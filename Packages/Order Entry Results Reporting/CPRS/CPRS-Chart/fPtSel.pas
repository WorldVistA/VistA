unit fPtSel;
{ Allows patient selection using various pt lists.  Allows display & processing of alerts. }

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

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
  uInfoBoxWithBtnControls,
  ClipBrd,
  DateUtils;

type
  TfrmPtSel = class(TfrmBase508Form)
    pnlPtSel: TORAutoPanel;
    cboPatient: TORComboBox;
    lblPatient: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlNotifications: TORAutoPanel;
    cmdProcessInfo: TButton;
    cmdProcessAll: TButton;
    cmdProcess: TButton;
    cmdForward: TButton;
    sptVert: TSplitter;
    cmdSaveList: TButton;
    pnlDivide: TORAutoPanel;
    lblNotifications: TLabel;
    ggeInfo: TGauge;
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
    txtCmdDefer: TVA508StaticText;
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
    procedure pnlPtSelResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboPatientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvAlertsColumnClick(Sender: TObject; Column: TListColumn);
    function DupLastSSN(const DFN: string): Boolean;
    procedure lstFlagsClick(Sender: TObject);
    procedure lstFlagsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvAlertsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ShowButts(ShowButts: Boolean);
    procedure lstvAlertsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure lstvAlertsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cmdCommentsClick(Sender: TObject);
    procedure lstvAlertsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cboPatientKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdDeferClick(Sender: TObject);
    procedure lstvAlertsData(Sender: TObject; Item: TListItem);
    procedure lstvAlertsDataStateChange(Sender: TObject; StartIndex,
      EndIndex: Integer; OldState, NewState: TItemStates);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FsortCol: Integer;
    FsortAscending: Boolean;
    FLastPt: string;
    FsortDirection: string;
    FUserCancelled: Boolean;
    FOKClicked: Boolean;
    FExpectedClose: Boolean;
    FNotificationBtnsAdjusted: Boolean;
    FAlertsNotReady: Boolean;
    FMouseUpPos: TPoint;
    FAlertData: TStringList;
    procedure WMReadyAlert(var Message: TMessage); message UM_MISC;
    procedure ReadyAlert;
    procedure AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
    procedure ClearIDInfo;
    procedure ShowIDInfo;
    procedure ShowFlagInfo;
    procedure SetCaptionTop;
    procedure SetPtListTop(IEN: Int64);
    procedure RPLDisplay;
    procedure AlertList;
//    procedure ReformatAlertDateTime;
    procedure AdjustButtonSize(pButton: TButton);
    procedure AdjustNotificationButtons;
    procedure SetupDemographicsForm;
    procedure SetupDemographicsLabel;
    procedure ShowDisabledButtonTexts;

  public
    procedure Loaded; override;
  end;

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer; var UserCancelled: Boolean);

var
  frmPtSel: TfrmPtSel;
  FDfltSrc, FDfltSrcType: string;
  IsRPL, RPLJob, DupDFN: string; // RPLJob stores server $J job number of RPL pt. list.
  RPLProblem: Boolean; // Allows close of form if there's an RPL problem.
  PtStrs: TStringList;

implementation

{$R *.DFM}

uses
  rCore,
  uCore,
  fDupPts,
  fPtSens,
  fPtSelDemog,
  fPtSelOptns,
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
  fNotificationProcessor;

const
  LAST_DISPLAYED_PIECE = 11;
  SORT_DATE_PIECE = 12;
  ITEM_STATE_PIECE = 13;

const
  AliasString = ' -- ALIAS';
  SortDirection: array[boolean] of tSortDir = (DIR_BKWRD, DIR_FRWRD);

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer; var UserCancelled: Boolean);
{ displays patient selection dialog (with optional notifications), updates Patient object }
var
  frmPtSel: TfrmPtSel;
begin
  frmPtSel := TfrmPtSel.Create(Application);
  RPLProblem := False;
  try
    with frmPtSel do
      begin
        AdjustFormSize(ShowNotif, FontSize); // Set initial form size
        FDfltSrc := DfltPtList;
        FDfltSrcType := Piece(FDfltSrc, U, 2);
        FDfltSrc := Piece(FDfltSrc, U, 1);
        if (IsRPL = '1') then // Deal with restricted patient list users.
          FDfltSrc := '';
        frmPtSelOptns.SetDefaultPtList(FDfltSrc);
        if RPLProblem then
          begin
            frmPtSel.Release;
            Exit;
          end;
        Notifications.Clear;
        FsortCol := -1;
        AlertList;
        ClearIDInfo;
        if (IsRPL = '1') then // Deal with restricted patient list users.
          RPLDisplay; // Removes unnecessary components from view.
        FUserCancelled := False;
        ShowModal;
        UserCancelled := FUserCancelled;
      end;
  finally
    frmPtSel.Release;
  end;
end;

procedure TfrmPtSel.AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
{ Adjusts the initial size of the form based on the font used & if notifications should show. }
var
  Rect: TRect;
  SplitterTop, t1, t2, t3: Integer;
begin
  SetFormPosition(self);
  ResizeAnchoredFormToFont(self);
  if ShowNotif then
    begin
      pnlDivide.Visible := True;
      lstvAlerts.Visible := True;
      pnlNotifications.Visible := True;
      pnlPtSel.BevelOuter := bvRaised;
    end
  else
    begin
      pnlDivide.Visible := False;
      lstvAlerts.Visible := False;
      pnlNotifications.Visible := False;
    end;
  // SetFormPosition(self);
  Rect := BoundsRect;
  ForceInsideWorkArea(Rect);
  BoundsRect := Rect;
  if frmFrame.EnduringPtSelSplitterPos <> 0 then
    SplitterTop := frmFrame.EnduringPtSelSplitterPos
  else
    SetUserBounds2(Name + '.' + sptVert.Name, SplitterTop, t1, t2, t3);
  if SplitterTop <> 0 then
    pnlPtSel.Height := SplitterTop;
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
      case frmPtSelOptns.SrcType of
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
        RedrawSuspend(Handle);
        ClearIDInfo;
        ClearTop;
        Text := '';
        Items.Add('^Select a ' + X + '...');
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
        cboPatient.InitLongList('');
        RedrawActivate(cboPatient.Handle);
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
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination')) then
    begin
      cboPatient.pieces := '2,3,4,5,9';
      cboPatient.tabPositions := '20,28,35,45';
    end;
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and
    (FDfltSrcType = 'Ward')) or (frmPtSelOptns.SrcType = TAG_SRC_WARD) then
    cboPatient.tabPositions := '35';
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and
    (AnsiStrPos(pChar(FDfltSrcType), 'Clinic') <> nil)) or (frmPtSelOptns.SrcType = TAG_SRC_CLIN) then
    begin
      cboPatient.pieces := '2,3,9';
      cboPatient.tabPositions := '24,45';
    end;
  NewTopList := IntToStr(frmPtSelOptns.SrcType) + U + IntToStr(IEN); // Default setting.
  if (frmPtSelOptns.SrcType = TAG_SRC_CLIN) then
    with frmPtSelOptns.cboDateRange do
      begin
        if ItemID = '' then
          Exit; // Need both clinic & date range.
        FirstDate := Piece(ItemID, ';', 1);
        LastDate := Piece(ItemID, ';', 2);
        NewTopList := IntToStr(frmPtSelOptns.SrcType) + U + IntToStr(IEN) + U + ItemID; // Modified for clinics.
      end;
  if NewTopList = frmPtSelOptns.LastTopList then
    Exit; // Only continue if new top list.
  frmPtSelOptns.LastTopList := NewTopList;
  RedrawSuspend(cboPatient.Handle);
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
      case frmPtSelOptns.SrcType of
        TAG_SRC_DFLT:
          ListPtByDflt(cboPatient.Items);
        TAG_SRC_PROV:
          ListPtByProvider(cboPatient.Items, IEN);
        TAG_SRC_TEAM:
          ListPtByTeam(cboPatient.Items, IEN);
        TAG_SRC_SPEC:
          ListPtBySpecialty(cboPatient.Items, IEN);
        TAG_SRC_CLIN:
          ListPtByClinic(cboPatient.Items, frmPtSelOptns.cboList.ItemIEN, FirstDate, LastDate);
        TAG_SRC_WARD:
          ListPtByWard(cboPatient.Items, IEN);
        // TDP - Added 5/27/2014 to handle PCMM team addition
        TAG_SRC_PCMM:
          ListPtByPcmmTeam(cboPatient.Items, IEN);
        TAG_SRC_ALL:
          ListPtTop(cboPatient.Items);
      end;
    end;
  with frmPtSelOptns.cboList do
  begin
    if Visible then
    begin
      updateDate := '';
      if (frmPtSelOptns.SrcType <> TAG_SRC_PROV) and
         (Piece(Items[ItemIndex], U, 3) <> '') then
        updateDate := ' last updated on ' + Piece(Items[ItemIndex], U, 3);
      lblPatient.Caption := 'Patients (' + Text + updateDate + ')';
    end;
  end;
  if frmPtSelOptns.SrcType = TAG_SRC_ALL then
    lblPatient.Caption := 'Patients (All Patients)';
  with cboPatient do
    if ShortCount > 0 then
      begin
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
  cboPatient.Caption := lblPatient.Caption;
  cboPatient.InitLongList('');
  RedrawActivate(cboPatient.Handle);
end;

{ Patient Select events: }

procedure TfrmPtSel.cboPatientEnter(Sender: TObject);
begin
  cmdOK.Default := True;
  if cboPatient.ItemIndex >= 0 then
    begin
      ShowIDInfo;
      ShowFlagInfo;
    end;
end;

procedure TfrmPtSel.cboPatientExit(Sender: TObject);
begin
  cmdOK.Default := False;
end;

procedure TfrmPtSel.cboPatientChange(Sender: TObject);

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
                ShowFlagInfo;
              end;
            Items.Add(LLS_LINE);
            Items.Add(LLS_SPACE);
          end;
        InitLongList('');
      end;
  end;

begin
  with cboPatient do
    if frmPtSelOptns.IsLast5(Text) then
      begin
        if (IsRPL = '1') then
          ListPtByRPLLast5(Items, Text)
        else
          ListPtByLast5(Items, Text);
        ShowMatchingPatients;
      end
    else if frmPtSelOptns.IsFullSSN(Text) then
      begin
        if (IsRPL = '1') then
          ListPtByRPLFullSSN(Items, Text)
        else
          ListPtByFullSSN(Items, Text);
        ShowMatchingPatients;
      end;
end;

procedure TfrmPtSel.cboPatientKeyPause(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then // *DFN*
    begin
      ShowIDInfo;
      ShowFlagInfo;
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
      ShowFlagInfo;
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
        FastAssign(ReadRPLPtList(RPLJob, NoAlias, Direction), PatientList)
      else
        begin
          FastAssign(SubSetOfPatients(NoAlias, Direction), PatientList);
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
  frmPtSelDemog.ClearIDInfo;
end;

procedure TfrmPtSel.ShowIDInfo;
begin
  frmPtSelDemog.ShowDemog(cboPatient.ItemID);
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
  NewDFN: string; // *DFN*
  DateDied: TFMDateTime;
  AccessStatus: Integer;
begin
  if not(Length(cboPatient.ItemID) > 0) then // *DFN*
    begin
      InfoBox('A patient has not been selected.', 'No Patient Selected', MB_OK);
      Exit;
    end;
  NewDFN := cboPatient.ItemID; // *DFN*
  if FLastPt <> cboPatient.ItemID then
    begin
      HasActiveFlg(FlagList, HasFlag, cboPatient.ItemID);
      FLastPt := cboPatient.ItemID;
    end;

  if DupLastSSN(NewDFN) then // Check for, deal with duplicate patient data.
    if (DupDFN = 'Cancel') then
      Exit
    else
      NewDFN := DupDFN;
  if not AllowAccessToSensitivePatient(NewDFN, AccessStatus) then
    Exit;
  DateDied := DateOfDeath(NewDFN);
  if (DateDied > 0) and (InfoBox('This patient died ' + FormatFMDateTime('mmm dd,yyyy hh:nn', DateDied) + CRLF +
    'Do you wish to continue?', 'Deceased Patient', MB_YESNO or MB_DEFBUTTON2) = ID_NO) then
    Exit;
  // 9/23/2002: Code used to check for changed pt. DFN here, but since same patient could be
  // selected twice in diff. Encounter locations, check was removed and following code runs
  // no matter; in fFrame code then updates Encounter display if Encounter.Location has changed.
  // NOTE: Some pieces in RPC returned arrays are modified/rearranged by ListPtByDflt call in rCore!
  Patient.DFN := NewDFN; // The patient object in uCore must have been created already!
  Encounter.Clear;
  Changes.Clear; // An earlier call to ReviewChanges should have cleared this.
  if (frmPtSelOptns.SrcType = TAG_SRC_CLIN) and (frmPtSelOptns.cboList.ItemIEN > 0) and
    IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4)) then // Clinics, not by default.
    begin
      Encounter.Location := frmPtSelOptns.cboList.ItemIEN;
      with cboPatient do
        Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
    end
  else if (frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (DfltPtListSrc = 'C') and
    IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4)) then
    with cboPatient do // "Default" is a clinic.
      begin
        Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 10), 0); // Piece 10 is ^SC( location IEN in this case.
        Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
      end
  else if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination') and
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
  FExpectedClose := True;
  Close;
end;

procedure TfrmPtSel.cmdCancelClick(Sender: TObject);
begin
  // Leave Patient object unchanged
  FUserCancelled := True;
  FExpectedClose := True;
  Close;
end;

procedure TfrmPtSel.cmdCommentsClick(Sender: TObject);
var
  tmpCmt: TStringList;
begin
  if FAlertsNotReady then
    Exit;
  inherited;
  tmpCmt := TStringList.Create;
  try
    tmpCmt.Text := lstvAlerts.Selected.SubItems[8];
    LimitStringLength(tmpCmt, 74);
    tmpCmt.Insert(0, StringOfChar('-', 74));
    tmpCmt.Insert(0, lstvAlerts.Selected.SubItems[4]);
    tmpCmt.Insert(0, lstvAlerts.Selected.SubItems[3]);
    tmpCmt.Insert(0, lstvAlerts.Selected.SubItems[0]);
    ReportBox(tmpCmt, 'Forwarded by: ' + lstvAlerts.Selected.SubItems[5], True);
    lstvAlerts.SetFocus;
  finally
    tmpCmt.Free;
  end;
end;

procedure TfrmPtSel.cmdDeferClick(Sender: TObject);
var
  aResult: string;
  item: TListItem;

begin
  if FAlertsNotReady then
    Exit;

  with TfrmDeferDialog.Create(self) do
    try
      Title := 'Defer Patient Notification';
      with TStringList.Create do
        try
          Text := lstvAlerts.Selected.SubItems.Text;
          while Count > 6 do
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
          aResult := sCallV('ORB3UTL DEFER', [User.DUZ, lstvAlerts.Selected.SubItems[6], DeferUntilFM]);
          if aResult = '1' then
            begin
              MessageDlg('Notification successfully deferred.', mtInformation, [mbOk], 0);
              item := lstvAlerts.Selected;
              FAlertData.Delete(item.Index);
              item.Selected := False;
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
  AFollowUp, i, infocount, LongTextResult: Integer;
  enableclose: Boolean;
  ADFN, X, RecordID, XQAID, LongText, AlertMsg: string; // *DFN*
  LongTextBtns: TStringList;
  aSmartParams, aEmptyParams: TStringList;
  aSMARTAction: TNotificationAction;
  lastUpdate: TDateTime;

  procedure IncProgressBar;
  begin
    ggeInfo.Progress := ggeInfo.Progress + 1;
    if MilliSecondsBetween(Now, lastUpdate) > 250 then
    begin
      Application.ProcessMessages;
      LastUpdate := Now;
    end;
  end;

begin
  Application.ProcessMessages;
  if FAlertsNotReady then
    Exit;
  enableclose := False;
  with lstvAlerts do
  begin
    if SelCount <= 0 then
      Exit;

    // Count information-only selections for gauge
    infocount := 0;
    for i := 0 to Items.Count - 1 do
      if Items[i].Selected then
      begin
        X := Items[i].Caption;
        if (X = 'I') or (X = 'L') then
          Inc(infocount);
      end;

    if infocount > 0 then
    begin
      ggeInfo.Visible := True; (* BOB *)
      ggeInfo.MaxValue := infocount;
      ggeInfo.Progress := 0;
      Application.ProcessMessages; // display the progress bar
      lastUpdate := Now;
    end;

    for i := 0 to Items.Count - 1 do
      if Items[i].Selected then
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
        XQAID := Items[i].SubItems[6];
        AlertMsg := Items[i].SubItems[4];
        RecordID := Items[i].SubItems[0] + ': ' + Items[i].SubItems[4] +
          '^' + XQAID;
        // RecordID := patient: alert message^XQAID  ('ABC,PATIE (A4321): New order(s) placed.^OR,66,50;1416;3021231.121024')
        if Items[i].Caption = 'I' then
        // If Caption is 'I' delete the information only alert.
        begin
          IncProgressBar;
          DeleteAlert(XQAID);
        end
        else if Items[i].Caption = 'L' then
          begin
            IncProgressBar;
            LongText := LoadNotificationLongText(XQAID);
            LongTextBtns := TStringList.Create();
            LongTextBtns.Add('Copy to Clipboard');
            LongTextBtns.Add('Dismiss Alert');
            LongTextBtns.Add('Keep Alert^true');

            if Piece(XQAID, ',', 1) = 'OR' then
            begin
              LongTextBtns.Add('Open Patient Chart');
            end;

            LongTextResult := 0;
            while (LongTextResult=0) do
            begin
              LongTextResult := uInfoBoxWithBtnControls.DefMessageDlg(LongText,
                  mtConfirmation, LongTextBtns, Alertmsg, false);
              if (LongTextResult = 0) then ClipBoard.astext := LongText
            end;
            if (LongTextResult = 1) then DeleteAlert(XQAID)
            else if (LongTextResult = 3) then
            begin
              DeleteAlert(XQAID);
              ADFN := Piece(XQAID, ',', 2); // *DFN*
              cboPatient.Items.Add(ADFN+'^');
              cboPatient.SelectByID(ADFN);
              cmdOKClick(self);
              enableClose := True;
              break;
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
{ removing code to roll back changes introduced by v31.261 - begin}
//              if aSmartParams.Values['CAN_PROCESS'] <> 'D' then
//              begin
{ removing code to roll back changes introduced by v31.261 - end}
                aSMARTAction := TfrmNotificationProcessor.Execute(aSmartParams,
                                    lstvAlerts.Selected.SubItems.Text);

                if aSMARTAction = naNewNote then
                begin
                  aSmartParams.Add('MAKE ADDENDUM=0');
                  ADFN := Piece(XQAID, ',', 2); // *DFN*
                  AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1),
                    ',', 3), 0);
                  Notifications.Add(ADFN, AFollowUp, RecordID,
                    Items[i].SubItems[3], aSmartParams);
                  enableclose := True;
                end
                else if aSMARTAction = naAddendum then
                begin
                  aSmartParams.Add('MAKE ADDENDUM=1');
                  ADFN := Piece(XQAID, ',', 2); // *DFN*
                  AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1),
                    ',', 3), 0);
                  Notifications.Add(ADFN, AFollowUp, RecordID,
                    Items[i].SubItems[3], aSmartParams);
                  enableclose := True;
                end;
{ removing code to roll back changes introduced by v31.261 - begin}
//              end
//              else
//              begin
//                InfoBox('Processing of this type of alert is currently disabled.', 'Unable to Process Alert', MB_OK);
//              end;
{ removing code to roll back changes introduced by v31.261 - end}
            end
            else
            begin
              ADFN := Piece(XQAID, ',', 2); // *DFN*
              AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1), ',', 3), 0);
              Notifications.Add(ADFN, AFollowUp, RecordID, Items[i].SubItems[3],
                aSmartParams);
              // CB
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
            try
              aEmptyParams := TStringList.Create();
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
            Items[i].SubItems[0] + ': ' + Items[i].SubItems[4], MB_OK);
      end;

      // blj 21 Jun 2016: moved outside of if statement to prevent A/V.
      if enableclose then
      begin
        FExpectedClose := True;
        Close;
      end
      else
      begin
        ggeInfo.Visible := False;
        // Update notification list:
        AlertList;
        // display alerts sorted according to parameter settings:
        FsortCol := -1; // CA - display alerts in correct sort
        FormShow(Sender);
      end;
      if Items.Count = 0 then
        ShowButts(False);
      if SelCount <= 0 then
        ShowButts(False);
  end;
end;

procedure TfrmPtSel.cmdSaveListClick(Sender: TObject);
begin
  frmPtSelOptns.cmdSaveListClick(Sender);
end;

procedure TfrmPtSel.cmdProcessInfoClick(Sender: TObject);
// Select and process all items that are information only in the lstvAlerts list box.
var
  i: Integer;
begin
  if FAlertsNotReady then
    Exit;
  if lstvAlerts.Items.Count = 0 then
    Exit;
  if InfoBox('You are about to process all your INFORMATION alerts.' + CRLF
    + 'These alerts will not be presented to you for individual' + CRLF
    + 'review and they will be permanently removed from your' + CRLF
    + 'alert list.  Do you wish to continue?',
    'Warning', MB_YESNO or MB_ICONWARNING) = IDYES then
    begin
      lstvAlerts.ClearSelection;
//      for i := 0 to lstvAlerts.Items.Count - 1 do
//        lstvAlerts.Items[i].Selected := False; // clear any selected alerts so they aren't processed
      for i := 0 to lstvAlerts.Items.Count - 1 do
        if lstvAlerts.Items[i].Caption = 'I' then
          lstvAlerts.Items[i].Selected := True;
      cmdProcessClick(self);
      ShowButts(False);
    end;
end;

procedure TfrmPtSel.cmdProcessAllClick(Sender: TObject);
begin
  if FAlertsNotReady then
    Exit;
  lstvAlerts.SelectAll;
  cmdProcessClick(self);
  ShowButts(False);
end;

procedure TfrmPtSel.lstvAlertsData(Sender: TObject; Item: TListItem);
var
  j: Integer;
  s: string;

begin
  inherited;
  if assigned(Item) and (Item.Index < FAlertData.Count) then
  begin
    s := FAlertData[Item.Index];
    Item.Caption := Piece(s, U, 1);
    for j := 2 to LAST_DISPLAYED_PIECE do
      if Item.SubItems.Count > (j-2) then
        Item.SubItems[j-2] := Piece(s, U, j)
      else
        Item.SubItems.Add(Piece(s, U, j));
  end;
end;

procedure TfrmPtSel.lstvAlertsDataStateChange(Sender: TObject; StartIndex,
  EndIndex: Integer; OldState, NewState: TItemStates);
begin
  FAlertsNotReady := True;
  PostMessage(Handle, UM_MISC, 0, 0);
end;

procedure TfrmPtSel.lstvAlertsDblClick(Sender: TObject);
begin
  cmdProcessClick(self);
end;

procedure TfrmPtSel.cmdForwardClick(Sender: TObject);
var
  i: Integer;
  Alert: string;
begin
  if FAlertsNotReady then
    Exit;
  try
    with lstvAlerts do
      begin
        if SelCount <= 0 then
          Exit;
        for i := 0 to Items.Count - 1 do
          if Items[i].Selected then
          begin
            try
              Alert := Items[i].SubItems[6] + '^' + Items[i].SubItems[0] + ': ' +
                Items[i].SubItems[4];
              ForwardAlertTo(Alert);
            finally
              Items[i].Selected := False;
            end;
          end;
      end;
  finally
    if lstvAlerts.SelCount <= 0 then
      ShowButts(False);
  end;
end;

procedure TfrmPtSel.cmdRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  if FAlertsNotReady then
    Exit;
  with lstvAlerts do
    begin
      if SelCount <= 0 then
        Exit;
      for i := 0 to Items.Count - 1 do
        if Items[i].Selected then
          begin
            if Items[i].SubItems[7] = '1' then // remove flag enabled
              DeleteAlertforUser(Items[i].SubItems[6])
            else
              InfoBox('This alert cannot be removed.', Items[i].SubItems[0] + ': ' + Items[i].SubItems[4], MB_OK);
          end;
    end;
  AlertList;
  FsortCol := -1; // CA - display alerts in correct sort
  FormShow(Sender); // CA - display alerts in correct sort
  if (lstvAlerts.Items.Count = 0) or (lstvAlerts.SelCount <= 0) then
    ShowButts(False);
end;

procedure TfrmPtSel.FormDestroy(Sender: TObject);
var
  i: Integer;
  aString: string;
begin
  SaveUserBounds(self);
  frmFrame.EnduringPtSelSplitterPos := pnlPtSel.Height;
  aString := '';
  for i := 0 to 6 do
    begin
      aString := aString + IntToStr(lstvAlerts.Column[i].Width);
      if i < 6 then
        aString := aString + ',';
    end;
  frmFrame.EnduringPtSelColumns := aString;
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
end;

procedure TfrmPtSel.pnlPtSelResize(Sender: TObject);
begin
  frmPtSelDemog.Left := cboPatient.Left + cboPatient.Width + 9;
  frmPtSelDemog.Width := pnlPtSel.Width - frmPtSelDemog.Left - 2;
  frmPtSelOptns.Width := cboPatient.Left - 8;
  SetupDemographicsLabel;
end;

procedure TfrmPtSel.Loaded;
begin
  inherited;
  SetupDemographicsForm;
  SetupDemographicsLabel;

  frmPtSelOptns := TfrmPtSelOptns.Create(self); // Was application - kcm
  with frmPtSelOptns do
    begin
      parent := pnlPtSel;
      Top := 4;
      Left := 4;
      Width := cboPatient.Left - 8;
      SetCaptionTopProc := SetCaptionTop;
      SetPtListTopProc := SetPtListTop;
      if RPLProblem then
        Exit;
      TabOrder := cmdSaveList.TabOrder; // Put just before save default list button
      Show;
    end;
  FLastPt := '';
  // Begin at alert list, or patient listbox if no alerts
  if lstvAlerts.Items.Count = 0 then
    ActiveControl := cboPatient;
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
end;

procedure TfrmPtSel.SetupDemographicsForm;
begin
  // This needs to be in Loaded rather than FormCreate or the TORAutoPanel resize logic breaks.
  frmPtSelDemog := TfrmPtSelDemog.Create(self);
  // Was application - kcm
  with frmPtSelDemog do
    begin
      parent := pnlPtSel;
      Top := cmdCancel.Top + cmdCancel.Height + 2;
      Left := cboPatient.Left + cboPatient.Width + 9;
      Width := pnlPtSel.Width - Left - 2;
      TabOrder := cmdCancel.TabOrder + 1;
      // Place after cancel button
      Show;
    end;
  if ScreenReaderActive then
    begin
      frmPtSelDemog.Memo.Show;
      frmPtSelDemog.Memo.BringToFront;
    end;
end;

procedure TfrmPtSel.SetupDemographicsLabel;
var
  intAdjust: Integer;

begin
  intAdjust := Round(PixelsPerInch * MainFontSize / 96);
  lblPtDemo.Top := frmPtSelDemog.Top - Round(lblPtDemo.Height * PixelsPerInch / 96 + intAdjust);
  lblPtDemo.Left := frmPtSelDemog.Left
end;

procedure TfrmPtSel.RPLDisplay;
begin

  // Make unneeded components invisible:
  cmdSaveList.Visible := False;
  frmPtSelOptns.Visible := False;

end;

procedure TfrmPtSel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (IsRPL = '1') then // Deal with restricted patient list users.
    KillRPLPtList(RPLJob); // Kills server global data each time.
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
  FAlertData := TStringList.Create;
end;

procedure TfrmPtSel.cboPatientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('D')) and (ssCtrl in Shift) then
    begin
      Key := 0;
      frmPtSelDemog.ToggleMemo;
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
  i: Integer;
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
        SetPiece(s, U, 7, Piece(FAlertData[i], U, 2));
        comment := Piece(FAlertData[i], U, 3);
        if Length(comment) > 0 then
          SetPiece(s, U, 10, FORWARD_COMMENT + comment);
        FAlertData[i - 1] := s;
        FAlertData.Delete(i);
      end
      else
      begin
        s := FAlertData[i];
        inDateStr := Piece(s, U, 5);
        srtDate := ((Piece(Piece(inDateStr, '/', 3), '@', 1)) + '/' + Piece(inDateStr, '/', 1) +
                 '/' + Piece(inDateStr, '/', 2) + '@' + Piece(inDateStr, '@', 2));
        SetPiece(s, U, SORT_DATE_PIECE, srtDate);
        FAlertData[i] := s;
        Inc(i);
      end;
    end;
    lstvAlerts.Items.Count := FAlertData.Count;
    lstvAlerts.ClearSelection;
    if FAlertData.Count > 0 then
      lstvAlerts.Items[0].MakeVisible(FALSE);
    lstvAlerts.Invalidate;
  finally
    Screen.Cursor := cur;
  end;

  with lstvAlerts do
    begin
      Columns[0].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 1), 40); // Info                 Caption
      Columns[1].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 2), 195); // Patient              SubItems[0]
      Columns[2].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 3), 75); // Location             SubItems[1]
      Columns[3].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 4), 95); // Urgency              SubItems[2]
      Columns[4].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 5), 150); // Alert Date/Time      SubItems[3]
      Columns[5].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 6), 310); // Message Text         SubItems[4]
      Columns[6].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 7), 290); // Forwarded By/When    SubItems[5]
      Columns[10].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 11), 195); // Ordering Provider    SubItems[5]
      // Items not displayed in Columns:     XQAID                SubItems[6]
      // Remove w/o process   SubItems[7]
      // Forwarding comments  SubItems[8]
    end;
end;

procedure TfrmPtSel.lstvAlertsColumnClick(Sender: TObject; Column: TListColumn);
const
  Mask = LVIS_FOCUSED or LVIS_SELECTED;

var
  i, max, State, NewState: integer;
  s, code: string;

begin
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
    if Piece(s, U, ITEM_STATE_PIECE) <> code then
    begin
      SetPiece(s, U, ITEM_STATE_PIECE, code);
      FAlertData[i] := s;
    end;
  end;

  if (FsortCol = Column.Index) then
    FsortAscending := not FsortAscending;

  if FsortAscending then
    FsortDirection := 'F'
  else
    FsortDirection := 'R';

  FsortCol := Column.Index;

  if FsortCol = 4 then
    SortByPiece(FAlertData, U, SORT_DATE_PIECE, SortDirection[FsortAscending])
//    ReformatAlertDateTime // hds7397- ge 2/6/6 sort and display date/time column correctly - as requested
  else
    SortByPiece(FAlertData, U, FsortCol + 1, SortDirection[FsortAscending]);

  for i := 0 to max do
  begin
    code := Piece(FAlertData[i], U, ITEM_STATE_PIECE) + ' ';
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
  case Column.Index of
    0:
      rCore.SetSortMethod('I', FsortDirection);
    1:
      rCore.SetSortMethod('P', FsortDirection);
    2:
      rCore.SetSortMethod('L', FsortDirection);
    3:
      rCore.SetSortMethod('U', FsortDirection);
    4:
      rCore.SetSortMethod('D', FsortDirection);
    5:
      rCore.SetSortMethod('M', FsortDirection);
    6:
      rCore.SetSortMethod('F', FsortDirection);
  end;
end;

function TfrmPtSel.DupLastSSN(const DFN: string): Boolean;
var
  i: Integer;
  frmPtDupSel: tForm;
begin
  Result := False;

  // Check data on server for duplicates:
  CallV('DG CHK BS5 XREF ARRAY', [DFN]);
  if (RPCBrokerV.Results[0] <> '1') then // No duplicates found.
    Exit;
  Result := True;
  PtStrs := TStringList.Create;
  with RPCBrokerV do
    if Results.Count > 0 then
      begin
        for i := 1 to Results.Count - 1 do
          begin
            if Piece(Results[i], U, 1) = '1' then
              PtStrs.Add(Piece(Results[i], U, 2) + U + Piece(Results[i], U, 3) + U +
                FormatFMDateTimeStr('mmm dd,yyyy', Piece(Results[i], U, 4)) + U +
                Piece(Results[i], U, 5));
          end;
      end;

  // Call form to get user's selection from expanded duplicate pt. list (resets DupDFN variable if applicable):
  DupDFN := DFN;
  frmPtDupSel := TfrmDupPts.Create(Application);
  with frmPtDupSel do
    begin
      try
        ShowModal;
      finally
        frmPtDupSel.Release;
      end;
    end;
end;

procedure TfrmPtSel.ShowFlagInfo;
begin
  if (pos('*SENSITIVE*', frmPtSelDemog.lblPtSSN.Caption) > 0) then
    begin
      // pnlPrf.Visible := False;
      Exit;
    end;
  if (FLastPt <> cboPatient.ItemID) then
    begin
      HasActiveFlg(FlagList, HasFlag, cboPatient.ItemID);
      FLastPt := cboPatient.ItemID;
    end;
  if HasFlag then
    begin
      // FastAssign(FlagList, lstFlags.Items);
      // pnlPrf.Visible := True;
    end
  // else pnlPrf.Visible := False;
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
  // SelCount is not accurate in this event because lstvAlerts is now OwnerData
  FAlertsNotReady := True;
  PostMessage(Handle, UM_MISC, 0, 0);
end;

procedure TfrmPtSel.ShowButts(ShowButts: Boolean);
begin
  cmdProcess.Enabled := ShowButts;
  cmdRemove.Enabled := ShowButts;
  cmdForward.Enabled := ShowButts;
  cmdComments.Enabled := ShowButts and (lstvAlerts.SelCount = 1) and (lstvAlerts.Selected.SubItems[8] <> '');
  cmdDefer.Enabled := ShowButts and (lstvAlerts.SelCount = 1);
  ShowDisabledButtonTexts;
end;

procedure TfrmPtSel.lstvAlertsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
begin
  InfoTip := Item.SubItems[8];
end;

procedure TfrmPtSel.lstvAlertsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{
  //KW
  508: Allow non-sighted users to sort Notifications using Ctrl + <key>
  Numbers in case stmnt are ASCII values for character keys.
}
begin
  if FAlertsNotReady then
    Exit;
  if lstvAlerts.Focused then
    begin
      case Key of
        VK_RETURN:
          cmdProcessClick(Sender); // Process all selected alerts
        73, 105:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[0]); // I,i
        80, 113:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[1]); // P,p
        76, 108:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[2]); // L,l
        85, 117:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[3]); // U,u
        68, 100:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[4]); // D,d
        77, 109:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[5]); // M,m
        70, 102:
          if (ssCtrl in Shift) then
            lstvAlertsColumnClick(Sender, lstvAlerts.Columns[6]); // F,f
      end;
    end;
end;

procedure TfrmPtSel.lstvAlertsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseUpPos := Point(X, Y);
end;

procedure TfrmPtSel.FormShow(Sender: TObject);
{
  //KW
  Sort Alerts by last-used method for current user
}
var
  sortResult: string;
  sortMethod: string;
begin
  sortResult := rCore.GetSortMethod;
  sortMethod := Piece(sortResult, U, 1);
  if sortMethod = '' then
    sortMethod := 'D';
  FsortDirection := Piece(sortResult, U, 2);
  if FsortDirection = 'F' then
    FsortAscending := True
  else
    FsortAscending := False;

  case sortMethod[1] of
    'I', 'i':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[0]);
    'P', 'p':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[1]);
    'L', 'l':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[2]);
    'U', 'u':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[3]);
    'D', 'd':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[4]);
    'M', 'm':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[5]);
    'F', 'f':
      lstvAlertsColumnClick(Sender, lstvAlerts.Columns[6]);
  end;

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


{
procedure TfrmPtSel.ReformatAlertDateTime;
var
  i: Integer;
  inDateStr, holdDayTime, srtDate, s: string;
begin
  // convert date to yyyy/mm/dd prior to sort.
  for i := 0 to FAlertData.Count - 1 do
  begin
    s := FAlertData[i];
    inDateStr := Piece(s, U, 5);
    srtDate := ((Piece(Piece(inDateStr, '/', 3), '@', 1)) + '/' + Piece(inDateStr, '/', 1) +
                 '/' + Piece(inDateStr, '/', 2) + '@' + Piece(inDateStr, '@', 2));
    SetPiece(s, U, 5, srtDate);
    FAlertData[i] := s;
  end;
  // sort the listview records by date
  SortByPiece(FAlertData, U, FsortCol + 1, SortDirection[FsortAscending]);
  // loop thru lstvAlerts change date to yyyy/mm/dd
  // sort list
  // change alert date/time back to mm/dd/yyyy@time for display
  for i := 0 to FAlertData.Count - 1 do
  begin
    s := FAlertData[i];
    inDateStr := Piece(s, U, 5);
    holdDayTime := Piece(inDateStr, '/', 3); // dd@time
    srtDate := (Piece(inDateStr, '/', 2) + '/' + Piece(holdDayTime, '@', 1) + '/'
      + Piece(inDateStr, '/', 1) + '@' + Piece(holdDayTime, '@', 2));
    SetPiece(s, U, 5, srtDate);
    FAlertData[i] := s;
  end;
end;
}

procedure TfrmPtSel.AdjustButtonSize(pButton: TButton);
var
  thisButton: TButton;
const
  Gap = 5;
begin
  thisButton := pButton;
  if thisButton.Width < frmFrame.Canvas.TextWidth(thisButton.Caption) then // CQ2737  GE
    begin
      FNotificationBtnsAdjusted := (thisButton.Width < frmFrame.Canvas.TextWidth(thisButton.Caption));
      thisButton.Width := (frmFrame.Canvas.TextWidth(thisButton.Caption) + Gap + Gap); // CQ2737  GE
    end;
  if thisButton.Height < frmFrame.Canvas.TextHeight(thisButton.Caption) then // CQ2737  GE
    thisButton.Height := (frmFrame.Canvas.TextHeight(thisButton.Caption) + Gap); // CQ2737  GE
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

end.
