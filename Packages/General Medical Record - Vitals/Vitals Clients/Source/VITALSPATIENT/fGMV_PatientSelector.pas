unit fGMV_PatientSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  uGMV_ScrollListBox
  , Math
  ;

type
  TgetList = function:TStringList of object;

  TfrmGMV_PatientSelector = class(TForm)
    pnlStatus: TPanel;
    pcMain: TPageControl;
    tsUnit: TTabSheet;
    tsTeam: TTabSheet;
    tsClinic: TTabSheet;
    tsWard: TTabSheet;
    tsAll: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    pnlTitle: TPanel;
    tmSearch: TTimer;
    Button1: TButton;
    Button2: TButton;
    lblSelected: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    pnlInfo: TPanel;
    lblPatientName: TLabel;
    Label7: TLabel;
    lblPatientLocationID: TLabel;
    Label12: TLabel;
    mmList: TMemo;
    lblSelectStatus: TLabel;
    pnlSelection: TPanel;
    pnlPtInfo: TPanel;
    lblSelectedName: TLabel;
    lblPatientInfo: TLabel;
    Panel3: TPanel;
    lvUnitPatients: TListView;
    Panel16: TPanel;
    Panel11: TPanel;
    Bevel2: TBevel;
    Label14: TLabel;
    Panel6: TPanel;
    Panel17: TPanel;
    cmbUnit: TComboBox;
    lbUnits: TListBox;
    Panel18: TPanel;
    Bevel7: TBevel;
    Label15: TLabel;
    Panel1: TPanel;
    lvWardPatients: TListView;
    Panel15: TPanel;
    Panel19: TPanel;
    Bevel8: TBevel;
    Label16: TLabel;
    Panel7: TPanel;
    Panel20: TPanel;
    cmbWard: TComboBox;
    lbWards: TListBox;
    Panel21: TPanel;
    Bevel9: TBevel;
    Label17: TLabel;
    Panel5: TPanel;
    lvAllPatients: TListView;
    Panel12: TPanel;
    Panel22: TPanel;
    Bevel10: TBevel;
    Label18: TLabel;
    Panel9: TPanel;
    cmbAll: TComboBox;
    Panel2: TPanel;
    lvTeampatients: TListView;
    Panel14: TPanel;
    Panel23: TPanel;
    Bevel11: TBevel;
    Label19: TLabel;
    Panel8: TPanel;
    Panel24: TPanel;
    cmbTeam: TComboBox;
    lbTeams: TListBox;
    Panel25: TPanel;
    Bevel12: TBevel;
    Label20: TLabel;
    Panel4: TPanel;
    lvClinicPatients: TListView;
    Panel13: TPanel;
    Panel26: TPanel;
    Bevel13: TBevel;
    Label21: TLabel;
    pnlClinic: TPanel;
    Panel27: TPanel;
    cmbClinic: TComboBox;
    Panel28: TPanel;
    Bevel14: TBevel;
    Label22: TLabel;
    Bevel15: TBevel;
    Label23: TLabel;
    cmbPeriod: TComboBox;
    pnlClinics: TPanel;
    lbClinics0: TListBox;
    sbClinics: TScrollBar;
    Label1: TLabel;
    Panel29: TPanel;
    Label5: TLabel;
    Label8: TLabel;
    lblSelectedPatientNameID: TLabel;
    Label9: TLabel;
    lblSelectedPatientLocationNameID: TLabel;
    lblTarget: TLabel;
    Panel30: TPanel;
    Label11: TLabel;
    Label6: TLabel;
    lblLocationName: TLabel;
    tmrLoad: TTimer;
    lblLoadStatus: TLabel;
    procedure tmSearchTimer(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure cmbUnitChange(Sender: TObject);
    procedure lbUnitsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbUnitsDblClick(Sender: TObject);
    procedure lvUnitPatientsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvUnitPatientsKeyPress(Sender: TObject; var Key: Char);
    procedure lvUnitPatientsDblClick(Sender: TObject);
    procedure lbUnitsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbUnitKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbUnitEnter(Sender: TObject);
    procedure cmbUnitExit(Sender: TObject);
    procedure lbUnitsEnter(Sender: TObject);
    procedure lbUnitsExit(Sender: TObject);
    procedure lvUnitPatientsEnter(Sender: TObject);
    procedure lvUnitPatientsExit(Sender: TObject);
    procedure cmbPeriodEnter(Sender: TObject);
    procedure cmbPeriodExit(Sender: TObject);
    procedure cmbPeriodChange(Sender: TObject);
    procedure cmbAllChange(Sender: TObject);
    procedure lvAllPatientsKeyPress(Sender: TObject; var Key: Char);
    procedure cmbAllKeyPress(Sender: TObject; var Key: Char);
    procedure lvUnitPatientsClick(Sender: TObject);
    procedure pnlPtInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPtInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmbClinicKeyPress(Sender: TObject; var Key: Char);
    procedure sbClinicsScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure sbClinicsChange(Sender: TObject);
    procedure lbClinics0KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pcMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmbClinicChange(Sender: TObject);
    procedure tmrLoadTimer(Sender: TObject);
    procedure lbClinics0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbClinics0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    fSelectedPatientName,
    fSelectedPatientID,
    fSelectedPatientLocationName,
    fSelectedPatientLocationID: String;

    fPatientID: string; //
    fPatientLocationName,
    fPatientLocationID,
    fPatientName:String;

    fLocationName,
    fLocationCaption, // Name of Location record in the list
    fLocationID:String;

    fTarget: String;

    fSource: TComboBox;
    fListBox: TListBox;
    fLV: TListView;
    fGetList: TgetList;
    fFound: Integer;
    fIgnore:Boolean;

    bDown: Boolean;
    bUseLocationID:Boolean;

    bLastClinicFound: Boolean;
    sLastClinicFound: String;

    fOnPatChange: TNotifyEvent;

    function getUnitList:TStringList;
    function getWardList:TStringList;
    function getTeamList:TStringList;
    function getClinicList:TStringList;
    function getAllPatientList:TStringList;

    procedure NotifyStart;
    procedure NotifyEnd;
    procedure setTarget(aValue:String);
    function UpdateListView(aSource:TStrings;lvItems:TListItems;
      iCaption,iSSN:Integer; iSubItems: array of Integer;aMode:Integer):Integer;
    procedure ReportFoundItems(aCount:Integer;aMessage:String);

    procedure SetPatientIEN(const Value: string);

    procedure SetCurrentPatient;
    procedure SetCurrentList;

    function getSelectCount:Integer;
    function getFocusedPatientID:String;

    function UploadClinics(aTarget,aDirection:String;anOption:Word): Integer;
    procedure FindClinics(aTarget:String);
    function LookupClinicInTheList(aTarget:String):Integer;

    procedure UpdateScrollBar;

  public
//    lbClinics: TListBox;
    lbClinics: TNoVScrollListBox; // zzzzzzandria 2008-04-17
    { Public declarations }
    bIgnore: Boolean;
    bIgnorePtChange:Boolean; // zzzzzzandria 2008-03-07

    iMSecondsToStart:Integer; //
    sSecondsToStart:String;   //
    sStatus:String;
    SelectionStatus:String;

    property Target:String read fTarget write setTarget;

    property FoundCount:Integer read fFound;
    property SelectCount: Integer read getSelectCount;

    property PatientGroup: TListBox read fListBox;
    property PatientList: TListView read fLV;

    property FocusedPatientID:String read getFocusedPatientID;

    property PatientLocationID :String read fPatientLocationID;// zzzzzzandria 2007-10-04

    property SelectedPatientName:String read fPatientName;
    property SelectedPatientID: string read fSelectedPatientID write SetPatientIEN;
    property SelectedPatientLocationName:String read fSelectedPatientLocationName;
    property SelectedPatientLocationID:String read fSelectedPatientLocationID;
    property OnPatChange: TNotifyEvent read FOnPatChange write FOnPatChange;

    procedure SetUp;
    procedure SetTimerInterval(sInterval:String);

    procedure setInfo;
    procedure clearInfo;
    procedure SetCurrentLocation;
    procedure SilentSearch;
    procedure Search;
    procedure ClearListView(aLV: TListView);
    procedure setPatientLocationIDByFirstSelectedPatient; // zzzzzzandria 2008-02-28
  end;

var
  frmGMV_PatientSelector: TfrmGMV_PatientSelector;

function SelectPatientDFN(var aDFN: String; var aName:String): Boolean;
function getPatientSelectorForm:  TfrmGMV_PatientSelector;

const
  ssSelected = 'SELECTED';
  ssInProgress = 'Selection In Progress';
var
  iLoadLimit: Integer; //500;

implementation

uses uGMV_Common, uGMV_FileEntry, uGMV_Const, uGMV_Engine, uGMV_GlobalVars,
  fGMV_PtSelect, uGMV_Patient, fGMV_PtInfo
  , fGMV_UserMain, uGMV_Log, system.UITypes;

{$R *.dfm}
function getPatientSelectorForm:  TfrmGMV_PatientSelector;
begin
  EventAdd('get Patient Selector Form -- Begin');
  if not Assigned(frmGMV_PatientSelector) then
    begin
      EventAdd('Create Patient Selector Form');
      Application.CreateForm(TfrmGMV_patientSelector, frmGMV_PatientSelector);
      frmGMV_PatientSelector.SetUp;
    end;
  Result := frmGMV_PatientSelector;
  EventAdd('get Patient Selector Form -- Begin');
end;

function SelectPatientDFN(var aDFN: String; var aName:String): Boolean;
begin
  EventAdd('Select Patient By DFN - start','DFN: '+aDFN);
  Result := False;
  if not Assigned(frmGMV_PatientSelector) then
    begin
      Application.CreateForm(TfrmGMV_patientSelector, frmGMV_PatientSelector);
      frmGMV_PatientSelector.SetUp;
    end;
  if  frmGMV_PatientSelector = nil then exit;

  if frmGMV_PatientSelector.ShowModal = mrOK then
    begin
      frmGMV_PatientSelector.tmSearch.Enabled := False;
      aName := frmGMV_PatientSelector.SelectedPatientName;
      aDFN := frmGMV_PatientSelector.SelectedPatientID;
      Result := True;
    end;
  EventAdd('Select Patient By DFN - stop','DFN: '+aDFN+ ', Name: '+aName);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.FormCreate(Sender: TObject);

  // zzzzzzandria 5.0.23.6 20090218 --------------------------------------------
  procedure setLV(aListView: TListView;aValue: Boolean =True);
  var
    i: Integer;
  begin
    for i := 0 to aListView.Columns.Count - 1 do
      aListView.Columns[i].AutoSize := aValue;
  end;
  // zzzzzzandria 5.0.23.6 20090218 --------------------------------------------

begin
  SelectionStatus := '';
  bIgnorePtChange := False;
  bIgnore := False;
  fIgnore := False;
  fFound := 0;
  pcMain.ActivePageIndex := 0;
  fGetList := getUnitList;
  fSource := cmbUnit;
  fLV := lvUnitPatients;
  fListBox := lbUnits;

  lblSelected.Caption := '';
  lblSelected.Visible := False;
  pnlInfo.Visible := False;

  lblPatientName.Caption := '';
  lblPatientLocationID.Caption := '';

  cmbUnit.Color := clTabIn;
  cmbWard.Color := clTabIn;
  cmbTeam.Color := clTabIn;
  cmbClinic.Color := clTabIn;
  cmbAll.Color := clTabIn;

  lbClinics := TNoVScrollListBox.Create(pnlClinics);
//  lbClinics := TListBox.Create(pnlClinics);
//  lbClinics.Sorted := True;
  lbClinics.Align := alClient;
  lbClinics.Parent := pnlClinics;
  lbClinics.Color := clWindow;
  lbClinics.OnClick := lbUnitsClick;
  lbClinics.OnDblClick := lbUnitsDblClick;
  lbClinics.OnEnter := lbUnitsEnter;
  lbClinics.OnExit := lbUnitsExit;
  lbClinics.OnKeyDown := lbClinics0KeyDown;//lbClinics.OnKeyDown:=lbUnitsKeyDown;
  lbClinics.OnMouseDown := lbClinics0MouseDown;
  lbClinics.OnMouseUp := lbClinics0MouseUp;

  bLastClinicFound := False;
  sLastClinicFound := '';
{
  setLV(lvUnitPatients);        // zzzzzzandria 5.0.23.6 20090218
  setLV(lvWardPatients);        // zzzzzzandria 5.0.23.6 20090218
  setLV(lvAllPatients);         // zzzzzzandria 5.0.23.6 20090218
  setLV(lvTeampatients);        // zzzzzzandria 5.0.23.6 20090218
  setLV(lvClinicPatients);      // zzzzzzandria 5.0.23.6 20090218
}
end;

procedure TfrmGMV_PatientSelector.Setup;
var
  sl: TStringList;

  procedure setLoadLimit;
  var
    sLoadLimit: String;
  begin
    if cmdLineSwitch(['ll','LL','LOADLIMIT','LoadLimit'],sLoadLimit) then
      iLoadLimit := StrToIntDef(sLoadLimit,iLoadLimit);
  end;

  procedure setLB(aLB: TListBox;aSL: TStringList);
  begin
    try
      aLB.Items.Clear;
      aLB.Items.Assign(aSL);
    except
    end;
  end;

begin
  bIgnore := True; // zzzzzzandria 2008-03-07
  bIgnorePtChange := True;
  if GMVNursingUnits.Entries.Count < 1 then GMVNursingUnits.LoadEntries('211.4');
  SetLB(lbUnits, GMVNursingUnits.Entries);

  if GMVWardLocations.Entries.Count < 1 then   GMVWardLocations.LoadWards;
  SetLB(lbWards, GMVWardLocations.Entries);

  if GMVTeams.Entries.Count < 1 then GMVTeams.LoadEntries('100.21');
  SetLB(lbTeams, GMVTeams.Entries);

{$IFDEF LOADLIMITPARAM}
  setLoadLimit;
{$ENDIF}
  if GMVClinics.Entries.Count < 1 then
    begin
      SL := getClinicFileEntriesByName('',intToStr(iLoadLimit),'1');
      if Assigned(SL) then
        begin
          GMVClinics.Entries.Assign(SL);
          SetLB(lbClinics, GMVClinics.Entries);

      sLastClinicFound := SL[SL.Count-1];
      SL.Free;
        end;
    end;
//  tmrLoad.Enabled := true; -- no background load

  if (lbClinics.Items.Count > 0) and (pcMain.ActivePage= tsClinic) then
    begin
      lbClinics.setFocus;   // zzzzzzandria 060920 -- commented to avoid RTE
      UpdateScrollBar;
    end;
  bIgnorePtChange := False;
  bIgnore := False; // zzzzzzandria 2008-03-07
  EventAdd('Patient Selector Setup Performed');
end;

procedure TfrmGMV_PatientSelector.SetTimerInterval(sInterval:String);
begin
  sSecondsToStart := sInterval;
  iMSecondsToStart := round(StrToFloat(GMVSearchDelay)*1000.0);
end;

procedure TfrmGMV_PatientSelector.SetPatientIEN(const Value: string);
begin
  fSelectedPatientID := Value;
  if Assigned(FOnPatChange) then
    FOnPatChange(Self);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.ReportFoundItems(aCount:Integer;aMessage:String);
begin
  if aCount = 0 then
    begin
      if not bIgnore then
        MessageDlg(aMessage, mtInformation, [mbok], 0);
    end
  else
    begin
      try
        if GetParentForm(Self).Visible then // zzzzzzandria 2007-07-16
        GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);
      except                                // zzzzzzandria 2007-07-16
      end;                                  // zzzzzzandria 2007-07-16
      lblSelected.Caption := 'Found: '+IntToStr(aCount);
    end;
end;

function TfrmGMV_PatientSelector.getUnitList:TStringList;
var
  RetList: TStringList;
begin
  fPatientLocationID := '';
  fPatientLocationName := '';

  RetList := getNursingUnitPatients(fLocationID);
  if RetList.Count < 1 then
    fFound := 0
  else
    fFound := UpdateListView(RetList,lvUnitPatients.Items,2,3,[4],0);

  sStatus := Format('%d patients found for nursing unit %s',[fFound,fLocationName]);
  ReportFoundItems(fFound,sStatus);

  Result := Retlist;
end;

function TfrmGMV_PatientSelector.getWardList:TStringList;
var
  RetList: TStringList;
begin
  RetList := getWardPatients(fLocationName);
  if RetList.Count < 1 then
    fFound := 0
  else
    fFound := UpdateListView(RetList,lvWardPatients.Items,2,3,[4],1);
{
  if fFound > 0 then
    begin
      fPatientLocationID := fLocationID;
      fPatientLocationName := fLocationName;
    end;
}
  sStatus := Format('%d patients found for the ward <%s>',[fFound,fLocationName]);
  ReportFoundItems(fFound,sStatus);

  Result := retList;
end;

function TfrmGMV_PatientSelector.getTeamList:TStringList;
var
  RetList: TStringList;
