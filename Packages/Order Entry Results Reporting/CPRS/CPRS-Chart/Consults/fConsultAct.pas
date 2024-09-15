unit fConsultAct;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, System.Actions, Vcl.ActnList, ComCtrls,
  ORFN, ORCtrls, ORDtTm, fBase508Form, VA508AccessibilityManager, oDST;

type
  TfrmConsultAction = class(TfrmBase508Form)
    lblActionBy: TOROffsetLabel;
    calDateofAction: TORDateBox;
    lblDateofAction: TOROffsetLabel;
    cboPerson: TORComboBox;
    memComments: TCaptionMemo;
    lblComments: TOROffsetLabel;
    lblToService: TOROffsetLabel;
    cboAttentionOf: TORComboBox;
    lblAttentionOf: TOROffsetLabel;
    lblUrgency: TOROffsetLabel;
    cmdOK: TORAlignButton;
    cmdCancel: TORAlignButton;
    cboUrgency: TORComboBox;
    pnlBase: TPanel;
    pnlForward: TPanel;
    pnlOther: TPanel;
    treService: TORTreeView;
    pnlComments: TPanel;
    pnlAllActions: TPanel;
    grpSigFindings: TRadioGroup;
    pnlSigFind: TPanel;
    cboService: TORComboBox;
    pnlAlert: TPanel;
    ckAlert: TCheckBox;
    Label1: TMemo;
    lblAutoAlerts: TStaticText;
    pnlButtons: TPanel;
    pnlActionDate: TPanel;
    pnlActionBy: TPanel;
    btnLaunchToolbox: TButton;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure NewPersonNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure ProviderNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure ckAlertClick(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure cboServiceSelect(Sender: TObject);
    procedure grpSigFindingsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DstMgrbtnLaunchToolboxClick(Sender: TObject); { **REV** }
    procedure ControlChange(Sender: TObject);
    procedure btnLaunchToolboxClick(Sender: TObject);
    procedure ORFormResize(Sender: TObject);
  private
    FActionType: Integer;
    FChanged: boolean;
    FActionDate: TFMDateTime;
    FToService: Integer;
    FAttentionOf: Int64;
    FUrgency: Integer;
    FIsProcedure: boolean;
    FProcIEN: Integer;
    FUserLevel: Integer;
    FConsultService: string;
    FConsultUrgency: string;
    // FActionBy: Int64;   - replaced with local var
    // FSigFind: string;   - replaced with local var
    // FComments: TStrings;- replaced with local var
    // FAlert: Integer;    - replaced with local var
    // FAlertTo: string;   - replaced with local var
    // FUserIsRequester: boolean; - replaced with local var

    function SetupForward(IsProcedure: boolean; ProcIEN: Integer): boolean;
    procedure SetupAddComment;
    procedure SetupAdminComplete;
    procedure SetupSigFindings;
    procedure SigFindPanelShow;
    procedure SetupReceive;
    procedure SetupSchedule;
    procedure SetupOther(action: integer);

    function ValidInput: boolean;
    function Submit: boolean;
    function getAutoAlertText: String;
    procedure setAutoAlerts(bVisible: boolean);
    procedure setActions(bVisible: boolean; aTitle: String = '');
    procedure setComments;
    procedure setForward(bVisible: boolean);
    procedure setSigFindings(bVisible: boolean);
    procedure SetDstButton(action: integer);
    function ResizeLabels(aLabelObject: TObject) : TRect;
  end;

function SetActionContext(FontSize: Integer; ActionCode: Integer;
  IsProcedure: boolean; ProcID: string; UserLevel: Integer;
  ConsService: string; ConsultUrgency: string): boolean;

const
  TX_FWD_NO_CSLT_SVCS_TEXT =
    'There are no services that you can forward this consult to';
  TX_FWD_NO_PROC_SVCS_TEXT =
    'There are no additional services that can perform this procedure.';
  TX_NOTTHISSVC_TEXT =
    'Consults cannot be forwarded to this service. Please select a subspecialty';
  TX_NOFORWARD_TEXT = 'Service must be specified.';
  TX_NOFORWARD_SELF =
    'A consult cannot be forwarded to the same service already responsible.';
  TX_NOFORWARD_CAP = 'Unable to forward';
  TX_NOURGENCY_TEXT = 'Urgency must be specified';
  TX_PERSON_TEXT = 'Select a person to perform this action or press Cancel.';
  TX_PERSON_CAP = 'Missing person';
  TX_DATE_TEXT = 'Enter a valid date for this action.';
  TX_DATE_CAP = 'Invalid date';
  TX_FUTDATE_TEXT = 'Dates or times in the future are not allowed.';
  TX_COMMENTS_TEXT = 'Comments are required for this action.';
  TX_COMMENTS_CAP = 'No comments entered';
  TX_SIGFIND_TEXT = 'A significant findings selection is required.';
  TX_SIGFIND_CAP = 'No significant findings status entered';

implementation

{$R *.DFM}

uses
  VAUtils, fConsultAlertTo, rCore, rConsults, uConsults, fConsults, rOrders,
  uCore, uORLists, uSimilarNames, uDstConst;

var
  uChanging: boolean;
  RecipientList: TRecipientList;

const
  _SigFindingsCaption = 'Significant Findings - Current status:';

function SetActionContext(FontSize: Integer; ActionCode: Integer;
  IsProcedure: boolean; ProcID: string; UserLevel: Integer;
  ConsService: string; ConsultUrgency: string): boolean;
{ displays action input form for consults and sets up broker calls }
var
  frmConsultAction: TfrmConsultAction;
begin
  Result := False;
  frmConsultAction := TfrmConsultAction.Create(Application);
  try
    ResizeAnchoredFormToFont(frmConsultAction);
    with frmConsultAction do
    begin
      FChanged := False;

      Caption := ActionType[ActionCode];
      FActionType := ActionCode;

      FIsProcedure := IsProcedure;
      FProcIEN := StrToIntDef(Piece(ProcID, ';', 1), 0);
      FUserLevel := UserLevel;
      FConsultService := ConsService;
      FConsultUrgency := ConsultUrgency;
      // FUserIsRequester := (User.DUZ = ConsultRec.SendingProvider);
      RecipientList.Recipients := '';
      RecipientList.Changed := False;

      case FActionType of
        CN_ACT_FORWARD:
          if not SetupForward(FIsProcedure, FProcIEN) then
            exit;
        CN_ACT_ADD_CMT:
          SetupAddComment;
        CN_ACT_ADMIN_COMPLETE:
          SetupAdminComplete;
        CN_ACT_SIGFIND:
          SetupSigFindings;
        CN_ACT_RECEIVE:
          SetupReceive;
        CN_ACT_SCHEDULE:
          SetupSchedule;
      else
        SetupOther(ActionCode);
      end;
      GetDSTMgr.DSTMode := GetDSTMgr.DstProvider.DstMode;
      GetDSTMgr.DSTService := ConsService;
      GetDSTMgr.DSTUrgency := ConsultUrgency;
      GetDSTMgr.DSTAction := FActionType;
      GetDstMgr.DSTId := ConsultRec.DstID;

      ShowModal;
      Result := FChanged;
    end;
  finally
    frmConsultAction.Release;
  end;
end;

procedure TFrmConsultAction.SetDstButton(action: integer);
begin
  GetDstMgr.DstAction := action;
  btnLaunchToolbox.Visible := GetDstMgr.DSTBtnVisible;
end;
// =================== Setup form for different actions ===========================

function TfrmConsultAction.SetupForward(IsProcedure: boolean;
  ProcIEN: Integer): boolean;
var
  SvcList: TStrings;
  i: Integer;
  OrdItmIEN: Integer;
  attention: string; // wat cq 15561
  AList: TStringList; { WAT cq 19626 }
begin
  AList := TStringList.Create;
  SvcList := TStringList.Create;
  try { WAT cq 19626 }
    if IsProcedure then
    begin
      OrdItmIEN := GetOrderableIEN(IntToStr(ConsultRec.ORFileNumber));

//      FastAssign(GetProcedureServices(OrdItmIEN), SvcList);
      // FastAssign(GetProcedureServices(ProcIEN), SvcList);   RPC expects pointer to 101.43, NOT 123.3  (RV)
      setProcedureServices(SvcList, OrdItmIEN);
      i := SvcList.IndexOf(IntToStr(ConsultRec.ToService) + U +
        Trim(ExternalName(ConsultRec.ToService, 123.5)));
      if i > -1 then
        SvcList.Delete(i);
      treService.Visible := False;
    end
    else
//      FastAssign(LoadServiceListWithSynonyms(CN_SVC_LIST_FWD, ConsultRec.IEN),
//        SvcList); { RV }
      setServiceListWithSynonyms(SvcList,CN_SVC_LIST_FWD, ConsultRec.IEN);

    if (IsProcedure and (SvcList.Count <= 0)) then
    begin
      InfoBox(TX_FWD_NO_PROC_SVCS_TEXT, TX_NOFORWARD_CAP,
        MB_OK or MB_ICONWARNING);
      Result := False;
      exit;
    end
    else if ((not IsProcedure) and
      ((SvcList.Count <= 0) or (Piece(SvcList.Strings[0], U, 1) = '-1'))) then
    begin
      InfoBox(TX_FWD_NO_CSLT_SVCS_TEXT, TX_NOFORWARD_CAP,
        MB_OK or MB_ICONWARNING);
      Result := False;
      exit;
    end
    else
    begin
      FastAssign(SvcList, AList); { WAT cq 19626 }
      SortByPiece(AList, U, 2); { WAT cq 19626 }
      // SortByPiece(TStringList(SvcList), U, 2);                                   {RV}
      for i := 0 to SvcList.Count - 1 do
        if (cboService.Items.IndexOf(Trim(Piece(SvcList.Strings[i], U, 2)))
          = -1) and { RV }
          (Piece(SvcList.Strings[i], U, 5) <> '1') then
         cboService.Items.Add(SvcList.Strings[i]);
     if not IsProcedure then
       begin
         BuildServiceTree(treService, SvcList) ;
         with treService do
         begin
           Items.BeginUpdate;
           try
             for i:=0 to Items.Count-1 do
             begin
               if Items[i].Level > 0 then
                 Items[i].Expanded := False
               else
                 Items[i].Expanded := True;
             end;
           finally
             Items.EndUpdate;
           end;
           if Items.Count > 0 then
           begin
             TopItem := Items[0] ;
             Selected := Items[0] ;
           end;
         end;
       end;
     pnlForward.Visible := True ;
   end ;
 if cboService.Items.Count = 1 then cboService.ItemIndex := 0;
 FToService := cboService.ItemIEN;
 //wat cq 15561
 //cboAttentionOf.InitLongList('') ;
 FAttentionOf := ConsultRec.Attention;
 attention := ExternalName(FAttentionOf,200);
 cboAttentionOf.InitLongList(attention);
 cboAttentionOf.SelectByIEN(FAttentionOf);
 TSimilarNames.RegORComboBox(cboAttentionOf);
 //end cq 15561
 with cboUrgency do
  begin
    setSubsetofUrgencies(cboUrgency.Items, ConsultRec.IEN);
    MixedCaseList(Items) ;
    SelectByIEN(ConsultRec.Urgency);
    if ItemIndex = -1 then
      begin
        for i := 0 to Items.Count - 1 do
          if DisplayText[i] = 'Routine' then
            break;
        ItemIndex := i;
      end;
    end;
    FUrgency := cboUrgency.ItemIEN;
{    if cboUrgency.Text = 'Special Instructions' then
      cboUrgency.Enabled := False
    else
    begin
      cboUrgency.Items.BeginUpdate;
      for i := cboUrgency.Items.Count - 1 downto 0 do
        if cboUrgency.DisplayText[i] = 'Special Instructions' then
          cboUrgency.Items.Delete(i);
      cboUrgency.Items.EndUpdate;
    end;
}
    setSigFindings(False); // pnlSigFind.Visible := False;
    setAutoAlerts(False);
    setActions(True, 'Responsible Person');
    setComments;

    SetDstButton(CN_ACT_FORWARD);

    Result := True;
  finally
    AList.Free; { WAT cq 19626 }
    SvcList.Free;
  end;
end;

procedure TfrmConsultAction.SetupAddComment;
begin
  setForward(False);
  setSigFindings(False); // pnlSigFind.Visible := False;
  setAutoAlerts(True);
  setActions(True);
  setComments;
  // btnLaunchToolbox.Enabled := isCtbEnabled;
  //add comment always gets a DST or CTB button, unless Switch is Off
  SetDstButton(CN_ACT_ADD_CMT);
  ActiveControl := memComments;
end;

procedure TfrmConsultAction.SetupSchedule;
begin
  setForward(False);
  setSigFindings(False); // pnlSigFind.Visible := False;
  setAutoAlerts(True);
  setActions(True, 'Responsible Person');
  setComments;
  SetDstButton(CN_ACT_SCHEDULE);
  ActiveControl := memComments;
end;

procedure TfrmConsultAction.SetupAdminComplete;
begin
  setForward(False);
  setSigFindings(True);
  setAutoAlerts(False);
  setActions(True, 'Responsible Person');
  setComments;
  (* if not FUserIsRequester then RecipientList.Recipients := IntToStr(ConsultRec.SendingProvider);
    RecipientList.Changed := not FUserIsRequester; *)
  SetDstButton(CN_ACT_ADMIN_COMPLETE);
  ActiveControl := memComments;
end;

procedure TfrmConsultAction.SetupSigFindings;
begin
  setForward(False);
  setSigFindings(True);
  setAutoAlerts(True);
  setActions(True);
  setComments;
  SetDstButton(CN_ACT_SIGFIND);
  ActiveControl := memComments;
end;

procedure TfrmConsultAction.SetupReceive;
begin
  setForward(False);
  setSigFindings(False);
  setAutoAlerts(False);
  setActions(True);
  pnlComments.Visible := True;
  // no Clear?                                                            // V14?
  SetDstButton(CN_ACT_RECEIVE);
  ActiveControl := calDateofAction;
end;

procedure TfrmConsultAction.SetupOther(action: integer);
begin
  setForward(False);
  setSigFindings(False);
  setAutoAlerts(False);
  setActions(True);
  setComments;
  case action of
    CN_ACT_DENY:
      SetDstButton(CN_ACT_DENY);
    CN_ACT_DISCONTINUE:
      SetDstButton(CN_ACT_DISCONTINUE);
  end;
  ActiveControl := memComments;
end;

// ============================= Control events ================================

procedure TfrmConsultAction.NewPersonNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
  cbo: TORComboBox;

begin
  inherited;
  sl := TStringList.Create;
  try
    cbo := (Sender as TORComboBox);
    setSubSetOfPersons(cbo, sl, StartFrom, Direction);
    cbo.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmConsultAction.ORFormResize(Sender: TObject);
var
  ARect: TRect;
begin
  if FActionType = CN_ACT_ADD_CMT then
  begin
    aRect := ResizeLabels(lblAutoAlerts);
    lblAutoAlerts.Height := aRect.Height;
  end;
  inherited;
end;

procedure TfrmConsultAction.ProviderNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
  cbo: TORComboBox;

begin
  inherited;
  sl := TStringList.Create;
  try
    cbo := (Sender as TORComboBox);
    setSubSetOfProviders(cbo, sl, StartFrom, Direction);
    cbo.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmConsultAction.cmdCancelClick(Sender: TObject);
begin
  FChanged := False;
  Close;
end;

function TfrmConsultAction.ValidInput: boolean;
var
  aErrMsg: String;
begin
  Result := False;
  if (cboPerson.ItemIEN = 0) and (FActionType <> CN_ACT_ADD_CMT) and
    (FActionType <> CN_ACT_SIGFIND) then
  begin
    InfoBox(TX_PERSON_TEXT, TX_PERSON_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end else begin
    if not CheckForSimilarName(cboPerson, aErrMsg, sPr) then
    begin
      if Trim(aErrMsg) = '' then
        InfoBox(TX_PERSON_TEXT, TX_PERSON_CAP, MB_OK or MB_ICONWARNING)
      else
        InfoBox(aErrMsg, 'Similiar Name Selection', MB_OK or MB_ICONWARNING);
      Exit;
    end;
  end;

  if (cboAttentionOf.ItemIEN <> 0) then
  begin
    if not CheckForSimilarName(cboAttentionOf, aErrMsg, sPr) then
    begin
      ShowMsgOn(Trim(aErrMsg) <> '', aErrMsg, 'Similiar Name Selection');
      Exit;
    end;
  end;
  //////////////////////////////////////////////////////

  if ((FActionType = CN_ACT_SIGFIND) or (FActionType = CN_ACT_ADMIN_COMPLETE))
    and (grpSigFindings.ItemIndex < 0) then
  begin
    InfoBox(TX_SIGFIND_TEXT, TX_SIGFIND_CAP, MB_OK or MB_ICONWARNING);
    exit;
  end;

  if ((FActionType = CN_ACT_DENY) or (FActionType = CN_ACT_DISCONTINUE) or
    (FActionType = CN_ACT_ADD_CMT) or (FActionType = CN_ACT_ADMIN_COMPLETE)) and
    (memComments.Lines.Count = 0) then
  begin
    InfoBox(TX_COMMENTS_TEXT, TX_COMMENTS_CAP, MB_OK or MB_ICONWARNING);
    exit;
  end;

  if (FActionType = CN_ACT_FORWARD) then
  begin
    if (FIsProcedure and (cboService.ItemIndex = -1) and (FToService = 0)) or
      ((not FIsProcedure) and (treService.Selected = nil) and (FToService = 0))
    then
    begin
      InfoBox(TX_NOFORWARD_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
      exit;
    end;
    if (not FIsProcedure) and (cboService.ItemIEN = ConsultRec.ToService) then
    begin
      InfoBox(TX_NOFORWARD_SELF, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
      exit;
    end;
    if cboUrgency.ItemIEN = 0 then
    begin
      InfoBox(TX_NOURGENCY_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
      exit;
    end;
    if (FIsProcedure and (Piece(cboService.Items[cboService.ItemIndex], U,
      5) = '1')) or ((not FIsProcedure) and
      (Piece(TORTreeNode(treService.Selected).StringData, U, 5) = '1')) then
    begin
      InfoBox(TX_NOTTHISSVC_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
      exit;
    end;
  end;

  if calDateofAction.Text <> '' then
  begin
    FActionDate := StrToFMDateTime(calDateofAction.Text);
    if FActionDate = -1 then
    begin
      InfoBox(TX_DATE_TEXT, TX_DATE_CAP, MB_OK or MB_ICONWARNING);
      calDateofAction.SetFocus;
      exit;
    end
    else if FActionDate > FMNow then
    begin
      InfoBox(TX_FUTDATE_TEXT, TX_DATE_CAP, MB_OK or MB_ICONWARNING);
      calDateofAction.SetFocus;
      exit;
    end;
  end
  else
    FActionDate := FMNow;

  Result := True;
end;

procedure TfrmConsultAction.cmdOKClick(Sender: TObject);
begin
  FChanged := False;
  if ValidInput then
  begin
    FChanged := Submit;
    Close;
  end;
end;

procedure TfrmConsultAction.ControlChange(Sender: TObject);
begin
  if GetDstMgr.DSTMode <> DST_OTH then
    btnLaunchToolbox.Enabled := (memComments.GetTextLen = 0) or
      (not ContainsVisibleChar(memComments.Text));
end;

procedure TfrmConsultAction.DstMgrbtnLaunchToolboxClick(Sender: TObject);
{User either enters manual comments during the action, or uses the DST/CTB
tool; not both.}
begin
  if GetDstMgr.DSTMode <> DST_OTH then
  begin
    GetDstMgr.doDst; // DST_CASE_CONSULT_ACT
    if GetDstMgr.DSTResult <> '' then
    begin
      memComments.Lines.Add(GetDstMgr.DSTResult);
      memComments.ReadOnly := True;
    end
  end;
end;

procedure TfrmConsultAction.FormCreate(Sender: TObject);
begin
  inherited;
  GetDstMgr(DST_CASE_CONSULT_ACT); // init DST manager with the case name
end;

procedure TfrmConsultAction.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeDSTMgr;
end;

function TfrmConsultAction.Submit: boolean;
var
  FActionBy: Int64;
  FSigFind: string;
  FComments: TStrings;
  FAlert: Integer;
  FAlertTo: string;
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    FActionBy := cboPerson.ItemIEN;
    FAttentionOf := cboAttentionOf.ItemIEN;
    FUrgency := cboUrgency.ItemIEN;
    if (FActionType = CN_ACT_SIGFIND) or (FActionType = CN_ACT_ADMIN_COMPLETE)
    then
      FSigFind := Copy(grpSigFindings.Items[grpSigFindings.ItemIndex], 2, 1);

    LimitEditWidth(memComments, 74);
    FComments := memComments.Lines;

    if ((ckAlert.Checked) (* or (FActionType = CN_ACT_ADMIN_COMPLETE) *) ) and
      RecipientList.Changed then
    begin
      FAlert := 1;
      FAlertTo := RecipientList.Recipients;
    end
    else
    begin
      FAlert := 0;
      FAlertTo := '';
    end;

    case FActionType of
      CN_ACT_RECEIVE:
        ReceiveConsult(AList, ConsultRec.IEN, FActionBy, FActionDate,
          FComments);
      CN_ACT_SCHEDULE:
        ScheduleConsult(AList, ConsultRec.IEN, FActionBy, FActionDate, FAlert,
          FAlertTo, FComments);
      CN_ACT_DENY:
        DenyConsult(AList, ConsultRec.IEN, FActionBy, FActionDate, FComments);
      CN_ACT_DISCONTINUE:
        DiscontinueConsult(AList, ConsultRec.IEN, FActionBy, FActionDate,
          FComments);
      CN_ACT_FORWARD:
        ForwardConsult(AList, ConsultRec.IEN, FToService, FActionBy,
          FAttentionOf, FUrgency, FActionDate, FComments);
      CN_ACT_ADD_CMT:
        AddComment(AList, ConsultRec.IEN, FComments, FActionDate, FAlert,
          FAlertTo);
      CN_ACT_SIGFIND:
        SigFindings(AList, ConsultRec.IEN, FSigFind, FComments, FActionDate,
          FAlert, FAlertTo);
      CN_ACT_ADMIN_COMPLETE:
        AdminComplete(AList, ConsultRec.IEN, FSigFind, FComments, FActionBy,
          FActionDate, FAlert, FAlertTo);
    end;

    if AList.Count > 0 then
    begin
      if StrToInt(Piece(AList[0], U, 1)) > 0 then
      begin
        InfoBox(Piece(AList[0], U, 2), 'Unable to ' + ActionType[FActionType],
          MB_OK or MB_ICONWARNING);
        // FChanged := False;
        Result := False;
      end
      else
        // FChanged := True;
        Result := True;
    end
    else
      // FChanged := True;
      Result := True;
  finally
    AList.Free;
  end;
  // Close;
end;

procedure TfrmConsultAction.ckAlertClick(Sender: TObject);
begin
  if ckAlert.Checked then
    SelectRecipients(Font.Size, FActionType, RecipientList);
end;

procedure TfrmConsultAction.treServiceChange(Sender: TObject; Node: TTreeNode);
begin
  if uChanging or FIsProcedure then
    exit;
  if not assigned(treService.Selected) then
  begin
    FToService := 0;
    cboService.ItemIndex := -1;
    exit;
  end;
  FToService := StrToIntDef(Piece(TORTreeNode(treService.Selected).StringData,
    U, 1), 0);
  (* if (treService.Selected.Data <> nil) and (Piece(string(treService.Selected.Data), U, 5) <> '1') then
    cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1)) *)
  // cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1));
  cboService.ItemIndex := cboService.Items.IndexOf
    (Trim(treService.Selected.Text)); { RV }
  ActiveControl := cboService; { RV }
end;

procedure TfrmConsultAction.btnLaunchToolboxClick(Sender: TObject);
var
  HelpText: String;
begin
  inherited;
  if GetDSTMgr.DSTMode <> DST_OTH then
  begin
    if ConsultRec.InOut = 'O' then
      GetDSTMgr.DSTOutpatient := 'True'
    else
      GetDSTMgr.DSTOutpatient := 'False';
    GetDSTMgr.doDst; // DST_CASE_CONSULT_ACT
    if (GetDSTMgr.DSTResult <> '') and
      (Pos('Error', GetDSTMgr.DSTResult) <> 1) then
    begin
      memComments.Lines.Add(GetDSTMgr.DSTResult);
      memComments.ReadOnly := True;
    end
    else if Pos('Error', GetDSTMgr.DSTResult) = 1 then
    begin
      HelpText := GetUserParam('OR CPRS HELP DESK TEXT');
      if HelpText <> '' then
        InfoBox(DST_UNAVAIL + CRLF + DST_TRY_LATER + CRLF + CRLF + HelpText +
          CRLF + GetDSTMgr.DSTResult, 'Communication Error',
          MB_OK or MB_ICONERROR)
      else
        InfoBox(DST_UNAVAIL + CRLF + DST_TRY_LATER + CRLF + CRLF + DST_PERSIST +
          CRLF + GetDSTMgr.DSTResult, 'Communication Error',
          MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TfrmConsultAction.cboServiceSelect(Sender: TObject);
var
  i: Integer;
begin
  if not FIsProcedure then
  begin
    uChanging := True; // BeginUpdate?
    treService.Selected := nil;
    with treService do
      for i := 0 to Items.Count - 1 do
      begin
        if Piece(TORTreeNode(Items[i]).StringData, U, 1) = cboService.ItemID
        then
        begin
          Selected := Items[i];
          // treServiceChange(Self, Items[i]);
          break;
        end;
      end;
    uChanging := False; // EndUpdate?
    if assigned(treService.Selected) then
      FToService := StrToIntDef(Piece(TORTreeNode(treService.Selected).StringData,
        U, 1), 0)
    else
      FToService := 0;
  end
  else
    FToService := cboService.ItemIEN;
end;

function TfrmConsultAction.getAutoAlertText: String;
const
  TX_ALERT1 = 'An alert will automatically be sent to ';
  TX_ALERT_PROVIDER = 'the ordering provider';
  TX_ALERT_SVC_USERS = 'notification recipients for this service.';
  TX_ALERT_NOBODY = 'No automatic alerts will be sent.';
  // this should be rare to never
  TX_ALERT_ADD_CMT ='Only alert Providers when their action is required.'
      + CRLF + '++ NOTE: To alert Provider use "Send additional alerts" ' +
      'option below, or use Significant Findings. ++';
var
  b: boolean;
  x: string;
begin
  Result := '';

  b := (User.DUZ = ConsultRec.SendingProvider); // b := FUserIsRequester;

  case FUserLevel of
    UL_NONE, UL_REVIEW:
      begin
        if b then
          x := TX_ALERT1 + TX_ALERT_SVC_USERS
        else
          x := TX_ALERT1 + TX_ALERT_PROVIDER + ' and to ' + TX_ALERT_SVC_USERS;
      end;
    UL_UPDATE, UL_ADMIN, UL_UPDATE_AND_ADMIN:
      begin
        if b then
          // x := TX_ALERT_NOBODY   Replace with following line
          x := TX_ALERT1 + TX_ALERT_SVC_USERS
        else
          x := TX_ALERT1 + TX_ALERT_PROVIDER + '.';
      end;
    UL_UNRESTRICTED:
      begin
        if b then
          x := TX_ALERT1 + TX_ALERT_SVC_USERS
        else
          x := TX_ALERT1 + TX_ALERT_PROVIDER + ' and to ' + TX_ALERT_SVC_USERS;
      end;
  end;
  (*Alter caption text when adding a comment to a consult. Addresses a patient
    safety issue when comments are added to a consult and the caption
    implies that the ordering provider will automatically receive the alert.
    HITPS-2453*)
  if (FActionType = CN_ACT_ADD_CMT) then
    begin
      if ScreenReaderActive then
        x := StringReplace(TX_ALERT_ADD_CMT,'++','',[rfReplaceAll])
      else
        x := TX_ALERT_ADD_CMT;
    end;
  Result := x;
end;

procedure TfrmConsultAction.grpSigFindingsClick(Sender: TObject);
begin
  inherited;
  exit; // disabling for now
  grpSigFindings.Caption := _SigFindingsCaption + ' ' + grpSigFindings.Items
    [grpSigFindings.ItemIndex];
end;

procedure TfrmConsultAction.setAutoAlerts(bVisible: boolean);
begin
  // If needed this procedure can be updated to handle visibility of
  // panels within pnlAlert
  pnlAlert.Visible := bVisible;
  if bVisible then
  begin
    lblAutoAlerts.Caption := getAutoAlertText;
    //Two lines of alert text for add comment; see getAutoAlertText
    pnlAlert.Height := ckAlert.Height + lblAutoAlerts.Height + 6;
  end;
end;

function TfrmConsultAction.ResizeLabels(aLabelObject: TObject) : TRect;
var
  aDummyLbl: TLabel;
  lText: String;
begin
  aDummyLbl := TLabel.Create(self);
  try
    if aLabelObject is TStaticText then
    begin
      aDummyLbl.Parent := TStaticText(aLabelObject).Parent;
      aDummyLbl.Align := alClient;
      aDummyLbl.Caption := TStaticText(aLabelObject).Caption;
      aDummyLbl.WordWrap := True;
    end else if aLabelObject is TLabel then
    begin
      aDummyLbl.Parent := TLabel(aLabelObject).Parent;
      aDummyLbl.Align := alClient;
      aDummyLbl.Caption := TLabel(aLabelObject).Caption;
      aDummyLbl.WordWrap := True;
    end else raise Exception.Create('aLabelObject is not TStaticText or Tlabel');

    lText := aDummyLbl.Caption;
    Result.Left := 0;
    Result.Right := aDummyLbl.Width;
    Result.Top := 0;
    Result.Bottom := 0;
    aDummyLbl.Canvas.TextRect(Result, lText, [tfCalcRect, tfWordBreak]);
  Finally
    aDummyLbl.Free;
  End;
end;

procedure TfrmConsultAction.setActions(bVisible: boolean; aTitle: String = '');
begin
  pnlAllActions.Visible := bVisible;
  if bVisible then
  begin
    if aTitle <> '' then
      lblActionBy.Caption := aTitle;

    cboPerson.Caption := lblActionBy.Caption;
    cboPerson.OnNeedData := NewPersonNeedData; //
    cboPerson.InitLongList(User.Name);
    cboPerson.SelectByIEN(User.DUZ);
    TSimilarNames.RegORComboBox(cboPerson);
    if FActionType in [CN_ACT_ADD_CMT, CN_ACT_SIGFIND] then
      pnlActionBy.Visible := False;
  end;
end;

procedure TfrmConsultAction.setComments;
begin
  // Comments are always used.
  // Adding this procedure for consistentcy of setup
  pnlComments.Visible := True;
  memComments.Clear;
end;

procedure TfrmConsultAction.setForward(bVisible: boolean);
begin
  pnlForward.Visible := bVisible;
  // If needed - add correction of the form width
  // if not bVisible then
  // with frmConsultAction do Width := Width - pnlForward.Width ;
end;

procedure TfrmConsultAction.SigFindPanelShow;
var
  i: Integer;
begin
  pnlSigFind.Visible := True;
  with grpSigFindings do
  begin
    for i := 0 to 2 do
      if Copy(Items[i], 1, 1) = ConsultRec.Findings then
        ItemIndex := i;
    if ItemIndex = -1 then
    begin
      ItemIndex := 2;
      Caption := _SigFindingsCaption + 'Not yet entered';
    end
    else
      Caption := _SigFindingsCaption + Items[ItemIndex];
  end;
end;

procedure TfrmConsultAction.setSigFindings(bVisible: boolean);
begin
  pnlSigFind.Visible := bVisible;
  if bVisible then
    SigFindPanelShow
end;

end.
