unit fGMV_UserMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, CommCtrl,
  Menus,
  ActnList
  , uGMV_Const, StdActns, ImgList, ShellAPI
  , VERGENCECONTEXTORLib_TLB
  , OleCtrls
  , mGMV_GridGraph
  , mGMV_MDateTime, uROR_Contextor, AppEvnts
  , fGMV_PatientSelector, System.Actions
  ;

type
  TfrmGMV_UserMain = class(TForm)
    sb: TStatusBar;
    acMainList: TActionList;
    acInputVitals: TAction;
    acPatientInfo: TAction;
    acPtSelect: TAction;
    acEditVitals: TAction;
    acPtAllergies: TAction;
    acRunReport: TAction;
    mnMain: TMainMenu;
    mnFile: TMenuItem;
    PtSelect1: TMenuItem;
    EnterVitals1: TMenuItem;
    mnFilePrinterSetup: TMenuItem;
    mnFileEnteredInError: TMenuItem;
    mnFileEditUserTemplates: TMenuItem;
    mnFileUserOptions: TMenuItem;
    N1: TMenuItem;
    mnFileExit: TMenuItem;
    mnReports: TMenuItem;
    mnReportsVitalSigns: TMenuItem;
    mnReportsBPPlottingChart: TMenuItem;
    mnReportsWeightChart: TMenuItem;
    mnReportsPOxRespirationChart: TMenuItem;
    mnReportsPainChart: TMenuItem;
    N4: TMenuItem;
    mnReportsCumaulativeVitalsReport: TMenuItem;
    mnReportsLatestVitalsbyLocation: TMenuItem;
    mnReportsLatestVitalsDisplayPatient: TMenuItem;
    mnReportsVitalsEnteredInError: TMenuItem;
    View1: TMenuItem;
    Demographics1: TMenuItem;
    Allergies1: TMenuItem;
    mnHelp: TMenuItem;
    mnHelpIndex: TMenuItem;
    mnHelpWeb: TMenuItem;
    N3: TMenuItem;
    mnHelpAbout: TMenuItem;
    FileExit1: TFileExit;
    splPtSelect: TSplitter;
    CCRContextor: TCCRContextor;
    aclMain: TActionList;
    acFileExit: TAction;
    acFileBreakLink: TAction;
    acFileRejoinApp: TAction;
    acFileRejoinGlobal: TAction;
    acPatientEdit: TAction;
    N5: TMenuItem;
    UseApplicationData1: TMenuItem;
    UseGlobalData1: TMenuItem;
    BreaktheClinicalLink1: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    CCOW1: TMenuItem;
    acShowStatus: TAction;
    ShowStatus1: TMenuItem;
    pnlPtSelect: TPanel;
    pnlGraph: TPanel;
    fraGMV_GridGraph1: TfraGMV_GridGraph;
    acPatientSelect: TAction;
    Panel2: TPanel;
    pnlGroupActions: TPanel;
    SpeedButton1: TSpeedButton;
    acGroupInput: TAction;
    pnlTop: TPanel;
    pnlSpeedButtonDown: TPanel;
    pnlCCOWControls: TPanel;
    pnlPtInfo: TPanel;
    lblPatientName: TLabel;
    lblPatientInfo: TLabel;
    ccrContextorIndicator: TCCRContextorIndicator;
    Panel1: TPanel;
    sbtnAllergies: TSpeedButton;
    sbEnterVitals: TSpeedButton;
    sbtnPtLookup: TSpeedButton;
    pnlPatientDetails: TPanel;
    lblHospital: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    lblDateFromTitle: TLabel;
    acDevInfo: TAction;
    Bevel1: TBevel;
    PrintGraph1: TMenuItem;
    N2: TMenuItem;
    ShowHideGraphOptions1: TMenuItem;
    SelectGraphColor1: TMenuItem;
    pnlCCOWIndicator: TPanel;
    PatientInquiry1: TMenuItem;
    DataGridReport1: TMenuItem;
    ShowLog1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ShowGraphReport1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure FileExit1Hint(var HintStr: String; var CanShow: Boolean);
    procedure acPatientInfoExecute(Sender: TObject);
    procedure pnlPtInfoClick(Sender: TObject);
    procedure pnlPtInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPtInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acPtSelectExecute(Sender: TObject);
    procedure acPtAllergiesExecute(Sender: TObject);
    procedure acRunReportExecute(Sender: TObject);
    procedure mnFilePrinterSetupClick(Sender: TObject);
    procedure mnFileEnteredInErrorClick(Sender: TObject);
    procedure mnFileEditUserTemplatesClick(Sender: TObject);
    procedure mnFileUserOptionsClick(Sender: TObject);
    procedure mnHelpAboutClick(Sender: TObject);
    procedure mnHelpIndexClick(Sender: TObject);
    procedure mnHelpWebClick(Sender: TObject);
    procedure sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure acInputVitalsExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CCRContextorCommitted(Sender: TObject);
    procedure CCRContextorPatientChanged(Sender: TObject);
    procedure CCRContextorPending(Sender: TObject;
      const aContextItemCollection: IDispatch);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure ApplicationEventsRestore(Sender: TObject);
    procedure acFileBreakLinkExecute(Sender: TObject);
    procedure acFileRejoinAppExecute(Sender: TObject);
    procedure acFileRejoinGlobalExecute(Sender: TObject);
    procedure acShowStatusExecute(Sender: TObject);
    procedure fraGMV_GridGraph1acEnterVitalsExecute(Sender: TObject);
    procedure pnlPtSelectResize(Sender: TObject);
    procedure acPatientSelectExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acGroupInputExecute(Sender: TObject);
    procedure acDevInfoExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fraGMV_GridGraph1SpeedButton1Click(Sender: TObject);
    procedure CCRContextorSuspended(Sender: TObject);
    procedure CCRContextorResumed(Sender: TObject);
    procedure mnFileExitClick(Sender: TObject);
   // function ApplicationEventsHelp(Command: Word; Data: Integer; // ZZZZZZBELLC 7/30/2013
 //     var CallHelp: Boolean): Boolean;
    procedure pnlPtInfoEnter(Sender: TObject);
    procedure pnlPtInfoExit(Sender: TObject);
    procedure ShowLog1Click(Sender: TObject);
    procedure PatientInquiry1Click(Sender: TObject);
    procedure DataGridReport1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ShowHideGraphOptions1Click(Sender: TObject);
    procedure ShowGraphReport1Click(Sender: TObject);
    function ApplicationEventsHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
    bIgnoreListChanges: Boolean;
    { The fEditCount variable (see also the EditCount property) stores number of
      open modal forms that prevent the patient context from changing.  A counter
      instead of a boolean variable is required to handle nested modal forms.
      See the StartPatientEdit and EndPatientEdit procedures for more details. }
    fEditCount:  Integer;

    { The fPendingDFN variable holds an IEN (DFN) of the patient who must be
      selected as the current one after the modal forms, which block the patient
      context change, are closed.  See the StartPatientEdit, EndPatientEdit,
      and ccrContextorPatientChanged procedures for more details. }
    fPendingDFN: String;

    SwitchPatientSelector:Boolean;
    fIgnoreCount:Integer;

    FMDateTimeRange: TMDateTimeRange;
    FCurrentPtIEN:String;
    FCurrentTemplate: string;
    FCurrentHospitalID: string;
    FCurrentHospitalName: string;

    fPatientSelectorForm: TfrmGMV_PatientSelector;  // zzzzzzandria 050706

    function getpatientList: TListView;  // zzzzzzandria 050706

    procedure SetCurrentPtIEN(aDFN: string);
    procedure SetCurrentTemplate(const Value: string);
    function GetCurrentTemplate: string;
    procedure NewPtLookup(Sender: TObject);
    procedure SetReportsActive(bState: Boolean);

    procedure DrawDelay(sDelay:String;iDelay:Integer);
    procedure DrawDelayClear;
//    procedure SetStatusBar(sText:String);
    function SearchPattern:String;
    function SearchDelay:String;
