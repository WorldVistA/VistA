unit bcrypt;

//+---------------------------------------------------------------------------
//
//  Temp comment
//
//  Microsoft Windows
//  Copyright (C) Microsoft Corporation, 2004.
//
//  File:       bcrypt.h
//
//  Contents:   Cryptographic Primitive API Prototypes and Definitions
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

uses
  Windows, ntstatus_code;

//typedef _Return_type_success_(return >= 0) LONG NTSTATUS;
//typedef NTSTATUS *PNTSTATUS;
//#define BCRYPT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
type
  PNTSTATUS  = ^NTSTATUS;
  NTSTATUS   = LONG;
  PWSTR      = LPWSTR;
  PPWSTR     = ^PWSTR;
  PPUCHAR    = ^PUCHAR;
  function BCRYPT_SUCCESS(Status: NTSTATUS): BOOL;

const
  BCRYPTDLL  = 'bcrypt.dll';


//
//  Alignment macros
//

//
// BCRYPT_OBJECT_ALIGNMENT must be a power of 2
// We align all our internal data structures to 16 to
// allow fast XMM memory accesses.
// BCrypt callers do not need to take any alignment precautions.
//
const
  BCRYPT_OBJECT_ALIGNMENT   = 16;

//
// BCRYPT_STRUCT_ALIGNMENT is an alignment macro that we no longer use.
// It used to align declspec(align(4)) on x86 and declspec(align(8)) on x64/ia64 but
// all structures that used it contained a pointer so they were already 4/8 aligned.
//
//#define BCRYPT_STRUCT_ALIGNMENT

//
// DeriveKey KDF Types
//
const
  BCRYPT_KDF_HASH                    = WideString('HASH');
  BCRYPT_KDF_HMAC                    = WideString('HMAC');
  BCRYPT_KDF_TLS_PRF                 = WideString('TLS_PRF');

  BCRYPT_KDF_SP80056A_CONCAT         = WideString('SP800_56A_CONCAT');

{$ifdef NTDDI_WINBLUE}
  BCRYPT_KDF_RAW_SECRET              = WideString('TRUNCATE');
{$endif}

//
// DeriveKey KDF BufferTypes
//
// For BCRYPT_KDF_HASH and BCRYPT_KDF_HMAC operations, there may be an arbitrary
// number of KDF_SECRET_PREPEND and KDF_SECRET_APPEND buffertypes in the
// parameter list.  The BufferTypes are processed in order of appearence
// within the parameter list.
//
const
   KDF_HASH_ALGORITHM      = $0;
   KDF_SECRET_PREPEND      = $1;
   KDF_SECRET_APPEND       = $2;
   KDF_HMAC_KEY            = $3;
   KDF_TLS_PRF_LABEL       = $4;
   KDF_TLS_PRF_SEED        = $5;
   KDF_SECRET_HANDLE       = $6;
   KDF_TLS_PRF_PROTOCOL    = $7;
   KDF_ALGORITHMID         = $8;
   KDF_PARTYUINFO          = $9;
   KDF_PARTYVINFO          = $A;
   KDF_SUPPPUBINFO         = $B;
   KDF_SUPPPRIVINFO        = $C;

{$ifdef NTDDI_WIN8}
   KDF_LABEL               = $D;
   KDF_CONTEXT             = $E;
   KDF_SALT                = $F;
   KDF_ITERATION_COUNT     = $10;

// Parameters for BCrypt(/NCrypt)KeyDerivation:
// Generic parameters:
// KDF_GENERIC_PARAMETER and KDF_HASH_ALGORITHM are the generic parameters that can be passed for the following KDF algorithms:
// BCRYPT/NCRYPT_SP800108_CTR_HMAC_ALGORITHM
//      KDF_GENERIC_PARAMETER = KDF_LABEL||0x00||KDF_CONTEXT
// BCRYPT/NCRYPT_SP80056A_CONCAT_ALGORITHM
//      KDF_GENERIC_PARAMETER = KDF_ALGORITHMID || KDF_PARTYUINFO || KDF_PARTYVINFO {|| KDF_SUPPPUBINFO } {|| KDF_SUPPPRIVINFO }
// BCRYPT/NCRYPT_PBKDF2_ALGORITHM
//      KDF_GENERIC_PARAMETER = KDF_SALT
// BCRYPT/NCRYPT_CAPI_KDF_ALGORITHM
//      KDF_GENERIC_PARAMETER = Not used
// BCRYPT/NCRYPT_TLS1_1_KDF_ALGORITHM
//      KDF_GENERIC_PARAMETER = Not used
// BCRYPT/NCRYPT_TLS1_2_KDF_ALGORITHM
//      KDF_GENERIC_PARAMETER = Not used
//
// KDF specific parameters:
// For BCRYPT/NCRYPT_SP800108_CTR_HMAC_ALGORITHM:
//      KDF_HASH_ALGORITHM, KDF_LABEL and KDF_CONTEXT are required
// For BCRYPT/NCRYPT_SP80056A_CONCAT_ALGORITHM:
//      KDF_HASH_ALGORITHM, KDF_ALGORITHMID, KDF_PARTYUINFO, KDF_PARTYVINFO are required
//      KDF_SUPPPUBINFO, KDF_SUPPPRIVINFO are optional
// For BCRYPT/NCRYPT_PBKDF2_ALGORITHM
//      KDF_HASH_ALGORITHM is required
//      KDF_ITERATION_COUNT, KDF_SALT are optional
//      Iteration count, (if not specified) will default to 10,000
// For BCRYPT/NCRYPT_CAPI_KDF_ALGORITHM
//      KDF_HASH_ALGORITHM is required
// For BCRYPT/NCRYPT_TLS1_1_KDF_ALGORITHM
//      KDF_TLS_PRF_LABEL is required
//      KDF_TLS_PRF_SEED is required
// For BCRYPT/NCRYPT_TLS1_2_KDF_ALGORITHM
//      KDF_HASH_ALGORITHM is required
//      KDF_TLS_PRF_LABEL is required
//      KDF_TLS_PRF_SEED is required
//
  KDF_GENERIC_PARAMETER  = $11;
  KDF_KEYBITLENGTH       = $12;
{$endif}


//
// DeriveKey Flags:
//
// KDF_USE_SECRET_AS_HMAC_KEY_FLAG causes the secret agreement to serve also
// as the HMAC key.  If this flag is used, the KDF_HMAC_KEY parameter should
// NOT be specified.
//
const
  KDF_USE_SECRET_AS_HMAC_KEY_FLAG = $1;

//
// BCrypt structs
//

type
  BCRYPT_KEY_LENGTHS_STRUCT = record
    dwMinLength          : ULONG;
    dwMaxLength          : ULONG;
    dwIncrement          : ULONG;
  end;
  BCRYPT_AUTH_TAG_LENGTHS_STRUCT = BCRYPT_KEY_LENGTHS_STRUCT;

  PBCRYPT_OID = ^BCRYPT_OID;
  BCRYPT_OID = record
    cbOID      : ULONG;
    pbOID      : PUCHAR;
  end;

  BCRYPT_OID_LIST = record
    dwOIDCount      : ULONG;
    pOIDs           : PBCRYPT_OID;
  end;


  PBCRYPT_PKCS1_PADDING_INFO = ^BCRYPT_PKCS1_PADDING_INFO;
  BCRYPT_PKCS1_PADDING_INFO = record
    pszAlgId        : LPCWSTR;
  end;

  BCRYPT_PSS_PADDING_INFO = record
    pszAlgId        : LPCWSTR;
    cbSalt          : ULONG;
  end;

  BCRYPT_OAEP_PADDING_INFO = record
    pszAlgId        : LPCWSTR;
    pbLabel         : PUCHAR;
    cbLabel         : ULONG;
  end;


const
  BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO_VERSION  = 1;

  BCRYPT_AUTH_MODE_CHAIN_CALLS_FLAG   = $00000001;
  BCRYPT_AUTH_MODE_IN_PROGRESS_FLAG   = $00000002;

type
  PBCRYPT_AUTHENTICATED_CIPHER_MODE_INFO = ^BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO;
  BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO = record
    cbSize                    : ULONG;
    dwInfoVersion             : ULONG;
    pbNonce                   : PUCHAR;
    cbNonce                   : ULONG;
    pbAuthData                : PUCHAR;
    cbAuthData                : ULONG;
    pbTag                     : PUCHAR;
    cbTag                     : ULONG;
    pbMacContext              : PUCHAR;
    cbMacContext              : ULONG;
    cbAAD                     : ULONG;
    cbData                    : ULONGLONG;
    dwFlags                   : ULONG;
  end;

{
FIXME - we need to come back and unwind this into a function
#define BCRYPT_INIT_AUTH_MODE_INFO(_AUTH_INFO_STRUCT_)    \
            RtlZeroMemory((&_AUTH_INFO_STRUCT_), sizeof(BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO));  \
            (_AUTH_INFO_STRUCT_).cbSize = sizeof(BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO);          \
            (_AUTH_INFO_STRUCT_).dwInfoVersion = BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO_VERSION;
}

//
// BCrypt String Properties
//

// BCrypt(Import/Export)Key BLOB types
const
   BCRYPT_OPAQUE_KEY_BLOB      = WideString('OpaqueKeyBlob');
   BCRYPT_KEY_DATA_BLOB        = WideString('KeyDataBlob');

   BCRYPT_AES_WRAP_KEY_BLOB    = WideString('Rfc3565KeyWrapBlob');

// BCryptGetProperty strings
   BCRYPT_OBJECT_LENGTH        = WideString('ObjectLength');
   BCRYPT_ALGORITHM_NAME       = WideString('AlgorithmName');
   BCRYPT_PROVIDER_HANDLE      = WideString('ProviderHandle');
   BCRYPT_CHAINING_MODE        = WideString('ChainingMode');
   BCRYPT_BLOCK_LENGTH         = WideString('BlockLength');
   BCRYPT_KEY_LENGTH           = WideString('KeyLength');
   BCRYPT_KEY_OBJECT_LENGTH    = WideString('KeyObjectLength');
   BCRYPT_KEY_STRENGTH         = WideString('KeyStrength');
   BCRYPT_KEY_LENGTHS          = WideString('KeyLengths');
   BCRYPT_BLOCK_SIZE_LIST      = WideString('BlockSizeList');
   BCRYPT_EFFECTIVE_KEY_LENGTH = WideString('EffectiveKeyLength');
   BCRYPT_HASH_LENGTH          = WideString('HashDigestLength');
   BCRYPT_HASH_OID_LIST        = WideString('HashOIDList');
   BCRYPT_PADDING_SCHEMES      = WideString('PaddingSchemes');
   BCRYPT_SIGNATURE_LENGTH     = WideString('SignatureLength');
   BCRYPT_HASH_BLOCK_LENGTH    = WideString('HashBlockLength');
   BCRYPT_AUTH_TAG_LENGTH      = WideString('AuthTagLength');

   BCRYPT_PRIMITIVE_TYPE       = WideString('PrimitiveType');
   BCRYPT_IS_KEYED_HASH        = WideString('IsKeyedHash');

