unit ovctccustomedt;

interface

uses
  Messages, Types, Classes, Controls, StdCtrls, ExtCtrls, Graphics, ovctcmmn,
  ovcstr, ovctcstr, ovctCell;

type
  TOVCTCCustomEdt = class(TCustomEdit)
  private
    FCellOwner: TOvcBaseTableCell;
    FValidChars: TOvcCharSet;
  protected
    function IsValidText(const AText: string): Boolean; virtual;
    procedure KeyPress(var Key: Char); override;
    procedure WMGetDlgCode(var Msg: TMessage);
    message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg: TWMKey);
    message WM_KEYDOWN;
    procedure WMKillFocus(var Msg: TWMKillFocus);
    message WM_KILLFOCUS;
    procedure WMPaste(var Msg: TMessage);
    message WM_PASTE;
    procedure WMSetFocus(var Msg: TWMSetFocus);
    message WM_SETFOCUS;
  public
    property CellOwner: TOvcBaseTableCell read FCellOwner write FCellOwner;
    property ValidChars: TOvcCharSet read FValidChars write FValidChars;
  end;

  TOVCTCInt = class(TOVCTCCustomEdt)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TOvcTCCustomControl = class(TOvcTCBaseString)
  private
    FCellEditorBuffer: TObject;
    FCharCase: TEditCharCase;
    FMaxLength: Integer;
    FTimer: TTimer;
    procedure OnTimer(Sender: TObject);
  protected
    FEdit: TOVCTCCustomEdt;
    FString: string;
    function DoCreateControl: TWinControl; virtual; abstract;
    procedure DoDataToControl(const AControl: TWinControl; Data: Pointer); virtual;
    function GetCellEditor: TControl; override;
    property CharCase: TEditCharCase read FCharCase write FCharCase;
    property MaxLength: Integer read FMaxLength write FMaxLength;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function EditHandle: THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect: TRect); override;
    procedure SaveEditedData(Data: Pointer); override;
    procedure StartEditing(RowNum: TRowNum; ColNum: TColNum; CellRect: TRect; const CellAttr: TOvcCellAttributes; CellStyle: TOvcTblEditorStyle; Data: Pointer); override;
    procedure StopEditing(SaveValue: Boolean; Data: Pointer); override;
    property StringValue: string read FString;
  published
    property Adjust;
    property Color;
    property Font;
    property DataStringType;
    { 07/2011 AUCOS-HKK: Reimplemented 'ASCIIZStrings' for backward compatibility }
    property UseASCIIZStrings;
  end;

  TOvcTCCustomStr = class(TOvcTCCustomControl)
  private
    FPasswordChar: Char;
    FValidChars: TOvcCharSet;
  protected
    function DoCreateControl: TWinControl; override;
    function get_PasswordChar: Char;
    procedure set_PasswordChar(const Value: Char);
  public
    procedure StringToData(const AValue: string; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    property ValidChars: TOvcCharSet read FValidChars write FValidChars;
  published
    property CharCase;
    property PasswordChar: Char read get_PasswordChar write set_PasswordChar;
    property MaxLength;
  end;

  TOvcTCCustomInt = class(TOvcTCCustomControl)
  private
    FHideZero: Boolean;
    function get_IntegerValue: Integer;
  protected
    function DoCreateControl: TWinControl; override;
  public
    procedure IntToData(const AValue: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    property IntegerValue: Integer read get_IntegerValue;
  published
    property MaxLength;
    property HideZero: Boolean read FHideZero write FHideZero;
  end;

implementation

uses
  SysUtils, Windows, Forms, ClipBrd, ovctcedt;

type
  TProtectedWinControl = class(TWinControl)
  end;

  TPOvcTCCustomString = class(TOvcTCCustomString)
  end;

  { TOVCTCCustomEdt }

function TOVCTCCustomEdt.IsValidText(const AText: string): Boolean;
var
  iCount: Integer;
begin
  Result := True;
  if FValidChars <> [] then
  begin
    for iCount := 1 to Length(AText) do
    begin
      Result := CharInSet(AText[iCount], FValidChars);
      if not Result then
        Break;
    end;
  end;
end;

procedure TOVCTCCustomEdt.KeyPress(var Key: Char);
begin
  if (Key > #32) and (FValidChars <> []) and (not CharInSet(Key, FValidChars)) then
    Key := #0;
  inherited KeyPress(Key);
end;

procedure TOVCTCCustomEdt.WMGetDlgCode(var Msg: TMessage);
begin
  if CellOwner = nil then
    inherited
  else
  begin
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
    inherited;
  end;
end;

procedure TOVCTCCustomEdt.WMKeyDown(var Msg: TWMKey);
  procedure GetSelection(var S, E: word);

  type
    LH = packed record
      L, H: word;
    end;

  var
    GetSel: Integer;
  begin
    GetSel := SendMessage(Handle, EM_GETSEL, 0, 0);
    S := LH(GetSel).L;
    E := LH(GetSel).H;
  end;

var
  GridReply: TOvcTblKeyNeeds;
  GridUsedIt: Boolean;
  SStart, SEnd: word;
begin
  if CellOwner = nil then
    inherited
  else
  begin
    GridUsedIt := false;
    GridReply := CellOwner.FilterTableKey(Msg);
    case GridReply of
      otkMustHave:
        begin
          CellOwner.SendKeyToTable(Msg);
          GridUsedIt := True;
        end;
      otkWouldLike:
        case Msg.CharCode of
          VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN:
            begin
              CellOwner.SendKeyToTable(Msg);
              GridUsedIt := True;
            end;
          VK_LEFT:
            if TPOvcTCCustomString(CellOwner).AutoAdvanceLeftRight then
            begin
              GetSelection(SStart, SEnd);
              if (SStart = SEnd) and (SStart = 0) then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := True;
              end;
            end;
          VK_RIGHT:
            if TPOvcTCCustomString(CellOwner).AutoAdvanceLeftRight then
            begin
              GetSelection(SStart, SEnd);
              if ((SStart = SEnd) or (SStart = 0)) and (SEnd = GetTextLen) then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := True;
              end;
            end;
        end;
    end; { case }

    if not GridUsedIt then
      inherited;
  end;
end;

procedure TOVCTCCustomEdt.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if CellOwner <> nil then
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
end;

procedure TOVCTCCustomEdt.WMPaste(var Msg: TMessage);
var
  sNewText: string;
begin
  sNewText := Copy(Text, 1, SelStart) + Clipboard.AsText + Copy(Text, SelStart + SelLength + 1, Length(Text) - SelLength - SelStart);
  if not IsValidText(sNewText) then
    Msg.Result := 0
  else
    inherited;
end;

procedure TOVCTCCustomEdt.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  if CellOwner <> nil then
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
end;

{ TOVCTCInt }

constructor TOVCTCInt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ValidChars := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
end;

{ TOvcTCCustomControl }

constructor TOvcTCCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := false;
  FTimer.Interval := 100;
  FTimer.OnTimer := OnTimer;
  FCharCase := ecNormal;
end;

destructor TOvcTCCustomControl.Destroy;
begin
  FreeAndNil(FTimer);
  inherited Destroy;
end;

procedure TOvcTCCustomControl.DoDataToControl(const AControl: TWinControl; Data: Pointer);
begin
  if Data <> nil then
    FEdit.Text := PChar(Data)
  else
    FEdit.Text := '';
end;

function TOvcTCCustomControl.EditHandle: THandle;
begin
  if FEdit <> nil then
    Result := FEdit.Handle
  else
    Result := 0;
end;

procedure TOvcTCCustomControl.EditHide;
begin
  if Assigned(CellEditor) then
    with CellEditor as TWinControl do
      SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
end;

procedure TOvcTCCustomControl.EditMove(CellRect: TRect);

var
  iHandle: HWND;
  NewTop: Integer;
begin
  if Assigned(CellEditor) then
  begin
    iHandle := EditHandle;
    with CellRect do
    begin
      NewTop := Top;
      if TProtectedWinControl(CellEditor).Ctl3D then
        InflateRect(CellRect, -1, -1);
      SetWindowPos(iHandle, HWND_TOP, Left, NewTop, Right - Left, Bottom - Top, SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
    end;
    InvalidateRect(iHandle, nil, false);
    UpdateWindow(iHandle);
  end;
end;

function TOvcTCCustomControl.GetCellEditor: TControl;
begin
  Result := FEdit;
end;

procedure TOvcTCCustomControl.OnTimer(Sender: TObject);
begin
  FTimer.Enabled := false;
  FreeAndNil(FCellEditorBuffer);
end;

procedure TOvcTCCustomControl.SaveEditedData(Data: Pointer);
begin
  { 04/2011 AB: Why is FEdit.Text not being saved in Data? }
  if FEdit <> nil then
    FString := FEdit.Text
  else
    FString := '';
end;

procedure TOvcTCCustomControl.StartEditing(RowNum: TRowNum; ColNum: TColNum; CellRect: TRect; const CellAttr: TOvcCellAttributes; CellStyle: TOvcTblEditorStyle; Data: Pointer);

var
  pControl: TProtectedWinControl;
begin
  pControl := TProtectedWinControl(DoCreateControl);
  if pControl <> nil then
  begin
    pControl.Parent := FTable;
    pControl.Color := CellAttr.caColor;
    case CellStyle of
      tes3D:
        pControl.Ctl3D := True;
    else
      pControl.Ctl3D := false;
    end;
    pControl.AutoSize := false;
    pControl.Left := CellRect.Left;
    pControl.Top := CellRect.Top;
    pControl.Width := CellRect.Right - CellRect.Left;
    pControl.Font := CellAttr.caFont;
    pControl.Font.Color := CellAttr.caFontColor;
    pControl.Hint := Self.Hint;
    pControl.ShowHint := Self.ShowHint;
    pControl.Visible := True;
    pControl.TabStop := false;
    DoDataToControl(pControl, Data);
  end;
end;

procedure TOvcTCCustomControl.StopEditing(SaveValue: Boolean; Data: Pointer);

var
  pControl: TWinControl;
  pForm: TCustomForm;
begin
  if SaveValue and Assigned(Data) then
  begin
    TProtectedWinControl(CellEditor).DoExit;
    SaveEditedData(Data);
  end;

  pControl := Table;
  pForm := GetParentForm(Table);
  if pForm <> nil then
    pControl := pForm.ActiveControl;
  if pControl = CellEditor then
    pControl := Table;

  FCellEditorBuffer := CellEditor;
  FTimer.Enabled := True;
  FEdit := nil;
  pControl.SetFocus;
end;

{ TOvcTCCustomStr }

function TOvcTCCustomStr.DoCreateControl: TWinControl;
begin
  FEdit := TOVCTCCustomEdt.Create(Table);
  FEdit.CellOwner := Self;
  FEdit.MaxLength := MaxLength;
  FEdit.CharCase := CharCase;
  FEdit.PasswordChar := FPasswordChar;
  FEdit.ValidChars := FValidChars;
  Result := FEdit;
end;

function TOvcTCCustomStr.get_PasswordChar: Char;
begin
  Result := FPasswordChar;
end;

procedure TOvcTCCustomStr.set_PasswordChar(const Value: Char);
begin
  FPasswordChar := Value;
end;

procedure TOvcTCCustomStr.StringToData(const AValue: string; var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
  FString := AValue;
  Data := PChar(FString);
end;

{ TOvcTCCustomInt }

function TOvcTCCustomInt.DoCreateControl: TWinControl;
begin
  FEdit := TOVCTCInt.Create(Table);
  FEdit.CellOwner := Self;
  FEdit.MaxLength := MaxLength;
  FEdit.CharCase := CharCase;
  Result := FEdit;
end;

function TOvcTCCustomInt.get_IntegerValue: Integer;
begin
  Result := StrToIntDef(FString, 0);
end;

procedure TOvcTCCustomInt.IntToData(const AValue: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
  if FHideZero and (Purpose = cdpForPaint) and (AValue = 0) then
  begin
    FString := '';
    Data := nil;
  end
  else
  begin
    FString := IntToStr(AValue);
    Data := PChar(FString);
  end;
end;

end.
