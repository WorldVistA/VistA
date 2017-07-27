/// /////////////////////////////////////////////////////////////////////////////
/// ///
/// EXCEPTION HOOK UNIT                                  ///
/// ///
/// -DESCRIPTION                                                         ///
/// This unit is responsible for hooking into the exception          ///
/// and returning the formated stack information                     ///
/// ///
/// ///
/// ///
/// ///
/// -IMPLEMNTATION                                                       ///
/// To start this unit you just need to make the call into           ///
/// StartExceptionStackMonitoring to start the monitoring and        ///
/// StopExceptionStackMonitoring to stop the monitoring              ///
/// ///
/// /////////////////////////////////////////////////////////////////////////////

unit UExceptHook;

interface

uses Classes, SysUtils, Windows, uMapParser;

type
  TParamArray = array [0 .. 14] of Pointer;

  /// <summary><para>Exception Hook Object</para><para><b>Type: </b><c>tobject</c></para></summary>
  tExceptionHook = class(tobject)
  private
    /// <summary><para>Original hook identifer</para></summary>
    fNotifyHookCache: Byte;
    fInIDE: Boolean;
    fStackInfo: TStringList;
    fMBI: TMemoryBasicInformation;
    fProcessingAV: Boolean;
    fActive: Boolean;
    fMapParser: tMapParser;
    fLastStack: TStringList;
    procedure HookException;
    procedure ReleaseException;
    function GetTopOfStack: Pointer;
    /// <summary><para>Checks for valid address</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Addr">Address to check<para><b>Type: </b><c>Pointer</c></para></param>
    /// <returns><para><b>Type: </b><c>Boolean</c></para> - </returns>
    function IsValidAddr(const Addr: Pointer): Boolean;
    function IsValidCodeAddr(const Addr: Pointer): Boolean;
    function GetDebugHook: Byte;
    procedure SetDebugHook(const aValue: Byte);
    function GetInIDE: Boolean;
    function GetOrigNotifyHook: Byte;
    function GetProcessingAV: Boolean;
    function GetActive: Boolean;
    procedure GrabTheAddresses(out TheList: TStringList; const aEIP, aEBP: Pointer);
  public
    constructor Create();
    destructor Destroy; override;
    function SetupStack(Context: PContext): TStringList; overload;
    function SetupStack(const EIP, EBP: Pointer): TStringList; overload;
    function SetupNoTraceStack(Context: PContext): TStringList; overload;
    function SetupNoTraceStack(const EIP, EBP: Pointer): TStringList; overload;
    procedure SetupMapParser;
    Procedure TearDownMapParser;
    Property InIDE: Boolean read GetInIDE;
    Property OrigNotifyHook: Byte read GetOrigNotifyHook;
    property _DebugHook: Byte read GetDebugHook write SetDebugHook;
    property ProcessingAV: Boolean read GetProcessingAV;
    Property Active: Boolean read GetActive;
    Property LastStack: TStringList read fLastStack write fLastStack;
  end;

  /// <summary><para>this is a test</para></summary>
  /// <param name="ExceptionCode">ExceptionCode<para><b>Type: </b><c>LongWord</c></para></param>
  /// <param name="ExceptionFlags">ExceptionFlags<para><b>Type: </b><c>LongWord</c></para></param>
  /// <param name="NumberOfArguments">NumberOfArguments<para><b>Type: </b><c>LongWord</c></para></param>
  /// <param name="Args">Args<para><b>Type: </b><c>Pointer</c></para></param>
procedure HookedRaiseExceptionProc(ExceptionCode, ExceptionFlags: Longword; NumberOfArguments: Longword; Args: Pointer); stdcall;
procedure CleanUpStackInfoProc(Info: Pointer);
function GetStackInfoStringProc(Info: Pointer): String;

procedure StartExceptionStackMonitoring;
procedure StopExceptionStackMonitoring;
function ExceptionHook: tExceptionHook;

implementation

var
  fOrigRaiseExceptionProc: TRaiseExceptionProc;
  fExceptionHook: tExceptionHook;

const
  StackFormat = '[%s] %s (Line %s, "%s")';
  AddressFormat = '[%s]';

  // Stack Depth
  MAX_STACK_LENGTH = 10;

  // Delphi exceptions
  cDelphiException = $0EEDFADE;
  cDelphiReRaise = $0EEDFADF;
  cDelphiExcept = $0EEDFAE0;
  cDelphiFinally = $0EEDFAE1;
  cDelphiTerminate = $0EEDFAE2;
  cDelphiUnhandled = $0EEDFAE3;
  cNonDelphiException = $0EEDFAE4;
  cDelphiExitFinally = $0EEDFAE5;
  cUnknownExceptionCode = $0EEDFACF;
  cContinuable = 0;

type
  aException = class(Exception);

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

// ==============================================================================
// tExceptionHook
// ==============================================================================

procedure HookedRaiseExceptionProc(ExceptionCode, ExceptionFlags: Longword; NumberOfArguments: Longword; Args: Pointer); stdcall;
var
  ContextRecord: PContext;
  ExceptionObj: aException;
  ArgsArry: TParamArray;
begin

  // If in the ide (or the av is internal to this process) then let it handle this for us
  if ExceptionHook.InIDE or ExceptionHook.ProcessingAV or (not ExceptionHook.Active) then
  begin
    // Got an error while trying to process the last error. Need to show both new and old
    if ExceptionHook.ProcessingAV then
    begin
        if (ExceptionCode = cNonDelphiException) then
        begin
          // Grab the context and exception object
          ArgsArry := TParamArray(Args^);
          ContextRecord := ArgsArry[0];
          ExceptionObj := ArgsArry[1];
          // Setup the stack info
          ExceptionObj.SetStackInfo(ExceptionHook.SetupNoTraceStack(ContextRecord));
        end
        else if (ExceptionCode = cDelphiException) and (ExceptionFlags <> cContinuable) then
        begin
          ArgsArry := TParamArray(Args^);
          ExceptionObj := ArgsArry[1];
          // Setup the stack info
          ExceptionObj.SetStackInfo(ExceptionHook.SetupNoTraceStack(ArgsArry[0], ArgsArry[5]));
        end;

      if ExceptionFlags <> cContinuable then
      begin
        // Use the original call
        ExceptionHook._DebugHook := ExceptionHook.OrigNotifyHook;
        try
          fOrigRaiseExceptionProc(ExceptionCode, ExceptionFlags, NumberOfArguments, Args)
        finally
          ExceptionHook._DebugHook := 1;
        end;
      end

    end
    else
      fOrigRaiseExceptionProc(ExceptionCode, ExceptionFlags, NumberOfArguments, Args);
  end
  else
  begin
    if (ExceptionCode = cNonDelphiException) or ((ExceptionCode = cDelphiException) and (ExceptionFlags <> cContinuable)) then
    begin
      if (ExceptionCode = cNonDelphiException) then
      begin
        // Grab the context and exception object
        ArgsArry := TParamArray(Args^);
        ContextRecord := ArgsArry[0];
        ExceptionObj := ArgsArry[1];
        // Setup the stack info
        ExceptionObj.SetStackInfo(ExceptionHook.SetupStack(ContextRecord));
      end
      else if (ExceptionCode = cDelphiException) and (ExceptionFlags <> cContinuable) then
      begin
        ArgsArry := TParamArray(Args^);
        ExceptionObj := ArgsArry[1];
        // Setup the stack info
        ExceptionObj.SetStackInfo(ExceptionHook.SetupStack(ArgsArry[0], ArgsArry[5]));
      end;
    end
    else
      fOrigRaiseExceptionProc(ExceptionCode, ExceptionFlags, NumberOfArguments, Args);

    if ExceptionFlags <> cContinuable then
    begin
      // Use the original call
      ExceptionHook._DebugHook := ExceptionHook.OrigNotifyHook;
      try
        fOrigRaiseExceptionProc(ExceptionCode, ExceptionFlags, NumberOfArguments, Args)
      finally
        ExceptionHook._DebugHook := 1;
      end;
    end;
  end;
end;

procedure CleanUpStackInfoProc(Info: Pointer);
begin
  FreeAndNil(Info);
end;

function GetStackInfoStringProc(Info: Pointer): String;
var
  StackInfo: TStringList;
begin
  result := '';
  if Assigned(Info) then
  begin
    StackInfo := TStringList(Info);
    result := Trim(StackInfo.Text);
  end;
end;

procedure tExceptionHook.HookException;
begin
  if not fInIDE then
  begin
    // Want to restor the noify hook back
    fNotifyHookCache := _DebugHook;
    _DebugHook := 1;
    // Keep original call and hook to ours
    fOrigRaiseExceptionProc := RaiseExceptionProc;
    RaiseExceptionProc := @HookedRaiseExceptionProc;
    Exception.CleanUpStackInfoProc := @CleanUpStackInfoProc;
    Exception.GetStackInfoStringProc := @GetStackInfoStringProc;
  end;
end;

procedure tExceptionHook.ReleaseException;
begin
  if not fInIDE then
  begin
    _DebugHook := fNotifyHookCache;
    RaiseExceptionProc := @fOrigRaiseExceptionProc;
    Exception.CleanUpStackInfoProc := nil;
    Exception.GetStackInfoStringProc := nil;
  end;
end;

constructor tExceptionHook.Create();
begin
  inherited;
  fActive := true;
  fNotifyHookCache := 0;
  fOrigRaiseExceptionProc := nil;
  fProcessingAV := false;
  fInIDE := (_DebugHook <> 0);

  HookException;
end;

destructor tExceptionHook.Destroy;
begin
  ReleaseException;
  if Assigned(fLastStack) then
   FreeAndNil(fLastStack);
  inherited;
end;

function tExceptionHook.GetTopOfStack: Pointer; assembler;
asm MOV EAX, FS:[0].NT_TIB32.StackBase
end;

  procedure tExceptionHook.GrabTheAddresses(out TheList: TStringList; const aEIP, aEBP: Pointer);
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
    while (CurentLevel < MAX_STACK_LENGTH) and ((Cardinal(BaseOfStack) < Cardinal(StackFrame)) and (Cardinal(StackFrame) < Cardinal(TopOfStack)) and (StackFrame <> StackFrame^.CallerFrame) and IsValidAddr(StackFrame) and IsValidCodeAddr(StackFrame^.CallerAddr)) do
    begin
      if CurentLevel >= 0 then
        TheList.Add(Format('%p', [Pointer(Cardinal(StackFrame^.CallerAddr) - 1)]));
      StackFrame := PStackFrame(StackFrame^.CallerFrame);
      Inc(CurentLevel);
    end;
  end;

function tExceptionHook.SetupStack(const EIP, EBP: Pointer): TStringList;

  procedure AddStackDetails(const p: Pointer);
  const
    Offset = $401000;
  var
    LookUp: Longword;
    aUnitName, aMethodName, aLinNum: String;
  begin
    LookUp := Integer(p);

    if ExceptionHook.Active then
    begin

      // fStackInfo.Add(TMapInfo.Global.GetAddrMapInfo(LookUp));

      if LookUp < Offset then
        exit;

      LookUp := LookUp - Offset;

      fMapParser.LookupInMap(LookUp, aUnitName, aMethodName, aLinNum);

      if (aUnitName <> 'NA') then
        fStackInfo.Add(Format(StackFormat, [Format('%p', [p]), aMethodName, aLinNum, aUnitName]));
      // fStackInfo.Add('[' + Format('%p', [p]) + '] ' + aMethodName + ' (Line ' + aLinNum + ', "' + aUnitName + '")');
    end
    else
      fStackInfo.Add(Format(AddressFormat, [Format('%p', [p])]));
    // fStackInfo.Add('[' +  + '] ');
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
    ExceptionHook.SetupMapParser;
    try
      if not Assigned(fLastStack) then
        fLastStack := TStringList.Create;

      //Grab this raw stack stack
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
      while (CurentLevel < MAX_STACK_LENGTH) and ((Cardinal(BaseOfStack) < Cardinal(StackFrame)) and (Cardinal(StackFrame) < Cardinal(TopOfStack)) and (StackFrame <> StackFrame^.CallerFrame) and IsValidAddr(StackFrame) and IsValidCodeAddr(StackFrame^.CallerAddr)) do
      begin
        if CurentLevel >= 0 then
          AddStackDetails(Pointer(Cardinal(StackFrame^.CallerAddr) - 1));
        StackFrame := PStackFrame(StackFrame^.CallerFrame);
        Inc(CurentLevel);
      end;
    finally
      ExceptionHook.TearDownMapParser;
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
var
  aList: TStringList;


begin
  fProcessingAV := false;
  result := TStringList.Create;
  try

    aList := TStringList.Create;
    try
      result.Add('An error ouccured while trying to lookup the access violation. Please see the information below');
      result.Add('');
      result.Add('');
      result.Add('Original Lookup Stack');
      result.AddStrings(LastStack);
      result.AddStrings(aList);
      result.Add('');
      result.Add('Lookup Error Stack');
      GrabTheAddresses(aList, EIP, EBP);
      result.AddStrings(aList);
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
  aPAGE_CODE: Cardinal = (PAGE_EXECUTE or PAGE_EXECUTE_READ or PAGE_EXECUTE_READWRITE or PAGE_EXECUTE_WRITECOPY);
Begin
  // Can we find this in the virtual address space of the calling process and
  // the page has the rifht access
  result := (VirtualQuery(Addr, fMBI, SizeOf(TMemoryBasicInformation)) <> 0) and ((fMBI.Protect and aPAGE_CODE) <> 0);
end;

function tExceptionHook.IsValidAddr(const Addr: Pointer): Boolean;
Begin
  // Can we find this in the virtual address space of the calling process
  result := (VirtualQuery(Addr, fMBI, SizeOf(TMemoryBasicInformation)) <> 0);
end;

function tExceptionHook.GetInIDE: Boolean;
begin
  result := fInIDE;
end;

function tExceptionHook.GetOrigNotifyHook: Byte;
begin
  result := fNotifyHookCache;
end;

function tExceptionHook.GetProcessingAV: Boolean;
begin
  result := fProcessingAV;
end;

function tExceptionHook.GetActive: Boolean;
begin
  result := fActive;
end;

function tExceptionHook.GetDebugHook: Byte;
begin
{$WARN SYMBOL_PLATFORM OFF}
  result := DebugHook;
{$WARN SYMBOL_PLATFORM ON}
end;

procedure tExceptionHook.SetDebugHook(const aValue: Byte);
begin
{$WARN SYMBOL_PLATFORM OFF}
  DebugHook := aValue;
{$WARN SYMBOL_PLATFORM ON}
end;

procedure tExceptionHook.SetupMapParser;
begin
  fMapParser := tMapParser.Create(true);
  fActive := fMapParser.MapLoaded;
end;

Procedure tExceptionHook.TearDownMapParser;
begin
  FreeAndNil(fMapParser);
end;

initialization

finalization

// ensure we dont leak
if Assigned(fExceptionHook) then
  FreeAndNil(fExceptionHook);

end.
