unit oCoverSheetParam_CPRS;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TCoverSheetParam this parameter holds
  *                     custom items for displaying CPRS data in the CoverSheet.
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  oCoverSheetParam,
  iCoverSheetIntf;

type
  TCoverSheetParam_CPRS = class(TCoverSheetParam, ICoverSheetParam_CPRS)
  private
    fLoadInBackground: boolean;
    fDateFormat: string;
    fDatePiece: integer;
    fDetailRPC: string;
    fInvert: boolean;
    fMainRPC: string;
    fParam1: string;
    fStatus: string;
    fTitleCase: boolean;
    fPollingID: string;
    fHighlightText: boolean;
    fAllowDetailPrint: boolean;
    fOnNewPatient: TNotifyEvent;

    procedure fOnNewPatientDefault(Sender: TObject);
  protected
    function getLoadInBackground: boolean; virtual;
    function getDateFormat: string; virtual;
    function getDatePiece: integer; virtual;
    function getDetailRPC: string; virtual;
    function getInvert: boolean; virtual;
    function getMainRPC: string; virtual;
    function getParam1: string; virtual;
    function getStatus: string; virtual;
    function getTitleCase: boolean; virtual;
    function getPollingID: string; virtual;
    function getHighlightText: boolean; virtual;
    function getAllowDetailPrint: boolean; virtual;
    function getIsApplicable: boolean; virtual;
    function getOnNewPatient: TNotifyEvent;

    procedure setLoadInBackground(const aValue: boolean);
    procedure setAllowDetailPrint(const aValue: boolean);
    procedure setInvert(const aValue: boolean);
    procedure setParam1(const aValue: string);
    procedure setOnNewPatient(const aValue: TNotifyEvent);

    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    constructor Create(aInitString: string);
    destructor Destroy; override;
  end;

implementation

uses
  oDelimitedString,
  mCoverSheetDisplayPanel_CPRS;

{ TCoverSheetParam_CPRS }

constructor TCoverSheetParam_CPRS.Create(aInitString: string);
begin
  inherited Create;

  fOnNewPatient := fOnNewPatientDefault;

  with NewDelimitedString(aInitString) do
    try
      fID := GetPieceAsInteger(1);
      fTitle := GetPiece(2);
      fStatus := GetPiece(3);
      fMainRPC := GetPiece(6);
      fInvert := GetPieceAsBoolean(8, False);
      fDateFormat := GetPiece(10);
      fDatePiece := GetPieceAsInteger(11, 0);
      fParam1 := GetPiece(12);
      fDetailRPC := GetPiece(16);
      fTitleCase := GetPieceAsBoolean(7);
      fHighlightText := GetPieceIsNotNull(9);
      fAllowDetailPrint := True;
      fPollingID := GetPiece(19);
    finally
      Free;
    end;

  {
    Example of aInitString from VistA

    ZZZ(1)="10^Active Problems^^S^^ORQQPL LIST^1^^^^^A^^2,3^9,10,2^ORQQPL DETAIL^1^28^PROB"
    ZZZ(2)="20^Allergies / Adverse Reactions^^S^^ORQQAL LIST^1^^^^^^^^2^ORQQAL DETAIL^2^29^"
    ZZZ(3)="30^Postings^^S^^ORQQPP LIST^1^^Maroon^D^3^^^20^2,3^^3^30^CWAD"
    ZZZ(4)="40^Active Medications^^S^^ORWPS COVER^1^1^^^^1^^35^2,4^ORWPS DETAIL^4^31^MEDS"
    ZZZ(5)="50^Clinical Reminders                                        Due Date^^S^^ORQQPX REMINDERS LIST^^^^D^3^^^34,44^2,3^^5^32^RMND"
    ZZZ(6)="99^Women's Health^^S^^WVRPCOR COVER^1^^^^^^^20^2,3^WVRPCOR DETAIL^6^1606^WHPNL"
    ZZZ(7)="60^Recent Lab Results^^S^^ORWCV LAB^1^^^D^3^^^34^2,3^ORWOR RESULT^7^33^LABS"
    ZZZ(8)="70^Vitals^^S^^ORQQVI VITALS^^^^T^4^^^5,17,19,27^2,5,4,6,7,8^^8^34^VITL"
    ZZZ(9)="80^Appointments/Visits/Admissions^^S^^ORWCV VST^1^1^^T^2^^^16,27^2,3,4^ORWCV DTLVST^9^35^VSIT"

  }
end;

destructor TCoverSheetParam_CPRS.Destroy;
begin
  fOnNewPatient := fOnNewPatientDefault;

  inherited;
end;

procedure TCoverSheetParam_CPRS.fOnNewPatientDefault(Sender: TObject);
begin
  // Prevent nil pointers
end;

function TCoverSheetParam_CPRS.getLoadInBackground: boolean;
begin
  Result := fLoadInBackground;
end;

function TCoverSheetParam_CPRS.getAllowDetailPrint: boolean;
begin
  Result := fAllowDetailPrint;
end;

function TCoverSheetParam_CPRS.getDateFormat: string;
begin
  Result := fDateFormat;
end;

function TCoverSheetParam_CPRS.getDatePiece: integer;
begin
  Result := fDatePiece;
end;

function TCoverSheetParam_CPRS.getDetailRPC: string;
begin
  Result := fDetailRPC;
end;

function TCoverSheetParam_CPRS.getHighlightText: boolean;
begin
  Result := fHighlightText;
end;

function TCoverSheetParam_CPRS.getInvert: boolean;
begin
  Result := fInvert;
end;

function TCoverSheetParam_CPRS.getMainRPC: string;
begin
  Result := fMainRPC;
end;

function TCoverSheetParam_CPRS.getOnNewPatient: TNotifyEvent;
begin
  Result := fOnNewPatient;
end;

function TCoverSheetParam_CPRS.getParam1: string;
begin
  Result := fParam1;
end;

function TCoverSheetParam_CPRS.getPollingID: string;
begin
  Result := fPollingID;
end;

function TCoverSheetParam_CPRS.getStatus: string;
begin
  Result := fStatus;
end;

function TCoverSheetParam_CPRS.getTitleCase: boolean;
begin
  Result := fTitleCase;
end;

function TCoverSheetParam_CPRS.getIsApplicable: boolean;
begin
  Result := True;
end;

function TCoverSheetParam_CPRS.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS.Create(aOwner);
end;

procedure TCoverSheetParam_CPRS.setAllowDetailPrint(const aValue: boolean);
begin
  fAllowDetailPrint := aValue;
end;

procedure TCoverSheetParam_CPRS.setInvert(const aValue: boolean);
begin
  fInvert := aValue;
end;

procedure TCoverSheetParam_CPRS.setLoadInBackground(const aValue: boolean);
begin
  fLoadInBackground := aValue;
end;

procedure TCoverSheetParam_CPRS.setOnNewPatient(const aValue: TNotifyEvent);
begin
  if Assigned(aValue) then
    fOnNewPatient := aValue
  else
    fOnNewPatient := fOnNewPatientDefault;
end;

procedure TCoverSheetParam_CPRS.setParam1(const aValue: string);
begin
  fParam1 := aValue;
end;

end.
