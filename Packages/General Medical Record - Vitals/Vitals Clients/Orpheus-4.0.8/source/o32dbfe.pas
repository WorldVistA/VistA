{*********************************************************}
{*                   O32DBFE.PAS 4.06                    *}
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

unit o32dbfe;
  {-Data aware flexedit component}

interface

uses
  Windows, Classes, Controls, DB, DbConsts, DbCtrls, Forms, Graphics, dialogs,
  Menus, Messages, SysUtils, OvcBase, OvcColor, OvcConst, OvcData, OvcEF,
  OvcExcpt, OvcMisc, O32FlxEd, Types;

type
  TO32DbFlexEdit = class(TO32CustomFlexEdit)
  protected {private}
    {property variables}
    FCanvas        : TControlCanvas;
    FDataLink      : TFieldDataLink;
    FFieldType     : TFieldType;
    FUseTFieldMask : Boolean;
    {internal variables}
    fedbBusy       : Boolean;
    fedbState      : TDbEntryFieldState;
    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetFieldType(Value : TFieldType);
    procedure SetUseTFieldMask(Value : Boolean);
    {internal methods}
    procedure fedbDataChange(Sender : TObject);
    procedure fedbEditingChange(Sender : TObject);
    procedure fedbGetFieldValue;
    procedure fedbSetFieldProperties;
    procedure fedbSetFieldValue;
    procedure fedbUpdateData(Sender : TObject);
    {vcl methods}
    procedure CMEnter(var Msg : TMessage);       message CM_ENTER;
    procedure CMExit(var Msg : TMessage);        message CM_EXIT;
    procedure CMGetDataLink(var Msg : TMessage); message CM_GETDATALINK;
    {windows message methods}
    procedure WMKeyDown(var Msg : TWMKeyDown);   message WM_KEYDOWN;
    procedure WMChar(var Msg : TWMChar); message WM_CHAR;
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDblClk(var Msg : TWMLButtonDblClk);
      message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Msg : TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg : TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMPaint(var Msg : TWMPaint); message WM_PAINT;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;

  protected
    procedure CreateWnd; override;
    procedure Notification(AComponent : TComponent;
                           Operation : TOperation); override;
    procedure DoOnChange; override;
      {-perform OnChange notification}
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    procedure Restore; override;
    procedure CutToClipboard; reintroduce;
      {-copy highlighted text to the clipboard and then delete it}
    procedure PasteFromClipboard; reintroduce;
      {-paste the contents of the clipboard}
    property Field : TField read GetField;
  published
    property DataField : string read GetDataField write SetDataField;
    property DataSource : TDataSource read GetDataSource write SetDataSource;
    property FieldType : TFieldType read FFieldType write SetFieldType
      default ftUnknown;
    property UseTFieldMask : Boolean read FUseTFieldMask write SetUseTFieldMask
      default False;

    {inherited properties}

//    property Alignment; Not in a db-field
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property DragMode;
    property ParentBiDiMode;
    property AutoSize default False;
    property About;
    property AutoSelect;
    property Borders;
    property ButtonGlyph;
    property CharCase;
    property Color;
    property Cursor;
    property DragCursor;
    property EditLines;
    property EFColors;
    property Enabled;
    property Font;
    property HideSelection;
    property Ctl3D;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property PopupAnchor default paLeft;
    property PopupMenu;
    property ReadOnly;
    property ShowButton default False;
    property LabelInfo;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ShowHint;
    property TabOrder;
    property Text;
    property Validation;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property TabStop default True;
    property Tag;
    property Visible;

    {inherited events}
    property AfterValidation;
    property BeforeValidation;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnStartDrag;
    property OnUserValidation;
    property OnValidationError;
  end;


implementation

uses
  O32Vlop1, OvcUtils, OvcFormatSettings;

const
  {field types supported by the data aware FlexEdit}
  SupportedFieldTypes : set of  TFieldType =
    [ftString, ftSmallInt, ftInteger, ftWord, ftDate, ftBoolean, ftFloat,
     ftCurrency, ftBCD, ftWideString];


procedure TO32dbFlexEdit.CMEnter(var Msg : TMessage);
begin
  Include(feDbState, esSelected);

  inherited;
end;
{=====}

procedure TO32dbFlexEdit.CMExit(var Msg : TMessage);
begin
  inherited;
end;
{=====}

procedure TO32dbFlexEdit.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;
{=====}

constructor TO32dbFlexEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csReplicatable];
  
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange    := fedbDataChange;
  FDataLink.OnEditingChange := fedbEditingChange;
  FDataLink.OnUpdateData    := fedbUpdateData;
  FUseTFieldMask            := False;

  {clear all states}
  fedbState := [];
end;
{=====}

destructor TO32dbFlexEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;
  FCanvas := nil;

  inherited Destroy;
end;
{=====}

procedure TO32dbFlexEdit.CreateWnd;
begin
  inherited CreateWnd;

  if Field <> nil then begin
    FieldType := Field.DataType;
    fedbSetFieldValue;
  end;
end;
{=====}

procedure TO32dbFlexEdit.CutToClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);
  inherited CutToClipboard;
  fedbGetFieldValue;
end;
{=====}

procedure TO32dbFlexEdit.PasteFromClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);
  inherited PasteFromClipboard;
  fedbGetFieldValue;
end;
{=====}

procedure TO32dbFlexEdit.DoOnChange;
begin
  FDataLink.Modified;
  Modified := true;
  inherited DoOnChange;
end;
{=====}

function TO32dbFlexEdit.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;
{=====}

function TO32dbFlexEdit.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;
{=====}

function TO32dbFlexEdit.GetField : TField;
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
{=====}

procedure TO32dbFlexEdit.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    fedbSetFieldProperties;
    Refresh;
  end;
end;
{=====}

procedure TO32dbFlexEdit.Restore;
  {-restore the field contents}
begin
  inherited Restore;

  Include(fedbState, esSelected);
  FDataLink.Reset;
end;
{=====}

procedure TO32dbFlexEdit.SetDataField(const Value : string);
begin
  try
    FDataLink.FieldName := Value;
  except
    FDataLink.FieldName := '';
    raise;
  end;
  fedbSetFieldProperties;
  Refresh;
  if csDesigning in ComponentState then
    RecreateWnd;
end;
{=====}

procedure TO32dbFlexEdit.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  fedbSetFieldProperties;
  Refresh;
end;
{=====}

procedure TO32dbFlexEdit.SetFieldType(Value : TFieldType);
begin
  if (Value <> FFieldType) and (Value in SupportedFieldTypes) then begin
    FFieldType := Value;
    fedbSetFieldProperties;
  end;

  if not (csLoading in ComponentState) then
    if (csDesigning in ComponentState) and not (Value in SupportedFieldTypes) then
      raise EOvcException.Create(GetOrphStr(SCInvalidFieldType));
end;
{=====}

procedure TO32dbFlexEdit.SetUseTFieldMask(Value : Boolean);
begin
  if (Value <> FUseTFieldMask) then begin
    FUseTFieldMask := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32dbFlexEdit.fedbDataChange(Sender : TObject);
begin
  if Field <> nil then begin
    {if field data type has changed, reset properties}
    if Field.DataType <> FFieldType then
      fedbSetFieldProperties;

    {force field to reset highlight and caret position}
    if not (DataSource.State in [dsEdit, dsInsert]) then begin
      Include(fedbState, esReset);
      Include(fedbState, esSelected);
    end;

    fedbSetFieldValue;
  end else
    Text := '';

  Invalidate;
end;
{=====}

procedure TO32dbFlexEdit.fedbEditingChange(Sender : TObject);
begin
  if (DataSource = nil) or (DataSource.State <> dsEdit) then
    Include(fedbState, esSelected);
end;
{=====}

procedure TO32dbFlexEdit.fedbGetFieldValue;
var
  S  : string;
  Str: string;
begin
  {if the field contents are invalid, exit}
  if not ValidateSelf then
    Exit;

  if Field <> nil then begin
    {get the entry field value}
    try
      S := Text;
    except
      {if error, don't update the field object}
      Exit;
    end;

    {if the field is empty, just clear the db field}
    if Text = '' then
      Field.Clear
    else
      case FFieldType of
        ftString, ftWideString: Field.AsString  := S;

        ftSmallInt, ftInteger, ftWord : Field.AsInteger := StrToIntDef(S, 0);

        ftBoolean: Field.AsBoolean := AnsiUppercase(S) = 'TRUE';

        ftFloat, ftBCD: Field.AsFloat   := StrToFloat(S);

        ftCurrency: begin
          Str := S;
          StripCharSeq(FormatSettings.ThousandSeparator, Str);
          StripCharSeq(FormatSettings.CurrencyString, Str);
          Field.AsCurrency := StrToCurr(Str);
        end;

        ftDate: Field.AsDateTime := StrToDate(S);
      end;
  end;
end;
{=====}

{DataType was never implemented}
procedure TO32dbFlexEdit.fedbSetFieldProperties;
begin
  case FFieldType of
    ftString, ftWideString
      : begin
//        DataType := feString;
        if Field <> nil then
          MaxLength := Field.DisplayWidth;
      end;

//  ftSmallInt : DataType := feInteger;
//  ftInteger  : DataType := feInteger;
//  ftWord     : DataType := feInteger;
//  ftBoolean  : DataType := feLogical;
//  ftFloat    : DataType := feFloat;
//  ftCurrency : DataType := feExtended;
//  ftBCD      : DataType := feExtended;
//else
    {default to string}
//  DataType := feString;
  end;

  {save current field type}
  if Field <> nil then
    FieldType := Field.DataType;

  {clear all states}
  fedbState := [];
end;
{=====}

procedure TO32dbFlexEdit.fedbSetFieldValue;
var
  SS : Integer;
  SL : Integer;
  F, S  : string; // string[MaxEditLen]; {used to compare old and new value}
begin
  if fedbBusy then
    Exit;

  {clear to insure match before transfer}
//  FillChar(S, SizeOf(S), 0);
//  FillChar(F, SizeOf(F), 0);
  S := '';
  F := '';

  if Field <> nil then begin
    case FFieldType of
      ftString, ftWideString: S := Field.AsString;

      ftSmallInt, ftInteger, ftWord :
        S := IntToStr(Field.AsInteger);

      ftBoolean    :
      if Field.AsBoolean then
        S := 'True'
      else
        S := 'False';

      ftFloat, ftBCD :
        S := FloatToStr(Field.AsFloat);

      ftCurrency:
        S := FormatCurr(FormatSettings.CurrencyString + '#' + FormatSettings.ThousandSeparator
          + '##0' + FormatSettings.DecimalSeparator + '00' , Field.AsCurrency);

      ftDate: S := FormatDateTime(FormatSettings.ShortDateFormat, Field.AsDateTime);
    else
      S := Field.AsString;
    end;

    fedbBusy := True;
    try
      {get copy of current field value}
      F := Text;
      SS := SelStart;
      SL := SelLength;

      {set field value}
      Text := S;

    finally
      fedbBusy := False;
    end;

    {if field value changed, call DoOnChange}
    if (S <> F) then
      inherited DoOnChange;

    if not (esSelected in fedbState) and not (csDesigning in ComponentState)
    then begin
      {return caret and highlight state}
      SelStart := SS;
      SelLength := SL;
    end else if (esSelected in fedbState) then
      SelectAll;

    {adjust highlight and caret position}
    if esReset in fedbState then begin
      SelStart := 0;
      SelLength := MaxEditLen;
      Exclude(fedbState, esReset);
    end;
  end;
end;
{=====}

procedure TO32dbFlexEdit.fedbUpdateData(Sender : TObject);
var
  Valid : Boolean;
begin
  if Field <> nil then begin
    if Modified then
      Valid := ValidateSelf
    else
      Valid := True;

    if Modified and Valid then
      fedbGetFieldValue;

    {raise an exception to halt any BDE scroll actions}
    if not Valid then
      SysUtils.Abort;
  end;
end;
{=====}

procedure TO32dbFlexEdit.WMKeyDown(var Msg : TWMKeyDown);
var
  Shift  : Boolean;
  Insert : Boolean;
begin
  if (DataSource <> nil) and DataSource.AutoEdit then begin
    if not ReadOnly then begin
      {special handling for <Ins> and <Shift><Ins> key sequences}
      Shift := (GetAsyncKeyState(VK_SHIFT) and $8000 <> 0);
      Insert := (Msg.CharCode = VK_INSERT);
      if not Insert or (Shift and Insert) then begin
        FDataLink.Edit;
        Exclude(fedbState, esSelected);
      end;
    end;
  end;
  inherited;
end;
{=====}

procedure TO32dbFlexEdit.WMChar(var Msg : TWMChar);
begin
  if (DataSource <> nil) then
    inherited
  else
    MessageBeep(0);
end;
{=====}

procedure TO32dbFlexEdit.WMKillFocus(var Msg : TWMKillFocus);
begin
  Exclude(fedbState, esFocused);

//inherited;

  if ValidateSelf and FDataLink.Editing then
    if Modified then fedbGetFieldValue;

  inherited;
end;
{=====}

procedure TO32dbFlexEdit.WMLButtonDblClk(var Msg : TWMLButtonDblClk);
begin
  inherited;

  Include(fedbState, esSelected);
end;
{=====}

procedure TO32dbFlexEdit.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  inherited;
  Exclude(fedbState, esSelected);
end;
{=====}

procedure TO32dbFlexEdit.WMLButtonUp(var Msg : TWMLButtonUp);
begin
  inherited;
  if SelLength > 0 then
    Include(fedbState, esSelected);
end;
{=====}

procedure TO32dbFlexEdit.WMPaint(var Msg : TWMPaint);
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
  {Fix for problem 668040
    ValidateSelf returns true if result is approved by the validator.
    In reality I think it is wrong to call the validate function for every
    paint of the control, but that is a different problem...
  }
  bError := not ValidateSelf;
  bActive := (FDataLink.DataSet <> nil) and FDataLink.Active;
  bFocused := (esFocused in fedbState) and not (csPaintCopy in ControlState);
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

    if not Enabled then begin
      FCanvas.Font.Color := EFColors.Disabled.TextColor;
      FCanvas.Brush.Color := EFColors.Disabled.BackColor
    end else
      FCanvas.Brush.Color := Color;

    with FCanvas do begin
      R := ClientRect;

      {get text to display}
      if Field <> nil then
        S := Field.DisplayText
      else begin
        S := '';
      end;

      if PasswordChar <> #0 then
        FillChar(S[1], Length(S), PasswordChar);

      {fix included but excluded again by Leif Holmgren:
        - Someone should take a look at this code, it was not included
          from turbopower, and does not work properly since the text
          gets hidden behind the flexedit-button when right-justified.
        - textmargin hardcoded 2
      }
      {
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
      }
        Indent := 2{TextMargin} - 1;

      FillRect(R);
      StrPLCopy(T, S, MaxEditLen);
      if (Enabled) then
        SetBkColor(FCanvas.Handle, Graphics.ColorToRGB(Color))
      else
        SetBkColor(FCanvas.Handle,
                   Graphics.ColorToRGB(EFColors.Disabled.BackColor));

      ExtTextOut(FCanvas.Handle, Indent, 1{TopMargin}, ETO_CLIPPED, @R, T, StrLen(T),
        nil);
    end;
  finally
    FCanvas.Handle := 0;
    if Msg.DC = 0 then
      EndPaint(Handle, PS);
  end;
end;
{=====}

procedure TO32dbFlexEdit.WMSetFocus(var Msg : TWMSetFocus);
begin
  Include(fedbState, esFocused);
  if ValidateSelf then fedbSetFieldValue;
  inherited;
end;
{=====}

function TO32dbFlexEdit.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;
{=====}

function TO32dbFlexEdit.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;
{=====}

end.
