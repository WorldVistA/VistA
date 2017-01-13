//---------------------------------------------------------------------------
// Copyright 2014 The Open Source Electronic Health Record Agent
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------

unit Wcrypt2;

{
Date Created: 12/22/2014
Site Name: OSEHRA
Developer: Joseph Snyder (snyderj@osehra.org)
Description: Function Signatures for Windows Certificate management functions
}
interface

uses SysUtils, Windows, Registry, Dialogs, Classes, Forms, Controls,
  StdCtrls;
  
const
  {
    Most Values from in the const were taken from
    http://www.math.uiuc.edu/~gfrancis/illimath/windows/aszgard_mini/bin/MinGW/include/wincrypt.h

    Others have their source mentioned in comments above
    the value
  }
  CRYPT32     = 'crypt32.dll';
  ADVAPI32    = 'Advapi32.dll';
  WIN32PROJECT1 = 'Win32Project1.dll';
  ALG_CLASS_ANY=0;
  ALG_CLASS_SIGNATURE=8192;
  ALG_CLASS_MSG_ENCRYPT=16384;
  ALG_CLASS_DATA_ENCRYPT=24576;
  ALG_CLASS_HASH =32768;
  ALG_CLASS_KEY_EXCHANGE=40960;
  CALG_SHA_256 = $0000800c;
  CALG_RC2 = $00006602;
  AT_KEYEXCHANGE = 1;
  AT_SIGNATURE =  2;
  CRYPT_EXPORTABLE = 1;
  CRYPT_CREATE_SALT = 4;
  CRYPT_USER_PROTECTED = 2;
  CRYPT_MACHINE_DEFAULT= 0;
  CRYPT_FIRST = 1;
  CRYPT_NEXT  = 2;


  //http://www.mankan.or.jp/iissamples/sdk/include/wincrypt.h
  CRYPT_DECODE_NOCOPY_FLAG = $1;
  PROV_RSA_AES  = 24;
  CRYPT_NEWKEYSET  = $00000008;
  PP_NAME = 4;
  PP_CONTAINER = 6;
  PP_VERSION = 5;
  PP_SIGNATURE_PIN=33;
  PP_ENUMALGS=1;

  //http://www.jensign.com/JavaScience/dotnet/HashStream/HashStream.txt
  PKCS_7_ASN_ENCODING = $00000001;
  X509_ASN_ENCODING =   $00010000;
  HP_HASHVAL = $00000002;

  CERT_CLOSE_STORE_FORCE_FLAG = 0;
  CERT_CONTEXT_REVOCATION_TYPE = 1;
  CERT_NAME_SIMPLE_DISPLAY_TYPE = 4;

  // http://msdn.microsoft.com/en-us/library/windows/desktop/aa381133(v=vs.85).aspx
  szOID_RSA_SHA1RSA = '1.2.840.113549.1.1.5';
  szOID_RSA_SHA256RSA = '1.2.840.113549.1.1.11';
  szOID_RSA_SHA384RSA = '1.2.840.113549.1.1.12';
  szOID_RSA_SHA512RSA = '1.2.840.113549.1.1.13';


  CMSG_TYPE_PARAM  =                1;
  CMSG_CONTENT_PARAM    =           2;
  CMSG_BARE_CONTENT_PARAM   =       3;
  CMSG_INNER_CONTENT_TYPE_PARAM =   4;
  CMSG_SIGNER_COUNT_PARAM   =       5;
  CMSG_SIGNER_INFO_PARAM   =        6;
  CMSG_SIGNER_CERT_INFO_PARAM  =    7;

  //http://marc.info/?l=wine-patches&m=107792745523702
  CERT_STORE_PROV_MSG                  =(LPCSTR(1));
  CERT_STORE_PROV_MEMORY               =LPCSTR(2);
  CERT_STORE_PROV_FILE                 =LPCSTR(3);
  CERT_STORE_PROV_REG                  =LPCSTR(4);
  CERT_STORE_PROV_PKCS7                =LPCSTR(5);
  CERT_STORE_PROV_SERIALIZED           =LPCSTR(6);
  CERT_STORE_PROV_FILENAME_A           =LPCSTR(7);
  CERT_STORE_PROV_FILENAME_W           =LPCSTR(8);
  CERT_STORE_PROV_SYSTEM_A             =LPCSTR(9);
  CERT_STORE_PROV_SYSTEM_W             =LPCSTR(10);

  CERT_STORE_READONLY_FLAG =$00008000;
  CERT_STORE_OPEN_EXISTING_FLAG =$00004000;



  USAGE_MATCH_TYPE_AND=0;
  USAGE_MATCH_TYPE_OR =1;
  CRL_DIST_POINT_FULL_NAME=0;
  CERT_ALT_NAME_URL=0;

  //http://zeq2.com/SVN/Source/Tools/MinGW/include/wincrypt.h
  x509_CRL_DIST_POINTS =LPCSTR(35);
  PKCS_CONTENT_INFO    =LPCSTR(33);
  PKCS7_SIGNER_INFO    =LPCSTR(500);


  // https://groups.google.com/forum/#!topic/microsoft.public.platformsdk.security/xkOPo7RW4uw
  CERT_DIGITAL_SIGNATURE_KEY_USAGE=$80;
  CERT_KEY_AGREEMENT_KEY_USAGE=$08;
  CERT_KEY_ENCIPHERMENT_KEY_USAGE=$20;
  CERT_DATA_ENCIPHERMENT_KEY_USAGE=$10;
  CERT_NON_REPUDIATION_KEY_USAGE=$40;
  CERT_OFFLINE_CRL_SIGN_KEY_USAGE=$02;
  CERT_KEY_CERT_SIGN_KEY_USAGE=$04;

  //http://openwatcom.org:4000/@md=d&cd=//&cdf=//depot/V2/src/w32api/include/wincrypt.mh&ra=s&c=U54@//depot/V2/src/w32api/include/wincrypt.mh?ac=64&rev1=1
  CERT_VERIFY_REV_CHAIN_FLAG             = $00000001;
  CERT_VERIFY_CACHE_ONLY_BASED_REVOCATION= $00000002;
  CERT_VERIFY_REV_ACCUMULATE_TIMEOUT_FLAG= $00000004;
  CERT_VERIFY_REV_SERVER_OCSP_FLAG       = $00000008;


  CERT_NAME_EMAIL_TYPE=1;
  //  http://doxygen.reactos.org/d7/d4a/wincrypt_8h_source.html
  CMSG_BARE_CONTENT_FLAG            =  $00000001;
  CMSG_LENGTH_ONLY_FLAG             =  $00000002;
  CMSG_DETACHED_FLAG                =  $00000004;
  CMSG_AUTHENTICATED_ATTRIBUTES_FLAG=  $00000008;
  CMSG_CONTENTS_OCTETS_FLAG         =  $00000010;
  CMSG_MAX_LENGTH_FLAG              =  $00000020;
  CMSG_CMS_ENCAPSULATED_CONTENT_FLAG=  $00000040;
  CMSG_CRYPT_RELEASE_CONTEXT_FLAG   =  $00008000;
  CMSG_CTRL_VERIFY_SIGNATURE        = 1;
  CMSG_CTRL_DECRYPT                 = 2;
  CMSG_CTRL_VERIFY_HASH             = 5;
  CMSG_CTRL_ADD_SIGNER              = 6;
  CMSG_CTRL_DEL_SIGNER              = 7;
  CMSG_CTRL_ADD_SIGNER_UNAUTH_ATTR  = 8;
  CMSG_CTRL_DEL_SIGNER_UNAUTH_ATTR  = 9;
  CMSG_CTRL_ADD_CERT                = 10;
  CMSG_CTRL_DEL_CERT                = 11;
  CMSG_CTRL_ADD_CRL                 = 12;
  CMSG_CTRL_DEL_CRL                 = 13;
  CMSG_CTRL_ADD_ATTR_CERT           = 14;
  CMSG_CTRL_DEL_ATTR_CERT           = 15;
  CMSG_CTRL_KEY_TRANS_DECRYPT       = 16;
  CMSG_CTRL_KEY_AGREE_DECRYPT       = 17;
  CMSG_CTRL_MAIL_LIST_DECRYPT       = 18;
  CMSG_CTRL_VERIFY_SIGNATURE_EX     = 19;
  CMSG_CTRL_ADD_CMS_SIGNER_INFO     = 20;

  //Trust Error Conditions; used XuDigsigS:1236
  CERT_TRUST_NO_ERROR=0;
  CERT_TRUST_IS_NOT_TIME_VALID=1;
  CERT_TRUST_IS_NOT_TIME_NESTED=2;
  CERT_TRUST_IS_REVOKED=3;
  CERT_TRUST_IS_NOT_SIGNATURE_VALID=4;
  CERT_TRUST_IS_NOT_VALID_FOR_USAGE=5;
  CERT_TRUST_IS_UNTRUSTED_ROOT=6;
  CERT_TRUST_REVOCATION_STATUS_UNKNOWN=7;
  CERT_TRUST_IS_CYCLIC=8;
  CERT_TRUST_IS_PARTIAL_CHAIN=9;
  CERT_TRUST_CTL_IS_NOT_TIME_VALID=10;
  CERT_TRUST_CTL_IS_NOT_SIGNATURE_VALID=11;
  CERT_TRUST_CTL_IS_NOT_VALID_FOR_USAGE=12;

  //Trust Information Status: XuDigsigS:1275
  CERT_TRUST_HAS_EXACT_MATCH_ISSUER=0;
  CERT_TRUST_HAS_KEY_MATCH_ISSUER=1;
  CERT_TRUST_HAS_NAME_MATCH_ISSUER=2;
  CERT_TRUST_IS_SELF_SIGNED=3;
  CERT_TRUST_HAS_PREFERRED_ISSUER=4;
  CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY=5;
  CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS=6;
  CERT_TRUST_IS_COMPLEX_CHAIN=7;


  //http://www.reactos.org/pipermail/ros-diffs/2007-September/018778.html
  CMSG_DATA           =      1;
  CMSG_SIGNED         =      2;
  CMSG_ENVELOPED      =      3;
  CMSG_SIGNED_AND_ENVELOPED= 4;
  CMSG_HASHED         =      5;
  CMSG_ENCRYPTED      =      6;
  //http://code.hhnotifier.com/Main/Cert/CertApiExt.pas.html
  CERT_ID_ISSUER_SERIAL_NUMBER    = 1;
  CERT_ID_KEY_IDENTIFIER          = 2;
  CERT_ID_SHA1_HASH               = 3;

  CERT_FIND_SUBJECT_STR =7;

  //http://msdn.microsoft.com/en-us/library/system.security.permissions.keycontainerpermissionaccessentry.providertype(v=vs.110).aspx
  PROV_RSA_FULL =1;
  PROV_RSA_SIG =2;
  PROV_DSS =3;
  PROV_DSS_DH= 13;
  PROV_DH_SCHANNEL =18;
  PROV_FORTEZZA =4;
  PROV_MS_EXCHANGE= 5;
  PROV_RSA_SCHANNEL =12;
  PROV_SSL =6;

  //http://www.math.uiuc.edu/~gfrancis/illimath/windows/aszgard_mini/bin/MinGW/include/wincrypt.h
  CERT_NAME_STR_ENABLE_T61_UNICODE_FLAG =131072;
  CERT_FIND_ANY =0;
  CERT_FIND_CERT_ID =1048576;
  CERT_FIND_CTL_USAGE =655360;
  CERT_FIND_ENHKEY_USAGE= 655360;
  CERT_FIND_EXISTING= 851968;
  CERT_FIND_HASH =65536;
  CERT_FIND_ISSUER_ATTR= 196612;
  CERT_FIND_ISSUER_NAME= 131076;
  CERT_FIND_ISSUER_OF =786432;
  CERT_FIND_KEY_IDENTIFIER= 983040;
  CERT_FIND_KEY_SPEC =589824;
  CERT_FIND_MD5_HASH =262144;
  CERT_FIND_PROPERTY= 327680;
  CERT_FIND_PUBLIC_KEY =393216;
  CERT_FIND_SHA1_HASH= 65536;
  CERT_FIND_SIGNATURE_HASH= 917504;
  CERT_FIND_SUBJECT_ATTR =196615;
  CERT_FIND_SUBJECT_CERT= 720896;
  CERT_FIND_SUBJECT_NAME =131079;
  CERT_FIND_SUBJECT_STR_A =458759;
  CERT_FIND_SUBJECT_STR_W =524295;
  CERT_FIND_ISSUER_STR_A =458756;
  CERT_FIND_ISSUER_STR_W =524292;
  CERT_FIND_OR_ENHKEY_USAGE_FLAG=16;
  CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG=  1;
  CERT_FIND_NO_ENHKEY_USAGE_FLAG=  8;
  CERT_FIND_VALID_ENHKEY_USAGE_FLAG = 32;
  CERT_FIND_EXT_ONLY_ENHKEY_USAGE_FLAG=  2;

  //http://msdn.microsoft.com/en-us/library/windows/desktop/aa376078(v=vs.85).aspx
  CERT_CHAIN_CACHE_END_CERT = $00000001;
  CERT_CHAIN_REVOCATION_CHECK_CACHE_ONLY=$80000000;
  CERT_CHAIN_REVOCATION_CHECK_OCSP_CERT=$04000000;
  CERT_CHAIN_CACHE_ONLY_URL_RETRIEVAL=$00000004;
  CERT_CHAIN_DISABLE_PASS1_QUALITY_FILTERING=$00000040;
  CERT_CHAIN_DISABLE_MY_PEER_TRUST=$00000800;
  CERT_CHAIN_ENABLE_PEER_TRUST=$00000400;
  CERT_CHAIN_RETURN_LOWER_QUALITY_CONTEXTS=$00000080;
  CERT_CHAIN_DISABLE_AUTH_ROOT_AUTO_UPDATE=$00000100;
  CERT_CHAIN_REVOCATION_ACCUMULATIVE_TIMEOUT=$08000000;
  CERT_CHAIN_TIMESTAMP_TIME=$00000200;
  CERT_CHAIN_REVOCATION_CHECK_END_CERT=$10000000;
  CERT_CHAIN_REVOCATION_CHECK_CHAIN=$20000000;
  CERT_CHAIN_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT=$40000000;


  // http://referencesource.microsoft.com/#System.Security/cryptography/cryptoapi.cs
  CERT_STORE_ADD_NEW                                 = 1;
  CERT_STORE_ADD_USE_EXISTING                        = 2;
  CERT_STORE_ADD_REPLACE_EXISTING                    = 3;
  CERT_STORE_ADD_ALWAYS                              = 4;
  CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES = 5;
  CERT_STORE_ADD_NEWER                               = 6;
  CERT_STORE_ADD_NEWER_INHERIT_PROPERTIES            = 7;

type

  WCRYPT2Type = record
    value:DWORD;
    class operator Implicit(a:WCRYPT2Type): boolean;
    class operator Implicit(a:WCRYPT2Type): cardinal;
    class operator GreaterThan(a:WCRYPT2Type;b:DWORD):boolean;
    class operator Equal(a:WCRYPT2Type;b:DWORD):boolean;
    class operator NotEqual(a:WCRYPT2Type;b:DWORD):boolean;
  end;

  pCharArray = array[0..0] of pByte;
  ppCharArray = ^pCharArray;
  //ByteArray = array[0..0] of byte;
  //pByteArray = ^ByteArray;
  DWORDArray = array[0..0] of DWORD;
  pDwordArray = ^DWORDArray;
  ALG_ID = DWORD;

  HCRYPTPROV = ULONG;
  PHCRYPTPROV = ^HCRYPTPROV;
  HCRYPTKEY  = ULONG;
  HCRYPTHASH = ULONG;
  HCRYPTSTORE = ULONG;
  HCRYPTMSG   = pointer;
  HCERTSTORE  = DWORD;
  HCERTCHAINENGINE = DWORD;
  pHCERTCHAINENGINE= ^HCERTCHAINENGINE;

  CERT_CHAIN_ENGINE_CONFIG = record
    cbSize:DWORD;
    hRestrictedRoot :HCERTSTORE;
    hRestrictedTrust:HCERTSTORE;
    hRestrictedOther:HCERTSTORE;
    cAdditionalStore:DWORD;
    rghAdditionalStore:HCERTSTORE;
    dwFlags : DWORD;
    dwUrlRetrievalTimeout:DWORD;
    MaximumCachedCertificates:DWORD;
    CycleDetectionModulus:DWORD;
  end;
  PCERT_CHAIN_ENGINE_CONFIG = ^CERT_CHAIN_ENGINE_CONFIG;

  TRUST_STATUS = record
    dwErrorStatus: DWORD;
    dwInfoStatus : DWORD;
  end;

  extension_param = record
    CbData : DWORD;
  end;

  CRYPT_INTEGER_BLOB= record
    cbData : DWORD;
    pbData : pbytearray;
  end;

  CRYPT_OBJID_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;

  PCERT_EXTENSION = ^CERT_EXTENSION;
  CERT_EXTENSION = record
    pszObjID : LPSTR;
    fCritical: boolean;
    Value: CRYPT_OBJID_BLOB;
  end;

  CRYPT_ALGORITHIM_IDENTIFIER = record
    pszObjId : string;
    parameters : CRYPT_OBJID_BLOB;
  end;

  CERT_NAME_BLOB = record
    cbData : DWORD;
    pbData : pByte;
  end;

  CRYPT_BIT_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;

  CRYPT_DATA_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;

  CRL_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;

  CERT_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;
 CRYPT_ATTR_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;
 CRYPT_HASH_BLOB =record
    cbData : DWORD;
    pbData : pByte;
  end;

  pCRL_BLOB=^CRL_BLOB;
  pCERT_BLOB=^CERT_BLOB;
  pCRYPT_DATA_BLOB=^CRYPT_DATA_BLOB;
  pCRYPT_ATTR_BLOB=^CRYPT_ATTR_BLOB;
  pCRYPT_HASH_BLOB=^CRYPT_HASH_BLOB;

  CERT_PUBLIC_KEY_INFO = record
    Algorithm : CRYPT_ALGORITHIM_IDENTIFIER;
    PublicKey : CRYPT_BIT_BLOB ;
  end;
  pCERT_PUBLIC_KEY_INFO = ^CERT_PUBLIC_KEY_INFO;

 //http://msdn.microsoft.com/en-us/library/windows/desktop/aa377200(v=vs.85).aspx
  CERT_INFO = record
    dwVersion             : DWORD;
    SerialNumber          : CRYPT_INTEGER_BLOB;
    SignatureAlgorithm    : CRYPT_ALGORITHIM_IDENTIFIER ;
    Issuer                : CERT_NAME_BLOB;
    NotBefore             : FILETIME;
    NotAfter              : FILETIME;
    Subject               : CERT_NAME_BLOB;
    SubjectPublicKeyInfo  : CERT_PUBLIC_KEY_INFO;
    IssuerUniqueId        : CRYPT_BIT_BLOB;
    SubjectUniqueId       : CRYPT_BIT_BLOB;
    cExtension            : DWORD;
    rgExtension           : PCERT_EXTENSION;
  end;
  PCERT_INFO=^CERT_INFO;

  CERT_CONTEXT = record
    dwCertEncodingType: DWORD;
    pbCertEncoded: pointer;
    cbCertEncoded: DWORD;
    pCertInfo : PCERT_INFO;
    hCertStore : HCERTSTORE;
  end;
  PCCERT_CONTEXT = ^CERT_CONTEXT;
  PCERT_CONTEXT = ^CERT_CONTEXT;

  CERT_REVOCATION_STATUS = record
    cbSize  : DWORD;
    dwIndex : DWORD;
    dwError : DWORD;
    dwReason: DWORD;
    fHasFreshnessTime : BOOLEAN;
    dwFreshnessTime : DWORD
  end;
  PCERT_REVOCATION_STATUS = ^CERT_REVOCATION_STATUS;

  CRYPT_ALGORITHM_IDENTIFIER = record
    pszObjId:  string ;
    Parameters: CRYPT_OBJID_BLOB;
  end;
  PCRYPT_ALGORITHM_IDENTIFIER=^CRYPT_ALGORITHM_IDENTIFIER;
  PPVOID = pointer;

  CRYPT_SIGN_MESSAGE_PARA = record
    cbSize: DWORD;
    dwMsgEncodingType: DWORD;
    pSigningCert: PCCERT_CONTEXT;
    HashAlgorithm : CRYPT_ALGORITHM_IDENTIFIER;
    pvHashAuxInfo: pointer;
    cMsgCert: DWORD;
    rgpMsgCert:pointer;//  PCCERT_CONTEXT;
    cMsgCrl: DWORD;
    rgpMsgCrl:pointer;// PCCRL_CONTEXT;
    cAuthAttr: DWORD;
    rgAuthAttr: pointer;//PCRYPT_ATTRIBUTE;
    cUnauthAttr: DWORD;
    rgUnauthAttr:pointer;// PCRYPT_ATTRIBUTE;
    dwFlags: DWORD;
    dwInnerContentType: DWORD;
  end;

  CRYPT_KEY_PROV_PARAM = record
    dwParam : DWORD;
    pbData : pointer;
    cbData : DWORD;
    dwFlags : DWORD;
  end;
  PCRYPT_KEY_PROV_PARAM = ^CRYPT_KEY_PROV_PARAM;

  CRYPT_KEY_PROV_INFO = record
    pwszContainerName: pointer;
    pwszProvName: pointer;
    dwProvType:DWORD;
    dwFlags:DWORD;
    cProvParam:DWORD;
    rgProvParam:PCRYPT_KEY_PROV_PARAM;
    dwKeySpec:DWORD;
  end;
  PCRL_DIST_POINT = ^CRL_DIST_POINT;

  PCRL_DIST_POINTS_INFO=^CRL_DIST_POINTS_INFO;
  CRL_DIST_POINTS_INFO = record
    rgDistPoint:PCRL_DIST_POINT;
    cDistPoint: DWORD;
  end;
  PCERT_ALT_NAME_ENTRY = record
    pwszURL:STRING;
    dwAltNameChoice:DWORD;
  end;
  CERT_ALT_NAME_INFO = record
    rgAltEntry: PCERT_ALT_NAME_ENTRY;
  end;

  CRL_DIST_POINT_NAME =record
    dwDistPointNameChoice: DWORD;
    FullName : CERT_ALT_NAME_INFO;
  end;
  CRL_DIST_POINT = record
    DistPointName: CRL_DIST_POINT_NAME;
  end;

  CRYPT_ATTRIBUTE = record
    pszObjId:string;
    cValue:DWORD;
    rgValue:PCRYPT_ATTR_BLOB;
  end;
  pCRYPT_ATTRIBUTE = ^CRYPT_ATTRIBUTE;


  CERT_ISSUER_SERIAL_NUMBER = record
    Issuer: CERT_NAME_BLOB;
    SerialNumber: CRYPT_INTEGER_BLOB;
  end;
  pCERT_ISSUER_SERIAL_NUMBER=^CERT_ISSUER_SERIAL_NUMBER;
  CERT_ID=record
    dwIDChoice:DWORD;
    case DWORD of
      1:
        (IssuerSerialNumber:CERT_ISSUER_SERIAL_NUMBER; );
      2:
        (KeyId:CRYPT_HASH_BLOB;);
      3:
        (HashId:CRYPT_HASH_BLOB;);
  end;

  CMSG_SIGNER_ENCODE_INFO=record
    cbSize:DWORD;
    pCertInfo:PCERT_INFO;
    dwKeySpec:DWORD;
    HashAlgorithm:CRYPT_ALGORITHM_IDENTIFIER;
    cAuthAttr:DWORD;
    rgAuthAttr: array of pCRYPT_ATTRIBUTE;
    cUnauthAttr:DWORD;
    rgUnauthAttr:array of pCRYPT_ATTRIBUTE;
    SignerID : CERT_ID;
    HashEncryptionAlgorithm : CRYPT_ALGORITHM_IDENTIFIER;
  end;
  pCMSG_SIGNER_ENCODE_INFO = ^CMSG_SIGNER_ENCODE_INFO;

  CMSG_SIGNED_ENCODE_INFO= record
    cbSize:DWORD;
    cSigners:DWORD;
    rgSigners: array of pCMSG_SIGNER_ENCODE_INFO;
    cCertEncoded:DWORD;
    rgCertEncoded: array of pCERT_BLOB;
    cCrlEncoded:DWORD;
    rgCrlEncoded: array of pCRL_BLOB;
    cAttrCertEncoded:DWORD;
    rgAttrCertEncoded:array of pCERT_BLOB;
  end;

  CERT_STRONG_SIGN_SERIALIZED_INFO = record
    dwFlags : DWORD;
    pwszCNGSignHashAlgids : pointer;
    pwszCNGPubKeyMinBitLengths:pointer;
  end;

  pCERT_STRONG_SIGN_SERIALIZED_INFO =^CERT_STRONG_SIGN_SERIALIZED_INFO;

  CERT_STRONG_SIGN_PARA= record
    cbSize : DWORD;
    dwInfoChoice : DWORD;
    case DWORD of
      1: (pvInfo: pointer;);
      2: (pSerializedInfo: PCERT_STRONG_SIGN_SERIALIZED_INFO;);
      3: (pszOID: pointer;);
  end;
  PCCERT_STRONG_SIGN_PARA=^CERT_STRONG_SIGN_PARA;

  CRYPT_VERIFY_MESSAGE_PARA = record
    cbSize :DWORD;
    dwMsgAndCertEncodingType:DWORD;
    hCryptProv : HCRYPTPROV;
    pfnGetSignerCertificate: pointer;
    pvGetArg: pointer;
  end;
  pCRYPT_VERIFY_MESSAGE_PARA=^CRYPT_VERIFY_MESSAGE_PARA;

  CRYPT_DECRYPT_MESSAGE_PARA = record
    cbSize:DWORD;
    EncodingType:DWORD;
    cCertStore:DWORD;
    rghCertStore: array of HCERTSTORE;
    dwFlags:DWORD;
  end;
  pCRYPT_DECRYPT_MESSAGE_PARA = ^CRYPT_DECRYPT_MESSAGE_PARA;

  CRYPT_ATTRIBUTES = record
    cAttr: DWORD;
    rgATTR:pCRYPT_ATTRIBUTE
  end;
  pCRYPT_ATTRIBUTES=^CRYPT_ATTRIBUTES;

  CMSG_SIGNER_INFO = record
    dwVersion:DWORD;
    Issuer: CERT_NAME_BLOB;
    SerialNumber: CRYPT_INTEGER_BLOB;
    HashAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    HashEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedHash: CRYPT_DATA_BLOB;
    AuthAttrs: CRYPT_ATTRIBUTES;
    UnauthAttrs: CRYPT_ATTRIBUTES;
  end;
  pCMSG_SIGNER_INFO=^CMSG_SIGNER_INFO;

  CERT_REVOCATION_CHAIN_PARA = record
    cbSize:DWORD;
    hChainEngine : HCERTCHAINENGINE;
    hAdditionalStore: HCERTSTORE;
    dwChainFlags: DWORD;
    dwURLRetrievalTimeout:DWORD;
    pftCurrentTime:pointer;
    pftCacheResync:pointer;
    cbMaxURLRetrievalByteCount: DWORD;
  end;
  PCERT_REVOCATION_CHAIN_PARA=^CERT_REVOCATION_CHAIN_PARA;

  CRL_ENTRY = record
    SerialNumber:CRYPT_INTEGER_BLOB;
    RevocationDate : FILETIME;
    cExtension : DWORD;
    rgExtension: array of PCERT_EXTENSION;
  end;
  PCRL_ENTRY=^CRL_ENTRY;

  CRL_INFO = record
    dwVersion : DWORD;
    SignatureAlgoithm:CRYPT_ALGORITHM_IDENTIFIER;
    Issuer : CERT_NAME_BLOB;
    ThisUpdate : FILETIME;
    NextUpdate : FILETIME;
    cCRLEntry : DWORD;
    rgCRLEntry : array of PCRL_ENTRY;
    cExtension : DWORD;
    rgExtension : array of PCERT_EXTENSION;
  end;
  PCRL_INFO=^CRL_INFO;

  CRL_CONTEXT = record
    dwCertEncodingType:DWORD;
    pbCRLEncoded:pointer;
    cbCRLEncoded:DWORD;
    pCRLInfo:PCRL_INFO;
    hCertStore:HCERTSTORE;
  end;
  PCRL_CONTEXT=^CRL_CONTEXT;
  PCCRL_CONTEXT=^CRL_CONTEXT;

  CERT_REVOCATION_CRL_INFO=record
    cbSize:DWORD;
    pBaseCRLContext:PCCRL_CONTEXT;
    pDeltaCRLContext:PCCRL_CONTEXT;
    fDeltaCRLEntry: BOOLEAN;
  end;
  PCERT_REVOCATION_CRL_INFO=^CERT_REVOCATION_CRL_INFO;

  CERT_REVOCATION_PARA = record
    cbSize:      DWORD;
    pIssuerCert: PCCERT_CONTEXT;
    cCertStore:  DWORD;
    rgCertStore: pointer;
    hCrlStore: HCERTSTORE;
    pftTimeToUse: pointer;
  end;
  PCERT_REVOCATION_PARA=^CERT_REVOCATION_PARA;

  CTL_ENTRY = record
    SubjectIdentifier:CRYPT_DATA_BLOB;
    cAttribute:DWORD;
    rgAttribute: array of PCRYPT_ATTRIBUTE;
  end;
  PCTL_ENTRY=^CTL_ENTRY;

  CERT_TRUST_STATUS = record
    dwErrorStatus:DWORD;
    dwInfoStatus:DWORD;
  end;
  PCERT_TRUST_STATUS=^CERT_TRUST_STATUS;

  CTL_USAGE = record
    cUsageIdentifier:DWORD;
    rgpszUsageIdentifier: array of LPSTR;
  end;
  PCTL_USAGE = ^CTL_USAGE ;
  CERT_ENHKEY_USAGE = CTL_USAGE;


  CTL_INFO =record
    dwVersion:DWORD;
    SubjectUsage:CTL_USAGE;
    ListIdentifier:CRYPT_DATA_BLOB;
    SequenceNumber:CRYPT_INTEGER_BLOB;
    ThisUpdate:FILETIME;
    NextUpdate:FILETIME;
    SubjectAlgorithm:CRYPT_ALGORITHIM_IDENTIFIER;
    cCTLEntry:DWORD;
    rgCTLEntry : array of PCTL_ENTRY;
    cExtension:DWORD;
    rgExtension : array of PCERT_EXTENSION;
  end;
  PCTL_INFO=^CTL_INFO;
  CTL_CONTEXT = record
    dwMsgAndCertEncodingType:DWORD;
    pbCtlEncoded:pointer;
    cbCtlEncoded:DWORD;
    pCtlInfo : PCTL_INFO;
    hCertStore: HCERTSTORE;
    hCryptMsg : HCRYPTMSG;
    pbCTLContent: pointer;
    cbCtlContent:DWORD;
  end;
  PCCTL_CONTEXT=^CTL_CONTEXT;
  PCTL_CONTEXT=^CTL_CONTEXT;

  CERT_TRUST_LIST_INFO = record
    cbSize: DWORD;
    pCtlEntry:PCTL_ENTRY;
    pCtlContext:PCCTL_CONTEXT;
  end;
  PCERT_TRUST_LIST_INFO=^CERT_TRUST_LIST_INFO;

  CERT_SIMPLE_CHAIN = record
    cbSize:DWORD;
    TrustStatus:CERT_TRUST_STATUS;
    cElement :DWORD;
    rgpElement : array of pointer;
    pTrustListInfo:PCERT_TRUST_LIST_INFO;
    fHasRevocationFreshnessTime:BOOLEAN;
    dwRevocationFreshnessTime:DWORD;
  end;
  PCERT_SIMPLE_CHAIN=^CERT_SIMPLE_CHAIN;

  PCCERT_CHAIN_CONTEXT = ^CERT_CHAIN_CONTEXT;

  CERT_CHAIN_CONTEXT = record
    cbSize: DWORD;
    TrustStatus:  CERT_TRUST_STATUS;
    cChain:DWORD;
    rgpChain: PCERT_SIMPLE_CHAIN;
    cLowerQualityChainContext: DWORD;
    rgpLowerQualityChainContext: PCCERT_CHAIN_CONTEXT;
    fHasRevocationFreshnessTime:BOOLEAN;
    dwRevocationFreshnessTime: DWORD;
  end;
  PCERT_CHAIN_CONTEXT = ^CERT_CHAIN_CONTEXT;

  CERT_USAGE_MATCH = record
    dwType: DWORD;
    Usage: CERT_ENHKEY_USAGE;
  end;
  pCERT_USAGE_MATCH=^CERT_USAGE_MATCH;

  CERT_CHAIN_PARA = record
    cbSize:DWORD;
    RequestedUsage: CERT_USAGE_MATCH;
    RequestedIssuancePolicy:  CERT_USAGE_MATCH;
    dwUrlRetrievalTimeout: DWORD;
    fCheckRevocationFreshnessTime: BOOLEAN;
    dwRevocationFreshnessTime : DWORD;
    //Windows VistA
    //pftCacheResync : pointer;

    //Windows 8
    //pStrongSignPara :PCCERT_STRONG_SIGN_PARA ;
    //dwStrongSignFlags: DWORD;
  end;
  
  //CRYPT* function signatures

  function CryptAcquireContextA( pHProv: Pointer; pszContainer: PWideChar; pszProvider: PWideChar; dwProvType: DWORD; dwFlags: DWORD) : boolean; stdcall;
  function CryptAcquireContext( pHProv: Pointer; pszContainer: PWideChar; pszProvider: PWideChar; dwProvType: DWORD; dwFlags: DWORD) : boolean; stdcall;
  function CryptGetProvParam(hProv: HCRYPTPROV; dwParam: DWORD; pbData:  pointer; pdwDataLen: pointer; dwFlags: DWORD) : boolean; stdcall;
  function CryptDestroyKey(hPassKey: HCRYPTKEY) : boolean; stdcall;
  function CryptCreateHash(hProv: HCRYPTPROV; c_HASH_ALGID: ALG_ID;kHEY: HCRYPTKEY; dwFlags: DWORD;phHash: pointer) : boolean; stdcall;
  function CryptDestroyHash(hHash: HCRYPTHASH) : boolean; stdcall;
  function CryptHashData(hHash: HCRYPTHASH; pB: pByte; cnt: DWORD; flag: DWORD) : boolean; stdcall;
  function CryptReleaseContext(hProv: HCRYPTPROV; force_flag: ULONG) : boolean; stdcall;
  function CryptGetHashParam(hHash: HCRYPTHASH; HP_HASHVAL: DWORD; pbData: pointer;pdwDataLen: pointer; dwFlags: DWORD) : boolean; stdcall;
  function CryptSignMessage(pSignPara: pointer; fDetachedSig:boolean;cToBeSigned:DWORD;rgpbToBeSigned:pointer;rgcbToBeSigned:pointer; pbSignedBlob:pointer; pcbSignedBlob: PDWORD): boolean; stdcall;
  function CryptMsgOpenToDecode(encodingtype:DWORD;dwFlags:DWORD;dwMessageType:DWORD;HCryptProv:DWORD;recipInfo:pointer;streamInfo:pointer): HCRYPTMSG; stdcall;
  function CryptMsgOpenToEncode(encodingtype:DWORD;dwFlags:DWORD;dwMessageType:DWORD;MsgEncodeInfo:pointer;InnerContentObjID:pointer;streamInfo:pointer): HCRYPTMSG; stdcall;
  function CryptMsgUpdate(hmsg:HCRYPTMSG; pBlob: pointer;blobsize:DWORD;lastcall:boolean):boolean; stdcall;
  function CryptMsgGetParam(hMsg:HCRYPTMSG;dwParamType:DWORD;dwIndex:DWORD;pvData:pointer;pcbData:pointer) : boolean; stdcall;
  function CryptMsgControl(msg:HCRYPTMSG;flags:DWORD;CMSG_CTRL_VERIFY_SIGNATURE:DWORD;certinfo:pointer): boolean; stdcall;
  function CryptDecodeObject(encodingtype:DWORD;StructType:LPCSTR;pbData:pointer;cbData:DWORD;flag:DWORD;dist_info: pointer ;cbuff:pointer):boolean; stdcall;
  function CryptSetProvParam(handleValue:DWORD;i:DWORD;text:pointer;Flags:Cardinal): boolean; stdcall;
  function CryptMsgClose(hmsg: HCRYPTMSG):boolean; stdcall;
  function CryptVerifyMessageSignature(verifyPara:PCRYPT_VERIFY_MESSAGE_PARA;SignerIndex:DWORD;pbSignedBlob:pointer;cbSignedBlob:DWORD;pbDecoded:pointer;pcbDecoded:pointer;ppSignerCert:pointer):boolean; stdcall;
  function CryptGenKey(hProv: HCRYPTPROV;AlgId: ALG_ID;dwFlags:DWORD;hKey:pointer):boolean; stdcall;
  function GET_ALG_CLASS(algid:DWORD):DWORD;
  function CryptEnumProvidersA(index:DWORD;reserved:pointer;flags:DWORD;provtype:pointer;provname:pointer;provnamesize:pointer): boolean ; stdcall;
  function CryptEnumProviderTypesA(index:DWORD;reserved:pointer;flags:DWORD;provtype:pointer;provtypename:pointer;provtypenamesize:pointer):boolean ; stdcall;
  function CryptGetDefaultProviderA(provType:DWORD;reserved:DWORD;dwFlags:DWORD;provname:pointer;provnamesize:pointer) : boolean ; stdcall;

  //CERT* function signatures

  function CertVerifyRevocation(c_ENCODING_TYPE: DWORD; dwRevType: DWORD; cContext: DWORD; rgpvContext: pointer; dwFlags:DWORD; pRevPara: pointer; pRevStatus: pointer) : boolean; stdcall;
  function CertOpenSystemStoreA(hProv: HCRYPTPROV; szSubsystemProtocol: PAnsiChar) : DWORD; stdcall;
  function CertOpenSystemStore(hProv: HCRYPTPROV; szSubsystemProtocol: PAnsiChar) : DWORD; stdcall;
  function CertEnumCertificatesInStore(hCertStore: HCERTSTORE;i: pointer): PCCERT_CONTEXT; stdcall;
  function CertGetNameString(pCertContext: pointer; dwType: DWORD; dwFlags:DWORD; pvTypePara: pointer; pszNameString: pChar; cchNameString: DWORD): WCrypt2Type; stdcall;
  function CertGetNameStringA(pCertContext: pointer; dwType: DWORD; dwFlags:DWORD; pvTypePara: pointer; pszNameString: pChar; cchNameString: DWORD): WCrypt2Type; stdcall;
  function CertGetNameStringW(pCertContext: pointer; dwType: DWORD; dwFlags:DWORD; pvTypePara: pointer; pszNameString: pChar; cchNameString: DWORD): WCrypt2Type; stdcall;
  function CertVerifyTimeValidity(i: pointer; pCertInfo: pCert_Info): ShortInt; stdcall;
  function CertFindExtension( address :LPCSTR; cExtension: DWORD; rgExtension: PPVOID) : PCERT_EXTENSION; stdcall; stdcall;
  function CertOpenStore( CERT_STORE_PROV_MSG: pointer;encoding_type: DWORD;i:DWORD;flags:DWORD;hMsg:pointer):HCERTSTORE; stdcall;
  function CertGetSubjectCertificateFromStore(hCertStore:HCERTSTORE;encoding_type:DWORD;infoblob:pointer): PCCERT_CONTEXT; stdcall;
  function CertCreateCertificateChainEngine( config: pointer;var chainEngine):boolean; stdcall;
  function CertGetCertificateChain(chainEngine:HCERTCHAINENGINE;CertContext:PCCERT_CONTEXT;time:pointer;additionalstores:DWORD;ChainPara:pointer;dwFlags:DWORD;reserved:pointer;var ChainContext:PCCERT_CHAIN_CONTEXT):boolean; stdcall;
  function CertGetIntendedKeyUsage(encodingtype:DWORD;pCertInfo:pCert_Info;pb:pointer;flag:DWORD):boolean; stdcall;
  function CertFindCertificateInStore(store:HCERTSTORE;EncodingType:DWORD;FindFlags:DWORD;FindType:DWORD;FindPara:pointer;context:PCCERT_CONTEXT):PCCERT_CONTEXT;stdcall;
  function CertFreeCertificateContext(pCertContext: pointer):boolean; stdcall;
  function CertCreateCertificateContext(dwCertEncodingType: DWORD;pbCertEncoded:pointer;cbCertEncoded:DWORD): PCCERT_CONTEXT ;stdcall;
  function CertAddCertificateContextToStore(hCertStore:HCERTSTORE;pCertContext: PCCERT_CONTEXT;dwAddDisposition:DWORD;ppStoreContext:pointer):boolean; stdcall;
  function CertDeleteCertificateFromStore(pCertContext: PCCERT_CONTEXT):boolean; stdcall;
  procedure CertFreeCertificateChainEngine(chainengine: HCERTCHAINENGINE); stdcall;
  procedure CertFreeCertificateChain(chain: PCCERT_CHAIN_CONTEXT); stdcall;
  function CertCloseStore(hCertStore :HCERTSTORE; dwFlags :DWORD):BOOL ; stdcall;

implementation

  function GET_ALG_CLASS(algid: DWORD):DWORD;
  begin
    Result :=algid;
  end;

  class operator WCRYPT2Type.Implicit(a:WCRYPT2Type): boolean;
  begin
    Result := (a.value <> 0);
  end;

  class operator WCRYPT2Type.Implicit(a:WCRYPT2Type): cardinal;
  begin
    Result := a.value;
  end;

  class operator WCRYPT2Type.GreaterThan(a:WCRYPT2Type;b:DWORD): boolean;
  begin
    Result := (a.value > b);
  end;

  class operator WCRYPT2Type.Equal(a:WCRYPT2Type;b:DWORD): boolean;
  begin
    Result := (a.value = b);
  end;

  class operator WCRYPT2Type.NotEqual(a:WCRYPT2Type;b:DWORD): boolean;
  begin
    Result := not(a.value = b);
  end;

  function CryptAcquireContextA; external ADVAPI32 name 'CryptAcquireContextA';
  function CryptAcquireContext; external ADVAPI32 name 'CryptAcquireContextA';
  function CryptReleaseContext; external ADVAPI32 name 'CryptReleaseContext';
  function CryptGetProvParam ; external ADVAPI32 name 'CryptGetProvParam';
  function CryptSetProvParam; external ADVAPI32 name 'CryptSetProvParam';

  function CryptDestroyKey; external ADVAPI32 name 'CryptDestroyKey';

  function CryptDestroyHash; external ADVAPI32 name 'CryptDestroyHash';
  function CryptCreateHash; external ADVAPI32 name 'CryptCreateHash';
  function CryptGetHashParam; external ADVAPI32 name 'CryptGetHashParam';
  function CryptHashData; external ADVAPI32 name 'CryptHashData';

  function CryptMsgClose; external CRYPT32 name 'CryptMsgClose';
  function CryptMsgOpenToDecode; external CRYPT32 name 'CryptMsgOpenToDecode';
  function CryptMsgOpenToEncode; external CRYPT32 name 'CryptMsgOpenToEncode';
  function CryptMsgUpdate; external CRYPT32 name 'CryptMsgUpdate';
  function CryptSignMessage; external CRYPT32 name 'CryptSignMessage';
  function CryptMsgGetParam; external CRYPT32 name 'CryptMsgGetParam';
  function CryptMsgControl; external CRYPT32 name 'CryptMsgControl';
  function CryptVerifyMessageSignature; external CRYPT32 name 'CryptVerifyMessageSignature';

  function CryptDecodeObject; external CRYPT32 name 'CryptDecodeObject';
  function CryptEnumProvidersA; external ADVAPI32 name 'CryptEnumProvidersA';
  function CryptEnumProviderTypesA; external ADVAPI32 name 'CryptEnumProviderTypesA';
  function CryptGetDefaultProviderA; external ADVAPI32 name 'CryptGetDefaultProviderA';
  function CryptGenKey; external ADVAPI32 name 'CryptGenKey';

  function CertOpenStore; external CRYPT32 name 'CertOpenStore';
  function CertCloseStore; external CRYPT32 name 'CertCloseStore';
  function CertFreeCertificateContext; external CRYPT32 name 'CertFreeCertificateContext';
  procedure CertFreeCertificateChainEngine; external CRYPT32 name 'CertFreeCertificateChainEngine';
  procedure CertFreeCertificateChain; external CRYPT32 name 'CertFreeCertificateChain';
  function CertVerifyRevocation; external CRYPT32 name 'CertVerifyRevocation';
  function CertOpenSystemStoreA; external CRYPT32 name 'CertOpenSystemStoreA';
  function CertOpenSystemStore; external CRYPT32 name 'CertOpenSystemStoreA';
  function CertEnumCertificatesInStore; external CRYPT32 name 'CertEnumCertificatesInStore';
  {$IF CompilerVersion < 20}
    function CertGetNameString; external CRYPT32 name 'CertGetNameStringA';
  {$ELSE}
    function CertGetNameString; external CRYPT32 name 'CertGetNameStringW';
  {$IFEND}
  function CertGetNameStringA; external CRYPT32 name 'CertGetNameStringA';
  function CertGetNameStringW; external CRYPT32 name 'CertGetNameStringW';
  function CertVerifyTimeValidity; external CRYPT32 name 'CertVerifyTimeValidity';
  function CertFindExtension; external CRYPT32 name 'CertFindExtension';
  function CertGetSubjectCertificateFromStore; external CRYPT32 name 'CertGetSubjectCertificateFromStore';
  function CertCreateCertificateChainEngine; external CRYPT32 name 'CertCreateCertificateChainEngine';
  function CertFindCertificateInStore; external CRYPT32 name 'CertFindCertificateInStore';
  function CertAddCertificateContextToStore; external CRYPT32 name 'CertAddCertificateContextToStore';
  function CertDeleteCertificateFromStore; external CRYPT32 name 'CertDeleteCertificateFromStore';
  function CertCreateCertificateContext; external CRYPT32 name 'CertCreateCertificateContext';  
  function CertGetCertificateChain; external CRYPT32 name 'CertGetCertificateChain';
  function CertGetIntendedKeyUsage; external CRYPT32 name 'CertGetIntendedKeyUsage';
  end.
