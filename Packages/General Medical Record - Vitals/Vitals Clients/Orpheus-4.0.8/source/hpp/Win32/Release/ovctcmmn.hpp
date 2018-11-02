// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcmmn.pas' rev: 29.00 (Windows)

#ifndef OvctcmmnHPP
#define OvctcmmnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcmmn
{
//-- forward type declarations -----------------------------------------------
struct TCellBitMapInfo;
struct TCellComboBoxInfo;
struct TOvcCellAttributes;
struct TOvcRowAttributes;
class DELPHICLASS TOvcTableCellAncestor;
class DELPHICLASS TOvcTableAncestor;
struct TOvcSparseAttr;
struct TOvcTableNumberArray;
struct TRowStyle;
class DELPHICLASS EOrpheusTable;
struct TOvcTblDisplayItem;
struct TOvcTblDisplayArray;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcTblAdjust : unsigned char { otaDefault, otaTopLeft, otaTopCenter, otaTopRight, otaCenterLeft, otaCenter, otaCenterRight, otaBottomLeft, otaBottomCenter, otaBottomRight };

enum DECLSPEC_DENUM TOvcTblAccess : unsigned char { otxDefault, otxNormal, otxReadOnly, otxInvisible };

enum DECLSPEC_DENUM TOvcTblState : unsigned char { otsFocused, otsUnfocused, otsDesigning, otsNormal, otsEditing, otsHiddenEdit, otsMouseSelect, otsShowSize, otsSizing, otsShowMove, otsMoving, otsDoingRow, otsDoingCol, otsANOther };

typedef System::Set<TOvcTblState, TOvcTblState::otsFocused, TOvcTblState::otsANOther> TOvcTblStates;

enum DECLSPEC_DENUM TOvcTblKeyNeeds : unsigned char { otkDontCare, otkWouldLike, otkMustHave };

enum DECLSPEC_DENUM TOvcTblRegion : unsigned char { otrInMain, otrInLocked, otrInUnused, otrOutside };

enum DECLSPEC_DENUM TOvcTblOption : unsigned char { otoBrowseRow, otoNoRowResizing, otoNoColResizing, otoTabToArrow, otoEnterToArrow, otoAlwaysEditing, otoNoSelection, otoMouseDragSelect, otoRowSelection, otoColSelection, otoThumbTrack, otoAllowColMoves, otoAllowRowMoves };

typedef System::Set<TOvcTblOption, TOvcTblOption::otoBrowseRow, TOvcTblOption::otoAllowRowMoves> TOvcTblOptionSet;

enum DECLSPEC_DENUM TOvcScrollBar : unsigned char { otsbVertical, otsbHorizontal };

enum DECLSPEC_DENUM TOvcTblActions : unsigned char { taGeneral, taSingle, taAll, taInsert, taDelete, taExchange };

enum DECLSPEC_DENUM TOvcCellDataPurpose : unsigned char { cdpForPaint, cdpForEdit, cdpForSave };

enum DECLSPEC_DENUM TOvcTextStyle : unsigned char { tsFlat, tsRaised, tsLowered };

enum DECLSPEC_DENUM TOvcTblSelectionType : unsigned char { tstDeselectAll, tstAdditional };

enum DECLSPEC_DENUM TOvcTblEditorStyle : unsigned char { tesNormal, tesBorder, tes3D };

enum DECLSPEC_DENUM TOvcTblStringtype : unsigned char { tstShortString, tstPChar, tstString };

typedef int TRowNum;

typedef int TColNum;

typedef TCellBitMapInfo *PCellBitMapInfo;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCellBitMapInfo
{
public:
	Vcl::Graphics::TBitmap* BM;
	int Count;
	int ActiveCount;
	int Index;
};
#pragma pack(pop)


typedef TCellComboBoxInfo *PCellComboBoxInfo;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCellComboBoxInfo
{
public:
	int Index;
	System::UnicodeString St;
	System::Classes::TStrings* RTItems;
	System::UnicodeString RTSt;
	System::UnicodeString TextHint;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcCellAttributes
{
public:
	TOvcTblAccess caAccess;
	TOvcTblAdjust caAdjust;
	System::Uitypes::TColor caColor;
	Vcl::Graphics::TFont* caFont;
	System::Uitypes::TColor caFontColor;
	System::Uitypes::TColor caFontHiColor;
	TOvcTextStyle caTextStyle;
	System::Uitypes::TColor caBorderColor;
	Vcl::Graphics::TPenStyle caBorderStyle;
	int caBorderWidth;
	bool caAlwaysShowDropDown;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcRowAttributes
{
public:
	System::Uitypes::TColor caBorderColor;
	Vcl::Graphics::TPenStyle caBorderStyle;
	int caBorderWidth;
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TOvcTableCellAncestor : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	System::Classes::TNotifyEvent FOnCfgChanged;
	DYNAMIC void __fastcall tcChangeScale(int M, int D);
	void __fastcall tcDoCfgChanged(void);
	
public:
	virtual void __fastcall tcResetTableValues(void) = 0 ;
	__property System::Classes::TNotifyEvent OnCfgChanged = {write=FOnCfgChanged};
public:
	/* TComponent.Create */ inline __fastcall virtual TOvcTableCellAncestor(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TOvcTableCellAncestor(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTableAncestor : public Ovcbase::TO32CustomControl
{
	typedef Ovcbase::TO32CustomControl inherited;
	
protected:
	Ovcbase::TOvcController* FController;
	System::Classes::TList* taCellList;
	System::Classes::TStringList* taLoadList;
	bool __fastcall ControllerAssigned(void);
	virtual void __fastcall SetController(Ovcbase::TOvcController* Value);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Loaded(void);
	void __fastcall tbFinishLoadingCellList(void);
	void __fastcall tbReadCellData(System::Classes::TReader* Reader);
	void __fastcall tbWriteCellData(System::Classes::TWriter* Writer);
	virtual void __fastcall tbCellChanged(System::TObject* Sender) = 0 ;
	
public:
	void __fastcall tbExcludeCell(TOvcTableCellAncestor* Cell);
	void __fastcall tbIncludeCell(TOvcTableCellAncestor* Cell);
	void __fastcall tbNotifyCellsOfTableChange(void);
	__fastcall virtual TOvcTableAncestor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcTableAncestor(void);
	__property Ovcbase::TOvcController* Controller = {read=FController, write=SetController};
	virtual TOvcTblKeyNeeds __fastcall FilterKey(Winapi::Messages::TWMKey &Msg) = 0 ;
	virtual void __fastcall ResolveCellAttributes(int RowNum, int ColNum, TOvcCellAttributes &CellAttr) = 0 ;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTableAncestor(HWND ParentWindow) : Ovcbase::TO32CustomControl(ParentWindow) { }
	
};


typedef TOvcSparseAttr *POvcSparseAttr;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcSparseAttr
{
public:
	TOvcTblAccess scaAccess;
	TOvcTblAdjust scaAdjust;
	System::Uitypes::TColor scaColor;
	Vcl::Graphics::TFont* scaFont;
	TOvcTableCellAncestor* scaCell;
};
#pragma pack(pop)


typedef TOvcTableNumberArray *POvcTableNumberArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcTableNumberArray
{
public:
	int NumElements;
	int Count;
	System::StaticArray<int, 30> Number;
};
#pragma pack(pop)


typedef TRowStyle *PRowStyle;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TRowStyle
{
public:
	int Height;
	bool Hidden;
};
#pragma pack(pop)


typedef System::ShortString *POvcShortString;

#pragma pack(push,4)
class PASCALIMPLEMENTATION EOrpheusTable : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EOrpheusTable(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EOrpheusTable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EOrpheusTable(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EOrpheusTable(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EOrpheusTable(NativeUInt Ident, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EOrpheusTable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EOrpheusTable(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EOrpheusTable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOrpheusTable(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOrpheusTable(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOrpheusTable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOrpheusTable(NativeUInt Ident, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EOrpheusTable(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TRowNotifyEvent)(System::TObject* Sender, int RowNum);

typedef void __fastcall (__closure *TColNotifyEvent)(System::TObject* Sender, int ColNum);

typedef void __fastcall (__closure *TColResizeEvent)(System::TObject* Sender, int ColNum, int NewWidth);

typedef void __fastcall (__closure *TRowResizeEvent)(System::TObject* Sender, int RowNum, int NewHeight);

typedef void __fastcall (__closure *TCellNotifyEvent)(System::TObject* Sender, int RowNum, int ColNum);

typedef void __fastcall (__closure *TCellDataNotifyEvent)(System::TObject* Sender, int RowNum, int ColNum, void * &Data, TOvcCellDataPurpose Purpose);

typedef void __fastcall (__closure *TCellAttrNotifyEvent)(System::TObject* Sender, int RowNum, int ColNum, TOvcCellAttributes &CellAttr);

typedef void __fastcall (__closure *TRowAttrNotifyEvent)(System::TObject* Sender, int RowNum, TOvcRowAttributes &RowAttr);

typedef void __fastcall (__closure *TCellPaintNotifyEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const TOvcCellAttributes &CellAttr, void * Data, bool &DoneIt);

typedef void __fastcall (__closure *TCellBeginEditNotifyEvent)(System::TObject* Sender, int RowNum, int ColNum, bool &AllowIt);

typedef void __fastcall (__closure *TCellEndEditNotifyEvent)(System::TObject* Sender, TOvcTableCellAncestor* Cell, int RowNum, int ColNum, bool &AllowIt);

typedef void __fastcall (__closure *TCellMoveNotifyEvent)(System::TObject* Sender, System::Word Command, int &RowNum, int &ColNum);

typedef void __fastcall (__closure *TCellChangeNotifyEvent)(System::TObject* Sender, int &RowNum, int &ColNum);

typedef void __fastcall (__closure *TRowChangeNotifyEvent)(System::TObject* Sender, int RowNum1, int RowNum2, TOvcTblActions Action);

typedef void __fastcall (__closure *TColChangeNotifyEvent)(System::TObject* Sender, int ColNum1, int ColNum2, TOvcTblActions Action);

typedef void __fastcall (__closure *TSizeCellEditorNotifyEvent)(System::TObject* Sender, int RowNum, int ColNum, System::Types::TRect &CellRect, TOvcTblEditorStyle &CellStyle);

typedef bool __fastcall (__closure *TSelectionIterator)(int RowNum1, int ColNum1, int RowNum2, int ColNum2, void * ExtraData);

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcTblDisplayItem
{
public:
	int Number;
	int Offset;
};
#pragma pack(pop)


typedef TOvcTblDisplayArray *POvcTblDisplayArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcTblDisplayArray
{
public:
	System::Word AllocNm;
	System::Word Count;
	System::StaticArray<TOvcTblDisplayItem, 128> Ay;
};
#pragma pack(pop)


//-- var, const, procedure ---------------------------------------------------
static const System::Word ctim_Base = System::Word(0x4945);
static const System::Word ctim_QueryOptions = System::Word(0x4945);
static const System::Word ctim_QueryColor = System::Word(0x4946);
static const System::Word ctim_QueryFont = System::Word(0x4947);
static const System::Word ctim_QueryLockedCols = System::Word(0x4948);
static const System::Word ctim_QueryLockedRows = System::Word(0x4949);
static const System::Word ctim_QueryActiveCol = System::Word(0x494a);
static const System::Word ctim_QueryActiveRow = System::Word(0x494b);
static const System::Word ctim_RemoveCell = System::Word(0x494f);
static const System::Word ctim_StartEdit = System::Word(0x4950);
static const System::Word ctim_StartEditMouse = System::Word(0x4951);
static const System::Word ctim_StartEditKey = System::Word(0x4952);
static const System::Word ctim_SetFocus = System::Word(0x4953);
static const System::Word ctim_KillFocus = System::Word(0x4954);
static const System::Word ctim_LoadDefaultCells = System::Word(0x4959);
static const TOvcTblAccess tbDefAccess = (TOvcTblAccess)(1);
static const TOvcTblAdjust tbDefAdjust = (TOvcTblAdjust)(4);
static const Vcl::Forms::TFormBorderStyle tbDefBorderStyle = (Vcl::Forms::TFormBorderStyle)(1);
static const System::Int8 tbDefColCount = System::Int8(0xa);
static const System::Byte tbDefColWidth = System::Byte(0x96);
static const int tbDefGridColor = int(0);
static const System::Int8 tbDefHeight = System::Int8(0x64);
static const System::Int8 tbDefLockedCols = System::Int8(0x1);
static const System::Int8 tbDefLockedRows = System::Int8(0x1);
static const System::Int8 tbDefMargin = System::Int8(0x4);
static const System::Int8 tbDefRowCount = System::Int8(0xa);
static const System::Int8 tbDefRowHeight = System::Int8(0x1e);
static const System::Uitypes::TScrollStyle tbDefScrollBars = (System::Uitypes::TScrollStyle)(3);
static const int tbDefTableColor = int(-16777201);
static const System::Word tbDefWidth = System::Word(0x12c);
static const int clOvcTableDefault = int(0x2ffffff);
static const System::Int8 CRCFXY_RowAbove = System::Int8(-2);
static const System::Int8 CRCFXY_RowBelow = System::Int8(-1);
static const System::Int8 CRCFXY_ColToLeft = System::Int8(-2);
static const System::Int8 CRCFXY_ColToRight = System::Int8(-1);
static const System::Int8 RowLimitChanged = System::Int8(-2);
static const System::Int8 UseDefHt = System::Int8(-1);
extern DELPHI_PACKAGE void __fastcall TableError(const System::UnicodeString Msg);
extern DELPHI_PACKAGE void __fastcall TableErrorRes(System::Word StringCode);
extern DELPHI_PACKAGE void __fastcall AssignDisplayArray(POvcTblDisplayArray &A, System::Word Num);
extern DELPHI_PACKAGE TRowStyle __fastcall MakeRowStyle(int AHeight, bool AHidden);
}	/* namespace Ovctcmmn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCMMN)
using namespace Ovctcmmn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcmmnHPP
