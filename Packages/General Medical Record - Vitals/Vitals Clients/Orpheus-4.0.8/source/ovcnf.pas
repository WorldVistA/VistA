{*********************************************************}
{*                    OVCNF.PAS 4.06                    *}
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

unit ovcnf;
  {-Numeric field visual component}

interface

uses
  Windows, Classes, Controls, Forms, Graphics, Menus, Messages, SysUtils,
  OvcBase, OvcCaret, OvcColor, OvcConst, OvcData, OvcEF, OvcExcpt,
  OvcMisc, OvcPB, OvcStr,imm;

type
  {numeric field types}
  TNumericDataType   = (
    nftLongInt, nftWord, nftInteger, nftByte, nftShortInt, nftReal,
    nftExtended, nftDouble, nftSingle, nftComp);

type
  TOvcCustomNumericField = class(TOvcPictureBase)

  protected {private}
    {property instance variables}
    FNumericDataType   : TNumericDataType;
    FPictureMask       : string;

    {private instance variables}
    nfMaxLen    : Word;        {maximum length of numeric string}
    nfMaxDigits : Word;        {maximum # of digits to left of decimal}
    nfPlaces    : Word;        {# of decimal places}
    nfMinus     : Boolean;     {true if number is negative}
    nfTmp       : TEditString; {temporary input string}

    function nfGetDataType(Value : TNumericDataType) : Byte;
      {-return a Byte value representing the data type of this field}
    procedure nfReloadTmp;
      {-reload Tmp from efEditSt, etc.}
    procedure nfResetFieldProperties(FT : TNumericDataType);
      {-reset field properties}
    procedure nfSetDefaultRanges;
      {-set default range values based on the field type}
    procedure nfSetMaxLength(Mask : PChar);
      {-determine and set MaxLength}

    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;

    procedure WMImeComposition(var Msg: TMessage); message WM_IME_COMPOSITION;
  protected
    {VCL methods}
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;

    procedure efCaretToEnd;
      override;
      {-move the caret to the end of the field}
    procedure efCaretToStart;
      override;
      {-move the caret to the beginning of the field}
    procedure efChangeMask(Mask : PChar);
      override;
      {-change the picture mask}
    procedure efEdit(var Msg : TMessage; Cmd : Word);
      override;
      {-process the specified editing command}
    function efGetDisplayString(Dest : PChar; Size : Word) : PChar;
      override;
      {-return the display string in Dest and a pointer as the result}
    procedure efIncDecValue(Wrap : Boolean; Delta : Double);
      override;
      {-increment field by Delta}
    function efTransfer(DataPtr : Pointer; TransferFlag : Word) : Word;
      override;
      {-transfer data to/from the entry fields}
        procedure pbRemoveSemiLits;
      override;
      {-remove semi-literal mask characters from the edit string}

    {virtual property methods}
    procedure efSetCaretPos(Value : Integer);
      override;
      {-set position of caret within the field}
    procedure nfSetDataType(Value : TNumericDataType);
      virtual;
      {-set the data type for this field}
    procedure nfSetPictureMask(const Value : string);
      virtual;
      {-set the picture mask}

  public
    procedure Assign(Source : TPersistent);
      override;
    constructor Create(AOwner: TComponent);
      override;

    function efValidateField : Word;
      override;
      {-validate contents of field; result is error code or 0}


    {public properties}
    property DataType : TNumericDataType
      read FNumericDataType
      write nfSetDataType;

    property PictureMask : string
      read FPictureMask
      write nfSetPictureMask;
  end;

  TOvcNumericField = class(TOvcCustomNumericField)
  published
    {inherited properties}
    property DataType;              {needs to loaded before most other properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property AutoSize;
    property BorderStyle;
    property CaretIns;
    property CaretOvr;
    property Color;
    property Controller;
    property Ctl3D;
    property Borders;
    property DragCursor;
    property DragMode;
    property EFColors;
    property Enabled;
    property Font;
    property LabelInfo;
    property Options;
    property PadChar;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureMask;
    property PopupMenu;
    property RangeHi stored False;
    property RangeLo stored False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Tag;
    property TextMargin;
    property Uninitialized;
    property Visible;
    property ZeroDisplay;
    property ZeroDisplayValue;

    {inherited events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnError;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnStartDrag;
    property OnUserCommand;
    property OnUserValidation;
  end;


implementation


{*** TOvcCustomNumericField ***}

//clc
procedure TOvcCustomNumericField.WMImeComposition(var Msg: TMessage);
var IMEContext: HIMC;
    p: WideString;
    FImeCount: integer;
//var AString:String;
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
        //this does cancel the IME input and Orpheus components gets their input from else where...
        //just throw input away

        //     procedure efEdit(var Msg : TMessage; Cmd : Word); PastePrim(Pchar(p[1]));//p[Counter]
        (*if ANSIString(p) <> p then
        begin
          AString := StrPas(efEditSt);
          Insert(p, AString,efHPos+1);
          StrPCopy(efEditSt,AString);
          inc(efHPos,Length(p));
        end;*)
       end;
    finally
      ImmReleaseContext(Handle, IMEContext);
    end;
  end;
  inherited;
end;


procedure TOvcCustomNumericField.Assign(Source : TPersistent);
var
  NF : TOvcCustomNumericField absolute Source;
begin
  if (Source <> nil) and (Source is TOvcCustomNumericField) then begin
    DataType             := NF.DataType;
    AutoSize             := NF.AutoSize;
    BorderStyle          := NF.BorderStyle;
    Color                := NF.Color;
    EFColors.Error.Assign(NF.EFColors.Error);
    EFColors.Highlight.Assign(NF.EFColors.Highlight);
    Options              := NF.Options;
    PadChar              := NF.PadChar;
    PictureMask          := NF.PictureMask;
    RangeHi              := NF.RangeHi;
    RangeLo              := NF.RangeLo;
    TextMargin           := NF.TextMargin;
    Uninitialized        := NF.Uninitialized;
    ZeroDisplay          := NF.ZeroDisplay;
    ZeroDisplayValue     := NF.ZeroDisplayValue;
  end else
    inherited Assign(Source);
end;

constructor TOvcCustomNumericField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FNumericDataType := nftLongInt;
  FPictureMask     := 'iiiiiiiiiii';
  efFieldClass     := fcNumeric;
  efDataType       := nfGetDataType(FNumericDataType);
  efRangeHi.rtLong := High(Integer);
  efRangeLo.rtLong := Low(Integer);

  //clc prevents ImeEditor from opening
imeMode := imDisable;
//HandleNeeded;
//SetImeMode(Handle,imeMode);

end;

procedure TOvcCustomNumericField.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  pfSelPos := 0;

  {get current picture string}
  StrPLCopy(efPicture, FPictureMask, MaxPicture);

  {set MaxLength based on picture mask}
  nfSetMaxLength(efPicture);

  FillChar(nfTmp, SizeOf(nfTmp), #0);
  pfSemiLits := 0;
  pbCalcWidthAndPlaces(nfMaxLen, nfPlaces);

  {adjust max length for decimal point if needed}
  nfMaxDigits := nfMaxLen;
  if nfPlaces <> 0 then
    Dec(nfMaxDigits, nfPlaces+1);
end;

procedure TOvcCustomNumericField.CreateWnd;
var
  P : array[0..MaxEditLen+1] of Byte;
begin
  {save field data}
  if efSaveData then
    efTransfer(@P, otf_GetData);

  inherited CreateWnd;

  {try to optimize InitPictureFlags}
  pbOptimizeInitPictureFlags;

  pfSemiLits := 0;
  nfSetDefaultRanges;
  efSetInitialValue;

  {if we saved the field data, restore it}
  if efSaveData then
    efTransfer(@P, otf_SetData);

  {set save data flag}
  efSaveData := True;
end;

procedure TOvcCustomNumericField.efCaretToEnd;
  {-move the caret to the end of the field}
begin
  efHPos := efEditEnd + 1;
end;

procedure TOvcCustomNumericField.efCaretToStart;
  {-move the caret to the beginning of the field}
begin
  efHPos := efEditEnd + 1;
end;

procedure TOvcCustomNumericField.efChangeMask(Mask : PChar);
  {-change the picture mask}
begin
  inherited efChangeMask(Mask);

  pfSemiLits := 0;
  pbCalcWidthAndPlaces(nfMaxLen, nfPlaces);

  {set MaxLength based on picture mask}
  nfSetMaxLength(Mask);
  nfMaxDigits := nfMaxLen;
  if nfPlaces <> 0 then
    Dec(nfMaxDigits, nfPlaces+1);
end;

procedure TOvcCustomNumericField.efEdit(var Msg : TMessage; Cmd : Word);
  {-process the specified editing command}
label
  ExitPoint;
var
  MF         : Byte;
  Ch         : Char;
  HaveSel    : Boolean;
  PicChar    : Char;
  StLen      : Word;
  StBgn      : Word;
  StEnd      : Word;
  DotPos     : Cardinal;
  Found      : Boolean;

  function MinusVal : Byte;
  begin
    if nfMinus then
      Result := 1
    else
      Result := 0;
  end;

  procedure ClearString;
    {-clear the string being edited}
  begin
    nfTmp[0] := #0;
    nfMinus := False;
    StLen := 0;
  end;

  function CharIsOK : Boolean;
    {-return true if Ch can be added to the string}
  begin
    Result := (Ch >= ' ');
  end;

  function CheckAutoAdvance(SP : Integer) : Boolean;
    {-see if we need to auto-advance to next/previous field}
  begin
    Result := False;
    if (SP < 0) and
       (efoAutoAdvanceLeftRight in Controller.EntryOptions) then begin
      efMoveFocusToPrevField;
      Result := True;
    end else if (SP > 0) then
      if (Cmd = ccChar) and
         (efoAutoAdvanceChar in Controller.EntryOptions) then begin
        efMoveFocusToNextField;
        Result := True;
      end else if (Cmd <> ccChar) and
                  (efoAutoAdvanceLeftRight in Controller.EntryOptions) then begin
        efMoveFocusToNextField;
        Result := True;
      end;
  end;

  procedure DeleteChar;
    {-delete char at end of string}
  begin
    if (StLen = 0) then
      if not nfMinus then
        Exit
      else
        nfMinus := False
    else begin
      {remove the last character}
      nfTmp[StLen-1] := #0;
      Dec(StLen);

      {if all that's left is a 0, remove it}
      if (StLen = 1) and (nfTmp[0] = '0') then
        nfTmp[0] := #0;
    end;
    MF := 10;
  end;

  procedure DeleteSel;
  begin
    ClearString;
    efSelStart := 0;
    efSelEnd := 0;
    MF := 10;
  end;

  function InsertChar : Boolean;
    {-insert Ch}
  var
    tDotPos : Cardinal;
    tFound  : Boolean;

    function DigitCount : Word;
      {-return number of digits to left of decimal place in St}
    begin
      if tFound then
        Result := tDotPos + MinusVal
      else
        Result := StLen + MinusVal;
    end;

    function PlacesCount : Word;
      {-return number of digits to right of decimal place in St}
    begin
      if not tFound then
        Result := 0
      else
        Result := StLen - tDotPos - 1;
    end;

  begin
    Result := False;

    {reject spaces}
    if (Ch = ' ') then
      Exit;

    {ok to add decimal point?}
    tFound := StrChPos(nfTmp, pmDecimalPt, tDotPos);
    if (Ch = pmDecimalPt) then
      if not Found or tFound then
        Exit;

    if (Ch = '-') then begin
      {minus sign treated as toggle}
      if nfMinus then
        nfMinus := False
      else begin
        nfMinus := (DigitCount < nfMaxDigits) and (StLen < nfMaxLen);
        if not nfMinus then
          Exit;
      end
    end else if (StLen+MinusVal < nfMaxLen) then begin
      {don't allow initial zeros}
      if (Ch = '0') and (StLen = 0) then begin
        Result := True;
        Exit;
      end;

      if Found and (Ch <> pmDecimalPt) then begin
        {check for too many digits to left of decimal point}
        if not tFound and (DigitCount >= nfMaxDigits) then
          Exit;
        {
         Fix for Problem 667950
         If there is a decimal point available in the mask, we should check
         the number of digits after it in the input field and not allow entry
         if it's "full"
        }
        if tFound and (PlacesCount >= nfPlaces) then
          Exit;
      end;

      {append the character}
      nfTmp[StLen] := Ch;
      Inc(StLen);
      nfTmp[StLen] := #0;
    end else if (nfMaxLen = 1) then
      if (Ch = pmDecimalPt) then
        Exit
      else
        {overwrite the character}
        nfTmp[0] := Ch
    else
      Exit;

    Result := True;
  end;

  procedure Adjust;
    {-adjust display string to show correct number of decimal places}
  var
    Delta     : Integer;
    ActPlaces : Integer;
    DP        : Cardinal;
    Len       : Word;
    ExDec     : TEditString;
  begin
    Len := StrLen(nfTmp);
    if not StrChPos(nfTmp, pmDecimalPt, DP) then
      Delta := nfPlaces+1
    else begin
      ActPlaces := Len-Succ(DP);
      Delta := nfPlaces-ActPlaces;
    end;

    if Delta = 0 then
      Exit;

    if Delta > 0 then begin
      StrStDeletePrim(efEditSt, StEnd-Pred(Delta), Delta);
      StrStInsertPrim(efEditSt, CharStrPChar(ExDec, ' ', Delta), StBgn);
    end else begin
      Delta := -Delta;
      StrStCopy(ExDec, nfTmp, DP+nfPlaces+1, Delta);
      StrStDeletePrim(efEditSt, StBgn, Delta);
      StrStInsertPrim(efEditSt, ExDec, StEnd-Pred(Delta));
    end;
  end;

  procedure UpdateEditSt;
    {-update efEditSt}
  begin
    StrCopy(efEditSt, nfTmp);
    case efEditSt[0] of
      #0 :
        begin
          {string is empty, put in a 0}
          efEditSt[0] := '0';
          efEditSt[1] := #0;
        end;
      '.' :
        StrChInsertPrim(efEditSt, '0', 0);
    end;

    {prepend the minus sign}
    if nfMinus then
      StrChInsertPrim(efEditSt, '-', 0);

    pbMergePicture(efEditSt, efEditSt);
    if Found then
      Adjust;
  end;

  procedure UpdateSel(Delta : Integer);
  begin
    if Delta <> 0 then begin
      efSelStart := 0;
      efSelEnd := MaxEditLen;
    end else begin
      efSelStart := 0;
      efSelEnd := 0;
    end;
  end;

  procedure PastePrim(P : PChar);
  begin
    if HaveSel then
      DeleteSel;
    while P^ <> #0 do begin
      Ch := P^;
      if (Ch = '(') then
        if StrScan(efPicture, pmNegParens) <> nil then
          if StrScan(P, ')') <> nil then
            Ch := '-';
      if (Ch <> '-') or not nfMinus then
        if (StLen+MinusVal <= nfMaxLen) then begin
          if Ch = IntlSupport.DecimalChar then
            Ch := pmDecimalPt
          else if Ch = pmDecimalPt then
            Ch := #0;
          if efCharOK(PicChar, Ch, #255, True) then
            if InsertChar then
              MF := 10
        end;
      Inc(P);
    end;
  end;

begin  {edit}
  HaveSel := efSelStart <> efSelEnd;
  MF := Ord(HaveSel);

  case Cmd of
    ccAccept : ;
  else
    if not (sefFixSemiLits in sefOptions) then
      pbRemoveSemiLits;

    Exclude(sefOptions, sefLiteral);
  end;

  StBgn := efEditBegin;
  StEnd := efEditEnd;
  StLen := StrLen(nfTmp);
  PicChar := efNthMaskChar(efHPos-1);
  Found := StrChPos(efPicture, pmDecimalPt, DotPos);

  Exclude(sefOptions, sefCharOK);
  case Cmd of
    ccChar :
      begin
        Ch := Char(Msg.wParam);
        if not (sefAcceptChar in sefOptions) then
          Exit
        else begin
          Exclude(sefOptions, sefAcceptChar);
          if HaveSel and CharIsOk then
            DeleteSel;
          if StLen+MinusVal <= nfMaxLen then begin
            if Ch = IntlSupport.DecimalChar then
              Ch := pmDecimalPt
            else if Ch = pmDecimalPt then
              Ch := #0;
            if not efCharOK(PicChar, Ch, #255, True) then
                efConditionalBeep
            else begin
              if InsertChar then begin
                if (Ch <> '-') and (StLen+MinusVal = nfMaxLen) then
                  CheckAutoAdvance(1);
                MF := 10;
              end else
                efConditionalBeep;
            end;
          end else if not CheckAutoAdvance(1) then
            efConditionalBeep;
        end;
      end;
    ccLeft, ccWordLeft :
      CheckAutoAdvance(-1);
    ccRight, ccWordRight :
      CheckAutoAdvance(1);
    ccUp :
      if (efoAutoAdvanceUpDown in Controller.EntryOptions) then
        efMoveFocusToPrevField
      else if (efoArrowIncDec in Options) and
              not (efoReadOnly in Options) then
        IncreaseValue(True, 1)
      else
        CheckAutoAdvance(-1);
    ccDown :
      if (efoAutoAdvanceUpDown in Controller.EntryOptions) then
        efMoveFocusToNextField
      else if (efoArrowIncDec in Options) and not (efoReadOnly in Options) then
        DecreaseValue(True, 1)
      else
        CheckAutoAdvance(1);
    ccMouse :
      begin
        efSelStart := 0;
        efSelEnd := 0;
      end;
    ccDblClk :
      SetSelection(0, MaxEditLen);
    ccHome, ccEnd : {do nothing};
    ccBack, ccDel :
      if HaveSel then
        DeleteSel
      else
        DeleteChar;
    ccDelWord :
      if HaveSel then
        DeleteSel;
    ccExtendLeft :
      UpdateSel(-1);
    ccExtendRight :
      UpdateSel(+1);
    ccExtWordLeft, ccExtendHome :
      UpdateSel(-MaxEditLen);
    ccExtWordRight, ccExtendEnd :
      UpdateSel(+MaxEditLen);
    ccCut :
      if HaveSel then
        DeleteSel;
    ccCopy : efCopyPrim;
    ccPaste :
      {for some reason, a paste action within the IDE}
      {gets passed to the control. filter it out}
      if not (csDesigning in ComponentState) then
        PastePrim(PChar(Msg.lParam));
    ccDelLine :
      begin
        ClearString;
        MF := 10;
      end;
    ccIns :
      begin
        if sefInsert in sefOptions then
          Exclude(sefOptions, sefInsert)
        else
          Include(sefOptions, sefInsert);
        efCaret.InsertMode := (sefInsert in sefOptions);
      end;
    ccRestore :
      begin
        Restore;
        nfReloadTmp;
      end;
    ccAccept :
      begin
        Include(sefOptions, sefCharOK);
        Include(sefOptions, sefAcceptChar);
        Exit;
      end;
    ccCtrlChar : {};
    ccDec :
      DecreaseValue(True, 1);
    ccInc :
      IncreaseValue(True, 1);
    ccSuppress, ccPartial :
      goto ExitPoint;
  else
    Include(sefOptions, sefCharOK);
  end;
  Exclude(sefOptions, sefAcceptChar);

  case Cmd of
    ccMouse : {};
    ccRestore, ccDblClk,
    ccExtendLeft, ccExtendRight, ccExtendEnd,
    ccExtendHome, ccExtWordLeft, ccExtWordRight :
      Inc(MF);
    ccCut, ccCopy, ccPaste : {};
  else
    efSelStart := efHPos;
    efSelEnd := efHPos;
  end;


ExitPoint:
  if MF >= 10 then begin
    UpdateEditSt;
    efFieldModified;
  end;
  if efPositionCaret(True) then
    Inc(MF);
  if MF > 0 then
    Invalidate;
end;

function TOvcCustomNumericField.efGetDisplayString(Dest : PChar; Size : Word) : PChar;
  {-return the display string in Dest and a pointer as the result}
var
  I, J  : Cardinal;
  Found : Boolean;
begin
  Result := inherited efGetDisplayString(Dest, Size);

  if Uninitialized and not (sefHaveFocus in sefOptions) then
    Exit;

  Found := StrChPos(Dest, '-', I);
  if StrChPos(efPicture, pmNegParens, J) then
    if not Found then
      Dest[J] := ' '
    else begin
      Dest[I] := '(';
      Dest[J] := ')';
    end;

  if StrChPos(efPicture, pmNegHere, J) then
    if not Found then
      Dest[J] := ' '
    else begin
      Dest[J] := '-';
      J := efEditBegin;
      if J = I then
        Dest[I] := ' '
      else begin
        StrChDeletePrim(Dest, I);
        StrChInsertPrim(Dest, ' ', J);
      end;
    end;

  TrimAllSpacesPChar(Dest);
end;

procedure TOvcCustomNumericField.efIncDecValue(Wrap : Boolean; Delta : Double);
  {-increment field by Delta}
var
  Code : Integer;

  procedure IncDecValueLongInt;
  var
    L : NativeInt;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    if efStr2Long(S, L) then begin
      if (Delta < 0) and (L <= efRangeLo.rtLong) then
        if Wrap then
          L := efRangeHi.rtLong
        else
          Exit
      else if (Delta > 0) and (L >= efRangeHi.rtLong) then
        if Wrap then
          L := efRangeLo.rtLong
        else
          Exit
      else
        Inc(L, Trunc(Delta));

      {insure valid value}
      if L < efRangeLo.rtLong then
        L := efRangeLo.rtLong;
      if L > efRangeHi.rtLong then
        L := efRangeHi.rtLong;

      efTransfer(@L, otf_SetData);
      nfReloadTmp;
      efPerformRepaint(True);
    end;
  end;

  procedure IncDecValueReal;
  var
    Re : Real;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, Re, Code);

    if Code = 0 then begin
      if (Delta < 0) and (Re <= efRangeLo.rtReal) then
        if Wrap then
          Re := efRangeHi.rtReal
        else
          Exit
      else if (Delta > 0) and (Re >= efRangeHi.rtReal) then
        if Wrap then
          Re := efRangeLo.rtReal
        else
          Exit
      else
        Re := Re + Delta;

      {insure valid value}
      if Re < efRangeLo.rtReal then
        Re := efRangeLo.rtReal;
      if Re > efRangeHi.rtReal then
        Re := efRangeHi.rtReal;

      efTransfer(@Re, otf_SetData);
      nfReloadTmp;
      efPerformRepaint(True);
    end;
  end;

  procedure IncDecValueExtended;
  var
    Ex : Extended;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, Ex, Code);

    if Code = 0 then begin
      if (Delta < 0) and (Ex <= efRangeLo.rtExt) then
        if Wrap then
          Ex := efRangeHi.rtExt
        else
          Exit
      else if (Delta > 0) and (Ex >= efRangeHi.rtExt) then
        if Wrap then
          Ex := efRangeLo.rtExt
        else
          Exit
      else
        Ex := Ex + Delta;

      {insure valid value}
      if Ex < efRangeLo.rtExt then
        Ex := efRangeLo.rtExt;
      if Ex > efRangeHi.rtExt then
        Ex := efRangeHi.rtExt;

      efTransfer(@Ex, otf_SetData);
      nfReloadTmp;
      efPerformRepaint(True);
    end;
  end;

  procedure IncDecValueDouble;
  var
    Db : Double;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, Db, Code);

    if Code = 0 then begin
      if (Delta < 0) and (Db <= efRangeLo.rtExt) then
        if Wrap then
          Db := efRangeHi.rtExt
        else
          Exit
      else if (Delta > 0) and (Db >= efRangeHi.rtExt) then
        if Wrap then
          Db := efRangeLo.rtExt
        else
          Exit
      else
        Db := Db + Delta;

      {insure valid value}
      if Db < efRangeLo.rtExt then
        Db := efRangeLo.rtExt;
      if Db > efRangeHi.rtExt then
        Db := efRangeHi.rtExt;

      efTransfer(@Db, otf_SetData);
      nfReloadTmp;
      efPerformRepaint(True);
    end;
  end;

  procedure IncDecValueSingle;
  var
    Si : Single;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, Si, Code);

    if Code = 0 then begin
      if (Delta < 0) and (Si <= efRangeLo.rtExt) then
        if Wrap then
          Si := efRangeHi.rtExt
        else
          Exit
      else if (Delta > 0) and (Si >= efRangeHi.rtExt) then
        if Wrap then
          Si := efRangeLo.rtExt
        else
          Exit
      else
        Si := Si + Delta;

      {insure valid value}
      if Si < efRangeLo.rtExt then
        Si := efRangeLo.rtExt;
      if Si > efRangeHi.rtExt then
        Si := efRangeHi.rtExt;

      efTransfer(@Si, otf_SetData);
      nfReloadTmp;
      efPerformRepaint(True);
    end;
  end;

  procedure IncDecValueComp;
  var
    Co : Comp;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, Co, Code);

    if Code = 0 then begin
      if (Delta < 0) and (Co <= efRangeLo.rtExt) then
        if Wrap then
          Co := efRangeHi.rtExt
        else
          Exit
      else if (Delta > 0) and (Co >= efRangeHi.rtExt) then
        if Wrap then
          Co := efRangeLo.rtExt
        else
          Exit
      else
        Co := Co + Delta;

      {insure valid value}
      if Co < efRangeLo.rtExt then
        Co := efRangeLo.rtExt;
      if Co > efRangeHi.rtExt then
        Co := efRangeHi.rtExt;

      efTransfer(@Co, otf_SetData);
      nfReloadTmp;
      efPerformRepaint(True);
    end;
  end;

begin
  if not (sefHaveFocus in sefOptions) then
    Exit;

  case FNumericDataType of
    nftLongInt,
    nftWord,
    nftInteger,
    nftByte,
    nftShortInt  : IncDecValueLongInt;
    nftReal      : IncDecValueReal;
    nftExtended  : IncDecValueExtended;
    nftDouble    : IncDecValueDouble;
    nftSingle    : IncDecValueSingle;
    nftComp      : IncDecValueComp;
  end;
  efPositionCaret(False);
end;

procedure TOvcCustomNumericField.efSetCaretPos(Value : Integer);
  {-set position of caret within the field}
begin
  {do nothing}
end;

function TOvcCustomNumericField.efTransfer(DataPtr : Pointer; TransferFlag : Word) : Word;
  {-transfer data to/from the entry fields}
var
  E      : Extended;

  procedure TransferLongInt;
  var
    S      : TEditString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      if not efStr2Long(S, NativeInt(DataPtr^)) then
        NativeInt(DataPtr^) := 0;
    end else begin
      efLong2Str(S, NativeInt(DataPtr^));
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferWord;
  var
    L      : NativeInt;
    S      : TEditString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      if efStr2Long(S, L) then
        Word(DataPtr^) := L
      else
        Word(DataPtr^) := 0;
    end else begin
      efLong2Str(S, Word(DataPtr^));
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferInteger;
  var
    L      : NativeInt;
    S      : TEditString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      if efStr2Long(S, L) then
        SmallInt(DataPtr^) := L
      else
        SmallInt(DataPtr^) := 0;
    end else begin
      efLong2Str(S, SmallInt(DataPtr^));
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferByte;
  var
    L      : NativeInt;
    S      : TEditString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      if efStr2Long(S, L) then
        Byte(DataPtr^) := L
      else
        Byte(DataPtr^) := 0;
    end else begin
      efLong2Str(S, Byte(DataPtr^));
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferShortInt;
  var
    L      : NativeInt;
    S      : TEditString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      if efStr2Long(S, L) then
        ShortInt(DataPtr^) := L
      else
        ShortInt(DataPtr^) := 0;
    end else begin
      efLong2Str(S, ShortInt(DataPtr^));
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferReal;
  var
    Code   : Integer;
    Places : Word;
    R      : Real;
    S      : TEditString;
    Width  : Word;
    Tmp: string;
    sShort: ShortString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      FixRealPrim(S, IntlSupport.DecimalChar);
      Val(S, R, Code);

      if Code <> 0 then
        R := 0;
      Real(DataPtr^) := R;
    end else begin
      pbCalcWidthAndPlaces(Width, Places);
      Str(Real(DataPtr^):Width:Places, sShort);
      Tmp := string(sShort);
      StrLCopy(S, PChar(Tmp), Length(Tmp));

      if DecimalPlaces <> 0 then
        TrimTrailingZerosPChar(S)
      else
        TrimAllSpacesPChar(S);
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferExtended;
  var
    Code   : Integer;
    Places : Word;
    S      : TEditString;
    Width  : Word;
    Tmp: string;
    sShort: ShortString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      FixRealPrim(S, IntlSupport.DecimalChar);
      Val(S, E, Code);

      if Code <> 0 then
        E := 0;
      Extended(DataPtr^) := E;
    end else begin
      pbCalcWidthAndPlaces(Width, Places);
      Str(Extended(DataPtr^):Width:Places, sShort);
      Tmp := string(sShort);
      StrLCopy(S, PChar(Tmp), Length(Tmp));
      if DecimalPlaces <> 0 then
        TrimTrailingZerosPChar(S)
      else
        TrimAllSpacesPChar(S);
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferDouble;
  var
    D      : Double;
    Code   : Integer;
    Places : Word;
    S      : TEditString;
    Width  : Word;
    Tmp: string;
    sShort: ShortString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      FixRealPrim(S, IntlSupport.DecimalChar);
      Val(S, D, Code);

      if Code <> 0 then
        D := 0;
      Double(DataPtr^) := D;
    end else begin
      pbCalcWidthAndPlaces(Width, Places);
      Str(Double(DataPtr^):Width:Places, sShort);
      Tmp := string(sShort);
      StrLCopy(S, PChar(Tmp), Length(Tmp));
      if DecimalPlaces <> 0 then
        TrimTrailingZerosPChar(S)
      else
        TrimAllSpacesPChar(S);
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferSingle;
  var
    Code   : Integer;
    G      : Single;
    Places : Word;
    S      : TEditString;
    Width  : Word;
    Tmp: string;
    sShort: ShortString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      FixRealPrim(S, IntlSupport.DecimalChar);
      Val(S, G, Code);

      if Code <> 0 then
        G := 0;
      Single(DataPtr^) := G;
    end else begin
      pbCalcWidthAndPlaces(Width, Places);
      Str(Single(DataPtr^):Width:Places, sShort);
      Tmp := string(sShort);
      StrLCopy(S, PChar(Tmp), Length(Tmp));
      if DecimalPlaces <> 0 then
        TrimTrailingZerosPChar(S)
      else
        TrimAllSpacesPChar(S);
      pbMergePicture(efEditSt, S);
    end;
  end;

  procedure TransferComp;
  var
    C      : Comp;
    Code   : Integer;
    Places : Word;
    S      : TEditString;
    Width  : Word;
    Tmp: string;
    sShort: ShortString;
  begin
    if TransferFlag = otf_GetData then begin
      pbStripPicture(S, efEditSt);

      FixRealPrim(S, IntlSupport.DecimalChar);
      Val(S, C, Code);

      if Code <> 0 then
        C := 0;
      Comp(DataPtr^) := C;
    end else begin
      pbCalcWidthAndPlaces(Width, Places);
      Str(Comp(DataPtr^):Width:Places, sShort);
      Tmp := string(sShort);
      StrLCopy(S, PChar(Tmp), Length(Tmp));
      if DecimalPlaces <> 0 then
        TrimTrailingZerosPChar(S)
      else
        TrimAllSpacesPChar(S);
      pbMergePicture(efEditSt, S);
    end;
  end;

begin  {transfer}
  if DataPtr = nil then begin
    Result := 0;
    Exit;
  end;

  case FNumericDataType of
    nftLongInt  : TransferLongInt;
    nftWord     : TransferWord;
    nftInteger  : TransferInteger;
    nftByte     : TransferByte;
    nftShortInt : TransferShortInt;
    nftReal     : TransferReal;
    nftExtended : TransferExtended;
    nftDouble   : TransferDouble;
    nftSingle   : TransferSingle;
    nftComp     : TransferComp;
  end;
  Result := inherited efTransfer(DataPtr, TransferFlag);
end;

function TOvcCustomNumericField.efValidateField : Word;
  {-validate contents of field; result is error code or 0}

  procedure ValidateLongInt;
  var
    L : NativeInt;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    if not efStr2Long(S, L) then
      Result := oeInvalidNumber
    else if (L < efRangeLo.rtLong) or (L > efRangeHi.rtLong) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          efTransfer(@L, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateWord;
  var
    L : NativeInt;
    W : Word;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    if not efStr2Long(S, L) then
      Result := oeInvalidNumber
    else if (L < efRangeLo.rtLong) or (L > efRangeHi.rtLong) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          W := L;
          efTransfer(@W, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateInteger;
  var
    L : NativeInt;
    I : Integer;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    if not efStr2Long(S, L) then
      Result := oeInvalidNumber
    else if (L < efRangeLo.rtLong) or (L > efRangeHi.rtLong) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          I := L;
          efTransfer(@I, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateByte;
  var
    L : NativeInt;
    B : Byte;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    if not efStr2Long(S, L) then
      Result := oeInvalidNumber
    else if (L < efRangeLo.rtLong) or (L > efRangeHi.rtLong) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          B := L;
          efTransfer(@B, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateShortInt;
  var
    L  : NativeInt;
    Si : Byte;
    S    : TEditString;
  begin
    pbStripPicture(S, efEditSt);

    if not efStr2Long(S, L) then
      Result := oeInvalidNumber
    else if (L < efRangeLo.rtLong) or (L > efRangeHi.rtLong) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          Si := L;
          efTransfer(@Si, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateReal;
  var
    R : Real;
    Code : Integer;
    S    : TEditString;
  begin
    {convert efEditSt to a real}
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, R, Code);

    if Code <> 0 then
      Result := oeInvalidNumber
    else if (R < efRangeLo.rtReal) or (R > efRangeHi.rtReal) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          efTransfer(@R, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateExtended;
  var
    E : Extended;
    Code : Integer;
    S    : TEditString;
  begin
    {convert efEditSt to an extended}
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, E, Code);

    if Code <> 0 then
      Result := oeInvalidNumber
    else if (E < efRangeLo.rtExt) or (E > efRangeHi.rtExt) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          efTransfer(@E, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateDouble;
  var
    E : Extended;
    D : Double;
    Code : Integer;
    S    : TEditString;
  begin
    {convert efEditSt to an extended}
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, E, Code);

    if Code <> 0 then
      Result := oeInvalidNumber
    else if (E < efRangeLo.rtExt) or (E > efRangeHi.rtExt) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          D := E;
          efTransfer(@D, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateSingle;
  var
    E  : Extended;
    Si : Single;
    Code : Integer;
    S    : TEditString;
  begin
    {convert efEditSt to an extended}
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, E, Code);

    if Code <> 0 then
      Result := oeInvalidNumber
    else if (E < efRangeLo.rtExt) or (E > efRangeHi.rtExt) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          Si := E;
          efTransfer(@Si, otf_SetData);
          Invalidate;
        end;
    end;
  end;

  procedure ValidateComp;
  var
    E : Extended;
    C : Comp;
    Code : Integer;
    S    : TEditString;
  begin
    {convert efEditSt to an comp}
    pbStripPicture(S, efEditSt);

    FixRealPrim(S, IntlSupport.DecimalChar);
    Val(S, C, Code);

    E := C;
    if Code <> 0 then
      Result := oeInvalidNumber
    else if (E < efRangeLo.rtExt) or (E > efRangeHi.rtExt) then
      Result := oeRangeError
    else begin
      if sefHaveFocus in sefOptions then
        if not (sefGettingValue in sefOptions) then begin
          efTransfer(@C, otf_SetData);
          Invalidate;
        end;
    end;
  end;

begin  {validate}
  Result := 0;
  case FNumericDataType of
    nftLongInt  : ValidateLongInt;
    nftWord     : ValidateWord;
    nftInteger  : ValidateInteger;
    nftByte     : ValidateByte;
    nftShortInt : ValidateShortInt;
    nftReal     : ValidateReal;
    nftExtended : ValidateExtended;
    nftDouble   : ValidateDouble;
    nftSingle   : ValidateSingle;
    nftComp     : ValidateComp;
  end;

  if not (sefUserValidating in sefOptions) then begin
    {user may retrieve data from field. flag that we are doing}
    {user validation to avoid calling this routine recursively}
    Include(sefOptions, sefUserValidating);
    DoOnUserValidation(Result);
    Exclude(sefOptions, sefUserValidating);
  end;
end;

function TOvcCustomNumericField.nfGetDataType(Value: TNumericDataType) : Byte;
  {-return a Byte value representing the type of this field}
begin
  case Value of
    nftLongInt   : Result := fidNumericLongInt;
    nftWord      : Result := fidNumericWord;
    nftInteger   : Result := fidNumericInteger;
    nftByte      : Result := fidNumericByte;
    nftShortInt  : Result := fidNumericShortInt;
    nftReal      : Result := fidNumericReal;
    nftExtended  : Result := fidNumericExtended;
    nftDouble    : Result := fidNumericDouble;
    nftSingle    : Result := fidNumericSingle;
    nftComp      : Result := fidNumericComp;
  else
    raise EOvcException.Create(GetOrphStr(SCInvalidParamValue));
  end;
end;

procedure TOvcCustomNumericField.nfReloadTmp;
  {-reload Tmp from efEditSt, etc.}
begin
  {load nfTmp}
  pbStripPicture(nfTmp, efEditSt);

  TrimAllSpacesPChar(nfTmp);

  {remove the minus sign if there is one}
  nfMinus := (nfTmp[0] = '-');
  if nfMinus then
    StrChDeletePrim(nfTmp, 0);

  {want a blank string if it's a zero}
  if (nfTmp[0] = '0') and (nfTmp[1] = #0) then
    nfTmp[0] := #0;
end;

procedure TOvcCustomNumericField.nfResetFieldProperties(FT: TNumericDataType);
  {-reset field properties}
begin
  DecimalPlaces := 0;
  case FT of
    nftLongInt   : PictureMask := 'iiiiiiiiiii';
    nftWord      : PictureMask := '99999';
    nftInteger   : PictureMask := 'iiiiii';
    nftByte      : PictureMask := '999';
    nftShortInt  : PictureMask := 'iiii';
    nftReal      : PictureMask := '##########';
    nftExtended  : PictureMask := '##########';
    nftDouble    : PictureMask := '##########';
    nftSingle    : PictureMask := '##########';
    nftComp      : PictureMask := 'iiiiiiiiii';
  else
    raise EOvcException.Create(GetOrphStr(SCInvalidParamValue));
  end;
end;

procedure TOvcCustomNumericField.nfSetDataType(Value: TNumericDataType);
  {-set the data type for this field}
begin
  if FNumericDataType <> Value then begin
    FNumericDataType := Value;
    efDataType := nfGetDataType(FNumericDataType);
    efSetDefaultRange(efDataType);

    {set defaults for this field type}
    nfResetFieldProperties(FNumericDataType);
    if HandleAllocated then begin
      {don't save data through create window}
      efSaveData := False;
      RecreateWnd;
    end;
  end;
end;

procedure TOvcCustomNumericField.nfSetDefaultRanges;
  {-set default range values based on the field type}
begin
  case FNumericDataType of
    nftLongInt, nftWord, nftInteger, nftByte, nftShortInt :
      if efRangeLo.rtLong = efRangeHi.rtLong then
        efSetDefaultRange(efDataType);
    nftReal :
      if efRangeLo.rtReal = efRangeHi.rtReal then
        efSetDefaultRange(efDataType);
    nftExtended, nftDouble, nftSingle, nftComp :
      if efRangeLo.rtExt = efRangeHi.rtExt then
        efSetDefaultRange(efDataType);
  else
    efSetDefaultRange(efDataType);
  end;
end;

procedure TOvcCustomNumericField.nfSetMaxLength(Mask : PChar);
  {-determine and set MaxLength}
var
  C : Cardinal;
begin
  FMaxLength := StrLen(Mask);

  {decrease this if Mask has special characters that}
  {should not be considered part of the display string}
  if StrChPos(Mask, pmNegParens, C) then
    Dec(FMaxLength);
  if StrChPos(Mask, pmNegHere, C) then
    Dec(FMaxLength);
end;

procedure TOvcCustomNumericField.nfSetPictureMask(const Value: string);
  {-set the picture mask}
var
  Buf : TPictureMask;
begin
  if (FPictureMask <> Value) and (Value <> '') then begin

    {test for blatantly invalid masks}
    if csDesigning in ComponentState then begin
      {check for masks like "999.99" or "iii.ii" in fields editing floating data types}
      if (efDataType mod fcpDivisor) in [fsubReal, fsubExtended, fsubDouble, fsubSingle] then
        if (Pos(pmDecimalPt, Value) > 0) and
         ((Pos(pmPositive, Value) > 0) or (Pos(pmWhole, Value) > 0)) then
          raise EInvalidPictureMask.Create(Value);
    end;

    FPictureMask := Value;
    if csDesigning in ComponentState then begin
      StrPLCopy(efPicture, FPictureMask, MaxPicture);
      efPicLen := StrLen(efPicture);
      {set MaxLength based on picture mask}
      nfSetMaxLength(efPicture);
      pbOptimizeInitPictureFlags;
      efInitializeDataSize;
      Repaint;
    end else begin
      StrPLCopy(Buf, FPictureMask, MaxPicture);
      efChangeMask(Buf);
      RecreateWnd;
    end;
  end;
end;

procedure TOvcCustomNumericField.pbRemoveSemiLits;
  {-remove semi-literal mask characters from the edit string}
begin
  if (sefHexadecimal in sefOptions) or (sefOctal in sefOptions) or
     (sefBinary in sefOptions) then
    Include(sefOptions, sefFixSemiLits)
  else
    Exclude(sefOptions, sefFixSemiLits);
end;

procedure TOvcCustomNumericField.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  {are we giving up the focus?}
  if not (sefRetainPos in sefOptions) then
    FillChar(nfTmp, SizeOf(nfTmp), #0);
end;

procedure TOvcCustomNumericField.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  //clc prevents ImeEditor from opening
  nfReloadTmp;
  efResetCaret;
end;


end.
