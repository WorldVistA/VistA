program VitalsManager;
{
================================================================================
*
*       Application:  Vitals Manager
*       Revision:     $Revision: 1 $  $Modtime: 3/04/09 2:41p $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Main project file
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER/VitalsManager.dpr $
*
* $History: VitalsManager.dpr $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/18/07    Time: 12:41p
 * Updated in $/Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 3:14p
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:40p
 * Created in $/Vitals/VITALS-5-0-18/APP-VitalsManager
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:30p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/APP-VitalsManager
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 4:57p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsManager-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:22p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSMANAGER-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:09p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsManager
 * 
 * *****************  Version 8  *****************
 * User: Zzzzzzandria Date: 12/20/02   Time: 3:03p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzandria Date: 11/04/02   Time: 9:15a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Version 5.0.0.0
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 10/11/02   Time: 6:21p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Version v.T32_1
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 10/04/02   Time: 4:49p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Version T32 
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 7/29/02    Time: 11:18a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * v T29
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:12a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Roll-up to 5.0.0.27
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 5/15/02    Time: 12:16p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Added the Print Qualifiers Option
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 3:47p
 * Created in $/Vitals GUI Version 5.0/Vitals Manager
 *
 *
*
================================================================================
}

uses
  Forms,
  Dialogs,
  SysUtils,
  TRPCB,
  //SharedRPCBroker,
  system.uitypes,
  fGMV_TimeOutManager in '..\VitalsCommon\fGMV_TimeOutManager.pas' {frmGMV_TimeOutManager},
  fGMV_AboutDlg in '..\VitalsCommon\fGMV_AboutDlg.pas' {frmGMV_AboutDlg},
  fGMV_AddVCQ in '..\VitalsCommon\fGMV_AddVCQ.pas' {frmGMV_AddVCQ},
  fGMV_Splash in '..\VitalsCommon\fGMV_Splash.pas' {frmGMV_Splash},
  mGMV_EditTemplate in '..\VitalsCommon\mGMV_EditTemplate.pas' {fraGMV_EditTemplate: TFrame},
  uGMV_Common in '..\VitalsUtils\uGMV_Common.pas',
  uGMV_Const in '..\VitalsUtils\uGMV_Const.pas',
  uGMV_FileEntry in '..\VitalsCommon\uGMV_FileEntry.pas',
  uGMV_GlobalVars in '..\VitalsUtils\uGMV_GlobalVars.pas',
  uGMV_VitalTypes in '..\VitalsCommon\uGMV_VitalTypes.pas',
  uGMV_Utils in '..\VitalsUtils\uGMV_Utils.pas',
  mGMV_Lookup in '..\VitalsDataEntry\mGMV_Lookup.pas' {fraGMV_Lookup: TFrame},
  uGMV_CRC32 in '..\VitalsUtils\uGMV_CRC32.pas',
  uGMV_VersionInfo in '..\VitalsUtils\uGMV_VersionInfo.pas',
  uGMV_User in '..\VitalsCommon\uGMV_User.pas',
  fGMV_Qualifiers in '..\VitalsDataEntry\fGMV_Qualifiers.pas' {frmGMV_Qualifiers},
  uGMV_QualifyBox in '..\VitalsDataEntry\uGMV_QualifyBox.pas',
  fROR_PCall in '..\ROR\fROR_PCall.pas' {RPCErrorForm},
  uGMV_Template in '..\VitalsDataEntry\uGMV_Template.pas',
  uGMV_Engine in '..\VitalsUtils\uGMV_Engine.pas',
  uROR_RPCBroker in '..\ROR\uROR_RPCBroker.pas',
  uGMV_Setup in '..\VitalsCommon\uGMV_Setup.pas',
  mGMV_SystemParameters in 'mGMV_SystemParameters.pas' {fraSystemParameters: TFrame},
  mGMV_VitalHiLo in 'mGMV_VitalHiLo.pas' {fraVitalHiLo: TFrame},
  fGMV_AddEditQualifier in 'fGMV_AddEditQualifier.pas' {frmGMV_AddEditQualifier},
  fGMV_DeviceSelector in 'fGMV_DeviceSelector.pas' {frmGMV_DeviceSelector},
  fGMV_Manager in 'fGMV_Manager.pas' {frmGMV_Manager},
  fGMV_NewTemplate in 'fGMV_NewTemplate.pas' {frmGMV_NewTemplate},
  fGMV_RPCLog in '..\VitalsCommon\fGMV_RPCLog.pas' {frmGMV_RPCLog},
  uGMV_EXEVersion in '..\VitalsUtils\uGMV_EXEVersion.pas',
  mGMV_PrinterSelector in '..\VitalsCommon\mGMV_PrinterSelector.pas' {frGMV_PrinterSelector: TFrame},
  mGMV_DefaultSelector in '..\VITALSCOMMON\mGMV_DefaultSelector.pas' {frDefaultSelector: TFrame},
  uGMV_RPC_Names in '..\VITALSCOMMON\uGMV_RPC_Names.pas',
  uGMV_Log in '..\VITALSCOMMON\uGMV_Log.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Vitals Manager';
  GMVSplash := TfrmGMV_Splash.Create(Application);
  GMVSplash.Show;
  GMVSplash.UpdateMessage('Establishing VistA Connection...');

  Application.CreateForm(TfrmGMV_Manager, frmGMV_Manager);
  Application.CreateForm(TfrmGMV_NewTemplate, frmGMV_NewTemplate);
  Application.CreateForm(TfrmGMV_RPCLog, frmGMV_RPCLog);
  if not frmGMV_Manager.RestoreConnection then // will create Broker
      begin
        FreeAndNil(frmGMV_Manager);
        FreeAndNil(GMVSplash);
        Exit;
      end;
  Application.CreateForm(TfrmGMV_AddVCQ, frmGMV_AddVCQ);

  try
    if not GMVUser.SignOn(RPC_CREATECONTEXT, True) then
      begin
        GMVSplash.Hide;
        Application.Terminate;
        Application.Run;
        ShutDownTimeOut;
      end
    else
      if GMVUser.GMVManager then
        begin
          GMVSplash.UpdateMessage('Loading ...');

          CreateGMVGlobalVars;
          GMVDefaultTemplates := TGMV_DefaultTemplates.Create;
          frmGMV_Manager.RestoreSettings;
          InitTimeOut(nil);
          UpdateTimeOutInterval(GMVUser.DTime);
          GMVSplash.Hide;
          frmGMV_Manager.pgctrl.Visible := true;
          Application.Run;
          ShutDownTimeOut;

          FreeAndNil(GMVSplash);
          FreeAndNil(GMVDefaultTemplates);
          ReleaseGMVGlobalVars;
          FreeAndNil(GMVUser);
          FreeAndNil(RPCBroker);
        end
      else
        begin
        MessageDlg(
          'Sorry, you need the GMV MANAGER Security Key to run this application.'#13#13+
          'Please see your Application Coordinator (ADPAC) to arrange access.',
          mtInformation, [mbok], 0);
        try
          FreeAndNil(frmGMV_Manager);
        except
        end;

        FreeAndNil(GMVSplash);
        FreeAndNil(frmGMV_AddVCQ);
        FreeAndNil(GMVUser);
        FreeAndNil(RPCBroker);
        end;
  except //finally
  end;
end.

