unit fODAllgy;
{$O-}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ORCtrls, ORfn, fODBase, ExtCtrls, ComCtrls, uConst,
  Menus, ORDtTm, Buttons, VA508AccessibilityManager;

type
  TfrmODAllergy = class(TfrmODBase)
    btnAgent: TSpeedButton;
    cboReactionType: TORComboBox;
    lblReactionType: TOROffsetLabel;
    lblAgent: TOROffsetLabel;
    lblSymptoms: TOROffsetLabel;
    lblSelectedSymptoms: TOROffsetLabel;
    grpObsHist: TRadioGroup;
    memComments: TRichEdit;
    lblComments: TOROffsetLabel;
    lstSelectedSymptoms: TORListBox;
    ckNoKnownAllergies: TCheckBox;
    cboOriginator: TORComboBox;
    lblOriginator: TOROffsetLabel;
    Bevel1: TBevel;
    lstAllergy: TORListBox;
    cboSymptoms: TORComboBox;
    dlgReactionDateTime: TORDateTimeDlg;
    btnCurrent: TButton;
    lblObservedDate: TOROffsetLabel;
    calObservedDate: TORDateBox;
    lblSeverity: TOROffsetLabel;
    cboSeverity: TORComboBox;
    btnRemove: TButton;
    btnDateTime: TButton;
    procedure btnAgentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboOriginatorNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboSymptomsNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure lstAllergySelect(Sender: TObject);
    procedure grpObsHistClick(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure memCommentsExit(Sender: TObject);
    procedure cboSymptomsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ckNoKnownAllergiesClick(Sender: TObject);
    procedure EnableControls;
    procedure DisableControls;
    procedure cmdAcceptClick(Sender: TObject);
    procedure btnCurrentClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure lstAllergyClick(Sender: TObject);
    procedure btnDateTimeClick(Sender: TObject);
    procedure cboSymptomsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboSymptomsMouseClick(Sender: TObject);
    procedure memCommentsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FLastAllergyID: string;
    FNKAOrder: boolean;
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

var
  frmODAllergy: TfrmODAllergy;
  AllergyList: TStringList;

implementation

{$R *.DFM}

uses
    rODBase, uCore, rCore, rCover, rODAllergy, fAllgyFind, fPtCWAD;

const
  TX_NO_ALLERGY       = 'An allergy must be specified.'    ;
  TX_NO_REACTION      = 'A reaction type must be entered for this allergy.'  ;
  TX_NO_SYMPTOMS      = 'Symptoms must be selected for this observed allergy and reaction.';
  TX_NO_OBSERVER      = 'An observer must be selected for this allergy and reaction .';
  TX_NO_FUTURE_DATES  = 'Dates in the future are not allowed.';
  TX_BAD_DATE         = 'Dates must be in the format m/d/y or m/y or y, or T-d.';
  TX_CAP_FUTURE       = 'Invalid date';

procedure TfrmODAllergy.FormCreate(Sender: TObject);
begin
  inherited;
  AllergyList := TStringList.Create;
  AllowQuickOrder := False;
  FillerID := 'GMRD';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'GMRAOR ALLERGY ENTER/EDIT';   // loads formatting info
  StatusText('Loading Default Values');
  CtrlInits.LoadDefaults(ODForAllergies);  // returns TStrings with defaults
  StatusText('Initializing Long List');
  CtrlInits.SetControl(cboSymptoms, 'Top Ten');
  cboSymptoms.InsertSeparator;
  cboOriginator.InitLongList(User.Name) ;
  cboOriginator.SelectByIEN(User.DUZ);
  PreserveControl(cboSymptoms);
  PreserveControl(cboOriginator);
  InitDialog;
  btnAgentClick(Self);
end;

procedure TfrmODAllergy.InitDialog;
begin
  inherited;
  Changing := True;
  with CtrlInits do
    begin
      SetControl(cboReactionType, 'Reactions');
      SetControl(cboSeverity, 'Severity');
    end;
  lstAllergy.Items.Add('-1^Click button to search ---->');
  grpObsHist.ItemIndex := 1;
  calObservedDate.Text := ''; //FMDateTime := FMNow;
  cboSeverity.ItemIndex := -1;
  cboSymptoms.ItemIndex := -1;
  memComments.Clear;
  ListAllergies(AllergyList);
  with AllergyList do
    if Count > 0 then
      begin
        if Piece(Strings[0], U, 1) = '' then
          ckNoKnownAllergies.Enabled := True
        else
          ckNoKnownAllergies.Enabled := False;
      end
    else
      ckNoKnownAllergies.Enabled := True;
  StatusText('');
  memOrder.Clear ;
  Changing := False;
end;

procedure TfrmODAllergy.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    SetControl(lstAllergy,          'ITEM',   1);
    lstAllergySelect(Self);
    Changing := True;
    SetControl(cboReactionType,     'TYPE',     1);
    SetControl(lstSelectedSymptoms, 'REACTION',     1);     // need dates concatenated  - see cboSymptomsClick
    SetControl(grpObsHist,          'OBSERVED',     1);
    SetControl(calObservedDate,     'START',     1);
    SetControl(cboSeverity,         'SEVERITY',     1);
    SetControl(memComments,         'COMMENT',   1);
    SetControl(ckNoKnownAllergies,  'NKA',       1);
    SetControl(cboOriginator,       'PROVIDER',  1);
    Changing := False;
    ControlChange(Self);
  end;
end;

procedure TfrmODAllergy.Validate(var AnErrMsg: string);
var
  tmpDate: TFMDateTime;
const
  TX_NO_LOCATION = 'A location must be identified.' + CRLF +
                   '(Select File | Update Provider/Location)';
  TX_NO_PROVIDER = 'A provider who is authorized to write orders must be indentified.' + CRLF +
                   '(Select File | Update Provider/Location)';

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
//  inherited;    v14a -  do not reject past dates - historical would not be allowed
  AnErrMsg := '';
  if User.NoOrdering then AnErrMsg := 'Ordering has been disabled.  Press Quit.';
  if not ckNoKnownAllergies.Checked then
    begin
      if lstAllergy.Items.Count = 0 then SetError(TX_NO_ALLERGY)
      else if (Length(lstAllergy.DisplayText[0]) = 0) or
         (Piece(lstAllergy.Items[0], U, 1) = '-1') then SetError(TX_NO_ALLERGY);
      if (grpObsHist.ItemIndex = 0) and (lstSelectedSymptoms.Items.Count = 0)   then SetError(TX_NO_SYMPTOMS);
      if cboReactionType.ItemID = '' then
        SetError(TX_NO_REACTION)
      else
        Responses.Update('TYPE', 1, cboReactionType.ItemID, cboReactionType.Text);
    end;
  if cboOriginator.ItemIEN = 0             then SetError(TX_NO_OBSERVER);
  if calObservedDate.Text <> '' then
    begin
      tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');
      if tmpDate > FMNow then  SetError(TX_NO_FUTURE_DATES);
      if tmpDate < 0 then SetError(TX_BAD_DATE);
    end;
  if (Encounter.Location = 0) and not(Self.EvtID>0) then AnErrMsg := TX_NO_LOCATION;
  if (Encounter.Provider = 0) or (PersonHasKey(Encounter.Provider, 'PROVIDER') = False)
    then AnErrMsg := TX_NO_PROVIDER;
end;

procedure TfrmODAllergy.cboOriginatorNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  cboOriginator.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmODAllergy.cboSymptomsNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  cboSymptoms.ForDataUse(SubSetOfSymptoms(StartFrom, Direction));
end;

procedure TfrmODAllergy.grpObsHistClick(Sender: TObject);
begin
  inherited;
  Changing := True;
  cboSeverity.ItemIndex := -1;
  case grpObsHist.ItemIndex of
    0:  begin
          cboSeverity.Visible := True;
          lblSeverity.Visible := True;
        end;
    1:  begin
          cboSeverity.Visible := False;
          lblSeverity.Visible := False;
        end;
  end;
  Changing := False;
  ControlChange(Self);
end;

procedure TfrmODAllergy.ControlChange(Sender: TObject);
var
  i: integer;
  tmpDate: TFMDateTime;
begin
  inherited;
  if Changing then Exit;
  Responses.Clear;
  if ckNoKnownAllergies.Checked then
    begin
      Responses.Update('NKA',       1, 'NKA', 'No Known Allergies');
      with cboOriginator       do if ItemIEN      > 0 then Responses.Update('PROVIDER',  1, ItemID, Text);
    end
  else
    with lstAllergy          do
      if (Items.Count > 0) then
        if (Piece(Items[0], U, 1) <>  '-1') and (Length(DisplayText[0]) > 0) then
          begin
            Responses.Update('ITEM', 1, DisplayText[0], DisplayText[0]);
            with cboReactionType     do if ItemID     <> '' then Responses.Update('TYPE', 1, ItemID, Text);
            with lstSelectedSymptoms do for i := 0 to Items.Count - 1 do
              begin
                Responses.Update('REACTION', i+1, Piece(Items[i],U,1), Piece(Items[i],U,2));
                Responses.Update('REACTDT',  i+1, Piece(Items[i],U,3), Piece(Items[i],U,4));
              end;
            with grpObsHist          do if ItemIndex   > -1 then
                                        if ItemIndex = 0    then Responses.Update('OBSERVED',     1, 'o', 'Observed')
                                        else                     Responses.Update('OBSERVED',     1, 'h', 'Historical');
            with calObservedDate do
              begin
                tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');
                if tmpDate   > 0 then Responses.Update('START',     1, FloatToStr(tmpDate), Text);
              end;
            with cboSeverity         do if ItemID     <> '' then Responses.Update('SEVERITY',     1, ItemID, Text);
            with cboOriginator       do if ItemIEN      > 0 then Responses.Update('PROVIDER',  1, ItemID, Text);
            with memComments         do if GetTextLen   > 0 then Responses.Update('COMMENT',   1, TX_WPTYPE, Text);
          end;
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODAllergy.lstAllergySelect(Sender: TObject);
begin
  inherited;
  with lstAllergy do
    begin
      if Items.Count = 0 then
        Exit
      else if Piece(Items[0], U, 1) = '-1' then
        Exit;
      if Piece(Items[0], U, 1) <> FLastAllergyID then FLastAllergyID := Piece(Items[0], U, 1) else Exit;
      Changing := True;
      if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
      Changing := False;
      if CharAt(Piece(Items[0], U, 1), 1) = 'Q' then
        begin
          Responses.QuickOrder := ExtractInteger(Piece(Items[0], U, 1));
          Responses.SetControl(lstAllergy, 'ITEM', 1);
          FLastAllergyID := Piece(Items[0], U, 1);
        end;
    end;
  with Responses do if QuickOrder > 0 then
    begin
    SetControl(lstAllergy,          'ITEM',   1);
    lstAllergySelect(Self);
    Changing := True;
    SetControl(cboReactionType,     'TYPE',     1);
    SetControl(lstSelectedSymptoms, 'REACTION',     1);
    SetControl(grpObsHist,          'OBSERVED',     1);
    SetControl(calObservedDate,     'START',     1);
    SetControl(cboSeverity,         'SEVERITY',     1);
    SetControl(memComments,         'COMMENT',   1);
    SetControl(ckNoKnownAllergies,  'NKA',       1);
    SetControl(cboOriginator,       'PROVIDER',  1);
    end;
  ControlChange(Self) ;
end;

procedure TfrmODAllergy.memCommentsExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    FastAssign(memComments.Lines, AStringList);
    LimitStringLength(AStringList, 74);
    QuickCopy(AstringList, memComments);
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmODAllergy.btnAgentClick(Sender: TObject);
var
  Allergy: string;
begin
  inherited;
  AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
  if Piece(Allergy, U, 1) = '-1' then
    ckNoKnownAllergies.Checked := True
  else
    if Allergy <> '' then
      begin
        lstAllergy.Clear;
        lstAllergy.Items.Add(Allergy);
        cboReactionType.SelectByID(Piece(Allergy, U, 4));
      end
  else
    Close;
  ControlChange(lstAllergy);
end;

procedure TfrmODAllergy.cboSymptomsClick(Sender: TObject);
begin
  inherited;
  if cboSymptoms.ItemIndex < 0 then exit;
  Changing := True;
  if lstSelectedSymptoms.SelectByID(cboSymptoms.ItemID) > -1 then exit;
  with lstSelectedSymptoms do
    begin
      Items.Add(cboSymptoms.Items[cboSymptoms.ItemIndex]);
      SelectByID(cboSymptoms.ItemID);
    end;
  Changing := False;
  ControlChange(Self)
end;

procedure TfrmODAllergy.FormDestroy(Sender: TObject);
begin
  AllergyList.Free;
  inherited;
end;

procedure TfrmODAllergy.ckNoKnownAllergiesClick(Sender: TObject);
begin
  inherited;
  if ckNoKnownAllergies.Checked then
    begin
      DisableControls;
      FNKAOrder := True;
    end
  else
    begin
      EnableControls;
      FNKAOrder := False;
    end;
  ControlChange(Self);
end;

procedure TfrmODAllergy.DisableControls;
begin
   InitDialog;
   btnAgent.Enabled            := False;
   cboReactionType.Enabled     := False;
   lblReactionType.Enabled     := False;
   lblAgent.Enabled            := False;
   lblSymptoms.Enabled         := False;
   lblSelectedSymptoms.Enabled := False;
   grpObsHist.Enabled          := False;
   memComments.Enabled         := False;
   lblComments.Enabled         := False;
   lstSelectedSymptoms.Enabled := False;
   lblObservedDate.Enabled     := False;
   calObservedDate.Enabled     := False;
   lblSeverity.Enabled         := False;
   cboSeverity.Enabled         := False;
   lstAllergy.Enabled          := False;
   cboSymptoms.Enabled         := False;
   btnDateTime.Enabled         := False;
end;

procedure TfrmODAllergy.EnableControls;
begin
   InitDialog;
   btnAgent.Enabled            := True;
   cboReactionType.Enabled     := True;
   lblReactionType.Enabled     := True;
   lblAgent.Enabled            := True;
   lblSymptoms.Enabled         := True;
   lblSelectedSymptoms.Enabled := True;
   grpObsHist.Enabled          := True;
   memComments.Enabled         := True;
   lblComments.Enabled         := True;
   lstSelectedSymptoms.Enabled := True;
   lblObservedDate.Enabled     := True;
   calObservedDate.Enabled     := True;
   lblSeverity.Enabled         := True;
   cboSeverity.Enabled         := True;
   lstAllergy.Enabled          := True;
   cboSymptoms.Enabled         := True;
   btnDateTime.Enabled         := True;
end;

procedure TfrmODAllergy.cmdAcceptClick(Sender: TObject);
begin
  if not FNKAOrder then
    inherited
  else
    if ValidSave then
      begin
        ckNoKnownAllergies.Checked := False;
        memOrder.Clear;
        Responses.Clear;    // to allow form to close without prompting to save order
        Close;
      end;
end;

procedure TfrmODAllergy.btnCurrentClick(Sender: TObject);
begin
  inherited;
  ShowCWAD;
end;


procedure TfrmODAllergy.btnRemoveClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  with lstSelectedSymptoms do
    begin
      if (Items.Count = 0) or (ItemIndex = -1) then exit;
      i := ItemIndex;
      Items.Delete(ItemIndex);
      ItemIndex := i - 1;
      if (Items.Count > 0) and (ItemIndex = -1) then ItemIndex := 0;
    end;
end;

procedure TfrmODAllergy.lstAllergyClick(Sender: TObject);
begin
  inherited;
  lstAllergy.ItemIndex := -1;
end;

procedure TfrmODAllergy.btnDateTimeClick(Sender: TObject);
begin
  inherited;
  with lstSelectedSymptoms do
    begin
      if (Items.Count = 0) or (ItemIndex = -1) then exit;
      dlgReactionDateTime.FMDateTime := FMNow;
      if not dlgReactionDateTime.Execute then exit;
      if dlgReactionDateTime.FMDateTime > FMNow then
        InfoBox(TX_NO_FUTURE_DATES, TX_CAP_FUTURE, MB_OK)
      else
        Items[ItemIndex] := Items[ItemIndex] + U + FloatToStr(dlgReactionDateTime.FMDateTime) + U + FormatFMDateTime('yyyy/mm/dd@hh:nn', dlgReactionDateTime.FMDateTime);
    end;
end;

procedure TfrmODAllergy.cboSymptomsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then cboSymptomsMouseClick(Self);
end;

procedure TfrmODAllergy.cboSymptomsMouseClick(Sender: TObject);
var
  x: string;
begin
  inherited;
  if cboSymptoms.ItemIndex < 0 then exit;
  Changing := True;
  if lstSelectedSymptoms.SelectByID(cboSymptoms.ItemID) > -1 then exit;
  with cboSymptoms do
    if Piece(Items[ItemIndex], U, 3) <> '' then
      x := ItemID + U + Piece(Items[ItemIndex], U, 3)
    else
      x := ItemID + U + Piece(Items[ItemIndex], U, 2);
  with lstSelectedSymptoms do
    begin
      Items.Add(x);
      SelectByID(cboSymptoms.ItemID);
    end;
  Changing := False;
  ControlChange(Self)
end;

procedure TfrmODAllergy.memCommentsKeyUp(Sender: TObject; var Key: Word;
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

end.
