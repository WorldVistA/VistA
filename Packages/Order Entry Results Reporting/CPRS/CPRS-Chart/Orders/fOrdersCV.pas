unit fOrdersCV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, fAutoSZ, uOrders, rOrders,
  VA508AccessibilityManager;

type
  TfrmChgEvent = class(TfrmAutoSz)
    pnlTop: TPanel;
    lblPtInfo: TLabel;
    pnlBottom: TPanel;
    cboSpecialty: TORComboBox;
    btnCancel: TButton;
    btnAction: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cboSpecialtyChange(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cboSpecialtyDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FDefaultEvntIFN:   Integer;
    FDefaultPtEvntIFN: Integer;
    FCurrSpecialty    : string;
    FDefaultIndex: String;
    FOKPress: boolean;
    FLastIndex: Integer;

    procedure updateChanges(Const AnOrderIDList: TStringList; Const AnEventName: String);

  public
    { Public declarations }
    procedure LoadSpecialtyList;
    procedure Highlight(APtEvtID: string);
    procedure FilterOutEmptyPtEvt;
    property CurrSpecialty: string      read FCurrSpecialty     write FCurrSpecialty;
    property DefaultIndex:   string    read FDefaultIndex      write FDefaultIndex;
    property OKPress:        boolean    read FOKPress           write FOKPress;

  end;

function ExecuteChangeEvt(SelectedList: TList; var DoesDestEvtOccur: boolean;
  var DestPtEvtID: integer; var DestPtEvtName: string): boolean;


implementation

{$R *.DFM}

uses uCore, uConst, forders, fODChangeEvtDisp, rMisc, uWriteAccess;

function ExecuteChangeEvt(SelectedList: TList; var DoesDestEvtOccur: boolean;
  var DestPtEvtID: integer; var DestPtEvtName: string): boolean;
const
  CHANGE_CAP = 'The release event for the following orders will be changed to: ';
  REMOVE_CAP = 'The release event will be deleted for the following orders: ';
var
  i: integer;
  frmChgEvent : TfrmChgEvent;
  AnOrder: TOrder;
  AnOrderIDList: TStringList;
  EvtInfo,AnEvtDlg: string;
  AnEvent: TOrderDelayEvent;
  ThePtEvtID, TheDefaultPtEvtID, TheDefaultEvtInfo, SpeCap: string;
  IsNewEvent: boolean;
  ExistedPtEvtId: integer;

  function DisplayEvntDialog(AEvtDlg: String; AnEvent: TOrderDelayEvent): boolean;
  var
    DlgData: string;
  begin
    DlgData := GetDlgData(AEvtDlg);
    frmOrders.NeedShowModal := True;
    frmOrders.IsDefaultDlg := True;
    Result := frmOrders.PlaceOrderForDefaultDialog(DlgData, True, AnEvent);
    frmOrders.IsDefaultDlg := False;
    frmOrders.NeedShowModal := False;
  end;

  function FindMatchedPtEvtID(EventName: string): integer;
  var
    cnt: integer;
    viewName: string;
  begin
    Result := 0;
    for cnt := 0 to frmOrders.lstSheets.Items.Count - 1 do
    begin
      viewName := Piece(frmOrders.lstSheets.Items[cnt],'^',2);
      if AnsiCompareText(EventName,viewName)=0 then
      begin
        Result := StrToIntDef(Piece(frmOrders.lstSheets.Items[cnt],'^',1),0);
        break;
      end;
    end;

  end;
begin
  Result := False;
  IsNewEvent := False;
  AnEvent.EventType := #0;
  AnEvent.EventIFN  := 0;
  AnEvent.EventName := '';
  AnEvent.Specialty := 0;
  AnEvent.Effective := 0;
  AnEvent.PtEventIFN := 0;
  AnEvent.TheParent := TParentEvent.Create(0);
  AnEvent.IsNewEvent := False;

  if SelectedList.Count = 0 then Exit;
  frmChgEvent := TfrmChgEvent.Create(Application);
  SetFormPosition(frmChgEvent);
  frmChgEvent.CurrSpecialty := Piece(GetCurrentSpec(Patient.DFN),'^',1);
  if Length(frmChgEvent.CurrSpecialty)>0 then
    SpeCap := #13 + '  The current treating specialty is ' + frmChgEvent.CurrSpecialty
  else
    SpeCap := #13 + '  No treating specialty is available.';
  ResizeFormToFont(TForm(frmChgEvent));
  SetFormPosition(frmChgEvent);
  if Patient.Inpatient then
    frmChgEvent.lblPtInfo.Caption := '   ' + Patient.Name + ' is currently admitted to ' + Encounter.LocationName + SpeCap
  else
    frmChgEvent.lblPtInfo.Caption := '   ' + Patient.Name + ' is currently at ' + Encounter.LocationName + SpeCap;
  frmChgEvent.cboSpecialty.Caption := frmChgEvent.lblPtInfo.Caption;
  ThePtEvtID := '';
  AnOrder := TOrder(selectedList[0]);
  TheDefaultPtEvtID := GetOrderPtEvtID(AnOrder.ID);
  if Length(TheDefaultPtEvtID)>0 then
  begin
    frmChgEvent.FDefaultPtEvntIFN := StrToIntDef(TheDefaultPtEvtId,0);
    TheDefaultEvtInfo := EventInfo(TheDefaultPtEvtID);
    frmChgEvent.FDefaultEvntIFN := StrToIntDef(Piece(TheDefaultEvtInfo,'^',2),0);
  end;
  frmChgEvent.LoadSpecialtyList;
  frmChgEvent.ShowModal;
  if frmChgEvent.OKPress then
  begin
    if frmChgEvent.btnAction.Caption = 'Change' then
    begin
      AnOrderIDList := TStringList.Create;
      for i := 0 to selectedList.Count - 1 do
      begin
        AnOrder := TOrder(selectedList[i]);
        AnOrderIDList.Add(AnOrder.ID + U + IntToStr(AnOrder.DGroup));
      end;
      EvtInfo := frmChgEvent.cboSpecialty.Items[frmChgEvent.cboSpecialty.ItemIndex];
      AnEvent.EventType := CharAt(Piece(EvtInfo,'^',3),1);
      AnEvent.EventIFN  := StrToInt64Def(Piece(EvtInfo,'^',1),0);
      if StrToInt64Def(Piece(EvtInfo,'^',13),0) > 0 then
      begin
        AnEvent.TheParent.Assign(Piece(EvtInfo,'^',13));
        AnEvent.EventType := AnEvent.TheParent.ParentType;
      end;
      AnEvent.EventName := Piece(EvtInfo,'^',9);
      ExistedPtEvtId := FindMatchedPtEvtID('Delayed ' + AnEvent.EventName + ' Orders');
      if (ExistedPtEvtId>0) and IsCompletedPtEvt(ExistedPtEvtId) then
      begin
        DoesDestEvtOccur := True;
        DestPtEvtId := ExistedPtEvtId;
        DestPtEvtName := AnEvent.EventName;
        ChangeEvent(AnOrderIDList, '');
        Result := True;
        Exit;
      end;

      if Length(AnEvent.EventName) < 1 then
        AnEvent.EventName := Piece(EvtInfo,'^',2);
      AnEvent.Specialty := 0;
      if TypeOfExistedEvent(Patient.DFN,AnEvent.EventIFN) = 0 then
      begin
         IsNewEvent := True;
         if AnEvent.TheParent.ParentIFN > 0 then
         begin
           if StrToIntDef(AnEvent.TheParent.ParentDlg,0)>0 then
             AnEvtDlg := AnEvent.TheParent.ParentDlg;
         end
         else
           AnEvtDlg := Piece(EvtInfo,'^',5);
      end;
      if (StrToIntDef(AnEvtDlg,0)>0) and (IsNewEvent) then
         if not DisplayEvntDialog(AnEvtDlg, AnEvent) then
         begin
           frmOrders.lstSheets.ItemIndex := 0;
           frmOrders.lstSheetsClick(nil);
           Result := False;
           Exit;
         end;
      if not isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN), ThePtEvtID) then
      begin
        if (AnEvent.TheParent.ParentIFN > 0) and (TypeOfExistedEvent(Patient.DFN,AnEvent.EventIFN) = 0 )then
          SaveEvtForOrder(Patient.DFN, AnEvent.TheParent.ParentIFN, '');
        SaveEvtForOrder(Patient.DFN,AnEvent.EventIFN,'');
        if isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN),ThePtEvtID) then
        begin
          AnEvent.IsNewEvent := False;
          AnEvent.PtEventIFN := StrToIntDef(ThePtEvtID,0);
        end;
      end;
      ChangeEvent(AnOrderIDList, ThePtEvtID);
      frmChgEvent.updateChanges(AnOrderIDList,'Delayed ' + AnEvent.EventName);
      frmChgEvent.Highlight(ThePtEvtID);
      if frmOrders.lstSheets.ItemIndex >= 0 then
        frmOrders.lstSheetsClick(Nil);
    end else
    begin
      if not DispOrdersForEventChange(SelectedList, REMOVE_CAP) then exit;
      AnOrderIDList := TStringList.Create;
      for i := 0 to selectedList.Count - 1 do
      begin
        AnOrder := TOrder(selectedList[i]);
        AnOrderIDList.Add(AnOrder.ID + U + IntToStr(AnOrder.DGroup));
      end;
      ChangeEvent(AnOrderIDList,'');
      frmChgEvent.updateChanges(AnOrderIDList,'');
      frmChgEvent.FilterOutEmptyPtEvt;
      frmOrders.InitOrderSheetsForEvtDelay;
      frmOrders.lstSheets.ItemIndex := 0;
      frmOrders.lstSheetsClick(Nil);
    end;
    Result := True;
  end else
    Result := False;
end;

{ TfrmChgEvent }

procedure TfrmChgEvent.LoadSpecialtyList;
var
  i: integer;
  tempStr: string;
begin
  inherited;
  cboSpecialty.Items.Clear;
  if Patient.Inpatient then
  begin
    ListSpecialtiesED(#0,cboSpecialty.Items);
  end
  else  ListSpecialtiesED('A',cboSpecialty.Items);
  if FDefaultEvntIFN > 0 then
  begin
    for i := 0 to cboSpecialty.Items.Count - 1 do
    begin
      if Piece(cboSpecialty.Items[i],'^',1)=IntToStr(FDefaultEvntIFN) then
      begin
        tempStr := cboSpecialty.Items[i];
        cboSpecialty.Items.Insert(0,tempStr);
        cboSpecialty.Items.Insert(1,'^^^^^^^^__________________________________________________________________________________');
        cboSpecialty.ItemIndex := 0;
        FDefaultIndex := Piece(tempStr,'^',1);
        btnAction.Visible := True;
        btnAction.Caption := 'Remove';
        break;
      end;
    end;
    if cboSpecialty.ItemIndex < 0 then
      btnAction.Visible := False;
  end;
end;

procedure TfrmChgEvent.FormCreate(Sender: TObject);
begin
  inherited;
  FDefaultEvntIFN   := 0;
  FDefaultPtEvntIFN := 0;
  FCurrSpecialty    := '';
  FDefaultIndex     := '';
  FOKPress          := False;
  FLastIndex        := 0;

end;

procedure TfrmChgEvent.cboSpecialtyChange(Sender: TObject);
const
  TX_MCHEVT1  = ' is already assigned to ';
  TX_MCHEVT2  = #13 + 'Do you still want to write delayed orders?';
var
  AnEvtID, AnEvtType: string;
  AnEvtName,ATsName: string;
  i: integer;
  NMRec : TNextMoveRec;
 begin
  inherited;
   NextMove(NMRec, FLastIndex, cboSpecialty.ItemIndex); //Logic added for 508 1/31/03
   FLastIndex := NMRec.LastIndex ;
  if (cboSpecialty.text = '') or (cboSpecialty.ItemIndex = -1) then
  begin
    btnAction.visible := False;
    btnAction.Caption := '';
  end
  else if (Piece(cboSpecialty.Items[cboSpecialty.ItemIndex],'^',1) <> FDefaultIndex) then
  begin
    btnAction.Visible := True;
    btnAction.Caption := 'Change';
  end
  else
  begin
    btnAction.Visible := True;
    btnAction.Caption := 'Remove';
  end;
  if cboSpecialty.ItemIndex >= 0 then
  begin
    AnEvtID   := Piece(cboSpecialty.Items[cboSpecialty.ItemIndex],'^',1);
    AnEvtType := Piece(cboSpecialty.Items[cboSpecialty.ItemIndex],'^',3);
    AnEvtName := Piece(cboSpecialty.Items[cboSpecialty.ItemIndex],'^',9)
  end else
  begin
    AnEvtID   := '';
    AnEvtType := '';
    AnEvtName := '';
  end;
  ATsName := CurrSpecialty;
  if (StrToIntDef(AnEvtID,0)>0) and (isMatchedEvent(Patient.DFN,AnEvtID,ATsName)) then
  begin
    if InfoBox(Patient.Name + TX_MCHEVT1 + CurrSpecialty + ' on ' + Encounter.LocationName + TX_MCHEVT2,
        'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDOK then
      btnActionClick(Self)
   else
   begin
     if Length(FDefaultIndex) > 0 then
     begin
       for i := 0 to cboSpecialty.Items.Count - 1 do
       begin
         if Piece(cboSpecialty.items[i],'^',1)=FDefaultIndex then
         begin
           cboSpecialty.ItemIndex := cboSpecialty.ItemIndex + NMRec.NextStep; //Added this code for 508 compliance GRE 01/30/03
           break;
         end;
       end;
       btnAction.Caption := 'Remove';
     end else
     begin
       cboSpecialty.ItemIndex := 0;
       btnAction.Caption := 'Change';
     end;
   end;
  end;
end;

procedure TfrmChgEvent.btnActionClick(Sender: TObject);
const
TX_REASON_REQ = 'A Delayed Event must be selected.';
TX_REMOVE     = 'Are you sure you want to remove the release event from these orders?';
TX_CHANGE     = 'Are you sure you want to change the release event for these orders?';

begin
  inherited;
  if cboSpecialty.ItemIndex < 0 then
  begin
    InfoBox(TX_REASON_REQ, 'No Selection made', MB_OK);
    Exit;
  end;
  OKPress := True;
  Close;
end;

procedure TfrmChgEvent.btnCancelClick(Sender: TObject);
begin
  Close;
end;
procedure TfrmChgEvent.cboSpecialtyDblClick(Sender: TObject);
begin
  inherited;
  if cboSpecialty.ItemIndex > -1 then
    btnActionClick(Self);
end;

procedure TfrmChgEvent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
  Action := caFree;
end;

procedure TfrmChgEvent.updateChanges(const AnOrderIDList: TStringList; const AnEventName: String);
var
  jx, TempSigSts, DG: integer;
  theChangeItem: TChangeItem;
  TempText: string;
  id: string;

begin
  for jx := 0 to AnOrderIDList.Count - 1 do
  begin
    id := Piece(AnOrderIDList[jx], U, 1);
    DG := StrToIntDef(Piece(AnOrderIDList[jx], U, 2), 0);
    theChangeItem := Changes.Locate(CH_ORD, id);
    if theChangeItem = nil then
    begin
      TempText := RetrieveOrderText(id);
      Changes.Add(CH_ORD, id, TempText, AnEventName, CH_SIGN_YES, waOrders, '', 0, DG)
    end
    else
    begin
      TempText := theChangeItem.Text;
      TempSigSts := theChangeItem.SignState;
      Changes.Remove(CH_ORD, id);
      Changes.Add(CH_ORD, id, TempText, AnEventName, TempSigSts, waOrders, '', 0, DG);
    end;
  end;
  if FDefaultPtEvntIFN>0 then
  begin
    if PtEvtEmpty(IntToStr(FDefaultPtEvntIFN)) then
    begin
      DeletePtEvent(IntToStr(FDefaultPtEvntIFN));
      frmOrders.ChangesUpdate(IntToStr(FDefaultPtEvntIFN));
    end;
  end;
end;

procedure TfrmChgEvent.Highlight(APtEvtID: string);
var
  jjj: integer;
begin
  FilterOutEmptyPtEvt;
  frmOrders.InitOrderSheetsForEvtDelay;
  for jjj := 0 to frmOrders.lstSheets.Items.Count - 1 do
  begin
    if Piece(frmOrders.lstSheets.Items[jjj],'^',1)=APtEvtID then
    begin
      frmOrders.lstSheets.ItemIndex := jjj;
      break;
    end;
  end;
end;

procedure TfrmChgEvent.FilterOutEmptyPtEvt;
var
  TmpStr: string;
  hhh: integer;
  AaPtEvtList: TStringList;
begin
  AaPtEvtList := TStringList.Create;
  LoadOrderSheetsED(AaPtEvtList);
  for hhh := 0 to AaPtEvtList.Count - 1 do
  begin
    if StrToIntDef(Piece(AaPtEvtList[hhh],'^',1),0)>0 then
    begin
      if DeleteEmptyEvt(Piece(AaPtEvtList[hhh],'^',1),TmpStr, False) then
        frmOrders.ChangesUpdate(Piece(AaPtEvtList[hhh],'^',1));
    end;
  end;
end;

end.
