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
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, Buttons, ExtCtrls, ORNet, Trpcb, uCore,
  Vcl.ComCtrls, VAUtils, fBase508Form, VA508AccessibilityManager;

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

  tRPCArrayIdent = array of tRPCArray;

  tRPCArrayIdentHelper = Record helper for tRPCArrayIdent
    public
     Procedure Clear;
  End;

  TfrmDebugReport = class(TfrmBase508Form)
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
    fRPCS: tRPCArrayIdent;
    fDebugReportBroker: TRPCBroker;
    fCallbackRPCIndex: Integer;
    fCallBackKey: String;
    fCallBackMaxLoops: Integer;
    fTaskDLG: TTaskDialog;
    fErrTxt: String;
    fLoopCounter: Integer;
    procedure RunNonThread();
    function GetTopRPCNumber: Integer;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FilteredString(const x: string; ATabWidth: Integer = 8): string;
    procedure SendTheRpc(RPCList: TStringList; UniqueKey: string);
    procedure SendTheDesc(Description: TStringList; UniqueKey: string);
    procedure EnsureDebugBroker;
    procedure SendDataCallback(Sender: TObject; TickCount: Cardinal; var Reset: Boolean);

    Property TopRPCNumber: Integer read GetTopRPCNumber;
    property RPCS: tRPCArrayIdent read fRPCS write fRPCS;
    property DebugReportBroker: TRPCBroker read fDebugReportBroker write fDebugReportBroker;
    property CallbackRPCIndex: Integer read fCallbackRPCIndex write fCallbackRPCIndex;
    property CallBackMaxLoops: Integer read fCallBackMaxLoops write fCallBackMaxLoops;
    property CallbackKey: String read fCallBackKey write fCallBackKey;
    property ErrorText: String read fErrTxt write fErrTxt;
    property TaskDlg: TTaskDialog read fTaskDLG write fTaskDLG;
  end;

Procedure LogBrokerErrors(const ErrTxt: String; const TotalRPCSToSend: Integer);

Const
  UseMultThread: Boolean = false;

var
  frmDebugReport: TfrmDebugReport;

implementation

{$R *.dfm}

procedure LogBrokerErrors(const ErrTxt: string; const TotalRPCSToSend: Integer);
var
  frmDebug: TfrmDebugReport;
  ReturnCursor: Integer;
begin
  frmDebug := TfrmDebugReport.Create(nil);
  ReturnCursor := Screen.cursor;
  Screen.cursor := crHourGlass;
  try
    // set unique key
    frmDebug.CallbackKey := IntToStr(User.DUZ) + '^' +
      FormatDateTime('mm/dd/yyyy hh:mm:ss', Now());
    // save the Error text
    frmDebug.ErrorText := ErrTxt;
    // set the loop
    frmDebug.CallbackRPCIndex := frmDebug.TopRPCNumber;
    frmDebug.CallBackMaxLoops := TotalRPCSToSend;
    // create the task dialog
    frmDebug.TaskDlg := TTaskDialog.Create(nil);
    with frmDebug.TaskDlg do
    begin
      try
        Caption := 'CPRS Error Log';
        Title := 'Capturing debug information';
        Text := 'Please wait this may take a minute.';
        CommonButtons := [tcbCancel];
        MainIcon := tdiInformation;
        ProgressBar.Position := 70;
        ProgressBar.MarqueeSpeed := 1;
        Flags := [tfShowMarqueeProgressBar, tfCallbackTimer,
          tfAllowDialogCancellation];
        OnTimer := frmDebug.SendDataCallback;
        Execute;
      finally
        Free;
      end
    end;
  finally
    Screen.cursor := ReturnCursor;
    FreeAndNil(frmDebug);
  end;
end;

procedure TfrmDebugReport.SendDataCallback(Sender: TObject; TickCount: Cardinal;
  var Reset: Boolean);
var
  RPCData: TStringList;
begin
  RPCData := TStringList.Create;
  // Pause the timer
  fTaskDLG.OnTimer := nil;
  try
    if fLoopCounter < fCallBackMaxLoops then
    begin
      // 1st call
      if fLoopCounter = 0 then
      begin
        // ensure the broker exist
        EnsureDebugBroker;
        // Send the error message
        RPCData.Add(fErrTxt);
        SendTheDesc(RPCData, fCallBackKey);
        RPCData.Clear;
      end;

      // Need to sync this call
      LoadRPCData(RPCData, fCallbackRPCIndex);

      // Send in the rpc list
      SendTheRpc(RPCData, fCallBackKey);

      Inc(fLoopCounter);
    end else begin
      fTaskDLG.OnTimer := nil;
      fTaskDLG.ProgressBar.Position := 100;
      fTaskDLG.ModalResult := mrOk;
      SendMessage(fTaskDLG.Handle, WM_CLOSE, 0, 0);
    end;

  finally
    // reset the timer
    fTaskDLG.OnTimer := SendDataCallback;
    FreeAndNil(RPCData);
  end;
end;

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
  ConnectionParam: string;
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
      end
    else
      begin
    //Non threaded
    RunNonThread;
   end;
  finally
   Screen.Cursor := ReturnCursor;
  end;
end;

constructor TfrmDebugReport.Create(AOwner: TComponent);
begin
  inherited;
  fCallBackMaxLoops := 0;
  fLoopCounter := 0;
end;

procedure TfrmDebugReport.FormShow(Sender: TObject);
begin
  ActionMemo.Text := '';
  btnSend.Enabled := False;
  ActionMemo.SetFocus;
  PnlProg.Visible := false;
end;

function TfrmDebugReport.GetTopRPCNumber: Integer;
begin
 Result := (RetainedRPCCount - 1);
end;

constructor tDebugThread.Create(ActionDescription: TStrings;
  RPCParams, CurContext: string);

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

begin
  inherited Create(True);
  fThreadDone := false;
  fDescription := TStringList.Create;
  fDescription.Assign(ActionDescription);
  FreeOnTerminate := True;
  SetLength(RPCArray, 0);
  try
    ThreadBroker := TRPCBroker.Create(nil);
    ThreadBroker.Server := Piece(RPCParams, '^', 1);
    ThreadBroker.ListenerPort := StrToIntDef(Piece(RPCParams, '^', 2), 9200);
    ThreadBroker.LogIn.LogInHandle := Piece(RPCParams, '^', 3);
    ThreadBroker.LogIn.Division := Piece(Piece(RPCParams, '^', 4), '^', 3);
    ThreadBroker.LogIn.Mode := lmAppHandle;
    ThreadBroker.KernelLogIn := false;
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
    LockBroker;
    try
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
    finally
      UnlockBroker;
    end;
  end;

  procedure SendTheDesc(Description: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    LockBroker;
    try
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
    finally
      UnlockBroker;
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
begin
  RPCS.Clear;
  DebugReportBroker := TRPCBroker.Create(nil);
  try
    //Setup the progress bar
    DebugProgBar.Max := (RetainedRPCCount + 3);
    DebugProgBar.Position := 0;

    PnlProg.Visible := True;

    Application.ProcessMessages; //Allow the screen to draw
    EnsureDebugBroker;

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
   for I := TopRPCNumber downto 0 do
   begin
    SetLength(fRPCS, Length(fRPCS) + 1);
    fRPCS[High(fRPCS)].RPCData := TStringList.Create;
    //Need to sync this call
    LoadRPCData(fRPCS[High(fRPCS)].RPCData, I);
   end;
   DebugProgBar.Position := DebugProgBar.Position + 1;

  //Send in the rpc list
  for I := High(fRPCS) downto Low(fRPCS) do
  begin
    SendTheRpc(fRPCS[i].RPCData, UniqueKey);
    DebugProgBar.Position := DebugProgBar.Position + 1;
  end;

  Sleep(1000); //ONE SEC
  Finally
   RPCS.Clear;
   DebugReportBroker.Connected := false;
   FreeAndNil(fDebugReportBroker);
   Self.Close;
  end;
end;

procedure TfrmDebugReport.EnsureDebugBroker;
begin
  if not Assigned(DebugReportBroker) then
    DebugReportBroker := TRPCBroker.Create(nil);

  // Setup the broker
  DebugReportBroker.Server := RPCBrokerV.Server;
  DebugReportBroker.ListenerPort := RPCBrokerV.ListenerPort;
  DebugReportBroker.LogIn.LogInHandle := GetAppHandle(RPCBrokerV);
  DebugReportBroker.LogIn.Division := Piece(RPCBrokerV.User.Division, '^', 3);
  DebugReportBroker.LogIn.Mode := lmAppHandle;
  DebugReportBroker.KernelLogIn := false;
  DebugReportBroker.Connected := True;
  if DebugReportBroker.CreateContext(RPCBrokerV.CurrentContext) = false then
    ShowMessage('Error switching broker context');
end;

  function TfrmDebugReport.FilteredString(const x: string; ATabWidth: Integer = 8): string;
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



  procedure TfrmDebugReport.SendTheRpc(RPCList: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    LockBroker;
    try
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
    finally
      UnlockBroker;
    end;
  end;

  procedure TfrmDebugReport.SendTheDesc(Description: TStringList; UniqueKey: string);
  var
    LnCnt: Integer;
  begin
    LockBroker;
    try
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
    finally
      UnlockBroker;
    end;
  end;

  destructor TfrmDebugReport.Destroy;
  begin
    if assigned(DebugReportBroker) then
    begin
      DebugReportBroker.Connected := false;
      FreeAndNil(fDebugReportBroker);
    end;
    Inherited;
  end;

  Procedure tRPCArrayIdentHelper.Clear;
  Var
    I: Integer;
  begin
    for I := High(self) downto Low(self) do
    if Assigned(self[i].RPCData) then
      FreeAndNil(self[i].RPCData);

    SetLength(self, 0);
  end;

{$WARN SYMBOL_PLATFORM ON}
end.
