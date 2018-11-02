// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32intdeq.pas' rev: 29.00 (Windows)

#ifndef O32intdeqHPP
#define O32intdeqHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32intdeq
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32IntDeque;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32IntDeque : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TList* FList;
	int FHead;
	int FTail;
	void __fastcall idGrow(void);
	
public:
	__fastcall TO32IntDeque(int aCapacity);
	__fastcall virtual ~TO32IntDeque(void);
	bool __fastcall IsEmpty(void);
	void __fastcall Enqueue(int aValue);
	void __fastcall Push(int aValue);
	int __fastcall Pop(void);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32intdeq */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32INTDEQ)
using namespace O32intdeq;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32intdeqHPP
