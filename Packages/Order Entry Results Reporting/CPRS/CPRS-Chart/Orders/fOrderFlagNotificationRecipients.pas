unit fOrderFlagNotificationRecipients;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, ORCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, VA508AccessibilityManager, System.Actions, Vcl.ActnList;

type
  TfrmOrderFlagRecipients = class(TfrmBase508Form)
    pnlBottom: TPanel;
    pnlButtons: TPanel;
    cmdCancel: TButton;
    cmdOK: TButton;
    Panel1: TPanel;
    grbRecipients: TGroupBox;
    Splitter1: TSplitter;
    pnlRecipientsList: TPanel;
    orSelectedRecipients: TORListBox;
    pnlListButtons: TPanel;
    btnAddRecipient: TButton;
    btnRemoveAllRecipients: TButton;
    btnRemoveRecipients: TButton;
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
    procedure cboAlertRecipientClick(Sender: TObject);
    procedure cboAlertRecipientEnter(Sender: TObject);
    procedure cboAlertRecipientExit(Sender: TObject);
    procedure orSelectedRecipientsExit(Sender: TObject);
    procedure orSelectedRecipientsEnter(Sender: TObject);
    procedure cboAlertRecipientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orSelectedRecipientsClick(Sender: TObject);
  private
    FCboAlertRecipientVistaParams: TArray<string>;
    ExistentRecipients:TStrings;
    procedure RecipientAdd;
    procedure RecipientRemove;
    procedure SetButtonStatus;
  end;

function getRecipientsList(anExceptions:TStrings):TStrings;
procedure NotificationRecipientsCleanUp;

implementation

{$R *.dfm}

uses rCore, ORFn, uSimilarNames;

var
  frmOrderFlagRecipients: TfrmOrderFlagRecipients;

function getRecipientsList(anExceptions:TStrings):TStrings;
begin
  Result := nil;
  if not assigned(frmOrderFlagRecipients) then
    Application.CreateForm(TfrmOrderFlagRecipients,frmOrderFlagRecipients);
  if not assigned(frmOrderFlagRecipients) then
    Exit;
  with frmOrderFlagRecipients do
    begin
      cboAlertRecipient.InitLongList('');
      ExistentRecipients := anExceptions;
//      orSelectedRecipients.Clear;  -- commented out to save list between calls;
      if ShowModal = mrOK then
        Result := orSelectedRecipients.Items;
    end;
end;

procedure NotificationRecipientsCleanUp;
// cleans up list for a new flag action
begin
  if Assigned(frmOrderFlagRecipients) then
    try
      frmOrderFlagRecipients.orSelectedRecipients.Items.Clear
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TfrmOrderFlagRecipients.acAddExecute(Sender: TObject);
begin
  inherited;
  RecipientAdd;
end;

procedure TfrmOrderFlagRecipients.acDeleteAllExecute(Sender: TObject);
begin
  inherited;
  orSelectedRecipients.SelectAll;
  RecipientRemove;
end;

procedure TfrmOrderFlagRecipients.acDeleteExecute(Sender: TObject);
begin
  inherited;
  RecipientRemove;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientClick(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientDblClick(Sender: TObject);
begin
  inherited;
  RecipientAdd;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientEnter(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientExit(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    cboAlertRecipientDblClick(Sender);
end;

procedure TfrmOrderFlagRecipients.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  TORComboBox(Sender).ForDataUse(SubSetOfPersons(StartFrom, Direction,
    FCboAlertRecipientVistaParams));
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsClick(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsDblClick(Sender: TObject);
begin
  inherited;
  RecipientRemove;
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsEnter(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.orSelectedRecipientsExit(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlagRecipients.RecipientAdd;
var
  s, aErrMsg: String;

  function IsSelected(anID:String):Boolean;
  var
    ss: String;
    i: Integer;
  begin
    Result := False;
    if Assigned(ExistentRecipients) and (ExistentRecipients.Count>0) then
      for i := 0 to ExistentRecipients.Count - 1 do
        begin
          ss := ExistentRecipients[i];
          Result := piece(ss,'^',1) = anID;
          if Result then
            break;
        end;
  end;

begin
  if (cboAlertRecipient.ItemIndex = -1) or
    (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) <> -1)
    or IsSelected(IntToStr(cboAlertRecipient.ItemID))
    then
  begin
    ShowMessage('This person is already Order Flag Alert recipient');
    exit;
  end
  else
    begin
      s := cboAlertRecipient.Items[cboAlertRecipient.ItemIndex];
      // checking duplicate names  request ##133 Issue Tracker
      if not CheckForSimilarName(cboAlertRecipient, aErrMsg, ltProvider,
        FCboAlertRecipientVistaParams, sPr, '', orSelectedRecipients.Items) then
      begin
        ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection');
        exit;
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
  acAdd.Enabled := (cboAlertRecipient.ItemIndex > -1) and
    (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) < 0);

  acDelete.Enabled := (orSelectedRecipients.SelCount > 0) and
    (orSelectedRecipients.Items.Count > 0);
//    orSelectedRecipients.Focused;

  acDeleteAll.Enabled := orSelectedRecipients.Items.Count > 0;

  orSelectedRecipients.TabStop := orSelectedRecipients.Items.Count > 0;
end;

end.
