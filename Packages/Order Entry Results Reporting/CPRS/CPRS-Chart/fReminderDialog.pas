unit fReminderDialog;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORFn, StdCtrls, ComCtrls, Buttons, ORCtrls, uReminders, uConst,
  ORClasses, fRptBox, Menus, rPCE, uTemplates, fBase508Form, System.Generics.Collections,
  VA508AccessibilityManager, fMHTest, fFrame, System.UITypes, rvimm, uPCE,
  fBaseDynamicControlsForm;

type
  TfrmRemDlg = class(TfrmBaseDynamicControlsForm)
    sb1: TScrollBox;
    sb2: TScrollBox;
    splTxtData: TSplitter;
    pnlFrmBottom: TPanel;
    pnlBottom: TPanel;
    splText: TSplitter;
    reData: ORExtensions.TRichEdit;
    reText: ORExtensions.TRichEdit;
    lblFootnotes: TLabel;
    gpButtons: TGridPanel;
    btnClear: TButton;
    btnClinMaint: TButton;
    btnVisit: TButton;
    btnBack: TButton;
    btnNext: TButton;
    btnFinish: TButton;
    btnCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbResize(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ProcessReminderFromNodeStr(value: string);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure btnClinMaintClick(Sender: TObject);
    procedure btnVisitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnCancelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    // AGP Change 24.8
  private
    FSCCond: TSCConditions;
    FSCPrompt: Boolean;
    FVitalsDate: TFMDateTime;
    FSCRelated: Integer;
    FAORelated: Integer;
    FIRRelated: Integer;
    FECRelated: Integer;
    FMSTRelated: Integer;
    FHNCRelated: Integer;
    FCVRelated: Integer;
    FSHDRelated: Integer;
    FCLRelated: Integer;
    FLastWidth: Integer;
    FUseBox2: Boolean;
    FExitOK: Boolean;
    FReminder: TReminderDialog;
    CurReminderList: TORStringList;
    FClinMainBox: TfrmReportBox;
    FOldClinMaintOnDestroy: TNotifyEvent;
    FProcessingTemplate: Boolean;
    FSilent: Boolean;
    FMessageBoxText: string;
    FFinishing: boolean;
    FAllowAutoRebuild: boolean;
    FPendingAutoRebuild: boolean;
    FLockCount: integer;
    procedure UMMessageBox(var Message: TMessage); message UM_MESSAGEBOX;
    procedure UMResyncRem(var Message: TMessage); message UM_RESYNCREM;
    procedure UMValidateMag(var Message: TMessage); message UM_VALIDATE_MAG;
    procedure KillDlg(ptr: Pointer; ID: string; KillObjects: Boolean = FALSE);
    procedure getProcedureCodes(var codesList: TStrings);
    procedure getDiagnosisCodes(var codesList: TStrings);
    function inCodesList(codeSys, code: string; codesList: TStrings): boolean;
    function CanAbort: boolean;
    procedure DoAbort;
    procedure Lock;
    procedure Unlock;
    procedure RequestRebuild;
  protected
    procedure RemindersChanged(Sender: TObject);
    procedure ClearControls(All: Boolean = FALSE);
    procedure BuildControls(BuildAll: boolean);
    function GetBox(Other: Boolean = FALSE): TScrollBox;
    function KillAll: Boolean;
    procedure ResetProcessing(Wipe: string = ''); // AGP CHANGE 24.8;
    procedure BoxUpdateDone;
    procedure ControlsChanged(Sender: TObject);
    procedure UpdateText(Sender: TObject);
    function GetCurReminderList: Integer;
    function NextReminder: string;
    function BackReminder: string;
    procedure UpdateButtons;
    procedure PositionTrees(NodeID: string);
    procedure ClinMaintDestroyed(Sender: TObject);
    procedure ProcessTemplate(Template: TTemplate);
    procedure ClearMHTest(Rien: string);
  public
    procedure ProcessReminder(ARemData: string; NodeID: string);
    procedure SetFontSize;
    property Silent: Boolean read FSilent write FSilent;
    property MessageBoxText: string read FMessageBoxText write FMessageBoxText;
  end;

procedure ViewReminderDialog(RemNode: TORTreeNode; InitDlg: Boolean = TRUE);
procedure ViewReminderDialogTemplate(TempNode: TORTreeNode;
  InitDlg: Boolean = TRUE);
procedure ViewRemDlgTemplateFromForm(OwningForm: TForm; Template: TTemplate;
  InitDlg, IsTemplate: Boolean);
procedure HideReminderDialog;
procedure UpdateReminderFinish;
procedure KillReminderDialog(frm: TForm);
procedure NotifyWhenProcessingReminderChanges(Proc: TNotifyEvent);
procedure RemoveNotifyWhenProcessingReminderChanges(Proc: TNotifyEvent);
function ReminderDialogActive: Boolean;
function CurrentReminderInDialog: TReminderDialog;

var
  frmRemDlg: TfrmRemDlg = nil;
  RemDlgSpltr1: Integer = 0;
  RemDlgSpltr2: Integer = 0;
  RemDlgLeft: Integer = 0;
  RemDlgTop: Integer = 0;
  RemDlgWidth: Integer = 0;
  RemDlgHeight: Integer = 0;

const
  RemDlgName = 'frmRemDlg';
  RemDlgSplitters = 'frmRemDlgSplitters';

implementation

uses
  fNotes, uOrders, rOrders, uCore, rMisc, rReminders,
  fReminderTree, uVitals, rVitals, RichEdit, fConsults, fTemplateDialog,
  uTemplateFields, fRemVisitInfo, rCore, uVA508CPRSCompatibility,
  VA508AccessibilityRouter, VAUtils, uGlobalVar, uDlgComponents, uPDMP,
  UResponsiveGUI;

{$R *.DFM}

var
  PositionList: TORNotifyList = nil;
  ClinRemTextLocation: Integer = -77;
  ClinRemTextStr: string = '';

const
  REQ_TXT = 'The following required items must be entered:' + CRLF;
  REQ_HDR = 'Required Items Missing';

function ClinRemText(Location: Integer): string;
var
  loc: Integer;

begin
  if Location < 1 then
    loc := Encounter.Location
  else
    loc := Location;
  if (ClinRemTextLocation <> loc) then
  begin
    ClinRemTextLocation := loc;
    ClinRemTextStr := GetProgressNoteHeader(loc);
  end;
  Result := ClinRemTextStr;
end;

procedure NotifyWhenProcessingReminderChanges(Proc: TNotifyEvent);
begin
  if (not assigned(PositionList)) then
    PositionList := TORNotifyList.Create;
  PositionList.Add(Proc);
end;

procedure RemoveNotifyWhenProcessingReminderChanges(Proc: TNotifyEvent);
begin
  if (assigned(PositionList)) then
    PositionList.Remove(Proc);
end;

function ReminderDialogActive: Boolean;
begin
  Result := assigned(frmRemDlg);
end;

function CurrentReminderInDialog: TReminderDialog;
begin
  Result := nil;
  if (assigned(frmRemDlg)) then
    Result := frmRemDlg.FReminder;
end;

var
  uRemDlgStarting: Boolean = FALSE;

procedure ViewRemDlgFromForm(OwningForm: TForm; RemNode: TORTreeNode;
  Template: TTemplate; InitDlg, IsTemplate: Boolean);
var
  Update: Boolean;
  Err: string;

begin
  if uRemDlgStarting then
    exit; // CQ#16219 - double click started reminder creation twice
  uRemDlgStarting := TRUE;
  try
    Err := '';
    if assigned(frmRemDlg) then
    begin
      if IsTemplate then
        Err := 'Can not process template while another reminder dialog is being processed.'
      else if frmRemDlg.FProcessingTemplate then
        Err := 'Can not process reminder while a reminder dialog template is being processed.'
    end;
    Update := FALSE;
    if Err = '' then
    begin
      if (RemForm.Form <> OwningForm) then
      begin
        if (assigned(RemForm.Form)) then
          Err := 'Reminders currently begin processed on another tab.'
        else
        begin
          if (OwningForm = frmNotes) then
          begin
            frmNotes.AssignRemForm;
            if (not SpansIntlDateLine) and FutureEncounter(RemForm.PCEObj) then
              Err := 'Can not process a reminder dialog for a future encounter date.';
          end
          else if (OwningForm = frmConsults) then
            frmConsults.AssignRemForm
          else
            Err := 'Can not process reminder dialogs on this tab.';
          Update := TRUE;
        end;
      end;
    end;
    if (Err = '') and (FutureEncounter(RemForm.PCEObj)) and
      (not SpansIntlDateLine) then
      Err := 'Can not process a reminder dialog for a future encounter date.';
    if Err <> '' then
    begin
      InfoBox(Err, 'Reminders in Process', MB_OK or MB_ICONERROR);
      exit;
    end;

    if (InitDlg and (not assigned(frmRemDlg))) then
    begin
      // (AGP add) Check for a bad encounter date
      if RemForm.PCEObj.DateTime < 0 then
      begin
        InfoBox('The parent note has an invalid encounter date. Please contact IRM support for assistance.',
          'Warning', MB_OK);
        exit;
      end;
      frmRemDlg := TfrmRemDlg.Create(Application);
      frmRemDlg.SetFontSize;
      Update := TRUE;
    end;
    if (assigned(frmRemDlg)) then
    begin
      if Update then
      begin
        frmRemDlg.FSCRelated := RemForm.PCEObj.SCRelated;
        frmRemDlg.FAORelated := RemForm.PCEObj.AORelated;
        frmRemDlg.FIRRelated := RemForm.PCEObj.IRRelated;
        frmRemDlg.FECRelated := RemForm.PCEObj.ECRelated;
        frmRemDlg.FMSTRelated := RemForm.PCEObj.MSTRelated;
        frmRemDlg.FHNCRelated := RemForm.PCEObj.HNCRelated;
        frmRemDlg.FCVRelated := RemForm.PCEObj.CVRelated;
        frmRemDlg.FSHDRelated := RemForm.PCEObj.SHADRelated;
        if IsLejeuneActive then
          frmRemDlg.FCLRelated := RemForm.PCEObj.CLRelated; // Camp Lejeune
      end;
      UpdateReminderFinish;
      if IsTemplate then
        frmRemDlg.ProcessTemplate(Template)
      else if assigned(RemNode) then
        frmRemDlg.ProcessReminder(RemNode.StringData,
          RemNode.TreeView.GetNodeID(RemNode, 1, IncludeParentID));
    end;
  finally
    uRemDlgStarting := FALSE;
  end;
end;

procedure ViewRemDlg(RemNode: TORTreeNode; InitDlg, IsTemplate: Boolean);
var
  own: TComponent;

begin
  if assigned(RemNode) then
  begin
    own := RemNode.TreeView.Owner.Owner;
    // Owner is the Drawers, Owner.Owner is the Tab
    if (not(own is TForm)) then
      InfoBox('ViewReminderDialog called from an unsupported location.',
        'Reminders in Process', MB_OK or MB_ICONERROR)
    else
      ViewRemDlgFromForm(TForm(own), RemNode, TTemplate(RemNode.Data), InitDlg,
        IsTemplate);
  end;
end;

procedure ViewReminderDialog(RemNode: TORTreeNode; InitDlg: Boolean = TRUE);
begin
  if (assigned(RemNode)) then
    ViewRemDlg(RemNode, InitDlg, FALSE)
  else
    HideReminderDialog;
end;

procedure ViewReminderDialogTemplate(TempNode: TORTreeNode;
  InitDlg: Boolean = TRUE);
begin
  if (assigned(TempNode) and (assigned(TempNode.Data)) and
    (TTemplate(TempNode.Data).IsReminderDialog)) then
    ViewRemDlg(TempNode, InitDlg, TRUE)
  else
    KillReminderDialog(nil);
end;

procedure ViewRemDlgTemplateFromForm(OwningForm: TForm; Template: TTemplate;
  InitDlg, IsTemplate: Boolean);
begin
  if (assigned(OwningForm) and assigned(Template) and Template.IsReminderDialog)
  then
    ViewRemDlgFromForm(OwningForm, nil, Template, InitDlg, IsTemplate)
  else
    KillReminderDialog(nil);
end;

procedure HideReminderDialog;
begin
  if (assigned(frmRemDlg)) then
    frmRemDlg.Hide;
end;

procedure UpdateReminderFinish;
begin
  if (assigned(frmRemDlg)) and (assigned(RemForm.Form)) then
  begin
    frmRemDlg.btnFinish.Enabled := RemForm.CanFinishProc;
    frmRemDlg.UpdateButtons;
  end;
end;

procedure KillReminderDialog(frm: TForm);
begin
  if (assigned(frm) and (assigned(RemForm.Form)) and (frm <> RemForm.Form)) then
    exit;
  if assigned(frmRemDlg) and frmRemDlg.FFinishing then
    exit;
  if (assigned(frmRemDlg)) then
  begin
    frmRemDlg.FExitOK := TRUE;
    frmRemDlg.ResetProcessing;
  end;
  KillObj(@frmRemDlg);
end;

{ TfrmRemDlg }

procedure TfrmRemDlg.ProcessReminder(ARemData: string; NodeID: string);
var
  Rem: TReminder;
  TmpList: TStringList;
  Msg: string;
  Flds, Abort: Boolean;

begin
  Lock;
  try
    FProcessingTemplate := FALSE;
    Rem := GetReminder(ARemData);
    if (FReminder <> Rem) then
    begin
      if (assigned(FReminder)) then
      begin
        Abort := FALSE;
        Flds := FALSE;
        TmpList := TStringList.Create;
        try
          FReminder.FinishProblems(TmpList, Flds);
          if (TmpList.Count > 0) or Flds then
          begin
            TmpList.Insert(0, '   Reminder: ' + FReminder.PrintName);
            if Flds then
                  TmpList.Add('      ' + MissingFieldsTxt);
                  Msg := REQ_TXT + TmpList.Text + CRLF +
                          ' Ignore required items and continue processing?';
                  Abort := (InfoBox(Msg, REQ_HDR, MB_YESNO or MB_DEFBUTTON2) = IDNO);
          end;
        finally
          TmpList.Free;
        end;
        if (Abort) then
          exit;
      end;
      ClearControls(TRUE);
      FReminder := Rem;
      Rem.PCEDataObj := RemForm.PCEObj;
      BuildControls(True);
      UpdateText(nil);
    end;
    PositionTrees(NodeID);
    UpdateButtons;
    Show;
  finally
    Unlock;
  end;
end;

procedure TfrmRemDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRemDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ask, IsWorking: boolean;

begin
  if not FExitOK then
  begin
    ClearPostValidateMag(Self);
    isWorking := PXRMWorking;
    try
      if isWorking then
        ask := CanAbort
      else
        ask := True;
      if ask then
      begin
        if (assigned(FReminder)) then
          FReminder.closeReportView;
        CanClose := KillAll;
        if CanClose then
          DoAbort;
      end
      else
        CanClose := False;
    finally
      if not IsWorking then
        PXRMDoneWorking;
    end;
  end;
end;

procedure TfrmRemDlg.FormCreate(Sender: TObject);
begin
  // reData.Color := ReadOnlyColor;
  // reText.Color := ReadOnlyColor;
  FSCCond := EligbleConditions(RemForm.PCEObj);
  (* FSCRelated  := SCC_NA;
    FAORelated  := SCC_NA;
    FIRRelated  := SCC_NA;       AGP Change 25.2
    FECRelated  := SCC_NA;
    FMSTRelated := SCC_NA;
    FHNCRelated := SCC_NA;
    FCVRelated  := SCC_NA;
    with FSCCond do
    FSCPrompt := (SCAllow or AOAllow or IRAllow or ECAllow or MSTAllow or HNCAllow or CVAllow); *)
  NotifyWhenRemindersChange(RemindersChanged);
  RemForm.DrawerReminderTreeChange(RemindersChanged);
  // RemForm.Drawers.NotifyWhenRemTreeChanges(RemindersChanged);
  KillReminderDialogProc := KillReminderDialog;
  Left := RemDlgLeft;
  Top := RemDlgTop;
  Width := RemDlgWidth;
  Height := RemDlgHeight;
  KeepBounds := True;
  FFinishing := False;
  FAllowAutoRebuild := True;
  FPendingAutoRebuild := False;
  FLockCount := 0;
  uPXRMWorkingCount := 0;
  IgnoreReminderClicks := False;
end;

procedure TfrmRemDlg.FormDestroy(Sender: TObject);
begin
  uPXRMWorkingCount := 0;
  FAllowAutoRebuild := False;
  FPendingAutoRebuild := False;
  if FProcessingTemplate then
    KillObj(@FReminder);
  KillObj(@FClinMainBox);
  // Save the Position and Size of the Reminder Dialog
  RemDlgLeft := Self.Left;
  RemDlgTop := Self.Top;
  RemDlgWidth := Self.Width;
  RemDlgHeight := Self.Height;
  RemDlgSpltr1 := pnlBottom.Height;
  RemDlgSpltr2 := reData.Height;
  // SaveDialogSplitterPos(Name + 'Splitters', pnlBottom.Height, reData.Height);

  RemForm.DisplayPCEProc; // VISTAOR-24268

  RemForm.DrawerRemoveReminderTreeChange(RemindersChanged);
  // RemForm.Drawers.RemoveNotifyWhenRemTreeChanges(RemindersChanged);
  RemoveNotifyRemindersChange(RemindersChanged);
  KillReminderDialogProc := nil;
  ClearControls(TRUE);
  frmRemDlg := nil;
  if (assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
  RemForm.Form := nil;

  if assigned(frmFrame) then
    frmFrame.pdmpCloseReport;
end;

procedure TfrmRemDlg.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  box: TScrollBox;
begin
  box := GetBox(TRUE);
  If RectContains(box.BoundsRect, box.ScreenToClient(MousePos)) then
  begin
    ScrollControl(box, (WheelDelta > 0));
    Handled := TRUE;
  end;
end;

function TfrmRemDlg.CanAbort: boolean;
begin
  Result := (FLockCount = 0);
end;

procedure TfrmRemDlg.DoAbort;
var
  Msg: TMsg;

begin
  clearGlobals;
  clearResults;
  clearInputs;
  uPXRMWorkingCount := 0;
  FAllowAutoRebuild := False;
  FPendingAutoRebuild := False;
  IgnoreReminderClicks := False;
  PeekMessage(Msg, Handle, UM_RESYNCREM, UM_RESYNCREM, PM_REMOVE);
end;

procedure TfrmRemDlg.ClearControls(All: Boolean = FALSE);
var
  oldAutoRebuild: boolean;

  procedure WipeOutControls(const Ctrl: TWinControl);
  var
    cnt1, cnt2, decamt, idx: Integer;
    ACtrl: TControl;

  begin
    idx := Ctrl.ControlCount;
    while idx > 0 do
    begin
      ACtrl := Ctrl.Controls[idx - 1];
      if (ACtrl.Owner = Self) then
      begin
        cnt1 := Ctrl.ControlCount;
        if (ACtrl is TWinControl) then
          WipeOutControls(TWinControl(ACtrl));
        try
          ACtrl.Free;
        except
        end;
        cnt2 := Ctrl.ControlCount;
        decamt := cnt1 - cnt2;
        if decamt < 1 then
          decamt := 1;
      end
      else
        decamt := 1;
      dec(idx, decamt);
    end;
  end;

begin
  oldAutoRebuild := FAllowAutoRebuild;
  FAllowAutoRebuild := False;
  try
    if (All) then
    begin
      WipeOutControls(sb1);
      WipeOutControls(sb2);
    end
    else
      WipeOutControls(GetBox);
  finally
    FAllowAutoRebuild := oldAutoRebuild;
  end;
end;

procedure TfrmRemDlg.ClearMHTest(Rien: string);
var
  MHKillArray: TStringList;
  i, idx, j: Integer;
  TestName: string;
begin
  MHKillArray := TStringList.Create;
  idx := RemindersInProcess.IndexOf(Rien);
  // Find All MH Test in the current Reminders and stored them in a temp Array
  if idx > -1 then
  begin
    if (TReminderDialog(TReminder(RemindersInProcess.Objects[idx])).MHTestArray
      <> nil) and (TReminderDialog(TReminder(RemindersInProcess.Objects[idx]))
      .MHTestArray.Count > 0) then
    begin
      for j := 0 to TReminderDialog(TReminder(RemindersInProcess.Objects[idx]))
        .MHTestArray.Count - 1 do
      begin
        TestName :=
          Piece(TReminderDialog(TReminder(RemindersInProcess.Objects[idx]))
          .MHTestArray.Strings[j], U, 1);
        // TReminderDialog(TReminder(RemindersInProcess.Objects[idx])).MHTestArray.Delete(j);
        MHKillArray.Add(TestName);
      end;
    end;
    if assigned(TReminderDialog(TReminder(RemindersInProcess.Objects[idx]))
      .MHTestArray) then
      FreeAndNil(TReminderDialog(TReminder(RemindersInProcess.Objects[idx]))
        .MHTestArray);
    (* if (TReminderDialog(TReminder(RemindersInProcess.Objects[idx])).MHTestArray <> nil) and
      (TReminderDialog(TReminder(RemindersInProcess.Objects[idx])).MHTestArray.Count = 0) then
      TReminderDialog(TReminder(RemindersInProcess.Objects[idx])).MHTestArray.Free; *)
  end;
  // Check to see if other reminders contains any of the MH test in the temp Array if so set entry to null
  if (MHKillArray.Count > 0) and (RemindersInProcess.Count > 1) then
  begin
    for i := 0 to RemindersInProcess.Count - 1 do
    begin
      if (TReminderDialog(TReminder(RemindersInProcess.Objects[i])).IEN <> Rien)
        and (TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
        .MHTestArray <> nil) and
        (TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
        .MHTestArray.Count > 0) then
      begin
        for j := 0 to TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
          .MHTestArray.Count - 1 do
        begin
          TestName :=
            Piece(TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
            .MHTestArray.Strings[j], U, 1);
          idx := MHKillArray.IndexOf(TestName);
          if idx > -1 then
            MHKillArray.Strings[idx] := '';
        end;
      end;
    end;
  end;
  // Delete the temp file stored in the MH dll for any MH tests names left in the temp array
  if MHKillArray.Count > 0 then
  begin
    for i := 0 to MHKillArray.Count - 1 do
    begin
      if MHKillArray.Strings[i] <> '' then
        RemoveMHTest(MHKillArray.Strings[i]);
    end;
  end;
  if assigned(MHKillArray) then
    FreeandNil(MHKillArray);
end;

procedure TfrmRemDlg.BuildControls(BuildAll: boolean);
var
  i, CtrlIdx, Y, ParentWidth: Integer;
  AutoCtrl, Active, Ctrl: TWinControl;
  LastCB, LastObjCnt: Integer;
  WorkBox, CurrentBox: TScrollBox;
  txt: string;

  function IsOnBox(Component: TComponent): Boolean;
  var
    Prnt: TWinControl;
  begin
    Result := FALSE;
    if (Component is TWinControl) then
    begin
      Prnt := TWinControl(Component).Parent;
      while (assigned(Prnt)) and (not Result) do
      begin
        Result := (Prnt = CurrentBox);
        Prnt := Prnt.Parent;
      end;
    end;
  end;

  procedure SetActiveVars(ActCtrl: TWinControl);
  var
    i: Integer;

  begin
    LastObjCnt := 0;
    LastCB := 0;
    Active := ActCtrl;
    while (assigned(Active) and (Active.Owner <> Self)) do
    begin
      if (assigned(Active.Owner) and (Active.Owner is TWinControl)) then
        Active := TWinControl(Active.Owner)
      else
        Active := nil;
    end;
    Ctrl := Active;
    if (assigned(Ctrl) and IsOnBox(Ctrl)) then
    begin
      if (Active is TORCheckBox) then
        LastCB := Active.Tag;
      if (LastCB = 0) then
      begin
        CtrlIdx := -1;
        for i := 0 to ComponentCount - 1 do
        begin
          if (IsOnBox(Components[i])) then
          begin
            Ctrl := TWinControl(Components[i]);
            if (Ctrl is TORCheckBox) and (Ctrl.Tag <> 0) then
              CtrlIdx := i;
            if (Ctrl = Active) and (CtrlIdx >= 0) then
            begin
              LastCB := Components[CtrlIdx].Tag;
              LastObjCnt := (i - CtrlIdx);
              break;
            end;
          end;
        end;
      end;
    end;
  end;

var
  LockedDrawingSetOnCurrentBox: Boolean;
begin
  LockedDrawingSetOnCurrentBox := False;
  try
    if BuildAll then
      Lock;
    try
      if (assigned(FReminder)) then
      begin
        CurrentBox := GetBox(TRUE);
        Y := CurrentBox.VertScrollBar.Position;
        if BuildAll then
        begin
          WorkBox := GetBox;
          ClearControls;
        end
        else
        begin
          WorkBox := CurrentBox;
          CurrentBox.LockDrawing;
          LockedDrawingSetOnCurrentBox := True;
          CurrentBox.Invalidate;
        end;
        try
          WorkBox.HorzScrollBar.Position := 0;
          WorkBox.VertScrollBar.Position := 0;
          if FProcessingTemplate then
            txt := 'Reminder Dialog Template'
          else
            txt := 'Reminder Resolution';
          Caption := txt + ': ' + FReminder.PrintName;
          FReminder.OnNeedRedraw := nil;
          ParentWidth := CurrentBox.Width - ScrollBarWidth - 6;
          SetActiveVars(ActiveControl);
          AutoCtrl := FReminder.BuildControls(ParentWidth, WorkBox, Self, BuildAll);
          WorkBox.HorzScrollBar.Position := 0;
          WorkBox.VertScrollBar.Position := Y;
        finally
          if BuildAll then
            BoxUpdateDone
          else
            if LockedDrawingSetOnCurrentBox then
            begin
              CurrentBox.UnlockDrawing;
              LockedDrawingSetOnCurrentBox := False;
            end;
        end;
        if (LastCB <> 0) and (BuildAll or (assigned(AutoCtrl) and (ActiveControl <> AutoCtrl))) then
        begin
          CurrentBox := GetBox(TRUE);
          if assigned(AutoCtrl) then
          begin
            if assigned(AutoCtrl.Parent) then
            begin
              AutoCtrl.SetFocus;
              if (AutoCtrl is TORComboBox) then
                TORComboBox(AutoCtrl).DroppedDown := TRUE;
            end
            else
              ShowMessage('No Parent Control assigned');
          end
          else
            for i := 0 to ComponentCount - 1 do
            begin
              if (IsOnBox(Components[i])) then
              begin
                Ctrl := TWinControl(Components[i]);
                if (Ctrl is TORCheckBox) and (Ctrl.Tag = LastCB) then
                begin
                  if ((i + LastObjCnt) < ComponentCount) and
                    (Components[i + LastObjCnt] is TWinControl) then
                    TWinControl(Components[i + LastObjCnt]).SetFocus;
                  break;
                end;
              end;
            end;
        end;
        if BuildAll then
          ClearControls;
        FReminder.OnNeedRedraw := ControlsChanged;
        FReminder.OnTextChanged := UpdateText;
      end;
    finally
      if BuildAll then
        Unlock;
    end;
  finally
    if LockedDrawingSetOnCurrentBox then
      CurrentBox.UnlockDrawing;
  end;
end;

function TfrmRemDlg.GetBox(Other: Boolean = FALSE): TScrollBox;
begin
  if (FUseBox2 xor Other) then
    Result := sb2
  else
    Result := sb1;
end;

procedure TfrmRemDlg.BoxUpdateDone;
var
  tryCount: Integer;
  Done: boolean;

  // Not sure why, but sometimes setting Visible to true could cause errors
begin
  tryCount := 0;
  Done := False;
  repeat
    try
      if FUseBox2 then
      begin
        sb1.Visible := False;
        sb2.Visible := True;
      end
      else
      begin
        sb2.Visible := False;
        sb1.Visible := True;
      end;
      Done := True;
    except
      inc(tryCount);
      if tryCount > 3 then
        raise
      else
        TResponsiveGUI.ProcessMessages;
    end;
  until Done;
  FUseBox2 := not FUseBox2;
  ClearControls;
  if ScreenReaderSystemActive then
    amgrMain.RefreshComponents;
  TResponsiveGUI.ProcessMessages; // allows new ScrollBox to repaint
end;

procedure TfrmRemDlg.ControlsChanged(Sender: TObject);
begin
  if FAllowAutoRebuild and (not FPendingAutoRebuild) then
  begin
    if FLockCount = 0 then
      RequestRebuild
    else
      FPendingAutoRebuild := True;
  end;
end;

procedure TfrmRemDlg.UMMessageBox(var Message: TMessage);
var
  prompt: TRemPrompt;
  msg, hdr: string;

begin
  Message.Result := 0;
  if FMessageBoxText = '' then exit;
  prompt := TRemPrompt(Message.LParam);
  hdr := Piece(FMessageBoxText, U, 1);
  msg := Piece(FMessageBoxText, U, 2);
  InfoBox(msg, hdr, MB_OK or MB_ICONERROR);
  if assigned(prompt) and assigned(prompt.CurrentControl) then
    TCPRSDialogFieldEdit(prompt.CurrentControl).SetFocus;
  ClearPostValidateMag(Self);
  FMessageBoxText := '';
end;

procedure TfrmRemDlg.UMResyncRem(var Message: TMessage);
var
  i: integer;
  evnt: TNotifyEvent;

begin
  if Message.WParam = 0 then
  begin
    IgnoreReminderClicks := True;
    try
      BuildControls(False);
    finally
      PXRMDoneWorking;
      FAllowAutoRebuild := True;
      PostMessage(Handle, UM_RESYNCREM, 1, 0);
    end;
  end
  else
  begin
    try
      if assigned(RemDlgResyncElements) then
      begin
        for i := 0 to RemDlgResyncElements.Count - 1 do
          with RemDlgResyncElements[i] do
          begin
            evnt := cb.OnClick;
            try
              cb.OnClick := nil;
              cb.Checked := elem.Checked;
            finally
              cb.OnClick := evnt;
            end;
          end;
        RemDlgResyncElements.Clear;
      end;
    finally
      IgnoreReminderClicks := False;
    end;
  end;
end;

procedure TfrmRemDlg.UMValidateMag(var Message: TMessage);
begin
  HandlePostValidateMag(Message);
end;

procedure TfrmRemDlg.Unlock;
begin
  if FLockCount > 0 then
    dec(FLockCount);
  if (not FExitOK) and FPendingAutoRebuild and (FLockCount = 0) then
    RequestRebuild;
end;

procedure TfrmRemDlg.sbResize(Sender: TObject);
begin
  { If you remove this logic you will get an infinite loop in some cases }
  if (FLastWidth <> GetBox(TRUE).ClientWidth) then
    ControlsChanged(Sender);
end;

procedure TfrmRemDlg.UpdateText(Sender: TObject);
const
  BadType = TPCEDataCat(-1);
var
  TopIdx, i, LastPos, CurPos, TxtStart: Integer;
  Cat, LastCat: TPCEDataCat;
  Rem: TReminderDialog;
  TmpData: TORStringList;
  Bold: Boolean;
  tmp: string;
  AStringList: TStringList;
begin
  reText.LockDrawing;
  try
    TopIdx := SendMessage(reText.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
    reText.Clear;
    LastPos := reText.SelStart;
    reText.SelAttributes.Style := reText.SelAttributes.Style - [fsBold];
    i := 0;
    repeat
      if FProcessingTemplate then
        Rem := FReminder
      else
        Rem := TReminder(RemindersInProcess.Objects[i]);
      if Assigned(Rem) then
      begin
        AStringList := TStringList.Create;
        try
          Rem.AddText(AStringList);
          reText.AddString(AStringList.Text);
        finally
          FreeAndNil(AStringList);
        end;
        reText.SelStart := MaxInt;
        CurPos := reText.SelStart;
        if (Rem = FReminder) then
        begin
          reText.SelStart := LastPos;
          reText.SelLength := CurPos - LastPos;
          reText.SelAttributes.Style := reText.SelAttributes.Style + [fsBold];
          reText.SelLength := 0;
          reText.SelStart := CurPos;
          reText.SelAttributes.Style := reText.SelAttributes.Style - [fsBold];
        end;
        LastPos := CurPos;
      end;
      inc(i);
    until (FProcessingTemplate or (i >= RemindersInProcess.Count));
    if ((not FProcessingTemplate) and (reText.Lines.Count > 0)) then
    begin
      reText.InsertStringBefore(ClinRemText(RemForm.PCEObj.Location) + #13#10);
      reText.SelStart := 0;
      reText.SelLength := length(ClinRemText(RemForm.PCEObj.Location));
      reText.SelAttributes.Style := reText.SelAttributes.Style - [fsBold];
      reText.SelLength := 0;
      reText.SelStart := MaxInt;
    end;
    SendMessage(reText.Handle, EM_LINESCROLL, 0, TopIdx);
  finally
    reText.UnlockDrawing;
  end;

  TmpData := TORStringList.Create;
  try
    reData.Clear;
    LastCat := BadType;
    tmp := RemForm.PCEObj.StrVisitType(FSCRelated, FAORelated, FIRRelated,
      FECRelated, FMSTRelated, FHNCRelated, FCVRelated, FSHDRelated,
      FCLRelated);
    if FProcessingTemplate then
    begin
      if assigned(FReminder) then
        i := GetReminderData(FReminder, TmpData)
      else
        i := 0;
    end
    else
      i := GetReminderData(TmpData);
    if (tmp = '') and (i = 0) then
      reData.Lines.Insert(0, TX_NOPCE);
    TmpData.Sort;
    reData.LockDrawing;
    try
      TopIdx := SendMessage(reData.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
      reData.SelAttributes.Style := reData.SelAttributes.Style - [fsBold];
      if tmp <> '' then
        reData.SelText := tmp + CRLF;
      i := 0;
      while i < TmpData.Count do
      begin
        tmp := TmpData[i];
        TxtStart := 2;
        Bold := FALSE;
        Cat := TPCEDataCat(ord(tmp[1]) - ord('A'));
        if (LastCat <> Cat) or (Cat = pdcVital) then
        begin
          if (Cat = pdcVital) then
            inc(TxtStart);
          if (LastCat <> BadType) then
          begin
            reData.SelText := CRLF;
            reData.SelStart := MaxInt;
          end;
          reData.SelText := PCEDataCatText[Cat];
          reData.SelStart := MaxInt;
          LastCat := Cat;
        end
        else
        begin
          reData.SelText := ', ';
          reData.SelStart := MaxInt;
        end;
        repeat
          if (TRemData(TmpData.Objects[i]).Parent.Reminder = FReminder) then
            Bold := TRUE;
          inc(i);
        until (i >= TmpData.Count) or (TmpData[i] <> tmp);
        if (Bold) then
          reData.SelAttributes.Style := reData.SelAttributes.Style + [fsBold];
        reData.SelText := copy(tmp, TxtStart, MaxInt);
        reData.SelStart := MaxInt;
        if (Bold) then
          reData.SelAttributes.Style := reData.SelAttributes.Style - [fsBold];
      end;
      SendMessage(reData.Handle, EM_LINESCROLL, 0, TopIdx);
    finally
      reData.UnlockDrawing;
    end;
  finally
    TmpData.Free;
  end;
end;

procedure TfrmRemDlg.btnClearClick(Sender: TObject);
var
  tmp, TmpNode: string;
  i: Integer;
  OK: Boolean;

begin
  if PXRMWorking then exit;
  try
    if (assigned(FReminder)) then
    begin
      try
        Self.btnClear.Enabled := FALSE;
        i := RemindersInProcess.IndexOf(FReminder.IEN);
        if (i >= 0) then
        begin
          if (FReminder.Processing) then
            OK := (InfoBox('Clear all reminder resolutions for ' +
              FReminder.PrintName, 'Clear Reminder Processing',
              MB_YESNO or MB_DEFBUTTON2) = ID_YES)
          else
            OK := TRUE;
          if (OK) then
          begin
  //          immProcedureCnt := 0;
            ClearMHTest(FReminder.IEN);
            FReminder.closeReportView;
            RemindersInProcess.Delete(i);
            tmp := (FReminder as TReminder).RemData;
            // clear should never be active if template
            TmpNode := (FReminder as TReminder).CurrentNodeID;
            KillObj(@FReminder);
            ProcessReminder(tmp, TmpNode);
          end;
        end;
      finally
        clearResults;
        clearInputs;
        Self.btnClear.Enabled := TRUE;
      end;
    end;
  finally
    PXRMDoneWorking;
  end;
end;

procedure TfrmRemDlg.btnCancelClick(Sender: TObject);
var
  ask, isWorking: boolean;

begin
  isWorking := PXRMWorking;
  try
    if IsWorking then
      ask := CanAbort
    else
      ask := True;
    if ask then
    begin
      ClearPostValidateMag(Self);
      Self.btnCancel.Enabled := FALSE;
      try
        if (assigned(FReminder)) then
          FReminder.closeReportView;
        if (KillAll) then
        begin
          DoAbort;
          FExitOK := TRUE;
          frmRemDlg.Release;
          frmRemDlg := nil;
        end;
      finally
        Self.btnCancel.Enabled := TRUE;
      end;
    end;
  finally
    if not IsWorking then
      PXRMDoneWorking;
  end;
end;

procedure TfrmRemDlg.btnCancelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    ClearPostValidateMag(Self);
end;

function TfrmRemDlg.KillAll: Boolean;
var
  i, cnt: Integer;
  Msg, RemWipe: string;
  // ClearMH: boolean;

begin
  // AGP 25.11 Added RemWipe section to cancel button to
  // flag the patient specific dialog to be destroy if not in process.
  RemWipe := '';
  // ClearMH := false;
  if frmFrame.TimedOut or (not assigned(fReminder)) then
  begin
    Result := TRUE;
    exit;
  end;
  if FProcessingTemplate or FSilent then
  begin
    Result := TRUE;
    if FReminder.RemWipe = 1 then
      RemWipe := Piece(FReminder.DlgData, U, 1);
    if (FProcessingTemplate) and (FReminder.Processing) then
    begin
      Msg := Msg + '  ' + FReminder.PrintName + CRLF;
      Msg := 'The Following Reminders are being processed:' + CRLF + CRLF + Msg;
      Msg := Msg + CRLF +
        'Canceling will cause all processing information to be lost.' + CRLF +
        'Do you still want to cancel out of reminder processing?';
      Result := (InfoBox(Msg, 'Cancel Reminder Processing',
        MB_YESNO or MB_DEFBUTTON2) = ID_YES);
    end;
  end
  else
  begin
    Msg := '';
    cnt := 0;
    for i := 0 to RemindersInProcess.Count - 1 do
    begin
      if TReminderDialog(TReminder(RemindersInProcess.Objects[i])).RemWipe = 1
      then
      begin
        if RemWipe = '' then
          RemWipe := TReminder(RemindersInProcess.Objects[i]).IEN
        else
          RemWipe := RemWipe + U + TReminder(RemindersInProcess.Objects[i]).IEN
      end;
      if (TReminder(RemindersInProcess.Objects[i]).Processing) then
      begin
        Msg := Msg + '  ' + TReminder(RemindersInProcess.Objects[i])
          .PrintName + CRLF;
        inc(cnt);
      end;
    end;
    if (Msg <> '') then
    begin
      if (cnt > 1) then
        Msg := 'The Following Reminders are being processed:' + CRLF +
          CRLF + Msg
      else
        Msg := 'The Following Reminder is being processed: ' + CRLF +
          CRLF + Msg;
      Msg := Msg + CRLF +
        'Canceling will cause all processing information to be lost.' + CRLF +
        'Do you still want to cancel out of reminder processing?';
      Result := (InfoBox(Msg, 'Cancel Reminder Processing',
        MB_YESNO or MB_DEFBUTTON2) = ID_YES);
    end
    else
      Result := TRUE;
  end;
  if (Result) then
  begin
    if FProcessingTemplate or FSilent then
    begin
      FReminder.closeReportView;
      if (FReminder.MHTestArray <> nil) and (FReminder.MHTestArray.Count > 0)
      then
      begin
        (* if ClearMH = false then
          begin
          RemoveMHTest('');
          ClearMH := true;
          end; *)
        RemoveMHTest('');
        FreeAndNil(FReminder.MHTestArray);
      end;
    end
    else
    begin
      for i := 0 to RemindersInProcess.Count - 1 do
      begin
//        TReminderDialog(TReminder(RemindersInProcess.Objects[i])).closeReportView;
        if (TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
          .MHTestArray <> nil) and
          (TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
          .MHTestArray.Count > 0) then
        begin
          (* if ClearMH = false then
            begin
            RemoveMHTest('');
            ClearMH := true;
            end; *)
          RemoveMHTest('');
          FreeAndNil(TReminderDialog(TReminder(RemindersInProcess.Objects[i]))
            .MHTestArray);
        end;
      end;
    end;
    ResetProcessing(RemWipe);
  end;
end;

function TfrmRemDlg.GetCurReminderList: Integer;
var
  Sel, Node: TORTreeNode;
  Data: string;
  NodeCheck, Cur: Boolean;

begin
  Result := -1;
  CurReminderList := TORStringList.Create;

  Sel := TORTreeNode(RemForm.DrawerReminderTV.Selected);

  // Sel := TORTreeNode(RemForm.Drawers.tvReminders.Selected);
  NodeCheck := (assigned(Sel) and assigned(FReminder) and
    (Piece(Sel.StringData, U, 1) = RemCode + FReminder.IEN));

  Node := TORTreeNode(RemForm.DrawerReminderTV.Items.GetFirstNode);
  // Node := TORTreeNode(RemForm.Drawers.tvReminders.Items.GetFirstNode);
  while assigned(Node) do
  begin
    Data := TORTreeNode(Node).StringData;
    if (copy(Data, 1, 1) = RemCode) then
    begin
      Delete(Data, 1, 1);
      Data := Node.TreeView.GetNodeID(Node, 1, IncludeParentID) + U + Data;
      if (NodeCheck) then
        Cur := (Node = Sel)
      else
        Cur := (assigned(FReminder)) and (FReminder.IEN = Piece(Data, U, 1));
      if (Cur) then
        Result := CurReminderList.Add(Data)
      else if (Piece(Data, U, 8) = '1') then
        CurReminderList.Add(Data);
    end;
    Node := TORTreeNode(Node.GetNextVisible);
  end;
end;

procedure TfrmRemDlg.getDiagnosisCodes(var codesList: TStrings);
var
dx: TPCEDiag;
i: integer;
begin
  for i := 0 to RemForm.PCEObj.Diagnoses.Count - 1 do
    begin
      dx := TPCEDiag(RemForm.PCEObj.Diagnoses[i]);
      if not inCodesList('POV', dx.Code, codesList) then
        begin
          codesList.Add(dx.DelimitedStr);
        end;

    end;
end;

procedure TfrmRemDlg.getProcedureCodes(var codesList: TStrings);
var
cpt: TPCEProc;
i: integer;
begin
  for i := 0 to RemForm.PCEObj.Procedures.Count - 1 do
    begin
      cpt := TPCEProc(RemForm.PCEObj.Procedures[i]);
      if not inCodesList('POV', cpt.Code, codesList) then
        begin
          codesList.Add(cpt.DelimitedStr);
        end;

    end;
end;

function TfrmRemDlg.inCodesList(codeSys, code: string;
  codesList: TStrings): boolean;
var
i: integer;
temp: string;
begin
  result := false;
  for i := 0 to codesList.count - 1 do
    begin
      Temp := codesList.Strings[i];
      if (Pos(codeSys, temp) > 0) and (Code = Piece(temp, U, 2)) then
        begin
          result := true;
          break;
        end;
    end;
end;

{ This routine is fired as a result of clicking a checkbox.  If we destroy
  the checkbox here we get access violations because the checkbox code is
  still processing the click event after calling this routine.  By posting
  a message we can guarantee that the checkbox is no longer processing the
  click event when the message is handled, preventing access violations. }
procedure TfrmRemDlg.RequestRebuild;
var
  ACount: Integer;
  NeedsRetry: boolean;
begin
  inc(uPXRMWorkingCount);

  // Copying the fix from TfrmRemDlg.BoxUpdateDone
  ACount := 0;
  repeat
    try
      NeedsRetry := False;
      FLastWidth := GetBox(TRUE).ClientWidth;
    except
      Inc(ACount);
      if ACount > 3 then raise;
      TResponsiveGUI.ProcessMessages;
      NeedsRetry := True;
    end;
  until not NeedsRetry;

  try
    FLastWidth := GetBox(TRUE).ClientWidth;
  except
    // do nothing
  end;
  PostMessage(Handle, UM_RESYNCREM, 0, 0);
  FAllowAutoRebuild := False;
  FPendingAutoRebuild := False;
end;

function TfrmRemDlg.NextReminder: string;
var
  idx: Integer;

begin
  Result := '';
  idx := GetCurReminderList;
  try
    inc(idx);
    if (idx < CurReminderList.Count) then
      Result := CurReminderList[idx];
  finally
    KillObj(@CurReminderList);
  end;
end;

function TfrmRemDlg.BackReminder: string;
var
  idx: Integer;

begin
  Result := '';
  idx := GetCurReminderList;
  try
    dec(idx);
    if (idx >= 0) then
      Result := CurReminderList[idx];
  finally
    KillObj(@CurReminderList);
  end;
end;

procedure TfrmRemDlg.ProcessReminderFromNodeStr(value: string);
var
  NodeID: string;
  Data: string;
  i: Integer;

begin
  if (value = '') then
  begin
    UpdateButtons;
    exit;
  end;
  Data := value;
  i := pos(U, Data);
  if (i = 0) then
    i := length(Data);
  NodeID := copy(Data, 1, i - 1);
  Delete(Data, 1, i);
  Data := RemCode + Data;
  ProcessReminder(Data, NodeID);
end;

procedure TfrmRemDlg.btnNextClick(Sender: TObject);
begin
  if PXRMWorking then exit;
  try
    if assigned(FReminder) then
      FReminder.closeReportView;
    ProcessReminderFromNodeStr(NextReminder);
  finally
    RequestRebuild;
    PXRMDoneWorking;
  end;
end;

procedure TfrmRemDlg.btnBackClick(Sender: TObject);
begin
  if PXRMWorking then exit;
  try
    if assigned(FReminder) then
      FReminder.closeReportView;
    ProcessReminderFromNodeStr(BackReminder);
  finally
    RequestRebuild;
    PXRMDoneWorking;
  end;
end;

procedure TfrmRemDlg.UpdateButtons;
begin
  if (assigned(frmRemDlg)) and (not FProcessingTemplate) then
  begin
    btnBack.Enabled := btnFinish.Enabled and (BackReminder <> '');
    btnNext.Enabled := btnFinish.Enabled and (NextReminder <> '');
    btnClinMaint.Enabled := (not assigned(FClinMainBox));
  end;
end;

procedure TfrmRemDlg.PositionTrees(NodeID: string);
begin
  if (assigned(PositionList)) and (not FProcessingTemplate) then
  begin
    if (assigned(FReminder)) then
      (FReminder as TReminder).CurrentNodeID := NodeID;
    PositionList.Notify(FReminder);
  end;
end;

procedure TfrmRemDlg.btnFinishClick(Sender: TObject);
var
  i, c, cnt, lcnt, OldRemCount, OldCount, T: Integer;
  CurDate, CurLoc, newStatus: string;
  LastDate, LastLoc, immFirst, immSecond: string;
  Rem: TReminderDialog;
  Reminder: TReminder;
  // Prompt: TRemPrompt;
  RData: TRemData;
  TmpData: TORStringList;
  OrderList: TStringList;
  TmpText: TStringList;
  TmpList: TStringList;
  VitalList: TStringList;
  MHList: TStringList;
  WHList: TStringList;
  MSTList: TStringList;
  immCPTList: TStringList;
  HistData, PCEObj: TPCEData;
  pceProc: TPCEProc;
  Cat: TPCEDataCat;
  VisitParent, Msg, tmp: string;
  DelayEvent: TOrderDelayEvent;
  Hist: Boolean;
  v: TVitalType;
  UserStr: string;
  BeforeLine, AfterTop: Integer;
  GAFScore: Integer;
  TempDate: TFMDateTime;
  TestStaff: Int64;
  DoOrders, Done, Kill, Flds: Boolean;
  TR: TEXTRANGE;
  buf: array [0 .. 3] of char;
  AddLine: Boolean;
  Process, StoreVitals, GenFind: Boolean;
  PCEType: TPCEType;
  WHNode, WHPrint, WHResult, WHTmp, WHValue, visitStr: String;
  WHType: TStrings;
  // Test: String;
  MHLoc, WHCnt, x: Integer;
  WHArray: TStringList;
  GecRemIen, GecRemStr, RemWipe, RemId, GenRemId: String;
  GenFindingList: TStringList;
  AVisitStr, FileCat, FileDate, FNoteDate, strData: string;
  RemList: TStringList;
  cptList, povList, codesList: TStrings;
  itm: TPCEItem;

  procedure Add(PCEItemClass: TPCEItemClass);
  var
    itm: TPCEItem;
    strData, tmp: string;
    vimmData: TVimmResult;

  begin
    if (Cat in MSTDataTypes) then
    begin
      tmp := Piece(TmpData[i], U, pnumMST);
      if (tmp <> '') then
      begin
        MSTList.Add(tmp);
        tmp := TmpData[i];
        setpiece(tmp, U, pnumMST, '');
        TmpData[i] := tmp;
      end;
    end;
    itm := PCEItemClass.Create;
    try
      strData := copy(TmpData[i], 2, MaxInt);
      itm.SetFromString(strData);
      TmpList.AddObject('', itm);
      if Cat = pdcHF then
        itm.FGecRem := GecRemStr;
      case Cat of
        pdcDiag:
          begin
            PCEObj.SetDiagnoses(TmpList, FALSE);
//            codesList.Add(strData);
          end;
        pdcProc:
          begin
            PCEObj.SetProcedures(TmpList, FALSE);
//            codesList.Add(strData);
          end;
        pdcImm:
          begin
            vimmData := TVimmResult(TmpData.objects[i]);
//            if hist then SetPiece(vimmData.DelimitedStr, U, 11, '');

            PCEObj.SetImmunizations(TmpList, FALSE, vimmData);
            if not Hist then
              codesList.Add(vimmData.DelimitedStr);
          end;

        pdcSkin:
          begin
            vimmData := TVimmResult(TmpData.objects[i]);
//            if hist then SetPiece(vimmData.DelimitedStr, U, 11, '');
            PCEObj.SetSkinTests(TmpList, FALSE, vimmData);
              if not Hist then
                codesList.Add(vimmData.DelimitedStr);
//            PCEObj.SetSkinTests(TmpList, FALSE);
          end;

        pdcPED:
          PCEObj.SetPatientEds(TmpList, FALSE);
        pdcHF:
          PCEObj.SetHealthFactors(TmpList, FALSE);
        pdcExam:
          PCEObj.SetExams(TmpList, FALSE);
        pdcGenFinding:
          PCEObj.SetGenFindings(TmpList, FALSE);
        pdcStandardCodes:
          PCEObj.SetStandardCodes(TmpList, FALSE);
      end;
      itm.Free;
      TmpList.Clear;
    except
      itm.Free;
    end;
  end;

  procedure SaveMSTData(MSTVal: string);
  var
    vdate, s1, s2, prov, FType, FIEN: string;

  begin
    if MSTVal <> '' then
    begin
      s1 := Piece(MSTVal, ';', 1);
      vdate := Piece(MSTVal, ';', 2);
      prov := Piece(MSTVal, ';', 3);
      FIEN := Piece(MSTVal, ';', 4);
      if FIEN <> '' then
      begin
        s2 := s1;
        s1 := '';
        FType := RemDataCodes[rdtExam];
      end
      else
      begin
        s2 := '';
        FType := RemDataCodes[rdtHealthFactor];
      end;
      SaveMSTDataFromReminder(vdate, s1, prov, FType, FIEN, s2);
    end;
  end;

  Procedure AddTextToNote(aValue: String);
  begin
   //Update any editable text limits
   if assigned(RemForm.Form) then
   begin
    if (RemForm.Form = frmNotes) then
      frmNotes.LimitEditableNote
    else if (RemForm.Form = frmConsults) then
      frmConsults.LimitEditableNote
   end;
   //Add the text to the note object
   RemForm.NewNoteRE.SelText := aValue;
  end;

begin
  if PXRMWorking then exit;
  FFinishing := True;
  Lock;
  try
    Kill := FALSE;
    GecRemIen := '0';
    WHList := nil;
    Rem := nil;
    Reminder := nil;
    RemWipe := ''; // AGP CHANGE 24.8
    GenFind := true;
    TmpText := nil;
    try
      Self.btnFinish.Enabled := FALSE;
      OldRemCount := ProcessedReminders.Count;
      if not FProcessingTemplate then
        ProcessedReminders.Notifier.BeginUpdate;
      try
        TmpList := TStringList.Create;
        RemList := TStringList.create;
        codesList := TStringList.Create;
        try
          i := 0;
          repeat
            // AGP Added RemWipe section this section will determine if the Dialog is a patient specific
            if FProcessingTemplate or (i < RemindersInProcess.Count) then
            begin
              if FProcessingTemplate then
              begin
                Rem := FReminder;
                if assigned(Rem) and (Rem.RemWipe = 1) then
                  RemWipe := Piece(Rem.DlgData, U, 1);
              end
              else
              begin
                Rem := TReminder(RemindersInProcess.Objects[i]);
                RemList.Add(TReminderDialog(TReminder(RemindersInProcess.Objects[i])).IEN);
                if TReminderDialog(TReminder(RemindersInProcess.Objects[i])).RemWipe = 1 then
                begin
                  if RemWipe = '' then
                    RemWipe := TReminder(RemindersInProcess.Objects[i]).IEN
                  else
                    RemWipe := RemWipe + U +
                      TReminder(RemindersInProcess.Objects[i]).IEN;
                end;
              end;

              Flds := FALSE;
              OldCount := TmpList.Count;
              if assigned(Rem) then
              begin
                Rem.FinishProblems(TmpList, Flds);
                Rem.closeReportView;
                if (OldCount <> TmpList.Count) or Flds then
                begin
                  TmpList.Insert(OldCount, '');
                  if not FProcessingTemplate then
                    TmpList.Insert(OldCount + 1, '   Reminder: ' + Rem.PrintName);
                  if Flds then
                    TmpList.Add('      ' + MissingFieldsTxt);
                end;
              end;
              inc(i);
            end;
          until (FProcessingTemplate or (i >= RemindersInProcess.Count));

          if FProcessingTemplate then
            PCEType := ptTemplate
          else
            PCEType := ptReminder;

          Process := TRUE;
          if (TmpList.Count > 0) then
          begin
            Msg := REQ_TXT + TmpList.Text;
            InfoBox(Msg, REQ_HDR, MB_OK);
            Process := FALSE;
          end
          else
          begin
            TmpText := TStringList.Create;
            try
              if (not FProcessingTemplate) and (not InsertRemTextAtCursor) then
                RemForm.NewNoteRE.SelStart := MaxInt; // Move to bottom of note
              AddLine := FALSE;
              BeforeLine := SendMessage(RemForm.NewNoteRE.Handle,
                EM_EXLINEFROMCHAR, 0, RemForm.NewNoteRE.SelStart);
              if (SendMessage(RemForm.NewNoteRE.Handle, EM_LINEINDEX, BeforeLine,
                0) <> RemForm.NewNoteRE.SelStart) then
              begin
                RemForm.NewNoteRE.SelStart :=
                  SendMessage(RemForm.NewNoteRE.Handle, EM_LINEINDEX,
                  BeforeLine + 1, 0);
                inc(BeforeLine);
              end;
              if (RemForm.NewNoteRE.SelStart > 0) then
              begin
                if (RemForm.NewNoteRE.SelStart = 1) then
                  AddLine := TRUE
                else
                begin
                  TR.chrg.cpMin := RemForm.NewNoteRE.SelStart - 2;
                  TR.chrg.cpMax := TR.chrg.cpMin + 2;
                  TR.lpstrText := @buf;
                  SendMessage(RemForm.NewNoteRE.Handle, EM_GETTEXTRANGE, 0,
                    LPARAM(@TR));
                  if (buf[0] <> #13) or (buf[1] <> #10) then
                    AddLine := TRUE;
                end;
              end;
              if FProcessingTemplate then
              begin
                if assigned(FReminder) then
                  FReminder.AddText(TmpText);
              end
              else
              begin
                for i := 0 to RemindersInProcess.Count - 1 do
                  TReminder(RemindersInProcess.Objects[i]).AddText(TmpText);
              end;
              if (TmpText.Count > 0) then
              begin
                if not FProcessingTemplate then
                begin
                  tmp := ClinRemText(RemForm.PCEObj.Location);
                  if (tmp <> '') then
                  begin
                    i := RemForm.NewNoteRE.Lines.IndexOf(tmp);
                    if (i < 0) or (i > BeforeLine) then
                    begin
                      TmpText.Insert(0, tmp);
                      if (RemForm.NewNoteRE.SelStart > 0) then
                        TmpText.Insert(0, '');
                      if (BeforeLine < RemForm.NewNoteRE.Lines.Count) then
                        TmpText.Add('');
                    end;
                  end;
                end;
                if AddLine then
                  TmpText.Insert(0, '');
                CheckBoilerplate4Fields(TmpText,
                  'Unresolved template fields from processed Reminder Dialog(s)');
                if TmpText.Count = 0 then
                  Process := FALSE
                else
                begin
                  if RemForm.PCEObj.NeedProviderInfo and
                    MissingProviderInfo(RemForm.PCEObj, PCEType) then
                    Process := FALSE
  //                else
  //                begin
  //                  RemForm.NewNoteRE.SelText := TmpText.Text;
  //                  SpeakTextInserted;
  //                end;
                end;
              end;
              if (Process) then
              begin
                SendMessage(RemForm.NewNoteRE.Handle, EM_SCROLLCARET, 0, 0);
                AfterTop := SendMessage(RemForm.NewNoteRE.Handle,
                  EM_GETFIRSTVISIBLELINE, 0, 0);
                SendMessage(RemForm.NewNoteRE.Handle, EM_LINESCROLL, 0,
                  -1 * (AfterTop - BeforeLine));
              end;
            finally
  //            TmpText.Free;
            end;
          end;
//          if CheckDailyHospitalization(RemForm.PCEObj) = False then
//          begin
//            Process := False;
//          end;
          if (Process) then
          begin
            PCEObj := RemForm.PCEObj;
            (* AGP CHANGE 23.2 Remove this section base on the Clinical Workgroup decision
              if FSCPrompt and (ndSC in PCEObj.NeededPCEData) then
              btnVisitClick(nil);
              PCEObj.SCRelated  := FSCRelated;
              PCEObj.AORelated  := FAORelated;
              PCEObj.IRRelated  := FIRRelated;
              PCEObj.ECRelated  := FECRelated;
              PCEObj.MSTRelated := FMSTRelated;
              PCEObj.HNCRelated := FHNCRelated;
              PCEObj.CVRelated  := FCVRelated; *)
            if not FProcessingTemplate then
            begin
              for i := 0 to RemindersInProcess.Count - 1 do
              begin
                Reminder := TReminder(RemindersInProcess.Objects[i]);
                if (Reminder.Processing) and
                  (ProcessedReminders.IndexOf(Reminder.RemData) < 0) then
                  ProcessedReminders.Add(copy(Reminder.RemData, 2, MaxInt));
              end;
            end;
            OrderList := TStringList.Create;
            GenFindingList := TStringList.Create;
            try
              MHList := TStringList.Create;
              try
                StoreVitals := TRUE;
                VitalList := TStringList.Create;
                try
                  WHList := TStringList.Create;
                  try
                    MSTList := TStringList.Create;
                    try
                      TmpData := TORStringList.Create;
                      try
                        UserStr := '';
                        LastDate := U;
                        LastLoc := U;
                        VisitParent := '';
                        HistData := nil;
                        for Hist := FALSE to TRUE do
                        begin
                          TmpData.Clear;
                          if FProcessingTemplate then
                          begin
                            if assigned(FReminder) then
                            begin
                              i := GetReminderData(FReminder, TmpData, TRUE, Hist);
                              RemId := FReminder.IEN;
                            end;
                          end
                          else
                          begin
                            GetReminderData(TmpData, TRUE, Hist);
                            if assigned(Reminder) then RemId := Piece(Reminder.RemData, U, 1);
                          end;
                          if (TmpData.Count > 0) then
                          begin
  //                          if Hist then
  //                            TmpData.SortByPieces([pnumVisitDate, pnumVisitLoc])
  //                          else
  //                            TmpData.Sort;
                            if Hist then
                              TmpData.SortByPieces([pnumVisitDate, pnumVisitLoc]);
                            TmpData.RemoveDuplicates;
                            TmpList.Clear;
                            for i := 0 to TmpData.Count - 1 do
                            begin
                              if (Hist) then
                              begin
                                CurDate := Piece(TmpData[i], U, pnumVisitDate);
                                CurLoc := Piece(TmpData[i], U, pnumVisitLoc);
                                if (CurDate = '') then
                                begin
                                  if RemForm.PCEObj.VisitDateTime < 1 then
                                  begin
                                    if Encounter.DateTime < 1 then
                                      CurDate := FloatToStr(FMNow)
                                    else
                                      CurDate := FloatToStr(Encounter.DateTime);
                                  end
                                  else
                                    CurDate := FloatToStr(RemForm.PCEObj.VisitDateTime);
                                end;
                                if (LastDate <> CurDate) or (LastLoc <> CurLoc)
                                then
                                begin
                                  if (assigned(HistData)) then
                                  begin
                                    if not HistData.Save then exit;
                                    HistData.Free;
                                  end;
                                  LastDate := CurDate;
                                  LastLoc := CurLoc;
                                  HistData := TPCEData.Create;
                                  HistData.DateTime := MakeFMDateTime(CurDate);
                                  HistData.VisitCategory := 'E';
                                  if (VisitParent = '') then
                                    VisitParent :=
                                      GetVisitIEN(RemForm.NoteList.ItemIEN);
                                  HistData.Parent := VisitParent;
                                  if (StrToIntDef(CurLoc, 0) = 0) then
                                    CurLoc := '0' + U + CurLoc;
                                  HistData.HistoricalLocation := CurLoc;
                                  PCEObj := HistData;
                                end;
                              end;
                              Cat := TPCEDataCat(ord(TmpData[i][1]) - ord('A'));
                              // check this for multiple process
                              // RData := TRemData(TmpData.Objects[i]);
                              if Cat = pdcHF then
                              begin
                                if not FProcessingTemplate and
                                  (GecRemIen <> TRemData(TmpData.Objects[i])
                                  .Parent.Reminder.IEN) then
                                begin
                                  GecRemIen := TRemData(TmpData.Objects[i])
                                    .Parent.Reminder.IEN;
                                  GecRemStr := CheckGECValue('R' + GecRemIen,
                                    PCEObj.NoteIEN, RemForm.PCEObj.VisitString);
                                  // SetPiece(TmpData.Strings[i],U,11,GecRemStr);
                                end;
                                if FProcessingTemplate then
                                begin
                                  if GecRemIen <> Rem.IEN then
                                  begin
                                    GecRemIen := Rem.IEN;
                                    GecRemStr :=
                                      CheckGECValue(Rem.IEN, PCEObj.NoteIEN,
                                        RemForm.PCEObj.VisitString)
                                  end;
                                end;
                              end;
                              case Cat of
                                // pdcVisit:
                                pdcDiag:
                                  Add(TPCEDiag);
                                pdcProc:
                                  Add(TPCEProc);
                                pdcImm:
                                    Add(TPCEImm);
                                pdcSkin:
                                  Add(TPCESkin);
                                pdcPED:
                                  Add(TPCEPat);
                                pdcHF:
                                  Add(TPCEHealth);
                                pdcExam:
                                  Add(TPCEExams);
                                pdcStandardCodes:
                                  Add(TStandardCode);

                                pdcVital:
                                  if (StoreVitals) then
                                  begin
                                    tmp := Piece(TmpData[i], U, 2);
                                    for v := low(TValidVitalTypes)
                                      to high(TValidVitalTypes) do
                                    begin
                                      if (tmp = VitalCodes[v]) then
                                      begin
                                        if (UserStr = '') then
                                          UserStr := GetVitalUser;

                                        if (FVitalsDate = 0) then
                                        begin
                                          FVitalsDate :=
                                          TRemData(TmpData.Objects[i])
                                          .Parent.VitalDateTime;
                                          StoreVitals :=
                                          ValidVitalsDate(FVitalsDate, TRUE,
                                          FALSE); // AGP Change 26.1
                                          if (not StoreVitals) then
                                          break;
                                        end;

                                        tmp := GetVitalStr(v,
                                          Piece(TmpData[i], U, 3), '', UserStr,
                                          FloatToStr(FVitalsDate));
                                        if (tmp <> '') then
                                          VitalList.Add(tmp);
                                        break;
                                      end;
                                    end;
                                  end;

                                pdcOrder:
                                  OrderList.Add(TmpData[i]);
                                pdcGenFinding:
                                  begin
                                   if pos('R',RemID) > 0 then GenRemId := 'R' + TRemData(TmpData.Objects[i]).Parent.Reminder.IEN
                                   else GenRemId := RemID;
                                    GenFindingList.Add(GenRemId + U + TmpData[i]);
                                    add(TGenFindings);
                                  end;
                                pdcMH:
                                  MHList.Add(TmpData[i]);
                                pdcWHR:
                                  begin
                                    WHNode := TmpData.Strings[i];
                                    setpiece(WHNode, U, 11,
                                      TRemData(TmpData.Objects[i])
                                      .Parent.WHResultChk);
                                    WHList.Add(WHNode);
                                  end;

                                pdcWH:
                                  begin
                                    WHPrint := TRemData(TmpData.Objects[i])
                                      .Parent.WHPrintDevice;
                                    WHNode := TmpData.Strings[i];
                                    setpiece(WHNode, U, 11,
                                      TRemData(TmpData.Objects[i])
                                      .Parent.WHResultNot);
                                    setpiece(WHNode, U, 12, Piece(WHPrint, U, 1));
                                    setpiece(WHNode, U, 13,
                                      TRemData(TmpData.Objects[i])
                                      .Parent.Reminder.WHReviewIEN);
                                    // AGP CHANGE 23.13
                                    WHList.Add(WHNode);
                                  end;
                              end;
                            end;

                            if (GenFindingList.Count > 0) and GenFind then
                              begin
                                GenFind := false;
                                if RemForm.PCEObj.IsSecondaryVisit then
                                  begin
                                    FileCat := GetLocSecondaryVisitCode(RemForm.PCEObj.Location);
                                    FileDate := FloatToStr(RemForm.PCEObj.NoteDateTime);
                                    AVisitStr :=  IntToStr(RemForm.PCEObj.Location) + ';' + FileDate + ';' + FileCat;
                                  end
                                else AVisitStr := RemForm.PCEObj.VisitString;
                                if ValidateGenFindingData(GenFindingList, Patient.DFN, AVisitStr, '',
                                  IntToStr(RemForm.PCEObj.NoteIEN), IntToStr(user.DUZ),
                                  IntToStr(RemForm.PCEObj.Providers.PCEProviderForce)) = FALSE then
                                  exit;
                                SaveGenFindingData(GenFindingList, Patient.DFN, AVisitStr, '',
                                  IntToStr(RemForm.PCEObj.NoteIEN), IntToStr(user.DUZ),
                                  IntToStr(RemForm.PCEObj.Providers.PCEProviderForce));
                              end;

  //                          if tmpText <> nil then
  //                            begin
  //                              RemForm.NewNoteRE.SelText := TmpText.Text;
  //                              FreeAndNil(tmpText);
  //                            end;
  //                          SpeakTextInserted;

                            if (Hist) then
                            begin
                              if (assigned(HistData)) then
                              begin
                                if not HistData.Save then exit;
                                HistData.Free;
                                HistData := nil;
                              end;
                            end
                            else
                            begin
                              if codesList.Count > 0 then
                                begin
                                  cptList := TStringList.Create;
                                  povList := TStringList.create;
                                    try
                                      tmpList.Clear;
                                      getDiagnosisCodes(codesList);
                                      getProcedureCodes(codesList);
                                      getBillingCodesList(codesList, IntToStr(remForm.PCEObj.VisitIEN), cptList);
                                      if cptList.Count > 0 then
                                        begin
                                          for c := 0 to cptList.Count -1 do
                                            begin
                                              strData := cptList[c];
                                              if Pos('CPT', Piece(strData, U, 1)) > 0 then
                                                begin
                                                  itm := TPCEProc.Create;
                                                  if remForm.PCEObj.Providers.PCEProvider > 0 then
                                                    SetPiece(strData, U, 6, IntToStr(remForm.PCEObj.Providers.PCEProvider));
                                                  itm.SetFromString(strData);
                                                  TmpList.AddObject('', itm);
                                                end
                                              else povList.Add(strData);
                                            end;
                                          pceObj.SetProcedures(tmpList, false);
                                          if povList.Count > 0 then
                                            begin
                                              tmpList.Clear;
                                              for c := 0 to povList.Count - 1 do
                                                begin
                                                  strData := povList[c];
                                                  itm := TPCEDiag.Create;
                                                  itm.SetFromString(strData);
                                                  tmpList.AddObject('', itm);
                                                end;
                                              pceObj.SetDiagnoses(tmpList, false);
                                            end;
                                        end;
                                    finally
                                      for c := 0 to tmpList.Count -1 do
                                        tmpList.Objects[c].Free;
                                      tmpList.Clear;
                                      FreeAndNil(cptList);
                                      FreeAndNil(povList);
                                    end;
                                end;

                              while RemForm.PCEObj.NeedProviderInfo do
                                MissingProviderInfo(RemForm.PCEObj, PCEType);
                              for c := 0 to RemForm.PCEObj.Procedures.Count - 1 do
                                begin
                                  if TPCEProc(RemForm.PCEObj.Procedures[c]).Provider = 0 then
                                    TPCEProc(RemForm.PCEObj.Procedures[c]).Provider :=
                                      RemForm.PCEObj.Providers.PCEProvider;
                                end;
                              if not RemForm.PCEObj.Save then exit;
                              VisitParent :=
                                GetVisitIEN(RemForm.NoteList.ItemIEN);
                            end;
                            if tmpText <> nil then
                              begin
                                AddTextToNote(TmpText.Text);
                                FreeAndNil(tmpText);
                              end;
                            SpeakTextInserted;
                          end
                          else
                          begin
                            if tmpText <> nil then
                              begin
                                AddTextToNote(TmpText.Text);
                                FreeAndNil(tmpText);
                              end;
                            SpeakTextInserted;
                          end;
                        end;

                      finally
                        TmpData.Free;
                      end;

                      for i := 0 to MSTList.Count - 1 do
                        SaveMSTData(MSTList[i]);

                    finally
                      MSTList.Free;
                    end;

                    if (StoreVitals) and (VitalList.Count > 0) then
                    begin
                      VitalList.Insert(0, VitalDateStr + FloatToStr(FVitalsDate));
                      VitalList.Insert(1, VitalPatientStr + Patient.DFN);
                      if IntToStr(RemForm.PCEObj.Location) <> '0' then
                      // AGP change 26.9
                        VitalList.Insert(2, VitalLocationStr +
                          IntToStr(RemForm.PCEObj.Location))
                      else
                        VitalList.Insert(2, VitalLocationStr +
                          IntToStr(RemForm.PCEObj.Location));;
                      tmp := ValAndStoreVitals(VitalList);
                      if (tmp <> 'True') then
                        ShowMsg(tmp);
                    end;

                  finally
                    VitalList.Free;
                  end;

                  if (MHList.Count > 0) then
                  begin
                    TempDate := 0;
                    for i := 0 to MHList.Count - 1 do
                    begin
                      try
                        TempDate := StrToFloat(Piece(MHList[i], U, 4));
                      except
                        on EConvertError do
                          TempDate := 0
                        else
                          raise;
                      end;
                      if (TempDate > 0) then
                      begin
                        TestStaff := StrToInt64Def(Piece(MHList[i], U, 5), 0);
                        if TestStaff <= 0 then
                          TestStaff := User.DUZ;
                        if (Piece(MHList[i], U, 3) = '1') and (MHDLLFound = FALSE)
                        then
                        begin
                          GAFScore := StrToIntDef(Piece(MHList[i], U, 6), 0);
                          if (GAFScore > 0) then
                            SaveGAFScore(GAFScore, TempDate, TestStaff);
                        end
                        else
                        begin
                          if Piece(MHList[i], U, 6) = 'New MH dll' then
                          begin
                            // The dll take date and time the original code took only date.
                            if assigned(FReminder) and
                              (Encounter.Location <> FReminder.PCEDataObj.Location)
                            then
                              MHLoc := FReminder.PCEDataObj.Location
                            else
                              MHLoc := Encounter.Location;
                            if assigned(FReminder) then
                              TempDate := FReminder.PCEDataObj.VisitDateTime
                            else
                              TempDate := Encounter.DateTime;
                            saveMHTest(Piece(MHList[i], U, 2),
                                FloatToStr(TempDate), IntToStr(MHLoc));
                          end;
                        end;
                      end;
                    end;
                  end;

                finally
                  MHList.Free;
                  if assigned(FReminder) and (FReminder.MHTestArray <> nil) and
                    (FReminder.MHTestArray.Count > 0) then
                    FreeAndNil(FReminder.MHTestArray);
                end;

  //            if (GenFindingList.Count > 0) then
  //              begin
  //                if RemForm.PCEObj.IsSecondaryVisit then
  //                  begin
  //                    FileCat := GetLocSecondaryVisitCode(RemForm.PCEObj.Location);
  //                    FileDate := FloatToStr(RemForm.PCEObj.NoteDateTime);
  //                    AVisitStr :=  IntToStr(RemForm.PCEObj.Location) + ';' + FileDate + ';' + FileCat;
  //                  end
  //                else AVisitStr := RemForm.PCEObj.VisitString;
  //                SaveGenFindingData(GenFindingList, Patient.DFN,
  //                  AVisitStr, '', IntToStr(RemForm.PCEObj.NoteIEN) );
  //              end;

                if (WHList.Count > 0) then
                begin
                  WHResult := '';
                  for i := 0 to WHList.Count - 1 do
                  begin
                    WHNode := WHList.Strings[i];
                    if (pos('N', Piece(WHNode, U, 1)) <> 0) then
                    begin
                      setpiece(WHResult, U, 1, 'WHIEN:' + Piece(WHNode, U, 2));
                      setpiece(WHResult, U, 2, 'DFN:' + Patient.DFN);
                      setpiece(WHResult, U, 3, 'WHRES:' + Piece(WHNode, U, 11));
                      setpiece(WHResult, U, 4, 'Visit:' + RemForm.PCEObj.VisitString);
                      if (not assigned(WHArray)) then
                        WHArray := TStringList.Create;
                      WHArray.Add(WHResult);
                    end;
                    if (pos('O', Piece(WHNode, U, 1)) <> 0) then
                    begin
                      setpiece(WHResult, U, 1, 'WHPur:' + Piece(WHNode, U, 2));
                      setpiece(WHResult, U, 2, Piece(WHNode, U, 11));
                      setpiece(WHResult, U, 3, Piece(WHNode, U, 12));
                      setpiece(WHResult, U, 4, 'DFN:' + Patient.DFN);
                      setpiece(WHResult, U, 5, Piece(WHNode, U, 13));
                      // AGP CHANGE 23.13
                      if (not assigned(WHArray)) then
                        WHArray := TStringList.Create;
                      WHArray.Add(WHResult);
                    end;
                  end;
                  SaveWomenHealthData(WHArray);
                end;
              finally
                WHList.Free;
              end;

              ResetProcessing(RemWipe);
              Hide;
              Kill := TRUE;
  //            RemForm.DisplayPCEProc; - moved to FormDestroy
//              if RemList <> nil then
//                begin
//                  for i := 0 to RemList.Count - 1 do
//                    begin
//                      NewStatus := EvaluateReminder(RemList.Strings[i]);
//                      ReminderEvaluated(NewStatus);
//                    end;
//                end;


              // Process orders after PCE data saved in case of user input
              if (OrderList.Count > 0) then
              begin
                DelayEvent.EventType := 'C';
                DelayEvent.Specialty := 0;
                DelayEvent.Effective := 0;
                DelayEvent.PtEventIFN := 0;
                DelayEvent.EventIFN := 0;
                DoOrders := TRUE;
                repeat
                  Done := TRUE;
                  if not ReadyForNewOrder(DelayEvent) then
                  begin
                    if (InfoBox('Unable to place orders.', 'Retry Orders?',
                      MB_RETRYCANCEL or MB_ICONWARNING) = IDRETRY) then
                      Done := FALSE
                    else
                    begin
                      DoOrders := FALSE;
                      ShowMsg('No Orders Placed.');
                    end;
                  end;
                until (Done);
                if (DoOrders) then
                begin
                  if (OrderList.Count = 1) then
                  begin
                    if not EncounterPresent then Exit;

                    case CharAt(Piece(OrderList[0], U, 3), 1) of
                      'A':
                        ActivateAction(Piece(OrderList[0], U, 2),
                          RemForm.Form, 0);
                      'D', 'Q':
                        ActivateOrderDialog(Piece(OrderList[0], U, 2), DelayEvent,
                          RemForm.Form, 0);
                      'M':
                        ActivateOrderMenu(Piece(OrderList[0], U, 2), DelayEvent,
                          RemForm.Form, 0);
                      'O':
                        ActivateOrderSet(Piece(OrderList[0], U, 2), DelayEvent,
                          RemForm.Form, 0);
                    end;
                  end
                  else
                  begin
                    for i := 0 to OrderList.Count - 1 do
                    begin
                      tmp := Pieces(OrderList[i], U, 2, 4);
                      OrderList[i] := tmp;
                    end;
                    ActivateOrderList(OrderList, DelayEvent, RemForm.Form,
                      0, '', '');
                  end;
                end;
              end;
            finally
              OrderList.Free;
              GenFindingList.Free;
            end;
          end;
        finally
          TmpList.Free;
          RemList.Free;
          codesList.Free;
        end;
      finally
        if not FProcessingTemplate then
          ProcessedReminders.Notifier.EndUpdate(ProcessedReminders.Count <>
            OldRemCount);
      end;
    finally
      clearResults;
      clearInputs;
      if assigned(TmpText) then
        FreeAndNil(TmpText);
      Self.btnFinish.Enabled := TRUE;
      if (Kill) then
      begin
        FExitOK := TRUE;
        clearGlobals;
        Close;
        SendMessage(Application.MainForm.Handle, UM_REMINDERS, 1, 1);
      end;
    end;
  finally
    Unlock;
    FFinishing := False;
    PXRMDoneWorking;
  end
end;

procedure TfrmRemDlg.ResetProcessing(Wipe: string = ''); // AGP CHANGE 24.8
var
  i: Integer;
  RemWipeArray: TStringList;

begin
  if FProcessingTemplate then
    KillObj(@FReminder)
  else
  begin
    while (RemindersInProcess.Count > 0) do
    begin
      RemindersInProcess.Notifier.BeginUpdate;
      try
        RemindersInProcess.KillObjects;
        RemindersInProcess.Clear;
      finally
        FReminder := nil;
        RemindersInProcess.Notifier.EndUpdate(TRUE);
      end;
    end;
  end;
  ClearControls(TRUE);
  PositionTrees('');
//  immProcedureCnt := 0;
  // AGP Change 24.8 Add wipe section for reminder wipe
  If Wipe <> '' then
  begin
    RemWipeArray := TStringList.Create;
    try
      if pos(U, Wipe) > 0 then
      begin
        Wipe := U + Wipe + U;
        for i := 0 to ReminderDialogInfo.Count - 1 do
        begin
          if pos(U + ReminderDialogInfo.Strings[i] + U, Wipe) > 0 then
          begin
            RemWipeArray.Add(ReminderDialogInfo.Strings[i]);
          end;
        end;
      end
      else
      begin
        RemWipeArray.Add(Wipe);
      end;

      if assigned(RemWipeArray) then
      begin
        for i := 0 to RemWipeArray.Count - 1 do
          KillDlg(@ReminderDialogInfo, RemWipeArray.Strings[i], TRUE);
      end;
    finally
      if (assigned(RemWipeArray)) then
      begin
        RemWipeArray.Clear;
        RemWipeArray.Free;
      end;
    end;
  end;
end;

procedure TfrmRemDlg.RemindersChanged(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmRemDlg.btnClinMaintClick(Sender: TObject);
var
  aList: TStrings;
  returnValue: integer;

begin
  if PXRMWorking then
    exit;
  try
    aList := TStringList.Create;
    try
      if assigned(FReminder) and (not assigned(FClinMainBox)) then
      begin
        returnValue := DetailReminder(StrToIntDef(FReminder.IEN, 0), aList);
        if returnValue > 0 then
          FClinMainBox := ModelessReportBox(aList, ClinMaintText + ': ' +
            FReminder.PrintName, TRUE)
        else
          InfoBox('Error loading Clinical Maintanence', 'Error', MB_OK);
        FOldClinMaintOnDestroy := FClinMainBox.OnDestroy;
        FClinMainBox.OnDestroy := ClinMaintDestroyed;
        UpdateButtons;
      end;
    finally
      FreeAndNil(aList);
    end;
  finally
    PXRMDoneWorking;
  end;
end;

procedure TfrmRemDlg.ClinMaintDestroyed(Sender: TObject);
begin
  if (assigned(FOldClinMaintOnDestroy)) then
    FOldClinMaintOnDestroy(Sender);
  FClinMainBox := nil;
  UpdateButtons;
end;

procedure TfrmRemDlg.btnVisitClick(Sender: TObject);
var
  frmRemVisitInfo: TfrmRemVisitInfo;
  VitalsDate: TFMDateTime;

begin
  if FVitalsDate = 0 then
    VitalsDate := FMNow // AGP Change 26.1
  else
    VitalsDate := FVitalsDate;
  frmRemVisitInfo := TfrmRemVisitInfo.Create(Self);
  try
    frmRemVisitInfo.fraVisitRelated.InitAllow(FSCCond);
    frmRemVisitInfo.fraVisitRelated.InitRelated(FSCRelated, FAORelated,
      FIRRelated, FECRelated, FMSTRelated, FHNCRelated, FCVRelated, FSHDRelated,
      FCLRelated);
    frmRemVisitInfo.dteVitals.FMDateTime := VitalsDate;
    frmRemVisitInfo.ShowModal;
    if frmRemVisitInfo.ModalResult = mrOK then
    begin
      VitalsDate := frmRemVisitInfo.dteVitals.FMDateTime;
      if VitalsDate <= FMNow then
        FVitalsDate := VitalsDate;
      frmRemVisitInfo.fraVisitRelated.GetRelated(FSCRelated, FAORelated,
        FIRRelated, FECRelated, FMSTRelated, FHNCRelated, FCVRelated,
        FSHDRelated, FCLRelated);
      FSCPrompt := FALSE;
      UpdateText(nil);
    end;
  finally
    frmRemVisitInfo.Free;
  end;
end;

procedure TfrmRemDlg.ProcessTemplate(Template: TTemplate);
begin
  Lock;
  try
    FProcessingTemplate := TRUE;
    btnClear.Visible := FALSE;
    btnClinMaint.Visible := FALSE;
    btnBack.Visible := FALSE;
    btnNext.Visible := FALSE;
    FReminder := TReminderDialog.Create(Template.ReminderDialogIEN + U +
      Template.PrintName + U + Template.ReminderWipe); // AGP CHANGE      24.8
    ClearControls(TRUE);
    FReminder.PCEDataObj := RemForm.PCEObj;
    BuildControls(True);
    UpdateText(nil);
    UpdateButtons;
    Show;
  finally
    Unlock;
  end;
end;

procedure TfrmRemDlg.SetFontSize;
begin
  ResizeAnchoredFormToFont(frmRemDlg);
  if assigned(FClinMainBox) then
    ResizeAnchoredFormToFont(FClinMainBox);

  if assigned(Application.MainForm) then
  begin
    sb1.Font.Size :=  Application.MainForm.Font.Size;
    sb2.Font.Size :=  Application.MainForm.Font.Size;
    reText.Font.Size := Application.MainForm.Font.Size;
    reData.Font.Size := Application.MainForm.Font.Size;
  end;

  BuildControls(False);
end;

{ AGP Change 24.8 You MUST pass an address to an object variable to get KillObj to work }
procedure TfrmRemDlg.KillDlg(ptr: Pointer; ID: string;
  KillObjects: Boolean = FALSE);
var
  Obj: TObject;
//  Lst: TList;
  SLst: TStringList;
  i: Integer;

begin
  Obj := TObject(ptr^);
  if (assigned(Obj)) then
  begin
    if (KillObjects) then
    begin
      {if (Obj is TList) then
      begin
        Lst := TList(Obj);
        for i := Lst.Count - 1 downto 0 do
          if assigned(Lst[i]) then
            TObject(Lst[i]).Free;
      end
      else}
      if (Obj is TStringList) then
      begin
        SLst := TStringList(Obj);
        // Check to see if the Reminder IEN is in the of IEN to be wipe out
        for i := SLst.Count - 1 downto 0 do
          if assigned(SLst.Objects[i]) and (SLst.Strings[i] = ID) then
          begin
            SLst.Objects[i].Free;
            SLst.Delete(i);
          end;
      end;
    end;
//    Obj.Free;
//    TObject(ptr^) := nil;
  end;
end;

procedure TfrmRemDlg.Lock;
begin
  inc(FLockCount);
end;

procedure TfrmRemDlg.FormShow(Sender: TObject);
begin
  // Set The form to it's Saved Position
  pnlFrmBottom.Height := RemDlgSpltr1 + lblFootnotes.Height;
  reData.Height := RemDlgSpltr2;
end;

initialization

finalization

KillReminderDialog(nil);
KillObj(@PositionList);

end.