{$ifdef NTDDI_WIN8}
   BCRYPT_IS_REUSABLE_HASH     = WideString('IsReusableHash');
   BCRYPT_MESSAGE_BLOCK_LENGTH = WideString('MessageBlockLength');
   BCRYPT_PUBLIC_KEY_LENGTH    = WideString('PublicKeyLength');
{$endif}


// Additional BCryptGetProperty strings for the RNG Platform Crypto Provider
   BCRYPT_PCP_PLATFORM_TYPE_PROPERTY    = WideString('PCP_PLATFORM_TYPE');
   BCRYPT_PCP_PROVIDER_VERSION_PROPERTY = WideString('PCP_PROVIDER_VERSION');

{$ifdef NTDDI_WINBLUE}
   BCRYPT_MULTI_OBJECT_LENGTH  = WideString('MultiObjectLength');
{$endif}

// BCryptSetProperty strings
   BCRYPT_INITIALIZATION_VECTOR    = WideString('IV');

// Property Strings
   BCRYPT_CHAIN_MODE_NA        = WideString('ChainingModeN/A');
   BCRYPT_CHAIN_MODE_CBC       = WideString('ChainingModeCBC');
   BCRYPT_CHAIN_MODE_ECB       = WideString('ChainingModeECB');
   BCRYPT_CHAIN_MODE_CFB       = WideString('ChainingModeCFB');
   BCRYPT_CHAIN_MODE_CCM       = WideString('ChainingModeCCM');
   BCRYPT_CHAIN_MODE_GCM       = WideString('ChainingModeGCM');

// Supported RSA Padding Types
   BCRYPT_SUPPORTED_PAD_ROUTER     = $00000001;
   BCRYPT_SUPPORTED_PAD_PKCS1_ENC  = $00000002;
   BCRYPT_SUPPORTED_PAD_PKCS1_SIG  = $00000004;
   BCRYPT_SUPPORTED_PAD_OAEP       = $00000008;
   BCRYPT_SUPPORTED_PAD_PSS        = $00000010;

//
//      BCrypt Flags
//

   BCRYPT_PROV_DISPATCH        = $00000001;  // BCryptOpenAlgorithmProvider

   BCRYPT_BLOCK_PADDING        = $00000001;  // BCryptEncrypt/Decrypt

// RSA padding schemes
   BCRYPT_PAD_NONE             = $00000001;
   BCRYPT_PAD_PKCS1            = $00000002;  // BCryptEncrypt/Decrypt BCryptSignHash/VerifySignature
   BCRYPT_PAD_OAEP             = $00000004;  // BCryptEncrypt/Decrypt
   BCRYPT_PAD_PSS              = $00000008;  // BCryptSignHash/VerifySignature
{$ifdef NTDDI_WINBLUE}
   BCRYPT_PAD_PKCS1_OPTIONAL_HASH_OID  = $00000010;   //BCryptVerifySignature
{$endif}

   BCRYPTBUFFER_VERSION        = 0;

type
  PBCryptBuffer = ^BCryptBuffer;
  BCryptBuffer = record
    cbBuffer     : ULONG;             // Length of buffer, in bytes
    BufferType   : ULONG;             // Buffer type
    pvBuffer     : PVOID;             // Pointer to buffer
  end;

  PBCryptBufferDesc = ^BCryptBufferDesc;
  BCryptBufferDesc = record
    ulVersion    : ULONG;             // Version number
    cBuffers     : ULONG;             // Number of buffers
    pBuffers     : PBCryptBuffer;     // Pointer to array of buffers
  end;


//
// Primitive handles
//

type
  PBCRYPT_HANDLE        = ^BCRYPT_HANDLE;
  BCRYPT_HANDLE         = PVOID;
  PBCRYPT_ALG_HANDLE    = ^BCRYPT_ALG_HANDLE;
  BCRYPT_ALG_HANDLE     = PVOID;
  PBCRYPT_KEY_HANDLE    = ^BCRYPT_KEY_HANDLE;
  BCRYPT_KEY_HANDLE     = PVOID;
  PBCRYPT_HASH_HANDLE   = ^BCRYPT_HASH_HANDLE;
  BCRYPT_HASH_HANDLE    = PVOID;
  PBCRYPT_SECRET_HANDLE = ^BCRYPT_SECRET_HANDLE;
  BCRYPT_SECRET_HANDLE  = PVOID;

//
// Structures used to represent key blobs.
//
const
 BCRYPT_PUBLIC_KEY_BLOB       = WideString('PUBLICBLOB');
 BCRYPT_PRIVATE_KEY_BLOB      = WideString('PRIVATEBLOB');

type
  BCRYPT_KEY_BLOB = record
    Magic         : ULONG;
  end;


// The BCRYPT_RSAPUBLIC_BLOB and BCRYPT_RSAPRIVATE_BLOB blob types are used
// to transport plaintext RSA keys. These blob types will be supported by
// all RSA primitive providers.
// The BCRYPT_RSAPRIVATE_BLOB includes the following values:
// Public Exponent
// Modulus
// Prime1
// Prime2
const
 BCRYPT_RSAPUBLIC_BLOB       = WideString('RSAPUBLICBLOB');
 BCRYPT_RSAPRIVATE_BLOB      = WideString('RSAPRIVATEBLOB');
 LEGACY_RSAPUBLIC_BLOB       = WideString('CAPIPUBLICBLOB');
 LEGACY_RSAPRIVATE_BLOB      = WideString('CAPIPRIVATEBLOB');

 BCRYPT_RSAPUBLIC_MAGIC      = $31415352;  // RSA1
 BCRYPT_RSAPRIVATE_MAGIC     = $32415352;  // RSA2

type
  BCRYPT_RSAKEY_BLOB = record
    Magic            : ULONG;
    BitLength        : ULONG;
    cbPublicExp      : ULONG;
    cbModulus        : ULONG;
    cbPrime1         : ULONG;
    cbPrime2         : ULONG;
  end;


// The BCRYPT_RSAFULLPRIVATE_BLOB blob type is used to transport
// plaintext private RSA keys.  It includes the following values:
// Public Exponent
// Modulus
// Prime1
// Prime2
// Private Exponent mod (Prime1 - 1)
// Private Exponent mod (Prime2 - 1)
// Inverse of Prime2 mod Prime1
// PrivateExponent
const
  BCRYPT_RSAFULLPRIVATE_BLOB      = WideString('RSAFULLPRIVATEBLOB');

  BCRYPT_RSAFULLPRIVATE_MAGIC     = $33415352;  // RSA3

//Properties of secret agreement algorithms
{$ifdef NTDDI_WIN8}
  BCRYPT_GLOBAL_PARAMETERS    = WideString('SecretAgreementParam');
  BCRYPT_PRIVATE_KEY          = WideString('PrivKeyVal');
{$endif}

// The BCRYPT_ECCPUBLIC_BLOB and BCRYPT_ECCPRIVATE_BLOB blob types are used
// to transport plaintext ECC keys. These blob types will be supported by
// all ECC primitive providers.
const
 BCRYPT_ECCPUBLIC_BLOB           = WideString('ECCPUBLICBLOB');
 BCRYPT_ECCPRIVATE_BLOB          = WideString('ECCPRIVATEBLOB');

{$ifdef NTDDI_WINTHRESHOLD}
 BCRYPT_ECCFULLPUBLIC_BLOB       = WideString('ECCFULLPUBLICBLOB');
 BCRYPT_ECCFULLPRIVATE_BLOB      = WideString('ECCFULLPRIVATEBLOB');
 SSL_ECCPUBLIC_BLOB              = WideString('SSLECCPUBLICBLOB');
{$endif}

 BCRYPT_ECDH_PUBLIC_P256_MAGIC   = $314B4345;  // ECK1
 BCRYPT_ECDH_PRIVATE_P256_MAGIC  = $324B4345;  // ECK2
 BCRYPT_ECDH_PUBLIC_P384_MAGIC   = $334B4345;  // ECK3
 BCRYPT_ECDH_PRIVATE_P384_MAGIC  = $344B4345;  // ECK4
 BCRYPT_ECDH_PUBLIC_P521_MAGIC   = $354B4345;  // ECK5
 BCRYPT_ECDH_PRIVATE_P521_MAGIC  = $364B4345;  // ECK6

{$ifdef NTDDI_WINTHRESHOLD}
 BCRYPT_ECDH_PUBLIC_GENERIC_MAGIC    = $504B4345;  // ECKP
 BCRYPT_ECDH_PRIVATE_GENERIC_MAGIC   = $564B4345;  // ECKV
{$endif}

 BCRYPT_ECDSA_PUBLIC_P256_MAGIC  = $31534345;  // ECS1
 BCRYPT_ECDSA_PRIVATE_P256_MAGIC = $32534345;  // ECS2
 BCRYPT_ECDSA_PUBLIC_P384_MAGIC  = $33534345;  // ECS3
 BCRYPT_ECDSA_PRIVATE_P384_MAGIC = $34534345;  // ECS4
 BCRYPT_ECDSA_PUBLIC_P521_MAGIC  = $35534345;  // ECS5
 BCRYPT_ECDSA_PRIVATE_P521_MAGIC = $36534345;  // ECS6

{$ifdef NTDDI_WINTHRESHOLD}
 BCRYPT_ECDSA_PUBLIC_GENERIC_MAGIC   = $50444345;  // ECDP
 BCRYPT_ECDSA_PRIVATE_GENERIC_MAGIC  = $56444345;  // ECDV
{$endif}

type
  PBCRYPT_ECCKEY_BLOB = ^BCRYPT_ECCKEY_BLOB;
  BCRYPT_ECCKEY_BLOB = record
    dwMagic         : ULONG;
    cbKey           : ULONG;
  end;

{$ifdef NTDDI_WINTHRESHOLD}
//SSL ECC Public Blob Version
type
  PSSL_ECCKEY_BLOB = ^SSL_ECCKEY_BLOB;
  SSL_ECCKEY_BLOB = record
    ULONG   dwCurveType;
    ULONG   cbKey;
  end;

//ECC Full versions
const
  BCRYPT_ECC_FULLKEY_BLOB_V1              = $1;

type
  ECC_CURVE_TYPE_ENUM =
  (
    BCRYPT_ECC_PRIME_SHORT_WEIERSTRASS_CURVE    = $1,
    BCRYPT_ECC_PRIME_TWISTED_EDWARDS_CURVE,
    BCRYPT_ECC_PRIME_MONTGOMERY_CURVE
  );

  ECC_CURVE_ALG_ID_ENUM =
  (
    BCRYPT_NO_CURVE_GENERATION_ALG_ID = $0
  );

//The full version contains the curve parameters as well
//as the public and potentially private exponent.
type
  PBCRYPT_ECCFULLKEY_BLOB = ^BCRYPT_ECCFULLKEY_BLOB;
  BCRYPT_ECCFULLKEY_BLOB = record
    dwMagic                 : ULONG;
    dwVersion               : ULONG;                //Version of the structure
    dwCurveType             : ECC_CURVE_TYPE_ENUM;  //Supported curve types.
    dwCurveGenerationAlgId  : ECC_CURVE_ALG_ID_ENUM;//For X.592 verification purposes, if we include Seed we will need to include the algorithm ID.
    cbFieldLength           : ULONG;                //Byte length of the fields P, A, B, X, Y.
    cbSubgroupOrder         : ULONG;                //Byte length of the subgroup.
    cbCofactor              : ULONG;                //Byte length of cofactor of G in E.
    cbSeed                  : ULONG;                //Byte length of the seed used to generate the curve.
    //P[cbFieldLength]              Prime specifying the base field.
    //A[cbFieldLength]              Coefficient A of the equation y^2 = x^3 + A*x + B mod p
    //B[cbFieldLength]              Coefficient B of the equation y^2 = x^3 + A*x + B mod p
    //Gx[cbFieldLength]             X-coordinate of the base point.
    //Gy[cbFieldLength]             Y-coordinate of the base point.
    //n[cbSubgroupOrder]            Order of the group generated by G = (x,y)
    //h[cbCofactor]                 Cofactor of G in E.
    //S[cbSeed]                     Seed of the curve.
    //Qx[cbFieldLength]             X-coordinate of the public point.
    //Qy[cbFieldLength]             Y-coordinate of the public point.
    //d[cbSubgroupOrder]            Private key.  Not always present.
  end;
{$endif}

// The BCRYPT_DH_PUBLIC_BLOB and BCRYPT_DH_PRIVATE_BLOB blob types are used
// to transport plaintext DH keys. These blob types will be supported by
// all DH primitive providers.
const
 BCRYPT_DH_PUBLIC_BLOB           = WideString('DHPUBLICBLOB');
 BCRYPT_DH_PRIVATE_BLOB          = WideString('DHPRIVATEBLOB');
 LEGACY_DH_PUBLIC_BLOB           = WideString('CAPIDHPUBLICBLOB');
 LEGACY_DH_PRIVATE_BLOB          = WideString('CAPIDHPRIVATEBLOB');

 BCRYPT_DH_PUBLIC_MAGIC          = $42504844;  // DHPB
 BCRYPT_DH_PRIVATE_MAGIC         = $56504844;  // DHPV

type
  PBCRYPT_DH_KEY_BLOB = ^BCRYPT_DH_KEY_BLOB;
  BCRYPT_DH_KEY_BLOB = record
    dwMagic          : ULONG;
    cbKey            : ULONG;
  end;


// Property Strings for DH
const
 BCRYPT_DH_PARAMETERS            = WideString('DHParameters');

 BCRYPT_DH_PARAMETERS_MAGIC      = $4d504844;  // DHPM

type
   //_Struct_size_bytes_(cbLength) struct
   BCRYPT_DH_PARAMETER_HEADER = record
     cbLength        : ULONG;
     dwMagic         : ULONG;
     cbKeyLength     : ULONG;
   end;


// The BCRYPT_DSA_PUBLIC_BLOB and BCRYPT_DSA_PRIVATE_BLOB blob types are used
// to transport plaintext DSA keys. These blob types will be supported by
// all DSA primitive providers.
const
 BCRYPT_DSA_PUBLIC_BLOB          = WideString('DSAPUBLICBLOB');
 BCRYPT_DSA_PRIVATE_BLOB         = WideString('DSAPRIVATEBLOB');
 LEGACY_DSA_PUBLIC_BLOB          = WideString('CAPIDSAPUBLICBLOB');
 LEGACY_DSA_PRIVATE_BLOB         = WideString('CAPIDSAPRIVATEBLOB');
 LEGACY_DSA_V2_PUBLIC_BLOB       = WideString('V2CAPIDSAPUBLICBLOB');
 LEGACY_DSA_V2_PRIVATE_BLOB      = WideString('V2CAPIDSAPRIVATEBLOB');

 BCRYPT_DSA_PUBLIC_MAGIC            = $42505344;  // DSPB
 BCRYPT_DSA_PRIVATE_MAGIC           = $56505344;  // DSPV

{$ifdef NTDDI_WIN8}
 BCRYPT_DSA_PUBLIC_MAGIC_V2          = $32425044;  // DPB2
 BCRYPT_DSA_PRIVATE_MAGIC_V2         = $32565044;  // DPV2
{$endif}

type
  PBCRYPT_DSA_KEY_BLOB = ^BCRYPT_DSA_KEY_BLOB;
  BCRYPT_DSA_KEY_BLOB = record
    dwMagic        : ULONG;
    cbKey          : ULONG;
    Count          : Array [0..4] of UCHAR;
    Seed           : Array [0..20] of UCHAR;
    q              : Array [0..20] of UCHAR   ;
  end;


{$ifdef NTDDI_WIN8}
type
  HASHALGORITHM_ENUM =
  (
    DSA_HASH_ALGORITHM_SHA1,
    DSA_HASH_ALGORITHM_SHA256,
    DSA_HASH_ALGORITHM_SHA512
  );

  DSAFIPSVERSION_ENUM =
  (
    DSA_FIPS186_2,
    DSA_FIPS186_3
  )

type
  PBCRYPT_DSA_KEY_BLOB_V2 = ^BCRYPT_DSA_KEY_BLOB_V2
  BCRYPT_DSA_KEY_BLOB_V2 = record
    dwMagic              : ULONG;
    cbKey                : ULONG;
    hashAlgorithm        : HASHALGORITHM_ENUM;
    standardVersion      : DSAFIPSVERSION_ENUM;
    cbSeedLength         : ULONG;
    cbGroupSize          : ULONG;
    Count                : Array [0..4] of UCHAR;
  end;

{$endif}

type
  PBCRYPT_KEY_DATA_BLOB_HEADER = ^BCRYPT_KEY_DATA_BLOB_HEADER;
  BCRYPT_KEY_DATA_BLOB_HEADER = record
    dwMagic           : ULONG;
    dwVersion         : ULONG;
    cbKeyData         : ULONG;
  end;


const
 BCRYPT_KEY_DATA_BLOB_MAGIC       = $4d42444b; //Key Data Blob Magic (KDBM)

 BCRYPT_KEY_DATA_BLOB_VERSION1    = $1;

// Property Strings for DSA
 BCRYPT_DSA_PARAMETERS       = WideString('DSAParameters');

 BCRYPT_DSA_PARAMETERS_MAGIC         = $4d505344;  // DSPM

{$ifdef NTDDI_WIN8}
 BCRYPT_DSA_PARAMETERS_MAGIC_V2      = $324d5044;  // DPM2
{$endif}

type
  BCRYPT_DSA_PARAMETER_HEADER = record
    cbLength        : ULONG;
    dwMagic         : ULONG;
    cbKeyLength     : ULONG;
    Count           : Array [0..4] of UCHAR;
    Seed            : Array [0..20] of UCHAR;
    q               : Array [0..20] of UCHAR;
  end;

{$ifdef NTDDI_WIN8}
type
  BCRYPT_DSA_PARAMETER_HEADER_V2 = record
    cbLength        : ULONG;
    dwMagic         : ULONG;
    cbKeyLength     : ULONG;
    hashAlgorithm   : HASHALGORITHM_ENUM;
    standardVersion : DSAFIPSVERSION_ENUM;
    cbSeedLength    : ULONG;
    cbGroupSize     : ULONG;
    Count           : Array [0..4] of UCHAR;
  end;
{$endif}

{$ifdef NTDDI_WINTHRESHOLD}
//Property Strings for ECC
const
 BCRYPT_ECC_PARAMETERS       = WideString('ECCParameters');
 BCRYPT_ECC_CURVE_NAME       = WideString('ECCCurveName');
 BCRYPT_ECC_CURVE_NAME_LIST  = WideString('ECCCurveNameList');

 BCRYPT_ECC_PARAMETERS_MAGIC         = $50434345;  // ECCP

type
  BCRYPT_ECC_CURVE_NAMES = record
    dwEccCurveNames      : ULONG;
    pEccCurveNames       : PLPWSTR;
  end;

//
// ECC Curve Names
//
const
 BCRYPT_ECC_CURVE_BRAINPOOLP160R1    = WideString('brainpoolP160r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP160T1    = WideString('brainpoolP160t1');
 BCRYPT_ECC_CURVE_BRAINPOOLP192R1    = WideString('brainpoolP192r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP192T1    = WideString('brainpoolP192t1');
 BCRYPT_ECC_CURVE_BRAINPOOLP224R1    = WideString('brainpoolP224r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP224T1    = WideString('brainpoolP224t1');
 BCRYPT_ECC_CURVE_BRAINPOOLP256R1    = WideString('brainpoolP256r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP256T1    = WideString('brainpoolP256t1');
 BCRYPT_ECC_CURVE_BRAINPOOLP320R1    = WideString('brainpoolP320r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP320T1    = WideString('brainpoolP320t1');
 BCRYPT_ECC_CURVE_BRAINPOOLP384R1    = WideString('brainpoolP384r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP384T1    = WideString('brainpoolP384t1');
 BCRYPT_ECC_CURVE_BRAINPOOLP512R1    = WideString('brainpoolP512r1');
 BCRYPT_ECC_CURVE_BRAINPOOLP512T1    = WideString('brainpoolP512t1');

 BCRYPT_ECC_CURVE_25519              = WideString('curve25519');

 BCRYPT_ECC_CURVE_EC192WAPI          = WideString('ec192wapi');

 BCRYPT_ECC_CURVE_NISTP192           = WideString('nistP192');
 BCRYPT_ECC_CURVE_NISTP224           = WideString('nistP224');
 BCRYPT_ECC_CURVE_NISTP256           = WideString('nistP256');
 BCRYPT_ECC_CURVE_NISTP384           = WideString('nistP384');
 BCRYPT_ECC_CURVE_NISTP521           = WideString('nistP521');

 BCRYPT_ECC_CURVE_NUMSP256T1         = WideString('numsP256t1');
 BCRYPT_ECC_CURVE_NUMSP384T1         = WideString('numsP384t1');
 BCRYPT_ECC_CURVE_NUMSP512T1         = WideString('numsP512t1');

 BCRYPT_ECC_CURVE_SECP160K1          = WideString('secP160k1');
 BCRYPT_ECC_CURVE_SECP160R1          = WideString('secP160r1');
 BCRYPT_ECC_CURVE_SECP160R2          = WideString('secP160r2');
 BCRYPT_ECC_CURVE_SECP192K1          = WideString('secP192k1');
 BCRYPT_ECC_CURVE_SECP192R1          = WideString('secP192r1');
 BCRYPT_ECC_CURVE_SECP224K1          = WideString('secP224k1');
 BCRYPT_ECC_CURVE_SECP224R1          = WideString('secP224r1');
 BCRYPT_ECC_CURVE_SECP256K1          = WideString('secP256k1');
 BCRYPT_ECC_CURVE_SECP256R1          = WideString('secP256r1');
 BCRYPT_ECC_CURVE_SECP384R1          = WideString('secP384r1');
 BCRYPT_ECC_CURVE_SECP521R1          = WideString('secP521r1');

 BCRYPT_ECC_CURVE_WTLS7              = WideString('wtls7');
 BCRYPT_ECC_CURVE_WTLS9              = WideString('wtls9');
 BCRYPT_ECC_CURVE_WTLS12             = WideString('wtls12');

 BCRYPT_ECC_CURVE_X962P192V1         = WideString('x962P192v1');
 BCRYPT_ECC_CURVE_X962P192V2         = WideString('x962P192v2');
 BCRYPT_ECC_CURVE_X962P192V3         = WideString('x962P192v3');
 BCRYPT_ECC_CURVE_X962P239V1         = WideString('x962P239v1');
 BCRYPT_ECC_CURVE_X962P239V2         = WideString('x962P239v2');
 BCRYPT_ECC_CURVE_X962P239V3         = WideString('x962P239v3');
 BCRYPT_ECC_CURVE_X962P256V1         = WideString('x962P256v1');

{$endif}



// Operation types used in BCRYPT_MULTI_HASH_OPERATION structures
type
  BCRYPT_HASH_OPERATION_TYPE = (
    BCRYPT_HASH_OPERATION_HASH_DATA = 1,
    BCRYPT_HASH_OPERATION_FINISH_HASH = 2
  );

  BCRYPT_MULTI_HASH_OPERATION = record
    iHash         : ULONG;                       // index of hash object
    hashOperation : BCRYPT_HASH_OPERATION_TYPE;  // operation to be performed
    pbBuffer      : PUCHAR;                      // data to be hashed, or result buffer  - _Field_size_(cbBuffer)
    cbBuffer      : ULONG;
  end;


  // Enum to specify type of multi-operation is passed to BCryptProcesMultiOperations
  BCRYPT_MULTI_OPERATION_TYPE =
  (
    BCRYPT_OPERATION_TYPE_HASH = 1     // structure type is BCRYPT_MULTI_HASH_OPERATION
  );

  BCRYPT_MULTI_OBJECT_LENGTH_STRUCT  = record
    cbPerObject      : ULONG;
    cbPerElement     : ULONG;  // required size for N elements is (cbPerObject + N * cbPerElement)
  end;

//
// Microsoft built-in providers.
//
const
 MS_PRIMITIVE_PROVIDER                   = WideString('Microsoft Primitive Provider');
 MS_PLATFORM_CRYPTO_PROVIDER             = WideString('Microsoft Platform Crypto Provider');

//
// Common algorithm identifiers.
//
const
 BCRYPT_RSA_ALGORITHM                    = WideString('RSA');
 BCRYPT_RSA_SIGN_ALGORITHM               = WideString('RSA_SIGN');
 BCRYPT_DH_ALGORITHM                     = WideString('DH');
 BCRYPT_DSA_ALGORITHM                    = WideString('DSA');
 BCRYPT_RC2_ALGORITHM                    = WideString('RC2');
 BCRYPT_RC4_ALGORITHM                    = WideString('RC4');
 BCRYPT_AES_ALGORITHM                    = WideString('AES');
 BCRYPT_DES_ALGORITHM                    = WideString('DES');
 BCRYPT_DESX_ALGORITHM                   = WideString('DESX');
 BCRYPT_3DES_ALGORITHM                   = WideString('3DES');
 BCRYPT_3DES_112_ALGORITHM               = WideString('3DES_112');
 BCRYPT_MD2_ALGORITHM                    = WideString('MD2');
 BCRYPT_MD4_ALGORITHM                    = WideString('MD4');
 BCRYPT_MD5_ALGORITHM                    = WideString('MD5');
 BCRYPT_SHA1_ALGORITHM                   = WideString('SHA1');
 BCRYPT_SHA256_ALGORITHM                 = WideString('SHA256');
 BCRYPT_SHA384_ALGORITHM                 = WideString('SHA384');
 BCRYPT_SHA512_ALGORITHM                 = WideString('SHA512');
 BCRYPT_AES_GMAC_ALGORITHM               = WideString('AES-GMAC');
 BCRYPT_AES_CMAC_ALGORITHM               = WideString('AES-CMAC');
 BCRYPT_ECDSA_P256_ALGORITHM             = WideString('ECDSA_P256');
 BCRYPT_ECDSA_P384_ALGORITHM             = WideString('ECDSA_P384');
 BCRYPT_ECDSA_P521_ALGORITHM             = WideString('ECDSA_P521');
 BCRYPT_ECDH_P256_ALGORITHM              = WideString('ECDH_P256');
 BCRYPT_ECDH_P384_ALGORITHM              = WideString('ECDH_P384');
 BCRYPT_ECDH_P521_ALGORITHM              = WideString('ECDH_P521');
 BCRYPT_RNG_ALGORITHM                    = WideString('RNG');
 BCRYPT_RNG_FIPS186_DSA_ALGORITHM        = WideString('FIPS186DSARNG');
 BCRYPT_RNG_DUAL_EC_ALGORITHM            = WideString('DUALECRNG');

{$ifdef NTDDI_WIN8}
 BCRYPT_SP800108_CTR_HMAC_ALGORITHM      = WideString('SP800_108_CTR_HMAC');
 BCRYPT_SP80056A_CONCAT_ALGORITHM        = WideString('SP800_56A_CONCAT');
 BCRYPT_PBKDF2_ALGORITHM                 = WideString('PBKDF2');
 BCRYPT_CAPI_KDF_ALGORITHM               = WideString('CAPI_KDF');
 BCRYPT_TLS1_1_KDF_ALGORITHM             = WideString('TLS1_1_KDF');
 BCRYPT_TLS1_2_KDF_ALGORITHM             = WideString('TLS1_2_KDF');
{$endif}

{$ifdef NTDDI_WINTHRESHOLD}
 BCRYPT_ECDSA_ALGORITHM                  = WideString('ECDSA');
 BCRYPT_ECDH_ALGORITHM                   = WideString('ECDH');
 BCRYPT_XTS_AES_ALGORITHM                = WideString('XTS-AES');
{$endif}

//
// Interfaces
//

 BCRYPT_CIPHER_INTERFACE                 = $00000001;
 BCRYPT_HASH_INTERFACE                   = $00000002;
 BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE  = $00000003;
 BCRYPT_SECRET_AGREEMENT_INTERFACE       = $00000004;
 BCRYPT_SIGNATURE_INTERFACE              = $00000005;
 BCRYPT_RNG_INTERFACE                    = $00000006;

{$ifdef NTDDI_WIN8}
 BCRYPT_KEY_DERIVATION_INTERFACE         = $00000007;
{$endif}


//
// Algorithm pseudo-handles
// Pseudo-handles are distinguished from normal handles by being 1 mod 16
//
{$ifdef NTDDI_WINTHRESHOLD}
const
 BCRYPT_MD2_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($00000001);
 BCRYPT_MD4_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($00000011);
 BCRYPT_MD5_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($00000021);
 BCRYPT_SHA1_ALG_HANDLE                   = BCRYPT_ALG_HANDLE ($00000031);
 BCRYPT_SHA256_ALG_HANDLE                 = BCRYPT_ALG_HANDLE ($00000041);
 BCRYPT_SHA384_ALG_HANDLE                 = BCRYPT_ALG_HANDLE ($00000051);
 BCRYPT_SHA512_ALG_HANDLE                 = BCRYPT_ALG_HANDLE ($00000061);
 BCRYPT_RC4_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($00000071);
 BCRYPT_RNG_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($00000081);
 BCRYPT_HMAC_MD5_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000091);
 BCRYPT_HMAC_SHA1_ALG_HANDLE              = BCRYPT_ALG_HANDLE ($000000a1);
 BCRYPT_HMAC_SHA256_ALG_HANDLE            = BCRYPT_ALG_HANDLE ($000000b1);
 BCRYPT_HMAC_SHA384_ALG_HANDLE            = BCRYPT_ALG_HANDLE ($000000c1);
 BCRYPT_HMAC_SHA512_ALG_HANDLE            = BCRYPT_ALG_HANDLE ($000000d1);
 BCRYPT_RSA_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($000000e1);
 BCRYPT_ECDSA_ALG_HANDLE                  = BCRYPT_ALG_HANDLE ($000000f1);

 BCRYPT_AES_CMAC_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000101);
 BCRYPT_AES_GMAC_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000111);
 BCRYPT_HMAC_MD2_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000121);
 BCRYPT_HMAC_MD4_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000131);

 BCRYPT_3DES_CBC_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000141);
 BCRYPT_3DES_ECB_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000151);
 BCRYPT_3DES_CFB_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000161);
 BCRYPT_3DES_112_CBC_ALG_HANDLE           = BCRYPT_ALG_HANDLE ($00000171);
 BCRYPT_3DES_112_ECB_ALG_HANDLE           = BCRYPT_ALG_HANDLE ($00000181);
 BCRYPT_3DES_112_CFB_ALG_HANDLE           = BCRYPT_ALG_HANDLE ($00000191);
 BCRYPT_AES_CBC_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($000001a1);
 BCRYPT_AES_ECB_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($000001b1);
 BCRYPT_AES_CFB_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($000001c1);
 BCRYPT_AES_CCM_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($000001d1);
 BCRYPT_AES_GCM_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($000001e1);
 BCRYPT_DES_CBC_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($000001f1);
 BCRYPT_DES_ECB_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($00000201);
 BCRYPT_DES_CFB_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($00000211);
 BCRYPT_DESX_CBC_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000221);
 BCRYPT_DESX_ECB_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000231);
 BCRYPT_DESX_CFB_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000241);
 BCRYPT_RC2_CBC_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($00000251);
 BCRYPT_RC2_ECB_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($00000261);
 BCRYPT_RC2_CFB_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($00000271);

 BCRYPT_DH_ALG_HANDLE                     = BCRYPT_ALG_HANDLE ($00000281);
 BCRYPT_ECDH_ALG_HANDLE                   = BCRYPT_ALG_HANDLE ($00000291);
 BCRYPT_ECDH_P256_ALG_HANDLE              = BCRYPT_ALG_HANDLE ($000002a1);
 BCRYPT_ECDH_P384_ALG_HANDLE              = BCRYPT_ALG_HANDLE ($000002b1);
 BCRYPT_ECDH_P521_ALG_HANDLE              = BCRYPT_ALG_HANDLE ($000002c1);
 BCRYPT_DSA_ALG_HANDLE                    = BCRYPT_ALG_HANDLE ($000002d1);
 BCRYPT_ECDSA_P256_ALG_HANDLE             = BCRYPT_ALG_HANDLE ($000002e1);
 BCRYPT_ECDSA_P384_ALG_HANDLE             = BCRYPT_ALG_HANDLE ($000002f1);
 BCRYPT_ECDSA_P521_ALG_HANDLE             = BCRYPT_ALG_HANDLE ($00000301);
 BCRYPT_RSA_SIGN_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000311);

 BCRYPT_CAPI_KDF_ALG_HANDLE               = BCRYPT_ALG_HANDLE ($00000321);
 BCRYPT_PBKDF2_ALG_HANDLE                 = BCRYPT_ALG_HANDLE ($00000331);

 BCRYPT_SP800108_CTR_HMAC_ALG_HANDLE      = BCRYPT_ALG_HANDLE ($00000341);
 BCRYPT_SP80056A_CONCAT_ALG_HANDLE        = BCRYPT_ALG_HANDLE ($00000351);

 BCRYPT_TLS1_1_KDF_ALG_HANDLE             = BCRYPT_ALG_HANDLE ($00000361);
 BCRYPT_TLS1_2_KDF_ALG_HANDLE             = BCRYPT_ALG_HANDLE ($00000371);

 BCRYPT_XTS_AES_ALG_HANDLE                = BCRYPT_ALG_HANDLE ($00000381);

{$endif}

//
// Primitive algorithm provider functions.
//

const
  BCRYPT_ALG_HANDLE_HMAC_FLAG             = $00000008;
  BCRYPT_HASH_REUSABLE_FLAG               = $00000020;

{$ifdef NTDDI_WIN8}
const
  BCRYPT_CAPI_AES_FLAG                    = $00000010;
{$endif}

{$ifdef NTDDI_WINBLUE}
const
  BCRYPT_MULTI_FLAG                       0x00000040
{$endif}

//
// The BUFFERS_LOCKED flag used in BCryptEncrypt/BCryptDecrypt signals that
// the pbInput and pbOutput buffers have been locked (see MmProbeAndLockPages)
// and CNG may not lock the buffers again.
// This flag applies only to kernel mode, it is ignored in user mode.
//
const
  BCRYPT_BUFFERS_LOCKED_FLAG      = $00000040;

//
// The EXTENDED_KEYSIZE flag extends the supported set of key sizes.
//
// The original design has a per-algorithm maximum key size, and
// BCryptGenerateSymmetricKey truncates any longer input to the maximum key size for that
// algorithm. Some callers depend on this feature and pass in large buffers.
// This makes it impossible to silently extend the supported key size without breaking
// backward compatibility.
// This flag indicates that the extended key size support is requested.
// It has the following consequences:
// - BCryptGetProperty will report a new maximum key size for BCRYPT_KEY_LENGTHS.
// - BCryptGenerateSymmetricKey will support the longer key sizes.
// - BCryptGenerateSymmetricKey will no longer truncate keys that are too long, but return an error instead.
//
{$ifdef NTDDI_WINBLUE}
const
  BCRYPT_EXTENDED_KEYSIZE         = $00000080;
{$endif}

//
// ENABLE_INCOMPATIBLE_FIPS_CHECKS flag enables some FIPS 140-2-mandated checks that are incompatible
// with the original algorithm.
//
// Starting in Redstone 1 (summer 2016 release of Win10) this flag has the following effect on the
//  Microsoft default algorithm provider.
// - BCryptGenerateSymmetricKey when generating an XTS-AES key with this flag specified and FIPS mode enabled
//      will verify that the two halves of the key are not identical. If they are, an error is returned.
//      This is actually incompatible with the NIST SP 800-38E and IEEE Std 1619-2007 definitions
//      of XTS-AES. Rather than change the standard, NIST added this requirement in the FIPS 140-2
//      implementation guidance.
//      This check breaks existing usage of the algorithm, which is why we only perform the check when the
//      caller explicitly asks for it.
//      Use of this flag  for any algorithm other than XTS-AES generates an error.
// Note that this flag is not supported for BCryptImportKey.
//
{$ifdef NTDDI_WINTHRESHOLD}
const
  BCRYPT_ENABLE_INCOMPATIBLE_FIPS_CHECKS	= $00000100;
{$endif}

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptOpenAlgorithmProvider(
    phAlgorithm       : PBCRYPT_ALG_HANDLE;  // _Out_
    pszAlgId          : LPCWSTR;             // _In_
    pszImplementation : LPCWSTR;             // _In_opt_
    dwFlags           : ULONG                // _In_
    ): NTSTATUS; stdcall;



// AlgOperations flags for use with BCryptEnumAlgorithms()
const
 BCRYPT_CIPHER_OPERATION                 = $00000001;
 BCRYPT_HASH_OPERATION                   = $00000002;
 BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION  = $00000004;
 BCRYPT_SECRET_AGREEMENT_OPERATION       = $00000008;
 BCRYPT_SIGNATURE_OPERATION              = $00000010;
 BCRYPT_RNG_OPERATION                    = $00000020;

{$ifdef NTDDI_WIN8}
 BCRYPT_KEY_DERIVATION_OPERATION         = $00000040;
{$endif}

// USE EXTREME CAUTION: editing comments that contain "certenrolls_*" tokens
// could break building CertEnroll idl files:
// certenrolls_begin -- BCRYPT_ALGORITHM_IDENTIFIER
type
  PBCRYPT_ALGORITHM_IDENTIFIER = ^BCRYPT_ALGORITHM_IDENTIFIER;
  BCRYPT_ALGORITHM_IDENTIFIER = record
    pszName       : LPWSTR;
    dwClass       : ULONG;
    dwFlags       : ULONG;
  end;
  PPBCRYPT_ALGORITHM_IDENTIFIER = ^PBCRYPT_ALGORITHM_IDENTIFIER;

// certenrolls_end

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEnumAlgorithms(
    dwAlgOperations        : ULONG;   // _In_
    pAlgCount              : PULONG;  // _Out_
    ppAlgList              : PPBCRYPT_ALGORITHM_IDENTIFIER; // _Out_
    dwFlags                : ULONG    // _In_
  ): NTSTATUS; stdcall;

type
  PBCRYPT_PROVIDER_NAME = ^BCRYPT_PROVIDER_NAME;
  BCRYPT_PROVIDER_NAME = record
    pszProviderName    : LPWSTR;
  end;
  PPBCRYPT_PROVIDER_NAME = ^PBCRYPT_PROVIDER_NAME;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEnumProviders(
    pszAlgId   : LPCWSTR;    // _In_
    pImplCount : PULONG;     // _Out_
    ppImplList : PPBCRYPT_PROVIDER_NAME;  //_Out_
    dwFlags    : ULONG                    // _In_
    ): NTSTATUS; stdcall;


// Unused flags. Kept for backward compatibility.
//   "Flags for use with BCryptGetProperty and BCryptSetProperty"
const
 BCRYPT_PUBLIC_KEY_FLAG                  = $00000001;
 BCRYPT_PRIVATE_KEY_FLAG                 = $00000002;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptGetProperty(
    hObject        : BCRYPT_HANDLE;  // _In_
    pszProperty    : LPCWSTR;        // _In_
    pbOutput       : PUCHAR;         // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput       : ULONG;          // _In_
    pcbResult      : PULONG;         // _Out_
    dwFlags        : ULONG           // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptSetProperty(
    hObject       : BCRYPT_HANDLE;  // _Inout_
    pszProperty   : LPCWSTR;        // _In_
    pbInput       : PUCHAR;         // _In_reads_bytes_(cbInput)
    cbInput       : ULONG;          // _In_
    dwFlags       : ULONG           // _In_
    ): NTSTATUS; stdcall;


{
NTSTATUS
WINAPI
}
function BCryptCloseAlgorithmProvider(
    hAlgorithm    : BCRYPT_ALG_HANDLE; // _Inout_
    dwFlags       : ULONG              // _In_
    ): NTSTATUS; stdcall;

{
VOID
WINAPI
}
procedure BCryptFreeBuffer(
    pvBuffer   : PVOID     // _In_
    ); stdcall;


//
// Primitive encryption functions.
//

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptGenerateSymmetricKey(
    hAlgorithm      : BCRYPT_ALG_HANDLE;    // _Inout_
    phKey           : PBCRYPT_KEY_HANDLE;   // _Out_
    pbKeyObject     : PUCHAR;               // _Out_writes_bytes_all_opt_(cbKeyObject)
    cbKeyObject     : ULONG;                // _In_
    pbSecret        : PUCHAR;               // _In_reads_bytes_(cbSecret)
    cbSecret        : ULONG;                // _In_
    dwFlags         : ULONG                 // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptGenerateKeyPair(
    hAlgorithm      : BCRYPT_ALG_HANDLE;   // _Inout_
    phKey           : PBCRYPT_KEY_HANDLE;  // _Out_
    dwLength        : ULONG;               // _In_
    dwFlags         : ULONG                // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEncrypt(
    hKey            : BCRYPT_KEY_HANDLE;  // _Inout_
    pbInput         : PUCHAR;             // _In_reads_bytes_opt_(cbInput)
    cbInput         : ULONG;              // _In_
    pPaddingInfo    : PVOID;              // _In_opt_
    pbIV            : PUCHAR;             // _Inout_updates_bytes_opt_(cbIV)
    cbIV            : ULONG;              // _In_
    pbOutput        : PUCHAR;             // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput        : ULONG;              // _In_
    pcbResult       : ULONG;              // _Out_
    dwFlags         : ULONG               // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDecrypt(
    hKey           : BCRYPT_KEY_HANDLE;   // _Inout_
    pbInput        : PUCHAR;              // _In_reads_bytes_opt_(cbInput)
    cbInput        : ULONG;               // _In_
    pPaddingInfo   : PVOID;               // _In_opt_
    pbIV           : PUCHAR;              // _Inout_updates_bytes_opt_(cbIV)
    cbIV           : ULONG;               // _In_
    pbOutput       : PUCHAR;              // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput       : ULONG;               // _In_
    pcbResult      : PULONG;              // _Out_
    dwFlags        : ULONG                // _In_
    ):NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptExportKey(
    hKey          : BCRYPT_KEY_HANDLE;     // _In_
    hExportKey    : BCRYPT_KEY_HANDLE;     // _In_opt_
    pszBlobType   : LPCWSTR;               // _In_
    pbOutput      : PUCHAR;                // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput      : ULONG;                 // _In_
    pcbResult     : PULONG;                // _Out_
    dwFlags       : ULONG                  // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptImportKey(
    hAlgorithm    : BCRYPT_ALG_HANDLE;      //_In_
    hImportKey    : BCRYPT_KEY_HANDLE;      // _In_opt_
    pszBlobType   : LPCWSTR;                // _In_
    phKey         : PBCRYPT_KEY_HANDLE;     // _Out_
    pbKeyObject   : PUCHAR;                 // _Out_writes_bytes_all_opt_(cbKeyObject)
    cbKeyObject   : ULONG;                  // _In_
    pbInput       : PUCHAR;                 // _In_reads_bytes_(cbInput)
    cbInput       : ULONG;                  // _In_
    dwFlags       : ULONG                   // _In_
    ): NTSTATUS; stdcall;


const
  BCRYPT_NO_KEY_VALIDATION    =$00000008;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptImportKeyPair(
    hAlgorithm    : BCRYPT_ALG_HANDLE;   // _In_
    hImportKey    : BCRYPT_KEY_HANDLE;   // _In_opt_
    pszBlobType   : LPCWSTR;             // _In_
    phKey         : PBCRYPT_KEY_HANDLE;  // _Out_
    pbInput       : PUCHAR;              // _In_reads_bytes_(cbInput)
    cbInput       : ULONG;               // _In_
    dwFlags       : ULONG                // _In_
    ):NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDuplicateKey(
    hKey          : BCRYPT_KEY_HANDLE;  // _In_
    phNewKey      : PBCRYPT_KEY_HANDLE; // _Out_
    pbKeyObject   : PUCHAR;             // _Out_writes_bytes_all_opt_(cbKeyObject)
    cbKeyObject   : ULONG;              // _In_
    dwFlags       : ULONG               // _In_
    ):NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptFinalizeKeyPair(
    hKey        : BCRYPT_KEY_HANDLE; // _Inout_
    dwFlags     : ULONG             // _In_
    ): NTSTATUS; stdcall;


{
NTSTATUS
WINAPI
}
function BCryptDestroyKey(
    hKey       : BCRYPT_KEY_HANDLE // _Inout_
    ): NTSTATUS; stdcall;


{
NTSTATUS
WINAPI
}
function BCryptDestroySecret(
    hSecret    : BCRYPT_SECRET_HANDLE  // _Inout_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptSignHash(
    hKey           : BCRYPT_KEY_HANDLE; //_In_
    pPaddingInfo   : PVOID;             // _In_opt_
    pbInput        : PUCHAR;            // _In_reads_bytes_(cbInput)
    cbInput        : ULONG;             // _In_
    pbOutput       : PUCHAR;            // _Out_writes_bytes_to_opt_(cbOutput, *pcbResult)
    cbOutput       : ULONG;             // _In_
    pcbResult      : PULONG;            // _Out_
    dwFlags        : ULONG              // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptVerifySignature(
    hKey           : BCRYPT_KEY_HANDLE; // _In_
    pPaddingInfo   : PVOID;             // _In_opt_
    pbHash         : PUCHAR;            // _In_reads_bytes_(cbHash)
    cbHash         : ULONG;             // _In_
    pbSignature    : PUCHAR;            // _In_reads_bytes_(cbSignature)
    cbSignature    : ULONG;             // _In_
    dwFlags        : ULONG              // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptSecretAgreement(
    hPrivKey       : BCRYPT_KEY_HANDLE;     // _In_
    hPubKey        : BCRYPT_KEY_HANDLE;     // _In_
    phAgreedSecret : PBCRYPT_SECRET_HANDLE; // _Out_
    dwFlags        : ULONG                  // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDeriveKey(
    hSharedSecret  : BCRYPT_SECRET_HANDLE;  // _In_
    pwszKDF        : LPCWSTR;               // _In_
    pParameterList : PBCryptBufferDesc;     // _In_opt_
    pbDerivedKey   : PUCHAR;                // _Out_writes_bytes_to_opt_(cbDerivedKey, *pcbResult)
    cbDerivedKey   : ULONG;                 // _In_
    pcbResult      : PULONG;                // _Out_
    dwFlags        : ULONG                  // _In_
    ): NTSTATUS; stdcall;


{$ifdef NTDDI_WIN8}
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptKeyDerivation(
    hKey            : BCRYPT_KEY_HANDLE;   // _In_
    pParameterList  : PBCryptBufferDesc;   // _In_opt_
    pbDerivedKey    : PUCHAR;              // _Out_writes_bytes_to_(cbDerivedKey, *pcbResult)
    cbDerivedKey    : ULONG;               // _In_
    pcbResult       : ULONG;               // _Out_
    dwFlags         : ULONG;               // _In_
    ): NTSTATUS; stdcall;
{$endif}


//
// Primitive hashing functions.
//
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptCreateHash(
    hAlgorithm       : BCRYPT_ALG_HANDLE;   // _Inout_
    //phHash          : PBCRYPT_HASH_HANDLE; // _Out_
    phHash       : PBCRYPT_HASH_HANDLE;  // _Out_
    pbHashObject     : PUCHAR;              // _Out_writes_bytes_all_opt_(cbHashObject)
    cbHashObject     : ULONG;               // _In_
    pbSecret         : PUCHAR;              // _In_reads_bytes_opt_(cbSecret); optional
    cbSecret         : ULONG;               // _In_ ; optional
    dwFlags          : ULONG                // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptHashData(
    hHash          : BCRYPT_HASH_HANDLE;  // _Inout_
    pbInput        : PUCHAR;              // _In_reads_bytes_(cbInput)
    cbInput        : ULONG;               // _In_
    dwFlags        : ULONG                // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptFinishHash(
    hHash          : BCRYPT_HASH_HANDLE;   // _Inout_
    pbOutput       : PUCHAR;               // _Out_writes_bytes_all_(cbOutput)
    cbOutput       : ULONG;                // _In_
    dwFlags        : ULONG                 // _In_
    ): NTSTATUS; stdcall;


{$ifdef NTDDI_WINBLUE}
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptCreateMultiHash(
    hAlgorithm      : BCRYPT_ALG_HANDLE;    // _Inout_
    phHash          : PBCRYPT_HASH_HANDLE;  // _Out_
    nHashes         : ULONG;                // _In_
    pbHashObject    : PUCHAR;               // _Out_writes_bytes_all_opt_(cbHashObject)
    cbHashObject    : ULONG;                // _In_
    pbSecret        : PUCHAR;               // _In_reads_bytes_opt_(cbSecret); optional
    cbSecret        : ULONG;                // _In_ ; optional
    dwFlags         : ULONG                 // _In_
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptProcessMultiOperations(
    hObject         : BCRYPT_HANDLE;        // _Inout_
    operationType   : BCRYPT_MULTI_OPERATION_TYPE;  // _In_
    pOperations     : PVOID;                // _In_reads_bytes_(cbOperations)
    cbOperations    : ULONG;                // _In_
    dwFlags         : ULONG                 // _In_
    ): NTSTATUS; stdcall;
{$endif}


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDuplicateHash(
    hHash          : BCRYPT_HASH_HANDLE;   // _In_
    phNewHash      : PBCRYPT_HASH_HANDLE;  // _Out_
    pbHashObject   : PUCHAR;               // _Out_writes_bytes_all_opt_(cbHashObject)
    cbHashObject   : ULONG;                // _In_
    dwFlags        : ULONG                 // _In_
    ): NTSTATUS; stdcall;


{
NTSTATUS
WINAPI
}
function BCryptDestroyHash(
    hHash          : BCRYPT_HASH_HANDLE    // _Inout_
    ):NTSTATUS; stdcall;


{$ifdef NTDDI_WINTHRESHOLD}
{
NTSTATUS
WINAPI
}
function BCryptHash(
    hAlgorithm      : BCRYPT_ALG_HANDLE;   // _Inout_
    pbSecret        : PUCHAR;              // _In_reads_bytes_opt_(cbSecret) ; for keyed algs
    cbSecret        : ULONG;               // _In_ ; for keyed algs
    pbInput         : PUCHAR;              // _In_reads_bytes_(cbInput)
    cbInput         : ULONG;               // _In_
    pbOutput        : PUCHAR;              // _Out_writes_bytes_all_(cbOutput)
    cbOutput        : ULONG                // _In_
    ): NTSTATUS; stdcall;
{$endif}


//
// Primitive random number generation.
//

// Flags to BCryptGenRandom
// BCRYPT_RNG_USE_ENTROPY_IN_BUFFER is ignored in Win7 & later
const
  BCRYPT_RNG_USE_ENTROPY_IN_BUFFER    = $00000001;
  BCRYPT_USE_SYSTEM_PREFERRED_RNG     = $00000002;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptGenRandom(
    hAlgorithm      : BCRYPT_ALG_HANDLE;  // _In_opt_
    pbBuffer        : PUCHAR;             // _Out_writes_bytes_(cbBuffer)
    cbBuffer        : ULONG;              // _In_
    dwFlags         : ULONG               // _In_
    ): NTSTATUS; stdcall;


//
// Primitive key derivation functions.
//
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDeriveKeyCapi(
    hHash          : BCRYPT_HASH_HANDLE;  // _In_
    hTargetAlg     : BCRYPT_ALG_HANDLE;   // _In_opt_
    pbDerivedKey   : PUCHAR;              // _Out_writes_bytes_( cbDerivedKey )
    cbDerivedKey   : ULONG;               // _In_
    dwFlags        : ULONG                // _In_
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDeriveKeyPBKDF2(
    hPrf           : BCRYPT_ALG_HANDLE;   // _In_
    pbPassword     : PUCHAR;              // _In_reads_bytes_opt_( cbPassword )
    cbPassword     : ULONG;               // _In_
    pbSalt         : PUCHAR;              // _In_reads_bytes_opt_( cbSalt )
    cbSalt         : ULONG;               // _In_
    cIterations    : ULONGLONG;           // _In_
    pbDerivedKey   : PUCHAR;              // _Out_writes_bytes_( cbDerivedKey )
    cbDerivedKey   : ULONG;               // _In_
    dwFlags        : ULONG                // _In_
    ): NTSTATUS; stdcall;


//
// Interface version control...
//
type
  PBCRYPT_INTERFACE_VERSION = ^BCRYPT_INTERFACE_VERSION;
  BCRYPT_INTERFACE_VERSION = record
    MajorVersion  :  USHORT;
    MinorVersion  :  USHORT;
  end;

function BCRYPT_MAKE_INTERFACE_VERSION(major: ULONG; minor: ULONG): BCRYPT_INTERFACE_VERSION;

function BCRYPT_IS_INTERFACE_VERSION_COMPATIBLE(loader: BCRYPT_INTERFACE_VERSION; provider: BCRYPT_INTERFACE_VERSION) : BOOL;
  // ((loader).MajorVersion <= (provider).MajorVersion)

//
// Primitive provider interfaces.
//
// TODO: set up an initialization section to define all of these.
var
  BCRYPT_CIPHER_INTERFACE_VERSION_1  : BCRYPT_INTERFACE_VERSION; //   BCRYPT_MAKE_INTERFACE_VERSION(1,0)
  BCRYPT_HASH_INTERFACE_VERSION_1    : BCRYPT_INTERFACE_VERSION; //   BCRYPT_MAKE_INTERFACE_VERSION(1,0)
  BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE_VERSION_1 : BCRYPT_INTERFACE_VERSION; //   BCRYPT_MAKE_INTERFACE_VERSION(1,0)
  BCRYPT_SECRET_AGREEMENT_INTERFACE_VERSION_1 : BCRYPT_INTERFACE_VERSION; //   BCRYPT_MAKE_INTERFACE_VERSION(1,0)
  BCRYPT_SIGNATURE_INTERFACE_VERSION_1  : BCRYPT_INTERFACE_VERSION; //  BCRYPT_MAKE_INTERFACE_VERSION(1,0)
  BCRYPT_RNG_INTERFACE_VERSION_1 : BCRYPT_INTERFACE_VERSION; //   BCRYPT_MAKE_INTERFACE_VERSION(1,0)

{$ifdef NTDDI_WINBLUE}
const
  BCRYPT_HASH_INTERFACE_MAJORVERSION_2 = 2;
var
  BCRYPT_HASH_INTERFACE_VERSION_2    : BCRYPT_INTERFACE_VERSION; //   BCRYPT_MAKE_INTERFACE_VERSION(BCRYPT_HASH_INTERFACE_MAJORVERSION_2,0)
{$endif}



//////////////////////////////////////////////////////////////////////////////
// CryptoConfig Definitions //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
const
// Interface registration flags
 CRYPT_MIN_DEPENDENCIES      = $00000001;
 CRYPT_PROCESS_ISOLATE       = $00010000; // User-mode only

// Processor modes supported by a provider
//
// (Valid for BCryptQueryProviderRegistration and BCryptResolveProviders;:
//
 CRYPT_UM                    = $00000001;    // User mode only
 CRYPT_KM                    = $00000002;    // Kernel mode only
 CRYPT_MM                    = $00000003;    // Multi-mode: Must support BOTH UM and KM
//
// (Valid only for BCryptQueryProviderRegistration;:
//
 CRYPT_ANY                   = $00000004;    // Wildcard: Either UM, or KM, or both


// Write behavior flags
 CRYPT_OVERWRITE             = $00000001;

// Configuration tables
 CRYPT_LOCAL                 = $00000001;
 CRYPT_DOMAIN                = $00000002;

// Context configuration flags
 CRYPT_EXCLUSIVE             = $00000001;
 CRYPT_OVERRIDE              = $00010000; // Enterprise table only

// Resolution and enumeration flags
 CRYPT_ALL_FUNCTIONS         = $00000001;
 CRYPT_ALL_PROVIDERS         = $00000002;

// Priority list positions
 CRYPT_PRIORITY_TOP          = $00000000;
 CRYPT_PRIORITY_BOTTOM       = $FFFFFFFF;

// Default system-wide context
 CRYPT_DEFAULT_CONTEXT       = WideString('Default');

//////////////////////////////////////////////////////////////////////////////
// CryptoConfig Structures ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//
// Provider Registration Structures
//

type
  PCRYPT_INTERFACE_REG = ^CRYPT_INTERFACE_REG;
  CRYPT_INTERFACE_REG = record
    dwInterface   : ULONG;
    dwFlags       : ULONG;

    cFunctions    : ULONG;
    rgpszFunctions: PPWSTR;
  end;
  PPCRYPT_INTERFACE_REG = ^PCRYPT_INTERFACE_REG;

  PCRYPT_IMAGE_REG = ^CRYPT_IMAGE_REG;
  CRYPT_IMAGE_REG = record
    pszImage      : PWSTR;

    cInterfaces   : LONG;
    rgpInterfaces : PPCRYPT_INTERFACE_REG;
  end;

  PCRYPT_PROVIDER_REG = ^CRYPT_PROVIDER_REG;
  CRYPT_PROVIDER_REG = record
    cAliases         : ULONG;
    rgpszAliases     : PPWSTR;

    pUM              : PCRYPT_IMAGE_REG;
    pKM              : PCRYPT_IMAGE_REG;
  end;
  PPCRYPT_PROVIDER_REG = ^PCRYPT_PROVIDER_REG;

  PCRYPT_PROVIDERS = ^CRYPT_PROVIDERS;
  CRYPT_PROVIDERS = record
    cProviders      : ULONG;
    rgpszProviders  : PPWSTR;
  end;
  PPCRYPT_PROVIDERS = ^PCRYPT_PROVIDERS;


//
// Context Configuration Structures
//

  PCRYPT_CONTEXT_CONFIG = ^CRYPT_CONTEXT_CONFIG;
  CRYPT_CONTEXT_CONFIG = record
    dwFlags    : ULONG;
    dwReserved : ULONG;
  end;
  PPCRYPT_CONTEXT_CONFIG = ^PCRYPT_CONTEXT_CONFIG;


  PCRYPT_CONTEXT_FUNCTION_CONFIG= ^CRYPT_CONTEXT_FUNCTION_CONFIG;
  CRYPT_CONTEXT_FUNCTION_CONFIG = record
    dwFlags    : ULONG;
    dwReserved : ULONG;
  end;
  PPCRYPT_CONTEXT_FUNCTION_CONFIG= ^PCRYPT_CONTEXT_FUNCTION_CONFIG;

  PCRYPT_CONTEXTS = ^CRYPT_CONTEXTS;
  CRYPT_CONTEXTS = record
    cContexts      : ULONG;
    rgpszContexts  : PPWSTR;
  end;
  PPCRYPT_CONTEXTS = ^PCRYPT_CONTEXTS;


  PCRYPT_CONTEXT_FUNCTIONS = ^CRYPT_CONTEXT_FUNCTIONS;
  CRYPT_CONTEXT_FUNCTIONS = record
    cFunctions     : ULONG;
    rgpszFunctions : PPWSTR;
  end;
  PPCRYPT_CONTEXT_FUNCTIONS = ^PCRYPT_CONTEXT_FUNCTIONS;


  PCRYPT_CONTEXT_FUNCTION_PROVIDERS = ^CRYPT_CONTEXT_FUNCTION_PROVIDERS;
  CRYPT_CONTEXT_FUNCTION_PROVIDERS = record
    cProviders     : ULONG;
    rgpszProviders : PPWSTR;
  end;
  PPCRYPT_CONTEXT_FUNCTION_PROVIDERS = ^PCRYPT_CONTEXT_FUNCTION_PROVIDERS;


//
// Provider Resolution Structures
//

  PCRYPT_PROPERTY_REF = ^CRYPT_PROPERTY_REF;
  CRYPT_PROPERTY_REF = record
    pszProperty      : PWSTR;

    cbValue          : ULONG;
    pbValue          : PUCHAR;
  end;
  PPCRYPT_PROPERTY_REF = ^PCRYPT_PROPERTY_REF;

  PCRYPT_IMAGE_REF = ^CRYPT_IMAGE_REF;
  CRYPT_IMAGE_REF = record
    pszImage      : PWSTR;
    dwFlags       : ULONG;
  end;

  PCRYPT_PROVIDER_REF = ^CRYPT_PROVIDER_REF;
  CRYPT_PROVIDER_REF = record
    dwInterface      : ULONG;
    pszFunction      : PWSTR;
    pszProvider      : PWSTR;

    cProperties      : ULONG;
    rgpProperties    : PPCRYPT_PROPERTY_REF;

    pUM              : PCRYPT_IMAGE_REF;
    pKM              : PCRYPT_IMAGE_REF;
  end;
  PPCRYPT_PROVIDER_REF = ^PCRYPT_PROVIDER_REF;

  PCRYPT_PROVIDER_REFS = ^CRYPT_PROVIDER_REFS;
  CRYPT_PROVIDER_REFS = record
    cProviders        : ULONG;
    rgpProviders      : PPCRYPT_PROVIDER_REF;
  end;
  PPCRYPT_PROVIDER_REFS = ^PCRYPT_PROVIDER_REFS;


//////////////////////////////////////////////////////////////////////////////
// CryptoConfig Functions ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////



{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptQueryProviderRegistration(
    pszProvider       : LPCWSTR;   // _In_
    dwMode            : ULONG;     // _In_
    dwInterface       : ULONG;     // _In_
    pcbBuffer         : PULONG;    // _Inout_
        //_Inout_
        //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
        //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer          : PPCRYPT_PROVIDER_REG
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEnumRegisteredProviders(
    pcbBuffer         : PULONG;    // _Inout_
        //_Inout_
        //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
        //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer          : PPCRYPT_PROVIDERS
    ): NTSTATUS; stdcall;

//
// Context Configuration Functions
//
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptCreateContext(
    dwTable          : ULONG;     // _In_
    pszContext       : LPCWSTR;   // _In_
    pConfig          : PCRYPT_CONTEXT_CONFIG // _In_opt_
    ): NTSTATUS; stdcall; // Optional

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptDeleteContext(
    dwTable          : ULONG;     // _In_
    pszContext       : LPCWSTR    // _In_
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEnumContexts(
    dwTable      : ULONG;         // _In_
    pcbBuffer    : PULONG;        // _Inout_
      //_Inout_
      //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
      //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer     : PPCRYPT_CONTEXTS
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptConfigureContext(
    dwTable      : ULONG;      // _In_
    pszContext   : LPCWSTR;    // _In_
    pConfig      : PCRYPT_CONTEXT_CONFIG // _In_
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptQueryContextConfiguration(
    dwTable      : ULONG;      // _In_
    pszContext   : LPCWSTR;    // _In_
    pcbBuffer    : PULONG;     // _Inout_
      //_Inout_
      //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
      //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer     : PPCRYPT_CONTEXT_CONFIG
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptAddContextFunction(
    dwTable     : ULONG;      // _In_
    pszContext  : LPCWSTR;    // _In_
    dwInterface : ULONG;      // _In_
    pszFunction : LPCWSTR;    // _In_
    dwPosition  : ULONG       // _In_
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptRemoveContextFunction(
    dwTable     : ULONG;      // _In_
    pszContext  : LPCWSTR;    // _In_
    dwInterface : ULONG;      // _In_
    pszFunction : LPCWSTR     // _In_
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEnumContextFunctions(
    dwTable     : ULONG;      // _In_
    pszContext  : LPCWSTR;    // _In_
    dwInterface : ULONG;      // _In_
    pcbBuffer   : PULONG;     // _Inout_
      //_Inout_
      //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
      //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer    : PPCRYPT_CONTEXT_FUNCTIONS
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptConfigureContextFunction(
    dwTable      : ULONG;       // _In_
    pszContext   : LPCWSTR;     // _In_
    dwInterface  : ULONG;       // _In_
    pszFunction  : LPCWSTR;     // _In_
    pConfig      : PCRYPT_CONTEXT_FUNCTION_CONFIG // _In_
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptQueryContextFunctionConfiguration(
    dwTable      : ULONG;        // _In_
    pszContext   : LPCWSTR;      // _In_
    dwInterface  : ULONG;        // _In_
    pszFunction  : LPCWSTR;       // _In_
    pcbBuffer    : PULONG;       // _Inout_
      //_Inout_
      //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
      //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer     : PPCRYPT_CONTEXT_FUNCTION_CONFIG
    ): NTSTATUS; stdcall;


{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptEnumContextFunctionProviders(
    dwTable      : ULONG;         // _In_
    pszContext   : LPCWSTR;       // _In_
    dwInterface  : ULONG;         // _In_
    pszFunction  : LPCWSTR;       // _In_
    pcbBuffer    : PULONG;        // _Inout_
      // _Inout_
      //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
      //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer     : PPCRYPT_CONTEXT_FUNCTION_PROVIDERS
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptSetContextFunctionProperty(
    dwTable       : ULONG;       // _In_
    pszContext    : LPCWSTR;     // _In_
    dwInterface   : ULONG;       // _In_
    pszFunction   : LPCWSTR;     // _In_
    pszProperty   : LPCWSTR;     // _In_
    cbValue       : ULONG;       // _In_
    pbValue       : PUCHAR       // _In_reads_bytes_opt_(cbValue)
    ): NTSTATUS; stdcall;

{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptQueryContextFunctionProperty(
    dwTable       : ULONG;       // _In_
    pszContext    : LPCWSTR;     // _In_
    dwInterface   : ULONG;       // _In_
    pszFunction   : LPCWSTR;     // _In_
    pszProperty   : LPCWSTR;     // _In_
    pcbValue      : PULONG;      // _Inout_
      //_Inout_
      //  _When_(_Old_(*ppbValue) != NULL, _At_(*ppbValue, _Out_writes_bytes_to_(*pcbValue, *pcbValue)))
      //  _When_(_Old_(*ppbValue) == NULL, _Outptr_result_bytebuffer_all_(*pcbValue))
    ppbValue      : PPUCHAR
    ):NTSTATUS; stdcall;


//
// Configuration Change Notification Functions
//

//
// Note: KERNEL_MODE_CNG is used when the application is calling these APIs while
//       in kernel mode.  This will not happen, but the code is left in place.
//

{$ifdef KERNEL_MODE_CNG}
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptRegisterConfigChangeNotify(
    _In_ PRKEVENT pEvent
    ): NTSTATUS; stdcall;

{$else}
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptRegisterConfigChangeNotify(
    phEvent : PHANDLE    // _Out_
    ): NTSTATUS; stdcall;

{$endif}

{$ifdef KERNEL_MODE_CNG}
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptUnregisterConfigChangeNotify(
    pEvent    : PRKEVENT;  // _In_
    ): NTSTATUS; stdcall;

{$else}
{
_Must_inspect_result_
NTSTATUS
WINAPI
}
function BCryptUnregisterConfigChangeNotify(
    hEvent   : PHANDLE   // _In_
    ): NTSTATUS; stdcall;

{$endif}

//
// Provider Resolution Functions
//
{
_Must_inspect_result_
NTSTATUS WINAPI
}
function BCryptResolveProviders(
    pszContext      : LPCWSTR;  // _In_opt_
    dwInterface     : ULONG;    // _In_opt_
    pszFunction     : LPCWSTR;  // _In_opt_
    pszProvider     : LPCWSTR;  // _In_opt_
    dwMode          : ULONG;    // _In_
    dwFlags         : ULONG;    // _In_
    pcbBuffer       : PULONG;   // _Inout_
      //_Inout_
      //  _When_(_Old_(*ppBuffer) != NULL, _At_(*ppBuffer, _Out_writes_bytes_to_(*pcbBuffer, *pcbBuffer)))
      //  _When_(_Old_(*ppBuffer) == NULL, _Outptr_result_bytebuffer_all_(*pcbBuffer))
    ppBuffer        : PPCRYPT_PROVIDER_REFS
    ): NTSTATUS; stdcall;

//
// Miscellaneous queries about the crypto environment
//
{
NTSTATUS
WINAPI
}
function BCryptGetFipsAlgorithmMode(
    pfEnabled: PBOOL  // _Out_ BOOLEAN *
    ):NTSTATUS; stdcall;

implementation

//-----------------------------------------------------------------------------
// Macro definitions
//
// These will be defined inline and we'll hope the compiler will inline 'em.
//-----------------------------------------------------------------------------

function BCRYPT_SUCCESS(Status: NTSTATUS): BOOL; inline;
begin
   result := (Status >= 0);
end;

function BCRYPT_MAKE_INTERFACE_VERSION(major: ULONG; minor: ULONG): BCRYPT_INTERFACE_VERSION; inline;
begin
  result.MajorVersion := major;
  result.MinorVersion := minor;
end;

function BCRYPT_IS_INTERFACE_VERSION_COMPATIBLE(loader: BCRYPT_INTERFACE_VERSION; provider: BCRYPT_INTERFACE_VERSION) : BOOL; inline;
begin
  result := (loader.MajorVersion <= provider.MajorVersion);
end;


//------------------------------------------------------------------------------
//  External functions
//------------------------------------------------------------------------------

function BCryptOpenAlgorithmProvider; external BCRYPTDLL name 'BCryptOpenAlgorithmProvider';
function BCryptEnumAlgorithms; external BCRYPTDLL name 'BCryptEnumAlgorithms';
function BCryptEnumProviders; external BCRYPTDLL name 'BCryptEnumProviders';
function BCryptGetProperty; external BCRYPTDLL name 'BCryptGetProperty';
function BCryptSetProperty; external BCRYPTDLL name 'BCryptSetProperty';
function BCryptCloseAlgorithmProvider; external BCRYPTDLL name 'BCryptCloseAlgorithmProvider';
procedure BCryptFreeBuffer; external BCRYPTDLL name 'BCryptFreeBuffer';
function BCryptGenerateSymmetricKey; external BCRYPTDLL name 'BCryptGenerateSymmetricKey';
function BCryptGenerateKeyPair; external BCRYPTDLL name 'BCryptGenerateKeyPair';
function BCryptEncrypt; external BCRYPTDLL name 'BCryptEncrypt';
function BCryptDecrypt; external BCRYPTDLL name 'BCryptDecrypt';
function BCryptExportKey; external BCRYPTDLL name 'BCryptExportKey';
function BCryptImportKey; external BCRYPTDLL name 'BCryptImportKey';
function BCryptImportKeyPair; external BCRYPTDLL name 'BCryptImportKeyPair';
function BCryptDuplicateKey; external BCRYPTDLL name 'BCryptDuplicateKey';
function BCryptFinalizeKeyPair; external BCRYPTDLL name 'BCryptFinalizeKeyPair';
function BCryptDestroyKey; external BCRYPTDLL name 'BCryptDestroyKey';
function BCryptDestroySecret; external BCRYPTDLL name 'BCryptDestroySecret';
function BCryptSignHash; external BCRYPTDLL name 'BCryptSignHash';
function BCryptVerifySignature; external BCRYPTDLL name 'BCryptVerifySignature';
function BCryptSecretAgreement; external BCRYPTDLL name 'BCryptSecretAgreement';
function BCryptDeriveKey; external BCRYPTDLL name 'BCryptDeriveKey';
{$ifdef NTDDI_WIN8}
function BCryptKeyDerivation; external BCRYPTDLL name 'BCryptKeyDerivation';
{$endif}
function BCryptCreateHash; external BCRYPTDLL name 'BCryptCreateHash';
function BCryptHashData; external BCRYPTDLL name 'BCryptHashData';
function BCryptFinishHash; external BCRYPTDLL name 'BCryptFinishHash';
{$ifdef NTDDI_WINBLUE}
function BCryptCreateMultiHash; external BCRYPTDLL name 'BCryptCreateMultiHash';
function BCryptProcessMultiOperations; external BCRYPTDLL name 'BCryptProcessMultiOperations';
{$endif}
function BCryptDuplicateHash; external BCRYPTDLL name 'BCryptDuplicateHash';
function BCryptDestroyHash; external BCRYPTDLL name 'BCryptDestroyHash';
{$ifdef NTDDI_WINTHRESHOLD}
function BCryptHash; external BCRYPTDLL name 'BCryptHash';
{$endif}
function BCryptGenRandom; external BCRYPTDLL name 'BCryptGenRandom';
function BCryptDeriveKeyCapi; external BCRYPTDLL name 'BCryptDeriveKeyCapi';
function BCryptDeriveKeyPBKDF2; external BCRYPTDLL name 'BCryptDeriveKeyPBKDF2';
function BCryptQueryProviderRegistration; external BCRYPTDLL name 'BCryptQueryProviderRegistration';
function BCryptEnumRegisteredProviders; external BCRYPTDLL name 'BCryptEnumRegisteredProviders';
function BCryptCreateContext; external BCRYPTDLL name 'BCryptCreateContext';
function BCryptDeleteContext; external BCRYPTDLL name 'BCryptDeleteContext';
function BCryptEnumContexts; external BCRYPTDLL name 'BCryptEnumContexts';
function BCryptConfigureContext; external BCRYPTDLL name 'BCryptConfigureContext';
function BCryptQueryContextConfiguration; external BCRYPTDLL name 'BCryptQueryContextConfiguration';
function BCryptAddContextFunction; external BCRYPTDLL name 'BCryptAddContextFunction';
function BCryptRemoveContextFunction; external BCRYPTDLL name 'BCryptRemoveContextFunction';
function BCryptEnumContextFunctions; external BCRYPTDLL name 'BCryptEnumContextFunctions';
function BCryptConfigureContextFunction; external BCRYPTDLL name 'BCryptConfigureContextFunction';
function BCryptQueryContextFunctionConfiguration; external BCRYPTDLL name 'BCryptQueryContextFunctionConfiguration';
function BCryptEnumContextFunctionProviders; external BCRYPTDLL name 'BCryptEnumContextFunctionProviders';
function BCryptSetContextFunctionProperty; external BCRYPTDLL name 'BCryptSetContextFunctionProperty';
function BCryptQueryContextFunctionProperty; external BCRYPTDLL name 'BCryptQueryContextFunctionProperty';
function BCryptRegisterConfigChangeNotify; external BCRYPTDLL name 'BCryptRegisterConfigChangeNotify';
function BCryptUnregisterConfigChangeNotify; external BCRYPTDLL name 'BCryptUnregisterConfigChangeNotify';
function BCryptResolveProviders; external BCRYPTDLL name 'BCryptResolveProviders';
function BCryptGetFipsAlgorithmMode; external BCRYPTDLL name 'BCryptGetFipsAlgorithmMode';

end.
