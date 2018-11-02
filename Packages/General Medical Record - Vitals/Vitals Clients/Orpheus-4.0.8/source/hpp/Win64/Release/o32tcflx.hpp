// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32tcflx.pas' rev: 29.00 (Windows)

#ifndef O32tcflxHPP
#define O32tcflxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcstr.hpp>
#include <o32flxed.hpp>
#include <o32bordr.hpp>
#include <ovcef.hpp>
#include <ovccmd.hpp>
#include <o32vlop1.hpp>
#include <o32vldtr.hpp>
#include <o32editf.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32tcflx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32TCValidatorOptions;
class DELPHICLASS TO32TCFlexEditEditor;
class DELPHICLASS TO32TCBorderProperties;
class DELPHICLASS TO32TCEditorProperties;
class DELPHICLASS TO32TCCustomFlexEdit;
class DELPHICLASS TO32TCFlexEdit;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TTCFEUserValidationEvent)(System::TObject* Sender, System::UnicodeString Value, bool &ValidEntry);

class PASCALIMPLEMENTATION TO32TCValidatorOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	O32vlop1::TValidationType FValidationType;
	System::UnicodeString FValidatorType;
	O32vldtr::TValidatorClass FValidatorClass;
	System::UnicodeString FMask;
	bool FLastValid;
	System::Word FLastErrorCode;
	bool FBeepOnError;
	bool FInputRequired;
	void __fastcall SetValidatorType(const System::UnicodeString VType);
	void __fastcall AssignValidator(void);
	
public:
	__fastcall TO32TCValidatorOptions(void);
	__property bool LastValid = {read=FLastValid, write=FLastValid, nodefault};
	__property System::Word LastErrorCode = {read=FLastErrorCode, write=FLastErrorCode, nodefault};
	__property O32vldtr::TValidatorClass ValidatorClass = {read=FValidatorClass, write=FValidatorClass, stored=true};
	
__published:
	__property bool BeepOnError = {read=FBeepOnError, write=FBeepOnError, stored=true, nodefault};
	__property bool InputRequired = {read=FInputRequired, write=FInputRequired, stored=true, nodefault};
	__property System::UnicodeString ValidatorType = {read=FValidatorType, write=SetValidatorType, stored=true};
	__property O32vlop1::TValidationType ValidationType = {read=FValidationType, write=FValidationType, stored=true, nodefault};
	__property System::UnicodeString Mask = {read=FMask, write=FMask, stored=true};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TO32TCValidatorOptions(void) { }
	
};


class PASCALIMPLEMENTATION TO32TCFlexEditEditor : public O32flxed::TO32CustomFlexEdit
{
	typedef O32flxed::TO32CustomFlexEdit inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
	virtual bool __fastcall ValidateSelf(void);
public:
	/* TO32CustomFlexEdit.Create */ inline __fastcall virtual TO32TCFlexEditEditor(System::Classes::TComponent* AOwner) : O32flxed::TO32CustomFlexEdit(AOwner) { }
	/* TO32CustomFlexEdit.Destroy */ inline __fastcall virtual ~TO32TCFlexEditEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32TCFlexEditEditor(HWND ParentWindow) : O32flxed::TO32CustomFlexEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32TCBorderProperties : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	bool FActive;
	System::Uitypes::TColor FFlatColor;
	O32bordr::TO32BorderStyle FBorderStyle;
	
public:
	__fastcall virtual TO32TCBorderProperties(void);
	
__published:
	__property bool Active = {read=FActive, write=FActive, nodefault};
	__property System::Uitypes::TColor FlatColor = {read=FFlatColor, write=FFlatColor, nodefault};
	__property O32bordr::TO32BorderStyle BorderStyle = {read=FBorderStyle, write=FBorderStyle, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TO32TCBorderProperties(void) { }
	
};


class PASCALIMPLEMENTATION TO32TCEditorProperties : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Classes::TAlignment FAlignment;
	O32bordr::TO32Borders* FBorders;
	Vcl::Graphics::TBitmap* FButtonGlyph;
	System::Uitypes::TColor FColor;
	System::Uitypes::TCursor FCursor;
	int FMaxLines;
	bool FShowButton;
	System::WideChar FPasswordChar;
	bool FReadOnly;
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	
public:
	__fastcall virtual TO32TCEditorProperties(void);
	__fastcall virtual ~TO32TCEditorProperties(void);
	__property O32bordr::TO32Borders* Borders = {read=FBorders, write=FBorders};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=FAlignment, nodefault};
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph};
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, nodefault};
	__property System::Uitypes::TCursor Cursor = {read=FCursor, write=FCursor, nodefault};
	__property int MaxLines = {read=FMaxLines, write=FMaxLines, nodefault};
	__property System::WideChar PasswordChar = {read=FPasswordChar, write=FPasswordChar, default=0};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, nodefault};
	__property bool ShowButton = {read=FShowButton, write=FShowButton, nodefault};
};


class PASCALIMPLEMENTATION TO32TCCustomFlexEdit : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
protected:
	TO32TCBorderProperties* FBorderProps;
	TO32TCFlexEditEditor* FEdit;
	TO32TCEditorProperties* FEditorOptions;
	System::Word FMaxLength;
	TO32TCValidatorOptions* FValidation;
	bool FWantReturns;
	bool FWantTabs;
	bool FWordWrap;
	Ovcef::TValidationErrorEvent FOnError;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	TTCFEUserValidationEvent FOnUserValidation;
	O32flxed::TO32feButtonClickEvent FOnButtonClick;
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	bool __fastcall GetModified(void);
	__property System::Word MaxLength = {read=FMaxLength, write=FMaxLength, stored=true, nodefault};
	__property bool WantReturns = {read=FWantReturns, write=FWantReturns, stored=true, nodefault};
	__property bool WantTabs = {read=FWantTabs, write=FWantTabs, stored=true, nodefault};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, stored=true, nodefault};
	__property TO32TCBorderProperties* EditorBorders = {read=FBorderProps, write=FBorderProps};
	__property O32flxed::TO32feButtonClickEvent OnButtonClick = {read=FOnButtonClick, write=FOnButtonClick};
	__property TO32TCValidatorOptions* Validation = {read=FValidation, write=FValidation};
	
public:
	__fastcall virtual TO32TCCustomFlexEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32TCCustomFlexEdit(void);
	virtual TO32TCFlexEditEditor* __fastcall CreateEditControl(System::Classes::TComponent* AOwner);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual bool __fastcall CanSaveEditedData(bool SaveValue);
	virtual void __fastcall SaveEditedData(void * Data);
	bool __fastcall ValidateEntry(void);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
	__property bool Modified = {read=GetModified, nodefault};
	__property TO32TCEditorProperties* EditorOptions = {read=FEditorOptions, write=FEditorOptions};
	__property TTCFEUserValidationEvent OnUserValidation = {read=FOnUserValidation, write=FOnUserValidation};
};


class PASCALIMPLEMENTATION TO32TCFlexEdit : public TO32TCCustomFlexEdit
{
	typedef TO32TCCustomFlexEdit inherited;
	
__published:
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property DataStringType = {default=2};
	__property EditorBorders;
	__property Color;
	__property EditorOptions;
	__property EllipsisMode = {default=2};
	__property Font;
	__property Hint = {default=0};
	__property IgnoreCR = {default=1};
	__property Margin = {default=4};
	__property MaxLength = {default=255};
	__property ShowHint = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property Validation;
	__property WantReturns = {default=0};
	__property WantTabs = {default=0};
	__property WordWrap = {default=0};
	__property UseWordWrap = {default=1};
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
	__property OnOwnerDraw;
	__property OnUserValidation;
public:
	/* TO32TCCustomFlexEdit.Create */ inline __fastcall virtual TO32TCFlexEdit(System::Classes::TComponent* AOwner) : TO32TCCustomFlexEdit(AOwner) { }
	/* TO32TCCustomFlexEdit.Destroy */ inline __fastcall virtual ~TO32TCFlexEdit(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32tcflx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32TCFLX)
using namespace O32tcflx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32tcflxHPP
