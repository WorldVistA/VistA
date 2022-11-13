unit fODMedIn;

{$OPTIMIZATION OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, ORCtrls, StdCtrls, ORFn, ExtCtrls, uConst, ComCtrls, uCore,
  Menus, VA508AccessibilityManager, uIndications;

type
  TfrmODMedIn = class(TfrmODBase)
    lblMedication: TLabel;
    cboMedication: TORComboBox;
    lblDosage: TLabel;
    lblRoute: TLabel;
    cboRoute: TORComboBox;
    lblSchedule: TLabel;
    cboSchedule: TORComboBox;
    Label5: TLabel;
    cboDispense: TORComboBox;
    lblComments: TLabel;
    memComments: TMemo;
    lblPriority: TLabel;
    cboPriority: TORComboBox;
    txtDosage: TCaptionEdit;
    Bevel1: TBevel;
    cboMedAlt: TORComboBox;
    lblIndications: TLabel;
    cboIndication: TORComboBox;
    procedure cboMedicationNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboMedicationSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cboDispenseExit(Sender: TObject);
    procedure cboDispenseMouseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLastDrug: Integer;
    FLastMedID: string;
    FDispenseMsg: string;
    FMedCombo: TORComboBox;
    FIndications: TIndications;
    procedure CheckFormAlt;
    procedure ResetOnMedChange;
    procedure SetAltCombo;
    procedure SetOnOISelect;
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

implementation

{$R *.DFM}

uses rOrders, rODBase, fODMedFA, VAUtils;

const
  TX_NO_MED    = 'Medication must be entered.';
  TX_NO_DOSE   = 'Dosage must be entered.';
  TX_NO_AMPER  = 'Dosage may not contain the ampersand (&) character.';
  TX_NO_ROUTE  = 'Route must be entered.';
  TX_NF_ROUTE  = 'Route not found in the Medication Routes file.';
  TX_NO_SCHED  = 'Schedule must be entered.';
  TX_DOSE_AMT  = 'Dosage must be the amount given, not simply the number of units.';
  TX_SCH_QUOTE = 'Schedule must not have quotemarks in it.';
  TX_SCH_MINUS = 'Schedule must not have a dash at the beginning.';
  TX_SCH_SPACE = 'Schedule must have only one space in it.';
  TX_SCH_LEN   = 'Schedule must be less than 70 characters.';
  TX_SCH_PRN   = 'Schedule cannot include PRN - use Comments to enter PRN.';
  TX_SCH_ZERO  = 'Schedule cannot be Q0.';
  TX_SCH_LSP   = 'Schedule may not have leading spaces.';
  TX_SCH_NS    = 'Unable to resolve non-standard schedule.';
  TX_OUTPT_IV  = 'This patient has not been admitted.  Only IV orders may be entered.';

{ TfrmODBase common methods }

procedure TfrmODMedIn.FormCreate(Sender: TObject);
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
  FillerID := 'PSI'; // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'PSJ OR PAT OE'; // loads formatting info
  StatusText('Loading Default Values');
  // CtrlInits.LoadDefaults(ODForMedIn);            // ODForMedIn returns TStrings with defaults
  sl := TSTringList.Create;
  try
    setODForMedIn(sl);
    CtrlInits.LoadDefaults(sl); // ODForMedIn returns TStrings with defaults
  finally
    sl.Free;
  end;
  InitDialog;
end;

procedure TfrmODMedIn.FormDestroy(Sender: TObject);
begin
  FIndications.Free;
  inherited;
end;

procedure TfrmODMedIn.InitDialog;
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

    FreeAndNil(FIndications);
    FIndications := TIndications.Create(CtrlInits);

    FIndications.Load;
    cboIndication.Items.Text := FIndications.GetIndicationList;
  end;
  StatusText('Initializing Long List');
  cboMedAlt.Visible := False;
  cboMedication.Visible := True;
  cboMedication.InitLongList('');
  ActiveControl := cboMedication;  //SetFocusedControl(FMedCombo);
  StatusText('');
end;

procedure TfrmODMedIn.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    Changing := True;                                     //v12a
    SetControl(cboMedication, 'ORDERABLE', 1);
    ResetOnMedChange;                                     //v12a
    SetOnOISelect;                                        //v12a
    SetAltCombo;                                          //v12a
    //cboMedicationSelect(Self);
    SetControl(cboDispense,   'DRUG',      1);
    SetControl(txtDosage,     'INSTR',     1);
    SetControl(cboRoute,      'ROUTE',     1);
    SetControl(cboSchedule,   'SCHEDULE',  1);
    SetControl(memComments,   'COMMENT',   1);
    SetControl(cboPriority,   'URGENCY',   1);
    { can't edit the orderable item for a med order that has been released }
    if (OrderAction = ORDER_EDIT) and OrderIsReleased(EditOrder)
      then FMedCombo.Enabled := False;
    Changing := False;                                   //v12a
    ControlChange(Self);                                 //v12a
  end;
  if OrderAction <> ORDER_EDIT then SetFocusedControl(FMedCombo);
end;

procedure TfrmODMedIn.Validate(var AnErrMsg: string);
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
  if Length(txtDosage.Text) = 0           then SetError(TX_NO_DOSE);
  if Pos('&', txtDosage.Text) > 0         then SetError(TX_NO_AMPER);
  if Length(cboRoute.Text) = 0            then SetError(TX_NO_ROUTE);
  if (Length(cboRoute.Text) > 0) and (cboRoute.ItemIndex < 0) then
  begin
    LookupRoute(cboRoute.Text, RouteID, RouteAbbr);
    if RouteID = '0'
      then SetError(TX_NF_ROUTE)
      else Responses.Update('ROUTE', 1, RouteID, RouteAbbr);
  end;
  if Length(cboSchedule.Text) = 0         then SetError(TX_NO_SCHED);
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
  if (Length(txtDosage.Text) > 0) and (not ContainsAlpha(txtDosage.Text))
    then SetError(TX_DOSE_AMT);
  if (not OrderForInpatient) and (not MedTypeIsIV(cboMedAlt.ItemIEN))
    then SetError(TX_OUTPT_IV);
end;

{ cboMedication methods }

procedure TfrmODMedIn.ResetOnMedChange;
begin
  ClearControl(cboDispense);
  ClearControl(txtDosage);
  ClearControl(cboRoute);                       // routes should be cached
  ResetControl(cboSchedule);
  ClearControl(memComments);
  ClearControl(memOrder);
end;

procedure TfrmODMedIn.SetAltCombo;
begin
  with cboMedication do
  begin
    FMedCombo := cboMedAlt;
    if cboMedAlt.Items.Count = 0 then
    begin
      CtrlInits.SetListOnly(cboMedAlt, 'ShortList');
      cboMedAlt.InsertSeparator;
    end;
    cboMedAlt.SetExactByIEN(ItemIEN, TrimRight(Piece(Text, '<', 1)));
    cboMedication.Visible := False;
    cboMedAlt.Visible := True;
  end;
end;

procedure TfrmODMedIn.SetOnOISelect;
var
  sl: TStrings;
begin
  with CtrlInits do
  begin
    FLastMedID := FMedCombo.ItemID;
    sl := TSTringList.Create;
    try
      setOIForMedIn(sl, FMedCombo.ItemIEN);
      LoadOrderItem(sl);

    finally
      sl.Free;
    end;
    SetControl(cboDispense, 'Dispense');
    if cboDispense.Items.Count = 1 then
      cboDispense.ItemIndex := 0;
    SetControl(txtDosage, 'Instruct');
    SetControl(cboRoute, 'Route');
    if cboRoute.Items.Count = 1 then
      cboRoute.ItemIndex := 0;
    // cboRoute.InsertSeparator;
    // AppendMedRoutes(cboRoute.Items);
    if DefaultText('DefSched') <> '' then
      cboSchedule.SelectByID(DefaultText('DefSched'));
    OrderMessage(TextOf('Message'));
  end;
end;

procedure TfrmODMedIn.cboMedicationNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
  { retrieves a subset of inpatient medication orderable items }
begin
  inherited;
  // FMedCombo.ForDataUse(SubSetOfOrderItems(StartFrom, Direction, 'S.UD RX', Responses.QuickOrder));
  sl := TStringList.Create;
  try
    setSubSetOfOrderItems(sl, StartFrom, Direction, 'S.UD RX',
      Responses.QuickOrder);
    FMedCombo.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmODMedIn.cboMedicationSelect(Sender: TObject);
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
    SetControl(txtDosage,     'INSTR',     1);
    SetControl(cboRoute,      'ROUTE',     1);
    SetControl(cboSchedule,   'SCHEDULE',  1);
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

procedure TfrmODMedIn.CheckFormAlt;
var
  DrugName, OIName: string;
  Drug, OI: Integer;
begin
  with cboDispense do if (ItemIndex > -1) and (Piece(Items[ItemIndex], U, 4) = 'NF') then
  begin
    SelectFormularyAlt(ItemIEN, Drug, OI, DrugName, OIName, PST_UNIT_DOSE);
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
end;

procedure TfrmODMedIn.cboDispenseExit(Sender: TObject);
var
  AMsg: string;
begin
  inherited;
  with cboDispense do
  begin
    if ItemIEN <> FLastDrug then CheckFormAlt;
    if ItemIEN > 0 then
    begin
      AMsg := DispenseMessage(ItemIEN);
      if memMessage.Text <> AMsg then OrderMessage(AMsg);
    end;
    FLastDrug := ItemIEN;
  end;
end;

procedure TfrmODMedIn.cboDispenseMouseClick(Sender: TObject);
begin
  inherited;
  with cboDispense do
  begin
    if ItemIEN <> FLastDrug then CheckFormAlt;
    if ItemIEN > 0 then OrderMessage(DispenseMessage(ItemIEN));
    FLastDrug := ItemIEN;
  end;
end;

{ all controls }

procedure TfrmODMedIn.ControlChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  with FMedCombo do if ItemIEN > 0
    then Responses.Update('ORDERABLE', 1, ItemID, Piece(Items[ItemIndex], U, 3))
    else Responses.Update('ORDERABLE', 1, '', '');
  with cboDispense   do if ItemIEN > 0
    then Responses.Update('DRUG', 1, ItemID, Piece(Items[ItemIndex], U, 2));
  with txtDosage     do if Length(Text) > 0 then Responses.Update('INSTR', 1, Text, Text);
  with cboRoute      do if ItemIndex > -1
    then Responses.Update('ROUTE', 1, ItemID, Piece(Items[ItemIndex], U, 3))
    else Responses.Update('ROUTE', 1, Text, Text);
  with cboSchedule   do if Length(Text) > 0 then Responses.Update('SCHEDULE', 1, Text, Text);
  with cboPriority   do if ItemIndex > -1   then Responses.Update('URGENCY', 1, ItemID, Text);
  with cboIndication do if Length(Text) > 0 then Responses.Update('Indication', 1, Text, Text);
  with memComments   do                          Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
  memOrder.Text := Responses.OrderText;
end;

end.
