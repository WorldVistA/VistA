unit uOrPtf;

interface

uses
  System.Classes,
  ORNet;

procedure HasActiveFlg(var FlagList: TStringList; var HasFlag: boolean; const PTDFN: string);
function TriggerPRFPopUp(PTDFN: string): boolean;
procedure GetActiveFlg(FlagInfo: TStrings; const PTDFN, FlagRecordID: string);
procedure ClearFlag;

implementation

procedure HasActiveFlg(var FlagList: TStringList; var HasFlag: boolean; const PTDFN: string);
begin
  CallVistA('ORPRF HASFLG', [PTDFN], FlagList);
  HasFlag := (FlagList.Count > 0);
end;

function TriggerPRFPopUp(PTDFN: string): boolean;
var
  aStr: string;
begin
  CallVistA('ORPRF TRIGGER POPUP', [PTDFN], aStr);
  Result := (aStr = '1');
end;

procedure GetActiveFlg(FlagInfo: TStrings; const PTDFN, FlagRecordID: string);
begin
  CallVistA('ORPRF GETFLG', [PTDFN, FlagRecordID], FlagInfo);
end;

procedure ClearFlag;
begin
  CallVistA('ORPRF CLEAR', [nil]);
end;

end.
