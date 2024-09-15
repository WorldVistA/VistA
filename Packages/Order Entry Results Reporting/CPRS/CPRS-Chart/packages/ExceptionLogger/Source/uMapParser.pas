////////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///                     MAP FILE PARSER UNIT                                 ///
///                                                                          ///
///     -DESCRIPTION                                                         ///
///        This unit is responsible for parsing out he map file              ///
///        and searching for the map info from provided addresses            ///
///                                                                          ///
///                                                                           ///
///                                                                          ///
///                                                                          ///
///     -IMPLEMNTATION                                                       ///
///         This can be ran in the main thread or is multithreaded           ///
///         for an increase in performance                                   ///
///                                                                          ///
////////////////////////////////////////////////////////////////////////////////

unit uMapParser;

interface

uses
  System.Classes,
  System.Generics.Collections,
  UThreadPool;

type
  TMapParser = class;

  /// <summary>custom Weight function used for the binary searching</summary>
  /// <param name="aTarget">The search criteria</param>
  /// <param name="aLine">The direction to move</param>
  /// <returns>The direction to move</returns>
  TWeight = function(aTarget, aLine: string): Integer;
  /// <summary>Function to be called by the thread</summary>
  /// <param name="aMasterList">The main list to move through</param>
  /// <param name="aResultList">The results list</param>
  TWorkThreadFunc = procedure(aParser: TMapParser;
    aMasterList, aResultList: TStringList);

  /// <summary>Additional methodes for the TStringList object</summary>
  TStringsHelper = class helper for TStrings
  public
    /// <summary>Finds the index of the string while stripping the spaces</summary>
    /// <param name="S">Substring that we want to find (should not have spaces)</param>
    /// <param name="OffSet">defines our starting position for the search</param>
    /// <returns>The index of the string or -1 if not found</returns>
    function IndexOfStrippedString(const S: string;
      OffSet: Integer = 0): Integer;
    /// <summary>Finds the index where a specific substring exist</summary>
    /// <param name="S">Substring to search for</param>
    /// <param name="OffSet">The starting point to begin the search</param>
    /// <returns>The first index where the substring was found</returns>
    function IndexOfPiece(const S: string; OffSet: Integer = 0): Integer;
    /// <summary>Retrieves a set of strings from a specific index on</summary>
    /// <param name="ReturnList">Return list where the strings should be placed</param>
    /// <param name="OffSet">Index to start processing at</param>
    /// <param name="Linecnt">How many lines to go past the Offset</param>
    procedure StringsByNum(ReturnList: TStringList; OffSet: Integer = 0;
      Linecnt: Integer = 1);
  end;

  // * Thread Types *
  // <table>
  // Type Name      Meaning
  // -------------  -------------
  // TYPE_UNIT      Processing the unit section
  // TYPE_METHOD    Processing the Method section
  // TYPE_LINES     Processing the Lines section
  // </table>
  tThreadType = (ttLoadUnits, ttLoadMethods, ttLoadLines, ttSortUnits,
    ttSortMethods, ttSortLines);

  TWorker = class
    FWorkerID: Integer;
    fThreadType: tThreadType;
    fParser: TMapParser;
    fMasterList: TStringList;
    fResultList: TStringList;
    fThreadFunc: TWorkThreadFunc;
    fHandler: TThreadPool;
  private
    procedure TakeAction(Sender: TObject);
  public
    constructor Create(const aParser: TMapParser; const Handler: TThreadPool;
      aThreadType: tThreadType; const aMasterList: TStringList;
      const aWrokerID: Integer);
    destructor Destroy(); override;
    procedure FireThread;
    property ResultList: TStringList read fResultList;
    property ThreadFunction: TWorkThreadFunc read fThreadFunc write fThreadFunc;
    property ThreadType: tThreadType read fThreadType write fThreadType;
    property WorkerID: Integer read FWorkerID write FWorkerID;
  end;

  TSegmentInfo = record
    StartAddress: LongWord;
    EndAddress: LongWord;
  end;

  TSegmentList = class(TList<TSegmentInfo>)
    procedure Assign(Source: TSegmentList);
  end;

  TMapParser = class(TObject)
  private
    FMapLoaded: Boolean;
    FMapFile: TStringList;
    FSegments: TSegmentList;
    FUnitSection: TStringList;
    FMethodSection: TStringList;
    FLines: TStringList;
    FFileName: string;
    FWorkerArray: TObjectList<TWorker>;
    FThreadPool: TThreadPool;
    FEndOfUnit: LongWord;
    function LoadMapFile: Boolean;
    function LoadUnits: Boolean;
    function LoadMethods: Boolean;
    function LoadLines: Boolean;
    function GetUnitName(const LookUpAddr: LongWord): string;
    function GetMethodName(const LookUpAddr: LongWord): string;
    function GetLineNum(const LookUpAddr: LongWord;
      const UnitName: string): string;
    function GetAddress(const addr: string): LongWord;
    procedure LoadUpMapFileThreaded(const ThreadOnDemand: Boolean);
    function GetIsMapLoaded: Boolean;
  public
    constructor Create(AFileName: string = ''); overload;
    constructor CreateAndLoadThreaded(AThreadOnDemand: Boolean;
      AFileName: string = '');
    constructor CreateAndLoad(AFileName: string = ''; ADummy: Integer = 0);
    destructor Destroy; override;
    procedure Assign(Source: TMapParser);
    procedure LookupInMap(const LookUpAddr: LongWord;
      out AUnit, AMethod, ALineNumber: string);
    procedure LoadUpMapFile;
    property FileName: string read FFileName;
    property IsMapLoaded: Boolean read GetIsMapLoaded;
    property _UnitName[const LookUpAddr: LongWord]: string read GetUnitName;
    property _MethodName[const LookUpAddr: LongWord]: string read GetMethodName;
  end;

