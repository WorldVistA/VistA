{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Roy Gaber
  Description: Contains TRPCBroker and related components.
  Unit: RequestSecurityTokenSVC.pas, this unit is the result
  of importing the IAM WSDL.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ *************************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in v1.1.71 (RGG 02/07/2019) XWB*1.1*71
  1. Created this unit from the IAM WSDL via the WSDL importer

  *************************************************************** }


// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : https://domain.aaaaa.aaaa.ext:9301/STS/RequestSecurityToken?wsdl
// >Import : https://domain.aaaaa.aaaa.ext:9301/STS/RequestSecurityToken?wsdl>0
// Encoding : UTF-8
// Version  : 1.0
// (1/28/2019 10:49:03 AM - - $Rev: 86412 $)
// ************************************************************************ //

unit RequestSecurityTokenSVC;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

type

  RequestSecurityTokenType = class;
  { "http://docs.oasis-open.org/ws-sx/ws-trust/200512"[Lit][GblCplx] }
  RequestSecurityToken = class;
  { "http://docs.oasis-open.org/ws-sx/ws-trust/200512"[Lit][GblElm] }
  RequestSecurityTokenResponseType = class;
  { "http://docs.oasis-open.org/ws-sx/ws-trust/200512"[Lit][GblCplx] }
  RequestSecurityTokenResponse = class;
  { "http://docs.oasis-open.org/ws-sx/ws-trust/200512"[Lit][GblElm] }

  // ************************************************************************ //
  // XML       : RequestSecurityTokenType, global, <complexType>
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // Info      : Wrapper
  // ************************************************************************ //
  RequestSecurityTokenType = class(TRemotable)
  private
  published
  end;

  // ************************************************************************ //
  // XML       : RequestSecurityToken, global, <element>
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // Info      : Wrapper
  // ************************************************************************ //
  RequestSecurityToken = class(RequestSecurityTokenType)
  private
  published
  end;

  // ************************************************************************ //
  // XML       : RequestSecurityTokenResponseType, global, <complexType>
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // Info      : Wrapper
  // ************************************************************************ //
  RequestSecurityTokenResponseType = class(TRemotable)
  private
  published
  end;

  // ************************************************************************ //
  // XML       : RequestSecurityTokenResponse, global, <element>
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // Info      : Wrapper
  // ************************************************************************ //
  RequestSecurityTokenResponse = class(RequestSecurityTokenResponseType)
  private
  published
  end;

  // ************************************************************************ //
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // style     : ????
  // use       : ????
  // ************************************************************************ //
  WSSecurityRequestor = interface(IInvokable)
    ['{E6F20C11-2652-C135-9C13-754D85BCC1AC}']
    procedure SecurityTokenResponse(const response
      : RequestSecurityTokenResponse); stdcall;
    procedure SecurityTokenResponse2(const response
      : RequestSecurityTokenResponse); stdcall;
    procedure Challenge(var response: RequestSecurityTokenResponse); stdcall;
    procedure Challenge2(var response: RequestSecurityTokenResponse); stdcall;
  end;

  // ************************************************************************ //
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // style     : ????
  // use       : ????
  // ************************************************************************ //
  SecurityTokenRequestService = interface(IInvokable)
    ['{84E963F5-D121-A4B9-2CC6-421FD67E2BD4}']
    procedure RequestSecurityToken(const request
      : RequestSecurityToken); stdcall;
  end;

  // ************************************************************************ //
  // Namespace : http://docs.oasis-open.org/ws-sx/ws-trust/200512
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : RequestSecurityTokenPortBinding
  // service   : SecurityTokenService
  // port      : RequestSecurityToken
  // URL       : https://domain.aaaaaa.aaaaaaa.ext:9301/STS/RequestSecurityToken
  // ************************************************************************ //
  SecurityTokenService = interface(IInvokable)
    ['{1A87D2AC-73FC-BBCF-B7F7-2AF8B4086479}']
    procedure RequestSecurityToken; stdcall;
  end;

function GetSecurityTokenService(UseWSDL: Boolean = System.False;
  Addr: string = ''; HTTPRIO: THTTPRIO = nil): SecurityTokenService;

implementation

uses System.SysUtils;

function GetSecurityTokenService(UseWSDL: Boolean; Addr: string;
  HTTPRIO: THTTPRIO): SecurityTokenService;
const
  defWSDL = 'https://domain.aaaaa.aaaa.ext:9301/STS/RequestSecurityToken?wsdl';
  defURL = 'https://domain.aaaaaa.aaaaaaa.ext:9301/STS/RequestSecurityToken';
  defSvc = 'SecurityTokenService';
  defPrt = 'RequestSecurityToken';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as SecurityTokenService);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end
    else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;

initialization

{ WSSecurityRequestor }
InvRegistry.RegisterInterface(TypeInfo(WSSecurityRequestor),
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512', 'UTF-8');
InvRegistry.RegisterDefaultSOAPAction(TypeInfo(WSSecurityRequestor), '');
{ SecurityTokenRequestService }
InvRegistry.RegisterInterface(TypeInfo(SecurityTokenRequestService),
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512', 'UTF-8');
InvRegistry.RegisterDefaultSOAPAction
  (TypeInfo(SecurityTokenRequestService), '');
{ SecurityTokenService }
InvRegistry.RegisterInterface(TypeInfo(SecurityTokenService),
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512', 'UTF-8');
InvRegistry.RegisterDefaultSOAPAction(TypeInfo(SecurityTokenService), '');
InvRegistry.RegisterInvokeOptions(TypeInfo(SecurityTokenService), ioDocument);
RemClassRegistry.RegisterXSClass(RequestSecurityTokenType,
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512',
  'RequestSecurityTokenType');
RemClassRegistry.RegisterXSClass(RequestSecurityToken,
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512', 'RequestSecurityToken');
RemClassRegistry.RegisterXSClass(RequestSecurityTokenResponseType,
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512',
  'RequestSecurityTokenResponseType');
RemClassRegistry.RegisterXSClass(RequestSecurityTokenResponse,
  'http://docs.oasis-open.org/ws-sx/ws-trust/200512',
  'RequestSecurityTokenResponse');

end.
