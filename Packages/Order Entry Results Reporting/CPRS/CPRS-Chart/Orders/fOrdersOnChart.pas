unit fOrdersOnChart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmOnChartOrders = class(TfrmAutoSz)
    Panel2: TPanel;
    Label1: TLabel;
    lstOrders: TCaptionListBox;
    Panel1: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Panel2Resize(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteOnChartOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rCore, rOrders, uConst, fOrdersPrint, uOrders, fFrame, UCore,
  fClinicWardMeds, rODLab, fRptBox, System.UITypes;

const
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR  = 'Error Saving Order';

function ExecuteOnChartOrders(SelectedList: TList): Boolean;
var
  frmOnChartOrders: TfrmOnChartOrders;
  i, PrintLoc: Integer;
  SignList: TStringList;
  OrderText: string;
  AList: TStringList;

  function FindOrderText(const AnID: string): string;
  var
    i: Integer;
  begin
    Result := '';
    with SelectedList do for i := 0 to Count - 1 do
      with TOrder(Items[i]) do if ID = AnID then
      begin
        Result := Text;
        Break;
      end;
  end;

begin
  Result := False;
  PrintLoc := 0;
  if SelectedList.Count = 0 then Exit;
  frmOnChartOrders := TfrmOnChartOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmOnChartOrders));
    with SelectedList do for i := 0 to Count - 1 do
      frmOnChartOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmOnChartOrders.ShowModal;
    if frmOnChartOrders.OKPressed then
    begin
      Result := True;
      SignList := TStringList.Create;
      try
        with SelectedList do for i := 0 to Count - 1 do with TOrder(Items[i]) do
          SignList.Add(ID + U + SS_ONCHART + U + RS_RELEASE + U + NO_WRITTEN);
        StatusText('Sending Orders to Service(s)...');
        if SignList.Count > 0 then SendOrders(SignList, '');

         if (not frmFrame.TimedOut) then
          begin
             if IsValidIMOLoc(uCore.TempEncounterLoc,Patient.DFN) then
                frmClinicWardMeds.ClinicOrWardLocation(SignList, uCore.TempEncounterLoc,uCore.TempEncounterLocName, PrintLoc)
             else
                if (IsValidIMOLoc(Encounter.Location,Patient.DFN)) and ((frmClinicWardMeds.rpcIsPatientOnWard(patient.DFN)) and (Patient.Inpatient = false)) then
                   frmClinicWardMeds.ClinicOrWardLocation(SignList, Encounter.Location,Encounter.LocationName, PrintLoc);
          end;
          uCore.TempEncounterLoc := 0;
          uCore.TempEncounterLocName := '';

      //CQ #15813 Modired code to look for error string mentioned in CQ and change strings to conts - JCS
        with SignList do if Count > 0 then for i := 0 to Count - 1 do
          begin
            if Pos('E', Piece(SignList[i], U, 2)) > 0 then
              begin
                OrderText := FindOrderText(Piece(SignList[i], U, 1));
                if Piece(SignList[i],U,4) = TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING then
                InfoBox(TX_SAVERR1 + Piece(SignList[i], U, 4) + TX_SAVERR2 + OrderText + CRLF + CRLF +
                        TX_SAVERR_PHARM_ORD_NUM, TC_SAVERR, MB_OK)
                else if Piece(SignList[i],U,4) = TX_SAVERR_IMAGING_PROC_SEARCH_STRING then
                InfoBox(TX_SAVERR1 + Piece(SignList[i], U, 4) + TX_SAVERR2 + OrderText + CRLF + CRLF +
                        TX_SAVERR_IMAGING_PROC, TC_SAVERR, MB_OK)
                else
                InfoBox(TX_SAVERR1 + Piece(SignList[i], U, 4) + TX_SAVERR2 + OrderText,
                        TC_SAVERR, MB_OK);
              end;
          end;
        StatusText('');
          //  CQ 10226, PSI-05-048 - advise of auto-change from LC to WC on lab orders
        AList := TStringList.Create;
        try
          CheckForChangeFromLCtoWCOnRelease(AList, Encounter.Location, SignList);
          if AList.Text <> '' then
            ReportBox(AList, 'Changed Orders', TRUE);
        finally
          AList.Free;
        end;
        PrintOrdersOnSignRelease(SignList, NO_WRITTEN, PrintLoc);
//        SetupOrdersPrint(SignList, DeviceInfo, NO_WRITTEN, False, PrintIt);  //*KCM*
//        if PrintIt then PrintOrdersOnReview(SignList, DeviceInfo);           //*KCM*
      finally
        SignList.Free;
      end;
    end; {if frmOnChartOrders.OKPressed}
  finally
    frmOnChartOrders.Release;
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  end;
end;

procedure TfrmOnChartOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmOnChartOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmOnChartOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmOnChartOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  with lstOrders do if Index < Items.Count then
  begin
    ARect := ItemRect(Index);
    Canvas.FillRect(ARect);
    x := FilteredString(Items[Index]);
    AHeight := WrappedTextHeightByFont(Canvas, Font, x, ARect);
    if AHeight <  13 then AHeight := 15;
  end;
end;

procedure TfrmOnChartOrders.lstOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
  SaveColor: TColor;
begin
  inherited;
  with lstOrders do
  begin
    ARect := Rect;
    ARect.Left := ARect.Left + 2;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    SaveColor := Canvas.Brush.Color;
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      x := FilteredString(Items[Index]);
      DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
      Canvas.Brush.Color := SaveColor;
      ARect.Right := ARect.Right + 4;
    end;
  end;
end;

procedure TfrmOnChartOrders.Panel2Resize(Sender: TObject);
begin
  inherited;
  lstOrders.Invalidate;
end;

end.
