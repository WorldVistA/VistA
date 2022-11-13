unit fOptions;
{------------------------------------------------------------------------------
Update History

    2016-02-15: NSR#20081008 (CPRS Notification Alert Processing Improvement)
-------------------------------------------------------------------------------}

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, ORCtrls, OrFn, Dialogs, ORDtTmRng,
  fBAOptionsDiagnoses, uBAGlobals, fBase508Form, VA508AccessibilityManager,
  fAutoSz, Vcl.CheckLst, Messages, uConst, fOptionsSurrogate;

type

  TTabSheet = class(ComCtrls.TTabSheet)
  private
    FColor: TColor;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(aOwner: TComponent); override;
  end;

  TColorBox = Class(Extctrls.TColorBox)
   private
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure AdjustSizeOfSelf;
  End;

  TfrmOptions = class(TfrmAutoSz)
    pnlBottom: TPanel;
    pagOptions: TPageControl;
    tsCoverSheet: TTabSheet;
    tsNotifications: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    tsOrderChecks: TTabSheet;
    tsListsTeams: TTabSheet;
    lblCoverReminderDesc: TMemo;
    lblCoverReminders: TStaticText;
    lblCoverDaysDesc: TMemo;
    lblCoverDays: TStaticText;
    btnCoverDays: TButton;
    btnCoverReminders: TButton;
    imgCoverDays: TImage;
    imgCoverReminders: TImage;
    lblPatientSelectionDesc: TMemo;
    lblPatientSelection: TStaticText;
    btnPatientSelection: TButton;
    btnPersonalLists: TButton;
    imgPatientSelection: TImage;
    lblOrderChecksDesc: TLabel;
    lblOrderChecks: TStaticText;
    imgOrderChecks: TImage;
    lblTeamsDesc: TMemo;
    lblTeams: TStaticText;
    btnTeams: TButton;
    lvwNotifications: TCaptionListView;
    lvwOrderChecks: TCaptionListView;
    lblOrderChecksView: TLabel;
    btnCombinations: TButton;
    lblOtherParameters: TStaticText;
    imgOtherParameters: TImage;
    lblOtherParametersDesc: TMemo;
    btnOtherParameters: TButton;
    tsNotes: TTabSheet;
    lblNotesNotesDesc: TMemo;
    lblNotesNotes: TStaticText;
    btnNotesNotes: TButton;
    lblNotesTitles: TStaticText;
    lblNotesTitlesDesc: TMemo;
    btnRequiredFields: TButton;
    imgNotesNotes: TImage;
    imgTeams: TImage;
    tsCprsReports: TTabSheet;
    lblReports: TStaticText;
    memReports: TMemo;
    imgReports: TImage;
    btnReports: TButton;
    lblReport1: TStaticText;
    memReport1: TMemo;
    btnReport1: TButton;
    btnDiagnoses: TButton;
    tsGraphs: TTabSheet;
    lblGraphSettings: TStaticText;
    imgGraphSettings: TImage;
    btnGraphSettings: TButton;
    lblGraphViews: TStaticText;
    imgGraphViews: TImage;
    btnGraphViews: TButton;
    memGraphSettings: TMemo;
    memGraphViews: TMemo;
    lblReport2: TStaticText;
    memReport2: TMemo;
    imgReport1: TImage;
    imgReport2: TImage;
    imgRequiredFields: TImage;
    tsSurrogates: TTabSheet;
    pnlSurrogatesTop: TPanel;
    StaticText2: TStaticText;
    Bevel2: TBevel;
    txtSurrogatesManagement: TStaticText;
    imgSurrogates: TImage;
    pnlNotificationsList: TPanel;
    Panel2: TPanel;
    lblNotificationView: TLabel;
    lblNotifications: TStaticText;
    bvlNotifications: TBevel;
    imgNotifications: TImage;
    lblNotificationsOptions: TStaticText;
    chkNotificationsFlagged: TCheckBox;
    btnProcessedAlertsSettings: TButton;
    pnlSurrogates: TPanel;
    pnlNotificationTools: TPanel;
    Button1: TButton;
    Button2: TButton;
    btnNotificationsRemove: TButton;
    tsCopyPaste: TTabSheet;
    GroupBox1: TGroupBox;
    pnlCPMain: TPanel;
    Panel1: TPanel;
    lblCP: TStaticText;
    CopyPasteOptions: TCheckListBox;
    lbCPhighLight: TStaticText;
    cpHLColor: TColorBox;
    GroupBox2: TGroupBox;
    pblCPLCS: TPanel;
    CPLCSToggle: TCheckBox;
    pnlCPLCsSub: TPanel;
    CPLcsMemo: TMemo;
    CPLCSCOLOR: TColorBox;
    CPLCSIDENT: TCheckListBox;
    CPLCSLimit: TEdit;
    CPLcsLimitText: TStaticText;
    lblTextColor: TStaticText;
    pnlCPOptions: TPanel;
    lblCopyPaste: TStaticText;
    ImgCopyPaste: TImage;
    cbkCopyPaste: TCheckBox;
    bvlCopyPasteTitle: TBevel;
    imgNotes: TImage;
    btnNotesTitles: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Bevel3: TBevel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Bevel4: TBevel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Bevel6: TBevel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Bevel7: TBevel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Bevel8: TBevel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    pnlTIU: TPanel;
    Panel38: TPanel;
    Bevel9: TBevel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    pnlNoteTop: TPanel;
    Panel43: TPanel;
    Bevel10: TBevel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Bevel1: TBevel;
    StaticText5: TStaticText;
    Panel49: TPanel;
    Panel50: TPanel;
    Memo3: TMemo;
    Panel51: TPanel;
    Panel42: TPanel;
    Panel52: TPanel;
    bvlOrderChecks: TBevel;
    Panel53: TPanel;
    Panel54: TPanel;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    bvlCoverDays: TBevel;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    Panel61: TPanel;
    Panel62: TPanel;
    bvlCoverReminders: TBevel;
    Panel63: TPanel;
    Panel64: TPanel;
    Panel65: TPanel;
    Panel66: TPanel;
    Panel67: TPanel;
    bvlOtherParameters: TBevel;
    Panel68: TPanel;
    Panel69: TPanel;
    Panel70: TPanel;
    Panel71: TPanel;
    Panel72: TPanel;
    bvlPatientSelection: TBevel;
    Panel73: TPanel;
    Panel74: TPanel;
    Panel75: TPanel;
    Panel76: TPanel;
    Panel77: TPanel;
    bvlTeams: TBevel;
    Panel78: TPanel;
    Panel79: TPanel;
    Panel80: TPanel;
    pnlNotifications: TPanel;
    Panel82: TPanel;
    Panel83: TPanel;
    Panel84: TPanel;
    Panel85: TPanel;
    Panel17: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCoverDaysClick(Sender: TObject);
    procedure btnCoverRemindersClick(Sender: TObject);
    procedure btnOtherParametersClick(Sender: TObject);
    procedure btnPatientSelectionClick(Sender: TObject);
    procedure btnPersonalListsClick(Sender: TObject);
    procedure btnTeamsClick(Sender: TObject);
    procedure btnNotificationsRemoveClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure chkNotificationsFlaggedClick(Sender: TObject);
    procedure lvwNotificationsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvwNotificationsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvwNotificationsCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvwNotificationsDblClick(Sender: TObject);
    procedure btnCombinationsClick(Sender: TObject);
    procedure btnNotesNotesClick(Sender: TObject);
    procedure btnNotesTitlesClick(Sender: TObject);
    procedure btnReportsClick(Sender: TObject);
    procedure btnReport1Click(Sender: TObject);
    procedure lvwNotificationsEnter(Sender: TObject);
    procedure lvwNotificationsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnDiagnosesClick(Sender: TObject);
    procedure btnGraphSettingsClick(Sender: TObject);
    procedure btnGraphViewsClick(Sender: TObject);
    procedure pagOptionsEnter(Sender: TObject);
    procedure pagOptionsDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure btnRequiredFieldsClick(Sender: TObject);
    procedure btnProcessedAlertsSettingsClick(Sender: TObject);
    procedure pagOptionsChange(Sender: TObject);
    procedure cbkCopyPasteClick(Sender: TObject);
    procedure CPOptionsClickCheck(Sender: TObject);
    procedure CPOptionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; aState: TOwnerDrawState);
   procedure cpHLColorChange(Sender: TObject);
    procedure CPLCSLimitKeyPress(Sender: TObject; var Key: Char);
    procedure CPLCSToggleClick(Sender: TObject);
    procedure CPLCSCOLORChange(Sender: TObject);
    procedure CPLCSIDENTClickCheck(Sender: TObject);
    procedure CPLCSLimitChange(Sender: TObject);
    procedure pagOptionsChanging(Sender: TObject; var AllowChange: Boolean);
  private
    { Private declarations }
    FdirtyNotifications: boolean;  // used to determine edit changes to Notifications
    FdirtyOrderChecks: boolean;    // used to determine edit changes to Order Checks
    FdirtyOtherStuff: boolean;     // used to determine edit changes to misc settings
    FuseCheckBoxes: boolean;
    FsortCol: integer;
    FsortAscending: boolean;
    FLastClickedItem: TListItem;
    FGiveMultiTabMessage: boolean;
    CopyPasteColor: TColor;  //Color used for copy paste
    LCSIdentColor: TColor;  //Color used for copy paste LCS
    FfrmOptionsSurrogate: TfrmOptionsSurrogate; // Use InitSurrogatesTab to set
    procedure Offset(var topnum: integer; topoffset: integer; var leftnum: integer; leftoffset: integer);
    procedure LoadNotifications;
    procedure LoadOrderChecks;
    procedure ApplyNotifications;
    procedure ApplyOrderChecks;
    procedure ApplyOtherStuff;
    Procedure ApplyCopyPaste;
    procedure CheckApply;
    procedure LoadListView(aListView: TListView; aList: TStrings);
    procedure ChangeOnOff(aListView: TListView; aListItem: TListItem);
    procedure SurrogateUpdated(Sender: TObject);
    function  CopyPasteChanged: Boolean;
    procedure LoadCopyPaste();
    function VerifySaveCondition(Sender: TObject): Integer;
    function VerifyIfTabCanChange: Boolean;
    procedure InitSurrogatesTab;
    procedure Init508;
  end;

var
  frmOptions: TfrmOptions;

procedure DialogOptions(var actiontype: Integer);
procedure setFormParented(aForm:TForm; aParent:TWinControl;anAlign: TAlign = alClient);

implementation

uses fOptionsDays, fOptionsReminders,
     fOptionsPatientSelection, fOptionsLists, fOptionsTeams, fOptionsCombinations,
     fOptionsOther, fOptionsNotes, fOptionsTitles, fOptionsReportsCustom, fOptionsReportsDefault,
     fGraphs, fGraphSettings, fGraphProfiles, rGraphs, uGraphs,
     rOptions, rCore, uCore, uOptions, UBACore, fFrame, UITypes, VA508AccessibilityRouter,
     fOptionsTIUTemplates, fOptionsProcessedAlerts,
     VAUtils;

{$R *.DFM}
procedure setFormParented(aForm:TForm; aParent:TWinControl;anAlign: TAlign = alClient);
begin
  if aForm.Parent <> aParent then
    begin
      aForm.BorderStyle := bsNone;
      aForm.Parent := aParent;
      aForm.Align := anAlign;
      aForm.Menu := nil;
      aForm.Show;
    end;
end;

type
  TRule = class
  public
    IEN: string;
    OriginalValue: string;
    ItemText: string;
end;

procedure DialogOptions(var actiontype: Integer);
// create the form and make in modal, return an action
const
  PixelGapBetweenButtons = 5;
var
  frmOptions: TfrmOptions;
begin
  frmOptions := TfrmOptions.Create(Application);
  try
    with frmOptions do
    begin
      with pagOptions do
      begin
        tsCoverSheet.TabVisible := false;
        tsNotifications.TabVisible := false;
        tsOrderChecks.TabVisible := false;
        tsListsTeams.TabVisible := false;
        case actiontype of
        1: begin
             tsCoverSheet.TabVisible := true;
           end;
        2: begin
             tsNotifications.TabVisible := true;
           end;
        3: begin
             tsOrderChecks.TabVisible := true;
           end;
        4: begin
             tsListsTeams.TabVisible := true;
           end;
        else
           begin
             tsCoverSheet.TabVisible := true;
             tsNotifications.TabVisible := true;
             tsOrderChecks.TabVisible := true;
             tsListsTeams.TabVisible := true;
             ActivePage := tsCoverSheet;
             memReports.Text := 'Change the default date range and occurrence limits for all reports on ' +
                               'the CPRS Reports tab (excluding health summary reports) .';
             memReport1.Text := 'Change the individual date range and occurrence limits for each report on ' +
                               'the CPRS Reports tab (excluding health summary reports) .';
             btnReports.caption := 'Set All Reports...';
             btnReport1.caption := 'Set Individual Reports...';
             if User.IsReportsOnly then // For "Reports Only" users.
               begin
                 tsCoverSheet.TabVisible := false;
                 tsNotifications.TabVisible := false;
                 tsOrderChecks.TabVisible := false;
                 tsListsTeams.TabVisible := false;
                 tsNotes.TabVisible := false;
                 if (not User.ToolsRptEdit) then
                 begin
                   btnOK.visible := false;
                   btnApply.visible := false;
                   btnCancel.caption := 'Close';
                 end;
               end;
             if (not User.ToolsRptEdit) then // For users with Reports settings edit parameter not set.
               begin
                 memReports.Text := 'View the default date range and occurrence limits for all reports on ' +
                                   'the CPRS Reports tab (excluding health summary reports) .';
                 memReport1.Text := 'View the individual date range and occurrence limits for each report on ' +
                                   'the CPRS Reports tab (excluding health summary reports) .';
                 btnReports.caption := 'View All Report Settings...';
                 btnReport1.caption := 'View Individual Report Settings...';
               end;
           end;
        end;
      end;
      actiontype := 0;
      ResizeAnchoredFormToFont(frmOptions);
      btnApply.Left := pagOptions.Left + pagOptions.Width - btnApply.Width;
      btnCancel.Left := btnApply.Left - btnCancel.Width - PixelGapBetweenButtons;
      btnOK.Left := btnCancel.Left - btnOK.Width - PixelGapBetweenButtons;
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptions.Release;
  end;
end;

procedure TfrmOptions.Init508;
begin
  txtSurrogatesManagement.TabStop := ScreenReaderActive;
end;

procedure TfrmOptions.InitSurrogatesTab;
// NSR20071216 AA 2016-01-23 ------------------------------------------- begin
begin
  if not Assigned(FfrmOptionsSurrogate) then begin
    Application.CreateForm(TfrmOptionsSurrogate, FfrmOptionsSurrogate);
    setFormParented(FfrmOptionsSurrogate, pnlSurrogates);
    ResizeAnchoredFormToFont(FfrmOptionsSurrogate);
    FFrmOptionsSurrogate.OnChange := SurrogateUpdated;
  end;
end;
// NSR20071216 AA 2016-01-23 --------------------------------------------- end

procedure TfrmOptions.FormCreate(Sender: TObject);
// initialize form
var
  I:integer;
  FTIUParam: Integer;
begin
  AutoSizeDisabled := True; // This avoids weird moving issues on the tabs, and eliminates severe sluggishness
  LoadNotifications;
  LoadOrderChecks;
  FdirtyNotifications := false;
  FdirtyOrderChecks := false;
  FdirtyOtherStuff := false;

  //Retrieve the Copy Paste options
  if frmFrame.CPAppMon.Enabled then
   LoadCopyPaste;
  for i := 0 to pagOptions.PageCount -1 do
  begin
    if pagOptions.Pages[i].Name = 'tsCopyPaste' then
    begin
    pagOptions.Pages[i].TabVisible := frmFrame.CPAppMon.Enabled;
    break;
    end;
  end;
  tsCopyPaste.TabVisible := frmFrame.CPAppMon.Enabled; // SDS 5/19/2017

  CheckApply;

  if (Encounter.Provider = 0) and not IsCIDCProvider(User.DUZ) then
      btnDiagnoses.Enabled := False;
  FGiveMultiTabMessage := ScreenReaderSystemActive;

  if PagOptions.ActivePage = tsSurrogates then InitSurrogatesTab; // NSR20071216 AA 2016-01-23
  FTIUParam := StrToIntDef(systemParameters.AsType<String>('tmRequiredFldsOff'), 1);
  pnlTIU.Visible := (FTIUParam = 0);
  Init508;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
// cleanup creation of objects
var
  i: integer;
begin
  FreeAndNil(FfrmOptionsSurrogate);
  for i := 0 to lvwOrderChecks.Items.Count - 1 do
    lvwOrderChecks.Items.Item[i].SubItems.Objects[2].free;
  for i := 0 to lvwNotifications.Items.Count - 1 do
    lvwNotifications.Items.Item[i].SubItems.Objects[2].free;
end;

procedure TfrmOptions.btnCoverDaysClick(Sender: TObject);
// display Date Range Defaults on Cover Sheet
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsDays(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnCoverRemindersClick(Sender: TObject);
// display Clinical Reminder Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsReminders(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnOtherParametersClick(Sender: TObject);
// display Other Parameters Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, 40, leftsize, 40);
  DialogOptionsOther(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnPatientSelectionClick(Sender: TObject);
// display Patient Selection Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsPatientSelection(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnPersonalListsClick(Sender: TObject);
// display Personal Lists Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsLists(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnTeamsClick(Sender: TObject);
// display Team Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsTeams(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnNotificationsRemoveClick(Sender: TObject);
// confirm before clearing notifications
begin
  if InfoBox('CAUTION: This will clear all the current notifications you have pending.'
    + #13 + 'If you say YES, these changes will take place immediately.'
    + #13 + 'Are you sure you want to erase all of your notifications?',
    'Warning', MB_YESNO or MB_ICONWARNING) = IDYES then
    begin
      rpcClearNotifications;
    end;
end;

procedure TfrmOptions.Offset(var topnum: integer; topoffset: integer; var leftnum: integer; leftoffset: integer);
// get positions to display dialog
begin
  // use these top and left values to display dialog
  topnum := Top;
  leftnum := Left;
  topnum := topnum + topoffset;
  if topnum < 0 then topnum := 0;
  leftnum := leftnum + leftoffset;
  if leftnum < 0 then leftnum := 0;
end;

procedure TfrmOptions.pagOptionsEnter(Sender: TObject);
begin
  if FGiveMultiTabMessage then // CQ#15483
  begin
    FGiveMultiTabMessage := FALSE;
    GetScreenReader.Speak('Multi Tab Form');
  end;
end;

procedure TfrmOptions.SurrogateUpdated(Sender: TObject);
begin
  CheckApply;
end;

procedure TfrmOptions.btnApplyClick(Sender: TObject);
// save actions without exiting
Var
  Verified: Integer;
begin
  if FdirtyNotifications then
    ApplyNotifications;
  if FdirtyOrderChecks then
    ApplyOrderChecks;
  if FdirtyOtherStuff then
    ApplyOtherStuff;
  if CopyPasteChanged then begin
    Verified := VerifySaveCondition(sender);
    if Verified = -1 then
     ApplyCopyPaste
    else if Verified = mrOk then
      exit;
  end;
  if Assigned(FfrmOptionsSurrogate) then
  begin
    if FfrmOptionsSurrogate.ApplyChanges then // NSR20071216 2016-01-14 AA -- begin
    begin
      if Sender = btnOK then begin
        ModalResult := mrOk;
        Close;
      end;
    end
    else begin
      pagOptions.ActivePage := tsSurrogates; // NSR20071216 2016-01-14 AA ---------- end  \
      ModalResult := mrNone;
    end;
  end;
  CheckApply;
end;

procedure TfrmOptions.LoadNotifications;
// load Notification tab
var
  processedAlertsInfo,
  notifydefaults, flag, enableerase: string;
  aResults: TStringList;
begin
  aResults := TStringList.Create;
  try
    rpcGetNotifications(aResults);
    LoadListView(lvwNotifications, aResults);
  finally
    FreeAndNil(aResults);
  end;
  lvwNotificationsColumnClick(lvwNotifications, lvwNotifications.Column[0]); // make sure sorted
  notifydefaults := rpcGetNotificationDefaults;
  flag := Piece(notifydefaults, '^', 2);
  enableerase := Piece(notifydefaults, '^', 3);
  chkNotificationsFlagged.Checked := flag = '1';
  btnNotificationsRemove.Enabled := enableerase = '1';

  processedAlertsInfo := pieces(notifydefaults,U,4,5);
  setProcessedAlertsInfo(ProcessedAlertsInfo); // save values in unit fOptionsProcessedAlerts
end;

procedure TfrmOptions.LoadOrderChecks;
// load Order Check tab
var
  aResults: TStringList;
begin
  aResults := TStringList.Create;
  try
    rpcGetOrderChecks(aResults);
    LoadListView(lvwOrderChecks, aResults);
  lvwOrderChecks.Checkboxes := true;
  finally
    FreeAndNil(aResults);
end;
end;

procedure TfrmOptions.ApplyNotifications;
// save Notification changes
var
  i: Integer;
  newonoff: string;
  aRule: TRule;
  aList: TStringList;
begin
  aList := TStringList.Create;
  try
  for i := 0 to lvwNotifications.Items.Count - 1 do
  begin
    aRule := TRule(lvwNotifications.Items.Item[i].SubItems.Objects[2]);
    if lvwNotifications.Items.Item[i].SubItems[1] <> 'Mandatory' then
    begin
      newonoff := Uppercase(lvwNotifications.Items.Item[i].SubItems[0]);
      if aRule.OriginalValue <> newonoff then
      begin
        //***Show508Message(aRule.IEN + ' ' + aRule.OriginalValue + ' ' + newonoff);
        aList.Add(aRule.IEN + '^' + newonoff);
        aRule.OriginalValue := lvwNotifications.Items.Item[i].SubItems[0];
      end;
    end;
  end;
  rpcSetNotifications(aList);
  FdirtyNotifications := false;
  finally
    aList.free;
  end;
end;

procedure TfrmOptions.ApplyOrderChecks;
// save Order Check changes
var
  i: Integer;
  newonoff: string;
  aRule: TRule;
  aList: TStringList;
begin
  aList := TStringList.Create;
  try
  for i := 0 to lvwOrderChecks.Items.Count - 1 do
  begin
    aRule := TRule(lvwOrderChecks.Items.Item[i].SubItems.Objects[2]);
    newonoff := Uppercase(lvwOrderChecks.Items.Item[i].SubItems[0]);
    if aRule.OriginalValue <> newonoff then
    begin
      aList.Add(aRule.IEN + '^' + newonoff);
      aRule.OriginalValue := lvwOrderChecks.Items.Item[i].SubItems[0];
    end;
  end;
  rpcSetOrderChecks(aList);
  FdirtyOrderChecks := false;
  finally
    aList.free;
  end;
end;

procedure TfrmOptions.ApplyOtherStuff;
// save other changes
var
  aString: string;
begin
  aString := '';
  if chkNotificationsFlagged.Checked then
    aString := aString + '^1'
  else
    aString := aString + '^0';
  rpcSetOtherStuff(aString+'^^'+getProcessedAlertsInfo);
  ProcessedAlertsSessionInfo := '';
  FdirtyOtherStuff := false;
end;

procedure TfrmOptions.CheckApply;
// determine if Apply button is enabled
// RDD: There may be an issue here with CopyPasteChanged. It seems to always return true for me.
begin
  btnApply.Enabled :=
    FdirtyOrderChecks or
    FdirtyNotifications or
    FdirtyOtherStuff or
    CopyPasteChanged or
    (Assigned(FfrmOptionsSurrogate) and FfrmOptionsSurrogate.SurrogateUpdated); // NSR20071216 AA 2015-12-09
end;

procedure TfrmOptions.cbkCopyPasteClick(Sender: TObject);
begin
  inherited;
  pnlCPOptions.Visible := cbkCopyPaste.Checked;
  if cbkCopyPaste.Checked then
    cbkCopyPaste.Caption := 'Copy/Paste viewing is currently enabled.'
  else
    cbkCopyPaste.Caption := 'Copy/Paste viewing is currently disabled.';

  CheckApply;
end;

procedure TfrmOptions.chkNotificationsFlaggedClick(Sender: TObject);
// set notification flagged status
begin
  FdirtyOtherStuff := true;
  CheckApply;
end;

procedure TfrmOptions.LoadListView; //(aListView: TListView; aList: TStrings);
// load a list view with: name, on/off, comment
var
  i: integer;
  aListItem: TListItem;
  aRule: TRule;
  rulenum, ruletext, ruleonoff, rulecomment: string;
begin
  FuseCheckBoxes := false;
  aListView.Items.Clear;
  aListView.SortType := stNone; // if Sorting during load then potential error
  with aList do
  begin
    for i := 0 to aList.Count - 1 do
    begin
      rulenum := Piece(aList[i], '^', 1);
      ruletext := Piece(aList[i], '^', 2);
      ruleonoff := Piece(aList[i], '^', 3);
      rulecomment := Piece(aList[i], '^', 4);
      aListItem := aListView.Items.Add;
      with aListItem do
      begin
        Caption := ruletext;
        SubItems.Add(ruleonoff);
        if ruleonoff = 'On' then Checked := true;
        SubItems.Add(rulecomment);
      end;
      aRule := TRule.Create;
      with aRule do
      begin
        IEN := rulenum;
        OriginalValue := ruleonoff;
        ItemText := ruletext;
      end;
      aListItem.SubItems.AddObject('rule object', aRule);
    end;
  end;
  aListView.SortType := stBoth;
  FuseCheckBoxes := true;
end;

procedure TfrmOptions.lvwNotificationsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
// change on/off on checkmark
begin
  if (Sender as TListView).ItemIndex = -1 then exit;
  if not FuseCheckBoxes then exit;
  if (Sender as TListView).Checkboxes = false then exit;
  if (Item.SubItems[1] = 'Mandatory') and not Item.Checked then begin
    Item.Checked := True;
    exit;
  end;
  if Item.Checked then
  begin
    if Item.SubItems[0] <> 'On' then
      ChangeOnOff(Sender as TListView, Item);
    Item.SubItems[0] := 'On';
  end
  else
  begin
    if Item.SubItems[0] <> 'Off' then
      ChangeOnOff(Sender as TListView, Item);
    Item.SubItems[0] := 'Off';
  end;
end;

procedure TfrmOptions.lvwNotificationsColumnClick(Sender: TObject;
  Column: TListColumn);
// toggle sort
begin
  if FsortCol = Column.Index then
    FsortAscending := not FsortAscending
  else
    FsortAscending := true;
  FsortCol := Column.Index;
  (Sender as TListView).AlphaSort;
end;

procedure TfrmOptions.lvwNotificationsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
//  sort columns
begin
  if not(Sender is TListView) then exit;
  if FsortAscending then
  begin
    if FsortCol = 0 then
      Compare := CompareStr(Item1.Caption, Item2.Caption)
    else
      Compare := CompareStr(Item1.SubItems[FsortCol - 1],
        Item2.SubItems[FsortCol - 1]);
  end
  else
  begin
    if FsortCol = 0 then
      Compare := CompareStr(Item2.Caption, Item1.Caption)
    else
      Compare := CompareStr(Item2.SubItems[FsortCol - 1],
        Item1.SubItems[FsortCol - 1]);
  end;
end;

procedure TfrmOptions.lvwNotificationsDblClick(Sender: TObject);
// toggle check marks with double click
var
  aListItem: TListItem;
begin
  with (Sender as TListView) do
  begin
    if Checkboxes = false then exit;
    if Selected = nil then exit;
    if Selected.SubItems[1] = 'Mandatory' then exit;
    if Selected <> FLastClickedItem then exit;
    aListItem := Selected;
    aListItem.Checked := not aListItem.Checked;
    ChangeOnOff(Sender as TListView, aListItem);

    if aListItem.Checked then
      aListItem.SubItems[0] := 'On'
    else
      aListItem.SubItems[0] := 'Off';
  end;
end;

procedure TfrmOptions.ChangeOnOff(aListView: TListView; aListItem: TListItem);
// check if list items were edited
begin
  if aListView = lvwNotifications then FdirtyNotifications := true;
  if aListView = lvwOrderChecks then FdirtyOrderChecks := true;
  CheckApply;
end;


procedure TfrmOptions.btnProcessedAlertsSettingsClick(Sender: TObject);
//var
//  b:boolean;
begin
//  Offset(topsize, -30, leftsize, -30);
//  b := (UpdateProcessedAlertsPreferences <> mrCancel);
//  FdirtyOtherStuff := FdirtyOtherStuff or b;
//  CheckApply;

  // AA: passing ApplyOtherStuff to save changes without clicking "Apply"
  UpdateProcessedAlertsPreferences(ApplyOtherStuff);
end;

procedure TfrmOptions.btnCombinationsClick(Sender: TObject);
// display Combination List Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsCombinations(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnNotesNotesClick(Sender: TObject);
// display Notes Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsNotes(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnNotesTitlesClick(Sender: TObject);
// display Titles Options
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsTitles(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnReportsClick(Sender: TObject);
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, 90, leftsize, 23);
  DialogOptionsHSDefault(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.btnReport1Click(Sender: TObject);
var
  topsize, leftsize, value: integer;
begin
  value := 0;
  Offset(topsize, -18, leftsize, -15);
  DialogOptionsHSCustom(topsize, leftsize, Font.Size, value);
end;

procedure TfrmOptions.lvwNotificationsEnter(Sender: TObject);
begin
  with Sender as TListView do begin
    if (Selected = nil) and (Items.Count > 0) then
      Selected := Items[0];
  end;
end;

procedure TfrmOptions.lvwNotificationsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLastClickedItem := (Sender as TListView).GetItemAt(X,Y);
end;

procedure TfrmOptions.btnDiagnosesClick(Sender: TObject);
// display Personal Diagnoses List
var
  topsize, leftsize, value: integer;
begin
  if IsCIDCProvider(User.DUZ) then    //(hds7564)
  begin
     value := 0;
     Offset(topsize, -60, leftsize, -60);
     DialogOptionsDiagnoses(topsize, leftsize, Font.Size, value);
  end;
end;

procedure TfrmOptions.btnGraphSettingsClick(Sender: TObject);
// display GraphSettings
var
  actiontype: boolean;
  topsize, leftsize: integer;
begin
  actiontype := false;
  Offset(topsize, -60, leftsize, -60);
  DialogOptionsGraphSettings(topsize, leftsize, Font.Size, actiontype);
end;

procedure TfrmOptions.btnGraphViewsClick(Sender: TObject);
// display Graph Views
var
  actiontype: boolean;
begin
  actiontype := false;
  DialogOptionsGraphProfiles(actiontype);
  // if changes were made then view listing should be updated ***********
end;

procedure TfrmOptions.pagOptionsChange(Sender: TObject);
begin
  inherited;
  if pagOptions.ActivePage = tsSurrogates then InitSurrogatesTab; // Creates the surrogates tab content if it is not there yet
  if pagOptions.TabIndex < 0 then Exit;
end;

procedure TfrmOptions.pagOptionsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  if pagOptions.Pages[pagOptions.TabIndex] = tsSurrogates then
  begin
    AllowChange := VerifyIfTabCanChange;
  end;
end;

procedure TfrmOptions.pagOptionsDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  AText: string;
  APoint: TPoint;
begin
  with (Control as TPageControl).Canvas do
  begin
    FillRect(Rect);
    AText := TPageControl(Control).Pages[TabIndex].Caption;
    with Control.Canvas do
    begin
      APoint.x := (Rect.Right - Rect.Left) div 2 - TextWidth(AText) div 2;
      APoint.y := (Rect.Bottom - Rect.Top) div 2 - TextHeight(AText) div 2;
      TextRect(Rect, Rect.Left + APoint.x, Rect.Top + APoint.y, AText);
    end;
  end;
end;

// COPY PASTE

procedure TfrmOptions.cpHLColorChange(Sender: TObject);
begin
  inherited;
  CopyPasteColor := Get508CompliantColor(cpHLColor.Selected);
  CopyPasteOptions.Repaint;
  CheckApply;
end;

procedure TfrmOptions.CPLCSCOLORChange(Sender: TObject);
begin
  inherited;
  LCSIdentColor := Get508CompliantColor(CPLCSCOLOR.Selected);
  CheckApply;
end;

procedure TfrmOptions.CPLCSLimitChange(Sender: TObject);
begin
  inherited;
  CheckApply;
end;

procedure TfrmOptions.CPLCSLimitKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not CharInSet(Key, [#8, '0'..'9']) then begin
    // Discard the key
    Key := #0;
  end;
  CheckApply;
end;

function TfrmOptions.CopyPasteChanged: Boolean;
// Determines if the user changed any options
// Bold^Italics^Underline^Highlight^Highlight Color
//var
// I: Integer;
// OptionList: TStringList;
// OurFlag: Boolean;
begin
  Result := False;
  if frmFrame.CPAppMon.Enabled then
  begin
    Result := Result or (frmFrame.CPAppMon.DisplayPaste <> cbkCopyPaste.Checked);
    if cbkCopyPaste.Checked then begin
      // if copypaste isn't enabled, none of these settings are considered changed
      Result := Result or (
        (CopyPasteOptions.Items.Count > 0) and
        (CopyPasteOptions.Checked[0] <> (fsBold in frmFrame.CPAppMon.MatchStyle))
        );
      Result := Result or (
        (CopyPasteOptions.Items.Count > 1) and
        (CopyPasteOptions.Checked[1] <> (fsItalic in frmFrame.CPAppMon.MatchStyle))
        );
      Result := Result or (
        (CopyPasteOptions.Items.Count > 2) and
        (CopyPasteOptions.Checked[2] <> (fsUnderline in frmFrame.CPAppMon.MatchStyle))
        );
      Result := Result or (
        (CopyPasteOptions.Items.Count > 3) and
        (CopyPasteOptions.Checked[3] <> frmFrame.CPAppMon.MatchHighlight)
        );
      //When off color is set to background color
      if (not Result) and
        (CopyPasteOptions.Items.Count > 3) and CopyPasteOptions.Checked[3] and
        (CopyPasteColor <> CopyPasteOptions.Color) then
        Result := frmFrame.CPAppMon.HighlightColor <> CopyPasteColor;
      //LCS Change
      Result := Result or (CPLCSToggle.Checked <> frmFrame.CPAppMon.LCSToggle);
      if CPLCSToggle.Checked then begin
        // if CPLCSToggle isn't checked, none of these settings are considered changed
        Result := Result or (
          (CPLCSIDENT.Items.Count > 0) and
          (CPLCSIDENT.Checked[0] <> (fsBold in frmFrame.CPAppMon.LCSTextStyle))
          );
        Result := Result or (
          (CPLCSIDENT.Items.Count > 1) and
          (CPLCSIDENT.Checked[1] <> (fsItalic in frmFrame.CPAppMon.LCSTextStyle))
          );
        Result := Result or (
          (CPLCSIDENT.Items.Count > 2) and
          (CPLCSIDENT.Checked[2] <> (fsUnderline in frmFrame.CPAppMon.LCSTextStyle))
          );
        Result := Result or (
          (CPLCSIDENT.Items.Count > 3) and
          (CPLCSIDENT.Checked[3] <> frmFrame.CPAppMon.LCSUseColor)
          );

        //When off color is set to background color
        if (not Result) and
          (CPLCSIDENT.Items.Count > 3) and CPLCSIDENT.Checked[3] and
          (LCSIdentColor <> CPLCSIDENT.color) then
          Result := frmFrame.CPAppMon.LCSTextColor <> LCSIdentColor;

        Result := Result or (StrToIntDef(CPLCSLimit.Text, 0) <> frmFrame.CPAppMon.LCSCharLimit);
      end;
    end;
  end;
end;

procedure TfrmOptions.CPLCSIDENTClickCheck(Sender: TObject);
const
  TextColorIndex: integer = 3;
var
  ACheckListBox: TCheckListBox;
begin
  inherited;
  ACheckListBox := Sender as TCheckListBox;
  if ACheckListBox.ItemIndex = TextColorIndex then
  begin
    if (ACheckListBox.Items.Count > TextColorIndex) and
      (ACheckListBox.Checked[TextColorIndex]) then
    begin
      CPLCSCOLOR.Selected := LCSIdentColor;
      lblTextColor.Visible := True;
      CPLCSCOLOR.Visible := True;
      if ScreenReaderSystemActive then
        GetScreenReader.Speak('Text color selection box now available.');
    end else begin
      lblTextColor.Visible := False;
      CPLCSCOLOR.Visible := False;
    end;
  end;
  CheckApply;
end;

procedure TfrmOptions.CPOptionsClickCheck(Sender: TObject);
//Display the color selection if highlight checked
const
  HighlightIndex: integer = 3;
var
  ACheckListBox: TCheckListBox;
begin
  inherited;
  ACheckListBox := (Sender as TCheckListBox);
  if ACheckListBox.ItemIndex = HighlightIndex then
  begin
    if (ACheckListBox.Items.Count > HighlightIndex) and
      (ACheckListBox.Checked[HighlightIndex]) then
    begin
      cpHLColor.Selected := CopyPasteColor;
      lbCPhighLight.Visible := True;
      cpHLColor.Visible := True;
      if ScreenReaderSystemActive then
        GetScreenReader.Speak('Highlight color selection box now available.');
    end else begin
      lbCPhighLight.Visible := False;
      cpHLColor.Visible := False;
    end;
  end;
  CheckApply;
end;

procedure TfrmOptions.CPOptionsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; aState: TOwnerDrawState);
//Draw the copy paste options
begin
 Inherited;
 with TCheckListBox(Control) do
  begin
     case Index of
     0: Canvas.Font.Style := [fsBold];
     1: Canvas.Font.Style := [fsItalic];
     2: Canvas.Font.Style := [fsUnderline];
     3: begin
      If TCheckListBox(Control).Name = 'CPLCSIDENT' then
      begin
       // if not (odSelected in aState) then
        Canvas.Font.Color := LCSIdentColor;
       Canvas.Font.Style := [];
      end else begin
       if not (odSelected in aState) then
        Canvas.Brush.Color := CopyPasteColor;
       Canvas.Font.Style := [];
      end;
     end;
    end;
    Canvas.FillRect(Rect);
    Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);
    if odFocused in aState then
      Canvas.DrawFocusRect(Rect) ;
   end;
end;

procedure TfrmOptions.ApplyCopyPaste;
// Setup the RPC
// Bold,Italics,Underline,Highlight,Highlight Color
var
  aString{, OurFlag}: string;
//  I: integer;
begin
 if cbkCopyPaste.Checked then
 begin
 With frmFrame.CPAppMon do begin
 MatchStyle := [];
 if CopyPasteOptions.Checked[0] then begin
   aString := aString + '1,';
   MatchStyle := MatchStyle + [fsBold];
 end else
   aString := aString + '0,';

 if CopyPasteOptions.Checked[1] then begin
   aString := aString + '1,';
   MatchStyle := MatchStyle + [fsItalic];
 end else
   aString := aString + '0,';

  if CopyPasteOptions.Checked[2] then begin
   aString := aString + '1,';
   MatchStyle := MatchStyle + [fsUnderline];
  end else
   aString := aString + '0,';

  if CopyPasteOptions.Checked[3] then
   aString := aString + '1,'
  else
   aString := aString + '0,';
  MatchHighlight := CopyPasteOptions.Checked[3];

  aString := aString + IntToStr(CopyPasteColor) +',';
  HighlightColor := CopyPasteColor;

  DisplayPaste := true;

  Enabled := True;
  //LCS
  if CPLCSToggle.Checked then
   aString := aString + '1,'
  else
   aString := aString + '0,';
   LCSToggle := CPLCSToggle.Checked;

  LCSTextStyle := [];
  if CPLCSIDENT.Checked[0] then begin
   aString := aString + '1,';
   LCSTextStyle := LCSTextStyle + [fsBold];
 end else
   aString := aString + '0,';

 if CPLCSIDENT.Checked[1] then begin
   aString := aString + '1,';
   LCSTextStyle := LCSTextStyle + [fsItalic];
 end else
   aString := aString + '0,';

  if CPLCSIDENT.Checked[2] then begin
   aString := aString + '1,';
   LCSTextStyle := LCSTextStyle + [fsUnderline];
  end else
   aString := aString + '0,';

  if CPLCSIDENT.Checked[3] then
   aString := aString + '1,'
  else
   aString := aString + '0,';
  LCSUseColor := CPLCSIDENT.Checked[3];

  aString := aString + IntToStr(LCSIdentColor) +','+ IntToStr(StrToIntDef(CPLCSLimit.Text, 0));
  LCSTextColor := LCSIdentColor;
  LCSCharLimit := StrToIntDef(CPLCSLimit.Text, 5000)
 end
 end else begin
   frmFrame.CPAppMon.DisplayPaste := False;
   aString := '-1;Visual Disable Override';
 end;

 rpcSetCopyPaste(aString);
end;

procedure TfrmOptions.CPLCSToggleClick(Sender: TObject);
begin
  inherited;
  pnlCPLCsSub.Visible := CPLCSToggle.Checked;
  CheckApply;
end;

procedure TfrmOptions.LoadCopyPaste();
//var
// I: Integer;
// OurFlag: Boolean;
begin
 With frmFrame.CPAppMon do begin
  //Try to load the properties (if not loaded)
  LoadTheProperties;

  if not DisplayPaste or not Enabled then
  begin
   cbkCopyPaste.Checked := False;
   cbkCopyPasteClick(cbkCopyPaste);
   CopyPasteOptions.Checked[0] := false;
   CopyPasteOptions.Checked[1] := false;
   CopyPasteOptions.Checked[2] := false;
   CopyPasteOptions.Checked[3] := false;
   MatchHighlight := False;
   CopyPasteColor := CopyPasteOptions.Color;
   lbCPhighLight.Visible := false;
   cpHLColor.Visible := false;


   //setup the LCS
   CPLCSToggle.Checked := false;
   LCSToggle := False;
   CPLCSIDENT.Checked[0] := false;
   CPLCSIDENT.Checked[1] := false;
   CPLCSIDENT.Checked[2] := false;
   CPLCSIDENT.Checked[3] := false;
   LCSUseColor := False;
   LCSIdentColor := clWindowText;
   lblTextColor.Visible := false;
   CPLCSCOLOR.Visible := false;

  end else begin
    CPLcsMemo.Text :='Please note that the Difference Identifier process is memory intensive. '+
      'The default number of characters is set at 5000. Changing this to a higher number may '+
      'increase the time for the system to display all the differences.';

   cbkCopyPaste.Checked := true;
   cbkCopyPasteClick(cbkCopyPaste);
   //Now load the options
   CopyPasteOptions.Checked[0] := (fsBold in MatchStyle);
   CopyPasteOptions.Checked[1] := (fsItalic in MatchStyle);
   CopyPasteOptions.Checked[2] := (fsUnderline in MatchStyle);
   CopyPasteOptions.Checked[3] := MatchHighlight;
   CopyPasteColor := HighlightColor;
   cpHLColor.Selected := CopyPasteColor;
   if MatchHighlight then begin
    lbCPhighLight.Visible := true;
    cpHLColor.Visible := true;
   end else begin
    lbCPhighLight.Visible := false;
    cpHLColor.Visible := false;
   end;


   //setup the LCS
   CPLCSToggle.Checked := LCSToggle;
   CPLCSIDENT.Checked[0] := (fsBold in LCSTextStyle);
   CPLCSIDENT.Checked[1] := (fsItalic in LCSTextStyle);
   CPLCSIDENT.Checked[2] := (fsUnderline in LCSTextStyle);
   CPLCSIDENT.Checked[3] := LCSUseColor;
   LCSIdentColor := LCSTextColor;
   CPLCSCOLOR.Selected := LCSIdentColor;
   if LCSUseColor then begin
    lblTextColor.Visible := true;
    CPLCSCOLOR.Visible := true;
   end else begin
    lblTextColor.Visible := false;
    CPLCSCOLOR.Visible := false;
   end;
   CPLCSLimit.Text := IntToStr(LCSCharLimit);
  end;

 end;
end;

function TfrmOptions.VerifySaveCondition(Sender: TObject): Integer;
const
  Msg = 'Copy/Paste GUI options DID NOT save. You must have at least one option selected.'
    + #13 + 'Please check the following section(s): ' + #13#13 + '%s' + #13 +
    'Click OK to reverify your selection';
Var
 DlgButtons: TMsgDlgButtons;
  ShowErr: Boolean;
  AddMsg: String;
begin
 Result := -1;
  ShowErr := false;
   //Copy paste options (at least one selected)
   if Sender = btnOK then
    DlgButtons := [mbOK, mbIgnore]
   else
    DlgButtons := [mbOK];

  if (cbkCopyPaste.Checked) and (not CopyPasteOptions.Checked[0]) and
    (not CopyPasteOptions.Checked[1]) and (not CopyPasteOptions.Checked[2]) and
    (not CopyPasteOptions.Checked[3]) then
  begin
    ShowErr := true;
    AddMsg := 'Text Identification' + #13;
  end;
  if (cbkCopyPaste.Checked) and CPLCSToggle.Checked and
    (not CPLCSIDENT.Checked[0]) and (not CPLCSIDENT.Checked[1]) and
    (not CPLCSIDENT.Checked[2]) and (not CPLCSIDENT.Checked[3]) then
  begin
    ShowErr := true;
    AddMsg := AddMsg + 'Paste Differences' + #13;
  end;

  if not ShowErr then
  begin
    if (not frmFrame.CPAppMon.DisplayPaste) and (cbkCopyPaste.Checked) then
    begin
      if MessageDlg('Saving will re-enable copy/paste. Are you sure?',
        mtWarning, [mbYes, mbNo], -1) = mrYes then
        Result := -1
      else
      begin
        Result := 0;
      cbkCopyPaste.Checked := false;
      cbkCopyPasteClick(cbkCopyPaste);
      CopyPasteOptions.Checked[0] := false;
      CopyPasteOptions.Checked[1] := false;
      CopyPasteOptions.Checked[2] := false;
      CopyPasteOptions.Checked[3] := false;
        frmFrame.CPAppMon.MatchHighlight := false;
        lbCPhighLight.visible := false;
        cpHLColor.visible := false;
    end;
    end;
  end
     else
    Result := MessageDlg(Format(Msg, [AddMsg]), mtError, DlgButtons, -1)

end;

//----------------- TTabSheet -----------------//
constructor TTabSheet.Create(aOwner: TComponent);
begin
  inherited;
  FColor := clBtnFace;
end;

procedure TTabSheet.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
    Brush.Color := FColor;
    Windows.FillRect(Msg.dc, ClientRect, Brush.Handle);
    Msg.Result := 1;
end;
// NSR20100706 AA 2015/10/10 - Management of Highlighting preferences ---- begin
procedure TfrmOptions.btnRequiredFieldsClick(Sender: TObject);
begin
  UpdateRequiredFieldsPreferences;
end;
// NSR20100706 AA 2015/10/10 - Management of Highlighting preferences ------ end

//----------------- TColorBox -----------------//
procedure TColorBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustSizeOfSelf;
end;

procedure TColorBox.AdjustSizeOfSelf;
var
  FontHeight: Integer;
  cboYMargin: integer;
begin
  DroppedDown := False;
  FontHeight := FontHeightPixel(Self.Font.Handle);
  cboYMargin := 8;
  ItemHeight := HigherOf(FontHeight + cboYMargin, ItemHeight); // must be at least as high as text
  SetBounds(Left, Top, Width, FontHeight + cboYMargin);
end;

function TfrmOptions.VerifyIfTabCanChange: Boolean;
begin
  Result := True;
  if (pagOptions.Pages[pagOptions.TabIndex] = tsSurrogates) and
    Assigned(FfrmOptionsSurrogate) then
  begin
    // Using the flag if there are changes
    if FfrmOptionsSurrogate.SurrogateUpdated then
      Result := FfrmOptionsSurrogate.CanChangeTabs
    else
      FfrmOptionsSurrogate.UpdateWithServerData;
  end;
end;

end.
