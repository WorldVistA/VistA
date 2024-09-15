unit fOrdersSign;

interface

uses
  System.Types,
  System.UITypes,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  fAutoSz,
  StdCtrls,
  StrUtils,
  ORFn,
  ORNet,
  ORCtrls,
  AppEvnts,
  mCoPayDesc,
  oPKIEncryption,
  ComCtrls,
  CheckLst,
  ExtCtrls,
  uConsults,
  Menus,
  ORClasses,
  fBase508Form,
  fPrintLocation,
  fCSRemaining,
  VA508AccessibilityManager,
  rODMeds;

type
  TfrmSignOrders = class(TfrmBase508Form)
    fraCoPay: TfraCoPayDesc;
    pnlDEAText: TPanel;
    lblDEAText: TStaticText;
    pnlProvInfo: TPanel;
    lblProvInfo: TLabel;
    pnlOrderList: TPanel;
    lblOrderList: TStaticText;
    clstOrders: TCaptionCheckListBox;
    pnlCSOrderList: TPanel;
    lblCSOrderList: TStaticText;
    lblSmartCardNeeded: TStaticText;
    clstCSOrders: TCaptionCheckListBox;
    pnlEsig: TPanel;
    lblESCode: TLabel;
    txtESCode: TCaptionEdit;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlCombined: TORAutoPanel;
    pnlTop: TPanel;
    gpMain: TGridPanel;
    pnlCSTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clstOrdersDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure clstOrdersMeasureItem(Control: TWinControl; Index: Integer; var AHeight: Integer);
    procedure clstOrdersClickCheck(Sender: TObject);
    procedure clstOrdersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure clstOrdersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gpMainResize(Sender: TObject);
  private
    OKPressed: boolean;
    ESCode: string;
    FLastHintItem: Integer;
    FOldHintPause: Integer;
    FOldHintHidePause: Integer;

    function IsSignatureRequired: boolean;
    function ItemsAreChecked(aCaptionCheckListBox: TCaptionCheckListBox): boolean;
    function nonDCCSItemsAreChecked: boolean;
    function AnyItemsAreChecked: boolean;

    procedure FormatListForScreenReader(Sender: TObject);
  public
    { Public Declarations }
  end;

var
  frmSignOrders: TfrmSignOrders;
  FOSTFHintWndActive: boolean;
  FOSTFhintWindow: THintWindow;

function ExecuteSignOrders(SelectedList: TList): boolean;

implementation

{$R *.DFM}

uses
  XWBHash,
  rCore,
  rOrders,
  uConst,
  uCore,
  uOrders,
  uSignItems,
  fOrders,
  fFrame,
  rODLab,
  fRptBox,
  VAUtils,
  UResponsiveGUI,
  rMisc,
  VAHelpers;

const
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR = 'Error Saving Order';

function ExecuteSignOrders(SelectedList: TList): boolean;
const
  VERT_SPACING = 6;
var
  i, {k,} cidx, cnt, theSts, WardIEN: Integer;
  minWidth, sigWidth, topHeight, lstHeight, deaHeight, newHeight: integer;
  SignList: TStringList;
  CSSignList: TStringList;
  Obj: TOrder;
  ContainsIMOOrders, DoNotPrint, t1, t2 {, t3}: boolean;
  X, FormID {SigData, SigUser, SigDrugSch, SigDEA}: string;
  cSignature, cHashData, cCrlUrl, cErr, WardName: string;
  //UsrAltName, IssuanceDate, PatientName, PatientAddress, DetoxNumber, ProviderName, ProviderAddress: string;
  //DrugName, Quantity, Directions: string;
  OrderText, ASvc: string;
  PrintLoc: Integer;
  AList, ClinicList, OrderPrintList, WardList: TStringList;
  EncLocName, EncLocText: string;
  EncLocIEN: Integer;
  EncDT: TFMDateTime;
  EncVC: Char;
  CSOrder, PINRetrieved: boolean;
  PINLock: string;
  DEACheck: string;
  aPKIEncryptionEngine: IPKIEncryptionEngine;
  aPKIEncryptionDataDEAOrder: IPKIEncryptionDataDEAOrder;
  aMessage, successMsg: string;
  aLst: TStringList;

  function FindOrderText(const aID: string): string;
  var
    aPtr: Pointer;
  begin
    Result := '';

    for aPtr in SelectedList do
      if TOrder(aPtr).ID = aID then
        begin
          Result := TOrder(aPtr).Text;
          Break;
        end;
  end;

  function SignNotRequired: boolean;
  var
    aPtr: Pointer;
  begin
    Result := True;
    for aPtr in SelectedList do
      if TOrder(aPtr).Signature <> OSS_NOT_REQUIRE then
        begin
          Result := False;
          Break;
        end;
  end;

  function DigitalSign: boolean;
  var
    aPtr: Pointer;
  begin
    Result := False;

    for aPtr in SelectedList do
      if Copy(TOrder(aPtr).DigSigReq, 1, 1) = '2' then
        begin
          Result := True;
          Break;
        end;
  end;

  function Piece2end(aString, aDelimiter: string): string;
  begin
    Result := Copy(aString, Pos(aDelimiter, aString), length(aString));
  end;

begin
  Result := False;
  PrintLoc := 0;
  EncLocIEN := 0;
  DoNotPrint := False;

  frmSignOrders := TfrmSignOrders.Create(Application);

  aLst := TStringList.Create;
  try
    CallVistA('ORDEA DEATEXT', [], aLst);
    frmSignOrders.lblDEAText.Caption := '';
    for X in aLst do
      frmSignOrders.lblDEAText.Caption := frmSignOrders.lblDEAText.Caption + ' ' + X;

    CallVistA('ORDEA SIGINFO', [Patient.DFN, User.DUZ], aLst);
    frmSignOrders.lblProvInfo.Caption := aLst.Text;
    frmSignOrders.pnlProvInfo.Width := frmSignOrders.lblProvInfo.Width + 8;
  finally
    FreeAndNil(aLst);
  end;
  try
    SigItems.ResetOrders;
    SigItemsCS.ResetOrders;

    with SelectedList do
      for i := 0 to Count - 1 do
        begin
          Obj := TOrder(Items[i]);

          if ((Obj.IsControlledSubstance = False) or IsPendingHold(Obj.ID)) then
            begin
              cidx := frmSignOrders.clstOrders.Items.AddObject(Obj.Text, Obj);
              SigItems.Add(CH_ORD, Obj.ID, cidx);
              frmSignOrders.clstOrders.Checked[cidx] := True;

              if Obj.Signature = OSS_NOT_REQUIRE then
                frmSignOrders.clstOrders.State[cidx] := cbGrayed;
            end

          else if (Obj.IsControlledSubstance and Obj.IsOrderPendDC) then
            begin
              cidx := frmSignOrders.clstOrders.Items.AddObject(Obj.Text, Obj);
              SigItems.Add(CH_ORD, Obj.ID, cidx);

              frmSignOrders.clstOrders.Checked[cidx] := True;

              if Obj.Signature = OSS_NOT_REQUIRE then
                frmSignOrders.clstOrders.State[cidx] := cbGrayed;
            end

          else if (Obj.IsControlledSubstance and not(IsPendingHold(Obj.ID))) then
            begin
              DEACheck := DEACheckFailedAtSignature(GetOrderableIen(Piece(Obj.ID, ';', 1)), False);
              if not(DEACheck = '0') then
                ShowMsg('You are not authorized to Digitally Sign order: ' + CRLF + Obj.Text)
              else
                begin
                  cidx := frmSignOrders.clstCSOrders.Items.AddObject(Obj.Text, Obj);
                  SigItemsCS.Add(CH_ORD, Obj.ID, cidx);

                  if TOrder(Items[i]).IsOrderPendDC then
                    frmSignOrders.clstCSOrders.Checked[cidx] := True
                  else
                    frmSignOrders.clstCSOrders.Checked[cidx] := False;

                  if Obj.Signature = OSS_NOT_REQUIRE then
                    frmSignOrders.clstCSOrders.State[cidx] := cbGrayed;
                end;
            end;
        end;

    if frmSignOrders.clstCSOrders.Count > 0 then
      begin
        if not(GetPKISite) then
          begin
            ShowMsg('Digital Signing of Controlled Substances is currently disabled for your site.');
            if frmSignOrders.clstOrders.Count > 0 then
              begin
                frmSignOrders.clstCSOrders.Clear;
                SigItemsCS.ResetOrders;
              end
            else
              Exit;
          end;

        if not(GetPKIUse) then
          begin
            ShowMsg('You are not currently permitted to digitally sign Controlled Substances.');
            if frmSignOrders.clstOrders.Count > 0 then
              begin
                frmSignOrders.clstCSOrders.Clear;
                SigItemsCS.ResetOrders;
              end
            else
              Exit;
          end;
      end;

    SigItems.ClearDrawItems;
    SigItems.ClearFCtrls;
    SigItemsCS.ClearDrawItems;
    SigItemsCS.ClearFCtrls;

    with frmSignOrders do
      begin
        topHeight := pnlTop.Height;
        lstHeight := Canvas.TextHeight('Ty') * 5;
        deaHeight := pnlDEAText.Height;
        if clstCSOrders.Count > 0 then
          minWidth := Canvas.TextWidth(lblCSOrderList.Caption +
            lblSmartCardNeeded.Caption) + lblSmartCardNeeded.Margins.Left
        else
          minWidth := Canvas.TextWidth(lblOrderList.Caption);
        inc(minWidth, TSigItems.MinWidthDX + ScrollBarWidth);
        t1 := SigItems.UpdateListBox(clstOrders);
        t2 := SigItemsCS.UpdateListBox(clstCSOrders);
        if t1 or t2 then
        begin
          fraCoPay.Visible := True;
          pnlTop.Visible := True;
          pnlTop.Height := fraCoPay.AdjustAndGetSize;
          if t1 then
            inc(minWidth, SigItems.BtnWidths)
          else
            inc(minWidth, SigItemsCS.BtnWidths);
        end;

        sigWidth := (cmdOK.Width * 4) + txtESCode.Left + txtESCode.Width;
        if minWidth < sigWidth then
          minWidth := SigWidth;

        if SignNotRequired then
          begin
            lblESCode.Visible := False;
            txtESCode.Visible := False;
          end;
        pnlDEAText.Visible := True;
        txtESCode.Text := '';
        if ((clstOrders.Count = 0) and (clstCSOrders.Count = 0)) then
          Exit;

        if clstCSOrders.Count = 0 then
          begin
            pnlProvInfo.Visible := False;
            if fraCoPay.Visible = False then
              begin
                pnlTop.Visible := False;
              end;
            pnlDEAText.Visible := False;
            pnlCSOrderList.Visible := False;
          end
        else if clstOrders.Count = 0 then
          begin
            pnlOrderList.Visible := False;
            txtESCode.Visible := False;
            lblESCode.Visible := False;
          end;
        lblDEAText.Visible := False;
        lblSmartCardNeeded.Visible := False;

        if AnyItemsAreChecked then
        begin
          lblESCode.Visible := IsSignatureRequired;
          txtESCode.Visible := IsSignatureRequired;
        end;
        if txtESCode.Visible then
          ActiveControl := txtESCode;

        newHeight := Height - ClientHeight + pnlEsig.Height;
        if pnlTop.Visible then
          inc(newHeight, topHeight);
        if pnlDEAText.Visible then
          inc(newHeight, deaHeight);
        if pnlOrderList.Visible then
          inc(newHeight, lstHeight)
        else
          gpMain.RowCollection[0].Value := 0;
        if pnlCSOrderList.Visible then
          inc(newHeight, lstHeight)
        else
          gpMain.RowCollection[1].Value := 0;
        Constraints.MinHeight := newHeight;
        Constraints.MinWidth := minWidth;
        Height := newHeight;

        FormID := '-';
        if pnlTop.Visible then
          FormID := FormID + 'T';
        if pnlDEAText.Visible then
          FormID := FormID + 'D';
        if pnlOrderList.Visible and pnlCSOrderList.Visible then
          FormID := FormID + '2'
        else if pnlOrderList.Visible or pnlCSOrderList.Visible then
          FormID := FormID + '1';
      end;

    SetFormPosition(frmSignOrders, FormID, True);
    frmSignOrders.ShowModal;
    SaveUserBounds(frmSignOrders, FormID);

    if frmSignOrders.OKPressed then
      begin
        Result := True;
        SignList := TStringList.Create;
        CSSignList := TStringList.Create;
        ClinicList := TStringList.Create;
        OrderPrintList := TStringList.Create;
        WardList := TStringList.Create;
        ContainsIMOOrders := False;
        try
          with SelectedList do
            for i := 0 to Count - 1 do
              with TOrder(Items[i]) do
                begin
                  CSOrder := False;
                  cErr := '';
                  cidx := frmSignOrders.clstOrders.Items.IndexOfObject(TOrder(Items[i]));
                  if cidx < 0 then
                    begin
                      cidx := frmSignOrders.clstCSOrders.Items.IndexOfObject(TOrder(Items[i]));
                      CSOrder := True;
                    end;

                  if (cidx > -1) and (CSOrder = False) and (cErr = '') then
                    begin
                      if TOrder(Items[i]).Signature = OSS_NOT_REQUIRE then
                        frmSignOrders.clstOrders.Checked[cidx] := True; // Non VA MEDS
                      if frmSignOrders.clstOrders.Checked[cidx] then
                        begin
                          UpdateOrderDGIfNeeded(ID);
                          SignList.Add(ID + U + SS_ESIGNED + U + RS_RELEASE + U + NO_PROVIDER);
                          // BAOrderList.Add(TOrder(Items[i]).ID);
                        end;
                    end;

                  if (cidx > -1) and (CSOrder) and (cErr = '') then
                    begin
                      if frmSignOrders.clstCSOrders.Checked[cidx] then
                        begin
                          if IsOrderPendDC then
                            begin
                              UpdateOrderDGIfNeeded(ID);
                              SignList.Add(ID + U + SS_DIGSIG + U + RS_RELEASE + U + NO_PROVIDER);
                              // BAOrderList.Add(TOrder(Items[i]).ID);
                            end
                          else
                            begin
                              CSSignList.Add(ID + U + SS_DIGSIG + U + RS_RELEASE + U + NO_PROVIDER);
                            end;
                        end;
                    end;
                end;

          // actually do the digital signing of orders
          // if digital signature passes then items will be added to SignList
          if CSSignList.Count > 0 then
            begin
              try
                // get PKI engine components ready
                NewPKIEncryptionEngine(RPCBrokerV, aPKIEncryptionEngine);
                NewPKIEncryptionDataDEAOrder(aPKIEncryptionDataDEAOrder);

                // check if reader is ready, card in slot, SAN is set in vista user account
                // if no SAN set it will perform the link process in IsDigitalSignatureAvailable
                aLst := TStringList.Create;
                try
                  CallVistA('ORDEA LNKMSG', [], aLst);
                  successMsg := aLst.Text;
                finally
                  FreeAndNil(aLst);
                end;
                if not IsDigitalSignatureAvailable(aPKIEncryptionEngine, aMessage, successMsg) then
                  raise Exception.Create('There was a problem linking your PIV card. Either the '
                    + 'PIV card name does NOT match your VistA account name or the PIV card is already '
                    + 'linked to another VistA account.  Ensure that the correct PIV card has '
                    + 'been inserted for your VistA account. Please contact your PIV Card Coordinator '
                    + 'if you continue to have problems.');

                // do PIN entry
                case VerifyPKIPIN(aPKIEncryptionEngine) of
                  prOK:
                    begin
                      for i := 0 to CSSignList.Count - 1 do
                        begin
                          aPKIEncryptionDataDEAOrder.Clear;
                          aPKIEncryptionDataDEAOrder.LoadFromVistA(RPCBrokerV, Patient.DFN, IntToStr(User.DUZ), Piece(Piece(CSSignList.Strings[i], U, 1), ';', 1));
                          try
                            aPKIEncryptionEngine.SignData(aPKIEncryptionDataDEAOrder);

                            // if we get here without an exception then all went well with digital signing of this order
                            cSignature := aPKIEncryptionDataDEAOrder.Signature;
                            cHashData := aPKIEncryptionDataDEAOrder.HashText;
                            cCrlUrl := aPKIEncryptionDataDEAOrder.CrlURL;
                            cErr := '';

                            // store digital sig info for the order
                            StoreDigitalSig(Piece(CSSignList.Strings[i], U, 1), cHashData, User.DUZ, cSignature, cCrlUrl, Patient.DFN, cErr);
                            if cErr = '' then
                              begin
                                UpdateOrderDGIfNeeded(Piece(CSSignList.Strings[i], U, 1));
                                // if this happens then the order will get released
                                SignList.Add(CSSignList.Strings[i]);
                                // BAOrderList.Add(Piece(CSSignList.Strings[i], U, 1));
                              end;
                          except
                            on E: EPKIEncryptionError do
                              raise Exception.Create('PKI error encountered during digital signing of data: ' + E.Message);
                            on E: Exception do
                              raise Exception.Create('Unknown error encountered during digital signing: ' + E.Message);
                          end;
                        end;
                    end;
                  prCancel:
                    Exception.Create('You have cancelled the digital signing process.');
                  prLocked:
                    Exception.Create('Your card has been locked and you cannot continue the digital signing process.');
                else
                  Exception.Create('There was a problem getting your PIN and the digital signing process has been stopped.');
                end;
              except
                on E: Exception do
                  ShowMsg('The Controlled Substance order(s) will remain unreleased.' + E.Message);
              end;
            end;
          aPKIEncryptionEngine := nil;
          aPKIEncryptionDataDEAOrder := nil;

          StatusText('Sending Orders to Service(s)...');
          if SignList.Count > 0 then
            begin
              if not frmFrame.TimedOut then
                begin
                  if (Patient.Inpatient = True) and (Encounter.Location <> Patient.Location) then
                    begin
                      EncLocName := Encounter.LocationName;
                      EncLocIEN := Encounter.Location;
                      EncLocText := Encounter.LocationText;
                      EncDT := Encounter.DateTime;
                      EncVC := Encounter.VisitCategory;
                      for i := 0 to SelectedList.Count - 1 do
                        begin
                          CSOrder := False;
                          cidx := frmSignOrders.clstOrders.Items.IndexOfObject(TOrder(SelectedList.Items[i]));
                          // selected order isn't from non-CS list -> check CS List
                          if cidx = -1 then
                            begin
                              cidx := frmSignOrders.clstCSOrders.Items.IndexOfObject(TOrder(SelectedList.Items[i]));
                              // selected order found in CS List -> CSOrder := True
                              if cidx <> -1 then
                                CSOrder := True;
                            end;
                          if ((CSOrder = False) and (frmSignOrders.clstOrders.Checked[cidx] = False)) or
                            (CSOrder and (frmSignOrders.clstCSOrders.Checked[cidx] = False)) then
                            continue;
                          if (TOrder(SelectedList.Items[i]).DGroupName = 'Clinic Medications') or
                            (TOrder(SelectedList.Items[i]).DGroupName = 'Clinic Infusions') then
                            ContainsIMOOrders := True;
                          if TOrder(SelectedList.Items[i]).DGroupName = '' then
                            continue;
                          if (Pos('DC', TOrder(SelectedList.Items[i]).ActionOn) > 0) or
                            (TOrder(SelectedList.Items[i]).IsOrderPendDC = True) then
                            begin
                              WardList.Add(TOrder(SelectedList.Items[i]).ID);
                              continue;
                            end;
                          if TOrder(SelectedList.Items[i]).IsDelayOrder = True then
                            continue;
                          OrderPrintList.Add(TOrder(SelectedList.Items[i]).ID + ':' + TOrder(SelectedList.Items[i]).Text);
                        end;
                      if OrderPrintList.Count > 0 then
                        begin
                          TfrmPrintLocation.PrintLocation(OrderPrintList, EncLocIEN, EncLocName, EncLocText, EncDT, EncVC, ClinicList,
                            WardList, WardIEN, WardName, ContainsIMOOrders, True);
                        end
                      else if (ClinicList.Count = 0) and (WardList.Count = 0) then
                        DoNotPrint := True;
                      if (WardIEN = 0) and (WardName = '') then
                        CurrentLocationForPatient(Patient.DFN, WardIEN, WardName, ASvc);
                    end;
                end;
              uCore.TempEncounterLoc := 0;
              uCore.TempEncounterLocName := '';
              // hds7591  Clinic/Ward movement  Patient Admission IMO

              SigItems.SaveSettings; // Save CoPay FIRST!
              SigItemsCS.SaveSettings;
              SendOrders(SignList, frmSignOrders.ESCode);
            end;

          // CQ #15813 Modified code to look for error string mentioned in CQ and change strings to conts - JCS
          // CQ #15813 Adjusted code to handle error message properly - TDP
          with SignList do
            if Count > 0 then
              for i := 0 to Count - 1 do
                begin
                  if Pos('E', Piece(SignList[i], U, 2)) > 0 then
                    begin
                      OrderText := FindOrderText(Piece(SignList[i], U, 1));
                      if Piece(SignList[i], U, 4) = TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING then
                        InfoBox(TX_SAVERR1 + Piece(SignList[i], U, 4) + TX_SAVERR2 + OrderText + CRLF + CRLF +
                          TX_SAVERR_PHARM_ORD_NUM, TC_SAVERR, MB_OK)
                      else if AnsiContainsStr(Piece(SignList[i], U, 4), TX_SAVERR_IMAGING_PROC_SEARCH_STRING) then
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
          for cnt := SignList.Count - 1 downto 0 do
            begin
              if Pos('E', Piece(SignList[cnt], U, 2)) > 0 then
                begin
                  SignList.Delete(cnt);
                  continue;
                end;
              theSts := GetOrderStatus(Piece(SignList[cnt], U, 1));
              if theSts = 10 then
                SignList.Delete(cnt); // signed delayed order should not be printed.
            end;
          // CQ 10226, PSI-05-048 - advise of auto-change from LC to WC on lab orders
          AList := TStringList.Create;
          try
            CheckForChangeFromLCtoWCOnRelease(AList, Encounter.Location, SignList);
            if AList.Text <> '' then
              ReportBox(AList, 'Changed Orders', True);
          finally
            AList.Free;
          end;
          if (ClinicList.Count > 0) or (WardList.Count > 0) then
            PrintOrdersOnSignReleaseMult(SignList, ClinicList, WardList, NO_PROVIDER, EncLocIEN, WardIEN, EncLocName, WardName)
          else if DoNotPrint = False then
            PrintOrdersOnSignRelease(SignList, NO_PROVIDER, PrintLoc);
        finally
          CSRemaining(frmSignOrders.clstOrders.Items, frmSignOrders.clstCSOrders.Items);
          SignList.Free;
          OrderPrintList.Free;
          WardList.Free;
          ClinicList.Free;
        end;
      end; { if frmSignOrders.OKPressed }
  finally
    frmSignOrders.Free;

    with SelectedList do
      for i := 0 to Count - 1 do
        UnlockOrder(TOrder(Items[i]).ID);
  end;
end;

procedure TfrmSignOrders.FormCreate(Sender: TObject);
begin
  inherited;
  FLastHintItem := -1;
  OKPressed := False;
  FOldHintPause := Application.HintPause;
  Application.HintPause := 250;
  FOldHintHidePause := Application.HintHidePause;
  Application.HintHidePause := 30000;
  ResizeFormToFont(Self);
  lblSmartCardNeeded.Font.Size := MainFontSize;
  pnlCSTop.Height := MainFontTextHeight + TSigItems.btnMargin;
end;

procedure TfrmSignOrders.FormShow(Sender: TObject);
begin
  if txtESCode.Visible then
    txtESCode.SetFocus;

  clstOrders.TabOrder := 0; // CQ5057
  FormatListForScreenReader(clstOrders);
  FormatListForScreenReader(clstCSOrders);

  // CQ5172
  if clstOrders.Count = 1 then
    clstOrders.Selected[0] := True;
  // end CQ5172
end;

procedure TfrmSignOrders.gpMainResize(Sender: TObject);
begin
  inherited;
  clstOrders.ForceItemHeightRecalc;
  clstCSOrders.ForceItemHeightRecalc;
end;

procedure TfrmSignOrders.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  j: Integer; // CQ5054
begin
  inherited;
  if FOSTFHintWndActive then
    begin
      FOSTFhintWindow.ReleaseHandle;
      FOSTFHintWndActive := False;
    end;

  case Key of
    // CQ5054
    // 83, 115:
    vkS, vkF4:
      if (ssAlt in Shift) then
        begin
          for j := 0 to clstOrders.Items.Count - 1 do
            clstOrders.Selected[j] := False;
          if clstOrders.Items.Count > 0 then
            clstOrders.Selected[0] := True;
          clstOrders.SetFocus;
        end;
    // end CQ5054
  end;
end;

procedure TfrmSignOrders.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  try
    if FOSTFHintWndActive then
      begin
        FOSTFhintWindow.ReleaseHandle;
        FOSTFHintWndActive := False;
        TResponsiveGUI.ProcessMessages;
      end;
  except
    on E: Exception do
      begin
        // Show508Message('Unhandled exception in procedure TfrmSignOrders.FormMouseMove()');
        raise;
      end;
  end;
end;

procedure TfrmSignOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  Application.HintPause := FOldHintPause;
  Application.HintHidePause := FOldHintHidePause;
end;

procedure TfrmSignOrders.cmdOKClick(Sender: TObject);
const
  TX_NO_CODE = 'An electronic signature code must be entered to sign orders.';
  TC_NO_CODE = 'Electronic Signature Code Required';
  TX_BAD_CODE = 'The electronic signature code entered is not valid.';
  TC_BAD_CODE = 'Invalid Electronic Signature Code';
  TC_NO_DX = 'Incomplete Diagnosis Entry';
  TX_NO_DX = 'A Diagnosis must be selected prior to signing any of the following order types:'
    + CRLF + 'Lab, Radiology, Outpatient Medications, Prosthetics.';
begin
  inherited;

  if txtESCode.Visible and (length(txtESCode.Text) = 0) then
    begin
      InfoBox(TX_NO_CODE, TC_NO_CODE, MB_OK);
      Exit;
    end;

  if txtESCode.Visible and not ValidESCode(txtESCode.Text) then
    begin
      InfoBox(TX_BAD_CODE, TC_BAD_CODE, MB_OK);
      txtESCode.SetFocus;
      txtESCode.SelectAll;
      Exit;
    end;

  if not SigItems.OK2SaveSettings or not SigItemsCS.OK2SaveSettings then
    begin
      InfoBox(TX_Order_Error, 'Sign Orders', MB_OK);
      Exit;
    end;

  if txtESCode.Visible then
    ESCode := Encrypt(txtESCode.Text)
  else
    ESCode := '';

  OKPressed := True;
  Close;
end;

procedure TfrmSignOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmSignOrders.clstOrdersDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  X: string;
  ARect: TRect;
  aListView: TCaptionCheckListBox;
begin
  if Control.ClassNameIs('TCaptionCheckListBox') then
    aListView := TCaptionCheckListBox(Control)
  else
    raise Exception.Create('Invalid control passed to DrawItem');

  X := '';
  ARect := Rect;
  with aListView do
    begin
      if Index < Items.Count then
        begin
          Canvas.FillRect(ARect);
          Canvas.Pen.Color := Get508CompliantColor(clSilver);
          Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
          Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
          X := FilteredString(Items[Index]);
          DrawText(Canvas.handle, PChar(X), length(X), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
        end;
    end;
end;

procedure TfrmSignOrders.clstOrdersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_Space) then
    FormatListForScreenReader(Sender);
end;

procedure TfrmSignOrders.clstOrdersMeasureItem(Control: TWinControl; Index: Integer; var AHeight: Integer);
var
  X: string;
  ARect: TRect;
  aListView: TCaptionCheckListBox;
begin
  if Control is TCaptionCheckListBox then
    aListView := TCaptionCheckListBox(Control)
  else
    raise Exception.Create('Invalid control passed to MeasureItem');

  AHeight := SigItemHeight;
  with aListView do
    if Index < Items.Count then
      begin
        ARect := ItemRect(Index);
        if CVarExists(TSigItems.RectWidth) then
          ARect.Right := CVar[TSigItems.RectWidth];
        Canvas.FillRect(ARect);
        X := FilteredString(Items[Index]);
        AHeight := WrappedTextHeightByFont(Canvas, Font, X, ARect);
        if AHeight > 255 then
          AHeight := 255;
        // -------------------
        { Bug fix-HDS00001627 }
        // if AHeight <  13 then AHeight := 13; {ORIG}
        if AHeight < 13 then
          AHeight := 15;
        // -------------------
      end;
end;

procedure TfrmSignOrders.clstOrdersClickCheck(Sender: TObject);
var
  aListView: TCaptionCheckListBox;
  aOrder: TOrder;

  procedure updateAllChilds(CheckedStatus: boolean; ParentOrderId: string);
  var
    idx: Integer;
  begin
    for idx := 0 to aListView.Items.Count - 1 do
      if TOrder(aListView.Items.Objects[idx]).ParentID = ParentOrderId then
        begin
          if aListView.Checked[idx] <> CheckedStatus then
            begin
              aListView.Checked[idx] := CheckedStatus;
              SigItems.EnableSettings(idx, aListView.Checked[idx]);
            end;
        end;
  end;

begin
  if Sender.ClassNameIs('TCaptionCheckListBox') then
    aListView := TCaptionCheckListBox(Sender)
  else
    raise Exception.Create('Invalid Sender in ClickCheck');

  if Sender = clstCSOrders then
    with clstCSOrders do
      try
        CallVistA(
          'ORDEA AUINTENT',
          [TOrder(Items.Objects[ItemIndex]).ID, BOOLCHAR[Checked[ItemIndex]]]);
      except
        on E: Exception do
          MessageDlg(
            Format('Error auditing intent to sign for controlled substance %s:%s', [E.ClassName, E.Message]),
            mtError, [mbOk], 0);
      end;

   if not Assigned(aListView.Items.Objects[aListView.ItemIndex]) then
    exit;
   aOrder := TOrder(aListView.Items.Objects[aListView.ItemIndex]);

   if (aOrder.Signature = OSS_NOT_REQUIRE) then
    aListView.State[aListView.ItemIndex] := cbGrayed
   else begin
    with aListView do
      begin
        if length(TOrder(Items.Objects[ItemIndex]).ParentID) > 0 then
          begin
            if aListView = clstOrders then
              SigItems.EnableSettings(ItemIndex, Checked[ItemIndex]);
            if aListView = clstCSOrders then
              SigItemsCS.EnableSettings(ItemIndex, Checked[ItemIndex]);

            updateAllChilds(Checked[ItemIndex], TOrder(Items.Objects[ItemIndex]).ParentID);
          end
        else
          begin
            if aListView = clstOrders then
              SigItems.EnableSettings(ItemIndex, Checked[ItemIndex]);
            if aListView = clstCSOrders then
              SigItemsCS.EnableSettings(ItemIndex, Checked[ItemIndex]);
          end
      end;
   end;

  if ItemsAreChecked(clstCSOrders) and nonDCCSItemsAreChecked then
    begin
      lblDEAText.Visible := True;
      lblSmartCardNeeded.Visible := True;
    end
  else
    begin
      lblDEAText.Visible := False;
      lblSmartCardNeeded.Visible := False;
    end;

  lblESCode.Visible := IsSignatureRequired;
  txtESCode.Visible := lblESCode.Visible;

  if txtESCode.Visible then
    txtESCode.SetFocus;
end;

procedure TfrmSignOrders.clstOrdersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  aListView: TCaptionCheckListBox;
  Itm: Integer;
begin
  if Sender.ClassNameIs('TCaptionCheckListBox') then
    aListView := TCaptionCheckListBox(Sender)
  else
    raise Exception.Create('Invalid sender in MouseMove');

  Itm := aListView.ItemAtPos(Point(X, Y), True);
  if (Itm >= 0) then
    begin
      if (Itm <> FLastHintItem) then
        begin
          Application.CancelHint;
          FLastHintItem := Itm;
          Application.ActivateHint(Point(X, Y));
        end;
    end
  else
    begin
      aListView.Hint := '';
      FLastHintItem := -1;
      Application.CancelHint;
    end;
end;

function TfrmSignOrders.ItemsAreChecked(aCaptionCheckListBox: TCaptionCheckListBox): boolean;
{ return true if any items in the Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;

  with aCaptionCheckListBox do
    for i := 0 to Items.Count - 1 do
      if Checked[i] then
        begin
          Result := True;
          Break;
        end;
end;

function TfrmSignOrders.nonDCCSItemsAreChecked: boolean;
{ return true if any items in the Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;

  with clstCSOrders do
    for i := 0 to Items.Count - 1 do
      if Checked[i] then
        begin
          if not TOrder(clstCSOrders.Items.Objects[i]).IsOrderPendDC then
            begin
              Result := True;
              Break;
            end;
        end;
end;

function TfrmSignOrders.AnyItemsAreChecked: boolean;
begin
  Result := ItemsAreChecked(clstOrders) or ItemsAreChecked(clstCSOrders);
end;

function TfrmSignOrders.IsSignatureRequired: boolean;
var
  i: Integer;
begin
  Result := False;
  with clstOrders do
    for i := 0 to Items.Count - 1 do
      begin
        if clstOrders.Checked[i] then
          begin
            with TOrder(Items.Objects[i]) do
              if Signature <> OSS_NOT_REQUIRE then
                Result := True;
          end;
      end;

  with clstCSOrders do
    for i := 0 to Items.Count - 1 do
      begin
        if clstCSOrders.Checked[i] then
          begin
            with TOrder(Items.Objects[i]) do
              if Signature <> OSS_NOT_REQUIRE then
                Result := True;
          end;
      end;
end;

procedure TfrmSignOrders.FormatListForScreenReader(Sender: TObject);
var
  aListView: TCaptionCheckListBox;
  i: Integer;
begin
  if ScreenReaderActive then
    begin
      aListView := TCaptionCheckListBox(Sender);

      if aListView.Count < 1 then
        Exit;

      for i := 0 to aListView.Count - 1 do
        if aListView.Items.Objects[i] <> nil then // Not a Group Title
          begin
            if aListView.Items.Objects[i] is TOrder then
              if aListView.Checked[i] then
                aListView.Items[i] := 'Checked ' + TOrder(aListView.Items.Objects[i]).Text
              else
                aListView.Items[i] := 'Not Checked ' + TOrder(aListView.Items.Objects[i]).Text;
          end;

      if aListView.ItemIndex >= 0 then
        aListView.Selected[aListView.ItemIndex] := True;
    end;
end;

end.
