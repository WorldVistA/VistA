unit fODMeds;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ComCtrls, ExtCtrls, ORCtrls, Grids, Buttons, uConst,
  ORDtTm,
  Menus,
  uIndications,
  // XUDIGSIGSC_TLB,
  VA508AccessibilityManager, VAUtils, Contnrs, UIndicationsComboBox;

const
  UM_DELAYCLICK = 11037; // temporary for listview click event

type

  TCaptionStringGrid = class(ORCtrls.TCaptionStringGrid)
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
  end;

  tIsSupply = (Supply_NA, Supply_Yes, Supply_No);

  TfrmODMeds = class(TfrmODBase)
    txtMed: TEdit;
    btnSelect: TButton;
    dlgStart: TORDateTimeDlg;
    timCheckChanges: TTimer;
    popDuration: TPopupMenu;
    popDays: TMenuItem;
    popBlank: TMenuItem;
    hours1: TMenuItem;
    minutes1: TMenuItem;
    months1: TMenuItem;
    weeks1: TMenuItem;
    PageControl: TPageControl;
    PageFields: TTabSheet;
    PageMeds: TTabSheet;
    pnlFields: TPanel;
    pnlTop: TPanel;
    lblRoute: TLabel;
    lblSchedule: TLabel;
    txtNSS: TLabel;
    grdDoses: TCaptionStringGrid;
    lblGuideline: TStaticText;
    tabDose: TTabControl;
    cboDosage: TORComboBox;
    cboRoute: TORComboBox;
    cboSchedule: TORComboBox;
    chkPRN: TCheckBox;
    btnXInsert: TButton;
    btnXRemove: TButton;
    pnlXAdminTime: TPanel;
    cboXDosage: TORComboBox;
    cboXRoute: TORComboBox;
    pnlXDuration: TPanel;
    pnlXDurationButton: TKeyClickPanel;
    btnXDuration: TSpeedButton;
    txtXDuration: TCaptionEdit;
    spnXDuration: TUpDown;
    pnlXSchedule: TPanel;
    cboXSchedule: TORComboBox;
    chkXPRN: TCheckBox;
    pnlBottom: TPanel;
    lblComment: TLabel;
    lblDays: TLabel;
    lblQuantity: TLabel;
    lblRefills: TLabel;
    lblPriority: TLabel;
    Image1: TImage;
    chkDoseNow: TCheckBox;
    memComment: TCaptionMemo;
    lblQtyMsg: TStaticText;
    txtSupply: TCaptionEdit;
    spnSupply: TUpDown;
    txtQuantity: TCaptionEdit;
    spnQuantity: TUpDown;
    txtRefills: TCaptionEdit;
    spnRefills: TUpDown;
    grpPickup: TGroupBox;
    radPickWindow: TRadioButton;
    radPickMail: TRadioButton;
    radPickPark: TRadioButton;
    cboPriority: TORComboBox;
    stcPI: TStaticText;
    chkPtInstruct: TCheckBox;
    memPI: TMemo;
    memDrugMsg: TMemo;
    lblAdminSch: TMemo;
    lblAdminTime: TVA508StaticText;
    chkTitration: TCheckBox;
    cboXSequence: TORComboBox;
    pnlMeds: TPanel;
    sptSelect: TSplitter;
    lstQuick: TCaptionListView;
    lstAll: TCaptionListView;
    cboIndication: TIndicationsComboBox;
    lblIndications: TLabel;
    // ckbPickPark: TCheckBox;
    // spbTest: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure tabDoseChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure txtMedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtMedKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtMedChange(Sender: TObject);
    procedure txtMedExit(Sender: TObject);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListViewKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewResize(Sender: TObject);
    procedure lstQuickData(Sender: TObject; Item: TListItem);
    procedure lstQuickDataHint(Sender: TObject; StartIndex, EndIndex: Integer);
    procedure lstAllDataHint(Sender: TObject; StartIndex, EndIndex: Integer);
    procedure lstAllData(Sender: TObject; Item: TListItem);
    procedure lblGuidelineClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure cboScheduleChange(Sender: TObject);
    procedure cboRouteChange(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboDosageClick(Sender: TObject);
    procedure cboDosageChange(Sender: TObject);
    procedure cboScheduleClick(Sender: TObject);
    procedure txtSupplyChange(Sender: TObject);
    procedure txtQuantityChange(Sender: TObject);
    procedure cboRouteExit(Sender: TObject);
    procedure grdDosesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdDosesKeyPress(Sender: TObject; var Key: Char);
    procedure grdDosesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cboXDosageClick(Sender: TObject);
    procedure cboXDosageExit(Sender: TObject);
    procedure cboXRouteClick(Sender: TObject);
    procedure cboXRouteExit(Sender: TObject);
    procedure cboXScheduleClick(Sender: TObject);
    procedure pnlXDurationEnter(Sender: TObject);
    procedure pnlXDurationExit(Sender: TObject);
    procedure txtXDurationChange(Sender: TObject);
    procedure cboXDosageEnter(Sender: TObject);
    procedure cboXDosageChange(Sender: TObject);
    procedure cboXRouteChange(Sender: TObject);
    procedure cboXScheduleChange(Sender: TObject);
    procedure grdDosesExit(Sender: TObject);
    procedure ListViewEnter(Sender: TObject);
    procedure timCheckChangesTimer(Sender: TObject);
    procedure popDurationClick(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure btnXInsertClick(Sender: TObject);
    procedure btnXRemoveClick(Sender: TObject);
    procedure pnlXScheduleEnter(Sender: TObject);
    procedure pnlXScheduleExit(Sender: TObject);
    procedure chkPtInstructClick(Sender: TObject);
    procedure pnlFieldsResize(Sender: TObject);
    procedure chkDoseNowClick(Sender: TObject);
    procedure cboDosageExit(Sender: TObject);
    procedure chkXPRNClick(Sender: TObject);
    procedure memCommentClick(Sender: TObject);
    procedure btnXDurationClick(Sender: TObject);
    procedure chkPRNClick(Sender: TObject);
    procedure grdDosesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdDosesEnter(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboXRouteEnter(Sender: TObject);
    procedure pnlMessageEnter(Sender: TObject);
    procedure pnlMessageExit(Sender: TObject);
    procedure memMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memPIClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure memPIKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtNSSClick(Sender: TObject);
    procedure cboScheduleEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboScheduleExit(Sender: TObject);
    procedure cboXScheduleExit(Sender: TObject);
    procedure cboDosageKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboXDosageKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtSupplyClick(Sender: TObject);
    procedure txtQuantityClick(Sender: TObject);
    procedure txtRefillsClick(Sender: TObject);
    procedure WMClose(var Msg: TWMClose); message WM_CLOSE;
    procedure cboXScheduleEnter(Sender: TObject);
    procedure pnlXAdminTimeClick(Sender: TObject);
    procedure cboXSequenceChange(Sender: TObject);
    procedure cboXSequence1Exit(Sender: TObject);
    procedure cboXSequenceExit(Sender: TObject);
    procedure cboXSequenceEnter(Sender: TObject);
    procedure txtRefillsChange(Sender: TObject);
    procedure QuantityMessageCheck(Tag: Integer);
    procedure pnlXDurationButtonEnter(Sender: TObject);
    procedure cboRouteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboScheduleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboXScheduleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboXSequenceKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboPriorityKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkTitrationClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure cboIndicationChange(Sender: TObject);
    procedure cboIndicationKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboIndicationExit(Sender: TObject);
    // procedure btnNSSClick(Sender: TObject);
  private
    FCloseCalled: Boolean;
    FScheduleChanged: Boolean;
    { selection }
    FMedCache: TObjectList;
    FCacheIEN: Integer;
    FQuickList: Integer;
    FQuickItems: TStringList;
    FChangePending: Boolean;
    FKeyTimerActive: Boolean;
    FActiveMedList: TListView;
    FRowHeight: Integer;
    FFromSelf: Boolean;
    { edit }
    FAllDoses: TStringList;
    FAllDrugs: TStringList;
    FGuideline: TStringList;
    FLastUnits: string;
    FLastSchedule: string;
    FLastDuration: string;
    FLastInstruct: string;
    FLastDispDrug: string;
    FLastTitration: boolean;
    FLastQuantity: Double;
    FLastSupply: Integer;
    FLastPickup: string;
    FSIGVerb: string;
    FSIGPrep: string;
    FDropColumn: Integer;
    FDrugID: string;
    FInptDlg: Boolean; // I believe this stands for InpatientDialog
    FUpdated: Boolean;
    FSuppressMsg: Boolean;
    FPtInstruct: string;
    FAltChecked: Boolean;
    FOutptIV: Boolean;
    FQOQuantity: Double;
    FQODosage: string;
    FNoZERO: Boolean;
    FIsQuickOrder: Boolean;
    FDisabledDefaultButton: TButton;
    FDisabledCancelButton: TButton;
    FShrinked: Boolean;
    FShrinkDrugMsg: Boolean;
    FResizedAlready: Boolean;
    FQOInitial: Boolean;
    FOrigiMsgDisp: Boolean;
    FNSSOther: Boolean;
    { selection }
    FShowPnlXScheduleOk: Boolean;
    FRemoveText: Boolean;
    FSmplPRNChkd: Boolean;
    { Admin Time }
    FAdminTimeLbl: string;
    FMedName: String;
    FNSSAdminTime: string;
    FNSSScheduleType: string;
    FAdminTimeText: string;
    // FOriginalAdminTime: string;
    // FOriginalScheduleIndex: integer;
    FOrderAction: Integer;
    FIndications: TIndications;
    FInSetupDlg: boolean;
    FIsSupply: tIsSupply;
    procedure ChangeDelayed;
    function FindQuickOrder(const X: string): Integer;
    function isUniqueQuickOrder(iText: string): Boolean;
    function GetCacheChunkIndex(idx: Integer): Integer;
    procedure LoadMedCache(First, Last: Integer);
    procedure ScrollToVisible(AListView: TListView);
    procedure StartKeyTimer;
    procedure StopKeyTimer;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    { edit }
    procedure ResetOnMedChange;
    procedure ResetOnTabChange;
    procedure SetControlsInpatient;
    procedure SetControlsOutpatient;
    procedure SetOnMedSelect;
    procedure SetOnQuickOrder;
    procedure SetVisibleCommentRows(Rows: Integer);
    procedure ShowMedSelect;
    procedure ShowMedFields;
    procedure ShowControlsSimple;
    procedure ShowControlsComplex;
    procedure SetDosage(const X: string);
    procedure SetPickup(const X: string);
    procedure SetSchedule(const X: string);
    procedure CheckFormAltDose(DispDrug: Integer);
//    function DurationToDays: Integer;
    function ConstructedDoseFields(const ADose: string;
      PrependName: Boolean = False): string;
    function FieldsForDose(ARow: Integer): string;
    function FieldsForDrug(const DrugID: string): string;
    function FindCommonDrug(DoseList: TStringList): string;
    function FindDoseFields(const Drug, ADose: string): string;
    function InpatientSig: string;
    function OutpatientSig: string;
    procedure UpdateRelated(DelayUpdate: Boolean = True);
    procedure UpdateStartExpires(const CurSchedule: string);
//  **  moved to uOrders.CheckChanges **
//    procedure UpdateRefills(const CurDispDrug: string; CurSupply: Integer);
//    procedure UpdateDefaultSupply(const CurUnits, CurSchedule, CurDuration,
//      CurDispDrug: string; var CurSupply: Integer; var CurQuantity: Double;
//      var SkipQtyCheck: Boolean);
//    procedure UpdateSupplyQuantity(const CurUnits, CurSchedule, CurDuration,
//      CurDispDrug, CurInstruct: string; var CurSupply: Integer;
//      var CurQuantity: Double);
    procedure UpdateDurationControls(FreeText: Boolean);
    function DisableDefaultButton(Control: TWinControl): Boolean;
    function DisableCancelButton(Control: TWinControl): Boolean;
    procedure RestoreDefaultButton;
    procedure RestoreCancelButton;
    function ValueOf(FieldID: Integer; ARow: Integer = -1): string;
    function ValueOfResponse(FieldID: Integer; AnInstance: Integer = 1): string;
    function UpValFor(FieldID, ARow: Integer): string;
    function ValFor(FieldID, ARow: Integer): string;
    function TextDosage(ADosage: string): string;
    // NSS
    function CreateOtherScheduel: string;
    function CreateOtherScheduelComplex: string;
    procedure ShowEditor(ACol, ARow: Integer; AChar: Char);
    procedure DropLastSequence(ASign: Integer = 0);
    procedure DispOrderMessage(const AMessage: string);
    procedure UMDelayClick(var Message: TMessage); message UM_DELAYCLICK;
    procedure UMDelayEvent(var Message: TMessage); message UM_DELAYEVENT;
    procedure UMShowNSSBuilder(var Message: TMessage); message UM_NSSOTHER;
    function IfIsIMODialog: Boolean;
    procedure ValidateInpatientSchedule(ScheduleCombo: TORComboBox);
    // function ValidateRoute(RouteCombo: TORComboBox) : Boolean; Removed based on Site feeback. See CQ: 7518
    function IsSupplyAndOutPatient: Boolean;
    function GetSchedListIndex(SchedCombo: TORComboBox;
      pSchedule: String): Integer;
    procedure DisplayDoseNow(Status: Boolean);
    function lblAdminSchGetText: string;
    procedure lblAdminSchSetText(str: string);
    procedure ShowTitration;
    procedure InitGUI;
    procedure ValidateIndication(IndicationCombo: TORComboBox);
    Function IsSupplyOrder: Boolean;
  protected
    procedure Loaded; override;
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
    procedure updateSig; override;
  public
    ARow1: Integer;
    procedure SetFontSize(FontSize: integer); override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure CheckDecimal(var AStr: string);
    procedure PaPI_GUISetup(ParkingAvailable: Boolean); // PaPI
    function IsAllergyCheckOK(anItemID: Integer): Boolean;
    property MedName: string read FMedName write FMedName;
    property NSSAdminTime: string read FNSSAdminTime write FNSSAdminTime;
    property NSSScheduleType: string read FNSSScheduleType
      write FNSSScheduleType;
  end;

var
  frmODMeds: TfrmODMeds;
  // crypto: IXuDigSigS;

implementation

{$R *.DFM}

uses rCore, uCore, ORFn, rODMeds, rODBase, rOrders, fRptBox, fODMedOIFA,
  uOrders, fOtherSchedule, StrUtils, fFrame, VA508AccessibilityRouter,
  System.Types,
  System.UITypes, uPaPI, fODAllergyCheck, ORNet,
  System.Math, UResponsiveGUI;

const
  { grid columns for complex dosing }
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
  TAB = #9;
  { field identifiers }
  FLD_LOCALDOSE = 1;
  FLD_STRENGTH = 2;
  FLD_DRUG_ID = 3;
  FLD_DRUG_NM = 4;
  FLD_DOSEFLDS = 5;
  FLD_UNITNOUN = 6;
  FLD_TOTALDOSE = 7;
  FLD_DOSETEXT = 8;
  FLD_INSTRUCT = 10;
  FLD_DOSEUNIT = 11;
  FLD_ROUTE_ID = 15;
  FLD_ROUTE_NM = 16;
  FLD_ROUTE_AB = 17;
  FLD_ROUTE_EX = 18;
  FLD_SCHEDULE = 20;
  FLD_SCHED_EX = 21;
  FLD_SCHED_TYP = 22;
  FLD_DURATION = 30;
  FLD_SEQUENCE = 31;
  FLD_TITRATION_ID = 35;
  FLD_TITRATION_NM = 36;
  FLD_MISC_FLDS = 50;
  FLD_SUPPLY = 51;
  FLD_QUANTITY = 52;
  FLD_REFILLS = 53;
  FLD_PICKUP = 55;
  FLD_QTYDISP = 56;
  FLD_SC = 58;
  FLD_PRIOR_ID = 60;
  FLD_PRIOR_NM = 61;
  FLD_START_ID = 70;
  FLD_START_NM = 71;
  FLD_EXPIRE = 72;
  FLD_ANDTHEN = 73;
  FLD_NOW_ID = 75;
  FLD_NOW_NM = 76;
  FLD_COMMENT = 80;
  FLD_PTINSTR = 85;
  FLD_DRUG_ID_INT = 90;
  { dosage type tab index values }
  TI_DOSE = 0;
  TI_RATE = 99;
  TI_COMPLEX = 1;
  { misc constants }
  TIMER_ID = 6902; // arbitrary number
  TIMER_DELAY = 500; // 500 millisecond delay
  TIMER_FROM_DAYS = 1;
  TIMER_FROM_QTY = 2;

  MED_CACHE_CHUNK_SIZE = 100;
  { text constants }
  TX_ADMIN = 'Requested Start: ';
  TX_TAKE = '';
  TX_NO_DEA = 'Provider must have a DEA# or VA# to order this medication';
  TC_NO_DEA = 'DEA# Required';
  TX_NO_MED = 'Medication must be selected.';
  TX_NO_SEQ = 'Missing one or more conjunction.';
  TX_NO_DOSE = 'Dosage must be entered.';
  TX_DOSE_NUM = 'Dosage may not be numeric only';
  TX_DOSE_LEN = 'Dosage may not exceed 60 characters';
  TX_NO_ROUTE = 'Route must be entered.';
  TX_NF_ROUTE = 'Route not found in the Medication Routes file.';
  TX_NO_SCHED = 'Schedule must be entered.';
  TX_NO_PICK = 'A method for picking up the medication must be entered.';
  TX_SCH_QUOTE = 'Schedule must not have quotemarks in it.';
  TX_SCH_MINUS = 'Schedule must not have a dash at the beginning.';
  TX_SCH_SPACE = 'Schedule must have only one space in it.';
  TX_SCH_LEN = 'Schedule must be less than 70 characters.';
  TX_SCH_PRN = 'Schedule cannot include PRN - use Comments to enter PRN.';
  TX_SCH_ZERO = 'Schedule cannot be Q0';
  TX_SCH_LSP = 'Schedule may not have leading spaces.';
  TX_SCH_NS = 'Unable to resolve non-standard schedule.';
  TX_MAX_STOP = 'The maximum expiration for this order is ';
  TX_OUTPT_IV =
    'This patient has not been admitted.  Only IV orders may be entered.';
  TX_QTY_MAIL = 'Quantity for mailed items must be a whole number.';
  TC_RESTRICT = 'Ordering Restrictions';
  TC_GUIDELINE = 'Restrictions/Guidelines';
  TX_QTY_PRE = '>> Quantity Dispensed: ';
  TX_QTY_POST = ' <<';
  TX_NO_PARKING = 'Parking is not available for selected medication';

  { procedures inherited from fODBase --------------------------------------------------------- }

procedure TfrmODMeds.FormCreate(Sender: TObject);
var
  ListCount: Integer;
  X: string;
  sl:TSTringList;
begin
//njc  Caption := 'Discontinue';
  frmFrame.pnlVisit.Enabled := FALSE;
  AutoSizeDisabled := TRUE;
  inherited;
  FAdminTimeText := '';
  btnXDuration.Align := alClient;
  AllowQuickOrder := TRUE;
  FSmplPRNChkd := FALSE; // GE CQ7585

  // CQ 21724 - Nurses should be able to order supplies - jcs
  CheckAuthForMeds(X, EvtDlgID);
  if Length(X) > 0 then
  begin
    InfoBox(X, TC_RESTRICT, MB_OK);
    Close;
    Exit;
  end;
  if DlgFormID = OD_MEDINPT then FInptDlg := True;
  if DlgFormID = OD_CLINICMED then FInptDlg := True;
  if DlgFormID = OD_MEDOUTPT then FInptDlg := False;
  if DlgFormID = OD_MEDNONVA then FInptDlg := False;
  if DlgFormID = OD_MEDS then FInptDlg := OrderForInpatient;
  if XfInToOutNow then FInptDlg := False;
  if XferOuttoInOnMeds then FInptDlg := True;
  if ImmdCopyAct and isUDGroup and (Patient.Inpatient) then FInptDlg := True;
  if ImmdCopyAct and (not isUDGroup) then FInptDlg := False;
  if FInptDlg then FillerID := 'PSI'
  else FillerID := 'PSO';
  FGuideline := TStringList.Create;
  FAllDoses := TStringList.Create;
  FAllDrugs := TStringList.Create;
  StatusText('Loading Dialog Definition');
  if DlgFormID = OD_MEDINPT then Responses.Dialog := 'PSJ OR PAT OE'
  else if DlgFormID = OD_CLINICMED then Responses.Dialog := 'PSJ OR CLINIC OE'
  else if DlgFormID = OD_CLINICINF then Responses.Dialog := 'CLINIC OR PAT FLUID OE'
  else if DlgFormID = OD_MEDOUTPT then Responses.Dialog := 'PSO OERR'
  else if DlgFormID = OD_MEDNONVA then Responses.Dialog := 'PSH OERR'
  else Responses.Dialog := 'PS MEDS'; // loads formatting info
  { if not FInptDlg then } Responses.SetPromptFormat('INSTR', '@');
  StatusText('Loading Schedules');
  // if (Self.EvtID > 0) then LoadSchedules(cboSchedule.Items)
  // else LoadSchedules(cboSchedule.Items, FInptDlg);
//  LoadSchedules(cboSchedule.Items, FInptDlg);
  sl := TStringList.Create;        //  RTC 762237
  LoadSchedules(sl, FInptDlg);     //  RTC 762237
  cboSchedule.Items.Assign(sl);    //  RTC 762237
  sl.Free;                         //  RTC 762237

  StatusText('');
  if FInptDlg then
    SetControlsInpatient
  else
    SetControlsOutpatient;
  CtrlInits.SetControl(cboPriority, 'Priority');
  FSuppressMsg := CtrlInits.DefaultText('DispMsg') = '1';
  FOrigiMsgDisp := FSuppressMsg;
  InitDialog;
  isIMO := IfIsIMODialog;
  if (isIMO) or ((FInptDlg) and (encounter.Location <> Patient.Location)) then
    FAdminTimeText := 'Not defined for Clinic Locations';
  if FInptDlg then
  begin
    txtNSS.Visible := TRUE;
    // cboSchedule.ListItemsOnly := True;
    // cboXSchedule.ListItemsOnly := True;
  end;
  with grdDoses do
  begin
    ColWidths[0] := 8; // select
    ColWidths[1] := 160; // dosage
    ColWidths[2] := 82; // route
    ColWidths[3] := 102; // schedule
    ColWidths[4] := 70; // duration
    if (FInptDlg) and (FAdminTimeText <> 'Not defined for Clinic Locations')
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

  FIndications := TIndications.Create(CtrlInits);

  // IsIMO := IfIsIMODialog; //IMO
  if (Self.EvtID > 0) then
    isIMO := FALSE; // event order can not be IMO order.
  if FInptDlg then
    X := 'UD RX'
  else if (not FInptDlg) and (DlgFormID = OD_MEDNONVA) then
    X := 'NV RX'
  else
    X := 'O RX';
  if FInptDlg and (not OrderForInpatient) and (not isIMO) and (not IsManualEvent) then // IMO
  begin
    FOutptIV := TRUE;
    X := 'IVM RX';
  end;
  // CQ 20854 - Display Supplies Only - JCS
  if IsPSOSupplyDlg(EvtDlgID, 1) then
  begin
    X := 'SPLY';
    Responses.Dialog := 'PSO SUPPLY';
  end;

  if Self.EvtID > 0 then FAdminTimeText := 'To Be Determined';
  if (isIMO = True) then Self.Caption := 'Clinic Medications'
  else if DlgFormID = OD_CLINICMED then Self.Caption := 'Clinic Medications'
  else if FInptDlg = True then Self.Caption := 'Inpatient Medications'
    // CQ 20854 - Display Supplies Only - JCS
  else if IsPSOSupplyDlg(EvtDlgID, 1) then Self.Caption := 'Supplies'
  else if DlgFormID = OD_MEDOUTPT then Self.Caption := 'Outpatient Medications'
  else Self.Caption := 'Medications Orders';
  ListForOrderable(FCacheIEN, ListCount, X);
  lstAll.Items.Count := ListCount;
  FMedCache := TObjectList.Create;
  FQuickItems := TStringList.Create;
  ListForQuickOrders(FQuickList, ListCount, X);
  if ListCount > 0 then
  begin
    lstQuick.Items.Count := ListCount;
    SubsetOfQuickOrders(FQuickItems, FQuickList, 0, 0);
    FActiveMedList := lstQuick;
  end
  else
  begin
    lstQuick.Items.Count := 1;
    ListCount := 1;
    FQuickItems.Add('0^(No quick orders available)');
    FActiveMedList := lstAll;
  end;
  // set the height based on user parameter here
  with lstQuick do
    if ListCount < VisibleRowCount then
      Height := (((Height - 6) div VisibleRowCount) * ListCount) + 6;
//  pnlFields.Height := memOrder.Top - 4 - pnlFields.Top;
  FNoZERO := FALSE;
  FShrinked := FALSE;
  FShrinkDrugMsg := FALSE;
  FResizedAlready := FALSE;
  FShowPnlXScheduleOk := TRUE;
  FRemoveText := TRUE;
  lblAdminTime.TabStop := ScreenReaderActive;
  lblAdminSch.TabStop := ScreenReaderActive;
  memOrder.TabStop := ScreenReaderActive;
end;

procedure TfrmODMeds.FormDestroy(Sender: TObject);
begin
  { selection }
  FQuickItems.Free;
  FMedCache.Free;
  { edit }
  FIndications.Free;
  FGuideline.Free;
  FAllDoses.Free;
  FAllDrugs.Free;
  frmFrame.pnlVisit.Enabled := TRUE;
  inherited;
end;

procedure TfrmODMeds.InitDialog;
{ Executed each time dialog is reset after pressing accept.  Clears controls & responses }
begin
  inherited;
  FLastPickup := ValueOf(FLD_PICKUP);
  Changing := TRUE;
  try
    ResetOnMedChange;
    txtMed.Text := '';
    txtMed.Tag := 0;
    lstQuick.Selected := nil;
    lstAll.Selected := nil;
    if Visible then
      ShowMedSelect;
  finally
    Changing := FALSE;
  end;
  FIsQuickOrder := FALSE;
  FQOQuantity := 0;
  FQODosage := '';
  FQOInitial := FALSE;
  FNSSOther := FALSE;
  // PaPI. update visibility of Park rout based on Encounter locaation and medication
  PaPI_GUISetup(papiParkingAvailable);
  ClearOutPtMedsRPCCache;
end;

procedure TfrmODMeds.SetupDialog(OrderAction: Integer; const ID: string);
var
  AnInstr, OrderID, nsSch, Text, tempOrder, tempSchString, tempSchType,
    AdminTime, X, DEAFailStr, TX_INFO: string;
  i, ix: Integer;
  LocChange: Boolean;
  AResponse: TResponse;

begin
  FInSetupDlg := True;
  try
    inherited;
    FOrderAction := OrderAction;
    if Self.EvtID > 0 then
      DisplayDoseNow(FALSE);
    if XfInToOutNow then
      DisplayGroup := DisplayGroupByName('O RX');
    if (CharAt(ID, 1) = 'X') or (CharAt(ID, 1) = 'C') then
    begin
      OrderID := Copy(Piece(ID, ';', 1), 2, Length(ID));
      CheckExistingPI(OrderID, FPtInstruct);
    end;
    // AGP 27.72 Order Action behave similar to QO this is why Edit and Copy are setting FIsQuickOrder to true
    // this is not the best approach but this should fix the problem with order edit losing the quantity value.
    if ((OrderAction = ORDER_QUICK) or (OrderAction = ORDER_EDIT) or
      (OrderAction = ORDER_COPY)) then
    begin
      FIsQuickOrder := TRUE;
      FQOInitial := TRUE;
    end
    else
    begin
      FIsQuickOrder := FALSE;
      FQOInitial := FALSE;
    end;
    if lblDays.Visible then
      SetVisibleCommentRows(2)
    else
      SetVisibleCommentRows(4);
    if OrderAction in [ORDER_COPY, ORDER_EDIT] then
      Responses.Remove('START', 1);
    if not(OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK]) then
    begin
      ShowMedSelect;
    end else begin
      Changing := TRUE;
      try
        txtMed.Tag := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
        if (OrderAction = ORDER_QUICK) or (OrderAction = ORDER_COPY) then
        begin
          DEAFailStr := '';
          DEAFailStr := DEACheckFailed(txtMed.Tag, FInptDlg);
          while StrToIntDef(Piece(DEAFailStr, U, 1), 0) in [1 .. 6] do
          begin
            // btnSelect.Visible := False;
            btnSelect.Enabled := FALSE;
            case StrToIntDef(Piece(DEAFailStr, U, 1), 0) of
              1:
                TX_INFO := TX_DEAFAIL; // prescriber has an invalid or no DEA#
              2:
                TX_INFO := TX_SCHFAIL + Piece(DEAFailStr, U, 2) + '.';
              // prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
              3:
                TX_INFO := TX_NO_DETOX; // prescriber has an invalid or no Detox#
              4:
                TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr, U, 2) + TX_EXP_DEA2;
              // prescriber's DEA# expired and no VA# is assigned
              5:
                TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr, U, 2) +
                  TX_EXP_DETOX2;
              // valid detox#, but expired DEA#
              6:
                TX_INFO := TX_SCH_ONE;
              // schedule 1's are prohibited from electronic prescription
            end;
            if StrToIntDef(Piece(DEAFailStr, U, 1), 0) = 6 then
            begin
              InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
              AbortOrder := TRUE;
              Exit;
            end;
            if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY
            then
            begin
              DEAContext := TRUE;
              fFrame.frmFrame.mnuFileEncounterClick(Self);
              // select another prescriber and perform DEA check again
              DEAFailStr := '';
              DEAFailStr := DEACheckFailed(txtMed.Tag, FInptDlg);
            end
            else
            begin
              AbortOrder := TRUE;
              Exit;
            end;
          end;
        end;
        if (OrderAction = ORDER_QUICK) and (uOrders.PassDrugTstCall = FALSE) and
          (uOrders.OutptDisp = OutptDisp) and
          (PassDrugTest(txtMed.Tag, 'Q', FALSE) = FALSE) then
          Exit;
        if (OrderAction = ORDER_QUICK) and (uOrders.PassDrugTstCall = FALSE) and
          ((uOrders.ClinDisp = ClinDisp) or (uOrders.InptDisp = InptDisp)) and
          (PassDrugTest(txtMed.Tag, 'Q', TRUE) = FALSE) then
          Exit;
        (* if (OrderAction = ORDER_QUICK) then
          begin
          tempAltIEN := GetQOAltOI;
          if tempAltIEN > 0 then txtMed.Tag := tempAltIEN;
          end; *)
        SetOnMedSelect; // set up for this medication
        SetOnQuickOrder; // insert quick order responses
        ShowMedFields;
        if (OrderAction = ORDER_EDIT) and OrderIsReleased(Responses.EditOrder)
        then
          btnSelect.Enabled := FALSE;
        if (OrderAction in [ORDER_COPY, ORDER_EDIT]) and (Self.EvtID <= 0) then
        // nss
        begin
          if NSSchedule then
          begin
            for ix := 0 to Responses.TheList.Count - 1 do
            begin
              if TResponse(Responses.TheList[ix]).promptid = 'SCHEDULE' then
              begin
                nsSch := TResponse(Responses.TheList[ix]).EVALUE;
                if Length(nsSch) > 0 then
                begin
                  SetSchedule(UpperCase(nsSch));
                  { cboSchedule.SelectByID(nsSch);
                    if cboSchedule.ItemIndex < 0 then
                    begin
                    cboSchedule.Items.Add(nsSch);
                    cboSchedule.ItemIndex := cboSchedule.Items.IndexOf(nsSch);
                    end; }
                end;
              end;
            end;
          end;
        end; // nss
        // if (FInptDlg) and (self.tabDose.TabIndex = TI_DOSE) and (OrderAction in [ORDER_COPY, ORDER_EDIT])  then
        if (FInptDlg) and (OrderAction in [ORDER_COPY, ORDER_EDIT]) then
        begin
          tempOrder := Piece(ID, ';', 1);
          tempOrder := Copy(tempOrder, 2, Length(tempOrder));
          LocChange := DifferentOrderLocations(tempOrder, Patient.Location);
          if LocChange = FALSE then
          begin
            AResponse := Responses.FindResponseByName('ADMIN', 1);
            if AResponse <> nil then
              AdminTime := AResponse.EVALUE;
            if (Self.cboSchedule.ItemIndex > -1) and (AdminTime <> '') then
            begin
              tempSchString := Self.cboSchedule.Items.Strings
                [cboSchedule.ItemIndex];
              SetPiece(tempSchString, U, 4, AdminTime);
              Self.cboSchedule.Items.Strings[cboSchedule.ItemIndex] :=
                tempSchString;
            end;
            if (Self.tabDose.TabIndex = TI_COMPLEX) and
              (Responses.InstanceCount('INSTR') = 1) and (AdminTime <> '') then
            begin
              if Self.cboXSchedule.ItemIndex > -1 then
              begin
                tempSchString := Self.cboXSchedule.Items.Strings
                  [cboXSchedule.ItemIndex];
                SetPiece(tempSchString, U, 4, AdminTime);
                Self.cboXSchedule.Items.Strings[cboXSchedule.ItemIndex] :=
                  tempSchString;
              end;
            end;
            AResponse := Responses.FindResponseByName('SCHTYPE', 1);
            if AResponse <> nil then
              tempSchType := AResponse.EVALUE;
            if Self.cboSchedule.ItemIndex > -1 then
            begin
              if (Piece(Self.cboSchedule.Items.Strings
                [Self.cboSchedule.ItemIndex], U, 3) = 'C') and (tempSchType = 'P')
              then
                Self.chkPRN.Checked := TRUE
              else
              begin
                tempSchString := Self.cboSchedule.Items.Strings
                  [cboSchedule.ItemIndex];
                SetPiece(tempSchString, U, 3, tempSchType);
                Self.cboSchedule.Items.Strings[cboSchedule.ItemIndex] :=
                  tempSchString;
              end;
            end;
            if (Self.tabDose.TabIndex = TI_COMPLEX) and
              (Responses.InstanceCount('INSTR') = 1) then
            begin
              if Self.cboXSchedule.ItemIndex > -1 then
              begin
                if (Piece(Self.cboXSchedule.Items.Strings
                  [Self.cboXSchedule.ItemIndex], U, 3) = 'C') and
                  (tempSchType = 'P') then
                  Self.chkXPRN.Checked := TRUE
                else
                begin
                  tempSchString := Self.cboXSchedule.Items.Strings
                    [cboXSchedule.ItemIndex];
                  SetPiece(tempSchString, U, 3, tempSchType);
                  Self.cboXSchedule.Items.Strings[cboXSchedule.ItemIndex] :=
                    tempSchString;
                end;
              end;
            end;
          end;
          if (FAdminTimeText <> 'Not defined for Clinic Locations') and
            (Self.tabDose.TabIndex = TI_COMPLEX) then
            lblAdminSchSetText('');
          if (FAdminTimeText <> '') and (Self.tabDose.TabIndex = TI_DOSE) then
            lblAdminSchSetText('Admin. Time: ' + FAdminTimeText);
        end;
        if ((OrderAction <> ORDER_COPY) and (OrderAction <> ORDER_EDIT)) or
          (XfInToOutNow = TRUE) or (FIsQuickOrder) then
        begin
            Changing := FALSE;
            try
              UpdateRelated(FALSE); // AGP Change
            finally
              Changing := TRUE;
            end;
          // Need to do the following code to reset the FLastUnits and FLastSchedule in case a free text Dose is found. If the following
          // code is not done than the quantity will reset to zero
          if not FInptDlg then
          begin
            FLastUnits := '';
            FLastSchedule := '';
            FLastInstruct := '';
            // Lasti := Responses.InstanceCount('INSTR');
            // Lasti := Responses.NextInstance('DOSE', 0);
            for i := 1 to Responses.InstanceCount('INSTR') do
            begin
              X := ValueOfResponse(FLD_DOSEUNIT, i);
              FLastUnits := FLastUnits + X + U;
              X := Responses.IValueFor('INSTR', i);
              FLastInstruct := FLastInstruct + X + U;
              X := ValueOfResponse(FLD_SCHEDULE, i);
              FLastSchedule := FLastSchedule + X + U;
            end;
          end;
        end;
      finally
        Changing := FALSE;
      end;
      if ((OrderAction = ORDER_COPY) or (OrderAction = ORDER_EDIT)) and
        (Self.cboSchedule.ItemIndex > -1) then
        UpdateStartExpires(Piece(Self.cboSchedule.Items.Strings
          [Self.cboSchedule.ItemIndex], U, 1));
    end;
    { prevent the SIG from being part of the comments on pre-CPRS prescriptions }
    if (OrderAction in [ORDER_COPY, ORDER_EDIT]) and (cboDosage.Text = '') then
    begin
      OrderID := Copy(Piece(ID, ';', 1), 2, Length(ID));
      AnInstr := TextForOrder(OrderID);
      pnlMessage.TabOrder := 0;
      DispOrderMessage(AnInstr);
      if OrderAction = ORDER_COPY then
        AnInstr := 'Copy: ' + AnInstr
      else
        AnInstr := 'Change: ' + AnInstr;
      Text := AnsiReplaceText(AnInstr, CRLF, '');
      Caption := Text;
      memComment.Clear; // sometimes the sig is in the comment
    end;
    FQOInitial := FALSE;
    ControlChange(Self);
    ClearOutPtMedsRPCCache;
  finally
    FInSetupDlg := False;
  end;
end;

procedure TfrmODMeds.Validate(var AnErrMsg: string);
var
  i, ie, code, CurSupply, tempRefills: Integer;
  CurDispDrug, temp, X: string;
  AUnits, ASchedule, ADuration, ADrug: string;
  TempBool: Boolean;

  procedure SetError(const X: string);
  begin
    if Length(AnErrMsg) > 0 then
      AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + X;
  end;

  procedure ValidateDosage(const X: string);
  begin
    if Length(X) = 0 then
      SetError(TX_NO_DOSE);
  end;

  procedure ValidateRoute(const X: string; NeedLookup: Boolean;
    AnInstance: Integer);
  var
    RouteID, RouteAbbr: string;
  begin
    // if order does not have route, and is not a supply order,
    // and is not an outpaitent order, then display error text to require route
    if (Length(X) = 0) and (Not IsSupplyAndOutPatient) then
    begin
      if cboRoute.Showing = TRUE then
        cboRoute.SetFocus; // CQ: 7467
      SetError(TX_NO_ROUTE);
    end;
    if (Length(X) > 0) and NeedLookup then
    begin
      LookupRoute(X, RouteID, RouteAbbr);
      if RouteID = '0' then
      begin
        if cboRoute.Showing = TRUE then
          cboRoute.SetFocus; // CQ: 7467
        SetError(TX_NF_ROUTE);
      end
      else
        Responses.Update('ROUTE', AnInstance, RouteID, RouteAbbr);
    end;
  end;

  procedure ValidateSchedule(const X: string; AnInstance: Integer);
  const
    SCH_BAD = 0;
    SCH_NO_RTN = -1;
  var
    ValidLevel: Integer;
    ARoute, ADrug, tmpX: string;
  begin
    ARoute := ValueOfResponse(FLD_ROUTE_ID, AnInstance);
    ADrug := ValueOfResponse(FLD_DRUG_ID, AnInstance);
    tmpX := X; // Changed for CQ: 7370 - it was tmpX := Trim(x);
    if Pos(CRLF, tmpX) > 0 then
    begin
      SetError('Schedule cannot contains control characters');
      Exit;
    end;
    if (Length(tmpX) = 0) and (not FInptDlg) then
      SetError(TX_NO_SCHED)
    else if (Length(tmpX) = 0) and FInptDlg and ScheduleRequired(txtMed.Tag,
      ARoute, ADrug) then
      SetError(TX_NO_SCHED);
    if Length(tmpX) > 0 then
    begin
      if FInptDlg then
        ValidLevel := ValidSchedule(tmpX)
      else
        ValidLevel := ValidSchedule(tmpX, 'O');
      (* if FInptDlg and (tmpX <> '') and (cboSchedule.ItemIndex = -1) and
        (self.tabDose.TabIndex = TI_DOSE) then
        //SetError('Unique Schedule Selection Required');
        SetError('More than one schedule starts with "'+tmpX+'". Please select a schedule from the list.'); *)
      if ValidLevel = SCH_NO_RTN then
      begin
        if Pos('"', tmpX) > 0 then
          SetError(TX_SCH_QUOTE);
        if Copy(tmpX, 1, 1) = '-' then
          SetError(TX_SCH_MINUS);
        if Pos(' ', Copy(tmpX, Pos(' ', tmpX) + 1, 999)) > 0 then
          SetError(TX_SCH_SPACE);
        if Length(tmpX) > 70 then
          SetError(TX_SCH_LEN);
        if (Pos('P RN', tmpX) > 0) or (Pos('PR N', tmpX) > 0) then
          SetError(TX_SCH_PRN);
        if Pos('Q0', tmpX) > 0 then
          SetError(TX_SCH_ZERO);
        if TrimLeft(tmpX) <> tmpX then
          SetError(TX_SCH_LSP);
      end;
      if ValidLevel = SCH_BAD then
        SetError(TX_SCH_NS);
    end;
  end;

  procedure ValidateIndication(const X: string; AnInstance: Integer);
  var
    AIndication, tmpX: string;
  begin
    AIndication := ValueOfResponse(FLD_Indications, AnInstance);
    tmpX := X;
    if (Length(tmpX) <= 2) OR (Length(tmpX) > 40) then
      SetError(TX_INDICATION_LIM);
  end;

// PaPI. Checking if the Order List contains items that can't be parked. Begin
  procedure ValidateParkingAvailability(AnInstance: Integer);
  var
    i, iDispDrug: Integer;
    DispDrug, ADrug: String;
    SL: TStringList;
    bParkable: Boolean;
  begin
    if radPickPark.Checked then
    begin
      DispDrug := ValueOfResponse(FLD_DRUG_ID, AnInstance);
      iDispDrug := StrToIntDef(DispDrug, 0);
      if iDispDrug = 0 then
      begin
        SL := TStringList.Create;
        SL.Text := CtrlInits.TextOf('Dispense');
        for i := 0 to SL.Count - 1 do
        begin
          ADrug := Piece(SL[i], U, 1);
          bParkable := papiDrugIsParkable(ADrug);
          if not bParkable then
          begin
            SetError('Parking is not available for "' + Piece(SL[i], U,
              4) + '"');
            break;
          end;
        end;
      end
      else
      begin
        if not papiDrugIsParkable(DispDrug) then
          SetError(TX_NO_PARKING);
      end;
    end;
  end;
// PaPI. ..................................................................end

begin
  inherited;
  ControlChange(Self); // make sure everything is updated

  //If it's a supply order and it's the indication line or
  //if it's not a supply order but the indication is not valid (line or blank)
  if (IsSupplyOrder and FIndications.IsIndicationLine(cboIndication.Text))
          or ((not IsSupplyOrder) and (not FIndications.IsSelectedIndicationValid
          (cboIndication.Text))) then
    SetError(TX_NO_INDICATION);

  if txtMed.Tag = 0 then
    SetError(TX_NO_MED);
  if Responses.InstanceCount('INSTR') < 1 then
    SetError(TX_NO_DOSE);
  if Pos(U, Self.memComment.Text) > 0 then
    SetError('Comments cannot contain a "^".');
  i := Responses.NextInstance('INSTR', 0);
  while i > 0 do
  begin
    if (ValueOfResponse(FLD_DRUG_ID, i) = '') then
    begin
      if not ContainsAlpha(Responses.IValueFor('INSTR', i)) then
      begin
        SetError(TX_DOSE_NUM);
        if tabDose.TabIndex = TI_DOSE then
          cboDosage.SetFocus; // CQ: 7467
      end;
      if Length(Responses.IValueFor('INSTR', i)) > 60 then
      begin
        if Self.tabDose.TabIndex = TI_COMPLEX then
        begin
          SetError('Dosage: ' + Responses.IValueFor('INSTR', i) + CRLF +
            TX_DOSE_LEN);
        end
        else
        begin
          if Self.tabDose.TabIndex = TI_COMPLEX then
          begin
            SetError('Dosage: ' + Responses.IValueFor('INSTR', i) + CRLF +
              TX_DOSE_LEN);
          end
          else
          begin
            SetError(TX_DOSE_LEN);
            cboDosage.SetFocus; // CQ: 7467
          end;
        end;
      end;
    end;
    ValidateRoute(Responses.EValueFor('ROUTE', i), Responses.IValueFor('ROUTE',
      i) = '', i);
    ValidateSchedule(ValueOfResponse(FLD_SCHEDULE, i), i);
    ValidateParkingAvailability(i);
    // PaPI. Validation of availability of Parking for the drug
    i := Responses.NextInstance('INSTR', i);
  end;
  if Self.tabDose.TabIndex = TI_DOSE then
  begin
    if (LeftStr(cboDosage.Text, 1) = '.') then
    begin
      SetError('Dosage must have a leading numeric value');
      Exit;
    end;
  end;
  // AGP Change 26.45 Fix for then/and conjucntion PSI-04-069
  if Self.tabDose.TabIndex = TI_COMPLEX then
  begin
    for i := 1 to Self.grdDoses.RowCount do
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
      if UpperCase(ValFor(COL_SEQUENCE, i)) = 'THEN' then
      begin
        if ValFor(COL_DURATION, i) = '' then
        begin
          SetError('A duration is required when using "Then" as a sequence.');
          Exit;
        end;
      end;
    end;
  end;
  if not FInptDlg then // outpatient stuff
  begin
    if Responses.IValueFor('PICKUP', 1) = '' then
      SetError(TX_NO_PICK);
    temp := Responses.IValueFor('REFILLS', 1);
    for i := 1 to Length(temp) do
      if not CharInSet(temp[i], ['0' .. '9']) then
      begin
        SetError('Refills can only be a number');
        Exit;
      end;
    tempRefills := StrToIntDef(temp, 0);
    if (spnRefills.Max > 0) and (tempRefills > 0) then
    begin
      i := Responses.NextInstance('DOSE', 0);
      while i > 0 do
      begin
        X := ValueOfResponse(FLD_DRUG_ID, i);
        CurDispDrug := CurDispDrug + X + U;
        i := Responses.NextInstance('DOSE', i);
      end;
      CurSupply := StrToIntDef(ValueOfResponse(FLD_SUPPLY), 0);
//      UpdateRefills(CurDispDrug, CurSupply);
      UpdateRefills(Responses, CurDispDrug, CurSupply, EvtForPassDischarge,
                    txtRefills, spnRefills, FUpdated);

    end;
    with txtSupply do
    begin
      txtSupply.Text := Trim(txtSupply.Text);
      Val(txtSupply.Text, ie, code);
      if (code <> 0) and (ie = 0) then
      begin
        SetError(TX_SUPPLY_NINT);
        Exit;
      end;
    end;
    BuildResponseVarsForOutpatient(Responses, AUnits, ASchedule, ADuration, ADrug, True);
    UpdateSupplyQtyRefillErrorMsg(AnErrMsg,
      StrToIntDef(Responses.IValueFor('SUPPLY', 1), 0), tempRefills,
      Responses.IValueFor('QTY', 1), ADrug, AUnits, ASchedule, ADuration,
      Responses.IValueFor('TITR', 1) = '1',
      StrToIntDef(ResponsesAdapter.IValueFor('ORDERABLE', 1), 0), True);

    if (AnErrMsg = '') and HasDaysSupplyComplexDoseConflict(Responses,
      StrToIntDef(txtSupply.Text, 0), '', TempBool) then
      AnErrMsg := TX_INVALID_NO_MESSAGE;

    if AnErrMsg = '' then
      ClearMaxData;
  end;
end;

procedure TfrmODMeds.SetVisibleCommentRows(Rows: Integer);
begin
  memComment.Height := (Abs(Font.Height) + 3) * Rows + 6;
end;

procedure TfrmODMeds.SetControlsInpatient;
var
  aLst: TStringList;
begin
  FillerID := 'PSI';
  aLst := TStringList.Create;
  try
    ODForMedsIn(aLst);
    CtrlInits.LoadDefaults(aLst);
  finally
    FreeAndNil(aLst);
  end;
  lblPriority.Top := pnlFields.Height - cboPriority.Height -
    lblPriority.Height - 3;
  cboPriority.Top := pnlFields.Height - cboPriority.Height;
  lblDays.Visible := FALSE;
  txtSupply.Visible := FALSE;
  spnSupply.Visible := FALSE;
  lblQuantity.Visible := FALSE;
  txtQuantity.Visible := FALSE;
  spnQuantity.Visible := FALSE;
  lblQtyMsg.Visible := FALSE;
  lblRefills.Visible := FALSE;
  txtRefills.Visible := FALSE;
  spnRefills.Visible := FALSE;
  grpPickup.Visible := FALSE;
  lblPriority.Visible := TRUE;
  cboPriority.Visible := TRUE;
  chkDoseNow.Visible := TRUE;
  lblAdminTime.Visible := TRUE;
  lblAdminSch.Visible := TRUE;
  lblAdminSch.Hint := AdminTimeHelpText;
  ShowTitration;
  if cboXSequence.Items.IndexOf('except') > -1 then
    cboXSequence.Items.Delete(cboXSequence.Items.IndexOf('except'));
end;

procedure TfrmODMeds.SetControlsOutpatient;
var
  aLst: TStringList;
begin
  FillerID := 'PSO';
  aLst := TStringList.Create;
  try
    ODForMedsOut(aLst);
    CtrlInits.LoadDefaults(aLst);
  finally
    FreeAndNil(aLst);
  end;
  lblPriority.Top := lblQuantity.Top;
  cboPriority.Top := txtQuantity.Top;
  lblDays.Visible := TRUE;
  txtSupply.Visible := TRUE;
  spnSupply.Visible := TRUE;
  lblQuantity.Visible := TRUE;
  txtQuantity.Visible := TRUE;
  spnQuantity.Visible := TRUE;
  lblQtyMsg.Visible := TRUE;
  lblRefills.Visible := TRUE;
  txtRefills.Visible := TRUE;
  spnRefills.Visible := TRUE;
  grpPickup.Visible := TRUE;
  lblPriority.Visible := TRUE;
  cboPriority.Visible := TRUE;
  chkDoseNow.Visible := FALSE;
  lblAdminTime.Visible := FALSE;
  lblAdminSch.Visible := FALSE;
  ShowTitration;
  if cboXSequence.Items.IndexOf('except') > -1 then
    cboXSequence.Items.Delete(cboXSequence.Items.IndexOf('except'));

end;

{ Navigate medication selection lists ------------------------------------------------------- }

{ txtMed methods (including timers) }

procedure TfrmODMeds.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if (Message.TimerID = TIMER_ID) then
  begin
    StopKeyTimer;
    ChangeDelayed;
  end;
end;

procedure TfrmODMeds.StartKeyTimer;
{ start (or restart) a timer (done on keyup to delay before calling OnKeyPause) }
var
  ATimerID: Integer;
begin
  StopKeyTimer;
  ATimerID := SetTimer(Handle, TIMER_ID, TIMER_DELAY, nil);
  FKeyTimerActive := ATimerID > 0;
  // if can't get a timer, just call the event immediately  F
  if not FKeyTimerActive then
    Perform(WM_TIMER, TIMER_ID, 0);
end;

procedure TfrmODMeds.StopKeyTimer;
{ stop the timer (done whenever a key is pressed or the combobox no longer has focus) }
begin
  if FKeyTimerActive then
  begin
    KillTimer(Handle, TIMER_ID);
    FKeyTimerActive := FALSE;
  end;
end;

function TfrmODMeds.FindQuickOrder(const X: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  if X = '' then
    Exit;
  for i := 0 to Pred(FQuickItems.Count) do
  begin
    if (Result > -1) or (FQuickItems[i] = '') then
      break;
    if AnsiCompareText(X, Copy(Piece(FQuickItems[i], '^', 2), 1, Length(X))) = 0
    then
      Result := i;
  end;
end;

procedure TfrmODMeds.txtMedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: Integer;
  X: string;
begin
  if txtMed.ReadOnly then // v27.50 - RV - CQ #15365
  begin
    if not(Key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END]) then
    // navigation
    begin
      Key := 0;
      Exit;
    end;
  end
  else if (Key in [VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN]) then // navigation
  begin
    FActiveMedList.Perform(WM_KEYDOWN, Key, 0);
    FFromSelf := TRUE;
    // txtMed.Text := FActiveMedList.Selected.Caption;
    txtMed.SelectAll;
    FFromSelf := FALSE;
    Key := 0;
  end
  else if Key = VK_BACK then
  begin
    FFromSelf := TRUE;
    X := txtMed.Text;
    i := txtMed.SelStart;
    if i > 1 then
      Delete(X, i + 1, Length(X))
    else
      X := '';
    txtMed.Text := X;
    if i > 1 then
      txtMed.SelStart := i;
    FFromSelf := FALSE;
  end
  else { StartKeyTimer };
end;

procedure TfrmODMeds.txtMedKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if txtMed.ReadOnly then
    Exit; // v27.50 - RV - CQ #15365
  if not(Key in [VK_PRIOR, VK_NEXT, VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME,
    VK_END]) then
    StartKeyTimer;
end;

procedure TfrmODMeds.txtMedChange(Sender: TObject);
begin
  if FFromSelf then
    Exit;
  FChangePending := TRUE;
end;

procedure TfrmODMeds.ScrollToVisible(AListView: TListView);
var
  Offset: Integer;
  SelRect: TRect;
begin
  AListView.Selected.MakeVisible(FALSE);
  SelRect := AListView.Selected.DisplayRect(drBounds);
  FRowHeight := SelRect.Bottom - SelRect.Top;
  Offset := AListView.Selected.Index - AListView.TopItem.Index;
  TResponsiveGUI.ProcessMessages;
  if Offset > 0 then
    AListView.Scroll(0, (Offset * FRowHeight));
  TResponsiveGUI.ProcessMessages;
end;

procedure TfrmODMeds.ChangeDelayed;
var
  QuickIndex, AllIndex: Integer;
  NewText, OldText, UserText: string;
  UniqueText: Boolean;
begin
  FRemoveText := FALSE;
  UniqueText := FALSE;
  FChangePending := FALSE;
  if (Length(txtMed.Text) > 0) and (txtMed.SelStart = 0) then
    Exit; // don't lookup null
  // lookup item in appropriate list box
  NewText := '';
  UserText := Copy(txtMed.Text, 1, txtMed.SelStart);
  QuickIndex := FindQuickOrder(UserText); // look in quick list first
  AllIndex := IndexOfOrderable(FCacheIEN, UserText);
  // but always synch the full list
  if UserText <> Copy(txtMed.Text, 1, txtMed.SelStart) then
    Exit; // if typing during lookup
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
      // Search Quick List for Uniqueness
      UniqueText := isUniqueQuickOrder(UserText);
    except
      // doing nothing  short term solution related to 117
    end;
  end
  else if AllIndex > -1 then
  begin
    lstAll.Selected := lstAll.Items[AllIndex];
    lstAll.ItemFocused := lstAll.Selected;
    NewText := lstAll.Selected.Caption;
    lstQuick.Selected := nil;
    FActiveMedList := lstAll;
    // List is alphabetical, So compare next Item in list to establish uniqueness.
    if CompareText(UserText, Copy(lstAll.Items[AllIndex + 1].Caption, 1,
      Length(UserText))) <> 0 then
      UniqueText := TRUE;
  end
  else
  begin
    lstQuick.Selected := nil;
    lstAll.Selected := nil;
    FActiveMedList := lstAll;
    NewText := txtMed.Text;
  end;
  if (AllIndex > -1) and (QuickIndex > -1) then // Not Unique Between Lists
    UniqueText := FALSE;
  FFromSelf := TRUE;
  { AutoSelection is only based upon uniquely matching characters.
    Several CQs have been resolved relating to this issue:
    See CQ:
    7326 - Auto complete does not work correctly if user has quick orders in Medication list
    7328 - PSI-05-016: TAM-0205-31170  Med Error due to pre-populated med screen
    6715 PSI-04-044 Orders: NJH-0804-20315  Physician unable to enter medication order
  }
  if UniqueText then
  begin
    OldText := Copy(txtMed.Text, 1, txtMed.SelStart);
    txtMed.Text := NewText;
    // txtMed.SelStart := Length(OldText);  // v24.14 RV
    txtMed.SelStart := Length(UserText); // v24.14 RV
    txtMed.SelLength := Length(NewText);
  end
  else
  begin
    txtMed.Text := UserText;
    txtMed.SelStart := Length(txtMed.Text);
  end;
  FFromSelf := FALSE;
  if lstAll.Selected <> nil then
    ScrollToVisible(lstAll);
  if lstQuick.Selected <> nil then
    ScrollToVisible(lstQuick);
  if Not UniqueText then
  begin
    lstQuick.ItemIndex := -1;
    lstAll.ItemIndex := -1;
  end;
  FRemoveText := TRUE;
end;

procedure TfrmODMeds.txtMedExit(Sender: TObject);
begin
  StopKeyTimer;
  if txtMed.ReadOnly then
    Exit; // v27.50 - RV - CQ #15365
  if not((ActiveControl = lstAll) or (ActiveControl = lstQuick)) then
    ChangeDelayed;
end;

{ lstAll & lstQuick methods }

procedure TfrmODMeds.ListViewEnter(Sender: TObject);
begin
  inherited;
  FActiveMedList := TListView(Sender);
  with Sender as TListView do
  begin
    if Selected = nil then
      Selected := TopItem;
    if Name = 'lstQuick' then
      lstAll.Selected := nil
    else
      lstQuick.Selected := nil;
    ItemFocused := Selected;
    // ScrollToVisible(TListView(Sender));
  end;
end;

procedure TfrmODMeds.ListViewClick(Sender: TObject);
begin
  inherited;
  btnSelect.Visible := TRUE;
  btnSelect.Enabled := TRUE;
  // txtMed.Text := FActiveMedList.Selected.Caption;
  PostMessage(Handle, UM_DELAYCLICK, 0, 0);
end;

procedure TfrmODMeds.UMDelayClick(var Message: TMessage);
begin
  btnSelectClick(Self);
end;

procedure TfrmODMeds.ListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := FALSE;
end;

procedure TfrmODMeds.ListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // This code emulates combo-box behavior on the quick view and all meds view.
  // I think this is a really bad idea because it cannot automatically be undone.
  // Example: pull up a valid medication.  Press change button.  Press tab.  Valid
  // medication is gone, replaced by first quick order entry.  Not good behavior
  // when tabbing through page.
  // If we are going to use an edit box to play combo box, I emphatically suggest
  // that we use a different edit box.
  (*
    with Sender as TListView do
    begin
    if txtMed.Text = Selected.Caption then Exit; // for tabs, arrows, etc.
    FFromSelf := True;
    txtMed.Text := Selected.Caption;
    txtMed.SelectAll;
    FFromSelf := False;
    Key := 0;
    end;
  *)
end;

procedure TfrmODMeds.ListViewResize(Sender: TObject);
var
  NewWidth: Integer;
begin
  if Sender is TListView then
  begin
    NewWidth := TListView(Sender).ClientWidth - 20;
    if NewWidth < 1 then NewWidth := 1; // To avoid an ERangeError!
    if TListView(Sender).Columns.Count > 0 then TListView(Sender).Columns.Items[0].Width := NewWidth;
  end;
end;

{ lstAll Methods (lstAll is TListView) }

procedure TfrmODMeds.Loaded;
begin
  inherited;
  if ScreenReaderSystemActive then
    tabDose.TabStop := TRUE;
end;

// Cache is a list of 100 string lists, starting at idx 0
procedure TfrmODMeds.LoadMedCache(First, Last: Integer);
var
  firstChunk, lastchunk, i: Integer;
  list: TStringList;
  firstMed, LastMed: Integer;

begin
  firstChunk := GetCacheChunkIndex(First);
  lastchunk := GetCacheChunkIndex(Last);
  for i := firstChunk to lastchunk do
  begin
    if (FMedCache.Count <= i) or (not assigned(FMedCache[i])) then
    begin
      while FMedCache.Count <= i do
        FMedCache.Add(nil);
      list := TStringList.Create;
      FMedCache[i] := list;
      firstMed := i * MED_CACHE_CHUNK_SIZE;
      LastMed := firstMed + MED_CACHE_CHUNK_SIZE - 1;
      if LastMed >= lstAll.Items.Count then
        LastMed := lstAll.Items.Count - 1;
      SubsetOfOrderable(list, FALSE, FCacheIEN, firstMed, LastMed);
    end;
  end;
end;

procedure TfrmODMeds.lstAllData(Sender: TObject; Item: TListItem);
var
  X: string;
  chunk: Integer;
  list: TStringList;
begin
  LoadMedCache(Item.Index, Item.Index);
  chunk := GetCacheChunkIndex(Item.Index);
  list := TStringList(FMedCache[chunk]);
  // This is to make sure that the index that is being used is not outside of the stringlist
  If Item.Index mod MED_CACHE_CHUNK_SIZE < list.Count then
  begin
    X := list[Item.Index mod MED_CACHE_CHUNK_SIZE];
    Item.Caption := Piece(X, U, 2);
    Item.Data := Pointer(StrToIntDef(Piece(X, U, 1), 0));
  end;
end;

procedure TfrmODMeds.lstAllDataHint(Sender: TObject;
  StartIndex, EndIndex: Integer);
begin
  LoadMedCache(StartIndex, EndIndex);
end;

{ lstQuick methods (lstQuick is TListView) }

procedure TfrmODMeds.lstQuickData(Sender: TObject; Item: TListItem);
var
  X: string;
begin
  { try
    if FQuickItems[Item.Index] = '' then
    SubsetOfQuickOrders(FQuickItems, FQuickList, Item.Index, Item.Index); }
  X := FQuickItems[Item.Index];
  Item.Caption := Piece(X, U, 2);
  Item.Data := Pointer(StrToIntDef(Piece(X, U, 1), 0));
  { except
    // doing nothing
    end; }
end;

procedure TfrmODMeds.lstQuickDataHint(Sender: TObject;
  StartIndex, EndIndex: Integer);
begin

end;

{ Medication is now selected ---------------------------------------------------------------- }

// NSR 20071211
function TfrmODMeds.IsAllergyCheckOK(anItemID: Integer): Boolean;
var
  aFillerID: string;
  MedReason, MedComment: string;
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

  Result := MedFieldsNeeded(anItemID, MedReason, MedComment, aFillerID);

  if Result then begin
    if (MedReason <> '') then Responses.Reason := MedReason;
    if (MedComment <> '') then Responses.RemComment := MedComment;
  end;
end;
// NSR 20071211

procedure TfrmODMeds.btnSelectClick(Sender: TObject);
var
  MedIEN: Integer;
  QOQuantityStr: string;
  ErrMsg, temp: string;
  DEAFailStr, TX_INFO: string;
begin
  inherited;
  QOQuantityStr := '';
  DEAFailStr := '';
  btnSelect.SetFocus; // let the exit events finish
  Self.MedName := '';
  FIsSupply := Supply_NA;  // reset supply order indicator
  FIsQuickOrder := False;
  FQOInitial := False;
  if pnlMeds.Visible then // display the medication fields
  begin
    Changing := TRUE;
    try
      ResetOnMedChange;
      if (FActiveMedList = lstQuick) and (lstQuick.Selected <> nil) then
      // quick order
      begin
        ErrMsg := '';
        FIsQuickOrder := TRUE;
        FQOInitial := TRUE;
        Responses.QuickOrder := Integer(lstQuick.Selected.Data);
        txtMed.Tag := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
        if (not FInptDlg) and (PassDrugTest(txtMed.Tag, 'N', FALSE) = FALSE)
        then
          Exit;
        if (FInptDlg) and (PassDrugTest(txtMed.Tag, 'N', TRUE) = FALSE) then
          Exit;
        IsActivateOI(ErrMsg, txtMed.Tag);
        if Length(ErrMsg) > 0 then
        begin
          // btnSelect.Visible := False;
          btnSelect.Enabled := FALSE;
          ShowMsg(ErrMsg);
          Exit;
        end;
        DEAFailStr := DEACheckFailed(txtMed.Tag, FInptDlg);
        while StrToIntDef(Piece(DEAFailStr, U, 1), 0) in [1 .. 6] do
        begin
          // btnSelect.Visible := False;
          btnSelect.Enabled := FALSE;
          case StrToIntDef(Piece(DEAFailStr, U, 1), 0) of
            1:
              TX_INFO := TX_DEAFAIL; // prescriber has an invalid or no DEA#
            2:
              TX_INFO := TX_SCHFAIL + Piece(DEAFailStr, U, 2) + '.';
            // prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
            3:
              TX_INFO := TX_NO_DETOX; // prescriber has an invalid or no Detox#
            4:
              TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr, U, 2) + TX_EXP_DEA2;
            // prescriber's DEA# expired and no VA# is assigned
            5:
              TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr, U, 2) +
                TX_EXP_DETOX2;
            // valid detox#, but expired DEA#
            6:
              TX_INFO := TX_SCH_ONE;
            // schedule 1's are prohibited from electronic prescription
          end;
          if StrToIntDef(Piece(DEAFailStr, U, 1), 0) = 6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            txtMed.Tag := 0;
            txtMed.SetFocus;
            Exit;
          end;
          if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY
          then
          begin
            DEAContext := TRUE;
            fFrame.frmFrame.mnuFileEncounterClick(Self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailed(txtMed.Tag, FInptDlg);
          end
          else
          begin
            txtMed.Tag := 0;
            txtMed.SetFocus;
            Exit;
          end;
        end;
        if txtMed.Tag = 0 then
        begin
          // btnSelect.Visible := False;
          btnSelect.Enabled := FALSE;
          txtMed.SetFocus;
          Exit;
        end;

        // NSR 20071211  ************** begin
        if not IsAllergyCheckOK(txtMed.Tag) then
        begin
          btnSelect.Enabled := FALSE;
          txtMed.SetFocus;
          Exit;
        end;
        // NSR 20071211  ************** end

        (* temp := self.MedName;
          tempIEN := txtMed.Tag;
          QOIEN := GetQOOrderableItem(InttoStr(Responses.QuickOrder));
          if QOIEN > 0 then
          begin
          CheckFormularyOI(tempIEN, temp, FInptDlg);
          if tempIEN <> txtMed.Tag then
          begin
          txtMed.Tag := tempIEN;
          txtMed.Text := temp;
          end;
          end; *)
        FAltChecked := TRUE;
        SetOnMedSelect; // set up for this medication
        SetOnQuickOrder; // insert quick order responses
        if Length(txtQuantity.Text) > 0 then
          QOQuantityStr := txtQuantity.Text;
        ShowMedFields;
        if Self.tabDose.TabIndex = TI_COMPLEX then
          Self.lblAdminSch.Visible := FALSE;
        if (txtQuantity.Text = '0') and (Length(QOQuantityStr) > 0) then
        begin
          txtQuantity.Text := QOQuantityStr;
          spnQuantity.Position := StrToIntDef(txtQuantity.Text, 0);
                  // FQOInitial := False;
        end;
      end
      else if (FActiveMedList = lstAll) and (lstAll.Selected <> nil) then
      // orderable item
      begin
        MedIEN := Integer(lstAll.Selected.Data);
        Self.MedName := lstAll.Selected.Caption;
        if (not FInptDlg) and (PassDrugTest(MedIEN, 'N', FALSE) = FALSE) then
          Exit;
        if (FInptDlg) and (PassDrugTest(MedIEN, 'N', TRUE) = FALSE) then
          Exit;
        txtMed.Tag := MedIEN;
        ErrMsg := '';
        IsActivateOI(ErrMsg, txtMed.Tag);
        if Length(ErrMsg) > 0 then
        begin
          // btnSelect.Visible := False;
          btnSelect.Enabled := FALSE;
          ShowMsg(ErrMsg);
          Exit;
        end;
        DEAFailStr := '';
        DEAFailStr := DEACheckFailed(txtMed.Tag, FInptDlg);
        while StrToIntDef(Piece(DEAFailStr, U, 1), 0) in [1 .. 6] do
        begin
          // btnSelect.Visible := False;
          btnSelect.Enabled := FALSE;
          case StrToIntDef(Piece(DEAFailStr, U, 1), 0) of
            1:
              TX_INFO := TX_DEAFAIL; // prescriber has an invalid or no DEA#
            2:
              TX_INFO := TX_SCHFAIL + Piece(DEAFailStr, U, 2) + '.';
            // prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
            3:
              TX_INFO := TX_NO_DETOX; // prescriber has an invalid or no Detox#
            4:
              TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr, U, 2) + TX_EXP_DEA2;
            // prescriber's DEA# expired and no VA# is assigned
            5:
              TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr, U, 2) +
                TX_EXP_DETOX2;
            // valid detox#, but expired DEA#
            6:
              TX_INFO := TX_SCH_ONE;
            // schedule 1's are prohibited from electronic prescription
          end;
          if StrToIntDef(Piece(DEAFailStr, U, 1), 0) = 6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            txtMed.Tag := 0;
            txtMed.SetFocus;
            Exit;
          end;
          if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY
          then
          begin
            DEAContext := TRUE;
            fFrame.frmFrame.mnuFileEncounterClick(Self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailed(txtMed.Tag, FInptDlg);
          end
          else
          begin
            txtMed.Tag := 0;
            txtMed.SetFocus;
            Exit;
          end;
        end;

        if Pos(' NF', Self.MedName) > 0 then
        begin
          temp := Self.MedName;
          CheckFormularyOI(MedIEN, temp, FInptDlg);
          FAltChecked := TRUE;
          txtMed.Text := '';
        end;

        if MedIEN <> txtMed.Tag then
        begin
          txtMed.Tag := MedIEN;
          temp := Self.MedName;
          Self.MedName := txtMed.Text;
          txtMed.Text := temp;
        end;

        // Disable the Selection list before checking the allergies
        // this will prevent accidental click.
        lstAll.Enabled := False; // defect fix 303482
        // NSR 20071211  **************
        if IsAllergyCheckOK(MedIEN) then
        begin
          SetOnMedSelect;
          ShowMedFields;
        end
        else
        begin
          btnSelect.Enabled := FALSE; // defect fix 564813
          Exit;
        end;
        // ******** end of NSR 20071211

      end
      else // no selection
      begin
        // btnSelect.Visible := False;
        btnSelect.Enabled := FALSE;
        MessageBeep(0);
        // btnSelect.Visible := False;
        btnSelect.Enabled := FALSE;
        Exit;
      end;
    finally
      Changing := FALSE;
      // Re-Enable the Selection list
      lstAll.Enabled := True; // defect fix 303482
    end;
    UpdateRelated(FALSE);
    ControlChange(Self);
  end
  else
    ShowMedSelect;
  // show the selection fields
  FNoZERO := FALSE;
  if FQOInitial = TRUE then
    FQOInitial := FALSE;
end;

procedure TfrmODMeds.ResetOnMedChange;
var
  i: Integer;
begin
  Responses.Clear;
  // clear dialog controls individually, since they are on panels
  with grdDoses do
    for i := 1 to Pred(RowCount) do
      Rows[i].Clear;
  cboDosage.Items.Clear;
  cboDosage.Text := '';
  cboRoute.Items.Clear;
  cboRoute.Text := '';
  cboRoute.Hint := cboRoute.Text;
  cboSchedule.ItemIndex := -1;
  cboSchedule.Text := ''; // leave items intact
  cboIndication.ItemIndex := -1;
  cboIndication.Text := '';
  chkPRN.Checked := FALSE;
  memComment.Lines.Clear;
  spnQuantity.Position := 0;
  spnSupply.Position := 0;
  spnRefills.Position := 0;
  txtSupply.Text := '';
  txtQuantity.Text := '';
  txtRefills.Text := '0';
  lblQtyMsg.Caption := '';
  lblQuantity.Caption := 'Quantity';
  chkDoseNow.Checked := FALSE;
  lblAdminTime.Caption := '';
  chkPtInstruct.Checked := FALSE;
  chkPtInstruct.Visible := FALSE;
  memPI.Visible := FALSE;
  stcPI.Visible := FALSE;
  Image1.Visible := FALSE;
  memDrugMsg.Visible := FALSE;
  chkTitration.Checked := FALSE;
  FLastUnits := '';
  FLastSchedule := '';
  FLastDuration := '';
  FLastInstruct := '';
  FLastDispDrug := '-1';
  FLastTitration := False;
  FLastQuantity := 0;
  FLastSupply := 0;
  FAltChecked := FALSE;
  FPtInstruct := '';
end;

procedure TfrmODMeds.ResetOnTabChange;
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
  Responses.Clear('INDICATION');
  cboDosage.ItemIndex := -1;
  cboDosage.Text := '';
  cboRoute.ItemIndex := -1;
  cboRoute.Text := '';
  cboSchedule.ItemIndex := -1;
  cboSchedule.Text := ''; // leave items intact
  cboIndication.ItemIndex := -1;
  chkTitration.Checked := FALSE;
  if FAdminTimeText <> 'Not defined for Clinic Locations' then
    lblAdminSchSetText('');
  spnSupply.Position := 0;
  spnQuantity.Position := 0;
  txtSupply.Text := '';
  txtSupply.Tag := 0;
  txtQuantity.Text := '';
  txtQuantity.Tag := 0;
  lblQtyMsg.Caption := '';
  lblQuantity.Caption := 'Quantity';
  FSmplPRNChkd := chkPRN.Checked; // GE  CQ7585
  chkPRN.Checked := FALSE;
  FLastUnits := '';
  FLastSchedule := '';
  FLastDuration := '';
  FLastInstruct := '';
  FLastDispDrug := '';
  FDrugID := '';
end;

procedure TfrmODMeds.SetOnMedSelect;
var
  i, j: Integer;
  temp, X: string;
  QOPiUnChk: Boolean;
  PKIEnviron: Boolean;
  AResponse: TResponse;
  aLst: TStringList;
begin
  // clear controls?
  cboDosage.Tag := -1;
  txtSupply.Tag := 0;
  txtQuantity.Tag := 0;
  spnQuantity.Tag := 0;
  QOPiUnChk := FALSE;
  PKIEnviron := FALSE;
  if GetPKISite then
    PKIEnviron := TRUE;
  with CtrlInits do
  begin
    // set up CtrlInits for orderable item
    aLst := TStringList.Create;
    try
      OIForMed(aLst, txtMed.Tag, FInptDlg, IncludeOIPI, PKIEnviron);
      LoadOrderItem(aLst);
    finally
      FreeAndNil(aLst);
    end;
    // set up lists & initial values based on orderable item
    SetControl(txtMed, 'Medication');
    if (Self.MedName <> '') then
    begin
      if (txtMed.Text <> Self.MedName) then
      begin
        temp := Self.MedName;
        Self.MedName := txtMed.Text;
        txtMed.Text := temp;
      end
      else
        MedName := '';
    end;
    SetControl(cboDosage, 'Dosage');
    SetControl(cboRoute, 'Route');
    if cboRoute.Items.Count = 1 then
      cboRoute.ItemIndex := 0;
    cboRouteChange(Self);
    X := DefaultText('Schedule');
    // AGP Change 27.72 trying to centralized the schedule setting code
    AResponse := Responses.FindResponseByName('SCHEDULE', 1);
    if (AResponse <> nil) and (AResponse.EVALUE <> '') then
      X := AResponse.EVALUE;
    SetSchedule(UpperCase(X));
    (* if x <> '' then
      begin
      cboSchedule.SelectByID(x);
      if cboSchedule.ItemIndex > -1 then
      AdminTime := Piece(cboSchedule.Items.Strings[cboSchedule.itemindex],U,4);
      if (cboSchedule.ItemIndex < 0) and (RightStr(x,3) = 'PRN')  then
      begin
      self.chkPRN.Checked := true;
      x := Copy(x,1,(Length(x)-3));
      if RightStr(X,1) = ' ' then x := Copy(x,1,(Length(x)-1))
      end;
      cboSchedule.Text := x;
      end; *)
    if Length(ValueOf(FLD_QTYDISP)) > 10 then
    begin
      lblQuantity.Caption := Copy(ValueOf(FLD_QTYDISP), 0, 7) + '...';
      lblQuantity.Hint := ValueOf(FLD_QTYDISP);
    end;
    FAllDoses.Text := TextOf('AllDoses');
    FAllDrugs.Text := TextOf('Dispense');
    FGuideline.Text := TextOf('Guideline');

    FIndications.ResetStringLists;
    FIndications.Load;
    cboIndication.Items.Text := FIndications.GetIndicationList;

    case FGuideline.Count of
      0:
        lblGuideline.Visible := FALSE;
      1:
        begin
          lblGuideline.Caption := FGuideline[0];
          lblGuideline.Visible := TRUE;
        end;
    else
      begin
        lblGuideline.Caption := 'Display Restrictions/Guidelines';
        lblGuideline.Visible := TRUE;
      end;
    end;
    if FInptDlg then
    begin
      if not FResizedAlready then
      begin
        pnlBottom.Height := pnlBottom.Height - lblDays.Height - txtSupply.Height
          - stcPI.Height - memPI.Height + 6;
        FResizedAlready := TRUE;
      end;
      pnlTop.Height := pnlFields.Height - pnlBottom.Height;
      chkDoseNow.Top := memComment.Top + memComment.Height + 1;
      lblPriority.Top := memComment.Top + memComment.Height + 1;
      cboPriority.Top := lblPriority.Top + lblPriority.Height;
      lblAdminSch.Left := chkDoseNow.Left;
      lblAdminSch.Top := chkDoseNow.Top + chkDoseNow.Height - 1;
      lblAdminSch.Height := (MainFontHeight * 3) + 3;
      lblAdminSch.Width := cboPriority.Left - lblAdminSch.Left - 5;
      lblAdminTime.Left := lblAdminSch.Left;
      lblAdminTime.Top := lblAdminSch.Top + lblAdminSch.Height - 1;
      if lblAdminTime.Tag = 0 then
      begin
        pnlBottom.Height := pnlBottom.Height + lblAdminTime.Height - ((Font.Size - 6) div 2);
        lblAdminTime.Tag := 1;
      end;
      if Self.tabDose.TabIndex = TI_DOSE then
        lblAdminSchSetText('')
      else
      begin
        if FAdminTimeText = 'Not defined for Clinic Locations' then
          lblAdminSchSetText('Admin. Time: ' + FAdminTimeText)
        else
          Self.lblAdminSch.Visible := FALSE;
      end;
    end
    else
    begin
      DEASig := '';
      if GetPKISite then
        DEASig := DefaultText('DEASchedule');
      FSIGVerb := DefaultText('Verb');
      if Length(FSIGVerb) = 0 then
        FSIGVerb := TX_TAKE;
      FSIGPrep := DefaultText('Preposition');
      if FLastPickup <> '' then
        SetPickup(FLastPickup)
      else
        SetPickup(DefaultText('Pickup')); // PaPI: "P"
      SetControl(txtRefills, 'Refills');
      spnRefills.Position := StrToIntDef(txtRefills.Text, 0);
      for j := 0 to Responses.TheList.Count - 1 do
      begin
        if (TResponse(Responses.TheList[j]).promptid = 'PI') and
          (TResponse(Responses.TheList[j]).EVALUE = ' ') then
        begin
          QOPiUnChk := TRUE;
          break;
        end;
      end;
      // if Length(FPtInstruct) = 0 then
      if FPtInstruct = '' then
        FPtInstruct := TextOf('PtInstr');
      for i := 1 to Length(FPtInstruct) do
        if Ord(FPtInstruct[i]) < 32 then
          FPtInstruct[i] := ' ';
      FPtInstruct := TrimRight(FPtInstruct);
      if Length(FPtInstruct) > 0 then
      begin
        // chkPtInstruct.Caption := FPtInstruct;
        if memPI.Lines.Count > 0 then
          memPI.Lines.Clear;
        memPI.Lines.Add(FPtInstruct);
        chkPtInstruct.Visible := TRUE;
        chkPtInstruct.Checked := TRUE;
        stcPI.Visible := TRUE;
        memPI.Visible := TRUE;
        if FShrinked then
        begin
          pnlBottom.Height := pnlBottom.Height + memPI.Height +
            stcPI.Height + 2;
          FShrinked := FALSE;
        end;
        if QOPiUnChk then
          chkPtInstruct.Checked := FALSE;
      end
      else
      begin
        chkPtInstruct.Visible := FALSE;
        chkPtInstruct.Checked := FALSE;
        stcPI.Visible := FALSE;
        memPI.Visible := FALSE;
        if not FShrinked then
        begin
          pnlBottom.Height := pnlBottom.Height - stcPI.Height -
            memPI.Height - 2;
          FShrinked := TRUE;
        end;
      end;
    end;
    pnlMessage.TabOrder := cboDosage.TabOrder + 1;
    DispOrderMessage(TextOf('Message'));
  end;
end;

procedure TfrmODMeds.SetOnQuickOrder;
var
  AResponse: TResponse;
  X, LocRoute, TempSch, DispGrp, SchType: string;
  i, j, k, l, NumRows, DispDrug: Integer;
  InstanceNames: array of String;
begin
  // txtMed already set by SetOnMedSelect
  with Responses do
  begin
    NumRows := TotalRows;
    if (NumRows > 1) or ((NumRows = 1) and (Responses.InstanceCount('DAYS') > 0))
    then // complex dose
    begin
      if FInptDlg then
      begin
        SetLength(InstanceNames, 6);
        InstanceNames[5] := 'ADMIN';
      end
      else
      begin
        SetLength(InstanceNames, 5);
      end;
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
          // AGP Change 26.41 for CQ 9102 PSI-05-015 affect copy and edit functionality
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
        SetSchedule(UpperCase(IValueFor('SCHEDULE', i)));
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
        if FInptDlg then
        begin
          if IValueFor('ADMIN', i) <> '' then
            grdDoses.Cells[COL_ADMINTIME, i] := IValueFor('ADMIN', i)
          else if (cboSchedule.ItemIndex > -1) and (chkPRN.Checked = FALSE) then
            grdDoses.Cells[COL_ADMINTIME, i] :=
              Piece(cboSchedule.Items.Strings[cboSchedule.ItemIndex], U, 4)
          else
            grdDoses.Cells[COL_ADMINTIME, i] := '';
          if grdDoses.Cells[COL_ADMINTIME, i] = '' then
            grdDoses.Cells[COL_ADMINTIME, i] := 'Not Defined';
          if FAdminTimeText <> '' then
            grdDoses.Cells[COL_ADMINTIME, i] := FAdminTimeText;
          // done to prevent admin time showing up in schedules that should not have admin times. Also remove Not Defined for schedule
          // should not show the admin time
          if (cboSchedule.ItemIndex > -1) or (chkPRN.Checked = TRUE) then
          begin
            SchType := '';
            if (cboSchedule.ItemIndex > -1) then
              SchType :=
                Piece(cboSchedule.Items.Strings[cboSchedule.ItemIndex], U, 3);
            if (SchType = 'P') or (SchType = 'O') or (SchType = 'OC') or
              (chkPRN.Checked = TRUE) then
              grdDoses.Cells[COL_ADMINTIME, i] := '';
          end;
        end;
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
      SetControl(cboRoute, 'ROUTE', 1);
      SetSchedule(UpperCase(IValueFor('SCHEDULE', 1)));
      if (cboSchedule.Text = '') and (FIsQuickOrder) and (NSSchedule = FALSE)
      then
      begin
        cboSchedule.SelectByID(TempSch);
        cboSchedule.Text := TempSch;
      end;
      if (cboSchedule.Text = '') and (FIsQuickOrder) and (NSSchedule = TRUE)
      then
        cboSchedule.ItemIndex := -1;
      if ((cboSchedule.Text = 'OTHER') and FIsQuickOrder) then
        FNSSOther := TRUE;
      DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID), 0);
      if Length(ValueOf(FLD_QTYDISP)) > 10 then
      begin
        lblQuantity.Caption := Copy(ValueOf(FLD_QTYDISP), 0, 7) + '...';
        lblQuantity.Hint := ValueOf(FLD_QTYDISP);
      end;
      if DispDrug > 0 then
      begin
        DispOrderMessage(DispenseMessage(DispDrug));
        X := QuantityMessage(DispDrug);
      end;
      if Length(X) > 0 then
        lblQtyMsg.Caption := TX_QTY_PRE + X + TX_QTY_POST
      else
        lblQtyMsg.Caption := '';
    end;
    SetControl(memComment, 'COMMENT', 1);
    SetControl(cboIndication, 'INDICATION', 1);
    SetControl(cboPriority, 'URGENCY', 1);
    SetControl(chkTitration, 'TITR', 1);

    if FInptDlg then
    begin
      // blj 9 December 2020 - remove event handler manipulation code.
      SetControl(chkDoseNow, 'NOW', 1);
    end
    else
    begin
      SetControl(txtSupply, 'SUPPLY', 1);
      txtSupply.Text := Trim(txtSupply.Text);
      spnSupply.Position := StrToIntDef(txtSupply.Text, 0);
      if Length(IValueFor('QTY', 1)) > 0 then
      begin
        FQOQuantity := StrToFloat(IValueFor('QTY', 1));
        txtQuantity.Text := FloatToStr(FQOQuantity);
        spnQuantity.Position := StrToIntDef(txtQuantity.Text, 0);
      end;
      SetControl(txtQuantity, 'QTY', 1);
      spnQuantity.Position := StrToIntDef(txtQuantity.Text, 0);
      SetControl(txtRefills, 'REFILLS', 1);
      spnRefills.Position := StrToIntDef(txtRefills.Text, 0);
      AResponse := Responses.FindResponseByName('PICKUP', 1);
      if AResponse <> nil then
        SetPickup(AResponse.IValue);
      if (FIsQuickOrder) and (FOrderAction = ORDER_QUICK) then
      begin
        if not QOHasRouteDefined(Responses.QuickOrder) then
        begin
          LocRoute := GetPickupForLocation(IntToStr(encounter.Location));
          SetPickup(LocRoute);
        end;
      end;
      DispGrp := NameOfDGroup(Responses.DisplayGroup);
      if (AResponse = nil) or
        ((StrToIntDef(Piece(Responses.CopyOrder, ';', 1), 0) > 0) and
        AnsiSameText('Out. Meds', DispGrp)) then
      begin
        LocRoute := GetPickupForLocation(IntToStr(encounter.Location));
        SetPickup(LocRoute);
      end;
      if ValueOf(FLD_PICKUP) = '' then
        SetPickup(FLastPickup);
      // AResponse := Responses.FindResponseByName('SC',     1);
      Responses.FindResponseByName('SC', 1);
    end; { if FInptDlg..else }
  end; { with }
  if (FInptDlg) then
  begin
    X := ValueOfResponse(FLD_SCHEDULE, 1);
    if Length(X) > 0 then
      UpdateStartExpires(X);
  end;
  SetLength(InstanceNames, 0);
end;

procedure TfrmODMeds.ShowMedSelect;
begin
  txtMed.SelStart := Length(txtMed.Text);
  ChangeDelayed; // synch the listboxes with display
  PageControl.ActivePage := PageMeds;
  InitGUI;
  txtMed.SelectAll;
  if Visible and Enabled then txtMed.SetFocus;
  FDrugID := '';
end;

procedure TfrmODMeds.ShowTitration;
var
  i: integer;
  Titrate: boolean;
begin
  Titrate := False;
  if (not FInptDlg) and (tabDose.TabIndex = TI_COMPLEX) then
  begin
    for i := 1 to grdDoses.RowCount do
    begin
      if UpValFor(COL_SEQUENCE, i) = 'THEN' then
      begin
        Titrate := True;
        chkTitration.Top := memComment.BoundsRect.Bottom + 2;
        chkTitration.Width := TextWidthByFont(MainFont.Handle, chkTitration.Caption) + 23;
        chkTitration.Left := memComment.BoundsRect.Right - chkTitration.Width - 6;
        break;
      end;
    end;
  end;
  chkTitration.Visible := Titrate;
end;

procedure TfrmODMeds.ShowMedFields;
var
  NumRows: Integer;
begin
  PageControl.ActivePage := PageFields;
  InitGUI;
  NumRows := Responses.TotalRows;
  if (NumRows > 1) or ((NumRows = 1) and (Responses.InstanceCount('DAYS') > 0)) then
  begin
    ShowControlsComplex
  end else begin
    ShowControlsSimple;
  end;
end;

procedure TfrmODMeds.ShowControlsSimple;
// var
// dosagetxt: string;
begin
  // Commented out, no longer using CharsNeedMatch Property
  { NumCharsForMatch := 0;
    for i := 0 to cboDosage.Items.Count - 1 do         //find the shortest unit dose text on fifth piece
    begin
    dosagetxt := Piece(cboDosage.Items[i],'^',5);
    if Length(dosagetxt) < 1 then break;
    if NumCharsForMatch = 0 then
    NumCharsForMatch := Length(dosagetxt);
    if (NumCharsForMatch > Length(dosagetxt)) then
    NumCharsForMatch := Length(dosagetxt);
    end;
    if NumCharsForMatch > 1 then
    cboDosage.CharsNeedMatch := NumCharsForMatch - 1;
    if NumCharsForMatch > 5 then
    cboDosage.CharsNeedMatch := 5; }
  tabDose.TabIndex := TI_DOSE;
  grdDoses.Visible := FALSE;
  btnXInsert.Visible := FALSE;
  btnXRemove.Visible := FALSE;
  cboDosage.Visible := TRUE;
  lblRoute.Visible := TRUE;
  cboRoute.Visible := TRUE;
  lblSchedule.Visible := TRUE;
  cboSchedule.Visible := TRUE;
  if FInptDlg = TRUE then
    lblAdminSch.Visible := TRUE
  else
    lblAdminSch.Visible := FALSE;
  chkPRN.Visible := TRUE;
  if Visible and Enabled then ActiveControl := cboDosage;
  ShowTitration;
end;

procedure TfrmODMeds.ShowControlsComplex;

  procedure MoveCombo(SrcCombo, DestCombo: TORComboBox;
    CompSch: Boolean = FALSE); // AGP Changes 26.12 PSI-04-63
  var
    cnt, i, Index: Integer;
    node, Text: string;
  begin
    if (CompSch = FALSE) or not(FInptDlg) then
    begin
      DestCombo.Items.Clear;
      FastAssign(SrcCombo.Items, DestCombo.Items);
      DestCombo.ItemIndex := SrcCombo.ItemIndex;
      DestCombo.Text := Piece(SrcCombo.Text, TAB, 1);
    end;
    if (CompSch = TRUE) and (FInptDlg) then // AGP Changes 26.12 PSI-04-63
    begin
      // AGP change 26.34 CQ 7201,6902 fix the problem with one time schedule still showing for inpatient complex orders
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
  MoveCombo(cboSchedule, cboXSchedule, TRUE); // AGP Changes 26.12 PSI-04-063
  grdDoses.Visible := TRUE;
  btnXInsert.Visible := TRUE;
  btnXRemove.Visible := TRUE;
  cboDosage.Visible := FALSE;
  lblRoute.Visible := FALSE;
  cboRoute.Visible := FALSE;
  lblSchedule.Visible := FALSE;
  cboSchedule.Visible := FALSE;
  chkPRN.Visible := FALSE;
  ShowTitration;
  FDropColumn := -1;
  pnlFieldsResize(Self);
  ActiveControl := grdDoses;
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

procedure TfrmODMeds.SetDosage(const X: string);
var
  i, DoseIndex: Integer;
begin
  DoseIndex := -1;
  with cboDosage do
  begin
    ItemIndex := -1;
    for i := 0 to Pred(Items.Count) do
      if UpperCase(Piece(Items[i], U, 5)) = UpperCase(X) then
      begin
        DoseIndex := i;
        break;
      end;
    if DoseIndex < 0 then
      Text := X
      (* if ((DoseIndex < 0) and (not IsTransferAction)) then Text := x
        else if ((DoseIndex < 0) and IsTransferAction) and (DosageTab = False) then Text := ''
        else if ((DoseIndex < 0) and IsTransferAction) and (DosageTab = True) then Text := x *)
    else
      ItemIndex := DoseIndex;
  end;
end;

procedure TfrmODMeds.SetPickup(const X: string);
begin
  radPickMail.Checked := FALSE;
  radPickWindow.Checked := FALSE;
  radPickPark.Checked := FALSE; // PaPI
  // ckbPickPark.Checked   := FALSE; // PaPI
  case CharAt(X, 1) of
    'M':
      radPickMail.Checked := TRUE;
    'W':
      radPickWindow.Checked := TRUE;
    'P':
      if papiParkingAvailable then // PaPI
      begin
        radPickPark.Checked := TRUE; // PaPI
//         ckbPickPark.Checked   := TRUE; // PaPI
      end;
  else { leave all unchecked }
  end;
end;

procedure TfrmODMeds.SetSchedule(const X: string);
var
  NonPRNPart, TempSch, tempText: string;
begin
  // AGP Change 27.72 if schedule matches why goes through and reprocess the same info?
  if cboSchedule.ItemIndex > -1 then
  begin
    tempText := Piece(cboSchedule.Items.Strings[cboSchedule.ItemIndex], U, 1);
    if tempText = X then
      Exit;
    if (Pos('PRN', X) > 0) and (chkPRN.Checked = TRUE) then
    begin
      NonPRNPart := Trim(Copy(X, 1, Pos('PRN', X) - 1));
      if NonPRNPart = tempText then
        Exit;
    end;
  end;
  cboSchedule.ItemIndex := -1;
  cboSchedule.Text := '';
  if chkPRN.Checked = TRUE then
    chkPRN.Checked := FALSE;
  cboSchedule.SelectByID(X);
  if cboSchedule.ItemIndex > -1 then
    Exit;
  if (X = ' PRN') or (X = 'PRN') then
  begin
    chkPRN.Checked := TRUE;
    Exit;
  end;
  // if cboSchedule.ItemIndex < 0 then
  // begin
  // if NSSchedule then
  // begin
  // cboSchedule.Text := '';
  // end
  if FInptDlg then
  begin
    if (Pos('@', X) > 0) then
    begin
      TempSch := Piece(X, '@', 2);
      cboSchedule.SelectByID(TempSch);
      if cboSchedule.ItemIndex > -1 then
      begin
        TempSch := Piece(X, '@', 1) + '@' + cboSchedule.Items.Strings
          [cboSchedule.ItemIndex];
        cboSchedule.Items.Add(TempSch);
        cboSchedule.Text := (Piece(TempSch, U, 1));
        cboSchedule.SelectByID(Piece(TempSch, U, 1));
        Exit;
      end;
      if Pos('PRN', TempSch) > 0 then
      begin
        NonPRNPart := Trim(Copy(TempSch, 1, Pos('PRN', TempSch) - 1));
        cboSchedule.SelectByID(NonPRNPart);
        if cboSchedule.ItemIndex > -1 then
        begin
          TempSch := Piece(X, '@', 1) + '@' + cboSchedule.Items.Strings
            [cboSchedule.ItemIndex];
          cboSchedule.Items.Add(TempSch);
          cboSchedule.Text := (Piece(TempSch, U, 1));
          cboSchedule.SelectByID(Piece(TempSch, U, 1));
          chkPRN.Checked := TRUE;
          Exit;
        end
        else
        begin
          NonPRNPart := Trim(Copy(X, 1, Pos('PRN', X) - 1));
          chkPRN.Checked := TRUE;
          TempSch := NonPRNPart + U + U + U + Piece(NonPRNPart, '@', 2);
          cboSchedule.Items.Add(TempSch);
          cboSchedule.SelectByID(Piece(TempSch, U, 1));
          Exit;
        end;
      end;
      cboSchedule.Items.Add(X + U + U + U + Piece(X, '@', 2));
      cboSchedule.Text := X;
      cboSchedule.SelectByID(X);
      Exit;
    end
    else if Pos('PRN', X) > 0 then
    begin
      NonPRNPart := Trim(Copy(X, 1, Pos('PRN', X) - 1));
      chkPRN.Checked := TRUE;
      cboSchedule.SelectByID(NonPRNPart);
      if cboSchedule.ItemIndex > -1 then
        Exit;
    end;
  end
  else if Pos('PRN', X) > 0 then
  begin
    NonPRNPart := Trim(Copy(X, 1, Pos('PRN', X) - 1));
    chkPRN.Checked := TRUE;
    cboSchedule.SelectByID(NonPRNPart);
    if cboSchedule.ItemIndex > -1 then
      Exit;
    cboSchedule.Items.Add(NonPRNPart);
    cboSchedule.Text := NonPRNPart;
    cboSchedule.SelectByID(NonPRNPart);
    Exit;
  end;
  cboSchedule.Items.Add(X);
  cboSchedule.Text := X;
  cboSchedule.SelectByID(X);
end;

{ Medication edit --------------------------------------------------------------------------- }
procedure TfrmODMeds.tabDoseChange(Sender: TObject);
var
  // text,x, tmpsch: string;
  Text, tmpAdmin, X: string;
  reset: Integer;
begin
  inherited;
  reset := 0;
  // AGP change for CQ 6521 added warning message
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
    TI_DOSE:
      begin
        cboXSchedule.Clear; // Added to Fix CQ: 9603
        cboXDosage.Clear;
        // clean up responses?
        FSuppressMsg := FOrigiMsgDisp;
        ShowControlsSimple;
        if reset = 0 then
          ResetOnTabChange;
        txtNSS.Left := lblSchedule.Left + lblSchedule.Width + 2;
        if (FInptDlg) then
          txtNSS.Visible := TRUE
        else
          txtNSS.Visible := FALSE;
        cboXRoute.Hide; // Added to Fix CQ: 7640

        cboIndication.Items.Clear;
        cboIndication.Items.Text := FIndications.GetIndicationList;
        ControlChange(Self);
      end;
    TI_RATE:
      begin
        // for future use...
      end;
    TI_COMPLEX:
      begin
        lblAdminTime.Visible := not chkDoseNow.Checked;
        if (tabDose.TabIndex = TI_COMPLEX) and chkDoseNow.Checked then
        begin
          if (InfoBox
            ('Give first dose off of standard administration schedule is in addition to those listed in the table.'
            + ' Please adjust the duration of the first row, if necessary.',
            'Give Additional Dose Now for Complex Order', MB_OKCANCEL or
            MB_ICONWARNING) = IDCANCEL) then
          begin
            chkDoseNow.Checked := FALSE;
            Exit;
          end;
        end;

        FSuppressMsg := FOrigiMsgDisp;
        if reset = 1 then
          Exit;
        (* AGP Change admin wrap 27.73
          tmpAdmin := Piece(self.lblAdminSch.text, ':', 2);
          tmpAdmin := Copy(tmpAdmin,2,Length(tmpAdmin)); *)
        tmpAdmin := lblAdminSchGetText;
        if FAdminTimeText <> '' then
        begin
          tmpAdmin := FAdminTimeText;
          if FAdminTimeText <> 'Not defined for Clinic Locations' then
            Self.lblAdminSch.Visible := FALSE;
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
        // AGP Change 27.1 handle PRN not showing in schedule panel if a dose is not selected.
        if FSmplPRNChkd then
        begin
          pnlXSchedule.Tag := 1;
          Self.chkXPRN.Checked := TRUE;
        end;
        if FInptDlg then
          UpdateStartExpires(ValFor(VAL_SCHEDULE, 1));

        cboIndication.Items.Clear;
        cboIndication.Items.Text := FIndications.GetIndicationList;
        ControlChange(Self);
      end; { TI_COMPLEX }
  end; { case }
  if ScreenReaderSystemActive then
    GetScreenReader.Speak(tabDose.Tabs[tabDose.TabIndex] + ' tab');
end;

function TfrmODMeds.lblAdminSchGetText: string;
var
  tempstr: string;
  i: Integer;
begin
  Result := '';
  if Self.lblAdminSch.Text = '' then
    Exit;
  tempstr := '';
  if Self.lblAdminSch.Lines.Count > 1 then
  begin
    for i := 0 to Self.lblAdminSch.Lines.Count - 1 do
      tempstr := tempstr + Self.lblAdminSch.Lines.Strings[i];
  end
  else if Self.lblAdminSch.Lines.Count = 1 then
  begin
    tempstr := Self.lblAdminSch.Text;
  end;
  Result := Piece(tempstr, ':', 2);
  Result := Copy(Result, 2, Length(Result));
end;

procedure TfrmODMeds.lblAdminSchSetText(str: string);
var
  cutoff: Integer;
begin
  cutoff := lblAdminSch.Width div MainFontWidth;
  if Length(str) > cutoff then
    Self.lblAdminSch.Text := Copy(str, 1, cutoff) + CRLF +
      Copy(str, cutoff + 1, Length(str))
  else
    Self.lblAdminSch.Text := str;
end;

procedure TfrmODMeds.lblGuidelineClick(Sender: TObject);
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
  // if FGuideline.Count > 0 then InfoBox(FGuideline.Text, 'Restrictions/Guidelines', MB_OK);
end;

{ cboDosage ------------------------------------- }

procedure TfrmODMeds.CheckFormAltDose(DispDrug: Integer);
var
  OI: Integer;
  OIName: string;
begin
  if FAltChecked or (DispDrug = 0) then
    Exit;
  OI := txtMed.Tag;
  OIName := txtMed.Text;
  CheckFormularyDose(DispDrug, OI, OIName, FInptDlg);
  if OI <> txtMed.Tag then
  begin
    ResetOnMedChange;
    txtMed.Tag := OI;
    txtMed.Text := OIName;
    SetOnMedSelect;
  end;
end;

procedure TfrmODMeds.cboDosageClick(Sender: TObject);
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
  UpdateRelated(FALSE);
  DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID), 0);
  if DispDrug > 0 then
  begin
    if not FSuppressMsg then
    begin
      DispOrderMessage(DispenseMessage(DispDrug));
    end;
    X := QuantityMessage(DispDrug);
  end
  else
    X := '';
  if Length(ValueOf(FLD_QTYDISP)) > 10 then
  begin
    lblQuantity.Caption := Copy(ValueOf(FLD_QTYDISP), 0, 7) + '...';
    lblQuantity.Hint := ValueOf(FLD_QTYDISP);
  end
  else
  begin
    lblQuantity.Caption := ValueOf(FLD_QTYDISP);
    lblQuantity.Hint := '';
  end;
  if Length(X) > 0 then
    lblQtyMsg.Caption := TX_QTY_PRE + X + TX_QTY_POST
  else
    lblQtyMsg.Caption := '';
  with cboDosage do
    if (ItemIndex > -1) and (Piece(Items[ItemIndex], U, 3) = 'NF') then
      CheckFormAltDose(DispDrug);
end;

procedure TfrmODMeds.cboDosageChange(Sender: TObject);
var
  temp1, temp2: string;
  Count: Integer;
begin
  inherited;
  Count := Pos(U, cboDosage.Text);
  if Count > 0 then
  begin
    temp1 := Copy(cboDosage.Text, 0, Count - 1);
    temp2 := Copy(cboDosage.Text, Count + 1, Length(cboDosage.Text));
    InfoBox('An ^ is not allowed in the dosage value', 'Dosage Warning', MB_OK);
    cboDosage.Text := temp1 + temp2;
  end;
  UpdateRelated;
end;

procedure TfrmODMeds.cboDosageExit(Sender: TObject);
var
  str: string;
begin
  inherited;
  str := cboDosage.Text;
  if (Length(cboDosage.Text) < 1) then
    cboDosage.ItemIndex := -1;
  (* Probably not needed here since this on validation check on accept
    if (LeftStr(cboDosage.Text,1)='.') then
    begin
    infoBox('Dosage must have a leading numeric value','Invalid Dosage',MB_OK);
    if self.tabDose.TabIndex = TI_DOSE then cboDosage.SetFocus;
    Exit;
    end; *)
  if (Length(cboDosage.Text) > 0) and (cboDosage.ItemIndex > -1) and
    (Trim(Piece(cboDosage.Items.Strings[cboDosage.ItemIndex], U, 5)) <>
    Trim(Piece(cboDosage.Text, TAB, 1))) then
  begin
    cboDosage.ItemIndex := -1;
    cboDosage.Text := Piece(str, TAB, 1);
    UpdateRelated(FALSE);
  end;
  if ActiveControl = memMessage then
  begin
    memMessage.SendToBack;
    pnlMessage.Visible := FALSE;
    Exit;
  end;
  if ActiveControl = memComment then
  begin
    if pnlMessage.Visible = TRUE then
    begin
      memMessage.SendToBack;
      pnlMessage.Visible := FALSE;
    end;
  end
  else if (ActiveControl <> btnSelect) and (ActiveControl <> memComment) then
  begin
    if pnlMessage.Visible = TRUE then
    begin
      memMessage.SendToBack;
      pnlMessage.Visible := FALSE;
    end;
    // cboDosageClick(Self);
  end;
end;

{ cboRoute -------------------------------------- }

procedure TfrmODMeds.cboRouteChange(Sender: TObject);
begin
  inherited;
  with cboRoute do
    if ItemIndex > -1 then
    begin
      if Piece(Items[ItemIndex], U, 5) = '1' then
        tabDose.Tabs[0] := 'Dosage / Rate'
      else
        tabDose.Tabs[0] := 'Dosage';
    end;
  cboDosage.Caption := tabDose.Tabs[0];
  if Sender <> Self then
    ControlChange(Sender);
end;

procedure TfrmODMeds.cboRouteExit(Sender: TObject);
begin
  if Trim(cboRoute.Text) = '' then
    cboRoute.ItemIndex := -1;
  // ValidateRoute(cboRoute); Removed based on Site feeback. See CQ: 7518
  inherited;
end;

procedure TfrmODMeds.cboRouteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboRoute.Text = '') then
    cboRoute.ItemIndex := -1;
end;

{ cboSchedule ----------------------------------- }

procedure TfrmODMeds.cboScheduleClick(Sender: TObject);
var
  othSch: string;
  idx: Integer;
begin
  inherited;
  if (FInptDlg) and (cboSchedule.Text = 'OTHER') then
  begin
    othSch := CreateOtherScheduel;
    if Length(Trim(othSch)) > 1 then
    begin
      othSch := othSch + U + U + NSSScheduleType + U + NSSAdminTime;
      cboSchedule.Items.Add(othSch);
      idx := cboSchedule.Items.IndexOf(Piece(othSch, U, 1));
      cboSchedule.ItemIndex := idx;
    end;
  end
  else
  begin
    NSSAdminTime := '';
    FNSSScheduleType := '';
  end;
  UpdateRelated(FALSE);
end;

procedure TfrmODMeds.cboScheduleChange(Sender: TObject);
var
  othSch: string;
  idx: Integer;
begin
  inherited;
  if Changing then
    exit;
  if (FInptDlg) and (cboSchedule.Text = 'OTHER') then
  begin
    othSch := CreateOtherScheduel;
    if Length(Trim(othSch)) > 1 then
    begin
      othSch := othSch + U + U + NSSScheduleType + U + NSSAdminTime;
      cboSchedule.Items.Add(othSch);
      idx := cboSchedule.Items.IndexOf(Piece(othSch, U, 1));
      cboSchedule.ItemIndex := idx;
    end;
  end;
  FScheduleChanged := TRUE;
  UpdateRelated;
end;

type
  TMyWinControl = class(TWinControl);

{ Duration ----------------------------- }
procedure TfrmODMeds.UpdateDurationControls(FreeText: Boolean);
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
    txtXDuration.Align := alNone;
    txtXDuration.Width := pnlXDuration.Width - (pnlXDuration.Width div 2) -
      spnXDuration.Width + 2;
    pnlXDurationButton.Width := pnlXDuration.Width div 2;
    pnlXDurationButton.Align := alRight;
    spnXDuration.Visible := TRUE;
    spnXDuration.AlignButton := udRight;
    TMyWinControl(spnXDuration).Align := alRight;
    txtXDuration.Align := alClient;
  end;
end;

procedure TfrmODMeds.popDurationClick(Sender: TObject);
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

procedure TfrmODMeds.QuantityMessageCheck(Tag: Integer);
var
  DispDrug: Integer;
  X: string;

begin
  if FInptDlg then
    Exit;
  DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID, Tag), 0);
  if DispDrug > 0 then
  begin
    if not FSuppressMsg then
    begin
      DispOrderMessage(DispenseMessage(DispDrug));
      FSuppressMsg := FALSE;
    end;
    X := QuantityMessage(DispDrug);
  end
  else
    X := '';
  if Length(X) > 0 then
    lblQtyMsg.Caption := TX_QTY_PRE + X + TX_QTY_POST
  else
    lblQtyMsg.Caption := '';
end;

{ txtSupply, txtQuantity -------------------------- }

procedure TfrmODMeds.txtSupplyChange(Sender: TObject);
begin
  inherited;
  if Changing then
    Exit;
  if not Showing then
    Exit;
  FNoZERO := TRUE;

  // if value = 0, change probably caused by the spin button
  txtSupply.Tag := (spnSupply.position <> 0).ToInteger;
  UpdateRelated;
end;

procedure TfrmODMeds.txtQuantityChange(Sender: TObject);
begin
  inherited;
  if Changing then
    Exit;
  if not Showing then
  begin
    if (FIsQuickOrder = TRUE) and (txtQuantity.Text = '0') and
      (FLastQuantity > 0) and (FLastQuantity <> StrtoInt64Def(txtQuantity.Text, 0))
    then
    begin
      Changing := TRUE;
      try
        txtQuantity.Text := FloatToStr(FLastQuantity);
        spnQuantity.Position := StrToIntDef(txtQuantity.Text, 0);
      finally
        Changing := FALSE;
      end;
    end;
    Exit;
  end;
  FNoZERO := TRUE;
  txtQuantity.Tag := (txtQuantity.Text <> '0').ToInteger;
  UpdateRelated;
end;

{ values changing }

function TfrmODMeds.OutpatientSig: string;
var
  Dose, Route, Schedule, Duration, X: string;
  i: Integer;
begin
  case tabDose.TabIndex of
    TI_DOSE:
      begin
        if ValueOf(FLD_TOTALDOSE) = '' then
          Dose := ValueOf(FLD_LOCALDOSE)
        else
          Dose := ValueOf(FLD_UNITNOUN);
        CheckDecimal(Dose);
        Route := ValueOf(FLD_ROUTE_EX);
        if (Length(Route) > 0) and (Length(FSIGPrep) > 0) then
          Route := FSIGPrep + ' ' + Route;
        if Length(Route) = 0 then
          Route := ValueOf(FLD_ROUTE_NM);
        Schedule := ValueOf(FLD_SCHED_EX);
        (* Schedule := Piece(Temp,U,1);
          if Piece(Temp,U,3) = '1' then Schedule := Schedule + ' AS NEEDED';
          if UpperCase(Copy(Schedule, Length(Schedule) - 18, Length(Schedule))) = 'AS NEEDED AS NEEDED'
          then Schedule := Copy(Schedule, 1, Length(Schedule) - 10); *)
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
        Result := FSIGVerb + ' ' + Dose + ' ' + Route + ' ' + Schedule;
      end;
    TI_COMPLEX:
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

function TfrmODMeds.InpatientSig: string;
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

function TfrmODMeds.ConstructedDoseFields(const ADose: string;
  PrependName: Boolean = FALSE): string;
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
      break;
    end;
  Strength := StrToFloatDef(Piece(FAllDrugs[DrugIndex], U, 2), 0);
  Units := Piece(FAllDrugs[DrugIndex], U, 3);
  AName := Piece(FAllDrugs[DrugIndex], U, 4);
  if FAllDoses.Count > 0 then
    Noun := Piece(Piece(FAllDoses[0], U, 3), '&', 4)
  else
    Noun := '';
  if Strength > 0 then
    UnitsPerDose := ExtractFloat(ADose) / Strength
  else
    UnitsPerDose := 0;
  if (UnitsPerDose > 1) and (Noun <> '') and (CharAt(Noun, Length(Noun)) <> 'S')
  then
    Noun := Noun + 'S';
  Result := FloatToStr(ExtractFloat(ADose)) + '&' + Units + '&' +
    FloatToStr(UnitsPerDose) + '&' + Noun + '&' + ADose + '&' + FDrugID + '&' +
    FloatToStr(Strength) + '&' + Units;
  if PrependName then
    Result := AName + U + FloatToStr(Strength) + Units + U + U + Result +
      U + ADose;
  Result := UpperCase(Result);
end;

function TfrmODMeds.FieldsForDrug(const DrugID: string): string;
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

function TfrmODMeds.FieldsForDose(ARow: Integer): string;
var
  i: Integer;
  DoseDrug: string;
begin
  Result := Piece(Piece(grdDoses.Cells[COL_DOSAGE, ARow], TAB, 2), U, 4);
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
        break;
      end; { if AnsiSameText }
    end; { for i }
    if Result = '' then
      Result := ConstructedDoseFields(Piece(DoseDrug, U, 1));
  end;
end;

function TfrmODMeds.FindDoseFields(const Drug, ADose: string): string;
var
  i: Integer;
  X: string;
begin
  Result := '';
  X := ADose + U + Drug + U;
  for i := 0 to Pred(FAllDoses.Count) do
  begin
    if AnsiSameText(X, Copy(FAllDoses[i], 1, Length(X))) then
    begin
      Result := Piece(FAllDoses[i], U, 3);
      break;
    end;
  end;
end;

function TfrmODMeds.FindCommonDrug(DoseList: TStringList): string;
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
      if AnsiSameText(Piece(FoundDrugs[i], U, 1), ADrug) then
        DrugIndex := i;
    if DrugIndex = -1 then
      FoundDrugs.Add(ADrug + U + FloatToStr(UnitsPerDose))
    else
    begin
      CurUnits := StrToFloatDef(Piece(FoundDrugs[DrugIndex], U, 2), 0);
      if UnitsPerDose > CurUnits then
        FoundDrugs[DrugIndex] := ADrug + U + FloatToStr(UnitsPerDose);
    end;
  end;

  procedure KillDrug(const ADrug: string);
  var
    i, DrugIndex: Integer;
  begin
    DrugIndex := -1;
    for i := 0 to Pred(FoundDrugs.Count) do
      if AnsiSameText(Piece(FoundDrugs[i], U, 1), ADrug) then
        DrugIndex := i;
    if DrugIndex > -1 then
      FoundDrugs.Delete(DrugIndex);
  end;

begin
  Result := '';
  if FInptDlg then // inpatient dialog
  begin
    DrugOK := TRUE;
    for i := 0 to Pred(DoseList.Count) do
    begin
      ADrug := Piece(DoseList[i], U, 2);
      if ADrug = '' then
        DrugOK := FALSE;
      if Result = '' then
        Result := ADrug;
      if not AnsiSameText(ADrug, Result) then
        DrugOK := FALSE;
      if not DrugOK then
        break;
    end;
    if not DrugOK then
      Result := '';
  end
  else // outpatient dialog
  begin
    // check the dose combinations for each dispense drug
    FoundDrugs := TStringList.Create;
    try
      if FAllDoses.Count > 0 then
        PossibleDoses := Length(Piece(Piece(FAllDoses[0], U, 3), '&', 1)) > 0
      else
        PossibleDoses := FALSE;
      for i := 0 to Pred(FAllDrugs.Count) do
      begin
        ADrug := Piece(FAllDrugs[i], U, 1);
        DrugOK := TRUE;
        DrugStrength := StrToFloatDef(Piece(FAllDrugs[i], U, 2), 0);
        DrugUnits := Piece(FAllDrugs[i], U, 3);
        SplitTab := Piece(FAllDrugs[i], U, 5) = '1';
        for j := 0 to Pred(DoseList.Count) do
        begin
          ADose := Piece(DoseList[j], U, 1);
          DoseFields := FindDoseFields(ADrug, ADose);
          // get the idnode for the dose/drug combination
          if not PossibleDoses then
          begin
            if DoseFields = '' then
              DrugOK := FALSE
            else
              SaveDrug(ADrug, 0);
          end
          else
          begin
            DoseValue := StrToFloatDef(Piece(DoseFields, '&', 1), 0);
            if DoseValue = 0 then
              DoseValue := ExtractFloat(ADose);
            UnitsPerDose := DoseValue / DrugStrength;
            if (Frac(UnitsPerDose) = 0) or
              (SplitTab and (Frac(UnitsPerDose) = 0.5)) then
              SaveDrug(ADrug, UnitsPerDose)
            else
              DrugOK := FALSE;
            // make sure this dose is using the same units as the drug
            if DoseFields = '' then
            begin
              for UnitIndex := 1 to Length(ADose) do
                if not CharInSet(ADose[UnitIndex], ['0' .. '9', '.']) then
                  break;
              DoseUnits := Copy(ADose, UnitIndex, Length(ADose));
            end
            else
              DoseUnits := Piece(DoseFields, '&', 2);
            if (not AnsiSameText(DoseUnits, DrugUnits)) then
              DrugOK := FALSE;
          end;
          if not DrugOK then
          begin
            KillDrug(ADrug);
            break;
          end; { if not DrugOK }
        end; { with..for j }
      end; { for i }
      if FoundDrugs.Count > 0 then
      begin
        if not PossibleDoses then
          Result := Piece(FoundDrugs[0], U, 1)
        else
        begin
          UnitsPerDose := 99999999;
          for i := 0 to Pred(FoundDrugs.Count) do
          begin
            if (StrToFloatDef(Piece(FoundDrugs[i], U, 2), 99999999) = 1) or
              (StrToFloatDef(Piece(FoundDrugs[i], U, 2), 99999999) <
              UnitsPerDose) then
            begin
              Result := Piece(FoundDrugs[i], U, 1);
              UnitsPerDose := StrToFloatDef(Piece(FoundDrugs[i], U, 2),
                99999999);
              if UnitsPerDose = 1 then
                break;
            end; { if StrToFloatDef }
          end; { for i..FoundDrugs }
        end; { if not..else PossibleDoses }
      end; { if FoundDrugs }
    finally
      FoundDrugs.Free;
    end; { try }
  end; { if..else FInptDlg }
end; { FindCommonDrug }

procedure TfrmODMeds.ControlChange(Sender: TObject);
var
  X, extX, ADose, AUnit, ADosageText: string;
  i, LastDose: Integer;
  DoseList: TStringList;
begin
  inherited;
  if csLoading in ComponentState then
    Exit; // to prevent error caused by txtRefills
  if Changing then
    Exit;
  if txtMed.Tag = 0 then
    Exit;
  ADose := '';
  AUnit := '';
  ADosageText := '';
  FUpdated := FALSE;
  Responses.Clear;
  if Self.MedName = '' then
    Responses.Update('ORDERABLE', 1, IntToStr(txtMed.Tag), txtMed.Text)
  else
    Responses.Update('ORDERABLE', 1, IntToStr(txtMed.Tag), Self.MedName);
  DoseList := TStringList.Create;
  case tabDose.TabIndex of
    TI_DOSE:
      begin
        if (cboDosage.ItemIndex < 0) and (Length(cboDosage.Text) > 0) then
        begin
          // try to resolve freetext dose and add it as a new item to the combobox
          ADosageText := cboDosage.Text;
          ADose := Piece(ADosageText, ' ', 1);
          Delete(ADosageText, 1, Length(ADose) + 1);
          ADosageText := ADose + Trim(ADosageText);
          DoseList.Add(ADosageText);
          FDrugID := FindCommonDrug(DoseList);
          if FDrugID <> '' then
          begin
            if ExtractFloat(cboDosage.Text) > 0 then
            begin
              X := ConstructedDoseFields(cboDosage.Text, TRUE);
              FDrugID := '';
              with cboDosage do
                ItemIndex := cboDosage.Items.Add(X);
            end;
          end;
        end;
        X := ValueOf(FLD_DOSETEXT);
        Responses.Update('INSTR', 1, X, X);
        X := ValueOf(FLD_DRUG_ID);
        Responses.Update('DRUG', 1, X, '');
        X := ValueOf(FLD_DOSEFLDS);
        Responses.Update('DOSE', 1, X, '');
        X := ValueOf(FLD_STRENGTH);
        // if outpt or inpt order with no total dose (i.e., topical)
        if (not FInptDlg) or (ValueOf(FLD_TOTALDOSE) = '') then
          Responses.Update('STRENGTH', 1, X, X);
        // if no strength for dosage, use dispense drug name
        if Length(X) = 0 then
        begin
          X := ValueOf(FLD_DRUG_NM);
          if Length(X) > 0 then
            Responses.Update('NAME', 1, X, X);
        end;
        X := ValueOf(FLD_ROUTE_AB);
        if Length(X) = 0 then
          X := ValueOf(FLD_ROUTE_NM);
        if Length(ValueOf(FLD_ROUTE_ID)) > 0 then
          Responses.Update('ROUTE', 1, ValueOf(FLD_ROUTE_ID), X)
        else
          Responses.Update('ROUTE', 1, '', X);
        X := ValueOf(FLD_SCHEDULE);
        Responses.Update('SCHEDULE', 1, X, X);
        if FInptDlg then
        begin
          (* AGP Change Admin Time Wrap 27.73
            x := Piece(self.lblAdminSch.text,':',2);
            x := Copy(x,2,Length(x)); *)
          X := lblAdminSchGetText;
          if FAdminTimeText <> '' then
            X := '';
          if X = 'Not Defined' then
            X := '';
          Responses.Update('ADMIN', 1, X, X);
          X := ValueOf(FLD_SCHED_TYP);
          if Self.chkPRN.Checked = TRUE then
            X := 'P';
          Responses.Update('SCHTYPE', 1, X, X);
        end;
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
          if (not FInptDlg) or (ValueOf(FLD_TOTALDOSE, 1) = '') then
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
            // GE CQ7585  Carry PRN checked from simple to complex tab
            begin
              pnlXSchedule.Tag := 1;
              chkXPRN.Checked := TRUE;
              // cboXScheduleClick(Self);// force onclick to fire when complex tab is entered
              FSmplPRNChkd := FALSE;
            end;
            X := ValueOf(FLD_DURATION, i);
            Responses.Update('DAYS', i, UpperCase(X), X);
            if FInptDlg then
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
            //mwa internal value was being save for external value
            extX := UpperCase(X);
            if extX = 'THEN' then
              X := 'T'
            else if extX = 'AND' then
              X := 'A'
            else if extX = 'EXCEPT' then
              X := 'X'
            else
              X := '';
            if i = LastDose then
              X := ''; // no conjunction for last dose
            Responses.Update('CONJ', i, X, extX);
          end; { with grdDoses }
        	Responses.Update('TITR', 1, ValueOf(FLD_TITRATION_ID, 1),
                                      ValueOf(FLD_TITRATION_NM, 1));
      end; { TI_COMPLEX }
  end; { case TabDose.TabIndex }
  DoseList.Free;
  Responses.Update('URGENCY', 1, ValueOf(FLD_PRIOR_ID), '');
  Responses.Update('COMMENT', 1, TX_WPTYPE, ValueOf(FLD_COMMENT));

  // INDICATIONS
  //If it's a supply order and it's not the indication line or
  //if it's not a supply order but the indication is valid (not line or not blank)
  if (IsSupplyOrder and not FIndications.IsIndicationLine(cboIndication.Text))
          or (not IsSupplyOrder and FIndications.IsSelectedIndicationValid
          (cboIndication.Text)) then
    Responses.Update('INDICATION', 1, cboIndication.Text, ValueOf(FLD_INDICATIONS));


  if FInptDlg then // inpatient orders
  begin
    Responses.Update('NOW', 1, ValueOf(FLD_NOW_ID), ValueOf(FLD_NOW_NM));
    X := InpatientSig;
    Responses.Update('SIG', 1, TX_WPTYPE, X);
  end
  else // outpatient orders
  begin
    X := ValueOf(FLD_SUPPLY);
    Responses.Update('SUPPLY', 1, X, X);
    X := ValueOf(FLD_QUANTITY);
    Responses.Update('QTY', 1, X, X);
    X := ValueOf(FLD_REFILLS);
    Responses.Update('REFILLS', 1, X, X);
    X := ValueOf(FLD_SC);
    Responses.Update('SC', 1, X, '');
    X := ValueOf(FLD_PICKUP);
    Responses.Update('PICKUP', 1, X, '');
    X := ValueOf(FLD_PTINSTR);
    Responses.Update('PI', 1, TX_WPTYPE, X);
    X := '';
    X := OutpatientSig;
    Responses.Update('SIG', 1, TX_WPTYPE, X);
  end;
  memOrder.Text := Responses.OrderText;
end;

{ complex dose ------------------------------------------------------------------------------ }

{ General Functions - get & set cell values }

function TfrmODMeds.ValFor(FieldID, ARow: Integer): string;
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

procedure FindInCombo(const X: string; AComboBox: TORComboBox);
begin
  AComboBox.SetTextAutoComplete(X);
end;

(*
  procedure TfrmODMeds.DurationToDays;
  var
  i, DoseHours, TotalHours: Integer;
  AllRows: Boolean;
  Days: Extended;
  x: string;
  begin
  Exit;  // don't try to figure out days supply from duration for now
  if txtSupply.Tag = 1 then Exit;
  AllRows := True;
  with grdDoses do for i := 1 to Pred(RowCount) do
  if (Length(ValFor(COL_DOSAGE, i)) > 0) and (Length(ValFor(VAL_DURATION, i)) = 0)
  then AllRows := False;
  if not AllRows then Exit;
  Changing := True;
  TotalHours := 0;
  with grdDoses do for i := 1 to Pred(RowCount) do
  if Length(ValFor(COL_DOSAGE, i)) > 0 then
  begin
  x := ValFor(VAL_DURATION, i);
  if Piece(x, U, 2) = 'D'
  then DoseHours := ExtractInteger(x) * 24
  else DoseHours := ExtractInteger(x);
  TotalHours := TotalHours + DoseHours;
  end;
  Days := TotalHours / 24;
  if Days > Int(Days) then Days := Days + 1;
  txtSupply.Text := IntToStr(Trunc(Days));
  //timDayQty.Tag := TIMER_FROM_DAYS;
  //timDayQtyTimer(Self);
  Changing := False;
  end;
*)

(* Moved to uOrders.CheckChanges
function TfrmODMeds.DurationToDays: Integer;
var
  i, DoseMinutes, AndMinutes, TotalMinutes: Integer;
  AllRows: Boolean;
  Days: Extended;
  X: string;
begin
  Result := 0;
  // make sure a duration exists for all rows with a dose
  AllRows := TRUE;
  with grdDoses do
    for i := 1 to Pred(RowCount) do
      if (Length(ValFor(COL_DOSAGE, i)) > 0) and
        (Length(ValFor(VAL_DURATION, i)) = 0) then
        AllRows := FALSE;
  if not AllRows then
    Exit;

  AndMinutes := 0;
  TotalMinutes := 0;
  with grdDoses do
    for i := 1 to Pred(RowCount) do
      if Length(ValFor(COL_DOSAGE, i)) > 0 then
      begin
        X := ValFor(VAL_DURATION, i);
        DoseMinutes := 0;
        if Piece(X, ' ', 2) = 'MONTHS' then
          DoseMinutes := ExtractInteger(X) * 43200;
        if Piece(X, ' ', 2) = 'WEEKS' then
          DoseMinutes := ExtractInteger(X) * 10080;
        if Pos('DAY', Piece(X, ' ', 2)) > 0 then
          DoseMinutes := ExtractInteger(X) * 1440;
        if Piece(X, ' ', 2) = 'HOURS' then
          DoseMinutes := ExtractInteger(X) * 60;
        if Piece(X, ' ', 2) = 'MINUTES' then
          DoseMinutes := ExtractInteger(X);
        // Determine how TotalMinutes should be calculated based on conjunction
        if ValFor(COL_SEQUENCE, i) <> 'AND' then // 'THEN', 'EXCEPT', or ''
        begin
          if AndMinutes = 0 then
            TotalMinutes := TotalMinutes + DoseMinutes;
          if AndMinutes > 0 then
          begin
            if AndMinutes < DoseMinutes then
              AndMinutes := DoseMinutes;
            TotalMinutes := TotalMinutes + AndMinutes;
            AndMinutes := 0;
          end;
          if ValFor(COL_SEQUENCE, i) = 'EXCEPT' then
            break; // quit out of For Loop to stop counting TotalMinutes
        end;
        if (ValFor(COL_SEQUENCE, i) = 'AND') then
          if AndMinutes < DoseMinutes then
            AndMinutes := DoseMinutes;
      end;
  if AndMinutes > 0 then
    TotalMinutes := TotalMinutes + AndMinutes;

  Days := TotalMinutes / 1440;
  if Days > Int(Days) then
    Days := Days + 1;
  Result := Trunc(Days);
end;
*)

procedure TfrmODMeds.pnlFieldsResize(Sender: TObject);
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
    if (not FInptDlg) or (FAdminTimeText = 'Not defined for Clinic Locations')
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
      COL_DOSAGE: ColControl := cboXDosage;
      COL_ROUTE: ColControl := cboXRoute;
      COL_SCHEDULE: ColControl := pnlXSchedule;
      COL_DURATION: ColControl := pnlXDuration;
      COL_ADMINTIME: ColControl := pnlXAdminTime;
      COL_SEQUENCE: ColControl := cboXSequence;
    end;
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

procedure TfrmODMeds.grdDosesMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TfrmODMeds.grdDosesKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if CharInSet(Key, [#32 .. #127]) then
    ShowEditor(grdDoses.Col, grdDoses.Row, Key);
  if grdDoses.Col <> COL_DOSAGE then
    DropLastSequence;
end;

procedure TfrmODMeds.grdDosesMouseUp(Sender: TObject; Button: TMouseButton;
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

procedure TfrmODMeds.grdDosesExit(Sender: TObject);
begin
  inherited;
  UpdateRelated(FALSE);
  RestoreDefaultButton;
  RestoreCancelButton;
end;

procedure TfrmODMeds.ShowEditor(ACol, ARow: Integer; AChar: Char);
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
        if FInptDlg then
          txtNSS.Visible := TRUE;
        X := Piece(grdDoses.Cells[COL_SCHEDULE, ARow], TAB, 1);
        Changing := TRUE;
        try
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
        finally
          Changing := FALSE;
        end;
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
        try
          txtXDuration.Text := Piece(X, ' ', 1);
          spnXDuration.Position := StrToIntDef(txtXDuration.Text, 0);
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
        finally
          Changing := FALSE;
        end;
        pnlXDuration.Tag := ARow;
        ARow1 := ARow;
        PlaceControl(pnlXDuration);
        txtXDuration.SetFocus;
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

procedure TfrmODMeds.UMDelayEvent(var Message: TMessage);
{ after focusing events are completed for a combobox, set the key the user typed }
begin
  case Message.LParam of
    COL_DOSAGE:
      FindInCombo(Chr(Message.WParam), cboXDosage);
    COL_ROUTE:
      FindInCombo(Chr(Message.WParam), cboXRoute);
    COL_SCHEDULE:
      FindInCombo(Chr(Message.WParam), cboXSchedule);
    COL_DURATION:
      begin
        txtXDuration.Text := Chr(Message.WParam);
        txtXDuration.SelStart := 1;
      end;
    COL_SEQUENCE:
      FindInCombo(Chr(Message.WParam), cboXSequence);
  end;
end;

procedure TfrmODMeds.cboXDosageEnter(Sender: TObject);
begin
  inherited;
  // if this was the last row, create a new last row
  if grdDoses.Row = Pred(grdDoses.RowCount) then
    grdDoses.RowCount := grdDoses.RowCount + 1;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
  QuantityMessageCheck(cboXDosage.Tag);
end;

procedure TfrmODMeds.cboXDosageChange(Sender: TObject);
var
  temp1, temp2: string;
  Count: Integer;
begin
  inherited;
  if Changing then
    exit;
  if (cboXDosage.ItemIndex < 0) then
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
  end;
  UpdateRelated;
end;

procedure TfrmODMeds.cboXDosageClick(Sender: TObject);
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
      DispOrderMessage(DispenseMessage(DispDrug));
      FSuppressMsg := FALSE;
    end;
    X := QuantityMessage(DispDrug);
  end
  else
    X := '';
  if Length(X) > 0 then
    lblQtyMsg.Caption := TX_QTY_PRE + X + TX_QTY_POST
  else
    lblQtyMsg.Caption := '';
end;

procedure TfrmODMeds.cboXDosageExit(Sender: TObject);
var
  // tempTag: integer;
  str: string;
begin
  inherited;
  if cboXDosage.Showing then
  begin
    cboXDosageClick(Self);
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
      Self.grdDoses.Cells[COL_DOSAGE, Self.grdDoses.Row] := cboXDosage.Text;
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

procedure TfrmODMeds.cboXRouteChange(Sender: TObject);
begin
  inherited;
  // Commented out to fix CQ: 7280
  // if cboXRoute.Text = '' then cboXRoute.ItemIndex := -1;
  if not Changing and (cboXRoute.ItemIndex < 0) then
  begin
    grdDoses.Cells[COL_ROUTE, cboXRoute.Tag] := cboXRoute.Text;
    ControlChange(Self);
  end;
end;

procedure TfrmODMeds.cboXRouteClick(Sender: TObject);
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
  ControlChange(Self);
end;

procedure TfrmODMeds.cboXRouteExit(Sender: TObject);
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
  cboXRouteClick(Self);
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

procedure TfrmODMeds.pnlXScheduleEnter(Sender: TObject);
begin
  inherited;
  cboXSchedule.SetFocus;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
end;

procedure TfrmODMeds.cboXScheduleChange(Sender: TObject);
var
  othSch, X: string;
  idx: Integer;
begin
  inherited;
  // Commented out to fix CQ: 7280
  // if cboXSchedule.Text = '' then cboXSchedule.ItemIndex := -1;
  if not Changing { and (cboXSchedule.ItemIndex < 0) } then
  begin
    if (FInptDlg) and (cboXSchedule.Text = 'OTHER') then
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
      pnlXSchedule.Tag := Self.grdDoses.Row;
    // if pnlXSchedule.Tag = -1 then pnlXSchedule.Tag := self.grdDoses.Row;
    with cboXSchedule do
      if ItemIndex > -1 then
        X := Text + TAB + Items[ItemIndex]
      else
        X := Text;
//    grdDoses.Cells[COL_SCHEDULE, pnlXSchedule.Tag] := X;
      if pnlXSchedule.Tag > 0 then  // [#VISTAOR-24488]
        grdDoses.Cells[COL_SCHEDULE, pnlXSchedule.Tag] := X;

    Self.cboSchedule.Text := X;
    // AGP Start Expired uncommented out the line
    if FInptDlg then
      UpdateStartExpires(Piece(X, TAB, 1));
    UpdateRelated;
  end;
end;

procedure TfrmODMeds.cboXScheduleClick(Sender: TObject);
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

procedure TfrmODMeds.chkXPRNClick(Sender: TObject);
var
  check: string;
begin
  inherited;
  if Self.chkXPRN.Checked = TRUE then
    check := '1'
  else
    check := '0';
  Self.grdDoses.Cells[COL_CHKXPRN, Self.grdDoses.Row] := check;
  if not Changing then
    cboXScheduleClick(Self);
end;

procedure TfrmODMeds.pnlXScheduleExit(Sender: TObject);
begin
  inherited;
  if Not FShowPnlXScheduleOk then // Added for CQ: 7370
    Exit;
  cboXScheduleClick(Self);
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

procedure TfrmODMeds.pnlXAdminTimeClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  if not FInptDlg then
    Exit;

  str := 'The Administration Times for this dose are: ' + CRLF + CRLF +
    ValFor(VAL_ADMINTIME, grdDoses.Row);
  str := str + CRLF + CRLF + AdminTimeHelpText;
  InfoBox(str, 'Administration Time Information', MB_OK);
end;

procedure TfrmODMeds.pnlXDurationButtonEnter(Sender: TObject);
begin
  inherited;
  QuantityMessageCheck(Self.grdDoses.Row);
end;

procedure TfrmODMeds.pnlXDurationEnter(Sender: TObject);
begin
  inherited;
  txtXDuration.SetFocus;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
end;

procedure TfrmODMeds.txtXDurationChange(Sender: TObject);
var
  FLG, j, i, code: Integer;
  OrgValue: string;
begin
  inherited;
  if Changing then
    Exit;
  txtQuantity.Tag := 0;
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
    end;
    { AGP change 26.19 for PSI-05-018 cq #7322
      else if PopDuration.Items.Tag = 0 then
      begin
      PopDuration.Items.Tag := 3;  //Days selection
      btnXDuration.Caption := 'days';
      end; }
    grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := txtXDuration.Text + ' ' +
      UpperCase(btnXDuration.Caption);
  end
  else // AGP CHANGE ORDER
  begin
    if not(FInptDlg) then
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
      grdDoses.Cells[COL_DURATION, pnlXDuration.Tag] := '';//txtXDuration.Text;
  end;
  // *SMT Reset if duration changed and duration has an open ended segment.
  FLG := 0;
  for j := 0 to grdDoses.Cols[COL_DURATION].Count - 1 do
    if (grdDoses.Cells[COL_DOSAGE, j] <> '') AND
      (grdDoses.Cells[COL_DURATION, j] = '') then
      FLG := 1;
  If (FLG = 0) then
    txtSupply.Tag := 0;

  // end;
  ControlChange(Self);
  UpdateRelated;
end;

procedure TfrmODMeds.pnlXDurationExit(Sender: TObject);
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

procedure TfrmODMeds.btnXInsertClick(Sender: TObject);
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

procedure TfrmODMeds.btnXRemoveClick(Sender: TObject);
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
  ControlChange(Self);
  UpdateRelated;
end;

function TfrmODMeds.ValueOf(FieldID: Integer; ARow: Integer = -1): string;
var
  X: string;
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

  function GetSingleDoseSchedule: string;
  begin
    Result := UpperCase(Trim(cboSchedule.Text));
    if chkPRN.Checked then
      Result := Result + ' PRN';
    if UpperCase(Copy(Result, Length(Result) - 6, Length(Result))) = 'PRN PRN'
    then
      Result := Copy(Result, 1, Length(Result) - 4);
  end;

  function GetSingleDoseScheduleEX: string;
  begin
    Result := '';
    with cboSchedule do
    begin
      if ItemIndex > -1 then
        Result := Piece(Items[ItemIndex], U, 2);
      (* if (Length(Result)=0) and (ItemIndex > -1) then
        begin
        Result := Piece(Items[ItemIndex], U, 1);
        if Piece(Items[ItemIndex], U, 3) = 'P' then
        begin
        if RightStr(Result,3) = 'PRN' then
        begin
        Result := Copy(Result,1,Length(Result)-3); //Remove the Trailing PRN
        if (RightStr(Result,1) = ' ') or (RightStr(Result,1) = '-') then
        Result := Copy(Result,1,Length(Result)-1);
        end;
        Result := Result + ' AS NEEDED';
        end;
        end;
        end; *)
      if RightStr(Result, 3) = 'PRN' then
      begin
        Result := Copy(Result, 1, Length(Result) - 3);
        // Remove the Trailing PRN
        if (RightStr(Result, 1) = ' ') or (RightStr(Result, 1) = '-') then
          Result := Copy(Result, 1, Length(Result) - 1);
        Result := Result + ' AS NEEDED'
      end;
      if (Length(Result) > 0) and chkPRN.Checked then
        Result := Result + ' AS NEEDED';
      if UpperCase(Copy(Result, Length(Result) - 18, Length(Result))) = 'AS NEEDED AS NEEDED'
      then
        Result := Copy(Result, 1, Length(Result) - 10);
      if UpperCase(Copy(Result, Length(Result) - 12, Length(Result))) = 'PRN AS NEEDED'
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

  function GetComplexDoseSchedule: string;
  begin
    with grdDoses do
    begin
      Result := Piece(Piece(Cells[COL_SCHEDULE, ARow], TAB, 2), U, 1);
      if Result = '' then
        Result := Piece(Cells[COL_SCHEDULE, ARow], TAB, 1);
      if ValFor(VAL_CHKXPRN, ARow) = '1' then
        Result := Result + ' PRN';
      if UpperCase(Copy(Result, Length(Result) - 6, Length(Result))) = 'PRN PRN'
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
      if UpperCase(Copy(Result, Length(Result) - 18, Length(Result))) = 'AS NEEDED AS NEEDED'
      then
        Result := Copy(Result, 1, Length(Result) - 10);
      if UpperCase(Copy(Result, Length(Result) - 12, Length(Result))) = 'PRN AS NEEDED'
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
  if ARow < 0 then // use single dose controls
  begin
    case FieldID of
      FLD_DOSETEXT:
        with cboDosage do
          if ItemIndex > -1 then
            Result := UpperCase(Piece(Items[ItemIndex], U, 5))
          else
            Result := UpperCase(Text);
      FLD_LOCALDOSE:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 5)
          else
            Result := UpperCase(Text);
      FLD_STRENGTH:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 2);
      FLD_DRUG_ID:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 6);
      FLD_DRUG_NM:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 1);
      FLD_DOSEFLDS:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 4);
      FLD_TOTALDOSE:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 1);
      FLD_UNITNOUN:
        with cboDosage do
          if ItemIndex > -1 then
            Result := Piece(Piece(Items[ItemIndex], U, 4), '&', 3) + ' ' +
              Piece(Piece(Items[ItemIndex], U, 4), '&', 4);
      FLD_ROUTE_ID:
        with cboRoute do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 1);
      FLD_ROUTE_NM:
        with cboRoute do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 2)
          else
            Result := Text;
      FLD_ROUTE_AB:
        with cboRoute do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 3);
      FLD_ROUTE_EX:
        with cboRoute do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 4);
      FLD_SCHEDULE:
        begin
          Result := GetSingleDoseSchedule;
        end;
      FLD_SCHED_EX:
        begin
          Result := GetSingleDoseScheduleEX;
        end;
      FLD_SCHED_TYP:
        with cboSchedule do
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 3);
      FLD_QTYDISP:
        with cboDosage do
        begin
          if ItemIndex > -1 then
            Result := Piece(Items[ItemIndex], U, 8);
          if (Result = '') and (Items.Count > 0) then
            Result := Piece(Items[0], U, 8);
          if Result <> '' then
            Result := 'Qty (' + Result + ')'
          else
            Result := 'Quantity';
        end;
    end; { case FieldID }                           // use complex dose controls
  end
  else
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
          Result := UpperCase(Piece(Cells[COL_DOSAGE, ARow], TAB, 1));
        FLD_LOCALDOSE:
          begin
            if (Length(X) > 0) and (Length(FDrugID) > 0) then
              Result := Piece(X, '&', 5)
            else
              Result := UpperCase(Piece(Cells[COL_DOSAGE, ARow], TAB, 1));
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
        FLD_TITRATION_ID:
          if chkTitration.Visible and chkTitration.Checked then
            Result := '1'
          else
            Result := '0';
        FLD_TITRATION_NM:
          if chkTitration.Visible and chkTitration.Checked then
            Result := 'Yes'
          else
            Result := 'No';
      end; { case FieldID }
  end; { if ARow }
  if FieldID > FLD_MISC_FLDS then // still need to process 'non-sig' fields
  begin
    case FieldID of
      FLD_SUPPLY:
        Result := Trim(txtSupply.Text);
      FLD_QUANTITY:
        begin
          if Pos(',', txtQuantity.Text) > 0 then
            Result := Piece(txtQuantity.Text, ',', 1) +
              Piece(txtQuantity.Text, ',', 2)
          else
            Result := Trim(txtQuantity.Text);
        end;
      FLD_REFILLS:
        Result := txtRefills.Text;
      FLD_PICKUP:
        if radPickWindow.Checked then
          Result := 'W'
        else if radPickMail.Checked then
          Result := 'M'
        else if radPickPark.Checked then
          Result := 'P' // PaPI
          // else if ckbPickPark.Checked   then Result := 'P' // PaPI
        else
          Result := '';
      FLD_PRIOR_ID:
        Result := cboPriority.ItemID;
      FLD_PRIOR_NM:
        Result := cboPriority.Text;
      FLD_COMMENT:
        Result := memComment.Text;
      FLD_INDICATIONS:
        Result := cboIndication.Text;
      FLD_NOW_ID:
        if chkDoseNow.Visible and chkDoseNow.Checked then
          Result := '1'
        else
          Result := '';
      FLD_NOW_NM:
        if chkDoseNow.Visible and chkDoseNow.Checked then
          Result := 'NOW'
        else
          Result := '';
      FLD_PTINSTR:
        if chkPtInstruct.Visible and chkPtInstruct.Checked then
          Result := FPtInstruct
        else
          Result := ' ';
    end; { case FieldID }
  end; { if FieldID }
end;

function TfrmODMeds.ValueOfResponse(FieldID: Integer;
  AnInstance: Integer = 1): string;
var
  X: string;
begin
  case FieldID of
    FLD_SCHEDULE:
      Result := Responses.IValueFor('SCHEDULE', AnInstance);
    FLD_UNITNOUN:
      begin
        X := Responses.IValueFor('DOSE', AnInstance);
        Result := Piece(X, '&', 3) + ' ' + Piece(X, '&', 4);
      end;
    FLD_DOSEUNIT:
      begin
        X := Responses.IValueFor('DOSE', AnInstance);
        Result := Piece(X, '&', 3);
      end;
    FLD_DRUG_ID:
      Result := Responses.IValueFor('DRUG', AnInstance);
    FLD_INSTRUCT:
      Result := Responses.IValueFor('INSTR', AnInstance);
    FLD_SUPPLY:
      Result := Responses.IValueFor('SUPPLY', AnInstance);
    FLD_QUANTITY:
      Result := Responses.IValueFor('QTY', AnInstance);
    FLD_ROUTE_ID:
      Result := Responses.IValueFor('ROUTE', AnInstance);
    FLD_EXPIRE:
      Result := Responses.IValueFor('DAYS', AnInstance);
    FLD_ANDTHEN:
      Result := Responses.IValueFor('CONJ', AnInstance);
    FLD_Indications:
      begin
        //If it's a supply order and it's not the indication line or
        //if it's not a supply order and the indication is valid (not line or not blank)
        if (IsSupplyOrder and not FIndications.IsIndicationLine(cboIndication.Text))
          or (not IsSupplyOrder and FIndications.IsSelectedIndicationValid
          (cboIndication.Text)) then
        begin
          Result := Responses.IValueFor('INDICATION', AnInstance);
        end;
      end;
  end;
end;

(* Moved to uOrders.CheckChanges
procedure TfrmODMeds.UpdateDefaultSupply(const CurUnits, CurSchedule,
  CurDuration, CurDispDrug: string; var CurSupply: Integer;
  var CurQuantity: Double; var SkipQtyCheck: Boolean);
var
  ADrug: string;
  OI: Integer;
begin
  OI := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
    ADrug := Piece(CurDispDrug, U, 1);
    CurSupply := DefaultDays(ADrug, CurUnits, CurSchedule, OI);
    if CurSupply > 0 then
    begin
      spnSupply.Position := CurSupply;
      if (txtSupply.Text = '') or (strtoInt(txtSupply.Text) <> CurSupply) then
        txtSupply.Text := IntToStr(CurSupply);
      if (FIsQuickOrder) and (FQOInitial) and (IsClozapineOrder = FALSE) then
      begin
        if StrToFloatDef(txtSupply.Text, 0) > 0 then
        begin
          Exit;
        end;
      end;
      CurQuantity := DaysToQty(CurSupply, CurUnits, CurSchedule,
        CurDuration, ADrug);
      if CurQuantity >= 0 then
      begin
        // spnQuantity.Position := CurQuantity;
        if txtQuantity.Text <> '' then
          txtQuantity.Text := FloatToStr(CurQuantity);
        if (txtQuantity.Text = '') or (strtoInt(txtQuantity.Text) <> CurQuantity)
        then
          txtQuantity.Text := FloatToStr(CurQuantity);
      end;
      SkipQtyCheck := TRUE;
    end;
    // if FQOInitial = true then FQOInitial := False;
end;
*)

(* moved to uOrders.CheckChange

// add CURInstrcut to this procedure. This address a problem with an user starting with a free-text dosage and changing
// to another free-text dose and the quantity value not updating.
procedure TfrmODMeds.UpdateSupplyQuantity(const CurUnits, CurSchedule,
  CurDuration, CurDispDrug, CurInstruct: string; var CurSupply: Integer;
  var CurQuantity: Double);
const
  UPD_NONE = 0;
  UPD_QUANTITY = 1;
  UPD_SUPPLY = 2;
  UPD_COMPLEX = 3;
  UPD_BOTH = 4;
var
  UpdateControl, supplyFromDuration, defSupplyfromM: Integer;
  ADrug: string;
  tmpQuantity: Double;
begin
  // MWA Changing should already be true...updates at the bottom will fire onchange()
  // If Changing is not TRUE...bad things happen
  Changing := TRUE;
  if (tabDose.TabIndex = TI_COMPLEX) and (txtSupply.Tag = 0) and
    (txtQuantity.Tag = 0) then
  begin
    //
    defSupplyfromM := DefaultDays(ADrug, CurUnits, CurSchedule,
      StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0));
    supplyFromDuration := DurationToDays;

    if (IsClozapineOrder = TRUE) then
    begin
      if (supplyFromDuration > 0) and (supplyFromDuration > defSupplyfromM) then
      begin
        CurSupply := defSupplyfromM;
        spnSupply.Position := CurSupply;
        if (txtSupply.Text = '') or (strtoInt(txtSupply.Text) <> CurSupply) then
          txtSupply.Text := IntToStr(CurSupply);
      end
      else
      begin
        if supplyFromDuration > 0 then
        begin
          txtSupply.Text := IntToStr(supplyFromDuration);
          CurSupply := supplyFromDuration;
        end
      end;
    end
    else
    begin
      // set days supply based on durations
      supplyFromDuration := DurationToDays;
      if supplyFromDuration > 0 then
      begin
        txtSupply.Text := IntToStr(supplyFromDuration);
        CurSupply := supplyFromDuration;
      end;
    end;
  end;
  // exit if not enough fields to calculation supply or quantity
  if (CurQuantity = 0) and (CurSupply = 0) then
    Exit;
  // exit if nothing has changed
  if (CurUnits = FLastUnits) and (CurSchedule = FLastSchedule) and
    (CurDuration = FLastDuration) and (CurQuantity = FLastQuantity) and
    (CurSupply = FLastSupply) and (CurInstruct = FLastInstruct) then
    Exit;
  // exit if supply & quantity have both been directly edited
  if (txtSupply.Tag > 0) and (txtQuantity.Tag > 0) then
    Exit;
  // figure out which control to update
  UpdateControl := UPD_NONE;

  if (CurSupply <> FLastSupply) and (txtQuantity.Tag = 0) and
    (CurQuantity <> FLastQuantity) and (txtSupply.Tag = 0) then
    UpdateControl := UPD_BOTH
  else if (CurSupply <> FLastSupply) and (txtQuantity.Tag = 0) then
    UpdateControl := UPD_QUANTITY
  else if (CurQuantity <> FLastQuantity) and (txtSupply.Tag = 0) then
    UpdateControl := UPD_SUPPLY;
  if (UpdateControl = UPD_NONE) and
    (((CurUnits <> FLastUnits) or (CurInstruct <> FLastInstruct)) or
    (CurSchedule <> FLastSchedule)) then
  begin
    if txtQuantity.Tag = 0 then
      UpdateControl := UPD_QUANTITY
    else if txtSupply.Tag = 0 then
      UpdateControl := UPD_SUPPLY;
  end;
  if (CurDuration <> FLastDuration) then
    UpdateControl := UPD_BOTH; // *SMT if Duration changed, update both.

  ADrug := Piece(CurDispDrug, U, 1);
  // just use the first dispense drug (for clozapine chk)
  case UpdateControl of
    UPD_QUANTITY:
      begin
        if FIsQuickOrder and (CurQuantity > 0) and FQOInitial then
        begin
          txtQuantity.Text := FloatToStr(CurQuantity);
          Exit;
        end;
        CurQuantity := DaysToQty(CurSupply, CurUnits, CurSchedule,
          CurDuration, ADrug);
        if (CurQuantity >= 0) then
          txtQuantity.Text := FloatToStr(CurQuantity);
      end;
    UPD_SUPPLY:
      begin
        CurSupply := QtyToDays(CurQuantity, CurUnits, CurSchedule,
          CurDuration, ADrug);
        if CurSupply > 0 then
          txtSupply.Text := IntToStr(CurSupply);
      end;
    UPD_BOTH:
      begin
        txtSupply.Text := IntToStr(CurSupply);
        spnSupply.Position := StrToIntDef(txtSupply.Text, 0);
        tmpQuantity := DaysToQty(CurSupply, CurUnits, CurSchedule,
          CurDuration, ADrug);
        if FIsQuickOrder and (CurQuantity > 0) and FQOInitial then
        begin
          txtQuantity.Text := FloatToStr(CurQuantity);
          Exit;
        end;
//         if FIsQuickOrder and (CurQuantity > 0) and (tmpQuantity = 0) and FQOInitial then
//          begin
//          txtQuantity.Text := FloatToStr(CurQuantity);
//          Exit;
//          end;
        // CurQuantity := DaysToQty(CurSupply,   CurUnits, CurSchedule, CurDuration, ADrug);
        CurQuantity := tmpQuantity;
        if CurQuantity >= 0 then
          txtQuantity.Text := FloatToStr(CurQuantity);
      end;
  end;
  if UpdateControl > UPD_NONE then
    FUpdated := TRUE;
end;
*)

function TfrmODMeds.UpValFor(FieldID, ARow: Integer): string;
begin
  Result := Uppercase(ValFor(FieldID, ARow));
end;

procedure TfrmODMeds.updateSig;
begin
  inherited;
  if Self.tabDose.TabIndex = TI_DOSE then
    Self.cboDosage.OnExit(cboDosage);
  if Self.tabDose.TabIndex = TI_COMPLEX then
    Self.cboXDosage.OnExit(cboXDosage);
end;

procedure TfrmODMeds.UpdateStartExpires(const CurSchedule: string);
var
  CompSch, CompDose, LastSch, ShowText, Duration, ASchedule, TempSch, SchType,
    Admin, tempAdmin: string;
  AdminTime: TFMDateTime;
  j, r, Interval, PrnPos, SchID: Integer;
  EndCheck, rowCheck, DoseNow: Boolean;
begin
  if not FInptDlg then
    Exit;
  if Length(CurSchedule) = 0 then
    Exit;
  ASchedule := Trim(CurSchedule);
  DoseNow := TRUE;
  if Self.EvtID > 0 then
    DoseNow := FALSE;
  if (Pos('^', ASchedule) > 0) then
  begin
    PrnPos := Pos('PRN', ASchedule);
    if (PrnPos > 1) and (CharAt(ASchedule, PrnPos - 1) = ' ') then
      Delete(ASchedule, PrnPos - 1, 4);
  end;
  if (FAdminTimeText = '') and (Self.EvtID > 0) then
    FAdminTimeText := 'To Be Determined';
  AdminTime := 0;
  ASchedule := Trim(ASchedule);
  // AGP Change for CQ 9906
  EndCheck := FALSE;
  LastSch := '';
  if Self.tabDose.TabIndex = TI_COMPLEX then
  begin
    TempSch := ASchedule;
    ASchedule := '';
    for r := 1 to Self.grdDoses.RowCount - 1 do
    begin
      CompSch := ValFor(VAL_SCHEDULE, r);
      CompDose := ValFor(VAL_DOSAGE, r);
      rowCheck := ValFor(VAL_CHKXPRN, r) = '1';
      if (rowCheck = TRUE) then
      begin
        if EndCheck = FALSE then
          AdminTime := -1;
        if FAdminTimeText = '' then
          Self.grdDoses.Cells[COL_ADMINTIME, r] := ''
        else
          Self.grdDoses.Cells[COL_ADMINTIME, r] := FAdminTimeText;
      end
      else
      begin
        if CompSch <> '' then
        begin
          // cboXSchedule.Items.IndexOfName(CompSch);
          // cboXSchedule.SelectByID(CompSch);
          SchID := -1;
          for j := 0 to cboXSchedule.Items.Count - 1 do
          begin
            if Piece(cboXSchedule.Items.Strings[j], U, 1) = CompSch then
            begin
              SchID := j;
              break;
            end;
          end;
          // if cboXSchedule.ItemIndex > -1 then
          if SchID > -1 then
          begin
            // SchID := cboXSchedule.ItemIndex;
            if (Piece(Self.cboXSchedule.Items.Strings[SchID], U, 1) = CompSch)
            then
            begin
              SchType := Piece(Self.cboXSchedule.Items.Strings[SchID], U, 3);
              if (SchType = 'P') or (SchType = 'O') or (SchType = 'OC') then
                Self.grdDoses.Cells[COL_ADMINTIME, r] := ''
              else if FAdminTimeText <> '' then
                Self.grdDoses.Cells[COL_ADMINTIME, r] := FAdminTimeText
              else
              begin
                Self.grdDoses.Cells[COL_ADMINTIME, r] :=
                  Piece(Self.cboXSchedule.Items.Strings[SchID], U, 4);
                if Self.grdDoses.Cells[COL_ADMINTIME, r] = '' then
                  Self.grdDoses.Cells[COL_ADMINTIME, r] := 'Not Defined';

              end;
              if CompDose <> '' then
              begin
                LastSch := CompSch;
                if (EndCheck = FALSE) and ((SchType = 'P') or (SchType = 'O'))
                then
                  AdminTime := -1
                  // else Aschedule := ';' + CompSch;
              end;
            end;

          end;
        end;
      end;
      if ((ValFor(VAL_SEQUENCE, r) = 'AND') or (ValFor(VAL_SEQUENCE, r) = ''))
        and (AdminTime > -1) and (EndCheck = FALSE) then
      begin
        // if (CompSch = '') and (LastSch <> '') and (Aschedule <> '') then CompSch := LastSch;
        if (ASchedule <> '') and (CompSch <> '') and (rowCheck = FALSE) then
          ASchedule := ASchedule + ';' + CompSch;
        if (ASchedule = '') and (CompSch <> '') and (rowCheck = FALSE) then
          ASchedule := ';' + CompSch;
      end
      else if ValFor(VAL_SEQUENCE, r) = 'THEN' then
      begin
        // if (CompSch = '') and (LastSch <> '') and (Aschedule <> '') then CompSch := LastSch;
        if (ASchedule <> '') and (CompSch <> '') and (rowCheck = FALSE) then
          ASchedule := ASchedule + ';' + CompSch;
        if (ASchedule = '') and (CompSch <> '') and (rowCheck = FALSE) then
          ASchedule := ';' + CompSch;
        EndCheck := TRUE;
      end
    end;
  end;
  if Self.tabDose.TabIndex = TI_DOSE then
  begin
    if LeftStr(ASchedule, 1) = ';' then
      TempSch := Piece(ASchedule, ';', 2)
    else
      TempSch := ASchedule;
    if Self.chkPRN.Checked = TRUE then
    begin
      AdminTime := -1;
      lblAdminSchSetText('');
      if (cboSchedule.ItemIndex > -1) and
        (Piece(Self.cboSchedule.Items.Strings[cboSchedule.ItemIndex], U, 3)
        = 'O') then
        DoseNow := FALSE;
    end
    else
    begin
      // cboSchedule.SelectByID(tempSch);
      SchID := -1;
      for j := 0 to cboSchedule.Items.Count - 1 do
      begin
        if Piece(cboSchedule.Items.Strings[j], U, 1) = TempSch then
        begin
          SchID := j;
          break;
        end;
      end;
      if SchID > -1 then
      begin
        SchType := Piece(Self.cboSchedule.Items.Strings[SchID], U, 3);
        if (SchType = 'P') or (SchType = 'OC') or (SchType = 'O') then
        begin
          lblAdminSchSetText('');
          if (SchType = 'P') or (SchType = 'OC') or (SchType = 'O') then
            AdminTime := -1;
          if SchType = 'O' then
            DoseNow := FALSE;
        end
        else
        begin
          if FAdminTimeText <> '' then
            tempAdmin := 'Admin. Time: ' + FAdminTimeText
          else
          begin
            if Piece(Self.cboSchedule.Items.Strings[SchID], U, 4) <> '' then
              tempAdmin := 'Admin. Time: ' +
                Piece(Self.cboSchedule.Items.Strings[SchID], U, 4)
            else
              tempAdmin := 'Admin. Time: Not Defined';
          end;
          lblAdminSchSetText(tempAdmin);
          (* if FAdminTimeText <> '' then self.lblAdminSch.text := 'Admin. Time: ' + FAdminTimeText
            else
            begin
            if Piece(self.cboSchedule.Items.Strings[schID], U, 4) <> '' then
            self.lblAdminSch.text := 'Admin. Time: ' + Piece(self.cboSchedule.Items.Strings[schID], U, 4)
            else self.lblAdminSch.text := 'Admin. Time: Not Defined';
            end; *)

        end;
      end;
    end;
  end;
  if (Length(ASchedule) > 0) and (AdminTime > -1) then
  begin
    if LeftStr(ASchedule, 1) <> ';' then
      ASchedule := ';' + ASchedule;
    Admin := '';
    if (Self.lblAdminSch.Visible = TRUE) and (Self.lblAdminSch.Text <> '') and
      (Self.tabDose.TabIndex = TI_DOSE) then
    begin
      // AGP Change Admin Time Wrap 27.73
      // Admin := Copy(self.lblAdminSch.text,  14, (Length(self.lblAdminSch.text)-1));
      Admin := lblAdminSchGetText;
      if (Admin <> '') and (not CharInSet(Admin[1], ['0' .. '9'])) then
        Admin := '';
    end
    else if Self.tabDose.TabIndex = TI_COMPLEX then
    begin
      Admin := Self.grdDoses.Cells[COL_ADMINTIME, 1];
      if (Admin <> '') and (not CharInSet(Admin[1], ['0' .. '9'])) then
        Admin := '';
    end;
    LoadAdminInfo(ASchedule, txtMed.Tag, ShowText, AdminTime, Duration, Admin);
  end;
  if AdminTime > 0 then
  begin
    ShowText := 'Expected First Dose: ';
    Interval := Trunc(FMDateTimeToDateTime(AdminTime) -
      FMDateTimeToDateTime(FMToday));
    case Interval of
      0:
        ShowText := ShowText + 'TODAY ' + FormatFMDateTime
          ('(mmm dd, yy) at hh:nn', AdminTime);
      1:
        ShowText := ShowText + 'TOMORROW ' +
          FormatFMDateTime('(mmm dd, yy) at hh:nn', AdminTime);
    else
      ShowText := ShowText + FormatFMDateTime('mmm dd, yy at hh:nn', AdminTime);
    end;

    if (Pos('PRN', Piece(CurSchedule, '^', 1)) > 0) and
      ((pnlXSchedule.Tag = 1) or chkPRN.Checked) then
    begin
      if lblAdminTime.Visible then
      begin
        lblAdminTime.Caption := '';
        FAdminTimeLbl := lblAdminTime.Caption;
      end;
    end
    else
      lblAdminTime.Caption := ShowText;
    FAdminTimeLbl := lblAdminTime.Caption;
  end
  else
    lblAdminTime.Caption := '';

  lblAdminTime.TabStop := ((lblAdminTime.Caption <> '') and
                          (lblAdminTime.Visible = TRUE) and
                          ScreenReaderActive);

  lblAdminSch.TabStop :=  ((lblAdminSch.Text <> '') and
                          (lblAdminSch.Visible = TRUE) and
                          ScreenReaderActive);

  DisplayDoseNow(DoseNow);
end;

(* moved to uOrders.CheckChanges
procedure TfrmODMeds.UpdateRefills(const CurDispDrug: string;
  CurSupply: Integer);
begin
  if EvtForPassDischarge = 'D' then
    spnRefills.Max := CalcMaxRefills(CurDispDrug, CurSupply, txtMed.Tag, TRUE)
  else
    spnRefills.Max := CalcMaxRefills(CurDispDrug, CurSupply, txtMed.Tag,
      Responses.EventType = 'D');
  if (StrToIntDef(txtRefills.Text, 0) > spnRefills.Max) then
  begin
    txtRefills.Text := IntToStr(spnRefills.Max);
    spnRefills.Position := spnRefills.Max;
    FUpdated := TRUE;
  end;
end;
*)

procedure TfrmODMeds.UpdateRelated(DelayUpdate: Boolean = TRUE);
begin
  timCheckChanges.Enabled := FALSE; // turn off timer
  if DelayUpdate then
    timCheckChanges.Enabled := TRUE // restart timer
  else
    timCheckChangesTimer(Self); // otherwise call directly
end;

procedure TfrmODMeds.timCheckChangesTimer(Sender: TObject);
//const
//  UPD_NONE = 0;
//  UPD_QUANTITY = 1;
//  UPD_SUPPLY = 2;
//var
//  CurUnits, CurSchedule, CurInstruct, CurDispDrug, CurDuration, TmpSchedule, X,
//    x1: string;
//  CurScheduleIN, CurScheduleOut: string;
//  CurSupply, i, pNum, j: Integer;
//  CurQuantity: Double;
//  LackQtyInfo: Boolean;
begin
  inherited;
  if Changing or ((not Showing) and (not FInSetupDlg)) then
    Exit;
  timCheckChanges.Enabled := FALSE;
  ControlChange(Self);
  Changing := TRUE;
  try
    CheckChanges(Responses, FIsQuickOrder, FInptDlg, (Self.tabDose.TabIndex = TI_COMPLEX),
      FQOInitial, IsClozapineOrder, FEvtForPassDischarge, cboDosage.Text, FScheduleChanged,
      FNoZERO, FChanging, FUpdated, FLastUnits, FLastSchedule, FLastDuration,
      FLastInstruct, FLastDispDrug, FLastTitration, FLastQuantity, FLastSupply,
      txtQuantity, txtSupply, txtRefills, spnSupply, spnQuantity, spnRefills,
      lblAdminTime, UpdateStartExpires);

(* moved to uOrders.CheckChanges
    CurUnits := '';
    CurSchedule := '';
    CurDuration := '';
    LackQtyInfo := FALSE;
    i := Responses.NextInstance('DOSE', 0);
    while i > 0 do
    begin
      X := ValueOfResponse(FLD_DOSEUNIT, i);
      if (X = '') and (not FIsQuickOrder) then
        LackQtyInfo := TRUE // StrToIntDef(x, 0) = 0
      else if (X = '') and FIsQuickOrder and (Length(txtQuantity.Text) > 0) then
        LackQtyInfo := FALSE;
      CurUnits := CurUnits + X + U;
      X := ValueOfResponse(FLD_SCHEDULE, i);
      if Length(X) = 0 then
        LackQtyInfo := TRUE;
      CurScheduleOut := CurScheduleOut + X + U;
//      x1 := ValueOf(FLD_SEQUENCE, i);
      x1 := ValueOfResponse(FLD_ANDTHEN, i);
      if Length(x1) > 0 then
      begin
        x1 := CharAt(x1, 1);
        CurScheduleIN := CurScheduleIN + x1 + ';' + X + U;
      end
      else
        CurScheduleIN := CurScheduleIN + ';' + X + U;
      X := ValueOfResponse(FLD_EXPIRE, i);
      CurDuration := CurDuration + X + '~';
      X := ValueOfResponse(FLD_ANDTHEN, i);
      CurDuration := CurDuration + X + U;
      X := ValueOfResponse(FLD_DRUG_ID, i);
      CurDispDrug := CurDispDrug + X + U;
      X := ValueOfResponse(FLD_INSTRUCT, i);
      CurInstruct := CurInstruct + X + U; // AGP CHANGE 26.19 FOR CQ 7465
      i := Responses.NextInstance('DOSE', i);
    end;

    pNum := 1;
    while Length(Piece(CurScheduleIN, U, pNum)) > 0 do
      pNum := pNum + 1;
    if Length(Piece(CurScheduleIN, U, pNum)) < 1 then
      for j := 1 to pNum - 1 do
      begin
        if j = pNum - 1 then
          TmpSchedule := TmpSchedule + ';' +
            Piece(Piece(CurScheduleIN, U, j), ';', 2)
        else
          TmpSchedule := TmpSchedule + Piece(CurScheduleIN, U, j) + U
      end;
    CurScheduleIN := TmpSchedule;
    CurQuantity := StrToFloatDef(ValueOfResponse(FLD_QUANTITY), 0);
    CurSupply := StrToIntDef(ValueOfResponse(FLD_SUPPLY), 0);
    // CurRefill  := StrToIntDef(ValueOfResponse(FLD_REFILLS) , 0);
    if FInptDlg then
    begin
      CurSchedule := CurScheduleIN;
      if Pos('^', CurSchedule) > 0 then
      begin
        if Pos('PRN', Piece(CurSchedule, '^', 1)) > 0 then
          if lblAdminTime.Visible then
            lblAdminTime.Caption := '';
      end;
      if (Self.tabDose.TabIndex = TI_DOSE) and (CurSchedule <> FLastSchedule)
      then
        UpdateStartExpires(CurSchedule);
      if CharInSet(Responses.EventType, ['A', 'D', 'T', 'M', 'O']) then
        lblAdminTime.Visible := FALSE;
    end;
    if not FInptDlg then
    begin
      CurSchedule := CurScheduleOut;
      if ((CurInstruct <> FLastInstruct) and (CurUnits <> U))
      // MWA the overall strucure of the following calls was changed
      // It makes more sense to check for Clozapine Supply/duration/qty
      // mismatch in UpdateSupplyQuantity
      then
        if ((StrToFloatDef(txtQuantity.Text, 0) = 0) and
          (StrToIntDef(txtSupply.Text, 0) = 0) and (txtQuantity.Tag = 0) and
          (txtSupply.Tag = 0) and (cboDosage.Text <> '')) or
          ((tabDose.TabIndex <> TI_COMPLEX) and (cboDosage.ItemIndex < 0) and
          (not FIsQuickOrder)) then
        begin
          UpdateDefaultSupply(CurUnits, CurSchedule, CurDuration, CurDispDrug,
            CurSupply, CurQuantity, LackQtyInfo);
        end;
      if LackQtyInfo then
      begin
        if FScheduleChanged then
          txtQuantity.Text := '0';
      end;
      UpdateSupplyQuantity(CurUnits, CurSchedule, CurDuration, CurDispDrug,
        CurInstruct, CurSupply, CurQuantity);
      // MWA UpdateSupplyQuantity can set "Changing"...restore it to TRUE
      Changing := TRUE;

      if ((CurDispDrug <> FLastDispDrug) or (CurSupply <> FLastSupply)) and
        ((CurDispDrug <> '') and (CurSupply > 0)) then
        UpdateRefills(CurDispDrug, CurSupply);
    end;

    FLastUnits := CurUnits;
    FLastSchedule := CurSchedule;
    FLastDuration := CurDuration;
    FLastInstruct := CurInstruct;
    FLastDispDrug := CurDispDrug;
    FLastQuantity := CurQuantity;
    FLastSupply := CurSupply;
    if (not FNoZERO) and (txtQuantity.Text = '') and (FLastQuantity = 0) then
      txtQuantity.Text := FloatToStr(FLastQuantity);
    if (not FNoZERO) and (txtSupply.Text = '') and (FLastSupply = 0) then
      txtSupply.Text := IntToStr(FLastSupply);
*)
    if (ActiveControl <> nil) and (ActiveControl.Parent <> cboDosage) then
      cboDosage.Text := Piece(cboDosage.Text, TAB, 1);
  finally
    Changing := FALSE;
  end;
  if FUpdated then
    ControlChange(Self);
  FScheduleChanged := FALSE;
  // FQOInitial := False;
end;

procedure TfrmODMeds.cmdAcceptClick(Sender: TObject);
var
  i: Integer;
begin
  if (FInptDlg) and (cboSchedule.Text = 'OTHER') then
  begin
    cboScheduleClick(Self);
    Exit;
  end;
  if timCheckChanges.Enabled = TRUE then
    sleep(1500);
  // AGP Change for 26.45 PSI-04-069
  if Self.tabDose.TabIndex = 1 then
  begin
    for i := 2 to Self.grdDoses.RowCount do
    begin
      if ((ValFor(COL_DOSAGE, i - 1) <> '') and (ValFor(COL_DOSAGE, i) <> ''))
        and (ValFor(COL_SEQUENCE, i - 1) = '') then
      begin
        InfoBox('To be able to complete a complex order every row except for the last row must have a conjunction defined. '
          + CRLF + CRLF + 'Verify that all rows have a conjunction defined.',
          'Sequence Error', MB_OK);
        Exit;
      end;
      // text := Self.cboXDosage.Items.Strings[i];
    end;
  end;
  if DlgFormID = OD_CLINICINF then
    DisplayGroup := DisplayGroupByName('CI RX')
  else if DlgFormID = OD_CLINICMED then
    DisplayGroup := DisplayGroupByName('C RX')
  else if FInptDlg and (not FOutptIV) then
    DisplayGroup := DisplayGroupByName('UD RX')
    // CQ 20854 - Display Supplies Only - JCS
  else if IsPSOSupplyDlg(EvtDlgID, 1) then
    DisplayGroup := DisplayGroupByName('SPLY')
  else
    DisplayGroup := DisplayGroupByName('O RX');
  (* if (Not FInptDlg) then
    begin
    if (ValidateDaySupplyandQuantity(strtoInt(txtSupply.Text), strtoInt(txtQuantity.text)) = false) then Exit
    else ClearMaxData;
    end; *)
  // if (Not FInptDlg) and (ValidateMaxQuantity(strtoInt(txtQuantity.Text)) = false) then Exit;

  // timCheckChangesTimer(Self);
  DropLastSequence;
  cmdAccept.SetFocus;
  inherited;
  (* if self.Responses.Cancel = true then
    begin
    self.Destroy;
    exit;
    end; *)
end;

procedure TfrmODMeds.chkPtInstructClick(Sender: TObject);
begin
  inherited;
  ControlChange(Self);
end;

procedure TfrmODMeds.chkTitrationClick(Sender: TObject);
begin
  inherited;
  UpdateRelated(FALSE); // Titration can change max refills
  if spnRefills.Max < StrToIntDef(txtRefills.Text,0) then
    spnRefills.Position := spnRefills.Max;
end;

procedure TfrmODMeds.chkDoseNowClick(Sender: TObject);
const
  CRLF = #13#10;
  GIVE_ADDITIONAL_DOSE1 =
    'By checking the "Give additional dose now" box, you have actually ' +
    'entered two orders for the same medication "%s"' + CRLF + CRLF +
    'The "Give additional dose now" order has an administration schedule of ' +
    '"%s" and a priority of "%s"' + CRLF +
    'The "Ongoing" order has an administration schedule of "%s" and a ' +
    'priority of "ROUTINE"' + CRLF + CRLF + 'Do you want to continue?';
  GIVE_ADDITIONAL_DOSE2 =
    'By checking the "Give additional dose now" box, you have actually ' +
    'entered a new order with the schedule "NOW" in addition to the one ' +
    'you are placing for the same medication "%s"' + CRLF + CRLF +
    'Do you want to continue?';
var
  medNm: string;
  theSch: string;
  ordPriority: string;
  nowPriority: string;
  UserPriority: Integer;
  FnowID: Integer;
  UserPriorityID: Integer;
begin
  inherited;
  UserPriorityID := cboPriority.ItemIndex;
  UserPriority := cboPriority.GetIEN(UserPriorityID);
  if (chkDoseNow.Checked) and (tabDose.TabIndex <> TI_COMPLEX) then
  begin
    medNm := txtMed.Text;
    theSch := cboSchedule.Text;
    ordPriority := cboPriority.SelText;
    if ((ordPriority) = '') then // RTW
      cboPriority.SelText := 'ROUTINE'; // RTW
    Callvista('ORWDPS1 GETPRIOR', [], nowPriority);
    if not((ordPriority) = '') then
      if not((ordPriority) = 'ROUTINE') then
      begin
        if (InfoBox
          ('You checked Give Additional Dose Now and your original priority selection will be overwritten for the ongoing order.',
          'Give Additional Dose Now Warning', MB_OKCANCEL or MB_ICONWARNING)
          = IDCANCEL) then
      end;
    if Length(theSch) > 0 then
    begin
      if InfoBox(Format(GIVE_ADDITIONAL_DOSE1, [medNm, 'NOW', nowPriority,
        theSch, ordPriority]), 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL
      then
      begin
        chkDoseNow.Checked := FALSE;
        Exit;
      end;
    end
    else
    begin
      if InfoBox(Format(GIVE_ADDITIONAL_DOSE2, [medNm]), 'Warning',
        MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL then
      begin
        begin
          chkDoseNow.Checked := FALSE;
          Exit;
        end;
      end;
    end;
    if chkDoseNow.Checked then
    begin
      Callvista('ORWDPS1 GETPRIEN', [], FnowID);
      cboPriority.SelectByIEN(FnowID);
    end
    else
    begin
      cboPriority.SelectByIEN(UserPriority);
    end;
    ControlChange(Self);
  end;

  lblAdminTime.Visible := not chkDoseNow.Checked;
  if (tabDose.TabIndex = TI_COMPLEX) and chkDoseNow.Checked then
  begin // rtw
    Callvista('ORWDPS1 GETPRIEN', [], FnowID);
    cboPriority.SelectByIEN(FnowID);
    Responses.Update('NOW', 1, '1', 'NOW'); // rtw  for complex quick orders
    if (InfoBox
      ('Give first dose off of standard administration schedule is in addition to those listed in the table.'
      + ' Please adjust the duration of the first row, if necessary.',
      'Give Additional Dose Now for Complex Order', MB_OKCANCEL or
      MB_ICONWARNING) = IDCANCEL) then
    begin
      chkDoseNow.Checked := FALSE;
      Exit;
    end;
  end;
end;

procedure TfrmODMeds.CheckDecimal(var AStr: string);
var
  DUName, UnitNum, tempstr: string;
  ToWord: string;
  ie, code: Integer;
begin
  ToWord := '';
  tempstr := AStr;
  UnitNum := Piece(AStr, ' ', 1);
  DUName := Copy(tempstr, Length(UnitNum) + 1, Length(tempstr));
  DUName := Trim(DUName);
  if CharAt(UnitNum, 1) = '.' then
  begin
    if CharInSet(CharAt(UnitNum, 2), ['0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9']) then
    begin
      UnitNum := '0' + UnitNum;
      AStr := '0' + AStr;
    end;
  end;
  if ((Pos('TABLET', UpperCase(DUName)) = 0)) and
    (Pos('DROP', UpperCase(DUName)) = 0) then
    Exit;
  if (Length(UnitNum) > 0) and (Length(DUName) > 0) then
  begin
    if CharAt(UnitNum, 1) <> '0' then
    begin
      Val(UnitNum, ie, code);
      if (code <> 0) and (ie = 0) then
        Exit;
    end;
    AStr := TextDosage(UnitNum) + ' ' + DUName;
  end;
end;

procedure TfrmODMeds.DropLastSequence(ASign: Integer);
const
  TXT_CONJUNCTIONWARNING =
    'is not associated with the comment field, and has been deleted.';
var
  i: Integer;
  StrConjunc: string;
begin
  ShowTitration;
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
      ShowTitration;
      Exit;
    end;
  end;
end;

procedure TfrmODMeds.memCommentClick(Sender: TObject);
var
  theSign: Integer;
begin
  inherited;
  theSign := 1;
  DropLastSequence(theSign);
end;

procedure TfrmODMeds.btnXDurationClick(Sender: TObject);
var
  APoint: TPoint;
begin
  inherited;
  with TSpeedButton(Sender) do
    APoint := ClientToScreen(Point(0, Height));
  popDuration.Popup(APoint.X, APoint.Y);
end;

procedure TfrmODMeds.chkPRNClick(Sender: TObject);
var
  TempSch: string;
  PrnPos: Integer;
begin
  inherited;
  // GE  CQ 7552
  if chkPRN.Checked then
  begin
    lblAdminTime.Caption := '';
    PrnPos := Pos('PRN', cboSchedule.Text);
    if (PrnPos < 1) and (FQOInitial = FALSE) then
      UpdateStartExpires(cboSchedule.Text + ' PRN');
  end
  else
  begin
    if Length(Trim(cboSchedule.Text)) > 0 then
    begin
      TempSch := ';' + Trim(cboSchedule.Text);
      if FQOInitial = FALSE then
        UpdateStartExpires(TempSch);
    end;
    // lblAdminTime.Caption := FAdminTimeLbl;
    if txtQuantity.Visible then
      cboScheduleClick(Self);
  end;
  if FQOInitial = FALSE then
    UpdateRelated(FALSE);
  // updateRelated(False);
  ControlChange(Self);
end;

procedure TfrmODMeds.grdDosesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    // VK_RETURN:   //moved to form key press
    VK_RIGHT:
      begin
        if (not FInptDlg) and (Self.grdDoses.Col = COL_DURATION) then
        begin
          Self.grdDoses.Col := COL_SEQUENCE;
          Key := 0;
        end;
      end;
    VK_LEFT:
      begin
        if (not FInptDlg) and (Self.grdDoses.Col = COL_SEQUENCE) then
        begin
          Self.grdDoses.Col := COL_DURATION;
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
        btnXInsertClick(Self);
        Key := 0;
      end;
    VK_DELETE:
      begin
        btnXRemoveClick(Self);
        Key := 0;
      end;

    VK_TAB:
      begin
        if ssShift in Shift then
        begin
          ActiveControl := tabDose; // Previeous control
          Key := 0;
        end
        else if ssCtrl in Shift then
        begin
          ActiveControl := memComment;
          Key := 0;
        end;
      end;
  end;
end;

procedure TfrmODMeds.grdDosesEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
end;

function TfrmODMeds.DisableCancelButton(Control: TWinControl): Boolean;
var
  i: Integer;
begin
  if (Control is TButton) and TButton(Control).Cancel then
  begin
    Result := TRUE;
    FDisabledCancelButton := TButton(Control);
    TButton(Control).Cancel := FALSE;
  end
  else
  begin
    Result := FALSE;
    for i := 0 to Control.ControlCount - 1 do
      if (Control.Controls[i] is TWinControl) then
        if DisableCancelButton(TWinControl(Control.Controls[i])) then
        begin
          Result := TRUE;
          break;
        end;
  end;
end;

function TfrmODMeds.DisableDefaultButton(Control: TWinControl): Boolean;
var
  i: Integer;
begin
  if (Control is TButton) and TButton(Control).Default then
  begin
    Result := TRUE;
    FDisabledDefaultButton := TButton(Control);
    TButton(Control).Default := FALSE;
  end
  else
  begin
    Result := FALSE;
    for i := 0 to Control.ControlCount - 1 do
      if (Control.Controls[i] is TWinControl) then
        if DisableDefaultButton(TWinControl(Control.Controls[i])) then
        begin
          Result := TRUE;
          break;
        end;
  end;
end;

procedure TfrmODMeds.RestoreCancelButton;
begin
  if assigned(FDisabledCancelButton) then
  begin
    FDisabledCancelButton.Cancel := TRUE;
    FDisabledCancelButton := nil;
  end;
end;

procedure TfrmODMeds.RestoreDefaultButton;
begin
  if assigned(FDisabledDefaultButton) then
  begin
    FDisabledDefaultButton.Default := TRUE;
    FDisabledDefaultButton := nil;
  end;
end;

procedure TfrmODMeds.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (ActiveControl = txtMed) then
    Key := #0 // Don't let the base class turn it into a forward tab!
  else if (Key = #13) and (Self.tabDose.TabIndex = TI_COMPLEX) then
    Key := #0
  else
    inherited;
end;

procedure TfrmODMeds.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) and (ssCtrl in Shift) and (ActiveControl <> grdDoses) then
  begin
    // Back-tab works the same as forward-tab because there are only two tabs.
    tabDose.TabIndex := (tabDose.TabIndex + 1) mod tabDose.Tabs.Count;
    Key := 0;
    tabDoseChange(tabDose);
  end;
end;

procedure TfrmODMeds.cboXRouteEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
  QuantityMessageCheck(Self.grdDoses.Row);
end;

procedure TfrmODMeds.pnlMessageEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
end;

procedure TfrmODMeds.pnlMessageExit(Sender: TObject);
begin
  inherited;
  RestoreDefaultButton;
  RestoreCancelButton;
end;

procedure TfrmODMeds.memMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := 0;
  end;
end;

procedure TfrmODMeds.memPIClick(Sender: TObject);
begin
  inherited;
  ShowMsg('The patient instruction field may not be edited.');
  chkPtInstruct.SetFocus;
end;

procedure TfrmODMeds.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  // Resizing the dialog on larger fonts caused horrible blinking. We need to
  // prevent resizing instead of first allowing it and then resetting it.
  if not(FInptDlg) then
  begin
    if NewWidth < grpPickup.Left + grpPickup.Width + 2 + Width - cboPriority.Left then
    begin
      NewWidth := grpPickup.Left + grpPickup.Width + 2 + Width - cboPriority.Left;
    end;
  end;
  inherited;
end;

procedure TfrmODMeds.FormResize(Sender: TObject);
var
  tempAdmin: string;
begin
  inherited;
  tempAdmin := lblAdminSchGetText;
  if tempAdmin <> '' then lblAdminSchSetText('Admin Time: ' + tempAdmin);
end;

procedure TfrmODMeds.memPIKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  ShowMsg('The patient instruction field may not be edited.');
  chkPtInstruct.SetFocus;
end;

function TfrmODMeds.TextDosage(ADosage: string): string;
var
  intS, fltS: string;
  iNum: Integer;
  fNum: Double;
begin
  intS := '';
  fltS := '';
  Result := intS + fltS;
  try
    begin
      iNum := StrToIntDef(Piece(ADosage, '.', 1), 0);
      fNum := StrToFloatDef('0.' + Piece(ADosage, '.', 2), 0);
      if fNum = 0.5 then
        fltS := 'ONE-HALF';
      if (fNum >= 0.3) and (fNum <= 0.4) then
        fltS := 'ONE-THIRD';
      if fNum = 0.25 then
        fltS := 'ONE-FOURTH';
      if (fNum >= 0.6) and (fNum <= 0.7) then
        fltS := 'TWO-THIRDS';
      if fNum = 0.75 then
        fltS := 'THREE-FOURTHS';
      if (fNum > 0) AND (Length(fltS) < 1) then
        // SMT Add a default for unaccounted values (Remedy HD396719)
        fltS := FloatToStr(fNum);

      Case iNum of
        0:
          intS := '';
        1:
          intS := 'ONE';
        2:
          intS := 'TWO';
        3:
          intS := 'THREE';
        4:
          intS := 'FOUR';
        5:
          intS := 'FIVE';
        6:
          intS := 'SIX';
        7:
          intS := 'SEVEN';
        8:
          intS := 'EIGHT';
        9:
          intS := 'NINE';
        10:
          intS := 'TEN';
      else
        intS := IntToStr(iNum);
      End;

      if Length(intS) > 0 then
      begin
        if Length(fltS) > 1 then
          fltS := ' AND ' + fltS;
      end;
      Result := intS + fltS;
      if Result = '' then
        Result := ADosage;
    end
  except
    on EConvertError do
      Result := '';
  end;
end;

function TfrmODMeds.CreateOtherScheduel: string; // NSS
var
  ASchedule: string;
begin
  ASchedule := '';
  if not ShowOtherSchedule(ASchedule) then
  begin
    cboSchedule.ItemIndex := -1;
    cboSchedule.Text := '';
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

function TfrmODMeds.IfIsIMODialog: Boolean;
var
  IsInptDlg, IsIMOLocation: Boolean;
  Td: TFMDateTime;
begin
  Result := FALSE;
  IsInptDlg := FALSE;
  // CQ #15188 - changed to use function to determine Td value - TDP
  // Td := FMToday;
  Td := IMOTimeFrame;
  if DlgFormID = MedsInDlgFormId then
    IsInptDlg := TRUE;
  IsIMOLocation := IsValidIMOLoc(encounter.Location, Patient.DFN);

  // CQ #15188 - allow IMO functionality 23 hours after encounter date/time - JCS
  // CQ #15188 - changed to use function to set Td.  Reverted this line back to original - TDP
  { if (IsInptDlg) and (not Patient.Inpatient) and IsIMOLocation and
    (Encounter.DateTime > DateTimeToFMDateTime(FMDateTimeToDateTime(FMNow) - (23/24))) then }
  if (IsInptDlg) and (not Patient.Inpatient) and IsIMOLocation and
    (encounter.DateTime > Td) then
    Result := TRUE;
  if (DlgFormID = OD_CLINICMED) or (DlgFormID = OD_CLINICINF) then
    Result := TRUE;
end;

procedure TfrmODMeds.lstChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  btnSelect.Enabled := (lstAll.ItemIndex > -1) or
    ((lstQuick.ItemIndex > -1) and
    (assigned(lstQuick.Items[lstQuick.ItemIndex].Data)) and
    (Integer(lstQuick.Selected.Data) > 0));
  if (btnSelect.Enabled) and (FOrderAction = ORDER_EDIT) then
    btnSelect.Enabled := FALSE;
  if (btnSelect.Enabled) and (FRemoveText) then
    txtMed.Text := '';
end;

procedure TfrmODMeds.DisplayDoseNow(Status: Boolean);
begin
  if not FInptDlg then
    Status := FALSE;
  if Status = FALSE then
  begin
    if (Self.chkDoseNow.Visible = TRUE) and (Self.chkDoseNow.Checked = TRUE)
    then
      Self.chkDoseNow.Checked := FALSE;
    Self.chkDoseNow.Visible := FALSE;
  end;
  if Status = TRUE then
    Self.chkDoseNow.Visible := TRUE;
end;

procedure TfrmODMeds.DispOrderMessage(const AMessage: string);
begin
  if ContainsVisibleChar(AMessage) then
  begin
    Image1.Visible := TRUE;
    memDrugMsg.Visible := TRUE;
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_ASTERISK);
    memDrugMsg.Lines.Clear;
    memDrugMsg.Lines.SetText(PChar(AMessage));
    if FShrinkDrugMsg then
    begin
      pnlBottom.Height := pnlBottom.Height + memDrugMsg.Height + 2;
      FShrinkDrugMsg := FALSE;
    end;
  end
  else
  begin
    Image1.Visible := FALSE;
    memDrugMsg.Visible := FALSE;
    if not FShrinkDrugMsg then
    begin
      pnlBottom.Height := pnlBottom.Height - memDrugMsg.Height - 2;
      FShrinkDrugMsg := TRUE;
    end;
  end;
end;

procedure TfrmODMeds.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCloseCalled then
    Exit; // Temporary Hack: Close is called 2x for some reason & errors out
  FCloseCalled := TRUE;
  FResizedAlready := FALSE;
  inherited;
end;

function TfrmODMeds.CreateOtherScheduelComplex: string;
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

procedure TfrmODMeds.txtNSSClick(Sender: TObject);
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
      cboScheduleClick(Self);
    end;
    if (tabDose.TabIndex = TI_COMPLEX) then
    begin
      cboXSchedule.SelectByID('OTHER');
      cboXScheduleChange(Self);
    end;
  end;
end;

procedure TfrmODMeds.cboScheduleEnter(Sender: TObject);
begin
  inherited;
  if (FInptDlg) and (cboSchedule.Text = 'OTHER') then
    cboScheduleClick(Self);
end;

procedure TfrmODMeds.FormShow(Sender: TObject);
begin
  FCloseCalled := FALSE;
  inherited;
  if ((cboSchedule.Text = 'OTHER') and FNSSOther and FInptDlg) then
    PostMessage(Handle, UM_NSSOTHER, 0, 0);

  // PaPI //////////////////////////////////////////////////////////////////////
  PaPI_GUISetup(papiParkingAvailable); // PaPI
end;

procedure TfrmODMeds.UMShowNSSBuilder(var Message: TMessage);
begin
  sleep(1000);
  cboScheduleClick(Self);
end;

procedure TfrmODMeds.cboScheduleExit(Sender: TObject);
begin
  inherited;
  if Trim(cboSchedule.Text) = '' then
    cboSchedule.ItemIndex := -1;
  ValidateInpatientSchedule(cboSchedule);
  UpdateRelated(FALSE);
end;

procedure TfrmODMeds.cboScheduleKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboSchedule.Text = '') then
    cboSchedule.ItemIndex := -1;
end;

procedure TfrmODMeds.ValidateIndication(IndicationCombo: TORComboBox);
begin
  // Coming across lower-case, change all Indication Text to Upper-Case.
  if (Length(IndicationCombo.Text) > 0) then
    IndicationCombo.Text := TrimLeft(UpperCase(IndicationCombo.Text));

  if ((Length(IndicationCombo.Text) <= 2) OR (Length(IndicationCombo.Text) > 40)) and
     not (IndicationCombo.Text = '') then
  begin
    Application.MessageBox(TX_INDICATION_LIM, 'Incorrect Indication');
    IndicationCombo.ItemIndex := -1;
    IndicationCombo.Text := '';
    if IndicationCombo.CanFocus then
      IndicationCombo.SetFocus;
  end;
end;

procedure TfrmODMeds.ValidateInpatientSchedule(ScheduleCombo: TORComboBox);
var
  tmpIndex: Integer;
begin

  { CQ: 6690 - Orders - autopopulation of schedule field - overtyping only 1 character
    CQ: 7280 - PTM 32-34, 42 Meds: NJH-0205-20901 MED DIALOG DROPPING FIRST LETTER (schedule) }

  // CQ 7575  Schedule coming across lower-case, change all schedules to Upper-Case.
  if (Length(ScheduleCombo.Text) > 0) then
    ScheduleCombo.Text := TrimLeft(UpperCase(ScheduleCombo.Text));
  { if user entered schedule verify it is in list }
  if (ScheduleCombo.ItemIndex < 0) and (not FInptDlg) then
  // CQ: 7397  and CQ 17934
  begin // Fix for CQ: 9299 - Outpatient Med orders will not accept free text schedule
    tmpIndex := GetSchedListIndex(ScheduleCombo, ScheduleCombo.Text);
    if tmpIndex > -1 then
      ScheduleCombo.ItemIndex := tmpIndex;
  end;
  if (Length(ScheduleCombo.Text) > 0) and (ScheduleCombo.ItemIndex < 0) and FInptDlg
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

// Removed based on Site feeback. See CQ: 7518
(* function TfrmODMeds.ValidateRoute(RouteCombo: TORComboBox) : Boolean;
  begin
  {CQ: 7331 - Medications - Route - Can not enter any route not listed in Route field in window}
  Result := True;
  if (Length(RouteCombo.Text) > 0) and (RouteCombo.ItemIndex < 0) and (Not IsSupplyAndOutPatient) then
  begin
  Application.MessageBox('Please select a correct route from the list.',
  'Incorrect Route.');
  if RouteCombo.CanFocus then
  RouteCombo.SetFocus;
  RouteCombo.SelStart := Length(RouteCombo.Text);
  Result := False;
  end;
  end; *)

function TfrmODMeds.isUniqueQuickOrder(iText: string): Boolean;
var
  counter, i: Integer;
begin
  counter := 0;
  Result := FALSE;
  if iText = '' then
    Exit;
  for i := 0 to FQuickItems.Count - 1 do
    if AnsiCompareText(iText, Copy(Piece(FQuickItems[i], '^', 2), 1,
      Length(iText))) = 0 then
      Inc(counter); // Found a Match
  Result := counter = 1;
end;

function TfrmODMeds.IsSupplyAndOutPatient: Boolean;
begin
  { CQ: 7331 - Medications - Route - Can not enter any route not listed in Route field in window }
  Result := FALSE;
  if IsSupplyOrder and (not FInptDlg) then
    Result := TRUE;
end;

function TfrmODMeds.IsSupplyOrder: Boolean;
begin
  //If we have not determined if this is a supply order then perform the check
  if FIsSupply = Supply_NA then
  begin
    if (Responses.Dialog = 'PSO SUPPLY') or MedIsSupply(txtMed.Tag) then
      FIsSupply := Supply_Yes
    else
      FIsSupply := Supply_No;
  end;
  Result := FIsSupply = Supply_Yes;
end;

// CQ: 7397 - Inpatient med orders with PRN cancel due to invalid schedule.
function TfrmODMeds.GetCacheChunkIndex(idx: Integer): Integer;
begin
  Result := idx div MED_CACHE_CHUNK_SIZE;
end;

function TfrmODMeds.GetSchedListIndex(SchedCombo: TORComboBox;
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
      break;
    end;
  end;
end;

procedure TfrmODMeds.cboXScheduleExit(Sender: TObject);
begin
  inherited;
  { CQ: 7344 - Inconsistency with Schedule box: Allows free-text entry for Complex orders,
    doesn't for simple orders }
  ValidateInpatientSchedule(cboXSchedule);
end;

procedure TfrmODMeds.cboXScheduleKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboXSchedule.Text = '') then
    cboXSchedule.ItemIndex := -1;
end;

procedure TfrmODMeds.cboXSequenceChange(Sender: TObject);
var
  X: string;
begin
  inherited;
  if Changing then
    Exit;
  txtQuantity.Tag := 0;
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
  grdDoses.Cells[COL_SEQUENCE, cboXSequence.Tag] := UpperCase(X);
  // AGP Start Expire add line
  UpdateStartExpires(ValFor(COL_SCHEDULE, Self.grdDoses.Row));
  ShowTitration;
  ControlChange(Sender);
  UpdateRelated;
end;

procedure TfrmODMeds.cboXSequenceEnter(Sender: TObject);
begin
  inherited;
  DisableDefaultButton(Self);
  DisableCancelButton(Self);
  QuantityMessageCheck(Self.grdDoses.Row);
end;

procedure TfrmODMeds.cboXSequenceExit(Sender: TObject);
begin
  inherited;
  grdDoses.Cells[COL_SEQUENCE, cboXSequence.Tag] :=
    UpperCase(cboXSequence.Text);
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

procedure TfrmODMeds.cboXSequenceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboXSequence.Text = '') then
    cboXSequence.ItemIndex := -1;
end;

procedure TfrmODMeds.cboXSequence1Exit(Sender: TObject);
begin
  inherited;
  cboXSequence.Hide;
end;

procedure TfrmODMeds.cboDosageKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboDosage.Text = '') then
    cboDosage.ItemIndex := -1;
  // Fix for CQ: 7545
  if cboDosage.ItemIndex > -1 then
    cboDosageClick(Sender)
  else
    UpdateRelated;
end;

procedure TfrmODMeds.cboIndicationChange(Sender: TObject);
begin
  inherited;
  if Changing then
    Exit;
  if not Showing then
    Exit;

  UpdateRelated;
end;

procedure TfrmODMeds.cboIndicationExit(Sender: TObject);
begin
  if Trim(cboIndication.Text) = '' then
    cboIndication.ItemIndex := -1;
  ValidateIndication(cboIndication);
  UpdateRelated(FALSE);
end;

procedure TfrmODMeds.cboIndicationKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  // Temporary fix of TORCombobox
  if (KEY = VK_DELETE)  then
  begin
    ControlChange(Sender);
  end;
end;

procedure TfrmODMeds.cboPriorityKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboPriority.Text = '') then
    cboPriority.ItemIndex := -1;
end;

procedure TfrmODMeds.cboXDosageKeyUp(Sender: TObject; var Key: Word;
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

procedure TfrmODMeds.txtSupplyClick(Sender: TObject);
begin
  inherited;
  Self.txtSupply.SelectAll;
end;

procedure TfrmODMeds.txtQuantityClick(Sender: TObject);
begin
  inherited;
  Self.txtQuantity.SelectAll;
end;

procedure TfrmODMeds.txtRefillsChange(Sender: TObject);
begin
  inherited;
  ControlChange(Sender);
end;

procedure TfrmODMeds.txtRefillsClick(Sender: TObject);
begin
  inherited;
  Self.txtRefills.SelectAll;
end;

procedure TfrmODMeds.WMClose(var Msg: TWMClose);
begin
  if Self <> nil then
  begin
    if (Self.tabDose.TabIndex = TI_DOSE) then
    begin
      if Trim(cboSchedule.Text) = '' then
        cboSchedule.ItemIndex := -1;
      ValidateInpatientSchedule(cboSchedule);
      if Self.cboSchedule.Focused = TRUE then
        Exit;
    end;
    if (Self.tabDose.TabIndex = TI_COMPLEX) then
    begin
      ValidateInpatientSchedule(cboXSchedule);
      if Self.cboXSchedule.Focused = TRUE then
        Exit;
    end;
  end;
  inherited
end;

procedure TfrmODMeds.cboXScheduleEnter(Sender: TObject);
begin
  inherited;
  // agp Change CQ 10719
  Self.chkXPRN.OnClick(Self.chkXPRN);
  QuantityMessageCheck(Self.grdDoses.Row);
end;

// Fix for issue with DefaultDrawing and DrawStyle = gdsThemed
procedure TCaptionStringGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
begin

  if Self.Name = 'grdDoses' then
    Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top + 2,
      Piece(Cells[ACol, ARow], TAB, 1))
  else
    inherited;
end;

// PaPI ========================================================================
procedure TfrmODMeds.PaPI_GUISetup(ParkingAvailable: Boolean);
begin
  if ParkingAvailable then
    begin
      radPickPark.Enabled := True;
      radPickPark.Visible := True;
    end
  else
    begin
      radPickPark.Visible := False;
      radPickPark.Enabled := False;
      if radPickPark.Checked then
        radPickPark.Checked := False;
    end;

  // AA 20160113 fixing defect 251427 - wrong size of the grpPickup -------- begin
  {
    if bPaPIHide then
    grpPickup.Width := radPickWindow.Width + radPickMail.Width + 5 //170
    else
    grpPickup.Width := radPickWindow.Width + radPickMail.Width + radPickPark.Width + 8; //220
  }

  // hiding radio button with no changes to the groupbox size
  grpPickup.Width := radPickWindow.Left + radPickWindow.Width + 8;
  // AA 20160113 fixing defect 251427 - wrong size of the grpPickup ---------- end
end;

procedure TfrmODMeds.SetFontSize(FontSize: integer);
begin
  inherited;
  InitGui;
end;

procedure TfrmODMeds.InitGUI;
// FODMeds does A LOT of stuff with sizing in code. I moved some of that to
// Anchors in the dfm, but everything that needs to be done at run-time should
// be done in here.
const
  ADistance: Integer = 4; // distance between components
var
  AMargin: Integer; // The margin within the form client
  AWidth: Integer; // The width within the margins
  WidestButtonWidth: Integer; // the width of the largest button at the bottom
  PageJustSwapped: boolean; // Did we just swap from med to fields, or vise versa
  MinHeight: integer;

begin
  pnlFields.Enabled := PageControl.ActivePage = PageFields;
  pnlFields.Visible := pnlFields.Enabled;
  pnlMeds.Enabled := PageControl.ActivePage = PageMeds;
  pnlMeds.Visible := pnlMeds.Enabled;
  PageControl.Left := txtMed.Left - PageMeds.Left; // Because a TPageControl always enforces a border around a Page
  memOrder.Top := ClientHeight - memOrder.Height - ADistance;
  PageControl.Height := memOrder.Top - PageControl.Top - ADistance;
  radPickWindow.Top := 18; // Resizing fonts does a job on this
  radPickMail.Top := 18; // Resizing fonts does a job on this
  radPickPark.Top := 18; // Resizing fonts does a job on this
  if PageControl.ActivePage = PageMeds then begin
    PageJustSwapped := txtMed.Font.Color <> clWindowText;
    AMargin := (ClientWidth - pnlMeds.ClientWidth) div 2; // The margin within the form client
    AWidth := pnlMeds.ClientWidth;
    WidestButtonWidth := Max(btnSelect.Width, cmdQuit.Width);
    txtMed.Width := AWidth;
    btnSelect.Top := memOrder.Top; // btnSelect jumps up and down
    btnSelect.Left := ClientWidth - AMargin - btnSelect.Width;
    btnSelect.Anchors := [akRight, akBottom];
    memOrder.Width := AWidth - WidestButtonWidth - ADistance;
    cmdAccept.Visible := False;
    // cmdAccept.Top := Doesn't matter for an invisible button;
    // cmdAccept.Left := Doesn't matter for an invisible button;
    cmdAccept.TabStop := False;
    cmdQuit.Top := btnSelect.Top + btnSelect.Height + ADistance;
    if PageJustSwapped then begin
      txtMed.Font.Color := clWindowText;
      txtMed.Color := clWindow;
      txtMed.ReadOnly := False;
      btnSelect.Caption := 'OK';
      btnSelect.Enabled := False;
      btnSelect.Default := True;
      btnSelect.TabOrder := cmdAccept.TabOrder;
    end;
  end else begin
    PageJustSwapped := txtMed.Font.Color <> clInfoText;
    AMargin := (ClientWidth - pnlFields.ClientWidth) div 2;
    AWidth := pnlFields.ClientWidth;
    WidestButtonWidth := Max(btnSelect.Width, cmdAccept.Width);
    txtMed.Width := AWidth - btnSelect.Width - ADistance;
    btnSelect.Top := txtMed.Top;
    btnSelect.Left := ClientWidth - AMargin - btnSelect.Width;
    btnSelect.Anchors := [akRight, akTop];
    memOrder.Width := AWidth - WidestButtonWidth - ADistance;
    PaPI_GUISetup(papiParkingAvailable);
    cmdAccept.Visible := True;
    cmdAccept.Top := memOrder.Top;
    cmdAccept.Left := ClientWidth - AMargin - cmdAccept.Width;
    cmdAccept.TabStop := True;
    cmdQuit.Top := cmdAccept.Top + cmdAccept.Height + ADistance;
    if PageJustSwapped then begin
      txtMed.Font.Color := clInfoText;
      txtMed.Color := clInfoBk;
      txtMed.ReadOnly := True;
      btnSelect.Caption := 'Change'; // btnSelect jumps up and down
      btnSelect.Enabled := True;
      btnSelect.Default := False;
      btnSelect.TabOrder := txtMed.TabOrder + 1; // because the order changed!
    end;
  end;
  cmdQuit.Left := ClientWidth - AMargin - cmdQuit.Width;
  case Font.Size of
    8: MinHeight := 450;
    10: MinHeight := 500;
    12: MinHeight := 600;
    else MinHeight := 700;
  end;
  if memPI.Visible then
    inc(MinHeight, memPI.Height + stcPI.Height);
  if memDrugMsg.Visible then
    inc(MinHeight, memDrugMsg.Height);
  if MinHeight > Screen.MonitorFromWindow(Handle).WorkAreaRect.Height then
    MinHeight := Screen.MonitorFromWindow(Handle).WorkAreaRect.Height;
  Constraints.MinHeight := MinHeight;
  ForceInsideWorkArea(Self);
end;

end.
