unit uMapParser2;

interface

uses
 System.Classes, Winapi.Windows, System.SysUtils, System.StrUtils, UStopWatch, Vcl.Dialogs;

type

  TMapElement = class
  private
    FMin: LongWord;
    FLineNumber: Integer;
    FAddrInfo: string;
    FMax: LongWord;
    procedure SetAddrInfo(const Value: string);
    procedure SetLineNumber(const Value: Integer);
    procedure SetMin(const Value: LongWord);
    procedure SetMax(const Value: LongWord);

  public
    property AddrInfo: string read FAddrInfo write SetAddrInfo;
    property _Min: Cardinal read FMin write SetMin;
    property _Max: Cardinal read FMax write SetMax;
    property LineNumber: Integer read FLineNumber write
      SetLineNumber;
  end;

  TMapElements = class(TList)
  private
    FMaxAddr: LongWord;
    function GetItems(idx: Cardinal): TMapElement;
    procedure SetItems(idx: LongWord; const Value: TMapElement);
    procedure SetMaxAddr(const Value: LongWord);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification);
      override;
  public
    property MapItems[idx: Cardinal]: TMapElement read GetItems
    write SetItems; default;
    function MakeElement: TMapElement;
    property MaxAddr: Cardinal read FMaxAddr write SetMaxAddr;
    constructor Create;
    function LookUp(eip: LongWord): Integer;
  end;

  TMapInfo = class
  private
    FFunctions: TMapElements;
    FLines: TMapElements;
    FIsLoaded: Boolean;
    fStopWatch: TStopWatch;
  public
    property IsLoaded: Boolean read FIsLoaded;
    property Functions: TMapElements read FFunctions;
    property Lines: TMapElements read FLines;

    constructor Create(FileName: string);
    destructor Destroy; override;

    function GetAddrMapInfo(eip: Cardinal): string;

    procedure Clear;
    function LoadMapFile(FileName: string): Boolean;

    class function Global: TMapInfo;
  end;

const
  CodeSectionNumber = '0001';
  CodeSectionVA = $1000;

  cnstSectionsDetails = 'Detailed map of segments';
  cnstPublicNames = 'Address Publics by Value';
  cnstLinesNumbers = 'Line numbers for ';

implementation


{$REGION 'TMapElement'}
procedure TMapElement.SetAddrInfo(const Value: string);
begin
  FAddrInfo := Value;
end;

procedure TMapElement.SetMax(const Value: LongWord);
begin
  FMax := Value;
end;

procedure TMapElement.SetLineNumber(const Value: Integer);
begin
  FLineNumber := Value;
end;

procedure TMapElement.SetMin(const Value: LongWord);
begin
  FMin := Value;
end;
{$ENDREGION}

{$REGION 'TMapElements'}
constructor TMapElements.Create;
begin
  inherited;
  MaxAddr := $FFFFFFFF;
end;

function TMapElements.GetItems(idx: LongWord): TMapElement;
begin
  result := TMapElement(Get(idx));
end;

function TMapElements.LookUp(eip: LongWord): Integer;

  function chk_in(z: Integer): Integer;
  begin
    if MapItems[z]._min > eip then
      result := -1
    else if MapItems[z]._Max < eip then
      result := 1
    else
      result := 0;
  end;

var
  i: Integer;
  ok: Boolean;
  gl, gh, gt: Integer;
begin
  result := -1;
  eip := eip - GetModuleHandle(nil);

      gl := 0;
      gh := pred(Count);
      if gl > gh then exit;
      if chk_in(gl) < 0 then exit;
      if chk_in(gh) > 0 then exit;
      repeat
        gt := (gl + gh) shr 1;
        i := chk_in(gt);
        if i = 0 then result := gt
        else if i < 0 then gh := gt - 1
        else gl := gt + 1;
        ok := (result <> -1) or (gl > gh);
      until ok;
end;

function TMapElements.MakeElement: TMapElement;
begin
  result := TMapElement.Create;
  Add(Result);
end;

procedure TMapElements.Notify(Ptr: Pointer; Action:
  TListNotification);
begin
  if (ptr <> nil) and (Action = lnDeleted) then
    TMapElement(ptr).Free;
end;

procedure TMapElements.SetItems(idx: LongWord;
  const Value: TMapElement);
begin
  Put(idx, Value);
end;

procedure TMapElements.SetMaxAddr(const Value: LongWord);
begin
  FMaxAddr := Value;
end;
{$ENDREGION}

{$REGION 'TMapInfo'}
procedure TMapInfo.Clear;
begin
  FIsLoaded := false;
  FLines.Clear;
  FFunctions.Clear;
end;

constructor TMapInfo.Create(FileName: string);
begin
  inherited Create;
  FFunctions := TMapElements.Create;
  FLines := TMapElements.Create;
  Clear;
  if trim(FileName) <> '' then LoadMapFile(FileName);
end;

destructor TMapInfo.Destroy;
begin
  FLines.Free;
  FFunctions.Free;
  inherited;
end;

function cmpEl(p1, p2: Pointer): Integer;
var
  e1, e2: TMapElement;
begin
  try
    e1 := TMapElement(p1);
    e2 := TMapElement(p2);
    if (e1 = e2) or (e1._min = e2._min) then
      begin
        result := 0;
      end
    else if e1._min < e2._min then
      begin
        result := -1;
      end
    else
      begin
        result := 1;
      end;
  except
    result := 0;
  end;
end;

function TMapInfo.GetAddrMapInfo(eip: Cardinal): string;
var
  n1, n2: Integer;
begin
  result := '';
  n1 := Lines.LookUp(eip);
  if n1 <> -1 then
    begin
      result := format('[module %s;line %d] ', [lines[n1].AddrInfo,
        Lines[n1].LineNumber]);
    end;
  n2 := Functions.LookUp(eip);
  if n2 <> -1 then
    begin
      result := result + Functions[n2].AddrInfo;
    end;

  if result = '' then
    result := format('Address <%x> unknown', [eip]);
end;

var
  glb: TMapInfo = nil;

class function TMapInfo.Global: TMapInfo;
begin
  if glb = nil then
    glb := TMapInfo.Create(ChangeFileExt(ParamStr(0), '.map'));
  result := glb;
end;

function TMapInfo.LoadMapFile(FileName: string): Boolean;
var
  inf: TStream;

  function inf_eof: Boolean;
  begin
    result := not (inf.Position < inf.Size)
  end;

  function ReadLine(): string;
var
  ch: AnsiChar;
  StartPos, LineLen: integer;
  I: Integer;
  Line: Ansistring;
begin
  Line := '';
  StartPos := inf.Position;
  ch := #0;
  while (inf.Read( ch, 1) = 1) and (ch <> #13) do;
  LineLen := inf.Position - StartPos;
  inf.Position := StartPos;
  SetString(Line, NIL, LineLen);
  inf.ReadBuffer(Line[1], LineLen);
  if ch = #13 then
    begin
    if (inf.Read( ch, 1) = 1) and (ch <> #10) then
      inf.Seek(-1, soCurrent) // unread it if not LF character.
    end;
    repeat
      i := pos('  ', string(Line));
      if i > 0 then delete(Line, i, 1);
    until i = 0;
    Result := string(Line);
end;

  function ReadLine2: string;
  var
    ws: string;
    ch: WideChar;
    i, j: Integer;
  begin
    result := '';
    if inf_eof then exit;
    ws := '';
    ch := #0;
    setlength(ws, 200);
    i := 0;
    j := 0;
    repeat
      inf.Read(ch, 1);
      if (ord(ch) > 32) or (j = 1) then
        begin
          if ord(ch) <= 32 then
            begin
              inc(i);
              ws[i] := ' ';
            end
          else
            begin
              inc(i);
              ws[i] := ch;
            end;
          j := 1;
        end;
    until (i > 190) or (ch = #13) or (inf_eof);
    if ch = #13 then
      begin
        inc(i);
        inf.Read(ws[i], 1)
      end;
    while (i > 0) and (ord(ws[i]) < 33) do dec(i);
    setlength(ws, i);
    result := ws;
    repeat
      i := pos('  ', result);
      if i > 0 then delete(result, i, 1);
    until i = 0;
  end;

  function xcmp(s1, s2: string): Boolean;
  begin
    result := SameText(copy(s1, 1, length(s2)), s2);
  end;

  function IsSectionsDetails(ws: string): Boolean;
  begin
    result := xcmp(ws, cnstSectionsDetails);
  end;

  function SkipEmptyLines: string;
  begin
    repeat
      result := ReadLine;
    until (result <> '') or (inf_eof);
  end;

  function IsCodeAddr(ws: string): Boolean;
  begin
    result := xcmp(ws, CodeSectionNumber);
  end;

  function GetSectionDetails: Cardinal;
  var
    n1, n2: Cardinal;
    s1, s2, s3: string;
  begin
    result := $FFFFFFFF;
    s1 := SkipEmptyLines;
    while s1 <> '' do
      begin
        if IsCodeAddr(s1) then
          begin
            n1 := pos(' ', s1);
            n2 := posex(' ', s1, n1 + 1);
            if (n1 > 0) and (n2 > 0) then
              begin
                s2 := '$' + copy(s1, 6, n1 - 6);
                s3 := '$' + copy(s1, n1 + 1, n2 - n1 - 1);
                try
                  n1 := StrToInt(s2);
                  n2 := StrToInt(s3);
                  result := CodeSectionVA + n1 + n2;
                except
                end;
              end;
          end;
        s1 := ReadLine;
      end;
  end;

  function IsPublicsNames(ws: string): Boolean;
  begin
    result := xcmp(ws, cnstPublicNames);
  end;

  procedure GetPublicsNames;
  var
    n1, n2: Cardinal;
    s1, s2, s3: string;
  begin
    s1 := SkipEmptyLines;
    while s1 <> '' do
      begin
        if IsCodeAddr(s1) then
          begin
            try
              n1 := pos(' ', s1);
              s2 := '$' + copy(s1, 6, n1 - 6);
              n2 := strtoint(s2);
              s3 := trim(copy(s1, n1, 999));
              with Functions.MakeElement do
                begin
                  AddrInfo := s3;
                  _Min := CodeSectionVA + n2;
                  _Max := 0;
                  LineNumber := 0;
                end;
            except
            end;
          end;
        s1 := ReadLine;
      end;
  end;

  function IsLineNumbers(ws: string): Boolean;
  begin
    result := xcmp(ws, cnstLinesNumbers);
  end;

  procedure GetLineNumbers(ws: string);
  var
    n1, n2: Integer;
    s1, s2, s3, s4: string;
  begin
    s4 := copy(ws, length(cnstLinesNumbers) + 1, 999);
    n1 := pos(')', s4);
    if n1 = 0 then n1 := pos(' ', s4) - 1;
    if n1 = -1 then n1 := length(s4);
    delete(s4, n1 + 1, 999);
    s4 := trim(s4);
//
    s1 := SkipEmptyLines;
    while s1 <> '' do
      begin
        while s1 <> '' do
          begin
            n1 := pos(' ', s1);
            n2 := posex(' ', s1, n1 + 1);
            if n2 = 0 then n2 := length(s1) + 1;
            s2 := copy(s1, 1, n1 - 1);
            s3 := '$' + copy(s1, n1 + 6, n2 - n1 - 6);
            delete(s1, 1, n2);
            try
              n1 := strtoint(s2);
              n2 := strtoint(s3);
              with Lines.MakeElement do
                begin
                  _Min := CodeSectionVA + n2;
                  AddrInfo := s4;
                  LineNumber := n1;
                  _Max := 0;
                end;
            except
            end;
          end;
        s1 := ReadLine;
      end;
  end;

  procedure FinListFill(xlst: TMapElements; mxrva: Cardinal);
  var
    n1: Integer;
  begin
    xlst.MaxAddr := mxrva;
    xlst.Sort(cmpEl);
    for n1 := 0 to pred(xlst.Count) do
      if n1 = pred(xlst.Count) then
        xlst[n1]._max := mxrva
      else
        xlst[n1]._max := xlst[n1 + 1]._Min - 1;
  end;

var
  s1: string;
  mxrva: Cardinal;
  fst: TFileStream;
begin

    fStopWatch := TStopWatch.Create(nil, true);
  try
  fStopWatch.Start;
  try

  result := false;
  if not FileExists(FileName) then exit;
//---
  Clear;
  mxrva := $FFFFFFFF;
  try
//    inf := TFileStream.Create(FileName,fmOpenRead);
    inf := TMemoryStream.Create;
    fst := TFileStream.Create(FileName, fmOpenRead);
    inf.CopyFrom(fst, fst.Size);
    inf.Position := 0;

    while not inf_eof do
      begin
        s1 := ReadLine;
        if s1 <> '' then
          begin
            if IsSectionsDetails(s1) then
              begin
                mxrva := GetSectionDetails;
              end
            else if IsPublicsNames(s1) then
              begin
                GetPublicsNames;
              end
            else if IsLineNumbers(s1) then
              begin
                GetLineNumbers(s1);
              end;
          end;
      end;
    FinListFill(Lines, mxrva);
    FinListFill(Functions, mxrva);
    FIsLoaded := true;
  finally
    if Assigned(inf) then FreeAndNil(inf);
    if Assigned(fst) then FreeAndNil(fst);
  end;
  finally
   fStopWatch.Stop;
   ShowMessage('Load of the map file: ' + fStopWatch.Elapsed );
  end;
  finally
   fStopWatch.Free;
  end;


end;
{$ENDREGION}


end.
