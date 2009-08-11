unit rEventHooks;

interface

uses
  Classes, ORNet;
  
function GetPatientChangeGUIDs: string;
function GetOrderAcceptGUIDs(DisplayGroup: integer): string;
function GetAllActiveCOMObjects: TStrings;
function GetCOMObjectDetails(IEN: integer): string;

implementation

function GetPatientChangeGUIDs: string;
begin
  Result := sCallV('ORWCOM PTOBJ', []);
end;

function GetOrderAcceptGUIDs(DisplayGroup: integer): string;
begin
  Result := sCallV('ORWCOM ORDEROBJ', [DisplayGroup]);
end;

function GetAllActiveCOMObjects: TStrings;
begin
  CallV('ORWCOM GETOBJS', []);
  Result := RPCBrokerV.Results;
end;

function GetCOMObjectDetails(IEN: integer): string;
begin
  Result := sCallV('ORWCOM DETAILS', [IEN]);
end;

end.
