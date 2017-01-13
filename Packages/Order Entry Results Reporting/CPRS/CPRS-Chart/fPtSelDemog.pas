unit fPtSelDemog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPtSelDemog = class(TfrmBase508Form)
    orapnlMain: TORAutoPanel;
    lblSSN: TStaticText;
    lblPtSSN: TStaticText;
    lblDOB: TStaticText;
    lblPtDOB: TStaticText;
    lblPtSex: TStaticText;
    lblPtVet: TStaticText;
    lblPtSC: TStaticText;
    lblLocation: TStaticText;
    lblPtRoomBed: TStaticText;
    lblPtLocation: TStaticText;
    lblRoomBed: TStaticText;
    lblPtName: TStaticText;
    Memo: TCaptionMemo;
    lblCombatVet: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoEnter(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FLastDFN: string;
    FOldWinProc :TWndMethod;
    procedure NewWinProc(var Message: TMessage);
  public
    procedure ClearIDInfo;
    procedure ShowDemog(ItemID: string);
    procedure ToggleMemo;
  end;

var
  frmPtSelDemog: TfrmPtSelDemog;

implementation

uses rCore, VA508AccessibilityRouter, uCombatVet;

{$R *.DFM}

const
{ constants referencing the value of the tag property in components }
  TAG_HIDE     =  1;                             // labels to be hidden
  TAG_CLEAR    =  2;                             // labels to be cleared

procedure TfrmPtSelDemog.ClearIDInfo;
{ clears controls with patient ID info (controls have '2' in their Tag property }
var
  i: Integer;
begin
  FLastDFN := '';
  with orapnlMain do
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := False;
    if Controls[i].Tag = TAG_CLEAR then with Controls[i] as TStaticText do Caption := '';
  end;
  Memo.Clear;
end;

procedure TfrmPtSelDemog.ShowDemog(ItemID: string);
{ gets a record of patient indentifying information from the server and displays it }
var
  PtRec: TPtIDInfo;
  i: Integer;
  CV : TCombatVet;
begin
  if ItemID = FLastDFN then Exit;
  Memo.Clear;
  FLastDFN := ItemID;
  PtRec := GetPtIDInfo(ItemID);
  with PtRec do
  begin
    Memo.Lines.Add(Name);
    Memo.Lines.Add(lblSSN.Caption + ' ' + SSN + '.');
    Memo.Lines.Add(lblDOB.Caption + ' ' + DOB + '.');
    if Sex <> '' then
      Memo.Lines.Add(Sex + '.');
    if Vet <> '' then
      Memo.Lines.Add(Vet + '.');
    if SCsts <> '' then
      Memo.Lines.Add(SCsts + '.');
    if Location <> '' then
      Memo.Lines.Add(lblLocation.Caption + ' ' + Location + '.');
    if RoomBed <> '' then
      Memo.Lines.Add(lblRoomBed.Caption + ' ' + RoomBed + '.');

    lblPtName.Caption     := Name;
    lblPtSSN.Caption      := SSN;
    lblPtDOB.Caption      := DOB;
    lblPtSex.Caption      := Sex {+ ', age ' + Age};
    lblPtSC.Caption       := SCSts;
    lblPtVet.Caption      := Vet;
    lblPtLocation.Caption := Location;
    lblPtRoomBed.Caption  := RoomBed;
  end;
  with orapnlMain do for i := 0 to ControlCount - 1 do
    if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := True;
  if lblPtLocation.Caption = '' then
    lblLocation.Hide
  else
    lblLocation.Show;
  if lblPtRoomBed.Caption = ''  then
    lblRoomBed.Hide
  else
    lblRoomBed.Show;
  CV := TCombatVet.Create(ItemID);
  if CV.IsEligible then begin
    lblCombatVet.Caption := 'CV ' + CV.ExpirationDate + ' ' + CV.OEF_OIF;
    Memo.Lines.Add(lblCombatVet.Caption);
  end else
    lblCombatVet.Caption := '';
  CV.Free;
 // Memo.SelectAll;
  if ScreenReaderSystemActive then
  begin
    Memo.SelStart := 0;
    GetScreenReader.Speak('Selected Patient Demographics');
    GetScreenReader.Speak(Memo.Text);
  end;
end;

procedure TfrmPtSelDemog.ToggleMemo;
begin
  if Memo.Visible then
  begin
    Memo.Hide;
  end
  else
  begin
    Memo.Show;
    Memo.BringToFront;
  end;
end;

procedure TfrmPtSelDemog.FormCreate(Sender: TObject);
begin
  FOldWinProc := orapnlMain.WindowProc;
  orapnlMain.WindowProc := NewWinProc;
end;

procedure TfrmPtSelDemog.NewWinProc(var Message: TMessage);
const
  Gap = 4;
  MaxFont = 10;
  var uHeight:integer;


begin
  if(assigned(FOldWinProc)) then FOldWinProc(Message);
  if(Message.Msg = WM_Size) then
  begin
    if(lblPtSSN.Left < (lblSSN.Left+lblSSN.Width+Gap)) then
      lblPtSSN.Left := (lblSSN.Left+lblSSN.Width+Gap);
    if(lblPtDOB.Left < (lblDOB.Left+lblDOB.Width+Gap)) then
      lblPtDOB.Left := (lblDOB.Left+lblDOB.Width+Gap);
    if(lblPtSSN.Left < lblPtDOB.Left) then
      lblPtSSN.Left := lblPtDOB.Left
    else
      lblPtDOB.Left := lblPtSSN.Left;

    if(lblPtLocation.Left < (lblLocation.Left+lblLocation.Width+Gap)) then
      lblPtLocation.Left := (lblLocation.Left+lblLocation.Width+Gap);
    if(lblPtRoomBed.Left < (lblRoomBed.Left+lblRoomBed.Width+Gap)) then
      lblPtRoomBed.Left := (lblRoomBed.Left+lblRoomBed.Width+Gap);
    if(lblPtLocation.Left < lblPtRoomBed.Left) then
      lblPtLocation.Left := lblPtRoomBed.Left
    else
      lblPtRoomBed.Left := lblPtLocation.Left;
  end;
  if frmPtSelDemog.Canvas.Font.Size > MaxFont then
  begin
    uHeight         := frmPtSelDemog.Canvas.TextHeight(lblPtSSN.Caption)-2;
    lblPtSSN.Top    := (lblPtName.Top + uHeight);
    lblSSN.Top      := lblPtSSN.Top;
    lblPtDOB.Height := uHeight;
    lblPtDOB.Top    := (lblPtSSn.Top + uHeight);
    lblDOB.Top      := lblPtDOB.Top;
    lblPtSex.Height :=  uHeight;
    lblPtSex.Top    := (lblPtDOB.Top + uHeight);
    lblPtVet.Height :=  uHeight;
    lblPtVet.Top    := (lblPtSex.Top + uHeight);
    lblPtSC.Height  := uHeight;
    lblPtSC.Top     :=  lblPtVet.Top;
    lblLocation.Height := uHeight;
    lblLocation.Top := ( lblPtVet.Top + uHeight);
    lblPtLocation.Top := lblLocation.Top;
    lblRoomBed.Height := uHeight;
    lblRoomBed.Top    :=(lblLocation.Top + uHeight)+ 2;
    lblPtRoomBed.Height := uHeight;
    lblPtRoomBed.Top  := lblRoomBed.Top ;
    lblCombatVet.Top := (lblRoomBed.Top + uHeight) + 2;
  end;
end;

procedure TfrmPtSelDemog.FormDestroy(Sender: TObject);
begin
  orapnlMain.WindowProc := FOldWinProc;
end;

procedure TfrmPtSelDemog.FormShow(Sender: TObject);
begin
  inherited;
  lblCombatVet.Caption := '';
end;

procedure TfrmPtSelDemog.MemoEnter(Sender: TObject);
begin
  inherited;
  if ScreenReaderSystemActive then
  begin
    Memo.SelStart := 0;
    GetScreenReader.Speak('Selected Patient Demographics');
    GetScreenReader.Speak(Memo.Text);
  end;
end;

procedure TfrmPtSelDemog.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if ScreenReaderSystemActive then
  begin
    if Memo.SelStart = Memo.GetTextLen then
      if ((Key = VK_DOWN) or (Key = VK_RIGHT)) then GetScreenReader.Speak('End of Data');
    if Memo.SelStart = 0 then
      if ((Key = VK_UP) or (Key = VK_LEFT)) then GetScreenReader.Speak('Start of Data')
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPtSelDemog);

end.
