unit fODMedOut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, ORCtrls, StdCtrls, ORFn, ExtCtrls, uConst, ComCtrls, uCore, Mask,
  Menus, Buttons, VA508AccessibilityManager, uIndications;

type
  TfrmODMedOut = class(TfrmODBase)
    lblMedication: TLabel;
    cboMedication: TORComboBox;
    lblDosage: TLabel;
    lblRoute: TLabel;
    cboRoute: TORComboBox;
    lblSchedule: TLabel;
    cboSchedule: TORComboBox;
    lblDispense: TLabel;
    cboDispense: TORComboBox;
    memComments: TMemo;
    cboPriority: TORComboBox;
    Bevel1: TBevel;
    cboMedAlt: TORComboBox;
    cboInstructions: TORComboBox;
    lblQuantity: TLabel;
    cboPickup: TORComboBox;
    lblPickup: TLabel;
    cboSC: TORComboBox;
    lblSC: TLabel;
    lblRefills: TLabel;
    txtQuantity: TCaptionEdit;
    lblComment: TLabel;
    lblPriority: TLabel;
    txtRefills: TCaptionEdit;
    spnRefills: TUpDown;
    cmdComplex: TButton;
    btnUnits: TSpeedButton;
    txtSIG: TCaptionEdit;
    lblSIG: TLabel;
    popUnits: TPopupMenu;
    memComplex: TMemo;
    pnlIndications: TPanel;
    Panel1: TPanel;
    lblIndications: TLabel;
    cboIndication: TORComboBox;
    procedure cboMedicationNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboMedicationSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboDispenseExit(Sender: TObject);
    procedure cboDispenseMouseClick(Sender: TObject);
    procedure cboSCEnter(Sender: TObject);
    procedure txtQuantityEnter(Sender: TObject);
    procedure btnUnitsClick(Sender: TObject);
    procedure cmdComplexClick(Sender: TObject);
    procedure memCommentsEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cboIndicationChange(Sender: TObject);
    procedure cboIndicationKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboIndicationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FLastDrug: Integer;
    FLastMedID: string;
    FDispenseMsg: string;
    FMedCombo: TORComboBox;
    FIndications: TIndications;
    procedure CheckFormAlt;
    procedure ResetOnMedChange;
    procedure SetAskSC;
    procedure SetAltCombo;
    procedure SetInstructions;
    procedure SetOnOISelect;
    procedure SetMaxRefills;
    procedure SetupNouns;
    procedure SetComplex;
    procedure SetSimple;
    procedure UnitClick(Sender: TObject);
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

implementation

{$R *.DFM}

uses rOrders, rODBase, fODMedFA, fODMedComplex, System.Types, VAUtils;

const
  REFILLS_DFLT  = '0';
  REFILLS_MAX   = 11;

  TX_NO_MED     = 'Medication must be entered.';
  TX_NO_DOSE    = 'Instructions must be entered.';
  TX_NO_AMPER   = 'Instructions may not contain the ampersand (&) character.';
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
  TX_OUTPT_IV   = 'This patient has not been admitted.  Only IV orders may be entered.';
  TX_QTY_NV     = 'Unable to validate quantity.';
  TX_QTY_MAIL   = 'Quantity for mailed items must be a whole number.';


{ TfrmODBase common methods }

procedure TfrmODMedOut.FormCreate(Sender: TObject);
const
  TC_RESTRICT = 'Ordering Restrictions';
var
  Restriction: string;
  sl: TStrings;
begin
  inherited;
  AllowQuickOrder := True;
  CheckAuthForMeds(Restriction);
  if Length(Restriction) > 0 then
  begin
    InfoBox(Restriction, TC_RESTRICT, MB_OK);
    Close;
    Exit;
  end;
  FillerID := 'PSO'; // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'PSO OERR'; // loads formatting info
  StatusText('Loading Default Values');
  // CtrlInits.LoadDefaults(ODForMedOut);      // ODForMedOut returns TStrings with defaults
  sl := TSTringList.Create;
  try
    setODForMedOut(sl);
    CtrlInits.LoadDefaults(sl); // ODForMedOut returns TStrings with defaults

  finally
    sl.Free;
  end;
  InitDialog;
  CtrlInits.SetControl(cboPickup, 'Pickup');
  // do only once, so don't do in InitDialog
  PreserveControl(cboPickup);
end;

procedure TfrmODMedOut.FormDestroy(Sender: TObject);
begin
  FIndications.Free;
  inherited;
end;

procedure TfrmODMedOut.InitDialog;
begin
  inherited;
  FLastDrug := 0;
  FLastMedID := '';
  FDispenseMsg := '';
  FMedCombo := cboMedication;                    // this must be before SetControl(cboMedication)
  with CtrlInits do
  begin
    SetControl(cboMedication, 'ShortList');
    cboMedication.InsertSeparator;
    //SetControl(cboMedAlt,     'ShortList'); can't do this since it calls InitLongList
    SetControl(cboSchedule,   'Schedules');
    SetControl(cboPriority,   'Priorities');
    //SetControl(cboPickup,     'Pickup');
    SetControl(cboSC,         'SCStatus');

    FreeAndNil(FIndications);
    FIndications := TIndications.Create(CtrlInits);

    FIndications.Load;
    cboIndication.Items.Text := FIndications.GetIndicationList;
  end;
  SetAskSC;
  StatusText('Retrieving List of Medications');
  cboMedAlt.Visible := False;
  cboMedication.Visible := True;
  cboMedication.InitLongList('');
  ActiveControl := cboMedication; //SetFocusedControl(FMedCombo);
  SetSimple;
  StatusText('');
end;

procedure TfrmODMedOut.SetupDialog(OrderAction: Integer; const ID: string);
var
  AnInstr: string;
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT] then Responses.Remove('START', 1);
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    Changing := True;
    SetControl(cboMedication, 'ORDERABLE', 1);
    ResetOnMedChange;
    SetOnOISelect;
    SetAltCombo;
    //cboMedicationSelect(Self);
    SetControl(cboDispense,   'DRUG',      1);
    SetInstructions;
    SetControl(txtQuantity,   'QTY',       1);
    SetControl(txtRefills,    'REFILLS',   1);
    spnRefills.Position := StrToIntDef(txtRefills.Text, 0);
    SetControl(cboPickup,     'PICKUP',    1);
    SetControl(memComments,   'COMMENT',   1);
    SetControl(cboPriority,   'URGENCY',   1);
    { prevent the SIG from being part of the comments on pre-CPRS prescriptions }
    if (OrderAction in [ORDER_COPY, ORDER_EDIT]) and (cboInstructions.Text = '') then
    begin
      AnInstr := TextForOrder(ID); //'SIG:  ' + memComments.Text;
      OrderMessage(AnInstr);
      lblSIG.Visible := True;
      txtSIG.Visible := True;
      txtSIG.Text := memComments.Text;
      memComments.Clear;
    end;
    { can't edit the orderable item for a med order that has been released }
    if (OrderAction = ORDER_EDIT) and OrderIsReleased(EditOrder)
      then FMedCombo.Enabled := False;
    Changing := False;
    ControlChange(Self);
  end;
  if OrderAction <> ORDER_EDIT then SetFocusedControl(FMedCombo);
end;

procedure TfrmODMedOut.Validate(var AnErrMsg: string);
var
  Sched: Integer;
  RouteID, RouteAbbr: string;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  if Length(cboMedAlt.Text) = 0           then SetError(TX_NO_MED);
  // if memComplex is Visible, then the dosage fields were validated in fMedComplex
  if memComplex.Visible = False then
  begin
    if Length(cboInstructions.Text) = 0     then SetError(TX_NO_DOSE);
    if Pos('&', cboInstructions.Text) > 0   then SetError(TX_NO_AMPER);
    if (Length(cboRoute.Text) = 0) and (not MedIsSupply(cboMedAlt.ItemIEN))
                                            then SetError(TX_NO_ROUTE);
    if (Length(cboRoute.Text) > 0) and (cboRoute.ItemIndex < 0) then
    begin
      LookupRoute(cboRoute.Text, RouteID, RouteAbbr);
      if RouteID = '0'
        then SetError(TX_NF_ROUTE)
        else Responses.Update('ROUTE', 1, RouteID, RouteAbbr);
    end;
    if Length(cboSchedule.Text) = 0         then SetError(TX_NO_SCHED);
  end;
  if cboPickup.ItemID = ''                then SetError(TX_NO_PICK);
  if StrToIntDef(txtRefills.Text, 99) > spnRefills.Max
    then SetError(TX_RNG_REFILL + IntToStr(spnRefills.Max));
  with cboSchedule do if Length(Text) > 0 then
  begin
    Sched := ValidSchedule(Text);
    if Sched = -1 then
    begin
      if Pos('"', Text) > 0                                 then SetError(TX_SCH_QUOTE);
      if Copy(Text, 1, 1) = '-'                             then SetError(TX_SCH_MINUS);
      if Pos(' ', Copy(Text, Pos(' ', Text) + 1, 999)) > 0  then SetError(TX_SCH_SPACE);
      if Length(Text) > 70                                  then SetError(TX_SCH_LEN);
      if (Pos('P RN', Text) > 0) or (Pos('PR N', Text) > 0) then SetError(TX_SCH_PRN);
      if Pos('Q0', Text) > 0                                then SetError(TX_SCH_ZERO);
      if TrimLeft(Text) <> Text                             then SetError(TX_SCH_LSP);
    end;
    if Sched = 0                          then SetError(TX_SCH_NS);
  end;
  with txtQuantity do if Length(Text) > 0 then
  begin
    if not ValidQuantity(Text)            then SetError(TX_QTY_NV);
    //if (cboPickup.ItemID = 'M') and (IntToStr(StrToIntDef(Text,-1)) <> Text)
    //                                      then SetError(TX_QTY_MAIL);
  end;
end;

{ cboMedication methods }

procedure TfrmODMedOut.ResetOnMedChange;
begin
  ClearControl(cboDispense);
  ClearControl(cboInstructions);
  btnUnits.Caption := '';
  ResetControl(cboRoute);
  ResetControl(cboSchedule);
  ClearControl(txtQuantity);
  txtRefills.Text := REFILLS_DFLT;
  spnRefills.Max  := REFILLS_MAX;
  ClearControl(memComments);
  ClearControl(memOrder);
end;

procedure TfrmODMedOut.SetAltCombo;
begin
  with cboMedication do
  begin
    FMedCombo := cboMedAlt;
    if cboMedAlt.Items.Count = 0 then CtrlInits.SetListOnly(cboMedAlt, 'ShortList');
    cboMedAlt.SetExactByIEN(ItemIEN, TrimRight(Piece(Text, '<', 1)));
    cboMedication.Visible := False;
    cboMedAlt.Visible := True;
  end;
end;

procedure TfrmODMedOut.SetOnOISelect;
var
  sl: TStrings;
begin
  with CtrlInits do
  begin
    FLastMedID := FMedCombo.ItemID;
    sl := TSTringList.Create;
    try
      setOIForMedOut(sl, FMedCombo.ItemIEN);
      LoadOrderItem(sl);
    finally
      sl.Free;
    end;
    SetControl(cboDispense, 'Dispense');
    if cboDispense.Items.Count = 1 then
      cboDispense.ItemIndex := 0;
    lblDosage.Caption := DefaultText('Verb');
    if lblDosage.Caption = '' then
      lblDosage.Caption := 'Amount';
    SetControl(cboInstructions, 'Instruct');
    SetupNouns;
    SetControl(cboRoute, 'Route');
    if cboRoute.Items.Count = 1 then
      cboRoute.ItemIndex := 0;
    if DefaultText('DefSched') <> '' then
      cboSchedule.SelectByID(DefaultText('DefSched'));
    OrderMessage(TextOf('Message'));
  end;
end;

procedure TfrmODMedOut.cboMedicationNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
  { retrieves a subset of inpatient medication orderable items }
begin
  inherited;
  // FMedCombo.ForDataUse(SubSetOfOrderItems(StartFrom, Direction, 'S.O RX', Responses.QuickOrder));
  sl := TSTringList.Create;
  try
    setSubSetOfOrderItems(sl, StartFrom, Direction, 'S.O RX',
      Responses.QuickOrder);
    FMedCombo.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmODMedOut.cboMedicationSelect(Sender: TObject);
{ sets related controls whenever orderable item changes (MouseClick or Exit) }
begin
  inherited;
  with FMedCombo do
  begin
    if ItemID <> FLastMedID then FLastMedID := ItemID else Exit;
    Changing := True;
    if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
    ResetOnMedChange;
    if CharAt(ItemID, 1) = 'Q' then
    begin
      Responses.QuickOrder := ExtractInteger(ItemID);
      Responses.SetControl(FMedCombo, 'ORDERABLE', 1);
    end;
    if ItemIEN > 0 then SetOnOISelect;
  end;
  with Responses do if QuickOrder > 0 then
  begin
    SetControl(FMedCombo,     'ORDERABLE', 1);
    SetControl(cboDispense,   'DRUG',      1);
    SetInstructions;
    SetControl(txtQuantity,   'QTY',       1);
    SetControl(txtRefills,    'REFILLS',   1);
    spnRefills.Position := StrToIntDef(txtRefills.Text, 0);
    SetControl(cboPickup,     'PICKUP',    1);
    SetControl(memComments,   'COMMENT',   1);
    SetControl(cboPriority,   'URGENCY',   1);
  end;
  Changing := False;
  ControlChange(Self);
  if FMedCombo = cboMedication then SetAltCombo;
  // if the Dispense drug was stuffed - still do the checks (form alt, refills)
  if cboDispense.ItemIndex > -1 then cboDispenseMouseClick(Self);
end;

{ cboDispense methods }

procedure TfrmODMedOut.CheckFormAlt;
var
  DrugName, OIName: string;
  Drug, OI: Integer;
begin
  with cboDispense do if (ItemIndex > -1) and (Piece(Items[ItemIndex], U, 4) = 'NF') then
  begin
    SelectFormularyAlt(ItemIEN, Drug, OI, DrugName, OIName, PST_OUTPATIENT);
    if Drug > 0 then
    begin
      if FMedCombo.ItemIEN <> OI then
      begin
        FMedCombo.InitLongList(OIName);
        FMedCombo.SelectByIEN(OI);
        cboMedicationSelect(Self);
      end;
      cboDispense.SelectByIEN(Drug);
    end; {if FormAlt}
  end; {if ItemIndex}
  SetAskSC;  // now check enabled for the service connected prompt
end;

procedure TfrmODMedOut.SetMaxRefills;
begin
  with cboDispense do if (ItemIndex > -1) and (Length(Piece(Items[ItemIndex], U, 6)) > 0) then
  begin
    spnRefills.Max := StrToIntDef(Piece(Items[ItemIndex], U, 6), REFILLS_MAX);
    if StrToIntDef(txtRefills.Text, 0) > spnRefills.Max then
    begin
      txtRefills.Text := IntToStr(spnRefills.Max);
      spnRefills.Position := spnRefills.Max;
    end;
  end;
end;

procedure TfrmODMedOut.cboDispenseExit(Sender: TObject);
var
  AMsg: string;
begin
  inherited;
  SetMaxRefills;
  with cboDispense do
  begin
    if ItemIEN <> FLastDrug then CheckFormAlt;
    if ItemIEN > 0 then
    begin
      AMsg := DispenseMessage(ItemIEN) + CRLF;
      if memMessage.Text <> AMsg then OrderMessage(AMsg);
    end;
    FLastDrug := ItemIEN;
  end;
end;

procedure TfrmODMedOut.cboDispenseMouseClick(Sender: TObject);
begin
  inherited;
  SetMaxRefills;
  with cboDispense do
  begin
    if ItemIEN <> FLastDrug then CheckFormAlt;
    if ItemIEN > 0 then OrderMessage(DispenseMessage(ItemIEN));
    FLastDrug := ItemIEN;
  end;
end;

procedure TfrmODMedOut.cboIndicationChange(Sender: TObject);
begin
  inherited;
  if Changing then
    Exit;
  if not Showing then
    Exit;

//  UpdateRelated;
//  if FUpdated then
    ControlChange(Self);
end;

procedure TfrmODMedOut.cboIndicationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := 0;
  end;
end;

procedure TfrmODMedOut.cboIndicationKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboIndication.Text = '') then
    cboIndication.ItemIndex := -1;
end;

{ dosage instructions }

procedure TfrmODMedOut.SetupNouns;
var
  AvailWidth, MaxWidth: Integer;
begin
  CtrlInits.SetPopupMenu(popUnits, UnitClick, 'Nouns');
  if popUnits.Items.Count > 0 then
  begin
    // Make sure cboInstructions is at least 40 pixels wide so it can show values
    // like "1/2".  Allow for a 3 pixel space between the the Units button & Route.
    AvailWidth := (cboRoute.Left - 3) - (cboInstructions.Left + 40);
    MaxWidth := popUnits.Tag + 9; // allow 9 pixels for the down arrow & button border
    if MaxWidth > AvailWidth then MaxWidth := AvailWidth;
    btnUnits.Width := MaxWidth;
    btnUnits.Left  := cboRoute.Left - MaxWidth - 3;
    cboInstructions.Width := btnUnits.Left - cboInstructions.Left;
    btnUnits.Caption := popUnits.Items[0].Caption;
    btnUnits.Visible := True;
  end else
  begin
    btnUnits.Visible := False;
    // Allow for a 6 pixel margin between the Instructions box & Route
    cboInstructions.Width := cboRoute.Left - cboInstructions.Left - 6;
  end;
end;

procedure TfrmODMedOut.btnUnitsClick(Sender: TObject);
var
  APoint: TPoint;
begin
  inherited;
  APoint := btnUnits.ClientToScreen(Point(0, btnUnits.Height));
  popUnits.Popup(APoint.X, APoint.Y);
end;

procedure TfrmODMedOut.UnitClick(Sender: TObject);
begin
  btnUnits.Caption := TMenuItem(Sender).Caption;
end;

procedure TfrmODMedOut.SetComplex;
begin
  lblDosage.Visible := False;;
  lblRoute.Visible := False;;
  lblSchedule.Visible := False;;
  cboInstructions.Visible := False;
  btnUnits.Visible := False;;
  cboRoute.Visible := False;
  cboSchedule.Visible := False;
  memComplex.Visible := True;
  cmdComplex.Caption := 'Change Dose...';
end;

procedure TfrmODMedOut.SetSimple;
begin
  memComplex.Visible := False;
  lblDosage.Visible := True;;
  lblRoute.Visible := True;;
  lblSchedule.Visible := True;;
  cboInstructions.Visible := True;
  btnUnits.Visible := (popUnits.Items.Count > 0) or (btnUnits.Caption <> '');
  cboRoute.Visible := True;
  cboSchedule.Visible := True;
  cmdComplex.Caption := 'Complex Dose...';
end;

procedure TfrmODMedOut.SetInstructions;
var
  x: string;
  AnInstance: Integer;
begin
  case Responses.InstanceCount('INSTR') of
  0:   begin
         cboInstructions.ItemIndex := -1;
         // there may still be a route & schedule (for copied orders)
         if Responses.EValueFor('MISC', 1) <> ''
           then btnUnits.Caption := Responses.EValueFor('MISC', 1);
         Responses.SetControl(cboRoute, 'ROUTE', 1);
         with cboRoute do if ItemIndex > -1 then Text := DisplayText[ItemIndex];
         Responses.SetControl(cboSchedule, 'SCHEDULE', 1);
         SetSimple;
       end;
  1:   begin
         AnInstance := Responses.NextInstance('INSTR', 0);
         Responses.SetControl(cboInstructions, 'INSTR', AnInstance);
         btnUnits.Caption := Responses.IValueFor('MISC', AnInstance);
         Responses.SetControl(cboRoute, 'ROUTE', AnInstance);
         with cboRoute do if ItemIndex > -1 then Text := DisplayText[ItemIndex];
         Responses.SetControl(cboSchedule, 'SCHEDULE', AnInstance);
         SetSimple;
       end;
  else begin
         memComplex.Clear;
         AnInstance := Responses.NextInstance('INSTR', 0);
         while AnInstance > 0 do
         begin
           x := Responses.EValueFor('INSTR', AnInstance);
           x := x + ' ' + Responses.EValueFor('MISC', AnInstance);
           x := x + ' ' + Responses.EValueFor('ROUTE', AnInstance);
           x := x + ' ' + Responses.EValueFor('SCHEDULE', AnInstance);
           if Length(Responses.EValueFor('DAYS', AnInstance)) > 0
             then x := x + ' ' + Responses.EValueFor('DAYS', AnInstance) + ' day(s)';
           memComplex.Lines.Add(x);
           AnInstance := Responses.NextInstance('INSTR', AnInstance);
         end;
         SetComplex;
       end;
  end; {case}
  memOrder.Text := Responses.OrderText;
end; {if ExecuteComplexDose}

procedure TfrmODMedOut.cmdComplexClick(Sender: TObject);
begin
  inherited;
  if FMedCombo.ItemIEN = 0 then
  begin
    InfoBox(TX_NO_MED, 'Error', MB_OK);
    Exit;
  end;
  if ExecuteComplexDose(CtrlInits, Responses) then SetInstructions;
end;

{ quantity }

procedure TfrmODMedOut.txtQuantityEnter(Sender: TObject);
begin
  inherited;
  with cboDispense do if ItemIEN > 0 then OrderMessage(QuantityMessage(ItemIEN));
end;

{ service connection }

procedure TfrmODMedOut.SetAskSC;
const
  SC_NO  = 0;
  SC_YES = 1;
begin
  if Patient.ServiceConnected and RequiresCopay(FLastDrug) then
  begin
    lblSC.Font.Color := clWindowText;
    cboSC.Enabled := True;
    cboSC.Color := clWindow;
    if Patient.SCPercent > 50 then cboSC.SelectByIEN(SC_YES) else cboSC.SelectByIEN(SC_NO);
  end else
  begin
    lblSC.Font.Color := clGrayText;
    cboSC.Enabled := False;
    cboSC.Color := clBtnFace;
    cboSC.ItemIndex := -1;
  end;
end;

procedure TfrmODMedOut.cboSCEnter(Sender: TObject);
begin
  inherited;
  OrderMessage(RatedDisabilities);
end;

{ comments }

procedure TfrmODMedOut.memCommentsEnter(Sender: TObject);
begin
  inherited;
  OrderMessage('');  // make sure Order Message disappears when in comments box
end;

{ all controls }

procedure TfrmODMedOut.ControlChange(Sender: TObject);
begin
  inherited;
  if csLoading in ComponentState then Exit;  // to prevent error caused by txtRefills
  if Changing then Exit;
  if FMedCombo.ItemIEN = 0 then Exit;        // prevent txtRefills from updating early
  with FMedCombo do if ItemIEN > 0
    then Responses.Update('ORDERABLE', 1, ItemID, Piece(Items[ItemIndex], U, 3))
    else Responses.Update('ORDERABLE', 1, '', '');
  with cboDispense   do if ItemIEN > 0
    then Responses.Update('DRUG', 1, ItemID, Piece(Items[ItemIndex], U, 2))
    else Responses.Update('DRUG', 1, '', '');
  if memComplex.Visible = False then
  begin
    with cboInstructions do Responses.Update('INSTR', 1, Text, Text);
    with btnUnits        do if Visible then Responses.Update('MISC',  1, Caption, Caption);
    with cboRoute        do if ItemIndex > -1
      then Responses.Update('ROUTE', 1, ItemID, Piece(Items[ItemIndex], U, 3)) // abbreviation
      else Responses.Update('ROUTE', 1, Text, Text);
    with cboSchedule     do Responses.Update('SCHEDULE', 1, Text, Text);
  end;
  with txtQuantity     do Responses.Update('QTY', 1, Text, Text);
  with txtRefills      do Responses.Update('REFILLS', 1, Text, Text);
  with cboPickup       do Responses.Update('PICKUP', 1, ItemID, Text);
  with cboPriority     do Responses.Update('URGENCY', 1, ItemID, Text);
  with memComments     do Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
  with cboSC           do if Enabled then Responses.Update('SC', 1, ItemID, Text);
  with cboIndication   do Responses.Update('INDICATION', 1, Text, Text);
  memOrder.Text := Responses.OrderText;
end;

end.
