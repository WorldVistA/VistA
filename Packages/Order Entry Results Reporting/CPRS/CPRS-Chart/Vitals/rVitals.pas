/// /////////////////////////////////////////////////////////////////////////////
// Modifed: 9/18/98
// By: Robert Bott
// Location: ISL
// Description of Mod:
// Changed function ValAndStoreVitals to return the string indicating the value
// that failed.
/// /////////////////////////////////////////////////////////////////////////////

unit rVitals;

interface

uses SysUtils, Classes, ORNet, ORFn;

procedure GetLastVital(Dest: TStrings; const PatientID: string);  //*DFN*
function VerifyVital(typ,rte,unt: String):boolean;
function ValAndStoreVitals(VitalList: TStringList):string;      //9/18/98
procedure GetVitalFromNoteIEN(Dest: TStrings; const PatientID: string; NoteIEN: Integer);  //*DFN*
procedure GetVitalsFromEncDateTime(Dest: TStrings; const PatientID: string; datetime: TFMDateTime);  //*DFN*

var
  uVitalsMetric: boolean = FALSE;
  uVitCVPmmHg: boolean = FALSE;

implementation

var
  uOldVitalsMetric: boolean = FALSE;
  uOldVitCVPmmHg: boolean = FALSE;
  uVitalList: TStringList = nil;
  uLastVitalLoc: integer = -1;

procedure GetLastVital(Dest: TStrings; const PatientID: string);  //*DFN*
var
  IDString: String;
begin
  IDString := patientid;  //*DFN*
  CallVistA('ORQQVI VITALS', [IDString], Dest);
end;

function VerifyVital(typ, rte, unt: String): boolean;
var
  aStr: string;
begin
  CallVistA('ORQQVI2 VITALS RATE CHECK',[typ, rte, unt], aStr);
  Result := (aStr = '1');
end;

/// //////////////////////////////////////////////////////////////////////////////
// Modifed: 9/18/98
// By: Robert Bott
// Location: ISL
// Description of Mod:
// Changed function ValAndStoreVitals to return the string indicating the value
// that failed.
/// //////////////////////////////////////////////////////////////////////////////
function ValAndStoreVitals(VitalList: TStringList): string;
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORQQVI2 VITALS VAL & STORE', [VitalList], aLst);
    if aLst[0] >= '0' then
      Result := 'True' // stored ok
    else
      Result := Piece(aLst[1], U, 2) + ': ' + Piece(aLst[1], U, 3) + ' Value: ' + Piece(aLst[1], U, 4);
  finally
    FreeAndNil(aLst);
  end;
end;

procedure GetVitalFromNoteIEN(Dest: TStrings; const PatientID: string; NoteIEN: Integer); // *DFN*
var
  NoteIENStr: string;
  IDString: string;
begin
  IDString := PatientID; // *DFN*
  NoteIENStr := IntToStr(NoteIEN);
  CallVistA('ORQQVI NOTEVIT', [IDString, NoteIENStr], Dest);
end;

procedure GetVitalsFromEncDateTime(Dest: TStrings; const PatientID: string; datetime: TFMDateTime); // *DFN*
var
  EncDate: string;
  IDString: string;
begin
  IDString := PatientID; // *DFN*
  EncDate := FloatToStr(datetime);
  CallVistA('ORQQVI VITALS', [IDString, EncDate], Dest);
end;

initialization

finalization
  FreeAndNil(uVitalList);

end.
