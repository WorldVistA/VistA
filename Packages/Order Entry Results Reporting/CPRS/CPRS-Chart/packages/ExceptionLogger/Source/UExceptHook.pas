/// /////////////////////////////////////////////////////////////////////////////
///
/// EXCEPTION HOOK UNIT
///
/// -DESCRIPTION
/// This unit is responsible for hooking into the exception
/// and returning the formatted stack information
///
///
///
///
/// -IMPLEMENTATION
/// To start this unit you just need to make the call into
/// StartExceptionStackMonitoring to start the monitoring and
/// StopExceptionStackMonitoring to stop the monitoring
///
/// /////////////////////////////////////////////////////////////////////////////

unit UExceptHook;

interface

uses
  System.Generics.Collections,
  Winapi.Windows;

type
  TStack = class(TList<Pointer>)
  public
    procedure Assign(Source: TStack);
  end;

procedure StartExceptionStackMonitoring;
procedure StopExceptionStackMonitoring;

// Headers for Windows api calls
function AddVectoredExceptionHandler(FirstHandler: DWORD;
  VectoredHandler: Pointer): Pointer; stdcall;
  external 'kernel32.dll' name 'AddVectoredExceptionHandler';
function RemoveVectoredExceptionHandler(VectoredHandlerHandle: Pointer): ULONG;
  stdcall; external 'kernel32.dll' name 'RemoveVectoredExceptionHandler';

implementation

uses
  System.SysUtils,
  System.Classes;

type
  PEXCEPTION_POINTERS = ^EXCEPTION_POINTERS;

  tExceptionHook = class(TObject)
  strict private
    FExceptionHandler: Pointer;
    fOrigGetExceptionStackInfoProc
      : function(P: System.SysUtils.PExceptionRecord): Pointer;
    FLastStack: TStack;
    FIsHandlingExceptionCount: integer;
    function GetFramePointer: Pointer;
    function GetTopOfStack: Pointer;
    function IsValidAddr(const Addr: Pointer): Boolean;
    function IsValidCodeAddr(const Addr: Pointer): Boolean;
    function GetCurrentAddress: Pointer;
    procedure GrabTheStack(aEIP, aEBP: Pointer);
    function GetIsHandlingException: Boolean;
    property IsHandlingException: Boolean read GetIsHandlingException;
    property LastStack: TStack read FLastStack;
  private
    function NewGetExceptionStackInfoProc
      (P: System.SysUtils.PExceptionRecord): Pointer;
    function NewExceptionHandler(Info: PEXCEPTION_POINTERS): LongInt;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  ExceptionHook: tExceptionHook;

const
  // EXCEPTION_CONTINUE_EXECUTION = -1; // Not used, but leave around as these three consts belong together
  EXCEPTION_CONTINUE_SEARCH = 0;
  EXCEPTION_EXECUTE_HANDLER = 1;

type
  PStackFrame = ^TStackFrame;

  TStackFrame = record
    CallerFrame: Pointer;
    CallerAddr: Pointer;
  end;

  NT_TIB32 = packed record
    ExceptionList: DWORD;
    StackBase: DWORD;
    StackLimit: DWORD;
    SubSystemTib: DWORD;
    case integer of
      0:
        (FiberData: DWORD; ArbitraryUserPointer: DWORD; Self: DWORD;);
      1:
        (Version: DWORD;);
  end;

function IsMainThread: Boolean;
begin
  Result := GetCurrentThreadID = MainThreadID;
end;

procedure StartExceptionStackMonitoring;
begin
  if not Assigned(ExceptionHook) then
  begin
    if not IsMainThread then
      raise Exception.Create
        ('Exception stack monitoring needs to be started from the main thread');
    ExceptionHook := tExceptionHook.Create;
    // Make 100% certain there's only ever one!
  end;
end;

procedure StopExceptionStackMonitoring;
begin
  FreeAndNil(ExceptionHook);
end;

// ==============================================================================
// The two entrypoints for exception handling
// ==============================================================================

function GetExceptionStackInfoProc(P: System.SysUtils.PExceptionRecord)
  : Pointer;
begin
{$R+}
  try
    if Assigned(ExceptionHook) then
      Result := ExceptionHook.NewGetExceptionStackInfoProc(P)
    else
      Result := nil;
  except
    // No errors in exception handling!
    Result := nil;
  end;
{$R-}
end;

function ExceptionHandler(Info: PEXCEPTION_POINTERS): LongInt; stdcall;
// The Vector Exception Handling (VEH) function to collect the Context record
// of the exception
begin
{$R+}
  try
    if Assigned(ExceptionHook) then
      Result := ExceptionHook.NewExceptionHandler(Info)
    else
      Result := EXCEPTION_CONTINUE_SEARCH; // Mark exception as unhandled
  except
    // No errors in exception handling!
    Result := EXCEPTION_CONTINUE_SEARCH; // Mark exception as unhandled
  end;
{$R-}
end;

// ==============================================================================
// tExceptionHook
// ==============================================================================

constructor tExceptionHook.Create;
begin
  inherited;
  // Set the exception functions so that we can lookup and return information
  // about the exception
{$R+}
  fOrigGetExceptionStackInfoProc := Exception.GetExceptionStackInfoProc;
  Exception.GetExceptionStackInfoProc := GetExceptionStackInfoProc;

  FExceptionHandler := AddVectoredExceptionHandler(1, @ExceptionHandler);
  if not Assigned(FExceptionHandler) then
    RaiseLastOSError;

  FLastStack := TStack.Create;
{$R-}
end;

destructor tExceptionHook.Destroy;
begin
{$R+}
  FreeAndNil(FLastStack);
  // Clear our exception monitoring and return them to what they were before we
  // started monitoring.
  RemoveVectoredExceptionHandler(FExceptionHandler);
  Exception.GetExceptionStackInfoProc := fOrigGetExceptionStackInfoProc;
{$R-}
  inherited Destroy;
end;

function tExceptionHook.GetTopOfStack: Pointer; assembler;
asm
  MOV EAX, FS:[0].NT_TIB32.StackBase
end;

function tExceptionHook.GetFramePointer: Pointer;
asm
  MOV EAX, EBP
end;

function tExceptionHook.GetIsHandlingException: Boolean;
begin
  Result := FIsHandlingExceptionCount > 0;
end;

function tExceptionHook.GetCurrentAddress: Pointer;
// Trying to keep this SUPER simple, as it's used when an error occurs during
// exception handling
var
  StackFrame: PStackFrame;
begin
  StackFrame := GetFramePointer;
  Result := Pointer(PByte(StackFrame^.CallerAddr) - 1);
end;

procedure tExceptionHook.GrabTheStack(aEIP, aEBP: Pointer);
const
  MAX_STACK_LENGTH = 100; // Maximum Recorded Stack Depth, to avoid endless loop
var
  TopOfStack: PByte;
  // explains why to use PByte: http://docwiki.embarcadero.com/RADStudio/Sydney/en/Converting_32-bit_Delphi_Applications_to_64-bit_Windows
  BaseOfStack: PByte;
  StackFrame: PStackFrame;
  CurrentLevel: integer;
  AStack: TStack;
begin
  if not Assigned(FLastStack) then
    Exit;
  AStack := FLastStack;
  try
    AStack.Clear;
    CurrentLevel := 0;
    if IsValidAddr(aEIP) then
      AStack.Add(aEIP); // I have not seen this being helpful
    // Grab the current stacked frame
    StackFrame := aEBP;
    // StackFrame := GetFramePointer; // This works!
    // Set our starting point
    BaseOfStack := PByte(StackFrame);
    // Set the end point
    TopOfStack := PByte(GetTopOfStack);
    // While we are less than our max stack depth, frame is between the top and bottom, frame is not the same as the previous,
    // and the location is valid and has the right access authority
    while (CurrentLevel < MAX_STACK_LENGTH) and
      (PByte(BaseOfStack) <= PByte(StackFrame)) and
      (PByte(StackFrame) < PByte(TopOfStack)) and IsValidAddr(StackFrame) and
      IsValidCodeAddr(StackFrame^.CallerAddr) and
      (StackFrame <> StackFrame^.CallerFrame) do
    begin
      if CurrentLevel >= 0 then
        AStack.Add(Pointer(PByte(StackFrame^.CallerAddr) - 1));
      StackFrame := PStackFrame(StackFrame^.CallerFrame);
      Inc(CurrentLevel);
    end;
  except
    AStack.Insert(0, GetCurrentAddress);
    raise;
  end;
end;

function tExceptionHook.IsValidCodeAddr(const Addr: Pointer): Boolean;
const
  aPAGE_CODE: Cardinal = (PAGE_EXECUTE or PAGE_EXECUTE_READ or
    PAGE_EXECUTE_READWRITE or PAGE_EXECUTE_WRITECOPY);
var
  AMBI: TMemoryBasicInformation;
begin
  // Can we find this in the virtual address space of the calling process and
  // the page has the right access
  ZeroMemory(@AMBI, SizeOf(AMBI));
  Result := Assigned(Addr) and (VirtualQuery(Addr, AMBI, SizeOf(AMBI)) <> 0) and
    ((AMBI.Protect and aPAGE_CODE) <> 0);
end;

function tExceptionHook.IsValidAddr(const Addr: Pointer): Boolean;
var
  AMBI: TMemoryBasicInformation;
begin
  // Can we find this in the virtual address space of the calling process
  Result := Assigned(Addr) and
    (VirtualQuery(Addr, AMBI, SizeOf(TMemoryBasicInformation)) <> 0);
end;

function tExceptionHook.NewGetExceptionStackInfoProc
  (P: System.SysUtils.PExceptionRecord): Pointer;
// This returns a TStack object as a Pointer.
// The stack will not contain the correct information until the
// ExceptionHandler function has been called (which will happen after this),
// but that doesn't matter because the Exception won't be handled until after
// both have ran.
begin
{$R+}
  try
    Result := LastStack;
  except
    // No errors in exception handling!
    Result := nil;
  end;
{$R-}
end;

function tExceptionHook.NewExceptionHandler(Info: PEXCEPTION_POINTERS): LongInt;
// The Vector Exception Handling (VEH) function to collect the Context record
// of the exception
begin
{$R+}
  try
    if not IsHandlingException then
    begin
      Inc(FIsHandlingExceptionCount);
      try
        GrabTheStack(Pointer(Info^.ContextRecord^.Eip),
          Pointer(Info^.ContextRecord^.EBP));
      finally
        Dec(FIsHandlingExceptionCount);
      end;
    end;
    Result := EXCEPTION_EXECUTE_HANDLER; // Mark exception as handled
  except
    // No errors in exception handling!
    Result := EXCEPTION_EXECUTE_HANDLER; // Mark exception as handled
  end;
{$R-}
end;

{ TStack }

procedure TStack.Assign(Source: TStack);
begin
  Clear;
  if Assigned(Source) then
    for var I := 0 to Source.Count - 1 do Add(Source[I]);
end;

initialization

finalization

StopExceptionStackMonitoring;

end.
