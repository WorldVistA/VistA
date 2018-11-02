// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrvexp.pas' rev: 29.00 (Windows)

#ifndef OvcrvexpHPP
#define OvcrvexpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <ovccoco.hpp>
#include <ovcrvexpdef.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrvexp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EOvcRvExp;
class DELPHICLASS TOvcRvExpScanner;
class DELPHICLASS TOvcRvExp;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<Ovccoco::TBitSet, 4> SymbolSet;

class PASCALIMPLEMENTATION EOvcRvExp : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EOvcRvExp(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EOvcRvExp(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EOvcRvExp(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EOvcRvExp(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EOvcRvExp(NativeUInt Ident, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EOvcRvExp(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EOvcRvExp(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EOvcRvExp(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOvcRvExp(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOvcRvExp(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOvcRvExp(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOvcRvExp(NativeUInt Ident, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EOvcRvExp(void) { }
	
};


class PASCALIMPLEMENTATION TOvcRvExpScanner : public Ovccoco::TCocoRScanner
{
	typedef Ovccoco::TCocoRScanner inherited;
	
private:
	TOvcRvExp* FOwner;
	Ovccoco::TCommentList* fLastCommentList;
	void __fastcall CheckLiteral(int &Sym);
	bool __fastcall Equal(System::UnicodeString s);
	bool __fastcall Comment(void);
	
protected:
	virtual void __fastcall NextCh(void);
	
public:
	__fastcall TOvcRvExpScanner(void);
	__fastcall virtual ~TOvcRvExpScanner(void);
	virtual void __fastcall Get(int &sym);
	__property CurrentSymbol;
	__property NextSymbol;
	__property OnStatusUpdate;
	__property TOvcRvExp* Owner = {read=FOwner, write=FOwner};
	__property ScannerError;
	__property SrcStream;
};


class PASCALIMPLEMENTATION TOvcRvExp : public Ovccoco::TCocoRGrammar
{
	typedef Ovccoco::TCocoRGrammar inherited;
	
private:
	System::StaticArray<System::StaticArray<Ovccoco::TBitSet, 4>, 7> symSet;
	Ovccoco::TCommentEvent fInternalGrammarComment;
	int __fastcall GetMajorVersion(void);
	int __fastcall GetMinorVersion(void);
	int __fastcall GetRelease(void);
	int __fastcall GetBuild(void);
	System::TDateTime __fastcall GetBuildDate(void);
	System::UnicodeString __fastcall GetVersion(void);
	void __fastcall SetVersion(const System::UnicodeString Value);
	bool __fastcall _In(SymbolSet &s, int x);
	void __fastcall InitSymSet(void);
	void __fastcall _BooleanLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpBooleanLiteral* &BooleanLiteral);
	void __fastcall _TimestampLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpTimestampLiteral* &TimestampLiteral);
	void __fastcall _TimeLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpTimeLiteral* &TimeLiteral);
	void __fastcall _DateLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpDateLiteral* &DateLiteral);
	void __fastcall _StringLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpStringLiteral* &StringLiteral);
	void __fastcall _IntegerLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpIntegerLiteral* &IntegerLiteral);
	void __fastcall _FloatLiteral(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpFloatLiteral* &FloatLiteral);
	void __fastcall _WhenClause(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpWhenClause* &WhenClause);
	void __fastcall _WhenClauseList(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpWhenClauseList* &WhenClauseList);
	void __fastcall _CaseExpression(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpCaseExpression* &CaseExp);
	void __fastcall _ScalarFunction(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpScalarFunc* &Func);
	void __fastcall _Literal(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpLiteral* &Literal);
	void __fastcall _Factor(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpFactor* &Factor, Ovcrvexpdef::TOvcRvExpMulOp MulOp);
	void __fastcall _Term(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpTerm* &Term, Ovcrvexpdef::TOvcRvExpAddOp AddOp);
	void __fastcall _SimpleExpressionList(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpSimpleExpressionList* &SimpleExpressionList);
	void __fastcall _IsTest(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpIsTest* &IsTest);
	void __fastcall _LikeClause(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpLikeClause* &LikeClause, bool Negated);
	void __fastcall _InClause(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpInClause* &InClause, bool Negated);
	void __fastcall _BetweenClause(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpBetweenClause* &BetweenClause, bool Negated);
	void __fastcall _CondPrimary(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpCondPrimary* &CondPrimary);
	void __fastcall _CondFactor(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpCondFactor* &CondFactor);
	void __fastcall _CondTerm(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpCondTerm* &CondTerm);
	void __fastcall _CondExpList(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpressionList* &CondExpList);
	void __fastcall _FieldRef(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpFieldRef* &FieldRef);
	void __fastcall _SimpleExpression(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpSimpleExpression* &SimpleExpression);
	void __fastcall _Aggregate(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpAggregate* &Aggregate);
	void __fastcall _CondExp(Ovcrvexpdef::TOvcRvExpNode* Parent, Ovcrvexpdef::TOvcRvExpression* &CondExp);
	void __fastcall _OvcRvExp(void);
	Ovcrvexpdef::TOvcRvExpression* FRootNode;
	void __fastcall Init(void);
	void __fastcall Final(void);
	
protected:
	virtual void __fastcall Get(void);
	__property Ovccoco::TCommentEvent InternalGrammarComment = {read=fInternalGrammarComment, write=fInternalGrammarComment};
	
public:
	__fastcall virtual TOvcRvExp(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcRvExp(void);
	virtual System::UnicodeString __fastcall ErrorStr(const int ErrorCode, const System::UnicodeString Data);
	void __fastcall Execute(void);
	TOvcRvExpScanner* __fastcall GetScanner(void);
	void __fastcall Parse(void);
	__property ErrorList;
	__property ListStream;
	__property SourceStream;
	__property Successful;
	__property int MajorVersion = {read=GetMajorVersion, nodefault};
	__property int MinorVersion = {read=GetMinorVersion, nodefault};
	__property int Release = {read=GetRelease, nodefault};
	__property int Build = {read=GetBuild, nodefault};
	__property System::TDateTime BuildDate = {read=GetBuildDate};
	__property Ovcrvexpdef::TOvcRvExpression* RootNode = {read=FRootNode, write=FRootNode};
	
__published:
	__property AfterParse;
	__property AfterGenList;
	__property BeforeGenList;
	__property BeforeParse;
	__property ClearSourceStream = {default=1};
	__property GenListWhen = {default=2};
	__property SourceFileName = {default=0};
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion};
	__property OnCustomError;
	__property OnError;
	__property OnFailure;
	__property OnStatusUpdate;
	__property OnSuccess;
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 maxT = System::Int8(0x3c);
}	/* namespace Ovcrvexp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRVEXP)
using namespace Ovcrvexp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrvexpHPP
