unit fOrdersTS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORCtrls, ORFn, ExtCtrls, rOrders, ORDtTm, mEvntDelay,uConst,
  VA508AccessibilityManager;

type
  TfrmOrdersTS = class(TfrmAutoSz)
    pnlMiddle: TPanel;
    pnlTop: TPanel;
    lblPtInfo: TVA508StaticText;
    radReleaseNow: TRadioButton;
    radDelayed: TRadioButton;
    pnldif: TPanel;
    Image1: TImage;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblUseAdmit: TVA508StaticText;
    lblUseTransfer: TVA508StaticText;
    pnlBottom: TPanel;
    fraEvntDelayList: TfraEvntDelayList;
    pnlButtons: TPanel;
    sbxReleaseEvent: TScrollBox;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure radDelayedClick(Sender: TObject);
    procedure radReleaseNowClick(Sender: TObject);
    procedure fraEvntDelayListcboEvntListChange(Sender: TObject);
    procedure UMStillDelay(var message: TMessage); message UM_STILLDELAY;
    procedure fraEvntDelayListmlstEventsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fraEvntDelayListmlstEventsChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    FIsReleaseEventSelected: Boolean;
    OKPressed: Boolean;
    FResult  : Boolean;
    FImmediatelyRelease: boolean;
    FCurrSpecialty: string;
    F1stClick: Boolean;
  end;

function ShowDelayedEventsTreatingSepecialty(const ARadCaption: string; var AnEvent: TOrderDelayEvent;
 var ADlgLst: TStringlist; var ReleaseNow: boolean; AnLimitEvent: Char = #0): Boolean;

var
  frmOrdersTS: TfrmOrdersTS;

implementation

uses ucore,fOrders, rMisc;

{$R *.DFM}

const
  TX_TRANSFER1= 'You selected the Transfer delayed event';
  TX_TRANSFER = 'The release of orders entered ' +
                'will be delayed until the patient is transferred to the ' +
                'following specialty.';
  TX_ADMIT1   = 'You selected the Admit delayed event';
  TX_ADMIT    = 'The release of orders entered ' +
                'will be delayed until the patient is admitted to the ' +
                'following specialty.';
  TX_XISTEVT1 = 'Delayed orders already exist for event Delayed ';
  TX_XISTEVT2 = #13 + 'Do you want to view those orders?';
  TX_MCHEVT1  = ' is already assigned to ';
  TX_MCHEVT2  = #13 + 'Do you still want to write delayed orders?';


function ShowDelayedEventsTreatingSepecialty(const ARadCaption: string; var AnEvent: TOrderDelayEvent;
 var ADlgLst: TStringlist; var ReleaseNow: boolean; AnLimitEvent: Char = #0): Boolean;
var
  EvtInfo,speCap: string;
begin
  frmOrdersTS := TfrmOrdersTS.Create(Application);
  frmOrdersTS.FCurrSpecialty := Piece(GetCurrentSpec(Patient.DFN),'^',1);
  frmOrdersTS.fraEvntDelayList.UserDefaultEvent := StrToIntDef(GetDefaultEvt(IntToStr(User.DUZ)),0);
  SetFormPosition(frmOrdersTS);
  //frmOrdersTs.fraEvntDelayList.Top := frmOrdersTS.Height -
  Result := frmOrdersTS.FResult;
  if Length(ARadCapTion)>0 then
    frmOrdersTS.radDelayed.Caption := ARadCaption;
  try
    ResizeFormToFont(TForm(frmOrdersTS));
    if Length(frmOrdersTS.FCurrSpecialty)>0 then
      SpeCap := #13 + 'The current treating specialty is ' + frmOrdersTS.FCurrSpecialty
    else
      SpeCap := #13 + 'No treating specialty is available.';
    if Patient.Inpatient then
      frmOrdersTS.lblPtInfo.Caption := Patient.Name + ' is currently admitted to ' + Encounter.LocationName + SpeCap
    else
    begin
      if (EnCounter.Location > 0) then
        frmOrdersTS.lblPtInfo.Caption := Patient.Name + ' is currently on ' + Encounter.LocationName + SpeCap
      else
        frmOrdersTS.lblPtInfo.Caption := Patient.Name + ' currently is an outpatient.' + SpeCap;
    end;
    if not CharInSet(AnLimitEvent, ['A','D','T','M','O']) then
      AnLimitEvent := #0;
    frmOrdersTs.fraEvntDelayList.EvntLimit := AnLimitEvent;
    if AnEvent.EventIFN > 0 then
    begin
      frmOrdersTS.fraEvntDelayList.DefaultEvent := AnEvent.EventIFN;
      frmOrdersTS.radDelayed.Checked := True;
    end else
    begin
      frmOrdersTS.radReleaseNow.Enabled := True;
      frmOrdersTS.radReleaseNow.Checked := False;
      frmOrdersTS.radDelayed.Checked    := False;
    end;
    frmOrdersTS.radDelayed.Checked := True;
    frmOrdersTS.ShowModal;
    if frmOrdersTS.FImmediatelyRelease then
    begin
      AnEvent.EventIFN  := 0;
      AnEvent.EventName := '';
      AnEvent.Specialty := 0;
      AnEvent.Effective := 0;
      ReleaseNow := frmOrdersTS.FImmediatelyRelease;
      Result := frmOrdersTS.FResult;
    end;
    if (frmOrdersTS.OKPressed) and (frmOrdersTS.radDelayed.Checked) then
    begin
      EvtInfo := frmOrdersTS.fraEvntDelayList.mlstEvents.Items[frmOrdersTS.fraEvntDelayList.mlstEvents.ItemIndex];
      AnEvent.EventType := CharAt(Piece(EvtInfo,'^',3),1);
      AnEvent.EventIFN  := StrToInt64Def(Piece(EvtInfo,'^',1),0);
      AnEvent.TheParent := TParentEvent.Create(0);
      if StrToInt64Def(Piece(EvtInfo,'^',13),0) > 0 then
      begin
        AnEvent.TheParent.Assign(Piece(EvtInfo,'^',13));
        if AnEvent.EventType = #0 then
          AnEvent.EventType := AnEvent.TheParent.ParentType;
      end;
      AnEvent.EventName := frmOrdersTS.fraEvntDelayList.mlstEvents.DisplayText[frmOrdersTS.fraEvntDelayList.mlstEvents.ItemIndex];
      AnEvent.Specialty := 0;
      if frmOrdersTS.fraEvntDelayList.orDateBox.Visible then
        AnEvent.Effective := frmOrdersTS.fraEvntDelayList.orDateBox.FMDateTime
      else
        AnEvent.Effective := 0;
      ADlgLst.Clear;
      if StrToIntDef(AnEvent.TheParent.ParentDlg,0)>0 then
        ADlgLst.Add(AnEvent.TheParent.ParentDlg)
      else if Length(Piece(EvtInfo,'^',5))>0 then
        ADlgLst.Add(Piece(EvtInfo,'^',5));
      if Length(Piece(EvtInfo,'^',6))>0 then
        ADlgLst.Add(Piece(EvtInfo,'^',6)+ '^SET');
      Result := frmOrdersTS.FResult;
    end;
  finally
    frmOrdersTS.FImmediatelyRelease := False;
    frmOrdersTS.FCurrSpecialty := '';
    frmOrdersTS.fraEvntDelayList.ResetProperty;
    frmOrdersTS.Release;
    frmOrdersTS := nil;
  end;
end;

procedure TfrmOrdersTS.FormCreate(Sender: TObject);
begin
  inherited;
  if not Patient.Inpatient then
    pnldif.Visible  := False;
  OKPressed           := False;
  FResult             := False;
  FImmediatelyRelease := False;
  F1stClick           := True;
  FCurrSpecialty      := '';
  AutoSizeDisabled := true;
end;


{=========================================================================================}
{  RetrieveValueFromIndex - Acts like old ValueFromIndex                                  }
{-----------------------------------------------------------------------------------------}
{  XE3 changed the Value From Index to include calculating with the delimiter character.  }
{  This routine uses the old method for calculating ValueFromIndex from D2006             }
{=========================================================================================}
function RetrieveValueFromIndex(s: TStrings; Index: integer): string;
begin
  if Index >= 0 then
  Result := Copy(s[Index], Length(s.Names[Index]) + 2, MaxInt) else
  Result := '';
end;

procedure TfrmOrdersTS.cmdOKClick(Sender: TObject);
var
  tempStr: String;

begin
  inherited;
  if not FIsReleaseEventSelected then
  begin
    InfoBox('A release event has not been selected.', 'No Selection Made', MB_OK);
    Exit;
  end;
  if( not (fraEvntDelayList.mlstEvents.ItemIndex >= 0) ) and (radDelayed.Checked) then
  begin
    InfoBox('A release event must be selected.', 'No Selection Made', MB_OK);
    Exit;
  end;

 // tempStr := fraEvntDelayList.mlstEvents.Items.ValueFromIndex[fraEvntDelayList.mlstEvents.ItemIndex];
  tempStr := RetrieveValueFromIndex(fraEvntDelayList.mlstEvents.Items, fraEvntDelayList.mlstEvents.ItemIndex);  // CQ 21556

  if(fraEvntDelayList.mlstEvents.ItemIndex >= 0) and (Length(Piece(tempStr,'^',2))<1)then
  begin
    InfoBox('Invalid release event selected.', 'No Selection Made', MB_OK);
    Exit;
  end;

  if (fraEvntDelayList.mlstEvents.ItemIndex >= 0) and F1stClick then
  begin
    fraEvntDelayList.CheckMatch;
    if fraEvntDelayList.MatchedCancel then
    begin
      OKPressed := False;
      Close;
      Exit;
    end;
  end;
  OKPressed := True;
  FResult   := True;
  Close;
end;

procedure TfrmOrdersTS.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FResult  := False;
  Close;
end;

procedure TfrmOrdersTS.radDelayedClick(Sender: TObject);
begin
  inherited;
  fraEvntDelayList.Visible := True;
  fraEvntDelayList.DisplayEvntDelayList;
  FIsReleaseEventSelected := True;
end;

procedure TfrmOrdersTS.radReleaseNowClick(Sender: TObject);
begin
  inherited;
  FIsReleaseEventSelected := True;
  if InfoBox('Would you like to close this window and return to the Orders Tab?',
        'Confirmation', MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
  begin
    FImmediatelyRelease := True;
    FResult             := False;
    Close;
  end
  else
  begin
    fraEvntDelayList.mlstEvents.Items.Clear;
    FImmediatelyRelease   := False;
    radReleaseNow.Checked := False;
    radDelayed.Checked    := True;
  end;
end;

procedure TfrmOrdersTS.fraEvntDelayListcboEvntListChange(Sender: TObject);
begin
  inherited;
  fraEvntDelayList.mlstEventsChange(Sender);
  F1stClick   := False;
  if fraEvntDelayList.MatchedCancel then  Close
end;

procedure TfrmOrdersTS.UMStillDelay(var message: TMessage);
begin
  inherited;
  if not FIsReleaseEventSelected then
  begin
    InfoBox('A release event has not been selected.', 'No Selection Made', MB_OK);
    Exit;
  end;
  if(not (fraEvntDelayList.mlstEvents.ItemIndex >= 0)) and (radDelayed.Checked) then
  begin
    InfoBox('A release event must be selected.', 'No Selection Made', MB_OK);
    Exit;
  end;
  OKPressed := True;
  FResult   := True;
  Close;
end;

procedure TfrmOrdersTS.fraEvntDelayListmlstEventsDblClick(Sender: TObject);
begin
  inherited;
  if fraEvntDelayList.mlstEvents.ItemID > 0 then
    cmdOKClick(Self);
end;

procedure TfrmOrdersTS.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
  Action := caFree;
end;

procedure TfrmOrdersTS.fraEvntDelayListmlstEventsChange(Sender: TObject);
begin
  inherited;
  fraEvntDelayList.mlstEventsChange(Sender);
  if fraEvntDelayList.MatchedCancel then
  begin
    OKPressed := False;
    Close;
    Exit;
  end;
end;

procedure TfrmOrdersTS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
     cmdOKClick(Self);
end;

procedure TfrmOrdersTS.FormResize(Sender: TObject);
begin
 // inherited;

end;

end.
