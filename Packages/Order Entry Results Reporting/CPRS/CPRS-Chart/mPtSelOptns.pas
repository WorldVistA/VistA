unit mPtSelOptns;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ORDtTmRng, ORCtrls, ORFn;

type
  TSetCaptionTopProc = procedure of object;
  TSetPtListTopProc = procedure(IEN: Int64) of object;

  TfraPtSelOptns = class(TFrame)
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
    gpRad: TGridPanel;
    gpMain: TGridPanel;
    pnlRad: TPanel;
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
    procedure radHistoryClick(Sender: TObject);
    procedure lbHistoryClick(Sender: TObject);
    procedure lbHistoryDblClick(Sender: TObject);
    procedure cboListChange(Sender: TObject);
    procedure cboDateRangeChange(Sender: TObject);
    procedure cboListEnter(Sender: TObject);
    procedure cboListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FRowHeight: integer;
    FRadRows: integer;
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
    procedure UpdateGrids;
    procedure HideHistory;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    class function IsLast5(x: string): Boolean;
    class function IsFullSSN(x: string): Boolean;
    procedure cmdSaveListClick(Sender: TObject);
    procedure SetDefaultPtList(Dflt: string);
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

  DATECTRL_ADJ = 8;
var
  clinDoSave, clinSaveToday: boolean;
  clinDefaults: string;
{$IFDEF PTSEL_HISTORY}
  ptSelHistory: TStringList;
{$ENDIF}
implementation

{$R *.DFM}

uses
  rCore, fPtSelOptSave, fPtSel, VA508AccessibilityRouter, VAUtils, uSimilarNames,
  UResponsiveGUI;

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

class function TfraPtSelOptns.IsLast5(x: string): Boolean;
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
procedure TfraPtSelOptns.lbHistoryClick(Sender: TObject);
begin
{$IFDEF PTSEL_HISTORY}
  inherited;
  if lbHistory.ItemIndex <0 then
    exit;
  with frmPtSel do
    begin
      cboPatient.Text := lbHistory.Items[lbHistory.ItemIndex];
      cboPatient.InitLongList(cboPatient.Text);
      cboPatient.ItemIndex := 0;
      cboPatientKeyPause(nil);
    end;
{$ENDIF}
end;

procedure TfraPtSelOptns.lbHistoryDblClick(Sender: TObject);
begin
{$IFDEF PTSEL_HISTORY}
  inherited;
  frmPtSel.cmdOKClick(nil);
{$ENDIF}
end;

procedure TfraPtSelOptns.radHistoryClick(Sender: TObject);
begin
{$IFDEF PTSEL_HISTORY}
  inherited;
  radHideSrcClick(Sender);
  lbHistory.Items.Assign(ptSelHistory);
  lbHistory.Visible := True;
  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[2].Value := 0;
    gpMain.RowCollection[5].Value := 100;
  finally
    gpMain.RowCollection.EndUpdate;
  end;
{$ENDIF}
end;
/////////////////////////////////////////////////////////////////////////// PaPI

class function TfraPtSelOptns.IsFullSSN(x: string): boolean;
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

procedure TfraPtSelOptns.radHideSrcClick(Sender: TObject);
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
  HideHistory;
end;

procedure TfraPtSelOptns.radShowSrcClick(Sender: TObject);
{ called by radTeams, radSpecialties, radWards - shows items for the list source }
begin
  HideHistory;
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

procedure TfraPtSelOptns.radLongSrcClick(Sender: TObject);
{ called by radProviders, radClinics - switches to long list & shows items for the list source }
begin
  HideHistory;
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

procedure TfraPtSelOptns.cboListChange(Sender: TObject);
begin
  inherited;
  UpdatePtSelection;
end;

procedure TfraPtSelOptns.cboListEnter(Sender: TObject);
begin
  inherited;
  if radProviders.Checked then
    FChanging := true;
end;

procedure TfraPtSelOptns.cboListExit(Sender: TObject);
begin
  if FChanging and radProviders.Checked then
  begin
    FChanging := False;
    cboListChange(sender);
  end;
end;

procedure TfraPtSelOptns.cboListKeyDown(Sender: TObject; var Key: Word;
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

procedure TfraPtSelOptns.cboListKeyPause(Sender: TObject);
begin
  UpdatePtSelection;
end;

procedure TfraPtSelOptns.cboListMouseClick(Sender: TObject);
begin
  if FChanging and radProviders.Checked then
  begin
    FChanging := False;
    UpdatePtSelection
  end;
end;

procedure TfraPtSelOptns.cboListNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
var
  Dest:TStrings;
begin
  Dest := TStringList.Create;
  try
    case SrcType of
      TAG_SRC_PROV: setSubSetOfProviders(cboList, Dest, StartFrom, Direction);
      TAG_SRC_CLIN: setSubSetOfClinics(Dest, StartFrom, Direction);
    end;
    cboList.ForDataUse(Dest);
  finally
    Dest.Free;
  end;
end;

procedure TfraPtSelOptns.HideDateRange;
begin
  cboDateRange.Hide;
  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[3].Value := 0;
    gpMain.RowCollection[4].Value := 0;
  finally
    gpMain.RowCollection.EndUpdate;
  end;
end;

procedure TfraPtSelOptns.HideHistory;
begin
{$IFDEF PTSEL_HISTORY}
  lbHistory.Visible := False;
  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[2].Value := 100;
    gpMain.RowCollection[5].Value := 0;
  finally
    gpMain.RowCollection.EndUpdate;
  end;
{$ENDIF}
end;

procedure TfraPtSelOptns.ShowDateRange;
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
  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[3].Value := FRowHeight;
    gpMain.RowCollection[4].Value := FRowHeight + DATECTRL_ADJ;
  finally
    gpMain.RowCollection.EndUpdate;
  end;      
  cboDateRange.Show;
end;

procedure TfraPtSelOptns.cboDateRangeChange(Sender: TObject);
begin
  inherited;
  if cboDateRange.ItemIndex <> FLastDateIndex then cboDateRangeMouseClick(Self);
end;

procedure TfraPtSelOptns.cboDateRangeExit(Sender: TObject);
begin
  if cboDateRange.ItemIndex <> FLastDateIndex then cboDateRangeMouseClick(Self);
end;

procedure TfraPtSelOptns.cboDateRangeMouseClick(Sender: TObject);
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

procedure TfraPtSelOptns.cmdSaveListClick(Sender: TObject);
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

procedure TfraPtSelOptns.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateGrids;
end;

constructor TfraPtSelOptns.Create(AOwner: TComponent);
begin
  inherited;
  FLastDateIndex := -1;
  FRadRows := 5;
  UpdateGrids;
{$IFDEF PTSEL_HISTORY}
  radHistory.Visible := True;
{$ELSE}
  radHistory.Visible := False;
{$ENDIF}
  lbHistory.Visible := False;
  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[2].Value := 100;
    gpMain.RowCollection[5].Value := 0;
  finally
    gpMain.RowCollection.EndUpdate;
  end;
  FChanging := false;
end;

procedure TfraPtSelOptns.UpdateGrids;
var
  btnList: array [0..1] of array [0..3] of TRadioButton;
  i, j, total, len: integer;
  w: array[0..1] of integer;
  p1, p2: double;

begin
  btnList[0, 0] := radProviders;
  btnList[0, 1] := radTeams;
  btnList[0, 2] := radSpecialties;
  btnList[0, 3] := radHistory;
  btnList[1, 0] := radClinics;
  btnList[1, 1] := radWards;
  btnList[1, 2] := radPcmmTeams;
  btnList[1, 3] := radAll;
  for i := 0 to 1 do
  begin
    w[i] := 0;
    for j := 0 to 3 do
    begin
      len := TextWidthByFont(Font.Handle, btnList[i, j].Caption);
      if w[i] < len then
        w[i] := len;
    end;
    inc(w[i], 25);
  end;
  total := w[0] + w[1];
  p1 := (w[0] / total) * 100;
  p2 := (w[1] / total) * 100;
  gpRad.ColumnCollection.BeginUpdate;
  try
    gpRad.ColumnCollection[0].Value := p1;
    gpRad.ColumnCollection[1].Value := p2;
  finally
    gpRad.ColumnCollection.EndUpdate;
  end;

  FRowHeight := TextHeightByFont(Font.Handle, 'TpWyg') + 4;
  Constraints.MinHeight := FRowHeight * 13 + DATECTRL_ADJ;

  gpMain.RowCollection.BeginUpdate;
  try
    gpMain.RowCollection[0].Value := FRowHeight;
    gpMain.RowCollection[1].Value := FRowHeight * FRadRows;
    if gpMain.RowCollection[3].Value > 0 then
      gpMain.RowCollection[3].Value := FRowHeight;
    if gpMain.RowCollection[4].Value > 0 then
      gpMain.RowCollection[4].Value := FRowHeight + DATECTRL_ADJ;
  finally
    gpMain.RowCollection.EndUpdate;
  end;  
end;

procedure TfraPtSelOptns.SetDefaultPtList(Dflt: string);
var
  i, r: integer;
  
begin
  //blj 22 September 2017 258066 - We will not show the Default patient list button unless
  //     we actually have a default patient list coming in.
  radDflt.Visible := Length(Dflt) > 0;

  if Length(Dflt) > 0 then                   // if default patient list available, use it
  begin
    radDflt.Caption := '&Default: ' + Dflt;
    radDflt.Checked := True;                 // causes radHideSrcClick to be called
    radDflt.Enabled := True;
    FRadRows := 5;
  end
  else                                       // otherwise, select from all patients
  begin
    radDflt.Enabled := False;
    radAll.Checked := True;                  // causes radHideSrcClick to be called
  //  pnlRad.TabStop := True;
    pnlRad.Hint := 'No default radio button unavailable 1 of 7 to move to the other patient list categories press tab';
    FRadRows := 4;
  end;
  gpRad.RowCollection.BeginUpdate;
  try
    r := 100 div FRadRows;
    for i := 0 to 4 do
      if (i = 0) and (FRadRows = 4) then
        gpRad.RowCollection[i].Value := 0
      else
        gpRad.RowCollection[i].Value := r;
    gpMain.RowCollection[1].Value := FRowHeight * FRadRows;
  finally
    gpRad.RowCollection.EndUpdate;
  end;
end;

procedure TfraPtSelOptns.UpdateDefault;
begin
  FSrcType := TAG_SRC_DFLT;
  fPtSel.FDfltSrc := DfltPtList; // Server side default setting: "DfltPtList" is in rCore.
  fPtSel.FDfltSrcType := Piece(fPtSel.FDfltSrc, U, 2);
  fPtSel.FDfltSrc := Piece(fPtSel.FDfltSrc, U, 1);
  if (IsRPL = '1') then // Deal with restricted patient list users.
    fPtSel.FDfltSrc := '';
  SetDefaultPtList(fPtSel.FDfltSrc);
end;

Procedure TfraPtSelOptns.UpdatePtSelection;
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
{$IFDEF PTSEL_HISTORY}
  ptSelHistory := TStringList.Create;
{$ENDIF}
finalization
{$IFDEF PTSEL_HISTORY}
  FreeAndNil(ptSelHistory);
{$ENDIF}
end.