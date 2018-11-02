// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovceditn.pas' rev: 29.00 (Windows)

#ifndef OvceditnHPP
#define OvceditnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovceditn
{
//-- forward type declarations -----------------------------------------------
struct TUndoRec;
class DELPHICLASS TUndoNode;
class DELPHICLASS TParaNode;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM UndoType : unsigned char { utSavePos, utInsert, utInsPara, utPlacePara, utDelete, utDelPara, utReplace };

typedef System::StaticArray<System::Word, 32767> LineMap;

typedef LineMap *PLineMap;

typedef TUndoRec *PUndoRec;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TUndoRec
{
	
private:
	struct DECLSPEC_DRECORD _TUndoRec__1
	{
	};
	
	
	
public:
	int PNum;
	int PPos;
	System::Word DSize;
	System::Word PrevSize;
	System::Byte Flags;
	System::Byte LinkNum;
	_TUndoRec__1 Data;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TUndoNode : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TUndoRec *UndoRec;
	void __fastcall Init(PUndoRec PUR, UndoType UT, System::Byte Link, bool MF, System::Word PSize, int P, int Pos, System::WideChar * D, System::Word DLen);
	void __fastcall InitReplace(PUndoRec PUR, System::Byte Link, bool MF, System::Word PSize, int P, int Pos, System::WideChar * D, System::Word DLen, System::WideChar * R, System::Word RLen);
	void __fastcall Done(PUndoRec PUR);
	UndoType __fastcall GetUndoType(PUndoRec PUR);
	bool __fastcall ModFlag(PUndoRec PUR);
	void __fastcall SetModFlag(PUndoRec PUR, bool Value);
public:
	/* TObject.Create */ inline __fastcall TUndoNode(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TUndoNode(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TParaNode : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::Word BufSize;
	int LineCount;
	LineMap *Map;
	System::Word MapSize;
	TParaNode* Next;
	TParaNode* Prev;
	System::WideChar *S;
	System::Word SLen;
	__fastcall TParaNode(System::WideChar * P, int WrapCol, int TabSize);
	__fastcall TParaNode(System::WideChar * P, System::Word Len, int WrapCol, int TabSize);
	__fastcall virtual ~TParaNode(void);
	System::WideChar * __fastcall GetS(void);
	bool __fastcall ExpandToLength(System::Word NBS);
	System::Word __fastcall EstimateMapSize(System::Word Len, int WrapCol);
	void __fastcall ExpandLineMap(System::Word NMS);
	void __fastcall Recalc(int WrapCol, int TabSize);
	void __fastcall RecalcAfterInsDel(int WrapCol, int TabSize, int Pos, int RplLen, int Count, int &FL, int &LL);
	System::WideChar * __fastcall NthLine(int N, System::Word &Len);
	int __fastcall PosToLine(int Pos, int &Col);
	System::Word __fastcall InsertTextPrim(System::WideChar * St, System::Word StLen, int Pos, int WrapCol, int TabSize, int &FL, int &LL);
	System::Word __fastcall InsertText(System::WideChar * St, int Pos, int WrapCol, int TabSize, int &FL, int &LL);
	void __fastcall DeleteText(int Pos, int Count, int WrapCol, int TabSize, int &FL, int &LL);
	System::Word __fastcall ReplaceText(int Pos, int Count, int WrapCol, int TabSize, System::WideChar * St, int StLen, int &FL, int &LL);
	System::Word __fastcall TrimWhiteSpace(void);
	System::Word __fastcall CountWhiteSpace(int Pos);
public:
	/* TObject.Create */ inline __fastcall TParaNode(void) : System::TObject() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const int UndoRecSize = int(0xe);
}	/* namespace Ovceditn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDITN)
using namespace Ovceditn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvceditnHPP
