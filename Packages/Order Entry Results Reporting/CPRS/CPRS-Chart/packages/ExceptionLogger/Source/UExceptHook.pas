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

uses Classes, SysUtils, Windows;

type
  PEXCEPTION_POINTERS = ^EXCEPTION_POINTERS;

  tExceptionHook = class(tobject)
  private
    fStackInfo: TStringList;
    fMBI: TMemoryBasicInformation;
    fProcessingAV: Boolean;
    fLastStack: TStringList;
    fInfoContext: _EXCEPTION_POINTERS;
    procedure BeginMonitoring;
    procedure EndMonitoring;
    function GetTopOfStack: Pointer;
    function IsValidAddr(const Addr: Pointer): Boolean;
    function IsValidCodeAddr(const Addr: Pointer): Boolean;
    function GetProcessingAV: Boolean;
    procedure GrabTheAddresses(out TheList: TStringList;
      const aEIP, aEBP: Pointer);
  public
    constructor Create();
    destructor Destroy; override;
    function SetupStack(Context: PContext): TStringList; overload;
    function SetupStack(const EIP, EBP: Pointer): TStringList; overload;
    function SetupNoTraceStack(Context: PContext): TStringList; overload;
    function SetupNoTraceStack(const EIP, EBP: Pointer): TStringList; overload;
    property ProcessingAV: Boolean read GetProcessingAV;
    Property LastStack: TStringList read fLastStack write fLastStack;
  end;

procedure CleanUpStackInfoProc(Info: Pointer);
function GetStackInfoStringProc(Info: Pointer): String;
function GetExceptionStackInfoProc(P: system.PExceptionRecord): Pointer;

procedure StartExceptionStackMonitoring;
procedure StopExceptionStackMonitoring;
function ExceptionHook: tExceptionHook;

function AddVectoredExceptionHandler(FirstHandler: DWORD;
  VectoredHandler: Pointer): Pointer; stdcall;
  external 'kernel32.dll' name 'AddVectoredExceptionHandler';
function RemoveVectoredExceptionHandler(VectoredHandlerHandle: Pointer): ULONG;
  stdcall; external 'kernel32.dll' name 'RemoveVectoredExceptionHandler';

implementation

var
  fExceptionHook: tExceptionHook;
  ExceptionHandle: Pointer;
  fOrigGetExceptionStackInfoProc: function (P: System.SysUtils.PExceptionRecord): Pointer;
  fOrigGetStackInfoStringProc: function (Info: Pointer): string;
  fOrigCleanUpStackInfoProc: procedure (Info: Pointer);

const
  AddressFormat = '[%s]';

  // Stack Depth
  MAX_STACK_LENGTH = 10;

  EXCEPTION_CONTINUE_EXECUTION = -1;
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
    case Integer of
      0:
        (FiberData: DWORD; ArbitraryUserPointer: DWORD; Self: DWORD;);
      1:
        (Version: DWORD;);
  end;

procedure StartExceptionStackMonitoring;
begin
  fExceptionHook := tExceptionHook.Create;
end;

procedure StopExceptionStackMonitoring;
begin
  if Assigned(fExceptionHook) then
    FreeAndNil(fExceptionHook);
end;

function ExceptionHook: tExceptionHook;
begin
  result := fExceptionHook;
end;

procedure CleanUpStackInfoProc(Info: Pointer);
{
  CleanUpStackInfoProc cleans up the stack information.

  Assign a method to CleanUpStackInfoProc to clean up the opaque data structure
  that contains stack information. The function pointed to by
  CleanUpStackInfoProc is called when the exception is being destroyed.
}
begin
  if Assigned(Info) then
    TStringList(Info).free;
end;

function GetStackInfoStringProc(Info: Pointer): String;
{
  GetStackInfoStringProc generates a formatted string with the stack trace.

  Assign a method to GetStackInfoStringProc to generate a formatted string
  containing the stack trace. The function pointed to by GetStackInfoStringProc
  is called by the GetStackTrace method.
}
var
  StackInfo: TStringList;
begin
{$R+}
  try
    result := '';
    if Assigned(Info) then
    begin
      StackInfo := TStringList(Info);
      result := Trim(StackInfo.Text);
    end;
  except
    result := '';
  end;
{$R-}
end;

function ExceptionHandler(Info: PEXCEPTION_POINTERS): LongInt; stdcall;
{
 The Vector Exception Handling (VEH) function to collect the Context record
 of the exception
}
begin
{$R+}
  ExceptionHook.fInfoContext.ExceptionRecord := nil;
  ExceptionHook.fInfoContext.ContextRecord := nil;
  ExceptionHook.fInfoContext := Info^;
  result := EXCEPTION_CONTINUE_SEARCH;
{$R-}
end;

function GetExceptionStackInfoProc(P: system.PExceptionRecord): Pointer;
{
 GetExceptionStackInfoProc generates stack information from an exception record.

 Assign a method to GetExceptionStackInfoProc to return an opaque data
 structure that contains stack information for the given exception information
 record. The function pointed to by GetExceptionStackInfoProc is called when
 the exception is about to be raised.
}
begin
{$R+}
  result := nil;
  try
    if Assigned(ExceptionHook.fInfoContext.ContextRecord) then
    begin
      // Setup the stack info as a tStringList
      if ExceptionHook.ProcessingAV then
        result := ExceptionHook.SetupNoTraceStack
          (ExceptionHook.fInfoContext.ContextRecord)
      else
        result := ExceptionHook.SetupStack
          (ExceptionHook.fInfoContext.ContextRecord);
      end;
  except
    result := nil;
  end;
{$R-}
end;

// ==============================================================================
// tExceptionHook
// ==============================================================================

procedure tExceptionHook.BeginMonitoring;
{
 Set the exception functions so that we can lookup and return information
 about the exception
}
begin
{$R+}
  if assigned(Exception.GetExceptionStackInfoProc) then
    fOrigGetExceptionStackInfoProc := Exception.GetExceptionStackInfoProc;
  Exception.GetExceptionStackInfoProc := GetExceptionStackInfoProc;

  if assigned(Exception.GetStackInfoStringProc) then
    fOrigGetStackInfoStringProc := Exception.GetStackInfoStringProc;
  Exception.GetStackInfoStringProc := GetStackInfoStringProc;

  if assigned(Exception.CleanUpStackInfoProc) then
    fOrigCleanUpStackInfoProc := Exception.CleanUpStackInfoProc;
  Exception.CleanUpStackInfoProc := CleanUpStackInfoProc;

  ExceptionHandle := AddVectoredExceptionHandler(1, @ExceptionHandler);
  if not Assigned(ExceptionHandle) then
    RaiseLastOSError;
{$R-}
end;

procedure tExceptionHook.EndMonitoring;
{
 Clear our exception monitoring and return them to what they were before we
 started monitoring.
}
begin
{$R+}
  RemoveVectoredExceptionHandler(ExceptionHandle);

  if Assigned(fOrigCleanUpStackInfoProc) then
     Exception.CleanUpStackInfoProc := fOrigCleanUpStackInfoProc
  else
    Exception.CleanUpStackInfoProc := nil;

  if Assigned(fOrigGetStackInfoStringProc) then
   Exception.GetStackInfoStringProc := fOrigGetStackInfoStringProc
  else
    Exception.GetStackInfoStringProc := nil;

  if Assigned(fOrigGetExceptionStackInfoProc) then
    Exception.GetExceptionStackInfoProc := fOrigGetExceptionStackInfoProc
  else
    Exception.GetExceptionStackInfoProc := nil;
{$R-}
end;

constructor tExceptionHook.Create();
begin
  inherited;
  fProcessingAV := false;
  BeginMonitoring;
end;

destructor tExceptionHook.Destroy;
begin
  EndMonitoring;
  if Assigned(fLastStack) then
    FreeAndNil(fLastStack);
  inherited;
end;

function tExceptionHook.GetTopOfStack: Pointer; assembler;
asm MOV EAX, FS:[0].NT_TIB32.StackBase
end;

procedure tExceptionHook.GrabTheAddresses(out TheList: TStringList;
  const aEIP, aEBP: Pointer);
var
  TopOfStack: Pointer;
  BaseOfStack: Pointer;
  StackFrame: PStackFrame;
  CurentLevel: Integer;
begin
  TheList.Clear;

  CurentLevel := 0;
  TheList.Add(Format('%p', [aEIP]));

  // Grab the current stacked frame
  StackFrame := aEBP;
  // Set our starting point
  BaseOfStack := Pointer(Cardinal(StackFrame) - 1);
  // Set the end point
  TopOfStack := GetTopOfStack;
  // While we are less than our max stack depth, frame is between the top and bottom, frame is not the same as the previous,
  // and the location is valid and has the right access authority
  while (CurentLevel < MAX_STACK_LENGTH) and
    ((Cardinal(BaseOfStack) < Cardinal(StackFrame)) and
    (Cardinal(StackFrame) < Cardinal(TopOfStack)) and
    (StackFrame <> StackFrame^.CallerFrame) and IsValidAddr(StackFrame) and
    IsValidCodeAddr(StackFrame^.CallerAddr)) do
  begin
    if CurentLevel >= 0 then
      TheList.Add(Format('%p',
        [Pointer(Cardinal(StackFrame^.CallerAddr) - 1)]));
    StackFrame := PStackFrame(StackFrame^.CallerFrame);
    Inc(CurentLevel);
  end;
end;

function tExceptionHook.SetupStack(const EIP, EBP: Pointer): TStringList;

  procedure AddStackDetails(const P: Pointer);
  begin
    fStackInfo.Add(Format(AddressFormat, [Format('%p', [P])]));
  end;

var
  TopOfStack: Pointer;
  BaseOfStack: Pointer;
  StackFrame: PStackFrame;
  CurentLevel: Integer;
begin
  fProcessingAV := true;
  try
    fStackInfo := TStringList.Create;
    if not Assigned(fLastStack) then
      fLastStack := TStringList.Create;

    // Grab this raw stack stack
    GrabTheAddresses(fLastStack, EIP, EBP);

    CurentLevel := 0;
    AddStackDetails(EIP);
    // Grab the current stacked frame
    StackFrame := EBP;

    // Set our starting point
    BaseOfStack := Pointer(Cardinal(StackFrame) - 1);
    // Set the end point
    TopOfStack := GetTopOfStack;
    // While we are less than our max stack depth, frame is between the top and bottom, frame is not the same as the previous,
    // and the location is valid and has the right access authority
    while (CurentLevel < MAX_STACK_LENGTH) and
      ((Cardinal(BaseOfStack) < Cardinal(StackFrame)) and
      (Cardinal(StackFrame) < Cardinal(TopOfStack)) and
      (StackFrame <> StackFrame^.CallerFrame) and IsValidAddr(StackFrame) and
      IsValidCodeAddr(StackFrame^.CallerAddr)) do
    begin
      if CurentLevel >= 0 then
        AddStackDetails(Pointer(Cardinal(StackFrame^.CallerAddr) - 1));
      StackFrame := PStackFrame(StackFrame^.CallerFrame);
      Inc(CurentLevel);
    end;
  finally
    fProcessingAV := false;
  end;
  result := fStackInfo;
end;

function tExceptionHook.SetupStack(Context: PContext): TStringList;
begin
  result := SetupStack(Pointer(Context^.EIP), Pointer(Context^.EBP));
end;

function tExceptionHook.SetupNoTraceStack(const EIP, EBP: Pointer): TStringList;
{
 This runs when we have an exception during our lookup process. We want to keep
 the old stack as well as the new stack
}
var
  aList: TStringList;
begin
  fProcessingAV := false;
  result := TStringList.Create;
  try

    aList := TStringList.Create;
    try
      result.Add
        ('An error ouccured while trying to lookup the access violation. Please see the information below');
      result.Add('');
      result.Add('');
      result.Add('Original Lookup Stack');
      if Assigned(LastStack) then
        result.AddStrings(LastStack);
      result.AddStrings(aList);
      result.Add('');
      GrabTheAddresses(aList, EIP, EBP);
      if aList.Count > 0 then
      begin
        result.Add('Lookup Error Stack');
        result.AddStrings(aList);
      end;

    finally
      aList.Free;
    end;

  except

  end;

end;

function tExceptionHook.SetupNoTraceStack(Context: PContext): TStringList;
begin
  result := SetupNoTraceStack(Pointer(Context^.EIP), Pointer(Context^.EBP));
end;

function tExceptionHook.IsValidCodeAddr(const Addr: Pointer): Boolean;
const
  aPAGE_CODE: Cardinal = (PAGE_EXECUTE or PAGE_EXECUTE_READ or
    PAGE_EXECUTE_READWRITE or PAGE_EXECUTE_WRITECOPY);
Begin
  // Can we find this in the virtual address space of the calling process and
  // the page has the right access
  result := (VirtualQuery(Addr, fMBI, SizeOf(TMemoryBasicInformation)) <> 0) and
    ((fMBI.Protect and aPAGE_CODE) <> 0);
end;

function tExceptionHook.IsValidAddr(const Addr: Pointer): Boolean;
Begin
  // Can we find this in the virtual address space of the calling process
  result := (VirtualQuery(Addr, fMBI, SizeOf(TMemoryBasicInformation)) <> 0);
end;

function tExceptionHook.GetProcessingAV: Boolean;
begin
  result := fProcessingAV;
end;

initialization

finalization

// ensure we dont leak
if Assigned(fExceptionHook) then
  FreeAndNil(fExceptionHook);

end.
