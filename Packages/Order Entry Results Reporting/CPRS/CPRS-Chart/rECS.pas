unit rECS;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TECSReport = Class(TObject)
  private
    FReportHandle: string; // PCE report or Patient Summary report
    FReportType: string; // D: display  P: print
    FPrintDEV: string; // if Print, the print device IEN
    FReportStart: string; // Start Date
    FReportEnd: string; // End Date
    FNeedReason: string; // Need procedure reason ?
    FECSPermit: boolean; // Authorized use of ECS
  public
    constructor Create;

    property ReportHandle: string read FReportHandle write FReportHandle;
    property ReportType: string read FReportType write FReportType;
    property ReportStart: string read FReportStart write FReportStart;
    property ReportEnd: string read FReportEnd write FReportEnd;
    property PrintDEV: string read FPrintDEV write FPrintDEV;
    property NeedReason: string read FNeedReason write FNeedReason;
    property ECSPermit: boolean read FECSPermit write FECSPermit;
  end;

function GetVisitID: string;
function GetDivisionID: string;
function IsESSOInstalled: boolean;
procedure SaveUserPath(APathInfo: string; var CurPath: string);
procedure FormatECSDate(ADTStr: string; var AnECSRpt: TECSReport);
procedure LoadECSReportText(Dest: TStrings; AnECSRpt: TECSReport);
procedure PrintECSReportToDevice(AnECSRpt: TECSReport);

implementation

uses
  TRPCB,
  ORFn,
  rCore,
  ORNet,
  uCore;

constructor TECSReport.Create;
begin
  inherited;
  FReportHandle := '';
  FReportType := '';
  FReportStart := '';
  FReportEnd := '';
  FPrintDEV := '';
  FNeedReason := '';
  FECSPermit := False;
end;

function IsESSOInstalled: boolean;
var
  aStr: string;
begin
  if CallVistA('ORECS01 CHKESSO', [nil], aStr) then
    Result := (StrToIntDef(aStr, 0) > 0)
  else
    Result := False;
end;

function GetVisitID: string;
var
  vsitStr: string;
begin
  vsitStr := Encounter.VisitStr + ';' + Patient.DFN;
  CallVistA('ORECS01 VSITID', [vsitStr], Result);
end;

function GetDivisionID: string;
begin
  CallVistA('ORECS01 GETDIV', [nil], Result);
end;

procedure SaveUserPath(APathInfo: string; var CurPath: string);
begin
  CallVistA('ORECS01 SAVPATH', [APathInfo], CurPath);
end;

procedure FormatECSDate(ADTStr: string; var AnECSRpt: TECSReport);
var
  x, DaysBack: string;
  Alpha, Omega: double;
begin
  Alpha := 0;
  Omega := 0;
  if CharAt(ADTStr, 1) = 'T' then
    begin
      Alpha := StrToFMDateTime(Piece(ADTStr, ';', 1));
      Omega := StrToFMDateTime(Piece(ADTStr, ';', 2));
    end;
  if CharAt(ADTStr, 1) = 'd' then
    begin
      x := Piece(ADTStr, ';', 1);
      DaysBack := Copy(x, 2, Length(x));
      Alpha := StrToFMDateTime('T-' + DaysBack);
      Omega := StrToFMDateTime('T');
    end;
  AnECSRpt.ReportStart := FloatToStr(Alpha);
  AnECSRpt.ReportEnd := FloatToStr(Omega);
end;

procedure LoadECSReportText(Dest: TStrings; AnECSRpt: TECSReport);
var
  userid: string;
begin
  // Defered until we can pass in an object with the Mult=Value pair - DRP@SLC
  LockBroker;
  try
    with RPCBrokerv do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORECS01 ECRPT';
      Param[0].PType := list;
      Param[0].Mult['"ECHNDL"'] := AnECSRpt.ReportHandle;
      Param[0].Mult['"ECPTYP"'] := AnECSRpt.ReportType;
      Param[0].Mult['"ECDEV"'] := AnECSRpt.PrintDEV;
      Param[0].Mult['"ECDFN"'] := Patient.DFN;
      Param[0].Mult['"ECSD"'] := AnECSRpt.ReportStart;
      Param[0].Mult['"ECED"'] := AnECSRpt.ReportEnd;
      Param[0].Mult['"ECRY"'] := AnECSRpt.NeedReason;
      Param[0].Mult['"ECDUZ"'] := userid;
      CallBroker;
    end;
    QuickCopy(RPCBrokerv.Results, Dest);
  finally
    UnlockBroker;
  end;
end;

procedure PrintECSReportToDevice(AnECSRpt: TECSReport);
var
  userid: string;
begin
  // Defered until we can pass in an object with the Mult=Value pair - DRP@SLC
  userid := IntToStr(User.DUZ);
  LockBroker;
  try
    with RPCBrokerv do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORECS01 ECPRINT';
      Param[0].PType := list;
      Param[0].Mult['"ECHNDL"'] := AnECSRpt.ReportHandle;
      Param[0].Mult['"ECPTYP"'] := AnECSRpt.ReportType;
      Param[0].Mult['"ECDEV"'] := AnECSRpt.PrintDEV;
      Param[0].Mult['"ECDFN"'] := Patient.DFN;
      Param[0].Mult['"ECSD"'] := AnECSRpt.ReportStart;
      Param[0].Mult['"ECED"'] := AnECSRpt.ReportEnd;
      Param[0].Mult['"ECRY"'] := AnECSRpt.NeedReason;
      Param[0].Mult['"ECDUZ"'] := userid;
      CallBroker;
    end;
  finally
    UnlockBroker;
  end;
end;

end.
