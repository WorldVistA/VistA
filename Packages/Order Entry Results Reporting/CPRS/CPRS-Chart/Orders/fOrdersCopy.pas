unit fOrdersCopy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, mEvntDelay, uCore, fODBase, UConst, fAutoSz, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmCopyOrders = class(TfrmBase508Form)
    pnlInfo: TPanel;
    fraEvntDelayList: TfraEvntDelayList;
    pnlRadio: TPanel;
    GroupBox1: TGroupBox;
    radRelease: TRadioButton;
    radEvtDelay: TRadioButton;
    Image1: TImage;
    lblInstruction2: TVA508StaticText;
    lblInstruction: TVA508StaticText;
    pnlTop: TPanel;
    lblPtInfo: TVA508StaticText;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlBottom: TPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure radEvtDelayClick(Sender: TObject);
    procedure radReleaseClick(Sender: TObject);
    procedure fraEvntDelayListcboEvntListChange(Sender: TObject);
    procedure UMStillDelay(var message: TMessage); message UM_STILLDELAY;
    procedure fraEvntDelayListmlstEventsDblClick(Sender: TObject);
    procedure fraEvntDelayListmlstEventsChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fraEvntDelayListedtSearchChange(Sender: TObject); //rtw
  private
    OKPressed: Boolean;
    procedure AdjustFormSize;
  public
  end;

function SetViewForCopy(var IsNewEvent: boolean; var DoesDestEvtOccur: boolean;
  var DestPtEvtID: integer; var DestPtEvtName: string): Boolean;
  function ShouldCancelCopyOrder: boolean; //rtw
var
  frmCopyOrders: TfrmCopyOrders;

implementation
{$R *.DFM}

uses fOrders, fOrdersTS, ORFn, rOrders, uWriteAccess;
var //rtw
 copyordercancel: boolean;  //rtw

Function ShouldCancelCopyorder: boolean; //rtw
begin
  result := copyordercancel;
end; //rtw

function SetViewForCopy(var IsNewEvent: boolean; var DoesDestEvtOccur: boolean;
  var DestPtEvtID: integer; var DestPtEvtName: string): Boolean;
var
  EvtInfo,APtEvtID, AnEvtDlg: string;
  AnEvent: TOrderDelayEvent;
  SpeCap, CurrTS: string;
  ExistedPtEvtID: integer;

  procedure Highlight(APtEvtID: string);
  var
    j: integer;
  begin
    frmOrders.InitOrderSheetsForEvtDelay;
    for j := 0 to frmOrders.lstSheets.Items.Count - 1 do
    begin
      if Piece(frmOrders.lstSheets.Items[j],'^',1)=APtEvtID then
      begin
        frmOrders.lstSheets.ItemIndex := j;
        break;
      end;
    end;
  end;

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
  AnEvent.EventType := #0;
  AnEvent.EventIFN  := 0;
  AnEvent.EventName := '';
  AnEvent.Specialty := 0;
  AnEvent.Effective := 0;
  AnEvent.PtEventIFN := 0;
  AnEvent.TheParent := TParentEvent.Create(0);
  AnEvent.IsNewEvent := False;

  frmCopyOrders := TfrmCopyOrders.Create(Application);
  try
    ResizeAnchoredFormToFont(TForm(frmCopyOrders));
    frmCopyOrders.AdjustFormSize;
    CurrTS := Piece(GetCurrentSpec(Patient.DFN),'^',1);
    if Length(CurrTS)>0 then
      SpeCap := #13 + 'The current treating specialty is ' + CurrTS
    else
      SpeCap := #13 + 'No treating specialty is available.';
    //ResizeFormToFont(TForm(frmCopyOrders));
    if Patient.Inpatient then
      frmCopyOrders.lblPtInfo.Caption := Patient.Name + ' is currently admitted to ' + Encounter.LocationName + SpeCap
    else
    begin
      if (Encounter.Location > 0) then
        frmCopyOrders.lblPtInfo.Caption := Patient.Name + ' is currently at ' + Encounter.LocationName + SpeCap
      else
        frmCopyOrders.lblPtInfo.Caption := Patient.Name + ' currently is an outpatient.'  + SpeCap;
    end;
    frmCopyOrders.AdjustFormSize;
    frmCopyOrders.ShowModal;
    if (frmCopyOrders.OKPressed) and (frmCopyOrders.radRelease.Checked) then
    begin
      frmOrders.lstSheets.ItemIndex := 0;
      frmOrders.lstSheetsClick(Nil);
      Result := True;
    end;
    if (frmCopyOrders.OKPressed) and (frmCopyOrders.radEvtDelay.Checked) then
    begin
      EvtInfo := frmCopyOrders.fraEvntDelayList.mlstEvents.Items[frmCopyOrders.fraEvntDelayList.mlstEvents.ItemIndex];
      AnEvent.EventType := CharAt(Piece(EvtInfo,'^',3),1);
      AnEvent.EventIFN  := StrToInt64Def(Piece(EvtInfo,'^',1),0);
      if StrToInt64Def(Piece(EvtInfo,'^',13),0) > 0 then
      begin
        AnEvent.TheParent.Assign(Piece(EvtInfo,'^',13));
        AnEvent.EventType := AnEvent.TheParent.ParentType;
      end;
      AnEvent.EventName := frmCopyOrders.fraEvntDelayList.mlstEvents.DisplayText[frmCopyOrders.fraEvntDelayList.mlstEvents.ItemIndex];
      AnEvent.Specialty := 0;
      if frmCopyOrders.fraEvntDelayList.orDateBox.Visible then
        AnEvent.Effective := frmCopyOrders.fraEvntDelayList.orDateBox.FMDateTime
      else
        AnEvent.Effective := 0;
      ExistedPtEvtID := FindMatchedPtEvtID('Delayed ' + AnEvent.EventName + ' Orders');
      if (ExistedPtEvtId>0) and IsCompletedPtEvt(ExistedPtEvtId) then
      begin
        DoesDestEvtOccur := True;
        DestPtEvtId := ExistedPtEvtId;
        DestPtEvtName := AnEvent.EventName;
        IsNewEvent := False;
        Result := True;
        Exit;
      end;
      IsNewEvent := False;
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
      if not isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN), APtEvtID) then
      begin
        IsNewEvent := True;
        if (AnEvent.TheParent.ParentIFN > 0) and (TypeOfExistedEvent(Patient.DFN,AnEvent.EventIFN) = 0) then
           SaveEvtForOrder(Patient.DFN,AnEvent.TheParent.ParentIFN,'');
        SaveEvtForOrder(Patient.DFN,AnEvent.EventIFN,'');
        if isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN),APtEvtID) then
        begin
          Highlight(APtEvtID);
          AnEvent.IsNewEvent := False;
          AnEvent.PtEventIFN := StrToIntDef(APtEvtID,0);
        end;
      end else
      begin
        Highlight(APtEvtID);
        AnEvent.PtEventIFN := StrToIntDef(APtEvtID,0);
        AnEvent.IsNewEvent := False;
      end;
      DestPtEvtId := AnEvent.PtEventIFN;
      DestPtEvtName := AnEvent.EventName;
      if (AnEvent.PtEventIFN >0) and IsCompletedPtEvt(AnEvent.PtEventIFN) then
      begin
        DoesDestEvtOccur := True;
        IsNewEvent := False;
        Result := True;
        Exit;
      end;
      if frmOrders.lstSheets.ItemIndex > -1 then
      begin
        frmOrders.AskForCancel := False;
        frmOrders.lstSheetsClick(nil);
        frmOrders.AskForCancel := True;
      end;
      Result := True;
    end;
  finally
    frmCopyOrders.fraEvntDelayList.ResetProperty;
    frmCopyOrders.Free;
  end;
end;

procedure TfrmCopyOrders.FormCreate(Sender: TObject);
begin
  inherited;
  if rOrders.UAPViewCalling then  //rtw to next rtw
  begin
    radRelease.Checked := False;
    radEvtDelay.Checked := True;
    radRelease.Visible := False;
  end
  else //rtw
    radRelease.Checked := True;
  OKPressed := False;
  if not Patient.Inpatient then
  begin
    pnlInfo.Visible := False;
  end;
  AdjustFormSize;
end;

procedure TfrmCopyOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  if (radEvtDelay.Checked) and (fraEvntDelayList.mlstEvents.ItemIndex < 0 ) then
  begin
    InfoBox('A release event must be selected.', 'No Selection Made', MB_OK);
    Exit;
  end;
  if radRelease.Checked then
  begin
    ImmdCopyAct := True;
    frmOrders.lstSheets.ItemIndex := 0;
    frmOrders.lstSheetsClick(Self);
  end;
  OKPressed := True;
  Close;
end;

procedure TfrmCopyOrders.AdjustFormSize;
var
  y: integer;
begin
  copyordercancel := FALSE;    //rtw
  y := lblPtInfo.Height + 8; // allow for font changes
  if pnlInfo.Visible then
  begin
    lblInstruction2.top := lblInstruction.Height; // allow for font change
    pnlInfo.Height := lblInstruction2.top + lblInstruction2.Height;
    inc(y,pnlInfo.Height);
  end;
  pnlTop.Height := y;
  inc(y, pnlRadio.Height);
  if fraEvntDelayList.Visible then
  begin
    inc(y, fraEvntDelayList.Height);
  end;
  VertScrollBar.Range := y;
  ClientHeight := y;
end;

procedure TfrmCopyOrders.cmdCancelClick(Sender: TObject);
begin
copyordercancel := TRUE;   //rtw
inherited;
  Close;
end;

procedure TfrmCopyOrders.radEvtDelayClick(Sender: TObject);
var i: integer;
begin
  inherited;
  if not WriteAccess(waDelayedOrders, True) then
  begin
    radReleaseClick(radRelease);
    exit;
  end;

  if radRelease.Checked then
    radRelease.Checked  := False;
  radEvtDelay.Checked := True;
  fraEvntDelayList.Visible := True;
  //hide Release Immediately for UAP //rtw
  if not rOrders.UAPViewCalling then //rtw
     frmCopyOrders.fraEvntDelayList.UserDefaultEvent := StrToIntDef(GetDefaultEvt(IntToStr(User.DUZ)),0);
  fraEvntDelayList.DisplayEvntDelayList;
  for i:= 0 to fraEvntDelayList.mlstEvents.Items.Count -1 do  //rtw to next rtw
  begin
     //for UAP default to DISCHARGE selection
    if (Piece(fraEvntDelayList.mlstEvents.Items[i],'^',2)='DISCHARGE') then
      fraEvntDelayList.mlstEvents.ItemIndex := i ;
  end;
  //end UAP enhancement   //rtw
AdjustFormSize;
end;

procedure TfrmCopyOrders.radReleaseClick(Sender: TObject);
begin
  inherited;
  if radEvtDelay.Checked then
    radEvtDelay.Checked := False;
  radRelease.Checked  := True;
  fraEvntDelayList.Visible := False;
  AdjustFormSize;
end;

procedure TfrmCopyOrders.fraEvntDelayListcboEvntListChange(
  Sender: TObject);
begin
  inherited;
  fraEvntDelayList.IsForCpXfer := True;
  fraEvntDelayList.mlstEventsChange(Sender);
  if fraEvntDelayList.MatchedCancel then Close
end;

procedure TfrmCopyOrders.fraEvntDelayListedtSearchChange(Sender: TObject); //rtw to next rtw
begin
  inherited;
  fraEvntDelayList.edtSearchChange(Sender);
end; //rtw

procedure TfrmCopyOrders.UMStillDelay(var message: TMessage);
begin
  CmdOKClick(Application);
end;

procedure TfrmCopyOrders.fraEvntDelayListmlstEventsDblClick(
  Sender: TObject);
begin
  inherited;
  if fraEvntDelayList.mlstEvents.ItemID > 0 then
    cmdOKClick(Self);
end;

procedure TfrmCopyOrders.fraEvntDelayListmlstEventsChange(Sender: TObject);
begin
  fraEvntDelayList.mlstEventsChange(Sender);
  if fraEvntDelayList.MatchedCancel then
  begin
    OKPressed := False;
    Close;
    Exit;
  end;
end;

procedure TfrmCopyOrders.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    cmdOKClick(Self);
end;

end.
