unit oPKIEncryptionSignature;

interface

uses
  System.Classes,
  oPKIEncryption;

type
  TPKIEncryptionSignature = class(TInterfacedObject, IPKIEncryptionSignature)
  private
    fHashText: string;
    fDateTimeSigned: string;
    fSignature: string;

    function getHashText: string; virtual; final;
    function getDateTimeSigned: string; virtual; final;
    function getSignature: string; virtual;

    procedure setHashText(const aValue: string); virtual; final;
    procedure setDateTimeSigned(const aValue: string); virtual; final;
    procedure setSignature(const aValue: string); virtual; final;
  protected
    procedure LoadSignature(const aValue: TStringList); virtual; final;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPKIEncryptionSignature }

constructor TPKIEncryptionSignature.Create;
begin
  inherited;
end;

destructor TPKIEncryptionSignature.Destroy;
begin

  inherited;
end;

function TPKIEncryptionSignature.getDateTimeSigned: string;
begin
  Result := fDateTimeSigned;
end;

function TPKIEncryptionSignature.getHashText: string;
begin
  Result := fHashText;
end;

function TPKIEncryptionSignature.getSignature: string;
begin
  Result := fSignature;
end;

procedure TPKIEncryptionSignature.LoadSignature(const aValue: TStringList);
begin
  fSignature := '';
  with aValue.GetEnumerator do
    while MoveNext do
      fSignature := fSignature + Current;
end;

procedure TPKIEncryptionSignature.setDateTimeSigned(const aValue: string);
begin
  fDateTimeSigned := aValue;
end;

procedure TPKIEncryptionSignature.setHashText(const aValue: string);
begin
  fHashText := aValue;
end;

procedure TPKIEncryptionSignature.setSignature(const aValue: string);
begin
  fSignature := aValue;
end;

end.
