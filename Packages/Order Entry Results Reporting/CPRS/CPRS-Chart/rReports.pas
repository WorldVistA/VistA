unit rReports;

interface

uses Windows, SysUtils, Classes, ORNet, ORFn, ComCtrls, Chart, graphics;

{ Consults }
procedure ListConsults(Dest: TStrings);
procedure LoadConsultText(Dest: TStrings; IEN: Integer);

{ Reports }
procedure ListReports(Dest: TStrings);
procedure ListLabReports(Dest: TStrings);
procedure ListReportDateRanges(Dest: TStrings);
procedure ListHealthSummaryTypes(Dest: TStrings);
procedure ListImagingExams(Dest: TStrings);
procedure ListProcedures(Dest: TStrings);
procedure ListNutrAssessments(Dest: TStrings);
procedure ListSurgeryReports(Dest: TStrings);
procedure ColumnHeaders(Dest: TStrings; AReportType: String);
procedure SaveColumnSizes(aColumn: String);
procedure LoadReportText(Dest: TStrings; ReportType: string; const Qualifier: string; ARpc, AHSTag: string);
procedure RemoteQueryAbortAll;
procedure RemoteQuery(Dest: TStrings; AReportType: string; AHSType, ADaysback,
            AExamID: string; Alpha, AOmega: Double; ASite, ARemoteRPC, AHSTag: String);
procedure DirectQuery(Dest: TStrings; AReportType: string; AHSType, ADaysback,
            AExamID: string; Alpha, AOmega: Double; ASite, ARemoteRPC, AHSTag: String);
function ReportQualifierType(ReportType: Integer): Integer;
function ImagingParams: String;
function AutoRDV: String;
function HDRActive: String;
procedure PrintReportsToDevice(AReport: string; const Qualifier, Patient,
     ADevice: string; var ErrMsg: string; aComponents: TStringlist;
     ARemoteSiteID, ARemoteQuery, AHSTag: string);
function HSFileLookup(aFile: String; const StartFrom: string;
         Direction: Integer): TStrings;
procedure HSComponentFiles(Dest: TStrings; aComponent: String);
procedure HSSubItems(Dest: TStrings; aItem: String);
procedure HSReportText(Dest: TStrings; aComponents: TStringlist);
procedure HSComponents(Dest: TStrings);
procedure HSABVComponents(Dest: TStrings);
procedure HSDispComponents(Dest: TStrings);
procedure HSComponentSubs(Dest: TStrings; aItem: String);
procedure HealthSummaryCheck(Dest: TStrings; aQualifier: string);
function GetFormattedReport(AReport: string; const Qualifier, Patient: string;
           aComponents: TStringlist; ARemoteSiteID, ARemoteQuery, AHSTag: string): TStrings;
procedure PrintWindowsReport(ARichEdit: TRichEdit; APageBreak, ATitle: string;
  var ErrMsg: string; IncludeHeader: Boolean = false);
function DefaultToWindowsPrinter: Boolean;
procedure PrintGraph(GraphImage: TChart; PageTitle: string);
procedure PrintBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap);
procedure CreatePatientHeader(var HeaderList: TStringList; PageTitle: string);
procedure SaveDefaultPrinter(DefPrinter: string) ;
function GetRemoteStatus(aHandle: string): String;
function GetAdhocLookup: integer;
procedure SetAdhocLookup(aLookup: integer);
procedure GetRemoteData(Dest: TStrings; aHandle: string; aItem: PChar);
procedure ModifyHDRData(Dest: string; aHandle: string; aID: string);
procedure PrintVReports(Dest, ADevice, AHeader: string; AReport: TStringList);

implementation

uses uCore, rCore, Printers, clipbrd, uReports, fReports;

var
  uTree:       TStringList;
  uReportsList:    TStringList;
  uLabReports: TStringList;
  uDateRanges: TStringList;
  uHSTypes:    TStringList;

{ Consults }

procedure ListConsults(Dest: TStrings);
var
  i: Integer;
  x: string;
begin
  CallV('ORWCS LIST OF CONSULT REPORTS', [Patient.DFN]);
  with RPCBrokerV do
  begin
    SortByPiece(TStringList(Results), U, 2);
    InvertStringList(TStringList(Results));
    SetListFMDateTime('dddddd', TStringList(Results), U, 2);
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      x := Pieces(x, U, 1, 2) + U + Piece(x, U, 3) + '  (' + Piece(x, U, 4) + ')';
      Results[i] := x;
    end;
    FastAssign(Results, Dest);
  end;
end;

procedure LoadConsultText(Dest: TStrings; IEN: Integer);
begin
  CallV('ORWCS REPORT TEXT', [Patient.DFN, IEN]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

{ Reports }

procedure ExtractSection(Dest: TStrings; const Section: string; Mixed: Boolean);
var
  i: Integer;
begin
  with RPCBrokerV do
  begin
    i := -1;
    repeat Inc(i) until (i = Results.Count) or (Results[i] = Section);
    Inc(i);
    while (i < Results.Count) and (Results[i] <> '$$END') do
    begin
      {if (Pos('OR_ECS',UpperCase(Results[i]))>0) and (not uECSReport.ECSPermit) then
      begin
        Inc(i);
        Continue;
      end;}
      if Mixed = true then
        Dest.Add(MixedCase(Results[i]))
      else
        Dest.Add(Results[i]);
      Inc(i);
    end;
  end;
end;

procedure LoadReportLists;
begin
  CallV('ORWRP REPORT LISTS', [nil]);
  uDateRanges := TStringList.Create;
  uHSTypes    := TStringList.Create;
  uReportsList    := TStringList.Create;
  ExtractSection(uDateRanges, '[DATE RANGES]', true);
  ExtractSection(uHSTypes,    '[HEALTH SUMMARY TYPES]', true);
  ExtractSection(uReportsList,    '[REPORT LIST]', true);
end;

procedure LoadLabReportLists;
begin
  CallV('ORWRP LAB REPORT LISTS', [nil]);
  uLabReports  := TStringList.Create;
  ExtractSection(uLabReports, '[LAB REPORT LIST]', true);
end;

procedure LoadTree(Tab: String);
begin
  CallV('ORWRP3 EXPAND COLUMNS', [Tab]);
  uTree    := TStringList.Create;
  ExtractSection(uTree, '[REPORT LIST]', false);
end;

procedure ListReports(Dest: TStrings);
var
  i: Integer;
begin
  if uTree = nil
    then LoadTree('REPORTS')
  else
    begin
      uTree.Clear;
      LoadTree('REPORTS');
    end;
  for i := 0 to uTree.Count - 1 do Dest.Add(Pieces(uTree[i], '^', 1, 20));
end;

procedure ListLabReports(Dest: TStrings);
var
  i: integer;
begin
  {if uLabreports = nil then LoadLabReportLists;
  for i := 0 to uLabReports.Count - 1 do Dest.Add(Pieces(uLabReports[i], U, 1, 10)); }
  if uTree = nil
    then LoadTree('LABS')
  else
    begin
      uTree.Clear;
      LoadTree('LABS');
    end;
  for i := 0 to uTree.Count - 1 do Dest.Add(Pieces(uTree[i], '^', 1, 20));
end;

procedure ListReportDateRanges(Dest: TStrings);
begin
  if uDateRanges = nil then LoadReportLists;
  FastAssign(uDateRanges, Dest);
end;

procedure ListHealthSummaryTypes(Dest: TStrings);
begin
  if uHSTypes = nil then LoadReportLists;
  MixedCaseList(uHSTypes);
  FastAssign(uHSTypes, Dest);
end;

procedure HealthSummaryCheck(Dest: TStrings; aQualifier: string);

begin
  if aQualifier = '1' then
    begin
      ListHealthSummaryTypes(Dest);
    end;
end;

procedure ColumnHeaders(Dest: TStrings; AReportType: String);
begin
  CallV('ORWRP COLUMN HEADERS',[AReportType]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure SaveColumnSizes(aColumn: String);
begin
  CallV('ORWCH SAVECOL', [aColumn]);
end;

procedure ListImagingExams(Dest: TStrings);
var
  x: string;
  i: Integer;
begin
  CallV('ORWRA IMAGING EXAMS1', [Patient.DFN]);
  with RPCBrokerV do
  begin
    SetListFMDateTime('dddddd hh:nn', TStringList(Results), U, 3);
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      if Piece(x,U,7) = 'Y' then SetPiece(x,U,7, ' - Abnormal');
        x := Piece(x,U,1) + U + 'i' + Pieces(x,U,2,3)+ U + Piece(x,U,4)
             + U + Piece(x,U,6)  + Piece(x,U,7) + U
             + MixedCase(Piece(Piece(x,U,9),'~',2)) + U + Piece(x,U,5) +  U + '[+]'
             + U + Pieces(x, U, 15,17);                                                 
(*      x := Piece(x,U,1) + U + 'i' + Pieces(x,U,2,3)+ U + Piece(x,U,4)
        + U + Piece(x,U,6) + Piece(x,U,7) + U + Piece(x,U,5) +  U + '[+]' + U + Piece(x, U, 15);*)
      Results[i] := x;
    end;
    FastAssign(Results, Dest);
  end;
end;

procedure ListProcedures(Dest: TStrings);
var
  x,sdate: string;
  i: Integer;
begin
  CallV('ORWMC PATIENT PROCEDURES1', [Patient.DFN]);
  with RPCBrokerV do
  begin
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      if length(piece(x, U, 8)) > 0 then
        begin
          sdate := ShortDateStrToDate(piece(piece(x, U, 8),'@',1)) + ' ' + piece(piece(x, U, 8),'@',2);
        end;
      x := Piece(x, U, 1) + U + 'i' + Piece(x, U, 2) + U + sdate + U + Piece(x, U, 3) + U + Piece(x, U, 9) + '^[+]';
      Results[i] := x;
    end;
    FastAssign(Results, Dest);
  end;
end;

procedure ListNutrAssessments(Dest: TStrings);
var
  x: string;
  i: Integer;
begin
  CallV('ORWRP1 LISTNUTR', [Patient.DFN]);
  with RPCBrokerV do
  begin
    for i := 0 to Results.Count - 1 do
      begin
        x := Results[i];
        x := Piece(x, U, 1) + U + 'i' + Piece(x, U, 3) + U + Piece(x, U, 3);
        Results[i] := x;
      end;
    FastAssign(Results, Dest);
  end;
end;

procedure ListSurgeryReports(Dest: TStrings);
{ returns a list of surgery cases for a patient, without documents}
//Facility^Case #^Date/Time of Operation^Operative Procedure^Surgeon name)
var
  i: integer;
  x, AFormat: string;
begin
  CallV('ORWSR RPTLIST', [Patient.DFN]);
  with RPCBrokerV do
   begin
    for i := 0 to Results.Count - 1 do
      begin
        x := Results[i];
        if Piece(Piece(x, U, 3), '.', 2) = '' then AFormat := 'mm/dd/yyyy' else AFormat := 'mm/dd/yyyy hh:nn';
        x := Piece(x, U, 1) + U + 'i' + Piece(x, U, 2) + U + FormatFMDateTimeStr(AFormat, Piece(x, U, 3))+ U +
             Piece(x, U, 4)+ U + Piece(x, U, 5);
        if Piece(Results[i], U, 6) = '+' then x := x + '^[+]';
        Results[i] := x;
      end;
    FastAssign(Results, Dest);
  end;
end;

procedure LoadReportText(Dest: TStrings; ReportType: string; const Qualifier: string; ARpc, AHSTag: string);
var
  HSType, DaysBack, ExamID, MaxOcc, AReport, x: string;
  Alpha, Omega, Trans: double;
begin
  HSType := '';
  DaysBack := '';
  ExamID := '';
  Alpha := 0;
  Omega := 0;
  if CharAt(Qualifier, 1) = 'T' then
    begin
      Alpha := StrToFMDateTime(Piece(Qualifier,';',1));
      Omega := StrToFMDateTime(Piece(Qualifier,';',2));
      if Alpha > Omega then
        begin
          Trans := Omega;
          Omega := Alpha;
          Alpha := Trans;
        end;
      MaxOcc := Piece(Qualifier,';',3);
      SetPiece(AHSTag,';',4,MaxOcc);
    end;
  if CharAt(Qualifier, 1) = 'd' then
    begin
      MaxOcc := Piece(Qualifier,';',2);
      SetPiece(AHSTag,';',4,MaxOcc);
      x := Piece(Qualifier,';',1);
      DaysBack := Copy(x, 2, Length(x));
    end;
  if CharAt(Qualifier, 1) = 'h' then HSType   := Copy(Qualifier, 2, Length(Qualifier));
  if CharAt(Qualifier, 1) = 'i' then ExamID   := Copy(Qualifier, 2, Length(Qualifier));
  AReport := ReportType + '~' + AHSTag;
  if Length(ARpc) > 0 then
    begin
      CallV(ARpc, [Patient.DFN, AReport, HSType, DaysBack, ExamID, Alpha, Omega]);
      QuickCopy(RPCBrokerV.Results,Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteQueryAbortAll;
begin
  CallV('XWB DEFERRED CLEARALL',[nil]);
end;

procedure RemoteQuery(Dest: TStrings; AReportType: string; AHSType, ADaysback,
            AExamID: string; Alpha, AOmega: Double; ASite, ARemoteRPC, AHSTag: String);
var
  AReport: string;
begin
  AReport := AReportType + ';1' + '~' + AHSTag;
  if length(AHSType) > 0 then
    AHSType := piece(AHSType,':',1) + ';' + piece(AHSType,':',2);  //format for backward compatibility
  CallV('XWB REMOTE RPC', [ASite, ARemoteRPC, 0, Patient.DFN + ';' + Patient.ICN,
            AReport, AHSType, ADaysBack, AExamID, Alpha, AOmega]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure DirectQuery(Dest: TStrings; AReportType: string; AHSType, ADaysback,
            AExamID: string; Alpha, AOmega: Double; ASite, ARemoteRPC, AHSTag: String);
var
  AReport: string;
begin
  AReport := AReportType + ';1' + '~' + AHSTag;
  if length(AHSType) > 0 then
    AHSType := piece(AHSType,':',1) + ';' + piece(AHSType,':',2);  //format for backward compatibility
  CallV('XWB DIRECT RPC', [ASite, ARemoteRPC, 0, Patient.DFN + ';' + Patient.ICN,
            AReport, AHSType, ADaysBack, AExamID, Alpha, AOmega]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

function ReportQualifierType(ReportType: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to uReportsList.Count - 1 do
    if StrToIntDef(Piece(uReportsList[i], U, 1), 0) = ReportType
      then Result := StrToIntDef(Piece(uReportsList[i], U, 3), 0);
end;

function ImagingParams: String;
begin
  Result := sCallV('ORWTPD GETIMG',[nil]);
end;

function AutoRDV: String;
begin
  Result := sCallV('ORWCIRN AUTORDV', [nil]);
end;

function HDRActive: String;
begin
  Result := sCallV('ORWCIRN HDRON', [nil]);
end;

procedure PrintVReports(Dest, ADevice, AHeader: string; AReport: TStringList);
begin
  CallV('ORWRP PRINT V REPORT', [ADevice, Patient.DFN, AHeader, AReport]);
end;

procedure PrintReportsToDevice(AReport: string; const Qualifier, Patient, ADevice: string;
 var ErrMsg: string; aComponents: TStringlist; ARemoteSiteID, ARemoteQuery, AHSTag: string);
{ prints a report on the selected device }
var
  HSType, DaysBack, ExamID, MaxOcc, ARpt, x: string;
  Alpha, Omega: double;
  j: integer;
  RemoteHandle,Report: string;
  aHandles: TStringlist;
begin
  HSType := '';
  DaysBack := '';
  ExamID := '';
  Alpha := 0;
  Omega := 0;
  aHandles := TStringList.Create;
  if CharAt(Qualifier, 1) = 'T' then
    begin
      Alpha := StrToFMDateTime(Piece(Qualifier,';',1));
      Omega := StrToFMDateTime(Piece(Qualifier,';',2));
      MaxOcc := Piece(Qualifier,';',3);
      SetPiece(AHSTag,';',4,MaxOcc);
    end;
  if CharAt(Qualifier, 1) = 'd' then
    begin
      MaxOcc := Piece(Qualifier,';',2);
      SetPiece(AHSTag,';',4,MaxOcc);
      x := Piece(Qualifier,';',1);
      DaysBack := Copy(x, 2, Length(x));
    end;
  if CharAt(Qualifier, 1) = 'h' then HSType   := Copy(Qualifier, 2, Length(Qualifier));
  if CharAt(Qualifier, 1) = 'i' then ExamID   := Copy(Qualifier, 2, Length(Qualifier));
  if Length(ARemoteSiteID) > 0 then
    begin
      RemoteHandle := '';
      for j := 0 to RemoteReports.Count - 1 do
        begin
          Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
          if Report = ARemoteQuery then
            begin
              RemoteHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle
                + '^' + Pieces(Report,'^',9,10);
              break;
            end;
        end;
      if Length(RemoteHandle) > 1 then
        with RemoteSites.SiteList do
            aHandles.Add(ARemoteSiteID + '^' + RemoteHandle);
    end;
  ARpt := AReport + '~' + AHSTag;
  if aHandles.Count > 0 then
    begin
      ErrMsg := sCallV('ORWRP PRINT REMOTE REPORT',[ADevice, Patient, ARpt, aHandles]);
      if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
    end
  else
    begin
      ErrMsg := sCallV('ORWRP PRINT REPORT',[ADevice, Patient, ARpt, HSType,
        DaysBack, ExamID, aComponents, Alpha, Omega]);
      if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
    end;
  aHandles.Clear;
  aHandles.Free;
end;

function GetFormattedReport(AReport: string; const Qualifier, Patient: string;
         aComponents: TStringlist; ARemoteSiteID, ARemoteQuery, AHSTag: string): TStrings;
{ prints a report on the selected device }
var
  HSType, DaysBack, ExamID, MaxOcc, ARpt, x: string;
  Alpha, Omega: double;
  j: integer;
  RemoteHandle,Report: string;
  aHandles: TStringlist;
begin
  HSType := '';
  DaysBack := '';
  ExamID := '';
  Alpha := 0;
  Omega := 0;
  aHandles := TStringList.Create;
  if CharAt(Qualifier, 1) = 'T' then
    begin
      Alpha := StrToFMDateTime(Piece(Qualifier,';',1));
      Omega := StrToFMDateTime(Piece(Qualifier,';',2));
      MaxOcc := Piece(Qualifier,';',3);
      SetPiece(AHSTag,';',4,MaxOcc);
    end;
  if CharAt(Qualifier, 1) = 'd' then
    begin
      MaxOcc := Piece(Qualifier,';',2);
      SetPiece(AHSTag,';',4,MaxOcc);
      x := Piece(Qualifier,';',1);
      DaysBack := Copy(x, 2, Length(x));
    end;
  if CharAt(Qualifier, 1) = 'h' then HSType   := Copy(Qualifier, 2, Length(Qualifier));
  if CharAt(Qualifier, 1) = 'i' then ExamID   := Copy(Qualifier, 2, Length(Qualifier));
  if Length(ARemoteSiteID) > 0 then
    begin
      RemoteHandle := '';
      for j := 0 to RemoteReports.Count - 1 do
        begin
          Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
          if Report = ARemoteQuery then
            begin
              RemoteHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle
                + '^' + Pieces(Report,'^',9,10);
              break;
            end;
        end;
      if Length(RemoteHandle) > 1 then
        with RemoteSites.SiteList do
            aHandles.Add(ARemoteSiteID + '^' + RemoteHandle);
    end;
  ARpt := AReport + '~' + AHSTag;
  if aHandles.Count > 0 then
    begin
      CallV('ORWRP PRINT WINDOWS REMOTE',[Patient, ARpt, aHandles]);
      Result := RPCBrokerV.Results;
    end
  else
    begin
      CallV('ORWRP PRINT WINDOWS REPORT',[Patient, ARpt, HSType,
        DaysBack, ExamID, aComponents, Alpha, Omega]);
      Result := RPCBrokerV.Results;
    end;
  aHandles.Clear;
  aHandles.Free;
end;

function DefaultToWindowsPrinter: Boolean;
begin
  Result := (StrToIntDef(sCallV('ORWRP WINPRINT DEFAULT',[]), 0) > 0);
end;

procedure PrintWindowsReport(ARichEdit: TRichEdit; APageBreak, Atitle: string; var ErrMsg: string; IncludeHeader: Boolean = false);
var
  i, j, x, y, LineHeight: integer;
  aGoHead: string;
  aHeader: TStringList;
const
  TX_ERR_CAP = 'Print Error';
  TX_FONT_SIZE = 10;
  TX_FONT_NAME = 'Courier New';
begin
  aHeader := TStringList.Create;
  aGoHead := '';
  if piece(Atitle,';',2) = '1' then
    begin
      Atitle := piece(Atitle,';',1);
      aGoHead := '1';
    end;
  CreatePatientHeader(aHeader ,ATitle);
  with ARichEdit do
    begin
(*      if Lines[Lines.Count - 1] = APageBreak then      //  remove trailing form feed
        Lines.Delete(Lines.Count - 1);
      while (Lines[0] = '') or (Lines[0] = APageBreak) do
        Lines.Delete(0);                               //  remove leading blank lines and form feeds*)

        {v20.4 - SFC-0602-62899 - RV}
        while (Lines.Count > 0) and ((Lines[Lines.Count - 1] = '') or (Lines[Lines.Count - 1] = APageBreak)) do
          Lines.Delete(Lines.Count - 1);                 //  remove trailing blank lines and form feeds
        while (Lines.Count > 0) and ((Lines[0] = '') or (Lines[0] = APageBreak)) do
          Lines.Delete(0);                               //  remove leading blank lines and form feeds

      if Lines.Count > 1 then
        begin
(*          i := Lines.IndexOf(APageBreak);
          if ((i >= 0 ) and (i < Lines.Count - 1)) then        // removed in v15.9 (RV)
            begin*)
              Printer.Canvas.Font.Size := TX_FONT_SIZE;
              Printer.Canvas.Font.Name := TX_FONT_NAME;
              Printer.Title := ATitle;
              x := Trunc(Printer.Canvas.TextWidth(StringOfChar('=', TX_FONT_SIZE)) * 0.75);
              LineHeight := Printer.Canvas.TextHeight(TX_FONT_NAME);
              y := LineHeight * 5;            // 5 lines = .83" top margin   v15.9 (RV)
              Printer.BeginDoc;

              //Do we need to add the header?
              IF IncludeHeader then begin
               for j := 0 to aHeader.Count - 1 do
                begin
                 Printer.Canvas.TextOut(x, y, aHeader[j]);
                 y := y + LineHeight;
                end;
              end;

              for i := 0 to Lines.Count - 1 do
                begin
                  if Lines[i] = APageBreak then
                    begin
                      Printer.NewPage;
                      y := LineHeight * 5;   // 5 lines = .83" top margin    v15.9 (RV)
                      if (IncludeHeader) then
                        begin
                          for j := 0 to aHeader.Count - 1 do
                            begin
                              Printer.Canvas.TextOut(x, y, aHeader[j]);
                              y := y + LineHeight;
                            end;
                        end;
                    end
                  else
                    begin
                      Printer.Canvas.TextOut(x, y, Lines[i]);
                      y := y + LineHeight;
                    end;
                end;
              Printer.EndDoc;
(*            end
          else                               // removed in v15.9 (RV)  TRichEdit.Print no longer used.
            try
              Font.Size := TX_FONT_SIZE;
              Font.Name := TX_FONT_NAME;
              Print(ATitle);
            except
              ErrMsg := TX_ERR_CAP;
            end;*)
        end
      else if ARichEdit.Lines.Count = 1 then
        if Piece(ARichEdit.Lines[0], U, 1) <> '0' then
          ErrMsg := Piece(ARichEdit.Lines[0], U, 2);
    end;
  aHeader.Free;
end;

procedure CreatePatientHeader(var HeaderList: TStringList; PageTitle: string);
// standard patient header, from HEAD^ORWRPP
var
  tmpStr, tmpItem: string;
begin
  with HeaderList do
    begin
      Add(' ');
      Add(StringOfChar(' ', (74 - Length(PageTitle)) div 2) + PageTitle);
      Add(' ');
      tmpStr := Patient.Name + '   ' + Patient.SSN;
      tmpItem := tmpStr + StringOfChar(' ', 39 - Length(tmpStr)) + Encounter.LocationName;
      tmpStr := FormatFMDateTime('dddddd', Patient.DOB) + ' (' + IntToStr(Patient.Age) + ')';
      tmpItem := tmpItem + StringOfChar(' ', 74 - (Length(tmpItem) + Length(tmpStr))) + tmpStr;
      Add(tmpItem);
      Add(StringOfChar('=', 74));
      Add('*** WORK COPY ONLY ***' + StringOfChar(' ', 24) + 'Printed: ' + FormatFMDateTime('dddddd  hh:nn', FMNow));
      Add(' ');
      Add(' ');
    end;
end;

procedure PrintGraph(GraphImage: TChart; PageTitle: string);
var
  AHeader: TStringList;
  i, y, LineHeight: integer;
  GraphPic: TBitMap;
  Magnif: integer;
const
  TX_FONT_SIZE = 12;
  TX_FONT_NAME = 'Courier New';
  CF_BITMAP = 2;      // from Windows.pas
begin
  ClipBoard;
  AHeader := TStringList.Create;
  CreatePatientHeader(AHeader, PageTitle);
  GraphPic := TBitMap.Create;
  try
    GraphImage.CopyToClipboardBitMap;
    GraphPic.LoadFromClipBoardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
    with Printer do
      begin
        Canvas.Font.Size := TX_FONT_SIZE;
        Canvas.Font.Name := TX_FONT_NAME;
        Title := PageTitle;
        Magnif := (Canvas.TextWidth(StringOfChar('=', 74)) div GraphImage.Width);
        LineHeight := Printer.Canvas.TextHeight(TX_FONT_NAME);
        y := LineHeight;
        BeginDoc;
        try
          for i := 0 to AHeader.Count - 1 do
            begin
              Canvas.TextOut(0, y, AHeader[i]);
              y := y + LineHeight;
            end;
          y := y + (4 * LineHeight);
          //GraphImage.PrintPartial(Rect(0, y, Canvas.TextWidth(StringOfChar('=', 74)), y + (Magnif * GraphImage.Height)));
          PrintBitmap(Canvas, Rect(0, y, Canvas.TextWidth(StringOfChar('=', 74)), y + (Magnif * GraphImage.Height)), GraphPic);
        finally
          EndDoc;
        end;
      end;
  finally
    ClipBoard.Clear;
    GraphPic.Free;
    AHeader.Free;
  end;
end;

procedure SaveDefaultPrinter(DefPrinter: string) ;
begin
  CallV('ORWRP SAVE DEFAULT PRINTER', [DefPrinter]);
end;

function HSFileLookup(aFile: String; const StartFrom: string;
          Direction:Integer): TStrings;
begin
  CallV('ORWRP2 HS FILE LOOKUP', [aFile, StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

procedure HSComponentFiles(Dest: TStrings; aComponent: String);
begin
  CallV('ORWRP2 HS COMP FILES', [aComponent]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure HSSubItems(Dest: TStrings; aItem: String);
begin
  CallV('ORWRP2 HS SUBITEMS', [aItem]);
  MixedCaseList(RPCBrokerV.Results);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure HSReportText(Dest: TStrings; aComponents: TStringlist);
begin
  CallV('ORWRP2 HS REPORT TEXT', [aComponents, Patient.DFN]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure HSComponents(Dest: TStrings);
begin
  CallV('ORWRP2 HS COMPONENTS', [nil]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure HSABVComponents(Dest: TStrings);
begin
  CallV('ORWRP2 COMPABV', [nil]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure HSDispComponents(Dest: TStrings);
begin
  CallV('ORWRP2 COMPDISP', [nil]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure HSComponentSubs(Dest: TStrings; aItem: String);
begin
  CallV('ORWRP2 HS COMPONENT SUBS',[aItem]);
  MixedCaseList(RPCBrokerV.Results);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

function GetRemoteStatus(aHandle: string): String;
begin
  CallV('XWB REMOTE STATUS CHECK', [aHandle]);
  Result := RPCBrokerV.Results[0];
end;

function GetAdhocLookup: integer;
begin
  CallV('ORWRP2 GETLKUP', [nil]);
  if RPCBrokerV.Results.Count > 0 then
    Result := StrToInt(RPCBrokerV.Results[0])
  else
    Result := 0;
end;

procedure SetAdhocLookup(aLookup: integer);

begin
  CallV('ORWRP2 SAVLKUP', [IntToStr(aLookup)]);
end;

procedure GetRemoteData(Dest: TStrings; aHandle: string; aItem: PChar);
begin
  CallV('XWB REMOTE GETDATA', [aHandle]);
  if RPCBrokerV.Results.Count < 1 then
    RPCBrokerV.Results[0] := 'No data found.';
  if (RPCBrokerV.Results.Count < 2) and (RPCBrokerV.Results[0] = '') then
    RPCBrokerV.Results[0] := 'No data found.';
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure ModifyHDRData(Dest: string; aHandle: string; aID: string);
begin
  CallV('ORWRP4 HDR MODIFY', [aHandle, aID]);
end;

procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
var
  BitmapHeader:  pBitmapInfo;
  BitmapImage :  POINTER;
  HeaderSize  :  DWORD;    // Use DWORD for D3-D5 compatibility
  ImageSize   :  DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end
end {PrintBitmap};

initialization
  { nothing to initialize }

finalization
  uTree.Free;
  uReportsList.Free;
  uLabReports.Free;
  uDateRanges.Free;
  uHSTypes.Free;

end.
