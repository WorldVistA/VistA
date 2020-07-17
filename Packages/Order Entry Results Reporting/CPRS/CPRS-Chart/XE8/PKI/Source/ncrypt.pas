unit ncrypt;

//+---------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (C) Microsoft Corporation, 2004.
//
//  File:       ncrypt.h
//
//  Contents:   Cryptographic API Prototypes and Definitions
//
//----------------------------------------------------------------------------
//
//  Translation to Delphi/Object Pascal 18 July 2018
//  blj/hoifo
//
//  Note: this version of bcrypt.h contains conditional compile flags allowing it
//  to target various versions of Windows.  As of 18 July 2018, any conditional
//  flag meant to protect an api with a version lower than Windows 7 was removed,
//  as it is assumed at this point that all VA desktops are up to at least Windows 7.
//
//  For reference, the following flags are included.  It is suggested that, when
//  VA commonly deploys operating systems at or below the level indicated by the
//  conditional flag, that the flag be removed rather than defined.  This will
//  prevent an ever-growing list of compile flags specifying various versions of
//  windows supported by bcrypt.pas
//
//  NTDDI_NT4            - Windows NT 4.0
//  NTDDI_WIN2K          - Windows 2000
//  NTDDI_WINXP          - Windows XP
//  NTDDI_WS03           - Windows Server 2003
//  NTDDI_WIN6           - Windows Vista
//  NTDDI_VISTA          - Windows Vista
//  NTDDI_WS08           - Windows Server 2008
//  NTDDI_LONGHORN       - Windows Vista
//  NTDDI_WIN7           - Windows 7
//  NTDDI_WIN8           - Windows 8
//  NTDDI_WINBLUE        - Windows 8.1
//  NTDDI_WINTHREHSOLD   - Windows 10
//  NTDDI_WIN10          - Windows 10
//
//----------------------------------------------------------------------------

interface

uses Windows, bcrypt;

const
  NCRYPTDLL = 'ncrypt.dll';

type
  SECURITY_STATUS = LONG;
  HCRYPTPROV      = ULONG_PTR;
  HCRYPTKEY       = ULONG_PTR;
  HCRYPTHASH      = ULONG_PTR;

//
// Maximum length of Key name, in characters
//
const
  NCRYPT_MAX_KEY_NAME_LENGTH      = 512;


//
// Maximum length of Algorithm name, in characters
//
  NCRYPT_MAX_ALG_ID_LENGTH        = 512;

{****************************************************************************

  NCRYPT memory management routines for functions that require
  the caller to allocate memory

****************************************************************************}
type
  PFN_NCRYPT_ALLOC = function (
    cbSize    : SIZE_T         // _In_
    ): LPVOID; stdcall;

  PFN_NCRYPT_FREE = procedure (
    pv       : LPVOID          // _In_
    ); stdcall;

  NCRYPT_ALLOC_PARA  = record
    cbSize                  : DWORD;                  // size of this structure
    pfnAlloc                : PFN_NCRYPT_ALLOC;
    pfnFree                 : PFN_NCRYPT_FREE;
  end;


//
// Microsoft built-in providers.
//
const
  MS_KEY_STORAGE_PROVIDER         = WideString('Microsoft Software Key Storage Provider');
  MS_SMART_CARD_KEY_STORAGE_PROVIDER = WideString('Microsoft Smart Card Key Storage Provider');
  MS_PLATFORM_KEY_STORAGE_PROVIDER   = WideString('Microsoft Platform Crypto Provider');
  MS_NGC_KEY_STORAGE_PROVIDER        = WideString('Microsoft Passport Key Storage Provider');

//
// Key name for sealing
//
{$ifdef NTDDI_WIN10_RS1}
const
  TPM_RSA_SRK_SEAL_KEY            = WideString('MICROSOFT_PCP_KSP_RSA_SEAL_KEY_3BD1C4BF-004E-4E2F-8A4D-0BF633DCB074');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)

//
// Common algorithm identifiers.
//

const
  NCRYPT_RSA_ALGORITHM            = BCRYPT_RSA_ALGORITHM;
  NCRYPT_RSA_SIGN_ALGORITHM       = BCRYPT_RSA_SIGN_ALGORITHM;
  NCRYPT_DH_ALGORITHM             = BCRYPT_DH_ALGORITHM;
  NCRYPT_DSA_ALGORITHM            = BCRYPT_DSA_ALGORITHM;
  NCRYPT_MD2_ALGORITHM            = BCRYPT_MD2_ALGORITHM;
  NCRYPT_MD4_ALGORITHM            = BCRYPT_MD4_ALGORITHM;
  NCRYPT_MD5_ALGORITHM            = BCRYPT_MD5_ALGORITHM;
  NCRYPT_SHA1_ALGORITHM           = BCRYPT_SHA1_ALGORITHM;
  NCRYPT_SHA256_ALGORITHM         = BCRYPT_SHA256_ALGORITHM;
  NCRYPT_SHA384_ALGORITHM         = BCRYPT_SHA384_ALGORITHM;
  NCRYPT_SHA512_ALGORITHM         = BCRYPT_SHA512_ALGORITHM;
  NCRYPT_ECDSA_P256_ALGORITHM     = BCRYPT_ECDSA_P256_ALGORITHM;
  NCRYPT_ECDSA_P384_ALGORITHM     = BCRYPT_ECDSA_P384_ALGORITHM;
  NCRYPT_ECDSA_P521_ALGORITHM     = BCRYPT_ECDSA_P521_ALGORITHM;
  NCRYPT_ECDH_P256_ALGORITHM      = BCRYPT_ECDH_P256_ALGORITHM;
  NCRYPT_ECDH_P384_ALGORITHM      = BCRYPT_ECDH_P384_ALGORITHM;
  NCRYPT_ECDH_P521_ALGORITHM      = BCRYPT_ECDH_P521_ALGORITHM;

{$ifdef NTDDI_WIN8}
const
  NCRYPT_AES_ALGORITHM            = BCRYPT_AES_ALGORITHM;
  NCRYPT_RC2_ALGORITHM            = BCRYPT_RC2_ALGORITHM;
  NCRYPT_3DES_ALGORITHM           = BCRYPT_3DES_ALGORITHM;
  NCRYPT_DES_ALGORITHM            = BCRYPT_DES_ALGORITHM;
  NCRYPT_DESX_ALGORITHM           = BCRYPT_DESX_ALGORITHM;
  NCRYPT_3DES_112_ALGORITHM       = BCRYPT_3DES_112_ALGORITHM;

  NCRYPT_SP800108_CTR_HMAC_ALGORITHM  = BCRYPT_SP800108_CTR_HMAC_ALGORITHM;
  NCRYPT_SP80056A_CONCAT_ALGORITHM    = BCRYPT_SP80056A_CONCAT_ALGORITHM;
  NCRYPT_PBKDF2_ALGORITHM             = BCRYPT_PBKDF2_ALGORITHM;
  NCRYPT_CAPI_KDF_ALGORITHM           = BCRYPT_CAPI_KDF_ALGORITHM;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

{$ifdef NTDDI_WINTHRESHOLD}
const
  NCRYPT_ECDSA_ALGORITHM          = BCRYPT_ECDSA_ALGORITHM;
  NCRYPT_ECDH_ALGORITHM           = BCRYPT_ECDH_ALGORITHM;
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

  NCRYPT_KEY_STORAGE_ALGORITHM    = WideString('KEY_STORAGE');

{$ifdef NTDDI_WIN10_RS1}
//
// This algorithm is not supported by any = BCRYPT provider. This identifier is for creating
// persistent stored HMAC keys in the TPM KSP.
//
const
 NCRYPT_HMAC_SHA256_ALGORITHM     = WideString('HMAC-SHA256');
{$endif}

//
// Interfaces
//
{$ifdef NTDDI_WIN8}
const
  NCRYPT_CIPHER_INTERFACE         = BCRYPT_CIPHER_INTERFACE;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

const
  NCRYPT_HASH_INTERFACE                   = BCRYPT_HASH_INTERFACE;
  NCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE  = BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE;
  NCRYPT_SECRET_AGREEMENT_INTERFACE       = BCRYPT_SECRET_AGREEMENT_INTERFACE;
  NCRYPT_SIGNATURE_INTERFACE              = BCRYPT_SIGNATURE_INTERFACE;
{$ifdef NTDDI_WIN8}
  NCRYPT_KEY_DERIVATION_INTERFACE         = BCRYPT_KEY_DERIVATION_INTERFACE;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

  NCRYPT_KEY_STORAGE_INTERFACE            = $00010001;
  NCRYPT_SCHANNEL_INTERFACE               = $00010002;
  NCRYPT_SCHANNEL_SIGNATURE_INTERFACE     = $00010003;
{$ifdef NTDDI_WIN8}
  NCRYPT_KEY_PROTECTION_INTERFACE         = $00010004;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

//
// algorithm groups.
//
const
  NCRYPT_RSA_ALGORITHM_GROUP              = NCRYPT_RSA_ALGORITHM;
  NCRYPT_DH_ALGORITHM_GROUP               = NCRYPT_DH_ALGORITHM;
  NCRYPT_DSA_ALGORITHM_GROUP              = NCRYPT_DSA_ALGORITHM;
  NCRYPT_ECDSA_ALGORITHM_GROUP            = WideString('ECDSA');
  NCRYPT_ECDH_ALGORITHM_GROUP             = WideString('ECDH');

{$ifdef NTDDI_WIN8}
const
  NCRYPT_AES_ALGORITHM_GROUP              = NCRYPT_AES_ALGORITHM;
  NCRYPT_RC2_ALGORITHM_GROUP              = NCRYPT_RC2_ALGORITHM;
  NCRYPT_DES_ALGORITHM_GROUP              = WideString('DES');
  NCRYPT_KEY_DERIVATION_GROUP             = WideString('KEY_DERIVATION');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

//
// NCrypt generic memory descriptors
//
const
  NCRYPTBUFFER_VERSION                               = 0;

  NCRYPTBUFFER_EMPTY                                 = 0;
  NCRYPTBUFFER_DATA                                  = 1;

{$ifdef NTDDI_WIN8}
  NCRYPTBUFFER_PROTECTION_DESCRIPTOR_STRING   3   // The buffer contains a null-terminated Unicode string that contains the Protection Descriptor.
  NCRYPTBUFFER_PROTECTION_FLAGS               4   // DWORD flags to be passed to NCryptCreateProtectionDescriptor function.
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)


  NCRYPTBUFFER_SSL_CLIENT_RANDOM                     = 20;
  NCRYPTBUFFER_SSL_SERVER_RANDOM                     = 21;
  NCRYPTBUFFER_SSL_HIGHEST_VERSION                   = 22;
  NCRYPTBUFFER_SSL_CLEAR_KEY                         = 23;
  NCRYPTBUFFER_SSL_KEY_ARG_DATA                      = 24;
{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPTBUFFER_SSL_SESSION_HASH                      = 25;
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

  NCRYPTBUFFER_PKCS_OID                              = 40;
  NCRYPTBUFFER_PKCS_ALG_OID                          = 41;
  NCRYPTBUFFER_PKCS_ALG_PARAM                        = 42;
  NCRYPTBUFFER_PKCS_ALG_ID                           = 43;
  NCRYPTBUFFER_PKCS_ATTRS                            = 44;
  NCRYPTBUFFER_PKCS_KEY_NAME                         = 45;
  NCRYPTBUFFER_PKCS_SECRET                           = 46;

  NCRYPTBUFFER_CERT_BLOB                             = 47;

//for threshold key attestation
  NCRYPTBUFFER_CLAIM_IDBINDING_NONCE                 = 48;
  NCRYPTBUFFER_CLAIM_KEYATTESTATION_NONCE            = 49;
  NCRYPTBUFFER_KEY_PROPERTY_FLAGS                    = 50;
  NCRYPTBUFFER_ATTESTATIONSTATEMENT_BLOB             = 51;
  NCRYPTBUFFER_ATTESTATION_CLAIM_TYPE                = 52;
  NCRYPTBUFFER_ATTESTATION_CLAIM_CHALLENGE_REQUIRED  = 53;

{$ifdef NTDDI_WIN10_RS3}
  NCRYPTBUFFER_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS = 54;
{$endif}

{$ifdef NTDDI_WINTHRESHOLD}
//for generic ecc
  NCRYPTBUFFER_ECC_CURVE_NAME                        = 60;
  NCRYPTBUFFER_ECC_PARAMETERS                        = 61;
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{$ifdef NTDDI_WIN10_RS1}
//for TPM seal
  NCRYPTBUFFER_TPM_SEAL_PASSWORD                     = 70;
  NCRYPTBUFFER_TPM_SEAL_POLICYINFO                   = 71;
  NCRYPTBUFFER_TPM_SEAL_TICKET                       = 72;
  NCRYPTBUFFER_TPM_SEAL_NO_DA_PROTECTION             = 73;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)


// NCRYPT shares the same BCRYPT definitions
type
  NCryptBuffer           = BCryptBuffer;
  PNCryptBuffer          = ^BCryptBuffer;
  NCryptBufferDesc       = BCryptBufferDesc;
  PNCryptBufferDesc      = ^BCryptBufferDesc;

//
// NCrypt handles
//

type
  NCRYPT_HANDLE          = ULONG_PTR;
  PNCRYPT_PROV_HANDLE    = ^NCRYPT_PROV_HANDLE;
  NCRYPT_PROV_HANDLE     = ULONG_PTR;
  PNCRYPT_KEY_HANDLE     = ^NCRYPT_KEY_HANDLE;
  NCRYPT_KEY_HANDLE      = ULONG_PTR;
  NCRYPT_HASH_HANDLE     = ULONG_PTR;
  PNCRYPT_SECRET_HANDLE  = ^NCRYPT_SECRET_HANDLE;
  NCRYPT_SECRET_HANDLE   = ULONG_PTR;

{$ifdef NTDDI_WIN8}

//typedef _Struct_size_bytes_(cbSize + cbIV + cbOtherInfo)

type
  PNCRYPT_CIPHER_PADDING_INFO = ^NCRYPT_CIPHER_PADDING_INFO;
  NCRYPT_CIPHER_PADDING_INFO = record
    // size of this struct
    cbSize          : ULONG;

    // See NCRYPT_CIPHER_ flag values
    cbSize          : DWORD;

    // [in, out, optional]
    // The address of a buffer that contains the initialization vector (IV) to use during encryption.
    // The cbIV parameter contains the size of this buffer. This function will modify the contents of this buffer.
    // If you need to reuse the IV later, make sure you make a copy of this buffer before calling this function.
    //_Field_size_bytes_(cbIV)
    pbIV        : PUCHAR;
    cbIV        : ULONG;

    // [in, out, optional]
    // The address of a buffer that contains the algorithm specific info to use during encryption.
    // The cbOtherInfo parameter contains the size of this buffer. This function will modify the contents of this buffer.
    // If you need to reuse the buffer later, make sure you make a copy of this buffer before calling this function.
    //
    // For Microsoft providers, when an authenticated encryption mode is used,
    // this parameter must point to a serialized BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO structure.
    //
    // NOTE: All pointers inside a structure must be to a data allocated within pbOtherInfo buffer.
    //
    //_Field_size_bytes_(cbOtherInfo)
    pbOtherInfo   : PUCHAR;
    cbOtherInfo   : ULONG;
  end;

//
// The following flags are used with NCRYPT_CIPHER_PADDING_INFO
//
 const
  NCRYPT_CIPHER_NO_PADDING_FLAG           = $00000000;
  NCRYPT_CIPHER_BLOCK_PADDING_FLAG        = $00000001;
  NCRYPT_CIPHER_OTHER_PADDING_FLAG        = $00000002;

{$endif}  // (NTDDI_VERSION >= NTDDI_WIN8)

{$ifdef NTDDI_WINBLUE}

const
  NCRYPT_PLATFORM_ATTEST_MAGIC   = $44504150;  // 'PAPD'

type
  NCRYPT_PLATFORM_ATTEST_PADDING_INFO = record
    magic     : ULONG;  // 'PAPD'
    pcrMask   : ULONG;
  end;


const
  NCRYPT_KEY_ATTEST_MAGIC        = $4450414b;  // 'KAPD'

type
  NCRYPT_KEY_ATTEST_PADDING_INFO = record
    magic      : ULONG;  // 'KAPD'
    pbKeyBlob  : PUCHAR;
    cbKeyBlob  : ULONG;
    pbKeyAuth  : PUCHAR;
    cbKeyAuth  : ULONG;
  end;

{$endif}  // (NTDDI_VERSION >= NTDDI_WINBLUE)

//
// key attestation claim type
//
{$ifdef NTDDI_WINTHRESHOLD}
const
  NCRYPT_CLAIM_AUTHORITY_ONLY                         = $00000001;
  NCRYPT_CLAIM_SUBJECT_ONLY                           = $00000002;
  NCRYPT_CLAIM_WEB_AUTH_SUBJECT_ONLY                  = $00000102;
  NCRYPT_CLAIM_AUTHORITY_AND_SUBJECT                  = $00000003;
  NCRYPT_CLAIM_UNKNOWN                                = $00001000;

{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{$ifdef NTDDI_WIN10_RS3}
  NCRYPT_CLAIM_VSM_KEY_ATTESTATION_STATEMENT          = $00000004;
{$endif} //  NTDDI_WIN10_RS3

{$ifdef NTDDI_WIN10_RS3}

// NCryptCreateClaim claim types, flags and buffer types
const
  NCRYPT_ISOLATED_KEY_FLAG_CREATED_IN_ISOLATION = $00000001; // if set, this key was generated in isolation, not imported
  NCRYPT_ISOLATED_KEY_FLAG_IMPORT_ONLY          = $00000002; // if set, this key can only be used for importing other keys

  NCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES_V0 = 0;
  NCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES_CURRENT_VERSION  = NCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES_V0;

type
  PNCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES = ^NCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES;
  NCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES = record
    Version              : ULONG;   // set to NCRYPT_ISOLATED_KEY_ATTESTED_ATTRIBUTES_V0
    Flags                : ULONG;   // NCRYPT_ISOLATED_KEY_FLAG_ flags
    cbPublicKeyBlob      : ULONG;
    // pbPublicKeyBlob[cbPublicKeyBlob] - exported public key
  end;

const
  NCRYPT_VSM_KEY_ATTESTATION_STATEMENT_V0 = 0;
  NCRYPT_VSM_KEY_ATTESTATION_STATEMENT_CURRENT_VERSION = NCRYPT_VSM_KEY_ATTESTATION_STATEMENT_V0;

type
  PNCRYPT_VSM_KEY_ATTESTATION_STATEMENT = ^NCRYPT_VSM_KEY_ATTESTATION_STATEMENT;
  NCRYPT_VSM_KEY_ATTESTATION_STATEMENT = record
    Magic            : ULONG;  // {'I', 'M', 'S', 'V'} - 'VSMI' for VSM Isolated
    Version          : ULONG;  // Set to NCRYPT_VSM_KEY_ATTESTATION_STATEMENT_CURRENT_VERSION
    cbSignature      : ULONG;  // Secure kernel signature over the isolation report
    cbReport         : ULONG;  // Key isolation report from the secure kernel
    cbAttributes     : ULONG ; // Attributes of the isolated key including public key blob
    // UCHAR Signature[cbSignature]    -- Secure kernel signature of the report
    // UCHAR Report[cbReport]          -- Secure kernel report including hash of Attributes
    // UCHAR Attributes[cbAttributes]  -- Trustlet-reported attributes of the key
  end;


// Buffer contents for NCryptVerifyClaim (for buffer type NCRYPTBUFFER_ISOLATED_KEY_ATTESTATION_CLAIM_RESTRICTIONS)
const
  NCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS_V0 = 0;
  NCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS_CURRENT_VERSION = NCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS_V0;

type
  PNCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS = ^NCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS;
  NCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS = record
    Version       : ULONG;         // Set to NCRYPT_VSM_KEY_ATTESTATION_CLAIM_RESTRICTIONS_V0
    TrustletId    : ULONGLONG;     // Trustlet type
    MinSvn        : ULONG;         // Minimum acceptable trustlet SVN, 0 if don't care
    FlagsMask     : ULONG;         // Which of NCRYPT_ISOLATED_KEY_ flags to check
    FlagsExpected : ULONG;         // Expected values of flags inside the mask
    AllowDebugging: ULONG = 1;     // Is it okay for the trustlet to be debugged, 0 if no
    Reserved      : ULONG = 31;    // Future extension area, must be 0
  end;

// Structures to assist with importation of isolated keys
 const
  NCRYPT_EXPORTED_ISOLATED_KEY_HEADER_V0 = 0;
  NCRYPT_EXPORTED_ISOLATED_KEY_HEADER_CURRENT_VERSION = NCRYPT_EXPORTED_ISOLATED_KEY_HEADER_V0;

type
  PNCRYPT_EXPORTED_ISOLATED_KEY_HEADER = ^NCRYPT_EXPORTED_ISOLATED_KEY_HEADER;
  NCRYPT_EXPORTED_ISOLATED_KEY_HEADER = record
    Version       : ULONG;      // Set to NCRYPT_EXPORTED_ISOLATED_KEY_HEADER_V0
    KeyUsage      : ULONG;      // Set to NCRYPT_ALLOW_KEY_IMPORT_FLAG for import-only keys
    PerBootKey    : ULONG = 1;  // Set to TRUE if the key is to be valid in the current boot cycle only
    Reserved      : ULONG = 31; // Leave as 0
    cbAlgName     : ULONG;      // Number of bytes in Unicode algorithm name following header + terminating NULL
    cbNonce       : ULONG;      // Number of bytes in the nonce used to encrypt the isolated key
    cbAuthTag     : ULONG;      // Number of bytes in authentication tag resulting from encrypting the isolated key
    cbWrappingKey : ULONG;      // Number of bytes in encrypted wrapping key blob
    cbIsolatedKey : ULONG;      // Number of bytes in encrypted isolated key blob
  end;
  PNCRYPT_EXPORTED_ISOLATED_KEY_ENVELOPE = ^NCRYPT_EXPORTED_ISOLATED_KEY_ENVELOPE;
  NCRYPT_EXPORTED_ISOLATED_KEY_ENVELOPE = record
    Header        : NCRYPT_EXPORTED_ISOLATED_KEY_HEADER;
    // UCHAR AlgorithmName[Header.cbAlgName]       -- Unicode algorithm name including terminating NULL
    // UCHAR Nonce[Header.cbNonce]                 -- Nonce buffer used when encrypting isolated key
    // ---- data after this point is not integrity protected in transit
    // UCHAR AesGcmAuthTag[Header.cbAuthTag]
    // UCHAR WrappingKeyBlob[Header.cbWrappingKey] -- RSA-OAEP encrypted AES wrapping key
    // UCHAR IsolatedKeyBlob[Header.cbIsolatedKey] -- AES-GCM encrypted key to import
  end;

{$endif}

{$ifdef NTDDI_WIN10_RS2}

type
  PNCRYPT_PCP_TPM_WEB_AUTHN_ATTESTATION_STATEMENT = ^NCRYPT_PCP_TPM_WEB_AUTHN_ATTESTATION_STATEMENT;
  NCRYPT_PCP_TPM_WEB_AUTHN_ATTESTATION_STATEMENT = record
    Magic             : UINT32;  // { 'A', 'W', 'A', 'K' } - 'KAWA'
    Version           : UINT32;  // 1 for the statement defined in this specification
    HeaderSize        : UINT32;  // 24
    cbCertifyInfo     : UINT32;
    cbSignature       : UINT32;
    cbTpmPublic       : UINT32;
    // CertifyInfo[cbCertifyInfo];
    // Signature[cbSignature];
    // TpmPublic[cbTpmPublic];
  end;


{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS2)

//
// NCrypt API Flags
//
 const
  NCRYPT_NO_PADDING_FLAG                  = $00000001;  // NCryptEncrypt/Decrypt
  NCRYPT_PAD_PKCS1_FLAG                   = $00000002;  // NCryptEncrypt/Decrypt NCryptSignHash/VerifySignature
  NCRYPT_PAD_OAEP_FLAG                    = $00000004;  // BCryptEncrypt/Decrypt
  NCRYPT_PAD_PSS_FLAG                     = $00000008;  // BCryptSignHash/VerifySignature
{$ifdef NTDDI_WIN8}
  NCRYPT_PAD_CIPHER_FLAG                  = $00000010;  // NCryptEncrypt/Decrypt
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_ATTESTATION_FLAG                 = $00000020; // NCryptDecrypt for key attestation
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{$ifdef NTDDI_WIN10_RS1}
  NCRYPT_SEALING_FLAG                     = $00000100; // NCryptEncrypt/Decrypt for sealing
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)

  NCRYPT_REGISTER_NOTIFY_FLAG             = $00000001;  // NCryptNotifyChangeKey
  NCRYPT_UNREGISTER_NOTIFY_FLAG           = $00000002;  // NCryptNotifyChangeKey
  NCRYPT_NO_KEY_VALIDATION                = BCRYPT_NO_KEY_VALIDATION;
  NCRYPT_MACHINE_KEY_FLAG                 = $00000020;  // same as CAPI CRYPT_MACHINE_KEYSET
  NCRYPT_SILENT_FLAG                      = $00000040;  // same as CAPI CRYPT_SILENT
  NCRYPT_OVERWRITE_KEY_FLAG               = $00000080;
  NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG   = $00000200;
  NCRYPT_DO_NOT_FINALIZE_FLAG             = $00000400;
  NCRYPT_EXPORT_LEGACY_FLAG               = $00000800;
{$ifdef NTDDI_WINBLUE}
  NCRYPT_IGNORE_DEVICE_STATE_FLAG         = $00001000;  // NCryptOpenStorageProvider
{$endif} // (NTDDI_VERSION >= NTDDI_WINBLUE)
{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_TREAT_NIST_AS_GENERIC_ECC_FLAG   = $00002000;
  NCRYPT_NO_CACHED_PASSWORD				= $00004000;
 	NCRYPT_PROTECT_TO_LOCAL_SYSTEM			= $00008000;
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)
  NCRYPT_PERSIST_ONLY_FLAG                = $40000000;
  NCRYPT_PERSIST_FLAG                     = $80000000;

{$ifdef NTDDI_WIN10_RS2}
  NCRYPT_PREFER_VIRTUAL_ISOLATION_FLAG    = $00010000; // NCryptCreatePersistedKey NCryptImportKey
  NCRYPT_USE_VIRTUAL_ISOLATION_FLAG       = $00020000; // NCryptCreatePersistedKey NCryptImportKey
  NCRYPT_USE_PER_BOOT_KEY_FLAG            = $00040000; // NCryptCreatePersistedKey NCryptImportKey
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS2)

//
// Functions used to manage persisted keys.
//

// NCryptOpenStorageProvider flags
//const
  //NCRYPT_SILENT_FLAG                      = $00000040;  // same as CAPI CRYPT_SILENT
{$ifdef NTDDI_WINBLUE}
  NCRYPT_IGNORE_DEVICE_STATE_FLAG         = $00001000;  // NCryptOpenStorageProvider
{$endif} // (NTDDI_VERSION >= NTDDI_WINBLUE)

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptOpenStorageProvider(
    phProvider      : PNCRYPT_PROV_HANDLE;    // _Out_
    pszProviderName : LPCWSTR;                // _In_opt_
    dwFlags         : DWORD                   // _In_
    ): SECURITY_STATUS; stdcall;



const
// AlgOperations flags for use with NCryptEnumAlgorithms()
  NCRYPT_CIPHER_OPERATION                 = BCRYPT_CIPHER_OPERATION;
  NCRYPT_HASH_OPERATION                   = BCRYPT_HASH_OPERATION;
  NCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION  = BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION;
  NCRYPT_SECRET_AGREEMENT_OPERATION       = BCRYPT_SECRET_AGREEMENT_OPERATION;
  NCRYPT_SIGNATURE_OPERATION              = BCRYPT_SIGNATURE_OPERATION;
  NCRYPT_RNG_OPERATION                    = BCRYPT_RNG_OPERATION;
{$ifdef NTDDI_WIN8}
  NCRYPT_KEY_DERIVATION_OPERATION         = BCRYPT_KEY_DERIVATION_OPERATION;
{$endif}  // (NTDDI_VERSION >= NTDDI_WIN8)
// USE EXTREME CAUTION: editing comments that contain "certenrolls_*" tokens
// could break building CertEnroll idl files:
// certenrolls_begin -- NCryptAlgorithmName
type
  PNCryptAlgorithmName = ^NCryptAlgorithmName;
  PPNCryptAlgorithmName = ^PNCryptAlgorithmName;
  NCryptAlgorithmName = record
    pszName         : LPWSTR;
    dwClass         : DWORD;            // the CNG interface that supports this algorithm
    dwAlgOperations : DWORD;            // the types of operations supported by this algorithm
    dwFlags         : DWORD;
  end;
    // certenrolls_end

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptEnumAlgorithms(
    hProvider       : NCRYPT_PROV_HANDLE;       // _In_
    dwAlgOperations : DWORD;                    // _In_
    pdwAlgCount     : PDWORD;                   // _Out_
    ppAlgList       : PPNCryptAlgorithmName;    //_Outptr_result_buffer_(*pdwAlgCount)
    dwFlags         : DWORD                     // _In_
    ): SECURITY_STATUS; stdcall;



{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptIsAlgSupported(
    hProvider      : NCRYPT_PROV_HANDLE;        // _In_
    pszAlgId       : LPCWSTR;                   // _In_
    dwFlags        : DWORD                      // _In_
    ): SECURITY_STATUS; stdcall;



// NCryptEnumKeys flags
//const
//  NCRYPT_MACHINE_KEY_FLAG         = $00000020;

type
  PNCryptKeyName = ^NCryptKeyName;
  PPNCryptKeyName = ^PNCryptKeyName;
  NCryptKeyName = record
    pszName              : PWideChar;
    pszAlgid             : PWideChar;
    dwLegacyKeySpec      : DWORD;
    dwFlags              : DWORD;
  end;


{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptEnumKeys(
    hProvider       : NCRYPT_PROV_HANDLE;   // _In_
    pszScope        : LPCWSTR;              // _In_opt_
    ppKeyName       : PPNCryptKeyName;      // _Outptr_
    ppEnumState     : PPVOID;               // _Inout_
    dwFlags         : DWORD                 // _In_
    ):SECURITY_STATUS; stdcall;

type
  PNCryptProviderName = ^NCryptProviderName;
  PPNCryptProviderName = ^PNCryptProviderName;
  NCryptProviderName = record
    pszName     : LPWSTR;
    pszComment  : LPWSTR;
  end;

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptEnumStorageProviders(
    pdwProviderCount     : PDWORD;                // _Out_
    ppProviderList       : PPNCryptProviderName;  // _Outptr_result_buffer_(*pdwProviderCount)
    dwFlags              : DWORD                  // _In_
    ): SECURITY_STATUS; stdcall;

{
SECURITY_STATUS
WINAPI
}
function NCryptFreeBuffer(
    pvInput      : PVOID        // _Pre_notnull_
    ):SECURITY_STATUS; stdcall;



// NCryptOpenKey flags
{
// Identifiers declared above
const
  NCRYPT_MACHINE_KEY_FLAG         = $00000020;
  NCRYPT_SILENT_FLAG              = $00000040;
}
{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_AUTHORITY_KEY_FLAG       = $00000100;
{$endif}

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptOpenKey(
    hProvider          : NCRYPT_PROV_HANDLE;  // _In_
    phKey              : PNCRYPT_KEY_HANDLE;  // _Out_
    pszKeyName         : LPCWSTR;             // _In_
    dwLegacyKeySpec    : DWORD;               // _In_opt_
    dwFlags            : DWORD                // _In_
    ): SECURITY_STATUS; stdcall;



// NCryptCreatePersistedKey flags
{
// Identifiers declared above
const
 NCRYPT_MACHINE_KEY_FLAG         = $00000020;
 NCRYPT_OVERWRITE_KEY_FLAG       = $00000080;
}


{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptCreatePersistedKey(
    hProvider          : NCRYPT_PROV_HANDLE;    // _In_
    phKey              : PNCRYPT_KEY_HANDLE;    // _Out_
    pszAlgId           : LPCWSTR;               // _In_
    pszKeyName         : LPCWSTR;               // _In_opt_
    dwLegacyKeySpec    : DWORD;                 // _In_
    dwFlags            : DWORD                  // _In_
    ): SECURITY_STATUS; stdcall;



// Standard property names.
const
  NCRYPT_NAME_PROPERTY                    = WideString('Name');
  NCRYPT_UNIQUE_NAME_PROPERTY             = WideString('Unique Name');
  NCRYPT_ALGORITHM_PROPERTY               = WideString('Algorithm Name');
  NCRYPT_LENGTH_PROPERTY                  = WideString('Length');
  NCRYPT_LENGTHS_PROPERTY                 = WideString('Lengths');
  NCRYPT_BLOCK_LENGTH_PROPERTY            = WideString('Block Length');

{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_PUBLIC_LENGTH_PROPERTY           = BCRYPT_PUBLIC_KEY_LENGTH;
  NCRYPT_SIGNATURE_LENGTH_PROPERTY        = BCRYPT_SIGNATURE_LENGTH;
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{$ifdef NTDDI_WIN8}
  NCRYPT_CHAINING_MODE_PROPERTY           = WideString('Chaining Mode');
  NCRYPT_AUTH_TAG_LENGTH                  = WideString('AuthTagLength');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

  NCRYPT_UI_POLICY_PROPERTY               = WideString('UI Policy');
  NCRYPT_EXPORT_POLICY_PROPERTY           = WideString('Export Policy');
  NCRYPT_WINDOW_HANDLE_PROPERTY           = WideString('HWND Handle');
  NCRYPT_USE_CONTEXT_PROPERTY             = WideString('Use Context');
  NCRYPT_IMPL_TYPE_PROPERTY               = WideString('Impl Type');
  NCRYPT_KEY_USAGE_PROPERTY               = WideString('Key Usage');
  NCRYPT_KEY_TYPE_PROPERTY                = WideString('Key Type');
  NCRYPT_VERSION_PROPERTY                 = WideString('Version');
  NCRYPT_SECURITY_DESCR_SUPPORT_PROPERTY  = WideString('Security Descr Support');
  NCRYPT_SECURITY_DESCR_PROPERTY          = WideString('Security Descr');
  NCRYPT_USE_COUNT_ENABLED_PROPERTY       = WideString('Enabled Use Count');
  NCRYPT_USE_COUNT_PROPERTY               = WideString('Use Count');
  NCRYPT_LAST_MODIFIED_PROPERTY           = WideString('Modified');
  NCRYPT_MAX_NAME_LENGTH_PROPERTY         = WideString('Max Name Length');
  NCRYPT_ALGORITHM_GROUP_PROPERTY         = WideString('Algorithm Group');
  NCRYPT_DH_PARAMETERS_PROPERTY           = BCRYPT_DH_PARAMETERS;

{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_ECC_PARAMETERS_PROPERTY          = BCRYPT_ECC_PARAMETERS;
  NCRYPT_ECC_CURVE_NAME_PROPERTY          = BCRYPT_ECC_CURVE_NAME;
  NCRYPT_ECC_CURVE_NAME_LIST_PROPERTY     = BCRYPT_ECC_CURVE_NAME_LIST;
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{$ifdef NTDDI_WIN10_RS2}
  NCRYPT_USE_VIRTUAL_ISOLATION_PROPERTY   = WideString('Virtual Iso');
  NCRYPT_USE_PER_BOOT_KEY_PROPERTY        = WideString('Per Boot Key');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS2)

  NCRYPT_PROVIDER_HANDLE_PROPERTY         = WideString('Provider Handle');
  NCRYPT_PIN_PROPERTY                     = WideString('SmartCardPin');
  NCRYPT_READER_PROPERTY                  = WideString('SmartCardReader');
  NCRYPT_SMARTCARD_GUID_PROPERTY          = WideString('SmartCardGuid');
  NCRYPT_CERTIFICATE_PROPERTY             = WideString('SmartCardKeyCertificate');
  NCRYPT_PIN_PROMPT_PROPERTY              = WideString('SmartCardPinPrompt');
  NCRYPT_USER_CERTSTORE_PROPERTY          = WideString('SmartCardUserCertStore');
  NCRYPT_ROOT_CERTSTORE_PROPERTY          = WideString('SmartcardRootCertStore');
  NCRYPT_SECURE_PIN_PROPERTY              = WideString('SmartCardSecurePin');
  NCRYPT_ASSOCIATED_ECDH_KEY              = WideString('SmartCardAssociatedECDHKey');
  NCRYPT_SCARD_PIN_ID                     = WideString('SmartCardPinId');
  NCRYPT_SCARD_PIN_INFO                   = WideString('SmartCardPinInfo');
{$ifdef NTDDI_WIN8}
  NCRYPT_READER_ICON_PROPERTY             = WideString('SmartCardReaderIcon');
  NCRYPT_KDF_SECRET_VALUE                 = WideString('KDFKeySecret');
//
// Additional property strings specific for the Platform Crypto Provider
//
  NCRYPT_PCP_PLATFORM_TYPE_PROPERTY                  = WideString('PCP_PLATFORM_TYPE');
  NCRYPT_PCP_PROVIDER_VERSION_PROPERTY               = WideString('PCP_PROVIDER_VERSION');
  NCRYPT_PCP_EKPUB_PROPERTY                          = WideString('PCP_EKPUB');
  NCRYPT_PCP_EKCERT_PROPERTY                         = WideString('PCP_EKCERT');
  NCRYPT_PCP_EKNVCERT_PROPERTY                       = WideString('PCP_EKNVCERT');
  NCRYPT_PCP_RSA_EKPUB_PROPERTY                      = WideString('PCP_RSA_EKPUB');
  NCRYPT_PCP_RSA_EKCERT_PROPERTY                     = WideString('PCP_RSA_EKCERT');
  NCRYPT_PCP_RSA_EKNVCERT_PROPERTY                   = WideString('PCP_RSA_EKNVCERT');
  NCRYPT_PCP_ECC_EKPUB_PROPERTY                      = WideString('PCP_ECC_EKPUB');
  NCRYPT_PCP_ECC_EKCERT_PROPERTY                     = WideString('PCP_ECC_EKCERT');
  NCRYPT_PCP_ECC_EKNVCERT_PROPERTY                   = WideString('PCP_ECC_EKNVCERT');
  NCRYPT_PCP_SRKPUB_PROPERTY                         = WideString('PCP_SRKPUB');
  NCRYPT_PCP_PCRTABLE_PROPERTY                       = WideString('PCP_PCRTABLE');
  NCRYPT_PCP_CHANGEPASSWORD_PROPERTY                 = WideString('PCP_CHANGEPASSWORD');
  NCRYPT_PCP_PASSWORD_REQUIRED_PROPERTY              = WideString('PCP_PASSWORD_REQUIRED');
  NCRYPT_PCP_USAGEAUTH_PROPERTY                      = WideString('PCP_USAGEAUTH');
  NCRYPT_PCP_MIGRATIONPASSWORD_PROPERTY              = WideString('PCP_MIGRATIONPASSWORD');
  NCRYPT_PCP_EXPORT_ALLOWED_PROPERTY                 = WideString('PCP_EXPORT_ALLOWED');
  NCRYPT_PCP_STORAGEPARENT_PROPERTY                  = WideString('PCP_STORAGEPARENT');
  NCRYPT_PCP_PROVIDERHANDLE_PROPERTY                 = WideString('PCP_PROVIDERMHANDLE');
  NCRYPT_PCP_PLATFORMHANDLE_PROPERTY                 = WideString('PCP_PLATFORMHANDLE');
  NCRYPT_PCP_PLATFORM_BINDING_PCRMASK_PROPERTY       = WideString('PCP_PLATFORM_BINDING_PCRMASK');
  NCRYPT_PCP_PLATFORM_BINDING_PCRDIGESTLIST_PROPERTY = WideString('PCP_PLATFORM_BINDING_PCRDIGESTLIST');
  NCRYPT_PCP_PLATFORM_BINDING_PCRDIGEST_PROPERTY     = WideString('PCP_PLATFORM_BINDING_PCRDIGEST');
  NCRYPT_PCP_KEY_USAGE_POLICY_PROPERTY               = WideString('PCP_KEY_USAGE_POLICY');
  NCRYPT_PCP_RSA_SCHEME_PROPERTY                     = WideString('PCP_RSA_SCHEME');
  NCRYPT_PCP_RSA_SCHEME_HASH_ALG_PROPERTY            = WideString('PCP_RSA_SCHEME_HASH_ALG');
  NCRYPT_PCP_TPM12_IDBINDING_PROPERTY                = WideString('PCP_TPM12_IDBINDING');
  NCRYPT_PCP_TPM12_IDBINDING_DYNAMIC_PROPERTY        = WideString('PCP_TPM12_IDBINDING_DYNAMIC');
  NCRYPT_PCP_TPM12_IDACTIVATION_PROPERTY             = WideString('PCP_TPM12_IDACTIVATION');
  NCRYPT_PCP_KEYATTESTATION_PROPERTY                 = WideString('PCP_TPM12_KEYATTESTATION');
  NCRYPT_PCP_ALTERNATE_KEY_STORAGE_LOCATION_PROPERTY = WideString('PCP_ALTERNATE_KEY_STORAGE_LOCATION');
  NCRYPT_PCP_TPM_IFX_RSA_KEYGEN_PROHIBITED_PROPERTY  = WideString('PCP_TPM_IFX_RSA_KEYGEN_PROHIBITED');
  NCRYPT_PCP_TPM_IFX_RSA_KEYGEN_VULNERABILITY_PROPERTY = WideString('PCP_TPM_IFX_RSA_KEYGEN_VULNERABILITY');

{$ifdef NTDDI_WIN10_RS1}
  NCRYPT_PCP_HMAC_AUTH_POLICYREF                     = WideString('PCP_HMAC_AUTH_POLICYREF');
  NCRYPT_PCP_HMAC_AUTH_POLICYINFO                    = WideString('PCP_HMAC_AUTH_POLICYINFO');
  NCRYPT_PCP_HMAC_AUTH_NONCE                         = WideString('PCP_HMAC_AUTH_NONCE');
  NCRYPT_PCP_HMAC_AUTH_SIGNATURE                     = WideString('PCP_HMAC_AUTH_SIGNATURE');
  NCRYPT_PCP_HMAC_AUTH_TICKET                        = WideString('PCP_HMAC_AUTH_TICKET');
  NCRYPT_PCP_NO_DA_PROTECTION_PROPERTY               = WideString('PCP_NO_DA_PROTECTION');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)

{$ifdef NTDDI_WIN10_RS2}
  NCRYPT_PCP_TPM_MANUFACTURER_ID_PROPERTY            = WideString('PCP_TPM_MANUFACTURER_ID');
  NCRYPT_PCP_TPM_FW_VERSION_PROPERTY                 = WideString('PCP_TPM_FW_VERSION');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS2)

{$ifdef NTDDI_WIN10_RS3}
  NCRYPT_PCP_TPM2BNAME_PROPERTY                      = WideString('PCP_TPM2BNAME');
  NCRYPT_PCP_TPM_VERSION_PROPERTY                    = WideString('PCP_TPM_VERSION');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS3)

//
// NCRYPT_PCP_TPM_IFX_RSA_KEYGEN_VULNERABILITY_PROPERTY values
//
  IFX_RSA_KEYGEN_VUL_NOT_AFFECTED     = 0;
  IFX_RSA_KEYGEN_VUL_AFFECTED_LEVEL_1 = 1;
  IFX_RSA_KEYGEN_VUL_AFFECTED_LEVEL_2 = 2;

//
// BCRYPT_PCP_KEY_USAGE_POLICY values
//
  NCRYPT_TPM12_PROVIDER                  = $00010000;
  NCRYPT_PCP_SIGNATURE_KEY               = $00000001;
  NCRYPT_PCP_ENCRYPTION_KEY              = $00000002;
  NCRYPT_PCP_GENERIC_KEY                 = (NCRYPT_PCP_SIGNATURE_KEY | NCRYPT_PCP_ENCRYPTION_KEY);
  NCRYPT_PCP_STORAGE_KEY                 = $00000004;
  NCRYPT_PCP_IDENTITY_KEY                = $00000008;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

{$ifdef NTDDI_WIN10_RS1}
  NCRYPT_PCP_HMACVERIFICATION_KEY        (0x00000010)
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)

//
// Additional property strings specific for the Smart Card Key Storage Provider
//
{$ifdef NTDDI_WIN10}
  NCRYPT_SCARD_NGC_KEY_NAME       = WideString('SmartCardNgcKeyName');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10)

{$ifdef NTDDI_WIN10}
  NCRYPT_PCP_PLATFORM_BINDING_PCRALGID_PROPERTY      = WideString('PCP_PLATFORM_BINDING_PCRALGID');
{$endif} // (NTDDI_VERSION >= NTDDI_WIN10)

{$ifdef NTDDI_WIN8}
//
// Used to set IV for block ciphers, before calling NCryptEncrypt/NCryptDecrypt
//
  NCRYPT_INITIALIZATION_VECTOR            = BCRYPT_INITIALIZATION_VECTOR;
{$endif} // (NTDDI_VERSION >= NTDDI_WIN8)

{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_CHANGEPASSWORD_PROPERTY	= NCRYPT_PCP_CHANGEPASSWORD_PROPERTY;
  NCRYPT_ALTERNATE_KEY_STORAGE_LOCATION_PROPERTY = NCRYPT_PCP_ALTERNATE_KEY_STORAGE_LOCATION_PROPERTY;
  NCRYPT_KEY_ACCESS_POLICY_PROPERTY   = WideString('Key Access Policy');
{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

// Maximum length of property name (in characters)
  NCRYPT_MAX_PROPERTY_NAME       = 64;

// Maximum length of property data (in bytes)
  NCRYPT_MAX_PROPERTY_DATA        = $100000;

// NCRYPT_EXPORT_POLICY_PROPERTY property flags.
  NCRYPT_ALLOW_EXPORT_FLAG                = $00000001;
  NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG      = $00000002;
  NCRYPT_ALLOW_ARCHIVING_FLAG             = $00000004;
  NCRYPT_ALLOW_PLAINTEXT_ARCHIVING_FLAG   = $00000008;

// NCRYPT_IMPL_TYPE_PROPERTY property flags.
  NCRYPT_IMPL_HARDWARE_FLAG               = $00000001;
  NCRYPT_IMPL_SOFTWARE_FLAG               = $00000002;
  NCRYPT_IMPL_REMOVABLE_FLAG              = $00000008;
  NCRYPT_IMPL_HARDWARE_RNG_FLAG           = $00000010;

// NCRYPT_KEY_USAGE_PROPERTY property flags.
  NCRYPT_ALLOW_DECRYPT_FLAG               = $00000001;
  NCRYPT_ALLOW_SIGNING_FLAG               = $00000002;
  NCRYPT_ALLOW_KEY_AGREEMENT_FLAG         = $00000004;
{$ifdef NTDDI_WIN10_RS3}
  NCRYPT_ALLOW_KEY_IMPORT_FLAG            = $00000008;
{$endif}
  NCRYPT_ALLOW_ALL_USAGES                 = $00ffffff;

// NCRYPT_UI_POLICY_PROPERTY property flags and structure
  NCRYPT_UI_PROTECT_KEY_FLAG              = $00000001;
  NCRYPT_UI_FORCE_HIGH_PROTECTION_FLAG    = $00000002;
{$ifdef NTDDI_WINBLUE}
  NCRYPT_UI_FINGERPRINT_PROTECTION_FLAG   = $00000004;
  NCRYPT_UI_APPCONTAINER_ACCESS_MEDIUM_FLAG = $00000008;
{$endif} // (NTDDI_VERSION >= NTDDI_WINBLUE)



{$ifdef NTDDI_WINTHRESHOLD}

//
// Pin Cache Provider Properties
//

  NCRYPT_PIN_CACHE_FREE_APPLICATION_TICKET_PROPERTY   = WideString('PinCacheFreeApplicationTicket');

{$ifdef NTDDI_WIN10_RS1}

  NCRYPT_PIN_CACHE_FLAGS_PROPERTY                     = WideString('PinCacheFlags');

// The NCRYPT_PIN_CACHE_FLAGS_PROPERTY property is a DWORD value that can be set from a trusted process. The
// following flags can be set.
  NCRYPT_PIN_CACHE_DISABLE_DPL_FLAG                   = $00000001

{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)


//
// Pin Cache Key Properties
//

  NCRYPT_PIN_CACHE_APPLICATION_TICKET_PROPERTY        = WideString('PinCacheApplicationTicket');
  NCRYPT_PIN_CACHE_APPLICATION_IMAGE_PROPERTY         = WideString('PinCacheApplicationImage');
  NCRYPT_PIN_CACHE_APPLICATION_STATUS_PROPERTY        = WideString('PinCacheApplicationStatus');
  NCRYPT_PIN_CACHE_PIN_PROPERTY                       = WideString('PinCachePin');
  NCRYPT_PIN_CACHE_IS_GESTURE_REQUIRED_PROPERTY       = WideString('PinCacheIsGestureRequired');


  NCRYPT_PIN_CACHE_REQUIRE_GESTURE_FLAG               = $00000001;

// The NCRYPT_PIN_CACHE_PIN_PROPERTY and NCRYPT_PIN_CACHE_APPLICATION_TICKET_PROPERTY properties
// return a 32 byte random unique ID encoded as a null terminated base64 Unicode string. The string length
// is 32 * 4/3 + 1 characters = 45 characters, 90 bytes
  NCRYPT_PIN_CACHE_PIN_BYTE_LENGTH                   = 90;
  NCRYPT_PIN_CACHE_APPLICATION_TICKET_BYTE_LENGTH    = 90;

{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{$ifdef NTDDI_WIN10_RS1}

  NCRYPT_PIN_CACHE_CLEAR_PROPERTY                     = WideString('PinCacheClear');

// The NCRYPT_PIN_CACHE_CLEAR_PROPERTY property is a DWORD value. The following option can be set:
  NCRYPT_PIN_CACHE_CLEAR_FOR_CALLING_PROCESS_OPTION   = $00000001

{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)



type
  NCRYPT_UI_POLICY = record
    dwVersion         : DWORD;
    dwFlags           : DWORD;
    pszCreationTitle  : LPCWSTR;
    pszFriendlyName   : LPCWSTR;
    pszDescription    : LPCWSTR;
  end;


{$ifdef NTDDI_WINTHRESHOLD}
  NCRYPT_KEY_ACCESS_POLICY_VERSION  = 1;
  NCRYPT_ALLOW_SILENT_KEY_ACCESS	  = $00000001;

type
  NCRYPT_KEY_ACCESS_POLICY_BLOB = record
	  dwVersion         : DWORD;
	  dwPolicyFlags     : DWORD;
	  cbUserSid         : DWORD;
    cbApplicationSid  : DWORD;
	  //  User Sid
    //  Application Sid
  end;

{$endif} // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

// NCRYPT_LENGTHS_PROPERTY property structure.
type
  NCRYPT_SUPPORTED_LENGTHS = record
    dwMinLength            : DWORD;
    dwMaxLength            : DWORD;
    dwIncrement            : DWORD;
    dwDefaultLength        : DWORD;
  end;


{$ifdef NTDDI_WIN10_RS1}
// NCRYPT_PCP_HMAC_AUTH_SIGNATURE property structure.
type
  NCRYPT_PCP_HMAC_AUTH_SIGNATURE_INFO = record
    dwVersion              : DWORD;
    iExpiration            : INT32;
    pabNonce               : Array [0..32] of BYTE;
    pabPolicyRef           : Array [0..32] of BYTE;
    pabHMAC                : Array [0..32] of BYTE;
  end;

{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS1)

{$ifdef NTDDI_WIN10_RS2}
// NCRYPT_PCP_TPM_FW_VERSION property structure.
type
  NCRYPT_PCP_TPM_FW_VERSION_INFO = record
    major1      : UINT16;
    major2      : UINT16;
    minor1      : UINT16;
    minor2      : UINT16;
  end;

{$endif} // (NTDDI_VERSION >= NTDDI_WIN10_RS2)

// NCryptGetProperty flags
{
//Identifier declared above
const
  NCRYPT_PERSIST_ONLY_FLAG        = $40000000;
}


{
_Check_return_
_Success_( return == 0 )
SECURITY_STATUS
WINAPI
}
function  NCryptGetProperty(
    hObject         : NCRYPT_HANDLE;    // _In_
    pszProperty     : LPCWSTR;          // _In_
    pbOutput        : PBYTE;            // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput        : DWORD;            // _In_
    pcbResult       : PDWORD;           // _Out_
    dwFlags         : DWORD             // _In_
    ): SECURITY_STATUS; stdcall;



// NCryptSetProperty flags
{
// Identifiers declared above
const
  NCRYPT_PERSIST_FLAG             = $80000000;
  NCRYPT_PERSIST_ONLY_FLAG        = $40000000;
}


{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptSetProperty(
    hObject        : NCRYPT_HANDLE;   // _In_
    pszProperty    : LPCWSTR;         // _In_
    pbInput        : PBYTE;           // _In_reads_bytes_(cbInput)
    cbInput        : DWORD;           // _In_
    dwFlags        : DWORD            // _In_
    ): SECURITY_STATUS; stdcall;



// NCryptFinalizeKey flags
{
//Identifier declared above
const
  NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG   = $00000200;
}

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptFinalizeKey(
    hKey          : NCRYPT_KEY_HANDLE;   // _In_
    dwFlags       : DWORD                // _In_
    ):SECURITY_STATUS; stdcall;



{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptEncrypt(
    hKey             : NCRYPT_KEY_HANDLE;  // _In_
    pbInput          : PBYTE;              // _In_reads_bytes_opt_(cbInput)
    cbInput          : DWORD;              // _In_
    pPaddingInfo     : PVOID;              // _In_opt_
    pbOutput         : PBYTE;              // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput         : DWORD;              // _In_
    pcbResult        : PDWORD;             // _Out_
    dwFlags          : DWORD               // _In_
    ): SECURITY_STATUS; stdcall;


{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptDecrypt(
    hKey           : NCRYPT_KEY_HANDLE;    // _In_
    pbInput        : PBYTE;                // _In_reads_bytes_opt_(cbInput)
    cbInput        : DWORD;                // _In_
    pPaddingInfo   : PVOID;                // _In_opt_
    pbOutput       : PBYTE;                // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput       : DWORD;                // _In_
    pcbResult      : PDWORD;               // _Out_
    dwFlags        : DWORD                 // _In_
    ): SECURITY_STATUS; stdcall;



{$ifdef NTDDI_WIN8}

type
  PNCRYPT_KEY_BLOB_HEADER = ^NCRYPT_KEY_BLOB_HEADER;
  NCRYPT_KEY_BLOB_HEADER = record
    cbSize    : ULONG;            // size of this structure
    dwMagic   : ULONG;
    cbAlgName : ULONG;             // size of the algorithm, in bytes, including terminating 0
    cbKeyData : ULONG;
  end;

const
  NCRYPT_CIPHER_KEY_BLOB_MAGIC    = $52485043;      // CPHR
  NCRYPT_KDF_KEY_BLOB_MAGIC       = $3146444B;      // KDF1
  NCRYPT_PROTECTED_KEY_BLOB_MAGIC = $4B545250;      // PRTK

  NCRYPT_CIPHER_KEY_BLOB          = WideString('CipherKeyBlob');
  NCRYPT_KDF_KEY_BLOB             = WideString('KDFKeyBlob');
  NCRYPT_PROTECTED_KEY_BLOB       = WideString('ProtectedKeyBlob');

{$endif}  // (NTDDI_VERSION >= NTDDI_WIN8)

type
  PNCRYPT_TPM_LOADABLE_KEY_BLOB_HEADER = ^NCRYPT_TPM_LOADABLE_KEY_BLOB_HEADER;
  NCRYPT_TPM_LOADABLE_KEY_BLOB_HEADER = record
    magic         : DWORD;
    cbHeader      : DWORD;
    cbPublic      : DWORD;
    cbPrivate     : DWORD;
    cbName        : DWORD;
  end;

const
 NCRYPT_TPM_LOADABLE_KEY_BLOB_MIN_SIZE = sizeof(NCRYPT_TPM_LOADABLE_KEY_BLOB_HEADER);
 NCRYPT_TPM_LOADABLE_KEY_BLOB = WideString('PcpTpmProtectedKeyBlob');
 NCRYPT_TPM_LOADABLE_KEY_BLOB_MAGIC = $4D54504B; //'MTPK'

 NCRYPT_PKCS7_ENVELOPE_BLOB      = WideString('PKCS7_ENVELOPE');
 NCRYPT_PKCS8_PRIVATE_KEY_BLOB   = WideString('PKCS8_PRIVATEKEY');
 NCRYPT_OPAQUETRANSPORT_BLOB     = WideString('OpaqueTransport');

{$ifdef NTDDI_WIN10_RS3}
 NCRYPT_ISOLATED_KEY_ENVELOPE_BLOB   = WideString ('ISOLATED_KEY_ENVELOPE');
{$endif}

// NCryptImportKey flags
{
// Identifiers declared above
const
 NCRYPT_MACHINE_KEY_FLAG         = $00000020;
 NCRYPT_DO_NOT_FINALIZE_FLAG     = $00000400;
 NCRYPT_EXPORT_LEGACY_FLAG       = $00000800;
}

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptImportKey(
    hProvider            : NCRYPT_PROV_HANDLE;  // _In_
    hImportKey           : NCRYPT_KEY_HANDLE;   // _In_opt_
    pszBlobType          : LPCWSTR;             // _In_
    pParameterList       : PNCryptBufferDesc;   // _In_opt_
    phKey                : PNCRYPT_KEY_HANDLE;  // _Out_
    pbData               : PBYTE;               // _In_reads_bytes_(cbData)
    cbData               : DWORD;               // _In_
    dwFlags              : DWORD                // _In_
    ): SECURITY_STATUS; stdcall;


{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptExportKey(
    hKey           : NCRYPT_KEY_HANDLE;    // _In_
    hExportKey     : NCRYPT_KEY_HANDLE;    // _In_opt_
    pszBlobType    : LPCWSTR;              // _In_
    pParameterList : PNCryptBufferDesc;     // _In_opt_
    pbOutput       : PBYTE;                // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput       : DWORD;                // _In_
    pcbResult      : PDWORD;               // _Out_
    dwFlagS        : DWORD                 // _In_
    ): SECURITY_STATUS; stdcall;



{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptSignHash(
    hKey          : NCRYPT_KEY_HANDLE;     // _In_
    pPaddingInfo  : PVOID ;                // _In_opt_
    pbHashValue   : PBYTE;                 // _In_reads_bytes_(cbHashValue)
    cbHashValue   : DWORD;                 // _In_
    pbSignature   : PBYTE;                 // _Out_writes_bytes_to_opt_(cbSignature, *pcbResult)
    cbSignature   : DWORD;                 // _In_
    pcbResult     : PDWORD;                // _Out_
    dwFlags       : DWORD                  // _In_
    ):SECURITY_STATUS; stdcall;



{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptVerifySignature(
    hKey           : NCRYPT_KEY_HANDLE;    // _In_
    pPaddingInfo   : PVOID;                // _In_opt_
    pbHashValue    : PBYTE;                // _In_reads_bytes_(cbHashValue)
    cbHashValue    : DWORD;                // _In_
    pbSignature    : PBYTE;                // _In_reads_bytes_(cbSignature)
    cbSignature    : DWORD;                // _In_
    dwFlags        : DWORD                 // _In_
    ): SECURITY_STATUS; stdcall;



{
SECURITY_STATUS
WINAPI
}
function NCryptDeleteKey(
    hKey           : NCRYPT_KEY_HANDLE;    // _In_
    dwFlags        : DWORD                 // _In_
    ): SECURITY_STATUS;



{
SECURITY_STATUS
WINAPI
}
function NCryptFreeObject(
    hObject       : NCRYPT_HANDLE          // _In_
    ): SECURITY_STATUS; stdcall;



{
BOOL
WINAPI
}
function NCryptIsKeyHandle(
    hKey         : NCRYPT_KEY_HANDLE       // _In_
    ): BOOL; stdcall;

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptTranslateHandle(
    phProvider      : PNCRYPT_PROV_HANDLE;  // _Out_opt_
    phKey           : PNCRYPT_KEY_HANDLE;   // _Out_
    hLegacyProv     : HCRYPTPROV;           // _In_
    hLegacyKey      : HCRYPTKEY;            // _In_opt_
    dwLegacyKeySpec : DWORD;                // _In_opt_
    dwFlags         : DWORD                 // _In_
    ): SECURITY_STATUS; stdcall;



// NCryptNotifyChangeKey flags
{
// Identifiers declared above
const
  NCRYPT_REGISTER_NOTIFY_FLAG     = $00000001;
  NCRYPT_UNREGISTER_NOTIFY_FLAG   = $00000002;
  NCRYPT_MACHINE_KEY_FLAG         = $00000020;
  }


{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptNotifyChangeKey(
    hProvider         : NCRYPT_PROV_HANDLE;   // _In_
    phEvent           : PHANDLE;              // _Inout_
    dwFlags           : DWORD                 // _In_
    ): SECURITY_STATUS; stdcall;



{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptSecretAgreement(
    hPrivKey          : NCRYPT_KEY_HANDLE;       // _In_
    hPubKey           : NCRYPT_KEY_HANDLE;       // _In_
    phAgreedSecret    : PNCRYPT_SECRET_HANDLE;   // _Out_
    dwFlags           : DWORD                    // _In_
    ): SECURITY_STATUS; stdcall;



{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptDeriveKey(
    hSharedSecret        : NCRYPT_SECRET_HANDLE; // _In_
    pwszKDF              : LPCWSTR;              // _In_
    pParameterList       : PNCryptBufferDesc;    // _In_opt_
    pbDerivedKey         : PBYTE;                // _Out_writes_bytes_to_opt_(cbDerivedKey, *pcbResult)
    cbDerivedKey         : DWORD;                // _In_
    pcbResult            : PDWORD;               // _Out_
    dwFlags              : ULONG                 // _In_
    ): SECURITY_STATUS;



{$ifdef NTDDI_WIN8}

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptKeyDerivation(
    hKey              : NCRYPT_KEY_HANDLE;       // _In_
    pParameterList    : PNCryptBufferDesc;       // _In_opt_
    pbDerivedKey      : PUCHAR;                  // _Out_writes_bytes_to_(cbDerivedKey, *pcbResult)
    cbDerivedKey      : DWORD;                   // _In_
    pcbResult         : PDWORD;                  // _Out_
    dwFlags           : ULONG                    // _In_
    ): SECURITY_STATUS; stdcall;

{$endif}  // (NTDDI_VERSION >= NTDDI_WIN8)


{$ifdef NTDDI_WINTHRESHOLD}

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptCreateClaim(
    hSubjectKey       : NCRYPT_KEY_HANDLE;       // _In_
    hAuthorityKey     : NCRYPT_KEY_HANDLE;       // _In_opt_
    dwClaimType       : DWORD;                   // _In_
    pParameterList    : PNCryptBufferDesc;       // _In_opt_
    pbClaimBlob       : PBYTE;                   // _Out_writes_bytes_to_opt_(cbClaimBlob, *pcbResult)
    cbClaimBlob       : DWORD;                   // _In_
    pcbResult         : DWORD;                   // _Out_
    dwFlags           : DWORD                    // _In_
    ): SECURITY_STATUS; stdcall;

{
_Check_return_
SECURITY_STATUS
WINAPI
}
function NCryptVerifyClaim(
    hSubjectKey      : NCRYPT_KEY_HANDLE;        // _In_
    hAuthorityKey    : NCRYPT_KEY_HANDLE;        // _In_opt_
    dwClaimType      : DWORD;                    // _In_
    pParameterList   : NCryptBufferDesc;         // _In_opt_
    pbClaimBlob      : PBYTE;                    // _In_reads_bytes_(cbClaimBlob)
    cbClaimBlob      : DWORD;                    // _In_
    pOutput          : PNCryptBufferDesc;        // _Out_
    dwFlags          : DWORD                     // _In_
    ): SECURITY_STATUS; stdcall;


{$endif}  // (NTDDI_VERSION >= NTDDI_WINTHRESHOLD)

{

const
  NCRYPT_KEY_STORAGE_INTERFACE_VERSION =  BCRYPT_MAKE_INTERFACE_VERSION(1,0);
  NCRYPT_KEY_STORAGE_INTERFACE_VERSION_2 = BCRYPT_MAKE_INTERFACE_VERSION(2,0);
  NCRYPT_KEY_STORAGE_INTERFACE_VERSION_3 = BCRYPT_MAKE_INTERFACE_VERSION(3,0);
}

implementation


function NCryptOpenStorageProvider; external NCRYPTDLL name 'NCryptOpenStorageProvider';
function NCryptEnumAlgorithms; external NCRYPTDLL name 'NCryptEnumAlgorithms';
function NCryptIsAlgSupported; external NCRYPTDLL name 'NCryptIsAlgSupported';
function NCryptEnumKeys; external NCRYPTDLL name 'NCryptEnumKeys';
function NCryptEnumStorageProviders; external NCRYPTDLL name 'NCryptEnumStorageProviders';
function NCryptFreeBuffer; external NCRYPTDLL name 'NCryptFreeBuffer';
function NCryptOpenKey; external NCRYPTDLL name 'NCryptOpenKey';
function NCryptCreatePersistedKey; external NCRYPTDLL name 'NCryptCreatePersistedKey';
function NCryptGetProperty; external NCRYPTDLL name 'NCryptGetProperty';
function NCryptSetProperty; external NCRYPTDLL name 'NCryptSetProperty';
function NCryptFinalizeKey; external NCRYPTDLL name 'NCryptFinalizeKey';
function NCryptEncrypt; external NCRYPTDLL name 'NCryptEncrypt';
function NCryptDecrypt; external NCRYPTDLL name 'NCryptDecrypt';
function NCryptImportKey; external NCRYPTDLL name 'NCryptImportKey';
function NCryptExportKey; external NCRYPTDLL name 'NCryptExportKey';
function NCryptSignHash; external NCRYPTDLL name 'NCryptSignHash';
function NCryptVerifySignature; external NCRYPTDLL name 'NCryptVerifySignature';
function NCryptDeleteKey; external NCRYPTDLL name 'NCryptDeleteKey';
function NCryptFreeObject; external NCRYPTDLL name 'NCryptFreeObject';
function NCryptIsKeyHandle; external NCRYPTDLL name 'NCryptIsKeyHandle';
function NCryptTranslateHandle; external NCRYPTDLL name 'NCryptTranslateHandle';
function NCryptNotifyChangeKey; external NCRYPTDLL name 'NCryptNotifyChangeKey';
function NCryptSecretAgreement; external NCRYPTDLL name 'NCryptSecretAgreement';
function NCryptDeriveKey; external NCRYPTDLL name 'NCryptDeriveKey';
{$ifdef NTDDI_WIN8}
function NCryptKeyDerivation; external NCRYPTDLL name'NCryptKeyDerivation';
{$endif}
{$ifdef NTDDI_WINTHRESHOLD}
function NCryptCreateClaim; external NCRYPTDLL name 'NCryptCreateClaim';
function NCryptVerifyClaim; external NCRYPTDLL name 'NCryptVerifyClaim';
{$endif}


end.
