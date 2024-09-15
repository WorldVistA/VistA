unit fOrderSaveQuick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, Buttons, ExtCtrls, StdCtrls, ORCtrls, ORFn, fODBase, uOrders,
  VA508AccessibilityManager;

type
  TfrmSaveQuickOrder = class(TfrmAutoSz)
    Panel1: TPanel;
    memOrder: TMemo;
    lblDisplayName: TLabel;
    txtDisplayName: TCaptionEdit;
    Panel2: TPanel;
    lblQuickList: TLabel;
    lstQuickList: TORListBox;
    pnlUpButton: TKeyClickPanel;
    cmdUp: TSpeedButton;
    pnlDownButton: TKeyClickPanel;
    cmdRename: TButton;
    cmdDelete: TButton;
    cmdDown: TSpeedButton;
    Panel3: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure txtDisplayNameChange(Sender: TObject);
  //  procedure cmdUpClick(Sender: TObject);
 //   procedure cmdDownClick(Sender: TObject);
    procedure cmdRenameClick(Sender: TObject);
    procedure cmdDeleteClick(Sender: TObject);
    procedure pnlUpButtonEnter(Sender: TObject);
    procedure pnlUpButtonExit(Sender: TObject);
    procedure cmdUpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdUpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdDownMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdDownMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlDownButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlDownButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlUpButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlUpButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    OKPressed: Boolean;
  end;

function EditCommonList(ADisplayGroup: Integer): Boolean;
function SaveAsQuickOrder(ResponseSet: TResponses): Boolean;

implementation

{$R *.DFM}

uses rODBase, rOrders, fRename;

const
  TX_DNAME_REQ = 'A name for the quick order must be entered in order to save it.';
  TC_DNAME_REQ = 'Display Name Missing';
  TX_DEL_CONFIRM = 'Remove the following quick order from your list?' + CRLF + CRLF;
  TC_DEL_CONFIRM = 'Remove Quick Order';
  TX_QO_RENAME   = 'Rename Quick Order';
  TX_NO_DEL_NEW  = 'A new quick order cannot be deleted.  Press <Cancel> instead.';
  TC_NO_DEL_NEW  = 'Remove Quick Order';
  TX_NO_TEXT     = 'No fields have been entered - cannot save as quick order.';
  TC_NO_TEXT     = 'Save as Quick Order';
  TX_DUP_NAME = 'There is already a quick order with that name.' + CRLF +
                'Please either delete the original or enter a different name.';
  TC_DUP_NAME = 'Unable to save quick order';
  TC_DUP_RENAME = 'Unable to rename quick order';

function EditCommonList(ADisplayGroup: Integer): Boolean;
var
  frmSaveQuickOrder: TfrmSaveQuickOrder;
  DGroupName: string;
begin
  Result := False;
  frmSaveQuickOrder := TfrmSaveQuickOrder.Create(Application);
  try
    ResizeFormToFont(TForm(frmSaveQuickOrder));
    with frmSaveQuickOrder do
    begin
      if ADisplayGroup = ClinDisp then
        ADisplayGroup := InptDisp;
      DGroupName := NameOfDGroup(ADisplayGroup);
      Caption := 'Edit Common Order List (' + DGroupName + ')';
      lblQuickList.Caption := 'Common List for ' + DGroupName;
      lstQuickList.Caption := lblQuickList.Caption;
      lblDisplayName.Font.Color := clGrayText;
      txtDisplayName.Enabled := False;
      txtDisplayName.Color := clBtnFace;
      with lstQuickList do
      begin
        LoadQuickListForOD(Items, ADisplayGroup);
        ItemIndex := 0;
      end;
      ActiveControl := lstQuickList;
      ShowModal;
      if OKPressed then
      begin
        Result := True;
        // replace the user's quick list with this new quick list
        SaveQuickListForOD(lstQuickList.Items, ADisplayGroup);
      end; {if OKPressed}
    end; {with frmSaveQuickOrder}
  finally
    frmSaveQuickOrder.Release;
  end;
end;

function SaveAsQuickOrder(ResponseSet: TResponses): Boolean;
const
  EMPTY_CRC = 'FFFFFFFF';
var
  frmSaveQuickOrder: TfrmSaveQuickOrder;
  DGroupName, QuickName, CRC: string;
  NewIEN, AnIndex, i: Integer;
  IsClinicOrder: boolean;
begin
  Result := False;
  CRC := ResponseSet.OrderCRC;
  IsClinicOrder := False;
  if CRC = EMPTY_CRC then
  begin
    InfoBox(TX_NO_TEXT, TC_NO_TEXT, MB_OK);
    Exit;
  end;
  frmSaveQuickOrder := TfrmSaveQuickOrder.Create(Application);
  try
    ResizeFormToFont(TForm(frmSaveQuickOrder));
    with frmSaveQuickOrder do
    begin
      if (ResponseSet.DisplayGroup = ClinIVDisp) then
        begin
          ResponseSet.DisplayGroup := IVDisp;
          IsClinicOrder := True;
        end;
      if ResponseSet.DisplayGroup = ClinDisp then
        DGroupName := NameOfDGroup(InptDisp)
      else
        DGroupName := NameOfDGroup(ResponseSet.DisplayGroup);
      if DGroupName = 'Inpt. Meds' then
        begin
          ResponseSet.DisplayGroup := InptDisp;
          DGroupName := NameOfDGroup(InptDisp);
        end;
      Caption := 'Add Quick Order (' + DGroupName + ')';
      lblQuickList.Caption := 'Common List for ' + DGroupName;
      lstQuickList.Caption := lblQuickList.Caption;
      QuickName := GetQuickName(CRC);
      memOrder.Text := ResponseSet.OrderText;
      txtDisplayName.Text := QuickName;
      with lstQuickList do
      begin
        if ResponseSet.DisplayGroup = ClinDisp then
          LoadQuickListForOD(Items, InptDisp)
        else
          LoadQuickListForOD(Items, ResponseSet.DisplayGroup);
        if Length(QuickName) > 0
          then Items.Insert(0, '-1^' + QuickName)
          else Items.Insert(0, '-1^<New Quick Order>');
        ItemIndex := 0;
      end;
      ActiveControl := txtDisplayName;
      ShowModal;
      if OKPressed then
      begin
        Result := True;
        // save reponses as quick order
        ResponseSet.SaveQuickOrder(NewIEN, txtDisplayName.Text);
        // find the new quick order and set the new IEN
        AnIndex := -1;
        with lstQuickList do for i := 0 to Items.Count - 1 do
          if GetIEN(i) = -1 then AnIndex := i;
        if AnIndex > -1 then lstQuickList.Items[AnIndex] := IntToStr(NewIEN) + U +
                                                            txtDisplayName.Text;
        // replace the user's quick list with this new quick list
        if ResponseSet.DisplayGroup = ClinDisp then
          SaveQuickListForOD(lstQuickList.Items, InptDisp)
        else
          SaveQuickListForOD(lstQuickList.Items, ResponseSet.DisplayGroup);
      end; {if OKPressed}
      if IsClinicOrder = True then ResponseSet.DisplayGroup := ClinDisp;
    end; {with frmSaveQuickOrder}
  finally
    frmSaveQuickOrder.Release;
  end;
end;

procedure TfrmSaveQuickOrder.txtDisplayNameChange(Sender: TObject);
var
  AnIndex, i: Integer;
begin
  inherited;
  if txtDisplayName.Text = '' then Exit;
  AnIndex := -1;
  with lstQuickList do for i := 0 to Items.Count - 1 do
    if GetIEN(i) = -1 then AnIndex := i;
  if AnIndex > -1 then lstQuickList.Items[AnIndex] := '-1^' + txtDisplayName.Text;
end;

procedure TfrmSaveQuickOrder.cmdRenameClick(Sender: TObject);
var
  AName: string;
  i: integer;
begin
  inherited;
  with lstQuickList do
  begin
    if ItemIndex < 0 then Exit;
    AName := Piece(Items[ItemIndex], U, 2);
    if ExecuteRename(AName, TX_QO_RENAME) then
    begin
      i := Items.IndexOf(AName);
      if (i > -1) and (i <> ItemIndex) then
        InfoBox(TX_DUP_NAME, TC_DUP_RENAME, MB_ICONERROR or MB_OK)
      else
        Items[ItemIndex] := Piece(Items[ItemIndex], U, 1) + U + AName;
    end;
  end;

