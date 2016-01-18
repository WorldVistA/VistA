unit oPKIEncryptionEx;

// Management Interfaces

interface

uses
  oPKIEncryption;

type
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