begin
  fPatientLocationID := '';
  fPatientLocationName := '';

  RetList := getTeampatients(fLocationID);

  if RetList.Count < 1 then
    fFound := 0
  else
    if RetList[0] = 'NO PATIENTS' then fFound := 0
    else fFound := UpdateListView(RetList,lvTeamPatients.Items,1,3,[4],2);

  sStatus := Format('%d patients found for the team <%s>',[fFound,fLocationName]);
  ReportFoundItems(fFound,sStatus);

  Result := RetList;
end;

function TfrmGMV_PatientSelector.getClinicList:TStringList;
var
  RetList: TStringList;
  sFailourReason:String;
begin
  if (fLocationName<>'') and (cmbPeriod.Text <> '') then
    begin
      RetList := getClinicPatients(fLocationCaption,cmbPeriod.Text);

      sFailourReason := '';
      if  (RetList.Count < 1) then
        fFound := 0
      else if pos('No patient',RetList[0]) <> 0 then
        fFound := 0
      else if pos('No clinic',RetList[0]) <> 0 then
        begin
          fFound := 0;
          sFailourReason := 'Check clinic name';
        end
      else if pos('ERROR',Uppercase(RetList[0])) <> 0 then
        begin
          fFound := 0;
          if pos('^',RetList[0]) > 0 then
            sFailourReason := piece(RetList[0],'^',2)
          else
            sFailourReason := RetList[0];
        end
      else
        fFound := UpdateListView(RetList,lvClinicPatients.Items,2,5,[6,4],3);

      sStatus := Format('%d patient apointments found for:'+#13+
        #13+'Clinic: <%s>'+
        #13+'Date:   <%s>'+
        #13+#13+'%s',[fFound,fLocationName,cmbPeriod.Text,sFailourReason]);

      if fFound > 0 then
        begin
          lvClinicPatients.ItemFocused := lvClinicPatients.Items[0];
          GetParentForm(Self).Perform(CM_SELECTPTLIST, 0, 0);
        end;
      ReportFoundItems(fFound,sStatus);

      Result := RetList;
    end
  else
    Result := nil;
end;

function TfrmGMV_PatientSelector.getAllPatientList:TStringList;
var
  RetList: TStringList;
begin
  fPatientLocationID := '';
  fPatientLocationName := '';
  RetList := getPatientList(Target);
  if Piece(RetList[0], '^', 1) = '-1' then
    begin
      fFound := 0;
      GetParentForm(Self).Perform(CM_PTLISTNOTFOUND, 0, 0); //AAN 07/22/02
      MessageDlg(Piece(RetList[0], '^', 2), mtInformation, [mbok], 0);
    end
  else
    begin
      RetList.Delete(0);
      fFound := UpdateListView(RetList,lvAllPatients.Items,2,11,[10],4);
// zzzzzzandria 2008-03-10 commenting out message to parent form
// parent form will be notified later
//      GetParentForm(Self).Perform(CM_PTLISTCHANGED, RetList.Count, 0); //AAN 08/30/02
    end;
  Result := RetList;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.SilentSearch;
var
  tmpList: TStringList;
begin
  pcMain.Enabled := False; // zzzzzzandria 2008-04-15
  eventAdd('Silent Search');
  if assigned(fGetList) then
    begin
      ClearListView(fLV);
      tmSearch.Enabled := False;
      tmpList := fGetList;
      GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0);
      tmpList.Free;
      pcMain.Enabled := True; // zzzzzzandria 2008-05-12
      if fFound > 0 then
        begin
          fLV.TabStop := true;
          fLV.Enabled := true;
          Application.ProcessMessages;
          try
            fLV.Selected := fLV.Items[0];
            if self.Visible then // zzzzzzandria 2007-07-16
              fLV.SetFocus;
          except
          end;
        end
      else
        begin
          fLV.TabStop := False;
          fLV.Enabled := False;
        end;
    end;
  pcMain.Enabled := True; // zzzzzzandria 2008-04-15
  if not self.Visible then
    exit; // zzzzzzandria 2008-11-03
  if pcMain.ActivePage = tsClinic then
    try
      if fFound = 0 then
        cmbPeriod.SetFocus;
    except
//      on E: Exception do
//      ShowMessage(E.Message);
    end;
end;

procedure TfrmGMV_PatientSelector.Search;
begin
  NotifyStart;
  SilentSearch;
  NotifyEnd;
end;

procedure TfrmGMV_PatientSelector.tmSearchTimer(Sender: TObject);
begin
  if iMSecondsToStart >= 500 then
    begin
      iMSecondsToStart := iMSecondsToStart - 500;
      sSecondsToStart := Format('%3.1n',[iMSecondsToStart/1000.0]);
      lblSelected.Caption := 'Seconds to start: '+sSecondsToStart;
      GetParentForm(Self).Perform(CM_PTSEARCHDelay, 0, 0); //AAN 07/22/02
    end
  else
    begin
      tmSearch.Enabled := False;
      if pcMain.ActivePage = tsAll then
        Search
      else
      if pcMain.ActivePage = tsClinic then
        FindClinics(cmbClinic.Text);
    end;
end;

procedure TfrmGMV_PatientSelector.clearInfo;
begin
  lblPatientName.Caption := '...';
  lblLocationName.Caption := '...';
  lblPatientLocationID.Caption := '';
  lblSelectedPatientNameID.Caption := '';
  lblSelectedPatientLocationNameID.Caption := '';
  lblSelectStatus.Caption := '?';
end;

procedure TfrmGMV_PatientSelector.setInfo;
begin
  try
    lblTarget.Caption := fSource.Text;
    lblSelectedPatientNameID.Caption :=
      fSelectedPatientName + ' /' + fSelectedPatientID;
    lblSelectedPatientLocationNameID.Caption :=
      fSelectedPatientLocationName + ' /' + fSelectedPatientLocationID;
    lblLocationName.Caption := fLocationName + ' / ' + fLocationID;
    lblSelectStatus.Caption := SelectionStatus;
    lblPatientName.Caption := fPatientName + ' / '+ fPatientID;
    lblPatientLocationID.Caption := fPatientLocationName + ' / ' + fPatientLocationID;

    if SelectionStatus <> ssSelected then
      begin
        lblSelectedName.Caption := 'No Patient Selected';
        lblPatientInfo.Caption := '000-00-0000';
      end;
  except
    ClearInfo;
  end;
end;

procedure TfrmGMV_PatientSelector.SetCurrentList;
var
  i: Integer;
begin
  eventAdd('Set Current List',fLV.Name);
  mmList.Lines.Clear;
  for i := 0 to fLV.Items.Count - 1 do
    if (fLV.Items[i].Selected)
      and Assigned(fLV.Items[i].Data) // zzzzzzandria 2007-07-17
    then
      mmList.Lines.Add(fLV.Items[i].Caption+' / '+
                       TGMV_FileEntry(fLV.Items[i].Data).IEN);
  GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0); // zzzzzzandria 050518
end;

procedure TfrmGMV_PatientSelector.pcMainChange(Sender: TObject);
const
  iUnit = 0;
  iWard = 1;
  iTeam = 2;
  iClinic = 3;
  iAll = 4;

begin
  eventAdd('Page Control Change', 'Selected Tab: '+pcMain.ActivePage.Name);
  tmSearch.Enabled := False;
  lblSelected.Caption := '';
  clearInfo;
  case pcMain.ActivePageIndex of
    iUnit: begin
      fSource := cmbUnit;
      fLV := lvUnitPatients;
      fListBox := lbUnits;
      fGetList := getUnitList;
      bUseLocationID := False;
    end;
    iWard: begin
      fSource := cmbWard;
      fLV := lvWardPatients;
      fListBox := lbWards;
      fGetList := getWardList;
      bUseLocationID := True;
      end;
    iTeam: begin
      fSource := cmbTeam;
      fLV := lvTeampatients;
      fListBox := lbTeams;
      fGetList := getTeamList;
      bUseLocationID := False;
      end;
    iClinic: begin
      fSource := cmbClinic;
      fLV := lvClinicPatients;
      fListBox := lbClinics;
      fGetList := getClinicList;
      bUseLocationID := True;
      end;
    iAll: begin
      fSource := cmbAll;
      fLV := lvAllPatients;
      fListBox := nil;
      fGetList := getAllPatientList;
      bUseLocationID := False;
      end;
  end;
  Target := fSource.Text;
  try
    if self.Visible then // zzzzzzandria 2007-07-16
      fSource.SetFocus;
  except
    on e: Exception do
      begin
      end;
  end;

  SetCurrentLocation;
  SetCurrentPatient;
  SetCurrentList;// list of selected patients, sends message to parent form
  SelectionStatus := 'Not selected';
  SetInfo;
end;

procedure TfrmGMV_PatientSelector.setTarget(aValue:String);
begin
  tmSearch.Enabled := False;
  fTarget := aValue;
end;

procedure TfrmGMV_PatientSelector.NotifyStart;
begin
  lblSelected.Caption := 'Search...';
  GetParentForm(Self).Perform(CM_PTSEARCHING, 0, 0); //AAN 07/22/02
end;

procedure TfrmGMV_PatientSelector.NotifyEnd;
begin
  GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
  lblSelected.Caption := 'Found: '+IntToStr(fFound);;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.cmbUnitChange(Sender: TObject);
var
  i: integer;
  Found: Boolean;
  LookFor: string;
begin
  if fIgnore then Exit;

  if fListBox <> nil then
    begin
      Found := False;
      ClearListView(fLV);
      Target := fSource.Text; // get search target
      if Target <> '' then
        begin
          i := 0;
          LookFor := LowerCase(Target);
          while (i < fListBox.Items.Count) and (not Found) do
            begin
              if LowerCase(Copy(fListBox.Items[i], 1, Length(LookFor))) = LookFor then
                begin
                  fListBox.ItemIndex := i;
                  fSource.Text := fListBox.Items[i];
                  fSource.SelStart := Length(LookFor);
                  fSource.SelLength := Length(fSource.Text);
                  Found := True;
                end
              else
                inc(i);
            end;
        end;
      if not Found then  fListBox.ItemIndex := -1;
    end;

  SelectionStatus := ssInProgress;
  SetInfo;
end;

procedure TfrmGMV_PatientSelector.cmbPeriodChange(Sender: TObject);
begin
  if fIgnore Then Exit;
  if (fSource.Text <> '') and (cmbPeriod.Text<>'') then
    lbUnitsDblClick(nil);
end;

procedure TfrmGMV_PatientSelector.cmbAllChange(Sender: TObject);
var
  s: String;
begin
  if fIgnore then s := 'True'
  else s := 'False';
  EventAdd('Search Target Changed', 'Ignore:'+ s+' LV: '+fLV.Name + ' Target: '+fSource.Text);
  if fIgnore Then Exit;

  ClearListView(fLV);
  Target := fSource.Text; // get search target
  tmSearch.Enabled := fSource.Text <> ''; // start countdouwn
  SetTimerInterval(GMVSearchDelay);
  GetParentForm(Self).Perform(CM_PTSEARCHKBMODE, 0, 0); //AAN 07/18/02
  SelectionStatus := ssInProgress;
  SetInfo;
end;

function TfrmGMV_PatientSelector.UpdateListView(aSource:TStrings;lvItems:TListItems;
  iCaption,iSSN:Integer; iSubItems: array of Integer;aMode:Integer):Integer;
var
  b: Boolean;
  s:String;
  ii,jj,
  iFound: Integer;
const
  Delim = '^';

  procedure setNameWidth(aName:String);
  var
    lv: TListView;
    j: Integer;
  begin
    if lvItems.Owner is TListView then
      begin
        lv := TListView(lvItems.Owner);
        for j := 0 to lv.Columns.Count - 1 do
          begin
            if lv.Column[j].Caption <> 'Name' then
              continue;
            if lv.Columns[j].Width < lv.Canvas.TextWidth(aName)+8 then
              lv.Columns[j].Width := lv.Canvas.TextWidth(aName)+8;
          end;
      end;
  end;

begin
  iFound := 0;
  lvItems.BeginUpdate;
  b := bIgnorePtChange; // zzzzzzandria 2008-03-07
  bIgnorePtChange := True; // zzzzzzandria 2008-03-07
  for jj := 0 to aSource.Count - 1 do
    begin
      s := aSource[jj];
      if pos('-1',s)= 1 then Continue;
      with lvItems.Add do
        begin
          Caption := Piece(s,Delim,iCaption);
          setNameWidth(Caption);
          SubItems.Add(FormatSSN(Piece(s, Delim, iSSN)));
          for ii := Low(iSubItems) to High(iSubItems) do
            SubItems.Add(Piece(s, Delim, iSubItems[ii]));
          case aMode of
            0: Data := TGMV_FileEntry.CreateFromRPC('2;' + s);// Nursing Unit
            1: Data := TGMV_FileEntry.CreateFromRPC('2;' + s);// PtWard
            2: Data := TGMV_FileEntry.CreateFromRPC('2;' + Piece(s, '^', 2) + '^' + Piece(s, '^', 1)); // Team
            3: Data := TGMV_FileEntry.CreateFromRPC('2;' + s);// Clinic
            4: Data := TGMV_FileEntry.CreateFromRPC(s);// Patients
          end;
          inc(iFound);
        end;
    end;
  lvItems.EndUpdate;
  Result := iFound;
  bIgnorePtChange := b; // zzzzzzandria 2008-03-07
end;

procedure TfrmGMV_PatientSelector.ClearListView(aLV: TListView);
var
  i: integer;
  b: Boolean;

begin
  eventAdd('Clean List View',aLV.Name);
  aLV.Items.BeginUpdate;
  b := bIgnorePtChange; // zzzzzzandria 2008-03-07
  bIgnorePtChange := True; // zzzzzzandria 2008-03-07
  for i := 0 to aLV.Items.Count - 1 do
    if aLV.Items[i].Data <> nil then
      begin
        TGMV_FileEntry(aLV.Items[i].Data).Free;
        aLV.Items[i].Data := nil;
      end;
  aLV.Items.Clear;
  aLV.Items.EndUpdate;
  bIgnorePtChange := b; // zzzzzzandria 2008-03-07

  SetCurrentPatient;

  GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// lbUnitsClick, DblClick, Enter, Exit, KeyDoun methods will be used
// for all inteface elements
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.lbUnitsClick(Sender: TObject);
begin
  try
    fSource.Text := fListBox.Items[fListBox.ItemIndex];

    if Sender <> lbClinics then // 2008-06-20
      begin
        if (fSource.Text <>'') and (pos(fSource.Text+#13,fSource.Items.Text)=0) then
          fSource.Items.Insert(0,fSource.Text);
        if fSource.Items.Count > 3 then
          fSource.Items.Delete(3);
      end;

    SetCurrentLocation;
    SelectionStatus := 'In progress';
    ClearListView(fLV);
    setInfo;
  except
  end;
end;

procedure TfrmGMV_PatientSelector.lbUnitsDblClick(Sender: TObject);
begin
  GetParentForm(Self).Perform(CM_PTSEARCHSTART, 0, 0); //AAN 07/18/02
  tmSearch.Enabled := False;
  SilentSearch;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsDblClick(Sender: TObject);
var
  s: String;
  Patient:TPatient;
begin
  SelectionStatus := '';
  with fLV do
    if Selected <> nil then
      begin
        s := TGMV_FileEntry(Selected.Data).IEN;

        Patient := SelectPatientByDFN(s);
        if Patient <> nil then
          begin
            Screen.Cursor := crHourGlass;

            fPatientID := s;
            fPatientName := Selected.Caption;
            fSelectedPatientName := fPatientName;

            if bUseLocationID then //  Wards and Clinics
              begin
                fSelectedPatientLocationName := fLocationName;
                fSelectedPatientLocationID := fLocationID;
//                fSelectedPatientLocationName := Patient.LocationName; // zzzzzzandria 060608
//                fSelectedPatientLocationID := Patient.LocationID; // zzzzzzandria 060608
              end
            else
              begin // Nursing Units, Teams, All
                fSelectedPatientLocationName := '';
                fSelectedPatientLocationID := '';
                if Patient.LocationName <> '' then
                  begin
                    fSelectedPatientLocationName := Patient.LocationName;
                    fSelectedPatientLocationID := Patient.LocationID;
                  end
              end;

            SelectionStatus := ssSelected;
            lblSelectedName.Caption := Patient.Name;
            lblPatientInfo.Caption := Patient.SSN + '  '+Patient.Age;

// No need in sending a message. OnPatSelect will be called instead
//            GetParentForm(Self).Perform(CM_PATIENTFOUND, 0, 0); //AAN 06/11/02
//            GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);

            SelectedPatientID := fPatientID; // Assignment will invoke OnPatSelect

            Screen.Cursor := crDefault;
            FreeAndNil(Patient);
          end //AAN 06/11/02
        else
          Selected := nil;
      end
    else
      begin
        fPatientID := '';
        fPatientName := '';

        fSelectedPatientName := fPatientName;
        fSelectedPatientID := fPatientID;
        fSelectedPatientLocationName := fLocationName;
        fSelectedPatientLocationID := fLocationID;
      end;
   SetInfo;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    char(VK_RETURN): if fLV.SelCount = 1 then lvUnitPatientsDblClick(Sender);
  else
  end;
end;

procedure TfrmGMV_PatientSelector.lbUnitsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: if (fListBox.ItemIndex > - 1) then lbUnitsDblClick(Sender);
  end;
end;

procedure TfrmGMV_PatientSelector.cmbUnitKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with fSource do
    case Key of
     VK_RETURN:
      if (fListBox.ItemIndex > -1) then
        begin
          Key := 0;
          lbUnitsClick(nil);
          lbUnitsDblClick(Sender);
        end;
     VK_Back:
        if (SelLength > 0) then
          begin
            fIgnore := True;
            Text := Copy(Text, 1, SelStart - 1);
            Key := 0;
            fIgnore := False;
          end;
    end;
end;

procedure TfrmGMV_PatientSelector.cmbUnitEnter(Sender: TObject);
begin
  fSource.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.cmbUnitExit(Sender: TObject);
begin
  fSource.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.lbUnitsEnter(Sender: TObject);
begin
  fListBox.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.lbUnitsExit(Sender: TObject);
begin
  fListBox.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsEnter(Sender: TObject);
begin
  fLV.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsExit(Sender: TObject);
begin
  fLV.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.cmbPeriodEnter(Sender: TObject);
begin
  cmbPeriod.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.cmbPeriodExit(Sender: TObject);
begin
  cmbPeriod.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.lvAllPatientsKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    char(VK_RETURN): if fLV.SelCount = 1 then lvUnitPatientsDblClick(Sender);
  end;
end;

procedure TfrmGMV_PatientSelector.cmbAllKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = char(VK_RETURN)
    then Search;
end;

procedure TfrmGMV_PatientSelector.SetCurrentPatient;
begin
  if (fLV.Selected <> nil)
    and Assigned(fLV.Selected.Data) // zzzzzzandria 2007-07-17
  then
    begin
      try
        fPatientID := TGMV_FileEntry(fLV.Selected.Data).IEN;
        fPatientName := fLV.Selected.Caption;
      except
        fPatientID := '';
        fPatientName := '';
      end;
    end
  else
    begin
      fPatientID := '';
      fPatientName := '';
    end;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  f: TCustomForm;
begin
//  if bIgnorePtChange then Exit; // zzzzzzandria 2008-03-07
  SetCurrentPatient;
  SelectionStatus := ssInProgress;
//  setCurrentList; -- commented 2008-02-27 zzzzzzandria
// zzzzzzandria 2008-02-27 ----------------------------------------------- begin
  if (FocusedPatientID =SelectedPatientID) and
    (FocusedPatientID <> '') then
    begin
      fPatientLocationID := fSelectedPatientLocationID;
      fPatientLocationName := fSelectedPatientLocationName;
    end
  else
    begin
        if (Sender = lvTeamPatients) or (Sender = lvAllPatients) then
          begin
            fPatientLocationID := '';
            fPatientLocationName := '';
          end
        else
          begin
            fPatientLocationID := fLocationID;
            fPatientLocationName := fLocationName;
          end;
    end;

  eventAdd(
    'Focused Patient changed',
    '---------------------------'+#13#10+
    'Item:..................... '+ Item.Caption+#13#10+
    'Selected Pt ID:........... '+SelectedPatientID + #13#10+
    'Focused Pt ID:............ '+FocusedPatientID + #13#10+
    'Selected Pt Location ID:.. '+fSelectedPatientLocationID + #13#10+
    'Selected Pt Location Name: '+fSelectedPatientLocationName + #13#10+
    'Pt Location ID:........... '+fLocationID + #13#10+
    'Pt Location Name:......... '+fLocationName);
  // zzzzzzandria 2008-02-27 ------------------------------------------------- end
  setInfo;
//  if not bIgnore then // zzzzzzandria 2008-03-07
  f := GetParentForm(Self);
  if Assigned(f) then
    f.Perform(CM_PTLISTCHANGED, fLV.Items.Count, 0);
end;

procedure TfrmGMV_PatientSelector.SetCurrentLocation;
begin
// zzzzzzandria 2007-07-12 ----------------------------------------------- begin
  fLocationID := '';
  fLocationCaption := '';
  fLocationName := '';
  if Assigned(fListBox) and (fListBox.ItemIndex>-1) and Assigned(fListBox.Items.Objects[fListBox.ItemIndex]) then
// zzzzzzandria 2007-07-12 ------------------------------------------------- end
  try
    fLocationID := TGMV_FileEntry(fListBox.Items.Objects[fListBox.ItemIndex]).IEN;
    fLocationCaption := TGMV_FileEntry(fListBox.Items.Objects[fListBox.ItemIndex]).Caption;
    fLocationName := fListBox.Items[fListBox.ItemIndex];
  except
    fLocationID := '';
    fLocationCaption := '';
    fLocationName := '';
  end;

  if bUseLocationID then
    begin
      fPatientLocationName := fLocationName;
      fPatientLocationID := fLocationID;
    end
  else
    begin
      fPatientLocationName := '';
      fPatientLocationID := '';
    end;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsClick(Sender: TObject);
begin
  SelectionStatus := ssInProgress;
  SetCurrentList;
  SetInfo;
end;

function TfrmGMV_PatientSelector.getSelectCount:Integer;
begin
  Result := fLV.SelCount;
end;

procedure TfrmGMV_PatientSelector.pnlPtInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    pnlPtInfo.BevelOuter := bvLowered;
end;

procedure TfrmGMV_PatientSelector.pnlPtInfoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPtInfo.BevelOuter := bvRaised;
  if SelectionStatus = ssSelected then
    ShowPatientInfo(SelectedPatientID,'')
  else
    MessageDlg('Select Patient first.', mtInformation,[mbOk], 0);
end;

function TfrmGMV_PatientSelector.getFocusedPatientID:String;
begin
  Result := '';
  if Assigned(fLV) and (fLV.Items.Count > 0) then
  try
    if (fLV.ItemIndex> - 1) and Assigned(fLV.Items[fLV.ItemIndex].Data) then // zzzzzzandria 2007-12-16
    Result :=  TGMV_FileEntry(fLV.Items[fLV.ItemIndex].Data).IEN;
  except
  end;
end;

procedure TfrmGMV_PatientSelector.setPatientLocationIDByFirstSelectedPatient; // zzzzzzandria 2008-02-28
var
  s: String;
begin
  s := getHospitalLocationByID(FocusedPatientID);
  if s = '0' then
    fPatientLocationID := ''
  else
    fPatientLocationID := s;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.sbClinicsScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  case ScrollCode of
    scLineUp:   SendMessage(lbClinics.Handle, WM_KEYDOWN, VK_UP, 1);
    scLineDown: SendMessage(lbClinics.Handle, WM_KEYDOWN, VK_DOWN, 1);
  end;
end;

procedure TfrmGMV_PatientSelector.UpdateScrollBar;
begin
  sbClinics.Min := 0;
  if GMVClinics.Entries.Count > 0 then
    sbClinics.Max := GMVClinics.Entries.Count - 1
  else
    sbClinics.Max := 0;
  sbClinics.enabled := sbClinics.Max > 0;
end;

procedure TfrmGMV_PatientSelector.sbClinicsChange(Sender: TObject);
begin
  if not lbClinics.Focused then
    lbClinics.SetFocus;
  lbClinics.ItemIndex := sbClinics.Position;
end;

function TfrmGMV_PatientSelector.LookupClinicInTheList(aTarget:String):integer;
var
  i: integer;
  LookFor: string;
begin
  Result := -1;
  if fListBox <> nil then
    begin
      ClearListView(fLV);
      if aTarget <> '' then
        begin
          i := 0;
          LookFor := LowerCase(aTarget);
          while (i < fListBox.Items.Count) do
            begin
              if LowerCase(Copy(fListBox.Items[i], 1, Length(LookFor))) = LookFor then
                begin
                  Result := i;
                  break;
                end
              else
                inc(i);
            end;
        end;
    end;
end;

procedure TfrmGMV_PatientSelector.cmbClinicChange(Sender: TObject);
var
  i: integer;
  iLen: Integer;
begin
  if fIgnore then Exit;
  iLen := Length(fSource.Text);
  i := LookupClinicInTheList(fSource.Text);
  if i >=0 then
    begin
      fListBox.ItemIndex := i;
      fSource.Text := fListBox.Items[i];
      fSource.SelStart := iLen;
      fSource.SelLength := iLen;
    end
  else
    fListBox.ItemIndex := -1;

  SelectionStatus := ssInProgress;
  SetInfo;
end;

function TfrmGMV_PatientSelector.UploadClinics(aTarget,aDirection:String;anOption:Word): Integer;
var
  s, sSelected,
  sTarget,
  sCount: String;
  iSelected,
  iSL, iIndex: Integer;
  fe: TGMV_FileEntry;
  SL: TStringList;
begin
  Result := 0;
  sCount := IntToStr(iLoadLimit);
  sTarget := aTarget;
  iSelected := fListBox.ItemIndex;
  if iSelected < 0 then iSelected := 0;
  sSelected := fListBox.Items[iSelected];
  SL := getClinicFileEntriesByName(aTarget,sCount,aDirection);

  if Assigned(SL) then
    begin
      Result := SL.Count;
      for iSL := 0 to SL.Count - 1 do
        begin
          s := SL[iSL];
          iIndex := GMVClinics.Entries.IndexOf(s);
          fe := TGMV_FileEntry(SL.Objects[iSL]);
          if iIndex >= 0 then
            try
              if Assigned(fe) then fe.Free;
            except
            end
          else
            begin
              if aDirection = '1' then
                begin
                  GMVClinics.Entries.AddObject(SL[iSL],fe);
                  fListBox.Items.Add(SL[iSL]);    // zzzzzzandria 2008-04-15
                end
              else
                begin
                  GMVClinics.Entries.InsertObject(0,SL[iSL],fe);
                  fListBox.Items.Insert(0,SL[iSL]); // zzzzzzandria 2008-04-15
                end;
            end;
        end;
      SL.Free;
    end;
    UpdateScrollBar;
end;

// zzzzzzandria 2008-04-11 =============================================== begin
procedure TfrmGMV_PatientSelector.FindClinics(aTarget:String);
var
  iPos: Integer;
  iCount: Integer;
  iLen: Integer;

  procedure ClearClinics;
  var
    i: Integer;
    fe: TGMV_FileEntry;
  begin
    for i := 0 to GMVClinics.Entries.Count - 1 do
      begin
        fe := TGMV_FileEntry(GMVClinics.Entries.Objects[i]);
        if Assigned(fe) then
          fe.Free;
      end;
    GMVClinics.Entries.Clear;
  end;

  procedure setPos(aPos,aLen:Integer);
  begin
    fListBox.ItemIndex := aPos;
    fSource.Text := fListBox.Items[aPos];
    fSource.SelStart := aLen;
    fSource.SelLength := Length(fSource.Text);
  end;

begin
  iLen := Length(aTarget);
  iPos := LookupClinicInTheList(aTarget);
  if iPos >= 0 then
    setPos(iPos,iLen)
  else
    begin
      ClearClinics;                            // Clean up GMVClinics list
      iCount := UploadClinics(aTarget,'1',0);  // Reload Clinics based on target
      if iCount > 0 then
        begin
          try
            lbClinics.Items.Clear;
            lbClinics.Items.Assign(GMVClinics.Entries);
            lbClinics.setFocus;
          except
          end;
          bLastClinicFound := iCount < iLoadLimit;
          // added zzzzzzandria 20080701 11:45
          iPos := LookupClinicInTheList(aTarget);
          if iPos >= 0 then
            setPos(iPos,iLen);
        end
      else
        MessageDLG('No records found'+#13#10+'Search target: "'+
          aTarget+ '"', mtWarning,[mbOK],0);
      UpdateScrollBar;
    end;
end;

procedure TfrmGMV_PatientSelector.cmbClinicKeyPress(Sender: TObject;
  var Key: Char);
var
  s: String;
begin
  if Key = char(VK_RETURN) then
    begin
      if tmSearch.enabled then
        begin // stop timer and cleanup indicator
          tmSearch.Enabled :=false;
          GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0);
        end;

      s := cmbClinic.Text;
      if cmbClinic.SelLength > 0 then
        s := copy(s,1,cmbClinic.SelStart - 1);

      FindClinics(s);
    end;
end;
// zzzzzzandria 2008-04-11 ================================================= end


procedure TfrmGMV_PatientSelector.lbClinics0KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  iTop,iBottom, iSize, iTopPos,
  i: Integer;

  function LoadMoreDown(bKB:Boolean=True): Integer;
  begin
    iBottom := fListBox.Items.Count - 1;
    i := UploadClinics(fListBox.Items[iBottom],'1',Key);
    fListBox.Items.Assign(GMVClinics.Entries); // zzzzzzandria 20080609
    Result := i;
    if bKB then // k/b request
      begin
        if i > 0 then
          fListBox.ItemIndex := iTop;
      end
    else
      if i > 0 then
        fListBox.ItemIndex := min(iBottom+iSize,fListBox.Items.Count - 1)
      else
        fListBox.ItemIndex := iBottom;
  end;

  procedure LoadMoreUp;
  begin
    i := UploadClinics(fListBox.Items[iTopPos],'-1',Key);
    fListBox.Items.Assign(GMVClinics.Entries); // zzzzzzandria 20080609
    if i > 0 then
      fListBox.ItemIndex := i - 1
    else
      fListBox.ItemIndex := 0;
  end;

begin
  if Key = VK_RETURN then
    cmbPeriod.SetFocus
  else
    begin
      iTop := fListBox.ItemIndex;
      iTopPos := fListBox.TopIndex;
      iSize := (fListBox.Height div fListBox.ItemHeight) - 1;
      iBottom := iTop + iSize;
      case Key of
        SB_TOP:
            if iTopPos = 0 then
              LoadMoreUp;
        SB_BOTTOM:
            if not bLastClinicFound then
              LoadMoreDown(False)
            else
              fListBox.ItemIndex :=
                min(iTopPos+iSize,fListBox.Items.Count - 1);
        VK_DOWN, VK_Next {VK_end,}:
            if not bLastClinicFound and (fListBox.ItemIndex = fListBox.Items.Count - 1) then
                LoadMoreDown(True);
        VK_Up, VK_Prior:
            if not bLastClinicFound and (fListBox.ItemIndex = 0) then
              LoadMoreUp;
      end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.pcMainMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{$IFDEF AANTEST} // shows extra panels on click
  if (ssCTRL in Shift) and (ssShift in Shift) then
    begin
      pnlInfo.Visible := not pnlInfo.Visible;
      lblSelected.Visible := not lblSelected.Visible;
    end;
{$ENDIF}
end;

procedure TfrmGMV_PatientSelector.tmrLoadTimer(Sender: TObject);
var
  fe: TGMV_FileEntry;
  iSL: Integer;
  iIndex: Integer;
  s: String;
  aTarget: String;
  SL: TStringList;
  b: Boolean;
  bClinic: Boolean;
begin

  tmrLoad.Enabled := False;
  aTarget := sLastClinicFound;

  b := pcMain.ActivePage = tsClinic;
  bClinic := True;
  if b then
    begin
      bClinic := pnlClinic.Enabled;
      tsClinic.Enabled := False;
      lblLoadStatus.Caption := 'Loading <'+aTarget+'>';
      lblLoadStatus.Visible := True;
      Application.ProcessMessages;
    end;

  SL := getClinicFileEntriesByName(aTarget,IntToStr(iLoadLimit),'1');
  if Assigned(SL) then
    begin
      for iSL := 0 to SL.Count - 1 do
        begin
          s := SL[iSL];
          iIndex := GMVClinics.Entries.IndexOf(s);
          if iIndex < 0 then
            begin
              fe := TGMV_FileEntry(SL.Objects[iSL]);
              GMVClinics.Entries.AddObject(SL[iSL],fe);
            end;
        end;
      bLastClinicFound := SL.Count < iLoadLimit;
      sLastClinicFound := s;
      SL.Free;
    end;

    try
      bIgnore := True;
      for iSL := 0 to GMVClinics.Entries.Count - 1 do
        begin
          iIndex := lbClinics.Items.IndexOf(GMVClinics.Entries[iSL]);
          if iIndex < 0 then
            begin
              lbClinics.Items.Add(GMVClinics.Entries[iSL]);
            end;
        end;
      bIgnore := False;
    except
    end;

  if b then
    begin
      tsClinic.Enabled := bLastClinicFound;
      pnlClinic.Enabled := bClinic;
    end;

  if bLastClinicFound then
    lblLoadStatus.Visible := false;
  tmrLoad.Enabled := not bLastClinicFound;
end;


procedure TfrmGMV_PatientSelector.lbClinics0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  bDown := True;
end;

procedure TfrmGMV_PatientSelector.lbClinics0MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  bDown := False;
end;

initialization
{$IFDEF LOADLIMITPARAM}
  iLoadLimit := 10; // test version
{$ELSE}
  iLoadLimit := 500; // production version
{$ENDIF}
end.