implementation

uses
  System.StrUtils,
  System.SysUtils,
  System.Generics.Defaults,
  Vcl.Forms,
  Vcl.Controls,
  System.Math,
  WinAPI.Windows,
  System.IOUtils,
  AVCatcher;

const
  UnitPrefix = ' M=';
  SegmentMap = 'Detailedmapofsegments';
  PublicsByValue = 'AddressPublicsbyValue';
  BoundResource = 'Boundresourcefiles';
  UnitSection = 'Line numbers for ';
  LookUpErrorNum = -3;
  OutsideMapAddress = $FFFFFFFF;

{$REGION 'Utils'}

function Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns the Nth piece (PieceNum) of a string delimited by Delim }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if i < PieceNum then
    Result := ''
  else
    SetString(Result, Strt, Next - Strt);
end;

function Piece2(input: string; schar: char; S: Integer): string;
var
  c: array of Integer;
  b, t: Integer;
begin
  Result := '';

  // Dec(s, 2);  // for compatibility with very old & slow split function
  if Trim(input) = '' then
    Exit;
  S := S - 1; // zero based
  t := 0; // variable T needs to be initialized...
  setlength(c, Length(input));
  for b := 0 to pred(high(c)) do
  begin
    c[b + 1] := posex(schar, input, succ(c[b]));
    // BREAK LOOP if posex looped (position before previous)
    // or wanted position reached..
    if (c[b + 1] < c[b]) or (S < t) then
      break
    else
      Inc(t);
  end;
  if (S < Length(c)) and (c[S + 1] <> 0) then

    Result := Copy(input, succ(c[S]), pred(c[S + 1] - c[S]))
  else
    Result := Copy(input, succ(c[S]), Length(input))
end;

function Piece3(const S: string; Delim: char; PieceNum: Integer): string;
var
  tmp: TStringList;
begin
  Result := '';
  if S = '' then
    Exit;
  tmp := TStringList.Create;
  try
    ExtractStrings([Delim], [], PChar(S), tmp);
    if PieceNum <= tmp.Count then
      Result := tmp[PieceNum - 1];
  finally

    tmp.Free;
  end;
end;

function PieceByString(Value, Delimiter: string;
  StartPiece, EndPiece: Integer): string;
var
  dlen, i, pnum: Integer;
  buf: string;
begin
  Result := '';
  // Value := Uppercase(Value);
  // Delimiter := Uppercase(Delimiter);
  if (Value <> '') and (StartPiece > 0) and (EndPiece >= StartPiece) then
  begin
    dlen := Length(Delimiter);
    i := Pos(Delimiter, Value) - 1;
    if i >= 0 then
    begin
      buf := Value;
      pnum := 1;
      repeat
        if pnum > EndPiece then
          break;
        if i < 0 then
          i := Length(buf);
        if pnum = StartPiece then
          Result := Copy(buf, 1, i)
        else if pnum > StartPiece then
          Result := Result + Delimiter + Copy(buf, 1, i);
        Delete(buf, 1, i + dlen);
        i := Pos(Delimiter, buf) - 1;
        Inc(pnum);
      until (i < 0) and (buf = '');
    end
    else if StartPiece = 1 then
      Result := Value;
  end;
end;

procedure SetPiece(var x: string; Delim: char; PieceNum: Integer;
  const NewPiece: string);
{ sets the Nth piece (PieceNum) of a string to NewPiece, adding delimiters as necessary }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(x);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if i < PieceNum then
    x := x + StringOfChar(Delim, PieceNum - i) + NewPiece
  else
    x := Copy(x, 1, Strt - PChar(x)) + NewPiece + StrPas(Next);
end;

function HexToInt(const txt: string): LongWord;
begin
  Result := LongWord(StrToIntDef('$' + txt, 0));
end;

function AddrStr(addr: LongWord): string;
begin
  Result := Format('%.*d', [10, addr]);
end;

procedure SetPieces(var x: string; Delim: char; Pieces: array of Integer;
  FromString: string);
var
  i: Integer;
begin
  for i := low(Pieces) to high(Pieces) do
    SetPiece(x, Delim, Pieces[i], Piece(FromString, Delim, Pieces[i]));
end;

function MapWeightAddress(aTarget: string; aLine: string): Integer;

  function StrToLongWord(var aLngWrd: LongWord; aStr: string;
    aAdjustment: Integer = 0): Boolean;
  var
    aInt: Integer;
  begin
    Result := false;
    aInt := StrToIntDef(aStr, -1) + aAdjustment;
    if aInt >= 0 then
    begin
      Result := true;
      aLngWrd := aInt;
    end;
  end;

var
  _Target, _min, _max: LongWord;
  _Error: Boolean;
begin
  _Target := 0;

  _Error := not StrToLongWord(_Target, aTarget);
  if not _Error then
    _Error := not StrToLongWord(_min, Piece(aLine, '^', 1));
  if not _Error then
    _Error := not StrToLongWord(_max, Piece(aLine, '^', 2), -1);

  if not _Error then
  begin
    if _Target < _min then
      Result := -1
    else if _Target <= _max then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := LookUpErrorNum;
end;

function findPosition(aList: TStrings; aTarget: string;
  aStartPos, aEndPos: Integer; aWeight: TWeight): Integer;
var
  S: string;
  Pos, step, dir: Integer;
  Found: Boolean;
  CacheLookup: TStringList;
begin
  Result := -1;
  if not assigned(aList) then
    Exit;
  if aList.Count < 1 then
    Exit;

  Found := true;
  Pos := 0;
  step := aList.Count - 1;
  dir := aWeight(aTarget, aList[0]);
  if dir = LookUpErrorNum then
  begin
    Result := -2;
    Exit;
  end;
  case dir of
    - 1:
      Exit;
    0:
      Result := 0;
  else
    Found := false;
  end;

  if not Found then
  begin
    CacheLookup := TStringList.Create;
    try
      while not Found do
      begin
        step := step div 2;
        if step < 1 then
          step := 1;
        Pos := Pos + dir * step;
        if (Pos < aStartPos) or (Pos > aEndPos) then
          Exit;

        // logging positions to avoid cycling when there are gaps in the map
        S := IntToStr(Pos);
        if CacheLookup.IndexOf(S) > 0 then
        begin
          Result := -2;
          Exit;
        end
        else
          CacheLookup.Add(S);

        dir := aWeight(aTarget, aList[Pos]);
        if dir = LookUpErrorNum then
        begin
          Result := -2;
          Exit;
        end;
        Found := dir = 0;
        if Found then
          Result := Pos;
      end;
    finally
      FreeAndNil(CacheLookup);
    end;
  end;
end;

function DelimCount(const Str, Delim: string): Integer;
var
  i, dlen, slen: Integer;

begin
  Result := 0;
  i := 1;
  dlen := Length(Delim);
  slen := Length(Str) - dlen + 1;
  while (i <= slen) do
  begin
    if (Copy(Str, i, dlen) = Delim) then
    begin
      Inc(Result);
      Inc(i, dlen);
    end
    else
      Inc(i);
  end;
end;

procedure Replace(var InString: string;
  WhatToReplace, WhatToReplaceWith: string);
{
  does a search and replace within InString. Replaces all occurrences
  of "WhatToReplace" with "WhatToReplaceWith".
  Instring: The string we are going to modify
  WhatToReplace: The part of Instring that we are going to replace
  WhatToReplaceWith: The string we will replace WhatToReplace with.

  You can use this routine to delete characters by simply setting
  WhatToReplaceWith:='';
}
var
  ReplacePosition: Integer;
begin

  if WhatToReplace = WhatToReplaceWith then
    Exit;

  ReplacePosition := Pos(WhatToReplace, InString);
  if ReplacePosition <> 0 then
  begin
    repeat
      Delete(InString, ReplacePosition, Length(WhatToReplace));
      Insert(WhatToReplaceWith, InString, ReplacePosition);
      // ReplacePosition:=PosEx(WhatToReplace,InString,ReplacePosition);
      ReplacePosition := Pos(WhatToReplace, InString);
      // Remarkably, Pos is faster than PosEX, despite the ReplacePosition parameter in PosEx
    until ReplacePosition = 0;
  end; // if

end; // procedure

{$ENDREGION}

procedure LoadUnitsThreaded(aParser: TMapParser;
  aMasterList, aResultList: TStringList);
var
  idx: Integer;
  line, UnitName: string;
  addr, Next: LongWord;

begin
  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := aMasterList[idx];
    addr := aParser.GetAddress(line);
    if addr <> OutsideMapAddress then
    begin
      Next := addr + HexToInt(Piece(line, ' ', 3));
      UnitName := Piece(PieceByString(line, UnitPrefix, 2, 2), ' ', 1);
      aResultList.Add(AddrStr(addr) + '^' + AddrStr(Next) + '^' + UnitName);
    end;
  end;
end;

procedure LoadMethodsThreaded(aParser: TMapParser;
  aMasterList, aResultList: TStringList);
var
  idx: Integer;
  line, UnitName: string;
  addr: LongWord;
begin
  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := aMasterList[idx];
    addr := aParser.GetAddress(line);
    if addr <> OutsideMapAddress then
    begin
      UnitName := Trim(Copy(line, Pos(' ', line, 3), MaxInt));
      aResultList.Add(AddrStr(addr) + '^^' + UnitName + '^' + Copy(line, 2, 4));
    end;
  end;
end;

procedure LoadLinesThreaded(aParser: TMapParser;
  aMasterList, AResultList1: TStringList);
var
  idx, p: Integer;
  line, seg, lineNum: string;
  addr: LongWord;

begin
  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := Trim(aMasterList[idx]);
    if (line <> '') and (Pos(UnitSection, line) = 0) then
    begin
      while line <> '' do
      begin
        addr := aParser.GetAddress(line);
        if (addr = OutsideMapAddress) or (addr = aParser.FEndOfUnit) then
          line := ''
        else
        begin
          seg := Copy(line, Pos(':', line) - 4, 4);
          lineNum := Piece(line, ' ', 1);
          AResultList1.Add(AddrStr(addr) + '^^' + lineNum + '^' + seg);
        end;
        p := Pos(' ', line, 15);
        if p > 0 then
        begin
          Delete(line, 1, p);
          line := Trim(line);
        end
        else
          line := '';
      end;
    end;
  end;
end;

{$REGION 'tMapParser'}
{$REGION 'Threaded'}

procedure TMapParser.LoadUpMapFileThreaded(const ThreadOnDemand: Boolean);
const
  MaxLineCnt = 3; // Number of lines to process for each thread
var
  CoreCnt: Integer;
  CanContinue: Boolean;
  RtnCursor: Integer;

  function PreLoadWorkers(StrtStr: string; WorkerType: tThreadType;
    EndStr: string = ''): Boolean;
  var
    i, FromIdx, ToIdx, LastPos, SegmentCnt, LoopCnt: Integer;
    tmpStrLst: TStringList;
    aObj: TWorker;
  begin
    Result := false;

    // find the start and end point of the file
    FromIdx := FMapFile.IndexOfStrippedString(StrtStr);
    if WorkerType = ttLoadLines then
      FromIdx := FMapFile.IndexOfPiece(UnitSection, FromIdx);
    ToIdx := FMapFile.IndexOfStrippedString(EndStr, FromIdx + 2);

    // Ensure that we have our points
    if (FromIdx = -1) or (ToIdx = -1) then
      Exit;

    // Find how much to break up the text
    SegmentCnt := Ceil((ToIdx - FromIdx) / CoreCnt);
    LoopCnt := CoreCnt;

    tmpStrLst := TStringList.Create;
    try
      LastPos := FromIdx;
      // for each core grab the "chunk" of text
      for i := 1 to LoopCnt do
      begin
        // Get the remaining if at the end
        if i = LoopCnt then
          SegmentCnt := ToIdx - LastPos;

        // Grab the text
        tmpStrLst.Clear;
        FMapFile.StringsByNum(tmpStrLst, LastPos, SegmentCnt);

        // Create the worker
        aObj := TWorker.Create(Self, FThreadPool, WorkerType, tmpStrLst,
          FWorkerArray.Count + 1);

        // set the callback
        case WorkerType of
          ttLoadUnits:
            aObj.ThreadFunction := LoadUnitsThreaded;
          ttLoadMethods:
            aObj.ThreadFunction := LoadMethodsThreaded;
          ttLoadLines:
            aObj.ThreadFunction := LoadLinesThreaded;
        end;
        FWorkerArray.Add(aObj);

        // This will start the new thread (can be called after all have been setup too)
        if ThreadOnDemand then
          aObj.FireThread;

        // Update so we know where we left off
        Inc(LastPos, SegmentCnt + 1);

      end;
    finally
      tmpStrLst.Free;
    end;
    Result := true;
  end;

  procedure PostLoadWorkers(list: TStringList; aThreadType: tThreadType);
  var
    aObj: TWorker;

  begin
    aObj := TWorker.Create(Self, FThreadPool, aThreadType, list, 0);
    FWorkerArray.Add(aObj);
    if ThreadOnDemand then
      aObj.FireThread;
  end;

  procedure FireOffThreads;
  var
    aObj: TWorker;
  begin
    // Will loop throgh and start the threads
    for aObj in FWorkerArray do
      aObj.FireThread;
  end;

  procedure LoadResults;
  var
    Comp: IComparer<TWorker>;
    aObj: TWorker;

  begin
    // Sort the array by it's type and thread id
    Comp := TComparer<TWorker>.Construct(
      function(const Left, Right: TWorker): Integer
      begin
        Result := TComparer<tThreadType>.Default.Compare(Left.ThreadType,
          Right.ThreadType);
        if Result = 0 then
          Result := TComparer<Integer>.Default.Compare(Left.WorkerID,
            Right.WorkerID);
      end);

    // Sort the data array
    FWorkerArray.Sort(Comp);

    // Need to grad the last addrss from methods and add it to the start of the first (for the next part)
    for aObj in FWorkerArray do
    begin
      case aObj.ThreadType of
        ttLoadUnits:
          FUnitSection.AddStrings(aObj.ResultList);
        ttLoadMethods:
          FMethodSection.AddStrings(aObj.ResultList);
        ttLoadLines:
          FLines.AddStrings(aObj.ResultList);
      end;
    end;
  end;

begin
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crhourGlass;
  try

    // Assume we can load it
    FMapLoaded := LoadMapFile;

    // Init our variables
    FWorkerArray := TObjectList<TWorker>.Create;
    try
      CoreCnt := CPUCount - 1;
      if CoreCnt < 1 then // in case there's only 1 CPU
        CoreCnt := 1;
      FThreadPool := TThreadPool.Create(CoreCnt * 3); // one for each PreLoad

      // Run our setup
      CanContinue := PreLoadWorkers(SegmentMap, ttLoadUnits);
      if CanContinue then
        CanContinue := PreLoadWorkers(PublicsByValue, ttLoadMethods);
      if CanContinue then
        CanContinue := PreLoadWorkers(PublicsByValue, ttLoadLines,
          BoundResource);

      if not CanContinue then
      begin
        FMapLoaded := false;
        Exit;
      end;

      if not ThreadOnDemand then
        FireOffThreads;

      // Wait while we run
      while not(FThreadPool.AllTasksFinished) do
        Sleep(0);

      FUnitSection := TStringList.Create;
      FMethodSection := TStringList.Create;
      FLines := TStringList.Create;

      LoadResults;

      FWorkerArray.Clear;

      PostLoadWorkers(FUnitSection, ttSortUnits);
      PostLoadWorkers(FMethodSection, ttSortMethods);
      PostLoadWorkers(FLines, ttSortLines);

      if not ThreadOnDemand then
        FireOffThreads;

      // Wait while we run
      while not(FThreadPool.AllTasksFinished) do
        Sleep(0);

    finally
      FreeAndNil(FWorkerArray);
    end;

  finally
    Screen.Cursor := RtnCursor;
  end;
end;


procedure WorkerUpdate(aParser: TMapParser; list: TStringList);
var
  i, S: Integer;
  lastline, line, seg, lastseg, Next: string;
  getNext: Boolean;

begin
  lastseg := '';
  for i := 1 to list.Count do
  begin
    lastline := list[i - 1];
    if (i = list.Count) then
      line := '^^^FFFF'
    else
      line := list[i];
    Next := '';
    seg := Piece(line, '^', 4);
    if (seg = lastseg) then
      getNext := true
    else
    begin
      if lastseg = '' then
        getNext := true
      else
      begin
        getNext := false;
        S := HexToInt(lastseg);
        Next := AddrStr(aParser.FSegments[S].EndAddress);
      end;
      lastseg := seg;
    end;
    if getNext then
      Next := Piece(line, '^', 1);
    SetPiece(lastline, '^', 2, Next);
    list[i - 1] := lastline;
  end;
end;

procedure TMapParser.Assign(Source: TMapParser);
begin
  Self.FMapLoaded := Source.FMapLoaded;
  Self.FMapFile.Assign(Source.FMapFile);
  Self.FSegments.Assign(Source.FSegments);
  Self.FUnitSection.Assign(Source.FUnitSection);
  Self.FMethodSection.Assign(Source.FMethodSection);
  Self.FLines.Assign(Source.FLines);
  Self.FFileName := Source.FFileName;
  Self.FEndOfUnit := Source.FEndOfUnit;
end;

constructor TMapParser.CreateAndLoadThreaded(AThreadOnDemand: Boolean;
AFileName: string);
begin
  Create(AFileName);
  LoadUpMapFileThreaded(AThreadOnDemand);
end;

{$ENDREGION}
{$REGION 'Non Threaded'}

constructor TMapParser.Create(AFileName: string = '');
begin
  inherited Create;
  FFileName := AFileName;
  FMapFile := TStringList.Create;
  FSegments := TSegmentList.Create;
  FUnitSection := TStringList.Create;
  FMethodSection := TStringList.Create;
  FLines := TStringList.Create;
end;

constructor TMapParser.CreateAndLoad(AFileName: string = '';
ADummy: Integer = 0);
begin
  Create(AFileName);
  LoadUpMapFile;
end;

procedure TMapParser.LoadUpMapFile;
begin
  FMapLoaded := FMapLoaded or (LoadMapFile and LoadUnits and LoadMethods and LoadLines);
end;

function TMapParser.LoadMapFile: Boolean;

  // Returns True if segments were found and added to FSegments
  function LoadSegments: Boolean;
  const
    SegmentList = 'StartLengthNameClass';
  var
    i, p, seg: Integer;
    line: string;
    info: TSegmentInfo;

  begin
    Result := false;
    i := FMapFile.IndexOfStrippedString(SegmentList);
    if i < 0 then
      Exit;
    Inc(i);

    FSegments.Clear;
    info.StartAddress := 0;
    info.EndAddress := 0;
    while (i < FMapFile.Count) do
    begin
      line := FMapFile[i];
      p := Pos(':', line);
      if p > 4 then
      begin
        seg := HexToInt(Copy(line, p - 4, 4));
        while FSegments.Count < seg do
          FSegments.Add(info);
        info.StartAddress := HexToInt(Copy(line, p + 1, 8));
        info.EndAddress := info.StartAddress +
          HexToInt(Copy(Piece(line, ' ', 3), 1, 8)) - 1;
        FSegments.Add(info);
        if seg = 1 then
          FEndOfUnit := info.StartAddress;
        Result := true;
        Inc(i);
      end
      else
        Exit;
    end;
  end;

const
  MapFileExt = '.map';
begin
  if FFileName = '' then
  begin
    // Check for file name with version number first
    FFileName := TPath.GetFileNameWithoutExtension(Application.ExeName) +
      TExceptionLogger.FileVersion(Application.ExeName) + MapFileExt;
    if not FileExists(FFileName) then
    begin
      FFileName := ExtractFileName(Application.ExeName);
      FFileName := ChangeFileExt(FFileName, MapFileExt);
    end;
  end;
  if FileExists(FFileName) then
  begin
    FMapFile.LoadFromFile(FFileName);
    Result := LoadSegments;
  end
  else
    Result := false;
end;

destructor TMapParser.Destroy;
begin
  FreeAndNil(FLines);
  FreeAndNil(FMethodSection);
  FreeAndNil(FUnitSection);
  FreeAndNil(FSegments);
  FreeAndNil(FMapFile);
  FreeAndNil(FThreadPool);
  inherited;
end;

function TMapParser.LoadUnits: Boolean;

  function FindStartLoc: Integer;
  begin
    Result := FMapFile.IndexOfStrippedString(SegmentMap);
  end;

var
  idx: Integer;
  line, UnitName: string;
  addr, Next: LongWord;

begin

  idx := FindStartLoc;

  // if not found then we have an error
  if idx < 0 then
  begin
    Result := false;
    Exit;
  end
  else
    Result := true;

  // Move down 2 lines
  try
    Inc(idx, 2);
    repeat
      line := FMapFile[idx];
      addr := GetAddress(line);
      if addr <> OutsideMapAddress then
      begin
        Next := addr + HexToInt(Piece(line, ' ', 3));
        UnitName := Piece(PieceByString(line, UnitPrefix, 2, 2), ' ', 1);
        FUnitSection.Add(AddrStr(addr) + '^' + AddrStr(Next) + '^' + UnitName);
      end;
      Inc(idx, 1);
    until (line = '');

    FUnitSection.Sort;
  except
    Result := false;
  end;
end;

// Last Address^ current Address^ Method
function TMapParser.LoadMethods: Boolean;

  function FindStartLoc: Integer;
  const
    Val1 = 'AddressPublicsbyValue';
  begin
    Result := FMapFile.IndexOfStrippedString(Val1);
  end;

var
  idx, S, idx2: Integer;
  line, seg, lastseg, lastline, UnitName: string;
  addr, Next: LongWord;

begin

  idx := FindStartLoc;

  // if not found then we have an error
  if idx < 0 then
  begin
    Result := false;
    Exit;
  end
  else
    Result := true;

  // Move down 2 lines
  try
    Inc(idx, 2);
    seg := '';
    lastseg := '';
    repeat
      line := FMapFile[idx];
      if line = '' then
        seg := 'FFFF'
      else
      begin
        addr := GetAddress(line);
        if addr <> OutsideMapAddress then
        begin
          seg := Copy(line, Pos(':', line) - 4, 4);
          UnitName := Trim(Copy(line, Pos(' ', line, 3), MaxInt));
          FMethodSection.Add(AddrStr(addr) + '^^' + UnitName);
        end;
      end;
      if (seg <> lastseg) then
      begin
        if lastseg <> '' then
        begin
          S := HexToInt(lastseg);
          Next := FSegments[S].EndAddress;
          if line = '' then
            idx2 := 1
          else
            idx2 := 2;
          lastline := FMethodSection[FMethodSection.Count - idx2];
          SetPiece(lastline, '^', 2, AddrStr(Next));
          FMethodSection[FMethodSection.Count - idx2] := lastline;
        end;
        lastseg := seg
      end;
      Inc(idx, 1);
    until (line = '');

    FMethodSection.Sort;

    for idx := 1 to FMethodSection.Count - 1 do
    begin
      lastline := FMethodSection[idx - 1];
      if Piece(lastline, '^', 2) = '' then
      begin
        line := FMethodSection[idx];
        SetPiece(lastline, '^', 2, Piece(line, '^', 1));
        FMethodSection[idx - 1] := lastline;
      end;
    end;

  except
    Result := false;
  end;
end;

function TMapParser.LoadLines: Boolean;

  function FindStartLoc: Integer;
  const
    Val1 = 'AddressPublicsbyValue';
  begin
    Result := FMapFile.IndexOfStrippedString(Val1);
  end;

  function FindEndLoc(OffSet: Integer): Integer;
  const
    Val1 = 'Boundresourcefiles';
  begin
    Result := FMapFile.IndexOfStrippedString(Val1, OffSet);
  end;

var
  idx, EndIdx: Integer;
  line, lastline, lineNum, seg, lastseg, Next: string;
  i, p, S: Integer;
  addr: LongWord;
  getNext: Boolean;

begin

  idx := FindStartLoc;
  EndIdx := FindEndLoc(idx);
  // if not found then we have an error
  if (idx < 0) or (EndIdx < idx) then
  begin
    Result := false;
    Exit;
  end
  else
    Result := true;

  // Need to move past all the methods
  // while Pos(UnitSection, fMapFile[idx]) = 0 do
  // Inc(idx);
  Inc(idx, 2);
  while FMapFile[idx] <> '' do
    Inc(idx);

  // Move down 2 lines
  try
    Inc(idx, 2);
    seg := '';
    lastseg := '';
    for i := idx to EndIdx do
    begin
      line := Trim(FMapFile[i]);

      if (line <> '') and (Pos(UnitSection, line) = 0) then
      begin
        while line <> '' do
        begin
          addr := GetAddress(line);
          if (addr = OutsideMapAddress) or (addr = FEndOfUnit) then
            line := ''
          else
          begin
            seg := Copy(line, Pos(':', line) - 4, 4);
            lineNum := Piece(line, ' ', 1);
            FLines.Add(AddrStr(addr) + '^^' + lineNum + '^' + seg);
          end;
          p := Pos(' ', line, 15);
          if p > 0 then
          begin
            Delete(line, 1, p);
            line := Trim(line);
          end
          else
            line := '';
        end;
      end;
    end;

    FLines.Sort;

    for i := 1 to FLines.Count do
    begin
      lastline := FLines[i - 1];
      if (i = FLines.Count) then
        line := '^^^FFFF'
      else
        line := FLines[i];
      Next := '';
      seg := Piece(line, '^', 4);
      if (seg = lastseg) then
        getNext := true
      else
      begin
        if lastseg = '' then
          getNext := true
        else
        begin
          getNext := false;
          S := HexToInt(lastseg);
          Next := AddrStr(FSegments[S].EndAddress);
        end;
        lastseg := seg
      end;
      if getNext then
        Next := Piece(line, '^', 1);
      SetPiece(lastline, '^', 2, Next);
      FLines[i - 1] := lastline;
    end;
  except
    Result := false;
  end;
end;

function TMapParser.GetAddress(const addr: string): LongWord;
var
  seg, p: Integer;
  overflow: Int64;

begin
  Result := OutsideMapAddress;
  p := Pos(':', addr);
  if p > 4 then
  begin
    seg := HexToInt(Copy(addr, p - 4, 4));
    if seg < FSegments.Count then
    begin
      overflow := Int64(FSegments[seg].StartAddress) +
        Int64(HexToInt(Copy(addr, p + 1, 8)));
      if overflow > OutsideMapAddress then
        Result := OutsideMapAddress
      else
        Result := LongWord(overflow);
    end;
  end;
end;

procedure TMapParser.LookupInMap(const LookUpAddr: LongWord;
out AUnit, AMethod, ALineNumber: string);
begin
  AUnit := GetUnitName(LookUpAddr);
  if (AUnit = 'NA') then
  begin
    AMethod := '*** Unknown ***';
    ALineNumber := '-1';
  end
  else
  begin
    AMethod := GetMethodName(LookUpAddr);
    ALineNumber := GetLineNum(LookUpAddr, AUnit);
  end;
end;

function TMapParser.GetUnitName(const LookUpAddr: LongWord): string;
var
  UnitLineNum: Integer;
begin
  Result := 'NA';
  UnitLineNum := findPosition(FUnitSection, AddrStr(LookUpAddr), 0,
    FUnitSection.Count - 1, MapWeightAddress);
  if UnitLineNum > -1 then
    Result := Piece(FUnitSection[UnitLineNum], '^', 3);
end;

function TMapParser.GetIsMapLoaded: Boolean;
begin
  Result := FMapLoaded;
end;

function TMapParser.GetMethodName(const LookUpAddr: LongWord): string;
var
  MethodLineNum: Integer;
begin
  Result := '*** Unknown ***';
  MethodLineNum := findPosition(FMethodSection, AddrStr(LookUpAddr), 0,
    FMethodSection.Count - 1, MapWeightAddress);
  if MethodLineNum = -1 then
    Exit;
  Result := Trim(Piece(FMethodSection[MethodLineNum], '^', 3));
end;

function TMapParser.GetLineNum(const LookUpAddr: LongWord;
const UnitName: string): string;
var
  idx: Integer;

begin
  Result := '-1'; // '*** Unknown ***';
  idx := findPosition(FLines, AddrStr(LookUpAddr), 0, FLines.Count - 1,
    MapWeightAddress);
  if idx = -1 then
    Exit;
  Result := Trim(Piece(FLines[idx], '^', 3));
end;
{$ENDREGION}
{$ENDREGION}
{$REGION 'TStringsHelper'}

function TStringsHelper.IndexOfStrippedString(const S: string;
OffSet: Integer = 0): Integer;
var
  tmpStr: string;
begin
  Result := -1;
  if OffSet > GetCount - 1 then
    Exit;

  for Result := OffSet to GetCount - 1 do
  begin
    tmpStr := Strings[Result];
    Replace(tmpStr, ' ', '');
    if CompareStr(tmpStr, S) = 0 then
      Exit;
  end;
  Result := -1;
end;

function TStringsHelper.IndexOfPiece(const S: string;
OffSet: Integer = 0): Integer;
begin
  Result := -1;
  if OffSet > GetCount - 1 then
    Exit;

  for Result := OffSet to GetCount - 1 do
    if Pos(Uppercase(S), Uppercase(Strings[Result])) > 0 then
      Exit;
  Result := -1;
end;

procedure TStringsHelper.StringsByNum(ReturnList: TStringList;
OffSet: Integer = 0; Linecnt: Integer = 1);
var
  i: Integer;
begin
  for i := OffSet to OffSet + Linecnt do
    ReturnList.Add(Strings[i]);
end;

{$ENDREGION}
{$REGION 'TWorker'}

constructor TWorker.Create(const aParser: TMapParser;
const Handler: TThreadPool; aThreadType: tThreadType;
const aMasterList: TStringList; const aWrokerID: Integer);

begin
  fParser := aParser;
  FWorkerID := aWrokerID;
  fThreadType := aThreadType;
  case fThreadType of
    ttLoadUnits, ttLoadMethods, ttLoadLines:
      begin
        fMasterList := TStringList.Create;
        fResultList := TStringList.Create;
        fMasterList.Assign(aMasterList);
      end;

    ttSortUnits, ttSortMethods, ttSortLines:
      fResultList := aMasterList;
  end;
  fHandler := Handler;
end;

destructor TWorker.Destroy();
begin
  case fThreadType of
    ttLoadUnits, ttLoadMethods, ttLoadLines:
      begin
        FreeAndNil(fMasterList);
        FreeAndNil(fResultList);
      end;
  end;
  inherited;
end;

procedure TWorker.TakeAction(Sender: TObject);
begin
  case fThreadType of
    ttLoadUnits, ttLoadMethods, ttLoadLines:
      begin
        if assigned(fThreadFunc) then
          fThreadFunc(fParser, fMasterList, fResultList);
      end;

    ttSortUnits, ttSortMethods, ttSortLines:
      begin
        fResultList.Sort;
        if fThreadType <> ttSortUnits then
          WorkerUpdate(fParser, fResultList);
      end;
  end;
end;

procedure TWorker.FireThread;
begin
  fHandler.AddTask(TakeAction, nil);
end;

{$ENDREGION}
{ TSegmentList }

procedure TSegmentList.Assign(Source: TSegmentList);
var
  SegmentInfo: TSegmentInfo;
begin
  for SegmentInfo in Source do
  begin
    Self.Add(SegmentInfo);
  end;
end;

end.
