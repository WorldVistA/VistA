unit fNewAllergyCheck;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, ORClasses,
  System.Classes, Vcl.Graphics, fAutoSz,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ORCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  VA508AccessibilityManager, Vcl.Buttons, System.Actions, Vcl.ActnList,
  u508Button;

type
  TfrmNewAllergyCheck = class(TfrmAutoSz)
    pnlCheck: TPanel;
    pnlOptRecipients: TPanel;
    lblRecipients: TLabel;
    Recipients: TORListBox;
    Check: TMemo;
    lblSent: TLabel;
    pnlButton: TPanel;
    btnSendAlertBtn: u508Button.TButton;
    pnlOptRecipientsSub: TPanel;
    OptRecip: TORComboBox;
    pnlOptRecipientsButtons: TPanel;
    btnRemove: u508Button.TButton;
    btnAdd: u508Button.TButton;
    btnRemoveAll: u508Button.TButton;
    ActionList1: TActionList;
    actAdd: TAction;
    actRemove: TAction;
    actRemoveAll: TAction;
    actOK: TAction;
    pnlRecipients: TPanel;
    SelRecip: TORListBox;
    procedure OptRecipxxNeedData(Sender: TObject;
      const StartFrom: string; Direction, InsertAt: Integer);
    procedure OptRecipKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OptRecipNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure OptRecipDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actRemoveExecute(Sender: TObject);
    procedure actRemoveAllExecute(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
    procedure OptRecipChange(Sender: TObject);
    procedure SelRecipClick(Sender: TObject);
    procedure OptRecipEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SelRecipDblClick(Sender: TObject);
    procedure SelRecipEnter(Sender: TObject);
    procedure SelRecipKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fOrderNo:string;
    fRecipientList: TORStringList;
    procedure UpdateButtonStatus;
    procedure RecipientAdd;
    procedure RecipientRemove;
  public
    { Public declarations }
    procedure setByOrder(anOrder,aNewAllergy,tDFN:String; Cleanup:Boolean = true);
  end;

Function ExecuteNewAllergyCheck(aMatchingDrugs: TStringList; aNewAllergy: string): Boolean;

implementation

{$R *.dfm}

uses fAllgyAR, ORNet, uCore, rCore, ORfn, uORLists, uSimilarNames, VAUtils;

Function ExecuteNewAllergyCheck(aMatchingDrugs: TStringList;
  aNewAllergy: string): Boolean;
var
  frmNewAllergyCheck: TfrmNewAllergyCheck;
  I: Integer;
begin
  try
    frmNewAllergyCheck := TfrmNewAllergyCheck.Create(Application);
    try
      ResizeAnchoredFormToFont(frmNewAllergyCheck);
      for I := 0 to aMatchingDrugs.Count - 1 do
      begin
        frmNewAllergyCheck.setByOrder(aMatchingDrugs[I], aNewAllergy,
          Patient.DFN);
        frmNewAllergyCheck.ShowModal;
      end;
    finally
      frmNewAllergyCheck.Free;
    end;
    Result := true;
  Except
    On e: Exception do
    begin
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TfrmNewAllergyCheck.setByOrder(anOrder, aNewAllergy, tDFN: String;
  Cleanup: Boolean = true);
var
  I: Integer;
  ReturnedList: tStringList;
  aName, aTitle: string;

begin
  if Cleanup then
    Recipients.Items.Clear;
  fRecipientList.Clear;

  Check.Lines.Clear;
  OptRecip.InitLongList('');

  Check.Lines.Add('The following ACTIVE Order has a potential reaction to  ' +
    aNewAllergy);

  for I := 7 to ORfn.DelimCount(anOrder, '^') + 1 do
    Check.Lines.Add(Piece(anOrder, '^', I));

  Check.Lines.Add('');
  Check.Lines.Add('   ' + Piece(anOrder, '^', 3) + ' (Order# ' + Piece(anOrder,
    '^', 1) + ')');
  Check.Lines.Add('');

  fOrderNo := Piece(anOrder, '^', 1);
  I := Pos(';', fOrderNo);
  if I > 0 then
    fOrderNo := Copy(anOrder, 1, I - 1);

  ReturnedList := TStringList.Create;
  try
    CallVistA('ORWDAL32 GETPROV', [fOrderNo, tDFN], ReturnedList);
    MixedCaseList(ReturnedList);
    fRecipientList.AddStrings(ReturnedList);
    for I := 0 to ReturnedList.Count - 1 do
    begin
      aName := Piece(ReturnedList[I], U, 2);
      aTitle := Piece(ReturnedList[I], U, 3);
      if aTitle <> '' then aTitle := ' - ' + aTitle;
      Recipients.Items.Add(aName + aTitle);
    end;
  finally
    ReturnedList.Free;
  end;

  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.actOKExecute(Sender: TObject);
var
  line, DUZ, aTitle: string;
  I: Integer;

begin
  for I := 0 to SelRecip.Items.Count - 1 do
  begin
    line := SelRecip.Items[I];
    DUZ := Piece(line, U, 1);
    if (DUZ <> '') and (fRecipientList.IndexOfPiece(DUZ) < 0) then
    begin
      aTitle := Piece(line, U, 3);
      if aTitle.StartsWith('- ') then
      begin
        delete(aTitle, 1, 2);
        SetPiece(line, U, 3, aTitle);
      end;
      fRecipientList.Add(line);
    end;
  end;
  if fRecipientList.Count > 0 then
    CallVistA('ORWDAL32 SENDALRT',[fOrderNo, fRecipientList]);
end;

procedure TfrmNewAllergyCheck.OptRecipNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  uORLists.setPersonList(OptRecip ,StartFrom, Direction);
end;

procedure TfrmNewAllergyCheck.FormActivate(Sender: TObject);
begin
  inherited;
  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.FormCreate(Sender: TObject);
begin
  inherited;
  fOrderNo := '';
  Check.TabStop := ScreenReaderActive;
  fRecipientList := TORStringList.Create;
end;

procedure TfrmNewAllergyCheck.FormDestroy(Sender: TObject);
begin
  fRecipientList.Free;
  inherited;
end;

procedure TfrmNewAllergyCheck.OptRecipChange(Sender: TObject);
begin
  inherited;
  // Update button status since the recipients changed
  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.OptRecipDblClick(Sender: TObject);
begin
  inherited;
  actAdd.Execute;
end;

procedure TfrmNewAllergyCheck.OptRecipEnter(Sender: TObject);
begin
  inherited;
  // Ensure that there is no recipient selection
  SelRecip.ClearSelection;
end;

procedure TfrmNewAllergyCheck.OptRecipKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  // If enter is pressed then try to add to the recipients
  if Key = VK_RETURN then
    OptRecipDblClick(Self);
end;

procedure TfrmNewAllergyCheck.OptRecipxxNeedData(Sender: TObject;     // NJC - 1 090717
  const StartFrom: string; Direction, InsertAt: Integer);
var uCase:string;                        // NJC 090717
begin
  inherited;
  setProviderList(OptRecip, uCase, Direction);         // NJC 090717
end;

procedure TfrmNewAllergyCheck.RecipientAdd;
var
  aErrMsg, s: String;
begin
  if (OptRecip.ItemIndex = -1) or
    (SelRecip.SelectByID(OptRecip.ItemID) <> -1)
    then
    exit
  else
    begin
       // checking duplicate names  request ##133 Issue Tracker
      if not CheckForSimilarName(OptRecip, aErrMsg, sPr) then
      begin
        ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection');
        exit;
      end;

      s := OptRecip.Items[OptRecip.ItemIndex];
      SelRecip.Items.Add(s);
      SelRecip.ItemIndex := SelRecip.Items.Count - 1;
    end;
end;

procedure TfrmNewAllergyCheck.RecipientRemove;
var
  I: Integer;
begin
  if SelRecip.itemindex = -1 then
    exit;
  for I := SelRecip.Items.Count - 1 downto 0 do
    if SelRecip.Selected[I] then
      SelRecip.Items.Delete(I);
end;

procedure TfrmNewAllergyCheck.SelRecipClick(Sender: TObject);
begin
  inherited;
  // Changing potential recipients so check if we can add
  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.SelRecipDblClick(Sender: TObject);
begin
  inherited;
  // If available remove the selected recipient
  actRemove.Execute;
end;

procedure TfrmNewAllergyCheck.SelRecipEnter(Sender: TObject);
begin
  inherited;
  Recipients.ItemIndex := -1;
end;

procedure TfrmNewAllergyCheck.SelRecipKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  // If enter is pressed then try to remove the recipient(s)
  if ord(Key) = VK_RETURN then
    SelRecipDblClick(Sender);
end;

procedure TfrmNewAllergyCheck.actAddExecute(Sender: TObject);
begin
  // Add recipient and disable the add button.
  // Will re-enable when a new person is selected
  RecipientAdd;
  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.actRemoveAllExecute(Sender: TObject);
begin
  inherited;
  // Select all recipients and then remove the selected
  // Disable the remove all button since no entries left
  SelRecip.SelectAll;
  RecipientRemove;
  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.actRemoveExecute(Sender: TObject);
begin
  // Remove the selected recipient and disable the remove button.
  // Will re-enable when a new recipient is selected
  RecipientRemove;
  UpdateButtonStatus;
end;

procedure TfrmNewAllergyCheck.UpdateButtonStatus;
begin
   // Something selected and not already in the recipient list
  actAdd.Enabled := (OptRecip.ItemIndex > -1) and
    (SelRecip.SelectByID(OptRecip.ItemID) < 0);

  // recipient(s) selected
  actRemove.Enabled := (SelRecip.SelCount > 0);

  // Has recipients
  actRemoveAll.Enabled := SelRecip.Items.Count > 0;

  //Must have a Recipient
  actOK.Enabled := (Recipients.items.Count > 0) or (SelRecip.Items.Count > 0);
end;


end.
