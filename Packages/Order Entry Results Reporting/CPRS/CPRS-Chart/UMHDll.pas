unit UMHDll;
///////////////////////////////////////////////////////////////////////////////
///  This unit is a wrapper around the Mental Health dll. The (Delphi) code
///  for that dll resides in Git Repo spp_mha_core.
///
///  There are two sets of calls: regular (with broker) and brokerless (with
///  tokenbroker). This unit will try and use brokerless calls, if those entry
///  points can be found in the mental health dll. Otherwise it will use
///  regular calls. Regular calls will fail unless the Mental Health dll and
///  the code that uses this unit (CPRS) are compiled using the same broker
///  software, and the same Delphi version.
///
///  If a dll call fails, aditional information can be obtained through
///  properties Status and StatusMessage.
///////////////////////////////////////////////////////////////////////////////

interface

uses
  WinApi.Windows,
  rMisc,
  Trpcb;

type
  TMHDll = class(TObject)
{$SCOPEDENUMS ON}
  public type
    TDllStatus = (OK, SetupError, Missing, VersionError, FunctionMissing);
{$SCOPEDENUMS OFF}
  strict private
    class var FDllName: string;
    class var FHandle: THandle;
    class var FShowInstrument: FARPROC;
    class var FSaveInstrument: FARPROC;
    class var FRemoveTempVistaFile: FARPROC;
    class var FShowInstrument_TokenBroker: FARPROC;
    class var FSaveInstrument_TokenBroker: FARPROC;
    class var FRemoveTempVistaFile_TokenBroker: FARPROC;
    class var FCloseDll: FARPROC;
    class var FStatus: TDllStatus;
    class var FStatusMessage: string;
    class function GetDllName: string; static;
    class function GetConnectParams: string; static;
    class function GetBroker: TRPCBroker; static;
    class function GetIsLoaded: Boolean; static;
  strict protected
    class property Handle: THandle read FHandle;
    class property Broker: TRPCBroker read GetBroker;
    class property ConnectParams: string read GetConnectParams;
    class function LoadDll: Boolean;
    class procedure CloseDll(Handle: THandle);
  public
    class property DllName: string read GetDllName;
    class function ShowInstrument(InstrumentName, PatientDFN, OrderedBy,
      OrderedByDUZ, AdministeredBy, AdministeredByDUZ, Location,
      LocationIEN: string; Required: Boolean; var ProgressNote: string)
      : Boolean;
    class function SaveInstrument(InstrumentName, PatientDFN, OrderedByDUZ,
      AdministeredByDUZ, AdminDate, LocationIEN: string;
      var Status: string): Boolean;
    class function RemoveTempVistaFile(InstrumentName,
      PatientDFN: string): Boolean;
    class procedure UnloadDll;
    class function CheckForDll: Boolean;
    class property IsLoaded: Boolean read GetIsLoaded;
    class property Status: TDllStatus read FStatus; // Error code
    class property StatusMessage: string read FStatusMessage; // Error message
  end;

implementation

uses
  System.SysUtils,
  VAUtils,
  ORFn,
  ORNet,
  rCore;

class function TMHDll.GetDllName: string;
begin
  if FDllName = '' then FDllName := GetUserParam('YS MHA_A DLL NAME');
  Result := Trim(FDllName);
end;

class function TMHDll.GetIsLoaded: Boolean;
begin
  Result := Handle <> 0;
end;

class function TMHDll.GetBroker: TRPCBroker;
begin
  Result := ORNet.RPCBrokerV;
end;

class function TMHDll.GetConnectParams: string;
begin
  Result := Format('%s^%s^%d^%s', [Trpcb.GetAppHandle(Broker), Broker.Server,
    Broker.ListenerPort, Piece(Broker.User.Division, U, 3)]);
end;

class function TMHDll.LoadDll: Boolean;
// The result of the function indicates if the dll has been successfully loaded
begin
  FStatus := TDllStatus.OK;
  FStatusMessage := '';
  if IsLoaded then Exit(True);
  if DllName = '' then
  begin
    FStatus := TDllStatus.SetupError;
    FStatusMessage := 'The YS MHA_A DLL NAME parameter is not setup on this ' +
      'system. Please contact your IRM';
    Exit(False);
  end;

  //Load the dll
  var ADllRtnRec := rMisc.LoadDll(DllName, CloseDll);
  FHandle := ADllRtnRec.DLL_HWND;
  if Handle = 0 then
  begin
    case ADllRtnRec.Return_Type of
      DLL_VersionErr:
        begin
          FStatus := TDllStatus.VersionError;
          FStatusMessage := ADllRtnRec.Return_Message;
        end;
    else
      begin
        FStatus := TDllStatus.Missing;
        FStatusMessage := ADllRtnRec.Return_Message;
      end;
    end;
    Exit(False);
  end;

  FCloseDll := GetProcAddress(Handle, PAnsiChar('CloseDLL'));
  // Get pointers to the TokenBroker (Brokerless) calls
  FShowInstrument_TokenBroker := GetProcAddress(Handle,
    PAnsiChar('ShowInstrument_TokenBroker'));
  if Assigned(FShowInstrument_TokenBroker) then
  begin
    FSaveInstrument_TokenBroker := GetProcAddress(Handle,
      PAnsiChar('SaveInstrument_TokenBroker'));
    FRemoveTempVistaFile_TokenBroker :=
      GetProcAddress(Handle, PAnsiChar('RemoveTempVistaFile_TokenBroker'));
  end else begin
    // Get pointers to the regular Broker calls
    FShowInstrument := GetProcAddress(Handle, PAnsiChar('ShowInstrument'));
    FSaveInstrument := GetProcAddress(Handle, PAnsiChar('SaveInstrument'));
    FRemoveTempVistaFile := GetProcAddress(Handle,
      PAnsiChar('RemoveTempVistaFile'));
  end;
  Result := True;
end;

class procedure TMHDll.UnloadDll;
begin
  if IsLoaded then
  begin
    FreeLibrary(Handle);
    FHandle := 0;
    FCloseDll := nil;
    FShowInstrument_TokenBroker := nil;
    FSaveInstrument_TokenBroker := nil;
    FRemoveTempVistaFile_TokenBroker := nil;
    FShowInstrument := nil;
    FSaveInstrument := nil;
    FRemoveTempVistaFile := nil;
    FStatus := TDllStatus.OK;
    FStatusMessage := '';
  end;
end;

class function TMHDll.CheckForDll: Boolean;
begin
  Result := IsLoaded or (Trim(FindDllDir(DllName)) <> '');
end;

class function TMHDll.ShowInstrument(InstrumentName, PatientDFN, OrderedBy,
  OrderedByDUZ, AdministeredBy, AdministeredByDUZ, Location,
  LocationIEN: string; Required: Boolean; var ProgressNote: string): Boolean;
// The result of this function indicates if the dll call was succesful or not
// Additional information on failure will be in the Status property
var
  AProcBroker: procedure(RPCBrokerV: TRPCBroker;
    InstrumentName, PatientDFN, OrderedBy, OrderedByDUZ, AdministeredBy,
    AdministeredByDUZ, Location, LocationIEN: string; Required: Boolean;
    var ProgressNote: string); stdcall;
  AProcBrokerless: procedure(const AConnectParams: WideString;
    InstrumentName, PatientDFN, OrderedBy, OrderedByDUZ, AdministeredBy,
    AdministeredByDUZ, Location, LocationIEN: string; Required: Boolean;
    var ProgressNote: string); stdcall;
begin
  if not LoadDll then Exit(False);
  if Assigned(FShowInstrument_TokenBroker) then
  begin
    @AProcBrokerless := FShowInstrument_TokenBroker;
    AProcBrokerless(ConnectParams, InstrumentName, PatientDFN, OrderedBy,
      OrderedByDUZ, AdministeredBy, AdministeredByDUZ, Location, LocationIEN,
      Required, ProgressNote);
    Exit(True);
  end;
  if Assigned(FShowInstrument) then
  begin
    @AProcBroker := FShowInstrument;
    AProcBroker(Broker, InstrumentName, PatientDFN, OrderedBy, OrderedByDUZ,
      AdministeredBy, AdministeredByDUZ, Location, LocationIEN, Required,
      ProgressNote);
    Exit(True);
  end;
  FStatus := TDllStatus.FunctionMissing;
  FStatusMessage := Format('Can''t find function "ShowInstrument" within %s.',
    [DllName]);
  Exit(False);
end;

class function TMHDll.SaveInstrument(InstrumentName, PatientDFN, OrderedByDUZ,
  AdministeredByDUZ, AdminDate, LocationIEN: string;
  var Status: string): Boolean;
// The result of this function indicates if the dll call was succesful or not
// Additional information on failure will be in the Status property
var
  AProcBroker: procedure(RPCBrokerV: TRPCBroker;
    InstrumentName, PatientDFN, OrderedByDUZ, AdministeredByDUZ, AdminDate,
    LocationIEN: string; var Status: string); stdcall;
  AProcBrokerless: procedure(const AConnectParams: WideString;
    InstrumentName, PatientDFN, OrderedByDUZ, AdministeredByDUZ, AdminDate,
    LocationIEN: string; var Status: string); stdcall;
begin
  if not LoadDll then Exit(False);
  if Assigned(FSaveInstrument_TokenBroker) then
  begin
    @AProcBrokerless := FSaveInstrument_TokenBroker;
    AProcBrokerless(ConnectParams, InstrumentName, PatientDFN, OrderedByDUZ,
      AdministeredByDUZ, AdminDate, LocationIEN, Status);
    Exit(True);
  end;
  if Assigned(FSaveInstrument) then
  begin
    @AProcBroker := FSaveInstrument;
    AProcBroker(Broker, InstrumentName, PatientDFN, OrderedByDUZ,
      AdministeredByDUZ, AdminDate, LocationIEN, Status);
    Exit(True);
  end;
  FStatus := TDllStatus.FunctionMissing;
  FStatusMessage := Format('Can''t find function "SaveInstrument" within %s.',
    [DllName]);
  Exit(False);
end;

class function TMHDll.RemoveTempVistaFile(InstrumentName,
  PatientDFN: string): Boolean;
// The result of this function indicates if the dll call was succesful or not
// Additional information on failure will be in the Status property
var
  AProcBroker: procedure(RPCBrokerV: TRPCBroker;
    InstrumentName, PatientDFN: string); stdcall;
  AProcBrokerless: procedure(const AConnectParams: WideString;
    InstrumentName, PatientDFN: string); stdcall;
begin
  if not LoadDll then Exit(False);
  if Assigned(FRemoveTempVistaFile_TokenBroker) then
  begin
    @AProcBrokerless := FRemoveTempVistaFile_TokenBroker;
    AProcBrokerless(ConnectParams, InstrumentName, PatientDFN);
    Exit(True);
  end;
  if Assigned(FRemoveTempVistaFile) then
  begin
    @AProcBroker := FRemoveTempVistaFile;
    AProcBroker(Broker, InstrumentName, PatientDFN);
    Exit(True);
  end;
  FStatus := TDllStatus.FunctionMissing;
  FStatusMessage := Format('Remove Temp File function not found within %s.',
    [DllName]);
  Exit(False);
end;

class procedure TMHDll.CloseDll(Handle: THandle);
var
  ACloseProc: procedure;
begin
  if IsLoaded then
  begin
    @ACloseProc := FCloseDll;
    if Assigned(ACloseProc) then ACloseProc;
  end;
end;

end.
