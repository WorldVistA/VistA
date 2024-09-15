unit mPtSelDemog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, Vcl.ComCtrls;

const
  FROM_LABEL = ' @^@ ';

type
  TDemogRow = (drSSN, drDateOfBirth, drSexAge, drSIGI, drVeteran,
    drServiceConnected, drLocation, drRoomBed, drCombatVet, drProvider,
    drInpatientProvider, drAttending, drLastLocation, drLastVisited, drMemo);

  TfraPtSelDemog = class(TFrame)
    stxSSN: TStaticText;
    lblPtSSN: TStaticText;
    stxDOB: TStaticText;
    lblPtDOB: TStaticText;
    lblPtSex: TStaticText;
    lblPtVet: TStaticText;
    lblPtSC: TStaticText;
    stxLocation: TStaticText;
    lblPtRoomBed: TStaticText;
    lblPtLocation: TStaticText;
    stxRoomBed: TStaticText;
    Memo: TCaptionMemo;
    lblCombatVet: TStaticText;
    stxVeteran: TStaticText;
    stxSexAge: TStaticText;
    stxSC: TStaticText;
    stxSIGI: TStaticText;
    lblPtSigi: TStaticText;
    gPanel: TGridPanel;
    lblVeteran: TStaticText;
    stxPrimaryProvider: TStaticText;
    stxPtPrimaryProvider: TStaticText;
    stxInpatientProvider: TStaticText;
    stxPtInpatientProvider: TStaticText;
    stxLastVisitLocation: TStaticText;
    stxPtLastVisitLocation: TStaticText;
    stxLastVisitDate: TStaticText;
    stxPtLastVisitDate: TStaticText;
    lblPtName: TStaticText;
    stxAttending: TStaticText;
    stxPtAttending: TStaticText;
    procedure MemoEnter(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FrameResize(Sender: TObject);
  private
    FLastDFN: string;
    procedure UpdateLabel(dRow: TDemogRow; aText: string = FROM_LABEL);
    procedure UpdateGrid;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Redraw;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ClearIDInfo;
    procedure ShowDemog(ItemID: string);
    procedure ToggleMemo;
    function GetMinHeight: integer;
  end;

implementation

uses rCore, VA508AccessibilityRouter, uCombatVet, ORFn, uConst, AVCatcher;

{$R *.DFM}

const
  UNKNOWN      = 'Unknown'; // ...?';
  NO_PATIENT = 'No patient selected';
  drFirstLbl = Low(TDemogRow);
  drLastLbl = Pred(drMemo);
  LEFT_PAD = 6;
  TOP_PAD: array[Boolean] of integer = (1, 0); // Memo.Visible

type
  TLabelInfo = record
    Show: boolean;
    Height: integer;
  end;

var
  uLabelInfo: array[drFirstLbl .. drLastLbl] of TLabelInfo =
   { drSSN               } ((Show: True),
   { drDateOfBirth       }  (Show: True),
   { drSex               }  (Show: True),
   { drSIGI              }  (Show: False),
   { drVeteran           }  (Show: False),
   { drServiceConnected  }  (Show: False),
   { drLocation          }  (Show: False),
   { drRoomBed           }  (Show: False),
   { drCombatVet         }  (Show: False),
   { drProvider          }  (Show: False),
   { drInpatientProvider }  (Show: False),
   { drAttending         }  (Show: False),
   { drLastLocation      }  (Show: False),
   { drLastVisited       }  (Show: False));

procedure TfraPtSelDemog.UpdateLabel(dRow: TDemogRow; aText: string = FROM_LABEL);
var
  iWidth, iHeight, aRow: integer;
  ctrl: TControl;
  aName, aValue: TStaticText;
  CalcHeight, ShowLabel, Add2Memo: boolean;
  Text: string;

  function getTextHeight(aText: String; aWidth: Integer): Integer;
  var
    r: TRect;

  begin
    r := Rect(0, 0, aWidth, 15);
    Result := WrappedTextHeightByFont(Application.MainForm.Canvas, aValue.Font,
      aText, r);
  end;

begin
  aRow := ord(dRow);
  if (dRow < drFirstLbl) or (dRow > drLastLbl) then
    exit;
  ctrl := gPanel.ControlCollection.Controls[0, aRow];
  if ctrl is TStaticText then
    aName := ctrl as TStaticText
  else
    exit;
  ctrl := gPanel.ControlCollection.Controls[1, aRow];
  if ctrl is TStaticText then
    aValue := ctrl as TStaticText
  else
    exit;

  if aText = FROM_LABEL then
  begin
    aText := aValue.Caption;
    if aText = UNKNOWN then
      aText := '';
  end;
  if aText = '' then
    aValue.Caption := UNKNOWN
  else
    aValue.Caption := aText;
  Add2Memo := (aText <> '') and (FLastDFN <> '');
  CalcHeight := Add2Memo or uLabelInfo[dRow].Show;
  if Memo.Visible or (FLastDFN = '') then
    ShowLabel := False
  else
    ShowLabel := CalcHeight;
  aName.Visible := ShowLabel;
  aValue.Visible := ShowLabel;
  Text := aName.Caption + '  ' + aValue.Caption + '.';
  if Add2Memo then
    Memo.Lines.Add(Text);
  iHeight := 0;
  if CalcHeight then
  begin
    if Memo.Visible then
      iWidth := Memo.ClientWidth
    else
    begin
      iWidth := gPanel.Width - round(gPanel.ColumnCollection[0].Value);
      Text := aValue.Caption;
    end;
    iHeight := getTextHeight(Text, iWidth);
    uLabelInfo[dRow].Height := iHeight;
  end
  else
    uLabelInfo[dRow].Height := 0;
  if not ShowLabel then
    iHeight := 0;
  gPanel.RowCollection[aRow].Value := iHeight
end;

procedure TfraPtSelDemog.BeginUpdate;
begin
  LockDrawing;
  gPanel.BeginUpdate;
end;

procedure TfraPtSelDemog.ClearIDInfo;
{ clears controls with patient ID info (controls have '2' in their Tag property }
begin
  FLastDFN := '';
  lblPtName.Caption := NO_PATIENT;
  Redraw;
end;

procedure TfraPtSelDemog.ShowDemog(ItemID: string);
{ gets a record of patient indentifying information from the server and displays it }
var
  APtRec: TPtIDInfo;
  ACombatVet : TCombatVet;
  ADesc: string;
  ARow: TDemogRow;
begin
  if ItemID = FLastDFN then Exit;
  Memo.Clear;

  BeginUpdate;
  try
    FLastDFN := ItemID;
    APtRec := GetPtIDInfo(ItemID);
    lblPtName.Caption := APtRec.Name;
    Memo.Lines.Add(APtRec.Name);
    lblPtName.Caption := APtRec.Name;
    // doing this in For loop keeps memo and labels in the same order
    for aRow := drFirstLbl to drLastLbl do
    begin
      case aRow of
        drSSN: ADesc := APtRec.SSN;
        drDateOfBirth: ADesc := APtRec.DOB;
        drSexAge: ADesc := APtRec.Sex;
        drSIGI: ADesc := Piece(APtRec.SIGI, '/', 1);
        drVeteran:
          begin
            if APtRec.Vet = 'Veteran' then ADesc := 'Yes'
            else ADesc := '';
          end;
        drServiceConnected: ADesc := APtRec.SCSts;
        drLocation: ADesc := APtRec.Location;
        drRoomBed: ADesc := APtRec.RoomBed;
        drCombatVet:
          begin
            ACombatVet := TCombatVet.Create(ItemID);
            try
              if ACombatVet.IsEligible then
                  ADesc := ACombatVet.ExpirationDate + ' ' + ACombatVet.OEF_OIF
              else ADesc := '';
            finally
              FreeAndNil(ACombatVet);
            end;
          end;
        drProvider: ADesc := APtRec.PrimaryCareProvider;
        drInpatientProvider: ADesc := APtRec.PrimaryInpatientProvider;
        drAttending: ADesc := APtRec.Attending;
        drLastLocation: ADesc := APtRec.LastVisitLocation;
        drLastVisited: ADesc := APtRec.LastVisitDate;
      end;
      UpdateLabel(aRow, ADesc);
    end;
  finally
    EndUpdate;
  end;
  if ScreenReaderSystemActive then
  begin
    Memo.SelStart := 0;
    GetScreenReader.Speak('Selected Patient Demographics');
    GetScreenReader.Speak(Memo.Text);
  end;
end;

procedure TfraPtSelDemog.ToggleMemo;
{ toggle Memo visibility }
begin
  BeginUpdate;
  try
    if Memo.Visible then
      Memo.Hide
    else
      Memo.Show;
    Redraw;
  finally
    EndUpdate;
  end;
end;

procedure TfraPtSelDemog.UpdateGrid;
var
  dr: TDemogRow;
  w, len: integer;
  Canvas: TCanvas;
  ctrl: TControl;

begin
  Canvas := Application.MainForm.Canvas;
  w := 0;
  BeginUpdate;
  try
    lblPtName.Font.Size := Font.Size;
    for dr := drFirstLbl to drLastLbl do
    begin
      ctrl := gPanel.ControlCollection.Controls[0, ord(dr)];
      if ctrl is TStaticText then
      begin
        len := Canvas.TextWidth(TStaticText(ctrl).Caption);
        if w < len then
          w := len;
      end;
    end;
    inc(w, LEFT_PAD);
    gPanel.ColumnCollection[0].Value := w;
    Redraw;
  finally
    EndUpdate;
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
  stxSexAge.Hint := SIGI_HINTS[0];
  lblPtSex.Hint := SIGI_HINTS[0];
  stxSIGI.Hint := SIGI_HINTS[1];
  lblPtSIGI.Hint := SIGI_HINTS[1];
end;

procedure TfraPtSelDemog.EndUpdate;
begin
  gPanel.EndUpdate;
  UnlockDrawing;
end;

procedure TfraPtSelDemog.FrameResize(Sender: TObject);
begin
  if Visible and Showing then
    Redraw;
end;

function TfraPtSelDemog.GetMinHeight: integer;
var
  dr: TDemogRow;
  ht: integer;
  hide: boolean;

begin
  Result := lblPtName.Height;
  hide := Memo.Visible;
  if hide then
    Result := Result * 2;
  for dr := drFirstLbl to drLastLbl do
  begin
    ht := uLabelInfo[dr].Height;
    if ht > 0 then
      inc(Result, ht + TOP_PAD[hide]);
  end;
  if Result < 200 then
    Result := 200;
end;

procedure TfraPtSelDemog.MemoEnter(Sender: TObject);
{ reads the Memo contents if the Screenreader is active }
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
{ notifies on position in the Memo if the Screenreader is active }
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

procedure TfraPtSelDemog.Redraw;
var
  dr: TDemogRow;

begin
  BeginUpdate;
  try
    Memo.Clear;
    if lblPtName.Caption <> NO_PATIENT then
      Memo.Lines.Add(lblPtName.Caption);
    for dr := drFirstLbl to drLastLbl do
      UpdateLabel(dr);
  finally
    EndUpdate;
  end;
end;

end.
