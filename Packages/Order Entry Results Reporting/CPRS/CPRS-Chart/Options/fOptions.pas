unit fOptions;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, ORCtrls, OrFn, Dialogs, ORDtTmRng, fBAOptionsDiagnoses,
  uBAGlobals, fBase508Form, VA508AccessibilityManager, fAutoSz, Vcl.CheckLst, Messages;

type

  TTabSheet = class(ComCtrls.TTabSheet)
  private
    FColor: TColor;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(aOwner: TComponent); override;
  end;

  TfrmOptions = class(TfrmAutoSz)
    pnlMain: TPanel;
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
    bvlCoverDays: TBevel;
    btnCoverReminders: TButton;
    bvlCoverReminders: TBevel;
    imgCoverDays: TImage;
    imgCoverReminders: TImage;
    lblPatientSelectionDesc: TMemo;
    lblPatientSelection: TStaticText;
    btnPatientSelection: TButton;
    bvlPatientSelection: TBevel;
    btnPersonalLists: TButton;
    imgPatientSelection: TImage;
    lblNotificationsOptions: TStaticText;
    lblNotifications: TStaticText;
    bvlNotifications: TBevel;
    imgNotifications: TImage;
    lblOrderChecksDesc: TLabel;
    lblOrderChecks: TStaticText;
    bvlOrderChecks: TBevel;
    imgOrderChecks: TImage;
    lblTeamsDesc: TMemo;
    lblTeams: TStaticText;
    btnTeams: TButton;
    bvlTeams: TBevel;
    lvwNotifications: TCaptionListView;
    lblNotificationView: TLabel;
    btnNotificationsRemove: TButton;
    chkNotificationsFlagged: TCheckBox;
    lvwOrderChecks: TCaptionListView;
    lblOrderChecksView: TLabel;
    btnSurrogate: TButton;
    lblNotificationsSurrogate: TStaticText;
    lblNotificationsSurrogateText: TStaticText;
    btnCombinations: TButton;
    bvlOtherParameters: TBevel;
    lblOtherParameters: TStaticText;
    imgOtherParameters: TImage;
    lblOtherParametersDesc: TMemo;
    btnOtherParameters: TButton;
    tsNotes: TTabSheet;
    lblNotesNotesDesc: TMemo;
    lblNotesNotes: TStaticText;
    bvlNotesNotes: TBevel;
    btnNotesNotes: TButton;
    lblNotesTitles: TStaticText;
    bvlNotesTitles: TBevel;
    lblNotesTitlesDesc: TMemo;
    btnNotesTitles: TButton;
    imgNotesNotes: TImage;
    imgNotes: TImage;
    imgTeams: TImage;
    tsCprsReports: TTabSheet;
    lblReports: TStaticText;
    bvlReports: TBevel;
    memReports: TMemo;
    imgReports: TImage;
    btnReports: TButton;
    lblReport1: TStaticText;
    memReport1: TMemo;
    btnReport1: TButton;
    bvlReport1: TBevel;
    btnDiagnoses: TButton;
    tsGraphs: TTabSheet;
    lblGraphSettings: TStaticText;
    bvlGraphSettings: TBevel;
    imgGraphSettings: TImage;
    btnGraphSettings: TButton;
    bvlGraphViews: TBevel;
    lblGraphViews: TStaticText;
    imgGraphViews: TImage;
    btnGraphViews: TButton;
    memGraphSettings: TMemo;
    memGraphViews: TMemo;
    bvlReport2: TBevel;
    lblReport2: TStaticText;
    memReport2: TMemo;
    imgReport1: TImage;
    imgReport2: TImage;
    PnlNoteTop: TPanel;
    PnlNoteCl: TPanel;
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
    procedure btnSurrogateClick(Sender: TObject);
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
    procedure Offset(var topnum: integer; topoffset: integer; var leftnum: integer; leftoffset: integer);
    procedure LoadNotifications;
    procedure LoadOrderChecks;
    procedure ApplyNotifications;
    procedure ApplyOrderChecks;
    procedure ApplyOtherStuff;
    procedure CheckApply;
    procedure LoadListView(aListView: TListView; aList: TStrings);
    procedure ChangeOnOff(aListView: TListView; aListItem: TListItem);
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

procedure DialogOptions(var actiontype: Integer);

implementation

uses fOptionsDays, fOptionsReminders, fOptionsSurrogate,
     fOptionsPatientSelection, fOptionsLists, fOptionsTeams, fOptionsCombinations,
     fOptionsOther, fOptionsNotes, fOptionsTitles, fOptionsReportsCustom, fOptionsReportsDefault,
     fGraphs, fGraphSettings, fGraphProfiles, rGraphs, uGraphs,
     rOptions, rCore, uCore, uOptions, UBACore, fFrame, UITypes, VA508AccessibilityRouter, Themes;
     //fTestDialog;

{$R *.DFM}

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

procedure TfrmOptions.FormCreate(Sender: TObject);
// initialize form
begin
  LoadNotifications;
  LoadOrderChecks;
  FdirtyNotifications := false;
  FdirtyOrderChecks := false;
  FdirtyOtherStuff := false;
  CheckApply;

  if (Encounter.Provider = 0) and not IsCIDCProvider(User.DUZ) then
      btnDiagnoses.Enabled := False;
  FGiveMultiTabMessage := ScreenReaderSystemActive;

end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
// cleanup creation of objects
var
  i: integer;
begin
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

procedure TfrmOptions.btnApplyClick(Sender: TObject);
// save actions without exiting
begin
  if FdirtyNotifications then
    ApplyNotifications;
  if FdirtyOrderChecks then
    ApplyOrderChecks;
  if FdirtyOtherStuff then
    ApplyOtherStuff;
  CheckApply;
  if Sender = btnOK then begin
    ModalResult := mrOk;
    Close;
  end;
end;

procedure TfrmOptions.LoadNotifications;
// load Notification tab
var
  notifydefaults, surrogateinfo, flag, enableerase: string;
begin
  LoadListView(lvwNotifications, rpcGetNotifications);
  lvwNotificationsColumnClick(lvwNotifications, lvwNotifications.Column[0]); // make sure sorted
  notifydefaults := rpcGetNotificationDefaults;
  flag := Piece(notifydefaults, '^', 2);
  enableerase := Piece(notifydefaults, '^', 3);
  chkNotificationsFlagged.Checked := flag = '1';
  btnNotificationsRemove.Enabled := enableerase = '1';
  surrogateinfo := rpcGetSurrogateInfo;
  btnSurrogate.Hint := surrogateinfo;
  LabelSurrogate(surrogateinfo, lblNotificationsSurrogateText);
end;

procedure TfrmOptions.LoadOrderChecks;
// load Order Check tab
begin
  LoadListView(lvwOrderChecks, rpcGetOrderChecks);
  lvwOrderChecks.Checkboxes := true;
end;

procedure TfrmOptions.ApplyNotifications;
// save Notification changes
var
  i: integer;
  newonoff: string;
  aRule: TRule;
  aList: TStringList;
begin
  aList := TStringList.Create;
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
  aList.free;
  FdirtyNotifications := false;
end;

procedure TfrmOptions.ApplyOrderChecks;
// save Order Check changes
var
  i: integer;
  newonoff: string;
  aRule: TRule;
  aList: TStringList;
begin
  aList := TStringList.Create;
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
  aList.free;
  FdirtyOrderChecks := false;
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
  rpcSetOtherStuff(aString);
  FdirtyOtherStuff := false;
end;

procedure TfrmOptions.CheckApply;
// determine if Apply button is enabled
begin
  btnApply.Enabled :=  FdirtyOrderChecks or FdirtyNotifications or FdirtyOtherStuff;
end;

procedure TfrmOptions.chkNotificationsFlaggedClick(Sender: TObject);
// set notification flagged status
begin
  FdirtyOtherStuff := true;
  CheckApply;
end;

procedure TfrmOptions.LoadListView(aListView: TListView; aList: TStrings);
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

procedure TfrmOptions.btnSurrogateClick(Sender: TObject);
// display Surrogate Options
var
  topsize, leftsize: integer;
  surrogateinfo: string;
begin
  surrogateinfo := btnSurrogate.Hint;
  Offset(topsize, -30, leftsize, -30);
  DialogOptionsSurrogate(topsize, leftsize, Font.Size, surrogateinfo);
  LabelSurrogate(surrogateinfo, lblNotificationsSurrogateText);
  btnSurrogate.Hint := surrogateinfo;
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

end.

