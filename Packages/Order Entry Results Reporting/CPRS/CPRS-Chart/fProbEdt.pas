unit fProbEdt;

interface

uses
  SysUtils, windows, Messages, Classes, Graphics, Vcl.Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Grids,
  ORCtrls, Vawrgrid, uCore, Menus, uConst, fBase508Form,
  VA508AccessibilityManager, Vcl.ComCtrls;

const
  SOC_QUIT = 1;        { close single dialog }

type
  tVA508Captions = record
   CheckBox: TCheckBox;
   OrigCaption: String;
   OrigWidth: Integer;
   VA508Label: TStaticText;
  end;

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
    pnlTop: TPanel;
    lblAct: TLabel;
    rgStatus: TKeyClickRadioGroup;
    rgStage: TKeyClickRadioGroup;
    bbChangeProb: TBitBtn;
    edProb: TCaptionEdit;
    gbTreatment: TGroupBox;
    ckYSC: TCheckBox;
    ckYRad: TCheckBox;
    ckYAO: TCheckBox;
    ckYENV: TCheckBox;
    ckYHNC: TCheckBox;
    ckYMST: TCheckBox;
    ckYSHAD: TCheckBox;
    ckNSC: TCheckBox;
    ckNRad: TCheckBox;
    ckNAO: TCheckBox;
    ckNENV: TCheckBox;
    ckNHNC: TCheckBox;
    ckNMST: TCheckBox;
    ckNSHAD: TCheckBox;
    ckVerify: TCheckBox;
    edRecDate: TCaptionEdit;
    cbServ: TORComboBox;
    cbLoc: TORComboBox;
    lblLoc: TLabel;
    cbProv: TORComboBox;
    Label3: TLabel;
    edOnsetdate: TCaptionEdit;
    Label6: TLabel;
    lstComments: TCaptionListView;
    Panel1: TPanel;
    bbAdd: TBitBtn;
    bbEdit: TBitBtn;
    bbRemove: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    Panel4: TPanel;
    ckNCL: TCheckBox;
    ckYCL: TCheckBox;
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
    procedure ckTreatments(value: String; ckBox: Integer);
    function  TreatmentsCked(ckBox: Integer):String;
    procedure ckNSCClick(Sender: TObject);
    procedure rgStatusEnter(Sender: TObject);
    procedure lstCommentsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
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
    FSearchString: String;
    VA508Captions: Array of tVA508Captions;
    procedure UMTakeFocus(var Message: TMessage); message UM_TAKEFOCUS;
    procedure ShowComments;
    procedure GetEditedComments;
    procedure GetNewComments(Reason:char);
    function  OkToQuit:boolean;
    procedure ShowServiceCombo;
    procedure ShowClinicLocationCombo;
    procedure HandleVA508Caption();

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

uses ORFn, uProbs, fProbs, rProbs, fCover, rCover, rCore, rOrders, fProbCmt, fProbLex, rPCE, uInit  ,
     VA508AccessibilityRouter, VAUtils, rMisc, uGlobalVar;

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
      lstComments.Add(Pieces(cmt, U, 2, 3)) ;
      fChanged := true;
    end ;
end;

procedure TfrmdlgProb.bbEditClick(Sender: TObject);
var
  cmt: string    ;
begin
  if not Assigned(lstComments.Selected) then Exit;
  cmt := EditComment(lstComments.Strings[lstComments.Selected.Index]) ;
  if StrToInt(Piece(cmt, U, 1)) > 0 then
    begin
      lstComments.Strings[lstComments.Selected.Index] := Pieces(cmt, U, 2, 4) ;
      fChanged := true;
    end ;
end;

procedure TfrmdlgProb.ckNSCClick(Sender: TObject);
var
  ChkBoxName :string;
begin
  inherited;
  fChanged:=true;
  ChkBoxName := AnsiUpperCase(TCheckBox(Sender).Name);
  if (ChkBoxName = 'CKYSC') and TCheckBox(Sender).Checked then ckNSC.Checked := not ckYSC.Checked;
  if (ChkBoxName = 'CKNSC') and TCheckBox(Sender).Checked then ckYSC.Checked := not ckNSC.Checked;
  if (ChkBoxName = 'CKYAO') then ckNAO.Checked := not ckYAO.Checked;
  if (ChkBoxName = 'CKNAO') then ckYAO.Checked := not ckNAO.Checked;
  if (ChkBoxName = 'CKYRAD') then ckNRAD.Checked := not ckYRAD.Checked;
  if (ChkBoxName = 'CKNRAD') then ckYRAD.Checked := not ckNRAD.Checked;
  if (ChkBoxName = 'CKYENV') then ckNENV.Checked := not ckYENV.Checked;
  if (ChkBoxName = 'CKNENV') then ckYENV.Checked := not ckNENV.Checked;
  if (ChkBoxName = 'CKYSHAD') then ckNSHAD.Checked := not ckYSHAD.Checked;
  if (ChkBoxName = 'CKNSHAD') then ckYSHAD.Checked := not ckNSHAD.Checked;
  if (ChkBoxName = 'CKYMST') then ckNMST.Checked := not ckYMST.Checked;
  if (ChkBoxName = 'CKNMST') then ckYMST.Checked := not ckNMST.Checked;
  if (ChkBoxName = 'CKYHNC') then ckNHNC.Checked := not ckYHNC.Checked;
  if (ChkBoxName = 'CKNHNC') then ckYHNC.Checked := not ckNHNC.Checked;
  if (ChkBoxName = 'CKYCL') then ckNCL.Checked := not ckYCL.Checked;
  if (ChkBoxName = 'CKNCL') then ckYCL.Checked := not ckNCL.Checked;
end;

procedure TfrmdlgProb.ckTreatments(value: String; ckBox: Integer);
{ Used to set the checkboxes in order to properly set yes and no boxes
   Send How ckbox should be set and which box
   Value -> 1 Set to Yes, 2 Set to No, 0 Set Unknown
   ckBox:
     0 -> Service Connected
     1 -> Agent Orange
     2 -> Radiation
     3 -> Southwest Asia Conditions
     4 -> Shipboard Hazard and Defense
     5 -> MST
     6 -> Head and/or Neck Cancer
     7 -> Camp Lejeune

}
Var
 yptr,nptr :^TCheckBox;
begin
  case ckBox of
    0 : begin
          //Sevice Connected
          yptr := @ckYSC;
          nptr := @ckNSC;
        end;
    1 : begin
          //Agent Orange
          yptr := @ckYAO;
          nptr := @ckNAO;
        end;
    2 : begin
          //Radiation
          yptr := @ckYRAD;
          nptr := @ckNRAD;
        end;
    3 : begin
          //Southwest Asia Conditions
          yptr := @ckYENV;
          nptr := @ckNENV;
        end;
    4 : begin
          //Shipboard Hazard and Defense
          yptr := @ckYSHAD;
          nptr := @ckNSHAD;
        end;
    5 : begin
          //MST
          yptr := @ckYMST;
          nptr := @ckNMST;
        end;
    6 : begin
          //Head and/or Neck Cancer
          yptr := @ckYHNC;
          nptr := @ckNHNC;
        end;
    7 : begin
          //Camp Lejeune
          yptr := @ckYCL;
          nptr := @ckNCL;
        end;

    else begin
           Exit;
         end;
  end;

  if Value = '1' then  // Yes is selected
  begin
     TCheckBox(yptr^).Checked := True;
     TCheckBox(nptr^).Checked := False;
  end
  else if value = '0' then  // No is selected
  begin
     TCheckBox(yptr^).Checked := False;
     TCheckBox(nptr^).Checked := True;
  end
  else  //Unknown
  begin
     TCheckBox(yptr^).Checked := False;
     TCheckBox(nptr^).Checked := False;
  end;

end;

function TfrmdlgProb.TreatmentsCked(ckBox: Integer):String;
{ Return 1 for checked 0 for not checked, and '' for unknown
  ckBox:
     0 -> Service Connected
     1 -> Agent Orange
     2 -> Radiation
     3 -> Southwest Asia Conditions
     4 -> Shipboard Hazard and Defense
     5 -> MST
     6 -> Head and/or Neck Cancer
     7 -> Camp Lejeune

}
Var
 yptr,nptr :^TCheckBox;
begin
  case ckBox of
    0 : begin
          //Sevice Connected
          yptr := @ckYSC;
          nptr := @ckNSC;
        end;
    1 : begin
          //Agent Orange
          yptr := @ckYAO;
          nptr := @ckNAO;
        end;
    2 : begin
          //Radiation
          yptr := @ckYRAD;
          nptr := @ckNRAD;
        end;
    3 : begin
          //Southwest Asia Conditions
          yptr := @ckYENV;
          nptr := @ckNENV;
        end;
    4 : begin
          //Shipboard Hazard and Defense
          yptr := @ckYSHAD;
          nptr := @ckNSHAD;
        end;
    5 : begin
          //MST
          yptr := @ckYMST;
          nptr := @ckNMST;
        end;
    6 : begin
          //Head and/or Neck Cancer
          yptr := @ckYHNC;
          nptr := @ckNHNC;
        end;
    7 : begin
          //Camp Lejeune - Veterans
          yptr := @ckYCL;
          nptr := @ckNCL;
        end;

    else begin
           Result := '';
           Exit;
         end;

  end;
    if TCheckBox(yptr^).Checked then Result := '1'
    else if TCheckBox(nptr^).Checked then Result := '0'
    else Result := '';
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
        ckYSC.enabled         := false;
        ckYRAD.enabled        := false;
        ckYAO.enabled         := false;
        ckYENV.enabled        := false;
        ckYHNC.enabled        := false;
        ckYMST.enabled        := false;
        ckYSHAD.enabled       := false;
        ckNSC.enabled         := false;
        ckNRAD.enabled        := false;
        ckNAO.enabled         := false;
        ckNENV.enabled        := false;
        ckNHNC.enabled        := false;
        ckNMST.enabled        := false;
        ckNSHAD.enabled       := false;
        ckNCL.enabled         := false;
        ckYCL.enabled         := false;

        if Reason = 'R' then bbFile.caption := 'Remove';
      end;
    edProb.Caption := lblact.Caption;
    edProb.Text := Piece(subjProb, u, 2);

    if Piece(subjProb, '|', 2) <> '' then
      FSearchString := Piece(subjProb, '|', 2);

    {line up problem action and title}
    {edProb.Left:=lblAct.left+lblAct.width+2;}
    {get problem}
    if Reason <> 'A' then
      begin {edit,remove or display existing problem}
        problemIFN := Piece(subjProb, u, 1);
        FastAssign(EditLoad(ProblemIFN), AList) ;   //V17.5   RV
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
          if PtServiceConnected then
          begin
            ckYSC.Enabled := True;
            ckNSC.Enabled := True;
            ckTreatments(ProbRec.SCProblem,0);
          end
          else
          begin
            ckYSC.Enabled := False;
            ckNSC.Enabled := False;
          end;

          if PtAgentOrange then
          begin
            ckYAO.Enabled := True;
            ckNAO.Enabled := True;
            ckTreatments(ProbRec.AOProblem,1);
          end
          else
          begin
            ckYAO.Enabled := False;
            ckNAO.Enabled := False;
          end;

          if PtRadiation then
          begin
            ckYRad.Enabled := True;
            ckNRad.Enabled := True;
            ckTreatments(Probrec.RADProblem,2);
          end
          else
          begin
            ckYRad.Enabled := False;
            ckNRad.Enabled := False;
          end;

          if PtEnvironmental then
          begin
            ckYENV.Enabled := True;
            ckNENV.Enabled := True;
            ckTreatments(ProbRec.ENVProblem,3);
          end
          else
          begin
            ckYENV.Enabled := False;
            ckNENV.Enabled := False;
          end;

          if PtSHAD then
          begin
            ckYSHAD.Enabled := True;
            ckNSHAD.Enabled := True;
            ckTreatments(ProbRec.SHADProblem,4);
          end
          else
          begin
            ckYSHAD.Enabled := False;
            ckNSHAD.Enabled := False;
          end;

          if PtMST then
          begin
            ckYMST.Enabled := True;
            ckNMST.Enabled := True;
            ckTreatments(ProbRec.MSTProblem,5);
          end
          else
          begin
            ckYMST.Enabled := False;
            ckNMST.Enabled := False;
          end;

          if PtHNC then
          begin
            ckYHNC.Enabled := True;
            ckNHNC.Enabled := True;
            ckTreatments(ProbRec.HNCProblem,6);
          end
          else
          begin
            ckYHNC.Enabled := False;
            ckNHNC.Enabled := False;
          end;
          if PtCL then
          begin
            ckYCL.Enabled := True;
            ckNCL.Enabled := True;
            ckTreatments(ProbRec.CLProblem,7);
          end
          else
          begin
            ckYCL.Enabled := False;
            ckNCL.Enabled := False;
          end;

        end ;

    {cbProv.InitLongList(ProbRec.RespProvider.extern) ;
    if (ProbRec.RespProvider.intern <> '') and (StrToInt64Def(ProbRec.RespProvider.intern, 0) > 0) then
      cbProv.SelectByIEN(StrToInt64(ProbRec.RespProvider.intern));}

    if (Encounter.Provider > 0) and PersonHasKey(Encounter.Provider, 'PROVIDER') then
      begin
        cbProv.InitLongList(Encounter.ProviderName);
        cbProv.SelectByIEN(Encounter.Provider);
      end
    else cbProv.InitLongList('');


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
        {if (ProbRec.Service.DHCPField = '^') and  (ProbRec.Clinic.DHCPField <> '^') then
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
        else}
        if Encounter.Inpatient then
          begin
            ShowServiceCombo();
            cbServ.InitLongList('');
          end
        else if (Encounter.Location > 0) and IsClinicLoc(Encounter.Location) then
          begin
            ShowClinicLocationCombo();
            cbLoc.InitLongList(Encounter.LocationName);
            cbLoc.SelectByIEN(Encounter.Location);
          end
        else
          begin
            ShowClinicLocationCombo();
            cbLoc.InitLongList('');
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
   //     bbEdit.Enabled := TRUE;
   //     bbRemove.Enabled := TRUE;
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
    if rgStatus.ItemIndex = -1 then
      InitialFocus := rgStatus
    else
      InitialFocus := rgStatus.Buttons[rgStatus.ItemIndex] as TWinControl;

    if ScreenReaderActive then
     HandleVA508Caption();
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
      lstComments.Add(TComment(fComments[i]).ExtDateAdd + '^' + TComment(fComments[i]).Narrative + '^' + TComment(fComments[i]).AuthorID);
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
        if fChanged then LoadPatientProblems(AList, PLUser.usViewAct[1], False);
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
  TX_INACTIVE_SCODE   = 'This problem references an inactive SNOMED CT code.' + #13#10 +
                        'The code must be updated using the ''Change''' + #13#10 +
                        'button before it can be saved';
  TC_INACTIVE_SCODE   = 'Inactive SNOMED CT Code';
var
  AList: TstringList;
  remcom, vu, ut, PtID: string;
  NTRTCallResult: String;
  DateOfInterest: TFMDateTime;
  SvcCat: Char;
begin
  SvcCat := Encounter.VisitCategory;
  if (SvcCat = 'E') or (SvcCat = 'H') then
    DateOfInterest := FMNow
  else
    DateOfInterest := Encounter.DateTime;
  frmProblems.wgProbData.TabStop := True;  //CQ #15531 part (c) [CPRS v28.1] {TC}.
  if (Reason <> 'R') and (Reason <> 'r') then
    if (rgStatus.itemindex=-1) or (cbProv.itemindex=-1) then
    begin
      InfoBox('Status and Responsible Provider are required.', 'Information', MB_OK or MB_ICONINFORMATION);
      exit;
    end;
  if CharInSet(Reason, ['C','c','E','e']) then
  begin
    if not IsActiveICDCode(ProbRec.Diagnosis.extern, DateOfInterest) then
    begin
      InfoBox(TX_INACTIVE_ICODE, TC_INACTIVE_ICODE, MB_ICONWARNING or MB_OK);
      exit;
    end
    else if (ProbRec.SCTConcept.extern <> '') and not IsActiveSCTCode(ProbRec.SCTConcept.extern, DateOfInterest) then
    begin
      InfoBox(TX_INACTIVE_SCODE, TC_INACTIVE_SCODE, MB_ICONWARNING or MB_OK);
      exit;
    end;
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
    case rgStage.ItemIndex of
         0: ProbRec.Priority := 'A';
         1: ProbRec.Priority := 'C'
         else
           ProbRec.Priority := '@';
    end;
    ProbRec.DateOnsetStr := edOnsetDate.text;
    ProbRec.DateResStr   := edResDate.text;{aka inactivation date}
    ProbRec.DateRecStr   := edRecDate.text;{recorded anywhere}
    if fChanged or (edUpdate.text = '') then
      ProbRec.DateModStr := InttoStr(trunc(FMNow))
    else
      ProbRec.DateModStr := edUpdate.text; {last update}
    (*if ckSC.enabled then *)Probrec.SCProblem  := TreatmentsCked(0);
    if ckYAO.enabled then ProbRec.AOProblem     := TreatmentsCked(1);
    if ckYRAD.enabled then Probrec.RadProblem   := TreatmentsCked(2);
    if ckYENV.enabled then ProbRec.ENVProblem   := TreatmentsCked(3);
    if ckYSHAD.Enabled then ProbRec.SHADProblem := TreatmentsCked(4);
    if ckYMST.enabled then ProbRec.MSTProblem   := TreatmentsCked(5);
    if ckYHNC.enabled then ProbRec.HNCProblem   := TreatmentsCked(6);
    if ckYCL.enabled then ProbRec.CLProblem     := TreatmentsCked(7);

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

    if RequestNTRT then
    begin
      ProbRec.NTRTRequested.intern := '1';
      ProbRec.NTRTRequested.extern := 'True';
      if NTRTComment <> '' then
      begin
        ProbRec.NTRTComment.intern := NTRTComment;
        ProbRec.NTRTComment.extern := NTRTComment;
      end;
    end;

    if ProbRec.Commentcount > 0 then GetEditedComments;
    GetNewComments(Reason);
    case Reason of
      'E','e','C','c': {edits or comments}
        begin
          ut := '';
          if PLUser.usPrimeUser then ut := '1';
          FastAssign(EditSave(ProblemIFN, User.DUZ, PLPt.ptVAMC, ut, ProbRec.FilerObject, FSearchString), AList) ;    //V17.5  RV
        end;
      'A','a':  {new problem}
         FastAssign(AddSave(PLPt.GetGMPDFN(Patient.DFN, Patient.Name),
           pProviderID, PLPt.ptVAMC, ProbRec.FilerObject, FSearchString), AList) ;  //*DFN*
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
        Changes.RefreshCoverPL := True;
        if RequestNTRT then
        begin
          PtID := Patient.Name + ' (' + Copy(Patient.Name, 0, 1) + Copy(Patient.SSN, (Length(Patient.SSN) - 3), 4) + ')';
          NTRTCallResult := ProblemNTRTBulletin(FSearchString, Piece(ProbRec.RespProvider.DHCPField, U, 1), PtID, NTRTComment);
          if piece(NTRTCallResult, '^', 1) <> '1' then
            InfoBox('Your NTRT Request bulletin for ' + FSearchString + ' could not be generated: '#13#10#13#10 +
              piece(NTRTCallResult, '^', 2) + #13#10#13#10'Please contact IRM.', 'Bulletin Failed!', MB_ICONERROR or MB_OK);
          RequestNTRT := False;
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
        if Strings[i] = 'DELETED' then
          TComment(ProbRec.fComments[i]).Narrative := '' {this deletes the comment}
        else
          begin
            TComment(ProbRec.fComments[i]).DateAdd := Piece(lstComments.Strings[i], U, 1) ;
            TComment(ProbRec.fComments[i]).Narrative := Piece(lstComments.Strings[i], U, 2) ;
            TComment(ProbRec.fComments[i]).AuthorID := Piece(lstComments.Strings[i], U, 3) ;
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
      if (lstComments.Strings[i] <> 'DELETED') and (Piece(lstComments.Strings[i], u, 2) <> '') then
       ProbRec.AddNewComment(Piece(lstComments.Strings[i],u,2));
     end;
   end;
  end;

procedure TfrmdlgProb.bbRemoveClick(Sender: TObject);
begin
 if (lstComments.Items.Count = 0) or (lstComments.SelCount < 0) then exit ;
 lstComments.Strings[lstComments.Selected.Index] := 'DELETED' ;
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

procedure TfrmdlgProb.rgStatusEnter(Sender: TObject);
begin
  inherited;
  bbFile.Default := True;
  bbFile.Invalidate;
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
  Today, ICDCode: string;
  EncounterDate : TFMDateTime;

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
  EncounterDate := Trunc(Encounter.DateTime);
  if Pos('ICD-9-CM',Piece(prob, u, 3)) > 0 then
    ICDCode := Piece(Piece(Piece(prob, u, 3),' ',2),')',1)
  else
    ICDCode := Piece(prob, u, 3);
  if Piece(prob, u, 4) <> '' then
    alist.add('NEW' + v + '.01' + v +Piece(prob, u, 4) + u + ICDCode)
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
  if IsLejeuneActive then alist.add('NEW' + v + '1.19' + v + '0' + u + 'NO'); {CL}

  if Piece(prob, u, 6) <> '' then
    alist.Add('NEW' + v + '80001' + v + Piece(prob, u, 6) + u + Piece(prob, u, 6)); {SCT Concept}
  if Piece(prob, u, 7) <> '' then
    alist.Add('NEW' + v + '80002' + v + Piece(Piece(prob, u, 7), '|', 1) + u + Piece(Piece(prob, u, 7), '|', 1)); {SCT Designation}
  alist.add('NEW' + v + '80201' + v + Piece(FloatToStr(EncounterDate),'.',1) + u + FormatFMDateTime('yyyy/mm/dd',EncounterDate));   {Code Date/Date of Interest}
  alist.add('NEW' + v + '80202' + v + Encounter.GetICDVersion);   {Code System}
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
      if Piece(lstComments.Strings[i],u,2)<>'' then {may have blank lines at bottom}
        begin
          ds:=DateStringOk(Piece(lstComments.Strings[i],u,1));
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
  SetLength(VA508Captions, 0);

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
  ckNCL.Visible := IsLejeuneActive;
  ckYCL.Visible := IsLejeuneActive;

end;

{ old TPLDlgForm Methods }

constructor TfrmdlgProb.Create(AOwner: TComponent);
{ It is unusual to not call the inherited Create first, but necessary in this case; some
  of the TMStruct objects need to be created before the form gets its OnCreate event.        }
begin
  inherited Create(AOwner);
  FCtrlMap := TStringList.Create;       { FCtrlMap[n]='CtrlName=PtrID'                        }
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

procedure TfrmdlgProb.lstCommentsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  bbEdit.Enabled := lstComments.ItemIndex <> -1 ;
  bbRemove.Enabled := lstComments.ItemIndex <> -1 ;
  ControlChange(Sender);
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
  if (FInitialFocus.visible) and (FInitialFocus.enabled) then
  begin
    FInitialFocus.SetFocus();
    Invalidate;
  end;
end;

procedure TfrmdlgProb.bbChangeProbClick(Sender: TObject);
const
  TX799 = '799.9';
var
   newprob, CSysAbbr: string ;
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
  newprob := PLProblem;

  if Piece(NewProb, '|', 2) <> '' then
  begin
    FSearchString := Piece(NewProb, '|', 2);
    NewProb := Piece(NewProb, '|', 1);
  end;

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
      ProbRec.SCTConcept.DHCPtoKeyVal(Piece(NewProb, u, 6) + u + Piece(NewProb, u, 6));      {80001}
      ProbRec.SCTDesignation.DHCPtoKeyVal(Piece(NewProb, u, 7) + u + Piece(NewProb, u, 7));  {80002}
      ProbRec.CodeDateStr := InttoStr(trunc(FMNow));  {80201}
      if Piece(NewProb, u, 8)='ICD-9-CM' then CSysAbbr := 'ICD' else CSysAbbr := '10D';
      ProbRec.CodeSystem.DHCPtoKeyVal(CSysAbbr + u + Piece(NewProb, u, 8));  {80202}

      {mark it as changed}
      fchanged := true ;

      {Redraw heading}
      edProb.Text:=Piece(NewProb,u,2);
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

//procedure TfraVisitRelated.HandleVA508Caption(ParentCheckBox: TCheckBox; chkEnabled: Boolean);
procedure TfrmdlgProb.HandleVA508Caption();
Var
 i,X: Integer;
 LabelExist: Boolean;
 ParentCheckBox: TCheckBox;
begin
 for x := 0 to ComponentCount -1 do
 begin
   if Components[x] is TCheckBox then
   begin
    ParentCheckBox := TCheckBox(Components[x]);

 LabelExist := False;
 for I := Low(VA508Captions) to High(VA508Captions) do
 begin
   if VA508Captions[i].CheckBox = ParentCheckBox then
   begin
    LabelExist := true;
    //Setup the caption
    if ParentCheckBox.Enabled then
    begin
     VA508Captions[i].CheckBox.Caption := VA508Captions[i].OrigCaption;
     VA508Captions[i].CheckBox.Width := VA508Captions[i].OrigWidth;
    end else begin
     VA508Captions[i].CheckBox.Caption := '';
     VA508Captions[i].CheckBox.Width := 20;
    end;
    //handle the label's visibility
    VA508Captions[i].VA508Label.Visible := not ParentCheckBox.Enabled;
    Break;
   end;
  if LabelExist then Break;
 end;


 if (not ParentCheckBox.Enabled) and (ParentCheckBox.Visible) and (not LabelExist) and (Trim(ParentCheckBox.Caption) <> '') then
 begin
  SetLength(VA508Captions, length(VA508Captions) + 1);
  with VA508Captions[High(VA508Captions)] do
  begin
   CheckBox := ParentCheckBox;
   OrigCaption := ParentCheckBox.Caption;
   OrigWidth := ParentCheckBox.Width;

  ParentCheckBox.Width := 20;
   ParentCheckBox.Caption := '';

   VA508Label := TStaticText.Create(ParentCheckBox.Owner);
   VA508Label.Parent := ParentCheckBox.Parent;
   VA508Label.Top := ParentCheckBox.Top;
   VA508Label.Left := ParentCheckBox.Left + 15;
   VA508Label.TabStop := true;
   VA508Label.Caption := Trim(OrigCaption) + ' disabled';
   VA508Label.TabOrder := ParentCheckBox.TabOrder;
   VA508Label.Visible := true;
  end;
 end;

  end;
 end;
end;



initialization
  SpecifyFormIsNotADialog(TfrmdlgProb);

end.
