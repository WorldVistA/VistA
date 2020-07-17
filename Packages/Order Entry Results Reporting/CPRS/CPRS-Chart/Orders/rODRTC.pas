unit rODRTC;

interface

//uses SysUtils, Classes, ORNet, ORFn, uCore, uConst, Windows;
uses SysUtils, Classes, ORNet;

procedure getAdditionalInformation(locIen,what: string; var aReturn: TStrings);

implementation


procedure getAdditionalInformation(locIen, what: string; var aReturn: TStrings);
begin
  CallVistA('ORWDSD1 GETINFO',[locIEN, what], aReturn);
end;
end.
