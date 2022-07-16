unit oPKIEncryption;

interface

uses
  System.Classes,
  System.SysUtils,
  TRPCB,
  wcrypt2;

type
  EPKIEncryptionError = class(Exception);

  TPKIPINResult = (prOK, prCancel, prLocked, prError);

  TPKISANLink = (slOK, slBlankVistA, slMisMatch, slNoCertFound, slVistAError, slError);

  TPKIHashAlgorithm = (ha128, ha256, ha384, ha512);

  TPKIEncryptionLogEvent = procedure(const aMessage: string) of object;

  IPKIByteArray = interface;
  IPKIEncryptionEngine = interface;
  IPKIEncryptionData = interface;
  IPKIEncryptionSignature = interface;

  IPKIByteArray = interface(IInterface)
    ['{57E1DAFC-7572-440C-A2F7-6F016C2BD985}']
    function getArrayLength: integer;
    function getAsAnsiString: AnsiString;
    function getAsHex: string;
    function getAsMime: string;
    function getAsString: string;

    procedure GetArrayValues(aList: TStrings);

    property AsAnsiString: AnsiString read getAsAnsiString;
    property AsHex: string read getAsHex;
    property AsMime: string read getAsMime;
    property AsString: string read getAsString;
    property ArrayLength: integer read getArrayLength;
  end;

  IPKIEncryptionEngine = interface(IInterface)
    ['{45065459-F385-415B-A167-9178FCD6B557}']
    function getVistAUserName: string;
    function getIsCardReaderReady: boolean;
    function getSANFromCard: string;
    function getSANFromVistA: string;
    function getSANLink: TPKISANLink;
    function getEngineVersion: string;
    function getCSPName: string;
    function getHashAlgorithm: string;

    procedure setOnLogEvent(const aOnLogEvent: TPKIEncryptionLogEvent);

    procedure ClearPIN;
    procedure DisplayProviders;
    procedure GetCertificates(aList: TStrings);
    procedure HashData(aPKIEncryptionData: IPKIEncryptionData);
    procedure LinkSANtoVistA;
    procedure SignData(aPKIEncryptionData: IPKIEncryptionData);
    procedure ValidateSignature(aPKIEncryptionSignature: IPKIEncryptionSignature);
    procedure SaveSignature(aPKIEncryptionData: IPKIEncryptionData);

    property OnLogEvent: TPKIEncryptionLogEvent write setOnLogEvent;

    property EngineVersion: string read getEngineVersion;
    property IsCardReaderReady: boolean read getIsCardReaderReady;
    property SANFromCard: string read getSANFromCard;
    property SANFromVistA: string read getSANFromVistA;
    property VistAUserName: string read getVistAUserName;
    property SANLink: TPKISANLink read getSANLink;
    property CSPName: string read getCSPName;
    property HashAlgorithm: string read getHashAlgorithm;
  end;

  IPKIEncryptionData = interface(IInterface)
    ['{89A9B876-7AF5-42C9-9BF4-7A30E6081E4A}']
    function getBuffer: string;
    function getHashText: string;
    function getHashHex: string;
    function getHashValue: AnsiString;
    function getSignature: string;
    function getSignatureID: string;
    function getCrlURL: string;
    function getDateTimeSigned: TDateTime;
    function getFMDateTimeSigned: string;

    procedure setBuffer(const aValue: string);

    procedure AppendToBuffer(aStrings: array of string);
    procedure Clear;
    procedure Validate;

    property Buffer: string read getBuffer write setBuffer;
    property HashText: string read getHashText;
    property HashHex: string read getHashHex;
    property Signature: string read getSignature;
    property SignatureID: string read getSignatureID;
    property CrlURL: string read getCrlURL;
    property DateTimeSigned: TDateTime read getDateTimeSigned;
    property FMDateTimeSigned: string read getFMDateTimeSigned;
  end;

  IPKIEncryptionDataDEAOrder = interface(IPKIEncryptionData)
    ['{3BBC382A-F970-49B5-9263-C06DB2E8CF18}']
    function getDEANumber: string;
    function getDetoxNumber: string;
    function getDirections: string;
    function getDrugName: string;
    function getIsDEASig: boolean;
    function getIssuanceDate: string;
    function getOrderNumber: string;
    function getPatientAddress: string;
    function getPatientName: string;
    function getProviderAddress: string;
    function getProviderName: string;
    function getQuantity: string;

    procedure setDEANumber(const aValue: string);
    procedure setDetoxNumber(const aValue: string);
    procedure setDirections(const aValue: string);
    procedure setDrugName(const aValue: string);
    procedure setIsDEASig(const aValue: boolean);
    procedure setIssuanceDate(const aValue: string);
    procedure setOrderNumber(const aValue: string);
    procedure setPatientAddress(const aValue: string);
    procedure setPatientName(const aValue: string);
    procedure setProviderAddress(const aValue: string);
    procedure setProviderName(const aValue: string);
    procedure setQuantity(const aValue: string);

    procedure LoadFromVistA(aRPCBroker: TRPCBroker; aPatientDFN, aUserDUZ, aCPRSOrderNumber: string);

    property IsDEASig: boolean read getIsDEASig write setIsDEASig;
    property IssuanceDate: string read getIssuanceDate write setIssuanceDate;
    property PatientName: string read getPatientName write setPatientName;
    property PatientAddress: string read getPatientAddress write setPatientAddress;
    property DrugName: string read getDrugName write setDrugName;
    property Quantity: string read getQuantity write setQuantity;
    property Directions: string read getDirections write setDirections;
    property DetoxNumber: string read getDetoxNumber write setDetoxNumber;
    property ProviderName: string read getProviderName write setProviderName;
    property ProviderAddress: string read getProviderAddress write setProviderAddress;
    property DEANumber: string read getDEANumber write setDEANumber;
    property OrderNumber: string read getOrderNumber write setOrderNumber;
  end;

  IPKIEncryptionSignature = interface(IInterface)
    ['{B7D683A4-D40D-4B3B-84F7-5C40EA1887F5}']
    function getHashText: string;
    function getDateTimeSigned: string;
    function getSignature: string;

    procedure setHashText(const aValue: string);
    procedure setDateTimeSigned(const aValue: string);
    procedure setSignature(const aValue: string);

    procedure LoadSignature(const aValue: TStringList);

    property DataString: string read getHashText write setHashText;
    property DateTimeSigned: string read getDateTimeSigned write setDateTimeSigned;
    property Signature: string read getSignature write setSignature;
  end;

const
  Version = '1.0.2.1';

  PKI_VERSION = 1;

  PKI_PIN_RESULT: array [TPKIPINResult] of string = ('OK', 'PIN Canceled', 'Card Locked', 'PIN Error');

  PKI_PIN_MESSAGE: array [TPKIPINResult] of string = ('OK', 'User canceled signing.', 'User card is locked.', 'PIN Error');

  PKI_SAN_LINK_RESULT: array [TPKISANLink] of string = ('OK', 'Blank value in VistA', 'VistA and PIV card values do not match', 'No certificate found on the card', 'Error getting SAN from VistA', 'Unknown system error');

  PKI_ENGINE_VERSION = '1.0.0.1';

  PKI_HASH_ALGORITHM: array [TPKIHashAlgorithm] of string = ('SHA1RSA', 'SHA256RSA', 'SHA384RSA', 'SHA512RSA');

  // PKI_ACTIVE_CLIENT = 'ActivClient Cryptographic Service Provider'; Removed, using registry value

  PKI_ACTIVE_CLIENT_TYPE = 1; // Should probably just use PROV_RSA_FULL from the wcrypt2.pas file instead

  PKI_SCARD_S_SUCCESS = 0;

  PKI_PROVIDER_TYPE = PROV_RSA_AES; // Should probably just use PROV_RSA_AES in the engine to keep it clean

  PKI_ENCODING_TYPE = PKCS_7_ASN_ENCODING or X509_ASN_ENCODING; // <-- OR of WCrypt2.pas constants

  DLG_89802000 = '89802000^Order text to be signed is empty.';

  DLG_89802001 = '89802001^User''s DEA # is missing.';

  DLG_89802002 = '89802002^Drug Schedule is missing.';

  DLG_89802003 = '89802003^No Cert with a valid date found.';

  DLG_89802004 = '89802004^Valid Certificate was not found.';

  DLG_89802005 = '89802005^Couldn''t load CSP.';

  DLG_89802006 = '89802006^Smart Card Reader not found.';

  DLG_89802007 = '89802007^Cert with DEA # not found.';

  DLG_89802008 = '89802008^The Cert was not valid for the Drug Schedule.';

  DLG_89802009 = '89802009^Signature Check failed (Invalid Signature).';

  DLG_89802010 = '89802010^Error reported by the Crypto API: ';
  {
    DLG_89802010 is the general error that is a catch all for several problems.
    Things that IRM should look at if user reporting getting this error.
    1. See that the PKIserver.exe routine is installed on the server
    in the WINNT\system32 directory.
    2. See that the PKIserver.exe routine has been registered with
    windows.
    3. See that in Administrator tools>services that PKIService has a
    status of STARTED and its Startup Type is Automatic.
  }

  DLG_89802011 = '89802011^Certificate Chain not valid.';

  DLG_89802012 = '89802012^Card must be unlocked before linking.';

  DLG_89802013 = '89802013^Error validating PIN, account linkage canceled.';

  DLG_89802014 = '89802014^Unable to sign without valid PIN entry.';

  DLG_89802015 = '89802015^Corrupted (Decode failure).';

  DLG_89802016 = '89802016^Corrupted (Hash mismatch).';

  DLG_89802017 = '89802017^Certificate revoked.';

  DLG_89802018 = '89802018^Digital signature verification failed.';

  DLG_89802019 = '89802019^Before the certificate effective date.';

  DLG_89802020 = '89802020^This certificate or one of the certificates in the certificate chain is not time-valid.';

  DLG_89802021 = '89802021^PIV card cannot be linked without the proper PIN.';

  DLG_89802022 = '89802022^Does not have valid signature.';

  DLG_89802023 = '89802023^Certificate trust is not properly time-nested.';

  DLG_89802024 = '89802024^Certificate not valid in it''s proposed usage.';

  DLG_89802025 = '89802025^The certificate or certificate chain is based on an untrusted root.';

  DLG_89802026 = '89802026^The revocation status of the certificate or one of the certificates in the certificate chain is unknown.';

  DLG_89802027 = '89802027^One of the certificates in the chain was issued by a certification authority that the original certificate had certified.';

  DLG_89802028 = '89802028^The certificate chain is not complete.';

  DLG_89802029 = '89802029^The certificate or one of the certificates in the certificate chain does not have a valid signature.';

  DLG_89802030 = '89802030^The certificate or certificate chain is not valid in its proposed usage.';

  DLG_89802031 = '89802031^Unable to access encryption data via IPKIEncryptionDataEx Interface.';

  DLG_89802032 = '89802032^Trust for this certificate or one of the certificates in the certificate chain has been revoked.';

  DLG_89802033 = '89802033^Error getting name value from certificate.';

  DLG_89802034 = '89802034^Error establishing context with the card reader.';

  DLG_89802035 = '89802035^Card reader not ready or card not inserted properly.';

  DLG_89802036 = '89802036^Error reported by the PKIServiceEngine: ';

  DLG_89802037 = '89802037^Invalid Fileman DateTime Conversion.';

  DLG_89802038 = '89802038^Not marked as DEA Order.';

  DLG_89802039 = '89802039^DEA Orders can only be initialized via individual property values.';

  DLG_89802040 = '89802040^User canceled connection.';

  DLG_89802041 = '89802041^Unable to retrieve SAN from card.';

  DLG_89802042 = '89802042^Connection not established.';

  DLG_89802043 = '89802043^User must have the XU EPCS EDIT DATA context option in their menu tree.';

  DLG_89802044 = '89802044^You cannot use this application if you hold the ORES key.';

  DLG_89802045 = '89802045^You must hold the XUEPCSEDIT key to use this application.';

  DLG_89802046 = '89802046^Subject Alternate Name (SAN) on card and in VistA do not Match.';

  DLG_89802047 = '89802047^Error communicating with VistA via the RPC Broker Connection.';

  DLG_89802048 = '89802048^VistA Subject Alternate Name (SAN) is blank.';

  DLG_89802049 = '89802049^Unable to update VistA Subject Alternate Name (SAN).';

  DLG_89802050 = '89802050^PKIServer Status: ';

  { Interface Factories and Other Utilities }
procedure NewPKIEncryptionData(var aPKIEncryptionData: IPKIEncryptionData);
procedure NewPKIEncryptionDataDEAOrder(var aPKIEncryptionDataDEAOrder: IPKIEncryptionDataDEAOrder);
procedure NewPKIEncryptionEngine(aRPCBroker: TRPCBroker; var aPKIEncryptionEngine: IPKIEncryptionEngine);
procedure NewPKIEncryptionSignature(var aPKIEncryptionSignature: IPKIEncryptionSignature);

procedure TDateTime2FMDateTime(const aTDateTime: TDateTime; var aFMDateTime: string; aIncludeTime: boolean = True; aIncludeSeconds: boolean = True);
procedure FMDateTime2TDateTime(const aFMDateTime: string; var aDateTime: TDateTime);
procedure GetPINValue(var aPinValue: string);

function GetLastSystemError: string;
function IsDigitalSignatureAvailable(aPKIEncryptionEngine: IPKIEncryptionEngine; var aMessage: string; aSuccessfulLinkMessage: string = ''): boolean;
function VerifyPKIPIN(aPKIEncryptionEngine: IPKIEncryptionEngine): TPKIPINResult;
function DialogAsMessage(aDialog: string): string;

implementation

uses
  VAUtils,
  System.UITypes,
  fPKIPINPrompt,
  oPKIEncryptionEngine,
  oPKIEncryptionData,
  oPKIEncryptionDataDEAOrder,
  oPKIEncryptionSignature;

const
  SAN_LINK_NEEDED =
    'Your VistA account has not been linked to this PIV card.' + #13#10 +
    'Would you like to link this PIV card now?';

  SAN_LINK_SUCCESS =
    'Your PIV card (%s) has been successfully linked' + #13#10 +
    'to your VistA account, which will allow you to digitally sign.';

  SAN_LINK_FAILURE =
    '%s' + #13#10 +
    'VistA was not able to link this PIV card to your account.' + #13#10 +
    'One possible cause is that your card is already linked to another VistA account.';

  { Factories }

procedure NewPKIEncryptionEngine(aRPCBroker: TRPCBroker; var aPKIEncryptionEngine: IPKIEncryptionEngine);
begin
  TPKIEncryptionEngine.Create(aRPCBroker).GetInterface(IPKIEncryptionEngine, aPKIEncryptionEngine);
end;

procedure NewPKIEncryptionData(var aPKIEncryptionData: IPKIEncryptionData);
begin
  TPKIEncryptionData.Create.GetInterface(IPKIEncryptionData, aPKIEncryptionData);
end;

procedure NewPKIEncryptionDataDEAOrder(var aPKIEncryptionDataDEAOrder: IPKIEncryptionDataDEAOrder);
begin
  TPKIEncryptionDataDEAOrder.Create.GetInterface(IPKIEncryptionDataDEAOrder, aPKIEncryptionDataDEAOrder);
end;

procedure NewPKIEncryptionSignature(var aPKIEncryptionSignature: IPKIEncryptionSignature);
begin
  TPKIEncryptionSignature.Create.GetInterface(IPKIEncryptionSignature, aPKIEncryptionSignature);
end;

{ Utilities }

function GetLastSystemError: string;
begin
  Result := Format('%s x%8x: %s', [DLG_89802010, GetLastError, SysErrorMessage(GetLastError)]);
end;

function DialogAsMessage(aDialog: string): string;
begin
  Result := Copy(aDialog, 1, Pos('^', aDialog) - 1) +
    ': ' +
    Copy(aDialog, Pos('^', aDialog) + 1, Length(aDialog));
end;

procedure TDateTime2FMDateTime(const aTDateTime: TDateTime; var aFMDateTime: string; aIncludeTime: boolean = True; aIncludeSeconds: boolean = True);
var
  aYear, aMonth, aDay: Word;
  aHour, aMinute, aSecond, aMilliSecond: Word;
begin
  DecodeDate(aTDateTime, aYear, aMonth, aDay);
  aFMDateTime := IntToStr(aYear - 1700) + Format('%.2d', [aMonth]) + Format('%.2d', [aDay]);
  if aIncludeTime then
    begin
      DecodeTime(aTDateTime, aHour, aMinute, aSecond, aMilliSecond);
      aFMDateTime := aFMDateTime + '.' + Format('%.2d', [aHour]) + Format('%.2d', [aMinute]);
      if aIncludeSeconds then
        aFMDateTime := aFMDateTime + Format('%.2d', [aSecond]);
    end;
  while (Length(aFMDateTime) > 7) and ((Copy(aFMDateTime, Length(aFMDateTime), 1) = '0') or (Copy(aFMDateTime, Length(aFMDateTime), 1) = '.')) do
    aFMDateTime := Copy(aFMDateTime, 1, Length(aFMDateTime) - 1);
end;

procedure FMDateTime2TDateTime(const aFMDateTime: string; var aDateTime: TDateTime);
var
  aFMDateString: string;
  aYear, aMonth, aDay: Word;
  aHour, aMinute, aSecond: Word;
begin
  try
    aDateTime := 0;
    aFMDateString := Format('%0.6f', [StrToFloat(aFMDateTime) + 0.0000001]);
    aYear := StrToIntDef(Copy(aFMDateString, 1, 3), -1);
    if aYear > 0 then
      inc(aYear, 1700);
    aMonth := StrToIntDef(Copy(aFMDateString, 4, 2), -1);
    aDay := StrToIntDef(Copy(aFMDateString, 6, 2), -1);

    aHour := StrToIntDef(Copy(aFMDateString, 9, 2), 0);
    aMinute := StrToIntDef(Copy(aFMDateString, 11, 2), 0);
    aSecond := StrToIntDef(Copy(aFMDateString, 13, 2), 0);

    aDateTime := EncodeDate(aYear, aMonth, aDay) + EncodeTime(aHour, aMinute, aSecond, 0);
  except
    raise EPKIEncryptionError.Create(DLG_89802037 + aFMDateTime);
  end;
end;

function VerifyPKIPIN(aPKIEncryptionEngine: IPKIEncryptionEngine): TPKIPINResult;
begin
  Result := prOK;
  //Result := TfrmPKIPINPrompt.VerifyPKIPIN(aPKIEncryptionEngine);
end;

procedure GetPINValue(var aPinValue: string);
begin
  aPinValue := TfrmPKIPINPrompt.GetPINValue;
end;

function IsDigitalSignatureAvailable(aPKIEncryptionEngine: IPKIEncryptionEngine; var aMessage: string; aSuccessfulLinkMessage: string = ''): boolean;
{ Does the preliminary work of verifying the card is ready and the SAN linkage is correct }
var
  aSuccessMessage: string;
begin
  try
    while not aPKIEncryptionEngine.IsCardReaderReady do
      begin
        if ShowMsg('Please insert your PIV card or press cancel to exit.', 'Card Reader Not Ready', smiInfo, smbRetryCancel) <> smrRetry then
          raise EPKIEncryptionError.Create(DLG_89802035);
        Sleep(4000); // Painful but the card will need time to synch up
      end;

    case aPKIEncryptionEngine.SANLink of
      slOK: // Good To Go!
        begin
          aMessage := 'OK';
        end;

      slBlankVistA: // Offer to Update the SAN in VistA, otherwise bail with exception
        begin
          if ShowMsg(SAN_LINK_NEEDED, 'Link PIV Card', smiQuestion, smbYesNo) = smrYes then
            try
              aPKIEncryptionEngine.LinkSANtoVistA; // This will raise an exception if it fails, otherwise update is good

              // Build default success message
              aSuccessMessage := Format(SAN_LINK_SUCCESS, [aPKIEncryptionEngine.VistAUserName]);

              // if aSuccessfulLinkMessage has text, append it to the success message
              if aSuccessfulLinkMessage <> '' then
                aSuccessMessage := aSuccessMessage + #13#10 + aSuccessfulLinkMessage;

              // Report the successful linking
              ShowMsg(aSuccessMessage, 'Successfully Linked', smiInfo, smbOK);
            except
              raise EPKIEncryptionError.CreateFmt(SAN_LINK_FAILURE, [aPKIEncryptionEngine.VistAUserName]);
            end
          else
            raise EPKIEncryptionError.Create(DLG_89802048);
        end;

      slMisMatch: // Both names exist but are different (Non-Case Sensitive match used)
        raise EPKIEncryptionError.Create(DLG_89802046);

      slNoCertFound: // Problem finding the cert on the card, SAN is returned blank
        raise EPKIEncryptionError.Create(DLG_89802041);
    else
      raise EPKIEncryptionError.Create(DLG_89802041);
    end;

    aMessage := 'OK';
    Result := True;
  except
    on E: Exception do
      begin
        Result := False;
        aMessage := E.Message;
      end;
  end;
end;

end.
