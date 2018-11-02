unit mGMV_InputOne2;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 4/09/09 10:12a $
*       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Frame to manage the input of a single vital.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY/mGMV_InputOne2.pas $
*
* $History: mGMV_InputOne2.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSDATAENTRY
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 6/17/08    Time: 4:04p
 * Updated in $/Vitals/5.0 (Version 5.0)/VitalsGUI2007/Vitals/VITALSDATAENTRY
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 2/01/08    Time: 7:39a
 * Updated in $/Vitals GUI 2007/Vitals/VITALSDATAENTRY
 * Vitals GUI 5.0.22.3
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 1/07/08    Time: 6:52p
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
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 6/13/06    Time: 11:15a
 * Updated in $/Vitals/VITALS-5-0-18/VitalsDataEntry
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
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 1/30/04    Time: 4:32p
 * Updated in $/VitalsLite/VitalsLiteDLL
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/15/04    Time: 3:06p
 * Created in $/VitalsLite/VitalsLiteDLL
 * Vitals Lite DLL
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
  Buttons,
  ComCtrls,
  ExtCtrls
  , ActnList
  , uGMV_Template
  , uGMV_FileEntry
  , uGMV_GlobalVars
  , uGMV_VitalTypes
  ;

type
  TfraGMV_InputOne2 = class(TFrame)
    pnlMain: TPanel;
    pnlValues: TPanel;
    cbxInput: TComboBox;
    pnlRefusedUnavailable: TPanel;
    cbxRefused: TCheckBox;
    cbxUnavailable: TCheckBox;
    pnlQualifiers: TPanel;
    bbtnQualifiers: TBitBtn;
    lblQualifiers: TLabel;
    ckbMetric: TCheckBox;
    pnlName: TPanel;
    lblVital: TLabel;
    lblUnit: TLabel;
    lblNum: TLabel;
    bvU: TBevel;
    bvR: TBevel;
    bvMetric: TBevel;
    bvQual: TBevel;
    cbxUnits: TComboBox;
    procedure cbxInputExit(Sender: TObject);
    procedure bbtnQualifiersClick(Sender: TObject);
    procedure ckbMetricClick(Sender: TObject);
    procedure cbxRefusedClick(Sender: TObject);
    procedure cbxUnavailableClick(Sender: TObject);
    procedure DisablePanel;
    procedure EnablePanel;
    procedure cbxRefusedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, Y: integer);
    procedure cbxUnavailableMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, Y: integer);
    procedure cbxInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxInputChange(Sender: TObject);
    procedure cbxInputClick(Sender: TObject);
    procedure acMetricChangedExecute(Sender: TObject);
    procedure ckbMetricEnter(Sender: TObject);
    procedure ckbMetricExit(Sender: TObject);
    procedure cbxRefusedEnter(Sender: TObject);
    procedure cbxRefusedExit(Sender: TObject);
    procedure cbxUnavailableExit(Sender: TObject);
    procedure cbxUnavailableEnter(Sender: TObject);
    procedure bbtnQualifiersEnter(Sender: TObject);
    procedure bbtnQualifiersExit(Sender: TObject);
    procedure cbxInputKeyPress(Sender: TObject; var Key: Char);
    procedure cbxInputEnter(Sender: TObject);
    procedure cbxUnitsEnter(Sender: TObject);
    procedure cbxUnitsExit(Sender: TObject);
  private
    fTemplateVital: TGMV_TemplateVital;
    fTemplateVitalType: TVitalType;
    fVitalQualifiers: string;
    fValueDbl: Double; {This stores the value for the input in US Standard where applicable}
    fValueInt: integer; {This stores the value for the input in US Standard where applicable}
//    FValueStr: string; {This stores the value for the input in US Standard where applicable}
    fPO2FlowRate: string;
    fPO2Percentage: string;
    fCheckErrorMessage: String;
    bCPRSMetric: Boolean;
    bMetric: Boolean;
    bIgnore: Boolean;
    function ValidBP: Boolean;
    function ValidTemperature: Boolean;
    function ValidPulse: Boolean;
    function ValidRespiration: Boolean;
    function ValidWeight(aDT: TDateTime): Boolean;
    function ValidHeight(aDT: TDateTime): Boolean;
    function ValidPain: Boolean;
    function ValidGirth: Boolean;
    function ValidPO2: Boolean;
    function ValidCVP: Boolean;
    procedure OutOfRange(aVitalType:String='');
    procedure SetTemplateVital(const Value: TGMV_TemplateVital);
    procedure SetPanelStatus(bStatus:Boolean);//AAN 07/11/2002
    function HintString(isMetric:Boolean):String;
    { Private declarations }
  public
    DFN: String;
    ConversionWarning: Boolean;
    Valid: Boolean;
    DefaultTemplateVital: TGMV_TemplateVital;
    function VitalIEN: string;
    function VitalsRate: string;
    function VitalsQualifiers: string;
    procedure ShowMetrics;
    procedure SetMetricStyle(bCPRSStyle:Boolean);
    function Check(aDT:TDateTime):Boolean;
    procedure ClearPO2FlowRateAndPercentage;
    procedure SetMetricUnitLabels(aMetric:Boolean);

    function getStatusString:String;
    procedure setStatusString(aString:String);
    function getLength(aString:String;aMetric:Boolean):Double;
  published
    property TemplateVital: TGMV_TemplateVital
      read FTemplateVital write SetTemplateVital;
  end;

implementation

uses
    fGMV_SupO2
  , fGMV_Qualifiers
  , uGMV_Utils
  , uGMV_Common
  , uGMV_Const
  , fGMV_InputLite, uGMV_Engine
  , system.UITypes;

{$R *.DFM}

var
  tmpDouble: Double;
  tmpInt: integer;

const
  cRefused = 'Refused';
  cUnavailable = 'Unavailable';
  cWeightDelta = 20.0;
  cHeightDelta = 10.0;

  emDoubleCheck = 'Double check to ensure that you have entered the data for'#13+
    'the correct patient''s chart and in the correct units of measure.';

  fmtDoubleCheck = 'The value just entered differs from the most'#13+
    'recent %s recorded values by more than %2.0n%%'#13#13+

    'Just entered:  '+Char(VK_TAB)+'%s %s ' + Char(VK_TAB) + '%s'#13+
    'Previous value:'+Char(VK_TAB)+'%s %s ' + Char(VK_TAB) + '%s'#13#13+

    'Double check to ensure that you have entered data'#13+
    'for the correct patient''s chart and in the correct'#13+
    'units of measure.'#13#13+

    'Do you want to save the new value?';

function getDelta(aDbl:Double;aValue:String): Double;
var
  dValue: Double;
begin
  dValue := strToFloatDef(aValue,0.0);
  Result := dValue - aDbl;
  if Result < 0.0 then
    Result := -Result;
  Result := Result / dValue;
  Result := 100.0 * Result;
end;

  { TfraGMV_InputOne }
procedure TfraGMV_InputOne2.ClearPO2FlowRateAndPercentage;
begin
  FPO2FlowRate := '';
  FPO2Percentage := '';
end;

procedure TfraGMV_InputOne2.ShowMetrics;
begin
  if not bCPRSMetric then
    begin
      cbxUnits.Visible := False;
      lblUnit.Visible := bMetric;
      ckbMetric.Visible := bMetric;
    end
  else
    begin
      lblUnit.Visible := False;
      ckbMetric.Visible := False;
      cbxUnits.Visible := bMetric;
    end;
  cbxInput.Hint := HintString(ckbMetric.Checked);
  SetMetricUnitLabels(ckbMetric.Checked);
end;

procedure TfraGMV_InputOne2.SetMetricStyle(bCPRSStyle:Boolean);
begin
  bcPRSMetric := bCPRSStyle;
  ShowMetrics;
end;

procedure TfraGMV_InputOne2.SetTemplateVital(const Value: TGMV_TemplateVital);
var
  i: integer;
  aType: TVitalType;
begin
  Valid := True;
  FTemplateVital := Value;
  lblVital.Caption := TitleCase(FTemplateVital.VitalName) + ':';
  ckbMetric.Checked := FTemplateVital.Metric;
  lblQualifiers.Caption := '';
  FVitalQualifiers := '';
  i := 1;
  while Piece(FTemplateVital.Qualifiers, '~', i) <> '' do
    begin
      if FVitalQualifiers <> '' then
        FVitalQualifiers := FVitalQualifiers + ':';
      FVitalQualifiers := FVitalQualifiers + Piece(Piece(FTemplateVital.Qualifiers, '~', i), ',', 2);
      inc(i);
    end;
  //Defaults --- //AAN 07/10/2002
  cbxInput.Style := csSimple;
  cbxInput.Text := '';
  ckbMetric.Visible := False;
  cbxUnits.Visible := False;
  lblQualifiers.Caption := TitleCase(FTemplateVital.DisplayQualifiers);
  lblUnit.Caption := '';
  lblUnit.Visible := False;
  ckbMetric.Visible := False;

  bvQual.Visible := False;
  bvU.Visible := False;
  bvR.Visible := False;
  bvMetric.Visible := False;

  bMetric := False;
  bCPRSMetric := False;
// Changes to avoid using fixed number for the types -------------- AAN 12/04/02
//  case StrToIntDef(FTemplateVital.IEN, -1) of
  aType := VitalTypeByString(FTemplateVital.IEN);
  cbxInput.Hint := HintString(ckbMetric.Checked);//HintText;//AAN 07/08/2002
  case aType of
    vtBP:  FTemplateVitalType := vtBP;
    vtTemp:
      begin
        FTemplateVitalType := vtTemp;
        ckbMetric.Visible := True;

        lblUnit.Caption := 'F';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('F');
        cbxUnits.Items.Add('C');
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtResp:  FTemplateVitalType := vtResp;
    vtPulse: FTemplateVitalType := vtPulse;
    vtHeight:
      begin
        FTemplateVitalType := vtHeight;
        ckbMetric.Visible := True;
        lblUnit.Caption := '(in)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('in');
        cbxUnits.Items.Add('cm');
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;
        bMetric := True;
      end;
    vtWeight:
      begin
        FTemplateVitalType := vtWeight;
        ckbMetric.Visible := True;
        lblUnit.Caption := '(lb)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('lb');
        cbxUnits.Items.Add('kg');
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtCircum:
      begin
        FTemplateVitalType := vtCircum;
        ckbMetric.Visible := True;
        lblUnit.Caption := '(in)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('in');
        cbxUnits.Items.Add('cm');
        cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('in'); // zzzzzzbellc 2010/05/06 Remedy: 370106
        //cbxUnits.Text := 'in';
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtCVP:
      begin
        FTemplateVitalType := vtCVP;
        ckbMetric.Caption := 'mmHg';
        ckbMetric.Visible := True;

        lblVital.Caption := 'CVP';//AAN 07/03/2002
        bbtnQualifiers.Visible := False;
        lblQualifiers.Caption := '';
        lblUnit.Caption := '(cmH2O)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('cmH20');
        cbxUnits.Items.Add('mmHg');
        cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('cmH20'); // zzzzzzbellc 2010/05/06 Remedy: 370106
       // cbxUnits.Text := 'cmH20';
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtPO2:
    // zzzzzzandria 060613 - Room Air question
      begin
        FTemplateVitalType := vtPO2;
// zzzzzzandria 060920 Remedy 146205 - Room Air can not be selected as the default
//        lblQualifiers.Caption := '[]'; //zzzzzzandria 060725 Remedy 150714, 151694, 146205
        bbtnQualifiers.Hint := 'Press to select Supplemental Oxygen Rate, Concentration and Method';
      end;
    vtPain:
      begin
        FTemplateVitalType := vtPain;
        cbxInput.Style := csDropDownList; // zzzzzzandria 050209 end
// zzzzzzandria 050706 added blank line to the pain list
        cbxInput.Items.CommaText := '"","0 - no pain","1 - slightly uncomfortable",2,3,4,5,6,7,8,9,"10 - worst imaginable","99 - unable to respond"';
        cbxInput.ItemIndex := -1;
        cbxInput.Hint := 'Enter a value from '+FloatToStr(GMVVitalLoRange[FTemplateVitalType])+
          ' to '+ FloatToStr(GMVVitalHiRange[FTemplateVitalType])+' or 99';//AAN 04/15/2003
        bbtnQualifiers.Visible := False;
        lblQualifiers.Caption := '';
      end;
  else
    FTemplateVitalType := vtUnknown;
  end;
  ShowMetrics;
end;

function TfraGMV_InputOne2.HintString(isMetric:Boolean):String;
var
  fLow,fHigh:Double;
begin
  fLow := GMVVitalLoRange[FTemplateVitalType];
  fHigh := GMVVitalHiRange[FTemplateVitalType];
  if isMetric then
    begin
      case FTemplateVitalType of
        vtTemp: begin
            fLow := ConvertFToC(fLow);
            fHigh := ConvertFToC(fHigh);
          end;
        vtHeight,vtCircum: begin
//            fLow :=ConvertInToCm(fLow);
//            fHigh :=ConvertInToCm(fHigh);
            fLow := fLow*2.54;
            fHigh := fHigh*2.54;
          end;
        vtWeight: begin
            fLow :=ConvertLbsToKgs(fLow);
            fHigh :=ConvertLbsToKgs(fHigh);
          end;
        vtCVP: begin
            fLow := ConvertcmH20TommHg(fLow);
            fHigh := ConvertcmH20TommHg(fHigh);
          end;
      end;
    end;
  Result := 'Please enter a value from  '+
    FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
end;

procedure TfraGMV_InputOne2.OutOfRange(aVitalType:String='');
var
  s: String;
begin
  s := 'The value you entered is out of range for this vital.' + #13#13+
      HintString(ckbMetric.Checked);
  if aVitalType <> '' then  s := 'Vital Type: '+aVitalType+ #13+#13+s;
  MessageDlg(s, mtError, [mbOk], 0);
end;

procedure TfraGMV_InputOne2.cbxInputExit(Sender: TObject);
begin
  cbxInput.Text := trim(cbxInput.Text);// Remedy 170801  zzzzzzandria 061214

  if not Check(0) then
    cbxInput.SetFocus;
  setStatusString('');
end;

procedure TfraGMV_InputOne2.bbtnQualifiersClick(Sender: TObject);
var
  s: String;
  Quals: string;
  QualsText: string;
  PO2FlowRate: string;
  PO2Percentage: string;
//const // zzzzzzandria 050714
//  cRoomAir = 'ROOM AIR'; // zzzzzzandria 050714

begin
  if FTemplateVitalType = vtPO2 then
    begin
      PO2FlowRate := FPO2FlowRate;
      PO2Percentage := FPO2Percentage;
      if GetSupplementO2Data(PO2FlowRate, PO2Percentage, TControl(Sender),lblQualifiers.Caption) then
        begin
          FPO2FlowRate := PO2FlowRate;
          FPO2Percentage := piece(PO2Percentage,'^',1);
          FVitalQualifiers := piece(PO2Percentage,'^',2);
          QualsText := piece(PO2Percentage,'^',3);
          s := ' ';//AAN 11/07/2002 -- two spaces between Qualifier and data
          if FPO2FlowRate <> '' then
              s := s + ' ' + FPO2FlowRate + ' l/min';
          if FPO2Percentage <> '' then
            s := s + ' ' + FPO2Percentage + ' %';
          if s = ' ' then s := '';
// 20071220 zzzzzzandria --- all flow rates and %% values are included --- /////
          lblQualifiers.Caption := '[' + QualsText + s + ']'
(* ==================================================================== 20071220
          if (FPO2FlowRate <> '') or (FPO2Percentage <> '') then
             lblQualifiers.Caption := '[' + QualsText + s + ']'
          else if pos(cRoomAir,uppercase(QualsText)) > 0 then // zzzzzzandria 050714
             lblQualifiers.Caption := '[' + QualsText + ']' // zzzzzzandria 050714
          else
             lblQualifiers.Caption := '[]';
==============================================================================*)
        end;
      Exit;
    end;

  Quals := FVitalQualifiers;
  if SelectQualifiers(FTemplateVitalType, Quals, QualsText, TControl(Sender),cbxInput.Text) then
    begin
      FVitalQualifiers := Quals;
      lblQualifiers.Caption := '[' + QualsText + ']';
    end;
end;

procedure TfraGMV_InputOne2.SetMetricUnitLabels(aMetric:Boolean);
begin
  //UPDATED CODE zzzzzzbellc 2010/05/06 Remedy: 370106
  if aMetric then
      case FTemplateVitalType of
        vtTemp: begin
         if (cbxUnits.Items.IndexOf('C') = -1) then
          cbxUnits.Items.Add('C');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('C');
       //  cbxUnits.Text := 'C';
        end;
        vtWeight: begin
         if (cbxUnits.Items.IndexOf('kg') = -1) then
          cbxUnits.Items.Add('kg');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('kg');
         //cbxUnits.Text := 'kg';
        end;
        vtHeight: begin
         if (cbxUnits.Items.IndexOf('cm') = -1) then
          cbxUnits.Items.Add('cm');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('cm');
         //cbxUnits.Text := 'cm';
        end;
        vtCircum: begin
         if (cbxUnits.Items.IndexOf('cm') = -1) then
          cbxUnits.Items.Add('cm');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('cm');
         //cbxUnits.Text := 'cm';
        end;
        vtCVP: begin
         if (cbxUnits.Items.IndexOf('mmHg') = -1) then
          cbxUnits.Items.Add('mmHg');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('mmHg');
         //cbxUnits.Text := 'mmHg';
        end;
      end
   else
      case FTemplateVitalType of
        vtTemp: begin
         if (cbxUnits.Items.IndexOf('F') = -1) then
          cbxUnits.Items.Add('F');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('F');
         //cbxUnits.Text := 'F';
        end;
        vtWeight: begin
         if (cbxUnits.Items.IndexOf('lb') = -1) then
          cbxUnits.Items.Add('lb');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('lb');
         //cbxUnits.Text := 'lb';
        end;
        vtHeight: begin
         if (cbxUnits.Items.IndexOf('in') = -1) then
          cbxUnits.Items.Add('in');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('in');
        // cbxUnits.Text := 'in';
        end;
        vtCircum: begin
         if (cbxUnits.Items.IndexOf('in') = -1) then
          cbxUnits.Items.Add('in');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('in');
         //cbxUnits.Text := 'in';
        end;
        vtCVP: begin
         if (cbxUnits.Items.IndexOf('cmH20') = -1) then
          cbxUnits.Items.Add('cmH20');
         cbxUnits.ItemIndex := cbxUnits.Items.IndexOf('cmH20');
        // cbxUnits.Text := 'cmH20';
        end;
      end;
end;

procedure TfraGMV_InputOne2.ckbMetricClick(Sender: TObject);
var
  IsMetric: Boolean;
begin
  IsMetric := ckbMetric.Checked;
  if IsMetric then
      case FTemplateVitalType of
        vtTemp: lblUnit.Caption := '(C)';
        vtWeight: lblUnit.Caption := '(kg)';
        vtHeight: lblUnit.Caption := '(cm)';
        vtCircum: lblUnit.Caption := '(cm)';
        vtCVP: lblUnit.Caption := '(mmHg)';
      end
  else
      case FTemplateVitalType of
        vtTemp: lblUnit.Caption := '(F)';
        vtWeight: lblUnit.Caption := '(lb)';
        vtHeight: lblUnit.Caption := '(in)';
        vtCircum: lblUnit.Caption := '(in)';
        vtCVP: lblUnit.Caption := '(cmH20)';
      end;
  cbxInput.Hint := HintString(ckbMetric.Checked);// zzzzzzandria 2003/06/06
  SetMetricUnitLabels(IsMetric); // zzzzzzbellc 2010/05/06 Remedy: 370106
{$IFDEF METRICCONVERSION}
  if (cbxInput.Text <> '') then
    begin
      IsMetric := ckbMetric.Checked;
      case FTemplateVitalType of
        vtTemp:
          begin
           if (cbxInput.Text <> '') then
              if IsMetric then
                  cbxInput.Text := FloatToStr(convertFToC(FValueDbl))
              else
                  cbxInput.Text := FloatToStr(FValueDbl);
          end;
        vtWeight:
          begin
            if IsMetric then
                cbxInput.Text := FloatToStr(ConvertLbsToKgs(FValueDbl))
            else
                cbxInput.Text := FloatToStr(FValueDbl);
          end;
        vtHeight:
          begin
            if IsMetric then
                cbxInput.Text := FloatToStr(ConvertInToCm(FValueDbl))
            else
                cbxInput.Text := FloatToStr(FValueDbl);
          end;
        vtCircum:
          begin
            if IsMetric then
                cbxInput.Text := FloatToStr(ConvertInToCm(FValueDbl))
            else
                cbxInput.Text := FloatToStr(FValueDbl);
          end;
// zzzzzzandria 07/03/2002 ----------------------------------------------- Begin
        vtCVP:
          begin
            try
              if IsMetric then
                  cbxInput.Text := Format('%1.1f',[ConvertCMH20TommHg(FValueDbl)])
              else
                  cbxInput.Text := Format('%1.2f',[FValueDbl]);
            except
            end;
          end;
// zzzzzzandria 07/03/2002 ------------------------------------------------- end
      end;
    end;
{$ELSE}
  if (cbxInput.Text <> '') and ConversionWarning then
    ShowMessage('Units have been changed...');
{$ENDIF}
end;

function TfraGMV_InputOne2.VitalsRate: string;
var
  sValue,
  sPercent,sFlow:String;
  S: String;
begin
  if cbxRefused.Checked then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';Refused;'
  else if cbxUnavailable.Checked then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';Unavailable;'
  else if FTemplateVitalType = vtPO2 then
    begin
(*
      Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text + ';';
      if FPO2FlowRate <> '' then
        s:= FPO2FlowRate + ' l/min '
      else
        s:= '';
      if FPO2Percentage <> '' then
        Result := Result + S + FPO2Percentage + '%'
      else if FPO2FlowRate <> '' then
        Result := Result + S;
*)
      sValue := cbxInput.Text;
      sFlow := '';
      sPercent := '';

      if FPO2FlowRate <> '' then
        sFlow := FPO2FlowRate + ' l/min ';
      if FPO2Percentage <> '' then
        sPercent := FPO2Percentage + '%';

//      if sValue + sPercent + sFlow = '' then  // zzzzzzandria 2008-01-24
      if sValue = '' then
        Result := ''
      else
        Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text +
          ';' + sFlow + sPercent;

    end
  else if cbxInput.Text = '' then
    Result := ''
  else if FTemplateVitalType = vtCVP then
    begin
//      Result := GMVVitalTypeIEN[FTemplateVitalType] + Format(';%1.1f;',[FValueDbl]);
      s := Format(';%1.1f',[FValueDbl]);
      if pos('.0',s) = length(s)-1 then
        s := copy(s,1,Length(s)-2);
      Result := GMVVitalTypeIEN[FTemplateVitalType] + s + ';';
    end
  else if FTemplateVitalType = vtTemp then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl)
  else if FTemplateVitalType = vtWeight then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl)
  else if FTemplateVitalType = vtHeight then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl)
  else if FTemplateVitalType = vtPain then
    begin
      if pos('-',cbxInput.Text) <> 0 then
        Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' +
          copy(cbxInput.Text,1,pos('-',cbxInput.Text)-2)
      else
        Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text;
    end
  else if FTemplateVitalType = vtResp then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + IntToStr(FValueInt)
  else if FTemplateVitalType = vtPulse then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + IntToStr(FValueInt)
  else if FTemplateVitalType = vtBP then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text
  else
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl);
end;

function TfraGMV_InputOne2.VitalsQualifiers: string;
begin
  if cbxRefused.Checked or cbxUnavailable.Checked then
    Result := ''
  else
    Result := FVitalQualifiers;
end;

function TfraGMV_InputOne2.VitalIEN: string;
begin
  Result := GMVVitalTypeIEN[FTemplateVitalType]
end;

procedure TfraGMV_InputOne2.cbxRefusedClick(Sender: TObject);
begin
  if cbxRefused.Checked or cbxUnavailable.Checked then
    begin
      DisablePanel;
      GetParentForm(self).Perform(CM_VITALCHANGED,0,0);//2003/08/29 AAN
    end
  else
    EnablePanel;
  if cbxRefused.Checked then
    begin
      cbxUnavailable.Checked := False;
      cbxInput.Text := '';
    end;
end;

procedure TfraGMV_InputOne2.cbxUnavailableClick(Sender: TObject);
begin
  if cbxUnavailable.Checked or cbxRefused.Checked then
    begin
      DisablePanel;
      GetParentForm(self).Perform(CM_VITALCHANGED,0,0);//2003/08/29 AAN
    end
  else
    EnablePanel;
  if cbxUnavailable.Checked then
    begin
      cbxRefused.Checked := False;
      cbxInput.Text := '';
    end;
end;

procedure TfraGMV_InputOne2.DisablePanel;
begin
  SetPanelStatus(False);
end;

procedure TfraGMV_InputOne2.EnablePanel;
begin
  SetPanelStatus(True);
end;

procedure TfraGMV_InputOne2.SetPanelStatus(bStatus:Boolean);
begin
  cbxInput.Enabled := bStatus;
  cbxUnits.Enabled := bStatus;
  lblUnit.Enabled := bStatus;
  lblNum.Enabled := bStatus;
  lblVital.Enabled := bStatus;
  ckbMetric.Enabled := bStatus;
  bbtnQualifiers.Enabled :=  bStatus;
  lblQualifiers.Enabled := bStatus;
  if bStatus then
    begin
      cbxInput.Color := clWindow;
      cbxUnits.Color := clWindow;
    end
  else
    begin
      cbxInput.Color := pnlValues.Color;
      cbxUnits.Color := pnlValues.Color;
    end;
end;

procedure TfraGMV_InputOne2.cbxRefusedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ScrollBox: TScrollBox;
  i: integer;
begin
  if (ssShift in Shift) and (cbxRefused.Checked) then
    if Self.Parent is TScrollBox then
      if MessageDlg('Mark all vitals as Refused?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
        begin
          ScrollBox := TScrollBox(Self.Parent);
          for i := 0 to ScrollBox.ComponentCount - 1 do
            if ScrollBox.Components[i] is TfraGMV_InputOne2 then
              begin
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxRefused.Checked := True;
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxRefusedClick(Sender);
              end;
        end;
end;

procedure TfraGMV_InputOne2.cbxUnavailableMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ScrollBox: TScrollBox;
  i: integer;
begin
  if (ssShift in Shift) and (cbxUnavailable.Checked) then
    if Self.Parent is TScrollBox then
      if MessageDlg('Mark all vitals as Unavailable?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
        begin
          ScrollBox := TScrollBox(Self.Parent);
          for i := 0 to ScrollBox.ComponentCount - 1 do
            if ScrollBox.Components[i] is TfraGMV_InputOne2 then
              begin
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxUnavailable.Checked := True;
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxUnavailableClick(Sender);
              end;
        end;
end;

procedure TfraGMV_InputOne2.cbxInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  j, // NOIS RIC-0103-22002 Jan 27 2003
  i: integer;
begin
  i := Self.ComponentIndex;
  if Key = VK_RETURN then
    begin
      if ssShift in Shift then
        begin
          while i > 0 do
            try
              TfraGMV_InputOne2(Parent.Components[i - 1]).cbxInput.SetFocus;
              break;
            except
              i := i - 1;
            end;
          if i = 0 then
            begin
              j := Self.ComponentIndex;
              i := Parent.ComponentCount;
              while j < i do
                try
                  TfraGMV_InputOne2(Parent.Components[i - 1]).cbxInput.SetFocus;
                  break;
                except
                  i := i - 1;
                end;
              if i=j then //AAN 2003/06/04 --
                begin
                  // Try to save
                  try
                     GetParentForm(Self).Perform(CM_SAVEINPUT, 0, 0);
                  except
                  end;
                end;
            end;
        end
      else
        begin
          while i < Parent.ComponentCount - 1 do
            try
              TfraGMV_InputOne2(Parent.Components[i + 1]).cbxInput.SetFocus;
              break;
            except
              i := i + 1;
            end;
          if i = Parent.ComponentCount - 1 then
            begin
              j := Self.ComponentIndex;
              i := 0;
              while i < j do
                try
                  TfraGMV_InputOne2(Parent.Components[i]).cbxInput.SetFocus;
                  break;
                except
                  i := i + 1;
                end;
              if i=j then //AAN 2003/06/04 --
                begin     // Try to save
                  try
                     GetParentForm(Self).Perform(CM_SAVEINPUT, 0, 0);
                  except
                  end;
                end;
            end;
        end;
    end;
end;

procedure TfraGMV_InputOne2.cbxInputChange(Sender: TObject);
begin
  if (cbxInput.Text = cRefused) or (cbxInput.Text = cUnavailable) then
    SetPanelStatus(False)
  else
    SetPanelStatus(True);
  GetParentForm(self).Perform(CM_VITALCHANGED,0,0);//09/11/02
end;

procedure TfraGMV_InputOne2.cbxInputClick(Sender: TObject);
begin
  cbxInput.SelStart := 0;
end;

procedure TfraGMV_InputOne2.acMetricChangedExecute(Sender: TObject);
begin
  case FTemplateVitalType of
    vtTemp:     ckbMetric.Checked := cbxUnits.Text = 'C';
    vtWeight:   ckbMetric.Checked := cbxUnits.Text = 'kg';
    vtHeight:   ckbMetric.Checked := cbxUnits.Text = 'cm';
    vtCircum:   ckbMetric.Checked := cbxUnits.Text = 'cm';
    vtCVP:      ckbMetric.Checked := cbxUnits.Text = 'mmHg';
  end;
  cbxInput.Hint := HintString(ckbMetric.Checked);
end;

procedure TfraGMV_InputOne2.ckbMetricEnter(Sender: TObject);
begin
  bvMetric.Visible := True;
end;

procedure TfraGMV_InputOne2.ckbMetricExit(Sender: TObject);
begin
  bvMetric.Visible := False;
end;

procedure TfraGMV_InputOne2.cbxRefusedEnter(Sender: TObject);
begin
  bvR.Visible := True;
end;

procedure TfraGMV_InputOne2.cbxRefusedExit(Sender: TObject);
begin
  bvR.Visible := False;
end;

procedure TfraGMV_InputOne2.cbxUnavailableExit(Sender: TObject);
begin
  bvU.Visible := False;
end;

procedure TfraGMV_InputOne2.cbxUnavailableEnter(Sender: TObject);
begin
  bvU.Visible := True;
end;

procedure TfraGMV_InputOne2.bbtnQualifiersEnter(Sender: TObject);
begin
  bvQual.Visible := True;
  setStatusString(lblQualifiers.Caption);
end;

procedure TfraGMV_InputOne2.bbtnQualifiersExit(Sender: TObject);
begin
  bvQual.Visible := False;
  setStatusString('');
end;

//=================================================================== Validation
//==============================================================================
function MessageDlgEnteredInvalidValue(S,ErrorS:String;sType:String=''): Word;//AAN 07/03/2002
var
  ss: String;
begin
  if ErrorS = '' then
//    ss := 'The value you entered ''' + S + ''' is not valid' + #13 + #13 + ErrorS;
    ss := 'The value you entered ''' + S + ''' is not valid'
  else
    ss := ErrorS;

  if sType <> '' then
    ss := 'Vital Type: '+sType+#13#13+ss;

  result :=  MessageDlg(ss, mtError, [mbok], 0);
end;

function TfraGMV_InputOne2.Check(aDT: TDateTime):Boolean;
var
  OKToProceed: Boolean;
begin
  OKToProceed := True;
  fCheckErrorMessage := '';
  if cbxInput.Text <> '' then
    begin
      case FTemplateVitalType of

        vtUnknown:
          begin
            MessageDlg('Unknown Vital Type!', mtError, [mbok], 0);
            OKToProceed := True;
          end;

        vtBP: OKToProceed := ValidBP;
        vtTemp: OKToProceed := ValidTemperature;
        vtPulse: OKToProceed := ValidPulse;
        vtResp: OKToProceed := ValidRespiration;
        vtHeight: OKToProceed := ValidHeight(aDT);
        vtWeight: OKToProceed := ValidWeight(aDT);
        vtPain: OKToProceed := ValidPain;
        vtCircum: OKToProceed := ValidGirth;
        vtPO2: OKToProceed := ValidPO2;
        vtCVP: OKToProceed := ValidCVP;

      else
        begin
          MessageDlg('Cannot validate this vital type.', mtError, [mbok], 0);
          OKToProceed := False;
        end;
      end;
    end;

  Valid := OKToProceed;
  Result := OKToProceed;
end;



function TfraGMV_InputOne2.ValidPain: Boolean;
var
  PainValue: integer;
begin
// zzzzzzandria 050706 blank value for pain added
  if cbxInput.Text = '' then
    begin
      Result := True;
      Exit;
    end;

  if pos('-',cbxInput.Text) <> 0 then
    begin
      PainValue := StrToInt(Copy(cbxInput.Text,1,pos('-',cbxInput.Text)-2));
    end
  else
    PainValue := StrToIntDef(cbxInput.Text, -1);

  if ((PainValue >= 0) and (PainValue <= 10)) or (PainValue = 99) then
    begin
      FValueInt := PainValue;
      Result := True;
    end
  else
    begin
      MessageDlg('Pain must be a numeric value from 0 to 10 ' + #13 +
                  'or 99 if patient is unable to respond.',mtError,[],0);
      Result := False;
    end;
end;

function TfraGMV_InputOne2.ValidPO2: Boolean;
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtPO2]) and
      (tmpInt <= GMVVitalHiRange[vtPO2]) then
      begin
        {Process valid PO2 Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Pulse Ox.');
  except
    on E: EConvertError do
//      MessageDlg('The value you entered ''' + cbxInput.Text + ''' is not valid',
//        mtError, [mbok], 0);
      MessageDlgEnteredInvalidValue(cbxInput.Text,'','Pulse Ox.');
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidCVP: Boolean;
begin
  Result := False;
  if cbxInput.Text = '.' then
    begin
      MessageDlgEnteredInvalidValue(cbxInput.Text,'','CVP');//zzzzzzandria 050429
      Exit;
    end;
  try
//AAN 07/03/2002---------------------------------------------------------- Begin
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertmmHGtoCMH20(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtCVP]) and
      (tmpDouble <= GMVVitalHiRange[vtCVP]) then
      begin
        {Process valid CVP Here}
        FValueDbl := tmpDouble;
        Result := True;
      end
//AAN 07/03/2002------------------------------------------------------------ End
    else
      OutOfRange('CVP');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'CVP');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidBP: Boolean;
var
  i,iCount: Integer;
  s, sS, sD, sM: String;
  bS,bD,bM: Boolean;
  Systolic, Diastolic, Middle: integer;
begin
  Result := False;
  try
{AAN 2003/06/05-----------------------------------------------------------Start}
    s := cbxInput.Text;
    sS := trim(Piece(s, '/', 1));
    sD := trim(Piece(s, '/', 2));
    sM := trim(Piece(s, '/', 3));

    iCount := 0;
    for i := 1 to length(s) do
      if copy(s,i,1) = '/' then inc(iCount);

    s := Piece(cbxInput.Text, '/', 4);
    if (s <>'')
      or (iCount > 2)
      or (iCount < 1)
      or ((iCount=2) and (sD='') and (sM=''))
      or ((iCount=2) and (sM=''))
//      or ((iCount=1) and (sD=''))//uncomment this line to reject values like '120/'
      then
      begin
        MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP,'BP');//AAN 07/03/2002
        Exit;
      end;

    Systolic := StrToInt(sS);
    bS :=
      (Systolic >= GMVVitalLoRange[vtBP]) and
      (Systolic <= GMVVitalHiRange[vtBP]);


    if sD <> '' then
      begin
        Diastolic :=StrToInt(sD);
        s := ss + '/'+SD;// Remedy 170801
      end
    else
      begin
        s := ss+'/';// Remedy 170801
        Diastolic := -1;
      end;

    bD := (sD = '') or
      ((Diastolic >= GMVVitalLoRange[vtBP]) and
       (Diastolic <= GMVVitalHiRange[vtBP]));

    if sM <> '' then
      begin
        s := s + '/'+ sM; // Remedy 170801
        Middle :=StrToInt(sM);
      end
    else
      Middle := -1;

    bM := (sM = '') or
          ((Middle >= GMVVitalLoRange[vtBP]) and
          (Middle <= GMVVitalHiRange[vtBP]));

    Result :=(bS and bD and bM);

    if sM = '' then
      Result := Result and (Diastolic < Systolic)
    else
      Result := Result and (Middle < Systolic);

    if not Result then
      MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP,'BP')//AAN 07/03/2002
    else
      cbxInput.Text := s; // Remedy 170801

    Exit;

{AAN 2003/06/05-------------------------------------------------------------End}
    Systolic := StrToInt(Piece(cbxInput.Text, '/', 1));
    Diastolic := StrToInt(Piece(cbxInput.Text, '/', 2));
    Middle := StrToIntDef(Piece(cbxInput.Text, '/', 3), 0);
    if Diastolic = 0 then
      begin
        if
          (Systolic >= GMVVitalLoRange[vtBP]) and
          (Systolic <= GMVVitalHiRange[vtBP]) and
          (Middle >= GMVVitalLoRange[vtBP]) and
          (Middle <= GMVVitalHiRange[vtBP]) then
          begin
            Result := True;
          end
        else
          Exit;
      end;

    if (
      (Middle = 0) and
      (Systolic >= GMVVitalLoRange[vtBP]) and
      (Systolic <= GMVVitalHiRange[vtBP]) and
      (Diastolic >= GMVVitalLoRange[vtBP]) and
      (Diastolic <= GMVVitalHiRange[vtBP])
      )
      or
      (
      (Systolic >= GMVVitalLoRange[vtBP]) and
      (Systolic <= GMVVitalHiRange[vtBP]) and
      (Diastolic >= GMVVitalLoRange[vtBP]) and
      (Diastolic <= GMVVitalHiRange[vtBP]) and
      (Middle >= GMVVitalLoRange[vtBP]) and
      (Middle <= GMVVitalHiRange[vtBP])
      ) then
      begin
        Result := True;
      end
    else
      MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP,'BP');//AAN 07/03/2002
  except
    on E: EConvertError do
        MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP+#13+E.Message,'BP');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidTemperature: Boolean;
begin
  Result := False;
  try
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertCToF(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtTemp]) and
      (tmpDouble <= GMVVitalHiRange[vtTemp]) then
      begin {Process valid Temperature here}
        FValueDbl := tmpDouble;
        Result := True;
      end
    else
      OutOfRange('Temperature');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Temperature');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidPulse: Boolean;
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtPulse]) and
      (tmpInt <= GMVVitalHiRange[vtPulse]) then
      begin {Process valid Pulse Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Pulse');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Pulse');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidRespiration: Boolean;
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtResp]) and
      (tmpInt <= GMVVitalHiRange[vtResp]) then
      begin {Process valid respiration here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Respiration');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Respiration');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidWeight(aDT: TDateTime): Boolean;
var
  dd: Double;
  sCode, sUnits, sDateTime,
  sValue, sMsg,
  s: String;

  function FormatValue(aValue:String):String;
  var
    ddd: Double;
  begin
    if not ckbMetric.Checked then
      Result := aValue
    else
      begin
        ddd := StrToFloat(aValue);
        ddd := ConvertLbsToKgs(ddd);
        Result := FloatToStr(ddd);//+ 'kg';
      end;
  end;

begin
  Result := False;
  try
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertKgsToLbs(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtWeight]) and
      (tmpDouble <= GMVVitalHiRange[vtWeight]) then
      begin {Process valid weight Here}
        fValueDbl := tmpDouble;
        if aDT = 0 then
          Result := True
        else
          begin
            s := getClosestReading(DFN,
              FloatToStr(WindowsDateTimeToFMDateTime(aDT)),
              GMVVitalTypeAbbv[fTemplateVitalType],'0');

            sCode := Piece(s,'^',1);
            sValue := Piece(Piece(s,'^',2),#13,1);

            if sCode = '-1' then
              raise Exception.Create(Piece(s,'^',2))
            else if sCode = '-2' then
              begin
                sMsg := Format(fmtDoubleCheck,['weight',cWeightDelta,
                   cbxInput.Text,cbxUnits.Text, FMDateTimeStr(FloatToStr(aDT)),
                    sValue,sUnits,sDateTime]);
                Result :=  MessageDialog('Warning',sMsg,mtWarning,[mbNo,mbYes],mrNo,0)=mrYes;
              end
            else
              begin
                dd := getDelta(fValueDbl,sValue);
                if dd >= cWeightDelta then
                  begin
                    sValue := FormatValue(sValue);
                    sDateTime := FMDateTimeStr(sCode);
                    sMsg := Format(fmtDoubleCheck,['weight',cWeightDelta,
                       cbxInput.Text,cbxUnits.Text, FMDateTimeStr(FloatToStr(aDT)),
                        sValue,cbxUnits.Text,sDateTime]);
                    Result :=  MessageDialog('Warning',sMsg,mtWarning,[mbNo,mbYes],mrNo,0)=mrYes;
                  end
                else
                  Result := True;
              end;
          end;
      end
    else
      OutOfRange('Weight');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Weight');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.getLength(aString:String;aMetric:Boolean):Double;
var
  sFeet,sInches,sValue:String;
  fFeet,fInches,_Double: Double;
begin
    // Enter Height in Feet and Inches ---------------------- Start
    sValue := aString;
    _Double := 0; // zzzzzzandria 2007-07-12
    if not aMetric and
      ((pos('''',sValue) > 0 ) or (pos('"',sValue) > 0 )) then
      begin
        if pos('''',sValue) > 0 then sFeet := piece(sValue,'''',1)
        else                         sFeet := '';

        if pos('''',sValue) > 0 then sInches := piece(sValue,'''',2)
        else                         sInches := sValue;

        if pos('"',sInches) > 0 then sInches := piece(sInches,'"',1);

        try
          fFeet := 0;
          fInches := 0;
          if sFeet <> '' then fFeet := StrToFloat(sFeet);
          if sInches <> '' then fInches := StrToFloat(sInches);

          if (sFeet <> '') and (fInches > 12) then
            begin
              raise Exception.CreateFmt(
                '"%s" invalid input format',[aString]);
            end;
          _Double := 12 * fFeet + fInches;

          bIgnore := True;
          sValue := Format('%f',[_Double]);
          cbxInput.Text := sValue;
          bIgnore := False;
        except
        end;
      end
    else
      _Double := StrToFloat(aString);
  Result := _Double;
end;

function TfraGMV_InputOne2.ValidHeight(aDT: TDateTime): Boolean;
var
  dd: Double;
  sCode,sUnits,sDateTime,
  sValue,sMsg,
  s: String;

  function FormatValue(aValue:String):String;
  var
    ddd: Double;
  begin
    if not ckbMetric.Checked then
      Result := aValue
    else
      begin
        ddd := StrToFloat(aValue);
        ddd := ConvertInToCm(ddd);
        Result := FloatToStr(ddd);//+ 'cm';
      end;
  end;

begin
  Result := False;
  try
    tmpDouble := getLength(cbxInput.Text,ckbMetric.Checked);
    if ckbMetric.Checked then
      tmpDouble := ConvertCmToIn(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtHeight]) and
      (tmpDouble <= GMVVitalHiRange[vtHeight]) then
      begin  {Process valid height here}
        FValueDbl := tmpDouble;

        if aDT = 0 then
          Result := True
        else
          begin
            s := getClosestReading(DFN,FloatToStr(WindowsDateTimeToFMDateTime(aDT)),
              GMVVitalTypeAbbv[fTemplateVitalType],'0');

            sCode := Piece(s,'^',1);
            sValue := Piece(Piece(s,'^',2),#13,1);

            if sCode = '-1' then
              raise Exception.Create(Piece(s,'^',2))
            else if sCode = '-2' then
              begin
                sMsg := Format(fmtDoubleCheck,['height',cHeightDelta,
                   cbxInput.Text,cbxUnits.Text, FMDateTimeStr(FloatToStr(aDT)),
                    sValue,sUnits,sDateTime]);
                Result :=  MessageDialog('Warning',sMsg,mtWarning,[mbNo,mbYes],mrNo,0)=mrYes;
              end
            else
              begin
                dd := getDelta(fValueDbl,sValue);
                if dd >= cHeightDelta then
                  begin
                    sValue := FormatValue(sValue);
                    sDateTime := FMDateTimeStr(sCode);
                    sMsg := Format(fmtDoubleCheck,['height',cHeightDelta,
                       cbxInput.Text,cbxUnits.Text, FMDateTimeStr(FloatToStr(aDT)),
                        sValue,cbxUnits.Text,sDateTime]);
                    Result :=  MessageDialog('Warning',sMsg,mtWarning,[mbNo,mbYes],mrNo,0)=mrYes;
                  end
                else
                  Result := True;
              end;

          end;
      end
    else
      OutOfRange('Height');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Height');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidGirth: Boolean;
begin
  Result := False;
  try
//{$IFDEF R144925}
    tmpDouble := getLength(cbxInput.Text,ckbMetric.Checked);
//{$ELSE}
//    tmpDouble := StrToFloat(cbxInput.Text);
//{$ENDIF}
//    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertCmToIn(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtCircum]) and
      (tmpDouble <= GMVVitalHiRange[vtCircum]) then
      begin
        {Process valid girth here}
        FValueDbl := tmpDouble;
        Result := True;
      end
    else
      OutOfRange('Circumference/Girth');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Girth');//AAN 07/03/2002
  else
    raise;
  end;
end;

procedure TfraGMV_InputOne2.cbxInputKeyPress(Sender: TObject;
  var Key: Char);
var
  s:String;
  iLen: Integer;// = 2;
begin
//{$IFDEF R144925} // Enter Height in Feet and Inches
  if (fTemplateVitalType = vtHeight) then
    begin
      if  (pos(char(key),'0123456789."''') = 0) and
        (Key<>char(VK_Back)) then
        begin
          Key := #0;
        end;
      Exit;
    end;
//{$ENDIF}

  iLen := 2;
  if (fTemplateVitalType = vtTemp) or
     (fTemplateVitalType = vtCVP) then iLen := 1;
  if (fTemplateVitalType = vtHeight) or
    (fTemplateVitalType = vtCircum) or
    (fTemplateVitalType = vtWeight) then iLen := 2;

  if (fTemplateVitalType = vtCircum) or
    (fTemplateVitalType = vtHeight) or
    (fTemplateVitalType = vtCVP) or
    (fTemplateVitalType = vtTemp) or
    (fTemplateVitalType = vtWeight) then
    begin
      if (pos(char(Key),'0123456789.') <> 0) and (cbxInput.SelStart>=pos('.',cbxInput.Text)) then
        begin
          s := Piece(cbxInput.Text,'.',2);
          if Length(s)> iLen-1 then
            begin
              s := copy(s,1,iLen-1);
              cbxInput.Text := Piece(cbxInput.Text,'.',1)+'.'+s+Key;
              cbxInput.SelStart := pos('.',cbxInput.Text)+iLen-1;
              cbxInput.SelLength := 1;
              Key := #0;
            end;
        end;

    end;
end;

function TfraGMV_InputOne2.getStatusString;
begin
  result := lblVital.Caption;
end;

procedure TfraGMV_InputOne2.cbxInputEnter(Sender: TObject);
begin
  setStatusString(getStatusString);
end;

procedure TfraGMV_InputOne2.setStatusString(aString:String);
begin
  if not assigned(frmGMV_InputLite) then exit;
  try
    frmGMV_InputLite.StatusBar.SimpleText := '  '+aString;
  except
  end;
end;

procedure TfraGMV_InputOne2.cbxUnitsEnter(Sender: TObject);
begin
  setStatusString(cbxUnits.Text);
end;

procedure TfraGMV_InputOne2.cbxUnitsExit(Sender: TObject);
begin
  setStatusString('');
end;

end.

