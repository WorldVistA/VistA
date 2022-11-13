unit fOMSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, rOrders, uConst, ORFn, rODMeds, fODBase,uCore,fOrders, fframe, fBase508Form,
  VA508AccessibilityManager;

type
  TSetItem = class
  public
    DialogIEN: Integer;
    DialogType: Char;
    OIIEN: string;
    InPkg: string;
    OwnedBy: TComponent;
    RefNum: Integer;
    MenuActive: Boolean;
  end;

  TfrmOMSet = class(TfrmBase508Form)
    lstSet: TCheckListBox;
    cmdInterupt: TButton;
    procedure cmdInteruptClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    DoingNextItem : Boolean;
    CloseRequested : Boolean;
    FromInterrupt: Boolean;
    FDelayEvent: TOrderDelayEvent;
    FClosing: Boolean;
    FRefNum: Integer;
    FActiveMenus: Integer;
    FClosebyDeaCheck: Boolean;
    function  IsCreatedByMenu(ASetItem: TSetItem): boolean;
    function  DeaCheckPassed(OIIens: string; APkg: string; AnEventType: Char): string;
    procedure DoNextItem;
    procedure UMDestroy(var Message: TMessage); message UM_DESTROY;
    procedure UMDelayEvent(var Message: TMessage); message UM_DELAYEVENT;
    function GetActiveMenus: integer;
  public
    procedure InsertList(SetList: TStringList; AnOwner: TComponent; ARefNum: Integer;
                         const KeyVarStr: string; AnEventType:Char =#0);
    procedure SetEventDelay(AnEvent: TOrderDelayEvent);
    property RefNum: Integer read FRefNum write FRefNum;
    property ActiveMenus: Integer read GetActiveMenus write FActiveMenus;
  end;

var
  frmOMSet: TfrmOMSet;

implementation

{$R *.DFM}

uses uOrders, fOMNavA, rMisc, uODBase;

const
  TX_STOP = 'Do you want to stop entering the current set of orders?';
  TC_STOP = 'Interrupt Order Set';

procedure TfrmOMSet.SetEventDelay(AnEvent: TOrderDelayEvent);
begin
  FDelayEvent := AnEvent;
end;

procedure TfrmOMSet.InsertList(SetList: TStringList; AnOwner: TComponent; ARefNum: Integer;
  const KeyVarStr: string; AnEventType: Char);
{ expects SetList to be strings of DlgIEN^DlgType^DisplayName^OrderableItemIens }
const
  TXT_DEAFAIL1 = 'Order for controlled substance ';
  TXT_DEAFAIL2 = CRLF + 'could not be completed. Provider does not have a' + CRLF +
                 'current, valid DEA# on record and is ineligible' + CRLF + 'to sign the order.';
  TXT_SCHFAIL  = CRLF + 'could not be completed. Provider is not authorized' + CRLF +
                 'to prescribe medications in Federal Schedule ';
  TXT_SCH_ONE  = ' could not be completed.' + CRLF +
                 'Electronic prescription of medications in Federal Schedule 1 is prohibited.' + CRLF + CRLF +
                 'Valid Schedule 1 investigational medications require paper prescription.';
  TXT_NO_DETOX = CRLF + 'could not be completed. Provider does not have a' + CRLF +
                 'valid Detoxification/Maintenance ID number on' + CRLF + 'record and is ineligible to sign the order.';
  TXT_EXP_DETOX1 = CRLF + 'could not be completed. Provider''s Detoxification/Maintenance' + CRLF +
                   'ID number expired due to an expired DEA# on ';
  TXT_EXP_DETOX2 = '.' + CRLF + 'Provider is ineligible to sign the order.';
  TXT_EXP_DEA1 = CRLF + 'could not be completed. Provider''s DEA# expired on ';
  TXT_EXP_DEA2 = CRLF + 'and no VA# is assigned. Provider is ineligible to sign the order.';
  TXT_INSTRUCT = CRLF + CRLF + 'Click RETRY to select another provider.' + CRLF +
                 'Click CANCEL to cancel the current order process.';
  TC_DEAFAIL   = 'Order not completed';
var
  i, InsertAt, InsHold: Integer;
  SetItem: TSetItem;
  DEAFailStr, TX_INFO: string;
begin

  //SMT If we are not inserting at the beginning of the orderset, we are inserting
  //   an orderset into an order set and want to insert above our current menu so that
  //   we don't automatically skip the menu when selecting the order set.

  InsertAt := 0;

  if lstSet.ItemIndex > -1 then
  begin
    //Get the current order set
    SetItem := TSetItem(lstSet.Items.Objects[lstSet.ItemIndex]);
    if assigned(SetItem) then
    begin
      //If the current orderset is using a menu then add the order set items above
      if SetItem.MenuActive then
        InsertAt := lstSet.ItemIndex
      else
       InsertAt := lstSet.ItemIndex + 1;
    end else
       InsertAt := lstSet.ItemIndex + 1;

  end;

  InsHold := InsertAt;

  with SetList do for i := 0 to Count - 1 do
  begin
    SetItem := TSetItem.Create;
    SetItem.DialogIEN  := StrToIntDef(Piece(SetList[i], U, 1), 0);
    SetItem.DialogType := CharAt(Piece(SetList[i], U, 2), 1);
    SetItem.OIIEN      := Piece(SetList[i], U, 4);
    SetItem.InPkg      := Piece(SetList[i], U, 5);
    // put the Owner form and reference number in the last item
    if i = Count - 1 then
    begin
      SetItem.OwnedBy := AnOwner;
      SetItem.RefNum  := ARefNum;
    end;
    DEAFailStr := '';
    DEAFailStr := DeaCheckPassed(SetItem.OIIEN, SetItem.InPkg, AnEventType);
    if DEAFailStr <> '' then
      begin
        case StrToIntDef(Piece(DEAFailStr,U,1),0) of
          1:  TX_INFO := TXT_DEAFAIL1 + Piece(SetList[i], U, 3) + TXT_DEAFAIL2;  //prescriber has an invalid or no DEA#
          2:  TX_INFO := TXT_DEAFAIL1 + Piece(SetList[i], U, 3) + TXT_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
          3:  TX_INFO := TXT_DEAFAIL1 + Piece(SetList[i], U, 3) + TXT_NO_DETOX;  //prescriber has an invalid or no Detox#
          4:  TX_INFO := TXT_DEAFAIL1 + Piece(SetList[i], U, 3) + TXT_EXP_DEA1 + Piece(DEAFailStr,U,2) + TXT_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
          5:  TX_INFO := TXT_DEAFAIL1 + Piece(SetList[i], U, 3) + TXT_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TXT_EXP_DETOX2;  //valid detox#, but expired DEA#
          6:  TX_INFO := TXT_DEAFAIL1 + Piece(SetList[i], U, 3) + TXT_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
        end;
        if StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] then
          begin
            if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
              begin
                InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                FClosebyDeaCheck := True;
                Continue;
              end;
            if InfoBox(TX_INFO + TXT_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL or MB_ICONERROR) = IDRETRY then
              begin
                DEAContext := True;
                fFrame.frmFrame.mnuFileEncounterClick(Self);
                DEAFailStr := '';
                DEAFailStr := DeaCheckPassed(SetItem.OIIEN, SetItem.InPkg, AnEventType);
                if StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..5] then Continue
              end
            else
              begin
                FClosebyDeaCheck := True;
                Close;
                Exit;
              end;
          end;
      end;
    lstSet.Items.InsertObject(InsertAt, Piece(SetList[i], U, 3), SetItem);
    Inc(InsertAt);
  end;
  PushKeyVars(KeyVarStr);
  //SMT reset the index after addition.
  lstSet.ItemIndex := InsHold -1;
  DoNextItem;
end;

procedure TfrmOMSet.DoNextItem;
var
  SetItem: TSetItem;
  theOwner: TComponent;
  ok: boolean;

  procedure SkipToNext;
  begin
    if FClosing then Exit;
    lstSet.Checked[lstSet.ItemIndex] := True;
    DoNextItem;
  end;

begin
  DoingNextItem := true;
  try
  //frmFrame.UpdatePtInfoOnRefresh;
  if FClosing then Exit;
  if frmOrders <> nil then
  begin
   if (frmOrders.TheCurrentView<>nil) and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
    and IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
   begin
     FDelayEvent.EventType := #0;
     FDelayEvent.EventIFN  := 0;
     FDelayEvent.TheParent := TParentEvent.Create(0);
     FDelayEvent.EventName := '';
     FDelayEvent.PtEventIFN := 0;
   end;
  end;
  with lstSet do
  begin
    if ItemIndex >= Items.Count - 1 then
    begin
      Close;
      Exit;
    end;
    ItemIndex := ItemIndex + 1;
    SetItem := TSetItem(Items.Objects[ItemIndex]);
    case SetItem.DialogType of
    'A':      if not ActivateAction(IntToStr(SetItem.DialogIEN), Self, ItemIndex) then
              begin
                if Not FClosing then
                begin
                  if IsCreatedByMenu(SetItem) and (lstSet.ItemIndex < lstSet.Items.Count - 1) then
                    lstSet.Checked[lstSet.ItemIndex] := True
                  else SkipToNext;
                end;
              end;
    'D', 'Q': if not ActivateOrderDialog(IntToStr(SetItem.DialogIEN), FDelayEvent, Self, ItemIndex) then
              begin
                if Not FClosing then
                begin
                  if IsCreatedByMenu(SetItem) and (lstSet.ItemIndex < lstSet.Items.Count - 1) then
                    lstSet.Checked[lstSet.ItemIndex] := True
                  else SkipToNext;
                end;
              end;
    'M':      begin
                ok := ActivateOrderMenu(IntToStr(SetItem.DialogIEN), FDelayEvent, Self, ItemIndex);
                if not FClosing then
                begin
                  if ok then
                    SetItem.MenuActive := true
                  //  Inc(FActiveMenus)
                  else
                  begin
                    if IsCreatedByMenu(SetItem) and (lstSet.ItemIndex < lstSet.Items.Count - 1) then
                      lstSet.Checked[lstSet.ItemIndex] := True
                    else
                      SkipToNext;
                  end;
                end;
              end;
    'O':      begin
                if (Self.Owner.Name = 'frmOMNavA') then theOwner := Self.Owner else theOwner := self;
                if not ActivateOrderSet( IntToStr(SetItem.DialogIEN), FDelayEvent, theOwner, ItemIndex) then
                begin
                  if Not FClosing then
                  begin
                    if IsCreatedByMenu(SetItem) and (lstSet.ItemIndex < lstSet.Items.Count - 1) then
                      lstSet.Checked[lstSet.ItemIndex] := True
                    else SkipToNext;
                  end;
                end;
              end;
    else      begin
                InfoBox('Unsupported dialog type: ' + SetItem.DialogType, 'Error', MB_OK);
                SkipToNext;
              end;
    end; {case}
  end; {with lstSet}
  finally
  DoingNextItem := false;
  end;
end;

procedure TfrmOMSet.UMDelayEvent(var Message: TMessage);
begin
  if CloseRequested then
  begin
    Close;
    if Not FClosing then
      begin
        CloseRequested := False;
        FClosing := False;
        DoNextItem;
      end
      else Exit;
  end;
  // ignore if delay from other than current itemindex
  // (prevents completion of an order set from calling DoNextItem)
  if Integer(Message.WParam) = lstSet.ItemIndex then
    if lstSet.ItemIndex < lstSet.Items.Count - 1 then DoNextItem else Close;
end;

procedure TfrmOMSet.UMDestroy(var Message: TMessage);
{ Received whenever activated item is finished.  Posts to Owner if last item in the set. }
var
  SetItem: TSetItem;
  RefNum: Integer;
begin
  RefNum := Message.WParam;
  lstSet.Checked[RefNum] := True;
  SetItem := TSetItem(lstSet.Items.Objects[RefNum]);
  if SetItem.DialogType = 'M' then
   SetItem.MenuActive := false;
  //Dec(FActiveMenus);
  if (SetItem.OwnedBy <> nil) and (SetItem.DialogType <> 'O') then
  begin
    PopKeyVars;
    if ((lstSet.ItemIndex = lstSet.Count - 1) and (lstSet.Checked[lstSet.ItemIndex] = True)) then Close;
    if {(SetItem.OwnedBy <> Self) and} (SetItem.OwnedBy is TWinControl) then
    begin
      SendMessage(TWinControl(SetItem.OwnedBy).Handle, UM_DESTROY, SetItem.RefNum, 0);
      //Exit;
    end;
  end;
  // let menu or dialog finish closing before going on to next item in the order set
  While RefNum <= lstSet.Items.Count - 2 do
  begin
    if not (lstSet.Checked[RefNum+1]) then Break
    else
    begin
      RefNum := RefNum + 1;
      lstSet.ItemIndex := RefNum;
    end;
  end;
  PostMessage(Handle, UM_DELAYEVENT, RefNum, 0);
end;

function TfrmOMSet.GetActiveMenus: integer;
var
 SetItem: TSetItem;
 i: integer;
begin
 Result := 0;
 for I := 0 to lstSet.Items.Count - 1 do
 begin
   if Assigned(lstSet.Items.Objects[I]) then
   begin
     SetItem := TSetItem(lstSet.Items.Objects[I]);
     if (SetItem.DialogType = 'M') and (SetItem.MenuActive) then
      Inc(Result);
   end;
 end;
end;

procedure TfrmOMSet.FormCreate(Sender: TObject);
begin
  FActiveMenus := 0;
  FClosing := False;
  FromInterrupt := False;
  FClosebyDeaCheck := False;
  NoFresh := True;
  CloseRequested := false;
  DoingNextItem := false;
end;

procedure TfrmOMSet.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  with lstSet do for i := 0 to Items.Count - 1 do TSetItem(Items.Objects[i]).Free;
  DestroyingOrderSet;
end;

procedure TfrmOMSet.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ if this is not the last item in the set, prompt whether to interrupt processing }
begin
  if FClosebyDeaCheck then
  begin
    CanClose := True;
    FClosing := CanClose;
    FromInterrupt := False;
  end
  else if lstSet.ItemIndex < (lstSet.Items.Count - 1) then
  begin
    if DoingNextItem and (not CloseRequested) and (not FromInterrupt) then
    begin
      CloseRequested := True;
      FClosing := True;
      CanClose := False;
    end
    else
    begin
      CanClose := InfoBox(TX_STOP, TC_STOP, MB_YESNO) = IDYES;
      FClosing := CanClose;
      FromInterrupt := False;
    end;
  end;
end;

procedure TfrmOMSet.FormClose(Sender: TObject; var Action: TCloseAction);
{ Notify remaining owners that their item is done (or - really never completed) }
var
  i, TotalActiveMenus: Integer;
  SetItem: TSetItem;
begin
  // do we need to iterate thru and send messages where OwnedBy <> nil?
  FClosing := True;

  TotalActiveMenus := ActiveMenus;
  for i := 1 to TotalActiveMenus do
    PopLastMenu;

  if lstSet.Items.Count > 0 then
    begin
      if lstSet.ItemIndex < 0 then
        lstSet.ItemIndex := 0;

      with lstSet do
        //for i := ItemIndex to Items.Count - 1 do
        for i := Items.Count - 1 downto ItemIndex do
          begin
            SetItem := TSetItem(lstSet.Items.Objects[i]);
            if (SetItem.OwnedBy <> nil) and (SetItem.OwnedBy <> Self) and (SetItem.OwnedBy is TWinControl) then
              SendMessage(TWinControl(SetItem.OwnedBy).Handle, UM_DESTROY, SetItem.RefNum, 0);
          end;
    end;
  SaveUserBounds(Self);
  NoFresh := False;
  Action := caFree;
end;

procedure TfrmOMSet.cmdInteruptClick(Sender: TObject);
begin
  FromInterrupt := True;
  if DoingNextItem then
  begin
    CloseRequested := true;             //Fix for CQ: 8297
    FClosing := true;
  end
  else
    Close;
end;

function TfrmOMSet.DeaCheckPassed(OIIens: string; APkg: string; AnEventType: Char): string;
var
  tmpIenList: TStringList;
  i: integer;
  InptDlg: boolean;
  DEAFailstr: string;
begin
  Result := '';
  InptDlg := False;
  if Pos('PS',APkg) <> 1 then
    Exit;
  if Length(OIIens)=0 then Exit;
  tmpIenList := TStringList.Create;
  PiecesToList(OIIens,';',TStrings(tmpIenList));
  (* case AnEventType of
  'A','T': isInpt := True;
  'D': isInpt := False;
  else isInpt := Patient.Inpatient;
  end; *)
  if APkg = 'PSO' then InptDlg := False
  else if APkg = 'PSJ' then InptDlg := True;
  for i := 0 to tmpIenList.Count - 1 do
    begin
      DEAFailStr := '';
      DEAFailStr := DEACheckFailed(StrToIntDef(tmpIenList[i],0), InptDlg);
      if StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] then
      begin
        Result := DEAFailStr;
        Break;
      end;
    end;
end;

function TfrmOMSet.IsCreatedByMenu(ASetItem: TSetItem): boolean;
begin
  Result := False;
  if (AsetItem.OwnedBy <> nil) and (ASetItem.OwnedBy.Name = 'frmOMNavA') then
    Result := True;
end;

end.
