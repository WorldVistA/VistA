// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OvcTCHeaderExtended.pas' rev: 29.00 (Windows)

#ifndef OvctcheaderextendedHPP
#define OvctcheaderextendedHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcstr.hpp>
#include <ovcmisc.hpp>
#include <ovctchdr.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcheaderextended
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCColHeadExtendedInfoItem;
class DELPHICLASS TOvcTCColHeadExtendedInfoItems;
class DELPHICLASS TOvcTCColHeadExtendedInfo;
class DELPHICLASS TOvcTCColHeadExtended;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcTCColHeadExtendedInfoItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FCaption;
	Vcl::Graphics::TIcon* FIcon;
	bool FShowCaption;
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetIcon(Vcl::Graphics::TIcon* const Value);
	void __fastcall SetShowCaption(const bool Value);
	
protected:
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	
public:
	__fastcall virtual TOvcTCColHeadExtendedInfoItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TOvcTCColHeadExtendedInfoItem(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property Vcl::Graphics::TIcon* Icon = {read=FIcon, write=SetIcon};
	__property bool ShowCaption = {read=FShowCaption, write=SetShowCaption, default=1};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcTCColHeadExtendedInfoItems : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TOvcTCColHeadExtendedInfoItem* operator[](int Index) { return Items[Index]; }
	
private:
	HIDESBASE TOvcTCColHeadExtendedInfoItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcTCColHeadExtendedInfoItem* const Value);
	
protected:
	virtual void __fastcall Update(System::Classes::TCollectionItem* Item);
	
public:
	__fastcall TOvcTCColHeadExtendedInfoItems(System::Classes::TPersistent* AOwner);
	HIDESBASE TOvcTCColHeadExtendedInfoItem* __fastcall Add(void);
	__property TOvcTCColHeadExtendedInfoItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
	void __fastcall ExchangeItems(int I, int J);
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TOvcTCColHeadExtendedInfoItems(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcTCColHeadExtendedInfo : public TOvcTCColHeadExtendedInfoItem
{
	typedef TOvcTCColHeadExtendedInfoItem inherited;
	
public:
	__fastcall TOvcTCColHeadExtendedInfo(void);
public:
	/* TOvcTCColHeadExtendedInfoItem.Destroy */ inline __fastcall virtual ~TOvcTCColHeadExtendedInfo(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcTCColHeadExtended : public Ovctchdr::TOvcTCCustomColHead
{
	typedef Ovctchdr::TOvcTCCustomColHead inherited;
	
protected:
	TOvcTCColHeadExtendedInfoItems* FHeadings;
	void __fastcall SetHeadings(TOvcTCColHeadExtendedInfoItems* H);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	
public:
	virtual void __fastcall chColumnsChanged(int ColNum1, int ColNum2, Ovctcmmn::TOvcTblActions Action);
	__fastcall virtual TOvcTCColHeadExtended(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcTCColHeadExtended(void);
	
__published:
	__property TOvcTCColHeadExtendedInfoItems* Headings = {read=FHeadings, write=SetHeadings};
	__property About = {default=0};
	__property Adjust = {default=0};
	__property Color;
	__property Font;
	__property Margin = {default=4};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property UseASCIIZStrings = {default=1};
	__property UseWordWrap = {default=0};
	__property ShowEllipsis = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnOwnerDraw;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcheaderextended */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCHEADEREXTENDED)
using namespace Ovctcheaderextended;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcheaderextendedHPP
