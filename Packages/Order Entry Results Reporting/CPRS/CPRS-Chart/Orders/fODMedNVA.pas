unit fODMedNVA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ComCtrls, ExtCtrls, ORCtrls, Grids, Buttons, uConst, ORDtTm,
  Menus, uIndications,
//  XUDIGSIGSC_TLB,
  rMisc, uOrders, StrUtils, oRFn, contnrs,
  VA508AccessibilityManager;

const
  UM_DELAYCLICK = 11037;  // temporary for listview click event
  NVA_CR = #13;
  NVA_LF = #10;

type
  TCaptionStringGrid = class(ORCtrls.TCaptionStringGrid)
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
  end;
  TfrmODMedNVA = class(TfrmODBase)
    txtMed: TEdit;
    pnlMeds: TPanel;
    lstQuick: TCaptionListView;
    sptSelect: TSplitter;
    lstAll: TCaptionListView;
    dlgStart: TORDateTimeDlg;
    cboXDosage: TORComboBox;
    cboXRoute: TORComboBox;
    timCheckChanges: TTimer;
    pnlFields: TPanel;
    pnlTop: TPanel;
    lblRoute: TLabel;
    lblSchedule: TLabel;
    grdDoses: TCaptionStringGrid;
    lblGuideline: TStaticText;
    tabDose: TTabControl;
    cboDosage: TORComboBox;
    cboRoute: TORComboBox;
    cboSchedule: TORComboBox;
    pnlXSchedule: TPanel;
    cboXSchedule: TORComboBox;
    txtXDuration: TCaptionEdit;
    spnXDuration: TUpDown;
    chkXPRN: TCheckBox;
    chkPRN: TCheckBox;
    btnXInsert: TButton;
    btnXRemove: TButton;
    pnlBottom: TPanel;
    popDuration: TPopupMenu;
    pnlXDuration: TPanel;
    pnlXDurationButton: TKeyClickPanel;
    btnXDuration: TSpeedButton;
    lblAdminSch: TMemo;
    lblComment: TLabel;
    memComment: TCaptionMemo;
    lblAdminTime: TStaticText;
    calStart: TORDateBox;
    Label1: TLabel;
    lbStatements: TORListBox;
    Label2: TLabel;
    btnSelect: TButton;
    Image1: TImage;
    memDrugMsg: TMemo;
    txtNSS: TLabel;
    cboXSequence: TORComboBox;
    pnlXAdminTime: TPanel;
    lblIndications: TLabel;
    popBlank: TMenuItem;
    months1: TMenuItem;
    weeks1: TMenuItem;
    popDays: TMenuItem;
    hours1: TMenuItem;
    minutes1: TMenuItem;
    cboIndication: TORComboBox;
    procedure txtNSSClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure tabDoseChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure txtMedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtMedKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtMedChange(Sender: TObject);
    procedure txtMedExit(Sender: TObject);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListViewResize(Sender: TObject);
    procedure lstQuickData(Sender: TObject; Item: TListItem);
    procedure lstAllDataHint(Sender: TObject; StartIndex,
      EndIndex: Integer);
    procedure lstAllData(Sender: TObject; Item: TListItem);
    procedure lblGuidelineClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure cboScheduleChange(Sender: TObject);
    procedure cboRouteChange(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboDosageClick(Sender: TObject);
    procedure cboDosageChange(Sender: TObject);
    procedure cboScheduleClick(Sender: TObject);
    procedure DispOrderMessage(const AMessage: string);

    procedure QuantityMessageCheck(Tag: Integer);

    procedure chkXPRNClick(Sender: TObject);

    procedure pnlXDurationEnter(Sender: TObject);
    procedure pnlXDurationExit(Sender: TObject);

    procedure pnlXAdminTimeClick(Sender: TObject);

    procedure pnlFieldsResize(Sender: TObject);

    procedure cboXScheduleChange(Sender: TObject);
    procedure cboXScheduleClick(Sender: TObject);
    procedure cboXScheduleExit(Sender: TObject);
    procedure cboXScheduleEnter(Sender: TObject);
    procedure cboXScheduleKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure cboXRouteChange(Sender: TObject);
    procedure cboXRouteClick(Sender: TObject);
    procedure cboXRouteExit(Sender: TObject);
    procedure cboXRouteEnter(Sender: TObject);

    procedure cboXSequenceChange(Sender: TObject);
    procedure cboXSequenceExit(Sender: TObject);
    procedure cboXSequence1Exit(Sender: TObject);
    procedure cboXSequenceEnter(Sender: TObject);
    procedure cboXSequenceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure cboXDosageEnter(Sender: TObject);
    procedure cboXDosageChange(Sender: TObject);
    procedure cboXDosageClick(Sender: TObject);
    procedure cboXDosageExit(Sender: TObject);
    procedure cboXDosageKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure txtXDurationChange(Sender: TObject);

    procedure pnlXScheduleEnter(Sender: TObject);
    procedure pnlXScheduleExit(Sender: TObject);

    procedure grdDosesKeyPress(Sender: TObject; var Key: Char);
    procedure grdDosesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdDosesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure popDurationClick(Sender: TObject);

    procedure btnXDurationClick(Sender: TObject);
    procedure pnlXDurationButtonEnter(Sender: TObject);

    procedure grdDosesExit(Sender: TObject);
    procedure ListViewEnter(Sender: TObject);
    procedure timCheckChangesTimer(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure btnXInsertClick(Sender: TObject);
    procedure btnXRemoveClick(Sender: TObject);
    procedure cboDosageExit(Sender: TObject);
    procedure chkPRNClick(Sender: TObject);
    procedure grdDosesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdDosesEnter(Sender: TObject);
    procedure pnlMessageEnter(Sender: TObject);
    procedure pnlMessageExit(Sender: TObject);
    procedure memMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure lbStatementsClickCheck(Sender: TObject; Index: Integer);
    procedure lstChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cboDosageKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboRouteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboScheduleKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtXDurationEnter(Sender: TObject);
    procedure cboIndicationChange(Sender: TObject);
  private
    {selection}
    FShowPnlXScheduleOk: Boolean;
    FNVAMedCache:   TObjectList;
    FCacheIEN:   integer;
    FQuickList:  Integer;
    FQuickItems: TStringList;
    FChangePending: Boolean;
    FKeyTimerActive: Boolean;
    FActiveMedList: TListView;
    FRowHeight: Integer;
    FFromSelf: Boolean;
    {edit}
    FAllDoses:  TStringList;
    FAllDrugs:  TStringList;
    FGuideline: TStringList;
    FLastUnits:    string;
    FLastSchedule: string;
    FLastDuration: string;
    FLastInstruct: string;
    FLastDispDrug: string;
    FLastQuantity: Integer;
    FLastSupply:   Integer;
    FLastPickup:   string;
    FSIGVerb: string;
    FSIGPrep: string;
    FDrugID: string;
    fInptDlg: Boolean;
    FNonVADlg: Boolean;
    FUpdated: Boolean;
    FSuppressMsg: Boolean;
    FPtInstruct: string;
    FAltChecked: Boolean;
    FShrinkDrugMsg: boolean;
    FQOQuantity: Double;
    FQODosage: string;
    FNoZERO: boolean;
    FIsQuickOrder: boolean;
    FAdminTimeLbl: string;
    FDisabledDefaultButton: TButton;
    FDisabledCancelButton: TButton;
    FShrinked: boolean;
    FQOInitial: boolean;
    FOrigiMsgDisp: Boolean;
    FRemoveText : Boolean;
    FMedName: string;
    FNSSAdminTime: string;
    FNSSScheduleType: string;

    FAdminTimeText: string;
    FDropColumn: Integer;

    FIndications: TIndications;

    { selection }
    FSmplPRNChkd: Boolean;
    procedure ChangeDelayed;
    procedure LoadNonVAMedCache(First, Last: Integer);
    function FindQuickOrder(const x: string): Integer;
    function isUniqueQuickOrder(iText: string): Boolean;
    function GetCacheChunkIndex(idx: integer): integer;
    procedure ScrollToVisible(AListView: TListView);
    procedure StartKeyTimer;
    procedure StopKeyTimer;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    // NON VA MEDS
    procedure LoadOTCStatements(Dest: TStrings);

    {edit}
    procedure ResetOnMedChange;
    procedure ResetOnTabChange;
    procedure SetOnMedSelect;
    procedure SetOnQuickOrder;
    procedure ShowMedSelect;
    procedure ShowMedFields;
    procedure ShowControlsSimple;
    procedure ShowControlsComplex;
    procedure SetDosage(const x: string);
    procedure SetStatements(x: string);
    procedure SetStartDate(const x: string);
    procedure SetSchedule(const x: string);
    procedure CheckFormAltDose(DispDrug: Integer);
    function ConstructedDoseFields(const ADose: string; PrependName: Boolean = FALSE): string;
    function FindCommonDrug(DoseList: TStringList): string;
    function FindDoseFields(const Drug, ADose: string): string;
    function OutpatientSig: string;
    function  SearchStatements(StatementList:TStringList;Statement: string): Boolean;
    procedure UpdateRelated(DelayUpdate: Boolean = TRUE);
    procedure UpdateStartExpires(const CurSchedule: string);
    function DisableDefaultButton(Control: TWinControl): boolean;
    function DisableCancelButton(Control: TWinControl): boolean;
    procedure RestoreDefaultButton;
    procedure RestoreCancelButton;
    function ValueOf(FieldID: Integer; ARow: Integer = -1): string;
    function ValueOfResponse(FieldID: Integer; AnInstance: Integer = 1): string;
    function ValFor(FieldID, ARow: Integer): string;
    procedure UMDelayClick(var Message: TMessage); message UM_DELAYCLICK;
    procedure lblAdminSchSetText(str: string);
    procedure ShowEditor(ACol, ARow: Integer; AChar: Char);
    procedure UpdateDurationControls(FreeText: Boolean);

    function FieldsForDose(ARow: Integer): string;
    function FieldsForDrug(const DrugID: string): string;

    // NSS
    function lblAdminSchGetText: string;
    procedure DropLastSequence(ASign: Integer = 0);
    function CreateOtherScheduelComplex: string;
    procedure ValidateInpatientSchedule(ScheduleCombo: TORComboBox);
    function GetSchedListIndex(SchedCombo: TORComboBox;
      pSchedule: String): Integer;
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    function InpatientSig: string;
    function IsSupplyAndOutPatient: Boolean;
  public
    ARow1: Integer;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure CheckDecimal(var AStr: string);
    property MedName: string read FMedName write FMedName;
    property NSSAdminTime: string read FNSSAdminTime write FNSSAdminTime;
    property NSSScheduleType: string read FNSSScheduleType
      write FNSSScheduleType;
  end;

var
  frmODMedNVA: TfrmODMedNVA;
//  crypto: IXuDigSigS;

//function OIForNVA(AnIEN: Integer; ForNonVAMed: Boolean; HavePI: boolean = True; PKIActive: Boolean = False): TStrings;
function setOIForNVA(aList:TSTrings;AnIEN: Integer; ForNonVAMed: Boolean; HavePI: boolean = True; PKIActive: Boolean = False): Integer;
procedure CheckAuthForNVAMeds(var x: string);

implementation

{$R *.DFM}

uses rCore, uCore, rODMeds, rODBase, rOrders, fRptBox, fODMedOIFA,
  fOtherSchedule, VA508AccessibilityRouter, System.Types,
  System.UITypes,
  fFrame, ORNet, VAUtils, fODAllergyCheck, uResponsiveGUI;

const
  {grid columns for complex dosing }
  COL_SELECT = 0;
  COL_DOSAGE = 1;
  COL_ROUTE = 2;
  COL_SCHEDULE = 3;
  COL_DURATION = 4;
  COL_ADMINTIME = 5;
  COL_SEQUENCE = 6;
  COL_CHKXPRN = 7;
  VAL_DOSAGE = 10;
  VAL_ROUTE = 20;
  VAL_SCHEDULE = 30;
  VAL_DURATION = 40;
  VAL_ADMINTIME = 50;
  VAL_SEQUENCE = 60;
  VAL_CHKXPRN = 70;
  TAB          = #9;
  {field identifiers}
  FLD_LOCALDOSE =  1;
  FLD_STRENGTH  =  2;
  FLD_DRUG_ID   =  3;
  FLD_DRUG_NM   =  4;
  FLD_DOSEFLDS  =  5;
  FLD_UNITNOUN  =  6;
  FLD_TOTALDOSE =  7;
  FLD_DOSETEXT  =  8;
  FLD_INSTRUCT  = 10;
  FLD_DOSEUNIT  = 11;
  FLD_ROUTE_ID  = 15;
  FLD_ROUTE_NM  = 16;
  FLD_ROUTE_AB  = 17;
  FLD_ROUTE_EX  = 18;
  FLD_SCHEDULE  = 20;
  FLD_SCHED_EX  = 21;
  FLD_SCHED_TYP = 22;
  FLD_DURATION  = 30;
  FLD_SEQUENCE  = 31;
  FLD_MISC_FLDS = 50;
  FLD_SUPPLY    = 51;
  FLD_QUANTITY  = 52;
  FLD_REFILLS   = 53;
  FLD_PICKUP    = 55;
  FLD_QTYDISP   = 56;
  FLD_SC        = 58;
  FLD_PRIOR_ID  = 60;
  FLD_PRIOR_NM  = 61;
  FLD_START_ID  = 70;
  FLD_START_NM  = 71;
  FLD_EXPIRE    = 72;
  FLD_ANDTHEN   = 73;
  FLD_NOW_ID    = 75;
  FLD_NOW_NM    = 76;
  FLD_COMMENT   = 80;
  FLD_PTINSTR   = 85;
  FLD_START     = 88;
  FLD_STATEMENTS = 90;
  FLD_INDICATIONS = 99;

    {dosage type tab index values}
  TI_DOSE       =  0;
  TI_RATE       =  99;
  TI_COMPLEX    =  1;
  {misc constants}
  TIMER_ID = 6902;                                // arbitrary number
  TIMER_DELAY = 500;                              // 500 millisecond delay
  TIMER_FROM_DAYS = 1;
  TIMER_FROM_QTY  = 2;

  MED_CACHE_CHUNK_SIZE = 100;
  {text constants}
  TX_ADMIN      = 'Requested Start: ';
  TX_TAKE       = '';
  TX_NO_DEA     = 'Provider must have a DEA# or VA# to order this medication';
  TC_NO_DEA     = 'DEA# Required';
  TX_NO_MED     = 'Medication must be selected.';
  TX_NO_SEQ     = 'Missing one or more conjunction.';
  TX_NO_DOSE    = 'Dosage must be entered.';
  TX_DOSE_NUM   = 'Dosage may not be numeric only';
  TX_DOSE_LEN   = 'Dosage may not exceed 60 characters';
  TX_NO_ROUTE   = 'Route must be entered.';
  TX_NF_ROUTE   = 'Route not found in the Medication Routes file.';
  TX_NO_SCHED   = 'Schedule must be entered.';
  TX_NO_PICK    = 'A method for picking up the medication must be entered.';
  TX_RNG_REFILL = 'The number of refills must be in the range of 0 through ';
  TX_SCH_QUOTE  = 'Schedule must not have quotemarks in it.';
  TX_SCH_MINUS  = 'Schedule must not have a dash at the beginning.';
  TX_SCH_SPACE  = 'Schedule must have only one space in it.';
  TX_SCH_LEN    = 'Schedule must be less than 70 characters.';
  TX_SCH_PRN    = 'Schedule cannot include PRN - use Comments to enter PRN.';
  TX_SCH_ZERO   = 'Schedule cannot be Q0';
  TX_SCH_LSP    = 'Schedule may not have leading spaces.';
  TX_SCH_NS     = 'Unable to resolve non-standard schedule.';
  TX_MAX_STOP   = 'The maximum expiration for this order is ';
  TX_OUTPT_IV   = 'This patient has not been admitted.  Only IV orders may be entered.';
  TX_QTY_MAIL   = 'Quantity for mailed items must be a whole number.';
  TC_RESTRICT   = 'Ordering Restrictions';
  TC_GUIDELINE  = 'Restrictions/Guidelines';
  TX_QTY_PRE    = '>> Quantity Dispensed: ';
  TX_QTY_POST   = ' <<';
  TX_STARTDT    = 'Unable to interpret start date.';  //cla 7-17-03
  TX_FUTUREDT   = 'Dates in the future are not allowed.';  //cla 7-17-03
  TX_NO_FUTURE_DATES  = 'Dates in the future are not allowed.';
  TX_BAD_DATE         = 'Dates must be in the format mm/dd/yy or mm/yy';
  TX_CAP_FUTURE       = 'Invalid date';

{ procedures inherited from fODBase --------------------------------------------------------- }

procedure TfrmODMedNVA.FormCreate(Sender: TObject);
const
  TC_RESTRICT = 'Ordering Restrictions';
var
  sl: TSTringList;
  ListCount: Integer;
  Restriction, x: string;
begin
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := True;
 // ActivateOrderDialog(Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  inherited;
  AllowQuickOrder := True;
  btnXDuration.Align := alClient;

  if User.OrderRole in[OR_CLERK] then   // if user is clerk check restrictions else ok to write NonVA Order.
    begin
      CheckAuthForNVAMeds(Restriction);
      if Length(Restriction) > 0 then
        begin
          CheckAuthForNVAMeds(Restriction);
          if Length(Restriction) > 0 then
            begin
              InfoBox(Restriction, TC_RESTRICT, MB_OK);
              Close;
              Exit;
            end;
        end;
    end;  // clerk restrictions

  if DlgFormID = OD_MEDNONVA  then FNonVADlg := TRUE;
  FillerID := 'PSH';    // CLA 6/3/03
  FGuideline := TStringList.Create;
  FAllDoses  := TStringList.Create;
  FAllDrugs  := TStringList.Create;

  StatusText('Loading Dialog Definition');

  Responses.Dialog := 'PSH OERR';  // CLA 6/3/03
  Responses.SetPromptFormat('INSTR', '@');
  StatusText('Loading Schedules');
//  LoadSchedules(cboSchedule.Items);               // load the schedules combobox (cached)
  sl := TSTringList.Create;             //  RTC 762237
  LoadSchedules(sl, patient.Inpatient); //  RTC 762237
  cboSchedule.Items.Assign(sl);         //  RTC 762237
  sl.Free;                              //  RTC 762237
  StatusText('');
  FSuppressMsg := CtrlInits.DefaultText('DispMsg') = '1';
  InitDialog;

  with grdDoses do
  begin
    ColWidths[0] := 8; // select
    ColWidths[1] := 160; // dosage
    ColWidths[2] := 82; // route
    ColWidths[3] := 102; // schedule
    ColWidths[4] := 70; // duration
    if (fInptDlg) and (FAdminTimeText <> 'Not defined for Clinic Locations')
    then
    begin
      ColWidths[5] := 102; // administration times
      ColWidths[6] := 58; // and/then
    end
    else
      ColWidths[5] := 0;
    ColWidths[6] := 58;
    Cells[1, 0] := 'Dosage';
    Cells[2, 0] := 'Route';
    Cells[3, 0] := 'Schedule';
    Cells[4, 0] := 'Duration (optional)';
    Cells[5, 0] := 'Admin. Times';
    Cells[6, 0] := 'then/and';
  end;
   // medication selection
  FRowHeight := MainFontHeight + 1;
  x := 'NV RX';  // CLA 6/3/03; carried forward by WEF 3/14/19 from inpatient complex orders
  ListForOrderable(FCacheIEN, ListCount, x);
  lstAll.Items.Count := ListCount;
  FNVAMedCache := TObjectList.Create;
  FQuickItems := TStringList.Create;
  ListForQuickOrders(FQuickList, ListCount, x);
 if ListCount > 0 then
  begin
    lstQuick.Items.Count := ListCount;
    SubsetOfQuickOrders(FQuickItems, FQuickList, 0, 0);
    FActiveMedList := lstQuick;
  end else
  begin
    lstQuick.Items.Count := 1;
    ListCount := 1;
    FQuickItems.Add('0^(No quick orders available)');
    FActiveMedList := lstAll;
  end;

  // set the height based on user parameter here
  with lstQuick do if ListCount < VisibleRowCount
    then Height := (((Height - 6) div VisibleRowCount) * ListCount) + 6;
  pnlFields.Height := cmdAccept.Top - 4 - pnlFields.Top;
  pnlFields.Width := self.Width - 25;
  cmdAccept.Left := cmdQuit.Left;
  cmdaccept.Anchors := cmdQuit.anchors;
  FNoZero := False;
  FShrinked := False;
  // Load OTC Statement/Explanations
  LoadOTCStatements(lbStatements.Items);
  FRemoveText := True;
  FShrinkDrugMsg := False;
  FShowPnlXScheduleOk := TRUE;
  if ScreenReaderActive then lstQuick.TabStop := True;

  FIndications := TIndications.Create(CtrlInits);
  FIndications.IsUNKNOWN := True;
end;

procedure TfrmODMedNVA.FormDestroy(Sender: TObject);
begin
  FIndications.Free;
  {selection}
  FQuickItems.Free;
  FNVAMedCache.Free;
  {edit}
  FGuideline.Free;
  FAllDoses.Free;
  FAllDrugs.Free;
 // TAccessibleStringGrid.UnwrapControl(grdDoses);
  inherited;
  frmFrame.pnlVisit.Enabled := true;
end;

procedure TfrmODMedNVA.InitDialog;
{ Executed each time dialog is reset after pressing accept.  Clears controls & responses }
begin
  inherited;
  FLastPickup := ValueOf(FLD_PICKUP);
  Changing := True;
  ResetOnMedChange;
  txtMed.Text := '';
  txtMed.Tag := 0;
  lstQuick.Selected := nil;
  lstAll.Selected := nil;
  if Visible then ShowMedSelect;
  Changing := False;
  FIsQuickOrder := False;
  FQOQuantity := 0 ;
  FQODosage   := '';
  memComment.Clear;  // sometimes the sig is in the comment
  LoadOTCStatements(lbStatements.Items);
  txtMed.Width := ClientWidth - 30;
  pnlMeds.Width := ClientWidth - 30;
  pnlMeds.Height := pnlFields.Height;
end;

procedure TfrmODMedNVA.SetupDialog(OrderAction: Integer; const ID: string);
var
  //AnInstr: string;
  OrderID: string;
begin
  inherited;
 // if FInptDlg and (not FOutptIV) then DisplayGroup := DisplayGroupByName('UD RX')
  DisplayGroup := DisplayGroupByName('NV RX');   // CLA 6/3/03
  if XfInToOutNow then DisplayGroup := DisplayGroupByName('O RX');
  if CharAt(ID,1)='X' then
  begin
    OrderID := Copy(Piece(ID, ';', 1), 2, Length(ID));
    CheckExistingPI(OrderID, FPtInstruct);
  end;
  if OrderAction = ORDER_QUICK then
    FIsQuickOrder := True
  else
    FIsQuickOrder := False;
//  if OrderAction in [ORDER_COPY, ORDER_EDIT] then Responses.Remove('START', 1);
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
  begin
    Changing := True;
    txtMed.Tag  := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
    SetOnMedSelect;
    SetOnQuickOrder;                                  // set up for this medication
    ShowMedFields;
    if (OrderAction = ORDER_EDIT) and OrderIsReleased(Responses.EditOrder)
      then btnSelect.Enabled := False;
    UpdateRelated(FALSE);
    Changing := False;
  end;
  { prevent the SIG from being part of the comments on pre-CPRS prescriptions }
  {if (OrderAction in [ORDER_COPY, ORDER_EDIT]) and (cboDosage.Text = '') then  //commented out by cla 2/27/04 - CQ 2591; carried forward by WEF 3/14/19 from inpatient complex orders
  begin
    OrderID := Copy(Piece(ID, ';', 1), 2, Length(ID));
    AnInstr := TextForOrder(OrderID);
    pnlMessage.TabOrder := 0;
    OrderMessage(AnInstr);
    if OrderAction = ORDER_COPY
      then AnInstr := 'Copy: ' + AnInstr
      else AnInstr := 'Change: ' + AnInstr;
    Caption := AnInstr;
    memComment.Clear;  // sometimes the sig is in the comment
    lbStatements.Clear;
  end;}
  ControlChange(Self);
end;

procedure TfrmODMedNVA.Validate(var AnErrMsg: string);
var
  i: Integer;
  StartDate: TFMDateTime;
  temp: string;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

  procedure ValidateDosage(const x: string);
  begin
    if Length(x) = 0 then SetError(TX_NO_DOSE);
  end;

  procedure ValidateRoute(const x: string; NeedLookup: Boolean; AnInstance: Integer);
  var
    RouteID, RouteAbbr: string;
  begin
    if (Length(x) = 0) and (not MedIsSupply(txtMed.Tag)) then SetError(TX_NO_ROUTE);
    if (Length(x) > 0) and NeedLookup then
    begin
      LookupRoute(x, RouteID, RouteAbbr);
      if RouteID = '0'
        then SetError(TX_NF_ROUTE)
        else Responses.Update('ROUTE', AnInstance, RouteID, RouteAbbr);
    end;
  end;

  procedure ValidateSchedule(const x: string; AnInstance: Integer);
  const
    SCH_BAD = 0;
    SCH_NO_RTN = -1;
  var
    ValidLevel: Integer;
    ARoute, ADrug: string;
  begin
    ARoute := ValueOfResponse(FLD_ROUTE_ID, AnInstance);
    ADrug  := ValueOfResponse(FLD_DRUG_ID,  AnInstance);
 {  if (Length(x) = 0) and (not FNonVADlg) then SetError(TX_NO_SCHED)
    else if (Length(x) = 0) and FNonVADlg and ScheduleRequired(txtMed.Tag, ARoute, ADrug)
    then SetError(TX_NO_SCHED);
}
    if Length(x) > 0 then
    begin
      ValidLevel := ValidSchedule(x, 'O');
      if ValidLevel = SCH_NO_RTN then
      begin
        if Pos('"', x) > 0                              then SetError(TX_SCH_QUOTE);
        if Copy(x, 1, 1) = '-'                          then SetError(TX_SCH_MINUS);
        if Pos(' ', Copy(x, Pos(' ', x) + 1, 999)) > 0  then SetError(TX_SCH_SPACE);
        if Length(x) > 70                               then SetError(TX_SCH_LEN);
        if (Pos('P RN', x) > 0) or (Pos('PR N', x) > 0) then SetError(TX_SCH_PRN);
        if Pos('Q0', x) > 0                             then SetError(TX_SCH_ZERO);
        if TrimLeft(x) <> x                             then SetError(TX_SCH_LSP);
      end;
      if ValidLevel = SCH_BAD then SetError(TX_SCH_NS);
    end;
  end;

begin
  inherited;
   begin
  AnErrMsg := '';
  if User.NoOrdering then AnErrMsg := 'Ordering has been disabled. Press Quit';

  ControlChange(Self);                            // make sure everything is updated
  if txtMed.Tag = 0 then SetError(TX_NO_MED);
  if Responses.InstanceCount('INSTR') < 1 then SetError(TX_NO_DOSE);
  i := Responses.NextInstance('INSTR', 0);
  while i > 0 do
  begin
 {   if (ValueOfResponse(FLD_DRUG_ID, i) = '') then
     begin
      if not ContainsAlpha(Responses.IValueFor('INSTR', i)) then SetError(TX_DOSE_NUM);
      if Length(Responses.IValueFor('INSTR', i)) > 60       then SetError(TX_DOSE_LEN);
     end;
    ValidateRoute(Responses.EValueFor('ROUTE', i), Responses.IValueFor('ROUTE', i) = '', i);
    ValidateSchedule(ValueOfResponse(FLD_SCHEDULE, i), i);
 }
    i := Responses.NextInstance('INSTR', i);
  //  inherited;  -  do not reject past dates - historical would not be allowed

       if calStart.Text <> '' then
     begin
        StartDate := ValidDateTimeStr(calStart.Text,'TS');
        if StartDate > FMNow then SetError(TX_NO_FUTURE_DATES);
        if StartDate < 0 then SetError(TX_BAD_DATE);
     end;
   end;
  end;
  if Pos(U, self.memComment.Text) > 0 then SetError('Comments cannot contain a "^".');
  // AGP Change 26.45 Fix for then/and conjucntion PSI-04-069; carried forward by WEF 3/14/19 from inpatient complex orders
  if self.tabDose.TabIndex = TI_COMPLEX then
  begin
    for i := 1 to self.grdDoses.RowCount do
    begin
      temp := ValFor(COL_DOSAGE, i);
      if (LeftStr(temp, 1) = '.') then
      begin
        SetError('All dosage must have a leading numeric value');
        Exit;
      end;
      if (i > 1) and ((ValFor(COL_DOSAGE, i - 1) <> '') and
        (ValFor(COL_DOSAGE, i) <> '')) and (ValFor(COL_SEQUENCE, i - 1) = '')
      then
      begin
        SetError(TX_NO_SEQ);
        Exit;
      end;
      if Uppercase(ValFor(COL_SEQUENCE, i)) = 'THEN' then
      begin
        if ValFor(COL_DURATION, i) = '' then
        begin
          SetError('A duration is required when using "Then" as a sequence.');
          Exit;
        end;
      end;
    end;
  end;
end;

{ Navigate medication selection lists ------------------------------------------------------- }

{ txtMed methods (including timers) }

procedure TfrmODMedNVA.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if (Message.TimerID = TIMER_ID) then
  begin
    StopKeyTimer;
    ChangeDelayed;
  end;
end;

procedure TfrmODMedNVA.StartKeyTimer;
{ start (or restart) a timer (done on keyup to delay before calling OnKeyPause) }
var
  ATimerID: Integer;
begin
  StopKeyTimer;
  ATimerID := SetTimer(Handle, TIMER_ID, TIMER_DELAY, nil);
  FKeyTimerActive := ATimerID > 0;
  // if can't get a timer, just call the event immediately  F
  if not FKeyTimerActive then Perform(WM_TIMER, TIMER_ID, 0);
end;

procedure TfrmODMedNVA.StopKeyTimer;
{ stop the timer (done whenever a key is pressed or the combobox no longer has focus) }
begin
  if FKeyTimerActive then
  begin
    KillTimer(Handle, TIMER_ID);
    FKeyTimerActive := False;
  end;
end;

procedure TfrmODMedNVA.txtMedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: Integer;
  x: string;
begin
  if Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN] then             // navigation
  begin
    FActiveMedList.Perform(WM_KEYDOWN, Key, 0);
    FFromSelf := True;
    try
      if Assigned(FActiveMedList.Selected) then
      begin
        txtMed.Text := FActiveMedList.Selected.Caption;
        txtMed.SelectAll;
      end
      else
        txtMed.Text := '';
    finally
      FFromSelf := False;
    end;
    Key := 0;
  end
  else if Key = VK_BACK then
  begin
    FFromSelf := True;
    x := txtMed.Text;
    i := txtMed.SelStart;
    if i > 1 then Delete(x, i + 1, Length(x)) else x := '';
    txtMed.Text := x;
    if i > 1 then txtMed.SelStart := i;
    FFromSelf := False;
  end
  else {StartKeyTimer};
end;

procedure TfrmODMedNVA.txtMedKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN]) then StartKeyTimer;
end;

procedure TfrmODMedNVA.txtMedChange(Sender: TObject);
begin
  if FFromSelf then Exit;
  FChangePending := True;
end;

procedure TfrmODMedNVA.ScrollToVisible(AListView: TListView);
var
  Offset: Integer;
  SelRect: TRect;
begin
  AListView.Selected.MakeVisible(FALSE);
  SelRect := AListView.Selected.DisplayRect(drBounds);   //  CQ: 6636
  FRowHeight := SelRect.Bottom - SelRect.Top;
  Offset := AListView.Selected.Index - AListView.TopItem.Index;
  TResponsiveGUI.ProcessMessages;
  if Offset > 0 then AListView.Scroll(0, (Offset * FRowHeight));
  TResponsiveGUI.ProcessMessages;
end;

procedure TfrmODMedNVA.ChangeDelayed;
var
  QuickIndex, AllIndex: Integer;
  NewText, OldText, UserText: string;
  UniqueText: Boolean;
begin
  FRemoveText := False;
  UniqueText := False;
  FChangePending := False;
  if (Length(txtMed.Text) > 0) and (txtMed.SelStart = 0) then Exit;  // don't lookup null
  // lookup item in appropriate list box
  NewText := '';
  UserText := Copy(txtMed.Text, 1, txtMed.SelStart);
  QuickIndex := FindQuickOrder(UserText);
  AllIndex := IndexOfOrderable(FCacheIEN, UserText);  // but always synch the full list
  if UserText <> Copy(txtMed.Text, 1, txtMed.SelStart) then Exit;  // if typing during lookup
  if AllIndex > -1 then
  begin
    lstAll.Selected := lstAll.Items[AllIndex];
    FActiveMedList := lstAll;
  end;
  if QuickIndex > -1 then
  begin
    try
      lstQuick.Selected := lstQuick.Items[QuickIndex];
      lstQuick.ItemFocused := lstQuick.Selected;
      NewText := lstQuick.Selected.Caption;
      FActiveMedList := lstQuick;
      //Search Quick List for Uniqueness
      UniqueText := isUniqueQuickOrder(UserText);
    except
      //doing nothing  short term solution related to 117
    end;
  end
  else if AllIndex > -1 then
  begin
    lstAll.Selected := lstAll.Items[AllIndex];
    lstAll.ItemFocused := lstAll.Selected;
    NewText := lstAll.Selected.Caption;
    lstQuick.Selected := nil;
    FActiveMedList := lstAll;
    //List is alphabetical, So compare next Item in list to establish uniqueness.
    if CompareText(UserText, Copy(lstAll.Items[AllIndex+1].Caption, 1, Length(UserText))) <> 0 then
      UniqueText := True;
  end
  else
  begin
    lstQuick.Selected := nil;
    lstAll.Selected := nil;
    FActiveMedList := lstAll;
    NewText := txtMed.Text;
  end;
  if (AllIndex > -1) and (QuickIndex > -1) then  //Not Unique Between Lists
    UniqueText := False;
  FFromSelf := True;
  if UniqueText then
  begin
    OldText := Copy(txtMed.Text, 1, txtMed.SelStart);
    txtMed.Text := NewText;
    //txtMed.SelStart := Length(OldText);  // v24.14 RV
    txtMed.SelStart := Length(UserText);   // v24.14 RV; carried forward by WEF 3/14/19 from inpatient complex orders
    txtMed.SelLength := Length(NewText);
  end
  else begin
    txtMed.Text := UserText;
    txtMed.SelStart := Length(txtMed.Text);
  end;
  FFromSelf := False;
  if lstAll.Selected <> nil then
    ScrollToVisible(lstAll);
  if lstQuick.Selected <> nil then
    ScrollToVisible(lstQuick);
  if Not UniqueText then
  begin
    lstQuick.ItemIndex := -1;
    lstAll.ItemIndex := -1;
  end;
  FRemoveText := True;
end;

procedure TfrmODMedNVA.txtMedExit(Sender: TObject);
begin
  StopKeyTimer;
  if not ((ActiveControl = lstAll) or (ActiveControl = lstQuick)) then ChangeDelayed;
end;

{ lstAll & lstQuick methods }

procedure TfrmODMedNVA.ListViewEnter(Sender: TObject);
begin
  inherited;
  FActiveMedList := TListView(Sender);
  with Sender as TListView do
  begin
    if Selected = nil then Selected := TopItem;
    if Name = 'lstQuick' then lstAll.Selected := nil else lstQuick.Selected := nil;
    ItemFocused := Selected;
  end;
end;

procedure TfrmODMedNVA.ListViewClick(Sender: TObject);
begin
  inherited;
  btnSelect.Visible := True;
  btnSelect.Enabled := True;
  //txtMed.Text := FActiveMedList.Selected.Caption;
  PostMessage(Handle, UM_DELAYCLICK, 0, 0);
end;

procedure TfrmODMedNVA.UMDelayClick(var Message: TMessage);
begin
  btnSelectClick(Self);
end;

procedure TfrmODMedNVA.ListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := FALSE;
end;

procedure TfrmODMedNVA.ListViewResize(Sender: TObject);
begin
  with Sender as TListView do Columns.Items[0].Width := ClientWidth - 20;
end;

{ lstAll Methods (lstAll is TListView) }

// Cache is a list of 100 string lists, starting at idx 0
procedure TfrmODMedNVA.LoadNonVAMedCache(First, Last: Integer);
var
  firstChunk, lastchunk, i: integer;
  list: TStringList;
  firstMed, LastMed: integer;

begin
  firstChunk := GetCacheChunkIndex(First);
  lastChunk := GetCacheChunkIndex(Last);
  for i := firstChunk to lastChunk do
  begin
    if (FNVAMedCache.Count <= i) or (not assigned(FNVAMedCache[i])) then
    begin
      while FNVAMedCache.Count <= i do
        FNVAMedCache.add(nil);
      list := TStringList.Create;
      FNVAMedCache[i] := list;
      firstMed := i * MED_CACHE_CHUNK_SIZE;
      LastMed := firstMed + MED_CACHE_CHUNK_SIZE - 1;
      if LastMed >= lstAll.Items.Count then
        LastMed := lstAll.Items.Count - 1;
      SubsetOfOrderable(list, false, FCacheIEN, firstMed, lastMed);
    end;
  end;
end;

procedure TfrmODMedNVA.lstAllData(Sender: TObject; Item: TListItem);
var
  x: string;
  chunk: integer;
  list: TStringList;
begin
  LoadNonVAMedCache(Item.Index, Item.Index);
  chunk := GetCacheChunkIndex(Item.Index);
  list := TStringList(FNVAMedCache[chunk]);
  //This is to make sure that the index that is being used is not outside of the stringlist
  If Item.Index mod MED_CACHE_CHUNK_SIZE < list.Count then begin
   x := list[Item.Index mod MED_CACHE_CHUNK_SIZE];
   Item.Caption := Piece(x, U, 2);
   Item.Data := Pointer(StrToIntDef(Piece(x, U, 1), 0));
  end;
end;

procedure TfrmODMedNVA.lstAllDataHint(Sender: TObject; StartIndex,
  EndIndex: Integer);
begin
  LoadNonVAMedCache(StartIndex, EndIndex);
end;

{ Medication is now selected ---------------------------------------------------------------- }

procedure TfrmODMedNVA.btnSelectClick(Sender: TObject);
var
  MedIEN: Integer;
  //MedName: string;
  QOQuantityStr: string;
  ErrMsg, temp: string;

  MedReason, MedComment: string;
  aFillerID:String;

  // NSR 20071211  ************** begin; carried forward by WEF 3/14/19 from inpatient complex orders
  function IsAllergyCheckOK(MedIEN:Integer):Boolean;
  begin
    aFillerID := FillerID;
    if (aFillerID <> 'PSI') and (aFillerID <> 'PSO') then
    begin
      if FInptDlg = True then
        aFillerID := 'PSI'
      else
        aFillerID := 'PSO';
    end;
    if (aFillerID = 'PSO') and (DlgFormID = OD_MEDNONVA) then
      aFillerID := 'PSX';

    Result:= MedFieldsNeeded(MedIEN, MedReason, MedComment, aFillerID);
  end;
  // NSR 20071211  ************** begin; carried forward by WEF 3/14/19 from inpatient complex orders
begin
  inherited;
  QOQuantityStr := '';
  btnSelect.SetFocus;
  self.MedName := '';                             // let the exit events finish
  if pnlMeds.Visible then                         // display the medication fields
  begin
    Changing := True;
    ResetOnMedChange;
    if (FActiveMedList = lstQuick) and (lstQuick.Selected <> nil) then   // quick order
    begin
      ErrMsg := '';
      FIsQuickOrder := True;
      FQOInitial := True;
      Responses.QuickOrder := Integer(lstQuick.Selected.Data);
      txtMed.Tag  := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
      IsActivateOI(ErrMsg, txtMed.Tag);
      if Length(ErrMsg)>0 then
      begin
        //btnSelect.Visible := False;
        btnSelect.Enabled := False;
        ShowMsg(ErrMsg);
        Exit;
      end;
      if txtMed.Tag = 0 then
      begin
        //btnSelect.Visible := False;
        btnSelect.Enabled := False;
        txtMed.SetFocus;
        Exit;
      end;

      // NSR 20071211  ************** begin; carried forward by WEF 3/14/19 from inpatient complex orders
      if not IsAllergyCheckOK(txtMed.Tag) then
      begin
        btnSelect.Enabled := FALSE;
        txtMed.SetFocus;
        Exit;
      end;
      // NSR 20071211  ************** end

      SetOnMedSelect;   // set up for this medication
      SetOnQuickOrder;  // insert quick order responses
      ShowMedFields;
    end
    else if (FActiveMedList = lstAll) and (lstAll.Selected <> nil) then  // orderable item
    begin
      MedIEN := Integer(lstAll.Selected.Data);
      self.MedName := lstAll.Selected.Caption;
      txtMed.Tag := MedIEN;
      ErrMsg := '';
      IsActivateOI(ErrMsg, txtMed.Tag);
      if Length(ErrMsg)>0 then
      begin
        btnSelect.Enabled := False;
        ShowMsg(ErrMsg);
        Exit;
      end;

     { if Pos(' NF', MedName) > 0 then
      begin
        CheckFormularyOI(MedIEN, MedName, FNonVADlg);
        FAltChecked := True;
      end;
     }
      if MedIEN <> txtMed.Tag then
      begin
        txtMed.Tag := MedIEN;
        temp := self.MedName;
        self.MedName := txtMed.Text;
        txtMed.Text := Temp;
      end;

      // NSR 20071211  **************; carried forward by WEF 3/14/19 from inpatient complex orders
      if IsAllergyCheckOK(MedIEN) then
      begin
        if (MedReason <> '') then
          Responses.Reason := MedReason;
        if (MedComment <> '') then
          Responses.RemComment := MedComment;
        SetOnMedSelect;
        ShowMedFields;
      end
      else
      begin
        btnSelect.Enabled := FALSE; // defect fix 564813
        Exit;
      end;
      // ******** end of NSR 20071211

      SetOnMedSelect;
      ShowMedFields;
    end
    else                                           // no selection
    begin
      MessageBeep(0);
      Exit;
    end;
    UpdateRelated(False);
    Changing := False;
    ControlChange(Self);
  end
  else ShowMedSelect;                             // show the selection fields
  FNoZERO   := False;
end;

procedure TfrmODMedNVA.ResetOnMedChange;
begin
  cboDosage.Items.Clear;
  chkPRN.Checked := False;
  cboSchedule.ItemIndex := -1;
  cboSchedule.Text := '';  // leave items intact
  memComment.Lines.Clear;
  cboDosage.Text := '';
  cboRoute.Items.Clear;
  cboRoute.Text := '';
  cboRoute.Hint := cboRoute.Text;
  cboIndication.Text := '';
  ResetControl(cboSchedule);        /// cla 2/26/04; carried forward by WEF 3/14/19 from inpatient complex orders
  Responses.Clear;
end;

procedure TfrmODMedNVA.ResetOnTabChange;
var
  i: Integer;
begin
  with grdDoses do
    for i := 1 to Pred(RowCount) do
      Rows[i].Clear;
  Responses.Clear('STRENGTH');
  Responses.Clear('NAME');
  Responses.Clear('INSTR');
  Responses.Clear('DOSE');
  Responses.Clear('DRUG');
  Responses.Clear('DAYS');
  Responses.Clear('ROUTE');
  Responses.Clear('SCHEDULE');
  Responses.Clear('START', 1);
  Responses.Clear('SIG');
  Responses.Clear('SUPPLY');
  Responses.Clear('QTY');
  cboDosage.ItemIndex := -1;
  cboDosage.Text := '';
  cboRoute.ItemIndex := -1;
  cboRoute.Text := '';
  cboSchedule.ItemIndex := -1;
  cboSchedule.Text := ''; // leave items intact
  if FAdminTimeText <> 'Not defined for Clinic Locations' then
    lblAdminSchSetText('');

  FSmplPRNChkd := chkPRN.Checked; // GE  CQ7585; carried forward by WEF 3/14/19 from inpatient complex orders
  chkPRN.Checked := FALSE;
  FLastUnits := '';
  FLastSchedule := '';
  FLastDuration := '';
  FLastInstruct := '';
  FLastDispDrug := '';
  FDrugID := '';
end;

procedure TfrmODMedNVA.SetOnMedSelect;
var
  i,j: Integer;
  temp,x: string;
  QOPiUnChk: boolean;
  PKIEnviron: boolean;
  sl: TStrings;

begin
  // clear controls?
  cboDosage.Tag := -1;
  QOPiUnChk := False;
  PKIEnviron := False;
  if GetPKISite then PKIEnviron := True;
  with CtrlInits do
  begin
    // set up CtrlInits for orderable item
//    LoadOrderItem(OIForNVA(txtMed.Tag, FNonVADlg, IncludeOIPI, PKIEnviron));
    sl := TSTringList.Create;
    try
      SetOIForNVA(sl,txtMed.Tag, FNonVADlg, IncludeOIPI, PKIEnviron);
      LoadOrderItem(sl);
    finally
      sl.Free;
    end;
    // set up lists & initial values based on orderable item
    SetControl(txtMed,       'Medication');
    if (self.MedName <> '') then
       begin
         if (txtMed.Text <> self.MedName) then
           begin
             temp := self.MedName;
             self.MedName := txtMed.Text;
             txtMed.Text := temp;
           end
         else MedName := '';
       end;
    SetControl(cboDosage,    'Dosage');
    SetControl(cboRoute,     'Route');
    SetControl(calStart,     'START');   //cla 7-17-03; carried forward by WEF 3/14/19 from inpatient complex orders
    if cboRoute.Items.Count = 1 then cboRoute.ItemIndex := 0;
    cboRouteChange(Self);
    x := DefaultText('Schedule');
    if x <> '' then
    begin
      cboSchedule.SelectByID(x);
      cboSchedule.Text := x;
    end;
    if Length(ValueOf(FLD_QTYDISP))>10 then
    begin
    end;
    FAllDoses.Text := TextOf('AllDoses');
    FAllDrugs.Text := TextOf('Dispense');
    FGuideline.Text := TextOf('Guideline');
    case FGuideline.Count of
    0: lblGuideline.Visible := False;
    1:   begin
           lblGuideline.Caption := FGuideline[0];
           lblGuideline.Visible := TRUE;
         end;
    else begin
           lblGuideline.Caption := 'Display Restrictions/Guidelines';
           lblGuideline.Visible := TRUE;
         end;
    end;

      DEASig := '';
      if GetPKISite then DEASig := DefaultText('DEASchedule');
      FSIGVerb := DefaultText('Verb');
      if Length(FSIGVerb) = 0 then FSIGVerb := TX_TAKE;
      FSIGPrep := DefaultText('Preposition');
      for j := 0 to Responses.TheList.Count - 1 do
      begin
        if (TResponse(Responses.theList[j]).PromptID = 'PI') and (TResponse(Responses.theList[j]).EValue = ' ') then
          QOPiUnChk := True;
      end;
      FPtInstruct := TextOf('PtInstr');
      for i := 1 to Length(FPtInstruct) do if Ord(FPtInstruct[i]) < 32 then FPtInstruct[i] := ' ';
      FPtInstruct := TrimRight(FPtInstruct);
      if Length(FPtInstruct) > 0 then
      begin
        if FShrinked then
        begin
           FShrinked := False;
        end;
        if QOPiUnChk then
       end else
      begin
        if not FShrinked then
        begin
           FShrinked := True;
        end;
      end;
 //   end;
    pnlMessage.TabOrder := cboDosage.TabOrder + 1;

    FIndications.Load;
    cboIndication.Items.Clear;
    cboIndication.Items.Text := FIndications.GetIndicationList;
  end;
end;

procedure TfrmODMedNVA.SetOnQuickOrder;
var
  AResponse: TResponse;
  X, LocRoute, TempSch, DispGrp: string;
  i, j, k, l, NumRows, DispDrug: Integer;
  InstanceNames: array of String;
begin
  // txtMed already set by SetOnMedSelect
  with Responses do
  begin
    SetControl(memComment, 'COMMENT', 1);
    SetControl(calStart, 'START', 1);
    SetControl(cboIndication, 'INDICATION', 1);

    SetStartDate(EValueFor('START', 1));
    SetStatements(EValueFor('STATEMENTS', 1));

    NumRows := TotalRows;
    if (NumRows > 1) or ((NumRows = 1) and (Responses.InstanceCount('DAYS') > 0))
    then // complex dose; carried forward by WEF 3/14/19 from inpatient complex orders
    begin
      SetLength(InstanceNames, 5);
      InstanceNames[0] := 'INSTR';
      InstanceNames[1] := 'ROUTE';
      InstanceNames[2] := 'SCHEDULE';
      InstanceNames[3] := 'DAYS';
      InstanceNames[4] := 'CONJ';
      grdDoses.RowCount := HigherOf(NumRows + 2, 4);
      i := 0;
      for X in InstanceNames do
      begin
        l := Responses.NextInstance(X, 0);
        if i = 0 then
        begin
          i := l;
        end
        else if l > 0 then
        begin
          i := LowerOf(i, Responses.NextInstance(X, 0));
        end
      end;
      while i > 0 do
      begin
        if IValueFor('INSTR', i) <> '' then
        begin
          SetDosage(IValueFor('INSTR', i));
          with cboDosage do
            // agp change QO code to populate the Grid with the same fields after selection CQ 15933
            // if ItemIndex > -1 then x := Text + TAB + Items[ItemIndex]
            if ItemIndex > -1 then
              X := Piece(Text, TAB, 1) + TAB + Items[ItemIndex]
            else
              X := IValueFor('INSTR', i);
          // AGP Change 26.41 for CQ 9102 PSI-05-015 affect copy and edit functionality; carried forward by WEF 3/14/19 from inpatient complex orders
        end
        else
          X := '';
        grdDoses.Cells[COL_DOSAGE, i] := X;
        SetControl(cboRoute, 'ROUTE', i);
        with cboRoute do
          if ItemIndex > -1 then
            X := Text + TAB + Items[ItemIndex]
          else
            X := Text;
        grdDoses.Cells[COL_ROUTE, i] := X;
        SetSchedule(Uppercase(IValueFor('SCHEDULE', i)));
        if (cboSchedule.Text = '') and (FIsQuickOrder) and (NSSchedule = TRUE)
        then
          cboSchedule.ItemIndex := -1;
        X := cboSchedule.Text;
        if chkPRN.Checked then
          X := X + ' PRN';
        with cboSchedule do
          if ItemIndex > -1 then
            X := X + TAB + Items[ItemIndex];
        grdDoses.Cells[COL_SCHEDULE, i] := X;
        if chkPRN.Checked = TRUE then
          grdDoses.Cells[COL_CHKXPRN, i] := '1';
        grdDoses.Cells[COL_DURATION, i] := IValueFor('DAYS', i);
        chkPRN.Checked := FALSE;
        if IValueFor('CONJ', i) = 'A' then
          X := 'AND'
        else if IValueFor('CONJ', i) = 'T' then
          X := 'THEN'
        else if IValueFor('CONJ', i) = 'X' then
          X := 'EXCEPT'
        else
          X := '';
        grdDoses.Cells[COL_SEQUENCE, i] := X;
        k := 0;
        for X in InstanceNames do
        begin
          j := Responses.NextInstance(X, i);
          if j > 0 then
          begin
            if k > 0 then
            begin
              k := LowerOf(j, k);
            end
            else if k = 0 then
            begin
              k := j;
            end;
          end;
        end;
        i := k;
      end; { while }
    end
    else // single dose
    begin
      if FIsQuickOrder then
      begin
        FQODosage := IValueFor('INSTR', 1);
        SetDosage(FQODosage);
        TempSch := cboSchedule.Text;
      end
      else
        SetDosage(IValueFor('INSTR', 1));
      SetControl(cboDosage, 'DOSAGE', 1); // CQ: HDS00007776
      SetControl(cboRoute, 'ROUTE', 1); // AGP ADDED ROUTE FOR CQ 11252
      SetSchedule(IValueFor('SCHEDULE', 1));
      if (cboSchedule.Text = '') and FIsQuickOrder then
      begin
        cboSchedule.SelectByID(TempSch);
        cboSchedule.Text := TempSch;
      end;
      DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID), 0);
      if DispDrug > 0 then
        X := QuantityMessage(DispDrug)
      else
        X := '';
      if FIsQuickOrder then
      begin
        if not QOHasRouteDefined(Responses.QuickOrder) then
        begin
          LocRoute := GetPickupForLocation(IntToStr(Encounter.Location));
        end;
      end;
      AResponse := Responses.FindResponseByName('SC', 1);
      DispGrp := NameOfDGroup(Responses.DisplayGroup);
      if (AResponse = nil) or
        ((StrToIntDef(Piece(Responses.CopyOrder, ';', 1), 0) > 0) and
        AnsiSameText('Out. Meds', DispGrp)) then
      begin
        LocRoute := GetPickupForLocation(IntToStr(Encounter.Location));
      end;

    end;
  end; { with }
  if fInptDlg then
  begin
    X := ValueOfResponse(FLD_SCHEDULE, 1);
    if Length(X) > 0 then
      UpdateStartExpires(X);
  end;
end;

procedure TfrmODMedNVA.ShowMedSelect;
begin
  txtMed.SelStart := Length(txtMed.Text);
  ChangeDelayed;  // synch the listboxes with display
  pnlFields.Enabled := False;
  pnlFields.Visible := False;
  pnlMeds.Enabled   := True;
  pnlMeds.Visible   := True;
  pnlMeds.Width := grdDoses.Width;
  pnlMeds.Height := pnlFields.Height;
  btnSelect.Caption := 'OK';
  btnSelect.Top     := cmdAccept.Top;
  btnSelect.Anchors := [akRight, akBottom];
  btnSelect.BringToFront;
  cmdAccept.Visible := False;
  cmdAccept.Default := False;
  btnSelect.Default := True;
  btnSelect.TabOrder := cmdAccept.TabOrder;
  cmdAccept.TabStop := False;
  txtMed.Width := grdDoses.Width;
  txtMed.Font.Color := clWindowText;
  txtMed.Color      := clWindow;
  txtMed.ReadOnly   := False;
  txtMed.SelectAll;
  txtMed.SetFocus;
  FDrugID := '';
end;

procedure TfrmODMedNVA.ShowMedFields;
var
  NumRows: Integer;
begin
  pnlMeds.Enabled   := False;
  pnlMeds.Visible   := False;
  pnlFields.Enabled := True;
  pnlFields.Visible := True;
  btnSelect.Caption := 'Change';
  btnSelect.Top     := txtMed.Top;
  btnSelect.Anchors := [akRight, akTop];
  btnSelect.Default := False;
  cmdAccept.Visible := True;
  cmdAccept.Default := False;
  btnSelect.TabOrder := txtMed.TabOrder + 1;
  cmdAccept.TabStop := True;
  txtMed.Width      := memOrder.Width;
  txtMed.Font.Color := clInfoText;
  txtMed.Color      := clInfoBk;
  txtMed.ReadOnly   := True;
  NumRows := Responses.TotalRows;
  if (NumRows > 1) or ((NumRows = 1) and (Responses.InstanceCount('DAYS') > 0))
  then
  begin
    ShowControlsComplex
  end
  else
  begin
    ShowControlsSimple;
  end;
end;

procedure TfrmODMedNVA.ShowControlsSimple;
begin
  tabDose.TabIndex := TI_DOSE;
  cboDosage.Visible := True;
  lblRoute.Visible := True;
  cboRoute.Visible := True;
  lblSchedule.Visible := True;
  cboSchedule.Visible := True;
  chkPRN.Visible := True;
  ActiveControl := cboDosage;
 grdDoses.Visible := FALSE;
  btnXInsert.Visible := FALSE;
  btnXRemove.Visible := FALSE;

  if fInptDlg = TRUE then
    lblAdminSch.Visible := TRUE
  else
    lblAdminSch.Visible := FALSE;
end;

procedure TfrmODMedNVA.SetDosage(const x: string);
var
  i, DoseIndex: Integer;
begin
  DoseIndex := -1;
  with cboDosage do
  begin
    ItemIndex := -1;
    for i := 0 to Pred(Items.Count) do
      if UpperCase(Piece(Items[i], U, 5)) = UpperCase(x) then
      begin
        DoseIndex := i;
        Break;
      end;
    if DoseIndex < 0 then Text := x else ItemIndex := DoseIndex;
  end;
end;

procedure TfrmODMedNVA.SetStatements(x: string);
var
i,stmtLen: integer;
stmt: string;
hldStr, matchStmt: string;
stmtList: TStringList;
begin
   stmt := x;
   stmtLen := Length(stmt);
   stmtList := TStringList.Create;
   stmtList.Clear;
   for i := 1 to stmtLen do
   if((stmt[i] <> NVA_CR) and (stmt[i] <> NVA_LF)) then
      hldStr := hldStr + stmt[i]
   else
      hldStr := hldStr + '^';
   hldStr := hldStr + '^';  //  end line with a '^' for piece.

   //  Load List of statements.
   stmtList.Add(Piece(hldStr,U,1));
   stmtList.Add(Piece(hldStr,U,3));
   stmtList.Add(Piece(hldStr,U,5));
   stmtList.Add(Piece(hldStr,U,7));

   for i := 0 to lbStatements.count-1 do
   begin
      matchStmt := lbStatements.Items.Strings[i];
      if SearchStatements(stmtList,matchStmt) then
         lbStatements.Checked[i] := True;
   end;

end;

function TfrmODMedNVA.SearchStatements(StatementList: TStringList; Statement: string): Boolean;
var
i : integer;
x: string;
begin

    Result := FALSE;
    for i := 0 to StatementList.Count-1 do
    begin
       x := StatementList.Strings[i];
       if Statement = Trim(StatementList.Strings[i]) then
       begin
           Result := TRUE;
           Break;
       end;
    end;
end;

procedure TfrmODMedNVA.SetStartDate(const x: string);
begin
     calStart.Text := x;
end;

procedure TfrmODMedNVA.SetSchedule(const x: string);
var
  NonPRNPart: string;
begin

  cboSchedule.ItemIndex := -1;
  if Pos('PRN', x) > 0 then
  begin
    NonPRNPart := Trim(Copy(x, 1, Pos('PRN', x) - 1));
    cboSchedule.SelectByID(NonPRNPart);
    if cboSchedule.ItemIndex < 0 then
    begin
      if NSSchedule then
      begin
        chkPRN.Checked := False;
        cboSchedule.Text := '';
      end else
      begin
        chkPRN.Checked := True;
        cboSchedule.Items.Add(NonPRNPart);
        cboSchedule.Text := NonPRNPart;
      end;
    end else
      chkPRN.Checked := True;
  end else
  begin
    chkPRN.Checked := False;
    cboSchedule.SelectByID(x);
    if cboSchedule.ItemIndex < 0 then
    begin
      if NSSchedule then
      begin
        cboSchedule.Text := '';
      end
      else
      begin
        cboSchedule.Items.Add(x);
        cboSchedule.Text := x;
        cboSchedule.SelectByID(x);
      end;
    end;
  end;
end;

{ Medication edit --------------------------------------------------------------------------- }

procedure TfrmODMedNVA.tabDoseChange(Sender: TObject);
var
  tmpAdmin, X: string;
  reset: Integer;

begin
  inherited;
  reset := 0;
  // AGP change for CQ 6521 added warning message; carried forward by WEF 3/14/19 from inpatient complex orders
  // AGP Change for CQ 7508 added tab information
  // GE  Change warning message functionality show only   cq 7590
  // when tab changes from complex to simple.
  // AGP Change for CQ 7834 and 7832 change text and added check to see if some values have been completed in row 1
  if (tabDose.TabIndex = 0) and ((ValFor(COL_DOSAGE, 1) <> '') or
    (ValFor(COL_SCHEDULE, 1) <> '') or (ValFor(COL_DURATION, 1) <> '') or
    (ValFor(COL_SEQUENCE, 1) <> '')) then
  begin
    Text := 'By switching to the Dosage Tab, ';
    if (InfoBox(Text +
      'you will lose all data on this screen. Click "OK" to continue or "Cancel"',
      'Warning', MB_OKCANCEL) = IDCANCEL) then
    begin
      if tabDose.TabIndex = 1 then
        tabDose.TabIndex := 0
      else
        tabDose.TabIndex := 1;
      reset := 1;
    end;
  end;

  case tabDose.TabIndex of
  TI_DOSE:    begin
                // clean up responses?
                ShowControlsSimple;
                ControlChange(Self);
              end;
  TI_RATE:    begin
                // for future use...
              end;
    TI_COMPLEX: //; carried forward by WEF 3/14/19 from inpatient complex orders
      begin
        FSuppressMsg := FOrigiMsgDisp;
        if (reset = 1) then
          Exit;
        (* AGP Change admin wrap 27.73
          tmpAdmin := Piece(self.lblAdminSch.text, ':', 2);
          tmpAdmin := Copy(tmpAdmin,2,Length(tmpAdmin)); *)
        tmpAdmin := lblAdminSchGetText;
        if FAdminTimeText <> '' then
        begin
          tmpAdmin := FAdminTimeText;
          if FAdminTimeText <> 'Not defined for Clinic Locations' then
            self.lblAdminSch.Visible := FALSE;
        end;
        ShowControlsComplex;
        ResetOnTabChange;
        txtNSS.Left := grdDoses.Left + grdDoses.ColWidths[0] +
          grdDoses.ColWidths[1] + grdDoses.ColWidths[2] + 3;
        txtNSS.Visible := FALSE;
        X := cboXDosage.Text + TAB;
        if LeftStr(X, 1) = '.' then
          X := '';
        with cboXDosage do
          if ItemIndex > -1 then
            X := X + Items[ItemIndex];
        grdDoses.Cells[COL_DOSAGE, 1] := X;
        X := cboXRoute.Text + TAB;
        with cboXRoute do
          if ItemIndex > -1 then
            X := X + Items[ItemIndex];
        grdDoses.Cells[COL_ROUTE, 1] := X;
        X := cboXSchedule.Text + TAB;
        with cboXSchedule do
          if ItemIndex > -1 then
            X := X + Items[ItemIndex];
        grdDoses.Cells[COL_SCHEDULE, 1] := X;
        // AGP Change 27.1 handle PRN not showing in schedule panel if a dose is not selected.; carried forward by WEF 3/14/19 from inpatient complex orders
        if FSmplPRNChkd then
        begin
          pnlXSchedule.Tag := 1;
          self.chkXPRN.Checked := TRUE;
        end;
        if fInptDlg then
          UpdateStartExpires(ValFor(VAL_SCHEDULE, 1));
        ControlChange(self);
      end; { TI_COMPLEX }
  end; { case }
  if ScreenReaderSystemActive then
    GetScreenReader.Speak(tabDose.Tabs[tabDose.TabIndex] + ' tab');
end;

procedure TfrmODMedNVA.lblGuidelineClick(Sender: TObject);
var
  TextStrings: TStringList;
begin
  inherited;
  TextStrings := TStringList.Create;
  try
    TextStrings.Text := FGuideline.Text;
    ReportBox(TextStrings, TC_GUIDELINE, TRUE);
  finally
    TextStrings.Free;
  end;
end;

{ cboDosage ------------------------------------- }

procedure TfrmODMedNVA.CheckFormAltDose(DispDrug: Integer);
var
  OI: Integer;
  OIName: string;
begin
  if FAltChecked or (DispDrug = 0) then Exit;
  OI := txtMed.Tag;
  OIName := txtMed.Text;
  CheckFormularyDose(DispDrug, OI, OIName, FNonVADlg);
  if OI <> txtMed.Tag then
  begin
    ResetOnMedChange;
    txtMed.Tag  := OI;
    txtMed.Text := OIName;
    SetOnMedSelect;
  end;
end;

procedure TfrmODMedNVA.cboDosageClick(Sender: TObject);
var
  DispDrug: Integer;
begin
  inherited;
UpdateRelated(False);
  DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID), 0);
  if cboDosage.Text = '' then    //cla 3/18/04; carried forward by WEF 3/14/19 from inpatient complex orders
  begin
    DispDrug := 0;
    cboDosage.ItemIndex := -1;
  end;
  {  hds8084
  if DispDrug > 0 then
  begin
    if not FSuppressMsg then begin
      pnlMessage.TabOrder := cboDosage.TabOrder + 1;
      DispOrderMessage(DispenseMessage(DispDrug));
    end;
    x := QuantityMessage(DispDrug);
  end
  else x := '';
  }
  with cboDosage do
    if (ItemIndex > -1) and (Piece(Items[ItemIndex], U, 3) = 'NF')
      then CheckFormAltDose(DispDrug);
end;

procedure TfrmODMedNVA.cboDosageChange(Sender: TObject);
// DRM - 10797688FY16/529126 - 6/27/2017 - strip CR/LF from dosage text; carried forward by WEF 3/14/19 from inpatient complex orders
var
  dosageText: string;
// DRM - 10797688FY16/529126 ---
begin
  inherited;
  // DRM - 10797688FY16/529126 - 6/27/2017 - strip CR/LF from dosage text; carried forward by WEF 3/14/19 from inpatient complex orders
  if cboDosage.Text <> '' then
  begin
    dosageText := cboDosage.Text;
    if (Pos(NVA_CR, dosageText) > 0) or (Pos(NVA_LF, dosageText) > 0) then
    begin
      dosageText := StringReplace(dosageText, NVA_CR, '', [rfReplaceAll]);
      dosageText := StringReplace(dosageText, NVA_LF, '', [rfReplaceAll]);
      cboDosage.Text := dosageText;
    end;
  end;
  // DRM - 10797688FY16/529126 ---; carried forward by WEF 3/14/19 from inpatient complex orders
  UpdateRelated;
end;

procedure TfrmODMedNVA.cboDosageExit(Sender: TObject);
begin
  inherited;
  if ActiveControl = memMessage then
  begin
    memMessage.SendToBack;
    PnlMessage.Visible := False;
    Exit;
  end;
  if ActiveControl = memComment then
  begin
   if PnlMessage.Visible = true then
   begin
     memMessage.SendToBack;
     PnlMessage.Visible := False;
   end;
  end
  else if (ActiveControl <> btnSelect) and (ActiveControl <> memComment) then
  begin
   if PnlMessage.Visible = true then
   begin
     memMessage.SendToBack;
     PnlMessage.Visible := False;
   end;
   cboDosageClick(Self);
  end;
end;

procedure TfrmODMedNVA.cboDosageKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboDosage.Text = '') then cboDosage.ItemIndex := -1;
end;

procedure TfrmODMedNVA.cboIndicationChange(Sender: TObject);
begin
  inherited;
  if Changing then
    Exit;
  if not Showing then
    Exit;

  ControlChange(Self);
end;

{ cboRoute -------------------------------------- }

procedure TfrmODMedNVA.cboRouteChange(Sender: TObject);
begin
  inherited;
  with cboRoute do
    if ItemIndex > -1 then
    begin
      if Piece(Items[ItemIndex], U, 5) = '1'
        then tabDose.Tabs[0] := 'Dosage / Rate'
        else tabDose.Tabs[0] := 'Dosage';
    end;
  cboDosage.Caption := tabDose.Tabs[0];
  if Sender <> Self then ControlChange(Sender);
end;



procedure TfrmODMedNVA.cboRouteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboRoute.Text = '') then cboRoute.ItemIndex := -1;
end;

{ cboSchedule ----------------------------------- }

procedure TfrmODMedNVA.cboScheduleClick(Sender: TObject);
begin
  inherited;
  UpdateRelated(False);
end;

procedure TfrmODMedNVA.cboScheduleChange(Sender: TObject);
begin
  inherited;
  UpdateRelated;
end;


procedure TfrmODMedNVA.cboScheduleKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboSchedule.Text = '') then cboSchedule.ItemIndex := -1;
end;

{ values changing }

function TfrmODMedNVA.OutpatientSig: string;
var
  Dose, Route, Schedule, Duration, X: string;
  i: Integer;

begin
  case tabDose.TabIndex of
  TI_DOSE:
    begin
      if ValueOf(FLD_TOTALDOSE) = ''
        then Dose := ValueOf(FLD_LOCALDOSE)
        else Dose := ValueOf(FLD_UNITNOUN);
      CheckDecimal(Dose);
      Route := ValueOf(FLD_ROUTE_EX);
      if (Length(Route) > 0) and (Length(FSigPrep) > 0) then Route := FSigPrep + ' ' + Route;
      if Length(Route) = 0 then Route := ValueOf(FLD_ROUTE_NM);
      Schedule := ValueOf(FLD_SCHED_EX);
      if Length(Schedule) = 0 then Schedule := ValueOf(FLD_SCHEDULE);
      Result := FSIGVerb + ' ' + Dose + ' ' + Route + ' ' + Schedule;
    end;
    TI_COMPLEX: //; carried forward by WEF 3/14/19 from inpatient complex orders
      begin
        with grdDoses do
          for i := 1 to Pred(RowCount) do
          begin
            if Length(ValueOf(FLD_LOCALDOSE, i)) = 0 then
              Continue;
            if FDrugID = '' then
            begin
              Dose := ValueOf(FLD_DOSETEXT, i);
              CheckDecimal(Dose);
            end
            else
            begin
              if ValueOf(FLD_TOTALDOSE, i) = '' then
                Dose := ValueOf(FLD_LOCALDOSE, i)
              else
                Dose := ValueOf(FLD_UNITNOUN, i);
              CheckDecimal(Dose);
            end;
            Route := ValueOf(FLD_ROUTE_EX, i);
            if (Length(Route) > 0) and (Length(FSIGPrep) > 0) then
              Route := FSIGPrep + ' ' + Route;
            if Length(Route) = 0 then
              Route := ValueOf(FLD_ROUTE_NM, i);
            Schedule := ValueOf(FLD_SCHED_EX, i);
            // if Length(Schedule) = 0 then Schedule := ValueOf(FLD_SCHEDULE, i);
            if Length(Schedule) = 0 then
            begin
              Schedule := ValueOf(FLD_SCHEDULE);
              if RightStr(Schedule, 3) = 'PRN' then
              begin
                Schedule := Copy(Schedule, 1, Length(Schedule) - 3);
                // Remove the Trailing PRN
                if (RightStr(Schedule, 1) = ' ') or (RightStr(Schedule, 1) = '-')
                then
                  Schedule := Copy(Schedule, 1, Length(Schedule) - 1);
                Schedule := Schedule + ' AS NEEDED'
              end;
            end;
            Duration := ValueOf(FLD_DURATION, i);
            if Length(Duration) > 0 then
              Duration := 'FOR ' + Duration;
            X := FSIGVerb + ' ' + Dose + ' ' + Route + ' ' + Schedule + ' '
              + Duration;
            if i > 1 then
              Result := Result + ' ' + ValueOf(FLD_SEQUENCE, i - 1) + ' ' + X
            else
              Result := X;
          end; { with grdDoses }
      end; { TI__COMPLEX }
  end; { case }
end;

function TfrmODMedNVA.ConstructedDoseFields(const ADose: string; PrependName: Boolean = FALSE): string;
var
  i, DrugIndex: Integer;
  UnitsPerDose, Strength: Extended;
  Units, Noun, AName: string;
begin
  DrugIndex := -1;
  for i := 0 to Pred(FAllDrugs.Count) do
    if AnsiSameText(Piece(FAllDrugs[i], U, 1), FDrugID) then
    begin
      DrugIndex := i;
      Break;
    end;
  Strength := StrToFloatDef(Piece(FAllDrugs[DrugIndex], U, 2), 0);
  Units    := Piece(FAllDrugs[DrugIndex], U, 3);
  AName    := Piece(FAllDrugs[DrugIndex], U, 4);
  if FAllDoses.Count > 0
    then Noun := Piece(Piece(FAllDoses[0], U, 3), '&', 4)
    else Noun := '';
  if Strength > 0
    then UnitsPerDose := ExtractFloat(ADose) / Strength
    else UnitsPerDose := 0;
  if (UnitsPerDose > 1) and (Noun <> '') and (CharAt(Noun, Length(Noun)) <> 'S')
    then Noun := Noun + 'S';
  Result := FloatToStr(ExtractFloat(ADose)) + '&' + Units + '&' + FloatToStr(UnitsPerDose)
            + '&' + Noun + '&' + ADose + '&' + FDrugID + '&' + FloatToStr(Strength) + '&'
            + Units;
  if PrependName then Result := AName + U + FloatToStr(Strength) + Units + U + U +
                                Result + U + ADose;
  Result := UpperCase(Result);
end;

function TfrmODMedNVA.FindDoseFields(const Drug, ADose: string): string;
var
  i: Integer;
  x: string;
begin
  Result := '';
  x := ADose + U + Drug + U;
  for i := 0 to Pred(FAllDoses.Count) do
  begin
    if AnsiSameText(x, Copy(FAllDoses[i], 1, Length(x))) then
    begin
      Result := Piece(FAllDoses[i], U, 3);
      Break;
    end;
  end;
end;

function TfrmODMedNVA.FindCommonDrug(DoseList: TStringList): string;
// DoseList[n] = DoseText ^ Dispense Drug Pointer
var
  i, j, UnitIndex: Integer;
  DrugStrength, DoseValue, UnitsPerDose: Extended;
  DrugOK, PossibleDoses, SplitTab: Boolean;
  ADrug, ADose, DoseFields, DoseUnits, DrugUnits: string;
  FoundDrugs: TStringList;

  procedure SaveDrug(const ADrug: string; UnitsPerDose: Extended);
  var
    i, DrugIndex: Integer;
    CurUnits: Extended;
  begin
    DrugIndex := -1;
    for i := 0 to Pred(FoundDrugs.Count) do
      if AnsiSameText(Piece(FoundDrugs[i], U, 1), ADrug) then DrugIndex := i;
    if DrugIndex = -1 then FoundDrugs.Add(ADrug + U + FloatToStr(UnitsPerDose)) else
    begin
      CurUnits := StrToFloatDef(Piece(FoundDrugs[DrugIndex], U, 2), 0);
      if UnitsPerDose > CurUnits
        then FoundDrugs[DrugIndex] := ADrug + U + FloatToStr(UnitsPerDose);
    end;
  end;

  procedure KillDrug(const ADrug: string);
  var
    i, DrugIndex: Integer;
  begin
    DrugIndex := -1;
    for i := 0 to Pred(FoundDrugs.Count) do
      if AnsiSameText(Piece(FoundDrugs[i], U, 1), ADrug) then DrugIndex := i;
    if DrugIndex > -1 then FoundDrugs.Delete(DrugIndex);
  end;

begin
  Result := '';
  if FInptDlg then                                // inpatient dialog
  begin
    DrugOK := True;
    for i := 0 to Pred(DoseList.Count) do
    begin
      ADrug := Piece(DoseList[i], U, 2);
      if ADrug = '' then DrugOK := False;
      if Result = '' then Result := ADrug;
      if not AnsiSameText(ADrug, Result) then DrugOK := False;
      if not DrugOK then Break;
    end;

    if not DrugOK then Result :='';
  end else                                        // outpatient dialog
  begin
    // check the dose combinations for each dispense drug
    FoundDrugs := TStringList.Create;
    try
      if FAllDoses.Count > 0
        then PossibleDoses := Length(Piece(Piece(FAllDoses[0], U, 3), '&', 1)) > 0
        else PossibleDoses := False;
      for i := 0 to Pred(FAllDrugs.Count) do
      begin
        ADrug := Piece(FAllDrugs[i], U, 1);
        DrugOK := True;
        DrugStrength := StrToFloatDef(Piece(FAllDrugs[i], U, 2), 0);
        DrugUnits := Piece(FAllDrugs[i], U, 3);
        SplitTab := Piece(FAllDrugs[i], U, 5) = '1';
        for j := 0 to Pred(DoseList.Count) do
        begin
          ADose:= Piece(DoseList[j], U, 1);
          DoseFields := FindDoseFields(ADrug, ADose);  // get the idnode for the dose/drug combination
          if not PossibleDoses then
          begin
            if DoseFields = '' then DrugOK := False else SaveDrug(ADrug, 0);
          end else
          begin
            DoseValue := StrToFloatDef(Piece(DoseFields, '&', 1), 0);
            if DoseValue = 0 then DoseValue := ExtractFloat(ADose);
            UnitsPerDose := DoseValue / DrugStrength;
            if (Frac(UnitsPerDose) = 0) or (SplitTab and (Frac(UnitsPerDose) = 0.5))
              then SaveDrug(ADrug, UnitsPerDose)
              else DrugOK := False;
            // make sure this dose is using the same units as the drug
            if DoseFields = '' then
            begin
              for UnitIndex := 1 to Length(ADose) do
                if not CharInSet(ADose[UnitIndex], ['0'..'9','.']) then Break;
              DoseUnits := Copy(ADose, UnitIndex, Length(ADose));
            end
            else DoseUnits := Piece(DoseFields, '&', 2);
            if not AnsiSameText(DoseUnits, DrugUnits) then DrugOK := False;
          end;
          if not DrugOK then
          begin
            KillDrug(ADrug);
            Break;
          end; {if not DrugOK}
        end; {with..for j}
      end; {for i}
      if FoundDrugs.Count > 0 then
      begin
        if not PossibleDoses then Result := Piece(FoundDrugs[0], U, 1) else
        begin
          UnitsPerDose := 99999999;
          for i := 0 to Pred(FoundDrugs.Count) do
          begin
            if StrToFloatDef(Piece(FoundDrugs[i], U, 2), 99999999) < UnitsPerDose then
            begin
              Result := Piece(FoundDrugs[i], U, 1);
              UnitsPerDose := StrToFloatDef(Piece(FoundDrugs[i], U, 2), 99999999);
            end; {if StrToFloatDef}
          end; {for i..FoundDrugs}
        end; {if not..else PossibleDoses}
      end; {if FoundDrugs}
    finally
      FoundDrugs.Free;
    end; {try}
  end; {if..else FInptDlg}
end; {FindCommonDrug}

procedure TfrmODMedNVA.ControlChange(Sender: TObject);
var
  x,ADose,AUnit,ADosageText: string;
  i, LastDose: Integer;
  DoseList: TStringList;

begin
  inherited;
  if csLoading in ComponentState then Exit;       // to prevent error caused by txtRefills
  if Changing then Exit;
  if txtMed.Tag = 0 then Exit;
  ADose := '';
  AUnit := '';
  ADosageText := '';
  FUpdated := FALSE;
  Responses.Clear;
  if self.MedName = '' then Responses.Update('ORDERABLE',  1, IntToStr(txtMed.Tag), txtMed.Text)
  else Responses.Update('ORDERABLE',  1, IntToStr(txtMed.Tag), self.MedName);
  DoseList := TStringList.Create;
  case tabDose.TabIndex of
  TI_DOSE:
    begin
      if (cboDosage.ItemIndex < 0) and (Length(cboDosage.Text) > 0) then
      begin
        // try to resolve freetext dose and add it as a new item to the combobox
        ADosageText := cboDosage.Text;
        ADose := Piece(ADosageText,' ',1);
        Delete(ADosageText,1,Length(ADose)+1);
        ADosageText := ADose + Trim(ADosageText);
        DoseList.Add(ADosageText);
        FDrugID := FindCommonDrug(DoseList);
        if FDrugID <> '' then
        begin
          if ExtractFloat(cboDosage.Text) > 0 then
          begin
            x := ConstructedDoseFields(cboDosage.Text, TRUE);
            FDrugID := '';
            with cboDosage do ItemIndex := cboDosage.Items.Add(x);
          end;
        end;
      end;
      x := ValueOf(FLD_DOSETEXT);    Responses.Update('INSTR',    1, x,  x);
      x := ValueOf(FLD_DRUG_ID);     Responses.Update('DRUG',     1, x, '');
      x := ValueOf(FLD_DOSEFLDS);    Responses.Update('DOSE',     1, x, '');
      x := ValueOf(FLD_STRENGTH);
      // if outpt or inpt order with no total dose (i.e., topical)
      if (not FInptDlg) or (ValueOf(FLD_TOTALDOSE) = '')
                                then Responses.Update('STRENGTH', 1, x,  x);
      // if no strength for dosage, use dispense drug name
      if Length(x) = 0 then
      begin
        x := ValueOf(FLD_DRUG_NM);
        if Length(x) > 0        then Responses.Update('NAME',     1, x,  x);
      end;
      x := ValueOf(FLD_ROUTE_AB);
      if Length(x) = 0 then x := ValueOf(FLD_ROUTE_NM);
      if Length(ValueOf(FLD_ROUTE_ID)) > 0
                                then Responses.Update('ROUTE',    1, ValueOf(FLD_ROUTE_ID), x)
                                else Responses.Update('ROUTE',    1, '', x);
      x := ValueOf(FLD_SCHEDULE);    Responses.Update('SCHEDULE', 1, x,  x); // CQ:7297, 7534; carried forward by WEF 3/14/19 from inpatient complex orders

      Responses.Update('STATEMENTS', 1, TX_WPTYPE, ValueOf(FLD_STATEMENTS));
    end;
    TI_COMPLEX:
      begin
        // if txtNss.Visible then txtNss.Visible := False;
        with grdDoses do
          for i := 1 to Pred(RowCount) do
          begin
            X := Piece(Piece(grdDoses.Cells[COL_DOSAGE, i], TAB, 2), U, 5);
            if X = '' then
              X := Piece(grdDoses.Cells[COL_DOSAGE, i], TAB, 1);
            if X = '' then
              Continue;
            X := X + U + Piece(Piece(grdDoses.Cells[COL_DOSAGE, i], U,
              4), '&', 6);
            DoseList.Add(X);
          end;
        FDrugID := FindCommonDrug(DoseList);
        if FDrugID <> '' then // common drug found
        begin
          X := ValueOf(FLD_STRENGTH, 1);
          if (not fInptDlg) or (ValueOf(FLD_TOTALDOSE, 1) = '') then
            Responses.Update('STRENGTH', 1, X, X);
          // if no strength, use dispense drug
          if Length(X) = 0 then
          begin
            X := ValueOf(FLD_DRUG_NM, 1);
            if Length(X) > 0 then
              Responses.Update('NAME', 1, X, X);
          end;
          Responses.Update('DRUG', 1, FDrugID, '');
        end; { if FDrugID }
        LastDose := 0;
        with grdDoses do
          for i := 1 to Pred(RowCount) do
            if Length(ValueOf(FLD_DOSETEXT, i)) > 0 then
              LastDose := i;
        with grdDoses do
          for i := 1 to Pred(RowCount) do
          begin
            if Length(ValueOf(FLD_DOSETEXT, i)) = 0 then
              Continue;
            X := ValueOf(FLD_DOSETEXT, i);
            Responses.Update('INSTR', i, X, X);
            X := ValueOf(FLD_DOSEFLDS, i);
            Responses.Update('DOSE', i, X, '');
            X := ValueOf(FLD_ROUTE_AB, i);
            if Length(X) = 0 then
              X := ValueOf(FLD_ROUTE_NM, i);
            if Length(ValueOf(FLD_ROUTE_ID, i)) > 0 then
              Responses.Update('ROUTE', i, ValueOf(FLD_ROUTE_ID, i), X)
            else
              Responses.Update('ROUTE', i, '', X);
            X := ValueOf(FLD_SCHEDULE, i);
            Responses.Update('SCHEDULE', i, X, X);
            if FSmplPRNChkd then
            // GE CQ7585  Carry PRN checked from simple to complex tab; carried forward by WEF 3/14/19 from inpatient complex orders
            begin
              pnlXSchedule.Tag := 1;
              chkXPRN.Checked := TRUE;
              // cboXScheduleClick(Self);// force onclick to fire when complex tab is entered
              FSmplPRNChkd := FALSE;
            end;
            X := ValueOf(FLD_DURATION, i);
            Responses.Update('DAYS', i, Uppercase(X), X);
            if fInptDlg then
            begin
              X := ValFor(VAL_ADMINTIME, i);
              if FAdminTimeText <> '' then
                X := '';
              if X = 'Not Defined' then
                X := '';
              Responses.Update('ADMIN', i, X, X);
              X := ValueOf(FLD_SCHED_TYP, i);
              if ValFor(VAL_CHKXPRN, i) = '1' then
                X := 'P';
              Responses.Update('SCHTYPE', i, X, X);
            end;
            X := ValueOf(FLD_SEQUENCE, i);
            if Uppercase(X) = 'THEN' then
              X := 'T'
            else if Uppercase(X) = 'AND' then
              X := 'A'
            else if Uppercase(X) = 'EXCEPT' then
              X := 'X'
            else
              X := '';
            if i = LastDose then
              X := ''; // no conjunction for last dose
            Responses.Update('CONJ', i, X, X);
          end; { with grdDoses }

          Responses.Update('STATEMENTS', 1, TX_WPTYPE, ValueOf(FLD_STATEMENTS));
      end;
  end; {case TabDose.TabIndex}
  DoseList.Free;
  Responses.Update('URGENCY',   1, ValueOf(FLD_PRIOR_ID), '');
  Responses.Update('COMMENT',   1, TX_WPTYPE, ValueOf(FLD_COMMENT));
  // INDICATIONS
  if FIndications.IsSelectedIndicationValid( cboIndication.Text ) then
    Responses.Update('INDICATION', 1, cboIndication.Text, ValueOf(FLD_INDICATIONS));

  if Length(calStart.Text) > 0 then
     Responses.Update('START', 1, calStart.Text, 'Start Date: ' + calStart.Text);  //cla 7-17-03; carried forward by WEF 3/14/19 from inpatient complex orders

 if FInptDlg then                       // inpatient orders
  begin
    Responses.Update('NOW',     1, ValueOf(FLD_NOW_ID), ValueOf(FLD_NOW_NM));
  end else
  begin
     x := OutpatientSig;                 Responses.Update('SIG',     1, TX_WPTYPE, x);
 end;
  memOrder.Text := Responses.OrderText;
end;

{ complex dose ------------------------------------------------------------------------------ }
// ; carried forward by WEF 3/14/19 from inpatient complex orders
{ General Functions - get & set cell values}
function TfrmODMedNVA.ValFor(FieldID, ARow: Integer): string;
{ Contents of grid cells  (Only the first tab piece for each cell is drawn)
  Dosage    <TAB> DosageFields
  RouteText <TAB> IEN^RouteName^Abbreviation
  Schedule  <TAB> (nothing)
  Duration  <TAB> Duration^Units }
begin
  Result := '';
  if (ARow < 1) or (ARow >= grdDoses.RowCount) then
    Exit;
  with grdDoses do
    case FieldID of
      COL_DOSAGE:
        Result := Piece(Cells[COL_DOSAGE, ARow], TAB, 1);
      COL_ROUTE:
        Result := Piece(Cells[COL_ROUTE, ARow], TAB, 1);
      COL_SCHEDULE:
        Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
      COL_DURATION:
        Result := Piece(Cells[COL_DURATION, ARow], TAB, 1);
      COL_SEQUENCE:
        Result := Piece(Cells[COL_SEQUENCE, ARow], TAB, 1);
      VAL_DOSAGE:
        Result := Piece(Cells[COL_DOSAGE, ARow], TAB, 2);
      VAL_ROUTE:
        Result := Piece(Cells[COL_ROUTE, ARow], TAB, 2);
      VAL_SCHEDULE:
        Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
      VAL_DURATION:
        Result := Piece(Cells[COL_DURATION, ARow], TAB, 1);
      VAL_ADMINTIME:
        Result := Piece(Cells[COL_ADMINTIME, ARow], TAB, 1);
      VAL_SEQUENCE:
        Result := Piece(Cells[COL_SEQUENCE, ARow], TAB, 1);
      VAL_CHKXPRN:
        Result := Cells[COL_CHKXPRN, ARow];
    end;
end;

procedure FindInCombo(const x: string; AComboBox: TORComboBox);
var
  i, Found: Integer;
begin
  with AComboBox do
  begin
    i := 0;
    Found := -1;
    while (i < Items.Count) and (Found < 0) do
    begin
      if CompareText(Copy(DisplayText[i], 1, Length(x)), x) = 0 then Found := i;
      Inc(i);
    end; {while}
    if Found > -1 then
    begin
      ItemIndex := Found;
      TResponsiveGUI.ProcessMessages;
      SelStart  := 1;
      SelLength := Length(Items[Found]);
    end else
    begin
      Text := x;
      SelStart := Length(x);
    end;
  end; {with AComboBox}
end;

procedure TfrmODMedNVA.grdDosesExit(Sender: TObject);
begin
  inherited;
  UpdateRelated(FALSE);
  RestoreDefaultButton;
  RestoreCancelButton;
end;

procedure TfrmODMedNVA.btnXInsertClick(Sender: TObject);
var
  i: Integer;
  x1, x2: string;
begin
  inherited;
  grdDoses.SetFocus; // make sure exit events for editors fire
  with grdDoses do
  begin
    if Row < 1 then
      Exit;
    x1 := grdDoses.Cells[COL_ROUTE, Row];
    x2 := grdDoses.Cells[COL_SCHEDULE, Row];
    RowCount := RowCount + 1;
    { move rows down }
    for i := Pred(RowCount) downto Succ(Row) do
      Rows[i] := Rows[i - 1];
    Rows[Row].Clear;
    Cells[COL_ROUTE, Row] := x1;
    Cells[COL_SCHEDULE, Row] := x2;
    Col := COL_DOSAGE;
  end;
  ShowEditor(COL_DOSAGE, grdDoses.Row, #0);

  DropLastSequence;
end;

procedure TfrmODMedNVA.btnXRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  grdDoses.SetFocus; // make sure exit events for editors fire
  with grdDoses do
    if (Row > 0) and (RowCount > 2) then
    begin
      { move rows up }
      for i := Row to RowCount - 2 do
        Rows[i] := Rows[i + 1];
      RowCount := RowCount - 1;
      Rows[RowCount].Clear;
    end;
  DropLastSequence;
  ControlChange(self);
end;
function TfrmODMedNVA.ValueOf(FieldID: Integer; ARow: Integer = -1): string;
var
  y: string;
  X: string;
  stmt: Integer;
{ Contents of cboDosage
    DrugName^Strength^NF^TDose&Units&U/D&Noun&LDose&Drug^DoseText^CostText^MaxRefills
  Contents of grid cells  (Only the first tab piece for each cell is drawn)
    Dosage    <TAB> DosageFields
    RouteText <TAB> IEN^RouteName^Abbreviation
    Schedule  <TAB> (nothing)
    Duration  <TAB> Duration^Units }

  // the following functions were created to get rid of a compile warning saying the
  // return value may be undefined - too much branching logic in the case statements
  // for the compiler to handle

  function GetSchedule: string;
  begin
    Result := UpperCase(cboSchedule.Text);
    if chkPRN.Checked then Result := Result + ' PRN';
    if UpperCase(Copy(Result, Length(Result) - 6, Length(Result))) = 'PRN PRN'
      then Result := Copy(Result, 1, Length(Result) - 4);
  end;

  function GetScheduleEX: string;
  begin
    Result := '';
    with cboSchedule do
      if ItemIndex > -1 then Result := Piece(Items[ItemIndex], U, 2);
    if (Length(Result) > 0) and chkPRN.Checked then Result := Result + ' AS NEEDED';
    if UpperCase(Copy(Result, Length(Result) - 18, Length(Result))) = 'AS NEEDED AS NEEDED'
      then Result := Copy(Result, 1, Length(Result) - 10);
  end;

  function GetComplexDoseSchedule: string;
  begin
    with grdDoses do
    begin
      Result := Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 1);
      if Result = '' then
        Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
      if ValFor(VAL_CHKXPRN, ARow) = '1' then
        Result := Result + ' PRN';
      if Uppercase(Copy(Result, Length(Result) - 6, Length(Result))) = 'PRN PRN'
      then
        Result := Copy(Result, 1, Length(Result) - 4);
    end;
  end;

  function GetComplexDoseScheduleEX: string;
  begin
    with grdDoses do
    begin
      (* Result := Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 2);
        if Result = '' then //Added for CQ: 7639
        begin
        Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
        if RightStr(Result,4) = ' PRN' then
        Result := Copy(Result,1,Length(Result)-4); //Remove the Trailing PRN
        end;
        if (Piece(Cells[COL_SCHEDULE, ARow], TAB, 1) <>
        Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 1)) and
        (Pos('PRN', Piece(Cells[COL_SCHEDULE, ARow], TAB, 1)) > 0)
        then Result := Result + ' AS NEEDED';
        end; *)
      Result := Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 2);
      if Result = '' then
        Result := Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 1);
      // Added for CQ: 7639
      if Result = '' then
        Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
      if RightStr(Result, 3) = 'PRN' then
      begin
        Result := Copy(Result, 1, Length(Result) - 3);
        // Remove the Trailing PRN
        if (RightStr(Result, 1) = ' ') or (RightStr(Result, 1) = '-') then
          Result := Copy(Result, 1, Length(Result) - 1);
        Result := Result + ' AS NEEDED';
      end;
      if ValFor(VAL_CHKXPRN, ARow) = '1' then
        Result := Result + ' AS NEEDED';
      if Uppercase(Copy(Result, Length(Result) - 18, Length(Result))) = 'AS NEEDED AS NEEDED'
      then
        Result := Copy(Result, 1, Length(Result) - 10);
      if Uppercase(Copy(Result, Length(Result) - 12, Length(Result))) = 'PRN AS NEEDED'
      then
      begin
        Result := Copy(Result, 1, Length(Result) - 13);
        if RightStr(Result, 1) = ' ' then
          Result := Result + 'AS NEEDED'
        else
          Result := Result + ' AS NEEDED';
      end;
    end;
  end;
begin
  Result := '';
  if ARow < 0 then                                // use single dose controls
  begin
    case FieldID of
    FLD_DOSETEXT  : with cboDosage do
                      if ItemIndex > -1 then Result := Uppercase(Piece(Items[ItemIndex], U, 5))
                                        else Result := Uppercase(Text);
    FLD_LOCALDOSE : with cboDosage do
                      if ItemIndex > -1 then Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 5)
                                        else Result := Uppercase(Text);
    FLD_STRENGTH  : with cboDosage do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 2);
    FLD_DRUG_ID   : with cboDosage do
                     if ItemIndex > -1  then Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 6);
    FLD_DRUG_NM   : with cboDosage do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 1);
    FLD_DOSEFLDS  : with cboDosage do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 4);
    FLD_TOTALDOSE : with cboDosage do
                      if ItemIndex > -1 then Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 1);
    FLD_UNITNOUN  : with cboDosage do
                      if ItemIndex > -1 then Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 3) + ' '
                                                     + Piece(Piece(Items[ItemIndex], U, 4), '&', 4);
    FLD_ROUTE_ID  : with cboRoute do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 1);
    FLD_ROUTE_NM  : with cboRoute do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 2)
                                        else Result := Text;
    FLD_ROUTE_AB  : with cboRoute do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 3);
    FLD_ROUTE_EX  : with cboRoute do
                     if ItemIndex > -1  then Result := Piece(Items[ItemIndex], U, 4);
    FLD_SCHEDULE  : begin
                      Result := GetSchedule;
                    end;
    FLD_SCHED_EX  : begin
                      Result := GetScheduleEX;
                    end;
    FLD_SCHED_TYP : with cboSchedule do
                      if ItemIndex > -1 then Result := Piece(Items[ItemIndex], U, 3);
    FLD_QTYDISP   : with cboDosage do
                      begin
                        if ItemIndex > -1 then Result := Piece(Items[ItemIndex], U, 8);
                        if (Result = '') and (Items.Count > 0) then Result := Piece(Items[0], U, 8);
                        if Result <> ''
                          then Result := 'Qty (' + Result + ')'
                          else Result := 'Quantity';
                      end;

    FLD_INDICATIONS: Result := cboIndication.Text;

    FLD_COMMENT   : Result := memComment.Text;

    FLD_START     : Result := FormatFMDateTime('mmm dd,yy',calStart.FMDateTime);

    end; {case FieldID}
  end
  else // use complex dose controls; carried forward by WEF 3/14/19 from inpatient complex orders
  begin
    if (ARow < 1) or (ARow >= grdDoses.RowCount) then
      Exit;
    if Length(FDrugID) > 0 then
      X := FieldsForDose(ARow)
    else
      X := Piece(Piece(grdDoses.Cells[COL_DOSAGE, ARow], TAB, 2), U, 4);
    with grdDoses do
      case FieldID of
        FLD_DOSETEXT:
          Result := Uppercase(Piece(Cells[COL_DOSAGE, ARow], TAB, 1));
        FLD_LOCALDOSE:
          begin
            if (Length(X) > 0) and (Length(FDrugID) > 0) then
              Result := Piece(X, '&', 5)
            else
              Result := Uppercase(Piece(Cells[COL_DOSAGE, ARow], TAB, 1));
          end;
        FLD_STRENGTH:
          Result := Piece(X, '&', 7) + Piece(X, '&', 8);
        FLD_DRUG_ID:
          Result := Piece(X, '&', 6);
        FLD_DRUG_NM:
          Result := Piece(FieldsForDrug(Piece(X, '&', 6)), U, 4);
        FLD_DOSEFLDS:
          Result := X;
        FLD_TOTALDOSE:
          Result := Piece(X, '&', 1);
        FLD_UNITNOUN:
          Result := Piece(X, '&', 3) + ' ' + Piece(X, '&', 4);
        FLD_ROUTE_ID:
          Result := Piece(Piece(Cells[COL_ROUTE, ARow], TAB, 2), U, 1);
        FLD_ROUTE_NM:
          begin
            Result := Piece(Piece(Cells[COL_ROUTE, ARow], TAB, 2), U, 2);
            if Result = '' then
              Result := Piece(Cells[COL_ROUTE, ARow], TAB, 1);
          end;
        FLD_ROUTE_AB:
          Result := Piece(Piece(Cells[COL_ROUTE, ARow], TAB, 2), U, 3);
        FLD_ROUTE_EX:
          Result := Piece(Piece(Cells[COL_ROUTE, ARow], TAB, 2), U, 4);
        FLD_SCHEDULE:
          begin
            Result := GetComplexDoseSchedule;
          end;
        FLD_SCHED_EX:
          begin
            Result := GetComplexDoseScheduleEX;
          end;
        FLD_SCHED_TYP:
          Result := Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 3);
        FLD_DURATION:
          Result := Piece(Cells[COL_DURATION, ARow], TAB, 1);
        FLD_SEQUENCE:
          Result := Piece(Cells[COL_SEQUENCE, ARow], TAB, 1);
      end; { case FieldID }
  end; { if ARow }
  if FieldID > FLD_MISC_FLDS then // still need to process 'non-sig' fields
  begin
    case FieldID of

      FLD_SUPPLY:
        Result := '0';
      FLD_QUANTITY:
        Result := '0';
      FLD_REFILLS:
        Result := '0';
      FLD_PICKUP:
        Result := '';
      FLD_PRIOR_ID:
        Result := '0';
      FLD_PRIOR_NM:
        Result := '';

      // Indications
      FLD_INDICATIONS:
        Result := cboIndication.Text;

      FLD_COMMENT:
        Result := memComment.Text;

      FLD_STATEMENTS:
        with lbStatements do
          for stmt := 0 to lbStatements.Items.Count - 1 do
            if (lbStatements.Checked[stmt]) then
            begin
              Y := #13#10 + lbStatements.Items.Strings[stmt] + '  ';
              Result := Result + Y;
            end;

    end; { case FieldID }
  end; { if FieldID }
end;

function TfrmODMedNVA.ValueOfResponse(FieldID: Integer; AnInstance: Integer = 1): string;
var
  x: string;
begin
  case FieldID of
  FLD_SCHEDULE  : Result := Responses.IValueFor('SCHEDULE', AnInstance);
  FLD_UNITNOUN  : begin
                    x := Responses.IValueFor('DOSE',   AnInstance);
                    Result := Piece(x, '&', 3) + ' ' + Piece(x, '&', 4);
                  end;
  FLD_DOSEUNIT  : begin
                    x := Responses.IValueFor('DOSE',   AnInstance);
                    Result := Piece(x, '&', 3);
                  end;
  FLD_DRUG_ID   : Result := Responses.IValueFor('DRUG',     AnInstance);
  FLD_INSTRUCT  : Result := Responses.IValueFor('INSTR',    AnInstance);
  FLD_SUPPLY    : Result := Responses.IValueFor('SUPPLY',   AnInstance);
  FLD_QUANTITY  : Result := Responses.IValueFor('QTY',      AnInstance);
  FLD_ROUTE_ID  : Result := Responses.IValueFor('ROUTE',    AnInstance);
  FLD_EXPIRE    : Result := Responses.IValueFor('DAYS',     AnInstance);
  FLD_ANDTHEN   : Result := Responses.IValueFor('CONJ',     AnInstance);
  FLD_INDICATIONS: Result := Responses.IValueFor('INDICATION',     AnInstance);
  end;
end;

procedure TfrmODMedNVA.UpdateStartExpires(const CurSchedule: string);
var
  ShowText, Duration, ASchedule: string;
  AdminTime:    TFMDateTime;
  Interval, PrnPos: Integer;
begin
  if Length(CurSchedule)=0 then Exit;
  ASchedule := Trim(CurSchedule);
  {if (Pos('^',ASchedule)=0) then  //GE  CQ7506
  begin
    PrnPos := Pos('PRN',ASchedule);
    if (PrnPos > 1) and (CharAt(ASchedule,PrnPos-1) <> ';') then
      Delete(ASchedule, PrnPos, Length(ASchedule));
  end  }
  if (Pos('^',ASchedule)>0) then
  begin
    PrnPos := Pos('PRN',ASchedule);
    if (PrnPos > 1) and (CharAt(ASchedule,PrnPos-1)=' ') then
      Delete(ASchedule, PrnPos-1, 4);
  end;
  ASchedule := Trim(ASchedule);
  if Length(ASchedule)>0 then
      LoadAdminInfo(ASchedule, txtMed.Tag, ShowText, AdminTime, Duration)
  else Exit;
  if AdminTime > 0 then
  begin
    ShowText := 'Expected First Dose: ';
    Interval := Trunc(FMDateTimeToDateTime(AdminTime) - FMDateTimeToDateTime(FMToday));
    case Interval of
    0: ShowText := ShowText + 'TODAY ' + FormatFMDateTime('(mmm dd, yy) at hh:nn', AdminTime);
    1: ShowText := ShowText + 'TOMORROW ' + FormatFMDateTime('(mmm dd, yy) at hh:nn', AdminTime);
    else ShowText := ShowText + FormatFMDateTime('mmm dd, yy at hh:nn', AdminTime);
    end;
  lblAdminTime.Caption := ShowText;
  FAdminTimeLbl := lblAdminTime.Caption;
  end
  else lblAdminTime.Caption := '';
end;

procedure TfrmODMedNVA.UpdateRelated(DelayUpdate: Boolean = TRUE);
begin
  timCheckChanges.Enabled := False;               // turn off timer
  if DelayUpdate
    then timCheckChanges.Enabled := True          // restart timer
    else timCheckChangesTimer(Self);              // otherwise call directly
end;

procedure TfrmODMedNVA.timCheckChangesTimer(Sender: TObject);
const
  UPD_NONE     = 0;
  UPD_QUANTITY = 1;
  UPD_SUPPLY   = 2;
var
  CurUnits, CurSchedule, CurInstruct, CurDispDrug, CurDuration, TmpSchedule, x, x1: string;
  CurScheduleIN, CurScheduleOut: string;
  CurQuantity, CurSupply, i, pNum, j: Integer;
 { LackQtyInfo,} SaveChanging: Boolean;
begin
  inherited;
  timCheckChanges.Enabled := False;
  ControlChange(Self);
  SaveChanging := Changing;
  Changing := TRUE;
  // don't allow Exit procedure so Changing gets reset appropriately
  CurUnits    := '';
  CurSchedule := '';
  CurDuration := '';
 // LackQtyInfo := False;
  i := Responses.NextInstance('DOSE', 0);
  while i > 0 do
  begin
    x := ValueOfResponse(FLD_DOSEUNIT,  i);
 //   if x = '' then LackQtyInfo := TRUE;  //StrToIntDef(x, 0) = 0
    CurUnits    := CurUnits   + x  + U;
    x := ValueOfResponse(FLD_SCHEDULE,  i);
 //   if Length(x) = 0         then LackQtyInfo := TRUE;
    CurScheduleOut := CurScheduleOut + x + U;
    x1 := ValueOf(FLD_SEQUENCE,i);
    if Length(x1)>0 then
    begin
      X1 := CharAt(X1,1);
      CurScheduleIn := CurScheduleIn + x1 + ';' + x + U;
    end
    else
      CurScheduleIn := CurScheduleIn + ';' + x + U;
    x := ValueOfResponse(FLD_EXPIRE,    i);
    CurDuration := CurDuration + x + '~';
    x := ValueOfResponse(FLD_ANDTHEN,   i);
    CurDuration := CurDuration + x + U;
    x := ValueOfResponse(FLD_DRUG_ID,   i);
    CurDispDrug := CurDispDrug + x + U;
    x := ValueOfResponse(FLD_INSTRUCT,  i);
    CurInstruct := CurInstruct + x + U;
    i := Responses.NextInstance('DOSE', i);
  end;

  pNum := 1;
  while Length( Piece(CurScheduleIn,U,pNum)) > 0 do
    pNum := pNum + 1;
  if Length(Piece(CurScheduleIn,U,pNum)) < 1 then
    for j := 1 to pNum - 1 do
    begin
      if j = pNum -1 then
        TmpSchedule := TmpSchedule + ';' + Piece(Piece(CurScheduleIn,U,j),';',2)
      else
        TmpSchedule := TmpSchedule + Piece(CurScheduleIn,U,j) + U
    end;
  CurScheduleIn := TmpSchedule;
  CurQuantity := StrToIntDef(ValueOfResponse(FLD_QUANTITY) ,0);
  CurSupply   := StrToIntDef(ValueOfResponse(FLD_SUPPLY)   ,0);
  if FInptDlg then
  begin
    CurSchedule := CurScheduleIn;
    if Pos('^',CurSchedule)>0 then
    begin
      if Pos('PRN',Piece(CurSchedule,'^',1))>0 then
        if lblAdminTime.Visible then
          lblAdminTime.Caption := '';
    end;
    if CurSchedule <> FLastSchedule then UpdateStartExpires(CurSchedule);
    if CharInSet(Responses.EventType, ['A','D','T','M','O']) then lblAdminTime.Visible := False;
  end;
  if not FInptDlg then
  begin
    CurSchedule := CurScheduleOut;
  end;

  FLastUnits    := CurUnits;
  FLastSchedule := CurSchedule;
  FLastDispDrug := CurDispDrug;
  FLastQuantity := CurQuantity;
  FLastSupply   := CurSupply;
  if (ActiveControl <> nil) and (ActiveControl.Parent <> cboDosage)
    then cboDosage.Text := Piece(cboDosage.Text, TAB, 1);
  Changing := SaveChanging;
  if FUpdated then ControlChange(Self);
end;

procedure TfrmODMedNVA.cmdAcceptClick(Sender: TObject);
var
  i: Integer;
begin
  // AGP Change for 26.45 PSI-04-069; carried forward by WEF 3/14/19 from inpatient complex orders
  if self.tabDose.TabIndex = 1 then
  begin
    for i := 2 to self.grdDoses.RowCount do
    begin
      if ((ValFor(COL_DOSAGE, i - 1) <> '') and (ValFor(COL_DOSAGE, i) <> ''))
        and (ValFor(COL_SEQUENCE, i - 1) = '') then
      begin
        InfoBox('To be able to complete a complex order every row except for the last row must have a conjunction defined. '
          + CRLF + CRLF + 'Verify that all rows have a conjunction defined.',
          'Sequence Error', MB_OK);
        Exit;
      end;
    end;
  end;

  ControlChange(self);
  DropLastSequence;
  cmdAccept.SetFocus;
  inherited;
end;
procedure TfrmODMedNVA.CheckDecimal(var AStr: string);
var
  Number: double;
  DUName,TabletNum,tempStr: string;
  ToWord: string;
  ie,code: integer;
begin
  ToWord := '';
  tempStr := AStr;
  TabletNum := Piece(AStr,' ',1);
  if CharAt(TabletNum,1)='.' then
  begin
    if CharInSet(CharAt(TabletNum,2), ['0','1','2','3','4','5','6','7','8','9']) then
    begin
      TabletNum := '0' + TabletNum;
      AStr := '0' + AStr;
    end;
  end;
  DUName := Piece(AStr,' ',2);
  if Pos('TABLET',upperCase(DUName))= 0 then
    Exit;
  if (Length(TabletNum)>0) and (Length(DUName)>0) then
  begin
    if CharAt(TabletNum,1) <> '0' then
    begin
      Val(TabletNum, ie, code);
      if ie = 0 then begin end;
      if code <> 0 then
        Exit;
    end;
    try
      begin
        Number := StrToFloat(TabletNum);
        if Number = 0.5 then
          ToWord := 'ONE-HALF';
        if ( Number >= 0.333 ) and  ( Number <= 0.334 ) then
          ToWord := 'ONE-THIRD';
        if Number = 0.25 then
          ToWord := 'ONE-FOURTH';
        if ( Number >= 0.66 ) and ( Number <= 0.67 ) then
          ToWord := 'TWO-THIRDS';
        if Number = 0.75 then
          ToWord := 'THREE-FOURTHS';
        if Number = 1 then
          ToWord := 'ONE';
        if Number = 2 then
          ToWord := 'TWO';
        if Number = 3 then
          ToWord := 'THREE';
        if Number = 4 then
          ToWord := 'FOUR';
        if Number = 5 then
          ToWord := 'FIVE';
        if Number = 6 then
          ToWord := 'SIX';
        if (Length(ToWord) > 0) then
           AStr :=  ToWord + ' ' + DUName;
      end
    except
      on EConvertError do AStr := tempStr;
    end;
  end;
end;

procedure TfrmODMedNVA.chkPRNClick(Sender: TObject);
var
  tempSch: string;
  PRNPos: integer;
begin
  inherited;
  {if chkPRN.Checked then lblAdminTime.Caption := ''
  else
  begin
    lblAdminTime.Caption := FAdminTimeLbl;
  end;
  ControlChange(Self);
  }
  if chkPRN.Checked then
  begin
     lblAdminTime.Caption := '';
     PrnPos := Pos('PRN',cboSchedule.Text);
     if (PrnPos < 1) then
        UpdateStartExpires(cboSchedule.Text + ' PRN');
  end
  else
  begin
    if Length(Trim(cboSchedule.Text))>0 then
    begin
      tempSch := ';'+Trim(cboSchedule.Text);
      UpdateStartExpires(tempSch);
    end;
    lblAdminTime.Caption := FAdminTimeLbl;

  end;
  ControlChange(Self);
end;

procedure TfrmODMedNVA.grdDosesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    // VK_RETURN:   //moved to form key press
    VK_RIGHT:
      begin
        if (not fInptDlg) and (self.grdDoses.Col = COL_DURATION) then
        begin
          self.grdDoses.Col := COL_SEQUENCE;
          Key := 0;
        end;
      end;
    VK_LEFT:
      begin
        if (not fInptDlg) and (self.grdDoses.Col = COL_SEQUENCE) then
        begin
          self.grdDoses.Col := COL_DURATION;
          Key := 0;
        end;
      end;
  VK_ESCAPE:
      begin
        ActiveControl := FindNextControl(Sender as TWinControl, FALSE, TRUE,
          FALSE); // Previous control
        Key := 0;
      end;
    VK_INSERT:
      begin
        btnXInsertClick(self);
        Key := 0;
      end;
    VK_DELETE:
      begin
        btnXRemoveClick(self);
        Key := 0;
      end;
  VK_TAB:
    begin
      if ssShift in Shift then
      begin
        ActiveControl := tabDose; //Previeous control
        Key := 0;
      end
      else if ssCtrl	in Shift then
      begin
        ActiveControl := memComment;
        Key := 0;
      end;
    end;
  end;
end;

procedure TfrmODMedNVA.grdDosesEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(self);
  DisableCancelButton(self);
end;


procedure TfrmODMedNVA.grdDosesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  inherited;
  grdDoses.MouseToCell(X, Y, ACol, ARow);
  if (ARow < 0) or (ACol < 0) then
    Exit;
  if ACol > COL_SELECT then
    ShowEditor(ACol, ARow, #0)
  else
  begin
    grdDoses.Col := COL_DOSAGE;
    grdDoses.Row := ARow;
  end;
  if grdDoses.Col <> COL_DOSAGE then
    DropLastSequence;
end;

procedure TfrmODMedNVA.grdDosesKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if CharInSet(Key, [#32 .. #127]) then
    ShowEditor(grdDoses.Col, grdDoses.Row, Key);
  if grdDoses.Col <> COL_DOSAGE then
    DropLastSequence;
end;

procedure TfrmODMedNVA.grdDosesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  case FDropColumn of
    COL_DOSAGE:
      with cboXDosage do
        if Items.Count > 0 then
          DroppedDown := TRUE;
    COL_ROUTE:
      with cboXRoute do
        if Items.Count > 0 then
          DroppedDown := TRUE;
    COL_SCHEDULE:
      with cboXSchedule do
        if Items.Count > 0 then
          DroppedDown := TRUE;
    COL_SEQUENCE:
      with cboXSequence do
        if Items.Count > 0 then
          DroppedDown := TRUE;

  end;
  FDropColumn := -1;
end;
function TfrmODMedNVA.DisableCancelButton(Control: TWinControl): boolean;
var
  i: integer;
begin
  if (Control is TButton) and TButton(Control).Cancel then begin
    result := True;
    FDisabledCancelButton := TButton(Control);
    TButton(Control).Cancel := False;
  end else begin
    result := False;
    for i := 0 to Control.ControlCount-1 do
      if (Control.Controls[i] is TWinControl) then
        if DisableCancelButton(TWinControl(Control.Controls[i])) then begin
          result := True;
          break;
        end;
  end;
end;

function TfrmODMedNVA.DisableDefaultButton(Control: TWinControl): boolean;
var
  i: integer;
begin
  if (Control is TButton) and TButton(Control).Default then begin
    result := True;
    FDisabledDefaultButton := TButton(Control);
    TButton(Control).Default := False;
  end else begin
    result := False;
    for i := 0 to Control.ControlCount-1 do
      if (Control.Controls[i] is TWinControl) then
        if DisableDefaultButton(TWinControl(Control.Controls[i])) then begin
          result := True;
          break;
        end;
  end;
end;

procedure TfrmODMedNVA.RestoreCancelButton;
begin
  if Assigned(FDisabledCancelButton) then begin
    FDisabledCancelButton.Cancel := True;
    FDisabledCancelButton := nil;
  end;
end;

procedure TfrmODMedNVA.RestoreDefaultButton;
begin
  if Assigned(FDisabledDefaultButton) then begin
    FDisabledDefaultButton.Default := True;
    FDisabledDefaultButton := nil;
  end;
end;

procedure TfrmODMedNVA.pnlMessageEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(self);
  DisableCancelButton(self);
end;

procedure TfrmODMedNVA.pnlMessageExit(Sender: TObject);
begin
  inherited;
  RestoreDefaultButton;
  RestoreCancelButton;
end;

procedure TfrmODMedNVA.memMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := 0;
  end;
end;

procedure TfrmODMedNVA.FormResize(Sender: TObject);
begin
  inherited;
  pnlFields.Height := cmdAccept.Top - 4 - pnlFields.Top;
end;

function TfrmODMedNVA.GetCacheChunkIndex(idx: integer): integer;
begin
  Result := idx div MED_CACHE_CHUNK_SIZE;
end;

procedure TfrmODMedNVA.lstQuickData(Sender: TObject; Item: TListItem);
var
  x: string;
begin
    x := FQuickItems[Item.Index];
    Item.Caption := Piece(x, U, 2);
    Item.Data := Pointer(StrToIntDef(Piece(x, U, 1), 0));
end;

procedure TfrmODMedNVA.LoadOTCStatements(Dest: TStrings);
var tmplst: TStringList;
  s: string;
  i :Integer;
begin
    tmplst := TStringList.Create;
    tmplst.Clear;
    CallVistA('ORWPS REASON', [nil],tmplst);
    if tmplst.Count > 0 then
    begin
      //  sort := tmplst.Strings[0];
        for i := 0 to tmplst.Count-1 do
        begin
            s:= tmplst.Strings[i];
            tmplst.Strings[i] := Piece(s,U,2);
        end;
        FastAssign(tmplst, Dest);
    end;
 end;

function TfrmODMedNVA.FindQuickOrder(const x: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  if x = '' then Exit;
  for i := 0 to Pred(FQuickItems.Count) do
  begin
    if (Result > -1) or (FQuickItems[i] = '') then Break;
    if AnsiCompareText(x, Copy(Piece(FQuickItems[i],'^',2), 1, Length(x))) = 0 then Result := i;
  end;
end;
procedure TfrmODMedNVA.lbStatementsClickCheck(Sender: TObject;
  Index: Integer);
begin
  inherited;
   ControlChange(self);
end;

procedure TfrmODMedNVA.lstChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  btnSelect.Enabled := (lstAll.ItemIndex > -1) or
                       ((lstQuick.ItemIndex > -1) and
                       (Assigned(lstQuick.Items[lstQuick.ItemIndex].Data)) and
                       (Integer(lstQuick.Selected.Data) > 0)) ;
  if (btnSelect.Enabled) and (FRemoveText) then
    txtMed.Text := '';
end;

procedure TfrmODMedNVA.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if (Key = #13) and (ActiveControl = txtMed) then
  Key := #0   //Don't let the base class turn it into a forward tab!
 else
  inherited;
end;
{
function OIForNVA(AnIEN: Integer; ForNonVAMed: Boolean; HavePI: Boolean; PKIActive: Boolean): TStrings;
var
  PtType: Char;
  NeedPI: Char;
  IsPKIActive: Char;
begin
  if HavePI then NeedPI := 'Y' else NeedPI := 'N';
  if ForNonVAMed then PtType := 'X' else PtType := 'O';
  if PKIActive then IsPKIActive := 'Y' else IsPKIActive := 'N';
  CallV('ORWDPS2 OISLCT', [AnIEN, PtType, Patient.DFN, NeedPI, IsPKIActive]);
  Result := RPCBrokerV.Results;
end;
}
function setOIForNVA(aList: TStrings;AnIEN: Integer; ForNonVAMed: Boolean; HavePI: Boolean; PKIActive: Boolean):Integer;
var
  PtType: Char;
  NeedPI: Char;
  IsPKIActive: Char;
begin
  if HavePI then NeedPI := 'Y' else NeedPI := 'N';
  if ForNonVAMed then PtType := 'X' else PtType := 'O';
  if PKIActive then IsPKIActive := 'Y' else IsPKIActive := 'N';
  CallVistA('ORWDPS2 OISLCT', [AnIEN, PtType, Patient.DFN, NeedPI, IsPKIActive],aList);
  Result := aList.Count;
end;

procedure TfrmODMedNVA.txtNSSClick(Sender: TObject);
begin
  inherited;
  if MessageDlg('You can also select ' + '"' + 'Other' + '"' +
    ' from the schedule list' + ' to create a day-of-week schedule.' + #13#10 +
    'Click OK to launch schedule builder', mtInformation, [mbOK, mbCancel], 0) = mrOK
  then
  begin
    if (tabDose.TabIndex = TI_DOSE) then
    begin
      cboSchedule.SelectByID('OTHER');
      cboScheduleClick(self);
    end;
    if (tabDose.TabIndex = TI_COMPLEX) then
    begin
      cboXSchedule.SelectByID('OTHER');
      cboXScheduleChange(self);
    end;
  end;
end;

procedure CheckAuthForNVAMeds(var x: string);
begin
  if CallVistA('ORWDPS32 AUTHNVA', [Encounter.Provider],x) then
    x := Piece(x,U,2)
  else
    x := '';
end;

function TfrmODMedNVA.isUniqueQuickOrder(iText: string): Boolean;
var
  counter,i: Integer;
begin
  counter := 0;
  Result := False;
  if iText = '' then Exit;
  for i := 0 to FQuickItems.Count-1 do
    if AnsiCompareText(iText, Copy(Piece(FQuickItems[i],'^',2), 1, Length(iText))) = 0 then
      Inc(counter);               //Found a Match
  Result := counter = 1;
end;

procedure TfrmODMedNVA.ShowControlsComplex;

  procedure MoveCombo(SrcCombo, DestCombo: TORComboBox;
    CompSch: Boolean = FALSE); // AGP Changes 26.12 PSI-04-63; carried forward by WEF 3/14/19 from inpatient complex orders
  var
    cnt, i, Index: Integer;
    node, Text: string;
  begin
    if (CompSch = FALSE) or not(fInptDlg) then
    begin
      DestCombo.Items.Clear;
      FastAssign(SrcCombo.Items, DestCombo.Items);
      DestCombo.ItemIndex := SrcCombo.ItemIndex;
      DestCombo.Text := Piece(SrcCombo.Text, TAB, 1);
    end;
    if (CompSch = TRUE) and (fInptDlg) then // AGP Changes 26.12 PSI-04-63; carried forward by WEF 3/14/19 from inpatient complex orders
    begin
      // AGP change 26.34 CQ 7201,6902 fix the problem with one time schedule still showing for inpatient complex orders
      // ; carried forward by WEF 3/14/19 from inpatient complex orders
      DestCombo.ItemIndex := -1;
      Text := SrcCombo.Text;
      index := SrcCombo.ItemIndex;
      cnt := 0;
      for i := 0 to SrcCombo.Items.Count - 1 do
      begin
        node := SrcCombo.Items.Strings[i];
        if Piece(node, U, 3) <> 'O' then
        begin
          DestCombo.Items.Add(SrcCombo.Items.Strings[i]);
          if Piece(node, U, 1) = Text then
            DestCombo.ItemIndex := index - cnt;
        end
        else
          cnt := cnt + 1;
      end;
      if (index = -1) and (Text <> '') then
      begin
        for i := 0 to DestCombo.Items.Count - 1 do
          if Piece(DestCombo.Items.Strings[i], U, 1) = Text then
          begin
            DestCombo.ItemIndex := i;
            DestCombo.Text := Text;
            Exit;
          end;
      end;
    end;
  end;

// var
// dosagetxt: string;
begin
  tabDose.TabIndex := TI_COMPLEX;
  lblAdminSchSetText('');
  MoveCombo(cboDosage, cboXDosage);
  MoveCombo(cboRoute, cboXRoute);
  MoveCombo(cboSchedule, cboXSchedule, TRUE); // AGP Changes 26.12 PSI-04-063; carried forward by WEF 3/14/19 from inpatient complex orders
  grdDoses.Visible := TRUE;
  btnXInsert.Visible := TRUE;
  btnXRemove.Visible := TRUE;
  cboDosage.Visible := FALSE;
  lblRoute.Visible := FALSE;
  cboRoute.Visible := FALSE;
  lblSchedule.Visible := FALSE;
  cboSchedule.Visible := FALSE;
  chkPRN.Visible := FALSE;
  FDropColumn := -1;
  pnlFieldsResize(self);
  ActiveControl := grdDoses;
  if cboXSequence.Items.IndexOf('except') > -1 then
    cboXSequence.Items.Delete(cboXSequence.Items.IndexOf('except'));

  // Commented out, no longer using CharsNeedMatch Property
  { NumCharsForMatch := 0;
    for i := 0 to cboXDosage.Items.Count - 1 do         //find the shortest unit dose text on fifth piece
    begin
    dosagetxt := Piece(cboXDosage.Items[i],'^',5);
    if Length(dosagetxt) < 1 then break;
    if NumCharsForMatch = 0 then
    NumCharsForMatch := Length(dosagetxt);
    if (NumCharsForMatch > Length(dosagetxt)) then
    NumCharsForMatch := Length(dosagetxt);
    end;
    if NumCharsForMatch > 1 then
    cboXDosage.CharsNeedMatch := NumCharsForMatch - 1;
    if NumCharsForMatch > 5 then
    cboDosage.CharsNeedMatch := 5; }
end;
procedure TfrmODMedNVA.DispOrderMessage(const AMessage: string);
begin
  if ContainsVisibleChar(AMessage) then
  begin
    image1.Visible := True;
    memDrugMsg.Visible := True;
    image1.Picture.Icon.Handle := LoadIcon(0, IDI_ASTERISK);
    memDrugMsg.Lines.Clear;
    memDrugMsg.Lines.SetText(PChar(AMessage));
    if fShrinkDrugMsg then
    begin
      pnlBottom.Height := pnlBottom.Height + memDrugMsg.Height + 2;
      fShrinkDrugMsg := False;
    end;
  end else
  begin
    image1.Visible := False;
    memDrugMsg.Visible := False;
    if not fShrinkDrugMsg then
  //  begin
  //    pnlBottom.Height := pnlBottom.Height - memDrugMsg.Height - 2;
      fShrinkDrugMsg := True;
 //   end;
  end;
end;

procedure TfrmODMedNVA.lblAdminSchSetText(str: string);
var
  cutoff: Integer;
begin
  cutoff := lblAdminSch.Width div MainFontWidth;
  if Length(str) > cutoff then
    self.lblAdminSch.Text := Copy(str, 1, cutoff) + CRLF +
      Copy(str, cutoff + 1, Length(str))
  else
    self.lblAdminSch.Text := str;
end;

procedure TfrmODMedNVA.cboXRouteChange(Sender: TObject);
begin
  inherited;
  // Commented out to fix CQ: 7280; carried forward by WEF 3/14/19 from inpatient complex orders
  // if cboXRoute.Text = '' then cboXRoute.ItemIndex := -1;
  if not Changing and (cboXRoute.ItemIndex < 0) then
  begin
    grdDoses.Cells[COL_ROUTE, cboXRoute.Tag] := cboXRoute.Text;
    ControlChange(self);
  end;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXRouteClick(Sender: TObject);
var
  X: string;
begin
  inherited;
  with cboXRoute do
    if ItemIndex > -1 then
      X := Text + TAB + Items[ItemIndex]
    else
      X := Text;
  grdDoses.Cells[COL_ROUTE, cboXRoute.Tag] := X;
  ControlChange(self);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXRouteExit(Sender: TObject);
begin
  inherited;
  // Removed based on Site feeback. See CQ: 7518
  { if Not ValidateRoute(cboXRoute) then
    Exit; }
  if Trim(cboXRoute.Text) = '' then
  begin
    cboXRoute.ItemIndex := -1;
    Exit;
  end;
  cboXRouteClick(self);
  cboXRoute.Tag := -1;
  cboXRoute.Hide;
  RestoreDefaultButton;
  RestoreCancelButton;
  if (pnlMessage.Visible) and (memMessage.TabStop) then
  begin
    pnlMessage.Parent := grdDoses.Parent;
    pnlMessage.TabOrder := grdDoses.TabOrder;
    ActiveControl := memMessage;
  end
  else if grdDoses.Showing then
    ActiveControl := grdDoses
  else
    ActiveControl := cboDosage;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXRouteEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(self);
  DisableCancelButton(self);
  QuantityMessageCheck(self.grdDoses.Row);
end;

procedure TfrmODMedNVA.ShowEditor(ACol, ARow: Integer; AChar: Char);
var
  X, tmpText: string;

  procedure PlaceControl(AControl: TWinControl);
  var
    ARect: TRect;
  begin
    with AControl do
    begin
      ARect := grdDoses.CellRect(ACol, ARow);
      SetBounds(ARect.Left + grdDoses.Left + 1, ARect.Top + grdDoses.Top + 1,
        ARect.Right - ARect.Left + 1, ARect.Bottom - ARect.Top + 1);
      Tag := ARow;
      BringToFront;
      Show;
      SetFocus;
    end;
  end;

  procedure SynchCombo(ACombo: TORComboBox; const ItemText, EditText: string);
  var
    i: Integer;
    evnt: TNotifyEvent;

  begin
    evnt := ACombo.OnChange;
    ACombo.OnChange := nil;
    try
      ACombo.ItemIndex := -1;
      for i := 0 to Pred(ACombo.Items.Count) do
        if ACombo.Items[i] = ItemText then
          ACombo.ItemIndex := i;
      if ACombo.ItemIndex < 0 then
        ACombo.Text := EditText;
    finally
      ACombo.OnChange := evnt;
    end;
  end;

begin
  inherited;
  txtNSS.Visible := FALSE;
  // Make space just select editor.  This blows up as soon as some joker makes a
  // dosage starting with a space.
  if AChar = ' ' then
    AChar := #0;
  if ARow = 0 then
    Exit; // header row
  // require initial instruction entry when in last row
  with grdDoses do
    if { (ARow = Pred(RowCount)) and } (ACol > COL_DOSAGE) and
      (ValFor(COL_DOSAGE, ARow) = '') then
      Exit;
  // require that initial instructions  for rows get entered from top to bottom
  // (this does not include behaivor of row insertion button.)
  if (ACol = COL_DOSAGE) and (ARow > 1) and (ValFor(COL_DOSAGE, ARow - 1) = '')
  then
    Exit;
  // display appropriate editor for row & column
  case ACol of
    COL_DOSAGE:
      begin
        // default route & schedule to previous row
        if (ARow > 1) then
        begin
          if (grdDoses.Cells[COL_ROUTE, ARow] = '') and
            (grdDoses.Cells[COL_SCHEDULE, ARow] = '') then
          begin
            grdDoses.Cells[COL_ROUTE, ARow] :=
              grdDoses.Cells[COL_ROUTE, Pred(ARow)];
            { don't default schedule - recommended by Martin Lowe }
            // grdDoses.Cells[COL_SCHEDULE, ARow] := grdDoses.Cells[COL_SCHEDULE, Pred(ARow)];
          end;
          // AGP Change 26.45 remove auto-populate of the sequence field
          { *    if grdDoses.Cells[COL_SEQUENCE, Pred(ARow)] = '' then
            begin
            if StrToIntDef(Piece(grdDoses.Cells[COL_DURATION, Pred(ARow)], ' ', 1), 0) > 0
            then grdDoses.Cells[COL_SEQUENCE, Pred(ARow)] := 'THEN'
            else grdDoses.Cells[COL_SEQUENCE, Pred(ARow)] := 'AND';
            end;  * }
        end;
        // set appropriate value for cboDosage
        SynchCombo(cboXDosage, ValFor(VAL_DOSAGE, ARow),
          ValFor(COL_DOSAGE, ARow));
        PlaceControl(cboXDosage);
        FDropColumn := COL_DOSAGE;
        if AChar <> #0 then
          PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_DOSAGE);
      end;
    COL_ROUTE:
      begin
        // set appropriate value for cboRoute
        SynchCombo(cboXRoute, ValFor(VAL_ROUTE, ARow), ValFor(COL_ROUTE, ARow));
        PlaceControl(cboXRoute);
        FDropColumn := COL_ROUTE;
        if AChar <> #0 then
          PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_ROUTE);
      end;
    COL_SCHEDULE:
      begin
        // set appropriate value for cboSchedule
        if fInptDlg then
          txtNSS.Visible := TRUE;
        X := Piece(grdDoses.Cells[COL_SCHEDULE, ARow], TAB, 1);
        Changing := TRUE;
        if ValFor(VAL_CHKXPRN, ARow) = '1' then
          chkXPRN.Checked := TRUE
        else
          chkXPRN.Checked := FALSE;
        if Pos('PRN', X) > 0 then
        begin
          cboXSchedule.SelectByID(X);
          if cboXSchedule.ItemIndex < 0 then
          begin
            X := Trim(Copy(X, 1, Pos('PRN', X) - 1));
            chkXPRN.Checked := TRUE;
          end;
        end;
        if Length(X) > 0 then
        begin
          cboXSchedule.SelectByID(X);
          cboXSchedule.Text := X;
        end
        else
          cboXSchedule.ItemIndex := -1;
        (* if Pos('PRN', x) > 0 then
          begin
          NonPRNPart := Trim(Copy(x, 1, Pos('PRN', x) - 1));
          cboXSchedule.SelectByID(NonPRNPart);
          if cboXSchedule.ItemIndex > -1 then chkXPRN.Checked := True else
          begin
          chkXPRN.Checked := False;
          cboXSchedule.SelectByID(x);
          if cboXSchedule.ItemIndex < 0 then cboXSchedule.Text := x;
          end;
          end; *)
        Changing := FALSE;
        cboXSequence.Tag := ARow;
        PlaceControl(pnlXSchedule);
        FDropColumn := COL_SCHEDULE;
        if AChar <> #0 then
          PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_SCHEDULE);
      end;
    COL_DURATION:
      begin
        // set appropriate value for pnlDuration
        X := ValFor(VAL_DURATION, ARow);
        Changing := TRUE;
        txtXDuration.Text := Piece(X, ' ', 1);
        X := Piece(X, ' ', 2);
        if Length(X) > 0 then
          btnXDuration.Caption := LowerCase(X)
        else
        begin
          txtXDuration.Text := '0';
          btnXDuration.Caption := 'days';
        end;
        tmpText := txtXDuration.Text; // Fix for CQ: 8107 - Kloogy but works.
        UpdateDurationControls(FALSE);
        Changing := FALSE;
        pnlXDuration.Tag := ARow;
        PlaceControl(pnlXDuration);
        txtXDuration.SetFocus;
        ARow1 := ARow;
        txtXDuration.Text := tmpText; // Fix for CQ: 8107 - Kloogy but works.
        if AChar <> #0 then
          PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_DURATION);
      end;
    COL_SEQUENCE:
      begin
        SynchCombo(cboXSequence, ValFor(VAL_SEQUENCE, ARow),
          ValFor(COL_SEQUENCE, ARow));
        cboXSequence.Tag := ARow;
        ARow1 := ARow;
        PlaceControl(cboXSequence);
        FDropColumn := COL_SEQUENCE;
        if AChar <> #0 then
          PostMessage(Handle, UM_DELAYEVENT, Ord(AChar), COL_SEQUENCE);
      end;
    COL_ADMINTIME:
      BEGIN
        pnlXAdminTime.OnClick(pnlXAdminTime);
      end;
  end; { case ACol }
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.DropLastSequence(ASign: Integer);
const
  TXT_CONJUNCTIONWARNING =
    'is not associated with the comment field, and has been deleted.';
var
  i: Integer;
  StrConjunc: string;
begin
  for i := 1 to grdDoses.RowCount - 1 do
  begin
    if (i = 1) and (grdDoses.Cells[COL_DOSAGE, i] = '') then
      Exit
    else if (i > 1) and (grdDoses.Cells[COL_DOSAGE, i] = '') and
      (grdDoses.Cells[COL_ROUTE, i] = '') then
    begin
      if Length(grdDoses.Cells[COL_SEQUENCE, i - 1]) > 0 then
      begin
        StrConjunc := grdDoses.Cells[COL_SEQUENCE, i - 1];
        if ASign = 1 then
        begin
          if InfoBox('The "' + StrConjunc + '" ' + TXT_CONJUNCTIONWARNING,
            'Warning', MB_OK or MB_ICONWARNING) = IDOK then
          begin
            grdDoses.Cells[COL_SEQUENCE, i - 1] := '';
            ActiveControl := memOrder;
          end
        end
        else
        begin
          grdDoses.Cells[COL_SEQUENCE, i - 1] := '';
        end;
      end;
      Exit;
    end;
  end;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXSequenceChange(Sender: TObject);
var
  X: string;
begin
  inherited;
  X := cboXSequence.Text;
  if (X = 'then') and ((ValFor(COL_DURATION, ARow1) = '') or
    (ValFor(COL_DURATION, ARow1) = '0')) then
  begin
    InfoBox('A duration is required when using "Then" as a conjunction' + CRLF +
      CRLF + 'The patient will be instructed to take these doses consecutively, not concurrently.',
      'Duration Warning', MB_OK);
    X := '';
  end;
  cboXSequence.Text := X;
  cboXSequence.ItemIndex := cboXSequence.Items.IndexOf(X);
  grdDoses.Cells[COL_SEQUENCE, cboXSequence.Tag] := Uppercase(X);
  // AGP Start Expire add line
  UpdateStartExpires(ValFor(COL_SCHEDULE, self.grdDoses.Row));
  ControlChange(Sender);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXSequenceEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(self);
  DisableCancelButton(self);
  QuantityMessageCheck(self.grdDoses.Row);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXSequenceExit(Sender: TObject);
begin
  inherited;
  grdDoses.Cells[COL_SEQUENCE, cboXSequence.Tag] :=
    Uppercase(cboXSequence.Text);
  if ActiveControl = grdDoses then
  begin
    // This next condition seldom occurs, since entering the dosage on the last
    // row adds another row
    if grdDoses.Row = grdDoses.RowCount - 1 then
      grdDoses.RowCount := grdDoses.RowCount + 1;
  end;
  cboXSequence.Tag := -1;
  cboXSequence.Hide;
  RestoreDefaultButton;
  RestoreCancelButton;
  if (pnlMessage.Visible) and (memMessage.TabStop) then
  begin
    pnlMessage.Parent := grdDoses.Parent;
    pnlMessage.TabOrder := grdDoses.TabOrder;
    ActiveControl := memMessage;
  end
  else if grdDoses.Showing then
    ActiveControl := grdDoses
  else
    ActiveControl := cboDosage;
  // AGP Start Expire commented out line
  // UpdateStartExpires(valFor(COL_SCHEDULE,self.grdDoses.Row));
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXSequenceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboXSequence.Text = '') then
    cboXSequence.ItemIndex := -1;
end;

procedure TfrmODMedNVA.cboXSequence1Exit(Sender: TObject);
begin
  inherited;
  cboXSequence.Hide;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXScheduleChange(Sender: TObject);
var
  othSch, X: string;
  idx: Integer;
begin
  inherited;
  // Commented out to fix CQ: 7280; carried forward by WEF 3/14/19 from inpatient complex orders
  // if cboXSchedule.Text = '' then cboXSchedule.ItemIndex := -1;
  if not Changing { and (cboXSchedule.ItemIndex < 0) } then
  begin
    if (fInptDlg) and (cboXSchedule.Text = 'OTHER') then
    begin
      cboXSchedule.SelectByID('OTHER');
      othSch := CreateOtherScheduelComplex;
      if Length(Trim(othSch)) > 1 then
      begin
        othSch := othSch + U + U + NSSScheduleType + U + NSSAdminTime;
        cboXSchedule.Items.Add(othSch);
        idx := cboXSchedule.Items.IndexOf(Piece(othSch, U, 1));
        cboXSchedule.ItemIndex := idx;
      end;
    end;
    if pnlXSchedule.Tag = -1 then
      pnlXSchedule.Tag := self.grdDoses.Row;
    // if pnlXSchedule.Tag = -1 then pnlXSchedule.Tag := self.grdDoses.Row;
    with cboXSchedule do
      if ItemIndex > -1 then
        X := Text + TAB + Items[ItemIndex]
      else
        X := Text;
    grdDoses.Cells[COL_SCHEDULE, pnlXSchedule.Tag] := X;
    self.cboSchedule.Text := X;
    // AGP Start Expired uncommented out the line
    if fInptDlg then
      UpdateStartExpires(Piece(X, TAB, 1));

    ControlChange(self);
    UpdateRelated;
  end;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXScheduleClick(Sender: TObject);
var
  PRN, X: string;
begin
  inherited;
  // agp change CQ 11015
  if (chkXPRN.Checked) then
    PRN := ' PRN'
  else
    PRN := '';
  with cboXSchedule do
  begin
    if RightStr(Text, 3) = 'PRN' then
      PRN := '';
    if ItemIndex > -1 then
      X := Text + PRN + TAB + Items[ItemIndex]
    else
      X := Text + PRN;
  end;
  (* with cboXSchedule do if ItemIndex > -1
    then x := Text + TAB + Items[ItemIndex]
    else x := Text; *)
  grdDoses.Cells[COL_SCHEDULE, pnlXSchedule.Tag] := X;
  // AGP Start Expired uncommented out the line
  UpdateStartExpires(Piece(X, TAB, 1));
  UpdateRelated;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXScheduleEnter(Sender: TObject);
begin
  inherited;
  // agp Change CQ 10719
  self.chkXPRN.OnClick(self.chkXPRN);
  QuantityMessageCheck(self.grdDoses.Row);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXScheduleExit(Sender: TObject);
begin
  inherited;
  { CQ: 7344 - Inconsistency with Schedule box: Allows free-text entry for Complex orders,
    doesn't for simple orders }
  ValidateInpatientSchedule(cboXSchedule);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXScheduleKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboXSchedule.Text = '') then
    cboXSchedule.ItemIndex := -1;
end;

procedure TfrmODMedNVA.QuantityMessageCheck(Tag: Integer);
var
  DispDrug: Integer;
  X: string;

begin
  if fInptDlg then
    Exit;
  DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID, Tag), 0);
  if DispDrug > 0 then
  begin
    if not FSuppressMsg then
    begin
      FSuppressMsg := FALSE;
    end;
    X := QuantityMessage(DispDrug);
  end
  else
    X := '';
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlFieldsResize(Sender: TObject);
const
  REL_DOSAGE = 0.38;
  REL_ROUTE = 0.17;
  REL_SCHEDULE = 0.19;
  REL_DURATION = 0.16;
  REL_ANDTHEN = 0.10;
  REL_ADMINTIME = 0.16;
var
  i, ht, RowCountShowing: Integer;
  ColControl: TWinControl;
begin
  inherited;
  with grdDoses do
  begin
    i := grdDoses.Width - 20; // 20 = 12 pixel margin + 8 pixel column 0
    i := i - GetSystemMetrics(SM_CXVSCROLL);
    // compensate for appearance of scroll bar
    if (not fInptDlg) or (FAdminTimeText = 'Not defined for Clinic Locations')
    then
    begin
      ColWidths[1] := Round(REL_DOSAGE * i); // dosage
      ColWidths[2] := Round(REL_ROUTE * i); // route
      ColWidths[3] := Round(REL_SCHEDULE * i); // schedule
      ColWidths[4] := Round(REL_DURATION * i); // duration
      ColWidths[5] := Round(0 * i); // administration time
      grdDoses.TabStops[5] := FALSE;
      ColWidths[6] := Round(REL_ANDTHEN * i); // and/then
    end
    else
    begin
      ColWidths[1] := Round(0.35 * i); // dosage
      ColWidths[2] := Round(0.10 * i); // route
      ColWidths[3] := Round(0.19 * i); // schedule
      ColWidths[4] := Round(0.12 * i); // duration
      ColWidths[5] := Round(0.16 * i); // administration time
      grdDoses.TabStops[5] := TRUE;
      ColWidths[6] := Round(0.08 * i); // and/then
    end;
    // adjust height of grid to not show partial rows
    ht := pnlBottom.Top - Top - 6;

    ht := ht div (DefaultRowHeight + 1);
    ht := ht * (DefaultRowHeight + 1);
    Inc(ht, 3);
    Height := ht;
    // Move a column control if it is showing
    ColControl := nil;
    case grdDoses.Col of
      COL_DOSAGE:
        ColControl := cboXDosage;
      COL_ROUTE:
        ColControl := cboXRoute;
      COL_SCHEDULE:
        ColControl := pnlXSchedule;
      COL_DURATION:
        ColControl := pnlXDuration;
      COL_ADMINTIME:
        ColControl := pnlXAdminTime;
      COL_SEQUENCE:
        ColControl := cboXSequence;
    end; { case }
  end;
  if assigned(ColControl) and ColControl.Showing then
  begin
    RowCountShowing := (Height - 25) div (grdDoses.DefaultRowHeight + 1);
    if (grdDoses.Row <= RowCountShowing) then
      ShowEditor(grdDoses.Col, grdDoses.Row, #0)
    else
      ColControl.Hide;
  end;

end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.txtXDurationChange(Sender: TObject);
var
  i, code: Integer;
  OrgValue: string;
begin
  inherited;
  if Changing then
    Exit;
  if (txtXDuration.Text <> '0') and (txtXDuration.Text <> '') then
  begin
    Val(txtXDuration.Text, i, code);
    UpdateDurationControls(code <> 0);
    // Commented out the "and" to resolve CQ: 7557
    if (code <> 0) { and (I=0) } then
    begin
      ShowMsg('Please use numeric characters only.');
      with txtXDuration do
      begin
        Text := IntToStr(i);
        SelStart := Length(Text);
      end;
      Exit;
      btnXDuration.Width := 8;
      btnXDuration.Align := alRight;
      spnXDuration.Visible := FALSE;
      txtXDuration.Align := alClient;
      popDuration.Items.Tag := 0;
      btnXDuration.Caption := '';
    end;
    { AGP change 26.19 for PSI-05-018 cq #7322
      else if PopDuration.Items.Tag = 0 then
      begin
      PopDuration.Items.Tag := 3;  //Days selection
      btnXDuration.Caption := 'days';
      end; }
    grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := txtXDuration.Text + ' ' +
      Uppercase(btnXDuration.Caption);
  end
  else // AGP CHANGE ORDER
  begin
    if not(fInptDlg) then
      grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := '';
    OrgValue := ValFor(COL_DURATION, pnlXDuration.Tag);
    // if ((txtXDuration.Text = '0') or (txtXDuration.Text = '')) and ((ValFor(COL_SEQUENCE, ARow1) = 'THEN') and (FInptDlg)) then //AGP CHANGE ORDER
    // AGP change 26.33 Then/And conjunction requiring a duration to include outpatient orders also
    if ((txtXDuration.Text = '0') or (txtXDuration.Text = '')) and
      (ValFor(COL_SEQUENCE, ARow1) = 'THEN') then // AGP CHANGE ORDER
    begin
      if (InfoBox('A duration is required when using "Then" as a sequence.' +
        CRLF + '"Then" will be remove from the sequence field if you continue' +
        CRLF + 'Click "OK" to continue or click "Cancel"', 'Duration Warning',
        MB_OKCANCEL) = 1) then
      begin
        grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := '';
        cboXSequence.Tag := ARow1;
        grdDoses.Cells[COL_SEQUENCE, cboXSequence.Tag] := '';
        cboXSequence.Text := '';
        cboXSequence.ItemIndex := -1;
      end
      else
        grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := OrgValue;
    end
    else
      grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := txtXDuration.Text;
  end;
  // end;
  ControlChange(self);
  UpdateRelated;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.txtXDurationEnter(Sender: TObject);
begin
  inherited;
  UpdateDurationControls(FALSE);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.btnXDurationClick(Sender: TObject);
var
  APoint: TPoint;
begin
  inherited;
  with TSpeedButton(Sender) do
    APoint := ClientToScreen(Point(0, Height));
  popDuration.Popup(APoint.X, APoint.Y);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlXDurationButtonEnter(Sender: TObject);
begin
  inherited;
  QuantityMessageCheck(self.grdDoses.Row);
end;

procedure TfrmODMedNVA.UpdateDurationControls(FreeText: Boolean);
var
  lnWidth: Integer;
begin
  if FreeText then
  begin
    pnlXDurationButton.Width := 8;
    pnlXDurationButton.Align := alRight;
    spnXDuration.Visible := FALSE;
    txtXDuration.Align := alClient;
  end
  else
  begin
    lnWidth := pnlXDuration.Width - (pnlXDuration.Width div 2) -
      spnXDuration.Width + 2;
    txtXDuration.Align := alNone;
    txtXDuration.Width := lnWidth;
    pnlXDurationButton.Width := pnlXDuration.Width div 2;
    pnlXDurationButton.Align := alRight;
    spnXDuration.Visible := TRUE;
    spnXDuration.Left := txtXDuration.Left + lnWidth;
  end;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlXAdminTimeClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  if not fInptDlg then
    Exit;

  str := 'The Administration Times for this dose are: ' + CRLF + CRLF +
    ValFor(VAL_ADMINTIME, grdDoses.Row);
  str := str + CRLF + CRLF + AdminTimeHelpText;
  InfoBox(str, 'Administration Time Information', MB_OK);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
function TfrmODMedNVA.CreateOtherScheduelComplex: string;
var
  ASchedule: string;
begin
  ASchedule := '';
  if not ShowOtherSchedule(ASchedule) then
  begin
    cboXSchedule.ItemIndex := -1;
    cboXSchedule.Text := '';
  end
  else
  begin
    Result := Piece(ASchedule, U, 1);
    NSSAdminTime := Piece(ASchedule, U, 2);
    NSSScheduleType := Piece(ASchedule, U, 3);
    if FAdminTimeText <> '' then
      NSSAdminTime := FAdminTimeText;
  end;
end;

procedure TfrmODMedNVA.popDurationClick(Sender: TObject);
var
  X: string;
begin
  inherited;
  with TMenuItem(Sender) do
  begin
    if Tag > 0 then
    begin
      X := LowerCase(Caption);
      // Make sure duration is integer
      txtXDuration.Text := IntToStr(StrToIntDef(txtXDuration.Text, 0));
      UpdateDurationControls(FALSE);
    end
    else
    begin
      X := '';
      txtXDuration.Text := '';
      UpdateDurationControls(TRUE);
    end;
  end;
  btnXDuration.Caption := X;
  txtXDurationChange(Sender);
  ControlChange(Sender);
end;

function TfrmODMedNVA.lblAdminSchGetText: string;
var
  tempStr: string;
  i: Integer;
begin
  Result := '';
  if self.lblAdminSch.Text = '' then
    Exit;
  tempStr := '';
  if self.lblAdminSch.Lines.Count > 1 then
  begin
    for i := 0 to self.lblAdminSch.Lines.Count - 1 do
      tempStr := tempStr + self.lblAdminSch.Lines.Strings[i];
  end
  else if self.lblAdminSch.Lines.Count = 1 then
  begin
    tempStr := self.lblAdminSch.Text;
  end;
  Result := Piece(tempStr, ':', 2);
  Result := Copy(Result, 2, Length(Result));
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlXDurationEnter(Sender: TObject);
begin
  inherited;
  txtXDuration.SetFocus;
  DisableDefaultButton(self);
  DisableCancelButton(self);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlXDurationExit(Sender: TObject);
begin
  inherited;
  pnlXDuration.Tag := -1;
  pnlXDuration.Hide;
  UpdateRelated;
  RestoreDefaultButton;
  RestoreCancelButton;
  if (pnlMessage.Visible) and (memMessage.TabStop) then
  begin
    pnlMessage.Parent := grdDoses.Parent;
    pnlMessage.TabOrder := grdDoses.TabOrder;
    ActiveControl := memMessage;
  end
  else if grdDoses.Showing then
    ActiveControl := grdDoses
  else
    ActiveControl := cboDosage;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlXScheduleEnter(Sender: TObject);
begin
  inherited;
  cboXSchedule.SetFocus;
  DisableDefaultButton(self);
  DisableCancelButton(self);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.pnlXScheduleExit(Sender: TObject);
begin
  inherited;
  if Not FShowPnlXScheduleOk then // Added for CQ: 7370
    Exit;
  cboXScheduleClick(self);
  pnlXSchedule.Tag := -1;
  pnlXSchedule.Hide;
  UpdateRelated;
  RestoreDefaultButton;
  RestoreCancelButton;
  if (pnlMessage.Visible) and (memMessage.TabStop) then
  begin
    pnlMessage.Parent := grdDoses.Parent;
    pnlMessage.TabOrder := grdDoses.TabOrder;
    ActiveControl := memMessage;
  end
  else if grdDoses.Showing then
    ActiveControl := grdDoses
  else
    ActiveControl := cboDosage;
  // AGP Start Expired commented out the line
  // updateStartExpires(valFor(COL_SCHEDULE,self.grdDoses.Row));
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.ValidateInpatientSchedule(ScheduleCombo: TORComboBox);
var
  tmpIndex: Integer;
begin

  { CQ: 6690 - Orders - autopopulation of schedule field - overtyping only 1 character
    CQ: 7280 - PTM 32-34, 42 Meds: NJH-0205-20901 MED DIALOG DROPPING FIRST LETTER (schedule) }

  // CQ 7575  Schedule coming across lower-case, change all schedules to Upper-Case.
  if (Length(ScheduleCombo.Text) > 0) then
    ScheduleCombo.Text := TrimLeft(Uppercase(ScheduleCombo.Text));
  { if user entered schedule verify it is in list }
  if (ScheduleCombo.ItemIndex < 0) and (not fInptDlg) then
  // CQ: 7397  and CQ 17934
  begin // Fix for CQ: 9299 - Outpatient Med orders will not accept free text schedule
    tmpIndex := GetSchedListIndex(ScheduleCombo, ScheduleCombo.Text);
    if tmpIndex > -1 then
      ScheduleCombo.ItemIndex := tmpIndex;
  end;
  if (Length(ScheduleCombo.Text) > 0) and (ScheduleCombo.ItemIndex < 0) and fInptDlg
  then
  begin
    FShowPnlXScheduleOk := FALSE; // Added for CQ: 7370
    Application.MessageBox('Please select a valid schedule from the list.' + #13
      + #13 + 'If you would like to create a Day-of-Week schedule please' +
      ' select ''OTHER'' from the list.', 'Incorrect Schedule.');
    ScheduleCombo.ItemIndex := -1;
    ScheduleCombo.Text := '';
    FShowPnlXScheduleOk := TRUE; // Added for CQ: 7370
    if ScheduleCombo.CanFocus then
      ScheduleCombo.SetFocus;
    // ScheduleCombo.SelStart := Length(ScheduleCombo.Text);
  end;
end;

function TfrmODMedNVA.GetSchedListIndex(SchedCombo: TORComboBox;
  pSchedule: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to SchedCombo.Items.Count - 1 do
  begin
    if pSchedule = SchedCombo.DisplayText[i] then
    begin
      Result := i; // match found
      Break;
    end;
  end;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.chkXPRNClick(Sender: TObject);
var
  check: string;
begin
  inherited;
  if self.chkXPRN.Checked = TRUE then
    check := '1'
  else
    check := '0';
  self.grdDoses.Cells[COL_CHKXPRN, self.grdDoses.Row] := check;
  if not Changing then
    cboXScheduleClick(self);

  ControlChange(self);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXDosageEnter(Sender: TObject);
begin
  inherited;
  // if this was the last row, create a new last row
  if grdDoses.Row = Pred(grdDoses.RowCount) then
    grdDoses.RowCount := grdDoses.RowCount + 1;
  DisableDefaultButton(self);
  DisableCancelButton(self);
  QuantityMessageCheck(cboXDosage.Tag);
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXDosageChange(Sender: TObject);
var
  temp1, temp2: string;
  Count: Integer;
begin
  inherited;
  if not Changing and (cboXDosage.ItemIndex < 0) then
  begin
    Count := Pos(U, cboXDosage.Text);
    if Count > 0 then
    begin
      temp1 := Copy(cboXDosage.Text, 0, Count - 1);
      temp2 := Copy(cboXDosage.Text, Count + 1, Length(cboXDosage.Text));
      InfoBox('An ^ is not allowed in the dosage value',
        'Dosage Warning', MB_OK);
      cboXDosage.Text := temp1 + temp2;
    end;
    grdDoses.Cells[COL_DOSAGE, cboXDosage.Tag] := cboXDosage.Text;
    UpdateRelated;
  end;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXDosageClick(Sender: TObject);
var
  DispDrug: Integer;
  X: string;
begin
  inherited;
  if FSuppressMsg then
  begin
    if pnlMessage.Visible = TRUE then
    begin
      memMessage.SendToBack;
      pnlMessage.Visible := FALSE;
    end;
  end;

  with cboXDosage do
    if ItemIndex > -1 then
      X := Text + TAB + Items[ItemIndex]
    else
      X := Text;
  grdDoses.Cells[COL_DOSAGE, cboXDosage.Tag] := X;
  UpdateRelated(FALSE);
  DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID, cboXDosage.Tag), 0);
  if DispDrug > 0 then
  begin
    if not FSuppressMsg then
    begin
      FSuppressMsg := FALSE;
    end;
    X := QuantityMessage(DispDrug);
  end
  else
    X := '';
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXDosageExit(Sender: TObject);
var
  // tempTag: integer;
  str: string;
begin
  inherited;
  if cboXDosage.Showing then
  begin
    cboXDosageClick(self);
    str := cboXDosage.Text;
    // tempTag := cboXDosage.Tag;
    // cboXDosage.Tag := -1;
    cboXDosage.Hide;
    UpdateRelated;
    RestoreDefaultButton;
    RestoreCancelButton;
    (* Probably not needed here since on validation check on accept
      if (LeftStr(cboXDosage.Text,1)='.') and (self.tabDose.TabIndex = TI_COMPLEX) then
      begin
      infoBox('Dosage must have a leading numeric value','Invalid Dosage',MB_OK);
      //cboXDosage.Tag := tempTag;
      cboXDosage.Show;
      cboXDosage.SetFocus;
      Exit;
      end; *)
    if (Length(cboXDosage.Text) > 0) and (cboXDosage.ItemIndex > -1) and
      (Trim(Piece(cboXDosage.Items.Strings[cboXDosage.ItemIndex], U, 5)) <>
      Trim(Piece(cboXDosage.Text, '#', 1))) then
    begin
      cboXDosage.ItemIndex := -1;
      cboXDosage.Text := Piece(str, '#', 1);
      self.grdDoses.Cells[COL_DOSAGE, self.grdDoses.Row] := cboXDosage.Text;
      UpdateRelated(FALSE);
    end;
    if (pnlMessage.Visible) and (memMessage.TabStop) then
    begin
      pnlMessage.Parent := grdDoses.Parent;
      pnlMessage.TabOrder := grdDoses.TabOrder;
      ActiveControl := memMessage;
    end
    else if grdDoses.Showing then
      ActiveControl := grdDoses
    else
      ActiveControl := cboDosage;
  end
  else
    cmdQuit.Click;
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
procedure TfrmODMedNVA.cboXDosageKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboXDosage.Text = '') then
    cboXDosage.ItemIndex := -1;
  // Fix for CQ: 7545
  if cboXDosage.ItemIndex > -1 then
    cboXDosageClick(Sender)
  else
  begin
    grdDoses.Cells[COL_DOSAGE, cboXDosage.Tag] := cboXDosage.Text;
    UpdateRelated;
  end;
end;

function TfrmODMedNVA.FieldsForDose(ARow: Integer): string;
var
  i: Integer;
  DoseDrug: string;
begin
  Result := Piece(Piece(grdDoses.Cells[COL_DOSAGE, ARow], TAB, 2), U, 4);
  // ; carried forward by WEF 3/14/19 from inpatient complex orders
  // AGP CHANGE 26.33 change for Remedy ticket 87476 fix for quick orders for complex
  // inpatient orders not displaying the correct unit dose in Pharmacy
  // if (not FInptDlg) and (Length(FDrugID) > 0) then
  if Length(FDrugID) > 0 then
  begin
    Result := '';
    DoseDrug := Piece(Piece(grdDoses.Cells[COL_DOSAGE, ARow], TAB, 2), U, 5);
    if DoseDrug = '' then
      DoseDrug := Piece(grdDoses.Cells[COL_DOSAGE, ARow], TAB, 1);
    DoseDrug := DoseDrug + U + FDrugID;
    for i := 0 to Pred(FAllDoses.Count) do
    begin
      // CQ #16957 - Corrected code that would potentially mis-match drugs - JCS
      // if AnsiSameText(DoseDrug, Copy(FAllDoses[i], 1, Length(DoseDrug))) then
      if AnsiSameText(DoseDrug, Pieces(FAllDoses[i], U, 1, 2)) then
      begin
        Result := Piece(FAllDoses[i], U, 3);
        Break;
      end; { if AnsiSameText }
    end; { for i }
    if Result = '' then
      Result := ConstructedDoseFields(Piece(DoseDrug, U, 1));
  end;
end;

function TfrmODMedNVA.FieldsForDrug(const DrugID: string): string;
var
  i, DrugIndex: Integer;
begin
  Result := '';
  DrugIndex := -1;
  for i := 0 to Pred(FAllDrugs.Count) do
  begin
    if AnsiSameText(Piece(FAllDrugs[i], U, 1), DrugID) then
      DrugIndex := i;
  end;
  if DrugIndex > -1 then
    Result := FAllDrugs[DrugIndex];
end;

//; carried forward by WEF 3/14/19 from inpatient complex orders
function TfrmODMedNVA.InpatientSig: string;
var
  Dose, Route, Schedule, Duration, X: string;
  i: Integer;
begin
  case tabDose.TabIndex of
    TI_DOSE:
      begin
        Dose := ValueOf(FLD_LOCALDOSE);
        CheckDecimal(Dose);
        Route := ValueOf(FLD_ROUTE_AB);
        if Route = '' then
          Route := ValueOf(FLD_ROUTE_NM);
        Schedule := ValueOf(FLD_SCHEDULE);
        Result := Dose + ' ' + Route + ' ' + Schedule;
      end;
    TI_COMPLEX:
      begin
        with grdDoses do
          for i := 1 to Pred(RowCount) do
          begin
            if Length(ValueOf(FLD_LOCALDOSE, i)) = 0 then
              Continue;
            if FDrugID = '' then
              Dose := ValueOf(FLD_DOSETEXT, i)
            else
              Dose := ValueOf(FLD_LOCALDOSE, i);
            CheckDecimal(Dose);
            Route := ValueOf(FLD_ROUTE_AB, i);
            if Route = '' then
              Route := ValueOf(FLD_ROUTE_NM, i);
            Schedule := ValueOf(FLD_SCHEDULE, i);
            Duration := ValueOf(FLD_DURATION, i);
            if Length(Duration) > 0 then
              Duration := 'FOR ' + Duration;
            X := Dose + ' ' + Route + ' ' + Schedule + ' ' + Duration;
            if i > 1 then
              Result := Result + ' ' + ValueOf(FLD_SEQUENCE, i - 1) + ' ' + X
            else
              Result := X;
          end; { with grdDoses }
      end; { TI__COMPLEX }
  end; { case }
end;

function TfrmODMedNVA.IsSupplyAndOutPatient: Boolean;
begin
  { CQ: 7331 - Medications - Route - Can not enter any route not listed in Route field in window }
  Result := FALSE;
  if (MedIsSupply(txtMed.Tag)) and (not fInptDlg) then
    Result := TRUE;
end;

// Fix for issue with DefaultDrawing and DrawStyle = gdsThemed
procedure TCaptionStringGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
begin

  if self.Name = 'grdDoses' then
    Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top + 2,
      Piece(Cells[ACol, ARow], TAB, 1))
  else
    inherited;
end;
end.
