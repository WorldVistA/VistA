// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovceditu.pas' rev: 29.00 (Windows)

#ifndef OvcedituHPP
#define OvcedituHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <ovcbase.hpp>
#include <Vcl.Controls.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovceditu
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcEditBase;
struct TMarker;
struct TOvcTextPos;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcEditBase : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
public:
	/* TOvcCustomControl.Create */ inline __fastcall virtual TOvcEditBase(System::Classes::TComponent* AOwner) : Ovcbase::TOvcCustomControlEx(AOwner) { }
	/* TOvcCustomControl.Destroy */ inline __fastcall virtual ~TOvcEditBase(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcEditBase(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


#pragma pack(push,1)
struct DECLSPEC_DRECORD TMarker
{
public:
	int Para;
	int Pos;
};
#pragma pack(pop)


typedef System::StaticArray<TMarker, 10> TMarkerArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcTextPos
{
public:
	int Line;
	int Col;
};
#pragma pack(pop)


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Word __fastcall edBreakPoint(System::WideChar * S, System::Word MaxLen);
extern DELPHI_PACKAGE void __fastcall edDeleteSubString(System::WideChar * S, int SLen, int Count, int Pos);
extern DELPHI_PACKAGE System::Word __fastcall edEffectiveLen(System::WideChar * S, System::Word Len, System::Byte TabSize);
extern DELPHI_PACKAGE System::WideChar * __fastcall edFindNextLine(System::WideChar * S, int WrapCol);
extern DELPHI_PACKAGE System::Word __fastcall edFindPosInMap(void * Map, System::Word Lines, System::Word Pos);
extern DELPHI_PACKAGE System::Word __fastcall edGetActualCol(System::WideChar * S, System::Word Col, System::Byte TabSize);
extern DELPHI_PACKAGE bool __fastcall edHaveTabs(System::WideChar * S, unsigned Len);
extern DELPHI_PACKAGE System::WideChar * __fastcall edPadPrim(System::WideChar * S, System::Word Len);
extern DELPHI_PACKAGE System::Word __fastcall edScanToEnd(System::WideChar * P, System::Word Len);
extern DELPHI_PACKAGE System::WideChar * __fastcall edStrStInsert(System::WideChar * Dest, System::WideChar * S, System::Word DLen, System::Word SLen, System::Word Pos);
extern DELPHI_PACKAGE bool __fastcall edWhiteSpace(System::WideChar C);
}	/* namespace Ovceditu */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDITU)
using namespace Ovceditu;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcedituHPP
