unit fPtSel;
{ Allows patient selection using various pt lists.  Allows display & processing of alerts. }
{------------------------------------------------------------------------------
Update History

    2016-02-15: NSR#20081008 (CPRS Notification Alert Processing Improvement)
    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}

{$define VAA}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ORCtrls,
  ExtCtrls,
  ORFn,
  ORNet,
  ORDtTmRng,
  Gauges,
  Menus,
  ComCtrls,
  CommCtrl,
  fBase508Form,
  VA508AccessibilityManager,
  uConst,
  System.UITypes,
  Vcl.Buttons,
  Vcl.ImgList,
  uInfoBoxWithBtnControls,
  ClipBrd,
  DateUtils,
  System.Generics.Collections,
  dShared,
  mPtSelDemog,
  mPtSelOptns;

type
  TPageControl = class(Vcl.ComCtrls.TPageControl)
  public
    function CanFocus: Boolean; override;
  end;

  TProgressBar = class(Vcl.ComCtrls.TProgressBar)
  private
    FCanvas: TCanvas;
    FProgressText: String;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetProgressText(const Value: String);
  protected
    procedure Paint; virtual;
    property Canvas: TCanvas read FCanvas;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ProgressText: String read FProgressText write SetProgressText;
  end;

  TCaptionListView = class(ORCtrls.TCaptionListView)
  private
    FChangingStateCount: integer;
    FBeforeChangingStateCursor: TCursor;
    FBeforeChangingStateEnabled: Boolean;
    function GetItemSelected(Index: integer): Boolean;
    procedure SetItemSelected(Index: integer; const Value: Boolean);
  public
    procedure BeginChangingStates;
    procedure EndChangingStates;
    // These methods and properties are used to get and set selection states
    // without having to trigger an OnData event for each item
    function SelectedIndex: integer;
    procedure SelectAllItems(Selected: Boolean);
    function ChangingStates: Boolean;
    property ItemSelected[Index: integer]: Boolean read GetItemSelected write SetItemSelected;
  end;

  // The order of these alert date types is the order they are stored in FAlertData
  TAlertDataType = (adtInfo, adtPatient, adtLocation, adtUrgency, adtDateTime,
    adtMessage, adtForwardedBy, adtXQAID, adtRemovable, adtComment,
    adtOrderingProvider, adtSortableDateTime, adtItemState, adtNotUsed,
    adtSurrogateFor);

  TfrmPtSel = class(TfrmBase508Form)
    cboPatient: TORComboBox;
    lblPatient: TLabel;
    pnlNotifications: TORAutoPanel;
    cmdProcessInfo: TButton;
    cmdProcessAll: TButton;
    cmdProcess: TButton;
    cmdForward: TButton;
    sptVert: TSplitter;
    pnlDivide: TORAutoPanel;
    lblNotifications: TLabel;
    cmdRemove: TButton;
    popNotifications: TPopupMenu;
    mnuProcess: TMenuItem;
    mnuRemove: TMenuItem;
    mnuForward: TMenuItem;
    lstvAlerts: TCaptionListView;
    N1: TMenuItem;
    cmdComments: TButton;
    txtCmdComments: TVA508StaticText;
    txtCmdRemove: TVA508StaticText;
    txtCmdForward: TVA508StaticText;
    txtCmdProcess: TVA508StaticText;
    lblPtDemo: TLabel;
    cmdDefer: TButton;
    pcProcNoti: TPageControl;
    tsPendNoti: TTabSheet;
    dlgDateRange: TORDateRangeDlg;
    txtCmdDefer: TVA508StaticText;
    cmdOK: TButton;
    cmdCancel: TButton;
    cmdSaveList: TButton;
    tsProcessedAlertsForm: TTabSheet;
    pnlPaCanvas: TPanel;
    btnCancelProcessing: TButton;
    pbarNotifications: TProgressBar;
    gpTop: TGridPanel;
    fraPtSelOptns: TfraPtSelOptns;
    lblGap: TLabel;
    fraPtSelDemog: TfraPtSelDemog;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboPatientChange(Sender: TObject);
    procedure cboPatientKeyPause(Sender: TObject);
    procedure cboPatientMouseClick(Sender: TObject);
    procedure cboPatientEnter(Sender: TObject);
    procedure cboPatientExit(Sender: TObject);
    procedure cboPatientNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboPatientDblClick(Sender: TObject);
    procedure cmdProcessClick(Sender: TObject);
    procedure cmdSaveListClick(Sender: TObject);
    procedure cmdProcessInfoClick(Sender: TObject);
    procedure cmdProcessAllClick(Sender: TObject);
    procedure lstvAlertsDblClick(Sender: TObject);
    procedure cmdForwardClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboPatientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvAlertsColumnClick(Sender: TObject; Column: TListColumn);
    function DupLastSSN(var DFN: string): Boolean;
    procedure lstFlagsClick(Sender: TObject);
    procedure lstFlagsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvAlertsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ShowButts(AValue: Boolean);
    procedure lstvAlertsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure lstvAlertsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cmdCommentsClick(Sender: TObject);
    procedure cboPatientKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdDeferClick(Sender: TObject);

    procedure pcProcNotiResize(Sender: TObject);
    procedure pcProcNotiChange(Sender: TObject);
    procedure lstvAlertsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);

    procedure lstvAlertsData(Sender: TObject; Item: TListItem);
    procedure lstvAlertsDataStateChange(Sender: TObject; StartIndex,
      EndIndex: Integer; OldState, NewState: TItemStates);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function CanForwardAlerts(AItemIndices: TArray<Integer>): Boolean;
    procedure btnCancelProcessingClick(Sender: TObject);
    procedure pcProcNotiChanging(Sender: TObject; var AllowChange: Boolean);
    procedure lstvAlertsAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure sptVertMoved(Sender: TObject);
    procedure sptVertCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
  private
    FGridRowHeight: integer;
    FsortCol: Integer;
    FsortAscending: Boolean;
    FsortDirection: string;
    FUserCancelled: Boolean;
    FOKClicked: Boolean;
    FExpectedClose: Boolean;
    FNotificationBtnsAdjusted: Boolean;
    FAlertsNotReady: Boolean;
    FTrimmer: Boolean;
    FProcessingAlerts: Boolean;
    FAlertData: TStringList;
    FDisablePageControlTabStops: boolean;
    FTempSubItems: TStringList;
    FBeforeDisabledColor: TColor;
    FBuildColumns: Boolean;
    procedure WMReadyAlert(var Message: TMessage); message UM_MISC;
    procedure ReadyAlert;
    procedure AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
    procedure ClearIDInfo;
    procedure ShowIDInfo;
    procedure SetCaptionTop;
    procedure SetPtListTop(IEN: Int64);
    procedure RPLDisplay;
    procedure AlertList;
    procedure AdjustButtonSize(pButton: TButton);
    procedure AdjustNotificationButtons;
    procedure ShowDisabledButtonTexts;
    procedure SelectPtByDFN(aDFN:String);
    procedure WMSelectPatient(var Message: TMessage); message UM_SELECTPATIENT;
    function AlertData(Index: integer; DataType: TAlertDataType): string;
    function CreateSubItems(Index: integer): TStringList;
    procedure EnsureDemographicsVisible;
  end;

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer; var UserCancelled: Boolean);

var
  FDfltSrc, FDfltSrcType: string;
  IsRPL, RPLJob: string; // RPLJob stores server $J job number of RPL pt. list.
  RPLProblem: Boolean; // Allows close of form if there's an RPL problem.

implementation

{$R *.DFM}

uses
  rCore,
  uCore,
  fDupPts,
  fPtSens,
  fPatientFlagMulti,
  uOrPtf,
  fAlertForward,
  rMisc,
  fFrame,
  fRptBox,
  VA508AccessibilityRouter,
  VAUtils,
  System.Types,
  fDeferDialog,
  fNotificationProcessor,
  fOptions,
  fAlertsProcessed,
  uFormUtils,
  uSimilarNames,
  uSizing,
  UResponsiveGUI,
  uMisc;

type
  TAlertColumnInfo = record
  public
    DisplayData: TAlertDataType;
    SortData: TAlertDataType;
    Header: string;
    Code: Char;
    DefaultWidth: integer;
    Keys  : TSysCharSet;
  end;

var
  AlertColumnInfo: array[0..8] of TAlertColumnInfo =
   ((DisplayData: adtInfo; SortData: adtInfo;
       Header: 'Info'; Code: 'I'; DefaultWidth: 40;),
    (DisplayData: adtPatient; SortData: adtPatient;
       Header: 'Patient'; Code: 'P'; DefaultWidth: 195;),
    (DisplayData: adtLocation; SortData: adtLocation;
       Header: 'Location'; Code: 'L'; DefaultWidth: 75;),
    (DisplayData: adtUrgency; SortData: adtUrgency;
       Header: 'Urgency'; Code: 'U'; DefaultWidth: 95;),
    (DisplayData: adtDateTime; SortData: adtSortableDateTime;
       Header: 'Alert Date/Time'; Code: 'D'; DefaultWidth: 150;),
    (DisplayData: adtMessage; SortData: adtMessage;
       Header: 'Message'; Code: 'M'; DefaultWidth: 310;),
    (DisplayData: adtSurrogateFor; SortData: adtSurrogateFor;
       Header: 'Surrogate for'; Code: 'S'; DefaultWidth: 195;),
    (DisplayData: adtForwardedBy; SortData: adtForwardedBy;
       Header: 'Forwarded By/When'; Code: 'F'; DefaultWidth: 290;),
    (DisplayData: adtOrderingProvider; SortData: adtOrderingProvider;
       Header: 'Ordering Provider'; Code: 'O'; DefaultWidth: 195;));

const
  AliasString = ' -- ALIAS';
  SortDirection: array[boolean] of tSortDir = (DIR_BKWRD, DIR_FRWRD);
  iGap = 5;
  ONC = 'Order(s) needing clarification';
  sCodeClarification = '6'; // NSR#20110719
  sCodeFlagComment = '8';   // NSR#20110719

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer; var UserCancelled: Boolean);
{ displays patient selection dialog (with optional notifications), updates Patient object }
var
  frmPtSel: TfrmPtSel;
begin
  frmPtSel := TfrmPtSel.Create(Application);
  RPLProblem := False;
  try
    frmPtSel.AdjustFormSize(ShowNotif, FontSize); // Set initial form size
    FDfltSrc := DfltPtList;
    FDfltSrcType := Piece(FDfltSrc, U, 2);
    FDfltSrc := Piece(FDfltSrc, U, 1);
    if (IsRPL = '1') then // Deal with restricted patient list users.
      FDfltSrc := '';
    frmPtSel.fraPtSelOptns.SetDefaultPtList(FDfltSrc);
    if RPLProblem then
    begin
      frmPtSel.Release;
      frmPtSel := nil;
      Exit;
    end;
    Notifications.Clear;
    frmPtSel.FsortCol := -1;
    frmPtSel.AlertList;
    frmPtSel.ClearIDInfo;
    if (IsRPL = '1') then // Deal with restricted patient list users.
      frmPtSel.RPLDisplay; // Removes unnecessary components from view.
    frmPtSel.FUserCancelled := False;

    frmPtSel.pcProcNoti.TabIndex := 0; // always start with pending notifications

    frmPtSel.KeepBounds := False;
    frmPtSel.ShowModal;
    UserCancelled := frmPtSel.FUserCancelled;
  finally
    if Assigned(frmPtSel) then frmPtSel.Release;
  end;
end;

procedure TfrmPtSel.AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
{ Adjusts the initial size of the form based on the font used & if notifications should show. }
var
  SplitterTop, t1, t2, t3, btnW: Integer;

begin
  SetFormPosition(self);
  ResizeAnchoredFormToFont(self);
  FGridRowHeight := TextHeightByFont(Font.Handle, cmdSaveList.Caption) + 12;
  btnW := TextWidthByFont(Font.Handle, cmdSaveList.Caption) + 40;
  gpTop.ColumnCollection[3].Value := btnW;
  gpTop.RowCollection.BeginUpdate;
  try
    gpTop.RowCollection[0].Value := FGridRowHeight;
    gpTop.RowCollection[1].Value := FGridRowHeight;
    gpTop.RowCollection[3].Value := FGridRowHeight - 2; // Fixes cut-off of Save Settings button
  finally
    gpTop.RowCollection.EndUpdate;
  end;

  if ShowNotif then
    begin
      pnlDivide.Visible := True;
      lstvAlerts.Visible := True;
      pnlNotifications.Visible := True;
    end
  else
    begin
      pnlDivide.Visible := False;
      lstvAlerts.Visible := False;
      pnlNotifications.Visible := False;
    end;
  // SetFormPosition(self);
  ForceInsideWorkArea(Self);
  if frmFrame.EnduringPtSelSplitterPos <> 0 then
    SplitterTop := frmFrame.EnduringPtSelSplitterPos
  else
    SetUserBounds2(Name + '.' + sptVert.Name, SplitterTop, t1, t2, t3);
  if SplitterTop > 150 then
    gpTop.Height := SplitterTop;
  FNotificationBtnsAdjusted := False;
  AdjustButtonSize(cmdSaveList);
  AdjustButtonSize(cmdProcessInfo);
  AdjustButtonSize(cmdProcessAll);
  AdjustButtonSize(cmdProcess);
  AdjustButtonSize(cmdForward);
  AdjustButtonSize(cmdRemove);
  AdjustButtonSize(cmdComments);
  AdjustButtonSize(cmdDefer); // DRP
  AdjustNotificationButtons;
end;

procedure TfrmPtSel.SetCaptionTop;
{ Show patient list name, set top list to 'Select ...' if appropriate. }
var
  X: string;
begin
  X := '';
  lblPatient.Caption := 'Patients';
  if (not User.IsReportsOnly) then
    begin
      case fraPtSelOptns.SrcType of
        TAG_SRC_DFLT:
          lblPatient.Caption := 'Patients (' + FDfltSrc + ')';
        TAG_SRC_PROV:
          X := 'Provider';
        TAG_SRC_TEAM:
          X := 'Team';
        TAG_SRC_SPEC:
          X := 'Specialty';
        TAG_SRC_CLIN:
          X := 'Clinic';
        TAG_SRC_WARD:
          X := 'Ward';
        TAG_SRC_PCMM:
          X := 'PCMM Team'; // TDP - Added 5/27/2014 to handle PCMM team addition
        TAG_SRC_ALL: { Nothing }
          ;
      end; // case stmt
    end; // begin
  if Length(X) > 0 then
    with cboPatient do
      begin
        cboPatient.LockDrawing;
        try
          ClearIDInfo;
          ClearTop;
          Text := '';
          Items.Add('^Select a ' + X + '...');
          Items.Add(LLS_LINE);
          Items.Add(LLS_SPACE);
          cboPatient.InitLongList('');
        finally
          cboPatient.UnlockDrawing;
        end;
      end;
end;

{ List Source events: }

procedure TfrmPtSel.SetPtListTop(IEN: Int64);
{ Sets top items in patient list according to list source type and optional list source IEN. }
var
  NewTopList, updateDate: string;
  FirstDate, LastDate: string;
begin
  // NOTE:  Some pieces in RPC returned arrays are rearranged by ListPtByDflt call in rCore!
  IsRPL := User.IsRPL;
  if (IsRPL = '') then // First piece in ^VA(200,.101) should always be set (to 1 or 0).
    begin
      InfoBox('Patient selection list flag not set.', 'Incomplete User Information', MB_OK);
      RPLProblem := True;
      Exit;
    end;
  // FirstDate := 0; LastDate := 0; // Not req'd, but eliminates hint.
  // Assign list box TabPosition, Pieces properties according to type of list to be displayed.
  // (Always use Piece "2" as the first in the list to assure display of patient's name.)
  cboPatient.pieces := '2,3'; // This line and next: defaults set - exceptions modifield next.
  cboPatient.tabPositions := '20,28';
  if ((fraPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination')) then
    begin
      cboPatient.pieces := '2,3,4,5,9';
      cboPatient.tabPositions := '20,28,35,45';
    end;
  if ((fraPtSelOptns.SrcType = TAG_SRC_DFLT) and
    (FDfltSrcType = 'Ward')) or (fraPtSelOptns.SrcType = TAG_SRC_WARD) then
    cboPatient.tabPositions := '35';
  if ((fraPtSelOptns.SrcType = TAG_SRC_DFLT) and
    (AnsiStrPos(pChar(FDfltSrcType), 'Clinic') <> nil)) or (fraPtSelOptns.SrcType = TAG_SRC_CLIN) then
    begin
      cboPatient.pieces := '2,3,9';
      cboPatient.tabPositions := '24,45';
    end;
  NewTopList := IntToStr(fraPtSelOptns.SrcType) + U + IntToStr(IEN); // Default setting.
  if (fraPtSelOptns.SrcType = TAG_SRC_CLIN) then
    with fraPtSelOptns.cboDateRange do
      begin
        if ItemID = '' then
          Exit; // Need both clinic & date range.
        FirstDate := Piece(ItemID, ';', 1);
        LastDate := Piece(ItemID, ';', 2);
        NewTopList := IntToStr(fraPtSelOptns.SrcType) + U + IntToStr(IEN) + U + ItemID; // Modified for clinics.
      end;
  if NewTopList = fraPtSelOptns.LastTopList then
    Exit; // Only continue if new top list.
  fraPtSelOptns.LastTopList := NewTopList;
  cboPatient.LockDrawing;
  try
    ClearIDInfo;
    cboPatient.ClearTop;
    cboPatient.Text := '';
    if (IsRPL = '1') then // Deal with restricted patient list users.
    begin
      RPLJob := MakeRPLPtList(User.RPLList); // MakeRPLPtList is in rCore, writes global "B" x-ref list.
      if (RPLJob = '') then
      begin
        InfoBox('Assignment of valid OE/RR Team List Needed.', 'Unable to build Patient List', MB_OK);
        RPLProblem := True;
        Exit;
      end;
    end
    else
    begin
      case fraPtSelOptns.SrcType of
        TAG_SRC_DFLT:
          ListPtByDflt(cboPatient.Items);
        TAG_SRC_PROV:
          ListPtByProvider(cboPatient.Items, IEN);
        TAG_SRC_TEAM:
          ListPtByTeam(cboPatient.Items, IEN);
        TAG_SRC_SPEC:
          ListPtBySpecialty(cboPatient.Items, IEN);
        TAG_SRC_CLIN:
          ListPtByClinic(cboPatient.Items, fraPtSelOptns.cboList.ItemIEN, FirstDate, LastDate);
        TAG_SRC_WARD:
          ListPtByWard(cboPatient.Items, IEN);
        // TDP - Added 5/27/2014 to handle PCMM team addition
        TAG_SRC_PCMM:
          ListPtByPcmmTeam(cboPatient.Items, IEN);
        TAG_SRC_ALL:
          ListPtTop(cboPatient.Items);
      end;
    end;
    with fraPtSelOptns.cboList do
    begin
      if Visible then
      begin
        updateDate := '';
        if (fraPtSelOptns.SrcType <> TAG_SRC_PROV) and
          (Piece(Items[ItemIndex], U, 3) <> '') then
          updateDate := ' last updated on ' + Piece(Items[ItemIndex], U, 3);
        lblPatient.Caption := 'Patients (' + Text + updateDate + ')';
      end;
    end;
    if fraPtSelOptns.SrcType = TAG_SRC_ALL then
      lblPatient.Caption := 'Patients (All Patients)';
    with cboPatient do
      if ShortCount > 0 then
      begin
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
    cboPatient.Caption := lblPatient.Caption;
    cboPatient.InitLongList('');
  finally
    cboPatient.UnlockDrawing;
  end;
end;

{ Patient Select events: }

procedure TfrmPtSel.cboPatientEnter(Sender: TObject);
begin
  cmdOK.Default := True;
  if cboPatient.ItemIndex >= 0 then
    begin
      ShowIDInfo;
    end;
end;

procedure TfrmPtSel.cboPatientExit(Sender: TObject);
begin
  cmdOK.Default := False;
end;

procedure TfrmPtSel.cboPatientChange(Sender: TObject);
var
  sText: String;
  CharPos: Integer;

  procedure ShowMatchingPatients;
  begin
    with cboPatient do
      begin
        ClearIDInfo;
        if ShortCount > 0 then
          begin
            if ShortCount = 1 then
              begin
                ItemIndex := 0;
                ShowIDInfo;
              end;
            Items.Add(LLS_LINE);
            Items.Add(LLS_SPACE);
          end;
        InitLongList('');
      end;
  end;

begin
  if fTrimmer then
    Exit;

  with cboPatient do
  begin
    sText := cboPatient.Text;
    for CharPos := Length(sText) downto 1 do
      if CharInSet(sText[CharPos], [#0 .. #8]) or CharInSet(sText[CharPos], [#10 .. #31])then
        delete(sText, CharPos, 1);
    fTrimmer := True;
    cboPatient.Text := sText;
    TResponsiveGUI.ProcessMessages;
    fTrimmer := False;

    if fraPtSelOptns.IsLast5(Text) then
    begin
      if (IsRPL = '1') then
        ListPtByRPLLast5(Items, Text)
      else
        ListPtByLast5(Items, Text);
      ShowMatchingPatients;
    end
    else if fraPtSelOptns.IsFullSSN(Text) then
    begin
      if (IsRPL = '1') then
        ListPtByRPLFullSSN(Items, Text)
      else
        ListPtByFullSSN(Items, Text);
      ShowMatchingPatients;
    end;
  end;
end;

procedure TfrmPtSel.cboPatientKeyPause(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then // *DFN*
    begin
      ShowIDInfo;
    end
  else
    begin
      ClearIDInfo;
    end;
end;

procedure TfrmPtSel.cboPatientKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboPatient.Text = '') then
    cboPatient.ItemIndex := -1;
end;

procedure TfrmPtSel.cboPatientMouseClick(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then // *DFN*
    begin
      ShowIDInfo;
    end
  else
    begin
      ClearIDInfo;
    end;
end;

procedure TfrmPtSel.cboPatientDblClick(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then
    cmdOKClick(self); // *DFN*
end;

procedure TfrmPtSel.cboPatientNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  i: Integer;
  NoAlias, Patient: string;
  PatientList: TStringList;
begin
  NoAlias := StartFrom;
  with Sender as TORComboBox do
    if Items.Count > ShortCount then
      begin
        NoAlias := Piece(Items[Items.Count - 1], U, 1) + U + NoAlias;
        if Direction < 0 then
          NoAlias := Copy(NoAlias, 1, Length(NoAlias) - 1);
      end;
  if pos(AliasString, NoAlias) > 0 then
    NoAlias := Copy(NoAlias, 1, pos(AliasString, NoAlias) - 1);
  PatientList := TStringList.Create;
  try
    begin
      if (IsRPL = '1') then // Restricted patient lists uses different feed for long list box:
        setRPLPtList(PatientList, RPLJob, NoAlias, Direction)
      else
        begin
          setSubSetOfPatients(PatientList, NoAlias, Direction);
          for i := 0 to PatientList.Count - 1 do // Add " - Alias" to alias names:
            begin
              Patient := PatientList[i];
              // Piece 6 avoids display problems when mixed with "RPL" lists:
              if (Uppercase(Piece(Patient, U, 2)) <> Uppercase(Piece(Patient, U, 6))) then
                begin
                  SetPiece(Patient, U, 2, Piece(Patient, U, 2) + AliasString);
                  PatientList[i] := Patient;
                end;
            end;
        end;
      cboPatient.ForDataUse(PatientList);
    end;
  finally
    PatientList.Free;
  end;
end;

procedure TfrmPtSel.ClearIDInfo;
begin
  fraPtSelDemog.ClearIDInfo;
end;

procedure TfrmPtSel.ShowIDInfo;
begin
  fraPtSelDemog.ShowDemog(cboPatient.ItemID);
  EnsureDemographicsVisible;
end;

procedure TfrmPtSel.sptVertCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  Accept := (ClientHeight - NewSize > pnlNotifications.Height * 5) and
    (NewSize > (fraPtSelDemog.GetMinHeight + (FGridRowHeight * 3)));
end;

procedure TfrmPtSel.sptVertMoved(Sender: TObject);
begin
  inherited;
  gpTop.Realign;
end;

procedure TfrmPtSel.WMReadyAlert(var Message: TMessage);
begin
  ReadyAlert;
  message.Result := 0;
end;

{ Command Button events: }

procedure TfrmPtSel.cmdOKClick(Sender: TObject);
{ Checks for restrictions on the selected patient and sets up the Patient object. }
const
  DLG_CANCEL = False;
var
  DFN, NewDFN: string; // *DFN* - String since Patient DNF is string
  DateDied: TFMDateTime;
  AccessStatus: Integer;
begin
  if not(Length(cboPatient.ItemID) > 0) then // *DFN*
    begin
      InfoBox('A patient has not been selected.', 'No Patient Selected', MB_OK);
      Exit;
    end;
  NewDFN := cboPatient.ItemID; // *DFN*
  DFN := cboPatient.ItemID; // *DFN*
  if DupLastSSN(DFN) then // Check for, deal with duplicate patient data.
  begin
    if (trim(DFN) = '') then
      Exit
    else
      NewDFN := DFN;
  end;
  if not AllowAccessToSensitivePatient(NewDFN, AccessStatus) then
    Exit;
  DateDied := DateOfDeath(NewDFN);
  if (DateDied > 0) and (InfoBox('This patient died ' + FormatFMDateTime('mmm dd,yyyy hh:nn', DateDied) + CRLF +
    'Do you wish to continue?', 'Deceased Patient', MB_YESNO or MB_DEFBUTTON2) = ID_NO) then
    Exit;
  SelectPtByDFN(NewDFN);
end;

procedure TfrmPtSel.SelectPtByDFN(aDFN:String);
begin
  // 9/23/2002: Code used to check for changed pt. DFN here, but since same patient could be
  // selected twice in diff. Encounter locations, check was removed and following code runs
  // no matter; in fFrame code then updates Encounter display if Encounter.Location has changed.
  // NOTE: Some pieces in RPC returned arrays are modified/rearranged by ListPtByDflt call in rCore!
  Patient.DFN := aDFN; // The patient object in uCore must have been created already!
  Encounter.Clear;
  Changes.Clear; // An earlier call to ReviewChanges should have cleared this.
  if (fraPtSelOptns.SrcType = TAG_SRC_CLIN) and (fraPtSelOptns.cboList.ItemIEN > 0) and
    IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4)) then // Clinics, not by default.
    begin
      Encounter.Location := fraPtSelOptns.cboList.ItemIEN;
      with cboPatient do
        Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
    end
  else if (fraPtSelOptns.SrcType = TAG_SRC_DFLT) and (DfltPtListSrc = 'C') and
    IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4)) then
    with cboPatient do // "Default" is a clinic.
      begin
        Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 10), 0); // Piece 10 is ^SC( location IEN in this case.
        Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
      end
  else if ((fraPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination') and
    (Copy(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 3), 1, 2) = 'Cl')) and
    (IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 8))) then
    with cboPatient do // "Default" combination, clinic pt.
      begin
        Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 7), 0); // Piece 7 is ^SC( location IEN in this case.
        Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 8));
      end
  else if Patient.Inpatient then // Everything else:
    begin
      Encounter.Inpatient := True;
      Encounter.Location := Patient.Location;
      Encounter.DateTime := Patient.AdmitTime;
      Encounter.VisitCategory := 'H';
    end;
  if User.IsProvider then
    Encounter.Provider := User.DUZ;

  FUserCancelled := False;
  FOKClicked := True;
{$IFDEF PTSEL_HISTORY}
  ptSelHistory.Insert(0,cboPatient.Text); // PaPI
{$ENDIF}
  FExpectedClose := True;
  Close;
end;

procedure TfrmPtSel.cmdCancelClick(Sender: TObject);
begin
  if ((not Assigned(Patient)) or (Patient.DFN = '')) and ScreenReaderActive then
  begin
    if InfoBox('No patient selected. Close CPRS Yes or No?', 'Confirmation',
      MB_YESNO or MB_ICONQUESTION) <> IDYES then
        Exit;
  end;
  // Leave Patient object unchanged
  FUserCancelled := True;
  FExpectedClose := True;
  Close;
end;

procedure TfrmPtSel.cmdCommentsClick(Sender: TObject);
var
  tmpCmt: TStringList;
  idx: integer;

begin
  idx := lstvAlerts.SelectedIndex;
  if FAlertsNotReady or (idx < 0) then
    Exit;
  inherited;
  tmpCmt := TStringList.Create;
  try
    tmpCmt.Text := AlertData(idx, adtComment);
    LimitStringLength(tmpCmt, 74);
    tmpCmt.Insert(0, StringOfChar('-', 74));
    tmpCmt.Insert(0, AlertData(idx, adtMessage));
    tmpCmt.Insert(0, AlertData(idx, adtDateTime));
    tmpCmt.Insert(0, AlertData(idx, adtPatient));
    ReportBox(tmpCmt, 'Forwarded by: ' + AlertData(idx, adtForwardedBy), True);
    lstvAlerts.SetFocus;
  finally
    tmpCmt.Free;
  end;
end;

procedure TfrmPtSel.cmdDeferClick(Sender: TObject);
var
  aResult: string;
  idx: integer;

begin
  idx := lstvAlerts.SelectedIndex;
  if FAlertsNotReady or (idx < 0) then
    Exit;

  with TfrmDeferDialog.Create(self) do
    try
      Title := 'Defer Patient Notification';
      with TStringList.Create do
        try
          AddStrings(CreateSubItems(idx));
          while Count > 7 do
            Delete(Count - 1);
          Description := Text;
        finally
          Free;
        end;
      {
        Set more/better properties on the dialog here depending on SMART requirements
      }
      if Execute then
        begin
          CallVistA('ORB3UTL DEFER', [User.DUZ, AlertData(idx, adtXQAID),
            DeferUntilFM], aResult);
          if aResult = '1' then
            begin
              MessageDlg('Notification successfully deferred.', mtInformation, [mbOk], 0);
              lstvAlerts.ItemSelected[idx] := False;
              FAlertData.Delete(idx);
              lstvAlerts.Items.Count := FAlertData.Count;
              lstvAlerts.Invalidate;
            end
          else
            begin
              MessageDlg(Copy(aResult, pos(aResult, '^') + 1, Length(aResult)), mtError, [mbOk], 0);
            end
        end;
    finally
      Free;
    end;
end;

procedure TfrmPtSel.cmdProcessClick(Sender: TObject);
var
  AFollowUp, i, LongTextResult: Integer;
  enableclose: Boolean;
  ADFN, X, RecordID, XQAID, LongText, AlertMsg: string; // *DFN*
  LongTextBtns: TStringList;
  aSmartParams, aEmptyParams: TStringList;
  lastUpdate: TDateTime;
  ProcessLongTextAlerts: boolean;
  oldCursor: TCursor;
  ctrlList: TObjectList<TControl>;
  lastFocus: TWinControl;

  procedure DisableControls(parent: TWinControl);
  var
    j: integer;
    child: TWinControl;

  begin
    for j := 0 to parent.ControlCount - 1 do
    begin
      if parent.Controls[j] is TWinControl then
      begin
        child := parent.Controls[j] as TWinControl;
        DisableControls(child);
        if child.Enabled and child.Visible and ((child is TORComboBox) or
          (child is TCustomButton) or (child is TCustomListView) or
          (child is TButtonControl) or (child is TCustomListBox) or
          (child is TCustomEdit) or (child is TCustomStaticText)) then
        begin
          ctrlList.Add(child);
          child.Enabled := False;
        end;
      end;
    end;
  end;

  procedure StartProcessing;
  begin
    lastFocus := ActiveControl;
    lstvAlerts.BeginChangingStates;
    pbarNotifications.Visible := False;
    btnCancelProcessing.Visible := False;
    oldCursor := Screen.Cursor;
    Screen.Cursor := crAppStart; // Hour Glass with Arrow
    ctrlList := TObjectList<TControl>.Create(False);
    FProcessingAlerts := True;
    DisableControls(Self);
    fraPtSelOptns.Enabled := False;
    FDisablePageControlTabStops := True;
  end;

  procedure EndProcessing;
  var
    j: integer;

  begin
    FDisablePageControlTabStops := False;
    fraPtSelOptns.Enabled := True;
    for j := 0 to ctrlList.Count -1 do
      ctrlList[j].Enabled := True;
    ctrlList.Free;
    btnCancelProcessing.Visible := False;
    pbarNotifications.Visible := False;
    Screen.Cursor := oldCursor;
    FProcessingAlerts := False;
    lstvAlerts.EndChangingStates;
    ActiveControl := lastFocus;
  end;

begin
  TResponsiveGUI.ProcessMessages;
  if FAlertsNotReady then
    Exit;
  if lstvAlerts.SelCount <= 0 then
    Exit;
  enableclose := False;
  Notifications.Clear;
  StartProcessing;
  try
    with lstvAlerts do
    begin
      ProcessLongTextAlerts := True;
      for i := 0 to FAlertData.Count - 1 do
      begin
        if lstvAlerts.ItemSelected[i] then
        begin
          XQAID := AlertData(i, adtXQAID);
          if Copy(XQAID, 1, 6) = 'TIUERR' then
            continue;
          if (Copy(XQAID, 1, 3) = 'TIU') or (Piece(XQAID, ',', 1) = 'OR') then
          begin
            ProcessLongTextAlerts := False;
            break;
          end;
        end;
      end;

      pbarNotifications.Max := SelCount;
      pbarNotifications.Position := 0;
      if ScreenReaderActive and (SelCount > 1) then
      begin
        GetScreenReader.Speak('Processing ' + SelCount.ToString + ' Notifications');
        TResponsiveGUI.ProcessMessages;
      end;

      lastUpdate := Now;
      for i := 0 to FAlertData.Count - 1 do
        if lstvAlerts.ItemSelected[i] then
        { Items[i].Selected    =  Boolean TRUE if item is selected
          "   .Caption     =  Info flag ('I')
          "   .SubItems[0] =  Patient ('ABC,PATIE (A4321)')
          "   .    "   [1] =  Patient location ('[2B]')
          "   .    "   [2] =  Alert urgency level ('HIGH, Moderate, low')
          "   .    "   [3] =  Alert date/time ('2002/12/31@12:10')
          "   .    "   [4] =  Alert message ('New order(s) placed.')
          "   .    "   [5] =  Forwarded by/when
          "   .    "   [6] =  XQAID ('OR,66,50;1416;3021231.121024')
          'TIU6028;1423;3021203.09')
          "   .    "   [7] =  Remove without processing flag ('YES')
          "   .    "   [8] =  Forwarding comments (if applicable) }
        begin
          pbarNotifications.Position := pbarNotifications.Position + 1;

          if MilliSecondsBetween(Now, lastUpdate) > 250 then
          begin
            pbarNotifications.ProgressText := IntToStr(pbarNotifications.Position) + ' of ' + IntToStr(SelCount);
            if not pbarNotifications.Visible then
            begin
              btnCancelProcessing.Visible := True;
              btnCancelProcessing.Enabled := True;
              btnCancelProcessing.Height := pnlDivide.Height - 2;
              btnCancelProcessing.Top := 1;
              btnCancelProcessing.SetFocus;
              pbarNotifications.Top := 1;
              pbarNotifications.Height := pnlDivide.Height - 2;
              pbarNotifications.Visible := True;
            end;
            TResponsiveGUI.ProcessMessages(True);
            if not FProcessingAlerts then
            begin
              enableclose := False;
              Notifications.Clear;
              if ScreenReaderActive then
                GetScreenReader.Speak('Canceling Notification Processing');
              break;
            end;
            LastUpdate := Now;
          end;

          XQAID := AlertData(i, adtXQAID);
          AlertMsg := AlertData(i, adtMessage);
          RecordID := AlertData(i, adtPatient) + ': ' + AlertData(i, adtMessage) +
            '^' + XQAID;
          // RecordID := patient: alert message^XQAID  ('ABC,PATIE (A4321): New order(s) placed.^OR,66,50;1416;3021231.121024')
          if AlertData(i, adtInfo) = 'I' then
            DeleteAlert(XQAID)
          else if AlertData(i, adtInfo) = 'L' then
            begin
              if Piece(XQAID, ',', 1) = 'OR' then
                ADFN := Piece(XQAID, ',', 2) // *DFN*
              else
                ADFN := '';
              LongText := LoadNotificationLongText(XQAID);
              if ProcessLongTextAlerts and (ADFN = '') then
              begin
                LongTextBtns := TStringList.Create();
                try
                  LongTextBtns.Add('Copy to Clipboard');
                  LongTextBtns.Add('Dismiss Alert');
                  LongTextBtns.Add('Keep Alert^true');

                  LongTextResult := 0;
                  while (LongTextResult=0) do
                  begin
                    LongTextResult := uInfoBoxWithBtnControls.DefMessageDlg(LongText,
                        mtConfirmation, LongTextBtns, Alertmsg, false);
                    if (LongTextResult = 0) then ClipBoard.astext := LongText
                  end;
                finally
                  LongTextBtns.Free;
                end;
                if (LongTextResult = 1) then DeleteAlert(XQAID)
              end
              else
              begin
                aSmartParams := TStringList.Create;
                try
                  aSmartParams.Text := LongText;
                  Notifications.Add(ADFN, NF_LONG_TEXT_ALERT, RecordID, AlertMsg,
                    aSmartParams, False);
                  enableClose := True;
                finally
                  FreeAndNil(aSmartParams);
                end;
              end;
            end
          else if Piece(XQAID, ',', 1) = 'OR' then
          // OR,16,50;1311;2980626.100756
          begin
            //check if smart alert and if so show notificationprocessor dialog
            try
              aSmartParams := TStringList.Create;
              CallVistA('ORB3UTL GET NOTIFICATION', [Piece(RecordID, '^', 2)],
                aSmartParams);
              If (aSmartParams.Values['PROCESS AS SMART NOTIFICATION'] = '1') then
              begin
                aSmartParams.Add(SMART_ALERT_INFO);
                aSmartParams.AddStrings(CreateSubItems(i));
                ADFN := Piece(XQAID, ',', 2); // *DFN*
                AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1),
                  ',', 3), 0);
                Notifications.Add(ADFN, AFollowUp, RecordID,
                  AlertData(i, adtDateTime), aSmartParams);
                enableclose := True;
              end
              else
              begin
                ADFN := Piece(XQAID, ',', 2); // *DFN*
                AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1), ',', 3), 0);
                Notifications.Add(ADFN, AFollowUp, RecordID,
                  AlertData(i, adtDateTime), aSmartParams);
                enableclose := True;
              end;
            finally
              FreeAndNil(aSmartParams);
            end;

          end
          else if Copy(XQAID, 1, 6) = 'TIUERR' then
            InfoBox(Piece(RecordID, U, 1) + sLineBreak + sLineBreak +
              'The CPRS GUI cannot yet process this type of alert.  Please use List Manager.',
              'Unable to Process Alert', MB_OK)
          else if Copy(XQAID, 1, 3) = 'TIU' then
          // TIU6028;1423;3021203.09
          begin
            X := GetTIUAlertInfo(XQAID);
            if Piece(X, U, 2) <> '' then
            begin
              aEmptyParams := TStringList.Create();
              try
                ADFN := Piece(X, U, 2); // *DFN*
                AFollowUp := StrToIntDef(Piece(Piece(X, U, 3), ';', 1), 0);
                Notifications.Add(ADFN, AFollowUp,
                  RecordID + '^^' + Piece(X, U, 3), '', aEmptyParams);
                enableclose := True;
              finally
                FreeAndNil(aEmptyParams);
              end;
            end
            else
              DeleteAlert(XQAID);
          end
          else // other alerts cannot be processed
            InfoBox('This alert cannot be processed by the CPRS GUI.' + sLineBreak +
                    'Please use VistA to process this alert.',
              AlertData(i, adtPatient) + ': ' + AlertData(i, adtMessage), MB_OK);
        end;
    end;
  finally
    EndProcessing;
    if enableclose then
    begin
      FExpectedClose := True;
      Close;
    end
    else
    begin
      // Update notification list:
      AlertList;
      // display alerts sorted according to parameter settings:
      FsortCol := -1; // CA - display alerts in correct sort
      FormShow(Sender);
      if (FAlertData.Count = 0) or (lstvAlerts.SelCount <= 0) then
        ShowButts(False);
    end;
  end;
end;

procedure TfrmPtSel.cmdSaveListClick(Sender: TObject);
begin
  fraPtSelOptns.cmdSaveListClick(Sender);
end;

function TfrmPtSel.CreateSubItems(Index: integer): TStringList;
var
  s, data: string;
  col: integer;

begin
  FTempSubItems.Clear;
  if (Index >= 0) and (Index < FAlertData.Count) then
  begin
    s := FAlertData[Index];
    for col := 1 to high(AlertColumnInfo) do
    begin
      data := Piece(s, U, ord(AlertColumnInfo[col].DisplayData) + 1);
      FTempSubItems.Add(data);
    end;
  end;
  Result := FTempSubItems;
end;

procedure TfrmPtSel.cmdProcessInfoClick(Sender: TObject);
// Select and process all items that are information only in the lstvAlerts list box.
var
  i: Integer;
begin
  if FAlertsNotReady then
    Exit;
  if FAlertData.Count = 0 then
    Exit;
  if InfoBox('You are about to process all your INFORMATION alerts.' + CRLF
    + 'These alerts will not be presented to you for individual' + CRLF
    + 'review and they will be permanently removed from your' + CRLF
    + 'alert list.  Do you wish to continue?',
    'Warning', MB_YESNO or MB_ICONWARNING) = IDYES then
    begin
      lstvAlerts.BeginChangingStates;
      try
        lstvAlerts.SelectAllItems(False);
        for i := 0 to FAlertData.Count - 1 do
          if AlertData(i, adtInfo) = 'I' then
            lstvAlerts.ItemSelected[i] := True;
        if lstvAlerts.SelCount > 0 then
          cmdProcessClick(self);
      finally
        lstvAlerts.EndChangingStates;
      end;
      ShowButts(False);
    end;
end;

procedure TfrmPtSel.cmdProcessAllClick(Sender: TObject);
begin
  if FAlertsNotReady or (lstvAlerts.Items.Count < 1) then
    Exit;
  lstvAlerts.BeginChangingStates;
  try
    lstvAlerts.SelectAllItems(True);
    cmdProcessClick(self);
  finally
    lstvAlerts.EndChangingStates;
  end;
  ShowButts(False);
end;

procedure TfrmPtSel.lstvAlertsData(Sender: TObject; Item: TListItem);
var
  i: integer;

begin
  inherited;
  if assigned(Item) and (Item.Index < FAlertData.Count) then
  begin
    Item.Caption := AlertData(Item.Index, AlertColumnInfo[0].DisplayData);
    CreateSubItems(Item.Index);
    // do NOT call SubItems.Assign or SubItems.AddStrings
    for i := 0 to FTempSubItems.Count - 1 do
      Item.SubItems.Add(FTempSubItems[i]);
  end;
end;

procedure TfrmPtSel.lstvAlertsDataStateChange(Sender: TObject; StartIndex,
  EndIndex: Integer; OldState, NewState: TItemStates);
begin
  if lstvAlerts.ChangingStates then
    exit;
  FAlertsNotReady := True;
  PostMessage(Handle, UM_MISC, 0, 0);
end;

procedure TfrmPtSel.lstvAlertsDblClick(Sender: TObject);
begin
  if lstvAlerts.ChangingStates then
    exit;
  cmdProcessClick(self);
end;

procedure TfrmPtSel.cmdForwardClick(Sender: TObject);
var
  I: Integer;
  Alert: string;

begin
  if FAlertsNotReady then Exit;
  try
    if lstvAlerts.SelCount <= 0 then Exit;
    for I := 0 to FAlertData.Count - 1 do
    begin
      if lstvAlerts.ItemSelected[i] then
      begin
        try
          if not CanForwardAlerts([i]) then
          begin
            ShowMessage('Forward alert is not allowable' + CRLF + CRLF +
              AlertData(i, adtMessage));
          end else begin
            Alert := AlertData(i, adtXQAID) + U +
              AlertData(i, adtPatient) + ': ' +
              AlertData(i, adtMessage);
            ForwardAlertTo(Alert);
          end;
        finally
          lstvAlerts.ItemSelected[i] := False;
        end;
      end;
    end;
  finally
    if lstvAlerts.SelCount <= 0 then ShowButts(False);
  end;
end;

procedure TfrmPtSel.cmdRemoveClick(Sender: TObject);
var
  i: Integer;
  modified: boolean;

begin
  if FAlertsNotReady or (lstvAlerts.SelCount <= 0) then
    Exit;
  modified := False;
  for i := 0 to FAlertData.Count - 1 do
    if lstvAlerts.ItemSelected[i] then
    begin
      if AlertData(i, adtRemovable) = '1' then // remove flag enabled
      begin
        DeleteAlertforUser(AlertData(i, adtXQAID));
        modified := True;
      end
      else
        InfoBox('This alert cannot be removed.', AlertData(i, adtPatient)
          + ': ' + AlertData(i, adtMessage), MB_OK);
    end;
  if modified then
  begin
    AlertList;
    FsortCol := -1; // CA - display alerts in correct sort
    FormShow(Sender); // CA - display alerts in correct sort
    if (FAlertData.Count = 0) or (lstvAlerts.SelCount <= 0) then
      ShowButts(False);
  end;
end;

procedure TfrmPtSel.FormDestroy(Sender: TObject);
var
  col, cVal: Integer;
  aString: string;

begin
  SaveUserBounds(self);
  frmFrame.EnduringPtSelSplitterPos := gpTop.Height;

  aString := '';
  for col := 0 to lstvAlerts.Columns.Count - 1 do
  begin
    cVal := lstvAlerts.Columns[col].Width;
    if cVal > TINY_COLS_MAX_WIDTH then
      SetPiece(aString, ',', col + 1, IntToStr(cVal));
  end;
  frmFrame.EnduringPtSelColumns := aString;

////////////////////////////////////////////////////////////////////////////////
  if assigned(frmAlertsProcessed) then
    begin
      frmAlertsProcessed.Parent := nil;
      FreeAndNil(frmAlertsProcessed);
    end;
////////////////////////////////////////////////////////////////////////////////
  FreeAndNil(FTempSubItems);
  FreeAndNil(FAlertData);
end;

procedure TfrmPtSel.FormResize(Sender: TObject);
begin
  inherited;
  FNotificationBtnsAdjusted := False;
  AdjustButtonSize(cmdSaveList);
  AdjustButtonSize(cmdProcessInfo);
  AdjustButtonSize(cmdProcessAll);
  AdjustButtonSize(cmdProcess);
  AdjustButtonSize(cmdForward);
  AdjustButtonSize(cmdComments);
  AdjustButtonSize(cmdRemove);
  AdjustButtonSize(cmdDefer);
  AdjustNotificationButtons;
  EnsureDemographicsVisible;
end;

procedure TfrmPtSel.ShowDisabledButtonTexts;
begin
  if ScreenReaderActive then
    begin
      txtCmdProcess.Visible := not cmdProcess.Enabled;
      txtCmdRemove.Visible := not cmdRemove.Enabled;
      txtCmdForward.Visible := not cmdForward.Enabled;
      txtCmdComments.Visible := not cmdComments.Enabled;
      txtCmdDefer.Visible := not cmdDefer.Enabled;
    end;

  if assigned(frmAlertsProcessed) then
      frmAlertsProcessed.stxtDateRange.TabStop := ScreenReaderActive;
end;

procedure TfrmPtSel.RPLDisplay;
begin
  // Make unneeded components invisible:
  cmdSaveList.Visible := False;
  fraPtSelOptns.Visible := False;
end;

procedure TfrmPtSel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (IsRPL = '1') then // Deal with restricted patient list users.
    try
      KillRPLPtList(RPLJob); // Kills server global data each time.
    except
      on E: Exception do
        ShowMessage('Closing Patient Selector Dialog:'+CRLF + E.Message);
    end;
  // (Global created by MakeRPLPtList in rCore.)
end;

procedure TfrmPtSel.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if not FExpectedClose then
  begin
    // For Alt-F4 or the X (Close) in the upper right hand corner of the dialog
    FExpectedClose := True;
    cmdCancelClick(Sender);
  end;
end;

procedure TfrmPtSel.FormCreate(Sender: TObject);
begin
  inherited;
  DefaultButton := cmdOK;
  FAlertsNotReady := False;
  FExpectedClose := False;
  ShowDisabledButtonTexts;
  FBuildColumns := True;
  with fraPtSelOptns do
  begin
    SetCaptionTopProc := SetCaptionTop;
    SetPtListTopProc := SetPtListTop;
  end;
  if ScreenReaderActive then
  begin
    fraPtSelDemog.ToggleMemo;
    EnsureDemographicsVisible;
  end;

////////////////////////////////////////////////////////////////////////////////
  setFormParented(getProcessedAlertsList,pnlPaCanvas);
  frmAlertsProcessed.ParentSelector := self.Handle;
////////////////////////////////////////////////////////////////////////////////
  FAlertData := TStringList.Create;
  FTempSubItems := TStringList.Create;
  FBeforeDisabledColor := ColorToRGB(lstvAlerts.Color);
end;

procedure TfrmPtSel.cboPatientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('D')) and (ssCtrl in Shift) then
    begin
      Key := 0;
      fraPtSelDemog.ToggleMemo;
      EnsureDemographicsVisible;
    end;
end;

function ConvertDate(
  var
  thisList: TStringList;
  listIndex: Integer): string;
{
  Convert date portion from yyyy/mm/dd to mm/dd/yyyy
}
var
  // thisListItem: TListItem;
  thisDateTime: string[16];
  tempDt: string;
  tempYr: string;
  tempTime: string;
  newDtTime: string;
  k: byte;
  piece1: string;
  piece2: string;
  piece3: string;
  piece4: string;
  piece5: string;
  piece6: string;
  piece7: string;
  piece8: string;
  piece9: string;
  piece10: string;
  piece11: string;
begin
  piece1 := '';
  piece2 := '';
  piece3 := '';
  piece4 := '';
  piece5 := '';
  piece6 := '';
  piece7 := '';
  piece8 := '';
  piece9 := '';
  piece10 := '';
  piece11 := '';

  piece1 := Piece(thisList[listIndex], U, 1);
  piece2 := Piece(thisList[listIndex], U, 2);
  piece3 := Piece(thisList[listIndex], U, 3);
  piece4 := Piece(thisList[listIndex], U, 4);
  // piece5 := Piece(thisList[listIndex],U,5);
  piece6 := Piece(thisList[listIndex], U, 6);
  piece7 := Piece(thisList[listIndex], U, 7);
  piece8 := Piece(thisList[listIndex], U, 8);
  piece9 := Piece(thisList[listIndex], U, 9);
  piece10 := Piece(thisList[listIndex], U, 1);

  thisDateTime := ShortString(Piece(thisList[listIndex], U, 5));

  tempYr := '';
  for k := 1 to 4 do
    tempYr := tempYr + string(thisDateTime[k]);

  tempDt := '';
  for k := 6 to 10 do
    tempDt := tempDt + string(thisDateTime[k]);

  tempTime := '';
  // Use 'Length' to prevent stuffing the control chars into the date when a trailing zero is missing
  for k := 11 to Length(thisDateTime) do // 16 do
    tempTime := tempTime + string(thisDateTime[k]);

  newDtTime := '';
  newDtTime := newDtTime + tempDt + '/' + tempYr + tempTime;
  piece5 := newDtTime;

  Result := piece1 + U + piece2 + U + piece3 + U + piece4 + U + piece5 + U + piece6 + U + piece7 + U + piece8 + U + piece9 + U + piece10 + U + piece11;
end;

procedure TfrmPtSel.AlertList;
var
  i, col, cWidth: Integer;
  cur: TCursor;
  s, inDateStr, srtDate, comment: string;

const
  FORWARD_BY_TXT = 'Forwarded by: ';
  FORWARD_BY_LEN = Length(FORWARD_BY_TXT);
  FORWARD_COMMENT = 'Fwd Comment: ';

begin
  cur := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    FAlertData.Clear;
    LoadNotifications(FAlertData);
    i := 0;
    while (i < FAlertData.Count) do
    begin
      if (i > 0) and (Copy(FAlertData[i], 1, FORWARD_BY_LEN) = FORWARD_BY_TXT) then  // faster than Piece
      begin
        s := FAlertData[i - 1];
        SetPiece(s, U, ord(adtForwardedBy) + 1, Piece(FAlertData[i], U, 2));
        comment := Piece(FAlertData[i], U, 3);
        if Length(comment) > 0 then
          SetPiece(s, U, ord(adtComment) + 1, FORWARD_COMMENT + comment);
        FAlertData[i - 1] := s;
        FAlertData.Delete(i);
      end
      else
      begin
        s := FAlertData[i];
        inDateStr := Piece(s, U, ord(adtDateTime) + 1);
        srtDate := ((Piece(Piece(inDateStr, '/', 3), '@', 1)) + '/' + Piece(inDateStr, '/', 1) +
                 '/' + Piece(inDateStr, '/', 2) + '@' + Piece(inDateStr, '@', 2));
        SetPiece(s, U, ord(adtSortableDateTime) + 1, srtDate);
        FAlertData[i] := s;
        Inc(i);
      end;
    end;
    lstvAlerts.Items.Count := FAlertData.Count;
    lstvAlerts.SelectAllItems(False);
    if FAlertData.Count > 0 then
      lstvAlerts.Items[0].MakeVisible(FALSE);
    lstvAlerts.Invalidate;
   finally
    Screen.Cursor := cur;
  end;

  if FBuildColumns then
  begin
    try
      lstvAlerts.Columns.Clear;
      for col := low(AlertColumnInfo) to high(AlertColumnInfo) do
        with AlertColumnInfo[col] do
        begin
          cWidth := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', col + 1), 0);
          if cWidth <= TINY_COLS_MAX_WIDTH then
            cWidth := DefaultWidth;
          with lstvAlerts.Columns.Add do
          begin
            Caption := Header;
            Width := cWidth;
          end;
          if Code <> #0 then
            Keys := [Code, LowerCase(Code)[1]];
        end;
      lstvAlerts.ResetTinyColumns;
    finally
      FBuildColumns := False;
    end;
  end;
end;

procedure TfrmPtSel.btnCancelProcessingClick(Sender: TObject);
begin
  inherited;
  FProcessingAlerts := False;
  btnCancelProcessing.Enabled := False;
end;

procedure TfrmPtSel.lstvAlertsColumnClick(Sender: TObject; Column: TListColumn);
const
  Mask = LVIS_FOCUSED or LVIS_SELECTED;

var
  i, max, State, NewState, ImageIdx: integer;
  s, code: string;

begin
  if lstvAlerts.ChangingStates or (not assigned(Column)) then
    exit;
  max := lstvAlerts.Items.Count - 1;
  if max > (FAlertData.Count - 1) then
    max := FAlertData.Count - 1;

  for i := 0 to max do
  begin
    State := ListView_GetItemState(lstvAlerts.Handle, i, Mask);
    if (State and Mask) = Mask then
      code := 'B' // Both
    else if (State and LVIS_SELECTED) = LVIS_SELECTED then
      code := 'S' // Selected
    else if (State and LVIS_FOCUSED) = LVIS_FOCUSED then
      code := 'F' // Focused
    else
      code := '';
    s := FAlertData[i];
    if Piece(s, U, ord(adtItemState) + 1) <> code then
    begin
      SetPiece(s, U, ord(adtItemState) + 1, code);
      FAlertData[i] := s;
    end;
  end;

  if FsortCol = Column.Index then
    FsortAscending := not FsortAscending;

  if FsortAscending then
    FsortDirection := 'F'
  else
    FsortDirection := 'R';

  FsortCol := Column.Index;

  for i := 0 to lstvAlerts.Columns.Count - 1 do
  begin
    if i = FSortCol then
    begin
      if FsortAscending then
        ImageIdx := IMG_ASCENDING
      else
        ImageIdx := IMG_DESCENDING
    end
    else
      ImageIdx := IMG_NONE;
    lstvAlerts.Columns[i].ImageIndex := ImageIdx;
  end;

  if AlertColumnInfo[FsortCol].SortData = adtSortableDateTime then
    SortByPiece(FAlertData, U, ord(adtSortableDateTime) + 1,
      SortDirection[FsortAscending])
  else
    SortByPieces(FAlertData, U, [ord(AlertColumnInfo[FsortCol].SortData) + 1,
      ord(adtSortableDateTime) + 1], [SortDirection[FsortAscending],
      SortDirection[not FsortAscending]]);

  for i := 0 to max do
  begin
    code := Piece(FAlertData[i], U, ord(adtItemState) + 1) + ' ';
    case code[1] of
      'B': NewState := Mask;
      'S': NewState := LVIS_SELECTED;
      'F': NewState := LVIS_FOCUSED
      else NewState := 0;
    end;
    State := ListView_GetItemState(lstvAlerts.Handle, i, Mask);
    if State <> NewState then
      ListView_SetItemState(lstvAlerts.Handle, i, NewState, Mask);
  end;

  lstvAlerts.Invalidate;

  // Set the Notifications sort method to last-used sort-type
  // ie., user clicked on which column header last use of CPRS?
  if AlertColumnInfo[FsortCol].Code <> #0 then
   rCore.SetSortMethod(AlertColumnInfo[FsortCol].Code, FsortDirection);
end;

//function TfrmPtSel.DupLastSSN(const DFN: string): Boolean;
function TfrmPtSel.DupLastSSN(var DFN: string): Boolean;

  function IsInpatient(ALocation: string): boolean;
  begin
    Result := Length(ALocation) > 0;
  end;

  function NeedToShowLocation: boolean;
  begin
    Result := fraPtSelOptns.radAll.Visible and fraPtSelOptns.radAll.Checked;;
  end;

var
  I: Integer;
  AStringList: TStringList;
  AIsInPatient: Boolean;
  ADFN, ALocation, AAttending, APrimaryCareProvider, ALastVisitLocation: string;
  ALastVisitDate: string;
const
  fmtResultError = 'SubsetOfPatientsWithSimilarSSNs returns incorrect data.' +
    CRLF + CRLF + 'Search for DFN %d returns' + CRLF + ' %s';
begin
  Result := False;
  AStringList := TStringList.Create;
  try
    if SubsetOfPatientsWithSimilarSSNs(AStringList, DFN) > 0 then
    begin
      Result := True;
      AStringList.Delete(0);
      for I := AStringList.Count - 1 downto 0 do
      begin
        if Piece(AStringList[i], U, 1) <> '1' then
        begin
          AStringList.Delete(I);
        end else begin
          ADFN := Piece(AStringList[I], U, 2);
          ALastVisitLocation := Piece(AStringList[I], U, 8);
          ALastVisitDate := Piece(AStringList[I], U, 9);
          ALocation := Piece(AStringList[I], U, 6);
          AIsInpatient := IsInpatient(ALocation);
          if AIsInPatient then
          begin
            AAttending := Piece(AStringList[I], U, 10);
            APrimaryCareProvider := '';
          end else begin
            AAttending := '';
            APrimaryCareProvider := Piece(AStringList[I], U, 7);
          end;
          if NeedToShowLocation then
          begin
            if ALocation = '' then
              ALocation := ' ';
          end else begin
            ALocation := '';
          end;

          AStringList[I] := (Piece(AStringList[I], U, 2) + U +
            Piece(AStringList[I], U, 3) + U + FormatFMDateTimeStr('mmm dd,yyyy',
            Piece(AStringList[I], U, 4)) + U + Piece(AStringList[I], U, 5)) + U
            + ALocation + U + Trim(AAttending + APrimaryCareProvider) + U +
            ALastVisitDate + U + ALastVisitLocation;
        end;
      end;

      case AStringList.Count of
        0: ;
        1: if Piece(AStringList[0], U, 1) <> DFN then
            MessageDlg(Format(fmtResultError, [DFN, AStringList[0]]), mtError,
              [mbOk], 0);
      else
        // Call form to get user's selection from expanded duplicate pt. list
        DFN := uSimilarNames.getItemIDFromList(AStringList);
      end;
    end;

  finally
    FreeAndNil(AStringList);
  end;
end;

procedure TfrmPtSel.EnsureDemographicsVisible;
var
  ht: integer;
begin
  ht := fraPtSelDemog.GetMinHeight + (FGridRowHeight * 3);
  if gpTop.Height < ht then
  begin
    gpTop.Height := ht;
    gpTop.Realign;
  end;
end;

procedure TfrmPtSel.lstFlagsClick(Sender: TObject);
begin
  { if lstFlags.ItemIndex >= 0 then
    ShowFlags(lstFlags.ItemID); }
end;

procedure TfrmPtSel.lstFlagsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lstFlagsClick(self);
end;

procedure TfrmPtSel.lstvAlertsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if lstvAlerts.ChangingStates then
    exit;
  // SelCount is not accurate in this event because lstvAlerts is now OwnerData
  FAlertsNotReady := True;
  PostMessage(Handle, UM_MISC, 0, 0);
end;

function TfrmPtSel.CanForwardAlerts(AItemIndices: TArray<Integer>): Boolean;
// Returns true if every alert in the array ca be forwarded, false if not
var
  S: string; // NSR#2010719 - Do not forward flagged alerts
  I: integer;
begin
  if Length(AItemIndices) <= 0 then Exit(False);
  for I in AItemIndices do
  begin
    if (I < 0) or (I >= FAlertData.Count) then Exit(False);
    S := Trim(Piece(Piece(AlertData(I, adtXQAID), ';', 1), ',', 3));
    Result :=
      (Pos(ONC, AlertData(I, adtMessage)) <> 1) and
      (S <> sCodeClarification) and
      (S <> sCodeFlagComment);  // NSR#2010719
      // ONC: 'Order(s) needing Clarification'
    if not Result then Exit;
  end;
  Result := True;
end;

procedure TfrmPtSel.ShowButts(AValue: Boolean);
var
  I: integer;
  ASelectedItems: TArray<Integer>;
begin
  cmdProcess.Enabled := AValue;
  cmdRemove.Enabled := AValue;
  case lstvAlerts.SelCount of
    0: ASelectedItems := [];
    1: ASelectedItems := [lstvAlerts.SelectedIndex];
  else
    ASelectedItems := [];
    for I := 0 to FAlertData.Count - 1 do
      if lstvAlerts.ItemSelected[I] then
        ASelectedItems := ASelectedItems + [I];
  end;
  cmdForward.Enabled := AValue and CanForwardAlerts(ASelectedItems);
  mnuForward.Enabled := AValue and cmdForward.Enabled;
  cmdComments.Enabled := AValue and (lstvAlerts.SelCount = 1) and
    (AlertData(lstvAlerts.SelectedIndex, adtComment) <> '');
  cmdDefer.Enabled := AValue and (lstvAlerts.SelCount = 1);
  ShowDisabledButtonTexts;
end;

procedure TfrmPtSel.lstvAlertsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
begin
  InfoTip := AlertData(Item.Index, adtComment);
end;

procedure TfrmPtSel.lstvAlertsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  col: integer;

{
  //KW
  508: Allow non-sighted users to sort Notifications using Ctrl + <key>
  Numbers in case stmnt are ASCII values for character keys.
}
begin
  if lstvAlerts.ChangingStates or FAlertsNotReady then
    Exit;
  if lstvAlerts.Focused then
  begin
    case Key of
      VK_RETURN:
        cmdProcessClick(Sender); // Process all selected alerts
    else
      begin
        if (ssCtrl in Shift) then
          for col := 0 to lstvAlerts.Columns.Count - 1 do
            if CharInSet(Char(Key), AlertColumnInfo[col].Keys) then
            begin
              lstvAlertsColumnClick(Sender, lstvAlerts.Columns[col]);
              break;
            end;
      end;
    end;
  end;
end;

procedure TfrmPtSel.FormShow(Sender: TObject);
{
  //KW
  Sort Alerts by last-used method for current user
}
var
  sortResult: string;
  sortMethod: string;
  col: integer;

begin
  if lstvAlerts.Items.Count = 0 then
    ActiveControl := cboPatient;
  sortResult := rCore.GetSortMethod;
  sortMethod := Piece(sortResult, U, 1);
  if sortMethod = '' then
    sortMethod := 'D';
  FsortDirection := Piece(sortResult, U, 2);
  if FsortDirection = 'F' then
    FsortAscending := True
  else
    FsortAscending := False;

  for col := 0 to lstvAlerts.Columns.Count - 1 do
    if CharInSet(sortMethod[1], AlertColumnInfo[col].Keys) then
    begin
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[col]);
      break;
    end;
end;

function TfrmPtSel.AlertData(Index: integer; DataType: TAlertDataType): string;
begin
  Result := Piece(FAlertData[Index], U, ord(DataType) + 1);
end;

// hds7397- ge 2/6/6 sort and display date/time column correctly - as requested
procedure TfrmPtSel.ReadyAlert;
begin
  if lstvAlerts.SelCount <= 0 then
    ShowButts(False)
  else
    ShowButts(True);
  FAlertsNotReady := False;
end;

procedure TfrmPtSel.AdjustButtonSize(pButton: TButton);
const
  Gap = 5;
var
  AWidth, AHeight: integer;
begin
  AWidth := TextWidthByFont(pButton.Font.Handle, pButton.Caption);
  if pButton.Width < AWidth + Gap + Gap then // CQ2737  GE
  begin
    FNotificationBtnsAdjusted := True;
    pButton.Width := AWidth + Gap + Gap; // CQ2737  GE
  end;

  AHeight := TextHeightByFont(pButton.Font.Handle, pButton.Caption);
  if pButton.Height < AHeight + Gap then // CQ2737  GE
    pButton.Height := AHeight + Gap; // CQ2737  GE
end;

procedure TfrmPtSel.AdjustNotificationButtons;
const
  Gap = 10;
  BigGap = 40;
  // reposition buttons after resizing eliminate overlap.
begin
  if FNotificationBtnsAdjusted then
    begin
      cmdProcessAll.Left := (cmdProcessInfo.Left + cmdProcessInfo.Width + Gap);
      cmdProcess.Left := (cmdProcessAll.Left + cmdProcessAll.Width + Gap);
      cmdForward.Left := (cmdProcess.Left + cmdProcess.Width + Gap);
      cmdComments.Left := (cmdForward.Left + cmdForward.Width + Gap);
      cmdRemove.Left := (cmdComments.Left + cmdComments.Width + BigGap);
      cmdDefer.Left := (cmdRemove.Left + cmdRemove.Width + Gap);
    end;
end;

procedure TfrmPtSel.WMSElectPatient(var Message: TMessage);
var
  s: String;
begin
  if Message.WParamLo <> 0 then
    begin
      s := IntToStr(Message.WParamLo);
      SelectPtByDFN(s);
      message.Result := 0;
    end;
end;

procedure TfrmPtSel.pcProcNotiChange(Sender: TObject);
begin
  inherited;
  if pcProcNoti.ActivePage = tsProcessedAlertsForm  then
    begin
      if assigned(frmAlertsProcessed) then
        begin
          frmAlertsProcessed.setFontSize(Application.MainForm.Font.Size);
          FEndDate := Trunc(FEndDate) + 0.235959; // End of the day adjustment
          frmAlertsProcessed.LoadProcessedAlerts(True); // Load Processed Alert Table
        end;
    end;
end;

procedure TfrmPtSel.pcProcNotiChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  AllowChange := not FProcessingAlerts;
end;

procedure TfrmPtSel.pcProcNotiResize(Sender: TObject);
begin
  inherited;
  if assigned(frmAlertsProcessed) then
    frmAlertsProcessed.pnlGroupBy.Width := cmdSaveList.Width + 4;
end;

procedure TfrmPtSel.lstvAlertsAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  inherited;
  if (not Item.Selected) and (Stage = cdPrePaint) and (cdsSelected in State) then
  begin
    lstvAlerts.Canvas.Brush.Color := FBeforeDisabledColor;
    lstvAlerts.Canvas.FillRect(Item.DisplayRect(drBounds));
  end;
end;

procedure TfrmPtSel.lstvAlertsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  s: String;

begin
  inherited;
  // looking for keyphrase in the message
  if change = ctState then
    begin
      s := trim(piece(piece(AlertData(Item.Index, adtXQAID),';',1),',',3)); // NSR#20110719
      cmdForward.Enabled :=
        (pos(ONC, AlertData(Item.Index, adtMessage)) <> 1) and
        (s <> sCodeClarification) and (s <> sCodeFlagComment);
      mnuForward.Enabled := cmdForward.Enabled;
      // NSR 20110719 - disabled for Codes 8, 6  see
    end;
end;

{ TPtSelPageControl }

function TPageControl.CanFocus: Boolean;
begin
  if (Owner is TfrmPtSel) and (TfrmPtSel(Owner).FDisablePageControlTabStops) then
    Result := False
  else
    Result := inherited CanFocus;
end;

{ TProgressBar }

constructor TProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TProgressBar.Destroy;
begin
  if GetCaptureControl = Self then
    SetCaptureControl(nil);
  FCanvas.Free;
  inherited Destroy;
end;

procedure TProgressBar.Paint;
const
  Gap = 2;

var
  x, y, x1, y1, len, size, i, j: integer;

begin
  if FProgressText <> '' then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Assign(Font);
    Canvas.Font.Style := [fsBold];
    len := length(FProgressText);
    size := - Gap;
    for i := 1 to len do
      inc(size, Canvas.TextExtent(FProgressText[i]).cx + Gap);
    x := (Width - size) div 2;
    y := (Height - Canvas.TextExtent(FProgressText).cy) div 2;
    for i := 1 to len do
    begin
      Canvas.Font.Color := clBtnFace;
      for j := 0 to 8 do
      begin
        x1 := x;
        y1 := y;
        case j of
          0 .. 2: inc(x1);
          4 .. 6: dec(x1);
        end;
        case j of
          2 .. 4: inc(y1);
          0, 6, 7: dec(y1);
        end;
        if j = 8 then
          Canvas.Font.Color := clWindowText;
        Canvas.TextOut(x1, y1, FProgressText[i]);
      end;
      inc(x, Canvas.TextExtent(FProgressText[i]).cx + Gap);
    end;
  end;
end;

procedure TProgressBar.SetProgressText(const Value: String);
begin
  if FProgressText <> Value then
  begin
    FProgressText := Value;
    invalidate;
  end;
end;

procedure TProgressBar.WMPaint(var Message: TWMPaint);
var
  DoRelease: boolean;

begin
  inherited;
  if not(csDestroying in ComponentState) then
  begin
    Canvas.Lock;
    try
      DoRelease := (Message.DC = 0);
      if DoRelease then
        Canvas.Handle := GetWindowDC(Handle)
      else
        Canvas.Handle := Message.DC;
      try
        Paint;
      finally
        if DoRelease then
          ReleaseDC(Handle, Canvas.Handle);
        Canvas.Handle := 0;
      end;
    finally
      Canvas.Unlock;
    end;
  end;
end;

{ TCaptionListView }

procedure TCaptionListView.BeginChangingStates;
begin
  inc(FChangingStateCount);
  if FChangingStateCount = 1 then
  begin
    FBeforeChangingStateCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    FBeforeChangingStateEnabled := Enabled;
    Enabled := False;
  end;
end;

function TCaptionListView.ChangingStates: Boolean;
begin
  Result := (FChangingStateCount > 0);
end;

procedure TCaptionListView.EndChangingStates;
begin
  if FChangingStateCount > 0 then
  begin
    dec(FChangingStateCount);
    if FChangingStateCount = 0 then
    begin
      Screen.Cursor := FBeforeChangingStateCursor;
      Enabled := FBeforeChangingStateEnabled;
    end;
  end;
end;

function TCaptionListView.GetItemSelected(Index: integer): Boolean;
begin
  if (Index < 0) or (Index >= Items.Count) then
    Result := False
  else
    Result := (ListView_GetItemState(Handle, Index, LVIS_SELECTED) and LVIS_SELECTED) <> 0;
end;

procedure TCaptionListView.SelectAllItems(Selected: Boolean);
begin
  BeginChangingStates;
  try
    SetItemSelected(-1, Selected);
  finally
    EndChangingStates;
  end;
end;

function TCaptionListView.SelectedIndex: integer;
begin
  Result := ListView_GetNextItem(Handle, -1, LVNI_ALL or LVNI_SELECTED);
end;

procedure TCaptionListView.SetItemSelected(Index: integer;
  const Value: Boolean);
var
  Data: Integer;

begin
  if Value then
    Data := LVIS_SELECTED
  else
    Data := 0;
  ListView_SetItemState(Handle, Index, Data, LVIS_SELECTED);
end;

end.
