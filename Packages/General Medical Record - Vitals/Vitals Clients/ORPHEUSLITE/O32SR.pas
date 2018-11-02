{*********************************************************}
{*                    O32SR.PAS 4.06                     *}
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

(*  Replaces the old String Resource Manager from Orpheus versions 3.x and
    below.  The string resource is broken into 3 parts.
      Part 1: The actual string resources contained in O32***RS.inc
        (O32ENGRS.inc for English). (Translate these strings and define the
        language below to create new language versions of Orpheus.)
      Part 2: The index constants defined in OvcConst.pas.
      Part 3: The cross reference array (SrMsgNumLookup) used to convert an
        index into the corresponding string.
    It is very important that the cross reference array be kept in numerical
    order. The lookup is performed by a binary search and if any of the items
    are out of order, the lookup will fail some or all strings.  *)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit o32sr;
  {- Orpheus String Resources
     Replaces the String Resource Manager from the olden days...}

interface

uses
  ovcconst;

{$I O32SR.INC}

resourcestring

{Orpheus Internal and Design-time resource strings...}

{!!!! - These should not be translated as they are used internally - !!!!}
{!!!! - See O32SR.INC for the user visible resource strings - !!!!}

  {Navigation Commands}
  ccNoneStr                 = 'ccNone';
  ccBackStr                 = 'ccBack';
  ccBotOfPageStr            = 'ccBotOfPage';
  ccBotRightCellStr         = 'ccBotRightCell';
  ccCompleteDateStr         = 'ccCompleteDate';
  ccCompleteTimeStr         = 'ccCompleteTime';
  ccCopyStr                 = 'ccCopy';
  ccCtrlCharStr             = 'ccCtrlChar';
  ccCutStr                  = 'ccCut';
  ccDecStr                  = 'ccDec';
  ccDelStr                  = 'ccDel';
  ccDelBolStr               = 'ccDelBol';
  ccDelEolStr               = 'ccDelEol';
  ccDelLineStr              = 'ccDelLine';
  ccDelWordStr              = 'ccDelWord';
  ccDownStr                 = 'ccDown';
  ccEndStr                  = 'ccEnd';
  ccExtendDownStr           = 'ccExtendDown';
  ccExtendEndStr            = 'ccExtendEnd';
  ccExtendHomeStr           = 'ccExtendHome';
  ccExtendLeftStr           = 'ccExtendLeft';
  ccExtendPgDnStr           = 'ccExtendPgDn';
  ccExtendPgUpStr           = 'ccExtendPgUp';
  ccExtendRightStr          = 'ccExtendRight';
  ccExtendUpStr             = 'ccExtendUp';
  ccExtBotOfPageStr         = 'ccExtBotOfPage';
  ccExtFirstPageStr         = 'ccExtFirstPage';
  ccExtLastPageStr          = 'ccExtLastPage';
  ccExtTopOfPageStr         = 'ccExtTopOfPage';
  ccExtWordLeftStr          = 'ccExtWordLeft';
  ccExtWordRightStr         = 'ccExtWordRight';
  ccFirstPageStr            = 'ccFirstPage';
  ccGotoMarker0Str          = 'ccGotoMarker0';
  ccGotoMarker1Str          = 'ccGotoMarker1';
  ccGotoMarker2Str          = 'ccGotoMarker2';
  ccGotoMarker3Str          = 'ccGotoMarker3';
  ccGotoMarker4Str          = 'ccGotoMarker4';
  ccGotoMarker5Str          = 'ccGotoMarker5';
  ccGotoMarker6Str          = 'ccGotoMarker6';
  ccGotoMarker7Str          = 'ccGotoMarker7';
  ccGotoMarker8Str          = 'ccGotoMarker8';
  ccGotoMarker9Str          = 'ccGotoMarker9';
  ccHomeStr                 = 'ccHome';
  ccIncStr                  = 'ccInc';
  ccInsStr                  = 'ccIns';
  ccLastPageStr             = 'ccLastPage';
  ccLeftStr                 = 'ccLeft';
  ccNewLineStr              = 'ccNewLine';
  ccNextPageStr             = 'ccNextPage';
  ccPageLeftStr             = 'ccPageLeft';
  ccPageRightStr            = 'ccPageRight';
  ccPasteStr                = 'ccPaste';
  ccPrevPageStr             = 'ccPrevPage';
  ccRedoStr                 = 'ccRedo';
  ccRestoreStr              = 'ccRestore';
  ccRightStr                = 'ccRight';
  ccScrollDownStr           = 'ccScrollDown';
  ccScrollUpStr             = 'ccScrollUp';
  ccSetMarker0Str           = 'ccSetMarker0';
  ccSetMarker1Str           = 'ccSetMarker1';
  ccSetMarker2Str           = 'ccSetMarker2';
  ccSetMarker3Str           = 'ccSetMarker3';
  ccSetMarker4Str           = 'ccSetMarker4';
  ccSetMarker5Str           = 'ccSetMarker5';
  ccSetMarker6Str           = 'ccSetMarker6';
  ccSetMarker7Str           = 'ccSetMarker7';
  ccSetMarker8Str           = 'ccSetMarker8';
  ccSetMarker9Str           = 'ccSetMarker9';
  ccTabStr                  = 'ccTab';
  ccTableEditStr            = 'ccTableEdit';
  ccTopLeftCellStr          = 'ccTopLeftCell';
  ccTopOfPageStr            = 'ccTopOfPage';
  ccUndoStr                 = 'ccUndo';
  ccUpStr                   = 'ccUp';
  ccWordLeftStr             = 'ccWordLeft';
  ccWordRightStr            = 'ccWordRight';

  {DataType strings}
  StringStr                 = 'String';
  CharStr                   = 'Char';
  BooleanStr                = 'Boolean';
  YesNoStr                  = 'YesNo';
  LongIntStr                = 'LongInt';
  WordStr                   = 'Word';
  SmallIntStr               = 'SmallInt';
  ByteStr                   = 'Byte';
  ShortIntStr               = 'ShortInt';
  RealStr                   = 'Real';
  ExtendedStr               = 'Extended';
  DoubleStr                 = 'Double';
  SingleStr                 = 'Single';
  CompStr                   = 'Comp';
  DateStr                   = 'Date';
  TimeStr                   = 'Time';

  {Sample masks for the EditField's property editors}
  CharMask1Str              = 'X  any character';
  CharMask2Str              = '!  any char (upper)';
  CharMask3Str              = 'L  any char (lower)';
  CharMask4Str              = 'x  any char (mixed)';
  CharMask5Str              = 'a  alphas only';
  CharMask6Str              = 'A  alphas (upper)';
  CharMask7Str              = 'l  alphas (lower)';
  CharMask8Str              = '9  0-9';
  CharMask9Str              = 'i  0-9, -';
  CharMask10Str             = '#  0-9, -, .';
  CharMask11Str             = 'E  0-9, E, -, .';
  CharMask12Str             = 'K  0-9, A-F (hex)';
  CharMask14Str             = 'O  0-7 (octal)';
  CharMask15Str             = 'b  0, 1 (binary)';
  CharMask16Str             = 'B  T or F (upper)';
  CharMask17Str             = 'Y  Y or N (upper)';
  CharMask18Str             = '1  User 1';
  CharMask19Str             = '2  User 2';
  CharMask20Str             = '3  User 3';
  CharMask21Str             = '4  User 4';
  CharMask22Str             = '5  User 5';
  CharMask23Str             = '6  User 6';
  CharMask24Str             = '7  User 7';
  CharMask25Str             = '8  User 8';

  FieldMask1Str             = '$##,###.##          Allows entry of 0 through 9, space, minus, and period Uses floating currency symbol';
  FieldMask2Str             = '9999999999          Allows entry of 0 through 9, and space';
  FieldMask3Str             = 'iiiiiiiiii          Allows entry of 0 through 9, space, and minus';
  FieldMask4Str             = 'ii,iii,iii          Allows entry of 0 through 9, space, and minus Displays number separators as needed';
  FieldMask5Str             = '$iiiiiiiii          Allows entry of 0 through 9, space, and minus Uses floating currency symbol';
  FieldMask6Str             = '##########          Allows entry of 0 through 9, space, minus, and period';
  FieldMask7Str             = '#######.##          Allows entry of 0 through 9, space, minus, and period Fixed decimal position';
  FieldMask8Str             = '###,###.##          Allows entry of 0 through 9, space, minus, and period Displays number separators as needed';
  FieldMask9Str             = '$######.##          Allows entry of 0 through 9, space, minus, and period Fixed decimal position Uses floating currency symbol';
  FieldMask10Str            = '##########p         Allows entry of 0 through 9, space, minus, and period Negative amounts use ()';
  FieldMask11Str            = '###,###.##C         Allows entry of 0 through 9, space, minus, and period Currency symbol at right';
  FieldMask12Str            = 'KKKKKKKK            Hexadecimal (E4401F3E) Allows entry of 0 through 9 and A through F Force upper case';
  FieldMask13Str            = 'KKKK                Hexadecimal (1F3E) Allows entry of 0 through 9 and A through F Force upper case';
  FieldMask14Str            = 'KK                  Hexadecimal (3E) Allows entry of 0 through 9 and A through F Force upper case';
  FieldMask15Str            = 'OOOOOOOO            Octal (45135677) Allows entry of 0 through 7 ';
  FieldMask16Str            = 'OOOO                Octal (5677) Allows entry of 0 through 7 ';
  FieldMask17Str            = 'bbbbbbbbbbbbbbbb    Binary (0101001010010100) Allows entry of 0 and 1';
  FieldMask18Str            = 'bbbbbbbb            Binary (10010100) Allows entry of 0 and 1';
  FieldMask19Str            = 'XXXXXXXXXX          Any character can be entered';
  FieldMask20Str            = '!!!!!!!!!!          Any character can be entered Alphabetic characters are forced to upper case';
  FieldMask21Str            = 'LLLLLLLLLL          Any character can be entered Alphabetic characters are forced to lower case';
  FieldMask22Str            = 'xxxxxxxxxx          Any character can be entered Uses mixed case';
  FieldMask23Str            = 'aaaaaaaaaa          Alphabetic characters plus space, minus, period, and comma';
  FieldMask24Str            = 'AAAAAAAAAA          Alphabetic characters plus space, minus, period, and comma Alphabetic characters are forced to upper case';
  FieldMask25Str            = 'llllllllll          Alphabetic characters plus space, minus, period, and comma Alphabetic characters are forced to lower case';
  FieldMask26Str            = '(999) 999-9999      Phone number mask Allows 0 through 9 and space';
  FieldMask27Str            = '999-999-9999        Phone number mask Allows 0 through 9 and space';
  FieldMask28Str            = '99999-9999          US Zip Code mask Allows 0 through 9 and space';
  FieldMask29Str            = 'B                   Boolean mask Allows T, t, F, f Forces input to upper case';
  FieldMask30Str            = 'Y                   Boolean mask Allows Y, y, N, n Forces input to upper case';
  FieldMask31Str            = 'mm/dd/yy            Date mask (01/05/96) Allows entry of 0 through 9 plus space Month and Day are padded with zeros';
  FieldMask32Str            = 'mm/dd/yyyy          Date mask (01/05/1996) Allows entry of 0 through 9 plus space Month and Day are padded with zeros';
  FieldMask33Str            = 'dd nnn yyyy         Date mask (05 Jan 1996) Allows entry of 0 through 9 plus space Day is padded with zeros';
  FieldMask34Str            = 'MM/DD/yy            Date mask ( 1/ 5/96) Allows entry of 0 through 9 plus space Month and Day are padded with spaces';
  FieldMask35Str            = 'MM/DD/yyyy          Date mask ( 1/ 5/1996) Allows entry of 0 through 9 plus space Month and Day are padded with spaces';
  FieldMask36Str            = 'DD nnn yyyy         Date mask ( 5 Jan 1996) Allows entry of 0 through 9 plus space Day is padded with spaces';
  FieldMask37Str            = 'hh:mm               Time mask (03:25) Allows entry of 0 through 9 plus space Hours and minutes are padded with zeros (24 hour clock)';
  FieldMask38Str            = 'hh:mm tt            Time mask (03:25 pm) Allows entry of 0 through 9 plus space Hours and minutes are padded with zeros';
  FieldMask39Str            = 'hh:mm:ss            Time mask (03:25:07) Allows entry of 0 through 9 plus space Hours, minutes, and seconds are padded with zeros';
  FieldMask40Str            = 'HH:MM               Time mask ( 3:25) Allows entry of 0 through 9 plus space Hours and minutes are padded with spaces (24 hour clock)';
  FieldMask41Str            = 'HH:MM tt            Time mask ( 3:25 pm) Allows entry of 0 through 9 plus space Hours and minutes are padded with spaces';
  FieldMask42Str            = 'HH:MM:SS            Time mask ( 3:25: 7) Allows entry of 0 through 9 plus space Hours, minutes, and seconds are padded with spaces';

const
  {Change this when new strings are added.}
  SrMaxMessages             = 375;

type
  SrMsgNumLookupRec = record
    MessageNum : integer;
    MessageStr : string;
  end;

const
  {Matches the index numbers to their associated Strings}

  {WARNING!  When adding to or deleting from this array, make sure you keep the
   items in ascending numerical order by the value of the MessageNum constants.
   Otherwise, the Lookup will fail some or all strings...}

  SrMsgNumLookup : array [1..SrMaxMessages] of SrMsgNumLookupRec =
  {External Resource String Mapping. External resource strings are contained in
   O32SR.INC...}
    ((MessageNum : SCUnknownError;            MessageStr : RSUnknownError),
     (MessageNum : SCDuplicateCommand;        MessageStr : RSDuplicateCommand),
     (MessageNum : SCTableNotFound;           MessageStr : RSTableNotFound),
     (MessageNum : SCNotDoneYet;              MessageStr : RSNotDoneYet),
     (MessageNum : SCNoControllerAssigned;    MessageStr : RSNoControllerAssigned),
     (MessageNum : SCCantCreateCommandTable;  MessageStr : RSCantCreateCommandTable),
     (MessageNum : SCCantDelete;              MessageStr : RSCantDelete),
     (MessageNum : SCInvalidKeySequence;      MessageStr : RSInvalidKeySequence),
     (MessageNum : SCNotWordStarCommands;     MessageStr : RSNotWordStarCommands),
     (MessageNum : SCNoCommandSelected;       MessageStr : RSNoCommandSelected),
     (MessageNum : SCDuplicateKeySequence;    MessageStr : RSDuplicateKeySequence),
     (MessageNum : SCRangeError;              MessageStr : RSRangeError),
     (MessageNum : SCInvalidNumber;           MessageStr : RSInvalidNumber),
     (MessageNum : SCRequiredField;           MessageStr : RSRequiredField),
     (MessageNum : SCInvalidDate;             MessageStr : RSInvalidDate),
     (MessageNum : SCInvalidTime;             MessageStr : RSInvalidTime),
     (MessageNum : SCBlanksInField;           MessageStr : RSBlanksInField),
     (MessageNum : SCPartialEntry;            MessageStr : RSPartialEntry),
     (MessageNum : SCRegionTooLarge;          MessageStr : RSRegionTooLarge),
     (MessageNum : SCOutOfMemoryForCopy;      MessageStr : RSOutOfMemoryForCopy),
     (MessageNum : SCInvalidParamValue;       MessageStr : RSInvalidParamValue),
     (MessageNum : SCNoTimersAvail;           MessageStr : RSNoTimersAvail),
     (MessageNum : SCTooManyEvents;           MessageStr : RSTooManyEvents),
     (MessageNum : SCBadTriggerHandle;        MessageStr : RSBadTriggerHandle),
     (MessageNum : SCOnSelectNotAssigned;     MessageStr : RSOnSelectNotAssigned),
     (MessageNum : SCInvalidPageIndex;        MessageStr : RSInvalidPageIndex),
     (MessageNum : SCInvalidDataType;         MessageStr : RSInvalidDataType),
     (MessageNum : SCInvalidTabFont;          MessageStr : RSInvalidTabFont),
     (MessageNum : SCInvalidLabelFont;        MessageStr : RSInvalidLabelFont),
     (MessageNum : SCOutOfMemory;             MessageStr : RSOutOfMemory),
     (MessageNum : SCTooManyParas;            MessageStr : RSTooManyParas),
     (MessageNum : SCCannotJoin;              MessageStr : RSCannotJoin),
     (MessageNum : SCTooManyBytes;            MessageStr : RSTooManyBytes),
     (MessageNum : SCParaTooLong;             MessageStr : RSParaTooLong),
     (MessageNum : SCInvalidPictureMask;      MessageStr : RSInvalidPictureMask),
     (MessageNum : SCInvalidRange;            MessageStr : RSInvalidRange),
     (MessageNum : SCInvalidRealRange;        MessageStr : RSInvalidRealRange),
     (MessageNum : SCInvalidExtendedRange;    MessageStr : RSInvalidExtendedRange),
     (MessageNum : SCInvalidDoubleRange;      MessageStr : RSInvalidDoubleRange),
     (MessageNum : SCInvalidSingleRange;      MessageStr : RSInvalidSingleRange),
     (MessageNum : SCInvalidCompRange;        MessageStr : RSInvalidCompRange),
     (MessageNum : SCInvalidDateRange;        MessageStr : RSInvalidDateRange),
     (MessageNum : SCInvalidTimeRange;        MessageStr : RSInvalidTimeRange),
     (MessageNum : SCInvalidRangeValue;       MessageStr : RSInvalidRangeValue),
     (MessageNum : SCRangeNotSupported;       MessageStr : RSRangeNotSupported),
     (MessageNum : SCInvalidLineOrParaIndex;  MessageStr : RSInvalidLineOrParaIndex),
     (MessageNum : SCNonFixedFont;            MessageStr : RSNonFixedFont),
     (MessageNum : SCInvalidFontParam;        MessageStr : RSInvalidFontParam),
     (MessageNum : SCInvalidLineOrColumn;     MessageStr : RSInvalidLineOrColumn),
     (MessageNum : SCSAEGeneral;              MessageStr : RSSAEGeneral),
     (MessageNum : SCSAEAtMaxSize;            MessageStr : RSSAEAtMaxSize),
     (MessageNum : SCInvalidXMLFile;          MessageStr : RSInvalidXMLFile),
     (MessageNum : SCUnterminatedElement;     MessageStr : RSUnterminatedElement),
     (MessageNum : SCBadColorConst;           MessageStr : RSBadColorConstant),
     (MessageNum : SCBadColorValue;           MessageStr : RSBadColorValue),
     (MessageNum : SCSAEOutOfBounds;          MessageStr : RSSAEOutOfBounds),
     (MessageNum : SCInvalidFieldType;        MessageStr : RSInvalidFieldType),
     (MessageNum : SCBadAlarmHandle;          MessageStr : RSBadAlarmHandle),
     (MessageNum : SCOnIsSelectedNotAssigned; MessageStr : RSOnIsSelectedNotAssigned),
     (MessageNum : SCInvalidDateForMask;      MessageStr : RSInvalidDateForMask),
     (MessageNum : SCNoTableAttached;         MessageStr : RSNoTableAttached),
     (MessageNum : SCViewerIOError;           MessageStr : RSViewerIOError),
     (MessageNum : SCViewerFileNotFound;      MessageStr : RSViewerFileNotFound),
     (MessageNum : SCViewerPathNotFound;      MessageStr : RSViewerPathNotFound),
     (MessageNum : SCViewerTooManyOpenFiles;  MessageStr : RSViewerTooManyOpenFiles),
     (MessageNum : SCViewerFileAccessDenied;  MessageStr : RSViewerFileAccessDenied),
     (MessageNum : SCControlAttached;         MessageStr : RSControlAttached),
     (MessageNum : SCCantEdit;                MessageStr : RSCantEdit),
     (MessageNum : SCChildTableError;         MessageStr : RSChildTableError),
     (MessageNum : SCNoCollection;            MessageStr : RSNoCollection),
     (MessageNum : SCNotOvcDescendant;        MessageStr : RSNotOvcDescendant),
     (MessageNum : SCItemIncompatible;        MessageStr : RSItemIncompatible),
     (MessageNum : SCLabelNotAttached;        MessageStr : RSLabelNotAttached),
     (MessageNum : SCClassNotSet;             MessageStr : RSClassNotSet),
     (MessageNum : SCCollectionNotFound;      MessageStr : RSCollectionNotFound),
     (MessageNum : SCDayConvertError;         MessageStr : RSDayConvertError),
     (MessageNum : SCMonthConvertError;       MessageStr : RSMonthConvertError),
     (MessageNum : SCMonthNameConvertError;   MessageStr : RSMonthNameConvertError),
     (MessageNum : SCYearConvertError;        MessageStr : RSYearConvertError),
     (MessageNum : SCDayRequired;             MessageStr : RSDayRequired),
     (MessageNum : SCMonthRequired;           MessageStr : RSMonthRequired),
     (MessageNum : SCYearRequired;            MessageStr : RSYearRequired),
     (MessageNum : SCInvalidDay;              MessageStr : RSInvalidDay),
     (MessageNum : SCInvalidMonth;            MessageStr : RSInvalidMonth),
     (MessageNum : SCInvalidMonthName;        MessageStr : RSInvalidMonthName),
     (MessageNum : SCInvalidYear;             MessageStr : RSInvalidYear),
     (MessageNum : SCTableRowOutOfBounds;     MessageStr : RSTableRowOutOfBounds),
     (MessageNum : SCTableMaxRows;            MessageStr : RSTableMaxRows),
     (MessageNum : SCTableMaxColumns;         MessageStr : RSTableMaxColumns),
     (MessageNum : SCTableGeneral;            MessageStr : RSTableGeneral),
     (MessageNum : SCTableToManyColumns;      MessageStr : RSTableToManyColumns),
     (MessageNum : SCTableInvalidFieldIndex;  MessageStr : RSTableInvalidFieldIndex),
     (MessageNum : SCTableHeaderNotAssigned;  MessageStr : RSTableHeaderNotAssigned),
     (MessageNum : SCTableInvalidHeaderCell;  MessageStr : RSTableInvalidHeaderCell),
     (MessageNum : SCGridTableName;           MessageStr : RSGridTableName),
     (MessageNum : SCNoneStr;                 MessageStr : RSNoneStr),
     (MessageNum : SCccUser;                  MessageStr : RSccUser),
     (MessageNum : SCccUserNum;               MessageStr : RSccUserNum),
     (MessageNum : SCDeleteTable;             MessageStr : RSDeleteTable),
     (MessageNum : SCRenameTable;             MessageStr : RSRenameTable),
     (MessageNum : SCEnterTableName;          MessageStr : RSEnterTableName),
     (MessageNum : SCNewTable;                MessageStr : RSNewTable),
     (MessageNum : SCDefaultTableName;        MessageStr : RSDefaultTableName),
     (MessageNum : SCWordStarTableName;       MessageStr : RSWordStarTableName ),
     (MessageNum : SCUnknownTable;            MessageStr : RSUnknownTable),
     (MessageNum : SCDefaultEntryErrorText;   MessageStr : RSDefaultEntryErrorText),
     (MessageNum : SCGotItemWarning;          MessageStr : RSGotItemWarning),
     (MessageNum : SCSampleListItem;          MessageStr : RSSampleListItem),
     (MessageNum : SCAlphaString;             MessageStr : RSAlphaString),
     (MessageNum : SCTallLowChars;            MessageStr : RSTallLowChars),
     (MessageNum : SCDefault;                 MessageStr : RSDefault),
     (MessageNum : SCDescending;              MessageStr : RSDescending),
     (MessageNum : SCDefaultIndex;            MessageStr : RSDefaultIndex),
     (MessageNum : SCRestoreMI;               MessageStr : RSRestoreMI),
     (MessageNum : SCCutMI;                   MessageStr : RSCutMI),
     (MessageNum : SCCopyMI;                  MessageStr : RSCopyMI),
     (MessageNum : SCPasteMI;                 MessageStr : RSPasteMI),
     (MessageNum : SCDeleteMI;                MessageStr : RSDeleteMI),
     (MessageNum : SCSelectAllMI;             MessageStr : RSSelectAllMI),
     (MessageNum : SCCalcBack;                MessageStr : RSCalcBack),
     (MessageNum : SCCalcMC;                  MessageStr : RSCalcMC),
     (MessageNum : SCCalcMR;                  MessageStr : RSCalcMR),
     (MessageNum : SCCalcMS;                  MessageStr : RSCalcMS),
     (MessageNum : SCCalcMPlus;               MessageStr : RSCalcMPlus),
     (MessageNum : SCCalcMMinus;              MessageStr : RSCalcMMinus),
     (MessageNum : SCCalcCT;                  MessageStr : RSCalcCT),
     (MessageNum : SCCalcCE;                  MessageStr : RSCalcCE),
     (MessageNum : SCCalcC;                   MessageStr : RSCalcC),
     (MessageNum : SCCalcSqrt;                MessageStr : RSCalcSqrt),
     (MessageNum : SCCalNext;                 MessageStr : RSCalNext),
     (MessageNum : SCCalLast;                 MessageStr : RSCalLast),
     (MessageNum : SCCalFirst;                MessageStr : RSCalFirst),
     (MessageNum : SCCal1st;                  MessageStr : RSCal1st),
     (MessageNum : SCCalSecond;               MessageStr : RSCalSecond),
     (MessageNum : SCCal2nd;                  MessageStr : RSCal2nd),
     (MessageNum : SCCalThird;                MessageStr : RSCalThird),
     (MessageNum : SCCal3rd;                  MessageStr : RSCal3rd),
     (MessageNum : SCCalFourth;               MessageStr : RSCalFourth),
     (MessageNum : SCCal4th;                  MessageStr : RSCal4th),
     (MessageNum : SCCalFinal;                MessageStr : RSCalFinal),
     (MessageNum : SCCalBOM;                  MessageStr : RSCalBOM),
     (MessageNum : SCCalEnd;                  MessageStr : RSCalEnd),
     (MessageNum : SCCalEOM;                  MessageStr : RSCalEOM),
     (MessageNum : SCCalYesterday;            MessageStr : RSCalYesterday),
     (MessageNum : SCCalToday;                MessageStr : RSCalToday),
     (MessageNum : SCCalTomorrow;             MessageStr : RSCalTomorrow),
     (MessageNum : SCEditingSections;         MessageStr : RSEditingSections),
     (MessageNum : SCEditingItems;            MessageStr : RSEditingItems),
     (MessageNum : SCEditingFolders;          MessageStr : RSEditingFolders),
     (MessageNum : SCEditingPages;            MessageStr : RSEditingPages),
     (MessageNum : SCEditingImages;           MessageStr : RSEditingImages),
     (MessageNum : SCSectionBaseName;         MessageStr : RSSectionBaseName),
     (MessageNum : SCItemBaseName;            MessageStr : RSItemBaseName),
     (MessageNum : SCFolderBaseName;          MessageStr : RSFolderBaseName),
     (MessageNum : SCPageBaseName;            MessageStr : RSPageBaseName),
     (MessageNum : SCImageBaseName;           MessageStr : RSImageBaseName),
     (MessageNum : SCOwnerMustBeForm;         MessageStr : RSOwnerMustBeForm),
     (MessageNum : SCTimeConvertError;        MessageStr : RSTimeConvertError),
     (MessageNum : SCCancelQuery;             MessageStr : RSCancelQuery),
     (MessageNum : SCNoPagesAssigned;         MessageStr : RSNoPagesAssigned),
     (MessageNum : SCCalPrev;                 MessageStr : RSCalPrev),
     (MessageNum : SCCalBegin;                MessageStr : RSCalBegin),
     (MessageNum : SCInvalidMinMaxValue;      MessageStr : RSInvalidMinMaxValue),
     (MessageNum : SCFormUseOnly;             MessageStr : RSFormUseOnly),
     (MessageNum : SCYes;                     MessageStr : RSYes),
     (MessageNum : SCNo;                      MessageStr : RSNo),
     (MessageNum : SCTrue;                    MessageStr : RSTrue),
     (MessageNum : SCFalse;                   MessageStr : RSFalse),
     (MessageNum : SCHoursName;               MessageStr : RSHoursName),
     (MessageNum : SCMinutesName;             MessageStr : RSMinutesName),
     (MessageNum : SCSecondsName;             MessageStr : RSSecondsName),
     (MessageNum : SCCloseCaption;            MessageStr : RSCloseCaption),
     (MessageNum : SCViewFieldNotFound;       MessageStr : RSViewFieldNotFound),
     (MessageNum : SCCantResolveField;        MessageStr : RSCantResolveField),
     (MessageNum : SCItemAlreadyExists;       MessageStr : RSItemAlreadyExists),
     (MessageNum : SCAlreadyInTempMode;       MessageStr : RSAlreadyInTempMode),
     (MessageNum : SCItemNotFound;            MessageStr : RSItemNotFound),
     (MessageNum : SCUpdatePending;           MessageStr : RSUpdatePending),
     (MessageNum : SCOnCompareNotAssigned;    MessageStr : RSOnCompareNotAssigned),
     (MessageNum : SCOnFilterNotAssigned;     MessageStr : RSOnFilterNotAssigned),
     (MessageNum : SCGetAsFloatNotAssigned;   MessageStr : RSGetAsFloatNotAssigned),
     (MessageNum : SCNotInTempMode;           MessageStr : RSNotInTempMode),
     (MessageNum : SCItemNotInIndex;          MessageStr : RSItemNotInIndex),
     (MessageNum : SCNoActiveView;            MessageStr : RSNoActiveView),
     (MessageNum : SCItemIsNotGroup;          MessageStr : RSItemIsNotGroup),
     (MessageNum : SCNotMultiSelect;          MessageStr : RSNotMultiSelect),
     (MessageNum : SCLineNoOutOfRange;        MessageStr : RSLineNoOutOfRange),
     (MessageNum : SCUnknownView;             MessageStr : RSUnknownView),
     (MessageNum : SCOnKeySearchNotAssigned;  MessageStr : RSOnKeySearchNotAssigned),
     (MessageNum : SCOnEnumNotAssigned;       MessageStr : RSOnEnumNotAssigned),
     (MessageNum : SCOnEnumSelectedNA;        MessageStr : RSOnEnumSelectedNA),
     (MessageNum : SCNoMenuAssigned;          MessageStr : RSNoMenuAssigned),
     (MessageNum : SCNoAnchorAssigned;        MessageStr : RSNoAnchorAssigned),
     (MessageNum : SCInvalidParameter;        MessageStr : RSInvalidParameter),
     (MessageNum : SCInvalidOperation;        MessageStr : RSInvalidOperation),
     (MessageNum : SCColorBlack;              MessageStr : RSColorBlack),
     (MessageNum : SCColorMaroon;             MessageStr : RSColorMaroon),
     (MessageNum : SCColorGreen;              MessageStr : RSColorGreen),
     (MessageNum : SCColorOlive;              MessageStr : RSColorOlive),
     (MessageNum : SCColorNavy;               MessageStr : RSColorNavy),
     (MessageNum : SCColorPurple;             MessageStr : RSColorPurple),
     (MessageNum : SCColorTeal;               MessageStr : RSColorTeal),
     (MessageNum : SCColorGray;               MessageStr : RSColorGray),
     (MessageNum : SCColorSilver;             MessageStr : RSColorSilver),
     (MessageNum : SCColorRed;                MessageStr : RSColorRed),
     (MessageNum : SCColorLime;               MessageStr : RSColorLime),
     (MessageNum : SCColorYellow;             MessageStr : RSColorYellow),
     (MessageNum : SCColorBlue;               MessageStr : RSColorBlue),
     (MessageNum : SCColorFuchsia;            MessageStr : RSColorFuchsia),
     (MessageNum : SCColorAqua;               MessageStr : RSColorAqua),
     (MessageNum : SCColorWhite;              MessageStr : RSColorWhite),
     (MessageNum : SCColorLightGray;          MessageStr : RSColorLightGray),
     (MessageNum : SCColorMediumGray;         MessageStr : RSColorMediumGray),
     (MessageNum : SCColorDarkGray;           MessageStr : RSColorDarkGray),
     (MessageNum : SCColorMoneyGreen;         MessageStr : RSColorMoneyGreen),
     (MessageNum : SCColorSkyBlue;            MessageStr : RSColorSkyBlue),
     (MessageNum : SCColorCream;              MessageStr : RSColorCream),

  {End - Resource String Mapping...}

  {Internal Strings}
     (MessageNum : IccNone;                   MessageStr : ccNoneStr),
     (MessageNum : IccBack;                   MessageStr : ccBackStr),
     (MessageNum : IccBotOfPage;              MessageStr : ccBotOfPageStr),
     (MessageNum : IccBotRightCell;           MessageStr : ccBotRightCellStr),
     (MessageNum : IccCompleteDate;           MessageStr : ccCompleteDateStr),
     (MessageNum : IccCompleteTime;           MessageStr : ccCompleteTimeStr),
     (MessageNum : IccCopy;                   MessageStr : ccCopyStr),
     (MessageNum : IccCtrlChar;               MessageStr : ccCtrlCharStr),
     (MessageNum : IccCut;                    MessageStr : ccCutStr),
     (MessageNum : IccDec;                    MessageStr : ccDecStr),
     (MessageNum : IccDel;                    MessageStr : ccDelStr),
     (MessageNum : IccDelBol;                 MessageStr : ccDelBolStr),
     (MessageNum : IccDelEol;                 MessageStr : ccDelEolStr),
     (MessageNum : IccDelLine;                MessageStr : ccDelLineStr),
     (MessageNum : IccDelWord;                MessageStr : ccDelWordStr),
     (MessageNum : IccDown;                   MessageStr : ccDownStr),
     (MessageNum : IccEnd;                    MessageStr : ccEndStr),
     (MessageNum : IccExtendDown;             MessageStr : ccExtendDownStr),
     (MessageNum : IccExtendEnd;              MessageStr : ccExtendEndStr),
     (MessageNum : IccExtendHome;             MessageStr : ccExtendHomeStr),
     (MessageNum : IccExtendLeft;             MessageStr : ccExtendLeftStr),
     (MessageNum : IccExtendPgDn;             MessageStr : ccExtendPgDnStr),
     (MessageNum : IccExtendPgUp;             MessageStr : ccExtendPgUpStr),
     (MessageNum : IccExtendRight;            MessageStr : ccExtendRightStr),
     (MessageNum : IccExtendUp;               MessageStr : ccExtendUpStr),
     (MessageNum : IccExtBotOfPage;           MessageStr : ccExtBotOfPageStr),
     (MessageNum : IccExtFirstPage;           MessageStr : ccExtFirstPageStr),
     (MessageNum : IccExtLastPage;            MessageStr : ccExtLastPageStr),
     (MessageNum : IccExtTopOfPage;           MessageStr : ccExtTopOfPageStr),
     (MessageNum : IccExtWordLeft;            MessageStr : ccExtWordLeftStr),
     (MessageNum : IccExtWordRight;           MessageStr : ccExtWordRightStr),
     (MessageNum : IccFirstPage;              MessageStr : ccFirstPageStr),
     (MessageNum : IccGotoMarker0;            MessageStr : ccGotoMarker0Str),
     (MessageNum : IccGotoMarker1;            MessageStr : ccGotoMarker1Str),
     (MessageNum : IccGotoMarker2;            MessageStr : ccGotoMarker2Str),
     (MessageNum : IccGotoMarker3;            MessageStr : ccGotoMarker3Str),
     (MessageNum : IccGotoMarker4;            MessageStr : ccGotoMarker4Str),
     (MessageNum : IccGotoMarker5;            MessageStr : ccGotoMarker5Str),
     (MessageNum : IccGotoMarker6;            MessageStr : ccGotoMarker6Str),
     (MessageNum : IccGotoMarker7;            MessageStr : ccGotoMarker7Str),
     (MessageNum : IccGotoMarker8;            MessageStr : ccGotoMarker8Str),
     (MessageNum : IccGotoMarker9;            MessageStr : ccGotoMarker9Str),
     (MessageNum : IccHome;                   MessageStr : ccHomeStr),
     (MessageNum : IccInc;                    MessageStr : ccIncStr),
     (MessageNum : IccIns;                    MessageStr : ccInsStr),
     (MessageNum : IccLastPage;               MessageStr : ccLastPageStr),
     (MessageNum : IccLeft;                   MessageStr : ccLeftStr),
     (MessageNum : IccNewLine;                MessageStr : ccNewLineStr),
     (MessageNum : IccNextPage;               MessageStr : ccNextPageStr),
     (MessageNum : IccPageLeft;               MessageStr : ccPageLeftStr),
     (MessageNum : IccPageRight;              MessageStr : ccPageRightStr),
     (MessageNum : IccPaste;                  MessageStr : ccPasteStr),
     (MessageNum : IccPrevPage;               MessageStr : ccPrevPageStr),
     (MessageNum : IccRedo;                   MessageStr : ccRedoStr),
     (MessageNum : IccRestore;                MessageStr : ccRestoreStr),
     (MessageNum : IccRight;                  MessageStr : ccRightStr),
     (MessageNum : IccScrollDown;             MessageStr : ccScrollDownStr),
     (MessageNum : IccScrollUp;               MessageStr : ccScrollUpStr),
     (MessageNum : IccSetMarker0;             MessageStr : ccSetMarker0Str),
     (MessageNum : IccSetMarker1;             MessageStr : ccSetMarker1Str),
     (MessageNum : IccSetMarker2;             MessageStr : ccSetMarker2Str),
     (MessageNum : IccSetMarker3;             MessageStr : ccSetMarker3Str),
     (MessageNum : IccSetMarker4;             MessageStr : ccSetMarker4Str),
     (MessageNum : IccSetMarker5;             MessageStr : ccSetMarker5Str),
     (MessageNum : IccSetMarker6;             MessageStr : ccSetMarker6Str),
     (MessageNum : IccSetMarker7;             MessageStr : ccSetMarker7Str),
     (MessageNum : IccSetMarker8;             MessageStr : ccSetMarker8Str),
     (MessageNum : IccSetMarker9;             MessageStr : ccSetMarker9Str),
     (MessageNum : IccTab;                    MessageStr : ccTabStr),
     (MessageNum : IccTableEdit;              MessageStr : ccTableEditStr),
     (MessageNum : IccTopLeftCell;            MessageStr : ccTopLeftCellStr),
     (MessageNum : IccTopOfPage;              MessageStr : ccTopOfPageStr),
     (MessageNum : IccUndo;                   MessageStr : ccUndoStr),
     (MessageNum : IccUp;                     MessageStr : ccUpStr),
     (MessageNum : IccWordLeft;               MessageStr : ccWordLeftStr),
     (MessageNum : IccWordRight;              MessageStr : ccWordRightStr),
     (MessageNum : IString;                   MessageStr : StringStr),
     (MessageNum : IChar;                     MessageStr : CharStr),
     (MessageNum : IBoolean;                  MessageStr : BooleanStr),
     (MessageNum : IYesNo;                    MessageStr : YesNoStr),
     (MessageNum : ILongInt;                  MessageStr : LongIntStr),
     (MessageNum : IWord;                     MessageStr : WordStr),
     (MessageNum : ISmallInt;                 MessageStr : SmallIntStr),
     (MessageNum : IByte;                     MessageStr : ByteStr),
     (MessageNum : IShortInt;                 MessageStr : ShortIntStr),
     (MessageNum : IReal;                     MessageStr : RealStr),
     (MessageNum : IExtended;                 MessageStr : ExtendedStr),
     (MessageNum : IDouble;                   MessageStr : DoubleStr),
     (MessageNum : ISingle;                   MessageStr : SingleStr),
     (MessageNum : IComp;                     MessageStr : CompStr),
     (MessageNum : IDate;                     MessageStr : DateStr),
     (MessageNum : ITime;                     MessageStr : TimeStr),
     (MessageNum : ICharMask1;                MessageStr : CharMask1Str),
     (MessageNum : ICharMask2;                MessageStr : CharMask2Str),
     (MessageNum : ICharMask3;                MessageStr : CharMask3Str),
     (MessageNum : ICharMask4;                MessageStr : CharMask4Str),
     (MessageNum : ICharMask5;                MessageStr : CharMask5Str),
     (MessageNum : ICharMask6;                MessageStr : CharMask6Str),
     (MessageNum : ICharMask7;                MessageStr : CharMask7Str),
     (MessageNum : ICharMask8;                MessageStr : CharMask8Str),
     (MessageNum : ICharMask9;                MessageStr : CharMask9Str),
     (MessageNum : ICharMask10;               MessageStr : CharMask10Str),
     (MessageNum : ICharMask11;               MessageStr : CharMask11Str),
     (MessageNum : ICharMask12;               MessageStr : CharMask12Str),
     (MessageNum : ICharMask13;               MessageStr : CharMask14Str),
     (MessageNum : ICharMask14;               MessageStr : CharMask15Str),
     (MessageNum : ICharMask15;               MessageStr : CharMask16Str),
     (MessageNum : ICharMask16;               MessageStr : CharMask17Str),
     (MessageNum : ICharMask17;               MessageStr : CharMask18Str),
     (MessageNum : ICharMask18;               MessageStr : CharMask19Str),
     (MessageNum : ICharMask19;               MessageStr : CharMask20Str),
     (MessageNum : ICharMask20;               MessageStr : CharMask21Str),
     (MessageNum : ICharMask21;               MessageStr : CharMask22Str),
     (MessageNum : ICharMask22;               MessageStr : CharMask23Str),
     (MessageNum : ICharMask23;               MessageStr : CharMask24Str),
     (MessageNum : ICharMask24;               MessageStr : CharMask25Str),
     (MessageNum : IFieldMask1;               MessageStr : FieldMask1Str),
     (MessageNum : IFieldMask2;               MessageStr : FieldMask2Str),
     (MessageNum : IFieldMask3;               MessageStr : FieldMask3Str),
     (MessageNum : IFieldMask4;               MessageStr : FieldMask4Str),
     (MessageNum : IFieldMask5;               MessageStr : FieldMask5Str),
     (MessageNum : IFieldMask6;               MessageStr : FieldMask6Str),
     (MessageNum : IFieldMask7;               MessageStr : FieldMask7Str),
     (MessageNum : IFieldMask8;               MessageStr : FieldMask8Str),
     (MessageNum : IFieldMask9;               MessageStr : FieldMask9Str),
     (MessageNum : IFieldMask10;              MessageStr : FieldMask10Str),
     (MessageNum : IFieldMask11;              MessageStr : FieldMask11Str),
     (MessageNum : IFieldMask12;              MessageStr : FieldMask12Str),
     (MessageNum : IFieldMask13;              MessageStr : FieldMask13Str),
     (MessageNum : IFieldMask14;              MessageStr : FieldMask14Str),
     (MessageNum : IFieldMask15;              MessageStr : FieldMask15Str),
     (MessageNum : IFieldMask16;              MessageStr : FieldMask16Str),
     (MessageNum : IFieldMask17;              MessageStr : FieldMask17Str),
     (MessageNum : IFieldMask18;              MessageStr : FieldMask18Str),
     (MessageNum : IFieldMask19;              MessageStr : FieldMask19Str),
     (MessageNum : IFieldMask20;              MessageStr : FieldMask20Str),
     (MessageNum : IFieldMask21;              MessageStr : FieldMask21Str),
     (MessageNum : IFieldMask22;              MessageStr : FieldMask22Str),
     (MessageNum : IFieldMask23;              MessageStr : FieldMask23Str),
     (MessageNum : IFieldMask24;              MessageStr : FieldMask24Str),
     (MessageNum : IFieldMask25;              MessageStr : FieldMask25Str),
     (MessageNum : IFieldMask26;              MessageStr : FieldMask26Str),
     (MessageNum : IFieldMask27;              MessageStr : FieldMask27Str),
     (MessageNum : IFieldMask28;              MessageStr : FieldMask28Str),
     (MessageNum : IFieldMask29;              MessageStr : FieldMask29Str),
     (MessageNum : IFieldMask30;              MessageStr : FieldMask30Str),
     (MessageNum : IFieldMask31;              MessageStr : FieldMask31Str),
     (MessageNum : IFieldMask32;              MessageStr : FieldMask32Str),
     (MessageNum : IFieldMask33;              MessageStr : FieldMask33Str),
     (MessageNum : IFieldMask34;              MessageStr : FieldMask34Str),
     (MessageNum : IFieldMask35;              MessageStr : FieldMask35Str),
     (MessageNum : IFieldMask36;              MessageStr : FieldMask36Str),
     (MessageNum : IFieldMask37;              MessageStr : FieldMask37Str),
     (MessageNum : IFieldMask38;              MessageStr : FieldMask38Str),
     (MessageNum : IFieldMask39;              MessageStr : FieldMask39Str),
     (MessageNum : IFieldMask40;              MessageStr : FieldMask40Str),
     (MessageNum : IFieldMask41;              MessageStr : FieldMask41Str),
     (MessageNum : IFieldMask42;              MessageStr : FieldMask42Str));

  {End - Internal Strings...}

function ResourceStrByNumber(Num: Word): String;

implementation

function ResourceStrByNumber(Num: Word): String;
{Implements a simple binary search through the SrMsgNumLookup array.
 Returns an empty string is a match isn't found.}
var
  Mid, Min, Max : integer;
begin
  result := '';
  Min := 0;
  Max := SrMaxMessages;
  while (Min <= Max) do begin
    Mid := (Min + Max) div 2;
    if SrMsgNumLookup[Mid].MessageNum = Num then begin
      result := SrMsgNumLookup[Mid].MessageStr;
      exit;
    end else begin
      if Num < SrMsgNumLookup[Mid].MessageNum
      then Max := Mid - 1
      else Min := Mid + 1;
    end;
  end;
end;

end.
