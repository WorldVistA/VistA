unit oWVPatient;
{
  ================================================================================
  *
  *       Application:  TDrugs Patch OR*3*377 and WV*1*24
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Object that is created via the WVController to maintain
  *                     valid WH data during the update process in
  *                     frmWHPregLacStatusUpdate. Only accessible as
  *                     IWVPatient interface.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  System.Classes,
  System.SysUtils,
  iWVInterface;

type
  TWVPatient = class(TInterfacedObject, IWVPatient)
  private
    fAbleToConceive: TWVAbleToConceive;
    fAskForLactationData: boolean;
    fAskForPregnancyData: boolean;
    fDFN: string;
    fHysterectomy: boolean;
    fLactationStatus: TWVLactationStatus;
    fLastMenstrualPeriod: TDateTime;
    fMenopause: boolean;
    fPregnancyStatus: TWVPregnancyStatus;
  public
    constructor Create(aDFN: string);
    destructor Destroy; override;

    function getAbleToConceive: TWVAbleToConceive;
    function getAbleToConceiveAsStr: string;
    function getAskForLactationData: boolean;
    function getAskForPregnancyData: boolean;
    function getDFN: string;
    function getHysterectomy: boolean;
    function getLactationStatus: TWVLactationStatus;
    function getLactationStatusAsStr: string;
    function getLastMenstrualPeriod: TDateTime;
    function getLastMenstrualPeriodAsStr: string;
    function getMenopause: boolean;
    function getPregnancyStatus: TWVPregnancyStatus;
    function getPregnancyStatusAsStr: string;
    function getUnableToConceiveReason: string;

    procedure setAbleToConceive(const aValue: TWVAbleToConceive);
    procedure setAskForLactationData(const aValue: boolean);
    procedure setAskForPregnancyData(const aValue: boolean);
    procedure setDFN(const aValue: string);
    procedure setHysterectomy(const aValue: boolean);
    procedure setLactationStatus(const aValue: TWVLactationStatus);
    procedure setLastMenstrualPeriod(const aValue: TDateTime);
    procedure setMenopause(const aValue: boolean);
    procedure setPregnancyStatus(const aValue: TWVPregnancyStatus);
  end;

implementation

{ TWVPatient }

constructor TWVPatient.Create(aDFN: string);
begin
  inherited Create;
  fDFN := aDFN;
  fAbleToConceive := atcUnknown;
  fPregnancyStatus := psUnknown;
  fLactationStatus := lsUnknown;
  fHysterectomy := False;
  fMenopause := False;
  fLastMenstrualPeriod := 0;
end;

destructor TWVPatient.Destroy;
begin
  inherited;
end;

function TWVPatient.getAbleToConceive: TWVAbleToConceive;
begin
  Result := fAbleToConceive;
end;

function TWVPatient.getAbleToConceiveAsStr: string;
begin
  Result := WV_ABLE_TO_CONCEIVE[fAbleToConceive];
end;

function TWVPatient.getAskForLactationData: boolean;
begin
  Result := fAskForLactationData;
end;

function TWVPatient.getAskForPregnancyData: boolean;
begin
  Result := fAskForPregnancyData;
end;

function TWVPatient.getDFN: string;
begin
  Result := fDFN;
end;

function TWVPatient.getHysterectomy: boolean;
begin
  Result := fHysterectomy;
end;

function TWVPatient.getLactationStatus: TWVLactationStatus;
begin
  Result := fLactationStatus;
end;

function TWVPatient.getLactationStatusAsStr: string;
begin
  Result := WV_LACTATION_STATUS[fLactationStatus];
end;

function TWVPatient.getLastMenstrualPeriod: TDateTime;
begin
  Result := fLastMenstrualPeriod;
end;

function TWVPatient.getLastMenstrualPeriodAsStr: string;
var
  y, m, d: Word;
begin
  if fLastMenstrualPeriod > 0 then
    begin
      DecodeDate(fLastMenstrualPeriod, y, m, d);
      Result := Format('%3d%.2d%.2d', [y - 1700, m, d]);
    end
  else
    Result := '';
end;

function TWVPatient.getMenopause: boolean;
begin
  Result := fMenopause;
end;

function TWVPatient.getPregnancyStatus: TWVPregnancyStatus;
begin
  Result := fPregnancyStatus;
end;

function TWVPatient.getPregnancyStatusAsStr: string;
begin
  Result := WV_PREGNANCY_STATUS[fPregnancyStatus];
end;

function TWVPatient.getUnableToConceiveReason: string;
begin
  if fHysterectomy and fMenopause then
    Result := 'Hysterectomy and Menopause'
  else if fHysterectomy then
    Result := 'Hysterectomy'
  else if fMenopause then
    Result := 'Menopause'
  else
    Result := '';
end;

procedure TWVPatient.setAbleToConceive(const aValue: TWVAbleToConceive);
begin
  fAbleToConceive := aValue;
end;

procedure TWVPatient.setAskForLactationData(const aValue: boolean);
begin
  fAskForLactationData := aValue;
end;

procedure TWVPatient.setAskForPregnancyData(const aValue: boolean);
begin
  fAskForPregnancyData := aValue;
end;

procedure TWVPatient.setDFN(const aValue: string);
begin
  fDFN := aValue;
end;

procedure TWVPatient.setHysterectomy(const aValue: boolean);
begin
  fHysterectomy := aValue;
end;

procedure TWVPatient.setLactationStatus(const aValue: TWVLactationStatus);
begin
  fLactationStatus := aValue;
end;

procedure TWVPatient.setLastMenstrualPeriod(const aValue: TDateTime);
begin
  fLastMenstrualPeriod := aValue;
end;

procedure TWVPatient.setMenopause(const aValue: boolean);
begin
  fMenopause := aValue;
end;

procedure TWVPatient.setPregnancyStatus(const aValue: TWVPregnancyStatus);
begin
  fPregnancyStatus := aValue;
end;

end.
