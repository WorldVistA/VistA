unit fOrderFlagEditor;
{ Order Flag properties editor }
{------------------------------------------------------------------------------
Update History
    2016-05-17: NSR#20110719 (Order Flag Recommendations)
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, ORCtrls,
  VA508AccessibilityManager,
  ORDtTm, Vcl.ExtCtrls, uOrderFlag, uFormUtils, Vcl.Buttons,fBase508Form,
  Vcl.ActnList, iOrderFlagPropertiesEditorIntf, iResizableFormIntf, uConst,
  System.Actions, fOrderFlagNotificationRecipients, u508button;

type

  TCheckBox = class(StdCtrls.TCheckBox)
  protected
    procedure Resize; override;
  private
    fMgr: TVA508AccessibilityManager;
    f508Label: TVA508StaticText;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure RegisterWithMGR;
    function GetIsScreenReaderActive: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property IsScreenReaderActive: Boolean read GetIsScreenReaderActive;
  end;

  TORDateBox = class(ORDtTm.TORDateBox)
  protected
    procedure Resize; override;
  private
    fMgr: TVA508AccessibilityManager;
    f508Label: TVA508StaticText;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure RegisterWithMGR;
    function GetIsScreenReaderActive: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property IsScreenReaderActive: Boolean read GetIsScreenReaderActive;
  end;

  TfrmOrderFlag = class(TfrmBase508Form, IOrderFlagPropertiesEditor, IResizableForm)
    cmdOK: u508button.TButton;
    cmdCancel: u508button.TButton;
    mmOrder: TMemo;
    cboFlagReason: TORComboBox;
    cboAlertRecipient: TORComboBox;
    orSelectedRecipients: TORListBox;
    dtFlagExpire: TORDateBox;
    btnRemoveAllRecipients: u508button.TButton;
    btnAddRecipient: u508button.TButton;
    pnlBottom: TPanel;
    pnlCanvas: TPanel;
    pnlNoActionAlert: TPanel;
    pnlDescription: TPanel;
    pnlReason: TPanel;
    pnlRecipients: TPanel;
    pnlRecipientsSource: TPanel;
    pnlRecipientsList: TPanel;
    cbReasonRequired: TCheckBox;
    cbNoActionRequired: TCheckBox;
    pnlComment: TPanel;
    txtComment: TCaptionEdit;
    cbRequiredComment: TCheckBox;
    splDetails: TSplitter;
    pnlInstructions: TPanel;
    mmInstructions: TMemo;
    sbDebug: TSpeedButton;
    pnlButtons: TPanel;
    pnlListButtons: TPanel;
    cbRecipientsRequired: TCheckBox;
    alEditorActions: TActionList;
    acFlagRemove: TAction;
    acFlagComment: TAction;
    acFlagSet: TAction;
    acRecipientAdd: TAction;
    acRecipientRemoveAll: TAction;
    acRecipientSelect: TAction;
    memComment: TMemo;
    btnRemoveRecipients: u508button.TButton;
    acRecipientRemove: TAction;
    orRecipientsAdd: TORListBox;
    cbCreateNoActionAlert: TCheckBox;
    lblOrderDetails: TLabel;
    lblReason: TLabel;
    lblRecipients: TLabel;
    pnlRecipientsSub: TPanel;
    lblNoActionAlert: TLabel;
    lblRecipientsAdd: TLabel;
    pnlRecipientsAdd: TPanel;
    pnlCommentSub: TPanel;
    lblComment: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cboAlertRecipientNeedData(Sender: TObject;
      const StartFrom: string; Direction, InsertAt: Integer);
    procedure cboAlertRecipientChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cboFlagReasonChange(Sender: TObject);
    procedure sbDebugClick(Sender: TObject);
    procedure cboAlertRecipientDblClick(Sender: TObject);
    procedure orSelectedRecipientsDblClick(Sender: TObject);
    procedure cbReasonRequiredClick(Sender: TObject);
    procedure cbRecipientsRequiredClick(Sender: TObject);
    procedure cbNoActionRequiredClick(Sender: TObject);
    procedure pnlRecipientsResize(Sender: TObject);
    procedure txtCommentChange(Sender: TObject);
    procedure cbRequiredCommentClick(Sender: TObject);
    procedure pnlRecipientsListResize(Sender: TObject);
    procedure pnlNoActionAlertResize(Sender: TObject);
    procedure acFlagSetExecute(Sender: TObject);
    procedure cboAlertRecipientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orSelectedRecipientsClick(Sender: TObject);
    procedure acRecipientAddExecute(Sender: TObject);
    procedure acRecipientRemoveExecute(Sender: TObject);
    procedure acRecipientRemoveAllExecute(Sender: TObject);
    procedure cboAlertRecipientEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure orSelectedRecipientsEnter(Sender: TObject);
    procedure acRecipientSelectExecute(Sender: TObject);
    procedure memCommentChange(Sender: TObject);
    procedure orRecipientsAddChange(Sender: TObject);
    procedure orRecipientsAddKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orRecipientsAddDblClick(Sender: TObject);
    procedure cbCreateNoActionAlertClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmOrderEnter(Sender: TObject);
    procedure orSelectedRecipientsKeyPress(Sender: TObject; var Key: Char);
  private
    FNeedsToResizeToFontSize: Integer;
    fDebug: Boolean;
    bIgnore: Boolean;
    fFlagInfo: TOrderFlag;
    fViewMode: TViewMode;
    fActionMode: TActionMode;
    fOrdersCount: Integer;
    fFlagRecipients: TfrmOrderFlagRecipients;
    procedure setButtonStatus;
    procedure setFlagInfo(anInfo: TOrderFlag);
//    procedure setFlagRecipients(anInfo: TOrderFlag);
    procedure reportStatus;
    procedure reportActionResult;
    procedure setViewMode(aMode: TViewMode);
    procedure setActionMode(aMode: TActionMode);
    procedure setRequiredByActionMode(aMode:TActionMode);
    procedure setProcessedMode(aProcessed: Boolean);
    procedure RecipientAdd;
    procedure RecipientRemove;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure setOrdersCount(aValue:Integer);
    function GetFlagRecipients: TfrmOrderFlagRecipients;
  protected
    // procedure Loaded;override;
  public
    ActionResult: String;
    MasterForm: TForm;
    property ViewMode: TViewMode read fViewMode write setViewMode;
    property ActionMode: TActionMode read fActionMode write setActionMode;
    property FlagInfo: TOrderFlag read fFlagInfo write setFlagInfo;
    property OrdersCount: Integer read fOrdersCount write setOrdersCount;
    property FlagRecipients: TfrmOrderFlagRecipients read GetFlagRecipients;

    constructor createParented(aParentForm: TForm; aParentControl: TWinControl);
    function IsValid(aTag: Integer): Boolean;
    function IsCommentValid:Boolean;
    procedure ResizeToFont(aSize: Integer);

    procedure setGUIByMultipleObjects(aList:TObject);
    procedure setGUIByObject(anObject: TObject);
    function IsValidArray(anArray: Array of Integer): Boolean;

    function getVisibleFieldNames:String;
    procedure setDebugView(aValue: Boolean);
    function CheckFlag: boolean;
  end;

const
  prpReason = 1;
  prpComment = 2;
  prpRecipients = 3;
  prpNoAction = 4;

  PrefixRequired = '* ';
  a508PrefixRequired = ' Required';

  iGap = 8;
  iGapHeader = 4;
  iGapTail = 2;

  igButtonTop = 4;
  igButtonLeft = 8;

  btnMinWidth = 75;
  btnMinHeight = 21;
  btnLeftMargin = 4;

  OrderFlagCommentsLimit = 240; // comments should not exceed 240 chars RSD 2.6.24.1.1.5

  TX_NO_PROVIDER_CAP = 'Invalid Provider';

implementation

{$R *.DFM}

uses
  uCore,
  rCore,
  uORLists,
  uSimilarNames,
  System.UITypes,
  VAUtils,
  VA508AccessibilityRouter,
  UResponsiveGUI;

function getHint(aStrings:TStrings;aCount: Integer = 15):String;
var
  i: Integer;
begin
  i := 0;
  Result := '';
  while (i < aStrings.Count) and (i < aCount) do
    begin
      Result := Result + aStrings[i]+CRLF;
      inc(i);
    end;
  if aStrings.Count > aCount then
    Result := Result + '...' + CRLF + '(Scroll the text area for more information)';
end;

function getRequiredCaption(aCaption: String; aRequired: Boolean): String;
var
  ReqPrefix: String;
begin
  if ScreenReaderActive then
    ReqPrefix := a508PrefixRequired
  else
    ReqPrefix := PrefixRequired;

  if aRequired then
  begin
    if pos(ReqPrefix, aCaption) <> 1 then
    begin
      if ScreenReaderActive then
        Result := aCaption + ReqPrefix
      else
        Result := ReqPrefix + aCaption
    end else
      Result := aCaption;
  end
  else if pos(ReqPrefix, aCaption) = 1 then
    Result := copy(aCaption, Length(ReqPrefix) + 1, Length(aCaption))
  else
    Result := aCaption
end;

const
  TX_REASON_REQ = 'A reason must be entered to flag an order.';
  TC_REASON_REQ = 'Reason Required';

constructor TfrmOrderFlag.createParented(aParentForm: TForm;
  aParentControl: TWinControl);
begin
  inherited Create(aParentForm);
  MasterForm := aParentForm;
  ViewMode := vmParentedForm;
  setFormParented(self, aParentControl);
  sbDebug.Visible := fDebug;
  cbReasonRequired.Visible := fDebug;
  cbNoActionRequired.Visible := fDebug;
  cbRecipientsRequired.Visible := fDebug;

  lblReason.Caption := getRequiredCaption(lblReason.Caption,
    cbReasonRequired.Checked);
  lblNoActionAlert.Caption := getRequiredCaption(lblNoActionAlert.Caption,
    cbNoActionRequired.Checked);
  lblRecipients.Caption := getRequiredCaption(lblRecipients.Caption,
    cbRecipientsRequired.Checked);
  lblComment.Caption := getRequiredCaption(lblComment.Caption,
    cbRequiredComment.Checked);
end;

function TfrmOrderFlag._AddRef: Integer;
begin
  Result := -1;
end;

function TfrmOrderFlag._Release: Integer;
begin
  Result := -1;
end;

procedure TfrmOrderFlag.orRecipientsAddChange(Sender: TObject);
begin
  inherited;
  acRecipientSelect.Execute;
end;

procedure TfrmOrderFlag.orRecipientsAddDblClick(Sender: TObject);
begin
  inherited;
  acRecipientSelect.Execute;
end;

procedure TfrmOrderFlag.orRecipientsAddKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_Return then
    acRecipientSelect.Execute;
end;



procedure TfrmOrderFlag.orSelectedRecipientsClick(Sender: TObject);
begin
  inherited;
  // Update button status since the recipients changed
  setButtonStatus;
end;

procedure TfrmOrderFlag.orSelectedRecipientsDblClick(Sender: TObject);
begin
  inherited;
  // If available remove the selected recipient
  acRecipientRemove.Execute;
end;

procedure TfrmOrderFlag.orSelectedRecipientsEnter(Sender: TObject);
begin
  inherited;
   //Ensure that no potential recipients are selected
  cboAlertRecipient.ItemIndex := -1;
end;

procedure TfrmOrderFlag.orSelectedRecipientsKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  // If enter is pressed then try to remove the recipient(s)
  if ord(Key) = VK_RETURN then
    orSelectedRecipientsDblClick(Sender);
end;

procedure TfrmOrderFlag.pnlNoActionAlertResize(Sender: TObject);
begin
  inherited;
  dtFlagExpire.Width :=
    pnlNoActionAlert.Width - dtFlagExpire.Left - 8;
end;

procedure TfrmOrderFlag.pnlRecipientsListResize(Sender: TObject);
begin
  inherited;
  pnlRecipientsSource.Width :=
    (pnlRecipients.Width - pnlListButtons.Width) div 2;
end;

procedure TfrmOrderFlag.pnlRecipientsResize(Sender: TObject);
begin
  inherited;
exit;
  cboAlertRecipient.Height := pnlRecipients.Height - cboAlertRecipient.Top - 16;
  orSelectedRecipients.Height := pnlRecipients.Height -
    orSelectedRecipients.Top - 16;
  orSelectedRecipients.Width :=
    pnlRecipientsList.Width - orSelectedRecipients.Left - 4;
end;

function TfrmOrderFlag.CheckFlag: boolean;
// The Flag button has been clicked and the set flag is about to be saved
// Return False if there are issues
begin
  Result := True;
  if Assigned(FlagInfo) then begin
    if cbCreateNoActionAlert.Checked then
    begin
      try
        // dtFlagExpire.DateSelected may not be right! (We should probably change this in the component)
        FlagInfo.Expires := FMDateTimeToDateTime(dtFlagExpire.FMDateTime);
      except
        on E: EFMDateTimeError do begin
          MessageDlg(Format('%s is not a valid date and time',
            [dtFlagExpire.Text]), mtError, [mbOK], 0, mbOK);
          Result := False;
        end;
      end;
    end else begin
      FlagInfo.Expires := 0; // The value that means "no expiration"
    end;
  end;
end;

procedure TfrmOrderFlag.FormActivate(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlag.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  function IsValid: Boolean;
  var
    Err:String;
  begin
    Result := False;
    case ViewMode of
      vmParentedForm:
        ;
      vmDialog:
        if Assigned(FlagInfo) then
          Result := FlagInfo.IsValid(Err); // OFStatus = stOFValid;
      vmConfirmationDlg:
        Result := True;
    end;
  end;

begin
  inherited;
  CanClose := (ModalResult = mrCancel) or IsValid;
  if not CanClose then
    InfoBox(TX_REASON_REQ, TC_REASON_REQ, MB_OK);
end;

procedure TfrmOrderFlag.FormCreate(Sender: TObject);
var
  tmpList: TStringList;
begin
  inherited;
  // AutoSizeDisabled := True;
  tmpList := TStringList.Create;
  try
    GetUserListParam(tmpList, 'OR FLAGGED ORD REASONS');
    tmpList.Insert(0, '');
    FastAssign(tmpList, cboFlagReason.Items);
  finally
    tmpList.Free;
  end;
  cboAlertRecipient.InitLongList('');
  dtFlagExpire.DateSelected := getOrderFlagExpireDefault; // Now;
  dtFlagExpire.FMDateTime := DateTimeToFMDateTime(dtFlagExpire.DateSelected);

  dtFlagExpire.DateRange.MinDate := FMDateTimeToDateTime(FMNow);
end;

procedure TfrmOrderFlag.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fFlagRecipients);
  inherited;
end;

procedure TfrmOrderFlag.FormShow(Sender: TObject);
begin
  inherited;
  if FNeedsToResizeToFontSize >= 0 then ResizeToFont(FNeedsToResizeToFontSize);
end;

function TfrmOrderFlag.GetFlagRecipients: TfrmOrderFlagRecipients;
begin
  if not assigned(fFlagRecipients) then
    fFlagRecipients := TfrmOrderFlagRecipients.Create(self);
  result := fFlagRecipients;
end;

procedure TfrmOrderFlag.acFlagSetExecute(Sender: TObject);
begin
  inherited;
  if assigned(FlagInfo) then
    ActionResult := FlagInfo.FlagInfoSave
  else
    ActionResult := '1^OrderFlag object is not assigned';
  ReportActionResult;
end;

procedure TfrmOrderFlag.acRecipientAddExecute(Sender: TObject);
begin
  inherited;
  // Add recipient and disable the add button.
  // Will re-enable when a new person is selected
  RecipientAdd;
  SetButtonStatus;
  if ScreenReaderActive then
    GetScreenReader.Speak('Recipient added');
end;

procedure TfrmOrderFlag.acRecipientRemoveAllExecute(Sender: TObject);
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

procedure TfrmOrderFlag.acRecipientRemoveExecute(Sender: TObject);
begin
  inherited;
  // Remove the selected recipient and disable the remove button.
  // Will re-enable when a new recipient is selected
  RecipientRemove;
  SetButtonStatus;
  if ScreenReaderActive then
    GetScreenReader.Speak('Recipient removed');
end;

procedure TfrmOrderFlag.acRecipientSelectExecute(Sender: TObject);
begin
  inherited;
  FlagRecipients.getRecipientsList(FlagInfo.Recipients, FlagInfo.RecipientsNew);
  pnlRecipientsAdd.Visible := FlagInfo.RecipientsNew.Count > 0;
  orRecipientsAdd.Items.Assign(FlagInfo.RecipientsNew);
end;

procedure TfrmOrderFlag.RecipientRemove;
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
        if Assigned(FlagInfo) then
          FlagInfo.deleteRecepient(Items[i]);
        Items.Delete(i);
      end;
  end;
end;

procedure TfrmOrderFlag.cboAlertRecipientChange(Sender: TObject);
begin
  inherited;
  // Changing potential recipients so check if we can add
  setButtonStatus;
end;


procedure TfrmOrderFlag.cboAlertRecipientDblClick(Sender: TObject);
begin
  inherited;
  acRecipientAdd.Execute;
end;

procedure TfrmOrderFlag.cboAlertRecipientEnter(Sender: TObject);
begin
  inherited;
  // Ensure that there is no recipient selection
  orSelectedRecipients.ClearSelection;
  SetButtonStatus;
end;

procedure TfrmOrderFlag.cboAlertRecipientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  // If enter is pressed then try to add to the recipients
  if Key = VK_RETURN then
    cboAlertRecipientDblClick(Sender);
end;

procedure TfrmOrderFlag.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  // Get the list of potential recipients
  if Sender = cboAlertRecipient then
    setPersonList(cboAlertRecipient, StartFrom, Direction)
  else
    setPersonList(Sender as TORComboBox, StartFrom, Direction); // RTC Defect 732085
end;

procedure TfrmOrderFlag.cboFlagReasonChange(Sender: TObject);
const
  InputLimit: Integer = 80; // Original value assigned to the Field.MaxLength
begin
  inherited;
  if Assigned(FlagInfo) then
    FlagInfo.Reason := cboFlagReason.Text;
  reportStatus;
end;

procedure TfrmOrderFlag.cbReasonRequiredClick(Sender: TObject);
begin
  if bIgnore then
    exit;
  inherited;
  if Assigned(FlagInfo) then
    FlagInfo.bRequiredReason := cbReasonRequired.Checked;

  reportStatus;
  lblReason.Caption := getRequiredCaption(lblReason.Caption,
    cbReasonRequired.Checked);
end;

procedure TfrmOrderFlag.cbNoActionRequiredClick(Sender: TObject);
begin
  if bIgnore then
    exit;
  inherited;
  if Assigned(FlagInfo) then
    FlagInfo.bRequiredExpires := cbNoActionRequired.Checked;
  reportStatus;
  lblNoActionAlert.Caption := getRequiredCaption(lblNoActionAlert.Caption,
    cbNoActionRequired.Checked);
  if cbNoActionRequired.Checked then cbCreateNoActionAlert.Checked := True;
  cbCreateNoActionAlert.Enabled := not cbNoActionRequired.Checked;
end;

procedure TfrmOrderFlag.cbRecipientsRequiredClick(Sender: TObject);
begin
  if bIgnore then
    exit;
  inherited;
  if Assigned(FlagInfo) then
    FlagInfo.bRequiredRecipients := cbRecipientsRequired.Checked;
  reportStatus;
  lblRecipients.Caption := getRequiredCaption(lblRecipients.Caption,
    cbRecipientsRequired.Checked);
end;

procedure TfrmOrderFlag.cbRequiredCommentClick(Sender: TObject);
begin
  if bIgnore then
    exit;
  inherited;
  bIgnore := True;
  if Assigned(FlagInfo) then
    FlagInfo.bRequiredComment := cbRequiredComment.Checked;
  reportStatus;
  lblComment.Caption := getRequiredCaption(lblComment.Caption,
    cbRequiredComment.Checked);
  bIgnore := False;
end;

procedure TfrmOrderFlag.cbCreateNoActionAlertClick(Sender: TObject);
begin
  inherited;
  dtFlagExpire.Enabled := cbCreateNoActionAlert.Checked;
end;

procedure TfrmOrderFlag.setButtonStatus;
begin
   // Something selected and not already in the recipient list
  acRecipientAdd.Enabled := (cboAlertRecipient.ItemIndex > -1) and
    (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) < 0);

  // recipient(s) selected
  acRecipientRemove.Enabled := (orSelectedRecipients.SelCount > 0);

  // Has recipients
  acRecipientRemoveAll.Enabled := orSelectedRecipients.Items.Count > 0;
end;

procedure TfrmOrderFlag.setFlagInfo(anInfo: TOrderFlag);
begin
  fFlagInfo := anInfo;
  bIgnore := True;

  mmOrder.Text := fFlagInfo.Details;
  mmOrder.Hint := getHint(mmOrder.Lines);

  cboFlagReason.Text := fFlagInfo.Reason;
  dtFlagExpire.FMDateTime := DateTimeToFMDateTime(fFlagInfo.Expires);

  //  setFlagRecipients(anInfo);

  fFlagInfo.bRequiredReason := cbReasonRequired.Checked;
  fFlagInfo.bRequiredRecipients := cbRecipientsRequired.Checked;
  fFlagInfo.bRequiredExpires := cbNoActionRequired.Checked;
  fFlagInfo.bRequiredComment := cbRequiredComment.Checked;

  fFlagInfo.ExpiresMin := dtFlagExpire.DateRange.MinDate;

  bIgnore := False;
end;

procedure TfrmOrderFlag.reportStatus;
var
  iStatus: Integer;
begin
  setButtonStatus;

  if not Assigned(MasterForm) then
    exit;

  if Assigned(FlagInfo) then
    iStatus := FlagInfo.OFStatus
  else
    iStatus := -1;

  SendMessage(MasterForm.Handle, UM_ORDFLAGSTATUS, iStatus, 0);
end;

procedure TfrmOrderFlag.reportActionResult;
var
  iStatus: Integer;
begin
  setButtonStatus;
  if not Assigned(MasterForm) then
    exit;

  if Assigned(FlagInfo) then
    iStatus := FlagInfo.OFSetStatus
  else
    iStatus := -1;
  SendMessage(MasterForm.Handle, UM_ORDFLAGACTION, iStatus, 0);
end;

procedure TfrmOrderFlag.setViewMode(aMode: TViewMode);
// sets visibility of the dialog components based on the expected usage of teh window.

  procedure adjustActionPanelHeight(aPanel: TPanel; anAction: TAction = nil);
  var
    iHeight: Integer;
  begin
    if anAction = nil then
      iHeight := self.Canvas.TextHeight('TEXT')
    else
      iHeight := self.Canvas.TextHeight(anAction.Caption);

    iHeight := iHeight + iGapHeader * 2;
    if iHeight < btnMinHeight then
      iHeight := btnMinHeight;
    aPanel.Height := iHeight + igButtonTop * 2;
  end;

begin
  fViewMode := aMode;
  case aMode of
    vmParentedForm:
      begin
        pnlInstructions.Visible := False;
        pnlCanvas.BevelOuter := bvNone;
        pnlBottom.Visible := False;
      end;
    vmDialog:
      begin
        pnlInstructions.Visible := False;
        pnlCanvas.BevelOuter := bvRaised;
        pnlBottom.Visible := True;
      end;
    vmConfirmationDlg:
      begin
        pnlInstructions.Visible := True;
        pnlBottom.Visible := True;
        pnlNoActionAlert.Visible := False;
        pnlComment.Visible := False;
        pnlReason.Visible := False;
        pnlRecipients.Visible := True;
        splDetails.Visible := False;
        pnlDescription.Align := alClient;
        Height := 360;
        mmOrder.Top := 1;
        mmOrder.Height := pnlDescription.Height - 2;
        adjustActionPanelHeight(pnlBottom);
        cmdOK.Top := igButtonTop;
        cmdCancel.Top := igButtonTop;
      end;
  end;
