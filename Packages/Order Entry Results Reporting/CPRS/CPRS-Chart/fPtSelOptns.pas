unit fPtSelOptns;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORDtTmRng, ORCtrls, StdCtrls, ExtCtrls, ORFn, fBase508Form,
  VA508AccessibilityManager;

type

  TSetCaptionTopProc = procedure of object;
  TSetPtListTopProc = procedure(IEN: Int64) of object;

  TfrmPtSelOptns = class(TfrmBase508Form)
    orapnlMain: TORAutoPanel;
    bvlPtList: TORAutoPanel;
    lblPtList: TLabel;
    lblDateRange: TLabel;
    cboList: TORComboBox;
    cboDateRange: TORComboBox;
    calApptRng: TORDateRangeDlg;
    radDflt: TRadioButton;
    radProviders: TRadioButton;
    radTeams: TRadioButton;
    radSpecialties: TRadioButton;
    radClinics: TRadioButton;
    radWards: TRadioButton;
    radAll: TRadioButton;
    radPcmmTeams: TRadioButton;
    radHistory: TRadioButton;
    lbHistory: TListBox;
    procedure radHideSrcClick(Sender: TObject);
    procedure radShowSrcClick(Sender: TObject);
    procedure radLongSrcClick(Sender: TObject);
    procedure cboListExit(Sender: TObject);
    procedure cboListKeyPause(Sender: TObject);
    procedure cboListMouseClick(Sender: TObject);
    procedure cboListNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboDateRangeExit(Sender: TObject);
    procedure cboDateRangeMouseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure radHistoryClick(Sender: TObject);
    procedure lbHistoryClick(Sender: TObject);
    procedure lbHistoryDblClick(Sender: TObject);
    procedure orapnlMainResize(Sender: TObject);
    procedure cboListChange(Sender: TObject);
    procedure cboDateRangeChange(Sender: TObject);
    procedure cboListEnter(Sender: TObject);
    procedure cboListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    FLastTopList: string;
    FLastDateIndex: Integer;
    FDateRangeChanged: boolean;
    FSrcType: Integer;
    FSetCaptionTop: TSetCaptionTopProc;
    FSetPtListTop: TSetPtListTopProc;
    FChanging: Boolean;
    procedure HideDateRange;
    procedure ShowDateRange;
    Procedure UpdatePtSelection;
  public
    function IsLast5(x: string): Boolean;
    function IsFullSSN(x: string): Boolean;
    procedure cmdSaveListClick(Sender: TObject);
    procedure SetDefaultPtList(Dflt: string);
    procedure UpdateListHeight(ShowDate:Boolean);
    procedure UpdateDefault;
    property LastTopList: string read FLastTopList write FLastTopList;
    property SrcType: Integer read FSrcType write FSrcType;
    property SetCaptionTopProc: TSetCaptionTopProc read FSetCaptionTop write FSetCaptionTop;
    property SetPtListTopProc: TSetPtListTopProc   read FSetPtListTop  write FSetPtListTop;
  end;

const
{ constants referencing the value of the tag property in components }
  TAG_SRC_DFLT = 11;                             // default patient list
  TAG_SRC_PROV = 12;                             // patient list by provider
  TAG_SRC_TEAM = 13;                             // patient list by team
  TAG_SRC_SPEC = 14;                             // patient list by treating specialty
  TAG_SRC_CLIN = 16;                             // patient list by clinic
  TAG_SRC_WARD = 17;                             // patient list by ward
  TAG_SRC_PCMM = 18;                             // patient list by PCMM team added 5/27/2014 by TDP
  TAG_SRC_ALL  = 19;                             // all patients
  TAG_SRC_HIST = 20;                             // History

var
  frmPtSelOptns: TfrmPtSelOptns;
  clinDoSave, clinSaveToday: boolean;
  clinDefaults: string;
{$IFDEF PTSEL_HISTORY}
  ptSelHistory: TStringList;
{$ENDIF}
implementation

{$R *.DFM}

uses
  rCore, fPtSelOptSave, fPtSel, VA508AccessibilityRouter, VAUtils, uSimilarNames;

const
  TX_LS_DFLT = 'This is already saved as your default patient list settings.';
  TX_LS_PROV = 'A provider must be selected to save patient list settings.';
  TX_LS_TEAM = 'A team must be selected to save patient list settings.';
  TX_LS_SPEC = 'A specialty must be selected to save patient list settings.';
  TX_LS_CLIN = 'A clinic and a date range must be selected to save settings for a clinic.';
  TX_LS_WARD = 'A ward must be selected to save patient list settings.';
  TX_LS_PCMM = 'A PCMM team must be selected to save patient list settings.';
  TC_LS_FAIL = 'Unable to Save Patient List Settings';
  TX_LS_SAV1 = 'Save ';
  TX_LS_SAV2 = CRLF + 'as your default patient list setting?';
  TC_LS_SAVE = 'Save Patient List Settings';

  iGap = 5; //

////////////////////////////////////////////////////////////////////////////////

function TfrmPtSelOptns.IsLast5(x: string): Boolean;
{ returns true if string matchs patterns: A9999 or 9999 (BS & BS5 xrefs for patient lookup) }
var
  i: Integer;
begin
  Result := False;
  if not ((Length(x) = 4) or (Length(x) = 5)) then Exit;
  if Length(x) = 5 then
  begin
    if not CharInSet(x[1], ['A'..'Z', 'a'..'z']) then Exit;
    x := Copy(x, 2, 4);
  end;
  for i := 1 to 4 do if not CharInSet(x[i], ['0'..'9']) then Exit;
  Result := True;
end;

// PaPI ////////////////////////////////////////////////////////////////////////
procedure TfrmPtSelOptns.lbHistoryClick(Sender: TObject);
begin
{$IFDEF PTSEL_HISTORY}
  inherited;
  if lbHistory.ItemIndex <0 then
    exit;
  with parent.parent as TfrmPtSel do
    begin
      cboPatient.Text := lbHistory.Items[lbHistory.ItemIndex];
      cboPatient.InitLongList(cboPatient.Text);
      cboPatient.ItemIndex := 0;
      cboPatientKeyPause(nil);
    end;
{$ENDIF}
end;

procedure TfrmPtSelOptns.lbHistoryDblClick(Sender: TObject);
begin
{$IFDEF PTSEL_HISTORY}
  inherited;
  with parent.parent as TfrmPtSel do
    cmdOKClick(nil);
{$ENDIF}
end;

procedure TfrmPtSelOptns.orapnlMainResize(Sender: TObject);
begin
  inherited;
  if Assigned(cboDateRange) then
  begin
    cboDateRange.Top := Height - cboDateRange.Height;
    if Assigned(lblDateRange) then
    begin
      lblDateRange.Top := cboDateRange.Top - lblDateRange.Height - iGap;
      UpdateListHeight(lblDateRange.Visible);
    end else begin
      UpdateListHeight(False);
    end;
  end;
end;

procedure TfrmPtSelOptns.radHistoryClick(Sender: TObject);
begin
{$IFDEF PTSEL_HISTORY}
  inherited;
  radHideSrcClick(Sender);
  lbHistory.Items.Assign(ptSelHistory);
  lbHistory.Visible := True;
{$ENDIF}
end;
/////////////////////////////////////////////////////////////////////////// PaPI

function TfrmPtSelOptns.IsFullSSN(x: string): boolean;
var
  i: integer;
begin
  Result := False;
  if (Length(x) < 9) or (Length(x) > 12) then Exit;
  case Length(x) of
    9:  // no dashes, no 'P'
        for i := 1 to 9 do if not CharInSet(x[i], ['0'..'9']) then Exit;
   10:  // no dashes, with 'P'
        begin
          for i := 1 to 9 do if not CharInSet(x[i], ['0'..'9']) then Exit;
          if (Uppercase(x[10]) <> 'P') then Exit;
        end;
   11:  // dashes, no 'P'
        begin
          if (x[4] <> '-') or (x[7] <> '-') then Exit;
          x := Copy(x,1,3) + Copy(x,5,2) + Copy(x,8,4);
          for i := 1 to 9 do if not CharInSet(x[i], ['0'..'9']) then Exit;
        end;
   12:  // dashes, with 'P'
        begin
          if (x[4] <> '-') or (x[7] <> '-') then Exit;
          x := Copy(x,1,3) + Copy(x,5,2) + Copy(x,8,5);
          for i := 1 to 9 do if not CharInSet(x[i], ['0'..'9']) then Exit;
          if UpperCase(x[10]) <> 'P' then Exit;
        end;
  end;
  Result := True;
end;

procedure TfrmPtSelOptns.radHideSrcClick(Sender: TObject);
{ called by radDflt & radAll - hides list source combo box and refreshes patient list }
begin
  cboList.Pieces := '2';
  FSrcType := TControl(Sender).Tag;
  FLastTopList := '';
  HideDateRange;
  cboList.Visible := False;
  cboList.Caption := TRadioButton(Sender).Caption;
  FSetCaptionTop;
  FSetPtListTop(0);
  lbHistory.Visible := False; // PaPI
end;

procedure TfrmPtSelOptns.radShowSrcClick(Sender: TObject);
{ called by radTeams, radSpecialties, radWards - shows items for the list source }
begin
  lbHistory.Visible := False; // PaPI
  cboList.Pieces := '2';
  FSrcType := TControl(Sender).Tag;
  FLastTopList := '';
  HideDateRange;
  FSetCaptionTop;
  with cboList do
  begin
    Clear;
    LongList := False;
    Sorted := True;
    case FSrcType of
    TAG_SRC_TEAM: ListTeamAll(Items);
    TAG_SRC_SPEC: ListSpecialtyAll(Items);
    TAG_SRC_WARD: ListWardAll(Items);
    TAG_SRC_PCMM: ListPcmmAll(Items);  // TDP - Added 5/27/2014 PCMM team
    end;
    Visible := True;
  end;
  cboList.Caption := TRadioButton(Sender).Caption;
end;

procedure TfrmPtSelOptns.radLongSrcClick(Sender: TObject);
{ called by radProviders, radClinics - switches to long list & shows items for the list source }
begin
  if lbHistory.Visible then
    lbHistory.Hide; // AA 20150917
  cboList.Pieces := '2';
  FSrcType := TControl(Sender).Tag;
  FLastTopList := '';
  FSetCaptionTop;
  with cboList do
  begin
    Sorted := False;
    LongList := True;
    Clear;
    case FSrcType of
    TAG_SRC_PROV: begin
                    cboList.Pieces := '2,3';
                    HideDateRange;
//                    ListProviderTop(Items); -- blank procedure
                  end;
    TAG_SRC_CLIN: begin
                    ShowDateRange;
                    ListClinicTop(Items);
                  end;
    end;
    InitLongList('');
    Visible := True;
  end;
  cboList.Caption := TRadioButton(Sender).Caption;
end;

procedure TfrmPtSelOptns.cboListChange(Sender: TObject);
begin
  inherited;
  UpdatePtSelection;
end;

procedure TfrmPtSelOptns.cboListEnter(Sender: TObject);
begin
  inherited;
  if radProviders.Checked then
    FChanging := true;
end;

procedure TfrmPtSelOptns.cboListExit(Sender: TObject);
begin
  if FChanging and radProviders.Checked then
  begin
    FChanging := False;
    cboListChange(sender);
  end;
end;

procedure TfrmPtSelOptns.cboListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if radProviders.Checked then
  begin
    FChanging := True;

    if Key = VK_LEFT then
      Key := VK_UP;
    if Key = VK_RIGHT then
      Key := VK_DOWN;
    if Key = VK_RETURN then
      FChanging := False;
  end;
end;

procedure TfrmPtSelOptns.cboListKeyPause(Sender: TObject);
begin
  UpdatePtSelection;
end;

procedure TfrmPtSelOptns.cboListMouseClick(Sender: TObject);
begin
  if FChanging and radProviders.Checked then
  begin
    FChanging := False;
    UpdatePtSelection
  end;
end;

procedure TfrmPtSelOptns.cboListNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
{CQ6363 Notes: This procedure was altered for CQ6363, but then changed back to its original form, as it is now.

The problem is that in LOM1T, there are numerous entries in the HOSPITAL LOCATION file (44) that are lower-case,
resulting in a "B" xref that looks like this:

^SC("B","module 1x",2897) =
^SC("B","pt",3420) = 
^SC("B","read",3146) = 
^SC("B","zz GIM/WONG NEW",2902) = 
^SC("B","zz bhost/arm",3076) = 
^SC("B","zz bhost/day",2698) = 
^SC("B","zz bhost/eve/ornelas",2885) = 
^SC("B","zz bhost/resident",2710) = 
^SC("B","zz bhost/sws",2946) = 
^SC("B","zz c&P ortho/patel",3292) = 
^SC("B","zz mhc md/kelley",320) = 
^SC("B","zz/mhc/p",1076) =
^SC("B","zzMHC MD/THRASHER",1018) =
^SC("B","zztest clinic",3090) =
^SC("B","zzz-hbpc-phone-jung",1830) =
^SC("B","zzz-hbpcphone cocohran",1825) =
^SC("B","zzz-home service",1428) =
^SC("B","zzz-phone-deloye",1834) =
^SC("B","zzz/gmonti impotence",2193) =

ASCII sort mode puts those entries at the end of the "B" xref, but when retrieved by CPRS and upper-cased, it
messes up the logic of the combo box.  This problem has been around since there was a CPRS GUI, and the best
possible fix is to require those entries to either be in all uppercase or be removed.  If that's cleaned up,
the logic below will work correctly.
}
var
  Dest:TStrings;
begin
  Dest := TStringList.Create;
  try
  case frmPtSelOptns.SrcType of
    TAG_SRC_PROV: setSubSetOfProviders(cboList, Dest,StartFrom, Direction);
    TAG_SRC_CLIN: setSubSetOfClinics(Dest,StartFrom, Direction);
  end;
  cboList.ForDataUse(Dest);
  finally
    Dest.Free;
  end;
end;

procedure TfrmPtSelOptns.UpdateListHeight(ShowDate:Boolean);
begin
  if Assigned(cboList) then
  begin
    if ShowDate and Assigned(lblDateRange) then
      cboList.Height := lblDateRange.Top - cboList.Top - iGap
    else
      cboList.Height := Self.Height - cboList.Top - iGap;
  end;
end;

procedure TfrmPtSelOptns.HideDateRange;
begin
  lblDateRange.Hide;
  cboDateRange.Hide;
  updateListHeight(lblDateRange.Visible);
end;

procedure TfrmPtSelOptns.ShowDateRange;
var
  DateString, DRStart, DREnd: string;
  TStart, TEnd: boolean;
begin
  with cboDateRange do if Items.Count = 0 then
  begin
    ListDateRangeClinic(Items);
    ItemIndex := 0;
  end;
  DateString := DfltDateRangeClinic; // Returns "^T" even if no settings.
  DRStart := piece(DateString,U,1);
  DREnd := piece(DateString,U,2);
  if (DRStart <> ' ') then
    begin
      TStart := false;
      TEnd := false;
      if ((DRStart = 'T') or (DRStart = 'TODAY')) then
        TStart := true;
      if ((DREnd = 'T') or (DREnd = 'TODAY')) then
        TEnd := true;
      if not (TStart and TEnd) then
        cboDateRange.ItemIndex := cboDateRange.Items.Add(DRStart + ';' +
          DREnd + U + DRStart + ' to ' + DREnd);
    end;
  lblDateRange.Show;
  cboDateRange.Show;
  updateListHeight(lblDateRange.Visible);
end;

procedure TfrmPtSelOptns.cboDateRangeChange(Sender: TObject);
begin
  inherited;
  if cboDateRange.ItemIndex <> FLastDateIndex then cboDateRangeMouseClick(Self);
end;

procedure TfrmPtSelOptns.cboDateRangeExit(Sender: TObject);
begin
  if cboDateRange.ItemIndex <> FLastDateIndex then cboDateRangeMouseClick(Self);
end;

procedure TfrmPtSelOptns.cboDateRangeMouseClick(Sender: TObject);
begin
  if (cboDateRange.ItemID = 'S') then
  begin
    with calApptRng do if Execute
      then cboDateRange.ItemIndex := cboDateRange.Items.Add(RelativeStart + ';' +
           RelativeStop + U + TextOfStart + ' to ' + TextOfStop)
      else cboDateRange.ItemIndex := -1;
  end;
  FLastDateIndex := cboDateRange.ItemIndex;
  FDateRangeChanged := True;
  UpdatePtSelection;
end;

procedure TfrmPtSelOptns.cmdSaveListClick(Sender: TObject);
var
  x: string;
begin
  x := '';
  case FSrcType of
  TAG_SRC_DFLT: InfoBox(TX_LS_DFLT, TC_LS_FAIL, MB_OK);
  TAG_SRC_PROV: if cboList.ItemIEN <= 0
                  then InfoBox(TX_LS_PROV, TC_LS_FAIL, MB_OK)
                  else x := 'P^' + IntToStr(cboList.ItemIEN) + U + U +
                            'Provider = ' + cboList.Text;
  TAG_SRC_TEAM: if cboList.ItemIEN <= 0
                  then InfoBox(TX_LS_TEAM, TC_LS_FAIL, MB_OK)
                  else x := 'T^' + IntToStr(cboList.ItemIEN) + U + U +
                            'Team = ' + cboList.Text;
  TAG_SRC_SPEC: if cboList.ItemIEN <= 0
                  then InfoBox(TX_LS_SPEC, TC_LS_FAIL, MB_OK)
                  else x := 'S^' + IntToStr(cboList.ItemIEN) + U + U +
                            'Specialty = ' + cboList.Text;
  TAG_SRC_CLIN: if (cboList.ItemIEN <= 0) or (Pos(';', cboDateRange.ItemID) = 0)
                  then InfoBox(TX_LS_CLIN, TC_LS_FAIL, MB_OK)
                  else
                    begin
                      clinDefaults := 'Clinic = ' + cboList.Text + ',  ' + cboDaterange.text;
                      frmPtSelOptSave := TfrmPtSelOptSave.create(Application); // Calls dialogue form for user input.
                      frmPtSelOptSave.showModal;
                      frmPtSelOptSave.free;
                      if (not clinDoSave) then
                        Exit;
                      if clinSaveToday then
                        x := 'CT^' + IntToStr(cboList.ItemIEN) + U + cboDateRange.ItemID + U +
                            'Clinic = ' + cboList.Text + ',  ' +  cboDateRange.Text
                      else
                        x := 'C^' + IntToStr(cboList.ItemIEN) + U + cboDateRange.ItemID + U +
                            'Clinic = ' + cboList.Text + ',  ' +  cboDateRange.Text;
                    end;
  TAG_SRC_WARD: if cboList.ItemIEN <= 0
                  then InfoBox(TX_LS_WARD, TC_LS_FAIL, MB_OK)
                  else x := 'W^' + IntToStr(cboList.ItemIEN) + U + U +
                            'Ward = ' + cboList.Text;
  // TDP - Added 5/27/2014 to handle PCMM team addition
  TAG_SRC_PCMM: if cboList.ItemIEN <= 0
                  then InfoBox(TX_LS_PCMM, TC_LS_FAIL, MB_OK)
                  else x := 'E^' + IntToStr(cboList.ItemIEN) + U + U +
                            'PCMM Team = ' + cboList.Text;
  TAG_SRC_ALL : x := 'A';
  end;
  if (x <> '') then
    begin
      if not (FSrcType = TAG_SRC_CLIN) then // Clinics already have a "confirm" d-box.
        begin
          if (InfoBox(TX_LS_SAV1 + Piece(x, U, 4) + TX_LS_SAV2, TC_LS_SAVE, MB_YESNO) = IDYES) then
            begin
              SavePtListDflt(x);
              UpdateDefault;
            end;
        end
      else // Skip second confirmation box for clinics.
        begin
          SavePtListDflt(x);
          UpdateDefault;
        end;
    end;
end;

procedure TfrmPtSelOptns.FormCreate(Sender: TObject);
begin
  FLastDateIndex := -1;
{$IFDEF PTSEL_HISTORY}
  radHistory.Visible := True;
{$ELSE}
  radHistory.Visible := False;
{$ENDIF}
  FChanging := false;
end;

procedure TfrmPtSelOptns.FormDestroy(Sender: TObject);
begin
  frmPtSelOptns := nil;
  inherited;
end;

procedure TfrmPtSelOptns.SetDefaultPtList(Dflt: string);

  procedure AdjustRadioButtons(aVisible:Boolean);
  var
    cmp: TControl;
    i, off: Integer;
  begin
    if aVisible then
      exit;
    // move buttons up if radDflt is hidden
    off := radProviders.Top - radDflt.Top;
//    bvlPtList.Height := bvlPtList.Height - off;
    for i := 0 to bvlPtList.ControlCount -1 do
      begin
        cmp := bvlPtList.Controls[i];
        if (cmp is TRadioButton) and (cmp <> radDflt) then
          TRadioButton(cmp).Top := TRadioButton(cmp).Top - off;
      end;
    bvlPtList.Invalidate;
    Application.ProcessMessages;
  end;

begin
  //blj 22 September 2017 258066 - We will not show the Default patient list button unless
  //     we actually have a default patient list coming in.
  radDflt.Visible := Length(Dflt) > 0;

  if Length(Dflt) > 0 then                   // if default patient list available, use it
  begin
    radDflt.Caption := '&Default: ' + Dflt;
    radDflt.Checked := True;                 // causes radHideSrcClick to be called
    radDflt.Enabled := True;
  end
  else                                       // otherwise, select from all patients
  begin
    radDflt.Enabled := False;
    radAll.Checked := True;                  // causes radHideSrcClick to be called
    bvlPtList.TabStop := True;
    bvlPtList.Hint := 'No default radio button unavailable 1 of 7 to move to the other patient list categories press tab';
    // fixes CQ #4716: 508 - No Default rad btn on Patient Selection screen doesn't read in JAWS. [CPRS v28.1] (TC).
    adjustRadioButtons(radDflt.Enabled);
  end;
end;

procedure TfrmPtSelOptns.UpdateDefault;
begin
  FSrcType := TAG_SRC_DFLT;
  fPtSel.FDfltSrc := DfltPtList; // Server side default setting: "DfltPtList" is in rCore.
  fPtSel.FDfltSrcType := Piece(fPtSel.FDfltSrc, U, 2);
  fPtSel.FDfltSrc := Piece(fPtSel.FDfltSrc, U, 1);
  if (IsRPL = '1') then // Deal with restricted patient list users.
    fPtSel.FDfltSrc := '';
  SetDefaultPtList(fPtSel.FDfltSrc);
end;

Procedure TfrmPtSelOptns.UpdatePtSelection;
var
  aErrMsg: String;
begin
  if FChanging then
    Exit;

  if cboList.ItemIEN > 0 then
  begin
    if (not FDateRangeChanged) and
      (cboList.ItemIEN =  StrToIntDef(Piece(FLastTopList, U, 2), -1)) then
        exit;
    FDateRangeChanged := False;
    if FSrcType = TAG_SRC_PROV then
    begin
      If not CheckForSimilarName(cboList, aErrMsg, sPr) then
       ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection')
      else
       FSetPtListTop(cboList.ItemIEN);
    end else
    begin
     // The following line was removed for VISTAOR-30569
     // cboList.SelectByIEN(cboList.ItemIEN);
      FSetPtListTop(cboList.ItemIEN);
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPtSelOptns);
{$IFDEF PTSEL_HISTORY}
  ptSelHistory := TStringList.Create;
{$ENDIF}
finalization
{$IFDEF PTSEL_HISTORY}
  FreeAndNil(ptSelHistory);
{$ENDIF}
end.
