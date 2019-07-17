////////////////////////////////////////////////////////////////////////////////
//Modifed: 9/18/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Changed function ValAndStoreVitals to return the string indicating the value
//   that failed.
////////////////////////////////////////////////////////////////////////////////

unit rVitals;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses SysUtils, Classes, ORNet, ORFn;

procedure SaveVitals(VitalList: TStringList);
Procedure GetLastVital(Dest: TStrings; const PatientID: string);  //*DFN*
function VerifyVital(typ,rte,unt: String):boolean;
function ValAndStoreVitals(VitalList: TStringList):string;      //9/18/98
Procedure GetVitalFromNoteIEN(Dest: TStrings; const PatientID: string; NoteIEN: Integer);  //*DFN*
Procedure GetVitalsFromEncDateTime(Dest: TStrings; const PatientID: string; datetime: TFMDateTime);  //*DFN*
procedure LoadUserVitalPreferences;
procedure SaveUserVitalPreferences;
function GetVList(Loc: integer): TStringList;

var
  uVitalsMetric: boolean = FALSE;
  uVitCVPmmHg: boolean = FALSE;

implementation

var
  uOldVitalsMetric: boolean = FALSE;
  uOldVitCVPmmHg: boolean = FALSE;
  uVitalList: TStringList = nil;
  uLastVitalLoc: integer = -1;

procedure SaveVitals(VitalList: TStringList);
begin
  CallV('ORWVITALS SAVE', [VitalList]);
end;

procedure GetLastVital(Dest: TStrings; const PatientID: string);  //*DFN*
var
  IDString: String;
begin
  IDString := patientid;  //*DFN*
  CallV('ORQQVI VITALS', [IDString]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function VerifyVital(typ,rte,unt: String):boolean;
begin
  result := False;
  CallV('ORQQVI2 VITALS RATE CHECK',[typ,rte,unt]);
  if RPCBrokerV.results[0] = '1' then
    result := True;
end;


////////////////////////////////////////////////////////////////////////////////
//Modifed: 9/18/98
//By: Robert Bott
//Location: ISL
//Description of Mod:
//  Changed function ValAndStoreVitals to return the string indicating the value
//   that failed.
////////////////////////////////////////////////////////////////////////////////
function ValAndStoreVitals(VitalList: TStringList):string;
begin
  CallV('ORQQVI2 VITALS VAL & STORE',[VitalList]);
  if RPCBrokerV.results[0] >= '0' then
    result := 'True'  //stored ok
  else
    result := Piece(RPCBrokerV.results[1],U,2) + ': '+Piece(RPCBrokerV.results[1],U,3)+' Value: '+
      Piece(RPCBrokerV.results[1],U,4);
end;

Procedure GetVitalFromNoteIEN(Dest: TStrings; const PatientID: string; NoteIEN: Integer);  //*DFN*
var
  NoteIENStr,IDString: String;
begin
  IDString := patientid;  //*DFN*
  NoteIENStr := IntToStr(NoteIen);
  CallV('ORQQVI NOTEVIT', [IDString, NoteIENStr]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

Procedure GetVitalsFromEncDateTime(Dest: TStrings; const PatientID: string; DateTime: TFMDateTime);  //*DFN*
var
  EncDate,IDString: String;
begin
  IDString := patientid;  //*DFN*
  EncDate := FloatToStr(DateTime);
  CallV('ORQQVI VITALS', [IDString, EncDate]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure LoadUserVitalPreferences;
var
  Tmp: string;
begin
  Tmp := sCallV('ORQQVI3 GETVPREF', []);
  uVitalsMetric := (Piece(Tmp,U,1) = '1');
  uVitCVPmmHg   := (Piece(Tmp,U,2) = '1');
  uOldVitalsMetric := uVitalsMetric;
  uOldVitCVPmmHg := uVitCVPmmHg;
end;

procedure SaveUserVitalPreferences;
var
  P1, P2: string;

begin
  // Don't same same value loaded, since saving is at user level,
  //                     and loading may be at a different level
  if(uOldVitalsMetric = uVitalsMetric) then P1 := '' else P1 := BOOLCHAR[uVitalsMetric];
  if(uOldVitCVPmmHg   = uVitCVPmmHg)   then P2 := '' else P2 := BOOLCHAR[uVitCVPmmHg];
  CallV('ORQQVI3 SETVPREF', [P1, P2]);
end;

function GetVList(Loc: integer): TStringList;
var
  GetList: boolean;

begin
  GetList := TRUE;
  if not assigned(uVitalList) then
    uVitalList := TStringList.Create
  else
  if Loc = uLastVitalLoc then
    GetList := FALSE;
  if(GetList) then
  begin
    uLastVitalLoc := Loc;
    CallV('ORQQVI3 GETVLIST', [Loc]);
    if(RPCBrokerV.Results.Count > 0) then
      RPCBrokerV.Results.Delete(0);
    FastAssign(RPCBrokerV.Results, uVitalList);
  end;
  Result := uVitalList;
end;

initialization

finalization
  KillObj(@uVitalList);

end.