end;

procedure TfrmSaveQuickOrder.cmdUpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewIndex: Integer;
begin
  inherited;
  lstQuickList.ItemTipEnable := False;
  if lstQuickList.ItemIndex < 1 then Exit;
  NewIndex := lstQuickList.ItemIndex - 1;
  lstQuickList.Items.Move(lstQuickList.ItemIndex, NewIndex);
  lstQuickList.ItemIndex := NewIndex;
end;

procedure TfrmSaveQuickOrder.cmdUpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  lstQuickList.ItemTipEnable := True;
end;

procedure TfrmSaveQuickOrder.cmdDeleteClick(Sender: TObject);
begin
  inherited;
  with lstQuickList do
  begin
    if ItemIndex < 0 then Exit;
    if ItemIEN = -1 then
    begin
      InfoBox(TX_NO_DEL_NEW, TC_NO_DEL_NEW, MB_OK);
      Exit;
    end;
    if InfoBox(TX_DEL_CONFIRM + DisplayText[ItemIndex], TC_DEL_CONFIRM,
      MB_YESNO or MB_ICONQUESTION) = IDYES then Items.Delete(ItemIndex);
  end;
end;

procedure TfrmSaveQuickOrder.cmdDownMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewIndex: Integer;
begin
  inherited;
  if (lstQuickList.ItemIndex < 0) then Exit;  // nothing selected
  lstQuickList.ItemTipEnable := False;
  if (lstQuickList.ItemIndex > lstQuickList.Items.Count - 2) then Exit;
  NewIndex := lstQuickList.ItemIndex + 1;
  lstQuickList.Items.Move(lstQuickList.ItemIndex, NewIndex);
  lstQuickList.ItemIndex := NewIndex;
end;

procedure TfrmSaveQuickOrder.cmdDownMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  lstQuickList.ItemTipEnable := True;
end;

procedure TfrmSaveQuickOrder.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmSaveQuickOrder.cmdOKClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if txtDisplayName.Enabled then
  begin
    if (txtDisplayName.Text = '') then
    begin
      InfoBox(TX_DNAME_REQ, TC_DNAME_REQ, MB_OK);
      Exit;
    end;
    for i := 0 to lstQuickList.Count - 1 do
      if (UpperCase(lstQuickList.DisplayText[i]) = UpperCase(txtDisplayName.Text)) and (i > 0) then
      begin
        InfoBox(TX_DUP_NAME, TC_DUP_NAME, MB_ICONERROR or MB_OK);
        lstQuickList.ItemIndex := i;
        Exit;
      end;
  end;
  OKPressed := True;
  Close;
end;

procedure TfrmSaveQuickOrder.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmSaveQuickOrder.pnlDownButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 NewIndex: Integer;
begin
 inherited;
 with lstQuickList do
 begin
  ItemTipEnable := false;
  if ItemIndex > Items.Count - 2 then Exit;
  NewIndex := ItemIndex + 1;
  Items.Move(ItemIndex, NewIndex);
  ItemIndex := NewIndex;
 end;
end;

procedure TfrmSaveQuickOrder.pnlDownButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  lstQuickList.ItemTipEnable := true;
end;

procedure TfrmSaveQuickOrder.pnlUpButtonEnter(Sender: TObject);
begin
  inherited;
  TPanel(Sender).BevelOuter := bvRaised;
end;

procedure TfrmSaveQuickOrder.pnlUpButtonExit(Sender: TObject);
begin
  inherited;
  TPanel(Sender).BevelOuter := bvNone;
end;

procedure TfrmSaveQuickOrder.pnlUpButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 NewIndex: Integer;
begin
 inherited;
 with lstQuickList do
 begin
  ItemTipEnable := false;
  if ItemIndex < 1 then Exit;
  NewIndex := ItemIndex - 1;
  Items.Move(ItemIndex, NewIndex);
  ItemIndex := NewIndex;
 end;
end;

procedure TfrmSaveQuickOrder.pnlUpButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  lstQuickList.ItemTipEnable := true;
end;

end.
