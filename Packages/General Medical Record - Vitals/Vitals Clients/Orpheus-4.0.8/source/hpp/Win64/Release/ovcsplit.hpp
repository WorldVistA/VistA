// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcsplit.pas' rev: 29.00 (Windows)

#ifndef OvcsplitHPP
#define OvcsplitHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcsplit
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcSection;
class DELPHICLASS TOvcSplitter;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TSplitterOrientation : unsigned char { soVertical, soHorizontal };

class PASCALIMPLEMENTATION TOvcSection : public Ovcbase::TOvcCollectibleControl
{
	typedef Ovcbase::TOvcCollectibleControl inherited;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	
public:
	__fastcall virtual TOvcSection(System::Classes::TComponent* AOwner);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	
__published:
	__property Color = {default=-16777201};
	__property Height = {stored=false};
	__property Left = {stored=false};
	__property Top = {stored=false};
	__property Width = {stored=false};
public:
	/* TOvcCollectibleControl.Destroy */ inline __fastcall virtual ~TOvcSection(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSection(HWND ParentWindow) : Ovcbase::TOvcCollectibleControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcSplitter : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	bool FAllowResize;
	bool FAutoScale;
	bool FAutoUpdate;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	TSplitterOrientation FOrientation;
	int FPosition;
	double FRelativePosition;
	System::Uitypes::TColor FColorLeft;
	System::Uitypes::TColor FColorRight;
	bool FShowHandle;
	System::Uitypes::TColor FSplitterColor;
	int FSplitterSize;
	System::Classes::TNotifyEvent FOnOwnerDraw;
	System::Classes::TNotifyEvent FOnResize;
	bool FirstTime;
	Ovcbase::TOvcCollection* FPaneColl;
	bool sCanResize;
	System::Types::TPoint sPos;
	TOvcSection* __fastcall GetSection(int Index);
	void __fastcall SetAutoUpdate(bool Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetColorLeft(System::Uitypes::TColor Value);
	void __fastcall SetColorRight(System::Uitypes::TColor Value);
	void __fastcall SetOrientation(TSplitterOrientation Value);
	void __fastcall SetPosition(int Value);
	void __fastcall SetShowHandle(const bool Value);
	void __fastcall SetSplitterColor(System::Uitypes::TColor Value);
	void __fastcall SetSplitterSize(int Value);
	void __fastcall sDrawSplitter(int X, int Y);
	void __fastcall sInvalidateSplitter(void);
	void __fastcall sSetPositionPrim(int Value);
	void __fastcall sSetSectionInfo(void);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	void __fastcall AncestorNotFound(System::Classes::TReader* Reader, const System::UnicodeString ComponentName, System::Classes::TPersistentClass ComponentClass, System::Classes::TComponent* &Component);
	DYNAMIC void __fastcall Resize(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall DoOnResize(void);
	virtual void __fastcall DoOnOwnerDraw(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	virtual void __fastcall SetName(const System::Classes::TComponentName Value);
	
public:
	__fastcall virtual TOvcSplitter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcSplitter(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall Center(void);
	__property TOvcSection* Section[int Index] = {read=GetSection};
	
__published:
	__property bool AllowResize = {read=FAllowResize, write=FAllowResize, default=1};
	__property bool AutoScale = {read=FAutoScale, write=FAutoScale, default=1};
	__property bool AutoUpdate = {read=FAutoUpdate, write=SetAutoUpdate, default=0};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=0};
	__property System::Uitypes::TColor ColorLeft = {read=FColorLeft, write=SetColorLeft, default=0};
	__property System::Uitypes::TColor ColorRight = {read=FColorRight, write=SetColorRight, default=0};
	__property TSplitterOrientation Orientation = {read=FOrientation, write=SetOrientation, default=0};
	__property int Position = {read=FPosition, write=SetPosition, nodefault};
	__property bool ShowHandle = {read=FShowHandle, write=SetShowHandle, default=0};
	__property System::Uitypes::TColor SplitterColor = {read=FSplitterColor, write=SetSplitterColor, default=-16777208};
	__property int SplitterSize = {read=FSplitterSize, write=SetSplitterSize, default=3};
	__property System::Classes::TNotifyEvent OnOwnerDraw = {read=FOnOwnerDraw, write=FOnOwnerDraw};
	__property System::Classes::TNotifyEvent OnResize = {read=FOnResize, write=FOnResize};
	__property Anchors = {default=3};
	__property Constraints;
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D = {default=1};
	__property Enabled = {default=1};
	__property ParentCtl3D = {default=0};
	__property ParentShowHint = {default=1};
	__property ShowHint;
	__property Visible = {default=1};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSplitter(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcsplit */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSPLIT)
using namespace Ovcsplit;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcsplitHPP
