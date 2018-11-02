// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OrpheusDBDR.dpk' rev: 29.00 (Windows)

#ifndef OrpheusdbdrHPP
#define OrpheusdbdrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// (rtl)
#include <SysInit.hpp>
#include <ovcdbae.hpp>
#include <ovcdbcal.hpp>
#include <ovcdbccb.hpp>
#include <ovcdbcl.hpp>
#include <ovcdbclk.hpp>
#include <ovcdbdat.hpp>
#include <ovcdbdLb.hpp>
#include <ovcdbed.hpp>
#include <ovcdbfcb.hpp>
#include <ovcdbmdg.hpp>
#include <ovcdbnf.hpp>
#include <ovcdbnum.hpp>
#include <ovcdbpf.hpp>
#include <ovcdbplb.hpp>
#include <ovcdbrpv.hpp>
#include <ovcdbsed.hpp>
#include <ovcdbsf.hpp>
#include <ovcdbsld.hpp>
#include <ovcdbtbl.hpp>
#include <ovcdbtim.hpp>
#include <o32dbfe.hpp>
#include <System.Types.hpp>	// (rtl)
#include <System.UITypes.hpp>	// (rtl)
#include <Winapi.Windows.hpp>	// (rtl)
#include <Winapi.Messages.hpp>	// (rtl)
#include <System.SysConst.hpp>	// (rtl)
#include <Winapi.ImageHlp.hpp>	// (rtl)
#include <Winapi.SHFolder.hpp>	// (rtl)
#include <Winapi.PsAPI.hpp>	// (rtl)
#include <System.RTLConsts.hpp>	// (rtl)
#include <System.Character.hpp>	// (rtl)
#include <System.Internal.ExcUtils.hpp>	// (rtl)
#include <System.SysUtils.hpp>	// (rtl)
#include <System.VarUtils.hpp>	// (rtl)
#include <System.Variants.hpp>	// (rtl)
#include <Winapi.ActiveX.hpp>	// (rtl)
#include <System.StrUtils.hpp>	// (rtl)
#include <System.AnsiStrings.hpp>	// (rtl)
#include <System.Hash.hpp>	// (rtl)
#include <System.Math.hpp>	// (rtl)
#include <System.Generics.Defaults.hpp>	// (rtl)
#include <System.Generics.Collections.hpp>	// (rtl)
#include <System.Rtti.hpp>	// (rtl)
#include <System.TypInfo.hpp>	// (rtl)
#include <System.Classes.hpp>	// (rtl)
#include <Winapi.MultiMon.hpp>	// (rtl)
#include <Winapi.Wincodec.hpp>	// (rtl)
#include <System.Masks.hpp>	// (rtl)
#include <System.TimeSpan.hpp>	// (rtl)
#include <System.DateUtils.hpp>	// (rtl)
#include <System.IOUtils.hpp>	// (rtl)
#include <System.IniFiles.hpp>	// (rtl)
#include <System.Win.Registry.hpp>	// (rtl)
#include <System.UIConsts.hpp>	// (rtl)
#include <Vcl.Consts.hpp>	// (vcl)
#include <Vcl.Graphics.hpp>	// (vcl)
#include <System.Contnrs.hpp>	// (rtl)
#include <Winapi.CommCtrl.hpp>	// (rtl)
#include <System.ImageList.hpp>	// (rtl)
#include <System.Actions.hpp>	// (rtl)
#include <Winapi.Imm.hpp>	// (rtl)
#include <Vcl.ActnList.hpp>	// (vcl)
#include <System.HelpIntfs.hpp>	// (rtl)
#include <System.Diagnostics.hpp>	// (rtl)
#include <System.SyncObjs.hpp>	// (rtl)
#include <Winapi.UxTheme.hpp>	// (rtl)
#include <Winapi.Dwmapi.hpp>	// (rtl)
#include <System.Win.Crtl.hpp>	// (rtl)
#include <System.ZLib.hpp>	// (rtl)
#include <Vcl.GraphUtil.hpp>	// (vcl)
#include <Vcl.StdCtrls.hpp>	// (vcl)
#include <Winapi.Qos.hpp>	// (rtl)
#include <Winapi.Winsock2.hpp>	// (rtl)
#include <Winapi.IpExport.hpp>	// (rtl)
#include <Winapi.ShellAPI.hpp>	// (rtl)
#include <Winapi.RegStr.hpp>	// (rtl)
#include <Winapi.WinInet.hpp>	// (rtl)
#include <Winapi.UrlMon.hpp>	// (rtl)
#include <Winapi.ObjectArray.hpp>	// (rtl)
#include <Winapi.StructuredQueryCondition.hpp>	// (rtl)
#include <Winapi.PropSys.hpp>	// (rtl)
#include <Winapi.MSXMLIntf.hpp>	// (rtl)
#include <Winapi.ShlObj.hpp>	// (rtl)
#include <Winapi.CommDlg.hpp>	// (rtl)
#include <Winapi.WinSpool.hpp>	// (rtl)
#include <Vcl.Printers.hpp>	// (vcl)
#include <Winapi.RichEdit.hpp>	// (rtl)
#include <Vcl.ToolWin.hpp>	// (vcl)
#include <Vcl.ListActns.hpp>	// (vcl)
#include <Vcl.ComStrs.hpp>	// (vcl)
#include <Vcl.Clipbrd.hpp>	// (vcl)
#include <Vcl.StdActns.hpp>	// (vcl)
#include <Vcl.ComCtrls.hpp>	// (vcl)
#include <System.WideStrUtils.hpp>	// (rtl)
#include <Winapi.Dlgs.hpp>	// (rtl)
#include <Vcl.Dialogs.hpp>	// (vcl)
#include <Vcl.ExtCtrls.hpp>	// (vcl)
#include <Vcl.Themes.hpp>	// (vcl)
#include <System.Win.ComConst.hpp>	// (rtl)
#include <System.Win.ComObj.hpp>	// (rtl)
#include <System.Win.Taskbar.hpp>	// (rtl)
#include <System.Win.TaskbarCore.hpp>	// (rtl)
#include <Winapi.FlatSB.hpp>	// (rtl)
#include <Vcl.Forms.hpp>	// (vcl)
#include <Vcl.ImgList.hpp>	// (vcl)
#include <Vcl.Menus.hpp>	// (vcl)
#include <Winapi.TpcShrd.hpp>	// (rtl)
#include <Winapi.MsInkAut.hpp>	// (rtl)
#include <Winapi.PenInputPanel.hpp>	// (rtl)
#include <Vcl.Controls.hpp>	// (vcl)
#include <Vcl.Buttons.hpp>	// (vcl)
#include <System.MaskUtils.hpp>	// (rtl)
#include <Data.DBConsts.hpp>	// (dbrtl)
#include <Data.SqlTimSt.hpp>	// (dbrtl)
#include <Data.FmtBcd.hpp>	// (dbrtl)
#include <Data.DBCommonTypes.hpp>	// (dbrtl)
#include <Data.DB.hpp>	// (dbrtl)
#include <Vcl.Mask.hpp>	// (vcl)
#include <Vcl.VDBConsts.hpp>	// (vcldb)
#include <Vcl.DBLogDlg.hpp>	// (vcldb)
#include <Vcl.DBPWDlg.hpp>	// (vcldb)
#include <Vcl.DBCtrls.hpp>	// (vcldb)
#include <ovcconst.hpp>	// (OrpheusDR)
#include <ovcdate.hpp>	// (OrpheusDR)
#include <o32sr.hpp>	// (OrpheusDR)
#include <ovcdata.hpp>	// (OrpheusDR)
#include <ovcstr.hpp>	// (OrpheusDR)
#include <OvcFormatSettings.hpp>	// (OrpheusDR)
#include <ovcintl.hpp>	// (OrpheusDR)
#include <ovcexcpt.hpp>	// (OrpheusDR)
#include <ovcmisc.hpp>	// (OrpheusDR)
#include <ovccmd.hpp>	// (OrpheusDR)
#include <ovcver.hpp>	// (OrpheusDR)
#include <ovctimer.hpp>	// (OrpheusDR)
#include <ovccaret.hpp>	// (OrpheusDR)
#include <ovccolor.hpp>	// (OrpheusDR)
#include <ovcuser.hpp>	// (OrpheusDR)
#include <ovceditf.hpp>	// (OrpheusDR)
#include <ovccalc.hpp>	// (OrpheusDR)
#include <ovcedpop.hpp>	// (OrpheusDR)
#include <ovcedclc.hpp>	// (OrpheusDR)
#include <ovcbcalc.hpp>	// (OrpheusDR)
#include <ovcbordr.hpp>	// (OrpheusDR)
#include <ovcef.hpp>	// (OrpheusDR)
#include <ovcbase.hpp>	// (OrpheusDR)
#include <ovcpb.hpp>	// (OrpheusDR)
#include <ovcnf.hpp>	// (OrpheusDR)
#include <ovcpf.hpp>	// (OrpheusDR)
#include <ovcsf.hpp>	// (OrpheusDR)
#include <ovccal.hpp>	// (OrpheusDR)
#include <ovccmbx.hpp>	// (OrpheusDR)
#include <ovcclrcb.hpp>	// (OrpheusDR)
#include <o32ledlabel.hpp>	// (OrpheusDR)
#include <ovcclock.hpp>	// (OrpheusDR)
#include <ovcedcal.hpp>	// (OrpheusDR)
#include <ovcrlbl.hpp>	// (OrpheusDR)
#include <Winapi.MMSystem.hpp>	// (rtl)
#include <ovceditu.hpp>	// (OrpheusDR)
#include <ovceditn.hpp>	// (OrpheusDR)
#include <ovcfxfnt.hpp>	// (OrpheusDR)
#include <ovceditp.hpp>	// (OrpheusDR)
#include <ovcedit.hpp>	// (OrpheusDR)
#include <ovcdlg.hpp>	// (OrpheusDR)
#include <ovcplb.hpp>	// (OrpheusDR)
#include <ovcdlm.hpp>	// (OrpheusDR)
#include <ovcfiler.hpp>	// (OrpheusDR)
#include <ovcdrag.hpp>	// (OrpheusDR)
#include <ovcbtnhd.hpp>	// (OrpheusDR)
#include <ovcvlb.hpp>	// (OrpheusDR)
#include <ovccoco.hpp>	// (OrpheusDR)
#include <ovcrvexp.hpp>	// (OrpheusDR)
#include <ovcvcped.hpp>	// (OrpheusDR)
#include <ovcviewed.hpp>	// (OrpheusDR)
#include <ovcflded.hpp>	// (OrpheusDR)
#include <ovcrvpv.hpp>	// (OrpheusDR)
#include <ovcrptvw.hpp>	// (OrpheusDR)
#include <ovcrvexpdef.hpp>	// (OrpheusDR)
#include <ovcrvidx.hpp>	// (OrpheusDR)
#include <ovcslide.hpp>	// (OrpheusDR)
#include <ovcedsld.hpp>	// (OrpheusDR)
#include <ovctcmmn.hpp>	// (OrpheusDR)
#include <ovcspary.hpp>	// (OrpheusDR)
#include <ovctcell.hpp>	// (OrpheusDR)
#include <ovctcary.hpp>	// (OrpheusDR)
#include <ovctsell.hpp>	// (OrpheusDR)
#include <ovctcstr.hpp>	// (OrpheusDR)
#include <ovctchdr.hpp>	// (OrpheusDR)
#include <ovctgpns.hpp>	// (OrpheusDR)
#include <ovctbclr.hpp>	// (OrpheusDR)
#include <ovctbrws.hpp>	// (OrpheusDR)
#include <ovctbcls.hpp>	// (OrpheusDR)
#include <ovctable.hpp>	// (OrpheusDR)
#include <ovctcbef.hpp>	// (OrpheusDR)
#include <ovctcbmp.hpp>	// (OrpheusDR)
#include <ovctgres.hpp>	// (OrpheusDR)
#include <ovctcgly.hpp>	// (OrpheusDR)
#include <ovctcbox.hpp>	// (OrpheusDR)
#include <ovctccbx.hpp>	// (OrpheusDR)
#include <ovctcedt.hpp>	// (OrpheusDR)
#include <ovctcico.hpp>	// (OrpheusDR)
#include <ovctcnum.hpp>	// (OrpheusDR)
#include <ovctcpic.hpp>	// (OrpheusDR)
#include <ovctcsim.hpp>	// (OrpheusDR)
#include <OvcTCHeaderExtended.hpp>	// (OrpheusDR)
#include <ovcedtim.hpp>	// (OrpheusDR)
#include <o32editf.hpp>	// (OrpheusDR)
#include <o32bordr.hpp>	// (OrpheusDR)
#include <o32vldtr.hpp>	// (OrpheusDR)
#include <o32vlop1.hpp>	// (OrpheusDR)
#include <o32vlreg.hpp>	// (OrpheusDR)
#include <o32ovldr.hpp>	// (OrpheusDR)
#include <o32pvldr.hpp>	// (OrpheusDR)
#include <o32intdeq.hpp>	// (OrpheusDR)
#include <o32intlst.hpp>	// (OrpheusDR)
#include <O32WideCharSet.hpp>	// (OrpheusDR)
#include <o32rxngn.hpp>	// (OrpheusDR)
#include <o32rxvld.hpp>	// (OrpheusDR)
#include <o32flxed.hpp>	// (OrpheusDR)
#include <OvcUtils.hpp>	// (OrpheusDR)

//-- user supplied -----------------------------------------------------------

namespace Orpheusdbdr
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Orpheusdbdr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ORPHEUSDBDR)
using namespace Orpheusdbdr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OrpheusdbdrHPP
