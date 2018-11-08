unit fARTAllgy;
  
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ORCtrls, ORfn, ExtCtrls, ComCtrls, uConst,
  Menus, ORDtTm, Buttons, fODBase, fAutoSz, fOMAction, rODAllergy, uOrders,
  VA508AccessibilityManager;

type
  TfrmARTAllergy = class(TfrmOMAction)
    pnlBase: TORAutoPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    pgAllergy: TPageControl;
    tabGeneral: TTabSheet;
    tabVerify: TTabSheet;
    ckNoKnownAllergies: TCheckBox;
    btnCurrent: TButton;
    lblAgent: TOROffsetLabel;
    lstAllergy: TORListBox;
    btnAgent1: TSpeedButton;
    lblOriginator: TOROffsetLabel;
    cboOriginator: TORComboBox;
    lblOriginateDate: TOROffsetLabel;
    calOriginated: TORDateBox;
    ckChartMarked: TCheckBox;
    ckIDBand: TCheckBox;
    lblVerifier: TOROffsetLabel;
    ckVerified: TCheckBox;
    cboVerifier: TORComboBox;
    calVerifyDate: TORDateBox;
    lblVerifyDate: TOROffsetLabel;
    Bevel1: TBevel;
    lblSymptoms: TOROffsetLabel;
    cboSymptoms: TORComboBox;
    lblSelectedSymptoms: TOROffsetLabel;
    lstSelectedSymptoms: TORListBox;
    btnRemove: TButton;
    grpObsHist: TRadioGroup;
    lblSeverity: TOROffsetLabel;
    cboSeverity: TORComboBox;
    lblObservedDate: TOROffsetLabel;
    calObservedDate: TORDateBox;
    cmdPrevObs: TButton;
    lblComments: TOROffsetLabel;
    memComments: TRichEdit;
    cmdPrevCmts: TButton;
    tabEnteredInError: TTabSheet;
    ckEnteredInError: TCheckBox;
    memErrCmts: TRichEdit;
    lblErrCmts: TLabel;
    lblEnteredInError: TLabel;
    lblAllergyType: TOROffsetLabel;
    cboAllergyType: TORComboBox;
    cboNatureOfReaction: TORComboBox;
    lblNatureOfReaction: TOROffsetLabel;
    btnSevHelp: TORAlignButton;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    VA508ComponentAccessibility2: TVA508ComponentAccessibility;
    origlbl508: TVA508StaticText;
    origdtlbl508: TVA508StaticText;
    SymptomDateBox: TORDateBox;
    btnAgent: TButton;
    VA508ComponentAccessibility3: TVA508ComponentAccessibility;
    NoAllergylbl508: TVA508StaticText;
    procedure btnAgent1Click(Sender: TObject);
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
    procedure cmdOKClick(Sender: TObject);
    procedure btnCurrentClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure lstAllergyClick(Sender: TObject);
    procedure cboSymptomsMouseClick(Sender: TObject);
    procedure cboSymptomsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdPrevCmtsClick(Sender: TObject);
    procedure cmdPrevObsClick(Sender: TObject);
    procedure lstSelectedSymptomsChange(Sender: TObject);
    procedure cboVerifierNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSevHelpClick(Sender: TObject);
    procedure VA508ComponentAccessibility1StateQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2ValueQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2StateQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2ItemInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2ItemQuery(Sender: TObject;
      var Item: TObject);
    procedure VA508ComponentAccessibility2InstructionsQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2ComponentNameQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2CaptionQuery(Sender: TObject;
      var Text: string);
    procedure SymptomDateBoxExit(Sender: TObject);
    procedure SymptomDateBoxDateDialogClosed(Sender: TObject);
    procedure calObservedDateExit(Sender: TObject);
    procedure VA508ComponentAccessibility3StateQuery(Sender: TObject;
      var Text: string);
    procedure memErrCmtsExit(Sender: TObject);
  private
    FLastAllergyID: string;
    FEditAllergyIEN: integer;
    FNKAOrder: boolean;
    FChanged: Boolean;
    FOldHintPause : integer;
    procedure SetDate;
  protected
    procedure EnableDisableControls(EnabledStatus: boolean);
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string);
    function  ValidSave: Boolean;
    procedure SetupDialog;
    procedure SetupVerifyFields(ARec: TAllergyRec);
    procedure SetUpEnteredInErrorFields(ARec: TAllergyRec);
  end;

function EnterEditAllergy(AllergyIEN: integer; AddNew, MarkAsEnteredInError: boolean; AnOwner: TComponent = nil; ARefNum: Integer = -1): boolean;
function MarkEnteredInError(AllergyIEN: integer): boolean;
function EnterNKAForPatient: boolean;

var
  frmARTAllergy: TfrmARTAllergy;
  AllergyList: TStringList;
  OldRec, NewRec: TAllergyRec;
  Defaults: TStringList;
  Changing: Boolean;
  FAbort: Boolean;
  uAddingNew: boolean = FALSE;
  uEditing: Boolean = FALSE;
  uEnteredInError: Boolean = FALSE;
  uUserCanVerify: boolean = FALSE;
  uDeletedSymptoms: TStringList;

implementation

{$R *.DFM}

uses
  rODBase, uCore, rCore, rCover, fCover, fAllgyFind, fPtCWAD, fRptBox, VA508AccessibilityRouter;

const
  TX_NO_ALLERGY       = 'A causative agent must be specified.'    ;
  TX_NO_ALLGYTYPE     = 'An allergy type must be entered for this causative agent.'  ;
  TX_NO_NATURE_OF_REACTION = 'A Nature of Reaction must be entered for this causative agent.'  ;
  TX_NO_SYMPTOMS      = 'Symptoms must be selected for this observed allergy and reaction.';
  TX_NO_OBSERVER      = 'An observer must be selected for this allergy and reaction .';
  TX_NO_ORIGINATOR    = 'An originator must be selected for this allergy and reaction .';
  TX_NO_FUTURE_DATES  = 'Reaction dates in the future are not allowed.';
  TX_BAD_OBS_DATE     = 'Observation date must be in the format m/d/y or m/y or y, or T-d.';
  TX_MISSING_OBS_DATE = 'Observation date is required for observed reactions.';
  TX_MISSING_OBS_HIST = 'You must select either OBSERVED or HISTORICAL for this reaction.';
  TX_MISSING_SEVERITY= 'You must select a Severity.';
  TX_BAD_VER_DATE     = 'Verify date must be in the format m/d/y or m/y or y, or T-d.';
  TX_BAD_ORIG_DATE    = 'Origination date must be in the format m/d/y or m/y or y, or T-d.';
  TX_NO_FUTURE_ORIG_DATES  = 'An origination date in the future is not allowed.';
  TX_MISSING_ORIG_DATE  = 'Origination date is required.';
  TX_CAP_FUTURE       = 'Invalid date';
  TX_NO_SAVE     = 'This item cannot be saved for the following reason(s):' + CRLF + CRLF;
  TX_NO_SAVE_CAP = 'Unable to Save Allergy/Adverse Reaction';
  TX_SAVE_ERR    = 'Unexpected error - it was not possible to save this request.';
  TX_CAP_EDITING = 'Edit Allergy/Adverse Reaction';
  TX_STS_EDITING = 'Loading Allergy/Adverse Reaction for Edit';
  TX_CAP_ERROR   = 'Mark Allergy/Adverse Reaction Entered In Error';
  TX_STS_ERROR   = 'Loading Allergy/Adverse Reaction';
  TX_ORIG_CMTS_REQD = 'Comments are required for ''Observed'' reactions.';
  TX_EDIT_ERROR = 'Unable to load record for editing';
  TC_EDIT_ERROR = 'Error Encountered';
  TX_NKA_SUCCESS = 'Patient''s record has been updated.';
  TC_NKA_SUCCESS = 'No Known Allergies';
  TX_OBHX_HINT =   'OBSERVED: directly observed or occurring while the patient was' + CRLF +
                   'on the suspected causative agent.  Use for new information about' + CRLF +
                   'an allergy/adverse reaction and for recent reactions caused by' + CRLF +
                   'VA-prescribed medications.' + CRLF + CRLF +
                   'HISTORICAL: reported by the patient as occurring in the past;' + CRLF +
                   'no longer requires intervention' ;

 NEW_ALLERGY = True;
 ENTERED_IN_ERROR = True;

function EnterNKAForPatient: boolean;
var
  x: string;
begin
  x := RPCEnterNKAForPatient;
  if not (Piece(x, U, 1) = '0') then
    InfoBox(Piece(x, U, 2), TC_EDIT_ERROR, MB_ICONERROR or MB_OK)
  else
    InfoBox(TX_NKA_SUCCESS, TC_NKA_SUCCESS, MB_ICONINFORMATION or MB_OK);
  Result := (Piece(x, U, 1) = '0');
end;

function MarkEnteredInError(AllergyIEN: integer): boolean;
begin
  Result := EnterEditAllergy(AllergyIEN, not NEW_ALLERGY, ENTERED_IN_ERROR);
end;

function EnterEditAllergy(AllergyIEN: integer; AddNew, MarkAsEnteredInError: boolean; AnOwner: TComponent = nil; ARefNum: Integer = -1): boolean;
var
  Allergy: string;
begin
  Result := False;
  if AnOwner = nil then AnOwner := Application;

  if not LockedForOrdering then Exit;//SMT Lets Lock Allergies
  try
    if frmARTAllergy <> nil then
    begin
      InfoBox('You are already entering/editing an Allergy.', 'Information', MB_OK);
      exit;
    end;
    uAddingNew := AddNew;
    uEditing := (not AddNew) and (not MarkAsEnteredInError);
    uEnteredInError := MarkAsEnteredInError;
    frmARTAllergy := TfrmARTAllergy.Create(AnOwner);
    if ARefNum <> -1 then frmARTAllergy.RefNum := ARefNum;
    if frmARTAllergy.AbortAction then exit;
    with frmARTAllergy do
      try
        ResizeFormToFont(TForm(frmARTAllergy));
        FChanged     := False;
        Changing := True;
        if uEditing then
          begin
            frmARTAllergy.Caption := TX_CAP_EDITING;
            FEditAllergyIEN := AllergyIEN;
            if FEditAllergyIEN = 0 then exit;
            StatusText(TX_STS_EDITING);
            OldRec := LoadAllergyForEdit(FEditAllergyIEN);
            NewRec.IEN := OldRec.IEN;
            SetupDialog;
          end
        else if uEnteredInError then
          begin
            frmARTAllergy.Caption := TX_CAP_ERROR;
            FEditAllergyIEN := AllergyIEN;
            if FEditAllergyIEN = 0 then exit;
            StatusText(TX_STS_ERROR);
            OldRec := LoadAllergyForEdit(FEditAllergyIEN);
            NewRec.IEN := OldRec.IEN;
            SetupDialog;
          end
        else if uAddingNew then
          begin
            SetupVerifyFields(NewRec);
            SetupEnteredInErrorFields(NewRec);
            AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
            if Piece(Allergy, U, 1) = '-1' then
              begin
                ckNoKnownAllergies.Checked := True;
                Result := EnterNKAForPatient;
                frmARTAllergy.Close;
                Exit;
              end
            else if Allergy <> '' then
              begin
                lstAllergy.Clear;
                lstAllergy.Items.Add(Allergy);
                cboAllergyType.SelectByID(Piece(Allergy, U, 4));
              end
            else
              begin
                Result := False;
                Close;
                exit;
              end;
            calOriginated.FMDateTime := FMNow;
            Changing := False;
            ControlChange(lstAllergy);
          end;
        StatusText('');
        if OldRec.IEN = -1 then
        begin
          Result := False;
          Close;
          Exit;
        end;

        origlbl508.Caption := 'Originator. Read Only. Value is ' + cboOriginator.SelText;
        origdtlbl508.Caption := 'Origination Date. Read Only. Value is '+ calOriginated.Text;
        Show;
        Result := FChanged;
      finally
  //      uAddingNew := FALSE;
  //      uEditing := FALSE;
  //      uEnteredInError := FALSE;
  //      uUserCanVerify := FALSE;
        //frmARTAllergy.Release;
      end;
  finally
    UnlockIfAble;
  end;
end;

procedure TfrmARTAllergy.FormCreate(Sender: TObject);
begin
  inherited;       // what to do here?  How to set up dialog defaults without order dialog to supply prompts?
  Changing := True;
  FAbort := True;
  AbortAction := False;
  AllergyList := TStringList.Create;
  uDeletedSymptoms := TStringList.Create;
  FillChar(OldRec, SizeOf(OldRec), 0);
  FillChar(NewRec, SizeOf(NewRec), 0);
  with NewRec do
    begin
      SignsSymptoms  := TStringList.Create ;
      IDBandMarked   := TStringList.Create;
      ChartMarked    := TStringList.Create;
      Observations   := TStringList.Create;
      Comments       := TStringList.Create ;
      NewComments    := TStringList.Create ;
      ErrorComments  := TStringList.Create ;
    end;
  Defaults    := TStringList.Create;
  StatusText('Loading Default Values');
  uUserCanVerify := FALSE;  //HasSecurityKey('GMRA-ALLERGY VERIFY');
  FastAssign(ODForAllergies, Defaults);
  StatusText('Initializing Long List');
  ExtractItems(cboSymptoms.Items, Defaults, 'Top Ten');
  if ScreenReaderSystemActive then cboSymptoms.Items.Add('^----Separator for end of Top Ten signs and symptoms------')
  else cboSymptoms.InsertSeparator;
  cboSymptoms.InitLongList('');
  cboOriginator.InitLongList(User.Name) ;
  cboOriginator.SelectByIEN(User.DUZ);
  pgAllergy.ActivePage := tabGeneral;
  InitDialog;
  Changing := False;
  if AbortAction then
  begin
    Close;
    Exit;
  end;
end;

procedure TfrmARTAllergy.InitDialog;
var
  Allergy: string;
  i: Integer;
  //ErrMsg: string;
begin
  inherited;
  // since this only allows entry of new allergies, key check is irrelevant, eff. v26.12
(*  if not IsARTClinicalUser(ErrMsg) then
  begin
    InfoBox(ErrMsg, 'No Authorization', MB_ICONWARNING or MB_OK);
    AbortAction := True;
    Close;
    Exit;
  end;*)
  Changing := True;
  FOldHintPause := Application.HintHidePause;
  Application.HintHidePause := 15000;
  ExtractItems(cboAllergyType.Items, Defaults, 'Allergy Types');
  ExtractItems(cboSeverity.Items, Defaults, 'Severity');
  ExtractItems(cboNatureOfReaction.Items, Defaults, 'Nature of Reaction');
  lstAllergy.Items.Add('-1^Click button to search ---->');
  grpObsHist.ItemIndex := -1;         // CQ 11775 - v27.10 - RV (was '1')
  calObservedDate.Text := '';
  cboSeverity.ItemIndex := -1;
  cboSeverity.Visible := False;
  lblSeverity.Visible := False;
  btnSevHelp.Visible := False;
  calObservedDate.Visible := False;
  lblObservedDate.Visible := False;
  cboSymptoms.ItemIndex := -1;
  memComments.Clear;
  cmdPrevCmts.Visible := (uEditing and (OldRec.Comments <> nil) and (OldRec.Comments.Text <> ''));
  cmdPrevObs.Visible := (uEditing and (OldRec.Observations <> nil) and (OldRec.Observations.Text <> ''));
  btnAgent.Enabled := (not uEditing) and (not uEnteredInError);
  ckEnteredInError.Enabled := uEditing or uEnteredInError;
  grpObsHist.Enabled := (not uEditing) and (not uEnteredInError);
  grpObsHist.Hint := TX_OBHX_HINT;
  grpObsHist.ShowHint := grpObsHist.Enabled;
  ckIDBand.Enabled := Patient.Inpatient and MarkIDBand;
  ckChartMarked.Checked := ckChartMarked.Checked or uAddingNew;
  ListAllergies(AllergyList);
  for i:=0 to grpObsHist.ControlCount -1 do
  TWinControl(grpObsHist.Controls[i]).TabStop := true;
  with AllergyList do
    if Count > 0 then
      begin
        if (Piece(Strings[0], U, 1) = '') and (Piece(Strings[0], U, 2) <> 'No Known Allergies') then
          begin
            ckNoKnownAllergies.Enabled := True;
            //TDP - CQ#19731 make sure NoAllergylbl508 is not enabled or visible if
            //      ckNoKnownAllergies is enabled
            NoAllergylbl508.Enabled := False;
            NoAllergylbl508.Visible := False;
          end
        else
          begin
            ckNoKnownAllergies.Enabled := False;
            btnCurrent.Enabled := True;
            //TDP - CQ#19731 make sure NoAllergylbl508 is enabled and visible if
            //      ckNoKnownAllergies is disabled
            if ScreenReaderSystemActive then
              begin
                NoAllergylbl508.Enabled := True;
                NoAllergylbl508.Visible := True;
              end;
          end;
      end
    else
      begin
        btnCurrent.Enabled := False;
        ckNoKnownAllergies.Enabled := True;
        //TDP - CQ#19731 make sure NoAllergylbl508 is not enabled or visible if
        //      ckNoKnownAllergies is enabled
        NoAllergylbl508.Enabled := False;
        NoAllergylbl508.Visible := False;
      end;
  if (not uEditing) and (not uEnteredInError) and (not uAddingNew) then
    begin
      SetupVerifyFields(NewRec);
      SetupEnteredInErrorFields(NewRec);
      AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
      if Piece(Allergy, U, 1) = '-1' then
        begin
          ckNoKnownAllergies.Checked := True;
          //Exit;
        end
      else if Allergy <> '' then
        begin
          lstAllergy.Clear;
          lstAllergy.Items.Add(Allergy);
          cboAllergyType.SelectByID(Piece(Allergy, U, 4));
        end
      else
        begin
          AbortAction := True;
          Close;
          exit;
        end;
      calOriginated.FMDateTime := FMNow;
    end;
  StatusText('');
  Changing := False;
  ControlChange(lstAllergy);
  origlbl508.Visible := False;
  origdtlbl508.Visible := False;
  if ScreenReaderSystemActive then
    begin
      origlbl508.Enabled := True;
      origdtlbl508.Enabled := True;
      origlbl508.Visible := True;
      origdtlbl508.Visible := True;
//    cboOriginator.Enabled := True;
//    calOriginated.Enabled := True;
//    calOriginated.ReadOnly := True;
    end;
end;

procedure TfrmARTAllergy.SetDate;
var
  x: string;
begin
  Changing := True;
  with lstSelectedSymptoms do
    begin
      if (Items.Count = 0) or (ItemIndex = -1) or (not SymptomDateBox.IsValid) then exit;

      if SymptomDateBox.FMDateTime > FMNow then
        InfoBox(TX_NO_FUTURE_DATES, TX_CAP_FUTURE, MB_OK)
      else
        begin
          x := Items[ItemIndex];
          x := ORFn.Pieces(x, U, 1, 2) + U + FloatToStr(SymptomDateBox.FMDateTime) + U +
                            FormatFMDateTime('yyyy/mm/dd@hh:nn', SymptomDateBox.FMDateTime);
          Items[ItemIndex] := x;
        end;
    end;
  Changing := False;
  ControlChange(SymptomDateBox);
end;

procedure TfrmARTAllergy.SetupDialog;
begin
  if AbortAction then exit;
  if OldRec.IEN = -1 then
  begin
    InfoBox(TX_EDIT_ERROR, TC_EDIT_ERROR, MB_ICONERROR or MB_OK);
    Exit;
  end;
  if uEditing then with OldRec do
    begin
      Changing := True;
      ckNoKnownAllergies.Checked := NoKnownAllergies;
      btnAgent.Enabled := FALSE;  //not Verified;
      lstAllergy.Items.Clear;
      lstAllergy.Items.Insert(0, U + CausativeAgent);
      lstAllergy.ItemIndex := 0;
      lstAllergySelect(Self);
      cboAllergyType.SelectByID(Piece(AllergyType, U, 1));
      cboNatureOfReaction.SelectByID(Piece(NatureOfReaction, U, 1));
      FastAssign(SignsSymptoms, lstSelectedSymptoms.Items);
      calOriginated.FMDateTime := Originated;
      cboOriginator.InitLongList(OriginatorName);
      cboOriginator.SelectByIEN(Originator);
      { TODO -oRich V. -cART/Allergy : Change to calendar entry fields and prior entries button? }
      ckIDBand.Checked := IDBandMarked.Count > 0;
      ckChartMarked.Checked := ChartMarked.Count > 0;
      if Piece(Observed_Historical, U, 1) <> '' then
        case UpperCase(Piece(Observed_Historical, U, 1))[1] of
          'O': grpObsHist.ItemIndex := 0;
          'H': grpObsHist.ItemIndex := 1;
        end
      else grpObsHist.ItemIndex := -1;
      calObservedDate.FMDateTime := ReactionDate;
      cmdPrevObs.Enabled := (OldRec.Observations.Text <> '');
      cboSeverity.SelectByID(Piece(Severity, U, 1));
      cmdPrevCmts.Enabled := Comments.Text <> '';
      SetupVerifyFields(OldRec);
      SetUpEnteredInErrorFields(OldRec);
      Changing := False;
      ControlChange(Self);
    end
  else if uEnteredInError then with OldRec do
    begin
      Changing := True;
      SetupVerifyFields(OldRec);
      SetUpEnteredInErrorFields(OldRec);
      Changing := False;
    end;

end;

procedure TfrmARTAllergy.VA508ComponentAccessibility1StateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
Text := 'Comments ' + memComments.Text;
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2CaptionQuery(
  Sender: TObject; var Text: string);
begin
  inherited;

 Text := 'Causative Agent';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ComponentNameQuery(
  Sender: TObject; var Text: string);
begin
  inherited;

 Text := 'List Box';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2InstructionsQuery(
  Sender: TObject; var Text: string);
begin
  //inherited;

 Text := 'Read Only';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ItemInstructionsQuery(
  Sender: TObject; var Text: string);
begin
  //inherited;
  Text := ' ';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ItemQuery(Sender: TObject;
  var Item: TObject);
begin
  inherited;
 Text := ' ';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2StateQuery(Sender: TObject;
  var Text: string);
begin
//  inherited;
  Text := ' ';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ValueQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := Piece(lstAllergy.Items[0],U,2);
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility3StateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memErrCmts.Text;
end;

procedure TfrmARTAllergy.Validate(var AnErrMsg: string);
var
  tmpDate: TFMDateTime;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  AnErrMsg := '';
  if tabEnteredInError.TabVisible then exit;
  if not ckNoKnownAllergies.Checked then
    begin
      if lstAllergy.Items.Count = 0 then SetError(TX_NO_ALLERGY)
      else if (Length(lstAllergy.DisplayText[0]) = 0) or
         (Piece(lstAllergy.Items[0], U, 1) = '-1') then SetError(TX_NO_ALLERGY);
      if (grpObsHist.ItemIndex = -1) then
        SetError(TX_MISSING_OBS_HIST);
      if (grpObsHist.ItemIndex = 0) then
        begin
          if (lstSelectedSymptoms.Items.Count = 0)   then SetError(TX_NO_SYMPTOMS);
          if (grpObsHist.Enabled) and RequireOriginatorComments and (not ContainsVisibleChar(memComments.Text))  then
            SetError(TX_ORIG_CMTS_REQD);
          if (grpObsHist.Enabled) and (calObservedDate.Text = '')  then
            SetError(TX_MISSING_OBS_DATE);
          if (cboSeverity.ItemIndex = -1) then
            SetError(TX_MISSING_SEVERITY);
        end;
      if cboAllergyType.ItemID = ''           then SetError(TX_NO_ALLGYTYPE);
      with cboNatureOfReaction do
        if (ItemID = '') or (ItemIndex < 0) or (Text = '')   then
          SetError(TX_NO_NATURE_OF_REACTION)
        else
          NewRec.NatureOfReaction := ItemID + U + Text;
    end;
  if (cboOriginator.ItemIEN = 0) or (cboOriginator.Text = '')  then SetError(TX_NO_ORIGINATOR);
  with NewRec do
  begin
    if calObservedDate.Text <> '' then
      begin
        tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');
        if tmpDate > 0 then
          begin
            if tmpDate > FMNow then  SetError(TX_NO_FUTURE_DATES)
            else ReactionDate := tmpDate;
          end
        else
          begin
            SetError(TX_BAD_OBS_DATE);
            pgAllergy.ActivePage := tabGeneral;
          end;
      end;
    if tabVerify.TabVisible then
      if calVerifyDate.Text <> '' then
        begin
          tmpDate := ValidDateTimeStr(calVerifyDate.Text, 'TS');
          if tmpDate > 0 then VerifiedDateTime := tmpDate
          else
            begin
              SetError(TX_BAD_VER_DATE);
              pgAllergy.ActivePage := tabVerify;
            end;
        end;
    if calOriginated.Text <> '' then
      begin
        tmpDate := ValidDateTimeStr(calOriginated.Text, 'TS');
        if tmpDate > 0 then
          begin
            if tmpDate > FMNow then  SetError(TX_NO_FUTURE_ORIG_DATES)
            else Originated := tmpDate;
          end
        else
          begin
            SetError(TX_BAD_ORIG_DATE);
            pgAllergy.ActivePage := tabGeneral;
          end;
      end
    else
      begin
        SetError(TX_MISSING_ORIG_DATE);
        pgAllergy.ActivePage := tabGeneral;
      end;
  end;
end;

procedure TfrmARTAllergy.calObservedDateExit(Sender: TObject);
var
  x: string;
begin
  inherited;
  calObservedDate.Validate(x);
  calObservedDate.FMDateTime := calObservedDate.FMDateTime;
end;

procedure TfrmARTAllergy.cboOriginatorNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  cboOriginator.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmARTAllergy.cboSymptomsNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  cboSymptoms.ForDataUse(SubSetOfSymptoms(StartFrom, Direction));
end;

procedure TfrmARTAllergy.grpObsHistClick(Sender: TObject);
begin
  inherited;
  Changing := True;
  cboSeverity.ItemIndex := -1; //*SMT
  case grpObsHist.ItemIndex of
    0:  begin
          cboSeverity.Visible := True;
          lblSeverity.Visible := True;
          btnSevHelp.Visible := True;
          calObservedDate.Visible := True;
          lblObservedDate.Visible := True;
          calObservedDate.FMDateTime := FMToday;
        end;
    1:  begin
          cboSeverity.Visible := False;
          lblSeverity.Visible := False;
          btnSevHelp.Visible := False;
          calObservedDate.Visible := False;
          lblObservedDate.Visible := False;
        end;
  end;
  Changing := False;
  ControlChange(Self);
end;

procedure TfrmARTAllergy.ControlChange(Sender: TObject);
var
  MyFMNow: TFMDateTime;
  i: integer;
  SourceGlobalRoot, x: string;
begin
  inherited;
  if Changing then Exit;
  MyFMNow := FMNow;
  with NewRec do
    begin
      if (not uEditing) and (not uEnteredInError) then IEN := 0;
      if ckNoKnownAllergies.Checked then
        begin
          with cboOriginator do if ItemIEN > 0 then
            begin
              Originator := ItemIEN;
              OriginatorName := Text;
            end;
          NoKnownAllergies := True;
        end
      else if tabEnteredInError.TabVisible then
        begin
          EnteredInError := ckEnteredInError.Checked;
          if EnteredInError then
            begin
              DateEnteredInError := MyFMNow;                               {***}
              UserEnteringInError := User.DUZ;
              with memErrCmts do if GetTextLen > 0 then QuickCopy(memErrCmts, ErrorComments);
            end;
        end
      else
        with lstAllergy do if (Items.Count > 0) then
          if (Piece(Items[0], U, 1) <>  '-1') and (Length(DisplayText[0]) > 0) then
            begin
              SourceGlobalRoot := Piece(Piece(Items[0], U, 3), ',', 1) + ',';
              if Pos('PSDRUG', SourceGlobalRoot) > 0 then
                SourceGlobalRoot := Piece(SourceGlobalRoot, '"', 1);
              x := Piece(Items[0], U, 2);
              if ((Pos('GMRD', SourceGlobalRoot) > 0) or (Pos('PSDRUG', SourceGlobalRoot) > 0))
                  and (Pos('<', x) > 0) then
                    x := Copy(x, 1, Length(Piece(x, '<', 1)) - 1);
                    //x := Trim(Piece(x, '<', 1));
              CausativeAgent := x + U + Piece(Items[0], U, 1) + ';' + SourceGlobalRoot;
              with cboAllergyType do
                if ItemID <> '' then
                  AllergyType := ItemID + U + Text;
              with cboNatureOfReaction do
                if ItemID <> '' then
                  NatureOfReaction := ItemID + U + Text;
              with cboOriginator do
                if ItemIEN > 0 then
                  begin
                    Originator := ItemIEN;
                    OriginatorName := Text;
                  end;
              SignsSymptoms.Clear;
              for i := 0 to uDeletedSymptoms.Count - 1 do
                SignsSymptoms.Add(uDeletedSymptoms[i]);
              with lstSelectedSymptoms do
                for i := 0 to Items.Count - 1 do
                  SignsSymptoms.Add(Items[i]);
              if tabVerify.TabVisible then
                begin
                  Verified := ckVerified.Checked;
                  with cboVerifier do
                    if ItemIEN > 0 then
                      begin
                        Verifier := ItemIEN;
                        VerifierName := Text;
                      end;
                end;
              NewRec.ChartMarked.Clear;
              if ckChartMarked.Checked then
                ChartMarked.Add(FloatToStr(MyFMNow));
              NewRec.IDBandMarked.Clear;
              if ckIDBand.Checked then
                IDBandMarked.Add(FloatToStr(MyFMNow));
              with grpObsHist do
                if ItemIndex   > -1 then
                  begin
                    if ItemIndex = 0 then
                      Observed_Historical := 'o^OBSERVED'
                    else
                      Observed_Historical := 'h^HISTORICAL';
                  end;
(*              tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');       {***}
              if tmpDate > 0 then ReactionDate := tmpDate;*)
              with cboSeverity do
                if (ItemID <> '') and (Text <> '') then
                  Severity := ItemID
                else
                begin
                  cboSeverity.ItemIndex := -1;
                  Severity := '';
                end;
              with memComments do
                if GetTextLen > 0 then
                  QuickCopy(memComments, NewComments);
            end;
    end;
end;

procedure TfrmARTAllergy.lstAllergySelect(Sender: TObject);
begin
  inherited;
  with lstAllergy do
    begin
      if Items.Count = 0 then
        Exit
      else if Piece(Items[0], U, 1) = '-1' then
        Exit;
      if Piece(Items[0], U, 1) <> FLastAllergyID then
        FLastAllergyID := Piece(Items[0], U, 1)
      else
        Exit;
      Changing := True;
      //if Sender <> Self then FillChar(NewRec, SizeOf(NewRec), 0);       // Sender=Self when called from SetupDialog
      Changing := False;
    end;
  ControlChange(Self) ;
end;

procedure TfrmARTAllergy.memCommentsExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    QuickCopy(memComments, AStringList);
    LimitStringLength(AStringList, 74);
    QuickCopy(AstringList, memComments);
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmARTAllergy.memErrCmtsExit(Sender: TObject);
var
  AStringList: TStringList;
begin
  inherited;
  AStringList := TStringList.Create;
  try
    QuickCopy(memErrCmts, AStringList);
    LimitStringLength(AStringList, 74);
    QuickCopy(AstringList, memErrCmts);
    ControlChange(Self);
  finally
    AStringList.Free;
  end;
end;

procedure TfrmARTAllergy.SymptomDateBoxDateDialogClosed(Sender: TObject);
begin
  inherited;
  SetDate;
end;

procedure TfrmARTAllergy.SymptomDateBoxExit(Sender: TObject);
begin
  inherited;
  SetDate;
  if TabIsPressed then
    btnRemove.SetFocus()
  else if ShiftTabIsPressed then
    lstSelectedSymptoms.SetFocus();
end;

procedure TfrmARTAllergy.btnAgent1Click(Sender: TObject);
var
  Allergy: string;
begin
  inherited;
  AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
  if Piece(Allergy, U, 1) = '-1' then
    ckNoKnownAllergies.Checked := True
  else if Allergy <> '' then
    begin
      lstAllergy.Clear;
      lstAllergy.Items.Add(Allergy);
      cboAllergyType.SelectByID(Piece(Allergy, U, 4));
    end
  else
    begin
      Close;
      exit;
    end;
  ControlChange(lstAllergy);
end;

procedure TfrmARTAllergy.cboSymptomsClick(Sender: TObject);
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

procedure TfrmARTAllergy.FormDestroy(Sender: TObject);
begin
  OldRec.SignsSymptoms.Free;
  OldRec.IDBandMarked.Free;
  OldRec.ChartMarked.Free;
  OldRec.Observations.Free;
  OldRec.Comments.Free;
  OldRec.NewComments.Free;
  OldRec.ErrorComments.Free;
  NewRec.SignsSymptoms.Free;
  NewRec.IDBandMarked.Free;
  NewRec.ChartMarked.Free;
  NewRec.Observations.Free;
  NewRec.Comments.Free;
  NewRec.NewComments.Free;
  NewRec.ErrorComments.Free;
  Defaults.Free;
  uDeletedSymptoms.Free;
  AllergyList.Free;
  frmARTAllergy := NIL;

  uAddingNew := FALSE;
  uEditing := FALSE;
  uEnteredInError := FALSE;
  uUserCanVerify := FALSE;
  frmCover.UpdateAllergiesList;
  
  inherited;
end;

procedure TfrmARTAllergy.ckNoKnownAllergiesClick(Sender: TObject);
begin
  inherited;
  Changing := True;
  FNKAOrder := ckNoKnownAllergies.Checked;
  EnableDisableControls(not FNKAOrder);
  Changing := False;
  ControlChange(Self);
end;

procedure TfrmARTAllergy.EnableDisableControls(EnabledStatus: boolean);
begin
   //InitDialog;
   with pgAllergy do
     begin
       tabVerify.TabVisible         := FALSE;    //EnabledStatus;    per Dave, leave out for now.
       tabEnteredInError.TabVisible := uEnteredInError;
       tabGeneral.TabVisible        := not uEnteredInError;
     end;
   btnAgent.Enabled                := EnabledStatus;
   cboAllergyType.Enabled          := EnabledStatus;
   cboNatureOfReaction.Enabled     := EnabledStatus;
   lblAllergyType.Enabled          := EnabledStatus;
   lblAgent.Enabled                := EnabledStatus;
   lblSymptoms.Enabled             := EnabledStatus;
   lblSelectedSymptoms.Enabled     := EnabledStatus;
   grpObsHist.Enabled              := EnabledStatus;
   memComments.Enabled             := EnabledStatus;
   lblComments.Enabled             := EnabledStatus;
   lstSelectedSymptoms.Enabled     := EnabledStatus;
   lblObservedDate.Enabled         := EnabledStatus;
   calObservedDate.Enabled         := EnabledStatus;
   lblSeverity.Enabled             := EnabledStatus;
   cboSeverity.Enabled             := EnabledStatus;
   btnSevHelp.Enabled              := EnabledStatus;
   lstAllergy.Enabled              := EnabledStatus;
   cboSymptoms.Enabled             := EnabledStatus;
   SymptomDateBox.Enabled          := EnabledStatus;
end;

procedure TfrmARTAllergy.cmdOKClick(Sender: TObject);
const
  TX_ENTERED_IN_ERROR = 'Mark this entry as ''Entered in Error''?';
  TC_ENTERED_IN_ERROR = 'Are you sure?';
var
  Saved: string;
begin
  if ValidSave then
    begin
      if uEnteredInError then
        if not (InfoBox(TX_ENTERED_IN_ERROR, TC_ENTERED_IN_ERROR, MB_YESNO or MB_ICONQUESTION) = ID_YES) then
          begin
            FChanged := False;
            FAbort := False;
            Close;
            Exit;
          end;
      Saved := SaveAllergy(NewRec);
      FChanged := (Piece(Saved, U, 1) = '0');
      if not FChanged then
        InfoBox(TX_NO_SAVE + Piece(Saved, U, 2), TX_NO_SAVE_CAP, MB_OK)
      else
        begin
          SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
          Application.ProcessMessages;
        end;
      FAbort := False;
      Close;
    end;
end;

function TfrmARTAllergy.ValidSave: Boolean;
var
  ErrMsg: string;
begin
  Result := True;
  Validate(ErrMsg);
  if Length(ErrMsg) > 0 then
  begin
    InfoBox(TX_NO_SAVE + ErrMsg, TX_NO_SAVE_CAP, MB_OK);
    Result := False;
  end;
end;

procedure TfrmARTAllergy.btnCurrentClick(Sender: TObject);
const
  VIEW_CURRENT = 'Current Allergies/Adverse Reactions for ';
begin
  inherited;
  ReportBox(DetailPosting('A'), VIEW_CURRENT + Patient.Name, True)
end;

procedure TfrmARTAllergy.btnRemoveClick(Sender: TObject);
var
  i: integer;
  x: string;
begin
  inherited;
  Changing := True;
  with lstSelectedSymptoms do
    begin
      if (Items.Count = 0) or (ItemIndex = -1) then exit;
      i := ItemIndex;
      if uEditing then
      begin
        if OldRec.SignsSymptoms.IndexOf(Items[ItemIndex]) > -1 then
          begin
            x := Items[i];
            SetPiece(x, U, 5, '@');
            uDeletedSymptoms.Add(x);
          end;
      end;
      Items.Delete(ItemIndex);
      ItemIndex := i - 1;
      if (Items.Count > 0) and (ItemIndex = -1) then ItemIndex := 0;
    end;
  Changing := False;
  ControlChange(btnRemove);
end;

procedure TfrmARTAllergy.lstAllergyClick(Sender: TObject);
begin
  inherited;
  lstAllergy.ItemIndex := -1;
end;

procedure TfrmARTAllergy.cboSymptomsMouseClick(Sender: TObject);
const
  TC_SS_MAX = 'Too many signs/symptoms';
  TX_SS_MAX = 'A maximum of 38 signs/symptoms may be selected.';
var
  x: string;
begin
  inherited;
  with cboSymptoms do if (ItemIndex < 0) or (Text = '') or (ItemID = '') then exit;
  if (lstSelectedSymptoms.SelectByID(cboSymptoms.ItemID) > -1) or
     (lstSelectedSymptoms.Items.IndexOf(cboSymptoms.Text) > -1) then exit;
  if (lstSelectedSymptoms.Count + 1) > 38 then
  begin
    InfoBox(TX_SS_MAX, TC_SS_MAX, MB_ICONERROR or MB_OK);
    exit;
  end;
  Changing := True;
  if cboSymptoms.ItemIndex > -1 then
    begin
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
    end ;
(*  else                             Free-text entries no longer allowed.
    with lstSelectedSymptoms do
      begin
        Items.Add('FT' + U + cboSymptoms.Text);
        ItemIndex := Items.Count - 1;
      end;*)
  Changing := False;
  ControlChange(Self)
end;

procedure TfrmARTAllergy.cboSymptomsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then cboSymptomsMouseClick(Self);
end;

procedure TfrmARTAllergy.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FChanged := False;
  Close;
end;

procedure TfrmARTAllergy.cmdPrevCmtsClick(Sender: TObject);
const
  CMT_CAPTION = 'View previous comments';
begin
  inherited;
  ReportBox(OldRec.Comments, CMT_CAPTION, False);
end;

procedure TfrmARTAllergy.cmdPrevObsClick(Sender: TObject);
const
  OBS_CAPTION = 'View previous observations';
begin
  inherited;
  ReportBox(OldRec.Observations, OBS_CAPTION, False);
end;

procedure TfrmARTAllergy.lstSelectedSymptomsChange(Sender: TObject);
var
  AFMDateTime: TFMDateTime;
begin
  inherited;
  with lstSelectedSymptoms do
    begin
      SymptomDateBox.Enabled := (ItemIndex <> -1);
      btnRemove.Enabled := (ItemIndex <> -1);

      if SymptomDateBox.Enabled then begin
        AFMDateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 3));
        if AFMDateTime > 0 then
          SymptomDateBox.FMDateTime := AFMDateTime
      end;
    end;
end;

procedure TfrmARTAllergy.cboVerifierNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  cboVerifier.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmARTAllergy.SetupVerifyFields(ARec: TAllergyRec);
var
  CanBeVerified: boolean;
begin
  tabVerify.TabVisible := False;     // FOR NOW
  if not tabVerify.TabVisible then exit;
  if not uUserCanVerify then
    begin
      tabVerify.TabVisible := False;
      exit;
    end;
  Changing := True;
  with ARec do
    begin
      ckVerified.Checked := Verified;
      CanBeVerified := (not Verified) and uUserCanVerify;
      if CanBeVerified then
        begin
          cboVerifier.InitLongList(User.Name);
          cboVerifier.SelectByIEN(User.DUZ);
          cboVerifier.Font.Color := clWindowText;
          calVerifyDate.FMDateTime := FMNow;
        end
      else
        begin
          cboVerifier.InitLongList(VerifierName);
          cboVerifier.SelectByIEN(Verifier);
          cboVerifier.Font.Color := clGrayText;
          calVerifyDate.FMDateTime := VerifiedDateTime;
        end;
      cboVerifier.Enabled   := CanBeVerified;
      calVerifyDate.Enabled := CanBeVerified;
      ckVerified.Enabled    := CanBeVerified;
      lblVerifier.Enabled   := CanBeVerified;
      lblVerifyDate.Enabled := CanBeVerified;
    end;
  Changing := False;
  ControlChange(ckVerified);
end;

procedure TfrmARTAllergy.SetUpEnteredInErrorFields(ARec: TAllergyRec);
const
  TC_ERR_CMTS_OPTIONAL = 'Comments (optional)';
  TC_ERR_CMTS_DISABLED = 'Comments (disabled)';
  TX_ENTERED_IN_ERROR1 = 'Clicking ''OK'' will mark ';
  TX_ENTERED_IN_ERROR2 = ' as ''Entered in Error''.';

begin
  tabEnteredInError.TabVisible := uEnteredInError;
  tabGeneral.TabVisible        := not uEnteredInError;
  tabVerify.TabVisible         := FALSE; // not uEnteredInError;
  Changing := True;
  ckEnteredInError.Checked := uEnteredInError;
  if uEnteredInError then
    begin
      lblEnteredInError.Caption := TX_ENTERED_IN_ERROR1 + UpperCase(OldRec.CausativeAgent) + TX_ENTERED_IN_ERROR2;
      if EnableErrorComments then
        begin
          memErrCmts.Enabled := True;
          memErrCmts.Color := clWindow;
          lblErrCmts.Enabled := True;
          lblErrCmts.Caption := TC_ERR_CMTS_OPTIONAL;
          ActiveControl := memErrCmts;
        end
      else
        begin
          memErrCmts.Enabled := False;
          memErrCmts.Color := clBtnFace;
          lblErrCmts.Enabled := False;
          lblErrCmts.Caption := TC_ERR_CMTS_DISABLED;
          ActiveControl := cmdOK;
        end;
    end;
  Changing := False;
  ControlChange(ckEnteredInError);
end;


procedure TfrmARTAllergy.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Release;
  uEditing := False;
  uEnteredInError := False;
  uAddingNew := False;
  Application.HintHidePause := FOldHintPause;
  Action  := caFree;

  UnlockIfAble; //SMT Unlock when allergies close.
end;

procedure TfrmARTAllergy.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if FAbort and frmARTAllergy.Visible then
  begin
    if InfoBox('Are you sure you want to cancel Entering/Editing this allergy?', 'Exiting Allergy Enter/Edit form', MB_YESNO) = ID_NO then
    begin
    CanClose := false;
    exit;
    end;
  end;
  if AbortAction then exit;
end;

procedure TfrmARTAllergy.btnSevHelpClick(Sender: TObject);
const
  TX_SEV_DEFINITION = 'MILD - Requires minimal therapeutic intervention '+#13+#10+
                     'such as discontinuation of drug(s)'+#13+#10+''+#13+#10+
                     'MODERATE - Requires active treatment of adverse reaction, '+#13+#10+
                     'or further testing or evaluation to assess extent of non-serious'+#13+#10+
                     'outcome (see SEVERE for definition of serious).'+#13+#10+''+#13+#10+
                     'SEVERE - Includes any serious outcome, resulting in life- or'+#13+#10+
                     'organ-threatening situation or death, significant or permanent'+#13+#10+
                     'disability, requiring intervention to prevent permanent impairment '+#13+#10+
                     'or damage, or requiring/prolonging hospitalization.';
  TC_SEV_CAPTION   = 'Severity Levels';
begin
  inherited;
  InfoBox(TX_SEV_DEFINITION, TC_SEV_CAPTION, MB_ICONINFORMATION or MB_OK);
end;

end.
