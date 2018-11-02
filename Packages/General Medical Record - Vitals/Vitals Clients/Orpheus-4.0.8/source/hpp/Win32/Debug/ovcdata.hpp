// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdata.pas' rev: 29.00 (Windows)

#ifndef OvcdataHPP
#define OvcdataHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcconst.hpp>
#include <ovcdate.hpp>
#include <o32sr.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdata
{
//-- forward type declarations -----------------------------------------------
struct TRangeType;
struct TOvcCmdRec;
struct TOMReportError;
struct TOMSetFocus;
struct TOMShowStatus;
//-- type declarations -------------------------------------------------------
typedef System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> TCharSet;

typedef void * *PPointer;

enum DECLSPEC_DENUM TsefOption : unsigned char { sefValPending, sefInvalid, sefNoHighlight, sefIgnoreFocus, sefValidating, sefModified, sefEverModified, sefFixSemiLits, sefHexadecimal, sefOctal, sefBinary, sefNumeric, sefRealVar, sefNoLiterals, sefHaveFocus, sefRetainPos, sefErrorPending, sefInsert, sefLiteral, sefAcceptChar, sefCharOK, sefUpdating, sefGettingValue, sefUserValidating, sefNoUserValidate };

typedef System::Set<TsefOption, TsefOption::sefValPending, TsefOption::sefNoUserValidate> TsefOptionSet;

enum DECLSPEC_DENUM TCaseChange : unsigned char { mcNoChange, mcUpperCase, mcLowerCase, mcMixedCase };

typedef System::WideChar TUserSetRange;

typedef System::WideChar TForceCaseRange;

typedef char TSubstCharRange;

typedef System::StaticArray<TCharSet, 8> TUserCharSets;

typedef System::StaticArray<TCaseChange, 8> TForceCase;

typedef System::StaticArray<System::WideChar, 8> TSubstChars;

typedef System::StaticArray<System::WideChar, 256> TEditString;

typedef System::StaticArray<System::WideChar, 256> TPictureMask;

typedef System::StaticArray<System::Byte, 257> TPictureFlags;

typedef TRangeType *PRangeType;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TRangeType
{
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 10> rt10;
		};
		struct 
		{
			int rtTime;
		};
		struct 
		{
			int rtDate;
		};
		struct 
		{
			System::Extended rtExt;
		};
		struct 
		{
			System::CompBase rtComp;
		};
		struct 
		{
			double rtDbl;
		};
		struct 
		{
			double rtReal;
		};
		struct 
		{
			void *rtPtr;
		};
		struct 
		{
			float rtSgl;
		};
		struct 
		{
			NativeInt rtLong;
		};
		struct 
		{
			System::Word rtWord;
		};
		struct 
		{
			short rtInt;
		};
		struct 
		{
			System::Int8 rtSht;
		};
		struct 
		{
			System::Byte rtByte;
		};
		struct 
		{
			System::WideChar rtChar;
		};
		
	};
};
#pragma pack(pop)


typedef int TOvcDate;

typedef int TOvcTime;

typedef Ovcdate::TStDayType TDayType;

enum DECLSPEC_DENUM TDbEntryFieldStates : unsigned char { esFocused, esSelected, esReset };

typedef System::Set<TDbEntryFieldStates, TDbEntryFieldStates::esFocused, TDbEntryFieldStates::esReset> TDbEntryFieldState;

enum DECLSPEC_DENUM TSearchOptions : unsigned char { soFind, soBackward, soMatchCase, soGlobal, soReplace, soReplaceAll, soWholeWord, soSelText };

typedef System::Set<TSearchOptions, TSearchOptions::soFind, TSearchOptions::soSelText> TSearchOptionSet;

enum DECLSPEC_DENUM TTabType : unsigned char { ttReal, ttFixed, ttSmart };

enum DECLSPEC_DENUM TZeroDisplay : unsigned char { zdShow, zdHide, zdHideUntilModified };

typedef TOvcCmdRec *POvcCmdRec;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcCmdRec
{
	union
	{
		struct 
		{
			int Keys;
		};
		struct 
		{
			System::Byte Key1;
			System::Byte SS1;
			System::Byte Key2;
			System::Byte SS2;
			System::Word Cmd;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TOMReportError
{
public:
	unsigned Msg;
	System::Word Error;
	System::Word Unused;
	int lParam;
	int Result;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TOMSetFocus
{
public:
	unsigned Msg;
	int wParam;
	Vcl::Controls::TWinControl* Control;
	int Result;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TOMShowStatus
{
public:
	unsigned Msg;
	int Column;
	int Line;
	int Result;
};
#pragma pack(pop)


typedef void __fastcall (__closure *TShowStatusEvent)(System::TObject* Sender, int LineNum, int ColNum);

typedef void __fastcall (__closure *TTopLineChangedEvent)(System::TObject* Sender, int Line);

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::StaticArray<int, 2> BorderStyles;
extern DELPHI_PACKAGE System::StaticArray<int, 4> ScrollBarStyles;
static const System::Uitypes::TColor clCream = System::Uitypes::TColor(10930928);
static const System::Uitypes::TColor clMoneyGreen = System::Uitypes::TColor(12639424);
static const System::Uitypes::TColor clSkyBlue = System::Uitypes::TColor(16776176);
extern DELPHI_PACKAGE TsefOptionSet sefDefOptions;
static const System::WideChar DefPadChar = (System::WideChar)(0x20);
static const System::Byte MaxEditLen = System::Byte(0xff);
static const System::Byte MaxPicture = System::Byte(0xff);
static const System::WideChar pmAnyChar = (System::WideChar)(0x58);
static const System::WideChar pmForceUpper = (System::WideChar)(0x21);
static const System::WideChar pmForceLower = (System::WideChar)(0x4c);
static const System::WideChar pmForceMixed = (System::WideChar)(0x78);
static const System::WideChar pmAlpha = (System::WideChar)(0x61);
static const System::WideChar pmUpperAlpha = (System::WideChar)(0x41);
static const System::WideChar pmLowerAlpha = (System::WideChar)(0x6c);
static const System::WideChar pmPositive = (System::WideChar)(0x39);
static const System::WideChar pmWhole = (System::WideChar)(0x69);
static const System::WideChar pmDecimal = (System::WideChar)(0x23);
static const System::WideChar pmScientific = (System::WideChar)(0x45);
static const System::WideChar pmHexadecimal = (System::WideChar)(0x4b);
static const System::WideChar pmOctal = (System::WideChar)(0x4f);
static const System::WideChar pmBinary = (System::WideChar)(0x62);
static const System::WideChar pmTrueFalse = (System::WideChar)(0x42);
static const System::WideChar pmYesNo = (System::WideChar)(0x59);
static const System::WideChar pmUser1 = (System::WideChar)(0x31);
static const System::WideChar pmUser2 = (System::WideChar)(0x32);
static const System::WideChar pmUser3 = (System::WideChar)(0x33);
static const System::WideChar pmUser4 = (System::WideChar)(0x34);
static const System::WideChar pmUser5 = (System::WideChar)(0x35);
static const System::WideChar pmUser6 = (System::WideChar)(0x36);
static const System::WideChar pmUser7 = (System::WideChar)(0x37);
static const System::WideChar pmUser8 = (System::WideChar)(0x38);
static const char Subst1 = '\xf1';
static const char Subst2 = '\xf2';
static const char Subst3 = '\xf3';
static const char Subst4 = '\xf4';
static const char Subst5 = '\xf5';
static const char Subst6 = '\xf6';
static const char Subst7 = '\xf7';
static const char Subst8 = '\xf8';
static const System::WideChar pmDecimalPt = (System::WideChar)(0x2e);
static const System::WideChar pmComma = (System::WideChar)(0x2c);
static const System::WideChar pmFloatDollar = (System::WideChar)(0x24);
static const System::WideChar pmCurrencyLt = (System::WideChar)(0x63);
static const System::WideChar pmCurrencyRt = (System::WideChar)(0x43);
static const System::WideChar pmNegParens = (System::WideChar)(0x70);
static const System::WideChar pmNegHere = (System::WideChar)(0x67);
static const System::WideChar pmMonth = (System::WideChar)(0x6d);
static const System::WideChar pmMonthU = (System::WideChar)(0x4d);
static const System::WideChar pmDay = (System::WideChar)(0x64);
static const System::WideChar pmDayU = (System::WideChar)(0x44);
static const System::WideChar pmYear = (System::WideChar)(0x79);
static const System::WideChar pmDateSlash = (System::WideChar)(0x2f);
static const System::WideChar pmMonthName = (System::WideChar)(0x6e);
static const System::WideChar pmMonthNameU = (System::WideChar)(0x4e);
static const System::WideChar pmWeekDay = (System::WideChar)(0x77);
static const System::WideChar pmWeekDayU = (System::WideChar)(0x57);
static const System::WideChar pmLongDateSub1 = (System::WideChar)(0x66);
static const System::WideChar pmLongDateSub2 = (System::WideChar)(0x67);
static const System::WideChar pmLongDateSub3 = (System::WideChar)(0x68);
static const System::WideChar pmHour = (System::WideChar)(0x68);
static const System::WideChar pmHourU = (System::WideChar)(0x48);
static const System::WideChar pmMinute = (System::WideChar)(0x6d);
static const System::WideChar pmMinuteU = (System::WideChar)(0x4d);
static const System::WideChar pmSecond = (System::WideChar)(0x73);
static const System::WideChar pmSecondU = (System::WideChar)(0x53);
static const System::WideChar pmAmPm = (System::WideChar)(0x74);
static const System::WideChar pmTimeColon = (System::WideChar)(0x3a);
extern DELPHI_PACKAGE TCharSet PictureChars;
extern DELPHI_PACKAGE TCharSet SimplePictureChars;
static const System::Int8 MaxDateLen = System::Int8(0x28);
static const System::Int8 MaxMonthName = System::Int8(0xf);
static const System::Int8 MaxDayName = System::Int8(0xf);
static const System::Int8 otf_SizeData = System::Int8(0x0);
static const System::Int8 otf_GetData = System::Int8(0x1);
static const System::Int8 otf_SetData = System::Int8(0x2);
extern DELPHI_PACKAGE TRangeType BlankRange;
static const System::Byte MaxSearchString = System::Byte(0xff);
static const System::Int8 ss_None = System::Int8(0x0);
static const System::Int8 ss_Shift = System::Int8(0x2);
static const System::Int8 ss_Ctrl = System::Int8(0x4);
static const System::Int8 ss_Alt = System::Int8(0x8);
static const System::Byte ss_Wordstar = System::Byte(0x80);
static const System::Int8 VK_NONE = System::Int8(0x0);
static const System::Int8 VK_ALT = System::Int8(0x12);
static const System::Word VK_A = System::Word(0x41);
static const System::Word VK_B = System::Word(0x42);
static const System::Word VK_C = System::Word(0x43);
static const System::Word VK_D = System::Word(0x44);
static const System::Word VK_E = System::Word(0x45);
static const System::Word VK_F = System::Word(0x46);
static const System::Word VK_G = System::Word(0x47);
static const System::Word VK_H = System::Word(0x48);
static const System::Word VK_I = System::Word(0x49);
static const System::Word VK_J = System::Word(0x4a);
static const System::Word VK_K = System::Word(0x4b);
static const System::Word VK_L = System::Word(0x4c);
static const System::Word VK_M = System::Word(0x4d);
static const System::Word VK_N = System::Word(0x4e);
static const System::Word VK_O = System::Word(0x4f);
static const System::Word VK_P = System::Word(0x50);
static const System::Word VK_Q = System::Word(0x51);
static const System::Word VK_R = System::Word(0x52);
static const System::Word VK_S = System::Word(0x53);
static const System::Word VK_T = System::Word(0x54);
static const System::Word VK_U = System::Word(0x55);
static const System::Word VK_V = System::Word(0x56);
static const System::Word VK_W = System::Word(0x57);
static const System::Word VK_X = System::Word(0x58);
static const System::Word VK_Y = System::Word(0x59);
static const System::Word VK_Z = System::Word(0x5a);
static const System::Word VK_0 = System::Word(0x30);
static const System::Word VK_1 = System::Word(0x31);
static const System::Word VK_2 = System::Word(0x32);
static const System::Word VK_3 = System::Word(0x33);
static const System::Word VK_4 = System::Word(0x34);
static const System::Word VK_5 = System::Word(0x35);
static const System::Word VK_6 = System::Word(0x36);
static const System::Word VK_7 = System::Word(0x37);
static const System::Word VK_8 = System::Word(0x38);
static const System::Word VK_9 = System::Word(0x39);
extern DELPHI_PACKAGE TCharSet AlphaCharSet;
extern DELPHI_PACKAGE TCharSet IntegerCharSet;
extern DELPHI_PACKAGE TCharSet RealCharSet;
static const System::Int8 pflagLiteral = System::Int8(0x0);
static const System::Int8 pflagFormat = System::Int8(0x1);
static const System::Int8 pflagSemiLit = System::Int8(0x2);
static const System::Word OM_FIRST = System::Word(0x7f00);
static const System::Word OM_REPORTERROR = System::Word(0x7f00);
static const System::Word OM_SETFOCUS = System::Word(0x7f01);
static const System::Word OM_SHOWSTATUS = System::Word(0x7f02);
static const System::Word OM_GETDATASIZE = System::Word(0x7f03);
static const System::Word OM_RECREATEWND = System::Word(0x7f05);
static const System::Word OM_PREEDIT = System::Word(0x7f06);
static const System::Word OM_POSTEDIT = System::Word(0x7f07);
static const System::Word OM_AFTERENTER = System::Word(0x7f08);
static const System::Word OM_AFTEREXIT = System::Word(0x7f09);
static const System::Word OM_DELAYNOTIFY = System::Word(0x7f0a);
static const System::Word OM_POSITIONLABEL = System::Word(0x7f0b);
static const System::Word OM_RECORDLABELPOSITION = System::Word(0x7f0c);
static const System::Word OM_ASSIGNLABEL = System::Word(0x7f0d);
static const System::Word OM_FONTUPDATEPREVIEW = System::Word(0x7f0e);
static const System::Word OM_DESTROYHOOK = System::Word(0x7f0f);
static const System::Word OM_PROPCHANGE = System::Word(0x7f10);
static const System::Word OM_ISATTACHED = System::Word(0x7f11);
static const System::Word OM_VALIDATE = System::Word(0x7f12);
static const System::Word oeFirst = System::Word(0x100);
static const System::Word oeRangeError = System::Word(0x100);
static const System::Word oeInvalidNumber = System::Word(0x101);
static const System::Word oeRequiredField = System::Word(0x102);
static const System::Word oeInvalidDate = System::Word(0x103);
static const System::Word oeInvalidTime = System::Word(0x104);
static const System::Word oeBlanksInField = System::Word(0x105);
static const System::Word oePartialEntry = System::Word(0x106);
static const System::Word oeOutOfMemory = System::Word(0x107);
static const System::Word oeRegionSize = System::Word(0x108);
static const System::Word oeTooManyParas = System::Word(0x109);
static const System::Word oeCannotJoin = System::Word(0x10a);
static const System::Word oeTooManyBytes = System::Word(0x10b);
static const System::Word oeParaTooLong = System::Word(0x10c);
static const System::Word oeCustomError = System::Word(0x8000);
static const System::Int8 fcSimple = System::Int8(0x0);
static const System::Int8 fcPicture = System::Int8(0x1);
static const System::Int8 fcNumeric = System::Int8(0x2);
static const System::Int8 fcpDivisor = System::Int8(0x40);
static const System::Int8 fcpSimple = System::Int8(0x0);
static const System::Int8 fcpPicture = System::Int8(0x40);
static const System::Byte fcpNumeric = System::Byte(0x80);
static const System::Int8 fidSimpleString = System::Int8(0x0);
static const System::Int8 fidSimpleChar = System::Int8(0x1);
static const System::Int8 fidSimpleBoolean = System::Int8(0x2);
static const System::Int8 fidSimpleYesNo = System::Int8(0x3);
static const System::Int8 fidSimpleLongInt = System::Int8(0x4);
static const System::Int8 fidSimpleWord = System::Int8(0x5);
static const System::Int8 fidSimpleInteger = System::Int8(0x6);
static const System::Int8 fidSimpleByte = System::Int8(0x7);
static const System::Int8 fidSimpleShortInt = System::Int8(0x8);
static const System::Int8 fidSimpleReal = System::Int8(0x9);
static const System::Int8 fidSimpleExtended = System::Int8(0xa);
static const System::Int8 fidSimpleDouble = System::Int8(0xb);
static const System::Int8 fidSimpleSingle = System::Int8(0xc);
static const System::Int8 fidSimpleComp = System::Int8(0xd);
static const System::Int8 fidPictureString = System::Int8(0x40);
static const System::Int8 fidPictureChar = System::Int8(0x41);
static const System::Int8 fidPictureBoolean = System::Int8(0x42);
static const System::Int8 fidPictureYesNo = System::Int8(0x43);
static const System::Int8 fidPictureLongInt = System::Int8(0x44);
static const System::Int8 fidPictureWord = System::Int8(0x45);
static const System::Int8 fidPictureInteger = System::Int8(0x46);
static const System::Int8 fidPictureByte = System::Int8(0x47);
static const System::Int8 fidPictureShortInt = System::Int8(0x48);
static const System::Int8 fidPictureReal = System::Int8(0x49);
static const System::Int8 fidPictureExtended = System::Int8(0x4a);
static const System::Int8 fidPictureDouble = System::Int8(0x4b);
static const System::Int8 fidPictureSingle = System::Int8(0x4c);
static const System::Int8 fidPictureComp = System::Int8(0x4d);
static const System::Int8 fidPictureDate = System::Int8(0x4e);
static const System::Int8 fidPictureTime = System::Int8(0x4f);
static const System::Byte fidNumericLongInt = System::Byte(0x84);
static const System::Byte fidNumericWord = System::Byte(0x85);
static const System::Byte fidNumericInteger = System::Byte(0x86);
static const System::Byte fidNumericByte = System::Byte(0x87);
static const System::Byte fidNumericShortInt = System::Byte(0x88);
static const System::Byte fidNumericReal = System::Byte(0x89);
static const System::Byte fidNumericExtended = System::Byte(0x8a);
static const System::Byte fidNumericDouble = System::Byte(0x8b);
static const System::Byte fidNumericSingle = System::Byte(0x8c);
static const System::Byte fidNumericComp = System::Byte(0x8d);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetOrphStr(System::Word Index);
}	/* namespace Ovcdata */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDATA)
using namespace Ovcdata;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdataHPP
