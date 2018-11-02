unit fGMV_InputTemp;

interface

uses
  ShareMem,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ActnList
  ,uGMV_Template
  , uGMV_Const
  , Buttons, System.Actions
  ;

type
  TfrmGMV_InputTemp = class(TForm)
    pnlInputTemplate: TPanel;
    Bevel1: TBevel;
    pnlInputTemplateHeader: TPanel;
    hc: THeaderControl;
    pnlScrollBox: TPanel;
    sbxMain: TScrollBox;
    pnlOptions: TPanel;
    bvU: TBevel;
    bvUnavailable: TBevel;
    lblUnavailable: TLabel;
    Label3: TLabel;
    ckbOnPass: TCheckBox;
    pnlCPRSMetricStyle: TPanel;
    chkCPRSSTyle: TCheckBox;
    ckbUnavailable: TCheckBox;
    pnlTools: TPanel;
    pnlPatient: TPanel;
    lblPatientName: TLabel;
    lblPatientInfo: TLabel;
    pnlSettings: TPanel;
    lblHospital: TLabel;
    lblDateTime: TLabel;
    lblHospitalCap: TLabel;
    Label2: TLabel;
    ActionList1: TActionList;
    acMetricStyleChanged: TAction;
    acSaveInput: TAction;
    acSetOnPass: TAction;
    acUnavailableBoxStatus: TAction;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure acMetricStyleChangedExecute(Sender: TObject);
    procedure acSaveInputExecute(Sender: TObject);
    procedure ckbOnPassClick(Sender: TObject);
    procedure acSetOnPassExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ckbOnPassEnter(Sender: TObject);
    procedure ckbOnPassExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FInputTemplate: TGMV_Template;
    FTemplateData: string;
    bDataUpdated: Boolean;
    FSignature,
    FDFN,
    FHospitalIEN: String;

    procedure SetVitalsList(InputTemplate:String);
    procedure FocusInputField;
    procedure CMVitalChanged(var Message: TMessage); message CM_VITALCHANGED;
    function InputString: String;
    procedure SetPatientID(anID:String);
    procedure SetHospitalID(anID:String);
    procedure SetSignature(anID:String);
    function CheckData:Boolean;
    procedure SaveData;
  public
    { Public declarations }
    property PatientID: String read FDFN write SetPatientID;
    property HospitalID: String read FHospitalIEN write SetHospitalID;
    property Signature:String read FSignature write SetSignature;
    procedure CleanUp;
  end;

var
  frmGMV_InputTemp: TfrmGMV_InputTemp;

function GetVitalsInputForm({aBroker:TRPCBroker;}aPatient,aHospital,aSignature,aTemplate:String;aNow:TDateTime):TfrmGMV_InputTemp;
procedure SetUpForm(aPatient,aHospital,aSignature:String);

//function GetVIForm(var anApp:TApplication;aBroker:TRPCBroker;aPatient,aHospital,aSignature:String):TfrmGMV_InputTemp;
//procedure SetBroker(aBroker:TRPCBroker);
//procedure CleanUpGlobals;

implementation

uses  mGMV_InputOne2
//  , u_Common
  , uGMV_Common
  , uGMV_User
  , uGMV_VitalTypes
  , uGMV_GlobalVars
  , uGMV_FileEntry
  , uGMV_Engine, uGMV_Setup
  ;

{$R *.dfm}

const
  sDelim = '*';
//var
//  PrevApp: TApplication;
//  PrevScreen: TScreen;

////////////////////////////////////////////////////////////////////////////////
(*
procedure SetBroker(aBroker: TRPCBroker);
begin
  RPCBroker := TCCOWRPCBroker(aBroker);
  SetUpGlobals;
  GMVUser.SetupSignOnParams;
  GMVUser.SetupUser;
end;
*)

procedure SetUpForm;
begin
  if Assigned(frmGMV_InputTemp) then
    begin
      frmGMV_InputTemp.PatientID := aPatient;
      frmGMV_InputTemp.HospitalID := aHospital;
      frmGMV_InputTemp.Signature := aSignature;
    end;
end;
////////////////////////////////////////////////////////////////////////////////

function GetVitalsInputForm(
  aPatient,aHospital,aSignature,aTemplate:String;
  aNow:TDateTime):TfrmGMV_InputTemp;
begin
  SetUpGlobals;
  GMVUser.SetupSignOnParams;
  GMVUser.SetupUser;
  try
    Application.CreateForm(TfrmGMV_inputTemp,frmGMV_InputTemp);
    frmGMV_InputTemp.PatientID := aPatient;
    frmGMV_InputTemp.HospitalID := aHospital;
    frmGMV_InputTemp.Signature := aSignature;
    frmGMV_InputTemp.pnlTools.Visible := False;
  except
    CleanUpGlobals;
    frmGMV_InputTemp := nil;
  end;
  Result := frmGMV_InputTemp;
end;
(*
function GetVIForm(var anApp:TApplication;aBroker:TRPCBroker;aPatient,aHospital,aSignature:String):TfrmGMV_InputTemp;
begin
  Application := anApp;
  Result := GetVitalsInputForm(aBroker,aPatient,aHospital,aSignature,'',Now);
end;

function GetVitalsInputPanel(
  var anApp:TApplication;
  aBroker:TRPCBroker;
  aPatient,aHospital,aSignature,aTemplate:String;aNow:TDateTime):TfrmGMV_InputTemp;
begin
  Application := anApp;
  Result := GetVitalsInputForm(aBroker,aPatient,aHospital,aSignature,aTemplate,aNow);
end;
*)
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_InputTemp.FormCreate(Sender: TObject);
var
  i: Integer;
  s: String;
  tmpList : TStrings;
  Template: TGMV_Template;
begin
{}
//  tmpList := TStringList.Create;
  try
//    CallRemoteProc(RPCBroker, RPC_MANAGER, ['GETTEMP'], nil, [],tmpList);
  tmpList := getTemplateList;
    for i := 1 to tmpList.Count - 1 do
      begin
//        Template := TGMV_Template.CreateFromXPAR(RPCBroker, tmpList[i]);
        Template := TGMV_Template.CreateFromXPAR(tmpList[i]);
        if (GMVDefaultTemplates <> nil)
          and GMVDefaultTemplates.IsDefault(Template.Entity, Template.TemplateName) then
          begin
            FInputTemplate := Template;
          end
        else
          Template.Free;
      end;
  finally
    FreeAndNil(tmpList);
  end;
{}
  // get default template name
  if FInputTemplate <> nil then
    begin
      s := FinputTemplate.Entity +       '|' +
           FInputTemplate.TemplateName + '^' +
           Piece(FInputTemplate.XPARValue,'|',1);
      SetVitalsList(S);
      pnlInputTemplateHeader.Caption := '  Vitals input template: <' + FInputTemplate.TemplateName + '>';
    end;
end;

procedure TfrmGMV_InputTemp.SetPatientID(anID:String);
begin
  FDFN := anID;
end;

procedure TfrmGMV_InputTemp.SetHospitalID(anID:String);
begin
  FHospitalIEN := anID;
end;

procedure TfrmGMV_InputTemp.SetSignature(anID:String);
begin
  FSignature := anID;
end;

procedure TfrmGMV_InputTemp.FocusInputField;
var
  i: Integer;
begin
  for i := 0 to sbxMain.ControlCount - 1 do
    if sbxMain.Controls[i] is TfraGMV_InputOne2 then
      begin
        ActiveControl :=TfraGMV_InputOne2(sbxMain.Controls[i]).cbxInput;
        break;
      end;
end;

procedure TfrmGMV_InputTemp.SetVitalsList(InputTemplate:String);
var
  InputOne2: TfraGMV_InputOne2;
  i: Integer;
begin
  Screen.Cursor := crHourGlass;
  sbxMain.Visible := False;

  FInputTemplate := GetTemplateObject(piece(InputTemplate,'|',1),piece(InputTemplate,'|',2));

  if FInputTemplate <> nil then
    begin
      FTemplateData := piece(FInputTemplate.XPARValue, '|', 2);
      i := 1;
      while piece(FTemplateData, ';', i) <> '' do
        begin
          try
            InputOne2 := TfraGMV_InputOne2.Create(sbxMain); //works in unit

            with InputOne2 do
              begin
                Parent := sbxMain;
                Name := 'tmplt' + IntToStr(i);

                if (i mod 2) = 0 then
                  pnlMain.Color := $00b1b1b1;
                TemplateVital := TGMV_TemplateVital.CreateFromXPAR(piece(FTemplateData, ';', i));
                DefaultTemplateVital := TemplateVital;
                lblNum.Caption := IntToStr(i) + '. ';

                Top := i * Height;
                TabOrder := Top;
                Align := alTop;
                try
                  ckbMetricClick(nil);//AAN 08/16/2002
                except
                end;
              end;
          except
            on e: Exception do
              MessageDialog('Error','Error creating input template '+#13+ e.Message,
                mtError,mbYesNoCancel,0,0);
          end;
          inc(i);
        end;
      try
        acMetricStyleChangedExecute(nil);
      except
      end;
    end;
  sbxMain.Visible := True;
  bDataUpdated := False;
  FocusInputField;
  Screen.Cursor := crDefault;
end;

procedure TfrmGMV_InputTemp.acMetricStyleChangedExecute(Sender: TObject);
var
  i : Integer;
begin
  for I := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          TfraGMV_InputOne2(sbxMain.Components[i]).SetMetricStyle(chkCPRSStyle.Checked);
        end;
    end;
  if acMetricStyleChanged.Enabled then
    acMetricStyleChanged.Checked := True
  else
    acMetricStyleChanged.Checked := False;
end;

function TfrmGMV_InputTemp.InputString: String;
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

function TfrmGMV_InputTemp.CheckData:Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if not TfraGMV_InputOne2(sbxMain.Components[i]).Check(0) then
        break;
    end;
  if i = sbxMain.ComponentCount then
    Result := True;
end;

procedure TfrmGMV_InputTemp.SaveData;
var
  i: Integer;
  s1,s2,
  s,
  x: String;
  dt: TDateTime;
begin
{
  dt := WindowsDateTimeToFMDateTime(trunc(dtpDate.Date) +
    (dtpTime.DateTime - trunc(dtpTime.Date)));
}
  dt := WindowsDateTimeToFMDateTime(Now);

  for i := 0 to sbxMain.ControlCount - 1 do
    begin
      if sbxMain.Controls[i] is TfraGMV_InputOne2 then
        with TfraGMV_InputOne2(sbxMain.Controls[i]) do
          begin
            x := '';
            if ckbOnPass.Checked then
              begin
                x := FloatToStr(dt) + '^' +
                  FDFN + '^' +
                  VitalIEN + ';Pass;' + '^' +
                  FHospitalIEN + '^' +
                  GMVUser.DUZ + '*';
              end else
            if ckbUnavailable.Checked then
              begin
                x := FloatToStr(dt) + '^' +
                  FDFN + '^' +
                  VitalIEN + ';Unavailable;' + '^' +
                  FHospitalIEN + '^' +
                  GMVUser.DUZ + '*';
              end
            else if VitalsRate <> '' then
              begin
                s1 := VitalsRate;
                // AAN 2003/06/30 -- do not show qualifiers for PulseOx if there is no rate
                if (piece(s1,';',1) = '21') and (piece(s1,';',3)='') then
                  s2 := ''
                else
                  s2 := VitalsQualifiers;
                  x := FloatToStr(dt) + '^' +
                  FDFN + '^' +
                  s1{VitalsRate} + '^' +
                  FHospitalIEN + '^' +
                  GMVUser.DUZ +
                  '*' +
                  s2{VitalsQualifiers};
              end;

            if x <> '' then
              begin
//                ShowMessage(X+sDelim+Signature);
{
                CallRemoteProc(RPCBroker, 'GMV ADD VM', [x+sDelim+Signature], nil,[rpcSilent,rpcNoresChk]);
                if RPCBroker.Results.Count > 1 then
                  MessageDlg(RPCBroker.Results.Text, mtError, [mbok], 0);
}
                s := addVM(x+sDelim+Signature);
                if s <> '' then
                  MessageDlg(s, mtError, [mbok], 0);
              end;
            end;
    end;
end;

procedure TfrmGMV_InputTemp.acSaveInputExecute(Sender: TObject);
begin
  //Check all input panels for valid values
  if not CheckData then Exit;
  if InputString <> '' then
      SaveData;
end;

procedure TfrmGMV_InputTemp.acSetOnPassExecute(Sender: TObject);
var
  i: Integer;
begin
  if (Sender = ckbUnavailable ) and
    ckbUnavailable.Checked and ckbOnPass.Checked then
    ckbOnPass.Checked := false
  else
    if ckbOnPass.Checked and ckbUnavailable.Checked then
    ckbUnavailable.Checked := false;

  for  i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          if (ckbOnPass.Checked) or (ckbUnavailable.Checked)//AAN 12/09/2002
          then
            begin
              TfraGMV_InputOne2(sbxMain.Components[i]).DisablePanel;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := False;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := False;
            end
          else
            begin
              if TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Checked or
                 TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked then
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

procedure TfrmGMV_InputTemp.ckbOnPassClick(Sender: TObject);
begin
  acSetOnPassExecute(ckbOnPass);
end;

procedure TfrmGMV_InputTemp.FormResize(Sender: TObject);
begin
  hc.Sections[3].width := 118;
  hc.Sections[4].width := 116;
  hc.Sections[5].width := 78;

  hc.Sections[6].width := hc.Width - hc.Sections[0].Width - hc.Sections[1].Width -
    hc.Sections[2].Width - hc.Sections[3].Width - hc.Sections[4].Width - hc.Sections[5].Width;
  if Height > Screen.Height then
    Height := Screen.Height;
end;

procedure TfrmGMV_InputTemp.ckbOnPassEnter(Sender: TObject);
begin
  bvU.Visible := true;
end;

procedure TfrmGMV_InputTemp.ckbOnPassExit(Sender: TObject);
begin
  bvU.Visible := False;
end;

procedure TfrmGMV_InputTemp.CMVitalChanged(var Message: TMessage);
begin
  bDataUpdated := True;
end;

procedure TfrmGMV_InputTemp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  ShowMessage('Close Window');
//  SaveData;
  CleanUp;
end;

procedure TfrmGMV_InputTemp.SpeedButton1Click(Sender: TObject);
begin
  SaveData;
end;

procedure TfrmGMV_InputTemp.CleanUp;
var
  i: Integer;
begin
  FInputTemplate.Free;
  for i := sbxMain.ComponentCount - 1 downto 0 do
    if sbxMain.Components[i] is TfraGMV_InputOne2 then
      TfraGMV_InputOne2(sbxMain.Components[i]).Free;
  CleanUpGlobals;
end;

procedure TfrmGMV_InputTemp.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if InputString <> '' then
    begin
      if CheckData then
        begin
          SaveData;
          CanClose := True;
        end
      else
        CanClose := False;
    end
  else CanClose := True;
end;


exports
  GetVitalsInputForm name 'GetVitalsInputForm',
//////////  GetVitalsInputForm name 'GMV_InputForm',
//  GetVIForm name 'GMV_InputPanel',
//  SetBroker name 'GMV_SetBroker',
//  CleanUpGlobals name 'GMV_CleanUp',
  SetUpForm name 'GMV_SetUpInputForm';
(*
initialization
  PrevApp := Application;
  PrevScreen := Screen;
  RegisterClass(TfrmGMV_InputTemp);

finalization
  Application := PrevApp;
  Screen := PrevScreen;
  UnRegisterClass(TfrmGMV_InputTemp);
*)
end.
