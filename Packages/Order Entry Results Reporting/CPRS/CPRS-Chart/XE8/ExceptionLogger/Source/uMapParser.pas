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
  System.Classes, Vcl.Forms, System.SysUtils, System.IniFiles, UStopWatch, Vcl.Dialogs, Winapi.Windows, UThreadPool,
  System.Generics.Defaults, System.Generics.Collections;

type

  /// <summary>custom Weight function used for the binary searching</summary>
  /// <param name="aTarget">The search criteria</param>
  /// <param name="aLine">The direction to move</param>
  /// <returns>The direction to move</returns>
  TWeight = function(aTarget, aLine: String): Integer;
  /// <summary>Function to be called by the thread</summary>
  /// <param name="aMasterList">The main list to move through</param>
  /// <param name="aResultList">The results list</param>
  /// <param name="aExtList">Additonal list that can be filled out</param>
  TWorkThreadFunc = procedure(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);

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
    /// <param name="ReturnList">Reutnr list where the strings should be placed</param>
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
  tThreadType = (TYPE_UNIT, TYPE_METHOD, TYPE_LINES);

  TWorker = class
    FWorkerID: Integer;
    fThreadType: tThreadType;
    fMasterList: TStringList;
    fResultList: TStringList;
    fExtList: TStringList;
    fThreadFunc: TWorkThreadFunc;
    fHandler: TThreadPool;
  private
    procedure TakeAction(Sender: TObject);
  public
    constructor Create(const Handler: TThreadPool; aThreadType: tThreadType; const aMasterList: TStringList; const aWrokerID: Integer);
    destructor Destroy(); override;
    procedure FireThread;
    property ResultList: TStringList read fResultList;
    property ExtList: TStringList read fExtList;
    Property ThreadFunction: TWorkThreadFunc read fThreadFunc write fThreadFunc;
    property ThreadType: tThreadType read fThreadType write fThreadType;
    Property WorkerID: Integer read FWorkerID write FWorkerID;
  end;

  tMapParser = class(TObject)
  private
    fMapLoaded: Boolean;
    fMapFile: TStringList;
    fUnitSection: TStringList;
    fMethodSection: TStringList;
    fLinesSections: TStringList;
    fLines: TStringList;
    fFileName: String;
    FUnitMax: THashedStringList;
  //  fStopWatch: TStopWatch;
    fworkerArray: TObjectList<TWorker>;
    fThreadPool: TThreadPool;
    Function LoadMapFile: Boolean;
    Function LoadUnits: Boolean;
    Function LoadMethods: Boolean;
    Function LoadLines: Boolean;
    Function LineSearch(const LookUpAddr: LongWord; const UnitName: String): Integer;
    function GetUnitName(const LookUpAddr: LongWord): string;
    function GetMethodName(const LookUpAddr: LongWord): string;
    function GetLineNum(const LookUpAddr: LongWord; const UnitName: string): string;
  public
    constructor Create; overload;
    constructor Create(ThreadOnDemand: Boolean = true); overload;
    procedure CreateThreaded(Const ThreadOnDemand: Boolean);
    destructor Destroy; override;
    procedure LookupInMap(const LookUpAddr: LongWord; out aUnit, aMethod, aLineNumber: String);
    Property FileName: string read fFileName;
    property MapLoaded: Boolean read fMapLoaded;
    property _UnitName[const LookUpAddr: LongWord]: string read GetUnitName;
    property _MethodName[const LookUpAddr: LongWord]: string read GetMethodName;
  end;

Procedure LoadUnitsThreaded(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);
Procedure LoadMethodsThreaded(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);
Procedure LoadLinesThreaded(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);

implementation

uses
  System.StrUtils, Vcl.Controls, System.Math;

const
  UnitPrefix = ' M=';
  SegmentMap = 'Detailedmapofsegments';
  PublicsByValue = 'AddressPublicsbyValue';
  BoundResource = 'Boundresourcefiles';
  UnitSection = 'Line numbers for ';
  LookUpErrorNum = -3;

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
  Value := Uppercase(Value);
  Delimiter := Uppercase(Delimiter);
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
    if WorkerType = TYPE_LINES then
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
        aObj := TWorker.Create(fThreadPool, WorkerType, tmpStrLst, fworkerArray.Count + 1);

        // set the callback
        case WorkerType of
          TYPE_UNIT:
            aObj.ThreadFunction := LoadUnitsThreaded;
          TYPE_METHOD:
            aObj.ThreadFunction := LoadMethodsThreaded;
          TYPE_LINES:
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
    i: Integer;
    Comp: IComparer<TWorker>;
    LAddrStr, NewText: String;
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
        TYPE_UNIT:
          begin
            fUnitSection.AddStrings(aObj.ResultList);
            FUnitMax.AddStrings(aObj.ExtList);
          end;
        TYPE_METHOD:
          begin
            // With it sorted we need to peice some data together
            if fMethodSection.Count > 0 then
            begin
              // Grab the last address
              LAddrStr := Piece(fMethodSection[fMethodSection.Count - 1], '^', 2);
              // Need to tack this on to the new line
              NewText := aObj.ResultList.Strings[0];
              SetPiece(NewText, '^', 1, LAddrStr);
              aObj.ResultList.Strings[0] := NewText;
            end;
            // Add these results to the list
            fMethodSection.AddStrings(aObj.ResultList);

          end;
        TYPE_LINES:
          begin
            // Need to adjust the extlist line values by the current length (if already added)
            if fLinesSections.Count > 0 then
            begin
              for i := 0 to aObj.ExtList.Count - 1 do
                aObj.ExtList.ValueFromIndex[i] := IntToStr(StrToIntDef(aObj.ExtList.ValueFromIndex[i], -1) + (fLines.Count));
            end;

            fLines.AddStrings(aObj.ResultList);
            fLinesSections.AddStrings(aObj.ExtList);

          end;
      end;
    end;

    fUnitSection.Sort;
    fMethodSection.Sort;

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
      fThreadPool := TThreadPool.Create(CoreCnt);

      // Run our setup
      CanContinue := PreLoadWorkers(SegmentMap, TYPE_UNIT);
      if CanContinue then
        CanContinue := PreLoadWorkers(PublicsByValue, TYPE_METHOD);
      if CanContinue then
        CanContinue := PreLoadWorkers(PublicsByValue, TYPE_LINES, BoundResource);

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
      FUnitMax := THashedStringList.Create;
      fMethodSection := TStringList.Create;
      fLines := TStringList.Create;
      fLinesSections := THashedStringList.Create;

      LoadResults;

    finally
      FreeAndNil(fworkerArray);
    end;

  Finally
    Screen.Cursor := RtnCursor;
  end;
end;

procedure LoadUnitsThreaded(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);
var
  idx: Integer;
  line, tmpStr, _UnitName: string;
  addr, Next, len: LongWord;
begin

  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := aMasterList[idx];
    if (Piece(line, ' ', 4) = 'C=CODE') then
    begin
      tmpStr := Piece(line, ':', 2);
      addr := StrToInt('$' + Piece(tmpStr, ' ', 1));
      len := StrToInt('$' + Piece(tmpStr, ' ', 2));
      Next := addr + len;
      _UnitName := '';
      _UnitName := Piece(PieceByString(line, UnitPrefix, 2, 2), ' ', 1);
      aResultList.Add(Format('%.*d', [8, addr]) + '^' + Format('%.*d', [8, Next]) + '^' + _UnitName);

      aExtList.Add(_UnitName + '=' + IntToStr(Next));
    end;
  end;
end;

Procedure LoadMethodsThreaded(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);
var
  idx: Integer;
  line, tmpStr, tmpStr2: string;
  LAddr, addr1: LongWord;
begin

  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := aMasterList[idx];

    if (Trim(Piece(line, ':', 1)) = '0001') then
    begin
      tmpStr := Piece(line, ':', 2);

      addr1 := StrToInt('$' + Piece(tmpStr, ' ', 1));
      LAddr := 0;
      if (idx + 1) <= aMasterList.Count - 1 then
      begin
        if (aMasterList[idx + 1] <> '') then
        begin
          tmpStr2 := Piece(aMasterList[idx + 1], ':', 2);
          LAddr := StrToInt('$' + Piece(tmpStr2, ' ', 1));
        end;
      end;

      // Chop of the address
      tmpStr := Copy(tmpStr, Pos(' ', tmpStr), Length(tmpStr));

      aResultList.Add(Format('%.*d', [8, addr1]) + '^' + Format('%.*d', [8, LAddr]) + '^' + Trim(tmpStr));
    end;
  end;
end;

Procedure LoadLinesThreaded(aMasterList, aResultList: TStringList; aExtList: TStringList = nil);
var
  idx, AddLineNum: Integer;
  line, tmpStr: string;
  insertLastLine: Boolean;
begin
  insertLastLine := false;

  for idx := 0 to aMasterList.Count - 1 do
  begin
    line := aMasterList[idx];

    if Pos(UnitSection, line) > 0 then
    begin
      tmpStr := Piece(line, '(', 1);
      AddLineNum := aResultList.Add(line);
      aExtList.Add(Piece(tmpStr, ' ', 4) + '=' + IntToStr(AddLineNum));
      insertLastLine := true;
    end;

    if (line = '') and insertLastLine then
    begin
      // aResultList.Add(' XXX 0001:' + IntToHex(FUnitMax, 8));
      insertLastLine := false;
    end;

    if Pos('0001:', line) > 0 then
      aResultList.Add(line);

  end;
end;

constructor tMapParser.Create(ThreadOnDemand: Boolean = true);
begin
  inherited Create;
 // fStopWatch := TStopWatch.Create(nil, true);
 // try
 //   fStopWatch.Start;
 //   try
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

constructor tMapParser.Create();
begin
  inherited;
 // fStopWatch := TStopWatch.Create(nil, true);
//  try
  //  fStopWatch.Start;
  //  try
      // Assume we can load it
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
begin

  fMapFile := TStringList.Create;
  fFileName := ExtractFileName(Application.exename);
  fFileName := ChangeFileExt(fFileName, MapFileExt);
  if FileExists(fFileName) then
  begin
    fMapFile.LoadFromFile(fFileName);
    Result := true;
  end
  else
    Result := false;
end;

destructor tMapParser.Destroy;
begin
  fMapFile.Free;
  fUnitSection.Free;
  fMethodSection.Free;
  fLinesSections.Free;
  fLines.Free;
  FUnitMax.Free;
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
  line, tmpStr, _UnitName: string;
  addr, Next, len: LongWord;
  tmpLst: TStringList;
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
    tmpLst := TStringList.Create;
    try
      Inc(idx, 2);
      repeat
        line := fMapFile[idx];

        if (Piece(line, ' ', 4) = 'C=CODE') then
        begin
          tmpStr := Piece(line, ':', 2);
          addr := StrToInt('$' + Piece(tmpStr, ' ', 1));
          len := StrToInt('$' + Piece(tmpStr, ' ', 2));
          Next := addr + len;
          _UnitName := '';
          _UnitName := Piece(PieceByString(line, UnitPrefix, 2, 2), ' ', 1);
          fUnitSection.Add(Format('%.*d', [8, addr]) + '^' + Format('%.*d', [8, Next]) + '^' + _UnitName);

          tmpLst.Add(_UnitName + '=' + IntToStr(Next));
        end;

        Inc(idx, 1);
      until (line = '');
      fUnitSection.Sort;

    finally
      if tmpLst.Count > 0 then
      begin
        FUnitMax := THashedStringList.Create;
        FUnitMax.Assign(tmpLst);
      end;
      tmpLst.Free;
    end;
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
  idx: Integer;
  line, tmpStr, tmpStr2: string;
  LAddr, addr1: LongWord;
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
    repeat
      line := fMapFile[idx];

      if (Trim(Piece(line, ':', 1)) = '0001') then
      begin
        tmpStr := Piece(line, ':', 2);
        addr1 := StrToInt('$' + Piece(tmpStr, ' ', 1));
        LAddr := 0;
        if (fMapFile[idx + 1] <> '') then
        begin
          tmpStr2 := Piece(fMapFile[idx + 1], ':', 2);
          LAddr := StrToInt('$' + Piece(tmpStr2, ' ', 1));
        end;
        tmpStr := Copy(tmpStr, Pos(' ', tmpStr), Length(tmpStr));
        fMethodSection.Add(Format('%.*d', [8, addr1]) + '^' + Format('%.*d', [8, LAddr]) + '^' + Trim(tmpStr));
      end;

      Inc(idx, 1);
    until (line = '');
    fMethodSection.Sort;

  except
    Result := false;
  end;
end;

Function tMapParser.LoadLines: Boolean;
const
  BoundResourceFiles = 'Bound resource files';
  UnitSection = 'Line numbers for ';

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
  idx, EndIdx, AddLineNum: Integer;
  line, tmpStr: string;
  insertLastLine: Boolean;
  i: Integer;
begin
  fLinesSections := TStringList.Create;
  fLines := TStringList.Create;
  insertLastLine := false;

  idx := FindStartLoc;
  EndIdx := FindEndLoc(idx);
  // if not found then we have an error
  if idx < 0 then
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
    for i := idx to EndIdx do
    begin
      line := fMapFile[i];

      if ContainsText(line, UnitSection) then
      begin
        tmpStr := Piece(line, '(', 1);
        AddLineNum := fLines.Add(line);
        fLinesSections.Add(Piece(tmpStr, ' ', 4) + '=' + IntToStr(AddLineNum));
        insertLastLine := true;
      end;

      if (line = '') and insertLastLine then
      begin
        // fLines.Add(' XXX 0001:' + IntToHex(FUnitMax, 8));
        insertLastLine := false;
      end;

      if ContainsText(line, '0001:') then
        fLines.Add(line);

    end;

  except
    Result := false;
  end;
end;

procedure tMapParser.LookupInMap(const LookUpAddr: LongWord; out aUnit, aMethod, aLineNumber: String);
begin
  aUnit := GetUnitName(LookUpAddr);

  if (aUnit = 'NA') then
    Exit;

  aMethod := GetMethodName(LookUpAddr);
  aLineNumber := GetLineNum(LookUpAddr, aUnit);
end;

function tMapParser.GetUnitName(const LookUpAddr: LongWord): string;
var
  UnitLineNum: Integer;
begin
  Result := 'NA';

  UnitLineNum := findPosition(fUnitSection, Format('%.*d', [8, LookUpAddr]), 0, fUnitSection.Count - 1, MapWeightAddress);
  //UnitLineNum := findPosition(fUnitSection, IntToStr(LookUpAddr), 0, fUnitSection.Count - 1, MapWeightAddress);

  if UnitLineNum > -1 then
    Result := Piece(fUnitSection[UnitLineNum], '^', 3);

end;

function tMapParser.GetMethodName(const LookUpAddr: LongWord): string;
var
  MethodLineNum: Integer;
begin
  Result := '*** Unknown ***';
  MethodLineNum := findPosition(fMethodSection, Format('%.*d', [8, LookUpAddr]), 0, fMethodSection.Count - 1, MapWeightAddress);
 // MethodLineNum := findPosition(fMethodSection, IntToStr(LookUpAddr), 0, fMethodSection.Count - 1, MapWeightAddress);
  // MethodLineNum := BinaryMethodSearch(LookUpAddr);
  if MethodLineNum = -1 then
    Exit;

  Result := Trim(Piece(fMethodSection[MethodLineNum], '^', 3));

end;

function tMapParser.GetLineNum(const LookUpAddr: LongWord; const UnitName: string): string;
begin
  Result := '*** Unknown ***';
  Result := IntToStr(LineSearch(LookUpAddr, UnitName));
end;

Function tMapParser.LineSearch(const LookUpAddr: LongWord; const UnitName: String): Integer;
var
  idx, i, UnitIdx: Integer;
  lastAddr, addr: LongWord;
  line, lineNum, LastLineNum: string;
  Found, insertLastLine: Boolean;
begin
  Result := -1;

  UnitIdx := 0;
  Found := false;

  UnitIdx := fLinesSections.IndexOfPiece(UnitName, UnitIdx);
  while (UnitIdx > 0) and not Found do
  begin

    // find the starting point
    idx := StrToIntDef(fLinesSections.ValueFromIndex[UnitIdx], -1);

    if idx = -1 then
      Exit;

    insertLastLine := true;

    Inc(idx, 2);
    lastAddr := 0;
    LastLineNum := '-1';
    repeat
      line := fLines[idx];
      Inc(idx);
      if idx < fLines.Count - 1 then
      begin
        if ((fLines[idx] = '') or (Pos(UnitSection, fLines[idx]) > 0)) and insertLastLine then
        begin
          fLines.Insert(idx, ' XXX 0001:' + IntToHex(StrToIntDef(FUnitMax.Values[UnitName], 0), 8));
          insertLastLine := false;
        end;
      end;

      repeat
        i := Pos('0001:', line);
        if (i > 0) then
        begin
          addr := StrToInt('$' + Copy(line, i + 5, 8));
          lineNum := Trim(Copy(line, 1, i - 1));
          line := Copy(line, i + 13, MaxInt) + ' ';

          if (LookUpAddr >= lastAddr) and (LookUpAddr < addr) then
          begin

            Result := StrToInt(LastLineNum);
            line := '';
            Found := true;
          end;
          LastLineNum := lineNum;
          lastAddr := addr;
        end;
      until (i = 0) or Found;
    until ((line = '') or (Pos(UnitSection, fLines[idx]) > 0)) or Found;
    UnitIdx := fLinesSections.IndexOfPiece(UnitName, UnitIdx + 1);
  end;

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

constructor TWorker.Create(const Handler: TThreadPool; aThreadType: tThreadType; const aMasterList: TStringList; const aWrokerID: Integer);
begin
  FWorkerID := aWrokerID;
  fMasterList := TStringList.Create;
  fResultList := TStringList.Create;
  fThreadType := aThreadType;
  fMasterList.Assign(aMasterList);

  case aThreadType of
    TYPE_UNIT, TYPE_LINES:
      fExtList := TStringList.Create;
  end;

  fHandler := Handler;
end;

destructor TWorker.Destroy();
begin
  FreeAndNil(fMasterList);
  FreeAndNil(fResultList);
  if assigned(fExtList) then
    FreeAndNil(fExtList);
  inherited;
end;

procedure TWorker.TakeAction(Sender: TObject);
begin
  if assigned(fThreadFunc) then
    fThreadFunc(fMasterList, fResultList, fExtList);
end;

procedure TWorker.FireThread;
begin
  fHandler.AddTask(TakeAction, nil);
end;

{$ENDREGION}

end.
