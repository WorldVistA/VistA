unit uCombatVet;

interface

type
  TCombatVet = Class(TObject)
  private
    FServiceBranch: String;
    FOIF_OEF: String;
    FExpirationDate: String;
    FEligibilityDate: String;
    FStatus: String;
    FSeperationDate: String;
    FDFN : String;
    FLocation: String;
    FIsEligible: Boolean;
    procedure ClearProperties;
  public
    procedure UpdateData;
    constructor Create(DFN : String);
    property ServiceBranch : String read FServiceBranch write FServiceBranch;
    property Status : String read FStatus write FStatus;
    property ServiceSeparationDate : String read FSeperationDate write FSeperationDate;
    property EligibilityDate : String read FEligibilityDate write FEligibilityDate;
    property ExpirationDate : String read FExpirationDate write FExpirationDate;
    property OEF_OIF : String read FOIF_OEF write FOIF_OEF;
    property Location : String read FLocation write FLocation;
    property IsEligible : Boolean read FIsEligible write FIsEligible;
  End;

implementation

uses ORNet, VAUtils, ORFn;

{ TCombatVet }

procedure TCombatVet.ClearProperties;
begin
  FServiceBranch := '';
  FStatus := '';
  FSeperationDate := '';
  FExpirationDate := '';
  FOIF_OEF := '';
end;

constructor TCombatVet.Create(DFN: String);
begin
  FDFN := DFN;
  UpdateData;
end;

procedure TCombatVet.UpdateData;
begin
  sCallV('OR GET COMBAT VET',[FDFN]);
  FIsEligible := True;
  if RPCBrokerV.Results[0] = 'NOTCV' then begin
    FIsEligible := False;
    ClearProperties;
    Exit;
  end;
  FServiceBranch := Piece(RPCBrokerV.Results[0],U,2);
  FStatus := Piece(RPCBrokerV.Results[1],U,2);
  FSeperationDate := Piece(RPCBrokerV.Results[2],U,2);
  FExpirationDate := Piece(RPCBrokerV.Results[3],U,2);
  FOIF_OEF := RPCBrokerV.Results[4];
end;

end.
