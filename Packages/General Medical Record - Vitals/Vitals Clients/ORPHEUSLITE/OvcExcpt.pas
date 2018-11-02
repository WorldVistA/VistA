{*********************************************************}
{*                  OVCEXCPT.PAS 4.06                    *}
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

unit ovcexcpt;
  {-Exceptions unit}

interface

uses
  Windows, Classes, SysUtils, OvcData, OvcConst, OvcIntl;

type
  {*** Base Orpheus exeption class ***}
  EOvcException = class(Exception)
  public
    ErrorCode : LongInt;
  end;

  {*** General ***}
  ENoTimersAvailable = class(EOvcException)
  public
    constructor Create;
  end;

  {*** Controller ***}
  EControllerError = class(EOvcException);
  ENoControllerAssigned = class(EControllerError)
  public
    constructor Create;
  end;

  {*** Command Processor ***}
  ECmdProcessorError = class(EOvcException);
  EDuplicateCommand = class(ECmdProcessorError)
  public
    constructor Create;
  end;

  ETableNotFound = class(ECmdProcessorError)
  public
    constructor Create;
  end;

  {*** Entry Fields ***}
  EEntryFieldError = class(EOvcException);
  EInvalidDataType = class(EEntryFieldError)
  public
    constructor Create;
  end;

  EInvalidPictureMask = class(EEntryFieldError)
  public
    constructor Create(const Mask : string);
  end;

  EInvalidRangeValue = class(EEntryFieldError)
  public
    constructor Create(DataType : Byte);
  end;

  EInvalidDateForMask = class(EEntryFieldError)
  public
    constructor Create;
  end;

  {*** Editors ***}
  EEditorError = class(EOvcException)
  public
    constructor Create(const Msg : string; Error : Cardinal);
  end;

  EInvalidLineOrCol = class(EEditorError)
  public
    constructor Create;
  end;

  EInvalidLineOrPara = class(EEditorError)
  public
    constructor Create;
  end;

  {*** Viewers ***}
  EViewerError = class(EOvcException);
  ERegionTooLarge = class(EViewerError)
  public
    constructor Create;
  end;

  {*** Notebook ***}
  ENotebookError = class(EOvcException);
  EInvalidPageIndex = class(ENotebookError)
  public
    constructor Create;
  end;

  EInvalidTabFont = class(ENotebookError)
  public
    constructor Create;
  end;

  {*** Rotated Label ***}
  ERotatedLabelError = class(EOvcException);
  EInvalidLabelFont = class(ERotatedLabelError)
  public
    constructor Create;
  end;

  {*** Timer Pool ***}
  ETimerPoolError = class(EOvcException);
  EInvalidTriggerHandle = class(ETimerPoolError)
  public
    constructor Create;
  end;

  {*** Virtual ListBox ***}
  EVirtualListBoxError = class(EOvcException);
  EOnSelectNotAssigned = class(EVirtualListBoxError)
  public
    constructor Create;
  end;

  EOnIsSelectedNotAssigned = class(EVirtualListBoxError)
  public
    constructor Create;
  end;

  {*** Report View ***}
  EReportViewError = class(EOvcException)        { generic report view exception}
    constructor Create(ErrorCode : Integer; Dummy : Byte);
    constructor CreateFmt(ErrorCode : Integer; const Args : array of const; Dummy : Byte);
  end;
  EUnknownView = class(EReportViewError);       { unknown view name }
  EItemNotFound = class(EReportViewError);      { attempt to change/remove nonexistent item}
  EItemAlreadyAdded = class(EReportViewError);  { attempt to re-add existing item }
  EUpdatePending = class(EReportViewError);     { operation is invalid while updates are pending }
  EItemIsNotGroup = class(EReportViewError);    { item at specified line is not a group (IsGroup = False) }
  ELineNoOutOfRange = class(EReportViewError);  { specified line is invalid (out of range) }
  ENotMultiSelect = class(EReportViewError);    { operation is invalid while MultiSelect is false }
  EItemNotInIndex = class(EReportViewError);    { specified data item is not in index }
  ENoActiveView = class(EReportViewError);      { no active view }
  EOnCompareNotAsgnd = class(EReportViewError); { unassigned OnCompareFields }
  EGetAsFloatNotAsg = class(EReportViewError);  { unassigned OnGetFieldAsFloat }
  EOnFilterNotAsgnd = class(EReportViewError);  { unassigned OnFilter }

  {*** Sparse Array ***}
  ESparseArrayError = class(EOvcException);
  ESAEAtMaxSize = class(ESparseArrayError);
  ESAEOutOfBounds = class(ESparseArrayError);

  {*** Fixed Font ***}
  EFixedFontError = class(EOvcException);
  EInvalidFixedFont = class(EFixedFontError)
  public
    constructor Create;
  end;

  EInvalidFontParam = class(EFixedFontError)
  public
    constructor Create;
  end;

  {*** MRU List ***}
  EMenuMRUError = class(EOvcException);

implementation


