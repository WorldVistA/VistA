unit uGMV_Monitor;

interface
uses
  Classes,
  XMLIntf,
  XMLDoc
  ;

type
  TfReady = function: Boolean; stdcall;
  TfReset = function: Boolean; stdcall;
  TfgetBufferLength = function: integer; stdcall;
  TfgetStatus = function: PAnsiChar; stdcall;

  TResultRecord = record
    Value: string;
    UnitsName: string;
    UnitsValue: string;
    Method: string;
    Year: string;
    Month: string;
    Day: string;
    Hour: string;
    Minute: string;
    Second: string;
  end;

  TGMV_Monitor = class(TObject)
  private
    fVendor: string;
    fModel: string;
    fSerialNumber: string;
    fSoftwareVersion: string;
    fLibraryName: string;

    fMonitorLibrary: THandle;

    fReady: TfReady;
    fReset: TfReset;
    fgetBufferLength: TfgetBufferLength;
    fgetStatus: TfgetStatus;

    rrSystolic,
      rrDiastolic,
      rrPulse,
      rrTemp,
      rrOxygen: TResultRecord;

    function getBPString: string;
    function getPulseString: string;
    function getTempString: string;
    function getTempUnitString: string;
    function getSpO2String: string;

    function getXMLString: string;
    function getDescription: string;

    procedure setUpRR(var aRR: TResultRecord; aNode: IXMLNode);
  public
    Active: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure getData(aReset: Boolean = False);

    property Vendor: string read fVendor;
    property Model: string read fModel;
    property SerialNumber: string read fSerialNumber;
    property SoftwareVersion: string read fSoftwareVersion;

    property sBP: string read getBPString;
    property sPulse: string read getPulseString;
    property sTemp: string read getTempString;
    property sTempUnit: string read getTempUnitString; // ??
    property sSpO2: string read getSpO2String;

    property XMLString: string read getXMLString;

    property LibraryName: string read fLibraryName;

    property Description: string read getDescription;

    procedure setVersionInfo;

  end;


const
  sInvalidValue = 'Invalid Value';

  tnVitals = 'Vitals';

  tnVendor = 'Vendor';
  tnModel = 'Model';
  tnSerialNumber = 'Serial_Number';
  tnResult = 'Result';

  nnTemp = 'Body_temperature';
  nnOxygen = 'Oxygen_saturation';
  nnPulse = 'Pulse';
  nnSBP = 'Systolic_blood_pressure';
  nnDBP = 'Diastolic_blood_pressure';

  nnValue = 'Value';
  nnUnits = 'Units';
  nnMethod = 'Method';
  nnTimeStamp = 'Time_stamp';

  anName = 'name';
  anYear = 'year';
  anMonth = 'month';
  anDay = 'day';
  anHour = 'hour';
  anMinute = 'minute';
  anSecond = 'second';

implementation

uses
  Windows, Forms, SysUtils, uGMV_GlobalVars, uGMV_DLLCommon, uXML, Dialogs
  ,
  {$WARN UNIT_PLATFORM OFF}
   FileCTRL
  {$WARN UNIT_PLATFORM ON}
  ;

procedure ClearResultRecord(var aR: TResultRecord);
begin
  with aR do
  begin
    Value := '';
    UnitsName := '';
    UnitsValue := '';
    Method := '';
    Year := '';
    Month := '';
    Day := '';
    Hour := '';
    Minute := '';
    Second := '';
  end;
end;

constructor TGMV_Monitor.Create;
var
  sDir, sFN: string;
  i: Integer;
  FLB: TFileListBox;
  P: Pointer;
  DLLHandle: THandle;

begin
  inherited Create;

  fVendor := 'Unknown';
  fSoftwareVersion := 'Unknown';
  fModel := 'Unknown';
  Active := False;

  FLB := TFileListBox.Create(application);
  FLB.Parent := Application.MainForm;
  FLB.Visible := False;
  FLB.Mask := '*.dll';
  sDir := ExtractFileDir(Application.ExeName) + '\' + GMV_PlugInDir;
  try
    FLB.ApplyFilePath(sDir);  // Here is where the no parent issue fires DRP@5-28-2013
    fMonitorLibrary := 0;

    for i := 0 to FLB.Items.Count - 1 do
    begin
      sFN := sDir + '\' + FLB.Items[i];
//      FindModule(sFN, GMV_PlugInReset, DLLHandle, P); 2009-04-15
      FindModule(sFN, GMV_PlugInReady, DLLHandle, P); // 2009-04-15
      if Assigned(P) then
      begin
        fLibraryName := sFN;
        fMonitorLibrary := DLLHandle;
//        fReset := p; // commented out 2009-04-15
        fReady := p;
//        if fReset then // commented out 2009-04015
        if fReady then
        begin
//          FindModule(sFN, GMV_PlugInReady, DLLHandle, P);
//          fReady := p;
          FindModule(sFN,GMV_PlugInReset,DLLHandle,P);
          fReset := P;
          FindModule(sFN, GMV_PlugInReady, DLLHandle, P);
          fgetBufferLength := P;
          FindModule(sFN, GMV_PlugInGetStatus, DLLHandle, P);
          fgetStatus := P;

//          getData(true); // commented out 2009-04-15
          setVersionInfo; // zzzzzzandria 2009-04-15
          Active := True;
          break;
        end;
        FreeLibrary(DLLHandle);
        fMonitorLibrary := 0;
      end;
    end;
  except  // Swallowing the exception tho I doubt it will work even with DLL libraries see line 163  DRP@5-28-2013
    {
    on E:Exception do
      ShowMessage('uGMV_Monitor Error: ' + E.Message);
    }
  end;
  FLB.Free;
end;

destructor TGMV_Monitor.Destroy;
begin
  if fMonitorLibrary <> 0 then
  try
    FreeLibrary(fMonitorLibrary);
  except
  end;
  inherited;
end;

function TGMV_Monitor.getBPString: string;
begin
  Result := rrSystolic.Value + '/' + rrDiastolic.Value;
  if Result = '/' then Result := '';
end;

function TGMV_Monitor.getPulseString: string;
begin
  Result := rrPulse.Value;
end;

function TGMV_Monitor.getTempString: string;
begin
  Result := rrTemp.Value;
end;

function TGMV_Monitor.getTempUnitString: string;
begin
  Result := rrTemp.UnitsName;
end;

function TGMV_Monitor.getSpO2String: string;
begin
  Result := rrOxygen.Value;
end;

function TGMV_Monitor.getXMLString: string;
begin
  Result := '';
  try // Ready always reaturns False
    if not Assigned(fReady) then
      Exit;
    if fReady then
      Result := string(AnsiString(fGetStatus))
    else
      Result := '';
//    if not Assigned(fReset) then Exit;
//    fReset;
  except
  end;
end;

procedure TGMV_Monitor.setUpRR(var aRR: TResultRecord; aNode: IXMLNode);
begin
  ClearResultRecord(aRR);
  with aRR do
  begin
    try Value := aNode.ChildNodes[nnValue].Text; except on E: Exception do ShowMessage('Setup RR Value:' + #13#10 + E.Message); end;
    try UnitsName := aNode.ChildNodes[nnUnits].GetAttribute(anName); except on E: Exception do ShowMessage('Setup RR Units Name:' + #13#10 + E.Message); end;
    try UnitsValue := aNode.ChildNodes[nnUnits].Text; except on E: Exception do ShowMessage('Setup RR Units Value:' + #13#10 + E.Message); end;
    try Method := aNode.ChildNodes[nnMethod].Text; except on E: Exception do ShowMessage('Setup RR Method:' + #13#10 + E.Message); end;

    try Year := aNode.ChildNodes[nnTimeStamp].GetAttribute(anYear); except on E: Exception do ShowMessage('Setup RR Year:' + #13#10 + E.Message); end;
    try Month := aNode.ChildNodes[nnTimeStamp].GetAttribute(anMonth); except on E: Exception do ShowMessage('Setup RR Month :' + #13#10 + E.Message); end;
    try Day := aNode.ChildNodes[nnTimeStamp].GetAttribute(anDay); except on E: Exception do ShowMessage('Setup RR day:' + #13#10 + E.Message); end;
    try Hour := aNode.ChildNodes[nnTimeStamp].GetAttribute(anHour); except on E: Exception do ShowMessage('Setup RR Hour:' + #13#10 + E.Message); end;
    try Minute := aNode.ChildNodes[nnTimeStamp].GetAttribute(anMinute); except on E: Exception do ShowMessage('Setup RR Minute:' + #13#10 + E.Message); end;
    try Second := aNode.ChildNodes[nnTimeStamp].GetAttribute(anSecond); except on E: Exception do ShowMessage('Setup RR Second:' + #13#10 + E.Message); end;
  end;
end;

procedure TGMV_Monitor.setVersionInfo;
var
  xDOC: IXMLDocument;
  xNode: IXMLNode;
  s: string;

begin
  s := XMLString;
  xDOC := XMLDocument(s);
  xNode := xDoc.ChildNodes[tnVitals];
  if Assigned(xNode) then
    begin
      fVendor := xNode.ChildNodes[tnVendor].Text;
      fModel := xNode.ChildNodes[tnModel].Text;
      fSerialNumber := xNode.ChildNodes[tnSerialNumber].Text;
//      fSoftwareVersion  := xNode.ChildNodes[tnVendor];
    end;
end;

procedure TGMV_Monitor.getData(aReset: Boolean = False);
var
  xDOC: IXMLDocument;
  xxNode,
    xNode: IXMLNode;
  s, ss: string;
  i: Integer;

begin
  s := XMLString;
  if s = '' then
  begin
    ClearResultRecord(rrSystolic);
    ClearResultRecord(rrDiastolic);
    ClearResultRecord(rrPulse);
    ClearResultRecord(rrTemp);
    ClearResultRecord(rrOxygen);
    Exit;
  end;

  xDOC := XMLDocument(s);
  xNode := xDoc.ChildNodes[tnVitals];
  if Assigned(xNode) then
  begin
    if aReset then
    begin
      fVendor := xNode.ChildNodes[tnVendor].Text;
      fModel := xNode.ChildNodes[tnModel].Text;
      fSerialNumber := xNode.ChildNodes[tnSerialNumber].Text;
//      fSoftwareVersion  := xNode.ChildNodes[tnVendor];
    end;
    for i := 0 to xNode.ChildNodes.Count - 1 do
    begin
      xxNode := xNode.ChildNodes[i];
      if xxNode.Nodename = tnResult then
      begin
        try
          ss := xxNode.GetAttribute(anName);
          if ss = nnPulse then setUpRR(rrPulse, xxNode);
          if ss = nnTemp then setUpRR(rrTemp, xxNode);
          if ss = nnOxygen then setUpRR(rrOxygen, xxNode);
          if ss = nnSBP then setUpRR(rrSystolic, xxNode);
          if ss = nnDBP then setUpRR(rrDiastolic, xxNode);
        except
          on E: Exception do
            ShowMessage('Get Data:' + #13#10 + E.Message);
        end;
      end;
    end;
  end;
  fReset; // reset is the part of the protocol
end;

function TGMV_Monitor.getDescription: string;
begin
  Result :=
    fVendor + '  ' + fModel + ' (SN: ' + fSerialNumber + ')' + #13 +
    '_____________________________' + #13 + #13 +
    'Software: ' + fSoftwareVersion;
end;

end.

