library JAWS;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }



{$R *.dres}

uses
  SysUtils,
  Classes,
  JAWSImplementation in 'JAWSImplementation.pas',
  fVA508DispatcherHiddenWindow in 'fVA508DispatcherHiddenWindow.pas',
  fVA508HiddenJawsMainWindow in 'fVA508HiddenJawsMainWindow.pas' {frmVA508HiddenJawsMainWindow},
  fVA508HiddenJawsDataWindow in 'fVA508HiddenJawsDataWindow.pas' {frmVA508HiddenJawsDataWindow},
  JAWSCommon in 'JAWSCommon.pas',
  FSAPILib_TLB in 'FSAPILib_TLB.pas',
  U_LogObject in 'U_LogObject.pas',
  U_SplashScreen in 'U_SplashScreen.pas' {SplashScrn};

{$Ifdef VER180}
 {$E SR}
{$Else}
 {$E SR3}
{$EndIf}

{$R *.res}

begin
 {$WARN SYMBOL_PLATFORM OFF}
 ReportMemoryLeaksOnShutdown := DebugHook <> 0;
 {$WARN SYMBOL_PLATFORM ON}
end.
