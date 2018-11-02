{*********************************************************}
{*                    OVCTCFLX.PAS 4.08                  *}
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

unit o32tcflx;
  {Orpheus Table Cell version of the FlexEdit}

interface

uses
  Windows, SysUtils, Messages, Graphics, Classes, Controls, Forms, StdCtrls,
  Menus, OvcTCmmn, OvcTCell,
  OvcTCStr, O32FlxEd, O32bordr, OvcEf, OvcCmd, O32VlOp1, O32Vldtr;

type

  { Event for the TCFlexEdit User Validation }
  TTCFEUserValidationEvent =
    procedure(Sender : TObject; Value: string;
              var ValidEntry : Boolean) of object;


  {Class for storing the validation properties.  These properties will be
   loaded dynamically when the editor is created.}
  TO32TCValidatorOptions = class(TPersistent)
  protected {private}
    FValidationType : TValidationType;
    FValidatorType  : String;
    FValidatorClass : TValidatorClass;
    FMask           : String;
    FLastValid      : Boolean;
    FLastErrorCode  : Word;
    FBeepOnError    : Boolean;
    FInputRequired  : Boolean;

    procedure SetValidatorType(const VType: String);
    procedure AssignValidator;
  public
    constructor Create; dynamic;
    property LastValid: Boolean
      read FLastValid write FLastValid;
    property LastErrorCode: Word
      read FLastErrorCode write FLastErrorCode;

    { - Moved from published}
    property ValidatorClass: TValidatorClass
      read FValidatorClass write FValidatorClass stored true;
  published
    property BeepOnError: Boolean
      read FBeepOnError write FBeepOnError stored true;
    property InputRequired: Boolean
      read FInputRequired write FInputRequired stored true;
    property ValidatorType : string
      read FValidatorType write SetValidatorType stored true;
    property ValidationType: TValidationType
      read FValidationType write FValidationType stored true;
    property Mask: String
      read FMask write FMask stored true;
  end;


  TO32TCFlexEditEditor = class(TO32CustomFlexEdit)
  protected {private}
    FCell : TOvcBaseTableCell;
    procedure WMChar(var Msg : TWMKey); message WM_CHAR;
    procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
    property CellOwner : TOvcBaseTableCell read FCell write FCell;

    function ValidateSelf: Boolean; override;
  end;

  TO32TCBorderProperties = class(TPersistent)
  protected {private}
    FActive       : Boolean;
    FFlatColor    : TColor;
    FBorderStyle  : TO32BorderStyle;
  public
    constructor Create; virtual;
  published
    property Active: Boolean read FActive write FActive;
    property FlatColor: TColor read FFlatColor write FFlatColor;
    property BorderStyle: TO32BorderStyle read FBorderStyle write FBorderStyle;
  end;

  TO32TCEditorProperties = class(TPersistent)
  protected
    FAlignment       : TAlignment;
    FBorders         : TO32Borders;
    FButtonGlyph     : TBitmap;
    FColor           : TColor;
    FCursor          : TCursor;
    FMaxLines        : Integer;
    FShowButton      : Boolean;
    FPasswordChar    : Char;
    FReadOnly        : Boolean;
    procedure SetButtonGlyph(Value :TBitmap);
    function GetButtonGlyph :TBitmap;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Borders: TO32Borders read FBorders write FBorders;

  published
    property Alignment: TAlignment read FAlignment write FAlignment;
    property ButtonGlyph: TBitmap
      read GetButtonGlyph write SetButtonGlyph;

    property Color: TColor Read FColor write FColor;
    property Cursor: TCursor read FCursor write FCursor;
    property MaxLines: Integer read FMaxLines write FMaxLines;
    property PasswordChar: Char read FPasswordChar write FPasswordChar default #0;
    property ReadOnly: Boolean Read FReadOnly write FReadOnly;
    property ShowButton: Boolean read FShowButton write FShowButton;
  end;

  TO32TCCustomFlexEdit = class(TOvcTCBaseString)
  protected {private}
    FBorderProps      : TO32TCBorderProperties;
    FEdit             : TO32TCFlexEditEditor;
    FEditorOptions    : TO32TCEditorProperties;
    FMaxLength        : word;
    FValidation       : TO32TCValidatorOptions;
    FWantReturns      : Boolean;
    FWantTabs         : Boolean;
    FWordWrap         : Boolean;

    FOnError          : TValidationErrorEvent;
    FOnUserCommand    : TUserCommandEvent;
    FOnUserValidation : TTCFEUserValidationEvent;

    FOnButtonClick   : TO32feButtonClickEvent;

  protected
    function GetCellEditor : TControl; override;
    function GetModified : boolean;

    property MaxLength : word
      read FMaxLength write FMaxLength stored true;
    property WantReturns : boolean
      read FWantReturns write FWantReturns stored true;
    property WantTabs : boolean
      read FWantTabs write FWantTabs stored true;
    property WordWrap: Boolean
      read FWordWrap write FWordWrap stored true;
    property EditorBorders: TO32TCBorderProperties
      read FBorderProps write FBorderProps;
    property OnButtonClick: TO32feButtonClickEvent
      read FOnButtonClick write FOnButtonClick;
    property Validation: TO32TCValidatorOptions
      read FValidation write FValidation;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function  CreateEditControl(AOwner : TComponent) : TO32TCFlexEditEditor; virtual;
    function  EditHandle : THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect : TRect); override;

    function  CanSaveEditedData(SaveValue : boolean) : boolean; override;
    procedure SaveEditedData(Data : pointer); override;
    function  ValidateEntry: Boolean;
    procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                           CellRect : TRect;
                     const CellAttr : TOvcCellAttributes;
                           CellStyle: TOvcTblEditorStyle;
                           Data : pointer); override;
    procedure StopEditing(SaveValue : boolean;
                          Data : pointer); override;
    property Modified : boolean
      read GetModified;
    property EditorOptions: TO32TCEditorProperties
      read FEditorOptions write FEditorOptions;
    property OnUserValidation: TTCFEUserValidationEvent
      read FOnUserValidation write FOnUserValidation;
  end;

  TO32TCFlexEdit = class(TO32TCCustomFlexEdit)
  published
    {properties inherited from custom ancestor}
    property Access default otxDefault;
    property Adjust default otaDefault;
    property DataStringType;
    property EditorBorders;
    property Color;
    property EditorOptions;
    property EllipsisMode;
    property Font;
    property Hint;
    property IgnoreCR;
    property Margin default 4;
    property MaxLength default 255;
    property ShowHint default False;
    property Table;
    property TableColor default True;
    property TableFont default True;
    property TextHiColor default clBtnHighlight;
    property TextStyle default tsFlat;
    property Validation;
    property WantReturns default False;
    property WantTabs default False;
    property WordWrap default False;

    {Fix for problem 668023 - Publish the property UseWordWrap}
    property UseWordWrap default True;

    {events inherited from custom ancestor}
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
    property OnOwnerDraw;
    property OnUserValidation;
  end;

implementation

{===== TO32TCValidatorOptions ========================================}

constructor TO32TCValidatorOptions.Create;
begin
  inherited Create;
  FValidationType := vtNone;
  FValidatorType := 'None';
  FValidatorClass := nil;
  FMask := '';
  FLastValid := false;
  FLastErrorCode := 0;
  FBeepOnError := true;
  FInputRequired := false;
end;

procedure TO32TCValidatorOptions.AssignValidator;
begin
  if (FValidatorType = 'None') or (FValidatorType = '')then
    FValidatorClass := nil
  else try
    FValidatorClass := TValidatorClass(FindClass(FValidatorType));
  except
    FValidatorClass := nil;
  end;
end;
{=====}

procedure TO32TCValidatorOptions.SetValidatorType(const VType: String);
begin
  if FValidatorType <> VType then begin
    FValidatorType := VType;
    AssignValidator;
  end;
end;


{===== TO32TCFlexEditEditor ==========================================}

procedure TO32TCFlexEditEditor.WMChar(var Msg : TWMKey);
begin
  if (not CellOwner.TableWantsTab) or (Msg.CharCode <> 9) then
    inherited;
end;
{=====}

procedure TO32TCFlexEditEditor.WMGetDlgCode(var Msg : TMessage);
begin
  inherited;
  if CellOwner.TableWantsTab then
    Msg.Result := Msg.Result or DLGC_WANTTAB;
end;
{=====}

procedure TO32TCFlexEditEditor.WMKeyDown(var Msg : TWMKey);
  {Local Method}
  procedure GetSelection(var S, E : word);
  type
    LH = packed record L, H : word; end;
  var
    GetSel : Integer;
  begin
    GetSel := SendMessage(Handle, EM_GETSEL, 0, 0);
    S := LH(GetSel).L;
    E := LH(GetSel).H;
  end;
var
  GridReply : TOvcTblKeyNeeds;
  GridUsedIt : boolean;
  SStart, SEnd : word;
begin
  GridUsedIt := false;
  GridReply := otkDontCare;
  if (CellOwner <> nil) then
    GridReply := CellOwner.FilterTableKey(Msg);
  case GridReply of
    otkMustHave :
      begin
        CellOwner.SendKeyToTable(Msg);
        GridUsedIt := true;
      end;
    otkWouldLike :
      case Msg.CharCode of
        VK_RETURN :
          if not WantReturns then
            begin
              CellOwner.SendKeyToTable(Msg);
              GridUsedIt := true;
            end;
        VK_LEFT :
          begin
            GetSelection(SStart, SEnd);
            if (SStart = SEnd) and (SStart = 0) then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := true;
              end;
          end;
        VK_RIGHT :
          begin
            GetSelection(SStart, SEnd);
            if ((SStart = SEnd) or (SStart = 0)) and (SEnd = GetTextLen) then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := true;
              end;
          end;
      end;
  end;{case}

  if not GridUsedIt then
    inherited;
end;
{=====}

procedure TO32TCFlexEditEditor.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;
  CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
end;
{=====}

procedure TO32TCFlexEditEditor.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
end;
{=====}

function TO32TCFlexEditEditor.ValidateSelf;
begin
  result := inherited ValidateSelf;
end;

{===== TO32TCBorderProperties ========================================}
constructor TO32TCBorderProperties.Create;
begin
  inherited;
  FActive := False;
  FFlatColor := clBlack;
  FBorderStyle := bstyRaised;
end;

{===== TO32TCEditorProperties ========================================}
constructor TO32TCEditorProperties.Create;
begin
  inherited Create;
  FAlignment := taLeftJustify;
  FButtonGlyph := TBitmap.Create;
  FColor := clWindow;
  FCursor := crDefault;
  FMaxLines := 3;
  FShowButton := false;
  { 06/2011; AB: Changed default-value for 'PasswordChar' to #0, so that
                 TO32TCFlexEdit does not work in password-mode by default }
  FPasswordChar := #0; //'*';
  FReadOnly := false;
end;
{=====}

destructor TO32TCEditorProperties.Destroy;
begin
  FButtonGlyph.Free;
  inherited Destroy;
end;
{=====}

{ - begin}
procedure TO32TCEditorProperties.SetButtonGlyph(Value :TBitmap);
begin
  FButtonGlyph.Assign(Value);
end;
{=====}

function TO32TCEditorProperties.GetButtonGlyph :TBitmap;
begin
  Result := FButtonGlyph;
end;
{=====}
{ - end}

{===== TO32TCCustomFlexEdit ==========================================}
constructor TO32TCCustomFlexEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  UseWordWrap := true;
  FEditorOptions := TO32TCEditorProperties.Create;
  FBorderProps := TO32TCBorderProperties.Create;
  FValidation := TO32TCValidatorOptions.Create;
  MaxLength := 255;
end;
{=====}

destructor TO32TCCustomFlexEdit.Destroy;
begin
  FEditorOptions.Free;
  FBorderProps.Free;
  FValidation.Free;
  inherited;
end;
{=====}

function TO32TCCustomFlexEdit.GetCellEditor : TControl;
  {-Changes
    06/2011 AB: Bugfix: FEditorOptions must not be freed here }
begin
  Result := FEdit;
//  FEditorOptions.Free;
end;
{=====}

function TO32TCCustomFlexEdit.GetModified : boolean;
begin
  if Assigned(FEdit) then
    Result := FEdit.Modified
  else
    Result := false;
end ;
{=====}

function TO32TCCustomFlexEdit.CreateEditControl(AOwner : TComponent):
  TO32TCFlexEditEditor;
begin
  Result := TO32TCFlexEditEditor.Create(AOwner);
end;
{=====}

function  TO32TCCustomFlexEdit.EditHandle : THandle;
begin
  if Assigned(FEdit) then
    Result := FEdit.Handle
  else
    Result := 0;
end;
{=====}

procedure TO32TCCustomFlexEdit.EditHide;
begin
  if Assigned(FEdit) then
//    with FEdit do
      SetWindowPos(FEdit.Handle, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW
        or SWP_NOREDRAW or SWP_NOZORDER);
end;
{=====}

procedure TO32TCCustomFlexEdit.EditMove(CellRect : TRect);
begin
  if Assigned(FEdit) then
    begin
      with CellRect do
        SetWindowPos(FEdit.Handle, HWND_TOP,
                     Left, Top, Right-Left, Bottom-Top,
                     SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
      InvalidateRect(FEdit.Handle, nil, false);
      UpdateWindow(FEdit.Handle);
    end;
end;
{=====}

function TO32TCCustomFlexEdit.CanSaveEditedData(SaveValue : boolean) : boolean;
begin
  Result := true;
  if Validation.InputRequired and (FEdit.Text = '') then begin
    result := false;
    FEdit.Restore;
  end

  else if (Validation.FValidationType <> vtNone) then
    if Assigned(FEdit) then
      if SaveValue then
        Result := ValidateEntry
      else begin
        FEdit.Restore;
        result := false;
      end;
end;
{=====}

function TO32TCCustomFlexEdit.ValidateEntry: Boolean;
begin
  if Assigned(FOnUserValidation) then begin
    FOnUserValidation(FEdit, FEdit.Text, result);
    if Validation.BeepOnError then MessageBeep(0);
    exit;
  end;

  result := FEdit.ValidateSelf;
  Validation.LastValid     := FEdit.Validation.LastValid;
  Validation.LastErrorCode := FEdit.Validation.LastErrorCode;
end;

procedure TO32TCCustomFlexEdit.SaveEditedData(Data : pointer);
begin
  {Abstract method does nothing.
   It is stubbed out so that BCB doesn't think this as an abstract class}
end;
{=====}

procedure TO32TCCustomFlexEdit.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                            CellRect : TRect;
                                      const CellAttr : TOvcCellAttributes;
                                            CellStyle: TOvcTblEditorStyle;
                                            Data : pointer);
  {-Changes:
    04/2011, AB: Use DataStringType to determine what kind of pointer is provided }
begin
  FEdit := TO32TCFlexEditEditor.Create(FTable);

  FEdit.Validation.EnableHooking   := false;
  FEdit.Validation.InputRequired   := Validation.InputRequired;
  FEdit.Validation.ValidationType  := Validation.ValidationType;
  FEdit.Validation.ValidatorType   := Validation.ValidatorType;
  FEdit.Validation.ValidatorClass  := Validation.ValidatorClass;
  FEdit.Validation.Mask            := Validation.Mask;
  FEdit.Validation.BeepOnError     := Validation.BeepOnError;
  FEdit.Validation.InputRequired   := Validation.InputRequired;
  FEdit.Validation.ValidationEvent := veOnExit;


  FEdit.ShowButton := FEditorOptions.ShowButton;
  if FEdit.ShowButton then begin
    FEdit.ButtonGlyph := FEditorOptions.ButtonGlyph;
    if Assigned(OnButtonClick) then
      FEdit.OnButtonClick := OnButtonClick;
  end;

  with FEdit do begin
    Parent := FTable;

    Borders.Active := FBorderProps.FActive;

    if Borders.Active then begin
      Borders.BorderStyle := FBorderProps.FBorderStyle;
      Borders.FlatColor := FBorderProps.FFlatColor;
      BorderStyle := bsSingle;
      Ctl3D := true;
    end else begin
      BorderStyle := bsNone;
      Ctl3D := false;
      case CellStyle of
        tesBorder : BorderStyle := bsSingle;
        tes3D     : Ctl3D := true;
      end;{case}
    end;

    Color := FEditorOptions.Color;
    Font := CellAttr.caFont;
    Font.Color := CellAttr.caFontColor;
    MaxLength := Self.MaxLength;
    WantReturns := Self.WantReturns;
    WantTabs := Self.WantTabs;
    WordWrap := Self.WordWrap;
    EditLines.MaxLines := FEditorOptions.MaxLines;
    EditLines.DefaultLines := 1;
    EditLines.FocusedLines := 3;
    EditLines.MouseOverLines := 3;
    Cursor := FEditorOptions.Cursor;
    PasswordChar := FEditorOptions.PasswordChar;
    ReadOnly := FEditorOptions.ReadOnly;
    Left := CellRect.Left;
    Top := CellRect.Top;
    Width := CellRect.Right - CellRect.Left;
    Height := CellRect.Bottom - CellRect.Top;
    Visible := true;
    TabStop := false;
    CellOwner := Self;
    Hint := Self.Hint;
    ShowHint := Self.ShowHint;

    if Data=nil then
      Text := ''
    else case FDataStringType of
      tstShortString: Text := string(POvcShortString(Data)^);
      tstPChar:       SetTextBuf(PChar(Data));
      tstString:      SetTextBuf(PChar(PString(Data)^))
    end;
    OnChange := Self.OnChange;
    OnClick := Self.OnClick;
    OnDblClick := Self.OnDblClick;
    OnDragDrop := Self.OnDragDrop;
    OnDragOver := Self.OnDragOver;
    OnEndDrag := Self.OnEndDrag;
    OnEnter := Self.OnEnter;
    OnExit := Self.OnExit;
    OnKeyDown := Self.OnKeyDown;
    OnKeyPress := Self.OnKeyPress;
    OnKeyUp := Self.OnKeyUp;
    OnMouseDown := Self.OnMouseDown;
    OnMouseMove := Self.OnMouseMove;
    OnMouseUp := Self.OnMouseUp;
  end;
end;
{=====}

procedure TO32TCCustomFlexEdit.StopEditing(SaveValue : boolean; Data : pointer);
  {-Changes:
    04/2011, AB: Use DataStringType to determine what kind of pointer is provided }
begin
  try
    if SaveValue and Assigned(Data) then
      case FDataStringType of
        tstShortString: POvcShortString(Data)^ := ShortString(Copy(FEdit.Text, 1, MaxLength));
        tstPChar:       FEdit.GetTextBuf(PChar(Data), MaxLength);
        tstString:      PString(Data)^ := FEdit.Text;
      end;
  finally
    FEdit.Free;
    FEdit := nil;
  end;
end;

{=====}


end.