//    function SearchStatus:String;
    function SearchMSDelay:Integer;
    procedure Disconnect;

    procedure StartPatientEdit; virtual;
    procedure EndPatientEdit; virtual;

    procedure DisplayHint(Sender: TObject);
    procedure setCCOWActionsStatus(bEnabled:Boolean);
    procedure FindPatientInSelector;

    procedure WMGetMinMaxInfo( var Message :TWMGetMinMaxInfo ); message WM_GETMINMAXINFO;
  protected
    property EditCount: Integer read fEditCount;
  public
    procedure CloseOtherForms(Force: Boolean = False);
    { Public declarations }
    function RestoreConnection:Boolean;
    procedure RestoreSettings;
    procedure setActionStatus(aValue:Boolean);
    procedure SetStatusBar(sText:String);
  published
    property CurrentTemplate: string      read GetCurrentTemplate write SetCurrentTemplate;
    property CurrentPtIEN: string         read FCurrentPtIEN write SetCurrentPtIEN;
    property CurrentHospitalID: string         read FCurrentHospitalID write FCurrentHospitalID;
    property CurrentHospitalName: string         read FCurrentHospitalName write FCurrentHospitalName;

    property PatientList:TListView read getPatientList; // zzzzzzandria 050706

  protected
    procedure CMPatientFound(var Message: TMessage); message CM_PATIENTFOUND; //AAN 06/11/02
    procedure CMPTSearching(var Message: TMessage); message CM_PTSEARCHING; //AAN 07/18/02
    procedure CMPTSearchDone(var Message: TMessage); message CM_PTSEARCHDONE; //AAN 07/18/02
    procedure CMPTSearchStart(var Message: TMessage); message CM_PTSEARCHSTART; //AAN 07/18/02
    procedure CMPatientListNotFound(var Message: TMessage); message CM_PTLISTNOTFOUND; //AAN 07/18/02
    procedure CMPTSearchKBMode(var Message: TMessage); message CM_PTSEARCHKBMODE; //AAN 07/18/02
    procedure CMPTSearchDelay(var Message: TMessage); message CM_PTSEARCHDELAY; //AAN 07/18/02

    procedure CMPTLISTCHANGED(var Message: TMessage); message CM_PTLISTCHANGED; //AAN 07/18/02
    procedure CMPTPeriodChanged(var Message: TMessage); message CM_PERIODCHANGED; //AAN 07/18/02
  end;

var
  frmGMV_UserMain: TfrmGMV_UserMain;

implementation

uses uGMV_Common, uGMV_User
  , uGMV_Utils, fGMV_PtInfo
  , fGMV_ReportOptions
  , fGMV_EnteredInError
  , fGMV_EditUserTemplates, uGMV_Template, fGMV_UserSettings
  , uGMV_GlobalVars, fGMV_AboutDlg, uGMV_SaveRestore, fGMV_InputLite
  , fROR_PCall
  , uROR_RPCBroker
  , fGMV_PtSelect, uGMV_FileEntry, uGMV_Engine, uGMV_Patient
  , uGMV_VersionInfo, Grids
  , fGMV_HospitalSelector2, fGMV_RPCLog, uGMV_Log
  , System.UITypes;

{$R *.dfm}

function Contextor: TCCRContextor;
begin
  Result := frmGMV_UserMain.ccrContextor;
end;

////////////////////////////////////////////////////////////////////////////CCOW
////////////////////////////////////////////////////////////////////////////CCOW
////////////////////////////////////////////////////////////////////////////CCOW
procedure TfrmGMV_UserMain.setCCOWActionsStatus(bEnabled:Boolean);
begin
// 2008-05-20 commented out to separate CCOW and movement within list
//  acGroupInput.Enabled := (frmGMV_PatientSelector.SelectCount > 1);
//  acInputVitals.Enabled := bEnabled;

  CCOW1.Enabled :=
    bEnabled and
    ccrContextor.Enabled and
    (ccrContextor.State<>CsParticipating);            // zzzzzzandria 060217

  acFileRejoinApp.Enabled := CCOW1.Enabled and (CurrentPtIEN<>''); // bEnabled and ccrContextor.Enabled;
  acFileRejoinGlobal.Enabled := CCOW1.Enabled; // bEnabled and ccrContextor.Enabled;
  acFileBreakLink.Enabled := ccrContextor.Enabled and (ccrContextor.State=CsParticipating);
end;

procedure TfrmGMV_UserMain.RestoreSettings;

  procedure RestoreGridGraph;
  begin
    try
      fraGMV_GridGraph1.FrameStyle := fsVitals;
      fraGMV_GridGraph1.RestoreUserPreferences;
    except
      on E: Exception do
         fraGMV_GridGraph1.cbxGraph.ItemIndex := 0;
    end;
  end;

  procedure RestoreDateRange;
  var
    i: Integer;
  begin
    if not Assigned(FMDateTimeRange) then
      FMDateTimeRange := TMDateTimeRange.Create;
    fraGMV_GridGraph1.SetUpFrame;
    fraGMV_GridGraph1.MDateTimeRange := FMDateTimeRange;

    i := StrToIntDef(GMVUser.Setting[usGridDateRange], 9);//AAN 12/11/02
    if i > 12 then i := 12;

    if fraGMV_GridGraph1.FrameStyle = fsVitals then
      begin
        fraGMV_GridGraph1.lbDateRange.ItemIndex := i;
        fraGMV_GridGraph1.cbxDateRangeClick(fraGMV_GridGraph1.lbDateRange);
      end;
  end;

  procedure RestorePatientSelectorWindow;
  var
    aForm: TfrmGMV_PatientSelector;
    s: String;
    i: Integer;

  begin
    aForm := nil;
    try
      aForm := getPatientSelectorForm;
      aForm.bIgnore := True;
      aForm.bIgnorePtChange := True;

      try
        s := getUserSettings('UNIT_INDEX');
        if (s <> '') and (s<>'-1') then
          begin
            aForm.pcMain.ActivePageIndex := 0;
            i := strToInt(s);
            aForm.lbUnits.ItemIndex := i;
            aForm.pcMainChange(nil);
            aForm.lbUnitsDblClick(nil);
            aForm.lvUnitPatients.Enabled := True;
          end;
      except
      end;

      try
        s := getUserSettings('WARD_INDEX');
        if (s <> '') and (s<>'-1') then
          begin
            aForm.pcMain.ActivePageIndex := 1;
            i := strToInt(s);
            aForm.lbWards.ItemIndex := i;
            aForm.pcMainChange(nil);
            aForm.lbUnitsDblClick(nil);
            aForm.lvWardPatients.Enabled := True;
          end;
      except
      end;

      try
        s := getUserSettings('TEAM_INDEX');
        if (s <> '') and (s<>'-1') then
          begin
            aForm.pcMain.ActivePageIndex := 2;
            i := strToInt(s);
            aForm.lbTeams.ItemIndex := i;
            aForm.pcMainChange(nil);
            aForm.lbUnitsDblClick(nil);
            aForm.lvTeamPatients.Enabled := True;
          end;
      except
      end;

      try
        s := getUserSettings('CLINIC_INDEX');
        if (s <> '') and (s<>'-1') then
          begin
            aForm.pcMain.ActivePageIndex := 3;
            aForm.cmbPeriod.ItemIndex := 0; // zzzzzzandria 2008-06-17
            i := strToInt(s);
            aForm.lbClinics.ItemIndex := i;
            aForm.pcMainChange(nil);
            aForm.lbUnitsDblClick(nil);
            aForm.lvClinicPatients.Enabled := True;
          end;
      except
      end;

      s := getUserSettings('SELECTOR_TAB');
      try
        if s = '' then i := 0
        else
          i := strToInt(s);
        aForm.pcMain.ActivePageIndex := i;
        aForm.pcMainChange(nil);
      except
      end;

      if aForm.Parent <> pnlPtSelect then
        begin
          aForm.Parent := pnlPtSelect;
          aForm.OnPatChange := NewPtLookup;
          aForm.BorderStyle := bsNone;
          aForm.pnlStatus.Visible := False;
          aForm.Align := alClient;
          aForm.Show;

          pnlGroupActions.Visible := True;
        end;
    except
    end;
    if Assigned(aForm) then
      begin
        aForm.bIgnore := False;
        aForm.bIgnorePtChange := True;
        fPatientSelectorForm := aForm;
      end;
  end;

var
  bTime,
  aTime: TDateTime;

begin
  // zzzzzzandria 2008-03-10   profiling changes ------------------------- begin
  aTime := EventStart('VITALS RestoreSettings --  Begin');
  FCurrentTemplate := GMVUser.Setting[usDefaultTemplate];

  RestorePatientSelectorWindow;
  bTime := EventAdd('Restore Patient Selector Window','',aTime);
  RestoreWindowSettings(TForm(Self));
  bTime := EventAdd('Restore LayoutSettings','',bTime);
  RestoreGridGraph;
  bTime := EventAdd('Restore GridGraph','',bTime);
  RestoreDateRange;
  EventAdd('Restore Date Range','',bTime);

  EventStop('VITALS RestoreSettings - end');
  // zzzzzzandria 2008-03-10   profiling changes --------------------------- end
end;

function TfrmGMV_UserMain.RestoreConnection:Boolean;
var
  s,
  stn:String;
  aTime,eTime: TDateTime;

const
  RPC_CREATECONTEXT = 'GMV V/M GUI';

begin
//zzzzzzandria 2008-03-11 =====================================================
  if Assigned(RPCBroker) then Disconnect;
  Result := False;

  if CmdLineSwitch(['/NOCCOW']) then
    begin
      ccrContextor.Enabled := False;
      RPCBroker := SelectBroker(RPC_CREATECONTEXT, nil);
    end
  else
    begin
      ccrContextor.Enabled := True;
      if CmdLineSwitch(['CCOW=PATIENTONLY','/PATIENTONLY']) then
        RPCBroker := SelectBroker(RPC_CREATECONTEXT, nil)
      else
        RPCBroker := SelectBroker(RPC_CREATECONTEXT, ccrContextor.Contextor);
    end;

  if RPCBroker = nil then
      Exit;

  GMVUser := TGMV_User.Create;

  if GMVUser.SignOn(RPC_CREATECONTEXT, True) then
    begin
      GMVTypes := TGMV_VitalType.Create;        // TGMV_VitalType.Create(RPCBroker);
      GMVQuals := TGMV_VitalQual.Create;        // TGMV_VitalQual.Create(RPCBroker);

      aTime := Now;
      InitVitalsIENS; // zzzzzzandria 060515
      aTime := EventStop('InitVitalsIENs -- Done','',aTime);
      GMVCats := TGMV_VitalCat.Create;          // TGMV_VitalCat.Create(RPCBroker);
      aTime := EventStop('Create Vitals Categories -- Done','',aTime);
      GMVNursingUnits := TGMV_NursingUnit.Create; // TGMV_NursingUnit.Create(RPCBroker);
      eTime := EventAdd('Create Nursing Units -- Done','',aTime);
      GMVWardLocations := TGMV_WardLocation.Create; // TGMV_WardLocation.Create(RPCBroker);
      eTime := EventAdd('Create Ward Locations -- Done','',eTime);
      GMVTeams := TGMV_Teams.Create;            // TGMV_Teams.Create(RPCBroker);
      eTime := EventAdd('Create Nursing Teams -- Done','',eTime);
      GMVClinics := TGMV_Clinics.Create;        // TGMV_Clinics.Create(RPCBroker);
      eTime := EventAdd('Create Clinics -- Done','',eTime);
      GMVDefaultTemplates := TGMV_DefaultTemplates.Create;// TGMV_DefaultTemplates.Create(RPCBroker);
      EventAdd('Create Templates -- Done','',eTime);

      RestoreSettings; // zzzzzzandria 2008-03-10

      Result := True;
    end
  else
    begin
      FreeAndNil(GMVUser);
      FreeAndNil(RPCBroker);
      Result := False;
    end;

  if Assigned(RPCBroker) then
    begin
      Result := True;
      { The contextor needs a reference to the RPC Broker to perform the
        DFN <-> ICN conversions. }
      aTime := Now;
      ccrContextor.RPCBroker := RPCBroker;
      EventStop('Assign Broker to Contextor','',aTime);

      with ccrContextor do
        begin
          { Here you should get a real station number from VistA }
          stn := getStationInfo;

          s := Piece(stn,'^',2);
          stn := Piece(stn,'^',1);
          if s = '0' then s := '_test';
//          if s = '1' then s := '_prod';
          if s = '1' then s := '';
          { If the station number is not available by any reason then the
            participation in the context will be suspended and the contextor
            will be disabled. }
          if stn <> '' then
            begin
              { Append the station number to the base name stored in
                the property ('patient.id.mrn.dfn_'). }
              DFNItemName := Piece(DFNItemName, '_') + '_' + stn + s;
              { Process the known subjects of the current context and
                extract available patient identifiers (convert the DFN
                to/from the ICN if necessary). }
              aTime := Now;
              ProcessKnownSubjects{(true)};// zzzzzzandria 2008-05-15
              EventStop('Process Context Subjects','',aTime);
              { Select the patient according to the current patient context }
              aTime := EventStart('Set Patient by Context Data -- Begin','DFN: '+PatientDFN);
              CurrentPtIEN := PatientDFN;
              EventStop('Set Patient by Context Data -- End','',aTime);
              if CurrentPtIEN<>'' then
                FindPatientInSelector;
            end
          else
            Enabled := False;
        end;

      if CmdLineSwitch(['/noccow','/NOCCOW']) then
        begin
          ccrContextor.Enabled := False;
          acFileBreakLink.Enabled := False;
          acFileRejoinApp.Enabled := False;
          acFileRejoinGlobal.Enabled := False;
          acShowStatus.Enabled := False;
          CCOW1.Enabled := False;
        end
      else
        CCOW1.Enabled := False;
    end;
end;

procedure TfrmGMV_UserMain.Disconnect;
begin 
  if Assigned(RPCBroker) then
    begin
//      Hide;    zzzzzzandria 2008-03-11
      { Disconnect and destroy the RPC Broker }
      RPCBroker.Connected := False;
      FreeAndNil(RPCBroker);
    end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_UserMain.SetCurrentPtIEN(aDFN: string);
var
  Value:String;
  sL: TStringList;
  aPatient: TPatient;
  aTime: TDateTime; //zzzzzzandria 060610
begin
  if (aDFN = fCurrentPtIEN) and (fCurrentPtIEN <>'') then Exit;
  Value := aDFN;
  FCurrentPtIEN := Value;

  fraGMV_GridGraph1.PatientDFN := FCurrentPtIEN;
  fraGMV_GridGraph1.PatientLocationName := '';
  fraGMV_GridGraph1.PatientLocation := '';
  if assigned(frmGMV_PatientSelector) then
    try
      fraGMV_GridGraph1.PatientLocationName := frmGMV_PatientSelector.SelectedPatientLocationName;
      fraGMV_GridGraph1.PatientLocation := frmGMV_PatientSelector.SelectedPatientLocationID;
    except
    end;

  try
    mnReportsLatestVitalsDisplayPatient.Enabled := False;
    mnReportsVitalsEnteredInError.Enabled := False;
    if FCurrentPtIEN <> '' then
      begin
        sL := getPatientHeader(Value);
        if Piece(SL[0], '^', 1) <> '-1' then
          begin
            lblPatientName.Caption := FormatPatientName(SL[1]);
            lblPatientInfo.Caption := FormatPatientInfo(SL[1] + SL[2]);
            acPtSelect.Enabled := True;
            acPtAllergies.Enabled := True;
            acPatientInfo.Enabled := True;
            acInputVitals.Enabled := True;

            mnReportsLatestVitalsDisplayPatient.Enabled := True;
            mnReportsVitalsEnteredInError.Enabled := True;

            // The location information should be provided by Patient object.
            // Otherwise when a patient would be changed by CCOW there will
            // be no way to figure out the location(Name and ID)
            aPatient := SelectPatientByDFN(FCurrentPtIEN,True);
            lblHospital.Caption := aPatient.LocationName;
            aPatient.Free;

            lblDateFromTitle.Caption := fraGMV_GridGraph1.lblDateFromTitle.Caption;
            pnlPatientDetails.Visible := True;
          end
        else
          begin
            lblPatientName.Caption := Piece(SL[0],'^',2);
            lblPatientInfo.Caption := '000-00-0000';
            acPtSelect.Enabled := False;
            acPtAllergies.Enabled := False;
            acPatientInfo.Enabled := False;
            acInputVitals.Enabled := False;
            pnlPatientDetails.Visible := False;
          end;
         SL.Free;
      end
    else if Assigned(PatientList) and (PatientList.SelCount > 1) then
      begin
        lblPatientName.Caption := 'Multiple Patients Selected';
        lblPatientInfo.Caption := '';
        acPtSelect.Enabled := False;
        acPtAllergies.Enabled := False; //AAN 05/28/2003
        acPatientInfo.Enabled := False; // zzzzzzandria 2008-02-13
        fraGMV_GridGraph1.acVitalsReport.Enabled := False; // zzzzzzandria 2008-02-13
      end
    else
      begin
        lblPatientName.Caption :='No Patient Selected';
        lblPatientInfo.Caption := '000-00-0000';
        acPtSelect.Enabled := True;
        acPtAllergies.Enabled := False;
        acPatientInfo.Enabled := False;
        pnlPatientDetails.Visible := False;
      end;

  except
    on E: Exception do
      begin
        lblPatientName.Caption := FCurrentPtIEN;
        lblPatientInfo.Caption := 'Error...';
        pnlPatientDetails.Visible := False;
      end;
  end;

  fraGMV_GridGraph1.SetGraphTitle(lblPatientName.Caption,lblPatientInfo.Caption);
  if fraGMV_GridGraph1.PatientDFN <> '' then
    begin
      fraGMV_GridGraph1.Visible := True;

      aTime := EventStart('UpdateFrame by StCurrentPtIEN','No Reload'); // zzzzzzandria 060610
      fraGMV_GridGraph1.UpdateFrame(false); // zzzzzzandria 060610
      {aTime := }EventStop('UpdateFrame by StCurrentPtIEN','No Reload',aTime); // zzzzzzandria 060610

      fraGMV_GridGraph1.scbHGraphChange(nil);
      fraGMV_GridGraph1.acPatientInfo.Enabled := True;
      fraGMV_GridGraph1.acVitalsReport.Enabled := True;
      fraGMV_GridGraph1.acShowGraphReport.Enabled := True;

      fraGMV_GridGraph1.PatientLocationName := lblHospital.Caption;

      Caption := 'Vitals for '+
        lblPatientName.Caption + ' ' + lblPatientInfo.Caption;
    end
  else
    begin
      fraGMV_GridGraph1.acPatientInfo.Enabled := False;
      fraGMV_GridGraph1.acVitalsReport.Enabled := False;
      fraGMV_GridGraph1.acShowGraphReport.Enabled := False;
      Caption := 'Vitals: No Patient Selected';
    end;
