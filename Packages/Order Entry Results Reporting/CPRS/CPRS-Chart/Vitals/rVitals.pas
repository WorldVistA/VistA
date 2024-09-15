////////////////////////////////////////////////////////////////////////////////
//Modifed: 9/18/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Changed function ValAndStoreVitals to return the string indicating the value
//   that failed.
////////////////////////////////////////////////////////////////////////////////

unit rVitals;

interface

uses SysUtils, Classes, ORNet, ORFn;

procedure GetLastVital(Dest: TStrings; const PatientID: string);  //*DFN*
function VerifyVital(typ,rte,unt: String):boolean;
function ValAndStoreVitals(VitalList: TStringList):string;      //9/18/98
procedure GetVitalFromNoteIEN(Dest: TStrings; const PatientID: string; NoteIEN: Integer);  //*DFN*
procedure GetVitalsFromEncDateTime(Dest: TStrings; const PatientID: string; datetime: TFMDateTime);  //*DFN*

const
  ORQQVI_METRIC_FIRST_IGNORE = 0;
  ORQQVI_METRIC_FIRST_HONOR = 1;

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
  CallVistA('ORQQVI VITALS', [IDString, '', '', ORQQVI_METRIC_FIRST_HONOR], Dest);
end;

function VerifyVital(typ,rte,unt: String):boolean;
var
  aStr: string;
begin
  CallVistA('ORQQVI2 VITALS RATE CHECK',[typ, rte, unt], aStr);
  Result := (aStr = '1');
end;

/// //////////////////////////////////////////////////////////////////////////////
//Modifed: 9/18/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Changed function ValAndStoreVitals to return the string indicating the value
//   that failed.
/// //////////////////////////////////////////////////////////////////////////////
function ValAndStoreVitals(VitalList: TStringList):string;
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORQQVI2 VITALS VAL & STORE', [VitalList], aLst);
    Result := 'Error Saving Vitals';
    if aLst.Count > 0 then
    begin
      if aLst[0] >= '0' then
        Result := 'True' // stored ok
      else if aLst.Count > 1 then
        Result := Piece(aLst[1], U, 2) + ': ' + Piece(aLst[1], U, 3) + ' Value: ' + Piece(aLst[1], U, 4);
    end;
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
  CallVistA('ORQQVI NOTEVIT', [IDString, NoteIENStr, ORQQVI_METRIC_FIRST_HONOR], Dest);
end;

procedure GetVitalsFromEncDateTime(Dest: TStrings; const PatientID: string; datetime: TFMDateTime); // *DFN*
var
  EncDate: string;
  IDString: string;
begin
  IDString := PatientID; // *DFN*
  EncDate := FloatToStr(datetime);
  CallVistA('ORQQVI VITALS', [IDString, EncDate, '', ORQQVI_METRIC_FIRST_HONOR], Dest);
end;

initialization

finalization
  FreeAndNil(uVitalList);

end.
