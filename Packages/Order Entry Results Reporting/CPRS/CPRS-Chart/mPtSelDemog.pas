unit mPtSelDemog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ORCtrls, ORFn;

type
  TfraPtSelDemog = class(TFrame)
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
    gpMain: TGridPanel;
    procedure MemoEnter(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FLastDFN: string;
    fRowHeight: integer;
    procedure UpdateGrid;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ClearIDInfo;
    procedure ShowDemog(ItemID: string);
    procedure ToggleMemo;
  end;

implementation

uses rCore, VA508AccessibilityRouter, uCombatVet, AVCatcher;

{$R *.DFM}

const
{ constants referencing the value of the tag property in components }
  TAG_HIDE     =  1;                             // labels to be hidden
  TAG_CLEAR    =  2;                             // labels to be cleared

procedure TfraPtSelDemog.ClearIDInfo;
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
      with gpMain do
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

procedure TfraPtSelDemog.ShowDemog(ItemID: string);
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
  with gpMain do for i := 0 to ControlCount - 1 do
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
  try
    if CV.IsEligible then begin
      lblCombatVet.Caption := 'CV ' + CV.ExpirationDate + ' ' + CV.OEF_OIF;
      Memo.Lines.Add(lblCombatVet.Caption);
    end else
      lblCombatVet.Caption := '';
  finally
    CV.Free;
  end;
 // Memo.SelectAll;
  if ScreenReaderSystemActive then
  begin
    Memo.SelStart := 0;
    GetScreenReader.Speak('Selected Patient Demographics');
    GetScreenReader.Speak(Memo.Text);
  end;
end;

procedure TfraPtSelDemog.ToggleMemo;
var
  i, h: integer;

begin
  if Memo.Visible then
  begin
    Memo.Hide;
    h := fRowHeight;
  end
  else
  begin
    Memo.Show;
    h := 0;
  end;
  gpMain.RowCollection.BeginUpdate;
  try
    for i := 0 to gpMain.RowCollection.Count - 2 do
      gpMain.RowCollection[i].Value := h;
  finally
    gpMain.RowCollection.EndUpdate;
  end;
end;

procedure TfraPtSelDemog.UpdateGrid;
var
  lblList: array [0..1] of array [0..1] of TStaticText;
  i, j, len: integer;
  w: array[0..1] of integer;

begin
  lblList[0, 0] := lblSSN;
  lblList[0, 1] := lblDOB;
  lblList[1, 0] := lblLocation;
  lblList[1, 1] := lblRoomBed;
  for i := 0 to 1 do
  begin
    w[i] := 0;
    for j := 0 to 1 do
    begin
      len := TextWidthByFont(Font.Handle, lblList[i, j].Caption);
      if w[i] < len then
        w[i] := len;
    end;
    inc(w[i], 4);
  end;
  lblPtName.Font.Size := Font.Size;
  gpMain.ColumnCollection.BeginUpdate;
  try
    gpMain.ColumnCollection[0].Value := w[0];
    gpMain.ColumnCollection[1].Value := w[1] - w[0];
  finally
    gpMain.ColumnCollection.EndUpdate;
  end;

  FRowHeight := TextHeightByFont(Font.Handle, 'TpWyg') + 4;
  gpMain.RowCollection.BeginUpdate;
  try
    for i := 0 to gpMain.RowCollection.Count - 2 do
      if gpMain.RowCollection[i].Value > 0 then
        gpMain.RowCollection[i].Value := FRowHeight;
  finally
    gpMain.RowCollection.EndUpdate;
  end;
end;

procedure TfraPtSelDemog.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateGrid;
end;

constructor TfraPtSelDemog.Create(AOwner: TComponent);
begin
  inherited;
  UpdateGrid;
end;

procedure TfraPtSelDemog.MemoEnter(Sender: TObject);
begin
  inherited;
  if ScreenReaderSystemActive then
  begin
    Memo.SelStart := 0;
    GetScreenReader.Speak('Selected Patient Demographics');
    GetScreenReader.Speak(Memo.Text);
  end;
end;

procedure TfraPtSelDemog.MemoKeyDown(Sender: TObject; var Key: Word;
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


end.