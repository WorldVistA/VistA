unit fOrdersRelease;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, UBACore, UBAGlobals,
  VA508AccessibilityManager;

type
  TfrmReleaseOrders = class(TfrmAutoSz)
    Panel1: TPanel;
    lstOrders: TCaptionListBox;
    Label1: TLabel;
    Panel2: TPanel;
    grpRelease: TGroupBox;
    radVerbal: TRadioButton;
    radPhone: TRadioButton;
    radPolicy: TRadioButton;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure Panel1Resize(Sender: TObject);
  private
    FOrderList: TList;
    FNature: Char;
    FSigSts: Char;
    OKPressed: Boolean;
    ESCode: string;
  end;

function ExecuteReleaseOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses Hash, rCore, rOrders, uConst, fSignItem, fOrdersPrint, uCore, uOrders, fRptBox,
  fFrame, fClinicWardMeds, rODLab, System.UITypes;

const
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR  = 'Error Saving Order';
  TX_ES_REQ  = 'Enter your electronic signature to release these orders.';
  TC_ES_REQ  = 'Electronic Signature';
  TX_NO_REL  = CRLF + CRLF + '- cannot be released to the service(s).' + CRLF + CRLF + 'Reason: ';
  TC_NO_REL  = 'Unable to Release Orders';

function ExecuteReleaseOrders(SelectedList: TList): Boolean;
var
  frmReleaseOrders: TfrmReleaseOrders;
  i, PrintLoc: Integer;
  SignList: TStringList;
  OrderText: string;
  AnOrder: TOrder;
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

  function SignNotRequired: Boolean;
  var
    i: Integer;
  begin
    Result := True;
    with SelectedList do for i := 0 to Pred(Count) do
    begin
      with TOrder(Items[i]) do if Signature <> OSS_NOT_REQUIRE then Result := False;
    end;
  end;


begin
  Result := False;
  PrintLoc := 0;
  if SelectedList.Count = 0 then Exit;
  frmReleaseOrders := TfrmReleaseOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmReleaseOrders));
    frmReleaseOrders.FOrderList := SelectedList;
    with SelectedList do for i := 0 to Count - 1 do
      frmReleaseOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    if SignNotRequired then frmReleaseOrders.grpRelease.Visible := False;
    frmReleaseOrders.ShowModal;
    if frmReleaseOrders.OKPressed then
    begin
      Result := True;
      SignList := TStringList.Create;
      try
        with SelectedList, frmReleaseOrders do
          for i := 0 to Count - 1 do
          begin
            AnOrder := TOrder(Items[i]);
            SignList.Add(AnOrder.ID + U + FSigSts + U + RS_RELEASE + U + FNature);
          end;
        StatusText('Sending Orders to Service(s)...');
        if SignList.Count > 0 then SendOrders(SignList, frmReleaseOrders.ESCode);

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

        //hds7591  Clinic/Ward movement.


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
          if Pos('R', Piece(SignList[i], U, 2)) > 0 then
            NotifyOtherApps(NAE_ORDER, 'RL' + U + Piece(SignList[i], U, 1));
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
        PrintOrdersOnSignRelease(SignList, frmReleaseOrders.FNature, PrintLoc);
//        SetupOrdersPrint(SignList, DeviceInfo, frmReleaseOrders.FNature, False, PrintIt); //*KCM*
//        if PrintIt then PrintOrdersOnReview(SignList, DeviceInfo);                       //*KCM*
      finally
        SignList.Free;
      end;
 {BillingAware}
  // HDS6435
  // HDS00005143 - if cidc master sw is on and  BANurseConsultOrders.Count > 0 then
  // save those orders with selected DX enteries.  Resulting in dx populated for provider.
      if rpcGetBAMasterSwStatus then
      begin
         if  BANurseConsultOrders.Count > 0 then
         begin
            rpcSaveNurseConsultOrder(BANurseConsultOrders);
            BANurseConsultOrders.Clear;
         end;
      end;
{BillingAware}
// HDS6435
    end; {if frmReleaseOrders.OKPressed}
      finally
    frmReleaseOrders.Release;
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  end;
end;

procedure TfrmReleaseOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
  ESCode := '';
  if Encounter.Provider = User.DUZ then
  begin
    FNature := NO_POLICY;
    radPolicy.Checked := True;
  end else
  begin
    FNature := NO_VERBAL;
    radVerbal.Checked := True
  end;
  FSigSts := SS_UNSIGNED;
end;

procedure TfrmReleaseOrders.cmdOKClick(Sender: TObject);
var
  i: Integer;
  AnErrMsg: string;
  AnOrder: TOrder;
begin
  inherited;
  // set up nature, signature status
  if      radPhone.Checked  then FNature := NO_PHONE
  else if radPolicy.Checked then FNature := NO_POLICY
  else                           FNature := NO_VERBAL;
  FSigSts := SS_UNSIGNED;
  if not grpRelease.Visible then
  begin
    FNature := NO_PROVIDER;
    FSigSts := SS_NOTREQD;
  end else
  begin
     if not (radPhone.Checked or radPolicy.Checked or radVerbal.Checked) then
     begin
       StatusText('');
       InfoBox('An option for the Nature of Orders prompt must be selected', 'Missing Value', MB_OK);
       Exit;
     end;
  end;
  if FNature = NO_POLICY then FSigSts := SS_ESIGNED;
  // validate release of the orders with this nature of order
  StatusText('Validating Release...');
  AnErrMsg := '';
  with FOrderList do for i := 0 to Count - 1 do
  begin
    AnOrder := TOrder(Items[i]);
    ValidateOrderActionNature(AnOrder.ID, OA_RELEASE, FNature, AnErrMsg);
    if Length(AnErrMsg) > 0 then
    begin
      if IsInvalidActionWarning(AnOrder.Text, AnOrder.ID) then Break;
      InfoBox(AnOrder.Text + TX_NO_REL + AnErrMsg, TC_NO_REL, MB_OK);
      Break;
    end;
  end;
  StatusText('');
  if Length(AnErrMsg) > 0 then Exit;
  // get the signature code for releasing the orders
  if grpRelease.Visible then
  begin
    SignatureForItem(Font.Size, TX_ES_REQ, TC_ES_REQ, ESCode);
    if ESCode = '' then Exit;
  end;
  OKPressed := True;
  Close;
end;

procedure TfrmReleaseOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmReleaseOrders.lstOrdersDrawItem(Control: TWinControl;
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

procedure TfrmReleaseOrders.lstOrdersMeasureItem(Control: TWinControl;
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

procedure TfrmReleaseOrders.Panel1Resize(Sender: TObject);
begin
  inherited;
  lstOrders.Invalidate;
end;

end.
