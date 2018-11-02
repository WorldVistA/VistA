// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovceditp.pas' rev: 29.00 (Windows)

#ifndef OvceditpHPP
#define OvceditpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.SysUtils.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovceditn.hpp>
#include <ovceditu.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovceditp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcParaList;
class DELPHICLASS TOvcUndoBuffer;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcParaList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Ovceditu::TOvcEditBase* Owner;
	Ovceditn::TParaNode* Head;
	Ovceditn::TParaNode* Tail;
	Ovceditn::TParaNode* LastNode;
	int LastP;
	int LastN;
	int LastO;
	int ParaCount;
	int CharCount;
	int LineCount;
	int MaxParas;
	int MaxBytes;
	int MaxParaLen;
	bool WordWrap;
	int WrapColumn;
	System::Byte TabSize;
	bool Modified;
	bool FixMarkers;
	Ovceditu::TMarkerArray Markers;
	TOvcUndoBuffer* UndoBuffer;
	bool InUndo;
	int FLine;
	int LLine;
	__fastcall virtual TOvcParaList(Ovceditu::TOvcEditBase* AOwner, System::Word UndoSize, bool Wrap);
	__fastcall virtual ~TOvcParaList(void);
	void __fastcall MakeUndoRec(Ovceditn::UndoType UT, int P, int Pos, System::WideChar * S, System::Word Len);
	void __fastcall MakeReplaceUndoRec(int P, int Pos, System::WideChar * S, System::Word Len, System::WideChar * R, System::Word RLen);
	void __fastcall Undo(Ovceditu::TOvcEditBase* Editor, int &P, int &Pos);
	void __fastcall Redo(Ovceditu::TOvcEditBase* Editor, int &P, int &Pos);
	void __fastcall SetUndoSize(System::Word Size);
	void __fastcall Insert(Ovceditn::TParaNode* PPN);
	void __fastcall Append(Ovceditn::TParaNode* PPN);
	void __fastcall Place(Ovceditn::TParaNode* PPN, Ovceditn::TParaNode* LPN);
	void __fastcall PlaceBefore(Ovceditn::TParaNode* PPN, Ovceditn::TParaNode* LPN);
	void __fastcall SetLastNode(Ovceditn::TParaNode* PPN, int P, int N, int O);
	Ovceditn::TParaNode* __fastcall NthPara(int P);
	Ovceditn::TParaNode* __fastcall NthLine(int N, System::WideChar * &S, System::Word &Len);
	int __fastcall FindParaByLine(int N, int &LinePos);
	int __fastcall FindLineByPara(int P, int Pos, int &Col);
	void __fastcall ResetPositionInfo(void);
	void __fastcall Recalculate(void);
	int __fastcall GetWrapColumn(void);
	void __fastcall SetWrapColumn(int Value);
	void __fastcall SetTabSize(System::Byte Value);
	void __fastcall SetByteLimit(int Value);
	void __fastcall SetParaLimit(int Value);
	void __fastcall SetWordWrap(bool Value);
	int __fastcall ParaLength(int Value);
	int __fastcall LineLength(int Value);
	System::Word __fastcall EffStrLen(System::WideChar * S, System::Word Len);
	System::Word __fastcall EffLen(int N);
	System::Word __fastcall EffCol(System::WideChar * S, System::Word Len, System::Word Col);
	System::Word __fastcall ActualCol(System::WideChar * S, System::Word Len, System::Word Col);
	System::Word __fastcall OkToInsert(int P, System::Word Paras, System::Word Bytes);
	System::Word __fastcall AppendParaEof(System::WideChar * S, System::Word SLen, bool Trim);
	void __fastcall InsertParaNode(Ovceditu::TOvcEditBase* Editor, int P, Ovceditn::TParaNode* NPN);
	System::Word __fastcall InsertParaPrim(Ovceditu::TOvcEditBase* Editor, int P, System::WideChar * S, System::Word Len);
	void __fastcall PlaceParaNode(Ovceditu::TOvcEditBase* Editor, int P, Ovceditn::TParaNode* NPN);
	System::Word __fastcall PlaceParaPrim(Ovceditu::TOvcEditBase* Editor, int P, System::WideChar * S, System::Word Len);
	System::Word __fastcall InsertTextPrim(Ovceditu::TOvcEditBase* Editor, int P, int Pos, System::WideChar * S, System::Word SLen);
	System::Word __fastcall InsertBlock(Ovceditu::TOvcEditBase* Editor, int &P, int &Pos, System::WideChar * S);
	void __fastcall DeletePara(Ovceditu::TOvcEditBase* Editor, int P);
	void __fastcall DeleteText(Ovceditu::TOvcEditBase* Editor, int P, int Pos, int Count);
	void __fastcall DeleteBlock(Ovceditu::TOvcEditBase* Editor, int Para1, int Pos1, int Para2, int Pos2);
	System::Word __fastcall JoinWithNext(Ovceditu::TOvcEditBase* Editor, int P, int Pos);
	System::Word __fastcall BreakPara(Ovceditu::TOvcEditBase* Editor, int P, int Pos, int TabSz, int &Indent, bool Trim);
	System::Word __fastcall ReplaceText(Ovceditu::TOvcEditBase* Editor, int P, int Pos, int Count, System::WideChar * St, int StLen);
	void __fastcall SetMarker(System::Byte N, int Para, int Pos);
	void __fastcall SetMarkerAt(System::Byte N, int Line, int Col);
	void __fastcall FixMarkerInsertedPara(Ovceditu::TMarker &M, int N, int Pos, int Indent);
	void __fastcall FixMarkersInsertedPara(Ovceditu::TOvcEditBase* Editor, int N, int Pos, int Indent);
	void __fastcall FixMarkerInsertedText(Ovceditu::TMarker &M, int N, int Pos, int Count);
	void __fastcall FixMarkersInsertedText(Ovceditu::TOvcEditBase* Editor, int N, int Pos, int Count);
	void __fastcall FixMarkDeletedPara(Ovceditu::TMarker &M, int N);
	void __fastcall FixMarkerDeletedPara(Ovceditu::TMarker &M, int N);
	void __fastcall FixMarkersDeletedPara(Ovceditu::TOvcEditBase* Editor, int N);
	void __fastcall FixMarkDeletedText(Ovceditu::TMarker &M, int N, int Pos, int Count);
	void __fastcall FixMarkerDeletedText(Ovceditu::TMarker &M, int N, int Pos, int Count);
	void __fastcall FixMarkersDeletedText(Ovceditu::TOvcEditBase* Editor, int N, int Pos, int Count);
	void __fastcall FixMarkerJoinedParas(Ovceditu::TMarker &M, int N, int Pos);
	void __fastcall FixMarkersJoinedParas(Ovceditu::TOvcEditBase* Editor, int N, int Pos);
public:
	/* TObject.Create */ inline __fastcall TOvcParaList(void) : System::TObject() { }
	
};


class PASCALIMPLEMENTATION TOvcUndoBuffer : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TOvcParaList* Owner;
	void *Buffer;
	System::Word BufSize;
	System::Word BufAvail;
	Ovceditn::TUndoRec *Last;
	System::Word Undos;
	System::Word Redos;
	System::Byte CurLink;
	bool Linking;
	bool Error;
	Ovceditn::TUndoNode* GUN;
	__fastcall virtual TOvcUndoBuffer(TOvcParaList* ParaList, System::Word Size);
	__fastcall virtual ~TOvcUndoBuffer(void);
	void __fastcall Flush(void);
	bool __fastcall CheckSize(int Bytes);
	bool __fastcall SameOperation(Ovceditn::UndoType UT, bool &Before, int P, int Pos, System::Word DLen);
	void __fastcall Append(System::WideChar * D, System::Word DLen);
	void __fastcall Prepend(System::WideChar * D, System::Word DLen);
	void __fastcall AppendReplace(System::WideChar * D, System::Word DLen, System::WideChar * R, System::Word RLen);
	void __fastcall Push(Ovceditn::UndoType UT, bool MF, int P, int Pos, System::WideChar * D, System::Word DLen);
	void __fastcall PushReplace(bool MF, int P, int Pos, System::WideChar * D, System::Word DLen, System::WideChar * R, System::Word RLen);
	void __fastcall GetUndo(Ovceditn::UndoType &UT, System::Byte &Link, bool &MF, int &P, int &Pos, System::WideChar * &D, System::Word &DLen);
	void __fastcall GetRedo(Ovceditn::UndoType &UT, System::Byte &Link, bool &MF, int &P, int &Pos, System::WideChar * &D, System::Word &DLen);
	void __fastcall PeekUndoLink(System::Byte &Link);
	void __fastcall PeekRedoLink(System::Byte &Link);
	Ovceditn::PUndoRec __fastcall NthRec(int N);
	void __fastcall SetModified(void);
	void __fastcall BeginComplexOp(bool &SaveLinking);
	void __fastcall EndComplexOp(bool SaveLinking);
public:
	/* TObject.Create */ inline __fastcall TOvcUndoBuffer(void) : System::TObject() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 edMaxMarkers = System::Int8(0xa);
}	/* namespace Ovceditp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDITP)
using namespace Ovceditp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvceditpHPP
