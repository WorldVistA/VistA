// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbtnhd.pas' rev: 29.00 (Windows)

#ifndef OvcbtnhdHPP
#define OvcbtnhdHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovcdrag.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbtnhd
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcButtonHeaderSection;
class DELPHICLASS TOvcButtonHeader;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcButtonHeaderStyle : unsigned char { bhsNone, bhsRadio, bhsButton };

enum DECLSPEC_DENUM TOvcBHDrawingStyle : unsigned char { bhsDefault, bhsThin, bhsFlat, bhsEtched };

class PASCALIMPLEMENTATION TOvcButtonHeaderSection : public Ovcbase::TOvcCollectible
{
	typedef Ovcbase::TOvcCollectible inherited;
	
protected:
	System::Classes::TAlignment FAlignment;
	bool FAllowResize;
	System::UnicodeString FCaption;
	int FImageIndex;
	System::UnicodeString FHint;
	int FLeftImageindex;
	System::Types::TRect FPaintRect;
	bool FVisible;
	int FWidth;
	DYNAMIC void __fastcall Changed(void);
	void __fastcall SetAlignment(System::Classes::TAlignment Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetImageIndex(int Value);
	void __fastcall SetLeftImageIndex(const int Value);
	void __fastcall SetWidth(int Value);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	int __fastcall GetWidth(void);
	void __fastcall SetVisible(const bool Value);
	
public:
	__fastcall virtual TOvcButtonHeaderSection(System::Classes::TComponent* AOwner);
	__property System::Types::TRect PaintRect = {read=FPaintRect};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, default=0};
	__property bool AllowResize = {read=FAllowResize, write=FAllowResize, default=1};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property int ImageIndex = {read=FImageIndex, write=SetImageIndex, default=-1};
	__property System::UnicodeString Hint = {read=FHint, write=FHint};
	__property int LeftImageIndex = {read=FLeftImageindex, write=SetLeftImageIndex, default=-1};
	__property bool Visible = {read=FVisible, write=SetVisible, default=1};
	__property int Width = {read=GetWidth, write=SetWidth, default=75};
public:
	/* TOvcCollectible.Destroy */ inline __fastcall virtual ~TOvcButtonHeaderSection(void) { }
	
};


typedef void __fastcall (__closure *TOvcTextAttrEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, int Index);

typedef void __fastcall (__closure *TOvcButtonHeaderRearrangingEvent)(System::TObject* Sender, int OldIndex, int NewIndex, bool &Allow);

typedef void __fastcall (__closure *TOvcButtonHeaderRearrangedEvent)(System::TObject* Sender, int OldIndex, int NewIndex);

