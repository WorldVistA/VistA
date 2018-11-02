unit uGMV_EXEVersion;

interface
uses
  uGMV_VersionInfo
  ;
function IsThisExeCompatibleVersion: Boolean;

implementation

uses uGMV_Const
  , uGMV_Engine;


function IsThisExeCompatibleVersion: Boolean;
{$IFNDEF IGNOREVERSION}
var
  s: String;
begin
  try
    s := getEXEInfo(CurrentExeNameAndVersion);
  except
    s := '';
  end;
  Result := (Pos('Y', s)>0);
{$ELSE}
begin
  Result := TRUE;
{$ENDIF}
end;


end.
