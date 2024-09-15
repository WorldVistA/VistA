unit fODConsult;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)

    calLatest must not be enabled or visible - per business requirements for
    Consult Toolbox, No Later Than Date (calLatest) is not currently used.
-------------------------------------------------------------------------------}

{$O-}

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ORCtrls, ExtCtrls, ComCtrls, ORfn, uConst, Buttons,
  Menus,
  UBAGlobals, rOrders,
  fBALocalDiagnoses, UBAConst, UBACore, uORLists,
  ORNet,
  ORDtTm, VA508AccessibilityManager, System.Actions, Vcl.ActnList, oDST;


type
  TfrmODCslt = class(TfrmODBase)
    pnlMain: TPanel;
    pnlReason: TPanel;
    lblReason: TLabel;
    memReason: ORExtensions.TRichEdit;
    mnuPopProvDx: TPopupMenu;
    mnuPopProvDxDelete: TMenuItem;
    popReason: TPopupMenu;
    popReasonCut: TMenuItem;
    popReasonCopy: TMenuItem;
    popReasonPaste: TMenuItem;
    popReasonPaste2: TMenuItem;
    popReasonReformat: TMenuItem;
    pnlCombatVet: TPanel;
    txtCombatVet: TVA508StaticText;
    grdDstControls: TGridPanel;
    pnlBaseMessage: TPanel;
    pnlBaseAccept: TPanel;
    pnlBaseCancel: TPanel;
    pnlDSTStatus: TPanel;
    pnlDST: TPanel;
    stOpenConsultToolboxDisabled: TStaticText;
    cmdLexSearch: TButton;
    btnDiagnosis: TButton;
    txtProvDiag: TCaptionEdit;
    lblProvDiag: TLabel;
    lblService: TLabel;
    cboCategory: TORComboBox;
    lblPlace: TLabel;
    cboPlace: TORComboBox;
    gbInptOpt: TGroupBox;
    radInpatient: TRadioButton;
    radOutpatient: TRadioButton;
    lblLatest: TStaticText;
    lblAttn: TLabel;
    cboAttn: TORComboBox;
    lblClinicallyIndicated: TStaticText;
    calClinicallyIndicated: TORDateBox;
    lblUrgency: TLabel;
    cboUrgency: TORComboBox;
    treService: TORTreeView;
    servicelbl508: TVA508StaticText;
    cboService: TORComboBox;
    pnlServiceTreeButton: TKeyClickPanel;
    btnServiceTree: TSpeedButton;
    calLatest: TORDateBox;
    btnLaunchToolbox: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cboAttnNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure radInpatientClick(Sender: TObject);
    procedure radOutpatientClick(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure ControlChange(Sender: TObject);
    procedure treServiceExit(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure cboServiceSelect(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnServiceTreeClick(Sender: TObject);
    procedure treServiceCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure treServiceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdLexSearchClick(Sender: TObject);
    procedure mnuPopProvDxDeleteClick(Sender: TObject);
    procedure txtProvDiagChange(Sender: TObject);
    procedure cboServiceExit(Sender: TObject);
    procedure popReasonCutClick(Sender: TObject);
    procedure popReasonCopyClick(Sender: TObject);
    procedure popReasonPasteClick(Sender: TObject);
    procedure popReasonPopup(Sender: TObject);
    procedure popReasonReformatClick(Sender: TObject);
    procedure pnlServiceTreeButtonEnter(Sender: TObject);
    procedure pnlServiceTreeButtonExit(Sender: TObject);
    procedure treServiceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure treServiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memReasonKeyPress(Sender: TObject; var Key: Char);
    procedure cboServiceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboServiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDiagnosisClick(Sender: TObject);
    procedure cmdQuitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure treServiceEnter(Sender: TObject);
//    procedure cboUrgencyExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure calClinicallyIndicatedExit(Sender: TObject);
    procedure btnLaunchToolboxClick(Sender: TObject);

  private
    FcboServiceKeyDownStopClick : boolean;
    FKeyBoarding: boolean;
    FLastServiceID: string;
    FEditCtrl: TCustomEdit;
    FNavigatingTab: boolean;
    LLS_LINE_INDEX: integer;
    procedure BuildQuickTree(QuickList: TStrings; const Parent: string; Node: TTreeNode);
    procedure ReadServerVariables;
    procedure SetProvDiagPromptingMode;
    procedure SetupReasonForRequest(OrderAction: integer);
    procedure GetProvDxandValidateCode(AResponses: TResponses);
    function ShowPrerequisites: boolean;
    procedure DoSetFontSize(FontSize: Integer = -1); reintroduce;
    procedure SetUpQuickOrderDX;
    procedure SaveConsultDxForNurse(pDiagnosis: string);  // save the dx entered by nurese if Master BA switch is ON
    procedure SetUpCopyConsultDiagnoses(pOrderID:string);
    function NotinIndex(AList: TStringList; i: integer): boolean;
    function GetItemIndex(Service: String; Index: integer): integer;
//    procedure SetUpCombatVet;
    procedure SetUpCombatVet(Eligable:Boolean);  // RTC#722078
    procedure SetUpClinicallyIndicatedDate; //wat v28
    procedure clearDstData;
    procedure setup508Label(lbl: TVA508StaticText; ctrl: TORComboBox);
    procedure setDstStatus(aStatus: String);

    function getCombatVetHeight:Integer;
    function getReasonHeight:Integer;
    function getMinHeight:Integer;

  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    function DefaultReasonForRequest(aDest:TStrings; Service: string; Resolve: Boolean): Integer;
    procedure ShowOrderMessage(Show: boolean); override;
    procedure ValidateDst(var AnErrMsg: string);
    //function DefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings;
    procedure SetDSTAction(anAction: Integer);

  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure SetFontSize(FontSize: integer); override;
    procedure DstStatusUpdate;
  end;

var
  LastNode: integer ;
  displayDXCode: string;
  consultQuickOrder: boolean;
  isProsSvc: boolean;

function CanFreeConsultDialog(dialog : TfrmODBase) : boolean;

implementation

{$R *.DFM}

uses
    rODBase, rConsults, uCore, uConsults, rCore, fConsults, fPCELex, rPCE, fPreReq,
    ORClasses, clipbrd, uTemplates, fFrame, uODBase, uVA508CPRSCompatibility,
    VA508AccessibilityRouter, VAUtils,
    uSizing, uDstConst, uSimilarNames;

var
  SvcList, QuickList, Defaults: TStrings ;
  ProvDx:  TProvisionalDiagnosis;
  GMRCREAF: string;
  BADxUpdated: boolean;
  quickCode: string;
  AreGlobalsFree: boolean;



const
  TX_NOTTHISSVC_TEXT = 'Consults cannot be ordered from this service' ;
  TX_NO_SVC          = 'A service must be specified.'    ;
  TX_NO_REASON       = 'A reason for this consult must be entered.'  ;
  TX_SVC_ERROR       = 'This service has not been defined in your Orderable Items file.' +
                       #13#10'Contact IRM for assistance.' ;
  TX_NO_URGENCY      = 'An urgency must be specified.';
  TX_NO_PLACE        = 'A place of consultation must be specified';
  TX_NO_DIAG         = 'A provisional diagnosis must be entered for consults to this service.';
  TX_SELECT_DIAG     = 'You must select a diagnosis for consults to this service.';
  TX_GROUPER         = 'This is not an orderable service. Please select a subspecialty';
  TC_INACTIVE_CODE   = 'Inactive ICD Code';
  TX_INACTIVE_CODE1  = 'The provisional diagnosis code is not active as of today''s date.' + #13#10;
  TX_INACTIVE_CODE_REQD     = 'Another code must be selected before the order can be saved.';
  TX_INACTIVE_CODE_OPTIONAL = 'If another code is not selected, no code will be saved.';
  TX_PAST_DATE       = 'Clinically indicated date must be today or later.';
  TX_BAD_DATE         = 'The clinically indicated date you have entered is invalid.';
  TX_NLTD_GREATER    = 'No later than date must be greater than or equal to the' + #13#10;
  TX_NLTD_GREATER1   = 'clinically indicated date';

  TX_SVC_HRCHY = 'services/specialties hierarchy';
  TX_VIEW_SVC_HRCHY = 'View services/specialties hierarchically';
  TX_CLOSE_SVC_HRCHY = 'Close services/specialties hierarchy tree view';

  TX_DST_UNAVAIL = 'Decision Support Tool is not available.' + #13#10 + 'Try again later.';
//  TX_NLTD_SI_URG = 'No later than date is required when using the Special Instructions urgency.';

const
  PIXEL_SPACE = 3;
  LEFT_MARGIN = 4;

{************** Static Unit Methods ***************}

function CanFreeConsultDialog(dialog : TfrmODBase) : boolean;
begin
  Result := true;
  if (dialog is TfrmODCslt) then
    Result := AreGlobalsFree;
end;

procedure InitializeGlobalLists;
begin
  Defaults := TStringList.Create;
  SvcList := TStringList.Create;
  QuickList := TStringList.Create;
  AreGlobalsFree := false;
end;

function FreeGlobalLists : Boolean;
begin
  Result := false;
  if AreGlobalsFree then
    Exit;
  Defaults.Free;
  SvcList.Free;
  QuickList.Free;
  AreGlobalsFree := true;
  Result := true;
end;

function getRectHeight(aRectWidth: Integer; aText: String): Integer;
var
  r: TRect;
begin
  r := Rect(0, 0, aRectWidth, aRectWidth);
  DrawText(Application.MainForm.Canvas.Handle, PChar(aText), Length(aText), r,
    DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
  Result := r.Bottom - r.Top + 6; // Default margings
end;

{*************** TfrmODCslt Methods ***********}

procedure TfrmODCslt.FormCreate(Sender: TObject);
begin
  GetDstMgr(DST_CASE_CONSULT_OD);
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := True;
  inherited;
  if BILLING_AWARE then
  begin
     btnDiagnosis.Visible := True;
     cmdLexSearch.Visible := False;
  end
  else
  begin
     btnDiagnosis.Visible := False;
     cmdLexSearch.Visible := True;
  end;
  InitializeGlobalLists;
  AllowQuickOrder := True;
  LastNode := 0;
  FLastServiceID := '' ;
  GMRCREAF := '';
  FillChar(ProvDx, SizeOf(ProvDx), 0);
  FillerID := 'GMRC';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'GMRCOR CONSULT';   // loads formatting info
  StatusText('Loading Default Values');
  setODForConsults(Defaults);  // ODForConsults returns TStrings with defaults
  CtrlInits.LoadDefaults(Defaults);
  cboAttn.InitLongList('') ;
  PreserveControl(cboAttn);
  PreserveControl(calClinicallyIndicated);

  SetUpCombatVet(patient.CombatVet.IsEligible);  // RTC#722078

  InitDialog;

  cmdQuit.Parent := pnlBaseCancel;
//  cmdQuit.Align := alBottom;
  cmdQuit.Align := alClient;

  cmdAccept.Parent := pnlBaseAccept;
//  cmdAccept.Align := alTop;
  cmdAccept.Align := alClient;

  memOrder.Parent := pnlBaseMessage;
  memOrder.Align := alClient;

  pnlMessage.Parent := pnlBaseMessage;
  pnlMessage.Align := alClient; // check which one visible or not

  //Calling virtual SetFontSize in constructor is a bad idea!
//  DoSetFontSize(MainFontSize, True);
  DoSetFontSize;
  DstStatusUpdate;
  FcboServiceKeyDownStopClick := false;
  consultQuickOrder := false;
end;


procedure TfrmODCslt.SetUpCombatVet;
begin
  pnlCombatVet.Visible := patient.CombatVet.IsEligible;
  if pnlCombatVet.Visible then
  begin
    pnlCombatVet.Height := getCombatVetHeight;
    txtCombatVet.Enabled := true;
    txtCombatVet.Caption := 'Combat Veteran Eligibility Expires on ' +
      patient.CombatVet.ExpirationDate;
    treService.Anchors := [akLeft, akTop, akRight];
    self.Height := self.Height + pnlCombatVet.Height;
    treService.Anchors := [akLeft, akTop, akRight, akBottom];
  end;
end;
(*
procedure TfrmODCslt.SetUpCombatVet(Eligable:Boolean);  // RTC#722078
begin
  pnlCombatVet.Visible := Eligable;
  txtCombatVet.Enabled := Eligable;
  if Eligable then
    begin
      txtCombatVet.Caption := 'Combat Veteran Eligibility Expires on ' + patient.CombatVet.ExpirationDate;
      ActiveControl := txtCombatVet;
    end;
end;
*)

function TfrmODCslt.getReasonHeight:Integer;
begin
  Result := getMainFormTextHeight * 4 + 16; // reserved for pnlReason
  pnlReason.Constraints.MinHeight := Result;
end;

function TfrmODCslt.getCombatVetHeight:Integer;
begin
  Result := 0;
  if patient.CombatVet.IsEligible then
    Result := getMainFormTextHeight + 8;
end;

function TfrmODCslt.getMinHeight: Integer;
begin
  Result := pnlMain.Height;
  Result := Result + grdDstControls.Height;
  if pnlCombatVet.Visible then
    Result := Result + getCombatVetHeight;
  Result := Result + getReasonHeight; // pnlReason aligned to Client
  Result := Result + 36; // adjusting to include window caption
end;


procedure TfrmODCslt.InitDialog;
begin
  inherited;
  GetDstMgr(DST_CASE_CONSULT_OD); //obj is destroyed in Validate
  //instantiate again here b/c cons order dlg can persist for subsequent orders
  Changing := True;
  FLastServiceID := '';
  QuickList.Clear;
  with CtrlInits do
  begin
   ExtractItems(QuickList, Defaults, 'ShortList');
   if OrderForInpatient then                            //INPATIENT CONSULT
    begin
      radInpatient.Checked := True;
      cboCategory.Items.Clear;
      cboCategory.Items.Add('I^Inpatient');
      cboCategory.SelectById('I');
      SetControl(cboPlace, 'Inpt Place');
      SetControl(cboUrgency, 'Inpt Cslt Urgencies');        //S.GMRCT
      SetControl(calClinicallyIndicated, 'Clin Ind Date');
    end
   else
    begin
      radOutpatient.Checked := True;                   //OUTPATIENT CONSULT
      cboCategory.Items.Clear;
      cboCategory.Items.Add('O^Outpatient');
      cboCategory.SelectById('O');
      {lblLatest.Enabled := False;
      lblLatest.Visible := False;
      calLatest.Enabled := False;
      calLatest.Text := '';
      calLatest.Visible := False;}
      SetControl(cboPlace, 'Outpt Place');
      SetControl(cboUrgency, 'Outpt Urgencies');      //S.GMRCO
      SetControl(calClinicallyIndicated, 'Clin Ind Date');
    end ;
  end ;
  StatusText('Initializing Long List');
  memOrder.Clear ;
  memReason.Clear;
  cboService.Enabled := True;
  setup508Label(servicelbl508, cboService);
  cboService.Font.Color := clWindowText;
  cboService.Height := 25 + (11 * cboService.ItemHeight);
  btnServiceTree.Enabled := True;
  pnlServiceTreeButton.Enabled := True;
  SetProvDiagPromptingMode;
  ActiveControl := cboService;
  Changing := False;
  StatusText('');
  isProsSvc := False;
  pnlDstStatus.Caption := '';
  //call status update to reset button state for subsequent orders
  DstStatusUpdate;
end;

procedure TfrmODCslt.SetupDialog(OrderAction: Integer; const ID: string);
const
  TX_INACTIVE_SVC = 'This consult service is currently inactive and not receiving requests.' + CRLF +
                    'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TX_INACTIVE_SVC_CAP = 'Inactive Service';
  TX_TRACK_SVC = 'This consult service is currently set to tracking only and can only be ordered by' + CRLF +
  'authorized personnel. Please contact your Clinical Coordinator/IRM staff if you feel' + CRLF +
  'you''ve received this message in error.';
  TX_TRACK_SVC_CAP = 'Tracking Service';
  TX_GROUP_SVC = 'This consult service is currently set to grouper only and not receiving requests.' + CRLF +
  'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TX_GROUP_SVC_CAP = 'Grouping Service';
  TX_NO_SVC = 'The order or quick order you have selected does not specify a consult service.' + CRLF +
              'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TC_NO_SVC = 'No service specified';
var
 i:integer;
 AList, TempAList: TStringList;
 tmpResp: TResponse;
 SvcIEN: string;
 TempSvcList: TStrings;
 TempUserLevel: String;
begin
  inherited;
  LLS_LINE_INDEX := -1;
  ReadServerVariables;
  AList := TStringList.Create;
  try
    if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
    begin
      Changing := True;
      tmpResp := TResponse(FindResponseByName('ORDERABLE',1));
      if tmpResp <> nil then
        SvcIEN := GetServiceIEN(tmpResp.IValue)
      else
        begin
          InfoBox(TX_NO_SVC, TC_NO_SVC, MB_ICONERROR or MB_OK);
          AbortOrder := True;
          Close;
          Exit;
        end;
      if SvcIEN = '-1' then
       begin
          InfoBox(TX_INACTIVE_SVC, TX_INACTIVE_SVC_CAP, MB_OK);
          AbortOrder := True;
          Close;
          Exit;
       end else begin
        //Is this tracking or grouping? CB
        TempSvcList := TStringList.Create();
        TempAList := TStringList.Create();
        try
         setServiceList(TempSvcList, False, StrToIntDef(SvcIEN, 1), 0); {RV}
         FastAssign(TempSvcList, TempAList);
         //Grouper
         if (TempAList.Count > 0) and (Piece(TempAList.Strings[0], U, 5) = '1') then begin
          InfoBox(TX_GROUP_SVC, TX_GROUP_SVC_CAP, MB_ICONERROR or MB_OK);
          AbortOrder := True;
          Close;
          Exit;
         end;
         //Tracking
         if (TempAList.Count > 0) and (Piece(TempAList.Strings[0], U, 5) = '2') then begin
          //Does the user have the required rights?
          TempUserLevel := GetServiceUserLevel(StrToInt(SvcIEN), 0);
          if StrtoInt(TempUserLevel) < 2 then begin
            InfoBox(TX_TRACK_SVC, TX_TRACK_SVC_CAP, MB_ICONERROR or MB_OK);
            AbortOrder := True;
            Close;
            Exit;
          end;
         end;
        finally
          TempAList.Free;
          TempSvcList.Free;
        end;
       end;
      cboService.Items.Add(SvcIEN + U + tmpResp.EValue + '^^^^' + tmpResp.IValue);
      cboService.SelectByID(SvcIEN);
      tmpResp := TResponse(FindResponseByName('CLASS',1));
      cboCategory.SelectByID(tmpResp.IValue);
      if tmpResp.IValue = 'I' then
        radInpatient.Checked := True
      else
        radOutpatient.Checked := True ;
      //If ORDER_COPY then don't associate existing DSTID with new order, otherwise get ID for display in order dialog
      if OrderAction = ORDER_COPY then
        begin
          Update('DSTID',1,'','');
          Remove('DSTDECSN',1);
        end
      else
        begin
          tmpResp := TResponse(FindResponseByName('DSTID',1));
          if assigned(tmpResp) then
             begin
              if tmpResp.IValue <> '' then
                begin
//                  frmConsults.DSTUUID := tmpResp.IValue;
                  tmpResp := TResponse(FindResponseByName('DSTDECSN',1));
                  if tmpResp <> nil then
                    begin
                      pnlDstStatus.Caption := tmpResp.EValue;
                    end;
                end;
             end;
        end;


      SetControl(cboUrgency,    'URGENCY',   1);
      SetControl(cboPlace,      'PLACE',     1);
      SetControl(cboAttn,       'PROVIDER',  1);
      TSimilarNames.RegORComboBox(cboAttn);
      SetControl(calClinicallyIndicated,   'CLINICALLY',  1);
      if getDstMgr.DSTMode <> DST_OTH then
      begin
        SetControl(calLatest, 'NLTD', 1);
        tmpResp := TResponse(FindResponseByName('NLTD',1));
        if tmpResp <> nil then

        begin
          lblLatest.Enabled := True;
          lblLatest.Visible := True;
          calLatest.Enabled := True;
          calLatest.Visible := True;
        end;
      end;
      btnLaunchToolbox.Caption := getDstMgr.DSTCaption;
      btnLaunchToolbox.Visible := (getDstMgr.DSTBtnVisible and DstPro.DstParameters.FOrderConsult);
      DoSetFontSize;
      if cboService.ItemIEN > 0 then
        isProsSvc := IsProstheticsService(cboService.ItemIEN)
      else
        isProsSvc := False;
      SetUpClinicallyIndicatedDate;   //wat v28
      cboService.Enabled := False;
      setup508Label(servicelbl508, cboService);
      cboService.Font.Color := clGrayText;
      btnServiceTree.Enabled := False;
      pnlServiceTreeButton.Enabled := False;
      if (OrderAction in [ORDER_COPY, ORDER_QUICK]) and (not ShowPrerequisites) then
        begin
          Close;
          Exit;
        end;
      SetProvDiagPromptingMode;
      GetProvDxandValidateCode(Responses);
      SetTemplateDialogCanceled(FALSE);
      SetControl(memReason,     'COMMENT',   1);
      if WasTemplateDialogCanceled then
      begin
        AbortOrder := True;
		SetTemplateDialogCanceled(FALSE);
        Close;
        Exit;
      end;
      SetTemplateDialogCanceled(FALSE);
      SetupReasonForRequest(OrderAction);
      if WasTemplateDialogCanceled then
      begin
        AbortOrder := True;
		SetTemplateDialogCanceled(FALSE);
        Close;
        Exit;
      end;
      Changing := False;
      ControlChange(Self);
    end
    else
    begin
      if QuickList.Count > 0 then BuildQuickTree(QuickList, '0', nil) ;
      setServiceListWithSynonyms(SvcList, CN_SVC_LIST_ORD);           {RV}
      FastAssign(SvcList, AList);
      SortByPiece(AList, U, 2);
      BuildServiceTree(treService, SvcList) ;
      with treService do
        begin
          for i:=0 to Items.Count-1 do
            if Items[i].Level > 0 then Items[i].Expanded := False else Items[i].Expanded := True;
          TopItem  := Items[LastNode] ;
          Changing := True;
          Selected := Items[LastNode] ;
          Changing := False;
          SendMessage(Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
        end ;
      if QuickList.Count > 0 then with cboService do
        begin
          FastAssign(QuickList, cboService.Items);
          Items.Add(LLS_LINE);
          LLS_LINE_INDEX := Items.IndexOf(Trim(Piece(LLS_LINE, U, 2))); {TP - HDS00015782: Used to determine if QO}
          Items.Add(LLS_SPACE);
        end;
      Changing := True;
      for i := 0 to AList.Count - 1 do
        //if (cboService.Items.IndexOf(Trim(Piece(AList.Strings[i], U, 2))) = -1) and   {RV}
        if (NotinIndex(AList,i)) and   {TP - HDS00015782: Check if service is already in index (not including QO)}
        //if (cboService.SelectByID(Piece(AList.Strings[i], U, 1)) = -1) and
           (Piece(AList.Strings[i], U, 5) <> '1') then
          cboService.Items.Add(AList.Strings[i]);
      cboService.ItemIndex := 0;
      Changing := False;
      if treService.Selected <> nil then
        begin
          if (TORTreeNode(treService.Selected).StringData <> '') and
             (Piece(TORTreeNode(treService.Selected).StringData, U, 5) <> '1') then
            cboService.ItemIndex := cboService.Items.IndexOf(Trim(Piece(TORTreeNode(treService.Selected).StringData, U, 2)))
            //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1))
          else
            cboService.ItemIndex := -1;
        end
      else
        cboService.ItemIndex := -1;
      if cboService.ItemIEN > 0 then
        begin
          if not ShowPrerequisites then
            begin
              Close;
              Exit;
            end;
          DefaultReasonForRequest(memReason.Lines, cboService.ItemID, True);
        end;
      PreserveControl(treService);
      PreserveControl(cboService);

      btnLaunchToolbox.Caption := GetDstMgr.DSTCaption;
      btnLaunchToolbox.Visible := (GetDstMgr.DSTBtnVisible and DstPro.DstParameters.FOrderConsult);
      DoSetFontSize;
    end;
  finally
    AList.Free;
  end;
end;


procedure TfrmODCslt.Validate(var AnErrMsg: string);
var
  MaxDays: Double;
  MaxDate: TDateTime;
  ALongMessage: String;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;
//var
// ErrMsg: String;
begin
  inherited;
  if (not ContainsVisibleChar(memReason.Text)) then SetError(TX_NO_REASON);
  if cboUrgency.ItemIEN = 0 then SetError(TX_NO_URGENCY);
  if cboPlace.ItemID = '' then SetError(TX_NO_PLACE);
  if cboService.ItemIEN = 0 then
    SetError(TX_NO_SVC)
  else
    begin
      if Piece(cboService.Items[cboService.ItemIndex],U,5) = '1' then SetError(TX_NOTTHISSVC_TEXT);
      if (Piece(cboService.Items[cboService.ItemIndex],U,5) <> '1')
         and (Piece(cboService.Items[cboService.ItemIndex],U,6) = '')
                                              then SetError(TX_SVC_ERROR) ;
    end;
  if (ProvDx.Reqd = 'R') and (not ContainsVisibleChar(txtProvDiag.Text)) then
    begin
      if ProvDx.PromptMode = 'F' then
        SetError(TX_NO_DIAG)
      else
        SetError(TX_SELECT_DIAG);
    end;
  MaxDays := SystemParameters.AsTypeDef<Double>('consultFutureDateLimit',0);
  MaxDate := FMDateTimeToDateTime(FMToday) + MaxDays;
  if (lblClinicallyIndicated.Enabled) then
    begin
      if calClinicallyIndicated.FMDateTime < FMToday then
        SetError(TX_PAST_DATE)
      else if FMDateTimeToDateTime(calClinicallyIndicated.FMDateTime) > MaxDate then
        begin
          ALongMessage := TX_BAD_DATE + CRLF + 'Please choose a date between ' +
            FormatFMDateTime('mm/dd/yyyy', FMToday) + ' and ' +
              FormatDateTime('mm/dd/yyyy', MaxDate);
          SetError(ALongMessage);
        end

    end;

//  if (calLatest.Enabled) and (calLatest.FMDateTime < calClinicallyIndicated.FMDateTime) then SetError(TX_NLTD_GREATER + TX_NLTD_GREATER1);
//  if (cboUrgency.Text = 'SPECIAL INSTRUCTIONS') and (calLatest.FMDateTime = 0) then SetError(TX_NLTD_SI_URG);

  { if validation is OK, order will be accepted, release DST manager obj.
    Obj will be recreated in InitDialog if dialog is set to remain open for
    subsequent orders }
  if Length(AnErrMsg) = 0 then
    FreeDSTMgr;
end;

procedure TfrmODCslt.ValidateDst(var AnErrMsg: string);

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
   if (lblClinicallyIndicated.Enabled) and (calClinicallyIndicated.FMDateTime < FMToday) then SetError(TX_PAST_DATE);
//   if (cboUrgency.Text = 'SPECIAL INSTRUCTIONS') and (calLatest.FMDateTime = 0) then SetError(TX_NLTD_SI_URG);
end;

procedure TfrmODCslt.cboAttnNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList(cboAttn, StartFrom, Direction);
end;

procedure TfrmODCslt.radInpatientClick(Sender: TObject);
begin
  inherited;
  with CtrlInits do
  begin
    SetControl(cboPlace, 'Inpt Place');
    SetControl(cboUrgency, 'Inpt Cslt Urgencies');
    cboCategory.Items.Clear;
    cboCategory.Items.Add('I^Inpatient') ;
    cboCategory.SelectById('I');
    clearDstData;
  end ;
  ControlChange(Self);
end;

procedure TfrmODCslt.radOutpatientClick(Sender: TObject);
begin
  inherited;
  with CtrlInits do
  begin
    SetControl(cboPlace, 'Outpt Place');
    SetControl(cboUrgency, 'Outpt Urgencies');
    cboCategory.Items.Clear;
    cboCategory.Items.Add('O^Outpatient');
    cboCategory.SelectById('O');
  end ;
  ControlChange(Self);
end;

procedure TfrmODCslt.BuildQuickTree(QuickList: TStrings; const Parent: string; Node: TTreeNode);
var
  i: Integer;
  QuickInfo, Name: string ;
  ANode: TTreeNode;
begin
  with QuickList do
    begin
      Node := treService.Items.AddChildObject(Node, 'Quick Orders', nil);
      for i := 0 to Count - 1 do
       begin
        Name        := Piece(Strings[i], U, 2);
        QuickInfo   := Strings[i];
        ANode := treService.Items.AddChildObject(Node, Name, Pointer(QuickInfo));
        TORTreeNode(ANode).StringData := QuickInfo;
       end;
    end;
end;

procedure TfrmODCslt.treServiceChange(Sender: TObject; Node: TTreeNode);
var
  i: integer;
  tmpSvc: string;
begin
  inherited;
  pnlMessage.Visible := False;
  if Changing or (treService.Selected = nil)
     or FKeyBoarding or FcboServiceKeyDownStopClick then exit;
  Changing := True;
  with cboService do
   begin
    if treService.Selected <> nil then
      begin
        if (TORTreeNode(treService.Selected).StringData <> '') and
           (Piece(TORTreeNode(treService.Selected).StringData, U, 5) <> '1') then
          cboService.ItemIndex := cboService.Items.IndexOf(Trim(Piece(TORTreeNode(treService.Selected).StringData, U, 2)))
          //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1))
        else
          begin
            pnlMessage.TabOrder := treService.TabOrder + 1;
            OrderMessage(TX_GROUPER);
            cboService.ItemIndex := -1;
            Changing := False;
            Exit;
          end;
      end
    else
      ItemIndex := -1;
(*    if (treService.Selected.Data <> nil) then
      SelectByID(Piece(string(treService.Selected.Data), U, 1))
    else
      ItemIndex := -1;*)
    Changing := False;
    if ItemIndex < 0 then exit;
    if Piece(Items[ItemIndex],U,5) = '1' then
      begin
        Responses.Update('ORDERABLE', 1, '', '');
        memOrder.Clear;
        cboService.ItemIndex := -1;
        FLastServiceID := '';
        Changing := True;
        treService.Selected := nil;
        Changing := False;
        pnlMessage.TabOrder := treService.TabOrder + 1;
        OrderMessage(TX_GROUPER);
        Exit;
      end;
    treService.Visible := False;
    cboService.Visible := True;
    memReason.Clear;
    if ItemID <> FLastServiceID then FLastServiceID := ItemID else Exit;
    Changing := True;
    if Sender <> Self then
      Responses.Clear;       // Sender=Self when called from SetupDialog
    Changing := False;
    if CharAt(ItemID, 1) = 'Q' then
      begin
        Changing := True;
        consultQuickOrder := True;
        Responses.QuickOrder := ExtractInteger(ItemID);
        tmpSvc := TResponse(Responses.FindResponseByName('ORDERABLE',1)).IValue;
        with treService do for i := 0 to Items.Count-1 do
          begin
            if Piece(TORTreeNode(Items[i]).StringData, U, 6) = tmpSvc then
              begin
                Selected := Items[i];
                break;
              end;
          end;
        if treService.Selected <> nil then
          begin
            if (TORTreeNode(treService.Selected).StringData <> '') and
               (Piece(TORTreeNode(treService.Selected).StringData, U, 5) <> '1') then
                 cboService.ItemIndex := cboService.Items.IndexOf(Trim(Piece(TORTreeNode(treService.Selected).StringData, U, 2)))
              //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1))
            else
              cboService.ItemIndex := -1;
          end
        else
          cboService.ItemIndex := -1;
        FLastServiceID := ItemID;
        cboService.Enabled := False;
        setup508Label(servicelbl508, cboService);
        cboService.Font.Color := clGrayText;
        btnServiceTree.Enabled := False;
        pnlServiceTreeButton.Enabled := False;
        Changing := False;
      end;
   end;
  with Responses do if QuickOrder > 0 then
    begin
      tmpSvc := TResponse(Responses.FindResponseByName('ORDERABLE',1)).IValue;
      with treService do
      begin
        Selected := nil;
        for i := 0 to Items.Count-1 do
        begin
          if Piece(TORTreeNode(Items[i]).StringData, U, 6) = tmpSvc then
            begin
              Selected := Items[i];
              break;
            end;
        end;
      end;
      if treService.Selected <> nil then
        begin
          if (TORTreeNode(treService.Selected).StringData <> '') and
             (Piece(TORTreeNode(treService.Selected).StringData, U, 5) <> '1') then
                cboService.ItemIndex := cboService.Items.IndexOf(Trim(Piece(TORTreeNode(treService.Selected).StringData, U, 2)))
            //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1))
          else
            cboService.ItemIndex := -1;
        end
      else
        cboService.ItemIndex := -1;
      Changing := True;
      if not ShowPrerequisites then
        begin
          Close;
          Exit;
        end;
      SetControl(cboCategory,   'CLASS',      1);
      if cboCategory.ItemID = 'I' then radInpatient.Checked := True
      else radOutpatient.Checked := True ;
      SetControl(cboUrgency,    'URGENCY',     1);
      SetControl(cboPlace,      'PLACE',     1);
      SetControl(cboAttn,       'PROVIDER',  1);
      TSimilarNames.RegORComboBox(cboAttn);
      SetControl(calClinicallyIndicated,   'CLINICALLY',  1);
      SetTemplateDialogCanceled(FALSE);
      SetControl(memReason,     'COMMENT',   1);
      if WasTemplateDialogCanceled and OrderContainsObjects then
      begin
        AbortOrder := TRUE;
		SetTemplateDialogCanceled(FALSE);
        Close;
        Exit;
      end;
      if ((cboService.ItemIEN > 0) and (Length(memReason.Text) = 0)) then
        DefaultReasonForRequest(memReason.Lines, cboService.ItemID, True);
      SetupReasonForRequest(ORDER_QUICK);
      GetProvDxandValidateCode(Responses);
      Changing := False;
    end
  else
    begin
      if cboService.ItemIEN > 0 then
        begin
          if not ShowPrerequisites then
            begin
              Close;
              Exit;
            end;
          DefaultReasonForRequest(memReason.Lines, cboService.ItemID, True);
          SetupReasonForRequest(ORDER_NEW);
        end;
    end;
  SetProvDiagPromptingMode;
  if cboService.ItemIEN > 0 then
    isProsSvc := IsProstheticsService(cboService.ItemIEN)
  else
    isProsSvc := False;
  SetUpClinicallyIndicatedDate; //wat v28
  tmpSvc := Piece(cboService.Items[cboService.ItemIndex], U, 6);
  pnlMessage.TabOrder := treService.TabOrder + 1;
  OrderMessage(ConsultMessage(StrToIntDef(tmpSvc, 0)));
  //OrderMessage(ConsultMessage(cboService.ItemIEN));
  ControlChange(Self) ;
end;

procedure TfrmODCslt.ControlChange(Sender: TObject);
var
  X: string;
  i: Integer;
begin
  inherited;

  if Changing then
    Exit;

  DstStatusUpdate;

// flag should be updated only for correct Sender and retained otherwise -
// - commenting out the next line
//    cboAttn.NeedsValidation := Sender = cboAttn;

  if cboService.ItemIEN <= 0 then
    memOrder.Clear
  else
  begin
    with cboService do
    begin
      if (ItemIEN > 0) and (Piece(Items[ItemIndex], U, 5) <> '1') then
      begin
        i := Pos('<', Text);
        if i > 0 then
        begin
          X := Piece(Copy(Text, i + 1, 99), '>', 1);
          X := UpperCase(Copy(X, 1, 1)) + Copy(X, 2, 99);
        end
        else
          X := Text;
        Responses.Update('ORDERABLE', 1, Piece(Items[ItemIndex], U, 6), X);
      end
      else
        Responses.Update('ORDERABLE', 1, '', '');
    end;
    with memReason do
      Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
    with cboCategory do
      Responses.Update('CLASS', 1, ItemID, Text);
    with cboUrgency do
      Responses.Update('URGENCY', 1, ItemID, Text);
    with cboPlace do
      Responses.Update('PLACE', 1, ItemID, Text);
    with cboAttn do
      Responses.Update('PROVIDER', 1, ItemID, Text);
    with calClinicallyIndicated do
      if Length(Text) > 0 then
        Responses.Update('CLINICALLY', 1, Text, Text);
    {with calLatest do
      if Length(Text) > 0 then
        Responses.Update('NLTD', 1, Text, Text);}
    // with txtProvDiag   do if Length(Text) > 0 then Responses.Update('MISC',      1, Text,   Text);
    if Length(ProvDx.Text) > 0 then
      Responses.Update('MISC', 1, ProvDx.Text, ProvDx.Text)
    else
      Responses.Update('MISC', 1, '', '');
    if Length(ProvDx.Code) > 0 then
      Responses.Update('CODE', 1, ProvDx.Code, ProvDx.Code)
    else
      Responses.Update('CODE', 1, '', '');

    memOrder.Text := Responses.OrderText;
  end;
end;

procedure TfrmODCslt.treServiceEnter(Sender: TObject);
begin
  inherited;
  cmdQuit.Cancel := FALSE;
end;

procedure TfrmODCslt.treServiceExit(Sender: TObject);
begin
  inherited;
  cmdQuit.Cancel := TRUE;
  with cboService do
  begin
    if ItemIEN > 0 then
    begin
      pnlMessage.TabOrder := treService.TabOrder + 1;
      OrderMessage(ConsultMessage(StrToIntDef(Piece(Items[ItemIndex],U,6),0)));
    end;
  end;
end;

procedure TfrmODCslt.SetUpQuickOrderDX;
// this procedure is called if the user selects a quick code from the list
// and accepts the order without entering or selection the diagnoses button.
begin
   quickCode := ProvDx.Code;
   if UBACore.IsICD9CodeActive(quickCode,'ICD',0) then
   begin
      uBAGlobals.BAConsultDxList.Clear;
      uBAGlobals.BAConsultDxList.Add(UBAConst.PRIMARY_DX + U + ProvDx.Text + ':' +  quickCode);
   end;

end;

procedure TfrmODCslt.cmdAcceptClick(Sender: TObject);
var
  BADiagnosis: string;
begin
  inherited;
  cmdAccept.SetFocus; // NSR#20110606 - making sure we exit other controls
  if treService.Selected <> nil then
    LastNode := treService.Selected.AbsoluteIndex;

  if  BILLING_AWARE and CIDCOkToSave  then
  begin
    if btnDiagnosis.Enabled then
      if consultQuickOrder then SetUpQuickOrderDX;
       if UBAGlobals.BAConsultDxList.Count > 0 then
       begin
          uBACore.CompleteConsultOrderRec(uBAGlobals.BAOrderID,UBAGlobals.BAConsultDxList);
          uBAGlobals.BAConsultDxList.Clear;
       end;
    BADiagnosis := ProvDx.Text + '^' + ProvDx.Code;
  end;

  if NOT BILLING_AWARE then
  begin
   // this will save a dx entered by a nurse to be reviewed by a provided.
   // this is active if CIDC MASTER SWITCH is ON.
     if rpcGetBAMasterSwStatus then   // BA master sw is on.
      if (uCore.User.OrderRole = OR_NURSE) then   // user is a nurse
     begin
        if ProvDx.Text <> '' then   // consult dx has been selected
        begin
            SaveConsultDxForNurse(ProvDx.Text + ProvDx.Code); // save selected dx, will be displayed to Provider
        end;
     end;
  end;
end;

procedure TfrmODCslt.cboServiceSelect(Sender: TObject);
var
  tmpSvc: string;
begin
  if FcboServiceKeyDownStopClick then
  begin
    Exit; //This fixes clearquest: HDS00001418
    FcboServiceKeyDownStopClick := false;
  end;
  memReason.Clear;
  isProsSvc := False;
  with cboService do
    begin
      setup508Label(servicelbl508, cboService);
      if (ItemIndex < 0) or (ItemID = '') then
        begin
          Responses.Update('ORDERABLE', 1, '', '');
          memOrder.Clear;
          FLastServiceID := '';
          exit;
        end;
      if Piece(Items[ItemIndex],U,5) = '1' then
        begin
          Responses.Update('ORDERABLE', 1, '', '');
          memOrder.Clear;
          FLastServiceID := '';
          pnlMessage.TabOrder := cboService.TabOrder + 1;
          OrderMessage(TX_GROUPER);
          Exit;
        end;
      FLastServiceID := ItemID;
      if CharAt(ItemID, 1) = 'Q' then
        begin
          Changing := True;
          Responses.QuickOrder := ExtractInteger(ItemID);
          consultQuickOrder := True;
          tmpSvc := TResponse(Responses.FindResponseByName('ORDERABLE',1)).EValue;
          ItemIndex := Items.IndexOf(Trim(tmpSvc));
          If ItemIndex < LLS_LINE_INDEX then       {TP - HDS00015782: Check if index is of a QO}
            ItemIndex := GetItemIndex(tmpSvc,ItemIndex);
(*          tmpSvc := TResponse(Responses.FindResponseByName('ORDERABLE',1)).IValue;
          for i := 0 to Items.Count-1 do
            begin
              if Piece(Items[i],U,6) = tmpSvc then
                begin
                  ItemIndex := i;
                  break;
                end;
            end;*)
          FLastServiceID := ItemID;
          Enabled := False;
          setup508Label(servicelbl508, cboService);
          Font.Color := clGrayText;
          btnServiceTree.Enabled := False;
          pnlServiceTreeButton.Enabled := False;
          Changing := False;
          with Responses do if QuickOrder > 0 then
            begin
              Changing := True;
              if not ShowPrerequisites then
                begin
                  Close;
                  Exit;
                end;
              SetControl(cboCategory,   'CLASS',      1);
              if cboCategory.ItemID = 'I' then radInpatient.Checked := True
              else radOutpatient.Checked := True ;
              SetControl(cboUrgency,    'URGENCY',     1);
              SetControl(cboPlace,      'PLACE',     1);
              SetControl(cboAttn,       'PROVIDER',  1);
              TSimilarNames.RegORComboBox(cboAttn);
              SetControl(calClinicallyIndicated,   'CLINICALLY',  1);
              SetTemplateDialogCanceled(FALSE);
              SetControl(memReason,     'COMMENT',   1);
              if WasTemplateDialogCanceled and OrderContainsObjects then
              begin
                AbortOrder := TRUE;
				        SetTemplateDialogCanceled(FALSE);
                Close;
                Exit;
              end;
//              if ((cboService.ItemIEN > 0) and (Length(memReason.Text) = 0)) then
//                QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
              SetupReasonForRequest(ORDER_QUICK);
              GetProvDxandValidateCode(Responses);
              Changing := False;
            end
          else
            begin
              if cboService.ItemIEN > 0 then
                begin
                  Changing := True;
                  if not ShowPrerequisites then
                    begin
                      Close;
                      Exit;
                    end;
                  DefaultReasonForRequest(memReason.Lines, cboService.ItemID, True);
                  SetupReasonForRequest(ORDER_NEW);
                  Changing := False;
                end;
            end;
        end
      else
        begin
          Changing := True;
          if not ShowPrerequisites then
            begin
              Close;
              Exit;
            end;
          DefaultReasonForRequest(memReason.Lines, cboService.ItemID, True);
          SetupReasonForRequest(ORDER_NEW);
          Changing := False;
        end;
      end;
  treService.Visible := False;
  SetProvDiagPromptingMode;
  tmpSvc := Piece(cboService.Items[cboService.ItemIndex], U, 6);
  pnlMessage.TabOrder := cboService.TabOrder + 1;
  OrderMessage(ConsultMessage(StrToIntDef(tmpSvc, 0)));
  //OrderMessage(ConsultMessage(cboService.ItemIEN));
  ControlChange(Self) ;
  isProsSvc := IsProstheticsService(cboService.ItemIEN);
  if cboService.ItemIEN > 0 then
    isProsSvc := IsProstheticsService(cboService.ItemIEN)
  else
    isProsSvc := False;
  SetUpClinicallyIndicatedDate;    //wat v28
  setup508Label(servicelbl508, cboService);
end;

procedure TfrmODCslt.FormDestroy(Sender: TObject);
begin
  if not FreeGlobalLists then
    Exit;
  inherited;
end;

procedure TfrmODCslt.btnLaunchToolboxClick(Sender: TObject);
var
  sDecision, ErrMsg, HelpText, oldDecision: String;
  tmpResp: TResponse;
begin
  inherited;
  // can be called for a new order or change to existing unsigned order
  // therefore need to try getting existing values
  ValidateDst(ErrMsg);
  if Length(ErrMsg) <= 0 then
  begin
    with Responses do
    begin
      tmpResp := Responses.FindResponseByName('DSTID', 1);
      if tmpResp <> nil then
        getDstMgr.DSTId := tmpResp.IValue;
      tmpResp := FindResponseByName('ORDERABLE', 1);
      if tmpResp <> nil then
        getDstMgr.DSTService := tmpResp.EValue;
      tmpResp := FindResponseByName('URGENCY', 1);
      if tmpResp <> nil then
        getDstMgr.DSTUrgency := tmpResp.EValue;
      tmpResp := FindResponseByName('CLINICALLY', 1);
      if tmpResp <> nil then
        // need double value here, so use FMDateTime instead of tmpResp
        getDstMgr.DSTCid := calClinicallyIndicated.FMDateTime;
      tmpResp := FindResponseByName('NLTD', 1);
      if tmpResp <> nil then
        getDstMgr.DSTNltd := calLatest.FMDateTime;
      tmpResp := Responses.FindResponseByName('CLASS', 1);
      if tmpResp <> nil then
      begin
        if tmpResp.IValue = 'O' then
          getDstMgr.DSTOutpatient := 'True'
        else
          getDstMgr.DSTOutpatient := 'False';
      end
      else
        getDstMgr.DSTOutpatient := 'False';
    end;
    oldDecision := pnlDstStatus.Caption;
    getDstMgr.doDst; // DST_CASE_CONSULT_OD
    if getDstMgr.DSTResult = '' then
    begin
      sDecision := ''; // 'User cancel DST review';
    end
    else if Pos('Error', getDstMgr.DSTResult) = 1 then
    begin
      sDecision := DST_UNAVAIL + CRLF + DST_TRY_LATER;
      setDstStatus(sDecision);
        HelpText := GetUserParam('OR CPRS HELP DESK TEXT');
        if HelpText <> '' then
          InfoBox(DST_UNAVAIL + CRLF + DST_TRY_LATER + CRLF + CRLF +
            HelpText + CRLF + GetDSTMgr.DSTResult,'Communication Error',MB_OK or MB_ICONERROR)
        else
          InfoBox(DST_UNAVAIL + CRLF + DST_TRY_LATER + CRLF + CRLF +
            DST_PERSIST + CRLF + GetDSTMgr.DSTResult,'Communication Error',MB_OK or MB_ICONERROR);
    end
    else if getDstMgr.DSTResult <> '' then
    begin
      Responses.Update('DSTID', 1, getDstMgr.DSTId, getDstMgr.DSTId);
      Responses.Update('DSTDECSN', 1, TX_WPTYPE, getDstMgr.DSTResult);
      sDecision := getDstMgr.DSTResult;
      setDstStatus(sDecision);
    end
    else
    begin
      if sDecision = '' then
        if oldDecision <> DST_UNAVAIL + #10#13 + DST_TRY_LATER then
          sDecision := oldDecision;
      setDstStatus(sDecision);
    end;
  end
  else
  begin
    InfoBox(ErrMsg + CRLF + 'You entered: ' + calClinicallyIndicated.Text,
      'Invalid Date Entered', MB_OK);
    calClinicallyIndicated.SetFocus;
  end;
  if assigned(pnlDSTStatus) then
    pnlDSTStatus.TabStop := (pnlDSTStatus.Caption <> '');
end;

procedure TfrmODCslt.btnServiceTreeClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  Changing := True;
  treService.Visible := not treService.Visible;
  cboService.Visible := not treService.Visible;
  if treService.Visible then
  begin
  // for some reason screen reader is reading caption when tree view is not visible
    treService.Caption := TX_SVC_HRCHY;
    pnlServiceTreeButton.Caption := TX_CLOSE_SVC_HRCHY;
    btnServiceTree.Hint := TX_CLOSE_SVC_HRCHY;
    treService.SetFocus;
    with treService do for i := 0 to Items.Count-1 do
    begin
      if Piece(TORTreeNode(Items[i]).StringData, U, 1) = cboService.ItemID then
        begin
          Selected := Items[i];
          if Piece(TORTreeNode(Items[i]).StringData, U, 5) = '1' then Selected.Expand(True);
          break;
        end;
    end;
  end
  else
  begin
    treService.Caption := '';
    pnlServiceTreeButton.Caption := TX_VIEW_SVC_HRCHY;
    btnServiceTree.Hint := TX_VIEW_SVC_HRCHY;
    pnlServiceTreeButton.SetFocus;
  end;
  Changing := False;
end;

procedure  TfrmODCslt.ReadServerVariables;
begin
  if StrToIntDef(KeyVariable['GMRCNOAT'], 0) > 0 then
    begin
      cboAttn.Enabled    := False;
      cboAttn.Font.Color := clGrayText;
      lblAttn.Enabled    := False;
      cboAttn.Color      := clBtnFace;
    end
  else
    begin
      cboAttn.Enabled    := True;
      cboAttn.Font.Color := clWindowText;
      lblAttn.Enabled    := True;
      cboAttn.Color      := clWindow;
    end;

  if StrToIntDef(KeyVariable['GMRCNOPD'], 0) > 0 then
    begin
      if BILLING_AWARE then
         btnDiagnosis.Enabled   := False //1.4.18
      else
         cmdLexSearch.Enabled   := False;
      txtProvDiag.Enabled    := False;
      txtProvDiag.Font.Color := clGrayText;
      txtProvDiag.ReadOnly   := True;
      txtProvDiag.Color      := clBtnFace;
    end
  else SetProvDiagPromptingMode;

  GMRCREAF := KeyVariable['GMRCREAF'];
end;

procedure TfrmODCslt.treServiceCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  inherited;
  Changing := True;
  treService.Selected := nil;
  Changing := False;
  AllowCollapse := True;
end;

procedure TfrmODCslt.treServiceMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tmpNode: TORTreeNode;
  NodeRect: TRect;
begin
  inherited;
  if Button <> mbLeft then
    Exit;
  tmpNode := TORTreeNode(treService.GetNodeAt(X, Y));
  if tmpNode = nil then
    Exit;
  NodeRect := tmpNode.DisplayRect(true);
  if treService.Selected <> nil then
    if (X >= NodeRect.Left) then
    // user clicked in the text of the item, not on the bitmap
    begin
      if tmpNode.StringData <> '' then
        if (Piece(tmpNode.StringData, U, 5) <> '1') then
        begin
          treService.Visible := false;
          cboService.Visible := true;
        end;
    end;
end;

procedure TfrmODCslt.cmdLexSearchClick(Sender: TObject);
var
  Match: string;
  i: integer;
  EncounterDate: TFMDateTime;
begin
  inherited;

 if  BILLING_AWARE then BADxUpdated := FALSE;

 if (Encounter.VisitCategory = 'A') or (Encounter.VisitCategory = 'I') then
    EncounterDate := Encounter.DateTime
 else
    EncounterDate := FMNow;

 LexiconLookup(Match, LX_ICD, EncounterDate);
 // INC13824577 - DRM - 2021-1-14
 // If the user clicks to another app while in the lexicon lookup, then comes back
 // to CPRS, this form can be pushed "behind" uOrderMenu. This is because both forms
 // have fsStayOnTop.
 BringToFront;
 if Match = '' then Exit;
 ProvDx.Code := Piece(Piece(Match, U, 1), '/', 1);
 ProvDx.Text := Piece(Match, U, 2);
 i := Pos(' (ICD', ProvDx.Text);
 if i = 0 then i := Length(ProvDx.Text) + 1;
 if ProvDx.Text[i-1] = '*' then i := i - 2;
 ProvDx.Text := Copy(ProvDx.Text, 1, i - 1);
 txtProvDiag.Text := ProvDx.Text + ' (' + ProvDx.Code + ')';
 ProvDx.CodeInactive := False;
end;

procedure TfrmODCslt.SetProvDiagPromptingMode;
const
  TX_USE_LEXICON = 'You must use the "Lexicon" button to select a provisional diagnosis for this service.';
  TX_USE_DIAGNOSIS = 'You must use the "Diagnosis" button to select a diagnosis for this service.';

  TX_PROVDX_OPT  = 'Provisional Diagnosis';
  TX_PROVDX_REQD = 'Provisional Dx (REQUIRED)';
begin
  if BILLING_AWARE then
     btnDiagnosis.Enabled    := False //1.4.18
  else
     cmdLexSearch.Enabled   := False;
  txtProvDiag.Enabled    := False;
  txtProvDiag.ReadOnly   := True;
  txtProvDiag.Color      := clBtnFace;
  txtProvDiag.Font.Color := clBtnText;
  txtProvDiag.Hint       := '';
  if cboService.ItemIEN = 0 then Exit;
  ProvDx.PreviousPromptMode := ProvDx.PromptMode;
  GetProvDxMode(ProvDx, cboService.ItemID + CSLT_PTR);
  //  Returns:  string  A^B
  //     A = O (optional), R (required) or S (suppress)
  //     B = F (free-text) or L (lexicon)
  with ProvDx do if (Reqd = '') or (PromptMode = '') then Exit;
  if (ProvDx.PreviousPromptMode <> '') and (ProvDx.PromptMode <> ProvDx.PreviousPromptMode) then
  begin
    ProvDx.Code := '';
    ControlChange(Self);
  end;

  if ProvDx.Reqd = 'R' then
  begin
    lblProvDiag.Caption := TX_PROVDX_REQD;
    if (BILLING_AWARE)  and (ProvDx.PromptMode[1] = '') then btnDiagnosis.Enabled := True;
  end
  else
    lblProvDiag.Caption := TX_PROVDX_OPT;
  if ProvDx.Reqd = 'S' then
    begin
      cmdLexSearch.Enabled   := False;
      txtProvDiag.Enabled    := False;
      txtProvDiag.ReadOnly   := True;
      txtProvDiag.Color      := clBtnFace;
      txtProvDiag.Font.Color := clBtnText;
    end
  else
    case ProvDx.PromptMode[1] of
      'F':  begin
              cmdLexSearch.Enabled   := False;
              txtProvDiag.Enabled    := True;
              txtProvDiag.ReadOnly   := False;
              txtProvDiag.Color      := clWindow;
              txtProvDiag.Font.Color := clWindowText;
            end;
      'L':  begin
              if BILLING_AWARE then
              begin
                 btnDiagnosis.Enabled   := True; //1.4.18
                 txtProvDiag.Hint       := TX_USE_DIAGNOSIS;
              end
              else
              begin
                 cmdLexSearch.Enabled   := True;
                 txtProvDiag.Hint       := TX_USE_LEXICON;
              end;
              txtProvDiag.Enabled    := True;
              txtProvDiag.ReadOnly   := True;
              txtProvDiag.Color      := clInfoBk;
              txtProvDiag.Font.Color := clInfoText;
           end;
    end;
end;


procedure TfrmODCslt.setup508Label(lbl: TVA508StaticText; ctrl: TORComboBox);
begin
  if ScreenReaderSystemActive and not ctrl.Enabled then begin
    lbl.Enabled := True;
    lbl.Visible := True;
    lbl.Caption := lblService.Caption + ', ' + ctrl.Text;
    lbl.Width := (ctrl.Left + ctrl.Width) - lbl.Left;
  end else
    lbl.Visible := false;
end;

procedure TfrmODCslt.mnuPopProvDxDeleteClick(Sender: TObject);
begin
  inherited;
  ProvDx.Text := '';
  ProvDx.Code := '';
  txtProvDiag.Text := '';
  ControlChange(Self);
end;

procedure TfrmODCslt.txtProvDiagChange(Sender: TObject);
begin
  inherited;
  if ProvDx.PromptMode = 'F' then
  begin
    ProvDx.Text := txtProvDiag.Text;
     displayDxCode := ProvDx.Text;
  end;
  ControlChange(Self);
end;

procedure TfrmODCslt.SetupReasonForRequest(OrderAction: integer);
var
  EditReason: string;

  procedure EnableReason;
  begin
    memReason.Color := clWindow;
    memReason.Font.Color := clWindowText;
    memReason.ReadOnly := False;
    lblReason.Caption := 'Reason for Request';
  end;

  procedure DisableReason;
  begin
    memReason.Color := clInfoBk;
    memReason.Font.Color := clInfoText;
    memReason.ReadOnly := True;
    lblReason.Caption := 'Reason for Request  (not editable)';
  end;

begin
  if ((OrderAction = ORDER_QUICK) and (cboService.ItemID <> '') and (Length(memReason.Text) = 0)) then
    DefaultReasonForRequest(memReason.Lines, cboService.ItemID, True);
  EditReason := GMRCREAF;
  if EditReason = '' then EditReason := ReasonForRequestEditable(cboService.ItemID + CSLT_PTR);
  case EditReason[1] of
    '0':  EnableReason;
    '1':  if OrderAction in [ORDER_COPY, ORDER_EDIT] then
            EnableReason
          else
            DisableReason;
    '2':  DisableReason
  else
    EnableReason;
  end;
end;

procedure TfrmODCslt.ShowOrderMessage(Show: boolean);
//var
//  Update: boolean;

begin
(*
  Update := (pnlMessage.Visible <> Show);
  inherited;
  if Update then
  begin
    DisableAlign;
    try
      memOrder.Top := ClientHeight - bvlBottom.Height;
      if Show then
      begin
        memOrder.Top := memOrder.Top - pnlMessage.Height;
        pnlMessage.Top := ClientHeight - bvlBottom.Height;
      end;
      bvlBottom.Top := ClientHeight;
    finally
      EnableAlign;
    end;
    FormResize(Self);
  end;
*)
end;

function TfrmODCslt.ShowPrerequisites: boolean;
var
  AList: TStringList;
const
  TC_PREREQUISITES = 'Service Prerequisites - ';
begin
  Result := True;
  AbortOrder := False;
  AList := TStringList.Create;
  try
    with cboService do
      if ItemIEN > 0 then
        begin
          setServicePrerequisites(aList, ItemID + CSLT_PTR);
          if AList.Count > 0 then
            begin
              if not DisplayPrerequisites(AList, TC_PREREQUISITES + DisplayText[ItemIndex]) then
                begin
                  memOrder.Clear;
                  Result := False;
                  AbortOrder := True;
               end
              else Result := True;
            end;
        end;
  finally
    AList.Free;
  end;
end;

procedure TfrmODCslt.calClinicallyIndicatedExit(Sender: TObject);
begin
  inherited;
  DstStatusUpdate;
end;

procedure TfrmODCslt.cboServiceExit(Sender: TObject);
begin
  inherited;
  if Length(memOrder.Text) = 0 then Exit;
  if (Length(cboService.ItemID) = 0) or (cboService.ItemID = '0') then Exit;
  if cboService.ItemID = FLastServiceID then Exit;
  cboServiceSelect(cboService);
  // CQ #7490, following line commented out v26.24 (RV)
  // CQ #9610 and 10074 - uncommented and "if" added v26.54 (RV)
  if cboService.Enabled then cboService.SetFocus;
  PostMessage(Handle, WM_NEXTDLGCTL, 0, 0);
  DstStatusUpdate;
end;

procedure TfrmODCslt.popReasonPopup(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popReason) is TCustomEdit
    then FEditCtrl := TCustomEdit(PopupComponent(Sender, popReason))
    else FEditCtrl := nil;
  if FEditCtrl <> nil then
  begin
    popReasonCut.Enabled      := FEditCtrl.SelLength > 0;
    popReasonCopy.Enabled     := popReasonCut.Enabled;
    popReasonPaste.Enabled    := (not TORExposedCustomEdit(FEditCtrl).ReadOnly) and
                                   Clipboard.HasFormat(CF_TEXT);
  end else
  begin
    popReasonCut.Enabled      := False;
    popReasonCopy.Enabled     := False;
    popReasonPaste.Enabled    := False;
  end;
  popReasonReformat.Enabled := True;
end;

procedure TfrmODCslt.popReasonCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmODCslt.popReasonCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmODCslt.popReasonPasteClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.SelText := Clipboard.AsText;
end;

procedure TfrmODCslt.popReasonReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memReason then Exit;
  ReformatMemoParagraph(memReason);
end;

function TfrmODCslt.DefaultReasonForRequest(aDest:TStrings; Service: string; Resolve: Boolean): Integer;
var
  TmpSL: TStringList;
  DocInfo: string;
  X: string;
  HasObjects: Boolean;
begin
  Assert(aDest <> nil);
  Resolve := false; // override value passed in - resolve on client - PSI-05-093
  DocInfo := '';
  TmpSL := TStringList.Create;
  try
    setDefaultReasonForRequest(TmpSL, Service + CSLT_PTR, Resolve);
    aDest.Text := TmpSL.Text;
    X := TmpSL.Text;
    ExpandOrderObjects(X, HasObjects);
    TmpSL.Text := X;
    Responses.OrderContainsObjects := HasObjects;
    ExecuteTemplateOrBoilerPlate(TmpSL, cboService.ItemIEN, ltConsult, nil,
      'Reason for Request: ' + cboService.DisplayText
      [cboService.ItemIndex], DocInfo);
    AbortOrder := WasTemplateDialogCanceled;
    Responses.OrderContainsObjects := HasObjects or TemplateBPHasObjects;
    if AbortOrder then
    begin
      aDest.Clear;
      Close;
    end
    else
    begin
      // INC29657166/VISTAOR-35988 - 2024-1-24 - DRM
      // Using SaveToStream/LoadFromStream to bypass a problem in TRichEdit.
      // Sometimes EM_GETLINECOUNT always returns 0, which causes the Assign method,
      // or assigning to the Text property, to reverse the lines.
      aDest.Clear;
      var mStream := TMemoryStream.Create;
      try
        TmpSL.SaveToStream(mStream);
        mStream.Position := 0;
        aDest.LoadFromStream(mStream);
      finally
        mStream.Free;
      end;
      if aDest.Count > 0 then
        SpeakTextInserted;
    end;
  finally
    TmpSL.Free;
  end;
  Result := aDest.Count;
end;

procedure TfrmODCslt.pnlServiceTreeButtonEnter(Sender: TObject);
begin
  inherited;
  (Sender as TPanel).BevelOuter := bvRaised;
end;

procedure TfrmODCslt.pnlServiceTreeButtonExit(Sender: TObject);
begin
  inherited;
  (Sender as TPanel).BevelOuter := bvNone;
end;

procedure TfrmODCslt.treServiceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
  VK_SPACE, VK_RETURN:
    begin
      Key := 0;
      FKeyBoarding := False;
      treServiceChange(Sender, treService.Selected);
      cboService.Visible := not treService.Visible;
    end;
  VK_ESCAPE:
    begin
      key := 0;
      btnServiceTreeClick(Self);
    end
  else
    FKeyBoarding := True;
  end;
end;

procedure TfrmODCslt.treServiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  FKeyBoarding := False;
end;

procedure TfrmODCslt.setDstStatus(aStatus: String);
begin
  pnlDstStatus.Caption := aStatus;
  doSetFontSize;
end;

procedure TfrmODCslt.DoSetFontSize(FontSize: Integer = -1);
var
  iButtonHeight, iButtonWidth, iWidth,
  iTextHeight, iTextWidth: Integer;
begin
  if FontSize = -1 then
    FontSize := Application.MainForm.Font.Size;

  adjustBtn(cmdQuit);
  adjustBtn(cmdAccept);
  adjustBtn(btnLaunchToolbox);

  iButtonHeight := getMainFormTextHeight + GAP;
  iButtonWidth := GetMainFormTextWidth(cmdAccept.Caption) + GAP * 2;
  iWidth := GetMainFormTextWidth(btnLaunchToolbox.Caption) + GAP * 2;
  if iWidth > iButtonWidth then
    iButtonWidth := iWidth;
  grdDstControls.ColumnCollection[1].Value := iButtonWidth;

  iTextWidth := grdDstControls.Width - iButtonWidth;
  iTextHeight := getRectHeight(iTextWidth, pnlDstStatus.Caption);
  if iTextHeight < iButtonHeight then
    iTextHeight := iButtonHeight;

  grdDstControls.RowCollection[0].Value := iTextHeight + GAP;

  grdDstControls.Height := iTextHeight + GAP + 2 * (iButtonHeight + GAP);
  grdDstControls.RowCollection[2].Value := iButtonHeight + GAP;

  memReason.DefAttributes.Size := FontSize;
  treService.Font.Size := FontSize * 7 div 8;

  Constraints.MinHeight := getMinHeight;
end;

procedure TfrmODCslt.SetFontSize(FontSize: integer);
begin
  inherited SetFontSize(FontSize);
  DoSetFontSize(FontSize);
end;

procedure TfrmODCslt.memReasonKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmODCslt.GetProvDxandValidateCode(AResponses: TResponses);
var
  tmpDx: TResponse;

begin
  with AResponses do
    begin
      tmpDx := TResponse(FindResponseByName('MISC',1));
      if tmpDx <> nil then ProvDx.Text := tmpDx.Evalue;
      tmpDx := TResponse(FindResponseByName('CODE',1));
      sourceOrderID := Responses.CopyOrder;
      if (tmpDx <> nil) and (tmpDx.EValue <> '') then
      begin
        if IsActiveICDCode(tmpDx.EValue) then
          ProvDx.Code := tmpDx.Evalue
        else
          begin
            if ProvDx.Reqd = 'R' then
              InfoBox(TX_INACTIVE_CODE1 + TX_INACTIVE_CODE_REQD, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK)
            else
              InfoBox(TX_INACTIVE_CODE1 + TX_INACTIVE_CODE_OPTIONAL, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
            ProvDx.Code := '';
            ProvDx.Text := '';
          end;
      end;
      txtProvDiag.Text := ProvDx.Text;
      if ProvDx.Code <> '' then
         txtProvDiag.Text :=  (txtProvDiag.Text + ' (' + ProvDx.Code + ')' )
      else
      begin
         if BILLING_AWARE  then
           if (sourceOrderID <> '') and (ProvDx.Code <> '') then  // if sourceid exists then user is copying an order.
             SetUpCopyConsultDiagnoses(sourceOrderID);
      end;
   end;
end;

procedure TfrmODCslt.memReasonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  //The navigating tab controls were inadvertantently adding tab characters
  //This should fix it
  FNavigatingTab := (Key = VK_TAB) and ([ssShift,ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmODCslt.memReasonKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processing
end;

procedure TfrmODCslt.cboServiceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  //This fixes clearquest: HDS00001418 Makes it so OnClick is not called
  //Except when Enter or Space is pressed. VK_LBUTTON activates OnClick in TORComboBoxes
  FcboServiceKeyDownStopClick := false;
  if (Key <> VK_RETURN) {and (Key <> VK_SPACE)} and (Key <> VK_LBUTTON) then  //comment on this line is fix for CQ6789
    FcboServiceKeyDownStopClick := True
  else
    Key := VK_LBUTTON;
end;

procedure TfrmODCslt.cboServiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  FcboServiceKeyDownStopClick := false;
end;


procedure TfrmODCslt.btnDiagnosisClick(Sender: TObject);
var
  leftParan, rightParan: string;
//  tmpOrderIDList: TStringList;
begin
  inherited;
//  tmpOrderIDList := TStringList.Create;
//  tmpOrderIDList.Clear;
  leftParan := '(';
  rightParan := ')';
  UBAGlobals.BAtmpOrderList.Clear;
  UBAGlobals.BAtmpOrderList.Add(Responses.OrderText);
  quickCode := '';
  if consultQuickOrder then
  begin
     quickCode := Piece(txtProvDiag.text,'(',2);
     quickCode := Piece(quickCode,')',1);
     if UBACore.IsICD9CodeActive(quickCode,'ICD',0) then
     begin
       uBAGlobals.BAConsultDxList.Clear;
       uBAGlobals.BAConsultDxList.Add(UBAConst.PRIMARY_DX + U + Piece(txtProvDiag.text,'(',1) + ':' +  quickCode);
     end;

  end;
  frmBALocalDiagnoses.Enter(UBAConst.F_CONSULTS, nil);
  if displayDxCode = '' then txtProvDiag.Text := ''
  else
  begin
     if displayDxCode <> 'DXCANCEL' then
     begin
        ProvDx.Code := Piece(displayDxCode,':', 2);
        ProvDx.Text := Piece(displayDxCode,':', 1);
        txtProvDiag.Text := ProvDx.Text + ' (' + ProvDx.Code + ')';
     end;
  end;

  ProvDx.CodeInactive := False;
end;

procedure TfrmODCslt.cmdQuitClick(Sender: TObject);
begin
  inherited;
  if BILLING_AWARE then uBAGlobals.BAConsultDxList.Clear;
end;

procedure  TfrmODCslt.SaveConsultDxForNurse(pDiagnosis: string);
var
  s,tmpTFactors: string;
  tmpList: TStringList;
begin
  tmpList := TStringList.Create;
  try
    s := '';
    tmpList.Add(uBAGlobals.BAOrderID);
    s := GetPatientTFactors(tmpList);
    tmpTFactors := ConvertPIMTreatmentFactors(s);
    BANurseConsultOrders.Add(uBAGlobals.BAOrderID + '1' + tmpTFactors + U + ProvDX.Code);
  finally
    tmpList.Free;
  end;
end;

procedure TfrmODCslt.SetDSTAction(anAction: Integer);
begin
  btnLaunchToolbox.Visible := False;
  GetDSTMgr.DSTAction := anAction;
  btnLaunchToolbox.Visible := GetDSTMgr.DSTBtnVisible;
  btnLaunchToolbox.Enabled := btnLaunchToolbox.Visible;
  stOpenConsultToolboxDisabled.Visible := ScreenReaderSystemActive and not(btnLaunchToolBox.Enabled);
  if stOpenConsultToolboxDisabled.Visible then
    stOpenConsultToolboxDisabled.BringToFront;
end;

procedure TfrmODCslt.SetUpCopyConsultDiagnoses(pOrderID:string);
var
  sourceOrderID, primaryText,primaryCode: string;
  sourceOrderList: TStringList;
  thisOrderList: TStringList;
begin
//logic handles setting up diagnoses when copying an order.
   if IsOrderBillable(pOrderID) then
   begin
      thisOrderList := TStringList.Create;
      try
        thisOrderList.Add(sourceOrderID);
        sourceOrderList := rpcRetrieveSelectedOrderInfo(thisOrderList);
        try
          if sourceOrderList.Count > 0 then
          begin
            primaryText := Piece(sourceOrderList.Strings[0],U,4);
            primaryCode := Piece(sourceOrderList.Strings[0],U,3);
            txtProvDiag.Text := primaryText + ' (' + primaryCode + ')';
            ProvDx.CodeInactive := False;
            // need to handle the rest of the dx's
            uBAGlobals.BAConsultDxList.Clear;
            uBAGlobals.BAConsultDxList.Add(UBAConst.PRIMARY_DX + U + Piece(txtProvDiag.text,'(',1) + ':' +  primaryCode);
            if (Piece(sourceOrderList.Strings[0],U,5) <> '') then // dx2
               uBAGlobals.BAConsultDxList.Add(UBAConst.SECONDARY_DX + U + Piece(sourceOrderList.Strings[0],U,6) + ':' +  Piece(sourceOrderList.Strings[0],U,5));
            if  (Piece(sourceOrderList.Strings[0],U,7) <> '') then // dx3
               uBAGlobals.BAConsultDxList.Add(UBAConst.SECONDARY_DX + U + Piece(sourceOrderList.Strings[0],U,8) + ':' +  Piece(sourceOrderList.Strings[0],U,7));
            if (Piece(sourceOrderList.Strings[0],U,9) <> '') then // dx4
               uBAGlobals.BAConsultDxList.Add(UBAConst.SECONDARY_DX + U + Piece(sourceOrderList.Strings[0],U,10) + ':' +  Piece(sourceOrderList.Strings[0],U,9));
          end;
        finally
          sourceOrderList.Free;
        end;
      finally
        thisOrderList.Free;
      end;
   end;
end;

procedure TfrmODCslt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeDSTMgr;
  inherited;
  frmFrame.pnlVisit.Enabled := true;
end;

procedure TfrmODCslt.FormResize(Sender: TObject);
begin
  inherited;
  LimitEditWidth(memReason, MAX_PROGRESSNOTE_WIDTH-7); //puts memReason at 74 characters
  self.Constraints.MinWidth := TextWidthByFont(memReason.Font.Handle,
    StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 10) +
    ScrollBarWidth;

  self.Constraints.MinHeight := getMinHeight;
end;

procedure TfrmODCslt.FormShow(Sender: TObject);
begin
  inherited;
  self.Constraints.MinHeight := getMinHeight;
end;

function TfrmODCslt.NotinIndex(AList: TStringList; i: integer): Boolean;   {TP - HDS00015782:}
{This function determines if a Consult Service will be added to the cboService
component.  If name does not exist or if name does not exist below the Quick
Order listing, then it is added.}
var
  x: Integer;
  y: String;
begin
  Result := False;
  x := cboService.Items.IndexOf(Trim(Piece(AList.Strings[i], U, 2)));
  if (x = -1) then
    Result := True;
  if (x <> -1) and (x < LLS_LINE_INDEX) then
  begin
    y := cboService.Items[x];
    cboService.Items.Delete(x);
    if (cboService.Items.IndexOf(Trim(Piece(AList.Strings[i], U, 2))) = -1) then
      Result := True;
    cboService.Items.Insert(x,y);
  end;

end;

function TfrmODCslt.GetItemIndex(Service: String; Index: integer): integer;     {TP - HDS00015782:}
{This function returns ItemIndexOf value for Service Consult when a Quick Order
has the exact same name}
var
  y: String;

begin
  y := cboService.Items[Index];
  cboService.Items.Delete(Index);
  Result := (cboService.Items.IndexOf(Trim(Service)) + 1);
  cboService.Items.Insert(Index,y);
end;

procedure TfrmODCslt.SetUpClinicallyIndicatedDate;  //wat v28
begin
  if isProsSvc then
    begin
      lblClinicallyIndicated.Enabled := False;
      calClinicallyIndicated.Enabled := False;
      calClinicallyIndicated.Text := '';
      Responses.Update('CLINICALLY',1,'','');
    end
  else
    begin
      lblClinicallyIndicated.Enabled := True;
      calClinicallyIndicated.Enabled := True;
      if calClinicallyIndicated.Text = 'T' then calClinicallyIndicated.Text := 'TODAY';
    end;
end;


procedure TfrmODCslt.DstStatusUpdate;
var
  b: Boolean;
begin
  { ******Business Logic for enabling DST/CTB buttons
    DST mode must be D or C
    Consult Service, Urgency, CID cannot be null
    Service cannot be prosthetics service
    DST mode C and radInpatient are allowed. DST mode D and radInpatient is not.
  }
  b := (cboService.ItemIEN > 0) and (not isProsSvc) and (cboUrgency.ItemIEN > 0)
    and (Length(calClinicallyIndicated.Text) > 0) and
    getDstMgr.DstProvider.DstParameters.FOrderConsult;

{  if (cboUrgency.Text = 'SPECIAL INSTRUCTIONS') and
    not(Length(calLatest.Text) > 0) then
    b := false;
}

  if (getDstMgr.DSTMode = DST_DST) and (radInpatient.Checked) then
    b := false;

  if getDstMgr.DSTMode = DST_OTH then
    b := false;

  if (b) or (pnlDstStatus.Caption <> '') then
    DoSetFontSize;

  btnLaunchToolbox.Enabled := b;
  stOpenConsultToolboxDisabled.Visible := ScreenReaderSystemActive and not(btnLaunchToolBox.Enabled);
  if stOpenConsultToolboxDisabled.Visible then
    stOpenConsultToolboxDisabled.BringToFront;
end;

procedure TfrmODCslt.clearDstData;
begin
  // DST info n/a for some scenarios like changing from OP to IP
  if getDstMgr.DSTMode = DST_DST then
  begin
{    calLatest.Enabled := false;
    calLatest.Visible := false;
    calLatest.FMDateTime := 0;
    calLatest.Text := '';
    lblLatest.Enabled := false;
    lblLatest.Visible := false;
}
    pnlDstStatus.Caption := '';
    with Responses do
    begin
//      Update('NLTD', 1, '', '');
      Remove('DSTDECSN', 1);
      Update('DSTID', 1, '', '');
    end;
  end;
end;

{
procedure TfrmODCslt.prostheticsUrgency;
var
  i, j: Integer;
begin
  // if ((isProsSvc) or (not isDstEnabled)) and
  if ((isProsSvc) or (DstMgr.DSTMode = DST_OTH)) and
    (cboUrgency.Items.IndexOf('SPECIAL INSTRUCTIONS') <> -1) then
  begin
    cboUrgency.Items.BeginUpdate;
    for i := cboUrgency.Items.Count - 1 downto 0 do
      if cboUrgency.DisplayText[i] = 'SPECIAL INSTRUCTIONS' then
        cboUrgency.Items.Delete(i);
    cboUrgency.Items.EndUpdate;
  end
  else if (cboUrgency.Items.IndexOf('SPECIAL INSTRUCTIONS') = -1) and
  // (isDstEnabled) and (siUrgency <> '') and (not radInpatient.Checked) then
    (DstMgr.DSTMode <> DST_OTH)
    and (siUrgency <> '') and
    (not radInpatient.Checked) then
  begin
    j := cboUrgency.Items.IndexOf('STAT');
    if j > -1 then
    begin
      cboUrgency.Items.BeginUpdate;
      cboUrgency.Items.Insert(j, siUrgency);
      cboUrgency.Items.EndUpdate;
    end;
  end;
end;
}
end.
