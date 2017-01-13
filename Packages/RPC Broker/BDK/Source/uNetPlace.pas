unit uNetPlace;

interface

type
  TNetPlace = class(TObject)
  private
    fTitle: string;
    fIP: string;
    fPort: integer;
    fSelected: boolean;
    fModified: boolean;
    fComment: string;
    procedure SetIP(const Value: string);
    procedure SetPort(const Value: integer);
    procedure SetTitle(const Value: string);
    procedure SetComment(const Value: string);
    function GetDisplay: string;
  protected
  public
    property Title: string read fTitle write SetTitle;
    property IP: string read fIP write SetIP;
    property Port: integer read fPort write SetPort;
    property Selected: boolean read fSelected write fSelected;
    property Modified: boolean read fModified write fModified;
    property Comment: string read fComment write SetComment;
    property Display: string read GetDisplay;
    constructor Create(ATitle: string = ''; AnIP: string = ''; AComment: string = ''; APort: integer = 0);
    destructor Destroy; override;
    procedure DetermineIP;
    function Clone: TNetPlace;
  end;

  TCompareRoutine = function(A, B: TNetPlace; SortAscending: boolean): integer;
  TNetPlaceList = class(TObject)
  private
    Data: array of TNetPlace;
    fModified: boolean;
    function GetModified: boolean;
    procedure SetModified(const Value: boolean);
  protected
    function GetByIP(AnIP: string): TNetPlace;
    function GetByTitle(ATitle: string): TNetPlace;
    procedure SetByIP(AnIP: string; const Value: TNetPlace);
    procedure SetByTitle(ATitle: string; const Value: TNetPlace);
    function GetByIdx(AnIdx: integer): TNetPlace;
    procedure SetByIdx(AnIdx: integer; const Value: TNetPlace);
    procedure Sort(ACompareRoutine: TCompareRoutine; SortAscending: boolean);
  public
    property ByIdx[AnIdx: integer]: TNetPlace read GetByIdx write SetByIdx; default;
    property ByIP[AnIP: string]: TNetPlace read GetByIP write SetByIP;
    property ByTitle[ATitle: string]: TNetPlace read GetByTitle write SetByTitle;
    property Modified: boolean read GetModified write SetModified;

    constructor Create;
    destructor Destroy; override;
    function Count: integer;
    function Clone: TNetPlaceList;
    procedure Clear;
    procedure Add(ANetPlace: TNetPlace);

    function FindTitle(ATitle: string): integer;
    function FindIP(AnIP: string): integer;

    procedure PopulateFromHostFile;
    procedure PopulateFromRegistry(ARegKey: string);
    procedure PopulateFromBrokerRegistry;

    procedure WriteToHostFile;
    procedure WriteToRegistry(ARegKey: string);
    procedure WriteToBrokerRegistry;
    function HasBlankHost: boolean;
    function HasSelected: boolean;
    procedure Delete(AnIdx: integer);
    procedure Swap(IndexA, IndexB: integer);
    procedure SortByTitle(UseAscending: boolean);
    procedure SortByIP(UseAscending: boolean);
    procedure SortByPort(UseAscending: boolean);
    procedure SortByComment(UseAscending: boolean);
    function SelectedTitleList: string;
    function Text: string;
  end;

function HostFileLocation: string;
function BuildServerList: TNetPlaceList;
function VerifyVistaServerRegistry: boolean;

var
  HasAdminRights: boolean;

implementation

uses
  Math, Windows, Registry, StrUtils, Classes, SysUtils, uTokenTools, MFunStr;

function HostFileLocation: string;
var
  WinDir: PWideChar;
begin
  WinDir := StrAlloc(MAX_PATH + 1);
  GetWindowsDirectoryW(WinDir, MAX_PATH);          //Retieve windows directory
  Result := string(WinDir);
  StrDispose(WinDir);
  if TOSVersion.Major >= 5 then // XP and up
    Result := Result + '\system32\drivers\etc';
  if Copy(Result, Length(Result), 1) = '\' then  //Strip terminating '\'
    Result := Copy(Result, 1, Length(Result)-1);
end;

function BuildServerList: TNetPlaceList;
var
  i, idx: integer;
  HostList: TNetPlaceList;
  RegList: TNetPlaceList;
begin
  Result := TNetPlaceList.Create;
  HostList := TNetPlaceList.Create;
  try
    HostList.PopulateFromHostFile;
    RegList := TNetPlaceList.Create;
    try
      RegList.PopulateFromBrokerRegistry;
      for i := 0 to (HostList.Count - 1) do begin
        if (Result.ByTitle[HostList.ByIdx[i].Title] = nil) then begin
          Result.Add(HostList.ByIdx[i].Clone);
        end;
      end;
      for i := 0 to (RegList.Count - 1) do begin
        idx := Result.FindTitle(RegList.ByIdx[i].Title);
        if (idx = -1) then begin
          Result.Add(RegList.ByIdx[i].Clone);
        end else begin
          Result.ByIdx[idx].Port := RegList.ByIdx[i].Port;
        end;
      end;
    finally
      RegList.Free;
    end;
  finally
    HostList.Free;
  end;
end;


{ TNetPlace }

function TNetPlace.Clone: TNetPlace;
begin
  Result := TNetPlace.Create(fTitle, fIP, fComment, fPort);
end;

constructor TNetPlace.Create(ATitle: string = ''; AnIP: string = ''; AComment: string = ''; APort: integer = 0);
begin
  fTitle := ATitle;
  fIP := AnIP;
  fPort := APort;
  fComment := AComment;
  fSelected := False;
  fModified := False;
end;

destructor TNetPlace.Destroy;
begin
  inherited;
end;

procedure TNetPlace.DetermineIP;
begin

end;

function TNetPlace.GetDisplay: string;
begin
  if IP = '' then begin
    Result := Title + ', ' + IntToStr(Port);
  end else begin
    Result := Title + ', ' + IP + ', ' + IntToStr(Port);
  end;
  if Comment <> '' then begin
    Result := Result + ', ' + Comment;
  end;
end;

procedure TNetPlace.SetComment(const Value: string);
begin
  fComment := Value;
  fModified := True;
end;

procedure TNetPlace.SetIP(const Value: string);
begin
  fIP := Trim(Value);
  fModified := True;
end;

procedure TNetPlace.SetPort(const Value: integer);
begin
  fPort := Value;
  fModified := True;
end;

procedure TNetPlace.SetTitle(const Value: string);
begin
  fTitle := Trim(Value);
  fModified := True;
end;

{ TNetPlaceList }

procedure TNetPlaceList.Add(ANetPlace: TNetPlace);
begin
  SetLength(Data, Count + 1);
  Data[Count - 1] := ANetPlace;
  fModified := True;
end;

procedure TNetPlaceList.Clear;
var
  i: integer;
begin
  fModified := (Count <> 0);
  for i := 0 to Count - 1 do begin
    if assigned(Data[i]) then Data[i].Free;
  end;
  SetLength(Data, 0);
end;

function TNetPlaceList.Clone: TNetPlaceList;
var
  i: integer;
begin
  Result := TNetPlaceList.Create;
  for i := 0 to (Count - 1) do begin
    Result.Add(Data[i].Clone);
  end;
end;

function TNetPlaceList.SelectedTitleList: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (Count - 1) do begin
    if Data[i].Selected then begin
      if Result = '' then begin
        Result := Data[i].Title;
      end else begin
        Result := Result + ', ' + Data[i].Title;
      end;
    end;
  end;
end;

function TNetPlaceList.Text: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (Count - 1) do begin
    if Result = '' then begin
      Result := Data[i].Display;
    end else begin
      Result := Result + #13#10 + Data[i].Display;
    end;
  end;
end;

function TNetPlaceList.Count: integer;
begin
  Result := Length(Data);
end;

constructor TNetPlaceList.Create;
begin
  SetLength(Data, 0);
  fModified := False;
end;

procedure TNetPlaceList.Delete(AnIdx: integer);
var
  i: integer;
begin
  if (AnIdx >=0) and (AnIdx < Count) then begin
    Data[AnIdx].Free;
    for i := AnIdx + 1 to (Count - 1) do Data[i - 1] := Data[i];
    SetLength(Data, Count - 1);
    fModified := True;
  end;
end;

destructor TNetPlaceList.Destroy;
begin
  Clear;
  inherited;
end;

function TNetPlaceList.FindIP(AnIP: string): integer;
begin
  Result := 0;
  while (Result < Count) and (Data[Result].IP <> AnIP) do inc(Result);
  if (Result = Count) then Result := -1;
end;

function TNetPlaceList.FindTitle(ATitle: string): integer;
begin
  Result := 0;
  while (Result < Count) and (Data[Result].Title <> ATitle) do inc(Result);
  if (Result = Count) then Result := -1;
end;

function TNetPlaceList.GetByIdx(AnIdx: integer): TNetPlace;
begin
  if (AnIdx >= 0) and (AnIdx < Count) then begin
    Result := Data[AnIdx];
  end else begin
    raise Exception.Create('NetPlaceList index out of bounds (' + IntToStr(AnIdx) +')');
  end;
end;

function TNetPlaceList.GetByIP(AnIP: string): TNetPlace;
var
  idx: integer;
begin
  idx := FindIP(AnIP);
  if (idx >= 0) and (idx < Count) then begin
    Result := Data[idx];
  end else begin
    Result := nil;
  end;
end;

function TNetPlaceList.GetByTitle(ATitle: string): TNetPlace;
var
  idx: integer;
begin
  idx := FindTitle(ATitle);
  if (idx >= 0) and (idx < Count) then begin
    Result := Data[idx];
  end else begin
    Result := nil;
  end;
end;

function TNetPlaceList.GetModified: boolean;
var
  i: integer;
begin
  Result := fModified;
  if not Result then begin
    i := 0;
    while (i < Count) and (not Data[i].Modified) do inc(i);
    Result := (i < Count);
  end;
end;

function TNetPlaceList.HasBlankHost: boolean;
begin
  Result := (FindTitle('') <> -1);
end;

function TNetPlaceList.HasSelected: boolean;
var
  i: integer;
begin
  i := 0;
  while (i < Count) and (not Data[i].Selected) do inc(i);
  Result := (i <> Count);
end;

procedure TNetPlaceList.PopulateFromBrokerRegistry;
begin
  PopulateFromRegistry('\Vista\Broker\Servers');
end;

procedure TNetPlaceList.PopulateFromHostFile;
var
  i, sp: integer;
  HostFile: TStringList;
  Line, IP, Title, Comment: string;
begin
  Clear;
  HostFile := TStringList.Create;
  try
    HostFile.LoadFromFile(HostFileLocation + '\Hosts');
    for i := 0 to (HostFile.Count - 1) do begin
      Line := Trim(HostFile[i]);
      sp := Pos(' ', Line);
      if (sp = 0) then sp := Pos(#9, Line);
      if (Line <> '') and (sp > 0) and (Line[1] <> '#') then begin
        IP := copy(Line, 1, sp - 1);
        Title := copy(Line, sp, length(Line) - sp + 1);
        sp := pos('#', Title);
        if (sp > 0) then begin
          Comment := copy(Title, sp + 1, length(Line));
          Title := copy(Title, 1, sp - 1);
        end else begin
          Comment := '';
        end;
        Title := Trim(Title);
        Add(TNetPlace.Create(Title, IP, Comment));
      end;
    end;
  finally
    HostFile.Free;
  end;
  fModified := False;
end;

procedure TNetPlaceList.PopulateFromRegistry(ARegKey: string); // ARegKey should have a slash on the front.
var
  i: integer;
  Base: string;
  Registry: TRegistry;
  WorkList: TStringList;
  DNS: string;
begin
  Clear;
  Registry := TRegistry.Create;
  try
    WorkList := TStringList.Create;
    try
      // Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.RootKey := HKEY_CURRENT_USER;

      if (TOSVersion.Architecture = arIntelX64) then
        begin
          Base := 'Software\Wow6432Node' + ARegKey;
          if not Registry.KeyExists(Base) then
            begin
              if Registry.KeyExists('Software' + ARegKey) then
                begin
                  Registry.MoveKey('Software' + ARegKey, Base, False);
                end;
            end;
        end
      else
        begin
          Base := 'Software' + ARegKey;
        end;

      if Registry.OpenKeyReadOnly(Base) then
        begin
          Registry.GetValueNames(WorkList);
          for i := 0 to (WorkList.Count - 1) do
            begin
              if (Registry.GetDataType(WorkList[i]) = rdString) then
                DNS := Registry.ReadString(WorkList[i])
              else
                DNS := '';
              Add(TNetPlace.Create(Piece(WorkList[i], ',', 1), DNS, '', StrToIntDef(Piece(WorkList[i], ',', 2), 0)));
            end;
        end;
    finally
      WorkList.Free;
    end;
  finally
    Registry.Free;
  end;
  fModified := False;
end;

procedure TNetPlaceList.SetByIdx(AnIdx: integer; const Value: TNetPlace);
begin
  if (AnIdx >= 0) and (AnIdx < Count) then begin
    fModified := True;
    Data[AnIdx] := Value;
  end else begin
    raise Exception.Create('NetPlaceList index out of bounds (' + IntToStr(AnIdx) +')');
  end;
end;

procedure TNetPlaceList.SetByIP(AnIP: string; const Value: TNetPlace);
var
  idx: integer;
begin
  idx := FindIP(AnIP);
  if (idx >= 0) and (idx < Count) then begin
    fModified := True;
    Data[idx] := Value;
  end;
end;

procedure TNetPlaceList.SetByTitle(ATitle: string; const Value: TNetPlace);
var
  idx: integer;
begin
  idx := FindTitle(ATitle);
  if (idx >= 0) and (idx < Count) then begin
    fModified := True;
    Data[idx] := Value;
  end;
end;

procedure TNetPlaceList.SetModified(const Value: boolean);
var
  i: integer;
begin
  if not Value then begin
    for i := 0 to (Count - 1) do begin
      Data[i].Modified := False;
    end;
  end;
  fModified := Value;
end;

procedure TNetPlaceList.Sort(ACompareRoutine: TCompareRoutine; SortAscending: boolean);
const
  gap: array[0..7] of integer = (701, 301, 132, 57, 23, 10, 4, 1);
var
  i, j, k: integer;
  tmp: TNetPlace;
begin
  for k := 0 to (Length(gap) - 1) do begin
    if (gap[k] < Count) then begin
      for i := (gap[k] - 1) to (Count - 1) do begin
        tmp := Data[i];
        j := i;
        while (j >= gap[k]) and (ACompareRoutine(Data[j - gap[k]], tmp, SortAscending) > 0) do begin
          Data[j] := Data[j - gap[k]];
          Dec(j, gap[k]);
        end;
        Data[j] := tmp;
      end;
    end;
  end;
  fModified := True;
end;


function IPCompare(A, B: TNetPlace; SortAscending: boolean): integer;
begin
  if (A.IP > B.IP) then Result := 1
  else if (A.IP < B.IP) then Result := -1
  else Result := 0;

  if SortAscending then begin
    Result := Result * -1;
  end;
end;

function CommentCompare(A, B: TNetPlace; SortAscending: boolean): integer;
begin
  if (A.Comment > B.Comment) then Result := 1
  else if (A.Comment < B.Comment) then Result := -1
  else Result := 0;

  if SortAscending then begin
    Result := Result * -1;
  end;
end;

function PortCompare(A, B: TNetPlace; SortAscending: boolean): integer;
begin
  if (A.Port > B.Port) then Result := 1
  else if (A.Port < B.Port) then Result := -1
  else Result := 0;

  if SortAscending then begin
    Result := Result * -1;
  end;
end;

function TitleCompare(A, B: TNetPlace; SortAscending: boolean): integer;
begin
  if (A.Title > B.Title) then Result := 1
  else if (A.Title < B.Title) then Result := -1
  else Result := 0;

  if SortAscending then begin
    Result := Result * -1;
  end;
end;

procedure TNetPlaceList.SortByComment(UseAscending: boolean);
begin
  Sort(CommentCompare, UseAscending);
end;

procedure TNetPlaceList.SortByIP(UseAscending: boolean);
begin
  Sort(IPCompare, UseAscending);
end;

procedure TNetPlaceList.SortByPort(UseAscending: boolean);
begin
  Sort(PortCompare, UseAscending);
end;

procedure TNetPlaceList.SortByTitle(UseAscending: boolean);
begin
  Sort(TitleCompare, UseAscending);
end;

procedure TNetPlaceList.Swap(IndexA, IndexB: integer);
var
  WorkPlace: TNetPlace;
begin
  WorkPlace := Data[IndexA];
  Data[IndexA] := Data[IndexB];
  Data[IndexB] := WorkPlace;
  fModified := True;
end;

function VerifyVistaServerRegistry: boolean;
const
  Key64 = 'Software\Wow6432Node\Vista\Broker\Servers';
  Key32 = 'Software\Vista\Broker\Servers';
var
  CurrentUser, LocalMachine: TRegistry;
  sl: TStringList;
  i: integer;
begin
  CurrentUser := TRegistry.Create;
  try
    LocalMachine := TRegistry.Create;
    try
      CurrentUser.RootKey := HKEY_CURRENT_USER;
      LocalMachine.RootKey := HKEY_LOCAL_MACHINE;
      if (TOSVersion.Architecture = arIntelX64) then begin
        Result := CurrentUser.KeyExists(Key64);
      end else begin
        Result := CurrentUser.KeyExists(Key32);
      end;
      if (not Result) then begin
        sl := TStringList.Create;
        try
          if (TOSVersion.Architecture = arIntelX64) then begin
            if LocalMachine.KeyExists(Key64) then begin
              LocalMachine.OpenKeyReadOnly(Key64);
              Result := True;
            end else if LocalMachine.KeyExists(Key32) then begin
              LocalMachine.OpenKeyReadOnly(Key32);
              Result := True;
            end;
            if Result then begin
              LocalMachine.GetValueNames(sl);
            end;
          end else begin
            if LocalMachine.KeyExists(Key32) then begin
              LocalMachine.OpenKeyReadOnly(Key32);
              LocalMachine.GetValueNames(sl);
              Result := True;
            end;
          end;
          if sl.Count = 0 then begin
            sl.Add('BROKERSERVER,9200');
            Result := True;
          end;
          if Result then begin
            if (TOSVersion.Architecture = arIntelX64) then begin
              CurrentUser.OpenKey(Key64, True);
            end else begin
              CurrentUser.OpenKey(Key32, True);
            end;
            for i := 0 to (sl.Count - 1) do begin
              CurrentUser.WriteString(sl[i], '');
            end;
            CurrentUser.CloseKey;
          end;
        finally
          sl.Free;
        end;
      end;
    finally
      LocalMachine.Free;
    end;
  finally
    CurrentUser.Free;
  end;
end;

procedure TNetPlaceList.WriteToBrokerRegistry;
begin
  WriteToRegistry('\Vista\Broker\Servers');
end;

procedure TNetPlaceList.WriteToHostFile;

const
  Header: array[0..12] of string = (
    '# This file contains the mappings of IP addresses to host names. Each',
    '# entry should be kept on an individual line. The IP address should',
    '# be placed in the first column followed by the corresponding host name.',
    '# The IP address and the host name should be separated by at least one',
    '# space.',
    '#',
    '# Additionally, comments (such as these) may be inserted on individual',
    '# lines or following the machine name denoted by a ''#'' symbol.',
    '#',
    '# localhost name resolution is handled within DNS itself.',
    '# 127.0.0.1       localhost  # you can place comments here',
    '# ::1             localhost',
    '#');
var
  i, WideIP, WideTitle: integer;
  WorkList: TStringList;
  Spaces: string;
begin
  WorkList := TStringList.Create;
  try
    for i := 0 to 12 do WorkList.Add(Header[i]);
    WideIP := 0;
    WideTitle := 0;
    for i := 0 to (Count - 1) do begin
      WideIP := Max(length(ByIdx[i].IP), WideIP);
      WideTitle := Max(length(ByIdx[i].Title), WideTitle);
    end;
    Spaces := StringOfChar(' ', Max(WideIP, WideTitle) + 2);
    for i := 0 to (Count - 1) do begin
      if Trim(Data[i].Comment) = '' then begin
        WorkList.Add(LeftStr(Data[i].IP + Spaces, WideIP + 2) + Data[i].Title);
      end else begin
        WorkList.Add(LeftStr(Data[i].IP + Spaces, WideIP + 2) + LeftStr(Data[i].Title + Spaces, WideTitle + 2) + '  #' + Data[i].Comment);
      end;
    end;
    WorkList.SaveToFile(HostFileLocation + '\Hosts');
  finally
    WorkList.Free;
  end;
  Modified := False;
end;

procedure TNetPlaceList.WriteToRegistry(ARegKey: string);
var
  i: integer;
  Base: string;
  Registry: TRegistry;
begin
  if (TOSVersion.Architecture = arIntelX64) then begin
    Base := 'Software\Wow6432Node' + ARegKey;
  end else begin
    Base := 'Software' + ARegKey;
  end;

  Registry := TRegistry.Create;
  try
//    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.KeyExists(Base) then Registry.DeleteKey(Base);
    if Registry.CreateKey(Base) then begin
      if Registry.OpenKey(Base, True) then begin
        for i := 0 to (Count - 1) do begin
          Registry.WriteString(Data[i].Title + ',' + IntToStr(Data[i].Port), Data[i].IP);
        end;
        Registry.CloseKey;
      end;
    end;
  finally
    Registry.Free;
  end;
  Modified := False;
end;

initialization
  HasAdminRights := IsUserAnAdmin;

finalization

end.
