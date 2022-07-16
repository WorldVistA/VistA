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
  System.Actions, System.UITypes;

type
  TfrmOrderFlag = class(TfrmBase508Form, IOrderFlagPropertiesEditor, IResizableForm)
    cmdOK: TButton;
    cmdCancel: TButton;
    mmOrder: TMemo;
    cboFlagReason: TORComboBox;
    cboAlertRecipient: TORComboBox;
    orSelectedRecipients: TORListBox;
    dtFlagExpire: TORDateBox;
    btnRemoveAllRecipients: TButton;
    btnAddRecipient: TButton;
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
    grbInstructions: TGroupBox;
    grbComment: TGroupBox;
    grbNoActionAlert: TGroupBox;
    grbReason: TGroupBox;
    grbOrderDetails: TGroupBox;
    grbRecipients: TGroupBox;
    cbRecipientsRequired: TCheckBox;
    alEditorActions: TActionList;
    acFlagRemove: TAction;
    acFlagComment: TAction;
    acFlagSet: TAction;
    acRecipientAdd: TAction;
    acRecipientRemoveAll: TAction;
    acRecipientSelect: TAction;
    memComment: TMemo;
    btnRemoveRecipients: TButton;
    acRecipientRemove: TAction;
    orRecipientsAdd: TORListBox;
    grbRecipientsAdd: TGroupBox;
    cbCreateNoActionAlert: TCheckBox;
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
    procedure mmOrderChange(Sender: TObject);
    procedure orSelectedRecipientsChange(Sender: TObject);
    procedure cboAlertRecipientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orSelectedRecipientsClick(Sender: TObject);
    procedure acRecipientAddExecute(Sender: TObject);
    procedure acRecipientRemoveExecute(Sender: TObject);
    procedure acRecipientRemoveAllExecute(Sender: TObject);
    procedure cboAlertRecipientEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboAlertRecipientClick(Sender: TObject);
    procedure orSelectedRecipientsEnter(Sender: TObject);
    procedure orSelectedRecipientsExit(Sender: TObject);
    procedure cboAlertRecipientExit(Sender: TObject);
    procedure acRecipientSelectExecute(Sender: TObject);
    procedure memCommentChange(Sender: TObject);
    procedure orRecipientsAddChange(Sender: TObject);
    procedure orRecipientsAddKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orRecipientsAddDblClick(Sender: TObject);
    procedure cbCreateNoActionAlertClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FNeedsToResizeToFontSize: Integer;
    fDebug: Boolean;
    bIgnore: Boolean;
    fFlagInfo: TOrderFlag;
    fViewMode: TViewMode;
    fActionMode: TActionMode;
    fOrdersCount: Integer;
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
  protected
    // procedure Loaded;override;
  public
    ActionResult: String;
    MasterForm: TForm;
    property ViewMode: TViewMode read fViewMode write setViewMode;
    property ActionMode: TActionMode read fActionMode write setActionMode;
    property FlagInfo: TOrderFlag read fFlagInfo write setFlagInfo;
    property OrdersCount: Integer read fOrdersCount write setOrdersCount;

    constructor createParented(aParentForm: TForm; aParentControl: TWinControl);
    function IsValid(aTag: Integer): Boolean;
    function IsCommentValid:Boolean;
    procedure ResizeToFont(aSize:Integer);

    procedure setGUIByMultipleObjects(aList:TObject);
    procedure setGUIByObject(anObject: TObject);
    function IsValidArray(anArray: Array of Integer): Boolean;

    function getVisibleFieldNames:String;
{$IFDEF DEBUG_AA}
    procedure setDebugView(aValue: Boolean);
{$ENDIF}
    function CheckFlag: boolean;
  end;

const
  prpReason = 1;
  prpComment = 2;
  prpRecipients = 3;
  prpNoAction = 4;

  PrefixRequired = '* ';

  iGap = 8;
  iGapHeader = 4;
  iGapTail = 2;

  igButtonTop = 4;
  igButtonLeft = 8;

  btnMinWidth = 75;
  btnMinHeight = 21;
  btnLeftMargin = 4;

  OrderFlagCommentsLimit = 240; // comments should not exceed 240 chars RSD 2.6.24.1.1.5

implementation

{$R *.DFM}

uses uCore, rCore, uSimilarNames, fOrderFlagNotificationRecipients;

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
begin
  if aRequired then
  begin
    if pos(PrefixRequired, aCaption) <> 1 then
      Result := PrefixRequired + aCaption
    else
      Result := aCaption;
  end
  else if pos(PrefixRequired, aCaption) = 1 then
    Result := copy(aCaption, Length(PrefixRequired) + 1, Length(aCaption))
  else
    Result := aCaption
end;

const
  TX_REASON_REQ = 'A reason must be entered to flag an order.';
  TC_REASON_REQ = 'Reason Required';
(*
function FlagOrderConfirmation(aCaption,anAction, anInfo: String): Integer;
var
  frmFlagOrder: TfrmOrderFlag;
begin
  frmFlagOrder := TfrmOrderFlag.Create(Application);
  try
    frmFlagOrder.Caption := aCaption;
    frmFlagOrder.ViewMode := vmConfirmationDlg;
    frmFlagOrder.mmOrder.Text := anInfo;
    frmFlagOrder.mmOrder.Hint := getHint(frmFlagOrder.mmOrder.Lines);
    frmFlagOrder.mmInstructions.Text :=
      'The following orders are not eligible for action "' + anAction +'"'+ CRLF +
      'They will be removed from selection' + CRLF +
      'Click "OK" to continue or "Cancel" to return to the order list';
//    ResizeFormToFont(TForm(frmFlagOrder));
    frmFlagOrder.ResizeToFont(Application.MainForm.Font.Size);
    Result := frmFlagOrder.ShowModal;
  finally
    frmFlagOrder.Release;
  end;
end;

function ExecuteFlagOrder(AnOrder: TOrder): Boolean;
var
  frmFlagOrder: TfrmOrderFlag;
begin
  Result := False;

  frmFlagOrder := TfrmOrderFlag.Create(Application);

  try
    ResizeFormToFont(TForm(frmFlagOrder));
    // AlertRecip := User.DUZ;
    with frmFlagOrder do
    begin
      mmOrder.SetTextBuf(PChar(AnOrder.Text));
      if ShowModal = mrOK then
      begin
        // FlagOrder(AnOrder, cboFlagReason.Text, AlertRecip);
        FlagOrder(AnOrder, cboFlagReason.Text, orSelectedRecipients.Items,
          dtFlagExpire.Text);
        Result := True;
      end;
    end;
  finally
    frmFlagOrder.Release;
  end;
end;
*)
/// /////////////////////////////////////////////////////////////////////////////

constructor TfrmOrderFlag.createParented(aParentForm: TForm;
  aParentControl: TWinControl);
begin
  inherited Create(aParentForm);
  MasterForm := aParentForm;
  ViewMode := vmParentedForm;
  setFormParented(self, aParentControl);
{$IFDEF DEBUG_AA}
{$ELSE}
  sbDebug.Visible := fDebug;
{$ENDIF}
  cbReasonRequired.Visible := fDebug;
  cbNoActionRequired.Visible := fDebug;
  cbRecipientsRequired.Visible := fDebug;
  grbReason.Caption := getRequiredCaption(grbReason.Caption,
    cbReasonRequired.Checked);
  grbNoActionAlert.Caption := getRequiredCaption(grbNoActionAlert.Caption,
    cbNoActionRequired.Checked);
  grbRecipients.Caption := getRequiredCaption(grbRecipients.Caption,
    cbRecipientsRequired.Checked);
  grbComment.Caption := getRequiredCaption(grbComment.Caption,
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

procedure TfrmOrderFlag.orSelectedRecipientsChange(Sender: TObject);
begin
  inherited;
  reportStatus;
end;

procedure TfrmOrderFlag.orSelectedRecipientsClick(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlag.orSelectedRecipientsDblClick(Sender: TObject);
begin
  inherited;
  RecipientRemove;
end;

procedure TfrmOrderFlag.orSelectedRecipientsEnter(Sender: TObject);
begin
  inherited;
  SetButtonStatus;
end;

procedure TfrmOrderFlag.orSelectedRecipientsExit(Sender: TObject);
begin
  inherited;
  SetButtonStatus;
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
  begin
    Result := False;
    case ViewMode of
      vmParentedForm:
        ;
      vmDialog:
        if Assigned(FlagInfo) then
          Result := FlagInfo.IsValid; // OFStatus = stOFValid;
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
//  AutoSizeDisabled := True;
  tmpList := TStringList.Create;
  try
    GetUserListParam(tmpList, 'OR FLAGGED ORD REASONS');
    tmpList.Insert(0, '');
    FastAssign(tmpList, cboFlagReason.Items);
  finally
    tmpList.Free;
  end;
  cboAlertRecipient.InitLongList('');
  dtFlagExpire.DateSelected := getOrderFlagExpireDefault; //Now;
  dtFlagExpire.FMDateTime := DateTimeToFMDateTime(dtFlagExpire.DateSelected);
  dtFlagExpire.DateRange.MinDate := FMDateTimeToDateTime(FMNow);

  NotificationRecipientsCleanUp;
end;

procedure TfrmOrderFlag.FormShow(Sender: TObject);
begin
  inherited;
  if FNeedsToResizeToFontSize >= 0 then ResizeToFont(FNeedsToResizeToFontSize);
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
  RecipientAdd;
end;

procedure TfrmOrderFlag.acRecipientRemoveAllExecute(Sender: TObject);
begin
  inherited;
  orSelectedRecipients.SelectAll;
  RecipientRemove;
end;

procedure TfrmOrderFlag.acRecipientRemoveExecute(Sender: TObject);
begin
  inherited;
  RecipientRemove;
end;

procedure TfrmOrderFlag.acRecipientSelectExecute(Sender: TObject);
var
  SS: TStrings;
begin
  inherited;
  SS := getRecipientsList(FlagInfo.Recipients);
  if SS <> nil then
    begin
{$IFDEF DEBUG}
      if SS.Count > 0 then
        ShowMessage(SS.Text);
{$ENDIF}
      FlagInfo.RecipientsNew.Assign(SS);

      grbRecipientsAdd.Visible := SS.Count > 0;
      orRecipientsAdd.Items.Assign(SS);
    end
  else
    grbRecipientsAdd.Visible := orRecipientsAdd.Items.Count > 0;
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
//  reportStatus;
  setButtonStatus;
end;

procedure TfrmOrderFlag.cboAlertRecipientChange(Sender: TObject);
begin
  inherited;
//  reportStatus;
  setButtonStatus;
end;

procedure TfrmOrderFlag.cboAlertRecipientClick(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlag.cboAlertRecipientDblClick(Sender: TObject);
begin
  inherited;
  RecipientAdd;
end;

procedure TfrmOrderFlag.cboAlertRecipientEnter(Sender: TObject);
begin
  inherited;
  SetButtonStatus;
end;

procedure TfrmOrderFlag.cboAlertRecipientExit(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmOrderFlag.cboAlertRecipientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    cboAlertRecipientDblClick(Sender);
end;

procedure TfrmOrderFlag.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  TORComboBox(Sender).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmOrderFlag.cboFlagReasonChange(Sender: TObject);
const
  InputLimit: Integer = 80; // Original value assigned to the Field.MaxLength
begin
  inherited;
(*
  if Length(cboFlagReason.Text) > InputLimit then
    begin
      InfoBox('Sorry, the input can''t exceed '+ IntToStr(inputLimit) +
        ' chars.'+CRLF+
        'The extra characters will be removed'

        ,'Input string too long',MB_OK);
      cboFlagReason.Text := copy(cboFlagReason.Text,1,inputLimit);
    end;
*)
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
  grbReason.Caption := getRequiredCaption(grbReason.Caption,
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
  grbNoActionAlert.Caption := getRequiredCaption(grbNoActionAlert.Caption,
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
  grbRecipients.Caption := getRequiredCaption(grbRecipients.Caption,
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
  grbComment.Caption := getRequiredCaption(grbComment.Caption,
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
  Application.ProcessMessages;

  acRecipientAdd.Enabled := (cboAlertRecipient.ItemIndex > -1) and
    (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) < 0);

  acRecipientRemove.Enabled := (orSelectedRecipients.SelCount > 0) and
    (orSelectedRecipients.Items.Count > 0);
//     and
//    orSelectedRecipients.Focused;

  acRecipientRemoveAll.Enabled := orSelectedRecipients.Items.Count > 0;

  orSelectedRecipients.TabStop := orSelectedRecipients.Items.Count > 0;
end;
{
procedure TfrmOrderFlag.setFlagRecipients;
var
  i: Integer;
begin
  orSelectedRecipients.Items.Clear;
  for i := 0 to fFlagInfo.Recipients.Count - 1 do
    orSelectedRecipients.Items.Add(fFlagInfo.Recipients[i]);
end;
}
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

  procedure adjustActionPanelHeight(aPanel:TPanel;anAction:TAction = nil);
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
    Application.ProcessMessages;
  end;

begin
  fActionMode := aMode;
  pnlReason.Visible := (aMode = amAdd);
  pnlRecipients.Visible := (aMode = amAdd);
  pnlNoActionAlert.Visible := (aMode = amAdd);
  pnlComment.Visible := (aMode = amEdit) or (aMode = amRemove);

  if aMode = amAdd then
    grbRecipients.Caption := 'Flag &Notification Recipients'
  else
    grbRecipients.Caption := 'Additional Flag &Notification Recipients';

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

    Application.ProcessMessages;
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
  inherited;
(**)
  if Assigned(FlagInfo) then
    begin
{
      if Length(txtComment.Text) > OrderFlagCommentsLimit then
        begin
          beep;
          InfoBox('Comment size exceeds '+ IntToStr(OrderFlagCommentsLimit) + ' characters'
            + CRLF + 'The extra text is removed' ,'Error',MB_OK or MB_ICONERROR);
        end;

      FlagInfo.FlagComments := copy(txtComment.Text, 1, OrderFlagCommentsLimit); // RSD 2.6.24.1.1.5
}
      FlagInfo.FlagComments.Text := txtComment.Text;
    end;
(**)
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

procedure TfrmOrderFlag.sbDebugClick(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG_AA}
  setDebugView(not cbRecipientsRequired.Visible);
{$ENDIF}
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
      if not CheckForSimilarName(cboAlertRecipient, aErrMsg, ltPerson, sPr, '', orSelectedRecipients.Items) then
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

    grbOrderDetails.Caption := 'Order Details';

    if FlagInfo.Expires = 0.0 then
//      FlagInfo.Expires := DateTimeToStr(getOrderFlagExpireDefault);
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
  grbOrderDetails.Caption := getSelectedItemsCaption(TListView(aList));
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

procedure TfrmOrderFlag.mmOrderChange(Sender: TObject);
begin
  inherited;
end;

{$IFDEF DEBUG_AA}
procedure TfrmOrderFlag.setDebugView(aValue: Boolean);
begin
  cbRecipientsRequired.Visible := aValue;
  cbNoActionRequired.Visible := aValue;
  cbReasonRequired.Visible := aValue;
  cbRequiredComment.Visible := aValue;
end;
{$ENDIF}

procedure TfrmOrderFlag.ResizeToFont(aSize:Integer);
var
  iHeight: Integer;

  procedure adjustPanelWidth(aPanel:TPanel;aCaption: String);
  var
    iWidth: Integer;
  begin
    iWidth := self.Canvas.TextWidth(aCaption) +
      2 * btnLeftMargin + 2 * iGap;
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

  function getGroupBoxCaption(aGroupBox: TGroupBox; aDelim: String = CRLF;
    aPrefix: String = '    '): String;
  var
    s: String;

    function getCommentText:String;
    begin
      if ActionMode = amEdit then
        Result := memComment.Text
      else
        Result := txtComment.Text
    end;

  begin
    if aGroupBox.Parent.Visible then
    begin
      if ((aGroupBox = grbReason) and (Trim(cboFlagReason.Text) <> '')) or
        ((aGroupBox = grbComment) and IsCommentValid) or
        ((aGroupBox = grbNoActionAlert) and (Trim(dtFlagExpire.Text) <> '')) or
        ((aGroupBox = grbRecipients) and (orSelectedRecipients.Items.Count > 0))
      then
      begin
        s := aGroupBox.Caption;
        if pos(PrefixRequired, s) = 1 then
          s := Trim(copy(s, Length(PrefixRequired) + 1, Length(s)));
        s := StringReplace(s, '&', '', [rfReplaceAll, rfIgnoreCase]);
        Result := aPrefix + s + aDelim;

        if aGroupBox = grbReason then
          Result := Result + char(VK_Tab) + cboFlagReason.Text + aDelim
        else if aGroupBox = grbComment then
          Result := Result + char(VK_Tab) + getCommentText +  aDelim
        else if aGroupBox = grbNoActionAlert then
          Result := Result + char(VK_Tab) + dtFlagExpire.Text + aDelim
        else if aGroupBox = grbRecipients then
          begin
            for s in orSelectedRecipients.Items
              do Result := Result + char(VK_Tab) + Piece(s, '^', 2) + Piece(s, '^', 3) + aDelim;
          end;
      end;
    end
      else Result := '';
  end;

begin
  Result := '';
  Result := Result + getGroupBoxCaption(grbReason);
  Result := Result + getGroupBoxCaption(grbRecipients);
  Result := Result + getGroupBoxCaption(grbNoActionAlert);
  Result := Result + getGroupBoxCaption(grbComment);
end;

procedure TfrmOrderFlag.setOrdersCount(aValue: Integer);
begin
  fOrdersCount := aValue;
  grbOrderDetails.Caption := 'Details - '+ IntToStr(aValue)+ ' Order(s)';
end;

end.
