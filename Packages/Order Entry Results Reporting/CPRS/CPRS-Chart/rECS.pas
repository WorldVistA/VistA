unit rECS;

interface

uses SysUtils, Windows, Classes, Forms, ORFn, rCore, uConst, ORClasses, ORNet, uCore;

type
  TECSReport = Class(TObject)
  private
    FReportHandle: string;            // PCE report or Patient Summary report
    FReportType  : string;            // D: display  P: print
    FPrintDEV    : string;            // if Print, the print device IEN
    FReportStart : string;            // Start Date
    FReportEnd   : string;            // End Date
    FNeedReason  : string;           // Need procedure reason ?
    FECSPermit   : boolean;           // Authorized use of ECS
  public
    constructor Create;
    property ReportHandle: string       read FReportHandle  write FReportHandle;
    property ReportType  : string       read FReportType    write FReportType;
    property ReportStart : string       read FReportStart   write FReportStart;
    property ReportEnd   : string       read FReportEnd     write FReportEnd;
    property PrintDEV    : string       read FPrintDEV      write FPrintDEV;
    property NeedReason  : string       read FNeedReason    write FNeedReason;
    property ECSPermit   : boolean      read FECSPermit     write FECSPermit;
  end;

function GetVisitID: string;
function GetDivisionID: string;
function IsESSOInstalled: boolean;
procedure SaveUserPath(APathInfo: string; var CurPath: string);
procedure FormatECSDate(ADTStr: string; var AnECSRpt: TECSReport);
procedure LoadECSReportText(Dest: TStrings; AnECSRpt: TECSReport);
procedure PrintECSReportToDevice(AnECSRpt: TECSReport);

implementation
uses TRPCB;

constructor TECSReport.Create;
begin
  ReportHandle := '';
  ReportType   := '';
  ReportStart  := '';
  ReportEnd    := '';
  PrintDEV     := '';
  FNeedReason  := '';
  ECSPermit    := False;
end;

function IsESSOInstalled: boolean;
var
  rtn: integer;
begin
  Result := False;
  rtn := StrToIntDef(SCallV('ORECS01 CHKESSO',[nil]),0);
  if rtn > 0 then
    Result := True;
end;

function GetVisitID: string;
var
  vsitStr: string;
begin
  vsitStr := Encounter.VisitStr + ';' + Patient.DFN;
  Result := SCallV('ORECS01 VSITID',[vsitStr]);
end;

function GetDivisionID: string;
var
  divID: string;
begin
  divID := SCallV('ORECS01 GETDIV',[nil]);
  Result := divID;
end;

procedure SaveUserPath(APathInfo: string; var CurPath: string);
begin
  CurPath := SCallV('ORECS01 SAVPATH',[APathInfo]);
end;

procedure FormatECSDate(ADTStr: string; var AnECSRpt: TECSReport);
var
  x,DaysBack :string;
  Alpha, Omega: double;
begin
  Alpha := 0;
  Omega := 0;
  if CharAt(ADTStr, 1) = 'T' then
  begin
    Alpha := StrToFMDateTime(Piece(ADTStr,';',1));
    Omega := StrToFMDateTime(Piece(ADTStr,';',2));
  end;
  if CharAt(ADTStr, 1) = 'd' then
  begin
    x := Piece(ADTStr,';',1);
    DaysBack := Copy(x, 2, Length(x));
    Alpha := StrToFMDateTime('T-' + DaysBack);
    Omega := StrToFMDateTime('T');
  end;
  AnECSRpt.ReportStart := FloatToStr(Alpha);
  AnECSRpt.ReportEnd   := FloatToStr(Omega);
end;

procedure LoadECSReportText(Dest: TStrings; AnECSRpt: TECSReport);
var
  userid: string;
begin
  with RPCBrokerv do
  begin
    ClearParameters := True;
    RemoteProcedure := 'ORECS01 ECRPT';
    Param[0].PType  := list;
    Param[0].Mult['"ECHNDL"'] := AnECSRpt.ReportHandle;
    Param[0].Mult['"ECPTYP"'] := AnECSRpt.ReportType;
    Param[0].Mult['"ECDEV"']  := AnECSRpt.PrintDEV;
    Param[0].Mult['"ECDFN"']  := Patient.DFN;
    Param[0].Mult['"ECSD"']   := AnECSRpt.ReportStart;
    Param[0].Mult['"ECED"']   := AnECSRpt.ReportEnd;
    Param[0].Mult['"ECRY"']   := AnECSRpt.NeedReason;
    Param[0].Mult['"ECDUZ"']  := userid;
    CallBroker;
  end;
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure PrintECSReportToDevice(AnECSRpt: TECSReport);
var
  userid: string;
begin
  userid := IntToStr(User.DUZ);
  with RPCBrokerV do
  begin
    clearParameters := True;
    RemoteProcedure := 'ORECS01 ECPRINT';
    Param[0].PType := List;
    Param[0].Mult['"ECHNDL"'] := AnECSRpt.ReportHandle;
    Param[0].Mult['"ECPTYP"'] := AnECSRpt.ReportType;
    Param[0].Mult['"ECDEV"']  := AnECSRpt.PrintDEV;
    Param[0].Mult['"ECDFN"']  := Patient.DFN;
    Param[0].Mult['"ECSD"']   := AnECSRpt.ReportStart;
    Param[0].Mult['"ECED"']   := AnECSRpt.ReportEnd;
    Param[0].Mult['"ECRY"']   := AnECSRpt.NeedReason;
    Param[0].Mult['"ECDUZ"']  := userid;
    CallBroker;
  end;
end;

end.
