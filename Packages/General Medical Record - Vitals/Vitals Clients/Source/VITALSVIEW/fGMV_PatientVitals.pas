unit fGMV_PatientVitals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mGMV_GridGraph, ExtCtrls, StdCtrls, ComCtrls
  , ImgList
  , mGMV_MDateTime, Menus
  , ShellAPI, AppEvnts, U_HelpMGR
  ;

type
  TfrmVitals = class(TForm)
    TfraGMV_GridGraph1: TfraGMV_GridGraph;
    MainMenu1: TMainMenu;
    E1: TMenuItem;
    EnterVitals1: TMenuItem;
    N1: TMenuItem;
    Allergies1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    Index1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    EnteredinError1: TMenuItem;
    PrintGraph1: TMenuItem;
    ShowHideGraphOptions1: TMenuItem;
    SelectGraphColor1: TMenuItem;
    VitalsWe1: TMenuItem;
    AppEv: TApplicationEvents;
    N4: TMenuItem;
    PatientInformation1: TMenuItem;
    VitalsReport1: TMenuItem;
    miShowRPCLog: TMenuItem;
    Grap1: TMenuItem;
    procedure TfraGMV_GridGraph1acEnterVitalsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TfraGMV_GridGraph1acEnteredInErrorExecute(Sender: TObject);
    procedure TfraGMV_GridGraph1acPatientAllergiesExecute(Sender: TObject);
    procedure TfraGMV_GridGraph1sbGraphColorClick(Sender: TObject);
    procedure TfraGMV_GridGraph1SpeedButton1Click(Sender: TObject);
    procedure TfraGMV_GridGraph1SelectGraphColor1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Index1Click(Sender: TObject);
    procedure SelectGraphColor1Click(Sender: TObject);
    procedure VitalsWe1Click(Sender: TObject);
    function AppEvHelp(Command: Word; Data: NativeInt; var CallHelp: Boolean): Boolean;
    procedure VitalsReport1Click(Sender: TObject);
    procedure Grap1Click(Sender: TObject);
  private
    { Private declarations }
    fFileVersion,
    fFileComments,
    ptName,
    ptInfo: String;
    FMDateTimeRange: TMDateTimeRange;
    fIgnoreCount: Integer;
  public
    { Public declarations }
    property FileVersion:String read fFileVersion;
    property FileComments:String read fFileComments;
    procedure AppException(Sender: TObject; E: Exception);
  protected
  end;

var
  frmVitals: TfrmVitals;

// the next function is used by CPRS ///////////////////////////////////////
function ProcessInPatientVitals(
  aDFN,
  aLocation,
  DateStart,
  DateStop,
  aSignature,
  aName,
  anInfo,
  aHospitalName:String):Integer;

////////////////////////////////////////////////////////////////////////////////

function getVitalsForm(
  aDFN,
  aLocation,
  DateStart,
  DateStop,
  aSignature,
  aName,
  anInfo,
  aHospitalName:String):TfrmVitals;


implementation

uses
   uGMV_Engine, uGMV_VersionInfo, uGMV_User, uGMV_Common, fGMV_AboutDlg,
  fGMV_PtInfo, uGMV_WindowsEvents;

var
  PrevApp: TApplication;
  PrevScreen: TScreen;

{$R *.dfm}

function getFrmVitals(aDFN, aLocation, DateStart, DateStop,aSignature,aName,anInfo,aHospitalName:String): TFrmVitals;
var
  aForm: TfrmVitals;
  aDT: TDateTime;
  sHospitalName, sVitalABB:String;

  function EditHospitalName:String;
  var
    i: Integer;
  begin
    i := pos('^',aHospitalName);
    if i > 0 then
      Result := copy(aHospitalName,1,i-1)
    else
      Result := aHospitalName;
  end;

begin
  try
    Application.CreateForm(TfrmVitals,aForm);

    aForm.TfraGMV_GridGraph1.FrameStyle := 'CPRS';
    aForm.TfraGMV_GridGraph1.UpdateGridColors1.Visible := False;

    if not aForm.TfraGMV_GridGraph1.FrameInitialized then aForm.TfraGMV_GridGraph1.SetupFrame;

    aForm.FMDateTimeRange.Start.setSWDateTime(DateStart);
    aForm.FMDateTimeRange.Stop.setSWDateTime(DateStop);

    if Trunc(aForm.FMDateTimeRange.Stop.WDate) = trunc (Now) then
      begin
        aDT := Now;
        aForm.FMDateTimeRange.Stop.WDate := aDT;
        aForm.FMDateTimeRange.Stop.WTime := aDT;
      end;
    aForm.TfraGMV_GridGraph1.MDateTimeRange := aForm.FMDateTimeRange; // property updates labels only

    aForm.TfraGMV_GridGraph1.PatientLocation := aLocation;

    aForm.TfraGMV_GridGraph1.IgnoreCount := aForm.TfraGMV_GridGraph1.IgnoreCount + 1;
    aForm.TfraGMV_GridGraph1.PatientDFN := aDFN;                   // property
    aForm.TfraGMV_GridGraph1.lbDateRange.Items.Add(aForm.TfraGMV_GridGraph1.lblDateFromTitle.Caption); //zzzzzzandria 051221
    aForm.TfraGMV_GridGraph1.lbDateRange.ItemIndex :=     aForm.TfraGMV_GridGraph1.lbDateRange.Items.Count -1;
    aForm.TfraGMV_GridGraph1.IgnoreCount := aForm.TfraGMV_GridGraph1.IgnoreCount - 1;

    aForm.TfraGMV_GridGraph1.SetGraphTitle(aName,anInfo);
    
    aForm.ptName := aName;
    aForm.ptInfo := anInfo;

//    aForm.TfraGMV_GridGraph1.lblPatientName.Caption := aName;   // vaishandria 050322
//    aForm.TfraGMV_GridGraph1.lblPatientInfo.Caption := anInfo;  // vaishandria 050322
    aForm.TfraGMV_GridGraph1.edPatientName.Text := aName;   // vaishandria 050322
    aForm.TfraGMV_GridGraph1.edPatientInfo.Text := anInfo;  // vaishandria 050322

//    aForm.Caption := 'Vitals Lite View ('+aForm.FileComments+')'; // zzzzzzandria 050415
    aForm.Caption := 'Vitals Lite: Vitals for '+aName + ' ' +anInfo;

    with aForm do
      begin
        TfraGMV_GridGraph1.RestoreUserPreferences;

        // GraphIndex as Parameter update
        // ('xx', 'T', 'P', 'R', 'BP', 'HT', 'WT', 'PN', 'PO2', 'CVP', 'CG');
        sVitalABB := piece(aHospitalName,'^',2);
        if sVitalABB <> '' then
          try
            if Uppercase(sVitalABB) = 'POX' then sVitalABB := 'PO2'; // zzzzzzandria 060228
            TfraGMV_GridGraph1.setGraphByABBR(sVitalABB);
          except
          end;
      end;

    sHospitalName := EditHospitalName;

    if sHospitalName = '' then
      begin
        try
          aForm.TfraGMV_GridGraph1.lblHospital.Caption := getFileField('44','.01',aLocation); //zzzzzzandria 050210
        except
          aForm.TfraGMV_GridGraph1.lblHospital.Caption := 'Unknown Location';
        end;
      end
    else
      aForm.TfraGMV_GridGraph1.lblHospital.Caption := sHospitalName;
  except
    on E: Exception do
      begin
        aForm := nil;
        MessageDLG('Cannot create a window'+#10#13+E.Message,mtError,[mbOK],0);
      end;
  end;

  aForm.TfraGMV_GridGraph1.UpdateFrame; // zzzzzzandria 051203
  aForm.TfraGMV_GridGraph1.scbHGraphChange(aForm.TfraGMV_GridGraph1.trbHGraph);
  Result := aForm;
end;

//==============================================================================
function ProcessInPatientVitals( aDFN, aLocation,
  DateStart, DateStop,aSignature,aName,anInfo,aHospitalName:String):Integer;
var
  Vitals: TfrmVitals;

  function getIOption(aName:String;aDefault:Integer):Integer;
  var
    ss: String;
    ii: Integer;
    begin
      try
        ss := getUserSettings(aName);
        ii := StrToIntDef(ss,aDefault);
        Result := ii;
      except
        Result := aDefault;
      end;
    end;

  procedure setIOption(aName:String;aValue: Integer);
  begin
    try
      setUserSettings(aName,IntToStr(aValue));
    except
    end;
  end;

begin
  Vitals := getFrmVitals(aDFN, aLocation, DateStart, DateStop,aSignature,aName,anInfo,aHospitalName);
  if Vitals <> nil then
    begin
{$IFDEF DLL}
      Application.OnException := Vitals.AppException;
{$ENDIF}
      Vitals.Height := getIOption('VIEW-HEIGHT',600);
      Vitals.Width := getIOption('VIEW-WIDTH',600);
      Vitals.Left := getIOption('VIEW-LEFT',600);
      Vitals.Top := getIOption('VIEW-TOP',600);
      PositionForm(Vitals);

      Application.BringToFront;   // zzzzzzandria 051107
      Application.ProcessMessages;

      Vitals.TfraGMV_GridGraph1.UpdateFrame;
      Vitals.TfraGMV_GridGraph1.scbHGraphChange(nil);

      Result := Vitals.ShowModal;

      { -- Vitals is already gone in the DLL because of caFree in OnCLose
      with Vitals do
        begin
          setIOption('VIEW-HEIGHT',Vitals.Height);
          setIOption('VIEW-WIDTH',Vitals.Width);
          setIOption('VIEW-LEFT',Vitals.Left);
          setIOption('VIEW-TOP',Vitals.Top);

          TfraGMV_GridGraph1.SaveStatus;
        end;
      }
    end
  else
    Result := -1;

end;

////////////////////////////////////////////////////////////////////////////////

function getVitalsForm(
  aDFN, aLocation,
  DateStart, DateStop,aSignature,aName,anInfo,aHospitalName:String):TfrmVitals;
begin
  Result := getFrmVitals(aDFN, aLocation, DateStart, DateStop,aSignature,aName,anInfo,aHospitalName);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfrmVitals.TfraGMV_GridGraph1acEnterVitalsExecute(Sender: TObject);
begin
  TfraGMV_GridGraph1.acEnterVitalsExecute(Sender);
end;

procedure TfrmVitals.FormCreate(Sender: TObject);
var
  s: String;
begin
  inherited;
  FMDateTimeRange := TMDateTimeRange.Create;
  fIgnoreCount := 0;

  with TVersionInfo.Create(self) do
  try
    fFileVersion := FileVersion;
    fFileComments := Comments;
  finally
    free;
  end;

  try
    s := getUserSettings('GRAPH OPTIONS VISIBLE');
    TfraGMV_GridGraph1.pnlGraphOptions.Visible := s='1';
    TfraGMV_GridGraph1.pnlGridTop.Visible := True;
  except
  end;
{$IFDEF SHOWLOG}
  miShowRPCLog.Visible := True;
{$ELSE}
  miShowRPCLog.Visible := False;
{$ENDIF}
end;

procedure TfrmVitals.FormDestroy(Sender: TObject);
begin
  FMDateTimeRange.Free;
  inherited;
end;

procedure TfrmVitals.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    try
      Close;
    except
    end;
  if Key = VK_F1 then
    begin
      Application.HelpCommand(HelpContext,0);
    end;
  if Key = VK_RETURN then
    begin
      if TfraGMV_GridGraph1.pnlPtInfo.BevelOuter = bvRaised then
          TfraGMV_GridGraph1.acPatientInfo.Execute; // zzzzzzandria 060309
    end;
end;

procedure TfrmVitals.FormClose(Sender: TObject; var Action: TCloseAction);

function getIOption(aName:String;aDefault:Integer):Integer;
  var
    ss: String;
    ii: Integer;
    begin
      try
        ss := getUserSettings(aName);
        ii := StrToIntDef(ss,aDefault);
        Result := ii;
      except
        Result := aDefault;
      end;
    end;

  procedure setIOption(aName:String;aValue: Integer);
  begin
    try
      setUserSettings(aName,IntToStr(aValue));
    except
    end;
  end;

begin
  if TfraGMV_GridGraph1.pnlGraphOptions.Visible then
    setUserSettings('GRAPH OPTIONS VISIBLE','1')
  else
    setUserSettings('GRAPH OPTIONS VISIBLE','0');

  setIOption('VIEW-HEIGHT',Height);
  setIOption('VIEW-WIDTH',Width);
  setIOption('VIEW-LEFT',Left);
  setIOption('VIEW-TOP',Top);

  TfraGMV_GridGraph1.SaveStatus;
{$IFDEF DLL}
  Action := caFree;
{$ENDIF}
end;

procedure TfrmVitals.TfraGMV_GridGraph1acEnteredInErrorExecute(Sender: TObject);
begin
  TfraGMV_GridGraph1.acEnteredInErrorExecute(Sender);
end;

procedure TfrmVitals.TfraGMV_GridGraph1acPatientAllergiesExecute(
  Sender: TObject);
begin
  TfraGMV_GridGraph1.acPatientAllergiesExecute(Sender);
end;

procedure TfrmVitals.TfraGMV_GridGraph1sbGraphColorClick(Sender: TObject);
begin
  TfraGMV_GridGraph1.sbGraphColorClick(sender);
end;

procedure TfrmVitals.TfraGMV_GridGraph1SpeedButton1Click(Sender: TObject);
begin
  TfraGMV_GridGraph1.sbGraphColorClick(Sender);

end;

procedure TfrmVitals.TfraGMV_GridGraph1SelectGraphColor1Click(
  Sender: TObject);
begin
  TfraGMV_GridGraph1.sbGraphColorClick(Sender);
end;

procedure TfrmVitals.FormResize(Sender: TObject);
var
  wd: Integer;
begin
  Inc(fIgnoreCount);
  if fIgnoreCount < 2 then
    with TfraGMV_GridGraph1 do
      begin
        wd := grdVitals.Width - grdVitals.ColWidths[0];
        wd := wd mod (grdVitals.DefaultColWidth+1);
        if wd > 1 then Self.Width := Self.Width - wd;
        pnlRight.Width := grdVitals.DefaultColWidth div 4;

        chrtVitalsResize(nil); //zzzzzzandria 060106
      end;
  dec(fIgnoreCount);
end;

procedure TfrmVitals.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmVitals.About1Click(Sender: TObject);
begin
  gmvaBOUTdlg.eXECUTE;
end;

procedure TfrmVitals.Index1Click(Sender: TObject);
begin
  Application.HelpCommand(0,0);
end;

procedure TfrmVitals.SelectGraphColor1Click(Sender: TObject);
begin
    TfraGMV_GridGraph1.sbGraphColorClick(nil);
end;

procedure TfrmVitals.VitalsWe1Click(Sender: TObject);
var
  s: String;
begin
//  ShellExecute(0, nil, PChar('http://domaindomain.ext/ClinicalSpecialties/vitals/'), nil, nil, SW_NORMAL)
  s := getWebLinkAddress;
  if s <> '' then
    ShellExecute(0, nil, PChar(S), nil, nil, SW_NORMAL)
end;

function TfrmVitals.AppEvHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
var
  s: String;
//  iHelp: Integer;
 CrRtn: Integer;
begin
  AppEv.CancelDispatch;
 // s := GetProgramFilesPath+'\Vista\Common Files\GMV_VitalsViewEnter.hlp';
  CrRtn := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
  LoadHelpFile('GMV_VitalsViewEnter.hlp');
  finally
    Screen.Cursor := CrRtn;
  end;
//  iHelp := ActiveControl.HelpContext;
//  if iHelp = 0 then iHelp := 1;

  try
//    Application.HelpSystem.ShowContextHelp(iHelp,s);
   // Application.HelpSystem.ShowTopicHelp('Introduction',Application.HelpFile);
    WinHelp( Application.Handle, PChar(Application.HelpFile), HELP_CONTEXT, 1);

    Result := True;
  except
    Result := False;
  end;

  CallHelp := False;
end;

procedure TfrmVitals.VitalsReport1Click(Sender: TObject);
begin
  TfraGMV_GridGraph1.acVitalsReportExecute(Sender);
end;

procedure TfrmVitals.Grap1Click(Sender: TObject);
begin
  TfraGMV_GridGraph1.acShowGraphReportExecute(Sender);
end;

procedure TfrmVItals.AppException(Sender: TObject; E: Exception);
begin
  {
  Noted that this simply hides various exceptions within the DLL and only logs
  them to the Windows Event Log - DRP 5/29/2013@12:49pm
  }
  WindowsLogLine('Vitals Exception'#13#10+E.Message);
end;

initialization
  PrevApp := Application;
  PrevScreen := Screen;

finalization
  Application := PrevApp;
  Screen := PrevScreen;
end.

