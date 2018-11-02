// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccoco.pas' rev: 29.00 (Windows)

#ifndef OvccocoHPP
#define OvccocoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccoco
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TCocoError;
class DELPHICLASS TCommentItem;
class DELPHICLASS TCommentList;
class DELPHICLASS TSymbolPosition;
class DELPHICLASS TCocoRScanner;
class DELPHICLASS TCocoRGrammar;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCocoError : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FErrorCode;
	int FCol;
	int FLine;
	System::UnicodeString FData;
	int FErrorType;
	
public:
	__property int ErrorType = {read=FErrorType, write=FErrorType, nodefault};
	__property int ErrorCode = {read=FErrorCode, write=FErrorCode, nodefault};
	__property int Line = {read=FLine, write=FLine, nodefault};
	__property int Col = {read=FCol, write=FCol, nodefault};
	__property System::UnicodeString Data = {read=FData, write=FData};
public:
	/* TObject.Create */ inline __fastcall TCocoError(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TCocoError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCommentItem : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString fComment;
	int fLine;
	int fColumn;
	
public:
	__property System::UnicodeString Comment = {read=fComment, write=fComment};
	__property int Line = {read=fLine, write=fLine, nodefault};
	__property int Column = {read=fColumn, write=fColumn, nodefault};
public:
	/* TObject.Create */ inline __fastcall TCommentItem(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TCommentItem(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCommentList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString operator[](int Idx) { return Comments[Idx]; }
	
private:
	System::Classes::TList* fList;
	System::UnicodeString __fastcall FixComment(const System::UnicodeString S);
	System::UnicodeString __fastcall GetComments(int Idx);
	void __fastcall SetComments(int Idx, const System::UnicodeString Value);
	int __fastcall GetCount(void);
	System::UnicodeString __fastcall GetText(void);
	int __fastcall GetColumn(int Idx);
	int __fastcall GetLine(int Idx);
	void __fastcall SetColumn(int Idx, const int Value);
	void __fastcall SetLine(int Idx, const int Value);
	
public:
	__fastcall TCommentList(void);
	__fastcall virtual ~TCommentList(void);
	void __fastcall Clear(void);
	void __fastcall Add(const System::UnicodeString S, const int aLine, const int aColumn);
	__property System::UnicodeString Comments[int Idx] = {read=GetComments, write=SetComments/*, default*/};
	__property int Line[int Idx] = {read=GetLine, write=SetLine};
	__property int Column[int Idx] = {read=GetColumn, write=SetColumn};
	__property int Count = {read=GetCount, nodefault};
	__property System::UnicodeString Text = {read=GetText};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSymbolPosition : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int fLine;
	int fCol;
	int fLen;
	int fPos;
	
public:
	void __fastcall Clear(void);
	__property int Line = {read=fLine, write=fLine, nodefault};
	__property int Col = {read=fCol, write=fCol, nodefault};
	__property int Len = {read=fLen, write=fLen, nodefault};
	__property int Pos = {read=fPos, write=fPos, nodefault};
public:
	/* TObject.Create */ inline __fastcall TSymbolPosition(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TSymbolPosition(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TGenListType : unsigned char { glNever, glAlways, glOnError };

typedef System::Set<System::Int8, 0, 15> TBitSet;

typedef System::StaticArray<int, 256> TStartTable;

typedef TStartTable *PStartTable;

typedef System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> TCharSet;

typedef void __fastcall (__closure *TAfterGenListEvent)(System::TObject* Sender, bool &PrintErrorCount);

typedef void __fastcall (__closure *TCommentEvent)(System::TObject* Sender, TCommentList* CommentList);

typedef System::UnicodeString __fastcall (__closure *TCustomErrorEvent)(System::TObject* Sender, const int ErrorCode, const System::UnicodeString Data);

typedef void __fastcall (__closure *TErrorEvent)(System::TObject* Sender, TCocoError* Error);

typedef void __fastcall (__closure *TErrorProc)(int ErrorCode, TSymbolPosition* Symbol, const System::UnicodeString Data, int ErrorType);

typedef void __fastcall (__closure *TFailureEvent)(System::TObject* Sender, int NumErrors);

typedef System::WideChar __fastcall (__closure *TGetCH)(int pos);

typedef void __fastcall (__closure *TStatusUpdateProc)(System::TObject* Sender, System::UnicodeString Status, int LineNum);

class PASCALIMPLEMENTATION TCocoRScanner : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FbpCurrToken;
	int FBufferPosition;
	int FContextLen;
	TGetCH FCurrentCh;
	TSymbolPosition* FCurrentSymbol;
	System::WideChar FCurrInputCh;
	int FCurrLine;
	System::WideChar FLastInputCh;
	TSymbolPosition* FNextSymbol;
	int FNumEOLInComment;
	TStatusUpdateProc FOnStatusUpdate;
	TErrorProc FScannerError;
	int FSourceLen;
	System::Classes::TMemoryStream* FSrcStream;
	int FStartOfLine;
	System::UnicodeString __fastcall GetNStr(TSymbolPosition* Symbol, TGetCH ChProc);
	
protected:
	TStartTable FStartState;
	System::WideChar __fastcall CapChAt(int pos);
	virtual void __fastcall Get(int &sym) = 0 ;
	virtual void __fastcall NextCh(void) = 0 ;
	PStartTable __fastcall GetStartState(void);
	void __fastcall SetStartState(PStartTable aStartTable);
	__property int bpCurrToken = {read=FbpCurrToken, write=FbpCurrToken, nodefault};
	__property int BufferPosition = {read=FBufferPosition, write=FBufferPosition, nodefault};
	__property int ContextLen = {read=FContextLen, write=FContextLen, nodefault};
	__property TGetCH CurrentCh = {read=FCurrentCh, write=FCurrentCh};
	__property TSymbolPosition* CurrentSymbol = {read=FCurrentSymbol, write=FCurrentSymbol};
	__property System::WideChar CurrInputCh = {read=FCurrInputCh, write=FCurrInputCh, nodefault};
	__property int CurrLine = {read=FCurrLine, write=FCurrLine, nodefault};
	__property System::WideChar LastInputCh = {read=FLastInputCh, write=FLastInputCh, nodefault};
	__property TSymbolPosition* NextSymbol = {read=FNextSymbol, write=FNextSymbol};
	__property int NumEOLInComment = {read=FNumEOLInComment, write=FNumEOLInComment, nodefault};
	__property TStatusUpdateProc OnStatusUpdate = {read=FOnStatusUpdate, write=FOnStatusUpdate};
	__property TErrorProc ScannerError = {read=FScannerError, write=FScannerError};
	__property int SourceLen = {read=FSourceLen, write=FSourceLen, nodefault};
	__property System::Classes::TMemoryStream* SrcStream = {read=FSrcStream, write=FSrcStream};
	__property int StartOfLine = {read=FStartOfLine, write=FStartOfLine, nodefault};
	__property PStartTable StartState = {read=GetStartState, write=SetStartState};
	
public:
	__fastcall TCocoRScanner(void);
	__fastcall virtual ~TCocoRScanner(void);
	System::WideChar __fastcall CharAt(int pos);
	System::UnicodeString __fastcall GetName(TSymbolPosition* Symbol);
	System::UnicodeString __fastcall GetString(TSymbolPosition* Symbol);
	void __fastcall _Reset(void);
};


class PASCALIMPLEMENTATION TCocoRGrammar : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TAfterGenListEvent FAfterGenList;
	System::Classes::TNotifyEvent FAfterParse;
	System::Classes::TNotifyEvent FBeforeGenList;
	System::Classes::TNotifyEvent FBeforeParse;
	bool fClearSourceStream;
	int FErrDist;
	System::Classes::TList* FErrorList;
	TGenListType fGenListWhen;
	System::Classes::TMemoryStream* FListStream;
	TCustomErrorEvent FOnCustomError;
	TErrorEvent FOnError;
	TFailureEvent FOnFailure;
	TStatusUpdateProc FOnStatusUpdate;
	System::Classes::TNotifyEvent FOnSuccess;
	TCocoRScanner* FScanner;
	System::UnicodeString FSourceFileName;
	int fExtra;
	System::Classes::TMemoryStream* __fastcall GetSourceStream(void);
	bool __fastcall GetSuccessful(void);
	void __fastcall SetOnStatusUpdate(const TStatusUpdateProc Value);
	void __fastcall SetSourceStream(System::Classes::TMemoryStream* const Value);
	int __fastcall GetLineCount(void);
	int __fastcall GetCharacterCount(void);
	
protected:
	int fCurrentInputSymbol;
	void __fastcall ClearErrors(void);
	void __fastcall Expect(int n);
	void __fastcall GenerateListing(void);
	virtual void __fastcall Get(void) = 0 ;
	void __fastcall PrintErr(const System::UnicodeString line, int ErrorCode, int col, const System::UnicodeString Data);
	void __fastcall StoreError(int nr, TSymbolPosition* Symbol, const System::UnicodeString Data, int ErrorType);
	__property bool ClearSourceStream = {read=fClearSourceStream, write=fClearSourceStream, default=1};
	__property int CurrentInputSymbol = {read=fCurrentInputSymbol, write=fCurrentInputSymbol, nodefault};
	__property int ErrDist = {read=FErrDist, write=FErrDist, nodefault};
	__property int Extra = {read=fExtra, write=fExtra, nodefault};
	__property TGenListType GenListWhen = {read=fGenListWhen, write=fGenListWhen, default=2};
	__property System::Classes::TMemoryStream* ListStream = {read=FListStream, write=FListStream};
	__property System::UnicodeString SourceFileName = {read=FSourceFileName, write=FSourceFileName};
	__property bool Successful = {read=GetSuccessful, nodefault};
	__property System::Classes::TNotifyEvent AfterParse = {read=FAfterParse, write=FAfterParse};
	__property TAfterGenListEvent AfterGenList = {read=FAfterGenList, write=FAfterGenList};
	__property System::Classes::TNotifyEvent BeforeGenList = {read=FBeforeGenList, write=FBeforeGenList};
	__property System::Classes::TNotifyEvent BeforeParse = {read=FBeforeParse, write=FBeforeParse};
	__property TCustomErrorEvent OnCustomError = {read=FOnCustomError, write=FOnCustomError};
	__property TFailureEvent OnFailure = {read=FOnFailure, write=FOnFailure};
	__property TStatusUpdateProc OnStatusUpdate = {read=FOnStatusUpdate, write=SetOnStatusUpdate};
	__property System::Classes::TNotifyEvent OnSuccess = {read=FOnSuccess, write=FOnSuccess};
	
public:
	virtual System::UnicodeString __fastcall ErrorStr(const int ErrorCode, const System::UnicodeString Data) = 0 ;
	__property System::Classes::TList* ErrorList = {read=FErrorList, write=FErrorList};
	__property System::Classes::TMemoryStream* SourceStream = {read=GetSourceStream, write=SetSourceStream};
	__fastcall virtual TCocoRGrammar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCocoRGrammar(void);
	void __fastcall GetLine(int &pos, System::UnicodeString &line, bool &eof);
	System::UnicodeString __fastcall LexName(void);
	System::UnicodeString __fastcall LexString(void);
	System::UnicodeString __fastcall LookAheadName(void);
	System::UnicodeString __fastcall LookAheadString(void);
	void __fastcall _StreamLine(System::UnicodeString s);
	void __fastcall _StreamLn(const System::UnicodeString s);
	void __fastcall SemError(const int errNo, const System::UnicodeString Data);
	void __fastcall SynError(const int errNo);
	__property TCocoRScanner* Scanner = {read=FScanner, write=FScanner};
	__property int LineCount = {read=GetLineCount, nodefault};
	__property int CharacterCount = {read=GetCharacterCount, nodefault};
	__property TErrorEvent OnError = {read=FOnError, write=FOnError};
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 setsize = System::Int8(0x10);
static const System::Int8 etSyntax = System::Int8(0x0);
static const System::Int8 etSymantic = System::Int8(0x1);
static const System::WideChar chCR = (System::WideChar)(0xd);
static const System::WideChar chLF = (System::WideChar)(0xa);
#define chEOL L"\r\n"
static const System::WideChar chLineSeparator = (System::WideChar)(0xd);
static const System::WideChar _EF = (System::WideChar)(0x0);
static const System::WideChar _TAB = (System::WideChar)(0x9);
static const System::WideChar _CR = (System::WideChar)(0xd);
static const System::WideChar _LF = (System::WideChar)(0xa);
static const System::WideChar _EL = (System::WideChar)(0xd);
static const System::WideChar _EOF = (System::WideChar)(0x1a);
extern DELPHI_PACKAGE TCharSet LineEnds;
static const System::Int8 minErrDist = System::Int8(0x2);
extern DELPHI_PACKAGE System::UnicodeString __fastcall PadL(System::UnicodeString S, System::WideChar ch, int L);
}	/* namespace Ovccoco */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCOCO)
using namespace Ovccoco;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccocoHPP
