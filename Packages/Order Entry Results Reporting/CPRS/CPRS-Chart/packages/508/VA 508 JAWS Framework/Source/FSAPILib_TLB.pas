unit FSAPILib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 5/11/2007 1:25:41 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Freedom Scientific\Shared\fsapi\1.0\FSAPI.dll (1)
// LIBID: {F152C4EF-B92F-4139-A901-E8F1E28CC8E0}
// LCID: 0
// Helpfile: 
// HelpString: FSAPI 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TJawsApi) : Server C:\Program Files\Freedom Scientific\Shared\fsapi\1.0\fsapi.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  FSAPILibMajorVersion = 1;
  FSAPILibMinorVersion = 0;

  LIBID_FSAPILib: TGUID = '{F152C4EF-B92F-4139-A901-E8F1E28CC8E0}';

  IID_IJawsApi: TGUID = '{123DEDB4-2CF6-429C-A2AB-CC809E5516CE}';
  CLASS_JawsApi: TGUID = '{CCE5B1E5-B2ED-45D5-B09F-8EC54B75ABF4}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IJawsApi = interface;
  IJawsApiDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  JawsApi = IJawsApi;


// *********************************************************************//
// Interface: IJawsApi
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {123DEDB4-2CF6-429C-A2AB-CC809E5516CE}
// *********************************************************************//
  IJawsApi = interface(IDispatch)
    ['{123DEDB4-2CF6-429C-A2AB-CC809E5516CE}']
    function RunScript(const ScriptName: WideString): WordBool; safecall;
    function SayString(const StringToSpeak: WideString; bFlush: WordBool): WordBool; safecall;
    procedure StopSpeech; safecall;
    function Enable(vbNoDDIHooks: WordBool): WordBool; safecall;
    function Disable: WordBool; safecall;
    function RunFunction(const FunctionName: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IJawsApiDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {123DEDB4-2CF6-429C-A2AB-CC809E5516CE}
// *********************************************************************//
  IJawsApiDisp = dispinterface
    ['{123DEDB4-2CF6-429C-A2AB-CC809E5516CE}']
    function RunScript(const ScriptName: WideString): WordBool; dispid 1;
    function SayString(const StringToSpeak: WideString; bFlush: WordBool): WordBool; dispid 2;
    procedure StopSpeech; dispid 3;
    function Enable(vbNoDDIHooks: WordBool): WordBool; dispid 4;
    function Disable: WordBool; dispid 5;
    function RunFunction(const FunctionName: WideString): WordBool; dispid 6;
  end;

// *********************************************************************//
// The Class CoJawsApi provides a Create and CreateRemote method to          
// create instances of the default interface IJawsApi exposed by              
// the CoClass JawsApi. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoJawsApi = class
    class function Create: IJawsApi;
    class function CreateRemote(const MachineName: string): IJawsApi;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TJawsApi
// Help String      : JawsApi Class
// Default Interface: IJawsApi
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TJawsApiProperties= class;
{$ENDIF}
  TJawsApi = class(TOleServer)
  private
    FIntf: IJawsApi;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TJawsApiProperties;
    function GetServerProperties: TJawsApiProperties;
{$ENDIF}
    function GetDefaultInterface: IJawsApi;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IJawsApi);
    procedure Disconnect; override;
    function RunScript(const ScriptName: WideString): WordBool;
    function SayString(const StringToSpeak: WideString; bFlush: WordBool): WordBool;
    procedure StopSpeech;
    function Enable(vbNoDDIHooks: WordBool): WordBool;
    function Disable: WordBool;
    function RunFunction(const FunctionName: WideString): WordBool;
    property DefaultInterface: IJawsApi read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TJawsApiProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TJawsApi
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TJawsApiProperties = class(TPersistent)
  private
    FServer:    TJawsApi;
    function    GetDefaultInterface: IJawsApi;
    constructor Create(AServer: TJawsApi);
  protected
  public
    property DefaultInterface: IJawsApi read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'VA 508';

  dtlOcxPage = 'VA 508';

implementation

uses ComObj;

class function CoJawsApi.Create: IJawsApi;
begin
  Result := CreateComObject(CLASS_JawsApi) as IJawsApi;
end;

class function CoJawsApi.CreateRemote(const MachineName: string): IJawsApi;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_JawsApi) as IJawsApi;
end;

procedure TJawsApi.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CCE5B1E5-B2ED-45D5-B09F-8EC54B75ABF4}';
    IntfIID:   '{123DEDB4-2CF6-429C-A2AB-CC809E5516CE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TJawsApi.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IJawsApi;
  end;
end;

procedure TJawsApi.ConnectTo(svrIntf: IJawsApi);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TJawsApi.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TJawsApi.GetDefaultInterface: IJawsApi;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TJawsApi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TJawsApiProperties.Create(Self);
{$ENDIF}
end;

destructor TJawsApi.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TJawsApi.GetServerProperties: TJawsApiProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TJawsApi.RunScript(const ScriptName: WideString): WordBool;
begin
  Result := DefaultInterface.RunScript(ScriptName);
end;

function TJawsApi.SayString(const StringToSpeak: WideString; bFlush: WordBool): WordBool;
begin
  Result := DefaultInterface.SayString(StringToSpeak, bFlush);
end;

procedure TJawsApi.StopSpeech;
begin
  DefaultInterface.StopSpeech;
end;

function TJawsApi.Enable(vbNoDDIHooks: WordBool): WordBool;
begin
  Result := DefaultInterface.Enable(vbNoDDIHooks);
end;

function TJawsApi.Disable: WordBool;
begin
  Result := DefaultInterface.Disable;
end;

function TJawsApi.RunFunction(const FunctionName: WideString): WordBool;
begin
  Result := DefaultInterface.RunFunction(FunctionName);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TJawsApiProperties.Create(AServer: TJawsApi);
begin
  inherited Create;
  FServer := AServer;
end;

function TJawsApiProperties.GetDefaultInterface: IJawsApi;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TJawsApi]);
end;

end.
