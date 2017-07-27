{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Herlan Westra
	Description: Contains the TXWBSSOiToken component.
  Unit: XWBSSOi contains a simple TWebBrowser to 'POST' a SOAP message to
    IAM to obtain a SAML token.
	Current Release: Version 1.1 Patch 65
*************************************************************** }

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
      You’ve got a client on a VA deployed Microsoft Windows workstation that is
      part of the VA forest and you want to obtain a SAML token from the IAM STS
      service.  Submit a SOAP request token message using mutual TLS, where
      the client certificate identifies the user making the request.

      Since VA workstation security blocks most API attempts to 'POST' data to
      a web site where you are not already authenticated, the choices of a
      working API are limited. The use within this unit of the ActiveX
      TWebBrowser (stripped down Internet Explorer) represents the only known
      working method of sending an https 'POST' to a web site using standard
      Windows APIs and TLS mutual authentication (PIV card) after the data is
      sent.
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
  {Vcl}
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.OleCtrls,
  Vcl.StdCtrls,
  {Utilities}
  MSHTML,
  SHDocVw,
  {VA}
  MFunStr,
  XWBut1;

type
{------ TXWBSSOiToken ------}
{:This component defines and obtains the STS SAML token used to authenticate
and identify the user}
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
  property SSOiLogonName: String read FSSOiLogonNameValue write FSSOiLogonName;
  property SSOiSECID: String read FSSOiSECIDValue write FSSOiSECID;
end;

TXWBSSOiFrm = class(TForm)
    WebBrowser1: TWebBrowser;
    Label1: TLabel;
    function CreatePost(S: String): OleVariant;
    function GetLocalComputerName: String;
    function GetSTSServer: String;
    function GetMyToken: String;
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch;
      const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
  private
    { Private declarations }
    FDispatch: IDispatch;
    FDocLoaded: Boolean;
  public
    { Public declarations }
  end;

var
  XWBSSOiFrm: TXWBSSOiFrm;
  myToken: String; //used to pass the value of the token between form and component

implementation

{$R *.dfm}

//Note: Include file contains SOAP message and IAM server location
{$I IAMBase.inc}

{--------------------- TXWBSSOiToken.Create ----------------------
This constructor creates and obtains a SSOiToken, and sets the value
of the FSSOiTokenValue property to the token. It also sets the
remaining property values. When the TXWBSSOiToken component is placed
on a form, this will run automatically when the form is created.
------------------------------------------------------------------}
constructor TXWBSSOiToken.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSSOiToken('');
  FSSOiADUPN('');
  FSSOiLogonName('');
  FSSOiSECID('');
  myToken := '';
end; //constructor TXWBSSOiToken.Create


{--------------------- TXWBSSOiToken.Destroy ---------------------
This destructor removes a SSOiToken.
------------------------------------------------------------------}
destructor TXWBSSOiToken.Destroy;
begin
  FSSOiTokenValue := '';
  inherited Destroy;
end; //destructor TXWBSSOiToken.Destroy


{------------------------- TXWBSSOiToken.FSSOiToken --------------
This procedure looks at FSSOiTokenValue, and if null then it does a SOAP
request to the STS server for a new token.
------------------------------------------------------------------}
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
end; //procedure TXWBSSOiToken.FSSOiToken


{------------------------- TXWBSSOiToken.FSSOiADUPN --------------
Returns the ADUPN assigned to the user by Identity and Access Management by
examining the SAML token. If there is no token stored, returns null.
------------------------------------------------------------------}
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
end; //procedure TXWBSSOiToken.FSSOiADUPN


{------------------------- TXWBSSOiToken.FSSOiLogonName ----------
Returns the SECID assigned to the user by Identity and Access Management by
examining the SAML token. If there is no token stored, returns null.
------------------------------------------------------------------}
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
end; //procedure TXWBSSOiToken.FSSOiLogonName


{------------------------- TXWBSSOiToken.FSSOiSECID --------------
Returns the SECID assigned to the user by Identity and Access Management by
examining the SAML token. If there is no token stored, returns null.
------------------------------------------------------------------}
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
end; //procedure TXWBSSOiToken.FSSOiSECID


{--------------------- TXWBSSOiFrm.GetMyToken --------------------
This function is where all of the heavy lifting occurs. It opens the
web browser and sends a 'POST' to IAM, and sets the return value to
the variable 'myToken'.
------------------------------------------------------------------}
function TXWBSSOiFrm.GetMyToken: String;
var
  Doc: IHTMLDocument2;
  iamURL: String;
  iamMessage: String;
  ComputerName: String;
  AppName: String;
  EmptyParam: OleVariant;
  Flags: OleVariant;
  Post: OleVariant;
  Header: OleVariant;
  ovDocument: OleVariant;
  rcvdToken: String;
begin
  FDispatch := nil;
  rcvdToken := '';
  myToken := '';
  EmptyParam := 0;
  iamURL := GetSTSServer;
  if (iamURL <> '') then
  begin
    ComputerName := GetLocalComputerName;
    AppName := ExtractFileName(Application.ExeName);
    Flags := NavNoHistory + NavNoReadFromCache + NavNoWriteToCache;
    //Doc := WebBrowser1.Document as IHTMLDocument2;
    Doc := WebBrowser1.DefaultInterface.Document as IHTMLDocument2;
    WebBrowser1.Visible := False;   //Per MSDN, OnDocumentComplete event will not trigger if Visible property is not True.
    iamMessage := iamMessagePart1 +'https://'+ComputerName+'/Delphi_RPC_Broker/'+AppName + iamMessagePart2;
    Header := 'Content-Type: text/plain' + #10#13;
    Post := CreatePost(iamMessage);
    try
      //Authenticate with PIV and 'POST' Soap message to obtain SAML
      WebBrowser1.Navigate(iamURL, Flags, EmptyParam, Post, Header);
      while WebBrowser1.ReadyState < READYSTATE_INTERACTIVE do
        Application.ProcessMessages;
      //OnDocumentComplete event should set myToken, but doesn't always trigger
      if myToken <> '' then
        rcvdToken := myToken
      else
        try
          ovDocument := WebBrowser1.Document;
          rcvdToken := ovDocument.XMLDocument.XML;
        except
          rcvdToken := '';      //An error above returns null string.
        end;
    finally
    end;
    WebBrowser1.Navigate('about:blank');
    WebBrowser1.Free;
  end;
  Result := RemoveCRLF(rcvdToken);
end; //function TXWBSSOiFrm.GetMyToken



{--------------------- TXWBSSOiFrm.CreatePost --------------------
This function converts a string value into an OleVariant value,
which is the required format for data sent in a TWebBrowser 'POST'.
------------------------------------------------------------------}
function TXWBSSOiFrm.CreatePost(S: String): OleVariant;
var
  Temp: OleVariant;
  I: Integer;
begin
  // The post must be an array, but without null terminator (-1)
  Temp := VarArrayCreate([0, Length(S) - 1], varByte);
  // Put post in array
  for I := 1 to Length(S) do
    Temp[I - 1] := Ord(S[I]);
  Result := Temp;
end; //function TXWBSSOiFrm.CreatePost


{--------------------- TXWBSSOiFrm.FormClose ---------------------
This procedure runs when XWBCallIamFrm Form is closed.
------------------------------------------------------------------}
procedure TXWBSSOiFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WindowState := wsNormal;
end; //procedure TXWBSSOiFrm.FormClose


{--------------------- TXWBSSOiFrm.FormCreate --------------------
This procedure instantiates XWBCallIamFrm Form.
------------------------------------------------------------------}
procedure TXWBSSOiFrm.FormCreate(Sender: TObject);
begin
  myToken := '';
  WindowState := wsNormal;     //Token seems to be truncated if this is run minimized
  myToken := GetMyToken;
end; //procedure TXWBSSOiFrm.FormCreate


{--------------------- TXWBSSOiFrm.GetLocalComputerName ----------
This function obtains the local computer name to be sent in the
TWebBrowser 'POST' so that the local computer is identified in
the returned STS SAML token (useful data for VistA authentication).
------------------------------------------------------------------}
function TXWBSSOiFrm.GetLocalComputerName: String;
var
  c1: dword;
  arrCh: array[0..MAX_PATH] of char;
begin
  c1 := MAX_PATH;
  GetComputerNameEx(ComputerNameDnsFullyQualified, arrCh, c1);    //Retrieves DNS name (FQDN) of the local computer
  if c1 > 0 then
    Result := arrCh
  else
    Result := '';
end; //function TXWBSSOiFrm.GetLocalComputerName


{--------------------- TXWBSSOiFrm.GetSTSServer ------------------
This function gets the address for the Identity and Access Management (IAM)
Secure Token Service (STS) from the Windows HKLM Registry.
------------------------------------------------------------------}
function TXWBSSOiFrm.GetSTSServer: String;
var
  serverList : TStringList;
  serverValue : String;
begin
  try
    //Read Windows Registry (local machine) for URL of IAM server
    serverList := TStringList.Create;
    ReadRegValues(HKLM, REG_IAM, serverList);
    //Assume only (Default) server in registry
    serverValue := Piece(serverList[0], '=', 2);
  finally
    if serverValue = '' then
    begin
      serverValue := IAM_Server_URL;  //From 'include' file IAMBase.inc
    end;
  end;
  Result := serverValue;
end;
//function TXWBSSOiFrm.GetSTSServer


{---------------- TXWBSSOiFrm.WebBrowser1BeforeNavigate2 ---------
This procedure is used to set event variables prior to making a
call to IAM.
------------------------------------------------------------------}
procedure TXWBSSOiFrm.WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  FDispatch := nil;
  FDocLoaded := False;
end; //procedure TXWBSSOiFrm.WebBrowser1BeforeNavigate2


{---------------- TXWBSSOiFrm.WebBrowser1DocumentComplete --------
This procedure is used to capture the raw data (token) as it is
received from IAM, as we want the unaltered token, and not the
parsed token that is displayed in the web browser.
------------------------------------------------------------------}
procedure TXWBSSOiFrm.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  ovDocument: OleVariant;
  rcvdToken: String;
begin
  if pDisp = FDispatch then
  begin
    ovDocument := WebBrowser1.Document;
    try
      rcvdToken := ovDocument.XMLDocument.XML;
    except
      rcvdToken := '';
    end;
    myToken := RemoveCRLF(rcvdToken);
    FDocLoaded := True;
    FDispatch := nil;
  end;
end; //procedure TXWBSSOiFrm.WebBrowser1DocumentComplete


{------------- TXWBSSOiFrm.WebBrowser1NavigateComplete2 ----------
This procedure sets a flag when navigation to the web site is
completed. The flag is used to monitor web browser activity.
------------------------------------------------------------------}
procedure TXWBSSOiFrm.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  if FDispatch = nil then
    FDispatch := pDisp;
end; //procedure TXWBSSOiFrm.WebBrowser1NavigateComplete2


{------------- TXWBSSOiFrm.WebBrowser1NavigateError ----------
This procedure sets a flag when navigation to the web site generates
an error. The flag is used to monitor web browser activity.
------------------------------------------------------------------}
procedure TXWBSSOiFrm.WebBrowser1NavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  if FDispatch = nil then
    FDispatch := pDisp;
  WebBrowser1.Navigate('about:blank');
end; //procedure TXWBSSOiFrm.WebBrowser1NavigateError

end.
