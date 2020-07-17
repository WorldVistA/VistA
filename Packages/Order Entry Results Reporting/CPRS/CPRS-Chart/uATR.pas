unit uATR;

interface

uses SysUtils, Classes, ORNet, ORFn, ComCtrls, Controls, Forms, TRPCB, Windows;

type
 TGetATRPatient = function(var slList: TStringList; var sATRDisplayTime: string; thisRPCBroker: TRPCBroker; UserIEN: string):boolean; stdcall;
 TPtProcessATR = function(RPCBroker: TRPCBroker; PatientIEN: string; UserIEN: string):string; stdcall;
 TPtProcessATRMult = function(RPCBroker: TRPCBroker; PatientIEN: string; UserIEN: string):TStringList; stdcall;
 TATRDocumentType = function(RPCBroker: TRPCBroker; PatientIEN: string; UserIEN: string; thisXQAID: string):string; stdcall;
 TGetEnhancedNotifications = procedure(var slNotifications: TStringList; thisRPCBroker: TRPCBroker; thisUserIEN: string); stdcall;
 TFreeATRDLL = procedure(); stdcall;

const
  TAR_INITIAL_PROCESS_LEVEL = 0;
  TAR_PROCESSED_NOT_COMPLETED = 1;
  TAR_PROCESSED_COMPLETED = 2;
  TAR_TRANSMITTED = 3;

var
 bATRAval: boolean;
 bATRPtSelOnce: boolean;
 sATRFilterShowParam: string;
 ATRHandle: HINST;
 GetATRPatient: TGetATRPatient;
 PtProcessATR: TPtProcessATR;
 PtProcessATRMult: TPtProcessATRMult;
 ATRDocumentType: TATRDocumentType;
 FreeATRDLL: TFreeATRDLL;
 GetEnhancedNotifications: TGetEnhancedNotifications;
 ATR_ien: string;
 atrXQAID: string;
 bNotATRPt: boolean; //<------------ Moved here from fPtSel.SelectPatient() for use in rTIU.SignDocument()
 //slPTSel: TStringList; //<------------ Moved here from fPtSel.SelectPatient()
 slPtList: TStringList; //<------------ Moved here from fPtSel.SelectPatient()
 TARHealthFactors: string; //Added 20121019 to send via 'ORATR HEALTH FACTORS'

 procedure LoadATRDLL();

implementation

procedure LoadATRDLL();
begin
 ATRHandle := SafeLoadLibrary('TAR.dll');
 if ATRHandle > 0 then
   begin
    bATRAval := true;
    bATRPtSelOnce := true;
    GetATRPatient := GetProcAddress(ATRHandle, 'GetATRPatient');

    PtProcessATR := GetProcAddress(ATRHandle, 'PtProcessATR');
    PtProcessATRMult := GetProcAddress(ATRHandle, 'PtProcessATRMult');

    FreeATRDLL := GetProcAddress(ATRHandle, 'FreeATRDLL');
    GetEnhancedNotifications := GetProcAddress(ATRHandle, 'GetEnhancedNotifications');
    ATRDocumentType := GetProcAddress(ATRHandle, 'ATRDocumentType');
   end
 else
  bATRAval := false;

end;

end.
