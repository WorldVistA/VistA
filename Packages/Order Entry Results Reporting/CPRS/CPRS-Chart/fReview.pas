unit fReview;

{ ------------------------------------------------------------------------------
  Update History
  2016-09-20: NSR#20101203 (Critical/Hight Order Check Display)
  2016-07-28: Defect 355810 (Form ignores Main form font size)
  ------------------------------------------------------------------------------- }
interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  Vcl.CheckLst,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Menus,
  Vcl.StdCtrls,
  Winapi.Windows,
  Winapi.Messages,
  fBase508Form,
  fPrintLocation,
  fCSRemaining,
  mCoPayDesc,
  oPKIEncryption,
  ORCtrls,
  ORClasses,
  ORNet,
  rODMeds,
  uConst,
  uCore,
  VA508AccessibilityManager, u508Button;

type
  TfrmReview = class(TfrmBase508Form)
    fraCoPay: TfraCoPayDesc;
    pnlProvInfo: TPanel;
    lblProvInfo: TLabel;
    pnlDEAText: TPanel;
    lblDEAText: TStaticText;
    pnlBottom: TPanel;
    pnlSignature: TPanel;
    lblESCode: TLabel;
    txtESCode: TCaptionEdit;
    pnlOrderAction: TPanel;
    lblOrderPrompt: TStaticText;
    lblHoldSign: TStaticText;
    radSignChart: TRadioButton;
    radHoldSign: TRadioButton;
    radVerbal: TRadioButton;
    radPhone: TRadioButton;
    radPolicy: TRadioButton;
    radRelease: TRadioButton;
    cmdOK: u508Button.TButton;
    cmdCancel: u508Button.TButton;
    pnlReview: TPanel;
    lstReview: TCaptionCheckListBox;
    lblSig: TStaticText;
    pnlCSReview: TPanel;
    lblCSReview: TLabel;
    lstCSReview: TCaptionCheckListBox;
    lblSmartCardNeeded: TStaticText;
    pnlTop: TPanel;
    pnlBottomCanvas: TPanel;
    pnlCSTop: TPanel;
    gpMain: TGridPanel;
    gpBottom: TGridPanel;
    gpOrderActions: TGridPanel;
    gpRelease: TGridPanel;
    lblGap: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure lstReviewDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstReviewMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure lstReviewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure lstReviewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstReviewClickCheck(Sender: TObject);

    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);

    procedure radReleaseClick(Sender: TObject);

    procedure txtESCodeChange(Sender: TObject);
    procedure fraCoPayLabel24MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure pnlCSReviewResize(Sender: TObject);
  private const
    DontSign = 'Don''t Sign';
  private
    FOKPressed: Boolean;
    FShowPanel: Integer;
    FSilent: Boolean;
    FCouldSign: Boolean;
    FLastHintItem: Integer;
    FOldHintPause: Integer;
    FOldHintHidePause: Integer;
    FIsEvtChange: Boolean;
    FCurrentlySelectedItem: Integer;
    FFormID: string;
    function AddItem(aCaptionCheckListBox: TCaptionCheckListBox;
      ChangeItem: TChangeItem): Integer;
    function ItemsAreChecked(aListView: TCaptionCheckListBox): Boolean;
    function nonDCCSItemsAreChecked: Boolean;
    function AnyItemsAreChecked: Boolean;
    function SignRequiredForAny(FullList: Boolean): Boolean;
    function IsSignatureRequired: Boolean;

    procedure AddHeader(aCaptionCheckListBox: TCaptionCheckListBox; s: string);
    procedure BuildList(FullList: Boolean);
    procedure BuildFullList;
    procedure BuildSignList;
    procedure PlaceComponents(Save: boolean = True);
    procedure CleanupChangesList(Sender: TObject; ChangeItem: TChangeItem);
    { **RV** }
    procedure FormatListForScreenReader(Sender: TObject);
  public
    property FormID: string read FFormID write FFormID;
  end;

function ReviewChanges(TimedOut: Boolean; IsEvtChange: Boolean = False)
  : Boolean;

var
  frmReview: TfrmReview;
  FRVTFHintWindowActive: Boolean; // Called by fFrame
  FRVTFHintWindow: THintWindow; // Called by fFrame

implementation

{$R *.DFM}

uses
  ORFn,
  rCore,
  fNotes,
  fConsults,
  fOrders,
  rOrders,
  XWBHash,
  fDCSumm,
  fOCSession,
  uOrders,
  fSignItem,
  fOrdersPrint,
  fLkUpLocation,
  fFrame,
  uSignItems,
  fSurgery,
  fClinicWardMeds,
  rODLab,
  fRptBox,
  VAUtils,
  UBAGlobals,
  UResponsiveGUI,
  rMisc,
  VAHelpers,
  uWriteAccess;

const
  SP_NONE = 0;
  SP_CLERK = 1;
  SP_NURSE = 2;
  SP_SIGN = 3;
  TXT_ENCNT = 'Outpatient Encounter';
  TXT_NOVISIT = 'Visit Type: < None Selected >';
  TXT_NODIAG = 'Diagnosis: < None Selected >';
  TXT_NOPROC = 'Procedures: none';
  TXT_DOCS = 'Documents';
  TXT_ORDERS = 'Orders';
  TXT_BLANK = ' ';
  TX_INVAL_MSG =
    'Not a valid electronic signature code.  Enter a valid code or press Cancel.';
  TX_INVAL_CAP = 'Unrecognized Signature Code';
  TX_ES_REQ = 'Enter your electronic signature to release these orders.';
  TC_ES_REQ = 'Electronic Signature';
  TX_NO_REL = CRLF + CRLF + '- cannot be released to the service(s).' + CRLF +
    CRLF + 'Reason: ';
  TC_NO_REL = 'Unable to Release Orders';
  TC_NO_DX = 'Incomplete Diagnosis Entry';
  TX_NO_DX =
    'A Diagnosis must be selected prior to signing any of the following order types:'
    + CRLF + 'Outpatient Lab, Radiology, Outpatient Medications, Prosthetics.';

function ReviewChanges(TimedOut: Boolean; IsEvtChange: Boolean = False)
  : Boolean;
{ display changes made to chart for this encounter, allow changes to be saved, signed, etc. }
var
  i: Integer;
  aLst: TStringList;
  aStr: string;
begin
  Result := True;
  if Changes.Count = 0 then
    Exit;
  if assigned(frmReview) then
    Exit;

  frmReview := TfrmReview.Create(Application);

  aLst := TStringList.Create;
  try
    CallVistA('ORDEA DEATEXT', [], aLst);
    frmReview.lblDEAText.Caption := '';
    for aStr in aLst do
      frmReview.lblDEAText.Caption := frmReview.lblDEAText.Caption + ' ' + aStr;

    CallVistA('ORDEA SIGINFO', [Patient.DFN, User.DUZ], aLst);
    frmReview.lblProvInfo.Caption := aLst.Text;
    frmReview.pnlProvInfo.Width := frmReview.lblProvInfo.Width + 8;
  finally
    FreeAndNil(aLst);
  end;
  frmReview.lblDEAText.Visible := False;
  frmReview.lblSmartCardNeeded.Visible := False;

  try
    Changes.OnRemove := frmReview.CleanupChangesList; { **RV** }
    frmReview.FIsEvtChange := IsEvtChange;

    if TimedOut and (Changes.Count > 0) then
    begin
      frmReview.FSilent := True;
      WriteAccessV.IgnoreErrors;
      frmReview.BuildFullList;
      with frmReview.lstReview do
        for i := 0 to Items.Count - 1 do
          Checked[i] := False;
      frmReview.cmdOKClick(frmReview);
      Result := True;
    end
    // if user not timed out, execute as before
    else
    begin
      if ((uCore.User.OrderRole = OR_NURSE) or (uCore.User.OrderRole = OR_CLERK)
        ) and Changes.CanSign then
      begin
        frmReview.FCouldSign := True;
        frmReview.BuildSignList;

        // ok will remove from changes, exit leaves altogether
        if ((frmReview.lstReview.Count > 0) or (frmReview.lstCSReview.Count > 0))
        then
        begin
          frmReview.PlaceComponents;
          frmReview.ShowModal;
          Result := frmReview.FOKPressed;
          CSRemaining(frmReview.lstReview.Items, frmReview.lstCSReview.Items);
        end
        else
        begin
          Result := True;
        end;
      end;

      if Result and (Changes.Count > 0) then
      begin
        frmReview.FCouldSign := Changes.CanSign;
        frmReview.BuildFullList;

        if ((frmReview.lstReview.Count > 0) or (frmReview.lstCSReview.Count > 0))
        then
        begin
          frmReview.PlaceComponents;
          frmReview.ShowModal;
          Result := frmReview.FOKPressed;
          CSRemaining(frmReview.lstReview.Items, frmReview.lstCSReview.Items);
        end
        else
        begin
          Result := True;
        end;
      end;

    end;

  finally
    Changes.OnRemove := nil; { **RV** }
    frmReview.Release;
    frmReview := nil;
  end;
end;

procedure TfrmReview.FormCreate(Sender: TObject);
const
  TX_FORM_CAPTION = 'Review / Sign Changes  ';
  RAG_GAP = 23;

var
  i, btnLen, gap, len, len2, total: integer;
  rbtn: TRadioButton;

begin
  FOKPressed := False;
  FSilent := False;
  FLastHintItem := -1;
  Self.Caption := TX_FORM_CAPTION + '(' + Patient.Name + ' - ' +
    Patient.SSN + ')';
  FOldHintPause := Application.HintPause;
  Application.HintPause := 250;
  FOldHintHidePause := Application.HintHidePause;
  Application.HintHidePause := 30000;
  ResizeFormToFont(Self);
  lblSmartCardNeeded.Font.Size := MainFontSize;
  pnlCSTop.Height := MainFontTextHeight + TSigItems.btnMargin;

  gap := TSigItems.btnMargin * 8;
  gpBottom.ColumnCollection.BeginUpdate;
  try
    gpBottom.ColumnCollection[0].Value := Canvas.TextWidth(lblESCode.Caption) + gap;
    btnLen := Canvas.TextWidth(DontSign) + gap;
    gpBottom.ColumnCollection[2].Value := btnLen;
    gpBottom.ColumnCollection[3].Value := btnLen;
  finally
    gpBottom.ColumnCollection.EndUpdate;
  end;
  gpOrderActions.ColumnCollection.BeginUpdate;
  try
    gpRelease.ColumnCollection.BeginUpdate;
    try
      len := Canvas.TextWidth(radSignChart.Caption) + RAG_GAP;
      len2 := Canvas.TextWidth(radHoldSign.Caption) + RAG_GAP;
      if len < len2 then
        len := Len2;
      gpOrderActions.ColumnCollection[1].Value := len;
      total := 4;
      for i := 0 to 2 do
      begin
        case i of
          0: rbtn := radVerbal;
          1: rbtn := radPhone;
        else rbtn := radPolicy;
        end;
        len := Canvas.TextWidth(rbtn.Caption) + RAG_GAP;
        gpRelease.ColumnCollection[i].Value := len;
        inc(total, len);
      end;
      gpOrderActions.ColumnCollection[2].Value := total;
    finally
      gpRelease.ColumnCollection.EndUpdate;
    end;
  finally
    gpOrderActions.ColumnCollection.EndUpdate;
  end;
end;

procedure TfrmReview.AddHeader(aCaptionCheckListBox: TCaptionCheckListBox;
  s: string);
{ add header to review list, object is left nil }
begin
  aCaptionCheckListBox.Items.AddObject(s, nil);
end;

function TfrmReview.AddItem(aCaptionCheckListBox: TCaptionCheckListBox;
  ChangeItem: TChangeItem): Integer;
{ add a single review item to the list with its associated TChangeItem object }
begin
  Result := aCaptionCheckListBox.Items.AddObject(ChangeItem.Text, ChangeItem);

  case ChangeItem.SignState of
    CH_SIGN_YES:
      aCaptionCheckListBox.Checked[Result] := (aCaptionCheckListBox <> lstCSReview);
    CH_SIGN_NO:
      aCaptionCheckListBox.Checked[Result] := False;
    CH_SIGN_NA:
      aCaptionCheckListBox.State[Result] := cbGrayed;
  end;

  // hds00006047 this will override the signstate from above for all non-va med orders...  no signature required.
  if ChangeItem.GroupName = '' then
  begin
    if ChangeItem.OrderDG = NONVAMEDGROUP then
      aCaptionCheckListBox.State[Result] := cbGrayed;
  end;
  // hds00006047
end;

function TfrmReview.IsSignatureRequired: Boolean;
var
  i: Integer;
begin
  Result := False;
  with lstReview do
    for i := 0 to Items.Count - 1 do
    begin
      if Checked[i] then
      begin
        if TChangeItem(lstReview.Items.Objects[i]) = nil then
          Continue;
        if (TChangeItem(lstReview.Items.Objects[i]).SignState) <> CH_SIGN_NA
        then
          Result := True;
      end;
    end;
  with lstCSReview do
    for i := 0 to Items.Count - 1 do
    begin
      if Checked[i] then
      begin
        if TChangeItem(lstCSReview.Items.Objects[i]) = nil then
          Continue;
        if (TChangeItem(lstCSReview.Items.Objects[i]).SignState) <> CH_SIGN_NA
        then
          Result := True;
      end;
    end;
end;

procedure TfrmReview.BuildList(FullList: Boolean);
var
  GrpIndex, ChgIndex, lbIdx: Integer;
  ChangeItem: TChangeItem;
  PrevGrpName, temp: string;
  displayHeader, displaySpacer, displayCSHeader, displayCSSpacer,
    otherUserOrders, otherhdradded, othercshdradded: Boolean;
  t1, t2, HeaderAdded: Boolean;
  ChangeItemErrors: TList;

  function CannotSignOrder(ChangeItem: TChangeItem): Boolean;
  begin
    Result := False;
    if (ChangeItemErrors.IndexOf(ChangeItem) >= 0) or
      canWriteOrder(ChangeItem.OrderDGIEN) then
      Exit;
    if not canWriteOrder(ChangeItem.OrderDGIEN, '', atSign, True,
      RetrieveOrderText(ChangeItem.ID)) then
    begin
      ChangeItemErrors.Add(ChangeItem);
      Result := True;
    end;
  end;

begin
  PrevGrpName := '';
  lstReview.Clear;
  // ok to clear without freeing objects since they're part of Changes
  ChangeItemErrors := nil;
  WriteAccessV.BeginErrors;
  try
    ChangeItemErrors := TList.Create;
    if (FullList) then
    begin
      SigItems.ResetOrders;
      SigItemsCS.ResetOrders;
      with Changes do
        if PCE.Count > 0 then
        begin
          for GrpIndex := 0 to PCEGrp.Count - 1 do
          begin
            AddHeader(lstReview, 'Outpatient Encounter ' + PCEGrp[GrpIndex]);
            for ChgIndex := 0 to PCE.Count - 1 do
            begin
              ChangeItem := PCE[ChgIndex];
              if ChangeItem.GroupName = PCEGrp[GrpIndex] then
                AddItem(lstReview, ChangeItem);
            end;
            AddHeader(lstReview, '   ');
          end;
        end; { if PCE }
    end;
    with Changes do
      if (Documents.Count > 0) then
      begin
        HeaderAdded := False;
        for ChgIndex := 0 to Documents.Count - 1 do
        begin
          ChangeItem := Documents[ChgIndex];
          if not WriteAccess(ChangeItem.WriteAccessType, atSign, True,
            ChangeItem.Text) then
            continue;
          if (FullList or (ChangeItem.SignState <> CH_SIGN_NA)) then
          begin
            if not HeaderAdded then
            begin
              AddHeader(lstReview, 'Documents');
              HeaderAdded := True;
            end;
            AddItem(lstReview, ChangeItem);
          end;
        end;
        if FullList and HeaderAdded then
          AddHeader(lstReview, '   ');
      end; { if Documents }
    if (FullList) then
    begin
      displaySpacer := False;
      displayCSSpacer := False;
      with Changes do
        if (Orders.Count > 0) then
        begin
          OrderGrp.Sorted := True;
          otherUserOrders := False;
          for GrpIndex := 0 to OrderGrp.Count - 1 do
          begin
            displayHeader := True;
            displayCSHeader := True;
            if (GrpIndex > 0) and
              (AnsiCompareText(PrevGrpName, OrderGrp[GrpIndex]) = 0) then
              Continue;
            if OrderGrp[GrpIndex] = '' then
              temp := 'My Unsigned Orders - This Session'
            else if OrderGrp[GrpIndex] = 'Other Unsigned' then
              temp := 'My Unsigned Orders - Previous Sessions'
            else
              temp := 'Orders - ' + OrderGrp[GrpIndex];

            for ChgIndex := 0 to Orders.Count - 1 do
            begin
              ChangeItem := Orders[ChgIndex];
              if CannotSignOrder(ChangeItem) then
                continue;
              if (ChangeItem.GroupName = OrderGrp[GrpIndex]) and
                ((ChangeItem.User = 0) or (ChangeItem.User = User.DUZ)) then
              begin
                if ((ChangeItem.CSValue = False) or ChangeItem.DCOrder or
                  IsPendingHold(ChangeItem.ID)) then
                begin
                  if displayHeader = True then
                  begin
                    AddHeader(lstReview, temp);
                    displayHeader := False;
                    displaySpacer := True;
                  end;
                  lbIdx := AddItem(lstReview, ChangeItem);
                  SigItems.Add(CH_ORD, ChangeItem.ID, lbIdx);
                end
                else
                begin
                  if not(GetPKISite) or not(GetPKIUse) or
                    (DEACheckFailedAtSignature
                    (GetOrderableIen(Piece(ChangeItem.ID, ';', 1)), False) = '1')
                  then
                    ChangeItem.SignState := CH_SIGN_NA;

                  if displayCSHeader = True then
                  begin
                    AddHeader(lstCSReview, temp);
                    displayCSHeader := False;
                    displayCSSpacer := True;
                  end;
                  lbIdx := AddItem(lstCSReview, ChangeItem);
                  SigItemsCS.Add(CH_ORD, ChangeItem.ID, lbIdx);
                end;

              end
              else if ((ChangeItem.User > 0) and (ChangeItem.User <> User.DUZ))
              then
                otherUserOrders := True;
            end;
            if displayHeader = False then
              AddHeader(lstReview, '   ');
            if displayCSHeader = False then
              AddHeader(lstCSReview, '   ');
            PrevGrpName := OrderGrp[GrpIndex];
          end;
          // AGP fix for CQ 10073
          if otherUserOrders = True then
          begin
            othercshdradded := False;
            otherhdradded := False;
            for ChgIndex := 0 to Orders.Count - 1 do
            begin
              ChangeItem := Orders[ChgIndex];
              if CannotSignOrder(ChangeItem) then
                continue;
              if (ChangeItem.GroupName = 'Other Unsigned') and
                ((ChangeItem.User > 0) and (ChangeItem.User <> User.DUZ)) then
              begin

                if ((ChangeItem.CSValue = False) or ChangeItem.DCOrder or
                  IsPendingHold(ChangeItem.ID)) then
                begin
                  if not otherhdradded then
                  begin
                    otherhdradded := True;
                    if displaySpacer = True then
                      AddHeader(lstReview, '   ');
                    AddHeader(lstReview,
                      'Others'' Unsigned Orders Orders - All Sessions');
                  end;
                  lbIdx := AddItem(lstReview, ChangeItem);
                  SigItems.Add(CH_ORD, ChangeItem.ID, lbIdx);
                end
                else
                begin
                  if not(GetPKIUse) or not(GetPKISite) or
                    (DEACheckFailedAtSignature
                    (GetOrderableIen(Piece(ChangeItem.ID, ';', 1)), False) = '1')
                  then
                    ChangeItem.SignState := CH_SIGN_NA;
                  if not othercshdradded then
                  begin
                    othercshdradded := True;
                    if displayCSSpacer = True then
                      AddHeader(lstCSReview, '   ');
                    AddHeader(lstCSReview,
                      'Others'' Unsigned Orders - All Sessions');
                  end;
                  lbIdx := AddItem(lstCSReview, ChangeItem);
                  SigItemsCS.Add(CH_ORD, ChangeItem.ID, lbIdx);
                end;
              end;
            end;
          end;
          OrderGrp.Sorted := False;
        end; { if Orders }

      case User.OrderRole of
        OR_CLERK:
          FShowPanel := SP_CLERK;
        OR_NURSE:
          FShowPanel := SP_NURSE;
        OR_PHYSICIAN:
          FShowPanel := SP_SIGN;
        OR_STUDENT:
          if Changes.CanSign then
            FShowPanel := SP_SIGN
          else
            FShowPanel := SP_NONE;
      else
        FShowPanel := SP_NONE;
      end; { case User }
    end
    else
      FShowPanel := SP_SIGN;

  finally
    WriteAccessV.EndErrors(True);
    FreeAndNil(ChangeItemErrors);
  end;

  case FShowPanel of
    SP_CLERK:
      begin
        pnlSignature.Visible := False;
        pnlOrderAction.Visible := SignRequiredForAny(FullList);
      end;
    SP_NURSE:
      begin
        pnlSignature.Visible := False;
        radRelease.Visible := True;
//        grpRelease.Visible := True;
        pnlOrderAction.Visible := SignRequiredForAny(FullList);
      end;
    SP_SIGN:
      begin
        pnlOrderAction.Visible := False;
        pnlSignature.Visible := ItemsAreChecked(lstReview);
      end;
  else
    begin // SP_NONE
      pnlOrderAction.Visible := False;
      pnlSignature.Visible := False;
    end;
  end; { case FShowPanel }
  pnlSignature.Visible := AnyItemsAreChecked;

  txtESCodeChange(Self);
  if pnlOrderAction.Visible then
  begin
    if FShowPanel = SP_NURSE then
    begin
      if GetUserParam('OR SIGNATURE DEFAULT ACTION') = 'OC' then
        radHoldSign.Checked := True
      else
        radRelease.Checked := True;
    end;
    if (radHoldSign.Checked) and (GetUserParam('OR SIGNED ON CHART') = '1') then
      radSignChart.Checked := True;
    if radRelease.Checked then
      radReleaseClick(Self);
  end; { if pnlOrderAction }

  if lstCSReview.Count > 0 then
  begin
    if not(GetPKISite) then
    begin
      ShowMsg('Digital Signing of Controlled Substances is currently disabled for your site. Controlled Substance Orders will not be signed.');
    end
    else if not(GetPKIUse) then
    begin
      ShowMsg('You are not currently permitted to digitally sign Controlled Substances. Controlled Substance Orders will not be signed.');
    end;
  end;

  SigItems.ClearDrawItems;
  SigItems.ClearFCtrls;
  SigItemsCS.ClearDrawItems;
  SigItemsCS.ClearFCtrls;
  t1 := SigItems.UpdateListBox(lstReview);
  t2 := SigItemsCS.UpdateListBox(lstCSReview);

  if (FullList and (t1 or t2)) then
  begin
    fraCoPay.Visible := True;
    pnlTop.Visible := True;
  end
  else
  begin
    fraCoPay.Visible := False;
  end;

  {
    if lstReview.Count > 0 then
    begin
    for i := 1 to lstReview.Count - 1 do
    begin
    lstReviewMeasureItem(lstReview, i, ColHeight);
    lstReview.Perform(LB_SETITEMHEIGHT, i, ColHeight);
    end;
    end;
    RedrawWindow(lstReview.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  }

  if pnlSignature.Visible and txtESCode.Visible then
    ActiveControl := txtESCode;
end; { BuildList }

procedure TfrmReview.BuildFullList;
begin
  BuildList(True);
end;

procedure TfrmReview.BuildSignList;
begin
  BuildList(False);
end;

// defect 355810 - form ignores Main Form font size  --------------------- begin
procedure TfrmReview.PlaceComponents(Save: boolean = True);
var
  i, minWidth, temp, temp2, lstHeight, btnHeight, newHeight: integer;

  function getControlHeight(aControl: TControl): Integer;
  begin
    Result := 0;
    if not assigned(aControl) then
      Exit;
    Result := aControl.Height;
    if aControl.AlignWithMargins then
      Result := Result + aControl.Margins.Top + aControl.Margins.Bottom;
  end;

begin
  pnlDEAText.Visible := True;

  if ((lstReview.Count = 0) and (lstCSReview.Count = 0)) then
    Exit;

  lstHeight := Canvas.TextHeight('Ty') * 6;

  // keeping the component visibility logic of the original implementation //////
  if lstCSReview.Count = 0 then
  begin
    pnlProvInfo.Visible := False;
    if fraCoPay.Visible = False then
      pnlTop.Visible := False;
    pnlDEAText.Visible := False;
    pnlCSReview.Visible := False;
    gpMain.RowCollection[1].Value := 0;
  end
  else if lstReview.Count = 0 then
  begin
    pnlReview.Visible := False;
    gpMain.RowCollection[0].Value := 0;
  end
  else if fraCoPay.Visible = False then
  begin
    fraCoPay.Visible := True;
    fraCoPay.Visible := False;
  end;

  /// /////////////////////////////////////////////////////////////////////////////

  newHeight := Height - ClientHeight;

  btnHeight := cmdOK.Height + MainFont.Size - 14;
  if pnlOrderAction.Visible then
    pnlBottom.Height := btnHeight * 5
  else
    pnlBottom.Height := getControlHeight(lblESCode) + txtESCode.Height +
      txtESCode.Margins.Top + txtESCode.Margins.Bottom;

  newHeight := newHeight + pnlBottom.Height;

  if nonDCCSItemsAreChecked then
    newHeight := newHeight + pnlDEAText.Height;

  if pnlTop.Visible then
  begin
    pnlTop.Height := fraCoPay.AdjustAndGetSize;
    newHeight := newHeight + pnlTop.Height;
  end;

  if pnlCSReview.Visible then
    inc(newHeight, lstHeight);
  if pnlReview.Visible then
    inc(newHeight, lstHeight);

  temp := SigItems.BtnWidths;
  temp2 := SigItemsCS.BtnWidths;
  if temp < temp2 then
    temp := temp2;
  if (lstCSReview.Count > 0) and (not pnlOrderAction.Visible) then
    minWidth := Canvas.TextWidth(lblCSReview.Caption +
      lblSmartCardNeeded.Caption) + lblSmartCardNeeded.Margins.Left
  else
    minWidth := Canvas.TextWidth(lblSig.Caption);
  inc(minWidth, TSigItems.MinWidthDX + ScrollBarWidth + temp);

  if pnlOrderAction.Visible then
    temp := trunc(gpOrderActions.ColumnCollection[1].Value) +
      trunc(gpOrderActions.ColumnCollection[2].Value)
  else
    temp := 0;

  for i := 0 to 3 do
    if i <> 1 then
      inc(temp, trunc(gpBottom.ColumnCollection[i].Value));
  inc(temp, TSigItems.MinWidthDX);

  if minWidth < temp then
    minWidth := temp;

  Constraints.MinHeight := newHeight;
  Constraints.MinWidth := minWidth;

  Height := newHeight;

  { Check for CS Items checked for signature }
  pnlDEAText.Visible := nonDCCSItemsAreChecked;

  lblSmartCardNeeded.Visible := lblDEAText.Visible;

  if AnyItemsAreChecked then
    pnlSignature.Visible := IsSignatureRequired;

  FormID := '-';
  if pnlTop.Visible then
    FormID := FormID + 'T';
  if pnlReview.Visible and pnlCSReview.Visible then
    FormID := FormID + '2'
  else if pnlReview.Visible or pnlCSReview.Visible then
    FormID := FormID + '1';
  if Save then
    SetFormPosition(Self, FormID, True);
end;

procedure TfrmReview.pnlCSReviewResize(Sender: TObject);
begin
  inherited;
  lstReview.ForceItemHeightRecalc;
  lstCSReview.ForceItemHeightRecalc;
end;

// defect 355810 - form ignores Main Form font size  ----------------------- end

function TfrmReview.ItemsAreChecked(aListView: TCaptionCheckListBox): Boolean;
{ return true if any items in the Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;
  with aListView do
    for i := 0 to Items.Count - 1 do
      if Checked[i] then
      begin
        Result := True;
        Break;
      end;
end;

function TfrmReview.nonDCCSItemsAreChecked: Boolean;
{ return true if any items in the CS Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;
  with lstCSReview do
    for i := 0 to Items.Count - 1 do
      if Checked[i] and not(TChangeItem(Items.Objects[i]) = nil) then
      begin
        if not(TChangeItem(Items.Objects[i]).DCOrder) then
        begin
          Result := True;
          Break;
        end;
      end;
end;

function TfrmReview.AnyItemsAreChecked: Boolean;
begin
  Result := ItemsAreChecked(lstReview) or ItemsAreChecked(lstCSReview);
end;

function TfrmReview.SignRequiredForAny(FullList: Boolean): Boolean;
var
  i: Integer;
  tmpOrders: TStringList;
  ChangeItem: TChangeItem;
begin
  if (FullList) then
  begin
    tmpOrders := TStringList.Create;
    try
      for i := 0 to Pred(Changes.Orders.Count) do
      begin
        ChangeItem := Changes.Orders[i];
        tmpOrders.Add(ChangeItem.ID);
      end;
      Result := AnyOrdersRequireSignature(tmpOrders);
    finally
      FreeAndNil(tmpOrders);
    end;
  end
  else
    Result := False;
end;

procedure TfrmReview.radReleaseClick(Sender: TObject);
begin
  if not radRelease.Visible then
    Exit;
  lblHoldSign.Visible := radHoldSign.Checked;
  if radRelease.Checked then
  begin
    radVerbal.Enabled := True;
    radPhone.Enabled := True;
    radPolicy.Enabled := True;
    if Encounter.Provider = User.DUZ then
      radPolicy.Checked := True
    else
    radVerbal.Checked := True;
  end
  else
  begin
    radVerbal.Enabled := False;
    radPhone.Enabled := False;
    radPolicy.Enabled := False;
    radVerbal.Checked := False;
    radPhone.Checked := False;
    radPolicy.Checked := False;
  end;
  PlaceComponents(False); //DEFECT 453886 - SDS 3/29/17 ->  resize bottom panel after setting lblHoldSign.visible
end;

procedure TfrmReview.txtESCodeChange(Sender: TObject);
begin
  if (not pnlSignature.Visible) then
  begin
    if (FCouldSign and not AnyItemsAreChecked) then
      cmdOK.Caption := DontSign
    else
      cmdOK.Caption := 'OK'
  end
  else
  begin
    if Length(txtESCode.Text) > 0 then
      cmdOK.Caption := 'Sign'
    else
    begin
      if FCouldSign then
        cmdOK.Caption := DontSign
      else
        cmdOK.Caption := 'OK';
    end;
  end;
end;

procedure TfrmReview.cmdOKClick(Sender: TObject);
{ validate the electronic signature & call SaveSignItem for the encounter }
const
  TX_NOSIGN = 'Save items without signing?';
  TC_NOSIGN = 'No Signature Entered';
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR = 'Error Saving Order';
var
  i, idx, AType, PrintLoc, theSts, wardIEN, checki, checkj: Integer;
  SigSts, RelSts, Nature: Char;
  ESCode, AnID, AnErrMsg: string;
  ChangeItem, TempChangeItem: TChangeItem;
  OrderList, CSOrderList, TotalOrderList, OrderPrintList: TStringList;
  SaveCoPay, PINRetrieved: Boolean;
  displayEncSwitch, DelayOnly: Boolean;
  SigData, SigUser, SigDrugSch, SigDEA: string;
  cSignature, cHashData, cCrlUrl, cErr, WardName, ASvc: string;
  UsrAltName, IssuanceDate, PatientName, PatientAddress, DetoxNumber,
    ProviderName, ProviderAddress: string;
  DrugName, Quantity, Directions: string;
  cProvDUZ: Int64;
  AList, ClinicList, WardList: TStringList;
  IsOk, ContainsIMOOrders, DoNotPrint, checkfound: Boolean;
  EncLocName, EncLocText, tempInpLoc: string;
  EncLocIEN: Integer;
  EncDT: TFMDateTime;
  EncVC: Char;
  aPKIEncryptionEngine: IPKIEncryptionEngine;
  aPKIEncryptionDataDEAOrder: IPKIEncryptionDataDEAOrder;
  aMessage, successMsg: string;
  aLst: TStringList;

  function OrdersSignedOrReleased: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Pred(OrderList.Count) do
    begin
      if Pos('R', Piece(OrderList[i], U, 2)) > 0 then
        Result := True;
      if Pos('S', Piece(OrderList[i], U, 2)) > 0 then
        Result := True;
      if Result then
        Break;
    end;
  end;

  function OrdersToBeSignedOrReleased: Boolean;
  var
    i: Integer;
    s, X: string;
  begin
    Result := False;

    for i := 0 to Pred(OrderList.Count) do
    begin
      s := Piece(OrderList[i], U, 2);
      X := s[1];
      if ((s <> '') and CharInSet(s[1], [SS_ONCHART, SS_ESIGNED, SS_NOTREQD]))
        or (Piece(OrderList[i], U, 3) = RS_RELEASE) then
      begin
        Result := True;
        Break;
      end;
    end;

    for i := 0 to Pred(CSOrderList.Count) do
    begin
      s := Piece(CSOrderList[i], U, 2);
      X := s[1];
      if ((s <> '') and CharInSet(s[1], [SS_ONCHART, SS_ESIGNED, SS_NOTREQD]))
        or (Piece(CSOrderList[i], U, 3) = RS_RELEASE) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

  function Piece2end(s, del: string): string;
  var
    i: Integer;
  begin
    i := Pos(del, s);
    Result := copy(s, i + 1, Length(s));
  end;

begin
  IsOk := True;
  ESCode := '';
  SaveCoPay := False;
  PrintLoc := 0;
  EncLocIEN := 0;
  DoNotPrint := False;
  tempInpLoc := '';
  DelayOnly := False;

  if pnlSignature.Visible then
  begin
    ESCode := txtESCode.Text;

    if AnyItemsAreChecked and (Length(ESCode) > 0) and (not ValidESCode(ESCode))
    then
    begin
      InfoBox(TX_INVAL_MSG, TX_INVAL_CAP, MB_OK);
      ActiveControl := txtESCode;
      txtESCode.SelectAll;
      Exit;
    end;
    if Length(ESCode) > 0 then
      ESCode := Encrypt(ESCode);
  end; { if pnlSignature }

  try
    if not frmFrame.Closing then
    begin
      { save/sign orders }
      OrderList := TStringList.Create;
      CSOrderList := TStringList.Create;
      TotalOrderList := TStringList.Create;
      OrderPrintList := TStringList.Create;
      ClinicList := TStringList.Create;
      WardList := TStringList.Create;
      ContainsIMOOrders := False;
      try
        Nature := NO_PROVIDER;
        case User.OrderRole of
          OR_NOKEY, OR_CLERK, OR_NURSE, OR_STUDENT:
            begin
              SigSts := SS_UNSIGNED; // default to med student values
              RelSts := RS_HOLD;
              Nature := NO_WRITTEN;
              if User.OrderRole in [OR_CLERK, OR_NURSE] then
              begin
                if pnlOrderAction.Visible and radRelease.Checked and
                  not(radPhone.Checked or radPolicy.Checked or radVerbal.Checked)
                then
                begin
                  StatusText('');
                  InfoBox('An option for the Nature of Orders prompt must be selected',
                    'Missing Value', MB_OK);
                  Exit;
                end;
                if radSignChart.Checked then
                  SigSts := SS_ONCHART
                else
                  SigSts := SS_UNSIGNED;

                if radRelease.Checked or radSignChart.Checked then
                  RelSts := RS_RELEASE
                else
                  RelSts := RS_HOLD;

                if radSignChart.Checked or radHoldSign.Checked then
                  Nature := NO_WRITTEN
                else if radVerbal.Checked then
                  Nature := NO_VERBAL
                else if radPhone.Checked then
                  Nature := NO_PHONE
                else if radPolicy.Checked then
                  Nature := NO_POLICY
                else
                  Nature := NO_WRITTEN;

                if not pnlOrderAction.Visible then
                // if no orders require a signature
                begin
                  RelSts := RS_RELEASE;
                  Nature := NO_PROVIDER;
                  SigSts := SS_NOTREQD;
                end;
                // the following was added due to patch OR*3.0*86
                if RelSts = RS_RELEASE then
                begin
                  StatusText('Validating Release...');
                  AnErrMsg := '';
                  for i := 0 to lstReview.Items.Count - 1 do
                  begin
                    ChangeItem := TChangeItem(lstReview.Items.Objects[i]);
                    if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD)
                    then
                    begin
                      ValidateOrderActionNature(ChangeItem.ID, OA_RELEASE,
                        Nature, AnErrMsg);
                      if Length(AnErrMsg) > 0 then
                      begin
                        if IsInvalidActionWarning(ChangeItem.Text, ChangeItem.ID)
                        then
                          Break;
                        InfoBox(ChangeItem.Text + TX_NO_REL + AnErrMsg,
                          TC_NO_REL, MB_OK);
                        Break;
                      end; { if Length(AnErrMsg) }
                    end; { if ChangeItem=CH_ORD }
                  end; { for }
                  StatusText('');
                  if Length(AnErrMsg) > 0 then
                    Exit;
                end; { if RelSts }
                // the following supports the change to allow nurses to sign policy orders
                if FSilent then
                  RelSts := RS_HOLD;
                if (RelSts = RS_RELEASE) and pnlOrderAction.Visible then
                begin
                  SignatureForItem(Font.Size, TX_ES_REQ, TC_ES_REQ, ESCode);
                  if ESCode = '' then
                    Exit;
                  if Nature = NO_POLICY then
                    SigSts := SS_ESIGNED;
                end;
              end; { if..ORCLERK, OR_NURSE }

              with lstReview do
                for i := 0 to Items.Count - 1 do
                begin
                  ChangeItem := TChangeItem(Items.Objects[i]);
                  if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) and
                    (not radSignChart.Checked) then
                  begin
                    OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U
                      + Nature);
                  end
                  else if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD)
                    and (radSignChart.Checked) then
                    OrderList.Add(ChangeItem.ID + U + SS_ONCHART + U +
                      RS_RELEASE + U + NO_WRITTEN);
                end; { with lstReview }

              with lstCSReview do
                for i := 0 to Items.Count - 1 do
                begin
                  ChangeItem := TChangeItem(Items.Objects[i]);
                  if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
                  begin
                    OrderList.Add(ChangeItem.ID + U + SS_UNSIGNED + U + RS_HOLD
                      + U + Nature);
                  end
                end; { with lstCSReview }

            end; { OR_NOKEY, OR_CLERK, OR_NURSE, OR_STUDENT }

          OR_PHYSICIAN:
            begin
              Nature := NO_PROVIDER;
              with lstReview do
                for i := 0 to Items.Count - 1 do
                begin
                  ChangeItem := TChangeItem(Items.Objects[i]);
                  if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
                  begin
                    case State[i] of
                      cbChecked:
                        if Length(ESCode) > 0 then
                        begin
                          SigSts := SS_ESIGNED;
                          RelSts := RS_RELEASE;
                          OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts
                            + U + Nature);
                        end
                        else
                        begin
                          SigSts := SS_UNSIGNED;
                          RelSts := RS_HOLD;
                        end;
                      cbGrayed:
                        if OrderRequiresSignature(ChangeItem.ID) then
                        begin
                          SigSts := SS_UNSIGNED;
                          RelSts := RS_HOLD;
                        end
                        else
                        begin
                          SigSts := SS_NOTREQD;
                          RelSts := RS_RELEASE;
                        end;
                    else
                      begin // (cbUnchecked)
                        SigSts := SS_UNSIGNED;
                        RelSts := RS_HOLD;
                      end;
                    end; { case State }

                    if (ChangeItem.GroupName = 'Other Unsigned') and
                      (SigSts = SS_UNSIGNED) and (RelSts = RS_HOLD) then
                      // NoOp - don't add unsigned orders from outside session to the list
                    else
                    begin
                      if not(State[i] = cbChecked) and
                        (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U +
                        RelSts + U + Nature) < 0) then
                        OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts +
                          U + Nature)
                      else if (cmdOK.Caption = DontSign) and
                        (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U +
                        RelSts + U + Nature) < 0) then
                        OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts +
                          U + Nature);
                    end;
                  end; { if ItemType }
                end; { with lstReview }

              with lstCSReview do
                for i := 0 to Items.Count - 1 do
                begin
                  ChangeItem := TChangeItem(Items.Objects[i]);
                  if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
                  begin
                    case State[i] of
                      cbChecked:
                        if Length(ESCode) > 0 then
                        begin
                          SigSts := SS_ESIGNED;
                          RelSts := RS_RELEASE;
                          if ChangeItem.DCOrder then
                            OrderList.Add(ChangeItem.ID + U + SS_ESIGNED + U +
                              RelSts + U + Nature)
                          else
                            CSOrderList.Add(ChangeItem.ID + U + SS_DIGSIG + U +
                              RelSts + U + Nature);
                        end
                        else
                        begin
                          SigSts := SS_UNSIGNED;
                          RelSts := RS_HOLD;
                        end;
                      cbGrayed:
                        if OrderRequiresSignature(ChangeItem.ID) then
                        begin
                          SigSts := SS_UNSIGNED;
                          RelSts := RS_HOLD;
                        end
                        else
                        begin
                          SigSts := SS_NOTREQD;
                          RelSts := RS_RELEASE;
                        end;
                    else
                      begin // (cbUnchecked)
                        SigSts := SS_UNSIGNED;
                        RelSts := RS_HOLD;
                      end;
                    end; { case State }

                    if (ChangeItem.GroupName = 'Other Unsigned') and
                      (SigSts = SS_UNSIGNED) and (RelSts = RS_HOLD) then
                      // NoOp - don't add unsigned orders from outside session to the list
                    else
                    begin
                      if not(State[i] = cbChecked) and
                        (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U +
                        RelSts + U + Nature) < 0) then
                        OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts +
                          U + Nature)
                      else if (cmdOK.Caption = DontSign) and
                        (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U +
                        RelSts + U + Nature) < 0) then
                        OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts +
                          U + Nature);
                    end;
                  end; { if ItemType }
                end; { with lstCSReview }

            end; { OR_PHYSICIAN }
        end; { case User.OrderRole }
        {
          // add csorderlist to totalorderlist in order to do order checking
          for i := 0 to CSOrderList.Count - 1 do
          begin
          TotalOrderList.Add(CSOrderList.Strings[i]);
          end;

          // add orderlist to totalorderlist in order to do order checking
          for i := 0 to OrderList.Count - 1 do
          begin
          TotalOrderList.Add(OrderList.Strings[i]);
          end;

          // do order checkign on totalorderlist.  Any order's cancelled will no longer be in totalorderlist
          While (TotalOrderList.Count > 0) do
          begin
          IsOk := ExecuteSessionOrderChecks(TotalOrderList);
          // any cancelled orders will be removed from OrderList
          if IsOk then
          Break;
          end;

          // remove any orders from csorderlist that are no longer part of totalorderlist
          i := CSOrderList.Count - 1;
          While i >= 0 do
          begin
          if (TotalOrderList.IndexOf(CSOrderList.Strings[i]) = -1) then
          CSOrderList.Delete(i);
          i := i - 1;
          end;

          // remove any orders from orderlist that are no longer part of totalorderlist
          i := OrderList.Count - 1;
          While i >= 0 do
          begin
          if (TotalOrderList.IndexOf(OrderList.Strings[i]) = -1) then
          OrderList.Delete(i);
          i := i - 1;
          end;
        }
        IsOk := ExecuteSessionOrderChecks([CSOrderList, OrderList]);

        if IsOk then
        // NSR 20101203 ---------------------------------------------------- begin
        begin
          if CSOrderList.Count > 0 then
          begin
            try
              // get PKI engine components ready
              NewPKIEncryptionEngine(RPCBrokerV, aPKIEncryptionEngine);
              NewPKIEncryptionDataDEAOrder(aPKIEncryptionDataDEAOrder);

              // check if reader is ready, card in slot, SAN is set in vista user account
              // if no SAN set it will perform the link process in IsDigitalSignatureAvailable
              aLst := TStringList.Create;
              try
                CallVistA('ORDEA LNKMSG', [], aLst);
                successMsg := aLst.Text;
              finally
                FreeAndNil(aLst);
              end;

              if not IsDigitalSignatureAvailable(aPKIEncryptionEngine, aMessage,
                successMsg) then
                raise Exception.Create
                  ('There was a problem linking your PIV card. Either the ' +
                  'PIV card name does NOT match your VistA account name or the PIV card is already '
                  + 'linked to another VistA account.  Ensure that the correct PIV card has '
                  + 'been inserted for your VistA account. Please contact your PIV Card Coordinator '
                  + 'if you continue to have problems.');

              // do PIN entry
              case VerifyPKIPIN(aPKIEncryptionEngine) of
                prOK:
                  begin
                    for i := 0 to CSOrderList.Count - 1 do
                    begin
                      aPKIEncryptionDataDEAOrder.Clear;
                      aPKIEncryptionDataDEAOrder.LoadFromVistA(RPCBrokerV,
                        Patient.DFN, IntToStr(User.DUZ),
                        Piece(Piece(CSOrderList.Strings[i], U, 1), ';', 1));
                      try
                        aPKIEncryptionEngine.SignData
                          (aPKIEncryptionDataDEAOrder);

                        // if we get here without an exception then all went well with digital signing of this order
                        cSignature := aPKIEncryptionDataDEAOrder.Signature;
                        cHashData := aPKIEncryptionDataDEAOrder.HashText;
                        cCrlUrl := aPKIEncryptionDataDEAOrder.CrlURL;
                        cErr := '';

                        // store digital sig info for the order
                        StoreDigitalSig(Piece(CSOrderList.Strings[i], U, 1),
                          cHashData, User.DUZ, cSignature, cCrlUrl,
                          Patient.DFN, cErr);
                        if cErr = '' then
                        begin
                          UpdateOrderDGIfNeeded
                            (Piece(CSOrderList.Strings[i], U, 1));
                          // if this happens then the order will get released
                          OrderList.Add(CSOrderList.Strings[i]);
                          // BAOrderList.Add(Piece(CSOrderList.Strings[i], U, 1));
                        end;
                      except
                        on E: EPKIEncryptionError do
                          raise Exception.Create
                            ('PKI error encountered during digital signing of data: '
                            + E.Message);
                        on E: Exception do
                          raise Exception.Create
                            ('Unknown error encountered during digital signing: '
                            + E.Message);
                      end;
                    end;
                  end;
                prCancel:
                  Exception.Create
                    ('You have cancelled the digital signing process.');
                prLocked:
                  Exception.Create
                    ('Your card has been locked and you cannot continue the digital signing process.');
              else
                Exception.Create
                  ('There was a problem getting your PIN and the digital signing process has been stopped.');
              end;
            except
              on E: Exception do
                ShowMsg('The Controlled Substance order(s) will remain unreleased. '
                  + E.Message);
            end;
          end;
          aPKIEncryptionEngine := nil;
          aPKIEncryptionDataDEAOrder := nil;

          if not IsUserNurseProvider(User.DUZ) then
          begin
            if OrdersToBeSignedOrReleased then
            begin
              if (not SigItems.OK2SaveSettings) or
                (not SigItemsCS.OK2SaveSettings) then
              begin
                if (cmdOK.Caption = DontSign) then
                  SaveCoPay := True
                else
                begin
                  InfoBox(TX_Order_Error, 'Review/Sign Orders', MB_OK);
                  Exit;
                end
              end
              else
                SaveCoPay := True;
            end
            else
              SaveCoPay := True;
          end;

          // make sure all cs orders are in the orderlist.  if not add them as usnigned/hold
          for checki := 0 to CSOrderList.Count - 1 do
          begin
            checkfound := False;
            for checkj := 0 to OrderList.Count - 1 do
            begin
              if Piece(OrderList[checkj], U, 1) = Piece(CSOrderList[checki],
                U, 1) then
                checkfound := True;
            end;
            if not(checkfound) then
              OrderList.Add(Piece(CSOrderList[checki], U, 1) + U + SS_UNSIGNED +
                U + RS_HOLD + U + Piece(CSOrderList[checki], U, 4));
          end;

          { release & print orders }
          // test for LockedForOrdering is to make sure patient is locked if pulling in all unsigned
          if (User.OrderRole in [OR_NOKEY .. OR_STUDENT]) and
            (OrderList.Count > 0) and LockedForOrdering then
          begin
            StatusText('Sending Orders to Service(s)...');
            if (OrderList.Count > 0) then
            begin
              // hds7591  Clinic/Ward movement.  Nurse orders
              if (cmdOK.Caption = 'Sign') or (cmdOK.Caption = 'OK') and
                (not frmFrame.TimedOut) then
              begin
                tempInpLoc := TfrmPrintLocation.rpcIsPatientOnWard(Patient.DFN);
                if ((Patient.Inpatient = False) and (tempInpLoc <> '')) or
                  ((Patient.Inpatient = True) and
                  (Encounter.Location <> Patient.Location)) or
                  ((Patient.Inpatient = True) and
                  (Encounter.Location = Patient.Location) and
                  (Encounter.Location <> uCore.TempEncounterLoc) and
                  (uCore.TempEncounterLoc <> 0)) or
                  ((Patient.Inpatient) and (tempInpLoc <> '') and
                  (Piece(tempInpLoc, U, 2) <> IntToStr(Encounter.Location)))
                then
                begin
                  if (Encounter.Location <> Patient.Location) or
                    ((tempInpLoc <> '') and ((IntToStr(Encounter.Location)) <>
                    (Piece(tempInpLoc, U, 2)))) then
                  begin
                    EncLocName := Encounter.LocationName;
                    EncLocIEN := Encounter.Location;
                    EncLocText := Encounter.LocationText;
                    EncDT := Encounter.DateTime;
                    EncVC := Encounter.VisitCategory;
                  end
                  else
                  begin
                    EncLocName := uCore.TempEncounterLocName;
                    EncLocIEN := uCore.TempEncounterLoc;
                    EncLocText := uCore.TempEncounterText;
                    EncDT := uCore.TempEncounterDateTime;
                    EncVC := uCore.TempEncounterVistCat;
                  end;
                  if frmFrame.mnuFile.Tag = 0 then
                    displayEncSwitch := False
                  else
                    displayEncSwitch := True;
                  if Encounter.Location = 0 then
                  begin
                    displayEncSwitch := True;
                    DelayOnly := True;
                  end;
                  for i := 0 to lstReview.Items.Count - 1 do
                  begin
                    // disregard orders that are not signed
                    if (lstReview.Checked[i] = False) and
                      (lstReview.State[i] <> cbGrayed) then
                      Continue;
                    TempChangeItem := TChangeItem(lstReview.Items.Objects[i]);
                    // DC Orders should print at the ward location
                    if TempChangeItem.DCOrder = True then
                    begin
                      WardList.Add(TempChangeItem.ID);
                      Continue;
                    end;
                    // disregard Non-VA Meds orders
                    if TempChangeItem.OrderDG = NONVAMEDGROUP then
                      Continue;
                    if TempChangeItem.OrderDG = 'Clinic Orders' then
                      ContainsIMOOrders := True;
                    if (TempChangeItem.OrderDG = '') then
                      Continue;
                    // Delay orders should be printed when the order is release to service not when the order is sign
                    if TempChangeItem.Delay = True then
                      Continue;
                    OrderPrintList.Add(TempChangeItem.ID + ':' +
                      TempChangeItem.Text);
                  end;
                  if (OrderPrintList.Count > 0) and (DelayOnly = False) then
                    TfrmPrintLocation.PrintLocation(OrderPrintList, EncLocIEN,
                      EncLocName, EncLocText, EncDT, EncVC, ClinicList,
                      WardList, wardIEN, WardName, ContainsIMOOrders,
                      displayEncSwitch)
                    // Only Display encounter switch form if staying in the patient chart
                  else if displayEncSwitch = True then
                  begin
                    TfrmPrintLocation.SwitchEncounterLoction(EncLocIEN,
                      EncLocName, EncLocText, EncDT, EncVC);
                    fFrame.frmFrame.OrderPrintForm := True;
                    DoNotPrint := True;
                  end;
                  if (wardIEN = 0) and (WardName = '') then
                    CurrentLocationForPatient(Patient.DFN, wardIEN,
                      WardName, ASvc);
                  // All other scenarios should not print
                  if (ClinicList.Count = 0) and (WardList.Count = 0) then
                    DoNotPrint := True;
                end;
              end;
              if (cmdOK.Caption = DontSign) and (not frmFrame.TimedOut) and
                (frmFrame.mnuFile.Tag <> 0) then
              begin
                tempInpLoc := TfrmPrintLocation.rpcIsPatientOnWard(Patient.DFN);
                if ((Patient.Inpatient = False) and (tempInpLoc <> '')) or
                  ((Patient.Inpatient = True) and
                  (Encounter.Location <> Patient.Location)) or
                  ((Patient.Inpatient = True) and
                  (Encounter.Location = Patient.Location) and
                  (Encounter.Location <> uCore.TempEncounterLoc) and
                  (uCore.TempEncounterLoc <> 0)) or
                  ((Patient.Inpatient) and (tempInpLoc <> '') and
                  (Piece(tempInpLoc, U, 2) <> IntToStr(Encounter.Location)))
                then
                begin
                  if (Encounter.Location <> Patient.Location) or
                    ((tempInpLoc <> '') and ((IntToStr(Encounter.Location)) <>
                    (Piece(tempInpLoc, U, 2)))) then
                  begin
                    EncLocName := Encounter.LocationName;
                    EncLocIEN := Encounter.Location;
                    EncLocText := Encounter.LocationText;
                    EncDT := Encounter.DateTime;
                    EncVC := Encounter.VisitCategory;
                  end
                  else
                  begin
                    EncLocName := uCore.TempEncounterLocName;
                    EncLocIEN := uCore.TempEncounterLoc;
                    EncLocText := uCore.TempEncounterText;
                    EncDT := uCore.TempEncounterDateTime;
                    EncVC := uCore.TempEncounterVistCat;
                  end;
                  TfrmPrintLocation.SwitchEncounterLoction(EncLocIEN,
                    EncLocName, EncLocText, EncDT, EncVC);
                  fFrame.frmFrame.OrderPrintForm := True;
                end;
              end;
              uCore.TempEncounterLoc := 0;
              uCore.TempEncounterLocName := '';
              tempInpLoc := '';
            end;
            // hds7591  Clinic/Ward movement.

            if SaveCoPay then
            begin
              SigItems.SaveSettings; // Save CoPay FIRST
              SigItemsCS.SaveSettings;
            end;

            SendOrders(OrderList, ESCode); { *KCM* }

            // CQ #15813 Modired code to look for error string mentioned in CQ and change strings to conts - JCS
            with OrderList do
              for i := 0 to Count - 1 do
              begin
                if Pos('E', Piece(OrderList[i], U, 2)) > 0 then
                begin
                  ChangeItem := Changes.Locate(CH_ORD,
                    Piece(OrderList[i], U, 1));
                  if not FSilent then
                  begin
                    if Piece(OrderList[i], U, 4) = TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING
                    then
                      InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) +
                        TX_SAVERR2 + ChangeItem.Text + CRLF + CRLF +
                        TX_SAVERR_PHARM_ORD_NUM, TC_SAVERR, MB_OK)
                    else if Piece(OrderList[i], U, 4) = TX_SAVERR_IMAGING_PROC_SEARCH_STRING
                    then
                      InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) +
                        TX_SAVERR2 + ChangeItem.Text + CRLF + CRLF +
                        TX_SAVERR_IMAGING_PROC, TC_SAVERR, MB_OK)
                    else
                      InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) +
                        TX_SAVERR2 + ChangeItem.Text, TC_SAVERR, MB_OK);
                  end;
                end;
                if Pos('R', Piece(OrderList[i], U, 2)) > 0 then
                  NotifyOtherApps(NAE_ORDER,
                    'RL' + U + Piece(OrderList[i], U, 1));
              end;
            if OrdersSignedOrReleased and (not FSilent) then
            begin
              for idx := OrderList.Count - 1 downto 0 do
              begin
                if Pos('E', Piece(OrderList[idx], U, 2)) > 0 then
                begin
                  OrderList.Delete(idx);
                  Continue;
                end;
                theSts := GetOrderStatus(Piece(OrderList[idx], U, 1));
                if theSts = 10 then
                  OrderList.Delete(idx);
                // signed delayed order should not be printed.
              end;
              // CQ 10226, PSI-05-048 - advise of auto-change from LC to WC on lab orders
              AList := TStringList.Create;
              try
                CheckForChangeFromLCtoWCOnRelease(AList, Encounter.Location,
                  OrderList);
                if AList.Text <> '' then
                  ReportBox(AList, 'Changed Orders', True);
              finally
                AList.Free;
              end;
              if (ClinicList.Count > 0) or (WardList.Count > 0) then
                PrintOrdersOnSignReleaseMult(OrderList, ClinicList, WardList,
                  Nature, EncLocIEN, wardIEN, EncLocName, WardName)
              else if DoNotPrint = False then
                PrintOrdersOnSignRelease(OrderList, Nature, PrintLoc);
            end;
            StatusText('');
            UpdateUnsignedOrderAlerts(Patient.DFN);
            UpdateIndOrderAlerts();
            with Notifications do
              if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
                UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
            UpdateExpiringMedAlerts(Patient.DFN);
            UpdateUnverifiedMedAlerts(Patient.DFN);
            UpdateUnverifiedOrderAlerts(Patient.DFN);
            SendMessage(Application.MainForm.Handle, UM_NEWORDER,
              ORDER_SIGN, 0);
          end; { if User.OrderRole }
        end; // NSR 20101203 --------------------------------------------------end
      finally
        FreeAndNil(OrderList);
        FreeAndNil(CSOrderList);
        FreeAndNil(TotalOrderList);
        FreeAndNil(OrderPrintList);
        FreeAndNil(ClinicList);
        FreeAndNil(WardList);
      end;
    end;

    { save/sign documents }
    with lstReview do
      for i := 0 to Items.Count - 1 do
      begin
        ChangeItem := TChangeItem(Items.Objects[i]);
        if ChangeItem <> nil then
          with ChangeItem do
            case ItemType of
              CH_DOC:
                if Checked[i] then
                  frmNotes.SaveSignItem(ChangeItem.ID, ESCode)
                else
                  frmNotes.SaveSignItem(ChangeItem.ID, '');
              CH_CON:
                if Checked[i] then
                  frmConsults.SaveSignItem(ChangeItem.ID, ESCode)
                else
                  frmConsults.SaveSignItem(ChangeItem.ID, '');
              CH_SUM:
                if Checked[i] then
                  frmDCSumm.SaveSignItem(ChangeItem.ID, ESCode)
                else
                  frmDCSumm.SaveSignItem(ChangeItem.ID, '');
              CH_SUR:
                if assigned(frmSurgery) then
                begin
                  if Checked[i] then
                    frmSurgery.SaveSignItem(ChangeItem.ID, ESCode)
                  else
                    frmSurgery.SaveSignItem(ChangeItem.ID, '');
                end;
            end; { case }
      end; { with lstReview }
    if frmFrame.Closing then
      Exit;

    // clear all the items that were on the list (but not all in Changes)
    with lstReview do
      for i := Items.Count - 1 downto 0 do
      begin
        if (not assigned(Items.Objects[i])) then
          Continue; { **RV** }
        ChangeItem := TChangeItem(Items.Objects[i]);
        if ChangeItem <> nil then
        begin
          AnID := ChangeItem.ID;
          AType := ChangeItem.ItemType;
          if (AType = CH_ORD) and IsOk then
            Changes.Remove(AType, AnID)
          else if (AType <> CH_ORD) then
            Changes.Remove(AType, AnID);
        end;
      end;
    with lstCSReview do
      for i := Items.Count - 1 downto 0 do
      begin
        if (not assigned(Items.Objects[i])) then
          Continue; { **RV** }
        ChangeItem := TChangeItem(Items.Objects[i]);
        if ChangeItem <> nil then
        begin
          AnID := ChangeItem.ID;
          AType := ChangeItem.ItemType;
          if (AType = CH_ORD) and IsOk then
            Changes.Remove(AType, AnID);
        end;
      end;
    FOKPressed := IsOk;
  Finally
    UnlockIfAble;
  end;
  Close;
end;

procedure TfrmReview.CleanupChangesList(Sender: TObject;
  ChangeItem: TChangeItem);
{ Added for v15.3 - called by Changes.Remove, but only if fReview in progress }
var
  i: Integer;
begin
  with lstReview do
  begin
    i := Items.IndexOfObject(ChangeItem);
    if i > -1 then
    begin
      TChangeItem(Items.Objects[i]).Free;
      Items.Objects[i] := nil;
    end;
  end;
end;

procedure TfrmReview.cmdCancelClick(Sender: TObject);
{ cancelled - do nothing }
begin
  inherited;
  Close;
end;

procedure TfrmReview.FormDestroy(Sender: TObject);
begin
  Application.HintPause := FOldHintPause;
  Application.HintHidePause := FOldHintHidePause;
end;

procedure TfrmReview.lstReviewClickCheck(Sender: TObject);
{ prevent grayed checkboxes from being changed to anything else }
var
  aListView: TCaptionCheckListBox;
  ChangeItem: TChangeItem;

  procedure updateAllChilds(CheckedStatus: Boolean; ParentOrderId: string);
  var
    idx: Integer;
    AChangeItem: TChangeItem;
  begin
    for idx := 0 to aListView.Items.Count - 1 do
    begin
      AChangeItem := TChangeItem(aListView.Items.Objects[idx]);
      if assigned(AChangeItem) and (AChangeItem.ParentID = ParentOrderId) then
        if aListView.Checked[idx] <> CheckedStatus then
        begin
          aListView.Checked[idx] := CheckedStatus;
          if Sender = lstReview
          then { IMPORTANT: Check for Sender/TSigItems match }
            SigItems.EnableSettings(idx, aListView.Checked[idx])
          else if Sender = lstCSReview then
            SigItemsCS.EnableSettings(idx, aListView.Checked[idx]);
        end;
    end;
  end;

begin
  aListView := Sender as TCaptionCheckListBox;

  if Sender = lstCSReview then
    with lstCSReview do
      try
        CallVistA(
          'ORDEA AUINTENT',
          [TOrder(Items.Objects[ItemIndex]).ID, BOOLCHAR[Checked[ItemIndex]]]);
      except
        on E: Exception do
          MessageDlg(
            Format('Error auditing intent to sign for controlled substance %s:%s', [E.ClassName, E.Message]),
            mtError, [mbOk], 0);
      end;

  with aListView do
  begin
    ChangeItem := TChangeItem(Items.Objects[ItemIndex]);
    if ItemIndex > 0 then
    begin
      if (ChangeItem <> nil) then
      begin
        if (ChangeItem.SignState = CH_SIGN_NA) then
          State[ItemIndex] := cbGrayed
        else
        begin
          SigItems.EnableSettings(ItemIndex, Checked[ItemIndex]);
          if Length(ChangeItem.ParentID) > 0 then
            updateAllChilds(Checked[ItemIndex], ChangeItem.ParentID);
        end;
      end;
    end;

    { Manage the PIV Card component visibility if actual CS order being placed }
    pnlDEAText.Visible := nonDCCSItemsAreChecked;
    lblSmartCardNeeded.Visible := lblDEAText.Visible;

    pnlSignature.Visible := IsSignatureRequired;
  end;

  txtESCodeChange(Self);
  if pnlSignature.Visible then
    txtESCode.SetFocus;
end;

procedure TfrmReview.lstReviewDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
{ outdent the header items (thus hiding the checkbox) }

  function UpdateTextRecord(R: TRect; DY: Integer): TRect;
  begin
    Result := R;
    Inc(Result.Top, DY);
    Dec(Result.Bottom, DY);
  end;

var
  AListView: TCaptionCheckListBox;
  ATextRecordRect: TRect;
  S: string;
  DY: Integer;
begin
  AListView := Control as TCaptionCheckListBox;
  if (Index < 0) or (Index >= AListView.Count) then Exit;

  DY := SIG_ITEM_VERTICAL_PAD div 2;
  S := '';
  if AListView.Items.Objects[Index] = nil then Rect.Left := 0;
  AListView.Canvas.FillRect(Rect);
  S := Trim(FilteredString(AListView.Items[Index]));

  if (Rect.Left = 0) and (Length(S) > 0) then
  begin
    AListView.Canvas.TextOut(Rect.Left + 2, Rect.Top + DY, S);
  end else begin
    if (Rect.Left > 0) and (Length(S) > 0) then
    begin
      AListView.Canvas.Pen.Color := Get508CompliantColor(clSilver);
      AListView.Canvas.MoveTo(0, Rect.Bottom - 1);
      AListView.Canvas.LineTo(Rect.Right, Rect.Bottom - 1);
      ATextRecordRect := UpdateTextRecord(Rect, DY);
      DrawText(AListView.Canvas.Handle, PChar(S), Length(S), ATextRecordRect,
        DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmReview.lstReviewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Space) then
    FormatListForScreenReader(Sender)
end;

procedure TfrmReview.lstReviewMeasureItem(Control: TWinControl; Index: Integer;
  var AHeight: Integer);
var
  AListView: TCaptionCheckListBox;
  S: string;
  ARect: TRect;
begin
  AListView := Control as TCaptionCheckListBox;
  AHeight := SigItemHeight;
  if (Index >= 0) and (Index < AListView.Count) then
  begin
    ARect := AListView.ItemRect(Index);
    if CVarExists(TSigItems.RectWidth) then
      ARect.Right := CVar[TSigItems.RectWidth];
    ARect.Left := AListView.CheckWidth;
    AListView.Canvas.FillRect(ARect);
    S := FilteredString(AListView.Items[Index]);
    AHeight := WrappedTextHeightByFont(AListView.Canvas, Font, S, ARect) +
      SIG_ITEM_VERTICAL_PAD;
  end;
  if AHeight > 255 then AHeight := 255;
  if AHeight < 13 then AHeight := 15;
end;

procedure TfrmReview.lstReviewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  aItem: Integer;
  aListView: TCaptionCheckListBox;
begin
  aListView := Sender as TCaptionCheckListBox;

  aItem := aListView.ItemAtPos(Point(X, Y), True);
  if (aItem >= 0) then
  begin
    if (aItem <> FLastHintItem) then
    begin
      Application.CancelHint;
      FLastHintItem := aItem;
      Application.ActivateHint(Point(X, Y));
    end;
  end
  else
  begin
    aListView.Hint := '';
    FLastHintItem := -1;
    Application.CancelHint;
  end;
end;

procedure TfrmReview.FormShow(Sender: TObject);
begin
  if pnlSignature.Visible then
  else if pnlOrderAction.Visible then
  else
  begin
    FormatListForScreenReader(lstReview);
    FormatListForScreenReader(lstCSReview);
  end;
end;

procedure TfrmReview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  j: Integer; // CQ5054
begin
  inherited;
  FCurrentlySelectedItem := lstReview.ItemIndex; // CQ5063

  case Key of
    // CQ5054
    83, 115:
      if (ssAlt in Shift) then
      begin
        for j := 0 to lstReview.Items.Count - 1 do
          lstReview.Selected[j] := False;
        if lstReview.Count >= 2 then lstReview.Selected[1] := True;
        lstReview.SetFocus;
      end;
    09:
      if FRVTFHintWindowActive then
      begin
        FRVTFHintWindow.ReleaseHandle;
        FRVTFHintWindowActive := False;
      end;
    // end CQ5054
  end;
end;

procedure TfrmReview.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Space then
  begin
    if lstReview.Focused then // CQ6657
    begin
      if lstReview.Count > 0 then
        lstReview.Selected[lstReview.Items.Count - 1] := False;
      if (FCurrentlySelectedItem >= 0) and
        (lstReview.Count > FCurrentlySelectedItem) then
        lstReview.Selected[FCurrentlySelectedItem] := True;
    end;
  end;
end;

procedure TfrmReview.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FRVTFHintWindowActive then
  begin
    FRVTFHintWindow.ReleaseHandle;
    FRVTFHintWindowActive := False;
  end;
end;

procedure TfrmReview.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FRVTFHintWindowActive then
  begin
    FRVTFHintWindow.ReleaseHandle;
    FRVTFHintWindowActive := False;
    TResponsiveGUI.ProcessMessages;
  end;
end;

procedure TfrmReview.fraCoPayLabel24MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  fraCoPay.LabelCaptionsOn(not FRVTFHintWindowActive);
end;

procedure TfrmReview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveUserBounds(Self, FormID);
  if FRVTFHintWindowActive then
  begin
    FRVTFHintWindow.ReleaseHandle;
    FRVTFHintWindowActive := False;

    with fraCoPay do
    begin
      // Long captions
      lblSC.ShowHint := False;
      lblCV.ShowHint := False;
      lblAO.ShowHint := False;
      lblIR.ShowHint := False;
      lblSWAC.ShowHint := False;
      lblHNC.ShowHint := False;
      lblHNC2.ShowHint := False;
      lblSHAD2.ShowHint := False;
    end;
  end;
end;

procedure TfrmReview.FormatListForScreenReader(Sender: TObject);
var
  aListView: TCaptionCheckListBox;
  i: Integer;
begin
  if ScreenReaderActive then
  begin
    aListView := Sender as TCaptionCheckListBox;

    if aListView.Count < 1 then
      Exit;
    for i := 0 to aListView.Count - 1 do
      if aListView.Items.Objects[i] <> nil then // Not a Group Title
      begin
        if aListView.Items.Objects[i] is TChangeItem then
          if aListView.Checked[i] then
            aListView.Items[i] := 'Checked ' +
              TChangeItem(aListView.Items.Objects[i]).Text
          else
            aListView.Items[i] := 'Not Checked ' +
              TChangeItem(aListView.Items.Objects[i]).Text;
      end;
    if aListView.ItemIndex >= 0 then
      aListView.Selected[aListView.ItemIndex] := True;
  end;
end;

end.
