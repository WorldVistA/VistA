program Vitals;

uses
  SysUtils,
  Forms,
  fGMV_UserMain in 'fGMV_UserMain.pas' {frmGMV_UserMain},
  fGMV_PtSelect in '..\VitalsPatient\fGMV_PtSelect.pas' {frmGMV_PtSelect},
  uGMV_Utils in '..\VitalsUtils\uGMV_Utils.pas',
  uGMV_FileEntry in '..\VitalsCommon\uGMV_FileEntry.pas',
  uGMV_Const in '..\VitalsUtils\uGMV_Const.pas',
  uGMV_GlobalVars in '..\VitalsUtils\uGMV_GlobalVars.pas',
  fGMV_Splash in '..\VitalsCommon\fGMV_Splash.pas' {frmGMV_Splash},
  fGMV_AboutDlg in '..\VitalsCommon\fGMV_AboutDlg.pas' {frmGMV_AboutDlg},
  uGMV_User in '..\VitalsCommon\uGMV_User.pas',
  fGMV_TimeOutManager in '..\VitalsCommon\fGMV_TimeOutManager.pas' {frmGMV_TimeOutManager},
  fGMV_PtInfo in '..\VitalsPatient\fGMV_PtInfo.pas' {fraGMV_PatientInfo},
  fGMV_ReportOptions in '..\VitalsPatient\fGMV_ReportOptions.pas' {frmGMV_ReportOptions},
  fGMV_EnteredInError in '..\VitalsDataEntry\fGMV_EnteredInError.pas' {frmGMV_EnteredInError},
  uGMV_QualifyBox in '..\VitalsDataEntry\uGMV_QualifyBox.pas',
  fGMV_UserSettings in '..\VitalsCommon\fGMV_UserSettings.pas' {frmGMV_UserSettings},
  fGMV_SelectColor in '..\VitalsCommon\fGMV_SelectColor.pas' {frmGMV_SelectColor},
  uGMV_SaveRestore in '..\VitalsCommon\uGMV_SaveRestore.pas',
  fGMV_DateRange in '..\VitalsCommon\fGMV_DateRange.pas' {frmGMV_DateRange},
  fGMV_ShowSingleVital in '..\VitalsView\fGMV_ShowSingleVital.pas' {frmGMV_ShowSingleVital},
  mGMV_InputOne2 in '..\VitalsDataEntry\mGMV_InputOne2.pas' {fraGMV_InputOne2: TFrame},
  fGMV_SupO2 in '..\VitalsDataEntry\fGMV_SupO2.pas' {frmGMV_SupO2},
  fGMV_Qualifiers in '..\VitalsDataEntry\fGMV_Qualifiers.pas' {frmGMV_Qualifiers},
  fGMV_DateTimeDLG in '..\VitalsCommon\fGMV_DateTimeDLG.pas' {fGMV_DateTime},
  mGMV_GridGraph in '..\VitalsView\mGMV_GridGraph.pas' {fraGMV_GridGraph: TFrame},
  uGMV_Patient in '..\VitalsCommon\uGMV_Patient.pas',
  fGMV_InputLite in '..\VitalsDataEntry\fGMV_InputLite.pas' {frmGMV_InputLite},
  mGMV_MDateTime in '..\VitalsCommon\mGMV_MDateTime.pas',
  fGMV_EditUserTemplates in '..\VitalsCommon\fGMV_EditUserTemplates.pas',
  mGMV_EditTemplate in '..\VitalsCommon\mGMV_EditTemplate.pas' {fraGMV_EditTemplate: TFrame},
  fGMV_AddVCQ in '..\VitalsCommon\fGMV_AddVCQ.pas' {frmGMV_AddVCQ},
  uGMV_Common in '..\VitalsUtils\uGMV_Common.pas',
  uGMV_CRC32 in '..\VitalsUtils\uGMV_CRC32.pas',
  uGMV_VersionInfo in '..\VitalsUtils\uGMV_VersionInfo.pas',
  uGMV_VitalTypes in '..\VitalsCommon\uGMV_VitalTypes.pas',
  RS232 in '..\VS_Monitors\RS232.pas',
  uVHA_ATE740X in '..\VS_Monitors\uVHA_ATE740X.pas',
  uROR_RPCBroker in '..\ROR\uROR_RPCBroker.pas',
  fROR_PCall in '..\ROR\fROR_PCall.pas' {RPCErrorForm},
  uGMV_EXEVersion in '..\VitalsUtils\uGMV_EXEVersion.pas',
  uGMV_Engine in '..\VitalsUtils\uGMV_Engine.pas',
  uGMV_Template in '..\VitalsDataEntry\uGMV_Template.pas',
  uGMV_Setup in '..\VitalsCommon\uGMV_Setup.pas',
  fGMV_PatientSelector in '..\VitalsPatient\fGMV_PatientSelector.pas' {frmGMV_PatientSelector},
  uGMV_DLLCommon in '..\VitalsUtils\uGMV_DLLCommon.pas',
  uXML in '..\VitalsUtils\uXML.pas',
  fGMV_HospitalSelector2 in '..\VitalsCommon\fGMV_HospitalSelector2.pas' {frmGMV_HospitalSelector2},
  fGMV_RPCLog in '..\VitalsCommon\fGMV_RPCLog.pas' {frmGMV_RPCLog},
  mGMV_PrinterSelector in '..\VitalsCommon\mGMV_PrinterSelector.pas' {frGMV_PrinterSelector: TFrame},
  uGMV_Monitor in '..\VS_Monitors\uGMV_Monitor.pas',
  uGMV_ScrollListBox in '..\COMPONENTS\uGMV_ScrollListBox.pas',
  fGMV_Waiting in '..\VS_Monitors\fGMV_Waiting.pas' {frmWaiting},
  fGMV_RoomSelector in '..\VITALSCOMMON\fGMV_RoomSelector.pas' {frmRoomSelector},
  mGMV_DefaultSelector in '..\VITALSCOMMON\mGMV_DefaultSelector.pas' {frDefaultSelector: TFrame},
  uGMV_RPC_Names in '..\VITALSCOMMON\uGMV_RPC_Names.pas',
  uGMV_Log in '..\VITALSCOMMON\uGMV_Log.pas';

{$R *.res}

begin
  Application.Initialize;

  GMVSplash := TfrmGMV_Splash.Create(application);
  GMVSplash.Show;
  GMVSplash.UpdateMessage('Establishing VistA Connection...');

  Application.CreateForm(TfrmGMV_UserMain, frmGMV_UserMain);
  Application.CreateForm(TfrmRoomSelector, frmRoomSelector);
  if not frmGMV_UserMain.RestoreConnection then // will create Broker
      begin
        FreeAndNil(frmGMV_UserMain);
        FreeAndNil(GMVSplash);
        Exit;
      end;
  GMVSplash.Hide;

  Application.Title := 'Vitals';
  Application.HelpFile := '';

  InitTimeOut(nil);
  UpdateTimeOutInterval(GMVUser.DTime);

  Application.BringToFront;
  Application.Run;
  ShutDownTimeOut;

  FreeAndNil(GMVDefaultTemplates);
  FreeAndNil(GMVClinics);
  FreeAndNil(GMVTeams);
  FreeAndNil(GMVWardLocations);
  FreeAndNil(GMVNursingUnits);
  FreeAndNil(GMVCats);
  FreeAndNil(GMVQuals);
  FreeAndNil(GMVTypes);

  FreeAndNil(GMVUser);
  FreeAndNil(RPCBroker);
//  FreeAndNil(GMVSplash);

end.
