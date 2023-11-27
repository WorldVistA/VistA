 unit UBAGlobals;

{$OPTIMIZATION OFF}

interface

uses
  Classes,
  ORNet,
  uConst,
  ORFn,
  Sysutils,
  Dialogs,
  Windows,
  Messages,
  rOrders;

type

 {Problem List Record Used To Add New DX From SignOrders Form }
 TBAPLRec = class(TObject)
  constructor Create(PLlist:TStringList);
   function BuildProblemListDxEntry(pDxCode:string):TStringList;
   function FMToDateTime(FMDateTime: string): TDateTime;

 end;

 {patient qualifiers}
 TBAPLPt=class(TObject)
 public
   PtVAMC:string;
   PtDead:string;
   PtBid:string;
   PtServiceConnected:boolean;
   PtAgentOrange:boolean;
   PtRadiation:boolean;
   PtEnvironmental:boolean;
   PtHNC:boolean;
   PtMST:boolean;
   PtSHAD:boolean;
    PtCL: boolean;
   constructor Create(Alist:TStringList);
   function GetGMPDFN(dfn:string;name:String):string;
//   function rpcInitPt(const PatientDFN: string): TStrings ;
// public
   procedure LoadPatientParams(AList:TstringList);

 end;

  TBAGlobals = class(TObject)
  private
     FOrderNum: string;
    protected
  public
     constructor Create;
     property  OrderNum: string read FOrderNum write FOrderNum;
     procedure AddBAPCEDiag(DiagStr:string);
     procedure ClearBAPCEDiagList;
  end;

 TBADxRecord = class(TObject)
 public
     FExistingRecordID: string;
     FOrderID: string;
     FBADxCode: string; //Primary Dx
     FBASecDx1: string; //Secondary Dx 1
     FBASecDx2: string; //Secondary Dx 2
     FBASecDx3: string; //Secondary Dx 3
     FDxDescCode: string;
     FDxDesc1: string;
     FDxDesc2: string;
     FDxDesc3: string;
     FTreatmentFactors: string;
 end;

 TBACopiedOrderFlags = class
 public
     OrderID: string;
 end;

 TBATreatmentFactorsInRec = class(TObject)
 public
     FBAOrderID:   string;
     FBAEligible:  string;
     FBATFactors:  string;
 end;

 TBAUnsignedBillingRec = class(TObject)
 public
     FBAOrderID:  string;
     FBASTSFlags: string;
     FBADxCode:   string;
     FBASecDx1:   string;
     FBASecDx2:   string;
     FBASecDx3:   string;
 end;

 TBAConsultOrderRec = class(TObject)
 public
    FBAOrderID:  string;
    FBADxCode:   string;
    FBASecDx1:   string;
    FBASecDx2:   string;
    FBASecDx3:   string;
    FBATreatmentFactors: string;
 end;

 TBAClearedBillingRec = class(TObject)
 public
     FBAOrderID:  string;
     FBASTSFlags: string;
     FBADxCode:   string;
     FBASecDx1:   string;
     FBASecDx2:   string;
     FBASecDx3:   string;
 end;

  TBAFactorsRec = class(TObject)
  public
     FBAFactorActive    : boolean;
     FBAFactorSC        : string;
     FBAFactorMST       : string;
     FBAFactorAO        : string;
     FBAFactorIR        : string;
     FBAFactorEC        : string;
     FBAFactorHNC       : string;
     FBAFactorCV        : string;
     FBAFactorSHAD       : string;
    FBAFactorCL: string;
  end;

  TBAPLFactorsIN = class(TOBject)
  public
      FPatientID         : string; // UProblems.piece 1
      FBADxText          : string; // UProblems.piece 2
      FBADxCode          : string; // UProblems.piece 3
      FBASC              : string; // UProblems.piece 5
      FBASC_YN           : string; // UProblems.piece 6
      FBATreatFactors    : string; //(......)
  end;

  TBACBStsFlagsIN = class(TOBject) // Y/N/U
  public
     CB_Sts_Flags       :string;
  //   CB_SC              :string;
     CB_AO              :string;
     CB_IR              :string;
     CB_EC              :string;
     CB_MST             :string;
     CB_HNC             :string;
     CB_CV              :string;
     CB_SHAD             :string;
  end;

procedure PutBADxListForOrder(var thisRecord: TBADxRecord; thisOrderID: string); //BAPHII 1.3.1
procedure CopyDxRecord(sourceOrderID: string; targetOrderID: string); //BAPHII 1.3.1
function  GetPrimaryDx(thisOrderID: string) : string; //BAPHII 1.3.1
function  tempDxNodeExists(thisOrderID: string) : boolean;
function  GetDxNodeIndex(thisOrderID: string) : smallint;
function  DiagnosesMatch(var List1: TStringList; var List2: TStringList) : boolean;
function  CountSelectedOrders(const Caller: smallint) : smallint;
function  CompareOrderDx(const Caller: smallint) : boolean;
procedure GetBADxListForOrder(var thisRetVal: TBADxRecord; thisOrderID: string);
procedure DestroyDxList;
procedure SetBADxList;
procedure SimpleAddTempDxList(thisOrderID: string);
procedure SetBADxListForOrder(thisRec: TBADxRecord; thisOrderID: string);
function  AllSelectedDxBlank(const Caller: smallint) : boolean;
function  SecondaryDxFull(thisOrderID: string) : boolean;
procedure AddSecondaryDx(thisOrderID: string; thisDxCode: string);
procedure InitializeNewDxRec(var thisDxRec:  TBADxRecord);
procedure InitializeConsultOrderRec(var thisDxRec: TBAConsultOrderRec);
procedure InitializeUnsignedOrderRec(var thisUnsignedRec: TBAUnsignedBillingRec);
procedure InitializeTFactorsInRec(var thisTFactorsRecIn: TBATreatmentFactorsInRec);
procedure BACopyOrder(sourceOrderList: TStringList);  //BAPHII 1.3.2
procedure CopyTreatmentFactorsDxsToCopiedOrder(pSourceOrderID:string; pTargetOrderID:string); //BAPHII 1.3.2
procedure CopyTreatmentFactorsDxsToRenewedOrder; //BAPHII 1.3.2
function GetTFCIForOrder(thisIndex: integer) : string; //BAPHII 1.3.2
procedure CopyTFCIToTargetOrder(thisTargetOrderID: string; thisCheckBoxStatus: string);

procedure ResetOrderID(fromID: string; toID: string);
procedure RemoveOrderFromDxList(thisOrderID: string);
function IsUserNurseProvider(pUserID: int64): boolean;
function GetPatientTFactors(pOrderList:TStringList): String;

var
  BAGlobals         : TBAGlobals;
  BAPLPt            : TBAPLPt;
  BAPLRec           : TBAPLRec;
  PLlist            : TStringList;
  BADiagnosisList   : TStringList;
  BALocation        : integer;
  BAPCEDiagList     : TStringList;
  BAOrderIDList    : TStringList;
  tempDxList        : TList;
  globalDxRec       : TBADxRecord;
  UnsignedBillingRec   : TBAUnsignedBillingRec;
  ClearedBillingRec    : TBAClearedBillingRec;
  ConsultOrderRec      : TBAConsultOrderRec;
  BAFactorsInRec        : TBATreatmentFactorsInRec;
  BAFactorsRec      : TBAFactorsRec;
  BAOrderList       : TStringList;
  UpdatedBAOrderList: TStringList;
  ChangeItemOrderNum: string;
  OrderIDList       : TStringList;
  OrderBillableList : TStrings;
  BAOrderID         : string;
  BILLING_AWARE     : boolean;

  BAtmpOrderList    : TStringList;
  BAFlagsIN         : string;
  BAFlagsOUT        : TStringList;

  SourceOrderID     : string; //BAPHII 1.3.2
  TargetOrderID     : string; //BAPHII 1.3.2
  BACopiedOrderFlags: TStringList; //BAPHII 1.3.2
  BANurseConsultOrders: TStringList;

 // Used to display Dx's on grids
  Dx1               : string;
  Dx2               : string;
  Dx3               : string;
  Dx4               : string;
  TFactors          : string;
  SC,AO,IR          : string;
  MST, HNC, CV, SHD, EC, CL: string;
  PLFactorsIndexes  : TStringList;
  BAHoldPrimaryDx   : string;     //  used to verify primart dx has been changed.
  BAPrimaryDxChanged: boolean;
  NonBillableOrderList : TStringList;  // contains reference to those selected orders that are non billable
  OrderListSCEI    : TSTringList;  //   OrderID Exists SCEI are required.
  UnsignedOrders   : TStringList;  //    List of Orders when "don't sign" action
  BAUnSignedOrders  : TStringList;  // OrderID^StsFlags  ie., 12345^NNNNNNN
  BATFHints        : TStringList;
  BASelectedList   : TStringList;  //  contains list of orders selected for signature.
  BAConsultDxList: TStringList; //  contains dx^code^DxRequired(consults Only) selected for consults.
  BAConsultPLFlags: TStringList;  // orderid^flags contains TF's if dx is selected from Problem list and Problem had TF associated.
  BAFWarningShown: boolean;       // flag used to determine if Inactive ICD Code has been shown.
  BAPersonalDX:  boolean;
  BADeltedOrders: TStringList;

implementation

uses
  fBALocalDiagnoses,
  fOrdersSign,
  fReview,
  uCore,
  rCore,
  rPCE,
  uPCE,
  UBAConst,
  UBAMessages,
  UBACore,
  VAUtils;

procedure RemoveOrderFromDxList(thisOrderID: string);
{
  This routine written for CQ4589.  Called from fOrdersDC.ExecuteDCOrders().
}
var
  i: integer;
begin
  if tempDxList.Count > 0 then
    for i := 0 to tempDxList.Count - 1 do
      if tempDxNodeExists(thisOrderID) then
        if ((TBADxRecord(tempDxList[i]).FOrderID = thisOrderID) and
          (tempDxList[i] <> nil)) then
        begin
          // tempDxList.Items[i] := nil; //remove reference to this item, effectively deleting it from the list (see Delphi help)
          BACopiedOrderFlags.Clear;
          UBAGlobals.sourceOrderID := '';
          UBAGlobals.targetOrderID := '';
          tempDxList.Delete(i); // remove this item from the CIDC Dx list
        end;
end;

procedure ResetOrderID(fromID: string; toID: string);
var
  i: integer;
begin
   for i := 0 to tempDxList.Count-1 do
   begin
     if TBADxRecord(tempDxList[i]).FOrderID = fromID then
        TBADxRecord(tempDxList[i]).FOrderID := toID;
     end;
end;

function GetTFCIForOrder(thisIndex: integer) : string;
{
 Retrieve BA flags for 'thisOrderID', and convert them to CPRS type uSignItems.StsChar array.
}
begin
  Result := BACopiedOrderFlags[thisIndex];
end;

procedure CopyTFCIToTargetOrder(thisTargetOrderID: string; thisCheckBoxStatus: string);
var
  i: integer;
begin
  for i := 0 to tempDxList.Count - 1 do
     if TBADxRecord(tempDxList[i]).FOrderID = thisTargetOrderID then
        TBADxRecord(tempDxList[i]).FTreatmentFactors := thisCheckBoxStatus;
end;

procedure BACopyOrder(sourceOrderList: TStringList);
begin
  {
    Removed, no longer used
  }
end;

procedure CopyTreatmentFactorsDxsToCopiedOrder(pSourceOrderID:string; pTargetOrderID:string);
{
 BAPHII 1.3.2
}
var
   sourceOrderList: TStringList;
   sourceOrderID: TStringList;
   targetOrderIDLst: TStringList;
begin
     //Retrieve TF's/CI's from SOURCE Order
        sourceOrderList := TStringList.Create;
        targetOrderIDLst := TStringList.Create;
        sourceOrderList.Clear;
        targetOrderIDLst.Clear;
        sourceOrderID := TStringList.Create;
        sourceOrderID.Clear;
        sourceOrderID.Add(Piece(pSourceOrderID, ';', 1));
        targetOrderIDLst.Add(pTargetOrderID);
     { if targetORderID is not billable do not create entry in BADXRecord - List  fix HDS00003130}
        rpcNonBillableOrders(targetOrderIDLst);
        if IsOrderBillable(pTargetOrderID) then
        begin
           CallVistA('ORWDBA4 GETTFCI', [sourceOrderID],sourceOrderList);
           BACopyOrder(sourceOrderList);
        end;
end;

procedure CopyTreatmentFactorsDxsToRenewedOrder;
{
  BAPHII 1.3.2
}
var
  sourceOrderList: TStringList;
  sourceOrderID: TStringList;
  targetOrderList: TStringList;
begin
  // Retrieve TF's/CI's from SOURCE Order
  sourceOrderList := TStringList.Create;
  sourceOrderList.Clear;
  sourceOrderID := TStringList.Create;
  sourceOrderID.Clear;
  targetOrderList := TStringList.Create;
  targetOrderList.Clear;
  sourceOrderID.Add(Piece(UBAGlobals.sourceOrderID, ';', 1));
  { if targetORderID is not billable do not create entry in BADXRecord - List fix HDS00003130 }
  rpcNonBillableOrders(targetOrderList);
  if IsOrderBillable(UBAGlobals.targetOrderID) then
  begin
    CallVistA('ORWDBA4 GETTFCI', [sourceOrderID], sourceOrderList);
    BACopyOrder(sourceOrderList); // BAPHII 1.3.2
  end;
end;

procedure PutBADxListForOrder(var thisRecord: TBADxRecord; thisOrderID: string);
{                              //existingRecord        //targetOrderID  }
var
  i: integer;
  thisRec: TBADxRecord;
begin
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
                   thisRec.FBADxCode := thisRecord.FBADxCode;
                   thisRec.FBASecDx1 := thisRecord.FBASecDx1;
                   thisRec.FBASecDx2 := thisRecord.FBASecDx2;
                   thisRec.FBASecDx3 := thisRecord.FBASecDx3;
                   thisRec.FTreatmentFactors := thisRecord.FTreatmentFactors;
                end;
           end;

     except
        on EListError do
           begin
           ShowMsg('EListError in UBAGlobals.PutBADxListForOrder()');
           raise;
           end;
     end;
     end;
end;

procedure CopyDxRecord(sourceOrderID: string; targetOrderID: string);
 {
     BAPHII 1.3.1
     Copy contents of one TBADxRecord to another.
     If target record does NOT exist, then add it to the Dx list.
     If target record DOES exist, then change its contents to those of source record.
 }
   var
  thisRecord: TBADxRecord;
  thatRecord: TBADxRecord;
  billingInfo: TstringList;
  orderList:  TStringList;
begin
   thisRecord := TBADxRecord.Create;
   thatRecord := TBADxRecord.Create;
   billingInfo := TStringList.Create;
   orderList   := TStringList.Create;
   if Assigned(billingInfo) then billingInfo.Clear;
   if Assigned(orderList) then orderList.Clear;

   if tempDxNodeExists(sourceOrderID) then
     GetBADxListForOrder(thisRecord, sourceOrderID); //load data from source

    if not tempDxNodeExists(targetOrderID) then
    begin
       SimpleAddTempDxList(targetOrderID);
       orderList.Add(sourceOrderID);
       billingInfo := rpcRetrieveSelectedOrderInfo(orderList);
       if billingInfo.Count > 0 then
       begin
           thisRecord.FBADxCode := Piece(billingInfo.Strings[0],U,4) + U +
                                   Piece(billingInfo.Strings[0],U,3);
           thisRecord.FBASecDx1 := Piece(billingInfo.Strings[0],U,6) + U +
                                   Piece(billingInfo.Strings[0],U,5);
           thisRecord.FBASecDx2 := Piece(billingInfo.Strings[0],U,8) + U +
                                   Piece(billingInfo.Strings[0],U,7);
           thisRecord.FBASecDx3 := Piece(billingInfo.Strings[0],U,10) + U +
                                   Piece(billingInfo.Strings[0],U,9);
           if thisRecord.FBADxCode = CARET then thisRecord.FBADxCode := DXREC_INIT_FIELD_VAL;
           if thisRecord.FBASecDx1 = CARET then thisRecord.FBASecDx1 := DXREC_INIT_FIELD_VAL ;
           if thisRecord.FBASecDx2 = CARET then thisRecord.FBASecDx2 := DXREC_INIT_FIELD_VAL ;
           if thisRecord.FBASecDx3 = CARET then thisRecord.FBASecDx3 := DXREC_INIT_FIELD_VAL ;

       end
       else
           PutBADxListForOrder(thisRecord, targetOrderID);
      //copy source data to temporary record
       with thatRecord do
         begin
            FOrderID :=  targetOrderID;
            FBADxCode := thisRecord.FBADxCode;
            FBASecDx1 := thisRecord.FBASecDx1;
            FBASecDx2 := thisRecord.FBASecDx2;
            FBASecDx3 := thisRecord.FBASecDx3;
            PutBADxListForOrder(thatRecord, targetOrderID);
         end;
    end;
end;


function GetPrimaryDx(thisOrderID: string) : string;
{
BAPHII 1.3.1
}
var
  retVal: TBADxRecord;
begin
  retVal := TBADxRecord.Create;
  GetBADxListForOrder(retVal, thisOrderID);
  Result := retVal.FBADxCode;
end;

function AllSelectedDxBlank(const Caller: smallint) : boolean;
{
var
  i: smallint;
  selectedOrderID: string;
}
begin
  Result := true;

  case Caller of
     F_ORDERS_SIGN: begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                       except
                           on EListError do
                             begin
                              ShowMsg('EListError in UBAGlobals.AllSelectedDxBlank() - F_ORDERS_SIGN');
                              raise;
                             end;
                       end;
                    end;
     F_REVIEW:      begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                       except
                           on EListError do
                             begin
                              ShowMsg('EListError in UBAGlobals.AllSelectedDxBlank() - F_REVIEW');
                              raise;
                             end;
                       end;
                    end;
  end; //case
end;

function GetDxNodeIndex(thisOrderID: string) : smallint;
var
  i: integer;
  thisRec: TBADxRecord;
begin
  Result := 0;

   if Assigned(tempDxList) then

   try
        for i := 0 to (tempDxList.Count - 1) do
           begin
            thisRec := TBADxRecord(tempDxList.Items[i]);
            if Assigned(thisRec) then
              if (thisRec.FOrderID = thisOrderID) then
                 Result := i;
            end;
  except
      on EListError do
        begin
         ShowMsg('EListError in UBAGlobals.GetDxNodeIndex()');
         raise;
        end;
  end;
end;

function DiagnosesMatch(var List1: TStringList; var List2: TStringList) : boolean;
var
  i: smallint;
begin
  Result := false;

  // If the number of Dx's in the lists differs, then bail
  if (List1.Count <> List2.Count) then
     begin
     Result := false;
     Exit;
     end;

  List1.Sort;
  List2.Sort;

  try
     for i := 0 to (List1.Count - 1) do
        if (List1.Strings[i] <> List2.Strings[i]) then
           Result := false
        else
           Result := true;
  except
      on EListError do
        begin
         ShowMsg('EListError in UBAGlobals.DiagnosesMatch()');
         raise;
        end;
  end;
end;

function CountSelectedOrders(const Caller: smallint) : smallint;
var
  //i: integer;
  selectedOrders: smallint;
begin
  selectedOrders := 0;

  // How many orders selected?
  case Caller of
     F_ORDERS_SIGN: begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                       except
                          on EListError do
                             begin
                             ShowMsg('EListError in UBAGlobals.CountSelectedOrders() - F_ORDERS_SIGN');
                             raise;
                             end;
                       end;
                    end;
     F_REVIEW:      begin
                       try
                          { Removed no longer used with this form }
                       except
                          on EListError do
                             begin
                             ShowMsg('EListError in UBAGlobals.CountSelectedOrders() - F_REVIEW');
                             raise;
                             end;
                       end;
                    end;
  end; //case

  Result := selectedOrders;

end;

function CompareOrderDx(const Caller: smallint) : boolean;
var
  //i: integer;
  firstSelectedID: string;
  //thisOrderID: string;
  firstDxRec: TBADxRecord;
  //compareDxRec: TBADxRecord;
  thisStringList: TStringList;
  thatStringList: TStringList;
begin
  Result := false;
  firstSelectedID := '';
  firstDxRec := nil;
  firstDxRec := TBADxRecord.Create;
  thisStringList := TStringList.Create;
  thisStringList.Clear;
  thatStringList := TStringList.Create;
  thatStringList.Clear;

  case Caller of
     F_ORDERS_SIGN: begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                       except
                          on EListError do
                             begin
                             ShowMsg('EListError in UBAGlobals.CompareOrderDx() - F_ORDERS_SIGN');
                             raise;
                             end;
                       end;
                    end;
     F_REVIEW:      begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                       except
                          on EListError do
                             begin
                             ShowMsg('EListError in UBAGlobals.CompareOrderDx() - F_REVIEW');
                             raise;
                             end;
                       end;
                    end;
  end; //case

  firstDxRec := TBADxRecord.Create;
  InitializeNewDxRec(firstDxRec);
  GetBADxListForOrder(firstDxRec, firstSelectedID);

  // first string to compare
  thisStringList.Add(firstDxRec.FBADxCode);
  thisStringList.Add(firstDxRec.FBASecDx1);
  thisStringList.Add(firstDxRec.FBASecDx2);
  thisStringList.Add(firstDxRec.FBASecDx3);

  case Caller of
     F_ORDERS_SIGN: begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                       except
                          on EListError do
                             begin
                             ShowMsg('EListError in UBAGlobals.CompareOrderDx() - F_ORDERS_SIGN');
                             raise;
                             end;
                       end;
                    end;
     F_REVIEW:      begin
                       try
                          {
                          Removed, no longer used with this form
                          }
                          except
                          on EListError do
                             begin
                             ShowMsg('EListError in UBAGlobals.CompareOrderDx() - F_REVIEW');
                             raise;
                             end;
                          end;
                    end;
  end; //case

  if Assigned(thisStringList) then
     FreeAndNil(thisStringList);

  if Assigned(thatStringList) then
     FreeAndNil(thatStringList);
end;

procedure GetBADxListForOrder(var thisRetVal: TBADxRecord; thisOrderID: string);
var
  i: integer;
  thisRec: TBADxRecord;
begin
   if UBAGlobals.tempDxNodeExists(thisOrderID) then
     begin

     if Assigned(tempDxList) then
     for i := 0 to (tempDxList.Count - 1) do
     begin
        thisRec := TBADxRecord(tempDxList.Items[i]);

                 if Assigned(thisRec) then
                   if (thisRec.FOrderID = thisOrderID) then
                      begin
                      with thisRetVal do
                          begin
                             FOrderID := thisRec.FOrderID;
                             FBADxCode := StringReplace(thisrec.FBADxCode,'^',':',[rfReplaceAll]);
                             FBASecDx1 := StringReplace(thisrec.FBASecDx1,'^',':',[rfReplaceAll]);
                             FBASecDx2 := StringReplace(thisrec.FBASecDx2,'^',':',[rfReplaceAll]);;
                             FBASecDx3 := StringReplace(thisrec.FBASecDx3,'^',':',[rfReplaceAll]);
                          end;
                      end;
                 end;
        end;
end;

procedure DestroyDxList;
var
   i: integer;
begin
  if Assigned(tempDxList) then
     for i := 0 to pred(UBAGlobals.tempDxList.Count) do
        TObject(tempDxList[i]).Free;

     tempDxList := nil;
     FreeAndNil(tempDxList);
end;

procedure SimpleAddTempDxList(thisOrderID: string);
var
   tempDxRec: TBADxRecord;
begin
     frmBALocalDiagnoses.LoadTempRec(tempDxRec, thisOrderID);
     UBAGlobals.tempDxList.Add(TBADxRecord(tempDxRec));
end;

procedure SetBADxList;
var
  i: smallint;
begin
  if not Assigned(UBAGlobals.tempDxList) then
     begin
     UBAGlobals.tempDxList := TList.Create;
     UBAGlobals.tempDxList.Count := 0;
     end
  else
     begin
     //Kill the old Dx list
     for i := 0 to pred(UBAGlobals.tempDxList.Count) do
        TObject(UBAGlobals.tempDxList[i]).Free;

     UBAGlobals.tempDxList := nil;

     //Create new Dx list for newly selected patient
      if not Assigned(UBAGlobals.tempDxList) then
         begin
         UBAGlobals.tempDxList := TList.Create;
         UBAGlobals.tempDxList.Count := 0;
         end;
     end;
end;

procedure SetBADxListForOrder(thisRec: TBADxRecord; thisOrderID: string);
var
  i: integer;
  foundRec: TBADxRecord;
begin
   if UBAGlobals.tempDxNodeExists(thisOrderID) then
     begin
     foundRec := TBADxRecord.Create;

     if Assigned(tempDxList) then
           try
             for i := 0 to (tempDxList.Count - 1) do
                begin
                 foundRec := TBADxRecord(tempDxList.Items[i]);

                 if Assigned(thisRec) then
                   if (thisOrderID = foundRec.FOrderID) then
                      begin
                      with foundRec do
                          begin
                          FOrderID := thisRec.FOrderID;
                          FBADxCode := thisRec.FBADxCode;
                          FBASecDx1 := thisRec.FBASecDx1;
                          FBASecDx2 := thisRec.FBASecDx2;
                          FBASecDx3 := thisRec.FBASecDx3;
                          PutBADxListForOrder(foundRec, thisOrderID);
                      end;
                      Break;
                      end;
                 end;
           except
              on EListError do
                 begin
                 ShowMsg('EListError in UBAGlobals.SetBADxListForOrder()');
                 raise;
                 end;
           end;
     end;
end;

function SecondaryDxFull(thisOrderID: string) : boolean;
var
  i: integer;
  thisRec: TBADxRecord;
begin
  Result := false;

     try
        for i := 0 to tempDxList.Count - 1 do
           begin
           thisRec := TBADxRecord(tempDxList.Items[i]);

           if Assigned(thisRec) then
               if thisRec.FOrderID = thisOrderID then
                  begin
                  if (thisRec.FBADxCode <> UBAConst.DXREC_INIT_FIELD_VAL) then
                     if (thisRec.FBASecDx1 <> UBAConst.DXREC_INIT_FIELD_VAL) then
                        if (thisRec.FBASecDx2 <> UBAConst.DXREC_INIT_FIELD_VAL) then
                           if (thisRec.FBASecDx3 <> UBAConst.DXREC_INIT_FIELD_VAL) then
                              Result := true;
                  end;
           end;
     except
        on EListError do
           begin
           ShowMsg('EListError in UBAGlobals.SecondaryDxFull()');
           raise;
           end;
     end;
end;

procedure AddSecondaryDx(thisOrderID: string; thisDxCode: string);
// Add a Secondary Dx to the first open slot in DxRec, if there IS an open slot
var
  thisRec: TBADxRecord;
  i: integer;
begin

  try
     for i := 0 to tempDxList.Count - 1 do
        begin
        thisRec := TBADxRecord(tempDxList.Items[i]);

        if thisRec.FOrderID = thisOrderID then
           begin
           if (thisRec.FBASecDx1 = UBAConst.DXREC_INIT_FIELD_VAL) then
              thisRec.FBASecDx1 := thisDxCode
           else
              if (thisRec.FBASecDx2 = UBAConst.DXREC_INIT_FIELD_VAL) then
                 thisRec.FBASecDx2 := thisDxCode
           else
              if (thisRec.FBASecDx3 = UBAConst.DXREC_INIT_FIELD_VAL) then
                 thisRec.FBASecDx3 := thisDxCode;
           end
        end;
  except
     on EListError do
        begin
        ShowMsg('EListError in UBAGlobals.AddSecondaryDx()');
        raise;
        end;
  end;
end;

procedure InitializeConsultOrderRec(var thisDxRec: TBAConsultOrderRec);
begin
  with thisDxRec do
  begin
     FBAOrderID   := UBAConst.DXREC_INIT_FIELD_VAL;
     FBADxCode    := UBAConst.DXREC_INIT_FIELD_VAL;
     FBASecDx1    := UBAConst.DXREC_INIT_FIELD_VAL;
     FBASecDx2    := UBAConst.DXREC_INIT_FIELD_VAL;
     FBASecDx3    := UBAConst.DXREC_INIT_FIELD_VAL;
     FBATreatmentFactors:= UBAConst.DXREC_INIT_FIELD_VAL;
  end;
end;


procedure InitializeNewDxRec(var thisDxRec: TBADxRecord);
begin
  with thisDxRec do
     begin
     FExistingRecordID := UBAConst.DXREC_INIT_FIELD_VAL;
     FOrderID := UBAConst.DXREC_INIT_FIELD_VAL;
     FBADxCode := UBAConst.DXREC_INIT_FIELD_VAL;
     FBASecDx1 := UBAConst.DXREC_INIT_FIELD_VAL;
     FBASecDx2 := UBAConst.DXREC_INIT_FIELD_VAL;
     FBASecDx3 := UBAConst.DXREC_INIT_FIELD_VAL;
   end;
end;

procedure InitializeUnsignedOrderRec(var thisUnsignedRec: TBAUnsignedBillingRec);
begin
    with thisUnsignedRec do
    begin
       FBAOrderID    := UNSIGNED_REC_INIT_FIELD_VAL;
       FBASTSFlags   := UNSIGNED_REC_INIT_FIELD_VAL;
       FBADxCode     := UNSIGNED_REC_INIT_FIELD_VAL;
       FBASecDx1     := UNSIGNED_REC_INIT_FIELD_VAL;
       FBASecDx2     := UNSIGNED_REC_INIT_FIELD_VAL;
       FBASecDx3     := UNSIGNED_REC_INIT_FIELD_VAL;
  end;
end;

procedure InitializeTFactorsInRec(var thisTFactorsRecIn: TBATreatmentFactorsInRec);
begin
    with thisTFactorsRecIn do
    begin
       FBAOrderID     :=  UNSIGNED_REC_INIT_FIELD_VAL;
       FBAEligible    :=  UNSIGNED_REC_INIT_FIELD_VAL;
       FBATFactors    :=  UNSIGNED_REC_INIT_FIELD_VAL;
    end;
end;
constructor TBAGlobals.Create;
begin
  inherited Create;
end;
// This procedure is called from uPCE.pas only --  do not delete.....
procedure TBAGlobals.AddBAPCEDiag(DiagStr:string);
begin
  if (BAPCEDiagList.Count <= 0) then
    BAPCEDiagList.Add('^Encounter Diagnoses');

  BAPCEDiagList.Add(DiagStr);
end;

procedure TBAGlobals.ClearBAPCEDiagList;
begin

   BAPCEDiagList.Clear;
end;

constructor TBAPLRec.Create;
begin
  inherited Create;
end;

function TBAPLRec.BuildProblemListDxEntry(pDxCode:string): TStringList;
// StringList used to store DX Codes selected from Encounter Form
var
  BADxIEN: string;
  BAProviderStr, BAProviderName : string;
  AList: TStringList;
begin
// Build Problem List record to be saved for selection.
  PLlist     := TStringList.Create;
  AList      := TStringList.Create;
  AList.Clear;
  PLlist.Clear;
  BALocation := Encounter.Location;
  BAProviderStr := IntToStr(Encounter.Provider);
  BAProviderName := Encounter.ProviderName;
  CallVistA('ORWDBA7 GETIEN9', [Piece(pDxCode,U,1)],BADxIEN);
  BAPLPt.LoadPatientParams(AList);

  //BAPLPt.PtVAMC
  PLlist.Add('GMPFLD(.01)='+'"' +BADxIEN+ '^'+Piece(pDxCode,U,1)+'"');
  PLlist.Add('GMPFLD(.03)=' +'"'+'0^' +'"');
  PLlist.Add('GMPFLD(.05)=' + '"' +'^'+Piece(pDxCode,U,2)+ '"');
  PLlist.Add('GMPFLD(.08)=' + '"'+ '^'+FloatToStr(FMToday)+'"');
  PLlist.Add('GMPFLD(.12)=' + '"' + 'A^ACTIVE'+ '"');
  PLlist.Add('GMPFLD(.13)=' + '"' + '^'+ '"');
  PLlist.Add('GMPFLD(1.01)=' + '"'+ Piece(pDxCode,U,2) + '"');
  PLlist.Add('GMPFLD(1.02)=' + '"'+'P' + '"');
  PLlist.Add('GMPFLD(1.03)=' + '"'+ BAProviderStr + '^'+ BAProviderName + '"');
  PLlist.Add('GMPFLD(1.04)=' + '"'+ BAProviderStr + '^' + BAProviderName + '"');
  PLlist.Add('GMPFLD(1.05)=' + '"'+ BAProviderStr + '^' + BAProviderName + '"');
  PLlist.Add('GMPFLD(1.08)=' +'"' + IntToStr(BALocation) + '^' + Encounter.LocationName + '"');
  PLlist.Add('GMPFLD(1.09)=' + '"'+ FloatToStr(FMToday) +'"');
  PLlist.Add('GMPFLD(10,0)=' + '"'+'0'+ '"');
  Result := PLlist;

end;

function TBAPLRec.FMToDateTime(FMDateTime: string): TDateTime;
var
  x, Year: string;
begin
  { Note: TDateTime cannot store month only or year only dates }
  x := FMDateTime + '0000000';
  if Length(x) > 12 then
    x := Copy(x, 1, 12);
  if StrToInt(Copy(x, 9, 4)) > 2359 then
    x := Copy(x, 1, 7) + '.2359';
  Year := IntToStr(17 + StrToInt(Copy(x,1,1))) + Copy(x,2,2);
  x := Copy(x,4,2) + '/' + Copy(x,6,2) + '/' + Year + ' ' + Copy(x,9,2) + ':' + Copy(x,11,2);
  Result := StrToDateTime(x);
end;

{-------------------------- TPLPt Class ----------------------}
constructor TBAPLPT.Create(Alist:TStringList);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    case i of
      0:
        PtVAMC := Copy(Alist[i], 1, 999);
      1:
        PtDead := Alist[i];
      2:
        PtServiceConnected := (Alist[i] = '1');
      3:
        PtAgentOrange := (Alist[i] = '1');
      4:
        PtRadiation := (Alist[i] = '1');
      5:
        PtEnvironmental := (Alist[i] = '1');
      6:
        PtBid := Alist[i];
      7:
        PtHNC := (Alist[i] = '1');
      8:
        PtMST := (Alist[i] = '1');
      9:
        PtSHAD := (Alist[i] = '1');
      10:
        PtCL := (Alist[i] = '1');
    end;
end;

function TBAPLPt.GetGMPDFN(dfn:string;name:string):string;
begin
  Result := dfn + u + name + u + PtBID + u + PtDead;
end;
{ RTC 272867
function TBAPLPt.rpcInitPt(const PatientDFN: string): TStrings ;  //*DFN*
begin
   CallV('ORQQPL INIT PT',[PatientDFN]);
   Result := RPCBrokerV.Results;
end ;
}
procedure TBAPLPt.LoadPatientParams(AList:TstringList);
begin
  if CallVistA('ORQQPL INIT PT',[Patient.DFN],aList) then
    BAPLPt := TBAPLPt.create(Alist);
end;

function tempDxNodeExists(thisOrderID: string) : boolean;
// Returns true if a node with the specified Order ID exists, false otherwise.
var
  i: integer;
  thisRec: TBADxRecord;
begin
  Result := false;
  if Assigned(tempDxList) then
     try
        for i := 0 to (tempDxList.Count - 1) do
           begin
            thisRec := TBADxRecord(tempDxList.Items[i]);

            if Assigned(thisRec) then
              if (thisRec.FOrderID = thisOrderID) then
                 begin
                 Result := true;
                 Break;
                 end;
            end;
     except
        on EListError do
           begin
           ShowMsg('EListError in UBAGlobals.tempDxNodeExists()');
           raise;
           end;
     end;
end;
 // HDS00003380
function IsUserNurseProvider(pUserID: int64):boolean;
begin
   Result := False;
   if BILLING_AWARE then
   begin
      if (pUserID <> 0) and PersonHasKey(pUserID, 'PROVIDER') then
         if (uCore.User.OrderRole = OR_NURSE)  then
            Result := True;
   end;
end;

function GetPatientTFactors(pOrderList:TStringList):String;
begin
   if not CallVistA('ORWDBA1 SCLST',[Patient.DFN,pOrderList], Result) then
     Result := '';
end;


Initialization
  BAPrimaryDxChanged := False;
  BAFWarningShown    := False;
  BAPersonalDX       := False;
  BAHoldPrimaryDx      :=  DXREC_INIT_FIELD_VAL;
  NonBillableOrderList := TStringList.Create;
  BAPCEDiagList        := TStringList.Create;
  OrderListSCEI        := TStringList.Create;
  BAOrderList          := TStringList.Create;
  UnSignedOrders       := TStringList.Create;
  BAOrderIDList        := TStringList.Create;
  BAUnSignedOrders     := TStringList.Create;
  BATFHints            := TStringList.Create;
  BAFactorsRec         := TBAFactorsRec.Create;
  BAFactorsInRec       := TBATreatmentFactorsInRec.Create;
  BASelectedList       := TStringList.Create;
  PLFactorsIndexes     := TStringList.Create;
  BAtmpOrderList       := TStringList.Create;
  BACopiedOrderFlags   := TStringList.Create; //BAPHII 1.3.2
  OrderIDList          := TStringList.Create;
  BAConsultDxList      := TStringList.Create;
  BAConsultPLFlags     := TStringList.Create;
  BANurseConsultOrders := TStringList.Create;
  BADeltedOrders       := TStringList.Create;
  BAConsultDxList.Clear;
  NonBillableOrderList.Clear;
  OrderListSCEI.Clear;
  UnSignedOrders.Clear;
  BAOrderIDList.Clear;
  BAUnSignedOrders.Clear;
  BATFHints.Clear;
  PLFactorsIndexes.Clear;
  BASelectedList.Clear;
  BAtmpOrderList.Clear;
  OrderIDList.Clear;
  BAConsultPLFlags.Clear;
  BAPCEDiagList.Clear;
  BANurseConsultOrders.Clear;
  BADeltedOrders.Clear;

finalization
  FreeAndNil(NonBillableOrderList);
  FreeAndNil(BAPCEDiagList);
  FreeAndNil(OrderListSCEI);
  FreeAndNil(BAOrderList);
  FreeAndNil(UnSignedOrders);
  FreeAndNil(BAOrderIDList);
  FreeAndNil(BAUnSignedOrders);
  FreeAndNil(BATFHints);
  FreeAndNil(BAFactorsRec);
  FreeAndNil(BAFactorsInRec);
  FreeAndNil(BASelectedList);
  FreeAndNil(PLFactorsIndexes);
  FreeAndNil(BAtmpOrderList);
  FreeAndNil(BACopiedOrderFlags);
  FreeAndNil(OrderIDList);
  FreeAndNil(BAConsultDxList);
  FreeAndNil(BAConsultPLFlags);
  FreeAndNil(BANurseConsultOrders);
  FreeAndNil(BADeltedOrders);
  if assigned(tempDxList) then
    KillObj(@tempDxList, True);

end.