{*** General ***}

constructor ENoTimersAvailable.Create;
begin
  inherited Create(GetOrphStr(SCNoTimersAvail));
end;


{*** Controller ***}

constructor ENoControllerAssigned.Create;
begin
  inherited Create(GetOrphStr(SCNoControllerAssigned));
end;


{*** Command Processor ***}

constructor ETableNotFound.Create;
begin
  inherited Create(GetOrphStr(SCTableNotFound));
end;

constructor EDuplicateCommand.Create;
begin
  inherited Create(GetOrphStr(SCDuplicateCommand));
end;


{*** Entry Fields ***}

constructor EInvalidDataType.Create;
begin
  inherited Create(GetOrphStr(SCInvalidDataType));
end;

constructor EInvalidPictureMask.Create(const Mask : string);
begin
  inherited CreateFmt(GetOrphStr(SCInvalidPictureMask), [Mask]);
end;

constructor EInvalidRangeValue.Create(DataType : Byte);
var
  S  : string;
begin
  case DataType of
    fsubLongInt  : inherited CreateFmt(GetOrphStr(SCInvalidRange), [Low(LongInt), High(LongInt)]);
    fsubWord     : inherited CreateFmt(GetOrphStr(SCInvalidRange), [Low(Word), High(Word)]);
    fsubInteger  : inherited CreateFmt(GetOrphStr(SCInvalidRange), [Low(SmallInt), High(SmallInt)]);
    fsubByte     : inherited CreateFmt(GetOrphStr(SCInvalidRange), [Low(Byte), High(Byte)]);
    fsubShortInt : inherited CreateFmt(GetOrphStr(SCInvalidRange), [Low(ShortInt), High(ShortInt)]);
    fsubReal     : inherited Create(GetOrphStr(SCInvalidRealRange));
    fsubExtended : inherited Create(GetOrphStr(SCInvalidExtendedRange));
    fsubDouble   : inherited Create(GetOrphStr(SCInvalidDoubleRange));
    fsubSingle   : inherited Create(GetOrphStr(SCInvalidSingleRange));
    fsubComp     : inherited Create(GetOrphStr(SCInvalidCompRange));
    fsubDate     :
      begin
        S := OvcIntlSup.InternationalDate(True);
        inherited CreateFmt(GetOrphStr(SCInvalidDateRange), [S]);
      end;
    fsubTime     :
      begin
        S := OvcIntlSup.InternationalTime(False);
        inherited CreateFmt(GetOrphStr(SCInvalidTimeRange), [S]);
      end;
  else
    inherited Create(GetOrphStr(SCInvalidRangeValue));
  end;
end;

constructor EInvalidDateForMask.Create;
begin
  inherited Create(GetOrphStr(SCInvalidDateForMask));
end;


{*** Editors ***}

constructor EEditorError.Create(const Msg : string; Error : Cardinal);
begin
  ErrorCode := Error;
  inherited Create(Msg);
end;

constructor EInvalidLineOrCol.Create;
begin
  inherited Create(GetOrphStr(SCInvalidLineOrColumn), 0);
end;

constructor EInvalidLineOrPara.Create;
begin
  inherited Create(GetOrphStr(SCInvalidLineOrParaIndex), 0);
end;


{*** Viewers ***}

constructor ERegionTooLarge.Create;
begin
  inherited Create(GetOrphStr(SCRegionTooLarge));
end;


{*** Notebook ***}

constructor EInvalidPageIndex.Create;
begin
  inherited Create(GetOrphStr(SCInvalidPageIndex));
end;

constructor EInvalidTabFont.Create;
begin
  inherited Create(GetOrphStr(SCInvalidTabFont));
end;


{*** Rotated Label ***}

constructor EInvalidLabelFont.Create;
begin
  inherited Create(GetOrphStr(SCInvalidLabelFont));
end;


{*** Timer Pool ***}

constructor EInvalidTriggerHandle.Create;
begin
  inherited Create(GetOrphStr(SCBadTriggerHandle));
end;


{*** Virtual ListBox ***}

constructor EOnSelectNotAssigned.Create;
begin
  inherited Create(GetOrphStr(SCOnSelectNotAssigned));
end;

constructor EOnIsSelectedNotAssigned.Create;
begin
  inherited Create(GetOrphStr(SCOnIsSelectedNotAssigned));
end;


{*** Fixed Font ***}

constructor EInvalidFixedFont.Create;
begin
  inherited Create(GetOrphStr(SCNonFixedFont));
end;

constructor EInvalidFontParam.Create;
begin
  inherited Create(GetOrphStr(SCInvalidFontParam));
end;


constructor EReportViewError.Create(ErrorCode : Integer; Dummy : Byte);
begin
  inherited Create(GetOrphStr(ErrorCode));
end;

constructor EReportViewError.CreateFmt(ErrorCode : Integer; const Args : array of const; Dummy : Byte);
begin
  inherited CreateFmt(GetOrphStr(ErrorCode),Args);
end;

end.
