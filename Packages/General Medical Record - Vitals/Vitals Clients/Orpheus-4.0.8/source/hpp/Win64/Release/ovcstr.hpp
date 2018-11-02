// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcstr.pas' rev: 29.00 (Windows)

#ifndef OvcstrHPP
#define OvcstrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcstr
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::Byte, 256> BTable;

typedef System::Sysutils::TSysCharSet TOvcCharSet;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::WideChar * __fastcall BinaryBPChar(System::WideChar * Dest, System::Byte B);
extern DELPHI_PACKAGE System::WideChar * __fastcall BinaryLPChar(System::WideChar * Dest, int L);
extern DELPHI_PACKAGE System::WideChar * __fastcall BinaryWPChar(System::WideChar * Dest, System::Word W);
extern DELPHI_PACKAGE void __fastcall BMMakeTable(System::WideChar * MatchString, BTable &BT);
extern DELPHI_PACKAGE bool __fastcall BMSearch(void *Buffer, unsigned BufLength, BTable &BT, System::WideChar * MatchString, unsigned &Pos);
extern DELPHI_PACKAGE bool __fastcall BMSearchUC(void *Buffer, unsigned BufLength, BTable &BT, System::WideChar * MatchString, unsigned &Pos);
extern DELPHI_PACKAGE System::WideChar * __fastcall CharStrPChar(System::WideChar * Dest, System::WideChar C, unsigned Len);
extern DELPHI_PACKAGE System::WideChar * __fastcall DetabPChar(System::WideChar * Dest, System::WideChar * Src, System::Byte TabSize);
extern DELPHI_PACKAGE System::WideChar * __fastcall HexBPChar(System::WideChar * Dest, System::Byte B);
extern DELPHI_PACKAGE System::WideChar * __fastcall HexLPChar(System::WideChar * Dest, int L);
extern DELPHI_PACKAGE System::WideChar * __fastcall HexPtrPChar(System::WideChar * Dest, void * P);
extern DELPHI_PACKAGE System::WideChar * __fastcall HexWPChar(System::WideChar * Dest, System::Word W);
extern DELPHI_PACKAGE System::WideChar __fastcall LoCaseChar(System::WideChar C);
extern DELPHI_PACKAGE System::WideChar * __fastcall OctalLPChar(System::WideChar * Dest, int L);
extern DELPHI_PACKAGE System::WideChar * __fastcall StrChDeletePrim(System::WideChar * P, unsigned Pos);
extern DELPHI_PACKAGE System::WideChar * __fastcall StrChInsertPrim(System::WideChar * Dest, System::WideChar C, unsigned Pos);
extern DELPHI_PACKAGE bool __fastcall StrChPos(System::WideChar * P, System::WideChar C, unsigned &Pos);
extern DELPHI_PACKAGE void __fastcall StrInsertChars(System::WideChar * Dest, System::WideChar Ch, System::Word Pos, System::Word Count);
extern DELPHI_PACKAGE System::WideChar * __fastcall StrStCopy(System::WideChar * Dest, System::WideChar * S, unsigned Pos, unsigned Count);
extern DELPHI_PACKAGE System::WideChar * __fastcall StrStDeletePrim(System::WideChar * P, unsigned Pos, unsigned Count);
extern DELPHI_PACKAGE System::WideChar * __fastcall StrStInsert(System::WideChar * Dest, System::WideChar * S1, System::WideChar * S2, unsigned Pos);
extern DELPHI_PACKAGE System::WideChar * __fastcall StrStInsertPrim(System::WideChar * Dest, System::WideChar * S, unsigned Pos);
extern DELPHI_PACKAGE bool __fastcall StrStPos(System::WideChar * P, System::WideChar * S, unsigned &Pos);
extern DELPHI_PACKAGE bool __fastcall StrToLongPChar(System::WideChar * S, NativeInt &I);
extern DELPHI_PACKAGE void __fastcall TrimAllSpacesPChar(System::WideChar * P);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TrimEmbeddedZeros(const System::UnicodeString S);
extern DELPHI_PACKAGE void __fastcall TrimEmbeddedZerosPChar(System::WideChar * P);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TrimTrailingZeros(const System::UnicodeString S);
extern DELPHI_PACKAGE void __fastcall TrimTrailingZerosPChar(System::WideChar * P);
extern DELPHI_PACKAGE System::WideChar * __fastcall TrimTrailPrimPChar(System::WideChar * S);
extern DELPHI_PACKAGE System::WideChar * __fastcall TrimTrailPChar(System::WideChar * Dest, System::WideChar * S);
extern DELPHI_PACKAGE System::WideChar __fastcall UpCaseChar(System::WideChar C);
extern DELPHI_PACKAGE bool __fastcall ovc32StringIsCurrentCodePage(const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE bool __fastcall ovc32StringIsCurrentCodePage(const System::WideChar * S, unsigned CP = (unsigned)(0x0))/* overload */;
}	/* namespace Ovcstr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSTR)
using namespace Ovcstr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcstrHPP
