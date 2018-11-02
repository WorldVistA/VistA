unit uGMV_WindowsEvents;

interface
uses
  SvcMgr
  , uGMV_Common
  ;

var
  MEV: TEventLogger;

procedure WindowsLogLine(aLine: String);

implementation
uses
  Windows
  , SysUtils
  ;

procedure WindowsLogLine(aLine: String);
begin
  if CmdLineSwitch(['/NOLOG','/nolog']) then
    Exit;
  try
    MEV.LogMessage(aLine,EVENTLOG_SUCCESS,0,1);
  except
  end;
end;

initialization
  MEV := TEventLogger.Create('zzVitals');

finalization
  FreeAndNil(MEV);
end.
