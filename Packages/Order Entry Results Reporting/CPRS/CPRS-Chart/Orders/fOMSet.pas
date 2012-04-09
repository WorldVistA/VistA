unit fOMSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, rOrders, uConst, ORFn, rODMeds, fODBase,uCore,fOrders, fframe, fBase508Form,
  VA508AccessibilityManager;

type
  TSetItem = class
    DialogIEN: Integer;
    DialogType: Char;
    OIIEN: string;
    InPkg: string;
    OwnedBy: TComponent;
    RefNum: Integer;
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
    FDelayEvent: TOrderDelayEvent;
    FClosing: Boolean;
    FRefNum: Integer;
    FActiveMenus: Integer;
    FClosebyDeaCheck: Boolean;
    function  IsCreatedByMenu(ASetItem: TSetItem): boolean;
    function  DeaCheckPassed(OIIens: string; APkg: string; AnEventType: Char): boolean;
    procedure DoNextItem;
    procedure UMDestroy(var Message: TMessage); message UM_DESTROY;
    procedure UMDelayEvent(var Message: TMessage); message UM_DELAYEVENT;
  public
    procedure InsertList(SetList: TStringList; AnOwner: TComponent; ARefNum: Integer;
                         const KeyVarStr: string; AnEventType:Char =#0);
    procedure SetEventDelay(AnEvent: TOrderDelayEvent);
    property RefNum: Integer read FRefNum write FRefNum;
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
  TXT_DEAFAIL = 'You need have #DEA key to place the order ';
  TXT_INSTRUCT = #13 + 'Click OK to continue, Click Cancel to terminate the current order process.';
var
  i, InsertAt: Integer;
  SetItem: TSetItem;
begin
  InsertAt := lstSet.ItemIndex + 1;
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
    if not DeaCheckPassed(SetItem.OIIEN, SetItem.InPkg, AnEventType) then
      if InfoBox(TXT_DEAFAIL + Piece(SetList[i], U, 3) + TXT_INSTRUCT,
          'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDOK then
        Continue
      else
      begin
        FClosebyDeaCheck := True;
        Close;
        Exit;
      end;
    lstSet.Items.InsertObject(InsertAt, Piece(SetList[i], U, 3), SetItem);
    Inc(InsertAt);
  end;
  PushKeyVars(KeyVarStr);
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
  //frmFrame.UpdatePtInfoOnRefresh;
  if FClosing then Exit;
  if frmOrders <> nil then
  begin
   if (frmOrders.TheCurrentView<>nil) and (frmOrders.TheCurrentView.EventDelay.PtEventIFN>0)
    and IsCompletedPtEvt(frmOrders.TheCurrentView.EventDelay.PtEventIFN) then
   begin
     FDelayEvent.EventType := #0;
     FDelayEvent.EventIFN  := 0;
     FDelayEvent.TheParent := TParentEvent.Create;
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
                    Inc(FActiveMenus)
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
  DoingNextItem := false;
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
  if Message.WParam = lstSet.ItemIndex then
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
  if SetItem.DialogType = 'M' then Dec(FActiveMenus);
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

procedure TfrmOMSet.FormCreate(Sender: TObject);
begin
  FActiveMenus := 0;
  FClosing := False;
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
    CanClose := True
 else if lstSet.ItemIndex < (lstSet.Items.Count - 1)
   then CanClose := InfoBox(TX_STOP, TC_STOP, MB_YESNO) = IDYES;
   FClosing := CanClose;
end;

procedure TfrmOMSet.FormClose(Sender: TObject; var Action: TCloseAction);
{ Notify remaining owners that their item is done (or - really never completed) }
var
  i: Integer;
  SetItem: TSetItem;
begin
  // do we need to iterate thru and send messages where OwnedBy <> nil?
  FClosing := True;
  for i := 1 to FActiveMenus do PopLastMenu;
  if lstSet.Items.Count > 0 then
  begin
    if lstSet.ItemIndex < 0 then lstSet.ItemIndex := 0;
    with lstSet do for i := ItemIndex to Items.Count - 1 do
    begin
      SetItem := TSetItem(lstSet.Items.Objects[i]);
      if (SetItem.OwnedBy <> nil) and (SetItem.OwnedBy is TWinControl)
        then SendMessage(TWinControl(SetItem.OwnedBy).Handle, UM_DESTROY, SetItem.RefNum, 0);
    end;
  end;
  SaveUserBounds(Self);
  NoFresh := False;
  Action := caFree;
end;

procedure TfrmOMSet.cmdInteruptClick(Sender: TObject);
begin
  if DoingNextItem then
  begin
    CloseRequested := true;             //Fix for CQ: 8297
    FClosing := true;
  end
  else
    Close;
end;

function TfrmOMSet.DeaCheckPassed(OIIens: string; APkg: string; AnEventType: Char): boolean;
var
  tmpIenList: TStringList;
  i: integer;
  isInpt: boolean;
begin
  Result := True;
  if Pos('PS',APkg) <> 1 then
    Exit;
  if Length(OIIens)=0 then Exit;
  tmpIenList := TStringList.Create;
  PiecesToList(OIIens,';',TStrings(tmpIenList));
  case AnEventType of
  'A','T': isInpt := True;
  'D': isInpt := False;
  else isInpt := Patient.Inpatient;
  end;
  for i := 0 to tmpIenList.Count - 1 do
    if DEACheckFailed(StrToIntDef(tmpIenList[i],0), isInpt) then
    begin
      Result := False;
      Break;
    end;
end;

function TfrmOMSet.IsCreatedByMenu(ASetItem: TSetItem): boolean;
begin
  Result := False;
  if (AsetItem.OwnedBy <> nil) and (ASetItem.OwnedBy.Name = 'frmOMNavA') then
    Result := True;
end;

end.
