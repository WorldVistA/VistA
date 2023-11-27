unit fODDiet;
{$O-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, ComCtrls, ExtCtrls, StdCtrls, Grids, ORCtrls, ORDtTm, ORFn, uConst,
  VA508AccessibilityManager, StrUtils, uInfoBoxWithBtnControls, ORExtensions,
  uOrders, rODDiet;

type
  TlbGrid508Manager = class(TVA508ComponentManager)
   private
    HeaderStr: String;
    function GetTextToSpeak(LB: TCaptionStringGrid): String;
    function ToBlankIfEmpty(aString : String) : String;
   public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
  end;

  TfrmODDiet = class(TfrmODBase)
    nbkDiet: TPageControl;
    pgeDiet: TTabSheet;
    lblDietAvail: TLabel;
    lblDietSelect: TLabel;
    lblComment: TLabel;
    lblStart: TLabel;
    lblDelivery: TLabel;
    cboDietAvail: TORComboBox;
    lstDietSelect: TORListBox;
    cmdRemove: TButton;
    txtDietComment: ORExtensions.TCaptionEdit;
    calDietStart: TORDateBox;
    cboDelivery: TORComboBox;
    pgeTubefeeding: TTabSheet;                                                        
    lblTFProductList: TLabel;
    lblTFComment: TLabel;                                                             
    lblTFStrength: TLabel;
    lblTFQuantity: TLabel;
    lblTFProduct: TLabel;
    cboProduct: TORComboBox;
    txtTFComment: ORExtensions.TCaptionEdit;
    grdSelected: TCaptionStringGrid;
    cmdTFRemove: TButton;
    pgeEarlyLate: TTabSheet;
    pgeIsolations: TTabSheet;
    pgeAdditional: TTabSheet;
    chkCancelTubefeeding: TCheckBox;
    txtQuantity: ORExtensions.TCaptionEdit;
    cboStrength: TCaptionComboBox;
    lblTFAmount: TLabel;
    grpMeal: TKeyClickRadioGroup;
    grpMealTime: TGroupBox;
    lblELStart: TLabel;
    calELStart: TORDateBox;
    lblELStop: TLabel;
    calELStop: TORDateBox;
    grpDoW: TGroupBox;
    chkMonday: TCheckBox;
    chkTuesday: TCheckBox;
    chkWednesday: TCheckBox;
    chkThursday: TCheckBox;
    chkFriday: TCheckBox;
    chkSaturday: TCheckBox;
    chkSunday: TCheckBox;
    chkBagged: TCheckBox;
    radET1: TRadioButton;
    radET2: TRadioButton;
    radET3: TRadioButton;
    radLT1: TRadioButton;
    radLT2: TRadioButton;
    radLT3: TRadioButton;
    lblNoTimes: TLabel;
    txtAOComment: ORExtensions.TCaptionEdit;
    lblAddlOrder: TLabel;
    lstIsolation: TORListBox;
    lblIsolation: TLabel;
    lblIPComment: TLabel;
    txtIPComment: ORExtensions.TCaptionEdit;
    lblIPCurrent: TLabel;
    txtIPCurrent: ORExtensions.TCaptionEdit;
    pgeOutPt: TTabSheet;
    grpOPMeal: TKeyClickRadioGroup;
    grpOPDoW: TGroupBox;
    chkOPMonday: TCheckBox;
    chkOPTuesday: TCheckBox;
    chkOPWednesday: TCheckBox;
    chkOPThursday: TCheckBox;
    chkOPFriday: TCheckBox;
    chkOPSaturday: TCheckBox;
    chkOPSunday: TCheckBox;
    lblOPStart: TLabel;
    calOPStart: TORDateBox;
    lblOPStop: TLabel;
    calOPStop: TORDateBox;
    lblOPDietAvail: TLabel;
    cboOPDietAvail: TORComboBox;
    lblOPComment: TLabel;
    txtOPDietComment: ORExtensions.TCaptionEdit;
    lblOPDelivery: TLabel;
    cboOPDelivery: TORComboBox;
    lblOPSelect: TLabel;
    lstOPDietSelect: TORListBox;
    cmdOPRemove: TButton;
    chkOPCancelTubefeeding: TCheckBox;
    calOPTFStart: TORDateBox;
    lblOPTFStart: TLabel;
    lblOPAOStart: TLabel;
    calOPAOStart: TORDateBox;
    cboOPAORecurringMeals: TORComboBox;
    cboOPTFRecurringMeals: TORComboBox;
    cboOPELRecurringMeals: TORComboBox;
    procedure nbkDietChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure nbkDietChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboDietAvailNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure cboDietAvailMouseClick(Sender: TObject);
    procedure cboDietAvailExit(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure DietChange(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure cboProductMouseClick(Sender: TObject);
    procedure cboProductExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure grdSelectedSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure txtQuantityChange(Sender: TObject);
    procedure txtQuantityExit(Sender: TObject);
    procedure cboStrengthChange(Sender: TObject);
    procedure cboStrengthExit(Sender: TObject);
    procedure TFChange(Sender: TObject);
    procedure cmdTFRemoveClick(Sender: TObject);
    procedure grdSelectedDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure cboStrengthKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboStrengthEnter(Sender: TObject);
    procedure txtQuantityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtQuantityEnter(Sender: TObject);
    procedure grpMealClick(Sender: TObject);
    procedure calELStartExit(Sender: TObject);
    procedure calELStopChange(Sender: TObject);
    procedure ELChange(Sender: TObject);
    procedure calELStartEnter(Sender: TObject);
    procedure calELStartChange(Sender: TObject);
    procedure IPChange(Sender: TObject);
    procedure AOChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboOPDietAvailMouseClick(Sender: TObject);
    procedure cboOPDietAvailExit(Sender: TObject);
    procedure calOPStartExit(Sender: TObject);
    procedure calOPStopChange(Sender: TObject);
    procedure calOPStartEnter(Sender: TObject);
    procedure calOPStartChange(Sender: TObject);
    procedure OPChange(Sender: TObject);
    procedure grpOPMealClick(Sender: TObject);
    procedure cmdOPRemoveClick(Sender: TObject);
    procedure cboOPDietAvailKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdSelectedMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblTFQuantityClick(Sender: TObject);
    procedure nbkDietDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure nbkDietMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure nbkDietMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTabInfo: TDietTabArray;
    FNextCol: Integer;
    FNextRow: Integer;
//    FChangeStop: Boolean;
    FIsolationID: string;
    FTabChanging: Boolean;
    FGiveMultiTabMessage: boolean;
    lbGrid508Manager : TlbGrid508Manager;
    doNotShowMess: boolean;
    FNextTabIdx: Integer;
    FExcludeTabs: TDietTabs;
    procedure DietCheckForNPO;
    procedure DietCheckForTF;
//    procedure DietCheckforTFWithNPO;
    function GetMealTime: string;
    function GetDaysOfWeek: string;
    function IsEarlyTray: Boolean;
    procedure ResetControlsDO;
    procedure ResetControlsTF;
    procedure ResetControlsEL;
    procedure ResetControlsIP;
    procedure ResetControlsAO;
    procedure SetEnableDOW(AllowUse: Boolean);
    procedure SetNextCell(ACol, ARow: Integer);
    procedure SetValuesFromResponsesDO;
    procedure SetValuesFromResponsesTF;
    procedure SetValuesFromResponsesEL;
    procedure SetValuesFromResponsesIP;
    procedure SetValuesFromResponsesAO;
    procedure TFMoveToNextCell;
    procedure TFClearGrid;
    procedure TFSetAmountForRow(ARow: Integer);
    function TFStrengthCode(const x: string): Integer;
   //  Outpatient meal additions
    function  FMDOW(AnFMDate: TFMDateTime): integer;
    function  FMDays(AStart, AEnd: TFMDateTime): string;
    function  GetOPDaysOfWeek: string;
    procedure SetEnableOPDOW(AllowUse: Boolean; OneTimeDay: integer; DaysToCheck: string = '');
    procedure ResetControlsOP;
    procedure SetValuesFromResponsesOP;
    function  GetOPMealWindow: string;
    procedure OPDietCheckForNPO;
    procedure OPDietCheckForTF;
    function  PatientHasRecurringMeals(var MealList: TStringList; MealType: string = ''): boolean;
    //procedure CheckForAutoDCOrders(EvtID: integer; CurrentText: string; var CancelText: string; Sender: TObject);
    procedure UMAfterDisplay(var Message: TMessage); message UM_MISC;
    function GetDietTab(idx: integer): TDietTab;
    function NoAccessMessage(Tab: TDietTab): string;
    procedure SwitchToAccessibleTab(AutoAcceptIfOnlyOne: Boolean);
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure setTabToDiet; override;
  end;

var
  frmODDiet: TfrmODDiet;
  uDialogName: string;
  uFHAUTH: boolean;
  uRecurringMealList: TStringList;
  FOldHintHidePause: integer;

implementation

{$R *.DFM}

uses uCore, rODBase, rCore, rOrders, fODDietLT, DateUtils, fODDietAccess,
  fOrders, uODBase, VA508AccessibilityRouter, fODAllergyCheck, VAUtils,
  uWriteAccess;


const
  TX_DIET_REG = 'A regular diet may not be combined with other diets.';
  TX_DIET_NPO = 'NPO may not be combined with other diets.';
  TX_DIET_LIM = 'A maximum of 5 diet modifications may be selected.';
  TX_DIET_DUP = 'This diet has already been selected.';
  TX_DIET_PRC = 'This diet conflicts with ';
  TC_DIET_ERR = 'Unable to Add Diet';
  TX_INPT_ONLY = 'This type of diet may be entered for inpatients only.';
  TC_INPT_ONLY = 'Ordering Restriction';
  TX_CANCEL_TF = 'Cancel the current tubefeeding order?' + CRLF + CRLF;
  TC_CANCEL_TF = 'Cancel Tubefeeding';
  TX_NO_DIET   = 'At least one diet must be selected.';
  TX_BAD_START = 'The effective date is not valid.';
  TX_BAD_STOP  = 'The expiration date is not valid.';
  TX_STOPSTART = 'The expiration date must be after the effective date.';
  TX_MINMAX = 'At least 1 product must be selected (maximum: 5).';
  TX_TFQTY  = 'A quantity must be entered for ';
  TX_TFAMT  = 'The quantity is invalid for ';
  TX_TF5000 = 'The total quantity ordered may not exceed 5000ml.';
  TX_BADEFF_DATE = 'Cannot be effective before now.';

  // CQ #15833 - Removed references of 'c' and 'cc', changed 100CC example to 100ML - JCS
  TX_HLPQTY = CRLF + 'Valid entries for quantity:' + CRLF + CRLF +
              'Units             K for Kcals;  M for ml;  O for oz.; PKG' + CRLF +
              'Frequency     DAILY  HOUR  QH  BID  TID  QID  Q2H  Q3H  Q4H  Q6H' + CRLF + CRLF +
              'Or   100 ml/HR X 16  for 16 hours' + CRLF + CRLF +
              'IF powder form product, Then' + CRLF +
              '          (# GRAMS or # Unit or PKG) / FREQUENCY' + CRLF + CRLF +
              'Examples:' + CRLF +
              '          20 GRAMS/Day' + CRLF +
              '          1 PKG/TID' + CRLF +
              '          6 Units/DAILY' + CRLF +
              '          1 Units/Q3H' + CRLF +
              '          50ml/TID' + CRLF +
              '          100 ML/HR' + CRLF + CRLF +
              'The Amount field is read only and calculated based on the Quantity';
  TX_ELMEAL      = 'A meal must be selected.';
  TX_ELTIME      = 'A meal time must be selected.';
  TX_ELNOSTART   = 'A valid start date must be entered.';
  TX_ELNOSTOP    = 'A valid end date must be entered.';
  TX_ELSTARTLT   = 'The start date may not be earlier than today.';
  TX_ELSTOPLT    = 'The end date may not be earlier than today.';
  TX_ELSTOPSTART = 'The end date may not be earlier than the start date.';
  TX_ELSTART30   = 'The start date may not be more than 30 days in the future.';
  TX_ELSTOP30    = 'The end date may not be more than 30 days in the future.';
  TX_ELDOW       = 'The days of the week must be selected for time ranges greater than 1 day.';
  TX_ELPAST      = 'The selected meal time has already passed.';
  TX_IPNONE      = 'An isolation type must be selected.';
  TX_AONONE      = 'Text for additional order has not been entered.';
  TX_ACCEPT      = 'Accept the following order?' + CRLF + CRLF;
  TX_CONTINUE    = 'Continue editing the following order?' + CRLF + CRLF;
  TX_DISCARD     = CRLF + CRLF + 'Answering NO will discard all changes.';
  TC_ACCEPT      = 'Unsaved Order';
  TX_EL_SAVE_ERR    = 'An error occurred while saving this late tray order.';
  TC_EL_SAVE_ERR    = 'Error Saving Late Tray Order';
   //  Outpatient meal additions
  TX_OPMEAL       = 'A meal must be selected.';
  TX_OPNOSTART    = 'A valid start date must be entered.';
  TX_OPNOSTOP     = 'A valid end date must be entered.';
  TX_OPSTARTLT    = 'The start date may not be earlier than today.';
  TX_OPSTOPLT     = 'The end date may not be earlier than today.';
  TX_OPSTOPSTART  = 'The end date may not be earlier than the start date.';
  TX_OPSTART_MAX1 = 'The start date may not be more than ';
  TX_OPSTART_MAX2 = ' days in the future.';
  TX_OPSTOP_MAX1  = 'The end date may not be more than ';
  TX_OPSTOP_MAX2  = ' days in the future.';
  TX_OPDOW        = 'The days of the week must be selected for time ranges greater than 1 day.';
  TX_OPPAST       = 'The selected meal time has already passed.';
  TX_OP_SAVE_ERR  = 'An error occurred while saving this outpatient meal order.';
  TC_OP_SAVE_ERR  = 'Error Saving Outpatient Meal Order';
  TX_OP_NO_DIET   = 'One and only one diet must be selected.';
  TX_OP_BAD_START = 'The effective date is not valid.';
  TX_OP_BAD_STOP  = 'The expiration date is not valid.';
  //TX_OP_DIET_REG  = 'A regular diet may not be combined with other diets.';
  //TX_OP_DIET_NPO  = 'NPO may not be combined with other diets.';
  //TX_OP_DIET_LIM  = 'A maximum of 1 diet may be selected.';
  //TX_OP_DIET_DUP  = 'This diet has already been selected.';
  //TX_OP_DIET_PRC  = 'This diet conflicts with ';
  TC_OP_DIET_ERR  = 'Unable to Add Diet';
  TX_OUTPT_ONLY   = 'This type of diet may be entered for outpatients only.';
  TC_OUTPT_ONLY   = 'Ordering Restriction';
  TX_NO_PARAMS    = 'Placing Early or Late tray orders is not allowed until the IRM diet package' + CRLF +
                    'coordinator enters times for E/L trays for this location.';
  TC_NO_PARAMS    = 'Unable to Order Early/Late Tray';
  TX_NOSTART   = 'A valid start date must be entered.';
  TC_NOSTART   = 'Start date required';
  TX_NOT_THIS_LOC = 'This location has not been configured to' + CRLF +
                    'allow ordering of meals for outpatients.' + CRLF + CRLF +
                    'Please contact your IRM diet package coordinator.';
  TC_NOT_THIS_LOC = 'Unable to order from this location';
  TX_NO_OUTPT_ORDERS = 'Diet orders may only be entered for inpatients.';
  TC_NO_OUTPT_ORDERS = 'Ordering Restriction';
  TX_NO_MEALS_DEFINED = 'No diet types have been defined to be orderable for outpatients.' + CRLF + CRLF +
                        'Please contact your IRM diet package coordinator.';
  TC_NO_MEALS_DEFINED = 'Unable to order outpatient meals';

  FMDayLetters: array[1..7] of string[1] = ('M', 'T', 'W', 'R', 'F', 'S', 'X');

type
  TTFProduct = class
  private
    IEN: Integer;
    Name: string;
  end;

var
  uDietParams: TDietParams;

procedure TfrmODDiet.FormCreate(Sender: TObject);
var
  ALocation: string;   //ptr to #44 hospital location

  procedure BuildTabInfo;

    procedure Build(Tab: TDietTab; Code: string; Sheet: TTabSheet);
    var
      i: integer;
      obj: TWriteAccess.TDGWriteAccess;

    begin
      FTabInfo[Tab].TabSheet := Sheet;
      Sheet.Tag := ord(Tab);
      with TWriteAccess.TDGWriteAccessDietetics do
      begin
        for i := 0 to CodeInfo.Count - 1 do
        begin
          if Code = CodeInfo[i].TabCode then
          begin
            obj := WriteAccessV.DGWriteAccess(CodeInfo[i].DisplayGroup);
            if obj is TWriteAccess.TDGWriteAccessDietetics then
            begin
              FTabInfo[Tab].Access := obj as TWriteAccess.TDGWriteAccessDietetics;
              Sheet.Enabled := FTabInfo[Tab].Access.WriteAccess;
            end;
            break;
          end;
        end;
      end;
    end;

  begin
    Build(dtDiet, 'D', pgeDiet);
    Build(dtOutpatientMeals, 'M', pgeOutPt);
    Build(dtTubeFeeding, 'T', pgeTubefeeding);
    Build(dtEarlyLateTray, 'E', pgeEarlyLate);
    Build(dtIsolationsPrecautions, 'P', pgeIsolations);
    Build(dtAdditionalOrder, 'A', pgeAdditional);
  end;

begin
  inherited;
  BuildTabInfo;
  FNextTabIdx := -1;
  AutoSizeDisabled := false;
  FOldHintHidePause := Application.HintHidePause;
  FGiveMultiTabMessage := ScreenReaderSystemActive;
  AbortOrder := False;
  uRecurringMealList := TStringList.Create;
  if OrderForInpatient then
    begin
      pgeDiet.TabVisible := True;
      pgeOutPt.TabVisible := False;
    end
  else if OutpatientPatchInstalled then        // put here to only call RPCs if outpatient - remove "IF" later
    begin
      pgeDiet.TabVisible := False;
      pgeOutPt.TabVisible := True;
    end
  else                                         // this block will go away after FH patch installed everywhere
    begin
      InfoBox(TX_NO_OUTPT_ORDERS, TC_NO_OUTPT_ORDERS, MB_OK);
      AbortOrder := True;
      Exit;
    end;

  FillerID := 'FH';                     // does 'on Display' order check **KCM**
  ALocation := '0';
  if Self.EvtID > 0 then
    ALocation := GetEventLoc1(IntToStr(Self.EvtID));
  if StrToIntDef(ALocation, 0) < 1 then
    ALocation := IntToStr(Encounter.Location);
  if (not OrderForInpatient) and OutpatientPatchInstalled and (not OutpatientLocationConfigured(ALocation)) then
    begin
      InfoBox(TX_NOT_THIS_LOC, TC_NOT_THIS_LOC, MB_OK or MB_ICONINFORMATION);
      AbortOrder := True;
    end
  else
    begin
      LoadDietParams(uDietParams, ALocation);
      if pgeOutPt.TabVisible then
        with uDietParams, cboOPDelivery do
        begin
          if Tray      then Items.Add('T^Tray');
          if Cafeteria then Items.Add('C^Cafeteria');
          if DiningRm  then Items.Add('D^Dining Room');
          ItemIndex := 0;
          chkBagged.Visible := uDietParams.Bagged;
        end
      else
        with uDietParams, cboDelivery do
        begin
          if Tray      then Items.Add('T^Tray');
          if Cafeteria then Items.Add('C^Cafeteria');
          if DiningRm  then Items.Add('D^Dining Room');
          ItemIndex := 0;
          chkBagged.Visible := uDietParams.Bagged;
        end;
    end;

  lbGrid508Manager := TlbGrid508Manager.Create;
  amgrMain.ComponentManager[grdSelected] := lbGrid508Manager;

   lbGrid508Manager.HeaderStr := lblTFProduct.Caption +'^'
   + lblTFStrength.Caption +'^'
   + lblTFQuantity.Caption +'^'
   + lblTFAmount.Caption;
end;

procedure TfrmODDiet.FormDestroy(Sender: TObject);
begin
  TFClearGrid;
  uRecurringMealList.Free;
  Application.HintHidePause := FOldHintHidePause;
  inherited;
end;

procedure TfrmODDiet.FormResize(Sender: TObject);
begin
  inherited;
  with grdSelected do
  begin
    ColWidths[1] := Canvas.TextWidth('XFULLX') + GetSystemMetrics(SM_CXVSCROLL);
    ColWidths[2] := Canvas.TextWidth('100 GRAMS/HOUR X 24');
    ColWidths[3] := Canvas.TextWidth('55000ml');
    ColWidths[0] := ClientWidth - ColWidths[1] - ColWidths[2] - ColWidths[3] - 3;
    lblTFStrength.Left := Left + ColWidths[0] + 3;
    lblTFQuantity.Left := Left + ColWidths[0] + ColWidths[1] + 5;
    lblTFAmount.Left   := Left + ColWidths[0] + ColWidths[1] + ColWidths[2] + 7;
  end;
end;

procedure TfrmODDiet.FormShow(Sender: TObject);
begin
  inherited;
  PostMessage(Self.Handle, UM_MISC, 0, 0);
end;

procedure TfrmODDiet.InitDialog;
begin
  inherited;
  // handle all initialization at the tab level
  // if FTabChanging, then nbkDietChange is about to be called anyway
  if (not doNotSHowMess) then doNotShowMess := false;

  if not FTabChanging then nbkDietChange(Self);
end;

procedure TfrmODDiet.SetupDialog(OrderAction: Integer; const ID: string);
begin
  if AbortOrder then exit;
  inherited;
  uDialogName := ExternalName(DialogIEN, 101.41);
  case DietDialogType(DisplayGroup) of
  'D': begin
         if not OrderForInpatient then
           begin
             InfoBox(TX_INPT_ONLY, TC_INPT_ONLY, MB_OK);
             Close;
             Exit;
           end;
         pgeDiet.TabVisible := True;
         pgeOutPt.TabVisible := False;
         nbkDiet.ActivePage := pgeDiet;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesDO;
       end;
  'N': begin
         if not OrderForInpatient then
           begin
             InfoBox(TX_INPT_ONLY, TC_INPT_ONLY, MB_OK);
             Close;
             Exit;
           end;
         nbkDiet.ActivePage := pgeDiet;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesDO;
       end;
  'T': begin
         if (not OrderForInpatient) and (not PatientHasRecurringMeals(uRecurringMealList)) then
         begin
           Close;
           Exit;
         end;
         nbkDiet.ActivePage := pgeTubefeeding;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesTF;
       end;
  'E': begin
         if (not OrderForInpatient) and (not PatientHasRecurringMeals(uRecurringMealList)) then
         begin
           Close;
           Exit;
         end;
         nbkDiet.ActivePage := pgeEarlyLate;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesEL;
       end;
  'P': begin
         nbkDiet.ActivePage := pgeIsolations;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesIP;
       end;
  'A': begin
         if (not OrderForInpatient) and (not PatientHasRecurringMeals(uRecurringMealList)) then
         begin
           Close;
           Exit;
         end;
         nbkDiet.ActivePage := pgeAdditional;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesAO;
       end;
  'M': begin
         if OrderForInpatient then
           begin
             InfoBox(TX_OUTPT_ONLY, TC_OUTPT_ONLY, MB_OK);
             Close;
             Exit;
           end;
         uFHAUTH := UserHasFHAUTHKey;       // is this really needed for other than printing?
         pgeDiet.TabVisible := False;
         pgeOutPt.TabVisible := True;
         nbkDiet.ActivePage := pgeOutPt;
         nbkDietChange(Self);
         if (not AbortOrder) and (OrderAction <> ORDER_NEW) then SetValuesFromResponsesOP;
       end
  else
      begin
        if not OrderForInpatient then
         begin
           InfoBox(TX_INPT_ONLY, TC_INPT_ONLY, MB_OK);
           Close;
           Exit;
         end;
        pgeDiet.TabVisible := True;
        pgeOutPt.TabVisible := False;
        nbkDiet.ActivePage := pgeDiet;
        nbkDietChange(Self);
        if not AbortOrder then
        begin
          if OrderAction <> ORDER_NEW then SetValuesFromResponsesDO;
          ActiveControl := cboOPDietAvail;
        end;
      end;
  end;
  if (not AbortOrder) and (OrderAction = ORDER_NEW) then SetFocusedControl(nbkDiet);
end;

procedure TfrmODDiet.Validate(var AnErrMsg: string);
var
  ErrMsg: string;
  i, Sum: Integer;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

  function MealTimePassed: Boolean;
  var
    x: string;
    ATime: Integer;
  begin
    Result := False;
    if calELStart.FMDateTime <> FMToday then Exit;
    x := GetMealTime;
    if Pos(':', x) = 0 then Exit;
    ATime := StrToIntDef(Piece(x, ':', 1) + Copy(Piece(x, ':', 2), 1, 2), 0);
    if (Pos('P', x) > 0) and (ATime < 1200) then ATime := ATime + 1200;
    if (Pos('A', x) > 0) and (ATime > 1200) then ATime := ATime - 1200;
    if (ATime / 10000) < Frac(FMNow) then Result := True;
  end;

  function OPMealTimePassed: Boolean;
  var
    WindowTimes: string;
    EndWindow: integer;
    x: extended;
  begin
    Result := False;
    if calOPStart.FMDateTime <> FMToday then Exit;
    WindowTimes := GetOPMealWindow;
    if WindowTimes = U then exit;
    EndWindow := StrToIntDef(Piece(WindowTimes, U, 2), 0);
    x := Frac(calOPStart.FMDateTime);
    if x = 0 then x := Frac(FMNow) * 10000;
    if x > EndWindow then Result := True;
  end;

begin
  // do the appropriate validation depending on the currently selected tab
  if nbkDiet.ActivePage = pgeDiet then
  begin
    if lstDietSelect.Items.Count < 1 then SetError(TX_NO_DIET);
    if not calDietStart.IsValid      then SetError(TX_BAD_START);
    if calDietStart.FMDateTime < FMNow then SetError(TX_BADEFF_DATE);
//    with calDietStop do
//    begin
//      Validate(ErrMsg);
//      if Length(ErrMsg) > 0          then SetError(TX_BAD_STOP);
//      if (Length(Text) > 0) and (FMDateTime <= calDietStart.FMDateTime)
//                                     then SetError(TX_STOPSTART);
//    end; {with calDietStop}
  end; {pgeDiet}
  if nbkDiet.ActivePage = pgeTubeFeeding then
  begin
    Sum := 0;
    with grdSelected do for i := 0 to RowCount - 1 do if Objects[0, i] <> nil then Inc(Sum);
    if (Sum < 1) or (Sum > 5) then SetError(TX_MINMAX);
    Sum := 0;
    with grdSelected do for i := 0 to RowCount - 1 do if Objects[0, i] <> nil then
    begin
      if  Length(Cells[2, i]) = 0  then SetError(TX_TFQTY + Cells[0, i]);
      if (Length(Cells[2, i]) > 0) and (Length(Cells[3, i]) = 0)
        then SetError(TX_TFAMT + Cells[0, i] + TX_HLPQTY);
      Sum := Sum + StrToIntDef(Piece(Cells[3, i], 'c', 1), 0);
      //CQ 21583 - Addressing numerous PSI 1187 issues - JCS
      Sum := Sum + StrToIntDef(LeftStr(Cells[3, i], Pos('ml', Cells[3, i]) - 1), 0);
    end;
    if Sum > 5000 then SetError(TX_TF5000);
    if not OrderForInpatient then
      if not calOPTFStart.IsValid      then SetError(TX_BAD_START);
  end;
  if nbkDiet.ActivePage = pgeEarlyLate then
  begin
    if grpMeal.ItemIndex = 3                                   then SetError(TX_ELMEAL);
    if not calELStart.IsValid                                  then SetError(TX_ELNOSTART);
    if calELStart.FMDateTime < FMToday                         then SetError(TX_ELSTARTLT);
    if calELStart.FMDateTime > FMDateTimeOffsetBy(FMToday, 30) then SetError(TX_ELSTART30);
    if OrderForInpatient then
    begin
      if GetMealTime = ''                                        then SetError(TX_ELTIME);
      if not calELStop.IsValid                                   then SetError(TX_ELNOSTOP);
      if calELStop.FMDateTime < FMToday                          then SetError(TX_ELSTOPLT);
      if calELStop.FMDateTime < calELStart.FMDateTime            then SetError(TX_ELSTOPSTART);
      if calELStop.FMDateTime > FMDateTimeOffsetBy(FMToday, 30)  then SetError(TX_ELSTOP30);
    end;
    if grpDOW.Enabled and (GetDaysOfWeek = '')                 then SetError(TX_ELDOW);
    if MealTimePassed                                          then SetError(TX_ELPAST);
  end;
  if nbkDiet.ActivePage = pgeIsolations then
  begin
    if lstIsolation.ItemIndex < 0                              then SetError(TX_IPNONE);
  end;
  if nbkDiet.ActivePage = pgeAdditional then
  begin
    if not ContainsVisibleChar(txtAOComment.Text)              then SetError(TX_AONONE);
    if not OrderForInpatient then
      if not calOPAOStart.IsValid                              then SetError(TX_BAD_START);
  end;
  if nbkDiet.ActivePage = pgeOutPt then
  begin
    if grpOPMeal.ItemIndex = 3           then SetError(TX_OPMEAL);
    if lstOPDietSelect.Items.Count < 1   then SetError(TX_OP_NO_DIET);
    if OPMealTimePassed                  then SetError(TX_OPPAST);
    if uDialogName = 'FHW OP MEAL' then
    begin
      if not calOPStart.IsValid          then SetError(TX_OP_BAD_START);
      with calOPStop do
      begin
        if not IsValid          then SetError(TX_OP_BAD_STOP);
        Validate(ErrMsg);
        if Length(ErrMsg) > 0            then SetError(TX_OP_BAD_STOP);
        if (Length(Text) > 0) and (FMDateTime < calOPStart.FMDateTime)
                                         then SetError(TX_OPSTOPSTART);
      end; {with calOPDietStop}
      if calOPStart.FMDateTime > FMDateTimeOffsetBy(FMToday, uDietParams.OPMaxDays)
                                         then SetError(TX_OPSTART_MAX1 + IntToStr(uDietParams.OPMaxDays) +
                                         TX_OPSTART_MAX2);
      if calOPStop.FMDateTime > FMDateTimeOffsetBy(FMToday, uDietParams.OPMaxDays)
                                         then SetError(TX_OPSTOP_MAX1 + IntToStr(uDietParams.OPMaxDays) +
                                         TX_OPSTOP_MAX2);
      if grpOPDOW.Enabled and (GetOPDaysOfWeek = '')
                                         then SetError(TX_OPDOW);
    end;
  end;
end;

{ notebook tabs - general ------------------------------------------------------------------- }

procedure TfrmODDiet.nbkDietChanging(Sender: TObject; var AllowChange: Boolean);
var
  Tab: TDietTab;

begin
  inherited;
  with Responses do if (Length(CopyOrder) > 0) or (Length(EditOrder) > 0) then
  begin
    AllowChange := False;
    Exit;
  end;
  if FNextTabIdx >= 0 then
  begin
    Tab := GetDietTab(FNextTabIdx);
    if (Tab <> dtNone) and (not FTabInfo[Tab].Access.WriteAccess) then
    begin
      ShowMessage(NoAccessMessage(Tab));
      AllowChange := False;
      Exit;
    end;
  end;
  if not FTabInfo[TDietTab(nbkDiet.ActivePage.Tag)].Access.WriteAccess then
    Exit;
  FTabChanging := True;
  if Length(memOrder.Text) > 0 then
    begin
      if nbkDiet.ActivePage = pgeOutpt then
        begin
          if InfoBox(TX_CONTINUE + memOrder.Text + TX_DISCARD, TC_ACCEPT, MB_YESNO) = ID_YES then
            begin
              AllowChange := FALSE;
            end else
            begin
              memOrder.Text := '';
              memOrder.Lines.Clear;
              Responses.Clear;
            end;
        end
      else
        begin
          if InfoBox(TX_ACCEPT + memOrder.Text, TC_ACCEPT, MB_YESNO) = ID_YES then
            begin
              cmdAcceptClick(Self);
              AllowChange := AcceptOK;
            end else
            begin
              memOrder.Text := '';
              memOrder.Lines.Clear;
              Responses.Clear;
            end;
        end
    end;
  FTabChanging := False;
end;

procedure TfrmODDiet.nbkDietDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  Text: string;
  r: TRect;
  Tab: TDietTab;

begin
  Tab := GetDietTab(TabIndex);
  if Tab = dtNone then
    Exit;
  Text := FTabInfo[Tab].TabSheet.Caption;
  if Active then
    Control.Canvas.Brush.Color := clWindow
  else
    Control.Canvas.Brush.Color := clBtnFace;
  Control.Canvas.FillRect(Rect);
  if not FTabInfo[Tab].Access.WriteAccess then
  begin
    Control.Canvas.Font.Color := clBlue;
    Control.Canvas.Font.Style := [fsUnderline];
  end;
  r := Rect;
  Control.Canvas.TextRect(r, Text, [tfCenter, tfSingleLine, tfVerticalCenter]);
end;

procedure TfrmODDiet.nbkDietMouseLeave(Sender: TObject);
begin
  inherited;
  FNextTabIdx := -1;
end;

procedure TfrmODDiet.nbkDietMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FNextTabIdx := nbkDiet.IndexOfTabAt(X, Y);
end;

(*procedure TfrmODDiet.CheckForAutoDCOrders(EvtID: integer; CurrentText: string; var CancelText: string; Sender: TObject);
const
  TX_CX_CUR = 'A new diet order will CANCEL and REPLACE this current diet now unless' + CRLF +
              'you specify a start date for when the new diet should replace the current' + CRLF +
              'diet:' + CRLF + CRLF;
  TX_CX_FUT = 'A new diet order with no expiration date will CANCEL and REPLACE these diets:' + CRLF + CRLF;
  TX_CX_DELAYED1 =  'There are other delayed diet orders for this release event:';
  TX_CX_DELAYED2 =  'This new diet order may cancel and replace those other diets' + CRLF +
                    'IMMEDIATELY ON RELEASE, unless you either:' + CRLF + CRLF +

                    '1. Specify an expiration date/time for this order that will' + CRLF +
                    '   be prior to the start date/time of those other orders; or' + CRLF + CRLF +

                    '2. Specify a later start date/time for this order for when you' + CRLF +
                    '   would like it to cancel and replace those other orders.';

var
  i: integer;
  AStringList: TStringList;
  AList: TList;
  x, PtEvtIFN, PtEvtName: string;
  //AResponse: TResponse;
begin
  if Self.EvtID = 0 then   // check current and future released diets
  begin
    x := CurrentText;
    if Piece(x, #13, 1) <> 'Current Diet:  ' then
    begin
      AStringList := TStringList.Create;
      try
        AStringList.Text := x;
        CancelText := TX_CX_CUR + #9 + Piece(AStringList[0], ':', 1) + ':' + CRLF + CRLF
                 + #9 + Copy(AStringList[0], 16, 99) + CRLF;
        if AStringList.Count > 1 then
        begin
          CancelText := CancelText + CRLF + CRLF +
                   TX_CX_FUT + #9 + Piece(AStringList[1], ':', 1) + ':' + CRLF + CRLF
                   + #9 + Copy(AStringList[1], 22, 99) + CRLF;
          if AStringList.Count > 2 then
          for i := 2 to AStringList.Count - 1 do
            CancelText := CancelText + #9 + TrimLeft(AStringList[i]) + CRLF;
        end;
      finally
        AStringList.Free;
      end;
    end;
  end
  else if Sender is TButton then     // delayed orders code here - on accept only
  begin
    //AResponse := Responses.FindResponseByName('STOP', 1);
    //if (AResponse <> nil) and (AResponse.EValue <> '') then exit;
    AList := TList.Create;
    try
      PtEvtIFN := IntToStr(frmOrders.TheCurrentView.EventDelay.PtEventIFN);
      PtEvtName := frmOrders.TheCurrentView.EventDelay.EventName;
      LoadOrdersAbbr(AList, frmOrders.TheCurrentView, PtEvtIFN);
      for i := AList.Count - 1 downto 0 do
      begin
        if TOrder(Alist.Items[i]).DGroup <> Self.DisplayGroup then
        begin
          TOrder(AList.Items[i]).Free;
          AList.Delete(i);
        end;
      end;
      if AList.Count > 0 then
      begin
        x := '';
        RetrieveOrderFields(AList, 0, 0);
        CancelText := TX_CX_DELAYED1 + CRLF + CRLF + 'Release event: ' + PtEvtName;
        for i := 0 to AList.Count - 1 do
          with TOrder(AList.Items[i]) do
          begin
            x := x + #9 + Text + CRLF;
(*            if StartTime <> '' then
              x := #9 + x + 'Start:   ' + StartTime + CRLF
            else
              x := #9 + x + 'Ordered: ' + FormatFMDateTime('mmm dd,yyyy@hh:nn', OrderTime) + CRLF;*)
(*          end;
        CancelText := CancelText + CRLF + CRLF + x;
        CancelText := CancelText + CRLF + CRLF + TX_CX_DELAYED2;
      end;
    finally
      with AList do for i := 0 to Count - 1 do TOrder(Items[i]).Free;
      AList.Free;
    end;
  end;
end;*)

procedure TfrmODDiet.nbkDietChange(Sender: TObject);
var
  x: string ;
  CxMsg, DLMsg: string;
  aLst: TStringList;
begin
  inherited;
  // much of the logic here can be eliminated if ClearDialogControls starts clearing containers
  if AbortOrder then
  begin
    cmdQuitClick(Self);
    exit;
  end;
  if (csLoading in ComponentState) then
    Exit;
  if Assigned(nbkDiet.ActivePage) and
    (not FTabInfo[TDietTab(nbkDiet.ActivePage.Tag)].Access.WriteAccess) then
  begin
    FExcludeTabs := FExcludeTabs + [TDietTab(nbkDiet.ActivePage.Tag)];
    if Visible then
      SwitchToAccessibleTab(True);
    Exit;
  end;
  StatusText('Loading Dialog Definition');
  if Sender <> Self then Responses.Clear;
  Changing := True;                                        // Changing set!
  if (nbkDiet.ActivePage = pgeDiet) then
  begin
    AllowQuickOrder := True;
    x := CurrentDietText;
    if (doNotShowMess = false) then
      begin
        CheckForAutoDCDietOrders(Self.EvtID, Self.DisplayGroup, x, CxMsg, nbkDiet);
        If Self.EvtID = 0 then CheckForDelayedDietOrders(DLMsg, frmOrders.TheCurrentView, Self.DisplayGroup);
        if CxMsg <> '' then
          begin
            if InfoBox(CxMsg + DLMsg + CRLF +
                'Are you sure?', 'Confirm', MB_ICONWARNING or MB_YESNO) = ID_NO then
            begin
              AbortOrder := True;
              cmdQuitClick(Self);
              exit;
            end;
          end;
      end;
    doNotShowMess := false;
    OrderMessage(x);
    Responses.Dialog := 'FHW1';                            // Diet Order
    DisplayGroup := DisplayGroupForDialog('FHW1');
    LoadDietQuickList(cboDietAvail.Items, 'DO');
    cboDietAvail.InsertSeparator;
    cboDietAvail.InitLongList('');
    chkCancelTubefeeding.State := cbGrayed;
    chkCancelTubefeeding.Visible := False;
    ResetControlsDO;
  end;
  if nbkDiet.ActivePage = pgeTubefeeding then
  begin
    if not OrderForInpatient then
    begin
      if not PatientHasRecurringMeals(uRecurringMealList) then
        begin
          Changing := False;
          FExcludeTabs := FExcludeTabs + [TDietTab(nbkDiet.ActivePage.Tag)];
          nbkDiet.ActivePage := pgeOutPt;
          nbkDietChange(nbkDiet);
          Exit;
        end
        else
          FastAssign(uRecurringMealList, cboOPTFRecurringMeals.Items);
    end;
    cboOPTFRecurringMeals.Visible := not OrderForInpatient;
    calOPTFStart.Visible := False;
    lblOPTFStart.Visible := not OrderForInpatient;
    AllowQuickOrder := True;
    if Length(uDietParams.CurTF) > 0
      then OrderMessage(TextForOrder(uDietParams.CurTF))
      else OrderMessage('');
    Responses.Dialog := 'FHW8';                            // Tubefeeding
    DisplayGroup := DisplayGroupForDialog('FHW8');
    with cboProduct do if Items.Count = 0 then
    begin
      LoadDietQuickList(Items, 'TF');
      if Items.Count > 0 then
      begin
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
      AppendTFProducts(Items);
    end;
    cboProduct.Text := '';
    ResetControlsTF;
  end;
  if nbkDiet.ActivePage = pgeEarlyLate then
  begin
    if not OrderForInpatient then
      begin
        if not PatientHasRecurringMeals(uRecurringMealList) then
          begin
            Changing := False;
            FExcludeTabs := FExcludeTabs + [TDietTab(nbkDiet.ActivePage.Tag)];
            nbkDiet.ActivePage := pgeOutPt;
            nbkDietChange(nbkDiet);
            Exit;
          end
        else
          FastAssign(uRecurringMealList, cboOPELRecurringMeals.Items);
      end
    else if (StrToIntDef(uDietParams.EarlyIEN, 0) = 0) or (StrToIntDef(uDietParams.LateIEN, 0) = 0) then
      begin
        InfoBox(TX_NO_PARAMS, TC_NO_PARAMS, MB_ICONERROR or MB_OK);
        if pgeEarlyLate <> nil then
          nbkDiet.SelectNextPage(False);
        Changing := False;
        Exit;
      end;
    cboOPELRecurringMeals.Visible := not OrderForInpatient;
    cboOPELRecurringMeals.TabStop := not OrderForInpatient;
    calELStart.Visible := OrderForInpatient;
    calELStart.TabStop := OrderForInpatient;
    calELStop.Visible := OrderForInpatient;
    lblELStop.Visible := OrderForInpatient;
    grpDOW.Visible := OrderForInpatient;
    grpDOW.Enabled := OrderForInpatient;
    AllowQuickOrder := False;
    OrderMessage('');
    Responses.Dialog := 'FHW2';                            // Early/Late Tray
    DisplayGroup := DisplayGroupForDialog('FHW2');
    ResetControlsEL;
  end;
  if nbkDiet.ActivePage = pgeIsolations then
  begin
    AllowQuickOrder := False;
    OrderMessage('');
    Responses.Dialog := 'FHW3';                            // Isolations
    DisplayGroup := DisplayGroupForDialog('FHW3');
    if lstIsolation.Items.Count = 0 then LoadIsolations(lstIsolation.Items);
    txtIPCurrent.Text := CurrentIsolation;
    FIsolationID := IsolationID;
    ResetControlsIP;
  end;
  if nbkDiet.ActivePage = pgeAdditional then
  begin
  if not OrderForInpatient then
    begin
      if not PatientHasRecurringMeals(uRecurringMealList) then
        begin
          Changing := False;
          FExcludeTabs := FExcludeTabs + [TDietTab(nbkDiet.ActivePage.Tag)];
          nbkDiet.ActivePage := pgeOutPt;
          nbkDietChange(nbkDiet);
          Exit;
        end
      else
        FastAssign(uRecurringMealList, cboOPAORecurringMeals.Items);
    end;
    cboOPAORecurringMeals.Visible := not OrderForInpatient;
    calOPAOStart.Visible := False;  //not OrderForInpatient;
    lblOPAOStart.Visible := not OrderForInpatient;
    AllowQuickOrder := False;
    OrderMessage('');
    Responses.Dialog := 'FHW7';                            // Additional Order
    DisplayGroup := DisplayGroupForDialog('FHW7');
    ResetControlsAO;
  end;
  if nbkDiet.ActivePage = pgeOutPt then
  begin
    x := CurrentDietText;
    if Length(Piece(x, #$D, 1)) > Length('Current Diet:  ') then
      OrderMessage(x)
    else
      OrderMessage('');
    if (uDialogName <> 'FHW SPECIAL MEAL') and (uDialogName <> 'FHW OP MEAL') then
      uDialogName := 'FHW OP MEAL';
    Responses.Dialog := uDialogName;
    DisplayGroup := DisplayGroupForDialog(uDialogName);
    if uDialogName = 'FHW SPECIAL MEAL' then                 // Special meal
      begin
       AllowQuickOrder := False;
       ResetControlsOP;
       aLst := TStringList.Create;
       try
         SubSetOfOPDiets(aLst);
         FastAddStrings(aLst, cboOPDietAvail.Items);
        finally
          FreeAndNil(aLst);
       end;
       { TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
       chkOPCancelTubefeeding.State := cbGrayed;
       chkOPCancelTubefeeding.Visible := False;
       grpOPMeal.Caption := 'Special Meal';
       pgeTubefeeding.TabVisible := False;
       pgeIsolations.TabVisible := False;
       pgeAdditional.TabVisible := False;
       pgeEarlyLate.TabVisible := False;
       cboOPDietAvail.SelectByIEN(uDietParams.OPDefaultDiet);
       cboOPDietAvailMouseClick(Self);
       Changing := False;
      end
    else if uDialogName = 'FHW OP MEAL' then                          // Recurring meal
      begin
       AllowQuickOrder := True;
       ResetControlsOP;
       LoadDietQuickList(cboOPDietAvail.Items, 'MEAL');              // use D.G. short name here
       cboOPDietAvail.InsertSeparator;
       aLst := TStringList.Create;
       try
         SubSetOfOPDiets(aLst);
         FastAddStrings(aLst, cboOPDietAvail.Items);
       finally
         FreeAndNil(aLst);
       end;
       cboOPDietAvail.SelectByIEN(uDietParams.OPDefaultDiet);
       { TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
       chkOPCancelTubefeeding.State := cbGrayed;
       chkOPCancelTubefeeding.Visible := False;
       grpOPMeal.Caption := 'Recurring Meal';
       SetEnableOPDOW(False, -1);
       cboOPDietAvailMouseClick(Self);
       Changing := False;
      end;
  end;
  Changing := False;                                       // Changing reset
  StatusText('');
  if FGiveMultiTabMessage then  // CQ#15483
  begin
    FGiveMultiTabMessage := FALSE;
    GetScreenReader.Speak('Multi Tab Form');
  end;
end;

{ Diet Order tab ---------------------------------------------------------------------------- }

procedure TfrmODDiet.DietCheckForNPO;
begin
  if (lstDietSelect.Count > 0) and (Piece(lstDietSelect.Items[0], U, 2) = 'NPO') then
  begin
    lblDelivery.Visible := False;
    cboDelivery.Visible := False;
    lblComment.Visible := True;          // <-- these changes added for 11a to suppress
    txtDietComment.Visible := True;      // <-- prompting of special instructions except
  end else                               // <-- for NPO
  begin                                  // <--
    lblComment.Visible := False;         // <--
    txtDietComment.Visible := False;     // <--
    txtDietComment.Text := '';           // <--
  end;
end;

procedure TfrmODDiet.DietCheckForTF;
var
  x: string;
  list: TStringList;
  value: integer;
begin
  with lstDietSelect do
  begin
    if (Items.Count > 0) and (Length(uDietParams.CurTF) > 0) then
    begin
      x := TextForOrder(uDietParams.CurTF);
      list := TStringList.Create;
      list.Add('Continue TubeFeeding Order^false');
      list.Add('Cancel TubeFeeding Order^false');
      value := uInfoBoxWithBtnControls.DefMessageDlg(TX_CANCEL_TF + x, mtConfirmation, list, TC_CANCEL_TF, true);
      if value = 1 then
      begin
        chkCancelTubeFeeding.State := cbChecked;
        chkCancelTubeFeeding.Visible := True;
      end
      else if value = 0 then chkCancelTubeFeeding.State := cbUnchecked;
    end; {if (Items...}
  end; {with lstDietSelect}
end;

//procedure TfrmODDiet.DietCheckforTFWithNPO;
//var
//  i: integer;
//  resolved: boolean;
//  x: string;
//begin
//  resolved := false;
//  for i := 0 to lstDietSelect.items.count -1 do
//    begin
//       if (Piece(lstDietSelect.Items[i], U, 2) = 'NPO')
//        and (Length(uDietParams.CurTF) > 0) then
//        begin
//          x := TextForOrder(uDietParams.CurTF);
//          if InfoBox(TX_CANCEL_TF + x, TC_CANCEL_TF, MB_YESNO) = IDYES then
//            begin
//              chkCancelTubeFeeding.State := cbChecked;
//              chkCancelTubeFeeding.Visible := True;
//            end
//          else chkCancelTubeFeeding.State := cbUnchecked;
//          Exit;
//        end;
//    end;
//end;

procedure TfrmODDiet.ResetControlsDO;
begin
  lstDietSelect.Clear;
  calDietStart.Text := 'Now';
//  calDietStop.Text  := '';
  lblDelivery.Visible := True;
  cboDelivery.Visible := True;
  txtDietComment.Text := '';             // <-- suppress except for NPO
  txtDietComment.Visible := False;       // <--
  lblComment.Visible := False;           // <--
end;

procedure TfrmODDiet.SetValuesFromResponsesDO;
var
  AnInstance: Integer;
  AResponse: TResponse;
  ADiet: string;
begin
  Changing := True;                                        // Changing set!!
  ResetControlsDO;
  with Responses do
  begin
    AnInstance := NextInstance('ORDERABLE', 0);
    while AnInstance > 0 do
    begin
      AResponse := FindResponseByName('ORDERABLE', AnInstance);
      if AResponse <> nil then
      begin
        ADiet := DietAttributes(StrToIntDef(AResponse.IValue,0));
        if Piece(ADiet,'^',1)='0' then
        begin
          InfoBox(Piece(ADiet,'^',2), TC_DIET_ERR, MB_OK);
          cboDietAvail.ItemIndex := -1;
          Changing := False;
          Exit;
        end;
        lstDietSelect.Items.Add(ADiet);
      end;
      AnInstance := NextInstance('ORDERABLE', AnInstance);
    end; {while AnInstance - ORDERABLE}
    SetControl(calDietStart,   'START',    1);
//    SetControl(calDietStop,    'STOP',     1);
    SetControl(cboDelivery,    'DELIVERY', 1);
    SetControl(txtDietComment, 'COMMENT',  1);
  end;
  DietCheckForNPO;
  DietCheckForTF;
//  DietCheckForTFWithNPO;
  Changing := False;                                       // Changing reset
  DietChange(Self);
end;

procedure TfrmODDiet.cboDietAvailNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
var
  aLst: TStringList;
begin
  inherited;
  aLst := TStringList.Create;
  try
    SubSetOfDiets(aLst, StartFrom, Direction);
    cboDietAvail.ForDataUse(aLst);
  finally
    FreeAndNil(aLst);
  end;
end;

procedure TfrmODDiet.cboDietAvailMouseClick(Sender: TObject);
var
  NewDiet, ErrMsg: string;
  DupDiet: Boolean;
  i: Integer;

  procedure SetError(const AnError: string);
  begin
    if Length(ErrMsg) > 0 then Exit;
    ErrMsg := AnError;
  end;

begin
  inherited;
  if CharAt(cboDietAvail.ItemID, 1) = 'Q' then              // setup quick order
  begin
    Responses.QuickOrder := ExtractInteger(cboDietAvail.ItemID);
    SetValuesFromResponsesDO;
    cboDietAvail.ItemIndex := -1;
//    DietCheckForTF;
//    DietCheckforTFWithNPO;
    Exit;
  end;
  if cboDietAvail.ItemIEN > 0 then with lstDietSelect do
  begin
    ErrMsg := '';
    if Items.Count > 0 then  // disallow other diets with Regular & NPO
    begin
      if cboDietAvail.ItemIEN = uDietParams.RegIEN then SetError(TX_DIET_REG);
      if GetIEN(0) = uDietParams.RegIEN            then SetError(TX_DIET_REG);
      if cboDietAvail.ItemIEN = uDietParams.NPOIEN then SetError(TX_DIET_NPO);
      if GetIEN(0) = uDietParams.NPOIEN            then SetError(TX_DIET_NPO);
    end;
    if Items.Count = 5 then SetError(TX_DIET_LIM);    // maximum of 5 diet modifications
    DupDiet := False;
    for i := 0 to Items.Count - 1 do if cboDietAvail.ItemIEN = GetIEN(i) then DupDiet := True;
    if DupDiet         then SetError(TX_DIET_DUP);    // each diet mod must be unique
    NewDiet := DietAttributes(cboDietAvail.ItemIEN);
    if Piece(NewDiet,'^',1)='0' then
    begin
      InfoBox(Piece(NewDiet,'^',2),TC_DIET_ERR, MB_OK);
      cboDietAvail.ItemIndex := -1;
      Exit;
    end;
    for i := 0 to Items.Count - 1 do                  // check to make sure unique precedence
      if Piece(Items[i], U, 4) = Piece(NewDiet, U, 4)
        then SetError(TX_DIET_PRC + Piece(Items[i], U, 2));
    if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TC_DIET_ERR, MB_OK) else
    begin
      lstDietSelect.Items.Add(NewDiet);
      DietCheckForNPO;
      DietCheckForTF;
//      DietCheckforTFWithNPO;
      OrderMessage(OIMessage(StrToIntDef(Piece(NewDiet, U, 1), 0)));
      DietChange(Sender);
    end; {else of if Length}
  end; {if cboDietAvail}
  cboDietAvail.ItemIndex := -1;
end;

procedure TfrmODDiet.cboDietAvailExit(Sender: TObject);
begin
  inherited;
  if (cboDietAvail.ItemIEN > 0) or (CharAt(cboDietAvail.ItemID, 1) = 'Q') then
    cboDietAvailMouseClick(Self);
end;

procedure TfrmODDiet.cmdRemoveClick(Sender: TObject);
begin
  inherited;
  with lstDietSelect do if ItemIndex > -1 then Items.Delete(ItemIndex);
  DietChange(Sender);
  with lstDietSelect do if Items.Count = 0 then
  begin
    chkCancelTubefeeding.State := cbGrayed;
    chkCancelTubefeeding.Visible := False;
    lblDelivery.Visible := True;
    cboDelivery.Visible := True;
  end;
end;

procedure TfrmODDiet.DietChange(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  if Changing then Exit;
  if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
  with calDietStart   do {if Length(Text) > 0 then} Responses.Update('START',     1, Text,   Text);
//  with calDietStop    do {if Length(Text) > 0 then} Responses.Update('STOP',      1, Text,   Text);
// DRM - I10010348FY16/525455 - 2017/6/20 - can't assume sequence number in list == instance number
//  with lstDietSelect  do for i := 0 to Items.Count - 1 do
//    Responses.Update('ORDERABLE', i+1, Piece(Items[i], U, 1), Piece(Items[i], U, 2));
  with lstDietSelect  do for i := 0 to Items.Count - 1 do
    if not Responses.IValueExists('ORDERABLE', Piece(Items[i], U, 1)) then
      Responses.Update('ORDERABLE', Responses.InstanceCount('ORDERABLE') + 1, Piece(Items[i], U, 1), Piece(Items[i], U, 2));
// DRM ---
  with txtDietComment do {if Length(Text) > 0 then} Responses.Update('COMMENT',   1, Text,   Text);
  with cboDelivery    do if Visible            then Responses.Update('DELIVERY',  1, ItemID, Text);
  with chkCancelTubefeeding do case State of
                                 cbChecked:   Responses.Update('CANCEL', 1, '1', 'YES');
                                 cbUnchecked: Responses.Update('CANCEL', 1, '0', 'NO');
                               end;
  with lstDietSelect do if (Items.Count = 1) and (GetIEN(0) = uDietParams.NPOIEN) then
  begin
    if Frac(calDietStart.FMDateTime) > 0.2358 then Responses.VarTrailing := 'at Midnight';
  end
  else Responses.VarTrailing := 'Diet';
  memOrder.Text := Responses.OrderText;
end;

{ Tubefeeding tab --------------------------------------------------------------------------- }

procedure TfrmODDiet.ResetControlsTF;
begin
  TFClearGrid;
  calOPTFStart.Text := '';
  txtTFComment.Text := '';
end;

procedure TfrmODDiet.SetValuesFromResponsesTF;
var
  AnInstance: Integer;
  AResponse: TResponse;
  AProduct: TTFProduct;
  ADiet : String; //*SMT
begin
  Changing := True;                                        // Changing set!!
  ResetControlsTF;
  with Responses do
  begin
    AnInstance := NextInstance('ORDERABLE', 0);
    while AnInstance > 0 do
    begin
      AResponse := FindResponseByName('ORDERABLE', AnInstance);

      //*SMT Check Orderable Item. Close Dialog if Inactive
      ADiet := DietAttributes(StrToIntDef(AResponse.IValue,0));
      if Piece(ADiet,'^',1)='0' then
      begin
        InfoBox(Piece(ADiet,'^',2), TC_DIET_ERR, MB_OK);
        Responses.Clear;
        AbortOrder := True;
        Exit;
      end;

      if AResponse <> nil then
      begin
        AProduct := TTFProduct.Create;
        AProduct.IEN := StrToIntDef(AResponse.IValue, 0);
        AProduct.Name := AResponse.EValue;
        with grdSelected do
        begin
          if Objects[0, RowCount - 1] <> nil then RowCount := RowCount + 1;
          Objects[0, RowCount - 1] := AProduct;
          Cells[0, RowCount - 1] := AProduct.Name;
          AResponse := FindResponseByName('STRENGTH', AnInstance);
          if AResponse <> nil then Cells[1, RowCount - 1] := AResponse.EValue;
          AResponse := FindResponseByName('INSTR',   AnInstance);
          if AResponse <> nil then Cells[2, RowCount - 1] := AResponse.EValue;
          TFSetAmountForRow(RowCount - 1);
        end;
      end;
      AnInstance := NextInstance('ORDERABLE', AnInstance);
    end; {while AnInstance - ORDERABLE}
    if not OrderForInpatient then
    begin
      SetControl(cboOPTFRecurringMeals, 'DATETIME', 1);
      SetControl(calOPTFStart, 'DATETIME', 1);
    end;
    SetControl(txtTFComment, 'COMMENT',  1);
  end;
  Changing := False;                                       // Changing reset
  TFChange(Self);
end;

procedure TfrmODDiet.SwitchToAccessibleTab(AutoAcceptIfOnlyOne: Boolean);
var
  CurrentTab, Tab: TDietTab;
  DoTimer: Boolean;

begin
  CurrentTab := TDietTab(nbkDiet.ActivePage.Tag);
  if not FTabInfo[CurrentTab].Access.WriteAccess then
  begin
    DoTimer := tmrBringToFront.Enabled;
    if DoTimer then
      tmrBringToFront.Enabled := False;
    Tab := AskForAccessibleTab(Self, NoAccessMessage(CurrentTab), FTabInfo,
      FExcludeTabs, AutoAcceptIfOnlyOne);
    if Tab = dtNone then
    begin
      AbortOrder := True;
      cmdQuitClick(Self);
      Exit;
    end;
    nbkDiet.ActivePage := FTabInfo[Tab].TabSheet;
    nbkDietChange(Self);
    if DoTimer then
      tmrBringToFront.Enabled := True;
  end;
end;

procedure TfrmODDiet.TFClearGrid;
var
  i: Integer;
begin
  with grdSelected do for i := 0 to RowCount - 1 do
  begin
    TTFProduct(Objects[0, i]).Free;
    Rows[i].Clear;
  end;
  grdSelected.RowCount := 1;
end;

procedure TfrmODDiet.cboProductMouseClick(Sender: TObject);
var
  AProduct: TTFProduct;

begin
  inherited;
    // check quick order
  if CharAt(cboProduct.ItemID, 1) = 'Q' then              // setup quick order
  begin
    Responses.QuickOrder := ExtractInteger(cboProduct.ItemID);
    SetValuesFromResponsesTF;
    cboProduct.ItemIndex := -1;
    Exit;
  end;
  if cboProduct.ItemIEN <= 0 then Exit;
  AProduct := TTFProduct.Create;
  AProduct.IEN := cboProduct.ItemIEN;
  AProduct.Name := Piece(cboProduct.Items[cboProduct.ItemIndex], U, 3);
  cboProduct.ItemIndex := -1;
  with grdSelected do
  begin
    if Objects[0, RowCount - 1] <> nil then RowCount := RowCount + 1;
    Objects[0, RowCount - 1] := AProduct;
    Cells[0, RowCount - 1] := AProduct.Name;
    Cells[1, RowCount - 1] := 'FULL';
    Row := RowCount - 1;
    Col := 1;
  end;
  OrderMessage(OIMessage(AProduct.IEN));
  TFChange(Sender);
end;

procedure TfrmODDiet.cboProductExit(Sender: TObject);
begin
  inherited;
  if (cboProduct.ItemIEN > 0) or (CharAt(cboProduct.ItemID, 1) = 'Q') then
    cboProductMouseClick(Self);
end;

procedure TfrmODDiet.grdSelectedDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  inherited;
  if Sender = ActiveControl then Exit;
  if not (gdSelected in State) then Exit;
  with Sender as TStringGrid do
  begin
    Canvas.Brush.Color := Color;
    Canvas.Font := Font;
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
  end;
end;

//CQ 21583 - Addressing numerous PSI 1187 issues - JCS
procedure TfrmODDiet.grdSelectedMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var aCol , aRow: integer;
begin
  Application.HintHidePause := 10000;
  grdSelected.MouseToCell(X,Y,acol , arow);

  if aCol = 2 then
    hint := txtQuantity.hint
  else
    hint := '';
  inherited;
end;

procedure TfrmODDiet.grdSelectedSelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);

  procedure PlaceControl(AControl: TWinControl);
  var
    ARect: TRect;
  begin
    with AControl do
    begin
      ARect := grdSelected.CellRect(Col, Row);
      SetBounds(ARect.Left + grdSelected.Left + 1,  ARect.Top  + grdSelected.Top + 1,
                ARect.Right - ARect.Left + 1,       ARect.Bottom - ARect.Top + 1);
      BringToFront;
      Show;
      SetFocus;
    end;
  end;

begin
  inherited;
  if (Col <> 1) and (Col <> 2) then Exit;
  if csDestroying in ComponentState then Exit;
  if Col = 1 then
  begin
    cboStrength.ItemIndex :=cboStrength.Items.IndexOf(grdSelected.Cells[Col, Row]);
    cboStrength.Tag := (Col * 256) + Row;
    PlaceControl(cboStrength);
  end;
  if Col = 2 then
  begin
    txtQuantity.Text := grdSelected.Cells[Col, Row];
    txtQuantity.Tag  := (Col * 256) + Row;
    PlaceControl(txtQuantity);
  end;
end;

procedure TfrmODDiet.SetNextCell(ACol, ARow: Integer);
begin
  FNextCol := ACol;
  FNextRow := ARow;
end;


procedure TfrmODDiet.setTabToDiet;
begin
  if FTabInfo[dtDiet].Access.WriteAccess then
    self.nbkDiet.ActivePage := self.pgeDiet;
  doNotShowMess := true;
end;

procedure TfrmODDiet.TFMoveToNextCell;
var
  NextCol, NextRow: Integer;
begin
  if (FNextCol < 0) or (FNextRow < 0) then Exit;
  if (ActiveControl = grdSelected) and not (csLButtonDown in grdSelected.ControlState) then
  begin
    NextCol := FNextCol;
    NextRow := FNextRow;
    with grdSelected do if NextCol <> Col then Col := NextCol;
    with grdSelected do if NextRow <> Row then Row := NextRow;
  end;
end;

procedure TfrmODDiet.TFSetAmountForRow(ARow: Integer);
var
  Product, Strength: Integer;
  x: string;
begin
  with grdSelected do
  begin
    if Objects[0, ARow] <> nil
      then Product := TTFProduct(Objects[0, ARow]).IEN
      else Product := 0;
    Strength := TFStrengthCode(Cells[1, ARow]);
    x := ExpandedQuantity(Product, Strength, Cells[2, ARow]);
    if Length(x) > 0 then
    begin
      grdSelected.Cells[2, ARow] := Piece(x, U, 2);
      grdSelected.Cells[3, ARow] := Piece(x, U, 1) + 'ml';
    end
    else grdSelected.Cells[3, ARow] := '';
  end;
end;

function TfrmODDiet.TFStrengthCode(const x: string): Integer;
begin
  Result := 0;
  if      x = '1/4'  then Result := 1
  else if x = '1/2'  then Result := 2
  else if x = '3/4'  then Result := 3
  else if x = 'FULL' then Result := 4;
end;

procedure TfrmODDiet.cboStrengthEnter(Sender: TObject);
begin
  inherited;
  SetNextCell(2, grdSelected.Row);
  if ScreenReaderSystemActive then
   GetScreenReader.Speak('Row ' + IntToStr(grdSelected.Row + 1)+', Strength');
end;

procedure TfrmODDiet.cboStrengthKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  with grdSelected do
    case Key of
    VK_LEFT:  SetNextCell(0, Row);
    VK_RIGHT: SetNextCell(2, Row);
    end;
  if Key in [VK_LEFT, VK_RIGHT] then
  begin
    Key := 0;
    if not (csDestroying in ComponentState) then grdSelected.SetFocus;
  end;
end;

procedure TfrmODDiet.cboStrengthChange(Sender: TObject);
begin
  inherited;
  with cboStrength do
  begin
    if Tag < 0 then Exit;
    grdSelected.Cells[Tag div 256, Tag mod 256] := Text;
  end;
  TFChange(Sender);
end;

procedure TfrmODDiet.cboStrengthExit(Sender: TObject);
begin
  inherited;
  with cboStrength do
  begin
    grdSelected.Cells[Tag div 256, Tag mod 256] := Text;
    TFSetAmountForRow(Tag mod 256);
    Tag := -1;
    Hide;
  end;
  TFChange(Sender);
  TFMoveToNextCell;
end;

procedure TfrmODDiet.txtQuantityEnter(Sender: TObject);
begin
  inherited;
  SetNextCell(-1, -1);
  if ScreenReaderSystemActive then
   GetScreenReader.Speak('Row ' + IntToStr(grdSelected.Row + 1)+', Quanity');
end;

procedure TfrmODDiet.txtQuantityKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  with grdSelected, txtQuantity do
    case Key of
    VK_UP:    SetNextCell(Col, HigherOf(Row - 1, 0));
    VK_DOWN:  SetNextCell(Col, LowerOf(Row + 1, RowCount - 1));
    VK_LEFT:  if (SelLength = 0) and (SelStart = 0) then SetNextCell(1, Row);
    VK_RIGHT: if (SelLength = 0) and (SelStart = Length(Text)) then SetNextCell(3, Row);
    VK_END:   if (SelLength = 0) and (SelStart = Length(Text)) then SetNextCell(3, Row);
    VK_HOME:  if (SelLength = 0) and (SelStart = 0) then SetNextCell(0, Row);
    VK_PRIOR: SetNextCell(Col, 0);
    VK_NEXT:  SetNextCell(Col, RowCount - 1);
    end;
  if FNextCol > -1 then
  begin
    Key := 0;
    if not (csDestroying in ComponentState) then grdSelected.SetFocus;
  end;
end;

procedure TfrmODDiet.UMAfterDisplay(var Message: TMessage);
begin
  SwitchToAccessibleTab(False);
end;

procedure TfrmODDiet.txtQuantityChange(Sender: TObject);
begin
  inherited;
  with txtQuantity do
  begin
    if Tag < 0 then Exit;
    grdSelected.Cells[Tag div 256, Tag mod 256] := Text;
  end;
  TFChange(Sender);
end;

procedure TfrmODDiet.txtQuantityExit(Sender: TObject);
begin
  inherited;
  with txtQuantity do
  begin
    grdSelected.Cells[Tag div 256, Tag mod 256] := Text;
    TFSetAmountForRow(Tag mod 256);
    Tag := -1;
    Hide;
  end;
  TFChange(Sender);
  TFMoveToNextCell;
end;

procedure TfrmODDiet.cmdTFRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  with grdSelected do
  begin
    if Row < 0 then Exit;
    if Objects[0, Row] <> nil then TTFProduct(Objects[0, Row]).Free;
    for i := Row to RowCount - 2 do Rows[i] := Rows[i + 1];
    Rows[RowCount - 1].Clear;
    RowCount := RowCount - 1;
  end;
  TFChange(Sender);
end;

procedure TfrmODDiet.TFChange(Sender: TObject);
var
  i: Integer;
  AProduct: TTFProduct;

begin
  inherited;
  if Changing then Exit;
  if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
  with grdSelected do for i := 0 to RowCount - 1 do
  begin
    AProduct := TTFProduct(Objects[0, i]);
    if AProduct = nil then Continue;
    with AProduct do if IEN > 0
      then Responses.Update('ORDERABLE', i+1, IntToStr(IEN), Name);
    if TFStrengthCode(Cells[1,i]) > 0
      then Responses.Update('STRENGTH',  i+1, IntToStr(TFStrengthCode(Cells[1,i])), Cells[1,i]);
    if Length(Cells[2,i]) > 0
      then Responses.Update('INSTR',     i+1, Cells[2,i], Cells[2,i]);
  end; {with grdSelected}
  with txtTFComment do if Text <> ''
    then Responses.Update('COMMENT', 1, Text, Text);
  if not OrderForInpatient then
  begin
    calOPTFStart.FMDateTime := StrToFloatDef(cboOPTFRecurringMeals.ItemID, 0);
    Responses.Update('DATETIME', 1, FloatToStr(calOPTFStart.FMDateTime), calOPTFStart.Text);
  end;
  memOrder.Text := Responses.OrderText;
end;

{ Early/Late Tray tab ----------------------------------------------------------------------- }

procedure TfrmODDiet.ResetControlsEL;
begin
  grpMeal.ItemIndex    := 3;
  grpMeal.TabStop      := True;
  grpMealTime.TabStop  := False;
  radET1.Visible       := False;
  radET2.Visible       := False;
  radET3.Visible       := False;
  radLT1.Visible       := False;
  radLT2.Visible       := False;
  radLT3.Visible       := False;
  lblNoTimes.Visible   := False;
  calELStart.Text      := '';
  calELStop.Text       := '';
  chkMonday.Checked    := False;
  chkTuesday.Checked   := False;
  chkWednesday.Checked := False;
  chkThursday.Checked  := False;
  chkFriday.Checked    := False;
  chkSaturday.Checked  := False;
  chkSunday.Checked    := False;
  chkBagged.Checked    := False;
end;

procedure TfrmODDiet.SetValuesFromResponsesEL;
var
  AResponse: TResponse;
begin
  Changing := True;
  ResetControlsEL;
  with Responses do
  begin
    AResponse := FindResponseByName('MEAL', 1);
    if AResponse <> nil then
    begin
      if AResponse.IValue = 'B' then grpMeal.ItemIndex := 0;
      if AResponse.IValue = 'N' then grpMeal.ItemIndex := 1;
      if AResponse.IValue = 'E' then grpMeal.ItemIndex := 2;
    end;
    if grpMeal.ItemIndex <> 3 then grpMealClick(Self);
    AResponse := FindResponseByName('TIME', 1);
    if AResponse <> nil then
    begin
      if radET1.Caption = AResponse.IValue then radET1.Checked := True;
      if radET2.Caption = AResponse.IValue then radET2.Checked := True;
      if radET3.Caption = AResponse.IValue then radET3.Checked := True;
      if radLT1.Caption = AResponse.IValue then radLT1.Checked := True;
      if radLT2.Caption = AResponse.IValue then radLT2.Checked := True;
      if radLT3.Caption = AResponse.IValue then radLT3.Checked := True;
    end;
    if not OrderForInpatient then
      SetControl(cboOPELRecurringMeals, 'START', 1)
    else
    begin
      SetControl(calELStart, 'START', 1);
      SetControl(calELStop,  'STOP',  1);
    end;
    calELStopChange(Self);
    AResponse := FindResponseByName('SCHEDULE', 1);
    if AResponse <> nil then
    begin
      chkMonday.Checked    := Pos('M', AResponse.IValue) > 0;
      chkTuesday.Checked   := Pos('T', AResponse.IValue) > 0;
      chkWednesday.Checked := Pos('W', AResponse.IValue) > 0;
      chkThursday.Checked  := Pos('R', AResponse.IValue) > 0;
      chkFriday.Checked    := Pos('F', AResponse.IValue) > 0;
      chkSaturday.Checked  := Pos('S', AResponse.IValue) > 0;
      chkSunday.Checked    := Pos('X', AResponse.IValue) > 0;
    end;
    AResponse := FindResponseByName('YN', 1);
    if AResponse <> nil then chkBagged.Checked := AResponse.IValue = '1';
  end; {with Responses}
  Changing := False;
  ELChange(Self);
end;

function TfrmODDiet.GetMealTime: string;
begin
  Result := '';
  if radET1.Checked then Result := radET1.Caption;
  if radET2.Checked then Result := radET2.Caption;
  if radET3.Checked then Result := radET3.Caption;
  if radLT1.Checked then Result := radLT1.Caption;
  if radLT2.Checked then Result := radLT2.Caption;
  if radLT3.Checked then Result := radLT3.Caption;
end;

function TfrmODDiet.NoAccessMessage(Tab: TDietTab): string;
var
  tabName, DGName: string;

  function CleanName(const txt: string): string;
  begin
    Result := LowerCase(txt);
    Result := Strip(Result, ' ');
    if not Result.EndsWith('s') then
      Result := Result + 's';
  end;

begin
  tabName := FTabInfo[Tab].TabSheet.Caption;
  DGName := FTabInfo[Tab].Access.DisplayName;
  if CleanName(tabName) = CleanName(DGName) then
    Result := Format('You do not have write access to %s.', [DGName])
  else
    Result := Format('You can not use the %s tab because you do not have ' +
      'write access to %s.', [tabName, DGName]);
end;

function TfrmODDiet.GetDaysOfWeek: string;
begin
  Result := '';
  if chkMonday.Checked    then Result := Result + 'M';
  if chkTuesday.Checked   then Result := Result + 'T';
  if chkWednesday.Checked then Result := Result + 'W';
  if chkThursday.Checked  then Result := Result + 'R';
  if chkFriday.Checked    then Result := Result + 'F';
  if chkSaturday.Checked  then Result := Result + 'S';
  if chkSunday.Checked    then Result := Result + 'X';
end;

function TfrmODDiet.IsEarlyTray: Boolean;
begin
  Result := True;
  if radLT1.Checked then Result := False;
  if radLT2.Checked then Result := False;
  if radLT3.Checked then Result := False;
end;

procedure TfrmODDiet.lblTFQuantityClick(Sender: TObject);
begin
  inherited;
  //CQ 21583 - Addressing numerous PSI 1187 issues - JCS
  infoBox(TX_HLPQTY, 'Informational Help Text', MB_OK);
end;

procedure TfrmODDiet.grpMealClick(Sender: TObject);

  procedure SetMealTimes(const x: string);

    procedure ActivateButton( Button: TRadioButton; const MealTime: string;
      var MoreActivated: boolean);
    var
      Activate: boolean;
    begin
      Button.Caption := MealTime;
      Activate := Length(MealTime) > 0;
      Button.Visible := Activate;
      Button.Checked := Activate and not MoreActivated;
      MoreActivated := MoreActivated or Activate;
    end;

  var
    HasTimes: Boolean;
  begin
    HasTimes := False;
    ActivateButton(radET1, Piece(x, U, 1), HasTimes);
    ActivateButton(radET2, Piece(x, U, 2), HasTimes);
    ActivateButton(radET3, Piece(x, U, 3), HasTimes);
    ActivateButton(radLT1, Piece(x, U, 4), HasTimes);
    ActivateButton(radLT2, Piece(x, U, 5), HasTimes);
    ActivateButton(radLT3, Piece(x, U, 6), HasTimes);
    lblNoTimes.Visible := not HasTimes;
  end;
var
  AMeal: string;
begin
  inherited;
  Changing := True;
  case grpMeal.ItemIndex of
    0: begin
         SetMealTimes(uDietParams.BTimes);
         AMeal := 'B';
       end;
    1: begin
         SetMealTimes(uDietParams.NTimes);
         AMeal := 'N';
       end;
    2: begin
         SetMealTimes(uDietParams.ETimes);
         AMeal := 'E';
       end;
  else
    begin
      SetMealTimes('');
      AMeal := '';
    end;
  end;
  if not OrderForInpatient then
    begin
      if AMeal = '' then
      begin
        uRecurringMealList.Clear;
        cboOPELRecurringMeals.Clear;
      end
      else if not PatientHasRecurringMeals(uRecurringMealList, AMeal) then
        begin
          uRecurringMealList.Clear;
          cboOPELRecurringMeals.Clear;
          grpMeal.ItemIndex := 3;
        end
      else
        FastAssign(uRecurringMealList, cboOPELRecurringMeals.Items);
    end;
  Changing := False;
  ELChange(grpMeal);
end;


procedure TfrmODDiet.SetEnableDOW(AllowUse: Boolean);
begin
  grpDOW.Enabled       := AllowUse;
  chkMonday.Enabled    := AllowUse;
  chkTuesday.Enabled   := AllowUse;
  chkWednesday.Enabled := AllowUse;
  chkThursday.Enabled  := AllowUse;
  chkFriday.Enabled    := AllowUse;
  chkSaturday.Enabled  := AllowUse;
  chkSunday.Enabled    := AllowUse;
end;

procedure TfrmODDiet.calELStartEnter(Sender: TObject);
begin
  inherited;
//  FChangeStop := Length(calELStop.Text) = 0;
end;

procedure TfrmODDiet.calELStartChange(Sender: TObject);
begin
  inherited;
//  if FChangeStop then
//    calELStop.Text := calELStart.Text
//  else
    ELChange(Sender);
end;

procedure TfrmODDiet.calELStartExit(Sender: TObject);
begin
  inherited;
  if not OrderForInpatient then SetEnableDOW(False)
  else if (Length(calELStop.Text) > 0) and (calELStop.Text = calELStart.Text)
    then SetEnableDOW(False)
    else SetEnableDOW(True);
end;

procedure TfrmODDiet.calELStopChange(Sender: TObject);
begin
  inherited;
  if (Length(calELStop.Text) > 0) and (calELStop.FMDateTime = calELStart.FMDateTime)
    then SetEnableDOW(False)
    else SetEnableDOW(True);
  ELChange(Sender);
end;

procedure TfrmODDiet.ELChange(Sender: TObject);
var
  x: string;
begin
  inherited;
  if Changing then Exit;
  if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
  case grpMeal.ItemIndex of
  0: Responses.Update('MEAL', 1, 'B', 'BREAKFAST');
  1: Responses.Update('MEAL', 1, 'N', 'NOON');
  2: Responses.Update('MEAL', 1, 'E', 'EVENING');
  end;
  x := GetMealTime;
  if Length(x) > 0 then
  begin
    Responses.Update('TIME', 1, x, x);
    if IsEarlyTray
      then Responses.Update('ORDERABLE', 1, uDietParams.EarlyIEN, 'EARLY TRAY')
      else Responses.Update('ORDERABLE', 1, uDietParams.LateIEN,  'LATE TRAY');
  end;
  if not OrderForInpatient then
  begin
    calELStart.FMDateTime := StrToFloatDef(cboOPELRecurringMeals.ItemID, 0);
    calELStop.FMDateTime := calELStart.FMDateTime;
  end;
  with calELStart   do if Length(Text) > 0 then Responses.Update('START',     1, Text,   Text);
  with calELStop    do if Length(Text) > 0 then Responses.Update('STOP',      1, Text,   Text);
  x := GetDaysOfWeek;
  if Length(x) > 0 then Responses.Update('SCHEDULE', 1, x, x);
  if chkBagged.Checked
    then Responses.Update('YN', 1, '1', 'YES')
    else Responses.Update('YN', 1, '0', 'NO');
  memOrder.Text := Responses.OrderText;
end;

{ Isolation Precautions tab ----------------------------------------------------------------- }

procedure TfrmODDiet.ResetControlsIP;
begin
  lstIsolation.ItemIndex := -1;
  txtIPComment.Text := '';
end;

procedure TfrmODDiet.SetValuesFromResponsesIP;
begin
  Changing := True;
  ResetControlsIP;
  Responses.SetControl(lstIsolation, 'ISOLATION', 1);
  Responses.SetControl(txtIPComment, 'COMMENT',   1);
  Changing := False;
  IPChange(Self);
end;

procedure TfrmODDiet.IPChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
  Responses.Update('ORDERABLE', 1, FIsolationID, 'Isolation Procedures');
  with lstIsolation do if ItemIEN > 0
    then Responses.Update('ISOLATION', 1, ItemID, DisplayText[ItemIndex]);
  with txtIPComment do if Text <> ''
    then Responses.Update('COMMENT', 1, Text, Text);
  memOrder.Text := Responses.OrderText;
end;

{ Additional Diet Order tab ----------------------------------------------------------------- }

procedure TfrmODDiet.ResetControlsAO;
begin
  txtAOComment.Text := '';
  calOPAOStart.Text := '';
end;

procedure TfrmODDiet.SetValuesFromResponsesAO;
begin
  Changing := True;
  ResetControlsAO;
  Responses.SetControl(txtAOComment, 'COMMENT', 1);
  //Responses.SetControl(calOPAOStart, 'DATETIME', 1);
  Responses.SetControl(cboOPAORecurringMeals, 'DATETIME', 1);
  Changing := False;
  AOChange(Self);
end;

procedure TfrmODDiet.AOChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  with txtAOComment do if Text <> ''
    then Responses.Update('COMMENT', 1, Text, Text);
  if not OrderForInpatient then
    begin
      calOPAOStart.FMDateTime := StrToFloatDef(cboOPAORecurringMeals.ItemID, 0);
      Responses.Update('DATETIME', 1, FloatToStr(calOPAOStart.FMDateTime), calOPAOStart.Text);
    end;
  memOrder.Text := Responses.OrderText;
end;


{ Outpatient Meals Order tab ----------------------------------------------------------------- }

procedure TfrmODDiet.cboOPDietAvailMouseClick(Sender: TObject);
var
  NewDiet,ErrMsg: string;

  procedure SetError(const AnError: string);
  begin
    if Length(ErrMsg) > 0 then Exit;
    ErrMsg := AnError;
  end;

begin
  inherited;
  if cboOPDietAvail.Items.Count = 0 then
    begin
      InfoBox(TX_NO_MEALS_DEFINED, TC_NO_MEALS_DEFINED, MB_OK or MB_ICONINFORMATION);
      AbortOrder := True;
      exit;
    end  ;
  if CharAt(cboOPDietAvail.ItemID, 1) = 'Q' then              // setup quick order
  begin
    Responses.QuickOrder := ExtractInteger(cboOPDietAvail.ItemID);
    SetValuesFromResponsesOP;
    cboOPDietAvail.ItemIndex := -1;
    Exit;
  end;
  if cboOPDietAvail.ItemIEN > 0 then with lstOPDietSelect do
  begin
    ErrMsg := '';
    NewDiet := DietAttributes(cboOPDietAvail.ItemIEN);
    if Piece(NewDiet,'^',1)='0' then
    begin
      InfoBox(Piece(NewDiet,'^',2),TC_OP_DIET_ERR, MB_OK);
      cboOPDietAvail.ItemIndex := -1;
      Exit;
    end;
    lstOPDietSelect.Items.Clear;
    lstOPDietSelect.Items.Add(NewDiet);
{ TODO -oRich V. -cOutpatient Meals : Will these be selectable for an outpatient meal? }
    OPDietCheckForNPO;
{ TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
    OPDietCheckForTF;
    OrderMessage(OIMessage(StrToIntDef(Piece(NewDiet, U, 1), 0)));
    OPChange(Sender);
  end; {if cboOPDietAvail}
  OPChange(Sender);
  cboOPDietAvail.ItemIndex := -1;
end;

procedure TfrmODDiet.cboOPDietAvailExit(Sender: TObject);
begin
  inherited;
  if (cboOPDietAvail.ItemIEN > 0) or (CharAt(cboOPDietAvail.ItemID, 1) = 'Q') then
    cboOPDietAvailMouseClick(Self);
end;

procedure TfrmODDiet.ResetControlsOP;
begin
  lstOPDietSelect.Clear;
  cboOPDietAvail.ItemIndex := -1;
  grpOPMeal.ItemIndex    := 3;
  grpOPMeal.TabStop      := True;
  chkOPMonday.Checked    := False;
  chkOPTuesday.Checked   := False;
  chkOPWednesday.Checked := False;
  chkOPThursday.Checked  := False;
  chkOPFriday.Checked    := False;
  chkOPSaturday.Checked  := False;
  chkOPSunday.Checked    := False;
  lblOPComment.Visible   := False;
  txtOPDietComment.Visible := False;
  txtOPDietComment.Text := '';
  if uDialogName = 'FHW OP MEAL' then
    begin
      calOPStart.Text      := '';
//      calOPStop.Text       := '';
      calOPStart.Enabled := True;
//      calOPStop.Enabled := True;
//      lblOPStart.Enabled := True;
//      lblOPStop.Enabled := True;
      grpOPDOW.Visible := True;
    end
  else if uDialogName = 'FHW SPECIAL MEAL' then
    begin
      calOPStart.Text := 'TODAY';
//      calOPStop.Text  := 'TODAY';
      calOPStart.Enabled := False;
//      calOPStop.Enabled := False;
//      lblOPStart.Enabled := False;
//      lblOPStop.Enabled := False;
      grpOPDOW.Visible := False;
    end;
end;

procedure TfrmODDiet.SetValuesFromResponsesOP;
var
  AResponse: TResponse;
  ADiet: string;
begin
  Changing := True;
  ResetControlsOP;
  with Responses do
  begin
    AResponse := FindResponseByName('ORDERABLE', 1);
    if AResponse <> nil then
    begin
      ADiet := DietAttributes(StrToIntDef(AResponse.IValue,0));
      if Piece(ADiet,'^',1)='0' then
      begin
        InfoBox(Piece(ADiet,'^',2), TC_OP_DIET_ERR, MB_OK);
        cboOPDietAvail.ItemIndex := -1;
        Changing := False;
        Exit;
      end;
      SetControl(cboOPDietAvail,    'ORDERABLE', 1);
      lstOPDietSelect.Items.Add(ADiet);
    end;
    SetControl(cboOPDelivery,    'DELIVERY', 1);
    AResponse := FindResponseByName('MEAL', 1);
    if AResponse <> nil then
    begin
      if AResponse.IValue = 'B' then grpOPMeal.ItemIndex := 0;
      if AResponse.IValue = 'N' then grpOPMeal.ItemIndex := 1;
      if AResponse.IValue = 'E' then grpOPMeal.ItemIndex := 2;
    end;
    SetControl(calOPStart, 'START', 1);
    SetControl(calOPStop,  'STOP',  1);
    calOPStopChange(Self);
    AResponse := FindResponseByName('SCHEDULE', 1);
    if AResponse <> nil then
    begin
      chkOPMonday.Checked    := Pos('M', AResponse.IValue) > 0;
      chkOPTuesday.Checked   := Pos('T', AResponse.IValue) > 0;
      chkOPWednesday.Checked := Pos('W', AResponse.IValue) > 0;
      chkOPThursday.Checked  := Pos('R', AResponse.IValue) > 0;
      chkOPFriday.Checked    := Pos('F', AResponse.IValue) > 0;
      chkOPSaturday.Checked  := Pos('S', AResponse.IValue) > 0;
      chkOPSunday.Checked    := Pos('X', AResponse.IValue) > 0;
    end;
    SetControl(txtOPDietComment, 'COMMENT',  1);
  end; {with Responses}
  OPDietCheckForNPO;
  OPDietCheckForTF;
  Changing := False;
  OPChange(Self);
end;

procedure TfrmODDiet.calOPStartEnter(Sender: TObject);
begin
  inherited;
//  FChangeStop := Length(calOPStop.Text) = 0;
end;

procedure TfrmODDiet.calOPStartChange(Sender: TObject);
var
Days: string;

begin
  inherited;
  if Changing then exit;
  if (calOPStart.FMDateTime > 0) then
  begin
    Days := FMDays(calOPStart.FMDateTime,FMDateTimeOffsetBy(calOPStart.FMDateTime,7));
    SetEnableOPDOW(True, -1, Days);
  end;
  OPChange(Sender);
end;

function TfrmODDiet.FMDOW(AnFMDate: TFMDateTime): integer;
var
  WinDate: TDateTime;
  x: integer;
begin
  WinDate := FMDateTimeToDateTime(AnFMDate);
  x := DayOfTheWeek(WinDate);
  Result := x;
end;

function TfrmODDiet.FMDays(AStart, AEnd: TFMDateTime): string;
var
  AWinStart, AWinEnd: TDateTime;
  i: double;
  Days: string;
begin
  AWinStart := FMDateTimeToDateTime(AStart);
  AWinEnd := FMDateTimeToDateTime(AEnd);
  i := AWinStart;
  repeat
    Days := Days + String(FMDayLetters[DayOfTheWeek(i)]);
    i := i + 1;
  until i > AWinEnd;
  Result := Days;
end;

procedure TfrmODDiet.calOPStartExit(Sender: TObject);
var
  Days: string;
begin
  inherited;
  if not (calOPStart.FMDateTime > 0) then
  begin
    Days := FMDays(calOPStart.FMDateTime,FMDateTimeOffsetBy(calOPStart.FMDateTime,7));
    SetEnableOPDOW(True, -1, Days);
//    SetEnableOPDOW(False, -1);
    Exit ;
  end;
  if (Length(calOPStop.Text) > 0) and (calOPStop.Text = calOPStart.Text) then
    SetEnableOPDOW(False, FMDOW(calOPStart.FMDateTime))
  else
  begin
//
    Days := FMDays(calOPStart.FMDateTime, calOPStart.FMDateTime);
//    Days := FMDays(calOPStart.FMDateTime,FMDateTimeOffsetBy(calOPStart.FMDateTime,7));
    SetEnableOPDOW(True, -1, Days);
  end;
end;

procedure TfrmODDiet.calOPStopChange(Sender: TObject);
var
  Days: string;
begin
  inherited;
  if Changing then exit;
  if not (calOPStop.FMDateTime > 0) then
  begin
    SetEnableOPDOW(False, -1);
    Exit ;
  end;
  if (Length(calOPStop.Text) > 0) and (calOPStop.FMDateTime = calOPStart.FMDateTime) then
    SetEnableOPDOW(False, FMDOW(calOPStart.FMDateTime))
  else
  begin
    Days := FMDays(calOPStart.FMDateTime, calOPStop.FMDateTime);
//    Days := FMDays(calOPStart.FMDateTime,FMDateTimeOffsetBy(calOPStart.FMDateTime,7));
    SetEnableOPDOW(True, -1, Days);
  end;
  OPChange(Sender);
end;

procedure TfrmODDiet.OPChange(Sender: TObject);
var
  x: string;
  //i: integer;
begin
  inherited;
  if Changing then Exit;
  if Sender <> Self then Responses.Clear;       // Sender=Self when called from SetupDialog
  // Per NFS, only one selection allowed from any of 10-15 available OP diets
  with lstOPDietSelect do if Items.Count > 0 then
    Responses.Update('ORDERABLE', 1, Piece(Items[0], U, 1), Piece(Items[0], U, 2));
  case grpOPMeal.ItemIndex of
    0: Responses.Update('MEAL', 1, 'B', 'BREAKFAST');
    1: Responses.Update('MEAL', 1, 'N', 'NOON');
    2: Responses.Update('MEAL', 1, 'E', 'EVENING');
  end;
  with calOPStart   do (*if Length(Text) > 0 then*) Responses.Update('START',     1, Text,   Text);
  with calOPStop    do (*if Length(Text) > 0 then*) Responses.Update('STOP',      1, Text,   Text);
  if uDialogName = 'FHW OP MEAL' then
    begin
      x := GetOPDaysOfWeek;
      if Length(x) = 0 then x := 'ONCE';
      Responses.Update('SCHEDULE', 1, x, x);
    end;
  with txtOPDietComment do {if Length(Text) > 0 then} Responses.Update('COMMENT',   1, Text,   Text);
  with cboOPDelivery    do if Visible            then Responses.Update('DELIVERY',  1, ItemID, Text);
{ TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
(*  with chkOPCancelTubefeeding do case State of
                                 cbChecked:   Responses.Update('CANCEL', 1, '1', 'YES');
                                 cbUnchecked: Responses.Update('CANCEL', 1, '0', 'NO');
                               end;*)
  Responses.VarTrailing := 'Meal';
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODDiet.grpOPMealClick(Sender: TObject);
begin
  inherited;
  OPChange(Sender);
end;

procedure TfrmODDiet.SetEnableOPDOW(AllowUse: Boolean; OneTimeDay: integer; DaysToCheck: string = '');
var
  i: integer;
begin
  if (not AllowUse) and (OneTimeDay > -1) then
    begin
      for i := 0 to grpOPDOW.ControlCount - 1 do
      begin
        if grpOPDOW.Controls[i] is TCheckBox then
          TCheckBox(grpOPDOW.Controls[i]).Checked := False;
      end;
      //TCheckBox(grpOPDOW.Controls[OneTimeDay - 1]).Checked := True;  CQ #8305
    end;
  grpOPDOW.Enabled       := AllowUse;
  chkOPMonday.Enabled    := AllowUse and (Pos('M', DaysToCheck) > 0);
  chkOPTuesday.Enabled   := AllowUse and (Pos('T', DaysToCheck) > 0);
  chkOPWednesday.Enabled := AllowUse and (Pos('W', DaysToCheck) > 0);
  chkOPThursday.Enabled  := AllowUse and (Pos('R', DaysToCheck) > 0);
  chkOPFriday.Enabled    := AllowUse and (Pos('F', DaysToCheck) > 0);
  chkOPSaturday.Enabled  := AllowUse and (Pos('S', DaysToCheck) > 0);
  chkOPSunday.Enabled    := AllowUse and (Pos('X', DaysToCheck) > 0);
end;

function TfrmODDiet.GetOPDaysOfWeek: string;
begin
  Result := '';
  if chkOPMonday.Checked    then Result := Result + 'M';
  if chkOPTuesday.Checked   then Result := Result + 'T';
  if chkOPWednesday.Checked then Result := Result + 'W';
  if chkOPThursday.Checked  then Result := Result + 'R';
  if chkOPFriday.Checked    then Result := Result + 'F';
  if chkOPSaturday.Checked  then Result := Result + 'S';
  if chkOPSunday.Checked    then Result := Result + 'X';
end;

procedure TfrmODDiet.cmdOPRemoveClick(Sender: TObject);
begin
  inherited;
  with lstOPDietSelect do if ItemIndex > -1 then Items.Delete(ItemIndex);
  OPChange(Sender);
  with lstOPDietSelect do if Items.Count = 0 then
  begin
    lblOPDelivery.Visible := True;
    cboOPDelivery.Visible := True;
{ TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
    chkOPCancelTubefeeding.State := cbGrayed;
    chkOPCancelTubefeeding.Visible := False;
  end;
end;

function TfrmODDiet.GetOPMealWindow: string;
begin
  case grpOPMeal.ItemIndex of
    0:  Result := Pieces(uDietParams.Alarms, U, 1, 2);
    1:  Result := Pieces(uDietParams.Alarms, U, 3, 4);
    2:  Result := Pieces(uDietParams.Alarms, U, 5, 6);
  else
    Result := U;
  end;
end;

function TfrmODDiet.GetDietTab(idx: integer): TDietTab;
var
  i, j: integer;
  Done: boolean;

begin
  i := -1;
  j := -1;
  repeat
    inc(i);
    Done := (i >= nbkDiet.PageCount);
    if (not Done) and nbkDiet.Pages[i].TabVisible then
      inc(j);
  until (j = idx) or Done;
  if Done or (j < 0) then
    exit(dtNone);
  Result := TDietTab(i);
end;

procedure TfrmODDiet.OPDietCheckForNPO;
begin
{ TODO -oRich V. -cOutpatient Meals : Need NFS input on this section (NPO and special instructions.) }
  if (lstOPDietSelect.Count > 0) and (Piece(lstOPDietSelect.Items[0], U, 2) = 'NPO') then
  begin
    lblOPDelivery.Visible := False;
    cboOPDelivery.Visible := False;
    lblOPComment.Visible := True;
    txtOPDietComment.Visible := True;
  end else
  begin
    lblOPComment.Visible := False;
    txtOPDietComment.Visible := False;
    txtOPDietComment.Text := '';
  end;
end;

{ TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
procedure TfrmODDiet.OPDietCheckForTF;
var
  x: string;
begin
  with lstOPDietSelect do
  begin
    if (Items.Count = 1) and (Piece(Items[0], U, 2) <> 'NPO')
      and (Length(uDietParams.CurTF) > 0) then
    begin
      x := TextForOrder(uDietParams.CurTF);
      if InfoBox(TX_CANCEL_TF + x, TC_CANCEL_TF, MB_YESNO) = IDYES then
      begin
        chkOPCancelTubeFeeding.State := cbChecked;
        chkOPCancelTubeFeeding.Visible := True;
      end
      else chkOPCancelTubeFeeding.State := cbUnchecked;
    end; {if (Items...}
  end; {with lstOPDietSelect}
end;

{ Common Buttons ---------------------------------------------------------------------------- }

procedure TfrmODDiet.cmdAcceptClick(Sender: TObject);
var
  DCOrder: TOrder;
  LateTrayFields: TLateTrayFields;
  //CxMsg: string;
begin
  // these actions should be before inherited, so that InitDialog doesn't clear properties
  LateTrayFields.LateMeal := #0;      // #0 so only create late order if LT dialog invoked
  if nbkDiet.ActivePage = pgeDiet then
  begin
(*    if Self.EvtID <> 0 then
    begin
      CheckForAutoDCDietOrders(Self.EvtID, Self.DisplayGroup, '', CxMsg, cmdAccept);
      if CxMsg <> '' then
      begin
        if InfoBox(CxMsg + CRLF + CRLF +
           'Have you done either of the above?', 'Possible delayed order conflict',
           MB_ICONWARNING or MB_YESNO) = ID_NO
           then exit;
      end;
    end;*)
    // create dc tubefeeding order
    if chkCancelTubeFeeding.State = cbChecked then
    begin
      DCOrder := TOrder.Create;
      DCOrder.ID := uDietParams.CurTF;
      SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_DC, Integer(DCOrder));
      DCOrder.Free;
    end;
    // check if late tray should be ordered
    LateTrayCheck(Responses, Self.EvtID, FALSE, LateTrayFields);
  end;
{ TODO -oRich V. -cOutpatient Meals : Need to DC Tubefeeding order for OP meals? }
  if nbkDiet.ActivePage = pgeOutPt then
  begin
    // create dc tubefeeding order
    if chkOPCancelTubeFeeding.State = cbChecked then
    begin
      DCOrder := TOrder.Create;
      DCOrder.ID := uDietParams.CurTF;
      SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_DC, Integer(DCOrder));
      DCOrder.Free;
    end;
    // check if late tray should be ordered
    LateTrayCheck(Responses, Self.EvtID, TRUE, LateTrayFields);
  end;
  inherited;
  with LateTrayFields do if LateMeal <> #0 then LateTrayOrder(LateTrayFields, OrderForInpatient);
end;

type
  THackPageControl = class(TPageControl);

procedure TfrmODDiet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then begin
    if (ssCtrl in Shift) then begin
      if not (ActiveControl is TCustomMemo) or not TMemo(ActiveControl).WantTabs then begin
        nbkDiet.SelectNextPage( not (ssShift in Shift));
        Key := 0;
      end;
    end;
  end;
  if (ActiveControl = nbkDiet) then
  begin
    with THackPageControl(nbkDiet) do
    begin
      if Key = VK_RIGHT then
      begin
        if TabIndex < (Tabs.Count - 1) then
          FNextTabIdx := TabIndex + 1
        else
          FNextTabIdx := -1;
      end
      else if Key = VK_LEFT then
      begin
        if TabIndex > 0 then
          FNextTabIdx := TabIndex - 1
        else
          FNextTabIdx := -1;
      end;
    end;
  end;
end;

procedure TfrmODDiet.cboOPDietAvailKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then cboOPDietAvailMouseClick(Self);
end;

function TfrmODDiet.PatientHasRecurringMeals(var MealList: TStringList; MealType: string = ''): boolean;
const
  TX_NO_RECURRING_MEALS = 'For outpatients, this type of order requires association with an existing recurring' + CRLF +
                          'meal order.  There are currently no active recurring meal orders for this patient.' + CRLF + CRLF +
                          'Those orders must be signed and released before they can be linked to this item.';
  TC_NO_RECURRING_MEALS = 'Unable to order ' ;
begin
  MealList.Clear;
  GetCurrentRecurringOPMeals(MealList, MealType);
  if MealList.Count = 0 then
    begin
      InfoBox(TX_NO_RECURRING_MEALS, TC_NO_RECURRING_MEALS + nbkDiet.ActivePage.Caption, MB_OK);
      Result := False;
    end
  else
    Result := True;
end;

constructor TlbGrid508Manager.Create;
begin
  inherited Create([mtValue, mtItemChange]);
end;

function TlbGrid508Manager.GetTextToSpeak(LB: TCaptionStringGrid): String;
var
  textToSpeak : String;
begin
  textToSpeak := '';

  textToSpeak := 'Row ' + IntToStr(Lb.Row + 1)+', '+ Piece(HeaderStr, '^', (LB.Col + 1)) + ', ' + ToBlankIfEmpty(LB.Cells[lb.Col, Lb.Row]);
  Result := textToSpeak;

end;

function TlbGrid508Manager.GetValue(Component: TWinControl): string;
var
  LB : TCaptionStringGrid;
begin
  LB := TCaptionStringGrid(Component);
  Result := GetTextToSpeak(LB);
end;

function TlbGrid508Manager.ToBlankIfEmpty(aString: String): String;
begin
  Result := aString;
  if aString = '' then
  Result := 'blank';
end;

end.
