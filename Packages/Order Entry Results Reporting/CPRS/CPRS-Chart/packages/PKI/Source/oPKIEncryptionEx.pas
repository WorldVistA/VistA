unit oPKIEncryptionEx;

// Management Interfaces

interface

uses
  System.Classes,
  oPKIEncryption;

type
  IPKIByteArrayEx = interface(IInterface)
    ['{3E8011F5-C15A-4A5C-BB2E-944DC129A8AE}']
    function getArrayLength: integer;
    function getAsAnsiString: AnsiString;
    function getAsHex: string;
    function getAsMime: string;
    function getAsString: string;

    function getPByte: PByte;

    procedure setArrayLength(const aValue: integer);
    procedure setAsAnsiString(const aValue: AnsiString);
    procedure setAsHex(const aValue: string);
    procedure setAsMime(const aValue: string);
    procedure setAsString(const aValue: string);

    procedure Clear;
    procedure GetArrayValues(aList: TStrings);
  end;

  IPKIEncryptionDataEx = interface(IInterface)
    ['{BADDD8E7-C5B3-49D7-9265-7A870F588322}']
    function getHashValue: AnsiString;

    procedure setHashValue(const aValue: AnsiString);
    procedure setHashText(const aValue: AnsiString);
    procedure setHashHex(const aValue: AnsiString);
    procedure setDateTimeSigned(const aValue: TDateTime);
    procedure setCrlURL(const aValue: string);
    procedure setSignature(const aValue: string);
    procedure setSignatureID(const aValue: string);
  end;

  IPKIEncryptionEngineEx = interface(IPKIEncryptionEngine)
    ['{1E5334D1-2890-40D2-9F1C-7C10F2CF5179}']
    function getIsValidPIN(const aPKIPIN: string; var aMessage: string): boolean;

    procedure setVistASAN(aNewSAN: string);
  end;

implementation

end.
