unit fODMedNVA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ComCtrls, ExtCtrls, ORCtrls, Grids, Buttons, uConst, ORDtTm,
  Menus, XUDIGSIGSC_TLB, rMisc, uOrders, StrUtils, oRFn, contnrs,
  VA508AccessibilityManager;

const
  UM_DELAYCLICK = 11037;  // temporary for listview click event
  NVA_CR = #13;
  NVA_LF = #10;

type
  TfrmODMedNVA = class(TfrmODBase)
    txtMed: TEdit;
    pnlMeds: TPanel;
    lstQuick: TCaptionListView;
    sptSelect: TSplitter;
    lstAll: TCaptionListView;
    dlgStart: TORDateTimeDlg;
    timCheckChanges: TTimer;
    pnlFields: TPanel;
    pnlTop: TPanel;
    lblRoute: TLabel;
    lblSchedule: TLabel;
    lblGuideline: TStaticText;
    tabDose: TTabControl;
    cboDosage: TORComboBox;
    cboRoute: TORComboBox;
    cboSchedule: TORComboBox;
    chkPRN: TCheckBox;
    pnlBottom: TPanel;
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


    procedure grdDosesExit(Sender: TObject);
    procedure ListViewEnter(Sender: TObject);
    procedure timCheckChangesTimer(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
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

  private
    {selection}
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
    FRemoveText : Boolean;
    FMedName: string;
    {selection}
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
    procedure SetOnMedSelect;
    procedure SetOnQuickOrder;
    procedure ShowMedSelect;
    procedure ShowMedFields;
    procedure ShowControlsSimple;
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
    procedure UMDelayClick(var Message: TMessage); message UM_DELAYCLICK;

  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure CheckDecimal(var AStr: string);
    property MedName: string read FMedName write FMedName;
  end;

var
  frmODMedNVA: TfrmODMedNVA;
  crypto: IXuDigSigS;

function OIForNVA(AnIEN: Integer; ForNonVAMed: Boolean; HavePI: boolean = True; PKIActive: Boolean = False): TStrings;
procedure CheckAuthForNVAMeds(var x: string);

implementation

{$R *.DFM}

uses rCore, uCore, rODMeds, rODBase, rOrders, fRptBox, fODMedOIFA,
  fFrame, ORNet, VAUtils;

const
  {grid columns for complex dosing }
  COL_SELECT   =  0;
  COL_DOSAGE   =  1;
  COL_ROUTE    =  2;
  COL_SCHEDULE =  3;
  COL_DURATION =  4;

  COL_SEQUENCE =  5;
  VAL_DOSAGE   = 10;
  VAL_ROUTE    = 20;
  VAL_SCHEDULE = 30;
  VAL_DURATION = 40;
  VAL_SEQUENCE = 50;
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
  TX_QTY_NV     = 'Unable to validate quantity.';
  TX_QTY_MAIL   = 'Quantity for mailed items must be a whole number.';
  TX_SUPPLY_LIM = 'Days Supply may not be greater than 90.';
  TX_SUPPLY_LIM1 = 'Days Supply may not be less than 1.';
  TX_SUPPLY_NINT= 'Days Supply is an invalid number.';
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
  ListCount: Integer;
  Restriction, x: string;
begin
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := True;
 // ActivateOrderDialog(Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  inherited;
  AllowQuickOrder := True;

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
  LoadSchedules(cboSchedule.Items);               // load the schedules combobox (cached)
  StatusText('');
  FSuppressMsg := CtrlInits.DefaultText('DispMsg') = '1';
  InitDialog;

   // medication selection
  FRowHeight := MainFontHeight + 1;
  x := 'NV RX';  // CLA 6/3/03
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
  cmdAccept.Left := cmdQuit.Left;
  cmdaccept.Anchors := cmdQuit.anchors;
  FNoZero := False;
  FShrinked := False;
  // Load OTC Statement/Explanations
  LoadOTCStatements(lbStatements.Items);
  FRemoveText := True;
  FShrinkDrugMsg := False;
  if ScreenReaderActive then lstQuick.TabStop := True;
end;

procedure TfrmODMedNVA.FormDestroy(Sender: TObject);
begin
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
  {if (OrderAction in [ORDER_COPY, ORDER_EDIT]) and (cboDosage.Text = '') then  //commented out by cla 2/27/04 - CQ 2591
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
    txtMed.Text := FActiveMedList.Selected.Caption;
    txtMed.SelectAll;
    FFromSelf := False;
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
  Application.ProcessMessages;
  if Offset > 0 then AListView.Scroll(0, (Offset * FRowHeight));
  Application.ProcessMessages;
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
    txtMed.SelStart := Length(UserText);   // v24.14 RV
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
  ResetControl(cboSchedule);        /// cla 2/26/04
  Responses.Clear;
end;

procedure TfrmODMedNVA.SetOnMedSelect;
var
  i,j: Integer;
  temp,x: string;
  QOPiUnChk: boolean;
  PKIEnviron: boolean;
begin
  // clear controls?
  cboDosage.Tag := -1;
  QOPiUnChk := False;
  PKIEnviron := False;
  if GetPKISite then PKIEnviron := True;
  with CtrlInits do
  begin
    // set up CtrlInits for orderable item
    LoadOrderItem(OIForNVA(txtMed.Tag, FNonVADlg, IncludeOIPI, PKIEnviron));
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
    SetControl(calStart,     'START');   //cla 7-17-03
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

 //   DispOrderMessage(TextOf('Message'));
  end;
end;

procedure TfrmODMedNVA.SetOnQuickOrder;
var
  AResponse: TResponse;
  x,LocRoute,TempSch,DispGrp: string;
  i, DispDrug: Integer;
begin
  // txtMed already set by SetOnMedSelect
  with Responses do
  begin
    if (InstanceCount('INSTR') > 1) or (InstanceCount('DAYS') > 0) then // complex dose
    begin
      i := Responses.NextInstance('INSTR', 0);
      while i > 0 do
      begin
        SetDosage(IValueFor('INSTR', i));
        with cboDosage do
          if ItemIndex > -1 then x := Text + TAB + Items[ItemIndex] else x := Text;

        SetControl(cboRoute,  'ROUTE', i);
        with cboRoute do
          if ItemIndex > -1 then x := Text + TAB + Items[ItemIndex] else x := Text;
        if FIsQuickOrder then TempSch := cboSchedule.Text;
        SetSchedule(IValueFor('SCHEDULE', i));
        if (cboSchedule.Text = '') and FIsQuickOrder then
        begin
          cboSchedule.SelectByID(TempSch);
          cboSchedule.Text := TempSch;
        end;
        x := cboSchedule.Text;
        if chkPRN.Checked then x := x + ' PRN';
        with cboSchedule do
          if ItemIndex > -1 then x := x + TAB + Items[ItemIndex];
        if      IValueFor('CONJ', i) = 'A' then x := 'AND'
        else if IValueFor('CONJ', i) = 'T' then x := 'THEN'
        else if IValueFor('CONJ', i) = 'X' then x := 'EXCEPT'
        else x := '';
        i := Responses.NextInstance('INSTR', i);
      end; {while}
    end else                                      // single dose
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
      SetControl(cboRoute,  'ROUTE',     1);  //AGP ADDED ROUTE FOR CQ 11252
      SetSchedule(IValueFor('SCHEDULE',  1));
      if (cboSchedule.Text = '') and FIsQuickOrder then
      begin
        cboSchedule.SelectByID(TempSch);
        cboSchedule.Text := TempSch;
      end;
      DispDrug := StrToIntDef(ValueOf(FLD_DRUG_ID), 0);
      if DispDrug > 0 then x := QuantityMessage(DispDrug) else x := '';
    SetControl(memComment ,  'COMMENT',  1);
    SetControl(calStart, 'START', 1);
    SetStartDate(EValueFor('START', 1));
    SetStatements(EValueFor('STATEMENTS', 1));
    if FIsQuickOrder then
      begin
        if not QOHasRouteDefined(Responses.QuickOrder) then
        begin
          LocRoute := GetPickupForLocation(IntToStr(Encounter.Location));
        end;
      end;
      AResponse := Responses.FindResponseByName('SC',     1);
      DispGrp := NameOfDGroup(Responses.DisplayGroup);
     if (AResponse = nil) or ((StrToIntDef(Piece(Responses.CopyOrder,';',1),0)>0) and AnsiSameText('Out. Meds',DispGrp)) then
      begin
        LocRoute := GetPickupForLocation(IntToStr(Encounter.Location));
      end;

    end;
  end; {with}
  if FInptDlg then
  begin
    x := ValueOfResponse(FLD_SCHEDULE, 1);
    if Length(x) > 0 then UpdateStartExpires(x);
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
  btnSelect.Caption := 'OK';
  btnSelect.Top     := cmdAccept.Top;
  btnSelect.Anchors := [akRight, akBottom];
  btnSelect.BringToFront;
  cmdAccept.Visible := False;
  cmdAccept.Default := False;
  btnSelect.Default := True;
  btnSelect.TabOrder := cmdAccept.TabOrder;
  cmdAccept.TabStop := False;
  txtMed.Font.Color := clWindowText;
  txtMed.Color      := clWindow;
  txtMed.ReadOnly   := False;
  txtMed.SelectAll;
  txtMed.SetFocus;
  FDrugID := '';
end;

procedure TfrmODMedNVA.ShowMedFields;
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
  ShowControlsSimple;
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
begin
  inherited;
  case tabDose.TabIndex of
  TI_DOSE:    begin
                // clean up responses?
                ShowControlsSimple;
                ControlChange(Self);
              end;
  TI_RATE:    begin
                // for future use...
              end;
   end; {case}
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
  if cboDosage.Text = '' then    //cla 3/18/04
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
begin
  inherited;
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
  Dose, Route, Schedule: string;
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
  end; {case}
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
      x := ValueOf(FLD_SCHEDULE);    Responses.Update('SCHEDULE', 1, x,  x); // CQ:7297, 7534
    end;
  end; {case TabDose.TabIndex}
  DoseList.Free;
  Responses.Update('URGENCY',   1, ValueOf(FLD_PRIOR_ID), '');
  Responses.Update('COMMENT',   1, TX_WPTYPE, ValueOf(FLD_COMMENT));

  if Length(calStart.Text) > 0 then
     Responses.Update('START', 1, calStart.Text, 'Start Date: ' + calStart.Text);  //cla 7-17-03
     
  x := ValueOf(FLD_STATEMENTS);
  Responses.Update('STATEMENTS',1, TX_WPTYPE, x);


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

{ General Functions - get & set cell values}

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
      Application.ProcessMessages;
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

function TfrmODMedNVA.ValueOf(FieldID: Integer; ARow: Integer = -1): string;
var
  y: string;
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

    FLD_COMMENT   : Result := memComment.Text;

    FLD_START     : Result := FormatFMDateTime('dddddd',calStart.FMDateTime);

    FLD_STATEMENTS : with lbStatements do
                     for stmt := 0 to lbStatements.Items.Count-1 do
                     if(lbStatements.Checked[stmt]) then
                     begin
                        y := #13#10 + lbStatements.Items.Strings[stmt] + '  ';
                          Result := Result + y;
                     end;

    end; {case FieldID}
   end;                          // use complex dose controls
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
    0: ShowText := ShowText + 'TODAY ' + FormatFMDateTime('(dddddd) at hh:nn', AdminTime);
    1: ShowText := ShowText + 'TOMORROW ' + FormatFMDateTime('(dddddd) at hh:nn', AdminTime);
    else ShowText := ShowText + FormatFMDateTime('dddddd at hh:nn', AdminTime);
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
begin
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
  VK_ESCAPE:
    begin
      ActiveControl := FindNextControl(Sender as TWinControl, False, True, False); //Previous control
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
    tCallV(tmplst, 'ORWPS REASON', [nil]);
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

procedure CheckAuthForNVAMeds(var x: string);
begin
  x := Piece(sCallV('ORWDPS32 AUTHNVA', [Encounter.Provider]), U, 2);
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

end.