end;

procedure TfrmGMV_UserMain.CMPatientFound(var Message: TMessage);
begin
  SwitchPatientSelector := False;

  SetReportsActive(True);
  if CCRContextor.SetPatientContext(frmGMV_PatientSelector.SelectedPatientID) then
  //  CurrentPtIEN := TfrmGMV_PatientSelector(nil).SelectedPatientID; //ZZZZZZBELLC
   CurrentPtIEN :=  frmGMV_PatientSelector.SelectedPatientID; //ZZZZZZBELLC
  SwitchPatientSelector := True;
end;

////////////////////////////////////////////////////////////////////////////////
//  ROR Contextor
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_UserMain.FormDestroy(Sender: TObject);
begin
//  SaveWindowSettings(Self); // zzzzzzandria 2008-03-10
  if Assigned(FMDateTimeRange) then FreeAndNil(FMDateTimeRange);
  try
    with fraGMV_GridGraph1 do
      begin
        while chrtVitals.SeriesCount > 0 do
           chrtVitals.Series[0].Free;
        FreeAndNil(chrtVitals);
      end;
  except
  end;
  inherited;
end;

procedure TfrmGMV_UserMain.EndPatientEdit;
begin
  { Decrease the form nesting level }
  if fEditCount > 0 then
    Dec(fEditCount);
  { If this is the outmost nesting level then process the postponed
    patient change request. }
  if (fEditCount = 0) and (fPendingDFN <> '') then
    begin
      CurrentPtIEN := fPendingDFN; //      SelectPatient(fPendingDFN);
      fPendingDFN := '';
    end;
end;

procedure TfrmGMV_UserMain.StartPatientEdit;
begin
  if fEditCount = 0 then
      fPendingDFN := '';
  { Incrememt the form nesting level }
  Inc(fEditCount);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_UserMain.CCRContextorCommitted(Sender: TObject);
begin
  if Assigned(RPCBroker) then
    { Perform the checks required by the single sign-on/sign-off. }
    if RPCBroker.WasUserDefined and RPCBroker.IsUserCleared then
      begin
        { Force closure of all modal dialogs and message boxes }
        CloseOtherForms(True);
        { Terminate the application }
        Application.Terminate;
      end;
end;

procedure TfrmGMV_UserMain.CloseOtherForms(Force: Boolean);
var
  i: Integer;
begin
  { Close the forms only if there are modal dialogs and/or message boxes that
    block the patient context change or if the "forced" action is requested. }
  if (EditCount > 0) or Force then
    begin
      for i:=1 to Screen.CustomFormCount do
        begin
          { Close all modal dialogs and message boxes that are displayed
            over the this window (main application window). }
          if Screen.CustomForms[i-1] = Self then
            Break;
          if fsModal in Screen.CustomForms[i-1].FormState then
            Screen.CustomForms[i-1].Close;
        end;
    end;
end;

procedure TfrmGMV_UserMain.CCRContextorPatientChanged(Sender: TObject);
begin
  { If this application conditionally accepted the patient context change
    request and is forced to change it now then close modal dialogs and
    message boxes that block the patient context change. }
  if Contextor.ForcedChange then
    CloseOtherForms;
  { If there were modal dialogs and message boxes that blocked the patient
    context change then postpone the change until the outermost EndPatientEdit
    is executed. Otherwise, select the new patient immediately. }
  if EditCount > 0 then
    fPendingDFN := Contextor.PatientDFN
  else
    begin
      CurrentPtIEN := Contextor.PatientDFN;
      // zzzzzzandria 060614
      // Cleanup the patient selector if the request to switch came from CCOW
      try
        if assigned(frmGMV_PatientSelector) then
          FindPatientInSelector; // zzzzzzandria 060614
      except
      end;
    end;
end;

procedure TfrmGMV_UserMain.CCRContextorPending(Sender: TObject;
  const aContextItemCollection: IDispatch);
var
  newDFN, newICN: String;
  ctx: IContextItemCollection;
begin
  ctx := IContextItemCollection(aContextItemCollection);
  with ccrContextor do
    begin
      { Get the awailable patient identifier(s) }
      PatientDFNFromContext(ctx, newDFN);
      PatientICNFromContext(ctx, newICN);
      { Check if the context change is actually required }
      if (newDFN <> PatientDFN) or (newICN <> PatientICN) then
        { If there are modal dialogs and/or message boxex that block the
          patient context change then accept the request conditionally
          and inform the user about the potential data loss. }
        if EditCount > 0 then
          SetSurveyResponse('You might lose unsaved patient data.');
    end;
end;

procedure TfrmGMV_UserMain.DisplayHint(Sender: TObject);
begin
  SB.Panels[0].Text := Application.Hint;
end;

procedure TfrmGMV_UserMain.FormCreate(Sender: TObject);
begin
  SwitchPatientSelector := True; // zzzzzzandria 060614

  { Try to start the underlaying contextor and connect to the vault. If the
    Sentillion contextor is not installed on the users workstation or the vault
    is not available then the TCCRContextor will switch to idle mode and all
    requests will be ignored. }
  ccrContextor.Run;

  with ccrContextorIndicator do
    begin
{$IFDEF RORCCOW}
      width  := SB.Panels[1].Width - 4;
      height := SB.Height - 6;
      // the contextor indicator invokes OnResumed method of contextor.
      // the OnResumed method has no information on what context (Global or
      // application) was used to switch the patient.
      // To avoid confusion we are hiding the Indicator menu
      ccrContextorIndicator.PopupMenu := nil; // zzzzzzandria 060614
{$ENDIF}
    end;

  fIgnoreCount := 0;
  Application.OnHint := DisplayHint;

{$IFDEF SHOWLOG} // zzzzzzandria 060613
  N6.Visible := True;
  ShowLog1.Visible := True;
{$ELSE}
  N6.Visible := False;
  ShowLog1.Visible := False;
{$ENDIF}

  fraGMV_GridGraph1.SetUpFrame; // zzzzzzandria 2008-03-10
{$IFDEF PATCH_5_0_23}
  mnReportsVitalSigns.Visible := False;
  mnReportsBPPlottingChart.Visible := False;
  mnReportsWeightChart.Visible := False;
  mnReportsPOxRespirationChart.Visible := False;
  mnReportsPainChart.Visible := False;
  N4.Visible := False;
{$ENDIF}
end;

//ZZZZZZBELLC
function TfrmGMV_UserMain.ApplicationEventsHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
var
  s: String;
  iHelp: Integer;
begin
  ApplicationEvents.CancelDispatch;
  s := ExtractFileDir(Application.ExeName) + '\Help\'+
    ChangeFileExt(ExtractFileName(Application.ExeName),'.hlp');
  if Assigned(ActiveControl) then
    begin
      iHelp := ActiveControl.HelpContext;
      if iHelp = 0 then iHelp := 1;

      Application.HelpSystem.ShowContextHelp(iHelp,s);
      CallHelp := False;
    end;
  Result := True;

end;

procedure TfrmGMV_UserMain.ApplicationEventsMinimize(Sender: TObject);
begin
  { When application is minimized, it suspends the contextor. It does not make
    sense to change the context when the application is not visible anyway. }
//  ccrContextor.Suspend;
end;

procedure TfrmGMV_UserMain.ApplicationEventsRestore(Sender: TObject);
begin
Exit; //
  { When the application is restored, the participation in context is
    resumed and synchronization with the current context is performed. }
  Screen.Cursor := crHourGlass;
  ccrContextor.Resume(crmUseGlobalData);
  Screen.Cursor := crDefault;
end;

procedure TfrmGMV_UserMain.acFileBreakLinkExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ccrContextor.Suspend;
  Screen.Cursor := crDefault;
  setCCOWActionsStatus(true);
end;

procedure TfrmGMV_UserMain.acFileRejoinAppExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ccrContextor.Resume(crmUseAppData);
  Screen.Cursor := crDefault;
end;

procedure TfrmGMV_UserMain.acFileRejoinGlobalExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ccrContextor.Resume(crmUseGlobalData);
  FindPatientInSelector; //zzzzzzandria 060614
  Screen.Cursor := crDefault;
end;

procedure TfrmGMV_UserMain.CCRContextorSuspended(Sender: TObject);
begin
  CCOW1.Enabled := not (ccrCOntextor.State = csParticipating);
  acFileBreakLink.Enabled := ccrCOntextor.State = csParticipating;
end;

procedure TfrmGMV_UserMain.CCRContextorResumed(Sender: TObject);
begin
  CCOW1.Enabled := not (ccrCOntextor.State = csParticipating);
  acFileBreakLink.Enabled := ccrContextor.State = csParticipating;
end;

procedure TfrmGMV_UserMain.acShowStatusExecute(Sender: TObject);
begin
  ccrContextor.DisplayStatus;
end;

procedure TfrmGMV_UserMain.fraGMV_GridGraph1acEnterVitalsExecute(
  Sender: TObject);
begin
  fraGMV_GridGraph1.acEnterVitalsExecute(Sender);
end;

procedure TfrmGMV_UserMain.FormResize(Sender: TObject);
var
  i, wd, ii: Integer;
  sbpr: TRect;
const
  iCCOW = 1;
begin
  Inc(fIgnoreCount);
  if fIgnoreCount < 2 then
    begin
      wd := SB.Width;
      for i:=SB.Panels.Count-1 downto 1 do
        wd := wd - SB.Panels[i].Width;
      SB.Panels[0].Width := wd;

      { Place the CCOW contextor indicator on the status bar }
      SB.Perform(SB_GETRECT, iCCOW, LPARAM(@sbpr));
      with ccrContextorIndicator do
        begin
{$IFDEF TOPCCOWINDICATOR}
          Parent := pnlCCOWIndicator;
          Left   := pnlCCOWIndicator.Left +
            (pnlCCOWIndicator.Width - Width)  div 2;
          Top    := pnlCCOWIndicator.Top  +
            (pnlCCOWIndicator.Height  - Height) div 2;
{$ELSE}
          pnlCCOWIndicator.Visible := False;
          Parent := SB;
          Left   := sbpr.Left + (sbpr.Right  - sbpr.Left - Width)  div 2;
          Top    := sbpr.Top  + (sbpr.Bottom - sbpr.Top  - Height) div 2;
{$ENDIF}
        end;
    end;

  with fraGMV_GridGraph1 do
    begin
      ii := grdVitals.ColWidths[1]+grdVitals.GridLineWidth;
      wd := self.Width - pnlPtSelect.Width - splPtSelect.Width
        - pnlGLeft.Width - pnlGRight.Width
        - grdVitals.ColWidths[0];
      wd := wd mod ii;
      if (wd > 1) and (wd < ii) then
//        Self.Width := Self.Width +grdVitals.ColWidths[1]+1 - wd;
        pnlRight.Width := wd - 4;
        pnlRight.Visible := True;
    end;

  dec(fIgnoreCount);
end;

////////////////////////////////////////////////////////////////////////////////
// CM implementaion
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_UserMain.FindPatientInSelector; // zzzzzzandria 060613
var
  sDFN,sName,sSSN,
  sDOB: String;
  SL : TStringList;
  li: TListItem;
begin
  if CurrentPtIEN = '' then Exit;

  bIgnoreListChanges := True;
  with frmGMV_PatientSelector do
    begin
      if pcMain.ActivePageIndex = 4 then
        begin
          ClearListView(lvAllPatients);
          cmbAll.Text := '';
        end
      else
        begin
          if fCurrentPtIEN <> '' then   // zzzzzzandria 2008-03-11
            begin
              pcMain.ActivePageIndex := 4;// switch to "All" tab if there is a Pt
            end;
          frmGMV_PatientSelector.pcMainChange(nil);
        end;
    end;

  frmGMV_PatientSelector.ClearListView(frmGMV_PatientSelector.lvAllPatients);
  SL := getPatientHeader(fCurrentPtIEN);
  if sl.Count > 0 then
    begin
      sDFN := sl[0];
      sName := piece(sl[1],' ',1);
      sSSN := FormatSSN(piece(sl[1],'  ',2));
      sDOB := piece(sl[2],' ',2);
      li := frmGMV_PatientSelector.lvAllPatients.Items.Add;
      li.Caption := sName;
      li.SubItems.Add(sSSN);
      li.SubItems.Add(sDOB);
      li.Data := TGMV_FileEntry.CreateFromRPC('2;'+sDFN+'^'+sName);
    end;
  SL.Free;

  bIgnoreListChanges := False;
  frmGMV_PatientSelector.lvAllPatients.ItemIndex := 0;
  frmGMV_PatientSelector.SelectedPatientID := sDFN;
  setActionStatus(fCurrentPtIEN <> '')
end;

procedure TfrmGMV_UserMain.setActionStatus(aValue:Boolean);
begin
  acInputVitals.Enabled := aValue;
  acPtAllergies.Enabled := aValue;
  acPatientInfo.Enabled := aValue;
  fraGMV_GridGraph1.acPatientInfo.Enabled := aValue; // true zzzzzzhndria 2008-03-12
  fraGMV_GridGraph1.acVitalsReport.Enabled := aValue;
  fraGMV_GridGraph1.acShowGraphReport.Enabled := aValue;
  fraGMV_GridGraph1.Visible := aValue;
end;

function TfrmGMV_UserMain.SearchPattern:String;
begin
  if pos(' ',frmGMV_PatientSelector.Target)=1 then  result :='the last patient processed'
  else                                              result :=frmGMV_PatientSelector.Target;
end;
{
function TfrmGMV_UserMain.SearchStatus:String;
begin
  Result := frmGMV_PatientSelector.sStatus;
end;
}
function TfrmGMV_UserMain.SearchDelay:String;
begin
  Result :=frmGMV_PatientSelector.sSecondsToStart;
  if Result = '0.0' then
    Result := '';
end;

function TfrmGMV_UserMain.SearchMSDelay:Integer;
begin
  Result :=frmGMV_PatientSelector.iMSecondsToStart;
end;

procedure TfrmGMV_UserMain.SetStatusBar(sText:String);
begin
  sb.Panels[0].Text := sText;
end;

procedure TfrmGMV_UserMain.CMPatientListNotFound(var Message: TMessage);
begin
  SetStatusBar('  Pattern <'+SearchPattern +'> not found')
end;

procedure TfrmGMV_UserMain.CMPTSearching(var Message: TMessage);
begin
  SetStatusBar('  Looking for <'+SearchPattern +'>');
  DrawDelayClear;
end;

procedure TfrmGMV_UserMain.CMPTSearchDone(var Message: TMessage);
begin
  SetStatusBar('');
  DrawDelayClear;
end;

procedure TfrmGMV_UserMain.CMPTSearchStart(var Message: TMessage);
begin
  DrawDelayClear;
end;

procedure TfrmGMV_UserMain.CMPTSearchDelay(var Message: TMessage);
begin
//  SetStatusBar(searchStatus); commented zzzzzzandria 20080609
  drawDelay(SearchDelay, searchMSDelay);
  Application.ProcessMessages;
end;

procedure TfrmGMV_UserMain.CMPTSearchKBMode(var Message: TMessage);
begin
    if searchPattern <> '' then
      CMPTSearchDelay(Message)
    else
      SetStatusBar('  Type target to search and press <Enter>')
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_UserMain.NewPtLookup(Sender: TObject);
{This procedure processing TNotifyEvents from fraPtLookup}
begin
  if Sender is TfrmGMV_PatientSelector then
    begin
      if CCRContextor.SetPatientContext(TfrmGMV_PatientSelector(Sender).SelectedPatientID) then
      CurrentPtIEN := TfrmGMV_PatientSelector(Sender).SelectedPatientID;
  end;
end;

function TfrmGMV_UserMain.GetCurrentTemplate: string;
begin
  Result := Piece(FCurrentTemplate, '|', 2);
end;

procedure TfrmGMV_UserMain.SetCurrentTemplate(const Value: string);
begin
  FCurrentTemplate := Value;
end;

procedure TfrmGMV_UserMain.FileExit1Hint(var HintStr: String;
  var CanShow: Boolean);
begin
  Close;
end;

procedure TfrmGMV_UserMain.acPatientInfoExecute(Sender: TObject);
begin
  if CurrentPtIEN = '' then
    Exit; // zzzzzzandria 2008-02-12
  ShowPatientInfo(FCurrentPtIEN, '');
end;

procedure TfrmGMV_UserMain.pnlPtInfoClick(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvNone;
  Application. ProcessMessages;
  if acPatientInfo.Enabled then
    acPatientInfo.Execute
  else
    MessageDlg('Select Patient first.', mtInformation,[mbOk], 0);//CCOW 29/04/03 AAN
end;

procedure TfrmGMV_UserMain.pnlPtInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if acPatientInfo.Enabled then
    pnlPtInfo.BevelOuter := bvLowered;
end;

procedure TfrmGMV_UserMain.pnlPtInfoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if acPatientInfo.Enabled then
    pnlPtInfo.BevelOuter := bvNone;
end;

procedure TfrmGMV_UserMain.acPtSelectExecute(Sender: TObject);
begin
  pnlPtSelect.Visible := not pnlPtSelect.Visible;
  if not pnlPtSelect.Visible then
    begin
      splPtSelect.Align := alRight;
      splPtSelect.Visible := False;
    end;
  fraGMV_GridGraph1.pnlPtInfo.Visible := not pnlPtSelect.Visible;
  sbtnPtLookup.Down := pnlPtSelect.Visible;
  if pnlPtSelect.Visible then
    begin
      splPtSelect.Visible := True;
      splPtSelect.Align := alLeft;
    end;
  PtSelect1.Checked := pnlPtSelect.Visible;
end;

procedure TfrmGMV_UserMain.acPtAllergiesExecute(Sender: TObject);
begin
  if CurrentPtIEN = '' then
    Exit; // zzzzzzandria 2008-02-12
  sbtnAllergies.Down := True;
  ShowPatientAllergies(CurrentPtIEN, 'Allergies for: '+lblPatientName.Caption +
    '  ' + lblPatientInfo.Caption);
  sbtnAllergies.Down := False;
end;

procedure TfrmGMV_UserMain.acRunReportExecute(Sender: TObject);
var
  i: Integer;
begin
  i := -1;
(* zzzzzzandria 2008-02-21 ==================== removing vitals reports ========
  if Sender = mnReportsVitalSigns then i := 0
  else if Sender = mnReportsBPPlottingChart  then i := 1
  else if Sender = mnReportsWeightChart  then i := 2
  else if Sender = mnReportsPOxRespirationChart  then i := 3
  else if Sender = mnReportsPainChart  then i := 4
  else
*)
{$IFDEF PATCH_5_0_23}
  if Sender = mnReportsCumaulativeVitalsReport  then i := 0 //5
  else if Sender = mnReportsLatestVitalsbyLocation  then i := 1 //6
  else if Sender = mnReportsLatestVitalsDisplayPatient  then i := 2 //7
  else if Sender = mnReportsVitalsEnteredInError  then i := 3 //8;
  ;
{$ELSE}
  if Sender = mnReportsVitalSigns then i := 0
  else if Sender = mnReportsBPPlottingChart  then i := 1
  else if Sender = mnReportsWeightChart  then i := 2
  else if Sender = mnReportsPOxRespirationChart  then i := 3
  else if Sender = mnReportsPainChart  then i := 4
  else
  if Sender = mnReportsCumaulativeVitalsReport  then i := 5
  else if Sender = mnReportsLatestVitalsbyLocation  then i := 6
  else if Sender = mnReportsLatestVitalsDisplayPatient  then i := 7
  else if Sender = mnReportsVitalsEnteredInError  then i := 8
  ;
{$ENDIF}

  if i >= 0 then
    PrintReport2(i, CurrentPtIEN,lblPatientName.Caption+' '+lblPatientInfo.Caption);
end;

procedure TfrmGMV_UserMain.mnFilePrinterSetupClick(Sender: TObject);
begin
  with TPrinterSetupDialog.Create(Application) do
    try
      Execute;
    finally
      free;
    end;
end;

procedure TfrmGMV_UserMain.mnFileEnteredInErrorClick(Sender: TObject);
begin
  if CurrentPtIEN = '' then
    MessageDlg('No patient selected, please select a patient to continue', mtInformation, [mbOK], 0)
  else
    begin
      EnterVitalsInError(CurrentPtIEN);
      fraGMV_GridGraph1.PatientDFN := CurrentPtIEN;
    end;
end;

procedure TfrmGMV_UserMain.mnFileEditUserTemplatesClick(Sender: TObject);
begin
  EditUserTemplates;
end;

procedure TfrmGMV_UserMain.mnFileUserOptionsClick(Sender: TObject);
begin
  UpdateUserSettings;
//  fraGMV_GridGraph1.BGColor := GMVNormalBkgd;
  fraGMV_GridGraph1.BGTodayColor := GMVNormalTodayBkgd;
  try
    frmGMV_PatientSelector.SetTimerInterval(GMVSearchDelay);
  except
  end;
  if pnlPtSelect.Visible then
    fraGMV_GridGraph1.grdVitals.Refresh;
end;

procedure TfrmGMV_UserMain.mnHelpAboutClick(Sender: TObject);
begin
  GMVAboutDlg.Execute;
end;

procedure TfrmGMV_UserMain.mnHelpIndexClick(Sender: TObject);
begin
//showMessage('Help Index');
//Exit;
  Application.HelpCommand(HELP_INDEX, 0);
end;

procedure TfrmGMV_UserMain.mnHelpWebClick(Sender: TObject);
var
  s: String;
begin
//  ShellExecute(0, nil, PChar(GMV_WEBSITE), nil, nil, SW_NORMAL)
  s := getWebLinkAddress;
  if s <> '' then
    ShellExecute(0, nil, PChar(S), nil, nil, SW_NORMAL)
end;

procedure TfrmGMV_UserMain.DrawDelay(sDelay:String;iDelay:Integer);
var
  i: Integer;
  aRect:TRect;
begin
  with sb.Canvas do
    begin
      aRect.Top := 3;
      aRect.Bottom := sb.Height-2;
      aRect.Left :=  sb.Panels[0].width + sb.Panels[1].width + 3;
      aRect.Right := sb.Panels[0].width + sb.Panels[1].Width + sb.Panels[2].width - 10;
      DrawDelayClear;

      TextRect(aRect,sb.Panels[0].Width+sb.Panels[1].Width+4+2,{2}6,sDelay);

      aRect.Top := aRect.Top + 2;
      aRect.Bottom := aRect.Bottom -2;
      aRect.Left := aRect.Left + 2 + 25;
      aRect.Right := aRect.Right - 2;
      i := round((aRect.Right-aRect.Left-25)/10*(iDelay/500));
      aRect.Right := aRect.Left + i;
      Brush.Color := clBlue;
      FillRect(aRect);
    end;
end;

procedure TfrmGMV_UserMain.DrawDelayClear;
var
  aRect:TRect;
begin
  with sb.Canvas do
    begin
      aRect.Top := 3;
      aRect.Bottom := sb.Height-2;
      aRect.Left :=  sb.Panels[0].width + 3 + sb.Panels[1].width;
      aRect.Right := sb.Panels[0].width + sb.Panels[1].Width + sb.Panels[2].Width- 10;
      Brush.Color := clBtnFace;
      FillRect(aRect);
    end;
end;

procedure TfrmGMV_UserMain.sbDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel = sb.Panels[2] then  DrawDelayClear;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_UserMain.SetReportsActive(bState: Boolean);
begin
  mnReportsLatestVitalsDisplayPatient.Enabled := bState;
  mnReportsVitalsEnteredInError.Enabled := bState;
  mnFileEnteredInError.Enabled := bState;

  acPatientInfo.Enabled := bState;
  fraGMV_GridGraph1.acGraphButtons.Enabled := bState;
end;

procedure TfrmGMV_UserMain.pnlPtSelectResize(Sender: TObject);
begin
  pnlPtInfo.Width := pnlPtSelect.Width;
end;

procedure TfrmGMV_UserMain.acPatientSelectExecute(Sender: TObject);
var
  aDFN,aName:String;
begin
  if SelectPatientDFN(aDFN,aName) then
    ShowMessage('Selected Patient: <'+aname+'/'+aDFN+'>');
end;

procedure TfrmGMV_UserMain.CMPTLISTCHANGED(var Message: TMessage);
var
  bValue: Boolean;
begin
  if bIgnoreListChanges then Exit;
  acGroupInput.Enabled := (frmGMV_PatientSelector.SelectCount > 1);// zzzzzzandria 2008-05-20
  // moved from setCCOWActionStatus
{
  setCCOWActionsStatus(
    (frmGMV_PatientSelector.SelectCount <= 1) and
    (fraGMV_GridGraph1.PatientDFN <> '')
    );
}
  // zzzzzzandria 060608  ------------------------------------------------ Start
  bValue :=
    (frmGMV_PatientSelector.FocusedPatientID = frmGMV_PatientSelector.SelectedPatientID)
    and (frmGMV_PatientSelector.SelectedPatientID <> '') // 2008-03-06 zzzzzzandria
    and (frmGMV_PatientSelector.SelectedPatientID = FCurrentPtIEN) // 2008-03-06 zzzzzzandria
    ;

  setActionStatus(bValue);
  // zzzzzzandria 060608  ------------------------------------------------- Stop
{
  eventAdd(
    'Patient Change Notification (MSG)',
    '---------------------------'+#13#10+
    'Current Parient DFN:...... '+ FCurrentPtIEN + #13#10 +
    'Grid-Fraph Parient DFN:... '+ fraGMV_GridGraph1.PatientDFN);
}
end;

procedure TfrmGMV_UserMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  s: String;
begin
  ApplicationEvents.OnHelp := nil;// zzzzzzandria 2007-11-08
  try
    s := IntToStr(frmGMV_PatientSelector.pcMain.TabIndex);
    setUserSettings('SELECTOR_TAB',s);

//    s := IntToStr(frmGMV_PatientSelector.PatientGroup.ItemIndex);
//    setUserSettings('SELECTOR_GROUP_INDEX',s);

    s := IntToStr(frmGMV_PatientSelector.lbUnits.ItemIndex);
    setUserSettings('UNIT_INDEX',s);
    s := IntToStr(frmGMV_PatientSelector.lbWards.ItemIndex);
    setUserSettings('WARD_INDEX',s);
    s := IntToStr(frmGMV_PatientSelector.lbTeams.ItemIndex);
    setUserSettings('TEAM_INDEX',s);
    s := IntToStr(frmGMV_PatientSelector.lbClinics.ItemIndex);
    setUserSettings('CLINIC_INDEX',s);

  except
  end;

  fraGMV_GridGraph1.SaveStatus;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TfrmGMV_UserMain.acInputVitalsExecute(Sender: TObject);
var
  sHospitalInfo,
  sLocationName,sLocationID
//  ,sName,sInfo
  : string;
//  lvIndex: integer;

begin
{$IFDEF RORCCOW}
  if (PatientList.SelCount > 1) and (ccrContextor.State = CsParticipating) then
    begin // Leave CCOW context begore usint this mode;
      ShowMessage('You must leave the CCOW patient context to work '+
                  'with multiple patients.'+#13+
                  'To do this choose File| Break the Clinical Link');
      Exit;
    end;
{$ENDIF}

  if (CurrentPtIEN = '') and (PatientList.SelCount > 1) then
    begin
      CurrentPtIEN := TGMV_FileEntry(frmGMV_PatientSelector.PatientList.Selected.Data).IEN;
      frmGMV_PatientSelector.SetCurrentLocation;

      sHospitalInfo := getHospitalLocationByID(CurrentPtIEN);

      if (sHospitalInfo = '') or (sHospitalInfo = '0') or (pos('-1',sHospitalInfo) = 1) then
        begin
          if not SelectLocation2(CurrentPtIEN,sLocationID,sLocationName) then
            begin
              ShowMessage('Sorry, you must enter a location...');
              Exit;
            end;
        end
      else
        begin
          sLocationID := sHospitalInfo;
          sLocationName := getFileField('44','.01',sLocationID);
        end;
    end
  else

  if (CurrentPtIEN <> '') and (PatientList.SelCount <= 1) then
    begin
      sLocationID :=  frmGMV_PatientSelector.SelectedPatientLocationID;
      sLocationName := frmGMV_PatientSelector.SelectedPatientLocationName;

      if sLocationID = '' then
        begin
          sHospitalInfo := getHospitalLocationByID(CurrentPtIEN);

          if (sHospitalInfo = '') or (sHospitalInfo = '0') or (pos('-1',sHospitalInfo) = 1) then
            begin
              if not SelectLocation2(CurrentPtIEN,sLocationID,sLocationName) then
                begin
                  ShowMessage('Sorry, you must enter a location...');
                  Exit;
                end;
            end
          else
            begin
              sLocationID := sHospitalInfo;
              sLocationName := getFileField('44','.01',sLocationID);
            end;
        end
      else
        sHospitalInfo := sLocationID;

    end;
    if (CurrentPtIEN <> '') and (PatientList.SelCount <= 1) then
      begin
{$IFDEF RORCCOW}
        StartPatientEdit;
{$ENDIF}
        InputVitals(CurrentPtIEN,sLocationID, FCurrentTemplate,nil,sLocationName);

        fraGMV_GridGraph1.PatientDFN := CurrentPtIEN;
{$IFDEF RORCCOW}
        EndPatientEdit;
{$ENDIF}
      end
end;


procedure TfrmGMV_UserMain.acGroupInputExecute(Sender: TObject);
var
  sLocationName,sLocationID,
  sName,sInfo: string;
  lvIndex: integer;
  LI: TListItem;
  LV: TListView;

  function NewPatientListView:TListView;
  var
    LView:TListView;
    LC:TListColumn;
  begin
    LView := TListView.Create(Self);
    LView.Visible := false;
    LView.Parent := self;

    LC := LView.Columns.Add;
    LC.Caption := 'Name';
    LC := LView.Columns.Add;
    LC.Caption := 'ID';
    LC := LView.Columns.Add;
    LC.Caption := 'Description';
    LC := LView.Columns.Add;
    LC.Caption := 'Description2';

    Result := LView;
  end;

  function ConfirmSelection(anIndex:Integer):Boolean;
  begin
    with PatientList do
      begin
        if SelCount >= 1 then
          Result := Items[anIndex].Selected and
            PatientCheckSelectByDFN(TGMV_FileEntry(Items[lvIndex].Data).IEN,sName,sInfo)
        else
          result :=
            PatientCheckSelectByDFN(TGMV_FileEntry(Items[lvIndex].Data).IEN,sName,sInfo);
      end;
  end;

begin
{$IFDEF RORCCOW}
  if (PatientList.SelCount > 1) and (ccrContextor.State = CsParticipating) then
    begin // Leave CCOW context begore using list input mode;
      if MessageDlg(
        'You must leave the CCOW patient context to work '+
        'with multiple patients.'+#13+
        'Do you want to break the Clinical Link now?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          if not acFileBreakLink.Execute then
            begin
              ShowMessage('Error breaking the Clinical Link');
              Exit;
            end
          else
            setCCOWActionsStatus(true);
        end
      else
        Exit;
    end;
{$ENDIF}

// 060927 zzzzzzandria - no need to change the Context -
//                       we are not participating in the context at this point
//  sID := TGMV_FileEntry(frmGMV_PatientSelector.PatientList.Selected.Data).IEN;
//  if CCRContextor.SetPatientContext(sID) then
//    CurrentPtIEN := sID;

//  frmGMV_PatientSelector.SetCurrentLocation; zzzzzzandria 2008-02-27
// 2007-10-04 zzzzzzandria ----------------------------------------------- begin
(* 2007-10-04 ------------------------------------------------------------------
  sHospitalInfo := getHospitalLocationByID(CurrentPtIEN);

  if (sHospitalInfo = '') or (sHospitalInfo = '0') or (pos('-1',sHospitalInfo) = 1) then
    begin
      if not SelectLocation2(CurrentPtIEN,sLocationID,sLocationName) then
        begin
          ShowMessage('Sorry, you must enter a location...');
          setCCOWActionsStatus(PatientList.SelCount<=1);
          Exit;
        end;
    end
  else
    begin
      sLocationID := sHospitalInfo;
      sLocationName := getFileField('44','.01',sLocationID);
    end;
------------------------------------------------------------------ 2007-10-04 *)
  frmGMV_PatientSelector.setPatientLocationIDByFirstSelectedPatient; // zzzzzzandria 2008-02-28

  if frmGMV_PatientSelector.PatientLocationID = '' then
    begin
      if not SelectLocation2(CurrentPtIEN,sLocationID,sLocationName) then
        begin
          ShowMessage('Sorry, you must enter a location...');
//          setCCOWActionsStatus(PatientList.SelCount<=1);   // commented  2008-05-20
          Exit;
        end;
    end
  else
    begin
      sLocationID := frmGMV_PatientSelector.PatientLocationID;
      sLocationName := getFileField('44','.01', sLocationID);
    end;
// 2007-10-04 zzzzzzandria ------------------------------------------------- end

  LV := NewPatientListView;
  for lvIndex := 0 to PatientList.Items.Count - 1 do
    if ConfirmSelection(lvIndex) then
      begin
        LI := LV.Items.Add;
        LI.SubItems.Add(sName);
        LI.SubItems.Add(TGMV_FileEntry(PatientList.Items[lvIndex].Data).IEN);
        LI.SubItems.Add(sInfo);
      end;
  if (LV.Items.Count<1) then
      MessageDLG('Not enough information to start input'+#13+
        'Select one or more patients to proceed',MTinFORMATION ,[MBok],0)
  else
    InputVitals('', sLocationID, FCurrentTemplate,LV,sLocationName);

// 060927 zzzzzzandria - no need to change the Context -
//                       we are not participating in the context at this point
//  sID := TGMV_FileEntry(frmGMV_PatientSelector.PatientList.Selected.Data).IEN;
//  if CCRContextor.SetPatientContext(sID) then
//    CurrentPtIEN := sID;

//  setCCOWActionsStatus(PatientList.SelCount<=1); commented 2008-05-20

  LV.Free;

  frmGMV_PatientSelector.PatientList.ClearSelection;
end;


procedure TfrmGMV_UserMain.CMPTPeriodChanged(var Message: TMessage); //AAN 07/18/02
begin
  lblDateFromTitle.Caption := fraGMV_GridGraph1.lblDateFromTitle.Caption;
end;

function TfrmGMV_UserMain.getpatientList: TListView;  // zzzzzzandria 050706
begin
  Result := nil;
  if not Assigned(fPatientSelectorForm) then Exit;
  Result := fPatientSelectorForm.PatientList;
end;

procedure TfrmGMV_UserMain.acDevInfoExecute(Sender: TObject);
var
  s: String;
begin
  try
    with TVersionInfo.Create(self) do
    try
      s := '  '+ProductName + ' v.'+FileVersion+'  '+getKey('DeveloperInfo');
      SetStatusBar(s);
      Application.ProcessMessages;
      sleep(3000);
      SetStatusBar('');
    finally
      free;
    end;
  except
  end;
end;

procedure TfrmGMV_UserMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    word(VK_F1):
      if ssCtrl in Shift then
        acDevInfoExecute(nil)
      else
        Application.HelpCommand(HELP_INDEX, 0);
    word(VK_RETURN): if (ActiveControl= pnlPtInfo)
      and (pnlPtInfo.BevelOuter = bvRaised) then
        fraGMV_GridGraph1.acPatientInfo.Execute; // zzzzzzandria 060309
  end;
end;

procedure TfrmGMV_UserMain.fraGMV_GridGraph1SpeedButton1Click(Sender: TObject);
begin
  fraGMV_GridGraph1.sbGraphColorClick(Sender);
end;

procedure TfrmGMV_UserMain.mnFileExitClick(Sender: TObject);
begin
  Close;
end;
{   ZZZZZZBELLC
function TfrmGMV_UserMain.ApplicationEventsHelp(Command: Word;
  Data: Integer; var CallHelp: Boolean): Boolean;
var
  s: String;
  iHelp: Integer;
begin
  ApplicationEvents.CancelDispatch;
  s := ExtractFileDir(Application.ExeName) + '\Help\'+
    ChangeFileExt(ExtractFileName(Application.ExeName),'.hlp');
  if Assigned(ActiveControl) then
    begin
      iHelp := ActiveControl.HelpContext;
      if iHelp = 0 then iHelp := 1;

      Application.HelpSystem.ShowContextHelp(iHelp,s);
      CallHelp := False;
    end;
  Result := True;
end;  }

procedure TfrmGMV_UserMain.pnlPtInfoEnter(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvRaised;
end;

procedure TfrmGMV_UserMain.pnlPtInfoExit(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvNone;
end;

procedure TfrmGMV_UserMain.ShowLog1Click(Sender: TObject);
begin
  ShowRPCLog;
end;

(*
procedure getLocationDescription(aDFN:String;var aLocationName:String; var aLocationID:String);
var
  aPt:TPatient;
begin
   aPt := TPatient.CreatePatientByDFN(aDFN);
   aLocationName := aPT.LocationName;
   aLocationID := aPt.LocationID;
   aPT.Free;
end;
*)
procedure TfrmGMV_UserMain.PatientInquiry1Click(Sender: TObject);
begin
  fraGMV_GridGraph1.acPatientInfoExecute(Sender);
end;

procedure TfrmGMV_UserMain.DataGridReport1Click(Sender: TObject);
begin
  if CurrentPtIEN = '' then
    Exit; // zzzzzzandria 2008-02-12
  fraGMV_GridGraph1.acVitalsReportExecute(Sender);
end;

procedure TfrmGMV_UserMain.WMGetMinMaxInfo( var Message :TWMGetMinMaxInfo );
var
  wd,ii: Integer;
const
  delta = 2;//borders;
begin
  exit;
  if not assigned(fraGMV_GridGraph1) then Exit;
  with fraGMV_GridGraph1 do
    begin
      ii := grdVitals.ColWidths[1];
      wd := Screen.Width
        - pnlPtSelect.Width - splPtSelect.Width - grdVitals.ColWidths[0];
      wd := wd mod (ii+1);
      if (wd > 1) and (wd < ii) then
        wd := Screen.Width - wd;
    end;
  with Message.MinMaxInfo^ do
  begin
    ptMaxSize.X := wd;                            {Width when maximized}
    ptMaxSize.Y := Screen.WorkAreaHeight;         {Height when maximized}
    ptMaxPosition.X := (Screen.Width - wd) div 2; {Left position when maximized}

//    ptMaxPosition.Y := (Screen.Height - Screen.WorkAreaHeight) div 2; {Top position when maximized}
//    ptMinTrackSize.X := 100;           {Minimum width}
//    ptMinTrackSize.Y := 100;           {Minimum height}
//    ptMaxTrackSize.X := 300;           {Maximum width}
//    ptMaxTrackSize.Y := 300;           {Maximum height}
  end;
  Message.Result := 0;                 {Tell windows you have changed minmaxinfo}
  inherited;
end;


procedure TfrmGMV_UserMain.FormActivate(Sender: TObject);
begin
  try
    if Assigned(frmGMV_PatientSelector) then
      frmGMV_PatientSelector.pcMainChange(nil);
    setActionStatus(CurrentPtIEN <> '');
  except
  end;
end;

procedure TfrmGMV_UserMain.ShowHideGraphOptions1Click(Sender: TObject);
begin
  fraGMV_GridGraph1.acGraphOptionsExecute(Sender);
  ShowHideGraphOptions1.Checked := fraGMV_GridGraph1.pnlGraphOptions.Visible;
end;

procedure TfrmGMV_UserMain.ShowGraphReport1Click(Sender: TObject);
begin
  fraGMV_GridGraph1.acShowGraphReportExecute(Sender);

end;

end.


