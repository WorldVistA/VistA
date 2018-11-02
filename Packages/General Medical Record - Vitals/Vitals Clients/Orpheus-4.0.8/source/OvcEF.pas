{*********************************************************}
{*                    OVCEF.PAS 4.08                     *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcef;
  {-Base entry field class}

interface

uses
  Windows, Classes, ClipBrd, Controls, Forms, Graphics, Menus, Messages,
  SysUtils, Variants,
  OvcBase, OvcCaret, OvcColor, OvcConst, OvcCmd, OvcData, OvcExcpt,
  OvcIntl, OvcMisc, OvcStr, OvcUser, OvcDate, OvcBordr,imm,dialogs;

type
  {user validation event}
  TUserValidationEvent =
    procedure(Sender : TObject; var ErrorCode : Word)
    of object;
  TValidationErrorEvent =
    procedure(Sender : TObject; ErrorCode : Word; ErrorMsg : string)
    of object;

  {options available to specific fields}
  TOvcEntryFieldOption = (efoArrowIncDec, efoCaretToEnd, efoForceInsert,
                          efoForceOvertype, efoInputRequired,
                          efoPasswordMode, efoReadOnly, efoRightAlign,
                          efoRightJustify, efoSoftValidation,
                          efoStripLiterals, efoTrimBlanks);

  TOvcEntryFieldOptions = set of TOvcEntryFieldOption;

const
  efDefOptions = [efoCaretToEnd, efoTrimBlanks];

type
  {combined color class}
  TOvcEfColors = class(TPersistent)
  protected {private}
    FDisabled  : TOvcColors;    {colors for disabled fields}
    FError     : TOvcColors;    {colors for invalid fields}
    FHighlight : TOvcColors;    {background and text highlight colors}
  public
    procedure Assign(Source : TPersistent); override;
    constructor Create; virtual;
    destructor  Destroy; override;
  published
    property Disabled : TOvcColors read FDisabled write FDisabled;
    property Error : TOvcColors read FError write FError;
    property Highlight : TOvcColors read FHighlight write FHighlight;
  end;

  {abstract entry field class}
  TOvcBaseEntryField = class(TOvcCustomControlEx)
  

  protected {private}
    {property instance variables}
    FAutoSize          : Boolean;      {size control when font changes}
    FBorders           : TOvcBorders;  {simple line borders}
    FBorderStyle       : TBorderStyle; {border around the edit field}
    FCtrlColor         : TColor;       {control character foreground color}
    FDecimalPlaces     : Byte;         {max decimal places, if no '.' in Picture}
    FEFColors          : TOvcEfColors; {entry field colors}
    FEpoch             : Integer;      {combined epoch year and cenury}
    FIntlSup           : TOvcIntlSup;  {international support object}
    FLastError         : Word;         {result of last validation}
    FMaxLength         : Word;         {maximum length of string}
    FOptions           : TOvcEntryFieldOptions;
    FPadChar           : Char;     {character used to pad end of string}
    FPasswordChar      : Char;     {character used in password mode}
    FTextMargin        : Integer;      {indent from left (right)}
    FUninitialized     : Boolean;      {the field isblanked out completely except when it has the focus}
    FUserData          : TOvcUserData; {field mask and data object}
    FZeroDisplay       : TZeroDisplay; {true to display an empty field}
    FZeroDisplayValue  : Double;       {value used by ZeroDisplay logic}

    {event variables}
    FOnChange          : TNotifyEvent;
    FOnError           : TValidationErrorEvent;
    FOnGetEpoch        : TGetEpochEvent;
    FOnUserCommand     : TUserCommandEvent;
    FOnUserValidation  : TUserValidationEvent;

    {internal variables}
    efCaret            : TOvcCaretPair;  {our carets}
    efDataSize         : Word;          {size of data type being edited}
    efDataType         : Byte;          {code indicating field type}
    efEditSt           : TEditString;   {the edit string}
    efFieldClass       : Byte;          {fcSimple, fcPicture, or fcNumeric}
    efHOffset          : Integer;       {horizontal scrolling offset}
    efHPos             : Integer;       {current position in field (column)}
    efPicLen           : Word;          {length of picture mask}
    efPicture          : TPictureMask;  {picture mask}
    efRangeHi          : TRangeType;    {high range for the field}
    efRangeLo          : TRangeType;    {low range for the field}
    efRightAlignActive : Boolean;       {true if right-align is in use}
    efSaveData         : Boolean;       {save data during create window}
    efSaveEdit         : PChar;     {saved copy of edit string}
    efSelStart         : Integer;       {start of highlighted selection}
    efSelEnd           : Integer;       {end of highlighted selection}
    efTopMargin        : Integer;       {margin above text}
    sefOptions         : TsefOptionSet; {secondary field options}

    {property methods}
    function GetAsBoolean : Boolean;
    function GetAsCents : Integer;
    function GetAsExtended : Extended;
    function GetAsFloat : Double;
    function GetAsInteger : Integer;
    function GetAsDateTime : TDateTime;
    function GetAsStDate : TStDate;
    function GetAsStTime : TStTime;
    function GetAsString : string;
    function GetAsVariant : Variant;
    function GetCurrentPos : Integer;
    function GetDataSize : Word;
    function GetDisplayString : string;
    function GetEditString : string;
    function GetEpoch : Integer;
    function GetEverModified : Boolean;
    function GetInsCaretType : TOvcCaret;
    function GetInsertMode : Boolean;
    function GetModified : Boolean;
    function GetOvrCaretType : TOvcCaret;
    function GetRangeHiStr : string;
    function GetRangeLoStr : string;
    function GetSelLength : Integer;
    function GetSelStart : Integer;
    function GetSelText : string;
    procedure SetAsBoolean(Value : Boolean);
    procedure SetAsCents(Value : Integer);
    procedure SetAsDateTime(Value : TDateTime);
    procedure SetAsExtended(Value : Extended);
    procedure SetAsFloat(Value : Double);
    procedure SetAsInteger(Value : Integer);
    procedure SetAsStDate(Value : TStDate);
    procedure SetAsStTime(Value : TStTime);
    procedure SetAsVariant(Value : Variant);
    procedure SetAutoSize(Value : Boolean); override;
    procedure SetBorderStyle(Value : TBorderStyle);
    procedure SetDecimalPlaces(Value : Byte);
    procedure SetEpoch(Value : Integer);
    procedure SetEverModified(Value : Boolean);
    procedure SetInsCaretType(const Value : TOvcCaret);
    procedure SetInsertMode(Value : Boolean);
    procedure SetIntlSupport(Value : TOvcIntlSup);
    procedure SetMaxLength(Value : Word);
    procedure SetModified(Value : Boolean);
    procedure SetOptions(Value : TOvcEntryFieldOptions);
    procedure SetOvrCaretType(const Value : TOvcCaret);
    procedure SetPadChar(Value : Char);
    procedure SetPasswordChar(Value : Char);
    procedure SetRangeLoStr(const Value : string);
    procedure SetRangeHiStr(const Value : string);
    procedure SetSelLength(Value : Integer);
    procedure SetSelStart(Value : Integer);
    procedure SetSelText(const Value : string);
    procedure SetTextMargin(Value : Integer);
    procedure SetUninitialized(Value : Boolean);
    procedure SetUserData(Value : TOvcUserData);
    procedure SetZeroDisplay(Value : TZeroDisplay);
    procedure SetZeroDisplayValue(Value : Double);

    {internal methods}
    procedure efBorderChanged(ABorder : TObject);
    procedure efCalcTopMargin;
    procedure efColorChanged(AColor : TObject);
    function  efGetTextExtent(S : PChar; Len : Integer) : Word;
    procedure efInitializeDataSize;
    function GetDefStrType: TVarType;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    function  efIsSibling(HW : TOvcHWnd{hWnd}) : Boolean;

    procedure efMoveFocus(C : TWinControl);
    procedure efPaintBorders;
    procedure efPerformEdit(var Msg : TMessage; Cmd : Word);
    procedure efPerformPreEditNotify(C : TWinControl);
    procedure efPerformPostEditNotify(C : TWinControl);
    procedure efReadRangeHi(Stream : TStream);
    procedure efReadRangeLo(Stream : TStream);
    function  efTransferPrim(DataPtr : Pointer; TransferFlag : Word) : Word;
    procedure efWriteRangeHi(Stream : TStream);
    procedure efWriteRangeLo(Stream : TStream);

    {VCL control methods}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMDialogChar(var Msg : TCMDialogChar);
      message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Msg : TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;

    {private message response methods}
  //CLC
    procedure ImeEnter;
    //procedure WMImeComposition(var Msg: TMessage); message WM_IME_COMPOSITION;
    procedure WMImeNotify(var Message: TMessage); message WM_IME_NOTIFY;

    procedure OMGetDataSize(var Msg : TMessage);
      message OM_GETDATASIZE;
    procedure OMReportError(var Msg : TOMReportError);
      message OM_REPORTERROR;

    {windows message response methods}
    procedure WMChar(var Msg : TWMChar);
      message WM_CHAR;
    procedure WMClear(var Msg : TWMClear);
      message WM_CLEAR;
    procedure WMCopy(var Msg : TWMCopy);
      message WM_COPY;
    procedure WMCut(var Msg : TWMCut);
      message WM_CUT;
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd);
      message WM_ERASEBKGND;
    procedure WMGetText(var Msg : TWMGetText);
      message WM_GETTEXT;
    procedure WMGetTextLength(var Msg : TWMGetTextLength);
      message WM_GETTEXTLENGTH;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMLButtonDblClk(var Msg : TWMLButtonDblClk);
      message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMMouseActivate(var Msg : TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure WMMouseMove(var Msg : TWMMouseMove);
      message WM_MOUSEMOVE;
    procedure WMPaste(var Msg : TWMPaste);
      message WM_PASTE;
    procedure WMRButtonUp(var Msg : TWMRButtonDown);
      message WM_RBUTTONUP;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMSetFont(var Msg : TWMSetFont);
      message WM_SETFONT;
    procedure WMSetText(var Msg : TWMSetText);
      message WM_SETTEXT;
    procedure WMSize(var Msg : TWMSize);
      message WM_SIZE;
    procedure WMSysKeyDown(var Msg : TWMSysKeyDown);
      message WM_SYSKEYDOWN;

    {edit control message methods}
    procedure EMGetModify(var Msg : TMessage);
      message EM_GETMODIFY;
    procedure EMGetSel(var Msg : TMessage);
      message EM_GETSEL;
    procedure EMSetModify(var Msg : TMessage);
      message EM_SETMODIFY;
    procedure EMSetSel(var Msg : TMessage);
      message EM_SETSEL;

  protected
    {VCL methods}
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure DefineProperties(Filer : TFiler);
      override;
    procedure Paint;
      override;

    {dynamic event wrappers}
    procedure DoOnChange;
      dynamic;
      {-perform notification of a change}
    procedure DoOnError(ErrorCode : Word; const ErrorMsg : string);
      dynamic;
      {-perform notification of an error}
    procedure DoOnUserCommand(Command : Word);
      dynamic;
      {-perform notification of a user command}
    procedure DoOnUserValidation(var ErrorCode : Word);
      dynamic;
      {-perform call to user validation event handler}

    procedure DoRestoreClick(Sender : TObject);
      dynamic;
    procedure DoCutClick(Sender : TObject);
      dynamic;
    procedure DoCopyClick(Sender : TObject);
      dynamic;
    procedure DoPasteClick(Sender : TObject);
      dynamic;
    procedure DoDeleteClick(Sender : TObject);
      dynamic;
    procedure DoSelectAllClick(Sender : TObject);
      dynamic;

    procedure efAdjustSize;
      dynamic;
      {-adjust the size of the control based on the current font}
    function efCanClose(DoValidation : Boolean) : Boolean;
      virtual;
      {-returns true if the field contents are valid}
    procedure efCaretToEnd;
      virtual;
      {-move the caret to the end of the field}
    procedure efCaretToStart;
      virtual;
      {-move the caret to the beginning of the field}
    procedure efChangeMask(Mask : PChar);
      dynamic;
      {-change the picture mask}
    function  efCharOK(PicChar : Char; var Ch : Char;
                     PrevCh : Char; Fix : Boolean) : Boolean;
      {-return True if Ch is in character set corresponding to PicChar}
    procedure efConditionalBeep;
      {-beep if pefBeepOnError option is active}
    procedure efCopyPrim;
      {-Primitive clipboard copy method}
    function efBinStr2Long(St : PChar; var L : NativeInt) : Boolean;
      {-convert a binary string to a Integer}
    function efCalcDataSize(St : PChar; MaxLen : Word) : Word;
      {-calculate data size of a string field with literal stripping option on}
    procedure efEdit(var Msg : TMessage; Cmd : Word);
      virtual; abstract;
      {-process the specified editing command}
    function  efEditBegin : Word;
      virtual;
      {-return offset of first editable position in field}
    function  efFieldIsEmpty : Boolean;
      virtual;
      {-return True if the field is empty}
    procedure efFieldModified;
      {-mark the field as modified; tell parent form it changed}
    procedure efFindCtrlChars(P : PChar; var ChCnt, CtCnt : Integer);
      {-find control caracters and return normal and control char counts}
    procedure efFixCase(PicChar : Char; var Ch : Char; PrevCh : Char);
      {-fix the case of Ch based on PicChar}
    function efGetDisplayString(Dest : PChar; Size : Word) : PChar;
      virtual;
      {-return the display string in Dest and a pointer as the result}
    function  efGetMousePos(MPos : Integer) : Integer;
      {-get the position of a mouse click}
    procedure efGetSampleDisplayData(T : PChar);
      dynamic;
      {-return sample data for the current field type}
    procedure efIncDecValue(Wrap : Boolean; Delta : Double);
      dynamic; abstract;
      {-increment field by Delta}
    function  efIsNumericType : Boolean;
      {-return True if field is of a numeric type}
    function  efIsReadOnly : Boolean;
      virtual;
      {-return True if field is read-only}
    procedure efLong2Str(P : PChar; L : Integer);
      {-convert a Integer to a string}
    procedure efMapControlChars(Dest, Src : PChar);
      {-copy from Src to Dest, mapping control characters to alph in process}
    procedure efMoveFocusToNextField;
      dynamic;
      {-give next field the focus}
    procedure efMoveFocusToPrevField;
      dynamic;
      {-give previous field the focus}
    function  efNthMaskChar(N : Word) : Char;
      {-return the N'th character in the picture mask. N is 0-based}
    function efOctStr2Long(St : PChar; var L : NativeInt) : Boolean;
      {-convert an octal string to a Integer}

{ - Hdc changed to TOvcHdc for BCB Compatibility }
    procedure efPaintPrim(DC : TOvcHDC{Hdc}; ARect : TRect; Offset : Integer);
      {-primitive routine to draw the entry field control}

    procedure efPerformRepaint(Modified : Boolean);
      {-flag the field as modified and redraw it}
    function  efPositionCaret(Adjust : Boolean) : Boolean;
      {-position the editing caret}
    function efRangeToStRange(const Value : TRangeType) : string;
      {-returns the range as a string}
    function efStRangeToRange(const Value : string; var R : TRangeType) : Boolean;
      {-converts a string range to a RangeType}
    procedure efRemoveBadOptions;
      virtual;
      {-remove inappropriate options for this field and data type}
    procedure efResetCaret;
      virtual;
      {-move the caret to the beginning or end of the field, as appropriate}
    procedure efSaveEditString;
      {-save a copy of the edit string}
    procedure efSetDefaultRange(FT : Byte);
      {-set the default range for the given field type}
    procedure efSetInitialValue;
      {-set the initial value of the field}
    function efStr2Long(P : PChar; var L : NativeInt) : Boolean;
      {-convert a string to a Integer}
    function efTransfer(DataPtr : Pointer; TransferFlag : Word) : Word;
      virtual;
      {-transfer data to/from the entry fields}
    function efValidateField : Word;
      virtual; abstract;
      {-validate contents of field; result is error code or 0}

    {virtual property methods}
    procedure efSetCaretPos(Value : Integer);
      virtual;
      {-set position of the caret within the field}
    procedure SetAsString(const Value : string);
      virtual;
      {-sets the field value to a String Value}
    procedure SetName(const Value : TComponentName);
      override;
      {-catch when component name is changed}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor  Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;


    procedure ClearContents;
      {-clear the contents of the entry field}
    procedure ClearSelection;
      {-erase the highlighted text}
    procedure CopyToClipboard;
      {-copies the highlighted text to the clipboard}
    procedure CutToClipboard;
      dynamic;
      {-performs a CopyToClipboard then deletes the highlighted text from the field}
    procedure DecreaseValue(Wrap : Boolean; Delta : Double);
      {-decrease the value of the field by Delta, wrapping if enabled}
    procedure Deselect;
      {-unhighlight any highlighted text}
    function FieldIsEmpty : Boolean;
      {-return True if the field is completely empty}
    function GetStrippedEditString : string;
      dynamic;
      {-return edit string stripped of literals and semi-literals}
    function GetValue(var Data) : Word;
      {-returns the current field value in Data. Result is 0 or error code}
    procedure IncreaseValue(Wrap : Boolean; Delta : Double);
      {-increase the value of the field by Delta, wrapping if enabled}
    function IsValid : Boolean;
      {-returns true if the field is not marked as invalid}
    procedure MergeWithPicture(const S : string);
      dynamic;
      {-combines S with the picture mask and updates the edit string}
    procedure MoveCaret(Delta : Integer);
      {-moves the caret to the right or left Value positions}
    procedure MoveCaretToEnd;
      {-move the caret to the end of the field}
    procedure MoveCaretToStart;
      {-move the caret to the beginning of the field}
    procedure PasteFromClipboard;
      dynamic;
      {-places the text content of the clipboard into the field}
    procedure ProcessCommand(Cmd, CharCode : Word);
      {-process the specified command}
    procedure ResetCaret;
      {-move the caret to the beginning or end of the field, as appropriate}
    procedure Restore;
      dynamic;
      {-restore the previous contents of the field}
    procedure SelectAll;
      {-selects the current edit text}
    procedure SetInitialValue;
      {-resets the field value to its initial value}
    procedure SetRangeHi(const Value : TRangeType);
      {-set the high range for this field}
    procedure SetRangeLo(const Value : TRangeType);
      {-set the low range for this field}
    procedure SetSelection(Start, Stop : Word);
      {-mark offsets Start..Stop as selected}
    procedure SetValue(const Data);
      {-changes the field's value to the value in Data}
    function ValidateContents(ReportError : Boolean) : Word;
      dynamic;
      {-performs field validation, returns error code, and conditionally reports error}
    function ValidateSelf : Boolean;
      {-performs field validation, returns true if no errors, and reports error}

    {public properties}
    property ParentColor default False;
    property AsBoolean : Boolean
      read GetAsBoolean write SetAsBoolean;
    property AsCents : Integer
      read GetAsCents write SetAsCents;
    property AsDateTime : TDateTime
      read GetAsDateTime write SetAsDateTime;
    property AsExtended : Extended
      read GetAsExtended write SetAsExtended;
    property AsFloat : Double
      read GetAsFloat write SetAsFloat;
    property AsInteger : Integer
      read GetAsInteger write SetAsInteger;
    property AsOvcDate : TOvcDate
      read GetAsStDate write SetAsStDate;
    property AsOvcTime : TOvcTime
      read GetAsStTime write SetAsStTime;
    property AsString : string
      read GetAsString write SetAsString;
    property AsVariant : Variant
      read GetAsVariant write SetAsVariant;
    property AsStDate : TStDate
      read GetAsStDate write SetAsStDate;
    property AsStTime : TStTime
      read GetAsStTime write SetAsStTime;
    property Font;
    property Canvas;
    property Color;
    property CurrentPos : Integer
      read GetCurrentPos write efSetCaretPos;
    property DataSize : Word
      read GetDataSize;
    property DisplayString : string
      read GetDisplayString;
    property EditString : string
      read GetEditString;
    property Epoch : Integer
      read GetEpoch write SetEpoch;
    property EverModified : Boolean
      read GetEverModified write SetEverModified;

  

    property InsertMode : Boolean
      read GetInsertMode write SetInsertMode;


    property IntlSupport : TOvcIntlSup
      read FIntlSup write SetIntlSupport;
    property LastError : Word
      read FLastError;
    property Modified : Boolean
      read GetModified write SetModified;
    property SelectionLength : Integer
      read GetSelLength write SetSelLength;
    property SelectionStart : Integer
      read GetSelStart write SetSelStart;
    property SelectedText : string
      read GetSelText write SetSelText;
    property Text : string
      read GetAsString write SetAsString;
    property UserData :  TOvcUserData
      read FUserData write SetUserData;

    {publishable properties}
            {revised}
    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;
    property AutoSize : Boolean
      read FAutoSize write SetAutoSize default True;
    property Borders : TOvcBorders
      read FBorders write FBorders;
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle default bsSingle;
    property CaretIns : TOvcCaret
      read GetInsCaretType write SetInsCaretType;
    property CaretOvr : TOvcCaret
      read GetOvrCaretType write SetOvrCaretType;
    property ControlCharColor : TColor
      read FCtrlColor write FCtrlColor;
    property DecimalPlaces : Byte
      read FDecimalPlaces write SetDecimalPlaces;
    property EFColors : TOvcEfColors
      read FEFColors write FEFColors;
    property MaxLength : Word
      read FMaxLength write SetMaxLength default 15;
    property Options : TOvcEntryFieldOptions
      read FOptions write SetOptions default efDefOptions;
    property PadChar : Char
      read FPadChar write SetPadChar default DefPadChar;
    property PasswordChar : Char
      read FPasswordChar write SetPasswordChar default '*';
    property RangeHi : string
      read GetRangeHiStr write SetRangeHiStr stored False;
    property RangeLo : string
      read GetRangeLoStr write SetRangeLoStr stored False;
    property TextMargin : Integer
      read FTextMargin write SetTextMargin default 2;
    property Uninitialized : Boolean
      read FUninitialized write SetUninitialized default False;
    property ZeroDisplay : TZeroDisplay
      read FZeroDisplay write SetZeroDisplay default zdShow;
    property ZeroDisplayValue : Double
      read FZeroDisplayValue write SetZeroDisplayValue;

    {events}
    property OnChange : TNotifyEvent
      read FOnChange write FOnChange;
    property OnError : TValidationErrorEvent
      read FOnError write FOnError;
    property OnGetEpoch : TGetEpochEvent
      read FOnGetEpoch write FOnGetEpoch;
    property OnUserCommand : TUserCommandEvent
      read FOnUserCommand write FOnUserCommand;
    property OnUserValidation : TUserValidationEvent
      read FOnUserValidation write FOnUserValidation;
  end;


implementation

uses
  Types;

{*** TOvcEfColors ***}

procedure TOvcEfColors.Assign(Source : TPersistent);
var
  C : TOvcEfColors absolute Source;
begin
  if (Source <> nil) and (Source is TOvcEfColors) then begin
    FDisabled.Assign(C.Disabled);
    FError.Assign(C.Error);
    FHighlight.Assign(C.Highlight);
  end else
    inherited Assign(Source);
end;

constructor TOvcEfColors.Create;
begin
  inherited Create;

  {create color objects and assign defaults}
  FDisabled := TOvcColors.Create(clGrayText, clWindow);
  FError := TOvcColors.Create(clBlack, clRed);
  FHighlight := TOvcColors.Create(clHighlightText, clHighlight);
end;

destructor  TOvcEfColors.Destroy;
begin
  {dispose of the color objects}
  FDisabled.Free;
  FError.Free;
  FHighlight.Free;

  inherited Destroy;
end;


{*** TOvcBaseEntryField ***}

//___________________CLCLCLCLCLCCLCLCLCLLCCLC_____________________
(*
procedure TOvcBaseEntryField.WMImeKeyDown(var Msg: TMessage);
begin
  Msg.Result := 0;
end;
*)


//problem efEdit( will try to handle the key as well - therefore ansi chars (a,b,c,1,2,3(from num keyboard), space..) becomes double
//Ime Composition window works ok once a none ansi char has been entered
//in conclusion - should only insert Char via WMImeComposition( if the IME window is open otherwise its done directly in the standard
//Orpheus editor - and thats also by far more convinient espc. for numbers....
//the ime EDITOR is not open if ime composition


procedure TOvcBaseEntryField.ImeEnter;
var IMEContext: HIMC;
begin
  IMEContext := ImmGetContext(Handle);
  try//http://archives.free.net.ph/message/20080421.014944.4d6ca4bd.fr.html
    ImmNotifyIME(IMEContext, NI_COMPOSITIONSTR, CPS_COMPLETE{PS_CANCEL},0);
  finally
    ImmReleaseContext(IMEContext, IMEContext);
  end;
end;
//søgeord: terminate ImeComposition
//http://www.iyonix.com/32bit/2205201-02.htm



(*
procedure TOvcBaseEntryField.WMImeComposition(var Msg: TMessage);
var IMEContext: HIMC;
    p: WideString;
    FImeCount: integer;
var AString:String;
begin
  if ImeMode <> imDisable then
  if (Msg.LParam and GCS_RESULTSTR) <> 0 then//Retrieve or update the string of the composition result.
  begin
    IMEContext := ImmGetContext(Handle);
    try
      FImeCount := ImmGetCompositionStringW(IMEContext, GCS_RESULTSTR, nil, 0) div 2;
      if FImeCount > 0 then
       begin
        SetLength(p, FImeCount);
        ImmGetCompositionStringW(IMEContext, GCS_RESULTSTR, PWideChar(p), FImeCount*2);

        if ANSIString(p) <> p then //comes from the above comments - not elegant but seems to work
        begin
          AString := StrPas(efEditSt);
          Insert(p, AString,efHPos+1);
          StrPCopy(efEditSt,AString);
          inc(efHPos,Length(p));
        end;
       end;
     //  p := '';
       //ImmSetCompositionStringW(IMEContext, SCS_SETSTR, PWideChar(p), 0,nil,0);
    finally
      ImmReleaseContext(Handle, IMEContext);
    end;
  end;
  inherited;
end;
*)
procedure TOvcBaseEntryField.WMImeNotify(var Message: TMessage);
var
  IMC: HIMC;
  LogFont: TLogFont;
begin
  if ImeMode <> imDisable then
  with Message do
  begin
    case WParam of
      IMN_SETOPENSTATUS:
        begin
          IMC := ImmGetContext(Handle);
          if IMC <> 0 then
          begin
            // need to tell the composition window what font we are using currently
            GetObject(Font.Handle, SizeOf(TLogFont), @LogFont);
            ImmSetCompositionFont(IMC, @LogFont);
            ImmReleaseContext(Handle, IMC);
          end;
          Message.Result := 0;
        end;
    else
      inherited;
    end;
  end;
end;

procedure TOvcBaseEntryField.ClearContents;
  {-erases the contents of the edit field}
var
  RO     : Boolean;
begin
  if HandleAllocated then begin
    RO := efoReadOnly in Options;  {store current read only state}
    Exclude(FOptions, efoReadOnly);

    {set the updating flag so OnChange doesn't get fired}
    Include(sefOptions, sefUpdating);
    SetWindowText(Handle, '');
    Exclude(sefOptions, sefUpdating);
    {restore previous state}
    if RO then
      Include(FOptions, efoReadOnly);
  end;
end;

procedure TOvcBaseEntryField.ClearSelection;
begin
  if HandleAllocated then
    Perform(WM_CLEAR, 0, 0);
end;

procedure TOvcBaseEntryField.CMCtl3DChanged(var Msg : TMessage);
begin
  if not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then begin
    RecreateWnd;
    if not (csLoading in ComponentState) then
      efAdjustSize;
  end;

  efCalcTopMargin;

  inherited;
end;

procedure TOvcBaseEntryField.CMDialogChar(var Msg : TCMDialogChar);
begin
  {see if this is an Alt-Backspace key sequence (Alt flag is bit 29}
  if (Msg.CharCode = VK_BACK) and (HiWord(Msg.KeyData) and $2000 <> 0) then
    {don't pass it on as a dialog character since we use it as}
    {the restore command by default}
    Msg.Result := 1;

  inherited;
end;

procedure TOvcBaseEntryField.CMEnabledChanged(var Msg : TMessage);
begin
  inherited;

  Repaint;
end;

procedure TOvcBaseEntryField.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  {efCalcTopMargin;}
  efAdjustSize; {adjust height based on font}
  efCalcTopMargin;

  if GetFocus = Handle then
    efPositionCaret(False);  {adjust caret for new font}
end;

procedure TOvcBaseEntryField.CopyToClipboard;
  {-copies the selected text to the clipboard}
begin
  if HandleAllocated then
    Perform(WM_COPY, 0, 0);
end;

constructor TOvcBaseEntryField.Create(AOwner : TComponent);
const
  CStyle = [csClickEvents, csCaptureMouse, csOpaque];
begin
  inherited Create(AOwner);

  if NewStyleControls then
    ControlStyle := ControlStyle + CStyle
  else
    ControlStyle := ControlStyle + CStyle + [csFramed];

  {create borders class and assign notifications}
  FBorders := TOvcBorders.Create;

  FBorders.LeftBorder.OnChange   := efBorderChanged;
  FBorders.RightBorder.OnChange  := efBorderChanged;
  FBorders.TopBorder.OnChange    := efBorderChanged;
  FBorders.BottomBorder.OnChange := efBorderChanged;


  Cursor             := crIBeam;
  Height             := 25;
  ParentColor        := False;
  Width              := 130;
  TabStop            := True;

  {defaults}
  FAutoSize          := True;
  FBorderStyle       := bsSingle;
  FCtrlColor         := clRed;
  FDecimalPlaces     := 0;
  FMaxLength         := 15;
  FOptions           := efDefOptions;
  FPadChar           := DefPadChar;
  FPasswordChar      := '*';
  FTextMargin        := 2;
  FUninitialized     := False;
  FZeroDisplay       := zdShow;
  FZeroDisplayValue  := 0;

  efRangeLo          := BlankRange;
  efRangeHi          := BlankRange;

  {default picture and field settings}
  efPicture[0]       := 'X';
  efPicture[1]       := #0;
  efPicLen           := 1;
  efFieldClass       := fcSimple;
  efDataType         := fidSimpleString;

  {assign default user data object}
  FUserData := OvcUserData;

  {assign default international support object}
  FIntlSup := OvcIntlSup;

  {create the caret class}
  efCaret := TOvcCaretPair.Create(Self);

  {init edit and save edit strings}
  FillChar(efEditSt, MaxEditLen * SizeOf(Char), #0);
  efSaveEdit := nil;

  {create colors class}
  FEFColors := TOvcEfColors.Create;

  {assign color change notification methods}
  FEFColors.FDisabled.OnColorChange := efColorChanged;
  FEFColors.FError.OnColorChange := efColorChanged;
  FEFColors.FHighlight.OnColorChange := efColorChanged;

  efCalcTopMargin;
end;


procedure TOvcBaseEntryField.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Integer(Params.Style) or BorderStyles[FBorderStyle];

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;

  {set picture length and check MaxLength}
  efPicLen := StrLen(efPicture);
  if FMaxLength = 0 then
    FMaxLength := efPicLen;

  {reset secondary options}
  sefOptions := sefDefOptions;
end;

procedure TOvcBaseEntryField.CreateWnd;
begin
  inherited CreateWnd;

  efHOffset    := 0;
  efHPos       := 0;
  efSelStart   := 0;
  efSelEnd     := 0;

  {set efDataSize for this field type}
  efInitializeDataSize;

  {if input is required then these fields must also be uninitialized}
  if efoInputRequired in Options then
    case efDataType mod fcpDivisor of
      fsubChar, fsubBoolean, fsubYesNo, fsubLongInt,
      fsubWord, fsubInteger, fsubByte, fsubShortInt,
      fsubReal, fsubExtended, fsubDouble, fsubSingle,
      fsubComp : Uninitialized := True;
    end;

  {is it a hex, binary, octal, and/or numeric field?}
  if StrScan(efPicture, pmHexadecimal) <> nil then
    Include(sefOptions, sefHexadecimal)
  else
    Exclude(sefOptions, sefHexadecimal);

  if StrScan(efPicture, pmBinary) <> nil then
    Include(sefOptions, sefBinary)
  else
    Exclude(sefOptions, sefBinary);

  if StrScan(efPicture, pmOctal) <> nil then
    Include(sefOptions, sefOctal)
  else
    Exclude(sefOptions, sefOctal);

  if efFieldClass = fcNumeric then
    Include(sefOptions, sefNumeric)
  else
    Exclude(sefOptions, sefNumeric);

  {assume no literals in mask}
  Include(sefOptions, sefNoLiterals);

  {reject bad options}
  efRemoveBadOptions;

  {set canvas font to selected font}
  Canvas.Font := Font;

  efAdjustSize; {adjust height based on font}
  efCalcTopMargin;

  efRightAlignActive := efoRightAlign in Options;
end;

procedure TOvcBaseEntryField.CutToClipboard;
  {-erases the selected text and places it in the clipboard}
begin
  if HandleAllocated then
    Perform(WM_CUT, 0, 0);
end;

procedure TOvcBaseEntryField.DefineProperties(Filer : TFiler);
var
  Save : Boolean;
begin
  inherited DefineProperties(Filer);

  Save := not (efDataType mod fcpDivisor in [fsubString, fsubBoolean, fsubYesNo]);

  Filer.DefineBinaryProperty('RangeHigh', efReadRangeHi, efWriteRangeHi, Save);
  Filer.DefineBinaryProperty('RangeLow', efReadRangeLo, efWriteRangeLo, Save);
end;

procedure TOvcBaseEntryField.DecreaseValue(Wrap : Boolean; Delta : Double);
  {-decrease the value of the field by Delta, wrapping if enabled}
begin
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
  efIncDecValue(Wrap, -Delta);
  SetSelection(0, 0);
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  Refresh;
end;

procedure TOvcBaseEntryField.Deselect;
  {-unhighlight any highlighted text}
begin
  SetSelection(0, 0);
end;

destructor TOvcBaseEntryField.Destroy;
var
  PF : TCustomForm;
begin
  if Focused then begin
    PF := GetParentForm(Self);
    PF.DefocusControl(Self, True);
  end;

  {dispose of the  caret object}
  efCaret.Free;

  {dispose of the color object}
  FEFColors.Free;

  {dispose the borders object}
  FBorders.Free;

  {dispose of the saved edit string}
  if efSaveEdit <> nil then
    StrDispose(efSaveEdit);

  inherited Destroy;
end;

procedure TOvcBaseEntryField.DoOnChange;
  {-perform notification of a change}
begin
  if Assigned(FOnChange) and not (sefUpdating in sefOptions) then
    FOnChange(Self);
end;

procedure TOvcBaseEntryField.DoOnError(ErrorCode : Word; const ErrorMsg : string);
begin
  if Assigned(FOnError) then
    FOnError(Self, ErrorCode, ErrorMsg)
  else
    Controller.DoOnError(Self, ErrorCode, ErrorMsg);
end;

procedure TOvcBaseEntryField.DoOnUserCommand(Command : Word);
  {-perform notification of a user command}
begin
  if Assigned(FOnUserCommand) then
    FOnUserCommand(Self, Command);
end;

procedure TOvcBaseEntryField.DoOnUserValidation(var ErrorCode : Word);
  {-perform call to user validation event handler}
begin
  if Assigned(FOnUserValidation) then
    if not (sefNoUserValidate in sefOptions) then
      FOnUserValidation(Self, ErrorCode);
end;

procedure TOvcBaseEntryField.DoRestoreClick(Sender : TObject);
begin
  Restore;
  efPositionCaret(True);
end;

procedure TOvcBaseEntryField.DoCutClick(Sender : TObject);
begin
  CutToClipboard
end;

procedure TOvcBaseEntryField.DoCopyClick(Sender : TObject);
begin
  CopyToClipboard;
end;

procedure TOvcBaseEntryField.DoPasteClick(Sender : TObject);
begin
  PasteFromClipboard;
end;

procedure TOvcBaseEntryField.DoDeleteClick(Sender : TObject);
begin
  ClearSelection;
end;

procedure TOvcBaseEntryField.DoSelectAllClick(Sender : TObject);
begin
  SelectAll;
end;

procedure TOvcBaseEntryField.efAdjustSize;
  {-adjust the height of the control based on the current font}
var
  DC         : hDC;
  SaveFont   : hFont;
  I          : Integer;
  SysMetrics : TTextMetric;
  Metrics    : TTextMetric;
begin
  if not FAutoSize then
    Exit;

  DC := GetDC(0);
  try
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;

  if NewStyleControls then begin
    if Ctl3D then
      I := 8
    else
      I := 6;
    I := GetSystemMetrics(SM_CYBORDER) * I;
  end else begin
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then
      I := Metrics.tmHeight;
    I := I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;

  Height := Metrics.tmHeight + I;

  {SetBounds may have turn this off, turn it back on}
  if not FAutoSize then
    FAutoSize := True;
end;

function TOvcBaseEntryField.efBinStr2Long(St : PChar; var L : NativeInt) : Boolean;
  {-convert a binary string to a Integer}
var
  BitNum  : Word;
  Len     : Word;
  LT      : Integer;
begin
  Result := False;
  Len := StrLen(St);
  BitNum := 0;
  LT := 0;
  while Len > 0 do begin
    Dec(Len);
    case St[Len] of
      '0' : {OK};
      '1' : if BitNum > 31 then
              Exit
            else
              Inc(LT, Integer(1) shl BitNum);
      else  Exit;
    end;
    Inc(BitNum);
  end;
  L := LT;
  Result := True;
end;

function TOvcBaseEntryField.efCalcDataSize(St : PChar; MaxLen : Word) : Word;
  {-calculate data size of a string field with literal stripping option on}
var
  I, L : Word;
begin
  I := 0;
  L := StrLen(St);
  while St^ <> #0 do begin
    if CharInSet(St^, PictureChars) then
      Inc(I)
    else case St^ of
      pmFloatDollar, pmComma : Inc(I);
    end;
    Inc(St);
  end;
  Result := I+(MaxLen-L)+1;
end;

function TOvcBaseEntryField.efCanClose(DoValidation : Boolean) : Boolean;
var
  SoftV  : Boolean;
begin
  Result := True;

  {don't do any of this if we're hidden or not enabled}
  if (not Visible) or (not Enabled) then
    Exit;

  HandleNeeded;

  {clear error flag}
  FLastError := 0;

  {check for empty/uninitialized required field}
  if (efoInputRequired in Options) and not efIsReadOnly then
    if efFieldIsEmpty or (Uninitialized and not (sefModified in sefOptions)) then
      FLastError := oeRequiredField;

  {ask the validation routine if there's an error}
  if FLastError = 0 then begin
    Include(sefOptions, sefValidating);
    FLastError := efValidateField;
    Exclude(sefOptions, sefValidating);
  end;

  if efHPos > Integer(StrLen(efEditSt)) then
    efHPos := Integer(StrLen(efEditSt));

  if FLastError = 0 then
    Exclude(sefOptions, sefInvalid)
  else begin
    if DoValidation and (efoSoftValidation in Options) then begin
      Include(sefOptions, sefInvalid);
      Result := True;  {say we can close, error is in FLastError}
      Exit;
    end else begin
      if (efoSoftValidation in Options) then
        Include(sefOptions, sefInvalid);

      {set flag to indicate that an error is pending}
      Include(sefOptions, sefErrorPending);

      {keep the caret where it is if we have the focus}
      if sefHaveFocus in sefOptions then
        Include(sefOptions, sefRetainPos);

      {force soft validation on}
      SoftV := efoSoftValidation in Options;
      Include(FOptions, efoSoftValidation);
      try
        {ask the parent form to give us back the focus}
        efMoveFocus(Self);

        {report the error}
        if not Controller.ErrorPending then
          PostMessage(Handle, om_ReportError, FLastError, 0);

        {set controller's error pending flag}
        Controller.ErrorPending := True;
      finally
        {restore old options}
        if SoftV then
          Include(FOptions, efoSoftValidation)
        else
          Exclude(FOptions, efoSoftValidation);
      end;
    end;
  end;

  Result := FLastError = 0;
end;

procedure TOvcBaseEntryField.efCaretToEnd;
  {-move the caret to the end of the field}
begin
  efHPos := StrLen(efEditSt);
end;

procedure TOvcBaseEntryField.efCaretToStart;
  {-move the caret to the beginning of the field}
begin
  efHPos := 0;
  efHOffset := 0;
end;

procedure TOvcBaseEntryField.efChangeMask(Mask : PChar);
  {-change the picture mask}
var
  BufS: string;                      //SZ Unicode
  Buf: array[0..MaxEditLen] of Word;
begin
  if (Mask <> nil) and (Mask^ <> #0) then begin
    if csLoading in ComponentState then begin
      {change the mask}
      StrLCopy(efPicture, Mask, MaxPicture);
      efPicLen := StrLen(efPicture);
    end else begin
      {save the current field value in tmp buffer}
      if efDataType mod fcpDivisor = fsubString then   //SZ
        efTransfer(@BufS, otf_GetData)                 //SZ
      else
        efTransfer(@Buf, otf_GetData);

      {change the mask}
      StrLCopy(efPicture, Mask, MaxPicture);
      efPicLen := StrLen(efPicture);

      {reset the field to its former value}
      if efDataType mod fcpDivisor = fsubString then //SZ
        efTransfer(@BufS, otf_SetData)               //SZ
      else                                           //SZ
        efTransfer(@Buf, otf_SetData);
    end;
  end;
end;

function TOvcBaseEntryField.efCharOK(PicChar : Char; var Ch : Char;
                            PrevCh : Char; Fix : Boolean) : Boolean;
  {-return True if Ch is in character set corresponding to PicChar}
begin
  if Ch = #0 then begin
    Result := False;
    Exit;
  end;

  if Fix then
    efFixCase(PicChar, Ch, PrevCh);

  {assume it's OK}
  Result := True;

  case PicChar of
    pmAnyChar, pmForceUpper, pmForceLower, pmForceMixed :
      ;
    pmMonthName, pmMonthNameU, pmAlpha, pmUpperAlpha, pmLowerAlpha :
      Result := IsCharAlpha(Ch) or CharInSet(Ch, AlphaCharSet);  //SZ: AlphaCharSet works only for ANSI characters; we need to check for [' ', '-', '.', ','] as well
    pmDecimal :
      Result := CharInSet(Ch, RealCharSet);
    pmWhole :
      Result := (Ch = '-') or CharInSet(Ch, IntegerCharSet);
    pmMonth, pmMonthU, pmDay, pmDayU, pmYear,
    pmHour, pmHourU, pmSecond, pmSecondU,
    pmPositive :
      Result := CharInSet(Ch, IntegerCharSet);
    pmHexadecimal :
      case Ch of
        'A'..'F' : ;
      else
        Result := CharInSet(Ch, IntegerCharSet);
      end;
    pmOctal :
      case Ch of
        '0'..'7', ' ' : ;
      else
        Result := False;
      end;
    pmBinary :
      case Ch of
        '0', '1', ' ' : ;
      else
        Result := False;
      end;
    pmAmPm : {};
    pmTrueFalse :
      Result := (Ch = FIntlSup.TrueChar) or (Ch = FIntlSup.FalseChar);
    pmYesNo :
      Result := (Ch = FIntlSup.YesChar) or (Ch = FIntlSup.NoChar);
    pmScientific :
      case Ch of
        '+', 'E' : ;
        else
          Result := CharInSet(Ch, RealCharSet);
      end;
    pmUser1..pmUser8 :
      Result := CharInSet(Ch, UserData.UserCharSet[PicChar]);
  end;
end;

procedure TOvcBaseEntryField.efConditionalBeep;
begin
  if (efoBeepOnError in Controller.EntryOptions) then
    MessageBeep(0);
end;

procedure TOvcBaseEntryField.efCopyPrim;
var
  Size : Word;
  H    : THandle;
  GP   : PChar;
  I    : Word;
  T    : TEditString;

begin
  Size := efSelEnd-efSelStart;
  if Size > 0 then begin
    {allocate global memory block}
    H := GlobalAlloc(GHND, (Size+1) * SizeOf(Char));
    if H = 0 then
      Exit;

    {copy selected text to global memory block}
    GP := GlobalLock(H);
    efGetDisplayString(T, MaxEditLen);
    StrStCopy(GP, T, efSelStart, Size);

    {remove control characters}
    for I := efSelStart to efSelEnd-1 do
      case efEditSt[I] of
        #1..#31 : GP[I-efSelStart] := efEditSt[I];
      end;

    GlobalUnlock(H);

    {give the handle to the clipboard}
    Clipboard.SetAsHandle(CF_UNICODETEXT, H);
  end;
end;

function TOvcBaseEntryField.efEditBegin : Word;
  {-return offset of first editable position in field}
begin
  Result := 0;
end;

function TOvcBaseEntryField.efFieldIsEmpty : Boolean;
  {-return True if the field is empty}
var
  P : PChar;
begin
  P := efEditSt;
  while P^ = ' ' do
    Inc(P);
  Result := (P^ = #0);
end;

procedure TOvcBaseEntryField.efFieldModified;
  {-mark the field as modified; call notify event}
begin
  Include(sefOptions, sefModified);
  Include(sefOptions, sefEverModified);
  DoOnChange;
end;

procedure TOvcBaseEntryField.efFindCtrlChars(P : PChar; var ChCnt, CtCnt : Integer);
  {-find control caracters and return normal and control char counts}
const
  Space = ' ';
var
  I : Integer;
begin
  ChCnt := 0;
  CtCnt := 0;
  I := 0;
  {count "normal" characters}
  while (I < Integer(StrLen(P))) and (P[I] >= Space) do begin
    Inc(ChCnt);
    Inc(I);
  end;
  {count "control" characters}
  while (I < Integer(StrLen(P))) and (P[I] < Space) do begin
    Inc(CtCnt);
    Inc(I);
  end;
end;

procedure TOvcBaseEntryField.efFixCase(PicChar : Char; var Ch : Char; PrevCh : Char);
  {-fix the case of Ch based on PicChar}
begin
  case PicChar of
    pmMonthNameU, pmForceUpper, pmUpperAlpha, pmTrueFalse,
    pmYesNo, pmScientific, pmHexadecimal :
      Ch := UpCaseChar(Ch);
    pmForceLower, pmLowerAlpha :
      Ch := LoCaseChar(Ch);
    pmForceMixed :
      case PrevCh of
        ' ', '-' :
          Ch := UpCaseChar(Ch);
      end;
    pmAmPm : ;
    pmUser1..pmUser8 :
      case UserData.ForceCase[PicChar] of
        mcUpperCase :
          Ch := UpCaseChar(Ch);
        mcLowerCase :
          Ch := LoCaseChar(Ch);
        mcMixedCase :
          case PrevCh of
            ' ', '-' :
              Ch := UpCaseChar(Ch);
          end;
      end;
  end;
end;

function TOvcBaseEntryField.efGetDisplayString(Dest : PChar; Size : Word) : PChar;
  {-return the display string in Dest and a pointer as the result}
var
  Len   : Word;
  Value : Double;
  Code  : Integer;
  I     : Integer;
  S     : string;
  pDest : PChar;
begin
  FillChar(Dest^, Size * SizeOf(Char), #0);
  efMapControlChars(Dest, efEditSt);

  {see if zero values should be displayed}
  if efIsNumericType and not (sefHaveFocus in sefOptions) then begin
    if (ZeroDisplay = zdHide) or
       ((ZeroDisplay = zdHideUntilModified) and not EverModified) then begin
      S := Trim(GetStrippedEditString);
      Val(S, Value, Code);
      if (Value = ZeroDisplayValue) and (Code = 0) then
      begin
        Len := StrLen(Dest);
        if Len > 0 then
        begin
          pDest := Dest;
          for I := 0 to Len - 1 do
          begin
            pDest^ := ' ';
            Inc(pDest);
          end;
        end;
//          FillChar(Dest^, Len * SizeOf(Char), ' ');
      end;
    end;
  end;

  Result := Dest;
end;

function TOvcBaseEntryField.efGetMousePos(MPos : Integer) : Integer;
  {-get the position of a mouse click}
var
  I       : Integer;
  Len     : Integer;
  Ex      : Integer;
  Pos     : Integer;
  S       : PChar;
  Metrics : TTextMetric;
  TmpSt   : TEditString;
  Done    : Boolean;
  SLen    : Integer;
  X       : Integer;
  LMargin : Integer;
begin
  LMargin := TextMargin;
  if (MPos < 0) and (efHOffset > 0) then begin
    GetTextMetrics(Canvas.Handle, Metrics);
    I := (Abs(MPos)+Metrics.tmAveCharWidth) div Metrics.tmAveCharWidth;
    Dec(efHOffset, I);
    if efHOffset < 0 then
      efHOffset := 0;
  end;

  {get a copy of the display string}
  efGetDisplayString(TmpSt, MaxEditLen);
  Len := StrLen(TmpSt);

  if efHOffset > Len then
    I := Len
  else
    I := efHOffset;
  S := @TmpSt[I];

  if efRightAlignActive then begin
    if (Assigned(FBorders)) then begin
      if (FBorders.RightBorder.Enabled) then
        LMargin := LMargin + FBorders.RightBorder.PenWidth;
    end;
    MPos := ClientWidth-LMargin-1-MPos;

    Pos := Len + 1;
    I := 0;
  end else begin
    if (Assigned(FBorders)) then begin
      if (FBorders.LeftBorder.Enabled) then
        LMargin := LMargin + FBorders.LeftBorder.PenWidth;
    end;
    MPos := MPos - LMargin+1;
    Pos := 0;
  end;

  repeat
    if efRightAlignActive then begin
      Dec(Pos);
      S := @TmpSt[Pos-1];
      SLen := Len - Pos + 1;
    end else begin
      Inc(Pos);
      SLen := Pos;
    end;
    Ex := efGetTextExtent(S, SLen);
    X := (efGetTextExtent(@S[SLen-1], 1) div 2);
    if efRightAlignActive then
      Done := (Ex+X > MPos) or (I+Pos < 1)
    else
      Done := (Ex-X > MPos) or (I+Pos > Len);
  until Done;

  Result := I+(Pos-1);
  if Result < 0 then
    Result := 0;

  if efRightAlignActive then begin
    if MPos < 1 then
      Result := I+Pos;
  end;
end;

procedure TOvcBaseEntryField.efGetSampleDisplayData(T : PChar);
  {-return sample data for the current field type}
var
  Buf : TEditString;
  I   : Integer;
begin
  {return the picture mask for the sample display data}
  StrLCopy(Buf, efPicture, MaxLength);
  if efFieldClass = fcSimple then begin
    for I := 1 to MaxLength-1 do
      Buf[I] := Buf[I-1];
    Buf[MaxLength] := #0;
  end;
  StrLCopy(T, Buf, MaxLength);
end;

function TOvcBaseEntryField.efGetTextExtent(S : PChar; Len : Integer) : Word;
var
  Size : TSize;
begin
  GetTextExtentPoint32(Canvas.Handle, S, Len, Size);
  Result := Size.cX;
end;



procedure TOvcBaseEntryField.efBorderChanged(ABorder : TObject);
begin
  if (FBorders.BottomBorder.Enabled) or
     (FBorders.LeftBorder.Enabled) or
     (FBorders.RightBorder.Enabled) or
     (FBorders.TopBorder.Enabled) then begin
    BorderStyle := bsNone;
    Ctl3D := False;
  end else begin
    BorderStyle := bsSingle;
    Ctl3D := True;
  end;
  RecreateWnd;
end;



procedure TOvcBaseEntryField.efCalcTopMargin;
begin
  if HandleAllocated then
    efTopMargin := GetTopTextMargin(Font, BorderStyle, Height, Ctl3D)
  else
    efTopMargin := 0;

  if (Assigned(FBorders)) then begin
    if (FBorders.TopBorder.Enabled) then
      efTopMargin := efTopMargin + FBorders.TopBorder.PenWidth;
  end;
end;

procedure TOvcBaseEntryField.efColorChanged(AColor : TObject);
begin
  Repaint;
end;

procedure TOvcBaseEntryField.efInitializeDataSize;
begin
  case efDataType mod fcpDivisor of
    fsubString   :
      begin
        efDataSize := (MaxLength+1) * SizeOf(Char);
        {handle special data size cases}
        if efDataType = fidPictureString then
            if (efoStripLiterals in Options) then
              efDataSize := efCalcDataSize(efPicture, MaxLength);
      end;

    fsubChar     : efDataSize := SizeOf(Char);
    fsubBoolean  : efDataSize := SizeOf(Boolean);
    fsubYesNo    : efDataSize := SizeOf(Boolean);
    fsubLongInt  : efDataSize := SizeOf(Integer);
    fsubWord     : efDataSize := SizeOf(Word);
    fsubInteger  : efDataSize := SizeOf(SmallInt);
    fsubByte     : efDataSize := SizeOf(Byte);
    fsubShortInt : efDataSize := SizeOf(ShortInt);
    fsubReal     : efDataSize := SizeOf(Real);
    fsubExtended : efDataSize := SizeOf(Extended);
    fsubDouble   : efDataSize := SizeOf(Double);
    fsubSingle   : efDataSize := SizeOf(Single);
    fsubComp     : efDataSize := SizeOf(Comp);
    fsubDate     : efDataSize := SizeOf(TStDate);
    fsubTime     : efDataSize := SizeOf(TStTime);
  else
    efDataSize := 0;
  end;
end;

function TOvcBaseEntryField.efIsNumericType : Boolean;
  {-return True if field is of a numeric type}
begin
  case efDataType mod fcpDivisor of
    fsubLongInt, fsubWord, fsubInteger, fsubByte,
    fsubShortInt, fsubReal, fsubExtended, fsubDouble,
    fsubSingle, fsubComp :
      Result := True;
    else
      Result := False;
  end;
end;

function  TOvcBaseEntryField.efIsReadOnly : Boolean;
  {-return True if field is read-only}
begin
  Result := efoReadOnly in Options;
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function TOvcBaseEntryField.efIsSibling(HW : TOvcHWnd{hWnd}) : Boolean;
  {-is the window HW one of our siblings}
var
  C : TWinControl;
  H : hWnd;
begin
  Result := False;
  if HW = 0 then
    Exit;

  C := FindControl(HW);

  {see if this window is a child of one of our siblings}
  if not Assigned(C) then begin
    H := GetParent(HW);
    if H > 0 then
      C := FindControl(H);
  end;

  if Assigned(C) then
    if (GetImmediateParentForm(C) = GetImmediateParentForm(Self)) then
      Result := True;
end;

procedure TOvcBaseEntryField.efLong2Str(P : PChar; L : Integer);
  {-convert a Integer to a string}
var
  W  : Word;
  S  : array[0..32] of Char;
  St : AnsiString;
begin
  W := efDataSize * 2;
  if sefHexadecimal in sefOptions then begin
    HexLPChar(S, L);
    if W < 8 then
      StrStDeletePrim(S, 0, 8-W);
  end else if sefOctal in sefOptions then begin
    OctalLPChar(S, L);
    if W < 8 then
      StrStDeletePrim(S, 0, 12-(W*2));
  end else if sefBinary in sefOptions then begin
    BinaryLPChar(S, L);
    if W < 8 then
      StrStDeletePrim(S, 0, 32-(W*4));
  end else if L = 0 then begin
    S[0] := '0';
    S[1] := #0;
  end else begin
    Str(L, St);
    StrPLCopy(S, string(St), Length(S) - 1);
  end;
  StrCopy(P, S);
end;

procedure TOvcBaseEntryField.efMapControlChars(Dest, Src : PChar);
  {-copy from Src to Dest, mapping control characters to alpha in process}
var
  I : Integer;
begin
  StrCopy(Dest, Src);
  if (StrLen(Dest) > 0) then begin
    for I := 0 to StrLen(Dest)-1 do
      if Dest[I] < ' ' then
        Dest[I] := Char(Word(Dest[I])+64);
  end;
end;

procedure TOvcBaseEntryField.efMoveFocus(C : TWinControl);
  {-ask the controller to move the focus to the specified control}
begin
  PostMessage(Controller.Handle, om_SetFocus, 0, NativeInt(C));
end;

procedure TOvcBaseEntryField.efMoveFocusToNextField;
  {-give next field the focus}
var
  PF : TForm;
begin
  PF := TForm(GetParentForm(Self));
  if not Assigned(PF) then
    Exit;

  PostMessage(PF.Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure TOvcBaseEntryField.efMoveFocusToPrevField;
  {-give previous field the focus}
var
  PF : TForm;
begin
  PF := TForm(GetParentForm(Self));
  if not Assigned(PF) then
    Exit;

  PostMessage(PF.Handle, WM_NEXTDLGCTL, 1, 0);
end;

function TOvcBaseEntryField.efNthMaskChar(N : Word) : Char;
  {-return the N'th character in the picture mask. N is 0-based}
begin
  if N >= efPicLen then
    Result := efPicture[efPicLen-1]
  else
    Result := efPicture[N];
end;

function TOvcBaseEntryField.efOctStr2Long(St : PChar; var L : NativeInt) : Boolean;
  {-convert an octal string to a Integer}
var
  I  : Word;
begin
  Result := True;
  L := 0;
  for I := 0 to StrLen(St)-1 do begin
    {are we going to loose any of the top 3 bits}
    if (L and $E0000000) <> 0 then
      Result := False;
    L := L shl 3;
    L := L or (Ord(St[I]) - Ord('0'));
  end;
end;

{ - Hdc changed to TOvcHdc for BCB Compatibility }
procedure TOvcBaseEntryField.efPaintPrim(DC : TOvcHdc{Hdc};
  ARect : TRect; Offset : Integer);
  {-primitive routine to draw the entry field control}
var
  X, Y      : Integer;
  ChCnt     : Integer;
  CtCnt     : Integer;
  HStart    : Integer;
  HEnd      : Integer;
  OldBKMode : Integer;
  RTC, HTC  : Integer;
  RBC, HBC  : Integer;
  CtlClr    : Integer;
  SA, SD    : PChar;
  T         : TEditString;
  LMargin   : Integer;
//  I         : Integer;

  procedure Display(Count : Word; TC, BC : Integer);
  begin
    if (Count <> 0) and (X < ARect.Right) then begin
      SetTextColor(DC, TC);
      SetBkColor(DC, BC);
      ExtTextOut(DC, X, Y, ETO_CLIPPED, @ARect, SD, Count, nil);
    end;

    if (Count <> 0) then begin
      {adjust X coordinate}
      Inc(X, efGetTextExtent(SD, Count));

      {advance string pointers}
      Inc(SD, Count);
      Inc(SA, Count);

      {adjust highlight indices}
      Dec(HStart, Count);
      if HStart < 0 then
        HStart := 0;
      Dec(HEnd, Count);
      if HEnd <= HStart then
        HEnd := 0;
    end;
  end;

  procedure DisplayPrim(Count : Word; TC, HC : Integer);
  var
    SubCnt : Word;
    Buf    : TEditString;
  begin
    if (Count > 0) and (efFieldClass = fcNumeric) then begin
      StrCopy(Buf, SD);

      {remove leading and trailing spaces}
      TrimAllSpacesPChar(Buf);
      SubCnt := StrLen(Buf);
      if HStart < HEnd then begin
        SetTextColor(DC, HTC);
        SetBkColor(DC, HBC)
      end else begin
        SetTextColor(DC, RTC);
        SetBkColor(DC, RBC);
      end;

      {set right alignment}
      SetTextAlign(DC, TA_RIGHT);


      {paint the text right aligned}
      ExtTextOut(DC, X, Y, ETO_CLIPPED, @ARect, Buf, SubCnt, nil);
      Exit;
    end;

    if (HStart = 0) and (HEnd > 0) then begin
      SubCnt := HEnd-HStart;
      if SubCnt > Count then
        SubCnt := Count;

      {highlighted chars}
      OldBKMode := SetBkMode(DC, OPAQUE);
      Display(SubCnt, HC, HBC);
      SetBkMode(DC, OldBkMode);
    end else begin
      if HStart > 0 then begin
        SubCnt := HStart;
        if SubCnt > Count then
          SubCnt := Count;
      end else
        SubCnt := Count;
      Display(SubCnt, TC, RBC);
    end;

    {do we need to recurse?}
    Dec(Count, SubCnt);
    if Count > 0 then
      DisplayPrim(Count, TC, HC);
  end;

begin
  {select the font into our painting DC}
  SelectObject(DC, Font.Handle);
  SetBkColor(DC, Graphics.ColorToRGB(Color));
  SetTextColor(DC, Graphics.ColorToRGB(Font.Color));

  {display samples of appropriate data while designing}
  if csDesigning in ComponentState then begin
    efGetSampleDisplayData(T);
    SD := @T[0];
  end else begin
    {get the display version of the string}
    efGetDisplayString(T, MaxEditLen);
    SD := @T[Offset];
  end;

  {point to the starting point of the string}
  SA := @efEditSt[Offset];

  {determine highlighted portion of the string}
  if not (sefHaveFocus in sefOptions) then begin
    HStart := 0;
    HEnd := 0;
  end else begin
    HStart := efSelStart-Offset;
    HEnd := efSelEnd-Offset;
    if HStart < 0 then
      HStart := 0;
    if HEnd <= HStart then
      HEnd := 0;
  end;

  {get text colors to use}
  if IsValid then begin
    RTC := GetTextColor(DC);
    RBC := GetBkColor(DC);
  end else begin
    RTC := Graphics.ColorToRGB(FEFColors.Error.TextColor);
    RBC := Graphics.ColorToRGB(FEFColors.Error.BackColor);
  end;

  {fill in the background}
  if not Enabled then
    Canvas.Brush.Color := FEFColors.Disabled.BackColor
  else if IsValid then
    Canvas.Brush.Color := Color
  else
    Canvas.Brush.Color := FEFColors.Error.BackColor;

  OldBkMode := SetBkMode(DC, TRANSPARENT);
  FillRect(DC, ARect, Canvas.Brush.Handle);
  SetBkMode(DC, OldBkMode);

  if csDesigning in ComponentState then begin
    {no highlights if we're designing}
    HStart := 0;
    HEnd := 0;
  end else if not Enabled then begin
    {no highlights}
    HStart := 0;
    HEnd := 0;
    RTC := Graphics.ColorToRGB(FEFColors.Disabled.TextColor);
    RBC := Graphics.ColorToRGB(FEFColors.Disabled.BackColor);
  end;

  if csDesigning in ComponentState then begin
    ChCnt := StrLen(T);
    CtCnt := 0;
  end else
    {count characters (use actual string, SA, not display string, SD)}
    efFindCtrlChars(SA, ChCnt, CtCnt);

  LMargin := FTextMargin;
  if (efFieldClass = fcNumeric) then begin
    if (Assigned(FBorders)) then begin
      if (FBorders.RightBorder.Enabled) then
        LMargin := LMargin + FBorders.RightBorder.PenWidth;
    end;
    X := ClientWidth-LMargin-1;

  end else begin
    efRightAlignActive := efoRightAlign in Options;
    if efRightAlignActive then begin
      if (Assigned(FBorders)) then begin
        if (FBorders.RightBorder.Enabled) then
          LMargin := LMargin + FBorders.RightBorder.PenWidth;
      end;
      X := efGetTextExtent(SD, StrLen(SD));
      if X >= ClientWidth-LMargin-1 then begin
(*
!!.04 - This is a classic bad idea. It royally messes stuff up.
        {the display string doesn't fit in the client area, so strip all    }
        {padding.                                                           }
        while SD[0] = PadChar do begin
          for I := 0 to Length(SD) - 1 do
            SD[i] := SD[i + 1];
        end;
        ChCnt := Length(SD);
        efRightAlignActive := False;
*)
        X := LMargin-1;
      end else
        X := ClientWidth-X-LMargin-1;
    end else begin
      if (Assigned(FBorders)) then begin
        if (FBorders.LeftBorder.Enabled) then
          LMargin := LMargin + Borders.LeftBorder.PenWidth;
      end;
(*
!!.04 - This is a classic bad idea. It royally messes stuff up.
      {the display string doesn't fit in the client area, so strip any      }
      {padding away so that the important stuff can show                    }
      X := efGetTextExtent(SD, StrLen(SD));
      if X >= ClientWidth-LMargin-1 then
      if efoTrimBlanks in Options then
        while SD[0] = PadChar do begin
          for I := 0 to Length(SD) - 1 do
            SD[i] := SD[i + 1];
        end;
      ChCnt := Length(SD);
*)
      X := LMargin-1;
    end;
  end;

  Y := efTopMargin;

  {convert TColor values to RGB values}
  CtlClr := Graphics.ColorToRGB(FCtrlColor);
  HTC := Graphics.ColorToRGB(FEFColors.Highlight.TextColor);
  HBC := Graphics.ColorToRGB(FEFColors.Highlight.BackColor);

  {display loop}
  while (ChCnt or CtCnt) <> 0 do begin
    {display regular characters}
    if ChCnt > 0 then
      DisplayPrim(ChCnt, RTC, HTC);

    {display control characters}
    if CtCnt > 0 then
      DisplayPrim(CtCnt, CtlClr, CtlClr);

    {check for more characters}
    if CtCnt = 0 then
      ChCnt := 0
    else
      efFindCtrlChars(SA, ChCnt, CtCnt);
  end;
end;

procedure TOvcBaseEntryField.efPerformEdit(var Msg : TMessage; Cmd : Word);
  {-process the specified editing command if appropriate}
begin
  HandleNeeded;
  if not HandleAllocated then
    Exit;

  {the null character implies that the this key should be}
  {ignored. the only way for the null character to get here}
  {is by changing a key after it has been entered , probably}
  {in a key preview event handler}
  if (Cmd = ccChar) and (Char(Msg.wParam) = #0) then
    Exit;

  {filter out commands that are inappropriate in read-only mode}
  if efIsReadOnly then begin
    case Cmd of
      ccChar, ccCtrlChar, ccRestore, ccBack, ccDel, ccDelEol,
      ccDelBol, ccDelLine, ccDelWord, ccCut, ccPaste,
      ccInc, ccDec :
        begin
          efConditionalBeep;
          Exit;
        end;
    end;
  end;

  {do user command notification for user commands}
  if Cmd >= ccUserFirst then begin
    DoOnUserCommand(Cmd);
    Cmd := ccSuppress;
  end;

  {allow descendant classes to perform edit processing}
  efEdit(Msg, Cmd);
end;

procedure TOvcBaseEntryField.efPerformRepaint(Modified : Boolean);
  {-flag the field as modified and redraw it}
begin
  if Modified then
    efFieldModified;
  Refresh;
end;

procedure TOvcBaseEntryField.efPerformPreEditNotify(C : TWinControl);
  {-pre-edit notification to parent form}
begin
  Controller.DoOnPreEdit(Self, C);
end;

procedure TOvcBaseEntryField.efPerformPostEditNotify(C : TWinControl);
  {-post-edit notification to parent form}
begin
  Controller.DoOnPostEdit(Self, C);
end;

function TOvcBaseEntryField.efPositionCaret(Adjust : Boolean) : Boolean;
  {-position the editing caret}
var
  Delta    : Word;
  S        : PChar;
  OK       : Boolean;
  Metrics  : TTextMetric;
  CW       : Integer;
  Pos      : TPoint;
  T        : TEditString;
  SLen     : Integer;
  LMargin  : Integer;
  RightBdr :Integer;
  R: TRect;
begin
  Result := False;
  if not (sefHaveFocus in sefOptions) then
    Exit;

  if Adjust then begin
  {when a character is entered that erases the existing text,
   efHPos may be 1 greater than EditBegin because of the
   entered character}
    if ((efHPos = efEditBegin) or (efHPos = efEditBegin+1)) and
       (efHOffset <> 0) then begin
      efHOffset := 0;
      Result := True;
    end else if (efHPos < efHOffset) then begin
      efHOffset := efHPos;
      Result := True;
    end;
  end;

  efGetDisplayString(T, MaxEditLen);

  efRightAlignActive := efoRightAlign in Options;
  if efRightAlignActive then begin
    Delta := efGetTextExtent(T, StrLen(T));
    if Delta >= ClientWidth-FTextMargin-1 then begin
      {the display string doesn't fit in the client area, it is displayed left aligned}
      efRightAlignActive := False;
    end else begin
      efRightAlignActive := True;
      efHOffset := 0;
    end;
  end;

  repeat
    if not efRightAlignActive then begin
      S := @T[efHOffset];
    end else begin
      S := @T[efHPos];
    end;

    SLen := StrLen(S);
    if (efHPos = efHOffset) and not efRightAlignActive then
      Delta := 0
    else begin
      if not efRightAlignActive then
        Delta := efGetTextExtent(S, efHPos-efHOffset)
      else
        Delta := efGetTextExtent(S, SLen);
    end;

    OK := (Delta < ClientWidth-FTextMargin-1) or
          (sefNumeric in sefOptions) or not Adjust;
    if not OK then begin
      if efHOffset >= efHPos then
        OK := True
      else begin
        Inc(efHOffset);
        Result := True;
      end;
    end;
  until OK;

  {get metrics for current font}
  GetTextMetrics(Canvas.Handle, Metrics);

  {get character width}
  CW := efGetTextExtent(@T[efHPos], 1);

  {set caret cell height and width}
  efCaret.CellHeight := Metrics.tmHeight;
  efCaret.CellWidth := CW;

  {adjust caret position if using a wide cursor}
  if (efCaret.CaretType.Shape in [csBlock, csHalfBlock, csHorzLine]) or
     (efCaret.CaretType.CaretWidth > 4) then
    if efRightAlignActive then
      Dec(Delta)
    else
      Inc(Delta);

  {set caret position}

  LMargin := FTextMargin;
  if (efFieldClass = fcNumeric) then begin
    if (Assigned(FBorders)) then begin
      if (FBorders.RightBorder.Enabled) then
        LMargin := LMargin + FBorders.RightBorder.PenWidth;
    end;
    Pos.X := ClientWidth-LMargin-1;
  end else begin
    if efRightAlignActive then begin
      if (Assigned(FBorders)) then begin
        if (FBorders.RightBorder.Enabled) then
          LMargin := LMargin + FBorders.RightBorder.PenWidth;
      end;
      Pos.X := ClientWidth - Succ(Delta) - LMargin - 1;
    end else begin
      if (Assigned(FBorders)) then begin
        if (FBorders.LeftBorder.Enabled) then
          LMargin := LMargin + FBorders.LeftBorder.PenWidth;
      end;
      Pos.X := Succ(Delta) + LMargin - 3;
    end;
  end;

  Pos.Y := efTopMargin;
  if Pos.Y < 0 then
    Pos.Y := 0;

  efCaret.Position := Pos;

  {$IF compilerversion >= 18} // Version 18 = Delphi 2006
  if AlignWithMargins then
  begin
    RightBdr := ClientWidth - Margins.Right;
    R := Rect(Margins.Left, Margins.Top, RightBdr + 1, ClientHeight - Margins.Bottom);
  end else
  {$IFEND}
  begin
    RightBdr := ClientWidth;
    R := Rect(0, 0, RightBdr + 1, ClientHeight);
  end;

  SendMessage(Handle, EM_SETRECTNP, 0, NativeInt(@R));   //SZ: According to the Windows SDK, this is only processed by multi line edits. Why do we need it here? It was introduced with the IME changes
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  if SysLocale.FarEast {and (IMEMode <> imDisable)} then
    SetImeCompositionWindow(Font, efCaret.Position.X,efCaret.Position.Y);
end;

function TOvcBaseEntryField.efRangeToStRange(const Value : TRangeType) : string;
  {-returns the range as a string}
var
  D        : Byte;
  Ex       : Extended;
  Buf      : TEditString;
  DateMask : string;
  TimeMask : string;
  sAnsi    : AnsiString;

  function GetDecimalPlaces : Byte;
  var
    I      : Cardinal;
    DotPos : Cardinal;
  begin
    if not StrChPos(efPicture, pmDecimalPt, DotPos) then
      Result := DecimalPlaces
    else begin
      Result := 0;
      for I := DotPos+1 to MaxLength-1 do
        if CharInSet(efNthMaskChar(I), PictureChars) then
          Inc(Result)
        else
          Break;
    end;
  end;

  function ExtendedToString(E : Extended; DP : Byte) : string;
  {-Changes
    03/2012, AB: Workaround for a bug in System.Str in Delphi XE2: Negative values can
                 cause 'Str' to crash. }
  label
    UseScientificNotation;
  var
    I : Cardinal;
    S : string;
    sAnsi: AnsiString;
    neg: Boolean;
  begin
    { workaround: Str might crash in Delphi XE2 if E<0... }
    neg := E<0;
    if neg then E := -E;

    if StrScan(efPicture, pmScientific) <> nil then
      goto UseScientificNotation;

    {try to use regular notation
     remark: Str(E:0:DP, S) migth result in scientific notation anyway... }
    Str(E:0:DP, sAnsi);
    S := Trim(string(sAnsi));
    { restore sign }
    if neg then S := '-' + S;

    {trim trailing 0's if appropriate}
    if Pos(pmScientific,S)=0 then begin
      if Pos(pmDecimalPt,S)>0 then
        S := TrimTrailingZeros(S);
    end else
      S := TrimEmbeddedZeros(S);

    {does it fit?}
    if Length(S) > MaxLength then begin
      {won't fit--use scientific notation}
  UseScientificNotation:
      if (DP > 0) and (9+DP < MaxLength) then
        Str(E:9+DP, sAnsi)
      else
        Str(E:MaxLength, sAnsi);
      S := Trim(string(sAnsi));
      if neg then S := '-' + S;
      S := TrimEmbeddedZeros(S);
    end;

    {convert decimal point}
    I := Pos(pmDecimalPt, S);
    if I > 0 then
      S[I] := IntlSupport.DecimalChar;

    result := S;
  end;

begin
  Result := '';
  D := GetDecimalPlaces;
  case efDataType mod fcpDivisor of
    fsubString : {};
    fsubBoolean, fsubYesNo : {};
    fsubChar :
      if Value.rtChar <= ' ' then begin
        Str(Ord(Value.rtChar), sAnsi);
        Result := '#' + string(sAnsi);
      end else
         Result := Value.rtChar;
    fsubLongInt, fsubInteger, fsubShortInt, fsubWord, fsubByte :
      begin
        efLong2Str(Buf, Value.rtLong);
        Result := StrPas(Buf);
      end;
    fsubReal :
      begin
        Ex := Value.rtReal;
        Result := ExtendedToString(Ex, D);
      end;
    fsubExtended, fsubDouble, fsubSingle, fsubComp :
      Result := ExtendedToString(Value.rtExt, D);
    fsubDate :
      begin
        DateMask := OvcIntlSup.InternationalDate(True);
        if Value.rtDate = BadDate then
          Result := ''
        else
          Result := OvcIntlSup.DateToDateString(DateMask, Value.rtDate, False);
      end;
    fsubTime      :
      begin
        TimeMask := OvcIntlSup.InternationalTime(False);
        if Value.rtTime = BadTime then
          Result := ''
        else
          Result := OvcIntlSup.TimeToTimeString(TimeMask, Value.rtTime, False);
      end;
  end;
end;

procedure TOvcBaseEntryField.efRemoveBadOptions;
  {-remove inappropriate options for this field and data type}
begin
  if csLoading in ComponentState then
    Exit;

  case efFieldClass of
    fcSimple :
      case efDataType mod fcpDivisor of
        fsubString :
          begin
            Exclude(FOptions, efoRightJustify);
            Exclude(FOptions, efoStripLiterals);
          end;
        fsubChar, fsubBoolean, fsubYesNo :
          begin
            Exclude(FOptions, efoCaretToEnd);
            Exclude(FOptions, efoForceInsert);
            Exclude(FOptions, efoTrimBlanks);
            Exclude(FOptions, efoRightJustify);
            Exclude(FOptions, efoStripLiterals);
          end;
        fsubLongInt, fsubWord, fsubInteger, fsubByte,
        fsubShortInt, fsubReal, fsubExtended, fsubDouble,
        fsubSingle, fsubComp :
          begin
            Exclude(FOptions, efoTrimBlanks);
            Exclude(FOptions, efoRightJustify);
            Exclude(FOptions, efoStripLiterals);
          end;
      end;
    fcPicture :
      case efDataType mod fcpDivisor of
        fsubString : {};
        fsubChar, fsubBoolean, fsubYesNo :
          begin
            Exclude(FOptions, efoCaretToEnd);
            Exclude(FOptions, efoForceInsert);
            Exclude(FOptions, efoTrimBlanks);
            Exclude(FOptions, efoRightJustify);
            Exclude(FOptions, efoStripLiterals);
          end;
        fsubLongInt, fsubWord, fsubInteger, fsubByte,
        fsubShortInt, fsubReal, fsubExtended, fsubDouble,
        fsubSingle, fsubComp :
          begin
            Exclude(FOptions, efoTrimBlanks);
            Exclude(FOptions, efoStripLiterals);
          end;
        fsubDate, fsubTime :
          begin
            Exclude(FOptions, efoTrimBlanks);
            Exclude(FOptions, efoRightJustify);
            Exclude(FOptions, efoStripLiterals);
          end;
      end;
    fcNumeric :
      begin
        Exclude(FOptions, efoCaretToEnd);
        Exclude(FOptions, efoForceInsert);
        Exclude(FOptions, efoTrimBlanks);
        Exclude(FOptions, efoRightJustify);
        Exclude(FOptions, efoStripLiterals);
        Exclude(FOptions, efoRightAlign);
      end;
  end;

  {if input is required then these fields must also be uninitialized}
  if (csDesigning in ComponentState) and (efoInputRequired in Options) then
    case efDataType mod fcpDivisor of
      fsubChar, fsubBoolean, fsubYesNo, fsubLongInt,
      fsubWord, fsubInteger, fsubByte, fsubShortInt,
      fsubReal, fsubExtended, fsubDouble, fsubSingle,
      fsubComp : FUninitialized := True;
    end;
end;

procedure TOvcBaseEntryField.efResetCaret;
  {-move the caret to the beginning or end of the field, as appropriate}
begin
  if (efoCaretToEnd in FOptions) then
    efCaretToEnd
  else
    efCaretToStart;
end;

procedure TOvcBaseEntryField.efSaveEditString;
  {-save a copy of the edit string}
begin
  if (efSaveEdit = nil) or (StrLen(efEditSt) <> StrLen(efSaveEdit)) then begin
    if efSaveEdit <> nil then
      StrDispose(efSaveEdit);
    efSaveEdit := StrNew(efEditSt);
  end else
    StrCopy(efSaveEdit, efEditSt);
end;

procedure TOvcBaseEntryField.efSetCaretPos(Value : Integer);
  {-set position of caret within the field}
begin
  if not (sefHaveFocus in sefOptions) then
    Exit;

  if Value < 0 then
      efHPos := 0
  else if Value > Integer(StrLen(efEditSt)) then
    efHPos := StrLen(efEditSt)+1
  else
    efHPos := Value;
  efPositionCaret(True);
end;

procedure TOvcBaseEntryField.efSetDefaultRange(FT : Byte);
  {-set the default range for the given field type FT}
begin
  efRangeLo := BlankRange;
  efRangeHi := BlankRange;
  case FT mod fcpDivisor of
    fsubString : {};
    fsubBoolean, fsubYesNo : {};
    fsubChar :
      begin
        efRangeLo.rtChar := #32;
        efRangeHi.rtChar := #32;
      end;
    fsubLongInt :
      begin
        efRangeLo.rtLong := Low(Integer); {80000000}
        efRangeHi.rtLong := High(Integer); {7FFFFFFF}
      end;
    fsubWord :
      begin
        efRangeLo.rtLong := Low(Word); {0}
        efRangeHi.rtLong := High(Word); {65535}
      end;
    fsubInteger :
      begin
        efRangeLo.rtLong := Low(SmallInt); {-32768}
        efRangeHi.rtLong := High(SmallInt); {+32767}
      end;
    fsubByte :
      begin
        efRangeLo.rtLong := Low(Byte); {0}
        efRangeHi.rtLong := High(Byte); {255}
      end;
    fsubShortInt :
      begin
        efRangeLo.rtLong := Low(ShortInt); {-128}
        efRangeHi.rtLong := High(ShortInt); {127}
      end;
    fsubReal :
      begin
        efRangeLo.rtReal := -1.7e+38;
        efRangeHi.rtReal := +1.7e+38;
      end;
{$IFNDEF WIN64}
    fsubExtended :
      begin
        efRangeLo.rtExt := -1.1e+4932;
        efRangeHi.rtExt := +1.1e+4932;
      end;
{$ELSE}
    fsubExtended,
{$ENDIF}
    fsubDouble :
      begin
        efRangeLo.rtExt := -1.7e+308;
        efRangeHi.rtExt := +1.7e+308;
      end;
    fsubSingle :
      begin
        efRangeLo.rtExt := -3.4e+38;
        efRangeHi.rtExt := +3.4e+38;
      end;
    fsubComp :
      begin
        efRangeLo.rtExt := -9.2e+18;
        efRangeHi.rtExt := +9.2e+18;
      end;
    fsubDate :
      begin
        efRangeLo.rtDate := MinDate;
        efRangeHi.rtDate := MaxDate;
      end;
    fsubTime :
      begin
        efRangeLo.rtTime := MinTime;
        efRangeHi.rtTime := MaxTime;
      end;
  end;
end;

procedure TOvcBaseEntryField.efSetInitialValue;
  {-set the initial value of the field}
var
  R   : TRangeType;
  FST : Byte;
begin
  if csDesigning in ComponentState then
    Exit;

  R := BlankRange;
  FST := efDataType mod fcpDivisor;
  case FST of
    fsubChar :
      if (' ' >= efRangeLo.rtChar) and (' ' <= efRangeHi.rtChar) then
        R.rtChar := ' '
      else
        R.rtChar := efRangeLo.rtChar;
    fsubLongInt, fsubWord, fsubInteger, fsubByte, fsubShortInt :
      if (0 < efRangeLo.rtLong) or (0 > efRangeHi.rtLong) then
        R.rtLong := efRangeLo.rtLong;
    fsubReal :
      if (0 < efRangeLo.rtReal) or (0 > efRangeHi.rtReal) then
        R.rtReal := efRangeLo.rtReal;
    fsubExtended, fsubDouble, fsubSingle, fsubComp :
      if (0 < efRangeLo.rtExt) or (0 > efRangeHi.rtExt) then
        case FST of
          fsubExtended : R.rtExt  := efRangeLo.rtExt;
          fsubDouble   : R.rtDbl  := efRangeLo.rtExt;
          fsubSingle   : R.rtSgl  := efRangeLo.rtExt;
          fsubComp     : R.rtComp := efRangeLo.rtExt;
        end;
    fsubDate : R.rtDate := BadDate;
    fsubTime : R.rtTime := BadTime;
  end;
  efTransfer(@R, otf_SetData);
end;

procedure TOvcBaseEntryField.SetName(const Value : TComponentName);
begin
  inherited SetName(Value);

  Repaint;
end;

procedure TOvcBaseEntryField.SetSelection(Start, Stop : Word);
  {-mark offsets Start..Stop as selected}
var
  Len : Word;
begin
  if Start <= Stop then begin
    Len := StrLen(efEditSt);

    if Start > Len then
      Start := Len;
    if Stop > Len then
      Stop := Len;

    {all or nothing for numeric fields}
    if (efFieldClass = fcNumeric) then
      if (Start <> Stop) then begin
        Start := 0;
        Stop := MaxEditLen;
      end;

    efSelStart := Start;
    efSelEnd := Stop;
  end;
end;

function TOvcBaseEntryField.efStr2Long(P : PChar; var L : NativeInt) : Boolean;
  {-convert a string to a long integer}
var
  S : TEditString;
begin
  Result := True;
  StrCopy(S, P);
  TrimAllSpacesPChar(S);

  {treat an empty string as 0}
  if StrLen(S) = 0 then begin
    L := 0;
    Exit;
  end;

  if sefBinary in sefOptions then
    Result := efBinStr2Long(S, L)
  else if sefOctal in sefOptions then
    Result := efOctStr2Long(S, L)
  else begin
    if (sefHexadecimal in sefOptions) and (S[0] <> #0) then
      if StrPos(S, '$') = nil then
        StrChInsertPrim(S, '$', 0);

    {check for special value the Val() doesn't handle correctly}
    if StrComp(S, '-2147483648') = 0 then
      L := Integer($80000000)
    else
      Result := StrToLongPChar(S, L);
  end;
end;

function TOvcBaseEntryField.efStRangeToRange(const Value : string; var R : TRangeType) : Boolean;
  {-converts a string range to a RangeType}
var
  I        : Integer;
  Code     : Integer;
  fSub     : Byte;
  Buf      : TEditString;
  DateMask : string;
  TimeMask : string;
begin
  Code := 0;  {assume success}
  R := BlankRange;
  fSub := efDataType mod fcpDivisor;
  case fSub of
    fsubString : {};
    fsubBoolean, fsubYesNo : {};
    fsubChar :
      if Value = '' then
        R.rtChar := #32
      else if Value[1] = '#' then begin
        Val(Copy(Value, 2, 3), I, Code);
        if Code = 0 then
          R.rtChar := Char(I)
        else begin
          Code := 0;
          R.rtChar := #32;
        end;
      end else
        R.rtChar := Char(Value[1]);
    fsubLongInt, fsubWord, fsubInteger, fsubByte, fsubShortInt :
      begin
        StrPLCopy(Buf, Value, Length(Buf) - 1);
        if not efStr2Long(Buf, R.rtLong) then
          Code := 1
        else if (fSub = fsubWord) and
          ((R.rtLong < Low(Word)) or (R.rtLong > High(Word))) then
          Code := 1
        else if (fSub = fsubInteger) and
          ((R.rtLong < Low(SmallInt)) or (R.rtLong > High(SmallInt))) then
          Code := 1
        else if (fSub = fsubByte) and
          ((R.rtLong < Low(Byte)) or (R.rtLong > High(Byte))) then
          Code := 1
        else if (fSub = fsubShortInt) and
          ((R.rtLong < Low(ShortInt)) or (R.rtLong > High(ShortInt))) then
          Code := 1;
      end;
    fsubReal :
      if Value = '' then
        R.rtReal := 0
      else
        Val(Value, R.rtReal, Code);
    fsubExtended, fsubDouble, fsubSingle, fsubComp :
      begin
        if Value = '' then
          R.rtExt := 0
        else
          Val(Value, R.rtExt, Code);
        if (Code = 0) then begin
          if (fSub = fsubDouble) and ((R.rtExt < -1.7e+308) or (R.rtExt > +1.7e+308)) then
            Code := 1
          else if (fSub = fsubSingle) and ((R.rtExt < -3.4e+38) or (R.rtExt > +3.4e+38)) then
            Code := 1
          else if (fSub = fsubComp) and ((R.rtExt < -9.2e+18) or (R.rtExt > +9.2e+18)) then
            Code := 1;
        end;
      end;
    fsubDate :
      begin
        DateMask := OvcIntlSup.InternationalDate(True);
        if Length(Value) <> Length(DateMask) then
          R.rtDate := BadDate
        else
          R.rtDate := OvcIntlSup.DateStringToDate(DateMask, Value, GetEpoch);
        if R.rtDate = BadDate then
          Code := 1;
      end;
    fsubTime :
      begin
        TimeMask := OvcIntlSup.InternationalTime(False);
        if Length(Value) <> Length(TimeMask) then
          R.rtTime := BadTime
        else
          R.rtTime := OvcIntlSup.TimeStringToTime(TimeMask, Value);
        if R.rtTime = BadTime then
          Code := 1;
      end;
  end;
  Result := Code = 0;
end;

procedure TOvcBaseEntryField.efReadRangeHi(Stream : TStream);
  {-called to read the high range from the stream}
begin
  Stream.Read(efRangeHi, SizeOf(TRangeType));
end;

procedure TOvcBaseEntryField.efReadRangeLo(Stream : TStream);
  {-called to read the low range from the stream}
begin
  Stream.Read(efRangeLo, SizeOf(TRangeType));
end;

function TOvcBaseEntryField.efTransfer(DataPtr : Pointer; TransferFlag : Word) : Word;
  {-transfer data to or from the field}
begin
  if (TransferFlag <> otf_SizeData) and not (csDesigning in ComponentState) then
    Result := efTransferPrim(DataPtr, TransferFlag)
  else
    Result := efDataSize;
  {descendant classes will do the actual transfering of data}
end;

function TOvcBaseEntryField.efTransferPrim(DataPtr : Pointer; TransferFlag : Word) : Word;
  {-reset for new data in field}
begin
  Result := efDataSize;
  if TransferFlag = otf_SetData then begin
    if not (sefValidating in sefOptions) then begin
      Exclude(sefOptions, sefRetainPos);
      if sefHaveFocus in sefOptions then begin
        efResetCaret;
        efPositionCaret(True);

        {if we are doing a transfer due to a GetValue}
        {validation, don't reset selection}
        if not (sefGettingValue in sefOptions) then
          SetSelection(0, MaxEditLen);
      end else
        Exclude(sefOptions, sefInvalid);

      {clear modified flags}
      Exclude(sefOptions, sefModified);
      Exclude(sefOptions, sefEverModified);

      Invalidate;
    end;
  end;
end;

procedure TOvcBaseEntryField.efWriteRangeHi(Stream : TStream);
  {-called to store the high range on the stream}
begin
  Stream.Write(efRangeHi, SizeOf(TRangeType));
end;

procedure TOvcBaseEntryField.efWriteRangeLo(Stream : TStream);
  {-called to store the low range on the stream}
begin
  Stream.Write(efRangeLo, SizeOf(TRangeType));
end;

procedure TOvcBaseEntryField.EMGetModify(var Msg : TMessage);
begin
  Msg.Result := 0;
  if sefModified in sefOptions then
    Msg.Result := 1;
end;

procedure TOvcBaseEntryField.EMGetSel(var Msg : TMessage);
begin
  {Return this info in Msg as well as in Result}
  with Msg do begin
    if LPDWORD(wParam) <> nil then
      LPDWORD(wParam)^ := efSelStart;
    if LPDWORD(lParam) <> nil then
      LPDWORD(lParam)^ := efSelEnd;
  end;
  Msg.Result := MakeLong(efSelStart, efSelEnd);
end;

procedure TOvcBaseEntryField.EMSetModify(var Msg : TMessage);
begin
  if Msg.wParam > 0 then begin
    Include(sefOptions, sefModified);
    Include(sefOptions, sefEverModified);
  end else
    Exclude(sefOptions, sefModified);
end;

procedure TOvcBaseEntryField.EMSetSel(var Msg : TMessage);
begin
  with Msg do begin
    if lParamLo = $FFFF then
      SetSelection(0, 0)
    else if (lParamLo = 0) and (lParamHi = $FFFF) then
      SetSelection(0, MaxEditLen)
    else if lParamHi >= lParamLo then
      SetSelection(lParamLo, lParamHi);
  end;
  Invalidate;
end;

function TOvcBaseEntryField.GetAsBoolean : Boolean;
  {-returns the field value as a Boolean Value}
begin
  Result := False;
  if (efDataType mod fcpDivisor) in [fsubBoolean, fsubYesNo] then
    FLastError := GetValue(Result)
  else
    raise EInvalidDataType.Create;
end;

function TOvcBaseEntryField.GetAsCents : Integer;
  {-returns the field value as a Integer Value representing pennies}
const
  C = 100.0;
var
  Re : Real;
  Db : Double;
  Si : Single;
  Ex : Extended;
begin
  Result := 0;
  case (efDataType mod fcpDivisor) of
    fsubReal     :
      begin
        FLastError := GetValue(Re);
        if FLastError = 0 then
          Result := Round(Re * C);
      end;
    fsubDouble   :
      begin
        FLastError := GetValue(Db);
        if FLastError = 0 then
          Result := Round(Db * C);
      end;
    fsubSingle   :
      begin
        FLastError := GetValue(Si);
        if FLastError = 0 then
          Result := Round(Si * C);
      end;
    fsubExtended :
      begin
        FLastError := GetValue(Ex);
        if FLastError = 0 then
          Result := Round(Ex * C);
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

function TOvcBaseEntryField.GetAsDateTime : TDateTime;
  {-returns the field value as a Delphi DateTime Value

   -Changes:
    03/2011 AB: Added support for TOvcPictureField with DataType=pftDateTime }
var
  D  : TStDate;
  T  : TStTime;
  DT : TDateTime;
begin
  case (efDataType mod fcpDivisor) of
    fsubDate :
      begin
        FLastError := GetValue(D);
        if FLastError <> 0 then
          Result := 0
        else
          Result := StDateToDateTime(D);
      end;
    fsubTime :
      begin
        FLastError := GetValue(T);
        if FLastError <> 0 then
          Result := 0
        else
          Result := StTimeToDateTime(T);
      end;
    fsubDouble : { TDateTime }
      begin
        FLastError := GetValue(DT);
        if FLastError <> 0 then
          Result := 0
        else
          Result := DT;
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

function TOvcBaseEntryField.GetAsExtended : Extended;
  {-returns the field value as an Extended Value}
var
  Ex  : Extended;
  Co  : Comp absolute Ex;
  Db  : Double;
  Sg  : Single absolute Db;
  Re  : Real absolute Db;
  Li  : Integer;
  Wo  : Word absolute Li;
  It  : SmallInt absolute Li;
  By  : Byte absolute Li;
  Si  : ShortInt absolute Li;
begin
  Result := 0;
  case efDataType mod fcpDivisor of
    fsubExtended   :
      begin
        FLastError := GetValue(Ex);
        if FLastError = 0 then
          Result := Ex;
      end;
    fsubComp :
      begin
        FLastError := GetValue(Co);
        if FLastError = 0 then
          Result := Co;
      end;
    fsubReal   :
      begin
        FLastError := GetValue(Re);
        if FLastError = 0 then
          Result := Re;
      end;
    fsubDouble :
      begin
        FLastError := GetValue(Db);
        if FLastError = 0 then
          Result := Db;
      end;
    fsubSingle :
      begin
        FLastError := GetValue(Sg);
        if FLastError = 0 then
          Result := Sg;
      end;
    fsubLongInt   :
      begin
        FLastError := GetValue(Li);
        if FLastError = 0 then
          Result := Li;
      end;
    fsubWord :
      begin
        FLastError := GetValue(Wo);
        if FLastError = 0 then
          Result := Wo;
      end;
    fsubInteger :
      begin
        FLastError := GetValue(It);
        if FLastError = 0 then
          Result := It;
      end;
    fsubByte :
      begin
        FLastError := GetValue(By);
        if FLastError = 0 then
          Result := By;
      end;
    fsubShortInt :
      begin
        FLastError := GetValue(Si);
        if FLastError = 0 then
          Result := Si;
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

function TOvcBaseEntryField.GetAsFloat : Double;
  {-returns the field value as a Double Value}
var
  Db  : Double;
  Sg  : Single absolute Db;
  Re  : Real absolute Db;
  Ex  : Extended;
  Co  : Comp absolute Ex;
  Li  : Integer;
  Wo  : Word absolute Li;
  It  : SmallInt absolute Li;
  By  : Byte absolute Li;
  Si  : ShortInt absolute Li;
begin
  Result := 0;
  case efDataType mod fcpDivisor of
    fsubReal   :
      begin
        FLastError := GetValue(Re);
        if FLastError = 0 then
          Result := Re;
      end;
    fsubDouble :
      begin
        FLastError := GetValue(Db);
        if FLastError = 0 then
          Result := Db;
      end;
    fsubSingle :
      begin
        FLastError := GetValue(Sg);
        if FLastError = 0 then
          Result := Sg;
      end;
    fsubExtended   :
      begin
        FLastError := GetValue(Ex);
        if FLastError = 0 then
          Result := Ex;
      end;
    fsubComp :
      begin
        FLastError := GetValue(Co);
        if FLastError = 0 then
          Result := Co;
      end;
    fsubLongInt   :
      begin
        FLastError := GetValue(Li);
        if FLastError = 0 then
          Result := Li;
      end;
    fsubWord :
      begin
        FLastError := GetValue(Wo);
        if FLastError = 0 then
          Result := Wo;
      end;
    fsubInteger :
      begin
        FLastError := GetValue(It);
        if FLastError = 0 then
          Result := It;
      end;
    fsubByte :
      begin
        FLastError := GetValue(By);
        if FLastError = 0 then
          Result := By;
      end;
    fsubShortInt :
      begin
        FLastError := GetValue(Si);
        if FLastError = 0 then
          Result := Si;
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

function TOvcBaseEntryField.GetAsInteger : Integer;
  {-returns the field value as a Integer Value}
var
  Li  : Integer;
  Wo  : Word absolute Li;
  It  : SmallInt absolute Li;
  By  : Byte absolute Li;
  Si  : ShortInt absolute Li;
begin
  Result := 0;
  case efDataType mod fcpDivisor of
    fsubLongInt   :
      begin
        FLastError := GetValue(Li);
        if FLastError = 0 then
          Result := Li;
      end;
    fsubWord :
      begin
        FLastError := GetValue(Wo);
        if FLastError = 0 then
          Result := Wo;
      end;
    fsubInteger :
      begin
        FLastError := GetValue(It);
        if FLastError = 0 then
          Result := It;
      end;
    fsubByte :
      begin
        FLastError := GetValue(By);
        if FLastError = 0 then
          Result := By;
      end;
    fsubShortInt :
      begin
        FLastError := GetValue(Si);
        if FLastError = 0 then
          Result := Si;
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

function TOvcBaseEntryField.GetAsString : string;
  {-return the field value as a string value}
var
  Buf : TEditString;
  S   : string;
begin
  Result := '';
  if (efDataType mod fcpDivisor) = fsubString then begin
    FLastError := GetValue(S);
    if FLastError = 0 then
      Result := S;
  end else begin
    StrCopy(Buf, efEditSt);
    if efoTrimBlanks in Options then
      TrimAllSpacesPChar(Buf);
    Result := StrPas(Buf);
    FLastError := 0;
  end;
end;

function TOvcBaseEntryField.GetAsVariant : Variant;
  {return the field value as a Variant value}
begin
  case efDataType mod fcpDivisor of
    fsubBoolean  : Result := GetAsBoolean;
    fsubYesNo    : Result := GetAsBoolean;
    fsubLongInt  : Result := GetAsInteger;
    fsubWord     : Result := GetAsInteger;
    fsubInteger  : Result := GetAsInteger;
    fsubByte     : Result := GetAsInteger;
    fsubShortInt : Result := GetAsInteger;
    fsubReal     : Result := GetAsFloat;
    fsubDouble   : Result := GetAsFloat;
    fsubSingle   : Result := GetAsFloat;
    fsubExtended : Result := GetAsExtended;
    fsubComp     : Result := GetAsExtended;
  else
    Result := GetAsString;
  end;
end;

function TOvcBaseEntryField.GetAsStDate : TStDate;
  {-returns the field value as a Date Value}
begin
  if (efDataType mod fcpDivisor) = fsubDate  then begin
    FLastError := GetValue(Result);
    if FLastError <> 0 then
      Result := BadDate;
  end else
    raise EInvalidDataType.Create;
end;

function TOvcBaseEntryField.GetAsStTime : TStTime;
  {-returns the field value as a Time Value}
begin
  if (efDataType mod fcpDivisor) = fsubTime then begin
    FLastError := GetValue(Result);
    if FLastError <> 0 then
      Result := BadTime;
  end else
    raise EInvalidDataType.Create;
end;

function TOvcBaseEntryField.GetCurrentPos : Integer;
  {-get position of the caret within the field}
begin
  if sefHaveFocus in sefOptions then
    Result := efHPos
  else
    Result := -1;
end;

function TOvcBaseEntryField.GetDataSize : Word;
  {-return the size of the data for this field}
begin
  if efDataSize = 0 then
    efInitializeDataSize;
  Result := efDataSize;
end;

function TOvcBaseEntryField.GetDisplayString : string;
  {-return the display string}
var
  Buf : TEditString;
begin
  efGetDisplayString(Buf, MaxEditLen);
  Result := StrPas(Buf);
end;

function TOvcBaseEntryField.GetEditString : string;
  {-return a string containing the edit text}
var
  Buf : TEditString;
begin
  StrLCopy(Buf, efEditSt, MaxEditLen);
  Result := StrPas(Buf);
end;

function TOvcBaseEntryField.GetEpoch : Integer;
begin
  Result := FEpoch;

  {avoid writing controller's epoch value}
  if csWriting in ComponentState then
    Exit;

  if Assigned(FOnGetEpoch) then
    FOnGetEpoch(Self, Result);
  if (Result = 0) and ControllerAssigned then
    Result := Controller.Epoch;
end;

function TOvcBaseEntryField.GetEverModified : Boolean;
  {-return true if this field has ever been modified}
begin
  Result := (sefEverModified in sefOptions) or (sefModified in sefOptions);
end;

function TOvcBaseEntryField.GetInsCaretType : TOvcCaret;
  {-return the current caret type}
begin
  Result := efCaret.InsCaretType;
end;

function TOvcBaseEntryField.GetInsertMode : Boolean;
  {-return the controller's insert mode state}
begin
  if ControllerAssigned then
    Result := Controller.InsertMode
  else
    Result := sefInsert in sefOptions;
end;

function TOvcBaseEntryField.GetModified : Boolean;
  {-return true if this field is modified}
begin
  Result := sefModified in sefOptions;
end;

function TOvcBaseEntryField.GetOvrCaretType : TOvcCaret;
  {-return the current caret type}
begin
  Result := efCaret.OvrCaretType;
end;

function TOvcBaseEntryField.GetRangeHiStr : string;
  {-get the high field range as string value}
begin
  Result := efRangeToStRange(efRangeHi);
end;

function TOvcBaseEntryField.GetRangeLoStr : string;
  {-get the low field range as string value}
begin
  Result := efRangeToStRange(efRangeLo);
end;

function TOvcBaseEntryField.GetSelLength : Integer;
  {-return the length of the currently selected text}
begin
  Result := efSelEnd - efSelStart;
end;

function TOvcBaseEntryField.GetSelStart : Integer;
  {-return the starting position of the selection, if any}
begin
  Result := efSelStart;
end;

function TOvcBaseEntryField.GetSelText : string;
  {-return the currently selected text}
var
  Len : Integer;
begin
  Result := '';
  Len := efSelEnd - efSelStart;
  if Len > 0 then begin
    {limit length to max edit length}
    if Len > MaxEditLen then
      Len := MaxEditLen;
    SetLength(Result, Len);
    StrLCopy(PChar(Result), @efEditSt[efSelStart], Len);
  end;
end;

function TOvcBaseEntryField.FieldIsEmpty : Boolean;
  {-return True if the field is completely empty}
begin
  HandleNeeded;
  Result := efFieldIsEmpty;
end;

function TOvcBaseEntryField.GetStrippedEditString : string;
  {-return edit string stripped of literals and semi-literals}
begin
  Result := GetEditString;
end;

function TOvcBaseEntryField.GetValue(var Data) : Word;
  {-returns the current field value in Data. Result is 0 or error code}
begin
  {flag to inform validate and transfer}
  {methods that we are retrieving a value}
  Include(sefOptions, sefGettingValue);
  try
    Result := efValidateField;
    if Result <> 0 then
      Exit;

    case efDataType mod fcpDivisor of
      fsubString   : efTransfer(@string(Data),   otf_GetData);
      fsubChar     : efTransfer(@Char(Data),     otf_GetData);
      fsubBoolean  : efTransfer(@Boolean(Data),  otf_GetData);
      fsubYesNo    : efTransfer(@Boolean(Data),  otf_GetData);
      fsubLongInt  : efTransfer(@NativeInt(Data),otf_GetData);
      fsubWord     : efTransfer(@Word(Data),     otf_GetData);
      fsubInteger  : efTransfer(@SmallInt(Data), otf_GetData);
      fsubByte     : efTransfer(@Byte(Data),     otf_GetData);
      fsubShortInt : efTransfer(@ShortInt(Data), otf_GetData);
      fsubReal     : efTransfer(@Real(Data),     otf_GetData);
      fsubExtended : efTransfer(@Extended(Data), otf_GetData);
      fsubDouble   : efTransfer(@Double(Data),   otf_GetData);
      fsubSingle   : efTransfer(@Single(Data),   otf_GetData);
      fsubComp     : efTransfer(@Comp(Data),     otf_GetData);
      fsubDate     : efTransfer(@TStDate(Data),  otf_GetData);
      fsubTime     : efTransfer(@TStTime(Data),  otf_GetData);
    else
      raise EOvcException.Create(GetOrphStr(SCInvalidParamValue));
    end;
  finally
    Exclude(sefOptions, sefGettingValue);
  end;
end;

procedure TOvcBaseEntryField.IncreaseValue(Wrap : Boolean; Delta : Double);
  {-increase the value of the field by Delta, wrapping if enabled}
begin
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
  efIncDecValue(Wrap, +Delta);
  SetSelection(0, 0);
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
  Refresh;
end;

function TOvcBaseEntryField.IsValid : Boolean;
  {-returns true if the field is not marked as invalid}
begin
  Result := not (sefInvalid in sefOptions);
end;

procedure TOvcBaseEntryField.MergeWithPicture(const S : string);
  {-combines S with the picture mask and updates the edit string}
begin
  StrPLCopy(efEditSt, S, MaxLength);
end;

procedure TOvcBaseEntryField.MoveCaret(Delta : Integer);
  {-moves the caret to the right or left Value positions}
var
  I   : Integer;
  Msg : TMessage;
begin
  if not (sefHaveFocus in sefOptions) then
    Exit;

  FillChar(Msg, SizeOf(Msg), 0);
  if Delta > 0 then begin
    for I := 1 to Delta do
      efPerformEdit(Msg, ccRight)
  end else if Delta < 0 then begin
    for I := 1 to Abs(Delta) do
      efPerformEdit(Msg, ccLeft)
  end;
end;

procedure TOvcBaseEntryField.MoveCaretToEnd;
  {-move the caret to the end of the field}
begin
  efCaretToEnd;
end;

procedure TOvcBaseEntryField.MoveCaretToStart;
  {-move the caret to the beginning of the field}
begin
  efCaretToStart;
end;

procedure TOvcBaseEntryField.OMGetDataSize(var Msg : TMessage);
  {-return the fields data size}
begin
  Msg.Result := DataSize;
end;

procedure TOvcBaseEntryField.OMReportError(var Msg : TOMReportError);
  {-report the error}
var
  P : string;
begin
  if Msg.Error = 0 then
    Exit;

  case Msg.Error of
    oeRangeError    : P := GetOrphStr(SCRangeError);
    oeInvalidNumber : P := GetOrphStr(SCInvalidNumber);
    oeRequiredField : P := GetOrphStr(SCRequiredField);
    oeInvalidDate   : P := GetOrphStr(SCInvalidDate);
    oeInvalidTime   : P := GetOrphStr(SCInvalidTime);
    oeBlanksInField : P := GetOrphStr(SCBlanksInField);
    oePartialEntry  : P := GetOrphStr(SCPartialEntry);
  else
    if Msg.Error >= oeCustomError then
      P := Controller.ErrorText
    else
      P := GetOrphStr(SCDefaultEntryErrorText);
  end;

  {update the error text}
  if P <> Controller.ErrorText then
    Controller.ErrorText := P;

  {do error notification}
  DoOnError(Msg.Error, P);
end;

procedure TOvcBaseEntryField.Paint;
  {-draw the entry field control}
var
  hCBM  : hBitmap;
  MemDC : hDC;
  CR    : TRect;
begin
  inherited Paint;

  {get dimensions of client area}
  CR.Top := 0; CR.Left := 0;
  CR.Right := Width; CR.Bottom := Height;

  {create a compatible display context and bitmap}
  MemDC := CreateCompatibleDC(Canvas.Handle);
  hCBM := CreateCompatibleBitmap(Canvas.Handle, CR.Right, CR.Bottom);
  SelectObject(MemDC, hCBM);
  SetMapMode(MemDC, GetMapMode(Canvas.Handle));

  {set text alignment}
  SetTextAlign(MemDC, TA_LEFT or TA_TOP);

  {call our paint routine}
  efPaintPrim(MemDC, CR, efHOffset);

  {copy everything to the original display context}
  BitBlt(Canvas.Handle, 0, 0, CR.Right, CR.Bottom, MemDC, 0, 0, SrcCopy);

  efPaintBorders;

  {dispose of the bitmap and the extra display context}
  DeleteDC(MemDC);
  DeleteObject(hCBM);
end;

procedure TOvcBaseEntryField.efPaintBorders;
var
  R : TRect;
  C : TCanvas;
begin
  R.Left   := 0;
  R.Top    := 0;
  R.Right  := Width;
  R.Bottom := Height;

  C := Canvas;
  if (FBorders.LeftBorder <> nil) then begin
    if (FBorders.LeftBorder.Enabled) then begin
      C.Pen.Color := FBorders.LeftBorder.PenColor;
      C.Pen.Width := FBorders.LeftBorder.PenWidth;
      C.Pen.Style := FBorders.LeftBorder.PenStyle;

      C.MoveTo(R.Left + (FBorders.LeftBorder.PenWidth div 2), R.Top);
      C.LineTo(R.Left + (FBorders.LeftBorder.PenWidth div 2), R.Bottom);
    end;
  end;

  if (FBorders.RightBorder <> nil) then begin
    if (FBorders.RightBorder.Enabled) then begin
      C.Pen.Color := FBorders.RightBorder.PenColor;
      C.Pen.Width := FBorders.RightBorder.PenWidth;
      C.Pen.Style := FBorders.RightBorder.PenStyle;

      if ((FBorders.RightBorder.PenWidth mod 2) = 0) then begin
        C.MoveTo(R.Right - (FBorders.RightBorder.PenWidth div 2), R.Top);
        C.LineTo(R.Right - (FBorders.RightBorder.PenWidth div 2), R.Bottom);
      end else begin
        C.MoveTo(R.Right - (FBorders.RightBorder.PenWidth div 2) - 1, R.Top);
        C.LineTo(R.Right - (FBorders.RightBorder.PenWidth div 2) - 1, R.Bottom);
      end;
    end;
  end;

  if (FBorders.TopBorder <> nil) then begin
    if (FBorders.TopBorder.Enabled) then begin
      C.Pen.Color := FBorders.TopBorder.PenColor;
      C.Pen.Width := FBorders.TopBorder.PenWidth;
      C.Pen.Style := FBorders.TopBorder.PenStyle;

      C.MoveTo(R.Left, R.Top + (FBorders.TopBorder.PenWidth div 2));
      C.LineTo(R.Right, R.Top + (FBorders.TopBorder.PenWidth div 2));
    end;
  end;

  if (FBorders.BottomBorder <> nil) then begin
    if (FBorders.BottomBorder.Enabled) then begin
      C.Pen.Color := FBorders.BottomBorder.PenColor;
      C.Pen.Width := FBorders.BottomBorder.PenWidth;
      C.Pen.Style := FBorders.BottomBorder.PenStyle;

      if ((FBorders.BottomBorder.PenWidth mod 2) = 0) then begin
        C.MoveTo(R.Left, R.Bottom - (FBorders.BottomBorder.PenWidth div 2));
        C.LineTo(R.Right, R.Bottom - (FBorders.BottomBorder.PenWidth div 2));
      end else begin
        C.MoveTo(R.Left, R.Bottom - (FBorders.BottomBorder.PenWidth div 2) - 1);
        C.LineTo(R.Right, R.Bottom - (FBorders.BottomBorder.PenWidth div 2) - 1);
      end;
    end;
  end;
end;

procedure TOvcBaseEntryField.PasteFromClipboard;
  {-pastes the contents of the clipboard in the edit field}
begin
  if HandleAllocated then
    Perform(WM_PASTE, 0, 0);
end;

procedure TOvcBaseEntryField.ProcessCommand(Cmd, CharCode : Word);
  {-process the specified command}
var
  Msg : TMessage;
begin
  FillChar(Msg, SizeOf(Msg), #0);
  Msg.wParam := CharCode;
  efPerformEdit(Msg, Cmd);
end;

procedure TOvcBaseEntryField.ResetCaret;
  {-move the caret to the beginning or end of the field, as appropriate}
begin
  efResetCaret;
end;

procedure TOvcBaseEntryField.Restore;
  {-restore the previous contents of the field}
begin
  if efSaveEdit = nil then
    Exit;

  StrCopy(efEditSt, efSaveEdit);
  efResetCaret;
  SetSelection(0, MaxEditLen);

  {clear modified flag}
  Exclude(sefOptions, sefModified);
  Repaint;
  DoOnChange;
end;

procedure TOvcBaseEntryField.SelectAll;
  {-selects the entire contents of the edit field}
begin
  if HandleAllocated then
    Perform(EM_SETSEL, 1, Integer($FFFF0000));
end;

procedure TOvcBaseEntryField.SetAsBoolean(Value : Boolean);
  {-sets the field value to a Boolean Value}
begin
  if (efDataType mod fcpDivisor) in [fsubBoolean, fsubYesNo] then
    SetValue(Value)
  else
    raise EInvalidDataType.Create;
end;

procedure TOvcBaseEntryField.SetAsCents(Value : Integer);
  {-sets the field value given a Integer Value representing pennies}
const
  C = 100.0;
var
  Re : Real;
  Db : Double;
  Si : Single;
  Ex : Extended;
begin
  case efDataType mod fcpDivisor of
    fsubReal     :
      begin
        Re := Value / C;
        SetValue(Re);
      end;
    fsubDouble   :
      begin
        Db := Value / C;
        SetValue(Db);
      end;
    fsubSingle   :
      begin
        Si := Value / C;
        SetValue(Si);
      end;
    fsubExtended :
      begin
        Ex := Value / C;
        SetValue(Ex);
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

procedure TOvcBaseEntryField.SetAsDateTime(Value : TDateTime);
  {-sets the field value to a Delphi DateTime value

   -Changes:
    03/2011 AB: Added support for TOvcPictureField with DataType=pftDateTime }
var
  D     : TStDate;
  T     : TStTime;
  Day,
  Month,
  Year  : Word;
  Hour,
  Min,
  Sec,
  MSec  : Word;
begin
  case (efDataType mod fcpDivisor) of
    fsubDate :
      begin
        {$IFDEF ZeroDateAsNull}
        if Value = 0 then
          Value := BadDate;
        {$ENDIF}
        DecodeDate(Value, Year, Month, Day);
        D := DMYToStDate(Day, Month, Year, GetEpoch);
        if D = DateTimeToStDate(BadDate) then
          D := BadDate;
        SetValue(D);
      end;
    fsubTime :
      begin
        DecodeTime(Value, Hour, Min, Sec, MSec);
        T := HMSToStTime(Hour, Min, Sec);
        if (T <> 0) and (T = DateTimeToStTime(BadTime)) then
          T := BadTime;
        SetValue(T);
      end;
    fsubDouble : { = TDateTime }
      begin
        SetValue(Value);
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

procedure TOvcBaseEntryField.SetAsExtended(Value : Extended);
  {-sets the field value to an Extended Value}
var
  Co  : Comp;
begin
  case efDataType mod fcpDivisor of
    fsubExtended   :
        SetValue(Value);
    fsubComp :
      begin
        Co := Trunc(Value);
        SetValue(Co);
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

procedure TOvcBaseEntryField.SetAsFloat(Value : Double);
  {-sets the field value to a Double Value}
var
  Sg  : Single;
  Re  : Real;
  Co  : Comp;
  Ex  : Extended;
begin
  case efDataType mod fcpDivisor of
    fsubReal   :
      begin
        Re := Value;
        SetValue(Re);
      end;
    fsubDouble :
        SetValue(Value);
    fsubSingle :
      begin
        Sg := Value;
        SetValue(Sg);
      end;
    fsubExtended   :
      begin
        Ex := Value;
        SetValue(Ex);
      end;
    fsubComp :
      begin
        Co := Trunc(Value);
        SetValue(Co);
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

procedure TOvcBaseEntryField.SetAsInteger(Value : Integer);
  {-sets the field value to a Integer Value}
var
  Wo  : Word;
  It  : SmallInt absolute Wo;
  By  : Byte absolute Wo;
  Si  : ShortInt absolute Wo;
begin
  case efDataType mod fcpDivisor of
    fsubLongInt   :
        SetValue(Value);
    fsubWord :
      begin
        Wo := LOWORD(Value);
        SetValue(Wo);
      end;
    fsubInteger :
      begin
        It := SmallInt(LOWORD(Value));
        SetValue(It);
      end;
    fsubByte :
      begin
        By := Lo(LOWORD(Value));
        SetValue(By);
      end;
    fsubShortInt :
      begin
        Si := ShortInt(Lo(LOWORD(Value)));
        SetValue(Si);
      end;
  else
    raise EInvalidDataType.Create;
  end;
end;

procedure TOvcBaseEntryField.SetAsString(const Value : string);
  {-sets the field value to a String Value}
var
  R    : TRangeType;
  fSub : Byte;
  B    : Boolean;
  Ch   : Char;
begin
  if sefUserValidating in sefOptions then
    Exit;

  fSub := (efDataType mod fcpDivisor);
  if fSub = fsubString then
    SetValue(Value)
  else if fSub in [fsubBoolean, fsubYesNo] then begin
    B := False;
    if Length(Value) > 0 then begin
      Ch := UpCaseChar(Value[1]);
      B := (Ch = FIntlSup.TrueChar) or (Ch = FIntlSup.YesChar);
    end;
    SetValue(B);
  end else begin
    {use range conversion routines to process string assignment}
    if efStRangeToRange(Value, R) then begin
      case (efDataType mod fcpDivisor) of
        {assign result to proper sub-field in range type var}
        fsubWord     : R.rtWord := R.rtLong;
        fsubInteger  : R.rtInt := R.rtLong;
        fsubByte     : R.rtByte := R.rtLong;
        fsubShortInt : R.rtSht := R.rtLong;
        fsubDouble   : R.rtDbl := R.rtExt;
        fsubSingle   : R.rtSgl := R.rtExt;
        fsubComp     : R.rtComp := R.rtExt;
      end;
      SetValue(R);
    end else
      raise EEntryFieldError.Create(GetOrphStr(SCInvalidNumber));
  end;
end;

function TOvcBaseEntryField.GetDefStrType: TVarType;
begin
  Result := varUString;
end;

procedure TOvcBaseEntryField.SetAsVariant(Value : Variant);
  {-sets the field value to a Variant value}
var
  fSub : Byte;
begin
  {what data type is this field}
  fSub := efDataType mod fcpDivisor;

  case VarType(Value) of
    varSmallInt,
    varInteger  :
      case fSub of
        fsubByte,
        fsubShortInt,
        fsubWord,
        fsubInteger,
        fsubLongInt : SetAsInteger(Value);
      else
        {try to convert it into a string}
        SetAsString(VarAsType(Value, GetDefStrType));
      end;
    varSingle,
    varDouble,
    varCurrency :
      case fSub of
        fsubReal,
        fsubDouble,
        fsubSingle,
        fsubExtended,
        fsubComp : SetAsFloat(Value);
      else
        {try to convert it into a string}
        SetAsString(VarAsType(Value, GetDefStrType));
      end;
    varDate     :
      if fSub = fsubDate then
        SetAsDateTime(Value)
      else
        {try to convert it into a string}
        SetAsString(VarAsType(Value, GetDefStrType));
    varBoolean  :
      if fSub in [fsubBoolean, fsubYesNo] then
        SetAsBoolean(Value)
      else
        {try to convert it into a string}
        SetAsString(VarAsType(Value, GetDefStrType));
    varString   : SetAsString(Value);
    varUString: SetAsString(Value);
  end;
end;

procedure TOvcBaseEntryField.SetAsStDate(Value : TStDate);
  {-sets the field value to a Date Value}
begin
  if (efDataType mod fcpDivisor) = fsubDate then
    SetValue(Value)
  else
    raise EInvalidDataType.Create;
end;

procedure TOvcBaseEntryField.SetAsStTime(Value : TStTime);
  {-sets the field value to a Time Value}
begin
  if efDataType mod fcpDivisor = fsubTime then
    SetValue(Value)
  else
    raise EInvalidDataType.Create;
end;

procedure TOvcBaseEntryField.SetAutoSize(Value : Boolean);
begin
  if Value <> FAutoSize then begin
    FAutoSize := Value;

    if not (csLoading in ComponentState) then
      efAdjustSize; {adjust height based on font}
  end;
end;

procedure TOvcBaseEntryField.SetBorderStyle(Value : TBorderStyle);
begin
  if FBorderStyle <> Value then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseEntryField.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  if FAutoSize and (AHeight <> Height) and
     not (csLoading in ComponentState) then
    FAutoSize := False;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  efCalcTopMargin;

  if HandleAllocated and (GetFocus = Handle) then
    efPositionCaret(False);  {adjust caret for new size}
  Refresh;
end;

procedure TOvcBaseEntryField.SetDecimalPlaces(Value : Byte);
  {-set the number of decimal places for the edit field}
begin
  if Value <> FDecimalPlaces then begin
    FDecimalPlaces := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseEntryField.SetEpoch(Value : Integer);
begin
  if Value <> FEpoch then
    if (Value = 0) or ((Value >= MinYear) and (Value <= MaxYear)) then
      FEpoch := Value;
  if ControllerAssigned and (FEpoch = Controller.Epoch) then
    FEpoch := 0;
end;

procedure TOvcBaseEntryField.SetEverModified(Value : Boolean);
  {-set the EverModified flag}
begin
  if Value then
    Include(sefOptions, sefEverModified)
  else begin
    Exclude(sefOptions, sefEverModified);

    {clear sefModified also}
    Exclude(sefOptions, sefModified);
  end;
end;

procedure TOvcBaseEntryField.SetInsCaretType(const Value : TOvcCaret);
  {-set the type of caret to use}
begin
  if Value <> efCaret.InsCaretType then
    efCaret.InsCaretType := Value;
end;

procedure TOvcBaseEntryField.SetIntlSupport(Value : TOvcIntlSup);
  {-set the international support object this field will use}
begin
  if Assigned(Value) then
    FIntlSup := Value
  else
    FIntlSup := OvcIntlSup;
end;

procedure TOvcBaseEntryField.SetMaxLength(Value : Word);
  {-set the maximum length of the edit field}
begin
  if csLoading in ComponentState then
    FMaxLength := Value
  else if (FMaxLength <> Value) and
          (Value > 0) and
          (Value <= MaxEditLen) and
          (Value >= efPicLen) then begin
    FMaxLength := Value;
    if StrLen(efEditSt) > FMaxLength then
      efEditSt[FMaxLength] := #0;
    RecreateWnd;
  end;
end;

procedure TOvcBaseEntryField.SetModified(Value : Boolean);
  {-set the modified flag}
begin
  if Value then begin
    Include(sefOptions, sefModified);

    {set sefEverModified also}
    Include(sefOptions, sefEverModified);
  end else
    Exclude(sefOptions, sefModified);
end;

procedure TOvcBaseEntryField.SetOptions(Value : TOvcEntryFieldOptions);
  {-set the options flags}
begin
  if Value <> Options then begin
    FOptions := Value;
    if (efoForceInsert in FOptions) then
      Exclude(FOptions, efoForceOvertype);
    if (efoForceOvertype in FOptions) then
      Exclude(FOptions, efoForceInsert);
    if (efoRightJustify in FOptions) then
      if efDataType mod fcpDivisor = fsubString then
        Include(FOptions, efoTrimBlanks);
    if (efoRightAlign in FOptions) then
      efPositionCaret(True);
    if not (efoTrimBlanks in FOptions) then begin
      {if this is a string picture field then turn off right justify}
      if efFieldClass = fcPicture then
        if efDataType mod fcpDivisor = fsubString then
          Exclude(FOptions, efoRightJustify);
    end;
  end;
  efRemoveBadOptions;
  Refresh;
end;

procedure TOvcBaseEntryField.SetOvrCaretType(const Value : TOvcCaret);
  {-set the type of caret to use}
begin
  if Value <> efCaret.OvrCaretType then
    efCaret.OvrCaretType := Value;
end;

procedure TOvcBaseEntryField.SetPadChar(Value : Char);
  {-set the character used to pad the end of the edit string}
begin
  if Value <> FPadChar then begin
    FPadChar := Value;
    Refresh;
  end;
end;

procedure TOvcBaseEntryField.SetPasswordChar(Value : Char);
  {-set the character used to mask password entry}
begin
  if FPasswordChar <> Value then begin
    FPasswordChar := Value;
    if Value = #0 then
      Exclude(FOptions, efoPasswordMode);
    Refresh;
  end;
end;

procedure TOvcBaseEntryField.SetSelLength(Value : Integer);
  {-set the extent of the selected text}
begin
  SetSelection(efSelStart, efSelStart + Value);
  Refresh;
end;

procedure TOvcBaseEntryField.SetInitialValue;
  {-resets the field value to its initial value}
begin
  efSetInitialValue;
end;

procedure TOvcBaseEntryField.SetInsertMode(Value : Boolean);
  {-changes the field's insert mode}
begin
  if Value <> (sefInsert in sefOptions) then begin
    if Value then
      Include(sefOptions, sefInsert)
    else
      Exclude(sefOptions, sefInsert);
    Controller.InsertMode := Value;
    efCaret.InsertMode := Value;
  end;
end;

procedure TOvcBaseEntryField.SetRangeHi(const Value : TRangeType);
  {-set the high range for this field}
begin
  case efDataType mod fcpDivisor of
    fsubLongInt  : efRangeHi.rtLong := Value.rtLong;
    fsubWord     : efRangeHi.rtLong := Value.rtWord;
    fsubInteger  : efRangeHi.rtLong := Value.rtInt;
    fsubByte     : efRangeHi.rtLong := Value.rtByte;
    fsubShortInt : efRangeHi.rtLong := Value.rtSht;
    fsubExtended : efRangeHi.rtExt  := Value.rtExt;
    fsubDouble   : efRangeHi.rtExt  := Value.rtDbl;
    fsubSingle   : efRangeHi.rtExt  := Value.rtSgl;
    fsubComp     : efRangeHi.rtExt  := Value.rtComp;
  else
    efRangeHi := Value;
  end;

// QEC060210-14:00 - Commented out code below to fix Windows Error 
//                   "Cannot focus invisible or hidden component."
//                   when using on Notebook Tab Pages.  
{  if (ValidateContents(true) > 0)
  and (Parent <> nil)
  and (Parent.Visible)
  and (Parent.Enabled) then
    SetFocus; }
end;

procedure TOvcBaseEntryField.SetRangeHiStr(const Value : string);
  {-set the high field range from a string value}
var
  R : TRangeType;
begin
  R := efRangeHi;
  if not (csLoading in ComponentState) then
    if not efStRangeToRange(Value, R) then
      raise EInvalidRangeValue.Create(efDataType mod fcpDivisor);
  efRangeHi := R;

// QEC060210-14:00 - Commented out code below to fix Windows Error 
//                   "Cannot focus invisible or hidden component."
//                   when using on Notebook Tab Pages.  
{  if (ValidateContents(true) > 0)
  and (Parent <> nil)
  and (Parent.Visible)
  and (Parent.Enabled) then
    SetFocus;  }
end;

procedure TOvcBaseEntryField.SetRangeLo(const Value : TRangeType);
  {-set the low range for this field}
begin
  case efDataType mod fcpDivisor of
    fsubLongInt  : efRangeLo.rtLong := Value.rtLong;
    fsubWord     : efRangeLo.rtLong := Value.rtWord;
    fsubInteger  : efRangeLo.rtLong := Value.rtInt;
    fsubByte     : efRangeLo.rtLong := Value.rtByte;
    fsubShortInt : efRangeLo.rtLong := Value.rtSht;
    fsubExtended : efRangeLo.rtExt  := Value.rtExt;
    fsubDouble   : efRangeLo.rtExt  := Value.rtDbl;
    fsubSingle   : efRangeLo.rtExt  := Value.rtSgl;
    fsubComp     : efRangeLo.rtExt  := Value.rtComp;
  else
    efRangeLo := Value;
  end;

// QEC060210-14:00 - Commented out code below to fix Windows Error 
//                   "Cannot focus invisible or hidden component."
//                   when using on Notebook Tab Pages.  
{  if (ValidateContents(true) > 0)
  and (Parent <> nil)
  and (Parent.Visible)
  and (Parent.Enabled) then
    SetFocus; }
end;

procedure TOvcBaseEntryField.SetRangeLoStr(const Value : string);
  {-set the low field range from a string value}
var
  R : TRangeType;
begin
  R := efRangeLo;
  if not (csLoading in ComponentState) then
    if not efStRangeToRange(Value, R) then
      raise EInvalidRangeValue.Create(efDataType mod fcpDivisor);
  efRangeLo := R;

// QEC060210-14:00 - Commented out code below to fix Windows Error 
//                   "Cannot focus invisible or hidden component."
//                   when using on Notebook Tab Pages.  
{  if (ValidateContents(true) > 0)
  and (Parent <> nil)
  and (Parent.Visible)
  and (Parent.Enabled) then
    SetFocus;  }
end;

procedure TOvcBaseEntryField.SetSelStart(Value : Integer);
  {-set the starting position of the selection}
begin
  SetSelection(Value, Value);
  Refresh;
end;

procedure TOvcBaseEntryField.SetSelText(const Value : string);
  {-replace selected text with Value}
var
  Msg : TMessage;
  Buf : array[0..MaxEditLen] of Char;
begin
  StrPLCopy(Buf, Value, Length(Buf) - 1);
  Msg.lParam := NativeInt(@Buf);
  efPerformEdit(Msg, ccPaste);
end;

procedure TOvcBaseEntryField.SetTextMargin(Value : Integer);
  {-set the text margin}
begin
  if (Value <> FTextMargin) and (Value >= 2) then begin
    FTextMargin := Value;
    Refresh;
  end;
end;

procedure TOvcBaseEntryField.SetUninitialized(Value : Boolean);
  {-sets the Uninitialized option}
begin
  if Value <> FUninitialized then begin
    FUninitialized := Value;
    efRemoveBadOptions;
  end;
end;

procedure TOvcBaseEntryField.SetUserData(Value : TOvcUserData);
  {-sets pointer to user-defined mask data object}
begin
  if Assigned(Value) then
    FUserData := Value
  else
    FUserData := OvcUserData;
end;

procedure TOvcBaseEntryField.SetValue(const Data);
  {-changes the field value to the value in Data}
begin
  if sefUserValidating in sefOptions then
    Exit;

  HandleNeeded;

  {set the updating flag so OnChange doesn't get fired}
  Include(sefOptions, sefUpdating);
  try
    case efDataType mod fcpDivisor of
      fsubString   : efTransfer(@string(Data),   otf_SetData);
      fsubChar     : efTransfer(@AnsiChar(Data), otf_SetData);
      fsubBoolean  : efTransfer(@Boolean(Data),  otf_SetData);
      fsubYesNo    : efTransfer(@Boolean(Data),  otf_SetData);
      fsubLongInt  : efTransfer(@NativeInt(Data),otf_SetData);
      fsubWord     : efTransfer(@Word(Data),     otf_SetData);
      fsubInteger  : efTransfer(@SmallInt(Data), otf_SetData);
      fsubByte     : efTransfer(@Byte(Data),     otf_SetData);
      fsubShortInt : efTransfer(@ShortInt(Data), otf_SetData);
      fsubReal     : efTransfer(@Real(Data),     otf_SetData);
      fsubExtended : efTransfer(@Extended(Data), otf_SetData);
      fsubDouble   : efTransfer(@Double(Data),   otf_SetData);
      fsubSingle   : efTransfer(@Single(Data),   otf_SetData);
      fsubComp     : efTransfer(@Comp(Data),     otf_SetData);
      fsubDate     : efTransfer(@TStDate(Data),  otf_SetData);
      fsubTime     : efTransfer(@TStTime(Data),  otf_SetData);
    else
      raise EOvcException.Create(GetOrphStr(SCInvalidParamValue));
    end;
  finally
    Exclude(sefOptions, sefUpdating);
  end;
end;

procedure TOvcBaseEntryField.SetZeroDisplay(Value : TZeroDisplay);
  {-set flag that determines if zeros are hidden}
begin
  if Value <> FZeroDisplay then begin
    FZeroDisplay := Value;
    Refresh;
  end;
end;

procedure TOvcBaseEntryField.SetZeroDisplayValue(Value : Double);
  {-set value used by ZeroDisplay logic}
begin
  if Value <> FZeroDisplayValue then begin
    FZeroDisplayValue := Value;
    Refresh;
  end;
end;

function TOvcBaseEntryField.ValidateContents(ReportError : Boolean) : Word;
  {-performs field validation, returns error code, and conditionally reports error}
var
  WasValid : Boolean;
begin
{ - If the parent is not enabled or visible then don't attempt to }
{ validate the contents of the control. }
  if (not (Enabled and Visible)) or (Parent = nil)
  or (not (Parent.Enabled and Parent.Visible))
  then begin
    Result := 0;
    Exit;
  end;

  FLastError := 0;

  {record current valid state}
  WasValid := IsValid;

  {check for empty/uninitialized required field}
  if (efoInputRequired in Options) and not efIsReadOnly then
    if efFieldIsEmpty or (Uninitialized and not (sefModified in sefOptions)) then
      FLastError := oeRequiredField;

  {ask the validation routine if there's an error}
  if FLastError = 0 then begin
    Include(sefOptions, sefValidating);
    try
      FLastError := efValidateField;
    finally
      Exclude(sefOptions, sefValidating);
    end;
  end;

  if ReportError and (FLastError <> 0) then
    PostMessage(Handle, om_ReportError, FLastError, 0);

  {update invalid flag}
  if FLastError = 0 then
    Exclude(sefOptions, sefInvalid)
  else if efoSoftValidation in Options then
    Include(sefOptions, sefInvalid);

  {force field to repaint if valid state has changed}
  if WasValid <> IsValid then
    Invalidate;

  Result := FLastError;
end;

function TOvcBaseEntryField.ValidateSelf : Boolean;
  {-performs field validation, returns true if no errors, and reports error if not using SoftValidation}
begin
  Result := ValidateContents(not (efoSoftValidation in Options)) = 0;
end;

procedure TOvcBaseEntryField.WMChar(var Msg : TWMChar);
begin
  inherited;

  if sefCharOk in sefOptions then
    efPerformEdit(TMessage(Msg), ccChar);
end;

procedure TOvcBaseEntryField.WMClear(var Msg : TWMClear);
begin
  efPerformEdit(TMessage(Msg), ccCut);
end;

procedure TOvcBaseEntryField.WMCopy(var Msg : TWMCopy);
begin
  efPerformEdit(TMessage(Msg), ccCopy);
end;

procedure TOvcBaseEntryField.WMCut(var Msg : TWMCut);
begin
  efCopyPrim;
  efPerformEdit(TMessage(Msg), ccCut);
end;

procedure TOvcBaseEntryField.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;  {don't erase background}
end;

{ Fix for 667944
  I really don't think the following two procedureas are needed anymore, since
  the text property seems to work just fine.
  I have added them for completeness anyway.
}
procedure TOvcBaseEntryField.WMGetText(var Msg : TWMGetText);
begin
  Msg.Result:=StrLen(StrLCopy(pChar(Msg.Text),pChar(Text),Msg.TextMax-1));
end;

procedure TOvcBaseEntryField.WMGetTextLength(var Msg : TWMGetTextLength);
begin
  Msg.Result:=Length(Text);
end;

procedure TOvcBaseEntryField.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  inherited;

  if csDesigning in ComponentState then
    Msg.Result := DLGC_STATIC
  else
    Msg.Result := Msg.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TOvcBaseEntryField.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  inherited;

  if Msg.CharCode = 0 then
    Exit;

  {don't process shift key by itself}
  if Msg.CharCode = VK_SHIFT then
    Exit;

  {see if this command should be processed by us}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));

  {convert undo to restore since ctrl-Z is mapped to ccUndo by default}
  {and cannot be mapped to more than one command in a command table}
  if Cmd = ccUndo then
    Cmd := ccRestore;

  if Cmd <> ccNone then begin
    if (Cmd <> ccIns) or
       not ((efoForceInsert in Options) or
            (efoForceOvertype in Options)) then begin
      case Cmd of
        ccCut   : WMCut(TWMCut(Msg));
        ccCopy  : WMCopy(TWMCopy(Msg));
        ccPaste : WMPaste(TWMPaste(Msg));
      else
        efPerformEdit(TMessage(Msg), Cmd);
      end;
    end;
  end;
end;

procedure TOvcBaseEntryField.WMKillFocus(var Msg : TWMKillFocus);
var
  NewWindow    : HWnd;
  SaveModified : Boolean;
begin
  {where is the focus going?}

  ImeEnter;

  NewWindow := Msg.FocusedWnd;
  if NewWindow = Handle then
    NewWindow := 0
  else if not efIsSibling(NewWindow) then
    NewWindow := 0;

  {retain caret position if focus is moving }
  {to a menu or a component not on this form}
  if (NewWindow = 0) then
    Include(sefOptions, sefRetainPos)
  else
    Exclude(sefOptions, sefRetainPos);

  {destroy caret}
  efCaret.Linked := False;

  {if the mouse if currently captured, release it}
  if MouseCapture then
    MouseCapture := False;

  {perform default processing}
  inherited;

  {set controller's insert mode flag for sibling fields' to access}
  if not ((efoForceInsert in Options) or
          (efoForceOvertype in Options)) then
    {are we in insert mode}
    Controller.InsertMode := sefInsert in sefOptions;

  {if no error is pending for this control...}
  if not (sefErrorPending in sefOptions) and
     not (sefIgnoreFocus in sefOptions) then begin
    Include(sefOptions, sefValPending);

    {and focus is going to a control...}
    if (NewWindow <> 0) then begin
      if sefModified in sefOptions then
        {clear the unitialized option}
        Uninitialized := False;

      {that isn't a Cancel, Restore, or Help button...}
      if not Controller.IsSpecialButton(Msg.FocusedWnd) then begin
        {then validate this field}
        efCanClose(True {validate});
        if sefErrorPending in sefOptions then
          Include(sefOptions, sefValPending)
        else
          Exclude(sefOptions, sefValPending);
      end else begin
        {just call validate field and ignore the error, if any}
        {this forces the field to redisplay using the proper format}
        SaveModified := Modified;
        efValidateField;
        Modified := SaveModified;
      end;
    end;
  end else begin
    {set the validation pending flag on if an error is pending}
    if sefErrorPending in sefOptions then
      Include(sefOptions, sefValPending)
    else
      Exclude(sefOptions, sefValPending);
  end;

  {we no longer have the focus}
  Exclude(sefOptions, sefHaveFocus);

  {if we're not coming back...}
  if (NewWindow <> 0) and not (sefRetainPos in sefOptions) and
                   not (sefIgnoreFocus in sefOptions) then begin
    efPerformPostEditNotify(FindControl(Msg.FocusedWnd));
  end;
  Exclude(sefOptions, sefIgnoreFocus);

  {reset the caret position}
  if not (sefRetainPos in sefOptions) then
    efCaretToStart;

  {redraw the field}
  Refresh;
end;

procedure TOvcBaseEntryField.WMLButtonDblClk(var Msg : TWMLButtonDblClk);
begin
  if sefHaveFocus in sefOptions then
    efPerformEdit(TMessage(Msg), ccDblClk);

  inherited;
end;

procedure TOvcBaseEntryField.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  inherited;

  if not (sefHaveFocus in sefOptions) then begin
    Include(sefOptions, sefNoHighlight);
    SetSelection(0, 0);
    if not Focused then
      SetFocus;
  end;

//  inherited;

  if sefHaveFocus in sefOptions then
    efPerformEdit(TMessage(Msg), ccMouse);
end;

procedure TOvcBaseEntryField.WMMouseActivate(var Msg : TWMMouseActivate);
begin
  if csDesigning in ComponentState then
    Exit;

  inherited;
end;

procedure TOvcBaseEntryField.WMMouseMove(var Msg : TWMMouseMove);
begin
  inherited;

  if MouseCapture then
    if GetAsyncKeyState(GetLeftButton) and $8000 <> 0 then
      efPerformEdit(TMessage(Msg), ccMouseMove);
end;

procedure TOvcBaseEntryField.WMPaste(var Msg : TWMPaste);
  {-paste text in the clipboard into the field}
var
  H  : THandle;
begin
  H := Clipboard.GetAsHandle(CF_UNICODETEXT);
  if H <> 0 then begin
    TMessage(Msg).lParam := Integer(GlobalLock(H));
    efPerformEdit(TMessage(Msg), ccPaste);
    GlobalUnlock(H);
  end;
end;

procedure TOvcBaseEntryField.WMRButtonUp(var Msg : TWMRButtonDown);
var
  P  : TPoint;
  M  : TPopUpMenu;
  MI : TMenuItem;
begin
  if not (sefHaveFocus in sefOptions) then
    if not Focused and CanFocus then
      SetFocus;

  inherited;
  if PopUpMenu = nil then begin
    M := TPopupMenu.Create(Self);
    try
      MI := TMenuItem.Create(M);
      MI.Caption := GetOrphStr(SCRestoreMI);
      MI.Enabled := Modified;
      MI.OnClick := DoRestoreClick;
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := '-';
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := GetOrphStr(SCCutMI);
      MI.Enabled := (SelectionLength > 0) and not efIsReadOnly;
      MI.OnClick := DoCutClick;
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := GetOrphStr(SCCopyMI);
      MI.Enabled := SelectionLength > 0;
      MI.OnClick := DoCopyClick;
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := GetOrphStr(SCPasteMI);
      MI.Enabled := not efIsReadOnly and Clipboard.HasFormat(CF_TEXT);
      MI.OnClick := DoPasteClick;
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := GetOrphStr(SCDeleteMI);
      MI.Enabled := (SelectionLength > 0) and not efIsReadOnly;
      MI.OnClick := DoDeleteClick;
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := '-';
      M.Items.Add(MI);

      MI := TMenuItem.Create(M);
      MI.Caption := GetOrphStr(SCSelectAllMI);
      MI.Enabled := Integer(StrLen(efEditSt)) > SelectionLength;
      MI.OnClick := DoSelectAllClick;
      M.Items.Add(MI);

      P.X := Msg.XPos;
      P.Y := Msg.YPos;
      P := ClientToScreen(P);
      M.PopUp(P.X, P.Y);

      Application.ProcessMessages;
    finally
      M.Free;
    end;
  end;
end;

procedure TOvcBaseEntryField.WMSetFocus(var Msg : TWMSetFocus);
var
  Highlight,
  Ignore,
  FixHOfs,
  ValPending : Boolean;
  PF         : TForm;
  P          : TPoint;
begin
  if ((csLoading in ComponentState) or
      (csDesigning in ComponentState)) then
    Exit;

  {we have the focus}
  Include(sefOptions, sefHaveFocus);

  {reset command processor}
  Controller.EntryCommands.ResetCommandProcessor;

  {get validation state}
  ValPending := sefValPending in sefOptions;

  {calling Show forces the parent to do whatever is necessary to}
  {make sure that we are visible. In the case where the entry}
  {field is on a non-visible notebook page that has had its}
  {handle deallocated, this insures that the page is made visible}
  {and that the window handles have been created}

  {if focus is retruning because of an error condition}
  if ValPending then begin

    {tell the control that lost the focus to}
    {cancel any special modes it might be in}
    if Msg.FocusedWnd > 0 then begin
      SendMessage(Msg.FocusedWnd, WM_CANCELMODE, 0, 0);
      GetCursorPos(P);
      {send a fake mouse up message to force release of mouse capture}
      {this is necessary so that the TStringGrid exits highlight mode}
      SendMessage(Msg.FocusedWnd, WM_LBUTTONUP, 0, MakeLong(P.X, P.Y));
    end;

    Show;
    PF := TForm(GetParentForm(Self));
    if Assigned(PF) then
      PF.FocusControl(Self);
  end;

  {get the field's insert mode}
  if not ((efoForceInsert in Options) or
          (efoForceOvertype in Options)) then
    if Controller.InsertMode then
      Include(sefOptions, sefInsert)
    else
      Exclude(sefOptions, sefInsert);

  if sefRetainPos in sefOptions then begin
    Highlight := False;
    FixHOfs := False;
    Ignore := False;
  end else begin
    Ignore := Controller.ErrorPending and {not us} (FLastError = 0);
    if not Ignore then begin
      if not ValPending then
        Exclude(sefOptions, sefModified);
      efPerformPreEditNotify(FindControl(Msg.FocusedWnd));
      {save a copy of the current edit string}
      efSaveEditString;
    end;

    if sefNoHighlight in sefOptions then begin
      Highlight := False;
      FixHOfs := False;
    end else begin
      Highlight := (not Ignore);
      FixHOfs := True;
      efResetCaret;
      { 07/2011 AB: When selecting a new cell, the caret is set to the start/end of
          the field by 'efResetCaret'; to avoid strange effects when selecting text
          (using <shift>-<crsr left> or <shift>-<crsr right>) we have to reset the
          selection, too. }
      if (efoCaretToEnd in FOptions) then
        SetSelection(MaxEditLen, MaxEditLen)
      else
        SetSelection(0, 0);
    end;
  end;

  if Ignore and not (efoSoftValidation in Options) then
    Include(sefOptions, sefIgnoreFocus)
  else
    Exclude(sefOptions, sefIgnoreFocus);

  Exclude(sefOptions, sefErrorPending);
  Exclude(sefOptions, sefRetainPos);
  Exclude(sefOptions, sefNoHighlight);
  Exclude(sefOptions, sefValPending);

  {clear controller's error pending flag}
  if not Ignore then
    Controller.ErrorPending := False;

  inherited;

  if (efoForceInsert in Options) then
    Include(sefOptions, sefInsert)
  else if (efoForceOvertype in Options) then
    Exclude(sefOptions, sefInsert);

  efCaret.Linked := True;
  efCaret.Visible := True;
  efCaret.InsertMode := (sefInsert in sefOptions);
  efPositionCaret(FixHOfs);

  if Highlight and (efoAutoSelect in Controller.EntryOptions) then
    SetSelection(0, MaxEditLen);

  Refresh;
end;

procedure TOvcBaseEntryField.WMSetFont(var Msg : TWMSetFont);
begin
  inherited;

  {inherited WMSetFont sets our font. Set it as our canvas font}
  Canvas.Font := Font;
end;

procedure TOvcBaseEntryField.WMSetText(var Msg : TWMSetText);
begin
  if HandleAllocated then begin
    SetSelection(0, MaxEditLen);
    efPerformEdit(TMessage(Msg), ccPaste);
  end;
end;

procedure TOvcBaseEntryField.WMSize(var Msg : TWMSize);
begin
  inherited;

  Refresh;
end;

procedure TOvcBaseEntryField.WMSysKeyDown(var Msg : TWMSysKeyDown);
var
  Cmd : Word;
begin
  inherited;

  {exit if this is a Tab key or an Alt key by itself}
  if (Msg.CharCode = VK_TAB) or (Msg.CharCode = VK_ALT) then
    Exit;

  {see if this command should be processed by us}
  Cmd := Controller.EntryCommands.TranslateKey(Msg.CharCode, [ssAlt]);

  {convert undo to restore since ctrl-Z is mapped to ccUndo by default}
  {and cannot be mapped to more than one command in a command table}
  if Cmd = ccUndo then
    Cmd := ccRestore;

  if Cmd <> ccNone then begin
    case Cmd of
      ccCut   : WMCut(TWMCut(Msg));
      ccCopy  : WMCopy(TWMCopy(Msg));
      ccPaste : WMPaste(TWMPaste(Msg));
    else
      efPerformEdit(TMessage(Msg), Cmd);
    end;

    {allow entering of characters using Alt-keypad numbers}
    case Msg.CharCode of
      vk_NumPad0, vk_NumPad1, vk_NumPad2, vk_NumPad3, vk_NumPad4,
      vk_NumPad5, vk_NumPad6, vk_NumPad7, vk_NumPad8, vk_NumPad9:
        begin
          Include(sefOptions, sefCharOk);
          Include(sefOptions, sefAcceptChar);
        end;
    end;
  end;
end;


end.
