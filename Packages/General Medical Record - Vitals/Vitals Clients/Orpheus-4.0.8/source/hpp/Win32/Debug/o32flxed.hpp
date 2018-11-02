// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32flxed.pas' rev: 29.00 (Windows)

#ifndef O32flxedHPP
#define O32flxedHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <ovcdata.hpp>
#include <o32editf.hpp>
#include <ovcef.hpp>
#include <Vcl.Graphics.hpp>
#include <o32sr.hpp>
#include <o32bordr.hpp>
#include <o32vldtr.hpp>
#include <o32vlop1.hpp>
#include <o32ovldr.hpp>
#include <o32pvldr.hpp>
#include <o32rxvld.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.UITypes.hpp>
#include <ovcbase.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32flxed
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32FEButton;
class DELPHICLASS TFlexEditValidatorOptions;
class DELPHICLASS TO32EditLines;
class DELPHICLASS TFlexEditStrings;
class DELPHICLASS TO32CustomFlexEdit;
class DELPHICLASS TO32FlexEdit;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TO32PopupAnchor : unsigned char { paLeft, paRight };

class PASCALIMPLEMENTATION TO32FEButton : public Vcl::Buttons::TBitBtn
{
	typedef Vcl::Buttons::TBitBtn inherited;
	
public:
	__fastcall virtual TO32FEButton(System::Classes::TComponent* AOwner);
	DYNAMIC void __fastcall Click(void);
public:
	/* TBitBtn.Destroy */ inline __fastcall virtual ~TO32FEButton(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32FEButton(HWND ParentWindow) : Vcl::Buttons::TBitBtn(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TO32feButtonClickEvent)(TO32CustomFlexEdit* Sender, const System::Types::TPoint &PopupPoint);

typedef void __fastcall (__closure *TFEUserValidationEvent)(System::TObject* Sender, bool &ValidEntry);

typedef void __fastcall (__closure *TFEValidationErrorEvent)(System::TObject* Sender, System::Word ErrorCode, System::UnicodeString ErrorMsg);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TFlexEditValidatorOptions : public O32vlop1::TValidatorOptions
{
	typedef O32vlop1::TValidatorOptions inherited;
	
__published:
	__property InputRequired;
public:
	/* TValidatorOptions.Create */ inline __fastcall TFlexEditValidatorOptions(Vcl::Controls::TWinControl* AOwner) : O32vlop1::TValidatorOptions(AOwner) { }
	/* TValidatorOptions.Destroy */ inline __fastcall virtual ~TFlexEditValidatorOptions(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32EditLines : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TO32CustomFlexEdit* FlexEdit;
	int FMaxLines;
	int FDefaultLines;
	int FFocusedLines;
	int FMouseOverLines;
	void __fastcall SetDefaultLines(int Value);
	void __fastcall SetMaxLines(int Value);
	void __fastcall SetFocusedLines(int Value);
	void __fastcall SetMouseOverLines(int Value);
	
public:
	__fastcall virtual TO32EditLines(void);
	__fastcall virtual ~TO32EditLines(void);
	
__published:
	__property int MaxLines = {read=FMaxLines, write=SetMaxLines, default=3};
	__property int DefaultLines = {read=FDefaultLines, write=SetDefaultLines, default=1};
	__property int FocusedLines = {read=FFocusedLines, write=SetFocusedLines, default=3};
	__property int MouseOverLines = {read=FMouseOverLines, write=SetMouseOverLines, default=3};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TFlexEditStrings : public System::Classes::TStrings
{
	typedef System::Classes::TStrings inherited;
	
protected:
	int FCapacity;
	virtual System::UnicodeString __fastcall Get(int Index);
	virtual int __fastcall GetCount(void);
	virtual System::UnicodeString __fastcall GetTextStr(void);
	virtual void __fastcall Put(int Index, const System::UnicodeString S);
	virtual void __fastcall SetTextStr(const System::UnicodeString Value);
	virtual void __fastcall SetUpdateState(bool Updating);
	
public:
	Vcl::Stdctrls::TCustomEdit* FlexEdit;
	virtual void __fastcall Clear(void);
	virtual void __fastcall SetCapacity(int NewCapacity);
	virtual void __fastcall Delete(int Index);
	virtual void __fastcall Insert(int Index, const System::UnicodeString S);
public:
	/* TStrings.Create */ inline __fastcall TFlexEditStrings(void) : System::Classes::TStrings() { }
	/* TStrings.Destroy */ inline __fastcall virtual ~TFlexEditStrings(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TO32CustomFlexEdit : public O32editf::TO32CustomEdit
{
	typedef O32editf::TO32CustomEdit inherited;
	
protected:
	System::Classes::TAlignment FAlignment;
	O32bordr::TO32Borders* FBorders;
	TO32FEButton* FButton;
	Vcl::Graphics::TBitmap* FButtonGlyph;
	Vcl::Controls::TControlCanvas* FCanvas;
	TO32EditLines* FEditLines;
	Ovcef::TOvcEfColors* FEFColors;
	int FDisplayedLines;
	int FMaxLines;
	TFlexEditStrings* FStrings;
	TO32PopupAnchor FPopupAnchor;
	bool FShowButton;
	bool FWordWrap;
	bool FWantReturns;
	bool FWantTabs;
	bool FMouseInControl;
	TFlexEditValidatorOptions* FValidation;
	int FValidationError;
	TO32feButtonClickEvent FOnButtonClick;
	TFEUserValidationEvent FOnUserValidation;
	TFEValidationErrorEvent FOnValidationError;
	System::Classes::TNotifyEvent FBeforeValidation;
	System::Classes::TNotifyEvent FAfterValidation;
	System::UnicodeString FSaveEdit;
	bool FCreating;
	System::Uitypes::TColor FColor;
	System::Uitypes::TColor FFontColor;
	int FUpdating;
	bool feValid;
	int FPainting;
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetShowButton(bool Value);
	bool __fastcall GetBoolean(void);
	bool __fastcall GetYesNo(void);
	System::TDateTime __fastcall GetDateTime(void);
	double __fastcall GetDouble(void);
	System::Extended __fastcall GetExtended(void);
	int __fastcall GetInteger(void);
	System::Classes::TStrings* __fastcall GetStrings(void);
	System::Variant __fastcall GetVariant(void);
	HIDESBASE System::UnicodeString __fastcall GetText(void);
	virtual System::Uitypes::TColor __fastcall GetColor(void);
	void __fastcall SetBoolean(bool Value);
	void __fastcall SetYesNo(bool Value);
	void __fastcall SetDateTime(System::TDateTime Value);
	void __fastcall SetDouble(double Value);
	void __fastcall SetExtended(System::Extended Value);
	void __fastcall SetInteger(int Value);
	void __fastcall SetStrings(System::Classes::TStrings* Value);
	void __fastcall SetVariant(const System::Variant &Value);
	void __fastcall SetDisplayedLines(int Value);
	void __fastcall SetWordWrap(bool Value);
	void __fastcall SetWantReturns(bool Value);
	void __fastcall SetWantTabs(bool Value);
	HIDESBASE void __fastcall SetText(const System::UnicodeString Value);
	HIDESBASE virtual void __fastcall SetColor(System::Uitypes::TColor Value);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMGotFocus(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMLostFocus(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TWMNCPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	MESSAGE void __fastcall OMValidate(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall OMRecreateWnd(Winapi::Messages::TMessage &Message);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* Value);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall CreateWindowHandle(const Vcl::Controls::TCreateParams &Params);
	HIDESBASE void __fastcall AdjustHeight(void);
	DYNAMIC void __fastcall GlyphChanged(void);
	virtual void __fastcall Loaded(void);
	HIDESBASE void __fastcall SetAlignment(System::Classes::TAlignment Value);
	bool __fastcall MultiLineEnabled(void);
	int __fastcall GetButtonWidth(void);
	DYNAMIC bool __fastcall GetButtonEnabled(void);
	void __fastcall SetMaxLines(int Value);
	virtual bool __fastcall ValidateSelf(void);
	void __fastcall SaveEditString(void);
	virtual void __fastcall DoOnChange(void);
	
public:
	__fastcall virtual TO32CustomFlexEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomFlexEdit(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	DYNAMIC void __fastcall ButtonClick(void);
	virtual void __fastcall Restore(void);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, default=0};
	__property O32bordr::TO32Borders* Borders = {read=FBorders, write=FBorders};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, default=-16777211};
	__property Ovcef::TOvcEfColors* EFColors = {read=FEFColors, write=FEFColors};
	__property TO32EditLines* EditLines = {read=FEditLines, write=FEditLines};
	__property TO32PopupAnchor PopupAnchor = {read=FPopupAnchor, write=FPopupAnchor, nodefault};
	__property bool ShowButton = {read=FShowButton, write=SetShowButton, nodefault};
	__property TFlexEditValidatorOptions* Validation = {read=FValidation, write=FValidation};
	__property bool WantReturns = {read=FWantReturns, write=SetWantReturns, default=0};
	__property bool WantTabs = {read=FWantTabs, write=SetWantTabs, default=0};
	__property bool WordWrap = {read=FWordWrap, write=SetWordWrap, default=0};
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property System::Classes::TStrings* Strings = {read=GetStrings, write=SetStrings};
	__property bool AsBoolean = {read=GetBoolean, write=SetBoolean, nodefault};
	__property bool AsYesNo = {read=GetYesNo, write=SetYesNo, nodefault};
	__property System::TDateTime AsDateTime = {read=GetDateTime, write=SetDateTime};
	__property double AsFloat = {read=GetDouble, write=SetDouble};
	__property System::Extended AsExtended = {read=GetExtended, write=SetExtended};
	__property int AsInteger = {read=GetInteger, write=SetInteger, nodefault};
	__property System::Variant AsVariant = {read=GetVariant, write=SetVariant};
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph};
	__property Vcl::Controls::TControlCanvas* Canvas = {read=FCanvas};
	__property TO32feButtonClickEvent OnButtonClick = {read=FOnButtonClick, write=FOnButtonClick};
	__property TFEUserValidationEvent OnUserValidation = {read=FOnUserValidation, write=FOnUserValidation};
	__property TFEValidationErrorEvent OnValidationError = {read=FOnValidationError, write=FOnValidationError};
	__property System::Classes::TNotifyEvent BeforeValidation = {read=FBeforeValidation, write=FBeforeValidation};
	__property System::Classes::TNotifyEvent AfterValidation = {read=FAfterValidation, write=FAfterValidation};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32CustomFlexEdit(HWND ParentWindow) : O32editf::TO32CustomEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32FlexEdit : public TO32CustomFlexEdit
{
	typedef TO32CustomFlexEdit inherited;
	
__published:
	__property Alignment = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property ParentBiDiMode = {default=1};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property OnEndDock;
	__property OnStartDock;
	__property AutoSize = {default=0};
	__property About = {default=0};
	__property AutoSelect = {default=1};
	__property Borders;
	__property ButtonGlyph;
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property EditLines;
	__property EFColors;
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property LabelInfo;
	__property MaxLength = {default=0};
	__property OEMConvert = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PasswordChar = {default=0};
	__property PopupAnchor = {default=0};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowButton = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Text;
	__property Validation;
	__property Visible = {default=1};
	__property WantReturns = {default=0};
	__property WantTabs = {default=0};
	__property WordWrap = {default=0};
	__property AfterValidation;
	__property BeforeValidation;
	__property OnButtonClick;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property OnUserValidation;
	__property OnValidationError;
public:
	/* TO32CustomFlexEdit.Create */ inline __fastcall virtual TO32FlexEdit(System::Classes::TComponent* AOwner) : TO32CustomFlexEdit(AOwner) { }
	/* TO32CustomFlexEdit.Destroy */ inline __fastcall virtual ~TO32FlexEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32FlexEdit(HWND ParentWindow) : TO32CustomFlexEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32flxed */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32FLXED)
using namespace O32flxed;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32flxedHPP
