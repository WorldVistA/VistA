unit fAllgyAR;

{ ------------------------------------------------------------------------------
  Update History

  2016-??-??: NSR#20070203
  2016-??-??: NSR#20080226
  2016-09-20: NSR#20101203 (Critical/Hight Order Check Display)
  ------------------------------------------------------------------------------- }
interface

uses
  ORExtensions,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ORCtrls, ORfn, ExtCtrls, ComCtrls, uConst,
  Menus, ORDtTm, Buttons, fODBase, fAutoSz, fOMAction, rODAllergy, uOrders,
  VA508AccessibilityManager;       //

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
    memComments: ORExtensions.TRichEdit;
    cmdPrevCmts: TButton;
    tabEnteredInError: TTabSheet;
    ckEnteredInError: TCheckBox;
    memErrCmts: ORExtensions.TRichEdit;
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
    pnlBottom: TPanel;
    pnlButtons: TPanel;
    pnlSeverity: TPanel;
    pnlOriginationDate: TPanel;
    pnlAgentButtons: TPanel;
    pnlActiveAllergies: TPanel;
    Panel2: TPanel;
    Panel7: TPanel;
    pnlVerify: TPanel;
    gpMain: TGridPanel;
    pnlOriginator: TPanel;
    Label1: TLabel;
    procedure btnAgent1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure FormActivate(Sender: TObject);
    procedure grpObsHistEnter(Sender: TObject);
  private
    OldRec, // AA: moved from the unit level to form
    NewRec: TAllergyRec; // AA: moved from the unit level to form
    uAddingNew: Boolean; // AA: moved from the unit level to form
    uEditing: Boolean; // AA: moved from the unit level to form
    uEnteredInError: Boolean; // AA: moved from the unit level to form
    uUserCanVerify: Boolean; // AA: moved from the unit level to form
    Changing: Boolean; // AA: flag to bypass ControlChange execution
    FAbort: Boolean; // AA: if set to TRUE close confirmation message is shown

    FLastAllergyID: string;
    FEditAllergyIEN: Integer;
    FNKAOrder: Boolean;
    FChanged: Boolean;
    FOldHintPause: Integer;
    fOnAfterSave: TNotifyEvent;
    uDeletedSymptoms: TStringList;
    FSendMessageUMNewOrderOnOK: boolean;
    procedure SetDate;
    procedure CheckAllergyScan;
    function SelectAllergyAgent: String;
  protected
    constructor NewfrmARTAllergy(aNew, anError: Boolean; anOwner: TComponent);
    procedure EnableDisableControls(EnabledStatus: Boolean);
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string);
    function ValidSave: Boolean;
    procedure SetupDialog;
    procedure SetupVerifyFields(ARec: TAllergyRec);
    procedure SetUpEnteredInErrorFields(ARec: TAllergyRec);
  public
    property OnAfterSave: TNotifyEvent read FOnAfterSave write FOnAfterSave;
    property SendMessageUMNewOrderOnOK: boolean read FSendMessageUMNewOrderOnOK
      write FSendMessageUMNewOrderOnOK;
  end;

function EnterEditAllergy(AllergyIEN: Integer;
  AddNew, MarkAsEnteredInError: Boolean; AnOwner: TComponent = nil;
  ARefNum: Integer = -1; aModal: Boolean = False;
  aOnAfterSave: TNotifyEvent = nil;
  ASendMessageUMNewOrderOnOK: Boolean = True): Boolean;
function MarkEnteredInError(AllergyIEN: Integer): Boolean;
function EnterNKAForPatient: Boolean;

var
  frmARTAllergy: TfrmARTAllergy;
  uAllergyOrdersCurrentlyBeingDiscontinued: TStringList = nil;

implementation

{$R *.DFM}

uses
  rODBase, uCore, rCore, rCover, iCoverSheetIntf, ORNet, fAllgyFind, fPtCWAD,
  fRptBox, VA508AccessibilityRouter, fNewAllergyCheck, uORLists,
  VAUtils, rOrders, ORClasses, UResponsiveGUI, uWriteAccess;

const
  TX_NO_ALLERGY = 'A causative agent must be specified.';
  TX_NO_ALLGYTYPE = 'An allergy type must be entered for this causative agent.';
  TX_NO_NATURE_OF_REACTION =
    'A Nature of Reaction must be entered for this causative agent.';
  TX_NO_SYMPTOMS =
    'Symptoms must be selected for this observed allergy and reaction.';
  TX_NO_OBSERVER =
    'An observer must be selected for this allergy and reaction .';
  TX_NO_ORIGINATOR =
    'An originator must be selected for this allergy and reaction .';
  TX_NO_FUTURE_DATES = 'Reaction dates in the future are not allowed.';
  TX_NO_DATE_CHANGED = CRLF + CRLF + 'Date reset.';
  TX_BAD_OBS_DATE =
    'Observation date must be in the format m/d/y or m/y or y, or T-d.';
  TX_MISSING_OBS_DATE = 'Observation date is required for observed reactions.';
  TX_MISSING_OBS_HIST =
    'You must select either OBSERVED or HISTORICAL for this reaction.';
  TX_MISSING_SEVERITY = 'You must select a Severity.';
  TX_BAD_VER_DATE =
    'Verify date must be in the format m/d/y or m/y or y, or T-d.';
  TX_BAD_ORIG_DATE =
    'Origination date must be in the format m/d/y or m/y or y, or T-d.';
  TX_NO_FUTURE_ORIG_DATES = 'An origination date in the future is not allowed.';
  TX_MISSING_ORIG_DATE = 'Origination date is required.';
  TX_CAP_FUTURE = 'Invalid date';
  TX_NO_SAVE = 'This item cannot be saved for the following reason(s):' +
    CRLF + CRLF;
  TX_NO_SAVE_CAP = 'Unable to Save Allergy/Adverse Reaction';
  TX_SAVE_ERR = 'Unexpected error - it was not possible to save this request.';
  TX_CAP_EDITING = 'Edit Allergy/Adverse Reaction';
  TX_STS_EDITING = 'Loading Allergy/Adverse Reaction for Edit';
  TX_CAP_ERROR = 'Mark Allergy/Adverse Reaction Entered In Error';
  TX_STS_ERROR = 'Loading Allergy/Adverse Reaction';
  TX_ORIG_CMTS_REQD = 'Comments are required for ''Observed'' reactions.';
  TX_EDIT_ERROR = 'Unable to load record for editing';
  TC_EDIT_ERROR = 'Error Encountered';
  TX_NKA_SUCCESS = 'Patient''s record has been updated.';
  TC_NKA_SUCCESS = 'No Known Allergies';
  TX_OBHX_HINT =
    'OBSERVED: directly observed or occurring while the patient was' + CRLF +
    'on the suspected causative agent.  Use for new information about' + CRLF +
    'an allergy/adverse reaction and for recent reactions caused by' + CRLF +
    'VA-prescribed medications.' + CRLF + CRLF +
    'HISTORICAL: reported by the patient as occurring in the past;' + CRLF +
    'no longer requires intervention';

  NEW_ALLERGY = True;
  ENTERED_IN_ERROR = True;

  // var
  // AllergyList: TStringList;  AA: made local variable of InitDialog
  // Defaults: TStringList;     AA: made local variable of InitDialog

  { AA: the next variables were redefined as the form private fields
    OldRec, NewRec: TAllergyRec;
    Changing: Boolean; // AA: flag to bypass ControlChange execution
    FAbort: Boolean; // AA: if set to TRUE close confirmation message is shown

    uAddingNew: Boolean = False;
    uEditing: Boolean = False;
    uEnteredInError: Boolean = False;
    uUserCanVerify: Boolean = False;

    uDeletedSymptoms: TStringList; AA: moved to the form private section
  }
function EnterNKAForPatient: Boolean;
var
  x: string;
begin
  Result := False;
  if not WriteAccess(waAllergies, True) then
    exit;
  uAllergiesChanged := True;
  x := RPCEnterNKAForPatient;
  if not(Piece(x, U, 1) = '0') then
    InfoBox(Piece(x, U, 2), TC_EDIT_ERROR, MB_ICONERROR or MB_OK)
  else
    InfoBox(TX_NKA_SUCCESS, TC_NKA_SUCCESS, MB_ICONINFORMATION or MB_OK);
  Result := (Piece(x, U, 1) = '0');
end;

function MarkEnteredInError(AllergyIEN: Integer): Boolean;
begin
  Result := EnterEditAllergy(AllergyIEN, not NEW_ALLERGY, ENTERED_IN_ERROR);
end;

procedure TfrmARTAllergy.calObservedDateExit(Sender: TObject);
var
  tmpDate: TFMDateTime;

begin
  inherited;

  if ActiveControl = cmdCancel then
    exit;

  with NewRec do                                                                // NJC 022217
  begin                                                                         // NJC 030217
     if (ShiftTabIsPressed) and (grpObsHist.ItemIndex = 0) and                  // NJC 030217
      (calObservedDate.Text = '') then                                          // NJC 030217
    else                                                                        // NJC 030217
    begin                                                                       // NJC 030317
      tmpDate := 0;                                                             // NJC 030217
      if (grpObsHist.ItemIndex = 0) and (Length(calObservedDate.Text) > 0) then // NJC 030217
        tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TSX')                // NJC 030317
      else                                                                      // NJC 030217
      if (grpObsHist.ItemIndex = 1) and (calObservedDate.Text <> '') then       // NJC 030217
        tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');                // NJC 030217
      if tmpDate > 0 then                                                       // NJC 030217
        ReactionDate := tmpDate                                                 // NJC 030217
      else                                                                      // NJC 030217
      if (grpObsHist.ItemIndex <> 1) or (tmpDate = -1) then                     // NJC 030217
      begin                                                                     // NJC 030217
        InfoBox('Invalid Date/Time','Information', MB_OK);                      // NJC 030217
        calObservedDate.SetFocus;                                               // NJC 030217
      end;
    end;
  end;
end;

function EnterEditAllergy(AllergyIEN: Integer;
  AddNew, MarkAsEnteredInError: Boolean; anOwner: TComponent = nil;
  ARefNum: Integer = -1; aModal: Boolean = False;
  aOnAfterSave: TNotifyEvent = nil;
  ASendMessageUMNewOrderOnOK: Boolean = True): Boolean;
var
  Allergy: string;
begin
  Result := False;
  if not WriteAccess(waAllergies, True) then
    exit;
  if anOwner = nil then
    anOwner := Application;

  if not LockedForOrdering then
    Exit; // SMT Lets Lock Allergies
  if frmARTAllergy <> nil then
    begin
      InfoBox('You are already entering/editing an Allergy.', 'Information', MB_OK);
      Exit;
    end;

  try
    frmARTAllergy := TfrmARTAllergy.NewfrmARTAllergy(AddNew,
      MarkAsEnteredInError, anOwner);
    frmARTAllergy.SendMessageUMNewOrderOnOK := ASendMessageUMNewOrderOnOK;
    if ARefNum <> -1 then
      frmARTAllergy.RefNum := ARefNum;
    if frmARTAllergy.AbortAction then
      Exit;
    with frmARTAllergy do
      try
        ResizeFormToFont(TForm(frmARTAllergy));
        ChangeAllFonts(frmARTAllergy, MainFontSize);
        FChanged := False;
        Changing := True;
        if uEditing then
          begin
            frmARTAllergy.Caption := TX_CAP_EDITING;
            FEditAllergyIEN := AllergyIEN;
            if FEditAllergyIEN = 0 then
              Exit;
            StatusText(TX_STS_EDITING);
            OldRec := LoadAllergyForEdit(FEditAllergyIEN);
            NewRec.IEN := OldRec.IEN;
            SetupDialog;
          end
        else if uEnteredInError then
          begin
            frmARTAllergy.Caption := TX_CAP_ERROR;
            FEditAllergyIEN := AllergyIEN;
            if FEditAllergyIEN = 0 then
              Exit;
            StatusText(TX_STS_ERROR);
            OldRec := LoadAllergyForEdit(FEditAllergyIEN);
            NewRec.IEN := OldRec.IEN;
            SetupDialog;
          end
        else if uAddingNew then
          begin
            SetupVerifyFields(NewRec); // AA: dummy call
            SetUpEnteredInErrorFields(NewRec);
            AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
            if Piece(Allergy, U, 1) = '-1' then
              begin
                ckNoKnownAllergies.Checked := True;
                Result := EnterNKAForPatient;
                frmARTAllergy.Close;
                if assigned(aOnAfterSave) then
                  aOnAfterSave(nil);
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
                FChanged := False;
                Close;
                Exit;
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
        origdtlbl508.Caption := 'Origination Date. Read Only. Value is ' + calOriginated.Text;

        fOnAfterSave := aOnAfterSave;

        if aModal then
          begin
            BorderIcons := [biSystemMenu];
            ShowModal;
          end
        else
          begin
            BorderIcons := [biSystemMenu, biMinimize, biMaximize];
            Show;
          end;

        Result := FChanged;
      finally
        // uAddingNew := FALSE;
        // uEditing := FALSE;
        // uEnteredInError := FALSE;
        // uUserCanVerify := FALSE;
      end;
  finally
    UnlockIfAble;
  end;
end;

constructor TfrmARTAllergy.NewfrmARTAllergy(aNew, anError: Boolean;
  anOwner: TComponent);
begin
  uAddingNew := aNew;
  uEditing := (not aNew) and (not anError);
  uEnteredInError := anError;

  fOnAfterSave := nil;
  if AnOwner = nil then
    AnOwner := Application;
  inherited Create(anOwner);
end;

procedure TfrmARTAllergy.FormCreate(Sender: TObject);
begin
  inherited;
  // what to do here?  How to set up dialog defaults without order dialog to supply prompts?

  Changing := True;
  try
  (* AA: moving intialization code in InitDialog ---------------------------------
    safe as the method is protected and there are no descendants of the class

    FAbort := True;
    AbortAction := False;
    //  AllergyList := TStringList.Create;
    uDeletedSymptoms := TStringList.Create;
    FillChar(OldRec, SizeOf(OldRec), 0);
    FillChar(NewRec, SizeOf(NewRec), 0);
    with NewRec do
    begin
    SignsSymptoms := TStringList.Create;
    IDBandMarked := TStringList.Create;
    ChartMarked := TStringList.Create;
    Observations := TStringList.Create;
    Comments := TStringList.Create;
    NewComments := TStringList.Create;
    ErrorComments := TStringList.Create;
    end;
    Defaults := TStringList.Create;
    StatusText('Loading Default Values');
    uUserCanVerify := False; // HasSecurityKey('GMRA-ALLERGY VERIFY');
    FastAssign(ODForAllergies, Defaults);
    StatusText('Initializing Long List');
    ExtractItems(cboSymptoms.Items, Defaults, 'Top Ten');
    if ScreenReaderSystemActive then
    cboSymptoms.Items.Add
    ('^----Separator for end of Top Ten signs and symptoms------')
    else
    cboSymptoms.InsertSeparator;
    cboSymptoms.InitLongList('');
    cboOriginator.InitLongList(User.Name);
    cboOriginator.SelectByIEN(User.DUZ);
    pgAllergy.ActivePage := tabGeneral;
    ------------------------------------------------------------------------------ *)
    InitDialog;
  finally
    Changing := False;
  end;
  if AbortAction then
  begin
    Close;
    Exit;
  end;
end;

procedure TfrmARTAllergy.InitDialog;
var
  Defaults: TStringList;
  AllergyList: TStringList;
  Allergy: string;
  i: Integer;
begin
  FSendMessageUMNewOrderOnOK := True;
  AutoSizeDisabled := True;
  // code below was moved from FormCreate  method.
  FAbort := True;
  AbortAction := False;
  AllergyList := TStringList.Create;
  uDeletedSymptoms := TStringList.Create;
  FillChar(OldRec, SizeOf(OldRec), 0);
  FillChar(NewRec, SizeOf(NewRec), 0);
  with NewRec do
  begin
    SignsSymptoms := TStringList.Create;
    IDBandMarked := TStringList.Create;
    ChartMarked := TStringList.Create;
    Observations := TStringList.Create;
    Comments := TStringList.Create;
    NewComments := TStringList.Create;
    ErrorComments := TStringList.Create;
  end;
  Defaults := TStringList.Create;
  StatusText('Loading Default Values');
  uUserCanVerify := False; // HasSecurityKey('GMRA-ALLERGY VERIFY');
  setAllergiesDefaults(Defaults);
  StatusText('Initializing Long List');
  ExtractItems(cboSymptoms.Items, Defaults, 'Top Ten');
  if ScreenReaderSystemActive then
    cboSymptoms.Items.Add
      ('^----Separator for end of Top Ten signs and symptoms------')
  else
    cboSymptoms.InsertSeparator;
  cboSymptoms.InitLongList('');
  cboOriginator.Items.Clear;
  cboOriginator.Items.Add(IntToStr(User.DUZ) + U + MixedCase(UpperCase(User.Name)));
  cboOriginator.SelectByIEN(User.DUZ);
  pgAllergy.ActivePage := tabGeneral;

  // code above was moved from FormCreate  method.
  // kept priot to "inherited" to keep sequesnce of execution

  inherited;

  // since this only allows entry of new allergies, key check is irrelevant, eff. v26.12
  (* if not IsARTClinicalUser(ErrMsg) then
    begin
    InfoBox(ErrMsg, 'No Authorization', MB_ICONWARNING or MB_OK);
    AbortAction := True;
    Close;
    Exit;
    end; *)
  Changing := True;
  FOldHintPause := Application.HintHidePause;
  Application.HintHidePause := 15000;
  ExtractItems(cboAllergyType.Items, Defaults, 'Allergy Types');
  ExtractItems(cboSeverity.Items, Defaults, 'Severity');
  ExtractItems(cboNatureOfReaction.Items, Defaults, 'Nature of Reaction');
  Defaults.Free;

  lstAllergy.Items.Add('-1^Click button to search ---->');
  grpObsHist.ItemIndex := -1; // CQ 11775 - v27.10 - RV (was '1')
  calObservedDate.Text := '';
  cboSeverity.ItemIndex := -1;
  // AA 20160919 -- no need to hide as the fielda are required
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
  cboSeverity.Enabled := False;
  lblSeverity.Enabled := False;
  btnSevHelp.Enabled := False;
  calObservedDate.Enabled := False;
  lblObservedDate.Enabled := False;

  cboSymptoms.ItemIndex := -1;
  memComments.Clear;
  cmdPrevCmts.Visible := (uEditing and (OldRec.Comments <> nil) and
    (OldRec.Comments.Text <> ''));
  cmdPrevObs.Visible := (uEditing and (OldRec.Observations <> nil) and
    (OldRec.Observations.Text <> ''));
  btnAgent.Enabled := (not uEditing) and (not uEnteredInError);
  ckEnteredInError.Enabled := uEditing or uEnteredInError;
  grpObsHist.Enabled := (not uEditing) and (not uEnteredInError);
  grpObsHist.Hint := TX_OBHX_HINT;
  grpObsHist.ShowHint := grpObsHist.Enabled;
  ckIDBand.Enabled := Patient.Inpatient and MarkIDBand;
  ckChartMarked.Checked := ckChartMarked.Checked or uAddingNew;
  for i := 0 to grpObsHist.ControlCount - 1 do
    TWinControl(grpObsHist.Controls[i]).TabStop := True;

  ListAllergies(AllergyList);
  with AllergyList do
    if Count > 0 then
    begin
      if (Piece(Strings[0], U, 1) = '') and
        (Piece(Strings[0], U, 2) <> 'No Known Allergies') then
      begin
        ckNoKnownAllergies.Enabled := True;
        // TDP - CQ#19731 make sure NoAllergylbl508 is not enabled or visible if
        // ckNoKnownAllergies is enabled
        NoAllergylbl508.Enabled := False;
        NoAllergylbl508.Visible := False;
      end
      else
      begin
        ckNoKnownAllergies.Enabled := False;
        btnCurrent.Enabled := True;
        // TDP - CQ#19731 make sure NoAllergylbl508 is enabled and visible if
        // ckNoKnownAllergies is disabled
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
      // TDP - CQ#19731 make sure NoAllergylbl508 is not enabled or visible if
      // ckNoKnownAllergies is enabled
      NoAllergylbl508.Enabled := False;
      NoAllergylbl508.Visible := False;
    end;
  AllergyList.Free;

  if (not uEditing) and (not uEnteredInError) and (not uAddingNew) then
  begin
    SetupVerifyFields(NewRec); // AA: dummy call
    SetUpEnteredInErrorFields(NewRec);
    AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
    if Piece(Allergy, U, 1) = '-1' then
    begin
      ckNoKnownAllergies.Checked := True;
      // Exit;
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
      Exit;
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
    // cboOriginator.Enabled := True;
    // calOriginated.Enabled := True;
    // calOriginated.ReadOnly := True;
  end;
end;

procedure TfrmARTAllergy.SetDate;
var
  x: string;
begin
  Changing := True;
  with lstSelectedSymptoms do
  begin
    if (Items.Count = 0) or (ItemIndex = -1) or (not SymptomDateBox.IsValid)
    then
      Exit;

    if SymptomDateBox.FMDateTime > FMNow then
    begin
      SymptomDateBox.Text := 'NOW';
      InfoBox(TX_NO_FUTURE_DATES + TX_NO_DATE_CHANGED, TX_CAP_FUTURE, MB_OK);
    end
    else
    begin
      x := Items[ItemIndex];
      x := ORfn.Pieces(x, U, 1, 2) + U + FloatToStr(SymptomDateBox.FMDateTime) +
        U + FormatFMDateTime('mmm dd,yyyy@hh:nn', SymptomDateBox.FMDateTime);
      Items[ItemIndex] := x;
    end;
  end;
  Changing := False;
  ControlChange(SymptomDateBox);
