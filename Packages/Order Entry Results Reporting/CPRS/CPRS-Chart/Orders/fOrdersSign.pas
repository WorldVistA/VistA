unit fOrdersSign;

{ .$define debug }

interface

uses
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
  UBAGlobals,
  UBACore,
  UBAMessages,
  UBAConst,
  Menus,
  ORClasses,
  fBase508Form,
  fPrintLocation,
  fCSRemaining,
  VA508AccessibilityManager,
  rODMeds;

type
  TfrmSignOrders = class(TfrmBase508Form)
    laDiagnosis: TLabel;
    gbdxLookup: TGroupBox;
    buOrdersDiagnosis: TButton;
    poBACopyPaste: TPopupMenu;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Diagnosis1: TMenuItem;
    Exit1: TMenuItem;
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
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clstOrdersDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure clstOrdersMeasureItem(Control: TWinControl; Index: Integer; var AHeight: Integer);
    procedure clstOrdersClickCheck(Sender: TObject);
    procedure clstOrdersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure buOrdersDiagnosisClick(Sender: TObject);
    function IsSignatureRequired: boolean;
    procedure Exit1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure clstOrdersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure clstOrdersClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure fraCoPaylblHNCMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure fraCoPayLabel23Enter(Sender: TObject);
    procedure fraCoPayLabel23Exit(Sender: TObject);
    procedure clstOrdersKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure clstCSOrdersClick(Sender: TObject);
    procedure clstCSOrdersClickCheck(Sender: TObject);
    procedure clstCSOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure clstCSOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormPaint(Sender: TObject);
  private
    OKPressed: boolean;
    ESCode: string;
    FLastHintItem: Integer;
    FOldHintPause: Integer;
    FOldHintHidePause: Integer;
    function ItemsAreChecked: boolean;
    function CSItemsAreChecked: boolean;
    function nonDCCSItemsAreChecked: boolean;
    function AnyItemsAreChecked: boolean;
    function GetNumberOfSelectedOrders: byte;
    procedure ShowTreatmentFactorHints(var pHintText: string; var pCompName: TVA508StaticText); // 508
    procedure SetItemTextToState;
    procedure FormatListForScreenReader;
  public
    procedure SetCheckBoxStatus(thisOrderID: string);
    function GetCheckBoxStatus(sourceOrderID: string): string; overload;

  end;

  { Begin BillingAware }
  TarRect = array [MIN_RECT .. MAX_RECT] of TRect;

var
  thisRect: TRect;
  j: shortint;
  ARect: TRect;
  arRect: TarRect;
  ProvDx: TProvisionalDiagnosis;
  FOSTFHintWndActive: boolean;
  FOSTFhintWindow: THintWindow;
  tempList: TList;
  tempCSList: TList;

  { End BillingAware }

  { Forward } function ExecuteSignOrders(SelectedList: TList): boolean;

var
  rectIndex: Integer;

  { Begin BillingAware }
  frmSignOrders: TfrmSignOrders;
  chkBoxStatus: string;
  srcOrderID: string;
  targetOrderID: string;
  tempStrList: TStringList;
  srcDx: string;
  tempBillableList: TStringList;
  tempOrderList: TStringList;
  copyOrderID: string;
  srcIndex: Integer;
  CopyBuffer: TBADxRecord;
  { End BillingAware }

implementation

{$R *.DFM}

uses
  XWBHash,
  rCore,
  rOrders,
  uConst,
  fOrdersPrint,
  uCore,
  uOrders,
  uSignItems,
  fOrders,
  fPCELex,
  rPCE,
  fODConsult,
  fBALocalDiagnoses,
  fClinicWardMeds,
  fFrame,
  rODLab,
  fRptBox,
  VAUtils,
  System.Types,
  System.UITypes;

const
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR = 'Error Saving Order';

function TfrmSignOrders.GetNumberOfSelectedOrders: byte;
{
  - Return the number of orders in clstOrders that are currently selected.
}
var
  i: Integer;
  numSelected: byte;
begin
  Result := 0;
  if BILLING_AWARE then
    begin
      numSelected := 0;

      try
        for i := 0 to fOrdersSign.frmSignOrders.clstOrders.Items.Count - 1 do
          if (fOrdersSign.frmSignOrders.clstOrders.Selected[i]) then
            Inc(numSelected);
      except
        on EListError do
          begin
            // {$ifdef debug}Show508Message('EListError in frmSignOrders.GetNumberOfSelectedOrders()');{$endif}
            raise;
          end;
      end;

      Result := numSelected;
    end;
end;

procedure TfrmSignOrders.SetCheckBoxStatus(thisOrderID: string);
{
  - Set the current GRID checkboxes status
}
begin
  if BILLING_AWARE then
    begin
      uSignItems.uSigItems.SetSigItems(clstOrders, thisOrderID);
    end;
end;

function TfrmSignOrders.GetCheckBoxStatus(sourceOrderID: string): string; // PASS IN ORDER ID - NOT GRID INDEX
{
  - Obtain checkbox status for selected order - BY ORDER ID
}
var
  itemsList: TStringList;
  i: smallint;
  thisOrderID: string;
begin
  Result := '';
  itemsList := TStringList.Create;
  itemsList.Clear;
  itemsList := uSigItems.GetSigItems; // Get FItems list
  if BILLING_AWARE then
    begin
      try
        for i := 0 to itemsList.Count - 1 do
          begin
            thisOrderID := Piece(itemsList[i], '^', 1); // get the order ID
            if thisOrderID = sourceOrderID then // compare to order ID of source order
              begin
                Result := Piece(itemsList[i], U, 4); // return TF status'
                Break;
              end;
          end;
      except
        on EListError do
          begin
            // {$ifdef debug}Show508Message('EListError in frmSignOrders.GetCheckBoxStatus()');{$endif}
            raise;
          end;
      end;
    end;
end;

function ExecuteSignOrders(SelectedList: TList): boolean;
const
  VERT_SPACING = 6;

var
  i, {k,} cidx, cnt, theSts, WardIEN: Integer;
  ShrinkHeight: Integer;
  SignList: TStringList;
  CSSignList: TStringList;
  Obj: TOrder;
  ContainsIMOOrders, DoNotPrint, t1, t2: boolean;
  cSignature, cHashData, cCrlUrl, cErr, WardName: string;
  OrderText, ASvc: string;
  PrintLoc: Integer;
  AList, ClinicList, OrderPrintList, WardList: TStringList;
  EncLocName, EncLocText: string;
  EncLocIEN: Integer;
  EncDT: TFMDateTime;
  EncVC: Char;
  CSSelectedList: TList;
  CSOrder: boolean;
  DEACheck: string;
  aPKIEncryptionEngine: IPKIEncryptionEngine;
  aPKIEncryptionDataDEAOrder: IPKIEncryptionDataDEAOrder;
  aMessage, successMsg: string;

  // ChangeItem: TChangeItem;

  function FindOrderText(const AnID: string): string;
  var
    i: Integer;
  begin
    Result := '';
    fOrdersSign.tempList := SelectedList;
    fOrdersSign.tempCSList := CSSelectedList;
    with SelectedList do
      for i := 0 to Count - 1 do
        with TOrder(Items[i]) do
          if ID = AnID then
            begin
              Result := Text;
              Break;
            end;
    with CSSelectedList do
      for i := 0 to Count - 1 do
        with TOrder(Items[i]) do
          if ID = AnID then
            begin
              Result := Text;
              Break;
            end;
  end;

  function SignNotRequired: boolean;
  var
    i: Integer;
  begin
    Result := True;
    tempList := SelectedList;
    tempCSList := CSSelectedList;
    with SelectedList do
      for i := 0 to Pred(Count) do
        begin
          with TOrder(Items[i]) do
            if Signature <> OSS_NOT_REQUIRE then
              Result := False;
        end;
    // with CSSelectedList do for i := 0 to Pred(Count) do
    // begin
    // with TOrder(Items[i]) do if Signature <> OSS_NOT_REQUIRE then Result := False;
    // end;
  end;

  function DigitalSign: boolean;
  var
    i: Integer;
  begin
    Result := False;

    with SelectedList do
      for i := 0 to Pred(Count) do
        begin
          with TOrder(Items[i]) do
            if Copy(DigSigReq, 1, 1) = '2' then
              Result := True;
        end;
    with CSSelectedList do
      for i := 0 to Pred(Count) do
        begin
          with TOrder(Items[i]) do
            if Copy(DigSigReq, 1, 1) = '2' then
              Result := True;
        end;
  end;

  function Piece2end(s, del: string): string;
  var
    i: Integer;
  begin
    i := Pos(del, s);
    Result := Copy(s, i + 1, length(s));
  end;

begin
  CSSelectedList := SelectedList;
  Result := False;
  PrintLoc := 0;
  EncLocIEN := 0;
  DoNotPrint := False;
  if BILLING_AWARE then
    begin
      tempOrderList := TStringList.Create;
      tempOrderList.Clear;
    end;
  frmSignOrders := TfrmSignOrders.Create(Application);

  CallV('ORDEA DEATEXT', []);
  frmSignOrders.lblDEAText.Caption := '';
  for i := 0 to RPCBrokerV.Results.Count - 1 do
    frmSignOrders.lblDEAText.Caption := frmSignOrders.lblDEAText.Caption + ' ' + RPCBrokerV.Results.Strings[i];

  CallV('ORDEA SIGINFO', [Patient.DFN, User.DUZ]);
  frmSignOrders.lblProvInfo.Caption := RPCBrokerV.Results.Text;
  // frmSignOrders.lblProvInfo.Caption := '';
  // for i := 0 to RPCBrokerV.Results.Count - 1 do
  // frmSignOrders.lblProvInfo.Caption := frmSignOrders.lblProvInfo.Caption + #13#10 + RPCBrokerV.Results.Strings[i];

  try
    // ResizeAnchoredFormToFont(frmSignOrders);
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
              if BILLING_AWARE then
                tempOrderList.Add(Obj.ID);
              frmSignOrders.clstOrders.Checked[cidx] := True;

              if (TOrder(Items[i]).DGroupName) = NonVAMedGroup then
                frmSignOrders.clstOrders.State[cidx] := cbGrayed;
            end;
        end;

    with CSSelectedList do
      for i := 0 to Count - 1 do
        begin
          Obj := TOrder(Items[i]);
          if (Obj.IsControlledSubstance and Obj.IsOrderPendDC) then
            begin
              cidx := frmSignOrders.clstOrders.Items.AddObject(Obj.Text, Obj);
              SigItems.Add(CH_ORD, Obj.ID, cidx);
              if BILLING_AWARE then
                tempOrderList.Add(Obj.ID);
              frmSignOrders.clstOrders.Checked[cidx] := True;

              if (TOrder(Items[i]).DGroupName) = NonVAMedGroup then
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
                  if BILLING_AWARE then
                    tempOrderList.Add(Obj.ID);
                  if TOrder(Items[i]).IsOrderPendDC then
                    frmSignOrders.clstCSOrders.Checked[cidx] := True
                  else
                    frmSignOrders.clstCSOrders.Checked[cidx] := False;

                  if (TOrder(Items[i]).DGroupName) = NonVAMedGroup then
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
    SigItems.ClearFcb;

    SigItemsCS.ClearDrawItems;
    SigItemsCS.ClearFcb;

    t1 := SigItems.UpdateListBox(frmSignOrders.clstOrders);
    t2 := SigItemsCS.UpdateListBox(frmSignOrders.clstCSOrders);
    if t1 or t2 then
      frmSignOrders.fraCoPay.Visible := True
    else
      begin
        { Begin BillingAware }
        if BILLING_AWARE then
          frmSignOrders.gbdxLookup.Visible := False;
        { End BillingAware }
      end;

    if SignNotRequired then
      begin
        frmSignOrders.lblESCode.Visible := False;
        frmSignOrders.txtESCode.Visible := False;
      end;

    if BILLING_AWARE then
      begin
        // build list of orders that are not billable based on order type
        UBAGlobals.NonBillableOrderList := rpcNonBillableOrders(tempOrderList);
      end;

    with frmSignOrders do
      begin
        pnlDEAText.Visible := True;
        txtESCode.Text := '';
        if ((clstOrders.Count = 0) and (clstCSOrders.Count = 0)) then
          Exit;

        pnlProvInfo.Height := lblProvInfo.Height + 5 + lblProvInfo.Top;
        // TotalSH := 0;

        if clstCSOrders.Count = 0 then
          begin
            // oheight := pnlOrderList.Height;
            pnlProvInfo.Visible := False;
            if fraCoPay.Visible = False then
              begin
                pnlTop.Visible := False;
              end;
            pnlDEAText.Visible := False;
            pnlCSOrderList.Visible := False;
            pnlOrderList.Align := alClient;
            // newheight := Height - pnlOrderList.Height + oheight;
            // if newheight < Constraints.MinHeight then
            // Constraints.MinHeight := newheight;
            // Height := newheight;
          end
        else if clstOrders.Count = 0 then
          begin
            // oheight := pnlCSOrderList.Height;
            pnlOrderList.Visible := False;
            pnlCSOrderList.Align := alClient;
            // newheight := Height - pnlCSOrderList.Height + oheight;
            // if newheight < Constraints.MinHeight then
            // Constraints.MinHeight := newheight;
            // Height := newheight;
            txtESCode.Visible := False;
            lblESCode.Visible := False;

          end
        else if fraCoPay.Visible = False then
          begin
            fraCoPay.Visible := True;
            ShrinkHeight := fraCoPay.Height - pnlProvInfo.Height;
            fraCoPay.Visible := False;

            pnlTop.Height := pnlTop.Height - ShrinkHeight;
            // pnlCombined.Top := pnlCombined.Top - ShrinkHeight;
            // pnlCombined.Height := pnlCombined.Height + ShrinkHeight;
          end;

        lblDEAText.Visible := False;
        lblSmartCardNeeded.Visible := False;
      end;

    if frmSignOrders.AnyItemsAreChecked then
      begin
        frmSignOrders.lblESCode.Visible := frmSignOrders.IsSignatureRequired;
        frmSignOrders.txtESCode.Visible := frmSignOrders.IsSignatureRequired
      end;

    if frmSignOrders.txtESCode.Visible then
      frmSignOrders.ActiveControl := frmSignOrders.txtESCode;

    frmSignOrders.OnResize(nil);
    frmSignOrders.pnlCombined.Invalidate;

    frmSignOrders.ShowModal;

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
                      if TOrder(Items[i]).DGroupName = NonVAMedGroup then
                        frmSignOrders.clstOrders.Checked[cidx] := True; // Non VA MEDS
                      if frmSignOrders.clstOrders.Checked[cidx] then
                        begin
                          UpdateOrderDGIfNeeded(ID);
                          SignList.Add(ID + U + SS_ESIGNED + U + RS_RELEASE + U + NO_PROVIDER);
                          BAOrderList.Add(TOrder(Items[i]).ID);
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
                              BAOrderList.Add(TOrder(Items[i]).ID);
                            end
                          else
                            begin
                              // UpdateOrderDGIfNeeded(ID);
                              CSSignList.Add(ID + U + SS_DIGSIG + U + RS_RELEASE + U + NO_PROVIDER);
                              // BAOrderList.Add(TOrder(Items[i]).ID);
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
                CallV('ORDEA LNKMSG', []);
                for i := 0 to RPCBrokerV.Results.Count - 1 do
                  begin
                    successMsg := successMsg + CRLF + RPCBrokerV.Results.Strings[i];
                  end;
                if not IsDigitalSignatureAvailable(aPKIEncryptionEngine, aMessage, successMsg) then
                  raise Exception.Create('There was a problem linking your PIV card. Either the '
                    + 'PIV card name does NOT match your VistA account name or the PIV card is already '
                    + 'linked to another VistA account.  Ensure that the correct PIV card has '
                    + 'been inserted for your VistA account. Please contact your PIV Card Coordinator '
                    + 'if you continue to have problems.')
                else
                  fframe.frmFrame.DigitalSigningSetup1.Visible := False;

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
                                BAOrderList.Add(Piece(CSSignList.Strings[i], U, 1));
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
                  ShowMsg('Error: ' + e.Message);
              end;
            end;
          aPKIEncryptionEngine := nil;
          aPKIEncryptionDataDEAOrder := nil;

          StatusText('Sending Orders to Service(s)...');
          if SignList.Count > 0 then
            begin
              // hds7591  Clinic/Ward movement.  Patient Admission IMO
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
                          if ((CSOrder = False) and (frmSignOrders.clstOrders.Checked[cidx] = False)) or (CSOrder and (frmSignOrders.clstCSOrders.Checked[cidx] = False)) then
                            continue;
                          if (TOrder(SelectedList.Items[i]).DGroupName = 'Clinic Medications') or (TOrder(SelectedList.Items[i]).DGroupName = 'Clinic Infusions') then
                            ContainsIMOOrders := True;
                          if TOrder(SelectedList.Items[i]).DGroupName = '' then
                            continue;
                          if (Pos('DC', TOrder(SelectedList.Items[i]).ActionOn) > 0) or
                            (TOrder(SelectedList.Items[i]).IsOrderPendDC = True) then
                            begin
                              WardList.Add(TOrder(SelectedList.Items[i]).ID);
                              continue;
                            end;
                          // ChangeItem := Changes.Locate(20,TOrder(SelectedList.Items[i]).ID);
                          // if ChangeItem = nil then continue;
                          // if ChangeItem.Delay = true then continue;
                          if TOrder(SelectedList.Items[i]).IsDelayOrder = True then
                            continue;
                          OrderPrintList.Add(TOrder(SelectedList.Items[i]).ID + ':' + TOrder(SelectedList.Items[i]).Text);
                        end;
                      if OrderPrintList.Count > 0 then
                        begin
                          frmPrintLocation.PrintLocation(OrderPrintList, EncLocIEN, EncLocName, EncLocText, EncDT, EncVC, ClinicList,
                            WardList, WardIEN, WardName, ContainsIMOOrders, True);
                          // fframe.frmFrame.OrderPrintForm := false;
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
  tempList := TList.Create;
  tempCSList := TList.Create;

  { Begin BillingAware }
  // This is the DIAGNOSIS label above the Dx column
  if BILLING_AWARE then
    begin
      clstOrders.Height := 228;
      clstOrders.Top := (gbdxLookup.Top + 65);
      gbdxLookup.Visible := True;
      lblOrderList.Top := (gbdxLookup.Top + gbdxLookup.Height);
      laDiagnosis.Top := lblOrderList.Top;
      laDiagnosis.Left := 270;
      laDiagnosis.Visible := True;
      rectIndex := 0;
    end
  else
    begin
      // lblOrderList.Top := 158;
      // lblOrderList.Left := 8;
    end;
  { End BillingAware }

end;

function TfrmSignOrders.IsSignatureRequired: boolean;
var
  i: Integer;
begin
  Result := False;
  //
  // with tempList do for i := 0 to Pred(Count) do
  // begin
  // if frmSignOrders.clstOrders.Checked[i] then
  // begin
  // with TOrder(Items[i]) do if Signature <> OSS_NOT_REQUIRE then
  // Result := TRUE;
  // end;
  // end;
  with frmSignOrders.clstOrders do
    for i := 0 to Items.Count - 1 do
      begin
        if frmSignOrders.clstOrders.Checked[i] then
          begin
            with TOrder(Items[i]) do
              if Signature <> OSS_NOT_REQUIRE then
                Result := True;
          end;
      end;
  with frmSignOrders.clstCSOrders do
    for i := 0 to Items.Count - 1 do
      begin
        if frmSignOrders.clstCSOrders.Checked[i] then
          begin
            with TOrder(Items[i]) do
              if Signature <> OSS_NOT_REQUIRE then
                Result := True;
          end;
      end;
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

  { Begin BillingAware }
  if BILLING_AWARE then
    begin
      if SigItems.OK2SaveSettings then

        if not UBACore.BADxEntered then // if Dx have been entered and OK is pressed
          begin // billing data will be saved. otherwise error message!
            InfoBox(TX_NO_DX, 'Sign Orders', MB_OK);
            Exit;
          end;
    end;
  { End BillingAware }

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
  // CSRemaining(frmSignOrders.clstOrders.items,frmSignOrders.clstCSOrders.items);
end;

procedure TfrmSignOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  Application.HintPause := FOldHintPause;
  Application.HintHidePause := FOldHintHidePause;
end;

procedure TfrmSignOrders.clstOrdersDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  { Begin BillingAware }
  str: string;
  tempID: string;
  thisRec: UBAGlobals.TBADxRecord;
  { End BillingAware }

  X: string;
  ARect: TRect;
begin
  inherited;
  X := '';
  ARect := Rect;

  { Begin BillingAware }
  if BILLING_AWARE then
    begin
      with clstOrders do
        begin
          if Index < Items.Count then
            begin
              Canvas.FillRect(ARect);
              Canvas.Pen.Color := Get508CompliantColor(clSilver);
              Canvas.MoveTo(ARect.Left, ARect.Bottom);
              Canvas.LineTo(ARect.Right, ARect.Bottom);
              X := FilteredString(Items[Index]);
              ARect.Right := ARect.Right - 50; // 50 to 40
              // Vertical column line
              Canvas.MoveTo(ARect.Right, Rect.Top);
              Canvas.LineTo(ARect.Right, Rect.Bottom);
              // Adjust position of 'Diagnosis' column label for font size
              laDiagnosis.Left := ARect.Right + 14;
              if uSignItems.GetAllBtnLeftPos > 0 then
                laDiagnosis.Left := uSignItems.GetAllBtnLeftPos - (laDiagnosis.Width + 5);
              // ARect.Right below controls the right-hand side of the Dx Column
              // Adjust ARect.Right in conjunction with procedure uSignItems.TSigItems.lbDrawItem(), because the
              // two rectangles overlap each other.
              if BILLING_AWARE then
                begin
                  arRect[Index] := Classes.Rect(ARect.Right + 2, ARect.Top, ARect.Right + 108, ARect.Bottom);
                  Canvas.FillRect(arRect[Index]);
                end;

              // Win32 API - This call to DrawText draws the text of the ORDER - not the diagnosis code
              DrawText(Canvas.handle, PChar(X), length(X), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
              if BILLING_AWARE then
                begin
                  if Assigned(UBAGlobals.tempDxList) then
                    begin
                      tempID := TOrder(clstOrders.Items.Objects[Index]).ID;

                      if UBAGlobals.tempDxNodeExists(tempID) then
                        begin
                          thisRec := TBADxRecord.Create;
                          UBAGlobals.GetBADxListForOrder(thisRec, tempID);
                          str := Piece(thisRec.FBADxCode, '^', 1);
                          { v25 BA }
                          str := Piece(str, ':', 1);
                          DrawText(Canvas.handle, PChar(str), length(str), arRect[Index], DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                          if not UBACore.IsOrderBillable(tempID) then
                            begin
                              Canvas.Font.Color := clBlue;
                              DrawText(Canvas.handle, PChar(NOT_APPLICABLE), length(NOT_APPLICABLE), { Length(str), } arRect[Index], DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                            end;
                        end
                      else
                        begin
                          // determine if order is billable, if NOT then insert NA in Dx field
                          if not UBACore.IsOrderBillable(tempID) then
                            begin
                              Canvas.Font.Color := clBlue;
                              DrawText(Canvas.handle, PChar(NOT_APPLICABLE), length(NOT_APPLICABLE), { Length(str), } arRect[Index], DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                            end;
                        end;
                    end;
                end;

            end;
        end;
    end
  else
    begin
      X := '';
      ARect := Rect;
      with clstOrders do
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
  { End BillingAware }
end;

procedure TfrmSignOrders.clstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  X: string;
  ARect: TRect;
begin
  inherited;
  AHeight := SigItemHeight;
  with clstOrders do
    if Index < Items.Count then
      begin
        ARect := ItemRect(Index);
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

  procedure updateAllChilds(CheckedStatus: boolean; ParentOrderId: string);
  var
    idx: Integer;
  begin
    for idx := 0 to clstOrders.Items.Count - 1 do
      if TOrder(clstOrders.Items.Objects[idx]).ParentID = ParentOrderId then
        begin
          if clstOrders.Checked[idx] <> CheckedStatus then
            begin
              clstOrders.Checked[idx] := CheckedStatus;
              SigItems.EnableSettings(idx, clstOrders.Checked[idx]);
            end;
        end;
  end;

begin
  with clstOrders do
    begin
      if length(TOrder(Items.Objects[ItemIndex]).ParentID) > 0 then
        begin
          SigItems.EnableSettings(ItemIndex, Checked[ItemIndex]);
          updateAllChilds(Checked[ItemIndex], TOrder(Items.Objects[ItemIndex]).ParentID);
        end
      else
        SigItems.EnableSettings(ItemIndex, Checked[ItemIndex]);
    end;
  if ItemsAreChecked then
    begin
      lblESCode.Visible := IsSignatureRequired;
      txtESCode.Visible := IsSignatureRequired
    end
  else
    begin
      lblESCode.Visible := ItemsAreChecked or CSItemsAreChecked;
      txtESCode.Visible := ItemsAreChecked or CSItemsAreChecked;
    end;

  if txtESCode.Visible then
    txtESCode.SetFocus;

end;

function TfrmSignOrders.ItemsAreChecked: boolean;
{ return true if any items in the Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;

  with clstOrders do
    for i := 0 to Items.Count - 1 do
      if Checked[i] then
        begin
          Result := True;
          Break;
        end;
end;

function TfrmSignOrders.CSItemsAreChecked: boolean;
{ return true if any items in the Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;

  with clstCSOrders do
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
  Result := ItemsAreChecked or CSItemsAreChecked;
end;

procedure TfrmSignOrders.clstOrdersMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Itm: Integer;
  { Begin BillingAware }
  thisRec: UBAGlobals.TBADxRecord;
  i: smallint;
  thisOrderID: string;
  { End BillingAware }
begin
  inherited;
  Itm := clstOrders.ItemAtPos(Point(X, Y), True);
  if (Itm >= 0) then
    begin
      if (Itm <> FLastHintItem) then
        begin
          Application.CancelHint;
          { Begin BillingAware }
          if BILLING_AWARE then
            begin
              // Billing Awareness 'flyover' hint includes Dx code(s) when Dx code(s) have been assigned to an order
              thisOrderID := TChangeItem(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[Itm]).ID;

              if UBAGlobals.tempDxNodeExists(thisOrderID) then
                begin
                  if Assigned(tempDxList) then
                    try
                      for i := 0 to (tempDxList.Count - 1) do
                        begin
                          thisRec := TBADxRecord(tempDxList.Items[i]);

                          if Assigned(thisRec) then
                            if (thisRec.FOrderID = thisOrderID) then
                              begin
                                with thisRec do
                                  begin
                                    FBADxCode := StringReplace(thisRec.FBADxCode, '^', ':', [rfReplaceAll]);
                                    FBASecDx1 := StringReplace(thisRec.FBASecDx1, '^', ':', [rfReplaceAll]);
                                    FBASecDx2 := StringReplace(thisRec.FBASecDx2, '^', ':', [rfReplaceAll]);;
                                    FBASecDx3 := StringReplace(thisRec.FBASecDx3, '^', ':', [rfReplaceAll]);
                                  end;

                                clstOrders.Hint := TrimRight(clstOrders.Items[Itm] + #13 +
                                  thisRec.FBADxCode + #13 + thisRec.FBASecDx1 + #13 + thisRec.FBASecDx2 + #13 + thisRec.FBASecDx3);
                              end
                        end
                    except
                      on EListError do
                        begin
                          // {$ifdef debug}Show508Message('EListError in frmSignOrders.clstOrdersMouseMove()');{$endif}
                          raise;
                        end;
                    end;

                end
              else
                clstOrders.Hint := TrimRight(clstOrders.Items[Itm]);
            end;
          { End BillingAware }
          FLastHintItem := Itm;
          Application.ActivateHint(Point(X, Y));
        end;
    end
  else
    begin
      clstOrders.Hint := '';
      FLastHintItem := -1;
      Application.CancelHint;
    end;
end;

procedure TfrmSignOrders.FormShow(Sender: TObject);
begin
  { Begin BillingAware }

  // if (clstOrders.Top + clstOrders.Height) > (lblESCode.Top - 4) then
  // clstOrders.Height := lblESCode.Top - clstOrders.Top - 4;

  // INITIALIZATIONS
  Paste1.Enabled := False;
  fOrdersSign.srcOrderID := '';
  fOrdersSign.srcDx := '';
  if txtESCode.Visible then
    frmSignOrders.txtESCode.SetFocus;

  if BILLING_AWARE then
    begin
      // List to contain loading OrderID's
      if not Assigned(UBAGlobals.OrderIDList) then
        UBAGlobals.OrderIDList := TStringList.Create;

      if BILLING_AWARE then
        begin
          clstOrders.Multiselect := True;
          clstCSOrders.Multiselect := True;
        end;

      with fraCoPay do
        begin
          lblSC2.Caption := 'Service &Connected Condition';
          lblCV2.Caption := 'Combat &Vet (Combat Related)';
          lblAO2.Caption := 'Agent &Orange Exposure';
          lblIR2.Caption := 'Ionizing &Radiation Exposure';
          lblSWAC2.Caption := '&Environmental Contaminants';
          lblMST2.Caption := '&MST';
          lblHNC2.Caption := '&Head and/or Neck Cancer';
          lblSHAD2.Caption := 'Shi&pboard Hazard and Defense';
          lblCL2.Caption := 'Camp &Lejeune';
          lblSC2.ShowAccelChar := True;
          lblCV2.ShowAccelChar := True;
          lblAO2.ShowAccelChar := True;
          lblIR2.ShowAccelChar := True;
          lblSWAC2.ShowAccelChar := True;
          lblMST2.ShowAccelChar := True;
          lblHNC2.ShowAccelChar := True;
          lblSHAD2.ShowAccelChar := True;
          lblCL2.ShowAccelChar := True;
        end;
    end; // BILLING_AWARE

  clstOrders.TabOrder := 0; // CQ5057
  FormatListForScreenReader;

  // CQ5172
  if clstOrders.Count = 1 then
    begin
      clstOrders.Selected[0] := True;
      buOrdersDiagnosis.Enabled := True;
      Diagnosis1.Enabled := True;
      // if number of orders is 1 and order is billable select order and disable diagnosis button
      if not UBACore.IsOrderBillable(TChangeItem(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[0]).ID) then
        begin
          buOrdersDiagnosis.Enabled := False;
          Diagnosis1.Enabled := False;
          clstOrders.Selected[0] := False;
        end
      else
        if Piece(TChangeItem(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[0]).ID, ';', 2) = DISCONTINUED_ORDER then
        begin
          buOrdersDiagnosis.Enabled := False;
          Diagnosis1.Enabled := False;
        end;
    end;
  // end CQ5172
end;

{ Begin BillingAware }
// New BA Button....
procedure TfrmSignOrders.buOrdersDiagnosisClick(Sender: TObject);
var
  i: smallint;
  thisOrderID: string;
  match: boolean;
  allBlank: boolean;
  numSelected: smallint;
begin
  { Begin BillingAware }

  match := False;
  allBlank := False;
  if Assigned(OrderIDList) then
    OrderIDList.Clear;
  if Assigned(UBAGlobals.PLFactorsIndexes) then
    UBAGlobals.PLFactorsIndexes.Clear;
  if Assigned(BAtmpOrderList) then
    BAtmpOrderList.Clear;

  try
    // User has selected no orders to sign
    for i := 0 to fOrdersSign.frmSignOrders.clstOrders.Items.Count - 1 do
      begin
        if (fOrdersSign.frmSignOrders.clstOrders.Selected[i]) then
          begin
            thisOrderID := TChangeItem(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i]).ID;
            OrderIDList.Add(thisOrderID);
            { BAV25 Code }
            BAtmpOrderList.Add(TOrder(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i]).Text);
            // stringlist holding index and stsFactors
            UBAGlobals.PLFactorsIndexes.Add(IntToStr(i) + U + GetCheckBoxStatus(thisOrderID)); // store indexes and flags of selected orders
            { BAV25 Code }
            // Test for blank Dx on current grid item
            if not(tempDxNodeExists(thisOrderID)) then
              if Assigned(UBAGlobals.globalDxRec) then
                InitializeNewDxRec(UBAGlobals.globalDxRec);
            if (tempDxNodeExists(thisOrderID)) then
              begin
                // Create UBAGlobals.globalDxRec with loaded fields
                if not Assigned(UBAGlobals.globalDxRec) then
                  begin
                    UBAGlobals.globalDxRec := UBAGlobals.TBADxRecord.Create;
                    InitializeNewDxRec(UBAGlobals.globalDxRec);
                    GetBADxListForOrder(UBAGlobals.globalDxRec, thisOrderID);
                  end
                else
                  GetBADxListForOrder(UBAGlobals.globalDxRec, thisOrderID);

{$IFDEF debug}

                with UBAGlobals.globalDxRec do
                  // Show508Message('globalDxRec:'+#13+FOrderID+#13+FBADxCode+#13+FBASecDx1+#13+FBASecDx2+#13+FBASecDx3);

{$ENDIF}

              end;
          end; // if
      end; // for
  except
    on E: Exception do
      ShowMsg(E.ClassName + ' error raised, with message : ' + E.Message);
  end;

  numSelected := CountSelectedOrders(UBAConst.F_ORDERS_SIGN);

  if numSelected = 0 then
    begin
      ShowMsg(UBAMessages.BA_NO_ORDERS_SELECTED);
      Exit;
    end
  else
    if numSelected = 1 then
    match := True;

  if (UBAGlobals.CompareOrderDx(UBAConst.F_ORDERS_SIGN)) then
    match := True;

  if UBAGlobals.AllSelectedDxBlank(UBAConst.F_ORDERS_SIGN) then
    allBlank := True;

  if ((match and allBlank) or (match and (not allBlank))) then // All selected are blank or matching-not-blank
    frmBALocalDiagnoses.Enter(UBAConst.F_ORDERS_SIGN, OrderIDList)
  else
    begin
      // Warning message
      // If 'Yes' on warning message then open localDiagnosis
      if (not allBlank) then
        if MessageDlg(UBAMessages.BA_CONFIRM_DX_OVERWRITE, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          Exit
        else
          if Assigned(UBAGlobals.globalDxRec) then
          InitializeNewDxRec(UBAGlobals.globalDxRec);
      frmBALocalDiagnoses.Enter(UBAConst.F_ORDERS_SIGN, OrderIDList);
    end;
  // TFactors come from FBALocalDiagnoses(Problem List Dx's Only).
  if length(UBAGlobals.TFactors) > 0 then
    begin
      UBACore.SetTreatmentFactors(UBAGlobals.TFactors);
      SigItems.DisplayPlTreatmentFactors;
    end;
  { End BillingAware }
  txtESCode.SetFocus;
end;

procedure TfrmSignOrders.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSignOrders.Copy1Click(Sender: TObject);
{
  - Copy contents of the 'source' order for copy/paste operation
}
var
  i: byte;
  numSelected: byte;
  thisChangeItem: TChangeItem;
begin
  try
    if BILLING_AWARE then
      begin
        Paste1.Enabled := True;

        numSelected := GetNumberOfSelectedOrders;

        if numSelected > 1 then
          begin
            ShowMsg('Only 1 order at a time may be selected for ''Copying''');
            Exit;
          end;

        for i := 0 to fOrdersSign.frmSignOrders.clstOrders.Items.Count - 1 do
          if (fOrdersSign.frmSignOrders.clstOrders.Selected[i]) then
            begin
              thisChangeItem := TChangeItem.Create;
              thisChangeItem := nil;
              thisChangeItem := TChangeItem(clstOrders.Items.Objects[i]);
              // Skip this one if it's a "header" on the grid
              if (thisChangeItem = nil) then // or (thisChangeItem.ItemType <> CH_ORD)) then
                begin
                  FreeAndNil(thisChangeItem);
                  Exit;
                end;

              fOrdersSign.srcOrderID := TChangeItem(frmSignOrders.clstOrders.Items.Objects[i]).ID;

              // Copy source order to COPY BUFFER and add it to the Dx List
              CopyBuffer := TBADxRecord.Create;
              InitializeNewDxRec(CopyBuffer);
              GetBADxListForOrder(CopyBuffer, fOrdersSign.srcOrderID);
              fOrdersSign.CopyBuffer.FOrderID := BUFFER_ORDER_ID;
              UBAGlobals.tempDxList.Add(CopyBuffer);

              // *************************************************************************
              if (not UBACore.IsOrderBillable(fOrdersSign.srcOrderID)) then // and
                // added to allow copy to NON CIDC consult order the requires a DX. then
                begin
                  ShowMsg(BA_NA_COPY_DISALLOWED);
                  fOrdersSign.srcOrderID := '';
                  Exit;
                end;
              // *************************************************************************

              fOrdersSign.srcIndex := clstOrders.ItemIndex;
              fOrdersSign.chkBoxStatus := GetCheckBoxStatus(fOrdersSign.srcOrderID);
              Break;
            end;
      end; // if BILLING_AWARE
  except
    on EListError do
      begin
        ShowMsg('EListError in frmSignOrders.Copy1Click()');
        raise;
      end;
  end;
end;

procedure TfrmSignOrders.Paste1Click(Sender: TObject);
{
  - Populate 'target' orders of a copy/paste operation with contents of 'source' order
}
var
  i: byte;
  newRec: TBADxRecord;
begin
  if BILLING_AWARE then
    begin
      if not Assigned(fOrdersSign.CopyBuffer) then // CQ5414
        fOrdersSign.CopyBuffer := TBADxRecord.Create; // CQ5414

      try
        for i := 0 to clstOrders.Count - 1 do
          begin
            if (fOrdersSign.frmSignOrders.clstOrders.Selected[i]) then
              begin
                fOrdersSign.targetOrderID := TChangeItem(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i]).ID;

                if fOrdersSign.targetOrderID = fOrdersSign.srcOrderID then // disallow copying an order to itself
                  continue
                else
                  begin
                    fOrdersSign.CopyBuffer.FOrderID := BUFFER_ORDER_ID;

                    // ***************************************************************
                    if not UBACore.IsOrderBillable(targetOrderID) then
                      begin
                        ShowMsg(BA_NA_PASTE_DISALLOWED);
                        fOrdersSign.targetOrderID := '';
                        continue;
                      end;
                    // ***************************************************************

                    newRec := TBADxRecord.Create;
                    with newRec do
                      begin
                        FOrderID := fOrdersSign.targetOrderID;
                        FBADxCode := CopyBuffer.FBADxCode;
                        FBASecDx1 := CopyBuffer.FBASecDx1;
                        FBASecDx2 := CopyBuffer.FBASecDx2;
                        FBASecDx3 := CopyBuffer.FBASecDx3;
                      end;

                    tempDxList.Add(newRec);

                    CopyTFCIToTargetOrder(fOrdersSign.targetOrderID, fOrdersSign.chkBoxStatus);
                    SetCheckBoxStatus(fOrdersSign.targetOrderID); // calls uSignItems.SetSigItems()
                  end;
              end;
          end;
      except
        on EListError do
          begin
            ShowMsg('EListError in frmSignOrders.Paste1Click()' + #13 + 'for i := 0 to clstOrders.Count - 1 do');
            raise;
          end;
      end;
      clstOrders.Refresh; // Update grid to show pasted Dx
    end;
end;

procedure TfrmSignOrders.clstOrdersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{
  - Open copy/paste popup menu.
}
var
  ClientPoint: TPoint;
  ScreenPoint: TPoint;
begin
  if not BILLING_AWARE then
    clstOrders.PopupMenu := nil;

  if BILLING_AWARE then
    begin
      try
        if Button = mbRight then // Right-click to open copy/paste popup menu
          begin
            // CQ3325
            if fOrdersSign.frmSignOrders.clstOrders.Items.Count = 1 then
              begin
                Copy1.Enabled := False;
                Paste1.Enabled := False
              end
            else
              begin
                Copy1.Enabled := True;
              end;
            // End CQ3325

            if not frmSignOrders.clstOrders.Selected[clstOrders.ItemIndex] then
              (Sender as TCheckListBox).Selected[clstOrders.ItemIndex] := True;

            ClientPoint.X := X;
            ClientPoint.Y := Y;
            ScreenPoint := clstOrders.ClientToScreen(ClientPoint);
            poBACopyPaste.Popup(ScreenPoint.X, ScreenPoint.Y);
          end;
      except
        on EListError do
          begin
            ShowMsg('EListError in frmSignOrders.clstOrdersMouseDown()');
            raise;
          end;
      end;
    end;
end;

procedure TfrmSignOrders.clstCSOrdersClick(Sender: TObject);
// If grid item is an order-able item, then enable the Diagnosis button
// else disable the Diagnosis button.
var
  thisChangeItem: TChangeItem;
  i: smallint;
  thisOrderList: TStringList;
begin
  thisOrderList := TStringList.Create;

  { Begin BillingAware }
  if BILLING_AWARE then
    begin

      if clstCSOrders.Items.Count > 1 then
        Copy1.Enabled := True
      else
        Copy1.Enabled := False;

      for i := 0 to clstCSOrders.Items.Count - 1 do
        begin
          if clstCSOrders.Selected[i] then
            begin
              thisChangeItem := TChangeItem(clstCSOrders.Items.Objects[i]);

              // Disallow copying of a grid HEADER item on LEFT MOUSE CLICK
              if thisChangeItem = nil then
                begin
                  Copy1.Enabled := False;
                  buOrdersDiagnosis.Enabled := False;
                  Exit;
                end;

              if (thisChangeItem <> nil) then // Blank row - not an order item
                begin
                  thisOrderList.Clear;
                  thisOrderList.Add(thisChangeItem.ID);

                  if IsAllOrdersNA(thisOrderList) then
                    begin
                      Diagnosis1.Enabled := False;
                      buOrdersDiagnosis.Enabled := False;
                    end
                  else
                    begin
                      Diagnosis1.Enabled := True;
                      buOrdersDiagnosis.Enabled := True;
                    end
                end
              else
                begin
                  buOrdersDiagnosis.Enabled := False;
                  Diagnosis1.Enabled := False;
                  Break;
                end;
            end;
        end;

      if Assigned(thisOrderList) then
        thisOrderList.Free;
    end;
end;

procedure TfrmSignOrders.clstCSOrdersClickCheck(Sender: TObject);

  procedure updateAllChilds(CheckedStatus: boolean; ParentOrderId: string);
  var
    idx: Integer;
  begin
    for idx := 0 to clstCSOrders.Items.Count - 1 do
      if TOrder(clstCSOrders.Items.Objects[idx]).ParentID = ParentOrderId then
        begin
          if clstCSOrders.Checked[idx] <> CheckedStatus then
            begin
              clstCSOrders.Checked[idx] := CheckedStatus;
              SigItemsCS.EnableSettings(idx, clstCSOrders.Checked[idx]);
            end;
        end;
  end;

begin
  with clstCSOrders do
    begin
      if length(TOrder(Items.Objects[ItemIndex]).ParentID) > 0 then
        begin
          SigItemsCS.EnableSettings(ItemIndex, Checked[ItemIndex]);
          updateAllChilds(Checked[ItemIndex], TOrder(Items.Objects[ItemIndex]).ParentID);
        end
      else
        SigItemsCS.EnableSettings(ItemIndex, Checked[ItemIndex]);
    end;
  if CSItemsAreChecked and nonDCCSItemsAreChecked then
    begin
      lblDEAText.Visible := True;
      lblSmartCardNeeded.Visible := True;
    end
  else
    begin
      lblDEAText.Visible := False;
      lblSmartCardNeeded.Visible := False;
    end;
  if AnyItemsAreChecked then
    begin
      lblESCode.Visible := IsSignatureRequired;
      txtESCode.Visible := IsSignatureRequired
    end
  else
    begin
      lblESCode.Visible := ItemsAreChecked or CSItemsAreChecked;
      txtESCode.Visible := ItemsAreChecked or CSItemsAreChecked;
    end;
  if txtESCode.Visible then
    txtESCode.SetFocus;
end;

procedure TfrmSignOrders.clstCSOrdersDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  { Begin BillingAware }
  str: string;
  tempID: string;
  thisRec: UBAGlobals.TBADxRecord;
  { End BillingAware }

  X: string;
  ARect: TRect;
begin
  inherited;
  X := '';
  ARect := Rect;

  { Begin BillingAware }
  if BILLING_AWARE then
    begin
      with clstCSOrders do
        begin
          if Index < Items.Count then
            begin
              Canvas.FillRect(ARect);
              Canvas.Pen.Color := Get508CompliantColor(clSilver);
              Canvas.MoveTo(ARect.Left, ARect.Bottom);
              Canvas.LineTo(ARect.Right, ARect.Bottom);
              X := FilteredString(Items[Index]);
              ARect.Right := ARect.Right - 50; // 50 to 40
              // Vertical column line
              Canvas.MoveTo(ARect.Right, Rect.Top);
              Canvas.LineTo(ARect.Right, Rect.Bottom);
              // Adjust position of 'Diagnosis' column label for font size
              laDiagnosis.Left := ARect.Right + 14;
              if uSignItems.GetAllBtnLeftPos > 0 then
                laDiagnosis.Left := uSignItems.GetAllBtnLeftPos - (laDiagnosis.Width + 5);
              // ARect.Right below controls the right-hand side of the Dx Column
              // Adjust ARect.Right in conjunction with procedure uSignItems.TSigItems.lbDrawItem(), because the
              // two rectangles overlap each other.
              if BILLING_AWARE then
                begin
                  arRect[Index] := Classes.Rect(ARect.Right + 2, ARect.Top, ARect.Right + 108, ARect.Bottom);
                  Canvas.FillRect(arRect[Index]);
                end;

              // Win32 API - This call to DrawText draws the text of the ORDER - not the diagnosis code
              DrawText(Canvas.handle, PChar(X), length(X), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
              if BILLING_AWARE then
                begin
                  if Assigned(UBAGlobals.tempDxList) then
                    begin
                      tempID := TOrder(clstCSOrders.Items.Objects[Index]).ID;

                      if UBAGlobals.tempDxNodeExists(tempID) then
                        begin
                          thisRec := TBADxRecord.Create;
                          UBAGlobals.GetBADxListForOrder(thisRec, tempID);
                          str := Piece(thisRec.FBADxCode, '^', 1);
                          { v25 BA }
                          str := Piece(str, ':', 1);
                          DrawText(Canvas.handle, PChar(str), length(str), arRect[Index], DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                          if not UBACore.IsOrderBillable(tempID) then
                            begin
                              Canvas.Font.Color := clBlue;
                              DrawText(Canvas.handle, PChar(NOT_APPLICABLE), length(NOT_APPLICABLE), { Length(str), } arRect[Index], DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                            end;
                        end
                      else
                        begin
                          // determine if order is billable, if NOT then insert NA in Dx field
                          if not UBACore.IsOrderBillable(tempID) then
                            begin
                              Canvas.Font.Color := clBlue;
                              DrawText(Canvas.handle, PChar(NOT_APPLICABLE), length(NOT_APPLICABLE), { Length(str), } arRect[Index], DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                            end;
                        end;
                    end;
                end;

            end;
        end;
    end
  else
    begin
      X := '';
      ARect := Rect;
      with clstCSOrders do
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
  { End BillingAware }
end;

procedure TfrmSignOrders.clstCSOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  X: string;
  ARect: TRect;
begin
  inherited;
  AHeight := SigItemHeight;
  with clstCSOrders do
    if Index < Items.Count then
      begin
        ARect := ItemRect(Index);
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

procedure TfrmSignOrders.clstOrdersClick(Sender: TObject);
// If grid item is an order-able item, then enable the Diagnosis button
// else disable the Diagnosis button.
var
  thisChangeItem: TChangeItem;
  i: smallint;
  thisOrderList: TStringList;
begin
  thisOrderList := TStringList.Create;

  { Begin BillingAware }
  if BILLING_AWARE then
    begin

      if clstOrders.Items.Count > 1 then
        Copy1.Enabled := True
      else
        Copy1.Enabled := False;

      for i := 0 to clstOrders.Items.Count - 1 do
        begin
          if clstOrders.Selected[i] then
            begin
              thisChangeItem := TChangeItem(clstOrders.Items.Objects[i]);

              // Disallow copying of a grid HEADER item on LEFT MOUSE CLICK
              if thisChangeItem = nil then
                begin
                  Copy1.Enabled := False;
                  buOrdersDiagnosis.Enabled := False;
                  Exit;
                end;

              if (thisChangeItem <> nil) then // Blank row - not an order item
                begin
                  thisOrderList.Clear;
                  thisOrderList.Add(thisChangeItem.ID);

                  if IsAllOrdersNA(thisOrderList) then
                    begin
                      Diagnosis1.Enabled := False;
                      buOrdersDiagnosis.Enabled := False;
                    end
                  else
                    begin
                      Diagnosis1.Enabled := True;
                      buOrdersDiagnosis.Enabled := True;
                    end
                end
              else
                begin
                  buOrdersDiagnosis.Enabled := False;
                  Diagnosis1.Enabled := False;
                  Break;
                end;
            end;
        end;

      if Assigned(thisOrderList) then
        thisOrderList.Free;
    end;
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
    67, 99:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorSC, fraCoPay.lblSC2); // C,c
    86, 118:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorCV, fraCoPay.lblCV2); // V,v
    79, 111:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorAO, fraCoPay.lblAO2); // O,o
    82, 114:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorIR, fraCoPay.lblIR2); // R,r
    65, 97:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorEC, fraCoPay.lblSWAC2); // A,a
    77, 109:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorMST, fraCoPay.lblMST2); // M,m
    78, 110:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorHNC, fraCoPay.lblHNC2); // N,n
    72, 104:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorSHAD, fraCoPay.lblSHAD2); // H,h
    76, 108:
      if (ssAlt in Shift) then
        ShowTreatmentFactorHints(BAFactorsRec.FBAFactorCL, fraCoPay.lblCL2); // L,l
    // CQ5054
    83, 115:
      if (ssAlt in Shift) then
        begin
          for j := 0 to clstOrders.Items.Count - 1 do
            clstOrders.Selected[j] := False;
          clstOrders.Selected[0] := True;
          clstOrders.SetFocus;
        end;
    // end CQ5054
  end;
end;

// BILLING AWARE Procedure
procedure TfrmSignOrders.ShowTreatmentFactorHints(var pHintText: string; var pCompName: TVA508StaticText); // 508
var
  HRect: TRect;
  thisRect: TRect;
  X, Y: Integer;

begin
  try
    if FOSTFHintWndActive then
      begin
        FOSTFhintWindow.ReleaseHandle;
        FOSTFHintWndActive := False;
      end;
  except
    on E: Exception do
      begin
        // {$ifdef debug}Show508Message('Unhandled exception in procedure TfrmSignOrders.ShowTreatmentFactorHints()');{$endif}
        raise;
      end;
  end;

  try
    FOSTFhintWindow := THintWindow.Create(frmSignOrders);
    FOSTFhintWindow.Color := clInfoBk;
    GetWindowRect(pCompName.handle, thisRect);
    X := thisRect.Left;
    Y := thisRect.Top;
    HRect := FOSTFhintWindow.CalcHintRect(Screen.Width, pHintText, nil);
    HRect.Left := HRect.Left + X;
    HRect.Right := HRect.Right + X;
    HRect.Top := HRect.Top + Y;
    HRect.Bottom := HRect.Bottom + Y;

    fraCoPay.LabelCaptionsOn(not FOSTFHintWndActive);

    FOSTFhintWindow.ActivateHint(HRect, pHintText);
    FOSTFHintWndActive := True;
  except
    on E: Exception do
      begin
        // {$ifdef debug}Show508Message('Unhandled exception in procedure TfrmSignOrders.ShowTreatmentFactorHints()');{$endif}
        raise;
      end;
  end;
end;

procedure TfrmSignOrders.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  try
    if FOSTFHintWndActive then
      begin
        FOSTFhintWindow.ReleaseHandle;
        FOSTFHintWndActive := False;
        Application.ProcessMessages;
      end;
  except
    on E: Exception do
      begin
        // {$ifdef debug}Show508Message('Unhandled exception in procedure TfrmSignOrders.FormMouseMove()');{$endif}
        raise;
      end;
  end;
end;

procedure TfrmSignOrders.FormPaint(Sender: TObject);
begin
  inherited;
  {
    if fOrdersSign.frmSignOrders.clstCSOrders.count = 0 then
    begin
    fOrdersSign.frmSignOrders.clstOrders.Height := fOrdersSign.frmSignOrders.pnlOrderlist.Height - fOrdersSign.frmSignOrders.clstOrders.Top - 4;
    fOrdersSign.frmSignOrders.clstOrders.Width := fOrdersSign.frmSignOrders.pnlOrderlist.Width - fOrdersSign.frmSignOrders.clstOrders.Left - 4;
    end;
    if fOrdersSign.frmSignOrders.clstOrders.count = 0 then
    begin
    fOrdersSign.frmSignOrders.clstCSOrders.Height := fOrdersSign.frmSignOrders.pnlCSOrderlist.Height - fOrdersSign.frmSignOrders.clstCSOrders.Top - 4;
    fOrdersSign.frmSignOrders.clstCSOrders.Width := fOrdersSign.frmSignOrders.pnlCSOrderlist.Width - fOrdersSign.frmSignOrders.clstCSOrders.Left - 4;
    end;
  }
end;

procedure TfrmSignOrders.FormResize(Sender: TObject);
begin
  inherited;

  pnlOrderList.Visible := clstOrders.Count > 0;
  pnlCSOrderList.Visible := clstCSOrders.Count > 0;

  if pnlOrderList.Visible and pnlCSOrderList.Visible then
    begin
      pnlOrderList.Height := pnlCombined.Height div 2;
    end
  else if pnlOrderList.Visible then
    begin
      pnlOrderList.Align := alClient;
      // pnlOrderList.Height := pnlCombined.Height;
    end
  else if pnlCSOrderList.Visible then
    begin
      // ignore, pnlCSOrderList is alClient and pnlOrderList isn't visible
    end;

  pnlCombined.Invalidate;

  {
    if fOrdersSign.frmSignOrders.clstCSOrders.Count = 0 then
    begin
    fOrdersSign.frmSignOrders.clstOrders.Height := fOrdersSign.frmSignOrders.pnlOrderList.Height - fOrdersSign.frmSignOrders.clstOrders.Top - 4;
    fOrdersSign.frmSignOrders.clstOrders.Width := fOrdersSign.frmSignOrders.pnlOrderList.Width - fOrdersSign.frmSignOrders.clstOrders.Left - 4;
    end;
    if fOrdersSign.frmSignOrders.clstOrders.Count = 0 then
    begin
    fOrdersSign.frmSignOrders.clstCSOrders.Height := fOrdersSign.frmSignOrders.pnlCSOrderList.Height - fOrdersSign.frmSignOrders.clstCSOrders.Top - 4;
    fOrdersSign.frmSignOrders.clstCSOrders.Width := fOrdersSign.frmSignOrders.pnlCSOrderList.Width - fOrdersSign.frmSignOrders.clstCSOrders.Left - 4;
    end;
  }
  // clstOrders.invalidate;
end;

procedure TfrmSignOrders.fraCoPaylblHNCMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  fraCoPay.LabelCaptionsOn(not FOSTFHintWndActive)
end;

procedure TfrmSignOrders.fraCoPayLabel23Enter(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [fsBold];
end;

procedure TfrmSignOrders.fraCoPayLabel23Exit(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [];
end;

procedure TfrmSignOrders.SetItemTextToState;
var
  i: Integer;
begin
  // The with statement below would cause access violations on other Delphi machines.
  { with clstOrders do
    begin }
  // Must use fully qualifying path includeing the unit... very wierd!

  if fOrdersSign.frmSignOrders.clstOrders.Count < 1 then
    Exit;
  for i := 0 to fOrdersSign.frmSignOrders.clstOrders.Count - 1 do
    if fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i] <> nil then // Not a Group Title
      begin
        if fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i] is TOrder then
          if fOrdersSign.frmSignOrders.clstOrders.Checked[i] then
            fOrdersSign.frmSignOrders.clstOrders.Items[i] := 'Checked ' + TOrder(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i]).Text
          else
            fOrdersSign.frmSignOrders.clstOrders.Items[i] := 'Not Checked ' + TOrder(fOrdersSign.frmSignOrders.clstOrders.Items.Objects[i]).Text;
      end;
  if fOrdersSign.frmSignOrders.clstOrders.ItemIndex >= 0 then
    fOrdersSign.frmSignOrders.clstOrders.Selected[fOrdersSign.frmSignOrders.clstOrders.ItemIndex] := True;
  // end;
end;

procedure TfrmSignOrders.clstOrdersKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Space) then
    FormatListForScreenReader
end;

procedure TfrmSignOrders.FormatListForScreenReader;
begin
  if ScreenReaderActive then
    SetItemTextToState;
end;

end.
