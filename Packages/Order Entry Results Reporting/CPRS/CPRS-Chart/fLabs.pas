unit fLabs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, ORCtrls, ComCtrls, Grids, Buttons, fLabTest,
  fLabTests, fLabTestGroups, ORFn, TeeProcs, TeEngine, Chart, Series, Menus,
  uConst, ORDtTmRng, OleCtrls, SHDocVw, Variants, StrUtils, fBase508Form,
  VA508AccessibilityManager, ORDtTm, VclTee.TeeGDIPlus;

type
  TGrdLab508Manager = class(TVA508ComponentManager)
  private
    function GetTextToSpeak(sg: TCaptionStringGrid): String;
    function ToBlankIfEmpty(aString : String) : String;
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
  end;

  TfrmLabs = class(TfrmHSplit)
    popChart: TPopupMenu;
    popValues: TMenuItem;
    pop3D: TMenuItem;
    popZoom: TMenuItem;
    N1: TMenuItem;
    popCopy: TMenuItem;
    popZoomBack: TMenuItem;
    popDetails: TMenuItem;
    N2: TMenuItem;
    calLabRange: TORDateRangeDlg;
    dlgWinPrint: TPrintDialog;
    N3: TMenuItem;
    popPrint: TMenuItem;
    Timer1: TTimer;
    pnlRightBottom: TPanel;
    Memo1: TMemo;
    memLab: TRichEdit;
    pnlRightTop: TPanel;
    bvlHeader: TBevel;
    pnlHeader: TORAutoPanel;
    lblDateFloat: TLabel;
    pnlWorksheet: TORAutoPanel;
    chkValues: TCheckBox;
    chk3D: TCheckBox;
    ragHorV: TRadioGroup;
    chkAbnormals: TCheckBox;
    ragCorG: TRadioGroup;
    chkZoom: TCheckBox;
    pnlGraph: TORAutoPanel;
    lblGraphInfo: TLabel;
    chkGraph3D: TCheckBox;
    chkGraphValues: TCheckBox;
    chkGraphZoom: TCheckBox;
    pnlButtons: TORAutoPanel;
    lblMostRecent: TLabel;
    lblDate: TVA508StaticText;
    cmdNext: TButton;
    cmdPrev: TButton;
    cmdRecent: TButton;
    cmdOld: TButton;
    grdLab: TCaptionStringGrid;
    pnlChart: TPanel;
    lblGraph: TLabel;
    lstTestGraph: TORListBox;
    chtChart: TChart;
    serHigh: TLineSeries;
    serLow: TLineSeries;
    serTest: TLineSeries;
    pnlRightTopHeader: TPanel;
    PopupMenu2: TPopupMenu;
    Print1: TMenuItem;
    Copy1: TMenuItem;
    SelectAll1: TMenuItem;
    PopupMenu3: TPopupMenu;
    Print2: TMenuItem;
    Copy2: TMenuItem;
    SelectAll2: TMenuItem;
    GoToTop1: TMenuItem;
    GoToBottom1: TMenuItem;
    FreezeText1: TMenuItem;
    UnFreezeText1: TMenuItem;
    sptHorzRight: TSplitter;
    pnlFooter: TORAutoPanel;
    lblSpecimen: TLabel;
    lblSingleTest: TLabel;
    lblFooter: TOROffsetLabel;
    lstTests: TORListBox;
    lvReports: TCaptionListView;
    pnlLefTop: TPanel;
    lblReports: TOROffsetLabel;
    tvReports: TORTreeView;
    pnlLeftBottom: TPanel;
    splLeft: TSplitter;
    TabControl1: TTabControl;
    pnlRightTopHeaderTop: TPanel;
    lblHeading: TOROffsetLabel;
    chkMaxFreq: TCheckBox;
    lblTitle: TOROffsetLabel;
    Label1: TLabel;
    lblSample: TLabel;
    Label2: TLabel;
    WebBrowser: TWebBrowser;
    Label3: TLabel;
    pnlRightTopHeaderMid: TPanel;
    pnlRightTopHeaderMidUpper: TPanel;
    grpDateRange: TGroupBox;
    rdo1Week: TRadioButton;
    rdo1Month: TRadioButton;
    rdo6Month: TRadioButton;
    rdo1Year: TRadioButton;
    rdo2Year: TRadioButton;
    rdoAllResults: TRadioButton;
    rdoToday: TRadioButton;
    rdoDateRange: TRadioButton;
    btnClear: TButton;
    btnAppearRt: TButton;
    btnAppearLt: TButton;
    lbl508Footer: TVA508StaticText;
    sptHorzRightTop: TSplitter;
    pnlLeftBotUpper: TPanel;
    pnlOtherTests: TORAutoPanel;
    bvlOtherTests: TBevel;
    cmdOtherTests: TButton;
    lblHeaders: TOROffsetLabel;
    lstHeaders: TORListBox;
    splLeftLower: TSplitter;
    pnlLeftBotLower: TPanel;
    lblDates: TOROffsetLabel;
    lblQualifier: TOROffsetLabel;
    lstDates: TORListBox;
    lstQualifier: TORListBox;
    procedure FormCreate(Sender: TObject);
    procedure DisplayHeading(aRanges: string);
    procedure lstHeadersClick(Sender: TObject);
    procedure lstDatesClick(Sender: TObject);
    procedure cmdOtherTestsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdRecentClick(Sender: TObject);
    procedure cmdOldClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure chkValuesClick(Sender: TObject);
    procedure chk3DClick(Sender: TObject);
    procedure ragHorVClick(Sender: TObject);
    procedure ragCorGClick(Sender: TObject);
    procedure lstTestGraphClick(Sender: TObject);
    procedure chkGraphValuesClick(Sender: TObject);
    procedure chkGraph3DClick(Sender: TObject);
    procedure chkGraphZoomClick(Sender: TObject);
    procedure GotoTop1Click(Sender: TObject);
    procedure GotoBottom1Click(Sender: TObject);
    procedure FreezeText1Click(Sender: TObject);
    procedure UnfreezeText1Click(Sender: TObject);
    procedure chkZoomClick(Sender: TObject);
    procedure chtChartUndoZoom(Sender: TObject);
    procedure popCopyClick(Sender: TObject);
    procedure popChartPopup(Sender: TObject);
    procedure popValuesClick(Sender: TObject);
    procedure pop3DClick(Sender: TObject);
    procedure popZoomClick(Sender: TObject);
    procedure popZoomBackClick(Sender: TObject);
    procedure chtChartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtChartClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chtChartClickLegend(Sender: TCustomChart;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure popDetailsClick(Sender: TObject);
    procedure popPrintClick(Sender: TObject);
    procedure BeginEndDates(var ADate1, ADate2: TFMDateTime; var ADaysBack: integer);
    procedure Timer1Timer(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpdateRemoteStatus(aSiteID, aStatus: string);
    procedure lblDateEnter(Sender: TObject);
    procedure LoadTreeView;
    procedure LoadListView(aReportData: TStringList);
    procedure tvReportsClick(Sender: TObject);
    procedure lstQualifierClick(Sender: TObject);
    procedure tvReportsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvReportsCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure tvReportsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure lvReportsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState); 
    procedure SelectAll1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Print2Click(Sender: TObject);
    procedure lvReportsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvReportsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvReportsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure splLeftCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure SelectAll2Click(Sender: TObject);
    procedure chkMaxFreqClick(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure grdLabTopLeftChanged(Sender: TObject);
    procedure rdoTodayClick(Sender: TObject);
    procedure rdo1WeekClick(Sender: TObject);
    procedure rdo1MonthClick(Sender: TObject);
    procedure rdo6MonthClick(Sender: TObject);
    procedure rdo1YearClick(Sender: TObject);
    procedure rdo2YearClick(Sender: TObject);
    procedure rdoAllResultsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnAppearRtClick(Sender: TObject);
    procedure rdoDateRangeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlButtonsEnter(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
    procedure memLabEnter(Sender: TObject);
    procedure cmdNextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdOldMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdPrevMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdRecentMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnAppearRtEnter(Sender: TObject);
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure grdLabClick(Sender: TObject);
    procedure grdLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdLabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdLabMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sptHorzRightMoved(Sender: TObject);
    procedure splLeftMoved(Sender: TObject);
    procedure splLeftLowerMoved(Sender: TObject);

  private
    { Private declarations }
    SortIdx1, SortIdx2, SortIdx3: Integer;
    grdLab508Manager : TGrdLab508Manager;
    procedure HGrid(griddata: TStrings);
    procedure VGrid(griddata: TStrings);
    procedure FillGrid(agrid: TStringGrid; aitems: TStrings);
    procedure GridComments(aitems: TStrings);
    procedure FillComments(amemo: TRichEdit; aitems:TStrings);
    procedure GetInterimGrid(adatetime: TFMDateTime; direction: integer);
    procedure WorksheetChart(test: string; aitems: TStrings);
    procedure GetStartStop(var start, stop: string; aitems: TStrings);
    procedure GraphChart(test: string; aitems: TStrings);
    procedure GraphList(griddata: TStrings);
    procedure ProcessNotifications;
    procedure PrintLabGraph;
    procedure GoRemoteOld(Dest: TStringList; AItem, AReportID: Int64; AQualifier, ARpc, AHSType, ADaysBack, ASection: string; ADate1, ADate2: TFMDateTime);
    procedure GoRemote(Dest: TStringList; AItem: string; AQualifier, ARpc: string; AHSTag: string; AHDR: string; aFHIE: string);
    procedure ShowTabControl;
    procedure HideTabControl;
    procedure ChkBrowser;
    procedure CommonComponentVisible(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12: Boolean);
    procedure RightTopHeader(MidSize: Integer);
    procedure RDOChange(rdoIndex: integer);
    procedure BlankWeb;
  public
    procedure ClearPtData; override;
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure DisplayPage; override;
    procedure SetFontSize(NewFontSize: Integer); override;
    function FMToDateTime(FMDateTime: string): TDateTime;
    procedure RequestPrint; override;
    procedure SaveUserSettings(var posD, posH, posL, posV: integer);
    procedure LoadUserSettings(posD, posH, posL, posV: integer);
end;

const
  LabSplitters = 'frmLabsSplitters';

var
  frmLabs: TfrmLabs;
  uFormat: integer;
  uPrevReportNode: TTreeNode;
  uDate1, uDate2: Tdatetime;
  tmpGrid: TStringList;
  uMostRecent: TStringList;
  uLabLocalReportData: TStringList;  //Storage for Local report data
  uLabRemoteReportData: TStringList; //Storage for Remote lab query
  uUpdateStat: boolean;              //flag turned on when remote status is being updated
  uTreeStrings: TStrings;
  uReportInstruction: String;        //User Instructions
  uColChange: string;                //determines when column widths have changed
  uQualifier: string;
  uReportType: string;
  uSortOrder: string;
  uMaxOcc: string;
  UpdatingLvReports: Boolean;        //Currently updating lvReports
  uColumns: TStringList;
  uNewColumn: TListColumn;
  uQualifierType: Integer;           //Report qualifier type
  uHState: string;
  uFirstSort: Integer;
  uSecondSort: Integer;
  uThirdSort: Integer;
  ulvSelectOn: boolean;              //flag turned on when multiple items in lvReports control have been selected
  uUseRadioButton: boolean;          //Parameter to determine use of DateTime Radio Button Selection
  uRDOChanging: boolean;             //Set to true when a Radio button is selected
  ulstDatesChanging: boolean;        //Set to true when lstDates item is selected to keep Radio button from selecting lstDatesClick again
  ulstQualifierChanging: boolean;    //Set to true when lstQualifier item is selected to keep Radio Button from selecting lstQualifierClick again
  uRDOStick: boolean;                //When a DateTime Radio Button is selected, make it stick for subsequent report selections
  uRDOPick: Integer;                 //Matches the Selected Radio Button Tab #
  uDateOverride: boolean;            //Set to true if selected report has a maximum # of days defined
  uTVLabReportSet: boolean;          //Set when report is selected from tvReportsClick, used to prevent multiple loading of reports
  MouseClick: boolean;               //Set when MouseButtonDown enters pnlButtons
  upnlRightTopHeight_1: Integer;     //For saving height of top right panel when splitter is moved for Most Recent Report
  upnlRightTopHeight_2: Integer;     //For saving height of top right panel when splitter is moved for Worksheet
  upnlRightTopHeight_3: Integer;     //For saving height of top right panel when splitter is moved for uQualifierType = QT_HSWPCOMPONENT
  upnlLeftTopHeight_1: Integer;      //For saving height of top left panel when splitter is moved for Worksheet
  upnlLeftTopHeight_2: Integer;      //For saving height of top left panel when splitter is moved for Selected Tests
  upnlLeftTopHeight_3: Integer;      //For saving height of top left panel when splitter is moved for Cumulative
  upnlLeftTopHeight_4: Integer;      //For saving height of top left panel when splitter is moved for uQualifierType = QT_HSWPCOMPONENT

implementation

uses uCore, rLabs, rCore, rCover, rOrders, fLabPrint, fFrame, fRptBox, Printers, fReportsPrint,
     clipbrd, rReports, rGraphs, activex, mshtml, VA508AccessibilityRouter, uReports,
  VAUtils;

const
//  BlankWebPage = 'http://www.google.com/';
  BlankWebPage = 'about:blank';
  QT_OTHER      = 0;
  QT_MOSTRECENT     = 1;
  QT_DATERANGE  = 2;
  QT_IMAGING    = 3;
  QT_NUTR       = 4;
  QT_PROCEDURES = 19;
  QT_SURGERY    = 28;
  QT_HSCOMPONENT   = 5;
  QT_HSWPCOMPONENT = 6;
  CT_LABS     = 9;            // ID for Labs tab used by frmFrame
  TX_NOREPORT     = 'No report is currently selected.';
  TX_NOREPORT_CAP = 'No Report Selected';
  ZOOM_PERCENT = 99;        // padding for inflating margins
  HTML_PRE  = '<html><head><style>' + CRLF +
              'PRE {font-size:8pt;font-family: "Courier New", "monospace"}' + CRLF +
              '</style></head><body><pre>';
  HTML_POST = CRLF + '</pre></body></html>';

{$R *.DFM}

var
  uFrozen: Boolean;
  uGraphingActivated: Boolean;
  uGraphTestClicked: Boolean;          // used to avoid mouse wheel selection
  uRemoteCount: Integer;
  uHTMLDoc: string;
  uReportRPC: string;
  uHTMLPatient: ANSIstring;
  uEmptyImageList: TImageList;
  uRptID: String;
  uDirect: String;
  ColumnToSort: Integer;
  ColumnSortForward: Boolean;

procedure TfrmLabs.RequestPrint;
var
  aID : integer;
begin
  aID := 0;
  if CharAt(uRPTID,2) =':' then
    aID := strToInt(piece(uRPTID,':',1));
  if (aID = 0) and (CharAt(uRPTID,3) =':') then
    aID := StrToInt(piece(uRptID,':',1));
  if uReportType = 'M' then
    begin
      InfoBox(TX_NOREPORT, TX_NOREPORT_CAP, MB_OK);
      Exit;
    end;
  if (uReportType = 'V') and (length(piece(uHState,';',2)) > 0) then
    begin
      if lvReports.Items.Count < 1 then
        begin
          InfoBox('There are no items to be printed.', 'No Items to Print', MB_OK);
          Exit;
        end;
      if lvReports.SelCount < 1 then
        begin
          InfoBox('Please select one or more items from the list to be printed.', 'No Items Selected', MB_OK);
          Exit;
        end;
    end;
  if uQualifierType = QT_DATERANGE then
    begin      //      = 2
      if lstQualifier.ItemIndex < 0 then
        begin
          InfoBox('Please select from one of the Date Range items before printing', 'Incomplete Information', MB_OK);
        end
      else
        PrintReports(uRptID, piece(uRemoteType,'^',4));
    end
  else
    if uQualifierType = 0 then
      begin
        if aID = 0 then InfoBox(TX_NOREPORT, TX_NOREPORT_CAP, MB_OK);
        case aID of
          1: begin
               InfoBox('Unable to print ''Most Recent'' report.', 'No Print Available', MB_OK);
             end;
          2: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
          3: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
          4: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
          5: begin
               InfoBox('Unable to print ''Worksheet'' report.', 'No Print Available', MB_OK);
             end;
          6: begin
               if chtChart.Visible then PrintLabGraph;
             end;
          8: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
          9: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
         10: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
         20: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
         21: begin
               PrintLabs(IntToStr(aID), piece(uRemoteType,'^',4), lstDates.ItemIEN);
             end;
        end;
      end
    else
      PrintLabs(uRptID, piece(uRemoteType,'^',4), lstDates.ItemIEN);
end;


procedure TfrmLabs.FormCreate(Sender: TObject);
var
  aList: TStrings;
begin
  inherited;
  LabRowObjects := TLabRowObject.Create;
  PageID := CT_LABS;
  uFrozen := False;
  aList := TStringList.Create;
  FastAssign(rpcGetGraphSettings, aList);
  uGraphingActivated := aList.Count > 0;
  uGraphTestClicked := false;
  aList.Free;
  uRemoteCount := 0;
  tmpGrid := TStringList.Create;
  uMostRecent := TStringList.Create;
  uLabLocalReportData := TStringList.Create;
  uLabRemoteReportData := TStringList.Create;
  uColumns := TStringList.Create;
  uTreeStrings := TStringList.Create;
  if uEmptyImageList = nil then
    uEmptyImageList := TImageList.Create(Self);
//  uEmptyImageList.Width := 0;
  uPrevReportNode := tvReports.Items.GetFirstNode;
  tvReports.Selected := uPrevReportNode;
  if Patient.Inpatient then lstDates.ItemIndex := 2 else lstDates.ItemIndex := 4;
  lblSingleTest.Caption := '';
  lblSpecimen.Caption := '';
  SerTest.GetHorizAxis.ExactDateTime := true;
  SerTest.GetHorizAxis.Increment := DateTimeStep[dtOneMinute];
  grdLab508Manager := TGrdLab508Manager.Create;
  amgrMain.ComponentManager[grdLab] := grdLab508Manager;
  memo1.Visible := false;
  uRDOChanging := false;
  ulstDatesChanging := false;
  ulstQualifierChanging := false;
  uRDOStick := false;
  uDateOverride := false;
  uRDOPick := 0;
  if User.HasKey('XUPROGMODE') then
    begin
      btnAppearRt.Enabled := true;
    end;
  if ScreenReaderActive then
  begin
    lbl508Footer.Enabled := true;
    lbl508Footer.TabStop := true;
  end;
  MouseClick := false;
end;

procedure TfrmLabs.UpdateRemoteStatus(aSiteID, aStatus: string);
var
  j: integer;
  s: string;
  c: boolean;
begin
  if uUpdateStat = true then exit;                 //uUpdateStat also looked at in fFrame
  uUpdateStat := true;
  for j := 0 to frmFrame.lstCIRNLocations.Items.Count - 1 do
    begin
      s := frmFrame.lstCIRNLocations.Items[j];
      c := frmFrame.lstCIRNLocations.checked[j];
      if piece(s, '^', 1) = aSiteID then
        begin
          frmFrame.lstCIRNLocations.Items[j] := pieces(s, '^', 1, 3) + '^' + aStatus;
          frmFrame.lstCIRNLocations.checked[j] := c;
        end;
    end;
  uUpdateStat := false;
end;

function TfrmLabs.AllowContextChange(var WhyNot: string): Boolean;
var
  i: integer;
begin
  Result := inherited AllowContextChange(WhyNot);  // sets result = true
  if Timer1.Enabled = true then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'A remote data query in progress will be aborted.';
             Result := False;
           end;
      '0': if WhyNot = 'COMMIT' then
             begin
               with RemoteSites.SiteList do for i := 0 to Count - 1 do
                 if TRemoteSite(Items[i]).Selected then
                 if Length(TRemoteSite(Items[i]).LabRemoteHandle) > 0 then
                   begin
                     TRemoteSite(Items[i]).ReportClear;
                     TRemoteSite(Items[i]).LabQueryStatus := '-1^Aborted';
                     TabControl1.OnChange(nil);
                   end;
               Timer1.Enabled := false;
               Result := True;
             end;
    end;
end;

procedure TfrmLabs.ClearPtData;
begin
  inherited ClearPtData;
  if Assigned(WebBrowser) then begin
    uHTMLDoc := '';
    BlankWeb;
  end; 
  Timer1.Enabled := False;
  memLab.Lines.Clear;
  uMostRecent.Clear;
  uLabLocalReportData.Clear;
  uLabRemoteReportData.Clear;
  TabControl1.Tabs.Clear;
  HideTabControl;
  tmpGrid.Clear;
  lvReports.SmallImages := uEmptyImageList;
  with grdLab do
  begin
    RowCount := 1;
    ColCount := 1;
    Cells[0, 0] := '';
  end;
end;

procedure TfrmLabs.DisplayPage;
var
  i: integer;
begin
  inherited DisplayPage;
  frmFrame.mnuFilePrint.Tag := CT_LABS;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  memLab.SelStart := 0;
  uHTMLPatient := AnsiString('<DIV align left>'
                  + '<TABLE width="75%" border="0" cellspacing="0" cellpadding="1">'
                  + '<TR valign="bottom" align="left">'
                  + '<TD nowrap><B>Patient: ' + Patient.Name + '</B></TD>'
                  + '<TD nowrap><B>' + Patient.SSN + '</B></TD>'
                  + '<TD nowrap><B>Age: ' + IntToStr(Patient.Age) + '</B></TD>'
                  + '</TR></TABLE></DIV><HR>');
                  //the preferred method would be to use headers and footers
                  //so this is just an interim solution.
  uUseRadioButton := UseRadioButtons;
  if uUseRadioButton then
    begin
      pnlRightTopHeaderMid.Visible := true;
      lblDates.Visible := false;
      lblQualifier.Visible := false;
      lstQualifier.Visible := false;
      lstDates.Visible := false;
      splLeftLower.Visible := false;
      pnlLeftBotLower.Visible := false;
    end
  else
    begin
      pnlRightTopHeaderMid.Visible := false;
    end;

  if InitPage then
    begin
      uColChange := '';
      uMaxOcc := '';
      LoadTreeView;
    end;

  if InitPatient and not (CallingContext = CC_NOTIFICATION) then
    begin
      uColChange := '';
      if Patient.Inpatient then lstDates.ItemIndex := 2 else lstDates.ItemIndex := 4;
      if uRDOStick and (uRDOPick > 0) then lstDates.ItemIndex := uRDOPick;
      lvReports.SmallImages := uEmptyImageList;
      lvReports.Items.Clear;
      lvReports.Columns.Clear;
      lblTitle.Caption := '';
      lvReports.Caption := '';
      memLab.Parent := pnlRightBottom;
      memLab.Align := alClient;
      memLab.Clear;
      uReportInstruction := '';
      uLabLocalReportData.Clear;
      for i := 0 to RemoteSites.SiteList.Count - 1 do
        TRemoteSite(RemoteSites.SiteList.Items[i]).ReportClear;
      StatusText('');
      with tvReports do
        if Items.Count > 0 then
          begin
            tvReports.Selected := tvReports.Items.GetFirstNode;
            tvReportsClick(self);
          end;
    end;
  case CallingContext of
    CC_INIT_PATIENT:  if not InitPatient then
      begin
        if Patient.Inpatient then lstDates.ItemIndex := 2 else lstDates.ItemIndex := 4;
        if uRDOStick and (uRDOPick > 0) then lstDates.ItemIndex := uRDOPick;
        lvReports.SmallImages := uEmptyImageList;
        lstQualifier.Clear;
        lvReports.SmallImages := uEmptyImageList;
        lvReports.Items.Clear;
        splLeft.Visible := false;
        pnlLeftBottom.Visible := false;
        with tvReports do
          if Items.Count > 0 then
            begin
              tvReports.Selected := tvReports.Items.GetFirstNode;
              tvReportsClick(self);
            end;
      end;
    CC_NOTIFICATION:  ProcessNotifications;

    //This corrects the reload of the labs when switching back to the tab.
    {This code was causing the processing of Lab notifications to display
     the wrong set of labs for a given notification the 1st notification
     after selecting/switching patients.  Upon checking the problem that
     this code was trying to solve, we found that the problem no longer
     exists, which may be a result of subsequent changes for similar
     issues found during development/testing of V28 (CQ 18267, 18268)
     CC_CLICK: if not InitPatient then
      begin
        //Clear our local variables
        OrigReportCat := nil;
        OrigDateIEN := -1;
        OrigSelection := -1;
        OrigDateItemID := '';

        //What was last selected before they switched tabs.
        if tvReports.Selected <> nil then OrigReportCat := tvReports.Selected;
        if lstDates.ItemIEN > 0 then OrigDateIEN := lstDates.ItemIEN;
        if lvReports.Selected <> nil then OrigSelection := lvReports.Selected.Index;
        if lstQualifier.ItemID <> '' then OrigDateItemID := lstQualifier.ItemID;

        //Load the tree and select the last selected
        if OrigReportCat <> nil then begin
         tvReports.Select(OrigReportCat);
         tvReportsClick(self);
        end;

        //Did they click on a date (lstDates box)
        if OrigDateIEN > -1 then begin
          lstDates.SelectByIEN(OrigDateIEN);
          lstDatesClick(self);
        end;

        //Did they click on a date (lstQualifier)
        if OrigDateItemID <> '' then begin
          lstQualifier.SelectByID(OrigDateItemID);
          lstQualifierClick(self);
        end;

        //Did they click on a lab
        if OrigSelection > -1 then begin
         lvReports.Selected := lvReports.Items[OrigSelection];
         lvReportsSelectItem(self, lvReports.Selected, true);
        end;
      end; }
  end;
end;

procedure TfrmLabs.SetFontSize(NewFontSize: Integer);
var
  pnlRightTopPct: Real;
  frmLabsHeight, pnlRightHeight: Integer;

begin
  pnlRightTopPct := (pnlRightTop.Height / (pnlRight.Height - (sptHorzRight.Height + pnlRightTopHeader.Height)));
  pnlRightTop.Constraints.MaxHeight := 20;
  inherited SetFontSize(NewFontSize);
  grdLab.Font.Size := NewFontSize;
  memLab.Font.Size := NewFontSize;
  pnlButtons.Font.Size := NewFontSize;
  cmdOld.Font.Size := NewFontSize;
  cmdPrev.Font.Size := NewFontSize;
  cmdNext.Font.Size := NewFontSize;
  cmdRecent.Font.Size := NewFontSize;
  lblMostRecent.Font.Size := NewFontSize;
  lblSample.Font.Size := NewFontSize;
  Memo1.Font.Size := NewFontSize;
  frmLabsHeight := frmFrame.pnlPatientSelectedHeight - (frmFrame.pnlToolbar.Height + frmFrame.stsArea.Height + frmFrame.tabPage.Height + 2);
  pnlRightHeight := frmLabsHeight;
  pnlRightTop.Constraints.MaxHeight := 0;
  pnlRightTop.Height := (Round((pnlRight.Height - (sptHorzRight.Height + pnlRightTopHeader.Height)) * pnlRightTopPct) - 14);
  if frmFrame.Height <> frmFrame.frmFrameHeight then
  begin
    pnlRight.Height := pnlRightHeight;
    frmLabs.Height := frmLabsHeight;
    frmFrame.Height := frmFrame.frmFrameHeight;
  end;
  FormResize(self);
end;

procedure TfrmLabs.LoadListView(aReportData: TStringList);
var
  j,k,aErr: integer;
  aTmpAray: TStringList;
  aColCtr, aCurCol, aCurRow, aColID: integer;
  x,y,z,c,aSite: string;
  ListItem: TListItem;
begin
  aSite := '';
  aErr := 0;
  ListItem := nil;
  case uQualifierType of
    QT_HSCOMPONENT:
      begin      //      = 5
        if (length(piece(uHState,';',2)) > 0) then
          begin
            with lvReports do
              begin
                ViewStyle := vsReport;
                for j := 0 to aReportData.Count - 1 do
                  begin
                    if piece(aReportData[j],'^',1) = '-1' then  //error condition, most likely remote call
                      continue;
                    ListItem := Items.Add;
                    aSite := piece(aReportData[j],'^',1);
                    ListItem.Caption := piece(aSite,';',1);
                    for k := 2 to uColumns.Count do
                      begin
                        ListItem.SubItems.Add(piece(aReportData[j],'^',k));
                      end;
                  end;
                if aReportData.Count = 0 then
                  begin
                    uReportInstruction := '<No Data Available>';
                    memLab.Lines.Clear;
                    memLab.Lines.Add(uReportInstruction);
                  end
                else
                  memLab.Lines.Clear;
              end;
          end;
      end;
    QT_HSWPCOMPONENT:
      begin     //      = 6
        if (length(piece(uHState,';',2)) > 0) then //and (chkText.Checked = false) then
          begin
            aTmpAray := TStringList.Create;
            aCurRow := 0;
            aCurCol := 0;
            aColCtr := 9;
            aTmpAray.Clear;
            with lvReports do
              begin
                for j := 0 to aReportData.Count - 1 do
                  begin
                    x := aReportData[j];
                    aColID := StrToIntDef(piece(x,'^',1),-1);
                    if aColID < 0 then    //this is an error condition most likely an incompatible remote call
                      continue;
                    if aColID > (uColumns.Count - 1) then
                      begin
                        aErr := 1;
                        continue;           //extract is out of sync with columns defined in 101.24
                      end;
                    if aColID < aColCtr then
                      begin
                        if aTmpAray.Count > 0 then
                          begin
                            if aColCtr = 1 then
                              begin
                                ListItem := Items.Add;
                                aSite := piece(aTmpAray[j],'^',1);
                                ListItem.Caption := piece(aSite,';',1);
                                ListItem.SubItems.Add(IntToStr(aCurRow) + ':' + IntToStr(aCurCol));
                              end
                            else
                              begin
                                c := aTmpAray[0];
                                if piece(uColumns.Strings[aCurCol],'^',4) = '1' then
                                  c := c + '...';
                                z := piece(c,'^',1);
                                y := copy(c, (pos('^', c)), 9999);
                                if pos('^',y) > 0 then
                                  begin
                                    while pos('^',y) > 0 do
                                      begin
                                        y := copy(y, (pos('^', y)+1), 9999);
                                        z := z + '^' + y;
                                      end;
                                        ListItem.SubItems.Add(z);
                                  end
                                else
                                  begin
                                    ListItem.SubItems.Add(y);
                                  end;
                              end;
                            LabRowObjects.Add(aSite, IntToStr(aCurRow) + ':' + IntToStr(aCurCol), uColumns.Strings[aCurCol], aTmpAray);
                            aTmpAray.Clear;
                          end;
                        aColCtr := 0;
                        aCurCol := aColID;
                        aCurRow := aCurRow + 1;
                      end
                    else
                      if aColID = aCurCol then
                        begin
                          z := '';
                          y := piece(x,'^',2);
                          if length(y) > 0 then z := y;
                          y := copy(x, (pos('^', x)+1), 9999);
                          if pos('^',y) > 0 then
                            begin
                              while pos('^',y) > 0 do
                                begin
                                  y := copy(y, (pos('^', y)+1), 9999);
                                  z := z + '^' + y;
                                end;
                              aTmpAray.Add(z);
                            end
                          else
                            begin
                              aTmpAray.Add(y);
                            end;
                          continue;
                        end;
                    if aTmpAray.Count > 0 then
                      begin
                        if aColCtr = 1 then
                          begin
                            ListItem := Items.Add;
                            aSite := piece(aTmpAray[0],'^',1);
                            ListItem.Caption := piece(aSite,';',1);
                            ListItem.SubItems.Add(IntToStr(aCurRow) + ':' + IntToStr(aCurCol));
                          end
                        else
                          begin
                            c := aTmpAray[0];
                            if piece(uColumns.Strings[aCurCol],'^',4) = '1' then
                              c := c + '...';
                            ListItem.SubItems.Add(c);
                          end;
                        LabRowObjects.Add(aSite, IntToStr(aCurRow) + ':' + IntToStr(aCurCol), uColumns.Strings[aCurCol], aTmpAray);
                        aTmpAray.Clear;
                      end;
                    aCurCol := aColID;
                    Inc(aColCtr);
                    y := '';
                    for k := 2 to 10 do
                      if length(piece(x,'^',k)) > 0 then
                        begin
                          if length(y) > 0 then y := y + '^' + piece(x,'^',k)
                          else y := y + piece(x,'^',k);
                        end;
                    aTmpAray.Add(y);
                    if aColCtr > 0 then
                      while aColCtr < aCurCol do
                        begin
                          ListItem.SubItems.Add('');
                          Inc(aColCtr);
                        end;
                  end;
                if aTmpAray.Count > 0 then
                  begin
                    if aColCtr = 1 then
                      begin
                        ListItem := Items.Add;
                        aSite := piece(aTmpAray[0],'^',1);
                        ListItem.Caption := piece(aSite,';',1);
                        ListItem.SubItems.Add(IntToStr(aCurRow) + ':' + IntToStr(aCurCol));
                      end
                    else
                      begin
                        c := aTmpAray[0];
                        if piece(uColumns.Strings[aCurCol],'^',4) = '1' then
                          c := c + '...';
                        ListItem.SubItems.Add(c);
                      end;
                    LabRowObjects.Add(aSite, IntToStr(aCurRow) + ':' + IntToStr(aCurCol), uColumns.Strings[aCurCol], aTmpAray);
                    aTmpAray.Clear;
                  end;
              end;
            aTmpAray.Free;
          end;
      end;
  end;
  if aErr = 1 then
    if User.HasKey('XUPROGMODE') then
      ShowMsg('Programmer message: One or more Column ID''s in file 101.24 do not match ID''s coded in extract routine');
  if lvReports.Items.Count>0 then lvReports.Items[0].Selected := True;
end;

procedure TfrmLabs.DisplayHeading(aRanges: string);
var
  x,x1,x2,y,z,DaysBack: string;
  d1,d2: TFMDateTime;
begin
  with lblTitle do
  begin
    x := '';
    y := '';
    z := '';
    if tvReports.Selected = nil then
     tvReports.Selected := tvReports.Items.GetFirstNode;
    if tvReports.Selected.Parent <> nil then
      x := tvReports.Selected.Parent.Text + ' ' + tvReports.Selected.Text
    else
      x :=  tvReports.Selected.Text;
      x1 := '';
      x2 := '';
    if (uReportType <> 'M') and (not(uRptID = '1:MOST RECENT')) then
      begin
        if CharAt(aRanges, 1) = 'd' then
          begin
            if length(piece(aRanges,';',2)) > 0 then
              begin
                x2 := '  Max/site:' + piece(aRanges,';',2);
                aRanges := piece(aRanges,';',1);
              end;
            DaysBack := Copy(aRanges, 2, Length(aRanges));
            if DaysBack = '' then DaysBack := '7';
            if DaysBack = '0' then
              aRanges := 'T' + ';T'
            else
              if Copy(aRanges, 2, 1) = 'T' then
                aRanges := DaysBack + ';T'
              else
                aRanges := 'T-' + DaysBack + ';T';
          end;
        if length(piece(aRanges,';',1)) > 0 then
          begin
            d1 := ValidDateTimeStr(piece(aRanges,';',1),'');
            d2 := ValidDateTimeStr(piece(aRanges,';',2),'');
            y := FormatFMDateTime('dddddd',d1);
            if strToInt(Copy(y,8,4)) < 1925 then y := 'EARLIEST RESULT';
            z := FormatFMDateTime('dddddd',d2);
            x1 := ' [From: ' + y + ' to ' + z + ']';
          end;
        if length(piece(aRanges,';',3)) > 0 then
          x2 := '  Max/site:' + piece(aRanges,';',3);
        case uQualifierType of
          QT_DATERANGE:
              x := x + x1;
          QT_HSCOMPONENT:
              x := x + x1 + x2;
          QT_HSWPCOMPONENT:
              x := x + x1 + x2;
          QT_IMAGING:
              x := x + x1 + x2;
          0:
              x := x + x1;
        end;
      end;
    if piece(uRemoteType, '^', 9) = '1' then x := x + ' <<ONLY REMOTE DATA INCLUDED IN REPORT>>';
    Caption := x;
  end;
  lvReports.Caption := x;
end;

procedure TfrmLabs.LoadTreeView;
var
  i: integer;
  currentNode, parentNode, grandParentNode, gtGrandParentNode: TTreeNode;
  x: string;
  addchild, addgrandchild, addgtgrandchild: boolean;
begin
  tvReports.Items.Clear;
  memLab.Clear;
  uHTMLDoc := '';
  BlankWeb;
  lvReports.SmallImages := uEmptyImageList;
  lvReports.Items.Clear;
  uTreeStrings.Clear;
  lvReports.Caption := '';
  ListLabReports(uTreeStrings);
  addchild := false;
  addgrandchild := false;
  addgtgrandchild := false;
  parentNode := nil;
  grandParentNode := nil;
  gtGrandParentNode := nil;
  currentNode := nil;
  for i := 0 to uTreeStrings.Count - 1 do
    begin
      x := uTreeStrings[i];
      if UpperCase(Piece(x,'^',1))='[PARENT END]' then
        begin
          if addgtgrandchild = true then
            begin
              currentNode := gtgrandParentNode;
              addgtgrandchild := false;
            end
          else
            if addgrandchild = true then
              begin
                currentNode := grandParentNode;
                addgrandchild := false;
              end
            else
              begin
                currentNode := parentNode;
                addchild := false;
              end;
          continue;
        end;
      if UpperCase(Piece(x,'^',1))='[PARENT START]' then
        begin
          if addgtgrandchild = true then
            currentNode := tvReports.Items.AddChildObject(gtGrandParentNode,Piece(x,'^',3),MakeReportTreeObject(Pieces(x,'^',2,21)))
          else
            if addgrandchild = true then
              begin
                currentNode := tvReports.Items.AddChildObject(grandParentNode,Piece(x,'^',3),MakeReportTreeObject(Pieces(x,'^',2,21)));
                addgtgrandchild := true;
                gtgrandParentNode := currentNode;
              end
            else
              if addchild = true then
                begin
                  currentNode := tvReports.Items.AddChildObject(parentNode,Piece(x,'^',3),MakeReportTreeObject(Pieces(x,'^',2,21)));
                  addgrandchild := true;
                  grandParentNode := currentNode;
                end
              else
                begin
                  currentNode := tvReports.Items.AddObject(currentNode,Piece(x,'^',3),MakeReportTreeObject(Pieces(x,'^',2,21)));
                  parentNode := currentNode;
                  addchild := true;
                end;
        end
      else
        if addchild = false then
          begin
            currentNode := tvReports.Items.AddObject(currentNode,Piece(x,'^',2),MakeReportTreeObject(x));
            parentNode := currentNode;
          end
        else
          begin
            if addgtgrandchild = true then
                currentNode := tvReports.Items.AddChildObject(gtGrandParentNode,Piece(x,'^',2),MakeReportTreeObject(x))
            else
              if addgrandchild = true then
                  currentNode := tvReports.Items.AddChildObject(grandParentNode,Piece(x,'^',2),MakeReportTreeObject(x))
              else
                  currentNode := tvReports.Items.AddChildObject(parentNode,Piece(x,'^',2),MakeReportTreeObject(x));
          end;
    end;
end;

procedure TfrmLabs.LoadUserSettings(posD, posH, posL, posV: integer);
begin
  if posD <> 0 then splLeft.Top := posD;
  if posH <> 0 then sptHorz.Left := posH;
  if posL <> 0 then sptHorzRightTop.Top := posL;
  if posV <> 0 then sptHorzRight.Top := posV;
end;

procedure TfrmLabs.lstHeadersClick(Sender: TObject);
var
  Current, Desired: integer;
begin
  inherited;
  if uFrozen = True then memo1.visible := False;
  Current := SendMessage(memLab.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  Desired := lstHeaders.ItemIEN;
  SendMessage(memLab.Handle, EM_LINESCROLL, 0, Desired - Current - 1);
end;

procedure TfrmLabs.lstQualifierClick(Sender: TObject);
  var
  MoreID: String;  //Restores MaxOcc value
  aRemote, aHDR, aFHIE, aMax, aQualAdd, aQualifier, aStartTime, aStopTime: string;
  i: integer;
  x,x1,x2: string;
  aQualMatch: boolean;
begin
  inherited;
  if uFrozen = True then
    begin
      memo1.visible := False;
      memo1.TabStop := False;
    end;
  ulstQualifierChanging := true;
  aQualifier  :=  PReportTreeObject(tvReports.Selected.Data)^.Qualifier;
  aStartTime  :=  Piece(aQualifier,';',1);
  aStopTime   :=  Piece(aQualifier,';',2);
  MoreID := ';' + Piece(uQualifier,';',3);
  if chkMaxFreq.checked = true then
    begin
      MoreID := '';
      SetPiece(uQualifier,';',3,'');
    end;
  aMax := piece(uQualifier,';',3);
  if (CharAt(lstQualifier.ItemID,1) = 'd')
    and (length(aMax)>0)
    and (StrToInt(aMax)<101) then
      MoreID := ';101';
  Timer1.Interval := 3000;
  aRemote :=  piece(uRemoteType,'^',1);
  aHDR := piece(uRemoteType,'^',7);
  aFHIE := piece(uRemoteType,'^',8);
  SetPiece(uRemoteType,'^',5,lstQualifier.ItemID);
  uHTMLDoc := '';
  if uReportType = 'H' then
    begin
      WebBrowser.Visible := true;
      WebBrowser.TabStop := true;
      BlankWeb;
      WebBrowser.BringToFront;
      memLab.Visible := false;
      memLab.TabStop := false;
    end
  else
    begin
      WebBrowser.Visible := false;
      WebBrowser.TabStop := false;
      memLab.Visible := true;
      memLab.TabStop := true;
      memLab.BringToFront;
      RedrawActivate(memLab.Handle);
    end;
  uLabLocalReportData.Clear;
  uLabRemoteReportData.Clear;
  for i := 0 to RemoteSites.SiteList.Count - 1 do
   TRemoteSite(RemoteSites.SiteList.Items[i]).ReportClear;
  uRemoteCount := 0;
  if lstQualifier.ItemID = 'ds' then
    begin
      with calLabRange do
       if Not (Execute) then
         begin
           lstQualifier.ItemIndex := -1;
           ulstQualifierChanging := false;
           Exit;
         end
       else if (Length(TextOfStart) > 0) and (Length(TextOfStop) > 0) then
         begin
           if (Length(piece(uRemoteType,'^',6)) > 0) and (StrToInt(piece(uRemoteType,'^',6)) > 0) then
             if abs(FMDateTimeToDateTime(FMDateStart) - FMDateTimeToDateTime(FMDateStop)) > StrToInt(piece(uRemoteType,'^',6)) then
               begin
                 InfoBox('The Date Range selected is greater than the' + CRLF + 'Maximum Days Allowed of '
                   + piece(uRemoteType,'^',6) + ' for this report.' + CRLF + CRLF
                   + 'Please reselect a valid Date Range.', 'No Report Generated',MB_OK);
                 uDateOverride := true;
                 lstQualifier.ItemIndex := -1;
                 rdoDateRange.Checked := false;
                 rdoToday.Checked := false;
                 rdo1Week.Checked := false;
                 rdo1Month.Checked := false;
                 rdo6Month.Checked := false;
                 rdo1Year.Checked := false;
                 rdo2Year.Checked := false;
                 rdoAllResults.Checked := false;
                 DisplayHeading('d' + piece(uRemoteType,'^',6) + MoreID);
                 aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
                 aQualMatch := false;
                 for i := 0 to lstQualifier.Items.Count - 1 do
                   if lstQualifier.Items[i] = aQualAdd then
                     begin
                       aQualMatch := true;
                       lstQualifier.ItemIndex := i;
                       break;
                     end;
                 if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                 exit;
               end;
           lstQualifier.ItemIndex := lstQualifier.Items.Add(RelativeStart +
             ';' + RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
           lstDates.ItemIndex := lstDates.Items.Add(RelativeStart + ';' +
                RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
           DisplayHeading(lstQualifier.ItemID + MoreID);
           SetPiece(uRemoteType,'^',5,lstQualifier.ItemID);
           uRDOStick := true;
           uRDOPick := lstQualifier.ItemIndex;
         end
       else
         begin
           lstQualifier.ItemIndex := -1;
           InfoBox('Invalid Date Range entered. Please try again','Invalid Date/time entry',MB_OK);
           if (Execute) and (Length(TextOfStart) > 0) and (Length(TextOfStop) > 0) then
             begin
               lstQualifier.ItemIndex := lstQualifier.Items.Add(RelativeStart +
                 ';' + RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
               lstDates.ItemIndex := lstDates.Items.Add(RelativeStart + ';' +
                RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
               DisplayHeading(lstQualifier.ItemID + MoreID);
               SetPiece(uRemoteType,'^',5,lstQualifier.ItemID);
               uRDOStick := true;
               uRDOPick := lstQualifier.ItemIndex;
             end
           else
             begin
               lstQualifier.ItemIndex := -1;
               InfoBox('No Report Generated!','Invalid Date/time entry',MB_OK);
               exit;
             end;
         end;
    end;
  if (CharAt(lstQualifier.ItemID,1) = 'd') and (Length(piece(uRemoteType,'^',6)) > 0) and (StrToInt(piece(uRemoteType,'^',6)) > 0) then
    if ExtractInteger(lstQualifier.ItemID) > (StrToInt(piece(uRemoteType,'^',6))) then
      begin
        InfoBox('The Date Range selected is greater than the' + CRLF + 'Maximum Days Allowed of '
          + piece(uRemoteType,'^',6) + ' for this report.' + CRLF + CRLF
          + 'Please reselect a valid Date Range.', 'No Report Generated',MB_OK);
        uDateOverride := true;
        lstQualifier.ItemIndex := -1;
        rdoDateRange.Checked := false;
        rdoToday.Checked := false;
        rdo1Week.Checked := false;
        rdo1Month.Checked := false;
        rdo6Month.Checked := false;
        rdo1Year.Checked := false;
        rdo2Year.Checked := false;
        rdoAllResults.Checked := false;
        DisplayHeading('d' + piece(uRemoteType,'^',6) + MoreID);
        aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
        aQualMatch := false;
        for i := 0 to lstQualifier.Items.Count - 1 do
          if lstQualifier.Items[i] = aQualAdd then
            begin
              aQualMatch := true;
              lstQualifier.ItemIndex := i;
              break;
            end;
        if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
        exit;
      end;
  Screen.Cursor := crHourGlass;
  StatusText('Retrieving ' + lblTitle.Caption + '...');
  uReportInstruction := #13#10 + 'Retrieving data...';
  memLab.Lines.Add(uReportInstruction);
  if WebBrowser.Visible then begin
    uHTMLDoc := HTML_PRE + uReportInstruction + HTML_POST;
    BlankWeb;
  end;
  case uQualifierType of
      QT_HSCOMPONENT:
        begin     //      = 5
          lvReports.SmallImages := uEmptyImageList;
          lvReports.Items.Clear;
          memLab.Lines.Clear;
          LabRowObjects.Clear;
          if ((aRemote = '1') or (aRemote = '2')) then
            GoRemote(uLabRemoteReportData, 'L:' + uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState, aHDR, aFHIE)
          else
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
          if not(piece(uRemoteType, '^', 9) = '1') then
            if (length(piece(uHState,';',2)) > 0) then
              begin
                if not(aRemote = '2') then
                  LoadReportText(uLabLocalReportData, 'L:' + uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                LoadListView(uLabLocalReportData);
              end
            else
              begin
                if ((aRemote = '1') or (aRemote = '2')) then
                  ShowTabControl;
                LoadReportText(uLabLocalReportData, 'L:' + uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                if uLabLocalReportData.Count < 1 then
                  begin
                    uReportInstruction := '<No Report Available>';
                    memLab.Lines.Add(uReportInstruction);
                  end
                else
                  begin
                    QuickCopy(uLabLocalReportData,memLab);
                    TabControl1.OnChange(nil);
                  end;
              end;
        end;
      QT_HSWPCOMPONENT:
        begin      //      = 6
          lvReports.SmallImages := uEmptyImageList;
          lvReports.Items.Clear;
          LabRowObjects.Clear;
          memLab.Lines.Clear;
          if ((aRemote = '1') or (aRemote = '2'))  then
            begin
              Screen.Cursor := crDefault;
              GoRemote(uLabRemoteReportData, 'L:' + uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState, aHDR, aFHIE);
            end
          else
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
          if not(piece(uRemoteType, '^', 9) = '1') then
            if (length(piece(uHState,';',2)) > 0) then
              begin
                if not(aRemote = '2') then
                  LoadReportText(uLabLocalReportData, 'L:' + uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                LoadListView(uLabLocalReportData);
              end
            else
              begin
                if not (aRemote = '2') then
                  begin
                    LoadReportText(uLabLocalReportData, 'L:' + uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                    if uLabLocalReportData.Count < 1 then
                      begin
                        uReportInstruction := '<No Report Available>';
                        memLab.Lines.Add(uReportInstruction);
                      end
                    else
                      QuickCopy(uLabLocalReportData,memLab);
                  end;
              end;
        end
      else
        begin
          if ((aRemote = '1') or (aRemote = '2')) then
            GoRemote(uLabRemoteReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState, aHDR, aFHIE)
          else
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
          if not(piece(uRemoteType, '^', 9) = '1') then
            begin
             LoadReportText(uLabLocalReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
             if TabControl1.TabIndex < 1 then
               QuickCopy(uLabLocalReportData,memLab);
            end;
          Screen.Cursor := crDefault;
        end;
    end;
    Screen.Cursor := crDefault;
    StatusText('');
    memLab.Lines.Insert(0,' ');
    memLab.Lines.Delete(0);
    if WebBrowser.Visible then begin
        if uReportType = 'R' then
          uHTMLDoc := HTML_PRE + uLabLocalReportData.Text + HTML_POST
        else
          uHTMLDoc := String(uHTMLPatient) + uLabLocalReportData.Text;
        BlankWeb;
      end;
  if uRDOChanging = false then
    begin
      rdoToday.Checked := false;
      rdo1Week.Checked := false;
      rdo1Month.Checked := false;
      rdo6Month.Checked := false;
      rdo1Year.Checked := false;
      rdo2Year.Checked := false;
      rdoAllResults.Checked := false;
      if lstQualifier.ItemIndex = 1 then rdoToday.Checked := true;
      if lstQualifier.ItemIndex = 2 then rdo1Week.Checked := true;
      if lstQualifier.ItemIndex = 3 then rdo1Month.Checked := true;
      if lstQualifier.ItemIndex = 4 then rdo6Month.Checked := true;
      if lstQualifier.ItemIndex = 5 then rdo1Year.Checked := true;
      if lstQualifier.ItemIndex = 6 then rdo2Year.Checked := true;
      if lstQualifier.ItemIndex = 7 then rdoAllResults.Checked := true;
      uRDOStick := true;
      uRDOPick := lstQualifier.ItemIndex;
    end;
  if uRDOStick and (not uDateOverride) and (uRDOPick > 0) and uRDOChanging then
    begin
      lstQualifier.ItemIndex := uRDOPick;
    end;
  x := lstQualifier.DisplayText[lstQualifier.ItemIndex];
  x1 := piece(x,' ',1);
  x2 := piece(x,' ',3);
  if (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
    DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2) + MoreID)
  else
    DisplayHeading(lstQualifier.ItemID + MoreID);
  StatusText('');
  ulstQualifierChanging := false;
end;

procedure TfrmLabs.lblDateEnter(Sender: TObject);
begin
  inherited;
  amgrMain.AccessText[lblDate] := 'Date Collected '+lblDate.Caption;
end;

procedure TfrmLabs.lstDatesClick(Sender: TObject);
var
  tmpList: TStringList;
  daysback: integer;
  date1, date2: TFMDateTime;
  today: TDateTime;
  i: integer;
  x,x1,x2,aID: string;
begin
  inherited;
  uRemoteCount := 0;
  Timer1.Interval := 3000;
  if uFrozen = True then memo1.visible := False;
  Screen.Cursor := crHourGlass;
  DisplayHeading('');
  uHTMLDoc := '';
  chkBrowser;
  ulstDatesChanging := true;
  if (lstDates.ItemID = 'S') then
  begin
    with calLabRange do
    begin
      if Execute then
        if Length(TextOfStart) > 0 then
          if Length(TextOfStop) > 0 then
            begin
              lstDates.ItemIndex := lstDates.Items.Add(RelativeStart + ';' +
                RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
              lstQualifier.ItemIndex := lstQualifier.Items.Add(RelativeStart + ';' +
                RelativeStop + U + TextOfStart + ' to ' + TextOfStop);
              DisplayHeading('');
            end
          else
            lstDates.ItemIndex := -1
        else
          lstDates.ItemIndex := -1
      else
        lstDates.ItemIndex := -1;
    end;
  end;
  today := FMToDateTime(floattostr(FMToday));
  if lstDates.ItemIEN > 0 then
    begin
      daysback := lstDates.ItemIEN;
      date1 := FMToday;
      If daysback = 1 then
        date2 := DateTimeToFMDateTime(today)
      Else
        date2 := DateTimeToFMDateTime(today - daysback);
    end
  else
    BeginEndDates(date1,date2,daysback);
  date1 := date1 + 0.2359;
  uHTMLDoc := '';
  BlankWeb;
  aID := piece(uRptID,':',1);
  if aID = '21' then
    begin                // Cumulative
      lstHeaders.Clear;
      memLab.Clear;
      uLabLocalReportData.Clear;
      uLabRemoteReportData.Clear;
      StatusText('Retrieving data for cumulative report...');
      GoRemoteOld(uLabRemoteReportData,21,2,'',uReportRPC,'',IntToStr(daysback),'',date1,date2);
      TabControl1.OnChange(nil);
      Cumulative(uLabLocalReportData, Patient.DFN, daysback, date1, date2, uReportRPC);
      splLeft.Visible := true;
      splLeftLower.Visible := true;
      if lstHeaders.Height < 20 then lstHeaders.Height := 50;
      if uLabLocalReportData.Count > 0 then
       begin
         TabControl1.OnChange(nil);
         if lstHeaders.Items.Count > 0 then
           begin
             lstHeaders.ItemIndex := 0;
             pnlLeftBottom.Visible := true;
             splLeft.Visible := true;
             lstHeaders.TabStop := true;
             if pnlLeftBotUpper.Height < 150 then pnlLeftBotUpper.Height := 150;
           end;
       end;
      memLab.Lines.Insert(0,' ');
      memLab.Lines.Delete(0);
    end
  else if aID = '3' then
    begin            // Interim
      memLab.Clear;
      uLabLocalReportData.Clear;
      uLabRemoteReportData.Clear;
      StatusText('Retrieving data for interim report...');
      GoRemoteOld(uLabRemoteReportData,3,3,'',uReportRPC,'','','',date1,date2);
      TabControl1.OnChange(nil);
      Interim(uLabLocalReportData, Patient.DFN, date1, date2, uReportRPC);
      if uLabLocalReportData.Count < 1 then
       uLabLocalReportData.Add('<No results for this date range.>');
      if TabControl1.TabIndex < 1 then
       QuickCopy(uLabLocalReportData,memLab);
      memLab.Lines.Insert(0,' ');
      memLab.Lines.Delete(0);
      memLab.SelStart := 0;
    end
  else if aID = '4' then
    begin            // Interim for Selected Tests
      memLab.Clear;
      uLabLocalReportData.Clear;
      uLabRemoteReportData.Clear;
      try
       StatusText('Retrieving data for selected tests...');
       FastAssign(InterimSelect(Patient.DFN, date1, date2, lstTests.Items), uLabLocalReportData);
       if uLabLocalReportData.Count > 0 then
         QuickCopy(uLabLocalReportData,memLab)
       else
         memLab.Lines.Add('<No results for selected tests in this date range.>');
       memLab.SelStart := 0;
      finally
      end;
    end
  else if aID = '5' then
    begin            // Worksheet
      chtChart.BottomAxis.Automatic := true;
      chkZoom.Checked := false;
      chkAbnormals.Checked := false;
      memLab.Clear;
      uLabLocalReportData.Clear;
      uLabRemoteReportData.Clear;
      grdLab.Align := alClient;
      StatusText('Retrieving data for worksheet...');
      FastAssign(Worksheet(Patient.DFN, date1, date2,
       Piece(lblSpecimen.Caption, '^', 1), lstTests.Items), tmpGrid);
      if ragHorV.ItemIndex = 0 then
       HGrid(tmpGrid)
      else
       VGrid(tmpGrid);
      GraphList(tmpGrid);
      GridComments(tmpGrid);
      ragCorGClick(self);
    end
  else if aID = '6' then
    begin            // Graph
     if not uGraphingActivated then
       begin
         chtChart.BottomAxis.Automatic := true;
         chkGraphZoom.Checked := false;
         chkGraphZoomClick(self);
         memLab.Clear;
         uLabLocalReportData.Clear;
         uLabRemoteReportData.Clear;
         tmpList := TStringList.Create;
         try
           StatusText('Retrieving data for graph...');
           FastAssign(GetChart(Patient.DFN, date1, date2,
             Piece(lblSpecimen.Caption, '^', 1),
             Piece(lblSingleTest.Caption, '^', 1)), tmpList);
           if tmpList.Count > 1 then
           begin
             chtChart.Visible := true;
             GraphChart(lblSingleTest.Caption, tmpList);
             //chtChart.ZoomPercent(ZOOM_PERCENT);
             for i := strtoint(Piece(tmpList[0], '^', 1)) + 1 to tmpList.Count - 1
               do memLab.Lines.Add(tmpList[i]);
             if memLab.Lines.Count < 2 then
               memLab.Lines.Add('<No comments on specimens.>');
             memLab.SelStart := 0;
             lblGraph.Visible := false;
           end
           else
           begin
             lblGraph.Left := chtChart.Left + ((chtChart.Width - lblGraph.Width) div 2);
             lblGraph.Top := 2;
             lblGraph.Visible := true;
             if Piece(lblSpecimen.Caption, '^', 1) = '0' then
               pnlChart.Caption := '<No results can be graphed for ' +
                 Piece(lblSingleTest.Caption, '^', 2) + ' in this date range.> '
                 + 'Results may be available, but cannot be graphed. Please try an alternate view.'
             else
               pnlChart.Caption := '<No results can be graphed for ' +
                 Piece(lblSingleTest.Caption, '^', 2)
                 + ' (' + Piece(lblSpecimen.Caption, '^', 2) +
                   ') in this date range.> '
                 + 'Results may be available, but cannot be graphed. Please try an alternate view.';
             chtChart.Visible := false;
           end;
         finally
           tmpList.Free;
         end;
       end;
    end
  else if aID = '9' then
    begin            // Micro
      memLab.Clear;
      uLabLocalReportData.Clear;
      uLabRemoteReportData.Clear;
      StatusText('Retrieving microbiology data...');
      GoRemoteOld(uLabRemoteReportData,4,4,'',uReportRPC,'','','',date1,date2);
      TabControl1.OnChange(nil);
      Micro(uLabLocalReportData, Patient.DFN, date1, date2, uReportRPC);
      if uLabLocalReportData.Count < 1 then
       uLabLocalReportData.Add('<No microbiology results for this date range.>');
      if TabControl1.TabIndex < 1 then
       QuickCopy(uLabLocalReportData,memLab);
      memLab.Lines.Insert(0,' ');
      memLab.Lines.Delete(0);
      memLab.SelStart := 0;
    end
  else if aID = '10' then
    begin           // Lab Status
      memLab.Clear;
      uLabLocalReportData.Clear;
      uLabRemoteReportData.Clear;
      StatusText('Retrieving lab status data...');
      GoRemoteOld(uLabRemoteReportData,10,1,'',uReportRPC,'',IntToStr(daysback),'',date1,date2);
      TabControl1.OnChange(nil);
      Reports(uLabLocalReportData,Patient.DFN, 'L:10', '', IntToStr(daysback),'',
       date1, date2, uReportRPC);
      if uLabLocalReportData.Count < 1 then
        uLabLocalReportData.Add('<No laboratory orders for this date range.>');
      if TabControl1.TabIndex < 1 then
        QuickCopy(uLabLocalReportData,memLab);
      memLab.Lines.Insert(0,' ');
      memLab.Lines.Delete(0);
      memLab.SelStart := 0;
    end
  else begin          //Anything Else
         lstHeaders.Clear;
         memLab.Clear;
         uLabLocalReportData.Clear;
         uLabRemoteReportData.Clear;
         StatusText('Retrieving lab data...');
         GoRemoteOld(uLabRemoteReportData, 1, 1, '', uReportRPC, '', IntToStr(daysback), '', date1, date2);
         TabControl1.OnChange(nil);
         Reports(uLabLocalReportData,Patient.DFN, 'L:' + Piece(uRptID,'^',1), '',
           IntToStr(daysback), '', date1, date2, uReportRPC);
         if uLabLocalReportData.Count < 1 then
           uLabLocalReportData.Add('<No data for this date range.>');
         if TabControl1.TabIndex < 1 then
           QuickCopy(uLabLocalReportData,memLab);
         memLab.Lines.Insert(0,' ');
         memLab.Lines.Delete(0);
         memLab.SelStart := 0;
       end;
  if uReportType = 'R' then
    uHTMLDoc := HTML_PRE + uLabLocalReportData.Text + HTML_POST
  else
    uHTMLDoc := String(uHTMLPatient) + uLabLocalReportData.Text;
  Screen.Cursor := crDefault;
  if uRDOChanging = false then
    begin
      rdoToday.Checked := false;
      rdo1Week.Checked := false;
      rdo1Month.Checked := false;
      rdo6Month.Checked := false;
      rdo1Year.Checked := false;
      rdo2Year.Checked := false;
      rdoAllResults.Checked := false;
      if lstDates.ItemIndex = 1 then rdoToday.Checked := true;
      if lstDates.ItemIndex = 2 then rdo1Week.Checked := true;
      if lstDates.ItemIndex = 3 then rdo1Month.Checked := true;
      if lstDates.ItemIndex = 4 then rdo6Month.Checked := true;
      if lstDates.ItemIndex = 5 then rdo1Year.Checked := true;
      if lstDates.ItemIndex = 6 then rdo2Year.Checked := true;
      if lstDates.ItemIndex = 7 then rdoAllResults.Checked := true;
      uRDOStick := true;
      uRDOPick := lstDates.ItemIndex;
    end;
  if uRDOStick and (uRDOPick > 0) and uRDOChanging then lstDates.ItemIndex := uRDOPick;
  x := lstDates.DisplayText[lstDates.ItemIndex];
  x1 := piece(x,' ',1);
  x2 := piece(x,' ',3);
  if not(uRptID = '1:MOST RECENT') and (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
    DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2))
  else
    DisplayHeading('d' + lstDates.ItemID);
  StatusText('');
  ulstDatesChanging := false;
end;

procedure TfrmLabs.cmdOtherTestsClick(Sender: TObject);
begin
  inherited;
  tvReportsClick(self);
end;

procedure TfrmLabs.GraphList(griddata: TStrings);
var
  i, j: integer;
  ok: boolean;
  testname, testnum, testnum1, line: string;
begin
  lstTestGraph.Clear;
  for i := 0 to lstTests.Items.Count - 1 do
  begin
    testnum := Piece(lstTests.Items[i], '^', 1);
    testname := Piece(lstTests.Items[i], '^', 2);
    ok := false;
    for j := strtoint(Piece(griddata[0], '^', 4)) + 1 to strtointdef(Piece(griddata[0], '^', 5), 0) do
    begin
      testnum1 := Piece(griddata[j - 1], '^', 1);
      if testnum1 = testnum then
      begin
        ok := true;
        line := testnum + '^' + testname + ' (' + MixedCase(Piece(griddata[j - 1], '^', 2)) + ')^';
        line := line + Pieces(griddata[j - 1], '^', 3, 6);
        lstTestGraph.Items.Add(line);
      end;
    end;
    if not ok then lstTestGraph.Items.Add(lstTests.Items[i]);
  end;
end;

procedure TfrmLabs.grdLabClick(Sender: TObject);
var
  itemid: string;
begin
  //clicking on row on graph brings up graph of that lab test
  //uses menu hint to hold type^item^date (63^lab_test_ien^collection_date_time)
  if (uRptID = '1:MOST RECENT') and uGraphTestClicked then
  begin
    itemid := '63^' + Piece(uMostRecent.Strings[grdLab.Row], '^', 1);
    itemid := itemid + '^' + lblDateFloat.Caption;
    itemid := itemid + '^^' + Pieces(uMostRecent.Strings[grdLab.Row], '^', 2, 6);
    frmFrame.mnuToolsGraphing.Hint := itemid;
    frmFrame.mnuToolsGraphingClick(self);
  end;
end;

procedure TfrmLabs.grdLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  uGraphTestClicked := true;
end;

procedure TfrmLabs.grdLabMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  uGraphTestClicked := false;
end;

procedure TfrmLabs.grdLabMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
  uGraphTestClicked := false;
end;

procedure TfrmLabs.grdLabTopLeftChanged(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if piece(uRptID,':',1) ='1' then
    begin
      for i := 2 to grdLab.RowCount do
        grdLab.Cells[0,i] := '';
      if not(grdLab.TopRow = 1) then
        grdLab.Cells[0,grdLab.TopRow] := lblDate.Caption;
    end;
end;

procedure TfrmLabs.HGrid(griddata: TStrings);
var
  testcnt, datecnt, datacnt, linecnt, offset, x, y, i: integer;
  DisplayDateTime: string;
begin
  offset := 0;
  testcnt := strtoint(Piece(griddata[offset], '^', 1));
  datecnt := strtoint(Piece(griddata[offset], '^', 2));
  datacnt := strtoint(Piece(griddata[offset], '^', 3));
  linecnt := testcnt + datecnt + datacnt;
  if chkAbnormals.Checked and (linecnt > 0) then
  begin
    offset := linecnt + 1;
    testcnt := strtoint(Piece(griddata[offset], '^', 1));
    datecnt := strtoint(Piece(griddata[offset], '^', 2));
    datacnt := strtoint(Piece(griddata[offset], '^', 3));
    linecnt := testcnt + datecnt + datacnt;
  end;
  with grdLab do
  begin
    if testcnt = 0 then ColCount := 3 else ColCount := testcnt + 2;
    if datecnt = 0 then RowCount := 2 else RowCount := datecnt + 1;
    DefaultColWidth := ResizeWidth( BaseFont, MainFont, 60);
    ColWidths[0] := ResizeWidth( BaseFont, MainFont, 80);
    FixedCols := 2;
    FixedRows := 1;
    for y := 0 to RowCount - 1 do
      for x := 0 to ColCount - 1 do
        Cells[x, y] := '';
    Cells[0, 0] := 'Date/Time';
    Cells[1, 0] := 'Specimen';
    for i := 1 to testcnt do
    begin
      Cells[i + 1, 0] := Piece(griddata[i + offset], '^', 3);
    end;
    if datecnt = 0 then
    begin
      Cells[0, 1] := 'no results';
      for x := 1 to ColCount - 1 do
        Cells[x, 1] := '';
    end;
    for i := testcnt + 1 to testcnt + datecnt do
    begin
      //------------------------------------------------------------------------------------------
      //v27.2 - RV - PSI-05-118 / Remedy HD0000000123277 - don't show "00:00" if no time present
      if LabPatchInstalled then        // Requires lab patch in const "PSI_05_118"
      begin
        DisplayDateTime := Piece(griddata[i + offset], '^', 2);
        if length(DisplayDateTime) > 7 then
          Cells[0, i - testcnt] := FormatFMDateTime('c',MakeFMDateTime(DisplayDateTime))
        else if length(DisplayDateTime) > 0 then
          Cells[0, i - testcnt] := FormatFMDateTime('ddddd',MakeFMDateTime(DisplayDateTime))
        else
          Cells[0, i - testcnt] := FormatFMDateTime('c',MakeFMDateTime(Piece(griddata[i + offset], '^', 2)));
      end
      else                             // If no lab patch in const "PSI_05_118", continue as is
      begin
        Cells[0, i - testcnt] := FormatFMDateTime('c',MakeFMDateTime(Piece(griddata[i + offset], '^', 2)));
      end;
      //------------------------------------------------------------------------------------------
      Cells[1, i - testcnt] := MixedCase(Piece(griddata[i + offset], '^', 4)) + '  ' + Piece(griddata[i + offset], '^', 5);
    end;
    for i := testcnt + datecnt + 1 to linecnt do
    begin
      y := strtoint(Piece(griddata[i + offset], '^', 1));
      x := strtoint(Piece(griddata[i + offset], '^', 2)) + 1;
      Cells[x, y]  := Piece(griddata[i + offset], '^', 3) + ' ' + Piece(griddata[i + offset], '^', 4);
    end;
  end;
end;

procedure TfrmLabs.VGrid(griddata: TStrings);
var
  testcnt, datecnt, datacnt, linecnt, offset, x, y, i: integer;
  DisplayDateTime: string;
begin
  offset := 0;
  testcnt := strtoint(Piece(griddata[offset], '^', 1));
  datecnt := strtoint(Piece(griddata[offset], '^', 2));
  datacnt := strtoint(Piece(griddata[offset], '^', 3));
  linecnt := testcnt + datecnt + datacnt;
  if chkAbnormals.Checked and (linecnt > 0) then
  begin
    offset := linecnt + 1;
    testcnt := strtoint(Piece(griddata[offset], '^', 1));
    datecnt := strtoint(Piece(griddata[offset], '^', 2));
    datacnt := strtoint(Piece(griddata[offset], '^', 3));
    linecnt := testcnt + datecnt + datacnt;
  end;
  with grdLab do
  begin
    if datecnt = 0 then ColCount := 2 else ColCount := datecnt + 1;
    if testcnt = 0 then RowCount := 3 else RowCount := testcnt + 2;
    DefaultColWidth := ResizeWidth( BaseFont, MainFont, 80);
    ColWidths[0] := ResizeWidth( BaseFont, MainFont, 60);
    FixedCols := 1;
    FixedRows := 2;
    for y := 0 to RowCount - 1 do
      for x := 0 to ColCount - 1 do
        Cells[x, y] := '';
    Cells[0, 0] := 'Date/Time';
    Cells[0, 1] := 'Specimen';
    for i := 1 to testcnt do
    begin
      Cells[0, i + 1] := Piece(griddata[i + offset], '^', 3);
    end;
    if datecnt = 0 then
    begin
      Cells[1, 0] := 'no results';
      for x := 1 to RowCount - 1 do
        Cells[x, 1] := '';
    end;
    for i := testcnt + 1 to testcnt + datecnt do
    begin
      //------------------------------------------------------------------------------------------
      if LabPatchInstalled then        // Requires lab patch in const "PSI_05_118"
      begin
        DisplayDateTime := Piece(griddata[i + offset], '^', 2);
        if length(DisplayDateTime) > 7 then
          Cells[i - testcnt, 0] := FormatFMDateTime('c',MakeFMDateTime(DisplayDateTime))
        else if length(DisplayDateTime) > 0 then
          Cells[i - testcnt, 0] := FormatFMDateTime('ddddd',MakeFMDateTime(DisplayDateTime))
        else
          Cells[i - testcnt, 0] := FormatFMDateTime('c',MakeFMDateTime(Piece(griddata[i + offset], '^', 2)));
      end
      else                             // If no lab patch in const "PSI_05_118", continue as is
      begin
        Cells[i - testcnt, 0] := FormatFMDateTime('c',MakeFMDateTime(Piece(griddata[i + offset], '^', 2)));
      end;
      //------------------------------------------------------------------------------------------
      Cells[i - testcnt, 1] := MixedCase(Piece(griddata[i + offset], '^', 4)) + ' ' + Piece(griddata[i + offset], '^', 5);
    end;
    for i := testcnt + datecnt + 1 to linecnt do
    begin
      x := strtoint(Piece(griddata[i + offset], '^', 1));
      y := strtoint(Piece(griddata[i + offset], '^', 2)) + 1;
      Cells[x, y]  := Piece(griddata[i + offset], '^', 3) + ' ' + Piece(griddata[i + offset], '^', 4);
    end;
  end;
end;

procedure TfrmLabs.GridComments(aitems: TStrings);
var
  i, start: integer;
begin
  start := strtointdef(Piece(aitems[0], '^', 5), 1);
  memLab.Clear;
  uLabLocalReportData.Clear;
  uLabRemoteReportData.Clear;
  for i := start to aitems.Count - 1 do
    memLab.Lines.Add(aitems[i]);
  if (memLab.Lines.Count = 0) and (aitems.Count > 1) then
    memLab.Lines.Add('<No comments on specimens.>');
  memLab.SelStart := 0;
end;

procedure TfrmLabs.FormDestroy(Sender: TObject);
var
  i: integer;
  aColChange: string;
begin
  inherited;
  if length(uColChange) > 0 then
    begin
      aColChange := '';
      for i := 0 to lvReports.Columns.Count - 1 do
        aColChange := aColChange + IntToStr(lvReports.Column[i].width) + ',';
      if (Length(aColChange) > 0) and (aColChange <> piece(uColchange,'^',2)) then
        SaveColumnSizes(piece(uColChange,'^',1) + '^' + aColChange);
      uColChange := '';
    end;
  RemoteQueryAbortAll;
  tmpGrid.free;
  uMostRecent.Free;
  uLabLocalReportData.Free;
  uLabRemoteReportData.Free;
  uTreeStrings.Free;
  uEmptyImageList.Free;
  uColumns.Free;
  LabRowObjects.Free;
end;

procedure TfrmLabs.FillGrid(agrid: TStringGrid; aitems: TStrings);
var
  testcnt, x, y, i: integer;
begin
  testcnt := strtoint(Piece(aitems[0], '^', 1));
  with agrid do
  begin
    if testcnt = 0 then RowCount := 3 else RowCount := testcnt + 1;
    ColCount := 6;
    DefaultColWidth := agrid.Width div ColCount - 2;
    ColWidths[0] := 120;               //agrid.Width div 6;
    ColWidths[1] := agrid.Width div 4; //5
    ColWidths[5] := agrid.Width div 7; //5
    ColWidths[3] := agrid.Width div 14;//12
    ColWidths[4] := agrid.Width div 12;//9
    ColWidths[2] := agrid.Width div 5; //agrid.Width - ColWidths[0] - ColWidths[1] - ColWidths[3] - ColWidths[4] - 8;
    FixedCols := 0;
    FixedRows := 1;
    for y := 0 to RowCount - 1 do
      for x := 0 to ColCount - 1 do
        Cells[x, y] := '';
    Cells[0, 0] := 'Collection Date/Time';
    Cells[1, 0] := 'Test';
    Cells[2, 0] := 'Result / Status';
    Cells[3, 0] := 'Flag';
    Cells[4, 0] := 'Units';
    Cells[5, 0] := 'Ref Range';
    for i := 1 to testcnt do
    begin
      if i = 1 then Cells[0, i] := lblDate.Caption
      else Cells[0, i] := '';
      Cells[1, i] := Piece(aitems[i], '^', 2);
      Cells[2, i] := Piece(aitems[i], '^', 3);
      Cells[3, i] := Piece(aitems[i], '^', 4);
      Cells[4, i] := Piece(aitems[i], '^', 5);
      Cells[5, i] := Piece(aitems[i], '^', 6);
    end;
  end;
end;

procedure TfrmLabs.FillComments(amemo: TRichEdit; aitems:TStrings);
var
  testcnt, i: integer;
  specimen, accession, provider: string;
begin
  amemo.Lines.Clear;
  specimen := Piece(aitems[0], '^', 5);
  accession := Piece(aitems[0], '^', 6);
  provider := Piece(aitems[0], '^', 7);
  amemo.Lines.Add('Specimen: ' + specimen + ';    Accession: ' + accession + ';    Provider: ' + provider);
  testcnt := strtoint(Piece(aitems[0], '^', 1));
  for i := testcnt + 1 to aitems.Count - 1 do
    amemo.Lines.Add(aitems[i]);
  amemo.SelStart := 0;
end;

procedure TfrmLabs.GetInterimGrid(adatetime: TFMDateTime; direction: integer);
var
  tmpList: TStringList;
  nexton, prevon: boolean;
  newest, oldest, DisplayDate, aCollection, aSpecimen, aX: string;
  i,ix: integer;
begin
  tmpList := TStringList.Create;
  GetNewestOldest(Patient.DFN, newest, oldest);  //****** PATCH
  prevon := true;
  aCollection := '';
  aSpecimen := '';
  aX := '';
  lblSample.Caption := '';
  lblSample.Color := clBtnFace;
  try
    FastAssign(InterimGrid(Patient.DFN, adatetime, direction, uFormat), tmpList);
    if tmpList.Count > 0 then
    begin
      lblDateFloat.Caption := Piece(tmpList[0], '^', 3);
      uFormat := strtointdef(Piece(tmpList[0], '^', 9), 1);
      //------------------------------------------------------------------------------------------
      //v27.1 - RV - PSI-05-118 / Remedy HD0000000123277 - don't show "00:00" if no time present
      if LabPatchInstalled then        // Requires lab patch in const "PSI_05_118"
      begin
        DisplayDate := Piece(tmpList[0], '^', 3);
        if length(DisplayDate) > 7 then
          lblDate.Caption := FormatFMDateTime('dddddd hh:nn', strtofloat(DisplayDate))
        else if length(DisplayDate) > 0 then
          lblDate.Caption := FormatFMDateTime('dddddd', strtofloat(DisplayDate))
        else
          if length(lblDateFloat.Caption) > 0 then
            lblDate.Caption := FormatFMDateTime('dddddd hh:nn', strtofloat(lblDateFloat.Caption));
      end
      else                             // If no lab patch in const "PSI_05_118", continue as is
      begin
        if length(lblDateFloat.Caption) > 0 then
          lblDate.Caption := FormatFMDateTime('dddddd hh:nn', strtofloat(lblDateFloat.Caption));
      end;
      //------------------------------------------------------------------------------------------
      if length(lblDateFloat.Caption) < 1
      then
      begin
        lblDateFloat.Caption := FloatToStr(adatetime);
        nexton := false;
      end
      else
      begin
        nexton := lblDateFloat.Caption <> newest;
        prevon := lblDateFloat.Caption <> oldest;
      end;
      if (not nexton) and (uFormat = 3) then
        nexton := true;
      if (not prevon) and (uFormat = 2) then
        prevon := true;
      if Piece(tmpList[0], '^', 2) = 'CH' then
        begin
          lblSample.Caption := 'Specimen: ' + Piece(tmpList[0], '^', 5);
          lblSample.Color := clCream;
        end;
      if Piece(tmpList[0], '^', 2) = 'MI' then
        begin
          for i  := 0 to tmpList.Count - 1 do
            begin
              if i > 5 then break;
              if ansiContainsStr(tmpList[i],'Collection sample:') then
                begin
                  ix := 0;
                  if length(piece(tmpList[i], ':',2)) > 0 then
                    begin
                      ix := Length(piece(tmpList[i], ':',2));
                      if ix > 15 then ix := ix - 15;
                    end;
                  aCollection := '  Sample: ' + LeftStr(piece(tmpList[i], ':',2),ix);
                end;
            end;
          for i  := 0 to tmpList.Count - 1 do
            begin
              if i > 5 then break;
              if ansiContainsStr(tmpList[i],'Site/Specimen:') then
                begin
                  aSpecimen := 'Specimen: ' + piece(tmpList[i], ':', 2);
                end;
            end;
          aX := aSpecimen + aCollection;
          if Length(aX) > 0 then
            begin
              lblSample.Caption := aX;
              lblSample.Color := clCream;
            end;
        end;
    end
    else
    begin
      lblDateFloat.Caption := '';
      lblDate.Caption := '';
      nexton := false;
      prevon := false;
    end;
    cmdNext.Enabled := nexton;
    cmdRecent.Enabled := nexton;
    cmdPrev.Enabled := prevon;
    cmdOld.Enabled := prevon;
    if cmdOld.Enabled and cmdRecent.Enabled then
      lblMostRecent.Visible := false
    else
    begin
      lblMostRecent.Visible := true;
      if (not cmdOld.Enabled) and (not cmdRecent.Enabled) and (not (tmpList.Count > 0)) then
        lblMostRecent.Caption := 'No Lab Data'
      else if cmdOld.Enabled then
        lblMostRecent.Caption := 'Most Recent Lab Data'
      else
        if (tmpList.Count > 0) and (not cmdRecent.Enabled) then lblMostRecent.Caption := 'Most Recent Lab Data'
        else lblMostRecent.Caption := 'Oldest Lab Data';
    end;
    if tmpList.Count > 0 then
    begin
      if Piece(tmpList[0], '^', 2) = 'CH' then
      begin
        FastAssign(tmpList, uMostRecent);
        FillGrid(grdLab, tmpList);
        FillComments(memLab, tmpList);
        pnlRightTop.Height := pnlRight.Height - (pnlRight.Height div 3);
        memLab.Lines.Insert(0,' ');
        memLab.Lines.Delete(0);
        memLab.SelStart := 0;
        grdLab.Align := alClient;
        grdLab.Visible := true;
        memLab.Visible := true;
        pnlFooter.Height := lblHeading.Height + 5;
        pnlFooter.Top := pnlLeft.Height - pnlFooter.Height;
        lblFooter.Caption := '  KEY: "L" = Abnormal Low, "H" = Abnormal High, "*" = Critical Value';
        lblFooter.Align := alTop;
        if ScreenReaderActive then
        begin
          lbl508Footer.Caption := lblFooter.Caption;
          lbl508Footer.Align := alTop;
          lblFooter.Visible := false;
          lbl508Footer.Visible := true;
        end;
        pnlFooter.Visible := true;
        if (grdLab.VisibleRowCount + 1) < grdLab.RowCount then
          grdLab.ColWidths[4] := grdLab.ColWidths[4] - 18;
        memLab.Align := alClient;
        memLab.Repaint;
        if upnlRightTopHeight_1 > 0 then
          pnlRightTop.Height := upnlRightTopHeight_1;
      end;
      if Piece(tmpList[0], '^', 2) = 'MI' then
      begin
        tmpList.Delete(0);
        QuickCopy(tmpList, memLab);
        memLab.SelStart := 0;
        grdLab.Visible := false;
        pnlFooter.Visible := false;
        sptHorzRight.Visible := true;
        TabControl1.Visible := false;
        pnlRightTop.Height := pnlHeader.Height;
        memLab.Height := pnlRight.Height - (lblHeading.Height + lblTitle.Height + pnlHeader.Height);
        pnlRightTop.Visible := true;
        memLab.Align := alClient;
        memLab.Repaint;
      end;
    end
    else
    begin
      grdLab.Visible := false;
      pnlFooter.Visible := false;
      memLab.Align := alClient;
    end;
  finally
    tmpList.Free;
  end;
end;

procedure TfrmLabs.cmdNextClick(Sender: TObject);
var
  HadFocus: boolean;
begin
  inherited;
  HadFocus := Screen.ActiveControl = cmdNext;
  StatusText('Retrieving next lab data...');
  if Length(lblDateFloat.Caption) > 0 then GetInterimGrid(strtofloat(lblDateFloat.Caption), -1);
  StatusText('');
  if HadFocus then begin
    if cmdNext.Enabled then cmdNext.SetFocus
    else if cmdPrev.Enabled then cmdPrev.SetFocus
    else tvReports.SetFocus;
  end;
  if ScreenReaderActive then
  begin
    if cmdNext.Focused then GetScreenReader.Speak(lblSample.Caption);
    if cmdPrev.Focused then GetScreenReader.Speak(lblMostRecent.Caption + lblSample.Caption);
  end;
end;

procedure TfrmLabs.cmdNextMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MouseClick := true;
end;

procedure TfrmLabs.cmdPrevClick(Sender: TObject);
var
  HadFocus: boolean;
begin
  inherited;
  HadFocus := Screen.ActiveControl = cmdPrev;
  StatusText('Retrieving previous lab data...');
  if Length(lblDateFloat.Caption) > 0 then GetInterimGrid(strtofloat(lblDateFloat.Caption), 1);
  StatusText('');
  if HadFocus then begin
    if cmdPrev.Enabled then cmdPrev.SetFocus
    else if cmdNext.Enabled then cmdNext.SetFocus
    else tvReports.Setfocus;
  end;
  if ScreenReaderActive then
  begin
    if cmdPrev.Focused then GetScreenReader.Speak(lblSample.Caption);
    if cmdNext.Focused then GetScreenReader.Speak(lblMostRecent.Caption + lblSample.Caption);
  end;
end;

procedure TfrmLabs.cmdPrevMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MouseClick := true;
end;

procedure TfrmLabs.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  WebDoc: IHtmlDocument2;
  v: variant;
begin
  inherited;
  if uHTMLDoc = '' then Exit;
  if not(uReportType = 'H') then Exit; //this can be removed if & when browser replaces memLab control
  if not Assigned(WebBrowser.Document) then Exit;
  WebDoc := WebBrowser.Document as IHtmlDocument2;
  v := VarArrayCreate([0, 0], varVariant);
  v[0] := uHTMLDoc;
  WebDoc.write(PSafeArray(TVarData(v).VArray));
  WebDoc.close;
  //uHTMLDoc := '';
end;

procedure TfrmLabs.WorksheetChart(test: string; aitems: TStrings);

function OkFloatValue(value: string): boolean;
var
  i, j: integer;
  first, second: string;
begin
  Result := false;
  i := strtointdef(value, -99999);
  if i <> -99999 then Result := true
  else if pos('.', Copy(Value, Pos('.', Value) + 1, Length(Value))) > 0 then Result := false
  else
  begin
    first := Piece(value, '.', 1);
    second := Piece(value, '.', 2);
    if length(second) > 0 then
    begin
      i := strtointdef(first, -99999);
      j := strtointdef(second, -99999);
      if ((i <> -99999) or (first = '')) and (j <> -99999) then Result := true;
    end
    else
    begin
      i :=strtointdef(first, -99999);
      if i <> -99999 then Result := true;
    end;
  end;
end;

var
  datevalue, oldstart, oldend: TDateTime;
  labvalue: double;
  i, numtest, numcol, numvalues, {refcount,} valuecount: integer;
  high, low, start, stop, numspec, value, testcheck, units, specimen, testnum, testorder: string;
begin
  if chkZoom.Checked and chtChart.Visible then
  begin
    oldstart := chtChart.BottomAxis.Minimum;
    oldend := chtChart.BottomAxis.Maximum;
    chtChart.UndoZoom;
    chtChart.BottomAxis.Automatic := false;
    chtChart.BottomAxis.Minimum := oldstart;
    chtChart.BottomAxis.Maximum := oldend;
  end
  else
  begin
    chtChart.BottomAxis.Automatic := true;
  end;
  chtChart.Visible := true;
  valuecount := 0;
  testnum := Piece(test, '^', 1);
  specimen := Piece(test, '^', 3);
  units := Piece(test, '^', 4);
  low := Piece(test, '^', 5);
  high := Piece(test, '^', 6);
  numtest := strtoint(Piece(aitems[0], '^', 1));
  numcol := strtoint(Piece(aitems[0], '^', 2));
  numvalues := strtoint(Piece(aitems[0], '^', 3));
  serHigh.Clear;  serLow.Clear;  serTest.Clear;
//  refcount := 0;
  if numtest > 0 then
  begin
    for i := 1 to numtest do
      if testnum = Piece(aitems[i], '^', 2) then
      begin
        testorder := inttostr(i);
        break;
      end;
    GetStartStop(start, stop, aitems);
    if OKFloatValue(high) then
    begin
//      inc(refcount);
      serHigh.AddXY(FMToDateTime(start), strtofloat(high), '',clTeeColor);
      serHigh.AddXY(FMToDateTime(stop), strtofloat(high), '',clTeeColor);
    end;
    if OKFloatValue(low) then
    begin
//      inc(refcount);
      serLow.AddXY(FMToDateTime(start), strtofloat(low), '',clTeeColor);
      serLow.AddXY(FMToDateTime(stop), strtofloat(low), '',clTeeColor);
    end;
    numspec := Piece(specimen, '^', 1);
    chtChart.Legend.Color := grdLab.Color;
    chtChart.Title.Font.Size := MainFontSize;
    chtChart.LeftAxis.Title.Caption := units;
    serTest.Title := Piece(test, '^', 2);
    serHigh.Title := 'Ref High ' + high;
    serLow.Title := 'Ref Low ' + low;
    testcheck := testorder;
    for i := numtest + numcol + 1 to numtest + numcol + numvalues do
      if Piece(aitems[i], '^', 2) = testcheck then
        if Piece(aitems[numtest + strtoint(Piece(aitems[i], '^', 1))], '^', 3) = numspec then
        begin
          value := Piece(aitems[i], '^', 3);
          if OkFloatValue(value) then
          begin
            labvalue := strtofloat(value);
            datevalue := FMToDateTime(Piece(aitems[numtest + strtoint(Piece(aitems[i], '^', 1))], '^', 2));
            serTest.AddXY(datevalue, labvalue, '', clTeeColor);
            inc(valuecount);
          end;
        end;
  end;
  if (valuecount = 0) {or (refcount = 0)} then
  begin
    lblGraph.Left := chtChart.Left + ((chtChart.Width - lblGraph.Width) div 2);
    lblGraph.Top := 2;
    lblGraph.Visible := true;
{    if (valuecount > 0) and (refcount = 0) then
      pnlChart.Caption := '<Results for ' + serTest.Title + ' are not graphed. Please use an alternate view.> '
    else}
    if length(Piece(specimen, '^', 2)) > 0 then
      pnlChart.Caption := '<No results can be graphed for ' + serTest.Title + ' in this date range.> '
    else
      pnlChart.Caption := '<No results can be graphed for ' + Piece(test, '^', 2) + ' in this date range.>';
    chtChart.Visible := false;
  end
  else
    lblGraph.Visible := false;
  if not chkZoom.Checked then
  begin
    chtChart.UndoZoom;
    chtChart.Refresh;       // put in to make happy with XE3 and v30
    chtChart.ZoomPercent(ZOOM_PERCENT);
  end;
end;

procedure TfrmLabs.GetStartStop(var start, stop: string; aitems: TStrings);
var
  numtest, numcol: integer;
begin
  numtest := strtoint(Piece(aitems[0], '^', 1));
  numcol := strtoint(Piece(aitems[0], '^', 2));
  start := Piece(aitems[numtest + 1], '^', 2);
  stop := Piece(aitems[numtest + numcol], '^', 2);
end;

procedure TfrmLabs.cmdRecentClick(Sender: TObject);
var
  HadFocus: boolean;
begin
  inherited;
  HadFocus := Screen.ActiveControl = cmdRecent;
  StatusText('Retrieving most recent lab data...');
  uFormat := 1;
  GetInterimGrid(FMToday + 0.2359, 1);
  StatusText('');
  if HadFocus and cmdPrev.Enabled then cmdPrev.SetFocus;
  if ScreenReaderActive then GetScreenReader.Speak(lblMostRecent.Caption + lblSample.Caption);
end;

procedure TfrmLabs.cmdRecentMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MouseClick := true;
end;

procedure TfrmLabs.cmdOldClick(Sender: TObject);
var
  HadFocus: boolean;
begin
  inherited;
  HadFocus := Screen.ActiveControl = cmdOld;
  StatusText('Retrieving oldest lab data...');
  uFormat := 1;
  GetInterimGrid(2700101, -1);
  if HadFocus and cmdNext.Enabled then cmdNext.SetFocus;
  StatusText('');
  if ScreenReaderActive then GetScreenReader.Speak(lblMostRecent.Caption + lblSample.Caption);
end;

procedure TfrmLabs.cmdOldMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MouseClick := true;
end;

procedure TfrmLabs.FormResize(Sender: TObject);

begin
  inherited;
  pnlFooter.Height := lblReports.Height + 5;
  lblFooter.Height := lblReports.Height;
  if ScreenReaderActive then lbl508Footer.Height := lblFooter.Height;
end;

procedure TfrmLabs.pnlButtonsEnter(Sender: TObject);
begin
  inherited;
  if ScreenReaderActive then
  begin
    if MouseClick = false then
    begin
      if lblMostRecent.Visible then
        GetScreenReader.Speak(lblMostRecent.Caption + lblSample.Caption);
      if lblMostRecent.Visible = False then
        GetScreenReader.Speak(lblSample.Caption);
    end;
    MouseClick := false
  end;
end;

procedure TfrmLabs.pnlRightResize(Sender: TObject);
begin
  inherited;
  pnlRight.Refresh;
  lblFooter.Height := lblHeading.Height;
  if ScreenReaderActive then lbl508Footer.Height := lblFooter.Height;
end;

function TfrmLabs.FMToDateTime(FMDateTime: string): TDateTime;
var
  x, Year: string;
begin
  { Note: TDateTime cannot store month only or year only dates }
  x := FMDateTime + '0000000';
  if Length(x) > 12 then x := Copy(x, 1, 12);
  if StrToInt(Copy(x, 9, 4)) > 2359 then x := Copy(x,1,7) + '.2359';
  Year := IntToStr(17 + StrToInt(Copy(x,1,1))) + Copy(x,2,2);
  x := Copy(x,4,2) + '/' + Copy(x,6,2) + '/' + Year + ' ' + Copy(x,9,2) + ':' + Copy(x,11,2);
  Result := StrToDateTime(x);
end;

procedure TfrmLabs.chkValuesClick(Sender: TObject);
begin
  inherited;
  serTest.Marks.Visible := chkValues.Checked;
end;

procedure TfrmLabs.chk3DClick(Sender: TObject);
begin
  inherited;
  chtChart.View3D := chk3D.Checked;
end;

procedure TfrmLabs.GraphChart(test: string; aitems: TStrings);
var
  datevalue: TDateTime;
  labvalue: double;
  i, numvalues: integer;
  high, low, start, stop, value, units, specimen: string;
begin
  numvalues := strtoint(Piece(aitems[0], '^', 1));
  specimen := Piece(aitems[0], '^', 2);
  high := Piece(aitems[0], '^', 3);
  low := Piece(aitems[0], '^', 4);
  units := Piece(aitems[0], '^', 5);
  if numvalues > 0 then
  begin
    start := Piece(aitems[1], '^', 1);
    stop := Piece(aitems[numvalues], '^', 1);
    chtChart.Legend.Color := grdLab.Color;
    serHigh.Clear;  serLow.Clear;  serTest.Clear;
    if high <> '' then
    begin
      serHigh.AddXY(FMToDateTime(start), strtofloat(high), '',clTeeColor);
      serHigh.AddXY(FMToDateTime(stop), strtofloat(high), '',clTeeColor);
    end;
    if low <> '' then
    begin
      serLow.AddXY(FMToDateTime(start), strtofloat(low), '',clTeeColor);
      serLow.AddXY(FMToDateTime(stop), strtofloat(low), '',clTeeColor);
    end;
    chtChart.LeftAxis.Title.Caption := units;
    serTest.Title := Piece(test, '^', 2) + '  (' + MixedCase(specimen) + ')';
    serHigh.Title := 'Ref High ' + high;
    serLow.Title := 'Ref Low ' + low;
    for i := 1 to numvalues do
    begin
      value := Piece(aitems[i], '^', 2);
      labvalue := strtofloat(value);
      datevalue := FMToDateTime(Piece(aitems[i], '^', 1));
      serTest.AddXY(datevalue, labvalue, '', clTeeColor);
    end;
  end;
end;

procedure TfrmLabs.ragHorVClick(Sender: TObject);
begin
  inherited;
  if ragHorV.ItemIndex = 0 then HGrid(tmpGrid) else VGrid(tmpGrid);
end;

procedure TfrmLabs.rdo1MonthClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo1Month.Tag);
end;

procedure TfrmLabs.rdo1WeekClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo1Week.Tag);
end;

procedure TfrmLabs.rdo1YearClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo1Year.Tag);
end;

procedure TfrmLabs.rdo2YearClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo2Year.Tag);
end;

procedure TfrmLabs.rdo6MonthClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo6Month.Tag);
end;

procedure TfrmLabs.rdoAllResultsClick(Sender: TObject);
begin
  inherited;
  RDOChange(rdoAllResults.Tag);
end;

procedure TfrmLabs.rdoDateRangeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  rdoChange(rdoDateRange.Tag);
end;

procedure TfrmLabs.rdoTodayClick(Sender: TObject);
begin
  rdoChange(rdoToday.Tag);
end;

procedure TfrmLabs.RDOChange(rdoIndex: integer);
var
  aID, aCategory, aHDR, aQualifier, aRptCode, x, x1, x2, MoreID: string;
  aIndex: integer;
begin
  inherited;
  if uTVLabReportSet then Exit;
  aID := uRptID;
  aCategory   :=  PReportTreeObject(tvReports.Selected.Data)^.Category;
  aHDR        :=  PReportTreeObject(tvReports.Selected.Data)^.HDR;
  aQualifier  :=  PReportTreeObject(tvReports.Selected.Data)^.Qualifier;
  aRptCode    :=  Piece(aQualifier,';',4);
  uQualifierType := StrToIntDef(aRptCode,0);
  aIndex := rdoIndex;
  uRDOChanging := true;
  uRDOStick := true;
  uRDOPick := rdoIndex;
  if chkMaxFreq.checked = true then
    begin
      MoreID := '';
      SetPiece(aQualifier,';',3,'');
    end;
  case uQualifierType of
    QT_OTHER:
      begin      //      = 0
        If aID = '1:MOST RECENT' then
          begin

          end
        else if aID = '4:SELECTED TESTS BY DATE' then
          begin
            lstDates.ItemIndex := aIndex;
            if ulstDatesChanging = false then lstDatesClick(self);
            lstQualifier.ItemIndex := lstDates.ItemIndex;
          end
        else if aID = '5:WORKSHEET' then
          begin
            lstDates.ItemIndex := aIndex;
            if ulstDatesChanging = false then lstDatesClick(self);
            lstQualifier.ItemIndex := lstDates.ItemIndex;
            if upnlRightTopHeight_2 > 0 then
              pnlRightTop.Height := upnlRightTopHeight_2;
          end
        else if (aID = '9:MICROBIOLOGY') or (aID = '20:ANATOMIC PATHOLOGY') or (aID = '2:BLOOD BANK') or (aID = '10:LAB STATUS') or (aID = '3:ALL TESTS BY DATE') or (aID = '21:CUMULATIVE') or (aID = '27:AUTOPSY') then
          begin
            case StrToInt(aCategory) of
                                  {Categories of reports:
                                      0:Fixed
                                      1:Fixed w/Dates
                                      2:Fixed w/Headers
                                      3:Fixed w/Dates & Headers
                                      4:Specialized
                                      5:Graphic}

              0: begin

              end;
              1: begin
                lstDates.ItemIndex := aIndex;
                if ulstDatesChanging = false then lstDatesClick(self);
                lstQualifier.ItemIndex := lstDates.ItemIndex;
              end;
              2: begin

              end;
              3: begin
                lstDates.ItemIndex := aIndex;
                if ulstDatesChanging = false then lstDatesClick(self);
                lstQualifier.ItemIndex := lstDates.ItemIndex;
              end;

            end;
          end
        else
          begin

          end;
      end;
    QT_DATERANGE:
      begin      //      = 2
        lstQualifier.ItemIndex := aIndex;
        if ulstQualifierChanging = false then lstQualifierClick(self);
        lstDates.ItemIndex := lstQualifier.ItemIndex;
      end;
    QT_HSCOMPONENT:
      begin      //      = 5
        lstQualifier.ItemIndex := aIndex;
        if ulstQualifierChanging = false then lstQualifierClick(self);
        lstDates.ItemIndex := lstQualifier.ItemIndex;
      end;
    QT_HSWPCOMPONENT:
      begin      //      = 6
        lstQualifier.ItemIndex := aIndex;
        if ulstQualifierChanging = false then lstQualifierClick(self);
        lstDates.ItemIndex := lstQualifier.ItemIndex;
      end;
    else
      begin      //      = ?

      end;
    end;
  x := Piece(aQualifier, ';', 3);
  if (CharAt(lstQualifier.ItemID,1) = 'd')
    and (length(x)>0)
    and (StrToInt(x)<101) then
      x := '101';
  if length(x)>0
    then MoreID := ';' + x
    else MoreID := '';
  if lstQualifier.ItemIndex > -1 then
    begin
    if not (aHDR = '1') then
      if (aCategory <> '0') and (not WebBrowser.Visible) then
          begin
            DisplayHeading(lstQualifier.ItemID + MoreID) ;
          end
      else
        DisplayHeading('');
    end
  else
    begin
      if not (aHDR = '1') and (lstDates.ItemIndex > -1) then
        if (aCategory <> '0') and (not WebBrowser.Visible) then
          begin
            if uRDOStick and (uRDOPick > 0) and uRDOChanging then lstDates.ItemIndex := uRDOPick;
            x := lstDates.DisplayText[lstDates.ItemIndex];
            x1 := piece(x,' ',1);
            x2 := piece(x,' ',3);
            if (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
              DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2) + MoreID)
            else
              DisplayHeading('d' + lstDates.ItemID + MoreID);
          end
        else
          DisplayHeading('');
    end;
  uRDOChanging := false;
end;

procedure TfrmLabs.ragCorGClick(Sender: TObject);
begin
  inherited;
  if ragCorG.ItemIndex = 0 then      // comments
  begin
    chkZoom.Enabled := false;
    chk3D.Enabled := false;
    chkValues.Enabled := false;
    pnlChart.Visible:= false;
    pnlRightTop.Align := alTop;
    pnlRightTop.Height := pnlRight.Height - (pnlRight.Height div 3);
    pnlRightBottom.Visible := true;
    pnlRightBottom.Align := alClient;
    memLab.Align := alClient;
    memLab.Visible := true;
    grdLab.Align := alClient;
  end
  else                             // graph
  begin
    chkZoom.Enabled := true;
    chk3D.Enabled := true;
    chkValues.Enabled := true;
    chk3DClick(self);
    chkValuesClick(self);
    memLab.Visible := false;
    pnlRightBottom.Visible := false;
    pnlRightTop.Align := alClient;
    pnlChart.Height :=  pnlRight.Height div 2;
    pnlChart.Top := pnlRight.Height - pnlFooter.Height - pnlChart.Height;
    pnlChart.Align := alBottom;
    pnlChart.Visible := true;
    grdLab.Align := alClient;
    if lstTestGraph.Items.Count > 0 then
    begin
      if lstTestGraph.ItemIndex < 0 then
        lstTestGraph.ItemIndex := 0;
      lstTestGraphClick(self);
    end;
  end;
end;

procedure TfrmLabs.lstTestGraphClick(Sender: TObject);
begin
  inherited;
  WorksheetChart(lstTestGraph.Items[lstTestGraph.ItemIndex], tmpGrid);
end;

procedure TfrmLabs.Print1Click(Sender: TObject);
begin
  inherited;
  RequestPrint;
end;

procedure TfrmLabs.Copy1Click(Sender: TObject);
var
  i,j: integer;
  line: string;
  ListItem: TListItem;
  aText: String;
begin
  inherited;
  ClipBoard;
  aText := '';
  for i := 0 to lvReports.Items.Count - 1 do
    if lvReports.Items[i].Selected then
    begin
      ListItem := lvReports.Items[i];
      line := '';
      for j := 1 to lvReports.Columns.Count - 1 do
        begin
          if (lvReports.Column[j].Width <> 0) and (j < (ListItem.SubItems.Count + 1)) then
            line := line + '  ' + ListItem.SubItems[j-1];
        end;
      if (length(line) > 0) and (lvReports.Column[0].Width <> 0) then
        line := ListItem.Caption + '  ' + line;
      if length(aText) > 0 then
        aText := aText + CRLF + line
      else aText := line;
    end;
  ClipBoard.Clear;
  ClipBoard.AsText := aText;
end;

procedure TfrmLabs.Copy2Click(Sender: TObject);
begin
  inherited;
  memLab.CopyToClipboard;
end;

procedure TfrmLabs.Print2Click(Sender: TObject);
begin
  inherited;
  RequestPrint;
end;

procedure TfrmLabs.lvReportsColumnClick(Sender: TObject;
  Column: TListColumn);
var
  ClickedColumn: Integer;
  a1, a2: integer;
  s,s1,s2: string;
begin
  inherited;
  a1 := StrToIntDef(piece(uSortOrder,':',1),0) - 1;
  a2 := StrToIntDef(piece(uSortOrder,':',2),0) - 1;
  ClickedColumn := Column.Index;
  ColumnToSort := Column.Index;
  SortIdx1 := StrToIntDef(piece(uColumns[ColumnToSort],'^',9),0);
  SortIdx2 := 0;
  SortIdx3 := 0;
  if a1 > -1 then SortIdx2 := StrToIntDef(piece(uColumns[a1],'^',9),0);
  if a2 > -1 then SortIdx3 := StrToIntDef(piece(uColumns[a2],'^',9),0);
  if a1 = ColumnToSort then
    begin
      SortIdx2 := SortIdx3;
      SortIdx3 := 0;
    end;
  if a2 = ColumnToSort then
      SortIdx3 := 0;
  if ClickedColumn = ColumnToSort then
    ColumnSortForward := not ColumnSortForward
  else
    ColumnSortForward := true;
  ColumnToSort := ClickedColumn;
  uFirstSort := ColumnToSort;
  uSecondSort := a1;
  uThirdSort := a2;
  lvReports.Hint := '';
  if ColumnSortForward = true then
    s := 'Sorted forward'
  else
    s := 'Sorted reverse';
  s1 := piece(uColumns[uFirstSort],'^',1);
  s2 := '';
  if length(piece(s1,' ',2)) > 0 then
    s2 := pieces(s1,' ',2,99);
  if length(s2) > 0 then s2 := StripSpace(s2);
  s := s + ' by ' + piece(s1,' ',1) + ' ' + s2;
  if (a1 <> uFirstSort) and (a1 > -1) then
    begin
      s1 :=  piece(uColumns[a1], '^', 1);
      s2 := '';
      if length(piece(s1,' ',2)) > 0 then
        s2 := pieces(s1,' ',2,99);
      if length(s2) > 0 then s2 := StripSpace(s2);
      s := s + ' then by ' +  piece(s1,' ',1) + ' ' + s2;
    end;
  if (a2 <> uFirstSort) and (a2 > -1) then
    begin
      s1 :=  piece(uColumns[a2], '^', 1);
      s2 := '';
      if length(piece(s1,' ',2)) > 0 then
        s2 := pieces(s1,' ',2,99);
      if length(s2) > 0 then s2 := StripSpace(s2);
      s := s + ' then by ' +  piece(s1,' ',1) + ' ' + s2;
    end;
  lvReports.Hint := s;
  lvReports.CustomSort(nil, 0);
end;

procedure TfrmLabs.lvReportsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);

  function CompareValues(Col: Integer): integer;
  var
    ix: Integer;
    s1, s2: string;
    v1, v2: extended;
    d1, d2: TFMDateTime;
  begin
    inherited;
    if ColumnToSort = 0 then
      Result := CompareText(Item1.Caption,Item2.Caption)
    else
      begin
        ix := ColumnToSort - 1;
        case Col of
          0:                        //strings
            begin
              if(Item1.SubItems.Count > 0) and (ix < Item1.SubItems.Count) then
                s1 := Item1.SubItems[ix]
              else
                s1 := '0';
              if(Item2.SubItems.Count > 0) and (ix < Item2.SubItems.Count) then
                s2 := Item2.SubItems[ix]
              else
                s2 := '0';
              Result := CompareText(s1,s2);
            end;

          1:                        //integers
            begin
              if(Item1.SubItems.Count > 0) and (ix < Item1.SubItems.Count) then
                s1 := Item1.SubItems[ix]
              else
                s1 := '0';
              if(Item2.SubItems.Count > 0) and (ix < Item2.SubItems.Count) then
                s2 := Item2.SubItems[ix]
              else
                s2 := '0';
              IsValidNumber(s1, v1);
              IsValidNumber(s2, v2);
              if v1 > v2 then
                Result := 1
              else
              if v1 < v2 then
                Result := -1
              else
                Result := 0;
            end;

          2:                        //date/times
            begin
              if(Item1.SubItems.Count > 1) and (ix < Item1.SubItems.Count) then
                s1 := Item1.SubItems[ix]
              else
                s1 := '1/1/1700';
              if(Item2.SubItems.Count > 1) and (ix < Item2.SubItems.Count) then
                s2 := Item2.SubItems[ix]
              else
                s2 := '1/1/1700';
              d1 := StringToFMDateTime(s1);
              d2 := StringToFMDateTime(s2);
              if d1 > d2 then
                Result := 1
              else
              if d1 < d2 then
                Result := -1
              else
                Result := 0;
            end;
          else
            Result := 0; // to make the compiler happy
        end;
      end;
  end;
begin
  ColumnToSort := uFirstSort;
  Compare := CompareValues(SortIdx1);
  if Compare = 0 then
  begin
    if (uSecondSort > -1) and (uFirstSort <> uSecondSort) then
      begin
        ColumnToSort := uSecondSort;
        Compare := CompareValues(SortIdx2);
      end;
    if Compare = 0 then
      if (uThirdSort > -1) and (uFirstSort <> uThirdSort) and (uSecondSort <> uThirdSort) then
        begin
          ColumnToSort := uThirdSort;
          Compare := CompareValues(SortIdx3);
        end;
  end;
  if not ColumnSortForward then Compare := -Compare;
end;

procedure TfrmLabs.lvReportsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = 67) and (ssCtrl in Shift) then
    Copy1Click(Self);
  if (Key = 65) and (ssCtrl in Shift) then
    SelectAll1Click(Self);
end;

procedure TfrmLabs.lvReportsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  aID, aSID: string;
  i,j,k: integer;
  aBasket: TStringList;
  aWPFlag: Boolean;
  x, HasImages: string;

begin
  inherited;
  if not selected then Exit;
  aBasket := TStringList.Create;
  uLabLocalReportData.Clear;
  aWPFlag := false;
  with lvReports do
    begin
      aID := Item.SubItems[0];
      case uQualifierType of
            QT_OTHER:
              begin      //      = 0

              end;
            QT_DATERANGE:
              begin      //      = 2

              end;
            QT_IMAGING:
              begin      //      = 3

              end;
            QT_NUTR:
              begin      //      = 4

              end;
            QT_HSWPCOMPONENT:
              begin      //      = 6
                if lvReports.SelCount < 3 then
                  begin
                    memLab.Lines.Clear;
                    ulvSelectOn := false;
                  end;
                aBasket.Clear;
                if (SelCount = 2) and (ulvSelectOn = false) then
                  begin
                    ulvSelectOn := true;
                    for i := 0 to Items.Count - 1 do
                      if (Items[i].Selected) and (aID <> Items[i].SubItems[0]) then
                        begin
                          aSID := Items[i].SubItems[0];
                          for j := 0 to LabRowObjects.ColumnList.Count - 1 do
                            if piece(aSID,':',1) = piece(TCellObject(LabRowObjects.ColumnList[j]).Handle,':',1) then
                              if Item.Caption = (piece(TCellObject(LabRowObjects.ColumnList[j]).Site,';',1)) then
                                if (TCellObject(LabRowObjects.ColumnList[j]).Data.Count > 0) and
                                  (TCellObject(LabRowObjects.ColumnList[j]).Include = '1') then
                                  begin
                                    aWPFlag := true;
                                    MemLab.Lines.Add(TCellObject(LabRowObjects.ColumnList[j]).Name);
                                    FastAssign(TCellObject(LabRowObjects.ColumnList[j]).Data, aBasket);
                                    for k := 0 to aBasket.Count - 1 do
                                      MemLab.Lines.Add(' ' + aBasket[k]);
                                  end;
                          if aWPFlag = true then
                            begin
                              memLab.Lines.Add('Facility: ' + Item.Caption);
                              memLab.Lines.Add('===============================================================================');
                            end;
                        end;
                  end;
                aBasket.Clear;
                aWPFlag := false;
                for i := 0 to LabRowObjects.ColumnList.Count - 1 do
                  if piece(aID,':',1) = piece(TCellObject(LabRowObjects.ColumnList[i]).Handle,':',1) then
                    if Item.Caption = (piece(TCellObject(LabRowObjects.ColumnList[i]).Site,';',1)) then
                      if (TCellObject(LabRowObjects.ColumnList[i]).Data.Count > 0) and
                        (TCellObject(LabRowObjects.ColumnList[i]).Include = '1') then
                        begin
                          aWPFlag := true;
                          MemLab.Lines.Add(TCellObject(LabRowObjects.ColumnList[i]).Name);
                          FastAssign(TCellObject(LabRowObjects.ColumnList[i]).Data, aBasket);
                          for j := 0 to aBasket.Count - 1 do
                            MemLab.Lines.Add(' ' + aBasket[j]);
                        end;
                if aWPFlag = true then
                  begin
                    memLab.Lines.Add('Facility: ' + Item.Caption);
                    memLab.Lines.Add('===============================================================================');
                  end;
                if uRptID = 'OR_R18:IMAGING' then
                begin
                  if (Item.SubItems.Count > 8) then                                             //has id, may have case (?)
                  begin
                    x := 'RA^' + Item.SubItems[8] + U + Item.SubItems[4] + U + Item.Caption;
                    SetPiece(x, U, 10, BOOLCHAR[Item.SubItemImages[1] = IMG_1_IMAGE]);
                    NotifyOtherApps(NAE_REPORT, x);
                  end
                  else if (Item.SubItems.Count > 4) then
                  begin
                    x := 'RA^' + U + U + Item.SubItems[4] + U + Item.Caption;
                    SetPiece(x, U, 10, BOOLCHAR[Item.SubItemImages[1] = IMG_1_IMAGE]);
                    NotifyOtherApps(NAE_REPORT, x);
                  end
                  else if Item.SubItemImages[1] = IMG_1_IMAGE then
                  begin
                    memLab.Lines.Insert(0,'<Imaging links not active at this site>');
                    memLab.Lines.Insert(1,' ');
                  end;
                end;
                if uRptID = 'OR_PN:PROGRESS NOTES' then
                  if (Item.SubItems.Count > 7) then
                    begin
                      if StrToIntDef(Item.SubItems[7], 0) > 0 then HasImages := '1' else HasImages := '0';
                      x := 'PN^' + Item.SubItems[7] + U + Item.SubItems[1] + U + Item.Caption;
                      SetPiece(x, U, 10, HasImages);
                      NotifyOtherApps(NAE_REPORT, x);
                    end;
              end;
            QT_PROCEDURES:
              begin      //      = 19

              end;
            QT_SURGERY:
              begin      //      = 28

              end;
      end;
      memLab.Lines.Insert(0,' ');
      memLab.Lines.Delete(0);
    end;
  aBasket.Free;
end;

procedure TfrmLabs.memLabEnter(Sender: TObject);
begin
  inherited;
if ScreenReaderActive then
     GetScreenReader.Speak(memLab.Text)
end;

procedure TfrmLabs.SaveUserSettings(var posD, posH, posL, posV: integer);
begin
  posD := splLeft.Top;
  posH := sptHorz.Left;
  posL := sptHorzRightTop.Top;
  posV := sptHorzRight.Top;
end;

procedure TfrmLabs.SelectAll1Click(Sender: TObject);
var
  i: integer;
begin
  inherited;
    for i := 0 to lvReports.Items.Count - 1 do
       lvReports.Items[i].Selected := true;
end;

procedure TfrmLabs.SelectAll2Click(Sender: TObject);
begin
  inherited;
  memLab.SelectAll;
end;

procedure TfrmLabs.chkGraphValuesClick(Sender: TObject);
begin
  inherited;
  serTest.Marks.Visible := chkGraphValues.Checked;
end;

procedure TfrmLabs.chkGraph3DClick(Sender: TObject);
begin
  inherited;
  chtChart.View3D := chkGraph3D.Checked;
end;

procedure TfrmLabs.chkGraphZoomClick(Sender: TObject);
begin
  inherited;
  chtChart.AllowZoom := chkGraphZoom.Checked;
  chtChart.AnimatedZoom := chkGraphZoom.Checked;
  lblGraphInfo.Caption := 'To Zoom, hold down the mouse button while dragging an area to be enlarged.';
  if chkGraphZoom.Checked then
    lblGraphInfo.Caption := lblGraphInfo.Caption + #13
                          + 'To Zoom Back drag to the upper left. You can also use the actions on the right mouse button.';
  lblGraphInfo.Visible := chkGraphZoom.Checked;
  if not chkGraphZoom.Checked then chtChart.UndoZoom;
end;

procedure TfrmLabs.chkMaxFreqClick(Sender: TObject);
begin
  inherited;
  if chkMaxFreq.Checked = true then
    begin
      uMaxOcc := piece(uQualifier, ';', 3);
      SetPiece(uQualifier, ';', 3, '');
    end
    else
      begin
        SetPiece(uQualifier, ';', 3, uMaxOcc);
      end;
  tvReportsClick(self);
end;

procedure TfrmLabs.GotoTop1Click(Sender: TObject);
begin
  inherited;
  SendMessage(memLab.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TfrmLabs.GotoBottom1Click(Sender: TObject);
begin
  Inherited;
  SendMessage(memLab.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TfrmLabs.FreezeText1Click(Sender: TObject);
var
  Current, Desired : Longint;
  LineCount : Integer;
begin
  Inherited;
  If memLab.SelLength > 0 then begin
    Memo1.visible := true;
    Memo1.Text := memLab.SelText;
    If Memo1.Lines.Count <6 then
      LineCount := Memo1.Lines.Count + 1
    Else
      LineCount := 5;
    Memo1.Height := LineCount * frmLabs.Canvas.TextHeight(memLab.SelText);
    Current := SendMessage(memLab.handle, EM_GETFIRSTVISIBLELINE, 0, 0);
    Desired := SendMessage(memLab.handle, EM_LINEFROMCHAR,
               memLab.SelStart + memLab.SelLength ,0);
    SendMessage(memLab.Handle,EM_LINESCROLL, 0, Desired - Current);
    uFrozen := True;
  end;
end;

procedure TfrmLabs.UnfreezeText1Click(Sender: TObject);
begin
  Inherited;
  If uFrozen = True Then begin
    uFrozen := False;
    UnFreezeText1.Enabled := False;
    Memo1.Visible := False;
    Memo1.Text := '';
  end;
end;

procedure TfrmLabs.PopupMenu3Popup(Sender: TObject);
begin
 inherited;
  If Screen.ActiveControl.Name <> memLab.Name then
   begin
     memLab.SetFocus;
     memLab.SelStart := 0;
   end;
  If memLab.SelLength > 0 Then
    FreezeText1.Enabled := True
  Else
    FreezeText1.Enabled := False;
  If Memo1.Visible Then
    UnFreezeText1.Enabled := True;                              
end;

procedure TfrmLabs.ProcessNotifications;
var
  OrderIFN: string;
begin
  OrderIFN                := Piece(Notifications.AlertData, '@', 1);
  if StrToIntDef(OrderIFN,0) > 0 then
   begin
    lvReports.Clear;
    sptHorzRightTop.Visible := false;
    lvReports.Visible := false;
    pnlRighttop.Visible := false;
    sptHorzRight.Visible := false;

    tvReports.Selected := tvReports.TopItem;    // moved here to fix the conflicting lab results caption header that is displayed with the alert message text.
    DisplayHeading('');    //fixes part B of CQ #17548 - CPRS v28.1 (TC)
    lstDates.ItemIndex      := -1;
    Memo1.Visible           := false;
    lblHeaders.Visible      := false;
    lstHeaders.Visible      := false;
    pnlOtherTests.Visible   := false;
    pnlLeftBotUpper.Visible := false;
    splLeftLower.Visible    := false;
    pnlLeftBotLower.Visible := false;
    lblDates.Visible        := false;
    lstDates.Visible        := false;
    if uUseRadioButton then
      begin
        pnlRightTopHeaderMid.Visible := false;
        lblDates.Visible := false;
        lblQualifier.Visible := false;
        lstQualifier.Visible := false;
        lstDates.Visible := false;
        splLeftLower.Visible    := false;
        pnlLeftBotLower.Visible := false;
      end
    else
      begin
        pnlRightTopHeaderMid.Visible := false;
      end;
    pnlHeader.Visible       := false;
    grdLab.Visible          := false;
    pnlChart.Visible        := false;
    WebBrowser.Visible      := false;
    WebBrowser.SendToBack;
    memLab.Visible          := true;
    memLab.BringToFront;
    pnlFooter.Visible       := true;
    memLab.Clear;
    uLabLocalReportData.Clear;
    uLabRemoteReportData.Clear;
    pnlRightTop.Height := 5;
    memLab.Align            := alClient;
    FormResize(self);
    uRptID := PReportTreeObject(tvReports.Selected.Data)^.ID; //Remedy HD417043 - Set variables so printing not allowed on notifications.
    uLabRepID := PReportTreeObject(tvReports.Selected.Data)^.ID;
    uReportType := PReportTreeObject(tvReports.Selected.Data)^.RptType;
    uQualifier := PReportTreeObject(tvReports.Selected.Data)^.Qualifier;
    uQualifierType := StrToIntDef(Piece(uQualifier,';',4),0);
    QuickCopy(ResultOrder(OrderIFN), memLab);
    memLab.SelStart := 0;
    memLab.Repaint;
    lblHeading.Caption      := Notifications.Text;
   end
   else
   begin
     if Patient.Inpatient then lstDates.ItemIndex := 2 else lstDates.ItemIndex := 4;
     if uRDOStick and (uRDOPick > 0) then lstDates.ItemIndex := uRDOPick;
     tvReports.Selected := tvReports.Items.GetFirstNode;
     tvReportsClick(self);
   end;

  case Notifications.FollowUp of
    NF_LAB_RESULTS          :   Notifications.Delete;
    NF_ABNORMAL_LAB_RESULTS :   Notifications.Delete;
    NF_SITE_FLAGGED_RESULTS :   Notifications.Delete;
    NF_STAT_RESULTS         :   Notifications.Delete;
    NF_CRITICAL_LAB_RESULTS :   Notifications.Delete;
    NF_LAB_THRESHOLD_EXCEEDED : Notifications.Delete;
  end;
end;

procedure TfrmLabs.chkZoomClick(Sender: TObject);
begin
  inherited;
  chtChart.AllowZoom := chkZoom.Checked;
  chtChart.AnimatedZoom := chkZoom.Checked;
  if not chkZoom.Checked then
  begin
    chtChart.UndoZoom;
    //chtChart.Refresh;
    chtChart.ZoomPercent(ZOOM_PERCENT);
  end;
end;

procedure TfrmLabs.chtChartUndoZoom(Sender: TObject);
begin
  inherited;
  chtChart.BottomAxis.Automatic := true;
end;

procedure TfrmLabs.popCopyClick(Sender: TObject);
begin
  inherited;
  chtChart.CopyToClipboardBitmap;
end;

procedure TfrmLabs.popChartPopup(Sender: TObject);
begin
  inherited;
  if pnlWorksheet.Visible then
  begin
    popValues.Checked := chkValues.Checked;
    pop3D.Checked := chk3D.Checked;
    popZoom.Checked := chkZoom.Checked;
  end
  else
  begin
    popValues.Checked := chkGraphValues.Checked;
    pop3D.Checked := chkGraph3D.Checked;
    popZoom.Checked := chkGraphZoom.Checked;
  end;
  popZoomBack.Enabled := popZoom.Checked and not chtChart.BottomAxis.Automatic;;
  if chtChart.Hint <> '' then
  begin
    popDetails.Caption := chtChart.Hint;
    popDetails.Enabled := true;
  end
  else
  begin
    popDetails.Caption := 'Details';
    popDetails.Enabled := false;
  end;
end;

procedure TfrmLabs.popValuesClick(Sender: TObject);
begin
  inherited;
  if pnlWorksheet.Visible then
  begin
    chkValues.Checked := not chkValues.Checked;
    chkValuesClick(self);
  end
  else
  begin
    chkGraphValues.Checked := not chkGraphValues.Checked;
    chkGraphValuesClick(self);
  end;
end;

procedure TfrmLabs.pop3DClick(Sender: TObject);
begin
  inherited;
  if pnlWorksheet.Visible then
  begin
    chk3D.Checked := not chk3D.Checked;
    chk3DClick(self);
  end
  else
  begin
    chkGraph3D.Checked := not chkGraph3D.Checked;
    chkGraph3DClick(self);
  end;
end;

procedure TfrmLabs.popZoomClick(Sender: TObject);
begin
  inherited;
  if pnlWorksheet.Visible then
  begin
    chkZoom.Checked := not chkZoom.Checked;
    chkZoomClick(self);
  end
  else
  begin
    chkGraphZoom.Checked := not chkGraphZoom.Checked;
    chkGraphZoomClick(self);
  end;
end;

procedure TfrmLabs.popZoomBackClick(Sender: TObject);
begin
  inherited;
  chtChart.UndoZoom;
end;

procedure TfrmLabs.chtChartMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  chtChart.Hint := '';
  chtChart.Tag := 0;
end;

procedure TfrmLabs.chtChartClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Series = serHigh then exit;
  if Series = serLow then exit;
  uDate1 := Series.XValue[ValueIndex];
  uDate2 := uDate1;
  chtChart.Hint := 'Details - Lab results for ' + FormatDateTime('dddd, mmmm d, yyyy', Series.XValue[ValueIndex]) + '...';
  chtChart.Tag := ValueIndex + 1;
  if Button <> mbRight then  popDetailsClick(self);
end;

procedure TfrmLabs.chtChartClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  chtChart.Hint := 'Details - for ' + Piece(serTest.Title, '(', 1) + '...';
  chtChart.Tag := 0;
  if Button <> mbRight then  popDetailsClick(self);
end;

procedure TfrmLabs.popDetailsClick(Sender: TObject);
var
  tmpList: TStringList;
  date1, date2: TFMDateTime;
  strdate1, strdate2: string;
begin
  inherited;
  Screen.Cursor := crHourGlass;
  if chtChart.Tag > 0 then
  begin
    tmpList := TStringList.Create;
    try
      strdate1 := FormatDateTime('mm/dd/yyyy', uDate1);
      strdate2 := FormatDateTime('mm/dd/yyyy', uDate2);
      uDate1 := StrToDateTime(strdate1);
      uDate2 := StrToDateTime(strdate2);
      date1 := DateTimeToFMDateTime(uDate1 + 1);
      date2 := DateTimeToFMDateTime(uDate2);
      StatusText('Retrieving data for ' + FormatDateTime('dddd, mmmm d, yyyy', uDate2) + '...');
      Interim(tmpList, Patient.DFN, date1, date2,'ORWLRR INTERIM');
      ReportBox(tmpList, 'Lab results on ' + Patient.Name + ' for ' + FormatDateTime('dddd, mmmm d, yyyy', uDate2), True);
    finally
      tmplist.Free;
    end;
  end
  else
  begin
    date1 := DateTimeToFMDateTime(chtChart.BottomAxis.Maximum);
    date2 := DateTimeToFMDateTime(chtChart.BottomAxis.Minimum);
    tmpList := TStringList.Create;
    try
      if lstTestGraph.ItemIndex > -1 then
        tmpList.Add(lstTestGraph.Items[lstTestGraph.ItemIndex])
      else
        tmpList.Add(Piece(lblSingleTest.Caption, '^', 1));
      StatusText('Retrieving data for ' + serTest.Title + '...');
      ReportBox(InterimSelect(Patient.DFN, date1, date2, tmpList), Piece(serTest.Title, '(', 1) + 'results on ' + Patient.Name, True);
    finally
      tmpList.Free;
    end;
  end;
  Screen.Cursor := crDefault;
  StatusText('');
end;

procedure TfrmLabs.popPrintClick(Sender: TObject);
begin
  inherited;
  if chtChart.Visible then PrintLabGraph;
end;

procedure TfrmLabs.PrintLabGraph;
var
  GraphTitle: string;
begin
  inherited;
  GraphTitle := Piece(lblSingleTest.Caption, '^', 2);
  if (Length(lblSpecimen.Caption) > 2) then GraphTitle := GraphTitle + ' (' + Piece(lblSpecimen.Caption, '^', 2) + ')';
  GraphTitle := GraphTitle + ' - ' + lstDates.DisplayText[lstDates.ItemIndex];
  if dlgWinPrint.Execute then PrintGraph(chtChart, GraphTitle);
end;

procedure TfrmLabs.BeginEndDates(var ADate1, ADate2: TFMDateTime; var ADaysBack: integer);
var
  datetemp: TFMDateTime;
  today, datetime1, datetime2: TDateTime;
  relativedate: string;
begin
  today := FMToDateTime(floattostr(FMToday));
  relativedate := Piece(lstDates.ItemID, ';', 1);
  relativedate := Piece(relativedate, '-', 2);
  ADaysBack := strtointdef(relativedate, 0);
  ADate1 := DateTimeToFMDateTime(today - ADaysBack);
  relativedate := Piece(lstDates.ItemID, ';', 2);
  if StrToIntDef(Piece(relativedate, '+', 2), 0) > 0 then
    begin
      relativedate := Piece(relativedate, '+', 2);
      ADaysBack := strtointdef(relativedate, 0);
      ADate2 := DateTimeToFMDateTime(today + ADaysBack + 1);
    end
  else
    begin
      relativedate := Piece(relativedate, '-', 2);
      ADaysBack := strtointdef(relativedate, 0);
      ADate2 := DateTimeToFMDateTime(today - ADaysBack);
    end;
  datetime1 := FMDateTimeToDateTime(ADate1);
  datetime2 := FMDateTimeToDateTime(ADate2);
  if datetime1 < datetime2 then                 // reorder dates, if needed
    begin
      datetemp := ADate1;
      ADate1 := ADate2;
      ADate2 := datetemp
    end;
  ADate1 := ADate1 + 0.2359;
end;

procedure TfrmLabs.BlankWeb;
begin
  try
    WebBrowser.Navigate(BlankWebPage);
  except
  end;
end;

procedure TfrmLabs.btnAppearRtClick(Sender: TObject);
begin
  inherited;
  btnClear.Visible := not btnClear.Visible;
  chkMaxFreq.Visible := not chkMaxFreq.Visible;
  if ScreenReaderActive then
  begin
    if btnClear.Visible = true then GetScreenReader.Speak('Hide Developer options, button, to activate press spacebar');
    if btnClear.Visible = false then GetScreenReader.Speak('Unhide Developer options, button, to activate press spacebar');
  end;
end;

procedure TfrmLabs.btnAppearRtEnter(Sender: TObject);
var
  item: TVA508AccessibilityItem;
  id: integer;
begin
  inherited;
  if ScreenReaderActive then
  begin
    item := amgrMain.AccessData.FindItem(btnAppearRt, False);
    id:= item.INDEX;
    if btnClear.Visible = true then amgrMain.AccessData[id].AccessText := 'Hide Developer options';
    if btnClear.Visible = false then amgrMain.AccessData[id].AccessText := 'Unhide Developer options';
  end;
end;

procedure TfrmLabs.btnClearClick(Sender: TObject);
begin
  inherited;
  uRDOStick := false;
  uRDOPick := 0;
  lstQualifier.Clear;
  lstDates.Clear;
  LoadTreeView;
  if uRDOStick and (uRDOPick > 0) then lstDates.ItemIndex := uRDOPick;
  if tvReports.Items.Count > 0 then
    begin
      tvReports.Selected := tvReports.Items.GetFirstNode;
      tvReportsClick(self);
    end;
end;

procedure TfrmLabs.Timer1Timer(Sender: TObject);
var
  i,j,fail,t: integer;
  r0: String;
begin
  inherited;
  t := Timer1.Interval;
  with RemoteSites.SiteList do
   begin
    for i := 0 to Count - 1 do
      if TRemoteSite(Items[i]).Selected then
       begin
        if Length(TRemoteSite(Items[i]).LabRemoteHandle) > 0 then
          begin
            r0 := GetRemoteStatus(TRemoteSite(Items[i]).LabRemoteHandle);
            TRemoteSite(Items[i]).LabQueryStatus := r0; //r0='1^Done' if no errors
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, piece(r0,'^',2));
            if piece(r0,'^',1) = '1' then
              begin
                GetRemoteData(TRemoteSite(Items[i]).LabData,
                  TRemoteSite(Items[i]).LabRemoteHandle,Items[i]);
                RemoteReports.Add(TRemoteSite(Items[i]).CurrentLabQuery,
                  TRemoteSite(Items[i]).LabRemoteHandle);
                TRemoteSite(Items[i]).LabRemoteHandle := '';
                TabControl1.OnChange(nil);
                if (length(piece(uHState,';',2)) > 0) then
                  begin
                    uLabRemoteReportData.Clear;
                    QuickCopy(TRemoteSite(Items[i]).LabData,uLabRemoteReportData);
                    fail := 0;
                    if uLabRemoteReportData.Count > 0 then
                      begin
                        if uLabRemoteReportData[0] = 'Report not available at this time.' then
                          begin
                            fail := 1;
                            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Report not available');
                          end;
                        if piece(uLabRemoteReportData[0],'^',1) = '-1' then
                          begin
                            fail := 1;
                            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Communication failure');
                          end;
                        if fail = 0 then
                          LoadListView(uLabRemoteReportData);
                      end;
                  end;
              end
            else
              begin
                uRemoteCount := uRemoteCount + 1;
                if uRemoteCount > 90 then //~7 minute limit
                  begin
                    TRemoteSite(Items[i]).LabRemoteHandle := '';
                    TRemoteSite(Items[i]).LabQueryStatus := '-1^Timed out';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Timed out');
                    StatusText('');
                    TabControl1.OnChange(nil);
                  end
                else
                  StatusText('Retrieving Lab data from '
                    + TRemoteSite(Items[i]).SiteName + '...');
              end;
            if t < 5000 then
              begin
                if t < 3001 then Timer1.Interval := 4000
                else if t < 4001 then Timer1.Interval := 5000;
              end;
          end;
       end;
     if Timer1.Enabled = True then
       begin
         j := 0;
         for i := 0 to Count -1 do
           begin
             if Length(TRemoteSite(Items[i]).LabRemoteHandle) > 0 then
               begin
                 j := 1;
                 break;
               end;
           end;
         if j = 0 then  //Shutdown timer if all sites have been processed
           begin
             Timer1.Enabled := False;
             StatusText('');
           end;
         j := 0;
         for i := 0 to Count -1 do
           if TRemoteSite(Items[i]).Selected = true then
             begin
               j := 1;
               break;
             end;
         if j = 0 then  //Shutdown timer if user has de-selected all sites
           begin
             Timer1.Enabled := False;
             StatusText('');
             TabControl1.OnChange(nil);
           end;
       end;
   end;
end;

procedure TfrmLabs.tvReportsClick(Sender: TObject);
var
  i: integer;
  aHeading, aReportType, aRPC, aQualifier, aStartTime, aStopTime, aMax, aRptCode, aRemote, aCategory, aSortOrder, aDaysBack, x, x1, x2: string;
  aIFN, aOldID: integer;
  aID, aHSTag, aColChange, aDirect, aHDR, aFHIE, aFHIEONLY, aQualifierID, aQualAdd: string;
//  CurrentNode: TTreeNode;
  aQualMatch: Boolean;
begin
  inherited;
  lblHeading.Caption := '';
  frmFrame.stsArea.Panels.Items[1].Text := '';
  lvReports.Hint := 'To sort, click on column headers|';
  tvReports.TopItem := tvReports.Selected;
  uRemoteCount := 0;
  Timer1.Interval := 3000;
  uReportInstruction := '';
  aHeading    :=  PReportTreeObject(tvReports.Selected.Data)^.Heading;
  aRemote     :=  PReportTreeObject(tvReports.Selected.Data)^.Remote;
  aReportType :=  PReportTreeObject(tvReports.Selected.Data)^.RptType;
  aQualifier  :=  PReportTreeObject(tvReports.Selected.Data)^.Qualifier;
  aID         :=  PReportTreeObject(tvReports.Selected.Data)^.ID;
  aRPC        :=  PReportTreeObject(tvReports.Selected.Data)^.RPCName;
  aHSTag      :=  PReportTreeObject(tvReports.Selected.Data)^.HSTag;
  aCategory   :=  PReportTreeObject(tvReports.Selected.Data)^.Category;
  aSortOrder  :=  PReportTreeObject(tvReports.Selected.Data)^.SortOrder;
  aDaysBack   :=  PReportTreeObject(tvReports.Selected.Data)^.MaxDaysBack;
  aIFN        :=  StrToIntDef(PReportTreeObject(tvReports.Selected.Data)^.IFN,0);
  aDirect     :=  PReportTreeObject(tvReports.Selected.Data)^.Direct;
  aHDR        :=  PReportTreeObject(tvReports.Selected.Data)^.HDR;
  aFHIE       :=  PReportTreeObject(tvReports.Selected.Data)^.FHIE;
  aFHIEONLY   :=  PReportTreeObject(tvReports.Selected.Data)^.FHIEONLY;
  aStartTime  :=  Piece(aQualifier,';',1);
  aStopTime   :=  Piece(aQualifier,';',2);
  aMax        :=  Piece(aQualifier,';',3);
  aRptCode    :=  Piece(aQualifier,';',4);
  aQualifierID:= '';
  uTVLabReportSet:= true;
  if chkMaxFreq.checked = true then
    begin
      aMax := '';
      SetPiece(aQualifier,';',3,'');
    end;
  if length(uColChange) > 0 then
    begin
      aColChange := '';
      for i := 0 to lvReports.Columns.Count - 1 do
        aColChange := aColChange + IntToStr(lvReports.Column[i].width) + ',';
      if (Length(aColChange) > 0) and (aColChange <> piece(uColchange,'^',2)) then
        SaveColumnSizes(piece(uColChange,'^',1) + '^' + aColChange);
      uColChange := '';
    end;
  if (aReportType <> 'M') and (aRPC = '') and (CharAt(aID,1) = 'H') then
    begin
      aReportType :=  'R';
      aRptCode    :=  LowerCase(CharAt(aID,1)) + Copy(aID, 2, Length(aID));
      aID         :=  '1';
      aRPC        :=  'ORWRP REPORT TEXT';
      aHSTag      :=  '';
    end;
  if uRDOStick = false then
    begin
      rdoToday.Checked := false;
      rdo1Week.Checked := false;
      rdo1Month.Checked := false;
      rdo6Month.Checked := false;
      rdo1Year.Checked := false;
      rdo2Year.Checked := false;
      rdoAllResults.Checked := false;
    end;
  uLabLocalReportData.Clear;
  uLabRemoteReportData.Clear;
  if aReportType = '' then aReportType := 'R';
  uDateOverride := false;
  uReportRPC := aRPC;
  uRptID := aID;
  uLabRepID := aID;
  uDirect := aDirect;
  uReportType := aReportType;
  uQualifier := aQualifier;
  uSortOrder := aSortOrder;
  uRemoteType := aRemote + '^' + aReportType + '^' + IntToStr(aIFN) + '^' + aHeading + '^' + aRptCode + '^' + aDaysBack + '^' + aHDR + '^' + aFHIE + '^' + aFHIEONLY;
  pnlRightTop.Height := lblTitle.Height;  // see below
  RedrawSuspend(tvReports.Handle);
  RedrawSuspend(memLab.Handle);
  uHState := aHSTag;
  Timer1.Enabled := False;
  HideTabControl;
  sptHorzRight.Visible := true;
  lvReports.Visible := false;
  pnlButtons.Visible := false;
  if (aRemote = '1') or (aRemote = '2') then
    if not(uReportType = 'V') and not(uReportType = 'M') then
      ShowTabControl;
  StatusText('');
  uHTMLDoc := '';
  BlankWeb;
  memLab.Lines.Clear;
  memLab.Parent := pnlRightBottom;
  memLab.Align := alClient;
  lvReports.SmallImages := uEmptyImageList;
  lvReports.Items.Clear;
  lvReports.Columns.Clear;
  DisplayHeading('');
  if (Length(piece(uRemoteType,'^',6)) > 0) and (StrToInt(piece(uRemoteType,'^',6)) > 0) then
    uDateOverride := true;
  if uRDOStick and not uDateOverride then
    begin
      case uRDOPick of
        0: rdoDateRange.Checked := true;
        1: rdoToday.Checked := true;
        2: rdo1Week.Checked := true;
        3: rdo1Month.Checked := true;
        4: rdo6Month.Checked := true;
        5: rdo1Year.Checked := true;
        6: rdo2Year.Checked := true;
        7: rdoAllResults.Checked := true;
     end
    end
    else
      sptHorzRightTop.Visible := false;
  if uReportType = 'H' then
    begin
      RightTopHeader(0);
      pnlRightTop.Visible := false;
      lvReports.Visible := false;
      pnlRightBottom.Visible := true;
      WebBrowser.Visible := true;
      WebBrowser.TabStop := true;
      BlankWeb;
      WebBrowser.BringToFront;
      memLab.Visible := false;
      memLab.TabStop := false;
    end
  else
    if uReportType = 'V' then
      begin
        with lvReports do
          begin
            RedrawSuspend(lvReports.Handle);
            Columns.BeginUpdate;
            ViewStyle := vsReport;
            ColumnHeaders(uColumns, IntToStr(aIFN));
            for i := 0 to uColumns.Count -1 do
              begin
                uNewColumn := Columns.Add;
                uNewColumn.Caption := piece(uColumns.Strings[i],'^',1);
                if length(uColChange) < 1 then uColChange := IntToStr(aIFN) + '^';
                if piece(uColumns.Strings[i],'^',2) = '1' then
                  begin
                    uNewColumn.Width := 0;
                    uColChange := uColChange + '0,';
                  end
                else
                  if length(piece(uColumns.Strings[i],'^',10)) > 0 then
                    begin
                      uColChange := uColChange + piece(uColumns.Strings[i],'^',10) + ',';
                      uNewColumn.Width := StrToInt(piece(uColumns.Strings[i],'^',10))
                    end
                  else
                    uNewColumn.Width := ColumnHeaderWidth;  //ColumnTextWidth for width of text
                if (i = 0) and (((aRemote <> '2') and (aRemote <> '1')) or ((TabControl1.Tabs.Count < 2) and (not (aHDR = '1')))) then
                  uNewColumn.Width := 0;
              end;
            Columns.EndUpdate;
            RedrawActivate(lvReports.Handle);
          end;
        pnlRightTopHeader.Visible := true;
        sptHorzRightTop.Visible := true;
        pnlRightTop.Visible := true;
        sptHorzRight.Visible := true;
        WebBrowser.Visible := false;
        WebBrowser.TabStop := false;
        pnlRightBottom.Visible := true;
        memLab.Visible := true;
        memLab.TabStop := true;
        memLab.BringToFront;
        RedrawActivate(memLab.Handle);
      end
    else
      begin
        pnlRightTop.Visible := false;
        sptHorzRight.Visible := false;
        WebBrowser.Visible := false;
        WebBrowser.TabStop := false;
        RightTopHeader(30);
        pnlRightTop.Visible := true;
        sptHorzRightTop.Visible := true;
      end;
  uLabLocalReportData.Clear;
  LabRowObjects.Clear;
  uLabRemoteReportData.Clear;
  lstHeaders.Visible := false;
  lstHeaders.TabStop := false;
  lblHeaders.Visible := false;
  splLeftLower.Visible := false;
  pnlLeftBotUpper.Visible := false;
  lstHeaders.Clear;
  uTVLabReportSet := false;
  if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
  for i := 0 to RemoteSites.SiteList.Count - 1 do
    TRemoteSite(RemoteSites.SiteList.Items[i]).LabClear;
  if uFrozen = True then
    begin
      memo1.visible := False;
      memo1.TabStop := False;
    end;
  Screen.Cursor := crHourGlass;
  x := Piece(aQualifier, ';', 3);
  if (CharAt(lstQualifier.ItemID,1) = 'd')
    and (length(x)>0)
    and (StrToInt(x)<101) then
      aMax := ';101';
  if aReportType = 'M' then
    begin
      CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,false,false);
      memLab.Clear;
      chkBrowser;
      pnlHeader.Visible := false;
      sptHorzRight.Visible := true;
      memLab.Height := pnlRight.Height - (lblHeading.Height + lblTitle.Height);
      pnlRightTop.Visible := true;
      pnlRightTopHeader.Height := lblHeading.Height;
      memLab.Align := alClient;
      FormResize(self);
    end
  else
    begin
    if (CharAt(lstQualifier.ItemID,1) = 'd') and (Length(piece(uRemoteType,'^',6)) > 0) and (StrToInt(piece(uRemoteType,'^',6)) > 0) then
      if ExtractInteger(lstQualifier.ItemID) > (StrToInt(piece(uRemoteType,'^',6))) then
        begin
          InfoBox('The Date Range selected is greater than the' + CRLF + 'Maximum Days Allowed of '
            + piece(uRemoteType,'^',6) + ' for this report.' + CRLF + CRLF
            + 'Please reselect a valid Date Range.', 'No Report Generated',MB_OK);
          uDateOverride := true;
          lstQualifier.ItemIndex := -1;
          rdoDateRange.Checked := false;
          rdoToday.Checked := false;
          rdo1Week.Checked := false;
          rdo1Month.Checked := false;
          rdo6Month.Checked := false;
          rdo1Year.Checked := false;
          rdo2Year.Checked := false;
          rdoAllResults.Checked := false;
          DisplayHeading('d' + piece(uRemoteType,'^',6) + ';' + aMax);
          aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
          aQualMatch := false;
          for i := 0 to lstQualifier.Items.Count - 1 do
            if lstQualifier.Items[i] = aQualAdd then
              begin
                aQualMatch := true;
                lstQualifier.ItemIndex := i;
                break;
              end;
          if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
        end;
      RightTopHeader(0);
      pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height;
      pnlRightTop.Height := pnlLeft.Height - (pnlLeft.Height div 2);
      sptHorzRight.Visible := false;
      pnlRighttop.Visible := false;
      sptHorzRightTop.Visible := false;
      pnlRightTop.Align := alTop;
      pnlRightTop.Visible := true;
      sptHorzRight.Top := pnlRightTop.Height;
      sptHorzRight.Align := alTop;
      sptHorzRight.Visible := true;
      pnlRightBottom.Visible := true;
      pnlRightBottom.Align := alclient;
      pnlWorksheet.Visible := false;
      pnlGraph.Visible := false;
      uQualifierType := StrToIntDef(aRptCode,0);
      case uQualifierType of
        QT_OTHER:
          begin      //      = 0
            memLab.Lines.Clear;
            pnlRightTop.Height := lblTitle.Height;
            if TabControl1.Tabs.Count > 1 then
              pnlRightTop.Height := pnlRightTop.Height + TabControl1.Height;
            if ((aRemote = '1') or (aRemote = '2')) then
              ShowTabControl;

            If aID = '1:MOST RECENT' then
                   begin
                      CommonComponentVisible(false,false,false,false,false,true,true,false,true,false,false,false);
                      RightTopHeader(0);
                      pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height;
                      pnlRightTop.Height := pnlRight.Height - (pnlRight.Height div 2);
                      sptHorzRight.Visible := false;
                      pnlRighttop.Visible := false;
                      sptHorzRightTop.Visible := false;
                      pnlRightTop.Align := alTop;
                      pnlRightTop.Visible := true;
                      sptHorzRight.Top := pnlRightTop.Height;
                      sptHorzRight.Align := alTop;
                      sptHorzRight.Visible := true;

                      pnlRightBottom.Visible := true;
                      pnlRightBottom.Align := alclient;
                      pnlButtons.Visible := true;
                      pnlWorksheet.Visible := false;
                      pnlGraph.Visible := false;
                      memLab.Align := alBottom;
                      grdLab.Align := alTop;
                      memLab.Clear;
                      if uReportType = 'H' then
                       begin
                         BlankWeb;
                         WebBrowser.Align := alBottom;
                         WebBrowser.Height := pnlLeft.Height div 5;
                         WebBrowser.Visible := true;
                         WebBrowser.BringToFront;
                         memLab.Visible := false;
                       end
                      else
                      begin
                        WebBrowser.Visible := false;
                        WebBrowser.SendToBack;
                        memLab.Visible := true;
                        memLab.BringToFront;
                      end;
                      FormResize(self);
                      cmdRecentClick(self);
                      if upnlRightTopHeight_1 > 0 then
                        pnlRightTop.Height := upnlRightTopHeight_1;
                      uPrevReportNode := tvReports.Selected;
                   end
            else if aID = '4:SELECTED TESTS BY DATE' then
                  begin               // Interim for Selected Tests
                    if uPrevReportNode <> tvReports.Selected then
                    begin
                     lstTests.Clear;
                     lblSpecimen.Caption := '';
                    end;
                    SelectTests(Font.Size);
                    if lstTests.Items.Count > 0 then
                    begin
                     CommonComponentVisible(false,false,true,true,true,false,false,false,true,false,false,false);
                     pnlRighttop.Height := lblHeading.Height + lblTitle.Height;
                     memLab.Clear;
                     chkBrowser;
                     if upnlLeftTopHeight_2 >0 then pnlLefTop.Height := upnlLeftTopHeight_2;
                     FormResize(self);
                     RedrawActivate(memLab.Handle);
                     uRDOChanging := true;
                     lstDatesClick(self);
                     uRDOChanging := false;
                     pnlLeftBottom.Visible := true;
                     cmdOtherTests.SetFocus;
                     cmdOtherTests.Default := true;
                     uPrevReportNode := tvReports.Selected;
                     pnlRightTop.Visible := false;
                     sptHorzRightTop.Visible := true;
                     sptHorzRightTop.Align := alTop;
                     if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(30)
                        else
                          RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := true;
                        lblDates.Visible := false;
                        lblQualifier.Visible := false;
                        lstQualifier.Visible := false;
                        lstDates.Visible := false;
                        pnlLeftBotLower.Visible := false;
                      end
                      else
                      begin
                        RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := false;
                      end;
                    end
                    else
                      begin
                        tvReports.Selected := uPrevReportNode;
                      end;
                  end
            else if aID = '5:WORKSHEET' then
                  begin               // Worksheet
                    if uPrevReportNode <> tvReports.Selected then
                    begin
                     lstTests.Clear;
                     lblSpecimen.Caption := '';
                    end;
                    SelectTestGroups(Font.Size);
                    if lstTests.Items.Count > 0 then
                    begin
                     pnlRighttop.Visible := false;
                     CommonComponentVisible(false,false,true,true,true,true,true,false,false,false,false,false);
                     pnlRighttop.Height := pnlRight.Height - (pnlRight.Height div 2);
                     chtChart.Visible := true;
                     memLab.Visible := false;
                     pnlButtons.Visible := false;
                     pnlGraph.Visible := false;
                     pnlWorksheet.Visible := true;
                     sptHorzRightTop.Visible := false;
                     sptHorzRight.Visible := false;
                     pnlRightTop.Align := alTop;
                     pnlRightTop.Visible := true;
                     sptHorzRightTop.Top := pnlRightTop.Top;
                     sptHorzRightTop.Align := alTop;
                     sptHorzRightTop.Visible := true;
                     sptHorzRight.Top := pnlRightTop.Height;
                     sptHorzRight.Align := alTop;
                     sptHorzRight.Visible := true;
                     lstTestGraph.Width := 150;
                     if upnlLeftTopHeight_1 >0 then pnlLefTop.Height := upnlLeftTopHeight_1;
                     ragCorG.ItemIndex := 0;
                     FormResize(self);
                     lblFooter.Caption := '  KEY: "L" = Abnormal Low, "H" = Abnormal High, "*" = Critical Value, "**" = Comments on Specimen';
                     pnlLeftBottom.Visible := true;
                     cmdOtherTests.SetFocus;
                     cmdOtherTests.Default := true;
                     uPrevReportNode := tvReports.Selected;
                     if (lstDates.ItemIndex = -1) and uRDOStick and (uRDOPick > 0) then lstDates.ItemIndex := uRDOPick;
                     if lstDates.ItemIndex = -1 then
                      if Patient.Inpatient then
                        begin
                        lstDates.ItemIndex := 2;
                        rdoToday.Checked := true;
                        end
                      else
                        begin
                        lstDates.ItemIndex := 4;
                        rdo6Month.Checked := true;
                        end;
                     uRDOChanging := true;
                     lstDatesClick(self);
                     uRDOChanging := false;
                     if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(30)
                        else
                        RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := true;
                        lblDates.Visible := false;
                        lblQualifier.Visible := false;
                        lstQualifier.Visible := false;
                        lstDates.Visible := false;
                        pnlLeftBotLower.Visible := false;
                      end
                      else
                      begin
                        RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := false;
                      end;
                     if ScreenReaderSystemActive then
                     begin
                       grdLab.SetFocus;
                       lbl508Footer.Caption := lblFooter.Caption;
                       lbl508Footer.Visible := true;
                       lblFooter.Visible := false;
                     end;
                    end
                    else
                      begin
                        tvReports.Selected := uPrevReportNode;
                      end;
                    if upnlRightTopHeight_2 > 0 then
                      pnlRightTop.Height := upnlRightTopHeight_2;
                  end

            else if aID = '6:GRAPH' then
                  begin               // Graph
                    // do if graphing is activiated
                    if uGraphingActivated then
                    begin
                     memLab.Clear;
                     chkBrowser;
                     FormResize(self);
                     memLab.Align := alClient;
                     CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,false,false);
                     pnlRightTop.Visible := false;
                     RedrawActivate(memLab.Handle);
                     StatusText('');
                     memLab.Lines.Insert(0, ' ');
                     memLab.Lines.Insert(1, 'Graphing activated');
                     memLab.SelStart := 0;
                     frmFrame.mnuToolsGraphingClick(self);  // make it just lab tests ??
                    end
                    else  // otherwise, do lab graph
                    begin
                     if uPrevReportNode <> tvReports.Selected then
                     begin
                       lblSingleTest.Caption := '';
                       lblSpecimen.Caption := '';
                     end;
                     SelectTest(Font.Size);
                     if (length(lblSingleTest.Caption) > 2) and (length(lblSpecimen.Caption) > 2) then
                     begin
                       CommonComponentVisible(false,false,true,true,true,true,false,false,true,false,false,false);
                       pnlChart.Visible := true;
                       chtChart.Visible := true;
                       pnlButtons.Visible := false;
                       pnlWorksheet.Visible := false;
                       pnlGraph.Visible := true;
                       memLab.Height := pnlRight.Height div 5;
                       memLab.Clear;
                       if uReportType = 'H' then
                       begin
                         WebBrowser.Visible := true;
                         BlankWeb;
                         WebBrowser.Height := pnlRight.Height div 5;
                         WebBrowser.BringToFront;
                         memLab.Visible := false;
                       end
                       else
                       begin
                         WebBrowser.Visible := false;
                         WebBrowser.SendToBack;
                         memLab.Visible := true;
                         memLab.BringToFront;
                       end;
                       lstTestGraph.Items.Clear;
                       lstTestGraph.Width := 0;
                       FormResize(self);
                       RedrawActivate(memLab.Handle);
                       lblFooter.Caption := '';
                       if lbl508Footer.Enabled then lbl508Footer.Caption := '';
                       chkGraphZoom.Checked := false;
                       chkGraphZoomClick(self);
                       chkGraph3DClick(self);
                       chkGraphValuesClick(self);
                       uRDOChanging := true;
                       lstDatesClick(self);
                       uRDOChanging := false;
                       pnlLeftBottom.Visible := true;
                       cmdOtherTests.SetFocus;
                       cmdOtherTests.Default := true;
                       uPrevReportNode := tvReports.Selected;
                     end
                     else
                       tvReports.Selected := uPrevReportNode;
                    end;
                  end

            else if (aID = '9:MICROBIOLOGY') or (aID = '20:ANATOMIC PATHOLOGY') or (aID = '2:BLOOD BANK') or (aID = '10:LAB STATUS') or (aID = '3:ALL TESTS BY DATE') or (aID = '21:CUMULATIVE') or (aID = '27:AUTOPSY') then
                  begin
                    //added to deal with other reports from file 101.24
                    memLab.Clear;
                    chkBrowser;
                    pnlHeader.Visible := false;
                    pnlRightTop.Visible := false;
                    pnlRightBottom.Visible := false;
                    sptHorzRight.Visible := false;
                    pnlRightTop.Height := lblHeading.Height;
                    if TabControl1.Tabs.Count > 1 then
                      pnlRightTopHeader.Height := pnlRightTopHeader.Height + TabControl1.Height;
                    if ((aRemote = '1') or (aRemote = '2')) then
                      ShowTabControl;
                    pnlRightTopHeader.Align := alTop;
                    pnlRightTop.Align := alTop;
                    pnlRightBottom.Align := alclient;
                    sptHorzRight.Visible := true;
                    pnlRightBottom.Visible := true;
                    lvReports.Visible := false;
                    memLab.Align := alClient;
                    RightTopHeader(0);
                    if (lstDates.ItemIndex = -1) and uRDOStick and (uRDOPick > 0) then lstDates.ItemIndex := uRDOPick;
                    if lstDates.ItemIndex = -1 then
                      if Patient.Inpatient then lstDates.ItemIndex := 2
                      else lstDates.ItemIndex := 4;
                    FormResize(self);
                    aOldID := 1;
                    if aID = '9:MICROBIOLOGY' then aOldID := 4;
                    //if aID = '20:ANATOMIC PATHOLOGY' then AOldID := 8;
                    if aID = '2:BLOOD BANK' then AOldID := 9;
                    if aID = '10:LAB STATUS' then AOldID := 10;
                    if aID = '3:ALL TESTS BY DATE' then AOldID := 3;
                    if aID = '21:CUMULATIVE' then AOldID := 2;
                    case StrToInt(aCategory) of
                                  {Categories of reports:
                                      0:Fixed
                                      1:Fixed w/Dates
                                      2:Fixed w/Headers
                                      3:Fixed w/Dates & Headers
                                      4:Specialized
                                      5:Graphic}

                      0: begin
                          CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,false,false);
                          sptHorzRightTop.Visible := true;
                          sptHorzRightTop.Align := alTop;
                          StatusText('Retrieving data...');
                          GoRemoteOld(uLabRemoteReportData,StrToInt(Piece(aID,':',1)),aOldID,'',uReportRPC,'0','9999','1',0,0);
                          TabControl1.OnChange(nil);
                          Reports(uLabLocalReportData,Patient.DFN, 'L:' + Piece(aID,':',1), '0', '9999', '1', 0, 0, uReportRPC);
                          if TabControl1.TabIndex < 1 then
                            QuickCopy(uLabLocalReportData,memLab);
                          RedrawActivate(memLab.Handle);
                          StatusText('');
                          memLab.Lines.Insert(0,' ');
                          memLab.Lines.Delete(0);
                          memLab.SelStart := 0;
                          RightTopHeader(0);
                          pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height;
                          if TabControl1.Tabs.Count > 1 then
                            pnlRightTopHeader.Height := pnlRightTopHeader.Height + TabControl1.Height;
                          if uReportType = 'R' then
                          uHTMLDoc := HTML_PRE + uLabLocalReportData.Text + HTML_POST
                          else
                          uHTMLDoc := String(uHTMLPatient) + uLabLocalReportData.Text;
                          if WebBrowser.Visible then BlankWeb;
                         end;
                      1: begin
                          CommonComponentVisible(false,false,false,true,true,false,false,false,false,false,false,false);
                          sptHorzRightTop.Visible := true;
                          sptHorzRightTop.Align := alTop;
                          if upnlLeftTopHeight_4 >0 then pnlLefTop.Height := upnlLeftTopHeight_4;
                          memLab.Repaint;
                          uRDOChanging := true;
                          lstDatesClick(self);
                          uRDOChanging := false;
                          if uUseRadioButton then
                            begin
                              if not (uReportType = 'M') then
                                RightTopHeader(30)
                              else
                                RightTopHeader(0);
                              pnlRightTopHeaderMid.Visible := true;
                              lblDates.Visible := false;
                              lblQualifier.Visible := false;
                              lstQualifier.Visible := false;
                              lstDates.Visible := false;
                              pnlLeftBotLower.Visible := false;
                            end
                          else
                            begin
                              RightTopHeader(0);
                              pnlRightTopHeaderMid.Visible := false;
                            end;
                         end;
                      2: begin
                          CommonComponentVisible(true,true,false,false,false,false,false,false,false,false,false,false);
                          sptHorzRightTop.Visible := true;
                          sptHorzRightTop.Align := alTop;
                          if upnlLeftTopHeight_3 >0 then pnlLefTop.Height := upnlLeftTopHeight_3;
                          lstHeaders.Clear;
                          StatusText('Retrieving data...');
                          GoRemoteOld(uLabRemoteReportData,StrToInt(Piece(aID,':',1)),aOldID,'',uReportRPC,'0','9999','1',0,0);
                          TabControl1.OnChange(nil);
                          Reports(uLabLocalReportData,Patient.DFN, Piece(aID,':',1), '0', '9999', '1', 0, 0, uReportRPC);
                          if uLabLocalReportData.Count > 0 then
                          begin
                           TabControl1.OnChange(nil);
                           if lstHeaders.Items.Count > 0 then
                           begin
                            lstHeaders.ItemIndex := 0;
                            lstHeaders.TabStop := true;
                           end;
                          end;
                          if pnlLeftBotUpper.Height < 20 then pnlLeftBotUpper.Height := (pnlLeftBottom.Height div 2);
                          RedrawActivate(memLab.Handle);
                          StatusText('');
                          memLab.Lines.Insert(0,' ');
                          memLab.Lines.Delete(0);
                          if uReportType = 'R' then
                           uHTMLDoc := HTML_PRE + uLabLocalReportData.Text + HTML_POST
                          else
                           uHTMLDoc := String(uHTMLPatient) + uLabLocalReportData.Text;
                          if WebBrowser.Visible then BlankWeb;
                         end;
                      3: begin
                          lstDatesClick(self);
                          CommonComponentVisible(true,true,false,true,true,false,false,false,true,false,false,false);
                          sptHorzRightTop.Visible := true;
                          sptHorzRightTop.Align := alTop;
                          if upnlLeftTopHeight_3 >0 then pnlLefTop.Height := upnlLeftTopHeight_3;
                          memLab.Lines.Insert(0,' ');
                          memLab.Lines.Delete(0);
                          if uUseRadioButton then
                            begin
                              if not (uReportType = 'M') then
                                RightTopHeader(30)
                              else
                              RightTopHeader(0);
                              pnlRightTopHeaderMid.Visible := true;
                              lblDates.Visible := false;
                              lblQualifier.Visible := false;
                              lstQualifier.Visible := false;
                              lstDates.Visible := false;
                              //splLeftLower.Visible := false;
                              pnlLeftBotLower.Visible := false;
                            end
                          else
                            begin
                              RightTopHeader(0);
                              pnlRightTopHeaderMid.Visible := false;
                            end;
                         end;
                    end;
                    uPrevReportNode := tvReports.Selected;
                  end

            //else if aID = '20:ANATOMIC PATHOLOGY' then

            //else if aID = '2:BLOOD BANK' then

            //else if aID = '10:LAB STATUS' then


            else
              begin
                pnlRightTopHeaderMid.Visible := false;
                CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,false,false);
                sptHorzRightTop.Visible := true;
                sptHorzRightTop.Align := alTop;
                RightTopHeader(0);
                StatusText('Retrieving ' + tvReports.Selected.Text + '...');
                if ((aRemote = '1') or (aRemote = '2')) then
                  GoRemote(uLabRemoteReportData, 'L:' + aID, aRptCode, aRPC, uHState, aHDR, aFHIE)
                else
                  if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                uReportInstruction := #13#10 + 'Retrieving data...';
                TabControl1.OnChange(nil);
                if not(piece(uRemoteType, '^', 9) = '1') then
                  begin
                    LoadReportText(uLabLocalReportData, 'L:' + aID, aRptCode, aRPC, uHState);
                    QuickCopy(uLabLocalReportData, memLab);
                  end;
                if WebBrowser.Visible then
                  begin
                    if uReportType = 'R' then
                      uHTMLDoc := HTML_PRE + uLabLocalReportData.Text + HTML_POST
                    else
                      uHTMLDoc := String(uHTMLPatient) + uLabLocalReportData.Text;
                    BlankWeb;
                  end;
                if uLabLocalReportData.Count > 0 then
                    TabControl1.OnChange(nil);
                StatusText('');
                uPrevReportNode := tvReports.Selected;
              end;
          end;
        QT_DATERANGE:
          begin      //      = 2
            CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,true,true);
            aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
            if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
            if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
            if lstQualifier.ItemID = '' then
              begin
                aQualMatch := false;
                for i := 0 to lstQualifier.Items.Count - 1 do
                  if lstQualifier.Items[i] = aQualAdd then
                    begin
                      aQualMatch := true;
                      lstQualifier.ItemIndex := i;
                      break;
                    end;
                if not aQualMatch then
                  begin
                    lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                    lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                  end;
                lvReports.SmallImages := uEmptyImageList;
                lvReports.Items.Clear;
              end
            else if not(uRDOPick > 0) then
              begin
                aQualMatch := false;
                for i := 0 to lstQualifier.Items.Count - 1 do
                  if lstQualifier.Items[i] = aQualAdd then
                    begin
                      aQualMatch := true;
                      lstQualifier.ItemIndex := i;
                      break;
                    end;
                if not aQualMatch then
                  begin
                    lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                    lstDates.Items.Add(aQualAdd);
                  end;
              end;
            uRDOChanging := true;
            lstQualifierClick(self);
            uRDOChanging := false;
            lblQualifier.Caption := 'Date Range';
            splLeft.Visible := true;
            pnlLeftBottom.Visible := true;
            CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,true,true);
            pnlRightTop.Visible := false;
            if uUseRadioButton then
              begin
                if not (uReportType = 'M') then
                  RightTopHeader(30)
                else
                  RightTopHeader(0);
                pnlRightTopHeaderMid.Visible := true;
                lblDates.Visible := false;
                lblQualifier.Visible := false;
                lstQualifier.Visible := false;
                lstDates.Visible := false;
                pnlLeftBotLower.Visible := false;
              end
            else
              begin
                RightTopHeader(0);
                pnlRightTopHeaderMid.Visible := false;
              end;
            uPrevReportNode := tvReports.Selected;
          end;
        QT_HSCOMPONENT:
          begin      //      = 5
            if Notifications.AlertData <> '' then
              pnlRightTop.Height := 75
            else
              pnlRightTop.Height := pnlRight.Height - (pnlRight.Height div 2);
            StatusText('Retrieving ' + tvReports.Selected.Text + '...');
            uReportInstruction := #13#10 + 'Retrieving data...';
            CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,false,false);
            RightTopHeader(0);
            lvReports.SmallImages := uEmptyImageList;
            lvReports.Items.Clear;
            LabRowObjects.Clear;
            memLab.Lines.Clear;
            pnlRightTopHeaderMid.Visible := false;
            if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
            aQualifierID := lstQualifier.ItemID;
            //
            if lstQualifier.ItemID = '' then
              begin
                if aHDR = '1' then aQualAdd := 'T-37000' + ';' + 'T+37000' + '^' + 'T-37000' + ' to ' + 'T+37000'
                  else aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
                aQualMatch := false;
                for i := 0 to lstQualifier.Items.Count - 1 do
                  if lstQualifier.Items[i] = aQualAdd then
                    begin
                      aQualMatch := true;
                      lstQualifier.ItemIndex := i;
                      break;
                    end;
                if not aQualMatch then
                  begin
                    lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                  end;
              end;
            //
            aQualifierID := lstQualifier.ItemID;
            if (length(piece(aHSTag,';',2)) > 0) then
              begin
                if aCategory <> '0' then
                  begin
                    if aHDR = '1' then aQualAdd := 'T-37000' + ';' + 'T+37000' + '^' + 'T-37000' + ' to ' + 'T+37000'
                    else aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
                    if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
                    if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
                    if lstQualifier.ItemID = '' then
                      begin
                        aQualMatch := false;
                        for i := 0 to lstQualifier.Items.Count - 1 do
                          if lstQualifier.Items[i] = aQualAdd then
                            begin
                              aQualMatch := true;
                              lstQualifier.ItemIndex := i;
                              break;
                            end;
                        if not aQualMatch then
                          begin
                            lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                            lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                          end;
                      end
                      else
                        begin
                          if ((aRemote = '1') or (aRemote = '2')) then
                            GoRemote(uLabRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
                          else
                            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                          if not(uRDOPick > 0) then
                            begin
                              aQualMatch := false;
                              for i := 0 to lstQualifier.Items.Count - 1 do
                                if lstQualifier.Items[i] = aQualAdd then
                                  begin
                                    aQualMatch := true;
                                    lstQualifier.ItemIndex := i;
                                    break;
                                  end;
                              if not aQualMatch then
                                begin
                                  lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                                  lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                                end;
                            end;
                        end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,true,true);
                    splLeft.Visible := true;
                    pnlLeftBottom.Visible := true;
                    if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(30)
                        else
                          RightTopHeader(0);
                      end
                    else RightTopHeader(0);
                  end
                else
                  begin
                    if not (aRemote = '2' ) then
                      GoRemote(uLabRemoteReportData, 'L:' + aID, aQualifier, aRPC, uHState, aHDR, aFHIE)
                    else
                      if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                    if not(piece(uRemoteType, '^', 9) = '1') then
                      begin
                        LoadReportText(uLabLocalReportData, 'L:' + aID, aQualifier, aRPC, uHState);
                        LoadListView(uLabLocalReportData);
                      end;
                    RightTopHeader(0);
                    pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height;
                    if TabControl1.Tabs.Count > 1 then
                      pnlRightTopHeader.Height := pnlRightTopHeader.Height + TabControl1.Height;
                  end;
              end
            else
              begin
                if (aRemote = '1') or (aRemote = '2') then
                  if TabControl1.Tabs.Count > 1 then
                    ShowTabControl;
                sptHorzRight.Visible := false;
                pnlRightTop.Visible := false;
                if ((aRemote = '1') or (aRemote = '2')) then
                  GoRemote(uLabRemoteReportData, 'L:' + aID, aQualifier, aRPC, uHState, aHDR, aFHIE)
                else
                  if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                if not(piece(uRemoteType, '^', 9) = '1') then
                  LoadReportText(uLabLocalReportData, 'L:' + aID, aQualifier, aRPC, uHState);
                if uLabLocalReportData.Count < 1 then
                  uReportInstruction := '<No Report Available>'
                else
                  begin
                    if TabControl1.TabIndex < 1 then
                      QuickCopy(uLabLocalReportData,memLab);
                  end;
                TabControl1.OnChange(nil);
                if aCategory <> '0' then
                  begin
                    if aHDR = '1' then aQualAdd := 'T-37000' + ';' + 'T+37000' + '^' + 'T-37000' + ' to ' + 'T+37000'
                    else aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
                    if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
                    if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
                    if lstQualifier.ItemID = '' then
                      begin
                        aQualMatch := false;
                        for i := 0 to lstQualifier.Items.Count - 1 do
                          if lstQualifier.Items[i] = aQualAdd then
                            begin
                              aQualMatch := true;
                              lstQualifier.ItemIndex := i;
                              break;
                            end;
                        if not aQualMatch then
                          begin
                            lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                            lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                          end;
                      end
                    else if not(uRDOPick > 0) then
                      begin
                        aQualMatch := false;
                        for i := 0 to lstQualifier.Items.Count - 1 do
                          if lstQualifier.Items[i] = aQualAdd then
                            begin
                              aQualMatch := true;
                              lstQualifier.ItemIndex := i;
                              break;
                            end;
                        if not aQualMatch then
                          begin
                            lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                            lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                          end;
                      end;
                    lblQualifier.Caption := 'Date Range';
                    CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,true,true);
                    splLeft.Visible := true;
                    pnlLeftBottom.Visible := true;
                    if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(30)
                        else
                          RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := true;
                        lblDates.Visible := false;
                        lblQualifier.Visible := false;
                        lstQualifier.Visible := false;
                        lstDates.Visible := false;
                        pnlLeftBotLower.Visible := false;
                      end
                    else
                      begin
                        RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := false;
                      end;
                  end
                else
                  begin
                    if uLabLocalReportData.Count < 1 then
                      begin
                        uReportInstruction := '<No Report Available>';
                        memLab.Lines.Add(uReportInstruction);
                      end
                    else
                      begin
                        QuickCopy(uLabLocalReportData,memLab);
                        TabControl1.OnChange(nil);
                      end;
                  end;
              end;
            StatusText('');
            uPrevReportNode := tvReports.Selected;
            if aCategory <> '0' then
              begin
                if upnlRightTopHeight_3 > 0 then pnlRightTop.Height := upnlRightTopHeight_3;
                if upnlLeftTopHeight_4 >0 then pnlLefTop.Height := upnlLeftTopHeight_4;
              end;
          end;
        QT_HSWPCOMPONENT:
          begin      //      = 6
            pnlRightTop.Height := pnlRight.Height - (pnlRight.Height div 2);
            StatusText('Retrieving ' + tvReports.Selected.Text + '...');
            uReportInstruction := #13#10 + 'Retrieving data...';
            CommonComponentVisible(false,false,false,false,false,false,false,false,false,true,false,false);
            RightTopHeader(0);
            TabControl1.OnChange(nil);
            LabRowObjects.Clear;
            memLab.Lines.Clear;
            lvReports.SmallImages := uEmptyImageList;
            lvReports.Items.Clear;
            memLab.Repaint;
            if uRDOPick > 0 then lstQualifier.ItemIndex := uRDOPick;
            aQualifierID := lstQualifier.ItemID;
            if (length(piece(aHSTag,';',2)) > 0) then
              begin
                if aCategory <> '0' then
                  begin
                    if aHDR = '1' then aQualAdd := 'T-37000' + ';' + 'T+37000' + '^' + 'T-37000' + ' to ' + 'T+37000'
                    else aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
                    if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
                    if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
                    if lstQualifier.ItemID = '' then
                      begin
                        aQualMatch := false;
                        for i := 0 to lstQualifier.Items.Count - 1 do
                          if lstQualifier.Items[i] = aQualAdd then
                            begin
                              aQualMatch := true;
                              lstQualifier.ItemIndex := i;
                              break;
                            end;
                        if not aQualMatch then
                          begin
                            lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                            lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                          end;
                      end
                    else
                      begin
                        if ((aRemote = '1') or (aRemote = '2')) then
                          GoRemote(uLabRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
                        else
                          if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                        if not(uRDOPick > 0) then
                          begin
                            aQualMatch := false;
                            for i := 0 to lstQualifier.Items.Count - 1 do
                              if lstQualifier.Items[i] = aQualAdd then
                                begin
                                  aQualMatch := true;
                                  lstQualifier.ItemIndex := i;
                                  break;
                                end;
                            if not aQualMatch then
                              begin
                                lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                                lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                              end;
                          end;
                      end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    CommonComponentVisible(false,false,false,false,false,false,false,false,false,true,true,true);
                    splLeft.Visible := true;
                    pnlLeftBottom.Visible := true;
                    splLeft.Visible := true;
                    if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(30)
                        else
                          RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := true;
                        lblDates.Visible := false;
                        lblQualifier.Visible := false;
                        lstQualifier.Visible := false;
                        lstDates.Visible := false;
                        pnlLeftBotLower.Visible := false;
                      end
                    else
                      begin
                        RightTopHeader(0);
                        pnlRightTopHeaderMid.Visible := false;
                      end;
                  end
                else
                  begin
                    if ((aRemote = '1') or (aRemote = '2')) then
                      GoRemote(uLabRemoteReportData, 'L:' + aID, aQualifier, aRPC, uHState, aHDR, aFHIE)
                    else
                      if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                    if not (aRemote = '2' ) and (not(piece(uRemoteType, '^', 9) = '1')) then
                      begin
                        LoadReportText(uLabLocalReportData, 'L:' + aID, aQualifier, aRPC, uHState);
                        LoadListView(uLabLocalReportData);
                      end;
                    RightTopHeader(0);
                    pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height;
                  end;
              end
            else
              begin
                if (aRemote = '1') or (aRemote = '2') then
                  ShowTabControl;
                sptHorzRight.Visible := false;
                sptHorzRightTop.Visible := false;
                pnlRightTop.Visible := false;
                if ((aRemote = '1') or (aRemote = '2')) then
                  GoRemote(uLabRemoteReportData, 'L:' + aID, aQualifier, aRPC, uHState, aHDR, aFHIE)
                else
                  if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                if not(piece(uRemoteType, '^', 9) = '1') then
                  LoadReportText(uLabLocalReportData, 'L:' + aID, aQualifier, aRPC, uHState);
                if uLabLocalReportData.Count < 1 then
                  uReportInstruction := '<No Report Available>'
                else
                  begin
                    if TabControl1.TabIndex < 1 then
                      QuickCopy(uLabLocalReportData,memLab);
                  end;
                TabControl1.OnChange(nil);
                if aCategory <> '0' then
                  begin
                    if aHDR = '1' then aQualAdd := 'T-37000' + ';' + 'T+37000' + '^' + 'T-37000' + ' to ' + 'T+37000'
                    else aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
                    if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
                    if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
                    if lstQualifier.ItemID = '' then
                      begin
                        aQualMatch := false;
                        for i := 0 to lstQualifier.Items.Count - 1 do
                          if lstQualifier.Items[i] = aQualAdd then
                            begin
                              aQualMatch := true;
                              lstQualifier.ItemIndex := i;
                              break;
                            end;
                        if not aQualMatch then
                          begin
                            lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                            lstDates.ItemIndex := lstDates.Items.Add(aQualAdd);
                          end;
                      end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    splLeft.Visible := true;
                    pnlLeftBottom.Visible := true;
                    CommonComponentVisible(false,false,false,false,false,false,false,false,false,false,true,true);
                    if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(30)
                        else
                          RightTopHeader(0);
                      end
                    else RightTopHeader(0);
                  end
                else
                  begin
                    LoadListView(uLabLocalReportData);
                  end;
              end;
            StatusText('');
            uPrevReportNode := tvReports.Selected;
          end;
        else
          begin      //      = ?
            uQualifierType := QT_OTHER;
            RightTopHeader(0);
            StatusText('Retrieving ' + tvReports.Selected.Text + '...');
            if ((aRemote = '1') or (aRemote = '2')) then
              GoRemote(uLabRemoteReportData, 'L:' + aID, aRptCode, aRPC, uHState, aHDR, aFHIE)
            else
              if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
            uReportInstruction := #13#10 + 'Retrieving data...';
            TabControl1.OnChange(nil);
            if not(piece(uRemoteType, '^', 9) = '1') then
              LoadReportText(uLabLocalReportData, 'L:' + aID, '', aRPC, uHState);
            if uLabLocalReportData.Count < 1 then
              uReportInstruction := '<No Report Available>'
            else
              begin
                if TabControl1.TabIndex < 1 then
                  QuickCopy(uLabLocalReportData,memLab);
              end;
            TabControl1.OnChange(nil);
            StatusText('');
            uPrevReportNode := tvReports.Selected;
          end;
        lstQualifier.Caption := lblQualifier.Caption;
      end;
    end;
  {if not uRDOStick then
    begin
      if lstQualifier.ItemIndex > -1 then
        begin
        if not (aHDR = '1') then
          if (aCategory <> '0') and (not WebBrowser.Visible) then
              DisplayHeading(uQualifier)
          else
            DisplayHeading('');
        end
      else
        begin
          if not (aHDR = '1') and (lstDates.ItemIndex > -1) then
            if (aCategory <> '0') and (not WebBrowser.Visible) then
              begin
                x := lstDates.DisplayText[lstDates.ItemIndex];
                x1 := piece(x,' ',1);
                x2 := piece(x,' ',3);
                if (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
                  DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2) + ';' + aMax)
                else
                  DisplayHeading('d' + lstDates.ItemID + ';' + aMax);
              end
            else
              DisplayHeading('');
        end;
    end
  else if not uDateOverride then
    begin
      if (uRDOPick > 0) and (not(aHDR = '1')) then
        begin
        if (aCategory <> '0') and (not WebBrowser.Visible) then
          begin
            begin
              lstQualifier.ItemIndex := uRDOPick;
              x := lstQualifier.DisplayText[uRDOPick]
            end;
          x := lstQualifier.DisplayText[lstQualifier.ItemIndex];
          x1 := piece(x,' ',1);
          x2 := piece(x,' ',3);
          if (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
            DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2) + ';' + aMax)
          else
            DisplayHeading(lstQualifier.ItemID + ';' + aMax);
        end;
        end
      else
        DisplayHeading(lstQualifier.ItemID + ';' + aMax);
    end; }
  if aCategory <> '0' then
    begin
      if upnlRightTopHeight_3 > 0 then pnlRightTop.Height := upnlRightTopHeight_3;
      if upnlLeftTopHeight_4 >0 then pnlLefTop.Height := upnlLeftTopHeight_4;
    end;
  SendMessage(tvReports.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
  RedrawActivate(tvReports.Handle);
  if WebBrowser.Visible  then begin
    BlankWeb;
    WebBrowser.BringToFront;
    lstHeaders.Visible := false;
    lblHeaders.Visible := false;
    lstHeaders.TabStop := false;
    pnlLeftBotUpper.Visible := false;
    splLeftLower.Visible := false;
    pnlLefTop.Height := frmLabs.Height;
    pnlLeftBottom.Visible := false;
    RightTopHeader(0);
  end else begin
    memLab.Visible := true;
    memLab.TabStop := true;
    memLab.BringToFront;
    RedrawActivate(memLab.Handle);
  end;
  lvReports.Columns.BeginUpdate;
  lvReports.Columns.EndUpdate;
  Screen.Cursor := crDefault;
end;

procedure TfrmLabs.tvReportsCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  inherited;
  tvReports.Selected := Node;
end;

procedure TfrmLabs.tvReportsExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  inherited;
  tvReports.Selected := Node;
end;

procedure TfrmLabs.tvReportsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_LBUTTON, VK_RETURN, VK_SPACE:
    begin
      tvReportsClick(Sender);
      Key := 0;
    end;
  end;
end;

procedure TfrmLabs.GoRemote(Dest: TStringList; AItem: string; AQualifier, ARpc: string; AHSTag: string; AHDR: string; aFHIE: string);
var
  i, j: integer;
  LocalHandle, Query, Report, Seq, aVistaWebLabel: string;
  HSType, DaysBack, ExamID, MaxOcc: string;
  Alpha, Omega, Trans: double;
begin
  HSType := '';
  DaysBack := '';
  ExamID := '';
  Alpha := 0;
  Omega := 0;
  Seq := '';
  aVistaWebLabel := GetVistaWeb_JLV_LabelName;
  if aVistaWebLabel = '' then aVistaWebLabel := 'VistaWeb';
  if AHDR = '1' then
    begin
      if HDRActive = '0' then
        begin
          InfoBox('The HDR is currently inactive.' + CRLF + 'Unable to retrieve HDR data at this time.', 'HDR Error', MB_OK);
          Exit;
        end;
        InfoBox('You must use ' + aVistaWebLabel + ' to view this report.', 'Use ' + aVistaWebLabel + ' for HDR data', MB_OK);
      if (Piece(AItem, ':', 1) = 'OR_VWAL') or (Piece(AItem, ':', 1) = 'OR_VWRX') then
        AQualifier := 'T-37000;T+37000;99999';
      if (Piece(AItem, ':', 1) = 'OR_VWVS') and (CharAt(AQualifier, 1) = ';') then
        AQualifier := 'T-37000;T+37000;99999';
    end;
  if CharAt(AQualifier, 1) = 'd' then
    begin
      DaysBack := Copy(AQualifier, 2, Length(AQualifier));
      AQualifier := ('T-' + Piece(DaysBack,';',1) + ';T;' + Pieces(AQualifier,';',2,3));
      DaysBack := '';
    end;
  if CharAt(AQualifier, 1) = 'T' then
    begin
      if Piece(AQualifier,';',1) = 'T-0' then SetPiece(AQualifier,';',1,'T');
      if (Piece(Aqualifier,';',1) = 'T') and (Piece(Aqualifier,';',2) = 'T')
        then SetPiece(AQualifier,';',2,'T+1');
      Alpha := StrToFMDateTime(Piece(AQualifier,';',1));
      Omega := StrToFMDateTime(Piece(AQualifier,';',2));
      if Alpha > Omega then
        begin
          Trans := Omega;
          Omega := Alpha;
          Alpha := Trans;
        end;
      MaxOcc := Piece(AQualifier,';',3);
      SetPiece(AHSTag,';',4,MaxOcc);
    end;
  if CharAt(AQualifier, 1) = 'h' then HSType   := Copy(AQualifier, 2, Length(AQualifier));
  if CharAt(AQualifier, 1) = 'i' then ExamID   := Copy(AQualifier, 2, Length(AQualifier));
  with RemoteSites.SiteList do for i := 0 to Count - 1 do
    begin
    if (AHDR='1') and (LeftStr(TRemoteSite(Items[i]).SiteID, 5) = '200HD') then
      begin
        TRemoteSite(Items[i]).Selected := true;
        frmFrame.lstCIRNLocations.Checked[i+1] := true;
      end;
    if TRemoteSite(Items[i]).Selected then
      begin
        TRemoteSite(Items[i]).ReportClear;
        if (LeftStr(TRemoteSite(Items[i]).SiteID, 5) = '200HD') and not(AHDR = '1') then
          begin
            TRemoteSite(Items[i]).LabQueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TRemoteSite(Items[i]).LabRemoteHandle := '';
            TRemoteSite(Items[i]).LabQueryStatus := '1^Done';
            if uQualifierType = 6 then seq := '1^';
            TRemoteSite(Items[i]).Data.Add(seq + TRemoteSite(Items[i]).SiteName);
            if uQualifierType = 6 then seq := '2^';
            TRemoteSite(Items[i]).Data.Add(seq + '<No HDR Data Included> - Use "HDR Reports" menu for HDR Data.');
            TabControl1.OnChange(nil);
            if (length(piece(uHState,';',2)) > 0) then
              LoadListView(TRemoteSite(Items[i]).Data);
            continue;
          end;
        if (AHDR = '1') and not(LeftStr(TRemoteSite(Items[i]).SiteID, 5) = '200HD') then
          begin
            TRemoteSite(Items[i]).LabQueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TRemoteSite(Items[i]).LabRemoteHandle := '';
            TRemoteSite(Items[i]).LabQueryStatus := '1^Done';
            if uQualifierType = 6 then seq := '1^';
            TRemoteSite(Items[i]).Data.Add(seq + TRemoteSite(Items[i]).SiteName);
            if uQualifierType = 6 then seq := '2^';
            TRemoteSite(Items[i]).Data.Add(seq + '<No HDR Data> This site is not a source for HDR Data.');
            TabControl1.OnChange(nil);
            if (length(piece(uHState,';',2)) > 0) then
              LoadListView(TRemoteSite(Items[i]).Data);
            continue;
          end;
        if (LeftStr(TRemoteSite(Items[i]).SiteID, 4) = '200N') then
          begin
            TRemoteSite(Items[i]).QueryStatus := '1^Not Included - USE ' + aVistaWebLabel;
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED - USE ' + aVistaWebLabel);
            TRemoteSite(Items[i]).RemoteHandle := '';
            TRemoteSite(Items[i]).QueryStatus := '1^Done';
            continue;
          end;
        if (LeftStr(TRemoteSite(Items[i]).SiteID, 3) = '200') and not(aFHIE = '1') then
          begin
            TRemoteSite(Items[i]).LabQueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TRemoteSite(Items[i]).LabRemoteHandle := '';
            TRemoteSite(Items[i]).LabQueryStatus := '1^Done';
            if uQualifierType = 6 then seq := '1^';
            TRemoteSite(Items[i]).Data.Add(seq + TRemoteSite(Items[i]).SiteName);
            if uQualifierType = 6 then seq := '2^';
            TRemoteSite(Items[i]).Data.Add(seq + '<No DOD Data> - Use "Dept. of Defense Reports" Menu to retrieve data from DOD.');
            TabControl1.OnChange(nil);
            if (length(piece(uHState,';',2)) > 0) then
              LoadListView(TRemoteSite(Items[i]).Data);
            continue;
          end;

        TRemoteSite(Items[i]).CurrentReportQuery := 'Report' + Patient.DFN + ';'
          + Patient.ICN + '^' + AItem + '^^^' + ARpc + '^' + HSType +
          '^' + DaysBack + '^' + ExamID + '^' + FloatToStr(Alpha) + '^' +
          FloatToStr(Omega) + '^' + TRemoteSite(Items[i]).SiteID + '^' + AHSTag + '^' + AHDR;
        LocalHandle := '';
        Query := TRemoteSite(Items[i]).CurrentReportQuery;
        for j := 0 to RemoteReports.Count - 1 do
          begin
            Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
            if Report = Query then
              begin
                LocalHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle;
                break;
              end;
          end;
        if Length(LocalHandle) > 1 then
          with RemoteSites.SiteList do
            begin
              GetRemoteData(TRemoteSite(Items[i]).Data,LocalHandle,Items[i]);
              TRemoteSite(Items[i]).LabRemoteHandle := '';
              TRemoteSite(Items[i]).LabQueryStatus := '1^Done';
              UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Done');
              TabControl1.OnChange(nil);
              if (length(piece(uHState,';',2)) > 0) then
                LoadListView(TRemoteSite(Items[i]).Data);
            end
        else
          begin
            if uDirect = '1' then
              begin
                StatusText('Retrieving reports from ' + TRemoteSite(Items[i]).SiteName + '...');
                TRemoteSite(Items[i]).LabQueryStatus := '1^Direct Call';
                UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Direct Call');
                DirectQuery(Dest, AItem, HSType, Daysback, ExamID, Alpha, Omega, TRemoteSite(Items[i]).SiteID, ARpc, AHSTag);
                if Copy(Dest[0],1,2) = '-1' then
                  begin
                    TRemoteSite(Items[i]).LabQueryStatus := '-1^Communication error';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Communication error');
                    if uQualifierType = 6 then seq := '1^';
                    TRemoteSite(Items[i]).Data.Add(seq + TRemoteSite(Items[i]).SiteName);
                    if uQualifierType = 6 then seq := '2^';
                    TRemoteSite(Items[i]).Data.Add(seq + '<ERROR>- Unable to communicate with Remote site');
                    TabControl1.OnChange(nil);
                    if (length(piece(uHState,';',2)) > 0) then
                      LoadListView(TRemoteSite(Items[i]).Data);
                  end
                else
                  begin
                    QuickCopy(Dest,TRemoteSite(Items[i]).Data);
                    TRemoteSite(Items[i]).LabRemoteHandle := '';
                    TRemoteSite(Items[i]).LabQueryStatus := '1^Done';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Done');
                    TabControl1.OnChange(nil);
                    if (length(piece(uHState,';',2)) > 0) then
                      LoadListView(TRemoteSite(Items[i]).Data);
                  end;
                StatusText('');
              end
            else
              begin
                RemoteQuery(Dest, AItem, HSType, Daysback, ExamID, Alpha, Omega, TRemoteSite(Items[i]).SiteID, ARpc, AHSTag);
                if Dest[0] = '' then
                  begin
                    TRemoteSite(Items[i]).LabQueryStatus := '-1^Communication error';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Communication error');
                    if uQualifierType = 6 then seq := '1^';
                    TRemoteSite(Items[i]).Data.Add(seq + TRemoteSite(Items[i]).SiteName);
                    if uQualifierType = 6 then seq := '2^';
                    TRemoteSite(Items[i]).Data.Add(seq + '<ERROR>- Unable to communicate with Remote site');
                    TabControl1.OnChange(nil);
                    if (length(piece(uHState,';',2)) > 0) then
                      LoadListView(TRemoteSite(Items[i]).Data);
                  end
                else
                  begin
                    TRemoteSite(Items[i]).LabRemoteHandle := Dest[0];
                    TRemoteSite(Items[i]).LabQueryStatus := '0^initialization...';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'initialization');
                    Timer1.Enabled := True;
                    StatusText('Retrieving reports from ' + TRemoteSite(Items[i]).SiteName + '...');
                  end;
              end;
          end;
      end;
    end;
end;

procedure TfrmLabs.GoRemoteOld(Dest: TStringList; AItem, AReportID: Int64; AQualifier,
  ARpc, AHSType, ADaysBack, ASection: string; ADate1, ADate2: TFMDateTime);
var
  i,j: integer;
  LocalHandle, Report, Query: String;
begin
  { AReportID := 1  Generic report   RemoteLabReports
                 2  Cumulative       RemoteLabCumulative
                 3  Interim          RemoteLabInterim
                 4  Microbioloby     RemoteLabMicro }

  with RemoteSites.SiteList do
    for i := 0 to Count - 1 do
      if TRemoteSite(Items[i]).Selected then
        begin
          TRemoteSite(Items[i]).LabClear;
          if (LeftStr(TRemoteSite(Items[i]).SiteID, 5) = '200HD') then
          begin
            TRemoteSite(Items[i]).LabQueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TabControl1.OnChange(nil);
            continue;
          end;
           if (LeftStr(TRemoteSite(Items[i]).SiteID, 5) = '200') then
          begin
            TRemoteSite(Items[i]).LabQueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TabControl1.OnChange(nil);
            continue;
          end;
          TRemoteSite(Items[i]).CurrentLabQuery := 'Lab' + Patient.DFN + ';' + Patient.ICN +
            '^' + 'L:' + IntToStr(AItem) + '^' +  IntToStr(AReportID) + '^^' + ARpc + '^' + AHSType +
            '^' + ADaysBack + '^' + ASection + '^' + DateToStr(ADate1) + '^' + DateToStr(ADate2) + '^' +
            TRemoteSite(Items[i]).SiteID;
          LocalHandle := '';
          for j := 0 to RemoteReports.Count - 1 do
            begin
              Query := TRemoteSite(Items[i]).CurrentLabQuery;
              Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
              if Report = Query then
                begin
                  LocalHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle;
                  break;
                end;
            end;
          if Length(LocalHandle) > 1 then
            with RemoteSites.SiteList do
              begin
                GetRemoteData(TRemoteSite(Items[i]).LabData,LocalHandle,Items[i]);
                TRemoteSite(Items[i]).LabRemoteHandle := '';
                TRemoteSite(Items[i]).LabQueryStatus := '1^Done';
                UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Done');
                TabControl1.OnChange(nil);
              end
          else
            begin
              case AReportID of
              1: begin
                   RemoteLabReports(Dest, Patient.DFN + ';' + Patient.ICN, 'L:' + IntToStr(AItem),
                     AHSType, ADaysBack, ASection, ADate1, ADate2,
                     TRemoteSite(Items[i]).SiteID, ARpc);
                 end;
              2: begin
                   RemoteLabCumulative(Dest, Patient.DFN + ';' + Patient.ICN,
                     StrToInt(Adaysback), Adate1, Adate2, TRemoteSite(Items[i]).SiteID,ARpc);
                 end;
              3: begin
                   RemoteLabInterim(Dest, Patient.DFN + ';' + Patient.ICN, Adate1, Adate2,
                     TRemoteSite(Items[i]).SiteID, ARpc);
                 end;
              4: begin
                   RemoteLabMicro(Dest, Patient.DFN + ';' + Patient.ICN, Adate1, Adate2,
                     TRemoteSite(Items[i]).SiteID, ARpc);
                 end;
              else begin
                     RemoteLab(Dest, Patient.DFN + ';' + Patient.ICN, 'L:' + IntToStr(AItem),
                     AHSType, ADaysBack, ASection, ADate1, ADate2,
                     TRemoteSite(Items[i]).SiteID, ARpc);
                   end;
              end;
              if Dest[0] = '' then
                begin
                  TRemoteSite(Items[i]).LabQueryStatus := '-1^Communication error';
                  UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Communication error');
                end
              else
                begin
                  TRemoteSite(Items[i]).LabRemoteHandle := Dest[0];
                  TRemoteSite(Items[i]).LabQueryStatus := '0^initialization...';
                  UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Initialization');
                  Timer1.Enabled := True;
                  StatusText('Retrieving reports from '
                    + TRemoteSite(Items[i]).SiteName + '...');
                end;
            end;
        end;
end;

procedure TfrmLabs.TabControl1Change(Sender: TObject);
var
  aStatus: string;
  hook: Boolean;
  i: integer;
begin
  inherited;
  if (uQualifiertype <> 6) or (length(piece(uHState,';',2)) < 1) then
    memLab.Lines.Clear;
  lstHeaders.Items.Clear;
  uHTMLDoc := '';
  if WebBrowser.visible then BlankWeb;
  if (length(piece(uHState,';',2)) = 0) then with TabControl1 do
    begin
      memLab.Lines.BeginUpdate;
      if TabIndex > 0 then
        begin
          aStatus := TRemoteSite(Tabs.Objects[TabIndex]).LabQueryStatus;
          if aStatus = '1^Done' then
            begin
              if Piece(TRemoteSite(Tabs.Objects[TabIndex]).LabData[0],'^',1) = '[HIDDEN TEXT]' then
                begin
                  lstHeaders.Clear;
                  hook := false;
                  for i := 1 to TRemoteSite(Tabs.Objects[TabIndex]).LabData.Count - 1 do
                    if hook = true then
                        memLab.Lines.Add(TRemoteSite(Tabs.Objects[TabIndex]).LabData[i])
                    else
                      begin
                        lstHeaders.Items.Add(MixedCase(TRemoteSite(Tabs.Objects[TabIndex]).LabData[i]));
                        if Piece(TRemoteSite(Tabs.Objects[TabIndex]).LabData[i],'^',1) = '[REPORT TEXT]' then
                          hook := true;
                      end;
                end
              else
                QuickCopy(TRemoteSite(Tabs.Objects[TabIndex]).LabData,memLab);
              memLab.Lines.Insert(0,' ');
              memLab.Lines.Delete(0);
            end;
          if Piece(aStatus,'^',1) = '-1' then
            memLab.Lines.Add('Remote data transmission error: ' + Piece(aStatus,'^',2));
          if Piece(aStatus,'^',1) = '0' then
            memLab.Lines.Add('Retrieving data... ' + Piece(aStatus,'^',2));
          if Piece(aStatus,'^',1) = '' then
            memLab.Lines.Add(uReportInstruction);
        end
      else
        if uLabLocalReportData.Count > 0 then
          begin
            if Piece(uLabLocalReportData[0],'^',1) = '[HIDDEN TEXT]' then
              begin
                lstHeaders.Clear;
                hook := false;
                for i := 1 to uLabLocalReportData.Count - 1 do
                  if hook = true then
                    memLab.Lines.Add(uLabLocalReportData[i])
                  else
                    begin
                      lstHeaders.Items.Add(MixedCase(uLabLocalReportData[i]));
                      if Piece(uLabLocalReportData[i],'^',1) = '[REPORT TEXT]' then
                        hook := true;
                    end;
              end
            else
              if tvReports.Selected.Text = 'Imaging (local only)' then
                   memLab.Lines.clear
              else
                QuickCopy(uLabLocalReportData,memLab);
            memLab.Lines.Insert(0,' ');
            memLab.Lines.Delete(0);
          end
        else
          memLab.Lines.Add(uReportInstruction);
      if WebBrowser.Visible then begin
        if uReportType = 'R' then
          uHTMLDoc := HTML_PRE + uLabLocalReportData.Text + HTML_POST
        else
          uHTMLDoc := String(uHTMLPatient) + uLabLocalReportData.Text;
        BlankWeb;
      end;
      memLab.SelStart := 0;
      memLab.Lines.EndUpdate;
    end;
end;

procedure TfrmLabs.ChkBrowser;
begin
  if uReportType = 'H' then
   begin
     WebBrowser.Visible := true;
     BlankWeb;
     WebBrowser.BringToFront;
     memLab.Visible := false;
   end
 else
  begin
    WebBrowser.Visible := false;
    WebBrowser.SendToBack;
    memLab.Visible := true;
    memLab.BringToFront;
  end;
end;

procedure TfrmLabs.CommonComponentVisible(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12: Boolean);
begin
  lstDates.Caption := lblDates.Caption;
  lstHeaders.Caption := lblHeaders.Caption;
  if A4 or A2 or A12 then
    begin
      pnlLefTop.Height := (frmLabs.Height div 2);
      pnlLeftBottom.Visible := false;
      splLeft.Visible := false;
      splLeft.Visible := true;
      pnlLeftBottom.Visible := true;
    end
    else
    begin
      //pnlLefTop.Height := frmLabs.Height;
    end;
  lstQualifier.Visible := false;
  lblQualifier.Visible := false;
  pnlOtherTests.Visible := false;
  lstHeaders.Visible := false;
  lblHeaders.Visible := false;
  pnlLeftBotUpper.Visible := false;
  sptHorzRight.Visible := false;
  lblHeaders.Visible := A1;
  lstHeaders.Visible := A2;
  lblQualifier.Visible := A11;
  lstQualifier.Visible := A12;
  lblDates.Visible := A4;
  lstDates.Visible := A5;        // reordered to realign
  if A5 then
    begin
      if uUseRadioButton = true then RightTopHeader(30)
      else RightTopHeader(0);
    end;
  if uUseRadioButton then
    if A5 or A11 or A12 then
      begin
        pnlRightTopHeaderMid.Visible := true;
        lblDates.Visible := false;
        lblQualifier.Visible := false;
        lstQualifier.Visible := false;
        lstDates.Visible := false;
        pnlLeftBotLower.Visible := false;
      end
    else
      begin
        pnlRightTopHeaderMid.Visible := false;
      end;
  pnlOtherTests.Visible := A3;
  if (A3 or A2) then
    begin
      pnlLeftBotUpper.Visible := true;
    end;
  if (not A2 and A3) then
    begin
      pnlLeftBotUpper.Height := pnlOtherTests.Height;
    end;
  if (A3 and A2) then
    begin
      pnlLeftBotUpper.Height := pnlOtherTests.Height + lblHeaders.Height + lstHeaders.Height;
    end;
  if (A2 and not A3) then pnlLeftBotUpper.Height := lblHeaders.Height + lstHeaders.Height;

  pnlHeader.Visible := A6;
  grdLab.Visible := A7;
  pnlChart.Visible := A8;
  pnlFooter.Visible := A9;
  if A10 = true then sptHorzRightTop.Visible := true;
  lvReports.Visible := A10;
  if lvReports.Visible = true then sptHorzRight.Visible := true;
  if grdLab.Visible = true then sptHorzRight.Visible := true;
  if A4 and A1 and (lblDates.Top < lblHeaders.Top) then
    begin
      lblDates.Caption := 'Headings';  // swithes captions if not aligned
      lblHeaders.Caption := 'Date Range';
    end
    else
    begin
      lblDates.Caption := 'Date Range';
      lblHeaders.Caption := 'Headings';
    end;
  frmLabs.Realign;
end;

procedure TfrmLabs.ShowTabControl;
begin
  if TabControl1.Tabs.Count > 1 then
    begin
      TabControl1.Visible := true;
      TabControl1.TabStop := true;
      if uUseRadioButton = true then RightTopHeader(30)
      else RightTopHeader(0);
    end;
end;

procedure TfrmLabs.RightTopHeader(MidSize: Integer);
begin
  if (pnlRightTopHeaderMid.Height > MidSize) and not (MidSize = 0) then MidSize := 30;
  if rdoDateRange.Height > 20 then MidSize := MidSize + (rdoDateRange.Height - 20);

  if (TabControl1.Tabs.Count > 1) and (TabControl1.Visible) then
    begin
      pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height + MidSize + TabControl1.Height;
    end
  else
    pnlRightTopHeader.Height := pnlRightTopHeaderTop.Height + MidSize;
end;

procedure TfrmLabs.HideTabControl;
begin
  TabControl1.Visible := false;
  TabControl1.TabStop := false;

  if uUseRadioButton = true then
    if not (uReportType = 'M') then
      RightTopHeader(30)
    else
      RightTopHeader(0)
  else RightTopHeader(0);
end;

procedure TfrmLabs.splLeftCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if NewSize < 150 then
    Newsize := 150;
end;

procedure TfrmLabs.splLeftLowerMoved(Sender: TObject);
begin
  inherited;
  if pnlLeftBotUpper.Height < 50 then pnlLeftBotUpper.Height := 50;
  if lstHeaders.Count > 0 then
    begin
      if pnlLeftBotUpper.Height < 150 then pnlLeftBotUpper.Height := 150;
    end;
  splLeftLower.Visible := false;
  pnlLeftBotLower.Visible := false;
  pnlLeftBotUpper.Visible := true;
  splLeftLower.Visible := true;
  pnlLeftBotLower.Visible := true;
end;

procedure TfrmLabs.Memo1Enter(Sender: TObject);
begin
  inherited;
if ScreenReaderActive then
     GetScreenReader.Speak(Memo1.Text)
end;

procedure TfrmLabs.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then
  begin
    if ssShift in Shift then
    begin
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
      Key := 0;
    end
    else if ssCtrl	in Shift then
    begin
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
      Key := 0;
    end;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

{ TGrdLab508Manager }

constructor TGrdLab508Manager.Create;
begin
  inherited Create([mtValue, mtItemChange]);
end;

function TGrdLab508Manager.GetItem(Component: TWinControl): TObject;
var
  sg : TCaptionStringGrid;
begin
  sg := TCaptionStringGrid(Component);
  Result := TObject(sg.Selection.Top + sg.Selection.Left);
end;

function TGrdLab508Manager.GetTextToSpeak(sg: TCaptionStringGrid): String;
var
  textToSpeak : String;
  CurrRowStrings,HeaderStrings : TStrings;
  i : integer;
begin
  textToSpeak := '';
  HeaderStrings := sg.Rows[0];
  CurrRowStrings := sg.Rows[sg.Selection.Top];
  for i := 0 to CurrRowStrings.Count - 1 do begin
    textToSpeak := TextToSpeak + ', ' + HeaderStrings[i] + ', ' + ToBlankIfEmpty(CurrRowStrings[i]);
  end;
  Result := textToSpeak;
end;

function TGrdLab508Manager.GetValue(Component: TWinControl): string;
var
  sg : TCaptionStringGrid;
begin
  sg := TCaptionStringGrid(Component);
  Result := GetTextToSpeak(sg);
end;

function TGrdLab508Manager.ToBlankIfEmpty(aString: String): String;
begin
  Result := aString;
  if aString = '' then
  Result := 'blank';
end;

procedure TfrmLabs.sptHorzRightMoved(Sender: TObject);
begin
  inherited;
  if uRptID = '1:MOST RECENT' then
    upnlRightTopHeight_1 := pnlRightTop.Height;
  if uRptID = '5:WORKSHEET' then
    upnlRightTopHeight_2 := pnlRightTop.Height;
  if uQualifierType = QT_HSWPCOMPONENT then
    upnlRightTopHeight_3 := pnlRightTop.Height;
end;

procedure TfrmLabs.splLeftMoved(Sender: TObject);
begin
  inherited;
  if uRptID = '5:WORKSHEET' then
    upnlLeftTopHeight_1 := pnlLefTop.Height;
  if uRptID = '4:SELECTED TESTS BY DATE' then
    upnlLeftTopHeight_2 := pnlLefTop.Height;
  if uRptID = '21:CUMULATIVE' then
    upnlLeftTopHeight_3 := pnlLefTop.Height;
  if uQualifierType = QT_HSWPCOMPONENT then
    upnlLeftTopHeight_4 := pnlLefTop.Height;
  if uRptID = '3:ALL TESTS BY DATE' then
    upnlLeftTopHeight_4 := pnlLefTop.Height;

end;

initialization
  SpecifyFormIsNotADialog(TfrmLabs);

end.
