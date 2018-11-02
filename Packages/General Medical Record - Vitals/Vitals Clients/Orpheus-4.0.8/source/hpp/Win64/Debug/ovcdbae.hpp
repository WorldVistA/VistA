// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbae.pas' rev: 29.00 (Windows)

#ifndef OvcdbaeHPP
#define OvcdbaeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Data.DB.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <ovcbase.hpp>
#include <ovccolor.hpp>
#include <ovccmd.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcdbnf.hpp>
#include <ovcdbpf.hpp>
#include <ovcdbsf.hpp>
#include <ovcmisc.hpp>
#include <ovcef.hpp>
#include <ovcstr.hpp>
#include <System.UITypes.hpp>
#include <ovcsf.hpp>
#include <ovcpf.hpp>
#include <ovcpb.hpp>
#include <ovcnf.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbae
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbSimpleCell;
class DELPHICLASS TOvcDbPictureCell;
class DELPHICLASS TOvcDbNumericCell;
class DELPHICLASS TOvcBaseDbArrayEditor;
class DELPHICLASS TOvcDbSimpleArrayEditor;
class DELPHICLASS TOvcDbPictureArrayEditor;
class DELPHICLASS TOvcDbNumericArrayEditor;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TGetItemColorEvent)(System::TObject* Sender, Data::Db::TField* Field, int Row, System::Uitypes::TColor &FG, System::Uitypes::TColor &BG);

typedef void __fastcall (__closure *TIndicatorClickEvent)(System::TObject* Sender, int Row);

class PASCALIMPLEMENTATION TOvcDbSimpleCell : public Ovcdbsf::TOvcDbSimpleField
{
	typedef Ovcdbsf::TOvcDbSimpleField inherited;
	
protected:
	virtual void __fastcall CreateWnd(void);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	
public:
	__fastcall virtual TOvcDbSimpleCell(System::Classes::TComponent* AOwner);
public:
	/* TOvcDbSimpleField.Destroy */ inline __fastcall virtual ~TOvcDbSimpleCell(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbSimpleCell(HWND ParentWindow) : Ovcdbsf::TOvcDbSimpleField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbPictureCell : public Ovcdbpf::TOvcDbPictureField
{
	typedef Ovcdbpf::TOvcDbPictureField inherited;
	
protected:
	virtual void __fastcall CreateWnd(void);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	
public:
	__fastcall virtual TOvcDbPictureCell(System::Classes::TComponent* AOwner);
public:
	/* TOvcDbPictureField.Destroy */ inline __fastcall virtual ~TOvcDbPictureCell(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbPictureCell(HWND ParentWindow) : Ovcdbpf::TOvcDbPictureField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbNumericCell : public Ovcdbnf::TOvcDbNumericField
{
	typedef Ovcdbnf::TOvcDbNumericField inherited;
	
protected:
	virtual void __fastcall CreateWnd(void);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	
public:
	__fastcall virtual TOvcDbNumericCell(System::Classes::TComponent* AOwner);
public:
	/* TOvcDbNumericField.Destroy */ inline __fastcall virtual ~TOvcDbNumericCell(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbNumericCell(HWND ParentWindow) : Ovcdbnf::TOvcDbNumericField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcBaseDbArrayEditor : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	int FActiveRow;
	bool FAutoRowHeight;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	System::UnicodeString FDataField;
	Data::Db::TDataSource* FDataSource;
	Ovcdbpf::TDateOrTime FDateOrTime;
	System::Byte FDecimalPlaces;
	int FEpoch;
	Data::Db::TFieldType FFieldType;
	Ovccolor::TOvcColors* FHighlightColors;
	System::Uitypes::TColor FLineColor;
	System::Word FMaxLength;
	Ovcef::TOvcEntryFieldOptions FOptions;
	char FPadChar;
	bool FPageScroll;
	System::UnicodeString FPictureMask;
	int FRowHeight;
	int FRowIndicatorWidth;
	bool FShowIndicator;
	int FTextMargin;
	bool FUseScrollBar;
	bool FZeroAsNull;
	System::Classes::TNotifyEvent FCellOnActiveChange;
	System::Classes::TNotifyEvent FCellOnDataChange;
	System::Classes::TNotifyEvent FCellOnEditingChange;
	System::Classes::TNotifyEvent FCellOnUpdateData;
	System::Classes::TNotifyEvent FOnChange;
	Ovcef::TValidationErrorEvent FOnError;
	TGetItemColorEvent FOnGetItemColor;
	TIndicatorClickEvent FOnIndicatorClick;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	Ovcef::TUserValidationEvent FOnUserValidation;
	Vcl::Controls::TImageList* aeIndicators;
	int aeNumRows;
	Ovcdata::TRangeType aeRangeLo;
	Ovcdata::TRangeType aeRangeHi;
	bool aeRangeLoaded;
	bool aePainting;
	bool aeFocusing;
	Vcl::Dbctrls::TFieldDataLink* __fastcall GetDataLink(void);
	Data::Db::TField* __fastcall GetField(void);
	System::UnicodeString __fastcall GetRangeHi(void);
	System::UnicodeString __fastcall GetRangeLo(void);
	void __fastcall SetActiveRow(int Value);
	void __fastcall SetAutoRowHeight(bool Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetDateOrTime(Ovcdbpf::TDateOrTime Value);
	void __fastcall SetDecimalPlaces(System::Byte Value);
	void __fastcall SetEpoch(int Value);
	void __fastcall SetFieldType(Data::Db::TFieldType Value);
	void __fastcall SetLineColor(System::Uitypes::TColor Value);
	void __fastcall SetMaxLength(System::Word Value);
	void __fastcall SetOptions(Ovcef::TOvcEntryFieldOptions Value);
	void __fastcall SetPadChar(char Value);
	void __fastcall SetPictureMask(const System::UnicodeString Value);
	void __fastcall SetRangeHi(const System::UnicodeString Value);
	void __fastcall SetRangeLo(const System::UnicodeString Value);
	void __fastcall SetRowHeight(int Value);
	void __fastcall SetRowIndicatorWidth(int Value);
	void __fastcall SetShowIndicator(bool Value);
	void __fastcall SetTextMargin(int Value);
	void __fastcall SetUseScrollBar(bool Value);
	void __fastcall SetZeroAsNull(bool Value);
	void __fastcall aeAdjustIntegralHeight(void);
	void __fastcall aeAdjustRowHeight(void);
	void __fastcall aeColorChanged(System::TObject* AColor);
	void __fastcall aeMoveCell(int NewIndex);
	void __fastcall aeReadRangeHi(System::Classes::TStream* Stream);
	void __fastcall aeReadRangeLo(System::Classes::TStream* Stream);
	void __fastcall aeUpdateActive(void);
	void __fastcall aeUpdateNumRows(void);
	void __fastcall aeUpdateScrollBar(void);
	void __fastcall aeWriteRangeHi(System::Classes::TStream* Stream);
	void __fastcall aeWriteRangeLo(System::Classes::TStream* Stream);
	void __fastcall aeActiveChange(System::TObject* Sender);
	void __fastcall aeDataChange(System::TObject* Sender);
	void __fastcall aeEditingChange(System::TObject* Sender);
	void __fastcall aeUpdateData(System::TObject* Sender);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetMinMaxInfo(Winapi::Messages::TWMGetMinMaxInfo &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	Ovcef::TOvcBaseEntryField* aeCell;
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Paint(void);
	virtual void __fastcall aeCreateEditCell(void) = 0 ;
	virtual void __fastcall aeGetCellProperties(void) = 0 ;
	System::WideChar * __fastcall aeGetEditString(void);
	void __fastcall aeGetSampleDisplayData(System::WideChar * P);
	void __fastcall aeRefresh(void);
	virtual void __fastcall DoGetItemColor(Data::Db::TField* AField, int ARow, System::Uitypes::TColor &FG, System::Uitypes::TColor &BG);
	DYNAMIC void __fastcall DoOnIndicatorClick(int Row);
	__property bool AutoRowHeight = {read=FAutoRowHeight, write=SetAutoRowHeight, nodefault};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property System::UnicodeString DataField = {read=FDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=FDataSource, write=SetDataSource};
	__property Ovcdbpf::TDateOrTime DateOrTime = {read=FDateOrTime, write=SetDateOrTime, nodefault};
	__property System::Byte DecimalPlaces = {read=FDecimalPlaces, write=SetDecimalPlaces, nodefault};
	__property int Epoch = {read=FEpoch, write=SetEpoch, nodefault};
	__property Data::Db::TFieldType FieldType = {read=FFieldType, write=SetFieldType, nodefault};
	__property Ovccolor::TOvcColors* HighlightColors = {read=FHighlightColors, write=FHighlightColors};
	__property System::Uitypes::TColor LineColor = {read=FLineColor, write=SetLineColor, nodefault};
	__property System::Word MaxLength = {read=FMaxLength, write=SetMaxLength, nodefault};
	__property Ovcef::TOvcEntryFieldOptions Options = {read=FOptions, write=SetOptions, nodefault};
	__property char PadChar = {read=FPadChar, write=SetPadChar, nodefault};
	__property bool PageScroll = {read=FPageScroll, write=FPageScroll, nodefault};
	__property System::UnicodeString PictureMask = {read=FPictureMask, write=SetPictureMask};
	__property System::UnicodeString RangeHi = {read=GetRangeHi, write=SetRangeHi, stored=false};
	__property System::UnicodeString RangeLo = {read=GetRangeLo, write=SetRangeLo, stored=false};
	__property int RowHeight = {read=FRowHeight, write=SetRowHeight, nodefault};
	__property int RowIndicatorWidth = {read=FRowIndicatorWidth, write=SetRowIndicatorWidth, nodefault};
	__property bool ShowIndicator = {read=FShowIndicator, write=SetShowIndicator, nodefault};
	__property int TextMargin = {read=FTextMargin, write=SetTextMargin, nodefault};
	__property bool UseScrollBar = {read=FUseScrollBar, write=SetUseScrollBar, nodefault};
	__property bool ZeroAsNull = {read=FZeroAsNull, write=SetZeroAsNull, nodefault};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property Ovcef::TValidationErrorEvent OnError = {read=FOnError, write=FOnError};
	__property TGetItemColorEvent OnGetItemColor = {read=FOnGetItemColor, write=FOnGetItemColor};
	__property TIndicatorClickEvent OnIndicatorClick = {read=FOnIndicatorClick, write=FOnIndicatorClick};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	__property Ovcef::TUserValidationEvent OnUserValidation = {read=FOnUserValidation, write=FOnUserValidation};
	
public:
	__fastcall virtual TOvcBaseDbArrayEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseDbArrayEditor(void);
	virtual void __fastcall SetFocus(void);
	void __fastcall Reset(void);
	void __fastcall Scroll(int Delta);
	void __fastcall UpdateRecord(void);
	__property Canvas;
	__property int ActiveRow = {read=FActiveRow, write=SetActiveRow, stored=false, nodefault};
	__property Vcl::Dbctrls::TFieldDataLink* DataLink = {read=GetDataLink};
	__property Data::Db::TField* Field = {read=GetField};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBaseDbArrayEditor(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbSimpleArrayEditor : public TOvcBaseDbArrayEditor
{
	typedef TOvcBaseDbArrayEditor inherited;
	
protected:
	virtual void __fastcall aeCreateEditCell(void);
	virtual void __fastcall aeGetCellProperties(void);
	
public:
	__fastcall virtual TOvcDbSimpleArrayEditor(System::Classes::TComponent* AOwner);
	
__published:
	__property FieldType;
	__property DataSource;
	__property DataField = {default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property AutoRowHeight;
	__property BorderStyle;
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property DecimalPlaces;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Height;
	__property HighlightColors;
	__property LineColor;
	__property MaxLength;
	__property PadChar;
	__property PageScroll;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PictureMask = {default=0};
	__property PopupMenu;
	__property RangeHi = {stored=false, default=0};
	__property RangeLo = {stored=false, default=0};
	__property RowHeight;
	__property RowIndicatorWidth;
	__property ShowHint;
	__property ShowIndicator;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Tag = {default=0};
	__property TextMargin;
	__property UseScrollBar;
	__property Visible = {default=1};
	__property Width;
	__property ZeroAsNull;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnError;
	__property OnExit;
	__property OnGetItemColor;
	__property OnIndicatorClick;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property OnUserCommand;
	__property OnUserValidation;
public:
	/* TOvcBaseDbArrayEditor.Destroy */ inline __fastcall virtual ~TOvcDbSimpleArrayEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbSimpleArrayEditor(HWND ParentWindow) : TOvcBaseDbArrayEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbPictureArrayEditor : public TOvcBaseDbArrayEditor
{
	typedef TOvcBaseDbArrayEditor inherited;
	
protected:
	virtual void __fastcall aeCreateEditCell(void);
	virtual void __fastcall aeGetCellProperties(void);
	
public:
	__fastcall virtual TOvcDbPictureArrayEditor(System::Classes::TComponent* AOwner);
	
__published:
	__property FieldType;
	__property DataSource;
	__property DataField = {default=0};
	__property DateOrTime;
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property AutoRowHeight;
	__property BorderStyle;
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property DecimalPlaces;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Epoch;
	__property Font;
	__property Height;
	__property HighlightColors;
	__property LineColor;
	__property MaxLength;
	__property PadChar;
	__property PageScroll;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PictureMask = {default=0};
	__property PopupMenu;
	__property RangeHi = {stored=false, default=0};
	__property RangeLo = {stored=false, default=0};
	__property RowHeight;
	__property RowIndicatorWidth;
	__property ShowHint;
	__property ShowIndicator;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Tag = {default=0};
	__property TextMargin;
	__property UseScrollBar;
	__property Visible = {default=1};
	__property Width;
	__property ZeroAsNull;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnError;
	__property OnExit;
	__property OnGetItemColor;
	__property OnIndicatorClick;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property OnUserCommand;
	__property OnUserValidation;
public:
	/* TOvcBaseDbArrayEditor.Destroy */ inline __fastcall virtual ~TOvcDbPictureArrayEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbPictureArrayEditor(HWND ParentWindow) : TOvcBaseDbArrayEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbNumericArrayEditor : public TOvcBaseDbArrayEditor
{
	typedef TOvcBaseDbArrayEditor inherited;
	
protected:
	virtual void __fastcall aeCreateEditCell(void);
	virtual void __fastcall aeGetCellProperties(void);
	
public:
	__fastcall virtual TOvcDbNumericArrayEditor(System::Classes::TComponent* AOwner);
	
__published:
	__property FieldType;
	__property DataSource;
	__property DataField = {default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property AutoRowHeight;
	__property BorderStyle;
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Height;
	__property HighlightColors;
	__property LineColor;
	__property PadChar;
	__property PageScroll;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PictureMask = {default=0};
	__property PopupMenu;
	__property RangeHi = {stored=false, default=0};
	__property RangeLo = {stored=false, default=0};
	__property RowHeight;
	__property RowIndicatorWidth;
	__property ShowHint;
	__property ShowIndicator;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Tag = {default=0};
	__property TextMargin;
	__property UseScrollBar;
	__property Visible = {default=1};
	__property Width;
	__property ZeroAsNull;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnError;
	__property OnExit;
	__property OnGetItemColor;
	__property OnIndicatorClick;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property OnUserCommand;
	__property OnUserValidation;
public:
	/* TOvcBaseDbArrayEditor.Destroy */ inline __fastcall virtual ~TOvcDbNumericArrayEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbNumericArrayEditor(HWND ParentWindow) : TOvcBaseDbArrayEditor(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbae */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBAE)
using namespace Ovcdbae;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbaeHPP
