unit uCombatVet;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TCombatVet = class(TObject)
  private
    FServiceBranch: string;
    FOIF_OEF: string;
    FExpirationDate: string;
    FStatus: string;
    FSeperationDate: string;
    FDFN: string;
    FIsEligible: boolean;
  protected
    procedure ClearProperties;
    procedure UpdateData;
  public
    constructor Create(DFN: string);
    destructor Destroy; override;

    property ServiceBranch: string read FServiceBranch;
    property Status: string read FStatus;
    property ServiceSeparationDate: string read FSeperationDate;
    property ExpirationDate: string read FExpirationDate;
    property OEF_OIF: string read FOIF_OEF;
    property IsEligible: boolean read FIsEligible;
  end;

implementation

uses
  ORNet,
  ORFn;

{ TCombatVet }

constructor TCombatVet.Create(DFN: string);
begin
  inherited Create;
  FDFN := DFN;
  UpdateData;
end;

destructor TCombatVet.Destroy;
begin
  inherited;
end;

procedure TCombatVet.ClearProperties;
begin
  FServiceBranch := '';
  FStatus := '';
  FSeperationDate := '';
  FExpirationDate := '';
  FOIF_OEF := '';
end;

procedure TCombatVet.UpdateData;
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVista('OR GET COMBAT VET', [FDFN], aLst);
    FIsEligible := (aLst.Count > 4) and (aLst[0] <> 'NOTCV');
    ClearProperties;
    if FIsEligible then
    begin
      FServiceBranch := Piece(aLst[0], U, 2);
      FStatus := Piece(aLst[1], U, 2);
      FSeperationDate := Piece(aLst[2], U, 2);
      FExpirationDate := Piece(aLst[3], U, 2);
      FOIF_OEF := aLst[4];
    end;
  finally
    FreeAndNil(aLst);
  end;
end;

end.
