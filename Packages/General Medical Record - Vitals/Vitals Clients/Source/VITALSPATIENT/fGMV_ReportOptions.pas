unit fGMV_ReportOptions;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 2/25/09 2:30p $
*       Developer:    dddddddddomain.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Report selection and device setup options.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSPATIENT/fGMV_ReportOptions.pas $
*
* $History: fGMV_ReportOptions.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSPATIENT
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSPATIENT
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSPATIENT
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 6/17/08    Time: 4:04p
 * Updated in $/Vitals/5.0 (Version 5.0)/VitalsGUI2007/Vitals/VITALSPATIENT
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 3/03/08    Time: 4:07p
 * Updated in $/Vitals Source/Vitals/VITALSPATIENT
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:30a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSPATIENT
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:44p
 * Created in $/Vitals/VITALS-5-0-18/VitalsPatient
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsPatient
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 4:59p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:23p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSPATIENT
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:08p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsUser
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 5/22/03    Time: 10:14a
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Preparation To CCOW
 * MessageDLG changet to Message DLGS
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 12  *****************
 * User: Zzzzzzandria Date: 11/04/02   Time: 9:15a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Version 5.0.0.0
 *
 * *****************  Version 11  *****************
 * User: Zzzzzzandria Date: 8/02/02    Time: 4:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Weekly Backup
 * 
 * *****************  Version 10  *****************
 * User: Zzzzzzandria Date: 7/18/02    Time: 5:57p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 9  *****************
 * User: Zzzzzzandria Date: 7/12/02    Time: 5:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * GUI Version T28
 *
 * *****************  Version 8  *****************
 * User: Zzzzzzandria Date: 7/03/02    Time: 4:59p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzandria Date: 7/02/02    Time: 11:56a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 7/01/02    Time: 5:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 6/28/02    Time: 5:19p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 6/17/02    Time: 4:51p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 6/17/02    Time: 4:26p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 6/17/02    Time: 3:47p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  uGMV_Common,
  ActnList,
  Buttons, System.Actions
  ;

type
  TfrmGMV_ReportOptions = class(TForm)
    pnlBottom: TPanel;
    OKButton: TButton;
    Button2: TButton;
    pnlLeft: TPanel;
    ReportCombo: TComboBox;
    ActionList1: TActionList;
    acReportCh: TAction;
    acScopeChanged: TAction;
    acWardChanged: TAction;
    acPrintReport: TAction;
    acStartDate: TAction;
    acStopDateChanged: TAction;
    acUPdateDTPColors: TAction;
    acStartTimeChanged: TAction;
    acEndTimeChanged: TAction;
    acPrinTimeChanged: TAction;
    acPrintDateChanged: TAction;
    tmDevice: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    acSearch: TAction;
    GroupBox3: TGroupBox;
    dtpPrintDate: TDateTimePicker;
    dtpPrintTime: TDateTimePicker;
    gbDateRange: TGroupBox;
    lblStart: TLabel;
    dtpFromDate: TDateTimePicker;
    dtpFromTime: TDateTimePicker;
    lblEnd: TLabel;
    dtpToDate: TDateTimePicker;
    dtpToTime: TDateTimePicker;
    GroupBox5: TGroupBox;
    edTarget: TEdit;
    lvDevices: TListView;
    Label3: TLabel;
    edDevice: TEdit;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    WardLabel: TLabel;
    RoomLabel: TLabel;
    rbPatient: TRadioButton;
    rbAllPatients: TRadioButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    cmbWard: TComboBox;
    Panel4: TPanel;
    edRoomList: TEdit;
    btnSelect: TButton;
    GroupBox2: TGroupBox;
    gbEnd: TGroupBox;
    lblEndTime: TLabel;
    lblEndDate: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure acReportChanged(Sender: TObject);
    procedure acScopeChangedExecute(Sender: TObject);
    procedure acWardChangedExecute(Sender: TObject);
    procedure acPrintReportExecute(Sender: TObject);
    procedure acStartDateChanged(Sender: TObject);
    procedure acStopDateChangedExecute(Sender: TObject);
    procedure acUPdateDTPColorsExecute(Sender: TObject);
    procedure acStartTimeChangedExecute(Sender: TObject);
    procedure acEndTimeChangedExecute(Sender: TObject);
    procedure acPrintDateChangedExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmDeviceTimer(Sender: TObject);
    procedure edTargetChange(Sender: TObject);
    procedure edTargetKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acSearchExecute(Sender: TObject);
    procedure lvDevicesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    { Private declarations }
    fWards: TStringList;
    CurrentTime,
    MinTime,MaxTime,
    MinDate,MaxDate: TDateTime;
    procedure SetWardActive(bState: Boolean);
    procedure SetRoomActive(bState: Boolean);
    procedure PrintReport(aRoutine,aReport,aTitle:String);
    procedure ReportPr(const routine, value, Report: string);
    function getDeviceName:String;
    function getDeviceIEN:String;
  public
    { Public declarations }
    fPtIEN: string;
    PatientInfo: string;
    Margin: string;
    SearchDirection: Integer;
    property DeviceIEN:String read getDeviceIEN;
    property DeviceName:String read getDeviceName;
  end;

var
  frmGMV_ReportOptions: TfrmGMV_ReportOptions;

procedure PrintReport2(ReportNumber: integer = 0; PatientIEN: string = ''; PName: string = '');

implementation

uses uGMV_User, uGMV_Engine, fGMV_RoomSelector, system.UITypes
  ;

{$R *.DFM}

procedure PrintReport2(ReportNumber: integer = 0; PatientIEN: string = ''; PName: string = '');
begin
  with TfrmGMV_ReportOptions.Create(Application) do
    try
      if (ReportNumber > -1) and (ReportNumber < ReportCombo.Items.Count) then
        ReportCombo.ItemIndex := ReportNumber;

      PatientInfo := PName;
      rbPatient.Caption := 'Patien&t: '+Piece(PatientInfo, ' ');
      if rbPatient.Caption = 'Patient: No' then
        rbPatient.Caption := 'No Panient Selected';

      fPtIEN := PatientIEN;
      if fPtIEN = '' then
        begin
          // removing two last reports the require patient ID 2009-02-20
          ReportCombo.Items.Delete(ReportCombo.Items.Count-1);
          ReportCombo.Items.Delete(ReportCombo.Items.Count-1);

          rbPatient.Checked := False;
          rbPatient.Enabled := False;
          rbAllPatients.Checked := True;
          cmbWard.Enabled := True;
          acScopeChangedExecute(nil);
        end;

      acScopeChangedExecute(nil);
      acReportChanged(nil);

      repeat
      until ShowModal = mrCancel;
    finally
      Free;
    end;
end;

procedure TfrmGMV_ReportOptions.SetWardActive(bState: Boolean);
begin
  WardLabel.Enabled := bState;
  cmbWard.Enabled := bState;
end;

procedure TfrmGMV_ReportOptions.SetRoomActive(bState: Boolean);
begin
  RoomLabel.Enabled := bState;
  edRoomList.Enabled := bState;
  if edRoomList.Enabled then
    edRoomList.Color := clWindow
  else
    edRoomList.Color := clBtnFace;
  btnSelect.Enabled := bState;
end;

procedure TfrmGMV_ReportOptions.FormCreate(Sender: TObject);
var
  sDateTime:String;
  ServerTime: Double;
  SL: TStringList;
  i: integer;
begin
{$IFNDEF PATCH_5_0_23}
  ReportCombo.Items.Add('Vitals Signs Record');
  ReportCombo.Items.Add('B/P Plotting Chart');
  ReportCombo.Items.Add('Weight Chart');
  ReportCombo.Items.Add('POx/Respirations Chart');
  ReportCombo.Items.Add('Pain Chart');
{$ENDIF}
  ReportCombo.Items.Add('Cumulative Vitals Report');
  ReportCombo.Items.Add('Latest Vitals by location');
  ReportCombo.Items.Add('Latest Vitals for Patient');
  ReportCombo.Items.Add('Entered in Error Patient');

  SearchDirection := 1;
  Margin := '132';
  sDateTime := getCurrentDateTime;
  ServerTime := StrToFloat(sDateTime);

  dtpPrintTime.DateTime :=    FMDateTimeToWindowsDateTime(ServerTime);
  dtpPrintDate.Date :=    FMDateTimeToWindowsDateTime(ServerTime);
  dtpFromDate.DateTime := FMDateTimeToWindowsDateTime(ServerTime);
  dtpToDate.DateTime :=   FMDateTimeToWindowsDateTime(ServerTime);

  CurrentTime := dtpPrintTime.DateTime;

  MinDate := dtpFromDate.Date;
  MaxDate := dtpToDate.Date;

  dtpFromDate.MaxDate := MaxDate;
  dtpToDate.MinDate := MinDate;
  dtpToDate.MaxDate := MaxDate;
  acUpdateDtpColorsExecute(Sender);

  dtpFromTime.Time := StrToTime('00:01');
  dtpToTime.Time := StrToTime('23:59');
  MinTime := dtpFromTime.Time;
  MaxTime := dtpToTime.Time;

  dtpPrintDate.MinDate := trunc(FMDateTimeToWindowsDateTime(ServerTime));

  SL := getWardLocations('P'); // Wards with Patients Only zzzzzzandria 060926

  cmbWard.Items.Add('');
  for i := 0 to SL.Count - 1 do
    cmbWard.Items.Add(piece(SL[i],'^',2));

  fWards := TStringList.Create;
  fWards.Text := #13#10+SL.Text;

  SL.Free;
  acWardChangedExecute(Sender); //AAN 06/10/02
end;

procedure TfrmGMV_ReportOptions.acReportChanged(Sender: TObject);
{$IFDEF PATCH_5_0_23}
var
  sName: String;
{$ENDIF}

  procedure SetPeriodActive(aState:Boolean);
  begin
    lblStart.Enabled := aState;
    lblEnd.Enabled := aState;
    lblEndDate.Enabled := aState;
    lblEndTime.Enabled := aState;
    dtpFromDate.Enabled := aState;
    dtpFromTime.Enabled := aState;
    dtpToDate.Enabled := aState;
    dtpToTime.Enabled := aState;

    acUpdateDtpColorsExecute(Sender);
  end;

//0:      Vitals Signs Record     - not supported 5.0.22
//1:      B/P Plotting Chart      - not supported 5.0.22
//2:      Weight Chart            - not supported 5.0.22
//3:      POx/Respirations Chart  - not supported 5.0.22
//4:      Pain Chart              - not supported 5.0.22
//5:      Cumulative Vitals Report
//6:      Latest Vitals by location
//7:      Latest Vitals for Patient
//8:      Entered in Error Patient

  procedure setPatientControls;
  begin
    if FPTien = '' then
      begin
        MessageDlg('Report needs patient to be selected.' + #13 +
          'Select patient prior to print report', mtInformation, [mbOk], 0);
        rbAllPatients.Enabled := True;
      end
    else
      begin
        SetWardActive(False);
        rbAllPatients.Enabled := False;
        rbAllPatients.Checked := False;
        rbPatient.Checked := True;
        rbPatient.Enabled := True;
      end;
  end;

begin
{$IFDEF PATCH_5_0_23}
// zzzzzzandria 2008-02-21 =============================================== begin
  Margin := '80';
  sName := ReportCombo.Text;
  if sName = 'Cumulative Vitals Report' then
    begin
      rbPatient.Enabled := True;
      rbAllPatients.Enabled := True;
      SetWardActive(True);
      SetPeriodActive(True);

      if FPTien = '' then
        rbPatient.Enabled := False;
    end
  else if sName = 'Latest Vitals by location' then
    begin
      rbPatient.Enabled := False;
      rbAllPatients.Enabled := True;
      rbAllPatients.Checked := True;
      SetPeriodActive(False);
    end
  else if sName = 'Latest Vitals for Patient' then
    begin
      SetPeriodActive(False);
      setPatientControls;
    end
  else if sName = 'Entered in Error Patient' then
    begin
      SetPeriodActive(True);
      setPatientControls;
    end;

  cmbWard.Text := '';

  acWardChangedExecute(Sender);
  acScopeChangedExecute(Sender);
Exit;
// zzzzzzandria 2008-02-21 ================================================= end
{$ENDIF}

  Margin := '132';
  case ReportCombo.ItemIndex of
    0..6:
      begin
        SetWardActive(True); //AAN 06/10/02
        if ReportCombo.ItemIndex > 4 then  // zzzzzzandria 060123
          Margin := '80';

        if ReportCombo.ItemIndex <> 6 then
          begin
            rbPatient.Enabled := True;
            rbAllPatients.Enabled := True;
            SetWardActive(True);
            SetPeriodActive(True);
          end
        else
          begin
            rbPatient.Enabled := False;
            rbAllPatients.Enabled := True;
            rbAllPatients.Checked := True;
            SetPeriodActive(False);
          end;
        if FPTien = '' then
          rbPatient.Enabled := False;
      end;
  else
    begin
      Margin := '80';
      if ReportCombo.ItemIndex = 7 then
        SetPeriodActive(False)
      else
        SetPeriodActive(True);

      if FPTien = '' then
        begin
          MessageDlg('Report needs patient to be selected.' + #13 +
            'Select patient prior to print report', mtInformation,
            [mbOk], 0);
          ReportCombo.ItemIndex := 6;
          rbAllPatients.Enabled := True;
        end
      else
        begin
          SetWardActive(False);
          rbAllPatients.Enabled := False;
          rbAllPatients.Checked := False;
          rbPatient.Checked := True;
          rbPatient.Enabled := True;
        end;
    end;
  end;
  cmbWard.Text := '';
  acWardChangedExecute(Sender);
  acScopeChangedExecute(Sender);
end;

procedure TfrmGMV_ReportOptions.acScopeChangedExecute(Sender: TObject);
begin
  cmbWard.Enabled := not rbPatient.Checked;
  setWardActive(not rbPatient.Checked);

  if rbPatient.Checked then
    begin
      SetRoomActive(False);
      acPrintReport.Enabled := True;
    end
  else
    acPrintReport.Enabled := (cmbWard.Text <> '')
end;

procedure TfrmGMV_ReportOptions.acWardChangedExecute(Sender: TObject);
var
  RetList : TStrings;
  sWard: String;
begin
  edRoomList.Clear;
//  sWard := WardCombo.DisplayText[WardCombo.itemindex];
  sWard := cmbWard.Text;
  if sWard <> '' then
    begin
      RetList := getRoomBedByWard(sWard);
      if RetList.Count > 0 then
        begin                                                   //AAN 06/10/02
          SetRoomActive(True);                                  //AAN 06/10/02
        end                                                     //AAN 06/10/02
      else                                                      //AAN 06/10/02
        SetRoomActive(False);                                   //AAN 06/10/02
      acPrintReport.Enabled := True;
      RetList.Free;
    end
  else                                                          //AAN 06/10/02
    begin
      SetWardActive(True);                                      //AAN 06/10/02
      SetRoomActive(False);                                     //AAN 06/10/02
      acPrintReport.Enabled := False;
    end;
end;

procedure TfrmGMV_ReportOptions.acPrintReportExecute(Sender: TObject);
var
  sRoutine,sReport,sTitle: String;
begin
// zzzzzzandria 2008-02-21 =============================================== begin
//PrintER;
(* original report list
0:      Vitals Signs Record
1:      B/P Plotting Chart
2:      Weight Chart
3:      POx/Respirations Chart
4:      Pain Chart
5:      Cumulative Vitals Report
6:      Latest Vitals by location
7:      Latest Vitals for Patient
8:      Entered in Error Patient
*)

(*
  case ReportCombo.ItemIndex of
    0..4: sRoutine := 'GMV PT GRAPH';
    5: sRoutine := 'GMV CUMULATIVE REPORT';
    6: sRoutine := 'GMV LATEST VITALS BY LOCATION';
    7: sRoutine := 'GMV LATEST VITALS FOR PATIENT';
    8: sRoutine := 'GMV ENTERED IN ERROR-PATIENT';
  end;
*)
  sRoutine := ReportCombo.Text;
  if sRoutine = 'Vitals Signs Record' then
    sRoutine := 'GMV PT GRAPH'
  else if sRoutine = 'B/P Plotting Chart' then
    sRoutine := 'GMV PT GRAPH'
  else if sRoutine = 'Weight Chart' then
    sRoutine := 'GMV PT GRAPH'
  else if sRoutine = 'POx/Respirations Chart' then
    sRoutine := 'GMV PT GRAPH'
  else if sRoutine = 'Pain Chart' then
    sRoutine := 'GMV PT GRAPH'
  else if sRoutine = 'Cumulative Vitals Report' then
    sRoutine := 'GMV CUMULATIVE REPORT'
  else if sRoutine = 'Latest Vitals by location' then
    sRoutine := 'GMV LATEST VITALS BY LOCATION'
  else if sRoutine = 'Latest Vitals for Patient' then
    sRoutine := 'GMV LATEST VITALS FOR PATIENT'
  else if sRoutine = 'Entered in Error Patient' then
    sRoutine := 'GMV ENTERED IN ERROR-PATIENT'
  else begin
      MessageDLG('Report: '+#13#10+sRoutine+#13#10#13#10+'is not supported.',
        mtWarning,[mbOK],0);
      exit;
    end;

  sReport := ReportCombo.Text;
  if sReport = 'Vitals Signs Record' then
    sReport := '1'
  else if sReport  = 'B/P Plotting Chart' then
    sReport := '2'
  else if sReport  = 'Weight Chart' then
    sReport := '3'
  else if sReport  = 'POx/Respirations Chart' then
    sReport := '4'
  else if sReport  = 'Pain Chart' then
    sReport := '5'
  else
    sReport := '';

  sTitle := ReportCombo.Text;
  if sTitle = 'Cumulative Vitals Report' then
    sTitle := ''
  else if sRoutine = 'Latest Vitals by location' then
    sTitle := ''
  else if sRoutine = 'Latest Vitals for Patient' then
    sTitle := ''
  else if sRoutine = 'Entered in Error Patient' then
    sTitle := '';

//  PrintER(sRoutine);
  PrintReport(sRoutine,sReport,sTitle);
// zzzzzzandria 2008-02-21 =============================================== begin
end;

procedure TfrmGMV_ReportOPtions.PrintReport(aRoutine,aReport,aTitle:String);
var
//  A: integer;
  PrintDT,
  WardStr,
  WardIEN,
  GraphName,
  fGraph,
  fRoutine,
  fValue,
  fRomDate,
  Wardlist,
  ToDate: string;
begin
  if ((fPtIEN = '') and (cmbWard.text = '')) then
    Messagedlg('No Patient selected, please select a patient to continue',
      mtinformation,[mbOK],0)
  else if ReportCombo.text = '' then
    Messagedlg('No Report selected, please select a Report to continue',
      mtInformation,[mbOK],0)
  else if lvDevices.ItemIndex = -1 then
    Messagedlg('No Device selected, please select a Device to continue',
      mtInformation,[mbOK],0)
  else
    begin
      FromDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpFromDate.Date) + (dtpFromTime.Time - trunc(dtpFromTime.Date))));
      ToDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpToDate.Date) + (dtpToTime.Time - trunc(dtpToTime.Date))));
      PrintDT := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpPrintDate.Date) + (dtpPrintTime.Time - trunc(dtpPrintTime.Date))));

      Wardstr := '';
      WardIEN := '';
      if rbAllPatients.Checked and (cmbWard.Text <> '') then
        WardIEN := Piece(fWards[cmbWard.itemindex], '^', 1);

      WardList := '';    // RoomList

      if  rbAllPatients.Checked  then                           // AAN 07/01/2002
        begin                                                   // AAN 07/01/2002
//          for  a := 0 to Roomcombo.Items.Count - 1 do
//            if RoomCombo.Checked[a] = True then
//              WardList := WardList + Roomcombo.DisplayText[a] + ',';
          WardList := Trim(edRoomList.Text);
          if (WardList <> '') then
            if copy(WardList,Length(WardList),1) = ',' then
              WardList := Copy(WardList, 1, Length(WardList) - 1);
        end;                                                    // AAN 07/01/2002

      fGraph := aReport;
      GraphName := aTitle;
      fRoutine := aRoutine; // vitals reports are not supported

      if WardIEN = '' then
        fValue := fPtIEN;

      fValue := fValue + '^' + FromDate + '^' + ToDate + '^' + Fgraph + '^' +
        DeviceName + '^' + DeviceIEN + '^' + PrintDT + '^' + WardIEN + '^^' + WardList;
      ReportPr(Froutine, Fvalue, GraphName);

      ModalResult := mrOk;
    end;
end;

procedure TfrmGMV_ReportOPtions.ReportPr(const routine, value, Report: string);
begin
  Messagedlg(getProcedureResult(routine,value), mtInformation, [mbOK], 0);
end;

procedure TfrmGMV_ReportOptions.acStartDateChanged(Sender: TObject);
begin
  MinDate := dtpFromDate.Date;
  dtpToDate.MinDate := MinDate;
  acUpdateDtpColorsExecute(Sender);
end;

procedure TfrmGMV_ReportOptions.acStopDateChangedExecute(Sender: TObject);
begin
  MaxDate := dtpToDate.Date;
  dtpFromDate.MaxDate := MaxDate;
  acUpdateDtpColorsExecute(Sender);
end;

procedure TfrmGMV_ReportOptions.acUPdateDTPColorsExecute(Sender: TObject);
begin
//  dtpToDate.Enabled := (trunc(dtpToDate.MinDate) <> trunc(dtpToDate.MaxDate));
//  dtpFromDate.Enabled := (trunc(dtpFromDate.MinDate) <> trunc(dtpFromDate.MaxDate));
  lblStart.Enabled := dtpFromDate.Enabled;
  lblEnd.Enabled := dtpToDate.Enabled;
end;

procedure TfrmGMV_ReportOptions.acStartTimeChangedExecute(Sender: TObject);
begin
  if dtpFromTime.Time > dtpToTime.Time Then
     dtpFromTime.Time := dtpToTime.Time;
end;

procedure TfrmGMV_ReportOptions.acEndTimeChangedExecute(Sender: TObject);
begin
  if dtpToTime.Time < dtpFromTime.Time Then
     dtpToTime.Time := dtpFromTime.Time;
end;

procedure TfrmGMV_ReportOptions.acPrintDateChangedExecute(Sender: TObject);
var
  DT: TDateTime;
begin
  DT := trunc(dtpPrintDate.Date)+ frac(dtpPrintTime.Time);
  if DT < CurrentTime then
    dtpPrintTime.Time := frac(CurrentTime);
end;

procedure TfrmGMV_ReportOptions.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  try
    if DeviceIEN <> '' then
      GMVUser.Setting[usLastVistAPrinter] := DeviceIEN;
  except
  end;
  CanClose := True;
end;

function TfrmGMV_ReportOptions.getDeviceName:String;
begin
  Result := lvDevices.Items[lvDevices.ItemIndex].SubItems[0];
end;

function TfrmGMV_ReportOptions.getDeviceIEN:String;
begin
  Result := '';
  if lvDevices.ItemIndex >= 0 then
    Result := lvDevices.Items[lvDevices.ItemIndex].Caption;
end;

procedure TfrmGMV_ReportOptions.tmDeviceTimer(Sender: TObject);
var
  s: String;
    i: Integer;
  sl: TStringList;
  LI: TListItem;
begin
  tmDevice.Enabled := False;
  SL := TStringList.Create;
  try
    s := getDeviceList(uppercase(edTarget.Text),Margin,SearchDirection);
    SL.Text := S;
    lvDevices.Items.Clear;
    if sl.Count <> 0 then
      for i := 0 to SL.Count do
        begin
          if piece(SL[i],'^',1) = '' then continue;
          LI := lvDevices.Items.Add;
          LI.Caption := piece(SL[i],'^',1);
          LI.SubItems.Add(piece(SL[i],'^',2));
          LI.SubItems.Add(piece(SL[i],'^',4));
          LI.SubItems.Add(piece(SL[i],'^',5));
          LI.SubItems.Add(piece(SL[i],'^',6));
        end;
  except
  end;
  SL.Free;
end;

procedure TfrmGMV_ReportOptions.edTargetChange(Sender: TObject);
begin
  tmDevice.Enabled := True;
end;

procedure TfrmGMV_ReportOptions.edTargetKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    tmDeviceTimer(nil);
end;

procedure TfrmGMV_ReportOptions.acSearchExecute(Sender: TObject);
begin
  tmDevice.Enabled := True;
end;

procedure TfrmGMV_ReportOptions.lvDevicesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  try
    edDevice.Text := lvDevices.ItemFocused.SubItems[0]+'  '+
      lvDevices.ItemFocused.SubItems[1]+' ' +
      lvDevices.ItemFocused.SubItems[2]+'x' + lvDevices.ItemFocused.SubItems[3];
  except
    edDevice.Text := 'Not selected';
  end;
end;

procedure TfrmGMV_ReportOptions.SpeedButton2Click(Sender: TObject);
begin
  if lvDevices.Items.Count <= 0 then Exit;
  try
    edTarget.Text :=
      Copy(lvDevices.Items[lvDevices.Items.Count-1].SubItems[0],1,1{i-1});
    tmDeviceTimer(nil);
  except
  end;
end;

procedure TfrmGMV_ReportOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmGMV_ReportOptions.FormDestroy(Sender: TObject);
begin
  fWards.Free;
  Inherited;
end;

procedure TfrmGMV_ReportOptions.btnSelectClick(Sender: TObject);
var
  sWard: String;
begin
  sWard := cmbWard.Text;
  if sWard = '' then Exit;
  sWard := getWardRooms(sWard,edRoomList.Text);
  if sWard <> '' then
    edRoomList.Text := sWard;
end;

end.

