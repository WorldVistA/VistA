{*********************************************************}
{*                   OVCBNF.PAS 4.06                    *}
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

unit ovcdbnf;
  {-Data aware numeric field visual componnent}

interface

uses
  Windows, Classes, Controls, DB, DbConsts, DbCtrls, Forms, Graphics,
  Messages, SysUtils, OvcBase, OvcCaret, OvcConst, OvcData,
  OvcEF, OvcExcpt, OvcMisc, OvcNF;

type
  TOvcDbNumericField = class(TOvcCustomNumericField)
  

  protected {private}
    {property variables}
    FCanvas        : TControlCanvas;
    FDataLink      : TFieldDataLink;
    FFieldType     : TFieldType;
    FUseTFieldMask : Boolean;
    FZeroAsNull    : Boolean;        {True to store zero value as null}

    {internal variables}
    efdbBusy       : Boolean;
    nfdbState      : TDbEntryFieldState;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetFieldType(Value : TFieldType);
    procedure SetUseTFieldMask(Value : Boolean);
    procedure SetZeroAsNull(Value : Boolean);

    {internal methods}
    procedure nfdbDataChange(Sender : TObject);
    procedure nfdbEditingChange(Sender : TObject);
    procedure nfdbGetFieldValue;
    procedure nfdbSetFieldProperties;
    procedure nfdbSetFieldValue;
    procedure nfdbUpdateData(Sender : TObject);

    {vcl methods}
    procedure CMEnter(var Msg : TMessage);
      message CM_ENTER;
    procedure CMExit(var Msg : TMessage);
      message CM_EXIT;
    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

    {windows message methods}
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN    ;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMLButtonDblClk(var Msg : TWMLButtonDblClk);
      message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg : TWMLButtonUp);
      message WM_LBUTTONUP;
    procedure WMPaint(var Msg : TWMPaint);
      message WM_PAINT;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    procedure DoOnChange;
      override;
      {-perform OnChange notification}

    procedure efEdit(var Msg : TMessage; Cmd : Word);
      override;
      {-process the specified editing command}
    procedure efGetSampleDisplayData(T : PChar);
      override;
      {-return a design time display string}
    procedure efIncDecValue(Wrap : Boolean; Delta : Double);
      override;
      {-increment field by Delta}
    function efIsReadOnly : Boolean;
      override;
      {-get the field's read-only status}
    procedure nfSetPictureMask(const Value : string);
      override;
      {-set the picture mask}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure Restore;
      override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

    procedure CutToClipboard;
      override;
      {-copy highlighted text to the clipboard and then delete it}
    procedure PasteFromClipboard;
      override;
      {-paste the contents of the clipboard}

    property Field : TField
      read GetField;

  published
    property DataField : string
      read GetDataField
      write SetDataField;

    property DataSource : TDataSource
      read GetDataSource
      write SetDataSource;

    property FieldType : TFieldType
      read FFieldType
      write SetFieldType default ftUnknown;

    property UseTFieldMask : Boolean
      read FUseTFieldMask
      write SetUseTFieldMask default False;

    property ZeroAsNull : Boolean
      read FZeroAsNull
      write SetZeroAsNull default False;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property AutoSize;
    property Borders;
    property BorderStyle;
    property CaretIns;
    property CaretOvr;
    property Color;
    property Controller;
    property Ctl3D;
    property Cursor default crIBeam;
    property DragCursor;
    property DragMode;
    property EFColors;
    property Enabled;
    property Font;
    property LabelInfo;
    property Options default [];
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
    property Visible;

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

uses
  Types;

const
  {field types supported by the data aware numeric field}
  SupportedFieldTypes : set of  TFieldType =
    [ftSmallInt, ftInteger, ftWord,
     ftFloat, ftCurrency, ftBCD];


procedure TOvcDbNumericField.CMEnter(var Msg : TMessage);
begin
  Include(nfDbState, esSelected);

  inherited;
end;

procedure TOvcDbNumericField.CMExit(var Msg : TMessage);
begin
  inherited;
end;

procedure TOvcDbNumericField.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbNumericField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange    := nfdbDataChange;
  FDataLink.OnEditingChange := nfdbEditingChange;
  FDataLink.OnUpdateData    := nfdbUpdateData;
  FUseTFieldMask            := False;
  FZeroAsNull               := False;

  {clear all states}
  nfdbState := [];
end;

procedure TOvcDbNumericField.CreateWnd;
begin
  inherited CreateWnd;

  if Field <> nil then begin
    FieldType := Field.DataType;
    nfdbSetFieldValue;
  end;
end;

procedure TOvcDbNumericField.CutToClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);
  inherited CutToClipboard;
  nfdbGetFieldValue;
end;

destructor TOvcDbNumericField.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;
  FCanvas := nil;

  inherited Destroy;
end;

procedure TOvcDbNumericField.DoOnChange;
begin
  FDataLink.Modified;

  {clear uninitialized flag}
  if efoInputRequired in Options then
    Uninitialized := False;

  inherited DoOnChange;
end;

procedure TOvcDbNumericField.efEdit(var Msg : TMessage; Cmd : Word);
begin
  if DataSource = nil then
    Exit;

  if (Cmd = ccPaste) or (Cmd = ccCut) then begin
    if DataSource.AutoEdit then begin
      FDataLink.Edit;
      Exclude(nfdbState, esSelected);
    end;
    if FDataLink.Editing then
      inherited efEdit(Msg, Cmd);
  end else
    inherited efEdit(Msg, Cmd);

  if efSelStart <> efSelEnd then
    Include(nfdbState, esSelected);
end;

procedure TOvcDbNumericField.efGetSampleDisplayData(T : PChar);
var
  S : string;
  P : Integer;
begin
  {overridden to supply live data for the field display}
  if (Field <> nil) and FDataLink.Active then begin
    if FFieldType in SupportedFieldTypes then  begin
      nfdbSetFieldValue;
      efGetDisplayString(T, MaxEditLen+1);
    end else begin
      S := Field.ClassName;
      S[1] := '(';
      P := Pos('Field', S);
      if P > 0 then begin
        S[P] := ')';
        SetLength(s,p);
        //S[0] := Char(P);
      end else
        S := Concat(S, ')');
      StrPCopy(T, S);
    end;
  end else
    inherited efGetSampleDisplayData(T);
end;

procedure TOvcDbNumericField.efIncDecValue(Wrap : Boolean; Delta : Double);
begin
  if DataSource = nil then
    Exit;

  if DataSource.AutoEdit and (Delta <> 0) then begin
    FDataLink.Edit;
    Exclude(nfdbState, esSelected);
  end;

  if FDataLink.Editing or (Delta = 0) then
    inherited efIncDecValue(Wrap, Delta);
end;

function TOvcDbNumericField.efIsReadOnly : Boolean;
  {-get the fields read-only status}
begin
  if csDesigning in ComponentState then
    Result := inherited efIsReadOnly
  else begin
    Result := inherited efIsReadOnly or (DataSource = nil) or (not FDataLink.CanModify);
    if not (FFieldType in SupportedFieldTypes) then
      Result := True;
    if not Result and Enabled then
      Result := not (DataSource.State in [dsEdit, dsInsert]);
  end;
end;

function TOvcDbNumericField.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbNumericField.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbNumericField.GetField : TField;
begin
  Result := FDataLink.Field;

  {Result will be nil if the datasource is not active. At design-time}
  {the field information can be obtained if a corresponding field    }
  {component has been added to the form (by using the Fields Editor).}
  if (Result = nil) and (csDesigning in ComponentState) then begin
    if (DataSource <> nil) and (DataSource.DataSet <> nil) then
      try
        Result := DataSource.DataSet.FieldByName(FDataLink.FieldName);
      except
        {ignore errors}
      end;
  end;
end;

procedure TOvcDbNumericField.nfdbDataChange(Sender : TObject);
begin
  if Field <> nil then begin
    {if field data type has changed, reset properties}
    if Field.DataType <> FFieldType then
      nfdbSetFieldProperties;

    {force field to reset highlight and caret position}
    if not (DataSource.State in [dsEdit, dsInsert]) then begin
      Include(nfdbState, esReset);
      Include(nfdbState, esSelected);
    end;

    nfdbSetFieldValue;
  end else
    efSetInitialValue;

  Invalidate;
end;

procedure TOvcDbNumericField.nfdbEditingChange(Sender : TObject);
begin
  if (DataSource = nil) or (DataSource.State <> dsEdit) then
    Include(nfdbState, esSelected);
end;

procedure TOvcDbNumericField.nfdbGetFieldValue;
var
  E  : Extended;
  I  : SmallInt absolute E;
  L  : Integer absolute E;
  W  : Word absolute E;

  function FieldIsZero : Boolean;
  begin
    case FFieldType of
      ftSmallInt : Result := I = 0;
      ftInteger  : Result := L = 0;
      ftWord     : Result := W = 0;
      ftFloat    : Result := E = 0;
      ftCurrency : Result := E = 0;
      ftBCD      : Result := E = 0;
    else
      Result := False;
    end;
  end;

begin
  {if the field contents are invalid, exit}
  if not Controller.ErrorPending then {avoid multiple error reports}
    if not ValidateSelf then
      Exit;

  if Field <> nil then begin
    {get the entry field value}
    FLastError :=  Self.GetValue(E);

    {if error, don't update the field object}
    if FLastError <> 0 then
      Exit;

    {if the field is empty, just clear the db field}
    if efFieldIsEmpty or (ZeroAsNull and FieldIsZero) then
      Field.Clear
    else
      case FFieldType of
        ftSmallInt : Field.AsInteger := I;
        ftInteger  : Field.AsInteger := L;
        ftWord     : Field.AsInteger := W;
        ftFloat    : Field.AsFloat := E;
        ftCurrency : Field.AsFloat := E;
        ftBCD      : Field.AsFloat := E;
      end;
  end;
end;

procedure TOvcDbNumericField.nfdbSetFieldProperties;
begin
  case FFieldType of
    ftSmallInt : DataType := nftInteger;
    ftInteger  : DataType := nftLongInt;
    ftWord     : DataType := nftWord;
    ftFloat    : DataType := nftExtended;
    ftCurrency : DataType := nftExtended;
    ftBCD      : DataType := nftExtended;
  end;
  {save current field type}
  if Field <> nil then
    FieldType := Field.DataType;
  {clear all states}
  nfdbState := [];
end;

procedure TOvcDbNumericField.nfdbSetFieldValue;
var
  E  : Extended;
  I  : SmallInt absolute E;
  L  : Integer absolute E;
  W  : Word absolute E;
  P  : Integer;
  SS : Integer;
  SE : Integer;
  M  : Boolean;
  EM : Boolean;
  F  : Extended; {used to compare old and new value}
  Pt : TPoint;
begin
  if efdbBusy then
    Exit;

  Pt := efCaret.Position;

  nftmp[0] := #0;

  {clear to insure match before transfer}
  FillChar(E, SizeOf(E), 0);
  FillChar(F, SizeOf(F), 0);

  if Field <> nil then begin
    case FFieldType of
      ftSmallInt : I := Field.AsInteger;
      ftInteger  : L := Field.AsInteger;
      ftWord     : W := Field.AsInteger;
      ftFloat    : E := Field.AsFloat;
      ftCurrency : E := Field.AsFloat;
      ftBCD      : E := Field.AsFloat;
    end;
    P := efHPos;

    Include(sefOptions, sefNoUserValidate);
    efdbBusy := True;
    try
      {get copy of current field value}
      Self.GetValue(F);
      SS := efSelStart;
      SE := efSelEnd;

      {store current modified states}
      EM := EverModified;
      M := Modified;

      {set field value}
      Self.SetValue(E);

      {restore modified states}
      if M then Include(sefOptions, sefModified);
      if EM then Include(sefOptions, sefEverModified);

    finally
      Exclude(sefOptions, sefNoUserValidate);
      efdbBusy := False;
    end;

    {if field value changed, call DoOnChange}
    if CompStruct(E, F, Self.DataSize) <> 0 then
      inherited DoOnChange;

    if not (esSelected in nfdbState) and not (csDesigning in ComponentState) then
      SetSelection(P, P)
    else if (esSelected in nfdbState) then
      SetSelection(SS, SE);

    {adjust highlight and caret position}
    if esReset in nfdbState then begin

(*
      if ControllerAssigned then
        if efoAutoSelect in Controller.EntryOptions then
          SetSelection(0, MaxEditLen);

      efHOffset := 0;
      efResetCaret;
      efPositionCaret(True);
*)
      efCaret.Position := Pt;
      Exclude(nfdbState, esReset);
    end;
  end;
end;

procedure TOvcDbNumericField.nfdbUpdateData(Sender : TObject);
var
  Valid : Boolean;
begin
  if Field <> nil then begin
    if not Modified or not (sefHaveFocus in sefOptions) then
      Include(sefOptions, sefNoUserValidate);
    try
      if Modified then
        Valid := ValidateContents(not Controller.ErrorPending) = 0
      else
        Valid := True;

      Include(sefOptions, sefNoUserValidate);
      if Modified and Valid then
        nfdbGetFieldValue;

      {raise an exception to halt any BDE scroll actions}
      if not Valid then
        SysUtils.Abort;

    finally
      Exclude(sefOptions, sefNoUserValidate);
    end;
  end;
end;

procedure TOvcDbNumericField.nfSetPictureMask(const Value : string);
  {-set the picture mask}
begin
  inherited nfSetPictureMask(Value);

  if csDesigning in ComponentState then
    RecreateWnd;
end;

procedure TOvcDbNumericField.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    nfdbSetFieldProperties;
    Refresh;
  end;
end;

procedure TOvcDbNumericField.PasteFromClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);
  inherited PasteFromClipboard;
  nfdbGetFieldValue;
end;

procedure TOvcDbNumericField.Restore;
  {-restore the field contents}
begin
  inherited Restore;

  Include(nfdbState, esSelected);
  FDataLink.Reset;
end;

procedure TOvcDbNumericField.SetDataField(const Value : string);
begin
  try
    FDataLink.FieldName := Value;
  except
    FDataLink.FieldName := '';
    raise;
  end;
  nfdbSetFieldProperties;
  Refresh;
  if csDesigning in ComponentState then
    RecreateWnd;
end;

procedure TOvcDbNumericField.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  nfdbSetFieldProperties;
  Refresh;
end;

procedure TOvcDbNumericField.SetFieldType(Value : TFieldType);
begin
  if (Value <> FFieldType) and (Value in SupportedFieldTypes) then begin
    FFieldType := Value;
    nfdbSetFieldProperties;
  end;

  if not (csLoading in ComponentState) then
    if (csDesigning in ComponentState) and not (Value in SupportedFieldTypes) then
      raise EOvcException.Create(GetOrphStr(SCInvalidFieldType));
end;

procedure TOvcDbNumericField.SetUseTFieldMask(Value : Boolean);
begin
  if (Value <> FUseTFieldMask) then begin
    FUseTFieldMask := Value;
    Invalidate;
  end;
end;

procedure TOvcDbNumericField.SetZeroAsNull(Value : Boolean);
begin
  if Value <> FZeroAsNull then
    FZeroAsNull := Value;
end;

procedure TOvcDbNumericField.WMKeyDown(var Msg : TWMKeyDown);
var
  Shift  : Boolean;
  Insert : Boolean;
begin
  case Msg.CharCode of
    VK_F1..VK_F12,
    VK_RETURN,
    VK_ESCAPE,
    VK_NONE,
    VK_SHIFT,
    VK_CONTROL,
    VK_ALT,
    VK_CAPITAL,
    VK_NUMLOCK,
    VK_SCROLL,
    VK_PRIOR,
    VK_NEXT,
    VK_TAB      : {};
    VK_HOME,
    VK_END,
    VK_UP,
    VK_DOWN,
    VK_LEFT,
    VK_RIGHT    : Exclude(nfdbState, esSelected);
  else
    if (DataSource <> nil) and DataSource.AutoEdit then begin
      if not inherited efIsReadOnly then begin
        {special handling for <Ins> and <Shift><Ins> key sequences}
        Shift := (GetAsyncKeyState(VK_SHIFT) and $8000 <> 0);
        Insert := (Msg.CharCode = VK_INSERT);
        if not Insert or (Shift and Insert) then begin
          FDataLink.Edit;
          Exclude(nfdbState, esSelected);
        end;
      end;
    end;
  end;

  inherited;
end;

procedure TOvcDbNumericField.WMKillFocus(var Msg : TWMKillFocus);
begin
  Exclude(nfdbState, esFocused);

  inherited;

  if (LastError = 0) and FDataLink.Editing then
    if Modified and not Controller.ErrorPending then
      if not Controller.IsSpecialButton(Msg.FocusedWnd) then
        nfdbGetFieldValue;
end;

procedure TOvcDbNumericField.WMLButtonDblClk(var Msg : TWMLButtonDblClk);
begin
  inherited;

  Include(nfdbState, esSelected);
end;

procedure TOvcDbNumericField.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  inherited;

  Exclude(nfdbState, esSelected);
end;

procedure TOvcDbNumericField.WMLButtonUp(var Msg : TWMLButtonUp);
begin
  inherited;

  if SelectionLength > 0 then
    Include(nfdbState, esSelected);
end;

procedure TOvcDbNumericField.WMPaint(var Msg : TWMPaint);
var
  Indent   : Integer;
  R        : TRect;
  DC       : hDC;
  bError   : Boolean;
  bActive  : Boolean;
  bFocused : Boolean;
  bNotMask : Boolean;
  PS       : TPaintStruct;
  S        : string;
  T        : TEditString;
begin
  bError := (LastError <> 0);
  bActive := (FDataLink.DataSet <> nil) and FDataLink.Active;
  bFocused := (esFocused in nfdbState) and not (csPaintCopy in ControlState);
  bNotMask := not UseTFieldMask and not (csPaintCopy in ControlState);
  if not bActive or bError or bFocused or bNotMask then begin
    inherited;
    Exit;
  end;

  if FCanvas = nil then begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;

  DC := Msg.DC;
  if DC = 0 then
    DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    FCanvas.Font := Font;

    if not Enabled then begin {and (Color <> clGrayText) then begin}
{      FCanvas.Font.Color := clGrayText;}
      FCanvas.Font.Color := EFColors.Disabled.TextColor;
      FCanvas.Brush.Color := EFColors.Disabled.BackColor
    end else
      FCanvas.Brush.Color := Color;

    with FCanvas do begin
      R := ClientRect;
{      Brush.Color := Color;}


      {get text to display}
      if Field <> nil then
        S := Field.DisplayText
      else begin
        efGetSampleDisplayData(T);
        S := StrPas(T);
      end;

      if Field <> nil then begin
        case Field.Alignment of
          taLeftJustify  :
            Indent := TextMargin - 1;
          taRightJustify :
            Indent := ClientWidth - TextWidth(S) - TextMargin - 1;
        else
          Indent := (ClientWidth - TextWidth(S)) div 2;
        end;
      end else
        Indent := ClientWidth - TextWidth(S) - TextMargin - 1;

      {TextRect(R, Indent, efTopMargin, S);}
      FillRect(R);
      StrPLCopy(T, S, MaxEditLen);
      if (Enabled) then
        SetBkColor(FCanvas.Handle, Graphics.ColorToRGB(Color))
      else
        SetBkColor(FCanvas.Handle,
                   Graphics.ColorToRGB(EFColors.Disabled.BackColor));
      ExtTextOut(FCanvas.Handle, Indent, efTopMargin,
        ETO_CLIPPED, @R, T, StrLen(T), nil);
    end;
  finally
    FCanvas.Handle := 0;
    if Msg.DC = 0 then
      EndPaint(Handle, PS);
  end;
end;

procedure TOvcDbNumericField.WMSetFocus(var Msg : TWMSetFocus);
begin
  Include(nfdbState, esFocused);

  if LastError = 0 then
    nfdbSetFieldValue;

  inherited;
end;

function TOvcDbNumericField.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbNumericField.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.
