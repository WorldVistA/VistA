//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("..\..\source\ovcspldg.pas", Ovcspldg, OvcfrmSplashDlg);
USEFORMNS("..\..\source\ovcrvpdg.pas", Ovcrvpdg, OvcfrmRptVwPrintDlg);
USEFORMNS("..\..\source\OvcRvPv.pas", Ovcrvpv, OvcRVPrintPreview);
USEFORMNS("..\..\source\ovcmodg.pas", Ovcmodg, OvcfrmMemoDlg);
USEFORMNS("..\..\source\OvcViewEd.pas", Ovcviewed, frmViewEd);
USEFORMNS("..\..\source\ovcvcped.pas", Ovcvcped, frmViewCEd);
USEFORMNS("..\..\source\ovctcedtTextFormatBar.pas", Ovctcedttextformatbar, ovcTextFormatBar);
USEFORMNS("..\..\source\OvcFldEd.pas", Ovcflded, frmOvcRvFldEd);
USEFORMNS("..\..\source\ovccaldg.pas", Ovccaldg, OvcfrmCalendarDlg);
USEFORMNS("..\..\source\ovcclkdg.pas", Ovcclkdg, OvcfrmClockDlg);
USEFORMNS("..\..\source\ovcclcdg.pas", Ovcclcdg, OvcfrmCalculatorDlg);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------


#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
	return 1;
}
//---------------------------------------------------------------------------
