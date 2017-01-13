unit fDebugReport;
{
*
*   Debug report
*
*   Mutli Thread disabled at this time
*   Reason: Issue with nil pointer for threadbroker. Looks as if its being used
*           after the thread dies off???
*
*
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, Buttons, ExtCtrls, ORNet, Trpcb, uCore,
  Vcl.ComCtrls;

type

  tRPCArray = record
    RPCData: TStringList;
  end;

  tDebugThread = class(TThread)
  private
    fThreadDone: Boolean;
    fDescription: TStringList;
    RPCArray: array of tRPCArray;
    ThreadBroker: TRPCBroker;
  protected
    procedure Execute; override;
  public
    constructor Create(ActionDescription: TStrings; RPCParams, CurContext: string);
    destructor Destroy; override;
  end;

  TfrmDebugReport = class(TForm)
    pnlLeft: TPanel;
    img1: TImage;
    pnlMain: TPanel;
    splUser: TSplitter;
    Panel1: TPanel;
    lbl2: TLabel;
    ActionMemo: TMemo;
    pnl1: TPanel;
    lbl1: TLabel;
    IssueMemo: TMemo;
    pnl2: TPanel;
    btnSend: TBitBtn;
    btnCancel: TBitBtn;
    DebugProgBar: TProgressBar;
    PnlProg: TPanel;
    Label1: TLabel;
    procedure ActionMemoChange(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    RPCS: array of tRPCArray;
    DebugReportBroker: TRPCBroker;
    procedure RunNonThread();
  public
    { Public declarations }
  end;

Const
  UseMultThread: Boolean = false;

var
  frmDebugReport: TfrmDebugReport;

implementation

{$R *.dfm}

procedure TfrmDebugReport.ActionMemoChange(Sender: TObject);
begin
  btnSend.Enabled := Trim(ActionMemo.Text) > '';
end;

procedure TfrmDebugReport.btnCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmDebugReport.btnSendClick(Sender: TObject);
var
  DebugThread: tDebugThread;
  ConnectionParam: String;
  ReturnCursor: Integer;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
   if UseMultThread then
   begin
    //threaded
    if Trim(ActionMemo.Text) > '' then
    begin
     ConnectionParam := RPCBrokerV.Server + '^' +
              IntToStr(RPCBrokerV.ListenerPort) + '^' +
              GetAppHandle(RPCBrokerV) + '^' +
              RPCBrokerV.User.Division;

     DebugThread := tDebugThread.Create(ActionMemo.Lines, ConnectionParam, RPCBrokerV.CurrentContext);
     {$WARN SYMBOL_DEPRECATED OFF} // researched
     DebugThread.Resume;
     {$WARN SYMBOL_DEPRECATED ON} // researched
     Self.Close;
    end;
   end else begin
    //Non threaded
    RunNonThread;
   end;
  finally
   Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmDebugReport.FormShow(Sender: TObject);
begin
  ActionMemo.Text := '';
  btnSend.Enabled := False;
  ActionMemo.SetFocus;
  PnlProg.Visible := false;
end;

constructor tDebugThread.Create(ActionDescription: TStrings; RPCParams, CurContext: string);

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
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum then Result := '' else SetString(Result, Strt, Next - Strt);
end;

begin
  inherited Create(True);
  fThreadDone := false;
  fDescription := TStringList.Create;
  fDescription.Assign(ActionDescription);
  FreeOnTerminate := True;
  SetLength(RPCArray, 0);
  try
   ThreadBroker := TRPCThreadBroker.Create(nil);
   ThreadBroker.Server := Piece(RPCParams, '^', 1);
   ThreadBroker.ListenerPort := StrToIntDef(Piece(RPCParams, '^', 2), 9200);
   ThreadBroker.LogIn.LogInHandle := Piece(RPCParams, '^', 3);
   ThreadBroker.LogIn.Division := Piece(RPCParams, '^', 4);
   ThreadBroker.LogIn.Mode := lmAppHandle;
   ThreadBroker.KernelLogIn := False;
   ThreadBroker.Connected := True;
   ThreadBroker.CreateContext(CurContext);
  except
   FreeAndNil(ThreadBroker);
  end;
end;

destructor tDebugThread.Destroy;
var
  I: Integer;
begin
  fDescription.Free;
  fThreadDone := true;
  for I := High(RPCArray) downto Low(RPCArray) do
    if Assigned(RPCArray[i].RPCData) then
      FreeAndNil(RPCArray[i].RPCData);
  SetLength(RPCArray, 0);
  ThreadBroker.Connected := false;
  FreeAndNil(ThreadBroker);
  inherited;
end;

procedure tDebugThread.Execute;
var
  I: Integer;
  UniqueKey: string;

  function FilteredString(const x: string; ATabWidth: Integer = 8): string;
var
  i, j: Integer;
  c: char;
begin
  Result := '';
  for i := 1 to Length(x) do begin
    c := x[i];
    if c = #9 then begin
      for j := 1 to (ATabWidth - (Length(Result) mod ATabWidth)) do
        Result := Result + ' ';
    end else if CharInSet(c, [#32..#127]) then begin
      Result := Result + c;
    end else if CharInSet(c, [#10, #13, #160]) then begin
      Result := Result + ' ';
    end else if CharInSet(c, [#128..#159]) then begin
      Result := Result + '?';
    end else if CharInSet(c, [#161..#255]) then begin
      Result := Result + x[i];
    end;
  end;

  if Copy(Result, Length(Result), 1) = ' ' then Result := TrimRight(Result) + ' ';
end;

  procedure SendTheRpc(RPCList: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    with ThreadBroker do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORDEBUG SAVERPCS';

      //send the unique key
      Param[0].PType := literal;
      Param[0].Value := UniqueKey;

      //send the RPC Data
      Param[1].PType := list;
      for LnCnt := 0 to RPCList.Count - 1 do
        ThreadBroker.Param[1].Mult[IntToStr(LnCnt)] := FilteredString(RPCList.Strings[LnCnt]);

      ThreadBroker.Call;

    end;
  end;

  procedure SendTheDesc(Description: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    with ThreadBroker do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORDEBUG SAVEDESC';

      //send the unique key
      Param[0].PType := literal;
      Param[0].Value := UniqueKey;

      //send the RPC Data
      Param[1].PType := list;
      for LnCnt := 0 to Description.Count - 1 do
        ThreadBroker.Param[1].Mult[IntToStr(LnCnt)] := FilteredString(Description.Strings[LnCnt]);

      ThreadBroker.Call;
      //CallBroker;

    end;
  end;

begin
  if Terminated then Exit;

  //set unique key
  UniqueKey := IntToStr(User.DUZ) + '^' + FormatDateTime('mm/dd/yyyy hh:mm:ss', Now());

  //save the users text
  SendTheDesc(fDescription, UniqueKey);

  //Collect all the RPC's up to that point
  for I := (RetainedRPCCount - 1) downto 0 do
  begin
    SetLength(RPCArray, Length(RPCArray) + 1);
    RPCArray[High(RPCArray)].RPCData := TStringList.Create;
    //Need to sync this call
    LoadRPCData(RPCArray[High(RPCArray)].RPCData, I);
  end;

  //Send in the rpc list
  for I := High(RPCArray) downto Low(RPCArray) do
  begin
    SendTheRpc(RPCArray[i].RPCData, UniqueKey);
  end;

  Sleep(Random(100));
end;

procedure TfrmDebugReport.RunNonThread();
var
  I: Integer;
  UniqueKey: string;
  ActionDesc: TStringList;

  function FilteredString(const x: string; ATabWidth: Integer = 8): string;
var
  i, j: Integer;
  c: char;
begin
  Result := '';
  for i := 1 to Length(x) do begin
    c := x[i];
    if c = #9 then begin
      for j := 1 to (ATabWidth - (Length(Result) mod ATabWidth)) do
        Result := Result + ' ';
    end else if CharInSet(c, [#32..#127]) then begin
      Result := Result + c;
    end else if CharInSet(c, [#10, #13, #160]) then begin
      Result := Result + ' ';
    end else if CharInSet(c, [#128..#159]) then begin
      Result := Result + '?';
    end else if CharInSet(c, [#161..#255]) then begin
      Result := Result + x[i];
    end;
  end;

  if Copy(Result, Length(Result), 1) = ' ' then Result := TrimRight(Result) + ' ';
end;

  procedure SendTheRpc(RPCList: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    with DebugReportBroker do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORDEBUG SAVERPCS';

      //send the unique key
      Param[0].PType := literal;
      Param[0].Value := UniqueKey;

      //send the RPC Data
      Param[1].PType := list;
      for LnCnt := 0 to RPCList.Count - 1 do
        Param[1].Mult[IntToStr(LnCnt)] := FilteredString(RPCList.Strings[LnCnt]);

      Call;

    end;
  end;

  procedure SendTheDesc(Description: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    with DebugReportBroker do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORDEBUG SAVEDESC';

      //send the unique key
      Param[0].PType := literal;
      Param[0].Value := UniqueKey;

      //send the RPC Data
      Param[1].PType := list;
      for LnCnt := 0 to Description.Count - 1 do
        Param[1].Mult[IntToStr(LnCnt)] := FilteredString(Description.Strings[LnCnt]);

      Call;

    end;
  end;

begin
  SetLength(RPCS, 0);
  DebugReportBroker := TRPCThreadBroker.Create(nil);
  try
    //Setup the progress bar
    DebugProgBar.Max := (RetainedRPCCount + 3);
    DebugProgBar.Position := 0;

    PnlProg.Visible := True;

    Application.ProcessMessages; //Allow the screen to draw
    //Setup the broker
    DebugReportBroker.Server := RPCBrokerV.Server;
    DebugReportBroker.ListenerPort := RPCBrokerV.ListenerPort;
    DebugReportBroker.LogIn.LogInHandle := GetAppHandle(RPCBrokerV);
    DebugReportBroker.LogIn.Division := RPCBrokerV.User.Division;
    DebugReportBroker.LogIn.Mode := lmAppHandle;
    DebugReportBroker.KernelLogIn := False;
    DebugReportBroker.Connected := True;
    if DebugReportBroker.CreateContext(RPCBrokerV.CurrentContext) = false then
     ShowMessage('Error switching broker context');

    DebugProgBar.Position := DebugProgBar.Position + 1;

    //set unique key
    UniqueKey := IntToStr(User.DUZ) + '^' + FormatDateTime('mm/dd/yyyy hh:mm:ss', Now());

    //save the users text
    ActionDesc := TStringList.Create;
    try
     ActionDesc.assign(ActionMemo.Lines);
     SendTheDesc(ActionDesc, UniqueKey);
     DebugProgBar.Position := DebugProgBar.Position + 1;
    finally
     ActionDesc.Free;
    end;


   //Collect all the RPC's up to that point
   for I := (RetainedRPCCount - 1) downto 0 do
   begin
    SetLength(RPCS, Length(RPCS) + 1);
    RPCS[High(RPCS)].RPCData := TStringList.Create;
    //Need to sync this call
    LoadRPCData(RPCS[High(RPCS)].RPCData, I);
   end;
   DebugProgBar.Position := DebugProgBar.Position + 1;

  //Send in the rpc list
  for I := High(RPCS) downto Low(RPCS) do
  begin
    SendTheRpc(RPCS[i].RPCData, UniqueKey);
    DebugProgBar.Position := DebugProgBar.Position + 1;
  end;

  Sleep(1000); //ONE SEC
  Finally
   for I := High(RPCS) downto Low(RPCS) do
    if Assigned(RPCS[i].RPCData) then
      FreeAndNil(RPCS[i].RPCData);
   SetLength(RPCS, 0);
   DebugReportBroker.Connected := false;
   FreeAndNil(DebugReportBroker);
   Self.Close;
  end;
end;

end.

