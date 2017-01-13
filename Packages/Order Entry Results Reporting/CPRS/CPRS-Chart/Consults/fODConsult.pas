unit fODConsult;

{$O-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ORCtrls, ExtCtrls, ComCtrls, ORfn, uConst, Buttons,
  Menus, UBAGlobals, rOrders, fBALocalDiagnoses, UBAConst, UBACore, ORNet,
  ORDtTm, VA508AccessibilityManager ;

type
  TfrmODCslt = class(TfrmODBase)
    pnlMain: TPanel;
    lblService: TLabel;
    lblProvDiag: TLabel;
    lblUrgency: TLabel;
    lblPlace: TLabel;
    lblAttn: TLabel;
    lblLatest: TStaticText;
    lblClinicallyIndicated: TStaticText;
    pnlReason: TPanel;
    lblReason: TLabel;
    memReason: TRichEdit;
    cboService: TORComboBox;
    cboUrgency: TORComboBox;
    cboPlace: TORComboBox;
    txtProvDiag: TCaptionEdit;
    txtAttn: TORComboBox;
    treService: TORTreeView;
    cboCategory: TORComboBox;
    pnlServiceTreeButton: TKeyClickPanel;
    btnServiceTree: TSpeedButton;
    gbInptOpt: TGroupBox;
    radInpatient: TRadioButton;
    radOutpatient: TRadioButton;
    btnDiagnosis: TButton;
    cmdLexSearch: TButton;
    calClinicallyIndicated: TORDateBox;
    calLatest: TORDateBox;
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
    servicelbl508: TVA508StaticText;
    procedure FormCreate(Sender: TObject);
    procedure txtAttnNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure radInpatientClick(Sender: TObject);
    procedure radOutpatientClick(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure ControlChange(Sender: TObject);
    procedure treServiceExit(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure memReasonExit(Sender: TObject);
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
    procedure DoSetFontSize(FontSize: integer);
    procedure SetUpQuickOrderDX;
    procedure SaveConsultDxForNurse(pDiagnosis: string);  // save the dx entered by nurese if Master BA switch is ON
    procedure SetUpCopyConsultDiagnoses(pOrderID:string);
    procedure AdjustMemReasonSize;
    function NotinIndex(AList: TStringList; i: integer): boolean;
    function GetItemIndex(Service: String; Index: integer): integer;
    procedure SetUpCombatVet;
    procedure SetUpClinicallyIndicatedDate; //wat v28
    procedure setup508Label(lbl: TVA508StaticText; ctrl: TORComboBox);
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    function DefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings;
    
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure SetFontSize(FontSize: integer); override;
  end;

var
  LastNode: integer ;
  displayDXCode: string;
  consultQuickOrder: boolean;


function CanFreeConsultDialog(dialog : TfrmODBase) : boolean;

implementation

{$R *.DFM}

uses
    rODBase, rConsults, uCore, uConsults, rCore, fConsults, fPCELex, rPCE, fPreReq,
    ORClasses, clipbrd, uTemplates, fFrame, uODBase, uVA508CPRSCompatibility,
    VA508AccessibilityRouter;

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

  TX_SVC_HRCHY = 'services/specialties hierarchy';
  TX_VIEW_SVC_HRCHY = 'View services/specialties hierarchically';
  TX_CLOSE_SVC_HRCHY = 'Close services/specialties hierarchy tree view';


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

{*************** TfrmODCslt Methods ***********}

procedure TfrmODCslt.FormCreate(Sender: TObject);
begin
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
  FastAssign(ODForConsults, Defaults);  // ODForConsults returns TStrings with defaults
  CtrlInits.LoadDefaults(Defaults);
  txtAttn.InitLongList('') ;
  PreserveControl(txtAttn);
  PreserveControl(calClinicallyIndicated);
    if (patient.CombatVet.IsEligible = True) then
   begin
     SetUpCombatVet;
   end
   else
    begin
      txtCombatVet.Enabled := False;
      pnlCombatVet.SendToBack;
    end;
  InitDialog;
  //Calling virtual SetFontSize in constructor is a bad idea!
  DoSetFontSize( MainFontSize);
  FcboServiceKeyDownStopClick := false;
  consultQuickOrder := false;
end;

procedure TfrmODCslt.InitDialog;
begin
  inherited;
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
         FastAssign(LoadServiceList(False, StrToIntDef(SvcIEN, 1), 0), TempSvcList); {RV}
         FastAssign(TempSvcList, TempAList);
         //Grouper
         if Piece(TempAList.Strings[0], U, 5) = '1' then begin
          InfoBox(TX_GROUP_SVC, TX_GROUP_SVC_CAP, MB_ICONERROR or MB_OK);
          AbortOrder := True;
          Close;
          Exit;
         end;
         //Tracking
         if Piece(TempAList.Strings[0], U, 5) = '2' then begin
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
      SetControl(cboUrgency,    'URGENCY',   1);
      SetControl(cboPlace,      'PLACE',     1);
      SetControl(txtAttn,       'PROVIDER',  1);
      SetControl(calClinicallyIndicated,   'CLINICALLY',  1);
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
      FastAssign(LoadServiceListWithSynonyms(CN_SVC_LIST_ORD), SvcList);           {RV}
      FastAssign(SvcList, AList);
      SortByPiece(AList, U, 2);
      BuildServiceTree(treService, SvcList, '0', nil) ;
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
          QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
        end;
      PreserveControl(treService);
      PreserveControl(cboService);
    end;
  finally
    AList.Free;
  end;
end;

procedure TfrmODCslt.Validate(var AnErrMsg: string);

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

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
  if (lblClinicallyIndicated.Enabled) and (calClinicallyIndicated.FMDateTime < FMToday) then SetError(TX_PAST_DATE);
end;

procedure TfrmODCslt.txtAttnNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  txtAttn.ForDataUse(SubSetOfPersons(StartFrom, Direction));
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
      SetControl(txtAttn,       'PROVIDER',  1);
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
        QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
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
          QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
          SetupReasonForRequest(ORDER_NEW);
        end;
    end;
  SetProvDiagPromptingMode;
  SetUpClinicallyIndicatedDate; //wat v28
  tmpSvc := Piece(cboService.Items[cboService.ItemIndex], U, 6);
  pnlMessage.TabOrder := treService.TabOrder + 1;
  OrderMessage(ConsultMessage(StrToIntDef(tmpSvc, 0)));
  //OrderMessage(ConsultMessage(cboService.ItemIEN));
  ControlChange(Self) ;
end;

procedure TfrmODCslt.ControlChange(Sender: TObject);
var
  x: string;
  i: integer;
begin
  inherited;
  if Changing or (cboService.ItemIEN = 0) then Exit;
  with cboService    do
    begin
      if (ItemIEN > 0) and (Piece(Items[ItemIndex], U, 5) <> '1') then
        begin
          i := Pos('<', Text);
          if i > 0 then
            begin
              x := Piece(Copy(Text, i + 1, 99), '>', 1);
              x := UpperCase(Copy(x, 1, 1)) + Copy(x, 2, 99);
            end
          else
            x := Text;
          Responses.Update('ORDERABLE', 1, Piece(Items[ItemIndex], U, 6), x);
        end
      else Responses.Update('ORDERABLE', 1, '', '');
    end;
  with memReason     do  Responses.Update('COMMENT',   1, TX_WPTYPE, Text);
  with cboCategory   do  Responses.Update('CLASS',     1, ItemID, Text);
  with cboUrgency    do  Responses.Update('URGENCY',   1, ItemID, Text);
  with cboPlace      do  Responses.Update('PLACE',     1, ItemID, Text);
  with txtAttn       do  Responses.Update('PROVIDER',  1, ItemID, Text);
  with calClinicallyIndicated   do if Length(Text) > 0 then Responses.Update('CLINICALLY',  1, Text,   Text);
  //with txtProvDiag   do if Length(Text) > 0 then Responses.Update('MISC',      1, Text,   Text);
  if Length(ProvDx.Text)                > 0 then Responses.Update('MISC',      1, ProvDx.Text,   ProvDx.Text)
   else Responses.Update('MISC',      1, '',   '');
  if Length(ProvDx.Code)                > 0 then Responses.Update('CODE',      1, ProvDx.Code,   ProvDx.Code)
   else Responses.Update('CODE',      1, '',   '');

  memOrder.Text := Responses.OrderText;
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
      OrderMessage(ConsultMessage(StrToInt(Piece(Items[ItemIndex],U,6))));
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

procedure TfrmODCslt.memReasonExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    //QuickCopy(memReason, AStringList);
    AStringList.Text := memReason.Text;
    LimitStringLength(AStringList, 74);
    //QuickCopy(AstringList, memReason);
    memReason.Text := AStringList.Text;
    ControlChange(Self);
  finally
    AStringList.Free;
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
              SetControl(txtAttn,       'PROVIDER',  1);
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
                  QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
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
          QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
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
  SetUpClinicallyIndicatedDate;    //wat v28
  setup508Label(servicelbl508, cboService);
end;

procedure TfrmODCslt.FormDestroy(Sender: TObject);
begin
  if not FreeGlobalLists then
    Exit;
  inherited;
end;

procedure TfrmODCslt.btnServiceTreeClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  Changing := True;
  treService.Visible := not treService.Visible;
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
      txtAttn.Enabled    := False;
      txtAttn.Font.Color := clGrayText;
      lblAttn.Enabled    := False;
      txtAttn.Color      := clBtnFace;
    end
  else
    begin
      txtAttn.Enabled    := True;
      txtAttn.Font.Color := clWindowText;
      lblAttn.Enabled    := True;
      txtAttn.Color      := clWindow;
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

procedure TfrmODCslt.treServiceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tmpNode: TORTreeNode;
  NodeRect: TRect;
begin
  inherited;
  if Button <> mbLeft then exit;
  tmpNode := TORTreeNode(treService.GetNodeAt(X, Y));
  if tmpNode = nil then exit;
  NodeRect := tmpNode.DisplayRect(True);
  if treService.Selected <> nil then
    if (X >= NodeRect.Left) then     // user clicked in the text of the item, not on the bitmap
      begin
        if tmpNode.StringData <> '' then
          if (Piece(tmpNode.StringData, U, 5) <> '1') then
            treService.Visible := False;
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
    QuickCopy(DefaultReasonForRequest(cboService.ItemID, True), memReason);
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
          FastAssign(GetServicePrerequisites(ItemID + CSLT_PTR), Alist);
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

function TfrmODCslt.DefaultReasonForRequest(Service: string;
  Resolve: Boolean): TStrings;
var
  TmpSL: TStringList;
  DocInfo: string;
  x: string;
  HasObjects: boolean;
begin
  Resolve := FALSE ;  // override value passed in - resolve on client - PSI-05-093
  DocInfo := '';
  TmpSL := TStringList.Create;
  try
    Result := GetDefaultReasonForRequest(Service + CSLT_PTR, Resolve);
    TmpSL.Text := Result.Text;
    x := TmpSL.Text;
    ExpandOrderObjects(x, HasObjects);
    TmpSL.Text := x;
    Responses.OrderContainsObjects := HasObjects;
    ExecuteTemplateOrBoilerPlate(TmpSL, cboService.ItemIEN , ltConsult, nil, 'Reason for Request: ' + cboService.DisplayText[cboService.ItemIndex], DocInfo);
    AbortOrder := WasTemplateDialogCanceled;
    Responses.OrderContainsObjects := HasObjects or TemplateBPHasObjects;
    if AbortOrder then begin
      Result.Text := '';
      Close;
      Exit;
    end else begin
      Result.Text := TmpSL.Text;
      if Result.Count > 0 then
        SpeakTextInserted;
    end;
  finally
    TmpSL.Free;
  end;
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

procedure TfrmODCslt.DoSetFontSize(FontSize: integer);
begin
  memReason.DefAttributes.Size := FontSize;
  treService.Font.Size := FontSize * 7 div 8;
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
  tmpOrderIDList: TStringList;
begin
  inherited;
  tmpOrderIDList := TStringList.Create;
  tmpOrderIDList.Clear;
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
   tmpList.Clear;
   s := '';
   tmpList.Add(uBAGlobals.BAOrderID);
   s := GetPatientTFactors(tmpList);
   tmpTFactors := ConvertPIMTreatmentFactors(s);
   BANurseConsultOrders.Add(uBAGlobals.BAOrderID + '1' + tmpTFactors + U + ProvDX.Code);
end;

procedure TfrmODCslt.SetUpCopyConsultDiagnoses(pOrderID:string);
var
  sourceOrderID, primaryText,primaryCode: string;
  sourceOrderList: TStringList;
  thisOrderList: TStringList;
begin
//logic handles setting up diagnoses when copying an order.
   sourceOrderList := TStringList.Create;
   sourceOrderList.Clear;
   thisOrderList := TStringList.Create;
   thisOrderList.Clear;
   if IsOrderBillable(sourceOrderID) then
   begin
      thisOrderList.Add(sourceOrderID);
      sourceOrderList := rpcRetrieveSelectedOrderInfo(thisOrderList);
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
end;

procedure TfrmODCslt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frmFrame.pnlVisit.Enabled := true;
end;

procedure TfrmODCslt.FormResize(Sender: TObject);
begin
  inherited;
  AdjustMemReasonSize();
end;

procedure TfrmODCslt.AdjustMemReasonSize;
const
  PIXEL_SPACE = 3;
begin
  pnlReason.Top := cboService.Top + cboService.Height + PIXEL_SPACE;
  pnlReason.Height := memOrder.Top - pnlReason.Top - PIXEL_SPACE;
  if patient.CombatVet.IsEligible then pnlReason.Height := pnlReason.Height - PIXEL_SPACE*20;
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

procedure TfrmODCslt.SetUpCombatVet;
begin
     pnlCombatVet.BringToFront;
     txtCombatVet.Enabled := True;
     txtCombatVet.Caption := 'Combat Veteran Eligibility Expires on ' + patient.CombatVet.ExpirationDate;
     pnlMain.Top := pnlMain.Top + pnlCombatVet.Height;
     pnlMain.Anchors := [akLeft,akTop,akRight];
     treService.Anchors := [akLeft,akTop,akRight];
     self.Height := self.Height + pnlCombatVet.Height;
     treService.Anchors := [akLeft,akTop,akRight,akBottom];
     pnlMain.Anchors := [akLeft,akTop,akRight,akBottom];
end;

procedure TfrmODCslt.SetUpClinicallyIndicatedDate;  //wat v28
begin
  if IsProstheticsService(cboService.ItemIEN) = '1' then
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

end.


