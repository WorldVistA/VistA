unit fOrdersRenew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ComCtrls, uConst, rODMeds, uOrders, fOCAccept,
  ExtCtrls, uODBase, ORCtrls, VA508AccessibilityManager, rOrders;

type
  TfrmRenewOrders = class(TfrmAutoSz)
    hdrOrders: THeaderControl;
    cmdCancel: TButton;
    cmdOK: TButton;
    cmdChange: TButton;
    pnlBottom: TPanel;
    lstOrders: TCaptionListBox;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstOrdersClick(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure hdrOrdersSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    OKPressed: Boolean;
    OrderList: TList;
    fCallBackOrder: TOrder;
    fCallBackList: tStringList;
    fResponses: TList;
    procedure RedrawList;
    procedure GetGridText(RenewFields: TOrderRenewFields; var col1, col2: string);
    function MeasureColumnHeight(TheOrderText: string; Index: Integer; Column: integer):integer;
    function AcceptOrderCheckOnRenew(const AnOrder: TOrder; var OCList: TStringList): boolean;
    procedure BuildOrderChecks(var aReturnList: TStringList);
    function OverrideFunction(aReturnList: tStringList; aOverrideType: String;
      aOverrideReason: String = ''; aOverrideComment: String = ''): Boolean;
    function GetMedResponseList(Index: Integer): TList;
  end;

function ExecuteRenewOrders(var SelectedList: TList): Boolean;
function ShouldCancelRenewOrder: boolean; //rtw

implementation

{$R *.DFM}

uses fDateRange, fRenewOutMed, uCore, rCore, rMisc, UBAGlobals, VA2006Utils, fFrame,
  rODBase, uInfoBoxWithBtnControls;
var //rtw
  RenewOrderCancel : boolean; //rtw

const
  TEXT_COLUMN = 0;
  DATE_COLUMN = 1;
  WORD_WRAPPED = True;

  TC_START_STOP = 'Change Start/Stop Dates';
  TX_START_STOP = 'Enter the start and stop times for this order.  Stop time is optional.';
  TX_LBL_START  = 'Start Date/Time';
  TX_LBL_STOP   = 'Stop Date/Time';
  TX_DEAFAIL1   = 'Order for controlled substance,' + CRLF;
  TX_DEAFAIL2   = CRLF + 'could not be renewed. Provider does not have a' + CRLF +
                  'current, valid DEA# on record and is ineligible' + CRLF + 'to sign the order.';
  TX_SCHFAIL    = CRLF + 'could not be renewed. Provider is not authorized' + CRLF +
                  'to prescribe medications in Federal Schedule ';
  TX_SCH_ONE    = CRLF + 'could not be renewed. Electronic prescription of medications in' + CRLF +
                  'Federal Schedule 1 is prohibited.' + CRLF + CRLF +
                  'Valid Schedule 1 investigational medications require paper prescription.';
  TX_NO_DETOX   = CRLF + 'could not be renewed. Provider does not have a' + CRLF +
                  'valid Detoxification/Maintenance ID number on' + CRLF +
                  'record and is ineligible to sign the order.';
  TX_EXP_DETOX1 = CRLF + 'could not be renewed. Provider''s Detoxification/Maintenance' + CRLF +
                  'ID number expired due to an expired DEA# on ';
  TX_EXP_DETOX2 = '.' + CRLF + 'Provider is ineligible to sign the order.';
  TX_EXP_DEA1   = CRLF + 'could not be renewed. Provider''s DEA# expired on ';
  TX_EXP_DEA2   = CRLF + 'and no VA# is assigned. Provider is ineligible to sign the order.';
  TX_INSTRUCT   = CRLF + CRLF + 'Click RETRY to select another provider.' + CRLF + 'Click CANCEL to cancel the current renewal.';
  TC_DEAFAIL    = 'Order not renewed';
  TC_ORDERCHECKS = 'Order Checks';
  TX_QTY_NV     = 'Unable to validate quantity on ';
  TX_QTY_NV_1   = 'selected order.';
  TX_QTY_NV_2   = 'some of these orders.';
  TX_NO_SAVE_CAP = 'Unable to Renew Order';

function ShouldCancelRenewOrder: boolean; //rtw
 begin
  result := RenewOrderCancel;
 end; //rtw

function PickupText(const x: string): string;
begin
  case CharAt(x, 1) of
  'C': Result := ' (administered in Clinic)';
  'M': Result := ' (deliver by Mail)';
  'W': Result := ' (pick up at Window)';
  else Result := '';
  end;
end;

function ExecuteRenewOrders(var SelectedList: TList): Boolean;
const
  TC_IMO_ERROR  = 'Unable to order';
//  'Inpatient medication order on outpatient authorization required';
var
  frmRenewOrders: TfrmRenewOrders;
  RenewFields: TOrderRenewFields;
  AnOrder, TheOrder: TOrder;
  OriginalID, RNFillerID,x: string;
  OrderableItemIen, temp: integer;
  TreatAsIMOOrder, IsAnIMOOrder: boolean;
  PassDeaList: TList;
  InptDlg: boolean;
  i,j: Integer;
  //m: integer; //BAPHII 1.3.2
  PkgInfo:string;
  PlainText,RnErrMsg: string;
  TD: TFMDateTime;
  OrchkList: TStringList;
  DEAFailStr, TX_INFO: string;

  function OrderForInpatient: Boolean;
  begin
    Result := Patient.Inpatient;
  end;

begin
  Result := False;
  IsAnIMOOrder := False;
  RnErrMsg := '';
  InptDlg := False;
  RenewOrderCancel := True;  //rtw
  if SelectedList.Count = 0 then Exit;

  PassDeaList := TList.Create;
  OrchkList := TStringList.Create;
  frmRenewOrders := TfrmRenewOrders.Create(Application);

  try
    frmRenewOrders.OrderList := SelectedList;
    //IsInpt := OrderForInpatient;

    with frmRenewOrders.OrderList do
    for j := 0 to Count - 1 do
       begin
         TheOrder := TOrder(Items[j]);
         PkgInfo := TheOrder.GetPackage; //GetPackageByOrderID(TheOrder.ID);

         if Pos('PS',PkgInfo)=1 then
            begin
              if PkgInfo = 'PSO' then InptDlg := False
              else if PkgInfo = 'PSJ' then InptDlg := True;
              OrderableItemIen := GetOrderableIen(TheOrder.ID);
              DEAFailStr := '';
              DEAFailStr := DEACheckFailed(OrderableItemIen, InptDlg);
              while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
                 begin
                   case StrToIntDef(Piece(DEAFailStr,U,1),0) of
                     1:  TX_INFO := TX_DEAFAIL1 + #13 + TheOrder.Text + #13 + TX_DEAFAIL2;  //prescriber has an invalid or no DEA#
                     2:  TX_INFO := TX_DEAFAIL1 + #13 + TheOrder.Text + #13 + TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                     3:  TX_INFO := TX_DEAFAIL1 + #13 + TheOrder.Text + #13 + TX_NO_DETOX;  //prescriber has an invalid or no Detox#
                     4:  TX_INFO := TX_DEAFAIL1 + #13 + TheOrder.Text + #13 + TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
                     5:  TX_INFO := TX_DEAFAIL1 + #13 + TheOrder.Text + #13 + TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
                     6:  TX_INFO := TX_DEAFAIL1 + #13 + TheOrder.Text + #13 + TX_SCH_ONE;   //schedule 1's are prohibited from electronic prescription
                   end;
                   if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
                   begin
                     InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                     UnlockOrder(TheOrder.ID);
                     Exit;
                   end;
                   if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
                   begin
                     DEAContext := True;
                     fFrame.frmFrame.mnuFileEncounterClick(frmRenewOrders);
                     DEAFailStr := '';
                     DEAFailStr := DEACheckFailed(OrderableItemIen, InptDlg);
                   end
                   else begin
                     UnlockOrder(TheOrder.ID);
                     Exit;
                   end;
                 end;
              PassDeaList.Add(frmRenewOrders.OrderList.Items[j]);
            end
         else
           PassDeaList.Add(frmRenewOrders.OrderList.Items[j]);
       end;

    frmRenewOrders.OrderList.Clear;
    frmRenewOrders.OrderList := PassDeaList;

    for i := frmRenewOrders.OrderList.Count - 1 downto 0 do
       begin
         AnOrder := TOrder(frmRenewOrders.OrderList.Items[i]);
         if not IMOActionValidation('RENEW^'+ AnOrder.ID,IsAnIMOOrder,RnErrMsg,'C') then
            begin
              frmRenewOrders.OrderList.Delete(i);
              ShowMsgOn(Length(RnErrMsg) > 0, RnErrMsg, TC_IMO_ERROR);
            end;
         RnErrMsg := '';
       end;

    with frmRenewOrders.OrderList do
     for i := 0 to Count - 1 do
       begin
         AnOrder := TOrder(Items[i]);
         RenewFields := TOrderRenewFields.Create;
         // PaPI. Passing Location ID
         if Assigned(Encounter) then
           LoadRenewFields(RenewFields, AnOrder.ID+';'+IntToStr(Encounter.Location))
         else
           LoadRenewFields(RenewFields, AnOrder.ID);
         if RenewFields.NewText = '' then
            RenewFields.NewText := AnOrder.Text;
         RenewFields.NewText := RenewFields.NewText + PickupText(RenewFields.Pickup);
         AnOrder.LinkObject := RenewFields;
         PlainText := '';

         if RenewFields.NewText <> '' then
           PlainText := PlainText + frmRenewOrders.hdrOrders.Sections[TEXT_COLUMN].Text +
                             ': ' + RenewFields.NewText + CRLF + RenewFields.TitrationMsg;

         if RenewFields.BaseType = OD_TEXTONLY then
           with RenewFields do
             PlainText := PlainText + 'Start: ' + StartTime + CRLF + 'Stop: ' + StopTime;

         frmRenewOrders.lstOrders.Items.AddObject(PlainText, AnOrder);
       end;
    if frmRenewOrders.OrderList.Count < 1 then
      frmRenewOrders.Close
    else
      frmRenewOrders.ShowModal;

    if frmRenewOrders.OKPressed then
       begin
         RenewOrderCancel := FALSE;    //rtw
         with frmRenewOrders.OrderList do
           for i := Count - 1 downto 0 do
            begin
              OrchkList.Clear;
              AnOrder := TOrder(Items[i]);
              OriginalID := AnOrder.ID;

              //BAPHII 1.3.2 - Pick up source-order ID here
             UBAGlobals.SourceOrderID := OriginalID; //BAPHII 1.3.2
             UBAGlobals.CopyTreatmentFactorsDxsToRenewedOrder; //BAPHII 1.3.2

              temp := CheckOrderGroup(OriginalID);
              if temp = 1 then
                RNFillerID := 'PSI'
              else if temp = 2 then
                RNFillerID := 'PSO';

              if AddFillerAppID(RNFillerID) and OrderChecksEnabled then
                 begin
                   StatusText('Order Checking...');
                   x := OrderChecksOnDisplay(RNFillerID);
                   StatusText('');
                   if Length(x) > 0 then InfoBox(x, TC_ORDERCHECKS, MB_OK);
                 end;

              TreatAsIMOOrder := False;

              if not frmRenewOrders.AcceptOrderCheckOnRenew(AnOrder, OrchkList) then
              begin
                FreeAndNil(TOrder(frmRenewOrders.OrderList[i]).LinkObject);
                frmRenewOrders.OrderList.Delete(i);
                Continue;
              end;

              if IsIMOOrder(OriginalID) then               //IMO
                 begin
                   TD := FMToday;
                   if IsValidIMOLoc(Encounter.Location, Patient.DFN) and (Encounter.DateTime > TD) then
                     TreatAsIMOOrder := True;
                   if Patient.Inpatient then TreatAsIMOOrder := True;
                 end;

              RenewFields := TOrderRenewFields(AnOrder.LinkObject);

              //PSI-COMPLEX Start
              if IsComplexOrder(OriginalID) then
                 begin
                   if TreatAsIMOOrder then
                     RenewOrder(AnOrder, RenewFields,1,Encounter.DateTime,OrchkList)
                   else
                     RenewOrder(AnOrder, RenewFields,1,0,OrchkList);

                   AnOrder.ActionOn := OriginalID + '=RN';
                   SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_CPLXRN, Integer(AnOrder));
                 end
              //PSI-COMPLEX End
              else
                 begin
                   if TreatAsIMOOrder then
                     RenewOrder(AnOrder, RenewFields,0,Encounter.DateTime,OrchkList)
                   else
                     RenewOrder(AnOrder, RenewFields,0,0,OrchkList);

                   AnOrder.ActionOn := OriginalID + '=RN';
                   SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(AnOrder));
                 end;
            end;

         Result := True;

       end

    else
     with frmRenewOrders.OrderList do
        for i := 0 to Count - 1 do
           UnlockOrder(TOrder(Items[i]).ID);
  finally
    // free all the TOrderRenewFields that were created
    SelectedList := frmRenewOrders.OrderList;

    with frmRenewOrders.OrderList do for i := 0 to Count - 1 do
       begin
         AnOrder := TOrder(Items[i]);
         FreeAndNil(AnOrder.LinkObject);
       end;
    ClearAllergyOrderCheckCache;
    frmRenewOrders.Release;
  end;
end;

procedure TfrmRenewOrders.FormCreate(Sender: TObject);
begin
  inherited;
  FixHeaderControlDelphi2006Bug(hdrOrders);
  OKPressed := False;
  ResizeFormToFont(Self);
  SetFormPosition(Self);
  uAllergiesChanged := False;
  fResponses := TList.Create;
end;

procedure TfrmRenewOrders.FormDestroy(Sender: TObject);
var
  AList, BList: TList;
begin
  AList := fResponses;
  fResponses := nil;

  if Assigned(AList) then
  begin
    for var I := AList.Count - 1 downto 0 do
    begin
      BList := TList(AList[I]);
      KillObj(@BList, True);
    end;

    FreeAndNil(AList);
  end;

  inherited;
end;

procedure TfrmRenewOrders.FormResize(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[0].Width := Round(hdrOrders.width * 0.7);
  hdrOrders.Sections[1].Width := Round(hdrOrders.width * 0.3);
  RedrawList;
end;

procedure TfrmRenewOrders.GetGridText(RenewFields: TOrderRenewFields; var col1, col2: string);
begin
  with RenewFields do
  begin
    if BaseType = OD_TEXTONLY then
      col2 := 'Start: ' + StartTime + CRLF + 'Stop: ' + StopTime
    else col2 := '';
    col1 := NewText;
    if length(TitrationMsg)>0 then
      col1 := col1 + CRLF + TitrationMsg;
  end;
end;

function TfrmRenewOrders.GetMedResponseList(Index: Integer): TList;
var
  AnOrder: TOrder;
  HasObjects: Boolean;
  RenewFields: TOrderRenewFields;
begin
  while fResponses.Count <= Index do
    fResponses.Add(nil);
  Result := TList(fResponses[Index]);
  if Result = nil then
  begin
    AnOrder := lstOrders.Items.Objects[Index] as TOrder;
    RenewFields := AnOrder.LinkObject as TOrderRenewFields;
    Result := TList.Create;
    fResponses[Index] := Result;
    LoadResponses(Result, 'X' + AnOrder.ID, HasObjects,
      (RenewFields.TitrationMsg <> ''));
  end;
end;

procedure TfrmRenewOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
  x1,x2: string;
  NewHeight, DateHeight, TextHeight: Integer;
  AnOrder: TOrder;
  RenewFields: TOrderRenewFields;
begin
  inherited;
  AnOrder := TOrder(OrderList.Items[Index]);
  if (AnOrder <> nil) then
  begin
    RenewFields := TOrderRenewFields(AnOrder.LinkObject);
    GetGridText(RenewFields, x1, x2);
    TextHeight := MeasureColumnHeight(x1, Index, TEXT_COLUMN);
    DateHeight := MeasureColumnHeight(x2, Index, DATE_COLUMN);
    NewHeight := HigherOf(TextHeight, DateHeight);
    if NewHeight > 255 then NewHeight := 255;  //This is maximum allowed by a windows listbox item.
    Height := NewHeight;
  end;
end;

procedure TfrmRenewOrders.lstOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x1,x2: string;
  AnOrder: TOrder;
  RenewFields: TOrderRenewFields;
begin
  inherited;
  AnOrder := TOrder(lstOrders.Items.Objects[Index]);
  if AnOrder <> nil then with AnOrder do
  begin
    RenewFields := TOrderRenewFields(AnOrder.LinkObject);
    GetGridText(RenewFields, x1, x2);
    ListGridDrawLines(lstOrders, hdrOrders, Index, State);
    ListGridDrawCell(lstOrders, hdrOrders, Index, TEXT_COLUMN, x1, WORD_WRAPPED);
    ListGridDrawCell(lstOrders, hdrOrders, Index, DATE_COLUMN, x2, WORD_WRAPPED);
  end;
end;

procedure TfrmRenewOrders.lstOrdersClick(Sender: TObject);
var
  RenewFields: TOrderRenewFields;
  idx: integer;
begin
  inherited;
  with lstOrders do
  begin
    if ItemIndex < 0 then
      idx := -1
    else
    begin
      RenewFields := TOrderRenewFields(TOrder(Items.Objects[ItemIndex]).LinkObject);
      idx := RenewFields.BaseType;
    end;
    case idx of
      OD_MEDOUTPT: cmdChange.Caption := 'Change Days Supply/Quantity/Refills/Pick Up...';
      OD_TEXTONLY: cmdChange.Caption := 'Change Start/Stop...';
      else         cmdChange.Caption := 'Change...';
    end;
    cmdChange.Width := TextWidthByFont(MainFont.Handle, cmdChange.Caption) + 30;
    cmdChange.Enabled := (idx = OD_MEDOUTPT) or (idx = OD_TEXTONLY);
  end;
end;

procedure TfrmRenewOrders.cmdChangeClick(Sender: TObject);
var
  StartPos: Integer;
  x, NewComment, OldQty, OldComment, OldRefills, OldPickup: string;
  AnOrder: TOrder;
  RenewFields: TOrderRenewFields;
begin
  inherited;
  with lstOrders do
  begin
    if ItemIndex < 0 then Exit;
    AnOrder := TOrder(Items.Objects[ItemIndex]);
    RenewFields := TOrderRenewFields(AnOrder.LinkObject);
    case RenewFields.BaseType of
    OD_MEDOUTPT: with RenewFields do begin
                   OldRefills := 'Refills: ' + IntToStr(Refills);
                   { reverse string to make sure getting last matching comment }
                   OldComment := UpperCase(ReverseStr(Comments));
                   OldPickup  := PickupText(Pickup);
                   OldQty := 'Quantity: ' + Quantity;
                   if ExecuteRenewOutMed(AnOrder, GetMedResponseList(ItemIndex)) then
                     RedrawList;
                   NewComment := UpperCase(ReverseStr(Comments));
                   x := ReverseStr(NewText);
                   StartPos := Pos(OldComment, UpperCase(x));
                   if StartPos > 0
                     then x := Copy(x, 1, StartPos - 1) + NewComment +
                               Copy(x, StartPos + Length(OldComment), Length(x))
                     else x := NewComment + x;
                   NewText := ReverseStr(x);
                   x := NewText;
                   StartPos := Pos(OldQty, x);
                   if StartPos > 0
                     then x := Copy(x, 1, StartPos - 1) + 'Quantity: ' + Quantity +
                               Copy(x, StartPos + Length(OldQty), Length(x))
                     else x := x + ' Quantity: ' + Quantity;
                   StartPos := Pos(OldRefills, x);
                   if StartPos > 0
                     then x := Copy(x, 1, StartPos - 1) + 'Refills: ' + IntToStr(Refills) +
                               Copy(x, StartPos + Length(OldRefills), Length(x))
                     else x := x + ' Refills: ' + IntToStr(Refills);
                   StartPos := Pos(OldPickup, x);
                   if StartPos > 0
                     then x := Copy(x, 1, StartPos - 1) + PickupText(Pickup) +
                               Copy(x, StartPos + Length(OldPickup), Length(x))
                     else x := x + PickupText(Pickup);
                   NewText := x;
                 end;
    OD_TEXTONLY: with RenewFields do ExecuteDateRange(StartTime, StopTime, DT_FUTURE+DT_TIMEOPT,
                   TC_START_STOP, TX_START_STOP, TX_LBL_START, TX_LBL_STOP);
    end;
  end;
  lstOrders.Invalidate;
end;

procedure TfrmRenewOrders.cmdOKClick(Sender: TObject);
var
  DestList, SkippedList: TList;
  i, idx, BtnResults: integer;
  AnOrder: TOrder;
  RenewFields: TOrderRenewFields;
  Done, Cancel: Boolean;
  Buttons: TStringList;
  ErrorMessage, tempUnit, tempSch, tempDur, tempDrug: string;
  Adapter: TResponsesAdapter;

begin
  inherited;
  Adapter := TResponsesAdapter.Create;
  Buttons := TStringList.Create;
  SkippedList := TList.Create;
  try
    Buttons.Add('Edit Order');
    Buttons.Add('Don''t Renew this order');
    Buttons.Add('Cancel');
    Cancel := False;
    for i := 0 to lstOrders.Count-1 do
    begin
      AnOrder := TOrder(lstOrders.Items.Objects[i]);
      if AnOrder.DGroup = OutptDisp then
      begin
        repeat
          Done := True;
          RenewFields := TOrderRenewFields(AnOrder.LinkObject);
          with RenewFields do
          begin
            DestList := GetMedResponseList(i);
            Adapter.Assign(DestList);
            BuildResponseVarsForOutpatient(Adapter, tempUnit, tempSch, tempDur, tempDrug, True);
            ErrorMessage := '';
            UpdateSupplyQtyRefillErrorMsg(ErrorMessage, DaysSupply, Refills,
              Quantity, tempDrug, tempUnit, tempSch, tempDur, (TitrationMsg <> ''),
              StrToIntDef(Adapter.IValueFor('ORDERABLE', 1), 0), True);
            if ErrorMessage <> '' then
            begin
              ErrorMessage := AnOrder.Text + CRLF + CRLF + ErrorMessage;
              BtnResults := uInfoBoxWithBtnControls.DefMessageDlg(ErrorMessage,
                mtConfirmation, Buttons, 'Error Renewing Order', false);
              case BtnResults of
                0:
                begin
                  lstOrders.ItemIndex := i;
                  cmdChangeClick(cmdChange);
                  Done := False; // Recheck order
                end;
                1: SkippedList.Add(AnOrder);
                2: Cancel := True;
              end;
            end;
          end;
        until Done or Cancel;
        if Cancel then
          break;
      end;
    end;
    if (not Cancel) and (SkippedList.Count > 0) then
    begin
      for i := OrderList.Count-1 downto 0 do
      begin
        AnOrder := TOrder(OrderList[i]);
        if SkippedList.IndexOf(AnOrder) >= 0 then
        begin
          OrderList.Delete(i);
          FreeAndNil(AnOrder.LinkObject);
          idx := lstOrders.Items.IndexOfObject(AnOrder);
          if idx >= 0 then
            lstOrders.Items.Delete(idx);
        end;
      end;
    end;
  finally
    SkippedList.Free;
    Buttons.Free;
    Adapter.Free;
  end;

  if not Cancel then
  begin
    OKPressed := True;
    Close;
  end;
end;



procedure TfrmRenewOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  RenewOrderCancel := TRUE; //rtw
  Close;
end;

function TfrmRenewOrders.MeasureColumnHeight(TheOrderText: string; Index,
  Column: integer): integer;
var
  ARect: TRect;
begin
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := hdrOrders.Sections[Column].Width -6;
  Result := WrappedTextHeightByFont(lstOrders.Canvas,lstOrders.Font,TheOrderText,ARect);
end;

procedure TfrmRenewOrders.RedrawList;
var
  i: integer;
begin
  lstOrders.Invalidate;
  // the following code forces new calls to OnMeasureItem
  for i := 0 to lstOrders.Count-1 do
    lstOrders.Items[i] := lstOrders.Items[i];
end;

function TfrmRenewOrders.AcceptOrderCheckOnRenew(const AnOrder: TOrder;
  var OCList: TStringList): boolean;
var
  OIList: TStringList;
begin
  fCallBackOrder := AnOrder;
  fCallBackList := OCList;

  OIList := TStringList.Create;
  try
    BuildOrderChecks(OIList);
    result := AcceptOrderWithChecks(OIList, BuildOrderChecks, OverrideFunction);
  finally
    FreeAndNil(OIList);
  end;

end;

procedure TfrmRenewOrders.BuildOrderChecks(var aReturnList: TStringList);
var
  OIInfo,FillerID,x: string;
  AnOIList: TStringList;
  subI: integer;
  RenewFields: TOrderRenewFields;
begin
  if (not assigned(fCallBackList)) or (not assigned(aReturnList)) then
    exit;

  fCallBackList.Clear;

  RenewFields := TOrderRenewFields(fCallBackOrder.LinkObject);
  AnOIList := TStringList.Create;
  try
    OIInfo := DataForOrderCheck(fCallBackOrder.ID);
    FillerID := Piece(OIInfo,'^',2);
    subI := 1;
    while Length(Piece(OIInfo,'|',subI))>1 do
    begin
      AnOIList.Add(Piece(OIInfo,'|',subI));
      subI := subI + 1;
    end;
    with RenewFields do
      x := Refills.ToString + U + Pickup + U + DaysSupply.ToString + U + Quantity;
    OrderChecksOnAccept(fCallBackList, FillerID, '', AnOIList, fCallBackOrder.ID,'1',x);

    aReturnList.Assign(fCallBackList);
  finally
    FreeandNil(AnOIList);
  end;
end;

function TfrmRenewOrders.OverrideFunction(aReturnList: tStringList;
  aOverrideType: String; aOverrideReason: String = '';
  aOverrideComment: String = ''): Boolean;
begin
  // no auto accept on renewal orders so no need to allow ocAccept the ability to load override reasons.
  result := False;
end;

procedure TfrmRenewOrders.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
end;

procedure TfrmRenewOrders.hdrOrdersSectionResize(HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  RedrawList;
end;


end.
