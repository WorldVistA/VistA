unit uFormUtils;

interface

uses
  Controls, Forms, WinApi.Windows;

type
  TViewMode = (vmParentedForm, vmDialog, vmConfirmationDlg);

procedure setFormParented(aForm: TForm; aParent: TWinControl;
  anAlign: TAlign = alClient;aVisible: Boolean = True);
procedure ListViewClearSortIndicator(aHandle: HWND; aColumn: Integer);
procedure AlignForm(aForm: TForm; AlignStyle: TAlign);
procedure MenuItemMoveRight(aMenu: hMenu; aCommand: Cardinal);

function CombineHeights(ctrl: array of TControl): integer;


implementation

uses
  WinApi.CommCtrl, UResponsiveGUI;

procedure setFormParented(aForm: TForm; aParent: TWinControl;
  anAlign: TAlign = alClient;aVisible: Boolean = True);
begin
  if aForm.Parent <> aParent then
  begin
    aForm.BorderStyle := bsNone;
    aForm.Parent := aParent;
    aForm.Align := anAlign;
    aForm.Menu := nil;
    aForm.Visible := aVisible;
//    if not aForm.Visible then
    if aVisible then
      aForm.Show;
  end;
end;

procedure ListViewClearSortIndicator(aHandle: HWND; aColumn: Integer);
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(aHandle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;

  // Clear the previous arrow
  Header_GetItem(Header, aColumn, Item);
  Item.fmt := Item.fmt and not(HDF_SORTUP or HDF_SORTDOWN); // remove both flags
  Header_SetItem(Header, aColumn, Item);
end;

procedure AlignForm(aForm: TForm; AlignStyle: TAlign);
var
  frm: TForm;
  iLog: Integer;
  R: TRect;

const
  RpcLogPart = 3;

  function WorkArea: TRect;
  var
    R: TRect;
  begin
    SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
    Result := R;
  end;

begin
  if AlignStyle = alNone then
    exit;

  frm := Application.MainForm;
  R := WorkArea;
  iLog := R.Width div RpcLogPart;
  frm.Top := R.Top;
  frm.Height := R.Bottom - R.Top;
  aForm.Top := R.Top;
  aForm.Height := R.Bottom - R.Top;
  aForm.Width := iLog;

  case AlignStyle of
    alNone:
      begin
        frm.Left := R.Left;
        frm.Width := R.Width;
        aForm.Left := R.Left + R.Width - iLog;
      end;
    alTop:
      ;
    alBottom:
      ;
    alLeft:
      begin
        frm.Left := iLog;
        frm.Width := R.Width - iLog;
        aForm.Left := R.Left;
      end;
    alRight:
      begin
        frm.Left := R.Left;
        frm.Width := R.Width - iLog;
        aForm.Left := R.Width - iLog;
      end;
    alClient:
      ;
    alCustom:
      ;
  end;
end;

procedure MenuItemMoveRight(aMenu: hMenu; aCommand: Cardinal);
var
  mii: TMenuItemInfo;
  Buffer: array [0 .. 79] of Char;

begin
  // GET Help Menu Item Info
  mii.cbSize := SizeOf(mii);
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf(Buffer);
  GetMenuItemInfo(aMenu, aCommand, false, mii);
  // SET Help Menu Item Info
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  if SetMenuItemInfo(aMenu, aCommand, false, mii) then
    if Assigned(Application.MainForm) then
    begin
      Application.MainForm.Width := Application.MainForm.Width + 1;
      TResponsiveGUI.ProcessMessages;
      Application.MainForm.Width := Application.MainForm.Width - 1;
      TResponsiveGUI.ProcessMessages;
    end;
end;

function CombineHeights(ctrl: array of TControl): integer;
var
  i: integer;

begin
  Result := 0;
  for i := Low(ctrl) to High(ctrl) do
  begin
    if ctrl[i].Visible then
    begin
      if ctrl[i].Align = alClient then
        inc(Result, ctrl[i].Constraints.MinHeight)
      else
        inc(Result, ctrl[i].Height);
      if ctrl[i].AlignWithMargins then
        inc(Result, ctrl[i].Margins.Top + ctrl[i].Margins.Bottom);
    end;
  end;
end;
end.
