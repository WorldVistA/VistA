unit fAlertForward;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls,
  Dialogs, StdCtrls, Buttons, ORCtrls, ORfn, ExtCtrls, fAutoSz, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmAlertForward = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboSrcList: TORComboBox;
    DstList: TORListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    pnlBase: TORAutoPanel;
    memAlert: TMemo;
    Label1: TLabel;
    memComment: TMemo;
    btnAddAlert: TButton;
    btnRemoveAlertFwrd: TButton;
    btnRemoveAllAlertFwrd: TButton;
    procedure btnRemoveAlertFwrdClick(Sender: TObject);
    procedure btnAddAlertClick(Sender: TObject);
    procedure cboSrcListNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboSrcListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboSrcListMouseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboSrcListChange(Sender: TObject);
    procedure DstListChange(Sender: TObject);
    procedure btnRemoveAllAlertFwrdClick(Sender: TObject);
  private
    RemovingAll: boolean;
  end;

function ForwardAlertTo(Alert: String): Boolean;


implementation

{$R *.DFM}

uses rCore, uCore, VA508AccessibilityRouter;

const
    TX_DUP_RECIP = 'You have already selected that recipient.';
    TX_RECIP_CAP = 'Error adding recipient';

var  XQAID: string;

function ForwardAlertTo(Alert: String): Boolean;
var
  frmAlertForward: TfrmAlertForward;
begin
  frmAlertForward := TfrmAlertForward.Create(Application);
  try
    ResizeAnchoredFormToFont(frmAlertForward);
    with frmAlertForward do
    begin
      memAlert.SetTextBuf(PChar(Piece(Alert, U, 2)));
      XQAID := Piece(Alert, U, 1);
      ShowModal;
    end;
  finally
    frmAlertForward.Release;
    Result := True;
  end;
end;

procedure TfrmAlertForward.FormCreate(Sender: TObject);
begin
  inherited;
  if ScreenReaderSystemActive then
    memAlert.TabStop := TRUE;
  cboSrcList.InitLongList('');  
end;

procedure TfrmAlertForward.cboSrcListNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmAlertForward.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlertForward.cmdOKClick(Sender: TObject);
var
  i: integer ;
  Recip: string;
begin

  for i := 0 to DstList.Items.Count-1 do
  begin
    Recip := Piece(DstList.Items[i], U, 1);
    memComment.Text := StringReplace(memComment.Text, CRLF, ' ', [rfReplaceAll]);
    ForwardAlert(XQAID, Recip, 'A', memComment.Text);
  end;
  Close;
end;

procedure TfrmAlertForward.DstListChange(Sender: TObject);
var
  HasFocus: boolean;
begin
  inherited;
  if DstList.SelCount = 1 then
    if Piece(DstList.Items[0], '^', 1) = '' then
    begin
      btnRemoveAlertFwrd.Enabled := false;
      btnRemoveAllAlertFwrd.Enabled := false;
      exit;
    end;
  HasFocus := btnRemoveAlertFwrd.Focused;
  if Not HasFocus then
    HasFocus := btnRemoveAllAlertFwrd.Focused;
  btnRemoveAlertFwrd.Enabled := DstList.SelCount > 0;
  btnRemoveAllAlertFwrd.Enabled := DstList.Items.Count > 0;
  if HasFocus and (DstList.SelCount = 0) then
    btnAddAlert.SetFocus; 
end;

procedure TfrmAlertForward.btnAddAlertClick(Sender: TObject);
begin
  inherited;
  cboSrcListMouseClick(btnAddAlert);
end;

procedure TfrmAlertForward.btnRemoveAlertFwrdClick(Sender: TObject);
var
  i: integer;
begin
  with DstList do
    begin
      if ItemIndex = -1 then exit ;
      for i := Items.Count-1 downto 0 do
        if Selected[i] then
        begin
          if ScreenReaderSystemActive and (not RemovingAll) then
            GetScreenReader.Speak(Piece(DstList.Items[i],U,2) +
            ' Removed from ' + DstLabel.Caption);
          Items.Delete(i) ;
        end;
    end;
end;

procedure TfrmAlertForward.btnRemoveAllAlertFwrdClick(Sender: TObject);
begin
  inherited;
  DstList.SelectAll;
  RemovingAll := TRUE;
  try
    btnRemoveAlertFwrdClick(self);
    if ScreenReaderSystemActive then
      GetScreenReader.Speak(DstLabel.Caption + ' Cleared');
  finally
    RemovingAll := FALSE;
  end;
end;

procedure TfrmAlertForward.cboSrcListChange(Sender: TObject);
begin
  inherited;
  btnAddAlert.Enabled := CboSrcList.ItemIndex > -1;
end;

procedure TfrmAlertForward.cboSrcListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
     cboSrcListMouseClick(Self);
  end;
end;

procedure TfrmAlertForward.cboSrcListMouseClick(Sender: TObject);
begin
  if cboSrcList.ItemIndex = -1 then exit;
  if (DstList.SelectByID(cboSrcList.ItemID) <> -1) then
    begin
      InfoBox(TX_DUP_RECIP, TX_RECIP_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  DstList.Items.Add(cboSrcList.Items[cboSrcList.Itemindex]);
  if ScreenReaderSystemActive then
    GetScreenReader.Speak(Piece(cboSrcList.Items[cboSrcList.Itemindex],U,2) +
      ' Added to ' + DstLabel.Caption);
  btnRemoveAlertFwrd.Enabled := DstList.SelCount > 0;
  btnRemoveAllAlertFwrd.Enabled := DstList.Items.Count > 0;
end;

end.