class PASCALIMPLEMENTATION TOvcButtonHeader : public Ovcbase::TOvcCustomControl
{
	typedef Ovcbase::TOvcCustomControl inherited;
	
protected:
	bool FAllowResize;
	bool FAllowDragRearrange;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	TOvcBHDrawingStyle FDrawingStyle;
	Vcl::Controls::TImageList* FLeftImages;
	Vcl::Controls::TImageList* FRightImages;
	int FItemIndex;
	System::Types::TRect FPushRect;
	Ovcbase::TOvcCollection* FSections;
	TOvcButtonHeaderStyle FStyle;
	int FTextMargin;
	bool FWordWrap;
	TOvcTextAttrEvent FOnChangeTextAttr;
	System::Classes::TNotifyEvent FOnClick;
	Vcl::Extctrls::TSectionEvent FOnSized;
	Vcl::Extctrls::TSectionEvent FOnSizing;
	bool bhCanResize;
	int bhMouseOffset;
	int bhResizeSection;
	int bhSectionPressed;
	Vcl::Graphics::TBitmap* bhDraw;
	System::Types::TPoint bhHitTest;
	Ovcdrag::TOvcDragShow* DragShow;
	TOvcButtonHeaderSection* FDragSection;
	TOvcButtonHeaderRearrangedEvent FRearranged;
	TOvcButtonHeaderRearrangingEvent FRearranging;
	int DragStartX;
	int DragStartY;
	bool Dragging;
	TOvcButtonHeaderSection* CurrentItem;
	int MoveFrom;
	int MoveTo;
	bool SectionChanged;
	int __fastcall GetResizeSection(void);
	TOvcButtonHeaderSection* __fastcall GetSection(int Index);
	int __fastcall GetSectionCount(void);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall AncestorNotFound(System::Classes::TReader* Reader, const System::UnicodeString ComponentName, System::Classes::TPersistentClass ComponentClass, System::Classes::TComponent* &Component);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	void __fastcall SetDrawingStyle(const TOvcBHDrawingStyle Value);
	void __fastcall SetLeftImages(Vcl::Controls::TImageList* Value);
	void __fastcall SetRightImages(Vcl::Controls::TImageList* Value);
	void __fastcall SetItemIndex(int Value);
	void __fastcall SetSection(int Index, TOvcButtonHeaderSection* Value);
	void __fastcall SetTextMargin(int Value);
	void __fastcall SetWordWrap(bool Value);
	void __fastcall SetStyle(TOvcButtonHeaderStyle Value);
	void __fastcall bhCollectionChanged(System::TObject* Sender);
	void __fastcall bhGetEditorCaption(System::UnicodeString &Caption);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMHintShow(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall DoOnChangeTextAttr(Vcl::Graphics::TCanvas* Canvas, int Index);
	virtual void __fastcall DoOnClick(void);
	DYNAMIC void __fastcall DoOnSized(int ASection, int AWidth);
	DYNAMIC void __fastcall DoOnSizing(int ASection, int AWidth);
	DYNAMIC bool __fastcall DoRearranging(int OldIndex, int NewIndex);
	DYNAMIC void __fastcall DoRearranged(int OldIndex, int NewIndex);
	
public:
	__fastcall virtual TOvcButtonHeader(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcButtonHeader(void);
	__property TOvcButtonHeaderSection* DragSection = {read=FDragSection};
	__property System::Types::TRect PushRect = {read=FPushRect};
	__property int ResizeSection = {read=GetResizeSection, nodefault};
	__property TOvcButtonHeaderSection* Section[int Index] = {read=GetSection, write=SetSection};
	__property int SectionCount = {read=GetSectionCount, nodefault};
	
__published:
	__property bool AllowDragRearrange = {read=FAllowDragRearrange, write=FAllowDragRearrange, default=0};
	__property bool AllowResize = {read=FAllowResize, write=FAllowResize, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=0};
	__property TOvcBHDrawingStyle DrawingStyle = {read=FDrawingStyle, write=SetDrawingStyle, default=0};
	__property Vcl::Controls::TImageList* Images = {read=FRightImages, write=SetRightImages};
	__property int ItemIndex = {read=FItemIndex, write=SetItemIndex, nodefault};
	__property LabelInfo;
	__property Vcl::Controls::TImageList* LeftImages = {read=FLeftImages, write=SetLeftImages};
	__property Ovcbase::TOvcCollection* Sections = {read=FSections, write=FSections};
	__property TOvcButtonHeaderStyle Style = {read=FStyle, write=SetStyle, default=1};
	__property int TextMargin = {read=FTextMargin, write=SetTextMargin, default=0};
	__property bool WordWrap = {read=FWordWrap, write=SetWordWrap, default=0};
	__property System::Classes::TNotifyEvent OnClick = {read=FOnClick, write=FOnClick};
	__property Vcl::Extctrls::TSectionEvent OnSizing = {read=FOnSizing, write=FOnSizing};
	__property Vcl::Extctrls::TSectionEvent OnSized = {read=FOnSized, write=FOnSized};
	__property TOvcButtonHeaderRearrangingEvent OnRearranging = {read=FRearranging, write=FRearranging};
	__property TOvcButtonHeaderRearrangedEvent OnRearranged = {read=FRearranged, write=FRearranged};
	__property Anchors = {default=3};
	__property Constraints;
	__property Align = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property OnDblClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcButtonHeader(HWND ParentWindow) : Ovcbase::TOvcCustomControl(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcbtnhd */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBTNHD)
using namespace Ovcbtnhd;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbtnhdHPP
