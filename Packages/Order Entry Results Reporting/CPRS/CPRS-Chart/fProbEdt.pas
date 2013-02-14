unit fProbEdt;

interface

uses
  SysUtils, windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Grids,
  ORCtrls, Vawrgrid, uCore, Menus, uConst, fBase508Form,
  VA508AccessibilityManager;

const
  SOC_QUIT = 1;        { close single dialog }

type
  TfrmdlgProb = class(TfrmBase508Form)
    Label1: TLabel;
    Label5: TLabel;
    edResDate: TCaptionEdit;
    Label7: TLabel;
    edUpdate: TCaptionEdit;
    pnlBottom: TPanel;
    bbQuit: TBitBtn;
    bbFile: TBitBtn;
    pnlComments: TPanel;
    Bevel1: TBevel;
    lblCmtDate: TOROffsetLabel;
    lblComment: TOROffsetLabel;
    lblCom: TStaticText;
    bbAdd: TBitBtn;
    bbRemove: TBitBtn;
    lstComments: TORListBox;
    bbEdit: TBitBtn;
    pnlTop: TPanel;
    lblAct: TLabel;
    rgStatus: TKeyClickRadioGroup;
    rgStage: TKeyClickRadioGroup;
    bbChangeProb: TBitBtn;
    edProb: TCaptionEdit;
    gbTreatment: TGroupBox;
    ckSC: TCheckBox;
    ckRad: TCheckBox;
    ckAO: TCheckBox;
    ckENV: TCheckBox;
    ckHNC: TCheckBox;
    ckMST: TCheckBox;
    ckSHAD: TCheckBox;
    ckVerify: TCheckBox;
    edRecDate: TCaptionEdit;
    cbServ: TORComboBox;
    cbLoc: TORComboBox;
    lblLoc: TLabel;
    cbProv: TORComboBox;
    Label3: TLabel;
    edOnsetdate: TCaptionEdit;
    Label6: TLabel;
    procedure bbQuitClick(Sender: TObject);
    procedure bbAddComClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbFileClick(Sender: TObject);
    procedure bbRemoveClick(Sender: TObject);
    procedure cbProvKeyPress(Sender: TObject; var Key: Char);
    procedure rgStatusClick(Sender: TObject);
    procedure cbProvClick(Sender: TObject);
    procedure cbLocClick(Sender: TObject);
    procedure cbLocKeyPress(Sender: TObject; var Key: Char);
    procedure SetDefaultProb(Alist:TstringList;prob:string);
    procedure ControlChange(Sender: TObject);
    function  BadDates:Boolean;
    procedure cbProvDropDown(Sender: TObject);
    procedure cbLocDropDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbChangeProbClick(Sender: TObject);
    procedure cbLocNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cbProvNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cbServNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure bbEditClick(Sender: TObject);
  private
    { Private declarations }
    FEditing: Boolean;
    FInitialShow: Boolean;
    FModified: Boolean;
    FProviderID: Int64;
    FLocationID: Longint;
    FDisplayGroupID: Integer;
    FInitialFocus: TWinControl;
    FCtrlMap: TStringList;
    FSourceOfClose: Integer;
    FOnInitiate: TNotifyEvent;
    fChanged:boolean;
    FSilent: boolean;
    FCanQuit: boolean;

    procedure UMTakeFocus(var Message: TMessage); message UM_TAKEFOCUS;
    procedure ShowComments;
    procedure GetEditedComments;
    procedure GetNewComments(Reason:char);
    function  OkToQuit:boolean;
    procedure ShowServiceCombo;
    procedure ShowClinicLocationCombo;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoShow; override;
    procedure Loaded; override;
    procedure ClearDialogControls; virtual;
    function  LackRequired: Boolean; virtual;
    procedure LoadDefaults; virtual;
    property  InitialFocus: TWinControl read FInitialFocus write FInitialFocus;
  public
    { Public declarations }
    Reason:Char;
    problemIFN:String;
    subjProb:string; {parameters for problem being added}
    constructor Create(AOwner: TComponent); override ;
    destructor Destroy; override;
    property DisplayGroupID: Integer read FDisplayGroupID write FDisplayGroupID;
    property Editing: Boolean read FEditing write FEditing;
    property Silent: Boolean read FSilent write FSilent;
    property ProviderID: Int64 read FProviderID write FProviderID;
    property LocationID: Longint read FLocationID write FLocationID;
    property SourceOfClose: Integer read FSourceOfClose write FSourceOfClose;
    property OnInitiate: TNotifyEvent read FOnInitiate write FOnInitiate;
    procedure SetFontSize( NewFontSize: integer);
    property CanQuit: boolean read FCanQuit write FCanQuit;
  end ;

implementation

{$R *.DFM}

uses ORFn, uProbs, fProbs, rProbs, fCover, rCover, rCore, fProbCmt, fProbLex, rPCE, uInit  ,
     VA508AccessibilityRouter;

type
  TDialogItem = class { for loading edits & quick orders }
    ControlName: string;
    DialogPtr: Integer;
    Instance: Integer;
  end;

function TfrmdlgProb.OkToQuit:boolean;
begin
  Result := not fChanged;
end;

procedure TfrmdlgProb.bbQuitClick(Sender: TObject);
begin
  if OkToQuit then
    begin
      frmProblems.lblProbList.caption := frmProblems.pnlRight.Caption ;
      frmProblems.wgProbData.TabStop := True; //CQ #15531 part (c) [CPRS v28.1] {TC}.
      //correct JAWS from reading the 'Edit Problem' caption of the wgProbData captionlistbx.
      if AnsiCompareText(frmProblems.wgProbData.Caption, 'Edit Problem')=0 then
         frmProblems.wgProbData.Caption := frmProblems.lblProbList.caption;
      close;
    end
  else
    begin
      if (not FSilent) and
         (InfoBox('Discard changes?', 'Add/Edit a Problem', MB_YESNO or MB_ICONQUESTION) <> IDYES) then
        begin
          FCanQuit := False;
          exit;
        end
      else
        begin
          frmProblems.lblProbList.caption := frmProblems.pnlRight.Caption ;
          frmProblems.wgProbData.TabStop := True; //CQ #15531 part (c) [CPRS v28.1] {TC}.
          //correct JAWS from reading the 'Edit Problem' caption of the wgProbData captionlistbx.
          if AnsiCompareText(frmProblems.wgProbData.Caption, 'Edit Problem')=0 then
             frmProblems.wgProbData.Caption := frmProblems.lblProbList.caption;
          FCanQuit := True;
          close;
        end;
    end;
end;

procedure TfrmdlgProb.bbAddComClick(Sender: TObject);
var
  cmt: string    ;
begin
  cmt := NewComment ;
  if StrToInt(Piece(cmt, U, 1)) > 0 then
    begin
      lstComments.Items.Add(Pieces(cmt, U, 2, 3)) ;
      fChanged := true;
    end ;
end;

procedure TfrmdlgProb.bbEditClick(Sender: TObject);
var
  cmt: string    ;
begin
  if lstComments.ItemIndex < 0 then Exit;
  cmt := EditComment(lstComments.Items[lstComments.ItemIndex]) ;
  if StrToInt(Piece(cmt, U, 1)) > 0 then
    begin
      lstComments.Items[lstComments.ItemIndex] := Pieces(cmt, U, 2, 3) ;
      fChanged := true;
    end ;
end;

procedure TfrmdlgProb.FormShow(Sender: TObject);
var
  alist: TstringList;
  Anchorses: Array of TAnchors;
  i: integer;
begin
  if ProbRec <> nil then exit;
  if (ResizeWidth(Font,MainFont,Width) >= Parent.ClientWidth) and
    (ResizeHeight(Font,MainFont,Height) >= Parent.ClientHeight) then
  begin  //This form won't fit when it resizes, so we have to take Drastic Measures
    SetLength(Anchorses, dlgProbs.ControlCount);
    for i := 0 to ControlCount - 1 do
    begin
      Anchorses[i] := Controls[i].Anchors;
      Controls[i].Anchors := [akLeft, akTop];
    end;
    SetFontSize(MainFontSize);
    RequestAlign;
    for i := 0 to ControlCount - 1 do
      Controls[i].Anchors := Anchorses[i];
  end
  else
  begin
    SetFontSize(MainFontSize);
    RequestAlign;
  end;
  frmProblems.mnuView.Enabled := False;
  frmProblems.mnuAct.Enabled := False ;
  frmProblems.lstView.Enabled := False;
  frmProblems.bbNewProb.Enabled := False ;
  Alist := TstringList.create;
  try
    if Reason = 'E' then
      lblact.caption := 'Editing:'
    else if Reason = 'A' then
      lblact.caption := 'Adding'
    else {display, comment edit or remove problem}
      begin
        case reason of 'C','c': lblact.caption := 'Comment Edit';
                       'R','r': lblact.caption := 'Remove Problem:';
        end; {case}
        {ckVerify.Enabled:=false;}
        cbProv.Enabled       := false;
        cbLoc.Enabled        := false;
        bbRemove.enabled     := false;
        rgStatus.Enabled     := false;
        rgStage.Enabled      := false;
        edRecdate.enabled    := false;
        edResdate.enabled    := false;
        edOnsetDate.enabled  := false;
        ckSC.enabled         := false;
        ckRAD.enabled        := false;
        ckAO.enabled         := false;
        ckENV.enabled        := false;
        ckHNC.enabled        := false;
        ckMST.enabled        := false;
        ckSHAD.enabled       := false;
        if Reason = 'R' then bbFile.caption := 'Remove';
      end;
    edProb.Caption := lblact.Caption;
    if Piece(subjProb,U,3) <> '' then
      edProb.Text := Piece(subjProb, u, 2) + ' (' + Piece(subjProb, u, 3) + ')'
    else
      edProb.Text := Piece(subjProb, u, 2);
    {line up problem action and title}
    {edProb.Left:=lblAct.left+lblAct.width+2;}
    {get problem}
    if Reason <> 'A' then
      begin {edit,remove or display existing problem}
        problemIFN := Piece(subjProb, u, 1);
        FastAssign(EditLoad(ProblemIFN, User.DUZ, PLPt.ptVAMC), AList) ;   //V17.5   RV
      end
    else {new  problem}
      SetDefaultProb(Alist, subjProb);
    if Alist.count = 0 then
      begin
        InfoBox('No Data on Host for problem ' + ProblemIFN, 'Information', MB_OK or MB_ICONINFORMATION);
        close;
        exit;
      end;
    ProbRec := TProbRec.Create(Alist); {create a problem object}
    ProbRec.PIFN := ProblemIFN;
    ProbRec.EnteredBy.DHCPtoKeyVal(inttostr(User.DUZ) + u + User.Name);
    ProbRec.RecordedBy.DHCPtoKeyVal(inttostr(Encounter.Provider) + u + Encounter.ProviderName);
    {fill in defaults}
    edOnsetdate.text := ProbRec.DateOnsetStr;
    if Probrec.status <> 'A' then
      begin
        rgStatus.itemindex := 1;
        rgStage.Visible := False ;
      end;
    if Probrec.Priority = 'A' then
      rgStage.itemindex := 0
    else if Probrec.Priority = 'C' then
      rgStage.itemindex := 1
    else
      rgStage.itemindex := 2;
    rgStatus.TabStop := (rgStatus.ItemIndex = -1);
    rgStage.TabStop := (rgStage.ItemIndex = -1);
    edRecDate.text := Probrec.DateRecStr;
    edUpdate.text := Probrec.DateModStr;
    edResDate.text := ProbRec.DateResStr;
    edUpdate.enabled := false;
    if pos(Reason,'CR') = 0 then
      with PLPt do
        begin
          if UpperCase(Reason) = 'E' then
            begin
              ckSC.Enabled  := ProbRec.SCProblem or PtServiceConnected;
              ckSC.checked  := ProbRec.SCProblem;
            end
          else
            begin
              ckSC.enabled  := PtServiceConnected ;
              ckSC.checked  := ProbRec.SCProblem and PtServiceConnected ;
            end;
          ckAO.enabled  := PtAgentOrange ;
          ckRAD.enabled := PtRadiation ;
          ckENV.enabled := PtEnvironmental ;
          ckHNC.enabled := PtHNC ;
          ckMST.enabled := PtMST ;
          ckSHAD.Enabled := PtSHAD;
          ckAO.checked  := Probrec.AOProblem and PtAgentOrange;
          ckRAD.checked := Probrec.RADProblem and PtRadiation;
          ckENV.checked := Probrec.ENVProblem and PtEnvironmental;
          ckHNC.checked := Probrec.HNCProblem and PtHNC;
          ckMST.checked := Probrec.MSTProblem and PtMST;
          ckSHAD.Checked := Probrec.SHADProlem and PtSHAD;
        end ;
    cbProv.InitLongList(ProbRec.RespProvider.extern) ;
    if (ProbRec.RespProvider.intern <> '') and (StrToInt64Def(ProbRec.RespProvider.intern, 0) > 0) then
      cbProv.SelectByIEN(StrToInt64(ProbRec.RespProvider.intern));

    if UpperCase(Reason) = 'A' then
      begin
        if Encounter.Inpatient then
          begin
            ShowServiceCombo();
            cbServ.InitLongList('');
          end
        else
          begin
            ShowClinicLocationCombo();
            cbLoc.InitLongList(Encounter.LocationName);
            cbLoc.SelectByIEN(Encounter.Location);
          end;
      end
    else
      begin
        if (ProbRec.Service.DHCPField = '^') and  (ProbRec.Clinic.DHCPField <> '^') then
          begin
            ShowClinicLocationCombo();
            cbLoc.InitLongList(ProbRec.Clinic.Extern);
            cbLoc.SelectByID(ProbRec.Clinic.Intern);
          end
        else if (ProbRec.Clinic.DHCPField = '^') and  (ProbRec.Service.DHCPField <> '^') then
          begin
            ShowServiceCombo();
            cbServ.InitLongList(ProbRec.Service.Extern);
            cbServ.SelectByID(ProbRec.Service.Intern);
          end
        else
          begin
            if Encounter.Inpatient then
              begin
                ShowServiceCombo();
                cbServ.InitLongList('');
              end
            else
              begin
                ShowClinicLocationCombo();
                cbLoc.InitLongList('');
              end;
          end;
      end;
    cbLoc.Caption := lblLoc.Caption;

    ShowComments;
    if ProbRec.CmtIsXHTML then
      begin
        bbAdd.Enabled := FALSE;
        bbEdit.Enabled := FALSE;
        bbRemove.Enabled := FALSE;
        pnlComments.Hint := ProbRec.CmtNoEditReason;
      end
    else
      begin
        bbAdd.Enabled := TRUE;
        bbEdit.Enabled := TRUE;
        bbRemove.Enabled := TRUE;
        pnlComments.Hint := '';
      end ;
   // ===================  changed code - REV 7/30/98  =========================
   // PlUser.usVerifyTranscribed is a SITE requirement, not a user ability
    if Reason = 'A' then
      begin
        if PlUser.usVerifyTranscribed and not PlUser.usPrimeUser then
          ckVerify.Checked := False
        else
          ckVerify.Checked := True;
      end
    else ckVerify.checked := (Probrec.condition = 'P');
   //===========================================================================
   (* if (PlUSer.usVerifyTranscribed) and (Reason='A') then
      begin {some users can add and verify}
        {ckVerify.visible:=true;}
        ckVerify.checked:=true; {assume it will be entered verified}
      end {others can add and edit verified status}
    else if (PlUSer.usVerifyTranscribed) and (PlUser.usPrimeUser) then
      begin
        {ckVerify.visible:=true; }
        ckVerify.checked:=(Probrec.condition='P');
      end;  *)
    if Reason <> 'A' then fChanged := False else fChanged := True; {initialize form for changes}
  finally
    alist.free;
  end;
end;

procedure TfrmdlgProb.ShowComments;
var
  i:integer;
begin
  with ProbRec do
    for i:=0 to Pred(fComments.count) do
      lstComments.Items.Add(TComment(fComments[i]).ExtDateAdd + '^' + TComment(fComments[i]).Narrative);
end;


procedure TfrmdlgProb.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Alist: TStringList;
begin
  AList := TStringList.Create;
  try
    //frmProblems.lblProbList.caption := frmProblems.pnlRight.Caption ;  {moved to bbQuit - only on CANCEL}
    TWinControl(parent).visible := false;
    with frmProblems do
      begin
        pnlProbList.Visible := False ;
        edProbEnt.text := '';
        pnlView.BringToFront ;
        pnlView.Show   ;
        mnuView.Enabled := True;
        mnuAct.Enabled := True ;
        lstView.Enabled := True ;
        bbNewProb.Enabled := true ;
        if fChanged then LoadPatientProblems(AList,PLUser.usViewAct[1],false);
      end ;
    Action := caFree;
 finally
    AList.Free;
  end;
end;

{--------------------------------- file ---------------------------------}

procedure TfrmdlgProb.bbFileClick(Sender: TObject);
const
  TX_INACTIVE_ICODE   = 'This problem references an inactive ICD-9-CM code.' + #13#10 +
                       'The code must be updated using the ''Change''' + #13#10 +
                       'button before it can be saved';
  TC_INACTIVE_ICODE   = 'Inactive ICD-9-CM Code';
var
  AList: TstringList;
  remcom, vu, ut: string;
  i: integer;
begin
  frmProblems.wgProbData.TabStop := True;  //CQ #15531 part (c) [CPRS v28.1] {TC}.
  if (Reason <> 'R') and (Reason <> 'r') then
    if (rgStatus.itemindex=-1) or (cbProv.itemindex=-1) then
      begin
        InfoBox('Status and Responsible Provider are required.', 'Information', MB_OK or MB_ICONINFORMATION);
        exit;
      end;
  if Reason in ['C','c','E','e'] then
    if not IsActiveICDCode(ProbRec.Diagnosis.extern) then
      begin
        InfoBox(TX_INACTIVE_ICODE, TC_INACTIVE_ICODE, MB_ICONWARNING or MB_OK);
        exit;
      end;
  if BadDates then exit;
  Alist:=TStringList.create;
  try
    screen.cursor := crHourGlass;
      {if (ckVerify.visible) then }
    if (ckVerify.Checked) then
      ProbRec.Condition := 'P'
    else
      Probrec.Condition := 'T';
    if rgStatus.itemindex = 0 then
      Probrec.status := 'A'
    else if rgstatus.itemindex = 1 then
      Probrec.status := 'I';
    if rgStage.itemindex = 0 then
      Probrec.Priority := 'A'
    else if rgStage.itemindex = 1 then
      Probrec.Priority := 'C';
    ProbRec.DateOnsetStr := edOnsetDate.text;
    ProbRec.DateResStr   := edResDate.text;{aka inactivation date}
    ProbRec.DateRecStr   := edRecDate.text;{recorded anywhere}
    if edUpdate.text = '' then
      ProbRec.DateModStr := DatetoStr(trunc(FMNow))
    else
      ProbRec.DateModStr := edUpdate.text; {last update}
    (*if ckSC.enabled then *)Probrec.SCProblem    := ckSC.checked;
    if ckRAD.enabled then Probrec.RadProblem  := ckrad.Checked;
    if ckAO.enabled then ProbRec.AOProblem    := ckAO.checked;
    if ckENV.enabled then ProbRec.ENVProblem  := ckENV.Checked;
    if ckHNC.enabled then ProbRec.HNCProblem  := ckHNC.Checked;
    if ckMST.enabled then ProbRec.MSTProblem  := ckMST.Checked;
    if ckSHAD.Enabled then ProbRec.SHADProlem := ckSHAD.Checked;
    if cbProv.itemindex = -1 then {Get provider}
      begin
        Probrec.respProvider.intern := '0';
        Probrec.RespProvider.extern := '';
      end
    else
      ProbRec.RespProvider.DHCPtoKeyVal(cbProv.Items[cbProv.itemindex]);
    if cbLoc.itemindex = -1 then {Get Clinic}
      begin
        Probrec.Clinic.intern := '';
        Probrec.Clinic.extern := '';
      end
    else
      ProbRec.Clinic.DHCPtoKeyVal(cbLoc.Items[cbLoc.itemindex]);
    if cbServ.itemindex = -1 then  {Get Service}
      begin
        Probrec.Service.intern := '';
        Probrec.Service.extern := '';
      end
    else
      Probrec.Service.DHCPtoKeyVal(cbServ.Items[cbServ.itemindex]);
    if ProbRec.Commentcount > 0 then GetEditedComments;
    GetNewComments(Reason);
    case Reason of
      'E','e','C','c': {edits or comments}
        begin
          ut := '';
          if PLUser.usPrimeUser then ut := '1';
          FastAssign(EditSave(ProblemIFN, User.DUZ, PLPt.ptVAMC, ut, ProbRec.FilerObject), AList) ;    //V17.5  RV
        end;
      'A','a':  {new problem}
         FastAssign(AddSave(PLPt.GetGMPDFN(Patient.DFN, Patient.Name),
           pProviderID, PLPt.ptVAMC, ProbRec.FilerObject), AList) ;  //*DFN*
      'R','r': {remove problem}
         begin
           remcom := '';
           if Probrec.commentcount > 0 then
             if TComment(Probrec.comments[pred(probrec.commentcount)]).IsNew then
               remcom := TComment(Probrec.comments[pred(probrec.commentcount)]).Narrative;
           FastAssign(ProblemDelete(ProbRec.PIFN, User.DUZ, PLPt.ptVAMC, remcom), AList) ;    //changed in v14
         end
    else exit;
    end; {case}
    screen.cursor := crDefault;
    if Alist.count < 1 then
      InfoBox('Broker time out filing on Host. Try again in a moment or cancel', 'Information', MB_OK or MB_ICONINFORMATION)
    else if Alist[0] = '1' then
      begin
        Alist.clear;
        vu:=PLUser.usViewAct;
        fChanged := True;  {ensure update of problem list on close}
        //frmProblems.LoadPatientProblems(AList,vu[1],false); 
          { update cover sheet problem list }
        with frmCover do
          for i := ComponentCount - 1 downto 0 do
            begin
              if Components[i] is TORListBox then
                begin
                  case Components[i].Tag of
                    10: ListActiveProblems((Components[i] as TORListBox).Items);
                  end;
                end;
            end;
        Close;
      end
    else
      InfoBox('Unable to lock record for filing on Host. Try again in a moment or cancel',
        'Information', MB_OK or MB_ICONINFORMATION);
  finally
    Alist.free
  end;
end;

procedure TfrmdlgProb.GetEditedComments;
var
  i: integer;
begin
  for i := 0 to pred(ProbRec.CommentCount) do
    if i < lstComments.Items.Count then with lstComments do
      begin
        if Items[i] = 'DELETED' then
          TComment(ProbRec.fComments[i]).Narrative := '' {this deletes the comment}
        else
          begin
            TComment(ProbRec.fComments[i]).DateAdd := Piece(lstComments.Items[i], U, 1) ;
            TComment(ProbRec.fComments[i]).Narrative := Piece(lstComments.Items[i], U, 2) ;
          end;
      end;
end;

procedure TfrmdlgProb.GetNewComments(Reason: char);
var
  i, start: integer;
begin
  {don't display previous comments for add comment or remove problem functions}
  if (Reason <> 'R') then
    start := ProbRec.CommentCount
  else
    start := 0;
  for i := start to Pred(lstComments.Items.Count) do
   begin
    with lstComments do
     begin
      if (lstComments.Items[i] <> 'DELETED') and (Piece(lstComments.Items[i], u, 2) <> '') then
       ProbRec.AddNewComment(Piece(lstComments.Items[i],u,2));
     end;
   end;
  end;

procedure TfrmdlgProb.bbRemoveClick(Sender: TObject);
begin
 if (lstComments.Items.Count = 0) or (lstComments.ItemIndex < 0) then exit ;
 lstComments.Items[lstComments.ItemIndex] := 'DELETED' ;
 fChanged := true;
end;

procedure TfrmdlgProb.cbProvKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    SendMessage(cbProv.Handle, CB_SHOWDROPDOWN, 1, 0) {Opens list}
  else
    SendMessage(cbProv.Handle, CB_SHOWDROPDOWN, 0, 0) {Closes list}
end;

procedure TfrmdlgProb.rgStatusClick(Sender: TObject);
begin
 if rgStatus.Itemindex = 1 then
   begin
     edResDate.text  := DateToStr(Date) ;
     rgStage.Visible := False ;
   end
 else
   begin
     edResDate.text  := '';
     rgStage.Visible := True ;
   end ;
 FChanged := True;
end;

procedure TfrmdlgProb.cbProvClick(Sender: TObject);
begin
  SendMessage(cbProv.Handle, CB_SHOWDROPDOWN, 0, 0); {Closes list}
end;

procedure TfrmdlgProb.cbLocClick(Sender: TObject);
begin
  SendMessage(cbLoc.Handle, CB_SHOWDROPDOWN, 0, 0); {Closes list}
end;

procedure TfrmdlgProb.cbLocKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    SendMessage(cbLoc.Handle, CB_SHOWDROPDOWN, 1, 0) {Opens list}
  else
    SendMessage(cbLoc.Handle, CB_SHOWDROPDOWN, 0, 0) {Closes list}
end;


procedure TfrmdlgProb.SetDefaultProb(Alist: TStringList; prob: string);
var
  Today: string;

  function Permanent: char;
  begin
  // ===================  changed code - REV 7/30/98  =========================
  // PlUser.usVerifyTranscribed is a SITE requirement, not a USER ability
    if PlUser.usVerifyTranscribed and not PlUser.usPrimeUser then
      result:='T'
    else
      result:='P';
  //===========================================================================
  { if PLUser.usPrimeUser or (PlUser.usVerifyTranscribed) then
    result:='P'
   else
    result:='T';}
  end;

begin  {BODY }
  Today := PLPt.Today;
  if Piece(prob, u, 4) <> '' then
    alist.add('NEW' + v + '.01' + v +Piece(prob, u, 4) + u + Piece(prob, u, 3))
  else
    alist.add('NEW' + v + '.01' + v + u); {no icd code}
  {Leave ien of .05 undefined - let host save routine compute it}
  alist.add('NEW' + v + '.05' + v + u + Piece(prob,u,2));{actual text}
  alist.add('NEW' + v + '.06' + v + PLPt.PtVAMC);
  alist.add('NEW' + v + '.08' + v + Today);
  alist.add('NEW' + v + '.12' + v + 'A' + u + 'ACTIVE');
  alist.add('NEW' + v + '.13' + v + '');
  alist.add('NEW' + v + '1.01' + v + Piece(prob,u,1) + u + Piece(prob,u,2));{standardized text}
  alist.add('NEW' + v + '1.02' +  v + Permanent); {Permanent or Transcribed status}
  alist.add('NEW' + v + '1.03' + v + inttostr(Encounter.Provider) + u + Encounter.Providername); {ent by}
  alist.add('NEW' + v + '1.04' + v + inttostr(Encounter.Provider) + u + Encounter.Providername); {recording prov}
  alist.add('NEW' + v + '1.05' + v + inttostr(Encounter.Provider) + u + Encounter.Providername); {resp prov}
  alist.add('NEW' + v + '1.06' + v + PLUser.usService); {user's service/section}
  alist.add('NEW' + v + '1.07' + v + '');
  alist.add('NEW' + v + '1.08' + v + '') ;{IntToStr(Encounter.Location));}
  alist.add('NEW' + v + '1.09' + v + Today);
  alist.add('NEW' + v + '1.1' +  v + '0' + u + 'NO'); {SC}
  alist.add('NEW' + v + '1.11' + v + '0' + u + 'NO'); {AO}
  alist.add('NEW' + v + '1.12' + v + '0' + u + 'NO'); {RAD}
  alist.add('NEW' + v + '1.13' + v + '0' + u + 'NO'); {ENV}
  alist.add('NEW' + v + '1.14' + v + ''); {Priority: 'A', 'C', or ''}
  alist.add('NEW' + v + '1.15' + v + '0' + u + 'NO'); {HNC}
  alist.add('NEW' + v + '1.16' + v + '0' + u + 'NO'); {MST}
  alist.add('NEW' + v + '1.17' + v + '0' + u + 'NO'); {CV}
  alist.add('NEW' + v + '1.18' + v + '0' + u + 'NO'); {SHAD}
end;


function TfrmdlgProb.BadDates:Boolean;
var
  ds:string;
  i:integer;

  procedure Msg(msg: string);
  begin
// CQ #16123 - Modified error text to clarify proper date formats - JCS
    InfoBox('Dates must be in format m/d/yy, m/d/yyyy, m/d, m/yyyy, yyyy, T+d or T-d' +
      #13#10 + msg + ' is formatted improperly.' +
      #13#10 + '     Please check the other dates as well.',
      'Information', MB_OK or MB_ICONINFORMATION);
  end;
begin
  result:=True;  {initialize for error condition}
  if edRecDate.text <>'' then
    begin
      ds:=DateStringOk(edRecDate.text);
      if ds = 'ERROR' then
        begin
          msg('Recorded');
          exit;
        end;
    end ;
  if edResDate.text <>'' then
    begin
      ds:=DateStringOk(edResDate.text);
      if ds = 'ERROR' then
        begin
          msg('Resolved');
          exit;
        end;
    end ;
  if edOnsetDate.text <>'' then
    begin
      ds:=DateStringOk(edOnsetDate.text);
      if ds = 'ERROR' then
        begin
          msg('Onset');
          exit;
        end;
      if StrToFMDateTime(edOnsetDate.Text) > FMNow then
        begin
          InfoBox('Onset dates in the future are not allowed.', 'Information', MB_OK or MB_ICONINFORMATION);
          Exit;
        end;
    end ;
  for i:=0 to pred(lstComments.Items.Count) do
    begin
      if Piece(lstComments.Items[i],u,2)<>'' then {may have blank lines at bottom}
        begin
          ds:=DateStringOk(Piece(lstComments.Items[i],u,1));
          if ds='ERROR' then
            begin
              msg('Comment #' + inttostr(i));
              exit;
            end;
        end;
    end;
  result:=False;  {made it through, so no bad dates}
end;

procedure TfrmdlgProb.ControlChange(Sender: TObject);
begin
  fChanged:=true;
end;

destructor TfrmdlgProb.Destroy;
begin
  ProbRec.free;
  ProbRec := nil;
  FCtrlMap.Free;
  if fprobs.dlgProbs <> nil then fprobs.dlgProbs := nil;
  if (not Application.Terminated) and (not uInit.TimedOut) then   {prevents GPF if system close box is clicked
                                                                   while frmDlgProbs is visible}
     if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_CLOSEPROBLEM, 0, 0);
  inherited Destroy ;
end;

procedure TfrmdlgProb.cbProvDropDown(Sender: TObject);
var
  alist:TstringList;
  i:integer;
  v:string;
begin
  v := uppercase(cbProv.text);
  if (v <> '') then
    begin
      alist := TstringList.create;
      try
        FastAssign(ProviderList('', 25, V, V), AList) ;
        if alist.count > 0 then
          begin
            if cbProv.items.count + 25 > 100 then
              for i := 0 to 75 do {don't allow more than 100 to build up}
                cbProv.Items.delete(i);
              for i := 0 to pred(alist.count) do
                cbProv.Items.add(Alist[i]); {add new ones to list}
          end;
      finally
        alist.free;
      end;
   end;
end;

procedure TfrmdlgProb.cbLocDropDown(Sender: TObject);
var
  alist: TstringList;
  v: string;
begin
  v := uppercase(cbLoc.text);
  alist := TstringList.create;
  try
    FastAssign(ClinicSearch(' '), AList) ;
    if alist.count > 0 then FastAssign(Alist, cbLoc.Items);
  finally
    alist.free;
  end;
end;

procedure TfrmdlgProb.FormCreate(Sender: TObject);
begin
  FSilent := False;
  if rgStatus.ItemIndex = -1
  then
    InitialFocus := rgStatus
  else
    InitialFocus := rgStatus.Controls[rgStatus.ItemIndex] as TWinControl;
end;

{ old TPLDlgForm Methods }

constructor TfrmdlgProb.Create(AOwner: TComponent);
{ It is unusual to not call the inherited Create first, but necessary in this case; some
  of the TMStruct objects need to be created before the form gets its OnCreate event.        }
begin
  FCtrlMap := TStringList.Create;       { FCtrlMap[n]='CtrlName=PtrID'                        }
  inherited Create(AOwner);
  FInitialShow := True;
  FModified := False;
  FEditing := False;
end;

procedure TfrmdlgProb.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  { to make the form a child window }
  with Params do
    begin
      if Owner is TPanel then
        WndParent := (Owner as TPanel).Handle
      else {pdr}
        WndParent := Application.MainForm.Handle;
      Style := ws_Child or ws_ClipSiblings;
      X := 0;
      Y := 0;
   end;
end;

procedure TfrmdlgProb.Loaded;
begin
  inherited Loaded;
  { allow the form to be treated as a child form }
  Visible := False;
  Position := poDefault;
  BorderIcons := [];
  BorderStyle := bsNone;
  HandleNeeded;
end;

procedure TfrmdlgProb.DoShow;
begin
  FInitialShow := False;
  inherited DoShow;
end;

procedure TfrmdlgProb.SetFontSize( NewFontSize: integer);
begin
  ResizeAnchoredFormToFont( self );
end;

procedure TfrmdlgProb.ShowClinicLocationCombo;
begin
  cbLoc.visible := true;
  cbServ.Visible := false;
  lblLoc.caption := 'Clinic:';
end;

procedure TfrmdlgProb.ShowServiceCombo;
begin
  cbLoc.visible := false;
  cbServ.Visible := true;
  lblLoc.caption := 'Service:';
end;

{ base form procedures (shared by all ordering dialogs) }


procedure TfrmdlgProb.ClearDialogControls;             { Reset all the controls in the dialog }
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i] is TLabel then Continue;
    if Controls[i] is TButton then Continue;
  end;
  LoadDefaults;                                       { added for lab to reset cleared lists }
