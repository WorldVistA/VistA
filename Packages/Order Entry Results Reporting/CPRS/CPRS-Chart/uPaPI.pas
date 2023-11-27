unit uPaPI;

/// /////////////////////////////////////////////////////////////////////////////
///
/// Project:    PaPI
/// Date:       2012-08-16
/// Comments:
/// Parking a Prescription Initiative (PaPI) support
///
/// /////////////////////////////////////////////////////////////////////////////

interface

uses
  ORFn,
  ORNet,
  UCore,
  ROrders;

function PapiMedOrderStatusHint(AStatus: string): string;

function PapiParkingAvailable: Boolean;
function PapiDrugIsParkable(ADrugID: string): Boolean;
function PapiOrderIsParkable(AOrderID: string): Boolean;

function GetOptionValue(AnOption: string): string;

implementation

uses
  System.JSON,
  SysUtils,
  VAUtils;

const
  papiActive =
    'Active - A prescription with this status is part of the patient''s ' + CRLF +
      'current expected medication regimen, and if refills remain, it' + CRLF +
      'can be filled or refilled upon request.';
  papiActiveSusp =
    'Active/Suspended - A prescription with this status is part of the' + CRLF +
      'patient''s current expected medication regimen and a request has' + CRLF +
      'been placed to be filled at a future date.';
  papiActivePark =
    'Active/Parked - A prescription that is on file but will not be ' + CRLF +
    'dispensed until requested by the patient/caregiver';
  papiPending =
    'Pending - A prescription with this status is an order that has been' + CRLF +
      'entered through CPRS.  It has been signed by the provider but is' + CRLF +
      'awaiting pharmacy review.  It cannot be filled until after the' + CRLF +
      'pharmacy review is completed.';
  papiNonVerified =
    'Non-verified - A prescription with this status has been either' + CRLF +
      'entered in CPRS by a provider or in pharmacy by a technician.' + CRLF +
      'It cannot be filled until a pharmacist has completed a review.';
  papiExpired =
    'Expired - A prescription with this status indicates the expiration' + CRLF +
      'date has passed and the prescription is no longer active.' + CRLF +
      'A prescription may be renewed up to 120 days after expiration.';
  papiHold =
    'Hold - A prescription that was placed on hold due to reasons' + CRLF +
      'determined by the physician/pharmacist.  This prescription' + CRLF +
      'cannot be filled until the hold is resolved.';
  papiDiscontinued =
    'Discontinued - A prescription with this status has been made' + CRLF +
      'inactive either by a new (replacement) prescription or by the' + CRLF +
      'request of a physician.';
  papiDiscontinuedEdit =
    'Discontinued (Edit) - A prescription with this status indicates' + CRLF +
      'a medication order has been edited by either a physician or' + CRLF +
      'pharmacist creating a new order.';
  papiUnreleased =
    'Unreleased – An order that has been created in the system but ' + CRLF +
      'has not been sent to the ancillary service to be addressed.';
  papiCanceled =
    'Canceled – An order that was discontinued before it was shared' + CRLF +
      'with an ancillary service.';
  papiRenewed =
  // 'Renewed - An order that has been renewed;' + CRLF +
  // 'it is still active until expired or is completed.';
    'Renewed- An order that has been updated;' + CRLF +
    'a more current version of the order exists.';

//  papiTX_UnderConstruction = 'Coming soon.';
//  papiTC_UnderConstruction = 'Under construction.';

  papiKeywords =
    'ACTIVE^ACTIVE/SUSP^ACTIVE/PARKED^PENDING^NON-VERIFIED^EXPIRED^HOLD^' +
    'DISCONTINUED^DISCONTINUED (EDIT)^DC/EDIT^UNRELEASED^CANCELLED^RENEWED';

function papiMedOrderStatusHint(aStatus: String): String;
var
  idx:integer;
  sts, UStatus: string;
begin
  Result := '';
  idx := 1;
  UStatus := UpperCase(aStatus);
  repeat
    sts := piece(papiKeywords, U, idx);
    if sts = UStatus then
    begin
      case idx of
        1: Result := papiActive;
        2: Result := papiActiveSusp;
        3: Result := papiActivePark;
        4: Result := papiPending;
        5: Result := papiNonVerified;
        6: Result := papiExpired;
        7: Result := papiHold;
        8: Result := papiDiscontinued;
        9,10: Result := papiDiscontinuedEdit;
        11: Result := papiUnreleased;
        12: Result := papiCanceled;
        13: Result := papiRenewed;
      end;
      exit;
    end
    else inc(idx);
  until sts='';
end;

function PapiParkingAvailable: Boolean;
// use SystemParameters;
begin
  Result := SystemParameters.AsType<boolean>('psoParkOn');
end;

function GetOptionValue(AnOption: string): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  for I := 1 to ParamCount do
  // params may be: S[ERVER]=hostname P[ORT]=port DEBUG
  begin
    S := ParamStr(I);
    if Pos(UpperCase(AnOption), UpperCase(S)) = 1 then
    begin
      Result := Piece(S, '=', 2);
      Break;
    end;
  end;
end;

function papiDrugIsParkable(ADrugID: String): Boolean;
var
  S: string;
begin
  Result := CallVistA('PSORPC', ['PARKDRG', ADrugID], S) and
    (Copy(S, 1, 1) = '1');
end;

function papiOrderIsParkable(AOrderID: string): Boolean;
var
  S: string;
begin
  Result := CallVistA('PSORPC', ['PARKORD', AOrderID], S) and
    (Copy(S, 1, 1) = '1');
end;

end.
