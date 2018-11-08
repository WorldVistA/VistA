unit fGMV_InputLite;

{
  ================================================================================
  *
  *       Application:  Vitals
  *       Revision:     $Revision: 1 $  $Modtime: 4/17/09 2:31p $
  *       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
  *       Site:         Hines OIFO
  *
  *       Description:  Main form for entering a new series of vitals for pt.
  *
  *       Notes:
  *
  ================================================================================
  *       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY/fGMV_InputLite.pas $
  *
  * $History: fGMV_InputLite.pas $
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
  * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
  * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSDATAENTRY
  *
  * *****************  Version 2  *****************
  * User: Zzzzzzandria Date: 1/20/09    Time: 3:42p
  * Updated in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSDATAENTRY
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
  * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSDATAENTRY
  *
  * *****************  Version 7  *****************
  * User: Zzzzzzandria Date: 6/17/08    Time: 4:04p
  * Updated in $/Vitals/5.0 (Version 5.0)/VitalsGUI2007/Vitals/VITALSDATAENTRY
  *
  * *****************  Version 5  *****************
  * User: Zzzzzzandria Date: 3/03/08    Time: 4:07p
  * Updated in $/Vitals GUI 2007/Vitals/VITALSDATAENTRY
  *
  * *****************  Version 4  *****************
  * User: Zzzzzzandria Date: 2/20/08    Time: 1:42p
  * Updated in $/Vitals GUI 2007/Vitals/VITALSDATAENTRY
  * Build 5.0.23.0
  *
  * *****************  Version 3  *****************
  * User: Zzzzzzandria Date: 1/07/08    Time: 6:51p
  * Updated in $/Vitals GUI 2007/Vitals/VITALSDATAENTRY
  *
  * *****************  Version 2  *****************
  * User: Zzzzzzandria Date: 7/17/07    Time: 2:30p
  * Updated in $/Vitals GUI 2007/Vitals-5-0-18/VITALSDATAENTRY
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
  * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSDATAENTRY
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
  * Created in $/Vitals/VITALS-5-0-18/VitalsDataEntry
  * GUI v. 5.0.18 updates the default vital type IENs with the local
  * values.
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
  * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsDataEntry
  *
  * *****************  Version 4  *****************
  * User: Zzzzzzandria Date: 7/22/05    Time: 3:51p
  * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
  *
  * *****************  Version 3  *****************
  * User: Zzzzzzandria Date: 7/06/05    Time: 12:11p
  * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
  *
  * *****************  Version 2  *****************
  * User: Zzzzzzandria Date: 7/05/05    Time: 9:38a
  * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 5/24/05    Time: 3:35p
  * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
  *
  * *****************  Version 2  *****************
  * User: Zzzzzzandria Date: 4/23/04    Time: 1:21p
  * Updated in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 4/16/04    Time: 4:20p
  * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
  *
  * *****************  Version 2  *****************
  * User: Zzzzzzandria Date: 2/06/04    Time: 4:47p
  * Updated in $/VitalsLite/VitalsLiteDLL
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 1/30/04    Time: 4:30p
  * Created in $/VitalsLite/VitalsLiteDLL
  *
  * *****************  Version 1  *****************
  * User: Zzzzzzandria Date: 1/15/04    Time: 3:06p
  * Created in $/VitalsLite/VitalsLiteDLL
  * Vitals Lite DLL
  *
  ================================================================================
}
interface

uses
  Windows,
  ShellAPI,
  Messages,
  SysUtils,
  System.DateUtils, {for incMinute}
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Menus,
  StdActns,
  ActnList,
  ImgList,
  ToolWin,
  Buttons,
  Grids,
  uGMV_Template,
  uGMV_Const,
  AppEvnts,
  Math
{$IFDEF USEVSMONITOR}
    ,
  uGMV_Monitor,
  uVHA_ATE740X,
  System.Actions, System.ImageList
{$ENDIF}
    ;

type
  TfrmGMV_InputLite = class(TForm)
    pnlBottom: TPanel;
    pnlInput: TPanel;
    pnlParams: TPanel;
    pnlTemplates: TPanel;
    gbxTemplates: TGroupBox;
    imgTemplates: TImageList;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    tv: TTreeView;
    pnlTemplInfo: TPanel;
    lblTemplInfo: TLabel;
    splParams: TSplitter;
    splLastVitals: TSplitter;
    pnlButtons: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    alInputVitals: TActionList;
    acMetricStyleChange: TAction;
    acSavePreferences: TAction;
    acLoadPreferences: TAction;
    acPatientSelected: TAction;
    splPatients: TSplitter;
    pnlTools: TPanel;
    pnlPatient: TPanel;
    pnlSettings: TPanel;
    lblHospital: TLabel;
    lblDateTime: TLabel;
    acTemplateClicked: TAction;
    acSetOnPass: TAction;
    acSaveInput: TAction;
    ImageList1: TImageList;
    acCheckBoxesChange: TAction;
    PopupMenu2: TPopupMenu;
    PatienOnPass1: TMenuItem;
    acDateTimeSelector: TAction;
    acHospitalSelector: TAction;
    acTemplateSelect: TAction;
    lblHospitalCap: TLabel;
    Label2: TLabel;
    tlbInput: TToolBar;
    sbtnHospitals: TSpeedButton;
    acParamsShowHide: TAction;
    acVitalsShowHide: TAction;
    acAdjustToolbars: TAction;
    acTemplateSelector: TAction;
    ToolButton2: TToolButton;
    sbtnTemplates: TSpeedButton;
    pnlInputTemplate: TPanel;
    pnlInputTemplateHeader: TPanel;
    hc: THeaderControl;
    pnlScrollBox: TPanel;
    sbxMain: TScrollBox;
    pnlLatestVitalsBg: TPanel;
    pnlLatestVitalsHeader: TPanel;
    pnlOptions: TPanel;
    bvU: TBevel;
    ckbOnPass: TCheckBox;
    pnlCPRSMetricStyle: TPanel;
    chkCPRSSTyle: TCheckBox;
    Bevel1: TBevel;
    Panel13: TPanel;
    strgLV: TStringGrid;
    WindowClose1: TWindowClose;
    bvUnavailable: TBevel;
    lblUnavailable: TLabel;
    ckbUnavailable: TCheckBox;
    chkbCloseOnSave: TCheckBox;
    chkOneUnavailableBox: TCheckBox;
    acUnavailableBoxStatus: TAction;
    gbDateTime: TGroupBox;
    dtpDate: TDateTimePicker;
    dtpTime: TDateTimePicker;
    sbtnToolShowParams: TSpeedButton;
    pnlParamTools: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel10: TPanel;
    sbtnTemplateTree: TSpeedButton;
    Panel3: TPanel;
    sbtnShowLatestVitals: TSpeedButton;
    gbxPatients: TGroupBox;
    Panel1: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    lvSelPatients: TListView;
    alDevice: TActionList;
    acGetCASMEDDescription: TAction;
    btnSaveAndExit: TButton;
    pnlMonitor: TPanel;
    sbMonitor: TSpeedButton;
    acMonitorGetData: TAction;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    cbR: TCheckBox;
    cbU: TCheckBox;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel7: TPanel;
    cbConversionWarning: TCheckBox;
    Bevel4: TBevel;
    acPatientInfo: TAction;
    MainMenu1: TMainMenu;
    acPatientInfo1: TMenuItem;
    edPatientName: TEdit;
    edPatientInfo: TEdit;
    Hospital1: TMenuItem;
    ExpView1: TMenuItem;
    LatestV1: TMenuItem;
    DateTime1: TMenuItem;
    StatusBar: TStatusBar;
    acShowStatusBar: TAction;
    ShowHideStatusBar1: TMenuItem;
    File1: TMenuItem;
    View1: TMenuItem;
    N1: TMenuItem;
    acEnableU: TAction;
    acEnableR: TAction;
    acExit: TAction;
    N2: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    Save1: TMenuItem;
    ReadMonitor1: TMenuItem;
    N4: TMenuItem;
    acLatestVitals: TAction;
    LatestVitals1: TMenuItem;
    EnableU1: TMenuItem;
    EnableR1: TMenuItem;
    acUnitsDDL: TAction;
    UnitsasDropDownList1: TMenuItem;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dtpTimeChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tvChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure acMetricStyleChangeExecute(Sender: TObject);
    procedure ckbOnPassEnter(Sender: TObject);
    procedure ckbOnPassExit(Sender: TObject);
    procedure acSavePreferencesExecute(Sender: TObject);
    procedure acLoadPreferencesExecute(Sender: TObject);
    procedure tvExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvCollapsed(Sender: TObject; Node: TTreeNode);
    procedure pnlParamsResize(Sender: TObject);
    procedure acSetOnPassExecute(Sender: TObject);
    procedure acSaveInputExecute(Sender: TObject);
    procedure ckbOnPassClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure acDateTimeSelectorExecute(Sender: TObject);
    procedure acHospitalSelectorExecute(Sender: TObject);
    procedure pnlLatestVitalsBgResize(Sender: TObject);
    procedure strgLVDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure ckbUnavailableEnter(Sender: TObject);
    procedure ckbUnavailableExit(Sender: TObject);
    procedure ckbUnavailableClick(Sender: TObject);
    procedure acUnavailableBoxStatusExecute(Sender: TObject);
    procedure acParamsShowHideExecute(Sender: TObject);
    procedure acAdjustToolbarsExecute(Sender: TObject);
    procedure acVitalsShowHideExecute(Sender: TObject);
    procedure lvSelPatientsClick(Sender: TObject);
    procedure lvSelPatientsChanging(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
    procedure lvSelPatientsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormDestroy(Sender: TObject);
    procedure acGetCASMEDDataExecute(Sender: TObject);
    procedure acGetCASMEDDescriptionExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acMonitorGetDataExecute(Sender: TObject);
    procedure cbRClick(Sender: TObject);
    procedure hcMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure cbConversionWarningClick(Sender: TObject);
    procedure pnlPatientEnter(Sender: TObject);
    procedure pnlPatientExit(Sender: TObject);
    procedure pnlPatientClick(Sender: TObject);
    procedure acPatientInfoExecute(Sender: TObject);
    procedure edPatientNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acShowStatusBarExecute(Sender: TObject);
    procedure pnlPatientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlPatientMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure acLatestVitalsExecute(Sender: TObject);
    procedure acEnableUExecute(Sender: TObject);
    procedure acEnableRExecute(Sender: TObject);
    procedure acUnitsDDLExecute(Sender: TObject);
  private
    FTmpltRoot: TTreeNode;
    FTmpltDomainRoot: TTreeNode;
    FTmpltInstitutionRoot: TTreeNode;
    FTmpltHopsitalLocationRoot: TTreeNode;
    FTmpltNewPersonRoot: TTreeNode;
    FNewTemplate: string;
    FNewTemplateDescription: String;
    FDefaultTemplate, // AAN 08/27/2002
    FInputTemplate: TGMV_Template;
    FTemplateData: string;
    FDFN: string;
    CurrentTime: TDateTime; // AAN 07/11/2002

    fStatus: String;

    fFileVersion: String; // zzzzzzandria 050415
    fFileComments: String; // zzzzzzandria 050415

    // VS monitor support;
{$IFDEF USEVSMONITOR}
    fMonitor: TGMV_Monitor;
    sCasmedPort: String;
    bCasmedUsed: Boolean;
    Casmed: TATE740X;
{$ENDIF}
    bShowVitals, bShowParams: Boolean;
    bDataUpdated: Boolean;
    bSlave: Boolean;
    _FCurrentPtIEN: string;
    _FHospitalIEN: String;
    procedure _SetCurrentPtIEN(const Value: string);
    procedure LoadTreeView;
    procedure InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
    procedure SetVitalsList(InputTemplate: String);
    procedure ClearVitalsList;
    procedure CleanUpVitalsList;
    procedure UpdateLatestVitals(aPatient: String; bSilent: Boolean);
    procedure FocusInputField;
    function InputString: String;
    procedure SaveData(DT: TDateTime);
    procedure CMHospitalUpdate(var Message: TMessage); message CM_UPDATELOOKUP;
    procedure CMVitalChanged(var Message: TMessage); message CM_VITALCHANGED;
    procedure UpdatePatient(aPatient: String);
    procedure PatientSelected;
    procedure setStatus(aStatus: String);

    procedure setPatientInfoView(aName, anInfo: String);
    procedure updatePatientInfoView;
    function getPatientName: String;

  public
    property Status: String read fStatus write setStatus;
    property _CurrentPtIEN: String read _FCurrentPtIEN write _SetCurrentPtIEN;

    procedure InputLite(PatientDFN: String; PatientLocationIEN: string; InputTemplate: string; aDateTime: TDateTime);
  protected
    procedure CMSaveInput(var Message: TMessage); message CM_SAVEINPUT; // AAN 2003/06/06
{$IFDEF USEVSMONITOR}
    procedure MonitorProcess;
    procedure CasmedStatusIndicator(aStatus: String);
    procedure CasmedProcess;
{$ENDIF}
  end;

function VitalsInputDLG(aPatient, aLocation, aTemplate, aSignature: String; aDateTime: TDateTime; aName, anInfo: String): Integer;

// function FormatLV(aSL:TStringList;aDelim:String):TStringList;
// procedure VitalsLiteInput(aPatient, aLocation, aTemplate,aSignature:ShortString;
// function GetLatestVitals(aBroker:TRPCBroker;aPatient,aDelim:String;bSilent:Boolean):TStringList;

procedure InputVitals(PatientDFN: string; PatientLocationIEN: string; InputTemplate: string; LV: TListView; aLocationName: String);

function VitalsInputForm(aPatient, aLocation, aTemplate, aSignature: String; aDateTime: TDateTime): TfrmGMV_InputLite;

function GetLatestVitals(aPatient, aDelim: String; bSilent: Boolean): TStringList;

var
  frmGMV_InputLite: TfrmGMV_InputLite;
  // InputOne21: TfraGMV_InputOne2;

implementation

uses
  mGMV_InputOne2
{$IFNDEF DLL}
    ,
  fGMV_Splash,
  fGMV_AboutDlg
{$ENDIF}
    ,
  uGMV_Common,
  uGMV_GlobalVars,
  uGMV_User,
  uGMV_FileEntry,
  uGMV_Utils,
  uGMV_SaveRestore,
  fGMV_HospitalSelector2,
  uGMV_VitalTypes,
  uGMV_Setup,
  RS232,
  uGMV_Engine,
  uGMV_VersionInfo // zzzzzzandria 050415
    ,
  fGMV_PtInfo,
  fGMV_DateTimeDLG,
  uGMV_Log,
  system.UITypes;

const
  indMultipleInput: Integer = 19;
  indSingleCurrent: Integer = 17;
  indMultipleCurrent: Integer = 18;
  indOnPass: Integer = 5;
  indUnavail: Integer = 5;
  indSingleInput: Integer = 3;
  indBlankInput: Integer = 13;

  _WindowName = 'VitalsLite';

  stsDLL = 'DLL';
  stsDIALOG = 'DIALOG';
  stsCPRS = 'CPRS';
  stsDefault = 'DEFAULT';

{$R *.DFM}

procedure InputVitals(PatientDFN: string; PatientLocationIEN: string; InputTemplate: string; LV: TListView; aLocationName: String);
var
  InputVitalsForm: TfrmGMV_InputLite;
  LI: TListItem;
  lc: TListColumn;
  i: Integer;

  CurrentServerDateTime: TDateTime;

  sHospitalLocationID, sHospitalLocationName,

    sWindowSettings, sDateTime, sTemplate: String;

  // Have some problems with:     RestoreWindowSettings(TForm(InputVitalsForm));
  procedure RestoreWin;
  var
    RetList: TStrings;
  begin
    RetList := TStringList.Create;
    try
      with InputVitalsForm do
        begin
          sWindowSettings := InputVitalsForm.ClassName;
          sWindowSettings := getUserSettings(sWindowSettings);
          if sWindowSettings <> '' then
            begin
              Left := StrToIntDef(Piece(sWindowSettings, ';', 3), Left);
              Top := StrToIntDef(Piece(sWindowSettings, ';', 4), Top);
              Width := StrToIntDef(Piece(sWindowSettings, ';', 5), Width);
              Height := StrToIntDef(Piece(sWindowSettings, ';', 6), Height);
            end
          else
            begin
              Left := (Screen.Width - Width) div 2;
              Top := (Screen.Height - Height) div 2;
              if Top < 0 Then
                Top := 0;
              if Left < 0 Then
                Left := 0;
            end;
        end;
    except
    end;
    RetList.Free;
  end;

begin
  sHospitalLocationID := PatientLocationIEN;
  sHospitalLocationName := aLocationName;

  if sHospitalLocationID = '' then
    begin
      if not SelectLocation2(PatientDFN, sHospitalLocationID, sHospitalLocationName) then
        begin
          MessageDLG('Not enough information to start input' + #13 + 'Select hospital location to proceed', mtInformation, [mbOK], 0);
          exit;
        end;
    end;

  try
    sDateTime := getCurrentDateTime;
    CurrentServerDateTime := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime)); // 10/08/2002 AAN
  except
    on E: Exception do
      begin
        MessageDLG('Input Vitals: Unable to set client to the servers time.' + #13#10 + E.Message, mtWarning, [mbOK], 0);
        exit;
      end;
  end;

  InputVitalsForm := TfrmGMV_InputLite.Create(Application);

  with InputVitalsForm do
    try
      if (PatientDFN = '') and ((LV = nil) or (LV.Items.Count < 1)) then
        MessageDLG('Not enough information to start input' + #13 + 'Select one or more patients to proceed', mtInformation, [mbOK], 0)
      else
        begin
          if PatientDFN = '' then
            FDFN := LV.Items[0].SubItems[1]
          else
            FDFN := PatientDFN;

          dtpDate.Date := CurrentServerDateTime;
          dtpDate.MaxDate := dtpDate.Date;
          dtpTime.DateTime := CurrentServerDateTime;
          CurrentTime := dtpTime.DateTime;

          _FHospitalIEN := sHospitalLocationID;
          lblHospital.Caption := sHospitalLocationName;

          acLoadPreferencesExecute(nil);
          RestoreWin;
          LoadTreeView;
          if tv <> nil then
            begin
              // AAN 08/27/2002 Default template handling------------------ begin
              sTemplate := Piece(FNewTemplate, '|', 2);
              if sTemplate = '' then
                try
                  sTemplate := FDefaultTemplate.TemplateName;
                except
                end;
              for i := 0 to tv.Items.Count - 1 do
                begin
                  if sTemplate = tv.Items[i].Text then
                    begin
                      tv.Selected := tv.Items[i];
                      break;
                    end;
                end;
            end;

          if LV <> nil then
            begin
              lvSelPatients.SmallImages := imgTemplates;
              if lvSelPatients.Columns.Count < 3 then
                begin
                  lc := lvSelPatients.Columns.Add;
                  lc.Width := 150;
                  lc := lvSelPatients.Columns.Add;
                  lc.Width := 0;
                  lc := lvSelPatients.Columns.Add;
                  lc.Width := 0;
                  lc := lvSelPatients.Columns.Add;
                  lc.Width := 0;
                end;
              for i := 0 to LV.Items.Count - 1 do
                begin
                  LI := lvSelPatients.Items.Add;
                  LI.Caption := LV.Items[i].SubItems[0];
                  LI.SubItems.Add(LV.Items[i].SubItems[0]);
                  LI.SubItems.Add(LV.Items[i].SubItems[1]);
                  LI.SubItems.Add(LV.Items[i].SubItems[2]);
                  LI.SubItems.Add('');
                  LI.Checked := False;
                end;
              if lvSelPatients.Items.Count > 0 then
                begin
                  lvSelPatients.ItemFocused := lvSelPatients.Items[0];
                  lvSelPatientsClick(nil);
                  btnSaveAndExit.Visible := False;
                end;
              if lvSelPatients.Items.Count < 2 then
                begin
                  gbxPatients.Visible := False;
                  splPatients.Visible := False;
                end;
            end
          else
            begin
              gbxPatients.Visible := False;
              splPatients.Visible := False;
              updatePatientInfoView; // zzzzzzandria 060309
              UpdateLatestVitals(FDFN, False);
            end;

          ShowModal;
          bDataUpdated := False;

          acSavePreferencesExecute(nil);
          SaveWindowSettings(TForm(InputVitalsForm));
        end;
    finally
      Free;
    end;
end;

function VitalsInputDLG(aPatient, aLocation, aTemplate, aSignature: String; aDateTime: TDateTime; aName, anInfo: String): Integer;

var
  aTime: TDateTime;

  procedure SaveWindowSettings(Form: TForm);
  var
    s: String;
    State: TWindowState;
  begin
    State := Form.WindowState;
    Form.WindowState := wsNormal;
    Form.Visible := False;
    s := IntToStr(Screen.Width) + ';' + IntToStr(Screen.Height) + ';' + IntToStr(Form.Left) + ';' + IntToStr(Form.Top) + ';' + IntToStr(Form.Width) + ';' + IntToStr(Form.Height) + ';' + IntToStr(Integer(State));

    s := setUserSettings(_WindowName, s);
    if Piece(s, '^', 1) = '-1' then
      MessageDLG('Unable to set parameter ' + _WindowName + '.' + #13 + 'Error Message: ' + Piece(s, '^', 2), mtError, [mbOK], 0);
  end;

begin
  Result := -1;
  try
    aTime := Now;
    SetUpGlobals;
    EventStop('Setup Globals', '', aTime);

    aTime := Now;
    GMVUser.SetupSignOnParams;
    GMVUser.SetupUser;
    EventStop('Setup User', '', aTime);

    aTime := Now;
    Application.CreateForm(TfrmGMV_InputLite, frmGMV_InputLite);
    //frmGMV_InputLite := TfrmGMV_InputLite.Create(nil);
    EventStop('Create Vitals Lite form', '', aTime);

    aTime := EventStart('InputLite -- Begin');
    frmGMV_InputLite.InputLite(aPatient, aLocation, aTemplate, aDateTime);
    EventStop('InputLite -- End', '', aTime);

    if frmGMV_InputLite._FHospitalIEN <> '' then
      begin
        try
          frmGMV_InputLite.setPatientInfoView(aName, anInfo); // zzzzzzandria 060309

          PositionForm(frmGMV_InputLite);
          { Result := } frmGMV_InputLite.ShowModal;

          aTime := EventStart('Save form -- Begin');
          { These next two are commented because the form is already freed via caFree in OnClose }
          // frmGMV_InputLite.acSavePreferencesExecute(nil);
          // SaveWindowSettings(TForm(frmGMV_InputLite));
          EventStop('Save form -- End', '', aTime);
        except
          on E: Exception do
            ShowMessage('Error saving user preferences:'#13#13 + E.Message);
        end;
      end
    else
      ShowMessage('To enter Vitals select the patient location first');
    // finally { added an exception to show there is an error }
    // frmGMV_InputLite.Free
    CleanUpGlobals;
    Result := -1;
  except
    on E: Exception do
      ShowMessage('Error while calling VitalsInputDLG: ' + E.Message);
  end;
end;

function FormatLV(aSL: TStringList; aDelim: String): TStringList;
var
  AbNormal: Boolean;
  sBMI, sVital, sDate, sTime, sKey, sValue, sQual, sMetric, sEnteredBy, s, ss: string;
  i: Integer;
  SL: TStringList;
{$IFDEF PATCH_5_0_23}
  sSource: String;
{$ENDIF}
const
  // 1   5    10   15   20   25   30   35   40   45   50   55   60
  // |   |    |    |    |    |    |    |    |    |    |    |    |
  KeyWords = 'Temp. Pulse Resp. Pulse Ox B/P Ht. Wt. CVP Circ/Girth Pain Body Mass Index';
  // 1     7     13    19       28  32  36  40  44         55   60
  // AAN 06/10/02----------------------------------------------------------- Begin
  procedure CorrectList(var tSL: TStringList);
  var
    s: string;
    i, j: Integer;
  begin
    for i := 0 to tSL.Count - 1 do
      begin
        s := tSL.Strings[i];
        j := pos('(,', s);
        while j <> 0 do
          begin
            s := copy(s, 1, j) + copy(s, j + 2, Length(s) - j - 1);
            j := pos('(,', s);
          end;
        tSL.Strings[i] := s;
      end;
  end;
// AAN 06/10/02------------------------------------------------------------- End

begin
  SL := TStringList.Create;
  SL.Assign(aSL);

  CorrectList(SL);
  sBMI := '';
  for i := 0 to SL.Count - 1 do
    begin
      s := SL.Strings[i];
      if pos('Body Mass Index:', s) <> 0 then
        begin
          sVital := 'Body Mass Index';
          sEnteredBy := '';
          ss := copy(s, 17, Length(s));
          ss := TrimLeft(ss);
          sBMI := ss;
        end
      else if pos('Pulse Ox:', s) <> 0 then
        begin
          sVital := 'Pulse Ox:';
          ss := copy(s, 10, Length(s));
          ss := TrimLeft(ss);
        end
      else
        begin
          sVital := Piece(s, ' ', 1);
          ss := copy(s, pos(' ', s), Length(s));
          ss := TrimLeft(ss);
        end;

      s := Piece(sVital, ':', 1);
      if s = '' then // two records for the same date/time
        begin
          ss := TrimLeft(SL.Strings[i]);
          sValue := ss;
          sDate := '';
          sTime := '';
        end
      else
        begin
          sKey := s;
          s := copy(ss, 1, pos(' ', ss));
          if pos('(', s) = 1 then
            s := Piece(Piece(s, '(', 2), ')', 1); // to delete ()
          sDate := Piece(s, '@', 1);
          sTime := Piece(s, '@', 2);

          ss := copy(ss, pos(' ', ss), Length(ss));
          ss := TrimLeft(ss);
          sValue := ss;
        end;
      sQual := '';
      sMetric := '';
{$IFDEF PATCH_5_0_23}
      sSource := Piece(sValue, '_', 3);
{$ENDIF}
      case pos(sKey, KeyWords) of
        // 1   5    10   15   20   25   30   35   40   45   50   55   60
        // |   |    |    |    |    |    |    |    |    |    |    |    |
        // KeyWords = 'Temp. Pulse Resp. Pulse Ox B/P Ht. Wt. CVP Circ/Girth Pain Body Mass Index';
        // 1     7     13    19       28  32  36  40  44         55   60
        0:
          begin
            sDate := '';
            sTime := '';
            sVital := ' ';
            sValue := '';
            sMetric := '';
            sEnteredBy := '';
{$IFDEF PATCH_5_0_23}
            sSource := '';
{$ENDIF}
            sQual := SL.Strings[i];
          end;
        1: // Temp
          begin
            AbNormal := pos('*', sValue) > 0;

            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sMetric := Piece(sValue, '(', 2, 2);
            sMetric := Piece(sMetric, ')', 1);
            sQual := sValue;
            sValue := Piece(sValue, '(', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(sQual, ')', 2), '(', 2);
            sVital := 'Temperature';
          end;
        7: // Pulse
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sValue := Piece(sValue, ' ', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(ss, '(', 2), ')', 1);
            sMetric := '';
            sVital := 'Pulse';
          end;
        13: // Resp;
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sValue := Piece(sValue, ' ', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(ss, '(', 2), ')', 1);
            sMetric := '';
            sVital := 'Respiration';
          end;
        19: // Pulse Ox;
          begin
            // ABNormal := pos('*',sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sValue := Piece(sValue, '_', 1);
            sQual := Trim(Piece(sValue, ' ', 2, 10));
            if (pos('P', sValue) <> 1) and (pos('U', sValue) <> 1) and (pos('R', sValue) <> 1) then
              sValue := Piece(sValue, '%', 1) + '%';
            sMetric := '';
            sVital := 'Pulse Oximetry';
            if pos('*', sQual) = 1 then
              begin
                sValue := sValue + '*';
                sQual := Trim(Piece(sQual, '*', 2));
              end;
          end;
        28: // B/P
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sValue := Piece(sValue, ' ', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(ss, '(', 2), ')', 1);
            sMetric := '';
            sVital := 'Blood Pressure';
          end;
        32: // Height
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sMetric := Piece(sValue, '(', 2, 2);
            sMetric := Piece(sMetric, ')', 1);
            sQual := sValue;
            sValue := Piece(sValue, '(', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(sQual, ')', 2), '(', 2);
            sVital := 'Height';
          end;
        36: // Weight
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sMetric := Piece(sValue, '(', 2, 2);
            sMetric := Piece(sMetric, ')', 1);
            sQual := sValue;
            sValue := Piece(sValue, '(', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(sQual, ')', 2), '(', 2);
            sVital := 'Weight';
          end;
        40: // CVP
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sMetric := Piece(sValue, '(', 2, 2);
            sMetric := Piece(sMetric, ')', 1);
            sQual := sValue;
            sValue := Piece(sValue, '(', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(sQual, ')', 2), '(', 2);
            sVital := 'CVP';
          end;
        44:
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1); // AAN 05/28/2003
            sMetric := Piece(sValue, '(', 2, 2);
            sMetric := Piece(sMetric, ')', 1);
            sQual := sValue;
            sValue := Piece(sValue, '(', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sQual := Piece(Piece(sQual, ')', 2), '(', 2);
            sVital := 'Circumference/Girth';
          end;
        55: // Pain
          begin
            AbNormal := pos('*', sValue) > 0;
            sEnteredBy := Piece(sValue, '_', 2);
            sValue := Piece(sValue, '_', 1);

            if AbNormal and (pos('*', sValue) = 0) then
              sValue := sValue + '*';

            sVital := 'Pain';
          end;
        60: // Body Mass Index;
          begin
            sQual := '';
            sMetric := '';
            sDate := '';
            sTime := '';
            sValue := sBMI;
          end;
      end;

      if ((Trim(sVital) = '') and (pos('There', Trim(sQual)) = 1)) then
        begin
          SL.Strings[i] := aDelim + 'There are' + aDelim + 'no results' + aDelim + 'to report' + aDelim + aDelim;
        end
      else
        begin
          SL.Strings[i] := sDate + ' ' + sTime + aDelim + sVital + aDelim + sValue + aDelim + sMetric + aDelim + sQual + aDelim + sEnteredBy
{$IFDEF PATCH_5_0_23}
            + aDelim + sSource
{$ENDIF}
            ;

        end;
    end;
  SL.Insert(0, 'Date & Time' + aDelim + 'Vital' + aDelim + 'USS Value' + aDelim + 'Metric Value' + aDelim + 'Qualifiers' + aDelim + 'Entered by'
{$IFDEF PATCH_5_0_23}
    + aDelim + 'Data Source'
{$ENDIF}
    );

  Result := SL;

end;

function VitalsInputForm(aPatient, aLocation, aTemplate, aSignature: String; aDateTime: TDateTime): TfrmGMV_InputLite;
begin
  try
    Application.CreateForm(TfrmGMV_InputLite, frmGMV_InputLite);
    frmGMV_InputLite.Status := stsDLL;

    frmGMV_InputLite.InputLite(aPatient, aLocation, aTemplate, aDateTime);
    frmGMV_InputLite.pnlTools.Visible := False;

    frmGMV_InputLite.chkbCloseOnSave.Visible := False;
    frmGMV_InputLite.pnlButtons.Width := frmGMV_InputLite.btnSave.Width + frmGMV_InputLite.btnSave.Left + 6;
    frmGMV_InputLite.BorderStyle := bsNone;

    Result := frmGMV_InputLite;
  except
    Result := nil;
  end;
end;

function GetLatestVitals(aPatient, aDelim: String; bSilent: Boolean): TStringList;
var
  aSL: TStringList;
begin
  aSL := getLatestVitalsByDFN(aPatient, bSilent);
  Result := FormatLV(aSL, '^');
  aSL.Free;
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_InputLite.InputLite(PatientDFN: string; PatientLocationIEN: string; InputTemplate: string; aDateTime: TDateTime);
var
  i: Integer;
  sDateTime, sCaption, sTemplate: String;
  sWindowSettings: String;
  aSL: TStrings;
  aTime: TDateTime;

  // Have some problems with:     RestoreWindowSettings(TForm(InputVitalsForm));
  procedure RestoreWin;
  begin
    try
      sWindowSettings := ClassName;
      sWindowSettings := getUserSettings(_WindowName);
      if sWindowSettings <> '' then
        begin
          Left := StrToIntDef(Piece(sWindowSettings, ';', 3), Left);
          Top := StrToIntDef(Piece(sWindowSettings, ';', 4), Top);
          Width := StrToIntDef(Piece(sWindowSettings, ';', 5), Width);
          Height := StrToIntDef(Piece(sWindowSettings, ';', 6), Height);
        end;
    except
    end;
  end;

  procedure setWindowCaption;
  begin
    sCaption := ' Vitals Lite Enter';
    if fFileComments <> '' then
      sCaption := sCaption + ' (' + fFileComments + ') ';
    sCaption := sCaption + '  User: ' + GMVUser.Name;
    if GMVUser.Title <> '' then
      sCaption := sCaption + '  (' + GMVUser.Title + ')';
    sCaption := sCaption + '  Division: ' + GMVUser.Division;

    Caption := sCaption;
  end;

begin
  aSL := TStringList.Create;
  try
    gbxPatients.Visible := False;
    setWindowCaption;
    chkbCloseOnSave.Visible := True;
    btnSaveAndExit.Visible := False;
    bSlave := True;
    FDFN := PatientDFN;

    // select a location first
    if (PatientLocationIEN = '') or (PatientLocationIEN = '0') then
      acHospitalSelectorExecute(nil)
    else
      begin
        sCaption := getFileField('44', '2', PatientLocationIEN);
        if (pos('WARD', uppercase(sCaption)) <> 0) or (pos('CLINIC', uppercase(sCaption)) <> 0) then
          begin
            _FHospitalIEN := PatientLocationIEN;
            sCaption := getFileField('44', '.01', _FHospitalIEN); // zzzzzzandria 050210
            lblHospital.Caption := sCaption;
          end
        else
          _FHospitalIEN := PatientLocationIEN;
      end;
    sCaption := getFileField('44', '.01', _FHospitalIEN); // zzzzzzandria 050210
    lblHospital.Caption := sCaption;

    try
      sDateTime := getCurrentDateTime;
      dtpDate.Date := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime)); // 10/08/2002 AAN
      dtpTime.DateTime := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime));
{$IFDEF DLL}
      chkbCloseOnSave.Visible := False; // zzzzzzandria 050209
      btnSaveAndExit.Visible := True;

      // CurrentTime := Now;
      // OSE/SMH - There may be an i18n bug in the date time control as after
      // setting the MaxDate once we cannot reset it. So I moved all the sets
      // to happen only once.
      if aDateTime <> 0 then
        begin
          CurrentTime := aDateTime; // zzzzzzandra 20081008 fixing discepency between PC and VistA
          dtpDate.Date := CurrentTime;
          dtpDate.MaxDate := CurrentTime;
          dtpTime.DateTime := CurrentTime;
        end
      else
        begin
          dtpDate.MaxDate := dtpDate.Date;
          CurrentTime := dtpDate.Date;
        end;
      dtpTimeChange(nil);
{$ELSE}
      CurrentTime := dtpTime.DateTime;
      dtpDate.MaxDate := dtpDate.Date;
{$ENDIF}
    except
      on E: EConvertError do
        MessageDLG('Input Lite: Unable to set client to the servers time.' + #13#10 + E.Message, mtWarning, [mbOK], 0);

      on E: Exception do
        begin
          ShowMessage('Exception reads: ' + E.Message);
          raise
        end;
    end;

    aTime := Now;
    acLoadPreferencesExecute(nil);
    EventStop('LoadPreferences', '', aTime);
    aTime := Now;
    RestoreWin;
    EventStop('RestoreWin', '', aTime);

    aTime := Now;
    LoadTreeView;
    if tv <> nil then
      begin
        sTemplate := Piece(FNewTemplate, '|', 2);
        if sTemplate = '' then
          try
            sTemplate := FDefaultTemplate.TemplateName;
          except
          end;
        for i := 0 to tv.Items.Count - 1 do
          begin
            if sTemplate = tv.Items[i].Text then
              begin
                tv.Selected := tv.Items[i];
                break;
              end;
          end;
      end;
    EventStop('Restore template tree', '', aTime);

    aTime := Now;
    UpdatePatient(FDFN);
    EventStop('Update patient', '', aTime);
  finally
    aSL.Free;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_InputLite.UpdatePatient(aPatient: String);
begin
{$IFNDEF DLL}
  updatePatientInfoView;
{$ENDIF}
  UpdateLatestVitals(aPatient, False);
end;

procedure TfrmGMV_InputLite._SetCurrentPtIEN(const Value: string);
begin
  _FCurrentPtIEN := Value;
  FDFN := Value;
{$IFNDEF DLL}
  lblHospital.Caption := getHospitalLocationByID(_CurrentPtIEN);
{$ENDIF}
  UpdatePatient(_CurrentPtIEN);
end;

procedure TfrmGMV_InputLite.FocusInputField;
var
  i: Integer;
begin
  for i := 0 to sbxMain.ControlCount - 1 do
    if sbxMain.Controls[i] is TfraGMV_InputOne2 then
      begin
        ActiveControl := TfraGMV_InputOne2(sbxMain.Controls[i]).cbxInput;
        break;
      end;
end;

procedure TfrmGMV_InputLite.btnCancelClick(Sender: TObject);
begin
  if (InputString <> '') then
    begin
      if (MessageDLG('Some of the input fields contain data.' + #13 + #13
        // +'Do you really want to close the input window?',
        + 'Click "Yes" to exit without saving the data' + #13 + #10 + 'Click "No" to return to the input template', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
        exit
      else
        bDataUpdated := False;
    end;

  if bSlave then
    begin
      acSavePreferencesExecute(nil);
      SaveWindowSettings(Self);
    end;

  Close;
end;

procedure TfrmGMV_InputLite.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  for i := sbxMain.ComponentCount - 1 downto 0 do
    if sbxMain.Components[i] is TfraGMV_InputOne2 then
      TfraGMV_InputOne2(sbxMain.Components[i]).Free;

  if bSlave then
    begin
      // commented by zzzzzzandria on 050209
      // acSaveInputExecute(nil);
      if InputString = '' then
        Action := caFree // DLL
      else
        Action := caNone;
    end;
end;

procedure TfrmGMV_InputLite.ClearVitalsList;
var
  i: Integer;
  p: TPanel;
begin
  i := 0;
  while sbxMain.ComponentCount > 0 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        TfraGMV_InputOne2(sbxMain.Components[i]).Free
      else if sbxMain.Components[i] is TPanel then
        begin
          p := TPanel(sbxMain.Components[i]);
          p.Free;
        end
      else
        inc(i);
      if i > sbxMain.ComponentCount then
        break;
    end;
end;

procedure TfrmGMV_InputLite.SetVitalsList(InputTemplate: String);
var
  InputOne2: TfraGMV_InputOne2; // ZZZZZZBELLC
  i: Integer;
begin
  Screen.Cursor := crHourGlass;
  sbxMain.Visible := False;

  try
    ClearVitalsList;
    acSaveInput.Enabled := False;
  except
  end;

  FInputTemplate := GetTemplateObject(Piece(InputTemplate, '|', 1), Piece(InputTemplate, '|', 2));

  if FInputTemplate <> nil then
    begin
      FTemplateData := Piece(FInputTemplate.XPARValue, '|', 2);
      i := 1;
      while Piece(FTemplateData, ';', i) <> '' do
        begin
          try
            InputOne2 := TfraGMV_InputOne2.Create(sbxMain); // works in unit
            InputOne2.DFN := FDFN; // zzzzzzandria 2009 02 27
            acSaveInput.Enabled := True;

            with InputOne2 do
              begin
                ConversionWarning := False;
                cbConversionWarning.Checked := False;
                Parent := sbxMain;
                Name := 'tmplt' + IntToStr(i);
                if (i mod 2) = 0 then
                  pnlMain.Color := $00B1B1B1
                else
                 pnlMain.Color := clBtnFace;
                TemplateVital := TGMV_TemplateVital.CreateFromXPAR(Piece(FTemplateData, ';', i));
                DefaultTemplateVital := TemplateVital;
                lblNum.Caption := IntToStr(i) + '. ';
                if i < 10 then
                  begin
                    lblNum.Caption := '&' + lblNum.Caption;
                    lblNum.FocusControl := cbxInput;
                  end;
                Top := i * Height;
                TabOrder := Top;
                Align := alTop;
                try
                  ckbMetricClick(nil); // AAN 08/16/2002
                except
                end;
              end;
          except
            on E: Exception do
              MessageDialog('Error', 'Error creating input template ' + #13 + E.Message, mtError, mbYesNoCancel, 0, 0);
          end;
          inc(i);
        end;
      try
        acMetricStyleChangeExecute(nil);
      except
      end;
    end;
  sbxMain.Visible := True;
  bDataUpdated := False;
  FocusInputField;
  Screen.Cursor := crDefault;
end;

procedure TfrmGMV_InputLite.dtpTimeChange(Sender: TObject);
begin
  if trunc(dtpDate.Date) + frac(dtpTime.Time) > CurrentTime then
    dtpTime.Time := CurrentTime;
  lblDateTime.Caption := ' ' + FormatDateTime(GMV_DateFormat, dtpDate.Date) + '  ' + FormatDateTime(GMV_TimeFormat, dtpTime.Time);
end;

procedure TfrmGMV_InputLite.FormResize(Sender: TObject);
begin
  hc.Sections[3].Width := 118;
  hc.Sections[4].Width := 116;
  hc.Sections[5].Width := 78;

  hc.Sections[6].Width := hc.Width - hc.Sections[0].Width - hc.Sections[1].Width - hc.Sections[2].Width - hc.Sections[3].Width - hc.Sections[4].Width - hc.Sections[5].Width;
  strgLV.ColWidths[0] := hc.Sections[0].Width + hc.Sections[1].Width + hc.Sections[2].Width + 2;
  strgLV.ColWidths[1] := hc.Sections[3].Width - 2;
  strgLV.ColWidths[2] := hc.Sections[4].Width;
  strgLV.ColWidths[3] := hc.Sections[5].Width;
  strgLV.ColWidths[4] := hc.Sections[6].Width - 100;
  strgLV.ColWidths[5] := 100;
  if Height > Screen.Height then
    Height := Screen.Height;

  acAdjustToolbars.Execute;
end;

procedure TfrmGMV_InputLite.LoadTreeView;
var
  tmpList: TStringList;
  i: Integer;
begin
  tv.Enabled := False;
  tv.Items.BeginUpdate;
  tv.ShowRoot := True;
  with tv.Items do
    begin
      Clear;
      FTmpltRoot := nil;
      FTmpltDomainRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teDomain]);
      FTmpltInstitutionRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teInstitution]);
      FTmpltHopsitalLocationRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teHospitalLocation]);
      if GMVAllowUserTemplates then
        FTmpltNewPersonRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teNewPerson]);
    end;

  try
    tmpList := getTemplateListByID('');
    for i := 1 to tmpList.Count - 1 do
      InsertTemplate(TGMV_Template.CreateFromXPAR(tmpList[i]));
  finally
    FreeAndNil(tmpList);
  end;

  tv.Ctl3D := False;
  tv.AlphaSort;
  tv.Enabled := True;
  tv.TopItem := tv.Items.GetFirstNode;
  tv.Items.EndUpdate;
  Refresh;
end;

procedure TfrmGMV_InputLite.InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
var
  TypeRoot: TTreeNode;
  oRoot: TTreeNode;
  NewNode: TTreeNode;

  function OwnerRoot: TTreeNode;
  begin
    Result := nil;
    try
      oRoot := TypeRoot.getFirstChild;
    except
      oRoot := nil;
    end;
    while oRoot <> nil do
      begin
        if TGMV_TemplateOwner(oRoot.Data).Entity = Template.Entity then
          begin
            Result := oRoot;
            exit;
          end
        else
          oRoot := TypeRoot.GetNextChild(oRoot);
      end;

    if oRoot = nil then
      begin
        if Template.EntityType = teNewPerson then
          begin
            if GMVAllowUserTemplates then
              Result := tv.Items.AddChildObject(TypeRoot, TitleCase(Template.Owner.OwnerName), Template.Owner);
          end
        else
          Result := tv.Items.AddChildObject(TypeRoot, Template.Owner.OwnerName, Template.Owner);
      end;
  end;

begin
  case Template.EntityType of
    teUnknown:
      TypeRoot := nil;
    teDomain:
      TypeRoot := FTmpltDomainRoot;
    teInstitution:
      TypeRoot := FTmpltInstitutionRoot;
    teHospitalLocation:
      TypeRoot := FTmpltHopsitalLocationRoot;
    teNewPerson:
      TypeRoot := FTmpltNewPersonRoot;
  end;

  NewNode := tv.Items.AddChildObject(OwnerRoot, Template.TemplateName, Template);

  if (GMVDefaultTemplates <> nil) and GMVDefaultTemplates.IsDefault(Template.Entity, Template.TemplateName) then
    begin
      NewNode.ImageIndex := GMVIMAGES[iiDefaultTemplate];
      NewNode.SelectedIndex := GMVIMAGES[iiDefaultTemplate];
      // Default Template Data;
      if Template.EntityType = teDomain then
        FDefaultTemplate := Template;
    end
  else
    begin
      NewNode.ImageIndex := GMVIMAGES[iiTemplate];
      NewNode.SelectedIndex := GMVIMAGES[iiTemplate];
    end;

  if GoToTemplate then
    begin
      NewNode.Selected := True;
      tv.SetFocus;
    end;
end;

procedure TfrmGMV_InputLite.tvChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  if Node = nil then
    exit;
  try
    if Node.Level > 1 then
      begin
        FNewTemplate := TGMV_Template(Node.Data).Entity + '|' + TGMV_Template(Node.Data).TemplateName;
        FNewTemplateDescription := Piece(TGMV_Template(Node.Data).XPARValue, '|', 1);

        SetVitalsList(FNewTemplate + '^' + FNewTemplateDescription);
        pnlInputTemplateHeader.Caption := '  Vitals input template: <' + TGMV_Template(Node.Data).TemplateName + '>';
        lblTemplInfo.Caption := Piece(TGMV_Template(Node.Data).XPARValue, '|', 1);
      end
    else
      lblTemplInfo.Caption := '';
    tv.hint := lblTemplInfo.Caption;
  except
  end;
end;

procedure TfrmGMV_InputLite.CleanUpVitalsList;
var
  i: Integer;
begin
  for i := 0 to sbxMain.ComponentCount - 1 do
    if sbxMain.Components[i] is TfraGMV_InputOne2 then
      try
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.ItemIndex := -1;
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.Text := '';
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked := False;
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Checked := False;
        TfraGMV_InputOne2(sbxMain.Components[i]).TemplateVital := TfraGMV_InputOne2(sbxMain.Components[i]).DefaultTemplateVital;
        TfraGMV_InputOne2(sbxMain.Components[i]).SetMetricStyle(chkCPRSSTyle.Checked);
        // AAN 2003/09/17
        TfraGMV_InputOne2(sbxMain.Components[i]).ckbMetricClick(nil);
        TfraGMV_InputOne2(sbxMain.Components[i]).ClearPO2FlowRateAndPercentage;
      except
      end;
  ckbOnPass.Checked := False; // zzzzzzandria 050429
  ckbUnavailable.Checked := False; // zzzzzzandria 050429
  bDataUpdated := False;
end;

procedure TfrmGMV_InputLite.FormActivate(Sender: TObject);
begin
  dtpTimeChange(Sender);
  acUnavailableBoxStatusExecute(Sender); // ?
  cbRClick(nil);
end;

procedure TfrmGMV_InputLite.acMetricStyleChangeExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to sbxMain.ComponentCount - 1 do
    if sbxMain.Components[i] is TfraGMV_InputOne2 then
      TfraGMV_InputOne2(sbxMain.Components[i]).SetMetricStyle(chkCPRSSTyle.Checked);

  acMetricStyleChange.Checked := acMetricStyleChange.Enabled;
  acUnitsDDL.Checked := chkCPRSSTyle.Checked;
end;

procedure TfrmGMV_InputLite.CMHospitalUpdate(var Message: TMessage);
begin
end;

procedure TfrmGMV_InputLite.ckbOnPassEnter(Sender: TObject);
begin
  bvU.Visible := True;
end;

procedure TfrmGMV_InputLite.ckbOnPassExit(Sender: TObject);
begin
  bvU.Visible := False;
end;

procedure TfrmGMV_InputLite.acSavePreferencesExecute(Sender: TObject);

  procedure saveBoolean(aSetting: TGMV_UserSetting; aValue: Boolean; aTrue, aFalse: String);
  begin
    if aValue then
      GMVUser.Setting[aSetting] := aTrue
    else
      GMVUser.Setting[aSetting] := aFalse;
  end;

begin
  if FNewTemplate <> '' then // zzzzzzandria 050209
    GMVUser.Setting[usDefaultTemplate] := FNewTemplate;

  if chkOneUnavailableBox.Checked then
    GMVUser.Setting[usOneUnavailableBox] := 'OneUnavailableBox'
  else
    GMVUser.Setting[usOneUnavailableBox] := 'ManyUnavailableBoxes';
  (*
    if chkbCloseOnSave.Checked then
    GMVUser.Setting[usCloseInputWindowAfterSave] :='CloseInputWindowAfterSave'
    else
    GMVUser.Setting[usCloseInputWindowAfterSave] :='DoNotCloseInputWindow';

    saveBoolean(usCloseInputWindowAfterSave,chkbCloseOnSave.Checked,
    'CloseInputWindowAfterSave','DoNotCloseInputWindow');
  *)
  // if chkCPRSStyle.Checked then GMVUser.Setting[usMetricStyle] :='CPRSMetricStyle'
  // else                  GMVUser.Setting[usMetricStyle] :='VitalsMetricStyle';
  saveBoolean(usMetricStyle, chkCPRSSTyle.Checked, 'CPRSMetricStyle', 'VitalsMetricStyle');

  GMVUser.Setting[usParamTreeWidth] := IntToStr(pnlParams.Width);

  // if bShowParams then   GMVUser.Setting[usTemplateTree] := 'ShowTemplates'
  // else                  GMVUser.Setting[usTemplateTree] := 'NoTemplates';
  saveBoolean(usTemplateTree, bShowParams, 'ShowTemplates', 'NoTemplates');

  GMVUser.Setting[usLastVitalsListHeight] := IntToStr(pnlLatestVitalsBg.Height);

  if bShowVitals then
    GMVUser.Setting[usLastVitals] := 'ShowLastVitals'
  else
    GMVUser.Setting[usLastVitals] := 'NoLatestVitals';

  if cbR.Checked then
    setUserSettings('RefuseStatus', 'ON')
  else
    setUserSettings('RefuseStatus', 'OFF');

  if cbU.Checked then
    setUserSettings('UnavailableStatus', 'ON')
  else
    setUserSettings('UnavailableStatus', 'OFF');

  (* commented 2008-04-23 zzzzzzandria
    if cbU.Checked then setUserSettings('ConversionWarningStatus','ON')
    else setUserSettings('ConversionWarningStatus','OFF');
  *)
end;

procedure TfrmGMV_InputLite.acLoadPreferencesExecute(Sender: TObject);
var
  s: String;
  i: Integer;
begin
  try
    FNewTemplate := GMVUser.Setting[usDefaultTemplate];
  except
    FNewTemplate := '';
  end;

  bShowVitals := not(GMVUser.Setting[usLastVitals] = 'ShowLastVitals');
  acVitalsShowHideExecute(nil);

  s := GMVUser.Setting[usLastVitalsListHeight];
  if s <> '' then
    try
      pnlLatestVitalsBg.Height := StrToInt(s);
    except
      pnlLatestVitalsBg.Height := pnlInput.Height div 4;
    end
  else
    pnlLatestVitalsBg.Height := pnlInput.Height div 4;

  bShowParams := not(GMVUser.Setting[usTemplateTree] = 'ShowTemplates');
  acParamsShowHideExecute(nil);

  s := GMVUser.Setting[usParamTreeWidth];
  if s <> '' then
    try
      i := StrToInt(s);
      pnlParams.Width := i;
    except
      pnlParams.Width := 150;
    end
  else
    pnlParams.Width := 150;

  chkCPRSSTyle.Checked := GMVUser.Setting[usMetricStyle] = 'CPRSMetricStyle';
  acMetricStyleChangeExecute(Sender);

  // chkOneUnavailableBox.Checked :=
  // GMVUser.Setting[usOneUnavailableBox] ='OneUnavailableBox';
  chkOneUnavailableBox.Checked := False; // AAN 05/21/2003

  acUnavailableBoxStatusExecute(Sender);
  { zzzzzzandria 20050209
    chkbCloseOnSave.Checked :=
    GMVUser.Setting[usCloseInputWindowAfterSave] ='CloseInputWindowAfterSave';
  }
  s := getUserSettings('RefuseStatus');
  cbR.Checked := s <> 'OFF';
  s := getUserSettings('UnavailableStatus');
  cbU.Checked := s <> 'OFF';
  { zzzzzzandria 2008-04-23 commented
    s := getUserSettings('ConversionWarningStatus');
    cbConversionWarning.Checked := s = 'ON';
  }
end;

procedure TfrmGMV_InputLite.UpdateLatestVitals(aPatient: String; bSilent: Boolean);
var
  aSL: TStringList;
  TheSL: TStringList;
  i, j: Integer;
  s: String;
begin
  aSL := getLatestVitalsByDFN(aPatient, bSilent);

  TheSL := FormatLV(aSL, '^');
  strgLV.RowCount := TheSL.Count + 1;
  strgLV.Cells[0, 0] := 'Date & Time';
  strgLV.Cells[1, 0] := 'Vital';
  strgLV.Cells[2, 0] := 'USS Value';
  strgLV.Cells[3, 0] := 'Metric Value';
  strgLV.Cells[4, 0] := 'Qualifiers';
  strgLV.Cells[5, 0] := 'Entered by';
{$IFDEF PATCH_5_0_23}
  strgLV.Cells[6, 0] := 'Data Source';
{$ENDIF}
{$IFDEF AANTEST}
  ShowMessage(aSL.Text + #13#10 + TheSL.Text); // zzzzzzandria 050429
{$ENDIF}
  for i := 1 to TheSL.Count - 1 do // first row contains headers
    begin
      s := TheSL.Strings[i];
      for j := 0 to strgLV.ColCount - 1 do
        strgLV.Cells[j, i] := Piece(s, '^', j + 1);
    end;
  TheSL.Free;

  aSL.Free;
end;

procedure TfrmGMV_InputLite.tvExpanded(Sender: TObject; Node: TTreeNode);
begin
  if Node.Level < 2 then
    Node.ImageIndex := 1;
end;

procedure TfrmGMV_InputLite.tvCollapsed(Sender: TObject; Node: TTreeNode);
begin
  if Node.Level < 2 then
    Node.ImageIndex := 0;
end;

procedure TfrmGMV_InputLite.pnlParamsResize(Sender: TObject);
begin
  pnlPatient.Width := pnlParams.Width + 5;
  acAdjustToolbars.Execute;
end;

procedure TfrmGMV_InputLite.acSetOnPassExecute(Sender: TObject);
var
  i: Integer;
begin
  if (Sender = ckbUnavailable) and ckbUnavailable.Checked and ckbOnPass.Checked then
    ckbOnPass.Checked := False
  else if ckbOnPass.Checked and ckbUnavailable.Checked then
    ckbUnavailable.Checked := False;

  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          if (ckbOnPass.Checked) or (ckbUnavailable.Checked) // AAN 12/09/2002
          then
            begin
              TfraGMV_InputOne2(sbxMain.Components[i]).DisablePanel;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := False;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := False;
            end
          else
            begin
              if TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Checked or TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked then
                TfraGMV_InputOne2(sbxMain.Components[i]).DisablePanel
              else
                TfraGMV_InputOne2(sbxMain.Components[i]).EnablePanel;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := True;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := True;
            end;
        end
    end;

  if acSetOnPass.Enabled then
    acSetOnPass.Checked := True
  else
    acSetOnPass.Checked := False;
end;

procedure TfrmGMV_InputLite.SaveData(DT: TDateTime);
var
  sPO2: String;
  i: Integer;
  s1, s2, X: String;
begin
  sPO2 := getVitalTypeIEN('PULSE OXIMETRY'); // zzzzzzandria 050715

  for i := 0 to sbxMain.ControlCount - 1 do
    begin
      if sbxMain.Controls[i] is TfraGMV_InputOne2 then
        with TfraGMV_InputOne2(sbxMain.Controls[i]) do
          begin
            X := '';
            if ckbOnPass.Checked then
              begin
                X := FloatToStr(DT) + '^' + FDFN + '^' + VitalIEN + ';Pass;' + '^' + _FHospitalIEN + '^' + GMVUser.DUZ + '*';
              end
            else if ckbUnavailable.Checked then
              begin
                X := FloatToStr(DT) + '^' + FDFN + '^' + VitalIEN + ';Unavailable;' + '^' + _FHospitalIEN + '^' + GMVUser.DUZ + '*';
              end
            else if VitalsRate <> '' then
              begin
                s1 := VitalsRate;
                (* zzzzzzandria 20071220 ==== No special treatment for sPO2 ====================
                  // AAN 2003/06/30 -- do not show qualifiers for PulseOx if there is no rate
                  if (piece(s1,';',1) = sPO2) // PulseOx ID {'21'}
                  and (piece(s1,';',3)='')  // no value for the Flow rate for PulseOx
                  // uncomment the next line if you'd like to ignore "no Flow Rate" for the Room Air
                  and (pos('ROOM AIR',uppercase(lblQualifiers.Caption))=0) // Method is not <Room Air>
                  then
                  s2 := ''
                  else
                  ============================================================================= *)
                s2 := VitalsQualifiers;

                X := FloatToStr(DT) + '^' + FDFN + '^' + s1 + '^' + _FHospitalIEN + '^' + GMVUser.DUZ + '*' + s2;
              end;

            if X <> '' then
              begin
                // CallRemoteProc(RPCBroker, 'GMV ADD VM', [x], nil,[rpcSilent,rpcNoresChk]);
                // if RPCBroker.Results.Count > 1 then
                // MessageDlg(RPCBroker.Results.Text, mtError, [mbok], 0);
                X := addVM(X);
                if X <> '' then
                  MessageDLG(X, mtError, [mbOK], 0);
              end;
          end;
    end;
{$IFDEF USEVSMONITOR}
  // CASMED support////////////////////////////////////////////////
  // zzzzzzabdria 20080929 check added to speed up cases when the device is not used
  if bCasmedUsed then
    try
      if not Assigned(Casmed) then
        Casmed := TATE740X.Create(sCasmedPort);
      Casmed.NewPatient;
      bCasmedUsed := False;
    finally
      FreeAndNil(Casmed);
    end;
{$ENDIF}  /// ///////////////////////////////////////////////////////////////////
  CleanUpVitalsList;
  UpdatePatient(FDFN);
end;

procedure TfrmGMV_InputLite.acSaveInputExecute(Sender: TObject);
const
  sLastProcessedMessage = 'The last patient in the list processed' + #13 + 'Close the input window?';
  sSelectHospital = 'Please select a valid hospital location for this patient.';
var
  aTime: TDateTime;
  sNoDataEntered: String;
  DT: TDateTime;

  procedure AssignImageIndex(anIndex: Integer);
  begin
    if lvSelPatients.ItemFocused.SubItems[3] = '' then
      begin
        lvSelPatients.ItemFocused.ImageIndex := anIndex;
        lvSelPatients.ItemFocused.SubItems[3] := IntToStr(anIndex);
      end
    else
      begin
        lvSelPatients.ItemFocused.SubItems[3] := lvSelPatients.ItemFocused.SubItems[3] + ' ' + IntToStr(anIndex);
        lvSelPatients.ItemFocused.ImageIndex := indMultipleInput;
      end;
  end;

  function CheckData(aDT: TDateTime): Boolean;
  var
    i: Integer;
  begin
    for i := 0 to sbxMain.ComponentCount - 1 do
      if not TfraGMV_InputOne2(sbxMain.Components[i]).Check(aDT) then
        break;
    Result := i = sbxMain.ComponentCount;
    if not Result then
      begin
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.SelStart := 0;
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.SelLength := Length(TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.Text);
        TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.SetFocus;
      end;
  end;

  procedure ProcessNext(ResultIndex: Integer);
  begin
    if (lvSelPatients = nil) or (lvSelPatients.Items.Count < 2) then
      begin
        if bSlave then // DLL
          begin
            if chkbCloseOnSave.Checked or (Sender = btnSaveAndExit) // added zzzzzzandria 050707 for DLL use
            then
              begin
                Close;
                Exit;      // Get out of here now, we just triggered the form Destroy with caFree
              end
            else
              UpdateLatestVitals(FDFN, True);
          end
        else
          begin
            // Do we need to close window if the list contains only one patient?
            // Yes we do
            // Do we need to have a message?
            // No we don't
            // s := LastProcessedMessage;
            // if MessageDlgS(S,mtInformation,mbOKCancel,0) = mrOK then
            if Sender = btnSaveAndExit then
              ModalResult := mrOk;
          end;
      end;

    try
      if lvSelPatients.ItemFocused.Index < 0 then
        lvSelPatients.ItemFocused := lvSelPatients.Items[0];
    except
      lvSelPatients.ItemFocused := lvSelPatients.Items[0];
    end;

    try
      if lvSelPatients.ItemFocused.Index < 0 then
        lvSelPatients.ItemFocused := lvSelPatients.Items[0];
      if lvSelPatients.ItemFocused.Index < lvSelPatients.Items.Count - 1 then
        begin
          AssignImageIndex(ResultIndex);
          lvSelPatients.ItemFocused := lvSelPatients.Items[lvSelPatients.ItemFocused.Index + 1];
          lvSelPatients.ItemFocused.ImageIndex := 1;
          lvSelPatientsClick(Sender);
          CleanUpVitalsList;
          SetVitalsList(FNewTemplate + '^' + FNewTemplateDescription); // ZZZZZZBELLC

          if not lvSelPatients.CheckBoxes then
            ckbOnPass.Checked := False;

          FocusInputField;
        end
      else
        begin
          AssignImageIndex(ResultIndex);
          lvSelPatients.Invalidate;
          // lvSelPatientsClick(Sender);// may be it is too much

          if lvSelPatients.Items.Count < 2 then
            ModalResult := mrOk
          else if MessageDLG(sLastProcessedMessage, mtInformation, mbOKCancel, 0) = mrOk then
            ModalResult := mrOk;
        end;
    except
    end;
  end;

begin
  // Check all input panels for valid values
  DT := WindowsDateTimeToFMDateTime(trunc(dtpDate.Date) + (dtpTime.DateTime - trunc(dtpTime.Date)));
  if not CheckData(DT) then
    exit;
  // Hospital location should be set before saving data -- 03/14/2003 AAN
  if (_FHospitalIEN = '') or (_FHospitalIEN = '0') then
    MessageDLG(sSelectHospital, mtWarning, [mbOK], 0)
  else
    begin
      if InputString <> '' then
        begin
          aTime := EventStart('Save Vitals -- Begin');
          SaveData(DT);
          EventStop('Save Vitals -- End', '', aTime);
          if ckbOnPass.Checked then
            ProcessNext(indOnPass)
          else
            ProcessNext(indSingleInput);
        end
      else
        begin
          sNoDataEntered := 'No data entered for patient ' + #13 + getPatientName + #13;
          case lvSelPatients.Items.Count of
            0, 1:
              begin
                if (MessageDLG(sNoDataEntered + 'Close the window?', mtInformation, [mbYes, mbNo], 0) = mrYes) then
                  if bSlave then
                    Close
                  else
                    ModalResult := mrOk;
              end;
          else
            begin
              if (MessageDLG(sNoDataEntered + 'Process next Patient?', mtInformation, [mbYes, mbNo], 0) = mrYes) then
                ProcessNext(indBlankInput);
            end;
          end;
        end;
    end;
end;

procedure TfrmGMV_InputLite.ckbOnPassClick(Sender: TObject);
begin
  acSetOnPassExecute(ckbOnPass);
  if not ckbOnPass.Checked then
    cbRClick(nil);
end;

procedure TfrmGMV_InputLite.SpeedButton2Click(Sender: TObject);
begin
  pnlOptions.Visible := not pnlOptions.Visible;
end;

procedure TfrmGMV_InputLite.acDateTimeSelectorExecute(Sender: TObject);
var
  aTime: TDateTime;
begin
  Application.CreateForm(TfGMV_DateTime, fGMV_DateTime);
  with fGMV_DateTime do
    begin
      // Enter date could not be less then a year before -- //AAN 12/12/2002
      fGMV_DateTime.mncCalendar.minDate := Now - 365; // AAN 12/12/2002
      fGMV_DateTime.mncCalendar.Date := dtpDate.Date;
      fGMV_DateTime.edtTime.Text := FormatDateTime(GMV_TimeFormat, dtpTime.Time);
      fGMV_DateTime.SetDateTimeText;

      if fGMV_DateTime.ShowModal <> mrCancel then
        begin
          CurrentTime := fGMV_DateTime.mncCalendar.MaxDate;
          aTime := trunc(fGMV_DateTime.mncCalendar.Date) + StrToTime(fGMV_DateTime.edtTime.Text);
          if dtpDate.MaxDate < aTime then
            dtpDate.MaxDate := aTime;
          dtpDate.Date := aTime;
          dtpTime.Time := trunc(aTime) + StrToTime(fGMV_DateTime.edtTime.Text);
          dtpTimeChange(Sender);
        end;
    end;
  fGMV_DateTime.Free;
end;

procedure TfrmGMV_InputLite.acHospitalSelectorExecute(Sender: TObject);
var
  sLocationID, sLocationName: String;
begin
  sLocationID := _FHospitalIEN;
  sLocationName := '';
  if SelectLocation2(FDFN, sLocationID, sLocationName) then
    begin
      _FHospitalIEN := sLocationID;
      lblHospital.Caption := sLocationName;
    end;
end;

procedure TfrmGMV_InputLite.pnlLatestVitalsBgResize(Sender: TObject);
begin
  if pnlLatestVitalsBg.Height > (pnlInput.Height div 4) * 3 then
    pnlLatestVitalsBg.Height := (pnlInput.Height div 4) * 3;
  if pnlLatestVitalsBg.Height < pnlInput.Height div 5 then
    pnlLatestVitalsBg.Height := pnlInput.Height div 5;
end;

procedure TfrmGMV_InputLite.CMVitalChanged(var Message: TMessage);
begin
  bDataUpdated := True;
end;

function TfrmGMV_InputLite.InputString: String;
var
  i: Integer;
  s: String;
begin
  s := '';
  for i := 0 to sbxMain.ControlCount - 1 do
    if sbxMain.Controls[i] is TfraGMV_InputOne2 then
      with TfraGMV_InputOne2(sbxMain.Controls[i]) do
        if ckbOnPass.Checked then
          s := s + 'OnPass'
        else
          s := s + VitalsRate;
  Result := s;
end;

procedure TfrmGMV_InputLite.strgLVDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with strgLV.canvas do
    begin
      if ARow = 0 then
        Brush.Color := clBtnFace
      else if pos('*', strgLV.Cells[2, ARow]) <> 0 then
        begin
          Font.Color := DisplayColors[GMVAbnormalText];
          // if pos(FormatDateTime('mm/dd/yy',Now),strgLV.Cells[0,ARow])<>0 then
          // Brush.Color := DisplayColors[GMVAbnormalTodayBkgd]
          // else
          Brush.Color := DisplayColors[GMVAbnormalBkgd];
        end
      else
        begin
          Font.Color := DisplayColors[GMVnormalText];
          // if pos(FormatDateTime('mm/dd/yy',Now),strgLV.Cells[0,ARow])<>0 then
          // Brush.Color := DisplayColors[GMVnormalTodayBkgd]
          // else
          Brush.Color := DisplayColors[GMVnormalBkgd];
        end;

      FillRect(Rect);
      TextRect(Rect, Rect.Left + 2, Rect.Top, strgLV.Cells[ACol, ARow]);
    end;

end;

procedure TfrmGMV_InputLite.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  bSlave := False;

  pnlMonitor.Visible := False;

  with TVersionInfo.Create(Self) do
    try
      fFileVersion := FileVersion;
      fFileComments := Comments;
    finally
      Free;
    end;

{$IFDEF USEVSMONITOR}
  fMonitor := TGMV_Monitor.Create;
  pnlMonitor.Visible := True;
  if (fMonitor <> nil) and fMonitor.Active then
    sbMonitor.Caption := 'Read Monitor' // 2009-04-15 fMonitor.Model // ReadMonitor
  else
    begin
      FreeAndNil(fMonitor);
      sCasmedPort := '';
      for i := 1 to ParamCount do // zzzzzzandria 20090112
        begin
          if InString(ParamStr(i), ['/casmed='], False) then
            begin
              sCasmedPort := Piece(ParamStr(i), '=', 2);
              break;
            end;
        end;
    end;
{$ENDIF}
{$IFDEF DLL}
  HelpContext := 3;
{$ENDIF}

end;

procedure TfrmGMV_InputLite.ckbUnavailableEnter(Sender: TObject);
begin
  bvUnavailable.Visible := True;
end;

procedure TfrmGMV_InputLite.ckbUnavailableExit(Sender: TObject);
begin
  bvUnavailable.Visible := False;
end;

procedure TfrmGMV_InputLite.ckbUnavailableClick(Sender: TObject);
begin
  acSetOnPassExecute(ckbUnavailable);
end;

procedure TfrmGMV_InputLite.acUnavailableBoxStatusExecute(Sender: TObject);

  procedure SetUStatus(aStatus: Boolean);
  var
    i: Integer;
  begin
    ckbUnavailable.Visible := aStatus;
    lblUnavailable.Visible := aStatus;
    for i := 0 to sbxMain.ComponentCount - 1 do
      begin
        if sbxMain.Components[i] is TfraGMV_InputOne2 then
          begin
            TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Visible := not aStatus;
            TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked := ckbUnavailable.Checked;
            TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := True;
          end;
      end;
    if aStatus then
      begin
        hc.Sections[2].Text := 'Refused';
      end
    else
      hc.Sections[2].Text := 'U... R...'
  end;

begin
  SetUStatus(chkOneUnavailableBox.Checked);
end;

procedure TfrmGMV_InputLite.CMSaveInput(var Message: TMessage);
begin
  acSaveInputExecute(nil);
end;

procedure TfrmGMV_InputLite.acParamsShowHideExecute(Sender: TObject);
begin
  bShowParams := not bShowParams;
  // sbtnTemplateTree.Down := bShowParams;
  sbtnToolShowParams.Down := bShowParams;

  if pnlParams.Visible and not bShowParams then
    splParams.Visible := False;
  pnlParams.Visible := bShowParams;
  if Sender <> nil then
    try
      FormResize(Sender);
    except
    end;
  if pnlParams.Visible then
    splParams.Visible := True;
  acParamsShowHide.Checked := bShowParams;
end;

procedure TfrmGMV_InputLite.acAdjustToolbarsExecute(Sender: TObject);
var
  LabelLen, PanelLen: Integer;
begin
  PanelLen := pnlTools.Width - pnlPatient.Width - pnlParamTools.Width - pnlMonitor.Width;
  LabelLen := Max((lblHospital.Width + lblHospital.Left + 4), (lblDateTime.Width + lblDateTime.Left + 4));
  if PanelLen < LabelLen then
    begin
      pnlTools.Visible := False;
      pnlTools.Visible := True;
      tlbInput.Align := alTop;
      tlbInput.Visible := True;
      Application.ProcessMessages;
    end
  else
    tlbInput.Visible := False;
  pnlParamTools.Visible := not tlbInput.Visible;
end;

procedure TfrmGMV_InputLite.acVitalsShowHideExecute(Sender: TObject);
begin
  bShowVitals := not bShowVitals;
  sbtnShowLatestVitals.Down := bShowVitals;
  if pnlLatestVitalsBg.Visible and not bShowVitals then
    splLastVitals.Visible := False;
  pnlLatestVitalsBg.Visible := bShowVitals;
  if pnlLatestVitalsBg.Visible then
    begin
      splLastVitals.Visible := True;
    end
  else
    pnlInputTemplate.Align := alClient;
  acVitalsShowHide.Checked := bShowVitals;
end;

procedure TfrmGMV_InputLite.lvSelPatientsClick(Sender: TObject);
begin
  PatientSelected;
  acSetOnPassExecute(Sender);
  cbRClick(nil); // zzzzzzandria 060223
end;

procedure TfrmGMV_InputLite.lvSelPatientsChanging(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
var
  i: Integer;
  bFlag: Boolean;
begin
  bFlag := True;
  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          bFlag := bFlag and TfraGMV_InputOne2(sbxMain.Components[i]).Valid;
          if not bFlag then
            break;
        end;
    end;
  AllowChange := bFlag;
end;

procedure TfrmGMV_InputLite.lvSelPatientsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  try
    if (Item.SubItems[1] = FDFN) and (InputString <> '') and // 2003/08/29 AAN
      bDataUpdated then
      if (MessageDLG('You are selecting another patient.' + #13 + 'Some of the input fields contain data.' + #13 + #13 + 'Save this data for the patient "' + getPatientName + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
        begin
          acSaveInputExecute(Sender);
        end
      else
        begin
          bDataUpdated := False; // 2003/08/29 AAN
        end
    else // 2003/08/29 AAN
      bDataUpdated := InputString <> ''; // 2003/08/29 AAN
  except
  end;
end;

procedure TfrmGMV_InputLite.PatientSelected;
var
  i: Integer;
  s, sPatientID: String;
begin
  for i := 0 to lvSelPatients.Items.Count - 1 do
    try
      s := lvSelPatients.Items[i].SubItems[3];
      if s = '' then
        // if lvSelPatients.Items[i].ImageIndex = 1 then
        lvSelPatients.Items[i].ImageIndex := 0
      else if pos(' ', s) <> 0 then
        lvSelPatients.Items[i].ImageIndex := indMultipleInput
      else
        // lvSelPatients.Items[i].ImageIndex := indSingleInput;
        lvSelPatients.Items[i].ImageIndex := StrToInt(s);
    except
    end;

  try
    sPatientID := lvSelPatients.ItemFocused.SubItems[1];
    if lvSelPatients.ItemFocused.SubItems[3] = '' then
      lvSelPatients.ItemFocused.ImageIndex := 1
    else if pos(' ', lvSelPatients.ItemFocused.SubItems[3]) <> 0 then
      lvSelPatients.ItemFocused.ImageIndex := indMultipleCurrent
    else
      lvSelPatients.ItemFocused.ImageIndex := indSingleCurrent;
  except
    sPatientID := '';
  end;
  if sPatientID = '' then
    exit;

  if lvSelPatients.CheckBoxes then
    ckbOnPass.Checked := lvSelPatients.ItemFocused.Checked;

  setPatientInfoView(lvSelPatients.ItemFocused.SubItems[0], lvSelPatients.ItemFocused.SubItems[2]); // zzzzzzandria 060309

  pnlLatestVitalsHeader.Caption := '  Latest Vitals for patient <' + getPatientName + '>';

  FDFN := sPatientID;

  UpdateLatestVitals(sPatientID, True);

  bDataUpdated := InputString <> '';
end;

procedure TfrmGMV_InputLite.FormDestroy(Sender: TObject);
begin
  if Status = stsDLL then
    CleanUpGlobals;
{$IFDEF USEVSMONITOR}
  if fMonitor <> nil then
    FreeAndNil(fMonitor);
  if Assigned(Casmed) then
    FreeAndNil(Casmed);
{$ENDIF}
end;

procedure TfrmGMV_InputLite.setStatus(aStatus: String);
begin
  fStatus := aStatus;
  if fStatus = stsDLL then
    begin
      SetUpGlobals;
      GMVUser.SetupSignOnParams;
      GMVUser.SetupUser;
    end;
end;

/// ///////////////////////////////////////////////////////////////// CASMED UNIT

procedure TfrmGMV_InputLite.acGetCASMEDDescriptionExecute(Sender: TObject);
begin
{$IFDEF USEVSMONITOR}
  Screen.Cursor := crHourGlass;
  if (fMonitor <> nil) and fMonitor.Active then
    begin
      ShowMessage(fMonitor.Description);
      Screen.Cursor := crDefault;
    end
  else
    begin
      // StatusBar.Visible := True; // uncomment to show the status of the instrument
      ShowMessage(getCasmedDescription(Casmed, sCasmedPort, CasmedStatusIndicator));
    end;
  Screen.Cursor := crDefault;
{$ENDIF}
end;

{$IFDEF USEVSMONITOR}

procedure TfrmGMV_InputLite.CasmedStatusIndicator(aStatus: String);
var
  sKey: String;
  i: Integer;
begin
  sKey := Piece(uppercase(aStatus), ':', 1);
  i := StatusBar.Panels.Count - 1;
  if sKey = 'MODEL' then
    i := 1;
  if sKey = 'PORT' then
    i := 2;
  if sKey = 'STATUS' then
    i := 3;

  StatusBar.Panels[i].Text := ' ' + aStatus + ' ';
  Application.ProcessMessages;
end;

procedure TfrmGMV_InputLite.CasmedProcess;
var
  i: Integer;
  anIn: TfraGMV_InputOne2;
  rr, rTemp: Real;

  sBP: String;
  sPulse: String;
  sTemp: String;
  sTempUnit: String;
  sSpO2: String;

  sCasmedError: String;
begin
  try
    // StatusBar.Visible := True; // incomment to indicate instrument status
    Screen.Cursor := crHourGlass;
    if not Assigned(Casmed) then
      Casmed := newATE740X(sCasmedPort, sCasmedError, CasmedStatusIndicator);
    Screen.Cursor := crDefault;

    bCasmedUsed := False;
    sCasmedError := errCheckStatus { errCasmedNotFound };
    if not Assigned(Casmed) then
      begin
        ShowMessage(sCasmedError);
        exit;
      end;

    if Casmed.Numerics <> 'ERROR' then
      begin
        sBP := Casmed.sBP;
        sPulse := Casmed.sPulse;
        sSpO2 := Casmed.sSpO2;
        rTemp := Casmed.fTemp; // rTemp := 33.3;
        sTemp := Casmed.sTemp; // sTemp := '33.3';
        sTempUnit := Casmed.TempUnit; // sTempUnit := 'C';
        FreeAndNil(Casmed);
        // Casmed.ClosePort;
      end
    else
      begin
        ShowMessage('Error getting data from CASMED');
        FreeAndNil(Casmed);
        // Casmed.ClosePort;
        exit;
      end;

    // zzzzzzandria 20080929 tracking use of the monitor
    bCasmedUsed := (sBP <> '') or (sPulse <> '') or (sSpO2 <> '') or (rTemp <> 0) or (sTemp <> '') or (sTempUnit <> '');

    for i := 0 to sbxMain.ComponentCount - 1 do
      begin
        if sbxMain.Components[i] is TfraGMV_InputOne2 then
          begin
            anIn := TfraGMV_InputOne2(sbxMain.Components[i]);
            if (anIn.TemplateVital.VitalName = 'TEMPERATURE') and (sTemp <> '') then
              begin
                if sTempUnit = copy(anIn.lblUnit.Caption, 2, 1) then
                  anIn.cbxInput.Text := sTemp
                else
                  begin
                    if sTempUnit = 'C' then
                      rr := ConvertCtoF(rTemp)
                    else
                      rr := ConvertFtoC(rTemp);
                    sTemp := Format('%4.1f', [rr]);
                    anIn.cbxInput.Text := sTemp
                  end;
                anIn.Check(0);
                sTemp := '';
              end;
            if (anIn.TemplateVital.VitalName = 'PULSE') and (sPulse <> '') then
              begin
                anIn.cbxInput.Text := sPulse;
                sPulse := '';
              end;
            if (anIn.TemplateVital.VitalName = 'BLOOD PRESSURE') and (sBP <> '') then
              begin
                anIn.cbxInput.Text := sBP;
                sBP := '';
              end;
            if (anIn.TemplateVital.VitalName = 'PULSE OXIMETRY') and (sSpO2 <> '') then
              begin
                anIn.cbxInput.Text := sSpO2;
                sSpO2 := '';
              end;
          end;
      end;
  except
    on E: Exception do
      begin
        ShowMessage('Getting CASMED instrument data error:' + #13#10 + E.Message);
        if Assigned(Casmed) then
          FreeAndNil(Casmed);
      end;
  end;
end;
/// ///////////////////////////////////////////////////////////// CASMED UNIT END

procedure TfrmGMV_InputLite.MonitorProcess;
var
  sBP, sBPSystolic, sBPDiastolic, sBPMean, sPulse, sSpO2, sTemp, sTempUnit: String;
  rTemp, rr: Real;

  i: Integer;
  anIn: TfraGMV_InputOne2;
begin
  if fMonitor = nil then
    exit;

  fMonitor.GetData;
  sBP := fMonitor.sBP;
  sPulse := fMonitor.sPulse;
  sSpO2 := fMonitor.sSpO2;
  sTemp := fMonitor.sTemp; // sTemp := '33.3';
  sTempUnit := fMonitor.sTempUnit; // sTempUnit := 'C';

  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          anIn := TfraGMV_InputOne2(sbxMain.Components[i]);
          if (anIn.TemplateVital.VitalName = 'TEMPERATURE') and (sTemp <> '') then
            begin
              if sTempUnit = copy(anIn.lblUnit.Caption, 2, 1) then
                anIn.cbxInput.Text := sTemp
              else
                begin
                  rTemp := StrToFloat(sTemp);
                  if sTempUnit = 'C' then
                    rr := ConvertCtoF(rTemp)
                  else
                    rr := ConvertFtoC(rTemp);
                  sTemp := Format('%4.1f', [rr]);
                  anIn.cbxInput.Text := sTemp
                end;
              anIn.Check(0);
              sTemp := '';
            end;
          if (anIn.TemplateVital.VitalName = 'PULSE') and (sPulse <> '') then
            begin
              anIn.cbxInput.Text := sPulse;
              sPulse := '';
            end;
          if (anIn.TemplateVital.VitalName = 'BLOOD PRESSURE') and (sBP <> '') then
            begin
              anIn.cbxInput.Text := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'Systolic_blood_pressure') and (sBP <> '') then
            begin
              sBPSystolic := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'Diastolic_blood_pressure') and (sBP <> '') then
            begin
              sBPDiastolic := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'Mean_arterial_pressure') and (sBP <> '') then
            begin
              sBPMean := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'PULSE OXIMETRY') and (sSpO2 <> '') then
            begin
              anIn.cbxInput.Text := sSpO2;
              sSpO2 := '';
            end;
        end;
    end;
end;
{$ENDIF}

procedure TfrmGMV_InputLite.acMonitorGetDataExecute(Sender: TObject);
begin
{$IFDEF USEVSMONITOR}
  if Assigned(fMonitor) and fMonitor.Active then
    MonitorProcess
  else
    CasmedProcess;
{$ENDIF}
end;

procedure TfrmGMV_InputLite.acGetCASMEDDataExecute(Sender: TObject);
begin
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_InputLite.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Word('Z')) and (ssCtrl in Shift) then
    acGetCASMEDDescriptionExecute(nil); // CASMED
  if Key = VK_ESCAPE then
    btnCancelClick(nil);

  if Key = VK_F1 then
    Application.HelpCommand(0, 0);

  if (Key = VK_Return) and (ActiveControl = pnlPatient) then
    acPatientInfo.Execute;
end;

procedure TfrmGMV_InputLite.cbRClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          if not ckbOnPass.Checked then
            begin
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := cbU.Checked;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := cbR.Checked;
            end;
        end
    end;
  acEnableU.Checked := cbU.Checked;
  acEnableR.Checked := cbR.Checked;
end;

procedure TfrmGMV_InputLite.hcMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  j, i: Integer;
begin
  hc.Enabled := True;
  j := 0;
  for i := 0 to hc.Sections.Count - 1 do
    begin
      j := j + hc.Sections[i].Width;
      if j > X then
        begin
          case i of
            0:
              hc.hint := 'Template Line Number';
            2:
              hc.hint := 'U - Unavailable, R - Refused';
            3:
              hc.hint := 'Vital Type';
            4:
              hc.hint := 'Vital Value';
            5:
              hc.hint := 'Vital Value Units';
            6:
              hc.hint := 'Vital Value Qualifiers';
          else
            hc.hint := hc.Sections[i].Text;
          end;
          break;
        end;
    end;
end;

procedure TfrmGMV_InputLite.cbConversionWarningClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        TfraGMV_InputOne2(sbxMain.Components[i]).ConversionWarning := cbConversionWarning.Checked;
    end;
end;

procedure TfrmGMV_InputLite.pnlPatientEnter(Sender: TObject);
begin
  pnlPatient.BevelInner := bvRaised; // zzzzzzandria 060308
end;

procedure TfrmGMV_InputLite.pnlPatientExit(Sender: TObject);
begin
  pnlPatient.BevelInner := bvNone; // zzzzzzandria 060308
end;

procedure TfrmGMV_InputLite.pnlPatientClick(Sender: TObject);
begin
  acPatientInfo.Execute;
end;

procedure TfrmGMV_InputLite.acPatientInfoExecute(Sender: TObject);
begin
  ShowPatientInfo(FDFN, 'Patient Inquiry for: ' + edPatientName.Text + '  ' + edPatientInfo.Text); // zzzzzzandria 060308
end;

procedure TfrmGMV_InputLite.setPatientInfoView(aName, anInfo: String);
begin
  edPatientName.Text := aName;
  edPatientInfo.Text := anInfo;
{$IFDEF DLL}
  Caption := 'Vitals Lite: Enter Vitals for ' + aName + ' ' + anInfo;
{$ELSE}
  Caption := 'Vitals: Enter Vitals for ' + aName + ' ' + anInfo;
{$ENDIF}
end;

function TfrmGMV_InputLite.getPatientName: String;
begin
  Result := edPatientName.Text;
end;

procedure TfrmGMV_InputLite.updatePatientInfoView;
var
  SL: TStringList;
begin
  SL := getPatientHeader(FDFN);
  setPatientInfoView(FormatPatientName(SL[1]), FormatPatientInfo(SL[1] + SL[2]));
  SL.Free;
end;

procedure TfrmGMV_InputLite.edPatientNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_Return then
    acPatientInfo.Execute;
end;

procedure TfrmGMV_InputLite.acShowStatusBarExecute(Sender: TObject);
begin
  // StatusBar.Visible := not StatusBar.Visible; // uncomment to indicate instrument status
end;

procedure TfrmGMV_InputLite.pnlPatientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPatient.BevelOuter := bvLowered;
end;

procedure TfrmGMV_InputLite.pnlPatientMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPatient.BevelOuter := bvRaised;
  acPatientInfo.Execute;
end;

procedure TfrmGMV_InputLite.acLatestVitalsExecute(Sender: TObject);
begin
  ShowPatientLatestVitals(FDFN, 'Latest Vitals for: ' + edPatientName.Text + '  ' + edPatientInfo.Text);
end;

procedure TfrmGMV_InputLite.acEnableUExecute(Sender: TObject);
begin
  cbU.Checked := not cbU.Checked;
end;

procedure TfrmGMV_InputLite.acEnableRExecute(Sender: TObject);
begin
  cbR.Checked := not cbR.Checked;
end;

procedure TfrmGMV_InputLite.acUnitsDDLExecute(Sender: TObject);
begin
  chkCPRSSTyle.Checked := not chkCPRSSTyle.Checked;
  acMetricStyleChangeExecute(Sender);
end;

end.
