unit uSignItems;

{.$define debug}

interface

uses
  SysUtils, Windows, Classes, Graphics, Controls, StdCtrls, CheckLst, ORClasses, ORCtrls,
  Dialogs, UBAConst, fODBase, UBACore, Forms;

type
  TSigItemType = (siServiceConnected, siAgentOrange, siIonizingRadiation,
                  siEnvironmentalContaminants, siMST, siHeadNeckCancer, siCombatVeteran, siSHAD, siCL);

  TSigItemTagInfo =  record
    SigType: TSigItemType;
    Index: integer;
  end;

  TlbOnDrawEvent = record
    xcontrol: TWinControl;
    xevent: TDrawItemEvent;
  end;

  TSigItems = class(TComponent)
  private
    FBuilding: boolean;
    FStsCount: integer;
    FItems: TORStringList;
    FOldDrawItemEvent: TDrawItemEvent;
    FOldDrawItemEvents: array of TlbOnDrawEvent;
    Fcb: TList;
    Flb: TCustomListBox;
    FLastValidX: integer;
    FValidGap: integer;
    FDy: integer;
    FAllCheck: array[TSigItemType] of boolean;
    FAllCatCheck: boolean;
    FcbX: array[TSigItemType] of integer;
    function TagInfo(ASigType: TSigItemType; AIndex: integer): TSigItemTagInfo;
    procedure cbClicked(Sender: TObject);
    procedure cbEnter(Sender: TObject);
    procedure cbExit(Sender: TObject);
    procedure lbDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure CopyCBValues(FromIndex, ToIndex: integer);
    function  FindCBValues(ATag: integer): TORCheckBox;
    function  GetTempCkBxState(Index: integer; CBValue:TSigItemType): string;

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public                          
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(ItemType: Integer; const ID: string; Index: integer);
    procedure Remove(ItemType: integer; const ID: string);
    procedure ResetOrders;
    procedure Clear;
    procedure ClearDrawItems;
    procedure ClearFcb;
    function  UpdateListBox(lb: TCustomListBox): boolean;
    procedure EnableSettings(Index: integer; Checked: boolean);
    function  OK2SaveSettings: boolean;
    procedure SaveSettings;
    procedure DisplayPlTreatmentFactors;
    procedure DisplayUnsignedStsFlags(sFlags:string);
    function GetSigItems : TORStringList; //BAPHII 1.3.1
    function FindCB(ATag: integer): TORCheckBox; //BAPHII 1.3.1
    procedure CopyCB(FromIndex, ToIndex: integer); //BAPHII 1.3.1
    procedure SetSigItems(Sender: TObject; sourceOrderID: string); //BAPHII 1.3.1
    function ItemToTag(Info: TSigItemTagInfo): integer; //CQ5074
    function TagToItem(ATag: integer): TSigItemTagInfo; //CQ5074

  end;

function SigItems: TSigItems;
function SigItemsCS: TSigItems;
function SigItemHeight: integer;
function  GetAllBtnLeftPos: integer;

const
  SIG_ITEM_VERTICAL_PAD = 2;

  TC_Order_Error = 'All Service Connection and/or Rated Disabilities questions must be answered, '+#13+
                   'and at least one diagnosis selected for each order that requires a diagnosis.';

  TX_Order_Error = 'All Service Connection and/or Rated Disabilities questions must be answered, '+#13+
                   'and at least one diagnosis selected for each order that requires a diagnosis.';

  TC_Diagnosis_Error = ' Missing Diagnosis';
  TX_Diagnosis_Error = ' One or more Orders have not been assigned a Diagnosis';
  INIT_STR = '';


var
  uSigItems: TSigItems = nil; //BAPHII 1.3.1
  uSigItemsCS: TSigItems = nil;


implementation

uses
  ORFn, ORNet, uConst, TRPCB, rOrders, rPCE, fOrdersSign, fReview,UBAGlobals,
  uGlobalVar, uCore, VAUtils, rMisc;

type
  ItemStatus = (isNA, isChecked, isUnchecked, isUnknown);
  SigDescType = (sdShort, sdLong);

const
  SigItemDesc: array[TSigItemType, SigDescType] of string =
        { siServiceConnected          } (('SC',  'Service Connected Condition'),
        { siAgentOrange               }  ('AO',  'Agent Orange Exposure'),
        { siIonizingRadiation         }  ('IR',  'Ionizing Radiation Exposure'),
        { siEnvironmentalContaminants }  ('SWAC','Southwest Asia Conditions'),
        { siMST                       }  ('MST', 'MST'), //'Military Sexual Trauma'
        { siHeadNeckCancer            }  ('HNC', 'Head and/or Neck Cancer'),
        { siCombatVeteran             }  ('CV',  'Combat Veteran Related'),
        { siSHAD                      }  ('SHD', 'Shipboard Hazard and Defense') ,
        { siCL                        }  ('CL', 'Camp Lejeune'));

  SigItemDisplayOrder: array[TSigItemType] of TSigItemType =
     (  siServiceConnected,
        siCombatVeteran,
        siAgentOrange,
        siIonizingRadiation,
        siEnvironmentalContaminants,
        siSHAD,
        siMST,
        siHeadNeckCancer,
        siCL);

  StsChar: array[ItemStatus] of char =
           { isNA        } ('N',
           { isChecked   }  'C',
           { isUnchecked }  'U',
           { isUnknown   }  '?');

  ColIdx = 30000;
  AllIdx = 31000;
  NA_FLAGS = 'NNNNNNNN';
  NA_FLAGS_CL = 'NNNNNNNNN';
var
  uSingletonFlag: boolean = FALSE;
  FlagCount: integer;
  BaseFlags: string;
  tempCkBx: TORCheckBox;
  thisOrderID: string;
  thisChangeItem: TChangeItem;
  AllBtnLeft: integer;

function TSigItems.GetSigItems : TORStringList;
begin
  Result := FItems;
end;

function TSigItems.FindCB(ATag: integer): TORCheckBox;
var
  i: integer;
  wc: TWinControl;
begin
  for i := 0 to Fcb.Count-1 do
  begin
    wc := TWinControl(Fcb[i]);
    if(wc is TORCheckBox) and (wc.Tag = ATag) then
    begin
      Result := TORCheckBox(wc);
      exit;
    end;
  end;
  Result := nil;
end;

procedure TSigItems.CopyCB(FromIndex, ToIndex: integer);
var
  si: TSigItemType;
  FromTag, ToTag: integer;
  FromCB, ToCB: TORCheckBox;

begin
  for si := low(TSigItemType) to high(TSigItemType) do
  begin
    FromTag := ItemToTag(TagInfo(si, FromIndex));
    ToTag := ItemToTag(TagInfo(si, ToIndex));
    FromCB := FindCB(FromTag);
    ToCB := FindCB(ToTag);
    if(Assigned(FromCB) and Assigned(ToCB)) then
      ToCB.State := FromCB.State;
  end;
end;

procedure TSigItems.SetSigItems(Sender: TObject; sourceOrderID: string);
var
  i: integer;
begin
  if (Sender as TCaptionCheckListBox).Name = 'clstOrders' then
    for i := 0 to frmSignOrders.clstOrders.Count - 1 do
       begin
       if ((fOrdersSign.frmSignOrders.clstOrders.Selected[i]) and (fOrdersSign.targetOrderID <> fOrdersSign.srcOrderID)) then
          CopyCB(fOrdersSign.srcIndex, i);
       end
  else
    if (Sender as TCaptionCheckListBox).Name = 'lstReview' then
      for i := 1 to  frmReview.lstReview.Count -1 do
         begin
           if ((fReview.frmReview.lstReview.Selected[i]) and (fReview.targetOrderID <> fReview.srcOrderID)) then
              CopyCB(fReview.srcIndex, i);
         end;
end;

function SigItems: TSigItems;
begin
  if not assigned(uSigItems) then
  begin
    uSingletonFlag := TRUE;
    try
      uSigItems := TSigItems.Create(nil);
    finally
      uSingletonFlag := FALSE;
    end;
  end;
  Result := uSigItems;
end;

function SigItemsCS: TSigItems;
begin
  if not assigned(uSigItemsCS) then
  begin
    uSingletonFlag := TRUE;
    try
      uSigItemsCS := TSigItems.Create(nil);
    finally
      uSingletonFlag := FALSE;
    end;
  end;
  Result := uSigItemsCS;
end;

function SigItemHeight: integer;
begin
  Result := abs(BaseFont.height) + 2 + SIG_ITEM_VERTICAL_PAD;
end;

function  GetAllBtnLeftPos: integer;
 begin
  Result := uSignItems.AllBtnLeft;
 end;


{ TSigItems }
{
FItems Layout:
1         2               3                            4                      5
OrderID ^ ListBox Index ^ RPC Call was Made (0 or 1) ^ Settings by char pos ^ Disabled Flag
}

procedure TSigItems.Add(ItemType: Integer; const ID: string; Index: integer);
var
  idx: integer;
begin
  if ItemType = CH_ORD then
  begin
    idx := FItems.IndexOfPiece(ID);
    if idx < 0 then
      idx := FItems.Add(ID);
    FItems.SetStrPiece(idx, 2, IntToStr(Index));
    FItems.SetStrPiece(idx,5,INIT_STR);    // hds4807 value was being reatained when same order selected in FReview.

  end;
end;

procedure TSigItems.Clear;
begin
  FItems.Clear;
  Fcb.Clear;
  Finalize(FOldDrawItemEvents);
end;

procedure TSigItems.ClearDrawItems;
begin
  Finalize(FOldDrawItemEvents);
end;

procedure TSigItems.ClearFcb;
begin
  Fcb.Clear;
end;

constructor TSigItems.Create(AOwner: TComponent);
begin
  if not uSingletonFlag then
    raise Exception.Create('Only one instance of TSigItems allowed');
  inherited Create(AOwner);
  FItems := TORStringList.Create;
  Fcb := TList.Create;
  tempCkBx := TORCheckBox.Create(Owner);
end;

destructor TSigItems.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(Fcb);
  inherited;
end;

procedure TSigItems.Remove(ItemType: integer; const ID: string);
var
  idx: integer;
begin
  if ItemType = CH_ORD then
  begin
    idx := FItems.IndexOfPiece(ID);
    if idx >= 0 then
      FItems.Delete(idx);
  end;
end;

procedure TSigItems.ResetOrders; // Resets ListBox positions, to avoid old data messing things up
var
  i: integer;
begin
  for i := 0 to FItems.Count-1 do
    FItems.SetStrPiece(i, 2, '-1');
end;

function TSigItems.ItemToTag(Info: TSigItemTagInfo): integer;
begin
  if Info.Index < 0 then
    Result := 0
  else
    Result := (Info.Index*FlagCount) + ord(Info.SigType) + 1;
end;


function TSigItems.TagInfo(ASigType: TSigItemType; AIndex: integer): TSigItemTagInfo;
begin
  Result.SigType := ASigType;
  Result.Index := AIndex;
end;

function TSigItems.TagToItem(ATag: integer): TSigItemTagInfo;
begin
  if ATag <= 0 then
  begin
    Result.Index := -1;
    Result.SigType := TSigItemType(0);
  end
  else
  begin
    dec(ATag);
    Result.SigType := TSigItemType(ATag mod FlagCount);
    Result.Index := ATag div FlagCount;
  end;
end;

type
  TExposedListBox = class(TCustomListBox)
  public
    property OnDrawItem;
  end;

function TSigItems.UpdateListBox(lb: TCustomListBox): boolean;
const
  cbWidth = 13;
  cbHeight = 13;
  btnGap = 2;
  AllTxt = 'All';

var
  cb: TORCheckBox;
  btn: TButton;
  lbl: TLabel;
  prnt: TWinControl;
  ownr: TComponent;
  FirstValidItem: TSigItemType;
  x, y, MaxX, i, btnW, btnH, j, dx, ht, idx, dgrp: integer;
  s, id, Code, cType, Flags,OrderStatus,CVFlag,ChangedFlags: string;
  odie: TlbOnDrawEvent;
  StsCode: char;
  sx, si: TSigItemType;
  sts, StsIdx: ItemStatus;
  StsUsed: array[TSigItemType] of boolean;
  AResponses : TResponses;
  UFlags,HoldFlags: string;
  thisCB: TORCheckBox;
  cpFlags: string;
  

  itemText: string;
  thisTagInfo: TSigItemTagInfo;

  function CreateCB(AParent: TWinControl): TORCheckBox;
  begin
     Result := TORCheckBox.Create(ownr);
     Result.Parent := AParent;
     Result.Height := cbHeight;
     Result.Width := cbWidth;
     Result.GrayedStyle := gsBlueQuestionMark;
     Result.GrayedToChecked := FALSE;
     Result.OnClick := cbClicked;
     Result.OnEnter := cbEnter;
     Result.OnExit := cbExit;
     UpdateColorsFor508Compliance(Result);
     Fcb.Add(Result);
  end;

  function notRightOne(cnter: Integer): Boolean;
  var
    id,idx: string;
    ix: Integer;
  begin
    Result := TRUE;
    id := piece(FItems[cnter],'^',1);
    for ix := 0 to lb.Items.Count - 1 do
      begin
        if lb.Items.Objects[ix] is TOrder then
        begin
          idx := TOrder(lb.Items.Objects[ix]).ID;
          if id = idx then Result := FALSE;
        end;
        if lb.Items.Objects[ix] is TChangeItem then
        begin
          idx := TChangeItem(lb.Items.Objects[ix]).ID;
          if id = idx then Result := FALSE;
          
        end;
      end;
  end;

begin
  Result := FALSE;
//  Fcb.Clear;
  FBuilding := TRUE;
try

  try
    idx := 0;
    RPCBrokerV.ClearParameters := True;

    for i := 0 to FItems.Count-1 do
    begin
       if notRightOne(i) then continue;
       
       s := FItems[i];
       thisOrderID := Piece(s,U,1);
       if BILLING_AWARE then
         if NOT UBACore.IsOrderBillable(thisOrderID) then
             RemoveOrderFromDxList(thisOrderID);
       if (piece(s, U, 2) <> '-1') and (piece(s, U, 3) <> '1') then
       begin
          with RPCBrokerV do
              begin
              if idx = 0 then
                Param[1].PType := list;
              inc(idx);
              Param[1].Mult[IntToStr(idx)] := piece(s, U, 1);
              end;
          end;
       end; //for

       if idx > 0 then
          begin
            rpcGetSC4Orders;
            for i := 0 to RPCBrokerV.Results.Count-1 do
               begin
                  s := RPCBrokerV.Results[i];
                {Begin BillingAware}
                if  BILLING_AWARE then
                begin
                  if (CharAt(piece(s,';',2),1) <> '1') then
                    s := piece(s,U,1);
                end;  {End BillingAware }
                id := piece(s,U,1);
                idx := FItems.IndexOfPiece(id);

                if idx >= 0 then
                begin
                    FItems.SetStrPiece(idx, 3, '1'); // Mark as read from RPC
                    j := 2;
                    Flags := BaseFlags;
                     repeat
                         Code := piece(s,U,j);
                         if Code = 'EC' then Code := 'SWAC';  // CQ:15431  ; resolve issue of displaying SWAC vs EC.
                         if Code <> '' then
                            begin
                            cType := piece(Code, ';', 1);

                            for si := low(TSigItemType) to high(TSigItemType) do
                               begin
                                 if cType = SigItemDesc[si, sdShort] then
                                    begin
                                    cType := piece(Code, ';', 2);

                                    if cType = '0' then
                                      sts := isUnchecked
                                    else
                                       if cType = '1' then
                                         sts := isChecked
                                       else
                                         sts := isUnknown;

                                    Flags[ord(si)+1] := StsChar[sts];
                                    break;

                                    end; //if cType = SigItemDesc[si, sdShort]
                                 end; //for
                            end; //if Code <> ''

                           inc(j);
                       until(Code = '');

                     FItems.SetStrPiece(idx, 4, Flags);
                      // new code  if deleted order and ba on then
                      // reset appropriate tf flags to "?".

                     if BILLING_AWARE then
                        begin
                           if not UBACore.OrderRequiresSCEI(Piece(s,U,1)) then
                           begin
                            if IsLejeuneActive then
                             FItems.SetStrPiece(idx,4, NA_FLAGS_CL)
                            else
                             FItems.SetStrPiece(idx,4, NA_FLAGS);
                           end else
                              begin

                              if UBAGlobals.BAUnsignedOrders.Count > 0 then
                                 begin
                                 UFlags := UBACore.GetUnsignedOrderFlags(Piece(s,U,1),UBAGlobals.BAUnsignedOrders);
                                 if UFlags <> '' then FItems.SetStrPiece(idx,4, UFlags)
                                 end;
                              //********************************
                              if UBAGlobals.BACopiedOrderFlags.Count > 0 then  //BAPHII 1.3.2
                                 begin
                                 UFlags := UBACore.GetUnsignedOrderFlags(Piece(s,U,1),UBAGlobals.BACopiedOrderFlags); //BAPHII 1.3.2
                                 if UFlags <> '' then //BAPHII 1.3.2
                                    FItems.SetStrPiece(idx,4,UFlags); //BAPHII 1.3.2
                                 end;
                              //********************************
                              if UBAGlobals.BAConsultPLFlags.Count > 0 then
                                 begin
                                    UFlags :=  GetConsultFlags(Piece(s,U,1),UBAGlobals.BAConsultPLFlags,Flags);

                                 if UFlags <> '' then
                                    FItems.SetStrPiece(idx,4, UFlags);
                                 end;

                                 UBAGlobals.BAFlagsIN := Flags;
                              end; //else
                           end; //if BILLING_AWARE

                       end; //if idx >= 0

                  end; //for i := 0 to RPCBrokerV.Results.Count-1
             end; //if idx > 0

    FStsCount := 0;
    AllBtnLeft := 0;

    for si := low(TSigItemType) to high(TSigItemType) do
      StsUsed[si] := FALSE;
    //  loop thru orders selected to be signed fReview/fOrdersSign.
    for i := 0 to FItems.Count-1 do
       begin                     
         if notRightOne(i) then continue;
         s := FItems[i];

         if (piece(s,u,2) <> '-1') and (piece(s,u,3) = '1') then
            begin
             s := piece(s, u, 4); // SC/EI
            // code added 01/17/2006 - check dc'd nurse orders,
            // originals where requiring CIDC if assigned to patient.
             if (BILLING_AWARE) and (not UBACore.IsOrderBillable(Piece(s,U,1))) then
              if IsLejeuneActive then
               s :=  NA_FLAGS_CL
              else
               s :=  NA_FLAGS;

            for si := low(TSigItemType) to high(TSigItemType) do
              if (not StsUsed[si]) and (s[ord(si)+1] <> StsChar[isNA]) then
              begin
                StsUsed[si] := TRUE;
                inc(FStsCount);
                if FStsCount >= FlagCount then break;
              end;
            end;

         if FStsCount >= FlagCount then
           Break;
       end; //for

   {Begin BillingAware}
     if  BILLING_AWARE then
         begin
            if FStsCount = 0 then //  Billing Awareness.  Force Grid to paint correctly
               FStsCount := 1;
         end;
   {End BillingAware}

    if FStsCount > 0 then
       begin
         Result := TRUE;
         FirstValidItem := TSigItemType(0);

         prnt := lb.Parent;
         ownr := lb.Owner;
         MaxX := lb.ClientWidth;
         lb.Canvas.Font := BaseFont;
         btnW := 0;

         for si := low(TSigItemType) to high(TSigItemType) do
         begin
            j := lb.Canvas.TextWidth(SigItemDesc[si, sdShort]);
            if btnW < j then
             btnW := j;
         end;

         inc(btnW, 8);
         btnH := ResizeHeight( BaseFont, BaseFont, 21);
         x := MaxX;
         dx := (btnW - cbWidth) div 2;

         for si := high(TSigItemType) downto low(TSigItemType) do
         begin
            FcbX[si] := x - btnW + dx;
            dec(x, btnW + btnGap);
         end;
         
         if FStsCount > 1 then
         begin
           FAllCatCheck := FALSE;
           btn := TButton.Create(ownr);
           btn.Parent := prnt;
           btn.Height := btnH;
           btn.Width := btnW;
           btn.Caption := AllTxt;
           btn.OnClick := cbClicked;
           btn.Left := FcbX[TSigItemType(0)] + lb.Left - dx + 2 - (FcbX[TSigItemType(1)] - FcbX[TSigItemType(0)]);
           AllBtnLeft := btn.left;
           btn.Top := lb.Top - btn.height - 2;
           btn.Tag := AllIdx;
           btn.ShowHint := TRUE;
           btn.Hint := 'Set All Related Entries';
           btn.TabOrder := lb.TabOrder;
           UpdateColorsFor508Compliance(btn);
           Fcb.Add(btn);
         end;

         for sx := low(TSigItemType) to high(TSigItemType) do
         begin                                                // print buttons on header of columns ie SC,AO,IR, etc....
            si := SigItemDisplayOrder[sx];
            if (si = siCL) and (not IsLejeuneActive) then
              Continue;
            FAllCheck[si] := TRUE;
            btn := TButton.Create(ownr);
            btn.Parent := prnt;
            btn.Height := btnH;
            btn.Width := btnW;
            btn.Caption := SigItemDesc[si, sdShort];
            btn.OnClick := cbClicked;
            btn.Left := FcbX[sx] + lb.Left - dx + 2;
            btn.Top := lb.Top - btn.height - 2;
            btn.Tag := ColIdx + ord(si);
            btn.ShowHint := TRUE;
            btn.Hint := 'Set all ' + SigItemDesc[si, sdLong];
            btn.Enabled := StsUsed[si];
            //tab order before listbox but after previous buttons.
            btn.TabOrder := lb.TabOrder;
            UpdateColorsFor508Compliance(btn);
            Fcb.Add(btn);
         end;

            FValidGap := ((FcbX[succ(TSigItemType(0))] - FcbX[TSigItemType(0)] - cbWidth) div 2) + 1;
            FLastValidX := FcbX[FirstValidItem] - FValidGap;
            lb.ControlStyle := lb.ControlStyle + [csAcceptsControls];
            
            try
              ht := SigItemHeight;
              FDy := ((ht - cbHeight) div 2)+1;
              y := lb.TopIndex;
              FOldDrawItemEvent := TExposedListBox(lb).OnDrawItem;
              odie.xcontrol := lb;
              odie.xevent := FOldDrawItemEvent;
              SetLength(FOldDrawItemEvents,Length(FOldDrawItemEvents)+1);
              FOldDrawItemEvents[Length(FOldDrawItemEvents)-1] := odie;
              Flb := lb;
              TExposedListBox(lb).OnDrawItem := lbDrawItem;
              lb.FreeNotification(Self);

              for i := 0 to FItems.Count-1 do
                  begin
                    if notRightOne(i) then continue;
                    s := FItems[i];
                    orderStatus := (Piece(s,u,1));
                  if piece(s,u,3) = '1' then
                     begin
                       idx := StrToIntDef(piece(s,U,2),-1);

                     if idx >= 0 then
                     begin
                        Flags := piece(s,u,4);
                          //loop thru treatment factors
                        for sx := low(TSigItemType) to high(TSigItemType) do
                           begin
                             si := SigItemDisplayOrder[sx];
                             if (si = siCL) and (not IsLejeuneActive) then
                              Continue;
                             StsCode := Flags[ord(si)+1];
                             StsIdx := isNA;

                           for sts := low(ItemStatus) to high(ItemStatus) do
                              if StsCode = StsChar[sts] then
                                 begin
                                   StsIdx := sts;
                                   Break;
                                 end;

                             if (StsIdx <> isNA) then
                               begin
                                 cb := CreateCB(lb);
                                 cb.Left := FcbX[sx];
                                 cb.Top := (ht * (idx - y)) + FDy;
                                 cb.Tag := ItemToTag(TagInfo(si, idx));
                                 cb.ShowHint := TRUE;
                                 cb.Hint := SigItemDesc[si, sdLong];

                                 //CQ3301/3302
                                 thisTagInfo := TagToItem(cb.Tag);
                                 itemText := '';
                                 thisChangeItem := nil; //init

                                 thisChangeItem := TChangeItem(lb.Items.Objects[thisTagInfo.Index]);

                                 if (thisChangeItem <> nil) then
                                     begin
                                        itemText := (FilteredString(lb.Items[thisTagInfo.Index]));
                                        cb.Caption := itemText + cb.Hint;  //CQ3301/3302 - gives JAWS a caption to read
                                     end;
                                 //end CQ3301/3302
                                  if ( (si = siCombatVeteran) and (StsIdx = isUnKnown) ) then
                                  begin
                                     StsIdx := isChecked;
                                     Flags[7] := 'C';                  // HD200866 default as Combat Related - GWOT mandated Change
                                     FItems.SetStrPiece(i, 4, Flags);  // HD200866 default as Combat Related - GWOT mandated Change
                                  end;
                                 case StsIdx of
                                   isChecked:   cb.State := cbChecked;
                                   isUnchecked: cb.State := cbUnchecked;
                                 else cb.State := cbGrayed;
                                 end; //case

                               end; //if (StsIdx <> isNA)

                        end; //for sx := low(TSigItemType) to high(TSigItemType)

                     end; // if idx >= 0

                     end; //if piece(s,u,3) = '1'

              end; //for i := 0 to FItems.Count-1

         finally
           lb.ControlStyle := lb.ControlStyle - [csAcceptsControls];
         end; //if FStsCount > 0
    end;

  finally
    FBuilding := FALSE;
  end;
  except
  on ERangeError do
  begin
     ShowMsg('ERangeError in UpdateListBox' + s);
  raise;
  end;
  end;
end;

procedure TSigItems.cbClicked(Sender: TObject);
var
  i,cnt,p: integer;
  cb: TORCheckBox;
  sType: TSigItemType;
  idx, Flags: string;
  Info: TSigItemTagInfo;
  wc, w: TWinControl;

begin
  if FBuilding then exit;
  wc := TWinControl(Sender);
  if wc.Tag = AllIdx then
  begin
    FAllCatCheck := not FAllCatCheck;
    for sType := low(TSigItemType) to high(TSigItemType) do
      FAllCheck[sType] := FAllCatCheck;
    cnt := 0;
    for i := 0 to Fcb.Count-1 do
    begin
      w := TWinControl(Fcb[i]);
      if (w <> wc) and (w.Tag >= ColIdx) and (w is TButton) then
      begin
        inc(cnt);
        if w.Enabled then
          TButton(w).Click;
        if cnt >= FlagCount then break;
      end;
    end;
  end
  else
  if wc.Tag >= ColIdx then
  begin
    sType := TSigItemType(wc.Tag - ColIdx);
    FAllCheck[sType] := not FAllCheck[sType];
    for i := 0 to Fcb.Count-1 do
    begin
      w := TWinControl(Fcb[i]);
      if (w.Tag < ColIdx) and (w is TORCheckBox) then
      begin
        if TagToItem(w.Tag).SigType = sType then
          TORCheckBox(w).Checked := FAllCheck[sType];
      end;
    end;
  end
  else
  begin
    cb := TORCheckBox(wc);
    info := TagToItem(cb.Tag);
    if info.Index >= 0 then
    begin
      idx := inttostr(info.Index);
      i := FItems.IndexOfPiece(idx,U,2);
      if i >= 0 then
      begin
        p := ord(Info.SigType)+1;
        Flags := piece(FItems[i],U,4);
        case cb.State of
          cbUnchecked: Flags[p] := StsChar[isUnchecked];
          cbChecked:   Flags[p] := StsChar[isChecked];
          else         Flags[p] := StsChar[isUnknown];
        end;
        FItems.SetStrPiece(i,4,Flags);
        if BILLING_AWARE then
          UBAGlobals.BAFlagsIN := Flags;
      end;
    end;
  end;
end;

procedure TSigItems.cbEnter(Sender: TObject);
var
  cb: TORCheckBox;
begin
  cb := TORCheckBox(Sender);
  cb.Color := clHighlight;
  cb.Font.Color := clHighlightText;

  // commented out causing check box states to be out of sync when
   //checked individually and/or when by column or all.
  //CQ5074
  if ( (cb.Focused) and (cb.State = cbGrayed) ) and (not IsAMouseButtonDown) then
     cb.Checked := false;
  //end CQ5074
end;

procedure TSigItems.cbExit(Sender: TObject);
var
  cb: TORCheckBox;
begin
  cb := TORCheckBox(Sender);
  cb.Color := clWindow;
  cb.Font.Color := clWindowText;
end;


procedure TSigItems.lbDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  OldRect: TRect;
  i,j: integer;
  cb: TORCheckBox;
  si: TSigItemType;
  DrawGrid: boolean;
  lb: TCustomListbox;

begin
  lb := TCaptionCheckListBox(Control);
  DrawGrid := (Index < lb.Items.Count);
  if DrawGrid and (trim(lb.Items[Index]) = '') and
                  (Index = (lb.Items.Count - 1)) then
    DrawGrid := FALSE;
  if DrawGrid then
    dec(Rect.Bottom);
  OldRect := Rect;

  Rect.Right := FlastValidX - 4;
{Begin BillingAware}
  if  BILLING_AWARE then Rect.Right := FLastValidX - 55;
{End BillingAware}

//  if assigned(FOldDrawItemEvent) then
  if True then
  begin
    for j := 0 to Length(FOldDrawItemEvents) - 1 do
    begin
      if FOldDrawItemEvents[j].xcontrol = lb then
      begin
        inc(Rect.Bottom);
        FOldDrawItemEvents[j].xevent(Control, Index, Rect, State);
        dec(Rect.Bottom);
      end;
    end;
//    inc(Rect.Bottom);
//    FOldDrawItemEvent(Control, Index, Rect, State);
//    dec(Rect.Bottom);
  end
  else
     begin
     lb.Canvas.FillRect(Rect);
     if Index < lb.Items.Count then
       lb.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top, FilteredString(lb.Items[Index]));
     end;

  if DrawGrid then
     begin
       lb.Canvas.Pen.Color := Get508CompliantColor(clSilver);
       lb.Canvas.MoveTo(Rect.Left, Rect.Bottom);
       lb.Canvas.LineTo(OldRect.RIght, Rect.Bottom);
     end;

  if  BILLING_AWARE then OldRect.Left := Rect.Right + 90
  else OldRect.Left := Rect.Right;

 //// SC Column
 ///
  lb.Canvas.FillRect(OldRect);
  for i := 0 to Fcb.Count-1 do
     begin
       cb := TORCheckBox(Fcb[i]);

       if TagToItem(cb.Tag).Index = Index then
          begin
            cb.Invalidate;
            cb.Top := Rect.Top + FDy;
          end;
     end;

  // EI Columns
  if DrawGrid then
  begin
    for si := low(TSigItemType) to high(TSigItemType) do
    begin
      if FcbX[si] > FLastValidX then
      begin
        if (si = siCL) and (not IsLejeuneActive) then continue;
        lb.Canvas.MoveTo(FcbX[si] - FValidGap, Rect.Top);
        lb.Canvas.LineTo(FcbX[si] - FValidGap, Rect.Bottom);
      end;
    end;
  end;
end;

procedure TSigItems.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = Flb) and (Operation = opRemove) then
  begin
    Fcb.Clear;
    TExposedListBox(Flb).OnDrawItem := FOldDrawItemEvent;
    FOldDrawItemEvent := nil;
    Flb := nil;
  end;
end;

procedure TSigItems.EnableSettings(Index: integer; Checked: boolean);
var
  cb: TORCheckBox;
  i: integer;
  Info: TSigItemTagInfo;

begin
  if Index < 0 then exit;
  for i := 0 to Fcb.Count-1 do
  begin
    if TObject(Fcb[i]) is TORCheckBox then
    begin
      cb := TORCheckBox(Fcb[i]);
      info := TagToItem(cb.Tag);
      if info.Index = Index then
        cb.enabled := Checked;
    end;
  end;
  i := FItems.IndexOfPiece(IntToStr(Index), U, 2);
  if i >= 0 then
    FItems.SetStrPiece(i, 5, BoolChar[not Checked]);
end;

function TSigItems.OK2SaveSettings: boolean;
var
  i, Index: integer;
  s: string;

begin
  {Begin BillingAware}
  if BILLING_AWARE then
     begin
     if Assigned(UBAGlobals.BAOrderList) then
        BAOrderList.Clear
     else
       begin
          BAOrderList := TStringList.Create;
          BAOrderList.Clear;
       end;
{End BillingAware}
  end;

  Result := TRUE;
  for i := 0 to FItems.Count-1 do
  begin
    s := FItems[i];
    Index := StrToIntDef(piece(s,U,2),-1);
    if(Index >= 0) and (piece(s,U,5) <> '1') then
    begin
      if pos(StsChar[isUnknown], piece(s, U, 4)) > 0 then
      begin
        Result := FALSE;
        break;
      end{end if}
      else
         if BILLING_AWARE then
            BAOrderList.Add(piece(s,U,1)+ piece(s,U,3) + piece(s,U,4)); //baph1
    end; {end if}
  end;{end for}
end;

procedure TSigItems.SaveSettings;
var
  s: string;
  i, Index: integer;
  TmpSL: TStringList;

begin
  TmpSL := TStringList.Create;

  try
    for i := 0 to FItems.Count-1 do
    begin
      s := FItems[i];
      Index := StrToIntDef(piece(s,U,2),-1);
      if(Index >= 0) and (piece(s,U,5) <> '1') then
      begin
        TmpSL.Add(Piece(s,U,1) + U + piece(s,U,4));
        FItems.SetStrPiece(i, 6, '1');
      end;
    end;

    SaveCoPayStatus(TmpSL);

  finally
    TmpSL.Free;
  end;
  i := 0;
  while i < FItems.Count do
  begin
    if Piece(FItems[i], U, 6) = '1' then
      FItems.Delete(i)
    else
      inc(i);
  end;
  Fcb.Clear;
end;

{ Begin Billing Aware }

procedure TSigItems.DisplayUnsignedStsFlags(sFlags:string);
var
   Index: integer;
   flags : string;
begin
   Index := 0;
   Flags := sFlags;
   CopyCBValues(Index,Index);

end;

procedure TSigItems.DisplayPlTreatmentFactors;
var
 FactorsOut:TStringList;
 y: integer;
 Index: integer;
begin
     FactorsOut :=  TStringList.Create;
     FactorsOut.Clear;
     FactorsOut := UBAGlobals.PLFactorsIndexes;
     for y := 0 to FactorsOut.Count-1 do
     begin
        Index := StrToInt(Piece(FactorsOut.Strings[y],U,1));
        CopyCBValues(Index,Index);
     end;
end;



procedure TSigItems.CopyCBValues(FromIndex, ToIndex: integer);
var
  si: TSigItemType;
  FromTag, ToTag: integer;
  FromCB, ToCB: TORCheckBox;
  x: string;
begin
  tempCkBx.GrayedStyle := gsBlueQuestionMark;
  
  for si := low(TSigItemType) to high(TSigItemType) do
     begin
       FromTag := ItemToTag(TagInfo(si, FromIndex));
       ToTag := ItemToTag(TagInfo(si, ToIndex));
       FromCB := FindCBValues(FromTag);
       ToCB := FindCBValues(ToTag);

       if assigned(FromCB) then // and assigned(ToCB)) then
          begin
             tempCkBx.State := cbGrayed;
             x:= GetTempCkBxState(FromIndex,si);
             if x = 'C' then tempCkBx.State := cbChecked
             else if x = 'U' then tempCkBx.State := cbUnChecked ;
             ToCB.State := tempCkBx.State;// FromCB.State;
          end;
       end; //for
  end;

function TSigItems.FindCBValues(ATag: integer):TORCheckBox;
var
  i: integer;
  wc: TWinControl;
begin
  for i := 0 to Fcb.Count-1 do
  begin
    wc := TWinControl(Fcb[i]);
    if(wc is TORCheckBox) and (wc.Tag = ATag) then
    begin
      Result := TORCheckBox(wc);
      Exit;
     end;
  end;
  Result := nil;
end;

function  TSigItems.GetTempCkBxState(Index: integer; CBValue:TSIGItemType):string;
var
 locateIdx,thisIdx,i: integer;
 iFactor: integer;
 TmpCBStatus : string;
begin
  try
      locateIdx := Index;
      iFactor := Ord(CBValue) +1;
      for i := 0 to  UBAGlobals.BAFlagsOut.count-1 do
           begin
                thisIdx := StrToInt(Piece(UBAGlobals.BAFlagsOut.Strings[i],U,1));
                if thisIdx = locateIdx then
                begin
                   TmpCBStatus := Piece(UBAGlobals.BAFlagsOut.Strings[i],U,2);
                   TmpCBStatus := Copy(TmpCBStatus,iFactor,1);
                   Result :=TmpCBStatus;
                end;
           end;
  except
     on EAccessViolation do
        begin
//        {$ifdef debug}Show508Message('EAccessViolation in uSignItems.GetTempCkBxState()');{$endif}
        raise;
        end;
  end;
end;
 { End Billing Aware }


initialization
  FlagCount := ord(high(TSigItemType)) - ord(low(TSigItemType)) + 1;
  BaseFlags := StringOfChar(StsChar[isNA], FlagCount);
  thisChangeItem := TChangeItem.Create; //CQ3301/3302
  AllBtnLeft := 0;

finalization
  FreeAndNil(uSigItems);

end.