end;

procedure TfrmARTAllergy.SetupDialog;
begin
  if AbortAction then
    Exit;
  if OldRec.IEN = -1 then
  begin
    InfoBox(TX_EDIT_ERROR, TC_EDIT_ERROR, MB_ICONERROR or MB_OK);
    Exit;
  end;
  if uEditing then
    with OldRec do
    begin
      Changing := True;
      ckNoKnownAllergies.Checked := NoKnownAllergies;
      btnAgent.Enabled := False; // not Verified;
      lstAllergy.Items.Clear;
      lstAllergy.Items.Insert(0, U + CausativeAgent);
      lstAllergy.ItemIndex := 0;
      lstAllergySelect(Self);
      cboAllergyType.SelectByID(Piece(AllergyType, U, 1));
      cboNatureOfReaction.SelectByID(Piece(NatureOfReaction, U, 1));
      FastAssign(SignsSymptoms, lstSelectedSymptoms.Items);
      calOriginated.FMDateTime := Originated;

      cboOriginator.Items.Clear;
      cboOriginator.Items.Add(IntToStr(Originator) + U + MixedCase(UpperCase(OriginatorName)));
      cboOriginator.SelectByIEN(Originator);

      { TODO -oRich V. -cART/Allergy : Change to calendar entry fields and prior entries button? }
      ckIDBand.Checked := IDBandMarked.Count > 0;
      ckChartMarked.Checked := ChartMarked.Count > 0;
      if Piece(Observed_Historical, U, 1) <> '' then
        case UpperCase(Piece(Observed_Historical, U, 1))[1] of
          'O':
            grpObsHist.ItemIndex := 0;
          'H':
            grpObsHist.ItemIndex := 1;
        end
      else
        grpObsHist.ItemIndex := -1;
      calObservedDate.FMDateTime := ReactionDate;
      cmdPrevObs.Enabled := (OldRec.Observations.Text <> '');
      cboSeverity.SelectByID(Piece(Severity, U, 1));
      cmdPrevCmts.Enabled := Comments.Text <> '';
      SetupVerifyFields(OldRec); // AA: dummy call
      SetUpEnteredInErrorFields(OldRec);
      Changing := False;
      ControlChange(Self);
    end
  else if uEnteredInError then
    with OldRec do
    begin
      Changing := True;
      SetupVerifyFields(OldRec); // AA: dummy call
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

procedure TfrmARTAllergy.VA508ComponentAccessibility2CaptionQuery
  (Sender: TObject; var Text: string);
begin
  inherited;

  Text := 'Causative Agent';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ComponentNameQuery
  (Sender: TObject; var Text: string);
begin
  inherited;

  Text := 'List Box';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2InstructionsQuery
  (Sender: TObject; var Text: string);
begin
  // inherited;

  Text := 'Read Only';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ItemInstructionsQuery
  (Sender: TObject; var Text: string);
begin
  // inherited;
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
  // inherited;
  Text := ' ';
end;

procedure TfrmARTAllergy.VA508ComponentAccessibility2ValueQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if lstAllergy.Items.Count > 0 then
    Text := Piece(lstAllergy.Items[0], U, 2);
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
    if Length(AnErrMsg) > 0 then
      AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  AnErrMsg := '';
  if tabEnteredInError.TabVisible then
    Exit;
  if not ckNoKnownAllergies.Checked then
  begin
    if lstAllergy.Items.Count = 0 then
      SetError(TX_NO_ALLERGY)
    else if (Length(lstAllergy.DisplayText[0]) = 0) or
      (Piece(lstAllergy.Items[0], U, 1) = '-1') then
      SetError(TX_NO_ALLERGY);
    if (grpObsHist.ItemIndex = -1) then
      SetError(TX_MISSING_OBS_HIST);
    if (grpObsHist.ItemIndex = 0) then
    begin
      if (lstSelectedSymptoms.Items.Count = 0) then
        SetError(TX_NO_SYMPTOMS);
      if (grpObsHist.Enabled) and RequireOriginatorComments and
        (not ContainsVisibleChar(memComments.Text)) then
        SetError(TX_ORIG_CMTS_REQD);
      if (grpObsHist.Enabled) and (calObservedDate.Text = '') then
        SetError(TX_MISSING_OBS_DATE);
      if (cboSeverity.ItemIndex = -1) then
        SetError(TX_MISSING_SEVERITY);
    end;
    if cboAllergyType.ItemID = '' then
      SetError(TX_NO_ALLGYTYPE);
    with cboNatureOfReaction do
      if (ItemID = '') or (ItemIndex < 0) or (Text = '') then
        SetError(TX_NO_NATURE_OF_REACTION)
      else
        NewRec.NatureOfReaction := ItemID + U + Text;
  end;
  if (cboOriginator.ItemIEN = 0) or (cboOriginator.Text = '') then
    SetError(TX_NO_ORIGINATOR);
  with NewRec do
  begin
    if calObservedDate.Text <> '' then
    begin
      tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');
      if tmpDate > 0 then
      begin
        if tmpDate > FMNow then
          SetError(TX_NO_FUTURE_DATES)
        else
          ReactionDate := tmpDate;
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
        if tmpDate > 0 then
          VerifiedDateTime := tmpDate
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
        if tmpDate > FMNow then
          SetError(TX_NO_FUTURE_ORIG_DATES)
        else
          Originated := tmpDate;
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

//procedure TfrmARTAllergy.calObservedDateExit(Sender: TObject);
//var
//  x: string;
//begin
//  inherited;
//  calObservedDate.Validate(x);
//  calObservedDate.FMDateTime := calObservedDate.FMDateTime;
//end;

procedure TfrmARTAllergy.cboSymptomsNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  inherited;
  sl := TStringList.Create;
  try
    if setSubSetOfSymptoms(StartFrom, Direction,sl) > 0 then
      cboSymptoms.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmARTAllergy.grpObsHistClick(Sender: TObject);
begin
  inherited;
  Changing := True;
  cboSeverity.Visible := True;
  lblSeverity.Visible := True;
  btnSevHelp.Visible := True;
  cboSeverity.Enabled := true;
  cboSeverity.ItemIndex := -1; // *SMT
  // case grpObsHist.ItemIndex of                    // N.Costanzo 06/19/15 NSR (20120404)
  // 0:  begin                                     // N.Costanzo 06/19/15 NSR (20120404)
  cboSeverity.Enabled := True;
  lblSeverity.Enabled := True;
  btnSevHelp.Enabled := True;
  calObservedDate.Visible := True;
  lblObservedDate.Visible := True;
  calObservedDate.Enabled := True;
  lblObservedDate.Enabled := True;
  if grpObsHist.ItemIndex = 1 then
    calObservedDate.Clear
  else
  calObservedDate.FMDateTime := FMToday;
  // end;                                    // N.Costanzo 06/19/15 NSR (20120404)
  // 1:  begin                               // N.Costanzo 06/19/15 NSR (20120404)
  // cboSeverity.Visible := False;           // N.Costanzo 06/19/15 NSR (20120404)
  // lblSeverity.Visible := False;           // N.Costanzo 06/19/15 NSR (20120404)
  // btnSevHelp.Visible := False;            // N.Costanzo 06/19/15 NSR (20120404)
  // calObservedDate.Visible := False;       // N.Costanzo 06/19/15 NSR (20120404)
  // lblObservedDate.Visible := False;       // N.Costanzo 06/19/15 NSR (20120404)
  // end;                                    // N.Costanzo 06/19/15 NSR (20120404)
  // end;                                    // N.Costanzo 06/19/15 NSR (20120404)
  Changing := False;
  ControlChange(Self);
end;

procedure TfrmARTAllergy.grpObsHistEnter(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
  begin
    if grpObsHist.ItemIndex <> 1 then
      grpObsHist.Buttons[0].SetFocus
    else
      grpObsHist.Buttons[1].SetFocus;
  end;
  if ShiftTabIsPressed and (grpObsHist.Focused = true) then cboNatureOfReaction.SetFocus;

end;

procedure TfrmARTAllergy.ControlChange(Sender: TObject);
var
  MyFMNow,tmpDate: TFMDateTime;
  i: Integer;
  SourceGlobalRoot, x: string;
begin
  inherited;
  if Changing then
    Exit;

  MyFMNow := FMNow;
  with NewRec do
  begin
    if (not uEditing) and (not uEnteredInError) then
      IEN := 0;
    if ckNoKnownAllergies.Checked then
    begin
      with cboOriginator do
        if ItemIEN > 0 then
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
        DateEnteredInError := MyFMNow; { *** }
        UserEnteringInError := User.DUZ;
        with memErrCmts do
          if GetTextLen > 0 then
            QuickCopy(memErrCmts, ErrorComments);
      end;
    end
    else
      with lstAllergy do
        if (Items.Count > 0) then
          if (Piece(Items[0], U, 1) <> '-1') and (Length(DisplayText[0]) > 0)
          then
          begin
            SourceGlobalRoot := Piece(Piece(Items[0], U, 3), ',', 1) + ',';
            if Pos('PSDRUG', SourceGlobalRoot) > 0 then
              SourceGlobalRoot := Piece(SourceGlobalRoot, '"', 1);
            x := Piece(Items[0], U, 2);
            if ((Pos('GMRD', SourceGlobalRoot) > 0) or
              (Pos('PSDRUG', SourceGlobalRoot) > 0)) and (Pos('<', x) > 0) then
              x := Copy(x, 1, Length(Piece(x, '<', 1)) - 1);
            // x := Trim(Piece(x, '<', 1));
            CausativeAgent := x + U + Piece(Items[0], U, 1) + ';' +
              SourceGlobalRoot;
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
              if ItemIndex > -1 then
              begin
                if ItemIndex = 0 then
                  Observed_Historical := 'o^OBSERVED'
                else
                  Observed_Historical := 'h^HISTORICAL';
              end;
              tmpDate := ValidDateTimeStr(calObservedDate.Text, 'TS');       {*** njc}
              if tmpDate > 0 then ReactionDate := tmpDate;
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
    // if Sender <> Self then FillChar(NewRec, SizeOf(NewRec), 0);       // Sender=Self when called from SetupDialog
    Changing := False;
  end;
  ControlChange(Self);
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
    QuickCopy(AStringList, memComments);
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
    QuickCopy(AStringList, memErrCmts);
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

function TfrmARTAllergy.SelectAllergyAgent: String;
var
  Allergy: string;
begin
  AllergyLookup(Allergy, ckNoKnownAllergies.Enabled);
  if Piece(Allergy, U, 1) = '-1' then
    ckNoKnownAllergies.Checked := True
  else if Allergy <> '' then
  begin
    lstAllergy.Clear;
    lstAllergy.Items.Add(Allergy);
    cboAllergyType.SelectByID(Piece(Allergy, U, 4));
  end;
  Result := Allergy;
end;

procedure TfrmARTAllergy.btnAgent1Click(Sender: TObject);
begin
  inherited;
  // AA: any reason to close the dialog if the user canceled Allergy selection?
  if SelectAllergyAgent = '' then
  begin
    Close;
    Exit;
  end;
  ControlChange(lstAllergy);
end;

procedure TfrmARTAllergy.cboSymptomsClick(Sender: TObject);
begin
  inherited;
  if cboSymptoms.ItemIndex < 0 then
    Exit;
  Changing := True;
  if lstSelectedSymptoms.SelectByID(cboSymptoms.ItemID) > -1 then
    Exit;
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

  uDeletedSymptoms.Free;

  // Defaults.Free;  -- AA: made local to InitDialog so no need to destroy here
  // AllergyList.Free; -- AA: made local to InitDialog so no need to destroy here

  frmARTAllergy := NIL;

  // AA: no need to default the unit variables defined in implementation section
  uAddingNew := False;
  uEditing := False;
  uEnteredInError := False;
  uUserCanVerify := False; // AA: not used

  CoverSheet.OnRefreshPanel(Self, CV_CPRS_ALLG);

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

procedure TfrmARTAllergy.EnableDisableControls(EnabledStatus: Boolean);
begin
  // InitDialog;
  with pgAllergy do
  begin
    tabVerify.TabVisible := False;
    // EnabledStatus;    per Dave, leave out for now.
    tabEnteredInError.TabVisible := uEnteredInError;
    tabGeneral.TabVisible := not uEnteredInError;
  end;
  btnAgent.Enabled := EnabledStatus;
  cboAllergyType.Enabled := EnabledStatus;
  cboNatureOfReaction.Enabled := EnabledStatus;
  lblAllergyType.Enabled := EnabledStatus;
  lblAgent.Enabled := EnabledStatus;
  lblSymptoms.Enabled := EnabledStatus;
  lblSelectedSymptoms.Enabled := EnabledStatus;
  grpObsHist.Enabled := EnabledStatus;
  memComments.Enabled := EnabledStatus;
  lblComments.Enabled := EnabledStatus;
  lstSelectedSymptoms.Enabled := EnabledStatus;
  lblObservedDate.Enabled := EnabledStatus;
  calObservedDate.Enabled := EnabledStatus;
  lblSeverity.Enabled := EnabledStatus;
  cboSeverity.Enabled := EnabledStatus;
  btnSevHelp.Enabled := EnabledStatus;
  lstAllergy.Enabled := EnabledStatus;
  cboSymptoms.Enabled := EnabledStatus;
  SymptomDateBox.Enabled := ((EnabledStatus) and (lstSelectedSymptoms.Count > 0));
end;

procedure TfrmARTAllergy.cmdOKClick(Sender: TObject);
const
  TX_ENTERED_IN_ERROR = 'Mark this entry as ''Entered in Error''?';
  TC_ENTERED_IN_ERROR = 'Are you sure?';
  TX_HIST_NOSELECT = 'You must enter at least one sign/symptom or enter' + CRLF
    + // N.Costanzo 06/19/15 NSR (20120404)
    'a comment of at least 4 characters when documenting' + CRLF +
  // N.Costanzo 06/19/15 NSR (20120404)
    'an historical allergy/adverse drug reaction.';
  // N.Costanzo 06/19/15 NSR (20120404)
var
  Saved: string;
begin
  { if in History Mode and lstSelectedSymptoms has items and it's UNKNOWN, then exit }
  // N.Costanzo 06/19/15 NSR (20120404)
  if grpObsHist.ItemIndex = 1 then { If historical selected }
    // N.Costanzo 06/19/15 NSR (20120404)
    if (lstSelectedSymptoms.Count = 0) and // N.Costanzo 05/07/15 NSR (20120404)
      (Length(StringReplace(memComments.Text, #13#10, '', [])) < 4) then
    // N.Costanzo 05/07/15 NSR (20120404)
    begin // N.Costanzo 05/07/15 NSR (20120404)
      InfoBox(TX_HIST_NOSELECT, 'Must Select a Sign/Symptom or Enter Comment',
        MB_OK); // N.Costanzo 05/01/15 NSR (20120404)
      Exit; // N.Costanzo 05/07/15 NSR (20120404)
    end;
  if ValidSave then
  begin
    uAllergiesChanged := True;
    if uEnteredInError then
      if not(InfoBox(TX_ENTERED_IN_ERROR, TC_ENTERED_IN_ERROR,
        MB_YESNO or MB_ICONQUESTION) = ID_YES) then
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
      CheckAllergyScan; // NSR#20070203   #14
      if SendMessageUMNewOrderOnOK then
      begin
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
        TResponsiveGUI.ProcessMessages;
      end;
    end;
    FAbort := False;
    Close;

    if Assigned(fOnAfterSave) then
      fOnAfterSave(Sender);

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
  i: Integer;
  x: string;
begin
  inherited;
  Changing := True;
  with lstSelectedSymptoms do
  begin
    if (Items.Count = 0) or (ItemIndex = -1) then
      Exit;
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
    if (Items.Count > 0) and (ItemIndex = -1) then
      ItemIndex := 0;
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
  with cboSymptoms do
    if (ItemIndex < 0) or (Text = '') or (ItemID = '') then
      Exit;
  if (lstSelectedSymptoms.SelectByID(cboSymptoms.ItemID) > -1) or
    (lstSelectedSymptoms.Items.IndexOf(cboSymptoms.Text) > -1) then
    Exit;
  if (lstSelectedSymptoms.Count + 1) > 38 then
  begin
    InfoBox(TX_SS_MAX, TC_SS_MAX, MB_ICONERROR or MB_OK);
    Exit;
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
  end;
  (* else                             Free-text entries no longer allowed.
    with lstSelectedSymptoms do
    begin
    Items.Add('FT' + U + cboSymptoms.Text);
    ItemIndex := Items.Count - 1;
    end; *)
  Changing := False;
  ControlChange(Self)
end;

procedure TfrmARTAllergy.cboSymptomsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    cboSymptomsMouseClick(Self);
end;

procedure TfrmARTAllergy.cmdCancelClick(Sender: TObject);
begin
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

    if SymptomDateBox.Enabled then
    begin
      AFMDateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 3));
      if AFMDateTime > 0 then
        SymptomDateBox.FMDateTime := AFMDateTime
      else
        SymptomDateBox.Text := 'NOW';
    end;
  end;
end;

procedure TfrmARTAllergy.cboVerifierNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList(cboVerifier, StartFrom, Direction);
end;

procedure TfrmARTAllergy.SetupVerifyFields(ARec: TAllergyRec);
var
  CanBeVerified: Boolean;
begin
  tabVerify.TabVisible := False; // FOR NOW
  if not tabVerify.TabVisible then // AA: Method is not used?
    Exit;
  if not uUserCanVerify then
  begin
    tabVerify.TabVisible := False;
    Exit;
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
    cboVerifier.Enabled := CanBeVerified;
    calVerifyDate.Enabled := CanBeVerified;
    ckVerified.Enabled := CanBeVerified;
    lblVerifier.Enabled := CanBeVerified;
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
  tabGeneral.TabVisible := not uEnteredInError;
  tabVerify.TabVisible := False; // not uEnteredInError;
  Changing := True;
  ckEnteredInError.Checked := uEnteredInError;
  if uEnteredInError then
  begin
    lblEnteredInError.Caption := TX_ENTERED_IN_ERROR1 +
      UpperCase(OldRec.CausativeAgent) + TX_ENTERED_IN_ERROR2;
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

procedure TfrmARTAllergy.FormActivate(Sender: TObject);
begin
  inherited;
  if pgAllergy.ActivePage = tabGeneral then
  begin
    if ckNoKnownAllergies.Enabled then ckNoKnownAllergies.SetFocus
    else btnCurrent.SetFocus;
  end;
end;

procedure TfrmARTAllergy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  // Release;
  // AA: no need to update the form fields onClosing it
  uEditing := False;
  uEnteredInError := False;
  uAddingNew := False;

  Application.HintHidePause := FOldHintPause;
  Action := caFree;

  UnlockIfAble; // SMT Unlock when allergies close.
end;

procedure TfrmARTAllergy.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if FAbort and { frmARTAllergy } Self.Visible then
  begin
    if InfoBox('Are you sure you want to cancel Entering/Editing this allergy?',
      'Exiting Allergy Enter/Edit form', MB_YESNO) = ID_NO then
    begin
      CanClose := False;
      Exit;
    end;
  end;
  if AbortAction then
    Exit;
end;

procedure TfrmARTAllergy.btnSevHelpClick(Sender: TObject);
const
  TX_SEV_DEFINITION = 'MILD - Requires minimal therapeutic intervention ' + #13
    + #10 + 'such as discontinuation of drug(s)' + #13 + #10 + '' + #13 + #10 +
    'MODERATE - Requires active treatment of adverse reaction, ' + #13 + #10 +
    'or further testing or evaluation to assess extent of non-serious' + #13 +
    #10 + 'outcome (see SEVERE for definition of serious).' + #13 + #10 + '' +
    #13 + #10 + 'SEVERE - Includes any serious outcome, resulting in life- or' +
    #13 + #10 + 'organ-threatening situation or death, significant or permanent'
    + #13 + #10 +
    'disability, requiring intervention to prevent permanent impairment ' + #13
    + #10 + 'or damage, or requiring/prolonging hospitalization.';
  TC_SEV_CAPTION = 'Severity Levels';
begin
  inherited;
  InfoBox(TX_SEV_DEFINITION, TC_SEV_CAPTION, MB_ICONINFORMATION or MB_OK);
end;


procedure TfrmARTAllergy.CheckAllergyScan; // 20070203 Entire procedure  #14
var
  MatchingDrugs: TORStringList;
  NewAllergy, OrderID: String;
  i, idx: integer;

begin
  if lstAllergy.Items.Count < 1 then
    exit;
  lstAllergy.ItemIndex := 0;
  NewAllergy := Piece(lstAllergy.Items[0], '^', 2);
  MatchingDrugs := TORStringList.Create;
  try
    CallVistA('ORWDAL32 CHKMEDS', [Patient.DFN, NewAllergy],MatchingDrugs);
    if MatchingDrugs.Count > 0 then
    begin
      if assigned(uAllergyOrdersCurrentlyBeingDiscontinued) then
      begin
        for i := 0 to uAllergyOrdersCurrentlyBeingDiscontinued.Count - 1 do
        begin
          OrderID := uAllergyOrdersCurrentlyBeingDiscontinued[i];
          repeat
            idx := MatchingDrugs.IndexOfPiece(OrderID, U);
            if idx >= 0 then
              MatchingDrugs.Delete(idx);
          until (idx < 0);
          if MatchingDrugs.Count = 0 then
            break;
        end;
        uAllergyOrdersCurrentlyBeingDiscontinued.Clear;
      end;
      if MatchingDrugs.Count > 0 then
        ExecuteNewAllergyCheck(MatchingDrugs, NewAllergy);
    end;
  finally
    MatchingDrugs.Free;
  end;
end;

initialization

finalization
  uAllergyOrdersCurrentlyBeingDiscontinued.Free;

end.
