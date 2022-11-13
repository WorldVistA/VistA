unit rEventHooks;

interface

uses
  Classes, ORNet, System.SysUtils;

function GetPatientChangeGUIDs(aDefault:String=''): string;
function GetOrderAcceptGUIDs(DisplayGroup: integer;aDefault:String=''): string;
function setAllActiveCOMObjects(aDest: TStrings): Integer;
function GetCOMObjectDetails(IEN: integer;aDefault:String=''): string;

implementation

function GetPatientChangeGUIDs(aDefault:String=''): string;
begin
  try
    if not CallVistA('ORWCOM PTOBJ', [],Result) then
      Result := aDefault;
  except
    on E: Exception do
      Result := aDefault;
  end;
end;

function GetOrderAcceptGUIDs(DisplayGroup: integer;aDefault:String=''): string;
begin
  try
    if not CallVistA('ORWCOM ORDEROBJ', [DisplayGroup],Result) then
      Result := aDefault;
  except
    on E: Exception do
      Result := aDefault;
  end;
end;

function GetAllActiveCOMObjects(aDest: TStrings): Integer;
begin
  CallVistA('ORWCOM GETOBJS', [], aDest);
  Result := aDest.Count;
end;

function setAllActiveCOMObjects(aDest: TStrings): Integer;
begin
  CallVistA('ORWCOM GETOBJS', [], aDest);
  Result := aDest.Count;
end;

function GetCOMObjectDetails(IEN: integer;aDefault:String=''): string;
begin
  try
    if not CallVistA('ORWCOM DETAILS', [IEN],Result) then
      Result := aDefault;
  except
    on E: Exception do
      Result := aDefault;
  end;
end;

end.
