unit oPKIEncryptionDataDEAOrder;

interface

uses
  System.Classes,
  oPKIEncryption,
  oPKIEncryptionData,
  TRPCB;

type
  TPKIEncryptionDataDEAOrder = class(TPKIEncryptionData, IPKIEncryptionDataDEAOrder)
  private
    fIsDEASig: boolean;
    fIssuanceDate: string;
    fPatientName: string;
    fPatientAddress: string;
    fDrugName: string;
    fQuantity: string;
    fDirections: string;
    fDetoxNumber: string;
    fProviderName: string;
    fProviderAddress: string;
    fDEANumber: string;
    fOrderNumber: string;

    function getDEANumber: string;
    function getDetoxNumber: string;
    function getDirections: string;
    function getDrugName: string;
    function getIsDEASig: boolean;
    function getIssuanceDate: string;
    function getOrderNumber: string;
    function getPatientAddress: string;
    function getPatientName: string;
    function getProviderAddress: string;
    function getProviderName: string;
    function getQuantity: string;

    procedure setDEANumber(const aValue: string);
    procedure setDetoxNumber(const aValue: string);
    procedure setDirections(const aValue: string);
    procedure setDrugName(const aValue: string);
    procedure setIsDEASig(const aValue: boolean);
    procedure setIssuanceDate(const aValue: string);
    procedure setOrderNumber(const aValue: string);
    procedure setPatientAddress(const aValue: string);
    procedure setPatientName(const aValue: string);
    procedure setProviderAddress(const aValue: string);
    procedure setProviderName(const aValue: string);
    procedure setQuantity(const aValue: string);
  protected
    function getBuffer: string; override;
    procedure setBuffer(const aValue: string); override; final;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; override;
    procedure Validate; override;

    procedure LoadFromVistA(aRPCBroker: TRPCBroker; aPatientDFN, aUserDUZ, aCPRSOrderNumber: string);
  end;

implementation

uses
  MFunStr, uLockBroker;

{ TPKIEncryptionDataDEAOrder }

constructor TPKIEncryptionDataDEAOrder.Create;
begin
  inherited Create;
end;

destructor TPKIEncryptionDataDEAOrder.Destroy;
begin
  inherited;
end;

function TPKIEncryptionDataDEAOrder.getBuffer: string;
begin
  Result := fDEANumber + // 10
  // fDetoxNumber + // 7
    fDirections + // 6
    fDrugName + // 4
    fIssuanceDate + // 1
    fOrderNumber + //
    fPatientAddress + // 3
    fPatientName + // 2
    fProviderAddress + // 9
    fProviderName + // 8
    fQuantity; // 5
end;

procedure TPKIEncryptionDataDEAOrder.setBuffer(const aValue: string);
begin
  raise EPKIEncryptionError.Create(DLG_89802039);
end;

procedure TPKIEncryptionDataDEAOrder.Clear;
begin
  inherited;
  fIsDEASig := false;
  fIssuanceDate := '';
  fPatientName := '';
  fPatientAddress := '';
  fDrugName := '';
  fQuantity := '';
  fDirections := '';
  fDetoxNumber := '';
  fProviderName := '';
  fProviderAddress := '';
  fDEANumber := '';
  fOrderNumber := '';
end;

procedure TPKIEncryptionDataDEAOrder.Validate;
begin
  inherited;
  if getBuffer = '' then
    raise EPKIEncryptionError.Create(DLG_89802000);

  if not fIsDEASig then
    raise EPKIEncryptionError.Create(DLG_89802038);

  if fDEANumber = '' then
    raise EPKIEncryptionError.Create(DLG_89802001);
end;

procedure TPKIEncryptionDataDEAOrder.LoadFromVistA(aRPCBroker: TRPCBroker; aPatientDFN, aUserDUZ, aCPRSOrderNumber: string);
var
  aResults: TStringList;
begin
  try
    Clear;
    aResults := TStringList.Create;
    try
      LockBroker;
      try
        aRPCBroker.RemoteProcedure := 'ORDEA HASHINFO';
        aRPCBroker.Param[0].value := aPatientDFN;
        aRPCBroker.Param[0].PType := literal;
        aRPCBroker.Param[1].value := aUserDUZ;
        aRPCBroker.Param[1].PType := literal;
        aRPCBroker.lstCall(aResults);
      finally
        UnlockBroker;
      end;

      while aResults.Count > 0 do
      begin
        if Piece(aResults[0], ':', 1) = 'IssuanceDate' then
          fIssuanceDate := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'PatientName' then
          fPatientName := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'PatientAddress' then
          fPatientAddress := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'DetoxNumber' then
          fDetoxNumber := ''
        else if Piece(aResults[0], ':', 1) = 'ProviderName' then
          fProviderName := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'ProviderAddress' then
          fProviderAddress := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'DeaNumber' then
          fDEANumber := Piece(aResults[0], ':', 2, 30);
        aResults.Delete(0);
      end;

      LockBroker;
      try
        aRPCBroker.RemoteProcedure := 'ORDEA ORDHINFO';
        aRPCBroker.Param[0].value := aCPRSOrderNumber;
        aRPCBroker.Param[0].PType := literal;
        aRPCBroker.lstCall(aResults);
      finally
        UnlockBroker;
      end;

      while aResults.Count > 0 do
      begin
        if Piece(aResults[0], ':', 1) = 'DrugName' then
          fDrugName := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'Quantity' then
          fQuantity := Piece(aResults[0], ':', 2, 30)
        else if Piece(aResults[0], ':', 1) = 'Directions' then
          fDirections := Piece(aResults[0], ':', 2, 30);
        aResults.Delete(0);
      end;

      // Last but not least :)
      fIsDEASig := True;
      fOrderNumber := aCPRSOrderNumber;
    finally
      aResults.Free;
    end;
  except
    raise EPKIEncryptionError.Create('Error loading DEA Order Components from VistA');
  end;
end;

{ Generic Property Getters and Setters }

function TPKIEncryptionDataDEAOrder.getDEANumber: string;
begin
  Result := fDEANumber;
end;

function TPKIEncryptionDataDEAOrder.getDetoxNumber: string;
begin
  Result := fDetoxNumber;
end;

function TPKIEncryptionDataDEAOrder.getDirections: string;
begin
  Result := fDirections;
end;

function TPKIEncryptionDataDEAOrder.getDrugName: string;
begin
  Result := fDrugName;
end;

function TPKIEncryptionDataDEAOrder.getIsDEASig: boolean;
begin
  Result := fIsDEASig;
end;

function TPKIEncryptionDataDEAOrder.getIssuanceDate: string;
begin
  Result := fIssuanceDate;
end;

function TPKIEncryptionDataDEAOrder.getOrderNumber: string;
begin
  Result := fOrderNumber;
end;

function TPKIEncryptionDataDEAOrder.getPatientAddress: string;
begin
  Result := fPatientAddress;
end;

function TPKIEncryptionDataDEAOrder.getPatientName: string;
begin
  Result := fPatientName;
end;

function TPKIEncryptionDataDEAOrder.getProviderAddress: string;
begin
  Result := fProviderAddress;
end;

function TPKIEncryptionDataDEAOrder.getProviderName: string;
begin
  Result := fProviderName;
end;

function TPKIEncryptionDataDEAOrder.getQuantity: string;
begin
  Result := fQuantity;
end;

procedure TPKIEncryptionDataDEAOrder.setDEANumber(const aValue: string);
begin
  fDEANumber := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setDetoxNumber(const aValue: string);
begin
  fDetoxNumber := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setDirections(const aValue: string);
begin
  fDirections := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setDrugName(const aValue: string);
begin
  fDrugName := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setIsDEASig(const aValue: boolean);
begin
  fIsDEASig := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setIssuanceDate(const aValue: string);
begin
  fIssuanceDate := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setOrderNumber(const aValue: string);
begin
  fOrderNumber := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setPatientAddress(const aValue: string);
begin
  fPatientAddress := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setPatientName(const aValue: string);
begin
  fPatientName := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setProviderAddress(const aValue: string);
begin
  fProviderAddress := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setProviderName(const aValue: string);
begin
  fProviderName := aValue;
end;

procedure TPKIEncryptionDataDEAOrder.setQuantity(const aValue: string);
begin
  fQuantity := aValue;
end;

end.
