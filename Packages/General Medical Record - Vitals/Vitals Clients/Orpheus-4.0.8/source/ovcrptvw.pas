{*********************************************************}
{*                  OVCRPTVW.PAS 4.08                   *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

(*Changes)

  10/20/01- Hdc changed to TOvcHdc for BCB Compatibility
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcrptvw;

interface

uses
  Types, Windows, Classes, Controls, ExtCtrls, Forms, Graphics, Messages, SysUtils,
  Menus, StdCtrls, ImgList, Variants, OvcFiler, OvcConst, OvcExcpt, OvcBase, OvcBtnHd,
  OvcData, OvcMisc, OvcVLB, OvcRVIdx, OvcColor, OvcRvExpDef, UITypes;

const
  {default property values}
  rvDefShowHeader       = True;
  rvDefShowFooter       = False;
  rvDefShowGroupTotals  = False;
  rvDefShowGroupCounts  = False;
  rvDefColWidth         = 50;
  rvDefColPrintWidth    = 1440; {in TWIPS ( 1 TWIP = 1/1440 inch ) }
  rvDefColComputeTotals = False;
  rvDefColOwnerDraw     = False;
  rvDefShowHint         = True;
  rvDefKeyTimeout       = 1000;
  OM_MAKEGROUPVISIBLE   = OM_FIRST + 3;

  OvcRptVwShowTruncTextHint : Boolean = True;


type
  TOvcRVListBox = class;
  TOvcCustomReportView = class;


  TOvcRVHeader = class(TOvcButtonHeader)
  protected
    FListBox : TOvcRVListBox;
    ShowingSizer : Boolean;
    LastOffset : Integer;
    InRearrange: Boolean;
    procedure HideShowSizer(Position: Integer);
    procedure HideSizer;
    procedure ShowSizer(ASection : Integer);
    procedure DoOnClick; override;
    procedure DblClick; override;
    procedure DoOnSized(ASection, AWidth : Integer); override;
    procedure DoOnSizing(ASection, AWidth : Integer); override;
    function DoRearranging(OldIndex, NewIndex: Integer): Boolean; override;
    procedure DoRearranged(OldIndex, NewIndex: Integer); override;
    procedure Paint; override;
    procedure SetSortGlyph;

  public
    procedure Reload;
    property ListBox : TOvcRVListBox
      read FListBox write FListBox;
  end;



  TOvcRVFooter = class(TOvcButtonHeader)
  protected
    FListBox : TOvcRVListBox;
    procedure Paint; override;
  public
    procedure Reload;
    procedure UpdateSections;
    property ListBox : TOvcRVListBox
      read FListBox write FListBox;
  end;


  TOvcRVGridLines = (glNone,glVertical,glHorizontal,glBoth);

  { new - for optimized streaming}
  TOvcRvListSelectColors = class(TOvcColors)
  published
    property BackColor default clHighlight;
    property TextColor default clHighlightText;
  end;


  TOvcRVListBox = class(TOvcVirtualListBox)
  protected
    FButtonHeader : TOvcRVHeader;
    FFooter       : TOvcRVFooter;
    FGridLines    : TOvcRVGridLines;
    LineCanvas    : TBitmap;
    FocusLeft     : Integer;
    InClick       : Boolean;
    IsSimulated   : Boolean;
    HintRect      : TRect;
    FSelectColor : TOvcRvListSelectColors;
    function CalcMaxX: Integer;
    procedure Click; override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    function DoOnIsSelected(Index : Integer) : Boolean; override;
    procedure DoOnSelect(Index : Integer; Selected : Boolean); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DrawGroupItem(Canvas : TCanvas; Data : Pointer;
      Group : Integer; Expanded : Boolean;
      const Rect : TRect; FGColor : TColor;BGColor : TColor;
      GroupRef : TOvcRvIndexGroup; IsSelected : Boolean;
      MaxX: Integer);
    procedure DrawItem(Canvas : TCanvas; Data : Pointer;
      const Rect : TRect; FGColor : TColor;BGColor : TColor;
      IsSelected : Boolean);
    procedure DrawItemG(Canvas : TCanvas; Data : Pointer; const Rect : TRect; FGColor : TColor; BGColor : TColor;
      GroupRef : TOvcRvIndexGroup; IsSelected : Boolean);
    function GetStringAtPos(XY : TPoint) : string;
    procedure InternalDrawItem(N : Integer; const CR : TRect);
    procedure InternalSetItemIndex(Index: Integer; DeselectOld: Boolean);
    procedure Paint; override;
    procedure SetGridLines(Value : TOvcRVGridLines);
    procedure SetItemIndex(Index : Integer); override;
    procedure SetMultiSelect(Value : Boolean); override;
    procedure SimulatedClick; override;
    procedure vlbCalcFontFields; override;
    procedure vlbDrawFocusRect(Canvas : TCanvas; Left, Right : Integer; Index : Integer);
    procedure WMKeyDown(var Msg : TWMKeyDown); message WM_KEYDOWN;
    procedure WMLButtonDown(var Msg : TWMLButtonDown); message WM_LBUTTONDOWN;
    {procedure WMMouseMove(var Msg : TWMMouseMove); message WM_MOUSEMOVE;}
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMKillFocus(var Msg : TWmKillFocus);
      message WM_KILLFOCUS;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
  public
    ReportView : TOvcCustomReportView;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property GridLines : TOvcRVGridLines
                   read FGridLines write SetGridLines;
    property RVFooter : TOvcRVFooter
                   read FFooter write FFooter;
    property RVHeader : TOvcRVHeader
                   read FButtonHeader write FButtonHeader;
    property SelectColor : TOvcRvListSelectColors
      read FSelectColor write FSelectColor;
  end;


  TOvcRvFieldSort = (rfsFirstAscending, rfsFirstDescending,
    rfsAlwaysAscending, rfsAlwaysDescending);
  TOvcRvField = class(TOvcAbstractRvField)

  protected
    FAlignment         : TAlignment;
    FCaption           : string;
    FDefaultPrintWidth : Integer;
    FDefaultWidth      : Integer;
    FDefaultOwnerDraw  : Boolean;
    FDefaultSortDirection : TOvcRvFieldSort;
    FExpression        : string;
    FImageIndex        : Integer;
    FNoDesign          : Boolean;
    FVPage             : Integer;
    FHint              : string;
    FExp               : TOvcRvExpression;
    FDirty             : Boolean;
    FDFMBased          : Boolean;
    function Exp: TOvcRvExpression;
    function GetBaseName : string; override;
    function GetDisplayText: string; override;
    function GetOwnerReport : TOvcCustomReportView;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetName(const NewName : TComponentName); override;
    property OwnerReport : TOvcCustomReportView
                   read GetOwnerReport;
    procedure LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string);
    procedure SaveToStorage(Storage: TOvcAbstractStore;
      const Prefix: string);
    procedure SetImageIndex(const Value: Integer);
    procedure SetExpression(const Value: string);
    procedure SetDirty(const Value: Boolean);
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetValue(Data: Pointer): Variant; override;
    function AsString(Data: Pointer): string; override;
    function InUse: Boolean;
    function RefersTo(const RefField: TOvcRvField): Boolean;
    procedure ValidateExpression;

  published
    property Alignment: TAlignment
                   read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string
                   read FCaption write SetCaption;
    {inherited properties}
    property CanSort default True;
    property DataType : TOvcDRDataType
      read FDataType write FDataType default dtString;
    property DefaultOwnerDraw: Boolean
      read FDefaultOwnerDraw write FDefaultOwnerDraw default False;
    property DefaultPrintWidth : Integer
                   read FDefaultPrintWidth write FDefaultPrintWidth
                   default rvDefColPrintWidth;
    property DefaultSortDirection: TOvcRvFieldSort
                   read FDefaultSortDirection write FDefaultSortDirection
                   default rfsFirstAscending;
    property DefaultWidth : Integer
                   read FDefaultWidth write FDefaultWidth default rvDefColWidth;
    property Expression: string
                   read FExpression write SetExpression;
    property ImageIndex: Integer
                   read FImageIndex write SetImageIndex default -1;
    property Hint: string read FHint write FHint;
    property NoDesign: Boolean read FNoDesign write FNoDesign default False;
    property Dirty: Boolean read FDirty write SetDirty
      stored False;
  end;

  TOvcRvFields = class(TOvcAbstractRvFields)

  protected
    function GetItem(Index: Integer): TOvcRvField;
    procedure SetItem(Index: Integer; Value: TOvcRvField);
    function GetOwnerReport : TOvcCustomReportView;
  public
    constructor Create(AOwner: TOvcCustomReportView);

    procedure Assign(Source: TPersistent); override;
    function Add: TOvcRvField;
    property Items[Index: Integer]: TOvcRvField
                   read GetItem write SetItem;

    property Owner: TOvcCustomReportView
                   read GetOwnerReport;

  end;


  TOvcRVView = class;
  TOvcRvViewField = class(TOvcAbstractRvViewField)
  protected
    FAggregate: string;
    FAllowResize: Boolean;
    FOwnerDraw  : Boolean;
    FPrintWidth : Integer;
    FWidth      : Integer;
    FShowHint   : Boolean;
    FVisible    : Boolean;
    FAggExp: TOvcRvExpression;
    FSortDirection: TOvcRvFieldSort;
    procedure Changed; override;
    function GetBaseName : string; override;
    function GetField : TOvcRvField;
    function GetDisplayText: string; override;
    function GetOwnerReport : TOvcCustomReportView;
    function GetOwnerView: TOvcRvView;
    function GetPrintWidth : Integer;
    function GetPrintWidthStored: Boolean;
    function GetWidth : Integer;
    function GetWidthStored: Boolean;
    procedure SetAggregate(const Value: string);
    procedure SetIndex(Value: Integer); override;
    procedure SetPrintWidth(Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(Value: Integer);
    function GetAggExp: TOvcRvExpression;
  protected
    procedure SaveToStorage(Storage: TOvcAbstractStore;
      const Prefix: string); override;
    function LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string): Boolean; override;
    function GetAllowResize: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property AggExp: TOvcRvExpression read GetAggExp;

    property Field: TOvcRvField
                   read GetField;
    property OwnerReport : TOvcCustomReportView
                   read GetOwnerReport;
    property OwnerView : TOvcRvView
                   read GetOwnerView;
  published
    property OwnerDraw : Boolean
                   read FOwnerDraw write FOwnerDraw
                   default rvDefColOwnerDraw;
    property PrintWidth: Integer
                   read GetPrintWidth write SetPrintWidth
                   stored GetPrintWidthStored default -1;
    property Width: Integer
                   read GetWidth write SetWidth
                   stored GetWidthStored default -1;
    {inherited properties}
    property ComputeTotals;
    property FieldName;
    property GroupBy;
    property ShowHint : Boolean read FShowHint write FShowHint
      default rvDefShowHint;
    property AllowResize : Boolean read GetAllowResize write FAllowResize
      default True;
    property Visible: Boolean read FVisible write SetVisible
      default True;
    property Aggregate: string read FAggregate write SetAggregate;
    property SortDirection: TOvcRvFieldSort
                   read FSortDirection write FSortDirection
                   default rfsFirstAscending;
  end;

  TOvcRvViewFields = class(TOvcAbstractRvViewFields)

  protected
    function GetItem(Index: Integer): TOvcRvViewField;
    procedure SetItem(Index: Integer; Value: TOvcRvViewField);
    function GetOwnerView : TOvcRVView;
  public
    constructor Create(AOwner: TOvcRVView);

    function Add: TOvcRvViewField;
    property Items[Index: Integer]: TOvcRvViewField
                   read GetItem write SetItem;

    property Owner: TOvcRVView
                   read GetOwnerView;

  end;

  TOvcRVView = class(TOvcAbstractRvView)

  protected
    FShowFooter: Boolean;
    FShowHeader: Boolean;
    FShowGroupCounts: Boolean;
    FShowGroupTotals: Boolean;
    FTitle: string;
    FDefaultSortColumn: Integer;
    FDefaultSortDescending : Boolean;
    FDirty: Boolean;
    FHidden: Boolean;
    FDFMBased: Boolean;
    FFilterExp: TOvcRvExpression;
    procedure SetDirty(const Value: Boolean);
    function GetViewFields: TOvcRvViewFields;
    procedure SetViewFields(const Value: TOvcRvViewFields);
    function GetBaseName : string; override;
    function GetViewField(Index : Integer) : TOvcRvViewField;
    procedure AncestorNotFound(Reader: TReader;
      const ComponentName: string; ComponentClass: TPersistentClass;
      var Component: TComponent);
    procedure ReadState(Reader: TReader); override;
    procedure SetName(const NewName : TComponentName); override;
    procedure SetShowFooter(Value : Boolean);
    procedure SetShowHeader(Value : Boolean);
    procedure SetTitle(const Value: string);
    procedure SetFilter(const Value: string); virtual;
    function Include(Data: Pointer): Boolean;
    function GetFilterExp: TOvcRvExpression;
    property FilterExp: TOvcRvExpression read GetFilterExp;
    function OwnerReport: TOvcCustomReportView;
    function UniqueViewTitle(const Title : string) : string;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property Dirty: Boolean read FDirty write SetDirty;

    procedure SaveToStorage(Storage: TOvcAbstractStore;
      const Prefix: string); override;
    procedure LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string); override;
    procedure Refresh;
    property ViewField[Index : Integer] : TOvcRvViewField
                   read GetViewField;
  published
    property DefaultSortColumn : Integer
                   read FDefaultSortColumn write FDefaultSortColumn
                   default 0;
    property DefaultSortDescending : Boolean
                   read FDefaultSortDescending
                   write FDefaultSortDescending
                   default False;
    property Filter: string read FFilter write SetFilter;
    property Hidden: Boolean read FHidden write FHidden
      default False;
    property ShowGroupCounts : Boolean
                   read FShowGroupCounts write FShowGroupCounts
                   default False;
    property ShowGroupTotals : Boolean
                   read FShowGroupTotals write FShowGroupTotals
                   default rvDefShowGroupTotals;
    property ShowFooter : Boolean
                   read FShowFooter write SetShowFooter default rvDefShowFooter;
    property ShowHeader : Boolean
                   read FShowHeader write SetShowHeader default rvDefShowHeader;
    property Title : string
                   read FTitle write SetTitle;
    property ViewFields: TOvcRvViewFields read GetViewFields write SetViewFields;
    {inherited properties}
    property FilterIndex;
  end;

  TOvcRvViews = class(TOvcAbstractRvViews)

  protected
    function GetItem(Index: Integer): TOvcRVView;
    procedure SetItem(Index: Integer; Value: TOvcRVView);

  public
    constructor Create(AOwner: TOvcCustomReportView);
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;


    function Add: TOvcRVView;
    property Items[Index: Integer]: TOvcRVView
                   read GetItem write SetItem;
  end;

  TOvcRVGetGroupStringEvent =
    procedure(Sender : TObject; FieldIndex : Integer; GroupRef : TOvcRvIndexGroup;
      var Str : string) of object;
  TOvcGetPrintHeaderFooterEvent =
    procedure(Sender : TObject; IsHeader : Boolean; Line : Integer;
      var LeftString,CenterString,RightString : string;
      var LeftAttr,CenterAttr,RightAttr : TFontStyles) of object;
  TOvcRvSignalBusyEvent =
    procedure(Sender : TObject; BusyFlag : Boolean) of object;
  TOvcDrawViewFieldEvent =
    procedure(Sender : TObject; Canvas : TCanvas; Data : Pointer; ViewFieldIndex: Integer;
      Rect : TRect; const S : string) of object;
  TOvcDrawViewFieldExEvent =
    procedure(Sender : TObject; Canvas : TCanvas;
      Field : TOvcRvField; ViewField : TOvcRvViewField;
      var TextAlign : Integer; IsSelected, IsGroupLine : Boolean;
      Data : Pointer; Rect : TRect; const Text, TruncText : string;
      var DefaultDrawing : Boolean) of object;
  TOvcPrintStatusEvent = procedure(Sender : TObject; Page : Integer;
    var Abort : Boolean) of object;
  TOvcKeySearchEvent = procedure(Sender : TObject; SortColumn : Integer;
        const KeyString : string) of object;
  TOvcDetailPrintEvent = procedure(Sender: TObject; MasterData: Pointer) of object;
  TOvcRVExpType = (etExpand,etCollapse,etToggle);
  TRVPrintMode = (pmCurrent,pmExpandAll,pmCollapseAll);

  { new - to optimize streaming}
  TRvPrintFont = class(TFont)
  protected
    function NameStored: Boolean;
  published
    property Charset default DEFAULT_CHARSET;
    property Color default clWindowText;
    property Height default -13;
    property Name stored NameStored;
    property Style default [];
  end;


  TOvcRvPrintProps = class(TPersistent)
  protected
    FDetailIndent      : Integer;
    FPrintColumnMargin : Integer;
    FPrintFont         : TRvPrintFont;
    FPrintFooterLines  : Integer;
    FPrintHeaderLines  : Integer;
    FPrintLineWidth    : Integer;
    FAutoScaleColumns  : Boolean;
    FPrintGridLines    : Boolean;
    FMarginLeft        : Integer;
    FMarginTop         : Integer;
    FMarginRight       : Integer;
    FMarginBottom      : Integer;
    procedure SetPrintFont(Value : TRvPrintFont);
  public
    constructor Create;
    destructor Destroy; override;
  published

    property AutoScaleColumns : Boolean
                   read FAutoScaleColumns write FAutoScaleColumns
                   default False;
    property DetailIndent: Integer
                   read FDetailIndent write FDetailIndent
                   default 0;
    property MarginLeft: Integer
                   read FMarginLeft write FMarginLeft
                   default 0;
    property MarginTop: Integer
                   read FMarginTop write FMarginTop
                   default 0;
    property MarginRight: Integer
                   read FMarginRight write FMarginRight
                   default 0;
    property MarginBottom: Integer
                   read FMarginBottom write FMarginBottom
                   default 0;
    property PrintColumnMargin : Integer
                   read FPrintColumnMargin write FPrintColumnMargin default 72;
    property PrintFont : TRvPrintFont
                   read FPrintFont write SetPrintFont;
    property PrintFooterLines : Integer
                   read FPrintFooterLines write FPrintFooterLines
                   default 0;
    property PrintGridLines : Boolean
                   read FPrintGridLines write FPrintGridLines
                   default False;
    property PrintHeaderLines : Integer
                   read FPrintHeaderLines write FPrintHeaderLines
                   default 0;
    property PrintLineWidth : Integer
                   read FPrintLineWidth write FPrintLineWidth default 12;
  end;

  TOvcRVOptions = class(TPersistent)
  protected
    FHeaderLines: Integer;
    FHeaderAutoHeight: Boolean;
    FHeaderHeight: Integer;
    FFooterAutoHeight: Boolean;
    FFooterHeight: Integer;
    FOwner : TOvcCustomReportView;
    FShowGroupCaptionInHeader: Boolean;
    FShowGroupCaptionInList: Boolean;
    function GetHeaderHeight: Integer;
    procedure SetHeaderHeight(const Value: Integer);
    function NotHeaderAutoHeight: Boolean;
    procedure SetHeaderAutoHeight(const Value: Boolean);
    function GetFooterHeight: Integer;
    procedure SetFooterHeight(const Value: Integer);
    function NotFooterAutoHeight: Boolean;
    procedure SetFooterAutoHeight(const Value: Boolean);
    function GetHeaderAllowDragRearrange: Boolean;
    procedure SetHeaderAllowDragRearrange(const Value: Boolean);
    function GetFooterDrawingStyle: TOvcBHDrawingStyle;
    function GetHeaderDrawingStyle: TOvcBHDrawingStyle;
    procedure SetFooterDrawingStyle(const Value: TOvcBHDrawingStyle);
    procedure SetHeaderDrawingStyle(const Value: TOvcBHDrawingStyle);
    function GetWheelDelta: Integer;
    procedure SetWheelDelta(const Value: Integer);
    function GetHeaderWordWrap: Boolean;
    procedure SetHeaderLines(const Value: Integer);
    procedure SetHeaderWordWrap(const Value: Boolean);
    function GetFooterTextMargin: Integer;
    function GetHeaderTextMargin: Integer;
    function GetListAutoRowHeight: Boolean;
    function GetListBorderStyle: TBorderStyle;
    function GetListColor: TColor;
    function GetListRowHeight: Integer;
    function GetListSelectColor: TOvcRvListSelectColors;
    procedure SetFooterTextMargin(const Value: Integer);
    procedure SetHeaderTextMargin(const Value: Integer);
    procedure SetListAutoRowHeight(const Value: Boolean);
    procedure SetListBorderStyle(const Value: TBorderStyle);
    procedure SetListColor(const Value: TColor);
    procedure SetListRowHeight(const Value: Integer);
    procedure SetListSelectColor(const Value: TOvcRvListSelectColors);
    procedure SetShowGroupCaptionInHeader(const Value: Boolean);
    procedure SetShowGroupCaptionInList(const Value: Boolean);
    function NotListAutoRowHeight: Boolean;
  public
    constructor Create(AOwner : TOvcCustomReportView);
    procedure Assign(Source: TPersistent); override;
  published
    property HeaderDrawingStyle : TOvcBHDrawingStyle
      read GetHeaderDrawingStyle write SetHeaderDrawingStyle
      default bhsEtched;
    property FooterDrawingStyle : TOvcBHDrawingStyle
      read GetFooterDrawingStyle write SetFooterDrawingStyle
      default bhsEtched;
    property HeaderAllowDragRearrange: Boolean
      read GetHeaderAllowDragRearrange write SetHeaderAllowDragRearrange
      default True;
    property HeaderAutoHeight: Boolean
      read FHeaderAutoHeight write SetHeaderAutoHeight
      default True;
    property HeaderHeight: Integer
      read GetHeaderHeight write SetHeaderHeight
      stored NotHeaderAutoHeight default 18;
    property HeaderLines : Integer
      read FHeaderLines write SetHeaderLines
      default 1;
    property HeaderWordWrap: Boolean
      read GetHeaderWordWrap write SetHeaderWordWrap
      default False;
    property HeaderTextMargin : Integer
      read GetHeaderTextMargin write SetHeaderTextMargin
      default 1;
    property FooterAutoHeight: Boolean
      read FFooterAutoHeight write SetFooterAutoHeight
      default True;
    property FooterHeight: Integer
      read GetFooterHeight write SetFooterHeight
      stored NotFooterAutoHeight default 18;
    property FooterTextMargin : Integer
      read GetFooterTextMargin write SetFooterTextMargin
      default 1;
    property ListAutoRowHeight : Boolean
      read GetListAutoRowHeight write SetListAutoRowHeight
      default True;
    property ListRowHeight : Integer
      read GetListRowHeight write SetListRowHeight
      stored NotListAutoRowHeight
      default 18;
    property ListBorderStyle : TBorderStyle
      read GetListBorderStyle write SetListBorderStyle
      default bsSingle;
    property ListColor : TColor
      read GetListColor write SetListColor
      default vlDefColor;
    property ListSelectColor : TOvcRvListSelectColors
      read GetListSelectColor write SetListSelectColor;
    property ShowGroupCaptionInHeader: Boolean
      read FShowGroupCaptionInHeader write SetShowGroupCaptionInHeader
      default False;
    property ShowGroupCaptionInList: Boolean
      read FShowGroupCaptionInList write SetShowGroupCaptionInList
      default True;
    property WheelDelta: Integer
      read GetWheelDelta write SetWheelDelta
      default 3;
  end;

  TRvChangeEvent = (rvViewCreate, rvViewDestroy, rvViewSelect, rvDestroying);
  TRVNotifyEvent = procedure(Sender : TOvcCustomReportView; Event : TRVChangeEvent) of object;
  TRvCurrentPosition =
    (rvpMoveToFirst, rvpMoveToLast, rvpMoveToNext, rvpMoveToPrevious,
     rvpScrollToTop, rvpScrollToBottom);

  TOvcReportViewClass = class of TOvcCustomReportView;

  TAdvancePageMethod = function(Canvas: TCanvas; var CurY: Integer; LineHeight,
      VPage, RenderPage: Integer; var Abort: Boolean; PrintStartLeft: Integer): Integer of object;
  TGetPageNumberMethod = function: Integer of object;

  TOvcCustomReportView = class(TOvcAbstractReportView)

  protected
    FActiveView              : string;
    FActiveViewByTitle       : string;
    FAutoCenter              : Boolean;
    FBorderStyle             : TBorderStyle;
    FCurrentView             : TOvcRVView;
    FFieldWidthStore         : TOvcAbstractStore;
    FCustomViewStore         : TOvcAbstractStore;
    FDesigning               : Boolean;
    FGroupColor              : TColor;
    FHideSelection           : Boolean;
    {FHoverTimer              : Integer;}
    FKeySearch               : Boolean;
    FKeyTimeout              : Integer;
    FPageNumber              : Integer;
    FPrinterProperties       : TOvcRvPrintProps;
    FDetailPrint             : TNotifyEvent;
    FOnClick                 : TNotifyEvent;
    FOnDblClick              : TNotifyEvent;
    FOnDrawViewField         : TOvcDrawViewFieldEvent;
    FOnDrawViewFieldEx       : TOvcDrawViewFieldExEvent;
    FOnGetGroupString        : TOvcRVGetGroupStringEvent;
    FOnGetPrintHeaderFooter  : TOvcGetPrintHeaderFooterEvent;
    FOnEnumerate             : TOvcRVEnumEvent;
    FOnKeyPress              : TKeyPressEvent;
    FOnKeySearch             : TOvcKeySearchEvent;
    FOnPrintStatus           : TOvcPrintStatusEvent;
    FOnSignalBusy            : TOvcRvSignalBusyEvent;
    FOnSortingChanged        : TNotifyEvent;
    FOptions                 : TOvcRVOptions;
    FOnViewSelect            : TNotifyEvent;
    FPrintDetailView: TOvcCustomReportView;
    InPrint                  : Integer;
    PLineHeight              : Integer;
    PLinesPerPage            : Integer;
    PMaxVertPage             : Integer;
    FPPageCount              : Integer;
    PrintAborted             : Boolean;
    DidPrint                 : Boolean;
    PAspect                  : double;
    FScrollBars              : TScrollStyle;
    FWidthChanged            : Boolean;
    StoreChangedWidths       : Boolean;
    ChangeNotificationList   : TList;
    ColWidthKey              : string;
    {HintShownHere            : Boolean;
    HintWindow               : THintWindow;
    HintX                    : Integer;
    HintY                    : Integer;                                !!.02}
    KeyString                : string;
    LastKeyTime              : Integer;
    HeaderPanel              : TPanel;
    FooterPanel              : TPanel;
    rvHaveHS                 : Boolean;
    HScrollDelta             : Integer;
    ClientExtra              : Integer;
    FRVHeader                : TOvcRVHeader;
    FRVFooter                : TOvcRVFooter;
    FRVListBox               : TOvcRVListBox;
    UpdateCount              : Integer;
    SaveCurItem              : Pointer;
    SaveFont                 : TFont;
    FAutoReset               : Boolean;
    FPrinting                : Boolean;
    FUserData                : Pointer;
    ViewDeleted              : Boolean;
    LoadingViews             : Boolean;
    Searching                : Boolean;
    procedure LockListPaint;
    procedure UnlockListPaint;
    procedure Click; override;
    procedure ColumnsChanged(Sender : TObject);
    function CompLineWidth2(PrintStartLeft, PrintStopRight: Integer): Integer;
    function CompLineWidth: Integer;
    function CountSelected(StopOnFirst: Boolean): Integer;
    { no longer in use:
    procedure CountSelection(Sender : TObject; Data : Pointer;
      var Stop : Boolean; UserData : Pointer);
    procedure CountSelection2(Sender: TObject; Data: Pointer;
      var Stop: Boolean; UserData: Pointer);
    !!.06 }
    procedure CreateParams(var Params: TCreateParams); override;
    function CreateViewCollection: TOvcRVViews; virtual;
    function CreateListBox: TOvcRVListBox;      virtual;
    function CreateHeader: TOvcRVHeader;        virtual;
    function CreateFooter: TOvcRVFooter;        virtual;
    procedure CreateWnd; override;
    procedure DblClick; override;
    procedure DoBusy(SetOn : Boolean); virtual;
    procedure DoDetail(Data: Pointer); virtual;
    procedure DoChangeNotification(Event : TRvChangeEvent);
    function DoCompareFields(Data1, Data2: Pointer; FieldIndex: Integer) : Integer; override;
    procedure DoDrawViewField(Canvas : TCanvas; Data : Pointer;
      Field : TOvcRvField; ViewField : TOvcRvViewField; TextAlign : Integer;
      IsSelected, IsGroup : Boolean;
      ViewFieldIndex : Integer; Rect : TRect; const Text, TruncText : string); virtual;
    procedure DoEnumEvent(Data : Pointer; var Stop : boolean; UserData : Pointer); override;
    function DoFilter(View: TOvcAbstractRvView; Data: Pointer): Boolean; override;
    function DoGetFieldAsFloat(Data: Pointer; Field: Integer) : Double; override;
    procedure DoHeaderFooter(Canvas: TCanvas; var CurY: Integer; LineHeight: Integer; const IsHeader : Boolean);
    procedure DoSectionHeader(Canvas: TCanvas; var CurY: Integer; LineHeight, VPage,
      PrintStartLeft: Integer);
    procedure DoKeySearch(FieldIndex : Integer;const SearchString : string); virtual;
    procedure DoLinesChanged(LineDelta: Integer; Offset: Integer); override;
    procedure DoLinesWillChange; override;
    procedure DoSortingChanged; override;
    function GetColumn(Index : Integer) : TOvcRvField;
    function GetColumnResize : Boolean;
    function GetCurrentGroup : TOvcRvIndexGroup;
    function GetCurrentItem : Pointer;
    function GetField(Index : Integer) : TOvcRvField;
    function GetFieldClassType : TOvcCollectibleClass; virtual;
    function GetFields: TOvcRvFields;
    procedure SetFields(const Value: TOvcRvFields);
    function GetDesigning: Boolean;
    procedure SetDesigning(const Value: Boolean);
    function GetViewClassType: TOvcCollectibleClass; virtual;
    function GetViews: TOvcRvViews;
    procedure SetViews(const Value: TOvcRvViews);
    function GetGridLines : TOvcRVGridLines;
    function DoGetGroupString(ViewField : TOvcRvViewField; GroupRef : TOvcRvIndexGroup) : string; virtual;
    function GetHaveSelection : Boolean; virtual;
    function GetSelectionCount: Integer; virtual;
    function GetIsGrouped : Boolean;
    function GetHeaderImages: TImageList;
    procedure SetHeaderImages(const Value: TImageList);
    function GetMultiSelect : Boolean;
    function GetOnKeyUp : TKeyEvent;
    function GetOnKeyDown : TKeyEvent;
    function GetOnMouseDown : TMouseEvent;
    function GetOnMouseMove : TMouseMoveEvent;
    function GetOnMouseUp : TMouseEvent;
    function GetPageNumber: Integer;
    function GetPopup : TPopupMenu;
    function GetPrinting: Boolean;
    function GetPrintAreaHeight: Integer;
    function GetPrintAreaWidth: Integer;
    function GetPrintPageHeight: Integer;
    function GetPrintPageWidth: Integer;
    function GetPrintStartLeft: Integer;
    function GetPrintStartTop: Integer;
    function GetPrintStopBottom: Integer;
    function GetPrintStopRight: Integer;
    function GetSmoothScroll : Boolean;
    function GetSortColumn : Integer;
    function GetSortDescending : Boolean;
    function GetView(Index : Integer) : TOvcRVView;
    function CompareValues(Data1, Data2: Pointer;
      FieldIndex: Integer): Integer;
    {procedure HideHint;}
    {procedure HoverTimerEvent(Sender : TObject; Handle : Integer;
                       Interval : Cardinal; ElapsedTime : Integer);}
    procedure InternalBeginUpdate(LockIndexer : Boolean);
    procedure InternalEndUpdate(UnlockIndexer : Boolean);
    procedure ListDblClick(Sender : TObject);
    procedure ListKeyPress(Sender: TObject; var Key: Char);
    procedure LoadColumnWidths;
    procedure Loaded; override;
    function LockUpdate : Boolean;
    procedure MakeGroupVisible(GRef : TOvcRvIndexGroup);
    procedure WMMakeGroupVisible(var Msg : TMessage); message OM_MAKEGROUPVISIBLE;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PHResize(Sender : TObject);
    procedure PFResize(Sender : TObject);
    procedure AncestorNotFound(Reader: TReader;
      const ComponentName: string; ComponentClass: TPersistentClass;
      var Component: TComponent);
    procedure ReadState(Reader: TReader); override;
    procedure RecalcWidth;
    procedure BeginPrint(PrintMode : TRVPrintMode; SelectedOnly : Boolean);
    procedure EndPrint(PrintMode : TRVPrintMode);
    function CalcHLinesNet: Integer;
    function CalcHPages(const SelectedOnly: Boolean; const
      LinesPerPage: Integer): Integer;
    procedure DoLine(Canvas: TCanvas; var CurY: Integer; LineHeight, VPage,
      Line, PrintStartLeft: Integer);
    procedure DoSectionFooter(Canvas: TCanvas; var CurY: Integer;
      LineHeight, VPage, PrintStartLeft: Integer);
    function AdvancePage(Canvas: TCanvas; var CurY: Integer; LineHeight,
      VPage, RenderPage: Integer; var Abort: Boolean; PrintStartLeft: Integer): Integer;
    function RenderPageBlock(Canvas: TCanvas;
      const LineHeight, LinesPerPage, VPage, HPage: Integer;
      AdvancePage: TAdvancePageMethod; PageNumber: TGetPageNumberMethod;
        var LinesLeft, CurY: Integer; PrintStartLeft: Integer): Boolean;
    procedure ResizeColumn;
    procedure InitScrollInfo;
    procedure HScrollPrim(Delta : Integer);
    procedure LoadCustomViews;
    function PaintCell(Canvas: TCanvas; CurY: Integer; Data: Pointer;
      const S: string; Cell: TOvcRvViewField; Left: Integer; BottomLine,
      TopLine, PaintIt, Clip, Last: Boolean; ImageIndex,
      LineHeight: Integer): Integer;
    procedure PaintString(Canvas: TCanvas; CurY, LineHeight: Integer; S: string; Alignment: TAlignment; Left,
      Right: Integer; const Attr: TFontStyles);
    procedure SaveDirtyViews;
    procedure ScaleColumn(C: Integer);
      {- Adjusts single column width according to contents}
    procedure ScaleColumnWidthsForPrint;
      {- Adjusts column widths according to content.}
    procedure SetHScrollPos;
    procedure SetHScrollRange;
    procedure WMHScroll(var Msg : TWMHScroll); message WM_HScroll;
    procedure SetActiveView(const Value : string);
    procedure SetActiveViewByTitle(const Value : string);
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetColumnResize(Value : Boolean);
    {procedure SetController(Value : TOvcController); override;}
    procedure SetDragMode(Value: TDragMode); override;
    procedure SetCurrentItem(Value : Pointer);
    procedure SetGridLines(Value : TOvcRVGridLines);
    procedure SetGroupColor(Value: TColor);
    procedure SetHideSelection(const Value : Boolean);
    procedure SetMultiSelect(Value : Boolean);
    procedure SetOnKeyUp(Value : TKeyEvent);
    procedure SetOnKeyDown(Value : TKeyEvent);
    procedure SetOnMouseDown(Value : TMouseEvent);
    procedure SetOnMouseMove(Value : TMouseMoveEvent);
    procedure SetOnMouseUp(Value : TMouseEvent);
    procedure SetOptions(const Value: TOvcRVOptions);
    procedure SetPopupMenu(Value : TPopupMenu);
    procedure SetScrollBars(const Value : TScrollStyle);
      {-set use of vertical and horizontal scroll bars}
    procedure SetSmoothScroll(Value : Boolean);
    procedure SetSortColumn(Value : Integer);
    procedure SetSortDescending(Value : Boolean);
    procedure SetWidthChanged(Value : Boolean);
    procedure StoreColumnWidths;
    function PixelsToTwips(T: Integer): Integer;
    function TwipsToPixels(T: Integer): Integer;
    property WidthChanged : Boolean read FWidthChanged write SetWidthChanged;
    procedure WMEraseBkgnd(var Msg : TWMEraseBkgnd);
      message WM_ERASEBKGND;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMKillFocus(var Msg : TWmKillFocus);
      message WM_KILLFOCUS;

    property OnCompareFields : TOvcRVCompareFieldsEvent
                   read FOnCompareFields write FOnCompareFields;
      {- Event generated by the report view when it needs to compare
         items}
    property OnDrawViewField : TOvcDrawViewFieldEvent
                   read FOnDrawViewField write FOnDrawViewField;
      {- Event generated by the report view for view fields that have
         their OwnerDraw property set to True}
    property OnDrawViewFieldEx : TOvcDrawViewFieldExEvent
                   read FOnDrawViewFieldEx write FOnDrawViewFieldEx;
    property OnEnumerate : TOvcRVEnumEvent
                   read FOnEnumerate write FOnEnumerate;
      {- Event generated for each item when the Enumerate method is
         called}
    property OnFilter: TOvcRVFilterEvent
                   read FOnFilter write FOnFilter;
      {- Event generated when the index is maintained for views that
         have a FilterIndex <> -1}
    property OnGetFieldAsFloat : TOvcRVGetFieldAsFloatEvent
                   read FOnGetFieldAsFloat write FOnGetFieldAsFloat;
      {- Event generated by the report view for fields that have their
         ComputeTotals property set to True}
    property OnGetFieldValue: TOvcRVGetFieldValueEvent
                   read FGetFieldValue write FGetFieldValue;
    property OnGetGroupTotal: TOvcRvGetGroupTotalEvent
                   read FOnGetGroupTotal write FOnGetGroupTotal;
    property OnGetFieldAsString : TOvcRVGetFieldAsStringEvent
                   read FOnGetFieldAsString write FOnGetFieldAsString;
      {- Event generated by the report view to get a text rendition of
         a field}
    property OnGetGroupString : TOvcRVGetGroupStringEvent
                   read FOnGetGroupString write FOnGetGroupString;
      {- Event generated by the report view to get a text rendition of
         a group string - typically a total.}
    property OnKeySearch : TOvcKeySearchEvent
                   read FOnKeySearch write FOnKeySearch;
      {- Event generated when the user types in the report view -
         if the KeySearch property is set to True.}
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AssignStructure(Source: TOvcCustomReportView); virtual;
      {- replace all fields and views from another report view}
    property Designing: Boolean read GetDesigning write SetDesigning;
    property InternalHeader : TOvcRVHeader read FRVHeader;
    property InternalFooter : TOvcRVFooter read FRVFooter;
    property InternalListBox : TOvcRVListBox read FRVListbox;
    property PrintPageWidth: Integer read GetPrintPageWidth;
    property PrintPageHeight: Integer read GetPrintPageHeight;
    property PrintStartLeft: Integer read GetPrintStartLeft;
    property PrintStopRight: Integer read GetPrintStopRight;
    property PrintStartTop: Integer read GetPrintStartTop;
    property PrintStopBottom: Integer read GetPrintStopBottom;
    property PrintAreaWidth: Integer read GetPrintAreaWidth;
    property PrintAreaHeight: Integer read GetPrintAreaHeight;
    function RenderPageSection(Canvas: TCanvas; const SelectedOnly: Boolean;
      const LineHeight, LinesPerPage, VPage, HPage: Integer; ScaleFonts: Boolean): Boolean;
    procedure ReplaceView(const Name: string; NewDefinition: TOvcRvView);
      {- replace a specific view from another report view}
    procedure SaveViewToStorage(
      Storage: TOvcAbstractStore; View: TOvcRvView);
      {- save a view definition in a storage container}
    function UniqueViewNameFromTitle(const Title: string): string;



    procedure ScaleColumnWidths;
      {- Adjusts column widths according to content.}
    class procedure StretchDrawImageListImage(Canvas: TCanvas;
      ImageList: TImageList; TargetRect: TRect; ImageIndex: Integer;
      PreserveAspect: Boolean);
    procedure BeginUpdate;
      {- Begin several changes (Add/Change/Remove) must be matched with
         a call to EndUpdate}
    procedure CenterCurrentLine;
      {- center the currently selected line (if any) on screen}
    function ColumnFromOffset(XOffset : Integer) : TOvcRvField;
    function DataCount: Integer;
    function EditNewView(const Title: string): Boolean;
    function EditCurrentView: Boolean;
    function EditCopyOfCurrentView: Boolean;
    function EditCalculatedFields: Boolean;
    procedure EndUpdate;
      {- Ends update block started with BeginUpdate}
    procedure Enumerate(UserData : Pointer); virtual;
      {- Enumerate all items in the view. Pass UserData to OnEnumerate}
    procedure EnumerateSelected(UserData : Pointer); virtual;
      {- Enumerate all selected items in the view.
        Pass UserData to OnEnumerate}
    procedure EnumerateEx(Backwards, SelectedOnly: Boolean; StartAfter: Pointer;
      UserData : Pointer); virtual;
      {- Enumerates items in the view. If SelectedOnly is true, only
         selected items are returned (assumes MultiSelect=True). Passes UserData
         to OnEnumerate. If StartAt is not NIL, no items are returned until
         StartAfter is seen. The StartAfter item itself is not returned.}
    property Fields: TOvcRvFields
                   read GetFields write SetFields;
    function Focused: Boolean; override;
    function GetGroupElement(G: TOvcRvIndexGroup): Pointer;
    procedure GotoNearest(DataRef: Pointer);
      {- Select new CurrentItem based on DataRef and the currently
         selected sort column.}
    function ItemAtPos(Pos : TPoint) : Pointer;
      {- Return Item at Pos in embedded listbox. Typically used with
         popup menus}
    procedure Navigate(NewPosition : TRvCurrentPosition);
    procedure Print(PrintMode : TRVPrintMode; SelectedOnly : Boolean);
      {- Print the current view on the default printer}
    procedure PrintPreview(PrintMode : TRVPrintMode; SelectedOnly : Boolean);
    procedure RebuildIndexes;
    procedure RegisterChangeNotification(ClientMethod : TRVNotifyEvent);
      {- Support method for controls that list views }
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UnRegisterChangeNotification(ClientMethod : TRVNotifyEvent);
      {- Support method for controls that list views }
    function ViewNameByTitle(const Value : string) : string;
      {- returns the name of a view with a given title - or '' if not found}
    property ActiveView : string
                   read FActiveView write SetActiveView;
      {- The name of the currently active view}
    property ActiveViewByTitle : string
                   read FActiveViewByTitle write SetActiveViewByTitle;
      {- The title of the currently active view}
    property AutoCenter : Boolean
                   read FAutoCenter write FAutoCenter default False;
    property AutoReset : Boolean
                   read FAutoReset write FAutoReset default False;
    property BorderStyle : TBorderStyle
                   read FBorderStyle write SetBorderStyle
                   default bsNone;
      {- bsNone or bsSingle}
    property ColumnResize : Boolean
                   read GetColumnResize write SetColumnResize default True;
      {- Controls whether the user can change the width of columns at
         run-time}
    property CurrentGroup : TOvcRvIndexGroup
                   read GetCurrentGroup;
    property CurrentItem : Pointer
                   read GetCurrentItem write SetCurrentItem;
      {- The currently selected item. NIL if no item is currently
         selected.}
    property CurrentView : TOvcRVView
                   read FCurrentView;
      {- The current view object}
    property CustomViewStore : TOvcAbstractStore
                   read FCustomViewStore write FCustomViewStore;
    property Field[Index : Integer] : TOvcRvField
                   read GetField;
    property FieldWidthStore : TOvcAbstractStore
                   read FFieldWidthStore write FFieldWidthStore;
    property GridLines : TOvcRVGridLines
                   read GetGridLines write SetGridLines default glNone;
    property GroupColor : TColor
                   read FGroupColor write SetGroupColor default clBtnFace;
      {- Whether divider lines are painted between cells}
    property HaveSelection : Boolean
                   read GetHaveSelection;
    property HeaderImages: TImageList read GetHeaderImages write SetHeaderImages;
    property HideSelection : Boolean
                   read FHideSelection write SetHideSelection
                   default False;
    function IsEmpty : Boolean;
    property IsGrouped : Boolean
                   read GetIsGrouped;
      {- Whether the current view contains grouped columns}
    property KeySearch : Boolean
                   read FKeySearch write FKeySearch
                   default False;
      {- Enable/disable key search. Requires an OnKeySearch event to be
         assigned as well.}
    property KeyTimeout : Integer
                   read FKeyTimeout write FKeyTimeout
                   default rvDefKeyTimeout;
    property MultiSelect : Boolean
                   read GetMultiSelect write SetMultiSelect
                   default False;
      {- Controls whether the user can select multiple lines at once.}
    property Options : TOvcRVOptions
      read FOptions write SetOptions;
    property PageNumber : Integer
                   read FPageNumber;
      {- During printing, this returns the current page number.}
    property PageCount: Integer
                   read FPPageCount;
      {- During printing, this returns the page count.}
    property PopupMenu : TPopupMenu
                   read GetPopup write SetPopupMenu;
    property PrinterProperties : TOvcRvPrintProps
                   read FPrinterProperties write FPrinterProperties;
      {- Properties related to the Print method.}
    property Printing : Boolean
                   read FPrinting;
    property PrintDetailView: TOvcCustomReportView
                   read FPrintDetailView write FPrintDetailView;
    property ScrollBars : TScrollStyle
                   read FScrollBars write SetScrollBars default ssVertical;
    property SelectionCount : Integer read GetSelectionCount;
    property SmoothScroll : Boolean
                   read GetSmoothScroll write SetSmoothScroll default True;
      {- Controls whether the contained ListBox should use smooth
         scrolling}
    property SortColumn : Integer
                   read GetSortColumn write SetSortColumn;
    property SortDescending : Boolean
                   read GetSortDescending write SetSortDescending;
      {- The current sort column}
    property UserData: Pointer read FUserData write FUserData;
    property View[Index : Integer] : TOvcRVView
                   read GetView;
    property Views: TOvcRvViews read GetViews write SetViews;
      {- The defined views}
    property OnGetPrintHeaderFooter : TOvcGetPrintHeaderFooterEvent
                   read FOnGetPrintHeaderFooter write FOnGetPrintHeaderFooter;
      {- Event generated during printing to obtain optional header/
        footer information}
    property OnPrintStatus : TOvcPrintStatusEvent
                   read FOnPrintStatus write FOnPrintStatus;
      {- Event generated for each page during printing. Can be used to
         implement a print status dialog.}
    property OnSignalBusy : TOvcRvSignalBusyEvent
                   read fOnSignalBusy write fOnSignalBusy;
      {- Event generated by the report view before and after
         potentially lengthy operations. Can be used to change the
         cursor into an hourglass.}
    property OnViewSelect : TNotifyEvent
                   read FOnViewSelect write FOnViewSelect;
    {inherited events}
    property OnClick : TNotifyEvent
                   read FOnClick write FOnClick;
    property OnDetailPrint: TNotifyEvent
                   read FDetailPrint write FDetailPrint;
    property OnDblClick : TNotifyEvent
                   read FOnDblClick write FOnDblClick;
    property OnKeyDown
                   read GetOnKeyDown write SetOnKeyDown;
    property OnKeyPress: TKeyPressEvent
                   read FOnKeyPress write FOnKeyPress;
    property OnKeyUp
                   read GetOnKeyUp write SetOnKeyUp;
    property OnMouseDown : TMouseEvent
                   read GetOnMouseDown write SetOnMouseDown;
    property OnMouseMove : TMouseMoveEvent
                   read GetOnMouseMove write SetOnMouseMove;
    property OnMouseUp : TMouseEvent
                   read GetOnMouseUp write SetOnMouseUp;
    property OnSortingChanged : TNotifyEvent
                   read FOnSortingChanged write FOnSortingChanged;
  end;

  TOvcReportView = class(TOvcCustomReportView)
  public
    procedure AddData(const Data : Pointer);
      {- Add one record to the index}
    procedure ChangeData(const Data : Pointer);
      {- Change one record in the index}
    procedure RemoveData(const Data : Pointer);
      {- Remove one record from the index}
    procedure Clear;
      {- Clear all item data from all views.}
  published
    property Anchors;
    property Constraints;
    property DragKind;
    property ActiveView;
    property Align;
    property AutoCenter;
    property BorderStyle;
    property Ctl3D;
    property ColumnResize;
    property Controller;
    property CustomViewStore;
    property DragMode;
    property Enabled;
    property Fields;
    property FieldWidthStore;
    property Font;
    property GridLines;
    property GroupColor;
    property HeaderImages;
    property HideSelection;
    property KeySearch;
    property KeyTimeout;
    property MultiSelect;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PrinterProperties;
    property ScrollBars;
    property ShowHint default True;
    property SmoothScroll;
    property TabOrder;
    property TabStop;
    property Views;
    property Visible;

    property OnClick;
    property OnCompareFields;
    property OnDblClick;
    property OnDetailPrint;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawViewField;
    property OnDrawViewFieldEx;
{
  Fix for problem 1055662 - OnEndDrag missing
  The OnEndDrag event was missing from the reportview. It was just not
  published so this should help.
}
    property OnEndDrag;
    property OnEnter;
    property OnEnumerate;
    property OnExit;
    property OnExtern;
    property OnFilter;
    property OnGetFieldAsFloat;
    property OnGetGroupTotal;
    property OnGetFieldAsString;
    property OnGetFieldValue;
    property OnGetGroupString;
    property OnGetPrintHeaderFooter;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnKeySearch;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPrintStatus;
    property OnSelectionChanged;
    property OnSignalBusy;
    property OnSortingChanged;
    property OnStartDrag;
    property OnViewSelect;
  end;

function CompareInt(I1,I2 : Integer) : Integer;
{ compare two integers, return negative, 0 and positive value for I1<I2, I1=I2 and I1>I2 resp.}
function CompareFloat(F1,F2 : Extended) : Integer;
{ compare two doubles, return -1, 0 and 1 for F1<F2, F1=F2 and F1>F2 resp.}
function CompareComp(F1,F2 : comp) : Integer;
{ compare two comps, return -1, 0 and 1 for F1<F2, F1=F2 and F1>F2 resp.}



implementation
uses
  OvcCoco,
  OvcRvExp,
  Printers,
  OvcViewEd,
  OvcFldEd,
  OvcRvPv,
  OVCStr;

const
  {Image list indices:}
  UpArrow = 0;
  DownArrow = 1;
  PlusSign = 0;
  MinusSign = 1;

type
  TChangeNotification = class
  public
    Event : TRVNotifyEvent;
    constructor Create(AnEvent : TRVNotifyEvent);
  end;

constructor TChangeNotification.Create(AnEvent : TRVNotifyEvent);
begin
  Event := AnEvent;
end;

var
  BrushBitmap : TBitmap;
  HeaderGlyphList : TImageList;

function CompareInt(I1,I2 : Integer) : Integer;
{ compare two integers, return -1, 0 and 1 for I1<I2, I1=I2 and I1>I2 resp.}
asm
  sub eax, edx
end;

function CompareFloat(F1,F2 : Extended) : Integer;
{ compare two doubles, return -1, 0 and 1 for F1<F2, F1=F2 and F1>F2 resp.}
begin
  if F1 < F2 then
    Result := -1
  else
  if F1 = F2 then
    Result := 0
  else
    Result := 1;
end;

function CompareComp(F1,F2 : Comp) : Integer;
{ compare two doubles, return -1, 0 and 1 for F1<F2, F1=F2 and F1>F2 resp.}
begin
  if F1 < F2 then
    Result := -1
  else
  if F1 = F2 then
    Result := 0
  else
    Result := 1;
end;

procedure TOvcRVHeader.Paint;
begin
  if not TOvcCustomReportView(Owner).LockUpdate then
    inherited Paint;
end;

procedure TOvcRVHeader.SetSortGlyph;
var
  i : Integer;
begin
  for i := 0 to SectionCount - 1 do
    with Section[i] do
      ImageIndex := -1;
  if Sections.Count = 0 then exit;
  with TOvcCustomReportView(Owner) do begin
    if InternalSortColumn = 0 then exit;
    if InternalSortColumn > 0 then
      Section[InternalSortColumn-1].ImageIndex := UpArrow
    else
      Section[abs(InternalSortColumn)-1].ImageIndex := DownArrow
  end;
end;

procedure TOvcRVHeader.DoOnClick;
{changes sorting when clicked, where appropriate}
begin
  with TOvcCustomReportView(Owner) do
    if not Focused and CanFocus then
      Windows.SetFocus(Handle);
  if (ItemIndex <> -1) then begin
    with TOvcCustomReportView(Owner) do if (CurrentView <> nil) then
      with CurrentView.ViewField[ItemIndex] do begin
      {Indexer sortcolumn is bumped by one}
        if Field.CanSort then begin
          if abs(InternalSortColumn) - 1 = Index then
            {column didn't change}
            case SortDirection of
            rfsFirstAscending,
            rfsFirstDescending :
              InternalSortColumn := -InternalSortColumn { toggle asc/desc}
            else
              ; {no action}
            end
          else
            {new column}
            case SortDirection of
            rfsFirstAscending,
            rfsAlwaysAscending :
              InternalSortColumn := Index + 1;
            rfsFirstDescending,
            rfsAlwaysDescending :
              InternalSortColumn := -(Index + 1);
            end;
          SetSortGlyph;
        end;
      end;
    inherited DoOnClick;
  end;
end;

procedure TOvcRVHeader.DblClick;
{sizes column on dbl-click}
var
  I : Integer;
begin
  inherited DblClick;
  I := ResizeSection;
  if I = -1 then exit;
  TOvcCustomReportView(Owner).ScaleColumn(I);
end;

function TOvcRVHeader.DoRearranging(OldIndex, NewIndex: Integer): Boolean;
begin
  if TOvcCustomReportView(Owner).CurrentView.ViewField[OldIndex].GroupBy
  or TOvcCustomReportView(Owner).CurrentView.ViewField[NewIndex].GroupBy then
    Result := False
  else
    Result := inherited DoRearranging(OldIndex, NewIndex);
end;

procedure TOvcRVHeader.DoRearranged(OldIndex, NewIndex: Integer);
begin
  inherited;
  InRearrange := True;
  try
    TOvcCustomReportView(Owner).CurrentView.ViewField[OldIndex].Index := NewIndex;
  finally
    InRearrange := False;
  end;
end;

procedure TOvcRVHeader.HideShowSizer(Position: Integer);
var
  OldPen : TPen;
begin
  with TOvcRVListBox(ListBox).Canvas do begin
    OldPen := TPen.Create;
    try
      OldPen.Assign(Pen);
      try
        Pen.Mode := pmXor;
        Pen.Style := psSolid;
        Pen.Color := clWhite;
        Pen.Width := 2;
        MoveTo(Position - 1, 0);
        LineTo(Position - 1, TOvcRVListBox(ListBox).ClientHeight);
        LastOffset := Position;
      finally
        Canvas.Pen := OldPen;
      end;
    finally
      OldPen.Free;
    end;
  end;
end;

procedure TOvcRVHeader.ShowSizer(ASection : Integer);
var
  i, MoveOffset : Integer;
begin
  if not ShowingSizer then begin
    MoveOffset := 0;
    for i := 0 to ASection do
      inc(MoveOffset, Section[i].Width);
    dec(MoveOffset,   TOvcCustomReportView(Owner).HScrollDelta);

    HideShowSizer(MoveOffset);
    ShowingSizer := True;
  end;
end;

procedure TOvcRVHeader.HideSizer;
begin
  if ShowingSizer then begin
    HideShowSizer(LastOffset);
    ShowingSizer := False;
  end;
end;

procedure TOvcRVHeader.DoOnSizing(ASection, AWidth : Integer);
begin
  HideSizer;
  inherited DoOnSizing(ASection,AWidth);
  ShowSizer(ASection);
end;

procedure TOvcRVHeader.DoOnSized(ASection, AWidth : Integer);
{resizes list view columns after header has been resized}
begin
  HideSizer;
  inherited DoOnSized(ASection,AWidth);
  TOvcRVListBox(ListBox).Invalidate;
  TOvcCustomReportView(Owner).ResizeColumn;
  TOvcCustomReportView(Owner).RecalcWidth;
end;

procedure TOvcRVHeader.Reload;
{reloads the button header contents from the view field definition}
var
  C : TOvcRvViewField;
  i : Integer;
begin
  if InRearrange then
    exit;
  Hint := TOvcCustomReportView(Owner).Hint;
  Sections.Clear;
  with TOvcCustomReportView(Owner) do begin
    if CurrentView = nil then exit;
    for i := 0 to pred(CurrentView.ViewFields.Count) do begin
      C := CurrentView.ViewField[i];
      if (C <> nil) and (C.FField <> nil) then
        with TOvcButtonHeaderSection(Sections.Add) do begin
          if C.GroupBy and not C.OwnerReport.Options.ShowGroupCaptionInHeader then
            Caption := ''
          else
            Caption := C.Field.Caption;
          Hint := C.Field.Hint;
          Width := C.Width;
          Alignment := C.Field.Alignment;
          AllowResize := C.AllowResize;
          LeftImageIndex := C.Field.ImageIndex;
        end;
    end;
  end;
  Invalidate;
end;

procedure TOvcRVFooter.Paint;
begin
  if not TOvcCustomReportView(Owner).LockUpdate then
    inherited Paint;
end;

procedure TOvcRVFooter.UpdateSections;
{updates the footer from the view field definition}
var
  C : TOvcRvViewField;
  i : Integer;
begin
  if not Visible then exit;
  with TOvcCustomReportView(Owner) do begin
    if CurrentView = nil then exit;
    for i := 0 to pred(CurrentView.ViewFields.Count) do begin
      C := CurrentView.ViewField[i];
      if i < Sections.Count then
        with Section[i] do begin
          if C.ComputeTotals then
            Caption := DoGetGroupString(C, TotalRef)
          else
            Caption := '';
          Width := C.Width;
          Alignment := C.Field.Alignment;
        end;
    end;
  end;
end;

procedure TOvcRVFooter.Reload;
{reloads the footer contents from the view field definition}
var
  C : TOvcRvViewField;
  i : Integer;
begin
  if not Visible then exit;
  Sections.Clear;
  with TOvcCustomReportView(Owner) do begin
    if CurrentView = nil then exit;
    for i := 0 to pred(CurrentView.ViewFields.Count) do begin
      C := CurrentView.ViewField[i];
      with TOvcButtonHeaderSection(Sections.Add) do begin
        if C.ComputeTotals then
          Caption := DoGetGroupString(C, TotalRef)
        else
          Caption := '';
        Width := C.Width;
        Alignment := C.Field.Alignment;
      end;
    end;
  end;
  Invalidate;
end;

constructor TOvcRVListBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  lVMargin := 3;
  ShowHint := True;
  FSelectColor  := TOvcRvListSelectColors.Create(vlDefSelectText, vlDefSelectBack);
  FSelectColor.OnColorChange := vlbColorChanged;
end;

destructor TOvcRVListBox.Destroy;
begin
  LineCanvas.Free;
  inherited Destroy;
  FSelectColor.Free;
end;

procedure TOvcRVListBox.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  TOvcCustomReportView(Owner).DoEndDrag(Target, X, Y);
end;

procedure TOvcRVListBox.DoStartDrag(var DragObject: TDragObject);
begin
  TOvcCustomReportView(Owner).DoStartDrag(DragObject);
end;

procedure TOvcRVListBox.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source is TOvcRVListBox then
    Source := TOvcRVListBox(Source).Owner;
  TOvcCustomReportView(Owner).DragOver(Source, X, Y, State, Accept);
end;

procedure TOvcRVListBox.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Source is TOvcRVListBox then
    Source := TOvcRVListBox(Source).Owner;
  TOvcCustomReportView(Owner).DragDrop(Source, X, Y);
end;

function TOvcRVListBox.DoOnIsSelected(Index: Integer): Boolean;
begin
  if csDesigning in ComponentState then
    Result := False
  else begin
    Result := (Index = FItemIndex);
    if FMultiSelect then
      Result := ReportView.IsSelected[Index];
    if Result and ReportView.HideSelection and not Focused then
      Result := False;
  end;
end;

procedure TOvcRVListBox.vlbCalcFontFields;
{changes line-height based on changed font size}
begin
  inherited vlbCalcFontFields;
  if ReportView.Options.HeaderAutoHeight then
    RVHeader.Height := ReportView.Options.HeaderLines*RowHeight + 2
  else
    RVHeader.Height := ReportView.Options.HeaderHeight;
  ReportView.HeaderPanel.Height := RVHeader.Height;
  if ReportView.Options.FooterAutoHeight then
    RVFooter.Height := RowHeight + 2
  else
    RVFooter.Height := ReportView.Options.FooterHeight;
  ReportView.FooterPanel.Height := RVFooter.Height;
end;

procedure TOvcRVListBox.vlbDrawFocusRect(Canvas : TCanvas; Left, Right : Integer; Index : Integer);
  {-draw the focus rectangle}
var
  CR : TRect;
begin
  if Index < 0 then
    Index := 0;
  if Focused then begin
    if (Index >= FTopIndex) and (Index-FTopIndex <= Pred(lRows)) then begin
      CR.Right := Right; {ClientWidth - 1;}
      CR.Left := Left;
      CR.Top := 0;
      CR.Bottom := CR.Top + FRowHeight;
      Canvas.DrawFocusRect(CR);
    end;
  end;
  lFocusedIndex := Index;
end;

procedure TOvcRVListBox.SetGridLines(Value : TOvcRVGridLines);
{Set method for the GridLines property}
begin
  if Value <> FGridLines then begin
    FGridLines := Value;
    Invalidate;
  end;
end;

procedure TOvcRVListBox.SetMultiSelect(Value : Boolean);
{Set method for the MultiSelect property - overrides the behavior in the base ListBox}
begin
  if Value <> FMultiSelect then
    FMultiSelect := Value;
end;

procedure TOvcRVListBox.DrawItem(Canvas : TCanvas; Data : Pointer; const Rect : TRect;
  FGColor : TColor; BGColor : TColor; IsSelected : Boolean);
{Draws a non-group item}
var
  R,R2 : TRect;
  ViewFieldIndex, W, AL, L, Stop : Integer;
  S, S2 : string;
  P : PChar;
  CurCol : TOvcRvViewField;
  CurField : TOvcRvField;
begin
  ViewFieldIndex := 0;
  R := Rect;
  R.Left := 1;
  Stop := RVHeader.Sections.Count;
  while (ViewFieldIndex < Stop) do begin
    W := RVHeader.Section[ViewFieldIndex].Width;
    CurCol := ReportView.CurrentView.ViewField[ViewFieldIndex];
    R.Right := R.Left + W - RVHeader.TextMargin;
    if CurCol.GroupBy then
      begin
        Canvas.Brush.Color := ReportView.GroupColor;
        R2 := R;
        InflateRect(R2, 1, 1);
        Canvas.FillRect(R2);
        Canvas.Brush.Color := BGColor;
      end
    else
      begin
        if ReportView.Options.HeaderDrawingStyle <> bhsFlat then
          dec(R.Right);
        Canvas.Brush.Color := BGColor;
        CurField := TOvcRvField(CurCol.Field);
        case CurField.Alignment of
          taLeftJustify  : AL := DT_LEFT;
          taRightJustify : AL := DT_RIGHT;
          taCenter       : AL := DT_CENTER;
        else
          AL := 0;
        end;
        AL := AL or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
        R2 := R;
        if ReportView.Options.ListBorderStyle = bsNone then begin
          inc(R2.Left, 2);
          dec(R2.Right, 4);
        end else
          dec(R2.Right, 6);
        if CurField = nil then
          S := ''
        else
          S := CurField.AsString(Data);
        Canvas.Font.Color := FGColor;
        if (S <> '') then
          S2 := GetDisplayString(Canvas, S, 1, R2.Right-R2.Left)
        else
          S2 := '';
        L := length(S2);
        P := pChar(S2);
        if CurCol.OwnerDraw then
          ReportView.DoDrawViewField(Canvas, Data, CurField, CurCol, AL,
          IsSelected, False, ViewFieldIndex, R2, S, S2)
        else
          DrawText(Canvas.Handle, P, L, R2, AL);
        if (GridLines in [glVertical,glBoth]) then begin
          Canvas.Brush.Bitmap := BrushBitmap;
          Canvas.FillRect(Classes.Rect(R.Right-2,R.Top,R.Right-1,R.Bottom));
        end;
        Canvas.Brush.Color := BGColor;
        if ReportView.Options.HeaderDrawingStyle <> bhsFlat then
          inc(R.Right);
      end;
    R.Left := R.Right + 1;
    if CurCol.GroupBy then
      FocusLeft := R.Left;
    Inc(ViewFieldIndex);
  end;
  if GridLines in [glHorizontal,glBoth] then begin
    Canvas.Brush.Bitmap := BrushBitmap;
    Canvas.FillRect(Classes.Rect(Rect.Left,Rect.Bottom-1,Rect.Right+1,Rect.Bottom));
  end;
end;

procedure TOvcRVListBox.DrawItemG(Canvas : TCanvas; Data : Pointer;
  const Rect : TRect; FGColor : TColor;BGColor : TColor;
  GroupRef : TOvcRvIndexGroup; IsSelected : Boolean);
{Draws a group item}
var
  ViewFieldIndex,W,AL,L : Integer;
  R,R2 : TRect;
  S, S2 : string;
  P : PChar;
  CurCol : TOvcRvViewField;
begin
  ViewFieldIndex := 0;
  R := Rect;
  R.Left := 1;
  while (ViewFieldIndex < RVHeader.Sections.Count) do begin
    W := RVHeader.Section[ViewFieldIndex].Width;
    CurCol := ReportView.CurrentView.ViewField[ViewFieldIndex];
    R.Right := R.Left + W - RVHeader.TextMargin;
    if not CurCol.GroupBy then
    if (CurCol.ComputeTotals) then
      begin
        case TOvcRvField(CurCol.Field).Alignment of
          taLeftJustify  : AL := DT_LEFT;
          taRightJustify : AL := DT_RIGHT;
          taCenter       : AL := DT_CENTER;
        else
          AL := 0;
        end;
        AL := AL or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
        R2 := R;
        inc(R2.Left, 2);
        if ReportView.Options.ListBorderStyle = bsNone then
          dec(R2.Right, 5)
        else
          dec(R2.Right, 7);
        S := ReportView.DoGetGroupString(CurCol, GroupRef);
        Canvas.Font.Color := FGColor;
        Canvas.Brush.Color := BGColor;
        if (S <> '') then
          S2 := GetDisplayString(Canvas,S,1,R2.Right-R2.Left)
        else
          S2 := '';
        L := length(S2);
        P := pChar(S2);
        if CurCol.OwnerDraw then
          ReportView.DoDrawViewField(Canvas, Data, CurCol.Field, CurCol, AL,
          IsSelected, True, ViewFieldIndex, R2, S, S2)
        else
          DrawText(Canvas.Handle, P, L, R2, AL);
        if not ReportView.IsGrouped and (GridLines in [glVertical,glBoth]) then begin
          Canvas.Brush.Bitmap := BrushBitmap;
          Canvas.FillRect(Classes.Rect(R.Right-1,R.Top,R.Right,R.Bottom));
        end;
        Canvas.Brush.Color := BGColor;
      end;
    R.Left := R.Right + 1;
    Inc(ViewFieldIndex);
  end;
end;

{ new}
function TOvcRVListBox.CalcMaxX: Integer;
{calculate horizontal pixel offset of first total column}
var
  ViewFieldIndex,W : Integer;
  RLeft: Integer;
  CurCol : TOvcRvViewField;
begin
  Result := MaxInt;
  ViewFieldIndex := 0;
  RLeft := 1;
  while (ViewFieldIndex < RVHeader.Sections.Count) do begin
    W := RVHeader.Section[ViewFieldIndex].Width;
    CurCol := ReportView.CurrentView.ViewField[ViewFieldIndex];
    if not CurCol.GroupBy and CurCol.ComputeTotals then
      begin
        Result := RLeft;
        exit;
      end;
    inc(RLeft, W - RVHeader.TextMargin + 1);
    Inc(ViewFieldIndex);
  end;
end;

procedure TOvcRVListBox.DrawGroupItem(Canvas : TCanvas; Data : Pointer; Group : Integer;
  Expanded : Boolean; const Rect : TRect; FGColor : TColor;BGColor : TColor; GroupRef : TOvcRvIndexGroup;
    IsSelected : Boolean; MaxX: Integer);
{draws a group line}
var
  R, BR : TRect;
  ViewFieldIndex, W, AL, L, BD : Integer;
  S, S2 : string;
  P : PChar;
  F : TOvcRvField;
  V : TOvcRvViewField;
const
  GlyphIdx : array[boolean] of Integer = (PlusSign, MinusSign);
begin
  ViewFieldIndex := 0;
  R := Rect;
  R.Left := 1;
  R.Right := MinI(R.Right, MaxX);

  while (ViewFieldIndex < RVHeader.Sections.Count) do begin
    W := RVHeader.Section[ViewFieldIndex].Width;
    if ViewFieldIndex = Group then
      begin

        BR.Left := R.Left + 2;
        BR.Top := R.Top + 2;
        BR.Bottom := R.Bottom - 2;
        BD := (BR.Bottom - BR.Top);
        BR.Right := BR.Left + BD;
        BD := BD div 2;

        DrawFrameControl(Canvas.Handle, BR, DFC_BUTTON, DFCS_BUTTONPUSH);

        AL := DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;

        Canvas.Pen.Color := clBtnText;
        Canvas.MoveTo(BR.Left + BD - 3,BR.Top + BD - 1);
        Canvas.LineTo(BR.Left + BD + 2,BR.Top + BD - 1);
        if not Expanded then begin
          Canvas.MoveTo(BR.Left + BD - 1,BR.Top + BD - 3);
          Canvas.LineTo(BR.Left + BD - 1,BR.Top + BD + 2);
        end;

        V := ReportView.CurrentView.ViewField[ViewFieldIndex];
        F := V.Field;

        if V.OwnerReport.Options.ShowGroupCaptionInList then begin
          S := F.Caption;
          if S <> '' then
            S := S + ' : ';
        end else
          S := '';

        S := S + F.AsString(Data);
        if ReportView.CurrentView.ShowGroupCounts then
          S := S + format(' (%d)', [ReportView.Count(GroupRef)]);
        Canvas.Brush.Color := BGColor;
        Canvas.Font.Color := FGColor;

        {if V.OwnerReport.Options.ShowGroupCaptionInList then
          R.Left := R.Left + W
        else}
          R.Left:=R.Left + BD * 2 + 4;

        if S <> '' then
          S2 := GetDisplayString(Canvas,S,1,R.Right-R.Left)
        else
          S2 := '';
        L := length(S2);
        P := pChar(S2);
        if V.OwnerDraw then
          ReportView.DoDrawViewField(Canvas, Data, F, V, AL,
          IsSelected, True, ViewFieldIndex, R, S, S2)
        else
          DrawText(Canvas.Handle, P, L, R, AL);
        if not V.OwnerReport.Options.ShowGroupCaptionInList then
          R.Left := R.Left + W - (BD * 2 + 4);
        break;
      end
    else
      R.Left := R.Left+W;
    Inc(ViewFieldIndex);
  end;
  if GridLines in [glHorizontal,glBoth] then begin
    Canvas.Brush.Bitmap := BrushBitmap;
    Canvas.FillRect(
      Classes.Rect(Rect.Left, Rect.Bottom - 2, Rect.Right + 1, Rect.Bottom - 1));
  end;
end;

procedure TOvcRVListBox.InternalDrawItem(N : Integer; const CR : TRect);
  {-Draw item N}
var
  FGColor : TColor;
  BGColor : TColor;
  Gr : Integer;
  Data : Pointer;
  GrRef : TOvcRvIndexGroup;
  CRWidth,CRHeight : Integer;
  CR2   : TRect;
  IsSelected : Boolean;
  HaveTotals: Boolean;
  MaxX: Integer;
begin
  CRWidth := ReportView.ClientWidth + ReportView.ClientExtra; {CR.Right - CR.Left + 1;}
  CRHeight := CR.Bottom - CR.Top + 1;

  if (LineCanvas <> nil) and ((LineCanvas.Width <> CRWidth) or (LineCanvas.Height <> CRHeight)) then begin
    LineCanvas.Free;
    LineCanvas := nil;
  end;
  if LineCanvas = nil then begin
    LineCanvas            := TBitMap.Create;
    LineCanvas.Width      := CRWidth;
    LineCanvas.Height     := CRHeight;
    LineCanvas.Canvas.Font := Self.Font;
    {we will erase our own background}
    SetBkMode(LineCanvas.Canvas.Handle, TRANSPARENT);
  end;

  {get colors}
  if DoOnIsSelected(N) {and (Row <= lRows)} then begin
    IsSelected := True;
    BGColor := FSelectColor.BackColor;
    FGColor := FSelectColor.TextColor;
  end else begin
    IsSelected := False;
    BGColor := Color;
    FGColor := Font.Color;
    DoOnGetItemColor(N, FGColor, BGColor);
  end;

  {assign colors to our canvas}
  LineCanvas.Canvas.Brush.Color := BGColor;
  LineCanvas.Canvas.Font.Color := FGColor;

  CR2.Left := 0;
  CR2.Top := 0;
  CR2.Bottom := (CR.Bottom - CR.Top);
  CR2.Right := CRWidth;

  if not ReportView.IsGroup[N] then begin
    Data := ReportView.ItemData[N];
    if Data <> nil then begin
      {CR2 := CR;
      CR2.Top := 0;
      CR2.Bottom := CR2.Top + (CR.Bottom - CR.Top);}
      LineCanvas.Canvas.FillRect(CR2);
      DrawItem(LineCanvas.Canvas, Data, CR2, FGColor, BGColor, IsSelected);
    end;
    if N = lFocusedIndex then
      vlbDrawFocusRect(LineCanvas.Canvas, FocusLeft, CR2.Right - 1, lFocusedIndex);
  end else begin
    if BGColor = Color then begin
      LineCanvas.Canvas.Brush.Color := ReportView.GroupColor;
      BGColor := ReportView.GroupColor;
    end;
    LineCanvas.Canvas.FillRect(CR2);
    Data := ReportView.ItemData[N];
    Gr := ReportView.GroupField[N];
    GrRef := ReportView.GroupRef[N];
    FocusLeft := 0;
    if (ReportView.CurrentView <> nil) and ReportView.CurrentView.ShowGroupTotals then begin
      HaveTotals := True;
      MaxX := CalcMaxX;
    end else begin
      HaveTotals := False;
      MaxX := MaxInt;
    end;
    DrawGroupItem(LineCanvas.Canvas, Data, Gr,
      ReportView.Expanded[GrRef], CR2, FGColor, BGColor, GrRef, IsSelected, MaxX);
    if HaveTotals then
      DrawItemG(LineCanvas.Canvas, Data, CR2, FGColor,BGColor, GrRef, IsSelected);
    if N = lFocusedIndex then
      vlbDrawFocusRect(LineCanvas.Canvas, FocusLeft, CR2.Right - 1, lFocusedIndex);
  end;
  Canvas.CopyMode := cmSrcCopy;
  CR2.Left := ReportView.HScrollDelta;
  CR2.Right := CR2.Left + (CR.Right - CR.Left);
  Canvas.CopyRect(CR, LineCanvas.Canvas, CR2);
end;

procedure TOvcRVListBox.Paint;
{paint ListBox's entire invalid area}
var
  I    : Integer;
  CR   : TRect;
  IR   : TRect;
  Clip : TRect;
  Last : Integer;

  procedure DrawEmptyFocus;
  begin
    if Focused then begin
      CR.Top := 0;
      CR.Bottom := FRowHeight;
      Canvas.DrawFocusRect(CR);
    end;
  end;

var
  N : Integer;
begin
  if (lUpdating > 0) or ReportView.LockUpdate then
    Exit;

  {ReportView.HideHint;}

  Canvas.Font := Font;

  {we will erase our own background}
  SetBkMode(Canvas.Handle, TRANSPARENT);

  {get the client rectangle}
  CR := ClientRect;

  {get the clipping region}
  GetClipBox(Canvas.Handle, Clip);

  if ReportView.ActiveIndex = nil then begin
    Canvas.Brush.Color := FillColor;
    Canvas.FillRect(Clip);
    DrawEmptyFocus;
    exit;
  end;

  {calculate last visible item}
  Last := lRows;
  if Last > NumItems then
    Last := NumItems;

  {display each row}
  for I := 0 to pred(Last) do begin
    {logic moved here from InternalDrawItem:}
    N := FTopIndex + I;
    if N <> -1 then begin
      {get bounding rectangle}
      CR.Top := I * FRowHeight;
      CR.Bottom := CR.Top + FRowHeight;
      FocusLeft := 0;
      {do we have anything to paint}
      if Bool(IntersectRect(IR, Clip, CR)) then
        InternalDrawItem(N, CR{, I + 1});
    end;
  end;

  {paint any blank area below last item}
  CR.Top := FRowHeight * (Last);
  if CR.Top < ClientHeight then begin
    CR.Bottom := ClientHeight;
    {clear the area}
    Canvas.Brush.Color := FillColor;
    Canvas.FillRect(CR);
  end;

  if (NumItems = 0) then
    DrawEmptyFocus;

end;

function TOvcRVListBox.GetStringAtPos(XY : TPoint) : string;
{return full string at X,Y; '' if not struncated - used for hint}
var
  I    : Integer;
  CR   : TRect;
  Last : Integer;

  procedure FindItem(Data : Pointer; const Rect : TRect);
  {Finds a non-group item}
  var
    R,R2 : TRect;
    ViewFieldIndex,W : Integer;
    S,S2 : string;
    CurCol : TOvcRvViewField;
  begin
    ViewFieldIndex := 0;
    R := Rect;
    R.Left := 1;
    while (ViewFieldIndex < RVHeader.Sections.Count) do begin
      W := RVHeader.Section[ViewFieldIndex].Width;
      CurCol := ReportView.CurrentView.ViewField[ViewFieldIndex];
      R.Right := R.Left + W - 1;
      if not (CurCol.GroupBy or not CurCol.ShowHint) then begin
        R2 := R;
        InflateRect(R2, -3, 0);
        if PtInRect(R2,XY) then begin
          S := CurCol.Field.AsString(Data);
          if (S <> '') then
            S2 := GetDisplayString(Canvas,S,1,R2.Right-R2.Left);
          if S <> S2 then begin
            Result := S;
            HintRect := R2;
          end;
          exit;
        end;
      end;
      R.Left := R.Right+1;
      Inc(ViewFieldIndex);
    end;
  end;

  procedure FindGroupItem(Data : Pointer; Group : Integer;
    const Rect : TRect; MaxX: Integer);
  {Finds a group line}
  var
    R : TRect;
    ViewFieldIndex,W : Integer;
    S,S2 : string;
    F : TOvcRvField;
  {const
    GlyphIdx : array[boolean] of Integer = (PlusSign,MinusSign);}
  begin
    ViewFieldIndex := 0;
    R := Rect;
    R.Left := 1;
    R.Right := MinI(R.Right, MaxX);
    while (ViewFieldIndex < RVHeader.Sections.Count) do begin
      W := RVHeader.Section[ViewFieldIndex].Width;
      if ViewFieldIndex = Group then
        begin
          R.Left := R.Left+W;
          if PtInRect(R,XY) then begin

            F := ReportView.CurrentView.ViewField[ViewFieldIndex].Field;

            if ReportView.Options.ShowGroupCaptionInList then begin
              S := F.Caption;
              if S <> '' then
                S := S + ' : ';
            end else
              S := '';

            S := S + F.AsString(Data);
            if S <> '' then
              S2 := GetDisplayString(Canvas,S,1,R.Right-R.Left);
            if S <> S2 then begin
              Result := S;
              HintRect := R;
            end;
            exit;
          end;
        end
      else
        R.Left := R.Left+W;
      Inc(ViewFieldIndex);
    end;
  end;

  procedure FindItemG(Data : Pointer; const Rect : TRect; GroupRef : TOvcRvIndexGroup);
  {Finds a non-group item}
  var
    ViewFieldIndex,W : Integer;
    R,R2 : TRect;
    S,S2 : string;
    CurCol : TOvcRvViewField;
  begin
    ViewFieldIndex := 0;
    R := Rect;
    R.Left := 1;
    while (ViewFieldIndex < RVHeader.Sections.Count) do begin
      W := RVHeader.Section[ViewFieldIndex].Width;
      CurCol := ReportView.CurrentView.ViewField[ViewFieldIndex];
      R.Right := R.Left + W - 1;
      if not (CurCol.GroupBy or not CurCol.ShowHint) then
        if (CurCol.ComputeTotals) then begin
          R2 := R;
          InflateRect(R2, -3, 0);
          if PtInRect(R2,XY) then begin
            S := ReportView.DoGetGroupString(CurCol, GroupRef);
            if (S <> '') then
              S2 := GetDisplayString(Canvas,S,1,R2.Right-R2.Left);
            if S2 <> S then begin
              Result := S;
              HintRect := R2;
            end;
            exit;
          end;
        end;
      R.Left := R.Right+1;
      Inc(ViewFieldIndex);
    end;
  end;

  procedure InternalFindItem(N : Integer; Row : Integer);
    {-Find item N at Row}
  var
    Gr : Integer;
    Data : Pointer;
    GrRef : TOvcRvIndexGroup;
  begin
    if N = -1 then exit;
    {get bounding rectangle}
    CR.Top := Pred(Row)*FRowHeight;
    CR.Bottom := CR.Top+FRowHeight;

    {do we have anything to paint}
    if PtInRect(CR,XY) then begin

      if not ReportView.IsGroup[N] then begin
        Data := ReportView.ItemData[N];
        if Data <> nil then begin
          FindItem(Data, CR);
        end;
      end else begin
        Data := ReportView.ItemData[N];
        Gr := ReportView.GroupField[N];
        GrRef := ReportView.GroupRef[N];
        FindGroupItem(Data, Gr, CR, CalcMaxX);
        if (ReportView.CurrentView <> nil) and ReportView.CurrentView.ShowGroupTotals then
          FindItemG(Data, CR, GrRef);
      end;
    end;
  end;

begin
  Result := '';

  inc(XY.x, ReportView.HScrollDelta);

  {get the client rectangle}
  CR := ClientRect;

  Inc(CR.Right, ReportView.HScrollDelta);

  {calculate last visible item}
  Last := lRows;
  if Last > NumItems then
    Last := NumItems;

  {check each row}
  for I := 1 to Last do begin
    InternalFindItem(FTopIndex+Pred(I), I);
    if Result <> '' then exit;
  end;
end;

{ new}
procedure TOvcRVListBox.InternalSetItemIndex(Index : Integer; DeselectOld: Boolean);
  {-change the currently selected item}
begin
  {verify valid index}
  if Index > lHighIndex then
    if lHighIndex < 0 then
      Index := -1
    else
      Index := lHighIndex;

  {do we need to do any more}
  if (Index = FItemIndex) then
    Exit;

  {erase current selection}
  InvalidateItem(FItemIndex);

  if DeselectOld then
    DoOnSelect(FItemIndex, False);

  {set the newly selected item index}
  FItemIndex := Index;
  Update;

  if csDesigning in ComponentState then
    Exit;

  if FItemIndex > -1 then begin
    vlbMakeItemVisible(Index);
    DoOnSelect(FItemIndex, True);
  end;
  if FItemIndex <> -1 then
    vlbSetFocusedIndex(FItemIndex)
  else
    vlbSetFocusedIndex(0);
  inherited DrawItem(FItemIndex);

  {notify of an index change}
  if not MouseCapture then
    SimulatedClick;
end;

{ new}
procedure TOvcRVListBox.SetItemIndex(Index : Integer);
  {-change the currently selected item}
begin
  InternalSetItemIndex(Index, True);
end;

procedure TOvcRVListBox.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  if Cmd <> ccNone then begin
    case Cmd of
      ccLeft :
        if ReportView.rvHaveHs then begin
          ReportView.HScrollPrim(-10);
          {indicate that this message was processed}
          Msg.Result := 0;
          exit;
        end;
      ccRight :
        if ReportView.rvHaveHs then begin
          ReportView.HScrollPrim(10);
          {indicate that this message was processed}
          Msg.Result := 0;
          exit;
        end;
    end;
  end;
  inherited;
end;

procedure TOvcRVListBox.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  Invalidate;
end;

procedure TOvcRVListBox.WMKillFocus(var Msg : TWmKillFocus);
begin
  inherited;
  Invalidate;
end;

constructor TOvcRvField.Create(AOwner : TComponent);
{create a field definition}
begin
  inherited Create(AOwner);
  FAlignment := taLeftJustify;
  FDefaultWidth := rvDefColWidth;
  FDefaultPrintWidth := rvDefColPrintWidth;
  FImageIndex := -1;
end;

function TOvcRvField.InUse: Boolean;
var
  i,j : Integer;
begin
  with OwnerReport do begin
    for i := 0 to pred(Fields.Count) do
      if (Field[i] <> Self) and (Field[i].RefersTo(Self)) then begin
        Result := True;
        exit;
      end;
    for i := 0 to pred(Views.Count) do
      with View[i] do
        for j := 0 to pred(ViewFields.Count) do
          if ViewField[j].Field = Self then begin
            Result := True;
            exit;
          end;
  end;
  Result := False;
end;

destructor TOvcRvField.Destroy;
begin
  if not OwnerReport.DelayedBinding and not (csDestroying in ComponentState) then
    if InUse then
      raise Exception.Create('Field is in use');
  FExp.Free;
  inherited Destroy;
end;

procedure TOvcRvField.SetExpression(const Value: string);
begin
  if FExpression <> Value then begin
    FExpression := Value;
    if not (csLoading in OwnerReport.ComponentState) then
      Dirty := True;
    FExp.Free;
    FExp := nil;
  end;
end;

function TOvcRvField.Exp: TOvcRvExpression;
var
  RvExpParser : TOvcRvExp;
  M: TMemoryStream;
begin
  if FExp = nil then begin
    RvExpParser := TOvcRvExp.Create(nil);
    try
      M := TMemoryStream.Create;
      M.Write(FExpression[1], length(FExpression) * Sizeof(Char));
      RvExpParser.SourceStream.Free;
      RvExpParser.SourceStream := nil;
      RvExpParser.SourceStream := M;
      RvExpParser.Execute;
      if not RvExpParser.Successful then
        raise Exception.Create('Error in calculated field expression:'+
          RvExpParser.ErrorStr(TCocoError(RvExpParser.ErrorList[0]).ErrorCode,
            TCocoError(RvExpParser.ErrorList[0]).Data));
      FExp := RvExpParser.RootNode;
      while FExp.Reduce do
        ;
      FExp.OwnerReport := OwnerReport;
    finally
      RvExpParser.Free;
    end;
  end;
  Result := FExp;
end;

function TOvcRvField.AsString(Data: Pointer): string;
const
  FalseTrue: array[Boolean] of string = ('False', 'True');
var
  V: Variant;
begin
  if Expression <> '' then begin
    V := GetValue(Data);
    if VarType(V) = varBoolean then
      Result := FalseTrue[Boolean(V)]
    else
      Result := GetValue(Data)
  end else
    Result := inherited AsString(Data);
end;

function TOvcRvField.GetValue(Data: Pointer): Variant;
begin
  if Expression <> '' then
    Result := Exp.GetValue(Data)
  else
    Result := inherited GetValue(Data);
end;

function TOvcRvField.GetBaseName : string;
begin
  Result := 'RvField';
end;

function TOvcRvField.GetOwnerReport : TOvcCustomReportView;
{Return owner as TOvcCustomReportView}
begin
  Result := TOvcRvFields(Collection).Owner;
end;

procedure TOvcRvField.SetCaption(const Value: string);
{Set caption of a field and mark dirty if not loading}
begin
  if FCaption <> Value then begin
    FCaption := Value;
    if ([csLoading,csReading] * Owner.ComponentState = []) then
      Changed;
  end;
end;

procedure TOvcRvField.SetDirty(const Value: Boolean);
begin
  if not OwnerReport.LoadingViews then
    FDirty := Value;
end;

procedure TOvcRvField.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    if ([csLoading,csReading] * Owner.ComponentState = []) then
      Changed;
  end;
end;

procedure TOvcRvField.LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string);
begin
  inherited LoadFromStorage(Storage, Prefix);
  Name := Storage.ReadString(Prefix, 'Name', '');
  Caption := Storage.ReadString(Prefix, 'Caption', '');
  Expression := Storage.ReadString(Prefix, 'Expression', '');
  Alignment := TAlignment(Storage.ReadInteger(Prefix, 'Alignment', 0));
  DefaultWidth := Storage.ReadInteger(Prefix, 'DefaultWidth', 50);
  DefaultPrintWidth := Storage.ReadInteger(Prefix, 'DefaultPrintWidth', 1440);
  DataType := TOvcDRDataType(Storage.ReadInteger(Prefix, 'DataType', 0));
  DefaultOwnerDraw := Storage.ReadBoolean(Prefix, 'DefaultOwnerDraw', False);
  DefaultSortDirection := TOvcRvFieldSort(
    Storage.ReadInteger(Prefix, 'DefaultSortDirection', 0));
  NoDesign := Storage.ReadBoolean(Prefix, 'NoDesign', False);
  Hint := Storage.ReadString(Prefix, 'Hint', '');
  ImageIndex := Storage.ReadInteger(Prefix, 'ImageIndex', -1);
  Dirty := False;
end;

procedure TOvcRvField.ReadState(Reader: TReader);
begin
  FDFMBased := True;
  inherited;
end;

function TOvcRvField.RefersTo(const RefField: TOvcRvField): Boolean;
begin
  if Expression <> '' then
    Result := Exp.RefersTo(RefField)
  else
    Result := False;
end;

procedure TOvcRvField.SaveToStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
begin
  inherited SaveToStorage(Storage, Prefix);
  Storage.WriteString(Prefix, 'Name', Name);
  if Caption <> '' then
    Storage.WriteString(Prefix, 'Caption', Caption);
  if Expression <> '' then
    Storage.WriteString(Prefix, 'Expression', Expression);
  if Alignment <> taLeftJustify then
    Storage.WriteInteger(Prefix, 'Alignment', ord(Alignment));
  if DefaultWidth <> 50 then
    Storage.WriteInteger(Prefix, 'DefaultWidth', DefaultWidth);
  if DefaultPrintWidth <> 1440 then
    Storage.WriteInteger(Prefix, 'DefaultPrintWidth', DefaultPrintWidth);
  Storage.WriteInteger(Prefix, 'DataType', ord(DataType));
  if DefaultOwnerDraw then
    Storage.WriteBoolean(Prefix, 'DefaultOwnerDraw', DefaultOwnerDraw);
  if DefaultSortDirection <> rfsFirstAscending then
    Storage.WriteInteger(Prefix, 'DefaultSortDirection', ord(DefaultSortDirection));
  if NoDesign then
    Storage.WriteBoolean(Prefix, 'NoDesign', NoDesign);
  if Hint <> '' then
    Storage.WriteString(Prefix, 'Hint', Hint);
  if ImageIndex <> -1 then
    Storage.WriteInteger(Prefix, 'ImageIndex', ImageIndex);
end;

procedure TOvcRvField.Assign(Source: TPersistent);
{Assign field}
var
  Field: TOvcRvField;
begin
  if Source is TOvcRvField then begin
    Field:= TOvcRvField(Source);
    Caption := Field.Caption;
    Alignment := Field.Alignment;
    DefaultWidth := Field.DefaultWidth;
    DefaultPrintWidth := Field.DefaultPrintWidth;
    DataType := Field.DataType;
    DefaultOwnerDraw := Field.DefaultOwnerDraw;
    NoDesign := Field.NoDesign;
    Hint := Field.Hint;
    ImageIndex := Field.ImageIndex;
    Expression := Field.Expression;
    DefaultSortDirection := Field.DefaultSortDirection;
  end;
  inherited Assign(Source);
end;

function TOvcRvField.GetDisplayText: string;
{Return display string for property editor}
begin
  if Caption <> '' then
    Result := format('%s ("%s")',[Name,Caption])
  else
    Result := Name;
  if Result = '' then
    Result := inherited GetDisplayText;
end;

procedure TOvcRvField.SetName(const NewName : TComponentName);
var
  i,j : Integer;
  OldName : string;
begin
  OldName := Name;
  inherited SetName(NewName);
  with OwnerReport do
    for i := 0 to pred(Views.Count) do
      with View[i] do
        for j := 0 to pred(ViewFields.Count) do
          if ViewField[j].FieldName = OldName then begin
            ViewField[j].FieldName := NewName;
            if (csDesigning in ComponentState)
            and (OwnerReport.Owner <> nil)
            and not (OwnerReport.Fields.ReadOnly) then
              TForm(OwnerReport.Owner).Designer.Modified;
          end;
end;

procedure TOvcRvField.ValidateExpression;
begin
  DataType := Exp.GetType;
  if Exp.RefersTo(Self) then
    raise Exception.Create('Field expression may not refer recursively to itself');
end;

{ TOvcRvViewField }

constructor TOvcRvViewField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FWidth := -1;
  PrintWidth := -1;
  FShowHint := rvDefShowHint;
  FAllowResize := True;
  FVisible := True;
end;

procedure TOvcRvViewField.SaveToStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
begin
  inherited SaveToStorage(Storage, Prefix);
  Storage.WriteString(Prefix, 'Name', Name);
  if OwnerDraw then
    Storage.WriteBoolean(Prefix, 'OwnerDraw', OwnerDraw);
  if SortDirection <> rfsFirstAscending then
    Storage.WriteInteger(Prefix, 'SortDirection', ord(SortDirection));
  if GetPrintWidthStored then
    Storage.WriteInteger(Prefix, 'PrintWidth', PrintWidth);
  if GetWidthStored then
    Storage.WriteInteger(Prefix, 'Width', Width);
  if Aggregate <> '' then
    Storage.WriteString(Prefix, 'Aggregate', Aggregate);
end;

function TOvcRvViewField.LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string): Boolean;
begin
  if inherited LoadFromStorage(Storage, Prefix) then begin
    Name := Storage.ReadString(Prefix, 'Name', '');
    OwnerDraw := Storage.ReadBoolean(Prefix, 'OwnerDraw', False);
    SortDirection := TOvcRvFieldSort(Storage.ReadInteger(Prefix, 'SortDirection', 0));
    PrintWidth := Storage.ReadInteger(Prefix, 'PrintWidth', PrintWidth);
    Width := Storage.ReadInteger(Prefix, 'Width', Width);
    Aggregate := Storage.ReadString(Prefix, 'Aggregate', '');
    Result := True;
  end else
    Result := False;
end;

destructor TOvcRvViewField.Destroy;
var
  Current : Boolean;
begin
  if (OwnerReport <> nil) and (OwnerReport.CurrentView = OwnerView) then begin
    OwnerReport.ActiveView := '';
    Current := True;
  end else
    Current := False;
  inherited Destroy;
  if Current then
    OwnerReport.ActiveView := OwnerView.Name;
  if not (csDestroying in OwnerReport.ComponentState) then
    OwnerView.Dirty := True;
  FAggExp.Free;
end;

function TOvcRvViewField.GetAggExp: TOvcRvExpression;
var
  RvExpParser : TOvcRvExp;
  M: TMemoryStream;
begin
  if FAggExp = nil then begin
    RvExpParser := TOvcRvExp.Create(nil);
    try
      M := TMemoryStream.Create;
      M.Write(FAggregate[1], length(FAggregate) * SizeOf(Char));
      RvExpParser.SourceStream.Free;
      RvExpParser.SourceStream := nil;
      RvExpParser.SourceStream := M;
      RvExpParser.Execute;
      if not RvExpParser.Successful then
        raise Exception.Create('Error in aggregate expression:'+
          RvExpParser.ErrorStr(TCocoError(RvExpParser.ErrorList[0]).ErrorCode,
            TCocoError(RvExpParser.ErrorList[0]).Data));
      FAggExp := RvExpParser.RootNode;
      while FAggExp.Reduce do
        ;
      FAggExp.OwnerReport := OwnerReport;
    finally
      RvExpParser.Free;
    end;
  end;
  Result := FAggExp;
end;

function TOvcRvViewField.GetBaseName : string;
begin
  Result := 'RvViewField';
end;

function TOvcRvViewField.GetDisplayText: string;
{Return display string for property editor}
begin
  if FieldName <> '' then
    Result := format('%s (%s)',[Name,FieldName])
  else
    Result := Name;
  if Result = '' then
    Result := inherited GetDisplayText;
end;

function TOvcRvViewField.GetField : TOvcRvField;
begin
  Result := TOvcRvField(inherited GetField);
end;


function TOvcRvViewField.GetOwnerReport;
begin
  Result := TOvcCustomReportView(FOwnerReport);
end;

procedure TOvcRvField.SetAlignment(Value: TAlignment);
{Set alignment of field}
begin
  if (Alignment <> Value) then begin
    FAlignment := Value;
    if ([csLoading,csReading] * Owner.ComponentState = []) then
      Changed;
  end;
end;

function TOvcRvViewField.GetWidth : Integer;
begin
  if Visible or (csDesigning in ComponentState) then begin
    if FWidth = -1 then
      if assigned(FField) then
        Result := Field.DefaultWidth
      else
        Result := rvDefColWidth
    else
      Result := FWidth;
  end else
    Result := 0;
end;

function TOvcRvViewField.GetWidthStored: Boolean;
begin
  Result := (FWidth <> -1)
    and (not assigned(FField) or (FWidth <> Field.DefaultWidth));
end;

function TOvcRvViewField.GetPrintWidth : Integer;
begin
  if FPrintWidth = -1 then
    if assigned(FField) then
      Result := Field.DefaultPrintWidth
    else
      Result := rvDefColPrintWidth
  else
    Result := FPrintWidth;
end;

function TOvcRvViewField.GetPrintWidthStored: Boolean;
begin
  Result := (FPrintWidth <> -1)
    and (not assigned(FField) or (FPrintWidth <> Field.DefaultPrintWidth));
end;

procedure TOvcRvViewField.SetWidth(Value: Integer);
{Set width of field}
begin
  if Width <> Value then begin
    FWidth := Value;
    if (Owner <> nil) and
    ([csLoading,csReading] * Owner.ComponentState = []) then begin
      if OwnerReport.CurrentView <> nil then with OwnerReport do begin
        if CurrentView = OwnerView then begin
          if Index < FRVHeader.Sections.Count then
            FRVHeader.Section[Index].Width := FWidth;
          if FooterPanel.Visible {RVFooter.Visible} then
            FRVFooter.Section[Index].Width := FWidth;
          FRVListBox.Invalidate;
        end;
      end;
      Changed;
      OwnerReport.WidthChanged := True;
    end;
  end;
end;

procedure TOvcRvViewField.SetPrintWidth(Value: Integer);
{Set width of field}
begin
  if PrintWidth <> Value then begin
    FPrintWidth := Value;
    Changed;
  end;
end;

procedure TOvcRvViewField.Assign(Source: TPersistent);
begin
  if Source is TOvcRvViewField then begin
    OwnerDraw := TOvcRvViewField(Source).OwnerDraw;
    PrintWidth := TOvcRvViewField(Source).PrintWidth;
    Width := TOvcRvViewField(Source).Width;
    Aggregate := TOvcRvViewField(Source).Aggregate;
    SortDirection := TOvcRvViewField(Source).SortDirection;
  end;
  inherited Assign(Source);
end;

function TOvcRvViewField.GetAllowResize: Boolean;
begin
  Result := FAllowResize and (Visible or (csDesigning in ComponentState));
end;

procedure TOvcRvViewField.SetVisible(const Value: Boolean);
var
  I: Integer;
begin
  if Value <> FVisible then begin
    FVisible := Value;
    if Value then
      I := Width
    else
      I := 0;
    if (Owner <> nil) and ([csLoading,csReading] * Owner.ComponentState = []) then begin
      if OwnerReport.CurrentView <> nil then with OwnerReport do begin
        if CurrentView = OwnerView then begin
          if Index < FRVHeader.Sections.Count then
            FRVHeader.Section[Index].Width := I;
          if FooterPanel.Visible then
            FRVFooter.Section[Index].Width := I;
          FRVListBox.Invalidate;
        end;
      end;
    end;
    Changed;
    OwnerReport.WidthChanged := True;
  end;
end;

procedure TOvcRvViewField.SetIndex(Value: Integer);
var
  S: TOvcRvViewField;
  i: Integer;
begin
  S := nil;
  if not OwnerReport.Designing then begin
    if GroupBy then
      raise Exception.Create('You cannot change position of a grouped column');
    if OwnerView.ViewField[Value].GroupBy then
      raise Exception.Create('Grouped columns must be left-most');
    if (OwnerReport.CurrentView = OwnerView)
    and (OwnerReport.SortColumn <> -1) then
      S := TOvcRvViewField(OwnerView.ViewField[OwnerReport.SortColumn]);
  end;
  inherited;
  if not OwnerReport.Designing then begin
    OwnerView.Dirty := True;
    if OwnerReport.CurrentView = OwnerView then begin
      OwnerReport.FRVHeader.Reload;
      OwnerReport.FRVFooter.Reload;
      OwnerReport.FRVHeader.SetSortGlyph;
      OwnerReport.Invalidate;
      if S <> nil then
        for i := 0 to pred(OwnerView.ViewFields.Count) do
          if OwnerView.ViewField[i] = S then begin
            OwnerReport.SortColumn := OwnerView.ViewField[i].Index;
            exit;
          end;
    end;
  end;
end;

function TOvcRvViewField.GetOwnerView: TOvcRvView;
begin
  Result := TOvcRvView(inherited OwnerView);
end;

procedure TOvcRvViewField.Changed;
begin
  inherited;
  if not OwnerReport.Designing then
    OwnerView.Dirty := True;
end;

procedure TOvcRvViewField.SetAggregate(const Value: string);
var
  SaveAgg: string;
begin
  if Value <> FAggregate then begin
    SaveAgg := FAggregate;
    try
      FAggregate := Value;
      FAggExp.Free;
      FAggExp := nil;
      if not (csLoading in ComponentState) then
        OwnerView.Dirty := True;
    except
      Aggregate := SaveAgg;
      raise;
    end;
  end;
end;

{ TOvcRvViewFields }

constructor TOvcRvFields.Create(AOwner: TOvcCustomReportView);
{Create a field-collection}
begin
  inherited Create(AOwner,AOwner.GetFieldClassType);
  FOwner := AOwner;
end;

function TOvcRvFields.GetOwnerReport : TOvcCustomReportView;
begin
  Result := TOvcCustomReportView(inherited Owner);
end;

function TOvcRvFields.GetItem(Index: Integer): TOvcRvField;
{Return collection-item cast to TOrRvColumn}
begin
  Result := TOvcRvField(inherited GetItem(Index));
end;

procedure TOvcRvFields.SetItem(Index: Integer; Value: TOvcRvField);
{Set collection item of type TOrRvColumn}
begin
  inherited SetItem(Index, Value);
end;

function TOvcRvFields.Add: TOvcRvField;
{Add new field to collection and return it}
begin
  Result := TOvcRvField(inherited Add);
end;

procedure TOvcRvFields.Assign(Source: TPersistent);
var
  NewField : TOvcRvField;
  i : Integer;
begin
  if Source is TOvcRvFields then begin
    Clear;
    for i := 0 to pred(TOvcRvFields(Source).Count) do begin
      NewField := TOvcRvField(Add);
      NewField.Assign(TOvcRvFields(Source).Items[i]);
    end;
  end else
    inherited Assign(Source);
end;

constructor TOvcRvViewFields.Create(AOwner: TOvcRVView);
begin
  inherited Create(AOwner, TOvcRvViewField);
  {FOwnerReport := TOvcCustomReportView(AOwner.Owner);}
end;

function TOvcRvViewFields.GetOwnerView : TOvcRVView;
begin
  Result := TOvcRVView(inherited Owner);
end;

function TOvcRvViewFields.Add: TOvcRvViewField;
begin
  Result := TOvcRvViewField(inherited Add);
end;

function TOvcRvViewFields.GetItem(Index: Integer): TOvcRvViewField;
begin
  Result := TOvcRvViewField(inherited GetItem(Index));
end;

procedure TOvcRvViewFields.SetItem(Index: Integer; Value: TOvcRvViewField);
begin
  inherited SetItem(Index, Value);
end;

constructor TOvcRVView.Create(AOwner : TComponent);
{create a view definition}
begin
  inherited Create(AOwner);
  FilterIndex := -1;
  FViewFields := TOvcRvViewFields.Create(Self);
  FShowHeader := True;
  TOvcCustomReportView(Owner).DoChangeNotification(rvViewCreate);
  Title := Name;
end;

function TOvcRvView.OwnerReport: TOvcCustomReportView;
begin
  Result := TOvcCustomReportView(Owner);
end;

destructor TOvcRVView.Destroy;
var
  SaveOwner : TOvcCustomReportView;
begin
  if Owner <> nil then
    if ([csDesigning, csDestroying] * Owner.ComponentState = []) then
    {if not (csDestroying in Owner.ComponentState) then}
      if FDFMBased then
        raise Exception.Create('Default view. May not be deleted');
  if (Owner <> nil)
  and ([csDesigning, csDestroying] * Owner.ComponentState = [])
  and not FDFMBased
  and not OwnerReport.LoadingViews then
    TOvcCustomReportView(Owner).ViewDeleted := True;
  if csAncestor in ComponentState then
    if csDesigning in ComponentState then
      if not (csDestroying in ComponentState) then
        raise Exception.CreateFmt(
          'Inherited component, %s, cannot delete',[Name]);
  if Owner <> nil then
    if not (csDestroying in Owner.ComponentState) then
      if TOvcCustomReportView(Owner).ActiveView = Self.Name then
        TOvcCustomReportView(Owner).ActiveView := '';
  {else (moved to after inherited)}
    {TOvcCustomReportView(Owner).DoChangeNotification(rvDataChanged);}
  if (Owner <> nil)
  and ([csDesigning, csDestroying] * TOvcCustomReportView(Owner).
    ComponentState = [csDesigning]) then
      if TOvcCustomReportView(Owner).Owner is TForm then
        TForm(TOvcCustomReportView(Owner).Owner).Designer.Modified;
  SaveOwner := TOvcCustomReportView(Owner);
  inherited Destroy;
  if SaveOwner <> nil then
    if not (csDestroying in SaveOwner.ComponentState) then
      SaveOwner.DoChangeNotification(rvViewDestroy);
  FFilterExp.Free;
end;

function TOvcRVView.GetBaseName : string;
begin
  Result := 'RvView';
end;

procedure TOvcRVView.Assign(Source: TPersistent);
begin
  if Source is TOvcRvView then begin
    DefaultSortColumn := TOvcRvView(Source).DefaultSortColumn;
    DefaultSortDescending := TOvcRvView(Source).DefaultSortDescending;
    ShowGroupCounts := TOvcRvView(Source).ShowGroupCounts;
    ShowGroupTotals := TOvcRvView(Source).ShowGroupTotals;
    ShowFooter := TOvcRvView(Source).ShowFooter;
    ShowHeader := TOvcRvView(Source).ShowHeader;
    Title := TOvcRvView(Source).Title;
    Filter := TOvcRvView(Source).Filter;
  end;
  inherited Assign(Source);
end;

function TOvcRVView.GetFilterExp: TOvcRvExpression;
var
  RvExpParser : TOvcRvExp;
  M: TMemoryStream;
begin
  if FFilterExp = nil then begin
    RvExpParser := TOvcRvExp.Create(nil);
    try
      M := TMemoryStream.Create;
      M.Write(FFilter[1], length(FFilter) * SizeOf(Char));
      RvExpParser.SourceStream.Free;
      RvExpParser.SourceStream := nil;
      RvExpParser.SourceStream := M;
      RvExpParser.Execute;
      if not RvExpParser.Successful then
        raise Exception.Create('Error in filter expression:'+
          RvExpParser.ErrorStr(TCocoError(RvExpParser.ErrorList[0]).ErrorCode,
            TCocoError(RvExpParser.ErrorList[0]).Data));
      FFilterExp := RvExpParser.RootNode;
      while FFilterExp.Reduce do
        ;
      FFilterExp.OwnerReport := OwnerReport;
    finally
      RvExpParser.Free;
    end;
  end;
  Result := FFilterExp;
end;

procedure TOvcRVView.AncestorNotFound(Reader: TReader; const ComponentName: string;
    ComponentClass: TPersistentClass; var Component: TComponent);
begin
  if ComponentClass = TOvcRvViewField then
    Component := FViewFields.ItemByName(ComponentName);
end;

procedure TOvcRVView.ReadState(Reader : TReader);
var
  SaveAncestorNotFound : TAncestorNotFoundEvent;
begin
  FDFMBased := True;
  SaveAncestorNotFound := Reader.OnAncestorNotFound;
  try
    Reader.OnAncestorNotFound := AncestorNotFound;
    inherited ReadState(Reader);
  finally
    Reader.OnAncestorNotFound := SaveAncestorNotFound;
  end;
end;

procedure TOvcRVView.SetDirty(const Value: Boolean);
begin
  if not OwnerReport.LoadingViews then
    FDirty := Value;
end;

procedure TOvcRVView.SetName(const NewName : TComponentName);
var
  OldName,OldActive : string;
begin
  OldActive := TOvcCustomReportView(Owner).ActiveView;
  if OldActive = Name then
    TOvcCustomReportView(Owner).ActiveView := '';
  OldName := Name;
  inherited SetName(NewName);
  if (OldActive <> '') and (OldActive = OldName) then
    TOvcCustomReportView(Owner).ActiveView  := NewName;
end;

procedure TOvcRVView.SetShowFooter(Value : Boolean);
begin
  if Value <> FShowFooter then begin
    FShowFooter := Value;
    if TOvcCustomReportView(Owner).CurrentView = Self then
      {TOvcCustomReportView(Owner).RVFooter.Visible := Value;}
      TOvcCustomReportView(Owner).FooterPanel.Visible := Value;
  end;
end;

procedure TOvcRVView.SetShowHeader(Value : Boolean);
begin
  if Value <> FShowHeader then begin
    FShowHeader := Value;
    if TOvcCustomReportView(Owner).CurrentView = Self then
      {TOvcCustomReportView(Owner).RVHeader.Visible := Value;}
      TOvcCustomReportView(Owner).HeaderPanel.Visible := Value;
  end;
end;

{ new}
function TOvcRVView.UniqueViewTitle(const Title : string) : string;
var
  i, Seq : Integer;
  Done: Boolean;
begin
  Seq := 1;
  repeat
    Done := True;
    if Seq > 1 then
      Result := Title + '#' + IntToStr(Seq)
    else
      Result := Title;
    for i := 0 to TOvcCustomReportView(Owner).Views.Count - 1 do
      if TOvcCustomReportView(Owner).View[i].Title = Result then begin
        inc(Seq);
        Done := False;
        break;
      end;
  until Done;
end;

procedure TOvcRVView.SetTitle(const Value: string);
var
  Current : Boolean;
begin
  if Value <> FTitle then begin
    FTitle := UniqueViewTitle(Value);
    if TOvcCustomReportView(Owner).CurrentView = Self then begin
      Current := True;
      TOvcCustomReportView(Owner).ActiveView := '';
    end else
      Current := False;
    try
      TOvcCustomReportView(Owner).DoChangeNotification(rvViewDestroy);
      TOvcCustomReportView(Owner).DoChangeNotification(rvViewCreate);
    finally
      if Current then
        TOvcCustomReportView(Owner).ActiveView := Self.Name;
    end;
    Dirty := True;
  end;
end;

procedure TOvcRvView.Refresh;
begin
  OwnerReport.ActiveView := '';
  OwnerReport.DeleteViewIndexes(Name);
  OwnerReport.ActiveView := Self.Name;
end;

procedure TOvcRVView.SetFilter(const Value: string);
var
  SaveFilter: string;
begin
  if Value <> FFilter then begin
    OwnerReport.CurrentItem := nil;
    SaveFilter := FFilter;
    try
      FFilter := Value;
      FFilterExp.Free;
      FFilterExp := nil;
      FilterIndex :=-1;
      if not (csLoading in ComponentState) then begin
        Refresh;
        Dirty := True;
      end;
    except
      Filter := SaveFilter;
      raise;
    end;
  end;
end;

procedure TOvcRVView.SaveToStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
begin
  if DefaultSortColumn <> 0 then
    Storage.WriteInteger(Prefix, 'DefSort', DefaultSortColumn);
  if DefaultSortDescending then
    Storage.WriteBoolean(Prefix, 'DefSortDesc', DefaultSortDescending);
  if ShowGroupCounts then
    Storage.WriteBoolean(Prefix, 'ShwGrpCnt', ShowGroupCounts);
  if ShowGroupTotals then
    Storage.WriteBoolean(Prefix, 'ShwGrpTot', ShowGroupTotals);
  if not ShowHeader then
    Storage.WriteBoolean(Prefix, 'Header', ShowHeader);
  if ShowFooter then
    Storage.WriteBoolean(Prefix, 'Footer', ShowFooter);
  if Title <> '' then
    Storage.WriteString(Prefix, 'Title', Title);
  if Filter <> '' then
    Storage.WriteString(Prefix, 'Filter', Filter);
  inherited SaveToStorage(Storage, Prefix);
  Dirty := False;
end;

procedure TOvcRVView.LoadFromStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
begin
  inherited LoadFromStorage(Storage, Prefix);
  DefaultSortColumn := Storage.ReadInteger(Prefix, 'DefSort', 0);
  DefaultSortDescending := Storage.ReadBoolean(Prefix, 'DefSortDesc', False);
  ShowGroupCounts := Storage.ReadBoolean(Prefix, 'ShwGrpCnt', False);
  ShowGroupTotals := Storage.ReadBoolean(Prefix, 'ShwGrpTot', False);
  ShowHeader := Storage.ReadBoolean(Prefix, 'Header', True);
  ShowFooter := Storage.ReadBoolean(Prefix, 'Footer', False);
  Title := Storage.ReadString(Prefix, 'Title', '');
  FFilter := Storage.ReadString(Prefix, 'Filter', '');
  Dirty := False;
end;

procedure TOvcRvViews.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

procedure TOvcRVViews.Clear;
begin
  TOvcCustomReportView(Owner).ActiveView := '';
  inherited Clear;
  FOwner.ClearIndexList;
end;

constructor TOvcRVViews.Create(AOwner: TOvcCustomReportView);
{Create a view-collection}
begin
  inherited Create(AOwner, AOwner.GetViewClassType);
  FOwner := AOwner;
end;

function TOvcRVViews.GetItem(Index: Integer): TOvcRVView;
{Return collection-item cast to TOrRvView}
begin
  Result := TOvcRVView(inherited GetItem(Index));
end;

procedure TOvcRVViews.SetItem(Index: Integer; Value: TOvcRVView);
{Set collection item of type TOrRvView}
begin
  inherited SetItem(Index, Value);
end;

function TOvcRVViews.Add: TOvcRVView;
{Add new view to collection and return it}
begin
  Result := TOvcRVView(inherited Add);
end;

function TOvcRVView.GetViewField(Index : Integer) : TOvcRvViewField;
begin
  Result := TOvcRvViewField(inherited GetViewField(Index));
end;

function TOvcRVView.GetViewFields: TOvcRvViewFields;
begin
  Result := TOvcRvViewFields(FViewFields);
end;

procedure TOvcRVView.SetViewFields(const Value: TOvcRvViewFields);
begin
  inherited SetViewFields(Value);
end;

function TOvcRVView.Include(Data: Pointer): Boolean;
begin
  Result := FilterExp.AsBoolean(Data);
end;

constructor TOvcRvPrintProps.Create;
begin
  FPrintFont := TRvPrintFont.Create;
  FPrintFont.Name := 'Arial';
  FPrintFont.Size := 10;
  FPrintColumnMargin := 72;
  FPrintLineWidth := 12;
end;

destructor TOvcRvPrintProps.Destroy;
begin
  FPrintFont.Free;
  inherited Destroy;
end;

procedure TOvcRvPrintProps.SetPrintFont(Value : TRvPrintFont);
begin
  FPrintFont.Assign(Value);
end;

{ TOvcCustomReportView }
procedure TOvcCustomReportView.SetActiveViewByTitle(const Value : string);
var
  S : string;
begin
  S := ViewNameByTitle(Value);
  if S <> '' then
    SetActiveView(S)
  else
    raise EReportViewError.CreateFmt(SCUnknownView,[Value],0);
end;

procedure TOvcCustomReportView.SetActiveView(const Value : string);
var
  i : Integer;
begin
  if (csLoading in ComponentState) or DelayedBinding then begin
    FActiveView := Value;
    if DelayedBinding then
      StoreColumnWidths;
    exit;
  end;
  if Value <> FActiveView then begin
    StoreColumnWidths;
    if Value = '' then begin
      {StoreColumnWidths;}
      FActiveView := '';
      FActiveViewByTitle := '';
      ActiveIndexerView := '';
      FCurrentView := nil;
      {RVHeader.Visible := False;}
      {RVFooter.Visible := False;}
      HeaderPanel.Visible := False;
      FooterPanel.Visible := False;
      FRVHeader.Reload;
      FRVFooter.Reload;
      FRVHeader.SetSortGlyph;
      Invalidate;
      DoChangeNotification(rvViewSelect);
      RecalcWidth;
      if not (csDestroying in ComponentState) then
        CurrentItem := nil;
      RequestAlign;
      exit;
    end;
    for i := 0 to pred(Views.Count) do
      if Value = View[i].Name then begin
        InternalSelectAll(False);
        InternalBeginUpdate(False);
        try
          {FooterPanel.Visible := False;}
          {RVFooter.Visible := False;}
          FActiveView := Value;
          FCurrentView := View[i];
          FActiveViewByTitle := CurrentView.Title;
          FRVHeader.Reload;
          if IsGrouped then
            FRVListBox.FillColor := GroupColor
          else
            FRVListBox.FillColor := Options.ListColor;
          InternalSortColumn := 1;
          ActiveIndexerView := Value;
          {RVHeader.Visible := CurrentView.ShowHeader;
          RVFooter.Visible := CurrentView.ShowFooter;}
          HeaderPanel.Visible := CurrentView.ShowHeader;
          FooterPanel.Visible := CurrentView.ShowFooter;
          FRVFooter.Reload;
          HScrollDelta := 0;
          PHResize(nil);
          PFResize(nil);
        finally
          InternalEndUpdate(False);
          if CurrentItem = nil then
            Navigate(rvpScrollToTop);
        end;
        if (FCurrentView.DefaultSortColumn < 0)
        or (FCurrentView.DefaultSortColumn >=
          FCurrentView.ViewFields.Count) then
          InternalSortColumn := 1
        else
          if FCurrentView.DefaultSortDescending then
            InternalSortColumn := - (FCurrentView.DefaultSortColumn + 1)
          else
            InternalSortColumn := FCurrentView.DefaultSortColumn + 1;
        FRVHeader.SetSortGlyph;
        LoadColumnWidths;
        DoChangeNotification(rvViewSelect);
        RecalcWidth;
        RequestAlign;
        exit;
      end;
    raise EReportViewError.CreateFmt(SCUnknownView,[Value],0);
  end else begin
    LoadColumnWidths;
    RecalcWidth;
  end;
end;

function TOvcCustomReportView.ColumnFromOffset(XOffset : Integer) : TOvcRvField;
{return field of column at X,Y - NIL if not a column}
var
  ViewFieldIndex, W : Integer;
  X1, X2 : Integer;
begin
  Result := nil;
  ViewFieldIndex := 0;
  X1 := 1;
  while (ViewFieldIndex < FRVHeader.Sections.Count) do begin
    W := FRVHeader.Section[ViewFieldIndex].Width;
    X2 := X1 + W - 1;
    if (XOffset >= (X1 - 3)) and (XOffset <= (X2 + 3)) then begin
      Result := CurrentView.ViewField[ViewFieldIndex].Field;
      exit;
    end;
    X1 := X2 + 1;
    inc(ViewFieldIndex);
  end;
end;

procedure TOvcCustomReportView.ColumnsChanged(Sender : TObject);
begin
  if not (csDestroying in ComponentState) then begin
    if not DelayedBinding then begin
      FRVHeader.Reload;
      FRVFooter.Reload;
    end;
  end;
end;

function TOvcCustomReportView.CreateViewCollection: TOvcRVViews;
begin
  Result := TOvcRVViews.Create(Self);
end;

function TOvcCustomReportview.CreateListBox: TOvcRVListBox;
begin
  Result := TOvcRVListBox.Create(Self);
end;

function TOvcCustomReportView.CreateHeader: TOvcRVHeader;
begin
  Result := TOvcRVHeader.Create(Self);
end;

function TOvcCustomReportView.CreateFooter: TOvcRVFooter;
begin
  Result := TOvcRVFooter.Create(Self);
end;

constructor TOvcCustomReportView.Create(AOwner : TComponent);
{Create report view component}
begin
  inherited Create(AOwner);
  FOptions := TOvcRVOptions.Create(Self);
  {FHoverTimer := -1;}
  ChangeNotificationList := TList.Create;
  ControlStyle := ControlStyle + [csOpaque];
  if Classes.GetClass(GetFieldClassType.ClassName) = nil then
    Classes.RegisterClass(GetFieldClassType);
  if Classes.GetClass(GetViewClassType.ClassName) = nil then
    Classes.RegisterClass(GetViewClassType);
  if Classes.GetClass(TOvcRvViewField.ClassName) = nil then
    Classes.RegisterClass(TOvcRvViewField);
  PrinterProperties := TOvcRvPrintProps.Create;
  Width := 100;
  Height := 100;
  FFields := TOvcRvFields.Create(Self);
  FFields.OnChanged := ColumnsChanged;
  FKeyTimeout := rvDefKeyTimeout;
  FViews := CreateViewCollection;
  FScrollBars := ssVertical;
  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 18;
  HeaderPanel.BorderStyle := bsNone;
  HeaderPanel.Parent := Self;
  HeaderPanel.OnResize := PHResize;
  FooterPanel := TPanel.Create(Self);
  FooterPanel.BevelOuter := bvNone;
  FooterPanel.Align := alBottom;
  FooterPanel.Height := 18;
  FooterPanel.BorderStyle := bsNone;
  FooterPanel.Parent := Self;
  FooterPanel.OnResize := PFResize;
  FRVListBox := CreateListBox;
  FRVListBox.AutoRowHeight := True;
  FRVListBox.NumItems := 0;
  FRVListBox.ScrollBars := ssVertical;
  FRVHeader := CreateHeader;
  FRVHeader.ShowHint := True;
  FRVHeader.Internal := True;
  FRVHeader.ListBox := FRVListBox;
  FRVListBox.RVHeader := FRVHeader;
  FRVHeader.BorderStyle := bsNone;
  FRVHeader.Parent := HeaderPanel;
  FRVHeader.Align := alNone;
  FRVHeader.Top := 0;
  FRVHeader.Left := 0;
  FRVHeader.Sections.Clear;
  FRVHeader.TextMargin := 1;
  FRVHeader.ItemIndex := -1;
  FRVHeader.Style := bhsButton;
  FRVHeader.Images := HeaderGlyphList;
  FRVHeader.DrawingStyle := bhsEtched;
  FRVHeader.AllowDragRearrange := True;
  FRVFooter := CreateFooter;
  FRVFooter.Internal := True;
  FRVFooter.ListBox := FRVListBox;
  FRVListBox.RVFooter := FRVFooter;
  FRVFooter.BorderStyle := bsNone;
  FRVFooter.Parent := FooterPanel;
  FRVFooter.Align := alNone; {alClient;}
  FRVFooter.Top := 0;
  FRVFooter.Left := 0;
  FRVFooter.Sections.Clear;
  FRVFooter.TextMargin := 1;
  FRVFooter.ItemIndex := -1;
  FRVFooter.Style := bhsNone;
  FRVFooter.AllowResize := False;
  FRVFooter.DrawingStyle := bhsEtched;
  FRVListBox.ReportView := Self;
  FRVListBox.BorderStyle := bsSingle;
  FRVListBox.Parent := Self;
  FRVListBox.Align := alClient;
  FRVListBox.OnDblClick := ListDblClick;
  FRVListBox.OnKeyPress := ListKeyPress;
  {HintWindow := HintWindowClass.Create(Self);
  HintWindow.Color := Application.HintColor;}
  SaveFont := TFont.Create; {used to save properties during owner draw}
  FGroupColor := clBtnFace;
  ShowHint := True;
end;

procedure TOvcCustomReportView.CreateWnd;
begin
  inherited CreateWnd;

  {do we have scroll bars}
  rvHaveHS := FScrollBars in [ssHorizontal, ssBoth];

  FRVListBox.Controller := Controller;
  if rvHaveHS then begin
    RecalcWidth;
    InitScrollInfo;
  end;
end;

function TOvcCustomReportView.DataCount: Integer;
begin
  Result := FRawData.Count;
end;

destructor TOvcCustomReportView.Destroy;
{Destroy report view component}
begin
  SaveDirtyViews;
  DoChangeNotification(rvDestroying);
  {
  if FHoverTimer <> -1 then begin
    if Controller <> nil then
      if Controller.TimerPool <> nil then
        Controller.TimerPool.Remove(FHoverTimer);
    FHoverTimer := -1;
  end;
  HintShownHere := True;
  }
  FFields.OnChanged := nil;
  ClearIndex;
  FViews.Free;
  FFields.Free;
  PrinterProperties.Free;
  {HintWindow.Free;}
  ChangeNotificationList.Free;
  FOptions.Free;
  SaveFont.Free;
  inherited Destroy;
end;

procedure TOvcCustomReportView.Loaded;
{Builds the header and footer from the field definition,
 and sets the current view.}
var
  S : string;
  {i : Integer;}
begin
  inherited Loaded;
  LoadCustomViews;
  if ActiveView <> '' then begin
    S := ActiveView;
    ActiveView := '';
    ActiveView := S;
  end;
  {for i := 0 to pred(Views.Count) do
    View[i].Dirty := False;}
end;

function TOvcCustomReportView.GetColumn(Index : Integer) : TOvcRvField;
{Get field by Index}
begin
  Result := TOvcRvField(Fields[Index]);
end;

function TOvcCustomReportView.GetView(Index : Integer) : TOvcRVView;
{Get view by Index}
begin
  Result := TOvcRVView(Views[Index]);
end;

function TOvcCustomReportView.GetColumnResize : Boolean;
{Get method for ColumnResize property}
begin
  Result := FRVHeader.AllowResize;
end;

procedure TOvcCustomReportView.SetColumnResize(Value : Boolean);
{Set method for ColumnResize property}
begin
  FRVHeader.AllowResize := Value;
end;

{
procedure TOvcCustomReportView.SetController(Value : TOvcController);
begin
  if Value <> FController then begin
    if (Value <> nil) then begin
      if HandleAllocated then
        FHoverTimer := Value.TimerPool.Add(HoverTimerEvent, 250);
    end else
      if FHoverTimer <> -1 then begin
        if Controller <> nil then
          if Controller.TimerPool <> nil then
            Controller.TimerPool.Remove(FHoverTimer);
        FHoverTimer := -1;
      end;
    inherited SetController(Value);
  end;
end;
}

function TOvcCustomReportView.GetGridLines : TOvcRVGridLines;
{Get method for GridLines property}
begin
  Result := FRVListBox.GridLines;
end;

procedure TOvcCustomReportView.SetGridLines(Value : TOvcRVGridLines);
{Set method for GridLines property}
begin
  FRVListBox.GridLines := Value;
end;

procedure TOvcCustomReportView.SetGroupColor(Value: TColor);
begin
  if Value <> FGroupColor then begin
    FGroupColor := Value;
    if (CurrentView <> nil) and IsGrouped then
      FRVListBox.FillColor := GroupColor
    else
      FRVListBox.FillColor := Options.ListColor;
    FRVListBox.Invalidate;
  end;
end;

procedure TOvcCustomReportView.SetHideSelection(const Value : Boolean);
begin
  if Value <> FHideSelection then begin
    FHideSelection := Value;
    FRVListBox.Invalidate;
  end;
end;

function TOvcCustomReportView.GetMultiSelect : Boolean;
{Get method for MultiSelect property}
begin
  Result := FRVListBox.MultiSelect;
end;

procedure TOvcCustomReportView.SetMultiSelect(Value : Boolean);
{Set method for MultiSelect property}
begin
  FRVListBox.MultiSelect := Value;
  IsMultiSelect := Value;
end;

procedure TOvcCustomReportView.DoEnumEvent(Data: Pointer;
  var Stop: boolean; UserData: Pointer);
begin
  if assigned(FOnEnumerate) then
    FOnEnumerate(Self, Data, Stop, UserData);
end;

function TOvcCustomReportView.DoFilter(View: TOvcAbstractRvView;
  Data: Pointer): Boolean;
begin
  if Searching then
    Result := True
  else
    if TOvcRvView(View).Filter <> '' then
      Result := TOvcRvView(View).Include(Data)
    else
      Result := inherited DoFilter(View, Data);
end;

{ new}
function TOvcCustomReportView.DoGetFieldAsFloat(Data: Pointer;
  Field: Integer): Double;
var
  F: TOvcRvField;
begin
  F := Self.Field[Field];
  if F.Expression <> '' then
    Result := F.GetValue(Data)
  else
    Result := inherited DoGetFieldAsFloat(Data, Field);
end;

function TOvcCustomReportView.DoGetGroupString(ViewField : TOvcRvViewField; GroupRef : TOvcRvIndexGroup) : string;
{Default group string function}
begin
  if ViewField.Aggregate <> '' then
    Result := ViewField.AggExp.GetValue(GroupRef)
  else
    if assigned(FOnGetGroupString) then
      FOnGetGroupString(Self, ViewField.Field.Index, GroupRef, Result)
    else
      Result := format('[%d]',[ViewField.Field.Index]);
end;

procedure TOvcCustomReportView.ResizeColumn;
{Change field definition widths based on header}
var
  I,W: Integer;
begin
  for I := 0 to CurrentView.ViewFields.Count - 1 do begin
    W := FRVHeader.Section[i].Width;
    CurrentView.ViewField[I].Width := W;
    if FooterPanel.Visible then
    {if FRVFooter.Visible then}
      FRVFooter.Section[i].Width := W;
  end;
end;

procedure TOvcCustomReportView.InitScrollInfo;
  {-setup scroll bar range and initial position}
begin
  if not HandleAllocated then
    Exit;

  SetHScrollRange;
  SetHScrollPos;
end;

procedure TOvcCustomReportView.HScrollPrim(Delta : Integer);
var
  SaveD : Integer;
begin
  SaveD := HScrollDelta;
  if Delta < 0 then
    if Delta > HScrollDelta then
      HScrollDelta := 0
    else
      Inc(HScrollDelta, Delta)
  else
    if Integer(HScrollDelta)+Delta > Integer(ClientExtra) then
      HScrollDelta := ClientExtra
    else
      Inc(HScrollDelta, Delta);

  if HScrollDelta < 0 then
    HScrollDelta := 0;

  if HScrollDelta <> SaveD then begin
    SetHScrollPos;
    PHResize(nil);
    PFResize(nil);
    FRVListBox.Invalidate;
  end;
end;

procedure TOvcCustomReportView.SetHScrollPos;
var
  SI : TScrollInfo;
begin
  if not HandleAllocated then
    Exit;
  with SI do begin
    cbSize := SizeOf(SI);
    fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
    nMin := 0;
    nMax := ClientExtra + ClientWidth - 1;
    nPage := ClientWidth;
    nPos := HScrollDelta;
    nTrackPos := nPos;
  end;
  SetScrollInfo(Handle, SB_HORZ, SI, True);
end;

procedure TOvcCustomReportView.SetHScrollRange;
var
  SI : TScrollInfo;
begin
  if rvHaveHS then
    begin
      with SI do
        begin
          fMask := SIF_PAGE + SIF_RANGE;
          nMin  := 1;
          nMax := ClientExtra + ClientWidth;
          nPage := ClientWidth;
          if Integer(nPage) >= nMax then
            nMax := 0;
          cbSize := SizeOf(SI);
        end;
      SetScrollInfo(Handle, SB_HORZ, SI, True);
    end;
end;

procedure TOvcCustomReportView.WMHScroll(var Msg : TWMHScroll);
begin
  case Msg.ScrollCode of
    SB_LINERIGHT : HScrollPrim(+(ClientExtra + ClientWidth) div 40);
    SB_LINELEFT  : HScrollPrim(-(ClientExtra + ClientWidth) div 40);
    SB_PAGERIGHT : HScrollPrim(+3 * (ClientExtra + ClientWidth) div 4);
    SB_PAGELEFT  : HScrollPrim(-3 * (ClientExtra + ClientWidth) div 4);
    SB_THUMBPOSITION, SB_THUMBTRACK :
      if HScrollDelta <> Msg.Pos then begin
        HScrollDelta := Msg.Pos;
        SetHScrollPos;
        PHResize(nil);
        PFResize(nil);
        FRVListBox.Invalidate;
      end;
  end;
end;

function TOvcCustomReportView.ViewNameByTitle(const Value : string) : string;
var
  i : Integer;
begin
  for i := 0 to pred(Views.Count) do
    if Value = View[i].Title then begin
      Result := View[i].Name;
      exit;
    end;
  Result := '';
end;

procedure TOvcRVListBox.DoOnSelect(Index : Integer; Selected : Boolean);
  {-notify of selection change}
type
  TBigBoolArray = array[0..pred(MaxInt)] of Boolean;
  PBigBoolArray = ^TbigBoolArray;
var
  LastIndex : Integer;
  SelState : PBigBoolArray;

  function SaveSelectState: PBigBoolArray;
  var
    i : Integer;
  begin
    GetMem(Result, lRows);
    for I := FTopIndex to LastIndex do
      Result^[I-FTopIndex] := ReportView.IsSelected[I-FTopIndex];
  end;

  procedure InvalidateChangedSelection(SelState : PBigBoolArray);
  var
    i : Integer;
  begin
    for I := FTopIndex to LastIndex do
      if SelState^[I-FTopIndex] <> ReportView.IsSelected[I-FTopIndex] then begin
        InvalidateItem(I);
      end;
    FreeMem(SelState,lRows);
  end;

begin
  if csDesigning in ComponentState then
    Exit;

  if InClick then exit;
  if ReportView.MultiSelect then begin

    {determine highest index to test}
    LastIndex := FTopIndex+Pred(lRows);
    if LastIndex > Pred(FNumItems) then
      LastIndex := Pred(FNumItems);
    if Index = -1 then begin
      SelState := SaveSelectState;
      ReportView.InternalSelectAll(Selected);
      InvalidateChangedSelection(SelState);
    end else begin
      if ReportView.IsSelected[Index] <> Selected then begin
        SelState := SaveSelectState;
        ReportView.IsSelected[Index] := Selected;
        InvalidateChangedSelection(SelState);
      end;
    end;
  end;
end;

procedure TOvcRVListBox.SimulatedClick;
begin
  IsSimulated := True;
  inherited SimulatedClick;
  IsSimulated := False;
end;

procedure TOvcRVListBox.Click;
{Click handler for the embedded listview}
{toggles a group expanded/collapsed when the view is grouped}
var
  Gx,Index : Integer;
  Pt           : TPoint;

  function PointToIndex(Y : Integer) : Integer;
  begin
    Result := -1;
    if (Y >= 0) and (Y < ClientHeight) then begin
      {convert to an index}
      Result := TopIndex+(Y div RowHeight);
      if ClientHeight mod RowHeight > 0 then
        if Result > TopIndex-1+lRows then
          Result := TopIndex-1+lRows;
    end;
  end;

var
  GRef : TOvcRvIndexGroup;
  SaveIdx : Integer;
begin
  if ReportView.IsBusy then exit;
  InClick := True;
  if not IsSimulated then
    if (NumItems <> 0) and ReportView.IsGrouped then begin
      GetCursorPos(Pt);
      Pt := ScreenToClient(Pt);
      Index := PointToIndex(Pt.Y);
      if Index <> -1 then begin
        if ReportView.IsGroup[Index] then begin
          Gx := ReportView.GroupField[Index];
          if (Gx > -1) and (Gx < NumItems) then
            if (not ReportView.FRVHeader.Visible and (Pt.X <= 100))
            xor (ReportView.FRVHeader.Visible and (Pt.X <= ReportView.FRVHeader.Section[Gx].PaintRect.Right)) then begin
              GRef := ReportView.GroupRef[Index];
              SaveIdx := ItemIndex;
              ReportView.Expanded[GRef] := not ReportView.Expanded[GRef];
              if ReportView.Expanded[GRef] then
                ReportView.MakeGroupVisible(GRef);
              if not ReportView.MultiSelect then
                if not ReportView.IsGroup[SaveIdx] then
                  if ReportView.CurrentItem <> nil then
                    ItemIndex := SaveIdx;
              InClick := False;
              inherited Click;
              exit;
            end;
        end;
      end;
    end;
  inherited Click;
  ReportView.Click;
  InClick := False;
end;

{
procedure TOvcRVListBox.WMMouseMove(var Msg : TWMMouseMove);
begin
  inherited;
  with ReportView do begin
    if FHoverTimer <> -1 then
      Controller.TimerPool.ResetElapsedTime(FHoverTimer);
    if (HintX <> Msg.XPos) and (HintY <> Msg.YPos) then begin
      if HintWindow.HandleAllocated and IsWindowVisible(HintWindow.Handle) then
        HideHint;
      HintShownHere := False;
    end;
    HintX := Msg.XPos;
    HintY := Msg.YPos;
  end;
end;
}

{ new}
procedure TOvcRVListBox.CMHintShow(var Message: TMessage);
var
  S: string;
begin
  with TCMHintShow(Message) do begin
    S := GetStringAtPos(HintInfo.CursorPos);
    if S <> '' then begin
      TCMHintShow(Message).HintInfo.HintStr := S;
      TCMHintShow(Message).HintInfo.HintPos := ClientToScreen(HintRect.TopLeft);
      TCMHintShow(Message).HintInfo.CursorRect := HintRect;
    end;
  end;
end;

procedure TOvcRVListBox.WMLButtonDown(var Msg : TWMLButtonDown);
var
  Gx,
  Index : Integer;
  Pt    : TPoint;

  function PointToIndex(Y : Integer) : Integer;
  begin
    Result := -1;
    if (Y >= 0) and (Y < ClientHeight) then begin
      {convert to an index}
      Result := TopIndex+(Y div RowHeight);
      if ClientHeight mod RowHeight > 0 then
        if Result > TopIndex-1+lRows then
          Result := TopIndex-1+lRows;
    end;
  end;

begin
  if (NumItems <> 0) and ReportView.IsGrouped then begin
    GetCursorPos(Pt);
    Pt := ScreenToClient(Pt);
    Index := PointToIndex(Pt.Y);
    if Index <> -1 then begin
      if ReportView.IsGroup[Index] then begin
        Gx := ReportView.GroupField[Index];
        if (Gx > -1) and (Gx < NumItems) then
          if (not ReportView.FRVHeader.Visible and (Pt.X <= 100))
          xor (ReportView.FRVHeader.Visible and (Pt.X <= ReportView.FRVHeader.Section[Gx].PaintRect.Right)) then begin
            MousePassThru := True;
            inherited;
            MousePassThru := False;
            exit;
          end;
      end;
    end;
  end;
  inherited;
end;

procedure TOvcCustomReportView.ScaleColumnWidths;
const
  MaxColCount = 4096;
type
  TIntArray = array[0..pred(MaxColCount)] of Integer;
  PIntArray = ^TIntArray;
var
  ColWidths : PIntArray;
  FieldRef: TList;
  GroupCount, ColCount, i, j : Integer;
  Data : Pointer;
begin
  {for the current view}
  if CurrentView <> nil then begin
    {get the number of view columns}
    ColCount := CurrentView.ViewFields.Count;
    {get the number of grouped columns in the view}
    GroupCount := CurrentView.GroupCount;
    ColWidths := nil;
    FieldRef := nil;
    try
      {allocate array for the column widths}
      GetMem(ColWidths, ColCount * SizeOf(Integer));
      {allocate array for the global field index for each view field}
      FieldRef := TList.Create;
      FieldRef.Count := ColCount;
      for i := 0 to pred(ColCount) do begin
        {If field is owner-draw, we can't compute the size but have to stick
         with the specified value.}
        if CurrentView.ViewField[i].OwnerDraw then
          FieldRef[i] := nil
        else begin
          {i is field index in the view, but we need to use the absolute
            field index for reading the data values below}
          FieldRef[i] := CurrentView.ViewField[i].Field;
          {column width should be at least the width of the caption
           plus sort glyph}
          ColWidths^[i] :=
          FRVListBox.
            Canvas.TextWidth(CurrentView.ViewField[i].Field.Caption)
              + HeaderGlyphList.Width;
        end;
      end;
      {for each data item}
      for i := 0 to pred(Lines) do begin
        Data := ItemData[i];
        {for each view field}
        for j := 0 to pred(ColCount) do
          if FieldRef[j] <> nil then
            if j < GroupCount then
              {if column is grouped, use a fixed width of 10}
              ColWidths^[j] := 10
            else
              {adjust for widest string}
              ColWidths^[j] := MaxI(ColWidths^[j],
                FRVListBox.
                  Canvas.TextWidth(TOvcRvField(FieldRef[j]).AsString(Data)));
      end;

      {adjust for totals}
      for i := GroupCount to pred(ColCount) do
        if CurrentView.ViewField[i].ComputeTotals then
          ColWidths^[i] := MaxI(ColWidths^[i],
            FRVListBox.
              Canvas.TextWidth(
                DoGetGroupString(CurrentView.ViewField[i],
                  TotalRef)));

      {apply the maximum width to each column}
      {add the width of a "W" to account for overhead in each column}
      for i := 0 to pred(ColCount) do
        if FieldRef[i] <> nil then
          CurrentView.ViewField[i].Width :=
            ColWidths^[i] +
              FRVListBox.
                Canvas.TextWidth('W');
    finally
      if ColWidths <> nil then
        FreeMem(ColWidths, ColCount * SizeOf(Integer));
      FieldRef.Free;
    end;
  end;
end;

procedure TOvcCustomReportView.LoadCustomViews;
var
  i, Count, P : Integer;
  OldView, NewView : TOvcRvView;
  OldField,NewField: TOvcRvField;
  FieldKey, FieldName,
  SaveCurrent, ViewKey, ViewName : string;
  OldDFMBased: Boolean;
begin
  if csDesigning in ComponentState then
    exit;
  SaveCurrent := ActiveView;
  LoadingViews := True;
  try
    if Assigned(CustomViewStore) then begin
      CustomViewStore.Open;
      try
        Count := CustomViewStore.ReadInteger(Name + '_CustomFields', 'Count', 0);
        for i := 0 to pred(Count) do begin
          FieldKey := CustomViewStore.ReadString(Name + '_CustomFields', 'f'+IntToStr(i), '');
          if FieldKey <> '' then begin
            P := pos('_CF_', FieldKey);
            FieldName := copy(FieldKey, P + length('_CF_'), MaxInt);
            OldField := TOvcRvField(Fields.ItemByName(FieldName));
            if OldField <> nil then begin
              OldDFMBased := OldField.FDFMBased;
              OldField.FDFMBased := False; {allow free}
              OldField.Free;
            end else
              OldDFMBased := False;
            NewField := Fields.Add;
            NewField.Name := FieldName;
            NewField.LoadFromStorage(CustomViewStore, FieldKey);
            NewField.FDFMBased := OldDFMBased;
          end;
        end;
        Count := CustomViewStore.ReadInteger(Name + '_CustomViews', 'Count', 0);
        for i := 0 to pred(Count) do begin
          ViewKey := CustomViewStore.ReadString(Name + '_CustomViews', 'v'+IntToStr(i), '');
          if ViewKey <> '' then begin
            P := pos('_CV_', ViewKey);
            ViewName := copy(ViewKey, P + length('_CV_'), MaxInt);
            OldView := TOvcRvView(Views.ItemByName(ViewName));
            if OldView <> nil then begin
              OldDFMBased := OldView.FDFMBased;
              OldView.FDFMBased := False; {allow free}
            end else
              OldDFMBased := False;
            OldView.Free;
            NewView := Views.Add;
            NewView.Name := ViewName;
            NewView.LoadFromStorage(CustomViewStore, ViewKey);
            NewView.FDFMBased := OldDFMBased;
          end;
        end;
      finally
        CustomViewStore.Close;
      end;
    end;
  finally
    LoadingViews := False;
    DoChangeNotification(rvViewDestroy);
    DoChangeNotification(rvViewCreate);
    ActiveView := SaveCurrent;
  end;
end;

procedure TOvcCustomReportView.SaveDirtyViews;
var
  i, c: Integer;
  FieldKey, ViewKey : string;
  AnyDirty: Boolean;
begin
  if csDesigning in ComponentState then
    exit;
  AnyDirty := False;
  for i := 0 to Fields.Count - 1 do
    if Field[i].Dirty then begin
      AnyDirty := True;
      break;
    end;
  if ViewDeleted then
    AnyDirty := True
  else
  if not AnyDirty then
    for i := 0 to Views.Count - 1 do
      if View[i].Dirty then begin
        AnyDirty := True;
        break;
      end;
  if not AnyDirty then
    exit;
  if not assigned(CustomViewStore) then
    exit;
  CustomViewStore.Open;
  try
    c := 0;
    for i := 0 to Fields.Count - 1 do
      if Field[i].Expression <> '' then
        inc(c);
    CustomViewStore.WriteInteger(Name + '_CustomFields', 'Count', c);
    c := 0;
    for i := 0 to Fields.Count - 1 do
      if Field[i].Expression <> '' then begin
        FieldKey := Name + '_CF_' + Field[i].Name;
        CustomViewStore.WriteString(Name + '_CustomFields', 'f'+IntToStr(c), FieldKey);
        CustomViewStore.EraseSection(FieldKey);
        Field[i].SaveToStorage(CustomViewStore, FieldKey);
        Field[i].Dirty := False;
        inc(c);
      end;
    CustomViewStore.WriteInteger(Name + '_CustomViews', 'Count', Views.Count);
    for i := 0 to Views.Count - 1 do begin
      ViewKey := Name + '_CV_' + View[i].Name;
      CustomViewStore.WriteString(Name +'_CustomViews', 'v'+IntToStr(i), ViewKey);
        CustomViewStore.EraseSection(ViewKey);
      View[i].SaveToStorage(CustomViewStore, ViewKey);
      View[i].Dirty := False;
    end;
  finally
    CustomViewStore.Close;
  end;
end;

procedure TOvcCustomReportView.ScaleColumn(C: Integer);
var
  ColWidth : Integer;
  FieldRef: TOvcRvField;
  GroupCount, i : Integer;
  Data : Pointer;
begin
  {for the current view}
  if CurrentView <> nil then begin
    if CurrentView.ViewField[C].OwnerDraw then
      exit;
    {get the number of grouped columns in the view}
    GroupCount := CurrentView.GroupCount;
    FieldRef := CurrentView.ViewField[C].Field;
    {column width should be at least the width of the caption
     plus sort glyph}
    ColWidth := FRVListBox.
      Canvas.TextWidth(CurrentView.ViewField[C].Field.Caption)
      + HeaderGlyphList.Width;
    if C < GroupCount then
      {if column is grouped, use a fixed width of 10}
      ColWidth := 10
    else begin
      {for each data item}
      for i := 0 to pred(Lines) do begin
        Data := ItemData[i];
        {adjust for widest string}
        ColWidth := MaxI(ColWidth,
          FRVListBox.
            Canvas.TextWidth(FieldRef.Asstring(Data)));
      end;
    end;

    {adjust for totals}
    if CurrentView.ViewField[C].ComputeTotals then
      ColWidth := MaxI(ColWidth,
        FRVListBox.
          Canvas.TextWidth(
            DoGetGroupString(CurrentView.ViewField[C],
              TotalRef)));

    {apply the maximum width to each column}
    {add the width of a "W" to account for overhead in each column}
    CurrentView.ViewField[C].Width :=
      ColWidth +
        FRVListBox.
          Canvas.TextWidth('W');
  end;
end;

procedure TOvcCustomReportView.ScaleColumnWidthsForPrint;
type
  TIntArray = array[0..pred(MaxInt div sizeof(Integer))] of Integer;
  PIntArray = ^TIntArray;
var
  ColWidths : PIntArray;
  FieldRef: TList;
  GroupCount, ColCount, i, j : Integer;
  Data : Pointer;
begin
  {for the current view}
  if CurrentView <> nil then begin
    {get the number of view columns}
    ColCount := CurrentView.ViewFields.Count;
    {get the number of grouped columns in the view}
    GroupCount := CurrentView.GroupCount;
    ColWidths := nil;
    FieldRef := nil;
    try
      {allocate array for the column widths}
      GetMem(ColWidths, ColCount * SizeOf(Integer));
      {allocate array for the global field index for each view field}
      FieldRef := TList.Create;
      FieldRef.Count := ColCount;
      for i := 0 to pred(ColCount) do begin
        {If field is owner-draw, we can't compute the size but have to stick
         with the specified value.}
        if CurrentView.ViewField[i].OwnerDraw then
          FieldRef[i] := nil
        else begin
          {column width should be at least the width of the caption}
          ColWidths^[i] := Printer.Canvas.TextWidth(CurrentView.ViewField[i].Field.Caption);
          {i is field index in the view, but we need to use the absolute
            field index for reading the data values below}
          FieldRef[i] := CurrentView.ViewField[i].Field;
        end;
      end;
      {for each data item}
      for i := 0 to pred(Lines) do begin
        Data := ItemData[i];
        {for each view field}
        for j := 0 to pred(ColCount) do
          if FieldRef[j] <> nil then
            if j < GroupCount then
              {if column is grouped, use a fixed width of 10}
              ColWidths^[j] := 10
            else
              {adjust for widest string}
              ColWidths^[j] := MaxI(ColWidths^[j],
                Printer.Canvas.TextWidth(
                  TOvcRvField(FieldRef[j]).AsString(Data)));
      end;

      {adjust for totals}
      for i := GroupCount to pred(ColCount) do
        if CurrentView.ViewField[i].ComputeTotals then
          ColWidths^[i] := MaxI(ColWidths^[i],
            Printer.Canvas.TextWidth(
              DoGetGroupString(CurrentView.ViewField[i],
                TotalRef)));

      {apply the maximum width to each column}
      {ColWidths is in pixels. To convert that to TWIPS, multiply by 1440 and
       divide by the PixelsPerInch value for the canvas/font.}
      {add the width of two "W"s to account for overhead in each column}
      j := Printer.Canvas.TextWidth('WW');
      for i := 0 to pred(ColCount) do
        if FieldRef[i] <> nil then
          CurrentView.ViewField[i].PrintWidth :=
            PixelsToTwips(ColWidths^[i] + j);
    finally
      if ColWidths <> nil then
        FreeMem(ColWidths, ColCount * SizeOf(Integer));
      FieldRef.Free;
    end;
  end;
end;

procedure TOvcCustomReportView.AssignStructure(Source: TOvcCustomReportView);
{- replace all fields and views from another report view}
begin
  {delete existing views}
  Views.Clear;
  {delete existing fields}
  Fields.Clear;
  {copy fields from source}
  Fields.Assign(Source.Fields);
  {copy views from source}
  Views.Assign(Source.Views);
  OnExtern := Source.OnExtern;
end;

procedure TOvcCustomReportView.ReplaceView(const Name: string; NewDefinition: TOvcRvView);
{- replace a specific view from another report view
   used by the view editor to apply the changed view layout}
var
  NewView : TOvcRvView;
  OldView : TOvcRvView;
begin
  OldView := TOvcRvView(Views.ItemByName(Name));
  OldView.FDFMBased := False; {to allow free}
  OldView.Free;
  {Views.ItemByName(Name).Free;}
  NewView := TOvcRvView(Views.Add);
  NewView.Assign(NewDefinition);
end;

procedure TOvcCustomReportView.SaveViewToStorage(
  Storage: TOvcAbstractStore; View: TOvcRvView);
{- save a view definition in a storage container}
begin
  Storage.Open;
  try
    Storage.EraseSection(Name);
    View.SaveToStorage(Storage, Name);
  finally
    Storage.Close;
  end;
end;

procedure TOvcCustomReportView.BeginUpdate;
{Lock control. Used for lengthy updates to prevent premature painting.
 Must be matched with a call to EndUpdate.}
begin
  InternalBeginUpdate(True);
end;

procedure TOvcCustomReportView.CenterCurrentLine;
{- center the currently selected line (if any) on screen}
begin
  if CurrentItem <> nil then
    FRVListBox.CenterCurrentLine;
end;

procedure TOvcCustomReportView.Click;
begin
  if {(FRVListBox.ItemIndex <> -1) and} Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TOvcCustomReportView.DblClick;
begin
  if assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

procedure TOvcCustomReportView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Style or DWord(BorderStyles[FBorderStyle]);
    if FScrollBars in [ssHorizontal, ssBoth] then
      Style := Style or DWord(ScrollBarStyles[ssHorizontal]);
  end;

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcCustomReportView.DoKeySearch(FieldIndex : Integer;const SearchString : string);
begin
  Searching := True;
  try
    if not assigned(FOnKeySearch) then
      raise EReportViewError.Create(SCOnKeySearchNotAssigned,0);
    FOnKeySearch(Self,FieldIndex,SearchString);
  finally
    Searching := False;
  end;
end;

procedure TOvcCustomReportView.EndUpdate;
{Ends an update cycle started with BeginUpdate. Invalidates the control.}
begin
  InternalEndUpdate(True);
end;

function TOvcCustomReportView.GetCurrentGroup : TOvcRvIndexGroup;
{Get method for the CurrentGroup property.
 Returns pointer to the currently selected group (if any)}
begin
  if FRVListBox.ItemIndex = -1 then
    Result := nil
  else
    if IsGroup[FRVListBox.ItemIndex] then
      Result := GroupRef[FRVListBox.ItemIndex]
    else
      Result := nil;
end;

function TOvcCustomReportView.GetCurrentItem : Pointer;
{Get method for the CurrentItem property.
 Returns data pointer for the currently selected item.}
begin
  if FRVListBox.ItemIndex = -1 then
    Result := nil
  else
    if not Assigned(FActiveIndex) then
      Result := nil
    else
      if IsGroup[FRVListBox.ItemIndex] then
        Result := nil
      else
        Result := ItemData[FRVListBox.ItemIndex];
end;

function TOvcCustomReportView.GetField(Index : Integer) : TOvcRvField;
begin
  Result := TOvcRvField(inherited GetField(Index));
end;

function TOvcCustomReportView.GetFieldClassType : TOvcCollectibleClass;
begin
  Result := TOvcRvField;
end;

function TOvcCustomReportView.GetViewClassType : TOvcCollectibleClass;
begin
  Result := TOvcRvView;
end;

function TOvcCustomReportView.GetOnKeyUp : TKeyEvent;
begin
  Result := FRVListBox.OnKeyUp;
end;

function TOvcCustomReportView.GetOnKeyDown : TKeyEvent;
begin
  Result := FRVListBox.OnKeyDown;
end;

function TOvcCustomReportView.GetOnMouseDown : TMouseEvent;
begin
  Result := FRVListBox.OnMouseDown;
end;

function TOvcCustomReportView.GetOnMouseMove : TMouseMoveEvent;
begin
  Result := FRVListBox.OnMouseMove;
end;

function TOvcCustomReportView.GetOnMouseUp : TMouseEvent;
begin
  Result := FRVListBox.OnMouseUp;
end;

function TOvcCustomReportView.GetPopup : TPopupMenu;
begin
  Result := FRVListBox.PopupMenu;
end;

function TOvcCustomReportView.GetPrinting: Boolean;
begin
  Result := InPrint > 0;
end;

function TOvcCustomReportView.GetPrintAreaHeight: Integer;
begin
  Result := PrintPageHeight
    - TwipsToPixels(PrinterProperties.MarginTop)
    - TwipsToPixels(PrinterProperties.MarginBottom);
end;

function TOvcCustomReportView.GetPrintAreaWidth: Integer;
begin
  Result := PrintPageWidth
    - TwipsToPixels(PrinterProperties.MarginLeft)
    - TwipsToPixels(PrinterProperties.MarginRight);
end;

function TOvcCustomReportView.GetPrintPageHeight: Integer;
begin
  Result := Printer.PageHeight;
end;

function TOvcCustomReportView.GetPrintPageWidth: Integer;
begin
  Result := Printer.PageWidth;
end;

function TOvcCustomReportView.GetPrintStartLeft: Integer;
begin
  Result := TwipsToPixels(PrinterProperties.MarginLeft);
end;

function TOvcCustomReportView.GetPrintStartTop: Integer;
begin
  Result := TwipsToPixels(PrinterProperties.MarginTop);
end;

function TOvcCustomReportView.GetPrintStopBottom: Integer;
begin
  Result := PrintPageHeight - TwipsToPixels(PrinterProperties.MarginBottom);
end;

function TOvcCustomReportView.GetPrintStopRight: Integer;
begin
  Result := PrintPageWidth - TwipsToPixels(PrinterProperties.MarginRight);
end;

procedure TOvcCustomReportView.SetDragMode(Value: TDragMode);
begin
  inherited;
  FRVListBox.DragMode := Value;
end;

function TOvcCustomReportView.GetSortDescending : Boolean;
begin
  Result := InternalSortColumn < 0;
end;

function TOvcCustomReportView.GetSortColumn : Integer;
begin
  Result := abs(InternalSortColumn) - 1;
end;

function TOvcCustomReportView.GetSmoothScroll : Boolean;
{Get method for the SmoothScroll property}
begin
  Result := FRVListBox.SmoothScroll;
end;

function TOvcCustomReportView.GetGroupElement(G: TOvcRvIndexGroup): Pointer;
begin
  if G.Count = 0 then
    Result := nil
  else
  if G.ContainsGroups then
    Result := GetGroupElement(G.Element[0])
  else
    Result := G.Element[0];
end;

procedure TOvcCustomReportView.GotoNearest(DataRef: Pointer);
begin
  if DataRef = nil then
    CurrentItem := nil
  else
    FRVListBox.ItemIndex := Find(DataRef);
  FRVListBox.lAnchor := FRVListBox.ItemIndex;
end;

{
procedure TOvcCustomReportView.HideHint;
begin
  if (HintWindow <> nil) then
    HintWindow.ReleaseHandle;
end;
}

function TOvcCustomReportView.ItemAtPos(Pos : TPoint) : Pointer;
{- Return Item at Pos in embedded listbox. Typically used with
         popup menus}
var
  IX : Integer;
begin
  IX := FRVListBox.ItemAtPos(Pos, False);
  if IX <> -1 then
    Result := ItemData[IX]
  else
    Result := nil;
end;

procedure TOvcCustomReportView.ListKeyPress(Sender: TObject; var Key: Char);
{OnKeyPress event handler for the embedded listview.
 Does group collapse/expand based on keys.}
var
  GrRef : TOvcRvIndexGroup;
  KeyTime : Integer;
  SaveIdx : Integer;
  ExtKeyString : string;
begin
  case Key of
  #0..#12, #14..#26, #28..#31 :;
  #27 :
    begin
      CurrentItem := nil;
      FRVListBox.Click;
    end;
  ' ','+','-',#13 :
    if FRVListBox.ItemIndex <> -1 then begin
      if IsGroup[FRVListBox.ItemIndex] then begin
        SaveIdx := FRVListBox.ItemIndex;
        GrRef := GroupRef[FRVListBox.ItemIndex];
        case Key of
        ' ',#13 :
            Expanded[GrRef] := not Expanded[GrRef];
        '+' :
          Expanded[GrRef] := True;
        '-' :
          Expanded[GrRef] := False;
        end;
        if Expanded[GrRef] then
          MakeGroupVisible(GrRef);
        Key := #0;
        FRVListBox.ItemIndex := SaveIdx;
        exit;
      end;
    end;
  else {'0'..#255 :}
    if KeySearch then begin
      if (CurrentView = nil) or IsGrouped then begin
        MessageBeep(MB_ICONHAND);
        exit;
      end;
      KeyTime := GetTickCount;
      if (KeyTime - LastKeyTime) > KeyTimeout then
        KeyString := Key
      else
        KeyString := KeyString + Key;
      if InternalSortColumn < 0 then begin
        SetLength(ExtKeyString,255);
        fillchar(ExtkeyString[1],255 * SizeOf(Char),#255);
        move(KeyString[1],ExtKeyString[1],length(KeyString) * SizeOf(Char));
      end else
        ExtKeyString := KeyString;
      LastKeyTime := KeyTime;
      {if CurrentView <> nil then}
      DoKeySearch(CurrentView.ViewField[abs(InternalSortColumn) - 1].Field.Index,ExtKeyString);
      Key := #0;
      exit;
    end;
  end;
  if assigned(FOnKeyPress) then
    FOnKeyPress(Sender,Key);
end;

procedure TOvcCustomReportView.DoBusy(SetOn : Boolean);
{Generate the OnSignalBusy event}
begin
  if not LockUpdate and assigned(FOnSignalBusy) then
    FOnSignalBusy(Self,SetOn);
end;

procedure TOvcCustomReportView.DoChangeNotification(Event : TRvChangeEvent);
var
  i : Integer;
begin
  if (Event = rvViewSelect) and Assigned(FOnViewSelect) then
    FOnViewSelect(Self);
  if LoadingViews then exit;
  for i := pred(ChangeNotificationList.Count) downto 0 do
    TChangeNotification(ChangeNotificationList[i]).Event(Self, Event);
end;

procedure TOvcCustomReportView.DoDrawViewField(Canvas : TCanvas; Data : Pointer;
      Field : TOvcRvField; ViewField : TOvcRvViewField; TextAlign : Integer;
      IsSelected, IsGroup : Boolean;
      ViewFieldIndex : Integer; Rect : TRect; const Text, TruncText : string);
var
  P : PChar;
  DefaultDrawing : Boolean;
begin
  if csDesigning in ComponentState then begin
    DrawText(Canvas.Handle, '<owner-draw>', -1, Rect, TextAlign);
  end else begin
    SaveFont.Assign(Canvas.Font);
    if assigned(FOnDrawViewFieldEx) then begin
      DefaultDrawing := True;
      FOnDrawViewFieldEx(Self, Canvas, Field, ViewField, TextAlign, IsSelected,
        IsGroup, Data, Rect, Text, TruncText, DefaultDrawing);
      if DefaultDrawing then begin
        P := PChar(TruncText);
        DrawText(Canvas.Handle, P, Strlen(P), Rect, TextAlign);
      end;
    end else
    if assigned(FOnDrawViewField) then
      FOnDrawViewField(Self, Canvas, Data, ViewFieldIndex, Rect, TruncText);
    Canvas.Font.Assign(SaveFont);
  end;
end;

procedure TOvcCustomReportView.DoLinesChanged(LineDelta: Integer; Offset: Integer);
var
  InvalidatePending : Boolean;
begin
  if FActiveView = '' then exit;
  if csDestroying in ComponentState then exit;
  if Offset = -1 then begin
    FRVListBox.NumItems := Lines;
    InvalidatePending := True;
  end else begin
    if CollapseEvent then
      FRVListBox.ItemIndex := -1;
    if LineDelta < 0 then
      FRVListBox.DeleteItemsAt(abs(LineDelta),Offset)
    else
      FRVListBox.InsertItemsAt(LineDelta,Offset);
    if (Offset > 0) and IsGroup[Offset-1] then
      FRVListBox.InvalidateItem(Offset-1); { invalidate group line}
    InvalidatePending := False;
  end;
  if SaveCurItem <> nil then begin
    Offset := OffsetOfData[SaveCurItem];
    if not CollapseEvent then begin
      if (Offset = -1) {and not CollapseEvent} then begin
        InternalMakeVisible(SaveCurItem);
        FRVListBox.NumItems := Lines;
        InvalidatePending := True;
        Offset := OffsetOfData[SaveCurItem];
      end;
      if (Offset <> -1) and not IsGroup[Offset] then begin
        {FRVListBox.ItemIndex := OffsetOfData[SaveCurItem];}
        FRVListBox.InternalSetItemIndex(OffsetOfData[SaveCurItem], False);
        if AutoCenter then
          FRVListBox.CenterCurrentLine;
      end else begin
        FRVListBox.ItemIndex := -1;
        {FRVListBox.TopIndex := 0;}
      end;
    end;
  end else begin
    FRVListBox.ItemIndex := -1;
    if AutoReset then
      FRVListBox.TopIndex := 0;
  end;
  if not DelayedBinding then
    FRVFooter.UpdateSections;
  if InvalidatePending and not LockUpdate then
    FRVListBox.Invalidate;
end;

procedure TOvcCustomReportView.DoLinesWillChange;
begin
  CollapseEvent := False;
  if FRVListBox.ItemIndex <> -1 then begin
    if IsGroup[FRVListBox.ItemIndex] then begin
      SaveCurItem := nil;
      {FRVListBox.ItemIndex := -1;}
      FRVListBox.InternalSetItemIndex(-1, False);
    end else
      SaveCurItem := ItemData[FRVListBox.ItemIndex];
  end else
    SaveCurItem := nil;
end;

procedure TOvcCustomReportView.DoSortingChanged;
begin
  if Assigned(FOnSortingChanged) then
    FOnSortingChanged(Self);
end;

procedure TOvcCustomReportView.Enumerate(UserData : Pointer);
{Enumerates all items.
 Calls OnEnumerate for each item. Does not return groups.}
begin
  if not Assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumNotAssigned,0);
  DoEnumerate(UserData);
end;

procedure TOvcCustomReportView.EnumerateSelected(UserData : Pointer);
{Enumerates selected items when multiselect is enabled.
 Calls OnEnumSelected for each one. Does not return groups.}
begin
  if not MultiSelect then
    raise ENotMultiSelect.Create(SCNotMultiSelect,0);
  if not assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumSelectedNA,0);
  DoEnumerateSelected(UserData);
end;

procedure TOvcCustomReportView.EnumerateEx(Backwards, SelectedOnly: Boolean;
  StartAfter: Pointer; UserData : Pointer);
begin
  if SelectedOnly and not MultiSelect then
    raise ENotMultiSelect.Create(SCNotMultiSelect,0);
  if not assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumSelectedNA,0);
  DoEnumerateEx(Backwards, SelectedOnly, StartAfter, UserData);
end;

function TOvcCustomReportView.GetIsGrouped : Boolean;
begin
  Result := (CurrentView <> nil) and (CurrentView.GroupCount > 0);
end;

(* !!.02
procedure TOvcCustomReportView.HoverTimerEvent(Sender : TObject; Handle : Integer;
                         Interval : Cardinal; ElapsedTime : Integer);
{display/hide hint with truncated text}
var
  S : string;
  Sc : TPoint;
  R : TRect;
begin
  if HintShownHere
  or not OvcRptVwShowTruncTextHint
  or not HandleAllocated
  or not HasParent then exit;

  GetCursorPos(Sc);
  Sc := ScreenToClient(Sc);

  if not Parent.Visible
  or LockUpdate
  or not Application.Active
  or (Sc.x < 0) or (Sc.y < 0) or (Sc.x > Width) or (Sc.y > height)
  or (csDestroying in ComponentState) then begin
    HideHint;
    exit;
  end;
  if ActiveIndex = nil then
    exit;
  if (Controller.TimerPool.ElapsedTime[FHoverTimer] > 100) then begin
    S := FRVListBox.GetStringAtPos(Point(HintX,HintY));
    if S <> '' then begin
      if not IsWindowVisible(HintWindow.Handle) then begin
        R := Rect(0, 0, Screen.Width, 0);
        DrawText(HintWindow.Canvas.Handle, PChar(S), -1, R, DT_CALCRECT
          or DT_LEFT or DT_WORDBREAK or DT_NOPREFIX);

        Sc := ClientToScreen(Point(HintX,HintY));
        R := Rect(Sc.X - R.Right div 2 - 4,
          Sc.Y + 2,Sc.X + R.Right div 2 + 4,Sc.Y + R.Bottom + 2);
        OffsetRect(R, 0, R.Bottom - R.Top);
        HintWindow.ActivateHint(R, S);
        exit;
      end;
    end;
    if (Controller.TimerPool.ElapsedTime[FHoverTimer] > 3000)
    and HintWindow.HandleAllocated and IsWindowVisible(HintWindow.Handle) then begin
      HideHint;
      HintShownHere := True;
    end;
  end;
end;
*)

function TOvcCustomReportView.IsEmpty : Boolean;
begin
  Result :=  FRawData.Empty;
end;

procedure TOvcCustomReportView.InternalBeginUpdate(LockIndexer : Boolean);
{Lock control. Used for lengthy updates to prevent premature painting.
 Must be matched with a call to EndUpdate.}
begin
  if UpdateCount = 0 then begin
    DoBusy(True);
    Enabled := False;
    if LockIndexer then
      BeginUpdateIndex;
    FRVListBox.BeginUpdate;
  end;
  inc(UpdateCount);
end;

procedure TOvcCustomReportView.InternalEndUpdate(UnlockIndexer : Boolean);
{Ends an update cycle started with BeginUpdate. Invalidates the control.}
begin
  if UpdateCount > 1 then
    dec(UpdateCount)
  else begin
    UpdateCount := 0;
    if UnlockIndexer then
      EndUpdateIndex;
    FRVListBox.EndUpdate;
    FRVListBox.Invalidate;
    if FooterPanel.Visible then
    {if FRVFooter.Visible then}
      FRVFooter.Invalidate;
    DoBusy(False);
    Enabled := True;
  end;
end;

procedure TOvcCustomReportView.ListDblClick(Sender : TObject);
{OnDblClick event handler for the embedded listview.
 Expands/collapses groups.}
var
  GrRef : TOvcRvIndexGroup;
  SaveIdx : Integer;
begin
  if FRVListBox.ItemIndex = -1 then exit;
  if IsGroup[FRVListBox.ItemIndex] then begin
    GrRef := GroupRef[FRVListBox.ItemIndex];
    SaveIdx := FRVListBox.ItemIndex;
    Expanded[GrRef] := not Expanded[GrRef];
    if Expanded[GrRef] then
      MakeGroupVisible(GrRef);
    FRVListBox.ItemIndex := SaveIdx;
    exit;
  end;

  DblClick;
end;

procedure TOvcCustomReportView.LoadColumnWidths;
var
  i : Integer;
  F : TWinControl;
begin
  if CurrentView = nil then exit;
  F := GetImmediateParentForm(Self);
  if assigned(F) then
    ColWidthKey := format('%s.%s.%s',[F.Name,Name,CurrentView.Name])
  else
    ColWidthKey := format('%s.%s',[Name,CurrentView.Name]);

  if (FieldWidthStore <> nil)
  and assigned(FCurrentView)
  and not (csDesigning in ComponentState) then begin

    FieldWidthStore.Open;
    try

      for i := 0 to pred(CurrentView.ViewFields.Count) do
        CurrentView.ViewField[i].Width := FieldWidthStore.ReadInteger(ColWidthKey,IntToStr(i),CurrentView.ViewField[i].Width);
    finally
      FieldWidthStore.Close;
    end;
  end;
end;

function TOvcCustomReportView.LockUpdate : Boolean;
{Return true if an update is in progress}
begin
  Result := UpdateCount > 0;
end;

procedure TOvcCustomReportView.MakeGroupVisible(GRef : TOvcRvIndexGroup);
begin
  PostMessage(Handle, OM_MakeGroupVisible, 0, Integer(GRef));
end;

procedure TOvcCustomReportView.WMMakeGroupVisible(var Msg : TMessage);
var
  GRef : TOvcRvIndexGroup;
  GIX, DBX, BX, DTX : Integer;
begin
  Update;
  GRef := TOvcRvIndexGroup(Msg.lParam);
  GIX := GetOffsetOfGroup(GRef) - 1;
  if GIX >= 0 then begin
    DBX := GIX + GRef.Count;
    BX := FRVListBox.TopIndex + FRVListBox.lRows - 1;
    if DBX > BX then begin
      DTX := FRVListBox.TopIndex + (DBX - BX);
      if (DTX < 0) or (DTX > GIX) then
        FRVListBox.TopIndex := GIX
      else
        FRVListBox.TopIndex := DTX;
    end;
  end;
end;

procedure TOvcCustomReportView.Navigate(NewPosition : TRvCurrentPosition);
var
  I : Integer;
  P : Pointer;
begin
  case NewPosition of
  rvpMoveToFirst :
    CurrentItem := ItemData[0];
  rvpMoveToLast :
    CurrentItem := ItemData[Lines - 1];
  rvpMoveToNext :
    if CurrentItem <> nil then begin
      I := OffSetOfData[CurrentItem];
      if I < Lines - 1 then
        CurrentItem := ItemData[I + 1];
    end;
  rvpMoveToPrevious :
    if CurrentItem <> nil then begin
      I := OffSetOfData[CurrentItem];
      if I > 0 then begin
        {need to manually skip over groups}
        repeat
          dec(I);
          P := ItemData[I];
        until (I = 0) or (P <> CurrentItem);
        CurrentItem := P;
      end;
    end;
  rvpScrollToTop :
    FRVListBox.TopIndex := 0;
  rvpScrollToBottom :
    FRVListBox.TopIndex := FRVListBox.NumItems - 1;
  end;
end;

procedure TOvcCustomReportView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
    if (AComponent = CustomViewStore) then begin
      SaveDirtyViews;
      CustomViewStore := nil;
    end else
    if (AComponent = FieldWidthStore) then begin
      StoreColumnWidths;
      FieldWidthStore := nil;
    end else
    if (AComponent = Self) then
      StoreColumnWidths
    else
    if (AComponent = FController) then
      FController := nil;
  inherited Notification(AComponent, Operation);
  if (Operation = opInsert) then
    if (AComponent = FieldWidthStore) then
      LoadCustomViews;
end;

{ - Hdc changed to TOvcHdc for BCB compatibility }
function GetRelativeAspect(PrinterDC : TOvcHdc{hDC}): double;
var
  ScreenDC : hDC;
begin
  ScreenDC := GetDC(0);
  try
    Result := GetDeviceCaps(PrinterDC, LOGPIXELSX) / GetDeviceCaps(ScreenDC, LOGPIXELSX);
  finally
    ReleaseDC(0, ScreenDC);
  end;
end;

function TOvcCustomReportView.TwipsToPixels(T: Integer): Integer;
begin
  Result := T * Printer.Canvas.Font.PixelsPerInch div 1440;
end;

function TOvcCustomReportView.PixelsToTwips(T: Integer): Integer;
begin
  Result := 1440 * T div Printer.Canvas.Font.PixelsPerInch;
end;

procedure TOvcCustomReportView.PaintString(Canvas: TCanvas; CurY, LineHeight: Integer; S : string; Alignment : TAlignment; Left,Right : Integer; const Attr : TFontStyles);
var
  R,R2: TRect;
  AL: Integer;
  SaveFontStyle: TFontStyles;
begin
  SaveFontStyle := Canvas.Font.Style;
  Canvas.Font.Style := Attr;
  try
    case Alignment of
      taLeftJustify  : AL := DT_LEFT;
      taRightJustify : AL := DT_RIGHT;
      taCenter       : AL := DT_CENTER;
    else
      AL := 0;
    end;
    AL := AL or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_NOCLIP;
    R.Left := Left;
    R.Top := CurY;
    R.Bottom := CurY + LineHeight;
    R.Right := Right;
    R2 := R;
    InflateRect(R2, -2, -2);
    if S <> '' then
      S := GetDisplayString(Canvas, S, 1, R2.Right - R2.Left);
    DrawText(Canvas.Handle, PChar(S), length(S), R2, AL);
  finally
    Canvas.Font.Style := SaveFontStyle;
  end;
end;

procedure TOvcCustomReportView.DoHeaderFooter(Canvas: TCanvas; var CurY: Integer; LineHeight: Integer; const IsHeader : Boolean);
var
  i, Count : Integer;
  Left, Center, Right : string;
  LeftAttr, CenterAttr, RightAttr : TFontStyles;
begin
  if IsHeader then
    Count := PrinterProperties.PrintHeaderLines
  else
    Count := PrinterProperties.PrintFooterLines;
  for i := 0 to pred(Count) do begin
    LeftAttr := [];
    CenterAttr := [];
    RightAttr := [];
    Left := '';
    Center := '';
    Right := '';
    if assigned(FOnGetPrintHeaderFooter) then
      FOnGetPrintHeaderFooter(Self, IsHeader, i,
        Left, Center, Right,
        LeftAttr, CenterAttr, RightAttr);
    PaintString(Canvas, CurY, LineHeight, Left, taLeftJustify, PrintStartLeft, PrintStopRight, LeftAttr);
    PaintString(Canvas, CurY, LineHeight, Center, taCenter, PrintStartLeft, PrintStopRight, CenterAttr);
    PaintString(Canvas, CurY, LineHeight, Right, taRightJustify, PrintStartLeft, PrintStopRight, RightAttr);
    inc(CurY, LineHeight);
  end;
end;

function TOvcCustomReportView.PaintCell(Canvas: TCanvas; CurY: Integer; Data : Pointer; const S : string; Cell : TOvcRvViewField;
  Left: Integer; BottomLine, TopLine, PaintIt, Clip, Last: Boolean; ImageIndex,
  LineHeight: Integer) : Integer;
var
  R, R2 : TRect;
  AL : Integer;
  S2 : string;
  PWidth : Integer;
  SaveBrushColor, SavePenColor : TColor;
  Margin : Integer;
begin
  Margin := TwipsToPixels(PrinterProperties.PrintColumnMargin);
  with Cell do begin
    PWidth := PrintWidth;
    case Field.Alignment of
      taLeftJustify  : AL := DT_LEFT;
      taRightJustify : AL := DT_RIGHT;
      taCenter       : AL := DT_CENTER;
    else
      AL := 0;
    end;
    AL := AL or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_NOCLIP;
    R.Left := Left;
    R.Top := CurY;
    R.Bottom := CurY + LineHeight;
    R.Right := R.Left + TwipsToPixels(PWidth);
    if PaintIt then begin
      Canvas.Pen.Width := TwipsToPixels(PrinterProperties.PrintLineWidth);
      if TopLine then begin
        Canvas.MoveTo(R.Left, R.Top);
        Canvas.LineTo(R.Right + 1, R.Top);
      end;
      if BottomLine then begin
        Canvas.MoveTo(R.Left, R.Bottom);
        Canvas.LineTo(R.Right + 1, R.Bottom);
      end;
      R2 := R;
      InflateRect(R2,-2,-2);
      if (ImageIndex <> -1) and (HeaderImages <> nil) then begin
        StretchDrawImageListImage(Canvas, HeaderImages,
          Rect(R2.Left, R2.Top, R2.Left + round(HeaderImages.Width * PAspect),
            R2.Top + round(HeaderImages.Height * PAspect)),
          ImageIndex, True);
        inc(R2.Left, round(HeaderImages.Width * PAspect) + 2);
      end;
      if (S <> '') and Clip then
        S2 := GetDisplayString(Canvas,S,1,R2.Right-R2.Left)
      else
        S2 := S;
      if Cell.OwnerDraw and (Data <> nil) then begin
        SaveBrushColor := Canvas.Brush.Color;
        SavePenColor := Canvas.Pen.Color;
        FPrinting := True;
        try
          DoDrawViewField(Canvas, Data, Cell.Field, Cell, AL,
            False, False, Cell.Index, R2, S, S2);
        finally
          FPrinting := False;
          Canvas.Brush.Color := SaveBrushColor;
          Canvas.Pen.Color := SavePenColor;
        end;
      end else
        DrawText(Canvas.Handle, PChar(S2), length(S2), R2, AL);

      if PrinterProperties.PrintGridLines
      and not BottomLine and not TopLine then begin
        if not Last
        and (GridLines in [glVertical, glBoth]) then begin
          Canvas.Pen.Width := TwipsToPixels(PrinterProperties.PrintLineWidth);
          Canvas.MoveTo(R.Right + Margin div 2,
            R.Top + Margin div 2);
          Canvas.LineTo(R.Right + Margin div 2,
            R.Bottom - Margin div 2);
        end;
        if (GridLines in [glHorizontal, glBoth]) then begin
          Canvas.Pen.Width := TwipsToPixels(PrinterProperties.PrintLineWidth);
          Canvas.MoveTo(R.Left, R.Bottom);
          Canvas.LineTo(R.Right, R.Bottom);
        end;
      end;

    end;
    Result := R.Right + Margin;
  end;
end;

procedure TOvcCustomReportView.DoSectionHeader(Canvas: TCanvas; var CurY: Integer; LineHeight, VPage,
  PrintStartLeft: Integer);
var
  CurX, i, LocalLineHeight : Integer;
begin
  if HeaderImages <> nil then
    LocalLineHeight := MaxI(LineHeight, round((HeaderImages.Height + 2) * PAspect))
  else
    LocalLineHeight := LineHeight;
  if IsGrouped then
    Canvas.Font.Style := [fsBold];
  inc(CurY, LocalLineHeight); {blank line}
  CurX := PrintStartLeft;
  for i := 0 to pred(CurrentView.GroupCount) do begin
    with CurrentView.ViewField[i], Field do
      if Visible then
        if (FVPage = VPage) or (FVPage = -1) then
          CurX := PaintCell(Canvas, CurY, nil, '',CurrentView.ViewField[i],
            CurX, False, False, True, True, i = pred(CurrentView.GroupCount), -1, LocalLineHeight);
  end;
  for i := CurrentView.GroupCount to pred(CurrentView.ViewFields.Count) do
    with CurrentView.ViewField[i], Field do
      if Visible then
        if (FVPage = VPage) or (FVPage = -1) then begin
          CurX := PaintCell(Canvas, CurY, nil, Caption, CurrentView.ViewField[i], CurX,
            True, False, True, True, i = pred(CurrentView.ViewFields.Count), ImageIndex, LocalLineHeight);
        end;
  inc(CurY, LocalLineHeight);
  if IsGrouped then
    Canvas.Font.Style := [];
end;

procedure TOvcCustomReportView.DoLine(Canvas: TCanvas; var CurY: Integer; LineHeight, VPage: Integer;
  Line, PrintStartLeft : Integer);
var
  CurX,i,Gr : Integer;
  S : string;
  Data : Pointer;
begin
  CurX := PrintStartLeft;
  if not IsGroup[Line] then begin
    Data := ItemData[Line];
    for i := 0 to pred(CurrentView.GroupCount) do
      with CurrentView.ViewField[i],Field do
        if Visible then
          if (FVPage = VPage) or (FVPage = -1) then
            CurX := PaintCell(Canvas, CurY, Data, '', CurrentView.ViewField[i], CurX, False,
             False, False, True, i = pred(CurrentView.GroupCount), -1, LineHeight);
    for i := CurrentView.GroupCount to pred(CurrentView.ViewFields.Count) do
      with CurrentView.ViewField[i],Field do
        if Visible then
          if (FVPage = VPage) or (FVPage = -1) then begin
            S := '';
            if (Data <> nil) then
              S := AsString(Data);
            CurX := PaintCell(Canvas, CurY, Data, S, CurrentView.ViewField[i], CurX, False,
              False, True, True, i = pred(CurrentView.ViewFields.Count), -1, LineHeight);
          end;
  end else begin
    Canvas.Font.Style := [fsBold];
    Data := ItemData[Line];
    Gr := GroupField[Line];
    if VPage = 0 then
      for i := 0 to pred(CurrentView.GroupCount) do begin
        if CurrentView.ViewField[i].Visible then begin

          if Options.ShowGroupCaptionInList then begin
            S := CurrentView.ViewField[i].Field.Caption;
            if S <> '' then
              S := S + ' : ';
          end else
            S := '';

          S := S + CurrentView.ViewField[i].Field.AsString(Data);
          CurX := PaintCell(Canvas, CurY, Data{nil}, S, CurrentView.ViewField[i], CurX, False,
            False, i = Gr, False, i = pred(CurrentView.GroupCount), -1, LineHeight);
        end;
      end;
    if CurrentView.ShowGroupTotals then begin
      for i := CurrentView.GroupCount to pred(CurrentView.ViewFields.Count) do
        with CurrentView.ViewField[i], Field do begin
          if Visible then begin
            if (FVPage = VPage) or (FVPage = -1) then begin
              if ComputeTotals then
                S := DoGetGroupString(CurrentView.ViewField[i], GroupRef[Line])
              else
                S := '';
              CurX := PaintCell(Canvas, CurY, nil, S,CurrentView.ViewField[i], CurX,
                False, False, ComputeTotals,
                True, i = pred(CurrentView.ViewFields.Count), -1, LineHeight);
            end;
          end;
        end;
    end;
    Canvas.Font.Style := [];
  end;
  inc(CurY, LineHeight);
end;

procedure TOvcCustomReportView.DoSectionFooter(Canvas: TCanvas; var CurY: Integer; LineHeight, VPage,
  PrintStartLeft: Integer);
var
  CurX,i : Integer;
begin
  if CurrentView.ShowFooter then begin
    if IsGrouped then
      Canvas.Font.Style := [fsBold];
    CurX := PrintStartLeft;
    for i := 0 to pred(CurrentView.GroupCount) do begin
      with CurrentView.ViewField[i],Field do
        if Visible then
          if (FVPage = VPage) or (FVPage = -1) then
            CurX := PaintCell(Canvas, CurY, nil, '', CurrentView.ViewField[i], CurX,
              False, False, False, True, i = pred(CurrentView.GroupCount), -1, LineHeight);
    end;
    for i := CurrentView.GroupCount to pred(CurrentView.ViewFields.Count) do
      with CurrentView.ViewField[i],Field do
        if Visible then
          if (FVPage = VPage) or (FVPage = -1) then
            CurX := PaintCell(Canvas, CurY, nil, FRVFooter.Section[i].Caption,
              CurrentView.ViewField[i], CurX, False,
              i >= CurrentView.GroupCount, True, True,
              i = pred(CurrentView.ViewFields.Count), -1, LineHeight);
    inc(CurY, 2*LineHeight);
    if IsGrouped then
      Canvas.Font.Style := [];
  end;
end;

function TOvcCustomReportView.AdvancePage(Canvas: TCanvas; var CurY: Integer;
  LineHeight: Integer; VPage, RenderPage: Integer; var Abort: Boolean;
  PrintStartLeft: Integer): Integer;
begin
  if FPageNumber = RenderPage then begin
    CurY := PrintStopBottom - PrinterProperties.PrintFooterLines * LineHeight;
    DoHeaderFooter(Canvas, CurY, LineHeight, False);
  end;
  inc(FPageNumber);
  if assigned(FOnPrintStatus) then begin
    FOnPrintStatus(Self, FPageNumber, Abort);
    if Abort then begin
      Result := 0;
      exit;
    end;
  end;
  CurY := PrintStartTop;
  if FPageNumber = RenderPage then
    DoHeaderFooter(Canvas, CurY, LineHeight, True);
  Result := PLinesPerPage - PrinterProperties.PrintHeaderLines - PrinterProperties.PrintFooterLines;
  if CurrentView.ShowHeader then begin
    if FPageNumber = RenderPage then
      DoSectionHeader(Canvas, CurY, LineHeight, VPage, PrintStartLeft);
    dec(Result, 2);
  end;
end;

function TOvcCustomReportView.RenderPageBlock(Canvas: TCanvas;
  const LineHeight, LinesPerPage, VPage, HPage: Integer;
    AdvancePage: TAdvancePageMethod; PageNumber: TGetPageNumberMethod;
      var LinesLeft, CurY: Integer; PrintStartLeft: Integer): Boolean;
var
  j: Integer;
  Abort: Boolean;
  DidPrint: Boolean;
begin
  Abort := False;

  DidPrint := False;

  if CurrentView.ShowHeader then begin
    if LinesLeft <= 1 then begin
      LinesLeft := AdvancePage(Canvas, CurY, LineHeight, VPage, HPage, Abort, PrintStartLeft);
      if Abort then begin
        Result := False;
        exit;
      end;
    end;
    if HPage = PageNumber then begin
      DoSectionHeader(Canvas, CurY, LineHeight, VPage, PrintStartLeft);
      DidPrint := True;
    end;
    dec(LinesLeft, 2);
  end;

  for j := 0 to Lines - 1 do begin
    if LinesLeft <= 0 then begin
      LinesLeft := AdvancePage(Canvas, CurY, LineHeight, VPage, HPage, Abort, PrintStartLeft);
      if Abort then begin
        Result := False;
        exit;
      end;
    end;

    if HPage = PageNumber then
      DoLine(Canvas, CurY, LineHeight, VPage, j, PrintStartLeft);

    dec(LinesLeft);
    DidPrint := True;

    if PrintDetailView <> nil then begin
      DoDetail(ItemData[j]);
      if not PrintDetailView.RenderPageBlock(Canvas, LineHeight, LinesPerPage, VPage, HPage,
        AdvancePage, GetPageNumber, LinesLeft, CurY, PrintStartLeft + PrinterProperties.DetailIndent) then begin
          Result := False;
          exit;
      end;

    end;

  end;

  if DidPrint then begin
    if LinesLeft <= 1 then begin
      LinesLeft := AdvancePage(Canvas, CurY, LineHeight, VPage, HPage, Abort, PrintStartLeft);
      if Abort then begin
        Result := False;
        exit;
      end;
    end;
    if HPage = PageNumber then
      DoSectionFooter(Canvas, CurY, LineHeight, VPage, PrintStartLeft);
    dec(LinesLeft, 2);
  end;

  Result := True;
end;

function TOvcCustomReportView.GetPageNumber: Integer;
begin
  Result := FPageNumber;
end;

function TOvcCustomReportView.RenderPageSection(Canvas: TCanvas; const SelectedOnly : Boolean;
  const LineHeight, LinesPerPage, VPage, HPage: Integer; ScaleFonts: Boolean): Boolean;
var
  j, LinesLeft, CurY: Integer;
  Abort: Boolean;
  DidPrint: Boolean;
begin
  Abort := False;
  LinesLeft := 0;
  FPageNumber := 0;

  Canvas.Font.Assign(PrinterProperties.PrintFont);
  if ScaleFonts then
    Canvas.Font.Size := round(Canvas.Font.Size * PAspect);
  SetBkMode(Canvas.Handle, TRANSPARENT);

  DidPrint := False;
  for j := 0 to Lines - 1 do begin
    if FPageNumber > HPage then
      break;
    if not SelectedOnly or IsSelected[j] then begin
      if LinesLeft <= 0 then begin
        LinesLeft := AdvancePage(Canvas, CurY, LineHeight, VPage, HPage, Abort, PrintStartLeft);
        if Abort then begin
          Result := False;
          exit;
        end;
      end;

      if HPage = FPageNumber then
        DoLine(Canvas, CurY, LineHeight, VPage, j, PrintStartLeft);

      DidPrint := True;
      dec(LinesLeft);

      if PrintDetailView <> nil then begin
        DoDetail(ItemData[j]);
        if not PrintDetailView.RenderPageBlock(Canvas, LineHeight, LinesPerPage, VPage, HPage,
          AdvancePage, GetPageNumber, LinesLeft, CurY, PrintStartLeft + PrinterProperties.DetailIndent) then begin
            Result := False;
            exit;
        end;

      end;

    end;
  end;
  if DidPrint and (HPage = FPageNumber) then
    DoSectionFooter(Canvas, CurY, LineHeight, VPage, PrintStartLeft);

  AdvancePage(Canvas, CurY, LineHeight, VPage, HPage, Abort, PrintStartLeft);

  Result := True;
end;

function TOvcCustomReportView.CalcHLinesNet: Integer;
var
  i: Integer;
begin
  Result := 0;
  if CurrentView.ShowHeader then
    inc(Result, 2);
  if CurrentView.ShowFooter then
    inc(Result, 2);
  if PrintDetailView <> nil then begin
    for i := 0 to Lines - 1 do begin
      DoDetail(ItemData[i]);
      inc(Result, PrintDetailView.CalcHLinesNet);
    end;
  end;
  inc(Result, Lines);
end;

function TOvcCustomReportView.CalcHPages(const SelectedOnly : Boolean; const LinesPerPage: Integer): Integer;
var
  DoneSectionHeader, DoneSectionFooter: Boolean;
  j, LinesLeft: Integer;
begin
  Result := 0;
  LinesLeft := 0;
  DoneSectionHeader := False;
  DoneSectionFooter := False;
  for j := 0 to pred(Lines) do
    if not SelectedOnly or IsSelected[j] then begin
      while LinesLeft <= 0 do begin
        inc(LinesLeft, (LinesPerPage - PrinterProperties.PrintHeaderLines - PrinterProperties.PrintFooterLines));
        inc(Result);
      end;
      if not DoneSectionHeader then begin
        if CurrentView.ShowHeader then
          dec(LinesLeft, 2);
        DoneSectionHeader := True;
      end;
      if not DoneSectionFooter then begin
        if CurrentView.ShowFooter then
          dec(LinesLeft, 2);
        DoneSectionFooter := True;
      end;
      dec(LinesLeft);
      if PrintDetailView <> nil then begin
        DoDetail(ItemData[j]);
        dec(LinesLeft, PrintDetailView.CalcHLinesNet);
      end;
    end;
end;

function TOvcCustomReportView.CompLineWidth2(PrintStartLeft, PrintStopRight: Integer): Integer;
var
  CurX, i, VPage, Right: Integer;
  PW: Integer;
begin
  VPage := 0;
  CurX := PrintStartLeft;
  for i := 0 to pred(CurrentView.ViewFields.Count) do
    with CurrentView.ViewField[i], Field do begin
      if Visible then begin
        PW := TwipsToPixels(PrintWidth);
        Right := CurX + PW;
        if Right >= PrintStopRight then begin
          inc(VPage);
          CurX := PrintStartLeft + PW;
        end else
          CurX := Right;
        FVPage := VPage;
      end;
    end;
  Result := VPage + 1;
  if PrintDetailView <> nil then
    Result := MaxI(Result, PrintDetailView.CompLineWidth2(
      PrintStartLeft + PrinterProperties.DetailIndent,
      PrintStopRight));
end;

function TOvcCustomReportView.CompLineWidth: Integer;
begin
  Result := CompLineWidth2(PrintStartLeft, PrintStopRight);
  if PrintDetailView <> nil then
    Result := MaxI(Result, PrintDetailView.CompLineWidth2(
      PrintStartLeft + PrinterProperties.DetailIndent, PrintStopRight));
end;

procedure TOvcCustomReportView.LockListPaint;
begin
  FRVListBox.BeginUpdate;
  if PrintDetailView <> nil then
    PrintDetailView.LockListPaint;
end;

procedure TOvcCustomReportView.UnlockListPaint;
begin
  FRVListBox.EndUpdate;
  if PrintDetailView <> nil then
    PrintDetailView.UnlockListPaint;
end;

procedure TOvcCustomReportView.BeginPrint(PrintMode : TRVPrintMode; SelectedOnly : Boolean);
begin
  if InPrint = 0 then begin
    LockListPaint;
    case PrintMode of
    pmCurrent :;
    pmExpandAll :
      BeginTemporaryIndex(emExpandAll);
    pmCollapseAll :
      BeginTemporaryIndex(emCollapseAll);
    end;
    DoBusy(True);
    PrintAborted := False;
    DidPrint := False;
    Printer.BeginDoc;
    Printer.Canvas.Font.Assign(PrinterProperties.PrintFont);
    if PrinterProperties.AutoScaleColumns then
      ScaleColumnWidthsForPrint;
    PLineHeight := Printer.Canvas.TextHeight(GetOrphStr(SCTallLowChars)) + FRVListBox.lVMargin;  {!!??!!!}
    PLinesPerPage := PrintAreaHeight div PLineHeight - 1;
    PMaxVertPage := CompLineWidth;
    FPPageCount := CalcHPages(SelectedOnly, PLinesPerPage);
    PAspect := GetRelativeAspect(Printer.Handle);
  end;
  inc(InPrint);
end;

procedure TOvcCustomReportView.EndPrint(PrintMode : TRVPrintMode);
begin
  dec(InPrint);
  if InPrint = 0 then begin
    if not PrintAborted and DidPrint then
      Printer.EndDoc
    else
      Printer.Abort;
    UnlockListPaint;
    case PrintMode of
    pmCurrent :;
    pmExpandAll,
    pmCollapseAll :
      begin
        EndTemporaryIndex;
        FRVListBox.Invalidate;
      end;
    end;
    DoBusy(False);
  end;
end;

procedure TOvcCustomReportView.Print(PrintMode : TRVPrintMode; SelectedOnly : Boolean);
var
  HP, VP : Integer;
begin
  BeginPrint(PrintMode, SelectedOnly);
  try
    for VP := 0 to PMaxVertPage - 1 do begin
      if VP > 0 then
        Printer.NewPage;
      for HP := 1 to FPPageCount do begin
        if HP > 1 then
          Printer.NewPage;
        if not RenderPageSection(Printer.Canvas, SelectedOnly, PLineHeight, PLinesPerPage, VP, HP, False) then begin
          PrintAborted := True;
          break;
        end else
          DidPrint := True;
      end;
      if PrintAborted then
        break;
    end;
  finally
    EndPrint(PrintMode);
  end;
end;

procedure TOvcCustomReportView.PrintPreview(PrintMode : TRVPrintMode; SelectedOnly : Boolean);
begin
  BeginPrint(PrintMode, SelectedOnly);
  try
    with TOvcRVPrintPreview.Create(Application) do
      try
        FPageCount := FPPageCount;
        FSectionCount := PMaxVertPage;
        FPrintMode := PrintMode;
        FSelectedOnly := SelectedOnly;
        FLineHeight := PLineHeight;
        FLinesPerPage := PLinesPerPage;
        lblMaxPage.Caption := IntToStr(FPPageCount);
        OwnerReport := Self;
        ShowModal;
      finally
        Free;
      end;
  finally
    EndPrint(PrintMode);
  end;
end;

procedure TOvcCustomReportView.RebuildIndexes;
var
  SaveView : string;
begin
  SaveView := ActiveView;
  ActiveView := '';
  DeleteInactiveIndexes(nil);
  ActiveView := SaveView;
end;

procedure TOvcCustomReportView.RegisterChangeNotification(ClientMethod : TRVNotifyEvent);
begin
  ChangeNotificationList.Add(TChangeNotification.Create(ClientMethod));
end;

procedure TOvcCustomReportView.SetBorderStyle(const Value : TBorderStyle);
  {-set the style used for the border}
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomReportView.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  {HScrollDelta := 0;}
  RecalcWidth;
end;

procedure TOvcCustomReportView.SetCurrentItem(Value : Pointer);
{Set method for CurrentItem property.
 Sets currently selected item to Value}
var
  NewOffset : Integer;
begin
  if Value = nil then
    NewOffset := -1
  else
    NewOffset := OffsetOfData[Value];
  if FRVListBox.ItemIndex = NewOffset then exit;
  FRVListBox.ItemIndex := -1;
  if NewOffset <> -1 then begin
    if AutoCenter then
      FRVListBox.CenterLine(NewOffset);
    FRVListBox.ItemIndex := NewOffset;
  end;
  {FRVListBox.ItemIndex := OffsetOfData[Value];}
  if FRVListBox.ItemIndex = -1 then begin
    if Value <> nil then begin
      MakeVisible(Value);
      FRVListBox.ItemIndex := OffsetOfData[Value];
    end else
      FRVListBox.ItemIndex := -1;
  end;
  FRVListBox.lAnchor := FRVListBox.ItemIndex;
  if AutoCenter then
    FRVListBox.CenterCurrentLine;
end;

procedure TOvcCustomReportView.SetOnKeyUp(Value : TKeyEvent);
begin
  FRVListBox.OnKeyUp := Value;
end;

procedure TOvcCustomReportView.SetOnKeyDown(Value : TKeyEvent);
begin
  FRVListBox.OnKeyDown := Value;
end;

procedure TOvcCustomReportView.SetOnMouseDown(Value : TMouseEvent);
begin
  FRVListBox.OnMouseDown := Value;
end;

procedure TOvcCustomReportView.SetOnMouseMove(Value : TMouseMoveEvent);
begin
  FRVListBox.OnMouseMove := Value;
end;

procedure TOvcCustomReportView.SetOnMouseUp(Value : TMouseEvent);
begin
  FRVListBox.OnMouseUp := Value;
end;

procedure TOvcCustomReportView.SetOptions(const Value: TOvcRVOptions);
begin
  FOptions.Assign(Value);
end;

procedure TOvcCustomReportView.SetPopupMenu(Value : TPopupMenu);
begin
  FRVListBox.PopupMenu := Value;
end;

procedure TOvcCustomReportView.SetScrollBars(const Value : TScrollStyle);
  {-set use of vertical and horizontal scroll bars}
var
  HaveVS, HaveHS : Boolean;
begin
  if Value <> FScrollBars then begin
    FScrollBars := Value;
    HaveVS := (Value = ssVertical) or (Value = ssBoth);
    HaveHS := (Value = ssHorizontal) or (Value = ssBoth);
    if HaveVS then
      FRVListBox.ScrollBars := ssVertical
    else
      FRVListBox.ScrollBars := ssNone;
    if HaveHS <> rvHaveHS then begin
      rvHaveHS := HaveHS;
      RecreateWnd;
    end;
    if HandleAllocated then begin
      RecalcWidth;
      InitScrollInfo;
    end;
  end;
end;

procedure TOvcCustomReportView.SetSmoothScroll(Value : Boolean);
{Set method for the SmoothScroll property}
begin
  FRVListBox.SmoothScroll := Value;
end;

procedure TOvcCustomReportView.StoreColumnWidths;
var
  i : Integer;
begin
  if assigned(FFieldWidthStore)
  and assigned(FCurrentView)
  and StoreChangedWidths {WidthChanged}
  and not (csDesigning in ComponentState) then begin

    FieldWidthStore.Open;
    try

      for i := 0 to pred(CurrentView.ViewFields.Count) do
        if CurrentView.ViewField[i].Visible then
          FieldWidthStore.WriteInteger(ColWidthKey,IntToStr(i), CurrentView.ViewField[i].Width);
    finally
      FieldWidthStore.Close;
    end;
    StoreChangedWidths {WidthChanged} := False;
  end;
end;

procedure TOvcCustomReportView.UnRegisterChangeNotification(ClientMethod : TRVNotifyEvent);
var
  i : Integer;
begin
  for i := 0 to pred(ChangeNotificationList.Count) do
    if (TMethod(TChangeNotification(ChangeNotificationList[i]).Event).Data =
      TMethod(ClientMethod).Data)
    and (TMethod(TChangeNotification(ChangeNotificationList[i]).Event).Code =
      TMethod(ClientMethod).Code) then begin
      TChangeNotification(ChangeNotificationList[i]).Free;
      ChangeNotificationList.Delete(i);
      exit;
    end;
  raise Exception.Create('Change notification method not found');
end;

procedure TOvcCustomReportView.WMEraseBkgnd(var Msg : TWMEraseBkGnd);
begin
  {indicate that we have processed this message}
  Msg.Result := 1;
end;

procedure TOvcCustomReportView.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  FRVListBox.SetFocus;
  FRVListBox.Invalidate;
end;

procedure TOvcCustomReportView.WMKillFocus(var Msg : TWmKillFocus);
begin
  inherited;
  FRVListBox.Invalidate;
end;

function TOvcCustomReportView.Focused: Boolean;
begin
  Result :=
    (FRVListBox <> nil)
    and FRVListBox.HandleAllocated
    and (GetFocus = FRVListBox.Handle);
end;

procedure TOvcCustomReportView.SetSortColumn(Value : Integer);
begin
  if InternalSortColumn < 0 then
    {retain descending property}
    InternalSortColumn := - (abs(Value) + 1)
  else
    InternalSortColumn := abs(Value) + 1;
  FRVHeader.SetSortGlyph;
end;

procedure TOvcCustomReportView.SetSortDescending(Value : Boolean);
begin
  if Value then
    if InternalSortColumn > 0 then begin
      InternalSortColumn := -InternalSortColumn;
      FRVHeader.SetSortGlyph;
    end else
  else
    if InternalSortColumn < 0 then begin
      InternalSortColumn := -InternalSortColumn;
      FRVHeader.SetSortGlyph;
    end
end;

procedure TOvcCustomReportView.PHResize(Sender : TObject);
begin
  if rvHaveHs then begin
    FRVHeader.Top := 0;
    FRVHeader.Left := -HScrollDelta;
    FRVHeader.Height := HeaderPanel.ClientHeight;
    FRVHeader.Width := ClientExtra + ClientWidth;
  end else begin
    FRVHeader.Top := 0;
    FRVHeader.Left := 0;
    FRVHeader.Height := HeaderPanel.ClientHeight;
    FRVHeader.Width := HeaderPanel.ClientWidth;
  end;
end;

procedure TOvcCustomReportView.PFResize(Sender : TObject);
begin
  if rvHaveHs then begin
    FRVFooter.Top := 0;
    FRVFooter.Left := -HScrollDelta;
    FRVFooter.Height := FooterPanel.ClientHeight;
    FRVFooter.Width := ClientExtra + ClientWidth;
  end else begin
    FRVFooter.Top := 0;
    FRVFooter.Left := 0;
    FRVFooter.Height := FooterPanel.ClientHeight;
    FRVFooter.Width := FooterPanel.ClientWidth;
  end;
end;

procedure TOvcCustomReportView.AncestorNotFound(Reader: TReader; const ComponentName: string;
    ComponentClass: TPersistentClass; var Component: TComponent);
begin
  if ComponentClass = TOvcRvField then
    Component := FFields.ItemByName(ComponentName)
  else
  if ComponentClass = TOvcRvView then
    Component := FViews.ItemByName(ComponentName);
end;

procedure TOvcCustomReportView.ReadState(Reader : TReader);
var
  SaveAncestorNotFound : TAncestorNotFoundEvent;
begin
  SaveAncestorNotFound := Reader.OnAncestorNotFound;
  try
    Reader.OnAncestorNotFound := AncestorNotFound;
    LoadingViews := True;
    inherited ReadState(Reader);
  finally
    Reader.OnAncestorNotFound := SaveAncestorNotFound;
  end;
end;

procedure TOvcCustomReportView.RecalcWidth;
var
  i, NewClientExtra : Integer;
begin
  if csDestroying in ComponentState then exit;
  if not HandleAllocated then exit;
  NewClientExtra := 0;
  if (CurrentView <> nil) and rvHaveHS then begin
    for i := 0 to pred(FRVHeader.Sections.Count) do
      inc(NewClientExtra, FRVHeader.Section[i].Width);
    inc(NewClientExtra, 20);  {resize area}
    dec(NewClientExtra, ClientWidth);
    if NewClientExtra < 0 then
      NewClientExtra := 0;
  end;
  if NewClientExtra <> ClientExtra then begin
    ClientExtra := NewClientExtra;
    if HScrollDelta <> 0 then begin
      {HScrollDelta := 0;}
      PHResize(nil);
      PFResize(nil);
      FRVListBox.Invalidate;
    end;
    {InitScrollInfo;}
  end;
  if NewClientExtra = 0 then
    HScrollDelta := 0;
  SetHScrollRange;
  SetHScrollPos;
  FWidthChanged := False;
end;

procedure TOvcCustomReportView.SetWidthChanged(Value : Boolean);
begin
  if Value <> FWidthChanged then begin
    FWidthChanged := Value;
    RecalcWidth;
    StoreChangedWidths := True;
  end;
end;

class procedure TOvcCustomReportView.StretchDrawImageListImage(Canvas: TCanvas; ImageList: TImageList;
  TargetRect: TRect; ImageIndex: Integer; PreserveAspect: Boolean);
var
  Img: TBitmap;
  XA, YA: double;
begin
  Img := TBitmap.Create;
  try
    if PreserveAspect then begin
      XA := (TargetRect.Right - TargetRect.Left) / ImageList.Width;
      YA := (TargetRect.Bottom - TargetRect.Top) / ImageList.Height;
      if XA < YA then
        TargetRect.Bottom := TargetRect.Top + round((TargetRect.Bottom - TargetRect.Top) / YA * XA)
      else
        TargetRect.Right := TargetRect.Left + round((TargetRect.Right - TargetRect.Left) / XA * YA);
    end;
    ImageList.GetBitmap(ImageIndex, Img);
    Canvas.StretchDraw(TargetRect, Img);
  finally
    Img.Free;
  end;
end;

{ new}
function TOvcCustomReportView.CountSelected(StopOnFirst: Boolean): Integer;

  procedure EnumGroup(Group: TOvcRvIndexGroup; Sel : Boolean);
  var
    I: Integer;
  begin
    Sel := Sel or Group.IsSelected;
    I := Group.Count - 1;
    while (I >= 0) and (not StopOnFirst or (Result = 0)) do begin
      if Group.ContainsGroups then
        EnumGroup(TOvcRvIndexGroup(Group.Element[I]), Sel)
      else
        if Sel then begin
          inc(Result);
          if StopOnFirst then
            exit;
        end else
          if FSelected.IndexOf(Group.Element[I]) <> -1 then begin
            inc(Result);
            if StopOnFirst then
              exit;
          end;
      dec(I);
    end
  end;

begin
  Result := 0;
  if not Assigned(FActiveIndex) then
    Exit;
  EnumGroup(FActiveIndex.Root, False)
end;

{ no longer used:
procedure TOvcCustomReportView.CountSelection(Sender : TObject; Data : Pointer; var Stop : Boolean; UserData : Pointer);
begin
  Boolean(UserData^) := True;
  Stop := True;
end;
}

function TOvcCustomReportView.GetHaveSelection: Boolean;
{var
  SaveEnumerator : TOvcRVEnumEvent;}
begin
  if not MultiSelect then
    Result := False
  else begin
    Result := CountSelected(True) > 0;
    { begin
    SaveEnumerator := OnEnumerate;
    Result := False;
    try
      OnEnumerate := CountSelection;
      DoEnumerateSelected(@Result);
    finally
      OnEnumerate := SaveEnumerator;
    end;
    { end}
  end;
end;

{ no longer used:
procedure TOvcCustomReportView.CountSelection2(Sender : TObject; Data : Pointer; var Stop : Boolean; UserData : Pointer);
begin
  inc(Integer(UserData^));
end;
}

function TOvcCustomReportView.GetSelectionCount: Integer;
{var
  SaveEnumerator : TOvcRVEnumEvent;}
begin
  Result := 0;
  if not MultiSelect then
    exit;
  Result := CountSelected(False);
  { begin
  SaveEnumerator := OnEnumerate;
  try
    OnEnumerate := CountSelection2;
    DoEnumerateSelected(@Result);
  finally
    OnEnumerate := SaveEnumerator;
  end;
  !!.06 }
end;

function TOvcCustomReportView.GetViews: TOvcRvViews;
begin
  Result := TOvcRvViews(FViews);
end;

procedure TOvcCustomReportView.SetViews(const Value: TOvcRvViews);
begin
  inherited SetViews(Value);
end;

function TOvcCustomReportView.GetDesigning: Boolean;
begin
  Result := FDesigning or (csDesigning in ComponentState);
end;

procedure TOvcCustomReportView.SetDesigning(const Value: Boolean);
begin
  FDesigning := Value;
end;

function TOvcCustomReportView.GetHeaderImages: TImageList;
begin
  Result := FRVHeader.LeftImages;
end;

procedure TOvcCustomReportView.SetHeaderImages(const Value: TImageList);
begin
  FRVHeader.LeftImages := Value;
end;

function TOvcCustomReportView.GetFields: TOvcRvFields;
begin
  Result := TOvcRvFields(FFields);
end;

procedure TOvcCustomReportView.SetFields(const Value: TOvcRvFields);
begin
  FFIelds := Value;
end;

function TOvcCustomReportView.CompareValues(Data1, Data2: Pointer;
  FieldIndex: Integer): Integer;
var
  V1, V2: Variant;
begin
  V1 := Field[FieldIndex].GetValue(Data1);
  V2 := Field[FieldIndex].GetValue(Data2);
  if V1 = V2 then
    Result := 0
  else
  if V1 < V2 then
    Result := -1
  else
    Result := 1;
end;

function TOvcCustomReportView.DoCompareFields(Data1, Data2: Pointer;
  FieldIndex: Integer): Integer;
begin
  if Field[FieldIndex].Expression <> '' then
    Result := CompareValues(Data1, Data2, FieldIndex)
  else
    Result := inherited DoCompareFields(Data1, Data2, FieldIndex);
end;

procedure TOvcCustomReportView.DoDetail;
begin
  if assigned(FDetailPrint) then
    FDetailPrint(Self);
  if PrintDetailView.PrinterProperties.AutoScaleColumns then
    PrintDetailView.ScaleColumnWidthsForPrint;
end;

function TOvcCustomReportView.UniqueViewNameFromTitle(const Title : string) : string;
var
  i : Integer;
begin
  if CharInSet(Title[1], ['A'..'Z','a'..'z']) then
    Result := Title[1]
  else
    Result := '_';
  for i := 2 to length(Title) do
    if CharInSet(Title[i], ['A'..'Z','a'..'z','0'..'9']) then
      Result := Result + Title[i]
    else
      Result := Result + '_';
  repeat
    for i := 0 to pred(Views.Count) do
      if View[i].Name = Result then begin
        Result := Result + '_1';
        continue;
      end;
  until True;
end;

function TOvcCustomReportView.EditNewView(const Title: string): Boolean;
var
  NewView : TOvcRvView;
  SaveView : string;
begin
  Result := False;
  NewView := Views.Add;
  NewView.Title := Title;
  NewView.Name := UniqueViewNameFromTitle(NewView.Title);
  SaveView := ActiveView;
  ActiveViewByTitle := Title;
  if not EditView(Self) then begin
    ActiveView := SaveView;
    NewView.Title := '';
    NewView.Free;
  end else begin
    CurrentView.Dirty := True;
    Result := True;
  end;
end;

function TOvcCustomReportView.EditCopyOfCurrentView: Boolean;
var
  OldView, NewView : TOvcRvView;
  SaveView : string;
begin
  Result := False;
  OldView := CurrentView;
  if OldView = nil then
    raise Exception.Create('There is currently no view selected');
  SaveView := ActiveView;
  CurrentItem := nil;
  ActiveView := '';
  NewView := Views.Add;
  NewView.Assign(OldView);
  NewView.Title := 'Copy of ' + NewView.Title;
  NewView.Name := UniqueViewNameFromTitle(NewView.Title);
  ActiveViewByTitle := NewView.Title;
  if not EditView(Self) then begin
    ActiveView := SaveView;
    NewView.Free;
  end else begin
    CurrentView.Dirty := True;
    Result := True;
  end;
end;

function TOvcCustomReportView.EditCurrentView: Boolean;
begin
  Result := EditView(Self);
end;

function TOvcCustomReportView.EditCalculatedFields: Boolean;
var
  frmOvcRvFieldEd : TfrmOvcRvFldEd;
  Source, Target: TOvcRvField;
  i: Integer;
begin
  frmOvcRvFieldEd := TfrmOvcRvFldEd.Create(Application);
  with frmOvcRvFieldEd do
    try
      EditReportView := TOvcReportViewClass(Self.ClassType).Create(frmOvcRvFieldEd);
      try
        EditReportView.AssignStructure(Self);
        PopulateFieldCombo;
        PopulateList;
        if ShowModal = mrOK then begin
          for i := 0 to pred(EditReportView.Fields.Count) do begin
            Source := EditReportView.Field[i];
            if Source.Expression <> '' then begin
              Target := TOvcRvField(Fields.ItemByName(Source.Name));
              if Target = nil then
                Fields.Add.Assign(Source)
              else
                Target.Assign(Source);
            end;
          end;
          for i := pred(Fields.Count) downto 0 do begin
            Target := Field[i];
            if EditReportView.Fields.ItemByName(Target.Name) = nil then
              Target.Free
            else
              Target.Dirty := True;
          end;
          Result := True;
        end else
          Result := False;
      finally
        EditReportView.Free;
      end;
    finally
      Free;
    end;
end;

{TOvcReportView}

procedure TOvcReportView.AddData(const Data : Pointer);
begin
  AddDataPrim(Data);
end;

procedure TOvcReportView.ChangeData(const Data : Pointer);
begin
  ChangeDataPrim(Data);
end;

procedure TOvcReportView.RemoveData(const Data : Pointer);
begin
  RemoveDataPrim(Data);
end;

procedure TOvcReportView.Clear;
begin
  ClearIndex;
end;

{ TOvcRVOptions }

constructor TOvcRVOptions.Create(AOwner: TOvcCustomReportView);
begin
  inherited Create;
  FOwner := AOwner;
  FHeaderLines := 1;
  FHeaderAutoHeight := True;
  FFooterAutoHeight := True;
  FHeaderHeight := 18;
  FFooterHeight := 18;
  FShowGroupCaptionInList := True;
end;

function TOvcRVOptions.GetFooterDrawingStyle: TOvcBHDrawingStyle;
begin
  Result := FOwner.FRVFooter.DrawingStyle;
end;

function TOvcRVOptions.GetHeaderAllowDragRearrange: Boolean;
begin
  Result := FOwner.FRVHeader.AllowDragRearrange;
end;

function TOvcRVOptions.GetHeaderDrawingStyle: TOvcBHDrawingStyle;
begin
  Result := FOwner.FRVHeader.DrawingStyle;
end;

function TOvcRVOptions.GetHeaderWordWrap: Boolean;
begin
  Result := FOwner.FRVHeader.WordWrap;
end;

procedure TOvcRVOptions.SetHeaderAllowDragRearrange(const Value: Boolean);
begin
  FOwner.FRVHeader.AllowDragRearrange := Value;
end;

procedure TOvcRVOptions.SetHeaderLines(const Value: Integer);
begin
  FHeaderLines := MaxI(Value, 1);
  FOwner.FRVListBox.vlbCalcFontFields;
end;

procedure TOvcRVOptions.SetHeaderWordWrap(const Value: Boolean);
begin
  FOwner.FRVHeader.WordWrap := Value;
end;

function TOvcRVOptions.GetFooterTextMargin: Integer;
begin
  Result := FOwner.FRVFooter.TextMargin;
end;

procedure TOvcRVOptions.SetHeaderAutoHeight(const Value: Boolean);
begin
  if FHeaderAutoHeight <> Value then begin
    FHeaderAutoHeight := Value;
    FOwner.FRVListBox.vlbCalcFontFields;
  end;
end;

function TOvcRVOptions.GetHeaderHeight: Integer;
begin
  if FHeaderAutoHeight then
    Result := FOwner.FRVHeader.Height
  else
    Result := FHeaderHeight;
end;

procedure TOvcRVOptions.SetHeaderHeight(const Value: Integer);
begin
  if not FHeaderAutoHeight then
    if Value <> FHeaderHeight then begin
      FHeaderHeight := Value;
      FOwner.FRVListBox.vlbCalcFontFields;
    end;
end;

function TOvcRVOptions.NotHeaderAutoHeight: Boolean;
begin
  Result := not HeaderAutoHeight;
end;

procedure TOvcRVOptions.SetFooterAutoHeight(const Value: Boolean);
begin
  if FFooterAutoHeight <> Value then begin
    FFooterAutoHeight := Value;
    FOwner.FRVListBox.vlbCalcFontFields;
  end;
end;

function TOvcRVOptions.GetFooterHeight: Integer;
begin
  if FFooterAutoHeight then
    Result := FOwner.FRVFooter.Height
  else
    Result := FFooterHeight;
end;

procedure TOvcRVOptions.SetFooterHeight(const Value: Integer);
begin
  if not FFooterAutoHeight then
    if Value <> FFooterHeight then begin
      FFooterHeight := Value;
      FOwner.FRVListBox.vlbCalcFontFields;
    end;
end;

procedure TOvcRVOptions.SetShowGroupCaptionInHeader(const Value: Boolean);
begin
  if Value <> FShowGroupCaptionInHeader then begin
    FShowGroupCaptionInHeader := Value;
    FOwner.FRVHeader.Reload;
  end;
end;

procedure TOvcRVOptions.SetShowGroupCaptionInList(const Value: Boolean);
begin
  if Value <> FShowGroupCaptionInList then begin
    FShowGroupCaptionInList := Value;
    FOwner.FRVListBox.Invalidate;
  end;
end;

function TOvcRVOptions.NotFooterAutoHeight: Boolean;
begin
  Result := not FooterAutoHeight;
end;

procedure TOvcRVOptions.Assign(Source: TPersistent);
begin
  if Source is TOvcRVOptions then begin
    HeaderDrawingStyle := TOvcRVOptions(Source).HeaderDrawingStyle;
    FooterDrawingStyle := TOvcRVOptions(Source).FooterDrawingStyle;
    HeaderAllowDragRearrange:= TOvcRVOptions(Source).HeaderAllowDragRearrange;
    HeaderAutoHeight:= TOvcRVOptions(Source).HeaderAutoHeight;
    HeaderHeight:= TOvcRVOptions(Source).HeaderHeight;
    HeaderLines := TOvcRVOptions(Source).HeaderLines;
    HeaderWordWrap:= TOvcRVOptions(Source).HeaderWordWrap;
    HeaderTextMargin := TOvcRVOptions(Source).HeaderTextMargin;
    FooterAutoHeight:= TOvcRVOptions(Source).FooterAutoHeight;
    FooterHeight:= TOvcRVOptions(Source).FooterHeight;
    FooterTextMargin := TOvcRVOptions(Source).FooterTextMargin;
    ListAutoRowHeight := TOvcRVOptions(Source).ListAutoRowHeight;
    ListRowHeight := TOvcRVOptions(Source).ListRowHeight;
    ListBorderStyle := TOvcRVOptions(Source).ListBorderStyle;
    ListColor := TOvcRVOptions(Source).ListColor;
    ListSelectColor.Assign(TOvcRVOptions(Source).ListSelectColor);
    WheelDelta:= TOvcRVOptions(Source).WheelDelta;
  end else
    inherited;
end;

function TOvcRVOptions.GetHeaderTextMargin: Integer;
begin
  Result := FOwner.FRVHeader.TextMargin;
end;

function TOvcRVOptions.GetListAutoRowHeight: Boolean;
begin
  Result := FOwner.FRVListBox.AutoRowHeight;
end;

function TOvcRVOptions.NotListAutoRowHeight: Boolean;
begin
  Result := not ListAutoRowHeight;
end;

function TOvcRVOptions.GetListBorderStyle: TBorderStyle;
begin
  Result := FOwner.FRVListBox.BorderStyle;
end;

function TOvcRVOptions.GetListColor: TColor;
begin
  Result := FOwner.FRVListBox.Color;
end;

function TOvcRVOptions.GetListRowHeight: Integer;
begin
  Result := FOwner.FRVListBox.RowHeight;
end;

function TOvcRVOptions.GetListSelectColor: TOvcRvListSelectColors;
begin
  Result := TOvcRvListSelectColors(FOwner.FRVListBox.SelectColor);
end;

procedure TOvcRVOptions.SetFooterDrawingStyle(
  const Value: TOvcBHDrawingStyle);
begin
  FOwner.FRVFooter.DrawingStyle := Value;
end;

procedure TOvcRVOptions.SetHeaderDrawingStyle(
  const Value: TOvcBHDrawingStyle);
begin
  FOwner.FRVHeader.DrawingStyle := Value;
end;

function TOvcRVOptions.GetWheelDelta: Integer;
begin
  Result := FOwner.FRVListBox.WheelDelta;
end;

procedure TOvcRVOptions.SetWheelDelta(const Value: Integer);
begin
  FOwner.FRVListBox.WheelDelta := Value;
end;

procedure TOvcRVOptions.SetFooterTextMargin(const Value: Integer);
begin
  FOwner.FRVFooter.TextMargin := Value;
end;

procedure TOvcRVOptions.SetHeaderTextMargin(const Value: Integer);
begin
  FOwner.FRVHeader.TextMargin := Value;
end;

procedure TOvcRVOptions.SetListAutoRowHeight(const Value: Boolean);
begin
  FOwner.FRVListBox.AutoRowHeight := Value;
end;

procedure TOvcRVOptions.SetListBorderStyle(const Value: TBorderStyle);
begin
  FOwner.FRVListBox.BorderStyle := Value;
end;

procedure TOvcRVOptions.SetListColor(const Value: TColor);
begin
  FOwner.FRVListBox.Color := Value;
end;

procedure TOvcRVOptions.SetListRowHeight(const Value: Integer);
begin
  FOwner.FRVListBox.FRowHeight := Value;
end;

procedure TOvcRVOptions.SetListSelectColor(const Value: TOvcRvListSelectColors);
begin
  FOwner.FRVListBox.SelectColor := Value;
end;

{ TRvPrintFont }

function TRvPrintFont.NameStored: Boolean;
begin
  Result := Name <> 'Arial';
end;

{global stuff}

procedure FreeResources; far;
{Release allocated global resources.}
begin
  HeaderGlyphList.Free;
  BrushBitmap.Free;
end;

procedure LoadGlyphs;
begin
  HeaderGlyphList := TImageList.Create(nil);
  BrushBitmap := TBitmap.Create;
  HeaderGlyphList.Height := 13;
  HeaderGlyphList.Width := 10;
  HeaderGlyphList.ResInstLoad(FindClassHInstance(
    TOvcCustomReportView), rtBitmap, 'ORRVARROWS', clOlive);
  BrushBitmap.Handle := LoadBaseBitmap('ORRVBRUSH');
end;

initialization
  LoadGlyphs;

finalization
  FreeResources;
end.


