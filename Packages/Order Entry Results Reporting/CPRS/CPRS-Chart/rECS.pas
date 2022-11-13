unit rECS;

interface

uses
  System.SysUtils,
  System.Classes;

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

uses
  TRPCB,
  ORFn,
  rCore,
  ORNet, ORNetIntf,
  uCore;

constructor TECSReport.Create;
begin
  inherited;
  FReportHandle := '';
  FReportType := '';
  FReportStart := '';
  FReportEnd := '';
  FPrintDEV := '';
  FNeedReason  := '';
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
  aList: iORNetMult;
begin
  // Defered until we can pass in an object with the Mult=Value pair - DRP@SLC
  NewORNetMult(aList);
  userid := IntToStr(User.DUZ);
  aList.AddSubscript(['ECHNDL'], AnECSRpt.ReportHandle);
  aList.AddSubscript(['ECPTYP'], AnECSRpt.ReportType);
  aList.AddSubscript(['ECDEV'], AnECSRpt.PrintDEV);
  aList.AddSubscript(['ECDFN'], Patient.DFN);
  aList.AddSubscript(['ECSD'], AnECSRpt.ReportStart);
  aList.AddSubscript(['ECED'], AnECSRpt.ReportEnd);
  aList.AddSubscript(['ECRY'], AnECSRpt.NeedReason);
  aList.AddSubscript(['ECDUZ'], userid);
  CallVistA('ORECS01 ECRPT', [aList], Dest);
end;

procedure PrintECSReportToDevice(AnECSRpt: TECSReport);
var
  userid: string;
  aList: iORNetMult;
begin
  // Defered until we can pass in an object with the Mult=Value pair - DRP@SLC
  userid := IntToStr(User.DUZ);
  NewORNetMult(aList);
  aList.AddSubscript(['ECHNDL'], AnECSRpt.ReportHandle);
  aList.AddSubscript(['ECPTYP'], AnECSRpt.ReportType);
  aList.AddSubscript(['ECDEV'], AnECSRpt.PrintDEV);
  aList.AddSubscript(['ECDFN'], Patient.DFN);
  aList.AddSubscript(['ECSD'], AnECSRpt.ReportStart);
  aList.AddSubscript(['ECED'], AnECSRpt.ReportEnd);
  aList.AddSubscript(['ECRY'], AnECSRpt.NeedReason);
  aList.AddSubscript(['ECDUZ'], userid);
  CallVistA('ORECS01 ECPRINT', [aList]);
end;

end.
