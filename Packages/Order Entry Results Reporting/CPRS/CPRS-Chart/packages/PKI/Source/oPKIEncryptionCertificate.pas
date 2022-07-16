unit oPKIEncryptionCertificate;

interface

uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  wcrypt2,
  WinSCard,
  oPKIEncryption
  {oPKIEncryptionEx};

type
  TPKIEncryptionCertificate = class(TObject)
  private
    fCertFriendlyName: string;
    fCertSerialNumber: string;
    fCertNameUPNType: string;
    fCertNameEMailType: string;

    fCertIntendedPurposes: integer;

    fCertChainInfoStatus: integer;
    fCertChainSize: integer;
    fCertChainCount: integer;
    fCertChainErrorStatus: integer;

    function open(aCertificate: PCCERT_CONTEXT): boolean;

    function getCertFriendlyName: string;
    function getCertSerialNumber: string;
    function getCertNameEMailType: string;
    function getCertNameUPNType: string;

    // Chain Info
    function getCertChainInfoStatus: integer;
    function getCertChainSize: integer;
    function getCertChainCount: integer;
    function getCertTrustHasExactMatchIssuer: boolean;
    function getCertTrustHasKeyMatchIssuer: boolean;
    function getCertTrustHasNameMatchIssuer: boolean;
    function getCertTrustIsSelfSigned: boolean;
    function getCertTrustHasPreferredIssuer: boolean;
    function getCertTrustHasIssuanceChainPolicy: boolean;
    function getCertTrustHasValidNameConstraints: boolean;
    function getCertTrustIsComplexChain: boolean;

    // Chain Error
    function getCertChainErrorStatus: integer;
    function getCertTrustNoError: boolean;
    function getCertTrustIsNotTimeValid: boolean;
    function getCertTrustIsNotTimeNested: boolean;
    function getCertTrustIsRevoked: boolean;
    function getCertTrustIsNotSignatureValid: boolean;
    function getCertTrustIsNotValidForUsage: boolean;
    function getCertTrustIsUntrustedRoot: boolean;
    function getCertTrustRevocationStatusUnknown: boolean;
    function getCertTrustIsCyclic: boolean;
    function getCertTrustIsPartialChain: boolean;
    function getCertTrustCTLIsNotTimeValid: boolean;
    function getCertTrustCTLIsNotSignatureValid: boolean;
    function getCertTrustCTLIsNotValidForUsage: boolean;

    // Intended Purposes
    function getCertIntendedPurposes: integer;
    function getCertDataEnciphermentKeyUsage: boolean;
    function getCertDigitalSignatureKeyUsage: boolean;
    function getCertKeyAgreementKeyUsage: boolean;
    function getCertKeyCertSignKeyUsage: boolean;
    function getCertKeyEnciphermentKeyUsage: boolean;
    function getCertNonRepudiationKeyUsage: boolean;
    function getCertOfflineCRLSignKeyUsage: boolean;

    function getToString: string;
  public
    constructor Create(aCertificate: PCCERT_CONTEXT);
    destructor Destroy; override;

    property CertFriendlyName: string read getCertFriendlyName;
    property CertSerialNum: string read getCertSerialNumber;
    property CertNameUPNType: string read getCertNameUPNType;
    property CertNameEMailType: string read getCertNameEMailType;

    property CertIntendedPurposes: integer read getCertIntendedPurposes;
    property CertDigitalSignatureKeyUsage: boolean read getCertDigitalSignatureKeyUsage;
    property CertNonRepudiationKeyUsage: boolean read getCertNonRepudiationKeyUsage;
    property CertKeyEnciphermentKeyUsage: boolean read getCertKeyEnciphermentKeyUsage;
    property CertDataEnciphermentKeyUsage: boolean read getCertDataEnciphermentKeyUsage;
    property CertKeyAgreementKeyUsage: boolean read getCertKeyAgreementKeyUsage;
    property CertKeyCertSignKeyUsage: boolean read getCertKeyCertSignKeyUsage;
    property CertOfflineCRLSignKeyUsage: boolean read getCertOfflineCRLSignKeyUsage;

    property CertChainInfoStatus: integer read getCertChainInfoStatus;
    property CertChainSize: integer read getCertChainSize;
    property CertChainCount: integer read getCertChainCount;
    property CertTrustHasExactMatchIssuer: boolean read getCertTrustHasExactMatchIssuer;
    property CertTrustHasKeyMatchIssuer: boolean read getCertTrustHasKeyMatchIssuer;
    property CertTrustHasNameMatchIssuer: boolean read getCertTrustHasNameMatchIssuer;
    property CertTrustIsSelfSigned: boolean read getCertTrustIsSelfSigned;
    property CertTrustHasPreferredIssuer: boolean read getCertTrustHasPreferredIssuer;
    property CertTrustHasIssuanceChainPolicy: boolean read getCertTrustHasIssuanceChainPolicy;
    property CertTrustHasValidNameConstraints: boolean read getCertTrustHasValidNameConstraints;
    property CertTrustIsComplexChain: boolean read getCertTrustIsComplexChain;

    property CertChainErrorStatus: integer read getCertChainErrorStatus;
    property CertTrustNoError: boolean read getCertTrustNoError;
    property CertTrustIsNotTimeValid: boolean read getCertTrustIsNotTimeValid;
    property CertTrustIsNotTimeNested: boolean read getCertTrustIsNotTimeNested;
    property CertTrustIsRevoked: boolean read getCertTrustIsRevoked;
    property CertTrustIsNotSignatureValid: boolean read getCertTrustIsNotSignatureValid;
    property CertTrustIsNotValidForUsage: boolean read getCertTrustIsNotValidForUsage;
    property CertTrustIsUntrustedRoot: boolean read getCertTrustIsUntrustedRoot;
    property CertTrustRevocationStatusUnknown: boolean read getCertTrustRevocationStatusUnknown;
    property CertTrustIsCyclic: boolean read getCertTrustIsCyclic;
    property CertTrustIsPartialChain: boolean read getCertTrustIsPartialChain;
    property CertTrustCTLIsNotTimeValid: boolean read getCertTrustCTLIsNotTimeValid;
    property CertTrustCTLIsNotSignatureValid: boolean read getCertTrustCTLIsNotSignatureValid;
    property CertTrustCTLIsNotValidForUsage: boolean read getCertTrustCTLIsNotValidForUsage;

    property AsString: string read getToString;
  end;

implementation

{ TPKIEncryptionCertificate }

constructor TPKIEncryptionCertificate.Create(aCertificate: PCCERT_CONTEXT);
begin
  inherited Create;
  fCertSerialNumber := '';
  fCertNameUPNType := '';
  fCertNameEMailType := '';
  fCertIntendedPurposes := 0;
  fCertChainInfoStatus := 0;
  fCertChainSize := 0;
  fCertChainCount := 0;
  fCertChainErrorStatus := 0;
  try
    open(aCertificate);
  except
    // Set an Error Status Here
  end;
end;

destructor TPKIEncryptionCertificate.Destroy;
begin
  inherited;
end;

function TPKIEncryptionCertificate.getCertFriendlyName: string;
begin
  Result := fCertFriendlyName;
end;

function TPKIEncryptionCertificate.getCertSerialNumber: string;
begin
  Result := fCertSerialNumber;
end;

function TPKIEncryptionCertificate.getCertNameEMailType: string;
begin
  Result := fCertNameEMailType;
end;

function TPKIEncryptionCertificate.getCertNameUPNType: string;
begin
  Result := fCertNameUPNType;
end;

function TPKIEncryptionCertificate.getCertDataEnciphermentKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_DATA_ENCIPHERMENT_KEY_USAGE) = CERT_DATA_ENCIPHERMENT_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertDigitalSignatureKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_DIGITAL_SIGNATURE_KEY_USAGE) = CERT_DIGITAL_SIGNATURE_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertKeyAgreementKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_KEY_AGREEMENT_KEY_USAGE) = CERT_KEY_AGREEMENT_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertKeyCertSignKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_KEY_CERT_SIGN_KEY_USAGE) = CERT_KEY_CERT_SIGN_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertKeyEnciphermentKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_KEY_ENCIPHERMENT_KEY_USAGE) = CERT_KEY_ENCIPHERMENT_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertNonRepudiationKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_NON_REPUDIATION_KEY_USAGE) = CERT_NON_REPUDIATION_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertOfflineCRLSignKeyUsage: boolean;
begin
  Result := (fCertIntendedPurposes and CERT_OFFLINE_CRL_SIGN_KEY_USAGE) = CERT_OFFLINE_CRL_SIGN_KEY_USAGE;
end;

function TPKIEncryptionCertificate.getCertTrustCTLIsNotSignatureValid: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_CTL_IS_NOT_SIGNATURE_VALID) = CERT_TRUST_CTL_IS_NOT_SIGNATURE_VALID;
end;

function TPKIEncryptionCertificate.getCertTrustCTLIsNotTimeValid: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_CTL_IS_NOT_TIME_VALID) = CERT_TRUST_CTL_IS_NOT_TIME_VALID;
end;

function TPKIEncryptionCertificate.getCertTrustCTLIsNotValidForUsage: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_CTL_IS_NOT_VALID_FOR_USAGE) = CERT_TRUST_CTL_IS_NOT_VALID_FOR_USAGE;
end;

function TPKIEncryptionCertificate.getCertTrustHasExactMatchIssuer: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_HAS_EXACT_MATCH_ISSUER) = CERT_TRUST_HAS_EXACT_MATCH_ISSUER;
end;

function TPKIEncryptionCertificate.getCertTrustHasIssuanceChainPolicy: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY) = CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY;
end;

function TPKIEncryptionCertificate.getCertTrustHasKeyMatchIssuer: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_HAS_KEY_MATCH_ISSUER) = CERT_TRUST_HAS_KEY_MATCH_ISSUER;
end;

function TPKIEncryptionCertificate.getCertTrustHasNameMatchIssuer: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_HAS_NAME_MATCH_ISSUER) = CERT_TRUST_HAS_NAME_MATCH_ISSUER;
end;

function TPKIEncryptionCertificate.getCertTrustHasPreferredIssuer: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_HAS_PREFERRED_ISSUER) = CERT_TRUST_HAS_PREFERRED_ISSUER;
end;

function TPKIEncryptionCertificate.getCertTrustHasValidNameConstraints: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS) = CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS;
end;

function TPKIEncryptionCertificate.getCertTrustIsComplexChain: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_IS_COMPLEX_CHAIN) = CERT_TRUST_IS_COMPLEX_CHAIN;
end;

function TPKIEncryptionCertificate.getCertTrustIsCyclic: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_CYCLIC) = CERT_TRUST_IS_CYCLIC;
end;

function TPKIEncryptionCertificate.getCertTrustIsNotSignatureValid: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_NOT_SIGNATURE_VALID) = CERT_TRUST_IS_NOT_SIGNATURE_VALID;
end;

function TPKIEncryptionCertificate.getCertTrustIsNotTimeNested: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_NOT_TIME_NESTED) = CERT_TRUST_IS_NOT_TIME_NESTED;
end;

function TPKIEncryptionCertificate.getCertTrustIsNotTimeValid: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_NOT_TIME_VALID) = CERT_TRUST_IS_NOT_TIME_VALID;
end;

function TPKIEncryptionCertificate.getCertTrustIsNotValidForUsage: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_NOT_VALID_FOR_USAGE) = CERT_TRUST_IS_NOT_VALID_FOR_USAGE;
end;

function TPKIEncryptionCertificate.getCertTrustIsPartialChain: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_PARTIAL_CHAIN) = CERT_TRUST_IS_PARTIAL_CHAIN;
end;

function TPKIEncryptionCertificate.getCertTrustIsRevoked: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_REVOKED) = CERT_TRUST_IS_REVOKED;
end;

function TPKIEncryptionCertificate.getCertTrustIsSelfSigned: boolean;
begin
  Result := (fCertChainInfoStatus and CERT_TRUST_IS_SELF_SIGNED) = CERT_TRUST_IS_SELF_SIGNED;
end;

function TPKIEncryptionCertificate.getCertTrustIsUntrustedRoot: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_IS_UNTRUSTED_ROOT) = CERT_TRUST_IS_UNTRUSTED_ROOT;
end;

function TPKIEncryptionCertificate.getCertTrustNoError: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_NO_ERROR) = CERT_TRUST_NO_ERROR;
end;

function TPKIEncryptionCertificate.getCertTrustRevocationStatusUnknown: boolean;
begin
  Result := (fCertChainErrorStatus and CERT_TRUST_REVOCATION_STATUS_UNKNOWN) = CERT_TRUST_REVOCATION_STATUS_UNKNOWN;
end;

function TPKIEncryptionCertificate.getCertChainCount: integer;
begin
  Result := fCertChainCount;
end;

function TPKIEncryptionCertificate.getCertChainErrorStatus: integer;
begin
  Result := fCertChainErrorStatus;
end;

function TPKIEncryptionCertificate.getCertChainInfoStatus: integer;
begin
  Result := fCertChainInfoStatus;
end;

function TPKIEncryptionCertificate.getCertChainSize: integer;
begin
  Result := fCertChainSize
end;

function TPKIEncryptionCertificate.getCertIntendedPurposes: integer;
begin
  Result := fCertIntendedPurposes;
end;

function TPKIEncryptionCertificate.getToString: string;
var
  aResult: TStringList;

  procedure Add(aValue: string); overload;
  begin
    aResult.Add(aValue);
  end;

  procedure Add(aProperty, aValue: string); overload;
  begin
    Add(Format('%s=%s', [aProperty, aValue]));
  end;

  procedure Add(aProperty: string; aValue: integer); overload;
  begin
    Add(aProperty, IntToStr(aValue));
  end;

  procedure Add(aProperty: string; aValue: boolean); overload;
  begin
    Add(aProperty, BoolToStr(aValue, True));
  end;

begin
  aResult := TStringList.Create;
  try
    Add('TPKIEncryptionCertificate');

    Add('Serial Number', fCertSerialNumber);

    Add('Intended Purposes', fCertIntendedPurposes);

    Add('CERT_DATA_ENCIPHERMENT_KEY_USAGE', getCertDataEnciphermentKeyUsage);

    Add('CERT_DIGITAL_SIGNATURE_KEY_USAGE', getCertDigitalSignatureKeyUsage);

    Add('CERT_KEY_AGREEMENT_KEY_USAGE', getCertKeyAgreementKeyUsage);

    Add('CERT_KEY_CERT_SIGN_KEY_USAGE', getCertKeyCertSignKeyUsage);

    Add('CERT_KEY_ENCIPHERMENT_KEY_USAGE', getCertKeyEnciphermentKeyUsage);

    Add('CERT_NON_REPUDIATION_KEY_USAGE', getCertNonRepudiationKeyUsage);

    Add('CERT_OFFLINE_CLR_SIGN_KEY_USAGE', getCertOfflineCRLSignKeyUsage);

    Add('CERT_NAME_EMAIL_TYPE', getCertNameEMailType);

    Add('CERT_NAME_UPN_TYPE', getCertNameUPNType);

    Add('');

    Add('Certificate Chain Status', getCertChainInfoStatus);

    Add('Certificate Chain Size', getCertChainSize);

    Add('Certificate Chain Count', getCertChainCount);

    Add('CERT_TRUST_HAS_EXACT_MATCH_ISSUER', getCertTrustHasExactMatchIssuer);

    Add('CERT_TRUST_HAS_KEY_MATCH_ISSUER', getCertTrustHasKeyMatchIssuer);

    Add('CERT_TRUST_HAS_NAME_MATCH_ISSUER', getCertTrustHasNameMatchIssuer);

    Add('CERT_TRUST_IS_SELF_SIGNED', getCertTrustIsSelfSigned);

    Add('CERT_TRUST_HAS_PREFERRED_ISSUER', getCertTrustHasPreferredIssuer);

    Add('CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY', getCertTrustHasIssuanceChainPolicy);

    Add('CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS', getCertTrustHasValidNameConstraints);

    Add('CERT_TRUST_IS_COMPLEX_CHAIN', getCertTrustIsComplexChain);

    Add('');

    Add('Certificate Error Status', fCertChainErrorStatus);

    Result := aResult.Text;
  finally
    FreeAndNil(aResult);
  end;
end;

function TPKIEncryptionCertificate.open(aCertificate: PCCERT_CONTEXT): boolean;
var
  aByte: Byte;
  aPByte: PByte;
  aPBArray: PByteArray;
  aDWord: DWORD;
  aCardinal: Cardinal;
  i: integer;

  aChainEngine: HCERTCHAINENGINE;
  aChainContext: PCCERT_CHAIN_CONTEXT;

  aEnhkeyUsage: CERT_ENHKEY_USAGE;
  aCertUsage: CERT_USAGE_MATCH;
  aChainPara: CERT_CHAIN_PARA;
  aChainConfig: CERT_CHAIN_ENGINE_CONFIG;
begin
//  Result := False;
  try
    try
      // Get the friendly name
      aCardinal := CertGetNameString(aCertificate, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, nil, 0);
      SetLength(fCertFriendlyName, aCardinal);
      if (CertGetNameString(aCertificate, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, 0, PWideChar(fCertFriendlyName), aCardinal) > 1) then
        begin
          while Copy(fCertFriendlyName, Length(fCertFriendlyName), 1) = #0 do
            fCertFriendlyName := Copy(fCertFriendlyName, 1, Length(fCertFriendlyName) - 1);
        end
      else
        raise Exception.Create('Error in CertGetNameString');

      // Get the Cert Serial Number and convert to Hex
      aDWord := aCertificate.pCertInfo.SerialNumber.CbData;
      aPBArray := PByteArray(aCertificate.pCertInfo.SerialNumber.PbData);
      fCertSerialNumber := '';

      for i := aDWord - 1 downto 0 do
        begin
          fCertSerialNumber := fCertSerialNumber + IntToHex(Byte(aPBArray[i]), 2);
          if i > 0 then
            fCertSerialNumber := fCertSerialNumber + ' ';
        end;

      // Get the intended purpose(s) of this cert
      aPByte := @aByte;
      if CertGetIntendedKeyUsage(PKI_ENCODING_TYPE, aCertificate.pCertInfo, aPByte, 1) then
        fCertIntendedPurposes := aByte
      else
        fCertIntendedPurposes := 0;

      // Crack into the chains
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
      if not CertCreateCertificateChainEngine(@aChainConfig, aChainEngine) then
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Build a chain using CertGetCertificateChain and the certificate retrieved
      if not CertGetCertificateChain(aChainEngine, aCertificate, nil, nil, @aChainPara, CERT_CHAIN_REVOCATION_CHECK_CHAIN, nil, aChainContext) then
        raise EPKIEncryptionError.Create(getLastSystemError);

      // Load up the chain values
      fCertChainSize := aChainContext.CbSize;
      fCertChainCount := aChainContext.cChain;
      fCertChainErrorStatus := aChainContext.TrustStatus.DwErrorStatus;
      fCertChainInfoStatus := aChainContext.TrustStatus.DwInfoStatus;

      Result := True;
    except
      begin
        Result := False;
      end;
    end;
  finally
    if aChainEngine <> 0 then
      CertFreeCertificateChainEngine(aChainEngine);
    if aChainContext <> nil then
      CertFreeCertificateChain(aChainContext);
  end;
end;

end.
