(*
Screen Reader software wishing to function properly with CPRS and some other VHA
Win32 applications must provide a DLL in the "\Program Files\VistA\Common Files\"
directory that has an extension of .SR, (not .DLL)

This DLL must export the routines shown below (they should use this include file) 
*)

// When a component receives focus, the screen reader needs to request data about the
// component.  The Call Back proc is called, and the VA app then supplies the info by
// calling the returning the ComponentDataAsRequested procedure.

// Checks to see if the screen reader is currently running
function IsRunning(HighVersion, LowVersion: Word): BOOL; stdcall;

function FindJaws(): BOOL; stdcall;

// Executed after IsRunning returns TRUE, when the DLL is accepted as the screen reader of choice
// if result returns a string, Initialization failed with retuned error message
// TComponentDataRequestProc is defined in the VA508AccessibilityConst unit
function Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL; stdcall;

function InitializeEx(ComponentCallBackProc: TComponentDataRequestProc; DoThread: Boolean; ShowSplash: Boolean; HostApplication: String)
  : BOOL; stdcall;

// Executed when the DLL is unloaded or screen reader is no longer needed
procedure ShutDown; stdcall;

// Instructs the Screen Reader to modify the way it handles specific information,
// such as how it pronounces specific words, or how it handles specific classes of components
procedure RegisterCustomBehavior(BehaviorType: integer; Before, After: PChar); stdcall;

// Returns Component Data as requested by the screen reader
// or in response to a change event
// must be able to support multiple calls for the same custom behavior
procedure ComponentData(WindowHandle:     HWND;
                        DataStatus:       LongInt = DATA_NONE;
                        Caption:          PChar   = nil;
                        Value:            PChar   = nil;
                        Data:             PChar   = nil;
                        ControlType:      PChar   = nil;
                        State:            PChar   = nil;
                        Instructions:     PChar   = nil;
                        ItemInstructions: PChar   = nil); stdcall;

// Instructs the Screen Reader to say the specified text
procedure SpeakText(Text: PChar); stdcall;

// A configuration change had been made that has yet to take effect
function ConfigChangePending: boolean; stdcall;


