// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32rxngn.pas' rev: 29.00 (Windows)

#ifndef O32rxngnHPP
#define O32rxngnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <o32intdeq.hpp>
#include <o32intlst.hpp>
#include <O32WideCharSet.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32rxngn
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32RegexEngine;
//-- type declarations -------------------------------------------------------
typedef O32widecharset::TWideCharSet *PO32CharSet;

typedef O32widecharset::TWideCharSet TO32CharSet;

enum DECLSPEC_DENUM TO32NFAMatchType : unsigned char { mtNone, mtAnyChar, mtChar, mtClass, mtNegClass, mtTerminal, mtUnused };

enum DECLSPEC_DENUM TO32RegexError : unsigned char { recNone, recSuddenEnd, recMetaChar, recNoCloseParen, recExtraChars };

typedef System::WideChar __fastcall (*TO32UpcaseChar)(System::WideChar aCh);

class PASCALIMPLEMENTATION TO32RegexEngine : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FAnchorEnd;
	bool FAnchorStart;
	TO32RegexError FErrorCode;
	bool FIgnoreCase;
	System::WideChar *FPosn;
	System::UnicodeString FRegexStr;
	int FStartState;
	System::Classes::TList* FTable;
	TO32UpcaseChar FUpcase;
	bool FLogging;
	System::TextFile Log;
	System::UnicodeString FLogFile;
	void __fastcall SetLogFile(const System::UnicodeString Value);
	void __fastcall rcSetIgnoreCase(bool aValue);
	void __fastcall rcSetRegexStr(const System::UnicodeString aRegexStr);
	void __fastcall rcSetUpcase(TO32UpcaseChar aValue);
	void __fastcall rcSetLogging(const bool aValue);
	void __fastcall rcClear(void);
	void __fastcall rcLevel1Optimize(void);
	void __fastcall rcLevel2Optimize(void);
	bool __fastcall rcMatchSubString(const System::UnicodeString S, int StartPosn);
	int __fastcall rcAddState(TO32NFAMatchType aMatchType, System::WideChar aChar, PO32CharSet aCharClass, int aNextState1, int aNextState2);
	int __fastcall rcSetState(int aState, int aNextState1, int aNextState2);
	int __fastcall rcParseAnchorExpr(void);
	int __fastcall rcParseAtom(void);
	System::WideChar __fastcall rcParseCCChar(void);
	int __fastcall rcParseChar(void);
	bool __fastcall rcParseCharClass(PO32CharSet aClass);
	bool __fastcall rcParseCharRange(PO32CharSet aClass);
	int __fastcall rcParseExpr(void);
	int __fastcall rcParseFactor(void);
	int __fastcall rcParseTerm(void);
	void __fastcall rcWalkNoCostTree(O32intlst::TO32IntList* aList, int aState);
	void __fastcall rcDumpTable(void);
	
public:
	__fastcall TO32RegexEngine(const System::UnicodeString aRegexStr);
	__fastcall virtual ~TO32RegexEngine(void);
	bool __fastcall Parse(int &aErrorPos, TO32RegexError &aErrorCode);
	int __fastcall MatchString(const System::UnicodeString S);
	__property bool IgnoreCase = {read=FIgnoreCase, write=rcSetIgnoreCase, nodefault};
	__property System::UnicodeString RegexString = {read=FRegexStr, write=rcSetRegexStr};
	__property TO32UpcaseChar Upcase = {read=FUpcase, write=rcSetUpcase};
	__property bool Logging = {read=FLogging, write=rcSetLogging, nodefault};
	__property System::UnicodeString LogFile = {read=FLogFile, write=SetLogFile};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32rxngn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32RXNGN)
using namespace O32rxngn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32rxngnHPP
