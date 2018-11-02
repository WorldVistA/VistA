// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccaret.pas' rev: 29.00 (Windows)

#ifndef OvccaretHPP
#define OvccaretHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccaret
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCaret;
class DELPHICLASS TOvcSingleCaret;
class DELPHICLASS TOvcCaretPair;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcCaretShape : unsigned char { csBlock, csHalfBlock, csVertLine, csHorzLine, csCustom, csBitmap };

enum DECLSPEC_DENUM TOvcCaretAlign : unsigned char { caLeft, caTop, caRight, caBottom, caCenter };

class PASCALIMPLEMENTATION TOvcCaret : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TOvcCaretAlign FAlign;
	Vcl::Graphics::TBitmap* FBitmap;
	int FBitmapX;
	int FBitmapY;
	System::Word FBlinkTime;
	int FCaretHt;
	int FCaretWd;
	bool FIsGray;
	TOvcCaretShape FShape;
	System::Classes::TNotifyEvent FOnChange;
	System::Word RefCount;
	void __fastcall SetAlign(TOvcCaretAlign A);
	void __fastcall SetBitmap(Vcl::Graphics::TBitmap* BM);
	void __fastcall SetBitmapX(int X);
	void __fastcall SetBitmapY(int Y);
	void __fastcall SetBlinkTime(System::Word BT);
	void __fastcall SetCaretHeight(int CH);
	void __fastcall SetCaretWidth(int CW);
	void __fastcall SetIsGray(bool IG);
	void __fastcall SetShape(TOvcCaretShape S);
	void __fastcall NotifyChange(void);
	
public:
	__fastcall TOvcCaret(void);
	__fastcall virtual ~TOvcCaret(void);
	void __fastcall Register(void);
	void __fastcall Deregister(void);
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
__published:
	__property Vcl::Graphics::TBitmap* Bitmap = {read=FBitmap, write=SetBitmap};
	__property int BitmapHotSpotX = {read=FBitmapX, write=SetBitmapX, default=0};
	__property int BitmapHotSpotY = {read=FBitmapY, write=SetBitmapY, default=0};
	__property TOvcCaretShape Shape = {read=FShape, write=SetShape, default=2};
	__property TOvcCaretAlign Align = {read=FAlign, write=SetAlign, default=0};
	__property System::Word BlinkTime = {read=FBlinkTime, write=SetBlinkTime, default=0};
	__property int CaretHeight = {read=FCaretHt, write=SetCaretHeight, default=10};
	__property int CaretWidth = {read=FCaretWd, write=SetCaretWidth, default=2};
	__property bool IsGray = {read=FIsGray, write=SetIsGray, default=0};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcSingleCaret : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TOvcCaret* FCaretType;
	int FHeight;
	bool FLinked;
	System::Types::TPoint FPos;
	bool FVisible;
	int FWidth;
	System::Word OrigBlinkTime;
	Vcl::Controls::TWinControl* Owner;
	int XOffset;
	int YOffset;
	void __fastcall SetCaretType(TOvcCaret* CT);
	void __fastcall SetCellHeight(int CH);
	void __fastcall SetCellWidth(int CW);
	void __fastcall SetLinked(bool L);
	void __fastcall SetPos(const System::Types::TPoint &P);
	void __fastcall SetVisible(bool V);
	void __fastcall MakeShape(void);
	void __fastcall Reinit(void);
	void __fastcall ResetPos(void);
	
public:
	__fastcall TOvcSingleCaret(Vcl::Controls::TWinControl* AOwner);
	__fastcall virtual ~TOvcSingleCaret(void);
	void __fastcall CaretTypeHasChanged(System::TObject* Sender);
	__property TOvcCaret* CaretType = {read=FCaretType, write=SetCaretType};
	__property int CellHeight = {read=FHeight, write=SetCellHeight, nodefault};
	__property int CellWidth = {read=FWidth, write=SetCellWidth, nodefault};
	__property bool Linked = {read=FLinked, write=SetLinked, stored=false, nodefault};
	__property System::Types::TPoint Position = {read=FPos, write=SetPos};
	__property bool Visible = {read=FVisible, write=SetVisible, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcCaretPair : public TOvcSingleCaret
{
	typedef TOvcSingleCaret inherited;
	
protected:
	bool FInsMode;
	TOvcCaret* FInsCaretType;
	TOvcCaret* FOvrCaretType;
	void __fastcall SetInsMode(bool IM);
	void __fastcall SetInsCaretType(TOvcCaret* ICT);
	void __fastcall SetOvrCaretType(TOvcCaret* OCT);
	
public:
	__fastcall TOvcCaretPair(Vcl::Controls::TWinControl* AOwner);
	__fastcall virtual ~TOvcCaretPair(void);
	__property bool InsertMode = {read=FInsMode, write=SetInsMode, nodefault};
	__property TOvcCaret* InsCaretType = {read=FInsCaretType, write=SetInsCaretType};
	__property TOvcCaret* OvrCaretType = {read=FOvrCaretType, write=SetOvrCaretType};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovccaret */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCARET)
using namespace Ovccaret;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccaretHPP
