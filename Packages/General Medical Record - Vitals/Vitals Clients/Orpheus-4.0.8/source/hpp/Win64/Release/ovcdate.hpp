// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdate.pas' rev: 29.00 (Windows)

#ifndef OvcdateHPP
#define OvcdateHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdate
{
//-- forward type declarations -----------------------------------------------
struct TStDateTimeRec;
//-- type declarations -------------------------------------------------------
typedef int TStDate;

typedef int *PStDate;

typedef System::StaticArray<int, 536870911> TDateArray;

enum DECLSPEC_DENUM TStDayType : unsigned char { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday };

enum DECLSPEC_DENUM TStBondDateType : unsigned char { bdtActual, bdt30E360, bdt30360, bdt30360psa };

typedef int TStTime;

typedef int *PStTime;

struct DECLSPEC_DRECORD TStDateTimeRec
{
public:
	int D;
	int T;
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word MinYear = System::Word(0x640);
static const System::Word MaxYear = System::Word(0xf9f);
static const System::Int8 Mindate = System::Int8(0x0);
static const int Maxdate = int(0xd6025);
static const int Date1900 = int(0x1ac05);
static const int Date1980 = int(0x21e28);
static const int Date2000 = int(0x23ab1);
static const int BadDate = int(-1);
static const int DeltaJD = int(0x232da8);
static const System::Int8 MinTime = System::Int8(0x0);
static const int MaxTime = int(0x1517f);
static const int BadTime = int(-1);
static const int SecondsInDay = int(0x15180);
static const System::Word SecondsInHour = System::Word(0xe10);
static const System::Int8 SecondsInMinute = System::Int8(0x3c);
static const System::Int8 HoursInDay = System::Int8(0x18);
static const System::Int8 MinutesInHour = System::Int8(0x3c);
static const System::Word MinutesInDay = System::Word(0x5a0);
extern DELPHI_PACKAGE int DefaultYear;
extern DELPHI_PACKAGE System::Int8 DefaultMonth;
extern DELPHI_PACKAGE bool __fastcall IsLeapYear(int Year);
extern DELPHI_PACKAGE int __fastcall ResolveEpoch(int Year, int Epoch);
extern DELPHI_PACKAGE int __fastcall CurrentDate(void);
extern DELPHI_PACKAGE int __fastcall DaysInMonth(int Month, int Year, int Epoch);
extern DELPHI_PACKAGE bool __fastcall ValidDate(int Day, int Month, int Year, int Epoch);
extern DELPHI_PACKAGE int __fastcall DMYtoStDate(int Day, int Month, int Year, int Epoch);
extern DELPHI_PACKAGE System::Byte __fastcall WeekOfYear(int Julian);
extern DELPHI_PACKAGE double __fastcall AstJulianDate(int Julian);
extern DELPHI_PACKAGE double __fastcall AstJulianDatePrim(int Year, int Month, int Date, int UT);
extern DELPHI_PACKAGE int __fastcall AstJulianDatetoStDate(double AstJulian, bool Truncate);
extern DELPHI_PACKAGE void __fastcall StDateToDMY(int Julian, int &Day, int &Month, int &Year);
extern DELPHI_PACKAGE int __fastcall IncDate(int Julian, int Days, int Months, int Years);
extern DELPHI_PACKAGE int __fastcall IncDateTrunc(int Julian, int Months, int Years);
extern DELPHI_PACKAGE void __fastcall DateDiff(int Date1, int Date2, int &Days, int &Months, int &Years);
extern DELPHI_PACKAGE int __fastcall BondDateDiff(int Date1, int Date2, TStBondDateType DayBasis);
extern DELPHI_PACKAGE TStDayType __fastcall DayOfWeek(int Julian);
extern DELPHI_PACKAGE TStDayType __fastcall DayOfWeekDMY(int Day, int Month, int Year, int Epoch);
extern DELPHI_PACKAGE void __fastcall StTimeToHMS(int T, System::Byte &Hours, System::Byte &Minutes, System::Byte &Seconds);
extern DELPHI_PACKAGE int __fastcall HMStoStTime(System::Byte Hours, System::Byte Minutes, System::Byte Seconds);
extern DELPHI_PACKAGE bool __fastcall ValidTime(int Hours, int Minutes, int Seconds);
extern DELPHI_PACKAGE int __fastcall CurrentTime(void);
extern DELPHI_PACKAGE void __fastcall TimeDiff(int Time1, int Time2, System::Byte &Hours, System::Byte &Minutes, System::Byte &Seconds);
extern DELPHI_PACKAGE int __fastcall IncTime(int T, System::Byte Hours, System::Byte Minutes, System::Byte Seconds);
extern DELPHI_PACKAGE int __fastcall DecTime(int T, System::Byte Hours, System::Byte Minutes, System::Byte Seconds);
extern DELPHI_PACKAGE int __fastcall RoundToNearestHour(int T, bool Truncate);
extern DELPHI_PACKAGE int __fastcall RoundToNearestMinute(const int T, bool Truncate);
extern DELPHI_PACKAGE void __fastcall DateTimeDiff(TStDateTimeRec DT1, TStDateTimeRec &DT2, int &Days, int &Secs);
extern DELPHI_PACKAGE int __fastcall DateTimeToStDate(System::TDateTime DT);
extern DELPHI_PACKAGE int __fastcall DateTimeToStTime(System::TDateTime DT);
extern DELPHI_PACKAGE System::TDateTime __fastcall StDateToDateTime(int D);
extern DELPHI_PACKAGE System::TDateTime __fastcall StTimeToDateTime(int T);
extern DELPHI_PACKAGE void __fastcall IncDateTime(TStDateTimeRec DT1, TStDateTimeRec &DT2, int Days, int Secs);
extern DELPHI_PACKAGE int __fastcall Convert2ByteDate(System::Word TwoByteDate);
extern DELPHI_PACKAGE System::Word __fastcall Convert4ByteDate(int FourByteDate);
}	/* namespace Ovcdate */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDATE)
using namespace Ovcdate;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdateHPP
