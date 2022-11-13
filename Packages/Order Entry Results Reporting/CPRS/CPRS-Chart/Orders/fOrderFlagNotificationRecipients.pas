unit fOrderFlagNotificationRecipients;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, ORCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, VA508AccessibilityManager, System.Actions, Vcl.ActnList, u508Button ;

type

  TfrmOrderFlagRecipients = class(TfrmBase508Form)
    pnlBottom: TPanel;
    pnlButtons: TPanel;
    cmdCancel: u508Button.TButton;
    cmdOK: u508Button.TButton;
    Panel1: TPanel;
    grbRecipients: TGroupBox;
    Splitter1: TSplitter;
    pnlRecipientsList: TPanel;
    orSelectedRecipients: TORListBox;
    pnlListButtons: TPanel;
    btnAddRecipient: u508Button.TButton;
    btnRemoveAllRecipients: u508Button.TButton;
    btnRemoveRecipients: u508Button.TButton;
    pnlRecipientsSource: TPanel;
    cboAlertRecipient: TORComboBox;
    alRecipients: TActionList;
    acAdd: TAction;
    acDelete: TAction;
    acDeleteAll: TAction;
    procedure cboAlertRecipientNeedData(Sender: TObject;
      const StartFrom: string; Direction, InsertAt: Integer);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acDeleteAllExecute(Sender: TObject);
    procedure cboAlertRecipientDblClick(Sender: TObject);
    procedure orSelectedRecipientsDblClick(Sender: TObject);
    procedure cboAlertRecipientEnter(Sender: TObject);
    procedure orSelectedRecipientsEnter(Sender: TObject);
    procedure cboAlertRecipientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orSelectedRecipientsClick(Sender: TObject);
    procedure cboAlertRecipientChange(Sender: TObject);
  private
    fExistentRecipients:TStrings;
    procedure RecipientAdd;
    procedure RecipientRemove;
    procedure SetButtonStatus;
  public
    procedure getRecipientsList(aExisintingRecipients:TStrings; aResults: TStrings);
    Property ExistentRecipients: TStrings read fExistentRecipients write fExistentRecipients;
  end;

implementation

{$R *.dfm}

uses rCore, ORFn, uORLists, uSimilarNames, VAUtils,
  VA508AccessibilityRouter;


procedure TfrmOrderFlagRecipients.acAddExecute(Sender: TObject);
begin
  inherited;
  // Add recipient and disable the add button.
  // Will re-enable when a new person is selected
  RecipientAdd;
  SetButtonStatus;
  if ScreenReaderActive then
    GetScreenReader.Speak('Recipient added');
end;

procedure TfrmOrderFlagRecipients.acDeleteAllExecute(Sender: TObject);
begin
  inherited;
  // Select all recipients and then remove the selected
  // Disable the remove all button since no entries left
  orSelectedRecipients.SelectAll;
  RecipientRemove;
  SetButtonStatus;
  if ScreenReaderActive then
    GetScreenReader.Speak('All Recipients removed');
end;

procedure TfrmOrderFlagRecipients.acDeleteExecute(Sender: TObject);
begin
  inherited;
  // Remove the selected recipient and disable the remove button.
  // Will re-enable when a new recipient is selected
  RecipientRemove;
  SetButtonStatus;
  if ScreenReaderActive then
    GetScreenReader.Speak('Recipient removed');
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientChange(Sender: TObject);
begin
  inherited;
  // Changing potential recipients so check if we can add
  setButtonStatus;
end;


procedure TfrmOrderFlagRecipients.cboAlertRecipientDblClick(Sender: TObject);
begin
  inherited;
  // If able call the recipient add action
  acAdd.Execute;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientEnter(Sender: TObject);
begin
  inherited;
  // Ensure that there is no recipient selection
  orSelectedRecipients.ClearSelection;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  // If enter is pressed then try to add to the recipients
  if Key = VK_RETURN then
    cboAlertRecipientDblClick(Sender);
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  //Get the list of potential recipients
  setPersonList(TORComboBox(Sender), StartFrom, Direction); // RTC Defect 732085
end;

Procedure TfrmOrderFlagRecipients.getRecipientsList(
  aExisintingRecipients: TStrings; aResults: TStrings);
begin
  // show the recipient selection form and return the selected recipients
  if Assigned(aResults) then
  begin
    cboAlertRecipient.Clear;
    cboAlertRecipient.InitLongList('');
    fExistentRecipients  := aExisintingRecipients;
    SetButtonStatus;
    if ShowModal = mrOK then
      aResults.Assign(orSelectedRecipients.Items);
  end;
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsClick(Sender: TObject);
begin
  inherited;
  // Update button status since the recipients changed
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsDblClick(Sender: TObject);
begin
  inherited;
  // If available remove the selected recipient
  acDelete.Execute;
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsEnter(Sender: TObject);
begin
  inherited;
  //Ensure that no potential recipients are selected
  cboAlertRecipient.ItemIndex := -1;
end;

procedure TfrmOrderFlagRecipients.RecipientAdd;

  function IsSelected(anID:String):Boolean;
  var
    ss: String;
    i: Integer;
  begin
    Result := False;
    if Assigned(fExistentRecipients) and (fExistentRecipients.Count>0) then
      for i := 0 to fExistentRecipients.Count - 1 do
        begin
          ss := fExistentRecipients[i];
          Result := piece(ss,'^',1) = anID;
          if Result then
            break;
        end;
  end;

var
  s, aErrMsg: String;
begin
  if (cboAlertRecipient.ItemIndex = -1) or
    (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) <> -1)
    or IsSelected(IntToStr(cboAlertRecipient.ItemID))
    then
  begin
    ShowMessage('This person is already an Order Flag Alert recipient');
    exit;
  end
  else
    begin
      s := cboAlertRecipient.Items[cboAlertRecipient.ItemIndex];
      // checking duplicate names  request ##133 Issue Tracker
      if not CheckForSimilarName(cboAlertRecipient, aErrMsg, sPr,
        orSelectedRecipients.Items) then
      begin
        ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection');
        Exit;
      end else
        orSelectedRecipients.Items.Add(s); //cboAlertRecipient.Items[cboAlertRecipient.ItemIndex]);
    end;
end;

procedure TfrmOrderFlagRecipients.RecipientRemove;
var
  i: Integer;
begin
  with orSelectedRecipients do
  begin
    if ItemIndex = -1 then
      exit;
    for i := Items.Count - 1 downto 0 do
      if Selected[i] then
      begin
        Items.Delete(i);
      end;
  end;
end;

procedure TfrmOrderFlagRecipients.setButtonStatus;
begin
  // Something selected and not already in the recipient list
  acAdd.Enabled := (cboAlertRecipient.ItemIndex > -1) and
    (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) < 0);

  // recipient(s) selected
  acDelete.Enabled := (orSelectedRecipients.SelCount > 0);

  // Has recipients
  acDeleteAll.Enabled := orSelectedRecipients.Items.Count > 0;

end;

end.
