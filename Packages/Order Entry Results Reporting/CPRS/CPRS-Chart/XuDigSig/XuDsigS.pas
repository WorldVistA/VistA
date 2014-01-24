unit XuDsigS;
{
 This is the Unit that connects to the MicroSoft CryptoAPI
 that is used to create a digital Signature for a block of
 Data.  This version requires the use of a SmartCard reader.
}
interface
uses SysUtils, Windows, Registry, Dialogs, Classes, Forms, Controls,
  StdCtrls,
  WCrypt2, XuDsigU, XlfMime,
  XlfHex, XuDsigConst, WinSCard, fPINPrompt,
  MFunStr;

type
  ECryptErr = Exception;

type
  TPINResult = (prOK, prCancel, prLocked, prError);

type
  tCryptography = class(TObject)
  private
    //Basic Crypto data
    hProv: HCRYPTPROV; // provider handle
    hPassKey: HCRYPTKEY; // Handle to password (key)
    hHash: HCRYPTHASH; //Hash handle
    hCertStore{, hCRLStore}: HCERTSTORE;  //Certificate store handle
    hUserKey: HCRYPTKEY;  //Handle to the users Sig key
    //Cert. Store Data
    hMsg: HCRYPTMSG;
    pCertContext: PCCERT_CONTEXT;  //Cert Context
    //Flag to mark if valid date
    MasterDateValid: boolean;
    //Flag to mark if Cert has valid Chain
    MasterCertChain: boolean;
    fCSProviderName, fContainerName, fCryptVer: string; // Misc. info
    fHashStr: string;  //hash value in Hex
    fHexHash: string;  //hash value in Hex
    fHashAlogrithm: string;  //Alogrithm used
    fSignatureStr: string;  //This is returned signature
    fDataBuffer: string;  //This is the data to sign as one big string
    fDeaNumber: string;  //This is the users DEA number of file with VA.
    fUsrName: string;    //The User Name on the Cert.
    fUsrAltName: string; // The User's Alt Name (i.e., e-mail address)
    fDateSigned:  string;  //FM datetime
    SignMsgParam: CRYPT_SIGN_MESSAGE_PARA;
    fHashValue: Array of byte;
    fIssuanceDate: String;
    fPatientName: String;
    fPatientAddress: String;
    fDrugName: String;
    fQuantity: String;
    fDirections: String;
    fDetoxNumber: String;
    fProviderName: String;
    fProviderAddress: String;
    fhSC: SCARDCONTEXT;
    fhCard: LongInt;
    fisCardReset: Boolean;
    fOrderNumber: String;
    fVistaUserName: String;

    fIgnoreDates: Boolean;  // DEBUG ONLY
    fIgnoreRevoked: Boolean;  // DEBUG ONLY
    fIgnoreMasterChain: Boolean;  // DEBUG ONLY

    procedure RaiseErr(msg: string);
    function FindCert: boolean;
    function DataReady: boolean;
    procedure Certsigndata;
    function CertChainCheck(pCertContext: PCCERT_CONTEXT): boolean;
    function CRLDistPoint(pbData: pointer; cbData: integer): string;
    function CheckSig(pBlob: pointer; Blobsize: DWORD): boolean;
    function SigningCert(pCertCtx: PCCERT_CONTEXT): Integer;
//    procedure SaveLog; hint fix
  public
    //These fields hold the data from the Crypto functions
    //that we want to pass back to the caller
    isDEAsig: boolean;  //Are we doing a DEA signature
    //These fields hold the raw data from the Crypto functions
    CHashValue: Array of byte;
    CKeyBlob, CSignature: Array[0..2024] of byte;
    CHashLen, CBlobLen, CSigLen: integer;  //The length
    KeyBloB64, SignatureB64: string;
    CertName, CertSerialNum: string; //pass back data
    SigningStatus: boolean;  //This will hold the overall status.
    Reason, SubReason: string;  //This will hold text for the caller about status.
    //The drug's schedule
    DrugSch: string;
    //A URL for the CRL from the cert.
    CrlUrl: string;
    HashB64: string;
    Certstr: string; //pass back data
    ErrCode, ReturnStr: string;  //
    Comment: String;
    LastErr: LongInt;
    TrackingMsg: Tstringlist;
    constructor Create;
    destructor Destroy; override;
    //Info about the Crypto provider
    property ContainerName: string read fContainerName write fContainerName;
    property CSProviderName: string read fCSProviderName write fCSProviderName;
    property CryptVer: string read fCryptVer;
    //Return Data
    property SignatureStr: string read fSignatureStr write fSignatureStr;
    property HashAlgorithm: string read fHashAlogrithm;
    property DTSigned: string read fDateSigned write fDateSigned;
    property HexHash: string read fHexHash;
    property HashStr: string read fHashStr;
    //Normal procedures and functions
    procedure Reset;
    //This is where the data to sign is loaded.
    property DataBuffer: string read fDataBuffer write fDataBuffer;
    property DeaNumber: string read fDeaNumber write fDeaNumber;
    property UsrName: string read fUsrName write fUsrName;
    property UsrAltName: string read fUsrAltName write fUsrAltName;
    property IssuanceDate: string read fIssuanceDate write fIssuanceDate;
    property PatientName: string read fPatientName write fPatientName;
    property PatientAddress: string read fPatientAddress write fPatientAddress;
    property DrugName: string read fDrugName write fDrugName;
    property Quantity: string read fQuantity write fQuantity;
    property Directions: string read fDirections write fDirections;
    property DetoxNumber: string read fDetoxNumber write fDetoxNumber;
    property OrderNumber: string read fOrderNumber write fOrderNumber;
    property ProviderName: string read fProviderName write fProviderName;
    property ProviderAddress: string read fProviderAddress write fProviderAddress;
    property isCardReset: Boolean read fisCardReset;
    property ignoreDates: Boolean read fIgnoreDates write fIgnoredates;  // DEBUG ONLY
    property ignoreRevoked: Boolean read fIgnoreRevoked write fIgnoreRevoked; // DEBUG ONLY
    property ignoreMasterChain: Boolean read fIgnoreMasterChain write fIgnoreMasterChain; // DEBUG ONLY
    property VistaUserName: String read fVistaUserName write fVistaUserName; // 121213 user's name from VistA
    procedure Hashbuffer;
    procedure HashStart;
    procedure HashBuf(pB: pByte; cnt: integer);
    function GetHashValue: String;
    procedure HashEnd;
    function  SignData: boolean;
    procedure sCardReset;
    procedure sCardReattach;
    procedure Release;
end;

function sCardReady: boolean;
function checkPINValue(InputForm: TComponent): TPINResult;
function ptochars(pbdata: pbytearray; len: DWORD): string;
function getSANFromCard(InputForm: TComponent; crypto: TCryptography): String;
function setPINValue(PinValue: String; handle: Dword): Boolean;

var
  SANfromCard: String;
  isXuDSigSLogging: Boolean; // 120912 - needs to be set, if it is going to record problems in Create, before the Crypto object is created.
  LastPINValue: String;

implementation

// Raise an exception with a formatted message
procedure tCryptography.RaiseErr(msg: string);
var
  err: dword;
  s: string;
begin
  s := '';
//  SaveLog(); // 121214 remove saving of log to PKISignError
  err := getLastError; // Check last system error
  if SUCCEEDED(err) then
  begin
    raise ECryptErr.createFmt('Cryptography error: %s.', [msg]);
  end;
  s := SysErrorMessage(err);
  if s = '' then
    s := format('System Error %0X', [err]);
  raise ECryptErr.createFmt('Cryptography error: %s (%s).', [msg, s]);
end;

//This function is to check that all the input data is ready.
//DEA final rule does not have DEA number or DEA schedule in the Cert.
//rwf This will need changes.
function tCryptography.DataReady: boolean;
var
 DataRdy: boolean;

 //nested procedure
 procedure Status(msg: string; st: boolean);
 begin
   Reason := msg;
   DataRdy := st;
 end; //Nested

begin
  Status('Data Check OK', True); //Sets DataReady
  fSignatureStr := '';
  SubReason := '';
  if DataBuffer = '' then
      Status('89802000^Order Text is blank.', False);
  if (isDEAsig = True) and (DeaNumber = '') then
      Status('89802001^DEA # missing.', False);
  Result := DataRdy;
end;

//This will create and init the cryptography object
constructor tCryptography.Create;
var
  buff: array [0..1023] of char;
  provider, Container: string;
  size: dWord;
  LastErr: DWORD;
  value: Boolean;
  Str: String;
begin
  inherited Create;
  Comment := '';
  hProv := 0;      //See that global variables are inited
  hHash := 0;
  hPassKey := 0;
  hUserKey := 0;
  hCertStore := 0;
  CSProviderName := c_SignPROV_NAME; //The Signing Provider  // 120206
  ContainerName := '';         //Will use the default        // 120206
  Reason := '';
  subReason := '';
  fCryptVer := '0.0';
  CHashLen := 0;
  CSigLen := 0;
  ReSet;
  CBlobLen := 0;
  fDataBuffer := '';
  fSignatureStr := '';
  fDatesigned := '';
  //
  Trackingmsg := TstringList.Create;
  if not sCardReady then
  begin
    ShowMessage('Put a smart card in the Reader, then Press OK');
    sleep(5000);
    if not sCardReady then
    begin
      lastErr := GetLastError;
      Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
      TrackingMsg.Add('89802006^Smart Card Reader not found - '+Str);
      RaiseErr('89802006^Smart Card Reader not found');
      exit;
    end;
  end;
  //Find out what CSP to use.
  //For Verification use the MS enhanced AES version.
   provider := CSProviderName;
   Container := '';  //Use the default container 'MY'

   //We only want to create a default container if
   //we are NOT using a SmartCard
   // Create a cryptography object with default
   // container and slected provider.
   Comment := Comment + 'Going to CryptAcquireContext'+#10#13;
   value := CryptAcquireContext( @hProv,
                           pchar(Container),
                           pchar(''),
                           PROV_RSA_AES,  // was PROV_RSA_FULL,   //rwf
                           0);
   if value then
   begin
     Comment := '01 CryptAcquireContext true hProv = '+IntToStr(hProv);
     TrackingMsg.Add(Comment);
     Comment := Comment + 'Back from CryptAcquireContext value true'+#10#13
   end
   else
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     Comment := '01 CryptAcquireContext false lastErr: '+Str;
     TrackingMsg.Add(Comment);
     Comment := Comment + 'Back from CryptAcquireContext value false Error: '+Str+#10#13;
   end;

   if value = false then
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     TrackingMsg.Add('CryptAcquireContext failed - '+Str);
     // Unable to aquire context, check if failure was due to
     // absence of key container.
     value := CryptAcquireContext( @hProv,
                  pchar(Container),
                  pchar(''),
                  PROV_RSA_AES,  // was PROV_RSA_FULL,  rwf
                  CRYPT_NEWKEYSET);
     if value = false then
     begin
       lastErr := GetLastError;
       Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
       TrackingMsg.Add('CryptAcquireContext with new keyset false - '+Str);
       RaiseErr( 'Unable to aquire context');
       exit;
     end
     else
     begin
       TrackingMsg.Add('CryptAcquireContext with new keyset');
     end;
  end;
  if value then
  begin
    Comment := '01 CryptAcquireContext true'+#10#13;
  end;
  if value = false then
  begin
    lastErr := GetLastError;
    Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
    TrackingMsg.Add('01 CryptAcquireContext false - '+Str);
    RaiseErr(Str);
    exit;
  end;
  // Get some info about the cryptography module.
  // Name of the CSP.
  Comment := Comment + '02 hProv = '+IntToStr(hProv)+#10#13;
  size := sizeof(buff);
  if CryptGetProvParam(hProv, PP_NAME, @Buff, @size, 0) = false then
    fCSProviderName := 'Unknown'
  else
    fCSProviderName := StrPas(Buff);
  Comment := Comment + '03 fCSProviderName = '+fCSProviderName+#10#13;

  // Name of the key container.
  size := sizeof(buff);
  if CryptGetProvParam(hProv, PP_CONTAINER, @Buff, @size, 0) = false then
    fContainerName := 'Unknown'
  else
    fContainerName := StrPas(Buff);
  Comment := Comment + '04 ContainerName = '+fContainerName+#10#13;

  // Version number
  size := sizeof(buff);
  if CryptGetProvParam(hProv, PP_VERSION, @Buff, @size, 0) = false then
    fCryptVer := '*.00'
  else
    fCryptVer := format('%d.%d', [integer(buff[1]), integer(buff[0])]);
  Comment := Comment + '05 fCryptVer = '+fCryptVer+#10#13;
end;

destructor tCryptography.Destroy;
begin
  try
    // Release the key handle
    if hPassKey <> 0 then
     if CryptDestroyKey(hPassKey) = false then
        RaiseErr('Unable to destroy password key');
    // Release the Hash handle
    if hHash <> 0 then
        CryptDestroyHash(hHash);
    //Release a certificate Context
    if pCertContext <> nil then
        CertFreeCertificateContext(pCertContext);
    //Release the Cert Store.
    if hCertStore <> 0 then
        CertCloseStore(hCertStore, CERT_CLOSE_STORE_FORCE_FLAG);
    // Clean up.
    // Release the CSP handle
    if hProv <> 0 then
      if CryptReleaseContext(hProv, 0) = false then
        RaiseErr('Unable to release context');
  finally
      //Must remember to do this
      inherited;
  end;
end;

//Gets the SHA-2 hash of the fDataBuffer
procedure tCryptography.Hashbuffer;
begin
  Comment := 'Going to HashStart';
  TrackingMsg.Add(Comment);
  HashStart;
  HashBuf(@DataBuffer[1], length(DataBuffer));
  TrackingMsg.Add('Going to GetHashValue');
  GetHashValue;
  TrackingMsg.Add('Going to HashEnd');
  HashEnd;
end;

//Called at start of a long hash to create the hash object.
procedure tCryptography.Hashstart;
var
  Str: String;
begin
  CHashLen := 0;
  if hHash = 0 then
    if cryptCreateHash(hprov, c_HASH_ALGID, 0, 0, @hHash) = False then
    begin
      lastErr := GetLastError;
      Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
      TrackingMsg.Add('Unable to create hash object in cryptCreateHash - '+Str);
      RaiseErr('Unable to create hash object');
      exit;
    end;
end;

//Called to hash a buffer of data
procedure tCryptography.HashBuf(pB: pByte; cnt: integer);
var
  Str: String;
begin
  if CryptHashData(hHash, pB, Cnt, 0) = False then
  begin
    lastErr := GetLastError;
    Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
    TrackingMsg.Add('CryptHashData in crypto.HashBuf failed - '+Str);
    RaiseErr('Unable to hash buff');
    exit;
  end;
end;

//This is called at the end of a long hash to destroy the hash object
//If going to sign the hash it must be done before calling this.
procedure tCryptography.Hashend;
begin
    //Destroy the Hash
    CryptDestroyHash(hHash);
    hHash := 0;
end;

//This call gets the current Hash value and puts the B64
//value in the public variable hashstr
//procedure tCryptography.GetHashValue;
function tCryptography.GetHashValue: String;
var
  pbData: pbyte;
  dwLen, LastErr: DWORD;
  i: integer;
  Str: String;
begin
  fHashStr := '';
  CHashLen := 0;
  if hHash = 0 then
    exit;
  //Get the length of the hash
  CryptGetHashParam(hHash, HP_HASHVAL, nil, @dwLen, 0);
  GetMem(pbData, dwLen);
  if CryptGetHashParam(hHash, HP_HASHVAL, pbData, @dwLen, 0) <> True then
  begin
    lastErr := GetLastError;
    Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
    Comment := Comment + 'Error in CryptGetHashParam - '+Str;
    RaiseErr(Str);
  end;
  CHashLen := dwLen;
  SetLength(fhashValue, dwLen);
  //Move the hash into the global variable
  for i := 0 to dwLen - 1 do fHashValue[i] := pbytearray(pbData)[i];
  i := MimeEncodedSize(dwlen);
  SetLength(fHashStr, i);
  MimeEncode(PChar(fHashValue)^, dwlen, PChar(fHashStr)^);
  //Free temp memory
  FreeMem(pbData);
  result := HashStr;
end;


///////////////////////////////////////////////////////////
//Open a system certificate store and
//check each certificates looking for a Certificate
//that is Valid and has a given ObjID.
//Leaves HCertStore and pCertContext open.
///////////////////////////////////////////////////////////
function Tcryptography.FindCert: Boolean;
const
  buffsize = 1024;
var
  //Used to tell if we found the right parts
  DateValid, Status, Signing: boolean;
  dwData{, ValLen}: DWORD;
  pbarray: pbytearray;
  str2, NameString: string;
  kpiData: CRYPT_KEY_PROV_INFO;
  ContainerName, CSProviderName: widestring;
  sContainerName, sCSProviderName: String;
  //a pointer the the rgExtension blob
  rgExtension: PCERT_EXTENSION;
  cExtension: DWORD;
  pce: PCERT_EXTENSION;
  prgp: PPVOID;
  str: String;
  isDisplayNameCorrect: Boolean;  // JLI 120619
  isAltNameMatched: Boolean;  // JLI 120619
  SigningVal: Integer;
  pTime: TFileTime;
  NotAfterDate: String;     // JLI 120919
  CertDisplayName: String;  // JLI 120919
  DateValidValue: Integer;
  InvalidDateLine: String;
  RevocationReason: String;
  RevocationStatusOK: Boolean;

  function Revco(): boolean;
  var
    //var's for Revocation checking
    RevStatus: CERT_REVOCATION_STATUS;
    pRevStatus: PCERT_REVOCATION_STATUS;
    RevPara: CERT_REVOCATION_PARA;
    rgpvContext: array[0..3] of pointer;
    i: integer;
    cContext: DWORD;
  begin
     //This takes a long time
     RevPara.cbSize := sizeof(RevPara);
     RevStatus.cbSize := sizeof(RevStatus);
     RevStatus.dwIndex := 0;
     RevStatus.dwError := 0;
     pRevStatus := @RevStatus;
     for i := 0 to 3 do
       rgpvContext[i] := nil;
     rgpvContext[0] := pCertContext;
     cContext := 1;
     prgp := @(rgpvContext[0]);
     Result := CertVerifyRevocation( c_ENCODING_TYPE,
                             CERT_CONTEXT_REVOCATION_TYPE,
                             cContext,
                             prgp,
                             CERT_VERIFY_REV_SERVER_OCSP_FLAG,  // was CERT_VERIFY_REV_CHAIN_FLAG,
                             nil,
                             pRevStatus);
     //Now to check the status
     if Result = false then
     begin
       LastErr := GetLastError;
       str2 := SysErrorMessage(LastErr);
       RevocationReason := 'Revocation failed - error: '+IntToStr(LastErr)+' - '+Str2;
       TrackingMsg.Add('  '+RevocationReason);
     end;  //if
  end;  //nested function
  //End Nested functions
begin
  Status := False;
  Result := False;
  //The system maps the current users Cert's to the MY store.
  //So, Open the MY Store
  if hCertStore = 0 then
  begin
    hCertStore := CertOpenSystemStore(0, PChar('MY'));
  end;
  if pCertContext <> nil then
  begin
      //If we can recheck we could skip the search.
  end;
  pCertContext := nil;
  Reason := 'Could not open the Cert Store';
  //if hCertStore is 0 the open didn't work
  if hCertStore = 0 then
  begin
    TrackingMsg.Add('Unable to open a Certificate Store.');
//  SaveLog(); // 121214 remove saving of log to PKISignError
    exit;
  end;
  //Set the size of some strings
  Setlength(ContainerName, 255);
  Setlength(CSProviderName, 255);
  Setlength(NameString, 255);
  //put some data in kpiData
  kpiData.pwszContainerName := @ContainerName;
  kpiData.pwszProvName := @CSProviderName;
  kpiData.dwKeySpec := 0;
  //Set a fail reason
  Reason := 'Did not find a Cert.';
  //Now Get the first certificates.
  pCertContext := CertEnumCertificatesInStore(hCertStore, nil);
  sCSProviderName := CSProviderName;
  sContainerName := ContainerName;
  Str := sCSProviderName + sContainerName;
  //The loop
  while (pCertContext <> nil) and (STATUS = False) do
  begin
    //INIT flags
    TrackingMsg.Add(' ');

    //Get user display name
    CertDisplayName := '';
    if (CertGetNameString(pCertContext,
        CERT_NAME_SIMPLE_DISPLAY_TYPE,
        0,
        0,
        PChar(NameString),  //SetLength done at start
        128)) then
             CertDisplayName := StrPas(PChar(NameString));

    // expected CertDisplayName is ALPHA NUMERIC
    // check first for alpha and last for digit
    isDisplayNameCorrect := false;
    str := UpperCase(Copy(CertDisplayName,1,1));
    if (Pos(str,'ABCDEFGHIJKLMNOPQRSTUVWXYZ') > 0) then
    begin
      str := IntToStr(length(certDisplayName));
      str := copy(certDisplayName,length(certDisplayName),1);
      if (Pos(str,'0123456789)') > 0) then
      begin
        isDisplayNameCorrect := true;
        if (UsrAltName = '') then     //121213 JLI insert for checking for valid UsrAltName
        begin
          if not (Pos(UpperCase(Piece(VistaUserName,',')),UpperCase(certDisplayName)) > 0) then
            isDisplayNameCorrect := false;
        end;
      end;
    end;

    //Get the Cert serialNumber
    dwdata := pCertContext.pCertInfo.SerialNumber.cbData;
    pbarray := pbytearray(pCertContext.pCertInfo.SerialNumber.pbData);
    //Now convert the Serial number to HEX
    CertSerialNum := XuDsigU.SerialNum(pbarray, dwdata);

    ptime := pCertContext.pCertinfo.NotAfter;
    NotAfterDate := CertDateTimeStr(pTime);

    //Check that it has a Signature key
    SigningVal := SigningCert(pCertContext);
    Signing := false;
// JLI 121120    if (SigningVal div $80) > 0 then
    if (SigningVal div $C0) > 0 then // JLI 121120
      Signing := true;
    //****************************

    SANFromCard := '';
    CertName := '';
    isAltNameMatched := false;
    if (CertGetNameString(pCertContext,8,0,0,
        PChar(NameString),   //SetLength done at start
        128)) then
    begin
      CertName := StrPas(PChar(NameString));  // 120507 JLI Make change in regular
    end;
    if CertName = '' then
    begin
      if CertGetNameString(pCertContext,1,0,0,
         PChar(NameString),   //SetLength done at start
         128) then
      begin
        CertName := StrPas(PChar(NameString));
      end;
    end;
    if not (UsrAltName = '') then    // UsrAltName = '' if to get value from card
    begin
      if UpperCase(UsrAltName) = UpperCase(CertName) then  // 120619 JLI make non case sensitive
      begin
        isAltNameMatched := true;
      end
      else
      begin
        CertName := '';
        if CertGetNameString(pCertContext,1,0,0,
           PChar(NameString),   //SetLength done at start
           128) then
        begin
          CertName := StrPas(PChar(NameString));
        end;
        if (UpperCase(UsrAltName) = UpperCase(CertName)) then
        begin
          isAltNameMatched := true;
        end;
      end;
    end;

    DateValid := True;
    //Check that the time is valid - use current time
    DateValidValue := CertVerifyTimeValidity(nil, pCertContext.pCertinfo);   // Pointer to CERT_INFO.
    case DateValidValue of
      -1: DateValid := False;   //Before the not before time
       1: DateValid := False;   //After the not after time
       0: DateValid := True;
    end;
    //****************************

    TrackingMsg.Add('Checking Cert:');
    TrackingMsg.Add('  CertDisplayName: '+CertDisplayName);
    if isDisplayNameCorrect then
      TrackingMsg.Add('  CertDisplayName is Valid')
    else
      TrackingMsg.Add('  CertDisplayName is NOT Valid');
    TrackingMsg.Add('  Cert Serial Number: '+CertSerialNum);
    TrackingMsg.Add('  Not After Date: '+NotAfterDate);
    if Signing then
      TrackingMsg.Add('  Is Signing Cert: true')
    else
      TrackingMsg.Add('  Is Signing Cert: false');
    TrackingMsg.Add('  CertName: '+CertName);
    if not (UsrAltName = '') then
    begin
      if isAltNameMatched then
        TrackingMsg.Add('  User SAN is Matched')
      else
        TrackingMsg.Add('  User SAN is NOT Matched');
    end
    else if isDisplayNameCorrect and signing and dateValid and not (CertName = '') then
    begin
      SANFromCard := CertName;
      Result := true;
      exit
    end;

    if DateValidValue = -1 then
      TrackingMsg.Add('  Certificate is not valid yet')
    else if DateValidValue = 1 then
      TrackingMsg.Add('  Certificate has expired');

    InvalidDateLine := '';
    if not IgnoreDates then
    begin
      if isDisplayNameCorrect and signing and isAltNameMatched then  // JLI 120619 only display if matches criteria
      begin
        if DateValidValue = -1 then
          InvalidDateLine := 'Certificate is not valid yet'
        else if DateValidValue = 1 then
          InvalidDateLine := 'Certificate has expired';
      end;
    end; // not ignoreDates

    RevocationStatusOK := true;
    if isAltNameMatched then
        if isDisplayNameCorrect then
          if Signing then
            if DateValid then
            begin
              rgExtension := pCertContext.pCertInfo.rgExtension;
              cExtension := pCertContext.pCertInfo.cExtension;
              // see if we get the CRL dist point
              pce := CertFindExtension(PChar('2.5.29.31'), cExtension, rgExtension);
              if pce <> nil then
                CRLURL := CRLDistPoint(pce.Value.pbData, pce.Value.cbData);
              RevocationStatusOK := true;
              if not IgnoreRevoked then
              begin
                RevocationStatusOK := Revco;  //Check Revocation Status
              end;  // not IgnoreRevoked
              if DateValid then
                MasterDateValid := True;
    end; //if FoundObjID and Signing and DateValid then

    //Set Status, Did we find a good one.
    Status := DateValid and isAltNameMatched
              and Signing and RevocationStatusOK
              and isDisplayNameCorrect;

    if (not Status) and isAltNameMatched and Signing and isDisplayNameCorrect then
    begin
      Reason := '';
      if not DateValid then
        Reason := InvalidDateLine
      else if not RevocationStatusOK then
        Reason := RevocationReason;
    end;

    //Only get the next Cert if Status is false.
    if Status = False then  //--- Get the next certificate
        pCertContext := CertEnumCertificatesInStore(hCertStore, pCertContext);
  end; // while (pCertContext <> nil) and (STATUS = False) do
  //*******************************************************************
  if Status = True then
  begin  //We found a Cert, get more data on it.
    MasterCertChain := true;
    if not fIgnoreMasterChain then
    begin
      //Need to look at which properties we need.
      MasterCertChain := CertChainCheck(pCertContext);
      if not MasterCertChain then
      begin
        Reason := 'Problems with verifying certificate chain of authority';
        TrackingMsg.Add('MasterCertChain returned False');
      end;
    end; // if not fIgnoreMasterChain
  end; //end if status

  if (not Status) and (not (InvalidDateLine = '')) then
    ShowMessage(InvalidDateLine);
  Result := Status and MasterCertChain;
end;

function tCryptography.SignData: boolean;
  //All the data that we need will be placed thru object calls
  //This part will manage the other parts to get the work done.
  //With luck we don't have to have all the code inline.
begin
  TrackingMsg.Clear;
  Comment := 'Entered crypto.SignData'+#10#13;
  TrackingMsg.Add('');
  TrackingMsg.Add('Entered crypto.SignData');
  if isDEAsig then
  begin
    // order by alphabetic of property name, since this is the order
    // they will be returned in for verification
    DataBuffer := '';
    DataBuffer := DataBuffer + DeaNumber;  // 10
    DataBuffer := DataBuffer + DetoxNumber;  // 7
    DataBuffer := DataBuffer + Directions;  // 6
    DataBuffer := DataBuffer + DrugName;  // 4
    DataBuffer := DataBuffer + IssuanceDate;  // 1
    DataBuffer := DataBuffer + OrderNumber;
    DataBuffer := DataBuffer + PatientAddress;  // 3
    DataBuffer := DataBuffer + PatientName;  // 2
    DataBuffer := DataBuffer + ProviderAddress;  // 9
    DataBuffer := DataBuffer + ProviderName;  // 8
    DataBuffer := DataBuffer + Quantity;  // 5
  end;  // if isDEAsig
  SigningStatus := True;
  MasterDateValid := False;
  MasterCertChain := False;
  SigningStatus := dataReady;  //function, dataready will set reason
  Result := SigningStatus;
  if SigningStatus = False then
  begin
    Comment := 'Signing Status was False';
    exit;
  end;
  //Build a Hash of the fDataBuffer
  //Put the results in fHashValue
  Reason := '';
  HashBuffer;
  if FindCert <> True then
  begin
    TrackingMsg.Add('FindCert failed');
    SigningStatus := False;
    fHashStr := '';
    if Reason = '' then
      Reason := '89802004^Valid Certificate not found.';
    ShowMessage(Reason); //121214 Show Reason
  end; //if
  //Have what we need, Lets sign the data
  if SigningStatus then
  begin
    if not (LastPINValue = '') then
      SetPinValue(LastPINValue,0);
    TrackingMsg.Add('Going to CertSignData');
    CertSignData;
    if not SigningStatus then
    begin
      ShowMessage('Returned from CertSignData with failure'); // 121214 display message
      TrackingMsg.Add('Returned from CertSignData with failure');
    end;
  end;
  Result := SigningStatus;
//  if not Result then // 121214
//  SaveLog(); // 121214 remove saving of log to PKISignError
  //Clean-up
  Release;
end;

procedure tCryptography.Release;
begin
  //Clean-up
  if isCardReset then
    sCardReattach;
  //Release the message
  if hmsg <> nil then
          CryptMsgClose(hMsg);
  hmsg := nil;
  //Release the Cert Context
  if pCertContext <> nil then
          CertFreeCertificateContext(pCertContext);
  pCertContext := nil;
  //Release the Cert Store.
  if hCertStore <> 0 then
          CertCloseStore(hCertStore, CERT_CLOSE_STORE_FORCE_FLAG);
  hCertStore := 0;
  // the following close the card on completion
  if not (fhCard = 0) then
  begin
    SCardDisconnect(fhCard,SCARD_LEAVE_CARD);
    fhCard := 0;
  end;
  if not (fhSC = 0) then
  begin
    SCardReleaseContext(fhSC);
    fhSC := 0;
  end;
end;

procedure tCryptography.CertSignData;
var
  LastErr: DWORD;
  pbEncodedBlob: array of byte;
  cbEncodedBlob: DWORD;
  cbContent: DWORD;
  rgpbToBeSigned: array [0..0] of PByte;
  rgcbToBeSigned: array [0..0] of PDWORD;
  Encodedsize: integer;
  str: string;
begin
  SignMsgParam.cbSize := sizeof(SignMsgParam);
  //zero out the stuff we don't use in the CRYPT_SIGN_MESSAGE_PARA
  SignMsgParam.pvHashAuxInfo := nil;
  SignMsgParam.cMsgCert := 0;
  SignMsgParam.rgpMsgCert := nil;
  SignMsgParam.cMsgCrl := 0;
  SignMsgParam.rgpMsgCrl := nil;
  SignMsgParam.cAuthAttr := 0;
  SignMsgParam.rgAuthAttr := nil;
  SignMsgParam.cUnauthAttr := 0;
  SignMsgParam.rgUnauthAttr := nil;
  SignMsgParam.dwFlags := 0;
  //Now for the parameters we want to use
  SignMsgParam.dwInnerContentType := 0;
  SignMsgParam.pSigningCert := pCertContext;
  SignMsgParam.dwMsgEncodingType := c_ENCODING_TYPE;
  SignMsgParam.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA; //szOID_RSA_MD2;
  //Include the Signing Cert
  SignMsgParam.cMsgCert := 1;
  SignMsgParam.rgpMsgCert := @pCertContext;
  //And now the data to be signed (the hash in this case)
  cbContent := length(fHashValue);
  rgpbToBeSigned[0] := @fHashValue;
  rgcbToBeSigned[0] := @cbContent;
  cbEncodedBlob := 0;
  cbEncodedBlob := 4096;  //Fixed size normal Sig is < 2K
  setlength(pbEncodedBlob, cbEncodedBlob + 1);
  // We set detachedsignature to false because we did
  // the hash ourselfs
  if not CryptSignMessage(@SignMsgParam,
                  False,  //DetachedSignature
                  1,
                  rgpbToBeSigned[0],  //rgpbToBeSigned,
                  rgcbToBeSigned[0],  //rgcbToBeSigned,
                  pointer(pbEncodedBlob),     //Pointer to return Blob
                  @cbEncodedBlob) then
  begin
    SigningStatus := false;
    TrackingMsg.Add('Returned from CryptSignMessage with failure');
    LastErr := GetLastError;
    Reason := '89802010^Signature Error - ' + SysErrorMessage(LastErr);
    TrackingMsg.Add(Reason);
  end;
  if SigningStatus then
  begin   //1
    //Try and use Base64 encoding
    //Get the size of the Encoded string
    EncodedSize := MimeEncodedSize(cbEncodedBlob);
    str := '';
    //Set the size of the string
    SetLength(str, EncodedSize);
    //Now to do the encodeing
    MimeEncode(PChar(pbEncodedBlob)^, cbEncodedBlob, PChar(str)^);
    fSignatureStr := str;
    //Lets check the Cert Chain
    TrackingMsg.Add('Going to CertChainCheck');
    CertChainCheck(pCertContext);
    TrackingMsg.Add('Returned from CertChainCheck');
  end; //if 1
  //Release the CertContext and CertStore
  Release;

  //Test if we can load the signature back in
  if SigningStatus then
    if not CheckSig(pointer(pbEncodedBlob),cbEncodedBlob) then
    begin
      TrackingMsg.Add('CheckSig (checking can load signature back) failed');
      SigningStatus := false;
      Reason := '89802009^Signature Check failed';
    end;
end;


function tCryptography.CheckSig(pBlob: pointer; Blobsize: DWORD): boolean;
var
  LastErr: DWORD;
  pbDecoded: array of byte;
  cbDecoded, cbSignerCertInfo: DWORD;
  hMsg: HCRYPTMSG;
  CertInfoBlob: array of DWORD;
  str, NameString: string;
  pTime: PFileTime;
  i: integer;
begin
  Result := false;
  //---------------
  subReason := 'SC msgOpen fail';
  //Lets see if we can reload the msg.
  hMsg := CryptMsgOpenToDecode(c_ENCODING_TYPE,        // Encoding type.
                   0,            // Flags.
                   0,            // Use the default message type.
                                 // The message type is
                                 // listed in the message header.
                   0,            // Cryptographic provider. Use NULL
                                 // for the default provider.
                   nil,          // Recipient information.
                   nil);         // Stream information.
  if hMsg = nil then
    Exit;
  //--------------------------------------------------------------------
  //  Update the message with an encoded blob.
  //  Both pbEncodedBlob, the encoded data,
  //  and cbEnclodeBlob, the length of the encoded data,
  //  must be available.
  if CryptMsgUpdate(hMsg,        // Handle to the message
                      pBlob,     // Pointer to the encoded blob
                      BlobSize,              // Size of the encoded blob
                      True)                      // Last call
  then
    str := 'The encoded blob has been added to the message.'
  else
  begin
    lastErr := GetLastError;
    Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
    RaiseErr('Decode MsgUpdate failed - '+Str);
  end;
//We will try and verify the signature here.
//new part
   //---------------
   // Get the number of bytes needed for a buffer
   // to hold the Decoded message.
  if CryptMsgGetParam(hMsg,                 //Handle to msg
                       CMSG_CONTENT_PARAM,   //Param type
                       0,                    //Index
                       nil,
                       @cbDecoded)
  then
    Str := 'The message param has been acquired'
  else
  begin
    lastErr := GetLastError;
    Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
    TrackingMsg.Add('Decode CMSG_CONTENT_PARAM failed - '+Str);
    RaiseErr('Decode CMSG_CONTENT_PARAM failed');
    exit;
  end;
   // Allocate memory
  SetLength(pbDecoded, cbDecoded);
   //Copy the content to the buffer
   if CryptMsgGetParam(hMsg,                 //Handle to msg
                       CMSG_CONTENT_PARAM,   //Param type
                       0,                    //Index
                       pbDecoded,            //Address for return data
                       @cbDecoded)           //Size of return data
                  Then
     Str := 'The message param has been acquired'
   else
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     TrackingMsg.Add('Decode CMSG_CONTENT_PARAM failed - '+Str);
     RaiseErr('Decode CMSG_CONTENT_PARAM failed');
     exit;
   end;
   //Verify the signature
   //First, Get the signer CERT_INFO from the message
   //------
   //Get the size needed
   if CryptMsgGetParam( hMsg,      //Msg Handle
                        CMSG_SIGNER_CERT_INFO_PARAM,   //Param Type
                        0,         //Index
                        nil,
                        @cbSignerCertInfo)  //Size of return data
   then
     Str:=IntToStr(cbSignerCertInfo) + ' bytes needed'
   else
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     TrackingMsg.Add('Verify SIGNER_CERT #1 failed - '+Str);
     RaiseErr('Verify SIGNER_CERT #1 failed');
     exit;
   end;
   //Allocate Memory
   SetLength(CertInfoBlob,cbSignerCertInfo);
   //Get the signer CERT_INFO
   if CryptMsgGetParam( hMsg,      //Msg Handle
                        CMSG_SIGNER_CERT_INFO_PARAM,   //Param Type
                        0,         //Index
                        Pointer(CertInfoBlob),
                        @cbSignerCertInfo)  //Size of return data
   then
     Str:='CertInfoBlob acquired'
   else
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     TrackingMsg.Add('Verify SIGNER_CERT #2 failed - '+Str);
     RaiseErr('Verify SIGNER_CERT #2 failed');
     exit;
   end;
   //------------
   //Open a certificate store in memory using CERT_STORE_PROV_MSG
   //which initializes it with the certificates from the MSG
   hCertStore := CertOpenStore( CERT_STORE_PROV_MSG,     //Store prov type
                                c_ENCODING_TYPE,
                                0,                       //Cryptographic provider
                                                         // use nil for default
                                0,                       //Flags
                                hMsg);
   if hCertStore = 0 then
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     TrackingMsg.Add('Open Store failed - '+Str);
     RaiseErr('Open Store failed');
     exit;
   end;
   //--------------
   //Find the signer's cert in the store
   pCertContext :=
     CertGetSubjectCertificateFromStore(hCertStore,
                                        c_ENCODING_TYPE,
                                        pointer(CertInfoBlob)); // pSignerCertInfo);
   if pCertContext = nil then
   begin
     lastErr := GetLastError;
     Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
     TrackingMsg.Add('GetSubjectCert failed - '+Str);
     RaiseErr('GetSubjectCert failed');
     exit;
   end;
   //Allocate memory for name
   SetLength(NameString, 256);
   //Get the Cert Name String
   CertGetNameString(pCertContext,
                     CERT_NAME_SIMPLE_DISPLAY_TYPE,
                     0,
                     0,
                     pointer(NameString),
                     256);
   //---------
   //Use the CERT_INFO from the signer Cert to Verify
   //the signature
   if CryptMsgControl( hMsg,             //Handle to msg
                       0,                //Flags
                       CMSG_CTRL_VERIFY_SIGNATURE,
                       pCertContext.pCertInfo)   //Pointer to the CERT_INFO
   then
     Result := true
   else
   begin
     lasterr := getLastError; // Check last system error
     subReason := 'Digital signature verification failed: ' +
                SysErrorMessage(lasterr);
   end;
  if not IgnoreDates then
  begin
    //Check that the time is valid
    pTime := nil;
    i := CertVerifyTimeValidity(
          pTime,                // Use time of signing or current time.
          pCertContext.pCertinfo);   // Pointer to CERT_INFO.
    case i of
      -1 : Str := '89802019^Before Cert effective date.';   //Before the not before time
      1 : Str :='89802020^Certificate expired.'  ;   //After the not after time
      0 : Str := 'DateValid';
    end;
    if not (CompareStr(Str, 'DateValid') = 0) then
      ShowMessage('Certificate not valid: '+Str);
  end; // if not IgnoreDates
  Release;
end;

//Check the Cert Chain for the Cert just used.
function tCryptography.CertChainCheck(pCertContext: PCCERT_CONTEXT): boolean;
var
    { Private declarations }
    hChainEngine: HCERTCHAINENGINE;
    ChainConfig: CERT_CHAIN_ENGINE_CONFIG;
    pChainContext: PCCERT_CHAIN_CONTEXT;
    EnhkeyUsage: CERT_ENHKEY_USAGE;
    CertUsage: CERT_USAGE_MATCH;
    ChainPara: CERT_CHAIN_PARA;
    dwFlags: DWORD;
    i: integer;
    fStatus: boolean;  //Local status
    Str: String;
    //-----------------------------------------------------
    //nested function
    procedure Memo(s: string);
    begin
        TrackingMsg.Add(s);
    end;
    
    procedure SetStatus(sta: boolean; s: string);
    begin
        fStatus := False;
        if sta then
          fStatus := True;
        SubReason := s;
        Memo(s);
    end;
    //end nested function
    //-------------------------------------------------------
begin
    EnhkeyUsage.cUsageIdentifier := 0;
    EnhkeyUsage.rgpszUsageIdentifier := nil;
    CertUsage.dwType := USAGE_MATCH_TYPE_AND;
    CertUsage.Usage := EnhkeyUsage;
    ChainPara.cbSize := sizeof(chainPara);
    ChainPara.RequestedUsage := CertUsage;
    ChainConfig.cbSize := sizeof(CERT_CHAIN_ENGINE_CONFIG);
    ChainConfig.hRestrictedRoot := 0;
    ChainConfig.hRestrictedTrust := 0;
    ChainConfig.hRestrictedOther := 0;
    ChainConfig.cAdditionalStore := 0;
    ChainConfig.rghAdditionalStore := 0;
    ChainConfig.dwFlags := CERT_CHAIN_REVOCATION_CHECK_CHAIN;
    ChainConfig.dwUrlRetrievalTimeout := 30000;
    ChainConfig.MaximumCachedCertificates := 0;
    ChainConfig.CycleDetectionModulus := 0;
    //---------------------------------------------------------
    //   Create the nondefault certificate chain engine.
    if CertCreateCertificateChainEngine(@ChainConfig, hChainEngine) then
        Memo('  A chain Engine has been created')
    else
    begin
        lastErr := GetLastError;
        Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
        TrackingMsg.Add('The Engine Create Failed - '+Str);
        RaiseErr('The engine Create Failed');
    end;
    //---------------------------------------------------------
    //----------------------------------------------------------------
    //        Build a chain using CertGetCertificateChain
    //        and the certificate retrieved.
    dwFlags := CERT_CHAIN_REVOCATION_CHECK_CHAIN;
    if (CertGetCertificateChain(hChainEngine,
        // Use 0 the default chain engine.
        pCertContext,          // Pointer to the end certificate.
        nil,                  // Use the default time.
        0,              // Search no additional stores.
        @ChainPara,            // Use AND logic, and enhanced key usage
        // as indicated in the ChainPara
        // data structure.
        dwFlags,
        nil,                 // Currently reserved.
        pChainContext))       // Return a pointer to the chain created.
    then
        Memo('  The chain has been created. ')
    else
    begin
        lastErr := GetLastError;
        Str := IntToStr(lastErr)+' - '+SysErrorMessage(lastErr);
        TrackingMsg.Add('The chain could not be created - '+Str);
        RaiseErr('The chain could not be created.');
    end;
    //---------------------------------------------------------------
    // Display some of the contents of the chain.
    Memo('  The size of the chain context is ' + IntToStr(pChainContext.cbSize));
    Memo('  '+IntToStr(pChainContext.cChain) + ' simple chains found.');
    i := pChainContext.TrustStatus.dwErrorStatus;
    Memo('  Error status for the chain: '+IntToStr(i));
    case i of
        CERT_TRUST_NO_ERROR:
            SetStatus(True, '    No error found for this certificate or chain.');
        CERT_TRUST_IS_NOT_TIME_VALID:
            SetStatus(False,
                '    This certificate or one of the certificates in the certificate chain is not time-valid.');
        CERT_TRUST_IS_NOT_TIME_NESTED:
            SetStatus(False, '    Certificates in the chain are not properly time-nested.');
        CERT_TRUST_IS_REVOKED:
            SetStatus(False,
                '    Trust for this certificate or one of the certificates in the certificate chain has been revoked.');
        CERT_TRUST_IS_NOT_SIGNATURE_VALID:
            SetStatus(False,
                '    The certificate or one of the certificates in the certificate chain does not have a valid signature.');
        CERT_TRUST_IS_NOT_VALID_FOR_USAGE:
            SetStatus(False,
                '    The certificate or certificate chain is not valid in its proposed usage.');
        CERT_TRUST_IS_UNTRUSTED_ROOT:
            SetStatus(False, '    The certificate or certificate chain is based on an untrusted root.');
        CERT_TRUST_REVOCATION_STATUS_UNKNOWN:
            SetStatus(False,
                '    The revocation status of the certificate or one of the certificates in the certificate chain is unknown.');
        CERT_TRUST_IS_CYCLIC:
            SetStatus(False,
                '    One of the certificates in the chain was issued by a certification authority that the original certificate had certified.');
        CERT_TRUST_IS_PARTIAL_CHAIN:
            SetStatus(False, '    The certificate chain is not complete.');
        CERT_TRUST_CTL_IS_NOT_TIME_VALID:
            SetStatus(False, '    A CTL used to create this chain was not time-valid.');
        CERT_TRUST_CTL_IS_NOT_SIGNATURE_VALID:
            SetStatus(False, '    A CTL used to create this chain did not have a valid signature.');
        CERT_TRUST_CTL_IS_NOT_VALID_FOR_USAGE:
            SetStatus(False, '    A CTL used to create this chain is not valid for this usage.');
        else
            SetStatus(True, '    No Error information returned');
    end;  //case
    i := pChainContext.TrustStatus.dwInfoStatus;
    Memo('  Info status for the chain: '+IntToStr(i));
    case (i) of
        CERT_TRUST_HAS_EXACT_MATCH_ISSUER:
            Memo('    An exact match issuer certificate has been found for this certificate.');
        CERT_TRUST_HAS_KEY_MATCH_ISSUER:
            Memo('    A key match issuer certificate has been found for this certificate.');
        CERT_TRUST_HAS_NAME_MATCH_ISSUER:
            Memo('    A name match issuer certificate has been found for this certificate.');
        CERT_TRUST_IS_SELF_SIGNED:
            Memo('    This certificate is self-signed.');
        CERT_TRUST_HAS_PREFERRED_ISSUER:
            Memo('    This certificate has a preferred issuer');
        CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY:
            Memo('    An Issuance Chain Policy exists');
        CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS:
            Memo('    A valid name contraints for all namespaces, including UPN');
        CERT_TRUST_IS_COMPLEX_CHAIN:
            Memo('    The certificate chain created is a complex chain.');
        else
            Memo('    No information status reported.');
    end; // End case
    //--------------------------------------------------------------------
    Result := fStatus;
    if Result then
      Memo('  Certificate Chain returned true')
    else
      Memo('  Certificate Chain returned false and failed');
end;

function tCryptography.CRLDistPoint(pbData: pointer; cbData: integer): string;
var
    buff: array[0..1023] of byte;
    cbBuff: DWORD;
    pvcrl_dist_info: PCRL_DIST_POINTS_INFO;
    pvcrl_dist_point: PCRL_DIST_POINT;
    distPointName: CRL_DIST_POINT_NAME;
    CertAltNameInfo: CERT_ALT_NAME_INFO;
    CertAltNameEntry: PCERT_ALT_NAME_ENTRY;
    ix, j: integer;
    str, lcstr: string;
begin
    pvcrl_dist_info := @buff;
    cbBuff := 1024;
    Result := '';
    str := '';
    if CryptDecodeObject(c_ENCODING_TYPE,
        X509_CRL_DIST_POINTS,
        pbData,
        cbData,
        0,
        pvcrl_dist_info, @cbBuff) = False then
        Str := SysErrorMessage(GetLastError);
    if Str = '' then
    begin
      j := pvCrl_dist_Info.cDistPoint;
      Result := 'CRL dist cnt: ' + IntToStr(j) + #9;
      pvcrl_dist_point := pvCrl_dist_Info.rgDistPoint;
      for ix := 0 to j - 1 do
        begin
          DistPointName := pvCrl_Dist_Point.DistPointName;
          if DistPointName.dwDistPointNameChoice = CRL_DIST_POINT_FULL_NAME then
            begin
              str := '';
              CertAltNameInfo := DistPointName.FullName;
              CertAltNameEntry := CertAltNameInfo.rgAltEntry;
              if CertAltNameEntry.dwAltNameChoice = CERT_ALT_NAME_URL then
                begin
                  str := CertAltNameEntry.pwszURL;
                  lcstr := LowerCase(str);
                  //Only send http or URL's that end in .COM or .GOV for now
                  if (pos('http' , lcstr) = 1) or
                     (pos('.com/', lcstr) > 0) or
                     (pos('.gov/', lcstr) > 0) then
                              Result := Result + str + #9;
                end;
           end;
           inc(pvcrl_dist_point, 1);
       end;
    end;
end;

//See if the Cert is valid for Signing.
function tCryptography.SigningCert(pCertCtx: PCCERT_CONTEXT): Integer;
var
    by: byte;
    pb: pbyte;
begin
    Result := 0;
    by := 0;
    pb := @by;
    if CertGetIntendedKeyUsage(c_ENCODING_TYPE,
                   pCertCtx.pCertInfo,
                   pb,
                   1) then
       Result := by;
end;

function sCardReady: boolean;
const
    MAX_SCARD_READERS = 10;
var
    szReaders: string;
    dwI: DWORD;
    cch: integer;
    Str: String;
    ActiveProtocol: DWORD;
    fhSC: sCardContext;
    fhCard: longint;
    offset, index: Integer;
    done: Boolean;
    charval: Char;
begin
    Result := False;
    dwi := SCardEstablishContext(SCARD_SCOPE_USER,
        nil,
        nil, @fhSC);
    //See if we got a handle
    if dwi <> SCARD_S_SUCCESS then
    begin
      exit;
    end;
//    dwi := SCardListReadersA(fhSC,   hint fix
    SCardListReadersA(fhSC,
        nil,
        nil,
        cch);
    setlength(szReaders, cch);
    dwi := SCardListReadersA(fhSC,
        nil,
        PChar(szReaders),
        cch);
    if dwi = SCARD_S_SUCCESS then
      Result := True;
    // check for card in reader
    offset := 1;
    done := false;
    Str := StrPas(PChar(szReaders));
    while not done do
    begin
      dwi := SCardConnectA(fhSC, PChar(Str), SCARD_SHARE_SHARED, 3, fhCard, @ActiveProtocol);
      if dwi = SCARD_S_SUCCESS then
        done := true
      else
      begin
        for index := offset to cch do
        begin
          offset := index;
          charval := szReaders[index];
          if charval = #0 then
            break;
        end;
        offset := offset + 1;
        if szReaders[offset] = #0 then
          done := true
        else
        begin
          for index := 1 to cch-offset+1 do
          begin
            szReaders[index] := szReaders[index+offset-1];
          end;
          Str := StrPas(PChar(szReaders));
          offset := 1;
        end;
      end;
    end;
    if not (dwi = SCARD_S_SUCCESS) then
    begin
      Result := false;
      Str := SysErrorMessage(dwi);
      ShowMessage(Str);
    end;
end;


procedure tCryptography.Reset;
begin
    isDEAsig := True;  //Are we doing a DEA signature
    SigningStatus := False;
    fHashStr := '';
    fSignatureStr := '';
    DataBuffer := '';
    Reason := '';
    CrlUrl := '';
end;


// sCardReset and sCardReattach are not needed if CheckPINValue, below,
// is used.
procedure TCryptography.sCardReset;
begin
    SCardDisconnect(fhCard,SCARD_UNPOWER_CARD);
    fisCardReset := true;
end;

procedure TCryptography.sCardReattach;
var
  PActiveProtocol: LongInt;
begin
    SCardReconnect(fhCard, SCARD_SHARE_SHARED, 3, SCARD_LEAVE_CARD, PActiveProtocol);
    fisCardReset := false;
end;

function checkPINValue(InputForm: TComponent): TPINResult;
var
  ready: Boolean;
  handle2: DWORD;
  Container: String;
  ErrVal: Integer;
  Done: Boolean;
  fPinEntry: TfrmPINPrompt;
  LoopCount: Integer;
begin
  if not sCardReady then
  begin
    ShowMessage('Put a smart card in the Reader, then Press OK');
    sleep(5000);
    if not sCardReady then
    begin
      Result := prError;
      exit;
    end;
  end;
  handle2 := 0;
  Container := '';
  ready := CryptAcquireContext(@handle2,PChar(Container),pchar('ActivClient Cryptographic Service Provider'),1,0);
  if ready = false then
  begin
   // Unable to aquire context, check if failure was due to
   // absence of key container.

   CryptAcquireContext(@handle2,
                pchar(Container),
                pchar('ActivClient Cryptographic Service Provider'),
                1,
                CRYPT_NEWKEYSET);
  end;
  if handle2 = 0 then
  begin
    ErrVal := GetLastError;
    ShowMessage('Could not aquire context Last Error val was '+IntToStr(ErrVal)+'  '+SysErrorMessage(ErrVal));
    Result := prError;
    exit;
  end;
  try
    Result := prOK;
    Done := false;
    LoopCount := 1;
    fPinEntry := TfrmPINPrompt.Create(InputForm);
    try
      while not Done do
      begin
        fPinEntry.edtPINValue.Text := '';
        if fPinEntry.ShowModal() = mrOK then
        begin
          PinValue := fPinEntry.edtPinValue.Text;
          if PinValue = '' then
          begin
            ShowMessage('Enter a valid PIN value or Press Cancel');
            Dec(LoopCount);
          end
          else
          begin
            ready := SetPinValue(PinValue,handle2);
            if ready then
            begin
              LastPINValue := PinValue;
              Result := prOK;
              Done := true;
            end
            else
            begin
              if LoopCount < 3 then
              begin
                ShowMessage('Invalid PIN entry - You only have '+IntToStr(3-LoopCount)+' attempts left before it is locked.');
              end
              else
              begin
                ShowMessage('That was three (3) unsuccessful tries, the Card Reader is Locked');
                Result := prLocked;
                Done := true;
              end;
            end;
          end;
          Inc(LoopCount);
        end
        else
        begin
          ShowMessage('Pin Entry was cancelled');
          Result := prCancel;
          Done := true;
        end;
      end;
    finally
      fPinEntry.Free;
    end;
  finally
    if not (handle2 = 0) then
    begin
      CryptReleaseContext(handle2, 0);
    end;
  end;
end;

function SetPinValue(PinValue: String; handle: Dword): Boolean;
var
  handleValue: DWord;
  Container: String;
  isNewHandle: Boolean;
  text: array [0..5000] of char;
  Flags: Cardinal;
  text1: PByte;
  i: integer;
begin
  isNewHandle := false;
  handleValue := handle;
  try
    if (handleValue = 0) then
    begin
      result := CryptAcquireContext(@handleValue,PChar(Container),pchar('ActivClient Cryptographic Service Provider'),1,0);
      if not result then
      begin
       // Unable to aquire context, check if failure was due to
       // absence of key container.
       result := CryptAcquireContext(@handleValue,
                  pchar(Container),
                  pchar('ActivClient Cryptographic Service Provider'),
                  1,
                  CRYPT_NEWKEYSET);
      end;
      if not result then
        exit;
      isNewHandle := true;
    end;
    Flags := 0;
    for i := 1 to Length(PinValue) do
    begin
      text[i-1] := PinValue[i];
    end;
    text[Length(PinValue)] := #0;
    text1 := @text;
    result := false;
    result := CryptSetProvParam(handleValue,33,text1,Flags);
  finally
    if isNewHandle and not (handleValue = 0) then
      CryptReleaseContext(handleValue, 0);
  end;
end;


function ptochars(pbdata: pbytearray; len: DWORD): string;
var
    i: integer;
begin
    Result := '';    //Init return string
    for i := 0 to len do
    begin
        Result := Result + char(pbdata[i]);
    end;
end;  // ptochars

function getSANFromCard(InputForm: TComponent; crypto: TCryptography): String;
var
 errMsg: String;
 cpvRes: TPINResult;
begin
  crypto.TrackingMsg.Clear;
  crypto.TrackingMsg.Add('Entered getSANFromCard');
  SANFromCard := '';
  cpvRes := checkPINValue(InputForm);
  if (cpvRes = prOK) then
  begin
    crypto.FindCert;
  end;
  result := SANFromCard;
  if result = '' then
  begin
    errMsg :=    'Please verify that you are logged on to the CPRS system and that your PIV card is inserted.';
    errMsg := errMsg + ' There is a possible mismatch between your VistA last name and the last name of the certificate on your card.';
    errMsg := errMsg + ' If it matches and you are still experiencing issues, please contact your card issuer for assistance.';
//    crypto.TrackingMsg.Add('SAN value returned as null string');
    if (not(cpvRes=prCancel)) then ShowMessage(errMsg);
//  crypto.SaveLog(); // 121214 remove saving of log to PKISignError
  end;
end;

{
 * SaveLog -
 */
}
(*procedure TCryptography.SaveLog();
var
  MemoList: TStringList;
  DirName: String;
  FileName: String;
  i: Integer;
begin
      DirName := 'C:\PKISignError';
      FileName := DirName +FormatDateTime('"\PKISignError_"yyyymmdd"@"hhmmss".txt"',Now);
      MemoList := TStringList.Create;
      MemoList.Add('Tracking Data:');
      for i := 0 to TrackingMsg.Count-1 do
      begin
        MemoList.Add('  '+TrackingMsg.Strings[i]);
      end;
      if not DirectoryExists(DirName) then
        if not CreateDir(DirName) then
          raise Exception.Create('Cannot create '+DirName);
      MemoList.SaveToFile(FileName);
      MemoList.Free;
end;
  *)
end.
