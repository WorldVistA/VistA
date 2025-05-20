{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Herlan Westra, Roy Gaber
  Description: Contains the TXWBSSOiToken component.
  Unit: XWBSSOi contains a simple TWebBrowser to 'POST' a SOAP
  message to IAM to obtain a SAML token.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ *************************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in v1.1.71 (RGG 02/07/2019) XWB*1.1*71
  1. Re-factored the internals of securing the STS token from
  IAM. Converted from TWebBrowser to THTTPRIO and TXMLDocument.
  2. Added certificate processing, this ensures that only
  valid certificates for the logged-in user are presented for
  selection and subsequent use in obtaining a SAML token from
  the IAM server.
  3. Added a new unit (RequestSecurityTokenSVC.pas) to the Broker
  Runtime to facilitate connections to and receiving tokens from
  the IAM STS server, it is the WSDL import from the IAM server.
  4. Added a new function (GetUserNameExString) to get the logged
  in user's last name, to be used in certificate selection
  5. Added RIOSERVICE and RIOPORT to GetSTSServer function, this
  was done to support SOAP calls to the IAM server, they represent
  the RIO (Remote Interfaced Object) values required by the IAM
  service.
  6. Added fallback to Active Directory (AD) credentials vs.
  Access/Verify codes for VistA login.  In the event the Active
  Directory credential input is avoided the fallback will go to
  Access/Verify codes.  The VHA request for AD fallback stems from
  lost or stolen PIV cards, users forgetting their PIN, etc.  If
  the user logs onto the workstation with their AD credentials they
  will be prompted with a new dialog asking if they want to use PIV
  or AD to login to VistA systems via an RPC Broker enabled app. If
  the user logs on to the workstation with their PIV card, the login
  process remains the same as in the previous version of the BDK (p65)
  7. Added a new unit, XWBLoginForm.pas.  This dialog prompts the
  user to select the mode of logon into VistA, they can choose from
  PIV login, Active Directory login, or cancel in which case Access
  and Verify codes are used.
  8. Changed Current Release to Version 1.1 Patch 71.
  ************************************************************ }

{ **************************************************
  Changes in v1.1.65 (HGW 11/22/2016) XWB*1.1*65
  1. Created unit XWBSSOi to exchange PIV Card credentials for a Secure Token
  Service (STS) token to be used for user authentication and identification.
  2. New class TXWBSSOiToken
  3. New properties SSOiToken, SSOiSECID, SSOiADUPN, SSOiLogonName
  ************************************************** }
unit XWBSSOi;

{
  Copyright 2016 Department of Veterans Affairs

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

{
  You�ve got a client on a VA deployed Microsoft Windows workstation that is
  part of the VA forest and you want to obtain a SAML token from the IAM STS
  service.  Submit a SOAP request token message using mutual TLS, where
  the client certificate identifies the user making the request.

  //  Since VA workstation security blocks most API attempts to 'POST' data to
  //  a web site where you are not already authenticated, the choices of a
  //  working API are limited. The use within this unit of the ActiveX
  //  TWebBrowser (stripped down Internet Explorer) represents the only known
  //  working method of sending an https 'POST' to a web site using standard
  //  Windows APIs and TLS mutual authentication (PIV card) after the data is
  //  sent.
}

interface

{$I IISBase.inc}

uses
  {Winapi}
  Winapi.Messages,
  Winapi.Windows,
  {System}
  System.Classes,
  System.SysUtils,
  System.Variants,
  System.StrUtils,
  System.Win.Registry,
  System.DateUtils,
  System.UITypes,
  {Vcl}
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.OleCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  {VA}
  MFunStr,
  XWBut1,
  XWBLoginForm,
  {SOAP and XML}
  Soap.InvokeRegistry,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Soap.Rio,
  Soap.SOAPHTTPClient,
  Soap.SOAPHTTPTrans,
  {IAM Interface}
  RequestSecurityTokenSVC,
  IAMConstants,
  {Certificate processing}
  // OverbyteIcsCryptuiApi,
  // OverbyteIcsWinCrypt,
  Wcrypt2,
  WinInet,
  Xml.Win.msxmldom,
  System.Net.URLClient,
  System.Net.HttpClient;
type
  { ------ TXWBSSOiToken ------ }
  { This component defines and obtains the STS SAML token used to authenticate
    and identify the user }
  TXWBSSOiToken = class(TComponent)
  private
    FSSOiTokenValue: String;
    FSSOiADUPNValue: String;
    FSSOiLogonNameValue: String;
    FSSOiSECIDValue: String;
    procedure FSSOiToken(Value: String);
    procedure FSSOiADUPN(Value: String);
    procedure FSSOiLogonName(Value: String);
    procedure FSSOiSECID(Value: String);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property SSOiToken: String read FSSOiTokenValue write FSSOiToken;
    property SSOiADUPN: String read FSSOiADUPNValue write FSSOiADUPN;
    property SSOiLogonName: String read FSSOiLogonNameValue
      write FSSOiLogonName;
    property SSOiSECID: String read FSSOiSECIDValue write FSSOiSECID;
  end;

  TXWBSSOiFrm = class(TForm)
    Label1: TLabel;
    tokenMemo: TMemo; // p71
    XMLDoc: TXMLDocument; // p71
    httpRio2: THTTPRIO; // p71
    function CreatePost(S: String): OleVariant;
    function GetLocalComputerName: String;
    function GetSTSServer: String;
    function GetMyToken: String;
    function GetADToken: String; // p71
    function GetLogonInfo: String; // p71
    function LogonAD: String; // p71
    function GenerateTimestamp: String; // p71
    function GenerateStampId(stampType: String): String; // p71
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure httpRio1BeforeExecute(const MethodName: string;
      SOAPRequest: TStream); // p71
    procedure httpRio1AfterExecute(const MethodName: string; // p71
      SOAPResponse: TStream);
    //function GetUserNameExString(ANameFormat: DWORD): string; // p71
    procedure httpRio2BeforeExecute(const MethodName: string; // p71
      SOAPRequest: TStream);
    procedure httpRio2AfterExecute(const MethodName: string; // p71
      SOAPResponse: TStream);
{$IF CompilerVersion < 33.0}
    procedure httpRio1HTTPWebNode1BeforePost(const HTTPReqResp: THTTPReqResp;
      Data: Pointer); // p71
    function httpRio1HTTPWebNode1WinInetError(LastError: Cardinal;
      Request: Pointer): Cardinal; // p71
{$ELSE}
    procedure httpRio1HTTPWebNode1BeforePost(const HTTPReqResp: THTTPReqResp;
      Client: THTTPClient); // p71
    procedure httpRio1HTTPWebNode1NeedClientCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const ACertificateList: TCertificateList;
      var AnIndex: Integer); // p71
{$ENDIF}
    { Private declarations }
  public
    { Public declarations }
    lCertContext: PCCERT_CONTEXT; // p71
    UserName, Password: String; // p71
    httpRio1: THTTPRIO; // p71
  end;
var  ShowCertDialog: boolean;

const
  NameUnknown = 0; // Unknown name type.
  NameFullyQualifiedDN = 1; // Fully qualified distinguished name
  NameSamCompatible = 2; // Windows NT� 4.0 account name
  NameDisplay = 3; // A "friendly" display name
  NameUniqueId = 6; // GUID string that the IIDFromString function returns
  NameCanonical = 7; // Complete canonical name
  NameUserPrincipal = 8; // User principal name
  NameCanonicalEx = 9;
  NameServicePrincipal = 10; // Generalized service principal name
  DNSDomainName = 11; // DNS domain name, plus the user name

var
  XWBSSOiFrm: TXWBSSOiFrm;
  myToken, lType: String;

  { added CryptUIDlgSelectCertificateFromStore to avoind 3rd party components }
{$EXTERNALSYM CryptUIDlgSelectCertificateFromStore}
function CryptUIDlgSelectCertificateFromStore(hCertStore: hCertStore;
  hwnd: hwnd; pwszTitle: LPCWSTR; pwszDisplayString: LPCWSTR;
  dwDontUseColumn: DWORD; dwFlags: DWORD; pvReserved: Pointer)
  : PCCERT_CONTEXT; stdcall;

const
  { flags for dwDontUseColumn }
  CRYPTUI_SELECT_ISSUEDTO_COLUMN = $000000001;
  CRYPTUI_SELECT_ISSUEDBY_COLUMN = $000000002;
  CRYPTUI_SELECT_INTENDEDUSE_COLUMN = $000000004;
  CRYPTUI_SELECT_FRIENDLYNAME_COLUMN = $000000008;
  CRYPTUI_SELECT_LOCATION_COLUMN = $000000010;
  CRYPTUI_SELECT_EXPIRATION_COLUMN = $000000020;

  // types used by CryptUIDlgSelectCertificateFromStore
type
  TFNCFILTERPROC = function(pCertContext: PCCERT_CONTEXT;
    pfInitialSelectedCert: PBool; pvCallbackData: Pointer): BOOL;

implementation

{$R *.dfm}
{ ID the CryptUIDlgSelectCertificateFromStore function for use later in
  the application }

function CryptUIDlgSelectCertificateFromStore;
  external 'cryptui.dll' name 'CryptUIDlgSelectCertificateFromStore';

{ --------------------- TXWBSSOiToken.Create ----------------------
  This constructor creates and obtains a SSOiToken, and sets the value
  of the FSSOiTokenValue property to the token. It also sets the
  remaining property values. When the TXWBSSOiToken component is placed
  on a form, this will run automatically when the form is created.
  ------------------------------------------------------------------ }
constructor TXWBSSOiToken.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSSOiToken('');
  FSSOiADUPN('');
  FSSOiLogonName('');
  FSSOiSECID('');
  myToken := '';
end;
// constructor TXWBSSOiToken.Create

{ --------------------- TXWBSSOiToken.Destroy ---------------------
  This destructor removes an SSOiToken.
  --------------------------------------------------------------- }
destructor TXWBSSOiToken.Destroy;
begin
  FSSOiTokenValue := '';
  inherited Destroy;
end;
// destructor TXWBSSOiToken.Destroy

{ ------------------------- TXWBSSOiToken.FSSOiToken --------------
  This procedure looks at FSSOiTokenValue, and if null then it does
  a SOAP request to the STS server for a new token.
  ------------------------------------------------------------------ }
procedure TXWBSSOiToken.FSSOiToken(Value: String);
begin
  if (FSSOiTokenValue = '') then
  begin
    try
      XWBSSOiFrm := TXWBSSOiFrm.Create(Application);
    finally
      FSSOiTokenValue := myToken;
      XWBSSOiFrm.Free;
    end;
  end;
end;
// procedure TXWBSSOiToken.FSSOiToken

{ ------------------------- TXWBSSOiToken.FSSOiADUPN --------------
  Returns the ADUPN assigned to the user by Identity and Access
  Management by examining the SAML token. If there is no token
  stored, returns null.
  ------------------------------------------------------------------ }
procedure TXWBSSOiToken.FSSOiADUPN(Value: String);
var
  myAdUpn: String;
  delimiter: String;
begin
  myAdUpn := '';
  if (FSSOiTokenValue <> '') then
  begin
    delimiter := '<saml:Attribute Name="upn"';
    myAdUpn := Piece(FSSOiTokenValue, delimiter, 2);
    delimiter := '</saml:AttributeValue>';
    myAdUpn := Piece(myAdUpn, delimiter, 1);
    delimiter := '<saml:AttributeValue>';
    myAdUpn := Piece(myAdUpn, delimiter, 2);
  end;
  FSSOiADUPNValue := myAdUpn;
end;
// procedure TXWBSSOiToken.FSSOiADUPN

{ ------------------------- TXWBSSOiToken.FSSOiLogonName ----------
  Returns the SECID assigned to the user by Identity and Access
  Management by examining the SAML token. If there is no token
  stored, returns null.
  ------------------------------------------------------------------ }
procedure TXWBSSOiToken.FSSOiLogonName(Value: String);
var
  myUserName: String;
  delimiter: String;
begin
  myUserName := '';
  if (FSSOiTokenValue <> '') then
  begin
    delimiter := 'urn:oasis:names:tc:xspa:1.0:subject:subject-id';
    myUserName := Piece(FSSOiTokenValue, delimiter, 2);
    delimiter := '</saml:AttributeValue>';
    myUserName := Piece(myUserName, delimiter, 1);
    delimiter := '<saml:AttributeValue>';
    myUserName := Piece(myUserName, delimiter, 2);
  end;
  FSSOiLogonNameValue := myUserName;
end;
// procedure TXWBSSOiToken.FSSOiLogonName

{ ------------------------- TXWBSSOiToken.FSSOiSECID --------------
  Returns the SECID assigned to the user by Identity and Access
  Management by examining the SAML token. If there is no token
  stored, returns null.
  ------------------------------------------------------------------ }
procedure TXWBSSOiToken.FSSOiSECID(Value: String);
var
  mySecID: String;
  delimiter: String;
begin
  mySecID := '';
  if (FSSOiTokenValue <> '') then
  begin
    delimiter := 'urn:va:vrm:iam:secid';
    mySecID := Piece(FSSOiTokenValue, delimiter, 2);
    delimiter := '</saml:AttributeValue>';
    mySecID := Piece(mySecID, delimiter, 1);
    delimiter := '<saml:AttributeValue>';
    mySecID := Piece(mySecID, delimiter, 2);
  end;
  FSSOiSECIDValue := mySecID;
end;
// procedure TXWBSSOiToken.FSSOiSECID

{ --------------------- TXWBSSOiFrm.GetMyToken --------------------
  This function was refactored to use SOAP components, all of the
  TWebBrowser references have been removed, the XML returned from
  the call to IAM was being formatted by the component.  This
  functions' purpose  is to make the call to the STS server, request
  a token and grab the token out of the tokenMemo, which was placed
  there by the TXWBSSOiFrm.httpRio1AfterExecute procedure. It also
  gets the proper certificates for the currently logged in user for
  presentation in the Windows certificate selection dialog.

  A request was made by Health Information Governance to have Active
  Directory used as a fallback machanism for logging into VistA vs.
  Access/Verify codes.  Logic was added here to address that.
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GetMyToken: String; // p71
var
  //CurrentUser,
  NameString, STSServerInfo, STSServer, RIOSERVER,
  RIOPORT: String;
  IAMRequest: SecurityTokenService;
  Store: hCertStore;
  SelectedCert: PCCERT_CONTEXT;
  ValidCert: PCCERT_CONTEXT;
  MemoryStore: hCertStore;
  CertContext: PCCERT_CONTEXT;
  Size: DWORD;
  KeyUsageBits: Byte;
  CertInfo: PCERT_INFO;
  ValidDate: DWORD;
  begin
  Store := CertOpenSystemStore(0, 'MY');
  MemoryStore := CertOpenStore(CERT_STORE_PROV_MEMORY, 0, 0, 0, nil);
  SelectedCert := nil;
  try
    CertContext := CertEnumCertificatesInStore(Store, nil);
    while CertContext <> nil do
    begin
      ValidCert := CertFindCertificateInStore(Store, X509_ASN_ENCODING or
        PKCS_7_ASN_ENCODING, 0, CERT_FIND_ANY, nil, nil);
      if (ValidCert <> nil) then
      begin
        NameString := '';
        Size := 0;
        {Size := CertGetNameString(CertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0,
          0, PWideChar(SimpleNameString), Size);
        SetLength(SimpleNameString, Size);
        CertGetNameString(CertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0,
          PWideChar(SimpleNameString), Size);}
		//Chris' Change Starts Here
        Size := CertGetNameString(CertContext, CERT_NAME_FRIENDLY_DISPLAY_TYPE, 0,
          0, PWideChar(NameString), Size);
        SetLength(NameString, Size);
        CertGetNameString(CertContext, CERT_NAME_FRIENDLY_DISPLAY_TYPE, 0, 0,
          PWideChar(NameString), Size);
		//Chris' Change Ends Here
          CertInfo := CertContext.pCertInfo;
        CertGetIntendedKeyUsage(X509_ASN_ENCODING or
          PKCS_7_ASN_ENCODING, CertInfo, @KeyUsageBits, 1);
          ValidDate := CertVerifyTimeValidity(nil, CertInfo);
          {if((KeyUsageBits and CERT_DIGITAL_SIGNATURE_KEY_USAGE)=CERT_DIGITAL_SIGNATURE_KEY_USAGE) and
          (ValidDate = 0) and (not ContainsText(NameString, 'people')) then}
          //Chris' Change Starts Here
//		  if((KeyUsageBits and CERT_DIGITAL_SIGNATURE_KEY_USAGE)=CERT_DIGITAL_SIGNATURE_KEY_USAGE) and
//          (ValidDate = 0) and (ContainsText(NameString, 'Authentication - ')) then
		          if((KeyUsageBits and CERT_DIGITAL_SIGNATURE_KEY_USAGE)=CERT_DIGITAL_SIGNATURE_KEY_USAGE) and
                (ValidDate = 0) and (not ContainsText(NameString, 'Card Authentication')) and
                  (not ContainsText(NameString, '0,')) and
                    (not ContainsText(NameString, 'Signature'))
              then
          //Chris' Change Ends Here
            begin
              CertAddCertificateContextToStore(MemoryStore, CertContext,
                CERT_STORE_ADD_ALWAYS, ValidCert);
              SelectedCert := ValidCert;
            end
            else
		          if((KeyUsageBits and CERT_DIGITAL_SIGNATURE_KEY_USAGE)=CERT_DIGITAL_SIGNATURE_KEY_USAGE) and
                (ValidDate = 0) and (not ContainsText(NameString, 'Card Authentication')) and
                  (not ContainsText(NameString, '0,')) and
                    (not ContainsText(NameString, 'Signature'))
              then
                  CertAddCertificateContextToStore(MemoryStore, CertContext,
                    CERT_STORE_ADD_ALWAYS, ValidCert);
      end;
      CertContext := CertEnumCertificatesInStore(Store, CertContext);
    end;
  finally
    CertCloseStore(Store, 0);
  end;

  if ShowCertDialog = true then
    begin
    SelectedCert := CryptUIDlgSelectCertificateFromStore(MemoryStore, 0,
    'VistA Logon - Certificate Selection',
    'Select a certificate for VistA authentication', 0, 0, nil);
    end;

  if MemoryStore <> nil then
    CertCloseStore(MemoryStore, 0);
  tokenMemo.Clear;
  if (SelectedCert <> nil) then
    lCertContext := SelectedCert;
  STSServerInfo := GetSTSServer;
  STSServer := Piece(STSServerInfo, '^', 1);
  RIOSERVER := Piece(STSServerInfo, '^', 2);
  RIOPORT := Piece(STSServerInfo, '^', 3);
  httpRio1.Service := RIOSERVER;
  httpRio1.Port := RIOPORT;
  IAMRequest := GetSecurityTokenService(False, STSServer, httpRio1);
  if lCertContext <> nil then
    try
      IAMRequest.RequestSecurityToken;
    except
      exit;

    end;
  myToken := tokenMemo.Lines.Text;
  Result := myToken;
end;
// function TXWBSSOiFrm.GetMyToken

{ ----------------- TXWBSSOiFrm.LogonAD ------------------------
  This function will secure a token from the IAM server using Active
  Directory username/password, it is used in lieu of PIV login as
  a fallback mechanism in the event a user forgets their PIV PIN
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.LogonAD: String; // p71
var
  IAMRequest: SecurityTokenService;
  STSServerInfo, STSServer, RIOSERVER, RIOPORT: string;
begin
  tokenMemo.Clear;
  STSServerInfo := GetSTSServer;
  STSServer := Piece(STSServerInfo, '^', 1);
  RIOSERVER := Piece(STSServerInfo, '^', 2);
  RIOPORT := Piece(STSServerInfo, '^', 3);
  httpRio2.Service := RIOSERVER;
  httpRio2.Port := RIOPORT;
  IAMRequest := GetSecurityTokenService(False, STSServer, httpRio2);
  try
    IAMRequest.RequestSecurityToken;
  except
    exit;
  end;
end;
// function TXWBSSOiFrm.LogonAD

{ --------------------- TXWBSSOiFrm.FormCreate --------------------
  This procedure instantiates an XWBSSOiFrm form, gets the user's
  mode of logon to the workstation and branches to getting a SAML
  token from IAM based on logon method.
  ------------------------------------------------------------------ }
procedure TXWBSSOiFrm.FormCreate(Sender: TObject);
var
  LogonAttempts: Integer;
  AppTitle: string;
  SessionName: string;
begin
  httpRio1 := THTTPRIO.Create(self);
{$IF CompilerVersion < 33}                                          // p71
  httpRio1.HTTPWebNode.OnBeforePost := httpRio1HTTPWebNode1BeforePost;
  httpRio1.OnAfterExecute := httpRio1AfterExecute; // p71
  httpRio1.OnBeforeExecute := httpRio1BeforeExecute; // p71
  httpRio1.HTTPWebNode.OnWinInetError := httpRio1HTTPWebNode1WinInetError;
{$ENDIF}
{$IF CompilerVersion >= 33}
  httpRio1.OnAfterExecute := httpRio1AfterExecute; // p71
  httpRio1.OnBeforeExecute := httpRio1BeforeExecute; // p71
  httpRio1.HTTPWebNode.OnNeedClientCertificate := // p71
    httpRio1HTTPWebNode1NeedClientCertificate;
{$ENDIF}
  AppTitle := Application.Title;
  Application.Title := 'VistA 2FA Login';
  try
  myToken := '';
  WindowState := wsNormal;
  LogonAttempts := 0;
  // Token seems to be truncated if this is run minimized
  //lType := GetLogonInfo();
  //check if session is Citrix, if so default to PIV
  SessionName := GetEnvironmentVariable('SESSIONNAME');
  if SessionName <> 'Console'
    then lType := 'lTypePIV'
  else lType := GetLogonInfo();
  //end Citrix mod
  if lType = 'lTypeAD' then
  begin
    GetADToken();
    if ContainsText(myToken, 'FAIL') then
    begin
      repeat
        MessageDlg('Logon failure!' + #10#13#10#13 + 'You have ' +
          IntToStr(2 - LogonAttempts) + ' attempts remaining', mtWarning,
          [mbOk], 0);
        LogonAttempts := LogonAttempts + 1;
        GetADToken();
      until (LogonAttempts = 2) or (not ContainsText(myToken, 'FAIL')) or
        (lType = 'lTypeCancel') or (lType = 'lTypePIV');
    end;
  end;
  if lType = 'lTypePIV' then
  begin
    myToken := GetMyToken();
    exit;
  end;
  Finally
    Application.Title := AppTitle;
  end;
end;
// procedure TXWBSSOiFrm.FormCreate

{ ------------------ TXWBSSOiFrm.GetLogonInfo ------------------------
  This function returns what method the user used to logon to the
  workstation
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GetLogonInfo: String; // p71
const
  pProvider7 = PasswordProvider_WIN7;
  pProvider10 = PasswordProvider_WIN10;
  llProvider = LastLoggedOnProvider;
var
  Registry: TRegistry;
  KeyName: String;
begin
  // Check if user logged into Windows with Active Directory credentials
  Registry := TRegistry.Create(KEY_READ OR KEY_WOW64_64KEY);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKeyReadOnly
      ('SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI');
    KeyName := Registry.GetDataAsString(llProvider, False);
  finally
    Registry.Free;
  end;
  if (KeyName = pProvider7) or (KeyName = UpperCase(pProvider7)) or
    (KeyName = pProvider10) or (KeyName = UpperCase(pProvider10)) then
    Result := 'lTypeAD'
  else
    Result := 'lTypePIV';
end;
// function TXWBSSOiFrm.GetLogonInfo

{ ----------------- TXWBSSOiFrm.GetADToken ------------------------
  This function gets the currently logged in user's mode of logon
  to Windows, it determines whether to prompt for Active Directory
  credentials or use PIV login with certificates from PIV card.
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GetADToken: String; // p71
var
  LoginTypeForm: TXWBLoginForm;
begin
  LoginTypeForm := TXWBLoginForm.Create(Application);
  LoginTypeForm.ShowModal;
  if LoginTypeForm.CloseResult = 'Cancel' then
  begin
    lType := 'lTypeCancel';
    exit;
  end;
  if LoginTypeForm.CloseResult = 'PIVLogin' then
  begin
    lType := 'lTypePIV';
    exit;
  end;
  if (LoginTypeForm.UserName <> '') and (LoginTypeForm.Password <> '') then
  begin
    UserName := '';
    Password := '';
    UserName := LoginTypeForm.UserName;
    Password := LoginTypeForm.Password;
    LoginTypeForm.Free;
    LogonAD();
  end;
end;
// function TXWBSSOiFrm.GetLogonType

{ ----------------- TXWBSSOiFrm.GetUserNameExString ----------------
  This function gets the currently logged in user's last name for
  use in certificate selection.
  ------------------------------------------------------------------ }
//function TXWBSSOiFrm.GetUserNameExString(ANameFormat: DWORD): string; // p71
//var
//  Buffer: array [0 .. 128] of Char;
//  BufSize: DWORD;
//  DllHandle: HMODULE;
//  Position: Integer;
//  NameString: string;
//  GetUserNameEx: function(NameFormat: DWORD; lpNameBuffer: LPSTR;
//    var nSize: ULONG): BOOL; stdcall;
//begin
//  Result := '';
//  BufSize := SizeOf(Buffer) div SizeOf(Buffer[0]);
//  DllHandle := LoadLibrary('secur32.dll');
//  GetUserNameEx := GetProcAddress(GetModuleHandle('secur32.dll'),
//    'GetUserNameExW');
//  if Assigned(GetUserNameEx) then
//    if GetUserNameEx(ANameFormat, @Buffer[0], BufSize) then
//    begin
//      Position := ansipos(',', Buffer);
//      NameString := copy(Buffer, 0, Position - 1);
//      FreeLibrary(DllHandle);
//    end;
//  Result := NameString;
//end;
// function TXWBSSOiFrm.GetUserNameExString

{$IF CompilerVersion < 33.0}

{ ----------- TXWBSSOiFrm.httpRio1HTTPWebNode1BeforePost -----------
  This procedure sets the client certificate for the HTTPRIO object
  to the user-selected certificate, if no certificate is selected
  the procedure exists
  ------------------------------------------------------------------ }
procedure TXWBSSOiFrm.httpRio1HTTPWebNode1BeforePost(const HTTPReqResp
  : THTTPReqResp; Data: Pointer); // p71
begin
  if (lCertContext <> nil) then
    if not InternetSetOptionA(Data, INTERNET_OPTION_CLIENT_CERT_CONTEXT,
      lCertContext, SizeOf(CERT_CONTEXT)) then
      RaiseLastOSError
    else
      exit;
end;
// procedure TXWBSSOiFrm.httpRio1HTTPWebNode1BeforePost
{$ELSE}

procedure TXWBSSOiFrm.httpRio1HTTPWebNode1BeforePost(const HTTPReqResp
  : THTTPReqResp; Client: THTTPClient);
begin
  exit;
end;
{$ENDIF}
{$IF CompilerVersion >= 33.0}
{ ----------- TXWBSSOiFrm.httpRio1HTTPWebNode1NeedClientCertificate -----------
  If Delphi version is 10.3.x, this procedure sets the client certificate for
  the HTTPRIO object,it compares the serial number of the user selected cert
  against the list of certificates presented in ACertificateList.
  --------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------
  function ChangeHexEndianness(const AStr: string): String;
  This function was taken out of System.Net.HttpClient.Win because it is not
  callable via the unit.  Version 10.4.1 changed the way certificate serial
  numbers are rendered, in the past they were rendered as is, now in 10.4.1
  they are rendered by changing the endianness of the data, thereby causing
  exisiting checks on SerialNum to no longer function.  Incorporating this
  function here alleviates that issue.
  --------------------------------------------------------------------------- }

//patch xwb*1.1*72 added this function
function ChangeHexEndianness(const AStr: string): String;
var
  i: Integer;
  l: Integer;
  LRight: PChar;
  LLeft: PChar;
  c: Char;
begin
  i := 1;
  Result := AStr;
  l := (Length(Result) div 2) and not 1;
  LRight := PChar(Result) + Length(Result) - 2;
  LLeft := PChar(Result);
  while i <= l do
  begin
    c := LRight^;
    LRight^ := LLeft^;
    LLeft^ := c;

    c := (LRight + 1)^;
    (LRight + 1)^ := (LLeft + 1)^;
    (LLeft + 1)^ := c;

    Inc(i, 2);
    Inc(LLeft, 2);
    Dec(LRight, 2);
  end;
end;
//patch xwb*1.1*72 end of added function

procedure TXWBSSOiFrm.httpRio1HTTPWebNode1NeedClientCertificate
  (const Sender: TObject; const ARequest: TURLRequest;
  const ACertificateList: TCertificateList; var AnIndex: Integer);
var
   i : Integer;
   SerialNumber: String;
begin
  SetLength(SerialNumber, lCertContext.pCertInfo.SerialNumber.cbData * 2);
  BinToHex(lCertContext.pCertInfo.SerialNumber.pbData, PChar(SerialNumber),
    lCertContext.pCertInfo.SerialNumber.cbData);
{$IF CompilerVersion >= 34.0}
  SerialNumber := ChangeHexEndianness(SerialNumber);
{$ENDIF}
  try
    for i := 0 to ACertificateList.Count - 1 do
      if String(SerialNumber) = ACertificateList[i].SerialNum then
        AnIndex := i;
  except
    RaiseLastOSError;
  end;
end;
// procedure TXWBSSOiFrm.httpRio1HTTPWebNode1NeedClientCertificate
{$ENDIF}
{$IF CompilerVersion < 33.0}

{ ------------ TXWBSSOiFrm.httpRio1HTTPWebNode1WinInetError -----------
  This function exists to catch WinInet errors related to SOAP
  message processing, its sole purpose is to return a 0 result
  which allows fallback to access/verify codes in the event the
  user decides to canel PIN input.
  --------------------- --------------------------------------------- }
function TXWBSSOiFrm.httpRio1HTTPWebNode1WinInetError(LastError: Cardinal;
  Request: Pointer): Cardinal;
begin
  Result := 0;
  exit;
end;
// function TXWBSSOiFrm.httpRio1HTTPWebNode1WinInetError
{$ENDIF}

{ --------------------- TXWBSSOiFrm.CreatePost --------------------
  This function converts a string value into an OleVariant value,
  which is the required format for data sent in a TWebBrowser 'POST'.
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.CreatePost(S: String): OleVariant; // p71
var
  Temp: OleVariant;
  i: Integer;
begin
  // The post must be an array, but without null terminator (-1)
  Temp := VarArrayCreate([0, Length(S) - 1], varByte);
  // Put post in array
  for i := 1 to Length(S) do
    Temp[i - 1] := Ord(S[i]);
  Result := Temp;
end;
// function TXWBSSOiFrm.CreatePost

{ --------------------- TXWBSSOiFrm.FormClose ---------------------
  This procedure runs when XWBSSOiFrm Form is closed.
  ------------------------------------------------------------------ }
procedure TXWBSSOiFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WindowState := wsNormal;
end;
// procedure TXWBSSOiFrm.FormClose

{ --------------------- TXWBSSOiFrm.GetLocalComputerName ----------
  This function obtains the local computer name to be sent in the
  TWebBrowser 'POST' so that the local computer is identified in
  the returned STS SAML token (useful data for VistA authentication).
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GetLocalComputerName: String;
var
  c1: DWORD;
  arrCh: array [0 .. MAX_PATH] of Char;
begin
  c1 := MAX_PATH;
  GetComputerNameEx(ComputerNameDnsFullyQualified, arrCh, c1);
  // Retrieves DNS name (FQDN) of the local computer
  if c1 > 0 then
    Result := arrCh
  else
    Result := '';
end;
// function TXWBSSOiFrm.GetLocalComputerName

{ --------------------- TXWBSSOiFrm.GetSTSServer ------------------
  This function gets the address for the Identity and Access Management (IAM)
  Secure Token Service (STS) from the Windows HKLM Registry, it also gets the
  RIO Service and RIO Port for the GetSecurityToken method from the
  RequestSecurityTokenSVC Type Library.
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GetSTSServer: String;
var
  serverList, iamServerList, iamPortList: TStringList;
  serverValue, rioServiceValue, rioPortValue: String;
begin
  try
    // Read Windows Registry (local machine) for URL of IAM server
    serverList := TStringList.Create;
    iamServerList := TStringList.Create;
    // p71
    iamPortList := TStringList.Create; // p71
    if lType = 'lTypeAD' then // p71
      ReadRegValues(HKLM, REG_IAM_AD, serverList) // p71
    else // p71
      ReadRegValues(HKLM, REG_IAM, serverList); // p71
    ReadRegValues(HKLM, REG_IAMRIOSERVICE, iamServerList); // p71
    ReadRegValues(HKLM, REG_IAMRIOPORT, iamPortList); // p71
    serverValue := Piece(serverList[0], '=', 2);
    rioServiceValue := Piece(iamServerList[0], '=', 2); // p71
    rioPortValue := Piece(iamPortList[0], '=', 2); // p71
  finally
    if (serverValue = '') or (rioServiceValue = '') or (rioPortValue = '') then
    // p71
    begin
      if (serverValue = '') and (lType <> 'lTypeAD') then // p71
        serverValue := IAM_Server_URL
      else
        serverValue := IAM_Server_AD_URL;
      // p71
      if rioServiceValue = '' then
        rioServiceValue := RIOSERVICE_VALUE;
      if rioPortValue = '' then
        rioPortValue := RIOPORT_VALUE;
    end;
  end;
  serverList.Free;
  iamServerList.Free; // p71
  iamPortList.Free; // p71
  Result := serverValue + '^' + rioServiceValue + '^' + rioPortValue;
end;
// function TXWBSSOiFrm.GetSTSServer

{ --------------------- TXWBSSOiFrm.httpRio1BeforeExecute ------------------
  This procedure sets up the call to the IAM server, it uses the message from
  the IAMConstants.pas file, however it does not use the TWebBrowser
  component to get the STS token, it uses standard SOAP message processing
  -------------------------------------------------------------------------- }
procedure TXWBSSOiFrm.httpRio1BeforeExecute(const MethodName: string; // p71
  SOAPRequest: TStream);
var
  IAMRequest: string;
  ComputerName: string;
  AppName: string;
begin
  if lCertContext = nil then
    exit;
  try
    ComputerName := GetLocalComputerName;
    AppName := ExtractFileName(Application.ExeName);
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    XMLDoc.Version := '1.0';
    XMLDoc.Encoding := 'UTF-8';
    XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
    IAMRequest := iamMessagePart1 + 'https://' + ComputerName +
      '/Delphi_RPC_Broker/' + AppName + iamMessagePart2;
    XMLDoc.Xml.Text := IAMRequest;
    SOAPRequest.Size := 0;
    XMLDoc.Active := True;
    XMLDoc.SaveToStream(SOAPRequest);
    SOAPRequest.Position := 0;
  finally
    if Assigned(XMLDoc) then
    begin
      XMLDoc.Active := False;
      FreeAndNil(XMLDoc);
    end;
  end;
end;
// procedure TXWBSSOiFrm.httpRio1BeforeExecute

{ --------------------- TXWBSSOiFrm.httpRio1AfterExecute ------------------
  This procedure takes the returned IAM STS token and places it into a
  Memo component to be pulled out into an XMLDocument in
  -------------------------------------------------------------------------- }
procedure TXWBSSOiFrm.httpRio1AfterExecute(const MethodName: string; // p71
  SOAPResponse: TStream);
begin
  if SOAPResponse.Size > 0 then
  begin
    SOAPResponse.Position := 0;
    tokenMemo.Lines.LoadFromStream(SOAPResponse);
  end;
  if Assigned(httpRio1) then
    httpRio1 := nil;
  if Assigned(XMLDoc) then
    XMLDoc := nil;
end;
// procedure TXWBSSOiFrm.httpRio1AfterExecute

{ --------------------- TXWBSSOiFrm.httpRio2BeforeExecute ------------------
  This procedure sets up the call to the IAM server for AD fallback
  authentication it uses the message from the IAMConstants.pas file to get
  an STS token, it uses standard SOAP message processing
  -------------------------------------------------------------------------- }
procedure TXWBSSOiFrm.httpRio2BeforeExecute(const MethodName: string; // p71
  SOAPRequest: TStream);
var
  IAMRequest, Timestamp, TimeStampId, TokenTimeStamp, TokenTimeStampId, ts,
    tsId, tsExpire, userToken, userTokenTimestamp, stampType: string;
  ComputerName: string;
  AppName: string;
begin
  try
    ComputerName := GetLocalComputerName;
    AppName := ExtractFileName(Application.ExeName);
    ts := Piece(GenerateTimestamp(), '::', 1);
    tsExpire := Piece(GenerateTimestamp(), '::', 2);
    stampType := 'Time';
    tsId := GenerateStampId(stampType);
    stampType := 'User';
    userToken := GenerateStampId(stampType);
    userTokenTimestamp := Piece(GenerateTimestamp(), '::', 1);
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    XMLDoc.Version := '1.0';
    XMLDoc.Encoding := 'UTF-8';
    XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
    Timestamp := '';
    TimeStampId := '';
    TokenTimeStamp := '';
    TokenTimeStampId := '';
    IAMRequest := iamMessageADPart1 + iamMessageADPart2 + '"' + tsId + '">' +
      '<u:Created>' + ts + '</u:Created>' + '<u:Expires>' + tsExpire +
      '</u:Expires>' + iamMessageADPart3 + '"' + userToken + '">' +
      iamMessageADPart4 + UserName + iamMessageADPart5 + Password +
      iamMessageADPart6 + userTokenTimestamp + '</u:Created>' +
      iamMessageADPart7 + 'https://' + ComputerName + '/Delphi_RPC_Broker/' +
      AppName + iamMessageADPart8;
    XMLDoc.Xml.Text := IAMRequest;
    SOAPRequest.Size := 0;
    SOAPRequest.Position := 0;
    XMLDoc.Active := True;
    XMLDoc.SaveToStream(SOAPRequest);
    SOAPRequest.Position := 0;
  finally
    if Assigned(XMLDoc) then
    begin
      XMLDoc.Active := False;
      FreeAndNil(XMLDoc);
    end;
  end;
end;
// procedure TXWBSSOiFrm.httpRio2BeforeExecute

{ --------------------- TXWBSSOiFrm.httpRio2AfterExecute ------------------
  This procedure takes the returned IAM STS token and places it into a
  Memo component to be pulled out into an XMLDocument
  -------------------------------------------------------------------------- }
procedure TXWBSSOiFrm.httpRio2AfterExecute(const MethodName: string; // p71
  SOAPResponse: TStream);
begin
  if SOAPResponse.Size > 0 then
  begin
    SOAPResponse.Position := 0;
    tokenMemo.Lines.LoadFromStream(SOAPResponse);
    myToken := tokenMemo.Lines.Text;
  end;
  if Assigned(httpRio2) and (not ContainsText(myToken, 'FAIL')) then
    httpRio2 := nil;
  if Assigned(XMLDoc) then
    XMLDoc := nil;
end;
// procedure TXWBSSOiFrm.httpRio2AfterExecute

{ --------------------- TXWBSSOiFrm.GenerateStampId ------------
  This function generates a unique, required timestamp identification
  for an IAM Active Directoery logon to VistA.
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GenerateStampId(stampType: String): String; // p71
const
  chars = 'ABCDEF0123456789';
var
  S: String;
  i, N: Integer;
begin
  Randomize;
  for i := 1 to 33 do
  begin
    N := Random(Length(chars)) + 1;
    S := S + chars[N];
  end;
  if stampType = 'Time' then
    Result := 'TS-' + S
  else
    Result := 'UsernameToken-' + S;
end;
// funciton TXWBSSOiFrm.GenerateStampId

{ --------------------- TXWBSSOiFrm.GenerateTimestamp --------------
  This function generates a unique, required timestamp for an IAM
  Active Directoery logon to VistA.
  ------------------------------------------------------------------ }
function TXWBSSOiFrm.GenerateTimestamp: String; // p71
var
  Timestamp, TimestampExpires: String;
begin
  Timestamp := DateToISO8601(Now());
  TimestampExpires := DateToISO8601(IncDay(Now(), 1));
  Result := Timestamp + '::' + TimestampExpires;
end;
// function TXWBSSOiFrm.GenerateTimestamp

end.
