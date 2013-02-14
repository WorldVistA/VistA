unit fConsultAct;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORFN,
  StdCtrls, ExtCtrls, ORCtrls, uCore, ComCtrls, ORDtTm, fBase508Form,
  VA508AccessibilityManager;

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
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure NewPersonNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure ProviderNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure ckAlertClick(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure treServiceExit(Sender: TObject);
    procedure cboServiceSelect(Sender: TObject);           {**REV**}
  private
     FActionType: integer ;
     FChanged: boolean ;
     FActionBy: Int64;
     FActionDate: TFMDateTime;
     FToService: integer ;
     FAttentionOf: int64 ;
     FUrgency: integer ;
     FSigFind: string;
     FComments: TStrings ;
     FAlert: integer ;
     FAlertTo: string ;
     FIsProcedure: boolean;
     FProcIEN: integer;
     FUserLevel: integer;
     FUserIsRequester: boolean;
     function SetupForward(IsProcedure: boolean; ProcIEN: integer): boolean;
     procedure SetupAddComment;
     procedure SetupAdminComplete;
     procedure SetupSigFindings;
     procedure SigFindPanelShow;
     procedure SetupReceive;
     procedure SetupSchedule;
     procedure SetupOther;
     procedure ShowAutoAlertText;
  end;

function SetActionContext(FontSize: Integer; ActionCode: integer; IsProcedure: boolean; ProcID: string; UserLevel: integer): boolean;

var
  frmConsultAction: TfrmConsultAction;
  SvcList: TStrings ;
  uChanging: Boolean;

const
  TX_FWD_NO_CSLT_SVCS_TEXT = 'There are no services that you can forward this consult to' ;
  TX_FWD_NO_PROC_SVCS_TEXT = 'There are no additional services that can perform this procedure.' ;
  TX_NOTTHISSVC_TEXT = 'Consults cannot be forwarded to this service. Please select a subspecialty' ;
  TX_NOFORWARD_TEXT  = 'Service must be specified.' ;
  TX_NOFORWARD_SELF  = 'A consult cannot be forwarded to the same service already responsible.';
  TX_NOFORWARD_CAP   = 'Unable to forward' ;
  TX_NOURGENCY_TEXT  = 'Urgency must be specified';
  TX_PERSON_TEXT     = 'Select a person to perform this action or press Cancel.';
  TX_PERSON_CAP      = 'Missing person';
  TX_DATE_TEXT       = 'Enter a valid date for this action.' ;
  TX_DATE_CAP        = 'Invalid date' ;
  TX_FUTDATE_TEXT    = 'Dates or times in the future are not allowed.';
  TX_COMMENTS_TEXT   = 'Comments are required for this action.' ;
  TX_COMMENTS_CAP    = 'No comments entered' ;
  TX_SIGFIND_TEXT    = 'A significant findings selection is required.' ;
  TX_SIGFIND_CAP     = 'No significant findings status entered' ;

implementation

{$R *.DFM}

uses rCore, rConsults, uConsults, fConsults, fConsultAlertTo, rOrders;

var
  RecipientList: TRecipientList ;

function SetActionContext(FontSize: Integer; ActionCode: integer; IsProcedure: boolean; ProcID: string; UserLevel: integer): boolean;
{ displays action input form for consults and sets up broker calls }
begin
  Result := False;
  frmConsultAction := TfrmConsultAction.Create(Application);
  try
    ResizeAnchoredFormToFont(frmConsultAction);
    with frmConsultAction do
     begin
      //I wish I knew why the resize wasn't working on the buttons
      cmdCancel.Left := pnlAllActions.ClientWidth - cmdCancel.Width -7;
      cmdOK.Left := cmdCancel.Left - cmdOK.Width - 10;
      FChanged     := False;
      FActionType  := ActionCode ;
      FIsProcedure := IsProcedure;
      FProcIEN     := StrToIntDef(Piece(ProcID, ';', 1), 0);
      FUserLevel   := UserLevel;
      FUserIsRequester := (User.DUZ = ConsultRec.SendingProvider);
      Caption      := ActionType[ActionCode] ;
      RecipientList.Recipients    := '' ;
      RecipientList.Changed       := False ;

      case FActionType of
        CN_ACT_FORWARD:         if not SetupForward(FIsProcedure, FProcIEN) then exit;
        CN_ACT_ADD_CMT:         SetupAddComment;
        CN_ACT_ADMIN_COMPLETE:  SetupAdminComplete;
        CN_ACT_SIGFIND:         SetupSigFindings;
        CN_ACT_RECEIVE:         SetupReceive;
        CN_ACT_SCHEDULE:        SetupSchedule;
      else                      SetupOther;
      end;

      ShowModal ;
      Result := FChanged ;
     end ;
  finally
    frmConsultAction.Release;
  end;
end;

//=================== Setup form for different actions ===========================

function TfrmConsultAction.SetupForward(IsProcedure: boolean; ProcIEN: integer): boolean;
var
  i: integer;
  OrdItmIEN: integer;
  attention: string;                                                              //wat cq 15561
  AList: TStringList;                                                             {WAT cq 19626}
begin
 pnlSigFind.Visible := False;
 with frmConsultAction do Height := Height - pnlSigFind.Height;
 pnlComments.Visible := True;
 memComments.Clear;
 AList := TStringList.Create;
try                                                                               {WAT cq 19626}
 if IsProcedure then
   begin
     OrdItmIEN := GetOrderableIEN(IntToStr(ConsultRec.ORFileNumber));
     FastAssign(GetProcedureServices(OrdItmIEN), SvcList);
     //FastAssign(GetProcedureServices(ProcIEN), SvcList);   RPC expects pointer to 101.43, NOT 123.3  (RV)
     i := SvcList.IndexOf(IntToStr(ConsultRec.ToService) + U + Trim(ExternalName(ConsultRec.ToService, 123.5)));
     if i > -1 then SvcList.Delete(i);
     treService.Visible := False;
   end
 else
   FastAssign(LoadServiceListWithSynonyms(CN_SVC_LIST_FWD, ConsultRec.IEN), SvcList);           {RV}
 if (IsProcedure and (SvcList.Count <= 0)) then
   begin
     InfoBox(TX_FWD_NO_PROC_SVCS_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
     Result := False  ;
     Exit ;
   end
 else if ((not IsProcedure) and (Piece(SvcList.Strings[0],U,1) = '-1')) then
   begin
     InfoBox(TX_FWD_NO_CSLT_SVCS_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
     Result := False  ;
     Exit ;
   end
 else
   begin
     FastAssign(SvcList, AList);                                                  {WAT cq 19626}
     SortByPiece(AList, U, 2);                                                    {WAT cq 19626}
     //SortByPiece(TStringList(SvcList), U, 2);                                   {RV}
     for i := 0 to SvcList.Count - 1 do
        if (cboService.Items.IndexOf(Trim(Piece(SvcList.Strings[i], U, 2))) = -1) and   {RV}
          (Piece(SvcList.Strings[i], U, 5) <> '1') then
         cboService.Items.Add(SvcList.Strings[i]);
     if not IsProcedure then
       begin
         BuildServiceTree(treService, SvcList, '0', nil) ;
         with treService do
           for i:=0 to Items.Count-1 do
             begin
               if Items[i].Level > 0 then Items[i].Expanded := False
                 else Items[i].Expanded := True;
               TopItem := Items[0] ;
               Selected := Items[0] ;
             end ;
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
 //end cq 15561
 with cboUrgency do
  begin
    FastAssign(SubsetofUrgencies(ConsultRec.IEN), cboUrgency.Items) ;
    MixedCaseList(Items) ;
    SelectByIEN(ConsultRec.Urgency);
    if ItemIndex = -1 then
      begin
        for i := 0 to Items.Count-1 do
          if DisplayText[i] = 'Routine' then break ;
        ItemIndex := i ;
      end;
  end ;
  FUrgency := cboUrgency.ItemIEN;
  //lblActionBy.Caption := 'Responsible Clinician';  //  v20.1 RV
  //cboPerson.OnNeedData := ProviderNeedData;        //
  lblActionBy.Caption := 'Responsible Person';       //
  cboPerson.Caption := lblActionBy.Caption;
  cboPerson.OnNeedData := NewPersonNeedData;         //
  cboPerson.InitLongList(User.Name)  ;
  cboPerson.SelectByIEN(User.DUZ);
  ckAlert.Visible := False ;
  lblAutoAlerts.Visible := False;
  Result := True;
finally
  AList.Free;                                                                      {WAT cq 19626}
end;
end;

procedure TfrmConsultAction.SetupAddComment;
begin
  pnlForward.Visible := False ;
  //with frmConsultAction do Width := Width - pnlForward.Width ;
  pnlSigFind.Visible := False;
  with frmConsultAction do Height := Height - pnlSigFind.Height;
  ckAlert.Visible             := True ;
  lblAutoAlerts.Visible       := True;
  ShowAutoAlertText;
(*  RecipientList.Recipients    := '' ;
  RecipientList.Changed       := False ;*)
  lblActionBy.Visible         := False ;
  cboPerson.Visible           := False ;
  pnlComments.Visible := True;
  memComments.Clear;
  ActiveControl := memComments ;
end;

procedure TfrmConsultAction.SetupSchedule;
begin
  pnlForward.Visible := False ;
  //with frmConsultAction do Width := Width - pnlForward.Width ;
  pnlSigFind.Visible := False;
  with frmConsultAction do Height := Height - pnlSigFind.Height;
  ckAlert.Visible             := True ;
  lblAutoAlerts.Visible       := True;
  ShowAutoAlertText;
(*  RecipientList.Recipients    := '' ;
  RecipientList.Changed       := False ;*)
  lblActionBy.Visible         := True ;
  cboPerson.Visible           := True ;
  lblActionBy.Caption := 'Responsible Person';
  cboPerson.Caption := lblActionBy.Caption;
  cboPerson.OnNeedData := NewPersonNeedData;
  cboPerson.InitLongList(User.Name)  ;
  cboPerson.SelectByIEN(User.DUZ);
  pnlComments.Visible := True;
  memComments.Clear;
  ActiveControl := memComments ;
end;

procedure TfrmConsultAction.SetupAdminComplete;
begin
  SigFindPanelShow ;
  pnlForward.Visible := False ;
  //with frmConsultAction do Width := Width - pnlForward.Width ;
  ckAlert.Visible             := False ;
  lblAutoAlerts.Visible       := False;

  //lblActionBy.Caption := 'Responsible Provider';
  //cboPerson.OnNeedData := ProviderNeedData;   //RIC-0100-21228 - need ALL users here
  //cboPerson.InitLongList('')  ;
  //cboPerson.ItemIndex := -1;
  lblActionBy.Caption := 'Responsible Person';
  cboPerson.Caption := lblActionBy.Caption;
  cboPerson.OnNeedData := NewPersonNeedData;
  cboPerson.InitLongList(User.Name)  ;
  cboPerson.SelectByIEN(User.DUZ);

  pnlComments.Visible := True;
  memComments.Clear;
(*  if not FUserIsRequester then RecipientList.Recipients := IntToStr(ConsultRec.SendingProvider);
  RecipientList.Changed := not FUserIsRequester;*)
  ActiveControl := memComments ;
end;

procedure TfrmConsultAction.SetupSigFindings;
begin
  SigFindPanelShow ;
  pnlForward.Visible := False ;
  //with frmConsultAction do Width := Width - pnlForward.Width ;
  ckAlert.Visible             := True ;
  lblAutoAlerts.Visible       := True;
  ShowAutoAlertText;
(*  RecipientList.Recipients    := '' ;
  RecipientList.Changed       := False ;*)
  lblActionBy.Visible         := False ;
  cboPerson.Visible           := False ;
  pnlComments.Visible := True;
  memComments.Clear;
  ActiveControl := memComments ;
end;

procedure TfrmConsultAction.SigFindPanelShow;
var
  i: integer;
begin
  pnlSigFind.Visible := True;        
  with grpSigFindings do        
    begin
      for i := 0 to 2 do if Copy(Items[i],1,1)=ConsultRec.Findings then ItemIndex := i ;
      if ItemIndex = -1 then        
        begin
          ItemIndex := 2;        
          Caption := Caption + 'Not yet entered';
        end
      else        
        Caption := Caption + Items[ItemIndex];
    end;
end ;

procedure TfrmConsultAction.SetupReceive;
begin
  pnlForward.Visible := False ;
  //with frmConsultAction do Width := Width - pnlForward.Width ;
  pnlComments.Visible := True;                                                              // V14?
  ckAlert.Visible := False ;
  lblAutoAlerts.Visible := False;
  pnlSigFind.Visible := False;
  with frmConsultAction do Height := Height - pnlSigFind.Height;// - pnlComments.Height ;   // V14?
  cboPerson.OnNeedData := NewPersonNeedData;
  cboPerson.InitLongList(User.Name)  ;
  cboPerson.SelectByIEN(User.DUZ);        
  ActiveControl := calDateOfAction;
end;

procedure TfrmConsultAction.SetupOther;
begin
  pnlForward.Visible := False ;
  //with frmConsultAction do Width := Width - pnlForward.Width ;
  pnlSigFind.Visible := False;
  with frmConsultAction do Height := Height - pnlSigFind.Height;
  lblActionBy.Caption := 'Action by';
  cboPerson.Caption := lblActionBy.Caption;
  cboPerson.OnNeedData := NewPersonNeedData;
  cboPerson.InitLongList(User.Name)  ;        
  cboPerson.SelectByIEN(User.DUZ);
  ckAlert.Visible := False ;        
  lblAutoAlerts.Visible := False;
  pnlComments.Visible := True;
  memComments.Clear;
  ActiveControl := memComments ;
end;

// ============================= Control events ================================

procedure TfrmConsultAction.NewPersonNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  inherited;
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmConsultAction.ProviderNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  inherited;
  (Sender as TORComboBox).ForDataUse(SubSetOfProviders(StartFrom, Direction));
end;

procedure TfrmConsultAction.cmdCancelClick(Sender: TObject);
begin
  FChanged := False ;
  Close ;
end;

procedure TfrmConsultAction.cmdOKClick(Sender: TObject);
var
  Alist: TStringList;
begin
  Alist := TStringList.Create ;
  try
    if (cboPerson.ItemIEN = 0)
        and (FActionType <> CN_ACT_ADD_CMT)
        and (FActionType <> CN_ACT_SIGFIND) then
      begin
        InfoBox(TX_PERSON_TEXT, TX_PERSON_CAP, MB_OK or MB_ICONWARNING);
        Exit;
      end;

    if ((FActionType = CN_ACT_SIGFIND) or (FActionType = CN_ACT_ADMIN_COMPLETE))
    and (grpSigFindings.ItemIndex < 0) then
      begin
        InfoBox(TX_SIGFIND_TEXT, TX_SIGFIND_CAP, MB_OK or MB_ICONWARNING);
        Exit;
      end;

    if   ((FActionType = CN_ACT_DENY)
       or (FActionType = CN_ACT_DISCONTINUE)
       or (FActionType = CN_ACT_ADD_CMT)
       or (FActionType = CN_ACT_ADMIN_COMPLETE))
       and (memComments.Lines.Count = 0) then
      begin
          InfoBox(TX_COMMENTS_TEXT, TX_COMMENTS_CAP, MB_OK or MB_ICONWARNING);
          Exit;
      end;

    if (FActionType = CN_ACT_FORWARD) then
     begin
       if (FIsProcedure and (cboService.ItemIndex = -1) and (FToService = 0 )) or
          ((not FIsProcedure) and (treService.Selected = nil) and (FToService = 0 )) then
         begin
          InfoBox(TX_NOFORWARD_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
          Exit;
         end;
       if (not FIsProcedure) and (cboService.ItemIEN = ConsultRec.ToService) then
         begin
          InfoBox(TX_NOFORWARD_SELF, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
          Exit;
         end;
       if cboUrgency.ItemIEN = 0 then
         begin
           InfoBox(TX_NOURGENCY_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
           Exit;
         end;
       if (FIsProcedure and (Piece(cboService.Items[cboService.ItemIndex], U, 5) = '1')) or
          ((not FIsProcedure) and (Piece(TORTreeNode(treService.Selected).StringData, U, 5) = '1')) then
         begin
          InfoBox(TX_NOTTHISSVC_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);
          Exit;
         end;
     end ;

    if calDateofAction.Text <> '' then
      begin
        FActionDate := StrToFMDateTime(calDateofAction.Text) ;
        if FActionDate = -1 then
          begin
            InfoBox(TX_DATE_TEXT, TX_DATE_CAP, MB_OK or MB_ICONWARNING);
            calDateofAction.SetFocus ;
            exit ;
          end
        else if FActionDate > FMNow then
          begin
            InfoBox(TX_FUTDATE_TEXT, TX_DATE_CAP, MB_OK or MB_ICONWARNING);
            calDateofAction.SetFocus ;
            exit ;
          end;
      end
    else
      FActionDate := FMNow ;

    FActionBy      := cboPerson.ItemIEN;
    FAttentionOf   := cboAttentionOf.ItemIEN ;
    FUrgency       := cboUrgency.ItemIEN ;
    if (FActionType = CN_ACT_SIGFIND) or (FActionType = CN_ACT_ADMIN_COMPLETE) then
      FSigFind       := Copy(grpSigFindings.Items[grpSigFindings.ItemIndex],2,1);
    LimitEditWidth(memComments, 74);
    FComments := memComments.Lines ;
    if ((ckAlert.Checked) (*or (FActionType = CN_ACT_ADMIN_COMPLETE)*))
        and RecipientList.Changed then
      begin
        FAlert   := 1  ;
        FAlertTo := RecipientList.Recipients ;
      end
    else
      begin
        FAlert   := 0;
        FAlertTo := '';
      end ;

    case FActionType of
      CN_ACT_RECEIVE    :
        ReceiveConsult(Alist, ConsultRec.IEN, FActionBy, FActionDate, FComments) ;
      CN_ACT_SCHEDULE   :
        ScheduleConsult(Alist, ConsultRec.IEN, FActionBy, FActionDate, FAlert, FAlertTo, FComments) ;
      CN_ACT_DENY       :
        DenyConsult(Alist, ConsultRec.IEN, FActionBy, FActionDate, FComments) ;
      CN_ACT_DISCONTINUE:
        DiscontinueConsult(Alist, ConsultRec.IEN, FActionBy, FActionDate, FComments) ;
      CN_ACT_FORWARD    :
        ForwardConsult(Alist, ConsultRec.IEN, FToService, FActionBy, FAttentionOf, FUrgency, FActionDate, FComments);
      CN_ACT_ADD_CMT    :
        AddComment(Alist, ConsultRec.IEN, FComments, FActionDate, FAlert, FAlertTo) ;
      CN_ACT_SIGFIND    :
        SigFindings(Alist, ConsultRec.IEN, FSigFind, FComments, FActionDate, FAlert, FAlertTo) ;
      CN_ACT_ADMIN_COMPLETE :
        AdminComplete(Alist,ConsultRec.IEN, FSigFind, FComments, FActionBy, FActionDate, FAlert, FAlertTo);
    end ;
    if AList.Count > 0 then
    begin
      if StrToInt(Piece(Alist[0],u,1)) > 0 then
        begin
          InfoBox(Piece(Alist[0],u,2), 'Unable to '+ActionType[FActionType], MB_OK or MB_ICONWARNING);
          FChanged :=  False ;
        end
      else
        FChanged := True;
    end
    else
      FChanged := True ;
  finally
    Alist.Free ;
  end ;
  Close ;
end ;

procedure TfrmConsultAction.ckAlertClick(Sender: TObject);
begin
   if ckAlert.Checked then SelectRecipients(Font.Size, FActionType, RecipientList) ;
end;


procedure TfrmConsultAction.treServiceChange(Sender: TObject; Node: TTreeNode);
begin
  if uChanging or FIsProcedure then Exit;
  FToService  := StrToIntDef(Piece(TORTreeNode(treService.Selected).StringData, U, 1), 0);
(*  if (treService.Selected.Data <> nil) and (Piece(string(treService.Selected.Data), U, 5) <> '1') then
    cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1))*)
  //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1));
   cboService.ItemIndex := cboService.Items.IndexOf(Trim(treService.Selected.Text));  {RV}
   ActiveControl := cboService;                                                 {RV}
end;

procedure TfrmConsultAction.treServiceExit(Sender: TObject);
begin
(*  if (Piece(TORTreeNode(treService.Selected).StringData, U, 5) = '1') then      WHY IS THIS IN HERE?  (rv - v15.5)
    InfoBox(TX_NOTTHISSVC_TEXT, TX_NOFORWARD_CAP, MB_OK or MB_ICONWARNING);*)
end;

procedure TfrmConsultAction.cboServiceSelect(Sender: TObject);
var                                                                       
  i: integer;                                                             
begin                                                                     
  if not FIsProcedure then
    begin
      uChanging := True;
      with treService do for i := 0 to Items.Count-1 do
        begin
          if Piece(TORTreeNode(Items[i]).StringData, U, 1) = cboService.ItemID then
            begin
              Selected := Items[i];
              //treServiceChange(Self, Items[i]);
              break;
            end;
        end;
      uChanging := False;
      FToService  := StrToIntDef(Piece(TORTreeNode(treService.Selected).StringData, U, 1), 0);
    end
  else 
    FToService  := cboService.ItemIEN;
end;                                                                      

(*procedure TfrmConsultAction.ShowAutoAlertText;      ****  SEE BELOW FOR REPLACEMENT - v27.9 Phelps/Vertigan
const
  TX_ALERT1          = 'An alert will automatically be sent to ';
  TX_ALERT_PROVIDER  = 'the ordering provider';
  TX_ALERT_SVC_USERS = 'notification recipients for this service.';
  TX_ALERT_NOBODY    = 'No automatic alerts will be sent.';  // this should be rare to never
var
  x: string;
begin
  case FUserLevel of
     UL_NONE, UL_REVIEW:
       begin
         if FUserIsRequester then
           x := TX_ALERT1 + TX_ALERT_SVC_USERS
         else
           x := TX_ALERT1 + TX_ALERT_PROVIDER + ' and to ' + TX_ALERT_SVC_USERS;
       end;
     UL_UPDATE, UL_ADMIN, UL_UPDATE_AND_ADMIN:
       begin
         if FUserIsRequester then
           x := TX_ALERT_NOBODY
         else
           x := TX_ALERT1 + TX_ALERT_PROVIDER + '.';
       end;
   end;
   lblAutoAlerts.Caption := x;
end;*)

procedure TfrmConsultAction.ShowAutoAlertText;
const
  TX_ALERT1          = 'An alert will automatically be sent to ';
  TX_ALERT_PROVIDER  = 'the ordering provider';
  TX_ALERT_SVC_USERS = 'notification recipients for this service.';
  TX_ALERT_NOBODY    = 'No automatic alerts will be sent.';  // this should be rare to never
var
  x: string;
begin
  case FUserLevel of
     UL_NONE, UL_REVIEW:
       begin
         if FUserIsRequester then
           x := TX_ALERT1 + TX_ALERT_SVC_USERS
         else
           x := TX_ALERT1 + TX_ALERT_PROVIDER + ' and to ' + TX_ALERT_SVC_USERS;
       end;
     UL_UPDATE, UL_ADMIN, UL_UPDATE_AND_ADMIN:
       begin
         if FUserIsRequester then
           //x := TX_ALERT_NOBODY   Replace with following line
            x := TX_ALERT1 + TX_ALERT_SVC_USERS
         else
           x := TX_ALERT1 + TX_ALERT_PROVIDER + '.';
       end;
     UL_UNRESTRICTED:
       begin
         if FUserIsRequester then
           x := TX_ALERT1 + TX_ALERT_SVC_USERS
         else
           x := TX_ALERT1 + TX_ALERT_PROVIDER + ' and to ' + TX_ALERT_SVC_USERS;
       end;
   end;
   lblAutoAlerts.Caption := x;
end;


initialization
   SvcList := TStringList.Create ;

finalization
   SvcList.Free ;


end.
