unit mGMV_VitalHiLo;
{
================================================================================
*
*       Application:  Vitals Manager
*       Revision:     $Revision: 1 $  $Modtime: 2/27/09 3:11p $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Frame for entering in Max/Min abnormal values for vitals.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER/mGMV_VitalHiLo.pas $
*
* $History: mGMV_VitalHiLo.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 3:14p
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:40p
 * Created in $/Vitals/VITALS-5-0-18/APP-VitalsManager
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:30p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/APP-VitalsManager
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsManager-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 4:56p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsManager-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:22p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSMANAGER-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:09p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsManager
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 7/05/02    Time: 3:49p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:12a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Roll-up to 5.0.0.27
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 3:44p
 * Created in $/Vitals GUI Version 5.0/Vitals Manager
 *
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
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  uGMV_Common
, uGMV_VitalTypes;

type
  TGMV_VitalHiLo = (
    hlUnknown,
    hlHigh,
    hlLow);
type
  TGMV_VitalHiLoType = (
    hltUnknown,
    hltSystolic,
    hltDiastolic,
    hltTemperature,
    hltRespiration,
    hltPulse,
    hltCVP,
    hltO2Sat);

type
  TGMV_VitalHiLoDefinition = class(TObject)
  private
    FMinimum: integer;
    FMaximum: integer;
    FIncrement: integer;
    FVitalType: TGMV_VitalHiLoType;
  public
    constructor Create(
      VitalType: TGMV_VitalHiLoType;
      Minimum: integer;
      Maximum: integer;
      Increment: integer);
//    destructor Destroy; override;
//  published
    property VitalType: TGMV_VitalHiLoType
      read FVitalType;
    property Maximum: integer
      read FMaximum;
    property Minimum: integer
      read FMinimum;
    property Increment: integer
      read FIncrement;
  end;


type
  TfraVitalHiLo = class(TFrame)
    Panel1: TPanel;
    pnlValue: TPanel;
    edtValue: TEdit;
    pnlSlider: TPanel;
    tkbar: TTrackBar;
    pnlHeader: TPanel;
    lblName: TLabel;
    lblHiLo: TLabel;
    lblRange: TLabel;
    pnlMinMax: TPanel;
    lblMax: TLabel;
    lblMin: TLabel;
    pnlSpacer: TPanel;
    gb: TGroupBox;
    procedure pnlSliderResize(Sender: TObject);
    procedure tkbarChange(Sender: TObject);
    function SetValue(var NewVal: string): Boolean;
    function SaveValue: Boolean;
    procedure edtValueExit(Sender: TObject);
    procedure pnlValueResize(Sender: TObject);
  private
    FHighLow: TGMV_VitalHiLo;
    FVitalType: TGMV_VitalHiLoType;
    { Private declarations }
  public
    procedure SetUpFrame(
      VitalType: TGMV_VitalHiLoType;
      HighOrLow: TGMV_VitalHiLo;
      Minimum, Maximum, Increment: Integer);
    function HiLoValue: Integer;
    function CheckLimits:Boolean;
    { Public declarations }
  end;

const
  GMVVITALHILO: array[TGMV_VitalHiLo] of string = ('Unknown', 'High', 'Low');
  GMVVITALHILOTYPES: array[TGMV_VitalHiLoType] of string = (
       'Unknown', 'Systolic', 'Diastolic', 'Temperature', 'Respiration', 'Pulse', 'CVP', 'Pulse Oximetry');//AAN 2003/06/04 'Pulse Oximetry'
  GMVVitalHiLoFields: array[TGMV_VitalHiLoType, TGMV_VitalHiLo] of string =
    (('','','')
    ,('','5.7','5.8')   // Systolic
    ,('','5.71','5.81') // Diastolic
    ,('','5.1','5.2')   // Temperature
    ,('','5.5','5.6')   // Respiration
    ,('','5.3','5.4')   // Pulse
    ,('','6.1','6.2')   // CVP
    ,('','','6.3')      // Pulse Ox
    );
var
//  GMVVitalHiLoFields: array[TGMV_VitalHiLoType, TGMV_VitalHiLo] of string;
  GMVVitalHiRange: array[TVitalType] of Double;
  GMVVitalLoRange: array[TVitalType] of Double;


implementation

uses
//  uROR_RPCBroker, fROR_PCall,
  uGMV_Engine, system.UITypes;

{$R *.DFM}

const
  RPC_MANAGER = 'GMV MANAGER';

{ TGMV_VitalHiLoDefinition }

constructor TGMV_VitalHiLoDefinition.Create(
  VitalType: TGMV_VitalHiLoType;
  Minimum, Maximum, Increment: integer);
begin
  inherited Create;
  FVitalType := VitalType;
  FMinimum := Minimum;
  FMaximum := Maximum;
  FIncrement := Increment;
end;


{ TfraVitalHiLo }

procedure TfraVitalHiLo.SetUpFrame(
  VitalType: TGMV_VitalHiLoType;
  HighOrLow: TGMV_VitalHiLo;
  Minimum, Maximum, Increment: Integer);
var
  InitVal: Integer;
  s,
  textVal: string;
begin
  FVitalType := VitalType;
  FHighLow := HighOrLow;
  lblName.Caption := GMVVITALHILOTYPES[FVitalType];
  lblHiLo.Caption := GMVVITALHILO[FHighLow];
  lblRange.Caption := Format('%d..%d',[Minimum,Maximum]);

  gb.Caption := lblName.Caption + '  ' + lblHiLo.Caption;
  
  lblMin.Caption := IntToStr(Minimum);
  lblMax.Caption := IntToStr(Maximum);
  tkbar.Min := Minimum;
  tkbar.Max := Maximum;
  tkbar.Frequency := Increment;
//  CallRemoteProc(RPCBroker,RPC_MANAGER,['GETHILO', GMVVitalHiLoFields[FVitalType, FHighLow]],nil);
  s := getVitalHiLo(GMVVitalHiLoFields[FVitalType, FHighLow]);
//  InitVal := StrToIntDef(RPCBroker.Results[0], 9999);
  InitVal := StrToIntDef(s, 9999);
  if (InitVal < tkbar.Min) or (InitVal > tkBar.Max) then
    begin
      MessageDlg('Invalid value retrieved ' + s, mtInformation, [mbok], 0);
      tkbar.Position := tkbar.Min;
      edtValue.Text := IntToStr(tkbar.Min);
    end
  else
    begin
      textVal := IntToStr(InitVal);
      SetValue(textVal);
      edtValue.Text := textVal;
    end;
end;

function TfraVitalHiLo.HiLoValue: Integer;
begin
  Result := tkbar.Position;
end;

function TfraVitalHiLo.SaveValue: Boolean;
var
  s: String;
begin
//  CallRemoteProc(RPCBroker, RPC_MANAGER,['SETHILO', GMVVitalHiLoFields[FVitalType, FHighLow] + '^' + edtValue.Text],nil);
  s := setVitalHiLo(GMVVitalHiLoFields[FVitalType, FHighLow],edtValue.Text);
//  if Piece(RPCBroker.Results[0], '^', 1) <> '-1' then
  if Piece(s, '^', 1) <> '-1' then
    Result := True
  else
    begin
      MessageDlg('Error saving abnormal value.' + #13 + piece(s, '^', 2), mtError, [mbok], 0);
      Result := False;
    end;
end;

procedure TfraVitalHiLo.pnlSliderResize(Sender: TObject);
begin
  tkbar.Height := pnlSlider.Height - (tkbar.Top * 2);
  pnlSpacer.Width := (pnlSlider.Width - tkbar.Width) div 2;
end;

procedure TfraVitalHiLo.tkbarChange(Sender: TObject);
begin
  edtValue.Text := IntToStr(tkbar.min + (Abs(tkbar.Max - tkbar.Position)));
end;

function TfraVitalHiLo.SetValue(var NewVal: string): Boolean;
var
  i: integer;
begin
  i := StrToIntDef(NewVal, tkbar.Max + 1);
  if (i > tkbar.Max) or (i < tkbar.Min) then
    begin
      MessageDlg('Please enter a value between ' + IntToStr(tkbar.Min) +
        ' and ' + IntToStr(tkbar.Max) + '.' + #13 +
        'Please try again.', mtError, [mbok], 0);
      NewVal := IntToStr(tkbar.min + (Abs(tkbar.Max - tkbar.Position)));
      Result := False;
    end
  else
    begin
      tkbar.Position := tkbar.Max - i + tkbar.Min;
      Result := True;
    end;
  edtValue.Text := NewVal;
end;

procedure TfraVitalHiLo.edtValueExit(Sender: TObject);
var
  Value: string;
begin
  Value := edtValue.Text;
  if not SetValue(Value) then
    begin
      edtValue.Text := Value;
      edtValue.SetFocus;
    end;
end;

procedure TfraVitalHiLo.pnlValueResize(Sender: TObject);
begin
  edtValue.Left := (pnlValue.Width - edtValue.width) div 2;
end;

function TfraVitalHiLo.CheckLimits:Boolean;
var
  Value: string;
begin
  Value := edtValue.Text;
  result := SetValue(Value);
end;

end.

