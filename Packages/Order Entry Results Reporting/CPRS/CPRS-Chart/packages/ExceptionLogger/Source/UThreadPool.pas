unit UThreadPool;

interface

uses
  Windows,
  Classes;

const
  WT_EXECUTEDEFAULT = DWORD($00000000);
  WT_EXECUTEINIOTHREAD = DWORD($00000001);
  WT_EXECUTEINUITHREAD = DWORD($00000002);
  WT_EXECUTEINWAITTHREAD = DWORD($00000004);
  WT_EXECUTEONLYONCE = DWORD($00000008);
  WT_EXECUTEINTIMERTHREAD = DWORD($00000020);
  WT_EXECUTELONGFUNCTION = DWORD($00000010);
  WT_EXECUTEINPERSISTENTIOTHREAD = DWORD($00000040);
  WT_EXECUTEINPERSISTENTTHREAD = DWORD($00000080);
  WT_TRANSFER_IMPERSONATION = DWORD($00000100);

function QueueUserWorkItem(ThreadFunc: TThreadStartRoutine; Context: Pointer; Flags: DWORD): BOOL; stdcall; external kernel32 name 'QueueUserWorkItem';

type
  TThreadPool = class
  private
    fWorkingThreads: Integer;
    fNumberOfThreads: Integer;
    procedure QueueWorkItem(Parameters: Pointer; WorkerEvent: TNotifyEvent);
  public
    function CreateThreadLimitFlag(Limit: DWORD): DWORD;
    function AreThreadsWorking: Boolean;
  public
    property AllTasksFinished: Boolean read AreThreadsWorking;
    property NumberOfThreads: Integer read fNumberOfThreads write fNumberOfThreads;
    constructor Create(NumberOfThreads: Integer);
    procedure AddTask(CallbackFunction: TNotifyEvent; Parameters: Pointer);
  end;

  TUserWorkItem = class
    ThreadBoss: TThreadPool;
    Parameters: Pointer;
    WorkerEvent: TNotifyEvent;
  public
    destructor Destroy; override;
  end;

implementation
uses
  SysUtils;

function InternalThreadFunction(lpThreadParameter: Pointer): Integer; stdcall;
begin
  Result := 0;
  Try
    Try
      With TUserWorkItem(lpThreadParameter) Do
      begin
        If Assigned(WorkerEvent) Then
        begin
          WorkerEvent(Parameters);
          InterlockedDecrement(ThreadBoss.fWorkingThreads);
        end;
      end;
    Finally
      FreeAndNil(TUserWorkItem(lpThreadParameter));
    end;
  except
    raise;
  end;
end;

function TThreadPool.CreateThreadLimitFlag(Limit: DWORD): DWORD;
begin
  Result := WT_EXECUTEDEFAULT;
  If Not(Limit in [1 .. 255]) Then
   Exit;
  Result := Result Or (Limit SHL 16);
end;

procedure TThreadPool.QueueWorkItem(Parameters: Pointer; WorkerEvent: TNotifyEvent);
var
  WorkItem: TUserWorkItem;
begin
  If Assigned(WorkerEvent) Then
  begin
    IsMultiThread := True;
    WorkItem := TUserWorkItem.Create;
    Try
      WorkItem.ThreadBoss := Self;
      WorkItem.WorkerEvent := WorkerEvent;
      WorkItem.Parameters := Parameters;
      InterlockedIncrement(fWorkingThreads);
      If Not(QueueUserWorkItem(InternalThreadFunction, WorkItem, CreateThreadLimitFlag(fNumberOfThreads))) Then
      begin
        InterlockedDecrement(fWorkingThreads);
        RaiseLastOSError;
      end;
    Except
      WorkItem.Free;
      raise;
    end;
  end;
end;

function TThreadPool.AreThreadsWorking: Boolean;
begin
  Result := (fWorkingThreads = 0);
end;

constructor TThreadPool.Create(NumberOfThreads: Integer);
begin
  inherited Create;
  fWorkingThreads := 0;
  fNumberOfThreads := NumberOfThreads;
end;

procedure TThreadPool.AddTask(CallbackFunction: TNotifyEvent; Parameters: Pointer);
begin
  QueueWorkItem(Parameters, CallbackFunction);
end;


destructor TUserWorkItem.Destroy;
begin
  inherited;
end;
end.
