// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcintl.pas' rev: 29.00 (Windows)

#ifndef OvcintlHPP
#define OvcintlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Win.Registry.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcstr.hpp>
#include <ovcdate.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcintl
{
//-- forward type declarations -----------------------------------------------
struct TIntlData;
class DELPHICLASS TOvcIntlSup;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::WideChar, 6> TCurrencySt;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TIntlData
{
public:
	TCurrencySt CurrencyLtStr;
	TCurrencySt CurrencyRtStr;
	System::WideChar DecimalChar;
	System::WideChar CommaChar;
	System::Byte CurrDigits;
	System::WideChar SlashChar;
	System::WideChar TrueChar;
	System::WideChar FalseChar;
	System::WideChar YesChar;
	System::WideChar NoChar;
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TOvcIntlSup : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FAutoUpdate;
	TCurrencySt FCurrencyLtStr;
	TCurrencySt FCurrencyRtStr;
	System::WideChar FDecimalChar;
	System::WideChar FCommaChar;
	System::Byte FCurrencyDigits;
	System::WideChar FListChar;
	System::WideChar FSlashChar;
	System::WideChar FTrueChar;
	System::WideChar FFalseChar;
	System::WideChar FYesChar;
	System::WideChar FNoChar;
	System::Classes::TNotifyEvent FOnWinIniChange;
	HWND intlHandle;
	System::UnicodeString w1159;
	System::UnicodeString w2359;
	System::WideChar wColonChar;
	System::UnicodeString wCountry;
	System::Byte wCurrencyForm;
	System::StaticArray<System::WideChar, 6> wldSub1;
	System::StaticArray<System::WideChar, 6> wldSub2;
	System::StaticArray<System::WideChar, 6> wldSub3;
	System::StaticArray<System::WideChar, 40> wLongDate;
	System::Byte wNegCurrencyForm;
	System::StaticArray<System::WideChar, 30> wShortDate;
	bool wTLZero;
	bool w12Hour;
	System::UnicodeString __fastcall GetCountry(void);
	System::UnicodeString __fastcall GetCurrencyLtStr(void);
	System::UnicodeString __fastcall GetCurrencyRtStr(void);
	void __fastcall SetAutoUpdate(bool Value);
	void __fastcall SetCurrencyLtStr(const System::UnicodeString Value);
	void __fastcall SetCurrencyRtStr(const System::UnicodeString Value);
	void __fastcall isExtractFromPictureEx(System::WideChar * Picture, System::WideChar * S, System::WideChar Ch, int &I, int Blank, int Default, System::WideChar ExCh);
	void __fastcall isExtractFromPicture(System::WideChar * Picture, System::WideChar * S, System::WideChar Ch, int &I, int Blank, int Default);
	void __fastcall isIntlWndProc(Winapi::Messages::TMessage &Msg);
	System::Word __fastcall isMaskCharCount(System::WideChar * P, System::WideChar MC);
	void __fastcall isMergeIntoPictureEx(System::WideChar * Picture, System::WideChar Ch, int I, System::WideChar ExCh);
	void __fastcall isMergeIntoPicture(System::WideChar * Picture, System::WideChar Ch, int I);
	void __fastcall isMergePictureSt(System::WideChar * Picture, System::WideChar * P, System::WideChar MC, System::WideChar * SP);
	void __fastcall isPackResult(System::WideChar * Picture, System::WideChar * S);
	void __fastcall isSubstChar(System::WideChar * Picture, System::WideChar OldCh, System::WideChar NewCh);
	void __fastcall isSubstCharSim(System::WideChar * P, System::WideChar OC, System::WideChar NC);
	System::WideChar * __fastcall isTimeToTimeStringPrim(System::WideChar * Dest, System::WideChar * Picture, int T, bool Pack, System::WideChar * t1159, System::WideChar * t2359);
	
public:
	__fastcall TOvcIntlSup(void);
	__fastcall virtual ~TOvcIntlSup(void);
	System::UnicodeString __fastcall CurrentDateString(const System::UnicodeString Picture, bool Pack);
	System::WideChar * __fastcall CurrentDatePChar(System::WideChar * Dest, System::WideChar * Picture, bool Pack);
	System::UnicodeString __fastcall CurrentTimeString(const System::UnicodeString Picture, bool Pack);
	System::WideChar * __fastcall CurrentTimePChar(System::WideChar * Dest, System::WideChar * Picture, bool Pack);
	System::UnicodeString __fastcall DateToDateString(const System::UnicodeString Picture, int Julian, bool Pack);
	System::WideChar * __fastcall DateToDatePChar(System::WideChar * Dest, System::WideChar * Picture, int Julian, bool Pack);
	System::WideChar * __fastcall DateTimeToDatePChar(System::WideChar * Dest, System::WideChar * Picture, System::TDateTime DT, bool Pack);
	bool __fastcall DateStringToDMY(const System::UnicodeString Picture, const System::UnicodeString S, int &Day, int &Month, int &Year, int Epoch);
	bool __fastcall DatePCharToDMY(System::WideChar * Picture, System::WideChar * S, int &Day, int &Month, int &Year, int Epoch);
	bool __fastcall DateStringIsBlank(const System::UnicodeString Picture, const System::UnicodeString S);
	bool __fastcall DatePCharIsBlank(System::WideChar * Picture, System::WideChar * S);
	int __fastcall DateStringToDate(const System::UnicodeString Picture, const System::UnicodeString S, int Epoch);
	int __fastcall DatePCharToDate(System::WideChar * Picture, System::WideChar * S, int Epoch);
	System::UnicodeString __fastcall DayOfWeekToString(Ovcdate::TStDayType WeekDay);
	System::WideChar * __fastcall DayOfWeekToPChar(System::WideChar * Dest, Ovcdate::TStDayType WeekDay);
	System::UnicodeString __fastcall DMYtoDateString(const System::UnicodeString Picture, int Day, int Month, int Year, bool Pack, int Epoch);
	System::WideChar * __fastcall DMYtoDatePChar(System::WideChar * Dest, System::WideChar * Picture, int Day, int Month, int Year, bool Pack, int Epoch);
	System::UnicodeString __fastcall InternationalCurrency(System::WideChar FormChar, System::Byte MaxDigits, bool Float, bool AddCommas, bool IsNumeric);
	System::WideChar * __fastcall InternationalCurrencyPChar(System::WideChar * Dest, System::WideChar FormChar, System::Byte MaxDigits, bool Float, bool AddCommas, bool IsNumeric);
	System::UnicodeString __fastcall InternationalDate(bool ForceCentury);
	System::WideChar * __fastcall InternationalDatePChar(System::WideChar * Dest, bool ForceCentury);
	System::UnicodeString __fastcall InternationalLongDate(bool ShortNames, bool ExcludeDOW);
	System::WideChar * __fastcall InternationalLongDatePChar(System::WideChar * Dest, bool ShortNames, bool ExcludeDOW);
	System::UnicodeString __fastcall InternationalTime(bool ShowSeconds);
	System::WideChar * __fastcall InternationalTimePChar(System::WideChar * Dest, bool ShowSeconds);
	System::Byte __fastcall MonthStringToMonth(const System::UnicodeString S, System::Byte Width);
	System::Byte __fastcall MonthPCharToMonth(System::WideChar * S, System::Byte Width);
	System::UnicodeString __fastcall MonthToString(int Month);
	System::WideChar * __fastcall MonthToPChar(System::WideChar * Dest, int Month);
	void __fastcall ResetInternationalInfo(void);
	bool __fastcall TimeStringToHMS(const System::UnicodeString Picture, const System::UnicodeString S, int &Hour, int &Minute, int &Second);
	bool __fastcall TimePCharToHMS(System::WideChar * Picture, System::WideChar * S, int &Hour, int &Minute, int &Second);
	int __fastcall TimeStringToTime(const System::UnicodeString Picture, const System::UnicodeString S);
	int __fastcall TimePCharToTime(System::WideChar * Picture, System::WideChar * S);
	System::UnicodeString __fastcall TimeToTimeString(const System::UnicodeString Picture, int T, bool Pack);
	System::WideChar * __fastcall TimeToTimePChar(System::WideChar * Dest, System::WideChar * Picture, int T, bool Pack);
	System::UnicodeString __fastcall TimeToAmPmString(const System::UnicodeString Picture, int T, bool Pack);
	System::WideChar * __fastcall TimeToAmPmPChar(System::WideChar * Dest, System::WideChar * Picture, int T, bool Pack);
	__property bool AutoUpdate = {read=FAutoUpdate, write=SetAutoUpdate, nodefault};
	__property System::UnicodeString CurrencyLtStr = {read=GetCurrencyLtStr, write=SetCurrencyLtStr};
	__property System::UnicodeString CurrencyRtStr = {read=GetCurrencyRtStr, write=SetCurrencyRtStr};
	__property System::WideChar DecimalChar = {read=FDecimalChar, write=FDecimalChar, nodefault};
	__property System::WideChar CommaChar = {read=FCommaChar, write=FCommaChar, nodefault};
	__property System::UnicodeString Country = {read=GetCountry};
	__property System::Byte CurrencyDigits = {read=FCurrencyDigits, write=FCurrencyDigits, nodefault};
	__property System::WideChar ListChar = {read=FListChar, write=FListChar, nodefault};
	__property System::WideChar SlashChar = {read=FSlashChar, write=FSlashChar, nodefault};
	__property System::WideChar TrueChar = {read=FTrueChar, write=FTrueChar, nodefault};
	__property System::WideChar FalseChar = {read=FFalseChar, write=FFalseChar, nodefault};
	__property System::WideChar YesChar = {read=FYesChar, write=FYesChar, nodefault};
	__property System::WideChar NoChar = {read=FNoChar, write=FNoChar, nodefault};
	__property System::Classes::TNotifyEvent OnWinIniChange = {read=FOnWinIniChange, write=FOnWinIniChange};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TIntlData DefaultIntlData;
extern DELPHI_PACKAGE TOvcIntlSup* OvcIntlSup;
}	/* namespace Ovcintl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCINTL)
using namespace Ovcintl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcintlHPP
