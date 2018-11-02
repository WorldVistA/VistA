// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32ledlabel.pas' rev: 29.00 (Windows)

#ifndef O32ledlabelHPP
#define O32ledlabelHPP

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
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <o32sr.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32ledlabel
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32CustomLEDLabel;
class DELPHICLASS TO32LEDLabel;
//-- type declarations -------------------------------------------------------
typedef System::Int8 TSegmentSize;

class PASCALIMPLEMENTATION TO32CustomLEDLabel : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
protected:
	System::Uitypes::TColor FBgColor;
	System::Uitypes::TColor FOffColor;
	System::Uitypes::TColor FOnColor;
	int FColumns;
	int FRows;
	TSegmentSize FSize;
	Vcl::Graphics::TBitmap* lbDrawBmp;
	MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	void __fastcall Initialize(System::Types::TPoint *Points, const int Points_High);
	int __fastcall NewOffset(System::WideChar xOry, int OldOffset);
	void __fastcall ProcessCaption(System::Types::TPoint *Points, const int Points_High);
	void __fastcall PaintSegment(int Segment, System::Uitypes::TColor Color, System::Types::TPoint *Points, const int Points_High, int OffsetX, int OffsetY);
	void __fastcall ResizeControl(int Row, int Col, int Size);
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetSize(TSegmentSize Value);
	void __fastcall SetOnColor(System::Uitypes::TColor Value);
	void __fastcall SetOffColor(System::Uitypes::TColor Value);
	void __fastcall SetRows(int Value);
	void __fastcall SetColumns(int Value);
	void __fastcall SetbgColor(System::Uitypes::TColor Value);
	void __fastcall SelectSegments(System::Word Segment, System::Types::TPoint *Points, const int Points_High, int OffsetX, int OffsetY);
	virtual void __fastcall Paint(void);
	
public:
	__fastcall virtual TO32CustomLEDLabel(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomLEDLabel(void);
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property int Columns = {read=FColumns, write=SetColumns, default=10};
	__property int Rows = {read=FRows, write=SetRows, default=1};
	__property System::Uitypes::TColor BgColor = {read=FBgColor, write=SetbgColor, default=0};
	__property System::Uitypes::TColor OffColor = {read=FOffColor, write=SetOffColor, default=1068618};
	__property System::Uitypes::TColor OnColor = {read=FOnColor, write=SetOnColor, default=65535};
	__property TSegmentSize Size = {read=FSize, write=SetSize, default=2};
	__property Caption = {default=0};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Visible = {default=1};
};


class PASCALIMPLEMENTATION TO32LEDLabel : public TO32CustomLEDLabel
{
	typedef TO32CustomLEDLabel inherited;
	
__published:
	__property About = {default=0};
	__property Caption = {default=0};
	__property Columns = {default=10};
	__property Rows = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property BgColor = {default=0};
	__property OffColor = {default=1068618};
	__property OnColor = {default=65535};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property Size = {default=2};
	__property ShowHint;
	__property Visible = {default=1};
public:
	/* TO32CustomLEDLabel.Create */ inline __fastcall virtual TO32LEDLabel(System::Classes::TComponent* AOwner) : TO32CustomLEDLabel(AOwner) { }
	/* TO32CustomLEDLabel.Destroy */ inline __fastcall virtual ~TO32LEDLabel(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32ledlabel */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32LEDLABEL)
using namespace O32ledlabel;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32ledlabelHPP
