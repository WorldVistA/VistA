unit fReview;

{.$define debug}

interface                                                                                                                                

uses
  UBAGlobals,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, checklst, uConst, ExtCtrls, uCore, mCoPayDesc, oPKIEncryption,
  ORCtrls, Menus, UBACore, ORClasses, ORNet, fBase508Form, fPrintLocation,
  VA508AccessibilityManager, fCSRemaining, rODMeds;

type
  TfrmReview = class(TfrmBase508Form)
    fraCoPay: TfraCoPayDesc;
    laDiagnosis: TLabel;
    gbxDxLookup: TGroupBox;
    buDiagnosis: TButton;
    poBACopyPaste: TPopupMenu;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Diagnosis1: TMenuItem;
    Exit1: TMenuItem;
    pnlProvInfo: TPanel;
    lblProvInfo: TLabel;
    pnlDEAText: TPanel;
    lblDEAText: TStaticText;
    pnlBottom: TPanel;
    pnlSignature: TPanel;
    lblESCode: TLabel;
    txtESCode: TCaptionEdit;
    pnlOrderAction: TPanel;
    Label1: TStaticText;
    lblHoldSign: TStaticText;
    radSignChart: TRadioButton;
    radHoldSign: TRadioButton;
    grpRelease: TGroupBox;
    radVerbal: TRadioButton;
    radPhone: TRadioButton;
    radPolicy: TRadioButton;
    radRelease: TRadioButton;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlCombined: TORAutoPanel;
    pnlReview: TPanel;
    lstReview: TCaptionCheckListBox;
    lblSig: TStaticText;
    pnlCSReview: TPanel;
    lblCSReview: TLabel;
    lstCSReview: TCaptionCheckListBox;
    lblSmartCardNeeded: TStaticText;
    pnlTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure lstReviewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstReviewClickCheck(Sender: TObject);
    procedure radReleaseClick(Sender: TObject);
    procedure txtESCodeChange(Sender: TObject);
    procedure lstReviewMeasureItem(Control: TWinControl; Index: Integer; var AHeight: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure lstReviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure buDiagnosisClick(Sender: TObject);
    procedure lstReviewClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure lstReviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure ClearDiagnoses1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fraCoPayLabel24MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstReviewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure lstCSReviewMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure lstCSReviewDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstCSReviewClickCheck(Sender: TObject);
    procedure lstCSReviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lstCSReviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstCSReviewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstCSReviewClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);

  private
    { Private declarations }
    FOKPressed: Boolean;
    FShowPanel: Integer;
    FSilent: Boolean;
    FCouldSign: Boolean;
    FLastHintItem: integer;
    FOldHintPause: integer;
    FOldHintHidePause: integer;
    FIsEvtChange: boolean;
    procedure AddHeader(s: string);
    procedure AddCSHeader(s: string);
    function AddItem(ChangeItem: TChangeItem): integer;
    function AddCSItem(ChangeItem: TChangeItem): integer;
    procedure BuildList(FullList: boolean);
    procedure BuildFullList;
    procedure BuildSignList;
    procedure PlaceComponents;
    procedure CleanupChangesList(Sender: TObject; ChangeItem: TChangeItem);  {**RV**}
    function ItemsAreChecked: Boolean;
    function CSItemsAreChecked: Boolean;
    function nonDCCSItemsAreChecked: Boolean;
    function AnyItemsAreChecked: Boolean;
    function SignRequiredForAny(FullList: boolean): Boolean;
    procedure AdjustSignatureTop( HeightAdjustment: integer);
    function IsSignatureRequired:boolean;
    function GetNumberOfSelectedOrders : byte;
    procedure ShowTreatmentFactorHints(var pHintText: string; var pCompName: TVA508StaticText); // 508
    procedure SetItemTextToState;
    procedure FormatListForScreenReader;
  public
    procedure SetCheckBoxStatus(thisOrderID: string);
    function GetCheckBoxStatus(sourceOrderID : string) : string; overload;
    function GetCheckBoxStatus(gridItemIndex : smallint) : string; overload; 
    function GetNonNilItemCount : integer; //CQ5172
  end;

function ReviewChanges(TimedOut: Boolean; IsEvtChange: boolean = False): Boolean;

var
{Begin BillingAware}
  frmReview: TfrmReview; //Originally declared locally in function ReviewChanges()
  DxRect: TRect;
{End BillingAware}

  {Begin BillingAware}
    TFactorMemo: TCaptionMemo;
    chkBoxStatus: string;
    srcOrderID: string;
    targetOrderID: string;
    tempStrList: TStringList;
    srcDx: string;
    tempOrderList: TStringList;
    copyOrderID: string;
    srcIndex: integer;
    CopyBuffer: TBADxRecord;
    FRVTFHintWindowActive: boolean;
    FRVTFHintWindow: THintWindow;
    {End BillingAware}
    currentlySelectedItem: integer; //CQ5063
    currentItems: TStringList; //CQ5063

implementation

{$R *.DFM}

uses ORFn, rCore, fNotes, fConsults, fOrders, rOrders, Hash, fDCSumm, fOCSession, uOrders,
     fSignItem, fOrdersPrint, fLkUpLocation, fFrame, uSignItems, fSurgery,
     fBALocalDiagnoses, UBAConst, UBAMessages, fOrdersSign, fClinicWardMeds,
     rODLab, fRptBox, VAUtils, System.Types, System.UITypes;

const
  SP_NONE  = 0;
  SP_CLERK = 1;
  SP_NURSE = 2;
  SP_SIGN  = 3;
  TXT_ENCNT     = 'Outpatient Encounter';
  TXT_NOVISIT   = 'Visit Type: < None Selected >';
  TXT_NODIAG    = 'Diagnosis: < None Selected >';
  TXT_NOPROC    = 'Procedures: none';
  TXT_DOCS      = 'Documents';
  TXT_ORDERS    = 'Orders';
  TXT_BLANK     = ' ';
  TX_INVAL_MSG  = 'Not a valid electronic signature code.  Enter a valid code or press Cancel.';
  TX_INVAL_CAP  = 'Unrecognized Signature Code';
  TX_ES_REQ     = 'Enter your electronic signature to release these orders.';
  TC_ES_REQ     = 'Electronic Signature';
  TX_NO_REL     = CRLF + CRLF + '- cannot be released to the service(s).' + CRLF + CRLF + 'Reason: ';
  TC_NO_REL     = 'Unable to Release Orders';
  TC_NO_DX      =  'Incomplete Diagnosis Entry';
  TX_NO_DX      =  'A Diagnosis must be selected prior to signing any of the following order types:'
                   + CRLF + 'Outpatient Lab,Radiology, Outpatient Medications, Prosthetics.';

procedure TfrmReview.SetCheckBoxStatus(thisOrderID: string);
{
   - Set the current CI checkboxes status
}
begin
  if BILLING_AWARE then
     begin
        uSignItems.uSigItems.SetSigItems(lstReview, thisOrderID);
     end;
end;

function TfrmReview.GetCheckBoxStatus(gridItemIndex: smallint) : string;
{
  - Obtain checkbox status for selected order - BY ORDER ID
}
var
  itemsList: TStringList;
  i: smallint;
begin
  Result := '';
  itemsList := TStringList.Create;
  itemsList.Clear;
  itemsList := uSigItems.GetSigItems; //Get FItems list

  if BILLING_AWARE then
     begin
     for i := 0 to itemsList.Count-1 do
        begin
        if i = gridItemIndex then   //compare to order ID of source order
           begin
           Result := Piece(itemsList[i],U,4);  //return TF status'
           Break;
           end;
        end;
     end;
end;

function TfrmReview.GetCheckBoxStatus(sourceOrderID: string) : string;  //PASS IN ORDER ID - NOT GRID INDEX
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
  itemsList := uSigItems.GetSigItems; //Get FItems list

  if BILLING_AWARE then
     begin
     for i := 0 to itemsList.Count-1 do
        begin
        thisOrderID := Piece(itemsList[i],'^',1); //get the order ID
        if thisOrderID = sourceOrderID then   //compare to order ID of source order
           begin
           Result := Piece(itemsList[i],U,4);  //return TF status'
           Break;
           end;
        end;
     end;
end;

function TfrmReview.GetNumberOfSelectedOrders : byte;
{
  - Return the number of orders in clstOrders that are currently selected.
}
var
  i: integer;
  numSelected: byte;
begin
  result := 0;
  if BILLING_AWARE then
     begin
     numSelected := 0;
     for i := 1 to frmReview.lstReview.Items.Count-1 do
         if (frmReview.lstReview.Selected[i]) then
           Inc(numSelected);

     Result := numSelected;
     end;
end;

function ReviewChanges(TimedOut: Boolean; IsEvtChange: boolean = False): Boolean;
{ display changes made to chart for this encounter, allow changes to be saved, signed, etc. }
var
  i: integer;
begin
  Result := True;
  if Changes.Count = 0 then Exit;
  if assigned(frmReview) then Exit;
  frmReview := TfrmReview.Create(Application);

  CallV('ORDEA DEATEXT', []);
  frmReview.lblDEAText.Caption := '';
  for i := 0 to RPCBrokerV.Results.Count -1 do
     frmReview.lblDEAText.Caption := frmReview.lblDEAText.Caption + ' ' + RPCBrokerV.Results.Strings[i];

  CallV('ORDEA SIGINFO', [Patient.DFN, User.DUZ]);
  frmReview.lblProvInfo.Caption := '';
  for i := 0 to RPCBrokerV.Results.Count -1 do
  begin
    if not (frmReview.lblProvInfo.Caption = '') then frmReview.lblProvInfo.Caption := frmReview.lblProvInfo.Caption + #13#10;
    
     frmReview.lblProvInfo.Caption := frmReview.lblProvInfo.Caption + RPCBrokerV.Results.Strings[i];
  end;
  frmReview.lblDeaText.Visible := FALSE;
  frmReview.lblSmartCardNeeded.Visible := FALSE;
  try
    Changes.OnRemove := frmReview.CleanupChangesList;     {**RV**}
    frmReview.FIsEvtChange := IsEvtChange;

    if TimedOut and (Changes.Count > 0) then
       begin
         frmReview.FSilent := True;
         frmReview.BuildFullList;
         with frmReview.lstReview do for i := 0 to Items.Count - 1 do
           Checked[i] := False;
         frmReview.cmdOKClick(frmReview);
         Result := True;
       end
    // if user not timed out, execute as before
    else
      begin
         if ((uCore.User.OrderRole = OR_NURSE) or (uCore.User.OrderRole = OR_CLERK)) and Changes.CanSign then
         begin
           frmReview.FCouldSign := True;
           frmReview.BuildSignList;  // ok will remove from changes, exit leaves altogether
           if ((frmReview.lstReview.Count>0) or (frmReview.lstCSReview.Count>0)) then
           begin
              frmReview.PlaceComponents;
              frmReview.ShowModal;
              Result := frmReview.FOKPressed;
              CSRemaining(frmReview.lstReview.items,frmReview.lstCSReview.items);
           end
           else
           begin
             Result := True;
           end;
         end;

      if Result and (Changes.Count > 0) then
      begin
        frmReview.FCouldSign := Changes.CanSign;
        frmReview.BuildFullList;

         if BILLING_AWARE then
            //  build list of orders that are not billable based on package type
            UBAGlobals.NonBillableOrderList := rpcNonBillableOrders(tempOrderList);

           if ((frmReview.lstReview.Count>0) or (frmReview.lstCSReview.Count>0)) then
           begin
              frmReview.PlaceComponents;
              frmReview.ShowModal;
              Result := frmReview.FOKPressed;
              CSRemaining(frmReview.lstReview.items,frmReview.lstCSReview.items);
           end
           else
           begin
             Result := True;
           end;
      end;

    end;

  finally
   Changes.OnRemove := nil;     {**RV**}
   frmReview.Release;
   frmReview := nil;
  end;
end;

procedure TfrmReview.FormCreate(Sender: TObject);
const
  TX_FORM_CAPTION = 'Review / Sign Changes  ';
begin
  FOKPressed := False;
  FSilent := False;
  FLastHintItem := -1;
  Self.Caption := TX_FORM_CAPTION + '(' + Patient.Name + ' - ' + Patient.SSN + ')';
  FOldHintPause := Application.HintPause;
  Application.HintPause := 250;
  FOldHintHidePause := Application.HintHidePause;
  Application.HintHidePause := 30000;
   {Begin BillingAware}
     if  BILLING_AWARE then
     begin
        gbxDxLookup.Visible := TRUE;
        laDiagnosis.Top :=  Lblsig.Top;
        laDiagnosis.Left := 270;
        laDiagnosis.Visible := TRUE;
        rectIndex := 0;
     end;
     {End BillingAware}
end;

procedure TfrmReview.AddHeader(s: string);
{ add header to review list, object is left nil }
begin
  lstReview.Items.AddObject(s, nil);
end;

procedure TfrmReview.AddCSHeader(s: string);
{ add header to review list, object is left nil }
begin
  lstCSReview.Items.AddObject(s, nil);
end;

function TfrmReview.AddItem(ChangeItem: TChangeItem): integer;
{ add a single review item to the list with its associated TChangeItem object }
begin
  Result := lstReview.Items.AddObject(ChangeItem.Text, ChangeItem);

  //Begin BillingAware
  if  BILLING_AWARE then
  begin
    UBAGlobals.ChangeItemOrderNum := ChangeItem.ID; // GE 2/21/2006 removed "Copy(ChangeItem.ID,0,8)" issue when sites have order number > 8 digits
     // HDS00005025

    if ChangeItem.ItemType = CH_DOC then    // documents are not orderable, code is necessary
      UBAGlobals.ChangeItemOrderNum := '0'; // document id can be same as order id, orderid = 0 will be nonbillable

    tempOrderList.Add(UBAGlobals.ChangeItemOrderNum);
  end;
   //end BillingAware

  case ChangeItem.SignState of
  CH_SIGN_YES: lstReview.Checked[Result] := True;
  CH_SIGN_NO:  lstReview.Checked[Result] := False;
  CH_SIGN_NA:  lstReview.State[Result] := cbGrayed;
  end;
  //hds00006047
 // this will override the signstate from above for all non-va med orders...  no signature required.
  if ChangeItem.GroupName = '' then
  begin
  if ChangeItem.OrderDG = NONVAMEDGROUP then
         lstReview.State[Result] := cbGrayed;
   end;
  //hds00006047
end;

function TfrmReview.AddCSItem(ChangeItem: TChangeItem): integer;
{ add a single review item to the list with its associated TChangeItem object }
begin
  Result := lstCSReview.Items.AddObject(ChangeItem.Text, ChangeItem);

  //Begin BillingAware
  if  BILLING_AWARE then
  begin
    UBAGlobals.ChangeItemOrderNum := ChangeItem.ID; // GE 2/21/2006 removed "Copy(ChangeItem.ID,0,8)" issue when sites have order number > 8 digits
     // HDS00005025

    if ChangeItem.ItemType = CH_DOC then    // documents are not orderable, code is necessary
      UBAGlobals.ChangeItemOrderNum := '0'; // document id can be same as order id, orderid = 0 will be nonbillable

    tempOrderList.Add(UBAGlobals.ChangeItemOrderNum);
  end;
   //end BillingAware
   if ChangeItem.DCOrder then lstCSReview.Checked[Result] := TRUE
   else lstCSReview.Checked[Result] := False;

  if ChangeItem.SignState=CH_SIGN_NA then lstCSReview.State[Result] := cbGrayed;
 // this will override the signstate from above for all non-va med orders...  no signature required.
  if ChangeItem.GroupName = '' then
  begin
  if ChangeItem.OrderDG = NONVAMEDGROUP then
         lstCSReview.State[Result] := cbGrayed;
   end;
  //hds00006047
end;

procedure TfrmReview.AdjustSignatureTop( HeightAdjustment: integer);
//This has been added to support correct anchoring for the lstReview list.
begin
  Height := Height + HeightAdjustment;
  lblSig.Top := lblSig.Top + HeightAdjustment;
  lstReview.Top := lstReview.Top + HeightAdjustment;
  lstReview.Height := lstReview.Height - HeightAdjustment;
  //for 24 pt font, we need to make sure that lstreview is resized before the main form is.
end;

function TfrmReview.IsSignatureRequired:boolean;
var
  i: integer;
begin
 Result := FALSE;
    with lstReview do for i := 0 to Items.Count-1 do
    begin
      if Checked[i] then
      begin
        if TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]) = nil then
           Continue;
         if (TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).SIGNSTATE) <> CH_SIGN_NA then
            Result := TRUE;
         end;
    end;
    with lstCSReview do for i := 0 to Items.Count-1 do
    begin
      if Checked[i] then
      begin
        if TChangeItem(fReview.frmReview.lstCSReview.Items.Objects[i]) = nil then
           Continue;
         if (TChangeItem(fReview.frmReview.lstCSReview.Items.Objects[i]).SIGNSTATE) <> CH_SIGN_NA then
            Result := TRUE;
         end;
    end;
end;

procedure TfrmReview.BuildList(FullList: boolean);
var
  GrpIndex, ChgIndex, lbIdx: Integer;
  ChangeItem: TChangeItem;
  LabelHeight: integer;
  PrevGrpName, temp: string;
  displayHeader, displaySpacer, displayCSHeader, displayCSSpacer, otherUserOrders, otherhdradded, othercshdradded: boolean;
  I, ColHeight: Integer;
  t1, t2{, NVAinNonCSList, otherinNonCSList}: Boolean;
begin
  tempOrderList := TStringList.Create;
  tempOrderList.Clear;
  PrevGrpName := '';
//  NVAinNonCSList := false;
//  otherinNonCSList := false;
  lstReview.Clear;  // ok to clear without freeing objects since they're part of Changes
  if(FullList) then
  begin
    SigItems.ResetOrders;
    SigItemsCS.ResetOrders;
    with Changes do
    if PCE.Count > 0 then
    begin
      for GrpIndex := 0 to PCEGrp.Count - 1 do
      begin
        AddHeader('Outpatient Encounter ' + PCEGrp[GrpIndex]);
        for ChgIndex := 0 to PCE.Count - 1 do
        begin
          ChangeItem := PCE[ChgIndex];
          if ChangeItem.GroupName = PCEGrp[GrpIndex] then AddItem(ChangeItem);
        end;
        AddHeader('   ');
      end;
    end; {if PCE}
  end;
  with Changes do
  if Documents.Count > 0 then
  begin
    AddHeader('Documents');
    for ChgIndex := 0 to Documents.Count - 1 do
    begin
      ChangeItem := Documents[ChgIndex];
      if(FullList or (ChangeItem.SignState <> CH_SIGN_NA)) then
         AddItem(ChangeItem);
    end;
    if(FullList) then
       AddHeader('   ');
  end; {if Documents}
  if(FullList) then
  begin
    //otherUserOrders := False;
    displaySpacer := False;
    displayCSSpacer := False;
    with Changes do
    if Orders.Count > 0 then
    begin
      OrderGrp.Sorted := True;
      otherUserOrders := False;
      for GrpIndex := 0 to OrderGrp.Count - 1 do
      begin
        displayHeader := True;
        displayCSHeader := True;
        if (GrpIndex > 0 ) and (AnsiCompareText(PrevGrpName,OrderGrp[GrpIndex])=0) then
          Continue;
        if OrderGrp[GrpIndex] = '' then Temp := 'My Unsigned Orders - This Session'
        else if OrderGrp[GrpIndex] = 'Other Unsigned' then Temp := 'My Unsigned Orders - Previous Sessions'
        else Temp := 'Orders - ' + OrderGrp[GrpIndex];
        {billing aware}
        if BILLING_AWARE then
        begin
           UBACore.rpcBuildSCIEList(Orders);            // build list of orders and Billable Status
           UBACore.CompleteUnsignedBillingInfo(rpcGetUnsignedOrdersBillingData(OrderListSCEI) );
        end;
        {billing aware}

        for ChgIndex := 0 to Orders.Count - 1 do
        begin
          ChangeItem := Orders[ChgIndex];
          if (ChangeItem.GroupName = OrderGrp[GrpIndex]) and ((ChangeItem.User = 0) or (ChangeItem.User = User.DUZ)) then
          begin
            if ((ChangeItem.CSValue = False) or ChangeItem.DCOrder or IsPendingHold(ChangeItem.ID)) then
            begin
              if displayHeader = True then
                begin
                 AddHeader(Temp);
                  displayHeader := False;
                 displaySpacer := True;
               end;
              lbIdx := AddItem(ChangeItem);
              SigItems.Add(CH_ORD, ChangeItem.ID, lbIdx);
//              if (ChangeItem.OrderDG = 'Non-VA Meds') or (Pos('Non-VA',ChangeItem.Text)>0) then NVAinNonCSList := true
//              else otherinNonCSList := true;
            end
            else
            begin
              if not(GetPKISite) or not(GetPKIUse) or (DEACheckFailedAtSignature(GetOrderableIen(Piece(ChangeItem.ID,';',1)),False)='1') then ChangeItem.SignState := CH_SIGN_NA;

              if displayCSHeader = True then
                begin
                 AddCSHeader(Temp);
                  displayCSHeader := False;
                 displayCSSpacer := True;
               end;
              lbIdx := AddCSItem(ChangeItem);
              SigItemsCS.Add(CH_ORD, ChangeItem.ID, lbIdx);
            end;
            
         end
         else if ((ChangeItem.User > 0) and (ChangeItem.User <> User.DUZ)) then
           otherUserOrders := True;
        end;
        if displayHeader = False then AddHeader('   ');
        if displayCSHeader = False then AddCSHeader('   ');
        PrevGrpName := OrderGrp[GrpIndex];
    end;
    //AGP fix for CQ 10073
    if otherUserOrders = True then
          begin
            othercshdradded := false;
            otherhdradded := false;
            for ChgIndex := 0 to Orders.Count - 1 do
             begin
                ChangeItem := Orders[ChgIndex];
                if (ChangeItem.GroupName = 'Other Unsigned') and ((ChangeItem.User >0) and (ChangeItem.User <> User.DUZ)) then
                  begin

                    if ((ChangeItem.CSValue = False) or ChangeItem.DCOrder or IsPendingHold(ChangeItem.ID)) then
                    begin
                      if not otherhdradded then
                      begin
                        otherhdradded := true;
                        if displaySpacer = True then AddHeader('   ');
                        AddHeader('Others'' Unsigned Orders Orders - All Sessions');
                      end;         
                      lbIdx := AddItem(ChangeItem);
                      SigItems.Add(CH_ORD, ChangeItem.ID, lbIdx);
//                      if (ChangeItem.OrderDG = 'Non-VA Meds') or (Pos('Non-VA',ChangeItem.Text)>0) then NVAinNonCSList := true
//                      else otherinNonCSList := true;
                    end
                    else
                    begin
                      if not(GetPKIUse) or not(GetPKISite) or (DEACheckFailedAtSignature(GetOrderableIen(Piece(ChangeItem.ID,';',1)),False)='1') then ChangeItem.SignState := CH_SIGN_NA;
                      if not othercshdradded then
                      begin
                        othercshdradded := true;
                        if displayCSSpacer = True then AddCSHeader('   ');
                        AddCSHeader('Others'' Unsigned Orders - All Sessions');
                      end;
                      lbIdx := AddCSItem(ChangeItem);
                      SigItemsCS.Add(CH_ORD, ChangeItem.ID, lbIdx);
                    end;
                  end;
            end;
        end;
    OrderGrp.Sorted := false;
  end; {if Orders}
    // determine the appropriate panel to display
    case User.OrderRole of
        OR_CLERK: FShowPanel := SP_CLERK;
        OR_NURSE: FShowPanel := SP_NURSE;
    OR_PHYSICIAN: FShowPanel := SP_SIGN;
      OR_STUDENT: if Changes.CanSign then FShowPanel := SP_SIGN else FShowPanel := SP_NONE;
    else          FShowPanel := SP_NONE;
    end; {case User}
  end
  else
    FShowPanel := SP_SIGN;

  case FShowPanel of
  SP_CLERK: begin
              pnlSignature.Visible := False;
              pnlOrderAction.Visible := SignRequiredForAny(FullList);
            end;
  SP_NURSE: begin
              pnlSignature.Visible := False;
              radRelease.Visible := True;
              grpRelease.Visible := True;
              pnlOrderAction.Visible := SignRequiredForAny(FullList);
            end;
   SP_SIGN: begin
              pnlOrderAction.Visible := False;
              pnlSignature.Visible := ItemsAreChecked;
            end;
  else      begin                                // SP_NONE
              pnlOrderAction.Visible := False;
              pnlSignature.Visible := False;
            end;
  end; {case FShowPanel}
  pnlSignature.Visible := AnyItemsAreChecked;
  

  txtESCodeChange(Self);
  if pnlOrderAction.Visible then
  begin
//    lblSig.Caption := 'Documents / Orders';
    if FShowPanel = SP_NURSE then
    begin
      if GetUserParam('OR SIGNATURE DEFAULT ACTION') = 'OC'
        then radHoldSign.Checked  := True
        else radRelease.Checked   := True;
    end;
    if (radHoldSign.Checked) and (GetUserParam('OR SIGNED ON CHART') = '1')
      then radSignChart.Checked := True;
    if radRelease.Checked then radReleaseClick(Self);
  end {if pnlOrderAction}
  else
  begin
//    if (User.OrderRole = OR_STUDENT) or (User.OrderRole = OR_NOKEY) or (User.OrderRole = OR_BADKEYS) then
//    begin
//      if otherinNonCSList then lblSig.Caption := 'These Non-Controlled Substance orders will be held until signed. '
//      else lblSig.Caption := ' ';
//      if NVAinNonCSList then lblSig.Caption := lblSig.Caption + 'Non-VA documentation will become active.';
//
//      lblCSReview.Caption := 'These Controlled Substance orders will be held until signed';
//    end
//    else
//    begin
//      lblSig.Caption := 'All Orders Except Controlled Substance EPCS Orders';
//    end;

  end;
  //Make sure there is enough width for the buttons and lblSig
   //begin BillingAware
  if  BILLING_AWARE then
  begin
     LabelHeight := lstReview.Top - fraCoPay.Height;
     AdjustSignatureTop( ResizeHeight( BaseFont, MainFont, LabelHeight) - LabelHeight);
  end;
   //end BillingAware


    if frmReview.lstCSReview.Count>0 then
    begin
      if not(GetPKISite) then
      begin
        ShowMsg('Digital Signing of Controlled Substances is currently disabled for your site. Controlled Substance Orders will not be signed.');
//          frmReview.lstCSReview.Clear;
//          SigItemsCS.ResetOrders;
      end
      else if not(GetPKIUse ) then
      begin
        ShowMsg('You are not currently permitted to digitally sign Controlled Substances. Controlled Substance Orders will not be signed.');
//          frmReview.lstCSReview.Clear;
//          SigItemsCS.ResetOrders;
      end;
    end;


   SigItems.ClearDrawItems;
   SigItems.ClearFcb;
   SigItemsCS.ClearDrawItems;
   SigItemsCS.ClearFcb;
   t1 := SigItems.UpdateListBox(lstReview);
   t2 := SigItemsCS.UpdateListBox(lstCSReview);

  if (FullList and (t1 or t2)) then
  begin
    fraCoPay.Visible := TRUE;
    if  BILLING_AWARE then frmReview.gbxDxLookup.Visible := TRUE;
  end
  else
  begin
    fraCoPay.Visible := FALSE;
    if  BILLING_AWARE then frmReview.gbxDxLookup.Visible := FALSE;
  end;

  if lstReview.Count > 0 then begin
   for I := 1 to lstReview.Count - 1 do begin
    lstReviewMeasureItem(lstReview, I, ColHeight);
    lstReview.Perform(LB_SETITEMHEIGHT,I,ColHeight);
   end;
  end;
  RedrawWindow(lstReview.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  if frmReview.pnlSignature.Visible and frmReview.txtESCode.Visible then  frmReview.ActiveControl := frmReview.txtESCode;
end; {BuildFullList}


procedure TfrmReview.BuildFullList;
begin
     BuildList(TRUE);
end;

procedure TfrmReview.BuildSignList;
begin
   BuildList(FALSE);
end;

procedure TfrmReview.PlaceComponents;
var
  ShrinkHeight,oheight,newheight: Integer;
begin
    with frmReview do
    begin
      pnlDeaText.Visible := TRUE;
      if ((lstReview.Count = 0) and (lstCSReview.Count = 0)) then  Exit;
      pnlProvInfo.Height := lblProvInfo.Height+5+lblProvInfo.Top;

      if lstCSReview.Count = 0 then
      begin     
        oheight := pnlReview.height;
        pnlProvInfo.Visible := False;  
        if fraCoPay.Visible = FALSE then
        begin
          pnlTop.Visible := False;
        end;
        pnlDEAText.Visible := False;   
        pnlCSReview.Visible := False;
        pnlReview.Align := alClient;
        newheight := Height - pnlReview.height + oheight;
        if newheight < Constraints.MinHeight then Constraints.MinHeight := newheight;
        Height := newheight;
      end
      else if lstReview.Count = 0 then
      begin
        oheight := pnlCSReview.height;
        pnlReview.Visible := False;
        pnlCSReview.Align := alClient;
        newheight := Height - pnlCSReview.height + oheight;  
        if newheight < Constraints.MinHeight then Constraints.MinHeight := newheight;
        Height := newheight;
      end
      else if fraCoPay.Visible = FALSE then
      begin
        fraCoPay.Visible := TRUE;
        ShrinkHeight := fraCoPay.Height - pnlProvInfo.Height;
        fraCoPay.Visible := FALSE;

		    pnlTop.Height := pnlTop.Height - ShrinkHeight;
        pnlCombined.Top := pnlCombined.Top - ShrinkHeight; 
		    pnlCombined.Height := pnlCombined.Height + ShrinkHeight;

      end;
      


      lblDEAText.Visible := FALSE;
      lblSmartCardNeeded.Visible := FALSE;
      if anyitemsarechecked then pnlsignature.visible := IsSignatureRequired;
    end;

end;

function TfrmReview.ItemsAreChecked: Boolean;
{ return true if any items in the Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;
  with lstReview do for i := 0 to Items.Count - 1 do if Checked[i] then
  begin
    Result := True;
    break;
  end;
end;

function TfrmReview.CSItemsAreChecked: Boolean;
{ return true if any items in the CS Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;
  with lstCSReview do for i := 0 to Items.Count - 1 do if Checked[i] then
  begin
    Result := True;
    break;
  end;
end;

function TfrmReview.nonDCCSItemsAreChecked: Boolean;
{ return true if any items in the CS Review List are checked for applying signature }
var
  i: Integer;
begin
  Result := False;
  with lstCSReview do for i := 0 to Items.Count - 1 do if Checked[i] and not(TChangeItem(Items.Objects[i])=nil) then
  begin
    if not(TChangeItem(Items.Objects[i]).DCOrder) then
    begin
      Result := True;
      break;
    end;
  end;
end;

function TfrmReview.AnyItemsAreChecked: Boolean;
begin
  Result := ItemsAreChecked or CSItemsAreChecked;
end;

function TfrmReview.SignRequiredForAny(FullList: boolean): Boolean;
var
  i: Integer;
  tmpOrders: TStringList;
  ChangeItem: TChangeItem;
begin
  if(FullList) then
  begin
    tmpOrders := TStringList.Create;
    try
      for i := 0 to Pred(Changes.Orders.Count) do
      begin
        ChangeItem := Changes.Orders[i];
        tmpOrders.Add(ChangeItem.ID);
      end;
      Result := AnyOrdersRequireSignature(tmpOrders);
    finally
      FreeAndNil(tmpOrders);
    end;
  end
  else
    Result := FALSE;
end;

procedure TfrmReview.lstReviewClickCheck(Sender: TObject);
{ prevent grayed checkboxes from being changed to anything else }
var
  ChangeItem: TChangeItem;

  procedure updateAllChilds(CheckedStatus: boolean; ParentOrderId: string);
  var
    idx: integer;
    AChangeItem: TChangeItem;
  begin
    for idx := 0 to lstReview.Items.Count - 1 do
    begin
      AChangeItem := TChangeItem(lstReview.Items.Objects[idx]);
      if Assigned(AChangeItem) and (AChangeItem.ParentID = ParentOrderId) then
          if lstReview.Checked[idx] <> CheckedStatus then
          begin
            lstReview.Checked[idx] := CheckedStatus;
            SigItems.EnableSettings(idx, lstReview.checked[Idx]);
          end;
    end;
  end;

begin
  with lstReview do
  begin
    ChangeItem := TChangeItem(Items.Objects[ItemIndex]);
    if ItemIndex > 0 then
    begin
       if (ChangeItem <> nil) then
       begin
         if (ChangeItem.SignState = CH_SIGN_NA) then State[ItemIndex] := cbGrayed
         else
         begin
           SigItems.EnableSettings(ItemIndex, checked[ItemIndex]);
           if Length(ChangeItem.ParentID) > 0 then
             updateAllChilds(checked[ItemIndex], ChangeItem.ParentID);
         end;
       end;
     end;
     pnlSignature.Visible := IsSignatureRequired;
  end;
  if pnlSignature.Visible then txtESCode.SetFocus;

end;

procedure TfrmReview.lstReviewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
{ outdent the header items (thus hiding the checkbox) }
var
  x: string;
  ARect, TextRecord: TRect;
  i, dy: integer;
  tempID: string;
  thisRec: UBAGlobals.TBADxRecord;

{Begin BillingAware}
  str: string;
{End BillingAware}

  procedure UpdateTextRecord(r: TRect);
  begin
    TextRecord := r;
    inc(TextRecord.Top, dy);
    dec(TextRecord.Bottom, dy);
  end;

begin
  inherited;
  dy := SIG_ITEM_VERTICAL_PAD div 2;
  x := '';
  ARect := Rect;

  if  BILLING_AWARE then
  begin
     ARect.Right := ARect.Right - 50;

  with lstReview do
  begin
    if Items.Objects[Index] = nil then
        ARect.Left := 0;
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.FillRect(ARect);

    if Index < Items.Count then
      begin
       x := Trim(FilteredString(Items[Index]));

       if (ARect.Left = 0) and ( Length(x)>0 ) then
         Canvas.TextOut(ARect.Left + 2, ARect.Top + dy, x)
       else
          if (ARect.Left > 0 ) and ( Length(x)>0 ) then
             begin
             //ARect.Right below controls the right-hand side of the Dx Column
             //Adjust ARect.Right in conjunction with procedure uSignItems.TSigItems.lbDrawItem(), because the
             //two rectangles overlap each other.

             if  BILLING_AWARE then
                begin
                arRect[Index] := Classes.Rect(ARect.Right+2, ARect.Top, ARect.Right + 108, ARect.Bottom);
                Canvas.FillRect(arRect[Index]);
                end;

             //Draw ORDER TEXT
            UpdateTextRecord(ARect);
            DrawText(Canvas.handle, PChar(x), Length(x), TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);

           if  BILLING_AWARE then
                begin
                     //Dx Column lines
                     Canvas.Pen.Color := Get508CompliantColor(clSilver);
                     Canvas.MoveTo(DxRect.Left-1, ARect.Top);
                     Canvas.LineTo(DxRect.Left-1, ARect.Bottom);
                     //Adjust position of 'Diagnosis' column label for font size
                     laDiagnosis.Left := DxRect.Left + 14;
                     if uSignItems.GetAllBtnLeftPos > 0 then
                        laDiagnosis.left := uSignItems.GetAllBtnLeftPos - (laDiagnosis.Width +5);
                     laDiagnosis.Top := lblSig.Top;
                     //Assign DxRect for drawing Dx column and Dx string
                     DxRect.Left := ARect.Right + 1;
                     DxRect.Top := ARect.Top;
                     DxRect.Right := DxRect.Left + 80;
                     DxRect.Bottom := ARect.Bottom;

                    //Display all saved Dx's
                      for i := 0 to lstReview.Items.Count-1 do
                        with TOrder(lstReview.Items[i]) do
                          begin
                           // HDS00005025
                          if TChangeItem(lstReview.Items.Objects[Index]).ITEMTYPE = CH_DOC then
                             tempID := '0' // if document id is equal to valid order id identify billable orders
                          else
                             tempID := TChangeItem(lstReview.Items.Objects[Index]).ID;
                            // HDS00005025
                           //WORKS FOR MULTIPLE Dx
                           if Assigned(UBAGlobals.tempDxList) then
                             if UBAGlobals.tempDxNodeExists(tempID) then
                                 begin
                                    thisRec := TBADxRecord.Create;
                                    UBAGlobals.GetBADxListForOrder(thisRec, tempID);
                                    str := Piece(thisRec.FBADxCode, '^', 1); // Display Dx text only - not the ICD-9 code
                                    str := Piece(str, ':', 1);   //in case has : vs. ^
                                    UpdateTextRecord(arRect[Index]);
                                    DrawText(Canvas.handle, PChar(str), Length(str), TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);

                                    if (Not UBACore.IsOrderBillable(tempID)) then
                                    begin
                                       Canvas.Font.Color := Get508CompliantColor(clBlue);
                                       UpdateTextRecord(arRect[Index]);
                                       DrawText(Canvas.handle, PChar(NOT_APPLICABLE), Length(NOT_APPLICABLE) , TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                                    end;
                                 end
                              else
                                 begin
                                 //Determine if order is billable. If NOT billable then insert NA in Dx field
                                    if Not UBACore.IsOrderBillable(tempID) then
                                    begin
                                        Canvas.Font.Color := Get508CompliantColor(clBlue);
                                        UpdateTextRecord(arRect[Index]);
                                        DrawText(Canvas.handle, PChar(NOT_APPLICABLE), Length(NOT_APPLICABLE) , TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                                    end;
                                 end;
                          end;
                    end;
        end; //if
      end; //if
  end; //with
 end
 else
    begin
       with lstReview do
          begin
          if Items.Objects[Index] = nil then
              ARect.Left := 0;

          Canvas.FillRect(ARect);

          if Index < Items.Count then
             begin
                x := Trim(FilteredString(Items[Index]));

             if (ARect.Left = 0) and ( Length(x) > 0 ) then
                Canvas.TextOut(ARect.Left + 2, ARect.Top + dy, x)
             else
                if (ARect.Left > 0 ) and ( Length(x)>0 ) then
                   begin
                     Canvas.Pen.Color := Get508CompliantColor(clSilver);
                     Canvas.MoveTo(0, ARect.Bottom-1);
                     Canvas.LineTo(ARect.Right, ARect.Bottom-1);
                     UpdateTextRecord(ARect);
                     DrawText(Canvas.handle, PChar(x), Length(x), TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                   end;
             end;
       end;
    end;
end;

procedure TfrmReview.radReleaseClick(Sender: TObject);
begin
  if not grpRelease.Visible then Exit;
  if radHoldSign.Checked then lblHoldSign.Visible := True
  else lblHoldSign.Visible := False;
  if radRelease.Checked then
  begin
    radVerbal.Enabled := True;
    radPhone.Enabled  := True;
    radPolicy.Enabled := True;
    if Encounter.Provider = User.DUZ
      then radPolicy.Checked := True
      else radVerbal.Checked := True;
  end else
  begin
    radVerbal.Enabled := False;
    radPhone.Enabled  := False;
    radPolicy.Enabled := False;
    radVerbal.Checked := False;
    radPhone.Checked  := False;
    radPolicy.Checked := False;
  end;
end;

procedure TfrmReview.txtESCodeChange(Sender: TObject);
begin
  if(not pnlSignature.Visible) then
  begin
    if (FCouldSign and not anyitemsarechecked) then cmdOK.Caption := 'Don''t Sign'
    else cmdOK.Caption := 'OK'
  end
  else
  begin
    if Length(txtESCode.Text) > 0 then cmdOK.Caption := 'Sign' else
    begin
      if FCouldSign then cmdOK.Caption := 'Don''t Sign' else cmdOK.Caption := 'OK';
    end;
  end;
end;

procedure TfrmReview.cmdOKClick(Sender: TObject);
{ validate the electronic signature & call SaveSignItem for the encounter }
const
  TX_NOSIGN  = 'Save items without signing?';
  TC_NOSIGN  = 'No Signature Entered';
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to save:' + CRLF + CRLF;
  TC_SAVERR  = 'Error Saving Order';
var
  i, k, idx, AType, PrintLoc, theSts, wardIEN, checki,checkj: Integer;
  SigSts, RelSts, Nature: Char;
  ESCode, AnID, AnErrMsg: string;
  ChangeItem, TempChangeItem: TChangeItem;
  OrderList, CSOrderList, TotalOrderList, OrderPrintList: TStringList;
  SaveCoPay, PINRetrieved: boolean;
  displayEncSwitch, DelayOnly: Boolean;
  SigData, SigUser, SigDrugSch, SigDEA: string;
  cSignature, cHashData, cCrlUrl, cErr, WardName, ASvc: string;
  UsrAltName, IssuanceDate, PatientName, PatientAddress, DetoxNumber, ProviderName, ProviderAddress: string;
  DrugName, Quantity, Directions: string;
  cProvDUZ: Int64;
  AList, ClinicList, WardList: TStringList;
  IsOk, ContainsIMOOrders, DoNotPrint, checkfound : Boolean;
  EncLocName, EncLocText, tempInpLoc: string;
  EncLocIEN: integer;
  EncDT: TFMDateTime;
  EncVC: Char;
  aPKIEncryptionEngine: IPKIEncryptionEngine;
  aPKIEncryptionDataDEAOrder: IPKIEncryptionDataDEAOrder;
  aMessage, successMsg: string;

  function OrdersSignedOrReleased: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to Pred(OrderList.Count) do
    begin
      if Pos('R', Piece(OrderList[i], U, 2)) > 0 then Result := True;
      if Pos('S', Piece(OrderList[i], U, 2)) > 0 then Result := True;
      if Result then Break;
    end;
  end;

  function OrdersToBeSignedOrReleased: Boolean;
  var
    i: Integer;
    s,x: string;
  begin
    Result := FALSE;

    for i := 0 to Pred(OrderList.Count) do
    begin
      s := Piece(OrderList[i], U, 2);
      x := s[1];
      if ((s <> '') and CharInSet(s[1], [SS_ONCHART, SS_ESIGNED, SS_NOTREQD])) or
         (Piece(OrderList[i], U, 3) = RS_RELEASE) then
      begin
         Result := TRUE;
         Break;
      end;
    end;

    for i := 0 to Pred(csOrderList.Count) do
    begin
      s := Piece(CSOrderList[i], U, 2);
      x := s[1];
      if ((s <> '') and CharInSet(s[1], [SS_ONCHART, SS_ESIGNED, SS_NOTREQD])) or
         (Piece(CSOrderList[i], U, 3) = RS_RELEASE) then
      begin
         Result := TRUE;
         Break;
      end;
    end;
  end; 

  function Piece2end (s,del: string): string;
  var
    i: Integer;
  begin
    i := Pos(del,s);
    Result := copy(s,i+1,length(s));
  end;

begin
  IsOk := True;
  ESCode := '';
  SaveCoPay := FALSE;
  PrintLoc := 0;
  EncLocIEN := 0;
  DoNotPrint := False;
  tempInpLoc := '';
  DelayOnly := false;
  if BILLING_AWARE then
  begin
     if Assigned(UBAGlobals.UnsignedOrders) then
        UBAGlobals.UnsignedOrders.Clear;
  end;
  if pnlSignature.Visible then
  begin
    ESCode := txtESCode.Text;

    if AnyItemsAreChecked and (Length(ESCode) > 0) and (not ValidESCode(ESCode)) then
    begin
      InfoBox(TX_INVAL_MSG, TX_INVAL_CAP, MB_OK);
      frmReview.ActiveControl := frmReview.txtESCode;
      txtESCode.SelectAll;
      Exit;
    end;
    if Length(ESCode) > 0 then ESCode := Encrypt(ESCode);
  end; {if pnlSignature}

  if not frmFrame.Closing then
  begin
    { save/sign orders }
    OrderList := TStringList.Create;
    CSOrderList := TStringList.Create;
    TotalOrderList := TStringList.Create;
    OrderPrintList := TStringList.create;
    ClinicList := TStringList.Create;
    WardList := TStringList.Create;
    ContainsIMOOrders := False;
    try
      Nature := NO_PROVIDER;
      case User.OrderRole of
      OR_NOKEY, OR_CLERK, OR_NURSE, OR_STUDENT:
        begin
          SigSts := SS_UNSIGNED;                   // default to med student values
          RelSts := RS_HOLD;
          Nature := NO_WRITTEN;
          if User.OrderRole in [OR_CLERK, OR_NURSE] then
          begin
            if radSignChart.Checked then SigSts := SS_ONCHART else SigSts := SS_UNSIGNED;
            if radRelease.Checked or radSignChart.Checked
              then RelSts := RS_RELEASE
              else RelSts := RS_HOLD;
            if radSignChart.Checked or radHoldSign.Checked then Nature := NO_WRITTEN
            else if radVerbal.Checked then Nature := NO_VERBAL
            else if radPhone.Checked  then Nature := NO_PHONE
            else if radPolicy.Checked then Nature := NO_POLICY
            else Nature := NO_WRITTEN;
            if not pnlOrderAction.Visible then     // if no orders require a signature
            begin
              RelSts := RS_RELEASE;
              Nature := NO_PROVIDER;
              SigSts := SS_NOTREQD;
            end;
            // the following was added due to patch OR*3.0*86
            if RelSts = RS_RELEASE then
            begin
              StatusText('Validating Release...');
              AnErrMsg := '';
              for i := 0 to lstReview.Items.Count - 1 do
              begin
                ChangeItem := TChangeItem(lstReview.Items.Objects[i]);
                if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
                begin
                  ValidateOrderActionNature(ChangeItem.ID, OA_RELEASE, Nature, AnErrMsg);
                  if Length(AnErrMsg) > 0 then
                  begin
                    if IsInvalidActionWarning(ChangeItem.Text, ChangeItem.ID) then Break;
                    InfoBox(ChangeItem.Text + TX_NO_REL + AnErrMsg, TC_NO_REL, MB_OK);
                    Break;
                  end; {if Length(AnErrMsg)}
                end; {if ChangeItem=CH_ORD}
              end; {for}
              StatusText('');
              if Length(AnErrMsg) > 0 then Exit;
            end; {if RelSts}
            // the following supports the change to allow nurses to sign policy orders
            if FSilent then RelSts := RS_HOLD;
            if (RelSts = RS_RELEASE) and pnlOrderAction.Visible then
            begin
              SignatureForItem(Font.Size, TX_ES_REQ, TC_ES_REQ, ESCode);
              if ESCode = '' then Exit;
              if Nature = NO_POLICY then SigSts := SS_ESIGNED;
            end;
          end; {if..ORCLERK, OR_NURSE}

          with lstReview do for i := 0 to Items.Count - 1 do
          begin
            ChangeItem := TChangeItem(Items.Objects[i]);
            if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) and (not radSignChart.Checked) then
            begin
              OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature);
              if BILLING_AWARE then
                if not (User.DUZ = 0) and PersonHasKey(User.DUZ, 'PROVIDER') then
                   UBACore.SaveUnsignedOrders(ChangeItem.ID+ '1' + GetCheckBoxStatus(ChangeItem.ID) )
            end
            else if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) and (radSignChart.Checked) then
              OrderList.Add(ChangeItem.ID + U + SS_ONCHART + U + RS_RELEASE + U + NO_WRITTEN);
          end; {with lstReview}

          with lstCSReview do for i := 0 to Items.Count - 1 do
          begin
            ChangeItem := TChangeItem(Items.Objects[i]);
            if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
            begin
              OrderList.Add(ChangeItem.ID + U + SS_UNSIGNED + U + RS_HOLD + U + Nature);
              if BILLING_AWARE then
                if not (User.DUZ = 0) and PersonHasKey(User.DUZ, 'PROVIDER') then
                   UBACore.SaveUnsignedOrders(ChangeItem.ID+ '1' + GetCheckBoxStatus(ChangeItem.ID) )
            end
          end;     {with lstCSReview}

        end; {OR_NOKEY, OR_CLERK, OR_NURSE, OR_STUDENT}

      OR_PHYSICIAN:
        begin
          Nature := NO_PROVIDER;
          with lstReview do for i := 0 to Items.Count - 1 do
          begin
            ChangeItem := TChangeItem(Items.Objects[i]);
            if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
              begin
                case State[i] of
                cbChecked:   if Length(ESCode) > 0 then
                             begin
                               SigSts := SS_ESIGNED;
                               RelSts := RS_RELEASE;
                               OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature);
                             end else
                             begin
                               if BILLING_AWARE then
                                  UBACore.SaveUnsignedOrders(ChangeItem.ID+ '1' + GetCheckBoxStatus(ChangeItem.ID) );
                               SigSts := SS_UNSIGNED;
                               RelSts := RS_HOLD;
                             end;
                cbGrayed:    if OrderRequiresSignature(ChangeItem.ID) then
                             begin
                               SigSts := SS_UNSIGNED;
                               RelSts := RS_HOLD;
                             end else
                             begin
                               SigSts := SS_NOTREQD;
                               RelSts := RS_RELEASE;
                             end;
                else         begin                   // (cbUnchecked)
                               SigSts := SS_UNSIGNED;
                               RelSts := RS_HOLD;
                             end;
                end; {case State}

                if (ChangeItem.GroupName = 'Other Unsigned') and (SigSts = SS_UNSIGNED) and (RelSts = RS_HOLD)
                  then //NoOp - don't add unsigned orders from outside session to the list
                  else
                  begin
                    if not(State[i] = cbChecked) and (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature) < 0) then
                      OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature)
                    else if (cmdOK.Caption = 'Don''t Sign') and (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature) < 0) then
                      OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature);
                  end;
            end; {if ItemType}
          end; {with lstReview}



          with lstCSReview do for i := 0 to Items.Count - 1 do
          begin
            ChangeItem := TChangeItem(Items.Objects[i]);
            if (ChangeItem <> nil) and (ChangeItem.ItemType = CH_ORD) then
              begin
                case State[i] of
                cbChecked:   if Length(ESCode) > 0 then
                             begin
                               SigSts := SS_ESIGNED;
                               RelSts := RS_RELEASE;
                               if ChangeItem.DCOrder then OrderList.Add(ChangeItem.ID + U + SS_ESIGNED + U + RelSts + U + Nature)
                               else CSOrderList.Add(ChangeItem.ID + U + SS_DIGSIG + U + RelSts + U + Nature);
                             end else
                             begin
                               if BILLING_AWARE then
                                  UBACore.SaveUnsignedOrders(ChangeItem.ID+ '1' + GetCheckBoxStatus(ChangeItem.ID) );
                               SigSts := SS_UNSIGNED;
                               RelSts := RS_HOLD;
                             end;
                cbGrayed:    if OrderRequiresSignature(ChangeItem.ID) then
                             begin
                               SigSts := SS_UNSIGNED;
                               RelSts := RS_HOLD;
                             end else
                             begin
                               SigSts := SS_NOTREQD;
                               RelSts := RS_RELEASE;
                             end;
                else         begin                   // (cbUnchecked)
                               SigSts := SS_UNSIGNED;
                               RelSts := RS_HOLD;
                             end;
                end; {case State}

                if (ChangeItem.GroupName = 'Other Unsigned') and (SigSts = SS_UNSIGNED) and (RelSts = RS_HOLD)
                  then //NoOp - don't add unsigned orders from outside session to the list
                else
                  begin
                    if not(State[i] = cbChecked) and (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature) < 0) then
                      OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature)
                    else if (cmdOK.Caption = 'Don''t Sign') and (OrderList.IndexOf(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature) < 0) then
                      OrderList.Add(ChangeItem.ID + U + SigSts + U + RelSts + U + Nature);
                  end;
            end; {if ItemType}
          end; {with lstCSReview}

        end; {OR_PHYSICIAN}
      end; {case User.OrderRole}

          //add csorderlist to totalorderlist in order to do order checking
          for i := 0 to CSOrderList.Count - 1 do
          begin
            TotalOrderList.add(CSOrderList.strings[i]);
          end;

          //add orderlist to totalorderlist in order to do order checking
          for i := 0 to OrderList.Count - 1 do
          begin
            TotalOrderList.add(OrderList.strings[i]);
          end;
          //do order checkign on totalorderlist.  Any order's cancelled will no longer be in totalorderlist
          While (TotalOrderList.Count > 0) do
          begin
            IsOk := ExecuteSessionOrderChecks(TotalOrderList);  // any cancelled orders will be removed from OrderList
            if IsOk then Break;
          end;
          //remove any orders from csorderlist that are no longer part of totalorderlist
          i := CSOrderList.Count - 1;
          while i>=0 do
          begin
            if (TotalOrderList.IndexOf(CSOrderList.strings[i])=-1) then CSOrderList.Delete(i);
            i := i - 1;
          end;

          //remove any orders from orderlist that are no longer part of totalorderlist
          i := OrderList.Count - 1;
          while i>=0 do
          begin
            if (TotalOrderList.IndexOf(OrderList.strings[i])=-1) then OrderList.Delete(i);
            i := i - 1;
          end;

          if CSOrderList.Count > 0 then
          begin
            //check if sc boxes were answered here before dig signing process
            inherited;
            if not IsUserNurseProvider(User.DUZ) then
            begin
                 if (not SigItems.OK2SaveSettings) or (not SigItemsCS.OK2SaveSettings) then
                 begin
                   if (cmdOk.Caption = 'Don''t Sign') then
                      //
                   else
                   begin
                      InfoBox(TX_Order_Error, 'Review/Sign Orders', MB_OK);
                      Exit;
                   end
                 end;
            end;

            try
              //get PKI engine components ready
              NewPKIEncryptionEngine(RPCBrokerV, aPKIEncryptionEngine);
              NewPKIEncryptionDataDEAOrder(aPKIEncryptionDataDEAOrder);

              //check if reader is ready, card in slot, SAN is set in vista user account
              //if no SAN set it will perform the link process in IsDigitalSignatureAvailable
              CallV('ORDEA LNKMSG',[]);
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

              //do PIN entry
              case VerifyPKIPIN(aPKIEncryptionEngine) of
                prOK:
                  begin
                    for i := 0 to CSOrderList.Count - 1 do
                    begin
                      aPKIEncryptionDataDEAOrder.Clear;
                      aPKIEncryptionDataDEAOrder.LoadFromVistA(RPCBrokerV,Patient.DFN,IntToStr(User.DUZ),Piece(Piece(CSOrderList.strings[i],U,1),';',1));
                      try
                        aPKIEncryptionEngine.SignData(aPKIEncryptionDataDEAOrder);

                        //if we get here without an exception then all went well with digital signing of this order
                        cSignature := aPKIEncryptionDataDEAOrder.Signature;
                        cHashData := aPKIEncryptionDataDEAOrder.HashText;
                        cCrlUrl := aPKIEncryptionDataDEAOrder.CrlURL;
                        cErr := '';

                        //store digital sig info for the order
		                    StoreDigitalSig(Piece(CSOrderList.Strings[i],U,1), cHashData, User.DUZ, cSignature, cCrlUrl, Patient.DFN, cErr);
                        if cERR = '' then
                          begin
                          UpdateOrderDGIfNeeded(Piece(CSOrderList.Strings[i],U,1));
                          //if this happens then the order will get released
                          OrderList.Add(CSOrderList.Strings[i]);
                          BAOrderList.Add(Piece(CSOrderList.Strings[i],U,1));
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
                 ShowMsg('The Controlled Substance order(s) will remain unreleased. ' + E.Message);
            end;
          end;
          aPKIEncryptionEngine := nil;
          aPKIEncryptionDataDEAOrder := nil;
      if BILLING_AWARE then
         if UBAGLobals.UnsignedOrders.Count > 0 then
           UBACore.BuildSaveUnsignedList(uBAGLobals.UnsignedOrders);

          // if true BA data in not mandatory.
          if not IsUserNurseProvider(User.DUZ) then
          begin
             if OrdersToBeSignedOrReleased then
             begin
               if (not SigItems.OK2SaveSettings) or (not SigItemsCS.OK2SaveSettings) then
               begin
                 if (cmdOk.Caption = 'Don''t Sign') then
                    SaveCoPay := TRUE
                 else
                 begin
                    InfoBox(TX_Order_Error, 'Review/Sign Orders', MB_OK);
                    Exit;
                 end
               end
               else
                 SaveCoPay := TRUE;
            end
            else
               SaveCoPay := TRUE;

           {Begin BillingAware}
            if  BILLING_AWARE then
            begin
              if (cmdOk.Caption = 'Sign') then
                begin
                  if Not UBACore.BADxEntered then
                  begin
                     InfoBox(TX_NO_DX, TC_NO_DX, MB_OK);
                     Exit;
                  end;
                end;
              {End BillingAware}
             end;
          end;

      // make sure all cs orders are in the orderlist.  if not add them as usnigned/hold
      for checki := 0 to CSOrderList.Count -1 do
      begin
        checkfound := false;
        for checkj := 0 to OrderList.Count - 1 do
        begin
          if Piece(OrderList[checkj],U,1) = Piece(CSOrderList[checki],U,1) then checkfound := true;
        end;
        if not(checkfound) then OrderList.Add(Piece(CSOrderList[checki],U,1) + U + SS_UNSIGNED + U + RS_HOLD + U + Piece(CSOrderList[checki],U,4));
      end;


      {release & print orders}
      // test for LockedForOrdering is to make sure patient is locked if pulling in all unsigned
      if (User.OrderRole in [OR_NOKEY..OR_STUDENT]) and (OrderList.Count > 0)and LockedForOrdering then
      begin
        StatusText('Sending Orders to Service(s)...');
        if (OrderList.Count > 0) then
        begin
        //hds7591  Clinic/Ward movement.  Nurse orders
          if (cmdOk.Caption = 'Sign') or (cmdOK.Caption = 'OK') and (not frmFrame.TimedOut) then
          begin
             tempInpLoc := frmPrintLocation.rpcIsPatientOnWard(patient.dfn);
             if ((Patient.Inpatient = false) and (tempInpLoc <> '')) or
                 ((Patient.Inpatient = True) and (Encounter.Location <> Patient.Location)) or
                 ((Patient.Inpatient = True) and (Encounter.Location = Patient.Location) and
                 (encounter.Location <> uCore.TempEncounterLoc) and (uCore.TempEncounterLoc <> 0))
                 or((Patient.Inpatient) and (tempInpLoc <> '') and (Piece(tempInpLoc, U, 2) <> InttoStr(Encounter.location))) then
             begin
                 if (Encounter.Location <> Patient.Location) or
                     ((tempInpLoc <> '') and ((InttoStr(Encounter.location)) <> (Piece(tempInpLoc,U,2)))) then
                   begin
                     EncLocName := Encounter.LocationName;
                     EncLocIEN  := Encounter.Location;
                     EncLocText := Encounter.LocationText;
                     EncDT := Encounter.DateTime;
                     EncVC := Encounter.VisitCategory;
                   end
                 else
                    begin
                     EncLocName := UCore.TempEncounterLocName;
                     EncLocIEN  := UCore.TempEncounterLoc;
                     EncLocText := uCore.TempEncounterText;
                     EncDT := uCore.TempEncounterDateTime;
                     EncVC := uCore.TempEncounterVistCat;
                    end;
                 if frmFrame.mnuFile.Tag = 0 then displayEncSwitch := false
                 else displayEncSwitch := true;
                 if Encounter.Location = 0  then
                   begin
                     DisplayEncSwitch := True;
                     DelayOnly := True;
                   end;
                 for i := 0 to lstReview.Items.Count-1 do
                   begin
                    //disregard orders that are not signed
                    if (lstReview.Checked[i] = false) and (lstReview.State[i] <> cbGrayed) then continue;
                    TempChangeItem := TChangeItem(lstReview.Items.Objects[i]);
                    //DC Orders should print at the ward location
                    if TempChangeItem.DCOrder = True then
                      begin
                        WardList.Add(tempChangeItem.ID);
                        continue;
                      end;
                    //disregard Non-VA Meds orders
                    if TempChangeItem.OrderDG = NONVAMEDGROUP then continue;
                    if (TempChangeItem.OrderDG = 'Clinic Medications') or (TempChangeItem.OrderDG = 'Clinic Infusions') then
                      ContainsIMOORders := true;
                    if (tempChangeItem.OrderDG = '') then continue;
                    //Delay orders should be printed when the order is release to service not when the order is sign
                    if tempChangeItem.Delay = True then continue;
                    OrderPrintList.Add(tempChangeItem.ID + ':' + tempChangeItem.Text);
                   end;
                 if (OrderPrintList.Count > 0) and (DelayOnly = False) then
                    frmPrintLocation.PrintLocation(OrderPrintList, EncLocIEN, EncLocName, EncLocText, EncDT, EncVC, ClinicList,
                                                   WardList, wardIEN, wardName, ContainsIMOOrders, displayEncSwitch)
                  //Only Display encounter switch form if staying in the patient chart
                  else if displayEncSwitch = true then
                    begin
                      frmPrintLocation.SwitchEncounterLoction(EncLocIEN, EncLocName, EncLocText, EncDT, EncVC);
                      fframe.frmFrame.OrderPrintForm := True;
                      DoNotPrint := True;
                    end;
                 if (WardIEN = 0) and (WardName = '') then CurrentLocationForPatient(Patient.DFN, WardIEN, WardName, ASvc);
                  //All other scenarios should not print
                 if (ClinicList.count = 0) and (WardList.count = 0) then DoNotPrint := True;
             end;
          end;
          if (cmdOk.Caption = 'Don''t Sign') and (not frmFrame.TimedOut) and (frmFrame.mnuFile.Tag <> 0) then
               begin
                 tempInpLoc := frmPrintLocation.rpcIsPatientOnWard(patient.dfn);
                 if ((Patient.Inpatient = false) and (tempInpLoc <> '')) or
                 ((Patient.Inpatient = True) and (Encounter.Location <> Patient.Location)) or
                 ((Patient.Inpatient = True) and (Encounter.Location = Patient.Location) and
                 (encounter.Location <> uCore.TempEncounterLoc) and (uCore.TempEncounterLoc <> 0))
                 or((Patient.Inpatient) and (tempInpLoc <> '') and (Piece(tempInpLoc, U, 2) <> InttoStr(Encounter.location))) then
                    begin
                      if (Encounter.Location <> Patient.Location) or
                          ((tempInpLoc <> '') and ((InttoStr(Encounter.location)) <> (Piece(tempInpLoc,U,2)))) then
                        begin
                          EncLocName := Encounter.LocationName;
                          EncLocIEN  := Encounter.Location;
                          EncLocText := Encounter.LocationText;
                          EncDT := Encounter.DateTime;
                          EncVC := Encounter.VisitCategory;
                        end
                      else
                        begin
                          EncLocName := UCore.TempEncounterLocName;
                          EncLocIEN  := UCore.TempEncounterLoc;
                          EncLocText := uCore.TempEncounterText;
                          EncDT := uCore.TempEncounterDateTime;
                          EncVC := uCore.TempEncounterVistCat;
                        end;
                        frmPrintLocation.SwitchEncounterLoction(EncLocIEN, EncLocName, EncLocText, EncDT, EncVC);
                        fframe.frmFrame.OrderPrintForm := True;
                    end;
               end;
          uCore.TempEncounterLoc := 0;
          uCore.TempEncounterLocName := '';
          tempInpLoc := '';
        end;
        //hds7591  Clinic/Ward movement.

          if SaveCoPay then
            begin
              SigItems.SaveSettings; // Save CoPay FIRST
              SigItemsCS.SaveSettings;
            end;

          SendOrders(OrderList, ESCode);   {*KCM*}


      //CQ #15813 Modired code to look for error string mentioned in CQ and change strings to conts - JCS
        with OrderList do for i := 0 to Count - 1 do
        begin
          if Pos('E', Piece(OrderList[i], U, 2)) > 0 then
          begin
            ChangeItem := Changes.Locate(CH_ORD, Piece(OrderList[i], U, 1));
            if not FSilent then
              begin
                if Piece(OrderList[i],U,4) = TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING then
                  InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) + TX_SAVERR2 + ChangeItem.Text + CRLF + CRLF +
                        TX_SAVERR_PHARM_ORD_NUM, TC_SAVERR, MB_OK)
                else if Piece(OrderList[i],U,4) = TX_SAVERR_IMAGING_PROC_SEARCH_STRING then
                  InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) + TX_SAVERR2 + ChangeItem.Text + CRLF + CRLF +
                        TX_SAVERR_IMAGING_PROC, TC_SAVERR, MB_OK)
                else
                 InfoBox(TX_SAVERR1 + Piece(OrderList[i], U, 4) + TX_SAVERR2 + ChangeItem.Text,
                    TC_SAVERR, MB_OK);
              end;
          end;
          if Pos('R', Piece(OrderList[i], U, 2)) > 0 then
            NotifyOtherApps(NAE_ORDER, 'RL' + U + Piece(OrderList[i], U, 1));
        end;
        if OrdersSignedOrReleased and (not FSilent) then
        begin
          for idx := OrderList.Count - 1 downto 0 do
          begin
            if Pos('E', Piece(OrderList[idx], U, 2)) > 0 then
            begin
              OrderList.Delete(idx);
              Continue;
            end;
            theSts := GetOrderStatus(Piece(OrderList[idx],U,1));
            if theSts = 10 then  OrderList.Delete(idx);  //signed delayed order should not be printed.
          end;
          //  CQ 10226, PSI-05-048 - advise of auto-change from LC to WC on lab orders
          AList := TStringList.Create;
          try
            CheckForChangeFromLCtoWCOnRelease(AList, Encounter.Location, OrderList);
            if AList.Text <> '' then
              ReportBox(AList, 'Changed Orders', TRUE);
          finally
            AList.Free;
          end;
          if (ClinicList.Count > 0) or (WardList.Count > 0) then
                PrintOrdersOnSignReleaseMult(OrderList, CLinicList, WardList, Nature, EncLocIEN, WardIEN, EncLocName, wardName)
          else if DoNotPrint = False then PrintOrdersOnSignRelease(OrderList, Nature, PrintLoc);
        end;
        StatusText('');
        UpdateUnsignedOrderAlerts(Patient.DFN);
        UpdateIndOrderAlerts();
        with Notifications do
          if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
            UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
        UpdateExpiringMedAlerts(Patient.DFN);
        UpdateUnverifiedMedAlerts(Patient.DFN);
        UpdateUnverifiedOrderAlerts(Patient.DFN);
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
      end; {if User.OrderRole}


    finally
      FreeAndNil(OrderList);
      FreeAndNil(OrderPrintList);
      FreeAndNil(ClinicList);
      FreeAndNil(WardList);
    end;
  end;

  { save/sign documents }
  with lstReview do for i := 0 to Items.Count - 1 do
  begin
    ChangeItem := TChangeItem(Items.Objects[i]);
    if ChangeItem <> nil then with ChangeItem do
      case ItemType of
      CH_DOC: if Checked[i]
                then frmNotes.SaveSignItem(ChangeItem.ID, ESCode)
                else frmNotes.SaveSignItem(ChangeItem.ID, '');
      CH_CON: if Checked[i]
                then frmConsults.SaveSignItem(ChangeItem.ID, ESCode)
                else frmConsults.SaveSignItem(ChangeItem.ID, '');
      CH_SUM: if Checked[i]
                then frmDCSumm.SaveSignItem(ChangeItem.ID, ESCode)
                else frmDCSumm.SaveSignItem(ChangeItem.ID, '');
      CH_SUR: if Assigned(frmSurgery) then
              begin
                if Checked[i]
                  then frmSurgery.SaveSignItem(ChangeItem.ID, ESCode)
                  else frmSurgery.SaveSignItem(ChangeItem.ID, '');
              end;
      end; {case}
  end; {with lstReview}
  if frmFrame.Closing then exit;

  // clear all the items that were on the list (but not all in Changes)
  with lstReview do for i := Items.Count - 1 downto 0  do
  begin
    if (not Assigned(Items.Objects[i])) then continue;   {**RV**}
    ChangeItem := TChangeItem(Items.Objects[i]);
    if ChangeItem <> nil then
    begin
      AnID := ChangeItem.ID;
      AType := ChangeItem.ItemType;
      Changes.Remove(AType, AnID);
    end;
  end;
  with lstCSReview do for i := Items.Count - 1 downto 0  do
  begin
    if (not Assigned(Items.Objects[i])) then continue;   {**RV**}
    ChangeItem := TChangeItem(Items.Objects[i]);
    if ChangeItem <> nil then
    begin
      AnID := ChangeItem.ID;
      AType := ChangeItem.ItemType;
      Changes.Remove(AType, AnID);
    end;
  end;
  FOKPressed := IsOk;
  UnlockIfAble;
  Close;
end;

procedure TfrmReview.CleanupChangesList(Sender: TObject; ChangeItem: TChangeItem);
{Added for v15.3 - called by Changes.Remove, but only if fReview in progress}
var
  i: integer;
begin
  with lstReview do
    begin
      i := Items.IndexOfObject(ChangeItem);
      if i > -1 then
        begin
          TChangeItem(Items.Objects[i]).Free;
          Items.Objects[i] := nil;
        end;
    end;
end;

procedure TfrmReview.cmdCancelClick(Sender: TObject);
{ cancelled - do nothing }
begin
  Inherited;
  Close;
end;

procedure TfrmReview.lstReviewMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x:string;
  ARect: TRect;
begin
  inherited;
  AHeight := SigItemHeight;
  with lstReview do if Index < Items.Count then
  begin
    ARect := ItemRect(Index);
    ARect.Left := lstReview.CheckWidth;
    Canvas.FillRect(ARect);
    x := FilteredString(Items[Index]);
    AHeight := WrappedTextHeightByFont( lstReview.Canvas, Font, x, ARect) + SIG_ITEM_VERTICAL_PAD;
    if AHeight > 255 then AHeight := 255;
    if AHeight <  13 then AHeight := 15;
  end;
end;

procedure TfrmReview.FormDestroy(Sender: TObject);
begin
  Application.HintPause := FOldHintPause;
  Application.HintHidePause := FOldHintHidePause;
end;


procedure TfrmReview.lstReviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Itm: integer;

 {Begin BillingAware}
  tempRec: UBAGlobals.TBADxRecord;
  i: smallint;
  thisOrderID: string;
 {End BillingAware}

begin
  inherited;
  Itm := lstReview.ItemAtPos(Point(X, Y), TRUE);
  if (Itm >= 0) then
  begin
    if (Itm <> FLastHintItem) then
    begin
      Application.CancelHint;
  {Begin BillingAware}
   if  BILLING_AWARE then
   begin
       if frmFrame.TimedOut then Exit;
        //Billing Awareness 'flyover' hint includes Dx code(s) when Dx code(s) have been assigned to an order

          if Assigned(frmReview) then
              if Assigned(fReview.frmReview.lstReview.Items.Objects[Itm]) then
                    thisOrderID := TOrder(fReview.frmReview.lstReview.Items.Objects[Itm]).ID;

           if UBAGlobals.tempDxNodeExists(thisOrderID) then
                 begin
                 if Assigned(tempDxList) then
                    try
                      for i := 0 to (tempDxList.Count - 1) do
                         begin
                          tempRec := TBADxRecord(tempDxList.Items[i]);

                          if Assigned(tempRec) then
                            if (tempRec.FOrderID = thisOrderID) then
                                begin
                                with tempRec do
                                   begin
                                   FBADxCode := StringReplace(tempRec.FBADxCode,'^',':',[rfReplaceAll]);
                                   FBASecDx1 := StringReplace(tempRec.FBASecDx1,'^',':',[rfReplaceAll]);
                                   FBASecDx2 := StringReplace(tempRec.FBASecDx2,'^',':',[rfReplaceAll]);;
                                   FBASecDx3 := StringReplace(tempRec.FBASecDx3,'^',':',[rfReplaceAll]);
                                   end;

                                   lstReview.Hint := TrimRight(lstReview.Items[Itm] + #13 +
                                      tempRec.FBADxCode + #13 + tempRec.FBASecDx1 + #13 + tempRec.FBASecDx2 + #13 + tempRec.FBASecDx3);
                                end
                         end //for
                      except
                          on EListError do
                             begin
//                             {$ifdef debug}Show508Message('EListError in fReview.lstReviewMouseMove()');{$endif}
                             raise;
                             end;
                      end;
                 end
           else
               lstReview.Hint := TrimRight(lstReview.Items[Itm]);
   end;
{End BillingAware}

      FLastHintItem := Itm;
      Application.ActivateHint(Point(X, Y));
    end;
  end
  else
  begin
    lstReview.Hint := '';
    FLastHintItem := -1;
    Application.CancelHint;
  end;
end;

procedure TfrmReview.buDiagnosisClick(Sender: TObject);
{Begin BillingAware}
var
  i: smallint;
  thisOrderID: string;
  match: boolean;
  allBlank: boolean;
  numSelected: smallint;
  tmpOrderIDList: TStringList;
  thisChangeItem: TChangeItem;
{End BillingAware}
begin
{Begin BillingAware}
try
 if  BILLING_AWARE then
 begin

  tmpOrderIDList := TStringList.Create;
  if Assigned(tmpOrderIDList) then tmpOrderIDList.Clear;
  BAtmpOrderList.Clear;
  UBAGlobals.PLFactorsIndexes.Clear;

  match := false;
  allBlank := false;

  try
      // User has selected no orders to sign
     for i := 0 to fReview.frmReview.lstReview.Items.Count-1 do
        begin
         if (fReview.frmReview.lstReview.Selected[i]) then
         //*********************************
            begin    //Access Violation fix
            thisChangeItem := TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]);
            if thisChangeItem = nil then
              begin
              fReview.frmReview.lstReview.Selected[i] := false;
              Continue;
              end;
          //*********************************
              thisOrderID := TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).ID;
              {BAV25 Code} //Used to pass selected orders to Lookup DX form
              BAtmpOrderList.Add(TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).TEXT);
              tmpOrderIDList.Add(thisOrderID);
              chkBoxStatus := GetCheckBoxStatus(thisOrderID);
              UBAGlobals.PLFactorsIndexes.Add(IntToStr(i)+ U + chkBoxStatus);
             {BAV25 Code}
             
            // Test for blank Dx on current grid item
            if Not (tempDxNodeExists(thisOrderID)) then
               if Assigned(UBAGlobals.GlobalDxRec) then
                  InitializeNewDxRec(UBAGlobals.globalDxRec);
            begin
               if (tempDxNodeExists(thisOrderID) ) then
                 if not Assigned(UBAGlobals.globalDxRec) then
                    begin
                    UBAGlobals.globalDxRec := UBAGlobals.TBADxRecord.Create;
                    InitializeNewDxRec(UBAGlobals.globalDxRec);
                    GetBADxListForOrder(UBAGlobals.globalDxRec, thisOrderID);
                    end
                 else
                    GetBADxListForOrder(UBAGlobals.globalDxRec, thisOrderID);

                  end
           end; //if
        end; //for
  except
     on EListError do
        begin
//        {$ifdef debug}Show508Message('EListError in fReview.buDiagnosisClick()');{$endif}
        raise;
        end;
  end;

  numSelected  := CountSelectedOrders(UBAConst.F_REVIEW);

  if numSelected = 0 then
     begin
     ShowMsg(UBAMessages.BA_NO_ORDERS_SELECTED);
     Exit;
     end
  else
     if numSelected = 1 then
        match := true;

  if (UBAGlobals.CompareOrderDx(UBAConst.F_REVIEW)) then
     match := true;


  if UBAGlobals.AllSelectedDxBlank(UBAConst.F_REVIEW) then
     allBlank := true;

  if ((match and allBlank) or (match and (not allBlank))) then  // All selected are blank or matching-not-blank
     begin
        frmBALocalDiagnoses.Enter(UBAConst.F_REVIEW,  tmpOrderIDList);
     end
  else
     begin
     //Warning message
     //If 'Yes' on warning message then open localDiagnosis
     if (not allBlank) then
         if MessageDlg(UBAMessages.BA_CONFIRM_DX_OVERWRITE, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                  begin
                  if Assigned(UBAGlobals.globalDxRec) then
                     InitializeNewDxRec(UBAGlobals.globalDxRec);

                  frmBALocalDiagnoses := TfrmBALocalDiagnoses.Create(frmReview);
                  frmBALocalDiagnoses.ShowModal;
                  frmBALocalDiagnoses.Release;

                  end;
     end;
     // TFactors come from FBALocalDiagnoses(Problem List Dx's Only).
     if Length(UBAGlobals.TFactors) > 0 then
     begin
        UBACore.SetTreatmentFactors(UBAGlobals.TFactors);
        SigItems.DisplayPlTreatmentFactors;
     end;
 {End BillingAware}
 if pnlSignature.Visible then
    txtESCode.SetFocus;
   end;
 finally
     if Assigned(tmpOrderIDList) then FreeAndNil(tmpOrderIDList);
 end;
end;

procedure TfrmReview.lstCSReviewClick(Sender: TObject);
//If grid item is an order-able item, then enable the Diagnosis button
// else disable the Diagnosis button.
{Begin BillingAware}
var
  thisChangeItem: TChangeItem;
  i: smallint;
  thisOrderList: TStringList;
{End BillingAware}
begin
thisOrderList := TStringList.Create;

{Begin BillingAware}
 if  BILLING_AWARE then
 begin
    if lstCSReview.Items.Count > 1 then
       Copy1.Enabled := True
    else
       Copy1.Enabled := False;

  try
     for i := 0 to lstCSReview.Items.Count - 1 do
     begin
        if lstCSReview.Selected[i] then
           begin
           thisChangeItem := TChangeItem(lstCSReview.Items.Objects[i]);

           //Disallow copying of a grid HEADER item on LEFT MOUSE CLICK
           if thisChangeItem = nil then
              begin
              buDiagnosis.Enabled := false;
              Copy1.Enabled := false;
              Paste1.Enabled := false;
              Diagnosis1.Enabled := false;
              Exit;
              end;

           if (thisChangeItem <> nil) then
              begin
              thisOrderList.Clear;
              thisOrderList.Add(thisChangeItem.ID);
              // Returns True if All selected orders are N/A, Order selected are NON CIDC or DC'd
              if uBACore.IsAllOrdersNA(thisOrderList) then
                 begin
                 Diagnosis1.Enabled := false;
                 buDiagnosis.Enabled := false;
                 end
              else
                 begin
                 Diagnosis1.Enabled := true;
                 buDiagnosis.Enabled := true;
                 end
              end
           else
              begin
              buDiagnosis.Enabled := false;
              Diagnosis1.Enabled := False;
              Break;
              end;
           end;
        end;
  except
     on EListError do
        begin
//        {$ifdef debug}Show508Message('EListError in fReview.lstCSReviewClick()');{$endif}
        raise;
        end;
  end;
 {End BillingAware}
 end;    
 if Assigned(thisOrderList) then thisOrderList.Free;
end;

procedure TfrmReview.lstCSReviewClickCheck(Sender: TObject);
{ prevent grayed checkboxes from being changed to anything else }
var
  ChangeItem: TChangeItem;

  procedure updateAllChilds(CheckedStatus: boolean; ParentOrderId: string);
  var
    idx: integer;
    AChangeItem: TChangeItem;
  begin
    for idx := 0 to lstCSReview.Items.Count - 1 do
    begin
      AChangeItem := TChangeItem(lstCSReview.Items.Objects[idx]);
      if Assigned(AChangeItem) and (AChangeItem.ParentID = ParentOrderId) then
          if lstCSReview.Checked[idx] <> CheckedStatus then
          begin
            lstCSReview.Checked[idx] := CheckedStatus;
            SigItemsCS.EnableSettings(idx, lstCSReview.checked[Idx]);
          end;
    end;
  end;

begin
  with lstCSReview do
  begin
    ChangeItem := TChangeItem(Items.Objects[ItemIndex]);
    if ChangeItem = nil then Exit;
    
    if ItemIndex > 0 then
    begin
      if (ChangeItem <> nil) then
      begin
        if (ChangeItem.SignState = CH_SIGN_NA) then State[ItemIndex] := cbGrayed
        else
        begin
          SigItemsCS.EnableSettings(ItemIndex, checked[ItemIndex]);
          if Length(ChangeItem.ParentID) > 0 then
            updateAllChilds(checked[ItemIndex], ChangeItem.ParentID);
        end;
      end;
    end;
    if CSItemsAreChecked and nonDCCSItemsAreChecked then
    begin
       lblDeaText.Visible := TRUE;
       lblSmartCardNeeded.Visible := TRUE;
    end
    else
    begin
       lblDeaText.Visible := FALSE;
       lblSmartCardNeeded.Visible := FALSE;
    end;
    pnlSignature.Visible := IsSignatureRequired;
  end;
  if pnlSignature.Visible then
  begin
    txtESCode.SetFocus;
    txtESCodechange(Self);
  end;
end;

procedure TfrmReview.lstCSReviewDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
{ outdent the header items (thus hiding the checkbox) }
var
  x: string;
  ARect, TextRecord: TRect;
  i, dy: integer;
  tempID: string;
  thisRec: UBAGlobals.TBADxRecord;

{Begin BillingAware}
  str: string;
{End BillingAware}

  procedure UpdateTextRecord(r: TRect);
  begin
    TextRecord := r;
    inc(TextRecord.Top, dy);
    dec(TextRecord.Bottom, dy);
  end;

begin
  inherited;
  dy := SIG_ITEM_VERTICAL_PAD div 2;
  x := '';
  ARect := Rect;

  if  BILLING_AWARE then
  begin
     ARect.Right := ARect.Right - 50;

  with lstCSReview do
  begin
    if Items.Objects[Index] = nil then
        ARect.Left := 0;
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.FillRect(ARect);

    if Index < Items.Count then
      begin
       x := Trim(FilteredString(Items[Index]));

       if (ARect.Left = 0) and ( Length(x)>0 ) then
         Canvas.TextOut(ARect.Left + 2, ARect.Top + dy, x)
       else
          if (ARect.Left > 0 ) and ( Length(x)>0 ) then
             begin
             //ARect.Right below controls the right-hand side of the Dx Column
             //Adjust ARect.Right in conjunction with procedure uSignItems.TSigItems.lbDrawItem(), because the
             //two rectangles overlap each other.

             if  BILLING_AWARE then
                begin
                arRect[Index] := Classes.Rect(ARect.Right+2, ARect.Top, ARect.Right + 108, ARect.Bottom);
                Canvas.FillRect(arRect[Index]);
                end;

             //Draw ORDER TEXT
            UpdateTextRecord(ARect);
            DrawText(Canvas.handle, PChar(x), Length(x), TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);

           if  BILLING_AWARE then
                begin
                     //Dx Column lines
                     Canvas.Pen.Color := Get508CompliantColor(clSilver);
                     Canvas.MoveTo(DxRect.Left-1, ARect.Top);
                     Canvas.LineTo(DxRect.Left-1, ARect.Bottom);
                     //Adjust position of 'Diagnosis' column label for font size
                     laDiagnosis.Left := DxRect.Left + 14;
                     if uSignItems.GetAllBtnLeftPos > 0 then
                        laDiagnosis.left := uSignItems.GetAllBtnLeftPos - (laDiagnosis.Width +5);
                     laDiagnosis.Top := lblSig.Top;
                     //Assign DxRect for drawing Dx column and Dx string
                     DxRect.Left := ARect.Right + 1;
                     DxRect.Top := ARect.Top;
                     DxRect.Right := DxRect.Left + 80;
                     DxRect.Bottom := ARect.Bottom;

                    //Display all saved Dx's
                      for i := 0 to lstCSReview.Items.Count-1 do
                        with TOrder(lstCSReview.Items[i]) do
                          begin
                           // HDS00005025
                          if TChangeItem(lstCSReview.Items.Objects[Index]).ITEMTYPE = CH_DOC then
                             tempID := '0' // if document id is equal to valid order id identify billable orders
                          else
                             tempID := TChangeItem(lstCSReview.Items.Objects[Index]).ID;
                            // HDS00005025
                           //WORKS FOR MULTIPLE Dx
                           if Assigned(UBAGlobals.tempDxList) then
                             if UBAGlobals.tempDxNodeExists(tempID) then
                                 begin
                                    thisRec := TBADxRecord.Create;
                                    UBAGlobals.GetBADxListForOrder(thisRec, tempID);
                                    str := Piece(thisRec.FBADxCode, '^', 1); // Display Dx text only - not the ICD-9 code
                                    str := Piece(str, ':', 1);   //in case has : vs. ^
                                    UpdateTextRecord(arRect[Index]);
                                    DrawText(Canvas.handle, PChar(str), Length(str), TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);

                                    if (Not UBACore.IsOrderBillable(tempID)) then// and
                                    begin
                                       Canvas.Font.Color := Get508CompliantColor(clBlue);
                                       UpdateTextRecord(arRect[Index]);
                                       DrawText(Canvas.handle, PChar(NOT_APPLICABLE), Length(NOT_APPLICABLE) , TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                                    end;
                                 end
                              else
                                 begin
                                 //Determine if order is billable. If NOT billable then insert NA in Dx field
                                    if Not UBACore.IsOrderBillable(tempID) then
                                    begin
                                        Canvas.Font.Color := Get508CompliantColor(clBlue);
                                        UpdateTextRecord(arRect[Index]);
                                        DrawText(Canvas.handle, PChar(NOT_APPLICABLE), Length(NOT_APPLICABLE) , TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                                    end;
                                 end;
                          end;
                    end;
        end; //if
      end; //if
  end; //with
 end
 else
    begin
       with lstCSReview do
          begin
          if Items.Objects[Index] = nil then
              ARect.Left := 0;

          Canvas.FillRect(ARect);

          if Index < Items.Count then
             begin
                x := Trim(FilteredString(Items[Index]));

             if (ARect.Left = 0) and ( Length(x) > 0 ) then
                Canvas.TextOut(ARect.Left + 2, ARect.Top + dy, x)
             else
                if (ARect.Left > 0 ) and ( Length(x)>0 ) then
                   begin
                     Canvas.Pen.Color := Get508CompliantColor(clSilver);
                     Canvas.MoveTo(0, ARect.Bottom-1);
                     Canvas.LineTo(ARect.Right, ARect.Bottom-1);
                     UpdateTextRecord(ARect);
                     DrawText(Canvas.handle, PChar(x), Length(x), TextRecord, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
                   end;
             end;
       end;
    end;
end;


procedure TfrmReview.lstCSReviewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Space) then
    FormatListForScreenReader
end;

procedure TfrmReview.lstCSReviewMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x:string;
  ARect: TRect;
begin
  inherited;
  AHeight := SigItemHeight;
  with lstCSReview do if Index < Items.Count then
  begin
    ARect := ItemRect(Index);
    ARect.Left := lstCSReview.CheckWidth;
    Canvas.FillRect(ARect);
    x := FilteredString(Items[Index]);
    AHeight := WrappedTextHeightByFont( lstCSReview.Canvas, Font, x, ARect) + SIG_ITEM_VERTICAL_PAD;
    if AHeight > 255 then AHeight := 255;
    if AHeight <  13 then AHeight := 15;
  end;
end;

procedure TfrmReview.lstCSReviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{
   - Open copy/paste popup menu.
}
var
  ClientPoint: TPoint;
  ScreenPoint: TPoint;
  thisChangeItem: TChangeItem;
  i: integer;
begin
  if not BILLING_AWARE then lstCSReview.PopupMenu := nil;

  if BILLING_AWARE then
     begin
        if Button = mbRight then  //Right-click to open copy/paste popup menu
           begin
           //CQ3325
           if frmReview.lstCSReview.Items.Count = 3 then
              begin
              Copy1.Enabled := false;
              Paste1.Enabled := false
              end
           else
              begin
              Copy1.Enabled := true;
              end;
           //End CQ3325

     //CQ HDS00002954 Fix
     if Button = mbRight then
         //Disallow copying of a grid HEADER item
        for i := 0 to lstCSReview.Items.Count - 1 do
              if lstCSReview.Selected[i] then
                 begin
                
                 thisChangeItem := TChangeItem(lstCSReview.Items.Objects[i]);

                  if thisChangeItem = nil then
                     begin
                     lstCSReview.Selected[i] := false;
                     Copy1.Enabled := false;
                     Paste1.Enabled := false;
                     Exit;
                     end;
                  end;
                    
         if not frmReview.lstCSReview.Selected[lstCSReview.ItemIndex] then
            (Sender as TCheckListBox).Selected[lstCSReview.ItemIndex] := true;

         ClientPoint.X := X;
         ClientPoint.Y := Y;
         ScreenPoint := lstCSReview.ClientToScreen(ClientPoint);
         poBACopyPaste.Popup(ScreenPoint.X, ScreenPoint.Y);
         end;
      end;
end;

procedure TfrmReview.lstCSReviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Itm: integer;

 {Begin BillingAware}
  tempRec: UBAGlobals.TBADxRecord;
  i: smallint;
  thisOrderID: string;
 {End BillingAware}

begin
  inherited;
  Itm := lstCSReview.ItemAtPos(Point(X, Y), TRUE);
  if (Itm >= 0) then
  begin
    if (Itm <> FLastHintItem) then
    begin
      Application.CancelHint;
  {Begin BillingAware}
   if  BILLING_AWARE then
   begin
       if frmFrame.TimedOut then Exit;
        //Billing Awareness 'flyover' hint includes Dx code(s) when Dx code(s) have been assigned to an order

          if Assigned(frmReview) then
              if Assigned(fReview.frmReview.lstCSReview.Items.Objects[Itm]) then
                    thisOrderID := TOrder(fReview.frmReview.lstCSReview.Items.Objects[Itm]).ID;

           if UBAGlobals.tempDxNodeExists(thisOrderID) then
                 begin
                 if Assigned(tempDxList) then
                    try
                      for i := 0 to (tempDxList.Count - 1) do
                         begin
                          tempRec := TBADxRecord(tempDxList.Items[i]);

                          if Assigned(tempRec) then
                            if (tempRec.FOrderID = thisOrderID) then
                                begin
                                with tempRec do
                                   begin
                                   FBADxCode := StringReplace(tempRec.FBADxCode,'^',':',[rfReplaceAll]);
                                   FBASecDx1 := StringReplace(tempRec.FBASecDx1,'^',':',[rfReplaceAll]);
                                   FBASecDx2 := StringReplace(tempRec.FBASecDx2,'^',':',[rfReplaceAll]);;
                                   FBASecDx3 := StringReplace(tempRec.FBASecDx3,'^',':',[rfReplaceAll]);
                                   end;

                                   lstCSReview.Hint := TrimRight(lstCSReview.Items[Itm] + #13 +
                                      tempRec.FBADxCode + #13 + tempRec.FBASecDx1 + #13 + tempRec.FBASecDx2 + #13 + tempRec.FBASecDx3);
                                end
                         end //for
                      except
                          on EListError do
                             begin
//                             {$ifdef debug}Show508Message('EListError in fReview.lstCSReviewMouseMove()');{$endif}
                             raise;
                             end;
                      end;
                 end
           else
               lstCSReview.Hint := TrimRight(lstCSReview.Items[Itm]);
   end;
{End BillingAware}

      FLastHintItem := Itm;
      Application.ActivateHint(Point(X, Y));
    end;
  end
  else
  begin
    lstCSReview.Hint := '';
    FLastHintItem := -1;
    Application.CancelHint;
  end;
end;

procedure TfrmReview.lstReviewClick(Sender: TObject);
//If grid item is an order-able item, then enable the Diagnosis button
// else disable the Diagnosis button.
{Begin BillingAware}
var
  thisChangeItem: TChangeItem;
  i: smallint;
  thisOrderList: TStringList;
{End BillingAware}
begin
thisOrderList := TStringList.Create;

{Begin BillingAware}
 if  BILLING_AWARE then
 begin
    if lstReview.Items.Count > 1 then
       Copy1.Enabled := True
    else
       Copy1.Enabled := False;

  try
     for i := 0 to lstReview.Items.Count - 1 do
     begin
        if lstReview.Selected[i] then
           begin
           thisChangeItem := TChangeItem(lstReview.Items.Objects[i]);

           //Disallow copying of a grid HEADER item on LEFT MOUSE CLICK
           if thisChangeItem = nil then
              begin
              buDiagnosis.Enabled := false;
              Copy1.Enabled := false;
              Paste1.Enabled := false;
              Diagnosis1.Enabled := false;
              Exit;
              end;

           if (thisChangeItem <> nil) then
              begin
              thisOrderList.Clear;
              thisOrderList.Add(thisChangeItem.ID);
              // Returns True if All selected orders are N/A, Order selected are NON CIDC or DC'd
              if uBACore.IsAllOrdersNA(thisOrderList) then
                 begin
                 Diagnosis1.Enabled := false;
                 buDiagnosis.Enabled := false;
                 end
              else
                 begin
                 Diagnosis1.Enabled := true;
                 buDiagnosis.Enabled := true;
                 end
              end
           else
              begin
              buDiagnosis.Enabled := false;
              Diagnosis1.Enabled := False;
              Break;
              end;
           end;
        end;
  except
     on EListError do
        begin
//        {$ifdef debug}Show508Message('EListError in fReview.lstReviewClick()');{$endif}
        raise;
        end;
  end;
 {End BillingAware}
 end;    
 if Assigned(thisOrderList) then thisOrderList.Free;
end;

procedure TfrmReview.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmReview.lstReviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{
   - Open copy/paste popup menu.
}
var
  ClientPoint: TPoint;
  ScreenPoint: TPoint;
  thisChangeItem: TChangeItem;
  i: integer;
begin
  if not BILLING_AWARE then lstReview.PopupMenu := nil;

  if BILLING_AWARE then
     begin
        if Button = mbRight then  //Right-click to open copy/paste popup menu
           begin
           //CQ3325
           if frmReview.lstReview.Items.Count = 3 then
              begin
              Copy1.Enabled := false;
              Paste1.Enabled := false
              end
           else
              begin
              Copy1.Enabled := true;
              end;

     //CQ HDS00002954 Fix
     if Button = mbRight then
         //Disallow copying of a grid HEADER item
        for i := 0 to lstReview.Items.Count - 1 do
              if lstReview.Selected[i] then
                 begin
                
                 thisChangeItem := TChangeItem(lstReview.Items.Objects[i]);

                  if thisChangeItem = nil then
                     begin
                     lstReview.Selected[i] := false;
                     Copy1.Enabled := false;
                     Paste1.Enabled := false;
                     Exit;
                     end;
                  end;
                    
         if not frmReview.lstReview.Selected[lstReview.ItemIndex] then
            (Sender as TCheckListBox).Selected[lstReview.ItemIndex] := true;

         ClientPoint.X := X;
         ClientPoint.Y := Y;
         ScreenPoint := lstReview.ClientToScreen(ClientPoint);
         poBACopyPaste.Popup(ScreenPoint.X, ScreenPoint.Y);
         end;
      end;
end;

procedure TfrmReview.Copy1Click(Sender: TObject);
{
   - Copy contents of the 'source' order for copy/paste operation
}
var
  i : byte;
  numSelected: byte;
  thisChangeItem: TChangeItem;
begin
  try
     if BILLING_AWARE then
        begin
        Paste1.Enabled := true;

         numSelected := GetNumberOfSelectedOrders;

         if numSelected > 1 then
           begin
           ShowMsg('Only 1 order at a time may be selected for ''Copying''');
           Exit;
           end;

            
         for i := 1 to frmReview.lstReview.Items.Count-1 do
             if (frmReview.lstReview.Selected[i]) then
               begin
               thisChangeItem := TChangeItem.Create;
               thisChangeItem := nil;
               thisChangeItem := TChangeItem(lstReview.Items.Objects[i]);
               
               //Skip this one if it's a "header" on the grid
                 if (thisChangeItem = nil) then 
                    begin
                    if Assigned(thisChangeItem) then FreeAndNil(thisChangeItem);
                    Exit;
                    end;

               fReview.srcOrderID := TChangeItem(frmReview.lstReview.Items.Objects[i]).ID;

               //Copy source order to COPY BUFFER and add it to the Dx List
               CopyBuffer := TBADxRecord.Create;
               InitializeNewDxRec(CopyBuffer);
               GetBADxListForOrder(CopyBuffer, fReview.srcOrderID);
               fReview.CopyBuffer.FOrderID := BUFFER_ORDER_ID;
               UBAGlobals.tempDxList.Add(CopyBuffer);

               //***********************************************************************
               if Not UBACore.IsOrderBillable(fReview.srcOrderID) then 
                 begin
                 ShowMsg(BA_NA_COPY_DISALLOWED);
                 fReview.srcOrderID := '';
                 Exit;
                 end;
                 //***********************************************************************

               fReview.srcIndex := lstReview.ItemIndex;
               fReview.chkBoxStatus := GetCheckBoxStatus(fReview.srcOrderID);
               Break;
               end;
        end; //if BILLING_AWARE
   except
     on EListError do
        begin
//        {$ifdef debug}Show508Message('EListError in fReview.Copy1Click()');{$endif}
        raise
        end;
   end;
end;

procedure TfrmReview.Paste1Click(Sender: TObject);
{
  - Populate 'target' orders of a copy/paste operation with contents of 'source' order
}
var
  i: byte;
  thisChangeItem: TChangeItem;
  newRec: TBADxRecord;
begin
  if BILLING_AWARE then
     begin
      if not Assigned(fReview.CopyBuffer) then //CQ5414
        fReview.CopyBuffer := TBADxRecord.Create; //CQ5414
        
  try
      for i := 1 to lstReview.Count - 1 do
          begin
          if (frmReview.lstReview.Selected[i]) then
            begin
            thisChangeItem := TChangeItem(lstReview.Items.Objects[i]);

            //Skip this one if it's a "header" on the grid
            if (thisChangeItem = nil) then
              Continue;

            if (fReview.frmReview.lstReview.Selected[i]) then
              begin
              fReview.targetOrderID := TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).ID;

               if fReview.targetOrderID = fReview.srcOrderID then //disallow copying an order to itself
                  Continue
               else
                  begin
                  fReview.CopyBuffer.FOrderID := BUFFER_ORDER_ID;

                  //***************************************************************
                  if (NOT UBACore.IsOrderBillable(fReview.targetOrderID) ) then
                   begin
                    ShowMsg(BA_NA_PASTE_DISALLOWED);
                    fReview.targetOrderID := '';
                    Continue;
                    end;
                  //***************************************************************

                  newRec := TBADxRecord.Create;
                  with newRec do
                    begin
                      FOrderID := fReview.targetOrderID;
                      FBADxCode := CopyBuffer.FBADxCode;
                      FBASecDx1 := CopyBuffer.FBASecDx1;
                      FBASecDx2 := CopyBuffer.FBASecDx2;
                      FBASecDx3 := CopyBuffer.FBASecDx3;
                    end;

                    tempDxList.Add(newRec);

                    CopyTFCIToTargetOrder(fReview.targetOrderID, fReview.chkBoxStatus);
                     SetCheckBoxStatus(fReview.targetOrderID);  //calls uSignItems.SetSigItems()
                end; //else
            end; //if
          end //if
      else
        Continue
        end; //for
  except
     on EListError do
        begin
//        {$ifdef debug}Show508Message('EListError in fReview.Paste1Click()');{$endif}
        raise;
        end;
  end;

  end; //if BILLING_AWARE

  lstReview.Refresh; //Update grid to show pasted Dx/TF/CI

end;

procedure TfrmReview.ClearDiagnoses1Click(Sender: TObject);
var
  selectedOrderIDList: TStringList;
  i:integer;
begin
  selectedOrderIDList := TStringList.Create;
  selectedOrderIDList.Clear;

  try
   for i := 0 to fReview.frmReview.lstReview.Items.Count-1 do
      begin
         if (fReview.frmReview.lstReview.Selected[i]) then
            selectedOrderIDList.Add(TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).ID);
      end;
   except
     on EListError do
        begin
//        {$ifdef debug}Show508Message('EListError in fReview.ClearDiagnoses1Click()');{$endif}
        raise;
        end;
   end;

   UBACore.ClearSelectedOrderDiagnoses(selectedOrderIDList);
end;

function TfrmReview.GetNonNilItemCount : integer;
//CQ5172
var
  i: integer;
  thisItem: TChangeItem;
  howMany: integer;
begin
  howMany := 0;

  for i := 0 to lstReview.Items.Count-1 do
     begin
     thisItem := TChangeItem(lstReview.Items.Objects[i]);
     if thisItem <> nil then
        Inc(howMany);
     end;
  Result := howMany;
end;

procedure TfrmReview.FormShow(Sender: TObject);
var
  numOrderItems: integer;
begin
  if pnlSignature.Visible then
  else
  if pnlOrderAction.Visible then
  else
    
     //INITIALIZATIONS
      Paste1.Enabled := false;
      fReview.srcOrderID := '';
      fReview.srcDx := '';

     if  BILLING_AWARE then
        frmReview.lstReview.Multiselect := true;

  FormatListForScreenReader;

  //CQ5172
  numOrderItems := GetNonNilItemCount;
 if BILLING_AWARE then
 begin
  if (numOrderItems = 1) then
  begin
   lstReview.Selected[0] := false;
   buDiagnosis.Enabled := True;
   Diagnosis1.Enabled := True;
   lstReview.Selected[1] := true;
     // ** if number of orders is 1 and order is billable select order and disable diagnosis button
   if NOT UBACore.IsOrderBillable(TChangeItem(frmReview.lstReview.Items.Objects[1]).ID) then
   begin
      buDiagnosis.Enabled := False;
      Diagnosis1.Enabled := False;
      lstReview.Selected[1] := false;
   end
   else
      if Piece(TChangeItem(frmReview.lstReview.Items.Objects[1]).ID,';',2) = DISCONTINUED_ORDER then
      begin
           buDiagnosis.Enabled := False;
           Diagnosis1.Enabled :=False ;
      end;
  end
  else
     lstReview.Selected[0] := false;
  //end CQ5172
end;
end;

procedure TfrmReview.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  j: integer; //CQ5054
begin
  inherited;
  currentlySelectedItem := frmReview.lstReview.ItemIndex; //CQ5063

    case Key of
        67,99:  if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorSC,fraCoPay.lblSC2); //C,c
        86,118: if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorCV,fraCoPay.lblCV2); //V,v
        79,111: if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorAO,fraCoPay.lblAO2); //O,o
        82,114: if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorIR,fraCoPay.lblIR2); //R,r
        65,97:  if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorEC,fraCoPay.lblSWAC2); //A,a
        77,109: if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorMST,fraCoPay.lblMST2); //M,m
        78,110: if (ssAlt in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorHNC,fraCoPay.lblHNC2); //N,n
        72,104: if (ssALT in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorSHAD,fraCopay.lblSHAD2); // H,h
        76,108: if (ssALT in Shift) then ShowTreatmentFactorHints(BAFactorsRec.FBAFactorCL,fraCopay.lblCL2); // L,l
        //CQ5054
        83,115: if (ssAlt in Shift) then
                begin
                for j := 0 to lstReview.Items.Count-1 do
                        lstReview.Selected[j] := false;
                lstReview.Selected[1] := true;
                lstReview.SetFocus;
                end;
        09:
            if FRVTFhintWindowActive then
             begin
                FRVTFHintWindow.ReleaseHandle;
                FRVTFHintWindowActive := False;
             end;

        //end CQ5054
    end;
end;

procedure TfrmReview.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //CQ5063
  if Key = VK_SPACE then
     begin
     if lstReview.Focused then //CQ6657
     begin
     lstReview.Selected[lstReview.Items.Count-1] := false;
     lstReview.Selected[currentlySelectedItem] := true;
     end;
     end;
  //end CQ5063
end;

//BILLING AWARE Procedure
procedure TfrmReview.ShowTreatmentFactorHints(var pHintText: string; var pCompName: TVA508StaticText); // 508
var
 HRect: TRect;
 thisRect: TRect;
 x,y: integer;

begin
  if FRVTFhintWindowActive then
  begin
     FRVTFHintWindow.ReleaseHandle;
     FRVTFHintWindowActive := False;
  end;

   FRVTFHintWindow := THintWindow.Create(frmReview); //(frmReview);
   FRVTFHintWindow.Color := clInfoBk;
   GetWindowRect(pCompName.Handle,thisRect);
   x := thisRect.Left;
   y := thisRect.Top;
   hrect := FRVTFHintWindow.CalcHintRect(Screen.Width, pHintText,nil);
   hrect.Left   := hrect.Left + X;
   hrect.Right  := hrect.Right + X;
   hrect.Top    := hrect.Top + Y;
   hrect.Bottom := hrect.Bottom + Y;

   fraCoPay.LabelCaptionsOn(not FRVTFHintWindowActive);

   FRVTFHintWindow.ActivateHint(hrect, pHintText);
   FRVTFHintWindowActive := True;
end;


procedure TfrmReview.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if FRVTFHintWindowActive then
    begin
       FRVTFHintWindow.ReleaseHandle;
       FRVTFHintWindowActive := False;
    end;
end;

procedure TfrmReview.FormPaint(Sender: TObject);
begin
  inherited;

  if frmReview.lstCSReview.count = 0 then
  begin
   frmReview.lstReview.Height := frmReview.pnlReview.Height - frmReview.lstReview.Top - 4;
   frmReview.lstReview.Width := frmReview.pnlReview.Width - frmReview.lstReview.Left - 4;
  end;
  if frmReview.lstReview.count = 0 then
  begin
   frmReview.lstCSReview.Height := frmReview.pnlCSReview.Height - frmReview.lstCSReview.Top - 4;
   frmReview.lstCSReview.Width := frmReview.pnlCSReview.Width - frmReview.lstCSReview.Left - 4;
  end;
end;

procedure TfrmReview.FormResize(Sender: TObject);
VAR
 I, ColHeight: Integer;
begin
  inherited;  

  if frmReview.lstCSReview.count = 0 then
  begin
   frmReview.lstReview.Height := frmReview.pnlReview.Height - frmReview.lstReview.Top - 4;
   frmReview.lstReview.Width := frmReview.pnlReview.Width - frmReview.lstReview.Left - 4;
  end;
  if frmReview.lstReview.count = 0 then
  begin
   frmReview.lstCSReview.Height := frmReview.pnlCSReview.Height - frmReview.lstCSReview.Top - 4;
   frmReview.lstCSReview.Width := frmReview.pnlCSReview.Width - frmReview.lstCSReview.Left - 4;
  end;
  if lstReview.Count > 0 then begin
   for I := 1 to lstReview.Count - 1 do begin
    lstReviewMeasureItem(lstReview, I, ColHeight);
    lstReview.Perform(LB_SETITEMHEIGHT,I,ColHeight);
   end;
  end;
  RedrawWindow(lstReview.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

procedure TfrmReview.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FRVTFHintWindowActive then
  begin
     FRVTFHintWindow.ReleaseHandle;
     FRVTFHintWindowActive := False;
     Application.ProcessMessages;
  end;
end;

procedure TfrmReview.fraCoPayLabel24MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  fraCoPay.LabelCaptionsOn(not FRVTFHintWindowActive);
end;

procedure TfrmReview.FormClose(Sender: TObject; var Action: TCloseAction);
begin

    if FRVTFHintWindowActive then
    begin
       FRVTFhintWindow.ReleaseHandle ;
       FRVTFHintWindowActive := False ;

      with fraCopay do
        begin
        //Long captions
        lblSC.ShowHint := false;
        lblCV.ShowHint := false;
        lblAO.ShowHint := false;
        lblIR.ShowHint := false;
        lblSWAC.ShowHint := false;
        lblHNC.ShowHint  := false;
        lblHNC2.ShowHint := false;
        lblSHAD2.ShowHint := false;
        lblCL2.ShowHint := false;
        end;
 end;

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
end;

procedure TfrmReview.SetItemTextToState;
var
  i : integer;
begin

  if fReview.frmReview.lstReview.Count < 1 then Exit;
  for i := 0 to fReview.frmReview.lstReview.Count-1 do
    if fReview.frmReview.lstReview.Items.Objects[i] <> nil then //Not a Group Title
    begin
      if fReview.frmReview.lstReview.Items.Objects[i] is TChangeItem then
      if fReview.frmReview.lstReview.Checked[i] then
        fReview.frmReview.lstReview.Items[i] := 'Checked '+TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).Text
      else
        fReview.frmReview.lstReview.Items[i] := 'Not Checked '+TChangeItem(fReview.frmReview.lstReview.Items.Objects[i]).Text;
    end;
  if fReview.frmReview.lstReview.ItemIndex >= 0 then
    fReview.frmReview.lstReview.Selected[fReview.frmReview.lstReview.ItemIndex] := True;
end;

procedure TfrmReview.lstReviewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Space) then
    FormatListForScreenReader
end;

procedure TfrmReview.FormatListForScreenReader;
begin
  if ScreenReaderActive then
    SetItemTextToState;
end;

end.

