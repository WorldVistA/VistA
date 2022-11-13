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
    procedure FormShow(Sender: TObject);
    procedure MemoEnter(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLastDFN: string;
  public
    procedure ClearIDInfo;
    procedure ShowDemog(ItemID: string);
    procedure ToggleMemo;
  end;

var
  frmPtSelDemog: TfrmPtSelDemog;

implementation

uses rCore, VA508AccessibilityRouter, uCombatVet, AVCatcher;

{$R *.DFM}

const
{ constants referencing the value of the tag property in components }
  TAG_HIDE     =  1;                             // labels to be hidden
  TAG_CLEAR    =  2;                             // labels to be cleared

procedure TfrmPtSelDemog.ClearIDInfo;
{ clears controls with patient ID info (controls have '2' in their Tag property }
var
  i, tryCount: Integer;
  Done: boolean;

begin
  FLastDFN := '';
  tryCount := 0;
  Done := False;
  repeat
    try
      with orapnlMain do
      begin
        for i := 0 to ControlCount - 1 do
        begin
          if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := False;
          if (Controls[i] is TStaticText) and (Controls[i].Tag = TAG_CLEAR) then
            TStaticText(Controls[i]).Caption := '';
        end;
      end;
      Memo.Clear;
      Done := True;
    except
      inc(tryCount);
      if tryCount >= 3 then
      begin
        ExceptionLog.TerminateApp := True;
        raise;
      end;
    end;
  until Done;
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

procedure TfrmPtSelDemog.FormDestroy(Sender: TObject);
begin
  frmPtSelDemog := nil;
  inherited;
end;

procedure TfrmPtSelDemog.FormResize(Sender: TObject);
begin
  inherited;
  FormShow(nil);
end;

procedure TfrmPtSelDemog.FormShow(Sender: TObject);
const
  Gap = 4;

var
  uHeight, y: integer;

  procedure Update(lbl1: TStaticText; lbl2: TStaticText = nil);
  begin
    lbl1.Height := uHeight;
    lbl1.Top := y;
    if assigned(lbl2) then
    begin
      lbl2.Height := uHeight;
      lbl2.Top := y;
      lbl1.Left := lbl2.Left + lbl2.Width + Gap;
    end;
    inc(y, uHeight + 2);
  end;

  procedure LineUp(lbl1, lbl2: TStaticText);
  begin
    if(lbl1.Left < lbl2.Left) then
      lbl1.Left := lbl2.Left
    else
      lbl2.Left := lbl1.Left;
  end;

begin
  inherited;
  lblCombatVet.Caption := '';
  uHeight := Canvas.TextHeight('Xy')+2;
  y := lblPtName.Top + uHeight;
  Update(lblPtSSN, lblSSN);
  Update(lblPtDOB, lblDOB);
  LineUp(lblPtSSN, lblPtDOB);
  Update(lblPtSex);
  Update(lblPtVet);
  Update(lblPtSC);
  Update(lblPtLocation, lblLocation);
  Update(lblPtRoomBed, lblRoomBed);
  LineUp(lblPtLocation, lblPtRoomBed);
  Update(lblCombatVet);
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