end;

procedure TfrmOrderFlag.setRequiredByActionMode(aMode:TActionMode);
begin
  cbRequiredComment.Checked := (aMode = amRemove);
  cbReasonRequired.Checked := (aMode = amAdd);
  cbNoActionRequired.Checked := False;
  cbRecipientsRequired.Checked := False;
end;

procedure TfrmOrderFlag.setActionMode(aMode: TActionMode);
// sets visibility of the dialog components based on the expected action
  procedure AlignToBottom(aFirst,aSecond:TControl);
  begin
    aSecond.Align := alTop;
    aSecond.Top := aFirst.Top + aFirst.Height;
    TResponsiveGUI.ProcessMessages;
  end;

begin
  fActionMode := aMode;
  pnlReason.Visible := (aMode = amAdd);
  pnlRecipients.Visible := (aMode = amAdd);
  pnlNoActionAlert.Visible := (aMode = amAdd);
  pnlComment.Visible := (aMode = amEdit) or (aMode = amRemove);

  if aMode = amAdd then
    lblRecipients.Caption := 'Flag &Notification Recipients'
  else
    lblRecipients.Caption := 'Additional Flag &Notification Recipients';

  setRequiredByActionMode(aMode);

  if (aMode = amRemove) or (aMode = amEdit) then
  begin
    pnlDescription.Align := alClient;
    cbRequiredComment.Checked := True;
    memComment.Visible := aMode = amEdit;
    txtComment.Visible := aMode = amRemove;
    if aMode = amEdit then
      pnlComment.Height := pnlCanvas.Height div 3;
    if aMode = amRemove then
      pnlComment.Height := pnlReason.Height;

    TResponsiveGUI.ProcessMessages;
    splDetails.Align := alBottom;
    splDetails.Top := pnlDescription.Top + pnlDescription.Height;
  end
  else
  begin
    pnlDescription.Align := alTop;
    pnlDescription.Height := pnlCanvas.Height div 4;
    AlignToBottom(pnlDescription,splDetails);
    AlignToBottom(splDetails,pnlReason);
    pnlRecipients.Align := alClient;
  end;
end;

procedure TfrmOrderFlag.txtCommentChange(Sender: TObject);
begin
  inherited;
  if bIgnore then
    exit;

  if Assigned(FlagInfo) then
  begin
    FlagInfo.FlagComments.Text := txtComment.Text;
  end;
  reportStatus;
end;

procedure TfrmOrderFlag.memCommentChange(Sender: TObject);
var
  bIgnoreOld:Boolean;
begin
  if bIgnore then
    exit;
  bIgnoreOld := bIgnore;
  bIgnore := True;
  LimitEditWidth(memComment, 74);
  if Assigned(FlagInfo) then
    FlagInfo.FlagComments.Text := memComment.Text;

  reportStatus;

  bIgnore := bIgnoreOld;
end;

procedure TfrmOrderFlag.mmOrderEnter(Sender: TObject);
begin
  inherited;
  if ScreenReaderActive then
    GetScreenReader.Speak(lblOrderDetails.Caption);
end;

procedure TfrmOrderFlag.sbDebugClick(Sender: TObject);
begin
  inherited;
  setDebugView(not cbRecipientsRequired.Visible);
end;

procedure TfrmOrderFlag.RecipientAdd;
var
  s, aErrMsg: String;

  function IsSelected(anID:String):Boolean;
  var
    ss: String;
    i: Integer;
  begin
    Result := False;
    // do not check the recipient list when adding the new flag
    if ActionMode = amAdd then
      exit;
    with FlagInfo do
    for i := 0 to Recipients.Count - 1 do
      begin
        ss := Recipients[i];
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
    exit
  else
    begin
       // checking duplicate names  request ##133 Issue Tracker
      if not CheckForSimilarName(cboAlertRecipient, aErrMsg, sPr, orSelectedRecipients.Items) then
      begin
        ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection');
        exit;
      end;

      s := cboAlertRecipient.Items[cboAlertRecipient.ItemIndex];
      orSelectedRecipients.Items.Add(s);
      if Assigned(FlagInfo) then
        FlagInfo.Recipients.Add(s);
      orSelectedRecipients.ItemIndex := orSelectedRecipients.Items.Count - 1;

      reportStatus;
    end;
end;

procedure TfrmOrderFlag.setGUIByObject(anObject: TObject);
begin
  mmOrder.Clear;
  if Assigned(anObject) and (anObject is TOrderFlag) then
  begin
    FlagInfo := TOrderFlag(anObject);
    mmOrder.Text := FlagInfo.Details;
    mmOrder.Hint := getHint(mmOrder.Lines);
    memComment.Text := FlagInfo.FlagComments.Text;

    lblOrderDetails.Caption := 'Order Details';

    if FlagInfo.Expires = 0.0 then
      FlagInfo.Expires := getOrderFlagExpireDefault;// 20180222

    dtFlagExpire.FMDateTime := DateTimeToFMDateTime(fFlagInfo.Expires);

    FlagInfo.bRequiredReason := cbReasonRequired.Checked; // (ActionMode = amAdd);
    FlagInfo.bRequiredRecipients := cbRecipientsRequired.Checked; /// False;
    FlagInfo.bRequiredExpires := cbNoActionRequired.Checked; // False;
    FlagInfo.bRequiredComment := cbRequiredComment.Checked; //(ActionMode = amRemove);
  end
  else
    setProcessedMode(False);
end;

procedure TfrmOrderFlag.setGUIByMultipleObjects(aList:TObject);

  function getSelectedItemsInfo(lvItems:TListView): String;
  var
    i,j: Integer;
  begin
    Result := '';
    j := 0;
    for i := 0 to lvItems.Items.Count - 1 do
      if lvItems.Items[i].Selected then
        begin
          inc(j);
          Result := Result + IntToStr(j) +
            ' ------------------------------------------------------'+
            CRLF+
            TOrderFlag(lvItems.Items[i].SubItems.Objects[0])
            .Details + CRLF + CRLF;
        end;
  end;

  function getSelectedItemsCaption(lvItems:TListView): String;
  begin
    Result := Format('Details of %d selected Order(s). ', [lvItems.SelCount]);
  end;

begin
  mmOrder.Text := getSelectedItemsInfo(TListView(aList));
  mmOrder.Hint := getHint(mmOrder.Lines);
  lblOrderDetails.Caption := getSelectedItemsCaption(TListView(aList));
end;

procedure TfrmOrderFlag.setProcessedMode(aProcessed: Boolean);
begin
  if aProcessed then
    Font.Color := clGrayText
  else
    Font.Color := clWindowText;
end;

function TfrmOrderFlag.IsCommentValid:Boolean;
begin
  // memComment is used for adding comments only
  if ActionMode = amEdit then
    Result := Length(Trim(memComment.Text)) >= 4
  else
    Result := Length(Trim(txtComment.Text)) >= 4;
end;

function TfrmOrderFlag.IsValid(aTag: Integer): Boolean;
begin
  case aTag of
    prpReason:
      Result := not cbReasonRequired.Checked or (Length(trim(cboFlagReason.Text)) >=4);
    prpComment:
      Result := not cbRequiredComment.Checked or IsCommentValid;
      // RSD 2.6.24.1.1.5
    prpRecipients:
      Result := not cbRecipientsRequired.Checked or
        (cboAlertRecipient.Items.Count > 0);
    prpNoAction:
      Result := not cbNoActionRequired.Checked or (dtFlagExpire.Text <> '');
  else
    Result := False;
  end;
end;

function TfrmOrderFlag.IsValidArray(anArray: Array of Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := Low(anArray) to High(anArray) do
    Result := Result and IsValid(anArray[i]);
end;

procedure TfrmOrderFlag.setDebugView(aValue: Boolean);
begin
  cbRecipientsRequired.Visible := aValue;
  cbNoActionRequired.Visible := aValue;
  cbReasonRequired.Visible := aValue;
  cbRequiredComment.Visible := aValue;
end;

procedure TfrmOrderFlag.ResizeToFont(aSize: Integer);
var
  iHeight: Integer;

  procedure adjustPanelWidth(aPanel: TPanel; aCaption: string);
  var
    iWidth: Integer;
  begin
    iWidth := Self.Canvas.TextWidth(aCaption) + 2 * btnLeftMargin + 2 * iGap;
    if iWidth < btnMinWidth then
      iWidth := btnMinWidth;

    aPanel.Width := iWidth + igButtonLeft * 2;
  end;

  procedure adjustGBPanelHeight(aPanel:TPanel; aCount: Integer = 1);
  var
    i: Integer;
  begin
    i := 1 + aCount;
    if i < 2 then
      i := 2;
    aPanel.Height := iHeight + i * txtComment.Height - 8;
    if aPanel.Height < 64 then
      aPanel.Height := 64;
  end;

  procedure AdjustCommentHeight;
  begin
    if ActionMode = amEdit then
      begin
        // No adjustment needed as the TMemo field aligned to all available space
      end
    else
      begin
        // adding or removing flag uses TEdit field that requiers adjustment
        adjustGBPanelHeight(pnlComment);
      end;
  end;

begin
  if (not(fsShowing in FormState)) and (not IsWindowVisible(Handle)) then
  begin
    // Delay the actual resizing to the OnShow event. This will make sure that
    // any autosizing of components happens correctly (in this case the
    // alTop aligned buttons on pnlListButtons.
    FNeedsToResizeToFontSize := aSize;
  end else begin
    FNeedsToResizeToFontSize := -1;
    if (8 <= aSize) and (aSize <=18) then
    begin
      Self.Font.Size := aSize;
      iHeight := self.Canvas.TextHeight('THIS IS THE TEXT');
      cmdOK.Height := iHeight + iGap;
      cmdOK.Top := igButtonTop;
      cmdCancel.Height := cmdOK.Height;
      cmdCancel.Top := igButtonTop;

      btnAddRecipient.Height := cmdOK.Height;
      btnRemoveRecipients.Height := cmdOK.Height;
      btnRemoveAllRecipients.Height := cmdOK.Height;

      adjustGBPanelHeight(pnlReason);
      adjustGBPanelHeight(pnlNoActionAlert, 2);
      adjustCommentHeight;
      adjustGBPanelHeight(pnlInstructions, mmInstructions.Lines.Count);

      btnRemoveRecipients.Top := btnAddRecipient.Top + btnAddRecipient.Height + iGapTail;
      btnRemoveAllRecipients.Top := btnRemoveRecipients.Top + btnRemoveRecipients.Height + iGapTail;
      sbDebug.Top := btnRemoveAllRecipients.Top + btnRemoveAllRecipients.Height + iGapTail;
      sbDebug.Height := cmdOK.Height;

      pnlBottom.Height := cmdOK.Height + iGapHeader + iGapHeader;

      adjustPanelWidth(pnlListButtons, 'Remove All');
      pnlRecipientsListResize(nil);
    end;
  end;
end;

function TfrmOrderFlag.getVisibleFieldNames:String;

  function getCompleteSections(aSection: tPanel; aCaption: String; aDelim: String = CRLF;
    aPrefix: String = '    '): String;
  var
    s, ReqPrefix: String;

    function getCommentText:String;
    begin
      if ActionMode = amEdit then
        Result := memComment.Text
      else
        Result := txtComment.Text
    end;

  begin
    if aSection.Parent.Visible then
    begin
      if ((aSection = pnlReason) and (Trim(cboFlagReason.Text) <> '')) or
        ((aSection = pnlComment) and IsCommentValid) or
        ((aSection = pnlNoActionAlert) and (Trim(dtFlagExpire.Text) <> '')) or
        ((aSection = pnlRecipients) and (orSelectedRecipients.Items.Count > 0))
      then
      begin
        s := aCaption;

        if ScreenReaderActive then
          ReqPrefix := a508PrefixRequired
        else
          ReqPrefix := PrefixRequired;

        if pos(ReqPrefix, s) = 1 then
        begin
          if ScreenReaderActive then
            s := Trim(copy(s, 1, Length(ReqPrefix) - 1))
          else
            s := Trim(copy(s, Length(ReqPrefix) + 1, Length(s)));
        end;
        s := StringReplace(s, '&', '', [rfReplaceAll, rfIgnoreCase]);
        Result := aPrefix + s + aDelim;

        if aSection = pnlReason then
          Result := Result + char(VK_Tab) + cboFlagReason.Text + aDelim
        else if aSection = pnlCommentSub then
          Result := Result + char(VK_Tab) + getCommentText +  aDelim
        else if aSection = pnlNoActionAlert then
          Result := Result + char(VK_Tab) + dtFlagExpire.Text + aDelim
        else if aSection = pnlRecipients then
          begin
            for s in orSelectedRecipients.Items
              do Result := Result + char(VK_Tab) + Piece(s, '^', 2) + Piece(s, '^', 3) + aDelim;
          end;
      end;
    end
      else Result := '';
  end;

begin
  { TODO 4 -ochris bell : update based on panels }
  Result := '';
  Result := Result + getCompleteSections(pnlReason, lblReason.Caption);
  Result := Result + getCompleteSections(pnlRecipients, lblRecipients.Caption);
  Result := Result + getCompleteSections(pnlNoActionAlert, lblNoActionAlert.Caption);
  Result := Result + getCompleteSections(pnlComment, lblComment.Caption);
end;

procedure TfrmOrderFlag.setOrdersCount(aValue: Integer);
begin
  fOrdersCount := aValue;
  lblOrderDetails.Caption := 'Details - '+ IntToStr(aValue)+ ' Order(s)';
end;



///////////////// TORDateBox /////////////////

procedure TORDateBox.Resize;
begin
  inherited;
  if Assigned(f508Label) then
  begin
    f508Label.width := Self.width + 5;
    f508Label.height := Self.height + 5;
  end;
end;

procedure TORDateBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if not IsScreenReaderActive then
    exit;
  if not self.Enabled then
  begin
    f508Label := TVA508StaticText.Create(self);
    f508Label.Parent := self.Parent;
    f508Label.SendToBack;
    // self.SendToBack;
    f508Label.TabStop := true;
    f508Label.TabOrder := self.TabOrder;
    f508Label.Name := 'lbl'+self.name;
    if self.name = 'dtFlagExpire' then
      f508Label.Caption := 'No Action Alert Flag Expiration Date date box disabled'
    else
      f508Label.Caption := ' ' + self.Caption + ' date box disabled';
    f508Label.Top := self.Top - 2;
    f508Label.Left := self.Left - 2;
    f508Label.Width := self.Width + 5;
    f508Label.Height := self.Height + 5;
    RegisterWithMGR;
  end
  else
  begin
    FreeAndNil(f508Label);
  end;
end;

constructor TORDateBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fMgr := nil;
end;

function TORDateBox.GetIsScreenReaderActive: Boolean;
begin
  Result := ScreenReaderActive;
end;

procedure TORDateBox.RegisterWithMGR;
var
  aFrm: TCustomForm;
  I: Integer;
begin
  if not assigned(fMgr) then
  begin
    aFrm := GetParentForm(self);
    if not assigned(aFrm) then
      raise Exception.Create('Procedure: RegisterWithMGR - Unable to find parent form for ' + self.Name);
    for I := 0 to aFrm.ComponentCount - 1 do
    begin
      if aFrm.Components[I] is TVA508AccessibilityManager then
      begin
        fMgr := TVA508AccessibilityManager(aFrm.Components[I]);
        break;
      end;
    end;
  end;
  if assigned(fMgr) then
    fMgr.AccessData.EnsureItemExists(f508Label)
  else
    raise Exception.Create('Procedure: RegisterWithMGR - Unable to find Manager for ' + self.Name);
end;

///////////////// TCheckBox /////////////////

procedure TCheckBox.Resize;
begin
  inherited;
  if Assigned(f508Label) then
  begin
    f508Label.width := Self.width + 5;
    f508Label.height := Self.height + 5;
  end;
end;

procedure TCheckBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if not IsScreenReaderActive then
    exit;
  if not self.Enabled then
  begin
    f508Label := TVA508StaticText.Create(self);
    f508Label.Parent := self.Parent;
    f508Label.SendToBack;
    // self.SendToBack;
    f508Label.TabStop := true;
    f508Label.TabOrder := self.TabOrder;
    f508Label.Name := 'lbl'+self.name;
    f508Label.Caption := ' ' + self.Caption + ' check box disabled';
    f508Label.Top := self.Top - 2;
    f508Label.Left := self.Left - 2;
    f508Label.Width := self.Width + 5;
    f508Label.Height := self.Height + 5;
    RegisterWithMGR;
  end
  else
  begin
    FreeAndNil(f508Label);
  end;
end;

constructor TCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fMgr := nil;
end;

function TCheckBox.GetIsScreenReaderActive: Boolean;
begin
  Result := ScreenReaderActive;
end;

procedure TCheckBox.RegisterWithMGR;
var
  aFrm: TCustomForm;
  I: Integer;
begin
  if not assigned(fMgr) then
  begin
    aFrm := GetParentForm(self);
    if not assigned(aFrm) then
      raise Exception.Create('Procedure: RegisterWithMGR - Unable to find parent form for ' + self.Name);
    for I := 0 to aFrm.ComponentCount - 1 do
    begin
      if aFrm.Components[I] is TVA508AccessibilityManager then
      begin
        fMgr := TVA508AccessibilityManager(aFrm.Components[I]);
        break;
      end;
    end;
  end;
  if assigned(fMgr) then
    fMgr.AccessData.EnsureItemExists(f508Label)
  else
    raise Exception.Create('Procedure: RegisterWithMGR - Unable to find Manager for ' + self.Name);
end;

end.
