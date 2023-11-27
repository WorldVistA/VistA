unit fRenewOutMed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, Mask, ORCtrls, ExtCtrls, fBase508Form,
  VA508AccessibilityManager, VA508AccessibilityRouter, rODBase, rODMeds;

type
  TfrmRenewOutMed = class(TfrmBase508Form)
    memOrder: TCaptionMemo;
    pnlButtons: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlMiddle: TPanel;
    cboPickup: TORComboBox;
    lblPickup: TLabel;
    txtRefills: TCaptionEdit;
    lblRefills: TLabel;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    txtSupply: TCaptionEdit;
    lblDays: TLabel;
    lblQuantity: TLabel;
    spnQuantity: TUpDown;
    spnSupply: TUpDown;
    txtQuantity: TCaptionEdit;
    spnRefills: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure VA508ComponentAccessibility1StateQuery(Sender: TObject;
      var Text: string);
    procedure FormShow(Sender: TObject);
    procedure txtSupplyChange(Sender: TObject);
    procedure txtQuantityChange(Sender: TObject);
    procedure txtRefillsChange(Sender: TObject);
    procedure txtSupplyClick(Sender: TObject);
    procedure txtQuantityClick(Sender: TObject);
    procedure txtRefillsClick(Sender: TObject);
  private
    OKPressed: Boolean;
    FChanging: Boolean;
    FResponses: TList;
    FLastUnits, FLastSchedule, FLastDuration, FLastInstruct, FLastDispDrug: string;
    FLastQuantity: Double;
    FLastSupply: Integer;
    FLastTitration: boolean;
    FNoZERO: Boolean;
    FUpdated: Boolean;
    FDrugName: string;
    FComplex: boolean;
    FClozapine: boolean;
    FInit: boolean;
    FEventName: string;
    FActLikeQuickOrder: boolean;
    FUpdateQuantity: string;
    procedure UpdateData;
    procedure UpdateCtrls;
    function IsValid: boolean;
  end;

function ExecuteRenewOutMed(AnOrder: TOrder; DestList: TList): Boolean;

implementation

uses uPaPI, uOrders, uCore, VAUtils;

{$R *.DFM}

const
  TX_NO_RENEW     = 'Cannot renew this order for the following reason';
  TX_NO_RENEW_END = ':' + CRLF + CRLF;
  TX_NO_RENEW_CAP = 'Unable to Renew Order';

function ExecuteRenewOutMed(AnOrder: TOrder; DestList: TList): Boolean;
var
  frmRenewOutMed: TfrmRenewOutMed;
//  HasObject: Boolean;
  i, doseCount: Integer;
  EDrug, Days, Qty, QtyTxt: string;
  RenewFields: TOrderRenewFields;

begin
  RenewFields := TOrderRenewFields(AnOrder.LinkObject);
  Result := False;
  EDrug:= '';
  with RenewFields do
  begin
    Days := IntToStr(DaysSupply);
    Qty := Quantity;
    //Moved to fOrdersRenew
    //LoadResponses(DestList, 'X' + AnOrder.ID, HasObject, (TitrationMsg <> ''));
    doseCount := 0;

    for I := 0 to DestList.Count - 1 do
    begin
      with TResponse(DestList.Items[i]) do
      begin
        if PromptID = 'DRUG' then
          EDrug := EValue
        else if PromptID = 'DOSE' then
          inc(doseCount);
      end;
    end;
    frmRenewOutMed := TfrmRenewOutMed.Create(Application);
    try
      with frmRenewOutMed do
      begin
        FActLikeQuickOrder := True;
        FEventName := AnOrder.EventName;
        FDrugName := EDrug;
        FClozapine := (Pos(EDrug, 'CLOZAPINE') > 0);
        FComplex := (doseCount > 1);
        FResponses := DestList;
        if papiParkingAvailable and papiOrderIsParkable(anOrder.ID) then
          cboPickup.Items.Add('P^Park'); // PaPI.
        ResizeFormToFont(TForm(frmRenewOutMed));
//          memOrder.SetTextBuf(PChar(AnOrder.Text)); // may contain titration msg
        memOrder.SetTextBuf(PChar(NewText));
        spnRefills.Position := Refills;
        if DispUnit = '' then
          QtyTxt := 'Quantity'
        else
        begin
          QtyTxt :='Qty (' + DispUnit + ')';
          if Length(QtyTxt) > 10 then
          begin
            lblQuantity.Hint := QtyTxt;
            QtyTxt := Copy(QtyTxt, 1, 7) + '...';
          end;
        end;
        FChanging := TRUE;
        try
          lblQuantity.Caption := QtyTxt;
          spnSupply.Position := StrToIntDef(Days, 0);
          FUpdateQuantity := Qty;
          txtQuantity.Text := Qty;
          cboPickup.SelectByID(Pickup);
        finally
          FChanging := False;
        end;
        ShowModal;
        if OKPressed then
        begin
          Result := True;
          Refills := StrToIntDef(txtRefills.Text, Refills);
          Pickup := cboPickup.ItemID;
          DaysSupply := StrToIntDef(txtSupply.Text, DaysSupply);
          Quantity := txtQuantity.Text;
// Keep TitrationMsg or the second time around it will load the complex order
//            TitrationMsg := '';
        end;
      end;
    finally
      frmRenewOutMed.Release;
    end;
  end;
end;

procedure TfrmRenewOutMed.FormCreate(Sender: TObject);
begin
  inherited;
  FInit := True;
  OKPressed := False;
  with cboPickup.Items do
  begin
    Add('W^at Window');
    Add('M^by Mail');
  end;
  FLastUnits := '';
  FLastSchedule := '';
  FLastDuration := '';
  FLastInstruct := '';
  FLastDispDrug := '';
  FLastQuantity := 0;
  FLastSupply := 0;
  FLastTitration := False;
  FNoZERO := False;
  FUpdated := False;
  FDrugName := '';
  txtRefills.Tag := 0;
  txtSupply.Tag := 0;
  txtQuantity.Tag := 0;
end;

procedure TfrmRenewOutMed.FormShow(Sender: TObject);
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

procedure TfrmRenewOutMed.txtQuantityChange(Sender: TObject);
begin
  inherited;
  if FChanging or FInit then
    Exit;
  FNoZERO := TRUE;
  txtQuantity.Tag := (txtQuantity.Text <> '0').ToInteger;
  UpdateCtrls;
end;

procedure TfrmRenewOutMed.txtQuantityClick(Sender: TObject);
begin
  inherited;
  Self.txtQuantity.SelectAll;
end;

procedure TfrmRenewOutMed.txtRefillsChange(Sender: TObject);
begin
  inherited;
  if FChanging or FInit then
    Exit;
  FNoZERO := TRUE;
  // if value = 0, change probably caused by the spin button
  txtRefills.Tag := (txtRefills.Text <> '0').ToInteger;
  UpdateCtrls;
end;

procedure TfrmRenewOutMed.txtRefillsClick(Sender: TObject);
begin
  inherited;
  Self.txtRefills.SelectAll;
end;

procedure TfrmRenewOutMed.txtSupplyChange(Sender: TObject);
begin
  inherited;
  if FChanging or (not Showing) or FInit then
    Exit;
  FNoZERO := TRUE;
  txtSupply.Tag := (txtSupply.Text <> '0').ToInteger;
  UpdateCtrls;
end;

procedure TfrmRenewOutMed.txtSupplyClick(Sender: TObject);
begin
  inherited;
  Self.txtSupply.SelectAll;
end;

procedure TfrmRenewOutMed.UpdateData;

  procedure Update2(APromptID: string; ctrl: TWinControl);
  var
    x: string;

  begin
    if ctrl is TUpDown then
      x := IntToStr(TUpDown(ctrl).Position)
    else if ctrl is TEdit then
      x := TEdit(ctrl).Text
    else
      exit;
    ResponsesAdapter.Update(APromptID, 1, x, x);
  end;

begin
  if FChanging then exit;
  FUpdated := FALSE;
  ResponsesAdapter.Assign(FResponses);
  Update2('SUPPLY',  spnSupply);
  Update2('QTY',     txtQuantity);
  Update2('REFILLS', spnRefills);
  ResponsesAdapter.Update('PICKUP', 1, cboPickup.ItemID, cboPickup.Text);
end;

procedure TfrmRenewOutMed.UpdateCtrls;
begin
  if FChanging or ((not showing) and (not FActLikeQuickOrder)) then exit;
  UpdateData;
  FChanging := True;
  try
    CheckChanges(FResponses, FActLikeQuickOrder, Patient.Inpatient, FComplex, FActLikeQuickOrder, FClozapine,
            #0, FDrugName, False, FNoZERO, FChanging, FUpdated,
            FLastUnits, FLastSchedule, FLastDuration, FLastInstruct, FLastDispDrug,
            FLastTitration, FLastQuantity, FLastSupply, txtQuantity, txtSupply, txtRefills,
            spnSupply, spnQuantity, spnRefills, nil, nil);
  finally
    FChanging := False;
  end;
  if FUpdated then
    UpdateData;
end;

procedure TfrmRenewOutMed.VA508ComponentAccessibility1StateQuery(
  Sender: TObject; var Text: string);
begin
  inherited;
  Text := memOrder.Text;
end;

function TfrmRenewOutMed.IsValid: boolean;
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
  ResponsesAdapter.Assign(FResponses);
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
                    FEventName = 'D', Titration);
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

procedure TfrmRenewOutMed.cmdOKClick(Sender: TObject);
begin
  if IsValid then
  begin
    OKPressed := True;
    Close;
  end;
end;

procedure TfrmRenewOutMed.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
