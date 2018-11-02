// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcef.pas' rev: 29.00 (Windows)

#ifndef OvcefHPP
#define OvcefHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Clipbrd.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <ovcbase.hpp>
#include <ovccaret.hpp>
#include <ovccolor.hpp>
#include <ovcconst.hpp>
#include <ovccmd.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcintl.hpp>
#include <ovcmisc.hpp>
#include <ovcstr.hpp>
#include <ovcuser.hpp>
#include <ovcdate.hpp>
#include <ovcbordr.hpp>
#include <Winapi.Imm.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcef
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcEfColors;
class DELPHICLASS TOvcBaseEntryField;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TUserValidationEvent)(System::TObject* Sender, System::Word &ErrorCode);

typedef void __fastcall (__closure *TValidationErrorEvent)(System::TObject* Sender, System::Word ErrorCode, System::UnicodeString ErrorMsg);

enum DECLSPEC_DENUM TOvcEntryFieldOption : unsigned char { efoArrowIncDec, efoCaretToEnd, efoForceInsert, efoForceOvertype, efoInputRequired, efoPasswordMode, efoReadOnly, efoRightAlign, efoRightJustify, efoSoftValidation, efoStripLiterals, efoTrimBlanks };

typedef System::Set<TOvcEntryFieldOption, TOvcEntryFieldOption::efoArrowIncDec, TOvcEntryFieldOption::efoTrimBlanks> TOvcEntryFieldOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcEfColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	Ovccolor::TOvcColors* FDisabled;
	Ovccolor::TOvcColors* FError;
	Ovccolor::TOvcColors* FHighlight;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcEfColors(void);
	__fastcall virtual ~TOvcEfColors(void);
	
