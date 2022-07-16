unit oPKIEncryptionEngine;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Win.Registry,
  Winapi.Windows,
  wcrypt2,
  WinSCard,
  oPKIEncryption,
  oPKIEncryptionEx,
  TRPCB;

type
  TPKIEncryptionEngine = class(TInterfacedObject, IPKIEncryptionEngine, IPKIEncryptionEngineEx)
  private
    fCSPName: string;
    fHashAlgorithm: TPKIHashAlgorithm;

    fProviderHandle: HCRYPTPROV; // Provider handle - retrieved once on Create
    fRPCBroker: TRPCBroker; // So we can do method calls to VistA as current signed on user
    fCurrentPIN: string; // Updated everytime ValidatePIN is called so SignData can reuse it

    fOnLogEvent: TPKIEncryptionLogEvent; // Built in generic logging capability - See property OnLogEvent in IPKIEncryptionEngine
    procedure fLogEvent(const aMessage: string);
    procedure setOnLogEvent(const aOnLogEvent: TPKIEncryptionLogEvent);

    // Internal methods
    procedure checkSignature(aDataString, aSignatureString: string; aDataTimeSigned: PFileTime = nil);
    procedure checkCertChain(aPCertContext: PCCERT_CONTEXT);
    procedure checkCertRevocation(aPCertContext: PCCERT_CONTEXT);
    procedure hashBuffer(aBuffer: string; var aHashText: AnsiString; var aHashValue: AnsiString; var aHashHex: AnsiString);
    procedure setVistASAN(aNewSAN: string);
    procedure setCSPName(const aValue: string);
    procedure setHashAlgorithm(const aValue: string);
    procedure setupCryptoServiceProvider;

    function getCertContext: PCCERT_CONTEXT;
    function getIsValidPIN(const aPKIPIN: string; var aMessage: string): boolean;

    // Methods for the IPKIEncryptionEngine interface properties
    function getIsCardReaderReady: boolean;
    function getSANFromCard: string;
    function getSANFromVistA: string;
    function getVistAUserName: string;
    function getSANLink: TPKISANLink;
    function getEngineVersion: string;
    function getCSPName: string;
    function getHashAlgorithm: string;

    procedure DisplayProviders;
    procedure GetCertificates(aList: TStrings);
    procedure SignData(aPKIEncryptionData: IPKIEncryptionData);
    procedure HashData(aPKIEncryptionData: IPKIEncryptionData);
    procedure ValidateSignature(aPKIEncryptionSignature: IPKIEncryptionSignature);
    procedure SaveSignature(aPKIEncryptionData: IPKIEncryptionData);
    procedure LinkSANtoVistA;
    procedure ClearPIN;
  public
    constructor Create(aRPCBroker: TRPCBroker);
    destructor Destroy; override;
  end;

implementation

uses
  XLFMime,
  StrUtils,
  oPKIEncryptionData,
  oPKIEncryptionCertificate;

{ TPKIEncryption }

constructor TPKIEncryptionEngine.Create(aRPCBroker: TRPCBroker);
begin
  inherited Create;

  fRPCBroker := aRPCBroker;
  fOnLogEvent := fLogEvent;
  fCurrentPIN := '';

  setupCryptoServiceProvider; // Gets info from registry

  if not CryptAcquireContextA(@fProviderHandle, nil, nil, PKI_PROVIDER_TYPE, 0) then
    // This tries again but will create the missing key set if that's the problem
    if not CryptAcquireContextA(@fProviderHandle, nil, nil, PKI_PROVIDER_TYPE, CRYPT_NEWKEYSET) then
      // We've got bigger issues, let's not dork around
      raise EPKIEncryptionError.Create(getLastSystemError);
end;

destructor TPKIEncryptionEngine.Destroy;
begin
  if fProviderHandle <> 0 then
    CryptReleaseContext(fProviderHandle, 0);
  inherited;
end;

procedure TPKIEncryptionEngine.fLogEvent(const aMessage: string);
begin
  // Prevents nil pointer when not using logging
end;

procedure TPKIEncryptionEngine.setupCryptoServiceProvider;
var
  aRegistry: TRegistry;
const
  KEY_32 = '\SOFTWARE\vista\PKIEngine';
  KEY_64 = '\SOFTWARE\Wow6432Node\vista\PKIEngine';
begin
  aRegistry := TRegistry.Create(KEY_READ);
  try
    aRegistry.RootKey := HKEY_LOCAL_MACHINE;

    try
      if aRegistry.KeyExists(KEY_32) then
      begin
        aRegistry.OpenKeyReadOnly(KEY_32);
        setCSPName(aRegistry.ReadString('CSPName'));
        setHashAlgorithm(aRegistry.ReadString('HashAlgorithm'));
      end
      else if aRegistry.KeyExists(KEY_64) then
      begin
        aRegistry.OpenKeyReadOnly(KEY_64);
        setCSPName(aRegistry.ReadString('CSPName'));
        setHashAlgorithm(aRegistry.ReadString('HashAlgorithm'));
      end
      else
      begin
        setCSPName('ActivClient Cryptographic Service Provider');
        setHashAlgorithm('SHA1RSA');
      end;
    except
      raise EPKIEncryptionError.Create('Unable to properly setup the Crypto Service Provider (CSP)');
    end;

  finally
    aRegistry.CloseKey;
    aRegistry.Free;
  end;
end;

procedure TPKIEncryptionEngine.setCSPName(const aValue: string);
begin
  fCSPName := aValue;
end;

procedure TPKIEncryptionEngine.setHashAlgorithm(const aValue: string);
var
  aNewAlgorithm: TPKIHashAlgorithm;
begin
  for aNewAlgorithm := Low(TPKIHashAlgorithm) to High(TPKIHashAlgorithm) do
    if CompareText(PKI_HASH_ALGORITHM[aNewAlgorithm], aValue) = 0 then
    begin
      fHashAlgorithm := aNewAlgorithm;
      Exit;
    end;
  raise EPKIEncryptionError.CreateFmt('Invalid Hash Algorithm ''%s''', [aValue]);
end;

procedure TPKIEncryptionEngine.setOnLogEvent(const aOnLogEvent: TPKIEncryptionLogEvent);
begin
  if Assigned(aOnLogEvent) then
  begin
    fOnLogEvent := aOnLogEvent;
    fOnLogEvent(Format('%s logging started', [ClassName]));
    fOnLogEvent(Format('%s version: %s', [ClassName, getEngineVersion]));
  end
  else
  begin
    fOnLogEvent(Format('%s logging stopped', [ClassName]));
    fOnLogEvent := fLogEvent; // aka the bit bucket
  end;
end;

procedure TPKIEncryptionEngine.setVistASAN(aNewSAN: string);
begin
  fRPCBroker.RemoteProcedure := 'XUS PKI SET UPN';
  fRPCBroker.Param[0].PType := literal;
  fRPCBroker.Param[0].value := aNewSAN;
  fRPCBroker.Call;

  if fRPCBroker.Results.Count = 0 then
    raise EPKIEncryptionError.Create(DLG_89802049);

  if StrToIntDef(fRPCBroker.Results[0], 0) <> 1 then
    raise EPKIEncryptionError.Create(DLG_89802049);
end;

procedure TPKIEncryptionEngine.checkCertChain(aPCertContext: PCCERT_CONTEXT);
var
  aChainEngine: HCERTCHAINENGINE;
  aChainContext: PCCERT_CHAIN_CONTEXT;

  aEnhkeyUsage: CERT_ENHKEY_USAGE;
  aCertUsage: CERT_USAGE_MATCH;
  aChainPara: CERT_CHAIN_PARA;
  aChainConfig: CERT_CHAIN_ENGINE_CONFIG;

  i: integer;
begin
  try
    try
      aEnhkeyUsage.CUsageIdentifier := 0;
      aEnhkeyUsage.RgpszUsageIdentifier := nil;

      aCertUsage.DwType := USAGE_MATCH_TYPE_AND;
      aCertUsage.Usage := aEnhkeyUsage;

      aChainPara.CbSize := Sizeof(aChainPara);
      aChainPara.RequestedUsage := aCertUsage;

      aChainConfig.CbSize := Sizeof(CERT_CHAIN_ENGINE_CONFIG);
      aChainConfig.HRestrictedRoot := nil;
      aChainConfig.HRestrictedTrust := nil;
      aChainConfig.HRestrictedOther := nil;
      aChainConfig.CAdditionalStore := 0;
      aChainConfig.RghAdditionalStore := nil;
      aChainConfig.DwFlags := CERT_CHAIN_REVOCATION_CHECK_CHAIN;
      aChainConfig.DwUrlRetrievalTimeout := 30000;
      aChainConfig.MaximumCachedCertificates := 0;
      aChainConfig.CycleDetectionModulus := 0;

      // Create the nondefault certificate chain engine
      if CertCreateCertificateChainEngine(@aChainConfig, aChainEngine) then
        fOnLogEvent('Chain Engine Created')
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Build a chain using CertGetCertificateChain and the certificate retrieved
      if CertGetCertificateChain(aChainEngine, aPCertContext, nil, nil, @aChainPara, CERT_CHAIN_REVOCATION_CHECK_CHAIN, nil, aChainContext) then
        fOnLogEvent('The Chain Context has been created')
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Display some of the contents of the chain
      fOnLogEvent('The size of the chain context is ' + IntToStr(aChainContext.CbSize));
      fOnLogEvent(IntToStr(aChainContext.CChain) + ' simple chains found.');

      i := aChainContext.TrustStatus.DwErrorStatus;
      fOnLogEvent('Error status for the chain: ' + IntToStr(i));

      case i of
        CERT_TRUST_NO_ERROR:
          fOnLogEvent('No error found for this certificate or chain');

        CERT_TRUST_IS_NOT_TIME_VALID:
          raise EPKIEncryptionError.Create(DLG_89802020); // 'This certificate or one of the certificates in the certificate chain is not time-valid ');

        CERT_TRUST_IS_NOT_TIME_NESTED:
          raise EPKIEncryptionError.Create(DLG_89802023); // 'Certificates in the chain are not properly time - nested');

        CERT_TRUST_IS_REVOKED:
          raise EPKIEncryptionError.Create(DLG_89802032); // 'Trust for this certificate or one of the certificates in the certificate chain has been revoked');

        CERT_TRUST_IS_NOT_SIGNATURE_VALID:
          raise EPKIEncryptionError.Create(DLG_89802029); // 'The certificate or one of the certificates in the certificate chain does not have a valid signature');

        CERT_TRUST_IS_NOT_VALID_FOR_USAGE:
          raise EPKIEncryptionError.Create(DLG_89802030); // 'The certificate or certificate chain is not valid in its proposed usage');

        CERT_TRUST_IS_UNTRUSTED_ROOT:
          raise EPKIEncryptionError.Create(DLG_89802025); // 'The certificate or certificate chain is based on an untrusted root');

        CERT_TRUST_REVOCATION_STATUS_UNKNOWN:
          raise EPKIEncryptionError.Create(DLG_89802026); // 'The revocation status of the certificate or one of the certificates in the certificate chain is unknown');

        CERT_TRUST_IS_CYCLIC:
          raise EPKIEncryptionError.Create(DLG_89802027); // 'One of the certificates in the chain was issued by a certification authority that the original certificate had certified');

        CERT_TRUST_IS_PARTIAL_CHAIN:
          raise EPKIEncryptionError.Create(DLG_89802028); // 'The certificate chain is not complete');

        CERT_TRUST_CTL_IS_NOT_TIME_VALID:
          raise EPKIEncryptionError.Create(DLG_89802020); // 'A CTL used to create this chain was not time-valid');

        CERT_TRUST_CTL_IS_NOT_SIGNATURE_VALID:
          raise EPKIEncryptionError.Create(DLG_89802029); // 'A CTL used to create this chain did not have a valid signature');

        CERT_TRUST_CTL_IS_NOT_VALID_FOR_USAGE:
          raise EPKIEncryptionError.Create(DLG_89802030); // 'A CTL used to create this chain is not valid for this usage');
      else
        raise EPKIEncryptionError.CreateFmt(DLG_89802010 + 'An unknown error code returned from PChainContext.TrustStatus.DwErrorStatus [%d]', [i]);
      end;

      i := aChainContext.TrustStatus.DwInfoStatus;
      fOnLogEvent('Info status for the chain: ' + IntToStr(i));

      if (i and CERT_TRUST_HAS_EXACT_MATCH_ISSUER) = CERT_TRUST_HAS_EXACT_MATCH_ISSUER then
        fOnLogEvent('An exact match issuer certificate has been found for this certificate.');

      if (i and CERT_TRUST_HAS_KEY_MATCH_ISSUER) = CERT_TRUST_HAS_KEY_MATCH_ISSUER then
        fOnLogEvent('A key match issuer certificate has been found for this certificate.');

      if (i and CERT_TRUST_HAS_NAME_MATCH_ISSUER) = CERT_TRUST_HAS_NAME_MATCH_ISSUER then
        fOnLogEvent('A name match issuer certificate has been found for this certificate.');

      if (i and CERT_TRUST_IS_SELF_SIGNED) = CERT_TRUST_IS_SELF_SIGNED then
        fOnLogEvent('This certificate is self-signed.');

      if (i and CERT_TRUST_HAS_PREFERRED_ISSUER) = CERT_TRUST_HAS_PREFERRED_ISSUER then
        fOnLogEvent('This certificate has a preferred issuer.');

      if (i and CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY) = CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY then
        fOnLogEvent('An Issuance Chain Policy exists.');

      if (i and CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS) = CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS then
        fOnLogEvent('A valid name contraints for all namespaces, including UPN.');

      if (i and CERT_TRUST_IS_COMPLEX_CHAIN) = CERT_TRUST_IS_COMPLEX_CHAIN then
        fOnLogEvent('The certificate chain created is a complex chain.');

      fOnLogEvent('Certificate Chain Check OK');
    except
      on E: Exception do
      begin
        fOnLogEvent('Certificate Chain Check Failure');
        fOnLogEvent(E.Message);
        raise;
      end;
    end;
  finally
    if aChainEngine <> 0 then
      CertFreeCertificateChainEngine(aChainEngine);
    if aChainContext <> nil then
      CertFreeCertificateChain(aChainContext);
  end;
end;

procedure TPKIEncryptionEngine.checkCertRevocation(aPCertContext: PCCERT_CONTEXT);
var
  aRevStatus: CERT_REVOCATION_STATUS;
  argpvContext: array [0 .. 3] of pointer;
  i: integer;
begin
  try
    aRevStatus.CbSize := Sizeof(aRevStatus);
    aRevStatus.dwIndex := 0;
    aRevStatus.dwError := 0;

    for i := 0 to 3 do
      argpvContext[i] := nil;
    argpvContext[0] := aPCertContext;

    if CertVerifyRevocation(PKI_ENCODING_TYPE, CERT_CONTEXT_REVOCATION_TYPE, 1, @argpvContext[0], CERT_VERIFY_REV_SERVER_OCSP_FLAG, nil, @aRevStatus) then
      fOnLogEvent('OCSP - PASS')
    else
    begin
      fOnLogEvent('OCSP - FAIL');
      raise EPKIEncryptionError.Create(getLastSystemError);
    end;
  except
    raise;
  end;
end;

procedure TPKIEncryptionEngine.checkSignature(aDataString, aSignatureString: string; aDataTimeSigned: PFileTime = nil);
var
  i: integer;
  aPKIEncryptionData: IPKIEncryptionData;

  aSignature: AnsiString;

  aMessageHandle: HCRYPTMSG;
  aCert: PCCERT_CONTEXT;
  aCertStore: HCERTSTORE;

  aContent: AnsiString;
  aContentSize: DWORD;

  aSignerCert: array of DWORD;
  aSignerCertSize: DWORD;

  aNameString: string;
  aNameStringSize: DWORD;
begin
  aMessageHandle := nil;
  aCert := nil;
  aCertStore := nil;

  try
    try
      fOnLogEvent('********************************* VALIDATING SIGNATURE ************************');
      NewPKIEncryptionData(aPKIEncryptionData);
      aPKIEncryptionData.Buffer := aDataString;
      HashData(aPKIEncryptionData);

      fOnLogEvent('Data Hash Value: ' + string(aPKIEncryptionData.getHashValue));
      fOnLogEvent('Data Hash Text:  ' + string(aPKIEncryptionData.HashText));

      aSignature := MimeDecodeString(AnsiString(aSignatureString));

      // Open a msg
      aMessageHandle := CryptMsgOpenToDecode(PKI_ENCODING_TYPE, 0, 0, 0, nil, nil);
      if aMessageHandle = nil then
        raise EPKIEncryptionError.Create(getLastSystemError)
      else
        fOnLogEvent('Successfully retrieved a new Message Handle');

      // Add the signature
      if CryptMsgUpdate(aMessageHandle, pointer(aSignature), Length(aSignature) + 1, True) then // Handle to the message
        fOnLogEvent('The encoded blob has been added to the message')
      else
        raise EPKIEncryptionError.Create(DLG_89802015);

      // Get the number of bytes needed for the content
      if CryptMsgGetParam(aMessageHandle, CMSG_CONTENT_PARAM, 0, nil, @aContentSize) then
        fOnLogEvent('Hash value size as been retrieved at ' + IntToStr(aContentSize))
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Allocate memory and get the content
      SetLength(aContent, aContentSize + 1);
      if CryptMsgGetParam(aMessageHandle, CMSG_CONTENT_PARAM, 0, pointer(aContent), @aContentSize) then
        fOnLogEvent('Content has been retrieved')
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      fOnLogEvent('Hash Value From The Message: ' + string(aContent));
      fOnLogEvent('Hash Value From Message as MIME: ' + string(MimeEncodeString(aContent)));
      fOnLogEvent('Hash Value From The Data:    ' + string(aPKIEncryptionData.getHashValue));

      if AnsiCompareStr(string(aContent), string(aPKIEncryptionData.getHashValue)) = 0 then
        fOnLogEvent('Hash Values Match')
      else
        raise EPKIEncryptionError.Create(DLG_89802016);

      // Verify the signature
      if CryptMsgGetParam(aMessageHandle, CMSG_SIGNER_CERT_INFO_PARAM, 0, nil, @aSignerCertSize) then
        fOnLogEvent('Retrieved length of SignerCert: ' + IntToStr(aSignerCertSize))
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Allocate Memory and get the signers CERT_INFO
      SetLength(aSignerCert, aSignerCertSize + 1);
      if CryptMsgGetParam(aMessageHandle, CMSG_SIGNER_CERT_INFO_PARAM, 0, pointer(aSignerCert), @aSignerCertSize) then
        fOnLogEvent('Cert Info retrieved')
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Open a certificate store in memory using CERT_STORE_PROV_MSG which initializes it with the certificates from the MSG
      aCertStore := CertOpenStore(CERT_STORE_PROV_MSG, PKI_ENCODING_TYPE, 0, 0, aMessageHandle);
      if aCertStore = nil then
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Find the signer's cert in the store
      aCert := CertGetSubjectCertificateFromStore(aCertStore, PKI_ENCODING_TYPE, pointer(aSignerCert));
      if aCert = nil then
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Get the name size and allocate for it - includes null terminator here
      // aNameStringSize := CertGetNameStringA(aCert, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, nil, 0);
      aNameStringSize := CertGetNameString(aCert, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, nil, 0);
      if aNameStringSize = 0 then
        raise EPKIEncryptionError.Create(getLastSystemError)
      else
        SetLength(aNameString, aNameStringSize);

      // Get the Cert Name
      // if CertGetNameStringA(aCert, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, pointer(aNameString), aNameStringSize) = 0 then
      if CertGetNameString(aCert, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, PWideChar(aNameString), aNameStringSize) = 0 then
        raise EPKIEncryptionError.Create(DLG_89802033) // 'Error getting name value')
      else
        fOnLogEvent('Got the name from the cert: ' + string(aNameString) + ' <<<<<<==================');

      // Use the CERT_INFO from the signer Cert to Verify the signature
      if CryptMsgControl(aMessageHandle, 0, CMSG_CTRL_VERIFY_SIGNATURE, aCert.pCertInfo) then
        fOnLogEvent('Digital signature verified')
      else
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Verify the date/time signed
      i := CertVerifyTimeValidity(nil, aCert.pCertInfo);
      case i of
        - 1:
          raise EPKIEncryptionError.Create(DLG_89802019); // 'Before certificate effective date');
        1:
          raise EPKIEncryptionError.Create(DLG_89802020); // 'Certificate is expired');
      else
        fOnLogEvent('Certificate Time Validty - PASS');
      end;

      fOnLogEvent('Checking Certificate Chain');
      checkCertChain(aCert);

      fOnLogEvent('Checking Certificate for OCSP Revocation');
      checkCertRevocation(aCert);
    except
      raise;
    end;
  finally
    if aMessageHandle <> nil then
      CryptMsgClose(aMessageHandle);

    if aCert <> nil then
      CertFreeCertificateContext(aCert);

    if Assigned(aCertStore) then
      CertCloseStore(aCertStore, CERT_CLOSE_STORE_FORCE_FLAG);
  end;
end;

function TPKIEncryptionEngine.getIsCardReaderReady: boolean;
var
  aActiveProtocol: DWORD;
  aCardName: AnsiString;
  aFHCard: LongInt;
  aReaders: AnsiString;
  aSCardContext: LongInt;
  aSize: LongInt;
begin
  try
    fOnLogEvent('Establishing Context with the Card Reader');
    if SCardEstablishContext(SCARD_SCOPE_USER, nil, nil, @aSCardContext) <> PKI_SCARD_S_SUCCESS then
      raise EPKIEncryptionError.Create(DLG_89802034); // 'No Context');

    // Get the size needed for the card readers
    fOnLogEvent('Getting proper buffer size');
    SCardListReadersA(aSCardContext, nil, nil, aSize);
    SetLength(aReaders, aSize);

    // Get the card readers in aReaders
    fOnLogEvent('Getting Card Readers');
    if SCardListReadersA(aSCardContext, nil, PAnsiChar(aReaders), aSize) <> PKI_SCARD_S_SUCCESS then
      raise EPKIEncryptionError.Create(DLG_89802006); // 'Unable to access card reader');

    // Walk the list of readers and grab the first one that is valid
    while Length(aReaders) > 1 do
    begin
      aCardName := AnsiString(Copy(aReaders, 1, Pos(#0, string(aReaders))));
      fOnLogEvent('Got Card Reader: ' + string(aCardName));
      aReaders := Copy(aReaders, Length(aCardName) + 1, Length(aReaders));
      if SCardConnectA(aSCardContext, PAnsiChar(aCardName), SCARD_SHARE_SHARED, 3, aFHCard, @aActiveProtocol) = PKI_SCARD_S_SUCCESS then
      begin
        fOnLogEvent('Successfully established context with Card Reader: ' + string(aCardName));
        Result := True;
        Exit;
      end
      else
        fOnLogEvent('Unable to establish context with Card Reader: ' + string(aCardName));
    end;

    Result := False;
  except
    on EPKIEncryptionError do
      raise;
    on E: Exception do
      raise EPKIEncryptionError.Create(DLG_89802010 + E.Message);
  end;
end;

function TPKIEncryptionEngine.getCertContext: PCCERT_CONTEXT;
var
  i: integer;
  isFound: boolean;
  aDWord: DWORD;
  aByte: Byte;
  aPByte: PByte;
  aPBArray: PByteArray;
  aHCertStore: HCERTSTORE;
  aPCertContext: PCCERT_CONTEXT;
  aCertNameLength: DWORD;
  aCertSerialNumber: string;
  aCertDisplayName: string;
  aCertEMailName: string;
  isCertSigning: boolean;
  isDisplayNameCorrect: boolean;
  aVistAUserName: string;
  aVistASAN: string;
begin
  Result := nil;

  aHCertStore := CertOpenSystemStoreA(0, PAnsiChar('MY'));

  if aHCertStore = nil then
    raise EPKIEncryptionError.Create(DLG_89802010 + 'Could not open the ''MY'' Cert Store');

  aVistAUserName := getVistAUserName; { This method checks for existence of fRPCBroker }
  if aVistAUserName = '' then
    raise EPKIEncryptionError.Create(DLG_89802010 + 'Unable to get certificate without VistA User Name');

  { If this exists, the cert must have it in the EMAIL name,
    otherwise, it tries to find it via the users last name }
  aVistASAN := getSANFromVistA;

  aPCertContext := CertEnumCertificatesInStore(aHCertStore, nil);
  isFound := False;

  while (aPCertContext <> nil) and (not isFound) do
    try
      fOnLogEvent('--------------------------------------------------------------------------');
      if aVistASAN = '' then
      begin
        fOnLogEvent('No SAN passed in, trying to match on ' + getVistAUserName);
        aCertNameLength := CertGetNameString(aPCertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, nil, 0);
        SetLength(aCertDisplayName, aCertNameLength);
        if (CertGetNameString(aPCertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, PWideChar(aCertDisplayName), aCertNameLength) > 1) then
          while Copy(aCertDisplayName, Length(aCertDisplayName), 1) = #0 do
            aCertDisplayName := Copy(aCertDisplayName, 1, Length(aCertDisplayName) - 1)
        else
          raise Exception.Create('Error in CertGetNameString');

        fOnLogEvent(Format('CERT_NAME_SIMPLE_DISPLAY_TYPE    = %s', [aCertDisplayName]));
        fOnLogEvent('VistA Name = ' + getVistAUserName);

        isDisplayNameCorrect := (Pos(UpperCase(Copy(aCertDisplayName, 1, 1)), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') > 0) and // Starts with a character
          (Pos(Copy(aCertDisplayName, Length(aCertDisplayName), 1), '0123456789)') > 0) and // Ends with a number or paren
          (Pos(UpperCase(Copy(aVistAUserName, 1, Pos(',', aVistAUserName) - 1)), UpperCase(aCertDisplayName)) > 0); // Contains the users last name from VistA - Not the best but oh well :(

        if not isDisplayNameCorrect then
        begin
          fOnLogEvent('Invalid Display Name');
          Continue;
        end
        else
        begin
          fOnLogEvent('Name match successful');
        end
      end
      else { We have a SAN, we must match it exactly }
      begin
        fOnLogEvent('VistA SAN exists, trying to match on ' + aVistASAN);
        aCertEMailName := '';
        aCertNameLength := CertGetNameString(aPCertContext, CERT_NAME_EMAIL_TYPE, 0, 0, nil, 0);
        SetLength(aCertEMailName, aCertNameLength);
        CertGetNameString(aPCertContext, CERT_NAME_EMAIL_TYPE, 0, 0, PWideChar(aCertEMailName), aCertNameLength);

        while Copy(aCertEMailName, Length(aCertEMailName), 1) = #0 do
          aCertEMailName := Copy(aCertEMailName, 1, Length(aCertEMailName) - 1);
        fOnLogEvent(Format('CERT_NAME_EMAIL_TYPE = %s', [aCertEMailName]));

        if aCertEMailName = '' then
        begin
          fOnLogEvent('Blank CERT_NAME_EMAIL_TYPE');
          Continue;
        end
        else
        begin
          if CompareText(aVistASAN, aCertEMailName) <> 0 then
          begin
            fOnLogEvent('SAN Mismatch on certificate');
            Continue;
          end;
        end;
      end;

      // Get the Cert serialNumber and convert to Hex
      aDWord := aPCertContext.pCertInfo.SerialNumber.CbData;
      aPBArray := PByteArray(aPCertContext.pCertInfo.SerialNumber.PbData);

      aCertSerialNumber := '';
      for i := aDWord - 1 downto 0 do
      begin
        aCertSerialNumber := aCertSerialNumber + IntToHex(Byte(aPBArray[i]), 2);
        if i > 0 then
          aCertSerialNumber := aCertSerialNumber + ' ';
      end;
      fOnLogEvent(Format('CertSerialNum: %s', [aCertSerialNumber]));

      aPByte := @aByte;
      if CertGetIntendedKeyUsage(PKI_ENCODING_TYPE, aPCertContext.pCertInfo, aPByte, 1) then
        i := aByte
      else
        i := 0;

      fOnLogEvent(Format('Required Intended Purposes: %d', [i]));

      // CERT_DIGITAL_SIGNATURE_KEY_USAGE = $80;
      fOnLogEvent(Format('CERT_DIGITAL_SIGNATURE_KEY_USAGE = %s', [BoolToStr(((i and CERT_DIGITAL_SIGNATURE_KEY_USAGE) = CERT_DIGITAL_SIGNATURE_KEY_USAGE), True)]));

      // CERT_NON_REPUDIATION_KEY_USAGE = // $40;
      fOnLogEvent(Format('CERT_NON_REPUDIATION_KEY_USAGE   = %s', [BoolToStr(((i and CERT_NON_REPUDIATION_KEY_USAGE) = CERT_NON_REPUDIATION_KEY_USAGE), True)]));

      isCertSigning := ((i and CERT_DIGITAL_SIGNATURE_KEY_USAGE) = CERT_DIGITAL_SIGNATURE_KEY_USAGE) and ((i and CERT_NON_REPUDIATION_KEY_USAGE) = CERT_NON_REPUDIATION_KEY_USAGE); // then // Official and correct

      if not isCertSigning then
      begin
        fOnLogEvent('Cannot digitally sign with non-repudiation with this one');
        Continue;
      end;

      if not(CertVerifyTimeValidity(nil, aPCertContext.pCertInfo) = 0) then
      begin
        fOnLogEvent('CertVerifyTimeValidity has failed');
        Continue;
      end;

      // We have a valid candidate check the chain and the revocation
      try
        checkCertChain(aPCertContext);
        checkCertRevocation(aPCertContext);

        isFound := True;
        Result := aPCertContext;
        fOnLogEvent('This is the cert!');
      except
        on E: Exception do
          fOnLogEvent(E.Message);
      end;
    finally
      // Continue will ALWAYS take us here and then back into the loop - Gets next cert only if not found
      if not isFound then
        aPCertContext := CertEnumCertificatesInStore(aHCertStore, aPCertContext);
    end;
end;

procedure TPKIEncryptionEngine.GetCertificates(aList: TStrings);
var
  aProvider: PHCRYPTPROV;
  aHCertStore: HCERTSTORE;
  aPCertContext: PCCERT_CONTEXT;
  aPKICertificate: TPKIEncryptionCertificate;
begin
  aList.Clear;

  if not CryptAcquireContextA(@aProvider, nil, nil, PKI_ACTIVE_CLIENT_TYPE, 0) then
    raise Exception.Create('Cannot get context.');

  aHCertStore := CertOpenSystemStoreA(0, PAnsiChar('MY'));

  if aHCertStore = nil then
    raise EPKIEncryptionError.Create(DLG_89802010 + 'Could not open the ''MY'' Cert Store');

  aPCertContext := CertEnumCertificatesInStore(aHCertStore, nil);

  while (aPCertContext <> nil) do
    try
      aPKICertificate := TPKIEncryptionCertificate.Create(aPCertContext);
      aList.AddObject(aPKICertificate.CertFriendlyName, aPKICertificate);
    finally
      aPCertContext := CertEnumCertificatesInStore(aHCertStore, aPCertContext);
    end;

  if Assigned(aHCertStore) then
    CertCloseStore(aHCertStore, CERT_CLOSE_STORE_FORCE_FLAG);
end;

function TPKIEncryptionEngine.getCSPName: string;
begin
  Result := fCSPName;
end;

function TPKIEncryptionEngine.getEngineVersion: string;
begin
  Result := PKI_ENGINE_VERSION;
end;

function TPKIEncryptionEngine.getHashAlgorithm: string;
begin
  Result := PKI_HASH_ALGORITHM[fHashAlgorithm];
end;

function TPKIEncryptionEngine.getSANFromCard: string;
var
  aPCertContext: PCCERT_CONTEXT;
  aCertEMailName: string;
  aCertNameLength: DWORD;
begin
  fOnLogEvent('TPKIEncryption.GetSANFromCard');

  aPCertContext := getCertContext;

  if aPCertContext = nil then
    raise EPKIEncryptionError.Create(DLG_89802004); // 'Unable to get Certificate');

  aCertEMailName := '';
  aCertNameLength := CertGetNameString(aPCertContext, CERT_NAME_EMAIL_TYPE, 0, 0, nil, 0);
  SetLength(aCertEMailName, aCertNameLength);
  CertGetNameString(aPCertContext, CERT_NAME_EMAIL_TYPE, 0, 0, PWideChar(aCertEMailName), aCertNameLength);
  while Copy(aCertEMailName, Length(aCertEMailName), 1) = #0 do
    aCertEMailName := Copy(aCertEMailName, 1, Length(aCertEMailName) - 1);

  fOnLogEvent(Format('CERT_NAME_EMAIL_TYPE = %s', [aCertEMailName]));
  Result := string(aCertEMailName);
end;

function TPKIEncryptionEngine.getSANFromVistA: string;
begin
  fRPCBroker.RemoteProcedure := 'XUS PKI GET UPN';
  fRPCBroker.Call;

  if fRPCBroker.Results.Count > 0 then
    Result := fRPCBroker.Results[0]
  else
    Result := '';
end;

function TPKIEncryptionEngine.getVistAUserName: string;
begin
  if Assigned(fRPCBroker) then
    Result := fRPCBroker.User.Name
  else
    Result := '';
end;

(*
  This is the internal private method accessible only from within this object.
  Any errors that we know about will be raised as an EPKIEncryptionError
*)
procedure TPKIEncryptionEngine.hashBuffer(aBuffer: string; var aHashText: AnsiString; var aHashValue: AnsiString; var aHashHex: AnsiString);
var
  i: integer;
  aHashData: AnsiString;
  aHashLength: DWORD;
  aHashHandle: HCRYPTHASH;

  function ByteToHex(InByte: Byte): ShortString;
  const
    Digits: array [0 .. 15] of char = '0123456789ABCDEF';
  begin
    Result := ShortString(Digits[InByte shr 4]) + ShortString(Digits[InByte and $0F]);
  end;

begin
  try
    fOnLogEvent('Calling CryptCreateHash');
    if (not CryptCreateHash(fProviderHandle, CALG_SHA_256, 0, 0, @aHashHandle)) then
    begin
      i := GetLastError;
      fOnLogEvent(Format('%d: %s', [i, SysErrorMessage(i)]));
      raise EPKIEncryptionError.Create(getLastSystemError);
    end
    else
      fOnLogEvent('Successfully created hash object in CryptCreateHash');

    // Actually do the hashing
    fOnLogEvent('Hashing: ' + aBuffer);
    aHashData := AnsiString(aBuffer);
    if not CryptHashData(aHashHandle, PByte(aHashData), Length(aHashData), 0) then
      raise EPKIEncryptionError.Create(getLastSystemError);

    // See how big the hash value is
    fOnLogEvent('Going to Get Hash Value Length');
    if CryptGetHashParam(aHashHandle, HP_HASHVAL, nil, @aHashLength, 0) <> True then
    begin
      i := GetLastError;
      fOnLogEvent(Format('%d: %s', [i, SysErrorMessage(i)]));
      raise EPKIEncryptionError.Create(getLastSystemError);
    end;

    // Retrieve the hash value - Note MUST BE PByte()
    fOnLogEvent('Going to Get Hash Value Data');
    SetLength(aHashValue, aHashLength);
    if CryptGetHashParam(aHashHandle, HP_HASHVAL, PByte(aHashValue), @aHashLength, 0) <> True then
    begin
      i := GetLastError;
      fOnLogEvent(Format('%d: %s', [i, SysErrorMessage(i)]));
      raise EPKIEncryptionError.Create(getLastSystemError);
    end;

    aHashHex := '';
    for i := 1 to Length(aHashValue) do
      aHashHex := aHashHex + ByteToHex(Byte(aHashValue[i]));

    aHashText := '';
    SetLength(aHashText, MimeEncodedSize(aHashLength));
    aHashText := MimeEncodeString(aHashValue);

    CryptDestroyHash(aHashHandle);
  except
    if aHashHandle <> 0 then
      CryptDestroyHash(aHashHandle);
    raise;
  end;
end;

function TPKIEncryptionEngine.getSANLink: TPKISANLink;
var
  aVistASAN: string;
  aPIVCardSAN: string;
begin
  try
    aVistASAN := getSANFromVistA;

    aPIVCardSAN := getSANFromCard;

    fOnLogEvent(Format('Comparing the following values ''%s'' and ''%s''', [aVistASAN, aPIVCardSAN]));

    if CompareText(aPIVCardSAN, '') = 0 then
      Result := slNoCertFound
    else if CompareText(aVistASAN, '') = 0 then
      Result := slBlankVistA
    else if CompareText(aPIVCardSAN, aVistASAN) <> 0 then
      Result := slMisMatch
    else
      Result := slOK;
  except
    on EBrokerError do
      Result := slVistAError;
    on EPKIEncryptionError do
      Result := slNoCertFound;
    on Exception do
      Result := slError;
  end;
end;

procedure TPKIEncryptionEngine.ClearPIN;
begin
  fCurrentPIN := '';
end;

procedure TPKIEncryptionEngine.ValidateSignature(aPKIEncryptionSignature: IPKIEncryptionSignature);
begin
  try
    checkSignature(aPKIEncryptionSignature.DataString, aPKIEncryptionSignature.Signature, nil);
  except
    raise;
  end;
end;

procedure TPKIEncryptionEngine.SignData(aPKIEncryptionData: IPKIEncryptionData);
var
  // aSignatureSuccess: boolean;
  RgpbToBeSigned: array [0 .. 0] of PByte;
  RgcbToBeSigned: array [0 .. 0] of PDWORD;

  // aPByte: PByte;

  // aMessage: string;
  aHashValue: AnsiString;
  aHashValueLength: DWORD;
  aSignature: AnsiString;
  aSignatureLength: DWORD;
  aSignatureStr: string;
  aSignMsgParam: CRYPT_SIGN_MESSAGE_PARA;
  aPKIEncryptionDataEx: IPKIEncryptionDataEx;
  aPCertContext: PCCERT_CONTEXT;
begin
  try
    // This will check to see if the current PIN has already been entered for this object lifecycle
    {
      if fCurrentPIN = '' then
      raise EPKIEncryptionError.Create(DLG_89802014)
      else if not getIsValidPIN(fCurrentPIN, aMessage) then
      raise EPKIEncryptionError.Create(DLG_89802014);
    }
    fOnLogEvent('Signing data: ' + aPKIEncryptionData.Buffer);

    aPKIEncryptionData.Validate; // virtual methods shall raise exception if not valid for signing

    HashData(aPKIEncryptionData); // Hashes data from getBuffer

    fOnLogEvent('We have hashed the data successfully');

    if aPKIEncryptionData.QueryInterface(IPKIEncryptionDataEx, aPKIEncryptionDataEx) <> 0 then
      raise EPKIEncryptionError.Create(DLG_89802031);

    if getSANFromVistA = '' then
      raise EPKIEncryptionError.Create(DLG_89802048)
    else
      aPCertContext := getCertContext;

    if aPCertContext = nil then
      raise EPKIEncryptionError.Create(DLG_89802004)
    else
      fOnLogEvent('Got the CertContext Successfully');

    aSignMsgParam.CbSize := Sizeof(CRYPT_SIGN_MESSAGE_PARA);
    aSignMsgParam.PvHashAuxInfo := nil;
    aSignMsgParam.cMsgCert := 0;
    aSignMsgParam.RgpMsgCert := nil;
    aSignMsgParam.CMsgCrl := 0;
    aSignMsgParam.RgpMsgCrl := nil;
    aSignMsgParam.CAuthAttr := 0;
    aSignMsgParam.RgAuthAttr := nil;
    aSignMsgParam.CUnauthAttr := 0;
    aSignMsgParam.RgUnauthAttr := nil;
    aSignMsgParam.DwFlags := 0;
    aSignMsgParam.DwInnerContentType := 0;
    aSignMsgParam.PSigningCert := aPCertContext;
    aSignMsgParam.DwMsgEncodingType := PKI_ENCODING_TYPE;

    case fHashAlgorithm of
      ha128:
        aSignMsgParam.HashAlgorithm.PszObjId := szOID_RSA_SHA1RSA;
      ha256:
        aSignMsgParam.HashAlgorithm.PszObjId := szOID_RSA_SHA256RSA;
      ha384:
        aSignMsgParam.HashAlgorithm.PszObjId := szOID_RSA_SHA384RSA;
      ha512:
        aSignMsgParam.HashAlgorithm.PszObjId := szOID_RSA_SHA512RSA;
    else
      aSignMsgParam.HashAlgorithm.PszObjId := szOID_RSA_SHA1RSA;
    end;

    aSignMsgParam.HashAlgorithm.Parameters.CbData := 0;

    // The Signing Cert
    aSignMsgParam.cMsgCert := 1;
    aSignMsgParam.RgpMsgCert := @aPCertContext;

    // The data to be signed and its length
    aHashValue := aPKIEncryptionDataEx.getHashValue;
    aHashValueLength := Length(aHashValue);

    RgpbToBeSigned[0] := @aHashValue;
    RgcbToBeSigned[0] := @aHashValueLength;

    aSignatureLength := 0;

    { Get the size of the signature first }
    if CryptSignMessage(@aSignMsgParam, False, 1, RgpbToBeSigned[0], RgcbToBeSigned[0], nil, @aSignatureLength) then
      fOnLogEvent('Successfully retrieved the required size of the signature: ' + IntToStr(aSignatureLength))
    else
      raise EPKIEncryptionError.Create(getLastSystemError);

    SetLength(aSignature, aSignatureLength + 1);

    if CryptSignMessage(@aSignMsgParam, False, 1, RgpbToBeSigned[0], RgcbToBeSigned[0], PByte(aSignature), @aSignatureLength) then
      fOnLogEvent('Successfully signed the message.')
    else
      raise EPKIEncryptionError.Create(getLastSystemError);

    SetLength(aSignatureStr, MimeEncodedSize(Length(aSignature)));

    aSignatureStr := string(MimeEncodeString(aSignature));

    fOnLogEvent('Signature Data: ' + aPKIEncryptionData.Buffer);
    fOnLogEvent('Signature HashText: ' + aPKIEncryptionData.HashText);
    fOnLogEvent('Signature Data as MIME: ' + aSignatureStr);

    aPKIEncryptionDataEx.setSignature(aSignatureStr); // String(MimeEncodeString(aSignature)));
    aPKIEncryptionDataEx.setDateTimeSigned(Now);

    { debug - Uncomment the lines below to immediately pass back the signature string for validation

      fOnLogEvent('checking the signature as is');
      checkSignature(aPKIEncryptionData.Buffer, aSignatureStr);
      fOnLogEvent('we are back from checking the signature');

      debug }
  except
    on E: EPKIEncryptionError do
      raise;
    on E: Exception do
      raise EPKIEncryptionError.Create(DLG_89802010 + E.Message);
  end;
end;

procedure TPKIEncryptionEngine.HashData(aPKIEncryptionData: IPKIEncryptionData);
(*
  This is the public method that calls the internal method for actual hashing and
  then updates the values in the IPKIEncryptionData object.

  All known errors are raised as EPKIEncryptionErrors.
*)
var
  aHashText: AnsiString;
  aHashValue: AnsiString;
  aHashHexValue: AnsiString;
  aPKIEncryptionDataEx: IPKIEncryptionDataEx;
begin
  fOnLogEvent('Entered TPKIEncryption.HashData(aPKIEncryptionData: IPKIEncryptionData);');
  try
    hashBuffer(aPKIEncryptionData.Buffer, aHashText, aHashValue, aHashHexValue);
    if aPKIEncryptionData.QueryInterface(IPKIEncryptionDataEx, aPKIEncryptionDataEx) = 0 then
    begin
      aPKIEncryptionDataEx.setHashValue(aHashValue);
      aPKIEncryptionDataEx.setHashText(aHashText);
      aPKIEncryptionDataEx.setHashHex(aHashHexValue);
    end;
  except
    raise;
  end;
end;

procedure TPKIEncryptionEngine.LinkSANtoVistA;
var
  aPIVCardSAN: string;
begin
  try
    fOnLogEvent(Format('Linking PIV Card SAN to VistA Account ''%s (DUZ:%s)''', [fRPCBroker.User.Name, fRPCBroker.User.DUZ]));

    aPIVCardSAN := getSANFromCard;

    if CompareText(aPIVCardSAN, '') = 0 then
      raise EPKIEncryptionError.Create(DLG_89802041);

    setVistASAN(aPIVCardSAN);
  except
    on EBrokerError do
      raise EPKIEncryptionError.Create(DLG_89802047); // Lets user know the broker copped a 'tude
    else
      raise;
  end;
end;

procedure TPKIEncryptionEngine.SaveSignature(aPKIEncryptionData: IPKIEncryptionData);
begin
  // Future development - Need to save the signature so other clients don't have to bang on the PKI files
end;

procedure TPKIEncryptionEngine.DisplayProviders; // Requires a valid fOnLogEvent
var
  dwIndex: DWORD;
  DwType: DWORD;
  dwName: DWORD;
  DwFlags: DWORD;
  aName: AnsiString;
  PbData: array [0 .. 1024] of Byte;
  CbData: DWORD;
  aiAlgid: ALG_ID;
  paiAlgid: ^ALG_ID;
  aAlgType: string;
  dwBits: DWORD;
  pdwBits: ^DWORD;
  dwNameLen: DWORD;
  pdwNameLen: ^DWORD;
  i, j: integer;
begin
  fOnLogEvent('DISPLAY PROVIDERS - START');
  fOnLogEvent('');
  fOnLogEvent('Provider Types');
  fOnLogEvent('--------------');

  dwIndex := 0;
  while CryptEnumProviderTypesA(dwIndex, nil, 0, @DwType, nil, @dwName) do
  begin
    SetLength(aName, dwName);
    if CryptEnumProviderTypesA(dwIndex, nil, 0, @DwType, PAnsiChar(aName), @dwName) then
      fOnLogEvent(Format('%0.4d: %s', [DwType, string(aName)]));
    inc(dwIndex);
  end;

  fOnLogEvent('');
  fOnLogEvent('Providers');
  fOnLogEvent('---------');
  dwIndex := 0;
  while CryptEnumProvidersA(dwIndex, nil, 0, @DwType, nil, @dwName) = True do
  begin
    SetLength(aName, dwName);
    if CryptEnumProvidersA(dwIndex, nil, 0, @DwType, PAnsiChar(aName), @dwName) then
      fOnLogEvent(Format('%0.4d: %s', [DwType, string(aName)]));
    inc(dwIndex);
  end;

  fOnLogEvent('');
  fOnLogEvent('Default Provider for PKI Operations');
  fOnLogEvent('-----------------------------------');
  if CryptGetDefaultProviderA(PKI_PROVIDER_TYPE, 0, CRYPT_MACHINE_DEFAULT, nil, @dwName) then
  begin
    SetLength(aName, dwName);
    CryptGetDefaultProviderA(PKI_PROVIDER_TYPE, 0, CRYPT_MACHINE_DEFAULT, PAnsiChar(aName), @dwName);
    fOnLogEvent(Format('%s', [string(aName)]));
  end;

  fOnLogEvent('');
  fOnLogEvent('Supported Algorithms');
  fOnLogEvent(Format('%-8s  %4s  %-15s %s', ['ID', 'Bits', 'Type', 'Name']));
  fOnLogEvent('-----------------------------------------------------------------');

  CbData := 1024;
  for i := 0 to 1023 do
    PbData[i] := 0;

  DwFlags := CRYPT_FIRST;
  while CryptGetProvParam(fProviderHandle, PP_ENUMALGS, @PbData[0], @CbData, DwFlags) do
  begin
    DwFlags := CRYPT_NEXT;
    i := 0;

    paiAlgid := @PbData[i];
    aiAlgid := paiAlgid^;
    inc(i, Sizeof(aiAlgid));

    pdwBits := @PbData[i];
    dwBits := pdwBits^;
    inc(i, Sizeof(dwBits));

    pdwNameLen := @PbData[i];
    dwNameLen := pdwNameLen^;
    inc(i, Sizeof(dwNameLen));

    SetLength(aName, dwNameLen);
    for j := 0 to dwNameLen - 1 do
      aName[j + 1] := AnsiChar(PbData[i + j]);

    case GET_ALG_CLASS(aiAlgid) of
      ALG_CLASS_ANY:
        aAlgType := 'Any';
      ALG_CLASS_SIGNATURE:
        aAlgType := 'Signature';
      ALG_CLASS_MSG_ENCRYPT:
        aAlgType := 'Message Encrypt';
      ALG_CLASS_DATA_ENCRYPT:
        aAlgType := 'Data Encrypt';
      ALG_CLASS_HASH:
        aAlgType := 'Hash';
      ALG_CLASS_KEY_EXCHANGE:
        aAlgType := 'Exchange';
    else
      aAlgType := 'Unknown';
    end;

    fOnLogEvent(Format('%.8x  %4d  %-15s %s', [aiAlgid, dwBits, string(aAlgType), string(aName)]));
  end;
  fOnLogEvent('DISPLAY PROVIDERS - END');
end;

function TPKIEncryptionEngine.getIsValidPIN(const aPKIPIN: string; var aMessage: string): boolean;
var
  aHandle: DWORD;
  aPinValue: AnsiString;
  aCSPName: AnsiString;
begin
  try
    // Result := False;
    aCSPName := AnsiString(fCSPName);
    fOnLogEvent('Checking Card Reader Status');
    if not getIsCardReaderReady then
      raise EPKIEncryptionError.Create(DLG_89802035);

    fOnLogEvent('Acquiring Context for ' + fCSPName);
    if CryptAcquireContextA(@aHandle, PAnsiChar(''), PAnsiChar(aCSPName), PKI_ACTIVE_CLIENT_TYPE, 0) then
      try
        // Store this internally so it can be present multiple times for multiple signing or until cleared
        fCurrentPIN := aPKIPIN;
        // Get an AnsiString copy for the DLL
        aPinValue := AnsiString(aPKIPIN);

        fOnLogEvent('Setting Provider Parameter');
        if CryptSetProvParam(aHandle, PP_SIGNATURE_PIN, PByte(aPinValue), 0) then
        begin
          aMessage := 'PIN Verified';
          fOnLogEvent(aMessage);
          Result := True;
        end
        else
          raise EPKIEncryptionError.Create(getLastSystemError);
      except
        on E: Exception do
        begin
          fCurrentPIN := '';
          aMessage := E.Message;
          fOnLogEvent(aMessage);
          Result := False;
        end;
      end
    else
    begin
      fCurrentPIN := '';
      aMessage := SysErrorMessage(GetLastError);
      fOnLogEvent(aMessage);
      Result := False;
    end;
  finally
    if aHandle <> 0 then
      CryptReleaseContext(aHandle, 0);
  end;
end;

end.
