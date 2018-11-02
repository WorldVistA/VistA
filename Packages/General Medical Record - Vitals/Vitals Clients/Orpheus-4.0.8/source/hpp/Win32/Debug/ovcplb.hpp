// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcplb.pas' rev: 29.00 (Windows)

#ifndef OvcplbHPP
#define OvcplbHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <ovcdata.hpp>
#include <ovcintl.hpp>
#include <ovcrlbl.hpp>
#include <ovcstr.hpp>
#include <ovcuser.hpp>
#include <ovcdate.hpp>
#include <ovcmisc.hpp>
#include <ovcbase.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcplb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomPictureLabel;
class DELPHICLASS TOvcPictureLabel;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TPictureLabelDataType : unsigned char { plNone, plBoolean, plYesNo, plDate, plFloat, plInteger, plStDate, plStTime, plString, plTime };

class PASCALIMPLEMENTATION TOvcCustomPictureLabel : public Ovcrlbl::TOvcCustomRotatedLabel
{
	typedef Ovcrlbl::TOvcCustomRotatedLabel inherited;
	
protected:
	System::UnicodeString FString;
	bool FBoolean;
	System::TDateTime FDate;
	System::Extended FExtended;
	int FLongInt;
	int FStDate;
	int FStTime;
	System::TDateTime FTime;
	TPictureLabelDataType FDataType;
	Ovcintl::TOvcIntlSup* FIntlSupport;
	System::UnicodeString FPictureMask;
	System::StaticArray<System::Byte, 255> FPictureFlags;
	bool FUseIntlMask;
	Ovcuser::TOvcUserData* FUserData;
	void __fastcall SetAsBoolean(const bool Value);
	void __fastcall SetAsDate(const System::TDateTime Value);
	void __fastcall SetAsFloat(const System::Extended Value);
	void __fastcall SetAsInteger(const int Value);
	void __fastcall SetAsStDate(const int Value);
	void __fastcall SetAsStTime(const int Value);
	void __fastcall SetAsString(const System::UnicodeString Value);
	void __fastcall SetAsTime(const System::TDateTime Value);
	void __fastcall SetAsVariant(const System::Variant &Value);
	void __fastcall SetAsYesNo(const bool Value);
	void __fastcall SetIntlSupport(Ovcintl::TOvcIntlSup* Value);
	void __fastcall SetPictureMask(const System::UnicodeString Value);
	void __fastcall SetUseIntlMask(bool Value);
	void __fastcall SetUserData(Ovcuser::TOvcUserData* Value);
	void __fastcall plCalcWidthAndPlaces(System::Word &Width, System::Word &Places);
	void __fastcall plFixCase(System::WideChar PicChar, System::WideChar &Ch, System::WideChar PrevCh);
	void __fastcall plFixDecimalPoint(System::UnicodeString &S);
	System::UnicodeString __fastcall plGetDisplayString(void);
	void __fastcall plInitPictureFlags(void);
	bool __fastcall plIsLiteral(System::Word N);
	bool __fastcall plIsSemiLiteral(System::Word N);
	System::UnicodeString __fastcall plMergePicture(const System::UnicodeString Src);
	void __fastcall plReadParentFont(System::Classes::TReader* Reader);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	DYNAMIC System::UnicodeString __fastcall plGetSampleDisplayData(void);
	__property System::UnicodeString PictureMask = {read=FPictureMask, write=SetPictureMask};
	__property bool UseIntlMask = {read=FUseIntlMask, write=SetUseIntlMask, nodefault};
	
public:
	__fastcall virtual TOvcCustomPictureLabel(System::Classes::TComponent* AOwner);
	virtual void __fastcall PaintTo(HDC DC, int X, int Y);
	void __fastcall Clear(void);
	virtual System::UnicodeString __fastcall GetDisplayString(void);
	__property bool AsBoolean = {write=SetAsBoolean, nodefault};
	__property System::TDateTime AsDate = {write=SetAsDate};
	__property System::Extended AsFloat = {write=SetAsFloat};
	__property int AsInteger = {write=SetAsInteger, nodefault};
	__property System::UnicodeString AsString = {write=SetAsString};
	__property System::TDateTime AsTime = {write=SetAsTime};
	__property System::Variant AsVariant = {write=SetAsVariant};
	__property int AsStDate = {write=SetAsStDate, nodefault};
	__property int AsStTime = {write=SetAsStTime, nodefault};
	__property bool AsYesNo = {write=SetAsYesNo, nodefault};
	__property Canvas;
	__property Ovcintl::TOvcIntlSup* IntlSupport = {read=FIntlSupport, write=SetIntlSupport};
	__property System::UnicodeString Text = {read=GetDisplayString, write=SetAsString};
	__property Ovcuser::TOvcUserData* UserData = {read=FUserData, write=SetUserData};
public:
	/* TOvcGraphicControl.Destroy */ inline __fastcall virtual ~TOvcCustomPictureLabel(void) { }
	
};


class PASCALIMPLEMENTATION TOvcPictureLabel : public TOvcCustomPictureLabel
{
	typedef TOvcCustomPictureLabel inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property AutoSize;
	__property Caption;
	__property Color = {default=-16777211};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property FontAngle = {default=0};
	__property OriginX = {default=0};
	__property OriginY = {default=0};
	__property ParentColor = {default=1};
	__property ParentShowHint = {default=1};
	__property PictureMask = {default=0};
	__property PopupMenu;
	__property ShadowColor = {default=-16777200};
	__property ShadowedText = {default=0};
	__property ShowHint;
	__property Transparent = {default=0};
	__property UseIntlMask;
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TOvcCustomPictureLabel.Create */ inline __fastcall virtual TOvcPictureLabel(System::Classes::TComponent* AOwner) : TOvcCustomPictureLabel(AOwner) { }
	
public:
	/* TOvcGraphicControl.Destroy */ inline __fastcall virtual ~TOvcPictureLabel(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcplb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCPLB)
using namespace Ovcplb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcplbHPP
