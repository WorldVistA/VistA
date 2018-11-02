// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcbef.pas' rev: 29.00 (Windows)

#ifndef OvctcbefHPP
#define OvctcbefHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <ovcbase.hpp>
#include <ovccmd.hpp>
#include <ovcdata.hpp>
#include <ovcconst.hpp>
#include <ovcef.hpp>
#include <ovccaret.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctable.hpp>
#include <ovctcstr.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcbef
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCBaseEntryField;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCBaseEntryField : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
protected:
	Ovcef::TOvcBaseEntryField* FEdit;
	Ovcef::TOvcBaseEntryField* FEditDisplay;
	Ovcef::TValidationErrorEvent FOnError;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	Ovcef::TUserValidationEvent FOnUserValidation;
	Ovccaret::TOvcCaret* __fastcall GetCaretIns(void);
	Ovccaret::TOvcCaret* __fastcall GetCaretOvr(void);
	System::Uitypes::TColor __fastcall GetControlCharColor(void);
	int __fastcall GetDataSize(void);
	System::Byte __fastcall GetDecimalPlaces(void);
	Ovcef::TOvcEntryFieldOptions __fastcall GetOptions(void);
	Ovcef::TOvcEfColors* __fastcall GetEFColors(void);
	System::Word __fastcall GetMaxLength(void);
	bool __fastcall GetModified(void);
	System::WideChar __fastcall GetPadChar(void);
	System::WideChar __fastcall GetPasswordChar(void);
	System::UnicodeString __fastcall GetRangeHi(void);
	System::UnicodeString __fastcall GetRangeLo(void);
	int __fastcall GetTextMargin(void);
	void __fastcall SetCaretIns(Ovccaret::TOvcCaret* CI);
	void __fastcall SetCaretOvr(Ovccaret::TOvcCaret* CO);
	void __fastcall SetControlCharColor(System::Uitypes::TColor CCC);
	void __fastcall SetDecimalPlaces(System::Byte DP);
	void __fastcall SetEFColors(Ovcef::TOvcEfColors* Value);
	void __fastcall SetMaxLength(System::Word ML);
	void __fastcall SetOptions(Ovcef::TOvcEntryFieldOptions Value);
	void __fastcall SetPadChar(System::WideChar PC);
	void __fastcall SetPasswordChar(System::WideChar PC);
	void __fastcall SetRangeHi(const System::UnicodeString RI);
	void __fastcall SetRangeLo(const System::UnicodeString RL);
	void __fastcall SetTextMargin(int TM);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	__property Ovccaret::TOvcCaret* CaretIns = {read=GetCaretIns, write=SetCaretIns};
	__property Ovccaret::TOvcCaret* CaretOvr = {read=GetCaretOvr, write=SetCaretOvr};
	__property System::Uitypes::TColor ControlCharColor = {read=GetControlCharColor, write=SetControlCharColor, nodefault};
	__property System::Byte DecimalPlaces = {read=GetDecimalPlaces, write=SetDecimalPlaces, nodefault};
	__property Ovcef::TOvcEfColors* EFColors = {read=GetEFColors, write=SetEFColors};
	__property System::Word MaxLength = {read=GetMaxLength, write=SetMaxLength, nodefault};
	__property Ovcef::TOvcEntryFieldOptions Options = {read=GetOptions, write=SetOptions, nodefault};
	__property System::WideChar PadChar = {read=GetPadChar, write=SetPadChar, nodefault};
	__property System::WideChar PasswordChar = {read=GetPasswordChar, write=SetPasswordChar, nodefault};
	__property System::UnicodeString RangeHi = {read=GetRangeHi, write=SetRangeHi, stored=false};
	__property System::UnicodeString RangeLo = {read=GetRangeLo, write=SetRangeLo, stored=false};
	__property int TextMargin = {read=GetTextMargin, write=SetTextMargin, nodefault};
	__property Ovcef::TValidationErrorEvent OnError = {read=FOnError, write=FOnError};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	__property Ovcef::TUserValidationEvent OnUserValidation = {read=FOnUserValidation, write=FOnUserValidation};
	
public:
	__fastcall virtual TOvcTCBaseEntryField(System::Classes::TComponent* AOwner);
	virtual Ovcef::TOvcBaseEntryField* __fastcall CreateEntryField(System::Classes::TComponent* AOwner) = 0 ;
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual bool __fastcall CanSaveEditedData(bool SaveValue);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
	__property int DataSize = {read=GetDataSize, nodefault};
	__property bool Modified = {read=GetModified, nodefault};
	
__published:
	__property About = {default=0};
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCBaseEntryField(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcbef */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCBEF)
using namespace Ovctcbef;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcbefHPP
