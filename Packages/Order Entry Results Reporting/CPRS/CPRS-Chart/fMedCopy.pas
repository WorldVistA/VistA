unit fMedCopy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORDtTm, ORCtrls, ORFn, rOrders, uCore, rCore, mEvntDelay, fAutoSz,
  ExtCtrls, UConst, fBase508Form, VA508AccessibilityManager;

type
  TfrmMedCopy = class(TfrmBase508Form)
    pnlTop: TPanel;
    lblPtInfo: TVA508StaticText;
    pnlInpatient: TPanel;
    lblInstruction: TStaticText;
    Image1: TImage;
    lblInstruction2: TStaticText;
    pnlMiddle: TPanel;
    gboxMain: TGroupBox;
    radDelayed: TRadioButton;
    radRelease: TRadioButton;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlBottom: TPanel;
    fraEvntDelayList: TfraEvntDelayList;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);                         
    procedure FormCreate(Sender: TObject);
    procedure radDelayedClick(Sender: TObject);
    procedure radReleaseClick(Sender: TObject);
    procedure fraEvntDelayListcboEvntListChange(Sender: TObject);
    procedure UMStillDelay(var message: TMessage); message UM_STILLDELAY;
    procedure fraEvntDelayListmlstEventsDblClick(Sender: TObject);
    procedure fraEvntDelayListmlstEventsChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    FDelayEvent: TOrderDelayEvent;
    FOKPressed: Boolean;
    procedure AdjustFormSize;
  public
    { Public declarations }
  end;

function SetDelayEventForMed(const RadCap: string; var ADelayEvent: TOrderDelayEvent;
          var IsNewEvent: Boolean; LimitEvent: Char): Boolean;
var
   frmMedCopy: TfrmMedCopy;

implementation
{$R *.DFM}

uses  fODBase, fOrdersTS, fOrders, VAUtils, uWriteAccess;

const
  TX_SEL_DATE = 'An effective date (approximate) must be selected for discharge orders.';
  TC_SEL_DATE = 'Missing Effective Date';

function SetDelayEventForMed(const RadCap: string; var ADelayEvent: TOrderDelayEvent;
          var IsNewEvent: Boolean; LimitEvent: Char): Boolean;
const
  TX_RELEASE1  = 'Release ';
  TX_RELEASE2  = ' orders immediately';
  TX_DELAYED1  = 'Delay release of ';
  TX_DELAYED2  = ' orders until';
var
  EvtInfo,PtEvtID,AnEvtDlg: string;
  SpeCap, CurrTS: string;

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

begin
  if LimitEvent = 'C' then
  begin
    Result := True;
    ADelayEvent.EventType := 'C';
    ADelayEvent.Specialty := 0;
    ADelayEvent.Effective := 0;
    Exit;
  end;
  Result := False;
  frmMedCopy := TfrmMedCopy.Create(Application);
  try
    if (LimitEvent = 'A') and (not Patient.Inpatient) then
    begin
      frmMedCopy.radDelayed.Checked := True;
      frmMedCopy.radRelease.Enabled := False;
    end;
    ResizeAnchoredFormToFont(frmMedCopy);
    frmMedCopy.AdjustFormSize;
    CurrTS := Piece(GetCurrentSpec(Patient.DFN),'^',1);
    if Length(CurrTS)>0 then
      SpeCap := #13 + '  The current treating specialty is ' + CurrTS
    else
      SpeCap := #13 + '  No treating specialty is available.';
    if Patient.Inpatient then
      frmMedCopy.lblPtInfo.Caption := '   ' + Patient.Name + ' is currently admitted to ' + Encounter.LocationName + SpeCap
    else
    begin
      if (Encounter.Location > 0) then
        frmMedCopy.lblPtInfo.Caption := Patient.Name + ' is currently at ' + Encounter.LocationName + SpeCap
      else
        frmMedCopy.lblPtInfo.Caption := Patient.Name + ' currently is an outpatient.' + SpeCap;
    end;
    frmMedCopy.AdjustFormSize;
    frmMedCopy.fraEvntDelayList.EvntLimit := LimitEvent;
    if Pos('transfer',RadCap)>0 then
      frmMedCopy.Caption := 'Transfer Medication Orders';
    frmMedCopy.radRelease.Caption := TX_RELEASE1 + RadCap + TX_RELEASE2;
    frmMedCopy.radDelayed.Caption := TX_DELAYED1 + RadCap + TX_DELAYED2;
    if LimitEvent='D' then
    begin
      frmMedCopy.pnlInpatient.Visible := False;
      frmMedCopy.AdjustFormSize;
    end;
    frmMedCopy.ShowModal;
    if (frmMedCopy.FOKPressed) and (frmMedCopy.radRelease.Checked) then
    begin
      if (frmMedCopy.radRelease.Checked) and (LimitEvent = 'D') then
        XfInToOutNow := True
      else XfInToOutNow := False;
      ADelayEvent := frmMedCopy.FDelayEvent;
      Result := True;
    end
    else if (frmMedCopy.FOKPressed) and (frmMedCopy.radDelayed.Checked) then
    begin
      EvtInfo := frmMedCopy.fraEvntDelayList.mlstEvents.Items[frmMedCopy.fraEvntDelayList.mlstEvents.ItemIndex];
      ADelayEvent.EventType := CharAt(Piece(EvtInfo,'^',3),1);
      ADelayEvent.EventIFN  := StrToInt64Def(Piece(EvtInfo,'^',1),0);
      if StrToInt64Def(Piece(EvtInfo,'^',13),0) > 0 then
      begin
        ADelayEvent.TheParent.Assign(Piece(EvtInfo,'^',13));
        ADelayEvent.EventType := ADelayEvent.TheParent.ParentType;
      end;
      ADelayEvent.EventName := frmMedCopy.fraEvntDelayList.mlstEvents.DisplayText[frmMedCopy.fraEvntDelayList.mlstEvents.ItemIndex];
      ADelayEvent.Specialty := 0;
      if frmMedCopy.fraEvntDelayList.orDateBox.Visible then
        ADelayEvent.Effective := frmMedCopy.fraEvntDelayList.orDateBox.FMDateTime
      else
        ADelayEvent.Effective := 0;
      IsNewEvent := False;
      if TypeOfExistedEvent(Patient.DFN,ADelayEvent.EventIFN) = 0 then
      begin
         IsNewEvent := True;
         if ADelayEvent.TheParent.ParentIFN > 0 then
         begin
           if StrToIntDef(ADelayEvent.TheParent.ParentDlg,0)>0 then
             AnEvtDlg := ADelayEvent.TheParent.ParentDlg;
         end
         else
           AnEvtDlg := Piece(EvtInfo,'^',5);
      end;
      if (StrToIntDef(AnEvtDlg,0)>0) and (IsNewEvent) then
         if not DisplayEvntDialog(AnEvtDlg, ADelayEvent) then
         begin
           frmOrders.lstSheets.ItemIndex := 0;
           frmOrders.lstSheetsClick(nil);
           Result := False;
           Exit;
         end;
      if not isExistedEvent(Patient.DFN, IntToStr(ADelayEvent.EventIFN), PtEvtID) then
      begin
        IsNewEvent := True;
        if (ADelayEvent.TheParent.ParentIFN > 0) and (TypeOfExistedEvent(Patient.DFN,ADelayEvent.EventIFN) = 0 ) then
          SaveEvtForOrder(Patient.DFN,ADelayEvent.TheParent.ParentIFN,'');
        SaveEvtForOrder(Patient.DFN,ADelayEvent.EventIFN,'');
        if isExistedEvent(Patient.DFN, IntToStr(ADelayEvent.EventIFN),PtEvtID) then
        begin
          Highlight(PtEvtID);
          ADelayEvent.IsNewEvent := False;
          ADelayEvent.PtEventIFN := StrToIntDef(PtEvtID,0);
        end;
      end else
      begin
        Highlight(PtEvtID);
        ADelayEvent.PtEventIFN := StrToIntDef(PtEvtID,0);
        ADelayEvent.IsNewEvent := False;
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
    frmMedCopy.fraEvntDelayList.ResetProperty;
    frmMedCopy.Release;
    frmMedCopy := nil;
  end;
end;

procedure TfrmMedCopy.FormCreate(Sender: TObject);
begin
  inherited;
  FOKPressed            := False;
  FDelayEvent.EventType := #0;
  FDelayEvent.EventIFN  := 0;
  radRelease.Checked := True;
  if not Patient.Inpatient then
    pnlInpatient.Visible := False;
  AdjustFormSize;
end;

procedure TfrmMedCopy.cmdOKClick(Sender: TObject);
var
  today : TFMDateTime;
begin
  inherited;
  today := FMToday;
  if (radDelayed.Checked) and (fraEvntDelayList.mlstEvents.ItemIndex < 0) then
  begin
    InfoBox('A release event must be selected.', 'No Selection Made', MB_OK);
    Exit;
  end;
  if (radRelease.Checked) and (Pos('copied',radRelease.Caption)>0)  then
  begin
    ImmdCopyAct := True;
    FDelayEvent.EventType := 'C';
    FDelayEvent.Specialty := 0;
    FDelayEvent.Effective := 0;
  end
  else if (radRelease.Checked) and (Pos('transfer',radRelease.Caption)>0) then
  begin
    FDelayEvent.EventType := 'D';
    FDelayEvent.Specialty := 0;
    FDelayEvent.Effective := today;
  end;
  FOKPressed := True;
  Close;
end;

procedure TfrmMedCopy.AdjustFormSize;
var
  y: integer;
begin
  y := lblPtInfo.Height + 8; // allow for font changes
  if pnlInpatient.Visible then
  begin
    lblInstruction2.top := lblInstruction.Height; // allow for font change
    pnlInpatient.Height := lblInstruction2.top + lblInstruction2.Height;
    inc(y,pnlInpatient.Height);
  end;
  pnlTop.Height := y;
  inc(y, pnlMiddle.Height);
  if fraEvntDelayList.Visible then
  begin
    inc(y, fraEvntDelayList.Height);
  end;
  VertScrollBar.Range := y;
  ClientHeight := y;
end;

procedure TfrmMedCopy.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmMedCopy.radDelayedClick(Sender: TObject);
const
  WarningMSG = 'If you''re writing medication orders to transfer these from Inpatient' +
    ' to Outpatient, please use the ''release immediately'' choice.  These will be' +
    ' readied in advance by Pharmacy for the patient''s expected discharge date.';
begin
  inherited;
    if not WriteAccess(waDelayedOrders, True) then
    begin
      radReleaseClick(radRelease);
      exit;
    end;
  frmMedCopy.fraEvntDelayList.UserDefaultEvent := StrToIntDef(GetDefaultEvt(IntToStr(User.DUZ)),0);
  fraEvntDelayList.DisplayEvntDelayList;
  if fraEvntDelayList.mlstEvents.Items.Count < 1 then
  begin
    ShowMsg(WarningMSG);
    radRelease.Checked := True;
  end else
  begin
    fraEvntDelayList.Visible := True;
  end;
  AdjustFormSize;
end;

procedure TfrmMedCopy.radReleaseClick(Sender: TObject);
begin
  inherited;
  fraEvntDelayList.Visible := False;
  AdjustFormSize;
end;

procedure TfrmMedCopy.fraEvntDelayListcboEvntListChange(Sender: TObject);
begin
  inherited;
  fraEvntDelayList.mlstEventsChange(Sender);
  if fraEvntDelayList.MatchedCancel then Close
end;

procedure TfrmMedCopy.UMStillDelay(var message: TMessage);
begin
  CmdOKClick(Application);
end;

procedure TfrmMedCopy.fraEvntDelayListmlstEventsDblClick(Sender: TObject);
begin
  if fraEvntDelayList.mlstEvents.ItemID > 0 then
    cmdOKClick(Self);
end;

procedure TfrmMedCopy.fraEvntDelayListmlstEventsChange(Sender: TObject);
begin
  fraEvntDelayList.mlstEventsChange(Sender);
  if fraEvntDelayList.MatchedCancel then
  begin
    FOKPressed := False;
    Close;
    Exit;
  end;
end;

procedure TfrmMedCopy.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    cmdOKClick(Self);
end;

end.
