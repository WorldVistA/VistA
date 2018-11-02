// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcRTF_IText.pas' rev: 29.00 (Windows)

#ifndef Ovcrtf_itextHPP
#define Ovcrtf_itextHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Win.StdVCL.hpp>
#include <Vcl.OleCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrtf_itext
{
//-- forward type declarations -----------------------------------------------
struct __MIDL_IWinTypes_0009;
struct _RemotableHandle;
__interface ITextDocument;
typedef System::DelphiInterface<ITextDocument> _di_ITextDocument;
__interface ITextRange;
typedef System::DelphiInterface<ITextRange> _di_ITextRange;
__interface ITextSelection;
typedef System::DelphiInterface<ITextSelection> _di_ITextSelection;
__interface ITextFont;
typedef System::DelphiInterface<ITextFont> _di_ITextFont;
__interface ITextPara;
typedef System::DelphiInterface<ITextPara> _di_ITextPara;
__interface ITextStoryRanges;
typedef System::DelphiInterface<ITextStoryRanges> _di_ITextStoryRanges;
__interface ITextDocument2;
typedef System::DelphiInterface<ITextDocument2> _di_ITextDocument2;
__interface ITextMsgFilter;
typedef System::DelphiInterface<ITextMsgFilter> _di_ITextMsgFilter;
//-- type declarations -------------------------------------------------------
typedef Winapi::Activex::TOleEnum __MIDL___MIDL_itf_tom_0000_0001;

typedef _RemotableHandle *wireHWND;

typedef System::OleVariant *POleVariant1;

typedef int *PInteger1;

typedef Winapi::Activex::TOleEnum tomConstants;

struct DECLSPEC_DRECORD __MIDL_IWinTypes_0009
{
	union
	{
		struct 
		{
			int hRemote;
		};
		struct 
		{
			int hInproc;
		};
		
	};
};


#pragma pack(push,1)
struct DECLSPEC_DRECORD _RemotableHandle
{
public:
	int fContext;
	__MIDL_IWinTypes_0009 u;
};
#pragma pack(pop)


__interface  INTERFACE_UUID("{8CC497C0-A1DF-11CE-8098-00AA0047BE5D}") ITextDocument  : public IDispatch 
{
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	virtual HRESULT __safecall Get_Selection(_di_ITextSelection &__Get_Selection_result) = 0 ;
	virtual HRESULT __safecall Get_StoryCount(int &__Get_StoryCount_result) = 0 ;
	virtual HRESULT __safecall Get_StoryRanges(_di_ITextStoryRanges &__Get_StoryRanges_result) = 0 ;
	virtual HRESULT __safecall Get_Saved(int &__Get_Saved_result) = 0 ;
	virtual HRESULT __safecall Set_Saved(int pValue) = 0 ;
	virtual HRESULT __safecall Get_DefaultTabStop(float &__Get_DefaultTabStop_result) = 0 ;
	virtual HRESULT __safecall Set_DefaultTabStop(float pValue) = 0 ;
	virtual HRESULT __safecall New(void) = 0 ;
	virtual HRESULT __safecall Open(System::OleVariant &pVar, int Flags, int CodePage) = 0 ;
	virtual HRESULT __safecall Save(System::OleVariant &pVar, int Flags, int CodePage) = 0 ;
	virtual HRESULT __safecall Freeze(int &__Freeze_result) = 0 ;
	virtual HRESULT __safecall Unfreeze(int &__Unfreeze_result) = 0 ;
	virtual HRESULT __safecall BeginEditCollection(void) = 0 ;
	virtual HRESULT __safecall EndEditCollection(void) = 0 ;
	virtual HRESULT __safecall Undo(int Count, int &__Undo_result) = 0 ;
	virtual HRESULT __safecall Redo(int Count, int &__Redo_result) = 0 ;
	virtual HRESULT __safecall Range(int cp1, int cp2, _di_ITextRange &__Range_result) = 0 ;
	virtual HRESULT __safecall RangeFromPoint(int x, int y, _di_ITextRange &__RangeFromPoint_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextSelection _scw_Get_Selection() { _di_ITextSelection __r; HRESULT __hr = Get_Selection(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextSelection Selection = {read=_scw_Get_Selection};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_StoryCount() { int __r; HRESULT __hr = Get_StoryCount(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int StoryCount = {read=_scw_Get_StoryCount};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextStoryRanges _scw_Get_StoryRanges() { _di_ITextStoryRanges __r; HRESULT __hr = Get_StoryRanges(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextStoryRanges StoryRanges = {read=_scw_Get_StoryRanges};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Saved() { int __r; HRESULT __hr = Get_Saved(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Saved = {read=_scw_Get_Saved, write=Set_Saved};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_DefaultTabStop() { float __r; HRESULT __hr = Get_DefaultTabStop(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float DefaultTabStop = {read=_scw_Get_DefaultTabStop, write=Set_DefaultTabStop};
};

__interface  INTERFACE_UUID("{8CC497C2-A1DF-11CE-8098-00AA0047BE5D}") ITextRange  : public IDispatch 
{
	virtual HRESULT __safecall Get_Text(System::WideString &__Get_Text_result) = 0 ;
	virtual HRESULT __safecall Set_Text(const System::WideString pbstr) = 0 ;
	virtual HRESULT __safecall Get_Char(int &__Get_Char_result) = 0 ;
	virtual HRESULT __safecall Set_Char(int pch) = 0 ;
	virtual HRESULT __safecall Get_Duplicate(_di_ITextRange &__Get_Duplicate_result) = 0 ;
	virtual HRESULT __safecall Get_FormattedText(_di_ITextRange &__Get_FormattedText_result) = 0 ;
	virtual HRESULT __safecall Set_FormattedText(const _di_ITextRange ppRange) = 0 ;
	virtual HRESULT __safecall Get_Start(int &__Get_Start_result) = 0 ;
	virtual HRESULT __safecall Set_Start(int pcpFirst) = 0 ;
	virtual HRESULT __safecall Get_End_(int &__Get_End__result) = 0 ;
	virtual HRESULT __safecall Set_End_(int pcpLim) = 0 ;
	virtual HRESULT __safecall Get_Font(_di_ITextFont &__Get_Font_result) = 0 ;
	virtual HRESULT __safecall Set_Font(const _di_ITextFont pFont) = 0 ;
	virtual HRESULT __safecall Get_Para(_di_ITextPara &__Get_Para_result) = 0 ;
	virtual HRESULT __safecall Set_Para(const _di_ITextPara pPara) = 0 ;
	virtual HRESULT __safecall Get_StoryLength(int &__Get_StoryLength_result) = 0 ;
	virtual HRESULT __safecall Get_StoryType(int &__Get_StoryType_result) = 0 ;
	virtual HRESULT __safecall Collapse(int bStart) = 0 ;
	virtual HRESULT __safecall Expand(int Unit_, int &__Expand_result) = 0 ;
	virtual HRESULT __safecall GetIndex(int Unit_, int &__GetIndex_result) = 0 ;
	virtual HRESULT __safecall SetIndex(int Unit_, int Index, int Extend) = 0 ;
	virtual HRESULT __safecall SetRange(int cpActive, int cpOther) = 0 ;
	virtual HRESULT __safecall InRange(const _di_ITextRange pRange, int &__InRange_result) = 0 ;
	virtual HRESULT __safecall InStory(const _di_ITextRange pRange, int &__InStory_result) = 0 ;
	virtual HRESULT __safecall IsEqual(const _di_ITextRange pRange, int &__IsEqual_result) = 0 ;
	virtual HRESULT __safecall Select(void) = 0 ;
	virtual HRESULT __safecall StartOf(int Unit_, int Extend, int &__StartOf_result) = 0 ;
	virtual HRESULT __safecall EndOf(int Unit_, int Extend, int &__EndOf_result) = 0 ;
	virtual HRESULT __safecall Move(int Unit_, int Count, int &__Move_result) = 0 ;
	virtual HRESULT __safecall MoveStart(int Unit_, int Count, int &__MoveStart_result) = 0 ;
	virtual HRESULT __safecall MoveEnd(int Unit_, int Count, int &__MoveEnd_result) = 0 ;
	virtual HRESULT __safecall MoveWhile(System::OleVariant &Cset, int Count, int &__MoveWhile_result) = 0 ;
	virtual HRESULT __safecall MoveStartWhile(System::OleVariant &Cset, int Count, int &__MoveStartWhile_result) = 0 ;
	virtual HRESULT __safecall MoveEndWhile(System::OleVariant &Cset, int Count, int &__MoveEndWhile_result) = 0 ;
	virtual HRESULT __safecall MoveUntil(System::OleVariant &Cset, int Count, int &__MoveUntil_result) = 0 ;
	virtual HRESULT __safecall MoveStartUntil(System::OleVariant &Cset, int Count, int &__MoveStartUntil_result) = 0 ;
	virtual HRESULT __safecall MoveEndUntil(System::OleVariant &Cset, int Count, int &__MoveEndUntil_result) = 0 ;
	virtual HRESULT __safecall FindText(const System::WideString bstr, int cch, int Flags, int &__FindText_result) = 0 ;
	virtual HRESULT __safecall FindTextStart(const System::WideString bstr, int cch, int Flags, int &__FindTextStart_result) = 0 ;
	virtual HRESULT __safecall FindTextEnd(const System::WideString bstr, int cch, int Flags, int &__FindTextEnd_result) = 0 ;
	virtual HRESULT __safecall Delete(int Unit_, int Count, int &__Delete_result) = 0 ;
	virtual HRESULT __safecall Cut(/* out */ System::OleVariant &pVar) = 0 ;
	virtual HRESULT __safecall Copy(/* out */ System::OleVariant &pVar) = 0 ;
	virtual HRESULT __safecall Paste(System::OleVariant &pVar, int Format) = 0 ;
	virtual HRESULT __safecall CanPaste(System::OleVariant &pVar, int Format, int &__CanPaste_result) = 0 ;
	virtual HRESULT __safecall CanEdit(int &__CanEdit_result) = 0 ;
	virtual HRESULT __safecall ChangeCase(int Type_) = 0 ;
	virtual HRESULT __safecall GetPoint(int Type_, /* out */ int &px, /* out */ int &py) = 0 ;
	virtual HRESULT __safecall SetPoint(int x, int y, int Type_, int Extend) = 0 ;
	virtual HRESULT __safecall ScrollIntoView(int Value) = 0 ;
	virtual HRESULT __safecall GetEmbeddedObject(System::_di_IInterface &__GetEmbeddedObject_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Text() { System::WideString __r; HRESULT __hr = Get_Text(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Text = {read=_scw_Get_Text, write=Set_Text};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Char() { int __r; HRESULT __hr = Get_Char(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Char = {read=_scw_Get_Char, write=Set_Char};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextRange _scw_Get_Duplicate() { _di_ITextRange __r; HRESULT __hr = Get_Duplicate(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextRange Duplicate = {read=_scw_Get_Duplicate};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextRange _scw_Get_FormattedText() { _di_ITextRange __r; HRESULT __hr = Get_FormattedText(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextRange FormattedText = {read=_scw_Get_FormattedText, write=Set_FormattedText};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Start() { int __r; HRESULT __hr = Get_Start(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Start = {read=_scw_Get_Start, write=Set_Start};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_End_() { int __r; HRESULT __hr = Get_End_(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int End_ = {read=_scw_Get_End_, write=Set_End_};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextFont _scw_Get_Font() { _di_ITextFont __r; HRESULT __hr = Get_Font(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextFont Font = {read=_scw_Get_Font, write=Set_Font};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextPara _scw_Get_Para() { _di_ITextPara __r; HRESULT __hr = Get_Para(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextPara Para = {read=_scw_Get_Para, write=Set_Para};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_StoryLength() { int __r; HRESULT __hr = Get_StoryLength(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int StoryLength = {read=_scw_Get_StoryLength};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_StoryType() { int __r; HRESULT __hr = Get_StoryType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int StoryType = {read=_scw_Get_StoryType};
};

__interface  INTERFACE_UUID("{8CC497C1-A1DF-11CE-8098-00AA0047BE5D}") ITextSelection  : public ITextRange 
{
	virtual HRESULT __safecall Get_Flags(int &__Get_Flags_result) = 0 ;
	virtual HRESULT __safecall Set_Flags(int pFlags) = 0 ;
	virtual HRESULT __safecall Get_type_(int &__Get_type__result) = 0 ;
	virtual HRESULT __safecall MoveLeft(int Unit_, int Count, int Extend, int &__MoveLeft_result) = 0 ;
	virtual HRESULT __safecall MoveRight(int Unit_, int Count, int Extend, int &__MoveRight_result) = 0 ;
	virtual HRESULT __safecall MoveUp(int Unit_, int Count, int Extend, int &__MoveUp_result) = 0 ;
	virtual HRESULT __safecall MoveDown(int Unit_, int Count, int Extend, int &__MoveDown_result) = 0 ;
	virtual HRESULT __safecall HomeKey(int Unit_, int Extend, int &__HomeKey_result) = 0 ;
	virtual HRESULT __safecall EndKey(int Unit_, int Extend, int &__EndKey_result) = 0 ;
	virtual HRESULT __safecall TypeText(const System::WideString bstr) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Flags() { int __r; HRESULT __hr = Get_Flags(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Flags = {read=_scw_Get_Flags, write=Set_Flags};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_type_() { int __r; HRESULT __hr = Get_type_(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int type_ = {read=_scw_Get_type_};
};

__interface  INTERFACE_UUID("{8CC497C3-A1DF-11CE-8098-00AA0047BE5D}") ITextFont  : public IDispatch 
{
	virtual HRESULT __safecall Get_Duplicate(_di_ITextFont &__Get_Duplicate_result) = 0 ;
	virtual HRESULT __safecall Set_Duplicate(const _di_ITextFont ppFont) = 0 ;
	virtual HRESULT __safecall CanChange(int &__CanChange_result) = 0 ;
	virtual HRESULT __safecall IsEqual(const _di_ITextFont pFont, int &__IsEqual_result) = 0 ;
	virtual HRESULT __safecall Reset(int Value) = 0 ;
	virtual HRESULT __safecall Get_Style(int &__Get_Style_result) = 0 ;
	virtual HRESULT __safecall Set_Style(int pValue) = 0 ;
	virtual HRESULT __safecall Get_AllCaps(int &__Get_AllCaps_result) = 0 ;
	virtual HRESULT __safecall Set_AllCaps(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Animation(int &__Get_Animation_result) = 0 ;
	virtual HRESULT __safecall Set_Animation(int pValue) = 0 ;
	virtual HRESULT __safecall Get_BackColor(int &__Get_BackColor_result) = 0 ;
	virtual HRESULT __safecall Set_BackColor(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Bold(int &__Get_Bold_result) = 0 ;
	virtual HRESULT __safecall Set_Bold(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Emboss(int &__Get_Emboss_result) = 0 ;
	virtual HRESULT __safecall Set_Emboss(int pValue) = 0 ;
	virtual HRESULT __safecall Get_ForeColor(int &__Get_ForeColor_result) = 0 ;
	virtual HRESULT __safecall Set_ForeColor(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Hidden(int &__Get_Hidden_result) = 0 ;
	virtual HRESULT __safecall Set_Hidden(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Engrave(int &__Get_Engrave_result) = 0 ;
	virtual HRESULT __safecall Set_Engrave(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Italic(int &__Get_Italic_result) = 0 ;
	virtual HRESULT __safecall Set_Italic(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Kerning(float &__Get_Kerning_result) = 0 ;
	virtual HRESULT __safecall Set_Kerning(float pValue) = 0 ;
	virtual HRESULT __safecall Get_LanguageID(int &__Get_LanguageID_result) = 0 ;
	virtual HRESULT __safecall Set_LanguageID(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	virtual HRESULT __safecall Set_Name(const System::WideString pbstr) = 0 ;
	virtual HRESULT __safecall Get_Outline(int &__Get_Outline_result) = 0 ;
	virtual HRESULT __safecall Set_Outline(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Position(float &__Get_Position_result) = 0 ;
	virtual HRESULT __safecall Set_Position(float pValue) = 0 ;
	virtual HRESULT __safecall Get_Protected_(int &__Get_Protected__result) = 0 ;
	virtual HRESULT __safecall Set_Protected_(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Shadow(int &__Get_Shadow_result) = 0 ;
	virtual HRESULT __safecall Set_Shadow(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Size(float &__Get_Size_result) = 0 ;
	virtual HRESULT __safecall Set_Size(float pValue) = 0 ;
	virtual HRESULT __safecall Get_SmallCaps(int &__Get_SmallCaps_result) = 0 ;
	virtual HRESULT __safecall Set_SmallCaps(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Spacing(float &__Get_Spacing_result) = 0 ;
	virtual HRESULT __safecall Set_Spacing(float pValue) = 0 ;
	virtual HRESULT __safecall Get_StrikeThrough(int &__Get_StrikeThrough_result) = 0 ;
	virtual HRESULT __safecall Set_StrikeThrough(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Subscript(int &__Get_Subscript_result) = 0 ;
	virtual HRESULT __safecall Set_Subscript(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Superscript(int &__Get_Superscript_result) = 0 ;
	virtual HRESULT __safecall Set_Superscript(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Underline(int &__Get_Underline_result) = 0 ;
	virtual HRESULT __safecall Set_Underline(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Weight(int &__Get_Weight_result) = 0 ;
	virtual HRESULT __safecall Set_Weight(int pValue) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextFont _scw_Get_Duplicate() { _di_ITextFont __r; HRESULT __hr = Get_Duplicate(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextFont Duplicate = {read=_scw_Get_Duplicate, write=Set_Duplicate};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Style() { int __r; HRESULT __hr = Get_Style(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Style = {read=_scw_Get_Style, write=Set_Style};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AllCaps() { int __r; HRESULT __hr = Get_AllCaps(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AllCaps = {read=_scw_Get_AllCaps, write=Set_AllCaps};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Animation() { int __r; HRESULT __hr = Get_Animation(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Animation = {read=_scw_Get_Animation, write=Set_Animation};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_BackColor() { int __r; HRESULT __hr = Get_BackColor(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int BackColor = {read=_scw_Get_BackColor, write=Set_BackColor};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Bold() { int __r; HRESULT __hr = Get_Bold(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Bold = {read=_scw_Get_Bold, write=Set_Bold};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Emboss() { int __r; HRESULT __hr = Get_Emboss(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Emboss = {read=_scw_Get_Emboss, write=Set_Emboss};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_ForeColor() { int __r; HRESULT __hr = Get_ForeColor(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int ForeColor = {read=_scw_Get_ForeColor, write=Set_ForeColor};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Hidden() { int __r; HRESULT __hr = Get_Hidden(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Hidden = {read=_scw_Get_Hidden, write=Set_Hidden};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Engrave() { int __r; HRESULT __hr = Get_Engrave(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Engrave = {read=_scw_Get_Engrave, write=Set_Engrave};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Italic() { int __r; HRESULT __hr = Get_Italic(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Italic = {read=_scw_Get_Italic, write=Set_Italic};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_Kerning() { float __r; HRESULT __hr = Get_Kerning(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float Kerning = {read=_scw_Get_Kerning, write=Set_Kerning};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LanguageID() { int __r; HRESULT __hr = Get_LanguageID(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LanguageID = {read=_scw_Get_LanguageID, write=Set_LanguageID};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name, write=Set_Name};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Outline() { int __r; HRESULT __hr = Get_Outline(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Outline = {read=_scw_Get_Outline, write=Set_Outline};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_Position() { float __r; HRESULT __hr = Get_Position(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float Position = {read=_scw_Get_Position, write=Set_Position};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Protected_() { int __r; HRESULT __hr = Get_Protected_(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Protected_ = {read=_scw_Get_Protected_, write=Set_Protected_};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Shadow() { int __r; HRESULT __hr = Get_Shadow(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Shadow = {read=_scw_Get_Shadow, write=Set_Shadow};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_Size() { float __r; HRESULT __hr = Get_Size(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float Size = {read=_scw_Get_Size, write=Set_Size};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_SmallCaps() { int __r; HRESULT __hr = Get_SmallCaps(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int SmallCaps = {read=_scw_Get_SmallCaps, write=Set_SmallCaps};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_Spacing() { float __r; HRESULT __hr = Get_Spacing(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float Spacing = {read=_scw_Get_Spacing, write=Set_Spacing};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_StrikeThrough() { int __r; HRESULT __hr = Get_StrikeThrough(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int StrikeThrough = {read=_scw_Get_StrikeThrough, write=Set_StrikeThrough};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Subscript() { int __r; HRESULT __hr = Get_Subscript(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Subscript = {read=_scw_Get_Subscript, write=Set_Subscript};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Superscript() { int __r; HRESULT __hr = Get_Superscript(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Superscript = {read=_scw_Get_Superscript, write=Set_Superscript};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Underline() { int __r; HRESULT __hr = Get_Underline(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Underline = {read=_scw_Get_Underline, write=Set_Underline};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Weight() { int __r; HRESULT __hr = Get_Weight(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Weight = {read=_scw_Get_Weight, write=Set_Weight};
};

__interface  INTERFACE_UUID("{8CC497C4-A1DF-11CE-8098-00AA0047BE5D}") ITextPara  : public IDispatch 
{
	virtual HRESULT __safecall Get_Duplicate(_di_ITextPara &__Get_Duplicate_result) = 0 ;
	virtual HRESULT __safecall Set_Duplicate(const _di_ITextPara ppPara) = 0 ;
	virtual HRESULT __safecall CanChange(int &__CanChange_result) = 0 ;
	virtual HRESULT __safecall IsEqual(const _di_ITextPara pPara, int &__IsEqual_result) = 0 ;
	virtual HRESULT __safecall Reset(int Value) = 0 ;
	virtual HRESULT __safecall Get_Style(int &__Get_Style_result) = 0 ;
	virtual HRESULT __safecall Set_Style(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Alignment(int &__Get_Alignment_result) = 0 ;
	virtual HRESULT __safecall Set_Alignment(int pValue) = 0 ;
	virtual HRESULT __safecall Get_Hyphenation(int &__Get_Hyphenation_result) = 0 ;
	virtual HRESULT __safecall Set_Hyphenation(int pValue) = 0 ;
	virtual HRESULT __safecall Get_FirstLineIndent(float &__Get_FirstLineIndent_result) = 0 ;
	virtual HRESULT __safecall Get_KeepTogether(int &__Get_KeepTogether_result) = 0 ;
	virtual HRESULT __safecall Set_KeepTogether(int pValue) = 0 ;
	virtual HRESULT __safecall Get_KeepWithNext(int &__Get_KeepWithNext_result) = 0 ;
	virtual HRESULT __safecall Set_KeepWithNext(int pValue) = 0 ;
	virtual HRESULT __safecall Get_LeftIndent(float &__Get_LeftIndent_result) = 0 ;
	virtual HRESULT __safecall Get_LineSpacing(float &__Get_LineSpacing_result) = 0 ;
	virtual HRESULT __safecall Get_LineSpacingRule(int &__Get_LineSpacingRule_result) = 0 ;
	virtual HRESULT __safecall Get_ListAlignment(int &__Get_ListAlignment_result) = 0 ;
	virtual HRESULT __safecall Set_ListAlignment(int pValue) = 0 ;
	virtual HRESULT __safecall Get_ListLevelIndex(int &__Get_ListLevelIndex_result) = 0 ;
	virtual HRESULT __safecall Set_ListLevelIndex(int pValue) = 0 ;
	virtual HRESULT __safecall Get_ListStart(int &__Get_ListStart_result) = 0 ;
	virtual HRESULT __safecall Set_ListStart(int pValue) = 0 ;
	virtual HRESULT __safecall Get_ListTab(float &__Get_ListTab_result) = 0 ;
	virtual HRESULT __safecall Set_ListTab(float pValue) = 0 ;
	virtual HRESULT __safecall Get_ListType(int &__Get_ListType_result) = 0 ;
	virtual HRESULT __safecall Set_ListType(int pValue) = 0 ;
	virtual HRESULT __safecall Get_NoLineNumber(int &__Get_NoLineNumber_result) = 0 ;
	virtual HRESULT __safecall Set_NoLineNumber(int pValue) = 0 ;
	virtual HRESULT __safecall Get_PageBreakBefore(int &__Get_PageBreakBefore_result) = 0 ;
	virtual HRESULT __safecall Set_PageBreakBefore(int pValue) = 0 ;
	virtual HRESULT __safecall Get_RightIndent(float &__Get_RightIndent_result) = 0 ;
	virtual HRESULT __safecall Set_RightIndent(float pValue) = 0 ;
	virtual HRESULT __safecall SetIndents(float StartIndent, float LeftIndent, float RightIndent) = 0 ;
	virtual HRESULT __safecall SetLineSpacing(int LineSpacingRule, float LineSpacing) = 0 ;
	virtual HRESULT __safecall Get_SpaceAfter(float &__Get_SpaceAfter_result) = 0 ;
	virtual HRESULT __safecall Set_SpaceAfter(float pValue) = 0 ;
	virtual HRESULT __safecall Get_SpaceBefore(float &__Get_SpaceBefore_result) = 0 ;
	virtual HRESULT __safecall Set_SpaceBefore(float pValue) = 0 ;
	virtual HRESULT __safecall Get_WidowControl(int &__Get_WidowControl_result) = 0 ;
	virtual HRESULT __safecall Set_WidowControl(int pValue) = 0 ;
	virtual HRESULT __safecall Get_TabCount(int &__Get_TabCount_result) = 0 ;
	virtual HRESULT __safecall AddTab(float tbPos, int tbAlign, int tbLeader) = 0 ;
	virtual HRESULT __safecall ClearAllTabs(void) = 0 ;
	virtual HRESULT __safecall DeleteTab(float tbPos) = 0 ;
	virtual HRESULT __safecall GetTab(int iTab, /* out */ float &ptbPos, /* out */ int &ptbAlign, /* out */ int &ptbLeader) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextPara _scw_Get_Duplicate() { _di_ITextPara __r; HRESULT __hr = Get_Duplicate(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextPara Duplicate = {read=_scw_Get_Duplicate, write=Set_Duplicate};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Style() { int __r; HRESULT __hr = Get_Style(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Style = {read=_scw_Get_Style, write=Set_Style};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Alignment() { int __r; HRESULT __hr = Get_Alignment(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Alignment = {read=_scw_Get_Alignment, write=Set_Alignment};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Hyphenation() { int __r; HRESULT __hr = Get_Hyphenation(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Hyphenation = {read=_scw_Get_Hyphenation, write=Set_Hyphenation};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_FirstLineIndent() { float __r; HRESULT __hr = Get_FirstLineIndent(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float FirstLineIndent = {read=_scw_Get_FirstLineIndent};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_KeepTogether() { int __r; HRESULT __hr = Get_KeepTogether(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int KeepTogether = {read=_scw_Get_KeepTogether, write=Set_KeepTogether};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_KeepWithNext() { int __r; HRESULT __hr = Get_KeepWithNext(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int KeepWithNext = {read=_scw_Get_KeepWithNext, write=Set_KeepWithNext};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_LeftIndent() { float __r; HRESULT __hr = Get_LeftIndent(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float LeftIndent = {read=_scw_Get_LeftIndent};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_LineSpacing() { float __r; HRESULT __hr = Get_LineSpacing(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float LineSpacing = {read=_scw_Get_LineSpacing};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LineSpacingRule() { int __r; HRESULT __hr = Get_LineSpacingRule(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LineSpacingRule = {read=_scw_Get_LineSpacingRule};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_ListAlignment() { int __r; HRESULT __hr = Get_ListAlignment(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int ListAlignment = {read=_scw_Get_ListAlignment, write=Set_ListAlignment};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_ListLevelIndex() { int __r; HRESULT __hr = Get_ListLevelIndex(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int ListLevelIndex = {read=_scw_Get_ListLevelIndex, write=Set_ListLevelIndex};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_ListStart() { int __r; HRESULT __hr = Get_ListStart(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int ListStart = {read=_scw_Get_ListStart, write=Set_ListStart};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_ListTab() { float __r; HRESULT __hr = Get_ListTab(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float ListTab = {read=_scw_Get_ListTab, write=Set_ListTab};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_ListType() { int __r; HRESULT __hr = Get_ListType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int ListType = {read=_scw_Get_ListType, write=Set_ListType};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NoLineNumber() { int __r; HRESULT __hr = Get_NoLineNumber(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NoLineNumber = {read=_scw_Get_NoLineNumber, write=Set_NoLineNumber};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_PageBreakBefore() { int __r; HRESULT __hr = Get_PageBreakBefore(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int PageBreakBefore = {read=_scw_Get_PageBreakBefore, write=Set_PageBreakBefore};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_RightIndent() { float __r; HRESULT __hr = Get_RightIndent(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float RightIndent = {read=_scw_Get_RightIndent, write=Set_RightIndent};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_SpaceAfter() { float __r; HRESULT __hr = Get_SpaceAfter(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float SpaceAfter = {read=_scw_Get_SpaceAfter, write=Set_SpaceAfter};
	#pragma option push -w-inl
	/* safecall wrapper */ inline float _scw_Get_SpaceBefore() { float __r; HRESULT __hr = Get_SpaceBefore(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property float SpaceBefore = {read=_scw_Get_SpaceBefore, write=Set_SpaceBefore};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_WidowControl() { int __r; HRESULT __hr = Get_WidowControl(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int WidowControl = {read=_scw_Get_WidowControl, write=Set_WidowControl};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TabCount() { int __r; HRESULT __hr = Get_TabCount(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TabCount = {read=_scw_Get_TabCount};
};

__interface  INTERFACE_UUID("{8CC497C5-A1DF-11CE-8098-00AA0047BE5D}") ITextStoryRanges  : public IDispatch 
{
	virtual HRESULT __safecall _NewEnum(System::_di_IInterface &___NewEnum_result) = 0 ;
	virtual HRESULT __safecall Item(int Index, _di_ITextRange &__Item_result) = 0 ;
	virtual HRESULT __safecall Get_Count(int &__Get_Count_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Count() { int __r; HRESULT __hr = Get_Count(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Count = {read=_scw_Get_Count};
};

__interface  INTERFACE_UUID("{01C25500-4268-11D1-883A-3C8B00C10000}") ITextDocument2  : public ITextDocument 
{
	virtual HRESULT __safecall AttachMsgFilter(const System::_di_IInterface pFilter) = 0 ;
	virtual HRESULT __safecall SetEffectColor(int Index, unsigned cr) = 0 ;
	virtual HRESULT __safecall GetEffectColor(int Index, /* out */ unsigned &pcr) = 0 ;
	virtual HRESULT __safecall Get_CaretType(int &__Get_CaretType_result) = 0 ;
	virtual HRESULT __safecall Set_CaretType(int pCaretType) = 0 ;
	virtual HRESULT __safecall GetImmContext(int &__GetImmContext_result) = 0 ;
	virtual HRESULT __safecall ReleaseImmContext(int Context) = 0 ;
	virtual HRESULT __safecall GetPreferredFont(int cp, int CodePage, int Option, int curCodepage, int curFontSize, /* out */ System::WideString &pbstr, /* out */ int &pPitchAndFamily, /* out */ int &pNewFontSize) = 0 ;
	virtual HRESULT __safecall Get_NotificationMode(int &__Get_NotificationMode_result) = 0 ;
	virtual HRESULT __safecall Set_NotificationMode(int pMode) = 0 ;
	virtual HRESULT __safecall GetClientRect(int Type_, /* out */ int &pLeft, /* out */ int &pTop, /* out */ int &pRight, /* out */ int &pBottom) = 0 ;
	virtual HRESULT __safecall Get_SelectionEx(_di_ITextSelection &__Get_SelectionEx_result) = 0 ;
	virtual HRESULT __safecall GetWindow(/* out */ int &phWnd) = 0 ;
	virtual HRESULT __safecall GetFEFlags(/* out */ int &pFlags) = 0 ;
	virtual HRESULT __safecall UpdateWindow(void) = 0 ;
	virtual HRESULT __safecall CheckTextLimit(int cch, int &pcch) = 0 ;
	virtual HRESULT __safecall IMEInProgress(int Mode) = 0 ;
	virtual HRESULT __safecall SysBeep(void) = 0 ;
	virtual HRESULT __safecall Update(int Mode) = 0 ;
	virtual HRESULT __safecall Notify(int Notify) = 0 ;
	virtual HRESULT __safecall GetDocumentFont(_di_ITextFont &__GetDocumentFont_result) = 0 ;
	virtual HRESULT __safecall GetDocumentPara(_di_ITextPara &__GetDocumentPara_result) = 0 ;
	virtual HRESULT __safecall GetCallManager(System::_di_IInterface &__GetCallManager_result) = 0 ;
	virtual HRESULT __safecall ReleaseCallManager(const System::_di_IInterface pVoid) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CaretType() { int __r; HRESULT __hr = Get_CaretType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CaretType = {read=_scw_Get_CaretType, write=Set_CaretType};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NotificationMode() { int __r; HRESULT __hr = Get_NotificationMode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NotificationMode = {read=_scw_Get_NotificationMode, write=Set_NotificationMode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITextSelection _scw_Get_SelectionEx() { _di_ITextSelection __r; HRESULT __hr = Get_SelectionEx(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITextSelection SelectionEx = {read=_scw_Get_SelectionEx};
};

__interface  INTERFACE_UUID("{A3787420-4267-11D1-883A-3C8B00C10000}") ITextMsgFilter  : public System::IInterface 
{
	virtual HRESULT __stdcall AttachDocument(_RemotableHandle &hwnd, const _di_ITextDocument2 pTextDoc, const System::_di_IInterface punk) = 0 ;
	virtual HRESULT __stdcall HandleMessage(unsigned &pmsg, unsigned &pwparam, int &plparam, /* out */ int &plres) = 0 ;
	virtual HRESULT __stdcall AttachMsgFilter(const _di_ITextMsgFilter pMsgFilter) = 0 ;
};

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 tomMajorVersion = System::Int8(0x1);
static const System::Int8 tomMinorVersion = System::Int8(0x0);
extern DELPHI_PACKAGE GUID LIBID_tom;
extern DELPHI_PACKAGE GUID IID_ITextDocument;
extern DELPHI_PACKAGE GUID IID_ITextRange;
extern DELPHI_PACKAGE GUID IID_ITextSelection;
extern DELPHI_PACKAGE GUID IID_ITextFont;
extern DELPHI_PACKAGE GUID IID_ITextPara;
extern DELPHI_PACKAGE GUID IID_ITextStoryRanges;
extern DELPHI_PACKAGE GUID IID_ITextDocument2;
extern DELPHI_PACKAGE GUID IID_ITextMsgFilter;
static const System::Int8 tomFalse = System::Int8(0x0);
static const unsigned tomTrue = unsigned(0xffffffff);
static const unsigned tomUndefined = unsigned(0xff676981);
static const unsigned tomToggle = unsigned(0xff676982);
static const unsigned tomAutoColor = unsigned(0xff676983);
static const unsigned tomDefault = unsigned(0xff676984);
static const unsigned tomSuspend = unsigned(0xff676985);
static const unsigned tomResume = unsigned(0xff676986);
static const System::Int8 tomApplyNow = System::Int8(0x0);
static const System::Int8 tomApplyLater = System::Int8(0x1);
static const System::Int8 tomTrackParms = System::Int8(0x2);
static const System::Int8 tomCacheParms = System::Int8(0x3);
static const System::Int8 tomApplyTmp = System::Int8(0x4);
static const unsigned tomBackward = unsigned(0xc0000001);
static const int tomForward = int(0x3fffffff);
static const System::Int8 tomMove = System::Int8(0x0);
static const System::Int8 tomExtend = System::Int8(0x1);
static const System::Int8 tomNoSelection = System::Int8(0x0);
static const System::Int8 tomSelectionIP = System::Int8(0x1);
static const System::Int8 tomSelectionNormal = System::Int8(0x2);
static const System::Int8 tomSelectionFrame = System::Int8(0x3);
static const System::Int8 tomSelectionColumn = System::Int8(0x4);
static const System::Int8 tomSelectionRow = System::Int8(0x5);
static const System::Int8 tomSelectionBlock = System::Int8(0x6);
static const System::Int8 tomSelectionInlineShape = System::Int8(0x7);
static const System::Int8 tomSelectionShape = System::Int8(0x8);
static const System::Int8 tomSelStartActive = System::Int8(0x1);
static const System::Int8 tomSelAtEOL = System::Int8(0x2);
static const System::Int8 tomSelOvertype = System::Int8(0x4);
static const System::Int8 tomSelActive = System::Int8(0x8);
static const System::Int8 tomSelReplace = System::Int8(0x10);
static const System::Int8 tomEnd = System::Int8(0x0);
static const System::Int8 tomStart = System::Int8(0x20);
static const System::Int8 tomCollapseEnd = System::Int8(0x0);
static const System::Int8 tomCollapseStart = System::Int8(0x1);
static const System::Word tomClientCoord = System::Word(0x100);
static const System::Word tomAllowOffClient = System::Word(0x200);
static const System::Int8 tomNone = System::Int8(0x0);
static const System::Int8 tomSingle = System::Int8(0x1);
static const System::Int8 tomWords = System::Int8(0x2);
static const System::Int8 tomDouble = System::Int8(0x3);
static const System::Int8 tomDotted = System::Int8(0x4);
static const System::Int8 tomDash = System::Int8(0x5);
static const System::Int8 tomDashDot = System::Int8(0x6);
static const System::Int8 tomDashDotDot = System::Int8(0x7);
static const System::Int8 tomWave = System::Int8(0x8);
static const System::Int8 tomThick = System::Int8(0x9);
static const System::Int8 tomHair = System::Int8(0xa);
static const System::Int8 tomDoubleWave = System::Int8(0xb);
static const System::Int8 tomHeavyWave = System::Int8(0xc);
static const System::Int8 tomLongDash = System::Int8(0xd);
static const System::Int8 tomThickDash = System::Int8(0xe);
static const System::Int8 tomThickDashDot = System::Int8(0xf);
static const System::Int8 tomThickDashDotDot = System::Int8(0x10);
static const System::Int8 tomThickDotted = System::Int8(0x11);
static const System::Int8 tomThickLongDash = System::Int8(0x12);
static const System::Int8 tomLineSpaceSingle = System::Int8(0x0);
static const System::Int8 tomLineSpace1pt5 = System::Int8(0x1);
static const System::Int8 tomLineSpaceDouble = System::Int8(0x2);
static const System::Int8 tomLineSpaceAtLeast = System::Int8(0x3);
static const System::Int8 tomLineSpaceExactly = System::Int8(0x4);
static const System::Int8 tomLineSpaceMultiple = System::Int8(0x5);
static const System::Int8 tomAlignLeft = System::Int8(0x0);
static const System::Int8 tomAlignCenter = System::Int8(0x1);
static const System::Int8 tomAlignRight = System::Int8(0x2);
static const System::Int8 tomAlignJustify = System::Int8(0x3);
static const System::Int8 tomAlignDecimal = System::Int8(0x3);
static const System::Int8 tomAlignBar = System::Int8(0x4);
static const System::Int8 tomAlignInterWord = System::Int8(0x3);
static const System::Int8 tomAlignInterLetter = System::Int8(0x4);
static const System::Int8 tomAlignScaled = System::Int8(0x5);
static const System::Int8 tomAlignGlyphs = System::Int8(0x6);
static const System::Int8 tomAlignSnapGrid = System::Int8(0x7);
static const System::Int8 tomSpaces = System::Int8(0x0);
static const System::Int8 tomDots = System::Int8(0x1);
static const System::Int8 tomDashes = System::Int8(0x2);
static const System::Int8 tomLines = System::Int8(0x3);
static const System::Int8 tomThickLines = System::Int8(0x4);
static const System::Int8 tomEquals = System::Int8(0x5);
static const unsigned tomTabBack = unsigned(0xfffffffd);
static const unsigned tomTabNext = unsigned(0xfffffffe);
static const unsigned tomTabHere = unsigned(0xffffffff);
static const System::Int8 tomListNone = System::Int8(0x0);
static const System::Int8 tomListBullet = System::Int8(0x1);
static const System::Int8 tomListNumberAsArabic = System::Int8(0x2);
static const System::Int8 tomListNumberAsLCLetter = System::Int8(0x3);
static const System::Int8 tomListNumberAsUCLetter = System::Int8(0x4);
static const System::Int8 tomListNumberAsLCRoman = System::Int8(0x5);
static const System::Int8 tomListNumberAsUCRoman = System::Int8(0x6);
static const System::Int8 tomListNumberAsSequence = System::Int8(0x7);
static const int tomListParentheses = int(0x10000);
static const int tomListPeriod = int(0x20000);
static const int tomListPlain = int(0x30000);
static const System::Int8 tomCharacter = System::Int8(0x1);
static const System::Int8 tomWord = System::Int8(0x2);
static const System::Int8 tomSentence = System::Int8(0x3);
static const System::Int8 tomParagraph = System::Int8(0x4);
static const System::Int8 tomLine = System::Int8(0x5);
static const System::Int8 tomStory = System::Int8(0x6);
static const System::Int8 tomScreen = System::Int8(0x7);
static const System::Int8 tomSection = System::Int8(0x8);
static const System::Int8 tomColumn = System::Int8(0x9);
static const System::Int8 tomRow = System::Int8(0xa);
static const System::Int8 tomWindow = System::Int8(0xb);
static const System::Int8 tomCell = System::Int8(0xc);
static const System::Int8 tomCharFormat = System::Int8(0xd);
static const System::Int8 tomParaFormat = System::Int8(0xe);
static const System::Int8 tomTable = System::Int8(0xf);
static const System::Int8 tomObject = System::Int8(0x10);
static const System::Int8 tomPage = System::Int8(0x11);
static const System::Int8 tomMatchWord = System::Int8(0x2);
static const System::Int8 tomMatchCase = System::Int8(0x4);
static const System::Int8 tomMatchPattern = System::Int8(0x8);
static const System::Int8 tomUnknownStory = System::Int8(0x0);
static const System::Int8 tomMainTextStory = System::Int8(0x1);
static const System::Int8 tomFootnotesStory = System::Int8(0x2);
static const System::Int8 tomEndnotesStory = System::Int8(0x3);
static const System::Int8 tomCommentsStory = System::Int8(0x4);
static const System::Int8 tomTextFrameStory = System::Int8(0x5);
static const System::Int8 tomEvenPagesHeaderStory = System::Int8(0x6);
static const System::Int8 tomPrimaryHeaderStory = System::Int8(0x7);
static const System::Int8 tomEvenPagesFooterStory = System::Int8(0x8);
static const System::Int8 tomPrimaryFooterStory = System::Int8(0x9);
static const System::Int8 tomFirstPageHeaderStory = System::Int8(0xa);
static const System::Int8 tomFirstPageFooterStory = System::Int8(0xb);
static const System::Int8 tomNoAnimation = System::Int8(0x0);
static const System::Int8 tomLasVegasLights = System::Int8(0x1);
static const System::Int8 tomBlinkingBackground = System::Int8(0x2);
static const System::Int8 tomSparkleText = System::Int8(0x3);
static const System::Int8 tomMarchingBlackAnts = System::Int8(0x4);
static const System::Int8 tomMarchingRedAnts = System::Int8(0x5);
static const System::Int8 tomShimmer = System::Int8(0x6);
static const System::Int8 tomWipeDown = System::Int8(0x7);
static const System::Int8 tomWipeRight = System::Int8(0x8);
static const System::Int8 tomAnimationMax = System::Int8(0x8);
static const System::Int8 tomLowerCase = System::Int8(0x0);
static const System::Int8 tomUpperCase = System::Int8(0x1);
static const System::Int8 tomTitleCase = System::Int8(0x2);
static const System::Int8 tomSentenceCase = System::Int8(0x4);
static const System::Int8 tomToggleCase = System::Int8(0x5);
static const System::Word tomReadOnly = System::Word(0x100);
static const System::Word tomShareDenyRead = System::Word(0x200);
static const System::Word tomShareDenyWrite = System::Word(0x400);
static const System::Word tomPasteFile = System::Word(0x1000);
static const System::Int8 tomCreateNew = System::Int8(0x10);
static const System::Int8 tomCreateAlways = System::Int8(0x20);
static const System::Int8 tomOpenExisting = System::Int8(0x30);
static const System::Int8 tomOpenAlways = System::Int8(0x40);
static const System::Int8 tomTruncateExisting = System::Int8(0x50);
static const System::Int8 tomRTF = System::Int8(0x1);
static const System::Int8 tomText = System::Int8(0x2);
static const System::Int8 tomHTML = System::Int8(0x3);
static const System::Int8 tomWordDocument = System::Int8(0x4);
static const unsigned tomBold = unsigned(0x80000001);
static const unsigned tomItalic = unsigned(0x80000002);
static const unsigned tomUnderline = unsigned(0x80000004);
static const unsigned tomStrikeout = unsigned(0x80000008);
static const unsigned tomProtected = unsigned(0x80000010);
static const unsigned tomLink = unsigned(0x80000020);
static const unsigned tomSmallCaps = unsigned(0x80000040);
static const unsigned tomAllCaps = unsigned(0x80000080);
static const unsigned tomHidden = unsigned(0x80000100);
static const unsigned tomOutline = unsigned(0x80000200);
static const unsigned tomShadow = unsigned(0x80000400);
static const unsigned tomEmboss = unsigned(0x80000800);
static const unsigned tomImprint = unsigned(0x80001000);
static const unsigned tomDisabled = unsigned(0x80002000);
static const unsigned tomRevised = unsigned(0x80004000);
static const System::Int8 tomNormalCaret = System::Int8(0x0);
static const System::Int8 tomKoreanBlockCaret = System::Int8(0x1);
static const System::Int8 tomIncludeInset = System::Int8(0x1);
static const System::Int8 tomIgnoreCurrentFont = System::Int8(0x0);
static const System::Int8 tomMatchFontCharset = System::Int8(0x1);
static const System::Int8 tomMatchFontSignature = System::Int8(0x2);
static const unsigned tomCharset = unsigned(0x80000000);
static const System::Int8 tomRE10Mode = System::Int8(0x1);
static const System::Int8 tomUseAtFont = System::Int8(0x2);
static const System::Int8 tomTextFlowMask = System::Int8(0xc);
static const System::Int8 tomTextFlowES = System::Int8(0x0);
static const System::Int8 tomTextFlowSW = System::Int8(0x4);
static const System::Int8 tomTextFlowWN = System::Int8(0x8);
static const System::Int8 tomTextFlowNE = System::Int8(0xc);
static const System::Int8 tomUsePassword = System::Int8(0x10);
static const int tomNoIME = int(0x80000);
static const int tomSelfIME = int(0x40000);
}	/* namespace Ovcrtf_itext */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRTF_ITEXT)
using namespace Ovcrtf_itext;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovcrtf_itextHPP
