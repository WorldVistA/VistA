unit UBACore;

interface
uses
  Classes, ORNet, uConst, ORFn, Sysutils, Dialogs, Windows,Messages, UBAGlobals,Trpcb,
  fFrame
  , ORNetIntf
  ;

function  rpcAddToPersonalDxList(UserDUZ:int64; DxCodes:TStringList):boolean;
function  rpcGetPersonalDxList(UserDUZ:int64):TStringList;
function  rpcDeleteFromPersonalDxList(UserDUZ:int64; Dest:TStringList):integer;
procedure rpcSaveBillingDxEntered;  // save dx enteries regardless of being mandatory....
function  rpcNonBillableOrders(pOrderList: TStringList): TStringList;
function  rpcOrderRequiresDx(pList: TStringList):boolean;
procedure rpcSetBillingAwareSwitch(encProvider: int64; pPatientDFN: string);
procedure rpcGetProviderPatientDaysDx(ProviderIEN: string;PatientIEN: string);
procedure rpcGetSC4Orders(aDest: TSTrings;aDFN:String; aList: iORNetMult);

function  rpcTreatmentFactorsActive(pOrderID: string):boolean;
procedure rpcBuildSCIEList(pOrderList: TList);
function  rpcGetUnsignedOrdersBillingData(pOrderList: TStringList):TStringList;
function  rpcRetrieveSelectedOrderInfo(pOrderIDList: TStringList):TStringList;
function  rpcGetTFHintData:TStringList;

procedure rpcSaveNurseConsultOrder(pOrderRec:TStringList);
function  rpcGetBAMasterSwStatus:boolean;
procedure rpcSaveCIDCData(pCIDCList: TStringList);
function  rpcIsPatientInsured(pPatientDFN: string):boolean;

procedure SaveBillingData(pBillingData:TStringList);
function  OrdersHaveDx(pOrderList:TStringList):boolean;
procedure SetTreatmentFactors(TFactors: string);
function  AttachDxToOrderList(pOrderList:TStringList):TStringList;
procedure AttachPLTFactorsToDx(var Dest:String;ProblemRec:string);
procedure BALoadStsFlagsAsIs(StsFlagsIN: string);
function  BADxEntered:boolean;  //  main logic to determine if dx has been entered for order that requires dx
function  StripTFactors(FactorsIN: string): string;
//function  AddProviderPatientDaysDx(Dest: TStringList; ProviderIEN: string;PatientIEN: string) : TStringList;
function  IsOrderBillable(pOrderID: string):boolean;

function  OrderRequiresSCEI(pOrderID :String): boolean;
procedure SaveUnsignedOrders(pOrderRec:String);

procedure CompleteUnsignedBillingInfo(pOrderList: TStringList);
procedure BuildSaveUnsignedList(pOrderList: TStringList);
procedure LoadUnsignedOrderRec(var thisRetVal: TBAUnsignedBillingRec;UnsignedBillingInfo:string);
function  GetUnsignedOrderFlags(pOrderID: string; pFlagList: TStringList):string;  // returns STSFlags if found
procedure BuildTFHintRec;
function  IsAllOrdersNA(pOrderList:TStringList):boolean;
function  PrepOrderID(pOrderID:String): String;
procedure ClearSelectedOrderDiagnoses(pOrderIDList: TStringList);
procedure LoadConsultOrderRec(var thisRetVal: TBAConsultOrderRec; pOrderID: String; pDxList: TStringList);
procedure CompleteConsultOrderRec(pOrderID: string; pDxList: TStringList);
function  GetConsultFlags(pOrderID:String; pFlagList:TStringList;FlagsAsIs:string):string;
function  SetConsultFlags(pPLFactors: string;pFlagsAsIs: string):string; //  return updated flags.
procedure GetBAStatus(pProvider:int64; pPatientDFN: string);
function  IsICD9CodeActive(ACode: string; LexApp: string; ADate:TFMDateTime = 0): boolean;
function  BuildConsultDxRec(ConsultRec: TBAConsultOrderRec): string;
function  ConvertPIMTreatmentFactors(pTFactors:string):string;
procedure DeleteDCOrdersFromCopiedList(pOrderID:string);
procedure UpdateBAConsultOrderList(pDcOrders: TStringList);
function  VerifyOrderIdExists(pOrderList: TStringList): TStringList; // removes records without order id
function  IsCIDCProvider(encProvider:int64):boolean;
function  ProcessProblemTFactors(pText:String):String;

var
  uAddToPDl: integer;
  uDeleteFromPDL: integer;
  uDxLst: TStringList;
  BADxList: TStringList;

implementation

uses fBALocalDiagnoses, fOrdersSign, fReview, rOrders, uCore, rCore, rPCE,uPCE,
     UBAConst, UBAMessages, USignItems;


procedure Show508Message(aMessage:String);
begin
{$IFDEF DEBUG}
  ShowMessage(aMessage);
{$ENDIF}
end;

// -----------------  MAIN CIDC DX HAS BEEN ENTERED LOGIC  ---------------------------
function BADxEntered:boolean;
var
  i: integer;
  //orderStatus: integer;
  x: string;
  passList: TStringList;
  holdOrderList: TStringList;
  thisOrderID: string;
  thisRec: string;
begin
 //  Result := TRUE;   // caused hint.....
   holdOrderList := TStringList.Create;
   holdOrderList.Clear;
   updatedBAOrderList := TStringList.Create;
   updatedBAOrderList.Clear;
   passList := TStringList.Create;
   passList.Clear;
   // determine which orders require a dx (lrmp- only)
   // if NO then continue
   // if YES, check BADxList for orders with DX enteries.
   // if ok then create data string pass to M via RPC

  for i := 0 to BAOrderList.Count-1 do
  begin
     thisRec := BAOrderList.Strings[i];
     thisOrderID := piece(thisRec,';',1) + ';1';  //rebuild orderID pass to M.
     x := BAOrderList.Strings[i];
     //orderStatus := StrToInt(CharAt(Piece(x, ';', 2), 1));  //  Order Status 1=OK, 2=DISCONTINUE
    if IsOrderBillable(thisOrderID) then
     begin
        passList.Add(piece(x,';',1));
        holdOrderList.Add(x);//  place holder for orders that can be signed!
     end;
  end;

   FastAssign(holdOrderList, BAOrderList); //assign signable orders to BAOrderList for further processing
   holdOrderList.Clear; // CQ5025

    //call with passList determine if LRMP
     if rpcOrderRequiresDx(passList) then
      FastAssign(updatedBAOrderList, BAOrderList);

    // check of all orders dx columns are flagged with N/A.....
    if UBACore.IsAllOrdersNA(BAOrderList) then
    begin
       Result := TRUE;              //  force true, no record needs DX entry
       Exit;                        //to do.  clean this up... when time permitts
    end
    else
      begin
      if OrdersHaveDx(UBAGlobals.BAOrderList) then
      begin
         Result := True; // CIDC orders have dx
         SaveBillingData(UBAGlobals.BAOrderList) ;
      end
      else
         begin
            Result := FALSE;
            Exit;
         end;
     end;
end;


function rpcOrderRequiresDx(pList: TStringList):boolean;
var x: string;
    i,j: integer;
    returnList, updatedList: TStringList;
   begin
    Result := FALSE;  // initial set dx NOT required
    returnList := TStringList.Create;
    updatedList := TStringList.Create;
    returnList.Clear;
    updatedList.Clear;
    // remove deleted orderid's
    if UBAGlobals.BADeltedOrders.Count > 0 then
    begin
       for i := 0 to UBAGlobals.BADeltedOrders.Count-1 do
          x := UBAGlobals.BADeltedOrders.Strings[i];
         for j := 0 to pList.Count-1 do
         begin
            if x = pList.Strings[j] then
              continue   // orderid is removed.. or skipped
            else
               updatedList.Add(x);
         end;
    end
    else
       FastAssign(pList, updatedList);

    // call returns boolean, orders is billable=1 or nonbillable=0 or discontinued = 0
    CallVistA('ORWDBA1 ORPKGTYP',[updatedList],returnList);

     //Remove NON LRMP orders from the mix(when checking for dx entry);
     // BAOrderList and pList are in sync - order id....
     for i := 0 to BAOrderList.Count-1 do
     begin
        x:= piece(returnList.Strings[i],'^',1);
        if x = BILLABLE_ORDER  then
        begin
           updatedBAOrderList.Add(BAOrderList[i]);
           Result := TRUE;
        end;
    end;
end;


// UBAGlobals.NonBillableOrderList must be populated prior to calling this function.
// call   rpcNonBillableOrders to populate List.
function IsOrderBillable(pOrderID: string):boolean ;
var
  i: integer;
  currOrderID: string;
  matchOrderID : string;

begin
  Result := TRUE;    //  = Billable
  currOrderID := PrepOrderID(pOrderID);
  if Piece(pOrderID,';',2) = DISCONTINUED_ORDER THEN
  begin
     Result := FALSE;
     Exit;
  end;
  try
     for i := 0 to UBAGlobals.NonBillableOrderList.Count -1 do
     begin
        matchOrderID := PrepOrderID( (Piece(UBAGlobals.NonBillableOrderList.Strings[i],U,1)) );
        if currOrderID = matchOrderID  then
        begin
           Result := FALSE;  //= Non Billable
           Exit;
        end;
     end;
  except
     on EListError do
        begin
        ShowMessage('EListError in UBACore.IsOrderBillable()');
        raise;
        end;
  end;
end;


procedure SaveBillingData(pBillingData:TStringList);
var
  RecsToSave: TStringList;
begin
  RecsToSave := TStringList.Create;
  RecsToSave.Clear;

  RecsToSave := AttachDxToOrderList(pBillingData); //call with new Biling data, return-code returned
  rpcSaveCIDCData(RecsToSave);  // verify and save billing data

  if Assigned(UBAGlobals.BAOrderList) then UBAGlobals.BAOrderList.Clear; // hds00005025
end;

function rpcTreatmentFactorsActive(pOrderID:string): boolean;
var x: string;
    i: integer;
    pList: TStringList;
    rList: TStringList;
   begin
      pList := TStringList.Create;
      rList := TStringList.Create;
      rList.Clear;
      rList := nil;
      pList.Clear;
      pList.Add(pOrderID);
      Result := FALSE;
     // call returns boolean, orders is billable=1 or nonbillable=0 or discontinued = 0
      CallVistA('ORWDBA1 ORPKGTYP',[pList],rList);
     //returns boolean value by OrderID - True = billable
     for i := 0 to rList.Count-1 do
     begin
        x := rList[i];
        if rList[i] = BILLABLE_ORDER then
        begin
           Result := True;
        end;
     end;
end;


function AttachDxToOrderList(pOrderList:TStringList):TStringList;
var
  i: integer;
  newBillingList: TStringList;
  baseDxRec: TBADxRecord;
  currentOrderID: string;
  currentOrderString: string;
  dxString,FlagsStatsIn: string;

begin
   newBillingList:= TStringList.Create;
   newBillingList.Clear;
   dxString := '';
   baseDxRec := nil;
   baseDxRec := TBADxRecord.Create;

  InitializeNewDxRec(baseDxRec);
  for i := 0 to pOrderList.Count-1 do
  begin
     currentOrderString := pOrderList.Strings[i];
     currentOrderID := piece(pOrderList.Strings[i],';',1)+ ';1';

     GetBADxListForOrder(baseDxRec, currentOrderID);
     FlagsStatsIn := BAFlagsIN;
     dxString := currentOrderString + '^' + piece(baseDxRec.FBADxCode,':',2);
     if baseDxRec.FBASecDx1 <> '' then
        dxString := dxString + '^' + piece(baseDxRec.FBASecDx1,':',2);
     if baseDxRec.FBASecDx2 <> '' then
        dxString := dxString + '^' + piece(baseDxRec.FBASecDx2,':',2);
     if baseDxRec.FBASecDx3 <> '' then
        dxString := dxString + '^' + piece(baseDxRec.FBASecDx3,':',2);

     NewBillingList.Add(dxString);
     InitializeNewDxRec(baseDxRec);  //HDS00004744
  end;
  Result := NewBillingList;
end;

function  rpcAddToPersonalDxList(UserDUZ:int64; DxCodes:TStringList):boolean;
var
  x: String;
//input example ien^code(s) = 12345^306.70^431.22
begin
   Result := CallVistA('ORWDBA2 ADDPDL', [UserDUZ,DxCodes], x) and (x = '1');
end;

function rpcGetPersonalDxList(UserDUZ:int64):TStringList;
begin
  Result := TSTringList.Create;
    CallVistA('ORWDBA2 GETPDL', [UserDUZ],Result);
end;

function rpcDeleteFromPersonalDxList(UserDUZ: int64; Dest: TStringList)
  : integer;
begin
  CallVistA('ORWDBA2 DELPDL', [UserDUZ, Dest], uDeleteFromPDL);
  Result := uDeleteFromPDL;
end;

// returns value used to bypass Billing Aware if needed.
// turns off visual and functionality
procedure rpcSetBillingAwareSwitch(encProvider: int64; pPatientDFN: string);
var
  s: String;
begin
  // Is Provider -> Is Master Sw -> Is CIDC SW -> Is Patient Insured
  BILLING_AWARE := FALSE;
  // verify user is a provider
  if (encProvider <> 0) and PersonHasKey(encProvider, 'PROVIDER') then
  // Master switch is set "ON"
  begin
    if CallVistA('ORWDBA1 BASTATUS', [nil], s) and (s = '1') then
      // User is CIDC Enabled
      if CallVistA('ORWDBA4 GETBAUSR', [encProvider], s) and (s = '1') then
      begin
        // Verify Patient is Insured
        // OR Switch = 2 ask questions for all patients.
        if rpcIsPatientInsured(pPatientDFN) then
          BILLING_AWARE := TRUE;
      end;
  end;
end;

//  verify CIDC Master Switch and Provider is CIDC Enabled.
//  Patient insurance check is bypassed.  (hds7564)
function  IsCIDCProvider(encProvider:int64):boolean;
begin
    Result := False;
    if rpcGetBAMasterSwStatus then
       if (encProvider <> 0) and PersonHasKey(encProvider, 'PROVIDER') then
          Result := True;
end;

function rpcGetBAMasterSwStatus:boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDBA1 BASTATUS', [nil],s) and (s = '1');    //  Master switch is set "ON"
end;

procedure rpcSaveNurseConsultOrder(pOrderRec:TStringList);
begin
  rpcSaveCIDCData(pOrderRec);
end;

procedure rpcSaveBillingDxEntered; // if not mandatory and user enters dx.
var
  ordersWithDx, i: integer;
  newBillingList: TStringList;
  baseDxRec, tempDxRec: TBADxRecord;
  currentOrderID, thisOrderID: string;
  currentOrderString, thisRec: string;
begin
  // verify Dx has been entered for orders checked for signature..
  ordersWithDx := 0;
  tempDxRec := TBADxRecord.Create;
  UBAGlobals.InitializeNewDxRec(tempDxRec);
  for i := 0 to BAOrderList.Count - 1 do
  begin
    thisRec := BAOrderList.Strings[i];
    thisOrderID := piece(thisRec, ';', 1) + ';1'; // rebuild orderID pass to M.
    if tempDxNodeExists(thisOrderID) then
      inc(ordersWithDx);
  end;

  // if orders have dx enteries - save billing data.
  if ordersWithDx > 0 then
  begin
    newBillingList := TStringList.Create;
    newBillingList.Clear;
    baseDxRec := nil;
    baseDxRec := TBADxRecord.Create;
    InitializeNewDxRec(baseDxRec);

    try
      for i := 0 to BAOrderList.Count - 1 do
      begin
        currentOrderString := BAOrderList.Strings[i];
        currentOrderID := piece(BAOrderList.Strings[i], ';', 1) + ';1';
        GetBADxListForOrder(baseDxRec, currentOrderID);
        if baseDxRec.FBADxCode <> '' then
        begin
          newBillingList.Add(currentOrderString + '^' + baseDxRec.FBADxCode +
            '^' + baseDxRec.FBASecDx1 + '^' + baseDxRec.FBASecDx2 + '^' +
            baseDxRec.FBASecDx3);
        end;
      end;
    except
      on EListError do
      begin
Show508Message('EListError in UBACore.rpcSaveBillingDxEntered()');
        raise;
      end;
    end;

    rpcSaveCIDCData(newBillingList);
    if Assigned(newBillingList) then
      FreeAndNil(newBillingList);
  end;
end;

procedure rpcGetSC4Orders(aDest: TSTrings;aDFN:String;aList: iORNetMult);
begin
//  ****** RPC Logic returning SC/TF codes for COPAY  ********
//     if (CIDC is ON) and (PatientInsured is True) then
//        return SC/TF for OutPatient Meds, Labs, Prosthetics, Imaging.
//     else
//       return SC/TF for Outpatient Meds only.
  CallVistA('ORWDBA1 SCLST',[aDFN, aList],aDest);
end;

procedure rpcGetProviderPatientDaysDx(ProviderIEN: string; PatientIEN: string);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
  uDxLst := TStringList.Create;
  tmplst.Clear;
  uDxLst.Clear;
  try
    CallVistA('ORWDBA2 GETDUDC', [ProviderIEN, PatientIEN], tmplst);
    FastAssign(tmplst, UBACore.uDxLst);
  finally
    tmplst.Free;
  end;
end;


function rpcGetTFHintData:TStringList;
begin
  CallVistA('ORWDBA3 HINTS', [nil],BATFHints);
  Result := BATFHints;
end;

//  call made to determine if order type is billable
//  if order type NOT billable, flagged with "NA".
function rpcNonBillableOrders(pOrderList: TStringList): TStringList;
var
  x: string;
  i: integer;
  rList: TStringList;
begin
  rList := TStringList.Create;
  rList.Clear;
  NonBillableOrderList.Clear;
  // call returns boolean, orders is billable=1 or nonbillable=0 or discontinued = 0
  try
    CallVistA('ORWDBA1 ORPKGTYP', [pOrderList], rList);
    for i := 0 to rList.Count - 1 do
    begin
      x := rList[i];
      if rList[i] <> BILLABLE_ORDER then
        NonBillableOrderList.Add(pOrderList[i] + U + 'NA');
    end;
    Result := NonBillableOrderList;
  finally
    rList.Free;
  end;
end;


procedure rpcBuildSCIEList(pOrderList: TList);
var
  AnOrder: TOrder;
  OrderIDList: TStringList;
  rList: TStringList;
  i: integer;
begin
  OrderIDList := TStringList.Create;
  rList := TStringList.Create;
  if Assigned(OrderListSCEI) then
    OrderListSCEI.Clear;
  OrderIDList.Clear;
  rList.Clear;
  for i := 0 to pOrderList.Count - 1 do
  begin
    AnOrder := TOrder(pOrderList.Items[i]);
    OrderIDList.Add(AnOrder.ID);
  end;
  // call returns boolean, orders is billable=1 or nonbillable=0 or discontinued = 0
  try
    CallVistA('ORWDBA1 ORPKGTYP', [OrderIDList], rList);

    for i := 0 to rList.Count - 1 do
    begin
      if rList.Strings[i] = BILLABLE_ORDER then
        OrderListSCEI.Add(OrderIDList.Strings[i]);
    end;
  finally
    rList.Free;
  end;
end;

procedure rpcSaveCIDCData(pCIDCList: TStringList);
var
  CIDCList: TStringList;
begin
  CIDCList := TStringList.Create;
  CIDCList.Clear;
  // insure record contain valid orderid
  if pCIDCList.Count > 0 then
  begin
    CIDCList := VerifyOrderIdExists(pCIDCList);
    if CIDCList.Count > 0 then
      CallVistA('ORWDBA1 RCVORCI', [CIDCList]);
  end;
  if Assigned(CIDCList) then
    FreeAndNil(CIDCList);
end;

function rpcIsPatientInsured(pPatientDFN: string): boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDBA7 ISWITCH', [pPatientDFN], s) and (s > '0');
end;


function OrdersHaveDx(pOrderList:TStringList):boolean;
var
  i: integer;
  thisOrderID: string;
  thisRec: string;
  tempDxRec: TBADxRecord;
begin
     Result := TRUE;
     tempDxRec := nil;
     tempDxRec := TBADxRecord.Create;
     UBAGlobals.InitializeNewDxRec(tempDxRec);

  try
     for i := 0 to pOrderList.Count-1 do
     begin
          thisRec := pOrderList.Strings[i];
          thisOrderID := piece(thisRec,';',1) + ';1';  //rebuild orderID pass to M.
          if not tempDxNodeExists(thisOrderID) then
          begin
             Result := FALSE;
             Break;
          end
          else
          begin
             GetBADxListForOrder(tempDxRec, thisOrderID);
             if tempDxRec.FBADxCode = '' then
                begin
                   Result := FALSE;
                   Break;
                end;
          end;

     end;
  except
     on EListError do
        begin
        Show508Message('EListError in UBACore.OrdersHaveDx()');
        raise;
        end;
  end;

   if Assigned(tempDxRec) then
       FreeAndNil(tempDxRec);
end;




procedure LoadUnsignedOrderRec(var thisRetVal: TBAUnsignedBillingRec;UnsignedBillingInfo:string);
var
  thisString : String;
begin
  thisString := UnsignedBillingInfo;
   with thisRetVal do
   begin
      FBAOrderID       := Piece(thisString,U,1) + ';1';
      FBASTSFlags      := Piece(thisString,U,2);
      FBADxCode        := (Piece(thisString,U,4)+ U + (Piece(thisString,U,3)));
      FBASecDx1        := (Piece(thisString,U,6)+ U + (Piece(thisString,U,5)));
      FBASecDx2        := (Piece(thisString,U,8)+ U + (Piece(thisString,U,7)));
      FBASecDx3        := (Piece(thisString,U,10)+ U + (Piece(thisString,U,9)));
      //  if codes are absent then get rid of '^'.
      if FBADxCode = U then FBADxCode := DXREC_INIT_FIELD_VAL;
      if FBASecDx1 = U then FBASecDx1 := DXREC_INIT_FIELD_VAL;
      if FBASecDx2 = U then FBASecDx2 := DXREC_INIT_FIELD_VAL;
      if FBASecDx3 = U then FBASecDx3 := DXREC_INIT_FIELD_VAL;
   end;
end;

procedure AttachPLTFactorsToDx(var Dest:String;ProblemRec:string);
var
    TFResults: string;
    thisRec: TBAPLFactorsIN;
begin
    TFResults := '';
    thisRec := TBAPLFactorsIN.Create;
    thisRec.FBADxText            := Piece(ProblemRec,'(',1);
    thisRec.FBADxText            := Piece(thisRec.FBADxText,U,2);
    thisRec.FBADxCode            := Piece(ProblemRec,U,3);
    thisRec.FBASC                := Piece(ProblemRec,U,5);
    thisRec.FBASC_YN             := Piece(ProblemRec,U,6);
    //HDS8409
    if StrPos(PChar(ProblemRec),'(') <> nil then
       thisRec.FBATreatFactors :=  ProcessProblemTFactors(ProblemRec)
    else
    begin
       thisRec.FBATreatFactors  := Piece(ProblemRec,')',1);
       thisRec.FBATreatFactors  := Piece(thisRec.FBATreatFactors,'(',2);
    end;
    //HDS8409
  with thisRec do
  begin
      if StrLen(pchar(FBATreatFactors)) > 0 then   // 0 Treatment Factors exist
      //build string containing Problem List Treatment Factors
        TFResults := ( FBADXCode + U + FBADxText  + '  (' + FBASC + '/' + FBATreatFactors + ')  ' )
      else
        if StrLen(PChar(FBASC)) > 0 then
           TFResults := ( FBADxCode + U + FBADxText  + '  (' + FBASC + ')  ' )
        else
           TFResults := ( FBADxCode + U  + FBADxText );
  end;

    Dest := TFResults;
end;


// this code is to handle adding Problem List(only) TF's when selected
procedure BALoadStsFlagsAsIs(StsFlagsIN: String);
var
  x: string;
begin
   x:= Piece(StsFlagsIN,U,2);
   UBAGlobals.SC  := Copy(x,1,1);
   UBAGlobals.AO  := Copy(x,2,1);
   UBAGlobals.IR  := Copy(x,3,1);
   UBAGlobals.EC  := Copy(x,4,1);
   UBAGlobals.MST := Copy(x,5,1);
   UBAGlobals.HNC := Copy(x,6,1);
   UBAGlobals.CV  := Copy(x,7,1);
   UBAGlobals.SHD := Copy(x,8,1);
   UBAGlobals.CL  := Copy(x,9,1);
end;


// this code is to handle adding Problem List(only) TF's when selected

procedure SetTreatmentFactors(TFactors: string);
var
 strTFactors : string;
 strFlagsOut: string;
 FlagsIN : TStringList;
 Idx: string;
 i : integer;
begin
    UBAGlobals.BAFlagsOUT := TStringList.Create;
    UBAGlobals.BAFlagsOUT.Clear;
    FlagsIN := TStringList.Create;
    FlagsIN.Clear;
    FlagsIN := UBAGlobals.PLFactorsIndexes;

    for i:= 0 to FlagsIN.Count-1 do
    begin
       BALoadStsFlagsAsIs(FlagsIN.Strings[i]);
       IDX := Piece(FlagsIN.Strings[i],U,1);

       strTFactors := TFactors;

       if UBAGlobals.SC  <> 'N' then
          if StrPos(PChar(strTFactors),PChar(SERVICE_CONNECTED)) <> nil then
             UBAGlobals.SC := 'C' ;

       if UBAGlobals.SC <> 'N' then
          if StrPos(PChar(strTFactors),PChar(NOT_SERVICE_CONNECTED)) <> nil then
             UBAGlobals.SC := 'U';

       if UBAGlobals.AO <>'N' then
          if StrPos(PChar(strTFactors),PChar(AGENT_ORANGE)) <> nil then
             UBAGlobals.AO := 'C';

       if UBAGlobals.IR <>'N' then
          if StrPos(PChar(strTFactors),PChar(IONIZING_RADIATION)) <> nil then
             UBAGlobals.IR := 'C';

       if UBAGlobals.EC <>'N' then
          if StrPos(PChar(strTFactors),PChar(ENVIRONMENTAL_CONTAM)) <> nil then
             UBAGlobals.EC := 'C';

       if UBAGlobals.MST <>'N' then
          if StrPos(PChar(strTFactors),PChar(MILITARY_SEXUAL_TRAUMA)) <> nil then
             UBAGlobals.MST := 'C';

       if UBAGlobals.CV <>'N' then
          if StrPos(PChar(strTFactors),PChar(COMBAT_VETERAN)) <> nil then
             UBAGlobals.CV := 'C';

       if UBAGlobals.HNC <>'N' then
          if StrPos(PChar(strTFactors),PChar(HEAD_NECK_CANCER)) <> nil then
             UBAGlobals.HNC := 'C';

       if UBAGlobals.SHD <> 'N' then
          if StrPos(PChar(strTFactors),PChar(SHIPBOARD_HAZARD_DEFENSE)) <> nil then
             UBAGlobals.SHD := 'C';

       if UBAGlobals.CL <> 'N' then
          if StrPos(PChar(strTFactors),PChar(CAMP_LEJEUNE)) <> nil then
             UBAGlobals.CL := 'C';

       //  Build Treatment Factor List to be passed to fOrdersSign form
       strFlagsOut := (SC + AO + IR + EC + MST + HNC + CV + SHD + CL);
       UBAGlobals.BAFlagsOUT.Add(IDX + '^' + strFlagsOut );
     end;
  end;

function StripTFactors(FactorsIN: string):string;
var strDxCode,strDxName:string;
begin
   Result := '';
   strDxCode := Piece(FactorsIN,U,2);
   strDxName := Piece(FactorsIN,'(',1);
   Result := (strDxName + U + strDxCode);
end;
(*
function AddProviderPatientDaysDx(Dest: TStringList; ProviderIEN: string;
  PatientIEN: string): TStringList;
var
  i: integer;
  x: string;
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
  CallVistA('ORWDBA2 GETDUDC', [ProviderIEN, PatientIEN], tmplst);
  try
    for i := 0 to tmplst.Count - 1 do
      x := tmplst.Strings[i];
  except
    on EListError do
    begin
Show508Message('EListError in UBACore.AddProviderPatientDaysDx()');
      raise;
    end;
  end;

  Result := tmplst;
end;
*)

function  OrderRequiresSCEI(pOrderID: string):boolean;
var i:integer;

begin
    Result := False;

  try
    for i := 0 to UBAGlobals.OrderListSCEI.Count-1 do
    begin
       if pOrderID = UBAGlobals.OrderListSCEI.Strings[i] then
       begin
          Result := True;
          Break;
       end;
    end;
  except
     on EListError do
        begin
        Show508Message('EListError in UBACore.OrderRequiresSCEI()');
        raise;
        end;
  end;
end;

procedure SaveUnsignedOrders(pOrderRec:String);
begin
     // save all unsigned orders, keeping freview and fordersSign in sync
     // this change may have an impact on response time??????
     // change from save orders with dx to save all. 06/24/04
     // /  if not  clear treatment factors for order is non cidc
   uBAGlobals.UnsignedOrders.Add(pOrderRec);

end;

function rpcRetrieveSelectedOrderInfo(pOrderIDList: TStringList): TStringList;
var
  newList: TStringList;
  i: integer;
  x: string;
begin
  Result := TStringList.Create;
  newList := TStringList.Create;
  try
    for i := 0 to pOrderIDList.Count - 1 do
    begin
      newList.Add(piece(pOrderIDList.Strings[i], ';', 1));
      x := newList.Strings[i];
    end;
    if newList.Count > 0 then
      CallVistA('ORWDBA4 GETTFCI', [newList], Result);
  finally
    newList.Free;
  end;
end;

procedure BuildSaveUnsignedList(pOrderList: TStringList);
var
  thisList: TStringList;
  rList: TStringList;
begin

  thisList := TStringList.Create;
  rList := TStringList.Create;
  if Assigned(rList) then
    rList.Clear;
  if Assigned(thisList) then
    thisList.Clear;
  SaveBillingData(pOrderList);
  // save unsigned info to be displayed when recalled at later time
end;

function rpcGetUnsignedOrdersBillingData(pOrderList: TStringList): TStringList;
var
  i: integer;
  newList: TStringList;
  rList: TStringList;
begin
  newList := TStringList.Create;
  rList := TStringList.Create;
  if Assigned(newList) then
    newList.Clear;
  if Assigned(rList) then
    rList.Clear;
  Result := rList;

  if pOrderList.Count = 0 then
    Exit;
  for i := 0 to pOrderList.Count - 1 do
  begin
    newList.Add(piece(pOrderList.Strings[i], ';', 1));
  end;
  CallVistA('ORWDBA4 GETTFCI', [newList], rList);
  Result := rList;
end;

procedure CompleteUnsignedBillingInfo(pOrderList:TStringList);
var
i: integer;
RecOut : TBADxRecord;
copyList: TStringList;
begin
   copyList := TStringList.Create;
   if Assigned(copyList) then copyList.Clear;

   if Assigned(BAUnSignedOrders) then  BAUnSignedOrders.Clear;

   if not Assigned(UBAGlobals.UnsignedBillingRec) then
   begin
      UBAGlobals.UnSignedBillingRec := UBAGlobals.TBAUnsignedBillingRec.Create;
      UBAGlobals.InitializeUnsignedOrderRec(UBAGlobals.UnsignedBillingRec);
   end;

   UBAGlobals.InitializeUnsignedOrderRec(UnsignedBillingRec);

  try
     for i := 0 to pOrderList.Count-1 do
        begin
           LoadUnsignedOrderRec(UBAGlobals.UnsignedBillingRec, pOrderList.Strings[i]);
           if Not UBAGlobals.tempDxNodeExists(UnsignedBillingRec.FBAOrderID) then
           begin
              SimpleAddTempDxList(UnSignedBillingRec.FBAOrderID);
              RecOut := TBADxRecord.Create;
              RecOut.FExistingRecordID := UnSignedBillingRec.FBAOrderID;
              RecOut.FBADxCode  := UnsignedBillingRec.FBADxCode;
              RecOut.FBASecDx1  := UnsignedBillingRec.FBASecDx1;
              RecOut.FBASecDx2  := UnsignedBillingRec.FBASecDx2;
              RecOut.FBASecDx3  := UnsignedBillingRec.FBASecDx3;
              RecOut.FTreatmentFactors := UnSignedBillingRec.FBASTSFlags;
              PutBADxListForOrder(RecOut, RecOut.FExistingRecordID);
              UBAGlobals.BAUnSignedOrders.Add(UnSignedBillingRec.FBAOrderID + '^' + UnSignedBillingRec.FBASTSFlags);
           end
           else
           begin
              RecOut := TBADxRecord.Create;
              if tempDxNodeExists(UnSignedBillingRec.FBAOrderID) then
              begin
                 GetBADxListForOrder(RecOut, UnSignedBillingRec.FBAOrderID); //load data from source
                 copyList.Add(UnSignedBillingRec.FBAOrderID + '^' + UnSignedBillingRec.FBASTSFlags);
                 BuildSaveUnsignedList(copyList);
             end;
         end;
     end;
     except
     on EListError do
        begin
        Show508Message('EListError in UBACore.CompleteUnsignedBillingInfo()');
        raise;
        end;
  end;
end;

function  GetUnsignedOrderFlags(pOrderID: string; pFlagList: TStringList):string;
var
  i: integer;
begin
   Result := '';
   try
    for i := 0 to pFlagList.Count-1 do
       begin
          if pOrderID = Piece(pFlagList.Strings[i],U,1) then
          begin
             Result := Piece(pFlagList.Strings[i],U,2); //  STSFlags
             Break;
          end;
       end;
  except
     on EListError do
        begin
        Show508Message('EListError in UBACore.GetUnsignedOrderFlags()');
        raise;
        end;
  end;

end;

// BuildTFHintRec is meant to run once, first user of the session
// contains the information to be displayed while mouse-over in fOrdersSign and fReview.
procedure BuildTFHintRec;
var
  hintList: TStringList;
  i: integer;
  x, x1, x2, x3: string;

  procedure setValue(var anItem:String; anX,anY:String);
  begin
    if anX = '1' then
      anItem := anY
    else
      anItem := anItem + CRLF + anY;
  end;

begin
  // hintList := TStringList.Create;
  // if Assigned(hintList) then hintList.Clear;

  hintList := rpcGetTFHintData; // function returns reference on BATFHints

  if hintList.Count > 0 then
    UBAGlobals.BAFactorsRec.FBAFactorActive := TRUE;

  try
    for i := 0 to hintList.Count - 1 do
    begin
      x := hintList.Strings[i];
      x1 := piece(x, U, 1);
      x2 := piece(x, U, 2);
      x3 := piece(x, U, 3);

      if x1 = SERVICE_CONNECTED then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorSC,x2,x3)
      else if x1 = AGENT_ORANGE then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorAO,x2,x3)
      else if x1 = IONIZING_RADIATION then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorIR,x2,x3)
      else if x1 = ENVIRONMENTAL_CONTAM then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorEC,x2,x3)
      else if x1 = HEAD_NECK_CANCER then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorHNC,x2,x3)
      else if x1 = MILITARY_SEXUAL_TRAUMA then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorMST,x2,x3)
      else if x1 = COMBAT_VETERAN then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorCV,x2,x3)
      else if x1 = SHIPBOARD_HAZARD_DEFENSE then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorSHAD,x2,x3)
      else if x1 = CAMP_LEJEUNE then
        setValue(UBAGlobals.BAFactorsRec.FBAFactorCL,x2,x3);
(*
      if piece(x, U, 1) = SERVICE_CONNECTED then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorSC := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorSC :=
            (UBAGlobals.BAFactorsRec.FBAFactorSC + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = AGENT_ORANGE then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorAO := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorAO :=
            (UBAGlobals.BAFactorsRec.FBAFactorAO + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = IONIZING_RADIATION then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorIR := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorIR :=
            (UBAGlobals.BAFactorsRec.FBAFactorIR + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = ENVIRONMENTAL_CONTAM then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorEC := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorEC :=
            (UBAGlobals.BAFactorsRec.FBAFactorEC + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = HEAD_NECK_CANCER then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorHNC := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorHNC :=
            (UBAGlobals.BAFactorsRec.FBAFactorHNC + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = MILITARY_SEXUAL_TRAUMA then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorMST := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorMST :=
            (UBAGlobals.BAFactorsRec.FBAFactorMST + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = COMBAT_VETERAN then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorCV := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorCV :=
            (UBAGlobals.BAFactorsRec.FBAFactorCV + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = SHIPBOARD_HAZARD_DEFENSE then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorSHAD := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorSHAD :=
            (UBAGlobals.BAFactorsRec.FBAFactorSHAD + CRLF + piece(x, U, 3));
      end
      else if piece(x, U, 1) = CAMP_LEJEUNE then
      begin
        if piece(x, U, 2) = '1' then
          UBAGlobals.BAFactorsRec.FBAFactorCL := piece(x, U, 3)
        else
          UBAGlobals.BAFactorsRec.FBAFactorCL :=
            (UBAGlobals.BAFactorsRec.FBAFactorCL + CRLF + piece(x, U, 3));
      end;
*)
    end;
  except
    on EListError do
    begin
Show508Message('EListError in UBACore.BuileTFHintRec()');

      raise;
    end;
  end;
end;


function IsAllOrdersNA(pOrderList: TStringList): boolean;
var
  i: integer;
  rList: TStringList;
begin
  rList := TStringList.Create;
  if Assigned(rList) then
    rList.Clear;
  Result := TRUE; // disables dx button

  // call returns boolean, orders is billable=1 or nonbillable=0 or discontinued = 0
  try
    CallVistA('ORWDBA1 ORPKGTYP', [pOrderList], rList);

    for i := 0 to rList.Count - 1 do
    begin
      if rList.Strings[i] = BILLABLE_ORDER then
      begin
        Result := FALSE;
        Break;
      end;
    end;
  finally
    rList.Free;
  end;
end;

function  PrepOrderID(pOrderID:String): String;
var
  newOrderID: String;
begin
   newOrderID := '';
   if pos(';',pOrderID) > 0 then
          newOrderID := Piece(pOrderID,';',1)
       else
          newOrderID := pOrderID ;

    Result := newOrderID;
end;

procedure ClearSelectedOrderDiagnoses(pOrderIDList: TStringList);
var
  RecOut: TBADXRecord;
  i: integer;
begin
  try
     for i := 0 to pOrderIDList.Count-1 do
     begin
         if UBAGlobals.tempDxNodeExists(pOrderIDList.Strings[i]) then
         begin
            RecOut := TBADxRecord.Create;
            GetBADxListForOrder(RecOut, pOrderIDList.Strings[i]);
            RecOut.FOrderID   := RecOut.FOrderID;
            RecOut.FBADxCode  := DXREC_INIT_FIELD_VAL;
            RecOut.FBASecDx1  := DXREC_INIT_FIELD_VAL;
            RecOut.FBASecDx2  := DXREC_INIT_FIELD_VAL;
            RecOut.FBASecDx3  := DXREC_INIT_FIELD_VAL;
            PutBADxListForOrder(RecOut, pOrderIDList.Strings[i]);
            frmReview.lstReview.Refresh;
         end;
     end;
  except
     on EListError do
        begin
           Show508Message('EListError in UBACore.ClearSelectedORdersDiagnoses()');
           raise;
        end;
  end;
end;

procedure LoadConsultOrderRec(var thisRetVal: TBAConsultOrderRec; pOrderID: String; pDxList: TStringList);
var
  thisString, thisFlags:String;
  dx1,dx2,dx3,dx4: string;
  i: integer;
begin
   thisFlags := '';
   dx1 := '';
   dx2 := '';
   dx3 := '';
   dx4 := '';
   UBAGlobals.BAConsultDxList.Sort;

  try
   for i := 0 to UBAGlobals.BAConsultDxList.Count -1 do
      begin
         thisString := UBAGlobals.BAConsultDxList[i];

         if i = 0 then
            begin
               if pos( '(', thisString) > 0 then
                  begin
                  thisFlags := Piece(thisString,'(',2);
                  thisFlags := Piece(thisFlags,')',1);
                  UBAGlobals.BAConsultPLFlags.Add(pOrderID + U + thisFlags);
                  dx1 := Piece(thisString,U,2);
                  dx1 := Piece(dx1,'(',1) + U + Piece(thisString,':',2);
                  end
               else
                  begin
                  dx1 := Piece(thisString,U,2);
                  dx1 := Piece(dx1,':',1)+ U + Piece(thisString,':',2);
                  end
            end
         else
            if i = 1 then
               begin
               if pos( '(', thisString) > 0 then
                  begin
                     dx2 := Piece(thisString,U,2);
                     dx2 := Piece(dx2,'(',1)+ U + Piece(thisString,':',2);
                  end
               else
                   begin
                      dx2 := Piece(thisString,U,2);
                      dx2 := Piece(dx2,':',1)+ U + Piece(thisString,':',2);
                   end
               end
            else
               if i = 2 then
                  begin
                  if pos( '(', thisString) > 0 then
                     begin
                        dx3 := Piece(thisString,U,2);
                        dx3 := Piece(dx3,'(',1)+ U + Piece(thisString,':',2);
                     end
                  else
                     begin
                        dx3  := Piece(thisString,U,2);
                        dx3  := Piece(dx3,':',1)+ U + Piece(thisString,':',2);
                     end
                  end
               else
                  if i = 3 then
                     begin
                     if pos( '(', thisString) > 0 then
                        begin
                           dx4 := Piece(thisString,U,2);
                           dx4 := Piece(dx4,'(',1)+ U + Piece(thisString,':',2);
                        end
                     else
                        begin
                           dx4 := Piece(thisString,U,2);
                           dx4 := Piece(dx4,':',1)+ U + Piece(thisString,':',2);
                        end;
                     end;
      end;
  except
     on EListError do
        begin
        Show508Message('EListError in UBACore.LoadConsultOrderRec()');
        raise;
        end;
  end;

      with thisRetVal do
      begin
        FBAOrderID          := pOrderID;
        FBATreatmentFactors:= thisFlags;
        FBADxCode        := dx1;
        FBASecDx1        := dx2;
        FBASecDx2        := dx3;
        FBASecDx3        := dx4;
       end;
end;

procedure LoadTFactorsInRec(var thisRetVal: TBATreatmentFactorsInRec; pOrderID:string; pEligible: string; pTFactors:string);
begin
     with thisRetVal do
     begin
        FBAOrderID    := pOrderID;
        FBAEligible   := pEligible;
        FBATFactors   := pTFactors;
     end;
end;

procedure CompleteConsultOrderRec(pOrderID: string; pDxList: TStringList);
var
  RecOut : TBADxRecord;
  TfFlags,dxRec: string;
  orderList : TStringList;
  tmpOrderList: TStringList;
begin
    orderList    := TStringList.Create;
    tmpOrderList := TStringList.Create;
    orderList.Clear;
    tmpOrderList.Clear;
    if not Assigned(uBAGlobals.ConsultOrderRec)then
       begin
          UBAGlobals.ConsultOrderRec := UBAGlobals.TBAConsultOrderRec.Create;
          InitializeConsultOrderRec(UBAGlobals.ConsultOrderRec);
       end
    else
       InitializeConsultOrderRec(UBAGlobals.ConsultOrderRec);
    // call rpc to load list with boolean values based on orders package type.
    UBAGlobals.NonBillableOrderList.Clear;
    tmpOrderList.Add(UBAGLobals.BAOrderID);
    rpcNonBillableOrders(tmpOrderList);
    if IsOrderBillable(uBAGlobals.BAOrderID) then
    begin
       if not UBAGlobals.tempDxNodeExists(uBAGlobals.BAOrderID) then
          begin
             LoadConsultOrderRec(UBAGlobals.ConsultOrderRec,UBAGlobals.BAOrderID,uBAGlobals.BAConsultDxList);
             if NOT UBAGlobals.tempDxNodeExists(pOrderID) then
                SimpleAddTempDxList(pOrderID);
             RecOut := TBADxRecord.Create;
             RecOut.FExistingRecordID := pOrderID;
             RecOut.FBADxCode  := ConsultOrderRec.FBADxCode;
             RecOut.FBASecDx1  := ConsultOrderRec.FBASecDx1;
             RecOut.FBASecDx2  := ConsultOrderRec.FBASecDx2;
             RecOut.FBASecDx3  := ConsultOrderRec.FBASecDx3;
             RecOut.FTreatmentFactors := ConsultOrderRec.FBATreatmentFactors;
             PutBADxListForOrder(RecOut, RecOut.FExistingRecordID);
//  HDS00003380
             if IsUserNurseProvider(User.DUZ) then
             begin
                dxRec := BuildConsultDxRec(ConsultOrderRec);
                orderList.Add(RecOut.FExistingRecordID);
              //  TfFlags := Piece(GetPatientTFactors(orderList),U,2);
                TfFlags := GetPatientTFactors(orderList);
                TfFlags := ConvertPIMTreatmentFactors(TfFlags);
                orderList.Clear;
              //  if strLen(PChar(dxRec)) > 0 then
              //     orderList.Add(RecOut.FExistingRecordID +TfFlags + '^'+ BuildConsultDxRec(ConsultOrderRec) )
              //  else
                   orderList.Add(RecOut.FExistingRecordID +TfFlags);
                SaveBillingData(OrderList);  //  save unsigned info to be displayed when re
             end;
          end;
      end;
end;

function  GetConsultFlags(pOrderID:String; pFlagList:TStringList;FlagsAsIs:string):string;
var
   i: integer;  //add code to match order id.....
begin
  Result := '';
    for i := 0 to pFlagList.Count -1 do
        begin
           if pOrderID = Piece(pFlagList.Strings[i],U,1) then
           begin
              Result := SetConsultFlags( Piece(pFlagList.Strings[i],U,2), FlagsAsIs);
              break;
           end;
        end;

end;

function  SetConsultFlags(pPLFactors: string; pFlagsAsIs:string):string; //  return updated flags.
var
  strFlagsAsIs: string;
  strTFactors: string;
  strFlagsOut,x: string;

begin
    strFlagsAsIs  := pFlagsAsIs; // flags from pims
    strTFactors   :=  pPLFactors;  // value selected from problem list
    strFlagsOut   := '';   // flags updated with selected values from problem list
    x             := strFlagsAsIs;
    Result        := '';

    UBAGlobals.SC  := Copy(x,1,1);
    UBAGlobals.AO  := Copy(x,2,1);
    UBAGlobals.IR  := Copy(x,3,1);
    UBAGlobals.EC  := Copy(x,4,1);
    UBAGlobals.MST := Copy(x,5,1);
    UBAGlobals.HNC := Copy(x,6,1);
    UBAGlobals.CV  :=  Copy(x,7,1); // load factors to global vars;
    UBAGlobals.SHD := Copy(x,8,1);
    UBAGlobals.CL := Copy(x,9,1);

  if UBAGlobals.SC  <> 'N' then
       if StrPos(PChar(strTFactors),PChar(SERVICE_CONNECTED)) <> nil then
          UBAGlobals.SC := 'C' ;

    if UBAGlobals.SC <> 'N' then
       if StrPos(PChar(strTFactors),PChar(NOT_SERVICE_CONNECTED)) <> nil then
          UBAGlobals.SC := 'U';

    if UBAGlobals.AO <>'N' then
       if StrPos(PChar(strTFactors),PChar(AGENT_ORANGE)) <> nil then
          UBAGlobals.AO := 'C';

    if UBAGlobals.IR <>'N' then
       if StrPos(PChar(strTFactors),PChar(IONIZING_RADIATION)) <> nil then
          UBAGlobals.IR := 'C';

    if UBAGlobals.EC <>'N' then
       if StrPos(PChar(strTFactors),PChar(ENVIRONMENTAL_CONTAM)) <> nil then
          UBAGlobals.EC := 'C';

    if UBAGlobals.MST <>'N' then
       if StrPos(PChar(strTFactors),PChar(MILITARY_SEXUAL_TRAUMA)) <> nil then
          UBAGlobals.MST := 'C';

    if UBAGlobals.HNC <> 'N' then
       if StrPos(PChar(strTFactors),PChar(HEAD_NECK_CANCER)) <> nil then
          UBAGlobals.HNC := 'C';

    if UBAGlobals.CV <>'N' then
       if StrPos(PChar(strTFactors),PChar(COMBAT_VETERAN)) <> nil then
          UBAGlobals.CV := 'C';

    if UBAGlobals.SHD <> 'N' then
       if StrPos(PChar(strTFactors),PChar(SHIPBOARD_HAZARD_DEFENSE)) <> nil then
          UBAGlobals.SHD := 'C';

    if UBAGlobals.CL <> 'N' then
       if StrPos(PChar(strTFactors),PChar(CAMP_LEJEUNE)) <> nil then
          UBAGlobals.CL := 'C';

     strFlagsOut := (UBAGlobals.SC + UBAGlobals.AO + UBAGlobals.IR +
                     UBAGlobals.EC + UBAGlobals.MST + UBAGlobals.HNC +
                     UBAGlobals.CV + UBAGlobals.SHD);
  Result := strFlagsOut;
end;

procedure GetBAStatus(pProvider:int64; pPatientDFN: string);
begin
  // sets global switch, based in value returned from server.
  // True ->  Billing Aware Switch ON. else OFF

  UBACore.rpcSetBillingAwareSwitch(pProvider,pPatientDFN);

  if Assigned(UBAGlobals.BAPCEDiagList) then UBAGlobals.BAPCEDiagList.Clear;
     frmFrame.SetBADxList;
  if not UBAGlobals.BAFactorsRec.FBAFactorActive then
     UBACore.BuildTFHintRec;
end;

function IsICD9CodeActive(ACode: string; LexApp: string; ADate: TFMDateTime = 0): boolean;
var
  s,
  inactiveChar : string;
begin
    inactiveChar := '#';
    if StrPos(PChar(ACode),PChar(inactiveChar) ) <> nil then
       ACode := Piece(ACode,'#',1);  //  remove the '#' added for inactive code.
   Result := CallVistA('ORWPCE ACTIVE CODE',[ACode, LexApp, ADate], s) and (s = '1');
end;

function  BuildConsultDxRec(ConsultRec: TBAConsultOrderRec): string;
var
newString: string;
begin
   if strLen(PChar(ConsultRec.FBADxCode)) > 0 then
      newString := Piece(ConsultRec.FBADxCode,U,2)
   else
      if strLen(PChar(ConsultRec.FBASecDx1)) > 0 then
         newString := newString + '^' + Piece(ConsultRec.FBASecDx1,U,2)
   else
      if strLen(PChar(ConsultRec.FBASecDx2)) > 0 then
         newString := newString + '^' + Piece(ConsultRec.FBASecDx2,U,2)
   else
      if strLen(PChar(ConsultRec.FBASecDx3)) > 0 then
         newString := newString + '^' + Piece(ConsultRec.FBASecDx3,U,2);
   Result := newString;
end;

function  ConvertPIMTreatmentFactors(pTFactors:string):string;
var
 strSC,strAO, strIR: string;
 strEC, strMST, strHNC, strCV: string;

begin
    Result := '';
   if StrPos(PChar(pTFactors),PChar(SERVICE_CONNECTED)) <> nil then
      strSC := '?'
   else
      strSC := 'N';

   if StrPos(PChar(pTFactors),PChar(AGENT_ORANGE)) <> nil then
      strAO := '?'
   else
      strAO := 'N';

   if StrPos(PChar(pTFactors),PChar(IONIZING_RADIATION)) <> nil then
      strIR := '?'
   else
      strIR := 'N';

   if StrPos(PChar(pTFactors),PChar(ENVIRONMENTAL_CONTAM)) <> nil then
      strEC := '?'
   else
      strEC := 'N';

   if StrPos(PChar(pTFactors),PChar(MILITARY_SEXUAL_TRAUMA)) <> nil then
      strMST := '?'
   else
      strMST := 'N';

   if StrPos(PChar(pTFactors),PChar(HEAD_NECK_CANCER)) <> nil then
      strHNC := '?'
   else
      strHNC := 'N';

   if StrPos(PChar(pTFactors),PChar(COMBAT_VETERAN)) <> nil then
      strCV := '?'
   else
      strCV := 'N';

   Result := (strSC + strAO + strIR + strEC + strMST + strHNC + strCV);
end;


// Delete dc'd orders from BACopiedOrderList to keep things in sync.
procedure DeleteDCOrdersFromCopiedList(pOrderID:string);
var i:integer;
    holdList: TStringList;
    x: string;
begin
   holdList := TStringList.Create;
   holdList.Clear;
   FastAssign(UBAGlobals.BACopiedOrderFlags, holdList);
   UBAGlobals.BACopiedOrderFlags.Clear;
   for i := 0 to holdList.Count-1 do
   begin
      x := Piece(holdList.Strings[i],';',1);
      if pOrderID = Piece(holdList.Strings[i],';',1) then
         continue
      else
         UBAGlobals.BACopiedOrderFlags.Add(holdList.Strings[i]);
   end;
end;

procedure UpdateBAConsultOrderList(pDcOrders: TStringList);
var
 x: string;
 var i,j: integer;
 holdList : TStringList;
begin
   // remove order enteries from the dx list that are being discontinued.
   for i := 0 to pDcOrders.Count -1 do
   begin
       UBAGlobals.RemoveOrderFromDxList(pDcOrders.Strings[i]);
   end;
   if UBAGlobals.BAConsultPLFlags.Count > 0 then
   begin
      holdList := TStringList.Create;
      holdList.Clear;
      FastAssign(UBAGlobals.BAConsultPLFlags, holdList);
      UBAGlobals.BAConsultPLFlags.Clear;
      for i := 0 to holdList.Count-1 do
      begin
         x := holdList.Strings[i];
         for j := 0 to pDcOrders.Count-1 do
         begin
            if x = pDcOrders.Strings[j] then
            continue
            else
               UBAGlobals.BAConsultPLFlags.Add(x);
         end;
      end;
   end;
end;

// loop thru CIDC records remove records with invalid orderid
function  VerifyOrderIdExists(pOrderList: TStringList): TStringList;
var
  goodList: TStringList;
  tOrderID: integer;
 i: integer;
begin
  goodList := TStringList.Create;
  goodList.clear;

  if pOrderList.Count > 0 then
  begin
      for i := 0 to pOrderList.Count-1 do
      begin
         tOrderID := StrToIntDef(Piece(pOrderList.Strings[i],';',1), 0);
         if tOrderID > 0 then
            goodList.add(pOrderList.Strings[i]);
      end;
  end;
  result := goodList;
end;

// parse string return Treatment Factors when text inlcudes multiple "(())"
//HDS8409
function  ProcessProblemTFactors(pText:String):String;
var AText1,x: string;
    i,j: integer;
begin
 if StrPos(PChar(pText),'(') = nil then exit;
 AText1 := Piece(pText,U,2);
 i := 1;
 j := 0;
 while j = 0 do
 begin
    x := Piece(AText1,'(',i);
    if Length(x) > 0 then
       inc(i)
    else
    begin
       x := Piece(AText1,'(',i-1);
       x := Piece(x,')',1);
       j := 1;
       Result := x;
    end;
  end;
end;

end.
