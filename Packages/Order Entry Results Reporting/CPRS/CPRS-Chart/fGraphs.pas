unit fGraphs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORCtrls, Menus, TeeProcs, TeEngine, Series, Chart, Math,
  ComCtrls, GanttCh, ClipBrd, StrUtils, ORFn, ORDtTmRng, DateUtils, Printers,
  OleServer, Variants, Word2000, ArrowCha, ORDtTm, uGraphs, fBase508Form, VCLTee.TeCanvas,
  System.UITypes
  {$IFDEF VER140}
  ,Word97;
  {$ELSE}
  ,WordXP, VA508AccessibilityManager, VclTee.TeeGDIPlus;
  {$ENDIF}

type
  TfrmGraphs = class(TfrmBase508Form)
    btnChangeSettings: TButton;
    btnClose: TButton;
    btnGraphSelections: TButton;
    bvlBottomLeft: TBevel;
    bvlBottomRight: TBevel;
    bvlTopLeft: TBevel;
    bvlTopRight: TBevel;
    calDateRange: TORDateRangeDlg;
    cboDateRange: TORComboBox;
    chartBase: TChart;
    chartDatelineBottom: TChart;
    chartDatelineTop: TChart;
    chkDualViews: TCheckBox;
    chkItemsBottom: TCheckBox;
    chkItemsTop: TCheckBox;
    dlgDate: TORDateTimeDlg;
    lblDateRange: TLabel;
    lstViewsBottom: TORListBox;
    lstViewsTop: TORListBox;
    lvwItemsBottom: TListView;
    lvwItemsTop: TListView;
    memBottom: TMemo;
    memTop: TMemo;
    memViewsBottom: TRichEdit;
    memViewsTop: TRichEdit;
    mnuCustom: TMenuItem;
    mnuFunctions1: TMenuItem;
    mnuGraphData: TMenuItem;
    mnuInverseValues: TMenuItem;
    mnuMHasNumeric1: TMenuItem;
    mnuPopGraph3D: TMenuItem;
    mnuPopGraphClear: TMenuItem;
    mnuPopGraphCopy: TMenuItem;
    mnuPopGraphDates: TMenuItem;
    mnuPopGraphDefineViews: TMenuItem;
    mnuPopGraphDetails: TMenuItem;
    mnuPopGraphDualViews: TMenuItem;
    mnuPopGraphGradient: TMenuItem;
    mnuPopGraphExport: TMenuItem;
    mnuPopGraphFixed: TMenuItem;
    mnuPopGraphHints: TMenuItem;
    mnuPopGraphHorizontal: TMenuItem;
    mnuPopGraphIsolate: TMenuItem;
    mnuPopGraphLegend: TMenuItem;
    mnuPopGraphLines: TMenuItem;
    mnuPopGraphMergeLabs: TMenuItem;
    mnuPopGraphPrint: TMenuItem;
    mnuPopGraphRemove: TMenuItem;
    mnuPopGraphReset: TMenuItem;
    mnuPopGraphSeparate1: TMenuItem;
    mnuPopGraphSort: TMenuItem;
    mnuPopGraphSplit: TMenuItem;
    mnuPopGraphStayOnTop: TMenuItem;
    mnuPopGraphStuff: TPopupMenu;
    mnuPopGraphSwap: TMenuItem;
    mnuPopGraphToday: TMenuItem;
    mnuPopGraphValues: TMenuItem;
    mnuPopGraphValueMarks: TMenuItem;
    mnuPopGraphVertical: TMenuItem;
    mnuPopGraphViewDefinition: TMenuItem;
    mnuPopGraphZoomBack: TMenuItem;
    mnuStandardDeviations: TMenuItem;
    mnuTest: TMenuItem;
    mnuTestCount: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    pcBottom: TPageControl;
    pcTop: TPageControl;
    pnlBlankBottom: TPanel;
    pnlBlankTop: TPanel;
    pnlBottom: TPanel;
    pnlBottomRightPad: TPanel;
    pnlDatelineBottom: TPanel;
    pnlDatelineBottomSpacer: TORAutoPanel;
    pnlDatelineTop: TPanel;
    pnlDatelineTopSpacer: TORAutoPanel;
    pnlFooter: TPanel;
    pnlHeader: TPanel;
    pnlInfo: TORAutoPanel;
    pnlItemsBottom: TPanel;
    pnlItemsBottomInfo: TPanel;
    pnlItemsTop: TPanel;
    pnlItemsTopInfo: TPanel;
    pnlMain: TPanel;
    pnlScrollBottomBase: TPanel;
    pnlScrollTopBase: TPanel;
    pnlTemp: TPanel;
    pnlTop: TPanel;
    pnlTopRightPad: TPanel;
    scrlBottom: TScrollBox;
    scrlTop: TScrollBox;
    serDatelineBottom: TGanttSeries;
    serDatelineTop: TGanttSeries;
    splGraphs: TSplitter;
    splItemsBottom: TSplitter;
    splItemsTop: TSplitter;
    splViewsBottom: TSplitter;
    splViewsTop: TSplitter;
    timHintPause: TTimer;
    tsBottomCustom: TTabSheet;
    tsBottomItems: TTabSheet;
    tsBottomViews: TTabSheet;
    tsTopCustom: TTabSheet;
    tsTopItems: TTabSheet;
    tsTopViews: TTabSheet;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);

    procedure btnCloseClick(Sender: TObject);
    procedure btnChangeSettingsClick(Sender: TObject);
    procedure btnGraphSelectionsClick(Sender: TObject);

    procedure chkDualViewsClick(Sender: TObject);
    procedure chkItemsBottomClick(Sender: TObject);
    procedure chkItemsBottomEnter(Sender: TObject);
    procedure chkItemsTopClick(Sender: TObject);
    procedure mnuPopGraph3DClick(Sender: TObject);
    procedure mnuPopGraphClearClick(Sender: TObject);
    procedure mnuPopGraphDatesClick(Sender: TObject);
    procedure mnuPopGraphDetailsClick(Sender: TObject);
    procedure mnuPopGraphDualViewsClick(Sender: TObject);
    procedure mnuPopGraphExportClick(Sender: TObject);
    procedure mnuPopGraphFixedClick(Sender: TObject);
    procedure mnuPopGraphGradientClick(Sender: TObject);
    procedure mnuPopGraphHintsClick(Sender: TObject);
    procedure mnuPopGraphHorizontalClick(Sender: TObject);
    procedure mnuPopGraphIsolateClick(Sender: TObject);
    procedure mnuPopGraphLegendClick(Sender: TObject);
    procedure mnuPopGraphLinesClick(Sender: TObject);
    procedure mnuPopGraphMergeLabsClick(Sender: TObject);
    procedure mnuPopGraphPrintClick(Sender: TObject);
    procedure mnuPopGraphRemoveClick(Sender: TObject);
    procedure mnuPopGraphResetClick(Sender: TObject);
    procedure mnuPopGraphSeparate1Click(Sender: TObject);
    procedure mnuPopGraphStayOnTopClick(Sender: TObject);
    procedure mnuPopGraphSortClick(Sender: TObject);
    procedure mnuPopGraphSplitClick(Sender: TObject);
    procedure mnuPopGraphStuffPopup(Sender: TObject);
    procedure mnuPopGraphSwapClick(Sender: TObject);
    procedure mnuPopGraphTodayClick(Sender: TObject);
    procedure mnuPopGraphValueMarksClick(Sender: TObject);
    procedure mnuPopGraphValuesClick(Sender: TObject);
    procedure mnuPopGraphVerticalClick(Sender: TObject);
    procedure mnuPopGraphZoomBackClick(Sender: TObject);

    procedure splGraphsMoved(Sender: TObject);
    procedure splItemsBottomMoved(Sender: TObject);
    procedure splItemsTopMoved(Sender: TObject);

    procedure lvwItemsBottomChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvwItemsBottomClick(Sender: TObject);
    procedure lvwItemsBottomColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvwItemsBottomCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvwItemsTopChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvwItemsTopClick(Sender: TObject);
    procedure lvwItemsTopColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvwItemsTopCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvwItemsTopKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure cboDateRangeChange(Sender: TObject);
    procedure cboDateRangeDropDown(Sender: TObject);

    procedure chartBaseClickLegend(Sender: TCustomChart;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure chartBaseClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure chartBaseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chartBaseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chartBaseMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure serDatelineTopGetMarkText(Sender: TChartSeries;
      ValueIndex: Integer; var MarkText: String);

    procedure ChartOnUndoZoom(Sender: TObject);
    procedure ChartOnZoom(Sender: TObject);
    procedure DateSteps(dateranges: string);
    procedure DisplayData(aSection: string);
    procedure DisplayDataInfo(aScrollBox: TScrollBox; aMemo: TMemo);
    procedure GraphSwap(bottomview, topview: integer);
    procedure GraphSwitch(bottomview, topview: integer);
    procedure FormatHint(var astring: string);
    procedure HideDates(aChart: TChart);
    procedure LabelClicks(aChart: TChart; aSeries: TChartSeries; lbutton: boolean; tmp: integer);
    procedure LabNameResults(astring: string; var labname, labresult: string);
    procedure MouseClicks(aChart: TChart; lbutton: boolean; X, Y: Integer);
    procedure PositionSelections(aListView: TListView);
    procedure SeriesClicks(aChart: TChart; aSeries: TChartSeries; aIndex: integer; lbutton: boolean);
    procedure SetupFields(settings: string);
    procedure SourcesDefault;
    procedure StayOnTop;

    procedure ZoomUpdate;
    procedure ZoomUpdateInfo(SmallTime, BigTime: TDateTime);
    procedure ZoomTo(SmallTime, BigTime: TDateTime);

    procedure lvwItemsBottomEnter(Sender: TObject);
    procedure lvwItemsTopEnter(Sender: TObject);

    procedure memBottomEnter(Sender: TObject);
    procedure memBottomExit(Sender: TObject);
    procedure memBottomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure memTopEnter(Sender: TObject);
    procedure memTopExit(Sender: TObject);
    procedure memTopKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure pnlScrollTopBaseResize(Sender: TObject);
    procedure timHintPauseTimer(Sender: TObject);

    procedure GetSize;
    procedure SetSize;
    procedure lstViewsBottomChange(Sender: TObject);
    procedure lstViewsBottomEnter(Sender: TObject);
    procedure lstViewsTopChange(Sender: TObject);
    procedure lstViewsTopEnter(Sender: TObject);
    procedure lstViewsTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuCustomClick(Sender: TObject);
    procedure mnuGraphDataClick(Sender: TObject);
    procedure mnuMHasNumeric1Click(Sender: TObject);
    procedure mnuPopGraphViewDefinitionClick(Sender: TObject);
    procedure splViewsTopMoved(Sender: TObject);
    procedure cboDateRangeExit(Sender: TObject);

  private
    FBSortAscending: boolean;
    FBSortCol: integer;
    FDate1: Double;
    FDate2: Double;
    FSortAscending: boolean;
    FSortCol: integer;

    FActiveGraph: TChart;
    FArrowKeys: boolean;
    FBHighTime, FBLowTime: Double;
    FCreate: boolean;
    FDisplayFreeText: boolean;
    FFastData: boolean;
    FFastItems: boolean;
    FFastLabs: boolean;
    FFastTrack: boolean;
    FFirstClick: boolean;
    FFirstSwitch: boolean;
    FGraphClick: TCustomChart;
    FGraphSeries: TChartSeries;
    FGraphSetting: TGraphSetting;
    FGraphType: char;
    FGraphValueIndex: integer;
    FItemsSortedTop: boolean;
    FItemsSortedBottom: boolean;
    FMouseDown: boolean;
    FMTimestamp: string;
    FMToday: TFMDateTime;
    FNonNumerics: boolean; // used with pnlItemsTop.Tag & pnlItemsBottom.Tag
    FOnLegend:  integer;
    FOnMark: boolean;
    FOnSeries: integer;
    FOnValue: integer;
    FPointClick: boolean;
    FPrevEvent: string;
    FRetainZoom: boolean;
    FSources: TStrings;
    FSourcesDefault: TStrings;
    FTHighTime, FTLowTime: Double;
    FWarning: boolean;
    FX, FY: integer;
    FYMinValue: Double;
    FYMaxValue: Double;

    procedure AddOnLabGroups(aListBox: TORListBox; personien: int64);
    procedure AdjustTimeframe;
    procedure AllTypeDate(aType, aTypeName, firstline, secondline: string; aDate, aDate2: double);
    procedure AllDetails(aDate1, aDate2: TFMDateTime; aTempList: TStrings);
    procedure AssignProfile(aProfile, aSection: string);
    procedure AutoSelect(aListView: TListView);
    procedure BaseResize(aScrollBox: TScrollBox);
    procedure BorderValue(var bordervalue: double; value: double);
    procedure BottomAxis(aScrollBox: TScrollBox);
    procedure BPAdd(itemvalue: string; adatetime: TDateTime; var fixeddatevalue: double; serLine, serBPDiastolic, serBPMean: TLineSeries);
    procedure BPCheck(aChart: TChart; aFileType: string; serLine, serBPDiastolic, serBPMean: TLineSeries);
    procedure ChangeStyle;
    procedure ChartColor(aColor: TColor);
    procedure ChartStyle(aChart: TChart);
    procedure CheckExpandedLabs(aListView: TListView);
    procedure CheckMedNum(var typenum: string; aSeries: TChartSeries);
    procedure CheckProfile(var aProfile: string; var Updated: boolean);
    procedure CheckToAddData(aListView: TListView; aSection, TypeToCheck: string);
    procedure CreateExcelPatientHeader(var HeaderList: TStringList; PageTitle, Warning, DateRange: string);
    procedure CreatePatientHeader(var HeaderList: TStringList; PageTitle, Warning, DateRange: string);
    procedure DateRangeItems(oldestdate, newestdate: double; filenum: string);
    procedure DisplayType(itemtype, displayed: string);
    procedure FastLab(aList: TStringList);
    procedure FillViews;
    procedure FilterListView(oldestdate, newestdate: double);
    procedure FixedDates(var adatetime, adatetime1: TDateTime);
    procedure GetData(aString: string);
    procedure GraphBoundry(singlepoint: boolean);
    procedure GraphFooter(aChart: TChart; datediff: integer; aDate: TDateTime);
    procedure HideGraphs(action: boolean);
    procedure HighLow(fmtime, fmtime1: string; aChart: TChart; var adatetime, adatetime1: TDateTime);
    procedure InactivateHint;
    procedure InfoMessage(aCaption: string; aColor: TColor; aVisible: boolean);
    procedure ItemCheck(aListView: TListView; aItemName: string;
      var aNum: integer; var aTypeItem: string);
    procedure ItemDateRange(Sender: TCustomChart);
    procedure ItemsClick(Sender: TObject; aListView, aOtherListView: TListView;
      aCheckBox: TCheckBox; aListBox: TORListBox; aList: TStrings; aSection: string);
    procedure LabAdd(aListView: TListView; filename: string; aIndex, oldlisting: integer; selectlab: boolean);
    procedure LabCheck(aListView: TListView; aItemType: string; var oldlisting: integer);
    procedure LabData(aItemType, aItemName, aSection: string; getdata: boolean);
    procedure LoadDateRange;
    procedure LoadDisplayCheck(typeofitem: string; var updated: boolean);
    procedure LoadType(itemtype, displayed: string);
    procedure NextPointerStyle(aSeries: TChartSeries; aSerCnt: integer);
    procedure NonNumSave(aChart: TChart; aTitle, aSection: string; adatetime: TDateTime;
      var noncnt: integer; newcnt, aIndex: integer);
    procedure NotifyApps(aList: TStrings);
    procedure NumAdd(serLine: TLineSeries; value: double; adatetime: TDateTime;
      var fixeddatevalue, hi, lo: double; var high, low: string);
    procedure OneDayTypeDetails(aTypeItem: string);
    procedure OtherInfo(aTypeItem, aResult: string; aDateTime: double; var moreinfo: string);
    procedure PadNonNum(aChart: TChart; aSection: string; var listofseries: string; var bmax, tmax: integer);
    procedure PainAdd(serBlank: TPointSeries);
    procedure RefUnits(aItem, aSpec: string; var low, high, units: string);
    procedure ResultValue(var resultstring, seriestitle: string; typenum, typeitem: string;
      Sender: TCustomChart; aSeries: TChartSeries; ValueIndex, SeriesNum: Integer; var OKToUse: boolean);
    procedure SaveTestData(typeitem: string);
    procedure SelCopy(aListView: TListView; aList: TStrings);
    procedure SelReset(aList: TStrings; aListView: TListView);
    procedure SelectItem(aListView: TListView; typeitem: string);
    procedure SeriesForLabels(aChart: TChart; aID: string; pad: double);
    procedure SetProfile(aProfile, aName: string; aListView: TListView);
    procedure SetRef(var datax: string);
    procedure SetRefNonNum(var datax: string);
    procedure SizeDates(aChart: TChart; aSmallTime, aBigTime: TDateTime);
    procedure SizeTogether(onlylines, nolines, anylines: Boolean; aScroll: TScrollBox;
      aChart: TChart; aPanel, aPanelBase: TPanel; portion: Double);
    procedure SpecRefCheck(aItemType, aItemName: string; var singlespec: boolean);
    procedure SpecRefSet(aItemType, aItemName: string);
    procedure SplitClick;
    procedure SortListView;
    procedure StackNonNum(astring: string; var offset, bmax, tmax: integer; var blabelon, tlabelon: boolean);
    procedure TempCheck(typeitem: string; var levelseq: double);
    procedure TempData(aStringList: TStringList; aType: string; dt1, dt2: double);
    procedure UpdateView(filename, filenum, itemnum, aString: string; aListView: TListView);
    procedure ValueDates(aSeries: TChartSeries; ValueIndex: Integer; var resultdate, otherdate: string; var startdate: double);
    procedure ViewsChange(aListView: TListView; aListBox: TORListBox; aSection: string);

    procedure MakeSeparate(aScrollBox: TScrollBox; aListView: TListView; aPadPanel: TPanel; section: string);
    procedure MakeSeparateItems(aScrollBox: TScrollBox; aListView: TListView; section: string);
    procedure MakeTogether(aScrollBox: TScrollBox; aListView: TListView; aPadPanel: TPanel; section: string);
    procedure MakeTogetherMaybe(aScrollBox: TScrollBox; aListView: TListView; aPadPanel: TPanel; section: string);
    procedure MakeTogetherNoLines(aListView: TListView; section: string);
    procedure MakeTogetherOnlyLines(aListView: TListView; section: string; aChart: TChart);
    procedure MakeTogetherAnyLines(aListView: TListView; section: string; aChart: TChart);

    procedure MakeChart(aChart: TChart; aScrollBox: TScrollBox);
    procedure MakeComments(aChart: TChart);
    procedure MakeDateline(section, aTitle, aFileType: string; aChart: TChart; graphtype: integer;
      var bcnt, pcnt, gcnt, vcnt: integer);
    procedure MakeNonNumerics(aChart: TChart);
    procedure MakeNonNumSeries(aChart: TChart; padvalue, highestvalue, lowestvalue: double; listofseries, section: string);
    procedure MakeOtherSeries(aChart: TChart);
    procedure MakeSeriesInfo(aChart: TChart; aSeries: TChartSeries; aTitle, aFileType: string; aSerCnt: integer);
    procedure MakeSeriesPoint(aChart: TChart; aPointSeries: TPointSeries);
    procedure MakeSeriesRef(aChart: TChart; aTest, aRef: TLineSeries; aTitle, aValue: string; aDate: double);
    procedure MakeSeriesBP(aChart: TChart; aTest, aBP: TLineSeries; aFileType: string);

    procedure MakeBarSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);
    procedure MakeLineSeries(aChart: TChart; aTitle, aFileType, section: string;
      var aSerCnt, aNonCnt: integer; multiline: boolean);
    procedure MakeGanttSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);  // good one
    procedure MakePointSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);
    procedure MakeVisitGanttSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);

    function BPValue(aDateTime: TDateTime): string;
    function DateRangeMultiItems(aOldDate, aNewDate: double; aMultiItem: string): boolean;
    function DatesInRange(EarlyDate, RecentDate, Date1, Date2: double): boolean;
    function DCName(aDCien: string): string;
    function ExpandTax(profile: string): string;
    function FileNameX(filenum: string): string;
    function FMCorrectedDate(fmtime: string): string;
    function GraphTypeNum(aType: string): integer;
    function HSAbbrev(aType: string): boolean;
    function InvVal(value: double): double;
    function ItemName(filenum, itemnum: string): string;
    function MergedLabsSelected: boolean;
    function NextColor(aCnt: integer): TColor;
    function NonNumText(listnum, seriesnum, valueindex: integer): string;
    function PadLeftEvent(aWidth: integer): integer;
    function PadLeftNonNumeric(aWidth: integer): integer;
    function PortionSize(lcnt, pcnt, gcnt, vcnt, bcnt: integer): double;
    function ProfileName(aProfile, aName, aString: string): string;
    function SelectRef(aRef: string): string;
    function SingleLabTest(aListView: TListView): boolean;
    function StdDev(value, high, low: double): double;
    function TitleInfo(filetype, typeitem, caption: string): string;
    function TypeIsDisplayed(itemtype: string): boolean;
    function TypeIsLoaded(itemtype: string): boolean;
    function TypeString(filenum: string): string;
    function ValueText(Sender: TCustomChart; aSeries: TChartSeries; ValueIndex: Integer): string;
  protected
    procedure UpdateAccessibilityActions(var Actions: TAccessibilityActions); override;
  public
    procedure CheckContext(var usecontext: boolean);
    procedure DateDefaults;
    procedure DisplayFreeText(aChart: TChart);
    procedure InitialData;
    procedure Initialize;
    procedure InitialRetain;
    procedure LoadListView(aList: TStrings);
    procedure SetFontSize(FontSize: integer);
    procedure SourceContext;
    procedure Switch;
    procedure ViewDefinition(profile: string; amemo: TRichEdit);
    procedure ViewSelections;

    function FMToDateTime(FMDateTime: string): TDateTime;
  end;

var
  frmGraphs: TfrmGraphs;
  FHintWin: THintWindow;
  FHintWinActive: boolean;
  FHintStop: boolean;
  uDateStart, uDateStop: double;

implementation

uses fGraphSettings, fGraphProfiles, fGraphData, fGraphOthers, rGraphs,
  ComObj, ActiveX, ShellAPI, fFrame, uCore, rCore, uConst, fRptBox, fReports,
  uFormMonitor, VA508AccessibilityRouter, VAUtils;

{$R *.DFM}

type
  TGraphItem = class
  public
    Values: string;
end;

procedure TfrmGraphs.FormCreate(Sender: TObject);
var
  i: integer;
  dfntype, listline, settings, settings1: string;
begin
  btnClose.Tag := 0;
  settings := GetCurrentSetting;
  if (length(settings) < 1) then
  begin
    Screen.Cursor := crDefault;
    ShowMsg(TXT_NOGRAPHING);
    btnClose.Tag := 1;
    Close;
    Exit;
  end;
  SetupFields(settings);
  settings1 := Piece(settings, '|', 1);
  pnlInfo.Caption := TXT_INFO;
  for i := 1 to BIG_NUMBER do
  begin
    dfntype := Piece(settings1, ';', i);
    if length(dfntype) = 0 then break;
    listline := dfntype + '^' + FileNameX(dfntype) + '^1';
    FSources.Add(listline);
    FSourcesDefault.Add(listline);
  end;
  serDatelineTop.Active := false;
  serDatelineBottom.Active := false;
  chartDatelineTop.Gradient.EndColor := clGradientActiveCaption;
  chartDatelineTop.Gradient.StartColor := clWindow;
  chartDatelineBottom.Gradient.EndColor := clGradientActiveCaption;
  chartDatelineBottom.Gradient.StartColor := clWindow;
  LoadDateRange;
  //chkItemsTop.Checked := true;
  //chkItemsBottom.Checked := true;
  FillViews;
  pcTop.ActivePage := tsTopItems;
  pcBottom.ActivePage := tsBottomItems;
end;

procedure TfrmGraphs.SetupFields(settings: string);
begin
  FArrowKeys := false;
  FBHighTime := 0;
  FBLowTime := BIG_NUMBER;
  FCreate := true;
  FDisplayFreeText := true;
  FGraphType := Char(32);
  FFirstClick := true;
  FFirstSwitch := true;
  FGraphSetting := GraphSettingsInit(settings);
  FHintStop := false;
  FHintWin := THintWindow.Create(self);
  FHintWin.Color := clInfoBk;
  FHintWin.Canvas.Font.Color := clInfoBk;
  FHintWinActive := false;
  FItemsSortedBottom := false;
  FItemsSortedTop := false;
  FMouseDown := false;
  FMTimestamp := floattostr(FMNow);
  FMToday := DateTimeToFMDateTime(Date);
  FNonNumerics := false;
  FOnLegend := BIG_NUMBER;
  FOnMark := false;
  FOnSeries := BIG_NUMBER;
  FOnValue := BIG_NUMBER;
  FPointClick := false;
  FPrevEvent := '';
  FRetainZoom := false;
  FSources := TStringList.Create;
  FSourcesDefault := TStringList.Create;
  FTHighTime := 0;
  FTLowTime := BIG_NUMBER;
  FWarning := false;
  FX := 0; FY :=0;
  FYMinValue := 0;
  FYMaxValue := 0;
  uDateStart := 0;
  uDateStop  := 0;
end;

procedure TfrmGraphs.SourcesDefault;
var
  i: integer;
  dfntype, listline, settings, settings1: string;
begin
  settings := GetCurrentSetting;
  settings1 := Piece(settings, '|', 1);
  for i := 1 to BIG_NUMBER do
  begin
    dfntype := Piece(settings1, ';', i);
    if length(dfntype) = 0 then break;
    listline := dfntype + '^' + FileNameX(dfntype) + '^1';
    FSourcesDefault.Add(listline);
  end;
end;

procedure TfrmGraphs.Initialize;
var                                        // from fFrame and fReports
  i: integer;
  rptview1, rptview2, rptviews: string;
begin
  InitialData;
  SourceContext;
  LoadListView(GtslItems);
  if pnlMain.Tag > 0 then
  begin
    rptviews := MixedCase(rpcReportParams(pnlMain.Tag));
    if length(rptviews) > 1 then
    begin
      lstViewsTop.ClearSelection;
      lvwItemsTop.ClearSelection;
      GtslSelCopyTop.Clear;
      GtslSelPrevTopFloat.Clear;
      lstViewsBottom.ClearSelection;
      lvwItemsBottom.ClearSelection;
      GtslSelCopyBottom.Clear;
      GtslSelPrevBottomFloat.Clear;
      rptview1 := Piece(rptviews, '^', 1);
      rptview2 := Piece(rptviews, '^', 2);
      if length(rptview1) > 0 then
      begin
        for i := 0 to lstViewsTop.Items.Count - 1 do
        if Piece(lstViewsTop.Items[i], '^', 2) = rptview1 then
        begin
          lstViewsTop.ItemIndex := i;
          break;
        end;
      end;
      if length(rptview2) > 0 then
      begin
        chkDualViews.Checked := true;
        chkDualViewsClick(self);
        for i := 0 to lstViewsBottom.Items.Count - 1 do
        if Piece(lstViewsBottom.Items[i], '^', 2) = rptview2 then
        begin
          lstViewsBottom.ItemIndex := i;
          break;
        end;
      end;
    end;
  end;
  if lstViewsTop.ItemIndex > -1 then
    lstViewsTopChange(self)
  else
    lvwItemsTopClick(self);
  if lstViewsBottom.ItemIndex > -1 then
  begin
    //lstViewsBottom.Tag := 0;     // **** reset to allow bottom graphs
    lstViewsbottomChange(self);
  end
  else
    lvwItemsBottomClick(self);
  if pnlMain.Tag > 0 then
  begin
    pnlMain.Tag := 0;
    cboDateRangeChange(self);
    if lstViewsTop.ItemIndex > -1 then
      lstViewsTopChange(self)
    else
      lvwItemsTopClick(self);
    if lstViewsBottom.ItemIndex > -1 then
      lstViewsbottomChange(self)
    else
      lvwItemsBottomClick(self);
  end;
end;

procedure TfrmGraphs.InitialRetain;
begin
  // from fFrame
end;

procedure TfrmGraphs.FillViews;
var
  i: integer;
  listline: string;
begin
  lstViewsTop.Tag := BIG_NUMBER;
  lstViewsBottom.Tag := BIG_NUMBER;
  lstViewsTop.Sorted := false;
  lstViewsBottom.Sorted := false;
  lstViewsTop.Items.Clear;
  lstViewsBottom.Items.Clear;
  GtslViewPersonal.Sorted := true;
  FastAssign(GetGraphProfiles('1', '0', 0, User.DUZ), GtslViewPersonal);
  GtslViewPublic.Sorted := true;
  FastAssign(GetGraphProfiles('1', '1', 0, 0), GtslViewPublic);
  with lstViewsTop do
  begin
    if GtslViews.Count > 0 then
    begin
      if not ((GtslViews.Count = 1) and (Piece(GtslViews[0], '^', 1) = VIEW_CURRENT)) then
      begin
        Items.Add(LLS_FRONT + copy('Temporary Views' + LLS_BACK, 0, 60) + '^0');
        for i := 0 to GtslViews.Count - 1 do
        begin
          listline := GtslViews[i];
          if Piece(listline, '^', 1) <> VIEW_CURRENT then
            Items.Add(VIEW_TEMPORARY + '^' + listline + '^');
        end;
      end;
    end;
    if GtslViewPersonal.Count > 0 then
    begin
      Items.Add(LLS_FRONT + copy('Personal Views' + LLS_BACK, 0, 60) + '^0');
      for i := 0 to GtslViewPersonal.Count - 1 do
        Items.Add(VIEW_PERSONAL + '^' + GtslViewPersonal[i] + '^');
    end;
    if GtslViewPublic.Count > 0 then
    begin
      Items.Add(LLS_FRONT + copy('Public Views' + LLS_BACK, 0, 60) + '^0');
      for i := 0 to GtslViewPublic.Count - 1 do
        Items.Add(VIEW_PUBLIC + '^' + GtslViewPublic[i] + '^');
    end;
    AddOnLabGroups(lstViewsTop, 0);
  end;
  FastAssign(lstViewsTop.Items, lstViewsBottom.Items);
end;

procedure TfrmGraphs.AddOnLabGroups(aListBox: TORListBox; personien: int64);
var
  i: integer;
begin
  if personien < 1 then personien := User.DUZ;
  FastAssign(rpcTestGroups(personien), GtslLabGroup);
  GtslLabGroup.Sorted := true;
  if GtslLabGroup.Count > 0 then
  begin
    aListBox.Items.Add(LLS_FRONT + copy('Lab Groups' + LLS_BACK, 0, 60) + '^0');
    for i := 0 to GtslLabGroup.Count - 1 do
      aListBox.Items.Add(VIEW_LABS + '^' + Piece(GtslLabGroup[i], '^', 2)
        + '^' + Piece(GtslLabGroup[i], '^', 1) + '^' + inttostr(personien));
  end;
end;

procedure TfrmGraphs.SourceContext;
begin
  if frmFrame.GraphContext = '' then exit;
  frmFrame.GraphContext := '';
end;

procedure TfrmGraphs.FormShow(Sender: TObject);
var
  context: boolean;
begin
  Font := MainFont;
  ChangeStyle;
  StayOnTop;
  mnuPopGraphResetClick(self);
  if pnlFooter.Tag = 1 then  // do not show footer controls on reports tab
  begin
    pnlFooter.Visible := false;
    if FCreate then
    begin
      FGraphType := GRAPH_REPORT;
      FCreate := false;
      GetSize;
    end;
  end
  else
  begin
    chkDualViews.Checked := false;
    chkDualViewsClick(self);
    if FCreate then
    begin
      FGraphType := GRAPH_FLOAT;
      FCreate := false;
      GetSize;
    end;
  end;
  if length(pnlFooter.Hint) > 1 then      // if context use all results
    cboDateRange.ItemIndex := 7
  else
    DateDefaults;
  cboDateRangeChange(self);
  CheckContext(context);
  lvwItemsTopClick(self);
  if lvwItemsTop.Items.Count = 0 then
  begin
    lstViewsTop.ItemIndex := -1
  end;
  if not mnuPopGraphViewDefinition.Checked then
    mnuPopGraphViewDefinitionClick(self);
  tsTopCustom.TabVisible := false;
  tsBottomCustom.TabVisible := false;
end;

procedure TfrmGraphs.CheckContext(var usecontext: boolean);
var
  i, topitem: integer;
  contextvalue, itemcheck, itemvalue, typecheck, typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  usecontext := false;
  if length(pnlFooter.Hint) > 1 then
  begin
    lvwItemsBottom.ClearSelection;
    lvwItemsBottomClick(self);
    contextvalue := pnlFooter.Hint;
    //chkItemsTop.Caption := contextvalue;    // testing
    typecheck := Piece(contextvalue, '^', 1);
    itemcheck := Piece(contextvalue, '^', 2);
    lvwItemsTop.ClearSelection;
    topitem := 0;
    for i := 0 to lvwItemsTop.Items.Count - 1 do
    begin
      aListItem := lvwItemsTop.Items[i];
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := UpperCase(aGraphItem.Values);
      if Piece(typeitem, '^', 1) = typecheck then
      begin
        itemvalue := Piece(Piece(typeitem, '^', 2), '.', 1);
        if itemvalue = itemcheck then
        begin
          lvwItemsTop.Items[i].Selected := true;
          topitem := i;
        end;
      end;
    end;
    GtslSelCopyTop.Clear;
    if lvwItemsTop.SelCount > 0 then
      usecontext := true;
    if topitem > 0 then
      lvwItemsTop.Items[topitem].MakeVisible(true);
  end;
  pnlFooter.Hint := '';
end;

procedure TfrmGraphs.DateDefaults;
begin
  if Patient.Inpatient then
     cboDateRange.SelectByID(FGraphSetting.DateRangeInpatient)
  else
     cboDateRange.SelectByID(FGraphSetting.DateRangeOutpatient);
  if cboDateRange.ItemIndex < 0 then
    cboDateRange.ItemIndex := cboDateRange.Items.Count - 1;
end;

procedure TfrmGraphs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if btnClose.Tag = 1 then
    exit;
  SetSize;
  timHintPause.Enabled := false;
  InactivateHint;
  frmFrame.GraphFloatActive := false;
end;

procedure TfrmGraphs.GetSize;

  procedure SetWidth(aListView: TListView; v1, v2, v3, v4: integer);
  begin
    if v1 > 0 then aListView.Column[0].Width := v1;
    if v2 > 0 then aListView.Column[1].Width := v2;
    if v3 > 0 then aListView.Column[2].Width := v3;
    if v4 > 0 then aListView.Column[3].Width := v4;
  end;

  procedure Layout(name, FR: string; v1, v2, v3, v4: integer);
  begin  // FR indicates Float or Report graph
    if name = (FR + 'WIDTH') then
    begin
      if v1 > 0 then
      begin
        pnlItemsTop.Width := v1;
        splItemsTopMoved(self);
      end;
    end
    else if name = (FR + 'BOTTOM') then
    begin
      if v1 > 0 then
      begin
        chkDualViews.Checked := true;
        chkDualViewsClick(self);
        pnlBottom.Height := v1;
      end;
    end
    else if name = (FR + 'COLUMN') then
      SetWidth(lvwItemsTop, v1, v2, v3, v4)
    else if name = (FR + 'BCOLUMN') then
      SetWidth(lvwItemsBottom, v1, v2, v3, v4);
  end;


var
  i, v1, v2, v3, v4: integer;
  name, settings, value: string;
  aList: TStrings;
begin
  aList := TStringList.Create;
  FastAssign(rpcGetGraphSizing, aList);
  for i := 0 to aList.Count - 1 do
  begin
    settings := aList[i];
    name := Piece(settings, '^', 1);
    value := Piece(settings, '^', 2);
    if length(value) > 1 then
    begin
      v1 := strtointdef(Piece(value, ',', 1), 0);
      v2 := strtointdef(Piece(value, ',', 2), 0);
      v3 := strtointdef(Piece(value, ',', 3), 0);
      v4 := strtointdef(Piece(value, ',', 4), 0);
      if FGraphType = GRAPH_FLOAT then
      begin
        if name = 'FBOUNDS' then
        begin
          if value = '0,0,0,0' then
            WindowState := wsMaximized
          else
          begin
            if v1 > 0 then Left :=   v1;
            if v2 > 0 then Top :=    v2;
            if v3 > 0 then Width :=  v3;
            if v4 > 0 then Height := v4;
          end;
        end
        else
          Layout(name, 'F', v1, v2, v3, v4);
      end
      else
        Layout(name, 'R', v1, v2, v3, v4);
    end;
  end;
  FreeAndNil(aList);
end;

procedure TfrmGraphs.SetSize;

  procedure GetWidth(aListView: TListView; var v1, v2, v3, v4: string);
  begin
    v1 := inttostr(aListView.Column[0].Width);
    v2 := inttostr(aListView.Column[1].Width);
    v3 := inttostr(aListView.Column[2].Width);
    v4 := inttostr(aListView.Column[3].Width);
  end;

  procedure Layout(aList: TStrings; FR, v1, v2, v3, v4: string);
  begin // FR indicates Float or Report graph
    v1 := inttostr(splItemsTop.Left);
    aList.Add(FR + 'WIDTH^' + v1);
    if chkDualViews.Checked then
      v1 := inttostr(pnlBottom.Height)
    else
      v1 := '0';
    aList.Add(FR + 'BOTTOM^' + v1);
    GetWidth(lvwItemsTop, v1, v2, v3, v4);
    aList.Add(FR + 'COLUMN^' + v1 + ',' + v2 + ',' + v3 + ',' + v4);
    GetWidth(lvwItemsBottom, v1, v2, v3, v4);
    aList.Add(FR + 'BCOLUMN^' + v1 + ',' + v2 + ',' + v3 + ',' + v4);
  end;


var
  v1, v2, v3, v4: string;
  //values: array[0..3] of string;
  aList: TStrings;
begin
  aList := TStringList.Create;
  if FGraphType = GRAPH_FLOAT then
  begin
    v1 := inttostr(Left);
    v2 := inttostr(Top);
    v3 := inttostr(Width);
    v4 := inttostr(Height);
    if WindowState = wsMaximized then
      aList.Add('FBOUNDS^0,0,0,0')
    else
      aList.Add('FBOUNDS^' + v1 + ',' + v2 + ',' + v3 + ',' + v4);
    Layout(aList, 'F', v1, v2, v3, v4);
  end
  else
    Layout(aList, 'R', v1, v2, v3, v4);
  rpcSetGraphSizing(aList);
  FreeAndNil(aList);
end;

procedure TfrmGraphs.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGraphs.btnChangeSettingsClick(Sender: TObject);
var
  needtoupdate, okbutton: boolean;
  conv, i, preconv: integer;
  PreMaxGraphs: integer;
  PreMaxSelect: integer;
  PreMinGraphHeight: integer;
  PreSortColumn: integer;
  PreFixedDateRange: boolean;
  PreMergeLabs: boolean;
  aSettings, filetype, sourcetype: string;
  PreSources: TStrings;
begin
  Application.ProcessMessages;
  okbutton := false;
  conv := btnChangeSettings.Tag;
  preconv := conv;
  with FGraphSetting do
  begin
    PreMaxGraphs := MaxGraphs;
    PreMaxSelect := MaxSelect;
    PreMinGraphHeight := MinGraphHeight;
    PreSortColumn := SortColumn;
    PreFixedDateRange := FixedDateRange;
    MaxSelectMin := Max(Max(lvwItemsTop.SelCount, lvwItemsBottom.SelCount), 1);
    PreMergeLabs := MergeLabs;
  end;
  PreSources := TStringList.Create;
  FastAssign(FSources, PreSources);
  DialogGraphSettings(Font.Size, okbutton, FGraphSetting, FSources, conv, aSettings);
  if not okbutton then exit;
  if length(aSettings) > 0 then SetCurrentSetting(aSettings);
  btnChangeSettings.Tag := conv;
  pnlInfo.Font.Size := chkItemsTop.Font.Size;
  SetFontSize(chkItemsTop.Font.Size);
  InfoMessage(TXT_WARNING, COLOR_WARNING, (conv > 0));
  if MergedLabsSelected then
    InfoMessage(pnlInfo.Caption + ' ' + TXT_WARNING_MERGED_LABS, COLOR_WARNING, true);
  pnlHeader.Visible := pnlInfo.Visible;
  StayOnTop;
  needtoupdate := (conv <> preconv);
  for i := 0 to FSources.Count - 1 do
  begin
    sourcetype := FSources[i];
    if Copy(sourcetype, 1, 1) = '*' then
    begin
      FSources[i] := Pieces(sourcetype, '^', 2, 4);
      if not FFastItems then
      begin
        filetype := Piece(FSources[i], '^', 1);
        FastAddStrings(rpcGetItems(filetype, Patient.DFN), GtslItems);
        needtoupdate := true;
      end;
    end;
    if not needtoupdate then
      if Piece(PreSources[i], '^', 3) = '0' then
        needtoupdate := TypeIsDisplayed(Piece(sourcetype, '^', 1))
      else
        needtoupdate := not TypeIsDisplayed(Piece(sourcetype, '^', 1));
  end;
  if not needtoupdate then
  with FGraphSetting do
    if MaxGraphs <> PreMaxGraphs then
      needtoupdate := true
    else if MaxSelect <> PreMaxSelect then
      needtoupdate := true
    else if MinGraphHeight <> PreMinGraphHeight then
      needtoupdate := true
    else if SortColumn <> PreSortColumn then
      needtoupdate := true
    else if MergeLabs <> PreMergeLabs then
      needtoupdate := true
    else if FixedDateRange <> PreFixedDateRange then
      needtoupdate := true;
  if needtoupdate then
  begin
    cboDateRangeChange(self);
    if FGraphSetting.MergeLabs <> PreMergeLabs then
    begin
      PositionSelections(lvwItemsTop);
      PositionSelections(lvwItemsBottom);
    end;
  end;
  ChangeStyle;
  if lvwItemsTop.SelCount = 0 then
  begin
    lstViewsTop.ItemIndex := -1;
  end;
  if lvwItemsBottom.SelCount = 0 then
  begin
    lstViewsBottom.ItemIndex := -1;
  end;
  FreeAndNil(PreSources);
end;

procedure TfrmGraphs.chkDualViewsClick(Sender: TObject);
begin
  if chkDualViews.Checked then
  begin
    pnlBottom.Height := pnlMain.Height div 2;
    lvwItemsTopClick(self);
  end
  else
  begin
    lvwItemsBottom.ClearSelection;
    lvwItemsBottomClick(self);
    pnlBottom.Height := 1;
  end;
  mnuPopGraphDualViews.Checked := chkDualViews.Checked;
  with pnlMain.Parent do
    if BorderWidth <> 1 then            // only do on Graph in Reports tab
      frmReports.chkDualViews.Checked := chkDualViews.Checked;
end;

procedure TfrmGraphs.LoadListView(aList: TStrings);
var
  i: integer;
  filename, filenum, itemnum: string;
begin
  lvwItemsTop.Items.Clear;
  lvwItemsBottom.Items.Clear;
  lvwItemsTop.Items.BeginUpdate;
  lvwItemsBottom.Items.BeginUpdate;
  lvwItemsTop.SortType := stNone; // if Sorting during load then potential error
  lvwItemsBottom.SortType := stNone; // if Sorting during load then potential error
  with lvwItemsTop do
  for i := 0 to aList.Count - 1 do
  begin
    filenum := Piece(aList[i], '^', 1);
    filename := FileNameX(filenum);    // change rpc **********
    itemnum := Piece(aList[i], '^', 2);
    UpdateView(filename, filenum, itemnum, aList[i], lvwItemsTop);
  end;
  lvwItemsBottom.Items.Assign(lvwItemsTop.Items);
  lvwItemsTop.SortType := stBoth;
  lvwItemsBottom.SortType := stBoth;
  if not FItemsSortedTop then
  begin
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[0]);
    FItemsSortedTop := true;
  end;
  if not FItemsSortedBottom then
  begin
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[0]);
    FItemsSortedBottom := true;
  end;
  with FGraphSetting do
  if SortColumn > 0 then
  begin
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[SortColumn]);
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[SortColumn]);
    FItemsSortedTop := false;
    FItemsSortedBottom := false;
  end;
  lvwItemsTop.Items.EndUpdate;
  lvwItemsBottom.Items.EndUpdate;
end;

procedure TfrmGraphs.FilterListView(oldestdate, newestdate: double);
var
  i: integer;
  lastdate: double;
  filename, filenum, itemnum: string;
begin
  lvwItemsTop.Scroll(-BIG_NUMBER, -BIG_NUMBER);      //faster to set scroll at top
  lvwItemsBottom.Scroll(-BIG_NUMBER, -BIG_NUMBER);
  lvwItemsTop.Items.Clear;
  lvwItemsBottom.Items.Clear;
  lvwItemsTop.SortType := stNone; // if Sorting during load then potential error
  lvwItemsBottom.SortType := stNone; // if Sorting during load then potential error
  if (cboDateRange.ItemIndex > 0) and (cboDateRange.ItemIndex < 8) then
  begin
    if TypeIsDisplayed('405') then
      DateRangeItems(oldestdate, newestdate, '405');  // does not matter for all results ******************
    if TypeIsDisplayed('52') then
      DateRangeItems(oldestdate, newestdate, '52');  // does not matter for all results ******************
    if TypeIsDisplayed('55') then
      DateRangeItems(oldestdate, newestdate, '55');
    if TypeIsDisplayed('55NVA') then
      DateRangeItems(oldestdate, newestdate, '55NVA');
    if TypeIsDisplayed('9999911') then
      DateRangeItems(oldestdate, newestdate, '9999911');
    for i := 0 to GtslItems.Count - 1 do
    begin
      filenum := UpperCase(Piece(GtslItems[i], '^', 1));
      if filenum <> '405' then
      if filenum <> '52' then
      if filenum <> '55' then
      if filenum <> '55NVA' then
      if filenum <> '9999911' then
      if TypeIsDisplayed(filenum) then
      begin
        lastdate := strtofloatdef(Piece(GtslItems[i], '^', 6), -BIG_NUMBER);
        if (lastdate > oldestdate) and (lastdate < newestdate) then
        begin
          filename := FileNameX(filenum);
          itemnum := Piece(GtslItems[i], '^', 2);
          UpdateView(filename, filenum, itemnum, GtslItems[i], lvwItemsTop);
        end;
      end;
    end;
  end
  else if (cboDateRange.ItemIndex = 0) or (cboDateRange.ItemIndex > 7) then
  begin     // manual date range selection
    for i := 0 to GtslAllTypes.Count - 1 do
    begin
      filenum := Piece(GtslAllTypes[i], '^', 1);
      if TypeIsDisplayed(filenum) then
      begin
        DateRangeItems(oldestdate, newestdate, filenum);
      end;
    end;
  end;
  lvwItemsBottom.Items.Assign(lvwItemsTop.Items);
  SortListView;
end;

procedure TfrmGraphs.SortListView;
var
  colnum: integer;
  aProfile: string;
begin
  lvwItemsTop.SortType := stBoth;
  lvwItemsBottom.SortType := stBoth;
  colnum := 0;
  if not FItemsSortedTop then
  begin
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[0]);
    FItemsSortedTop := true;
  end;
  if not FItemsSortedBottom then
  begin
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[0]);
    FItemsSortedBottom := true;
  end;
  with FGraphSetting do
  if SortColumn > 0 then
  begin
    colnum := SortColumn;
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[SortColumn]);
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[SortColumn]);
    FItemsSortedTop := false;
    FItemsSortedBottom := false;
  end;
  if lstViewsTop.ItemIndex > 1 then                         // sort by view
  begin
    aProfile := lstViewsTop.Items[lstViewsTop.ItemIndex];
    AssignProfile(aProfile, 'top');
    if not FItemsSortedTop then lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[colnum]);
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[2]);
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[2]);
    FItemsSortedTop := false;
  end;
  if lstViewsBottom.ItemIndex > 1 then                      // sort by view
  begin
    aProfile := lstViewsBottom.Items[lstViewsBottom.ItemIndex];
    AssignProfile(aProfile, 'bottom');
    if not FItemsSortedBottom then lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[colnum]);
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[2]);
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[2]);
    FItemsSortedBottom := false;
  end;
end;

procedure TfrmGraphs.DateRangeItems(oldestdate, newestdate: double; filenum: string);
var
  i, j: integer;
  meddate: double;
  filename, iteminfo, itemnum, oldtempiteminfo, tempiteminfo, tempitemnum: string;
begin
  FastAssign(rpcDateItem(oldestdate, newestdate, filenum, Patient.DFN), GtslScratchTemp);
  filename := FileNameX(filenum);
  lvwItemsTop.Items.BeginUpdate;
  oldtempiteminfo := '';
  with lvwItemsTop do
  for i := 0 to GtslScratchTemp.Count - 1 do
  begin
    tempiteminfo := GtslScratchTemp[i];
    tempitemnum := UpperCase(Piece(tempiteminfo, '^',2));
    for j := 0 to GtslItems.Count - 1 do
    begin
      iteminfo := GtslItems[j];
      if filenum = UpperCase(Piece(iteminfo, '^', 1)) then
      begin
        if filenum = '690' then  // recheck medicine dates & duplicates
        begin
          meddate := strtofloatdef(Piece(iteminfo, '^', 6), -BIG_NUMBER);
          if tempiteminfo <> oldtempiteminfo then
            if (meddate <> -BIG_NUMBER) and (meddate > oldestdate) and (meddate < newestdate) then
              if tempitemnum = UpperCase(Piece(iteminfo, '^', 2)) then
              begin
                UpdateView(filename, filenum, tempitemnum, iteminfo, lvwItemsTop);
                oldtempiteminfo := tempiteminfo;
              end;
        end
        else if tempitemnum = UpperCase(Piece(iteminfo, '^', 2)) then
          UpdateView(filename, filenum, tempitemnum, iteminfo, lvwItemsTop)
        else
          if filenum = '63' then
          begin
            itemnum := UpperCase(Piece(iteminfo, '^', 2));
            if tempitemnum = Piece(itemnum, '.', 1) then
              if DateRangeMultiItems(oldestdate, newestdate, itemnum) then
                UpdateView(filename, filenum, itemnum, iteminfo, lvwItemsTop);
          end;
      end;
    end;
  end;
  lvwItemsTop.Items.EndUpdate;
end;

procedure TfrmGraphs.UpdateView(filename, filenum, itemnum, aString: string; aListView: TListView);
var
  drugclass, itemname, itemqualifier: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  if filenum = '63' then
  begin
    itemqualifier := Piece(itemnum, '.', 2);
    if length(itemqualifier) > 0 then
    begin
      if FGraphSetting.MergeLabs then
        if itemqualifier  <> '0' then exit;
      if not FGraphSetting.MergeLabs then
        if itemqualifier  = '0' then exit;
    end;
  end;
  itemname := Piece(aString, '^', 4);
  itemqualifier := Pieces(aString, '^', 5, 9);
  itemqualifier := filenum + '^' + itemnum + '^' + itemqualifier;
  drugclass := Piece(aString, '^', 8);
  aListItem := aListView.Items.Add;
  with aListItem do
  begin
    Caption := itemname;
    SubItems.Add(filename);
    SubItems.Add('');
    SubItems.Add(drugclass);
    aGraphItem := TGraphItem.Create;
    aGraphItem.Values := itemqualifier;
    SubItems.AddObject('', aGraphItem);
  end;
end;

function TfrmGraphs.DateRangeMultiItems(aOldDate, aNewDate: double; aMultiItem: string): boolean;
var
  i: integer;
  checkdate: double;
  fileitem: string;
begin
  Result := false;
  fileitem := '63^' + aMultiItem;
  for i := 0 to GtslData.Count - 1 do
    if Pieces(GtslData[i], '^', 1, 2) = fileitem then
    begin
      checkdate := strtofloatdef(Piece(GtslData[i], '^', 3), BIG_NUMBER);
      if checkdate <> BIG_NUMBER then
        if checkdate >= aOldDate then
          if checkdate <= aNewDate then
          begin
            Result := true;
            break;
          end;
    end;
end;

function TfrmGraphs.DatesInRange(EarlyDate, RecentDate, Date1, Date2: double): boolean;
begin
  Result := true;
  if Date2 < 0 then   // instance
  begin
    if Date1 < EarlyDate then
      Result := false
    else if Date1 > RecentDate then
      Result := false;
  end
  else                // durations
  begin
    if Date1 > RecentDate then
      Result := false
    else if Date2 < EarlyDate then
      Result := false;
  end;
end;

function TfrmGraphs.FileNameX(filenum: string): string;
var
  i: integer;
  typestring: string;
begin
  Result := '';
  for i := 0 to GtslAllTypes.Count - 1 do
  begin
    typestring := GtslAllTypes[i];
    if Piece(typestring, '^', 1) = filenum then
    begin
      Result := Piece(GtslAllTypes[i], '^', 2);
      break;
    end;
  end;
  if Result = '' then
  begin
    for i := 0 to GtslAllTypes.Count - 1 do
    begin
      typestring := GtslAllTypes[i];
      if lowercase(Piece(typestring, '^', 1)) = filenum then
      begin
        Result := Piece(GtslAllTypes[i], '^', 2);
        break;
      end;
    end;
  end;
end;

function TfrmGraphs.TypeString(filenum: string): string;
var
  i: integer;
  typestring: string;
begin
  Result := '';
  for i := 0 to GtslAllTypes.Count - 1 do
  begin
    typestring := GtslAllTypes[i];
    if Piece(typestring, '^', 1) = filenum then
    begin
      Result := typestring;
      break;
    end;
  end;
  if Result = '' then
  begin
    for i := 0 to GtslAllTypes.Count - 1 do
    begin
      typestring := GtslAllTypes[i];
      if lowercase(Piece(typestring, '^', 1)) = filenum then
      begin
        Result := typestring;
        break;
      end;
    end;
  end;
end;

function TfrmGraphs.ItemName(filenum, itemnum: string): string;
var
  i: integer;
  typestring: string;
begin
  Result := '';
  filenum := UpperCase(filenum);
  itemnum := UpperCase(itemnum);
  for i := 0 to GtslItems.Count - 1 do
  begin
    typestring := UpperCase(GtslItems[i]);
    if (Piece(typestring, '^', 1) = filenum) and
      (Piece(typestring, '^', 2) = itemnum) then
    begin
      Result := Piece(typestring, '^', 4);
      break;
    end;
  end;
end;

procedure TfrmGraphs.Switch;
var
  aList: TStringList;
begin
  if FFastTrack then
    exit;
  aList := TStringList.Create;
  if not FFastItems then
  begin
    rpcFastItems(Patient.DFN, aList, FFastItems);  // ***
    if FFastItems then
    begin
      FastAssign(aList, GtslItems);
      rpcFastData(Patient.DFN, aList, FFastData);  // ***
      if FFastData then
      begin
        FastAssign(aList, GtslData);
        aList.Clear;
        rpcFastLabs(Patient.DFN, aList, FFastLabs);  // ***
        if FFastLabs then
          FastLab(aList);
        FastAssign(GtslData, GtslCheck);
      end;
    end;
  end;
  if not FFastTrack then
    FFastTrack := FFastItems and FFastData and FFastLabs;
  if not FFastTrack then
  begin
    FFastItems := false;
    FFastData := false;
    FFastLabs := false;
  end;
  FreeAndNil(aList);
end;

procedure TfrmGraphs.InitialData;
var
  i: integer;
  dfntype, listline: string;
begin
  Application.ProcessMessages;
  FMTimestamp := floattostr(FMNow);
  //SourcesDefault;
  //FastAssign(FSourcesDefault, FSources);
  for i := 0 to GtslTypes.Count - 1 do
  begin
    listline := GtslTypes[i];
    dfntype := UpperCase(Piece(listline, '^', 1));
    SetPiece(listline, '^', 1, dfntype);
    GtslTypes[i] := listline;
  end;
  btnChangeSettings.Tag := 0;
  btnClose.Tag := 0;
  lstViewsBottom.Tag := 0;
  lstViewsTop.Tag := 0;
  chartDatelineTop.Tag := 0;
  lvwItemsBottom.Tag := 0;
  lvwItemsTop.Tag := 0;
  pnlFooter.Parent.Tag := 0;
  pnlItemsBottom.Tag := 0;
  pnlItemsTop.Tag := 0;
  pnlTop.Tag := 0;
  scrlTop.Tag := 0;
  splGraphs.Tag := 0;
  lstViewsBottom.ItemIndex := -1;
  lstViewsTop.ItemIndex := -1;
  frmGraphData.pnlData.Hint := Patient.DFN;      // use to check for patient change
  FPrevEvent := '';
  FWarning := false;
  FFirstSwitch := true;
  Application.ProcessMessages;
  FFastData := false;
  FFastItems := false;
  FFastLabs := false;
  FFastTrack := false;
  if GraphTurboOn then
    Switch;
  //if not FFastItems then
  if GtslItems.Count = 0 then
  begin
    for i := 0 to GtslTypes.Count - 1 do
    begin
      dfntype := Piece(GtslTypes[i], '^', 1);
      if TypeIsLoaded(dfntype) then
        FastAddStrings(rpcGetItems(dfntype, Patient.DFN), GtslItems);
    end;
  end;
end;

procedure TfrmGraphs.SaveTestData(typeitem: string);
var
  aType, aItem, aItemName: string;
begin
  aType := Piece(typeitem, '^', 1);
  aItem := Piece(typeitem, '^', 2);
  aItemName := MixedCase(ItemName(aType, aItem));
  LabData(typeitem, aItemName, 'top', false);  // already have lab data
  GtslScratchLab.Clear;
end;

procedure TfrmGraphs.FastLab(aList: TStringList);
var
  i, lastnum: integer;
  newtypeitem, oldtypeitem, listline: string;
begin
  lastnum := aList.Count - 1;
  if lastnum < 0 then
    exit;
  GtslScratchLab.Clear;
  aList.Sort;
  oldtypeitem := Pieces(aList[0], '^', 1, 2);
  for i := 0 to lastnum do
  begin
    listline := aList[i];
    newtypeitem := Pieces(listline, '^', 1 , 2);
    if lastnum = i then
    begin
      if newtypeitem <> oldtypeitem then
      begin
        SaveTestData(oldtypeitem);
        oldtypeitem := newtypeitem;
      end;
      GtslScratchLab.Add(listline);
      SaveTestData(oldtypeitem);
    end
    else if newtypeitem <> oldtypeitem then
    begin
      SaveTestData(oldtypeitem);
      GtslScratchLab.Add(listline);
      oldtypeitem := newtypeitem;
    end
    else
      GtslScratchLab.Add(listline);
  end;
end;

function TfrmGraphs.TypeIsLoaded(itemtype: string): boolean;
var
  i: integer;
  filetype: string;
begin
  if FFastItems then
  begin
    Result := true;
    exit;
  end;
  Result := false;
  for i := 0 to FSources.Count - 1 do
  begin
    filetype := Piece(FSources[i], '^', 1);
    if itemtype = filetype then
    begin
      Result := true;
      break;
    end;
  end;
end;

function TfrmGraphs.TypeIsDisplayed(itemtype: string): boolean;
var
  i: integer;
  displayed, filetype: string;
begin
  Result := false;
  for i := 0 to FSources.Count - 1 do
  begin
    filetype := Piece(FSources[i], '^', 1);
    displayed := Piece(FSources[i], '^', 3);
    if (itemtype = filetype) then
    begin
      if displayed = '1' then Result := true;
      break;
    end;
  end;
end;

procedure TfrmGraphs.LoadDateRange;
var
  defaults, defaultrange: string;
begin
  FastAssign(rpcGetGraphDateRange('OR_GRAPHS'), cboDateRange.Items);
  with cboDateRange do
  begin
    defaults := Items[Items.Count - 1];        // ***** CHANGE TO DEFAULTS
    defaultrange := Piece(defaults, '^', 1);
    //get report views - param 1 and param 2
    lvwItemsTop.Hint := Piece(defaults,'^', 8);     // top view
    lvwItemsBottom.Hint := Piece(defaults,'^', 9);  // bottom view
    //check if default range already exists
    if strtointdef(defaultrange, BIG_NUMBER) = BIG_NUMBER then
      ItemIndex := Items.Count - 1
    else
      ItemIndex := strtoint(defaultrange);
  end;
end;

procedure TfrmGraphs.LoadType(itemtype, displayed: string);
var
  needtoadd: boolean;
  i: integer;
  filename, filetype, zzz: string;
begin
  if displayed <> '1' then displayed := '';
  needtoadd := true;
  for i := 0 to FSources.Count - 1 do
  begin
    zzz := FSources[i];
    filetype := Piece(FSources[i], '^', 1);
    if itemtype = filetype then
    begin
      needtoadd := false;
      break;
    end;
  end;
  if needtoadd then
  begin
    filename := FileNameX(itemtype);
    FSources.Add(itemtype + '^' + filename + '^' + displayed);
    FastAddStrings(rpcGetItems(itemtype, Patient.DFN), GtslItems);
  end;
end;

procedure TfrmGraphs.DisplayType(itemtype, displayed: string);
var
  i: integer;
  filename, filetype: string;
begin
  if displayed <> '1' then displayed := '';
  for i := 0 to FSources.Count - 1 do
  begin
    filetype := Piece(FSources[i], '^', 1);
    if itemtype = filetype then
    begin
      filename := FileNameX(itemtype);
      FSources[i] := itemtype + '^' + filename + '^' + displayed;
      break;
    end;
  end;
end;

procedure TfrmGraphs.DisplayData(aSection: string);
var
  i: integer;
  astring: string;
  aChart: TChart;
  aCheckBox: TCheckBox;
  aListView, aOtherListView: TListView;
  aDateline, aRightPad: TPanel;
  aScrollBox: TScrollBox;
  aMemo: TMemo;
begin
  FHintStop := true;
  SetFontSize(chkItemsTop.Font.Size);
  if aSection = 'top' then
  begin
    aListView := lvwItemsTop;         aOtherListView := lvwItemsBottom;
    aDateline := pnlDatelineTop;      aChart := chartDatelineTop;
    aRightPad := pnlTopRightPad;      aScrollBox := scrlTop;
    aCheckBox := chkItemsTop;         aMemo := memTop;
  end
  else
  begin
    aListView := lvwItemsBottom;      aOtherListView := lvwItemsTop;
    aDateline := pnlDatelineBottom;   aChart := chartDatelineBottom;
    aRightPad := pnlBottomRightPad;   aScrollBox := scrlBottom;
    aCheckBox := chkItemsBottom;      aMemo := memBottom;
  end;
  if aListView.SelCount < 1 then
  begin
    if not FFirstClick then
    begin
      FFirstClick := true;
      while aScrollBox.ControlCount > 0 do aScrollBox.Controls[0].Free;
      exit;
    end;
    FFirstClick := false;
    aDateline.Visible := false;
    while aScrollBox.ControlCount > 0 do
      aScrollBox.Controls[0].Free;
    if aOtherListView.SelCount > 0 then
      if aOtherListView = lvwItemsTop then
        ItemsClick(self, lvwItemsTop, lvwItemsBottom, chkItemsTop, lstViewsTop, GtslSelCopyTop, 'top')
      else
        ItemsClick(self, lvwItemsBottom, lvwItemsTop, chkItemsBottom, lstViewsBottom, GtslSelCopyBottom, 'bottom');
    exit;
  end;
  aScrollBox.VertScrollBar.Visible := false;
  aScrollBox.HorzScrollBar.Visible := false;
  amemo.Visible := false;
  aChart.RemoveAllSeries;    // this would leave bottom dateline visible on date change
  for i := GtslNonNum.Count - 1 downto 0 do
  begin
    astring := GtslNonNum[i];
    if Piece(astring, '^', 7) = aSection then
      GtslNonNum.Delete(i);
  end;
  if aCheckBox.Checked then
    MakeSeparate(aScrollBox, aListView, aRightPad, aSection)
  else
    MakeTogetherMaybe(aScrollBox, aListView, aRightPad, aSection);
  DisplayDataInfo(aScrollBox, aMemo);
end;

procedure TfrmGraphs.DisplayDataInfo(aScrollBox: TScrollBox; aMemo: TMemo);
begin
  ChangeStyle;
  pnlInfo.Font.Size := chkItemsTop.Font.Size;
  if ((lvwItemsTop.SelCount > MAX_ITEM_DISCLAIMER) and (not chkItemsTop.Checked))
    or ((lvwItemsBottom.SelCount > MAX_ITEM_DISCLAIMER) and (not chkItemsBottom.Checked)) then
    InfoMessage(TXT_DISCLAIMER, COLOR_WARNING, true)
  else
    pnlInfo.Visible := false;
  if btnChangeSettings.Tag > 0 then
    InfoMessage(TXT_WARNING, COLOR_WARNING, true);
  if FWarning then
    pnlInfo.Visible := true;
  if MergedLabsSelected then
    if (not ansicontainsstr(pnlInfo.Caption, TXT_WARNING_MERGED_LABS)) and pnlInfo.Visible then
      InfoMessage(pnlInfo.Caption + ' ' + TXT_WARNING_MERGED_LABS, COLOR_WARNING, true)
    else
      InfoMessage(TXT_WARNING_MERGED_LABS, COLOR_WARNING, true);
  pnlHeader.Visible := pnlInfo.Visible;
  aScrollBox.VertScrollBar.Visible := true;
  aScrollBox.HorzScrollBar.Visible := false;
  if (aScrollBox.ControlCount > FGraphSetting.MaxGraphs)
  or (aScrollBox.Height < FGraphSetting.MinGraphHeight) then
    aMemo.Visible:= true;
end;

function TfrmGraphs.MergedLabsSelected: boolean;
var
  i: integer;
  filetype, typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
  aListView: TListView;
begin
  Result := false;
  if not FGraphSetting.MergeLabs then exit;
  for i := 1 to 2 do
  begin
    if i = 1 then
      aListView := lvwItemsTop
    else
      aListView := lvwItemsBottom;
    aListItem := aListView.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      filetype := Piece(aGraphItem.Values, '^', 1);
      if filetype = '63' then
      begin
        typeitem := UpperCase(Piece(aGraphItem.Values, '^', 2));
        if Piece(typeitem, '.', 2) = '0' then
        begin
          Result := true;
          exit;
        end;
      end;
      aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end;
end;

procedure TfrmGraphs.chkItemsTopClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  DisplayData('top');
  if FFirstSwitch then   // this code makes events appear better (on first click was not displaying bar)
  begin
    chartBaseMouseDown(chartDatelineTop, mbLeft, [], 1, 1);
    DisplayData('top');
    FFirstSwitch := false;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.chkItemsBottomClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  DisplayData('bottom');
  if FFirstSwitch then   // this code makes events appear better (on first click was not displaying bar)
  begin
    chartBaseMouseDown(chartDatelineBottom, mbLeft, [], 1, 1);
    DisplayData('bottom');
    FFirstSwitch := false;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.BottomAxis(aScrollBox: TScrollBox);
var
  i: integer;
  ChildControl: TControl;
begin
  for i := 0 to aScrollBox.ControlCount - 1 do
  begin
    ChildControl := aScrollBox.Controls[i];
    with (ChildControl as TChart).BottomAxis do
    begin
      Automatic := false;
      Minimum := 0;
      Maximum := chartDatelineTop.BottomAxis.Maximum;
      Minimum := chartDatelineTop.BottomAxis.Minimum;
    end;
  end;
end;

procedure TfrmGraphs.AdjustTimeframe;
begin
  with FGraphSetting do
  begin
    if HighTime = 0 then exit;  // no data to chart clear form ???
    chartDatelineTop.BottomAxis.Minimum := 0;  // avoid possible error
    chartDatelineTop.BottomAxis.Maximum := HighTime;
    if LowTime < HighTime then
      chartDatelineTop.BottomAxis.Minimum := LowTime;
    chartDatelineBottom.BottomAxis.Minimum := 0;  // avoid possible error
    chartDatelineBottom.BottomAxis.Maximum := HighTime;
    if HighTime > FMDateTimeToDateTime(FMStopDate) then
      chartDatelineTop.BottomAxis.Maximum := FMDateTimeToDateTime(FMStopDate);
    if LowTime < FMDateTimeToDateTime(FMStartDate) then
      chartDatelineTop.BottomAxis.Minimum := FMDateTimeToDateTime(FMStartDate);  // *****
  end;
  BottomAxis(scrlTop);
  BottomAxis(scrlBottom);
end;

procedure TfrmGraphs.ChartOnZoom(Sender: TObject);
var
  i: integer;
  padding: double;
  datehx: string;
  BigTime, SmallTime: TDateTime;
  ChildControl: TControl;
  aChart: TChart;
begin
  if not (Sender is TChart) then exit;
  aChart := (Sender as TChart);
  if Not Assigned(FGraphSetting) then Exit;

  if not FGraphSetting.VerticalZoom then
  begin
    padding := 0; //(FYMaxValue - FYMinValue) * ((100 - ZOOM_PERCENT) * 0.01);
    aChart.LeftAxis.Maximum := BIG_NUMBER;    // avoid min>max error
    aChart.LeftAxis.Minimum := -BIG_NUMBER;
    aChart.LeftAxis.Maximum := FYMaxValue + padding;    //padding 0?
    aChart.LeftAxis.Minimum := FYMinValue - padding;    //padding 0?
  end;
  SmallTime := aChart.BottomAxis.Minimum;
  BigTime := aChart.BottomAxis.Maximum;
  if BigTime < SmallTime then BigTime := SmallTime;   // avoid min>max error
  for i := 0 to scrlTop.ControlCount - 1 do
  begin
    ChildControl := scrlTop.Controls[i];
    SizeDates((ChildControl as TChart), SmallTime, BigTime);
  end;
  SizeDates(chartDatelineTop, SmallTime, BigTime);
  for i := 0 to scrlBottom.ControlCount - 1 do
  begin
    ChildControl := scrlBottom.Controls[i];
    SizeDates((ChildControl as TChart), SmallTime, BigTime);
  end;
  SizeDates(chartDatelineBottom, SmallTime, BigTime);
  if FMouseDown and aChart.Zoomed then
  begin
    datehx := FloatToStr(SmallTime) + '^' + FloatToStr(BigTime);
    GtslZoomHistoryFloat.Add(datehx);
    mnuPopGraphZoomBack.Enabled := true;
    FMouseDown := false;
    ZoomUpdateinfo(SmallTime, BigTime);
  end;
end;

procedure TfrmGraphs.ChartOnUndoZoom(Sender: TObject);
var
  i: integer;
  padding: double;
  BigTime, SmallTime: TDateTime;
  ChildControl: TControl;
  aChart: TChart;
begin
  if not (Sender is TChart) then exit;
  aChart:= (Sender as TChart);
  FRetainZoom := false;
  mnuPopGraphZoomBack.Enabled := false;
  GtslZoomHistoryFloat.Clear;
  if not FGraphSetting.VerticalZoom then
  begin
    padding := 0; //(FYMaxValue - FYMinValue) * ((100 - ZOOM_PERCENT) * 0.01);
    aChart.LeftAxis.Maximum := BIG_NUMBER;    // avoid min>max error
    aChart.LeftAxis.Minimum := -BIG_NUMBER;
    aChart.LeftAxis.Maximum := FYMaxValue + padding;    //padding 0?
    aChart.LeftAxis.Minimum := FYMinValue - padding;    //padding 0?
  end;
  SmallTime := aChart.BottomAxis.Minimum;
  BigTime := aChart.BottomAxis.Maximum;
  if BigTime < SmallTime then BigTime := SmallTime;   // avoid min>max error
  for i := 0 to scrlTop.ControlCount - 1 do
  begin
    ChildControl := scrlTop.Controls[i];
    SizeDates((ChildControl as TChart), SmallTime, BigTime);
  end;
  SizeDates(chartDatelineTop, SmallTime, BigTime);
  for i := 0 to scrlBottom.ControlCount - 1 do
  begin
    ChildControl := scrlBottom.Controls[i];
    SizeDates((ChildControl as TChart), SmallTime, BigTime);
  end;
  SizeDates(chartDatelineBottom, SmallTime, BigTime);
  if FMouseDown then
  begin
    FMouseDown := false;
    InfoMessage('', COLOR_INFO, false);
  if MergedLabsSelected then
    InfoMessage(TXT_WARNING_MERGED_LABS, COLOR_WARNING, true);
  pnlHeader.Visible := pnlInfo.Visible;
  end;
end;

procedure TfrmGraphs.SizeDates(aChart: TChart; aSmallTime, aBigTime: TDateTime);
var
  datediff, yeardiff: integer;
  pad: double;
begin
  with aChart.BottomAxis do
  begin
    Automatic := false;
    Maximum := BIG_NUMBER;    // avoid min>max error
    Minimum := -BIG_NUMBER;
    Minimum := aSmallTime;
    Maximum := aBigTime;
    Increment := DateTimeStep[dtOneMinute];
    datediff := DaysBetween(aBigTime, aSmallTime);
    yeardiff := datediff div 365;
    DateTimeFormat := '';
    Labels := true;
    if yeardiff > 0 then
    begin
      if (pnlScrollTopBase.Width div yeardiff) < DWIDTH_MDY then
        DateTimeFormat := DFORMAT_MYY;
      if (pnlScrollTopBase.Width div yeardiff) < DWIDTH_MYY then
        DateTimeFormat := DFORMAT_YY;
      if (pnlScrollTopBase.Width div yeardiff) < DWIDTH_YY then
        Labels := false;
    end;
  end;
  GraphFooter(aChart, datediff, aSmallTime);
  pad := (aBigTime - aSmallTime) * 0.07;
  SeriesForLabels(aChart, 'serNonNumBottom', pad);
  SeriesForLabels(aChart, 'serNonNumTop', pad);
  if length(aChart.Hint) > 0 then SeriesForLabels(aChart, 'serComments', pad);
end;

procedure TfrmGraphs.SeriesForLabels(aChart: TChart; aID: string; pad: double);
var
  i: integer;
  aPointSeries: TPointSeries;
  max, min: double;
begin
  for i := 0 to aChart.SeriesCount - 1 do
  begin
    if aChart.Series[i].Identifier = aID then
    begin
      aPointSeries := (aChart.Series[i] as TPointSeries);
      aPointSeries.Clear;
      if aID = 'serNonNumBottom' then
      begin
        min := aChart.LeftAxis.Minimum;
        if min > aChart.MinYValue(aChart.LeftAxis) then
           min := aChart.MinYValue(aChart.LeftAxis);
        if min < 0 then min := 0;
        aPointSeries.AddXY(aChart.BottomAxis.Minimum, min, '', clTeeColor) ;
      end
      else if aID  = 'serNonNumTop' then
      begin
        max := aChart.LeftAxis.Maximum;
        if max < aChart.MaxYValue(aChart.LeftAxis) then
           max := aChart.MaxYValue(aChart.LeftAxis);
        aPointSeries.AddXY(aChart.BottomAxis.Minimum, max, '', clTeeColor) ;
      end
      else if aID = 'serComments' then
      begin
        min := aChart.MinYValue(aChart.LeftAxis);
        if aChart.SeriesCount = 2 then        // only 1 series (besides comment)
          if aChart.Series[0].Count = 1 then  // only 1 numeric
            min := min - 1;                   // force comment label to bottom
        if min < 0 then min := 0;
        aPointSeries.AddXY((aChart.BottomAxis.Maximum - pad), min, '', clTeeColor) ;
      end;
      aPointSeries.Marks.Visible := true;
      break;
    end;
  end;
end;

procedure TfrmGraphs.GraphFooter(aChart: TChart; datediff: integer; aDate: TDateTime);
begin
  if datediff < 1 then
  begin
    if not aChart.Foot.Visible then
    begin
      aChart.Foot.Text.Clear;
      aChart.Foot.Text.Insert(0, FormatDateTime('mmm d, yyyy', aDate));
      aChart.Foot.Font.Color := clBtnText;
      aChart.Foot.Visible := true;
    end;
  end
  else
    aChart.Foot.Visible := false;
end;

procedure TfrmGraphs.MakeSeparate(aScrollBox: TScrollBox; aListView:
  TListView; aPadPanel: TPanel; section: string);
var
  displayheight, displaynum, i: integer;
begin
  FNonNumerics := false;
  if section = 'top' then pnlItemsTop.Tag := 0 else pnlItemsBottom.Tag := 0;
  while aScrollBox.ControlCount > 0 do
    aScrollBox.Controls[0].Free;
  aPadPanel.Visible := false;
  if FGraphSetting.Hints then         //**************
  begin
    chartDatelineTop.OnMouseMove := chartBaseMouseMove;
    chartDatelineBottom.OnMouseMove := chartBaseMouseMove;
  end
  else
  begin
    chartDatelineTop.OnMouseMove := nil;
    chartDatelineBottom.OnMouseMove := nil;
  end;
  MakeSeparateItems(aScrollBox, aListView, section);
  if section = 'top' then
  begin
    pnlDatelineTop.Align := alBottom;
    pnlDatelineTop.Height := 30;
    scrlTop.Align := alClient;
    pnlDatelineTop.Visible := false;
  end
  else
  begin
    pnlDatelineBottom.Align := alBottom;
    pnlDatelineBottom.Height := 30;
    scrlBottom.Align := alClient;
    pnlDatelineBottom.Visible := false;
  end;
  with aScrollBox do
  begin
    if ControlCount < FGraphSetting.MaxGraphs then        //**** formating should be made for top & bottom
      displaynum := ControlCount
    else
      displaynum := FGraphSetting.MaxGraphs;
    if displaynum = 0 then
      displaynum := 3;
    if (Height div displaynum) < FGraphSetting.MinGraphHeight then
      displayheight := FGraphSetting.MinGraphHeight
    else
      displayheight := (Height div displaynum);
    for i := 0 to aScrollBox.ControlCount - 1 do
      Controls[i].height := displayheight;
  end;
  AdjustTimeframe;
  //if chartDatelineTop.Visible then chartDatelineTop.ZoomPercent(ZOOM_PERCENT);
  //if chartDatelineBottom.Visible then chartDatelineBottom.ZoomPercent(ZOOM_PERCENT);
  if FNonNumerics then
    if section = 'top' then pnlItemsTop.Tag := 1
    else pnlItemsBottom.Tag := 1;
end;

function TfrmGraphs.TitleInfo(filetype, typeitem, caption: string): string;
var
  i: integer;
  checkdata, high, low, refrange, specimen, specnum, units: string;
begin
  if (filetype = '63') and (GtslData.Count > 0) then
  begin
    checkdata := '';
    for i := 0 to GtslData.Count - 1 do
    begin
      checkdata := GtslData[i];
      if (Piece(checkdata, '^', 1) = '63') and (Piece(checkdata, '^', 2) = typeitem) then
        break;
    end;
    refrange := Piece(checkdata, '^', 10);
    specimen := Piece(checkdata, '^', 8);
    if length(refrange) > 0  then
    begin
      low := Piece(refrange, '!', 1);
      high := Piece(refrange, '!', 2);
      units := Piece(checkdata, '^', 11);
    end
    else
    begin
      specnum := Piece(checkdata, '^', 7);
      RefUnits(typeitem, specnum, low, high, units);
      units := LowerCase(units);
    end;
    if units = '' then units := '  ';
  end
  else
  begin
    specimen := ''; low := ''; high := ''; units := '';
  end;
  if (filetype = '63') and (Piece(typeitem, '.', 2) = '0') then
  begin
    specimen := ''; low := ''; high := '';
  end;
  Result := filetype + '^' + typeitem + '^' + caption + '^' +
            specimen + '^' + low + '^' + high + '^' + units + '^';
end;

procedure TfrmGraphs.MakeSeparateItems(aScrollBox: TScrollBox; aListView: TListView; section: string);
var
  bcnt, gcnt, graphtype, lcnt, ncnt, pcnt, vcnt: integer;
  aTitle, filetype, typeitem: string;
  newchart: TChart;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  pcnt := 0; gcnt := 0; vcnt := 0; lcnt := 0; ncnt := 0; bcnt := 0;
  aListItem := aListView.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := UpperCase(Piece(aGraphItem.Values, '^', 1));
    typeitem := UpperCase(Piece(aGraphItem.Values, '^', 2));
    graphtype := GraphTypeNum(filetype); //*****strtointdef(Piece(aListBox.Items[j], '^', 2), 1);
    aTitle := TitleInfo(filetype, typeitem, aListItem.Caption);
    newchart := TChart.Create(self);
    newchart.Tag := GtslNonNum.Count;
    MakeChart(newchart, aScrollBox);
    with newchart do
    begin
      Height := 170;
      Align := alBottom;
      Align := alTop;
      Tag := aListItem.Index;
      //SetPiece(aTitle, '^', 3, 'zzzz: ' + Piece(aTitle, '^', 3)); // test prefix
      if (graphtype = 1) and (btnChangeSettings.Tag = 1) then
        LeftAxis.Title.Caption := 'StdDev'
      else if (graphtype = 1) and (btnChangeSettings.Tag = 2) then
      begin
        LeftAxis.Title.Caption := '1/' + Piece(aTitle, '^', 7);
        SetPiece(aTitle, '^', 3, 'Inverse ' + Piece(aTitle, '^', 3));
      end
      else
        LeftAxis.Title.Caption := Piece(aTitle, '^', 7);
      if graphtype <> 1 then
      begin
        LeftAxis.Visible := false;
        MarginLeft := PadLeftEvent(pnlScrollTopBase.Width);
        //MarginLeft := round((65 / (pnlScrollTopBase.Width + 1)) * 100);       // ************* marginleft is a %
      end;
    end;
    splGraphs.Tag := 1;    // show ref ranges
    if graphtype = 4 then graphtype := 2;         // change points to be bars
    case graphtype of
      1:  MakeLineSeries(newchart, aTitle, filetype, section, lcnt, ncnt, false);
      2:  MakeBarSeries(newchart, aTitle, filetype, bcnt);
      3:  MakeVisitGanttSeries(newchart, aTitle, filetype, vcnt);
      4:  MakePointSeries(newchart, aTitle, filetype, pcnt);
      8:  MakeGanttSeries(newchart, aTitle, filetype, gcnt);
    end;
    MakeOtherSeries(newchart);
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  if (FGraphSetting.HighTime = FGraphSetting.LowTime)
  or (lcnt = 1) or (pcnt = 1) or (bcnt = 1) or (vcnt = 1) then
  begin
    FGraphSetting.HighTime := FGraphSetting.HighTime + 1;
    FGraphSetting.LowTime := FGraphSetting.LowTime - 1;
  end;
end;

function TfrmGraphs.PadLeftEvent(aWidth: integer): integer;
begin
  if aWidth < 50 then
    Result := 10
  else if aWidth < 100 then
    Result := 36
  else if aWidth < 200 then
    Result := 28
  else if aWidth < 220 then
    Result := 24
  else if aWidth < 240 then
    Result := 23
  else if aWidth < 270 then
    Result := 21
  else if aWidth < 300 then
    Result := 18
  else if aWidth < 400 then
    Result := 14
  else if aWidth < 500 then
    Result := 11
  else if aWidth < 600 then
    Result := 10
  else if aWidth < 700 then
    Result := 9
  else if aWidth < 800 then
    Result := 8
  else if aWidth < 900 then
    Result := 7
  else if aWidth < 1000 then
    Result := 6
  else
    Result := 5;
end;

function TfrmGraphs.PadLeftNonNumeric(aWidth: integer): integer;
begin
  if aWidth < 50 then
    Result := 10
  else if aWidth < 100 then
    Result := 36
  else if aWidth < 200 then
    Result := 16
  else if aWidth < 220 then
    Result := 14
  else if aWidth < 240 then
    Result := 12
  else if aWidth < 270 then
    Result := 10
  else if aWidth < 300 then
    Result := 9
  else if aWidth < 400 then
    Result := 8
  else if aWidth < 500 then
    Result := 7
  else if aWidth < 600 then
    Result := 6
  else
    Result := 5;
end;

procedure TfrmGraphs.MakeTogetherMaybe(aScrollBox: TScrollBox; aListView:
  TListView; aPadPanel: TPanel; section: string);
var
  filetype: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  FNonNumerics := false;
  if section = 'top' then pnlItemsTop.Tag := 0 else pnlItemsBottom.Tag := 0;
  if aListView.SelCount = 1 then                 // one lab test - make separate
  begin
    aListItem := aListView.Selected;
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := UpperCase(Piece(aGraphItem.Values, '^', 1));
    if (filetype = '63') or (filetype = '120.5') then
    begin
      MakeSeparate(aScrollBox, aListView, aPadPanel, section);
      exit;
    end;
  end;
  MakeTogether(aScrollBox, aListView, aPadPanel, section);
end;

procedure TfrmGraphs.MakeTogether(aScrollBox: TScrollBox; aListView:
  TListView; aPadPanel: TPanel; section: string);
var
  anylines, nolines, onlylines, singlepoint: boolean;
  bcnt, gcnt, graphtype, lcnt, pcnt, vcnt: integer;
  portion: double;
  filetype, typeitem: string;
  newchart: TChart;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  pcnt := 0; gcnt := 0; lcnt := 0; bcnt := 0; vcnt := 0;
  onlylines := true;
  anylines := false;
  nolines := true;
  FNonNumerics := false;
  if section = 'top' then pnlItemsTop.Tag := 0 else pnlItemsBottom.Tag := 0;
  aListItem := aListView.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := UpperCase(Piece(aGraphItem.Values, '^', 1));
    typeitem := UpperCase(Piece(aGraphItem.Values, '^', 2));
    graphtype := GraphTypeNum(filetype);
    case graphtype of
    1: lcnt := lcnt + 1;
    2: bcnt := bcnt + 1;
    3: vcnt := vcnt + 1;
    4: pcnt := pcnt + 1;
    8: gcnt := gcnt + 1;
    end;
    if graphtype = 1 then
    begin
      anylines := true;
      nolines := false;
    end
    else
      onlylines := false;
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  if section = 'top' then
    chkItemsTop.Checked := false
  else
    chkItemsBottom.Checked := false;
  GtslTempCheck.Clear;
  while aScrollBox.ControlCount > 0 do aScrollBox.Controls[0].Free;
  newchart := TChart.Create(self);  // whynot use base?
  MakeChart(newchart, aScrollBox);
  with newchart do          // if a single line graph do lab stuff (ref range, units) ****************************************
  begin
    Align := alClient;
    LeftAxis.Title.Caption := ' ';
  end;
  aPadPanel.Visible := true;
  portion := PortionSize(lcnt, pcnt, gcnt, vcnt, bcnt);
  if section = 'top' then
    SizeTogether(onlylines, nolines, anylines, scrlTop, newchart,
      pnlDatelineTop, pnlScrollTopBase, portion)
  else
    SizeTogether(onlylines, nolines, anylines, scrlBottom, newchart,
      pnlDatelineBottom, pnlScrollBottomBase, portion);
  if btnChangeSettings.Tag = 1 then  splGraphs.Tag := 1 // show ref ranges
  else splGraphs.Tag := 0;

  if nolines then MakeTogetherNoLines(aListView, section)
  else if onlylines then MakeTogetherOnlyLines(aListView, section, newchart)
  else if anylines then MakeTogetherAnyLines(aListView, section, newchart);
  MakeOtherSeries(newchart);

  singlepoint := (lcnt = 1) or (pcnt = 1) or (bcnt = 1) or (vcnt = 1);
  GraphBoundry(singlepoint);
  if FNonNumerics then
    if section = 'top' then pnlItemsTop.Tag := 1
    else pnlItemsBottom.Tag := 1;
end;

procedure TfrmGraphs.GraphBoundry(singlepoint: boolean);
begin
  if (FGraphSetting.HighTime = FGraphSetting.LowTime)
  or singlepoint then
  begin
    FGraphSetting.HighTime := FGraphSetting.HighTime + 1;
    FGraphSetting.LowTime := FGraphSetting.LowTime - 1;
    chartDatelineTop.LeftAxis.Minimum := chartDatelineTop.LeftAxis.Minimum - 0.5;
    chartDatelineTop.LeftAxis.Maximum := chartDatelineTop.LeftAxis.Maximum + 0.5;
    chartDatelineBottom.LeftAxis.Minimum := chartDatelineBottom.LeftAxis.Minimum - 0.5;
    chartDatelineBottom.LeftAxis.Maximum := chartDatelineBottom.LeftAxis.Maximum + 0.5;
  end;
  if FGraphSetting.Hints then
  begin
    chartDatelineTop.OnMouseMove := chartBaseMouseMove;
    chartDatelineBottom.OnMouseMove := chartBaseMouseMove;
  end
  else
  begin
    chartDatelineTop.OnMouseMove := nil;
    chartDatelineBottom.OnMouseMove := nil;
  end;
  AdjustTimeframe;
  //if chartDatelineTop.Visible then chartDatelineTop.ZoomPercent(ZOOM_PERCENT);
  //if chartDatelineBottom.Visible then chartDatelineBottom.ZoomPercent(ZOOM_PERCENT);
end;

procedure TfrmGraphs.MakeTogetherNoLines(aListView: TListView; section: string);
var
  bcnt, gcnt, graphtype, pcnt, vcnt: integer;
  aTitle, filetype, typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  pcnt := 0; gcnt := 0; vcnt := 0; bcnt := 0;
  aListItem := aListView.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := Piece(aGraphItem.Values, '^', 1);
    typeitem := Piece(aGraphItem.Values, '^', 2);
    aTitle := filetype + '^' + typeitem + '^' + aListItem.Caption + '^';
    graphtype := GraphTypeNum(filetype);
    if section = 'top' then
      MakeDateline(section, aTitle, filetype, chartDatelineTop, graphtype, bcnt, pcnt, gcnt, vcnt)
    else
      MakeDateline(section, aTitle, filetype, chartDatelineBottom, graphtype, bcnt, pcnt, gcnt, vcnt);
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  if section = 'top' then
  begin
    scrlTop.Align := alTop;
    scrlTop.Height := 1; //pnlScrollTopBase.Height div 4;
    pnlDatelineTop.Align := alClient;
    pnlDatelineTop.Visible := true;
  end
  else
  begin
    scrlBottom.Align := alTop;
    scrlBottom.Height := 1; //pnlScrollBottomBase.Height div 4;
    pnlDatelineBottom.Align := alClient;
    pnlDatelineBottom.Visible := true;
  end;
end;

procedure TfrmGraphs.MakeTogetherOnlyLines(aListView: TListView; section: string; aChart: TChart);
var
  lcnt, ncnt: integer;
  aTitle, filetype, typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  lcnt := 0;
  aListItem := aListView.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := Piece(aGraphItem.Values, '^', 1);
    typeitem := Piece(aGraphItem.Values, '^', 2);
    aTitle := TitleInfo(filetype, typeitem, aListItem.Caption);
    MakeLineSeries(aChart, aTitle, filetype, section, lcnt, ncnt, true);
    if FDisplayFreeText = true then DisplayFreeText(aChart);
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  if section = 'top' then
  begin
    pnlDatelineTop.Align := alBottom;
    pnlDatelineTop.Height := 5;
    scrlTop.Align := alClient;
    pnlDatelineTop.Visible := false;
  end
  else
  begin
    pnlDatelineBottom.Align := alBottom;
    pnlDatelineBottom.Height := 5;
    scrlBottom.Align := alClient;
    pnlDatelineBottom.Visible := false;
  end;
  with aChart do
  begin
    if btnChangeSettings.Tag = 1 then
      LeftAxis.Title.Caption := 'StdDev';
    Visible := true;
  end;
end;

procedure TfrmGraphs.MakeTogetherAnyLines(aListView: TListView; section: string; aChart: TChart);
var
  singletest: boolean;
  bcnt, gcnt, graphtype, lcnt, ncnt, pcnt, vcnt: integer;
  aTitle, filetype, typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  singletest := SingleLabTest(aListView);
  pcnt := 0; gcnt := 0; vcnt := 0; lcnt := 0; bcnt := 0;
  aListItem := aListView.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := Piece(aGraphItem.Values, '^', 1);
    typeitem := Piece(aGraphItem.Values, '^', 2);
    aTitle := TitleInfo(filetype, typeitem, aListItem.Caption);
    graphtype := GraphTypeNum(filetype);
    if graphtype = 1 then
    begin
      if btnChangeSettings.Tag = 1 then
        aChart.LeftAxis.Title.Caption := 'StdDev'
      else
        aChart.LeftAxis.Title.Caption := Piece(aTitle, '^', 7);
      if singletest then
        splGraphs.Tag := 1
      else
        splGraphs.Tag := 0;
      MakeLineSeries(aChart, aTitle, filetype, section, lcnt, ncnt, true);
      if FDisplayFreeText = true then DisplayFreeText(aChart);
    end
    else if section = 'top' then
      MakeDateline(section, aTitle, filetype, chartDatelineTop, graphtype, bcnt, pcnt, gcnt, vcnt)
    else
      MakeDateline(section, aTitle, filetype, chartDatelineBottom, graphtype, bcnt, pcnt, gcnt, vcnt);
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  if section = 'top' then
  begin
    scrlTop.Align := alTop;
    pnlDatelineTop.Align := alBottom;
    pnlDatelineTop.Height := pnlScrollTopBase.Height div 2;
    scrlTop.Align := alClient;
    pnlDatelineTop.Visible := true;
  end
  else
  begin
    scrlBottom.Align := alTop;
    pnlDatelineBottom.Align := alBottom;
    pnlDatelineBottom.Height := pnlScrollBottomBase.Height div 2;
    scrlBottom.Align := alClient;
    pnlDatelineBottom.Visible := true;
  end;
  with aChart do
  begin
    if btnChangeSettings.Tag = 1 then
      LeftAxis.Title.Caption := 'StdDev';
    Visible := true;
  end;
end;

function TfrmGraphs.SingleLabTest(aListView: TListView): boolean;
var
  cnt: integer;
  filetype: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  cnt := 0;
  aListItem := aListView.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    filetype := Piece(aGraphItem.Values, '^', 1);
    if filetype = '120.5' then
    begin
      cnt := BIG_NUMBER;
      break;
    end;
    if filetype = '63' then
      cnt := cnt + 1;
    if cnt > 1 then
      break;
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  Result := (cnt = 1);
end;

procedure TfrmGraphs.MakeChart(aChart: TChart; aScrollBox: TScrollBox);
begin
  with aChart do
  begin
    Parent := aScrollBox;
    View3D := false;
    Chart3DPercent := 10;
    AllowPanning := pmNone;
    Zoom.Pen.Color := chartBase.Zoom.Pen.Color;
    Gradient.EndColor := clGradientActiveCaption;
    Gradient.StartColor := clWindow;
    Legend.LegendStyle := lsSeries;
    Legend.ShadowSize := 1;
    Legend.Color := clCream;
    Legend.VertMargin := 0;
    Legend.Alignment := laTop;
    Legend.Visible := true;
    BottomAxis.ExactDateTime := true;
    BottomAxis.Increment := DateTimeStep[dtOneMinute];
    HideDates(aChart);
    BevelOuter := bvNone;
    OnZoom := ChartOnZoom;
    OnUndoZoom := ChartOnUndoZoom;
    OnClickSeries := chartBaseClickSeries;
    OnClickLegend := chartBaseClickLegend;
    OnDblClick := mnuPopGraphDetailsClick;
    OnMouseDown := chartBaseMouseDown;
    OnMouseUp := chartBaseMouseUp;
    if FGraphSetting.Hints then
      OnMouseMove := chartBaseMouseMove
    else
      OnMouseMove := nil;
  end;
end;

procedure TfrmGraphs.MakeSeriesInfo(aChart: TChart; aSeries: TChartSeries; aTitle, aFileType: string; aSerCnt: integer);
begin
  with aSeries do
  begin
    Active := true;
    ParentChart := aChart;
    Title := Piece(aTitle, '^', 3);
    GetData(aTitle);
    Identifier := aFileType;
    SeriesColor := NextColor(aSerCnt);
    ColorEachPoint := false;
    ShowInLegend := true;
    Marks.Style := smsLabel;
    Marks.BackColor := clInfoBk;
    Marks.Frame.Visible := true;
    Marks.Visible := false;
    OnGetMarkText := serDatelineTop.OnGetMarkText;
    XValues.DateTime := True;
    GetHorizAxis.ExactDateTime := True;
    GetHorizAxis.Increment := DateTimeStep[dtOneMinute];
  end;
end;

procedure TfrmGraphs.MakeSeriesPoint(aChart: TChart; aPointSeries: TPointSeries);
begin
  with aPointSeries do
  begin
    Active := true;
    ParentChart := aChart;
    Title := '';
    Identifier := '';
    SeriesColor := aChart.Color;
    ColorEachPoint := false;
    ShowInLegend := false;
    Marks.Style := smsLabel;
    Marks.BackColor := clInfoBk;
    Marks.Frame.Visible := true;
    Marks.Visible := false;
    OnGetMarkText := serDatelineTop.OnGetMarkText;
    XValues.DateTime := true;
    Pointer.Visible := true;
    Pointer.InflateMargins := true;
    Pointer.Style := psSmallDot;
    Pointer.Pen.Visible := true;
  end;
end;

procedure TfrmGraphs.MakeSeriesRef(aChart: TChart; aTest, aRef: TLineSeries; aTitle, aValue: string; aDate: double);
var
  value: double;
begin
  with aRef do
  begin
    Active := true;
    ParentChart := aChart;
    XValues.DateTime := True;
    Pointer.Visible := false;
    Pointer.InflateMargins := true;
    OnGetMarkText := serDatelineTop.OnGetMarkText;
    ColorEachPoint := false;
    Title := aTitle + aValue;
    Pointer.Style := psCircle;
    SeriesColor := clTeeColor; //aTest.SeriesColor; // clBtnShadow;  //
    Marks.Visible := false;
    LinePen.Visible := true;
    LinePen.Width := 1;
    LinePen.Style := psDash;  //does not show when width <> 1
  end;
  value := strtofloatdef(aValue, -BIG_NUMBER);
  if value <> -BIG_NUMBER then
  begin
    aRef.AddXY(IncDay(FGraphSetting.LowTime, -1), value, '', clTeeColor);
    aRef.AddXY(IncDay(FGraphSetting.HighTime, 1), value, '', clTeeColor);
    BorderValue(aDate, value);
  end;
end;

procedure TfrmGraphs.MakeSeriesBP(aChart: TChart; aTest, aBP: TLineSeries; aFileType: string);
begin
  with aBP do
  begin
    ParentChart := aChart;
    Title := 'Blood Pressure';
    XValues.DateTime := true;
    Pointer.Style := aTest.Pointer.Style;
    ShowInLegend := false;    //****
    Identifier := aFileType;
    Pointer.Visible := true;
    Pointer.InflateMargins := true;
    ColorEachPoint := false;
    SeriesColor := aTest.SeriesColor;
    Marks.BackColor := clInfoBk;
  end;
end;

procedure TfrmGraphs.MakeOtherSeries(aChart: TChart);
begin
  if GtslNonNum.Count > 0 then
  begin
    MakeNonNumerics(aChart);
    if FDisplayFreeText = true then DisplayFreeText(aChart);
  end;
  if length(aChart.Hint) > 0 then
  begin
    MakeComments(aChart);
  end;
end;

procedure TfrmGraphs.MakeComments(aChart: TChart);
var
  serComment: TPointSeries;
begin
  serComment := TPointSeries.Create(aChart);
  MakeSeriesPoint(aChart, serComment);
  with serComment do
  begin
    Identifier := 'serComments';
    Title := TXT_COMMENTS;
    SeriesColor := clTeeColor;
    Marks.ArrowLength := -24;
    Marks.Visible := true;
    end;
end;

procedure TfrmGraphs.MakeNonNumerics(aChart: TChart);
var
  nonnumericonly, nonnumsection: boolean;
  i, bmax, tmax: integer;
  diffvalue, highestvalue, lowestvalue, padvalue: double;
  astring, listofseries, section: string;
  serBlank: TPointSeries;
begin
  if aChart.Parent = scrlBottom then section := 'bottom'
  else section := 'top';
  nonnumericonly := true;
  for i := 0 to aChart.SeriesCount - 1 do
  begin
    if (aChart.Series[i] is TLineSeries) then
      if aChart.Series[i].Count > 0 then
      begin
        nonnumericonly := false;
        break;
      end;
  end;
  PadNonNum(aChart, section, listofseries, bmax, tmax);
  if bmax = 0 then bmax := 1;
  if tmax = 0 then tmax := 1;
  if nonnumericonly then
  begin
    highestvalue := 1;
    lowestvalue := 0;
  end
  else
  begin
    highestvalue := aChart.MaxYValue(aChart.LeftAxis);
    lowestvalue := aChart.MinYValue(aChart.LeftAxis);
  end;
  diffvalue := highestvalue - lowestvalue;
  if diffvalue = 0 then
    padvalue := highestvalue / 2
  else
    padvalue := POINT_PADDING * diffvalue;
  highestvalue := highestvalue + (tmax * padvalue);
  lowestvalue := lowestvalue - (bmax * padvalue);
  if not (aChart.MinYValue(aChart.LeftAxis) < 0) then
  begin
    if highestvalue < 0 then highestvalue := 0;
    if lowestvalue < 0 then lowestvalue := 0;
  end;
  if lowestvalue > highestvalue then
     lowestvalue := highestvalue;
  aChart.LeftAxis.Maximum := highestvalue;
  aChart.LeftAxis.Minimum := lowestvalue;
  nonnumsection := false;
  for i := 0 to GtslNonNum.Count - 1 do
  begin
    astring := GtslNonNum[i];
    if Piece(astring, '^', 7) = section then
    begin
      nonnumsection := true;
      break;
    end;
  end;
  if nonnumericonly and nonnumsection then
  begin
    serBlank := TPointSeries.Create(aChart);
    MakeSeriesPoint(aChart, serBlank);
    with serBlank do
    begin
      AddXY(aChart.BottomAxis.Minimum, highestvalue, '', aChart.Color);
      AddXY(aChart.BottomAxis.Minimum, lowestvalue, '', aChart.Color);
    end;
    aChart.LeftAxis.Labels := false;
    aChart.MarginLeft := PadLeftNonNumeric(pnlScrollTopBase.Width);
    //aChart.MarginLeft := round((40 / (pnlScrollTopBase.Width + 1)) * 100);       // ************* marginleft is a %
    ChartOnUndoZoom(aChart);
  end;
  MakeNonNumSeries(aChart, padvalue, highestvalue, lowestvalue, listofseries, section);
end;

procedure TfrmGraphs.MakeNonNumSeries(aChart: TChart; padvalue, highestvalue, lowestvalue: double; listofseries, section: string);
var
  asernum, i, j, offset, originalindex, linenum: integer;
  graphvalue, nonvalue: double;
  avalue, line: string;
  adatetime: TDateTime;
  serPoint: TPointSeries;
begin
  for j := 2 to BIG_NUMBER do
  begin
    line := Piece(listofseries, '^' , j);
    if length(line) < 1 then break;
    linenum := strtointdef(line, -BIG_NUMBER);
    if linenum = -BIG_NUMBER then break;
    serPoint := TPointSeries.Create(aChart);
    MakeSeriesPoint(aChart, serPoint);
    with serPoint do
    begin
      serPoint.Title := '(non-numeric)';
      serPoint.Identifier := (aChart.Series[linenum] as TCustomSeries).Title;
      serPoint.Pointer.Style := (aChart.Series[linenum] as TCustomSeries).Pointer.Style;
      serPoint.SeriesColor := (aChart.Series[linenum] as TCustomSeries).SeriesColor;
      serPoint.Tag := BIG_NUMBER + linenum;
    end;
    for i := 0 to GtslNonNum.Count - 1 do
    begin
      avalue := GtslNonNum[i];
      if Piece(avalue, '^', 7) = section then
      begin
        originalindex := strtointdef(Piece(avalue, '^', 3), 0);
        if originalindex = linenum then
        begin
          adatetime := strtofloatdef(Piece(avalue, '^', 1), -BIG_NUMBER);
          asernum := aChart.Tag;
          if adatetime = -BIG_NUMBER then break;
          if asernum = strtointdef(Piece(avalue, '^', 2), -BIG_NUMBER) then
          begin
            offset := strtointdef(Piece(avalue, '^', 5), 1);
            graphvalue := padvalue * offset;
            if copy(Piece(avalue, '^', 13), 0, 1) = '>' then
              nonvalue := highestvalue
            else
              nonvalue := lowestvalue;
            nonvalue := nonvalue + graphvalue;
            with serPoint do
            begin
              Hint := Piece(avalue, '^', 9);
              AddXY(adatetime, nonvalue, '', serPoint.SeriesColor);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmGraphs.StackNonNum(astring: string; var offset, bmax, tmax: integer; var blabelon, tlabelon: boolean);
var
  inlist: boolean;
  i, lastnum, plusminus: integer;
  avalue, checktime, lasttime: string;
begin
  inlist := false;
  offset := 0;
  checktime := Piece(astring, '^', 1);
  if length(checktime) < 4 then exit;
  if copy(Piece(astring, '^', 13), 0, 1) = '>' then
  begin
    checktime := checktime + ';t';    // top values will stack downwards
    plusminus := -1;
    tlabelon := true;
  end
  else
  begin
    checktime := checktime + ';b';    // bottom values will stack upwards
    plusminus := 1;
    blabelon := true;
  end;
  for i := 0 to GtslNonNumDates.Count - 1 do
  begin
    avalue := GtslNonNumDates[i];
    lasttime := Piece(avalue, '^' , 1);
    if checktime = lasttime then
    begin
      lastnum := strtointdef(Piece(avalue, '^', 2), 0);
      offset := lastnum + 1;
      if offset > 0 then bmax := bmax + 1
      else tmax := tmax + 1;
      GtslNonNumDates[i] := checktime + '^' + inttostr(offset * plusminus);
      inlist := true;
      break;
    end;
  end;
  if not inlist then
    GtslNonNumDates.Add(checktime + '^' + inttostr(offset * plusminus));
end;

procedure TfrmGraphs.PadNonNum(aChart: TChart; aSection: string; var listofseries: string; var bmax, tmax: integer);
var
  blabelon, tlabelon: boolean;
  i, offset: integer;
  astring, avalue, charttag, lasttime, newseries, newtime: string;
  serNonNumBottom, serNonNumTop: TPointSeries;
begin
  GtslNonNumDates.Clear;
  listofseries := '^';
  blabelon := false; tlabelon := false;
  bmax := 0; tmax := 0;
  lasttime := '';
  for i := 0 to GtslNonNum.Count - 1 do
  begin
    astring   := GtslNonNum[i];
    if Piece(astring, '^', 7) = aSection then
    begin
      charttag := Piece(astring, '^', 2);
      if charttag = inttostr(aChart.Tag) then
      begin
        newtime   := Piece(astring, '^', 1);
        avalue    := Piece(astring, '^', 13);
        newseries := '^' + Piece(astring, '^', 3) + '^';
        if Pos(newseries, listofseries) = 0 then
          listofseries := listofseries + Piece(astring, '^', 3) + '^';
        StackNonNum(astring, offset, bmax, tmax, blabelon, tlabelon);
        SetPiece(astring, '^', 5, inttostr(offset));
        GtslNonNum[i] := astring;
      end;
    end;
  end;
  if blabelon then
  begin
    serNonNumBottom := TPointSeries.Create(aChart);
    MakeSeriesPoint(aChart, serNonNumBottom);
    with serNonNumBottom do
    begin
      Identifier := 'serNonNumBottom';
      Title := TXT_NONNUMERICS;
      Marks.ArrowLength := -11;
      Marks.Visible := true;
    end;
  end;
  if tlabelon then
  begin
    serNonNumTop := TPointSeries.Create(aChart);
    MakeSeriesPoint(aChart, serNonNumTop);
    with serNonNumTop do
    begin
      Identifier := 'serNonNumTop';
      Title := TXT_NONNUMERICS;
      Marks.ArrowLength := -11;
      Marks.Visible := true;
    end;
  end;
end;

function TfrmGraphs.PortionSize(lcnt, pcnt, gcnt, vcnt, bcnt: integer): double;
var
  dvalue, etotal, evalue, value: double;
begin
  dvalue := (gcnt + vcnt);
  evalue := (pcnt + bcnt) / 2;
  etotal := dvalue + evalue;
  if etotal > 0 then
  begin
    value := lcnt / etotal;
    if value > 4 then Result := 0.2
    else if etotal < 5 then Result := 0.2
    else if value < 0.25 then Result := 0.8
    else if value < 0.4 then Result := 0.6
    else Result := 0.5;
  end
  else
    Result := 0;
end;

procedure TfrmGraphs.MakeDateline(section, aTitle, aFileType: string; aChart: TChart; graphtype: integer;
  var bcnt, pcnt, gcnt, vcnt: integer);
begin
  aChart.LeftAxis.Automatic := true;
  aChart.LeftAxis.Visible := true;
  //if graphtype = 4 then graphtype := 2;    // makes all points into bars
  case graphtype of
    2:  MakeBarSeries(aChart, aTitle, aFileType, bcnt);
    3:  MakeVisitGanttSeries(aChart, aTitle, aFileType, vcnt);
    4:  MakePointSeries(aChart, aTitle, aFileType, pcnt);
    8:  MakeGanttSeries(aChart, aTitle, aFileType, gcnt);
  end;
end;

procedure TfrmGraphs.SizeTogether(onlylines, nolines, anylines: Boolean; aScroll: TScrollBox;
  aChart: TChart; aPanel, aPanelBase: TPanel; portion: Double);
begin
  if onlylines then                     //top &bottom
  begin
    aScroll.Align := alTop;
    aScroll.Height := 1;
    aChart.Visible := false;
    aPanel.Align := alClient;
    aPanel.Visible := true;
  end
  else if nolines then
  begin
    aPanel.Align := alBottom;
    aPanel.Height := 5;
    aScroll.Align := alClient;
    aPanel.Visible := false;
    if btnChangeSettings.Tag = 1 then
      aChart.LeftAxis.Title.Caption := 'StdDev';
  end
  else if anylines then
  begin
    aScroll.Align := alTop;
    aPanel.Align := alBottom;
    aPanel.Height := round(aPanelBase.Height * portion);
    if aPanel.Height < 60 then
      if aPanelBase.Height > 100 then aPanel.Height := 60;           //***
    aScroll.Align := alClient;
    aPanel.Visible := true;
    if btnChangeSettings.Tag = 1 then
      aChart.LeftAxis.Title.Caption := 'StdDev';
  end;
end;

function TfrmGraphs.NextColor(aCnt: integer): TColor;
begin
  case (aCnt mod NUM_COLORS) of
    1: Result := clRed;
    2: Result := clBlue;
    3: Result := clYellow;
    4: Result := clGreen;
    5: Result := clFuchsia;
    6: Result := clMoneyGreen;
    7: Result := clOlive;
    8: Result := clLime;
    9: Result := clMedGray;
   10: Result := clNavy;
   11: Result := clAqua;
   12: Result := clGray;
   13: Result := clSkyBlue;
   14: Result := clTeal;
   15: Result := clBlack;
    0: Result := clPurple;
   16: Result := clMaroon;
   17: Result := clCream;
   18: Result := clSilver;
   else
       Result := clWhite;
   end;
end;


procedure TfrmGraphs.mnuPopGraphSwapClick(Sender: TObject);
var
  tempcheck: boolean;
  bottomview, topview: integer;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  FFirstClick := true;
  if (lvwItemsTop.SelCount = 0) and (lvwItemsBottom.SelCount = 0) then exit;
  topview := lstViewsTop.ItemIndex;
  bottomview := lstViewsBottom.ItemIndex;
  HideGraphs(true);
  with chkDualViews do
    if not Checked then
    begin
      Checked := true;
      Click;
    end;
  tempcheck := chkItemsTop.Checked;
  chkItemsTop.Checked := chkItemsBottom.Checked;
  chkItemsBottom.Checked := tempcheck;
  pnlBottom.Height := pnlMain.Height - pnlBottom.Height;
  GtslScratchSwap.Clear;
  if topview < 1 then
  begin
    aListItem := lvwItemsTop.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      GtslScratchSwap.Add(aGraphItem.Values);
      aListItem := lvwItemsTop.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end;
  GraphSwap(bottomview, topview);
  GtslScratchSwap.Clear;
  HideGraphs(false);
end;

procedure TfrmGraphs.GraphSwap(bottomview, topview: integer);
var
  tempcheck: boolean;
begin
  FFirstClick := true;
  if (lvwItemsTop.SelCount = 0) and (lvwItemsBottom.SelCount = 0) then exit;
  topview := lstViewsTop.ItemIndex;
  bottomview := lstViewsBottom.ItemIndex;
  HideGraphs(true);
  with chkDualViews do
    if not Checked then
    begin
      Checked := true;
      Click;
    end;
  tempcheck := chkItemsTop.Checked;
  chkItemsTop.Checked := chkItemsBottom.Checked;
  chkItemsBottom.Checked := tempcheck;
  pnlBottom.Height := pnlMain.Height - pnlBottom.Height;
  GtslScratchSwap.Clear;
  GraphSwitch(bottomview, topview);
  HideGraphs(false);
end;

procedure TfrmGraphs.GraphSwitch(bottomview, topview: integer);
var
  i, j: integer;
  typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  GtslScratchSwap.Clear;
  if topview < 1 then
  begin
    aListItem := lvwItemsTop.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      GtslScratchSwap.Add(aGraphItem.Values);
      aListItem := lvwItemsTop.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end;
  if bottomview > 0 then
  begin
    lstViewsTop.ItemIndex := bottomview;
    lstViewsTopChange(self);
  end
  else
  begin
    lstViewsTop.ItemIndex := -1;
    lvwItemsTop.ClearSelection;
    aListItem := lvwItemsBottom.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := Pieces(aGraphItem.Values, '^', 1, 2);
      for j := 0 to lvwItemsTop.Items.Count - 1 do
      begin
        aGraphItem := TGraphItem(lvwItemsTop.Items[j].SubItems.Objects[3]);
        if typeitem = Pieces(aGraphItem.Values, '^', 1, 2) then
        begin
          lvwItemsTop.Items[j].Selected := true;
          break;
        end;
      end;
      aListItem := lvwItemsBottom.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
    lvwItemsTopClick(self);
  end;
  if topview > 0 then
  begin
    lstViewsBottom.ItemIndex := topview;
    lstViewsBottomChange(self);
  end
  else
  begin
    lstViewsBottom.ItemIndex := -1;
    lvwItemsBottom.ClearSelection;
    for i := 0 to GtslScratchSwap.Count - 1 do
      for j := 0 to lvwItemsBottom.Items.Count - 1 do
      begin
        aGraphItem := TGraphItem(lvwItemsBottom.Items.Item[j].SubItems.Objects[3]);
        if aGraphItem.Values = GtslScratchSwap[i] then
        begin
          lvwItemsBottom.Items[j].Selected := true;
          break;
        end;
      end;
    lvwItemsBottomClick(self);
  end;
  GtslScratchSwap.Clear;
end;

procedure TfrmGraphs.mnuPopGraphSplitClick(Sender: TObject);
begin
  FFirstClick := true;
  if (lvwItemsTop.SelCount = 0) and (lvwItemsBottom.SelCount = 0) then exit;
  HideGraphs(true);
  with chkDualViews do
    if not Checked then
    begin
      Checked := true;
      Click;
    end;
  with lstViewsTop do
    if ItemIndex > -1 then
    begin
      ItemIndex := -1;
    end;
  with lstViewsBottom do
    if ItemIndex > -1 then
    begin
      ItemIndex := -1;
    end;
    SplitClick;
end;

procedure TfrmGraphs.SplitClick;

  procedure SplitGraphs(aListView: TListView);
  var
    typeitem: string;
    aGraphItem: TGraphItem;
    aListItem: TListItem;
  begin
    aListItem := lvwItemsTop.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := Pieces(aGraphItem.Values, '^', 1, 2);
      GtslScratchSwap.Add(typeitem);
      aListItem := lvwItemsTop.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end;

var
  i: integer;
  typeitem, typenum: string;
begin
  chkItemsTop.Checked := true;
  chkItemsBottom.Checked := false;
  pnlBottom.Height := pnlMain.Height - pnlBottom.Height;
  GtslScratchSwap.Clear;
  SplitGraphs(lvwItemsTop);
  SplitGraphs(lvwItemsBottom);
  lvwItemsTop.ClearSelection;
  lvwItemsBottom.ClearSelection;
  for i := 0 to GtslScratchSwap.Count - 1 do
  begin
    typeitem := GtslScratchSwap[i];
    typenum := Piece(typeitem, '^', 1);
    if (typenum = '63') or (typenum = '120.5') then
      SelectItem(lvwItemsTop, typeitem)
    else
      SelectItem(lvwItemsBottom, typeitem);
  end;
  lvwItemsTopClick(self);
  lvwItemsBottomClick(self);
  GtslScratchSwap.Clear;
  HideGraphs(false);
end;

procedure TfrmGraphs.SelectItem(aListView: TListView; typeitem: string);
var
  i: integer;
  aGraphItem: TGraphItem;
begin
  with aListView do
    for i := 0 to Items.Count - 1 do
    begin
      aGraphItem := TGraphItem(Items.Item[i].SubItems.Objects[3]);
      if typeitem = Pieces(aGraphItem.Values, '^', 1, 2) then
        Items[i].Selected := true;
    end;
end;

procedure TfrmGraphs.mnuPopGraphLinesClick(Sender: TObject);
begin
  with FGraphSetting do Lines := not Lines;
  ChangeStyle;
end;

procedure TfrmGraphs.mnuPopGraph3DClick(Sender: TObject);
begin
  with FGraphSetting do View3D := not View3D;
  ChangeStyle;
end;

procedure TfrmGraphs.mnuPopGraphValueMarksClick(Sender: TObject);
var
  i: integer;
begin
  if (FGraphSeries is TPointSeries) and not (FGraphSeries is TGanttSeries) then
  begin
    if (FGraphSeries as TPointSeries).Pointer.Style = psSmallDot then exit;    // keep non-numeric label unchanged
    if Piece(FGraphSeries.Title, '^', 1) = '(non-numeric)' then
    begin
      FGraphSeries.Marks.Visible := not FGraphSeries.Marks.Visible;
      for i := 0 to FGraphClick.SeriesCount - 1 do
      begin
        if FGraphClick.Series[i].Title = FGraphSeries.Identifier then
        begin
          FGraphClick.Series[i].Marks.Visible := FGraphSeries.Marks.Visible;
          if FGraphSeries.Title <> 'Blood Pressure' then break;
        end;
      end;
    end;
  end
  else if chartDatelineTop.Tag = 1 then               // series
  begin
    FGraphSeries.Marks.Visible := not FGraphSeries.Marks.Visible;
    for i := 0 to FGraphClick.SeriesCount - 1 do
    begin
      if (FGraphClick.Series[i].Identifier = FGraphSeries.Title)
      or (FGraphClick.Series[i].Title = FGraphSeries.Title) then
      begin
        FGraphClick.Series[i].Marks.Visible := FGraphSeries.Marks.Visible;
        if FGraphSeries.Title <> 'Blood Pressure' then break;
      end;
    end;
  end;
end;

procedure TfrmGraphs.mnuPopGraphValuesClick(Sender: TObject);
begin
  with FGraphSetting do Values := not Values;
  ChangeStyle;
end;

procedure TfrmGraphs.mnuPopGraphSortClick(Sender: TObject);
begin
  with FGraphSetting do
  begin
    if SortColumn = 1 then SortColumn := 0
    else SortColumn := 1;
    mnuPopGraphSort.Checked := SortColumn = 1;
    if not FItemsSortedTop then
    begin
      lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[0]);
      FItemsSortedTop := true;
    end;
    if not FItemsSortedBottom then
    begin
      lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[0]);
      FItemsSortedBottom := true;
    end;
    if SortColumn > 0 then
    begin
      lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[SortColumn]);
      lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[SortColumn]);
      FItemsSortedTop := false;
      FItemsSortedBottom := false;
    end;
  end;
end;

procedure TfrmGraphs.mnuPopGraphClearClick(Sender: TObject);
begin
  with FGraphSetting do
  begin
    ClearBackground := not ClearBackground;
    if ClearBackground then Gradient := false;
  end;
  ChangeStyle;
  // ???redisplay if nonnumericonly graph exists
  if pnlItemsTop.Tag = 1 then lvwItemsTopClick(self);
  if pnlItemsBottom.Tag = 1 then lvwItemsBottomClick(self);
end;

procedure TfrmGraphs.mnuPopGraphHorizontalClick(Sender: TObject);
begin
  with FGraphSetting do
  begin
    HorizontalZoom := not HorizontalZoom;
    mnuPopGraphHorizontal.Checked := HorizontalZoom;
    if not HorizontalZoom then mnuPopGraphResetClick(self);
  end;
end;

procedure TfrmGraphs.mnuPopGraphVerticalClick(Sender: TObject);
begin
  with FGraphSetting do
  begin
    VerticalZoom := not VerticalZoom;
    mnuPopGraphVertical.Checked := VerticalZoom;
    if not VerticalZoom then mnuPopGraphResetClick(self);
  end;
end;

procedure TfrmGraphs.mnuPopGraphViewDefinitionClick(Sender: TObject);
begin
  mnuPopGraphViewDefinition.Checked := not mnuPopGraphViewDefinition.Checked;
  if mnuPopGraphViewDefinition.Checked  then
  begin
    memViewsTop.Height := (tsTopViews.Height div 3) + 1;
    memViewsBottom.Height := (tsBottomViews.Height div 3) + 1;
  end
  else
  begin
    memViewsTop.Height := 1;
    memViewsBottom.Height := 1;
  end;
end;

procedure TfrmGraphs.mnuPopGraphDatesClick(Sender: TObject);
begin
  with FGraphSetting do Dates := not Dates;
  ChangeStyle;
end;

procedure TfrmGraphs.mnuPopGraphDualViewsClick(Sender: TObject);
begin
  chkDualViews.Checked := not chkDualViews.Checked;
  chkDualViewsClick(self);
end;

procedure TfrmGraphs.mnuPopGraphExportClick(Sender: TObject);

  procedure AddRow(worksheet: variant;
    linestring, typename, itemname, date1, date2, result, other: string);
  begin
    worksheet.range('A' + linestring) := typename;
    worksheet.range('B' + linestring) := itemname;
    worksheet.range('C' + linestring) := date1;
    worksheet.range('D' + linestring) := date2;
    worksheet.range('E' + linestring) := result;
    worksheet.range('F' + linestring) := other;
  end;

  procedure FillData(aListView: TListView; worksheet: variant; var cnt: integer);
  var
    i: integer;
    dtdata1, dtdata2: double;
    item, itemname, itemtype, itemtypename, typeitem: String;
    datax, fmdate1, fmdate2, linestring: String;
    aGraphItem: TGraphItem;
    aListItem: TListItem;
  begin
    aListItem := aListView.Selected;
    while aListItem <> nil do
    begin
      itemname := aListItem.Caption;
      itemtypename := aListItem.SubItems[0];
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := UpperCase(aGraphItem.Values);
      itemtype := Piece(typeitem, '^', 1);
      item := Piece(typeitem, '^', 2);
      for i := 0 to GtslData.Count - 1 do
      begin
        datax := GtslData[i];
        if Piece(datax, '^', 1) = itemtype then
          if Piece(datax, '^', 2) = item then
          begin
            dtdata1 := strtofloatdef(Piece(datax, '^', 3), -1);
            fmdate1 := FormatFMDateTime('c', dtdata1);
            fmdate1 := StringReplace(fmdate1, ' 00:00', '', [rfReplaceAll]);
            dtdata2 := strtofloatdef(Piece(datax, '^', 4), -1);
            if DatesInRange(uDateStart, uDateStop, dtdata1, dtdata2) then
            begin
              fmdate2 := FormatFMDateTime('c', dtdata2);
              fmdate2 := StringReplace(fmdate2, ' 00:00', '', [rfReplaceAll]);
              cnt := cnt + 1;
              linestring := inttostr(cnt);
              AddRow(worksheet, linestring, itemtypename, itemname, fmdate1, fmdate2, Piece(datax, '^', 5), Piece(datax, '^', 8));
            end;
          end;
      end;
      aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end;

var
  cnt, i: integer;
  aTitle, aWarning, aDateRange, ShortHeader, StrForFooter, StrForHeader: String;
  linestring: String;
  aHeader: TStringList;
  excelApp, workbook, worksheet: Variant;
begin
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    raise Exception.Create('Cannot start MS Excel!');
  end;
  Screen.Cursor := crDefault;
  aTitle := 'CPRS Graphing';
  aWarning := pnlInfo.Caption;
  aDateRange :=  'Date Range: ' + cboDateRange.Text + '  Selected Items from ' +
      FormatDateTime('mm/dd/yy', FGraphSetting.LowTime) + ' to ' +
      FormatDateTime('mm/dd/yy', FGraphSetting.HighTime);
  aHeader := TStringList.Create;
  CreateExcelPatientHeader(aHeader, aTitle, aWarning, aDateRange);
  StrForHeader := '';
  for i := 0 to aHeader.Count -1 do
    if (length(StrForHeader) + length(aHeader[i])) < 250 then
      StrForHeader := StrForHeader + aHeader[i] + #13;
  ShortHeader := Patient.Name + '         ' + Patient.SSN + '          '
         + Encounter.LocationName + '                            '
         + FormatFMDateTime('dddddd', Patient.DOB) + ' (' + IntToStr(Patient.Age) + ')'
         + #13 + TXT_COPY_DISCLAIMER;
  StrForFooter := aTitle + '                    *** WORK COPY ONLY ***                            '
                + 'Printed: ' + FormatDateTime('mmm dd, yyyy  hh:nn', Now) + #13;
  excelApp.Visible := true;
  workbook := excelApp.workbooks.add;
  worksheet := workbook.worksheets.add;
  worksheet.name := aTitle;
  worksheet.PageSetup.PrintArea := '';
  worksheet.PageSetup.TopMargin := 120;
  worksheet.PageSetup.LeftFooter := StrForFooter;
  worksheet.PageSetup.RightFooter := 'Page &P of &N';
  AddRow(worksheet, '1', 'Type', 'Item', 'Date1', 'Date2', 'Value', 'Other');
  cnt := 1;
  FillData(lvwItemsTop, worksheet, cnt);
  if lvwItemsBottom.Items.Count > 0 then
  begin
    cnt := cnt + 1;
    linestring := inttostr(cnt);
    AddRow(worksheet, linestring, '', '', '', '', '', '');
    FillData(lvwItemsBottom, worksheet, cnt);
  end;
  worksheet.Range['A1', 'F' + LineString].Columns.AutoFit;
  worksheet.Range['A1', 'F' + LineString].Select;
  worksheet.Range['A1', 'F' + LineString].AutoFormat(12, true, true, true, true, true, true);
  if length(StrForHeader) > 250 then
    worksheet.PageSetup.CenterHeader := ShortHeader           // large header does not work (excel errors when > 255 char)
  else
    worksheet.PageSetup.CenterHeader := StrForHeader;
  Screen.Cursor := crDefault;
  aHeader.Free;
end;

procedure TfrmGraphs.mnuPopGraphSeparate1Click(Sender: TObject);
begin
  with mnuPopGraphSeparate1 do
    Checked := not Checked;
  with chkItemsTop do
  begin
    Checked := mnuPopGraphSeparate1.Checked;
    Click;
  end;
  with chkItemsBottom do
  begin
    Checked := mnuPopGraphSeparate1.Checked;
    Click;
  end;
end;

procedure TfrmGraphs.mnuPopGraphGradientClick(Sender: TObject);
begin
  with FGraphSetting do
  begin
    Gradient := not Gradient;
    if Gradient then ClearBackground := false;
  end;
  ChangeStyle;
end;

procedure TfrmGraphs.mnuPopGraphHintsClick(Sender: TObject);
begin
  with FGraphSetting do
    Hints := not Hints;
  ChangeStyle;
end;

procedure TfrmGraphs.mnuPopGraphLegendClick(Sender: TObject);
begin
  with FGraphSetting do Legend := not Legend;
  ChangeStyle;
end;

procedure TfrmGraphs.ChartColor(aColor: TColor);
begin
  chartDatelineTop.Color := aColor;
  chartDatelineTop.Legend.Color := aColor;
  pnlDatelineTopSpacer.Color := aColor;
  scrlTop.Color := aColor;
  pnlTopRightPad.Color := aColor;
  pnlScrollTopBase.Color := aColor;
  pnlBlankTop.Color := aColor;
  chartDatelineBottom.Color := aColor;
  chartDatelineBottom.Legend.Color := aColor;
  pnlDatelineBottomSpacer.Color := aColor;
  scrlBottom.Color := aColor;
  pnlBottomRightPad.Color := aColor;
  pnlScrollBottomBase.Color := aColor;
  pnlBlankBottom.Color := aColor;
end;

procedure TfrmGraphs.ChartStyle(aChart: TChart);
var
  j: integer;
begin
  with aChart do
  begin
    View3D := FGraphSetting.View3D;
    Chart3DPercent := 10;
    AllowZoom := FGraphSetting.HorizontalZoom;
    Gradient.Visible := FGraphSetting.Gradient;
    Legend.Visible := FGraphSetting.Legend;
    HideDates(aChart);
    pnlHeader.Visible := pnlInfo.Visible;
    if FGraphSetting.ClearBackground then
    begin
      Color := clWindow;
      Legend.Color := clWindow;
      pnlBlankTop.Color := clWindow;
      pnlBlankBottom.Color := clWindow;
    end
    else
    begin
      Color := clBtnFace;
      Legend.Color := clCream;
      pnlBlankTop.Color := clBtnFace;
      pnlBlankBottom.Color := clBtnFace;
    end;
    for j := 0 to SeriesCount - 1 do
    begin
      if Series[j] is TLineSeries then
        with (Series[j] as TLineSeries) do
        begin
          Marks.Visible := FGraphSetting.Values;
          LinePen.Visible := FGraphSetting.Lines;
        end;
      if Series[j] is TPointSeries then
        with (Series[j] as TPointSeries) do
        if Pointer.Style <> psSmallDot then      // keep non-numeric label unchanged
        begin
          Marks.Visible := FGraphSetting.Values;
          LinePen.Visible := FGraphSetting.Lines;
          if Title = '(non-numeric)' then Marks.Visible := FDisplayFreeText;
        end;
      if Series[j] is TBarSeries then
        with (Series[j] as TBarSeries) do
        begin
          Marks.Visible := FGraphSetting.Values;
        end;
      if Series[j] is TArrowSeries then
        with (Series[j] as TArrowSeries) do
        begin
          Marks.Visible := FGraphSetting.Values;
        end;
      if Series[j] is TGanttSeries then
        with (Series[j] as TGanttSeries) do
        begin
          Marks.Visible := FGraphSetting.Values;
          LinePen.Visible := FGraphSetting.Lines;
        end;
    end;
  end;
end;

procedure TfrmGraphs.ChangeStyle;
var
  i: integer;
  ChildControl: TControl;
  ClearColor, OriginalColor: TColor;
begin
  OriginalColor := pnlItemsTopInfo.Color;
  ClearColor := clWindow;
  for i := 0 to scrlTop.ControlCount - 1 do
  begin
    ChildControl := scrlTop.Controls[i];
    ChartStyle(ChildControl as TChart);
  end;
  for i := 0 to scrlBottom.ControlCount - 1 do
  begin
    ChildControl := scrlBottom.Controls[i];
    ChartStyle(ChildControl as TChart);
  end;
  if pnlDateLineTop.Visible then   // not visible when separate graphs
    ChartStyle(chartDateLineTop);
  if pnlDateLineBottom.Visible then
    ChartStyle(chartDateLineBottom);
  if FGraphSetting.ClearBackground then
    ChartColor(ClearColor)
  else
    ChartColor(OriginalColor);
  mnuPopGraphLines.Checked := FGraphSetting.Lines;
  mnuPopGraph3D.Checked := FGraphSetting.View3D;
  mnuPopGraphValues.Checked := FGraphSetting.Values;
  mnuPopGraphDates.Checked := FGraphSetting.Dates;
  mnuPopGraphFixed.Checked := FGraphSetting.FixedDateRange;
  mnuPopGraphGradient.Checked := FGraphSetting.Gradient;
  mnuPopGraphHints.Checked := FGraphSetting.Hints;
  mnuPopGraphStayOnTop.Checked := FGraphSetting.StayOnTop;
  mnuPopGraphLegend.Checked := FGraphSetting.Legend;
  mnuPopGraphSort.Checked := FGraphSetting.SortColumn = 1;
  mnuPopGraphClear.Checked := FGraphSetting.ClearBackground;
  mnuPopGraphVertical.Checked := FGraphSetting.VerticalZoom;
  mnuPopGraphHorizontal.Checked := FGraphSetting.HorizontalZoom;
  mnuPopGraphMergeLabs.Checked := FGraphSetting.MergeLabs;
end;

procedure TfrmGraphs.chartBaseClickSeries(Sender: TCustomChart; Series: TChartSeries;
  ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lbutton: boolean;
begin
  if FOnMark then       // action already taken by mousedown on a mark
  begin
    FOnMark := false;
    exit;
  end;
  FOnMark := false;
  timHintPause.Enabled := false;
  InactivateHint;
  FGraphClick := Sender;
  FGraphSeries := Series;
  FGraphValueIndex := ValueIndex;
  chartDateLineTop.Tag := 1;       // indicates a series click
  if (Series is TGanttSeries) then
  begin
    FDate1 := (Series as TGanttSeries).StartValues[ValueIndex];
    FDate2 := (Series as TGanttSeries).EndValues[ValueIndex];
  end
  else
  begin
    FDate1 := Series.XValue[ValueIndex];
    FDate2 := FDate1;
  end;
  lbutton := Button <> mbRight;
  (Sender as TChart).AllowZoom := false;
  SeriesClicks(Sender as TChart, Series, ValueIndex, lbutton);
  FMouseDown := false;
  //(Sender as TChart).AllowZoom := FGraphSetting.HorizontalZoom;
end;


procedure TfrmGraphs.SeriesClicks(aChart: TChart; aSeries: TChartSeries; aIndex: integer; lbutton: boolean);
var
  originalindex: integer;
  dttm, labresult, seriestitle, showing, testname, textvalue, textvalue1, textvalue2, typename, typenum: string;
begin
  if lbutton then
  begin
    textvalue := ValueText(aChart, aSeries, aIndex);
    textvalue := StringReplace(textvalue, ' 00:00', '', [rfReplaceAll]);
    dttm := Piece(textvalue, '^', 3);
    textvalue1 := Piece(textvalue, '^', 2) + '  ' + dttm;
    typenum := trim(Piece(textvalue, '^', 1));
    typename := Piece(textvalue, '^', 2);
    if typenum = '63' then
    begin
      LabNameResults(textvalue, testname, labresult);
      textvalue2 := testname + '  ' + labresult;
    end
    else
      textvalue2 := Piece(textvalue, '^', 4) + '  ' + Piece(textvalue, '^', 5);
    AllTypeDate(typenum, typename, textvalue1, textvalue2, FDate1, FDate2);
  end
  else
  begin
    seriestitle := Piece(aSeries.Title, '^', 1);
    if seriestitle = '(non-numeric)' then
    begin
      originalindex := strtointdef(Piece(GtslNonNum[aIndex], '^', 3), 0);
      seriestitle := Piece(aChart.Series[originalindex].Title, '^', 1);
    end;
    mnuPopGraphIsolate.Enabled := true;
    if pnlTop.Tag = 1 then
      mnuPopGraphIsolate.Caption := 'Move - ' + seriestitle + ' - from Top to Bottom'
    else
      mnuPopGraphIsolate.Caption := 'Move - ' + seriestitle + ' - from Bottom to Top';
    scrlTop.Hint := 'Details - for ' + seriestitle + ' for ' +
      FormatDateTime('mmm d, yyyy  h:nn am/pm', FDate1);
    scrlTop.Tag := aIndex + 1;
    mnuPopGraphIsolate.Hint := seriestitle;
    mnuPopGraphRemove.Enabled := true;
    mnuPopGraphRemove.Caption := 'Remove - ' + seriestitle;
    mnuPopGraphDetails.Caption := 'Details - ' + seriestitle;
    if FGraphSeries.Marks.Visible then showing := ' - turn off' else showing := ' - turn on';
    mnuPopGraphValueMarks.Caption := 'Values - ' + seriestitle + showing;
    mnuPopGraphValueMarks.Enabled := true;
  end;
end;

procedure TfrmGraphs.AllTypeDate(aType, aTypeName, firstline, secondline: string; aDate, aDate2: double);
var
  i: integer;
  datex1, datex2, newline, oldline, spacer, titlemsg: string;
  labdate, labflag, labname, labunit, labvalue, refrange, specimen, testnum: string;
  dt1, dt2: double;
  tmpOtherList, templist: TStringList;
begin
  Screen.Cursor := crHourGlass;
  FPointClick := true;
  tmpOtherList := TStringList.Create;
  templist := TStringList.Create;
  datex1 := floattostr(DateTimeToFMDateTime(aDate));
  datex1 := Piece(datex1, '.', 1);
  if aDate <> aDate2 then
    datex2 := Piece(floattostr(DateTimeToFMDateTime(aDate2)), '.', 1) + '.23595959'
  else
    datex2 := datex1 + '.23595959';
  dt1 := strtofloatdef(datex1, BIG_NUMBER);
  dt2 := strtofloatdef(datex2, BIG_NUMBER);
  CheckToAddData(lvwItemsTop, 'top', aType);    // if type is not loaded - load data
  TempData(tmpOtherList, aType, dt1, dt2);
  with tmpOtherList do
  begin
    Sort;
    for i := Count - 1 downto 0 do
    begin
      newline := '';
      oldline := tmpOtherList[i];
      if aType = '63' then
      begin
        testnum := Piece(oldline, '^', 2);
        labvalue := Piece(oldline, '^', 3);
        labdate := Piece(oldline, '^', 4);
        labname := Piece(oldline, '^', 5);
        labflag := Piece(oldline, '^', 6);
        specimen := lowercase(Piece(oldline, '^', 8));
        refrange := Piece(oldline, '^', 10);
        labunit := Piece(oldline, '^', 11);
        if refrange = '!' then
          refrange := ''
        else
          refrange := Piece(refrange, '!', 1) + ' - ' + Piece(refrange, '!', 2);
        if Piece(testnum, '.', 2) = '0' then
          labname := Piece(labname, '*', 1) + ' (' + specimen + ')';
        newline := labdate + '   ' + labname;
        spacer := Copy(BIG_SPACES, 1, 42 - length(newline) - length(labvalue));
        newline := newline + spacer + ' ' + labvalue + ' ' + labflag;
        spacer := Copy(BIG_SPACES, 1, 47 - length(newline));
        newline := newline + spacer + ' ' + labunit;
        spacer := Copy(BIG_SPACES, 1, 57 - length(newline));
        newline := newline + spacer + ' ' + refrange;
      end
      else
      begin
        newline := Piece(oldline, '^', 4) + '   ' + Piece(oldline, '^', 5);
        spacer := Copy(BIG_SPACES, 1, 40 - length(newline));
        newline := newline + spacer + ' ' + Piece(oldline, '^', 3);
      end;
      templist.Add(newline);
    end;
    Clear;
    FastAssign(templist, tmpOtherList);
    if Copy(aTypeName, length(aTypeName) - 2, 3) = 'ies' then
      aTypeName := Copy(aTypeName, 1, length(aTypeName) - 3) + 'y'
    else if Copy(aTypeName, length(aTypeName), 1) = 's' then
      aTypeName := Copy(aTypeName, 1, length(aTypeName) - 1);
    //Assign(templist);
    if aDate <> aDate2 then
      titlemsg := aTypeName + ' occurrences for ' + FormatDateTime('mmm d, yyyy', aDate) +
        ' - ' + FormatDateTime('mmm d, yyyy', aDate2)
    else
      titlemsg := aTypeName + ' occurrences for ' + FormatDateTime('mmm d, yyyy', aDate);
    Insert(0, firstline);
    Insert(1, secondline);
    Insert(2, '');
    Insert(3, 'All ' + titlemsg + ':');
    Insert(4, '');
    Insert(0, TXT_REPORT_DISCLAIMER);
    Insert(1, '');
    ReportBox(tmpOtherList, titlemsg, true);
  end;
  tmpOtherList.Free;
  templist.Free;
  FPointClick := false;
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.TempData(aStringList: TStringList; aType: string; dt1, dt2: double);
var
  i: integer;
  dttm, datax, fmdate1, fmdate2, itemnum, itemqualifier, newdata: string;
  date1, date2, itemvalue: string;
  dtdata, dtdata1, dtdata2: double;
  ok: boolean;
begin
  for i := 0 to GtslData.Count - 1 do
  begin
    datax := GtslData[i];
    if Piece(datax, '^', 1) = aType then
    begin
      itemnum := Piece(datax, '^', 2);
      date1 := Piece(datax, '^', 3);
      date2 := Piece(datax, '^', 4);
      itemvalue := Piece(datax, '^', 5);
      if (length(date2)> 0) then    // date/times of episodes
      begin
        dtdata1 := strtofloatdef(date1, -1);
        fmdate1 := FormatFMDateTime('c', dtdata1);
        fmdate1 := StringReplace(fmdate1, ' 00:00', '', [rfReplaceAll]);
        dtdata2 := strtofloatdef(date2, -1);
        fmdate2 := FormatFMDateTime('c', dtdata2);
        fmdate2 := StringReplace(fmdate2, ' 00:00', '', [rfReplaceAll]);
        if (dtdata2 > dt1) and (dtdata1 < dt2) then
        begin
          newdata := date1 + '^' +
                     itemnum + '^' +
                     fmdate1 + ' - ' +
                     fmdate2 + '^' +
                     ItemName(aType, itemnum) + '^' +
                     itemvalue;
          aStringList.Add(MixedCase(newdata));
        end;
      end
      else
      begin
        ok := true;
        if aType = '63' then
        begin
          SetRef(datax);
          itemqualifier := Piece(itemnum, '.', 2);
          if length(itemqualifier) > 0 then
          begin
            if FGraphSetting.MergeLabs then
              if itemqualifier  <> '0' then ok := false;
            if not FGraphSetting.MergeLabs then
              if itemqualifier  = '0' then ok := false;
          end;
        end;
        if ok then
        begin
          dtdata := strtofloatdef(date1, -1);
          if (dtdata >= dt1) and (dtdata < dt2) then
          begin
            if length(Piece(date1, '.', 2)) > 0 then
              dttm := FormatFMDateTime('c', dtdata)
            else
              dttm := FormatFMDateTime('ddddd', dtdata);
            newdata := date1 + '^' +
            itemnum + '^' +
            itemvalue + '^' +
            dttm + '^' +
            ItemName(aType, itemnum);
            newdata := MixedCase(newdata);
            newdata := newdata + '^' + Pieces(datax, '^', 6, 11);
            aStringList.Add(newdata);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmGraphs.SetRef(var datax: string);
var
  hi, itemnum, lo, refrange, specnum, units, unitsv: string;
begin
  itemnum := Piece(datax, '^', 2);
  specnum := Piece(datax, '^', 7);
  refrange := Piece(datax, '^', 10);
  units := Piece(datax, '^', 11);
  if length(refrange) = 0 then
  begin
    lo := ''; hi := ''; unitsv := '';
    RefUnits(itemnum, specnum, lo, hi, unitsv);
    refrange := lo + '!' + hi;
    SetPiece(datax, '^', 10, refrange);
    if length(units) = 0 then
      SetPiece(datax, '^', 11, unitsv);
  end;
end;

procedure TfrmGraphs.SetRefNonNum(var datax: string);
var
  hi, itemnum, lo, refrange, specnum, units, unitsv: string;
begin
  itemnum := Piece(datax, '^', 10);
  specnum := Piece(datax, '^', 15);
  refrange := Piece(datax, '^', 18);
  units := Piece(datax, '^', 19);
  if length(refrange) = 0 then
  begin
    lo := ''; hi := ''; unitsv := '';
    RefUnits(itemnum, specnum, lo, hi, unitsv);
    refrange := lo + '!' + hi;
    SetPiece(datax, '^', 18, refrange);
    if length(units) = 0 then
      SetPiece(datax, '^', 19, unitsv);
  end;
end;

procedure TfrmGraphs.ItemDateRange(Sender: TCustomChart);
var
  bpnotdone, ok: boolean;
  i, j: integer;
  prevtype, results, seriestitle, seriestype, spacer, textvalue, typenum: string;
  datadate, labdate, labflag, labname, labunit, labvalue, newline, refrange, specimen, testnum: string;
  tmpOtherList: TStringList;
begin
  Screen.Cursor := crHourGlass;
  prevtype := '';
  tmpOtherList := TStringList.Create;
  with tmpOtherList do
  begin
    Add('Date Range: ' + cboDateRange.Text);
    Add('Selected Items from ' +
      FormatDateTime('mm/dd/yy', FGraphSetting.LowTime) + ' to ' +
      FormatDateTime('mm/dd/yy', FGraphSetting.HighTime));
    Add('');
  end;
  bpnotdone := true;
  for i := 0 to Sender.SeriesCount - 1 do
  begin
    if Sender.Series[i].Count > 0 then
    begin
      textvalue := ValueText(Sender, Sender.Series[i], 0);
      seriestype := Piece(textvalue, '^', 2);
      if (seriestype <> '') and (seriestype <> prevtype) then
      begin
        tmpOtherList.Add('     ' + seriestype);    // type
        prevtype := seriestype;
      end;
    end;
    ok := true;
    seriestitle := Sender.Series[i].Title;
    if seriestitle = 'Blood Pressure' then
      if not bpnotdone then ok := false;
    if ok then
    begin
      for j := 0 to Sender.Series[i].Count - 1 do
      begin
        textvalue := ValueText(Sender, Sender.Series[i], j);
        seriestitle := Piece(textvalue, '^', 4);
        typenum := trim(Piece(textvalue, '^', 1));
        if (typenum = '120.5') and (seriestitle = 'Blood Pressure') then bpnotdone := false;
        if length(typenum) > 0 then
        begin
          if typenum = '63' then
          begin
            testnum := Piece(textvalue, '^', 7);
            labvalue := Piece(textvalue, '^', 9);
            labdate := Piece(textvalue, '^', 6);
            labname := Piece(textvalue, '^', 4);
            labflag := Piece(textvalue, '^', 10);
            specimen := lowercase(Piece(textvalue, '^', 11));
            refrange := Piece(textvalue, '^', 12);
            labunit := Piece(textvalue, '^', 13);
            if refrange = '!' then
              refrange := ''
            else
              refrange := Piece(refrange, '!', 1) + ' - ' + Piece(refrange, '!', 2);
            if Piece(testnum, '.', 2) = '0' then
              labname := Piece(labname, '*', 1) + ' (' + specimen + ')';
            newline := labname;
            spacer := Copy(BIG_SPACES, 1, 29 - length(newline) - length(labvalue));
            newline := newline + spacer + ' ' + labvalue + ' ' + labflag;
            spacer := Copy(BIG_SPACES, 1, 34 - length(newline));
            newline := newline + spacer + ' ' + labunit;
            spacer := Copy(BIG_SPACES, 1, 44 - length(newline));
            newline := newline + spacer + ' ' + refrange;
            spacer := Copy(BIG_SPACES, 1, 58 - length(newline));
            newline := newline + spacer + ' ' + labdate;
            if length(labdate)= 0 then   // in case of duplicate names in listview
              newline := newline + ' ' + TXT_WARNING_CHECK_RESULTS;
            tmpOtherList.Add(newline);                 // item occurrence
          end
          else
          begin
            if typenum = '120.5' then
              datadate := Piece(textvalue, '^', 6)
            else
              datadate := Piece(textvalue, '^', 8);
            spacer := Copy(BIG_SPACES, 1, 30 - length(seriestitle));
            results := seriestitle + ':  ' + //spacer +
            Piece(textvalue, '^', 5); //LowerCase(Piece(textvalue, '^', 5));
            spacer := Copy(BIG_SPACES, 1, 54 - length(results));
            results := results + ' ' + spacer + datadate;
            results := StringReplace(results, ' 00:00', '', [rfReplaceAll]);
            if length(datadate)= 0 then   // in case of duplicate names in listview
              results := results + ' ' + TXT_WARNING_CHECK_RESULTS;
            tmpOtherList.Add(results);                 // item occurrence
          end;
        end;
      end;
    end;
  end;                               // same items are not being sorted by date
  if tmpOtherList.Count > 0 then
  begin
    tmpOtherList.Insert(0, TXT_REPORT_DISCLAIMER);
    tmpOtherList.Insert(1, '');
    ReportBox(tmpOtherList, 'Selected Items from Graph', true);
  end;
  tmpOtherList.Free;
  FMouseDown := false;
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.mnuPopGraphIsolateClick(Sender: TObject);
var
  i, j, selnum: integer;
  aOtherSection, aSection, typeitem: string;
  aGraphItem: TGraphItem;
  aListView, aOtherListView: TListView;
  aListItem: TListItem;
begin
  FFirstClick := true;
  lstViewsTop.ItemIndex := -1;
  lstViewsBottom.ItemIndex := -1;
  if pnlTop.Tag = 1 then
  begin
    aListView := lvwItemsTop;       aOtherListView := lvwItemsBottom;
    aSection := 'top';              aOtherSection := 'bottom';
  end
  else
  begin
    aListView := lvwItemsBottom;    aOtherListView := lvwItemsTop;
    aSection := 'bottom';           aOtherSection := 'top';
  end;
  if aListView.SelCount = 0 then exit;
  if StripHotKey(mnuPopGraphIsolate.Caption) = ('Move all selections to ' + aOtherSection) then
  begin
    aListItem := aListView.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := Pieces(aGraphItem.Values, '^', 1, 2);
      for j := 0 to aOtherListView.Items.Count - 1 do
      begin
        aGraphItem := TGraphItem(aOtherListView.Items.Item[j].SubItems.Objects[3]);
        if Pieces(aGraphItem.Values, '^', 1, 2) = typeitem then
          aOtherListView.Items[j].Selected := true;
      end;
      aListItem.Selected := false;
      aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end
  else
  begin
    ItemCheck(lvwItemsTop, mnuPopGraphIsolate.Hint, selnum, typeitem);
    if selnum = -1 then exit;
    for i := 0 to aOtherListView.Items.Count - 1 do
    begin
      aGraphItem := TGraphItem(aOtherListView.Items.Item[i].SubItems.Objects[3]);
      if Pieces(aGraphItem.Values, '^', 1, 2) = typeitem then
        aOtherListView.Items[i].Selected := true;
    end;
    aListView.Items[selnum].Selected := false;
  end;
  with chkDualViews do
  if not Checked then
  begin
    Checked := true;
    Click;
  end;
  ChangeStyle;
  DisplayData(aSection);
  DisplayData(aOtherSection);
  mnuPopGraphIsolate.Enabled := false;
end;

procedure TFrmGraphs.ItemCheck(aListView: TListView; aItemName: string;
  var aNum: integer; var aTypeItem: string);
var
  i: integer;
  aGraphItem: TGraphItem;
begin
  aNum := -1;
  aTypeItem := '';
  with aListView do
  for i := 0 to Items.Count - 1 do
  if Items[i].Caption = aItemName then
  begin
    aGraphItem := TGraphItem(Items.Item[i].SubItems.Objects[3]);     //get file^ien match
    aNum := i;
    aTypeItem := Pieces(aGraphItem.Values, '^', 1, 2);
    break;
  end;
  if aNum = -1 then
  begin
    aItemName := ReverseString(aItemName);
    aItemName := Pieces(aItemName, '(', 2, DelimCount(aItemName, '(') + 1);
    aItemName := Copy(aItemName, 2, length(aItemName) - 1);
    aItemName := ReverseString(aItemName);
    with aListView do
    for i := 0 to Items.Count - 1 do
    if Items[i].Caption = aItemName then            // match without (specimen)
    begin
      aGraphItem := TGraphItem(Items.Item[i].SubItems.Objects[3]);     //get file^ien match
      aNum := i;
      aTypeItem := Pieces(aGraphItem.Values, '^', 1, 2);
      break;
    end;
  end;
end;

procedure TfrmGraphs.chartBaseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  lbutton: boolean;
begin
  FHintStop := true;
  timHintPause.Enabled := false;
  InactivateHint;
  chartDatelineTop.Tag := 0; // not legend or series click
  scrlTop.Hint := '';
  scrlTop.Tag := 0;
  FYMinValue := (Sender as TChart).MinYValue((Sender as TChart).LeftAxis);
  FYMaxValue := (Sender as TChart).MaxYValue((Sender as TChart).LeftAxis);
  pnlTop.Tag := 1;
  if (Sender as TControl).Parent = pnlBottom then pnlTop.Tag := 0;
  if ((Sender as TControl).Parent as TControl) = pnlBottom then pnlTop.Tag := 0;
  if (((Sender as TControl).Parent as TControl).Parent as TControl).Parent = pnlBottom then pnlTop.Tag := 0;
  if pnlTop.Tag = 1 then
  begin
    mnuPopGraphIsolate.Caption := 'Move all selections to bottom';
    mnuPopGraphRemove.Caption := 'Remove all selections from top';
    if memTop.Visible then
      memTop.SetFocus;
  end
  else
  begin
    mnuPopGraphIsolate.Caption := 'Move all selections to top';
    mnuPopGraphRemove.Caption := 'Remove all selections from bottom';
    if memBottom.Visible then
      memBottom.SetFocus;
  end;
  if Button = mbLeft then
    FMouseDown := true;
  lbutton := Button <> mbRight;
  MouseClicks(Sender as TChart, lbutton, X, Y);
end;

procedure TfrmGraphs.MouseClicks(aChart: TChart; lbutton: boolean; X, Y: Integer);
var
  i, tmp: integer;
  aSeries: TChartSeries;
begin
  tmp := -1;
  for i := 0 to aChart.SeriesCount - 1 do
  if aChart.Series[i].Marks.Visible then
  begin
    tmp := aChart.Series[i].Marks.Clicked(X, Y);
    if tmp <> -1 then break;
  end;
  if tmp <> -1 then
  begin
    FOnMark := true;
    aSeries := aChart.Series[i];
    FGraphClick := aChart;
    FGraphSeries := aSeries;
    FGraphValueIndex := tmp;
    chartDateLineTop.Tag := 1;       // indicates a series click
    if (aSeries is TGanttSeries) then
    begin
      FDate1 := (aSeries as TGanttSeries).StartValues[tmp];
      FDate2 := (aSeries as TGanttSeries).EndValues[tmp];
    end
    else
    begin
      FDate1 := aSeries.XValue[tmp];
      FDate2 := FDate1;
    end;
    LabelClicks(aChart, aSeries, lbutton, tmp);
    FMouseDown := false;
    aChart.AllowZoom := false;
  end;
end;

procedure TfrmGraphs.LabelClicks(aChart: TChart; aSeries: TChartSeries; lbutton: boolean; tmp: integer);
var
  firstnon, toggle: boolean;
  i, originalindex: integer;
  dttm, labresult, seriestitle, showing, testname, textvalue, textvalue1, textvalue2, typename, typenum: string;
begin
    seriestitle := Piece(aSeries.Title, '^', 1);
    if seriestitle = '(non-numeric)' then
    begin
      originalindex := strtointdef(Piece(GtslNonNum[tmp], '^', 3), 0);
      seriestitle := Piece(aChart.Series[originalindex].Title, '^', 1);
    end;
    if (seriestitle = TXT_COMMENTS) and lbutton then
    begin
      chartDatelineTop.Tag := 0;
      mnuPopGraphDetailsClick(self);
    end
    else if (seriestitle = TXT_NONNUMERICS) and lbutton then
    begin
      if (aSeries.Identifier = 'serNonNumBottom') or (aSeries.Identifier = 'serNonNumTop') then
      begin
        firstnon := true;
        toggle := false;
        for i := 0 to aChart.SeriesCount - 1 do
        if Piece(aChart.Series[i].Title, '^', 1) = '(non-numeric)' then
        begin
          if firstnon then
          begin
           toggle := not aChart.Series[i].Marks.Visible;
           firstnon := false;
          end;
          aChart.Series[i].Marks.Visible := toggle;
        end;
      end;
    end
    else if lbutton and (seriestitle <> TXT_NONNUMERICS) then
    begin
      textvalue := ValueText(aChart, aSeries, tmp);
      textvalue := StringReplace(textvalue, ' 00:00', '', [rfReplaceAll]);
      dttm := Piece(textvalue, '^', 3);
      typenum := trim(Piece(textvalue, '^', 1));
      typename := Piece(textvalue, '^', 2);
      textvalue1 := typename + '  ' + dttm;
      if typenum = '63' then
      begin
        LabNameResults(textvalue, testname, labresult);
        textvalue2 := testname + '  ' + labresult;
      end
      else
        textvalue2 := Piece(textvalue, '^', 4) + '  ' + Piece(textvalue, '^', 5);
      AllTypeDate(typenum, typename, textvalue1, textvalue2, FDate1, FDate2);
    end
    else if (Piece(aSeries.Title, '^', 1) <> TXT_NONNUMERICS)
        and (Piece(aSeries.Title, '^', 1) <> TXT_COMMENTS) then
    begin
      mnuPopGraphIsolate.Enabled := true;
      if pnlTop.Tag = 1 then
        mnuPopGraphIsolate.Caption := 'Move - ' + seriestitle + ' - from Top to Bottom'
      else
        mnuPopGraphIsolate.Caption := 'Move - ' + seriestitle + ' - from Bottom to Top';
      scrlTop.Hint := 'Details - for ' + seriestitle + ' for ' +
        FormatDateTime('mmm d, yyyy  h:nn am/pm', FDate1);
      scrlTop.Tag := tmp + 1;
      mnuPopGraphIsolate.Hint := seriestitle;
      mnuPopGraphRemove.Enabled := true;
      mnuPopGraphRemove.Caption := 'Remove - ' + seriestitle;
      mnuPopGraphDetails.Caption := 'Details - ' + seriestitle;
      if FGraphSeries.Marks.Visible then showing := ' - turn off' else showing := ' - turn on';
      mnuPopGraphValueMarks.Caption := 'Values - ' + seriestitle + showing;
      mnuPopGraphValueMarks.Enabled := true;
    end;
end;

procedure TfrmGraphs.mnuPopGraphStuffPopup(Sender: TObject);
begin
  if scrlTop.Tag = 0 then scrlTop.Hint := '';
  if (lvwItemsTop.SelCount = 0) and (lvwItemsBottom.SelCount = 0) then scrlTop.Hint := '';
  if scrlTop.Hint = '' then
  begin
    if Pieces(mnuPopGraphIsolate.Caption, ' ', 1, 3) = 'Move all selections' then
      mnuPopGraphIsolate.Enabled := true
    else
    begin
      mnuPopGraphIsolate.Caption := 'Move';
      mnuPopGraphIsolate.Enabled := false;
    end;
    if Pieces(mnuPopGraphRemove.Caption, ' ', 1, 3) = 'Remove all selections' then
      mnuPopGraphRemove.Enabled := true
    else
    begin
      mnuPopGraphRemove.Caption := 'Remove';
      mnuPopGraphRemove.Enabled := false;
    end;
    mnuPopGraphDetails.Caption := 'Details...';
    mnuPopGraphDetails.Enabled := (lvwItemsTop.SelCount > 0) or (lvwItemsBottom.SelCount > 0);
    mnuPopGraphValueMarks.Caption := 'Values - ';
    mnuPopGraphValueMarks.Enabled := false;
  end
  else
  begin
    mnuPopGraphIsolate.Enabled := true;
    mnuPopGraphRemove.Enabled := true;
    mnuPopGraphDetails.Enabled := true;
    if chartDatelineTop.Tag <> -1 then
      mnuPopGraphValueMarks.Enabled := true;
  end;
  {mnuPopGraphViewDefinition.Enabled := (pcTop.ActivePageIndex = 1)
                                    or (pcBottom.ActivePageIndex = 1);}
  mnuPopGraphSwap.Enabled := (lvwItemsTop.SelCount > 0) or (lvwItemsBottom.SelCount > 0);
  mnuPopGraphReset.Enabled := mnuPopGraphSwap.Enabled;
  mnuPopGraphCopy.Enabled := mnuPopGraphSwap.Enabled;
  mnuPopGraphPrint.Enabled := mnuPopGraphSwap.Enabled;

  with pnlMain.Parent do
  if BorderWidth <> 1 then            // only do on float Graph
    mnuPopGraphStayOnTop.Enabled :=false
  else
    mnuPopGraphStayOnTop.Enabled :=true;
end;

procedure TfrmGraphs.mnuPopGraphDetailsClick(Sender: TObject);
var
  tmpList: TStringList;
  date1, date2: TFMDateTime;
  labresult, testname, teststring, textvalue, textvalue1, textvalue2, typeitem, typename, typenum: string;
  selnum: integer;
  aGraphItem: TGraphItem;
  aListView: TListView;
  aListItem: TListItem;
begin
  if chartDatelineTop.Tag = 1 then               // series
  begin
    ItemCheck(lvwItemsTop, mnuPopGraphIsolate.Hint, selnum, typeitem);
    if selnum < 0 then exit;
    if not HSAbbrev(Piece(typeitem, '^', 1)) then
    begin
      if (FGraphSeries is TGanttSeries) then
      begin
        FDate1 := (FGraphSeries as TGanttSeries).StartValues[FGraphValueIndex];
        FDate2 := (FGraphSeries as TGanttSeries).EndValues[FGraphValueIndex];
      end
      else
      begin
        FDate1 := FGraphSeries.XValue[FGraphValueIndex];
        FDate2 := FDate1;
      end;
      textvalue := ValueText(FGraphClick, FGraphSeries, FGraphValueIndex);
      typename := Piece(textvalue, '^', 2);
      typenum := trim(Piece(textvalue, '^', 1));
      textvalue1 := Piece(textvalue, '^', 2) + '  ' + Piece(textvalue, '^', 3);
      if typenum = '63' then
      begin
        LabNameResults(textvalue, testname, labresult);
        textvalue2 := testname + '  ' + labresult;
      end
      else
        textvalue2 := Piece(textvalue, '^', 4) + '  ' + Piece(textvalue, '^', 5);
      AllTypeDate(typenum, typename, textvalue1, textvalue2, FDate1, FDate2);
      exit;
    end
    else
      OneDayTypeDetails(typeitem);
  end
  else            // legend
  begin
    date1 := DateTimeToFMDateTime(FGraphSetting.HighTime);
    date2 := DateTimeToFMDateTime(FGraphSetting.LowTime);
    tmpList := TStringList.Create;
    if pnlTop.Tag = 1 then
      aListView := lvwItemsTop
    else
      aListView := lvwItemsBottom;
    aListItem := aListView.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);      //get file^ien match
      teststring := aGraphItem.Values;
      tmpList.Add(teststring);
      aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
    if tmpList.Count > 0 then
      AllDetails(date1, date2, tmplist);
    tmpList.Free;
  end;
  FMouseDown := false;
  if (Sender is TChart) then
    (Sender as TChart).AllowZoom := false;
end;

procedure TfrmGraphs.AllDetails(aDate1, aDate2: TFMDateTime; aTempList: TStrings);
var
  i: integer;
  detailsok: boolean;
  testnum, teststring, testtype: string;
  ztmpList: TStringList;
  TypeList: TStringList;
begin
  //ShowMsg('This funtionality is currently unavailable.');
  //exit;      // ****************** temporary 11-4-07
  TypeList := TStringList.Create;
   detailsok := true;
  for i := 0 to aTempList.Count -1 do
  begin
    teststring := aTempList[i];
    testtype := Piece(teststring, '^', 1);
    if not HSAbbrev(testtype) then
      detailsok := false;
    if testtype = '63' then
    begin
      testnum := Piece(teststring, '^', 2);
      testnum := Piece(testnum, '.', 1);
      TypeList.Add('63^' + testnum);
    end
    else
      TypeList.Add(teststring);
  end;
  if detailsok then
  begin
    ztmpList := TStringList.Create;
    try
      FastAssign(rpcDetailSelected(Patient.DFN, aDate1, aDate2, TypeList, true), ztmpList);
      NotifyApps(ztmpList);
      ReportBox(ztmpList, 'Graph results on ' + Patient.Name, True);
    finally
      ztmpList.Free;
    end;
  end
  else
    ItemDateRange(FGraphClick);
  TypeList.Free;
end;

procedure TfrmGraphs.OneDayTypeDetails(aTypeItem: string);
var
  strdate1, strdate2, titleitem, titletype: string;
  date1, date2: TFMDateTime;
  tmpList: TStringList;
begin
  tmpList := TStringList.Create;
  strdate1 := FormatDateTime('mm/dd/yyyy', FDate1);
  strdate2 := FormatDateTime('mm/dd/yyyy', FDate2);
  FDate1 := StrToDateTime(strdate1);
  FDate2 := StrToDateTime(strdate2);
  date1 := DateTimeToFMDateTime(FDate1 + 1);
  date2 := DateTimeToFMDateTime(FDate2);
  titletype := FileNameX(Piece(aTypeItem, '^', 1));
  titleitem := ItemName(Piece(aTypeItem, '^', 1), Piece(aTypeItem, '^', 2));
  rpcDetailDay(tmpList, Patient.DFN, date1, date2, aTypeItem, true);
  NotifyApps(tmpList);
  ReportBox(tmpList, titletype + ': ' + titleitem + ' on ' + Patient.Name + ' for ' + FormatFMDateTime('dddddd', date1), True);
  tmpList.Free;
end;

procedure TfrmGraphs.NotifyApps(aList: TStrings);
var
  i: integer;
  aID, aTag, info: string;
begin
  for i := aList.Count - 1 downto 0  do
  begin
    info := aList[i];
    if Piece(info, '^', 1 ) = '~~~' then
    begin
      aList.Delete(i);
      if length(Piece(info, '^', 11)) > 0 then
      begin
        aID := '';
        aTag := 'SUR' + '^';
        //NotifyOtherApps(NAE_REPORT, aTag + aID);
      end;
    end;
  end;
end;

procedure TfrmGraphs.CreatePatientHeader(var HeaderList: TStringList; PageTitle, Warning, DateRange: string);
// this procedure modified from rReports
var
  tmpItem, tmpStr: string;
begin
  if Warning = TXT_INFO then Warning := '  ';
  with HeaderList do
  begin
    Add(' ');
    Add(StringOfChar(' ', (74 - Length(PageTitle)) div 2) + PageTitle);
    Add(' ');
    tmpStr := Patient.Name + '   ' + Patient.SSN;
    tmpItem := tmpStr + StringOfChar(' ', 39 - Length(tmpStr)) + Encounter.LocationName;
    tmpStr := FormatFMDateTime('dddddd', Patient.DOB) + ' (' + IntToStr(Patient.Age) + ')';
    tmpItem := tmpItem + StringOfChar(' ', 74 - (Length(tmpItem) + Length(tmpStr))) + tmpStr;
    Add(tmpItem);
    Add(StringOfChar('=', 74));
    Add(' *** WORK COPY ONLY *** ' + StringOfChar(' ', 24) + 'Printed: '
      + FormatFMDateTime('dddddd  hh:nn', FMNow));
    Add('  ' + TXT_COPY_DISCLAIMER);
    Add(StringOfChar(' ', (74 - Length(DateRange)) div 2) + DateRange);
    Add(StringOfChar(' ', (74 - Length(Warning)) div 2) + Warning);
    Add(' ');
  end;
end;

procedure TfrmGraphs.CreateExcelPatientHeader(var HeaderList: TStringList; PageTitle, Warning, DateRange: string);
// this procedure modified from rReports
var
  tmpItem: string;
begin
  if Warning = TXT_INFO then Warning := '  ';
  with HeaderList do
  begin
    Add(' ');
    Add(PageTitle);
    Add(' ');
    tmpItem := Patient.Name + '         ' + Patient.SSN + '          '
             + Encounter.LocationName + '                            '
             + FormatFMDateTime('dddddd', Patient.DOB) + ' (' + IntToStr(Patient.Age) + ')';
    Add(tmpItem);
    Add(TXT_COPY_DISCLAIMER);
    Add(DateRange);
    Add(Warning);
  end;
end;

procedure TfrmGraphs.GetData(aString: string);
var
  i: integer;
  filenum, itemdata, itemid: string;
  aDate, aDate1: double;
begin
  GtslTemp.Clear;
  itemid := UpperCase(Pieces(aString, '^', 1, 2));
  for i := GtslData.Count - 1 downto 0 do
    if itemid = UpperCase(Pieces(GtslData[i], '^', 1, 2)) then
    begin
      itemdata := GtslData[i];
      filenum := Piece(itemdata, '^', 1);
      if (filenum = '52') or (filenum = '55') or (filenum = '55NVA')
      or (filenum = '9999911') or (filenum = '405') or (filenum = '9000010') then
      begin
        aDate := strtofloat(FMCorrectedDate(Piece(itemdata, '^', 3)));
        aDate1 := strtofloat(FMCorrectedDate(Piece(itemdata, '^', 4)));
        if (aDate < FGraphSetting.FMStopDate) and (aDate > FGraphSetting.FMStartDate) then
          GtslTemp.Add(GtslData[i])
        else if (aDate < FGraphSetting.FMStopDate) and (aDate1 > FGraphSetting.FMStartDate) then
          GtslTemp.Add(GtslData[i])
        else if (aDate < FGraphSetting.FMStartDate) and (aDate1 > FGraphSetting.FMStopDate) then
          GtslTemp.Add(GtslData[i]);
      end
      else if Piece(itemdata, '^', 3) <> '' then
      begin
        aDate := strtofloat(FMCorrectedDate(Piece(itemdata, '^', 3)));
        if (aDate < FGraphSetting.FMStopDate) and (aDate > FGraphSetting.FMStartDate) then
          if Copy(itemdata, 1, 4) = '63MI' then
            GtslTemp.Add(Pieces(GtslData[i], '^', 1, 4))
          else if Copy(itemdata, 1, 4) = '63AP' then
            GtslTemp.Add(Pieces(GtslData[i], '^', 1, 4))
          //else GtslTemp.Add(Pieces(Items[i], '^', 1, 5));         // add in non micro, ap
          else GtslTemp.Add(GtslData[i]);         // add in non micro, ap
      end;
    end;
end;

function TfrmGraphs.FMToDateTime(FMDateTime: string): TDateTime;
var
  Year, x: string;
begin
  { Note: TDateTime cannot store month only or year only dates }
  x := FMDateTime + '0000000';
  if Length(x) > 12 then x := Copy(x, 1, 12);
  if StrToInt(Copy(x, 9, 4)) > 2359 then x := Copy(x, 1, 7) + '.2359';
  Year := IntToStr(17 + StrToInt(Copy(x, 1, 1))) + Copy(x, 2, 2);
  x := Copy(x, 4, 2) + '/' + Copy(x, 6, 2) + '/' + Year + ' ' + Copy(x, 9, 2) + ':' + Copy(x, 11, 2);
  Result := StrToDateTime(x);
end;

function TfrmGraphs.GraphTypeNum(aType: string): integer;
var
  i: integer;
begin
  Result := 4;
  if (aType = '52') or (aType = '55') or (aType = '55NVA') or (aType = '9999911') then
    Result := 8
  else
  for i := 0 to GtslAllTypes.Count - 1 do
    if aType = Piece(GtslAllTypes[i], '^', 1) then
    begin
      Result := strtointdef(Piece(GtslAllTypes[i], '^', 3), 4);
      break;
    end;
end;

function TfrmGraphs.HSAbbrev(aType: string): boolean;
var
  i: integer;
  astring: string;
begin
  Result := false;
  for i := 0 to GtslTypes.Count - 1 do
  begin
    astring := GtslTypes[i];
    if Piece(astring, '^', 1) = aType then
    begin
      Result := length(Piece(astring, '^', 8)) > 0;
      break;
    end;
  end;
end;

procedure TfrmGraphs.TempCheck(typeitem: string; var levelseq: double);
var
  done, previous: boolean;
  j: integer;
begin
  previous := false;
  done := false;
  j := 0;
  while not done do
  begin
    if GtslTempCheck.Count = j then done := true
    else if GtslTempCheck[j] = typeitem then
    begin
      previous := true;
      levelseq := j + 1;
      done := true;
    end
    else j := j + 1;
  end;
  if not previous then
  begin
    GtslTempCheck.Add(UpperCase(typeitem));
    levelseq := GtslTempCheck.Count;
  end;
end;

function TfrmGraphs.DCName(aDCien: string): string;
var
  i: integer;
begin
  if GtslDrugClass.Count < 1 then
    FastAssign(rpcClass('50.605'), GtslDrugClass);
  Result := '';
  for i := 0 to GtslDrugClass.Count - 1 do
    if Piece(GtslDrugClass[i], '^', 2) = aDCien then
    begin
      Result := 'Drug - ' + Piece(GtslDrugClass[i], '^', 3);
      break;
    end;
end;

procedure TfrmGraphs.splItemsBottomMoved(Sender: TObject);
begin
 chkItemsBottom.Left := pnlItemsBottom.Width - chkItemsBottom.Width - 2;
 pnlItemsTop.Width := pnlItemsBottom.Width;
 chkItemsTop.Left := pnlItemsTop.Width - chkItemsTop.Width - 2;
end;

procedure TfrmGraphs.splItemsTopMoved(Sender: TObject);
begin
 chkItemsTop.Left := pnlItemsTop.Width - chkItemsTop.Width - 2;
 pnlItemsBottom.Width := pnlItemsTop.Width;
 chkItemsBottom.Left := pnlItemsBottom.Width - chkItemsBottom.Width - 2;
end;

procedure TfrmGraphs.splViewsTopMoved(Sender: TObject);
begin
  mnuPopGraphViewDefinition.Checked := (memViewsTop.Height > 5)
                                    or (memViewsBottom.Height > 5);
end;

procedure TfrmGraphs.cboDateRangeChange(Sender: TObject);
var
  dateranges: string;
begin
  SelCopy(lvwItemsTop, GtslSelCopyTop);
  SelCopy(lvwItemsBottom, GtslSelCopyBottom);
  dateranges := '';
  if (cboDateRange.ItemID = 'S') then
  begin
    with calDateRange do
    begin
      if Execute then
        if Length(TextOfStart) > 0 then
          if Length(TextOfStop) > 0 then
          begin
            dateranges :=
              '^' + UpperCase(TextOfStart) + ' to ' + UpperCase(TextOfStop) +
              '^^^' + RelativeStart + ';' + RelativeStop +
              '^' + floattostr(FMDateStart) + '^' + floattostr(FMDateStop);
            cboDateRange.Items.Append(dateranges);
            cboDateRange.ItemIndex := cboDateRange.Items.Count - 1;
          end
          else
            cboDateRange.ItemIndex := -1
        else
          cboDateRange.ItemIndex := -1
      else
        cboDateRange.ItemIndex := -1;
    end;
  end;
  HideGraphs(true);
  DateSteps(dateranges);
  uDateStart := FGraphSetting.FMStartDate;
  uDateStop  := FGraphSetting.FMStopDate;
  FilterListView(FGraphSetting.FMStartDate, FGraphSetting.FMStopDate);
  SelReset(GtslSelCopyTop, lvwItemsTop);
  SelReset(GtslSelCopyBottom, lvwItemsBottom);
  DisplayData('top');
  DisplayData('bottom');
  if lstViewsTop.ItemIndex > 1 then lstViewsTopChange(self);
  if lstViewsBottom.ItemIndex > 1 then lstViewsBottomChange(self);
  HideGraphs(false);
end;

procedure TfrmGraphs.DateSteps(dateranges: string);
var
  datetag: integer;
  endofday: double;
  manualstart, manualstop: string;
begin
  endofday := FMDateTimeOffsetBy(FMToday, 1);
  datetag := cboDateRange.ItemIEN;
  FGraphSetting.FMStopDate := endofday;
  with FGraphSetting do
  case datetag of
  0:  begin
        if cboDateRange.ItemIndex > 7 then    // selected date range
        begin
          if dateranges = '' then dateranges := cboDateRange.Items[cboDateRange.ItemIndex];
          manualstart := Piece(dateranges, '^' , 6);
          manualstop := Piece(dateranges, '^' , 7);
          if (manualstop <> '') and (length(Piece(manualstop, '.', 2)) = 0) then
            manualstop := manualstop + '.2359';
          FMStartDate := MakeFMDateTime(manualstart);
          FMStopDate := MakeFMDateTime(manualstop);
          if (manualstart <> '') and (length(Piece(manualstart, '.', 2)) = 0) then
          begin
            FMStartDate := FMDateTimeOffsetBy(FMStartDate, -1);
            manualstart := floattostr(FMStartDate) + '.2359';
            FMStartDate := MakeFMDateTime(manualstart);
          end;
        end;
      end;
  1:  FMStartDate := FMToday;
  2:  FMStartDate := FMDateTimeOffsetBy(FMToday, -7);
  3:  FMStartDate := FMDateTimeOffsetBy(FMToday, -30);
  4:  FMStartDate := FMDateTimeOffsetBy(FMToday, -183);
  5:  FMStartDate := FMDateTimeOffsetBy(FMToday, -365);
  6:  FMStartDate := FMDateTimeOffsetBy(FMToday, -730);
  7:  FMStartDate := FM_START_DATE;   // earliest recorded values

  else
      begin
        if dateranges = '' then dateranges := cboDateRange.Items[cboDateRange.ItemIndex];
        manualstart := Piece(dateranges, '^' , 6);
        manualstop := Piece(dateranges, '^' , 7);
        if (manualstop <> '') and (length(Piece(manualstop, '.', 2)) = 0) then manualstop := manualstop + '.2359';
        FMStartDate := MakeFMDateTime(manualstart);
        FMStopDate := MakeFMDateTime(manualstop);
        if (manualstart <> '') and (length(Piece(manualstart, '.', 2)) = 0) then
        begin
          FMStartDate := FMDateTimeOffsetBy(FMStartDate, -1);
          manualstart := floattostr(FMStartDate) + '.2359';
          FMStartDate := MakeFMDateTime(manualstart);
        end;
      end;
  end;
end;

function TfrmGraphs.StdDev(value, high, low: double): double;
begin
  if high - low <> 0 then
  begin
    Result := (value - (low + ((high - low) / 2)))/((high - low) / 4);
    Result := RoundTo(Result, -2);
  end
  else
    Result := 0;
end;

function TfrmGraphs.InvVal(value: double): double;
begin
  if value = 0 then value := 0.0001;
  Result := 1 / value;
  Result := RoundTo(Result, -2);
end;

procedure TfrmGraphs.lvwItemsTopCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if not(Sender is TListView) then exit;
  if FsortAscending then
  begin
    if FSortCol = 0 then
      Compare := CompareStr(Item1.Caption, Item2.Caption)
    else
      Compare := CompareStr(Item1.SubItems[FsortCol - 1],
        Item2.SubItems[FsortCol - 1]);
  end
  else
  begin
    if FSortCol = 0 then
      Compare := CompareStr(Item2.Caption, Item1.Caption)
    else
      Compare := CompareStr(Item2.SubItems[FsortCol - 1],
        Item1.SubItems[FsortCol - 1]);
  end;
end;

procedure TfrmGraphs.lvwItemsTopColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FSortCol = Column.Index then
    FSortAscending := not FSortAscending
  else
    FSortAscending := true;
  FSortCol := Column.Index;
  (Sender as TListView).AlphaSort;
end;

procedure TfrmGraphs.lvwItemsBottomCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if not(Sender is TListView) then exit;
  if FBSortAscending then
  begin
    if FBSortCol = 0 then
      Compare := CompareStr(Item1.Caption, Item2.Caption)
    else
      Compare := CompareStr(Item1.SubItems[FBSortCol - 1],
        Item2.SubItems[FBSortCol - 1]);
  end
  else
  begin
    if FBSortCol = 0 then
      Compare := CompareStr(Item2.Caption, Item1.Caption)
    else
      Compare := CompareStr(Item2.SubItems[FBSortCol - 1],
        Item1.SubItems[FBSortCol - 1]);
  end;
end;

procedure TfrmGraphs.lvwItemsBottomColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FBSortCol = Column.Index then
    FBSortAscending := not FBSortAscending
  else
    FBSortAscending := true;
  FBSortCol := Column.Index;
  (Sender as TListView).AlphaSort;
end;

procedure TfrmGraphs.btnGraphSelectionsClick(Sender: TObject);
var
  actionOK, checkaction: boolean;
  counter: integer;
  profile, profilestring, section, selections, seltext, specnum, typeitem: string;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  selections := '';
  seltext := '';
  aListItem := lvwItemsTop.Selected;
  while aListItem <> nil do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    typeitem := UpperCase(aGraphItem.Values);
    if Piece(typeitem, '^', 1) = '63' then
    begin
      specnum := Piece(Piece(typeitem, '^', 2), '.', 2);
      if length(specnum) > 0 then  // multispecimen
        if (specnum = '1') or (specnum = '0') then typeitem := Piece(typeitem, '.', 1)
        else typeitem := '';
    end;
    if length(typeitem) > 0 then
      selections := selections + Piece(typeitem, '^', 1) + '~' + Piece(typeitem, '^', 2) + '~|';
    aListItem := lvwItemsTop.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  checkaction := false;
  actionOK := false;
  profile := '*';
  counter := lstViewsTop.Tag;           // unclear on use of actual count ??
  if counter = BIG_NUMBER then
    counter := lstViewsBottom.Tag;
  DialogGraphProfiles(actionOK, checkaction, FGraphSetting,
    profile, profilestring, section, Patient.DFN, counter, true, selections);
  if (not actionOK) then exit;
  if (section = 'neither') then exit;
  FillViews;
  if (section = 'bottom') or (section = 'both') then
  begin
    lstViewsBottom.Tag := counter;
    lvwItemsBottom.Tag := counter;
  end;
  if (section = 'top') or (section = 'both') then
  begin
    lstViewsTop.Tag := counter;
    lvwItemsTop.Tag  := counter;
  end;
  ViewSelections;
end;

procedure TfrmGraphs.DisplayFreeText(aChart: TChart);
var
  i: integer;
begin
  for i := 0 to aChart.SeriesCount - 1 do
    if (Piece(aChart.Series[i].Title, '^', 1) = '(non-numeric)') then
      aChart.Series[i].Marks.Visible := true;
end;

procedure TfrmGraphs.ViewSelections;
var
  i: integer;
begin    // uses lvwItems... Tag as index for view selection
  with lvwItemsBottom do
  begin
    if (Tag = 0) and (length(lvwItemsBottom.Hint) > 0) then
    begin
      for i := 0 to lstViewsBottom.Items.Count - 1 do
      begin
        ShowMsg(lstViewsBottom.Items[i]);
        if lvwItemsBottom.Hint = Piece(lstViewsBottom.Items[i], '^', 2) then
        begin
          Tag := i;
          break;
        end;
      end;
    end;
    if Tag > 0 then
    begin
      if not chkDualViews.Checked then
      begin
        chkDualViews.Checked := true;
        chkDualViewsClick(self);
      end;
      ClearSelection;
      lstViewsBottom.ItemIndex := Tag;
      Tag := 0;
      Hint := '';
      lstViewsBottomChange(lstViewsBottom);
    end;
  end;
  with lvwItemsTop do
  begin
    if (Tag = 0) and (length(lvwItemsTop.Hint) > 0) then
      for i := 0 to lstViewsTop.Items.Count - 1 do
        if lvwItemsTop.Hint = Piece(lstViewsTop.Items[i], '^', 2) then
        begin
          Tag := i;
          break;
        end;
    if Tag > 0 then
    begin
      ClearSelection;
      lstViewsTop.ItemIndex := Tag;
      Tag := 0;
      Hint := '';
      lstViewsTopChange(lstViewsTop);
    end;
  end;
end;

// when using Reports graph and Float graph, multispec lab tests need to update correctly
procedure TfrmGraphs.CheckExpandedLabs(aListView: TListView);
var
  flag: boolean;
  i, j: integer;
  multicheck, testcheck, typeitem: string;
  aList: TStrings;
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  flag := false;     // check if need to convert lab tests
  aListItem := aListView.Selected;
  while (aListItem <> nil) and (flag = false) do
  begin
    aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
    typeitem := UpperCase(Pieces(aGraphItem.Values, '^', 1, 2));
    if Piece(typeitem, '^', 1) = '63' then
      if length(Piece(typeitem, '.', 2)) = 0 then
      for j := 0 to GtslCheck.Count - 1 do
      begin
        testcheck := GtslCheck[j];
        if Pieces(testcheck, '^', 1, 2) = typeitem then
          if Piece(testcheck, '^', 3) = '*' then
          begin
            flag := true;
            break;
          end;
      end;
    aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
  end;
  if flag then
  begin
    // copy selected tests - multiples with #.0, #.#
    aList := TStringList.Create;
    aListItem := aListView.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := UpperCase(Pieces(aGraphItem.Values, '^', 1, 2));
      if Piece(typeitem, '^', 1) = '63' then
      begin
        if length(Piece(typeitem, '.', 2)) = 0 then
        begin
          for i := 0 to GtslCheck.Count - 1 do
          begin
            testcheck := GtslCheck[i];
            if Pieces(testcheck, '^', 1, 2) = typeitem then
              if Piece(testcheck, '^', 3) = '*' then
              begin
                if FGraphSetting.MergeLabs then
                begin
                  aList.Add(typeitem + '.0');
                end
                else
                begin
                  for j := 0 to GtslCheck.Count - 1 do
                  begin
                    multicheck := GtslCheck[j];
                    if Piece(multicheck, '.', 1) = typeitem then
                      if Piece(multicheck, '.', 2) <> '0' then
                      begin
                        aList.Add(multicheck);  // add split lab tests
                      end;
                  end;
                end;
                break;
              end
              else
                aList.Add(typeitem);  // add merged lab tests
          end;
        end
        else
          aList.Add(typeitem);  // add regular lab tests
      end
      else
        aList.Add(typeitem);  // add non lab items
      aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
    end;

    cboDateRangeChange(self);     // update all tests

    // put back selections    (do not need to update other listview)
    for i := aListView.Items.Count - 1 downto 0 do
    begin
      aListItem := aListView.Items[i];
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);
      typeitem := UpperCase(Pieces(aGraphItem.Values, '^', 1, 2));
      for j := 0 to aList.Count - 1 do
      begin
        if typeitem = aList[j] then
        begin
          aListView.Items[i].Selected := true;
          break;
        end;
      end;
    end;
    FreeAndNil(aList);
  end;
end;

procedure TfrmGraphs.ItemsClick(Sender: TObject; aListView, aOtherListView: TListView;
  aCheckBox: TCheckBox; aListBox: TORListBox; aList: TStrings; aSection: string);
begin
  FRetainZoom := (GtslZoomHistoryFloat.Count > 0);
  FWarning := false;
  Screen.Cursor := crHourGlass;
  if aListView.SelCount > 0 then
    CheckExpandedLabs(aListView);
  HideGraphs(true);
  if Sender = aListView then
  begin
    aListBox.Tag := BIG_NUMBER;                   // avoids recurssion
    aListBox.ItemIndex := -1;
    aListBox.ClearSelection;
  end;
  if (Sender is TListView) then           // clear out selcopy list
    aList.Clear;
  if aOtherListView.SelCount < 1 then
  begin
    FGraphSetting.HighTime := 0;
    FGraphSetting.LowTime := BIG_NUMBER;
  end
  else if (FBHighTime <> 0) and (aSection = 'top') then
  begin
    if FBHighTime < FTHighTime then FGraphSetting.HighTime := FBHighTime;
    if FBLowTime > FTLowTime then FGraphSetting.LowTime := FBLowTime;
  end
  else if (FTHighTime <> 0) and (aSection = 'bottom') then
  begin
    if FTHighTime < FBHighTime then FGraphSetting.HighTime := FTHighTime;
    if FTLowTime > FBLowTime then FGraphSetting.LowTime := FTLowTime;
  end;
  if aSection = 'top' then
  begin
    FTHighTime := 0;
    FTLowTime := BIG_NUMBER;
  end
  else if aSection = 'bottom' then
  begin
    FBHighTime := 0;
    FBLowTime := BIG_NUMBER;
  end;
  CheckToAddData(aListView, aSection, 'SELECT');
  DisplayData(aSection);
  if (aListView.SelCount = 1) and (aOtherListView.SelCount = 0) then
  begin
    GtslZoomHistoryFloat.Clear;
    FRetainZoom := false;
    mnuPopGraphZoomBack.Enabled := false;
  end
  else if FRetainZoom and (GtslZoomHistoryFloat.Count > 0) then
    ZoomUpdate;
  HideGraphs(false);
  if FWarning then
    FWarning := false;
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.CheckToAddData(aListView: TListView; aSection, TypeToCheck: string);
var
  done, ok, previous, singletype: boolean;
  i, j: integer;
  itemname, typeitem: string;
  aGraphItem: TGraphItem;
begin
  if FFastTrack then
    exit;
  Application.ProcessMessages;
  TypeToCheck := UpperCase(TypeToCheck);
  if (TypeToCheck = 'SELECT') and (lvwItemsTop.SelCount = 0)
    and (lvwItemsBottom.SelCount = 0) then exit;
  singletype := length(Piece(TypeToCheck, '^', 2)) = 0;
  for i := 0 to aListView.Items.Count - 1 do
  begin
    ok := false;
    if (TypeToCheck = 'ALL') then ok := true;
    if (TypeToCheck = 'SELECT') and aListView.Items[i].Selected then ok := true;
    aGraphItem := TGraphItem(aListView.Items.Item[i].SubItems.Objects[3]);
    typeitem := UpperCase(Pieces(aGraphItem.Values, '^', 1, 2));
    if not ok then
      if TypeToCheck = typeitem then ok := true
      else if (TypeToCheck = Piece(typeitem, '^', 1)) and
        singletype then ok := true;
    if ok then
    begin
      previous := false;
      done := false;
      j := 0;
      while not done do
      begin
        if GtslCheck.Count = j then done := true
        else if Pieces(GtslCheck[j], '^', 1, 2) = typeitem then
        begin
          previous := true;
          done := true;
        end
        else j := j + 1;
      end;
      if not previous then
      begin
        GtslCheck.Add(typeitem);
        itemname := aListView.Items[i].Caption;
        if Piece(typeitem, '^', 1) = '63' then
          LabData(typeitem, itemname, aSection, true) // need to get lab data
        else
          FastAddStrings(rpcGetItemData(typeitem, FMTimeStamp, Patient.DFN), GtslData);
      end;
    end;
  end;
end;

procedure TfrmGraphs.lvwItemsBottomClick(Sender: TObject);
var
  i: integer;
begin
  FFirstClick := true;
  if not FFastTrack then
    if GraphTurboOn then
      Switch;
  if lvwItemsBottom.SelCount > FGraphSetting.MaxSelect then
  begin
    pnlItemsBottomInfo.Tag := 1;
    lvwItemsBottom.ClearSelection;
    ShowMsg('Too many items to graph');
    for i := 0 to GtslSelPrevBottomFloat.Count - 1 do
      lvwItemsBottom.Items[strtoint(GtslSelPrevBottomFloat[i])].Selected := true;
    pnlItemsBottomInfo.Tag := 0;
  end
  else
  begin
    GtslSelPrevBottomFloat.Clear;
    for i := 0 to lvwItemsBottom.Items.Count - 1 do
    if lvwItemsBottom.Items[i].Selected then
      GtslSelPrevBottomFloat.Add(inttostr(i));
    ItemsClick(Sender, lvwItemsBottom, lvwItemsTop, chkItemsBottom, lstViewsBottom, GtslSelCopyBottom, 'bottom');
  end;
end;

procedure TfrmGraphs.SelCopy(aListView: TListView; aList: TStrings);
var
  aGraphItem: TGraphItem;
  aListItem: TListItem;
begin
  if aListView.Items.Count > 0 then
  begin
    aListItem := aListView.Selected;
    while aListItem <> nil do
    begin
      aGraphItem := TGraphItem(aListItem.SubItems.Objects[3]);    //get file^ien match
      aList.Add(aGraphItem.Values);
      aListItem := aListView.GetNextItem(aListItem, sdAll, [isSelected]);
    end;
  end;
end;

procedure TfrmGraphs.SelReset(aList: TStrings; aListView: TListView);
var
  i, j: integer;
  itemtype, typeitem, typenum: string;
  aGraphItem: TGraphItem;
begin
  for i := 0 to aListView.Items.Count - 1 do
  begin
    aGraphItem := TGraphItem(aListView.Items.Item[i].SubItems.Objects[3]);    //get file^ien match
    typeitem := UpperCase(Pieces(aGraphItem.Values, '^', 1, 3));
    typenum := Piece(typeitem, '^', 1);
    for j := 0 to aList.Count - 1 do
    begin
      itemtype := UpperCase(Pieces(aList[j], '^', 1, 3));
      if itemtype = typeitem then
      begin
        aListView.Items[i].Selected := true;
        break;
      end;
      if typenum = '63' then
        if Piece(itemtype, '.', 1) = Piece(typeitem, '.', 1) then
        begin
          aListView.Items[i].Selected := true;
          break;
        end;
    end
  end;
end;

procedure TfrmGraphs.ViewsChange(aListView: TListView; aListBox: TORListBox; aSection: string);
var
  Updated: boolean;
  aProfile: string;
begin
  timHintPause.Enabled := false;
  InactivateHint;
  if aListBox.ItemIndex = -1 then exit;  // or clear graph  ***************************
  if aListBox.Tag = BIG_NUMBER then            // avoids recurssion
    exit;
  if pos(LLS_FRONT, aListBox.Items[aListBox.ItemIndex]) > 0 then  // <clear all selections>
  begin
    if aListBox.Tag = BIG_NUMBER then            // avoids recurssion
      exit;
    aListView.ClearSelection;
    if aSection = 'top' then
    begin
      FTHighTime := 0;
      FTLowTime := BIG_NUMBER;
      memViewsTop.Lines.Clear;
      memViewsTop.Lines[0] := TXT_VIEW_DEFINITION;
    end
    else
    begin
      FBHighTime := 0;
      FBLowTime := BIG_NUMBER;
      memViewsBottom.Lines.Clear;
      memViewsBottom.Lines[0] := TXT_VIEW_DEFINITION;
    end;
    DisplayData(aSection);
    aListBox.Tag := 0;                     // reset
    exit;
  end;
  aListView.ClearSelection;
  Updated := false;
  aProfile := aListBox.Items[aListBox.ItemIndex];
  if (length(Piece(aProfile, '^', 3)) = 0) or (length(Piece(aProfile, '^', 1)) = 0) or
     (Piece(aProfile, '^', 1) = VIEW_LABS) then        //or <custom>
    CheckProfile(aProfile, Updated);
  if Updated then
    cboDateRangeChange(self);
  if aSection = 'top' then
  begin
    ViewDefinition(aProfile, memViewsTop);
    AssignProfile(aProfile, 'top');
    if not FItemsSortedTop then
      lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[0]);
    if FGraphSetting.SortColumn > 0 then
      lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[FGraphSetting.SortColumn]);
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[2]);
    lvwItemsTopColumnClick(lvwItemsTop, lvwItemsTop.Column[2]);
    FItemsSortedTop := false;
  end
  else
  begin
    ViewDefinition(aProfile, memViewsBottom);
    AssignProfile(aProfile, 'bottom');
    if not FItemsSortedBottom then
      lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[0]);
    if FGraphSetting.SortColumn > 0 then
      lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[FGraphSetting.SortColumn]);
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[2]);
    lvwItemsBottomColumnClick(lvwItemsBottom, lvwItemsBottom.Column[2]);
    FItemsSortedBottom := false;
  end;
  aListView.ClearSelection;
  AutoSelect(aListView);
  DisplayData(aSection);
end;

procedure TfrmGraphs.AssignProfile(aProfile, aSection: string);
var
  profilename: string;
begin
  profilename := Piece(aProfile, '^', 2);
  aProfile := UpperCase(Piece(aProfile, '^', 3));
  if length(aProfile) = 0 then exit;
  if aSection = 'top' then
    SetProfile(aProfile, profilename, lvwItemsTop)
  else
    SetProfile(aProfile, profilename, lvwItemsBottom);
end;

procedure TfrmGraphs.SetProfile(aProfile, aName: string; aListView: TListView);
var
  i: integer;
  itemstring: string;
  aGraphItem: TGraphItem;
begin
  aListView.Items.BeginUpdate;
  if aProfile = '0' then
    for i := 0 to aListView.Items.Count - 1 do
      aListView.Items[i].SubItems[1] := ''
  else
    for i := 0 to aListView.Items.Count - 1 do
    begin
      aGraphItem := TGraphItem(aListView.Items.Item[i].SubItems.Objects[3]);   //get file^ien match
      itemstring := aGraphItem.Values;
      aListView.Items[i].SubItems[1] := ProfileName(aProfile, aName, itemstring);
    end;
  aListView.Items.EndUpdate;
end;

function TfrmGraphs.ProfileName(aProfile, aName, aString: string): string;
var
  j: integer;
  dcnm, itemdrugclass, itemnums, itempart, itempart1, itempart2: string;
  itemstring1, itemstringnums: string;
begin
  Result := '';
  itemstring1 := UpperCase(Piece(aString, '^', 1));
  itemdrugclass := Piece(aString, '^', 6);
  itemstringnums := UpperCase(Pieces(aString, '^', 1, 2));
  for j := 1 to BIG_NUMBER do
  begin
    itempart := Piece(aProfile, '|', j);
    if itempart = '' then
      break;
    itempart1 := Piece(itempart, '~', 1);
    itempart2 := Piece(itempart, '~', 2);
    itemnums := itempart1 + '^' + itempart2;
    if (itempart1 = '50.605') and (length(itemdrugclass) > 0) then
    begin
      dcnm := DCName(itempart2);
      if dcnm = itemdrugclass then
      begin
        Result := aName;
        break;
      end;
    end
    else if itempart1 = '63' then
    begin
      if itemnums = Piece(itemstringnums, '.', 1) then
      begin
        Result := aName;
        break;
      end;
    end
    else
    begin
      if itemnums = itemstringnums then
      begin
        Result := aName;
        break;
      end;
    end;
    if (itempart1 = '0') and (itempart2 = itemstring1) then
    begin
      Result := aName;
      break;
    end
    else if (itempart1 = '0') and (length(Piece(itempart2, ';', 2)) > 0) then    // subtypes
    if copy(itempart2, 1, length(itemstring1)) = Piece(itempart2, ';', 1) then
    if Piece(itempart2, ';', 2) = UpperCase(Piece(Piece(aString, '^', 2), ';', 2)) then
    begin
      Result := aName;
      break;
    end;
  end;
end;

procedure TfrmGraphs.ViewDefinition(profile: string; amemo: TRichEdit);
var
  i, defnum: integer;
  vdef, vlist, vname, vnum, vtype: string;
begin
  vtype := Piece(profile, '^', 1);
  defnum := strtointdef(vtype, BIG_NUMBER);
  vname := Piece(profile, '^', 2);
  case defnum of
    -1:  vdef := 'Personal View';
    -2:  vdef := 'Public View';
    -3:  vdef := 'Lab Group';
    else vdef := 'Temporary View';
  end;
  amemo.Clear;
  amemo.Lines.Add(vname + ' [' + vdef + ']:');
  if vdef = 'Temporary View' then
  begin
    for i := 4 to BIG_NUMBER do
    begin
      vlist := Piece(profile, '^', i);
      if vlist = '' then break;
      amemo.Lines.Add('  ' + vlist);
    end;
  end
  else
  begin
    vnum := '';
    for i := 0 to GtslAllViews.Count - 1 do
    begin
      vlist := GtslAllViews[i];
      if Piece(vlist, '^', 4) = vname then
        if Piece(vlist, '^', 1) = vtype then
          if Piece(vlist, '^', 2) = 'V' then
            vnum := Piece(vlist, '^', 3);
      if vnum <> '' then
        if Piece(vlist, '^', 2) = 'C' then
           if Piece(vlist, '^', 3) = vnum then
             amemo.Lines.Add('   ' + Piece(vlist, '^', 4));
    end;
  end;
end;

function TfrmGraphs.ExpandTax(profile: string): string;
var
  i: integer;
  itempart, itempart1, itempart2, newprofile: string;
  expandedcodes: TStrings;
  taxonomies: TStrings;
  taxonomycodes: TStrings;
begin    //  '811.2~123~|0~63~|' or '55~12~|0~811.2~|0~63~|'
  Result := profile;
  if Pos('811.2~', profile) = 0 then exit;
  taxonomies := TStringList.Create;
  expandedcodes := TStringList.Create;
  taxonomycodes := TStringList.Create;
  newprofile := '';
  for i := 1 to BIG_NUMBER do
  begin
    itempart := Piece(profile, '|', i);
    if length(itempart) = 0 then break;
    if Pos('811.2~', itempart) = 0 then
      newprofile := newprofile + '|'
    else
      taxonomies.Add(itempart);
  end;
  for i := 0 to taxonomies.Count -1 do
  begin
    itempart := taxonomies[i];
    if (Piece(itempart, '~', 1) = '0') and (Piece(itempart, '~', 2) = '811.2') then
    begin
      // this is Reminder Taxonomy <any> and would bring back a ton of codes
      //FastAssign(rpcTaxonomy(true, nil), expandedcodes);
      break;
    end
    else if Piece(itempart, '~', 1) = '811.2' then
      taxonomycodes.Add(Piece(itempart, '~', 2));
  end;
  if taxonomycodes.Count > 0 then
    FastAssign(rpcTaxonomy(false, taxonomycodes), expandedcodes);
  for i := 1 to expandedcodes.Count -1 do
  begin
    itempart := expandedcodes[i];
    itempart1 := Piece(itempart, ';', 1);
    itempart2 := Piece(itempart, ';', 2);
    newprofile := newprofile + itempart1 + '~' + itempart2 + '~|'
  end;
  FreeAndNil(taxonomies);
  FreeAndNil(expandedcodes);
  FreeAndNil(taxonomycodes);
  Result := newprofile;
end;

procedure TfrmGraphs.CheckProfile(var aProfile: string; var Updated: boolean);
var
  i, j: integer;
  itempart, itempart1, itempart2, profile, profilename, profiletype, xprofile: string;
begin
  Application.ProcessMessages;
  profiletype := Piece(aProfile, '^', 1);
  profilename := Piece(aProfile, '^', 2);
  if profiletype = VIEW_PUBLIC then
    FastAssign(GetGraphProfiles(UpperCase(profilename), '1', 0, 0), GtslTemp)
  else if profiletype = VIEW_PERSONAL then
    FastAssign(GetGraphProfiles(UpperCase(profilename), '0', 0, User.DUZ), GtslTemp)
  else if profiletype = VIEW_LABS then
  begin
    FastAssign(GetATestGroup(strtoint(Piece(aProfile, '^', 3)), strtoint(Piece(aProfile, '^', 4))), GtslTemp);
    aProfile := VIEW_LABS + '^' + Piece(aProfile, '^', 2) + '^';
    for i := 0 to GtslTemp.Count - 1 do
      aProfile := aProfile + '63~' + Piece(GtslTemp[i], '^', 1) + '~|';
    GtslTemp.Clear;
  end;
  if profiletype <> '' then
  begin
    for i := 0 to GtslTemp.Count - 1 do
      aProfile := aProfile + GtslTemp[i];
    GtslTemp.Clear;
  end;
  Updated := false;
  profile := UpperCase(Piece(aProfile, '^', 3));
  xprofile := ExpandTax(profile);
  if xprofile <> profile then
  begin                                         // taxonomies
    profile := xprofile;
    LoadDisplayCheck('45DX', Updated);
    LoadDisplayCheck('45OP', Updated);
    LoadDisplayCheck('9000010.07', Updated);
    LoadDisplayCheck('9000010.18', Updated);
    LoadDisplayCheck('9000011', Updated);
    //LoadDisplayCheck('9999911', Updated);   // problems as durations not being used
  end;
  aProfile := Pieces(aProfile, '^', 1, 2) + '^' + profile;
  for j := 1 to BIG_NUMBER do
  begin
    itempart := Piece(profile, '|', j);
    if itempart = '' then break;
    itempart1 := Piece(itempart, '~', 1);
    itempart2 := Piece(itempart, '~', 2);
    if itempart1 = '0' then                      // <any> type
      LoadDisplayCheck(itempart2, Updated)
    else if itempart1 = '50.605' then            // drug class
    begin
      LoadDisplayCheck('52', Updated);
      LoadDisplayCheck('55', Updated);
      LoadDisplayCheck('55NVA', Updated);
      LoadDisplayCheck('53.79', Updated);
    end
    else if itempart1 <> '0' then                // all others
      LoadDisplayCheck(itempart1, Updated);
  end;
end;

procedure TfrmGraphs.LoadDisplayCheck(typeofitem: string; var Updated: boolean);
begin
  if FFastTrack then
  begin
    exit;
  end;
  if not TypeIsLoaded(typeofitem) then
  begin
    LoadType(typeofitem, '1');
    Updated := true;
  end;
  if not TypeIsDisplayed(typeofitem) then
  begin
    DisplayType(typeofitem, '1');
    Updated := true;
  end;
end;

procedure TfrmGraphs.AutoSelect(aListView: TListView);
var
  counter, i: integer;
begin
  counter := 0;
  for i := 0 to aListView.Items.Count - 1 do
  begin
    if length(aListView.Items[i].SubItems[1]) > 0 then
      counter := counter + 1;
  end;
  if counter <= FGraphSetting.MaxSelect then
    for i := 0 to aListView.Items.Count - 1 do
    begin
      if length(aListView.Items[i].SubItems[1]) > 0 then
        aListView.Items[i].Selected := true;
    end
  else
  begin
    if aListView = lvwItemsTop then
      lvwItemsTop.ClearSelection
    else if aListView = lvwItemsBottom then
      lvwItemsBottom.ClearSelection;
  end;
  if aListView = lvwItemsTop then
    lvwItemsTopClick(self)
  else if aListView = lvwItemsBottom then
    lvwItemsBottomClick(self);
end;

procedure TfrmGraphs.LabAdd(aListView: TListView; filename: string; aIndex, oldlisting: integer; selectlab: boolean);
var
  aGraphItem: TGraphItem;
  aListItem: TListItem;
  newlab, newlabtest, newmult: string;
begin
  newlab := GtslMultiSpec[aIndex];
  newlabtest := Piece(newlab, '^', 2);
  newmult := Piece(newlabtest, '.', 2);
  if length(newmult) > 0 then
  begin
    if (newmult <> '0') and FGraphSetting.MergeLabs then exit;
    if (newmult = '0') and not FGraphSetting.MergeLabs then exit;
  end;
  aListItem := aListView.Items.Insert(oldlisting);
  aListItem.Caption := Piece(newlab, '^', 4);
  aListItem.SubItems.Add(filename);
  aListItem.SubItems.Add('');
  aListItem.SubItems.Add(Piece(newlab, '^', 8));
  aGraphItem := TGraphItem.Create;
  aGraphItem.Values := newlab;
  aListItem.SubItems.AddObject('', aGraphItem);
  if selectlab then
    if not FFastLabs then
      if not FPointClick then    // do not select test if expanding data from a point click
        aListView.Items[oldlisting].Selected := true;
end;

procedure TfrmGraphs.LabCheck(aListView: TListView; aItemType: string; var oldlisting: integer);
var
  i: integer;
  checkitem: string;
  aGraphItem: TGraphItem;
begin
  oldlisting := 0;
  aListView.SortType := stNone;    // avoids out of bounds error
  for i := 0 to aListView.Items.Count - 1 do
  begin
    aGraphItem := TGraphItem(aListView.Items.Item[i].SubItems.Objects[3]);   //get file^ien match
    checkitem := Pieces(aGraphItem.Values, '^', 1, 2);
    if aItemType = checkitem then
    begin
      oldlisting := i;
      aListView.Items.Delete(i);
      break;
    end;
  end;
end;

procedure TfrmGraphs.LabData(aItemType, aItemName, aSection: string; getdata: boolean);
var
  selectlab, singlespec: boolean;
  i, j, oldlisting: integer;
  checktest, checktypeitem, filename, newline, newtest: string;
begin
  if getdata then
    FastAssign(rpcGetItemData(aItemType, FMTimeStamp, Patient.DFN), GtslScratchLab);
  SpecRefCheck(aItemType, aItemName, singlespec);
  if singlespec then
    FastAddStrings(GtslScratchLab, GtslData)
  else
  begin
    for i := 0 to GtslScratchLab.Count - 1 do
    begin
      newline := GtslScratchLab[i];
      newtest := Piece(newline, '^', 2) + '.0';
      SetPiece(newline, '^', 2, newtest);
      GtslScratchLab[i] := newline;
    end;
    FastAddStrings(GtslScratchLab, GtslData);    //&&&&&
    SpecRefSet(aItemType, aItemName);
    filename := FileNameX('63');

    LabCheck(lvwItemsTop, aItemType, oldlisting);
    selectlab := aSection = 'top';
    lvwItemsTop.Items.BeginUpdate;
    for i := 0 to GtslMultiSpec.Count - 1 do
    begin
      checktest := UpperCase(Pieces(GtslMultiSpec[i], '^', 1, 2));
      if Piece(checktest, '.', 2) = '0' then      // flag expanded test
      begin
        checktypeitem := Piece(checktest, '.', 1);
        for j := 0 to GtslCheck.Count - 1 do
        begin
          if GtslCheck[j] = checktypeitem then
          begin
            GtslCheck[j] := checktypeitem + '^*';
            break;
          end;
        end;
      end;
      GtslCheck.Add(checktest);
      if (FGraphSetting.FMStartDate = FM_START_DATE) or
          DateRangeMultiItems(FGraphSetting.FMStartDate, FGraphSetting.FMStopDate, Piece(GtslMultiSpec[i], '^', 2)) then
        LabAdd(lvwItemsTop, filename, i, oldlisting, selectlab);
    end;
    lvwItemsTop.SortType := stBoth;
    lvwItemsTop.Items.EndUpdate;

    LabCheck(lvwItemsBottom, aItemType, oldlisting);
    selectlab := aSection = 'bottom';
    lvwItemsBottom.Items.BeginUpdate;
    for i := 0 to GtslMultiSpec.Count - 1 do
      LabAdd(lvwItemsBottom, filename, i, oldlisting, selectlab);
    lvwItemsBottom.SortType := stBoth;
    lvwItemsBottom.Items.EndUpdate;
  end;
end;

// sort out for multiple spec or ref ranges
procedure TfrmGraphs.SpecRefCheck(aItemType, aItemName: string; var singlespec: boolean);
var
  i: integer;
  aitem, aspec, checkstring, datastring, refrange, low, high, srcheck, srcheck1, units: string;
begin
  GtslSpec1.Sorted := true;
  GtslSpec1.Clear;
  singlespec := true;
  srcheck1 := '';
  if GtslScratchLab.Count < 1 then exit;
  for i := 0 to GtslScratchLab.Count - 1 do
  begin
    datastring := GtslScratchLab[i];
    aitem := Piece(datastring, '^', 2);
    aspec := Piece(datastring, '^', 7);
    refrange := Piece(datastring, '^', 10);
    units := Piece(datastring, '^', 11);
    if length(refrange) = 0 then
    begin
      RefUnits(aitem, aspec, low, high, units);
      refrange := low + '!' + high;
      SetPiece(datastring, '^', 10, refrange);
      SetPiece(datastring, '^', 11, units);
    end;
    srcheck := aitem + '^' + aspec + '^' + refrange + '^' + units;
    checkstring := UpperCase(srcheck) + '^' + datastring;
    GtslSpec1.Add(checkstring);
    if i = 0 then srcheck1 := srcheck
    else if srcheck1 <> srcheck then singlespec := false;
  end;
end;

// for mutiple spec ranges replace data and items
procedure TfrmGraphs.SpecRefSet(aItemType, aItemName: string);

function MultiRef(aline: string): boolean;
// check for multiple ref ranges on test/specimen
var
  cnt, i: integer;
  checkspec, listline, testspec: string;
begin
  Result := false;
  checkspec := Piece(aline, '^', 2);
  cnt := 0;
  for i := 0 to GtslSpec2.Count - 1 do
  begin
    listline := GtslSpec2[i];
    testspec := Piece(listline, '^', 2);
    if testspec = checkspec then cnt := cnt + 1;
    if cnt > 1 then
    begin
      Result := true;
      break;
    end;
  end;
end;

var
  cnt, i, lastnum: integer;
  listline, newline, newtest, newtsru, oldline, oldspec, oldtsru, refrange: string;
  range, specimen, specimens: string;
  multispec: boolean;
begin
  lastnum := GtslSpec1.Count - 1;
  if lastnum < 0 then
    exit;
  GtslSpec2.Clear; GtslSpec3.Clear; GtslSpec4.Clear;
  GtslSpec1.Sort;
  oldtsru := ''; newtest := '';
  oldspec := Piece(GtslSpec1[0], '^', 2);
  multispec := false;
  cnt := 0;
  for i := GtslSpec1.Count - 1 downto 0 do  // backwards to assure most recent item
  begin
    listline := GtslSpec1[i];
    if Piece(listline, '^', 2) <> oldspec then multispec := true;
    newtsru := Pieces(listline, '^', 1 , 4);
    if newtsru <> oldtsru then
    begin
      cnt := cnt + 1;
      newtest := Piece(listline, '^', 6) + '.' + inttostr(cnt);
      SetPiece(listline, '^', 1, newtest);
      GtslSpec2.Add(listline);
      oldtsru := newtsru;
    end;
    newline := Pieces(listline, '^', 5, 15);
    SetPiece(newline, '^', 2, newtest);
    GtslSpec3.Add(newline);
  end;
  oldline := '';
  for i := 0 to GtslItems.Count - 1 do
  if aItemType = Pieces(GtslItems[i], '^', 1, 2) then
  begin
    oldline := GtslItems[i];
    GtslItems.Delete(i);
    break;
  end;
  specimen := ''; specimens := ''; range := '';
  for i := 0 to GtslSpec2.Count - 1 do
  begin
    listline := GtslSpec2[i];
    newtest := Piece(oldline, '^', 4);
    if multispec then
    begin
      specimen := LowerCase(Piece(listline, '^', 12));
      newtest := newtest + ' (' + specimen + ')';
      specimens := specimens + specimen + ', ';
    end;
    if MultiRef(listline) then
    begin
      refrange := Piece(listline, '^', 14);
      range := Piece(refrange, '!', 1) + '-' + Piece(refrange, '!', 2);
      newtest := newtest + ' [' + range + ']';
    end;
    newline := oldline;
    SetPiece(newline, '^', 2, Piece(listline, '^', 1));
    SetPiece(newline, '^', 4, newtest);
    SetPiece(newline, '^', 6, Piece(listline, '^', 7));
    SetPiece(newline, '^', 10, Piece(listline, '^', 14));
    SetPiece(newline, '^', 11, Piece(listline, '^', 15));
    GtslSpec4.Add(newline);
  end;
  newline := oldline;
  newtest := Piece(newline, '^', 2) + '.0';
  SetPiece(newline, '^', 2, newtest);
  newtest := Piece(newline, '^', 4) + '*';
  {if length(specimens) > 0 then        // add multi-specimens to name
  begin
    specimens := LeftStr(specimens, length(specimens) - 2);
    newtest := newtest + ' (' + specimens + ')';
  end;}
  SetPiece(newline, '^', 4, newtest);
  GtslSpec4.Add(newline);
  FastAddStrings(GtslSpec4, GtslItems);
  FastAddStrings(GtslSpec3, GtslData);
  FastAssign(GtslSpec4, GtslMultiSpec);
end;

procedure TfrmGraphs.RefUnits(aItem, aSpec: string; var low, high, units: string);
var
  i: integer;
  item2: double;
  itemspec, specstring: string;
begin
  item2 := strtofloatdef(aItem, -BIG_NUMBER);
  if item2 <> -BIG_NUMBER then
  begin
    item2 := round(item2);
    aItem := floattostr(item2);
  end;
  itemspec := aItem + '^' + aSpec;
  for i := 0 to GtslTestSpec.Count - 1 do
  if itemspec = Pieces(GtslTestSpec[i], '^', 1, 2) then
  begin
    specstring := GtslTestSpec[i];
    low :=   Piece(specstring, '^', 3);
    high :=  Piece(specstring, '^', 4);
    units := Piece(specstring, '^', 8);
    if (Copy(low, 1, 3) = '$S(') then low  := SelectRef(low);
    if (Copy(high, 1, 3) = '$S(') then high := SelectRef(high);
    break;
  end;
end;

function TfrmGraphs.SelectRef(aRef: string): string;
// check ref range for AGE and SEX variables in $S statement

  procedure CheckRef(selection: string; var value: string; var ok: boolean);
  var
    age: integer;
    part1, part2, part3: string;
  begin
    value := '';
    ok := false;
    if pos('$S', selection) > 0 then exit;
    if pos(':', selection) = 0 then exit;
    part1 := Piece(selection, ':', 1);
    part2 := Piece(selection, ':', 2);
    part3 := Piece(selection, ':', 3);
    if length(part1) = 0 then exit;
    if length(part2) = 0 then exit;
    if length(part3) <> 0 then exit;
    ok := true;
    value := part2;
    if part1 = '1' then exit;
    if copy(part1, 1, 4) = 'SEX=' then
    begin
      if (part1 = 'SEX="M"') and (Patient.Sex = 'M') then exit;
      if (part1 = 'SEX="F"') and (Patient.Sex = 'F') then exit; //?? check for '= '> '<    ??
      value := '';
    end
    else if copy(part1, 1, 3) = 'AGE' then
    begin
      part3 := copy(part1, 5, length(part1));
      age := strtointdef(part3, BIG_NUMBER);
      if age <> BIG_NUMBER then
      begin
        part3 := copy(part1, 1, 4);
        if (part3 = 'AGE>') and (Patient.Age > age) then exit;
        if (part3 = 'AGE<') and (Patient.Age < age) then exit;
        if (part3 = 'AGE=') and (Patient.Age = age) then exit;
      end;
      value := '';
    end
    else
      value:= '';
  end;

var
  ok: boolean;
  i: integer;
  selection, selections: string;
begin
  Result := '';
  if copy(aRef, length(aRef), 1) = ')' then
  begin
    selections := copy(aRef, 4, length(aRef) - 4);
    for i := 1 to BIG_NUMBER do
    begin
      selection := Piece(selections, ',', i);
      if selection = '' then break;
      ok := true;
      CheckRef(selection, Result, ok);
      if not ok then break;
      if length(Result) > 0 then break;
    end;
  end;
end;

procedure TfrmGraphs.chartBaseClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  seriestitle: string;
begin
  FGraphClick := Sender;
  chartDatelineTop.Tag := -1;   // indicates a legend click
  if Button <> mbRight then
    ItemDateRange(Sender)
  else
  begin
    mnuPopGraphIsolate.Enabled := true;
    if pnlTop.Tag = 1 then
    begin
      if chkItemsTop.Checked then
      begin
        seriestitle := Sender.SeriesTitleLegend(0);
        scrlTop.Hint := 'Details - for ' + seriestitle;
        scrlTop.Tag := 1;
        mnuPopGraphIsolate.Caption := 'Move - ' + seriestitle + ' - from Top to Bottom';
        mnuPopGraphIsolate.Hint := seriestitle;
        mnuPopGraphRemove.Enabled := true;
        mnuPopGraphRemove.Caption := 'Remove - ' + seriestitle;
        mnuPopGraphDetails.Caption := 'Details - ' + seriestitle;
        mnuPopGraphValueMarks.Caption := 'Values - ';
        mnuPopGraphValueMarks.Enabled := false;
      end
      else
      begin
        mnuPopGraphIsolate.Caption := 'Move all selections to bottom';
        mnuPopGraphRemove.Caption := 'Remove all selections from top';
      end;
    end
    else
    begin
      if chkItemsBottom.Checked then
      begin
        seriestitle := Sender.SeriesTitleLegend(0);
        scrlTop.Hint := 'Details - for ' + seriestitle;
        scrlTop.Tag := 1;
        mnuPopGraphIsolate.Caption := 'Move - ' + seriestitle + ' - from Bottom to Top';
        mnuPopGraphIsolate.Hint := seriestitle;
        mnuPopGraphRemove.Enabled := true;
        mnuPopGraphRemove.Caption := 'Remove - ' + seriestitle;
        mnuPopGraphDetails.Caption := 'Details - ' + seriestitle;
        mnuPopGraphValueMarks.Caption := 'Values - ';
        mnuPopGraphValueMarks.Enabled := false;
      end
      else
      begin
        mnuPopGraphIsolate.Caption := 'Move all selections to top';
        mnuPopGraphRemove.Caption := 'Remove all selections from bottom';
      end;
    end;
  end;
end;

function TfrmGraphs.BPValue(aDateTime: TDateTime): string;
var
  i: integer;
  fmdatetime: double;
  datastring, datecheck, fmstring: string;
begin
  Result := '';
  fmdatetime := datetimetofmdatetime(aDateTime);
  fmstring := floattostr(fmdatetime);
  for i := 0 to GtslData.Count - 1 do
  begin
    datastring := GtslData[i];
    if Pieces(datastring, '^', 1, 2) = '120.5^1' then   //********** get item # for bp instead of 1
    begin
      datecheck := Piece(datastring, '^', 3);
      if length(Piece(datecheck, '.', 2)) > 0 then
        datecheck := Piece(datecheck, '.', 1) + '.' + copy(Piece(datecheck, '.', 2), 1, 4);
      if fmstring = datecheck then
      begin
        Result := Piece(datastring, '^', 5);
        break;
      end;
    end;
  end;
end;

procedure TfrmGraphs.mnuCustomClick(Sender: TObject);
begin
  mnuCustom.Checked := not mnuCustom.Checked;
  tsTopCustom.TabVisible := mnuCustom.Checked;
  tsBottomCustom.TabVisible := mnuCustom.Checked;
end;

procedure TfrmGraphs.mnuGraphDataClick(Sender: TObject);
begin
  frmGraphData.Show;
end;

procedure TfrmGraphs.mnuPopGraphMergeLabsClick(Sender: TObject);
begin
  with FGraphSetting do MergeLabs := not MergeLabs;
  cboDateRangeChange(self);
  PositionSelections(lvwItemsTop);
  PositionSelections(lvwItemsBottom);
  mnuPopGraphMergeLabs.Checked := FGraphSetting.MergeLabs;
end;

procedure TfrmGraphs.PositionSelections(aListView: TListView);
var
  bottomitem, i: integer;
begin
  if aListView.SelCount > 0 then
  begin
    bottomitem := 0;
    for i := aListView.Items.Count - 1 downto 0 do
      if aListView.Items[i].Selected then
      begin
        bottomitem := i;
        break;
      end;
    aListView.Items[bottomitem].MakeVisible(true);
  end;
end;

procedure TfrmGraphs.mnuMHasNumeric1Click(Sender: TObject);
begin
  DialogGraphOthers(1);
end;

procedure TfrmGraphs.mnuPopGraphResetClick(Sender: TObject);
begin
  FFirstClick := true;
  GtslZoomHistoryFloat.Clear;
  FRetainZoom := false;
  mnuPopGraphZoomBack.Enabled := false;
  lvwItemsTopClick(self);
end;

procedure TfrmGraphs.serDatelineTopGetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: String);
var
  i: integer;
  checkindex, checkseries, checktag, firsttext, nonstring: string;
begin
  firsttext := MarkText;
  MarkText := Sender.Title;
  if Copy(MarkText, 1, 4) = 'Ref ' then MarkText := ''
  else if Piece(Sender.Title, '^', 1) = '(non-numeric)' then
  begin
    if Sender.Tag > 0 then
    begin
      checkseries := inttostr(Sender.Tag - BIG_NUMBER);
      checktag := inttostr(Sender.ParentChart.Tag);
      checkindex := inttostr(ValueIndex + 1);
      for i := 0 to GtslNonNum.Count - 1 do
      begin
        nonstring := GtslNonNum[i];
        if checktag = Piece(nonstring, '^', 2) then
        begin
          if checkseries = Piece(nonstring, '^', 3) then
          if Piece(nonstring, '^', 4) = checkindex then
          begin
            MarkText := Piece(nonstring, '^', 13);
            break;
          end;
        end;
      end;
    end;
  end
  else if Sender is TLineSeries then
    MarkText := firsttext;
end;

procedure TfrmGraphs.mnuPopGraphRemoveClick(Sender: TObject);
var
  selnum: integer;
  aSection, typeitem: string;
  aListBox: TORListBox;
  aListView: TListView;
begin
  FFirstClick := true;
  if pnlTop.Tag = 1 then
  begin
    aListBox := lstViewsTop;
    aListView := lvwItemsTop;
    aSection := 'top';
  end
  else
  begin
    aListBox := lstViewsBottom;
    aListView := lvwItemsBottom;
    aSection := 'bottom';
  end;
  aListBox.ItemIndex := -1;
  if aListView.SelCount = 0 then exit;
  if StripHotKey(mnuPopGraphRemove.Caption) = ('Remove all selections from ' + aSection) then
    aListView.Selected := nil
  else
  begin
    ItemCheck(aListView, mnuPopGraphIsolate.Hint, selnum, typeitem);
    if selnum = -1 then exit;
    aListView.Items[selnum].Selected := false;
  end;
  DisplayData('top');
  DisplayData('bottom');
  mnuPopGraphRemove.Enabled := false;
  mnuPopGraphResetClick(self);
end;

procedure TfrmGraphs.mnuPopGraphTodayClick(Sender: TObject);
begin
  with dlgDate do
  begin
    FMDateTime := FMToday;
    if Execute then FMToday := FMDateTime;
  end;
end;

procedure TfrmGraphs.BaseResize(aScrollBox: TScrollBox);
var
  displayheight, displaynum, i: integer;
begin
  ChartOnZoom(chartDatelineTop);
  with aScrollBox do
  begin
    if ControlCount < FGraphSetting.MaxGraphs then
      displaynum := ControlCount
    else
      displaynum := FGraphSetting.MaxGraphs;
    displayheight := FGraphSetting.MinGraphHeight;
    if displaynum > 0 then
      if (Height div displaynum) < FGraphSetting.MinGraphHeight then
        displayheight := FGraphSetting.MinGraphHeight
      else
        displayheight := (Height div displaynum);
    for i := 0 to aScrollBox.ControlCount - 1 do
      Controls[i].height := displayheight;
  end;
end;

procedure TfrmGraphs.pnlScrollTopBaseResize(Sender: TObject);
begin
  ChartOnZoom(chartDatelineTop);
  BaseResize(scrlTop);
  BaseResize(scrlBottom);
end;

procedure TfrmGraphs.NextPointerStyle(aSeries: TChartSeries; aSerCnt: integer);
var
  colors1, colors2, colors3, colors4, colors5, colors6: integer;
begin
  colors1 := NUM_COLORS + 1;
  colors2 := NUM_COLORS * 2 + 1;
  colors3 := NUM_COLORS * 3 + 1;
  colors4 := NUM_COLORS * 4 + 1;
  colors5 := NUM_COLORS * 5 + 1;
  colors6 := NUM_COLORS * 6 + 1;
  if aSeries is TLineSeries then
  begin
    with (aSeries as TLineSeries) do
    if aSerCnt < colors1 then
      Pointer.Style := psCircle
    else if aSerCnt < colors2 then
      Pointer.Style := psTriangle
    else if aSerCnt < colors3 then
      Pointer.Style := psRectangle
    else if aSerCnt < colors4 then
      Pointer.Style := psStar
    else if aSerCnt < colors5 then
      Pointer.Style := psDownTriangle
    else if aSerCnt < colors6 then
      Pointer.Style := psCross
    else
      Pointer.Style := psDiagCross;
  end
  else if aSeries is TBarSeries then
  begin
    with (aSeries as TBarSeries) do
    if aSerCnt < colors1 then
      BarStyle := bsPyramid
    else if aSerCnt < colors2 then
      BarStyle := bsInvPyramid
    else if aSerCnt < colors3 then
      BarStyle := bsArrow
    else if aSerCnt < colors4 then
      BarStyle := bsEllipse
    else
      BarStyle := bsRectangle;
  end
  else if aSeries is TPointSeries then
  begin
    with (aSeries as TPointSeries) do
    if aSerCnt < colors1 then
      Pointer.Style := psRectangle
    else if aSerCnt < colors2 then
      Pointer.Style := psTriangle
    else if aSerCnt < colors3 then
      Pointer.Style := psCircle
    else if aSerCnt < colors4 then
      Pointer.Style := psStar
    else if aSerCnt < colors5 then
      Pointer.Style := psDownTriangle
    else if aSerCnt < colors6 then
      Pointer.Style := psCross
    else
      Pointer.Style := psDiagCross;
  end;
end;

function TfrmGraphs.FMCorrectedDate(fmtime: string): string;
begin
  if Copy(fmtime, 4, 4) = '0000' then Result := Copy(fmtime, 1, 3) + '0101'
  else if Copy(fmtime, 6, 2) = '00' then Result := Copy(fmtime, 1, 5) + '01'
  else Result := fmtime;
end;

procedure TfrmGraphs.FixedDates(var adatetime, adatetime1: TDateTime);
begin
  if FGraphSetting.FMStartDate <> FM_START_DATE then
  begin  // do not use when All Results
    adatetime := FMDateTimeToDateTime(FGraphSetting.FMStopDate);
    adatetime1 := FMDateTimeToDateTime(FGraphSetting.FMStartDate);
    FGraphSetting.HighTime := adatetime;
    FGraphSetting.LowTime := adatetime1;
    FTHighTime := adatetime;
    FTLowTime := adatetime1;
    FBHighTime := adatetime;
    FBLowTime := adatetime1;
  end;
end;

procedure TfrmGraphs.HighLow(fmtime, fmtime1: string; aChart: TChart; var adatetime, adatetime1: TDateTime);
begin
  adatetime1 := 0;
  adatetime := FMToDateTime(fmtime);
  if adatetime > FGraphSetting.HighTime then FGraphSetting.HighTime := adatetime;
  if adatetime < FGraphSetting.LowTime then FGraphSetting.LowTime := adatetime;
  if aChart = chartDatelineTop then
  begin
    if adatetime > FTHighTime then FTHighTime := adatetime;
    if adatetime < FTLowTime then FTLowTime := adatetime;
  end
  else
  begin
    if adatetime > FBHighTime then FBHighTime := adatetime;
    if adatetime < FBLowTime then FBLowTime := adatetime;
  end;
  if fmtime1 <> '' then
  begin
    adatetime1 := FMToDateTime(fmtime1);
    if adatetime1 > FGraphSetting.HighTime then FGraphSetting.HighTime := adatetime1;
    if adatetime1 < FGraphSetting.LowTime then FGraphSetting.LowTime := adatetime1;
    if aChart = chartDatelineTop then
    begin
      if adatetime1 > FTHighTime then FTHighTime := adatetime1;
      if adatetime1 < FTLowTime then FTLowTime := adatetime1;
    end
    else
    begin
      if adatetime1 > FBHighTime then FBHighTime := adatetime1;
      if adatetime1 < FBLowTime then FBLowTime := adatetime1;
    end;
  end;
end;

procedure TfrmGraphs.HideGraphs(action: boolean);
begin
  pnlTop.Color := chartDatelineTop.Color;
  pnlBottom.Color := chartDatelineTop.Color;
  if action then
  begin
    pnlScrollTopBase.Visible := false;
    pnlScrollBottomBase.Visible := false;
  end
  else
  begin
    pnlScrollTopBase.Visible := true;
    pnlScrollBottomBase.Visible := true;
    chartDatelineTop.Refresh;
  end;
end;

procedure TfrmGraphs.BorderValue(var bordervalue: double; value: double);
begin
  if FGraphSetting.FixedDateRange then
    if bordervalue = -BIG_NUMBER then
      bordervalue := value;
end;

procedure TfrmGraphs.BPAdd(itemvalue: string; adatetime: TDateTime; var fixeddatevalue: double; serLine, serBPDiastolic, serBPMean: TLineSeries);
var
  value: double;
  valueD, valueM, valueS: string;
begin
  valueS := Piece(itemvalue, '/', 1);
  valueD := Piece(itemvalue, '/', 2);
  valueM := Piece(itemvalue, '/', 3);
  value := strtofloatdef(valueS, -BIG_NUMBER);
  if value <> -BIG_NUMBER then
    serLine.AddXY(adatetime, value, '', clTeeColor);
  value := strtofloatdef(valueD, -BIG_NUMBER);
  if value <> -BIG_NUMBER then
    serBPDiastolic.AddXY(adatetime, value, '', clTeeColor);
  value := strtofloatdef(valueM, -BIG_NUMBER);
  if value <> -BIG_NUMBER then
  begin
    serBPMean.AddXY(adatetime, value, '', clTeeColor);
    serBPMean.Active := true;
  end;
  BorderValue(fixeddatevalue, 100);
end;

procedure TfrmGraphs.BPCheck(aChart: TChart; aFileType: string; serLine, serBPDiastolic, serBPMean: TLineSeries);
begin
  MakeSeriesBP(aChart, serLine, serBPDiastolic, aFileType);
  MakeSeriesBP(aChart, serLine, serBPMean, aFileType);
  serBPDiastolic.Active := true;
  serBPMean.Active := false;
end;

procedure TfrmGraphs.PainAdd(serBlank: TPointSeries);
begin
  begin
    serBlank.Active := true;
    serBlank.Pointer.Pen.Visible := false;
    serBlank.AddXY(IncDay(FGraphSetting.LowTime, -1), 0, '', pnlScrollTopBase.Color);
    serBlank.AddXY(IncDay(FGraphSetting.LowTime, -1), 10, '', pnlScrollTopBase.Color);
  end;
end;

procedure TfrmGraphs.NumAdd(serLine: TLineSeries; value: double; adatetime: TDateTime;
  var fixeddatevalue, hi, lo: double; var high, low: string);
begin
  if (btnChangeSettings.Tag = 1) and (hi <> -BIG_NUMBER) and (lo <> -BIG_NUMBER) then
  begin      // standard deviation
    value := StdDev(value, hi, lo);
    serLine.AddXY(adatetime, value, '', clTeeColor);
    high := '2'; low := '-2';
    BorderValue(fixeddatevalue, 0);
    //splGraphs.Tag := 1;   // show ref range
  end        // inverse value
  else if btnChangeSettings.Tag = 2 then
  begin
    value := InvVal(value);
    serLine.AddXY(adatetime, value, '', clTeeColor);
    high := '2'; low := '0';
    BorderValue(fixeddatevalue, 0);
    splGraphs.Tag := 0;  // do not show ref range
  end
  else
  begin       // numeric value
    serLine.AddXY(adatetime, value, '', clTeeColor);
    BorderValue(fixeddatevalue, value);
  end;
end;

procedure TfrmGraphs.NonNumSave(aChart: TChart; aTitle, aSection: string; adatetime: TDateTime;
  var noncnt: integer; newcnt, aIndex: integer);
var
  astring: string;
begin
  noncnt := noncnt + 1;
  astring := floattostr(adatetime) + '^' + inttostr(aChart.Tag) + '^'
           + inttostr(newcnt) + '^' + inttostr(noncnt) + '^^' + aTitle + '^'
           + aSection + '^^' + GtslTemp[aIndex];
  GtslNonNum.Add(astring);
end;

//****************************************************************************

procedure TfrmGraphs.MakeLineSeries(aChart: TChart; aTitle, aFileType, section: string;
  var aSerCnt, aNonCnt: integer; multiline: boolean);
var
  i, noncnt, newcnt: integer;
  fixeddatevalue, hi, lo, testint, testpad, value: double;
  checkdata, fmtime, itemvalue: string;
  comments, high, low, specimen: string;
  afixeddate, afixeddate1: TDateTime;
  adatetime, adatetime1: TDateTime;
  serBPDiastolic, serBPMean, serHigh, serLine, serLow: TLineSeries;
  serBlank: TPointSeries;
begin
  fixeddatevalue := -BIG_NUMBER;
  noncnt := 0; //GtslNonNum.Count;
  aChart.LeftAxis.LabelsFont.Color := aChart.BottomAxis.LabelsFont.Color;
  aSerCnt := aSerCnt + 1;
  specimen := LowerCase(Piece(aTitle, '^', 4));
  low := Piece(aTitle, '^', 5);
  high := Piece(aTitle, '^', 6);
  lo := strtofloatdef(low, -BIG_NUMBER);
  hi := strtofloatdef(high, -BIG_NUMBER);
  serLine := TLineSeries.Create(aChart);
  newcnt := aChart.SeriesCount;
  serBPDiastolic := TLineSeries.Create(aChart);
  serBPMean := TLineSeries.Create(aChart);
  serLow := TLineSeries.Create(aChart);
  serLow.Active := false;
  serHigh := TLineSeries.Create(aChart);
  serHigh.Active := false;
  serBlank := TPointSeries.Create(aChart);
  serBlank.Active := false;
  with serLine do
  begin
    MakeSeriesInfo(aChart, serLine, aTitle, aFileType, aSerCnt);
    LinePen.Visible := FGraphSetting.Lines;
    if (length(specimen) > 0) and (not ansicontainsstr(Title, specimen)) then
      Title := Title + ' (' + specimen + ')';
    Pointer.Visible := true;
    Pointer.InflateMargins := true;
    NextPointerStyle(serLine, aSerCnt);
    Tag := newcnt;
  end;
  if serLine.Title = 'Blood Pressure' then
    BPCheck(aChart, aFileType, serLine, serBPDiastolic, serBPMean);
  for i := GtslTemp.Count - 1 downto 0 do         // go from oldest first
  begin
    checkdata := GtslTemp[i];
    fmtime := FMCorrectedDate(Piece(checkdata, '^', 3));
    if IsFMDateTime(fmtime) then
    begin
      HighLow(fmtime, '', aChart, adatetime, adatetime1);
      comments := Piece(checkdata, '^', 9);
      if strtointdef(comments, -1) > 0  then aChart.Hint := comments;  // for any occurrence
      itemvalue := Piece(checkdata, '^', 5);
      itemvalue := trim(itemvalue);
      itemvalue := StringReplace(itemvalue, ',', '', [rfReplaceAll]);
      if serLine.Title = 'Blood Pressure' then
        BPAdd(itemvalue, adatetime, fixeddatevalue, serLine, serBPDiastolic, serBPMean)
      else
      begin
        value := strtofloatdef(itemvalue, -BIG_NUMBER);
        if (value <> -BIG_NUMBER) and (GtslTemp.Count = 1) and (lo = -BIG_NUMBER) and (hi = -BIG_NUMBER) then
        begin   // pad single numbers (without refs) to avoid exceptions
          testint := int(value);
          if testint = 0 then
          begin
            testint := value;
            testpad := value;
          end
          else
            testpad := 1;
          serBlank.AddXY(adatetime, testint + testpad, '', aChart.Color);
          serBlank.AddXY(adatetime, testint - testpad, '', aChart.Color);
        end;
        if value <> -BIG_NUMBER then
          NumAdd(serLine, value, adatetime, fixeddatevalue, hi, lo, high, low)
        else
          NonNumSave(aChart, serLine.Title, section, adatetime, noncnt, newcnt, i);
      end;
    end;
  end;
  if (length(low) > 0) and (splGraphs.Tag = 1) then
    MakeSeriesRef(aChart, serLine, serLow, 'Ref Low ', low, fixeddatevalue);
  if (length(high) > 0) and (splGraphs.Tag = 1) then
    MakeSeriesRef(aChart, serLine, serHigh, 'Ref High ', high, fixeddatevalue);
  splGraphs.Tag := 0;
  MakeSeriesPoint(aChart, serBlank);
  if serLine.Title = 'Pain' then
    PainAdd(serBlank);
  if multiline then
  begin
    // do nothing for now
  end;
  if fixeddatevalue <> -BIG_NUMBER then
  begin
    serBlank.Active := true;
    serBlank.Pointer.Pen.Visible := false;
    FixedDates(afixeddate, afixeddate1);
    serBlank.AddXY(afixeddate, fixeddatevalue, '', aChart.Color);
    serBlank.AddXY(afixeddate1, fixeddatevalue, '', aChart.Color);
  end;
end;

procedure TfrmGraphs.MakePointSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);
var
  i: integer;
  value: double;
  fmtime: string;
  adatetime, adatetime1: TDateTime;
  serPoint: TPointSeries;
begin
  aSerCnt := aSerCnt + 1;
  serPoint := TPointSeries.Create(aChart);
  MakeSeriesInfo(aChart, serPoint, aTitle, aFileType, aSerCnt);
  with serPoint do
  begin
    NextPointerStyle(serPoint, aSerCnt);
    Pointer.Visible := true;
    Pointer.InflateMargins := true;
    Pointer.Style := psSmallDot;
    Pointer.Pen.Visible := true;
    Pointer.VertSize := 10;
    Pointer.HorizSize := 2;
    for i := 0 to GtslTemp.Count - 1 do
    begin
      fmtime := FMCorrectedDate(Piece(GtslTemp[i], '^', 3));
      if IsFMDateTime(fmtime) then
      begin
        HighLow(fmtime, '', aChart, adatetime, adatetime1);
        value := strtofloatdef(Piece(GtslTemp[i], '^', 5), -BIG_NUMBER);
        if value = -BIG_NUMBER then
        begin
          value := aSerCnt;
          TempCheck(Pieces(GtslTemp[i], '^', 1, 2), value);
        end;
        serPoint.AddXY(adatetime, value, '', clTeeColor);
      end;
    end;
  end;
end;

procedure TfrmGraphs.MakeBarSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);
var
  i: integer;
  value: double;
  fmtime: string;
  adatetime, adatetime1: TDateTime;
  afixeddate, afixeddate1: TDateTime;
  serBar: TBarSeries;
  serBlank: TPointSeries;
begin
  aSerCnt := aSerCnt + 1;
  serBlank := TPointSeries.Create(aChart);
  MakeSeriesPoint(aChart, serBlank);
  serBar := TBarSeries.Create(aChart);
  MakeSeriesInfo(aChart, serBar, aTitle, aFileType, aSerCnt);
  with serBar do
  begin
    YOrigin := 0;
    CustomBarWidth := 7;
    NextPointerStyle(serBar, aSerCnt);
    for i:= 0 to GtslTemp.Count - 1 do
    begin
      fmtime := FMCorrectedDate(Piece(GtslTemp[i], '^', 3));
      if IsFMDateTime(fmtime) then
      begin
        HighLow(fmtime, '', aChart, adatetime, adatetime1);
        value := 25 - (aSerCnt mod NUM_COLORS);
        if FPrevEvent = copy(fmtime, 1, 10) then
          if copy((FPrevEvent + '00'), 1, 12) = copy(fmtime, 1, 12) then  // same time occurrence
          begin
            InfoMessage(TXT_WARNING_SAME_TIME, COLOR_WARNING, true);
            if MergedLabsSelected then
              InfoMessage(pnlInfo.Caption + ' ' + TXT_WARNING_MERGED_LABS, COLOR_WARNING, true);
            pnlHeader.Visible := true;
            FWarning := true;
          end;
        if value <> -BIG_NUMBER then
          serBar.AddXY(adatetime, value, '', clTeeColor);
        FPrevEvent := copy(fmtime, 1, 10);
        if i = 0 then
        begin
          serBlank.Pointer.Pen.Visible := false;
          serBlank.AddXY(adatetime, 100, '', aChart.Color);
          if FGraphSetting.FixedDateRange then
          begin
            FixedDates(afixeddate, afixeddate1);
            serBlank.AddXY(afixeddate, 100, '', aChart.Color);
            serBlank.AddXY(afixeddate1, 100, '', aChart.Color);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmGraphs.MakeGanttSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);
var
  i, value: integer;
  fmtime, fmtime1: string;
  adatetime, adatetime1: TDateTime;
  afixeddate, afixeddate1: TDateTime;
  serGantt: TGanttSeries;
  serBlank: TPointSeries;
begin
  aSerCnt := aSerCnt + 1;
  serBlank := TPointSeries.Create(aChart);
  MakeSeriesPoint(aChart, serBlank);
  serGantt := TGanttSeries.Create(aChart);
  MakeSeriesInfo(aChart, serGantt, aTitle, aFileType, aSerCnt);
  with serGantt do
  begin
    if Piece(aTitle, '^', 1) = '55' then       // make inpatient meds smaller to identify
      Pointer.VertSize := RX_HEIGHT_IN
    else if Piece(aTitle, '^', 1) = '55NVA' then       // make nonva meds smaller to identify
      Pointer.VertSize := RX_HEIGHT_NVA
    else if Piece(aTitle, '^', 1) = '9999911' then       // make problems smaller to identify
      Pointer.VertSize := PROB_HEIGHT
    else
      Pointer.VertSize := RX_HEIGHT_OUT;
    value := round(((aSerCnt mod NUM_COLORS) / NUM_COLORS) * 80) + 20 + aSerCnt;
    if aFileType <> '9999911' then
      if aChart <> chartDatelineTop then
        if aChart <> chartDatelineBottom then
          value := value - 26;
    for i := 0 to GtslTemp.Count - 1 do
    begin
      fmtime := FMCorrectedDate(Piece(GtslTemp[i], '^', 3));
      fmtime1 := FMCorrectedDate(Piece(GtslTemp[i], '^', 4));
      if IsFMDateTime(fmtime) and IsFMDateTime(fmtime1) then
      begin
        HighLow(fmtime, fmtime1, aChart, adatetime, adatetime1);
        AddGantt(adatetime, adatetime1, value, '');
        if i = 0 then
        begin
          serBlank.Pointer.Pen.Visible := false;
          serBlank.AddXY(adatetime, 100, '', aChart.Color);
          if aFileType = '9999911' then
            serBlank.AddXY(adatetime, 0, '', aChart.Color);
          if FGraphSetting.FixedDateRange then
          begin
            FixedDates(afixeddate, afixeddate1);
            serBlank.AddXY(afixeddate, 100, '', aChart.Color);
            serBlank.AddXY(afixeddate1, 100, '', aChart.Color);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmGraphs.MakeVisitGanttSeries(aChart: TChart; aTitle, aFileType: string; var aSerCnt: integer);
var
  i: integer;
  value: double;
  fmtime, fmtime1: string;
  adatetime, adatetime1: TDateTime;
  afixeddate, afixeddate1: TDateTime;
  serGantt: TGanttSeries;
  serBlank: TPointSeries;
begin
  aSerCnt := aSerCnt + 1;
  serBlank := TPointSeries.Create(aChart);
  MakeSeriesPoint(aChart, serBlank);
  serGantt := TGanttSeries.Create(aChart);
  MakeSeriesInfo(aChart, serGantt, aTitle, aFileType, aSerCnt);
  with serGantt do
  begin
    if Piece(aTitle, '^', 1) = '405' then  // make admit smaller to identify
      Pointer.VertSize := NUM_COLORS + 3
    else if Piece(aTitle, '^', 1) = '9999911' then  // make problems smaller to identify
      Pointer.VertSize := PROB_HEIGHT
    else
      Pointer.VertSize := NUM_COLORS + (aSerCnt mod NUM_COLORS) + 10;
    value := aSerCnt div NUM_COLORS;
    for i:= 0 to GtslTemp.Count - 1 do
    begin
      fmtime := FMCorrectedDate(Piece(GtslTemp[i], '^', 3));
      fmtime1 := FMCorrectedDate(Piece(GtslTemp[i], '^', 4));
      if IsFMDateTime(fmtime) and IsFMDateTime(fmtime1) then
      begin
        HighLow(fmtime, fmtime1, aChart, adatetime, adatetime1);
        AddGantt(adatetime, adatetime1, value, '');
        if i = 0 then
        begin
          serBlank.Pointer.Pen.Visible := false;
          serBlank.AddXY(adatetime, 100, '', aChart.Color);
          if FGraphSetting.FixedDateRange then
          begin
            FixedDates(afixeddate, afixeddate1);
            serBlank.AddXY(afixeddate, 100, '', aChart.Color);
            serBlank.AddXY(afixeddate1, 100, '', aChart.Color);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmGraphs.splGraphsMoved(Sender: TObject);
begin
  if Sender = splGraphs then
    chkDualViews.Checked := pnlBottom.Height > 3;
end;

function TfrmGraphs.NonNumText(listnum , seriesnum, valueindex: integer): string;
var
  ok: boolean;
  i: integer;
  date1, moreinfo, nonvalue, otherdate, resultdate: string;
  datestart: double;
  charttag, filename, filenum, itemnum, seriescheck, specimen, typeitemname, value: string;
begin
  ok := false;
  seriescheck := inttostr(seriesnum - BIG_NUMBER);
  charttag := inttostr(listnum);
  for i := 0 to GtslNonNum.Count - 1 do
  begin
    nonvalue := GtslNonNum[i];
    if Piece(nonvalue, '^', 2) = charttag then
      if Piece(nonvalue, '^', 3) = seriescheck then
        if Piece(nonvalue, '^', 4) = inttostr(valueindex + 1) then
        begin
          ok := true;
          break;
        end;
  end;
  if not ok then
  begin
    Result := '';
    exit;
  end;
  date1    := Piece(nonvalue, '^', 1);
  filenum  := Piece(nonvalue, '^', 9);
  itemnum  := Piece(nonvalue, '^', 10);
  value    := Piece(nonvalue, '^', 13);
  specimen := Piece(nonvalue, '^', 16);
  filename := FileNameX(filenum);
  typeitemname := MixedCase(ItemName(filenum, itemnum));
  SetRefNonNum(nonvalue);
  if length(specimen) > 0 then
    typeitemname := typeitemname + ' (' + LowerCase(specimen) + ')';
  datestart := strtofloat(date1);
  resultdate := FormatDateTime('mmm d, yyyy  h:nn am/pm', datestart);
  otherdate := FormatDateTime('mm/dd/yy hh:nn', datestart);
  moreinfo := itemnum + '^' +
              Piece(nonvalue, '^', 11) + '^' +  //date
              value + '^' +
              Piece(nonvalue, '^', 14) + '^' +  //flag
              specimen + '^' +
              Piece(nonvalue, '^', 18) + '^' +  //refrange
              Piece(nonvalue, '^', 19);  //units
  Result := filenum + '^' +filename + '^' + resultdate + '^'
          + typeitemname + '^' + value + '^' + otherdate + '^' + moreinfo;
end;

function TfrmGraphs.ValueText(Sender: TCustomChart; aSeries: TChartSeries; ValueIndex: Integer): string;
var      // type#^typename^formatdate^itemname^result^date
  OKToUse: boolean;
  chartnum, i, selnum, SeriesNum: integer;
  startdate: double;
  filetype, moreinfo, otherdate: string;
  resultdate, resultstring, seriestitle, typeitem, typename, typenum: string;
begin
  Result := '';
  SeriesNum := -1;
  filetype := '';
  for i := 0 to Sender.SeriesCount - 1 do
    if Sender.Series[i] = aSeries then
    begin
      SeriesNum := i;
      filetype := Sender.Series[i].Identifier;
      break;
    end;
  if SeriesNum = -1 then
  begin
    Result := '';
    exit;
  end;
  chartnum := Sender.Tag;
  seriestitle := Piece(Sender.Series[SeriesNum].Title, '^', 1);
  if seriestitle = '(non-numeric)' then
  begin
    Result := NonNumText(chartnum, (aSeries as TChartSeries).Tag, ValueIndex);
    exit;
  end;
  ItemCheck(lvwItemsTop, seriestitle, selnum, typeitem);
  typeitem := UpperCase(typeitem);
  if selnum < 0 then
  begin
    Result := '^^^' + seriestitle;
    exit;
  end;
  typenum := Piece(typeitem, '^', 1);
  if (typenum <> filetype) and (filetype <> '') then
  begin
    typenum := filetype;
    typeitem := typenum + '^' + Piece(typeitem, '^', 2);
  end;
  CheckMedNum(typenum, aSeries);
  typename := FileNameX(typenum);
  if ValueIndex < 0 then
  begin
    Result := typenum + '^' + typename + '^^' + seriestitle;
    exit;
  end;
  ValueDates(aSeries, ValueIndex, resultdate, otherdate, startdate);
  ResultValue(resultstring, seriestitle, typenum, typeitem, Sender, aSeries, ValueIndex, SeriesNum, OKToUse);
  if not OKToUse then
    Result := ''
  else
  begin
    moreinfo := '';
    if typenum = '63' then
      OtherInfo(typeitem, resultstring, startdate, moreinfo);
    Result := typenum + '  ^' + typename + '^' + resultdate + '^' +
      seriestitle + '^' + resultstring + '^' + otherdate + '^' + moreinfo;
  end;
end;

procedure TfrmGraphs.OtherInfo(aTypeItem, aResult: string; aDateTime: double; var moreinfo: string);
var
  i: integer;
  fmdatetime: double;
  datax, decimals, fmdt, fmstring, itemnum, itemresult, resultcheck, resultcheckz, typenum: string;
begin
  moreinfo := ''; resultcheckz := '';
  typenum := Piece(aTypeItem, '^', 1);
  if typenum <> '63' then exit;
  itemnum := Piece(aTypeItem, '^', 2);
  fmdatetime := datetimetofmdatetime(aDateTime);
  fmstring := floattostr(fmdatetime);
  resultcheck := aResult;
  if Copy(resultcheck, 1, 2) = '0.' then   // graph values preface decimals with 0.#
    resultcheckz := '.' + Piece(resultcheck, '.', 2);
  for i := 0 to GtslData.Count - 1 do
  begin
    datax := GtslData[i];
    if Piece(datax, '^', 1) = '63' then
      if Piece(datax, '^', 2) = itemnum then
      begin
        fmdt := Piece(datax, '^', 3);
        if fmstring = copy(fmdt, 1, length(fmstring)) then  // date/time from graph is not as exact as results date/time
        begin
          itemresult := Piece(datax, '^', 5);
          decimals := Piece(itemresult, '.', 2);
          if length(decimals) > 0 then  // graph values do not have trail decimal zeros
            if Copy(decimals,length(decimals), 1) = '0' then
              resultcheck := Piece(resultcheck, '.', 1) + '.' + decimals;
          if (resultcheck = itemresult) or (resultcheckz = itemresult) then  // check for matching result
          begin   //results from GtslData
            SetRef(datax);
            moreinfo := itemnum + '^' +               //test number
                        fmdt + '^' +                  //date/time
                        itemresult + '^' +            //result
                        Piece(datax, '^', 6) + '^' +  //flag
                        Piece(datax, '^', 8) + '^' +  //specimen
                        Piece(datax, '^', 10) + '^' +  //ref range
                        Piece(datax, '^', 11);         //units
          end;
        end;
      end;
  end;
end;

procedure TfrmGraphs.ValueDates(aSeries: TChartSeries; ValueIndex: Integer; var resultdate, otherdate: string; var startdate: double);
var
  dateend, datestart: double;
begin
  if (aSeries is TGanttSeries) then
  begin
    datestart := (aSeries as TGanttSeries).StartValues[ValueIndex];
    dateend := (aSeries as TGanttSeries).EndValues[ValueIndex];
  end
  else
  begin
    datestart := aSeries.XValue[ValueIndex];
    dateend := datestart;
  end;
  startdate := datestart;
  if datestart <> dateend then
  begin
    resultdate := FormatDateTime('mmm d, yyyy  h:nn am/pm', datestart) +
      ' - ' + FormatDateTime('mmm d, yyyy  h:nn am/pm', dateend);
    otherdate := FormatDateTime('mm/dd/yy hh:nn', datestart) +
      ' - ' + FormatDateTime('mm/dd/yy hh:nn', dateend);
  end
  else
  begin
    resultdate := FormatDateTime('mmm d, yyyy  h:nn am/pm', datestart);
    otherdate := FormatDateTime('mm/dd/yy hh:nn', datestart);
  end;
end;

procedure TfrmGraphs.CheckMedNum(var typenum: string; aSeries: TChartSeries);
begin
  if typenum = '55' then
  begin
    if aSeries is TGanttSeries then
    if (aSeries as TGanttSeries).Pointer.VertSize <> RX_HEIGHT_IN then
    if (aSeries as TGanttSeries).Pointer.VertSize <> RX_HEIGHT_NVA then
      typenum := '52'
    else typenum := '55NVA';
  end
  else if typenum = '55NVA' then
  begin
    if aSeries is TGanttSeries then
    if (aSeries as TGanttSeries).Pointer.VertSize <> RX_HEIGHT_NVA then
    if (aSeries as TGanttSeries).Pointer.VertSize <> RX_HEIGHT_OUT then
      typenum := '55'
    else typenum := '52';
  end
  else if typenum = '52' then
  begin
    if aSeries is TGanttSeries then
    if (aSeries as TGanttSeries).Pointer.VertSize <> RX_HEIGHT_OUT then
    if (aSeries as TGanttSeries).Pointer.VertSize <> RX_HEIGHT_NVA then
      typenum := '55'
    else typenum := '55NVA';
  end;
end;

procedure TfrmGraphs.ResultValue(var resultstring, seriestitle: string; typenum, typeitem: string;
  Sender: TCustomChart; aSeries: TChartSeries; ValueIndex, SeriesNum: Integer; var OKToUse: boolean);
var
  i: integer;
  astring, datecheck, fmdatecheck, item, partitem: string;
begin
  resultstring := '';
  OKToUse := true;
  if typenum = '63' then
  begin
    if aSeries is TLineSeries then
      if (aSeries as TLineSeries).LinePen.Style = psDash then
      begin
        OKToUse := false;
        exit;    // serHigh or serLow
      end;
    if aSeries is TPointSeries then
      if (aSeries as TPointSeries).Pointer.Style = psSmallDot then
      begin
        OKToUse := false;
        exit;    // serBlank
      end;
    if copy(seriestitle, length(seriestitle) - 12, length(seriestitle)) = '(non-numeric)' then
    begin
      seriestitle := copy(seriestitle, 1, length(seriestitle) - 13);
      serDatelineTopGetMarkText(Sender.Series[SeriesNum], ValueIndex, resultstring);
    end
    else
      resultstring := floattostr(aSeries.YValue[ValueIndex]);
  end
  else if typenum <> '120.5' then
  begin
    item := Piece(typeitem, '^', 2);
    partitem := copy(item, 1, 4);
    //if (partitem = 'M;A;') then     //or (partitem = 'M;T;') then   tb antibiotic on 1st piece
    begin
      fmdatecheck := floattostr(DateTimeToFMDateTime(aSeries.XValue[ValueIndex]));
      for i := 0 to GtslData.Count - 1 do
      begin
        astring := GtslData[i];
        if typenum = Piece(astring, '^', 1) then
          if item = Piece(astring, '^', 2) then
          begin
            datecheck := Piece(astring, '^', 3);
            if length(Piece(datecheck, '.', 2)) > 0 then
              datecheck := Piece(datecheck, '.', 1) + '.' + copy(Piece(datecheck, '.', 2), 1, 4);
            if datecheck = fmdatecheck then
            begin
              resultstring := MixedCase(Pieces(astring, '^', 5, 6)) + '^' + Piece(astring, '^', 7);
              break;
            end;
          end;
      end;
    end;
  end
  else if typenum = '120.5' then
  begin
    if seriestitle = 'Blood Pressure' then
      resultstring := BPValue(aSeries.XValue[ValueIndex])
    else
      resultstring := floattostr(aSeries.YValue[ValueIndex]);
  end;
end;

procedure TfrmGraphs.chartBaseMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ClickedLegend, ClickedMark, ClickedValue, j: Integer;
  itemname: string;
  NewPt: TPoint;
begin
  //if not FGraphSetting.Hints then exit;       //*****
  FX := x;
  FY := y;
  FActiveGraph := (Sender as TChart);
  NewPt := Mouse.CursorPos;
  ClickedLegend := -1;
  ClickedMark   := -1;
  ClickedValue  := -1;
  if FHintWinActive then exit;
  with FActiveGraph do
  begin
    for j := 0 to SeriesCount - 1 do
    with (Series[j] as TChartSeries) do
    begin
      itemname := Series[j].Title;
      if (length(itemname) > 0) and (Copy(itemname, 1, 7) <> 'Ref Low') and (Copy(itemname, 1, 8) <> 'Ref High') then
      begin
        ClickedValue := Clicked(FX, FY);
        if ClickedValue > -1 then break;
        ClickedMark := Marks.Clicked(FX, FY);
        if ClickedMark > -1 then break;
        // ClickedLegend := Legend.Clicked(FX, FY);
        // if ClickedLegend > -1 then break;
      end;
    end;
    if (ClickedValue > -1) or (ClickedMark > -1) then
    begin
      FHintStop := false;
      Screen.Cursor := crHandPoint;
      timHintPause.Enabled := true;
    end
    else if ClickedLegend > -1 then
    begin
      timHintPause.Enabled := false;
      InactivateHint;
      Screen.Cursor := crHandPoint;
    end
    else
    begin
      timHintPause.Enabled := false;
      InactivateHint;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmGraphs.chartBaseMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TChart).AllowZoom := FGraphSetting.HorizontalZoom;      // avoids cursor rectangle from appearing
end;

procedure TfrmGraphs.FormatHint(var astring: string);
var
  i, j: integer;
  dttm, hintslice, hintformat, info, itemname, newinfo, slice, text, titlename, value: string;
  labresults: string;
begin
  // hint format: slice|slice|slice| ...
  // where | is linebreak and slice is [text] value~[text] value~[text] value~ ...
  hintformat := Piece(TypeString(Piece(Piece(astring, '^', 1), ' ', 1)), '^', 9);
  titlename := Piece(astring, '^', 2);
  astring := StringReplace(astring, ' 00:00', '', [rfReplaceAll]);
  dttm := Piece(astring, '^', 3);
  if trim(Piece(astring, '^', 1)) = '63' then
  begin
    LabNameResults(astring, itemname, labresults);
    info := itemname + '~' + labresults + '~';
  end
  else
  begin
    itemname := Piece(astring, '^', 4);
    info := itemname + '~' + Piece(astring, '^', 5) + '~';
  end;
  newinfo := '';
  for i := 1 to BIG_NUMBER do
  begin
    hintslice := Piece(hintformat, '|', i);
    slice := Piece(info, '|', i);
    for j := 1 to BIG_NUMBER do
    begin
      text := Piece(hintslice, '~', j);
      value := Piece(info, '~', j);
      newinfo := newinfo + text + ' ' + value;
      //if Piece(hintslice, '~', j + 1) = '' then
      //  break;                                                   .

      if Pos('~', hintslice) = length(hintslice) then
        break;
      if Piece(slice, '~', j + 1) = '' then
        break;
    end;
    if Piece(hintslice, '|', i + 1) = '' then
      break;
    if length(Piece(hintformat, '|', i + 1)) > 0 then
      newinfo := newinfo + #13;
    if Piece(hintformat, '|', i + 1) = '' then
      break;
  end;
  astring := titlename + '  ' + dttm + #13 + newinfo; //itemname + '  ' + newinfo;
end;

procedure TfrmGraphs.LabNameResults(astring: string; var labname, labresult: string);
var
  labnum, labref, xlabref: string;
begin
  labnum := Piece(astring, '^', 7);
  xlabref := '';
  labref := Piece(astring, '^', 12);
  if length(labref) > 1 then
    xlabref := '[' + Piece(labref, '!', 1) + '-' + Piece(labref, '!', 2) + ']';
  labresult := Piece(astring, '^', 9)
                + ' ' + Piece(astring, '^', 10)
                + '    ' + Piece(astring, '^', 13)
                + '    ' + xlabref;
  if Piece(labnum, '.', 2) = '0'  then
     labname := Piece(Piece(astring, '^', 4), '*', 1)
                 + ' (' + lowercase(Piece(astring, '^', 11)) + ')'
  else
    labname := Piece(astring, '^', 4);
end;

procedure TfrmGraphs.timHintPauseTimer(Sender: TObject);

  function TitleOK(aTitle: string): boolean;
  begin
    Result := false;
    if Copy(aTitle, 1, 7)= 'Ref Low' then exit
    else if Copy(aTitle, 1, 8)= 'Ref High' then exit
    else if aTitle = TXT_COMMENTS then exit
    else if aTitle = TXT_NONNUMERICS then exit
    else if aTitle = '' then exit;
    Result := true;
  end;

var
  ClickedValue, j: Integer;
  textvalue: string;
  Rct: TRect;
begin
  with FActiveGraph do
  begin
    ClickedValue := -1;
    for j := 0 to SeriesCount - 1 do
    with (Series[j] as TChartSeries) do
    begin
      if FHintStop then break;
      ClickedValue := Clicked(FX, FY);
      if ClickedValue = -1 then ClickedValue := Marks.Clicked(FX, FY);
      if ClickedValue > -1 then break;
    end;
    if FHintStop then          // stop when clicked
    begin
      timHintPause.Enabled := false;
      InactivateHint;
      FHintStop := false;
      exit;
    end;
    if (ClickedValue > -1) and ((FOnValue <> ClickedValue) or (FOnSeries <> j)) then
    begin     // on a value but not the same value or series
      if FHintWinActive then
        InactivateHint;
      if not TitleOK(Series[j].Title) then
        exit;
      FOnSeries := j;
      FOnValue := ClickedValue;
      textvalue := ValueText(FActiveGraph, Series[j], ClickedValue);
      FormatHint(textvalue);
      Rct := FHintWin.CalcHintRect(Screen.Width, textvalue, nil);
      OffsetRect(Rct, FX, FY + 20);
      Rct.Right := Rct.Right + 3;
      Rct.TopLeft := ClientToScreen(Rct.TopLeft);
      Rct.BottomRight := ClientToScreen(Rct.BottomRight);
      FHintWin.ActivateHint(Rct, textvalue);
      FHintWinActive := true;
    end
    else if (ClickedValue = -1) and ((FOnValue <> BIG_NUMBER) and (FOnSeries <> BIG_NUMBER)) then
    begin  // not on a value anymore (used to be on a value and series)
      FOnSeries := BIG_NUMBER;
      FOnValue := BIG_NUMBER;
      timHintPause.Enabled := false;
      InactivateHint;
    end;
  end;
end;

procedure TfrmGraphs.InactivateHint;
begin
    FHintWin.ReleaseHandle;
    FHintWinActive := false;
end;

procedure TfrmGraphs.mnuPopGraphStayOnTopClick(Sender: TObject);
begin
  mnuPopGraphStayOnTop.Checked := not mnuPopGraphStayOnTop.Checked;
  if mnuPopGraphStayOnTop.Checked then
  begin
    MarkFormAsStayOnTop(Self, true);
    FGraphSetting.StayOnTop := true;
  end
  else
  begin
    MarkFormAsStayOnTop(Self, false);
    FGraphSetting.StayOnTop := false;
  end;
end;

procedure TfrmGraphs.StayOnTop;
begin
  with pnlMain.Parent do
  if BorderWidth <> 1 then
  begin
     mnuPopGraphStayOnTop.Enabled :=false;
     mnuPopGraphStayOnTop.Checked := false;
  end
  else
  begin     // only use on float Graph
    mnuPopGraphStayOnTop.Enabled :=true;
    mnuPopGraphStayOnTop.Checked := not FGraphSetting.StayOnTop;
    mnuPopGraphStayOnTopClick(self);
  end;
end;

procedure TfrmGraphs.HideDates(aChart: TChart);
var
  hidedates: boolean;
begin
  with aChart do          // dateline charts always have dates
  begin
    if (aChart = chartDatelineTop) then
      hidedates := false
    else if (aChart = chartDatelineBottom) then
      hidedates := false
    else
      hidedates := not FGraphSetting.Dates;
    if hidedates then
    begin
      MarginBottom := 0;
      BottomAxis.LabelsFont.Color := chartDatelineTop.Color;
      BottomAxis.LabelsSize := 1;
      LeftAxis.LabelsFont.Color := chartDatelineTop.LeftAxis.LabelsFont.Color;
    end
    else
    begin
      MarginBottom := chartDatelineTop.MarginBottom;
      BottomAxis.LabelsFont.Color := chartDatelineTop.BottomAxis.LabelsFont.Color;
      BottomAxis.LabelsSize := chartDatelineTop.BottomAxis.LabelsSize;
      LeftAxis.LabelsFont.Color := chartDatelineTop.LeftAxis.LabelsFont.Color;
    end;
  end;
end;

procedure TfrmGraphs.InfoMessage(aCaption: string; aColor: TColor; aVisible: boolean);
begin
  pnlInfo.Caption := aCaption;
  pnlInfo.Color := aColor;
  pnlInfo.Visible := aVisible;
end;

procedure TfrmGraphs.mnuPopGraphZoomBackClick(Sender: TObject);
begin
  FFirstClick := true;
  GtslZoomHistoryFloat.Delete(GtslZoomHistoryFloat.Count - 1);
  if GtslZoomHistoryFloat.Count = 0 then mnuPopGraphResetClick(self)
  else ZoomUpdate;
end;

procedure TfrmGraphs.ZoomUpdate;
var
  lastzoom: string;
  BigTime, SmallTime: TDateTime;
begin
  lastzoom := GtslZoomHistoryFloat[GtslZoomHistoryFloat.Count - 1];
  SmallTime := StrToFloat(Piece(lastzoom, '^', 1));
  BigTime := StrToFloat(Piece(lastzoom, '^', 2));
  ZoomTo(SmallTime, BigTime);
  ZoomUpdateInfo(SmallTime, BigTime);
end;

procedure TfrmGraphs.ZoomUpdateInfo(SmallTime, BigTime: TDateTime);
var
  aString: string;
begin
  aString := TXT_ZOOMED
           + FormatDateTime('mmm d, yyyy  h:nn am/pm', SmallTime)
           + ' to ' + FormatDateTime('mmm d, yyyy  h:nn am/pm', BigTime) + '.';
  InfoMessage(aString, COLOR_ZOOM, true);
  if MergedLabsSelected then
    InfoMessage(pnlInfo.Caption + ' ' + TXT_WARNING_MERGED_LABS, COLOR_WARNING, true);
  pnlHeader.Visible := true;
end;

procedure TfrmGraphs.ZoomTo(SmallTime, BigTime: TDateTime);
var
  i: integer;
  ChildControl: TControl;
begin
  for i := 0 to scrlTop.ControlCount - 1 do
  begin
    ChildControl := scrlTop.Controls[i];
    SizeDates((ChildControl as TChart), SmallTime, BigTime);
  end;
  SizeDates(chartDatelineTop, SmallTime, BigTime);
  for i := 0 to scrlBottom.ControlCount - 1 do
  begin
    ChildControl := scrlBottom.Controls[i];
    SizeDates((ChildControl as TChart), SmallTime, BigTime);
  end;
  SizeDates(chartDatelineBottom, SmallTime, BigTime);
end;

procedure TfrmGraphs.mnuPopGraphPrintClick(Sender: TObject);
var
  topflag: boolean;
  count, i: integer;
  aAction, aDateRange, aTitle, aWarning, StrForFooter, StrForHeader: String;
  aHeader: TStringList;
  wrdApp, wrdDoc, wrdPrintDlg: Variant;
  ChildControl: TControl;
begin
  try
    wrdApp := CreateOleObject('Word.Application');
  except
    raise Exception.Create('Cannot start MS Word!');
  end;
  if Sender = mnuPopGraphPrint then
    aAction := 'PRINT'
  else
    aAction := 'COPY';
  topflag := mnuPopGraphStayOnTop.Checked and mnuPopGraphStayOnTop.Enabled;
  Screen.Cursor := crDefault;
  aTitle := 'CPRS Graphing';
  aWarning := pnlInfo.Caption;
  aDateRange :=  'Date Range: ' + cboDateRange.Text + '  Selected Items from ' +
      FormatDateTime('mm/dd/yy', FGraphSetting.LowTime) + ' to ' +
      FormatDateTime('mm/dd/yy', FGraphSetting.HighTime);
  aHeader := TStringList.Create;
  CreatePatientHeader(aHeader, aTitle, aWarning, aDateRange);
  StrForHeader := '';
  for i := 0 to aHeader.Count -1 do
    StrForHeader := StrForHeader + aHeader[i] + Chr(13);
  StrForFooter := aTitle + ' - *** WORK COPY ONLY ***' + Chr(13);
  wrdApp.Visible := False;
  wrdApp.Documents.Add;
  wrdDoc := wrdApp.Documents.Item(1);
  wrdDoc := wrdDoc.Sections.Item(1);
  wrdDoc := wrdDoc.Headers.Item(1).Range;
  wrdDoc.Font.Name := 'Courier New';
  wrdDoc.Font.Size := 9;
  wrdDoc.Text := StrForHeader;
  wrdDoc := wrdApp.Documents.Item(1);
  wrdDoc := wrdDoc.Sections.Item(1);
  wrdDoc := wrdDoc.Footers.Item(1);
  wrdDoc.Range.Font.Name := 'Courier New';
  wrdDoc.Range.Font.Size := 9;
  wrdDoc.Range.Text := StrForFooter;
  wrdDoc.PageNumbers.Add;
  wrdDoc := wrdApp.Documents.Item(1);
  if aAction = 'COPY' then
  begin
    wrdDoc.Range.Font.Name := 'Courier New';
    wrdDoc.Range.Font.Size := 9;
    wrdDoc.Range.Text := StrForHeader;
  end;
  wrdDoc.Range.InsertParagraphAfter;
  for i := 0 to scrlTop.ControlCount - 1 do           // goes from top to bottom
  begin
    ChildControl := scrlTop.Controls[i];
    if (ChildControl as TChart).Visible then
    begin
      (ChildControl as TChart).CopyToClipboardBitmap;
      wrdDoc.Range.InsertParagraphAfter;
      wrdDoc.Paragraphs.Last.Range.Paste;
    end;
  end;
  if (chartDatelineTop.SeriesCount > 0) and (not chkItemsTop.Checked) then
  begin
    chartDatelineTop.CopyToClipboardBitmap;
    wrdDoc.Range.InsertParagraphAfter;
    wrdDoc.Paragraphs.Last.Range.Paste;
  end;
  wrdDoc.Range.InsertParagraphAfter;
  wrdDoc.Paragraphs.Last.Range.Text := '   ';
  for i := 0 to scrlBottom.ControlCount - 1 do
  begin
    ChildControl := scrlBottom.Controls[i];
    if (ChildControl as TChart).Visible then
    begin
      (ChildControl as TChart).CopyToClipboardBitmap;
      wrdDoc.Range.InsertParagraphAfter;
      wrdDoc.Paragraphs.Last.Range.Paste;
    end;
  end;
  if (chartDatelineBottom.SeriesCount > 0) and (chkDualViews.Checked)
    and (not chkItemsBottom.Checked) then
  begin
    chartDatelineBottom.CopyToClipboardBitmap;
    wrdDoc.Range.InsertParagraphAfter;
    wrdDoc.Paragraphs.Last.Range.Paste;
  end;
  if aAction = 'PRINT' then
  begin
    if topflag then
    begin
      mnuPopGraphStayOnTopClick(self);
      Self.SendToBack;           // avoid print dialog being hidden behind form
    end;
    wrdPrintDlg := wrdApp.Dialogs.item(wdDialogFilePrint);
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    wrdPrintDlg.Show;
    wrdApp.Visible := false;
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    Sleep(5000);
    count := 0;
    while (wrdApp.Application.BackgroundPrintingStatus > 0) do
    begin
      Sleep(1000);
      Application.ProcessMessages;
      count := count + 1;
      if count > 3 then break;
    end;
  end;
  if aAction = 'COPY' then
  begin
    wrdDoc.Range.WholeStory;
    wrdDoc.Range.Copy;
  end;
  wrdApp.DisplayAlerts := false;
  wrdDoc.Close(false);
  wrdApp.Quit;
  wrdApp := Unassigned; // releases variant
  aHeader.Free;
  Application.ProcessMessages;
  if topflag then
    if aAction = 'PRINT' then
      mnuPopGraphStayOnTopClick(self);
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.lstViewsTopChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ViewsChange(lvwItemsTop, lstViewsTop, 'top');
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.lstViewsTopEnter(Sender: TObject);
begin
  if Sender = lstViewsTop then
    lstViewsTop.Tag := 0;                     // reset
end;

procedure TfrmGraphs.lstViewsTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //  for right mouse click make arrangements for view definition ****************
end;

procedure TfrmGraphs.lstViewsBottomChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ViewsChange(lvwItemsBottom, lstViewsBottom, 'bottom');
  Screen.Cursor := crDefault;
end;

procedure TfrmGraphs.lstViewsBottomEnter(Sender: TObject);
begin
  if Sender = lstViewsBottom then
    lstViewsBottom.Tag := 0;                     // reset
end;

procedure TfrmGraphs.lvwItemsBottomChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if FArrowKeys then
    if lvwItemsBottom.SelCount > 0 then
    begin
      if pnlItemsBottomInfo.Tag <> 1 then
        lvwItemsBottomClick(self);
      FArrowKeys := false;
    end;
end;

procedure TfrmGraphs.lvwItemsTopChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if FArrowKeys then
    if lvwItemsTop.SelCount > 0 then
    begin
      if pnlItemsTopInfo.Tag <> 1 then
        lvwItemsTopClick(self);
      FArrowKeys := false;
    end;
end;

procedure TfrmGraphs.lvwItemsTopClick(Sender: TObject);
var
  i: integer;
begin
  FFirstClick := true;
  if not FFastTrack then
    if GraphTurboOn then
      Switch;
  if lvwItemsTop.SelCount > FGraphSetting.MaxSelect then
  begin
    pnlItemsTopInfo.Tag := 1;
    lvwItemsTop.ClearSelection;
    ShowMsg('Too many items to graph');
    for i := 0 to GtslSelPrevTopFloat.Count - 1 do
      lvwItemsTop.Items[strtoint(GtslSelPrevTopFloat[i])].Selected := true;
    pnlItemsTopInfo.Tag := 0;
  end
  else
  begin
    GtslSelPrevTopFloat.Clear;
    for i := 0 to lvwItemsTop.Items.Count - 1 do
    if lvwItemsTop.Items[i].Selected then
      GtslSelPrevTopFloat.Add(inttostr(i));
    ItemsClick(Sender, lvwItemsTop, lvwItemsBottom, chkItemsTop, lstViewsTop, GtslSelCopyTop, 'top');
  end;
end;

procedure TfrmGraphs.lvwItemsTopEnter(Sender: TObject);
begin
  if ScreenReaderActive then GetScreenReader.Speak(pnlInfo.Caption);
  if lvwItemsTop.SelCount = 0 then
    if lvwItemsTop.Items.Count > 0 then
      lvwItemsTop.Items[0].Focused := true;
end;

procedure TfrmGraphs.lvwItemsTopKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN] then
    FArrowKeys := true;
end;

procedure TfrmGraphs.cboDateRangeDropDown(Sender: TObject);
begin
  if (Top + Height) > (Screen.Height - 100) then
    cboDateRange.DropDownCount := 3
  else
    cboDateRange.DropDownCount := 9;
end;

procedure TfrmGraphs.cboDateRangeExit(Sender: TObject);
begin
  inherited;
  if not chkDualViews.Checked and ShiftTabIsPressed() then
  begin
    if scrlTop.VertScrollBar.IsScrollBarVisible and scrlTop.CanFocus then memTop.SetFocus
    else begin
      Case pcTop.ActivePageIndex of
        0:  lvwItemsTop.SetFocus;
        1:  memViewsTop.SetFocus;
        2:  tsTopCustom.SetFocus;
      End;
    end;
  end;
end;

procedure TfrmGraphs.mnuPopGraphFixedClick(Sender: TObject);
begin
  with FGraphSetting do FixedDateRange := not FixedDateRange;
  ChangeStyle;
end;

//*********************

procedure TfrmGraphs.FormDestroy(Sender: TObject);
begin
  SetSize;
end;

procedure TfrmGraphs.SetFontSize(FontSize: integer);
begin   // for now, ignore changing chart font size
  with chartDatelineTop do
  begin
    LeftAxis.LabelsFont.Size := 8;
    BottomAxis.LabelsFont.Size := 8;
    Foot.Font.Size := 8;
    Legend.Font.Size := 8;
    Title.Font.Size := 8;
  end;
  with chartDatelineBottom do
  begin
    LeftAxis.LabelsFont.Size := 8;
    BottomAxis.LabelsFont.Size := 8;
    Foot.Font.Size := 8;
    Legend.Font.Size := 8;
    Title.Font.Size := 8;
  end;
end;

procedure TfrmGraphs.chkItemsBottomEnter(Sender: TObject);
begin
  if not chkDualViews.Checked then
    if pnlFooter.Visible then
      cboDateRange.SetFocus
    else
      SelectNext(ActiveControl as TWinControl, True, True);
end;

procedure TfrmGraphs.lvwItemsBottomEnter(Sender: TObject);
begin
  if lvwItemsBottom.SelCount = 0 then
    if lvwItemsBottom.Items.Count > 0 then
      lvwItemsBottom.Items[0].Focused := true;
  if not chkDualViews.Checked then
    SelectNext(ActiveControl as TWinControl, True, True);
end;

procedure TfrmGraphs.UpdateAccessibilityActions(var Actions: TAccessibilityActions);
begin
  Actions := Actions - [aaColorConversion];
end;

procedure TfrmGraphs.memTopEnter(Sender: TObject);
begin
  memTop.Color := clBtnShadow;
end;

procedure TfrmGraphs.memTopExit(Sender: TObject);
begin
  memTop.Color := clBtnFace;
end;

procedure TfrmGraphs.memBottomEnter(Sender: TObject);
begin
  memBottom.Color := clBtnShadow;
end;

procedure TfrmGraphs.memBottomExit(Sender: TObject);
begin
  memBottom.Color := clBtnFace;
end;

procedure TfrmGraphs.memTopKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP:      SendMessage(scrlTop.Handle, WM_VSCROLL, SB_LINEUP,   0);
    VK_PRIOR:   SendMessage(scrlTop.Handle, WM_VSCROLL, SB_PAGEUP,   0);
    VK_NEXT:    SendMessage(scrlTop.Handle, WM_VSCROLL, SB_PAGEDOWN, 0);
    VK_DOWN:    SendMessage(scrlTop.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    VK_HOME:    SendMessage(scrlTop.Handle, WM_VSCROLL, SB_TOP,      0);
    VK_END:     SendMessage(scrlTop.Handle, WM_VSCROLL, SB_BOTTOM,   0);
  end;
end;

procedure TfrmGraphs.memBottomKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP:      SendMessage(scrlBottom.Handle, WM_VSCROLL, SB_LINEUP,   0);
    VK_PRIOR:   SendMessage(scrlBottom.Handle, WM_VSCROLL, SB_PAGEUP,   0);
    VK_NEXT:    SendMessage(scrlBottom.Handle, WM_VSCROLL, SB_PAGEDOWN, 0);
    VK_DOWN:    SendMessage(scrlBottom.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    VK_HOME:    SendMessage(scrlBottom.Handle, WM_VSCROLL, SB_TOP,      0);
    VK_END:     SendMessage(scrlBottom.Handle, WM_VSCROLL, SB_BOTTOM,   0);
  end;
end;

initialization
  CoInitialize (nil);
end.
