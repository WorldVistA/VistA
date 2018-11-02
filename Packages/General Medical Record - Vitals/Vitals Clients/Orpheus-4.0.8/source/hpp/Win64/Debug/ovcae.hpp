// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcae.pas' rev: 29.00 (Windows)

#ifndef OvcaeHPP
#define OvcaeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcnf.hpp>
#include <ovcpf.hpp>
#include <ovcsf.hpp>
#include <ovccolor.hpp>
#include <ovcbase.hpp>
#include <ovccmd.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcstr.hpp>
#include <System.UITypes.hpp>
#include <ovcpb.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcae
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcBaseArrayEditor;
class DELPHICLASS TOvcSimpleArrayEditor;
class DELPHICLASS TSimpleCellField;
class DELPHICLASS TOvcPictureArrayEditor;
class DELPHICLASS TPictureCellField;
class DELPHICLASS TOvcNumericArrayEditor;
class DELPHICLASS TNumericCellField;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TGetItemEvent)(System::TObject* Sender, int Index, void * &Value);

typedef void __fastcall (__closure *TGetItemColorEvent)(System::TObject* Sender, int Index, System::Uitypes::TColor &FG, System::Uitypes::TColor &BG);

typedef void __fastcall (__closure *TSelectEvent)(System::TObject* Sender, int NewIndex);

class PASCALIMPLEMENTATION TOvcBaseArrayEditor : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	int FActiveIndex;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	Ovccolor::TOvcColors* FDisabledColors;
	Ovccolor::TOvcColors* FHighlightColors;
	System::Uitypes::TColor FLineColor;
	int FNumItems;
	Ovcef::TOvcEntryFieldOptions FOptions;
	System::WideChar FPadChar;
	int FRowHeight;
	int FTextMargin;
	bool FUseScrollBar;
	System::Classes::TNotifyEvent FOnChange;
	Ovcef::TValidationErrorEvent FOnError;
	TGetItemEvent FOnGetItem;
	TGetItemColorEvent FOnGetItemColor;
	TSelectEvent FOnSelect;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	Ovcef::TUserValidationEvent FOnUserValidation;
	Ovcef::TOvcBaseEntryField* aeCell;
	int aeDivisor;
	int aeHighIndex;
	void *aeItemPtr;
	int aeNumRows;
	Ovcdata::TRangeType aeRangeLo;
	Ovcdata::TRangeType aeRangeHi;
	bool aeRangeLoaded;
	int aeTopIndex;
	int aeVSHigh;
	System::Byte aeDecimalPlaces;
	System::Word aeMaxLength;
	System::UnicodeString __fastcall GetRangeHi(void);
	System::UnicodeString __fastcall GetRangeLo(void);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetLineColor(System::Uitypes::TColor Value);
	void __fastcall SetNumItems(int Value);
	void __fastcall SetOptions(Ovcef::TOvcEntryFieldOptions Value);
	void __fastcall SetPadChar(System::WideChar Value);
	void __fastcall SetRangeHi(const System::UnicodeString Value);
	void __fastcall SetRangeLo(const System::UnicodeString Value);
	void __fastcall SetRowHeight(int Value);
	void __fastcall SetTextMargin(int Value);
	void __fastcall SetUseScrollBar(bool Value);
	void __fastcall aeAdjustIntegralHeight(void);
	void __fastcall aeColorChanged(System::TObject* AColor);
	bool __fastcall aeMakeItemVisible(int Index);
	void __fastcall aePreFocusProcess(void);
	void __fastcall aeReadRangeHi(System::Classes::TStream* Stream);
	void __fastcall aeReadRangeLo(System::Classes::TStream* Stream);
	short __fastcall aeScaleDown(int N);
	int __fastcall aeScaleUp(short N);
	void __fastcall aeSetVScrollPos(void);
	void __fastcall aeSetVScrollRange(void);
	void __fastcall aeUpdateDisplay(bool Scrolled, int OldItem, int NewItem);
	void __fastcall aeWriteRangeHi(System::Classes::TStream* Stream);
	void __fastcall aeWriteRangeLo(System::Classes::TStream* Stream);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall CMGotFocus(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall CMLostFocus(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall aeCreateEditCell(void) = 0 ;
	DYNAMIC System::WideChar * __fastcall aeGetEditString(void) = 0 ;
	DYNAMIC void __fastcall aeGetSampleDisplayData(System::WideChar * P) = 0 ;
	virtual void __fastcall DoGetCellValue(int Index) = 0 ;
	virtual void __fastcall DoGetItemColor(int Index, System::Uitypes::TColor &FG, System::Uitypes::TColor &BG);
	DYNAMIC int __fastcall DoPutCellValue(void) = 0 ;
	DYNAMIC void __fastcall DoOnSelect(int NewIndex);
	virtual void __fastcall SetActiveIndex(int Value) = 0 ;
	
public:
	__fastcall virtual TOvcBaseArrayEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseArrayEditor(void);
	virtual void __fastcall SetFocus(void);
	int __fastcall WriteCellValue(void);
	__property int ItemIndex = {read=FActiveIndex, write=SetActiveIndex, stored=false, nodefault};
	
__published:
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property Ovccolor::TOvcColors* DisabledColors = {read=FDisabledColors, write=FDisabledColors};
	__property Ovccolor::TOvcColors* HighlightColors = {read=FHighlightColors, write=FHighlightColors};
	__property System::Uitypes::TColor LineColor = {read=FLineColor, write=SetLineColor, nodefault};
	__property Ovcef::TOvcEntryFieldOptions Options = {read=FOptions, write=SetOptions, nodefault};
	__property int RowHeight = {read=FRowHeight, write=SetRowHeight, nodefault};
	__property int NumItems = {read=FNumItems, write=SetNumItems, nodefault};
	__property System::WideChar PadChar = {read=FPadChar, write=SetPadChar, nodefault};
	__property System::UnicodeString RangeHi = {read=GetRangeHi, write=SetRangeHi, stored=false};
	__property System::UnicodeString RangeLo = {read=GetRangeLo, write=SetRangeLo, stored=false};
	__property int TextMargin = {read=FTextMargin, write=SetTextMargin, nodefault};
	__property bool UseScrollBar = {read=FUseScrollBar, write=SetUseScrollBar, nodefault};
	__property TGetItemEvent OnGetItem = {read=FOnGetItem, write=FOnGetItem};
	__property TGetItemColorEvent OnGetItemColor = {read=FOnGetItemColor, write=FOnGetItemColor};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property Ovcef::TValidationErrorEvent OnError = {read=FOnError, write=FOnError};
	__property TSelectEvent OnSelect = {read=FOnSelect, write=FOnSelect};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	__property Ovcef::TUserValidationEvent OnUserValidation = {read=FOnUserValidation, write=FOnUserValidation};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Controller;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Height;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property Width;
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
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBaseArrayEditor(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcSimpleArrayEditor : public TOvcBaseArrayEditor
{
	typedef TOvcBaseArrayEditor inherited;
	
protected:
	Ovcsf::TSimpleDataType aeDataType;
	System::WideChar aePictureMask;
	void __fastcall SetArrayDataType(Ovcsf::TSimpleDataType Value);
	void __fastcall SetDecimalPlaces(System::Byte Value);
	void __fastcall SetMaxLength(System::Word Value);
	void __fastcall SetPictureMask(System::WideChar Value);
	DYNAMIC void __fastcall aeCreateEditCell(void);
	DYNAMIC System::WideChar * __fastcall aeGetEditString(void);
	DYNAMIC void __fastcall aeGetSampleDisplayData(System::WideChar * P);
	virtual void __fastcall DoGetCellValue(int Index);
	DYNAMIC int __fastcall DoPutCellValue(void);
	virtual void __fastcall SetActiveIndex(int Value);
	
public:
	__fastcall virtual TOvcSimpleArrayEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcSimpleArrayEditor(void);
	
__published:
	__property Ovcsf::TSimpleDataType DataType = {read=aeDataType, write=SetArrayDataType, nodefault};
	__property System::Byte DecimalPlaces = {read=aeDecimalPlaces, write=SetDecimalPlaces, nodefault};
	__property System::Word MaxLength = {read=aeMaxLength, write=SetMaxLength, nodefault};
	__property System::WideChar PictureMask = {read=aePictureMask, write=SetPictureMask, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSimpleArrayEditor(HWND ParentWindow) : TOvcBaseArrayEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TSimpleCellField : public Ovcsf::TOvcSimpleField
{
	typedef Ovcsf::TOvcSimpleField inherited;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TSimpleCellField(System::Classes::TComponent* AOwner);
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TSimpleCellField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TSimpleCellField(HWND ParentWindow) : Ovcsf::TOvcSimpleField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcPictureArrayEditor : public TOvcBaseArrayEditor
{
	typedef TOvcBaseArrayEditor inherited;
	
protected:
	Ovcpf::TPictureDataType aeDataType;
	int aeEpoch;
	System::UnicodeString aePictureMask;
	void __fastcall SetArrayDataType(Ovcpf::TPictureDataType Value);
	void __fastcall SetDecimalPlaces(System::Byte Value);
	void __fastcall SetEpoch(int Value);
	void __fastcall SetMaxLength(System::Word Value);
	void __fastcall SetPictureMask(const System::UnicodeString Value);
	DYNAMIC void __fastcall aeCreateEditCell(void);
	DYNAMIC System::WideChar * __fastcall aeGetEditString(void);
	DYNAMIC void __fastcall aeGetSampleDisplayData(System::WideChar * P);
	virtual void __fastcall DoGetCellValue(int Index);
	DYNAMIC int __fastcall DoPutCellValue(void);
	virtual void __fastcall SetActiveIndex(int Value);
	
public:
	__fastcall virtual TOvcPictureArrayEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcPictureArrayEditor(void);
	
__published:
	__property Ovcpf::TPictureDataType DataType = {read=aeDataType, write=SetArrayDataType, nodefault};
	__property System::Byte DecimalPlaces = {read=aeDecimalPlaces, write=SetDecimalPlaces, nodefault};
	__property int Epoch = {read=aeEpoch, write=SetEpoch, nodefault};
	__property System::Word MaxLength = {read=aeMaxLength, write=SetMaxLength, nodefault};
	__property System::UnicodeString PictureMask = {read=aePictureMask, write=SetPictureMask};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcPictureArrayEditor(HWND ParentWindow) : TOvcBaseArrayEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TPictureCellField : public Ovcpf::TOvcPictureField
{
	typedef Ovcpf::TOvcPictureField inherited;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TPictureCellField(System::Classes::TComponent* AOwner);
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TPictureCellField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TPictureCellField(HWND ParentWindow) : Ovcpf::TOvcPictureField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcNumericArrayEditor : public TOvcBaseArrayEditor
{
	typedef TOvcBaseArrayEditor inherited;
	
protected:
	Ovcnf::TNumericDataType aeDataType;
	System::UnicodeString aePictureMask;
	void __fastcall SetArrayDataType(Ovcnf::TNumericDataType Value);
	void __fastcall SetPictureMask(const System::UnicodeString Value);
	DYNAMIC void __fastcall aeCreateEditCell(void);
	DYNAMIC System::WideChar * __fastcall aeGetEditString(void);
	DYNAMIC void __fastcall aeGetSampleDisplayData(System::WideChar * P);
	virtual void __fastcall DoGetCellValue(int Index);
	DYNAMIC int __fastcall DoPutCellValue(void);
	virtual void __fastcall SetActiveIndex(int Value);
	
public:
	__fastcall virtual TOvcNumericArrayEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcNumericArrayEditor(void);
	
__published:
	__property Ovcnf::TNumericDataType DataType = {read=aeDataType, write=SetArrayDataType, nodefault};
	__property System::UnicodeString PictureMask = {read=aePictureMask, write=SetPictureMask};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcNumericArrayEditor(HWND ParentWindow) : TOvcBaseArrayEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TNumericCellField : public Ovcnf::TOvcNumericField
{
	typedef Ovcnf::TOvcNumericField inherited;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TNumericCellField(System::Classes::TComponent* AOwner);
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TNumericCellField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TNumericCellField(HWND ParentWindow) : Ovcnf::TOvcNumericField(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcae */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCAE)
using namespace Ovcae;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcaeHPP
