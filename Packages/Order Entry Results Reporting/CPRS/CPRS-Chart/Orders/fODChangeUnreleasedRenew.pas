unit fODChangeUnreleasedRenew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ORCtrls, fAutoSz, uOrders, ORFn, ORDtTm, rOrders,
  VA508AccessibilityManager, VA508AccessibilityRouter, rODBase, rODMeds, Vcl.ComCtrls;

type
  TfrmODChangeUnreleasedRenew = class(TFrmAutoSz)
    memOrder: TCaptionMemo;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    txtStart: TORDateBox;
    txtStop: TORDateBox;
    txtSupply: TCaptionEdit;
    spnSupply: TUpDown;
    lblDays: TLabel;
    txtQuantity: TCaptionEdit;
    lblQuantity: TLabel;
    spnQuantity: TUpDown;
    txtRefills: TCaptionEdit;
    lblRefills: TLabel;
    spnRefills: TUpDown;
    cboPickup: TORComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure txtSupplyChange(Sender: TObject);
    procedure txtQuantityChange(Sender: TObject);
    procedure txtRefillsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtSupplyClick(Sender: TObject);
    procedure txtQuantityClick(Sender: TObject);
    procedure txtRefillsClick(Sender: TObject);
  private
    FInit: boolean;
    OKPressed: boolean;
    FCategory: integer;
    FChanging: Boolean;
    FResponses: TList;
    FLastUnits, FLastSchedule, FLastDuration, FLastInstruct, FLastDispDrug: string;
    FLastQuantity: Double;
    FLastSupply: Integer;
    FLastTitration: boolean;
    FNoZERO: Boolean;
    FUpdated: Boolean;
    FComplex: boolean;
    FEvent: Char;
    FUpdateQuantity: string;
    FActLikeQuickOrder: boolean;
    procedure UpdateData;
    procedure UpdateCtrls;
    function IsValid: boolean;
  public
    FDrugName: string;
    { Public declarations }
  end;

procedure ExecuteChangeRenewedOrder(const AnID: string;
      var param1, param2, param3, param4: string; Category: integer;
      AnEvent: TOrderDelayEvent; IsTitration: boolean);

implementation

uses uPaPI, uCore;

{$R *.dfm}
const
  TC_INVALID_DATE = 'Unable to interpret date/time entry.';
  TX_BAD_START   = 'The start date is not valid.';
  TX_BAD_STOP    = 'The stop date is not valid.';
  TX_STOPSTART   = 'The stop date must be after the start date.';
  TX_NO_RENEW     = 'Cannot change this renewal order for the following reason';
  TX_NO_RENEW_CAP = 'Unable to Change Renewal Order';

procedure ExecuteChangeRenewedOrder(const AnID: string;
      var param1, param2, param3, param4: string; Category: integer;
      AnEvent: TOrderDelayEvent; IsTitration: boolean);
var
  frmODChangeUnreleasedRenew: TfrmODChangeUnreleasedRenew;
  theText, EDrug: string;
  tmpRefills, tmpDays: integer;
  tmpQty: Double;
  DestList: TList;
  HasObject: Boolean;
  i, doseCount: Integer;

begin
  DestList := TList.Create();
  try
    LoadResponses(DestList, 'X' + AnID, HasObject, IsTitration);
    doseCount := 0;
    for I := 0 to DestList.Count - 1 do
    begin
      with TResponse(DestList.Items[i]) do
      begin
        if PromptID = 'DRUG' then
          EDrug := EValue
        else if PromptID = 'DOSE' then inc(doseCount);
      end;
    end;

    tmpRefills := 0;
    tmpDays := 0;
    tmpQty := 0.0;

    theText := Trim(RetrieveOrderText(AnID));
    if Pos('>> RENEW', UpperCase(theText)) = 1 then Delete(theText,1,length('>> RENEW'))
    else if Pos('RENEW',UpperCase(theText))= 1 then Delete(theText,1,length('RENEW'));
    ResponsesAdapter.Assign(DestList);
    frmODChangeUnreleasedRenew := TfrmODChangeUnreleasedRenew.Create(Application);
    try
      frmODChangeUnreleasedRenew.FCategory := Category;
      ResizeFormToFont(TForm(frmODChangeUnreleasedRenew));
      with frmODChangeUnreleasedRenew do
      begin
        FActLikeQuickOrder := True;
        FResponses := DestList;
        FComplex := (doseCount > 1);
        FEvent := AnEvent.EventType;
        FDrugName := EDrug;
        FUpdateQuantity := '';
        if Category = 0 then
        begin
          Panel3.Visible := False;
          tmpRefills := StrToIntDef(param1, 0);
          spnRefills.Position := tmpRefills;
          cboPickup.SelectByID(param2); // 'P' for PaPI
          tmpDays := StrToIntDef(param3, 0);
          spnSupply.Position := tmpDays;
          tmpQty := StrToFloatDef(param4, 0.0);
          spnQuantity.Position := trunc(tmpQty);
          if tmpQty <> trunc(tmpQty) then
            FUpdateQuantity := FloatToStr(tmpQty);
          memOrder.SetTextBuf(PChar(theText));
        end
        else if Category = 1 then
        begin
          Panel2.Visible := false;
          txtStart.Text := param1;
          txtStop.Text  := param2;
          memOrder.SetTextBuf(PChar(theText));
        end;
        ShowModal;
        if OKPressed then
        begin
          if Category = 0 then
          begin
            tmpRefills := StrToIntDef(txtRefills.Text, tmpRefills);
            param1 := IntToStr(tmpRefills);
            param2 := cboPickup.ItemID; // 'P' for Park. PaPI
            tmpDays := StrToIntDef(txtSupply.Text, tmpDays);
            param3 := IntToStr(tmpDays);
            tmpQty := StrToFloatDef(txtQuantity.Text, tmpQty);
            param4 := FloatToStr(tmpQty);
          end
          else if Category = 1 then
          begin
            param1 := txtStart.Text;
            param2 := txtStop.Text;
          end;
        end;
      end;
    finally
      frmODChangeUnreleasedRenew.Release;
    end;
  finally
    DestList.Free;
  end;
end;

procedure TfrmODChangeUnreleasedRenew.FormCreate(Sender: TObject);
begin
  inherited;
  FInit := True;
  OKPressed := False;
  with cboPickup.Items do
  begin
    Add('W^at Window');
    Add('M^by Mail');
    if not rOrders.UAPViewCalling then //rtw
      Add('C^in Clinic');
    if PapiParkingAvailable then  ///////////////////////////////////////// PaPI
      Add('P^Park');
  end;
  FLastUnits := '';
  FLastSchedule := '';
  FLastDuration := '';
  FLastInstruct := '';
  FLastDispDrug := '';
  FLastQuantity := 0.0;
  FLastSupply := 0;
  FLastTitration := False;
  FNoZERO := False;
  FUpdated := False;
  FDrugName := '';
  txtRefills.Tag := 0;
  txtSupply.Tag := 0;
  txtQuantity.Tag := 0;
end;

procedure TfrmODChangeUnreleasedRenew.FormShow(Sender: TObject);
begin
  inherited;
  if ScreenReaderSystemActive then
  begin
    memOrder.TabStop := true;
    memOrder.SetFocus;
  end;
  if FUpdateQuantity <> '' then
  begin
    txtQuantity.Text := FUpdateQuantity;
    FUpdateQuantity := '';
  end;
  FInit := False;
  UpdateCtrls;
  FActLikeQuickOrder := False;
end;

function TfrmODChangeUnreleasedRenew.IsValid: boolean;
var
  MaxRefills, NumRefills, DaysSup, maxDS, errCount: Integer;
  s, AnErrMsg, Drug, OrID, Qty: string;
  Titration: boolean;

  procedure SetError(const X: string);
  begin
    if Length(AnErrMsg) > 0 then
      AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + X;
    inc(errCount);
  end;

begin
  Result := False;
  AnErrMsg := '';
  errCount := 0;
  UpdateCtrls;
  NumRefills := StrToIntDef(txtRefills.Text, -1);
  if StrToIntDef(txtSupply.Text, 0) < 1 then
    SetError(TX_SUPPLY_NINT);
  with ResponsesAdapter do
  begin
    maxDS := GetMaxDS(IValueFor('ORDERABLE', 1), IValueFor('DRUG', 1));
    DaysSup := StrToIntDef(IValueFor('SUPPLY', 1), 0);
    if (DaysSup > maxDS) then
      SetError(TX_SUPPLY_LIM + IntToStr(maxDS));
    if (DaysSup < 1) then
      SetError(TX_SUPPLY_LIM1);

    Qty := IValueFor('QTY', 1);
    if not ValidQuantity(Qty) then
      SetError(TX_QTY_NV);

    Drug := IValueFor('DRUG', 1);
    OrID := IValueFor('ORDERABLE', 1);
    Titration := (IValueFor('TITR', 1) = '1');

    MaxRefills := CalcMaxRefills(Drug, DaysSup, StrToIntDef(OrID, 0),
                    FEvent = 'D', Titration);
    if (NumRefills < 0) or (NumRefills > MaxRefills) then
      SetError(TX_ERR_REFILL + IntToStr(MaxRefills));
  end;

  if AnErrMsg = '' then
    Result := True
  else
  begin
    if errCount > 1 then
      s := 's'
    else
      s := '';
    InfoBox(TX_NO_RENEW + s + TX_NO_RENEW_END + AnErrMsg, TX_NO_RENEW_CAP, MB_OK);
  end;
end;

procedure TfrmODChangeUnreleasedRenew.txtQuantityChange(Sender: TObject);
begin
  inherited;
  if FChanging or FInit then
    Exit;
  FNoZERO := TRUE;
  txtQuantity.Tag := (txtQuantity.Text <> '0').ToInteger;
  UpdateCtrls;
end;

procedure TfrmODChangeUnreleasedRenew.txtQuantityClick(Sender: TObject);
begin
  inherited;
  Self.txtQuantity.SelectAll;
end;

procedure TfrmODChangeUnreleasedRenew.txtRefillsChange(Sender: TObject);
begin
  inherited;
  if FChanging then
    Exit;
  FNoZERO := TRUE;
  // if value = 0, change probably caused by the spin button
  txtRefills.Tag := (spnRefills.Position <> 0).ToInteger;
  UpdateCtrls;
end;

procedure TfrmODChangeUnreleasedRenew.txtRefillsClick(Sender: TObject);
begin
  inherited;
  Self.txtRefills.SelectAll;
end;

procedure TfrmODChangeUnreleasedRenew.UpdateData;
var
  x: string;

  procedure Update2(APromptID: string; Value: integer);
  begin
    x := IntToStr(Value);
    ResponsesAdapter.Update(APromptID, 1, x, x);
  end;

begin
  if FChanging then exit;
  Update2('SUPPLY',  spnSupply.Position);
  x := FloatToStr(StrToFloatDef(txtQuantity.Text, 0.0));
  ResponsesAdapter.Update('QTY', 1, x, x);
  Update2('REFILLS', spnRefills.Position);
  ResponsesAdapter.Update('PICKUP', 1, cboPickup.ItemID, cboPickup.Text);
end;

procedure TfrmODChangeUnreleasedRenew.UpdateCtrls;
begin
  if FChanging or ((not showing) and (not FActLikeQuickOrder)) then exit;
  UpdateData;
  FChanging := True;
  try
    CheckChanges(FResponses, FActLikeQuickOrder, Patient.Inpatient, FComplex, FActLikeQuickOrder, IsClozapineOrder,
            FEvent, FDrugName, False, FNoZERO, FChanging, FUpdated,
            FLastUnits, FLastSchedule, FLastDuration, FLastInstruct, FLastDispDrug,
            FLastTitration, FLastQuantity, FLastSupply, txtQuantity, txtSupply, txtRefills,
            spnSupply, spnQuantity, spnRefills, nil, nil);
  finally
    FChanging := False;
  end;
end;

procedure TfrmODChangeUnreleasedRenew.txtSupplyChange(Sender: TObject);
begin
  inherited;
  if FChanging or FInit then
    Exit;
  FNoZERO := TRUE;
  // if value = 0, change probably caused by the spin button
  txtSupply.Tag := (spnSupply.Position <> 0).ToInteger;
  UpdateCtrls;
end;

procedure TfrmODChangeUnreleasedRenew.txtSupplyClick(Sender: TObject);
begin
  inherited;
  Self.txtSupply.SelectAll;
end;

procedure TfrmODChangeUnreleasedRenew.btnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmODChangeUnreleasedRenew.btnOKClick(Sender: TObject);
var
  x, ErrMsg: string;

begin
  inherited;
  if panel2.Visible then
  begin
    if not IsValid then
      exit;
  end
  else if panel3.Visible then
  begin
    ErrMsg := '';
    txtStart.Validate(x);
    if Length(x) > 0   then ErrMsg := ErrMsg + TX_BAD_START + CRLF;
    with txtStop do
    begin
      Validate(x);
      if Length(x) > 0 then ErrMsg := ErrMsg + TX_BAD_STOP + CRLF;
      if (Length(Text) > 0) and (FMDateTime <= txtStart.FMDateTime)
                       then ErrMsg := ErrMsg + TX_STOPSTART;
    end;
    if Length(ErrMsg) > 0 then
    begin
      InfoBox(ErrMsg, TC_INVALID_DATE, MB_OK);
      Exit;
    end;
  end;
  OKPressed := True;
  Close;
end;

end.
