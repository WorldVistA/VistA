// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcoutln.pas' rev: 29.00 (Windows)

#ifndef OvcoutlnHPP
#define OvcoutlnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <ovcvlb.hpp>
#include <ovcdlm.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Vcl.Menus.hpp>
#include <ovccolor.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcoutln
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcOutlineNode;
class DELPHICLASS TOvcOutlineNodeList;
class DELPHICLASS TOvcOutlineNodes;
class DELPHICLASS TOvcCustomOutline;
class DELPHICLASS TOvcOutline;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcOlNodeStyle : unsigned char { osPlain, osRadio, osCheck };

enum DECLSPEC_DENUM TOvcOlNodeMode : unsigned char { omPreload, omDynamicLoad, omDynamic };

typedef void __fastcall (__closure *TOvcOlActiveChangeEvent)(TOvcCustomOutline* Sender, TOvcOutlineNode* OldNode, TOvcOutlineNode* NewNode);

typedef void __fastcall (__closure *TOvcOlCompareNodesEvent)(TOvcCustomOutline* Sender, int Key, TOvcOutlineNode* Node1, TOvcOutlineNode* Node2, int &Result);

typedef void __fastcall (__closure *TOvcOlDrawTextEvent)(TOvcCustomOutline* Sender, Vcl::Graphics::TCanvas* Canvas, TOvcOutlineNode* Node, const System::UnicodeString Text, const System::Types::TRect &Rect, bool &DefaultDrawing);

typedef void __fastcall (__closure *TOvcOlDrawCheckEvent)(TOvcCustomOutline* Sender, Vcl::Graphics::TCanvas* Canvas, TOvcOutlineNode* Node, const System::Types::TRect &Rect, TOvcOlNodeStyle Style, bool Checked, bool &DefaultDrawing);

typedef void __fastcall (__closure *TOvcOlNodeEvent)(TOvcCustomOutline* Sender, TOvcOutlineNode* Node);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcOutlineNode : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	TOvcOutlineNode* operator[](int Index) { return Node[Index]; }
	
protected:
	int FAddIndex;
	System::Types::TRect FButtonRect;
	bool FExpanded;
	void *FData;
	TOvcCustomOutline* FOutline;
	TOvcOutlineNodes* FFChildren;
	bool FChecked;
	int FImageIndex;
	TOvcOlNodeMode FMode;
	TOvcOutlineNodes* FOwner;
	TOvcOutlineNode* FParent;
	System::Types::TRect FRadioRect;
	TOvcOlNodeStyle FStyle;
	System::UnicodeString FText;
	System::Types::TRect FTextRect;
	bool FTruncated;
	bool ExpandEventCalled;
	int Seq;
	int __fastcall GetCount(void);
	bool __fastcall GetHasChildren(void);
	bool __fastcall GetHasParent(void);
	TOvcOutlineNode* __fastcall GetNode(int Index);
	int __fastcall GetLevel(void);
	int __fastcall GetLineCount(void);
	bool __fastcall GetVisible(void);
	void __fastcall MakeChildrenVisible(void);
	void __fastcall SetChecked(bool Value);
	void __fastcall SetData(const void * Value);
	void __fastcall SetExpanded(const bool Value);
	void __fastcall SetImageIndex(const int Value);
	void __fastcall SetParent(TOvcOutlineNode* Value);
	void __fastcall SetStyle(TOvcOlNodeStyle Value);
	void __fastcall SetText(const System::UnicodeString Value);
	void __fastcall SetVisible(const bool Value);
	__property System::Types::TRect TextRect = {read=FTextRect, write=FTextRect};
	__property bool Truncated = {read=FTruncated, write=FTruncated, nodefault};
	__property System::Types::TRect ButtonRect = {read=FButtonRect, write=FButtonRect};
	__property System::Types::TRect RadioRect = {read=FRadioRect, write=FRadioRect};
	__property int LineCount = {read=GetLineCount, nodefault};
	TOvcOutlineNodes* __fastcall GetChildren(void);
	void __fastcall PushChildIndex(void);
	void __fastcall PopChildIndex(void);
	TOvcOutlineNode* __fastcall FirstChild(void);
	TOvcOutlineNode* __fastcall NextChild(void);
	TOvcOutlineNode* __fastcall LastChild(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall TOvcOutlineNode(TOvcCustomOutline* AOutline, TOvcOutlineNodes* AOwner, TOvcOutlineNode* AParent, const void * Data);
	__fastcall virtual ~TOvcOutlineNode(void);
	int __fastcall Index(void);
	bool __fastcall IsFirstSibling(void);
	bool __fastcall IsLastSibling(void);
	bool __fastcall IsSibling(TOvcOutlineNode* Value);
	__property TOvcOutlineNodes* Owner = {read=FOwner};
	__property int AddIndex = {read=FAddIndex, nodefault};
	__property bool Checked = {read=FChecked, write=SetChecked, nodefault};
	void __fastcall Collapse(bool Recurse);
	__property int Count = {read=GetCount, nodefault};
	__property void * Data = {read=FData, write=SetData};
	void __fastcall DeleteChildren(void);
	void __fastcall Expand(bool Recurse);
	__property bool Expanded = {read=FExpanded, write=SetExpanded, nodefault};
	__property bool HasChildren = {read=GetHasChildren, nodefault};
	__property bool HasParent = {read=GetHasParent, nodefault};
	__property int ImageIndex = {read=FImageIndex, write=SetImageIndex, default=-1};
	void __fastcall Invalidate(void);
	__property TOvcOutlineNode* Node[int Index] = {read=GetNode/*, default*/};
	__property int Level = {read=GetLevel, nodefault};
	__property TOvcOlNodeMode Mode = {read=FMode, write=FMode, default=0};
	__property TOvcCustomOutline* Outline = {read=FOutline};
	__property TOvcOutlineNode* Parent = {read=FParent, write=SetParent};
	__property TOvcOlNodeStyle Style = {read=FStyle, write=SetStyle, nodefault};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property bool Visible = {read=GetVisible, write=SetVisible, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcOutlineNodeList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	Ovcdlm::TOvcSortedList* List;
	TOvcOutlineNode* __fastcall GetNode(int Index);
	int __fastcall GetCurrentKey(void);
	void __fastcall SetCurrentKey(const int Value);
	
public:
	__fastcall TOvcOutlineNodeList(int NumKeys, Ovcdlm::TOvcMultiCompareFunc CompareFunc);
	__fastcall virtual ~TOvcOutlineNodeList(void);
	bool __fastcall First(TOvcOutlineNode* &Node);
	bool __fastcall Next(TOvcOutlineNode* &Node);
	bool __fastcall Last(TOvcOutlineNode* &Node);
	int __fastcall Count(void);
	void __fastcall Add(TOvcOutlineNode* NewNode);
	void __fastcall Delete(TOvcOutlineNode* Node);
	bool __fastcall Empty(void);
	TOvcOutlineNode* __fastcall FirstItem(void);
	TOvcOutlineNode* __fastcall NextItem(void);
	TOvcOutlineNode* __fastcall LastItem(void);
	__property int CurrentKey = {read=GetCurrentKey, write=SetCurrentKey, nodefault};
	void __fastcall Clear(void);
	__property TOvcOutlineNode* Node[int Index] = {read=GetNode};
	TOvcOutlineNode* __fastcall GGEQ(TOvcOutlineNode* SearchNode);
	TOvcOutlineNode* __fastcall GLEQ(TOvcOutlineNode* SearchNode);
	void __fastcall PushIndex(void);
	void __fastcall PopIndex(void);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcOutlineNodes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	TOvcOutlineNode* operator[](int Index) { return Node[Index]; }
	
protected:
	TOvcCustomOutline* FOwner;
	TOvcOutlineNode* FParent;
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	int __fastcall GetCount(void);
	TOvcOutlineNode* __fastcall GetNode(int Index);
	int __fastcall GetLineCount(void);
	__property int LineCount = {read=GetLineCount, nodefault};
	TOvcOutlineNode* __fastcall FirstChild(void);
	TOvcOutlineNode* __fastcall LastChild(void);
	void __fastcall PushChildIndex(void);
	void __fastcall PopChildIndex(void);
	TOvcOutlineNode* __fastcall NextChild(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	TOvcOutlineNode* __fastcall Add(const System::UnicodeString S);
	TOvcOutlineNode* __fastcall AddButtonChild(TOvcOutlineNode* Node, const System::UnicodeString S, TOvcOlNodeStyle InitStyle, bool InitChecked);
	TOvcOutlineNode* __fastcall AddButtonChildObject(TOvcOutlineNode* Node, const System::UnicodeString S, void * Ptr, TOvcOlNodeStyle InitStyle, bool InitChecked);
	TOvcOutlineNode* __fastcall AddChild(TOvcOutlineNode* Node, const System::UnicodeString S);
	TOvcOutlineNode* __fastcall AddChildEx(TOvcOutlineNode* Node, const System::UnicodeString S, int InitImageIndex, TOvcOlNodeMode InitMode);
	TOvcOutlineNode* __fastcall AddChildObject(TOvcOutlineNode* Node, const System::UnicodeString S, void * Ptr);
	TOvcOutlineNode* __fastcall AddChildObjectEx(TOvcOutlineNode* Node, const System::UnicodeString S, void * Ptr, int InitImageIndex, TOvcOlNodeMode InitMode);
	TOvcOutlineNode* __fastcall AddEx(const System::UnicodeString S, int InitImageIndex, TOvcOlNodeMode InitMode);
	TOvcOutlineNode* __fastcall AddObject(const System::UnicodeString S, void * Ptr);
	TOvcOutlineNode* __fastcall AddObjectEx(const System::UnicodeString S, void * Ptr, int InitImageIndex, TOvcOlNodeMode InitMode);
	void __fastcall Clear(void);
	__property int Count = {read=GetCount, nodefault};
	__fastcall TOvcOutlineNodes(TOvcCustomOutline* AOwner, TOvcOutlineNode* AParent);
	__fastcall virtual ~TOvcOutlineNodes(void);
	__property TOvcOutlineNode* Node[int Index] = {read=GetNode/*, default*/};
	__property TOvcCustomOutline* Owner = {read=FOwner};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcCustomOutline : public Ovcvlb::TOvcCustomVirtualListBox
{
	typedef Ovcvlb::TOvcCustomVirtualListBox inherited;
	
protected:
	TOvcOutlineNode* FActiveNode;
	int FCurrentKey;
	bool FHideSelection;
	int FKeys;
	TOvcOlActiveChangeEvent FOnActiveChange;
	TOvcOlCompareNodesEvent FOnCompareNodes;
	TOvcOlDrawTextEvent FOnDrawText;
	TOvcOlDrawCheckEvent FOnDrawCheck;
	TOvcOlNodeEvent FOnDynamicLoad;
	TOvcOlNodeEvent FOnExpand;
	TOvcOlNodeEvent FOnCollapse;
	TOvcOlNodeEvent FOnNodeClick;
	TOvcOlNodeEvent FOnNodeDestroy;
	TOvcOutlineNodes* FNodes;
	bool FShowLines;
	bool FShowButtons;
	Vcl::Controls::TImageList* FImages;
	bool FShowImages;
	bool FTextSort;
	bool IsSimulated;
	Vcl::Graphics::TBitmap* LineCanvas;
	Ovcdlm::TOvcLiteCache* NodeCache;
	TOvcOutlineNodeList* FAbsNodes;
	TOvcOutlineNodeList* FNodeIndex;
	int AddIndex;
	bool FDelayNotify;
	bool Clearing;
	bool UpdateScrollWidthPending;
	int FCacheSize;
	void __fastcall SetCacheSize(const int Value);
	TOvcOutlineNode* __fastcall FirstChild(void);
	TOvcOutlineNode* __fastcall NextChild(void);
	TOvcOutlineNode* __fastcall LastChild(void);
	void __fastcall PopChildIndex(void);
	void __fastcall PushChildIndex(void);
	void __fastcall SetTextSort(const bool Value);
	void __fastcall SetCurrentKey(const int Value);
	void __fastcall SetKeys(const int Value);
	HIDESBASE MESSAGE void __fastcall CMHintShow(Winapi::Messages::TMessage &Message);
	DYNAMIC void __fastcall Click(void);
	DYNAMIC void __fastcall DblClick(void);
	int __fastcall CalcMaxWidth(void);
	int __fastcall CompareNodesGlobal(int Key, void * I1, void * I2);
	int __fastcall CompareNodesLocal(int Key, void * I1, void * I2);
	virtual void __fastcall DoActiveChange(TOvcOutlineNode* OldNode, TOvcOutlineNode* NewNode);
	virtual bool __fastcall DoDrawCheck(Vcl::Graphics::TCanvas* Canvas, TOvcOutlineNode* Node, const System::Types::TRect &Rect, TOvcOlNodeStyle Style, bool Checked);
	virtual bool __fastcall DoDrawText(Vcl::Graphics::TCanvas* Canvas, TOvcOutlineNode* Node, const System::UnicodeString Text, const System::Types::TRect &Rect);
	virtual void __fastcall DoDynamicLoad(TOvcOutlineNode* Node);
	DYNAMIC void __fastcall DoExpandCollapse(TOvcOutlineNode* Node, bool Expanding);
	virtual void __fastcall DoNodeDestroy(TOvcOutlineNode* Node);
	virtual bool __fastcall DoOnIsSelected(int Index);
	DYNAMIC void __fastcall DoOnSelect(int Index, bool Selected);
	void __fastcall DoNodeClick(TOvcOutlineNode* Node);
	bool __fastcall GetIsGroup(int Index);
	int __fastcall GetAbsNodes(void);
	TOvcOutlineNode* __fastcall GetAbsNode(int Index);
	TOvcOutlineNode* __fastcall GetNode(int Index);
	__property bool IsGroup[int Index] = {read=GetIsGroup};
	void __fastcall SetNodes(TOvcOutlineNodes* const Value);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	int __fastcall Lines(void);
	int __fastcall IndexFromNode(TOvcOutlineNode* CurNode);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	int __fastcall PointToIndex(int Y);
	void __fastcall SetActiveNode(TOvcOutlineNode* const Value);
	void __fastcall SetHideSelection(const bool Value);
	void __fastcall SetImages(Vcl::Controls::TImageList* const Value);
	virtual void __fastcall SetScrollBars(const System::Uitypes::TScrollStyle Value);
	void __fastcall SetShowButtons(const bool Value);
	void __fastcall SetShowImages(const bool Value);
	void __fastcall SetShowLines(const bool Value);
	virtual void __fastcall SimulatedClick(void);
	void __fastcall UpdateActiveNode(void);
	void __fastcall UpdateScrollWidth(void);
	void __fastcall UpdateLines(void);
	HIDESBASE void __fastcall vlbDrawFocusRect(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Rect);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	bool __fastcall NotAutoRowHeight(void);
	
public:
	__property int AbsNodes = {read=GetAbsNodes, nodefault};
	__property TOvcOutlineNode* AbsNode[int Index] = {read=GetAbsNode};
	__property TOvcOutlineNode* ActiveNode = {read=FActiveNode, write=SetActiveNode};
	virtual void __fastcall BeginUpdate(void);
	__property int CacheSize = {read=FCacheSize, write=SetCacheSize, default=4096};
	void __fastcall Clear(void);
	void __fastcall CollapseAll(void);
	__property int CurrentKey = {read=FCurrentKey, write=SetCurrentKey, nodefault};
	virtual void __fastcall EndUpdate(void);
	void __fastcall ExpandAll(void);
	TOvcOutlineNode* __fastcall FindNode(const System::UnicodeString Text);
	__property bool HideSelection = {read=FHideSelection, write=SetHideSelection, nodefault};
	__property int Keys = {read=FKeys, write=SetKeys, default=1};
	__fastcall virtual TOvcCustomOutline(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomOutline(void);
	__property Vcl::Controls::TImageList* Images = {read=FImages, write=SetImages};
	__property TOvcOutlineNodes* Nodes = {read=FNodes, write=SetNodes};
	__property TOvcOutlineNode* Node[int Index] = {read=GetNode};
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall LoadFromText(const System::UnicodeString FileName, System::Sysutils::TEncoding* Encoding = (System::Sysutils::TEncoding*)(0x0));
	void __fastcall SaveAsText(const System::UnicodeString FileName)/* overload */;
	void __fastcall SaveAsText(const System::UnicodeString FileName, System::Sysutils::TEncoding* Encoding)/* overload */;
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property bool ShowButtons = {read=FShowButtons, write=SetShowButtons, default=1};
	__property bool ShowImages = {read=FShowImages, write=SetShowImages, default=1};
	__property bool ShowLines = {read=FShowLines, write=SetShowLines, default=1};
	__property bool TextSort = {read=FTextSort, write=SetTextSort, default=0};
	__property TOvcOlActiveChangeEvent OnActiveChange = {read=FOnActiveChange, write=FOnActiveChange};
	__property TOvcOlNodeEvent OnCollapse = {read=FOnCollapse, write=FOnCollapse};
	__property TOvcOlCompareNodesEvent OnCompareNodes = {read=FOnCompareNodes, write=FOnCompareNodes};
	__property TOvcOlDrawCheckEvent OnDrawCheck = {read=FOnDrawCheck, write=FOnDrawCheck};
	__property TOvcOlDrawTextEvent OnDrawText = {read=FOnDrawText, write=FOnDrawText};
	__property TOvcOlNodeEvent OnDynamicLoad = {read=FOnDynamicLoad, write=FOnDynamicLoad};
	__property TOvcOlNodeEvent OnExpand = {read=FOnExpand, write=FOnExpand};
	__property TOvcOlNodeEvent OnNodeClick = {read=FOnNodeClick, write=FOnNodeClick};
	__property TOvcOlNodeEvent OnNodeDestroy = {read=FOnNodeDestroy, write=FOnNodeDestroy};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomOutline(HWND ParentWindow) : Ovcvlb::TOvcCustomVirtualListBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcOutline : public TOvcCustomOutline
{
	typedef TOvcCustomOutline inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property AfterEnter;
	__property AfterExit;
	__property Align = {default=0};
	__property AutoRowHeight = {default=1};
	__property BorderStyle = {default=1};
	__property CacheSize = {default=4096};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=0};
	__property Images;
	__property IntegralHeight = {default=1};
	__property Nodes;
	__property Keys = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=0};
	__property PopupMenu;
	__property RowHeight = {stored=NotAutoRowHeight, default=17};
	__property ScrollBars = {default=2};
	__property SelectColor;
	__property ShowButtons = {default=1};
	__property ShowHint = {default=1};
	__property ShowImages = {default=1};
	__property ShowLines = {default=1};
	__property SmoothScroll = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property TextSort = {default=0};
	__property Visible = {default=1};
	__property OnActiveChange;
	__property OnClick;
	__property OnCollapse;
	__property OnCompareNodes;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDrawCheck;
	__property OnDrawText;
	__property OnDynamicLoad;
	__property OnEnter;
	__property OnExpand;
	__property OnExit;
	__property OnNodeClick;
	__property OnNodeDestroy;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TOvcCustomOutline.Create */ inline __fastcall virtual TOvcOutline(System::Classes::TComponent* AOwner) : TOvcCustomOutline(AOwner) { }
	/* TOvcCustomOutline.Destroy */ inline __fastcall virtual ~TOvcOutline(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcOutline(HWND ParentWindow) : TOvcCustomOutline(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ChildIndent = System::Int8(0x11);
}	/* namespace Ovcoutln */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCOUTLN)
using namespace Ovcoutln;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcoutlnHPP
