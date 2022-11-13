////////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///                     MAP FILE PARSER UNIT                                 ///
///                                                                          ///
///     -DESCRIPTION                                                         ///
///        This unit is responsible for parsing out he map file              ///
///        and searching for the map info from provided addresses            ///
///                                                                          ///
///                                                                          ///
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
  TWeight = function(aTarget, aLine: String): Integer;
  /// <summary>Function to be called by the thread</summary>
  /// <param name="aMasterList">The main list to move through</param>
  /// <param name="aResultList">The results list</param>
  TWorkThreadFunc = procedure(aParser: TMapParser; aMasterList, aResultList: TStringList);

  /// <summary>Additional methodes for the TStringList object</summary>
  TStringsHelper = class helper for TStrings
  public
    /// <summary>Finds the index of the string while stripping the spaces</summary>
    /// <param name="S">Substring that we want to find (should not have spaces)</param>
    /// <param name="OffSet">defines our starting position for the search</param>
    /// <returns>The index of the string or -1 if not found</returns>
    function IndexOfStrippedString(const S: string; OffSet: Integer = 0): Integer;
    /// <summary>Finds the index where a specific substring exist</summary>
    /// <param name="S">Substring to search for</param>
    /// <param name="OffSet">The starting point to begin the search</param>
    /// <returns>The first index where the substring was found</returns>
    function IndexOfPiece(const S: string; OffSet: Integer = 0): Integer;
    /// <summary>Retrieves a set of strings from a specific index on</summary>
    /// <param name="ReturnList">Return list where the strings should be placed</param>
    /// <param name="OffSet">Index to start processing at</param>
    /// <param name="Linecnt">How many lines to go past the Offset</param>
    Procedure StringsByNum(ReturnList: TStringList; OffSet: Integer = 0; Linecnt: Integer = 1);
  end;

 // * Thread Types *
 // <table>
 //    Type Name      Meaning
 //    -------------  -------------
 //    TYPE_UNIT      Processing the unit section
 //    TYPE_METHOD    Processing the Method section
 //    TYPE_LINES     Processing the Lines section
 //</table>
  tThreadType = (ttLoadUnits, ttLoadMethods, ttLoadLines, ttSortUnits, ttSortMethods, ttSortLines);

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
    Property ThreadFunction: TWorkThreadFunc read fThreadFunc write fThreadFunc;
    property ThreadType: tThreadType read fThreadType write fThreadType;
    Property WorkerID: Integer read FWorkerID write FWorkerID;
  end;

  TSegmentInfo = record
    StartAddress: LongWord;
    EndAddress: LongWord;
  end;

  TMapParser = class(TObject)
  private
    fMapLoaded: Boolean;
    fMapFile: TStringList;
    fSegments: TList<TSegmentInfo>;
    fUnitSection: TStringList;
    fMethodSection: TStringList;
    fLines: TStringList;
    fFileName: String;
  //  fStopWatch: TStopWatch;
    fworkerArray: TObjectList<TWorker>;
    fThreadPool: TThreadPool;
    fEndOfUnit: LongWord;
    Function LoadMapFile: Boolean;
    Function LoadUnits: Boolean;
    Function LoadMethods: Boolean;
    Function LoadLines: Boolean;
    function GetUnitName(const LookUpAddr: LongWord): string;
    function GetMethodName(const LookUpAddr: LongWord): string;
    function GetLineNum(const LookUpAddr: LongWord; const UnitName: string): string;
    function GetAddress(const addr: String): LongWord;
    procedure CreateThreaded(Const ThreadOnDemand: Boolean);
  public
    constructor Create(aFileName: string = ''); overload;
    constructor Create(ThreadOnDemand: Boolean; aFileName: string = ''); overload;
    destructor Destroy; override;
    procedure LookupInMap(const LookUpAddr: LongWord; out aUnit, aMethod, aLineNumber: String);
    Property FileName: string read fFileName;
    property MapLoaded: Boolean read fMapLoaded;
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
  System.Math;

const
  UnitPrefix = ' M=';
  SegmentMap = 'Detailedmapofsegments';
  PublicsByValue = 'AddressPublicsbyValue';
  BoundResource = 'Boundresourcefiles';
  UnitSection = 'Line numbers for ';
  LookUpErrorNum = -3;
  OutsideMapAddress = $FFFFFFFF;

Procedure LoadUnitsThreaded(aParser: TMapParser; aMasterList, aResultList: TStringList); forward;
Procedure LoadMethodsThreaded(aParser: TMapParser; aMasterList, aResultList: TStringList); forward;
Procedure LoadLinesThreaded(aParser: TMapParser; aMasterList, aResultList: TStringList); forward;

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
  for b := 0 to pred(High(c)) do
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

function PieceByString(Value, Delimiter: string; StartPiece, EndPiece: Integer): string;
var
  dlen, i, pnum: Integer;
  buf: String;
begin
  Result := '';
//  Value := Uppercase(Value);
//  Delimiter := Uppercase(Delimiter);
  if (Value <> '') And (StartPiece > 0) And (EndPiece >= StartPiece) then
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
      until (i < 0) And (buf = '');
    end
    else if StartPiece = 1 then
      Result := Value;
  end;
end;

procedure SetPiece(var x: string; Delim: char; PieceNum: Integer; const NewPiece: string);
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

procedure SetPieces(var x: string; Delim: char; Pieces: Array of Integer; FromString: string);
var
  i: Integer;
begin
  for i := low(Pieces) to high(Pieces) do
    SetPiece(x, Delim, Pieces[i], Piece(FromString, Delim, Pieces[i]));
end;

function MapWeightAddress(aTarget: String; aLine: String): Integer;

  Function StrToLongWord(var aLngWrd: LongWord; aStr: String; aAdjustment: Integer = 0): Boolean;
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
  end else
   Result := LookUpErrorNum;
end;

function findPosition(aList: TStrings; aTarget: String; aStartPos, aEndPos: Integer; aWeight: TWeight): Integer;
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
    exit;
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
          exit;
        end;
        Found := dir = 0;
        if Found then
          Result := Pos;
      end;
    Finally
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

procedure Replace(Var InString: String; WhatToReplace, WhatToReplaceWith: String);
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
      ReplacePosition := Pos(WhatToReplace, InString); // Remarkably, Pos is faster than PosEX, despite the ReplacePosition parameter in PosEx
    until ReplacePosition = 0;
  end; // if

end; // procedure

{$ENDREGION}
{$REGION 'tMapParser'}
{$REGION 'Threaded'}

procedure tMapParser.CreateThreaded(Const ThreadOnDemand: Boolean);
const
  MaxLineCnt = 3; // Number of lines to process for each thread
var
  CoreCnt: Integer;
  CanContinue: Boolean;
  RtnCursor: Integer;

  function PreLoadWorkers(StrtStr: String; WorkerType: tThreadType; EndStr: string = ''): Boolean;
  var
    i, FromIdx, ToIdx, LastPos, SegmentCnt, LoopCnt: Integer;
    tmpStrLst: TStringList;
    aObj: TWorker;
  begin
    Result := false;

    // find the start and end point of the file
    FromIdx := fMapFile.IndexOfStrippedString(StrtStr);
    if WorkerType = ttLoadLines then
      FromIdx := fMapFile.IndexOfPiece(UnitSection, FromIdx);
    ToIdx := fMapFile.IndexOfStrippedString(EndStr, FromIdx + 2);

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
        fMapFile.StringsByNum(tmpStrLst, LastPos, SegmentCnt);

        // Create the worker
        aObj := TWorker.Create(Self, fThreadPool, WorkerType, tmpStrLst, fworkerArray.Count + 1);

        // set the callback
        case WorkerType of
          ttLoadUnits:
            aObj.ThreadFunction := LoadUnitsThreaded;
          ttLoadMethods:
            aObj.ThreadFunction := LoadMethodsThreaded;
          ttLoadLines:
            aObj.ThreadFunction := LoadLinesThreaded;
        end;
        fworkerArray.Add(aObj);

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
    aObj := TWorker.Create(Self, fThreadPool, aThreadType, list, 0);
    fworkerArray.Add(aObj);
    if ThreadOnDemand then
      aObj.FireThread;
  end;

  procedure FireOffThreads;
  var
    aObj: TWorker;
  begin
    // Will loop throgh and start the threads
    for aObj in fworkerArray do
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
        Result := TComparer<tThreadType>.Default.Compare(Left.ThreadType, Right.ThreadType);
        if Result = 0 then
          Result := TComparer<Integer>.Default.Compare(Left.WorkerID, Right.WorkerID);
      end);

    // Sort the data array
    fworkerArray.Sort(Comp);

    // Need to grad the last addrss from methods and add it to the start of the first (for the next part)
    for aObj in fworkerArray do
    begin
      case aObj.ThreadType of
        ttLoadUnits:
          fUnitSection.AddStrings(aObj.ResultList);
        ttLoadMethods:
          fMethodSection.AddStrings(aObj.ResultList);
        ttLoadLines:
          fLines.AddStrings(aObj.ResultList);
      end;
    end;
  end;

begin
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crhourGlass;
  try

    // Assume we can load it
    fMapLoaded := LoadMapFile;

    // Init our variables
    fworkerArray := TObjectList<TWorker>.Create;
    try
      CoreCnt := CPUCount - 1;
      if CoreCnt < 1 then   // in case there's only 1 CPU
        CoreCnt := 1;
      fThreadPool := TThreadPool.Create(CoreCnt * 3); // one for each PreLoad

      // Run our setup
      CanContinue := PreLoadWorkers(SegmentMap, ttLoadUnits);
      if CanContinue then
        CanContinue := PreLoadWorkers(PublicsByValue, ttLoadMethods);
      if CanContinue then
        CanContinue := PreLoadWorkers(PublicsByValue, ttLoadLines, BoundResource);

      if not CanContinue then
      begin
        fMapLoaded := false;
        Exit;
      end;

      if not ThreadOnDemand then
        FireOffThreads;

      // Wait while we run
      While Not(fThreadPool.AllTasksFinished) Do
        Sleep(0);

      fUnitSection := TStringList.Create;
      fMethodSection := TStringList.Create;
      fLines := TStringList.Create;

      LoadResults;

      fworkerArray.Clear;

      PostLoadWorkers(fUnitSection, ttSortUnits);
      PostLoadWorkers(fMethodSection, ttSortMethods);
      PostLoadWorkers(fLines, ttSortLines);

      if not ThreadOnDemand then
        FireOffThreads;

      // Wait while we run
      While Not(fThreadPool.AllTasksFinished) Do
        Sleep(0);

    finally
      FreeAndNil(fworkerArray);
    end;

  Finally
    Screen.Cursor := RtnCursor;
  end;
end;

procedure LoadUnitsThreaded(aParser: TMapParser; aMasterList, aResultList: TStringList);
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

Procedure LoadMethodsThreaded(aParser: TMapParser; aMasterList, aResultList: TStringList);
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
      UnitName := trim(copy(line, Pos(' ', line, 3), MaxInt));
      aResultList.Add(AddrStr(addr) + '^^' + UnitName + '^' + copy(line,2,4));
    end;
  end;
end;

Procedure LoadLinesThreaded(aParser: TMapParser; aMasterList, aResultList: TStringList);
var
  idx, p: Integer;
  line, seg, lineNum: string;
  addr: LongWord;

begin
  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := trim(aMasterList[idx]);
    if (line <> '') and (pos(UnitSection, line) = 0) then
    begin
      while line <> '' do
      begin
        addr := aParser.GetAddress(line);
        if (addr = OutsideMapAddress) or (addr = aParser.fEndOfUnit) then
          line := ''
        else
        begin
          seg := copy(line, pos(':', line) - 4, 4);
          lineNum := Piece(line, ' ', 1);
          aResultList.Add(AddrStr(addr) + '^^' + lineNum + '^' + seg);
        end;
        p := pos(' ', line, 15);
        if p > 0 then
        begin
          delete(line, 1, p);
          line := trim(line);
        end
        else
          line := '';
      end;
    end;
  end;
end;

procedure WorkerUpdate(aParser: TMapParser; list: TStringList);
var
  i, s: Integer;
  lastline, line, seg, lastseg, next: String;
  getNext: boolean;

begin
  lastseg := '';
  for i := 1 to list.Count do
  begin
    lastline := list[i - 1];
    if (i = list.Count) then
      line := '^^^FFFF'
    else
      line := list[i];
    next := '';
    seg := piece(line, '^', 4);
    if (seg = lastseg) then
      getNext := True
    else
    begin
      if lastseg = '' then
        getNext := True
      else
      begin
        getNext := false;
        s := HexToInt(lastseg);
        next := AddrStr(aParser.fSegments[s].EndAddress);
      end;
      lastseg := seg;
    end;
    if getNext then
      next := Piece(line, '^', 1);
    SetPiece(lastline, '^', 2, next);
    list[i - 1] := lastline;
  end;
end;

constructor tMapParser.Create(ThreadOnDemand: Boolean; aFileName: string = '');
begin
  inherited Create;
 // fStopWatch := TStopWatch.Create(nil, true);
 // try
 //   fStopWatch.Start;
 //   try
      fFileName := aFileName;
      CreateThreaded(ThreadOnDemand);
 //   finally
  //    fStopWatch.Stop;
 //     ShowMessage('Load of the map file: ' + fStopWatch.Elapsed);
 //   end;
 // finally
 //   fStopWatch.Free;
 // end;

end;

{$ENDREGION}
{$REGION 'Non Threaded'}

constructor tMapParser.Create(aFileName: string = '');
begin
  inherited Create;
 // fStopWatch := TStopWatch.Create(nil, true);
//  try
  //  fStopWatch.Start;
  //  try
      // Assume we can load it

      fFileName := aFileName;
      fMapLoaded := LoadMapFile;

      // No need to waste time if we are missing some info
      if fMapLoaded then
        fMapLoaded := LoadUnits;
      if fMapLoaded then
        fMapLoaded := LoadMethods;
      if fMapLoaded then
        fMapLoaded := LoadLines;
  //  finally
  //    fStopWatch.Stop;
  //    ShowMessage('Load of the map file: ' + fStopWatch.Elapsed);
  //  end;

 // finally
 //   fStopWatch.Free;
 // end;
end;

Function tMapParser.LoadMapFile: Boolean;
const
  MapFileExt = '.map';
  SegmentList =  'StartLengthNameClass';

  function LoadSegments: boolean;
  var
    i, p, seg: integer;
    line: string;
    info: TSegmentInfo;

  begin
    Result := False;
    i := fMapFile.IndexOfStrippedString(SegmentList);
    if i < 0 then
      exit;
    inc(i);
    if assigned(fSegments) then
      fSegments.Clear
    else
      fSegments := TList<TSegmentInfo>.Create;
    info.StartAddress := 0;
    info.EndAddress := 0;
    while (i < fMapFile.Count) do
    begin
      line := fMapFile[i];
      p := pos(':', line);
      if p > 4 then
      begin
        seg := HexToInt(copy(line, p - 4, 4));
        while fSegments.Count < seg do
          fSegments.Add(info);
        info.StartAddress := HexToInt(copy(line, p + 1, 8));
        info.EndAddress := info.StartAddress + HexToInt(copy(piece(line, ' ', 3),1,8)) - 1;
        fSegments.Add(info);
        if seg = 1 then
          fEndOfUnit := info.StartAddress;
        Result := True;
        Inc(i);
      end
      else
        exit;
    end;
  end;

begin
  fMapFile := TStringList.Create;
  if fFileName = '' then
  begin
    fFileName := ExtractFileName(Application.exename);
    fFileName := ChangeFileExt(fFileName, MapFileExt);
  end;
  if FileExists(fFileName) then
  begin
    fMapFile.LoadFromFile(fFileName);
    Result := LoadSegments;
  end
  else
    Result := false;
end;

destructor tMapParser.Destroy;
begin
  fMapFile.Free;
  if assigned(fSegments) then
    fSegments.Free;
  fUnitSection.Free;
  fMethodSection.Free;
  fLines.Free;
  if assigned(fThreadPool) then
    FreeAndNil(fThreadPool);
  inherited;
end;

Function tMapParser.LoadUnits: Boolean;

  Function FindStartLoc: Integer;
  begin
    Result := fMapFile.IndexOfStrippedString(SegmentMap);
  end;

var
  idx: Integer;
  line, UnitName: string;
  addr, Next: LongWord;

begin
  fUnitSection := TStringList.Create;

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
      line := fMapFile[idx];
      addr := GetAddress(line);
      if addr <> OutsideMapAddress then
      begin
        Next := addr + HexToInt(Piece(line, ' ', 3));
        UnitName := Piece(PieceByString(line, UnitPrefix, 2, 2), ' ', 1);
        fUnitSection.Add(AddrStr(addr) + '^' + AddrStr(Next) + '^' + UnitName);
      end;
      Inc(idx, 1);
    until (line = '');

    fUnitSection.Sort;
  except
    Result := false;
  end;
end;

// Last Address^ current Address^ Method
Function tMapParser.LoadMethods: Boolean;

  Function FindStartLoc: Integer;
  const
    Val1 = 'AddressPublicsbyValue';
  begin
    Result := fMapFile.IndexOfStrippedString(Val1);
  end;

var
  idx, s, idx2: Integer;
  line, seg, lastseg, lastline, UnitName: string;
  addr, next: LongWord;

begin
  fMethodSection := TStringList.Create;

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
      line := fMapFile[idx];
      if line = '' then
        seg := 'FFFF'
      else
      begin
        addr := GetAddress(line);
        if addr <> OutsideMapAddress then
        begin
          seg := Copy(line, Pos(':', line) - 4, 4);
          UnitName := trim(copy(line, pos(' ', line, 3), MaxInt));
          fMethodSection.Add(AddrStr(addr) + '^^' + UnitName);
        end;
      end;
      if (seg <> lastseg) then
      begin
        if lastseg <> '' then
        begin
          s := HexToInt(lastseg);
          next := fSegments[s].EndAddress;
          if line = '' then
            idx2 := 1
          else
            idx2 := 2;
          lastline := fMethodSection[fMethodSection.Count - idx2];
          SetPiece(lastline, '^', 2, AddrStr(next));
          fMethodSection[fMethodSection.Count - idx2] := lastline;
        end;
        lastseg := seg
      end;
      Inc(idx, 1);
    until (line = '');

    fMethodSection.Sort;

    for idx := 1 to fMethodSection.Count-1 do
    begin
      lastline := fMethodSection[idx - 1];
      if piece(lastline, '^', 2) = '' then
      begin
        line := fMethodSection[idx];
        SetPiece(lastline, '^', 2, Piece(line, '^', 1));
        fMethodSection[idx - 1] := lastline;
      end;
    end;

  except
    Result := false;
  end;
end;

Function tMapParser.LoadLines: Boolean;

  Function FindStartLoc: Integer;
  const
    Val1 = 'AddressPublicsbyValue';
  begin
    Result := fMapFile.IndexOfStrippedString(Val1);
  end;

  Function FindEndLoc(OffSet: Integer): Integer;
  const
    Val1 = 'Boundresourcefiles';
  begin
    Result := fMapFile.IndexOfStrippedString(Val1, OffSet);
  end;

var
  idx, EndIdx: Integer;
  line, lastLine, lineNum, seg, lastseg, next: string;
  i, p, s: Integer;
  addr: LongWord;
  getNext: boolean;

begin
  fLines := TStringList.Create;

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
  while fMapFile[idx] <> '' do
    Inc(idx);

  // Move down 2 lines
  try
    Inc(idx, 2);
    seg := '';
    lastseg := '';
    for i := idx to EndIdx do
    begin
      line := trim(fMapFile[i]);

      if (line <> '') and (pos(UnitSection, line) = 0) then
      begin
        while line <> '' do
        begin
          addr := GetAddress(line);
          if (addr = OutsideMapAddress) or (addr = fEndOfUnit) then
            line := ''
          else
          begin
            seg := copy(line, pos(':', line) - 4, 4);
            lineNum := Piece(line, ' ', 1);
            fLines.Add(AddrStr(addr) + '^^' + lineNum + '^' + seg);
          end;
          p := pos(' ', line, 15);
          if p > 0 then
          begin
            delete(line, 1, p);
            line := trim(line);
          end
          else
            line := '';
        end;
      end;
    end;

    fLines.Sort;

    for i := 1 to fLines.Count do
    begin
      lastline := fLines[i - 1];
      if (i = fLines.Count) then
        line := '^^^FFFF'
      else
        line := fLines[i];
      next := '';
      seg := piece(line, '^', 4);
      if (seg = lastseg) then
        getNext := True
      else
      begin
        if lastseg = '' then
          getNext := True
        else
        begin
          getNext := false;
          s := HexToInt(lastseg);
          next := AddrStr(fSegments[s].EndAddress);
        end;
        lastseg := seg
      end;
      if getNext then
        next := Piece(line, '^', 1);
      SetPiece(lastline, '^', 2, next);
      fLines[i - 1] := lastline;
    end;
  except
    Result := false;
  end;
end;

function TMapParser.GetAddress(const addr: String): LongWord;
var
  seg, p: integer;
  overflow: Int64;

begin
  Result := OutsideMapAddress;
  p := Pos(':', addr);
  if p > 4 then
  begin
    seg := HexToInt(Copy(addr, p - 4, 4));
    if seg < fSegments.Count then
    begin
      overflow :=  Int64(fSegments[seg].StartAddress) + Int64(HexToInt(copy(addr, p + 1, 8)));
      if overflow > OutsideMapAddress then
         Result := OutsideMapAddress
      else
        Result := LongWord(overflow);
    end;
  end;
end;

procedure tMapParser.LookupInMap(const LookUpAddr: LongWord; out aUnit, aMethod, aLineNumber: String);
begin
  aUnit := GetUnitName(LookUpAddr);
  if (aUnit = 'NA') then
  begin
    aMethod := '*** Unknown ***';
    aLineNumber := '-1';
  end
  else
  begin
    aMethod := GetMethodName(LookUpAddr);
    aLineNumber := GetLineNum(LookUpAddr, aUnit);
  end;
end;

function tMapParser.GetUnitName(const LookUpAddr: LongWord): string;
var
  UnitLineNum: Integer;
begin
  Result := 'NA';
  UnitLineNum := findPosition(fUnitSection, AddrStr(LookUpAddr), 0, fUnitSection.Count - 1, MapWeightAddress);
  if UnitLineNum > -1 then
    Result := Piece(fUnitSection[UnitLineNum], '^', 3);
end;

function tMapParser.GetMethodName(const LookUpAddr: LongWord): string;
var
  MethodLineNum: Integer;
begin
  Result := '*** Unknown ***';
  MethodLineNum := findPosition(fMethodSection, AddrStr(LookUpAddr), 0, fMethodSection.Count - 1, MapWeightAddress);
  if MethodLineNum = -1 then
    Exit;
  Result := Trim(Piece(fMethodSection[MethodLineNum], '^', 3));
end;

function tMapParser.GetLineNum(const LookUpAddr: LongWord; const UnitName: string): string;
var
  idx: integer;

begin
  Result := '-1'; // '*** Unknown ***';
  idx := findPosition(fLines, AddrStr(LookUpAddr), 0, fLines.Count - 1, MapWeightAddress);
  if idx = -1 then
    Exit;
  Result := Trim(Piece(fLines[idx], '^', 3));
end;
{$ENDREGION}
{$ENDREGION}
{$REGION 'TStringsHelper'}

function TStringsHelper.IndexOfStrippedString(const S: string; OffSet: Integer = 0): Integer;
var
  tmpStr: String;
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

function TStringsHelper.IndexOfPiece(const S: string; OffSet: Integer = 0): Integer;
begin
  Result := -1;
  if OffSet > GetCount - 1 then
    Exit;

  for Result := OffSet to GetCount - 1 do
    if Pos(Uppercase(S), Uppercase(Strings[Result])) > 0 then
      Exit;
  Result := -1;
end;

Procedure TStringsHelper.StringsByNum(ReturnList: TStringList; OffSet: Integer = 0; Linecnt: Integer = 1);
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

end.