__published:
	__property Ovccolor::TOvcColors* Disabled = {read=FDisabled, write=FDisabled};
	__property Ovccolor::TOvcColors* Error = {read=FError, write=FError};
	__property Ovccolor::TOvcColors* Highlight = {read=FHighlight, write=FHighlight};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcBaseEntryField : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	bool FAutoSize;
	Ovcbordr::TOvcBorders* FBorders;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	System::Uitypes::TColor FCtrlColor;
	System::Byte FDecimalPlaces;
	TOvcEfColors* FEFColors;
	int FEpoch;
	Ovcintl::TOvcIntlSup* FIntlSup;
	System::Word FLastError;
	System::Word FMaxLength;
	TOvcEntryFieldOptions FOptions;
	System::WideChar FPadChar;
	System::WideChar FPasswordChar;
	int FTextMargin;
	bool FUninitialized;
	Ovcuser::TOvcUserData* FUserData;
	Ovcdata::TZeroDisplay FZeroDisplay;
	double FZeroDisplayValue;
	System::Classes::TNotifyEvent FOnChange;
	TValidationErrorEvent FOnError;
	Ovcbase::TGetEpochEvent FOnGetEpoch;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	TUserValidationEvent FOnUserValidation;
	Ovccaret::TOvcCaretPair* efCaret;
	System::Word efDataSize;
	System::Byte efDataType;
	Ovcdata::TEditString efEditSt;
	System::Byte efFieldClass;
	int efHOffset;
	int efHPos;
	System::Word efPicLen;
	Ovcdata::TPictureMask efPicture;
	Ovcdata::TRangeType efRangeHi;
	Ovcdata::TRangeType efRangeLo;
	bool efRightAlignActive;
	bool efSaveData;
	System::WideChar *efSaveEdit;
	int efSelStart;
	int efSelEnd;
	int efTopMargin;
	Ovcdata::TsefOptionSet sefOptions;
	bool __fastcall GetAsBoolean(void);
	int __fastcall GetAsCents(void);
	System::Extended __fastcall GetAsExtended(void);
	double __fastcall GetAsFloat(void);
	int __fastcall GetAsInteger(void);
	System::TDateTime __fastcall GetAsDateTime(void);
	int __fastcall GetAsStDate(void);
	int __fastcall GetAsStTime(void);
	System::UnicodeString __fastcall GetAsString(void);
	System::Variant __fastcall GetAsVariant(void);
	int __fastcall GetCurrentPos(void);
	System::Word __fastcall GetDataSize(void);
	System::UnicodeString __fastcall GetDisplayString(void);
	System::UnicodeString __fastcall GetEditString(void);
	int __fastcall GetEpoch(void);
	bool __fastcall GetEverModified(void);
	Ovccaret::TOvcCaret* __fastcall GetInsCaretType(void);
	bool __fastcall GetInsertMode(void);
	bool __fastcall GetModified(void);
	Ovccaret::TOvcCaret* __fastcall GetOvrCaretType(void);
	System::UnicodeString __fastcall GetRangeHiStr(void);
	System::UnicodeString __fastcall GetRangeLoStr(void);
	int __fastcall GetSelLength(void);
	int __fastcall GetSelStart(void);
	System::UnicodeString __fastcall GetSelText(void);
	void __fastcall SetAsBoolean(bool Value);
	void __fastcall SetAsCents(int Value);
	void __fastcall SetAsDateTime(System::TDateTime Value);
	void __fastcall SetAsExtended(System::Extended Value);
	void __fastcall SetAsFloat(double Value);
	void __fastcall SetAsInteger(int Value);
	void __fastcall SetAsStDate(int Value);
	void __fastcall SetAsStTime(int Value);
	void __fastcall SetAsVariant(const System::Variant &Value);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetDecimalPlaces(System::Byte Value);
	void __fastcall SetEpoch(int Value);
	void __fastcall SetEverModified(bool Value);
	void __fastcall SetInsCaretType(Ovccaret::TOvcCaret* const Value);
	void __fastcall SetInsertMode(bool Value);
	void __fastcall SetIntlSupport(Ovcintl::TOvcIntlSup* Value);
	void __fastcall SetMaxLength(System::Word Value);
	void __fastcall SetModified(bool Value);
	void __fastcall SetOptions(TOvcEntryFieldOptions Value);
	void __fastcall SetOvrCaretType(Ovccaret::TOvcCaret* const Value);
	void __fastcall SetPadChar(System::WideChar Value);
	void __fastcall SetPasswordChar(System::WideChar Value);
	void __fastcall SetRangeLoStr(const System::UnicodeString Value);
	void __fastcall SetRangeHiStr(const System::UnicodeString Value);
	void __fastcall SetSelLength(int Value);
	void __fastcall SetSelStart(int Value);
	void __fastcall SetSelText(const System::UnicodeString Value);
	void __fastcall SetTextMargin(int Value);
	void __fastcall SetUninitialized(bool Value);
	void __fastcall SetUserData(Ovcuser::TOvcUserData* Value);
	void __fastcall SetZeroDisplay(Ovcdata::TZeroDisplay Value);
	void __fastcall SetZeroDisplayValue(double Value);
	void __fastcall efBorderChanged(System::TObject* ABorder);
	void __fastcall efCalcTopMargin(void);
	void __fastcall efColorChanged(System::TObject* AColor);
	System::Word __fastcall efGetTextExtent(System::WideChar * S, int Len);
	void __fastcall efInitializeDataSize(void);
	System::Word __fastcall GetDefStrType(void);
	bool __fastcall efIsSibling(HWND HW);
	void __fastcall efMoveFocus(Vcl::Controls::TWinControl* C);
	void __fastcall efPaintBorders(void);
	void __fastcall efPerformEdit(Winapi::Messages::TMessage &Msg, System::Word Cmd);
	void __fastcall efPerformPreEditNotify(Vcl::Controls::TWinControl* C);
	void __fastcall efPerformPostEditNotify(Vcl::Controls::TWinControl* C);
	void __fastcall efReadRangeHi(System::Classes::TStream* Stream);
	void __fastcall efReadRangeLo(System::Classes::TStream* Stream);
	System::Word __fastcall efTransferPrim(void * DataPtr, System::Word TransferFlag);
	void __fastcall efWriteRangeHi(System::Classes::TStream* Stream);
	void __fastcall efWriteRangeLo(System::Classes::TStream* Stream);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	void __fastcall ImeEnter(void);
	MESSAGE void __fastcall WMImeNotify(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall OMGetDataSize(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMReportError(Ovcdata::TOMReportError &Msg);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall WMClear(Winapi::Messages::TWMNoParams &Msg);
	MESSAGE void __fastcall WMCopy(Winapi::Messages::TWMNoParams &Msg);
	MESSAGE void __fastcall WMCut(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetText(Winapi::Messages::TWMGetText &Msg);
	MESSAGE void __fastcall WMGetTextLength(Winapi::Messages::TWMNoParams &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall WMPaste(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	MESSAGE void __fastcall WMSetFont(Winapi::Messages::TWMSetFont &Msg);
	MESSAGE void __fastcall WMSetText(Winapi::Messages::TWMSetText &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMSysKeyDown(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall EMGetModify(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall EMGetSel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall EMSetModify(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall EMSetSel(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall DoOnChange(void);
	DYNAMIC void __fastcall DoOnError(System::Word ErrorCode, const System::UnicodeString ErrorMsg);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Command);
	DYNAMIC void __fastcall DoOnUserValidation(System::Word &ErrorCode);
	DYNAMIC void __fastcall DoRestoreClick(System::TObject* Sender);
	DYNAMIC void __fastcall DoCutClick(System::TObject* Sender);
	DYNAMIC void __fastcall DoCopyClick(System::TObject* Sender);
	DYNAMIC void __fastcall DoPasteClick(System::TObject* Sender);
	DYNAMIC void __fastcall DoDeleteClick(System::TObject* Sender);
	DYNAMIC void __fastcall DoSelectAllClick(System::TObject* Sender);
	DYNAMIC void __fastcall efAdjustSize(void);
	virtual bool __fastcall efCanClose(bool DoValidation);
	virtual void __fastcall efCaretToEnd(void);
	virtual void __fastcall efCaretToStart(void);
	DYNAMIC void __fastcall efChangeMask(System::WideChar * Mask);
	bool __fastcall efCharOK(System::WideChar PicChar, System::WideChar &Ch, System::WideChar PrevCh, bool Fix);
	void __fastcall efConditionalBeep(void);
	void __fastcall efCopyPrim(void);
	bool __fastcall efBinStr2Long(System::WideChar * St, NativeInt &L);
	System::Word __fastcall efCalcDataSize(System::WideChar * St, System::Word MaxLen);
	virtual void __fastcall efEdit(Winapi::Messages::TMessage &Msg, System::Word Cmd) = 0 ;
	virtual System::Word __fastcall efEditBegin(void);
	virtual bool __fastcall efFieldIsEmpty(void);
	void __fastcall efFieldModified(void);
	void __fastcall efFindCtrlChars(System::WideChar * P, int &ChCnt, int &CtCnt);
	void __fastcall efFixCase(System::WideChar PicChar, System::WideChar &Ch, System::WideChar PrevCh);
	virtual System::WideChar * __fastcall efGetDisplayString(System::WideChar * Dest, System::Word Size);
	int __fastcall efGetMousePos(int MPos);
	DYNAMIC void __fastcall efGetSampleDisplayData(System::WideChar * T);
	DYNAMIC void __fastcall efIncDecValue(bool Wrap, double Delta) = 0 ;
	bool __fastcall efIsNumericType(void);
	virtual bool __fastcall efIsReadOnly(void);
	void __fastcall efLong2Str(System::WideChar * P, int L);
	void __fastcall efMapControlChars(System::WideChar * Dest, System::WideChar * Src);
	DYNAMIC void __fastcall efMoveFocusToNextField(void);
	DYNAMIC void __fastcall efMoveFocusToPrevField(void);
	System::WideChar __fastcall efNthMaskChar(System::Word N);
	bool __fastcall efOctStr2Long(System::WideChar * St, NativeInt &L);
	void __fastcall efPaintPrim(HDC DC, const System::Types::TRect &ARect, int Offset);
	void __fastcall efPerformRepaint(bool Modified);
	bool __fastcall efPositionCaret(bool Adjust);
	System::UnicodeString __fastcall efRangeToStRange(const Ovcdata::TRangeType &Value);
	bool __fastcall efStRangeToRange(const System::UnicodeString Value, Ovcdata::TRangeType &R);
	virtual void __fastcall efRemoveBadOptions(void);
	virtual void __fastcall efResetCaret(void);
	void __fastcall efSaveEditString(void);
	void __fastcall efSetDefaultRange(System::Byte FT);
	void __fastcall efSetInitialValue(void);
	bool __fastcall efStr2Long(System::WideChar * P, NativeInt &L);
	virtual System::Word __fastcall efTransfer(void * DataPtr, System::Word TransferFlag);
	virtual System::Word __fastcall efValidateField(void) = 0 ;
	virtual void __fastcall efSetCaretPos(int Value);
	virtual void __fastcall SetAsString(const System::UnicodeString Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName Value);
	
public:
	__fastcall virtual TOvcBaseEntryField(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseEntryField(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall ClearContents(void);
	void __fastcall ClearSelection(void);
	void __fastcall CopyToClipboard(void);
	DYNAMIC void __fastcall CutToClipboard(void);
	void __fastcall DecreaseValue(bool Wrap, double Delta);
	void __fastcall Deselect(void);
	bool __fastcall FieldIsEmpty(void);
	DYNAMIC System::UnicodeString __fastcall GetStrippedEditString(void);
	System::Word __fastcall GetValue(void *Data);
	void __fastcall IncreaseValue(bool Wrap, double Delta);
	bool __fastcall IsValid(void);
	DYNAMIC void __fastcall MergeWithPicture(const System::UnicodeString S);
	void __fastcall MoveCaret(int Delta);
	void __fastcall MoveCaretToEnd(void);
	void __fastcall MoveCaretToStart(void);
	DYNAMIC void __fastcall PasteFromClipboard(void);
	void __fastcall ProcessCommand(System::Word Cmd, System::Word CharCode);
	void __fastcall ResetCaret(void);
	DYNAMIC void __fastcall Restore(void);
	void __fastcall SelectAll(void);
	void __fastcall SetInitialValue(void);
	void __fastcall SetRangeHi(const Ovcdata::TRangeType &Value);
	void __fastcall SetRangeLo(const Ovcdata::TRangeType &Value);
	void __fastcall SetSelection(System::Word Start, System::Word Stop);
	void __fastcall SetValue(const void *Data);
	DYNAMIC System::Word __fastcall ValidateContents(bool ReportError);
	bool __fastcall ValidateSelf(void);
	__property ParentColor = {default=0};
	__property bool AsBoolean = {read=GetAsBoolean, write=SetAsBoolean, nodefault};
	__property int AsCents = {read=GetAsCents, write=SetAsCents, nodefault};
	__property System::TDateTime AsDateTime = {read=GetAsDateTime, write=SetAsDateTime};
	__property System::Extended AsExtended = {read=GetAsExtended, write=SetAsExtended};
	__property double AsFloat = {read=GetAsFloat, write=SetAsFloat};
	__property int AsInteger = {read=GetAsInteger, write=SetAsInteger, nodefault};
	__property int AsOvcDate = {read=GetAsStDate, write=SetAsStDate, nodefault};
	__property int AsOvcTime = {read=GetAsStTime, write=SetAsStTime, nodefault};
	__property System::UnicodeString AsString = {read=GetAsString, write=SetAsString};
	__property System::Variant AsVariant = {read=GetAsVariant, write=SetAsVariant};
	__property int AsStDate = {read=GetAsStDate, write=SetAsStDate, nodefault};
	__property int AsStTime = {read=GetAsStTime, write=SetAsStTime, nodefault};
	__property Font;
	__property Canvas;
	__property Color = {default=-16777211};
	__property int CurrentPos = {read=GetCurrentPos, write=efSetCaretPos, nodefault};
	__property System::Word DataSize = {read=GetDataSize, nodefault};
	__property System::UnicodeString DisplayString = {read=GetDisplayString};
	__property System::UnicodeString EditString = {read=GetEditString};
	__property int Epoch = {read=GetEpoch, write=SetEpoch, nodefault};
	__property bool EverModified = {read=GetEverModified, write=SetEverModified, nodefault};
	__property bool InsertMode = {read=GetInsertMode, write=SetInsertMode, nodefault};
	__property Ovcintl::TOvcIntlSup* IntlSupport = {read=FIntlSup, write=SetIntlSupport};
	__property System::Word LastError = {read=FLastError, nodefault};
	__property bool Modified = {read=GetModified, write=SetModified, nodefault};
	__property int SelectionLength = {read=GetSelLength, write=SetSelLength, nodefault};
	__property int SelectionStart = {read=GetSelStart, write=SetSelStart, nodefault};
	__property System::UnicodeString SelectedText = {read=GetSelText, write=SetSelText};
	__property System::UnicodeString Text = {read=GetAsString, write=SetAsString};
	__property Ovcuser::TOvcUserData* UserData = {read=FUserData, write=SetUserData};
	__property Ovcbase::TOvcAttachedLabel* AttachedLabel = {read=GetAttachedLabel};
	__property bool AutoSize = {read=FAutoSize, write=SetAutoSize, default=1};
	__property Ovcbordr::TOvcBorders* Borders = {read=FBorders, write=FBorders};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property Ovccaret::TOvcCaret* CaretIns = {read=GetInsCaretType, write=SetInsCaretType};
	__property Ovccaret::TOvcCaret* CaretOvr = {read=GetOvrCaretType, write=SetOvrCaretType};
	__property System::Uitypes::TColor ControlCharColor = {read=FCtrlColor, write=FCtrlColor, nodefault};
	__property System::Byte DecimalPlaces = {read=FDecimalPlaces, write=SetDecimalPlaces, nodefault};
	__property TOvcEfColors* EFColors = {read=FEFColors, write=FEFColors};
	__property System::Word MaxLength = {read=FMaxLength, write=SetMaxLength, default=15};
	__property TOvcEntryFieldOptions Options = {read=FOptions, write=SetOptions, default=2050};
	__property System::WideChar PadChar = {read=FPadChar, write=SetPadChar, default=32};
	__property System::WideChar PasswordChar = {read=FPasswordChar, write=SetPasswordChar, default=42};
	__property System::UnicodeString RangeHi = {read=GetRangeHiStr, write=SetRangeHiStr, stored=false};
	__property System::UnicodeString RangeLo = {read=GetRangeLoStr, write=SetRangeLoStr, stored=false};
	__property int TextMargin = {read=FTextMargin, write=SetTextMargin, default=2};
	__property bool Uninitialized = {read=FUninitialized, write=SetUninitialized, default=0};
	__property Ovcdata::TZeroDisplay ZeroDisplay = {read=FZeroDisplay, write=SetZeroDisplay, default=0};
	__property double ZeroDisplayValue = {read=FZeroDisplayValue, write=SetZeroDisplayValue};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property TValidationErrorEvent OnError = {read=FOnError, write=FOnError};
	__property Ovcbase::TGetEpochEvent OnGetEpoch = {read=FOnGetEpoch, write=FOnGetEpoch};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	__property TUserValidationEvent OnUserValidation = {read=FOnUserValidation, write=FOnUserValidation};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBaseEntryField(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define efDefOptions (System::Set<TOvcEntryFieldOption, TOvcEntryFieldOption::efoArrowIncDec, TOvcEntryFieldOption::efoTrimBlanks>() << TOvcEntryFieldOption::efoCaretToEnd << TOvcEntryFieldOption::efoTrimBlanks )
}	/* namespace Ovcef */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEF)
using namespace Ovcef;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcefHPP
