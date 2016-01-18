unit oPKIEncryptionData;

interface

uses
  System.SysUtils,
  System.StrUtils,
  oPKIEncryption,
  oPKIEncryptionEx;

type
  TPKIEncryptionData = class(TInterfacedObject, IPKIEncryptionData, IPKIEncryptionDataEx)
  protected
    fBuffer: string;
    fSignature: string;
    fSignatureID: string;
    fCrlURL: string;
    fHashValue: AnsiString;
    fHashText: AnsiString;
    fHashHex: AnsiString;
    fDateTimeSigned: TDateTime;

    function getBuffer: string; virtual;
    function getSignature: string; virtual; final;
    function getSignatureID: string; virtual; final;
    function getCrlURL: string; virtual; final;
    function getHashValue: AnsiString; virtual; final;
    function getHashHex: string; virtual; final;
    function getHashText: string; virtual; final;
    function getDateTimeSigned: TDateTime; virtual; final;
    function getFMDateTimeSigned: string; virtual; final;

    procedure setBuffer(const aValue: string); virtual;
    procedure setSignature(const aValue: string); virtual; final;
    procedure setSignatureID(const aValue: string); virtual; final;
    procedure setCrlURL(const aValue: string); virtual; final;
    procedure setHashHex(const aValue: AnsiString); virtual; final;
    procedure setHashText(const aValue: AnsiString); virtual; final;
    procedure setHashValue(const aValue: AnsiString); virtual; final;
    procedure setDateTimeSigned(const aValue: TDateTime); virtual; final;
  protected
    procedure AppendToBuffer(aStrings: array of string); virtual; final;
    procedure Clear; virtual;
    procedure Validate; virtual;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPKIEncryptionData }

constructor TPKIEncryptionData.Create;
begin
  inherited;
  Clear;
end;

destructor TPKIEncryptionData.Destroy;
begin
  inherited;
end;

function TPKIEncryptionData.getBuffer: string;
begin
  Result := fBuffer;
end;

function TPKIEncryptionData.getCrlURL: string;
begin
  Result := fCrlURL;
end;

function TPKIEncryptionData.getDateTimeSigned: TDateTime;
begin
  Result := fDateTimeSigned;
end;

function TPKIEncryptionData.getFMDateTimeSigned: string;
begin
  TDateTime2FMDateTime(fDateTimeSigned, Result, True, True);
end;

function TPKIEncryptionData.getHashHex: string;
begin
  Result := String(fHashHex);
end;

function TPKIEncryptionData.getHashText: string;
begin
  Result := String(fHashText);
end;

function TPKIEncryptionData.getHashValue: AnsiString;
begin
  Result := fHashValue;
end;

function TPKIEncryptionData.getSignature: string;
begin
  Result := fSignature;
end;

function TPKIEncryptionData.getSignatureID: string;
begin
  Result := fSignatureID;
end;

procedure TPKIEncryptionData.setBuffer(const aValue: string);
begin
  fBuffer := aValue;
end;

procedure TPKIEncryptionData.setCrlURL(const aValue: string);
begin
  fCrlURL := aValue;
end;

procedure TPKIEncryptionData.setDateTimeSigned(const aValue: TDateTime);
begin
  fDateTimeSigned := aValue;
end;

procedure TPKIEncryptionData.setHashHex(const aValue: AnsiString);
begin
  fHashHex := aValue;
end;

procedure TPKIEncryptionData.setHashText(const aValue: AnsiString);
begin
  fHashText := aValue;
end;

procedure TPKIEncryptionData.setHashValue(const aValue: AnsiString);
begin
  fHashValue := aValue;
end;

procedure TPKIEncryptionData.setSignature(const aValue: string);
begin
  fSignature := aValue;
end;

procedure TPKIEncryptionData.setSignatureID(const aValue: string);
begin
  fSignatureID := aValue;
end;

procedure TPKIEncryptionData.AppendToBuffer(aStrings: array of string);
var
  i: integer;
begin
  for i := Low(aStrings) to High(aStrings) do
    fBuffer := fBuffer + aStrings[i];
end;

procedure TPKIEncryptionData.Clear;
var
  aGUID: TGUID;
  aGUIDStr: string;
begin
  fBuffer := '';
  fSignature := '';
  fSignatureID := '';
  fCrlURL := '';
  fHashValue := '';
  fHashText := '';
  fHashHex := '';
  fDateTimeSigned := 0;

  // assign a new ID on each call
  CreateGUID(aGUID);
  aGUIDStr := LowerCase(GUIDToString(aGUID));
  aGUIDStr := AnsiReplaceStr(aGUIDStr, '{', '');
  aGUIDStr := AnsiReplaceStr(aGUIDStr, '}', '');
  aGUIDStr := AnsiReplaceStr(aGUIDStr, '-', '');
  fSignatureID := aGUIDStr;
end;

procedure TPKIEncryptionData.Validate;
begin
  // Handled via override methods when needed
end;

end.
