unit fODMedIV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, Grids, StdCtrls, ORCtrls, ComCtrls, ExtCtrls, Buttons, Menus, IdGlobal, strUtils,
  VA508AccessibilityManager, VAUtils, fIVRoutes;

type
  TfrmODMedIV = class(TfrmODBase)
    Label1: TLabel;
    lblAdminTime: TVA508StaticText;
    lblFirstDose: TVA508StaticText;
    lbl508Required: TVA508StaticText;
    VA508CompOrderSig: TVA508ComponentAccessibility;
    VA508CompRoute: TVA508ComponentAccessibility;
    VA508CompType: TVA508ComponentAccessibility;
    VA508CompSchedule: TVA508ComponentAccessibility;
    VA508CompGrdSelected: TVA508ComponentAccessibility;
    pnlTop: TGridPanel;
    pnlTopRight: TGridPanel;
    pnlTopRightTop: TPanel;
    pnlTopRightLbls: TPanel;
    pnlCombo: TPanel;
    cboAdditive: TORComboBox;
    tabFluid: TTabControl;
    cboSolution: TORComboBox;
    lblAmount: TLabel;
    lblComponent: TLabel;
    lblAddFreq: TLabel;
    lblPrevAddFreq: TLabel;
    Panel2: TPanel;
    lblComments: TLabel;
    memComments: TCaptionMemo;
    grdSelected: TCaptionStringGrid;
    txtSelected: TCaptionEdit;
    cboSelected: TCaptionComboBox;
    cboAddFreq: TCaptionComboBox;
    cmdRemove: TButton;
    pnlMiddle: TGridPanel;
    pnlMiddleSub1: TGridPanel;
    pnlMiddleSub2: TGridPanel;
    pnlMiddleSub3: TGridPanel;
    pnlMiddleSub4: TGridPanel;
    pnlMS11: TPanel;
    pnlMS12: TPanel;
    pnlMS21: TPanel;
    pnlMS22: TPanel;
    pnlMS31: TPanel;
    pnlMS41: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    lblPriority: TLabel;
    cboPriority: TORComboBox;
    txtAllIVRoutes: TLabel;
    lblRoute: TLabel;
    cboRoute: TORComboBox;
    lblType: TLabel;
    lblTypeHelp: TLabel;
    cboType: TComboBox;
    lblSchedule: TLabel;
    txtNSS: TLabel;
    cboSchedule: TORComboBox;
    chkPRN: TCheckBox;
    lblLimit: TLabel;
    lblInfusionRate: TLabel;
    pnlXDuration: TPanel;
    pnlDur: TGridPanel;
    pnlTxtDur: TPanel;
    txtXDuration: TCaptionEdit;
    pnlCbDur: TPanel;
    cboDuration: TComboBox;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    txtRate: TCaptionEdit;
    Panel3: TPanel;
    cboInfusionTime: TComboBox;
    chkDoseNow: TCheckBox;
    pnlBottom: TPanel;
    pnlButtons: TPanel;
    pnlMemOrder: TPanel;
    Panel6: TPanel;
    ScrollBox1: TScrollBox;
    pnlForm: TPanel;
    pnlB1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure tabFluidChange(Sender: TObject);
    procedure  cboAdditiveNeedData(Sender: TObject; const StartFrom: string; Direction,
      InsertAt: Integer);
    procedure cboSolutionNeedData(Sender: TObject; const StartFrom: string; Direction,
      InsertAt: Integer);
    procedure cboAdditiveMouseClick(Sender: TObject);
    procedure cboAdditiveExit(Sender: TObject);
    procedure cboSolutionMouseClick(Sender: TObject);
    procedure cboSolutionExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure txtSelectedExit(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure txtSelectedChange(Sender: TObject);
    procedure grdSelectedDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdSelectedKeyPress(Sender: TObject; var Key: Char);
    procedure grdSelectedMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure txtXDurationChange(Sender: TObject);
    procedure pnlXDurationEnter(Sender: TObject);
    procedure txtXDurationExit(Sender: TObject);
    procedure cboScheduleChange(Sender: TObject);
    procedure cboTypeChange(Sender: TObject);
    procedure cboRouteChange(Sender: TObject);
    procedure txtRateChange(Sender: TObject);
    procedure cboPriorityChange(Sender: TObject);
    procedure cboPriorityExit(Sender: TObject);
    procedure cboRouteExit(Sender: TObject);
    procedure txtNSSClick(Sender: TObject);
    procedure cboScheduleClick(Sender: TObject);
    procedure chkPRNClick(Sender: TObject);
    procedure chkDoseNowClick(Sender: TObject);
    procedure loadExpectFirstDose;
    procedure SetSchedule(const x: string);
    procedure cboScheduleExit(Sender: TObject);
    procedure cboInfusionTimeChange(Sender: TObject);
    procedure cboDurationChange(Sender: TObject);
    procedure cboDurationEnter(Sender: TObject);
    procedure cboInfusionTimeEnter(Sender: TObject);
    procedure txtAllIVRoutesClick(Sender: TObject);
    procedure cboRouteClick(Sender: TObject);
    procedure lblTypeHelpClick(Sender: TObject);
    procedure cboSelectedCloseUp(Sender: TObject);
    procedure cboRouteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboScheduleKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboPriorityKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboAddFreqKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboAddFreqCloseUp(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure txtSelectedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboSelectedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboRouteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboScheduleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VA508CompOrderSigStateQuery(Sender: TObject; var Text: string);
    procedure VA508CompRouteInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure VA508CompTypeInstructionsQuery(Sender: TObject; var Text: string);
    procedure VA508CompScheduleInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure VA508CompGrdSelectedCaptionQuery(Sender: TObject;
      var Text: string);
    procedure ScrollBox1Resize(Sender: TObject);
  private
    MinFormHeight: Integer; //Determines when the scrollbars appear
    MinFormWidth: Integer;
    FInpatient: Boolean;
    FNSSAdminTime: string;
    FNSSScheduleType: string;
    OSolIEN: integer;
    OAddIEN: integer;
    OSchedule: string;
    oAdmin: string;
    OrderIEN: string;
    FAdminTimeText: string;
    JAWSON: boolean;
    FOriginalDurationType: integer;
    FOriginalInfusionType: integer;
    FIVTypeDefined: boolean;
    //FInitialOrderID: boolean;
    procedure SetValuesFromResponses;
    procedure DoSetFontSize( FontSize: integer);
    procedure ClickOnGridCell(keypressed: Char);
    procedure SetLimitationControl(aValue: string);
    function CreateOtherSchedule: string;
    function CreateOtherRoute: string;
    procedure UpdateRoute;
    procedure DisplayDoseNow(Status: boolean);
    procedure UpdateDuration(SchType: string);
    procedure ClearAllFields;
    function UpdateAddFreq(OI: integer): string;
    function IsAltCtrl_L_Pressed(Shift : TShiftState; Key : Word) : Boolean;
    procedure SetCtrlAlt_L_LabelAccessText(var Text: string; theLabel : TLabel);
    procedure SetScrollBarHeight(FontSize: Integer);
  public
    OrdAction: integer;
    procedure InitDialog; override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure Validate(var AnErrMsg: string); override;
    procedure SetFontSize( FontSize: integer); override;
    function ValidateInfusionRate(Rate: string): string;
    function IVTypeHelpText: string;
    property NSSAdminTime: string read FNSSAdminTime write FNSSAdminTime;
    property NSSScheduleType: string read FNSSScheduleType write FNSSScheduleType;
  end;

var
  frmODMedIV: TfrmODMedIV;




implementation

{$R *.DFM}

uses ORFn, uConst, rODMeds, rODBase, fFrame, uCore, fOtherSchedule, rCore;

const
  TX_NO_DEA     = 'Provider must have a DEA# or VA# to order this medication';
  TC_NO_DEA     = 'DEA# Required';

type
  TIVComponent = class
  private
    IEN: Integer;
    Name: string;
    Fluid: Char;
    Amount: Integer;
    Units: string;
    Volumes: string;
    AddFreq: string;
  end;

const
  TC_RESTRICT  = 'Ordering Restrictions';
  TX_NO_BASE   = 'A solution must be selected.';
  TX_NO_AMOUNT = 'A valid strength or volume must be entered for ';
  TX_NO_UNITS  = 'Units must be entered for ';
  TX_NO_RATE   = 'An infusion rate must be entered.';
  //TX_BAD_RATE  = 'The infusion rate must be:  # ml/hr  or  text@labels per day';
  TX_BAD_RATE =  'Infusion rate can only be up to 4 digits long or' + CRLF + 'Infusion rate must be # ml/hr or text@labels per day';
  TX_NO_INFUSION_TIME = 'An Infusion length must be entered or the Unit of Time for the Infuse Over Time field needs to be cleared out.';
  TX_NO_SCHEDULE = 'A schedule is required for an intermittent order.';
  TX_BAD_SCHEDULE = 'Unable to resolve non-standard schedule.';
  TX_NO_INFUSION_UNIT = 'Invalid Unit of Time, select either "Minutes" or "Hours" for the Infusion Length';
  TX_BAD_ROUTE = 'Route cannot be free-text';
  TX_LEADING_NUMERIC = 'this additive must start with a leading numeric value';
  TX_BAD_BAG = 'A valid additive frequency must be entered for ';
  Tx_BAG_NO_COMMENTS ='"See Comments" entered for additive ';
  TX_BAG_NO_COMMENTS1 = ' no comments defined for this order.';

(*
  { TIVComponent methods }

procedure TIVComponent.Clear;
begin
  IEN     := 0;
  Name    := '';
  Fluid   := #0;
  Amount  := 0;
  Units   := '';
  Volumes := '';
end;
*)

{ Form methods }

procedure TfrmODMedIV.FormCreate(Sender: TObject);

 //Reduce flicker
 procedure ReplicatePreferences(c: TComponent);
  var
    X: Integer;
  begin

    if c is TListBox then
      exit;
    if (c is TWinControl) then
    begin
      TWinControl(c).DoubleBuffered := true;

    end;
    if (c is TPanel) then
    begin
      TPanel(c).FullRepaint := false;

    end;

    if c.ComponentCount > 0 then
    begin
      for X := (c.ComponentCount - 1) downto 0 do
        ReplicatePreferences(c.Components[X]);
    end;
  end;

var
  Restriction: string;
  I: Integer;
begin
  frmFrame.pnlVisit.Enabled := false;
  AutoSizeDisabled := true;
  inherited;
  AllowQuickOrder := True;
  if dlgFormId = OD_CLINICINF then self.Caption := 'Clinic Infusion Orders';

  CheckAuthForMeds(Restriction);
  if Length(Restriction) > 0 then
  begin
    InfoBox(Restriction, TC_RESTRICT, MB_OK);
    Close;
    Exit;
  end;
  OrdAction := -1;
  DoSetFontSize(MainFontSize);
  FillerID := 'PSIV';                            // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  if dlgFormId = OD_CLINICINF then Responses.Dialog := 'CLINIC OR PAT FLUID OE'
  else Responses.Dialog := 'PSJI OR PAT FLUID OE';    // loads formatting info
  StatusText('Loading Default Values');
  CtrlInits.LoadDefaults(ODForIVFluids);         // ODForIVFluids returns TStrings with defaults
  InitDialog;


  //Set the parent
  memOrder.Parent := pnlMemOrder;
  memOrder.Align := alClient;
  cmdAccept.Parent := pnlButtons;
  cmdQuit.Parent := pnlButtons;
  cmdAccept.Align := alTop;
  cmdQuit.Align := alBottom;

  SetScrollBarHeight(cmdQuit.Font.Size);

  for i := ComponentCount - 1 downto 0 do
  begin
    ReplicatePreferences(Components[i]);
  end;

end;

procedure TfrmODMedIV.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  with grdSelected do for i := 0 to RowCount - 1 do TIVComponent(Objects[0, i]).Free;
  inherited;
  frmFrame.pnlVisit.Enabled := True;
end;

procedure TfrmODMedIV.FormResize(Sender: TObject);
var
isNewOrder: boolean;
begin
  inherited;
  if OrdAction in [ORDER_COPY, ORDER_EDIT] then isNewOrder := false
  else isNewOrder := True;
  with grdSelected do
  begin
    ColWidths[1] := Canvas.TextWidth(' 10000 ') + GetSystemMetrics(SM_CXVSCROLL);
    ColWidths[2] := Canvas.TextWidth('meq.') + GetSystemMetrics(SM_CXVSCROLL);
    //AGP ADDITIVE FREQUENCY CHANGES
    ColWidths[3] := Canvas.TextWidth(lblAddFreq.Caption + '  ') + GetSystemMetrics(SM_CXVSCROLL);
     if IsNewOrder = false then
      begin
        ColWidths[4] := Canvas.TextWidth(lblPrevAddFreq.Caption) + GetSystemMetrics(SM_CXVSCROLL);
        ColWidths[0] := ClientWidth - ColWidths[1] - ColWidths[2] - ColWidths[3] - ColWidths[4] - 5;
      end
    else
      begin
        ColWidths[4] := 0;
        ColWidths[0] := ClientWidth - ColWidths[1] - ColWidths[2] - ColWidths[3] - ColWidths[4] - 25;
      end;
  end;
  lblAmount.Left := grdSelected.Left + grdSelected.ColWidths[0];
  lblAddFreq.Left := grdSelected.Left +  grdSelected.ColWidths[0] +  grdSelected.ColWidths[1] + grdSelected.ColWidths[2];
  if isNewOrder = false then
    begin
      lblPrevAddFreq.Visible := True;
      lblPrevAddFreq.Left := grdSelected.Left +  grdSelected.ColWidths[0] +  grdSelected.ColWidths[1] + grdSelected.ColWidths[2] + grdSelected.ColWidths[3];
    end
  else lblPrevAddFreq.Visible := False;
  self.cboType.SelLength := 0;
  self.cboInfusionTime.SelLength := 0;
  self.cboDuration.SelLength := 0;

end;

{ TfrmODBase overrides }

procedure TfrmODMedIV.InitDialog;
const
  NOSELECTION: TGridRect = (Left: -1; Top: -1; Right: -1; Bottom: -1);
var
  i: Integer;
begin
  inherited;
  //grdSelected.Selection := NOSELECTION;
  //FRouteConflict := False;
  //lblTypeHelp.Hint := IVTypeHelpText;
  ClearAllFields;
  //FIVTypeDefined := false;
  lblType.Hint := IVTypeHelpText;
  cboType.Hint := IVTYpeHelpText;
  with grdSelected do for i := 0 to RowCount - 1 do
  begin
     TIVComponent(Objects[0, i]).Free;
     Rows[i].Clear;
  end;
  grdSelected.RowCount := 1;
  //txtRate.Text := ' ml/hr';   {*kcm*}
  with CtrlInits do
  begin
    SetControl(cboSolution, 'ShortList');
    cboSolution.InsertSeparator;
    SetControl(cboPriority, 'Priorities');
    cboType.Items.Clear;
    cboType.Items.Add('Continuous');
    cboType.Items.Add('Intermittent');
    cboType.ItemIndex := -1;
    cboType.SelLength := 0;
    //SetControl(cboRoute, 'Route');
    if (cboRoute.ItemIndex = -1) and (cboRoute.Text <> '') then cboRoute.Text := '';
    //SetControl(cboSchedule, 'Schedules');
    LoadSchedules(cboSchedule.Items, patient.Inpatient);
    //if (Patient.Inpatient) and (cboSchedule.Items.IndexOfName('Other')<0) then
    if cboSchedule.Items.IndexOf('Other') = -1 then cboSchedule.Items.Add('OTHER');
    cboSchedule.Enabled := False;
    lblschedule.Enabled := False;
    if cboInfusionTime.Items.Count = 0 then
       begin
        cboInfusionTime.Items.add('Minutes');
        cboInfusionTime.Items.Add('Hours');
       end;
    cboInfusionTime.Enabled := false;
    updateDuration('');
    if cboDuration.Items.Count = 0 then
      begin
        cboDuration.Items.Add('L');
        cboDuration.Items.Add('ml');
        cboDuration.Items.Add('days');
        cboDuration.Items.Add('hours');
      end;
    cboDuration.ItemIndex := -1;
    cboDuration.Text := '';
    if self.txtXDuration.Text <> '' then self.txtXDuration.Text := '';
    txtNSS.Visible := false;
    if (chkDoseNow.Visible = true) and (chkDoseNow.Checked = true) then chkDoseNow.Checked := false;
    chkDoseNow.Visible := false;
    chkPRN.Enabled := false;
    //AGP ADDITIVE FREQUENCY CHANGES
    if cboAddFreq.Items.Count = 0 then
      begin
        cboAddFreq.Items.Add('1 Bag/Day');
        cboAddFreq.Items.Add('All Bags');
        cboAddFreq.Items.Add('See Comments');
      end;
  end;
  tabFluid.TabIndex := 0;
  tabFluidChange(Self);            // this makes cboSolution visible
  cboSolution.InitLongList('');
  cboAdditive.InitLongList('');
  JAWSON := true;
  if ScreenReaderActive = false then
    begin
      lblAdminTime.TabStop := false;
      lblFirstDose.TabStop := false;
      memOrder.TabStop := false;
      JAWSON := false;
    end;
  ActiveControl := cboSolution;  //SetFocusedControl(cboSolution);
  StatusText('');
  OSolIEN := 0;
  OAddIEN := 0;
  OSchedule := '';
  oAdmin := '';
  self.txtAllIVRoutes.Visible := false;
  memorder.text := '';
  memOrder.Lines.Clear;
end;

function TfrmODMedIV.IVTypeHelpText: string;
begin
   result := 'Continuous Type:' + CRLF + '     IVs that run at a specified rate?( __ml/hr, __mcg/kg/min, etc)' +
             CRLF + CRLF + 'Intermittent Type:' + CRLF +
             '     IVs administered at scheduled intervals (Q4H, QDay) or One-Time only, ' +
             CRLF + '     over a specified time period?(e.g. infuse over 30 min.?.' + CRLF + CRLF +
             'Examples:' + CRLF + 'Continuous = Infusion/drip' + CRLF + 'Intermittent = IVP/IVPB';
end;

procedure TfrmODMedIV.ScrollBox1Resize(Sender: TObject);
begin
  inherited;
  ScrollBox1.OnResize := nil;
  //At least minimum
   if (pnlForm.Width < MinFormWidth) or (pnlForm.Height < MinFormHeight) then
   pnlForm.Align := alNone;
   pnlForm.AutoSize := false;
   if (pnlForm.Width < MinFormWidth) then pnlForm.Width := MinFormWidth;
   if pnlForm.Height < MinFormHeight then pnlForm.Height := MinFormHeight;


  if (ScrollBox1.Width >= MinFormWidth) then
  begin
   if (ScrollBox1.Height >= (MinFormHeight)) then
   begin
       pnlForm.Align := alClient;
   end else begin
     pnlForm.Align := alTop;
     pnlForm.AutoSize := true;
   end;
  end else begin
   if (ScrollBox1.Height >= (MinFormHeight)) then
   begin
    pnlForm.Align := alNone;
    pnlForm.Top := 0;
    pnlForm.Left := 0;
    pnlForm.AutoSize := false;
    pnlForm.Width := MinFormWidth;
    pnlForm.height :=  ScrollBox1.Height;
   end else begin
    pnlForm.Align := alNone;
    pnlForm.Top := 0;
    pnlForm.Left := 0;
    pnlForm.AutoSize := true;
   end;
  end;

 {
 if ScrollBox1.Height >= (MinFormHeight + 5) then
  begin
      pnlForm.Align := alClient;
      end else
  if (ScrollBox1.Width < MinFormWidth)  then
  begin

   pnlForm.Align := alNone;
   pnlForm.Top := 0;
   pnlForm.Left := 0;
   pnlForm.autosize := false;
   if pnlForm.Width < MinFormWidth then
    pnlForm.Width := MinFormWidth;

   if pnlForm.height < MinFormHeight then
    pnlForm.height :=  MinFormHeight
  end else
  begin
    pnlForm.Align := alTop;
    pnlForm.AutoSize := true;
  end;
  Caption := IntToStr(ScrollBox1.Width); }
  ScrollBox1.OnResize := ScrollBox1Resize;
end;

procedure TfrmODMedIV.SetCtrlAlt_L_LabelAccessText(var Text: string; theLabel : TLabel);
begin
  if theLabel.Visible then
    Text := 'Press Ctrl + Alt + L to access ' + theLabel.Caption;
end;

procedure TfrmODMedIV.lblTypeHelpClick(Sender: TObject);
var
str: string;
begin
  inherited;
    str := IVTypeHelpText;
    infoBox(str, 'Informational Help Text', MB_OK);
end;


procedure TfrmODMedIV.loadExpectFirstDose;
var
i: integer;
AnIVComponent: TIVComponent;
fAddIEN, fSolIEN, Interval, idx: integer;
AdminTime:    TFMDateTime;
Admin, Duration, ShowText, SchTxt, SchType, IVType: string;
doseNow, calFirstDose: boolean;
begin
  idx := self.cboSchedule.ItemIndex;
  IVType := self.cboType.Items.Strings[self.cboType.itemindex];
  if idx = -1 then
    begin
      if IVType = 'Continuous' then
        begin
          self.lblFirstDose.Caption := '';
          self.lblFirstDose.Visible := false;
        end;
      exit;
    end;
  doseNow := true;
  SchType := Piece(self.cboSchedule.Items.Strings[idx],U,3);
  if self.EvtID > 0 then doseNow := false;
  if (IVType = 'Continuous') or ((idx > -1) and ((SchType = 'P') or (SchType = 'O') or (SchType = 'OC')) or
     (self.chkPRN.Checked = True))  then
     begin
       self.lblFirstDose.Caption := '';
       self.lblAdminTime.Caption := '';
       self.lblFirstDose.Visible := false;
       self.lblAdminTime.Visible := false;
       self.lblAdminTime.TabStop := false;
       self.lblFirstDose.TabStop := false;
       if (self.cboType.Text = 'Continuous') or (Piece(self.cboSchedule.Items.Strings[idx],U,3) = 'O') then doseNow := false;
       if chkDoseNow.Checked = true then lblFirstDose.Visible := false;
       if idx > -1 then oSchedule := Piece(self.cboSchedule.Items.Strings[idx],U,1);
       if (self.chkPRN.Checked = True) and (idx > -1) and (LeftStr(Piece(self.cboSchedule.Items.Strings[idx],U,1),3)<> 'PRN') then
          OSchedule := Piece(self.cboSchedule.Items.Strings[idx],U,1) + ' PRN';
       DisplayDoseNow(doseNow);
       exit;
       //  end;
     end
  else if SchType <> 'O' then
    begin
      self.lblAdminTime.Visible := true;
      if FAdminTimeText <> '' then self.lblAdminTime.Caption := 'Admin. Time: ' + FAdminTimeText
      else if Piece(self.cboSchedule.Items[idx],U,4) <> '' then
           self.lblAdminTime.Caption := 'Admin. Time: ' + Piece(self.cboSchedule.Items[idx],U,4)
      else self.lblAdminTime.Caption := 'Admin. Time: Not Defined';
    end;
 DisplayDoseNow(doseNow);
 if chkDoseNow.Checked = true then
   begin
     lblFirstDose.Visible := false;
     Exit;
   end;
 self.lblFirstDose.Visible := True;
 fSolIEN := 0;
 fAddIEN := 0;
 for i := 0 to self.grdSelected.RowCount - 1 do
  begin
   AniVComponent := TIVComponent(self.grdSelected.Objects[0, i]);
   if AnIVComponent = nil then Continue;
   if (AnIVComponent.Fluid = 'B') and (fSolIEN = 0) then fSolIEN := AnIVComponent.IEN;
   if (AnIVComponent.Fluid = 'A') and (fAddIEN = 0) then fAddIEN := AnIVComponent.IEN;
   if (fSolIEN > 0) and (fAddIEN > 0) then break;
  end;
  SchTxt := self.cboSchedule.Text;
  Admin := '';
  if (self.lblAdminTime.visible = True) and (self.lblAdminTime.Caption <> '') then
    begin
      Admin := Copy(self.lblAdminTime.Caption,  14, (Length(self.lblAdminTime.Caption)-1));
      if not CharInSet(Admin[1], ['0'..'9']) then Admin := '';
    end;
  if (fSolIEN = oSolIEN) and (fAddIEN = oAddIEN) and (OSchedule = SchTxt) and (oAdmin = Admin) then CalFirstDose := false
  else
    begin
      CalFirstDose := True;
      oSolIEN := fSolIEN;
      oAddIEN := fAddIEN;
      oSchedule := SchTxt;
      oAdmin := Admin;
    end;
  if CalFirstDose = True then
  begin
    if fAddIEN > 0 then LoadAdminInfo(';' + schTxt, fAddIEN, ShowText, AdminTime, Duration, Admin)
    else LoadAdminInfo(';' + schTxt, fSolIEN, ShowText, AdminTime, Duration, Admin);
    if AdminTime > 0 then
      begin
        ShowText := 'Expected First Dose: ';
        Interval := Trunc(FMDateTimeToDateTime(AdminTime) - FMDateTimeToDateTime(FMToday));
        case Interval of
        0: ShowText := ShowText + 'TODAY ' + FormatFMDateTime('(dddddd) at hh:nn', AdminTime);
        1: ShowText := ShowText + 'TOMORROW ' + FormatFMDateTime('(dddddd) at hh:nn', AdminTime);
        else ShowText := ShowText + FormatFMDateTime('dddddd at hh:nn', AdminTime);
      end;
    end;
    self.lblFirstDose.Caption := ShowText;
  end;
  if (self.lblFirstDose.Visible = true) and (self.lblFirstDose.Caption <> '') and (JAWSON = true) then self.lblFirstDose.TabStop := true
  else self.lblFirstDose.TabStop := false;
  if (self.lblAdminTime.Visible = true) and (self.lblAdminTime.Caption <> '') and (JAWSON = true) then self.lblAdminTime.TabStop := true
  else self.lblAdminTime.TabStop := false;

end;

procedure TfrmODMedIV.VA508CompRouteInstructionsQuery(
  Sender: TObject; var Text: string);
begin
  inherited;
  SetCtrlAlt_L_LabelAccessText(Text, txtAllIVRoutes);
end;

procedure TfrmODMedIV.VA508CompScheduleInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  SetCtrlAlt_L_LabelAccessText(Text, txtNSS);
end;

procedure TfrmODMedIV.VA508CompTypeInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  SetCtrlAlt_L_LabelAccessText(Text, lblTypeHelp);
end;

procedure TfrmODMedIV.VA508CompGrdSelectedCaptionQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if grdSelected.Col = 0 then
    Text := lblComponent.Caption
  else if grdSelected.Col = 1 then
    Text := lblAmount.Caption
  else if grdSelected.Col = 2 then
    Text := lblAmount.Caption + ', Unit'
  else if grdSelected.Col = 3 then
    Text := lblAddFreq.Caption
  else if grdSelected.Col = 4 then
    Text := lblPrevAddFreq.Caption;
end;

procedure TfrmODMedIV.VA508CompOrderSigStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memOrder.Text;
end;

procedure TfrmODMedIV.Validate(var AnErrMsg: string);
var
  DispWarning, ItemOK, Result: Boolean;
  LDec,RDec,x, tempStr, iunit, infError, Bag: string;
  digits, i, j, k, Len, temp, Value: Integer;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  with grdSelected do
  begin
    ItemOK := False;
    for i := 0 to RowCount - 1 do
    begin
      for k := i to RowCount - 1 do
        if not(k = i) and (TIVComponent(Objects[0, k]).IEN = TIVComponent(Objects[0, i]).IEN) then
        begin
        SetError('Duplicate Orderable Items included for '+TIVComponent(Objects[0, k]).Name+'.');
        break;
        end;

      if (Objects[0,i] <> nil) and (TIVComponent(Objects[0, i]).Fluid = 'B') then ItemOK := True;
    end;
    if (not ItemOK) and ((self.cboType.ItemIndex = -1) or (MixedCase(self.cboType.Items.Strings[self.cboType.ItemIndex]) = 'Continuous')) then
        SetError(TX_NO_BASE);
    for i := 0 to RowCount - 1 do
    begin
      if (Objects[0, i] <> nil) and ((Length(Cells[1, i]) = 0) or (StrToFloat(Cells[1,i])=0))
        then SetError(TX_NO_AMOUNT + Cells[0, i]);
      if (Objects[0, i] <> nil) and (Length(Cells[2, i]) = 0)
        then SetError(TX_NO_UNITS + Cells[0, i]);
      if (Objects[0,i] <> nil) and (TIVComponent(Objects[0, i]).Fluid = 'A') then
        begin
          temp := Pos('.', Cells[1, i]);
          if temp > 0 then
            begin
              tempStr := Cells[1, i];
               if temp = 1 then
                 begin
                   SetError(cells[0, i] + TX_LEADING_NUMERIC);
                   Exit;
                 end;
              for j := 1 to temp -1 do if not CharInSet(tempStr[j], ['0'..'9']) then
                begin
                  SetError(cells[0, i] + TX_LEADING_NUMERIC);
                  Exit;
                end;
            end;
           //AGP ADDITIVE FREQUENCY CHANGES
           if MixedCase(self.cboType.Items.Strings[self.cboType.ItemIndex]) = 'Continuous' then
             begin
               Bag := (Cells[3, i]);
               if Length(Bag) = 0 then
                 begin
                   SetError(TX_BAD_BAG + cells[0, i]);
                 end
               else if cboAddFreq.Items.IndexOf(Bag) = -1 then
                  begin
                    SetError(TX_BAD_BAG + cells[0, i]);
                  end
               else if (MixedCase(Bag) = 'See Comments') and ((self.memComments.Text = '') or (self.memComments.Text = CRLF)) then
                  begin
                    SetError(Tx_BAG_NO_COMMENTS + cells[0,i] + Tx_BAG_NO_COMMENTS1);
                  end;
                    
             end;
        end;
  end;
  end;
  if Pos(U, self.memComments.Text) > 0 then SetError('Comments cannot contain a "^".');
  if cboSchedule.ItemIndex > -1 then updateDuration(Piece(cboSchedule.Items.Strings[cboSchedule.itemIndex], U, 3));
  if self.cboPriority.Text = '' then SetError('Priority is required');
  if (cboRoute.ItemIndex = -1) and (cboRoute.Text <> '') then SetError(TX_BAD_ROUTE);
  if (cboRoute.ItemIndex > -1) and (cboRoute.ItemIndex = cboRoute.Items.IndexOf('OTHER')) then
      SetError('A valid route must be selected');
  if self.cboRoute.Text = '' then SetError('Route is required');
  if (self.txtXDuration.Text <> '') and (self.cboduration.Items.IndexOf(SELF.cboDuration.Text) = -1) then
      SetError('A valid duration type is required');
  if (self.txtXDuration.Text = '') and (self.cboduration.Items.IndexOf(SELF.cboDuration.Text) > -1) then
     SetError('Cannot have a duration type without a duration value');

  if self.cboType.ItemIndex = -1 then
    begin
      SetError('IV Type is required');
      Exit;
    end;
  if MixedCase(self.cboType.Items.Strings[self.cboType.ItemIndex]) = 'Continuous' then
     begin
      if Length(txtRate.Text) = 0 then SetError(TX_NO_RATE) else
        begin
          x := Trim(txtRate.Text);
          if pos('@', X) > 0 then
            begin
            LDec := Piece(x, '@', 1);
            RDec := Piece(x, '@', 2);
            if (Length(RDec) = 0) or (Length(RDec) > 2) then x := '';
            end
          else if Pos('.',X)>0 then
            begin
              LDec := Piece(x, '.', 1);
              RDec := Piece(x, '.', 2);
              if Length(LDec) = 0 then SetError('Infusion Rate required a leading numeric value');
              if Length(RDec) > 1 then SetError('Infusion Rate cannot exceed one decimal place');
            end
            else if LeftStr(txtRate.Text, 1) = '0' then
               SetError('Infusion Rate cannot start with a zero.');
          if ( Pos('@',x)=0) then
            begin
              if (Length(x) > 4) then
                begin
                  seterror(TX_BAD_RATE);
                  exit;
                end;
              for i := 1 to Length(x) do
                begin
                  if  not CharInSet(x[i], ['0'..'9']) and (x[i] <> '.') then
                    begin
                      SetError(TX_BAD_RATE);
                      exit;
                    end;
                end;
            end;
          if (pos('ml/hr', X) = 0) and (Length(x) > 0) and (pos('@', X) = 0) then X := X + ' ml/hr';
          if Length(x) = 0 then SetError(TX_BAD_RATE) else Responses.Update('RATE', 1, x, x);
        end;
      if cboduration.text = 'doses' then SetError('Continuous Orders cannot have "doses" as a duration type');
    end
  else if MixedCase(self.cboType.Items.Strings[self.cboType.ItemIndex]) = 'Intermittent' then
     begin
      if (cboInfusionTime.ItemIndex = -1) and (txtRate.Text <> '') then SetError(TX_NO_INFUSION_UNIT);
      if (txtRate.Text = '') and (cboInfusionTime.ItemIndex > -1) then SetError(TX_NO_INFUSION_TIME);
      if (txtRate.Text <> '') then
        begin
          infError := '';
          InfError := ValidateInfusionRate(txtRate.Text);
          if infError <> '' then SetError(InfError);
          Len := Length(txtRate.Text);
          iunit := MixedCase(self.cboInfusionTime.Items.Strings[cboInfusionTime.ItemIndex]);
          if (iunit = 'Minutes') and (Len > 4) then setError('Infuse Over Time cannot exceed 4 spaces for ' + iunit)
          else if (iunit = 'Hours') and (Len > 2) then setError('Infuse Over Time cannot exceed 2 spaces for ' + iunit);
        end;
      if (cboSchedule.ItemIndex = -1) and (cboSchedule.Text = '') and (chkPRN.Checked = false) then SetError(TX_NO_SCHEDULE);
      if (cboSchedule.ItemIndex > -1) and (cboSchedule.Text = '') then
        begin
          cboSchedule.ItemIndex := -1;
          SetError(TX_NO_SCHEDULE)
        end;
      if (cboSchedule.ItemIndex = -1) and (cboSchedule.Text <> '') then SetError(TX_BAD_SCHEDULE);
    end;
  if txtXDuration.Text = '' then
    begin
      if AnErrMsg = '' then exit;
      //if AnErrMsg = '' then self.FInitialOrderID := True;
      //exit;
    end;
  Len := Length(txtXDuration.Text);
  if LeftStr(txtXDuration.Text,1) <> '.' then
    begin
      DispWarning := false;
      Digits := 2;
      if cboDuration.text = 'ml' then digits := 4;
      if ((cboDuration.text = 'days') or (cboDuration.text = 'hours')) and (Len > digits) then
          DispWarning := true
      else if (cboduration.text = 'ml') and (Len > digits) then  DispWarning := true
      else if (cboduration.text = 'L') and (Len > digits) and (Pos('.',txtXDuration.Text) = 0) then DispWarning := True;
      if DispWarning = true then SetError('Duration for ' + cboduration.text + ' cannot be greater than ' + InttoStr(digits) + ' digits.');
    end;
  if (Pos('.', txtXDuration.Text)>0)  then
  begin
    SetError('Invalid Duration, please enter a whole numbers for a duration.');
  end
  else if LeftStr(txtXDuration.text, 1) = '0' then
       SetError('Duration cannot start with a zero.');
  if (cboduration.text = 'doses') then
     begin
       if TryStrToInt(txtXDuration.Text, Value) = false then
         SetError('Duration with a unit of "doses" must be a whole number between 0 and 2000000')
       else if (Value < 0) or (Value > 2000000) then
         SetError('Duration with a unit of "doses" must be greater then 0 and less then 2000000');
     end;
  //if AnErrMsg = '' then self.FInitialOrderID := True;
  
end;

function TFrmODMedIV.ValidateInfusionRate(Rate: string): string;
var
Temp: Boolean;
i: integer;
begin
  Temp := False;
  if Pos('.',Rate) >0 then
    begin
      Result := 'Infuse Over Time can only be a whole number';
      exit;
    end
  else if LeftStr(Rate, 1) = '0' then Result := 'Infuse Over Time cannot start with a zero.';
  for i := 1 to Length(Rate) do if not CharInSet(Rate[i], ['0'..'9']) then Temp := True;
  if Temp = True then Result := 'The Infusion time can only be a whole number';
end;

procedure TfrmODMedIV.SetValuesFromResponses;
var
  x, addRoute, tempSch, AdminTime, TempOrder, tmpSch, tempIRoute, tempRoute, PreAddFreq, DEAFailStr, TX_INFO: string;
  AnInstance, i, idx, j: Integer;
  AResponse, AddFreqResp: TResponse;
  AnIVComponent: TIVComponent;
  AllIVRoute: TStringList;
  PQO: boolean;
begin
  Changing := True;
  //self.FInitialOrderID := false;
  with Responses do
  begin
    SetControl(cboType, 'TYPE', 1);
    if cboType.ItemIndex > -1 then  FIVTypeDefined := True;
    FInpatient := OrderForInpatient;
    AnInstance := NextInstance('ORDERABLE', 0);
    while AnInstance > 0 do
    begin
      AResponse := FindResponseByName('ORDERABLE', AnInstance);
      if AResponse <> nil then
      begin
        x := AmountsForIVFluid(StrToIntDef(AResponse.IValue, 0), 'B');
        AnIVComponent := TIVComponent.Create;
        AnIVComponent.IEN     := StrToIntDef(AResponse.IValue, 0);
        DEAFailStr := '';
        if not FInpatient then
        begin
          DEAFailStr := DEACheckFailedForIVOnOutPatient(AnIVComponent.IEN,'S');
          while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
            begin
              case StrToIntDef(Piece(DEAFailStr,U,1),0) of
                1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
                2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
                4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
                5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
                6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
              end;
              if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
                begin
                  InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
              if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
                begin
                  DEAContext := True;
                  fFrame.frmFrame.mnuFileEncounterClick(self);
                  DEAFailStr := '';
                  DEAFailStr := DEACheckFailedForIVOnOutPatient(AnIVComponent.IEN,'S');
                end
              else
                begin
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
            end
        end else
        begin
          DEAFailStr := DEACheckFailed(AnIVComponent.IEN, FInpatient);
          while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
            begin
              case StrToIntDef(Piece(DEAFailStr,U,1),0) of
                1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
                2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
                4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
                5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
                6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
              end;
              if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
                begin
                  InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
              if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
                begin
                  DEAContext := True;
                  fFrame.frmFrame.mnuFileEncounterClick(self);
                  DEAFailStr := '';
                  DEAFailStr := DEACheckFailed(AnIVComponent.IEN, FInpatient);
                end
              else
                begin
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
            end
        end;
        AnIVComponent.Name    := AResponse.EValue;
        AnIVComponent.Fluid   := 'B';
        AnIVComponent.Amount  := StrToIntDef(Piece(x, U, 2), 0);
        AnIVComponent.Units   := Piece(x, U, 1);
        AnIVComponent.Volumes := Copy(x, Pos(U, x) + 1, Length(x));
        with grdSelected do
        begin
          if Objects[0, RowCount - 1] <> nil then RowCount := RowCount + 1;
          Objects[0, RowCount - 1] := AnIVComponent;
          Cells[0, RowCount - 1] := AnIVComponent.Name;
          if AnIVComponent.Amount <> 0 then
            Cells[1, RowCount - 1] := IntToStr(AnIVComponent.Amount);
          Cells[2, RowCount - 1] := AnIVComponent.Units;
          Cells[3, RowCount - 1] := 'N/A';
        end;
      end;
      AResponse := FindResponseByName('VOLUME', AnInstance);
      if AResponse <> nil then with grdSelected do Cells[1, RowCount - 1] := AResponse.EValue;
      AnInstance := NextInstance('ORDERABLE', AnInstance);
    end; {while AnInstance - ORDERABLE}
    AnInstance := NextInstance('ADDITIVE', 0);
    while AnInstance > 0 do
    begin
      AResponse := FindResponseByName('ADDITIVE', AnInstance);
      if AResponse <> nil then
      begin
        x := AmountsForIVFluid(StrToIntDef(AResponse.IValue, 0), 'A');
        AnIVComponent := TIVComponent.Create;
        AnIVComponent.IEN     := StrToIntDef(AResponse.IValue, 0);
        DEAFailStr := '';
        if not FInpatient then
        begin
          DEAFailStr := DEACheckFailedForIVOnOutPatient(AnIVComponent.IEN,'A');
          while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
            begin
              case StrToIntDef(Piece(DEAFailStr,U,1),0) of
                1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
                2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
                4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
                5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
                6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
              end;
              if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
                begin
                  InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
              if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
                begin
                  DEAContext := True;
                  fFrame.frmFrame.mnuFileEncounterClick(self);
                  DEAFailStr := '';
                  DEAFailStr := DEACheckFailedForIVOnOutPatient(AnIVComponent.IEN,'A');
                end
              else
                begin
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
            end
        end else
        begin
          DEAFailStr := DEACheckFailed(AnIVComponent.IEN, FInpatient);
          while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
            begin
              case StrToIntDef(Piece(DEAFailStr,U,1),0) of
                1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
                2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
                4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
                5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
                6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
              end;
              if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
                begin
                  InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
              if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
                begin
                  DEAContext := True;
                  fFrame.frmFrame.mnuFileEncounterClick(self);
                  DEAFailStr := '';
                  DEAFailStr := DEACheckFailed(AnIVComponent.IEN, FInpatient);
                end
              else
                begin
                  cboAdditive.Text := '';
                  AbortOrder := True;
                  Exit;
                end;
            end
        end;
        AnIVComponent.Name    := AResponse.EValue;
        AnIVComponent.Fluid   := 'A';
        AnIVComponent.Amount  := StrToIntDef(Piece(x, U, 2), 0);
        AnIVComponent.Units   := Piece(x, U, 1);
        AnIVComponent.Volumes := Copy(x, Pos(U, x) + 1, Length(x));
        //AGP ADDITIVE FREQUENCY CHANGES
        AnIVComponent.AddFreq := '';
        PreAddFreq := '';
        AddFreqResp := FindResponseByName('ADDFREQ', AnInstance);
        if AddFreqResp <> nil then
          begin
            if cboAddFreq.Items.IndexOf(AddFreqResp.IValue) = -1 then
                 begin
                   AnIvComponent.AddFreq := '';
                 end
            else AnIvComponent.AddFreq := AddFreqResp.IValue;
            PreAddFreq := AddFreqResp.IValue;
          end;
        with grdSelected do
        begin
          if Objects[0, RowCount - 1] <> nil then RowCount := RowCount + 1;
          Objects[0, RowCount - 1] := AnIVComponent;
          Cells[0, RowCount - 1] := AnIVComponent.Name;
          if AnIVComponent.Amount <> 0 then
            Cells[1, RowCount - 1] := IntToStr(AnIVComponent.Amount);
          Cells[2, RowCount - 1] := AnIVComponent.Units;
          Cells[3, RowCount -1] := AnIVComponent.AddFreq;
          if OrdAction in [ORDER_COPY, ORDER_EDIT] then Cells[4, RowCount -1] := PreAddFreq;
        end;
      end;
      AResponse := FindResponseByName('STRENGTH', AnInstance);
      if AResponse <> nil then with grdSelected do Cells[1, RowCount - 1] := AResponse.EValue;
      AResponse := FindResponseByName('UNITS', AnInstance);
      if AResponse <> nil then with grdSelected do Cells[2, RowCount - 1] := AResponse.EValue;
      AnInstance := NextInstance('ADDITIVE', AnInstance);
    end; {while AnInstance - ADDITIVE}
    SetControl(cboType, 'TYPE', 1);
    if self.grdSelected.RowCount > 0 then self.txtAllIVRoutes.Visible := True;    
    updateRoute;
    AResponse := FindResponseByName('ROUTE', 1);
    if AResponse <> nil then
      begin
        tempRoute := AResponse.EValue;
        if tempRoute <> '' then
          begin
           idx := self.cboRoute.Items.IndexOf(tempRoute);
           if idx > -1 then self.cboRoute.ItemIndex := idx
           else begin
             tempIRoute := AResponse.IValue;
             if tempIRoute <> '' then
               begin
                AllIVRoute := TStringList.Create;
                LoadAllIVRoutes(AllIVRoute);
                idx := -1;
                for i := 0 to AllIVRoute.Count - 1 do
                  begin
                    if Piece(AllIVRoute.Strings[i], U, 1) = tempIRoute then
                      begin
                        idx := i;
                        break;
                      end;
                  end;
                if idx > -1 then
                  begin
                    self.cboRoute.Items.Add(AllIVRoute.Strings[idx]);
                    idx := self.cboRoute.Items.IndexOf(tempRoute);
                    if idx > -1 then self.cboRoute.ItemIndex := idx;
                  end;
                  AllIVRoute.Free;
                //if Pos(U, tempIRoute) = 0 then tempIRoute := tempIRoute + U + tempRoute;
                //self.cboRoute.Items.Add(tempIRoute);
                //idx := self.cboRoute.Items.IndexOf(tempRoute);
                //if idx > -1 then self.cboRoute.ItemIndex := idx;
               end;
           end;
          end;
      end;
    //SetControl(cboRoute, 'ROUTE', 1);
    if (cboRoute.ItemIndex = -1) and (cboRoute.Text <> '') then cboRoute.Text := '';
    if self.cboType.Text = 'Intermittent' then
      begin
         lblInfusionRate.Caption := 'Infuse Over Time (Optional)';
         lblSchedule.Enabled := True;
         cboschedule.Enabled := True;
         //if popDuration.Items.IndexOf(popDoses) = -1 then popDuration.Items.Add(popDoses);
         if cboDuration.Items.IndexOf('doses') = -1 then cboDuration.Items.Add('doses');         
         txtNss.Visible := true;
         chkDoseNow.Visible := true;
         chkPRN.Enabled := True;
         tempSch := '';
         AdminTime := '';
         AResponse := FindResponseByName('SCHEDULE', 1);
         if AResponse <> nil then tempSch := AResponse.EValue;
         lblAdminTime.Visible := True;
         lblAdminTime.Hint := AdminTimeHelpText;
         lblAdminTime.ShowHint := True;
         //Add in Dose Now Checkbox
         SetControl(chkDoseNow, 'NOW', 1);
         //AResponse := Responses.FindResponseByName('ADMIN', 1);
         //if AResponse <> nil then AdminTime := AResponse.EValue;
         //if Action = Order_Copy then FOriginalAdminTime := AdminTime;
         SetSchedule(tempSch);
         //if (cboSchedule.ItemIndex > -1) then lblAdminTime.Caption := 'Admin. Time: ' + Piece(cboSchedule.Items.strings[cboSchedule.itemindex],U,5);
         //if (cboSchedule.ItemIndex > -1) and (Piece(lblAdminTime.Caption, ':' ,2) = ' ') then lblAdminTime.Caption := 'Admin. Time: ' + AdminTime;
         if (OrdAction in [ORDER_COPY, ORDER_EDIT])  then
           begin
            TempOrder := Piece(OrderIEN,';',1);
            TempOrder := Copy(tempOrder, 2, Length(tempOrder));
             if DifferentOrderLocations(tempOrder, Patient.Location) = false then
              begin
                AResponse := Responses.FindResponseByName('ADMIN', 1);
                if AResponse <> nil then AdminTime := AResponse.EValue;
                //lblAdminTime.Caption := 'Admin. Time: ' + AdminTime;
                if (cboSchedule.ItemIndex > -1) and (AdminTime <> '') then
                  begin
                    tmpSch := cboSchedule.Items.Strings[cboSchedule.itemindex];
                    setPiece(tmpSch,U,4,AdminTime);
                    cboSchedule.Items.Strings[cboSchedule.ItemIndex] := tmpSch;
                  end;
              end;
           end;
         //if Piece(lblAdminTime.Caption, ':' ,2) = ' ' then lblAdminTime.Caption := 'Admin. Time: Not Defined';
         SetControl(txtRate,     'RATE',    1);
         cboInfusionTime.Enabled := true;
         PQO := false;
         if Pos('INFUSE OVER',UpperCase(txtRate.Text)) > 0 then
           begin
             txtRate.Text := Copy(txtRate.Text,Length('Infuse over ')+1,Length(txtRate.text));
             PQO := True;
           end;
         if Pos('MINUTE',UpperCase(txtRate.Text))>0 then
           begin
             cboInfusionTime.Text := 'Minutes';
             cboInfusionTime.itemindex := 0;
             //txtRate.Text := Copy(txtRate.Text,Length('Infuse over ')+1,Length(txtRate.text));
             txtRate.Text := Copy(txtRate.Text, 1, Length(txtRate.Text) - 8);
           end
         else if Pos('HOUR',UpperCase(txtRate.Text))>0 then
           begin
             cboInfusionTime.Text := 'Hours';
             cboInfusionTime.ItemIndex := 1;
             //txtRate.Text := Copy(txtRate.Text,Length('Infuse over ')+1,Length(txtRate.text));
             txtRate.Text := Copy(txtRate.Text, 1, Length(txtRate.Text) - 6);
           end
         else if (txtRate.Text <> '') and (PQO = false) and (ValidateInfusionRate(txtRate.Text) ='') then
           begin
             cboInfusionTime.Text := 'Minutes';
             cboInfusionTime.itemindex := 0;
           end;
          For j := 0 to grdSelected.RowCount -1 do
            grdSelected.Cells[3,j] := 'N/A';
      end
    else
      begin
        lblSchedule.Enabled := false;
        cboSchedule.ItemIndex := -1;
        cboSchedule.Enabled := false;
        if chkDoseNow.Visible = true then  chkDoseNow.Checked := false;
        chkDoseNow.Visible := false;
        txtNSS.Visible := false;
        cboInfusionTime.ItemIndex := -1;
        cboInfusionTime.Text := '';
        cboInfusionTime.Enabled := false;
        chkPRN.Checked := false;
        chkPRN.Enabled := false;
        txtRate.Text := '';
        cboDuration.ItemIndex := -1;
        cboDuration.Text := '';
        txtXDuration.Text := '';
        SetControl(txtRate,     'RATE',    1);
        if LowerCase(Copy(ReverseStr(txtRate.Text), 1, 6)) = 'rh/lm '             {*kcm*}
          then txtRate.Text := Copy(txtRate.Text, 1, Length(txtRate.Text) - 6);
      end;
    SetControl(cboPriority, 'URGENCY', 1);
    SetControl(memComments, 'COMMENT', 1);

    AnInstance := NextInstance('DAYS', 0);
    if AnInstance > 0 then
    begin
      AResponse := FindResponseByName('DAYS', AnInstance);
      if AResponse <> nil then
          SetLimitationControl(AResponse.EValue);
    end;
  end; {if...with Responses}
  Changing := False;
  if self.cboSchedule.ItemIndex > -1 then updateDuration(Piece(cboSchedule.Items.Strings[cboSchedule.itemindex],U,3));
  loadExpectFirstDose;
  ControlChange(Self);
end;

procedure TfrmODMedIV.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  OrdAction := OrderAction;
  OrderIEN := id;
  //self.FInitialOrderID := True;
  if self.EvtID > 0 then FAdminTimeText := 'To Be Determined';
//  if isIMO = true then self.Caption := 'Clinic ' + self.Caption;
  if (isIMO) or ((patient.Inpatient = true) and (encounter.Location <> patient.Location)) and (FAdminTimeText = '') then
      FAdminTimeText := 'Not defined for Clinic Locations';
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then
    begin
      SetValuesFromResponses;
    end;
end;

{ tabFluid events }

procedure TfrmODMedIV.tabFluidChange(Sender: TObject);
begin
  inherited;
  case TabFluid.TabIndex of
  0: begin
       cboSolution.Visible := True;
       cboAdditive.Visible := False;
     end;
  1: begin
       cboAdditive.Visible := True;
       cboSolution.Visible := False;
     end;
  end;
  if cboSolution.Visible then
    ActiveControl := cboSolution;
  if cboAdditive.Visible then
    ActiveControl := cboAdditive;
end;

{ cboSolution events }

procedure TfrmODMedIV.cboSolutionNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  cboSolution.ForDataUse(SubSetOfOrderItems(StartFrom, Direction, 'S.IVB RX', Responses.QuickOrder));
end;

procedure TfrmODMedIV.cbotypeChange(Sender: TObject);
var
i: integer;
begin
  inherited;
  //if (self.cbotype.Text = 'Intermittent') or (self.cboType.itemIndex = 1) then
  if (self.cboType.itemIndex = 1) then
    begin
      cboSchedule.ItemIndex := -1;
      lblAdminTime.Caption := '';
      lblAdminTime.Visible := false;
      lblschedule.Enabled := True;
      cboSchedule.Enabled := True;
      txtNSS.Visible := true;
      chkDoseNow.Checked := false;
      chkDoseNow.Visible := true;
      chkPRN.Checked := false;
      chkPRN.Enabled := True;
      lblInfusionRate.Caption := 'Infuse Over Time (Optional)';
      cboInfusionTime.Enabled := true;
      if cboDuration.items.IndexOf('doses') = -1 then cboDuration.Items.Add('doses');
      //AGP ADDITIVE FREQUECNY CHANGES
      lblAddFreq.Caption := 'Additive Frequency';
      for i := 0 to grdselected.RowCount - 1 do
        begin
          if (TIVComponent(grdselected.Objects[0, i]) <> nil) and (TIVComponent(grdselected.Objects[0, i]).Fluid = 'A') then
            begin
              grdSelected.Cells[3, i] := 'N/A';
            end;
        end;
    end
  //else if (self.cbotype.Text = 'Continuous') or (self.cboType.itemIndex = 0) then
  else
    begin
      lblschedule.Enabled := False;
      cboSchedule.ItemIndex := -1;
      cboSchedule.Enabled := False;
      txtNSS.Visible := false;
      chkPRN.Checked := false;
      chkPRN.Enabled := false;
      if chkDoseNow.Visible = true then chkDoseNow.Checked := false;
      chkDoseNow.Visible := false;
      lblInfusionRate.Caption := 'Infusion Rate (ml/hr)*';
      cboInfusionTime.ItemIndex := -1;
      cboInfusionTime.Text := '';
      cboInfusionTime.Enabled := false;
      lblAdminTime.Visible := false;
      updateDuration('');
      cboduration.Items.Delete(cboDuration.Items.IndexOf('doses'));
      lblAddFreq.Caption := 'Additive Frequency*';
      if FIVTypeDefined = True then
        begin
          for i := 0 to grdselected.RowCount - 1 do
            begin
              if (TIVComponent(grdselected.Objects[0, i]) <> nil) and (TIVComponent(grdselected.Objects[0, i]).Fluid = 'A') then
                begin
                  grdSelected.Cells[3, i] := '';
                end;
            end;
        end;
    end;
  FIVTypeDefined := True;
  self.txtRate.Text := '';
  ControlChange(Sender);
end;

procedure TfrmODMedIV.cboTypeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if IsAltCtrl_L_Pressed(Shift, Key) then
    lblTypeHelpClick(lblTypeHelp);
end;

function TfrmODMedIV.IsAltCtrl_L_Pressed(Shift : TShiftState; Key : Word) : Boolean;
begin
  Result := (ssCtrl in Shift) and (ssAlt in Shift) and (Key = Ord('L'));
end;

procedure TfrmODMedIV.chkDoseNowClick(Sender: TObject);
Const
  T  = '"';
  T1 = 'By checking the "Give additional dose now" box, you have actually entered two orders for the same medication.';
  T2 = #13#13'The first order''s administrative schedule is "';
  T3 = #13'The second order''s administrative schedule is "';
  T4 = #13#13'Do you want to continue?';    
  T5 = '" and a priority of "';
  T1A = 'By checking the "Give additional dose now" box, you have actually entered a new order with the schedule "NOW"';
  T2A = ' in addition to the one you are placing for the same medication.';
var
  medNm: string;
  theSch: string;
  ordPriority: string;
  //SchID: integer;
begin
  inherited;
  if (chkDoseNow.Checked) then
  begin
    medNm := 'Test';
    //SchID := cboSchedule.ItemIndex;
    theSch := cboSchedule.Text;
    ordPriority := cboPriority.SelText;
    if length(theSch)>0 then
    begin
      //if (InfoBox(T1+medNm+T+T2+theSch+T+T3+'NOW"'+T4, 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL)then
      //if (InfoBox(T1+T2+theSch+T+T3+'NOW"'+T4, 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL)then
      if (InfoBox(T1+T2+'NOW'+T5+ordPriority+T+T3+theSch+T5+ordPriority+T+T4, 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL)then
      begin
        chkDoseNow.Checked := False;
        Exit;
      end;
    end else
    begin
      //if InfoBox(T1A+T2A+medNm+T+T4, 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL then
      if InfoBox(T1A+T2A+T4, 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL then
      begin
        chkDoseNow.Checked := False;
        Exit;
      end;
    end;
  end;
  ControlChange(self);
end;

procedure TfrmODMedIV.chkPRNClick(Sender: TObject);
begin
  inherited;
  ControlChange(Self);
end;

procedure TfrmODMedIV.cboSolutionMouseClick(Sender: TObject);
var
  AnIVComponent: TIVComponent;
  x,routeIEN, DEAFailStr, TX_INFO: string;
  i: integer;
begin
  inherited;
  if CharAt(cboSolution.ItemID, 1) = 'Q' then              // setup quick order
  begin
    //Clear pre-existing values
    for i := 0 to self.grdSelected.RowCount do
      begin
         if self.grdSelected.Objects[0,i] <> nil then
           begin
             TIVComponent(self.grdSelected.Objects[0,i]).Free;
             self.grdSelected.Rows[i].Clear;
           end
         else self.grdSelected.Rows[i].clear;
      end;
    self.grdSelected.RowCount := 0;
    ControlChange(Sender);
    Responses.QuickOrder := ExtractInteger(cboSolution.ItemID);
    SetValuesFromResponses;
    cboSolution.ItemIndex := -1;
    Exit;
  end;
  if cboSolution.ItemIEN <= 0 then Exit;                   // process selection of solution
  FInpatient := OrderForInpatient;
  DEAFailStr := '';
  if not FInpatient then
  begin
    DEAFailStr := DEACheckFailedForIVOnOutPatient(cboSolution.ItemIEN,'S');
    while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
      begin
        case StrToIntDef(Piece(DEAFailStr,U,1),0) of
          1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
          2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
          3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
          4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
          5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
          6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
        end;
        if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            cboSolution.Text := '';
            Exit;
          end;
        if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
          begin
            DEAContext := True;
            fFrame.frmFrame.mnuFileEncounterClick(self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailedForIVOnOutPatient(cboSolution.ItemIEN,'S');
          end
        else
          begin
            cboSolution.Text := '';
            Exit;
          end;
      end
  end else
  begin
    DEAFailStr := DEACheckFailed(cboSolution.ItemIEN, FInpatient);
    while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
      begin
        case StrToIntDef(Piece(DEAFailStr,U,1),0) of
          1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
          2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
          3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
          4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
          5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
          6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
        end;
        if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            cboSolution.Text := '';
            Exit;
          end;
        if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
          begin
            DEAContext := True;
            fFrame.frmFrame.mnuFileEncounterClick(self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailed(cboSolution.ItemIEN, FInpatient);
          end
        else
          begin
            cboSolution.Text := '';
            Exit;
          end;
      end
  end;
  RouteIEN := Piece(cboSolution.Items.Strings[cboSolution.itemindex],U,4);
  x := AmountsForIVFluid(cboSolution.ItemIEN, 'B');
  AnIVComponent := TIVComponent.Create;
  AnIVComponent.IEN     := cboSolution.ItemIEN;
  AnIVComponent.Name    := Piece(cboSolution.Items[cboSolution.ItemIndex], U, 3);
  AnIVComponent.Fluid   := 'B';
  AnIVComponent.Amount  := StrToIntDef(Piece(x, U, 2), 0);
  AnIVComponent.Units   := Piece(x, U, 1);
  AnIVComponent.Volumes := Copy(x, Pos(U, x) + 1, Length(x));
  cboSolution.ItemIndex := -1;
  with grdSelected do
  begin
    if Objects[0, RowCount - 1] <> nil then RowCount := RowCount + 1;
    Objects[0, RowCount - 1] := AnIVComponent;
    Cells[0, RowCount - 1] := AnIVComponent.Name;
    Cells[1, RowCount - 1] := IntToStr(AnIVComponent.Amount);
    Cells[2, RowCount - 1] := AnIVComponent.Units;
    Cells[3, RowCount - 1] := 'N/A';
    Row := RowCount - 1;
    if Length(Piece(AnIVComponent.Volumes, U, 2)) > 0 then Col := 1 else Col := 0;
  (*  if RowCount = 1 then        // switch to additives after 1st IV
    begin
       tabFluid.TabIndex := 1;
       tabFluidChange(Self);
    end;  *)
  end;
  Application.ProcessMessages;         //CQ: 10157
  updateRoute;
  ClickOnGridCell(#0);
  //updateRoute;
  ControlChange(Sender);
  //updateRoute(routeIEN);
end;

procedure TfrmODMedIV.cboSolutionExit(Sender: TObject);
begin
  inherited;
  if EnterIsPressed then //CQ: 15097
    if (cboSolution.ItemIEN > 0) or
       ((cboSolution.ItemIEN = 0) and (CharAt(cboSolution.ItemID, 1) = 'Q')) then
      cboSolutionMouseClick(Self);
end;

{ cboAdditive events }

procedure TfrmODMedIV.cboAdditiveNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  cboAdditive.ForDataUse(SubSetOfOrderItems(StartFrom, Direction, 'S.IVA RX', Responses.QuickOrder));
end;

procedure TfrmODMedIV.cboAddFreqCloseUp(Sender: TObject);
begin
  inherited;
  with cboAddFreq do
  begin
    if tag < 0 then exit;
    grdSelected.Cells[Tag div 256, Tag mod 256] := MixedCase(items.Strings[itemindex]);
    Tag := -1;
    Hide;
    ControlChange(Sender);
    TControl(self.grdSelected).Enabled := True;
    ActiveControl := self.grdSelected;
  end;
  grdSelected.Refresh;
end;

procedure TfrmODMedIV.cboAddFreqKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_Tab) then
  begin
    cboAddFreqCloseUp(cboAddFreq);
    Key := 0;
  end;
end;

procedure TfrmODMedIV.cboDurationChange(Sender: TObject);
Var
ItemCount, i : Integer;
begin
  //Overwrite the auto complete to need characters up to the first unique character of the selection
  //Loop through the items and see it we have multiple possibilites
  ItemCount := 0;
  For i := 0 to cboDuration.Items.Count - 1 do begin
   If Pos(Uppercase(cboDuration.Text), Uppercase(Copy(cboDuration.Items[i], 1, Length(cboDuration.Text)))) > 0 then
    Inc(ItemCount);
  end;
  //We have finally found the unique value so select it
  If ItemCount = 1 then begin
   For i := 0 to cboDuration.Items.Count - 1 do begin
    If Pos(Uppercase(cboDuration.Text), Uppercase(Copy(cboDuration.Items[i], 1, Length(cboDuration.Text)))) > 0 then begin
     cboDuration.ItemIndex := i;
     break;
    end;
   end;
  end;
  inherited;
  if (FOriginalDurationType > -1) and (FOriginalDurationType <> cboDuration.ItemIndex) then
    begin
      self.txtXDuration.Text := '';
      FOriginalDurationType := cboDuration.ItemIndex;
    end;
  if (FOriginalDurationType = -1) and (cboDuration.ItemIndex > -1) then FOriginalDurationType := cboDuration.ItemIndex;
  controlchange(sender);
end;

procedure TfrmODMedIV.cboDurationEnter(Sender: TObject);
begin
  inherited;
  FOriginalDurationType := cboDuration.ItemIndex;
end;


procedure TfrmODMedIV.cboInfusionTimeChange(Sender: TObject);
begin
  inherited;
  if (FOriginalInfusionType > -1) and (FOriginalInfusionType <> cboInfusionTime.ItemIndex) then
     begin
       self.txtRate.Text := '';
       FOriginalInfusionType := cboInfusionTime.ItemIndex;
     end;
  if (FOriginalInfusionType = -1) and (cboInfusionTime.ItemIndex > -1) then FOriginalInfusionType := cboInfusionTime.ItemIndex;
  ControlChange(Sender);
end;

procedure TfrmODMedIV.cboInfusionTimeEnter(Sender: TObject);
begin
  inherited;
  FOriginalInfusionType := self.cboInfusionTime.ItemIndex;
end;

procedure TfrmODMedIV.cboPriorityChange(Sender: TObject);
begin
  inherited;
  ControlChange(sender);
end;

procedure TfrmODMedIV.cboPriorityExit(Sender: TObject);
begin
  inherited;
  if cboPriority.Text = '' then
    begin
      infoBox('Priority must have a value assigned to it', 'Warning', MB_OK);
      cboPriority.SetFocus;
    end;
end;

procedure TfrmODMedIV.cboPriorityKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboPriority.Text = '') then cboPriority.ItemIndex := -1;
end;

procedure TfrmODMedIV.cboRouteChange(Sender: TObject);
begin
  inherited;
  if cboRoute.ItemIndex = cboRoute.Items.IndexOf('OTHER') then cboRouteClick(cboRoute);
  ControlChange(sender);
end;

procedure TfrmODMedIV.cboRouteClick(Sender: TObject);
var
otherRoute, temp: string;
idx, oidx: integer;
begin
  inherited;
  oidx := cboRoute.Items.IndexOf('OTHER');
  if oidx = -1 then exit;
  
  if cboRoute.ItemIndex = oidx then
    begin
      otherRoute := CreateOtherRoute;
      if length(otherRoute) > 1 then
        begin
          idx := cboRoute.Items.IndexOf(Piece(OtherRoute, U, 2));
          if idx > -1 then
            begin
              temp := cboRoute.Items.Strings[idx];
              //setPiece(temp,U,5,'1');
              cboRoute.Items.Strings[idx] := temp;
            end
          else
          begin
             cboRoute.Items.Add(otherRoute);
             idx := cboRoute.Items.IndexOf(Piece(OtherRoute, U, 2));
          end;
          cboRoute.ItemIndex := idx;
        end
      else
        begin
          cboRoute.ItemIndex := -1;
          cboRoute.SetFocus;
        end;
    end;
end;

procedure TfrmODMedIV.cboRouteExit(Sender: TObject);
begin
  inherited;
(*  if (cboRoute.Text <> '') and (cboRoute.ItemIndex = -1)  then
    begin
      infoBox(TX_BAD_ROUTE,'Warning',MB_OK);
      cboRoute.SetFocus;
    end; *)
end;

procedure TfrmODMedIV.cboRouteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if IsAltCtrl_L_Pressed(Shift, Key) then
    txtAllIVRoutesClick(txtAllIVRoutes);
end;

procedure TfrmODMedIV.cboRouteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboRoute.Text = '') then cboRoute.ItemIndex := -1;  
end;

procedure TfrmODMedIV.cboAdditiveMouseClick(Sender: TObject);
var
  AnIVComponent: TIVComponent;
  x, routeIEN, DEAFailStr, TX_INFO: string;
begin
  inherited;
  if cboAdditive.ItemIEN <= 0 then Exit;
  FInpatient := OrderForInpatient;
  DEAFailStr := '';
  if not FInpatient then
  begin
    DEAFailStr := DEACheckFailedForIVOnOutPatient(cboAdditive.ItemIEN,'A');
    while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
      begin
        case StrToIntDef(Piece(DEAFailStr,U,1),0) of
          1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
          2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
          3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
          4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
          5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
          6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
        end;
        if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            cboAdditive.Text := '';
            Exit;
          end;
        if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
          begin
            DEAContext := True;
            fFrame.frmFrame.mnuFileEncounterClick(self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailedForIVOnOutPatient(cboAdditive.ItemIEN,'A');
          end
        else
          begin
            cboAdditive.Text := '';
            Exit;
          end;
      end;
  end else
  begin
    DEAFailStr := DEACheckFailed(cboAdditive.ItemIEN, FInpatient);
    while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
      begin
        case StrToIntDef(Piece(DEAFailStr,U,1),0) of
          1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
          2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
          3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
          4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
          5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
          6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
        end;
        if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            cboAdditive.Text := '';
            Exit;
          end;
        if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
          begin
            DEAContext := True;
            fFrame.frmFrame.mnuFileEncounterClick(self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailed(cboAdditive.ItemIEN, FInpatient);
          end
        else
          begin
            cboAdditive.Text := '';
            Exit;
          end;
      end;
  end;
  routeIEN := Piece(cboAdditive.Items.Strings[cboAdditive.itemindex],U,4);
  x := AmountsForIVFluid(cboAdditive.ItemIEN, 'A');
  AnIVComponent := TIVComponent.Create;
  AnIVComponent.IEN     := cboAdditive.ItemIEN;
  AnIVComponent.Name    := Piece(cboAdditive.Items[cboAdditive.ItemIndex], U, 3);
  AnIVComponent.Fluid   := 'A';
  AnIVComponent.Amount  := 0;
  AnIVComponent.Units   := Piece(x, U, 1);
  AnIVComponent.Volumes := '';
  cboAdditive.ItemIndex := -1;
  with grdSelected do
  begin
    if Objects[0, RowCount - 1] <> nil then RowCount := RowCount + 1;
    Objects[0, RowCount - 1] := AnIVComponent;
    Cells[0, RowCount - 1] := AnIVComponent.Name;
    Cells[2, RowCount - 1] := AnIVComponent.Units;
    Cells[3, RowCount -1] :=  UpdateAddFreq(AnIVComponent.IEN);
    Row := RowCount - 1;
    Col := 1;
  end;
  Application.ProcessMessages;         //CQ: 10157
  ClickOnGridCell(#0);
  updateRoute;
  ControlChange(Sender);
  //UpdateRoute(RouteIEN);
end;

procedure TfrmODMedIV.cboAdditiveExit(Sender: TObject);
begin
  inherited;
  if (cboAdditive.ItemIEN > 0) and (EnterIsPressed) then
    cboAdditiveMouseClick(Self);
end;

{ grdSelected events }

procedure TfrmODMedIV.ClearAllFields;
begin
  self.cboType.ItemIndex := -1;
  self.cboType.Text := '';
  self.memComments.Text := '';
  self.txtRate.Text := '';
  self.txtXDuration.text := '';
  self.cboDuration.ItemIndex := -1;
  self.cboDuration.Text := '';
  self.txtAllIVRoutes.Visible := false;
  //self.FInitialOrderID := True;
  cbotypeChange(self.cboType);
  if self.cboroute.Items.Count > 0 then self.cboRoute.Clear;
  FIVTypeDefined := false;
end;

procedure TfrmODMedIV.ClickOnGridCell(keypressed: Char);
var
  AnIVComponent: TIVComponent;

  procedure PlaceControl(AControl: TWinControl; keypressed: Char);
  var
    ARect: TRect;
  begin
    with AControl do
    begin
      ARect := grdSelected.CellRect(grdSelected.Col, grdSelected.Row);
      SetBounds(ARect.Left + grdSelected.Left + 1,  ARect.Top  + grdSelected.Top + 1,
                ARect.Right - ARect.Left + 1,       ARect.Bottom - ARect.Top + 1);
      BringToFront;
      Show;
      SetFocus;
      if AControl is TComboBox then                    //CQ: 10157
      begin
        TComboBox(AControl).DroppedDown := True;
        TControl(self.grdSelected).Enabled := false;
      end
      else if AControl is TCaptionEdit then
      begin
        if not(keypressed = #0) then
        begin
          TCaptionEdit(AControl).Text := keypressed;
          TCaptionEdit(AControl).SelStart := 1;
        end;
      end;
    end;
  end;

begin
  AnIVComponent := TIVComponent(grdSelected.Objects[0, grdSelected.Row]);
  if (AnIVComponent = nil) or (grdSelected.Col = 0) then
    begin
      if (AnIVComponent <> nil) and (grdSelected.Col = 0) then grdSelected.Refresh;
      Exit;
    end;
  // allow selection if more the 1 unit to choose from
  if (grdSelected.Col = 2) and (Length(Piece(AnIVComponent.Units, U, 2)) > 0) then
  begin
    PiecesToList(AnIVComponent.Units, U, cboSelected.Items);
    cboSelected.ItemIndex := cboSelected.Items.IndexOf(grdSelected.Cells[grdSelected.Col, grdSelected.Row]);
    cboSelected.Tag  := (grdSelected.Col * 256) + grdSelected.Row;
    PlaceControl(cboSelected,keypressed);
  end;
  // allow selection if more than 1 volume to choose from
  if (grdSelected.Col = 1) and (Length(Piece(AnIVComponent.Volumes, U, 2)) > 0) then
  begin
    PiecesToList(AnIVComponent.Volumes, U, cboSelected.Items);
    cboSelected.ItemIndex := cboSelected.Items.IndexOf(grdSelected.Cells[grdSelected.Col, grdSelected.Row]);
    cboSelected.Tag  := (grdSelected.Col * 256) + grdSelected.Row;
    PlaceControl(cboSelected,keypressed);
  end;
  // display text box to enter strength if the entry is an additive
  if (grdSelected.Col = 1) and (AnIVComponent.Fluid = 'A') then
  begin
    txtSelected.Text := grdSelected.Cells[grdSelected.Col, grdSelected.Row];
    txtSelected.Tag  := (grdSelected.Col * 256) + grdSelected.Row;
    PlaceControl(txtSelected,keypressed);
  end;
  // AGP ADDITIVE FREQUENCY CHANGES
  if (Self.cboType.ItemIndex < 1) and (grdSelected.Col = 3) and (AnIVComponent.Fluid = 'A') then
  begin
    cboAddFreq.ItemIndex := cboAddFreq.Items.IndexOf(grdSelected.Cells[grdSelected.Col, grdSelected.Row]);
    cboAddFreq.Tag  := (grdSelected.Col * 256) + grdSelected.Row;
    PlaceControl(cboAddFreq,keypressed);
  end;
end;

procedure TfrmODMedIV.txtSelectedChange(Sender: TObject);   // text editor for grid
begin
  inherited;
  with txtSelected do
  begin
    if Tag < 0 then Exit;
    grdSelected.Cells[Tag div 256, Tag mod 256] := Text;
  end;
  ControlChange(Sender);
end;

procedure TfrmODMedIV.txtSelectedExit(Sender: TObject);
begin
  inherited;
  with txtSelected do
  begin
    grdSelected.Cells[Tag div 256, Tag mod 256] := Text;
    Tag := -1;
    Hide;
  end;
  grdSelected.Refresh;
end;



procedure TfrmODMedIV.txtSelectedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_Tab) then
    begin
      ActiveControl := grdSelected;
      Key := 0;
    end;
end;

procedure TfrmODMedIV.cboScheduleChange(Sender: TObject);
var
othSch: string;
idx: integer;
begin
  inherited;
   if self.txtXDuration.Enabled = true then
     begin
       self.txtXDuration.Text := '';
       self.cboDuration.ItemIndex := -1;
     end;
   if self.cboSchedule.ItemIndex > -1 then
      begin
        if cboSchedule.ItemIndex = cboSchedule.Items.IndexOf('Other') then
          begin
            othSch := CreateOtherSchedule;
            if length(trim(othSch)) > 1 then
              begin
                cboSchedule.Items.Add(othSch + U + U + NSSScheduleType + U + NSSAdminTime);
                idx := cboSchedule.Items.IndexOf(Piece(OthSch, U, 1));
                cboSchedule.ItemIndex := idx;
            end
            else cboSchedule.itemindex := -1;
        end;
        if cboSchedule.itemIndex > -1  then  updateDuration(Piece(cboSchedule.Items.Strings[cboSchedule.itemindex],U,3));
      end;
  ControlChange(sender);
end;

procedure TfrmODMedIV.cboScheduleClick(Sender: TObject);
var
  othSch: string;
  idx: integer;
begin
  inherited;
  if cboSchedule.ItemIndex = cboSchedule.Items.IndexOf('Other') then
    begin
      othSch := CreateOtherSchedule;
      if length(trim(othSch)) > 1 then
        begin
          cboSchedule.Items.Add(othSch + U + U + NSSScheduleType + U + NSSAdminTime);
          idx := cboSchedule.Items.IndexOf(Piece(OthSch, U, 1));
          cboSchedule.ItemIndex := idx;
        end;
    end
  else
    begin
      NSSAdminTime := '';
      NSSScheduleType := '';
    end;
end;

procedure TfrmODMedIV.cboScheduleExit(Sender: TObject);
begin
  inherited;
    if (cboSchedule.ItemIndex = -1) and (cboSchedule.Text <> '') then
    begin
      infoBox('Please select a valid schedule from the list.'+ CRLF + CRLF +
              'If you would like to create a Day-of-Week schedule please select ''OTHER'' from the list.',
              'Incorrect Schedule.', MB_OK);
      cboSchedule.Text := '';
      cboSchedule.SetFocus;
    end;
    if (cboSchedule.ItemIndex > -1) and (cboSchedule.Text = '') then cboSchedule.ItemIndex := -1;
end;

procedure TfrmODMedIV.cboScheduleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if IsAltCtrl_L_Pressed(Shift, Key) then
    txtNSSClick(txtNSS);
end;

procedure TfrmODMedIV.cboScheduleKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboSchedule.Text = '') then cboSchedule.ItemIndex := -1;  
end;

procedure TfrmODMedIV.cboSelectedCloseUp(Sender: TObject);
begin
  inherited;
  with cboSelected do
  begin
    if tag < 0 then exit;
    grdSelected.Cells[Tag div 256, Tag mod 256] := MixedCase(items.Strings[itemindex]);
    Tag := -1;
    Hide;
    ControlChange(Sender);
    TControl(self.grdSelected).Enabled := True;
    ActiveControl := self.grdSelected;
  end;
  grdSelected.Refresh;
end;

procedure TfrmODMedIV.cboSelectedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_Tab) then
  begin
    cboSelectedCloseUp(cboSelected);
    Key := 0;
  end;
end;

procedure TfrmODMedIV.cmdRemoveClick(Sender: TObject);  // remove button for grid
var
  i, stRow, stRowCount: Integer;
begin
  inherited;
  with grdSelected do
  begin
    if Row < 0 then Exit;
    stRow := Row;
    stRowCount := RowCount;
    if Objects[0, Row] <> nil then TIVComponent(Objects[0, Row]).Free;
    for i := Row to RowCount - 2 do Rows[i] := Rows[i + 1];
    Rows[RowCount - 1].Clear;
    RowCount := RowCount - 1;
  end;
  updateRoute;
  if (stRowCount = 1) and (stRow = 0) then
    begin
      //self.cboRoute.ItemIndex := -1;
      ClearAllFields;
    end;
  ControlChange(Sender);
end;

{ update Responses & Create Order Text }

procedure TfrmODMedIV.ControlChange(Sender: TObject);
var
  i, CurAdd, CurBase, idx: Integer;
  adminTime,x,xlimIn,xLimEx,eSch,iSch,iType, tmpdur, tmpSch, tmpRate: string;
  AnIVComponent: TIVComponent;
  FQOSchedule: TResponse;

  function IsNumericRate(const x: string): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 1 to Length(x) do if not CharInSet(x[i], ['0'..'9','.']) then Result := False;
  end;

begin
  inherited;
  if Changing then Exit;
  loadExpectFirstDose;
//  FQOSchedule := TResponse.Create;
  FQOSchedule := Responses.FindResponseByName('SCHEDULE',1);
  if FQOSchedule <> nil then
  begin
    eSch := FQOSchedule.EValue;
    iSch := FQOSchedule.IValue;
  end;
  //if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
  Responses.Clear;   // want this to clear even after SetupDialog in case instances don't match
  CurAdd := 1; CurBase := 1;
  tmpRate := '';
  with grdSelected do for i := 0 to RowCount - 1 do
  begin
    AnIVComponent := TIVComponent(Objects[0, i]);
    if AnIVComponent = nil then Continue;
    with AnIVComponent do
    begin
      if Fluid = 'B' then                        // Solutions
      begin
        if IEN > 0                then Responses.Update('ORDERABLE', CurBase, IntToStr(IEN), Name);
        if Length(Cells[1,i]) > 0 then Responses.Update('VOLUME',    CurBase, Cells[1,i], Cells[1,i]);
        Inc(CurBase);
      end; {if Fluid B}
      if Fluid = 'A' then                        // Additives
      begin
        if IEN > 0                then Responses.Update('ADDITIVE', CurAdd, IntToStr(IEN), Name);
        if Length(Cells[1,i]) > 0 then Responses.Update('STRENGTH', CurAdd, Cells[1,i], Cells[1,i]);
        if Length(Cells[2,i]) > 0 then Responses.Update('UNITS',    CurAdd, Cells[2,i], Cells[2,i]);
        //AGP ADDITIVE FREQUECNY CHANGES
        if (Length(Cells[3,i]) > 0) and (Cells[3,i] <> 'N/A') then Responses.Update('ADDFREQ',    CurAdd, Cells[3,i], Cells[3,i]);
        Inc(CurAdd);
      end; {if Fluid A}
    end; {with AnIVComponent}
  end; {with grdSelected}
  x := txtRate.Text;
  xlimIn := '';
  xlimEx := '';
  if length(txtXDuration.Text) > 0 then
  begin
    tmpDur := LowerCase(cboDuration.Text);
    if (tmpDur = 'l') or (tmpDur = 'ml') then
    begin
      xlimEx := 'with total volume ' +  txtXDuration.Text + self.cboDuration.items.strings[self.cboDuration.itemindex];
      xlimIn := 'with total volume ' +  txtXDuration.Text + self.cboDuration.items.strings[self.cboDuration.itemindex];
    end
    else if (tmpDur = 'days') or (tmpDur = 'hours') then
    begin
      xlimEx := 'for ' + txtXDuration.Text + ' ' +  self.cboDuration.items.strings[self.cboDuration.itemindex];
      xlimIn := 'for ' + txtXDuration.Text + ' ' +  self.cboDuration.items.strings[self.cboDuration.itemindex];
    end
    else if tmpDur = 'doses' then
      begin
         xlimEx := 'for a total of ' + txtXDuration.Text + ' ' +  self.cboDuration.items.strings[self.cboDuration.itemindex];
         xlimIn := 'for a total of ' + txtXDuration.Text + ' ' +  self.cboDuration.items.strings[self.cboDuration.itemindex];
      end
   else  begin
      xlimIn := '';
      xlimEx := '';
    end;
  end;
  if (cboType.ItemIndex > -1) and (cboType.Items.Strings[cboType.ItemIndex] = 'Intermittent') then iType := 'I'
  else if (cboType.ItemIndex > -1) and (cboType.Items.Strings[cboType.ItemIndex] = 'Continuous') then iType := 'C'
  else iType := '';
  Responses.Update('TYPE',1,iType,cboType.Text);
  Responses.Update('ROUTE',1,cboRoute.ItemID,cboRoute.Text);
  tmpSch := UpperCase(Trim(cboSchedule.Text));
  if chkPRN.Checked then tmpSch := tmpSch + ' PRN';
  if UpperCase(Copy(tmpSch, Length(tmpSch) - 6, Length(tmpSch))) = 'PRN PRN'
  then tmpSch := Copy(tmpSch, 1, Length(tmpSch) - 4);
  Responses.Update('SCHEDULE',1,tmpSch,tmpSch);
  (*adminTime := Piece(lblAdminTime.Caption,':',2);
  adminTime := Copy(adminTime,1,Length(adminTime));
  if (Action in [ORDER_COPY, ORDER_EDIT]) and ((FAdminTimeDelay <> '') or (FAdminTimeClinic <> '')) and
      (cboSchedule.ItemIndex = FOriginalScheduleIndex) then  Responses.Update('ADMIN',1,FOriginalAdminTime,FOriginalAdminTime)
  else Responses.Update('ADMIN',1,adminTime,adminTime);*)
  idx := self.cboSchedule.ItemIndex;
  if idx > -1 then
     begin
       adminTime := Piece(lblAdminTime.Caption,':',2);
       adminTime := Copy(adminTime,2,Length(adminTime));
       if FAdminTimeText <> '' then AdminTime :=  '';
       if AdminTime = 'Not Defined' then AdminTime := '';
       Responses.Update('ADMIN',1,adminTime,adminTime);
     end;
  if IsNumericRate(x) then
    begin
      if cboInfusionTime.Enabled = true then
        begin
           idx := cboInfusionTime.Items.IndexOf(cboInfusionTime.Text);
           if idx > -1 then x := x + ' ' + cboInfusionTime.Items.Strings[idx];
           tmpRate := 'Infuse Over ' + x;
        end
      else
        if pos('ml/hr', x)= 0 then  x := x + ' ml/hr';
    end;
  if (Pos('@',x)>0) and (Piece(x,'@',1) = IntToStr(StrToIntDef(Piece(x,'@',1), -1))) and (cboInfusionTime.Enabled = false) then
    begin
      if Pos('ml/hr', x) = 0 then
         x := Piece(x,'@',1) + ' ml/hr@' + Copy(x, Pos('@',x) + 1, Length(x));
    end;
  with txtRate     do if (Length(Text) > 0) then
    begin
      if tmpRate = '' then Responses.Update('RATE', 1, x, x)
      else Responses.Update('RATE', 1, 'INFUSE OVER ' + x, tmpRate);
    end;
  with cboPriority do if ItemIndex > -1     then Responses.Update('URGENCY', 1, ItemID, Text);
  if Length(xlimIn)>0 then Responses.Update('DAYS',1, xlimIn, xlimEx);
  with memComments do if GetTextLen > 0     then Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
  if (chkDoseNow.Visible = True) and (chkDoseNow.Checked = True) then
    Responses.Update('NOW', 1, '1', 'NOW')
  else Responses.Update('NOW', 1, '', '');
  memOrder.Text := Responses.OrderText;
  (* (Length(eSch)>0) or (Length(iSch)>0) then
    Responses.Update('SCHEDULE',1,iSch,eSch);  *)
end;

function TfrmODMedIV.CreateOtherRoute: string;
var
  aRoute: string;
begin
  aRoute := '';
  Result := '';
  if not ShowOtherRoutes(aRoute) then
    begin
      cboRoute.ItemIndex := -1;
      cboRoute.Text := '';
    end
  else
    begin
      Result := aRoute;
    end;
end;

function TfrmODMedIV.CreateOtherSchedule: string;
var
  aSchedule: string;
begin
  aSchedule := '';
  cboSchedule.ItemIndex := -1;
  cboSchedule.Text      := '';
  cboSchedule.DroppedDown := false;
  if ShowOtherSchedule(aSchedule) then
    begin
        Result := Piece(aSchedule,U,1);
        NSSAdminTime := Piece(aschedule,u,2);
        NSSScheduleType := Piece(ASchedule, U, 3);
    end;
end;

procedure TfrmODMedIV.grdSelectedDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  inherited;
  //if Sender = ActiveControl then Exit;
  //if not (gdSelected in State) then Exit;
  with Sender as TStringGrid do
  begin
    if State = [gdSelected..gdFocused] then
      begin
        Canvas.Font.Color := Get508CompliantColor(clWhite);
        Canvas.Brush.Color := clHighlight;
        //Canvas.Font.Color := clHighlightText;
        Canvas.Font.Style := [fsBold];
        Canvas.MoveTo(Rect.Left,Rect.top);
      end
    else
      begin
        if (ACol = 4) and (ColWidths[4] > 0) then
          Canvas.Brush.Color := clInactiveBorder
        else  Canvas.Brush.Color := clWindow;
        Canvas.Font := Font;
      end;
    Canvas.FillRect(Rect);
    //Canvas.Brush.Color := Color;

    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
  end;
end;

procedure TfrmODMedIV.SetFontSize( FontSize: integer);
begin
  inherited SetFontSize( FontSize );
  DoSetFontSize( FontSize );
end;

procedure TfrmODMedIV.DisplayDoseNow(Status: boolean);
begin
  if self.EvtID > 0 then Status := false;
  if status = false then
    begin
      if (self.chkDoseNow.Visible = true) and (self.chkDoseNow.Checked = true) then self.chkDoseNow.Checked := false;
      self.chkDoseNow.Visible := false;
    end;
  if status = true then self.chkDoseNow.Visible := true;
end;

procedure TfrmODMedIV.DoSetFontSize( FontSize: integer);
begin
  tabFluid.TabHeight := Abs(Font.Height) + 4;
  grdSelected.DefaultRowHeight := Abs(Font.Height) + 8;

  SetScrollBarHeight(FontSize);

end;

procedure TfrmODMedIV.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    //Back-tab works the same as forward-tab because there are only two tabs.
    tabFluid.TabIndex := (tabFluid.TabIndex + 1) mod tabFluid.Tabs.Count;
    Key := 0;
    tabFluidChange(tabFluid);
  end;
end;

procedure TfrmODMedIV.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (ActiveControl = grdSelected) then
  Key := #0;   //Don't let the base class turn it into a forward tab!
  inherited;
end;

procedure TfrmODMedIV.grdSelectedKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  ClickOnGridCell(Key);
end;

procedure TfrmODMedIV.grdSelectedMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ClickOnGridCell(#0);
end;

procedure TfrmODMedIV.txtXDurationChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  ControlChange(Sender);
end;


procedure TfrmODMedIV.pnlXDurationEnter(Sender: TObject);
begin
  inherited;
  txtXDuration.SetFocus;
end;

procedure TfrmODMedIV.SetLimitationControl(aValue: string);
var
  limitUnit,limitValue,tempval: string;
begin
  limitUnit  := '';
  limitValue := '';
  tempVal := '';
  if pos('dose',AValue)>0 then
    begin
      limitValue := Piece(aValue,' ',5);
      limitUnit := 'doses';
    end;
  if (( CharAt(aValue,1)= 'f') or ( CharAt(aValue,1)= 'F')) and (pos('dose',aValue)=0) then  //days, hours
  begin
     limitValue := Piece(aValue,' ',2);
     limitUnit  := Piece(aValue,' ',3);
  end;
  if (CharAt(aValue,1)= 'w') or (CharAt(aValue,1)= 'W') then  //L, ml
  begin
     tempval  := Piece(aValue,' ',4);
     limitValue := FloatToStr(ExtractFloat(tempVal));
     limitUnit  := Copy(tempVal,length(limitValue)+1,Length(tempVal));
  end;
  if isNumeric(CharAt(aValue,1)) then
  begin
    if LeftStr(avalue,1) = '0' then AValue := Copy(aValue,2,Length(aValue));
    limitValue := FloatToStr(ExtractFloat(aValue));
    limitUnit  := Copy(aValue,length(limitValue)+1,Length(aValue));
    if limitUnit = 'D' then limitUnit := 'days'
    else if limitUnit = 'H' then limitUnit := 'hours'
    else if limitUnit = 'ML' then limitUnit := 'ml';
  end;
  if ( Length(limitUnit)> 0)  and ( (Length(limitValue) > 0 ) ) then
  begin
    txtXDuration.Text := limitValue;
    if Trim(UpperCase(limitUnit))='CC' then
      limitUnit := 'ml';
    cboduration.text := limitUnit;
    if cboDuration.Text <> '' then cboDuration.ItemIndex := cboDuration.Items.IndexOf(cboDuration.Text)
  end;

end;

procedure TfrmODMedIV.SetSchedule(const x: string);
var
NonPRNPart,tempSch: string;
idx: integer;
begin
    cboSchedule.ItemIndex := -1;
    chkPRN.Checked := False;
    //Check to see if schedule is already define in the schedule list
    idx := cboSchedule.Items.IndexOf(X);
    if idx > -1 then
      begin
        cboSchedule.ItemIndex := idx;
        exit;
      end;
    //if PRN schedule than set the checkbox than exit
    if (X = ' PRN') or (X = 'PRN') then
      begin
        chkPRN.Checked := True;
        Exit;
      end;
      //Check to see if schedule is a Day-of-Week Schedule (MO-WE-FR@BID)
      if (Pos('@', x) > 0) then
        begin
          tempSch := Piece(x, '@', 2);
          idx := cboSchedule.Items.IndexOf(tempSch);
          if idx > -1 then
            begin
             //tempSch := U + Piece(x, '@', 1) + '@' + Pieces(cboSchedule.Items.Strings[idx], U, 2, 5);
             tempSch := Piece(x, '@', 1) + '@' + cboSchedule.Items.Strings[idx];
             cboSchedule.Items.Add(tempSch);
             cboSchedule.Text := (Piece(tempSch,U,1));
             cboSchedule.ItemIndex := cboSchedule.Items.IndexOf(Piece(tempSch,U,1));
             EXIT;
            end;
          //Check to see if schedule is a Day-of-Week PRN Schedule (MO-WE-FR@BID PRN)
          if Pos('PRN', tempSch) > 0 then
            begin
              NonPRNPart := Trim(Copy(tempSch, 1, Pos('PRN', tempSch) - 1));
              idx := cboSchedule.Items.IndexOf(NonPRNPart);
              if idx > -1 then
                begin
                  //tempSch := U + Piece(x, '@', 1) + '@' + Pieces(cboSchedule.Items.Strings[idx], U, 2, 5);
                  tempSch := Piece(x, '@', 1) + '@' + cboSchedule.Items.Strings[idx];
                  cboSchedule.Text := (Piece(tempSch,U,1));
                  cboSchedule.ItemIndex := cboSchedule.Items.IndexOf(Piece(tempSch, U, 1));
                  chkPRN.Checked := True;
                  EXIT;
                end
              else
               //Add Day-of-Week PRN schedule built off Time Prompt (MO-WE-FR@0800-1000 PRN)
               begin
                  NonPRNPart := Trim(Copy(X, 1, Pos('PRN', X) - 1));
                  chkPRN.Checked := True;
                  //cboSchedule.Items.Add(U + NonPRNPart + U + U + U + AdminTime);
                  //cboSchedule.Items.Add(U + NonPRNPart + U + U + U + Piece(NonPRNPart, '@', 2));
                  cboSchedule.Items.Add(NonPRNPart + U + U + U + Piece(NonPRNPart, '@', 2));
                  cboSchedule.Text := NonPRNPart;
                  cboSchedule.ItemIndex := cboSchedule.Items.IndexOf(NonPRNPart);
                  EXIT;
               end;
            end;
         //Add Non PRN Day-of-Week Schedule built off Time Prompt (MO-WE-FR@0800-1000)
         //cboSchedule.Items.Add(U + x + U + U + U + AdminTime);
         //cboSchedule.Items.Add(U + x + U + U + U + tempSch);
         cboSchedule.Items.Add(x + U + U + U + tempSch);
         cboSchedule.Text := x;
         cboSchedule.ItemIndex := cboSchedule.Items.IndexOf(X);
        end
        else
          begin
            //Handle standard schedule mark as PRN (Q4H PRN)
            if Pos('PRN', X) > 0 then
              begin
                NonPRNPart := Trim(Copy(X, 1, Pos('PRN', X) - 1));
                idx := cboSchedule.Items.IndexOf(NonPRNPart);
                if idx > -1 then
                  begin
                    cboSchedule.ItemIndex := idx;
                    tempSch := cboSchedule.Items.Strings[idx];
                    //setPiece(tempSch,U,5,AdminTime);
                    cboSchedule.Items.Strings[idx] := tempSch;
                    chkPRN.Checked := True;
                    exit;
                  end;
              end;
          end;
end;


procedure TfrmODMedIV.txtXDurationExit(Sender: TObject);
var
  Code: double;
begin
  inherited;
  if (txtXDuration.Text <> '0') and (txtXDuration.Text <> '') then
  begin
    try
      code := StrToFloat(txtXDuration.Text);
    except
      code := 0;
    end;
    if code < 0.0001 then
    begin
      ShowMsg('Can not save order.' + #13#10 + 'Reason: Invalid Duration or Total Volume!');
      txtXDuration.Text := '';
      txtXDuration.SetFocus;
      Exit;
    end;
  end;
  try
    if (Length(txtXDuration.Text)>0) and (StrToFloat(txtXDuration.Text)<0) then
    begin
      ShowMsg('Can not save order.' + #13#10 + 'Reason: Invalid Duration or total volume!');
      txtXDuration.Text := '';
      txtXDuration.SetFocus;
      Exit;
    end;
  except
    txtXDuration.Text := '';
  end;
  ControlChange(Sender);
end;

function TfrmODMedIV.UpdateAddFreq(OI: integer): string;
begin
  if (self.cboType.ItemIndex = -1) or (MixedCase(self.cboType.Items.Strings[self.cboType.ItemIndex]) = 'Continuous') then
     Result := GetDefaultAddFreq(OI)
  else Result := '';
end;

procedure TfrmODMedIV.UpdateDuration(SchType: string);
begin
if SchType = 'O' then
   begin
     self.cboDuration.ItemIndex := -1;
     self.txtXDuration.Text := '';
     self.cboDuration.Enabled := false;
     self.txtXDuration.Enabled := false;
     self.lblLimit.Enabled := false;
   end
else
  begin
     self.cboDuration.Enabled := true;
     self.txtXDuration.Enabled := true;
     self.lblLimit.Enabled := true;
  end;
end;

procedure TfrmODMedIV.UpdateRoute;
var
AnIVComponent: TIVComponent;
i: integer;
OrderIds, TempIVRoute: TStringList;
//Default: boolean;
begin
  if self.grdSelected.RowCount > 0 then self.txtAllIVRoutes.Visible := True;
  TempIVRoute := TStringList.Create;
  for I := (self.cboRoute.Items.Count -1) downto 0 do
    begin
      if Piece(self.cboRoute.Items.Strings[i], U, 5) = '1' then
        TempIVRoute.Add(self.cboRoute.Items.Strings[i]);
        self.cboRoute.Items.Delete(i);
    end;
  if self.cboRoute.ItemIndex = -1 then self.cboRoute.Text := '';
  OrderIds := TStringList.Create;
  for i := 0 to self.grdSelected.RowCount -1  do
    begin
      AniVComponent := TIVComponent(self.grdSelected.Objects[0, i]);
      if AnIVComponent <> nil then  orderIds.Add(InttoStr(AniVComponent.IEN));
    end;
 if OrderIds.Count > 0 then
   begin
     //if (self.FInitialOrderID = True) and (self.grdSelected.RowCount = 1) then Default := True
     //else Default := False;
     LoadDosageFormIVRoutes(self.cboRoute.Items, OrderIds);
     //if default = True then
     //  begin
     for I := 0 to cboRoute.items.Count - 1 do
       begin
        if Piece(cboRoute.Items.Strings[i], U, 5) = 'D' then
          begin
           cboRoute.ItemIndex := i;
           break;
          end;
       end;
       //  self.FInitialOrderID := false;
       //end;
     OrderIds.Free;
   end;
 if TempIVRoute.Count > 0 then
   begin
     for I := 0 to tempIVRoute.Count - 1 do cboRoute.Items.Add(tempIVRoute.Strings[i]);
     TempIVRoute.Free;
   end;
 cboRoute.Items.Add(U + 'OTHER');
end;


procedure TfrmODMedIV.txtAllIVRoutesClick(Sender: TObject);
var
  i: integer;
  msg : String;
begin
  inherited;
  msg := 'You can also select "OTHER" from the Route list'
     + ' to select a Route from the Expanded Med Route List.'
     + #13#10 + 'Click OK to launch the Expanded Med Route List.';
  if ShowMsg(msg, smiInfo, smbOKCancel) = smrOk then
  begin
      for I := 0 to cboRoute.Items.Count - 1 do if cboRoute.Items.Strings[i] = U + 'OTHER' then break;
      cboRoute.ItemIndex := i;
      cboRouteClick(self);
      cboRouteChange(self.cboRoute);
  end;
end;

procedure TfrmODMedIV.txtNSSClick(Sender: TObject);
var
  i: integer;
  msg : String;
begin
  inherited;
  msg := 'You can also select ' + '"' + 'Other' + '"' + ' from the schedule list'
    + ' to create a day-of-week schedule.'
    + #13#10 + 'Click OK to launch schedule builder';
  if ShowMsg(msg, smiInfo, smbOKCancel) = smrOK then
  begin
      //cboSchedule.Items.Add(U + 'OTHER');
      for I := 0 to cboSchedule.Items.Count - 1 do if cboSchedule.Items.Strings[i] = 'OTHER' then break;
      cboSchedule.ItemIndex := i;
      //cboSchedule.SelectByID(U+'OTHER');
      cboScheduleClick(Self);
      cboScheduleChange(self.cboSchedule);
  end;
end;

procedure TfrmODMedIV.txtRateChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  ControlChange(Sender);
end;

procedure TfrmODMedIV.SetScrollBarHeight(FontSize: Integer);
begin

  txtXDuration.Constraints.MaxHeight := cboDuration.Height;
  txtXDuration.Height :=  cboDuration.Height;
  txtRate.Constraints.MaxHeight := cboInfusionTime.Height;
  txtRate.Height := cboInfusionTime.Height;

  //Add constriant for remove button
  cmdRemove.Constraints.MaxHeight := TextHeightByFont(cmdRemove.Font.Handle, 'Z') + 12;

  //Dynamic formheight
  MinFormHeight := pnlTopRightLbls.Height +
  (TextHeightByFont(grdSelected.Font.Handle, 'Z') * 6) + (cmdRemove.Height + 5)
  + (TextHeightByFont(lblComponent.Font.Handle, 'Z') + 4) +
  (TextHeightByFont(memComments.Font.Handle, 'Z') * 6) + pnlB1.Height;


  //formwidth based on fontsize

  case FontSize of
   8: MinFormWidth := 600;
   10: MinFormWidth := 600;
   12: MinFormWidth := 700;
   14: MinFormWidth := 800;
   18: MinFormWidth := 1000;
  end;


  Self.Realign;

end;

end.