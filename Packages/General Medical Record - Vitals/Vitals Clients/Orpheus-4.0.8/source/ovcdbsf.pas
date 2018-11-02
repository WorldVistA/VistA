{*********************************************************}
{*                   OVCDBSF.PAS 4.06                    *}
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

unit ovcdbsf;
  {-Data aware simple field visual componnent}

interface

uses
  Windows, Classes, Controls, DB, DbConsts, DbCtrls, Forms, Graphics,dialogs,
  Menus, Messages, SysUtils, OvcBase, OvcCaret, OvcCmd, OvcColor, OvcConst,
  OvcData, OvcEF, OvcExcpt, OvcMisc, OvcSF, OvcBordr;

type
  TOvcDbSimpleField = class(TOvcCustomSimpleField)
  protected {private}
    {property variables}
    FCanvas        : TControlCanvas;
    FDataLink      : TFieldDataLink;
    FFieldType     : TFieldType;
    FUseTFieldMask : Boolean;
    FZeroAsNull    : Boolean;        {True to store zero value as null}

    {internal variables}
    efdbBusy       : Boolean;
    sfdbState      : TDbEntryFieldState;

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
    procedure sfdbDataChange(Sender : TObject);
    procedure sfdbEditingChange(Sender : TObject);
    procedure sfdbGetFieldValue;
    procedure sfdbSetFieldProperties;
    procedure sfdbSetFieldValue;
    procedure sfdbUpdateData(Sender : TObject);

    {vcl methods}
    procedure CMEnter(var Msg : TMessage);
      message CM_ENTER;
    procedure CMExit(var Msg : TMessage);
      message CM_EXIT;
    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

    {windows message methods}
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
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

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;
    procedure Restore;
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
    property ControlCharColor default clRed;
    property Controller;
    property Ctl3D;
    property Cursor default crIBeam;
    property DecimalPlaces default 0;
    property DragCursor;
    property DragMode;
    property EFColors;
    property Enabled;
    property Font;
    property LabelInfo;
    property MaxLength;
    property Options;
    property PadChar;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PictureMask default 'X';
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
  {field types supported by the data aware simple field}
  SupportedFieldTypes : set of  TFieldType =
    [ftString, ftSmallInt, ftInteger, ftWord, ftBoolean, ftFloat,
     ftCurrency, ftBCD, ftWideString];


procedure TOvcDbSimpleField.CMEnter(var Msg : TMessage);
begin
  Include(sfDbState, esSelected);

  inherited;
end;

procedure TOvcDbSimpleField.CMExit(var Msg : TMessage);
begin
  inherited;
end;

procedure TOvcDbSimpleField.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbSimpleField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange    := sfdbDataChange;
  FDataLink.OnEditingChange := sfdbEditingChange;
  FDataLink.OnUpdateData    := sfdbUpdateData;
  FUseTFieldMask            := False;
  FZeroAsNull               := False;

  {clear all states}
  sfdbState := [];
end;

procedure TOvcDbSimpleField.CreateWnd;
begin
  inherited CreateWnd;

  if Field <> nil then begin
    FieldType := Field.DataType;
    sfdbSetFieldValue;
  end;
end;

procedure TOvcDbSimpleField.CutToClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);
  inherited CutToClipboard;
  sfdbGetFieldValue;
end;

destructor TOvcDbSimpleField.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;
  FCanvas := nil;

  inherited Destroy;
end;

procedure TOvcDbSimpleField.DoOnChange;
begin
  FDataLink.Modified;

  {clear uninitialized flag}
  if efoInputRequired in Options then
    Uninitialized := False;

  inherited DoOnChange;
end;

procedure TOvcDbSimpleField.efEdit(var Msg : TMessage; Cmd : Word);
begin
  if DataSource = nil then
    Exit;

  if (Cmd = ccPaste) or (Cmd = ccCut) then begin
    if DataSource.AutoEdit then begin
      FDataLink.Edit;
      Exclude(sfdbState, esSelected);
    end;
    if FDataLink.Editing then
      inherited efEdit(Msg, Cmd);
  end else
    inherited efEdit(Msg, Cmd);

  if efSelStart <> efSelEnd then
    Include(sfdbState, esSelected);
end;

procedure TOvcDbSimpleField.efGetSampleDisplayData(T : PChar);
var
  S : string;
  P : Integer;
begin
  {overridden to supply live data for the field display}
  if (Field <> nil) and FDataLink.Active then begin
    if FFieldType in SupportedFieldTypes then begin
      sfdbSetFieldValue;
      efGetDisplayString(T, MaxEditLen+1);
    end else begin
      S := Field.ClassName;
      S[1] := '(';
      P := Pos('Field', S);
      if P > 0 then begin
        S[P] := ')';
        setlength(s,p);
        //S[0] := Char(P);
      end else
        S := Concat(S, ')');
      StrPCopy(T, S);
    end;
  end else
    inherited efGetSampleDisplayData(T);
end;

procedure TOvcDbSimpleField.efIncDecValue(Wrap : Boolean; Delta : Double);
begin
  if DataSource = nil then
    Exit;

  if DataSource.AutoEdit and (Delta <> 0) then begin
    FDataLink.Edit;
    Exclude(sfdbState, esSelected);
  end;

  if FDataLink.Editing or (Delta = 0) then
    inherited efIncDecValue(Wrap, Delta);
end;

function TOvcDbSimpleField.efIsReadOnly : Boolean;
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

function TOvcDbSimpleField.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbSimpleField.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbSimpleField.GetField : TField;
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

procedure TOvcDbSimpleField.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    sfdbSetFieldProperties;
    Refresh;
  end;
end;

procedure TOvcDbSimpleField.PasteFromClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);
  inherited PasteFromClipboard;
  sfdbGetFieldValue;
end;

procedure TOvcDbSimpleField.Restore;
  {-restore the field contents}
begin
  inherited Restore;

  Include(sfdbState, esSelected);
  FDataLink.Reset;
end;

procedure TOvcDbSimpleField.SetDataField(const Value : string);
begin
  try
    FDataLink.FieldName := Value;
  except
    FDataLink.FieldName := '';
    raise;
  end;
  sfdbSetFieldProperties;
  Refresh;
  if csDesigning in ComponentState then
    RecreateWnd;
end;

procedure TOvcDbSimpleField.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  sfdbSetFieldProperties;
  Refresh;
end;

procedure TOvcDbSimpleField.SetFieldType(Value : TFieldType);
begin
  if (Value <> FFieldType) and (Value in SupportedFieldTypes) then begin
    FFieldType := Value;
    sfdbSetFieldProperties;
  end;

  if not (csLoading in ComponentState) then
    if (csDesigning in ComponentState) and not (Value in SupportedFieldTypes) then
      raise EOvcException.Create(GetOrphStr(SCInvalidFieldType));
end;

procedure TOvcDbSimpleField.SetUseTFieldMask(Value : Boolean);
begin
  if (Value <> FUseTFieldMask) then begin
    FUseTFieldMask := Value;
    Invalidate;
  end;
end;

procedure TOvcDbSimpleField.SetZeroAsNull(Value : Boolean);
begin
  if Value <> FZeroAsNull then
    FZeroAsNull := Value;
end;

procedure TOvcDbSimpleField.sfdbDataChange(Sender : TObject);
begin
  if Field <> nil then begin
    {if field data type has changed, reset properties}
    if Field.DataType <> FFieldType then
      sfdbSetFieldProperties;

    {force field to reset highlight and caret position}
    if not (DataSource.State in [dsEdit, dsInsert]) then begin
      Include(sfdbState, esReset);
      Include(sfdbState, esSelected);
    end;

    sfdbSetFieldValue;
  end else
    efSetInitialValue;

  Invalidate;
end;

procedure TOvcDbSimpleField.sfdbEditingChange(Sender : TObject);
begin
  if (DataSource = nil) or (DataSource.State <> dsEdit) then
    Include(sfdbState, esSelected);
end;

procedure TOvcDbSimpleField.sfdbGetFieldValue;
var
  S : string[MaxEditLen];
  I : SmallInt absolute S;
  L : Integer absolute S;
  W : Word absolute S;
  B : Boolean absolute S;
  E : Extended absolute S;
  sValue: string;

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

  if Field <> nil then
  begin
    {get the entry field value}
    case FFieldType of
      ftString, ftWideString:
{ 06/2011, AB fix for a bug discovered by Yeimi Osorio (in TOvcDBPictureField, issue 3305212)
           GetValue expects a string here }
        FLastError := Self.GetValue(sValue);
      else FLastError := Self.GetValue(S);
    end;

    {if error, don't update the field object}
    if FLastError <> 0 then
      Exit;

    {if the field is empty, just clear the db field}
    if efFieldIsEmpty or (ZeroAsNull and FieldIsZero) then
      Field.Clear
    else
      case FFieldType of
        ftString, ftWideString
                     : Field.AsString  := sValue;
        ftSmallInt   : Field.AsInteger := I;
        ftInteger    : Field.AsInteger := L;
        ftWord       : Field.AsInteger := W;
        ftBoolean    : Field.AsBoolean := B;
        ftFloat      : Field.AsFloat   := E;
        ftCurrency   : Field.AsFloat   := E;
        ftBCD        : Field.AsFloat   := E;
      end;
  end;
end;

procedure TOvcDbSimpleField.sfdbSetFieldProperties;
begin
  case FFieldType of
    ftString, ftWideString:
      begin
        DataType := sftString;
        if Field <> nil then
          MaxLength := Field.DisplayWidth;
      end;
    ftSmallInt : DataType := sftInteger;
    ftInteger  : DataType := sftLongInt;
    ftWord     : DataType := sftWord;
    ftBoolean  : DataType := sftBoolean;
    ftFloat    : DataType := sftExtended;
    ftCurrency : DataType := sftExtended;
    ftBCD      : DataType := sftExtended;
  else
    {default to string}
    DataType := sftString;
  end;

  {save current field type}
  if Field <> nil then
    FieldType := Field.DataType;

  {clear all states}
  sfdbState := [];
end;

procedure TOvcDbSimpleField.sfdbSetFieldValue;
var
  S  : string[MaxEditLen];
  I  : SmallInt absolute S;
  L  : Integer absolute S;
  W  : Word absolute S;
  B  : Boolean absolute S;
  E  : Extended absolute S;
  P  : Integer;
  SS : Integer;
  SE : Integer;
  M  : Boolean;
  EM : Boolean;
  F  : array[0..255] of Byte; {used to compare old and new value}
  sNewValue: string;
  sOldValue: string;
begin
  if efdbBusy then
    Exit;

  {clear to insure match before transfer}
  FillChar(S, SizeOf(S), 0);
  FillChar(F, SizeOf(F), 0);

  if Field <> nil then begin
    case FFieldType of
      ftString, ftWideString
                   : sNewValue := Field.AsString;
      ftSmallInt   : I := Field.AsInteger;
      ftInteger    : L := Field.AsInteger;
      ftWord       : W := Field.AsInteger;
      ftBoolean    : B := Field.AsBoolean;
      ftFloat      : E := Field.AsFloat;
      ftCurrency   : E := Field.AsFloat;
      ftBCD        : E := Field.AsFloat;
    else
      sNewValue := Field.AsString;
    end;
    P := efHPos;

    Include(sefOptions, sefNoUserValidate);
    efdbBusy := True;
    try
      {get copy of current field value}
      if FFieldType in [ftString, ftWideString] then
        GetValue(sOldValue)
      else
        Self.GetValue(F);
      SS := efSelStart;
      SE := efSelEnd;

      {store current modified states}
      EM := EverModified;
      M := Modified;

      {set field value}
      case FFieldType of
        ftString, ftWideString: SetValue(sNewValue);
        ftSmallInt,
        ftInteger,
        ftWord,
        ftBoolean,
        ftFloat,
        ftCurrency,
        ftBCD        : SetValue(S);
        else
          SetValue(sNewValue);
      end;

      {restore modified states}
      if M then Include(sefOptions, sefModified);
      if EM then Include(sefOptions, sefEverModified);

    finally
      Exclude(sefOptions, sefNoUserValidate);
      efdbBusy := False;
    end;

    {if field value changed, call DoOnChange}
    if FFieldType in [ftString, ftWideString] then
    begin
      if sOldValue <> sNewValue then
        inherited DoOnChange;
    end
    else
    begin
      if CompStruct(S, F, Self.DataSize) <> 0 then
        inherited DoOnChange;
    end;

    if not (esSelected in sfdbState) and not (csDesigning in ComponentState) then begin
      {return caret and highlight state}
      SetSelection(P, P);
      efHPos := P;
      efPositionCaret(False);
    end else if (esSelected in sfdbState) then
      SetSelection(SS, SE);

    {adjust highlight and caret position}
    if esReset in sfdbState then begin
      SetSelection(0, MaxEditLen);
      efResetCaret;
      efPositionCaret(True);
      Exclude(sfdbState, esReset);
    end;
  end;
end;

procedure TOvcDbSimpleField.sfdbUpdateData(Sender : TObject);
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
        sfdbGetFieldValue;

      {raise an exception to halt any BDE scroll actions}
      if not Valid then
        SysUtils.Abort;

    finally
      Exclude(sefOptions, sefNoUserValidate);
    end;
  end;
end;

procedure TOvcDbSimpleField.WMKeyDown(var Msg : TWMKeyDown);
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
    VK_UP,
    VK_DOWN,
    VK_HOME,
    VK_END,
    VK_LEFT,
    VK_RIGHT    : Exclude(sfdbState, esSelected);
  else
    if (DataSource <> nil) and DataSource.AutoEdit then begin
      if not inherited efIsReadOnly then begin
        {special handling for <Ins> and <Shift><Ins> key sequences}
        Shift := (GetAsyncKeyState(VK_SHIFT) and $8000 <> 0);
        Insert := (Msg.CharCode = VK_INSERT);
        if not Insert or (Shift and Insert) then begin
          FDataLink.Edit;
          Exclude(sfdbState, esSelected);
        end;
      end;
    end;
  end;

  inherited;
end;

procedure TOvcDbSimpleField.WMKillFocus(var Msg : TWMKillFocus);
begin
  Exclude(sfdbState, esFocused);

  inherited;

  if (LastError = 0) and FDataLink.Editing then
    if Modified and not Controller.ErrorPending then
      if not Controller.IsSpecialButton(Msg.FocusedWnd) then
        sfdbGetFieldValue;
end;

procedure TOvcDbSimpleField.WMLButtonDblClk(var Msg : TWMLButtonDblClk);
begin
  inherited;

  Include(sfdbState, esSelected);
end;

procedure TOvcDbSimpleField.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  efHPos := 0;

  inherited;

  Exclude(sfdbState, esSelected);
end;

procedure TOvcDbSimpleField.WMLButtonUp(var Msg : TWMLButtonUp);
begin
  inherited;

  if SelectionLength > 0 then
    Include(sfdbState, esSelected);
end;

procedure TOvcDbSimpleField.WMPaint(var Msg : TWMPaint);
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
  bFocused := (esFocused in sfdbState) and not (csPaintCopy in ControlState);
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

      if efoPasswordMode in Options then
        FillChar(S[1], Length(S), PasswordChar);

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
        Indent := TextMargin - 1;

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

procedure TOvcDbSimpleField.WMSetFocus(var Msg : TWMSetFocus);
begin
  Include(sfdbState, esFocused);

  if LastError = 0 then
    sfdbSetFieldValue;

  inherited;
end;

function TOvcDbSimpleField.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbSimpleField.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.
