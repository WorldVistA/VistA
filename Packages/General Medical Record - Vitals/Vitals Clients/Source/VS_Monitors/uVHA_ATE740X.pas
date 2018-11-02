unit uVHA_ATE740X;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/20/09 3:56p $
*       Developer:    dddddddddomain.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  CASMED Vitals Signs Monitor support
*
*       Notes:
================================================================================
}

interface
uses
  RS232, Classes, SysUtils, Dialogs, Controls, Forms;

const
  iLimit = 200; //  milliseconds to wait for COM port

type
  TStatusIndicator = procedure(aStatus:String) of object;

  TATE740X = class(TObject)
  private
    ComPort: TComPort;
    fBootVersion,
    fPICVersion,
    fNBPVersion,
    fTempVersion,
    fSoftwareVersion,
    fSoftwaredate,
    fModel,
    fSerial,
    fReadings:String;
    fMeasurements: TStringList;
    function getActionResult(anAction,aResultCode:String;
      aResultLength:Integer;aTimeout:Integer = iLimit):String;

    function getDateTime:String;
    function getNumerics:String;
    function getBatteryVoltage:String;
    function getBatteryCharge:String;

//    function getPneumaticTestResults:TStringList;
    function getMeasurements:TStringList;

    function getSystolic:Integer;
    function getDiastolic:Integer;
    function getTemp: Real;
    function getMAP: Integer;
    function getSpo2:Integer;
    function getPulse:Integer;
    function getTempUnits:String;

    function getSBP:String;
    function getSTemp:String;
    function getSPulse:String;
    function getSSpO2:String;

    function getModel:String;
    function getSerial:String;
    function getDescription:String;
    procedure getSoftwareVersion;
    function getSWVersion:String;
  public
//    property ComPortname:String read fComPortName;  zzzzzzandria 20080109
    ComPortName:String; // zzzzzzandria 20080109
    StatusIndicator: TStatusIndicator;

    property SoftwareVersion:String read fSoftwareVersion;
    property BootVersion:String read fBootVersion;
    property PICVersion:String read fPICVersion;
    property NBPVersion:String read fNBPVersion;
    property TempVersion:String read fTempVersion;

    property SoftwareDate:String read fSoftwareDate;
    property Model:String read getModel;
    property SerialNumber:String read getSerial;

    property iSystolic:Integer read getSystolic;
    property iDiastolic:Integer read getDiastolic;
    property fTemp: Real read getTemp;
    property TempUnit: String read getTempUnits;
    property iMAP: Integer read getMap;
    property iSpo2:Integer read getSpO2;
    property iPulse:Integer read getPulse;

    property sBP: String read getSBP;
    property sTemp: String read getSTemp;
    property sPulse:String read getsPulse;
    property sSpO2:String read getSSpO2;

    property DateTime:String read getDateTime;
    property Numerics: String read getNumerics;
    property BatteryVoltage:String read getbatteryVoltage;
    property BatteryCharge: String read getBatteryCharge;

//    property PneumaticTest:TStringList read getPneumaticTestResults;
    property NIBP:TStringList read getMeasurements;
//    property Measurements: TStringList read fMeasurements;
    property Description:String read getDescription;

    constructor Create(aPortName:String=''); // parameter added zzzzzzandria 20080109
    destructor Destroy;override;

    procedure NewPatient;

    procedure ClosePort;
  end;

const
  cmsCreated = 'Created';
  cmsError = 'Error';
  cmsReady = 'Ready';

  errCheckStatus = 'Please verify that the monitor is connected and turned on.';
  _errCasmedNotFound = 'Monitor not found';

function getCasmedDescription(aCasmed: TATE740X;aCasmedPort:String;
  StatusIndicator: TStatusIndicator=nil): String;
function newATE740X(var CasmedPort,ErrorMsg:String;
  StatusIndicator: TStatusIndicator=nil): TATE740X;

implementation

const
  cUnknown =            'Unknown';
  arError =             'ERROR';

  acDateTime =          'X08'+#13;
  acNumericValues =     'X09'+#13;
// Requests ====================================================================
//                      X032     “X03 2.0”            PIC Version 2.0
//                      X033     “X02 1.1”            NIBP Module Version 1.1
//                      X034     “X02  14”            Temp Module Version 14

  cmGetBatteryVoltage = 'X20';
  cmGetSoftwareVersion ='X030';
  cmGetBootVersion =    'X031'; // “X032.0 “            Boot Version 2.0
  cmGetPICVersion =     'X032';
  cmGetNBPVersion =     'X033';
  cmGetTempVersion =    'X034';
  cmGetModel =          'X04';
  cmGetSerial =         'X05';
  cmGetDateTime =       'X08';
  cmGetNumericValues =  'X09';
  cmStopMeasurement =   'X130';
  cmStartMeasurement =  'X131';
  cmStartSTATMeasurement = 'X132';
  cmExitmanometerMode = 'X140';
  cmEnterManometerMode ='X141';
  cmStartPneumaticTest ='X151';
  cmStopPneumaticTest = 'X150';
  cmGetBatteryCharge =  'X18';
  cmNewPatient =        'X37';

// Responses ===================================================================
  rspGetSoftwareVersion = 'X03';
  rspGetBootVersion =   'X031';
  rspGetPICVersion =    'X032';
  rspGetNBPVersion =    'X033';
  rspGetTempVersion =   'X034';
  rspGetModel =         'X04';
  rspGetSerial =        'X05';
  rspDateTime =         'X08';
  rspNumericValues =    'X09';
  rspNIBPMeasurement =  'X13';
  rspNIBPManometerMode ='X14';//response is sent while in the manometer mode
  rspNIBPPneumaticTest ='X15';
  rspBatteryCharge =    'X18';
  rspBatteryVoltage =   'X20';
  rspUnknown =          'X??';
  rspATEDisabled =      'X**';

  // CASMED supports 740-3MS 740-2T 740-3ML and software 2.2 and up
  // 2008-04-23 zzzzzzandria 740-3NL added to the list of supportedinstruments.
  // GUI version: 5.0.22.6
  const
    cSupportedUnits = '740-3MS 740-2T 740 2T 740-3NL 740M-3NL ';
    cSupportedSoftvare = ' 2.2'; // v. 5.0.2.1

function StripFirstChar(aChar:Char;aValue:String):String;
var
  s: String;
begin
  Result := aValue;
  s := aValue;
  while pos(aChar,s) = 1 do
    s := copy(s,2,Length(s));
  Result := s;
end;

function getCasmedDescription(aCasmed: TATE740X;aCasmedPort:String;
  StatusIndicator: TStatusIndicator=nil): String;
var
  aCM: TATE740X;
  sCasmedError: String;
begin
  Screen.Cursor := crHourGlass;
  if not Assigned(aCasmed) then
    begin
      aCM := newATE740X(aCasmedPort,sCasmedError,StatusIndicator); //TATE740X.Create(aCasmedPort);
      if not Assigned(aCM) then
        Result := errCheckStatus
      else
        Result := aCM.Description;
      FreeAndNil(aCM);
    end
  else
    Result := aCasmed.Description;

  Screen.Cursor := crDefault;
end;

function newATE740X(var CasmedPort,ErrorMsg:String;
  StatusIndicator: TStatusIndicator=nil): TATE740X;
var
  CasmedModel,
  CasmedSoftware,
  ErrorItem,
  ErrorList: String;
  i: Integer;
  CM: TATE740X;
  sPortName:String;

  function SupportedModel(aValue:String):Boolean;
  begin
    Result := pos(trim(uppercase(aValue)),cSupportedUnits) > 0;// aValue = cSupportedUnit;
  end;

  function SupportedSoftware(aValue:String):Boolean;
  var
    f: Double;
  begin
    try
      f := strToFloat(aValue);
    except
      on E: Exception do
        f := 0.0;
    end;
    Result := f >=2.2;
  end;

  function CasmedOnPort(aPortName:String): TATE740X;
  var
    sValue: String;
    aCM: TATE740X;
  begin
    aCM := TATE740X.Create(aPortName);
    if Assigned(aCM) then
      begin
        sValue := aCM.Model;
        if not SupportedModel(sValue) then
          begin
            ErrorItem := 'Sorry. The model <'+sValue+'> is not supported.';
            FreeAndNil(aCM);
          end
        else
          CasmedModel := sValue;
      end;
    if Assigned(aCM) then
      begin
        sValue := aCM.getSWVersion;
        if not SupportedSoftware(sValue) then
          begin
            ErrorItem := 'Sorry. The software version <'+sValue+'> is not supported.';
            FreeAndNil(aCM);
          end
        else
          CasmedSoftware := sValue;
      end;
    Result := aCM;
  end;

begin
  ErrorItem := '';
  ErrorList := '';

  if CasmedPort = '' then
    begin
      for i := 1 to 8 do
        begin
          sPortName := 'COM'+IntToStr(i);
          if Assigned(StatusIndicator) then
            StatusIndicator('Looking for CASMED on Port: '+sPortName);
          CM := CasmedOnPort(sPortName);
          if CM <> nil then
            begin
              CasmedPort := 'COM'+IntToStr(i);
              break;
            end;
          ErrorList := ErrorList + ErrorItem+#13;
        end;
    end
  else
    begin
      if Assigned(StatusIndicator) then
        StatusIndicator('Looking for CASMED on Port: '+CasmedPort);
      CM := CasmedOnPort(CasmedPort);
    end;

  if assigned(CM) then
    CM.StatusIndicator := StatusIndicator;

  if Assigned(StatusIndicator) then
    begin
      StatusIndicator('Port: '+CasmedPort);
      if Assigned(CM) then
        begin
          StatusIndicator('Model: '+CasmedModel);
          StatusIndicator('Status: Connected');
          StatusIndicator('');
        end
      else
        begin
          StatusIndicator('Model: Unknown');
          StatusIndicator('Status: Unknown');
          StatusIndicator(errCheckStatus{errCasmedNotFound});
        end;
    end;

  Result := CM;
  ErrorMsg := ErrorList;
end;

////////////////////////////////////////////////////////////////////////////////

constructor TATE740X.Create(aPortName:String='');
begin
  TObject.Create;                       // zzzzzzandria 20090109
  ComPortName := aPortName;             // zzzzzzandria 20090109
  ComPort := TComPort.Create;
  fMeasurements := TStringList.Create;
  fBootVersion := cUnknown;
  fPICVersion := cUnknown;
  fNBPVersion := cUnknown;
  fTempVersion := cUnknown;
  fSoftwareversion := 'Unknown'
end;

destructor TATE740X.Destroy;
begin
  FreeAndNil(ComPort);
  FreeAndNil(fMeasurements);
  inherited;
end;

function TATE740X.getActionResult(anAction,aResultCode:String;
  aResultLength:Integer;aTimeout:Integer = iLimit):String;
var
  i: Integer;
begin
  result := arError;
  if ComPort.ComPortStatus <> cpsOpened then // zzzzzzandria 20090115
    if ComPort.Open(ComPortName) then // Port added.  zzzzzzandria 20090109
      ComPort.Config;

  i := 0;
  if ComPort.Write(anAction+#13) then
    while (pos(aResultCode, ComPort.CommandResults) = 0) do
      begin
        inc(i);
        sleep(aTimeout);
        Comport.Read(aResultLength);
        if i>1 then break;
      end;
  if (pos(aResultCode, ComPort.CommandResults) <> 0) then
    result := ComPort.CommandResults;

  ComPort.Purge;
  ComPort.Close;// zzzzzzandria 2009-01-20
end;

function TATE740X.getModel:String;
begin
  if Assigned(StatusIndicator) then
    StatusIndicator('Collecting monitor model information...');
  fModel := copy(GetActionResult(cmGetModel,rspGetModel,12),4,8);
  Result := fModel;
  if Assigned(StatusIndicator) then
    StatusIndicator('');
end;

function TATE740X.getSWVersion:String;
var
  sl: TSTringList;
begin
  if Assigned(StatusIndicator) then
    StatusIndicator('Collecting software version...');
  Result := GetActionResult(cmGetSoftwareVersion,rspGetSoftwareVersion,80,1000);
  if Result <> arError then
    begin
      sl := TstringList.Create;
      sl.Text := Result;
      if sl.Count > 0 then
        Result := copy(sl[0],5,Length(sl[0]))
      else
        Result := 'Unknown';
    end;
  if Assigned(StatusIndicator) then
    StatusIndicator('');
end;

procedure TATE740X.getSoftwareVersion;
var
  s: String;
  SL: TStringList;

  function SetValue(aValue:String;aPos,aLen:Integer):String;
    begin
      if aValue = arError then Result := 'Unknown'
      else
        Result := copy(aValue,aPos,aLen);
    end;

begin
  if Assigned(StatusIndicator) then
    StatusIndicator('Collecting software version information...');
  s := GetActionResult(cmGetSoftwareVersion,rspGetSoftwareVersion,80,1000);
  if s <> arError then
    begin
      SL:= TStringList.Create;
      SL.Text := s;
      if SL.Count > 0 then
        fSoftwareVersion := copy(SL[0],5,Length(SL[0]));

      if SL.Count > 1 then
        fSoftwareDate := copy(SL[1],3,2)+'/'+copy(sl[1],1,2)+'/'+copy(sl[1],5,2)
      else
        fSoftwareDate := 'Unknown';
      SL.Free;

      if Assigned(StatusIndicator) then
        StatusIndicator('Collecting Boot version...');
      fBootVersion :=SetValue(GetActionResult(cmGetBootVersion,rspGetBootVersion,8),5,4);
      if Assigned(StatusIndicator) then
        StatusIndicator('Collecting RIC version...');
      fPICVersion := SetValue(GetActionResult(cmGetPICVersion,rspGetPICVersion,8),5,4);
      if Assigned(StatusIndicator) then
        StatusIndicator('Collecting NBP version...');
      fNBPVersion := Setvalue(GetActionResult(cmGetNBPVersion,rspGetNBPVersion,8),5,4);
      if Assigned(StatusIndicator) then
        StatusIndicator('Collecting Temp version...');
      fTempVersion := Setvalue(GetActionResult(cmGetTempVersion,rspGetTempVersion,8),5,4);
    end;
  if Assigned(StatusIndicator) then
    StatusIndicator('');
end;

function TATE740X.getSerial:String;
begin
  if Assigned(StatusIndicator) then
    StatusIndicator('Collecting monitor Serial number information...');
  fSerial := copy(GetActionResult(cmGetSerial,rspGetSerial,12),4,8);
  Result := fSerial;
  if Assigned(StatusIndicator) then
    StatusIndicator('');
end;

function TATE740X.getDescription:String;
begin
//  Result := Model + #13#10+  SerialNumber;
  if Assigned(StatusIndicator) then
    StatusIndicator('Collecting version information...');
  getSoftwareVersion;
  Result :=
    'CASMED '+Model+ ' (SN: '+SerialNumber+')  at '+ComPortname+#13+
    '___________________________________'+#13+#13+#9+
    'Software: '+SoftwareVersion+' ( Date: '+SoftwareDate+')'+#13+#9+#9+
    'Boot: '+#9+BootVersion+#13+#9+#9+
    'PIC: '+#9+PICVersion+#13+#9+#9+
    'NBP: '+#9+NBPVersion+#13+#9+#9+
    'Temp: '+#9+TempVersion;
  if Assigned(StatusIndicator) then
    StatusIndicator('');
end;

function TATE740X.getDateTime:String;
begin
  Result := GetActionResult(cmGetDateTime,rspDateTime,16);
end;

function TATE740X.getNumerics:String;
begin
  if Assigned(StatusIndicator) then
    StatusIndicator('Requesting monitor readings...');
  fReadings := GetActionResult(cmGetNumericValues,rspNumericValues,24);
  if Assigned(StatusIndicator) then
    StatusIndicator('');
  Result := fReadings;
end;

function TATE740X.getBatteryVoltage:String;
begin
  Result := GetActionResult(cmGetBatteryVoltage,rspBatteryVoltage,9);
end;

function TATE740X.getBatteryCharge:String;
begin
  Result := GetActionResult(cmGetBatteryCharge,rspBatteryCharge,7);
end;

function TATE740X.getMeasurements:TStringList;
var
  i: Integer;
begin
  i := 0;
  fMeasurements.Clear;
  ComPort.CommandResults := '';
  if ComPort.Open(ComPortName) then // zzzzzzandria 20090109
    ComPort.Config;

  ComPort.Write(cmStartMeasurement+#13);
  while i < iLimit do
    begin
      inc(i);
      if ComPort.Read(7) then
        if (pos('X13', ComPort.CommandResults) = 1) then
          begin
            fMeasurements.Add(ComPort.CommandResults);
            i := 0;
          end;
    end;
  ComPort.Write(cmStopMeasurement);
  ComPort.Purge;
  ComPort.Close;
  Result := fMeasurements;
end;

function TATE740X.getSystolic:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,4,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getDiastolic:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,7,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getTemp: Real;
var
  s,ss: String;
begin
  try
    s := copy(fReadings,19,3);
    ss := copy(fReadings,22,1);
    if pos(ss,'0123456789') > 0 then
      s := s + ss;
    Result := StrToIntDef(s,-1) / 10.0;
  except
    Result := -1;
  end;
end;

function TATE740X.getMAP: Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,10,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getSpo2:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,16,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getPulse:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,13,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getTempUnits:String;
var
  s : String;
begin
  try
    s := copy(fReadings,22,1);
    if pos(s,'0123456789') > 0 then
      s := copy(fReadings,23,1);
    if (s<>'C') and (s<>'F') then s := '';
    Result := s;
  except
    Result := '';
  end;
end;

function TATE740X.getSBP:String;
var
  i: Integer;
  s: String;
begin
  Result := '';
  try
    s := copy(fReadings,4,3);
    while copy(s,1,1) = '0' do  s := Copy(s,2,length(s));
    i := StrToIntDef(s,-1);
    if i < 0 then Exit;
    Result := s + '/';
    s := copy(fReadings,7,3);
    while copy(s,1,1) = '0' do  s := Copy(s,2,length(s));
    i := StrToIntDef(s,-1);
    if i < 0 then
      begin
        Result := '';
        Exit;
      end;
    Result := Result + s;
  except
    Result := '';
  end;
end;

function TATE740X.getSTemp:String;
begin
  try
    if fTemp > 0 then
      Result := Format('%5.1f',[fTemp])
    else
      Result := '';
  except
    Result := '';
  end;
end;

function TATE740X.getSPulse:String;
begin
  try
    if iPulse < 0 then
      Result := ''
    else
      begin
        Result := copy(fReadings,13,3);
        Result := StripFirstChar('-',Result);
        Result := StripFirstChar(' ',Result);
        Result := StripFirstChar('0',Result);
      end;
  except
    Result := '';
  end;
end;

function TATE740X.getSSpO2:String;
begin
  try
    if iSpO2 < 0 then
      Result := ''
    else
      begin
        Result := copy(fReadings,16,3);
        Result := StripFirstChar('-',Result);
        Result := StripFirstChar('0',Result);
      end;
  except
    Result := '';
  end;
end;

procedure TATE740X.NewPatient;
begin
  if Assigned(StatusIndicator) then
    StatusIndicator('Cleaning data buffer...');
  getActionResult(cmNewPatient+#13,cmNewPatient+#13,Length(cmNewPatient+#13));
  if Assigned(StatusIndicator) then
    StatusIndicator('');
end;

procedure TATE740X.ClosePort;
begin
  ComPort.Close;
end;

(*
function TATE740X.getPneumaticTestResults:TStringList;
var
  i: Integer;
begin
  i := 0;
  fMeasurements.Clear;
  ComPort.CommandResults := '';
  if ComPort.Open(ComPortName) then // zzzzzzandria 20090109
    ComPort.Config;

  ComPort.Write(cmStartPneumaticTest+#13);
  while i < iLimit do
    begin
      inc(i);
      if ComPort.Read(8) then
        if (pos('X15', ComPort.CommandResults) = 1) then
          begin
            fMeasurements.Add(ComPort.CommandResults);
            i := 0;
            if (ComPort.CommandResults = 'X15PASS') or
               (ComPort.CommandResults = 'X15FAIL') then break;
          end;
    end;
  ComPort.Write(cmStopPneumaticTest);
  ComPort.Purge;
  ComPort.Close;
  Result := fMeasurements;
end;
*)
end.

