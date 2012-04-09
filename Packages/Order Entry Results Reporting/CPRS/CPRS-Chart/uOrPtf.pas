unit uOrPtf;   //PRF

interface

uses SysUtils, Windows, Classes, Forms, ORFn, ORNet, uCore;

Type
  TPatientFlag = Class(TObject)
  private
    FFlagID:   string;
    FName: string;
    FNarr: TStringList;
    FFlagIndex: integer;
  public
    property FlagID: string      read FFlagID  write FFlagID;
    property Name:   string      read FName    write FName;
    property Narr:   TStringList read FNarr    write FNarr;
    property FlagIndex: integer  read FFlagIndex write FFlagIndex;
    constructor Create;
    procedure Clearup;
  end;

procedure HasActiveFlg(var FlagList: TStringList; var HasFlag: boolean; const PTDFN: string);
function TriggerPRFPopUp(PTDFN: String): boolean;
procedure GetActiveFlg(FlagInfo: TStrings; const PTDFN, FlagRecordID: string);
procedure ClearFlag;

implementation

procedure HasActiveFlg(var FlagList: TStringList; var HasFlag: boolean; const PTDFN: string);
begin
  FlagList.Clear;
  HasFlag := False;
  CallV('ORPRF HASFLG',[PTDFN]);
  if RPCBrokerV.Results.Count > 0 then
  begin
    FastAssign(RPCBrokerV.Results, FlagList);
    HasFlag := True;
  end;
end;

function TriggerPRFPopUp(PTDFN: String): boolean;
begin
  CallV('ORPRF TRIGGER POPUP',[PTDFN]);
  Result := RPCBrokerV.Results[0] = '1';
  RPCBrokerV.Results.Delete(0);
end;

procedure TPatientFlag.Clearup;
begin
  FFlagID := '0';
  FName   := '';
  FNarr.Clear;
  FFlagIndex := -1;
end;

constructor TPatientFlag.Create;
begin
  FFlagID   := '0';
  FName := '';
  FNarr := TStringList.Create;
  FFlagIndex := -1;
end;

procedure GetActiveFlg(FlagInfo: TStrings; const PTDFN, FlagRecordID: string);
begin
  CallV('ORPRF GETFLG', [PTDFN,FlagRecordID]);
  if RPCBrokerV.Results.Count > 0 then
    FastAssign(RPCBrokerV.Results, FlagInfo);
end;

procedure ClearFlag;
begin
  sCallV('ORPRF CLEAR',[nil]);
end;

end.
