unit fODActive;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORFn, uCore, StdCtrls, CheckLst, ComCtrls,ExtCtrls,rOrders,fOrders,uOrders,
  fFrame,ORCtrls,fAutoSz, VA508AccessibilityManager;

type
  TfrmODActive = class(TfrmAutoSz)
    lblCaption: TLabel;
    pnlClient: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    hdControl: THeaderControl;
    lstActiveOrders: TCaptionListBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstActiveOrdersMeasureItem(Control: TWinControl;
      Index: Integer; var AaHeight: Integer);
    procedure lstActiveOrdersDrawItem(Control: TWinControl;
      Index: Integer; TheeRect: TRect; State: TOwnerDrawState);
    procedure hdControlSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
  private
    { Private declarations }
    FOrderView: TOrderView;
    FEvent: TOrderDelayEvent;
    FAutoAc: boolean;
    ActiveOrderList: TList;
    FDefaultEventOrder: string;
    function MeasureColumnHeight(TheOrderText: string; Index: Integer; Column: integer):integer;
    procedure LoadActiveOrders;
    procedure RetrieveVisibleOrders(AnIndex: Integer);
    procedure RedrawActiveList;
  public
    { Public declarations }
    property Event: TOrderDelayEvent   read FEvent         write FEvent;
    property OrderView: TOrderView     read FOrderView     write FOrderView;
    property AutoAc: boolean           read FAutoAc;
  end;

procedure CopyActiveOrdersToEvent(AnOrderView: TOrderView; AnEvent: TOrderDelayEvent);

implementation

uses
  VA2006Utils, System.UITypes;

{$R *.DFM}

const
 FM_DATE_ONLY = 7;

procedure CopyActiveOrdersToEvent(AnOrderView: TOrderView; AnEvent: TOrderDelayEvent);
var
  frmODActive: TfrmODActive;
begin
  frmODActive := TfrmODActive.Create(Application);
  ResizeFormToFont(TForm(frmODActive));
  frmODActive.Event     := AnEvent;
  frmODActive.FOrderView := AnOrderView;
  frmODActive.FOrderView.Filter := 2;
  if Length(frmOrders.EventDefaultOrder)>0 then
    frmODActive.FDefaultEventOrder := frmOrders.EventDefaultOrder;
  frmODActive.lblCaption.Caption := frmODActive.lblCaption.Caption + ' Delayed ' + AnEvent.EventName + ':';
  frmODActive.LoadActiveOrders;
  if frmODActive.lstActiveOrders.Items.Count < 1 then
    frmODActive.Close
  else
    frmODActive.ShowModal;
end;

procedure TfrmODActive.btnOKClick(Sender: TObject);
const
  TX_NOSEL      = 'No orders are highlighted.  Select the orders' + CRLF +
                  'you wish to take action on.';
  TC_NOSEL      = 'No Orders Selected';
var
  i : integer;
  SelectedList: TStringList;
  TheVerify : boolean;
  DoesDestEvtOccur:boolean;
begin
  try
  self.btnOK.Enabled := false;
  DoesDestEvtOccur := False;
  uAutoAC := True;
  frmFrame.UpdatePtInfoOnRefresh;
  SelectedList := TStringList.Create;
  try
    TheVerify := False;
    with lstActiveOrders do for i := 0 to Items.Count - 1 do
      if Selected[i] then SelectedList.Add(TOrder(Items.Objects[i]).ID);
    if ShowMsgOn(SelectedList.Count = 0, TX_NOSEL, TC_NOSEL) then Exit;
    if (Event.EventType = 'D') or ((not Patient.InPatient) and (Event.EventType = 'T')) then
      TransferOrders(SelectedList, Event, DoesDestEvtOccur, TheVerify)
    else if (not Patient.Inpatient) and (Event.EventType = 'A') then
      TransferOrders(SelectedList, Event, DoesDestEvtOccur, TheVerify)
    else
      CopyOrders(SelectedList, Event, DoesDestEvtOccur, TheVerify);
    if ( frmOrders <> nil ) and DoesDestEvtOccur then
      frmOrders.PtEvtCompleted(Event.PtEventIFN,Event.EventName);
   finally
    SelectedList.Free;
    uAutoAC := False;
  end;
  finally
    self.btnOK.Enabled := True;
  end;
  Close;
end;

procedure TfrmODActive.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmODActive.FormCreate(Sender: TObject);
begin
  FixHeaderControlDelphi2006Bug(hdControl);
  ActiveOrderList := TList.Create;
  FOrderView      := TOrderView.Create;
  FDefaultEventOrder := '';
end;

procedure TfrmODActive.LoadActiveOrders;
var
  AnOrder: TOrder;
  i: integer;
  AnOrderPtEvtId,AnOrderEvtId: string;
begin
  LoadOrdersAbbr(ActiveOrderList,FOrderView,'');
  with ActiveOrderList do for i := Count - 1 downto 0 do
  begin
    AnOrder := TOrder(Items[i]);
    AnOrderPtEvtID := GetOrderPtEvtID(AnOrder.ID);
    if StrToIntDef(AnOrderPtEvtID,0)>0 then
    begin
      AnOrderEvtId := Piece(EventInfo(AnOrderPtEvtID),'^',2);
      if AnsiCompareText(AnOrderEvtID,IntToStr(FEvent.TheParent.ParentIFN))=0 then
      begin
         ActiveOrderList.Delete(i);
         continue;
      end;
    end;
    if (AnOrder.ID = FDefaultEventOrder) or (IsDCedOrder(AnOrder.ID)) then
    begin
      ActiveOrderList.Delete(i);
    end;
  end;
  SortOrders(ActiveOrderList, FOrderView.ByService, FOrderView.InvChrono);
  lstActiveOrders.Items.Clear;
  with ActiveOrderList do for i := 0 to Count - 1 do
  begin
    AnOrder := TOrder(Items[i]);
    lstActiveOrders.Items.AddObject(AnOrder.ID,AnOrder);
  end;
end;

procedure TfrmODActive.FormDestroy(Sender: TObject);
begin
  ClearOrders(ActiveOrderList);
  ActiveOrderList.Free;
  lstActiveOrders.Clear;
  if FOrderView <> nil then FOrderView := nil ;
end;

procedure TfrmODActive.lstActiveOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AaHeight: Integer);
var
  x,y: string;
  TextHeight, NewHeight, DateHeight: Integer;
  TheOrder: TOrder;
begin
  inherited;
  NewHeight := AaHeight;
  with lstActiveOrders do if Index < Items.Count then
  begin
    TheOrder := TOrder(ActiveOrderList.Items[index]);
    if TheOrder <> nil then with TheOrder do
    begin
      if not TheOrder.Retrieved then RetrieveVisibleOrders(Index);
      {measure the height of order text}
      x := Text;
      TextHeight := MeasureColumnHeight(x,Index,1);

      {measure the height of Start/Stop date time}
      x := FormatFMDateTimeStr('mm/dd/yy hh:nn', StartTime);
      if IsFMDateTime(StartTime) and (Length(StartTime) = FM_DATE_ONLY) then x := Piece(x, #32, 1);
      if Length(x) > 0 then x := 'Start: ' + x;
      y := FormatFMDateTimeStr('mm/dd/yy hh:nn', StopTime);
      if IsFMDateTime(StopTime)  and (Length(StopTime) = FM_DATE_ONLY)  then y := Piece(y, #32, 1);
      if Length(y) > 0 then x := x + CRLF + 'Stop: ' + y;
      DateHeight := MeasureColumnHeight(x,Index,2);
      NewHeight := HigherOf(TextHeight, DateHeight);
    end;
  end;
  AaHeight := NewHeight;
end;

procedure TfrmODActive.lstActiveOrdersDrawItem(Control: TWinControl;
  Index: Integer; TheeRect: TRect; State: TOwnerDrawState);
var
  x, y: string;
  ARect: TRect;
  AnOrder: TOrder;
  i,RightSide: integer;
  SaveColor: TColor;
begin
  inherited;
  with lstActiveOrders do
  begin
    ARect := TheeRect;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    RightSide := -2;
    for i := 0 to 2 do
    begin
      RightSide := RightSide + hdControl.Sections[i].Width;
      Canvas.MoveTo(RightSide, ARect.Bottom - 1);
      Canvas.LineTo(RightSide, ARect.Top);
    end;
    if Index < Items.Count then
    begin
      AnOrder := TOrder(Items.Objects[Index]);
      if AnOrder <> nil then with AnOrder do for i := 0 to 3 do
      begin
        if i > 0 then ARect.Left := ARect.Right + 2 else ARect.Left := 2;
        ARect.Right := ARect.Left + hdControl.Sections[i].Width - 6;
        SaveColor := Canvas.Brush.Color;
        if i = 0 then
        begin
          x := DGroupName;
          if (Index > 0) and (x = TOrder(Items.Objects[Index - 1]).DGroupName) then x := '';
        end;
        if i = 1 then x := Text;
        if i = 2 then
        begin
          x := FormatFMDateTimeStr('mm/dd/yy hh:nn', StartTime);
          if IsFMDateTime(StartTime) and (Length(StartTime) = FM_DATE_ONLY) then x := Piece(x, #32, 1);
          if Length(x) > 0 then x := 'Start: ' + x;
          y := FormatFMDateTimeStr('mm/dd/yy hh:nn', StopTime);
          if IsFMDateTime(StopTime)  and (Length(StopTime) = FM_DATE_ONLY)  then y := Piece(y, #32, 1);
          if Length(y) > 0 then x := x + CRLF + 'Stop: ' + y;
        end;
        if i = 3 then
          begin // RTC Defect 701722 ------------------------------------- begin
            if ParkedStatus <> '' then // NSR#20090509 AA 2015/09/29
              x := ParkedStatus
            else
              x := NameOfStatus(Status);
          end;  // RTC Defect 701722 --------------------------------------- end
        if (i = 1) or (i = 2) then
          DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK)
        else
          DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX );
        Canvas.Brush.Color := SaveColor;
        ARect.Right := ARect.Right + 4;
      end;
    end;
  end;
end;

procedure TfrmODActive.RetrieveVisibleOrders(AnIndex: Integer);
var
  i: Integer;
  tmplst: TList;
  AnOrder: TOrder;
begin
  tmplst := TList.Create;
  for i := AnIndex to AnIndex + 100 do
  begin
    if i >= ActiveOrderList.Count then break;
    AnOrder := TOrder(ActiveOrderList.Items[i]);
    if not AnOrder.Retrieved then tmplst.Add(AnOrder);
  end;
  RetrieveOrderFields(tmplst, 2, -1);
  tmplst.Free;
end;

procedure TfrmODActive.hdControlSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  LockDrawing;
  try
    RedrawActiveList;
  finally
    UnlockDrawing;
  end;
  lstActiveOrders.Invalidate;
end;

procedure TfrmODActive.RedrawActiveList;
var
  i, SaveTop: Integer;
  AnOrder: TOrder;
begin
  with lstActiveOrders do
  begin
    LockDrawing;
    try
      SaveTop := TopIndex;
      Clear;
      for i := 0 to ActiveOrderList.Count - 1 do
      begin
        AnOrder := TOrder(ActiveOrderList.Items[i]);
        if (AnOrder.ID = FDefaultEventOrder) or (IsDCedOrder(AnOrder.ID)) then
          Continue;
        Items.AddObject(AnOrder.ID, AnOrder);
      end;
      TopIndex := SaveTop;
    finally
      UnlockDrawing;
    end;

  end;
end;

function TfrmODActive.MeasureColumnHeight(TheOrderText: string; Index,
  Column: integer): integer;
var
  ARect: TRect;
begin
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := hdControl.Sections[Column].Width -6;
  Result := WrappedTextHeightByFont(lstActiveOrders.Canvas,lstActiveOrders.Font,TheOrderText,ARect);
end;

end.
