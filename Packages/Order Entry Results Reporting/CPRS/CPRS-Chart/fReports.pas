unit fReports;

interface

uses                                           
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, ORCtrls, ComCtrls, Menus, uConst, ORDtTmRng,
  OleCtrls, SHDocVw, Buttons, ClipBrd, rECS, Variants, StrUtils, fBase508Form,
  VA508AccessibilityManager, VA508ImageListLabeler;

type
  TfrmReports = class(TfrmHSplit)
    PopupMenu1: TPopupMenu;
    GotoTop1: TMenuItem;
    GotoBottom1: TMenuItem;
    FreezeText1: TMenuItem;
    UnFreezeText1: TMenuItem;
    calApptRng: TORDateRangeDlg;
    Timer1: TTimer;
    pnlLefTop: TPanel;
    lblTypes: TOROffsetLabel;
    Splitter1: TSplitter;
    pnlLeftBottom: TPanel;
    lblQualifier: TOROffsetLabel;
    lblHeaders: TLabel;
    lstHeaders: TORListBox;
    lstQualifier: TORListBox;
    pnlRightTop: TPanel;
    pnlRightBottom: TPanel;
    pnlRightMiddle: TPanel;
    TabControl1: TTabControl;
    lvReports: TCaptionListView;
    Memo1: TMemo;
    WebBrowser: TWebBrowser;
    memText: TRichEdit;
    sptHorzRight: TSplitter;
    tvReports: TORTreeView;
    PopupMenu2: TPopupMenu;
    Print1: TMenuItem;
    Copy1: TMenuItem;
    Print2: TMenuItem;
    Copy2: TMenuItem;
    SelectAll1: TMenuItem;
    SelectAll2: TMenuItem;
    pnlProcedures: TPanel;
    lblProcedures: TOROffsetLabel;
    tvProcedures: TORTreeView;
    lblProcTypeMsg: TOROffsetLabel;
    pnlViews: TORAutoPanel;
    chkDualViews: TCheckBox;
    btnChangeView: TORAlignButton;
    btnGraphSelections: TORAlignButton;
    lblDateRange: TLabel;
    lstDateRange: TORListBox;
    pnlTopViews: TPanel;
    pnlTopRtLabel: TPanel;
    lblTitle: TOROffsetLabel;
    chkMaxFreq: TCheckBox;
    imgLblImages: TVA508ImageListLabeler;
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
    sptHorzRightTop: TSplitter;
    procedure lstQualifierClick(Sender: TObject);
    procedure GotoTop1Click(Sender: TObject);
    procedure GotoBottom1Click(Sender: TObject);
    procedure FreezeText1Click(Sender: TObject);
    procedure UnFreezeText1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DisplayHeading(aRanges: string);
    procedure Timer1Timer(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GoRemote(Dest: TStringList; AItem: string; AQualifier, ARpc: string; AHSTag: string; AHDR: string; aFHIE: string);
    procedure lstHeadersClick(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure sptHorzRightCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure lstQualifierDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure tvReportsClick(Sender: TObject);
    procedure lvReportsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvReportsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvReportsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure LoadListView(aReportData: TStringList);
    procedure LoadTreeView;
    procedure tvReportsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvReportsCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure Print1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Print2Click(Sender: TObject);
    procedure UpdateRemoteStatus(aSiteID, aStatus: string);
    procedure lvReportsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelectAll1Click(Sender: TObject);
    procedure SelectAll2Click(Sender: TObject);
    procedure tvReportsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoadProceduresTreeView(x: string; var CurrentParentNode: TTreeNode;       
      var CurrentNode: TTreeNode);
    procedure tvProceduresCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);                                                      
    procedure tvProceduresExpanding(Sender: TObject; Node: TTreeNode;                   
      var AllowExpansion: Boolean);
    procedure tvProceduresClick(Sender: TObject);
    procedure tvProceduresChange(Sender: TObject; Node: TTreeNode);
    procedure tvProceduresKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkDualViewsClick(Sender: TObject);
    procedure btnChangeViewClick(Sender: TObject);
    procedure btnGraphSelectionsClick(Sender: TObject);
    procedure lstDateRangeClick(Sender: TObject);
    procedure sptHorzMoved(Sender: TObject);
    procedure chkMaxFreqClick(Sender: TObject);
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
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
  private
    SortIdx1, SortIdx2, SortIdx3: Integer;
    procedure ProcessNotifications;
    procedure ShowTabControl;
    procedure HideTabControl;
    procedure Graph(reportien: integer);
    procedure GraphPanel(active: boolean);
    procedure RightTopHeader(MidSize: Integer);
    procedure RDOChange(rdoIndex: integer);
    procedure BlankWeb;
  public
    procedure ClearPtData; override;
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure DisplayPage; override;
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure RequestPrint; override;
  end;

var
  frmReports: TfrmReports;
  uHSComponents: TStringList;  //components selected
                               //segment^OccuranceLimit^TimeLimit^Header...
                               //^(value of uComponents...)
  uHSAll: TStringList;  //List of all displayable Health Summaries
  uLocalReportData: TStringList;  //Storage for Local report data
  uRemoteReportData: TStringList; //Storage for status of Remote data
  uReportInstruction: String;     //User Instructions
  uNewColumn: TListColumn;
  uListItem: TListItem;
  uColumns: TStringList;
  uTreeStrings: TStrings;
  uMaxOcc: string;
  uHState: string;
  uQualifier: string;
  uReportType: string;
  uSortOrder: string;
  uQualifierType: Integer;
  uFirstSort: Integer;
  uSecondSort: Integer;
  uThirdSort: Integer;
  uColChange: string;               //determines when column widths have changed
  uUpdateStat: boolean;             //flag turned on when remote status is being updated
  ulvSelectOn: boolean;             //flag turned on when multiple items in lvReports control have been selected
  uListState: Integer;              //Checked state of list of Adhoc components Checked: Abbreviation, UnChecked: Name
  uECSReport: TECSReport;           //Event Capture Report, initiated in fFrame when Click Event Capture under Tools
  UpdatingLvReports: Boolean;       //Currently updating lvReports
  UpdatingTvProcedures: Boolean;    //Currently updating tvProcedures
  uUseRadioButton: boolean;         //Parameter to determine use of DateTime Radio Button Selection
  uRDOChanging: boolean;            //Set to true when a Radio button is selected
  ulstDatesChanging: boolean;       //Set to true when lstDates item is selected to keep Radio button from selecting lstDatesClick again
  ulstQualifierChanging: boolean;   //Set to true when lstQualifier item is selected to keep Radio Button from selecting lstQualifierClick again
  uRDOStick: boolean;               //When a DateTime Radio Button is selected, make it stick for subsequent report selections
  uRDOPick: Integer;                //Matches the Selected Radio Button Tab #
  uDateOverride: boolean;           //Set to true if selected report has a maximum # of days defined
  uTVReportSet: boolean;            //Set when report is selected from tvReportsClick, used to prevent multiple loading of reports

implementation

{$R *.DFM}

uses ORFn, rCore, rReports, fFrame, uCore, uReports, fReportsPrint,
     fReportsAdhocComponent1, activex, mshtml, dShared, fGraphs, fGraphData, rGraphs, rLabs,
     VA508AccessibilityRouter, VAUtils;

const
  BlankWebPage = 'about:blank';
  CT_REPORTS    =10;        // ID for REPORTS tab used by frmFrame
  QT_OTHER      = 0;
  QT_HSTYPE     = 1;
  QT_DATERANGE  = 2;
  QT_IMAGING    = 3;
  QT_NUTR       = 4;
  QT_PROCEDURES = 19;
  QT_SURGERY    = 28;
  QT_HSCOMPONENT   = 5;
  QT_HSWPCOMPONENT = 6;
  TX_NOREPORT     = 'No report is currently selected.';
  TX_NOREPORT_CAP = 'No Report Selected';
  HTML_PRE  = '<html><head><style>' + CRLF +
              'PRE {font-size:8pt;font-family: "Courier New", "monospace"}' + CRLF +
              '</style></head><body><pre>';
  HTML_POST = CRLF + '</pre></body></html>';

var
  uRemoteCount: Integer;
  uFrozen: Boolean;
  uHTMLDoc: string;
  uReportRPC: string;
  uHTMLPatient: ANSIstring;
  uRptID: String;
  uDirect: String;
  uEmptyImageList: TImageList;
  ColumnToSort: Integer;
  ColumnSortForward: Boolean;
  GraphForm: TfrmGraphs;
  GraphFormActive: boolean;

procedure TfrmReports.ClearPtData;
begin
  inherited ClearPtData;
  if Assigned(WebBrowser) then begin
    uHTMLDoc := '';
    BlankWeb;
  end;
  Timer1.Enabled := False;
  memText.Clear;
  tvProcedures.Items.Clear;
  lblProcTypeMsg.Visible := FALSE;
  lvReports.SmallImages := uEmptyImageList;
  imgLblImages.ComponentImageListChanged;
  lvReports.Items.Clear;
  uLocalReportData.Clear;
  uRemoteReportData.Clear;
  TabControl1.Tabs.Clear;
  HideTabControl;
  lstDateRange.Tag := 0; // used to reset date default on graph
  if (GraphForm <> nil) and GraphFormActive then
  with GraphForm do
  begin
    GraphForm.SendToBack;
    Initialize;
    DisplayData('top');
    DisplayData('bottom');
    //GtslCheck.Clear;
    GraphFormActive := false;
  end;
  begin
  end;
end;

procedure TfrmReports.Graph(reportien: integer);
begin
  if uUseRadioButton then
    begin
      pnlLeftBottom.Visible := false;
      splitter1.Visible := false;
      RightTopHeader(70);
      pnlRightTopHeaderMid.Visible := true;
      pnlRightTopHeaderMidUpper.Visible := true;
      lblDateRange.Visible := false;
      lblQualifier.Visible := false;
      lstQualifier.Visible := false;
      lstDateRange.Visible := false;
    end
  else
    begin
      RightTopHeader(34);
      pnlRightTopHeaderMid.Visible := false;
    end;
  if GraphForm = nil then
  begin
    GraphForm := TfrmGraphs.Create(self);
    try
      with GraphForm do
      begin
        if btnClose.Tag = 1 then
          Exit;
        Parent := pnlRight;
        Align := alClient;
        pnlFooter.Tag := 1;   //suppresses bottom of graph form
        pnlBottom.Height := 1;
        pnlMain.BevelInner := bvLowered;
        pnlMain.BevelOuter := bvRaised;
        pnlMain.Tag := reportien;
        Initialize;
        ResizeAnchoredFormToFont(GraphForm);
        Show;
        DisplayData('top');
        DisplayData('bottom');
        //GtslCheck.Clear;
        GraphPanel(true);
        frmGraphData.pnlData.Hint := Patient.DFN;
        BringToFront;
      end;
    finally
      if GraphForm.btnClose.Tag = 1 then
      begin
        GraphFormActive := false;
        GraphForm.Free;
        GraphForm := nil;
      end
      else
        GraphFormActive := true;
    end;
  end
  else if GraphForm.btnClose.Tag = 1 then
    Exit
  else if frmGraphData.pnlData.Hint = Patient.DFN then
  begin   // displaying same patient
    if Tag <> reportien then   // different report
    with GraphForm do
    begin  // new report
      SendToBack;
      GraphPanel(false);
      pnlMain.Tag := reportien;
      Initialize;
      DisplayData('top');
      DisplayData('bottom');
      //GtslCheck.Clear;
      GraphPanel(true);
      BringToFront;
      GraphFormActive := true;
    end
    else
    begin   // bring back graph
      GraphPanel(true);
      BringToFront;
      GraphFormActive := true;
    end;
  end
  else
  with GraphForm do
  begin  // new patient
    pnlMain.Tag := reportien;
    Initialize;
    DisplayData('top');
    DisplayData('bottom');
    //GtslCheck.Clear;
    frmGraphData.pnlData.Hint := Patient.DFN;
    GraphPanel(true);
    BringToFront;
    GraphFormActive := true;
  end;
end;

procedure TfrmReports.GraphPanel(active: boolean);
var
  adddaterange: boolean;
  i: integer;
  aQualifier, aStartTime, aStopTime, aNewLine, aRptCode, aQualAdd: string;
begin
  if active then
  begin
    aRptCode := Piece(PReportTreeObject(tvReports.Selected.Data)^.Qualifier, ';',4);
    uQualifierType := StrToIntDef(aRptCode,0);
    pnlLeftBottom.Height := pnlLeft.Height div 2;
    pnlViews.Height := pnlLeftBottom.Height;
    if pnlLeft.Height < 200 then
      pnlTopViews.Height := 3
    else
      pnlTopViews.Height := 80;
    lblQualifier.Visible := false;
    lstQualifier.Visible := false;
    pnlViews.Visible := true;
    if lstDateRange.Tag = 0 then
    begin
      lstDateRange.Tag := 1;
      aQualifier  :=  PReportTreeObject(tvReports.Selected.Data)^.Qualifier;
      aStartTime  :=  Piece(aQualifier,';',1);
      aStopTime   :=  Piece(aQualifier,';',2);
      adddaterange := true;
      aNewLine := '^' + aStartTime + ' to ' + aStopTime +'^^^' + aStartTime + ';' +  aStopTime +
        '^' + floattostr(strtofmdatetime(aStartTime)) + '^' + floattostr(strtofmdatetime(aStopTime));
      aQualAdd := aStartTime + ';' + aStopTime + '^' + aStartTime + ' to ' + aStopTime;
      for i := 0 to GraphForm.cboDateRange.Items.Count - 1 do
        if GraphForm.cboDateRange.Items[i] = aNewLine then
        begin
          adddaterange := false;
          break;
        end;
      if adddaterange then
        begin
          GraphForm.cboDateRange.Items.Add(aNewLine);
          lstQualifier.Items.Add(aQualAdd);
        end;
      lstDateRange.Items := GraphForm.cboDateRange.Items;
      GraphForm.DateDefaults;
      lstDateRange.ItemIndex := GraphForm.cboDateRange.ItemIndex;
      lstQualifier.ItemIndex := GraphForm.cboDateRange.ItemIndex;

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

      //lstDateRange.ItemIndex := lstDateRange.Items.Count - 1;
      //lstDateRange.ItemIndex := lstDateRange.Items.Count - 2;      //set to all results till fixed
      lstDateRangeClick(self);
      lstQualifierClick(self);
    end;
    pnlLeftBottom.Visible := true;
    splitter1.Visible := true;
  end
  else
  begin
    lblQualifier.Visible := true;
    lstQualifier.Visible := true;
    pnlViews.Visible := false;
    pnlLeftBottom.Height := lblHeaders.Height + lblQualifier.Height + 90;
  end;
end;

function TfrmReports.AllowContextChange(var WhyNot: string): Boolean;
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
                 if Length(TRemoteSite(Items[i]).RemoteHandle) > 0 then
                   begin
                     TRemoteSite(Items[i]).ReportClear;
                     TRemoteSite(Items[i]).QueryStatus := '-1^Aborted';
                     UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Query Aborted');
                   end;
               Timer1.Enabled := false;
               Result := True;
             end;
    end;
end;

procedure TfrmReports.RequestPrint;
begin
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
  if (uReportType = 'G') and GraphFormActive then
    with GraphForm do
    begin
      if (lvwItemsTop.SelCount < 1) and (lvwItemsBottom.SelCount < 1) then
        begin
          InfoBox('There are no items graphed.', 'No Items to Print', MB_OK);
          Exit;
        end
      else
        begin
          mnuPopGraphPrintClick(mnuPopGraphPrint);
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
    PrintReports(uRptID, piece(uRemoteType,'^',4));
end;

procedure TfrmReports.DisplayPage;
var
  i{, OrigSelection}: integer;
  {OrigDateIEN: Int64;
  OrigDateItemID: Variant;
  OrigReportCat, OrigProcedure: TTreeNode; }
begin
  inherited DisplayPage;
  frmFrame.mnuFilePrint.Tag := CT_REPORTS;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  uUpdateStat := false;
  ulvSelectOn := false;
  uListState := GetAdhocLookup();
  memText.SelStart := 0;
  uHTMLPatient := AnsiString('<DIV align left>'
                  + '<TABLE width="75%" border="0" cellspacing="0" cellpadding="1">'
                  + '<TR valign="bottom" align="left">'
                  + '<TD nowrap><B>Patient: ' + Patient.Name + '</B></TD>'
                  + '<TD nowrap><B>' + Patient.SSN + '</B></TD>'
                  + '<TD nowrap><B>Age: ' + IntToStr(Patient.Age) + '</B></TD>'
                  + '</TR></TABLE></DIV><HR>');
                  //the preferred method would be to use headers and footers
                  //so this is just an interim solution.
  {if not GraphFormActive then
    pnlLeftBottom.Visible := False;  } //This was keeping Date Range selection box from appearing when leaving and coming back to this Tab
  uUseRadioButton := UseRadioButtons;
  if uUseRadioButton then
    begin
      lblDateRange.Visible := false;
      lblQualifier.Visible := false;
      lstQualifier.Visible := false;
      lstDateRange.Visible := false;
    end;
  if InitPage then
    begin
      Splitter1.Visible := false;
      pnlLeftBottom.Visible := false;
      uMaxOcc := '';
      uColChange := '';
      LoadTreeView;
    end;

  if InitPatient and not (CallingContext = CC_NOTIFICATION) then
    begin
      uColChange := '';
      lstQualifier.Clear;
      tvProcedures.Items.Clear;
      lblProcTypeMsg.Visible := FALSE;
      lvReports.SmallImages := uEmptyImageList;
      imgLblImages.ComponentImageListChanged;
      lvReports.Items.Clear;
      lvReports.Columns.Clear;
      lblTitle.Caption := '';
      lvReports.Caption := '';
      Splitter1.Visible := false;
      pnlLeftBottom.Visible := false;
      memText.Parent := pnlRightBottom;
      memText.Align := alClient;
      memText.Clear;
      uReportInstruction := '';
      uLocalReportData.Clear;
      for i := 0 to RemoteSites.SiteList.Count - 1 do
        TRemoteSite(RemoteSites.SiteList.Items[i]).ReportClear;
      pnlRightTop.Height := lblTitle.Height + lblProcTypeMsg.Height + TabControl1.Height;
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
        uColChange := '';
        lstQualifier.Clear;
        tvProcedures.Items.Clear;
        lblProcTypeMsg.Visible := FALSE;
        lvReports.SmallImages := uEmptyImageList;
        imgLblImages.ComponentImageListChanged;
        lvReports.Items.Clear;
        Splitter1.Visible := false;
        pnlLeftBottom.Visible := false;
        with tvReports do
          if Items.Count > 0 then
            begin
              tvReports.Selected := tvReports.Items.GetFirstNode;
              tvReportsClick(self);
            end;   
      end;
    CC_NOTIFICATION:  ProcessNotifications;

    //This corrects the reload of the reports when switching back to the tab.
     {Remove this since it has already been corrected. Related code was also removed from fLabs.
    CC_CLICK: if not InitPatient then
      begin
        //Clear our local variables
        OrigReportCat := nil;
        OrigDateIEN := -1;
        OrigSelection := -1;
        OrigDateItemID := '';
        OrigProcedure := nil;

        //What was last selected before they switched tabs.
        if tvReports.Selected <> nil then OrigReportCat := tvReports.Selected;
        if lstDateRange.ItemIEN > 0 then OrigDateIEN := lstDateRange.ItemIEN;
        if lvReports.Selected <> nil then OrigSelection := lvReports.Selected.Index;
        if lstQualifier.ItemID <> '' then OrigDateItemID := lstQualifier.ItemID;
        if tvProcedures.Selected <> nil then OrigProcedure := tvProcedures.Selected;

        //Load the tree and select the last selected
        if OrigReportCat <> nil then begin
         tvReports.Select(OrigReportCat);
         tvReportsClick(self);
        end;

        //Did they click on a date (lstDates box)
        if OrigDateIEN > -1 then begin
          lstDateRange.SelectByIEN(OrigDateIEN);
          lstDateRangeClick(self);
        end;

        //Did they click on a date (lstQualifier)
         if OrigDateItemID <> '' then begin
          lstQualifier.SelectByID(OrigDateItemID);
          lstQualifierClick(self);
        end;

        //Did they click on a procedure
        if OrigProcedure <> nil then begin
          tvProcedures.Select(OrigProcedure);
          tvProceduresClick(tvProcedures);
        end;


        //Did they click on a report
        if OrigSelection > -1 then begin
         lvReports.Selected := lvReports.Items[OrigSelection];
         lvReportsSelectItem(self, lvReports.Selected, true);
        end;
      end;  }
  end;
end;

procedure TfrmReports.RDOChange(rdoIndex: integer);
var
  aID, aCategory, aQualifier, aHDR, x, x1, x2, MoreID: string;
  aIndex: integer;
begin
  inherited;
  if uTVReportSet then Exit;
  aID := uRptID;
  aCategory   :=  PReportTreeObject(tvReports.Selected.Data)^.Category;
  aHDR        :=  PReportTreeObject(tvReports.Selected.Data)^.HDR;
  aQualifier  :=  PReportTreeObject(tvReports.Selected.Data)^.Qualifier;
  aIndex := rdoIndex;
  uRDOChanging := true;
  uRDOStick := true;
  uRDOPick := rdoIndex;
  if chkMaxFreq.checked = true then
    begin
      MoreID := '';
      SetPiece(aQualifier,';',3,'');
    end;
  if (GraphFormActive = true) then
  begin
    GraphForm.cboDateRange.ItemIndex := aIndex;
    GraphForm.cboDateRangeChange(self);
    FastAssign(GraphForm.cboDateRange.Items, lstDateRange.Items);
    lstDateRange.ItemIndex := GraphForm.cboDateRange.ItemIndex;
    lstQualifier.ItemIndex := aIndex;
  end;
  case uQualifierType of
    QT_OTHER:
      begin      //      = 0

      end;
    QT_DATERANGE:
      begin      //      = 2
        if (GraphFormActive = false) then
          begin
            lstQualifier.ItemIndex := aIndex;
            if ulstQualifierChanging = false then lstQualifierClick(self);
            lstDateRange.ItemIndex := lstQualifier.ItemIndex;
          end;
      end;
    QT_HSCOMPONENT:
      begin      //      = 5
        lstQualifier.ItemIndex := aIndex;
        if ulstQualifierChanging = false then lstQualifierClick(self);
        lstDateRange.ItemIndex := lstQualifier.ItemIndex;
      end;
    QT_HSWPCOMPONENT:
      begin      //      = 6
        lstQualifier.ItemIndex := aIndex;
        if ulstQualifierChanging = false then lstQualifierClick(self);
        lstDateRange.ItemIndex := lstQualifier.ItemIndex;
      end;
    else
      begin      //      = ?

      end;
    end;
  MoreID := '';
  x := Piece(aQualifier, ';', 3);
  if (CharAt(lstQualifier.ItemID,1) = 'd')
    and (length(x)>0)
    and (StrToInt(x)<101) then
      MoreID := ';101';
  if lstQualifier.ItemIndex > -1 then
    begin
    if not (aHDR = '1') then
      if (aCategory <> '0') and (not WebBrowser.Visible) then
          begin
            if (lstQualifier.ItemID = '') and (GraphForm <> nil) then
              DisplayHeading(piece(lstQualifier.Items[lstQualifier.ItemIndex],'^',5) + MoreID)
            else
              DisplayHeading(lstQualifier.ItemID + MoreID) ;
          end
      else
        DisplayHeading('');
    end
  else
    begin
      if not (aHDR = '1') and (lstDateRange.ItemIndex > -1) then
        if (aCategory <> '0') and (not WebBrowser.Visible) then
          begin
            x := lstDateRange.DisplayText[lstDateRange.ItemIndex];
            x1 := piece(x,' ',1);
            x2 := piece(x,' ',3);
            if (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
              DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2) + MoreID)
            else
              DisplayHeading('d' + lstDateRange.ItemID + ';' + MoreID);
          end
        else
          DisplayHeading('');
    end;
  uRDOChanging := false;
end;

procedure TfrmReports.rdoDateRangeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  rdoChange(rdoDateRange.Tag);
end;

procedure TfrmReports.rdoTodayClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdoToday.Tag);
end;

procedure TfrmReports.UpdateRemoteStatus(aSiteID, aStatus: string);
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

procedure TfrmReports.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  WebDoc: IHtmlDocument2;
  v: variant;
begin
  inherited;
  if uHTMLDoc = '' then Exit;
  if not(uReportType = 'H') then Exit; //this can be removed if & when browser replaces memtext control
  if not Assigned(WebBrowser.Document) then Exit;
  WebDoc := WebBrowser.Document as IHtmlDocument2;
  v := VarArrayCreate([0, 0], varVariant);
  v[0] := uHTMLDoc;
  WebDoc.write(PSafeArray(TVarData(v).VArray));
  WebDoc.close;
  //uHTMLDoc := '';
end;

procedure TfrmReports.LoadTreeView;
var
  i,j: integer;
  currentNode, parentNode, grandParentNode, gtGrandParentNode: TTreeNode;
  x: string;
  addchild, addgrandchild, addgtgrandchild: boolean;
begin
  tvReports.Items.Clear;
  memText.Clear;
  uHTMLDoc := '';
  BlankWeb;
  tvProcedures.Items.Clear;
  lblProcTypeMsg.Visible := FALSE;
  lvReports.SmallImages := uEmptyImageList;
  imgLblImages.ComponentImageListChanged;
  lvReports.Items.Clear;
  uTreeStrings.Clear;
  lblTitle.Caption := '';
  lvReports.Caption := '';
  ListReports(uTreeStrings);
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
  for i := 0 to tvReports.Items.Count - 1 do
    if Piece(PReportTreeObject(tvReports.Items[i].Data)^.Qualifier,';',4) = '1' then
      begin
        HealthSummaryCheck(uHSAll,'1');
        for j := 0 to uHSAll.Count - 1 do
          tvReports.Items.AddChildObject(tvReports.Items[i],Piece(uHSAll[j],'^',2),MakeReportTreeObject(uHSAll[j]));
      end;
end;

procedure TfrmReports.SetFontSize(NewFontSize: Integer);
var
  pnlRightMiddlePct: Real;
  frmReportsHeight, pnlRightHeight: Integer;

begin
  pnlRightMiddlePct := (pnlRightMiddle.Height / (pnlRight.Height - (sptHorzRight.Height + pnlRightTop.Height)));
  pnlRightMiddle.Constraints.MaxHeight := 20;
  inherited SetFontSize(NewFontSize);
  memText.Font.Size := NewFontSize;
  frmReportsHeight := frmFrame.pnlPatientSelectedHeight - (frmFrame.pnlToolbar.Height + frmFrame.stsArea.Height + frmFrame.tabPage.Height + 2);
  pnlRightHeight := frmReportsHeight - shpPageBottom.Height;
  pnlRightMiddle.Constraints.MaxHeight := 0;
  pnlRightMiddle.Height := (Round((pnlRightHeight - (sptHorzRight.Height + pnlRightTop.Height)) * pnlRightMiddlePct) - 14);
  if frmFrame.Height <> frmFrame.frmFrameHeight then
  begin
    pnlRight.Height := pnlRightHeight;
    frmReports.Height := frmReportsHeight;
    frmFrame.Height := frmFrame.frmFrameHeight;
  end;
end;

procedure TfrmReports.LoadListView(aReportData: TStringList);
var
  i,j,k,aErr: integer;
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
        if (length(piece(uHState,';',2)) > 0) then //and (chkText.Checked = false) then
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
                    memText.Lines.Clear;
                    memText.Lines.Add(uReportInstruction);
                  end
                else
                  memText.Lines.Clear;
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
                            RowObjects.Add(aSite, IntToStr(aCurRow) + ':' + IntToStr(aCurCol), uColumns.Strings[aCurCol], aTmpAray);
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
                        RowObjects.Add(aSite, IntToStr(aCurRow) + ':' + IntToStr(aCurCol), uColumns.Strings[aCurCol], aTmpAray);
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
                    RowObjects.Add(aSite, IntToStr(aCurRow) + ':' + IntToStr(aCurCol), uColumns.Strings[aCurCol], aTmpAray);
                    aTmpAray.Clear;
                  end;
              end;
            aTmpAray.Free;
          end;
        if uRptID = 'OR_R18:IMAGING' then with lvReports do  //set image indicator for "Imaging" report
          begin
            SmallImages := dmodShared.imgImages;
            imgLblImages.ComponentImageListChanged;
            for i := 0 to Items.Count - 1 do
              if (Items[i].SubItems.Count > 7) and (Items[i].SubItems[7] = 'Y') then
                Items[i].SubItemImages[1] := IMG_1_IMAGE
              else
                Items[i].SubItemImages[1] := IMG_NO_IMAGES;
          end
        else //lvReports.SmallImages := uEmptyImageList;
        if uRptID = 'OR_PN:PROGRESS NOTES' then with lvReports do  //set image indicator for "Progress Notes" report
          begin
            SmallImages := dmodShared.imgImages;
            imgLblImages.ComponentImageListChanged;
            for i := 0 to Items.Count - 1 do
              if (Items[i].SubItems.Count > 7) and (StrToInt(Items[i].SubItems[7]) > 0) then
                Items[i].SubItemImages[2] := IMG_1_IMAGE
              else
                Items[i].SubItemImages[2] := IMG_NO_IMAGES;
          end
        else begin
          lvReports.SmallImages := uEmptyImageList;
          imgLblImages.ComponentImageListChanged;
        end;
      end;
  end;
  if aErr = 1 then
    if User.HasKey('XUPROGMODE') then
      ShowMsg('Programmer message: One or more Column ID''s in file 101.24 do not match ID''s coded in extract routine');
end;

procedure TfrmReports.lstQualifierClick(Sender: TObject);
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
  uHSComponents.Clear;
  uHSAll.Clear;
  tvProcedures.Items.Clear;
  lblProcTypeMsg.Visible := FALSE;
  uHTMLDoc := '';
  if uReportType = 'H' then
    begin
      WebBrowser.Visible := true;
      WebBrowser.TabStop := true;
      BlankWeb;
      WebBrowser.BringToFront;
      memText.Visible := false;
      memText.TabStop := false;
    end
  else
    begin
      WebBrowser.Visible := false;
      WebBrowser.TabStop := false;
      memText.Visible := true;
      memText.TabStop := true;
      memText.BringToFront;
      RedrawActivate(memText.Handle);
    end;
  uLocalReportData.Clear;
  uRemoteReportData.Clear;
  for i := 0 to RemoteSites.SiteList.Count - 1 do
   TRemoteSite(RemoteSites.SiteList.Items[i]).ReportClear;
  uRemoteCount := 0;
  if lstQualifier.ItemID = 'ds' then
    begin
      with calApptRng do
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
  memText.Lines.Add(uReportInstruction);
  if WebBrowser.Visible then begin
    uHTMLDoc := HTML_PRE + uReportInstruction + HTML_POST;
    BlankWeb;
  end;
  case uQualifierType of
      QT_HSCOMPONENT:
        begin     //      = 5
          lvReports.SmallImages := uEmptyImageList;
          imgLblImages.ComponentImageListChanged;
          lvReports.Items.Clear;
          memText.Lines.Clear;
          RowObjects.Clear;
          if ((aRemote = '1') or (aRemote = '2')) then
            GoRemote(uRemoteReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState, aHDR, aFHIE)
          else
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
          if not(piece(uRemoteType, '^', 9) = '1') then
            if (length(piece(uHState,';',2)) > 0) then
              begin
                if not(aRemote = '2') then
                  LoadReportText(uLocalReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                LoadListView(uLocalReportData);
              end
            else
              begin
                if ((aRemote = '1') or (aRemote = '2')) then
                  ShowTabControl;
                pnlRightMiddle.Visible := false;
                LoadReportText(uLocalReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                if uLocalReportData.Count < 1 then
                  begin
                    uReportInstruction := '<No Report Available>';
                    memText.Lines.Add(uReportInstruction);
                  end
                else
                  begin
                    QuickCopy(uLocalReportData,memText);
                    TabControl1.OnChange(nil);
                  end;
              end;
        end;
      QT_HSWPCOMPONENT:
        begin      //      = 6
          lvReports.SmallImages := uEmptyImageList;
          imgLblImages.ComponentImageListChanged;
          lvReports.Items.Clear;
          RowObjects.Clear;
          memText.Lines.Clear;
          if ((aRemote = '1') or (aRemote = '2'))  then
            begin
              Screen.Cursor := crDefault;
              GoRemote(uRemoteReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState, aHDR, aFHIE);
            end
          else
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
          if not(piece(uRemoteType, '^', 9) = '1') then
            if (length(piece(uHState,';',2)) > 0) then
              begin
                if not(aRemote = '2') then
                  LoadReportText(uLocalReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                LoadListView(uLocalReportData);
              end
            else
              begin
                if not (aRemote = '2') then
                  begin
                    LoadReportText(uLocalReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
                    if uLocalReportData.Count < 1 then
                      begin
                        uReportInstruction := '<No Report Available>';
                        memText.Lines.Add(uReportInstruction);
                      end
                    else
                      QuickCopy(uLocalReportData,memText);
                  end;
              end;
        end
      else
        begin
          if ((aRemote = '1') or (aRemote = '2')) then
            GoRemote(uRemoteReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState, aHDR, aFHIE)
          else
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;  
          if Pos('ECS',Piece(uRptID,':',1))>0 then
          begin
            if Pos('OR_ECS1',uRptID)>0 then
              uECSReport.ReportHandle := 'ECPCER';
            if Pos('OR_ECS2',uRptID)>0 then
              uECSReport.ReportHandle := 'ECPAT';
            uECSReport.ReportType   := 'D';
            if uECSReport.ReportHandle = 'ECPAT' then
            begin
              if InfoBox('Would you like the procedure reason be included in the report?', 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
                uECSReport.NeedReason := 'Y'
              else
                uECSReport.NeedReason := 'N';
            end;
            FormatECSDate(lstQualifier.ItemID, uECSReport);
            LoadECSReportText(uLocalReportData, uECSReport);
          end else
            if not(piece(uRemoteType, '^', 9) = '1') then
              LoadReportText(uLocalReportData, uRptID, lstQualifier.ItemID + MoreID, uReportRPC, uHState);
          if not(piece(uRemoteType, '^', 9) = '1') then
            if TabControl1.TabIndex < 1 then
              QuickCopy(uLocalReportData,memText);
          Screen.Cursor := crDefault;
        end;
    end;
    Screen.Cursor := crDefault;
    StatusText('');
    memText.Lines.Insert(0,' ');
    memText.Lines.Delete(0);
    if WebBrowser.Visible then begin
      if uReportType = 'R' then
        uHTMLDoc := HTML_PRE + uLocalReportData.Text + HTML_POST
      else
        uHTMLDoc := String(uHTMLPatient) + uLocalReportData.Text;
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

procedure TfrmReports.GotoTop1Click(Sender: TObject);
begin
  inherited;
  SendMessage(memText.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TfrmReports.GotoBottom1Click(Sender: TObject);
begin
  Inherited;
  SendMessage(memText.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TfrmReports.FreezeText1Click(Sender: TObject);
var
  Current, Desired : Longint;
  LineCount : Integer;
begin
  Inherited;
  If memText.SelLength > 0 then begin
    Memo1.visible := true;
    Memo1.TabStop := true;
    Memo1.Text := memText.SelText;
    If Memo1.Lines.Count <6 then
      LineCount := Memo1.Lines.Count + 1
    Else
      LineCount := 5;
    Memo1.Height := LineCount * frmReports.Canvas.TextHeight(memText.SelText);
    Current := SendMessage(memText.handle, EM_GETFIRSTVISIBLELINE, 0, 0);
    Desired := SendMessage(memText.handle, EM_LINEFROMCHAR,
               memText.SelStart + memText.SelLength ,0);
    SendMessage(memText.Handle,EM_LINESCROLL, 0, Desired - Current);
    uFrozen := True;
  end;
end;

procedure TfrmReports.UnFreezeText1Click(Sender: TObject);
begin
  Inherited;
  If uFrozen = True Then begin
    uFrozen := False;
    UnFreezeText1.Enabled := False;
    Memo1.Visible := False;
    Memo1.TabStop := False;
    Memo1.Text := '';
  end;
end;

procedure TfrmReports.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  If Screen.ActiveControl.Name <> memText.Name then
   begin
     memText.SetFocus;
     memText.SelStart := 0;
   end;
  If memText.SelLength > 0 Then
    FreezeText1.Enabled := True
  Else
    FreezeText1.Enabled := False;
  If Memo1.Visible Then
    UnFreezeText1.Enabled := True;
end;

procedure TfrmReports.FormCreate(Sender: TObject);
begin
  inherited;
  PageID := CT_REPORTS;
  uFrozen := False;
  uHSComponents := TStringList.Create;
  uHSAll := TStringList.Create;
  uLocalReportData := TStringList.Create;
  uRemoteReportData := TStringList.Create;
  uColumns := TStringList.Create;
  uTreeStrings := TStringList.Create;
  if uEmptyImageList = nil then
    uEmptyImageList := TImageList.Create(Self);
//  uEmptyImageList.Width := 0;
  RowObjects := TRowObject.Create;
  uRemoteCount := 0;
  GraphFormActive := false;
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
end;

procedure TfrmReports.ProcessNotifications;
var
  j, AnIndex, IDColumn: integer;
  SelectID: string;
  ListItem: TListItem;
  tmpRptID: string;

  function FindReport(QualType: integer; var AnIndex: integer): boolean; overload;
  var
    Found: boolean;
    i: integer;
  begin
    Found := False;
    with tvReports do
      begin
        for i := 0 to Items.Count -1 do
          if StrToIntDef(Piece(PReportTreeObject(tvReports.Items[i].Data)^.Qualifier,';',4),0) = QualType then
            begin
              Found := True;
              break;
            end;
      end;
    Result := Found ;
    AnIndex := i;
  end;

  function FindReport(ReportID: string; var AnIndex: integer): boolean; overload;
  var
    Found: boolean;
    i: integer;
  begin
    Found := False;
    with tvReports do
      begin
        for i := 0 to Items.Count -1 do
          if Piece(PReportTreeObject(tvReports.Items[i].Data)^.ID, ':', 1) = ReportID then
            begin
              Found := True;
              break;
            end;
      end;
    Result := Found ;
    AnIndex := i;
  end;

begin
  IDColumn := 0;
  if uUseRadioButton then
      begin
        pnlRightTopHeaderMid.Visible := true;
        lblDateRange.Visible := false;
        lblQualifier.Visible := false;
        lstQualifier.Visible := false;
        lstDateRange.Visible := false;
      end
    else
      begin
        pnlRightTopHeaderMid.Visible := false;
      end;
  case Notifications.Followup of
    NF_IMAGING_RESULTS, NF_ABNORMAL_IMAGING_RESULTS, NF_IMAGING_RESULTS_AMENDED:
      begin
        if not FindReport(QT_IMAGING, AnIndex) then exit;
        tvReports.Selected := tvReports.Items[AnIndex];
        SelectID := 'i' + Piece(Notifications.AlertData, '~', 1) +
          '-' + Piece(Notifications.AlertData, '~', 2);
        IDColumn := 0;
        if tvReports.Selected <> tvReports.Items[AnIndex] then
          tvReports.Selected := tvReports.Items[AnIndex];
      end;
    NF_IMAGING_REQUEST_CHANGED:
      begin
        if not FindReport(QT_IMAGING, AnIndex) then exit;
        tvReports.Selected := tvReports.Items[AnIndex];
        SelectID := 'i' + Piece(Notifications.AlertData, '/', 2) +
          '-' + Piece(Notifications.AlertData, '/', 3);
        IDColumn := 0;
        if tvReports.Selected <> tvReports.Items[AnIndex] then
          tvReports.Selected := tvReports.Items[AnIndex];
      end;
    NF_STAT_RESULTS                  :
      begin
        if not FindReport(QT_IMAGING, AnIndex) then exit;
        tvReports.Selected := tvReports.Items[AnIndex];
        SelectID := 'i' + Piece(Notifications.AlertData, '~', 2) +
          '-' + Piece(Piece(Notifications.AlertData, '~', 3), '@', 1);
        IDColumn := 0;
        if tvReports.Selected <> tvReports.Items[AnIndex] then
          tvReports.Selected := tvReports.Items[AnIndex];
      end;
    NF_MAMMOGRAM_RESULTS            :
      begin
        if not FindReport('OR_R18', AnIndex) then exit;
        tvReports.Selected := tvReports.Items[AnIndex];
        SelectID := 'i' + Piece(Notifications.AlertData, '~', 1) +
          '-' + Piece(Notifications.AlertData, '~', 2);
        IDColumn := 8;
        if tvReports.Selected <> tvReports.Items[AnIndex] then
          tvReports.Selected := tvReports.Items[AnIndex];
      end;
    NF_ANATOMIC_PATHOLOGY_RESULTS    :
      //OR_SP^Surgical Pathology
      //OR_CY^Cytology
      //OR_EM^Electron Microscopy
      //OR_AU^Autopsy
      begin
        if Notifications.AlertData = '^1^^^0^0^0' then  //code snippet to handle the processing of v26 AP alerts in a v27 environment.
          begin
            if pnlRightMiddle.Visible then
              begin
                sptHorzRightTop.Visible := false;
                pnlRightMiddle.Visible := FALSE;
              end;
            InfoBox('This alert was generated in a v26 environment as an informational alert and'
            + CRLF + 'therefore cannot be processed as an action alert in a v27 environment.',
            'Unable to Process as Action Alert', MB_OK or MB_ICONWARNING);
            memText.Text := 'Unable to Process as an Action Alert. In order to view the associated Anatomic Pathology report, please manually'
            + CRLF + 'locate the appropriate report under the Anatomic Pathology section (also found under Laboratory, Clinical Reports).';
            Notifications.Delete;
            exit;
          end;
        tmpRptID := Piece(Notifications.AlertData, U, 1);
        if not FindReport('OR_' + tmpRptID, AnIndex) then exit;
        tvReports.Selected := tvReports.Items[AnIndex];
        SelectID := Piece(Notifications.AlertData, U, 2);
        if (tmpRptID = 'CY') or (tmpRptID = 'EM') or (tmpRptID = 'SP') then
             IDColumn := 3;
        if tvReports.Selected <> tvReports.Items[AnIndex] then
          tvReports.Selected := tvReports.Items[AnIndex];
      end;
    NF_PAP_SMEAR_RESULTS            :
      begin
        if not FindReport('OR_CY', AnIndex) then exit;
        tvReports.Selected := tvReports.Items[AnIndex];
        SelectID := Piece(Notifications.AlertData, U, 2);
        IDColumn := 3;
        if tvReports.Selected <> tvReports.Items[AnIndex] then
          tvReports.Selected := tvReports.Items[AnIndex];
      end;
    else with tvReports do if Items.Count > 0 then Selected := Items[0];
  end;
  if tvReports.Selected <> nil then
    begin
      tvReportsClick(Self);
      Application.ProcessMessages;
      for j := 0 to lvReports.Items.Count - 1 do
       begin
         ListItem := lvReports.Items[j];
         if ListItem.Subitems[IDColumn] = SelectID then
           begin
             lvReports.Selected := lvReports.Items[j];
             break;
           end;
       end;
      Notifications.Delete;
    end;
end;

procedure TfrmReports.rdo1MonthClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo1Month.Tag);
end;

procedure TfrmReports.rdo1WeekClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo1Week.Tag);
end;

procedure TfrmReports.rdo1YearClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo1Year.Tag);
end;

procedure TfrmReports.rdo2YearClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo2Year.Tag);
end;

procedure TfrmReports.rdo6MonthClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdo6Month.Tag);
end;

procedure TfrmReports.rdoAllResultsClick(Sender: TObject);
begin
  inherited;
  rdoChange(rdoAllResults.Tag);
end;

procedure TfrmReports.DisplayHeading(aRanges: string);
var
  x,x1,x2,y,z,DaysBack: string;
  d1,d2: TFMDateTime;
begin
  with lblTitle do
  begin
    x := '';
    if tvReports.Selected = nil then
     tvReports.Selected := tvReports.Items.GetFirstNode;
    if tvReports.Selected.Parent <> nil then
      x := tvReports.Selected.Parent.Text + ' ' + tvReports.Selected.Text
    else
      x :=  tvReports.Selected.Text;
      x1 := '';
      x2 := '';
    if uReportType <> 'M' then
      begin
        if CharAt(aRanges, 1) = 'd' then
          begin
            if length(piece(aRanges,';',2)) > 0 then
              begin
                x2 := '  Max/site:' + piece(aRanges,';',2);
                aRanges := piece(aRanges,';',1);
              end;
            DaysBack := Copy(aRanges, 2, Length(aRanges));
            if DaysBack = '0' then
              aRanges := 'T' + ';T'
            else
              aRanges := 'T-' + DaysBack + ';T';
          end;
        if length(piece(aRanges,';',1)) > 0 then
          begin
            d1 := ValidDateTimeStr(piece(aRanges,';',1),'');
            d2 := ValidDateTimeStr(piece(aRanges,';',2),'');
            if (d1 = -1) or (d2 = -1) then x1 := ''
            else
              begin
                y := FormatFMDateTime('dddddd',d1);
                if strToInt(Copy(y,8,4)) < 1925 then y := 'EARLIEST RESULT';
                z := FormatFMDateTime('dddddd',d2);
                x1 := ' [From: ' + y + ' to ' + z + ']';
              end;
          end;
        if (length(piece(aRanges,';',3)) > 0) and (length(x1) > 0) then
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
          QT_PROCEDURES:
              x := x + ' [ALL]';
          QT_SURGERY:
              x := x + ' [ALL]';
          else
            if rdoDateRange.Checked = true then
              x := x + x1 + x2;
        end;
      end;
    if piece(uRemoteType, '^', 9) = '1' then x := x + ' <<ONLY REMOTE DATA INCLUDED IN REPORT>>';
    Caption := x;
  end;
  lvReports.Caption := x;
end;

procedure TfrmReports.Timer1Timer(Sender: TObject);
var
  i,j,fail,t: integer;
  r0,aSite: String;
  aHDR, aID, aRet: String;
begin
  inherited;
  with RemoteSites.SiteList do
   begin
    for i := 0 to Count - 1 do
      if TRemoteSite(Items[i]).Selected then
       begin
        if Length(TRemoteSite(Items[i]).RemoteHandle) > 0 then
          begin
            r0 := GetRemoteStatus(TRemoteSite(Items[i]).RemoteHandle);
            aSite := TRemoteSite(Items[i]).SiteName;
            TRemoteSite(Items[i]).QueryStatus := r0; //r0='1^Done' if no errors
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, piece(r0,'^',2));
            if piece(r0,'^',1) = '1' then
              begin
                aHDR := piece(TRemoteSite(Items[i]).CurrentReportQuery, '^', 13);
                aID := piece(piece(TRemoteSite(Items[i]).CurrentReportQuery, '^', 2),':',1);
                if aHDR = '1' then
                  begin
                    ModifyHDRData(aRet, TRemoteSite(Items[i]).RemoteHandle ,aID);
                  end;
                GetRemoteData(TRemoteSite(Items[i]).Data, TRemoteSite(Items[i]).RemoteHandle,Items[i]);
                RemoteReports.Add(TRemoteSite(Items[i]).CurrentReportQuery,
                  TRemoteSite(Items[i]).RemoteHandle);
                TRemoteSite(Items[i]).RemoteHandle := '';
                TabControl1.OnChange(nil);
                if (length(piece(uHState,';',2)) > 0) then
                  begin
                    uRemoteReportData.Clear;
                    QuickCopy(TRemoteSite(Items[i]).Data,uRemoteReportData);
                    fail := 0;
                    if uRemoteReportData.Count > 0 then
                      begin
                        if uRemoteReportData[0] = 'Report not available at this time.' then
                          begin
                            fail := 1;
                            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Report not available');
                          end;
                        if piece(uRemoteReportData[0],'^',1) = '-1' then
                          begin
                            fail := 1;
                            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Communication failure');
                          end;
                        if fail = 0 then
                          LoadListView(uRemoteReportData);
                      end;
                  end;
              end
            else
              begin
                uRemoteCount := uRemoteCount + 1;
                if uRemoteCount > 90 then
                  begin
                    TRemoteSite(Items[i]).RemoteHandle := '';
                    TRemoteSite(Items[i]).QueryStatus := '-1^Timed out';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID,'Timed out');
                    StatusText('');
                    TabControl1.OnChange(nil);
                  end
                else
                  StatusText('Retrieving reports from '
                + TRemoteSite(Items[i]).SiteName + '...');
              end;
            t := Timer1.Interval;
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
             if Length(TRemoteSite(Items[i]).RemoteHandle) > 0 then
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

procedure TfrmReports.TabControl1Change(Sender: TObject);
var
  aStatus,aSite: string;
  hook: Boolean;
  i: integer;
begin
  inherited;
  if (uQualifiertype <> 6) or (length(piece(uHState,';',2)) < 1) then
    memText.Lines.Clear;
  lstHeaders.Items.Clear;
  uHTMLDoc := '';
  if WebBrowser.Visible then BlankWeb;
  if (length(piece(uHState,';',2)) = 0) then with TabControl1 do
    begin
      memText.Lines.BeginUpdate;
      if TabIndex > 0 then
        begin
          aStatus := TRemoteSite(Tabs.Objects[TabIndex]).QueryStatus;
          aSite := TRemoteSite(Tabs.Objects[TabIndex]).SiteName;
          if aStatus = '1^Done' then
            begin
              if Piece(TRemoteSite(Tabs.Objects[TabIndex]).Data[0],'^',1) = '[HIDDEN TEXT]' then
                begin
                  lstHeaders.Clear;
                  hook := false;
                  for i := 1 to TRemoteSite(Tabs.Objects[TabIndex]).Data.Count - 1 do
                    if hook = true then
                        memText.Lines.Add(TRemoteSite(Tabs.Objects[TabIndex]).Data[i])
                    else
                      begin
                        lstHeaders.Items.Add(MixedCase(TRemoteSite(Tabs.Objects[TabIndex]).Data[i]));
                        if Piece(TRemoteSite(Tabs.Objects[TabIndex]).Data[i],'^',1) = '[REPORT TEXT]' then
                          hook := true;
                      end;
                end
              else
                QuickCopy(TRemoteSite(Tabs.Objects[TabIndex]).Data,memText);
              memText.Lines.Insert(0,' ');
              memText.Lines.Delete(0);
            end;
          if Piece(aStatus,'^',1) = '-1' then
            begin
              memText.Lines.Add('Remote data transmission error: ' + Piece(aStatus,'^',2));
            end;
          if Piece(aStatus,'^',1) = '0' then
            memText.Lines.Add('Retrieving data... ' + Piece(aStatus,'^',2));
          if Piece(aStatus,'^',1) = '' then
            memText.Lines.Add(uReportInstruction);
        end
      else
        if uLocalReportData.Count > 0 then
          begin
            if Piece(uLocalReportData[0],'^',1) = '[HIDDEN TEXT]' then
            begin
              lstHeaders.Clear;
              hook := false;
              for i := 1 to uLocalReportData.Count - 1 do
                if hook = true then
                  memText.Lines.Add(uLocalReportData[i])
                else
                  begin
                    lstHeaders.Items.Add(MixedCase(uLocalReportData[i]));
                    if Piece(uLocalReportData[i],'^',1) = '[REPORT TEXT]' then
                      hook := true;
                  end;
            end
              else
                if tvReports.Selected.Text = 'Imaging (local only)' then
                   memText.Lines.clear
                else
                   QuickCopy(uLocalReportData,memText);
            memText.Lines.Insert(0,' ');
            memText.Lines.Delete(0);
          end
        else
          memText.Lines.Add(uReportInstruction);
      if WebBrowser.Visible then begin
        if uReportType = 'R' then
          uHTMLDoc := HTML_PRE + memText.Lines.Text + HTML_POST
        else
          uHTMLDoc := String(uHTMLPatient) + memText.Lines.Text;
        BlankWeb;
      end;
      memText.Lines.EndUpdate;
    end;
end;

procedure TfrmReports.GoRemote(Dest: TStringList; AItem: string; AQualifier, ARpc: string; AHSTag: string; AHDR: string; aFHIE: string);
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
          InfoBox('The HDR is currently inactive in CPRS.' + CRLF + 'You must use ' + aVistaWebLabel + ' to view this report.', 'Use ' + aVistaWebLabel + ' for HDR data', MB_OK);
          Exit;
        end;
      //InfoBox('You must use ' + aVistaWebLabel + ' to view this report.', 'Use ' + aVistaWebLabel + ' for HDR data', MB_OK);
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
        //TRemoteSite(Items[i]).Selected := true;
        //frmFrame.lstCIRNLocations.Checked[i+1] := true;
      end;
    if TRemoteSite(Items[i]).Selected then
      begin
        TRemoteSite(Items[i]).ReportClear;
        if (LeftStr(TRemoteSite(Items[i]).SiteID, 5) = '200HD') and not(AHDR = '1') then
          begin
            TRemoteSite(Items[i]).QueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TRemoteSite(Items[i]).RemoteHandle := '';
            TRemoteSite(Items[i]).QueryStatus := '1^Done';
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
            TRemoteSite(Items[i]).QueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TRemoteSite(Items[i]).RemoteHandle := '';
            TRemoteSite(Items[i]).QueryStatus := '1^Done';
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
            TRemoteSite(Items[i]).QueryStatus := '1^Not Included';
            UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'NOT INCLUDED');
            TRemoteSite(Items[i]).RemoteHandle := '';
            TRemoteSite(Items[i]).QueryStatus := '1^Done';
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
              TRemoteSite(Items[i]).RemoteHandle := '';
              TRemoteSite(Items[i]).QueryStatus := '1^Done';
              UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Done');
              TabControl1.OnChange(nil);
              if (length(piece(uHState,';',2)) > 0) then //and (chkText.Checked = false) then
                LoadListView(TRemoteSite(Items[i]).Data);
            end
        else
          begin
            if uDirect = '1' then
              begin
                StatusText('Retrieving reports from ' + TRemoteSite(Items[i]).SiteName + '...');
                TRemoteSite(Items[i]).QueryStatus := '1^Direct Call';
                UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'Direct Call');
                DirectQuery(Dest, AItem, HSType, Daysback, ExamID, Alpha, Omega, TRemoteSite(Items[i]).SiteID, ARpc, AHSTag);
                if Copy(Dest[0],1,2) = '-1' then
                  begin
                    TRemoteSite(Items[i]).QueryStatus := '-1^Communication error';
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
                    TRemoteSite(Items[i]).RemoteHandle := '';
                    TRemoteSite(Items[i]).QueryStatus := '1^Done';
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
                    TRemoteSite(Items[i]).QueryStatus := '-1^Communication error';
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
                    TRemoteSite(Items[i]).RemoteHandle := Dest[0];
                    TRemoteSite(Items[i]).QueryStatus := '0^initialization...';
                    UpdateRemoteStatus(TRemoteSite(Items[i]).SiteID, 'initialization');
                    Timer1.Enabled := True;
                    StatusText('Retrieving reports from ' + TRemoteSite(Items[i]).SiteName + '...');
                  end;
              end;
          end;
      end;
    end;
end;

procedure TfrmReports.FormDestroy(Sender: TObject);
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
  RowObjects.Free;
  uHSComponents.Free;
  uHSAll.Free;
  uLocalReportData.Free;
  uRemoteReportData.Free;
  uColumns.Free;
  uTreeStrings.Free;
  uEmptyImageList.Free;
  uECSReport.Free;
  if GraphForm <> nil then GraphForm.Release;
end;

procedure TfrmReports.lstHeadersClick(Sender: TObject);
var
  Current, Desired: integer;
begin
  inherited;
  if uFrozen = True then
    begin
      memo1.visible := False;
      memo1.TabStop := False;
    end;
  Current := SendMessage(memText.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  Desired := lstHeaders.ItemIEN;
  SendMessage(memText.Handle, EM_LINESCROLL, 0, Desired - Current - 1);
end;

procedure TfrmReports.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  inherited;
  if NewSize < 50 then
    Newsize := 50;
end;

procedure TfrmReports.sptHorzRightCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  inherited;
    if NewSize < 50 then
    Newsize := 50;
end;

procedure TfrmReports.lstQualifierDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  AnImage: TBitMap;
const
  STD_DATE = 'MMM DD,YY@HH:NN';
begin
  inherited;
  AnImage := TBitMap.Create;
  try
    with (Control as TORListBox).Canvas do  { draw on control canvas, not on the form }
      begin
        x := (Control as TORListBox).Items[Index];
        FillRect(Rect);       { clear the rectangle }
        if uQualifierType = QT_IMAGING then   // moved position of assignment in all case branches
          begin
            AnImage.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_1');
            if Piece(x, U, 4) = 'Y' then
              begin
                BrushCopy(Bounds(Rect.Left, Rect.Top, AnImage.Width, AnImage.Height),
                  AnImage, Bounds(0, 0, AnImage.Width, AnImage.Height), clRed); {render ImageFlag}
              end;
            TextOut(Rect.Left + AnImage.Width, Rect.Top, Piece(x, U, 2));
            TextOut(Rect.Left + AnImage.Width + TextWidth(STD_DATE), Rect.Top, Piece(x, U, 3));
          end
        else
          begin
            TextOut(Rect.Left, Rect.Top, Piece(x, U, 2));
            TextOut(Rect.Left + TextWidth(STD_DATE), Rect.Top, Piece(x, U, 3));
          end;
      end;
  finally
    AnImage.Free;
  end;
end;

procedure TfrmReports.tvReportsClick(Sender: TObject);
var
  i,j: integer;
  ListItem: TListItem;
  aHeading, aReportType, aRPC, aQualifier, aStartTime, aStopTime, aMax, aRptCode, aRemote, aCategory, aSortOrder, aDaysBack, x, x1, x2: string;
  aIFN: integer;
  aID, aHSTag, aRadParam, aColChange, aDirect, aHDR, aFHIE, aFHIEONLY, aQualifierID, aQualAdd: string;
  CurrentParentNode, CurrentNode: TTreeNode;
  aQualMatch: boolean;
begin
  inherited;
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
  uTVReportSet:= true;
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
  if aReportType = '' then aReportType := 'R';
  uDateOverride := false;
  uReportRPC := aRPC;
  uRptID := aID;
  uReportID := aID;
  uDirect := aDirect;
  uReportType := aReportType;
  uQualifier := aQualifier;
  uSortOrder := aSortOrder;
  uRemoteType := aRemote + '^' + aReportType + '^' + IntToStr(aIFN) + '^' + aHeading + '^' + aRptCode + '^' + aDaysBack + '^' + aHDR + '^' + aFHIE + '^' + aFHIEONLY;
  pnlRightTop.Height := lblTitle.Height;  // see below
  RedrawSuspend(tvReports.Handle);
  RedrawSuspend(memText.Handle);
  uHState := aHSTag;
  Timer1.Enabled := False;
  HideTabControl;
  lblProcTypeMsg.Visible := FALSE;
  pnlProcedures.Visible := FALSE;
  if (aRemote = '1') or (aRemote = '2') then
    if not(uReportType = 'V') and not(uReportType = 'M') then
      ShowTabControl;
  StatusText('');
  uHTMLDoc := '';
  BlankWeb;
  memText.Lines.Clear;
  memText.Parent := pnlRightBottom;
  memText.Align := alClient;
  UpdatingLvReports := TRUE;    {lw added}
  tvProcedures.Items.Clear;
  UpdatingLvReports := FALSE;   {lw added}
  lblProcTypeMsg.Visible := FALSE;
  lvReports.SmallImages := uEmptyImageList;
  imgLblImages.ComponentImageListChanged;
  lvReports.Items.Clear;
  lvReports.Columns.Clear;
  uHSComponents.Clear;
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
      pnlRightMiddle.Visible := false;
      pnlRightBottom.Visible := true;
      WebBrowser.Visible := true;
      WebBrowser.TabStop := true;
      BlankWeb;
      WebBrowser.BringToFront;
      memText.Visible := false;
      memText.TabStop := false;
    end
  else
    if uReportType = 'V' then
      begin
        with lvReports do
          begin
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
          end;
        pnlRightTop.Visible := true;
        sptHorzRightTop.Visible := true;
        pnlRightMiddle.Visible := true;
        sptHorzRight.Visible := true;
        sptHorzRightTop.Top := 2;
        sptHorzRight.Top := pnlRightMiddle.Height + 2;
        WebBrowser.Visible := false;
        WebBrowser.TabStop := false;
        pnlRightBottom.Visible := true;
        memText.Visible := true;
        memText.TabStop := true;
        memText.BringToFront;
      end
    else
      begin
        pnlRightMiddle.Visible := false;
        sptHorzRight.Visible := false;
        WebBrowser.Visible := false;
        WebBrowser.TabStop := false;
        RightTopHeader(34);
        pnlRightTop.Visible := true;
        sptHorzRightTop.Visible := true;
      end;
  uLocalReportData.Clear;
  RowObjects.Clear;
  uRemoteReportData.Clear;
  lstHeaders.Visible := false;
  lstHeaders.TabStop := false;
  lblHeaders.Visible := false;
  lstHeaders.Clear;
  uTVReportSet := false;
  if lstQualifier.Items.Count < 1 then ListReportDateRanges(lstQualifier.Items);
  for i := 0 to RemoteSites.SiteList.Count - 1 do
    TRemoteSite(RemoteSites.SiteList.Items[i]).ReportClear;
  x := Piece(aQualifier, ';', 3);
  if (CharAt(lstQualifier.ItemID,1) = 'd')
    and (length(x)>0)
    and (StrToInt(x)<101) then
      aMax := ';101';
  if uFrozen = True then
    begin
      memo1.visible := False;
      memo1.TabStop := False;
    end;
  Screen.Cursor := crHourGlass;
  if (GraphForm <> nil) and (aReportType <> 'G') then
  begin
    GraphForm.SendToBack;
    GraphPanel(false);
    GraphFormActive := false;
  end;
  if aReportType = 'G' then
    begin
      Graph(aIFN);
    end
  else
  if aReportType = 'M' then
    begin
      pnlRightTopHeaderMid.Visible := false;
      pnlLeftBottom.Visible := false;
      splitter1.Visible := false;
      pnlRighttop.Height := lblProcTypeMsg.Height + lblTitle.Height;
      pnlRightTop.Visible := true;
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
     uQualifierType := StrToIntDef(aRptCode,0);
      case uQualifierType of
        QT_OTHER:
          begin      //      = 0
            memText.Lines.Clear;
            pnlRightTopHeaderMid.Visible := false;
            pnlRightTop.Height := lblProcTypeMsg.Height + lblTitle.Height;
            if TabControl1.Tabs.Count > 1 then
              pnlRightTop.Height := pnlRightTop.Height + TabControl1.Height;
            if ((aRemote = '1') or (aRemote = '2')) then
              ShowTabControl;
            if copy(aRptCode,1,2) = 'h0' then  //HS Adhoc
              begin
                if TabControl1.TabIndex > 0 then
                  begin
                    InfoBox('Adhoc report is not available for remote sites',
                      'Information', MB_OK);
                    TabControl1.TabIndex := 0;
                  end;
                with RemoteSites.SiteList do
                for j := 0 to Count - 1 do
                  begin
                    TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                    TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                  end;
                uHTMLDoc := '';
                if WebBrowser.Visible then BlankWeb;
                ExecuteAdhoc1;  //Calls Adhoc form
                if uLocalReportData.Count < 1 then
                  uReportInstruction := '<No Report Available>'
                else begin
                  if TabControl1.TabIndex < 1 then
                    QuickCopy(uLocalReportData,memText);
                  if WebBrowser.Visible then begin
                    if uReportType = 'R' then
                      uHTMLDoc := HTML_PRE + uLocalReportData.Text + HTML_POST
                    else
                      uHTMLDoc := String(uHTMLPatient) + uLocalReportData.Text;
                    BlankWeb;
                  end;
                end;
                TabControl1.OnChange(nil);
              end
            else
              begin
                RightTopHeader(34);
                pnlLeftBottom.Visible := false;
                splitter1.Visible := false;
                StatusText('Retrieving ' + tvReports.Selected.Text + '...');
                if ((aRemote = '1') or (aRemote = '2')) then
                  GoRemote(uRemoteReportData, aID, aRptCode, aRPC, uHState, aHDR, aFHIE)
                else
                  if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                uReportInstruction := #13#10 + 'Retrieving data...';
                TabControl1.OnChange(nil);
                if not(piece(uRemoteType, '^', 9) = '1') then
                  begin
                    LoadReportText(uLocalReportData, aID, aRptCode, aRPC, uHState);
                    QuickCopy(uLocalReportData, memText);
                  end;
                if WebBrowser.Visible then begin
                  if uReportType = 'R' then
                    uHTMLDoc := HTML_PRE + uLocalReportData.Text + HTML_POST
                  else
                    uHTMLDoc := String(uHTMLPatient) + uLocalReportData.Text;
                  BlankWeb;
                end;
                if uLocalReportData.Count > 0 then
                  TabControl1.OnChange(nil);
                StatusText('');
              end;
          end;
        QT_HSTYPE:
          begin      //      = 1
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            RightTopHeader(0);
          end;
        QT_DATERANGE:
          begin      //      = 2
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
                if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                lvReports.SmallImages := uEmptyImageList;
                imgLblImages.ComponentImageListChanged;
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
                if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
              end;
            uRDOChanging := true;
            lstQualifierClick(self);
            uRDOChanging := false;
            lblQualifier.Caption := 'Date Range';
            pnlLeftBottom.Visible := true;
            splitter1.Visible := true;
            if uUseRadioButton then
              begin
                pnlLeftBottom.Visible := false;
                splitter1.Visible := false;
                if not (uReportType = 'M') then
                  RightTopHeader(70)
                else
                  RightTopHeader(45);
                pnlRightTopHeaderMid.Visible := true;
                pnlRightTopHeaderMidUpper.Visible := true;
                lblDateRange.Visible := false;
                lblQualifier.Visible := false;
                lstQualifier.Visible := false;
                lstDateRange.Visible := false;
              end
            else
              begin
                RightTopHeader(34);
                pnlRightTopHeaderMid.Visible := false;
              end;
          end;
        QT_IMAGING:
          begin      //      = 3
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            ListImagingExams(uLocalReportData);
            aRadParam := ImagingParams;
            uQualifier := StringReplace(aRadParam, '^', ';', [rfReplaceAll]);
            with lvReports do
              begin
                Items.BeginUpdate;
                ViewStyle := vsReport;
                SmallImages := dmodShared.imgImages;
                imgLblImages.ComponentImageListChanged;
                CurrentParentNode := nil;
                CurrentNode := nil;
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
                        if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                      end;
                  end;
                for i := 0 to uLocalReportData.Count - 1 do
                  begin
                    ListItem := Items.Add;
                    ListItem.Caption := piece(piece(uLocalReportData[i],'^',1),';',1);
                    if uColumns.Count > 1 then
                      begin
                        for j := 2 to uColumns.Count do
                          ListItem.SubItems.Add(piece(uLocalReportData[i],'^',j));
                          // if pieces are (added to/removed from) return string, PLEASE UPDATE THIS!!  (RV)
                          if Piece(uLocalReportData[i], U, 9) = 'Y' then
                            ListItem.SubItemImages[1] := IMG_1_IMAGE
                          else
                            ListItem.SubItemImages[1] := IMG_NO_IMAGES;
                      end;
                    LoadProceduresTreeView(uLocalReportData[i], CurrentParentNode, CurrentNode);
                    if CurrentNode <> nil then
                      PProcTreeObj(CurrentNode.Data)^.Associate := lvReports.Items.IndexOf(ListItem);
                  end;
                if tvProcedures.Items.Count > 0 then
                   tvProcedures.Selected := tvProcedures.Items.GetFirstNode;
                lblProcTypeMsg.Visible := TRUE;
                pnlRightTop.Height := lblTitle.Height + lblProcTypeMsg.Height;
                pnlLeftBottom.Visible := FALSE;
                pnlProcedures.Visible := TRUE;
                Splitter1.Visible := True;
                if lvReports.Columns.Count > 0 then lvReports.Columns[1].Width := 0;
                Items.EndUpdate;
                tvProcedures.TopItem := tvProcedures.Selected;
              end;
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
            if uLocalReportData.Count > 0
              then x := #13#10 + 'Select an imaging exam...'
              else x := #13#10 + 'No imaging reports found...';
            uReportInstruction := PChar(x);
            memText.Lines.Add(uReportInstruction);
            if WebBrowser.Visible then begin
              uHTMLDoc := HTML_PRE + uReportInstruction + HTML_POST;
              BlankWeb;
            end;
          end;
        QT_NUTR:
          begin      //      = 4
            lblQualifier.Caption := 'Nutritional Assessments';
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            ListNutrAssessments(uLocalReportData);
            with lvReports do
              begin
                Items.BeginUpdate;
                ViewStyle := vsReport;
                for i := 0 to uLocalReportData.Count - 1 do
                  begin
                    ListItem := Items.Add;
                    ListItem.Caption := piece(piece(uLocalReportData[i],'^',1),';',1);
                    if uColumns.Count > 1 then
                      for j := 2 to uColumns.Count do
                        ListItem.SubItems.Add(piece(uLocalReportData[i],'^',j));
                  end;
                if lvReports.Columns.Count > 0 then lvReports.Columns[1].Width := 0;
                Items.EndUpdate;
              end;
            if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
            if uLocalReportData.Count > 0
              then x := #13#10 + 'Select an assessment date...'
              else x := #13#10 + 'No nutritional assessments found...';
            uReportInstruction := PChar(x);
            memText.Lines.Add(uReportInstruction);
            if WebBrowser.Visible then begin
              uHTMLDoc := HTML_PRE + uReportInstruction + HTML_POST;
              BlankWeb;
            end;
          end;
        QT_HSCOMPONENT:
          begin      //      = 5
            if Notifications.AlertData <> '' then
              pnlRightMiddle.Height := 75
            else
              pnlRightMiddle.Height := pnlRight.Height - (pnlRight.Height div 2);
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            StatusText('Retrieving ' + tvReports.Selected.Text + '...');
            uReportInstruction := #13#10 + 'Retrieving data...';
            lvReports.SmallImages := uEmptyImageList;
            imgLblImages.ComponentImageListChanged;
            lvReports.Items.Clear;
            RowObjects.Clear;
            memText.Lines.Clear;
            pnlRightTopHeaderMid.Visible := false;
            if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
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
                          end;
                      end
                      else
                        begin
                          if ((aRemote = '1') or (aRemote = '2')) then
                            //GoRemote(uRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
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
                                end;
                            end;
                        end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    pnlLeftBottom.Visible := true;
                    splitter1.Visible := true;
                    if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(70)
                        else
                          RightTopHeader(45);
                        pnlLeftBottom.Visible := false;
                        splitter1.Visible := false;
                      end
                    else RightTopHeader(0);
                  end
                else
                  begin
                    if not (aRemote = '2' ) then
                      GoRemote(uRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
                    else
                      if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                    if not(piece(uRemoteType, '^', 9) = '1') then
                      begin
                        LoadReportText(uLocalReportData, aID, aQualifierID, aRPC, uHState);
                        LoadListView(uLocalReportData);
                      end;
                    RightTopHeader(0);
                    pnlRightTop.Height := lblProcTypeMsg.Height + lblTitle.Height;
                    if TabControl1.Tabs.Count > 1 then
                      pnlRightTop.Height := pnlRightTop.Height + TabControl1.Height;
                  end;
              end
            else
              begin
                if (aRemote = '1') or (aRemote = '2') then
                  if TabControl1.Tabs.Count > 1 then
                    ShowTabControl;
                sptHorzRight.Visible := false;
                pnlRightMiddle.Visible := false;
                if ((aRemote = '1') or (aRemote = '2')) then
                  GoRemote(uRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
                else
                  if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                if not(piece(uRemoteType, '^', 9) = '1') then
                  LoadReportText(uLocalReportData, aID, aQualifierID, aRPC, uHState);
                if uLocalReportData.Count < 1 then
                  uReportInstruction := '<No Report Available>'
                else
                  begin
                    if TabControl1.TabIndex < 1 then
                      QuickCopy(uLocalReportData,memText);
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
                        if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
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
                        if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                      end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    pnlLeftBottom.Visible := true;
                    splitter1.Visible := true;
                    if uUseRadioButton then
                      begin
                        pnlLeftBottom.Visible := false;
                        splitter1.Visible := false;
                        if not (uReportType = 'M') then
                          RightTopHeader(70)
                        else
                          RightTopHeader(45);
                        pnlRightTopHeaderMid.Visible := true;
                        pnlRightTopHeaderMidUpper.Visible := true;
                        lblDateRange.Visible := false;
                        lblQualifier.Visible := false;
                        lstQualifier.Visible := false;
                        lstDateRange.Visible := false;
                      end
                    else
                      begin
                        RightTopHeader(34);
                        pnlRightTopHeaderMid.Visible := false;
                      end;
                  end
                else
                  begin
                    if uLocalReportData.Count < 1 then
                      begin
                        uReportInstruction := '<No Report Available>';
                        memText.Lines.Add(uReportInstruction);
                      end
                    else
                      begin
                        QuickCopy(uLocalReportData,memText);
                        TabControl1.OnChange(nil);
                      end;
                  end;
              end;
            StatusText('');
          end;
        QT_HSWPCOMPONENT:
          begin      //      = 6
            if Notifications.AlertData <> '' then
              pnlRightMiddle.Height := 75
            else
              pnlRightMiddle.Height := pnlRight.Height - (pnlRight.Height div 2);
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            StatusText('Retrieving ' + tvReports.Selected.Text + '...');
            uReportInstruction := #13#10 + 'Retrieving data...';
            RightTopHeader(34);
            TabControl1.OnChange(nil);
            RowObjects.Clear;
            memText.Lines.Clear;
            lvReports.SmallImages := uEmptyImageList;
            imgLblImages.ComponentImageListChanged;
            lvReports.Items.Clear;
            pnlRightTopHeaderMid.Visible := false;
            pnlRightTopHeaderMidUpper.Visible := false;
            if not uDateOverride and (uRDOPick > 0) then lstQualifier.ItemIndex := uRDOPick;
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
                        if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                      end
                    else
                      begin
                        if ((aRemote = '1') or (aRemote = '2')) then
                          //GoRemote(uRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
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
                            if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                          end;
                        end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    pnlLeftBottom.Visible := true;
                    splitter1.Visible := true;
                    if uUseRadioButton then
                      begin
                        pnlLeftBottom.Visible := false;
                        splitter1.Visible := false;
                        if not (uReportType = 'M') then
                          RightTopHeader(70)
                        else
                          RightTopHeader(45);
                        pnlRightTopHeaderMid.Visible := true;
                        pnlRightTopHeaderMidUpper.Visible := true;
                        lblDateRange.Visible := false;
                        lblQualifier.Visible := false;
                        lstQualifier.Visible := false;
                        lstDateRange.Visible := false;
                      end
                    else
                      begin
                        RightTopHeader(34);
                        pnlRightTopHeaderMid.Visible := false;
                      end;
                  end
                else
                  begin
                    if ((aRemote = '1') or (aRemote = '2')) then
                      GoRemote(uRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
                    else
                      if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                    if not (aRemote = '2' ) and (not(piece(uRemoteType, '^', 9) = '1')) then
                      begin
                        LoadReportText(uLocalReportData, aID, aQualifierID, aRPC, uHState);
                        LoadListView(uLocalReportData);
                      end;
                    RightTopHeader(34);
                    pnlRightTop.Height := lblProcTypeMsg.Height + lblTitle.Height;
                  end;
              end
            else
              begin
                if (aRemote = '1') or (aRemote = '2') then
                  ShowTabControl;
                sptHorzRight.Visible := false;
                sptHorzRightTop.Visible := false;
                pnlRightMiddle.Visible := false;
                if ((aRemote = '1') or (aRemote = '2')) then
                  GoRemote(uRemoteReportData, aID, aQualifierID, aRPC, uHState, aHDR, aFHIE)
                else
                  if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
                if not(piece(uRemoteType, '^', 9) = '1') then
                  LoadReportText(uLocalReportData, aID, aQualifierID, aRPC, uHState);
                if uLocalReportData.Count < 1 then
                  uReportInstruction := '<No Report Available>'
                else
                  begin
                    if TabControl1.TabIndex < 1 then
                      QuickCopy(uLocalReportData,memText);
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
                        if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                      end;
                    uRDOChanging := true;
                    lstQualifierClick(self);
                    uRDOChanging := false;
                    lblQualifier.Caption := 'Date Range';
                    pnlLeftBottom.Visible := true;
                    splitter1.Visible := true;
                    if uUseRadioButton then
                      begin
                        if not (uReportType = 'M') then
                          RightTopHeader(70)
                        else
                          RightTopHeader(45);
                        pnlLeftBottom.Visible := false;
                        splitter1.Visible := false;
                      end
                    else RightTopHeader(0);
                  end
                else
                  begin
                    LoadListView(uLocalReportData);
                  end;
              end;
            StatusText('');
          end;
        QT_PROCEDURES:
          begin      //      = 19
            RightTopHeader(34);
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            ListProcedures(uLocalReportData);
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
                    if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                  end;
              end;
            with lvReports do
              begin
                Items.BeginUpdate;
                ViewStyle := vsReport;
                for i := 0 to uLocalReportData.Count - 1 do
                  begin
                    ListItem := Items.Add;
                    ListItem.Caption := piece(piece(uLocalReportData[i],'^',1),';',1);
                    if uColumns.Count > 1 then
                      for j := 2 to uColumns.Count do
                        ListItem.SubItems.Add(piece(uLocalReportData[i],'^',j));
                  end;
                if lvReports.Columns.Count > 0 then lvReports.Columns[1].Width := 0;
                Items.EndUpdate;
              end;
            if uLocalReportData.Count > 0
              then x := #13#10 + 'Select a procedure...'
              else x := #13#10 + 'No procedures found...';
            uReportInstruction := PChar(x);
            if WebBrowser.Visible then begin
              uHTMLDoc := HTML_PRE + uReportInstruction + HTML_POST;
              BlankWeb;
            end;
          end;
        QT_SURGERY:
          begin      //      = 28
            RightTopHeader(34);
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            ListSurgeryReports(uLocalReportData);
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
                    if not aQualMatch then lstQualifier.ItemIndex := lstQualifier.Items.Add(aQualAdd);
                  end;
              end;
            with lvReports do
              begin
                Items.BeginUpdate;
                ViewStyle := vsReport;
                for i := 0 to uLocalReportData.Count - 1 do
                  begin
                    ListItem := Items.Add;
                    ListItem.Caption := piece(piece(uLocalReportData[i],'^',1),';',1);
                    if uColumns.Count > 1 then
                      for j := 2 to uColumns.Count do
                        ListItem.SubItems.Add(piece(uLocalReportData[i],'^',j));
                  end;
                if lvReports.Columns.Count > 0 then lvReports.Columns[1].Width := 0;
                Items.EndUpdate;
              end;
            if uLocalReportData.Count > 0
              then x := #13#10 + 'Select a surgery case...'
              else x := #13#10 + 'No surgery cases found...';
            uReportInstruction := PChar(x);
            memText.Lines.Add(uReportInstruction);
            uHTMLDoc := HTML_PRE + uReportInstruction + HTML_POST;
            if WebBrowser.Visible then BlankWeb;
          end;
        else
          begin      //      = ?
            uQualifierType := QT_OTHER;
            pnlLeftBottom.Visible := false;
            splitter1.Visible := false;
            StatusText('Retrieving ' + tvReports.Selected.Text + '...');
            if ((aRemote = '1') or (aRemote = '2')) then
              GoRemote(uRemoteReportData, aID, aRptCode, aRPC, uHState, aHDR, aFHIE)
            else
              if TabControl1.TabIndex > 0 then TabControl1.TabIndex := 0;
            uReportInstruction := #13#10 + 'Retrieving data...';
            TabControl1.OnChange(nil);
            if not(piece(uRemoteType, '^', 9) = '1') then
              LoadReportText(uLocalReportData, aID, '', aRPC, uHState);
            if uLocalReportData.Count < 1 then
              uReportInstruction := '<No Report Available>'
            else
              begin
                if TabControl1.TabIndex < 1 then
                  QuickCopy(uLocalReportData,memText);
              end;
            TabControl1.OnChange(nil);
            StatusText('');
          end;
        lstQualifier.Caption := lblQualifier.Caption;
      end;
    end;
  if (uQualifierType = QT_IMAGING) or (uQualifierType = QT_NUTR) or (uQualifierType = QT_PROCEDURES) or (uQualifierType = QT_SURGERY) or (aReportType = 'G') then
    begin
      if not uRDOStick then
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
              if not (aHDR = '1') and (lstDateRange.ItemIndex > -1) then
                if (aCategory <> '0') and (not WebBrowser.Visible) then
                  begin
                    x := lstDateRange.DisplayText[lstDateRange.ItemIndex];
                    x1 := piece(x,' ',1);
                    x2 := piece(x,' ',3);
                    if (Uppercase(Copy(x1,1,1)) = 'T') and (Uppercase(Copy(x2,1,1)) = 'T') then
                      DisplayHeading(piece(x,' ',1) + ';' + piece(x,' ',2) + ';' + aMax)
                    else
                      DisplayHeading('d' + lstDateRange.ItemID + ';' + aMax);
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
                    x := lstQualifier.DisplayText[uRDOPick];
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
        end;
    end;
  SendMessage(tvReports.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
  RedrawActivate(tvReports.Handle);
  RedrawActivate(memText.Handle);
  if WebBrowser.Visible then begin
    BlankWeb;
    WebBrowser.BringToFront;
  end else if not GraphFormActive then
    begin
      memText.Visible := true;
      memText.TabStop := true;
      memText.BringToFront;
    end
  else
    begin
      GraphPanel(true);
      with GraphForm do
      begin
        lstDateRange.Items := cboDateRange.Items;
        lstDateRange.ItemIndex := cboDateRange.ItemIndex;
        ViewSelections;
        BringToFront;
      end;
    end;
  lvReports.Columns.BeginUpdate;
  lvReports.Columns.EndUpdate;
  Screen.Cursor := crDefault;
end;

procedure TfrmReports.lvReportsColumnClick(Sender: TObject;
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

procedure TfrmReports.lvReportsCompare(Sender: TObject; Item1,
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

procedure TfrmReports.lvReportsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  aID, aMoreID, aSID: string;
  i,j,k: integer;
  aBasket: TStringList;
  aWPFlag: Boolean;
  x, HasImages: string;

begin
  inherited;
  if not selected then Exit;
  aBasket := TStringList.Create;
  uLocalReportData.Clear;
  aWPFlag := false;
  with lvReports do
    begin
      aID := Item.SubItems[0];
      case uQualifierType of
            QT_OTHER:
              begin      //      = 0

              end;
            QT_HSTYPE:
              begin      //      = 1
                aMoreID := ';' +  Item.SubItems[2];
              end;
            QT_DATERANGE:
              begin      //      = 2

              end;
            QT_IMAGING:
              begin      //      = 3
                if lvReports.SelCount = 1 then
                  begin
                    memText.Lines.Clear;
                    if not UpdatingTvProcedures then
                      begin
                      UpdatingLvReports := TRUE;
                      for i := 0 to (tvProcedures.Items.Count - 1) do
                        if PProcTreeObj(tvProcedures.Items[i].Data)^.ExamDtTm = Item.SubItems[0] then
                           if PProcTreeObj(tvProcedures.Items[i].Data)^.ProcedureName = Item.SubItems[2] then
                              begin
                                if tvProcedures.Items[i].Parent <> nil then
                                   begin
                                     tvProcedures.Items[i].Parent.Expanded := True;
                                     if PProcTreeObj(tvProcedures.Items[i].Data)^.MemberOfSet = '1' then
                                        lblProcTypeMsg.Caption := 'Descendent Procedure'
                                     else if PProcTreeObj(tvProcedures.Items[i].Data)^.MemberOfSet = '2' then
                                             lblProcTypeMsg.Caption := 'Descendent Procedure with shared report';
                                   end
                                else
                                   lblProcTypeMsg.Caption := 'Standalone (single) procedure';
                                tvProcedures.Items[i].Selected := TRUE;
                              end;
                      UpdatingLvReports := False;
                      end;
                  end
                else
                  if not UpdatingTvProcedures then
                     tvProcedures.Selected := nil;

                if MemText.Lines.Count > 0 then
                  memText.Lines.Add('===============================================================================');
                aMoreID := '#' + Item.SubItems[5];
                SetPiece(uRemoteType,'^',5,aID + aMoreID);
                if not(piece(uRemoteType, '^', 9) = '1') then
                  begin
                    LoadReportText(uLocalReportData, uRptID, aID + aMoreID, uReportRPC, '');
                    for i := 0 to uLocalReportData.Count - 1 do
                      MemText.Lines.Add(uLocalReportData[i]);
                    if Item.SubItems.Count > 5 then
                      x := 'RA^' + aID + U + Item.SubItems[5]
                    else
                      x := 'RA^' + aID;
                    HasImages := BOOLCHAR[Item.SubItemImages[1] = IMG_1_IMAGE];
                    SetPiece(x, U, 10, HasImages);
                    NotifyOtherApps(NAE_REPORT, x);
                  end;
              end;
            QT_NUTR:
              begin      //      = 4
                if lvReports.SelCount = 1 then
                  memText.Lines.Clear;
                if MemText.Lines.Count > 0 then
                  memText.Lines.Add('===============================================================================');
                SetPiece(uRemoteType,'^',5,aID);
                if not(piece(uRemoteType, '^', 9) = '1') then
                  begin
                    LoadReportText(uLocalReportData, uRptID, aID, uReportRPC, '');
                    for i := 0 to uLocalReportData.Count - 1 do
                      MemText.Lines.Add(uLocalReportData[i]);
                  end;
              end;
            QT_HSWPCOMPONENT:
              begin      //      = 6
                if lvReports.SelCount < 3 then
                  begin
                    memText.Lines.Clear;
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
                          for j := 0 to RowObjects.ColumnList.Count - 1 do
                            if piece(aSID,':',1) = piece(TCellObject(RowObjects.ColumnList[j]).Handle,':',1) then
                              if Item.Caption = (piece(TCellObject(RowObjects.ColumnList[j]).Site,';',1)) then
                                if (TCellObject(RowObjects.ColumnList[j]).Data.Count > 0) and
                                  (TCellObject(RowObjects.ColumnList[j]).Include = '1') then
                                  begin
                                    aWPFlag := true;
                                    MemText.Lines.Add(TCellObject(RowObjects.ColumnList[j]).Name);
                                    FastAssign(TCellObject(RowObjects.ColumnList[j]).Data, aBasket);
                                    for k := 0 to aBasket.Count - 1 do
                                      MemText.Lines.Add(' ' + aBasket[k]);
                                  end;
                          if aWPFlag = true then
                            begin
                              memText.Lines.Add('Facility: ' + Item.Caption);
                              memText.Lines.Add('===============================================================================');
                            end;
                        end;
                  end;
                aBasket.Clear;
                aWPFlag := false;
                for i := 0 to RowObjects.ColumnList.Count - 1 do
                  if piece(aID,':',1) = piece(TCellObject(RowObjects.ColumnList[i]).Handle,':',1) then
                    if Item.Caption = (piece(TCellObject(RowObjects.ColumnList[i]).Site,';',1)) then
                      if (TCellObject(RowObjects.ColumnList[i]).Data.Count > 0) and
                        (TCellObject(RowObjects.ColumnList[i]).Include = '1') then
                        begin
                          aWPFlag := true;
                          MemText.Lines.Add(TCellObject(RowObjects.ColumnList[i]).Name);
                          FastAssign(TCellObject(RowObjects.ColumnList[i]).Data, aBasket);
                          for j := 0 to aBasket.Count - 1 do
                            MemText.Lines.Add(' ' + aBasket[j]);
                        end;
                if aWPFlag = true then
                  begin
                    memText.Lines.Add('Facility: ' + Item.Caption);
                    memText.Lines.Add('===============================================================================');
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
                    memText.Lines.Insert(0,'<Imaging links not active at this site>');
                    memText.Lines.Insert(1,' ');
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
                if lvReports.SelCount = 1 then
                  memText.Lines.Clear;
                if MemText.Lines.Count > 0 then
                  memText.Lines.Add('===============================================================================');
                SetPiece(uRemoteType,'^',5,aID);
                if not(piece(uRemoteType, '^', 9) = '1') then
                  begin
                    LoadReportText(uLocalReportData, uRptID, aID + aMoreID, uReportRPC, '');
                    for i := 0 to uLocalReportData.Count - 1 do
                      MemText.Lines.Add(uLocalReportData[i]);
                  end;
              end;
            QT_SURGERY:
              begin      //      = 28
                if lvReports.SelCount = 1 then
                  memText.Lines.Clear;
                if MemText.Lines.Count > 0 then
                  memText.Lines.Add('===============================================================================');
                SetPiece(uRemoteType,'^',5,aID);
                if not(piece(uRemoteType, '^', 9) = '1') then
                  begin
                    LoadReportText(uLocalReportData, uRptID, aID + aMoreID, uReportRPC, '');
                    for i := 0 to uLocalReportData.Count - 1 do
                      MemText.Lines.Add(uLocalReportData[i]);
                    NotifyOtherApps(NAE_REPORT, 'SUR^' + aID);
                  end;
              end;
      end;
      memText.Lines.Insert(0,' ');
      memText.Lines.Delete(0);
    end;
  aBasket.Free;
end;

procedure TfrmReports.tvReportsExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  inherited;
  tvReports.Selected := Node;
end;

procedure TfrmReports.tvReportsCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  inherited;
  tvReports.Selected := Node;
end;


procedure TfrmReports.Print1Click(Sender: TObject);
begin
  inherited;
  RequestPrint;
end;

procedure TfrmReports.Copy1Click(Sender: TObject);
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

procedure TfrmReports.Copy2Click(Sender: TObject);
begin
  inherited;
  memText.CopyToClipboard;
end;

procedure TfrmReports.Print2Click(Sender: TObject);
begin
  inherited;
  RequestPrint;
end;

procedure TfrmReports.lvReportsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = 67) and (ssCtrl in Shift) then
    Copy1Click(Self);
  if (Key = 65) and (ssCtrl in Shift) then
    SelectAll1Click(Self);
end;

procedure TfrmReports.SelectAll1Click(Sender: TObject);
var
  i: integer;
begin
  inherited;
    for i := 0 to lvReports.Items.Count - 1 do
       lvReports.Items[i].Selected := true;
end;

procedure TfrmReports.SelectAll2Click(Sender: TObject);
begin
  inherited;
  memText.SelectAll;
end;

   
procedure TfrmReports.tvReportsKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmReports.ShowTabControl;
begin
  if TabControl1.Tabs.Count > 1 then
    begin
      TabControl1.Visible := true;
      TabControl1.TabStop := true;
      if uUseRadioButton = true then RightTopHeader(70)
      else RightTopHeader(0);
    end;
end;

procedure TfrmReports.HideTabControl;
begin
  TabControl1.Visible := false;
  TabControl1.TabStop := false;
  if uUseRadioButton = true then
    if not (uReportType = 'M') then
      RightTopHeader(70)
    else
      RightTopHeader(45)
  else RightTopHeader(0);
end;

procedure TfrmReports.Memo1KeyUp(Sender: TObject; var Key: Word;
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

procedure TfrmReports.LoadProceduresTreeView(x: string; var CurrentParentNode: TTreeNode; var CurrentNode: TTreeNode);
var
  PTO, PTO2: PProcTreeObj;

begin
  PTO := MakeProcedureTreeObject(x);
  PTO2 := MakeProcedureTreeObject(x);
  PTO2.ProcedureName := '';
  if PTO^.ParentName = '' then
     begin // New stand-alone
       CurrentParentNode := tvProcedures.Items.AddObject(CurrentParentNode,PTO^.ProcedureName,PTO);
       CurrentNode := CurrentParentNode;
     end
  else
    if (CurrentParentNode <> nil) and (PTO^.ParentName = PProcTreeObj(CurrentParentNode.Data)^.ParentName) then
          // another child for same parent
       CurrentNode := tvProcedures.Items.AddChildObject(CurrentParentNode,PTO^.ProcedureName,PTO)
    else
       begin //New child and parent
         CurrentParentNode := tvProcedures.Items.AddObject(CurrentParentNode,PTO2^.ParentName,PTO2);
         CurrentNode := tvProcedures.Items.AddChildObjectFirst(CurrentParentNode,PTO^.ProcedureName,PTO);
        end;
end;

procedure TfrmReports.tvProceduresCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  inherited;
  tvReports.Selected := Node;
end;

procedure TfrmReports.tvProceduresExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  inherited;
  tvReports.Selected := Node;
end;

procedure TfrmReports.tvProceduresClick(Sender: TObject);
var
  Associate: Integer;
  SelNode: TTreeNode;
begin
  inherited;
  SelNode := TTreeView(Sender).Selected;
  if not assigned(SelNode) then Exit;
  Associate := PProcTreeObj(SelNode.Data)^.Associate;
  lvReports.Selected := nil;
  if PProcTreeObj(SelNode.Data)^.ProcedureName <> '' then  //if it is a descendent or a stand-alone
     begin
       memText.Lines.Clear;
       lvReports.Selected := lvReports.Items[Associate];
       if PProcTreeObj(SelNode.Data)^.MemberOfSet = '1' then
          lblProcTypeMsg.Caption := 'Descendent Procedure'
       else
          if PProcTreeObj(SelNode.Data)^.MemberOfSet = '2' then
             lblProcTypeMsg.Caption := 'Descendent Procedure with shared report';
     end
  else         //if it is a parent with descendents
     if PProcTreeObj(SelNode.Data)^.MemberOfSet = '2' then  //printset = shared report
        lblProcTypeMsg.Caption := 'Descendent Procedures with shared report'
     else if PProcTreeObj(SelNode.Data)^.MemberOfSet = '1' then    //examset - individual reports
             begin
               memText.Lines.Clear;
               lblProcTypeMsg.Caption := 'Descendent Procedures - Select to view individual reports';
               memText.Lines.Add('Descendent Procedures - Select to view individual reports...')
             end;
end;

procedure TfrmReports.tvProceduresChange(Sender: TObject; Node: TTreeNode);
var
  Associate, i: Integer;
  FirstChild: TTreeNode;
  aID, aMoreID: string;
  x, HasImages: string;
begin
  inherited;
  if UpdatingLvReports or not assigned(Node) then Exit;
    UpdatingTVProcedures := TRUE;
    Associate := PProcTreeObj(Node.Data)^.Associate;
    lvReports.Selected := nil;
    if PProcTreeObj(Node.Data)^.ProcedureName <> '' then  //if it is a descendent or a stand-alone
       if (Associate >= 0) and (Associate < (lvReports.Items.Count)) then // if valid associate in lvReports
          if lvReports.Items[Associate].Selected = FALSE then  // if not already selected
             begin
               lvReports.Selected := lvReports.Items[Associate];
               if PProcTreeObj(Node.Data)^.MemberOfSet = '1' then
                  begin
                    lblProcTypeMsg.Caption := 'Descendent Procedure';
                  end
               else if PProcTreeObj(Node.Data)^.MemberOfSet = '2' then
                       lblProcTypeMsg.Caption := 'Descendent Procedures with shared report'
                    else if PProcTreeObj(Node.Data)^.MemberOfSet = '' then
                            lblProcTypeMsg.Caption := 'Standalone (single) procedure';
             end;
    UpdatingTvProcedures := FALSE;

    if PProcTreeObj(Node.Data)^.ProcedureName = '' then  //Parent with descendents
       if PProcTreeObj(Node.Data)^.MemberOfSet = '2' then  //printset = shared report
          begin
            lblProcTypeMsg.Caption := 'Descendent Procedures with shared report';
            FirstChild := Node.GetFirstChild;
            Associate := PProcTreeObj(FirstChild.Data)^.Associate;
            aID := lvReports.Items[Associate].SubItems[0];
            aMoreID := '#' + lvReports.Items[Associate].SubItems[5];
            SetPiece(uRemoteType,'^',5,aID + aMoreID);
            uLocalReportData.Clear;
            MemText.Lines.Clear;
            if not(piece(uRemoteType, '^', 9) = '1') then
              begin
                LoadReportText(uLocalReportData, uRptID, aID + aMoreID, uReportRPC, '');
                for i := 0 to uLocalReportData.Count - 1 do
                  MemText.Lines.Add(uLocalReportData[i]);
                memText.SelStart := 0;
                if lvReports.Items[Associate].SubItems.Count > 5 then
                  x := 'RA^' + aID + U + lvReports.Items[Associate].SubItems[5]
                else
                  x := 'RA^' + aID;
                HasImages := BOOLCHAR[lvReports.Items[Associate].SubItemImages[1] = IMG_1_IMAGE];
                SetPiece(x, U, 10, HasImages);
                NotifyOtherApps(NAE_REPORT, x);
              end;
          end
       else if PProcTreeObj(Node.Data)^.MemberOfSet = '1' then    //examset - individual reports
               begin
                 memText.Lines.Clear;
                 lblProcTypeMsg.Caption := 'Descendent Procedures - Select to view individual reports';
                 memText.Lines.Add('Descendent Procedures - Select to view individual reports...');
               end;
end;

procedure TfrmReports.tvProceduresKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmReports.chkDualViewsClick(Sender: TObject);
begin
  inherited;
  if (GraphForm <> nil) and GraphFormActive then
    GraphForm.chkDualViews.Checked := chkDualViews.Checked;
end;

procedure TfrmReports.chkMaxFreqClick(Sender: TObject);
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

procedure TfrmReports.BlankWeb;
begin
  try
    WebBrowser.Navigate(BlankWebPage);
  except
  end;
end;

procedure TfrmReports.btnAppearRtClick(Sender: TObject);
begin
  inherited;
  btnClear.Visible := not btnClear.Visible;
  chkMaxFreq.Visible := not chkMaxFreq.Visible;
end;

procedure TfrmReports.btnChangeViewClick(Sender: TObject);
begin
  inherited;
  if (GraphForm <> nil) and GraphFormActive then
  begin
    GraphForm.btnChangeSettingsClick(GraphForm);
    chkDualViews.Checked := GraphForm.chkDualViews.Checked;
  end;
end;

procedure TfrmReports.btnGraphSelectionsClick(Sender: TObject);
begin
  inherited;
  if (GraphForm <> nil) and GraphFormActive then
  begin
    GraphForm.btnGraphSelectionsClick(GraphForm);
    chkDualViews.Checked := GraphForm.chkDualViews.Checked;
  end;
end;

procedure TfrmReports.btnClearClick(Sender: TObject);
begin
  inherited;
  uRDOStick := false;
  uRDOPick := 0;
  lstQualifier.Clear;
  lstDateRange.Clear;
  LoadTreeView;
end;

procedure TfrmReports.RightTopHeader(MidSize: Integer);
begin
  if (pnlRightTopHeaderMid.Height > MidSize) and not (MidSize = 0) then MidSize := 42;
  if font.size > 10 then MidSize := MidSize + (font.Size div 2) * 3;
  if font.Size > 14 then MidSize := MidSize + 10;

  if (TabControl1.Tabs.Count > 1) and (TabControl1.Visible) then
    begin
      pnlRightTop.Height := lblProcTypeMsg.Height + MidSize + TabControl1.Height;
    end
  else
    pnlRightTop.Height := lblProcTypeMsg.Height + MidSize;
end;

procedure TfrmReports.lstDateRangeClick(Sender: TObject);
begin
  inherited;
  ulstDatesChanging := true;
  if (GraphForm <> nil) then
  begin
    GraphForm.cboDateRange.ItemIndex := lstDateRange.ItemIndex;
    GraphForm.cboDateRangeChange(self);
    FastAssign(GraphForm.cboDateRange.Items, lstDateRange.Items);
    lstDateRange.ItemIndex := GraphForm.cboDateRange.ItemIndex;
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
      if lstDateRange.ItemIndex = 1 then rdoToday.Checked := true;
      if lstDateRange.ItemIndex = 2 then rdo1Week.Checked := true;
      if lstDateRange.ItemIndex = 3 then rdo1Month.Checked := true;
      if lstDateRange.ItemIndex = 4 then rdo6Month.Checked := true;
      if lstDateRange.ItemIndex = 5 then rdo1Year.Checked := true;
      if lstDateRange.ItemIndex = 6 then rdo2Year.Checked := true;
      if lstDateRange.ItemIndex = 7 then rdoAllResults.Checked := true;
      uRDOStick := true;
      uRDOPick := lstDateRange.ItemIndex;
    end;
  ulstDatesChanging := false;
  Timer1.Interval := 3000;
end;

procedure TfrmReports.sptHorzMoved(Sender: TObject);
begin
  inherited;
  pnlTopViews.Height := 80;
end;

initialization
  SpecifyFormIsNotADialog(TfrmReports);

end.
