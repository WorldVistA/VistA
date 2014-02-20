unit XuDsigConst;

interface

uses  WCrypt2;

const
    //cHASH_ALGID = CALG_MD5; // Hash algorithm to use
    //cHASH_ALGID = CALG_SHA; // Hash algorithm to use
    c_HASH_ALGID = CALG_SHA_256; // Hash algorithm to use
    c_CRYPT_ALGID = CALG_RC2; // Encryption algorithm to use
    // Key flags
    c_KEY_FLAGS = CRYPT_EXPORTABLE or CRYPT_CREATE_SALT or CRYPT_USER_PROTECTED;
    //Encodeing types
    c_ENCODING_TYPE = PKCS_7_ASN_ENCODING or X509_ASN_ENCODING;
    //To add a CR/LF to strings
    cCRLF = #13#10;
//    MS_ENH_RSA_AES_PROV_XP_A = 'Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)';  //type 24
    MS_ENH_RSA_AES_PROV_XP_A = 'Microsoft Enhanced RSA and AES Cryptographic Provider';// (Prototype)';  //type 24
    ACTIVE_CLIENT = 'ActivClient Cryptographic Service Provider';    //type 1
    //Use MS for test until get PIV card
{ JLI 120209
    c_SignPROV_NAME = ACTIVE_CLIENT;  //Signing provider
    c_SignPROV_type = 1;              //Must match  ^
JLI 120209  replaced by following }
    c_SignPROV_NAME = MS_ENH_RSA_AES_PROV_XP_A;  //Signing provider
    c_SignPROV_type = 24;              //Must match  ^
// end of
  //Signing provider
    c_VerPROV_NAME = MS_ENH_RSA_AES_PROV_XP_A;    //Verifing Provider
    c_VerPROV_type = 24;                           //Must match ^
    //Port # to listen on
    c_DsigPort = 10265;

    //Registry Key to check for SmartCard provider / Provider name
    c_SignRegKey = '\SOFTWARE\Vista\CSP';
    //get values CSPName and CSPType
    const c_CSPname = 'CSPName';
    const c_CSPtype = 'CSPType';
    
    cProv_1 = 'Passage Enhanced Cryptographic Provider';
    cProv_2 = 'ActivCard Gold Cryptographic Service Provider';

    //The path to the CRL store file
    c_stoFilePath = 'C:\PROGRAM FILES\VISTA\CRYPTOAPI\';
    //The CRL Store file name
    c_stoFilename = 'crlstore.sto';
    //The path for Temporary files.
    c_tempFilePath = 'c:\temp\';
    //The CRL temp file name
    c_tempFileName = 'CRLtemp.crl';
    //The CRL list file name
    c_CRLlistname = 'CRL_List.txt';
    //The File to Record events
    c_RecordFile = c_tempFilePath + 'CRL_Record.txt';
    //The Max number of records in the Record file.
    c_RecordMax = 250;
    //SmartCard reader interface
    SCARD_S_SUCCESS = 0;

    //The DEA item separator. Used in Address and Drug Schedule
    cSep = '$';
    //The DEA Final OID's
    cDEAversion =  '2.16.840.1.101.3.5.1';
    cDEAname =     '2.16.840.1.101.3.5.2';
    cDEAnumber =   '2.16.840.1.101.3.5.3';
    cDEAschedule = '2.16.840.1.101.3.5.4';
    cDEAactivity = '2.16.840.1.101.3.5.5';
    cDEApostal =   '2.16.840.1.101.3.5.6';

    //The DEA Schedule Bit string
    //The bitstring for schedule from the Cert.
    // 0 1 1 1 1 1 1 0
    //             |- 5
    //           |- 4
    //         |- 3N
    //       |- 3
    //     |- 2N
    //   |- 2

    cDEAsch2 = $40;
    cDEAsch2n = $20;
    cDEAsch3  = $10;
    cDEAsch3n = $08;
    cDEAsch4  = $04;
    cDEAsch5  = $02;

implementation


end.