end;

procedure TfrmdlgProb.LoadDefaults;
begin
  { by default nothing - should override in specific dialog }
end;



function TfrmdlgProb.LackRequired: Boolean;
begin
  Result := False;  { should override to check for additional required fields }
end;


procedure TfrmdlgProb.UMTakeFocus(var Message: TMessage);
begin
  if FInitialFocus = nil then exit; {PDR}
  if (FInitialFocus.visible) and (FInitialFocus.enabled) then FInitialFocus.SetFocus;
end;

procedure TfrmdlgProb.bbChangeProbClick(Sender: TObject);
const
  TX799 = '799.9';
var
   newprob: string ;
   frmPLLex: TfrmPLLex;
begin
  if PLUser.usUseLexicon then
    begin
      frmPLLex:=TfrmPLLex.create(Application);
      try
        frmPLLex.showmodal;
      finally
        frmPLLex.Free;
      end;
    end
  else
    begin
      PLProblem := InputBox('Change problem','Enter new problem name: ','') ;
      if PLProblem<>'' then
        PLProblem := u + PLProblem + u + TX799 + u
      else
        exit ;
    end ;

  {problems are in the form of: ien^.01^icd^icdifn , although only the .01 is required}
  if PLProblem='' then exit ;
  newprob := PLProblem ;

  if frmProblems.HighlightDuplicate(NewProb, Piece(newprob, U, 2) + #13#10#13#10 +
      'This problem would be a duplicate.'+#13#10 +
      'Return to the list and see the highlighted problem.',
      mtInformation, 'CHANGE') then
    exit {bail out - don't want dups}
  else
    begin
      {ien^.01^icd^icdifn - see SetDefaultProblem}
      {Set new problem properties}
      ProbRec.Problem.DHCPtoKeyVal(Piece(NewProb,u,1) + u + Piece(NewProb,u,2)) ;    {1.01}
      ProbRec.Diagnosis.DHCPtoKeyVal(Piece(NewProb,u,4) + u + Piece(NewProb,u,3)) ;   {.01}
      ProbRec.Narrative.DHCPtoKeyVal(u + Piece(NewProb,u,2));                         {.05}

      {mark it as changed}
      fchanged := true ;

      {Redraw heading}
      if Piece(NewProb,u,3)<>'' then
        edProb.Text:=Piece(NewProb,u,2) + ' (' + Piece(NewProb,u,3) + ')'
      else
        edProb.Text:=Piece(NewProb,u,2) + ' (799.9)'; {code not found, or free-text entry}
    end ;
end ;

procedure TfrmdlgProb.cbLocNeedData(Sender: TObject; const StartFrom: String;
  Direction, InsertAt: Integer);
begin
  cbLoc.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;

procedure TfrmdlgProb.cbProvNeedData(Sender: TObject; const StartFrom: String;
  Direction, InsertAt: Integer);
begin
  cbProv.ForDataUse(SubSetOfProviders(StartFrom, Direction));
end;

procedure TfrmdlgProb.cbServNeedData(Sender: TObject; const StartFrom: String;
  Direction, InsertAt: Integer);
begin
  cbServ.ForDataUse(ServiceSearch(StartFrom, Direction));
end;

initialization
  SpecifyFormIsNotADialog(TfrmdlgProb);

end.
