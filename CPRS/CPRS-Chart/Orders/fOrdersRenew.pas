unit fOrdersRenew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ComCtrls, uConst, rODMeds, uOrders, fOCAccept,
  ExtCtrls, uODBase, ORCtrls, VA508AccessibilityManager;

type
  TfrmRenewOrders = class(TfrmAutoSz)
    hdrOrders: THeaderControl;
    pnlBottom: TPanel;
    cmdCancel: TButton;
    cmdOK: TButton;
    cmdChange: TButton;
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
  private
    OKPressed: Boolean;
    OrderList: TList;
    function MeasureColumnHeight(TheOrderText: string; Index: Integer; Column: integer):integer;
    function AcceptOrderCheckOnRenew(const AnOrderID: string; var OCList: TStringList): boolean;
  end;

function ExecuteRenewOrders(var SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, fDateRange, fRenewOutMed, uCore, rCore, rMisc, UBAGlobals, 
  VA2006Utils;

const
  TEXT_COLUMN = 0;
  DATE_COLUMN = 1;
  WORD_WRAPPED = True;

  TC_START_STOP = 'Change Start/Stop Dates';
  TX_START_STOP = 'Enter the start and stop times for this order.  Stop time is optional.';
  TX_LBL_START  = 'Start Date/Time';
  TX_LBL_STOP   = 'Stop Date/Time';
  TX_NO_DEA     = 'Provider must have a DEA# or VA# to review this order';
  TC_NO_DEA     = 'DEA# Required';
  TC_ORDERCHECKS = 'Order Checks';

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
  TC_IMO_ERROR  = 'Inpatient medication order on outpatient authorization required';
var
  frmRenewOrders: TfrmRenewOrders;
  RenewFields: TOrderRenewFields;
  AnOrder, TheOrder: TOrder;
  OriginalID, RNFillerID,x: string;
  OrderableItemIen: integer;
  TreatAsIMOOrder, IsAnIMOOrder: boolean;
  PassDeaList: TList;
  IsInpt: boolean;
  i,j: Integer;
  //m: integer; //BAPHII 1.3.2
  PkgInfo:string;
  PlainText,RnErrMsg: string;
  TD: TFMDateTime;
  OrchkList: TStringList;

  function OrderForInpatient: Boolean;
  begin
    Result := Patient.Inpatient;
  end;
begin
  Result := False;
  IsAnIMOOrder := False;
  RnErrMsg := '';

  if SelectedList.Count = 0 then Exit;

  PassDeaList := TList.Create;
  OrchkList := TStringList.Create;
  frmRenewOrders := TfrmRenewOrders.Create(Application);

  try
    frmRenewOrders.OrderList := SelectedList;
    IsInpt := OrderForInpatient;

    with frmRenewOrders.OrderList do
    for j := 0 to Count - 1 do
       begin
         TheOrder := TOrder(Items[j]);
         PkgInfo := GetPackageByOrderID(TheOrder.ID);

         if Pos('PS',PkgInfo)=1 then
            begin
              OrderableItemIen := GetOrderableIen(TheOrder.ID);
              
              if DEACheckFailed(OrderableItemIen, IsInPt) then
                 begin
                   InfoBox(TX_NO_DEA + #13 + TheOrder.Text, TC_NO_DEA, MB_OK);
                   UnlockOrder(TheOrder.ID);
                 end
              else PassDeaList.Add(frmRenewOrders.OrderList.Items[j]);
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
         LoadRenewFields(RenewFields, AnOrder.ID);
         RenewFields.NewText := AnOrder.Text + PickupText(RenewFields.Pickup);
         AnOrder.LinkObject := RenewFields;
         PlainText := '';

         if RenewFields.NewText <> '' then
           PlainText := PlainText + frmRenewOrders.hdrOrders.Sections[TEXT_COLUMN].Text + ': ' + RenewFields.NewText + CRLF;

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
         with frmRenewOrders.OrderList do
           for i := Count - 1 downto 0 do
            begin
              OrchkList.Clear;
              AnOrder := TOrder(Items[i]);
              OriginalID := AnOrder.ID;

              //BAPHII 1.3.2 - Pick up source-order ID here
             UBAGlobals.SourceOrderID := OriginalID; //BAPHII 1.3.2
             UBAGlobals.CopyTreatmentFactorsDxsToRenewedOrder; //BAPHII 1.3.2

              if CheckOrderGroup(OriginalID) = 1 then
                RNFillerID := 'PSI'
              else if CheckOrderGroup(OriginalID) = 2 then
                RNFillerID := 'PSO';

              if AddFillerAppID(RNFillerID) and OrderChecksEnabled then
                 begin
                   StatusText('Order Checking...');
                   x := OrderChecksOnDisplay(RNFillerID);
                   StatusText('');
                   if Length(x) > 0 then InfoBox(x, TC_ORDERCHECKS, MB_OK);
                 end;

              TreatAsIMOOrder := False;

              if not frmRenewOrders.AcceptOrderCheckOnRenew(AnOrder.ID,OrchkList) then
              begin
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
         RenewFields := TOrderRenewFields(AnOrder.LinkObject);
         RenewFields.Free;
         AnOrder.LinkObject := nil;
       end;
    frmRenewOrders.Release;
  end;
end;

procedure TfrmRenewOrders.FormCreate(Sender: TObject);
begin
  inherited;
  FixHeaderControlDelphi2006Bug(hdrOrders);
  OKPressed := False;
  hdrOrders.Sections[0].Width := Round(self.width * 0.75);
  hdrOrders.Sections[1].Width := Round(self.width * 0.25);
  ResizeFormToFont(Self);
  SetFormPosition(Self);
end;

procedure TfrmRenewOrders.FormResize(Sender: TObject);
var
i: integer;
Height: integer;
begin
  inherited;
  if lstorders.Count = 0 then exit;
  for I := 0 to lstOrders.Count - 1 do
    begin
       Height := lstOrders.ItemRect(i).Bottom - lstOrders.ItemRect(i).Top;
       lstOrdersMeasureItem(lstOrders,i,Height);
       //ListGridDrawCell(lstOrders, hdrOrders, i, TEXT_COLUMN, x, WORD_WRAPPED);
    end;
end;

procedure TfrmRenewOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
  x, tmp: string;
  DateHeight, TextHeight: Integer;
  AnOrder: TOrder;
  RenewFields: TOrderRenewFields;
begin
  inherited;
      AnOrder := TOrder(OrderList.Items[Index]);
      if (AnOrder <> nil) then
        begin
          RenewFields := TOrderRenewFields(AnOrder.LinkObject);
          with RenewFields do x := 'Start: ' + StartTime + CRLF + 'Stop: ' + StopTime;
          //tmp := RenewFields.NewText;
          tmp := LstOrders.Items.Strings[index];
          TextHeight := MeasureColumnHeight(tmp,Index,TEXT_COLUMN);
          DateHeight := MeasureColumnHeight(x, Index, DATE_COLUMN);
          Height := HigherOf(TextHeight, DateHeight);
          if Height > 255 then Height := 255;  //This is maximum allowed by a windows listbox item.
        end
end;

procedure TfrmRenewOrders.lstOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  AnOrder: TOrder;
  RenewFields: TOrderRenewFields;
begin
  inherited;
  AnOrder := TOrder(lstOrders.Items.Objects[Index]);
  if AnOrder <> nil then with AnOrder do
  begin
    RenewFields := TOrderRenewFields(AnOrder.LinkObject);
    if RenewFields.BaseType = OD_TEXTONLY
      then with RenewFields do x := 'Start: ' + StartTime + CRLF + 'Stop: ' + StopTime
      else x := '';
    ListGridDrawLines(lstOrders, hdrOrders, Index, State);
    ListGridDrawCell(lstOrders, hdrOrders, Index, TEXT_COLUMN, RenewFields.NewText, WORD_WRAPPED);
    ListGridDrawCell(lstOrders, hdrOrders, Index, DATE_COLUMN, x, WORD_WRAPPED);
  end;
end;

procedure TfrmRenewOrders.lstOrdersClick(Sender: TObject);
var
  RenewFields: TOrderRenewFields;
begin
  inherited;
  with lstOrders do
  begin
    if ItemIndex < 0 then Exit;
    RenewFields := TOrderRenewFields(TOrder(Items.Objects[ItemIndex]).LinkObject);
    case RenewFields.BaseType of
    OD_MEDOUTPT: cmdChange.Caption := 'Change Refills/Pick Up...';
    OD_TEXTONLY: cmdChange.Caption := 'Change Start/Stop...';
    else         cmdChange.Caption := 'Change...';
    end;
    with RenewFields do if (BaseType = OD_MEDOUTPT) or (BaseType = OD_TEXTONLY)
      then cmdChange.Enabled := True
      else cmdChange.Enabled := False;
  end;
end;

procedure TfrmRenewOrders.cmdChangeClick(Sender: TObject);
var
  StartPos: Integer;
  x, NewComment, OldComment, OldRefills, OldPickup: string;
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
                   OldRefills := IntToStr(Refills) + ' refills';
                   { reverse string to make sure getting last matching comment }
                   OldComment := UpperCase(ReverseStr(Comments));
                   OldPickup  := PickupText(Pickup);
                   ExecuteRenewOutMed(Refills, Comments, Pickup, AnOrder);
                   NewComment := UpperCase(ReverseStr(Comments));
                   x := ReverseStr(NewText);
                   StartPos := Pos(OldComment, UpperCase(x));
                   if StartPos > 0
                     then x := Copy(x, 1, StartPos - 1) + NewComment +
                               Copy(x, StartPos + Length(OldComment), Length(x))
                     else x := NewComment + x;
                   NewText := ReverseStr(x);
                   x := NewText;
                   StartPos := Pos(OldRefills, x);
                   if StartPos > 0
                     then x := Copy(x, 1, StartPos - 1) + IntToStr(Refills) + ' refills' +
                               Copy(x, StartPos + Length(OldRefills), Length(x))
                     else x := x + ' ' + IntToStr(Refills) + ' refills';
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
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmRenewOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

function TfrmRenewOrders.MeasureColumnHeight(TheOrderText: string; Index,
  Column: integer): integer;
var
  ARect: TRect;
  cnt: integer;
  x: string;
begin
  cnt := 0;
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := hdrOrders.Sections[Column].Width -6;
  Result := WrappedTextHeightByFont(lstOrders.Canvas,lstOrders.Font,TheOrderText,ARect);
  //AGP 28.0 this fix address the issue of WrappedTextHeightByFont appearing to not take in account CRLF
  if Pos(CRLF, TheOrderText) > 0 then
    begin
      repeat
        x := Copy(TheOrderText, 1, Pos(CRLF, TheOrderText) - 1);
        if Length(x) = 0 then x := TheOrderText;
        Delete(TheOrderText, 1, Length(x) + 2);  {delete text + CRLF}
        cnt := cnt + 1;
      until TheOrderText = '';
      if cnt > 0 then Result := Result + (cnt * Abs(self.Font.Height));
      if Result > 255 then Result := 255;
    end;
  
end;

function TfrmRenewOrders.AcceptOrderCheckOnRenew(const AnOrderID: string;
  var OCList: TStringList): boolean;
var
  OIInfo,FillerID: string;
  AnOIList: TStringList;
  subI: integer;
begin
  AnOIList := TStringList.Create;
  OIInfo := DataForOrderCheck(AnOrderID);
  FillerID := Piece(OIInfo,'^',2);
  subI := 1;
  while Length(Piece(OIInfo,'|',subI))>1 do
  begin
    AnOIList.Add(Piece(OIInfo,'|',subI));
    subI := subI + 1;
  end;
  OrderChecksOnAccept(OCList, FillerID, '', AnOIList, AnOrderID,'1');
  Result :=  AcceptOrderWithChecks(OCList);
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
  lstOrders.Repaint; //CQ6367
end;


end.
