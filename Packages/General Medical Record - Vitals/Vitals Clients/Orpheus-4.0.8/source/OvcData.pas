{*********************************************************}
{*                   OVCDATA.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcdata;
  {-Miscellaneous type and constant declarations}

interface

uses
  UITypes,
  Windows, Controls, Forms, Graphics, Messages, StdCtrls, SysUtils, OvcConst,
  OvcDate, O32SR;

const
  BorderStyles    : array[TBorderStyle] of Integer =
                    (0, WS_BORDER);
  ScrollBarStyles : array [UITypes.TScrollStyle] of Integer =
                    (0, WS_HSCROLL, WS_VSCROLL, WS_HSCROLL or WS_VSCROLL);

{some colors that are not defined by Delphi}
const
  clCream      = TColor($A6CAF0);
  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue    = TColor($FFFBF0);

type
  TCharSet = set of AnsiChar; {a Pascal set of characters}

type
  PPointer = ^Pointer;

type
  {secondary field options--internal}
  TsefOption = (
    sefValPending,      {field needs validation}
    sefInvalid,         {field is invalid}
    sefNoHighlight,     {Don't highlight field initially}
    sefIgnoreFocus,     {We're ignoring the focus}
    sefValidating,      {We're validating a field}
    sefModified,        {Field recently modified}
    sefEverModified,    {Field has been modified after last data transfer}
    sefFixSemiLits,     {Semi-literals were stripped}
    sefHexadecimal,     {Field's value is shown in hex}
    sefOctal,           {Field's value is shown in octal}
    sefBinary,          {Field's value is shown in binary}
    sefNumeric,         {Edit from right to left--for numbers only}
    sefRealVar,         {Field is of a real/8087 type}
    sefNoLiterals,      {Picture mask has no literals}
    sefHaveFocus,       {Control has the focus}
    sefRetainPos,       {Retain caret position}
    sefErrorPending,    {Error pending?}
    sefInsert,          {Insert mode on}
    sefLiteral,         {Next char is literal}
    sefAcceptChar,      {Accept next character}
    sefCharOK,          {OK to add a character}
    sefUpdating,        {field is being updated}
    sefGettingValue,    {field contents are being retrieved}
    sefUserValidating,  {user validation in progress}
    sefNoUserValidate); {don't perform user validation}

  {Set of current secondary options for entry fields}
  TsefOptionSet = set of TsefOption;

const
  {default secondary field options}
  sefDefOptions      : TsefOptionSet = [sefCharOK, sefInsert];

const
  DefPadChar         = ' '; {Default character used to pad the end of a display string}
  MaxEditLen         = 255; {Maximum length of edit string}
  MaxPicture         = 255; {Maximum length of a picture mask}

{*** Picture masks ***}
const
  {the following characters are meaningful in Picture masks}
  pmAnyChar     = 'X';         {allows any character}
  pmForceUpper  = '!';         {allows any character, forces upper case}
  pmForceLower  = 'L';         {allows any character, forces lower case}
  pmForceMixed  = 'x';         {allows any character, forces mixed case}
  pmAlpha       = 'a';         {allows alphas only}
  pmUpperAlpha  = 'A';         {allows alphas only, forces upper case}
  pmLowerAlpha  = 'l';         {allows alphas only, forces lower case}
  pmPositive    = '9';         {allows numbers and spaces only}
  pmWhole       = 'i';         {allows numbers, spaces, minus}
  pmDecimal     = '#';         {allows numbers, spaces, minus, period}
  pmScientific  = 'E';         {allows numbers, spaces, minus, period, 'e'}
  pmHexadecimal = 'K';         {allows 0-9, A-F, and space forces upper case}
  pmOctal       = 'O';         {allows 0-7, space}
  pmBinary      = 'b';         {allows 0-1, space}
  pmTrueFalse   = 'B';         {allows T, t, F, f}
  pmYesNo       = 'Y';         {allows Y, y, N, n}

  pmUser1       = '1';         {User-defined picture mask characters}
  pmUser2       = '2';
  pmUser3       = '3';
  pmUser4       = '4';
  pmUser5       = '5';
  pmUser6       = '6';
  pmUser7       = '7';
  pmUser8       = '8';

  Subst1        = #241;        {User-defined substitution characters}
  Subst2        = #242;
  Subst3        = #243;
  Subst4        = #244;
  Subst5        = #245;
  Subst6        = #246;
  Subst7        = #247;
  Subst8        = #248;

const
  {Other special characters allowed in Picture strings}
  pmDecimalPt   = '.';         {insert decimal point}
  pmComma       = ',';         {character used to separate numbers}
  pmFloatDollar = '$';         {floating dollar sign}
  pmCurrencyLt  = 'c';         {currency to left of the amount}
  pmCurrencyRt  = 'C';         {currency to right of the amount}
  pmNegParens   = 'p';         {indicates () should be used for negative #'s}
  pmNegHere     = 'g';         {placeholder for minus sign}
  {NOTE: Comma and FloatDollar are allowed only in fields containing fixed
   decimal points and/or numeric fields. NegParens and NegHere should be used
   only in numeric fields.}

const
  {the following characters are meaningful in date Picture masks}
  pmMonth  = 'm';  {formatting character for a date string picture mask}
  pmMonthU = 'M';  {formatting character for a date string picture mask.
                    Uppercase means pad with ' ' rather than '0'}
  pmDay    = 'd';  {formatting character for a date string picture mask}
  pmDayU   = 'D';  {formatting character for a date string picture mask.
                    Uppercase means pad with ' ' rather then '0'}
  pmYear   = 'y';  {formatting character for a date string picture mask}
  pmDateSlash  = '/';  {formatting character for a date string picture mask}

  {'n'/'N' may be used in place of 'm'/'M' when the name of the month is
   desired instead of its number. E.g., 'dd/nnn/yyyy' -\> '01-Jan-1980'.
   'dd/NNN/yyyy' -\> '01-JAN-1980' (if SlashChar = '-'). The abbreviation used
   is based on the width of the subfield (3 in the example) and the current
   contents of the MonthString array.}
  pmMonthName   = 'n';  {formatting character for a date string picture mask}
  pmMonthNameU  = 'N';  {formatting character for a date string picture mask.
                        Uppercase causes the output to be in uppercase}

  {'w'/'W' may be used to include the day of the week in a date string. E.g.,
  'www dd nnn yyyy' -\> 'Mon 01 Jan 1989'. The abbreviation used is based on
  the width of the subfield (3 in the example) and the current contents of the
  DayString array. Note that entry field will not allow the user to enter
  text into a subfield containing 'w' or 'W'. The day of the week will be
  supplied automatically when a valid date is entered.}
  pmWeekDay  = 'w';   {formatting character for a date string picture mask}
  pmWeekDayU = 'W';   {formatting character for a date string picture mask.
                       Uppercase causes the output to be in uppercase}

  pmLongDateSub1 = 'f';   {mask character used with Window's long date format}
  pmLongDateSub2 = 'g';   {mask character used with Window's long date format}
  pmLongDateSub3 = 'h';   {mask character used with Window's long date format}

const
  {if uppercase letters are used, numbers are padded with ' ' rather than '0'}
  pmHour     = 'h';   {formatting character for a time string picture mask}
  pmHourU    = 'H';   {formatting character for a time string picture mask}
  pmMinute   = 'm';   {formatting character for a time string picture mask}
  pmMinuteU  = 'M';   {formatting character for a time string picture mask}
  pmSecond   = 's';   {formatting character for a time string picture mask}
  pmSecondU  = 'S';   {formatting character for a time string picture mask}
  {'hh:mm:ss tt' -\> '12:00:00 pm', 'hh:mmt' -\> '12:00p'}
  pmAmPm      = 't';  {formatting character for a time string picture mask.
                      This generates 'AM' or 'PM'}
  pmTimeColon = ':';  {formatting character for a time string picture mask}

const
  PictureChars : TCharSet = [
    pmAnyChar, pmForceUpper, pmForceLower, pmForceMixed,
    pmAlpha, pmUpperAlpha, pmLowerAlpha,
    pmPositive, pmWhole, pmDecimal, pmScientific,
    pmHexadecimal, pmOctal, pmBinary,
    pmTrueFalse, pmYesNo,
    pmMonthName, pmMonthNameU, pmMonth,
    pmMonthU, pmDay, pmDayU, pmYear, pmHour, pmHourU, pmMinute,
    pmMinuteU, pmSecond, pmSecondU, pmAmPm, pmUser1..pmUser8];

const
  {set of allowable picture characters for simple fields}
  SimplePictureChars : TCharSet = [
    pmAnyChar, pmForceUpper, pmForceLower, pmForceMixed,
    pmAlpha, pmUpperAlpha, pmLowerAlpha,
    pmPositive, pmWhole, pmDecimal, pmScientific,
    pmHexadecimal, pmOctal, pmBinary,
    pmTrueFalse, pmYesNo,
    pmUser1..pmUser8];

type
  {types of case change operations associated with a picture mask character}
  TCaseChange = (mcNoChange, mcUpperCase, mcLowerCase, mcMixedCase);

type
  TUserSetRange   = pmUser1..pmUser8;
  TForceCaseRange = pmUser1..pmUser8;
  TSubstCharRange = Subst1..Subst8;

  TUserCharSets   = array[TUserSetRange] of TCharSet;
  TForceCase      = array[TForceCaseRange] of TCaseChange;
  TSubstChars     = array[TSubstCharRange] of Char;

const
  MaxDateLen     = 40;        {maximum length of date picture strings}
  MaxMonthName   = 15;        {maximum length for month names}
  MaxDayName     = 15;        {maximum length for day names}

const
  otf_SizeData = 0; {These three constants are used in data transfers to}
  otf_GetData  = 1; {specify the type of transfer operation being requested}
  otf_SetData  = 2;

type
  TEditString  = array[0..MaxEditLen] of Char;
  TPictureMask = array[0..MaxPicture] of Char;

  {An array of flags that indicate the type of mask character at a given
   location in a picture mask}
  TPictureFlags = array[0..MaxEditLen+1] of Byte;

  {Each entry field maintains two data structures of this type, one to store
   the lower limit of a field's value, and another to store the upper limit}
  PRangeType = ^TRangeType;
  TRangeType = packed record
    case Byte of                         {size}
    00 : (rtChar : Char);             {01/02}
    01 : (rtByte : Byte);                 {01}
    02 : (rtSht  : ShortInt);             {01}
    03 : (rtInt  : SmallInt);             {02}
    04 : (rtWord : Word);                 {02}
    05 : (rtLong : NativeInt);            {04}
    06 : (rtSgl  : Single);               {04}
    07 : (rtPtr  : Pointer);              {04}
     08 : (rtReal : Real);                 {06}
    09 : (rtDbl  : Double);               {08}
    10 : (rtComp : Comp);                 {08}
    11 : (rtExt  : Extended);             {10}
    12 : (rtDate : Integer);              {04}
    13 : (rtTime : Integer);              {04}
    14 : (rt10   : array[1..10] of Byte); {10} {forces structure to size of 10 bytes}
  end;

const
  BlankRange : TRangeType = (rt10 : (0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

{*** Date/Time declarations ***}
type
  TOvcDate  = TStDate;
  TOvcTime  = TStTime;
  TDayType = TStDayType;

type
  {states for data aware entry fields}
  TDbEntryFieldStates = (esFocused, esSelected, esReset);
  TDbEntryFieldState  = set of TDbEntryFieldStates;

type
  {Search option flags for editor and viewer}
  TSearchOptions = (
     soFind,        {find  (this option is assumed)        }
     soBackward,    {search backwards                      }
     soMatchCase,   {don't ignore case when searching      }
     soGlobal,      {search globally                       }
     soReplace,     {find and replace         (editor only)}
     soReplaceAll,  {find and replace all     (editor only)}
     soWholeWord,   {match on whole word only (editor only)}
     soSelText);    {search in selected text  (editor only)}
  TSearchOptionSet = set of TSearchOptions;

const
  {maximum length of a search/replacement string}
  MaxSearchString = 255;

type
  {types of tabs supported in the editor}
  TTabType   = (ttReal, ttFixed, ttSmart);

  {entry field flag for display of number field with zero value}
  TZeroDisplay = (zdShow, zdHide, zdHideUntilModified);

type
  {structrue of the commands stored in the command table}
  POvcCmdRec = ^TOvcCmdRec;
  TOvcCmdRec = packed record
    case Byte of
      0 : (Key1  : Byte;     {first keys' virtual key code}
           SS1   : Byte;     {shift state of first key}
           Key2  : Byte;     {second keys' virtual key code, if any}
           SS2   : Byte;     {shift state of second key}
           Cmd   : Word);    {command to return for this entry}
      1 : (Keys  : Integer); {used for sorting, searching, and storing}
  end;

const
  {shift state flags for command processors}
  ss_None     = $00; {no shift key is pressed}
  ss_Shift    = $02; {the shift key is pressed}
  ss_Ctrl     = $04; {the control key is pressed}
  ss_Alt      = $08; {the alt key is pressed}
  ss_Wordstar = $80; {2nd key of a twokey wordstar command: ss_Ctrl or ss_None}
    {the second key of a two-key wordstar command is accepted if}
    {pressed by itself of with the ctrl key. case is ignored}

const
  {virtual key constants not already defined}
  VK_NONE = 0;
  VK_ALT  = VK_MENU;
  VK_A = Ord('A');  VK_B = Ord('B');  VK_C = Ord('C'); VK_D = Ord('D');
  VK_E = Ord('E');  VK_F = Ord('F');  VK_G = Ord('G');  VK_H = Ord('H');
  VK_I = Ord('I');  VK_J = Ord('J');  VK_K = Ord('K');  VK_L = Ord('L');
  VK_M = Ord('M');  VK_N = Ord('N');  VK_O = Ord('O');  VK_P = Ord('P');
  VK_Q = Ord('Q');  VK_R = Ord('R');  VK_S = Ord('S');  VK_T = Ord('T');
  VK_U = Ord('U');  VK_V = Ord('V');  VK_W = Ord('W');  VK_X = Ord('X');
  VK_Y = Ord('Y');  VK_Z = Ord('Z');  VK_0 = Ord('0');  VK_1 = Ord('1');
  VK_2 = Ord('2');  VK_3 = Ord('3');  VK_4 = Ord('4');  VK_5 = Ord('5');
  VK_6 = Ord('6');  VK_7 = Ord('7');  VK_8 = Ord('8');  VK_9 = Ord('9');

var
  AlphaCharSet  : TCharSet;

const
  IntegerCharSet: TCharSet = ['0'..'9', ' '];
  RealCharSet   : TCharSet = ['0'..'9', ' ', '-', '.'];

const
  {Picture flag values for elements in a TPictureFlags array}
  pflagLiteral = 0;  {Corresponding char in the mask is a literal}
  pflagFormat  = 1;  {Corresponding char in the mask is a formatting character}
  pflagSemiLit = 2;  {Corresponding char in the mask is a semi-literal character}

const
  {------------------- Windows messages -----------------------}
  {Not a message code. Value of the first of the message codes used}
  OM_FIRST = $7F00; {***}

  {entry field error}
  OM_REPORTERROR         = OM_FIRST + 0;
    {messages for/from viewer/editor controls}
  OM_SETFOCUS            = OM_FIRST + 1;
    {sent by an entry field to the controller to request return of the
    focus. lParam is pointer of the object to return the focus to}
  OM_SHOWSTATUS          = OM_FIRST + 2;
    {sent by a viewer or editor control to itself when the caret moves, or
    when text is inserted or deleted. wParam is the current column (an
    effective column number), and lParam is the current line}
  OM_GETDATASIZE         = OM_FIRST + 3;
    {sent to an entry field to obtain its data size}
  OM_RECREATEWND         = OM_FIRST + 5;
    {sent to force a call to RecreateWnd}
  OM_PREEDIT             = OM_FIRST + 6;
    {sent to preform pre-edit notification for entry fields}
  OM_POSTEDIT            = OM_FIRST + 7;
    {sent to preform post-edit notification for entry fields}
  OM_AFTERENTER          = OM_FIRST + 8;
    {sent to preform after-enter notification}
  OM_AFTEREXIT           = OM_FIRST + 9;
    {sent to preform after-exit notification}
  OM_DELAYNOTIFY         = OM_FIRST + 10;
    {sent to preform delayed notification}
  OM_POSITIONLABEL       = OM_FIRST + 11;
    {sent to cause the label to be repositioned}
  OM_RECORDLABELPOSITION = OM_FIRST + 12;
    {sent to cause the current position of the label to be recorded}
  OM_ASSIGNLABEL         = OM_FIRST + 13;
    {sent to assign a albel to a control}
  OM_FONTUPDATEPREVIEW   = OM_FIRST + 14;
    {sent to postpone the font change of the preview control}
  OM_DESTROYHOOK         = OM_FIRST + 15;
    {send to cause the window hook to be destroyed}
  OM_PROPCHANGE          = OM_FIRST + 16;
    {sent by a collection to its property editor when a property is changed}
  OM_ISATTACHED          = OM_FIRST + 17;
    {sent to other controls to see if they are attached. Used by attached
     button components and components that use an internal validator.
     Result is Integer(Self) if true}
  OM_VALIDATE            = OM_FIRST + 18;
    {Sent to the FlexEdit as a call for it to Validate Itself}

{message crackers for the above Orpheus messages}

type
  TOMReportError = packed record
    Msg    : Cardinal;
    Error  : Word;
    Unused : Word;
    lParam : Integer;
    Result : Integer;
  end;

  TOMSetFocus = packed record
    Msg    : Cardinal;
    wParam : Integer;
    Control: TWinControl;
    Result : Integer;
  end;

  TOMShowStatus = packed record
    Msg    : Cardinal;
    Column : Integer;
    Line   : Integer;
    Result : Integer;
  end;


type
  TShowStatusEvent =
    procedure(Sender : TObject; LineNum : Integer; ColNum : Integer)
    of object;
    {-event to notify of a viewer or editor caret position change}

  TTopLineChangedEvent =
    procedure(Sender : TObject; Line : Integer)
    of object;
    {-event to notify when the top line changes for the editor or viewer}

const
  {*** Error message codes ***}
  oeFirst             = 256;

  oeRangeError        = oeFirst + 0;
    {This error occurs when a user enters a value that is not within the
    accepted range of values for the field}
  oeInvalidNumber     = oeFirst + 1;
    {This error is reported if the user enters a string that does not represent
    a number in a field that should contain a numeric value}
  oeRequiredField     = oeFirst + 2;
    {This error occurs when the user leaves blank a field that is marked as
    required}
  oeInvalidDate       = oeFirst + 3;
    {This error occurs when the user enters a value in a date field that does
    not represent a valid date}
  oeInvalidTime       = oeFirst + 4;
    {This error occurs when the user enters a value in a time field that does
    not represent a valid time of day}
  oeBlanksInField     = oeFirst + 5;
    {This error is reported only by the validation helper routines
    ValidateNoBlanks and ValidateSubfields. It indicates that a blank was left
    in a field or subfield in which no blanks are allowed}
  oePartialEntry      = oeFirst + 6;
    {This error is reported only by the validation helper routines
    ValidateNotPartial and ValidateSubfields in OODEWCC. It indicates that a
    partial entry was given in a field or subfield in which the field/subfield
    must be either entirely empty or entirely full}
  oeOutOfMemory       = oeFirst + 7;
    {This error is reported by a viewer or editor control when there is
    insufficient memory to perform the requested operation. A viewer control
    reports this error only when copying selected text to the clipboard}
  oeRegionSize        = oeFirst + 8;
    {This error is reported by an editor control when the user asks to
    copy selected text to the clipboard, and the selected region exceeds
    64K in size}
  oeTooManyParas      = oeFirst + 9;
    {This error is reported by an editor control when the limit on the number
    of paragraphs is reached, and the requested operation would cause it to be
    exceeded}
  oeCannotJoin        = oeFirst + 10;
    {This error is reported by an editor control when the user attempts to join
    two paragraphs that cannot be joined. Typically this occurs when joining
    the two paragraphs would cause the new paragraph to exceed its size limit}
  oeTooManyBytes      = oeFirst + 11;
    {This error is reported by an editor control when the limit on the total
    number of bytes is reached, and the requested operation would cause it to
    be exceeded}
  oeParaTooLong       = oeFirst + 12;
    {This error is reported by an editor control when the limit on the length
    of an individual paragraph is reached, and the requested operation would
    cause it to be exceeded}
  oeCustomError       = 32768;
    {the first error code reserved for user applications. All }
    {error values less than this value are reserved for use by}
    {Orpheus}

{*** Field class and type constant id's ***}

const
  {Field class codes}
  fcSimple     =  0;
  fcPicture    =  1;
  fcNumeric    =  2;

  {Field class divisor}
  fcpDivisor   = $40;

  {Field class prefixes}
  fcpSimple    = fcpDivisor*fcSimple;
  fcpPicture   = fcpDivisor*fcPicture;
  fcpNumeric   = fcpDivisor*fcNumeric;

  {Field type IDs for simple fields}
  fidSimpleString    = fcpSimple+fsubString;
  fidSimpleChar      = fcpSimple+fsubChar;
  fidSimpleBoolean   = fcpSimple+fsubBoolean;
  fidSimpleYesNo     = fcpSimple+fsubYesNo;
  fidSimpleLongInt   = fcpSimple+fsubLongInt;
  fidSimpleWord      = fcpSimple+fsubWord;
  fidSimpleInteger   = fcpSimple+fsubInteger;
  fidSimpleByte      = fcpSimple+fsubByte;
  fidSimpleShortInt  = fcpSimple+fsubShortInt;
  fidSimpleReal      = fcpSimple+fsubReal;
  fidSimpleExtended  = fcpSimple+fsubExtended;
  fidSimpleDouble    = fcpSimple+fsubDouble;
  fidSimpleSingle    = fcpSimple+fsubSingle;
  fidSimpleComp      = fcpSimple+fsubComp;

  {Field type IDs for picture fields}
  fidPictureString   = fcpPicture+fsubString;
  fidPictureChar     = fcpPicture+fsubChar;
  fidPictureBoolean  = fcpPicture+fsubBoolean;
  fidPictureYesNo    = fcpPicture+fsubYesNo;
  fidPictureLongInt  = fcpPicture+fsubLongInt;
  fidPictureWord     = fcpPicture+fsubWord;
  fidPictureInteger  = fcpPicture+fsubInteger;
  fidPictureByte     = fcpPicture+fsubByte;
  fidPictureShortInt = fcpPicture+fsubShortInt;
  fidPictureReal     = fcpPicture+fsubReal;
  fidPictureExtended = fcpPicture+fsubExtended;
  fidPictureDouble   = fcpPicture+fsubDouble;
  fidPictureSingle   = fcpPicture+fsubSingle;
  fidPictureComp     = fcpPicture+fsubComp;
  fidPictureDate     = fcpPicture+fsubDate;
  fidPictureTime     = fcpPicture+fsubTime;

  {Field type IDs for numeric fields}
  fidNumericLongInt  = fcpNumeric+fsubLongInt;
  fidNumericWord     = fcpNumeric+fsubWord;
  fidNumericInteger  = fcpNumeric+fsubInteger;
  fidNumericByte     = fcpNumeric+fsubByte;
  fidNumericShortInt = fcpNumeric+fsubShortInt;
  fidNumericReal     = fcpNumeric+fsubReal;
  fidNumericExtended = fcpNumeric+fsubExtended;
  fidNumericDouble   = fcpNumeric+fsubDouble;
  fidNumericSingle   = fcpNumeric+fsubSingle;
  fidNumericComp     = fcpNumeric+fsubComp;


function GetOrphStr(Index : Word) : string;
  {-return a string from our RCDATA string resource}

implementation

function GetOrphStr(Index : Word) : string;
begin
  Result := ResourceStrByNumber(Index);
  if Result = '' then
    Result := 'Unknown';
end;


procedure InitAlphaCharSet;
  {-Initialize AlphaOnlySet}
var
  C : AnsiChar;
begin
  AlphaCharSet  := ['A'..'Z', 'a'..'z', ' ', '-', '.', ','];
  for C := #128 to #255 do
    {ask windows what other characters are considered alphas}
    if IsCharAlphaA(C) then
      AlphaCharSet := AlphaCharSet + [C];
end;

initialization
  InitAlphaCharSet;

end.
