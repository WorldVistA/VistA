unit ORUnitTesting;

interface

uses
  SysUtils, Classes, Windows, ComCtrls, StdCtrls, Forms, Controls,
  System.Generics.Collections, ORNet, Trpcb, WinAPI.Messages;

type
  EUnitTestException = class(EAbort);

  TMockRPC = class(TObject)
  private
    FName: String;
    FCallCount: integer;
    FParam: TParams;
    FResults: TStringList;
  public
    constructor Create(AName: string); overload;
    destructor Destroy; override;
    property Name: string read FName;
    property CallCount: integer read FCallCount write FCallCount;
    property Param: TParams read FParam;
    property Results: TStringList read FResults;
  end;

procedure StartMockRPCs;
procedure StopMockRPCs;

function ParamToStr(Param: TParams; Pad: boolean = false): string;
function FindMockRPC(RPCName: string; Param: TParams): TMockRPC;

procedure BuildMockRPC(RPCName: string; const Param: array of const;
  Results: array of String);
procedure LoadMockRPC(lst: TStrings; first: integer = 0;
  last: integer = MaxInt);
procedure LoadMockRPCFile(fileName: string);
procedure RegisterRPCValue(Key, Value: string);

procedure SimulateKeyStrokesInModalDialog(FormClass: string;
  keys: array of word);
procedure WaitForDialogThenClose(FormClass: string);
function GetLastDialogInfo(BtnList: TStringList): string;

procedure ExtractList(data: string; list: TStrings);

const
  START_PARAMS = 'Params -------------';
  START_RESULTS = 'Results ------------';
  LITERAL_PARAM = 'literal';
  REF_PARAM = 'reference';
  LIST_PARAM = 'list';

var
  UnitTestingActive: boolean = false;
  ModalDailogBoundsRect: TRect;

implementation

uses ORFn, UResponsiveGUI;

var
  MockRPCs: TObjectList<TMockRPC> = nil;
  rpcValues: TStringList = nil;

procedure StartMockRPCs;
begin
  StopMockRPCs;
  MockRPCs := TObjectList<TMockRPC>.Create(True);
  rpcValues := TStringList.Create;
end;

procedure StopMockRPCs;
begin
  if assigned(MockRPCs) then
    FreeAndNil(MockRPCs);
  if assigned(rpcValues) then
    FreeAndNil(rpcValues);
end;

function ParamToStr(Param: TParams; Pad: boolean = false): string;
var
  x, y: string;
  i, j: integer;
  padding: string;

begin
  Result := '';
  for i := 0 to Param.Count - 1 do
  begin
    case Param[i].PType of
      list:
        x := LIST_PARAM;
      literal:
        x := LITERAL_PARAM;
      reference:
        x := 'reference';
      undefined:
        x := 'undefined';
    else
      x := '';
    end;
    if Pad then
      padding := CRLF + '    '
    else
      padding := '/';
    Result := Result + padding + x + ' ' + Param[i].Value;
    if Param[i].PType = list then
    begin
      if Pad then
        padding := CRLF + '      '
      else
        padding := '/';
      for j := 0 to Param[i].Mult.Count - 1 do
      begin
        x := Param[i].Mult.Subscript(j);
        y := Param[i].Mult[x];
        if (length(x) < 1) or (x[1] <> '"') then
          x := '"' + x;
        if x[length(x)] <> '"' then
          x := x + '"';
        Result := Result + padding + '(' + x + ')=' + y;
      end;
    end;
  end;
end;

function FindMockRPC(RPCName: string; Param: TParams): TMockRPC;
var
  found, i, Count: integer;
  p1, p2: string;

begin
  p1 := ParamToStr(Param);
  Count := 0;
  found := -1;
  for i := 0 to MockRPCs.Count - 1 do
  begin
    if MockRPCs[i].Name = RPCName then
    begin
      p2 := ParamToStr(MockRPCs[i].Param);
      if p1 = p2 then
      begin
        if found < 0 then
        begin
          found := i;
          Count := MockRPCs[i].CallCount;
        end
        else
        begin
          if Count > MockRPCs[i].CallCount then
          begin
            found := i;
            Count := MockRPCs[i].CallCount;
          end;
        end;
      end;
    end;
  end;
  if found < 0 then
    Result := nil
  else
    Result := MockRPCs[found];
end;

function UpdateText(line: string): string;
var
  i, j: integer;
  Key, Value: string;
  done: boolean;

begin
  Result := trim(line);
  done := false;
  i := 0;
  repeat
    i := pos('<', Result, i + 1);
    j := pos('>', Result, i + 1);
    if (i > 0) and (j > i) then
    begin
      Key := copy(Result, i + 1, j - i - 1);
      Value := rpcValues.Values[Key];
      if Value <> '' then
        Result := copy(Result, 1, i - 1) + Value + copy(Result, j + 1, MaxInt);
    end
    else
      done := True;
  until done;
end;

procedure BuildMockRPC(RPCName: string; const Param: array of const;
  Results: array of String);
const
  BoolChar: array [boolean] of char = ('0', '1');

var
  i, j: integer;
  s: string;
  sl, sl2: TStringList;
  TmpExt: Extended;

begin
  sl := TStringList.Create;
  try
    sl.Add(RPCName);
    sl.Add(START_PARAMS);
    for i := 0 to High(Param) do
    begin
      with Param[i] do
        case VType of
          vtBoolean:
            sl.Add(LITERAL_PARAM + #9 + BoolChar[VBoolean]);
          vtChar:
            if VChar = #0 then
              sl.Add(LITERAL_PARAM + #9 + '')
            else
              sl.Add(LITERAL_PARAM + #9 + string(VChar));
          vtWideChar:
            if VChar = #0 then
              sl.Add(LITERAL_PARAM + #9 + '')
            else
              sl.Add(LITERAL_PARAM + #9 + string(VWideChar));
          vtExtended:
            begin
              TmpExt := VExtended^;
              if (abs(TmpExt) < 0.0000000000001) then
                TmpExt := 0;
              sl.Add(LITERAL_PARAM + #9 + FloatToStr(TmpExt));
            end;
          vtString:
            sl.Add(LITERAL_PARAM + #9 + string(VString^));
          vtAnsiString:
            sl.Add(LITERAL_PARAM + #9 + string(VAnsiString));
          vtInteger:
            sl.Add(LITERAL_PARAM + #9 + IntToStr(VInteger));
          vtInt64:
            sl.Add(LITERAL_PARAM + #9 + IntToStr(VInt64^));
          vtUnicodeString:
            sl.Add(LITERAL_PARAM + #9 + string(VUnicodeString));
          vtObject:
            if Param[i].VObject is TStringList then
            begin
              sl2 := Param[i].VObject as TStringList;
              sl.Add(LIST_PARAM);
              for j := 0 to sl2.Count - 1 do
                sl.Add('("' + IntToStr(j + 1) + '")=' + sl2[j]);
            end;
        end;
    end;
    sl.Add(START_RESULTS);
    for s in Results do
      sl.Add(s);
    LoadMockRPC(sl);
  finally
    sl.Free;
  end;
end;

const
  START_RPC_LINE = '<<< ---  ';
  END_RPC_LINE = ' >>>';

procedure LoadMockRPC(lst: TStrings; first: integer = 0;
  last: integer = MaxInt);
var
  index, idx, p: integer;
  line, line2, RPCName: String;
  EOL, IsRef: boolean;
  InList: boolean;
  rpc: TMockRPC;

  procedure NextLine;
  begin
    inc(index);
    if index > last then
      EOL := True
    else
      line := trim(lst[index]);
  end;

  function GetErrorMessage(msg: string = ''): string;
  begin
    Result := 'Error parsing RPC data';
    if RPCName <> '' then
      Result := Result + ' - ' + RPCName;
    if EOL then
      Result := Result + ' - End of RPC Data before ' + msg + ' reached'
    else if msg <> '' then
      Result := Result + ' - ' + msg;
  end;

begin
  if (not assigned(lst)) or (not(lst is TStrings)) then
    raise EUnitTestException.Create
      ('LoadMockRPC called without valid TStrings');
  if last >= lst.Count then
    last := lst.Count - 1;
  if last < first then
    exit;
  index := first - 1;
  RPCName := '';
  p := 0;
  InList := false;
  EOL := false;
  NextLine;
  if line.StartsWith(START_RPC_LINE) and line.EndsWith(END_RPC_LINE) then
  begin
    RPCName := copy(line, START_RPC_LINE.length + 1,
      length(line) - START_RPC_LINE.length - END_RPC_LINE.length);
    NextLine;
  end;
  if RPCName = '' then
    RPCName := line
  else if RPCName <> line then
    raise EUnitTestException.Create(GetErrorMessage);
  repeat
    NextLine;
  until line.StartsWith(START_PARAMS) or EOL;
  if EOL then
    raise EUnitTestException.Create(GetErrorMessage(START_PARAMS));

  rpc := TMockRPC.Create(RPCName);
  try
    repeat
      NextLine;
      IsRef := line.StartsWith(REF_PARAM);
      if line.StartsWith(LITERAL_PARAM) or IsRef then
      begin
        if InList then
        begin
          inc(p);
          InList := false;
        end;
        if IsRef then
          delete(line, 1, REF_PARAM.length)
        else
          delete(line, 1, LITERAL_PARAM.length);
        line := UpdateText(line);
        if IsRef then
          rpc.Param[p].PType := reference
        else
          rpc.Param[p].PType := literal;
        rpc.Param[p].Value := line;
        inc(p);
      end
      else if line = LIST_PARAM then
      begin
        InList := True;
        rpc.Param[p].PType := list;
      end
      else if InList then
      begin
        line := UpdateText(line);
        idx := pos('=', line);
        if idx > 0 then
        begin
          line2 := copy(line, 1, idx - 1);
          if (length(line2) > 2) and (line2[1] = '(') and
            (line2[length(line2)] = ')') then
          begin
            delete(line2, 1, 1);
            delete(line2, length(line2), 1);
            if line2[1] <> '"' then
              line2 := '"' + line2;
            if line2[length(line2)] <> '"' then
              line2 := line2 + '"';
            line := copy(line, idx + 1, MaxInt);
            rpc.Param[p].Mult[line2] := line;
          end;
        end;
      end
      else if (line <> '') and (not line.StartsWith(START_RESULTS)) then
        raise EUnitTestException.Create
          (GetErrorMessage('Invalid Param ' + line));
    until line.StartsWith(START_RESULTS) or EOL;
    if EOL then
      raise EUnitTestException.Create(GetErrorMessage(START_RESULTS));
    repeat
      NextLine;
      line := UpdateText(line);
      if not EOL then
        rpc.Results.Add(line);
    until EOL;
    MockRPCs.Add(rpc);
    rpc := nil;
  finally
    if assigned(rpc) then
      rpc.Free;
  end;
end;

procedure LoadMockRPCFile(fileName: string);
const
  RPC_LOG = '<<< RPC Log >>>';
  RAN_AT = 'Ran at:';
  RUN_TIME = 'Run time:';
  CONTEXT = 'Context:';

var
  dat: TStringList;
  first, last, index, lastParam: integer;
  line, path: string;
  EOF: boolean;

  procedure FindNextRPC;
  begin
    repeat
      inc(index);
      if index >= dat.Count then
      begin
        EOF := True;
        exit;
      end;
      line := trim(dat[index]);
    until line.StartsWith(START_PARAMS);
    lastParam := index;
    repeat
      dec(index);
      if index < 0 then
      begin
        EOF := True;
        exit;
      end;
      line := trim(dat[index]);
    until (line <> '') and (not line.StartsWith(RUN_TIME)) and
      (not line.StartsWith(RAN_AT)) and (not line.StartsWith(CONTEXT));
    if (index > 0) and dat[index - 1].StartsWith(START_RPC_LINE) and
      dat[index - 1].EndsWith(END_RPC_LINE) then
      dec(index);
  end;

begin
  path := ExtractFilePath(Application.ExeName) + 'MockDataFiles\' +
    fileName + '.txt';
  if not FileExists(path) then
    raise EUnitTestException.Create(path + ' not found');
  dat := TStringList.Create;
  try
    dat.LoadFromFile(path);
    index := 0;
    EOF := false;
    if dat[index].StartsWith(RPC_LOG) then
      inc(index);
    repeat
      FindNextRPC;
      if not EOF then
      begin
        first := index;
        index := lastParam + 1;
        FindNextRPC;
        if EOF then
          last := dat.Count - 1
        else
          last := index - 1;
        if trim(dat[last]) = '' then
          dec(last);
        LoadMockRPC(dat, first, last);
        index := lastParam - 1;
      end;
    until EOF;
  finally
    dat.Free;
  end;
end;

procedure RegisterRPCValue(Key, Value: string);
begin
  // Add check for greater than XE8
  {$IF CompilerVersion > 29.0}
    rpcValues.AddPair(Key, Value);
  {$ELSE}
    rpcValues.Add(Key + rpcValues.NameValueSeparator + Value);
  {$ENDIF}
end;

{ TMockRPC }

constructor TMockRPC.Create(AName: string);
begin
  inherited Create;
  FName := AName;
  FParam := TParams.Create(nil);
  FResults := TStringList.Create;
end;

destructor TMockRPC.Destroy;
begin
  FResults.Free;
  FParam.Free;
  inherited;
end;

type
  tWait4DialogThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

var
  ExpectedFormClass: string = '';
  ButtonList: TStringList;
  LastCaption: String = '';
  PendingKeys: array of word;

procedure WaitForDialogThenClose(FormClass: string);
begin
  ExpectedFormClass := FormClass;
  tWait4DialogThread.Create;
end;

function GetLastDialogInfo(BtnList: TStringList): string;
begin
  if assigned(BtnList) then
    BtnList.Clear;
  if assigned(ButtonList) then
  begin
    if assigned(BtnList) then
      BtnList.Assign(ButtonList);
    FreeAndNil(ButtonList);
    Result := LastCaption;
  end
  else
    Result := '';
end;

procedure SimulateKeyStrokesInModalDialog(FormClass: string;
  keys: array of word);
var
  i: integer;

begin
  ExpectedFormClass := FormClass;
  SetLength(PendingKeys, length(keys));
  for i := 0 to High(keys) do
    PendingKeys[i] := keys[i];
  tWait4DialogThread.Create;
end;

{ tWait4DialogThread }

constructor tWait4DialogThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create;
end;

procedure tWait4DialogThread.Execute;
var
  idx: integer;
  found: boolean;

begin
  inherited;
  found := false;
  idx := -1;
  repeat
    Synchronize(
      procedure
      var
        i: integer;
      begin
        for i := 0 to Screen.FormCount - 1 do
        begin
          if (Screen.Forms[i].ClassName = ExpectedFormClass) and
            Screen.Forms[i].Showing then
          begin
            idx := i;
            found := True;
          end;
        end;
      end);
    if not found then
      sleep(10);
  until found;
  Synchronize(
    procedure
    var
      i: integer;

    begin
      with Screen.Forms[idx] do
      begin
        ModalDailogBoundsRect := BoundsRect;
        if length(PendingKeys) > 0 then
        begin
          if assigned(ActiveControl) then
          begin
            for i := 0 to High(PendingKeys) do
            begin
              PostMessage(ActiveControl.Handle, WM_KEYDOWN, PendingKeys[i], 0);
              PostMessage(ActiveControl.Handle, WM_KEYUP, PendingKeys[i], 0);
              TResponsiveGUI.ProcessMessages;
            end;
          end;
          SetLength(PendingKeys, 0);
        end
        else
        begin
          if assigned(ButtonList) then
            ButtonList.Clear
          else
            ButtonList := TStringList.Create;
          for i := 0 to ControlCount - 1 do
            if (Controls[i] is TButton) and Controls[i].Visible then
              ButtonList.Add(TButton(Controls[i]).Caption);
          LastCaption := Caption;
          Close;
        end;
      end;
    end);
end;

procedure ExtractList(data: string; list: TStrings);
var
  x: string;
  p: integer;

begin
  list.Clear;
  x := data;
  repeat
    p := pos('|', x);
    if p > 0 then
    begin
      list.Add(copy(x, 1, p - 1));
      delete(x, 1, p);
    end
    else if x <> '' then
      list.Add(x);
  until p = 0;
end;

initialization

finalization

StopMockRPCs;

end.
