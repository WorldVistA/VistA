unit fOptionsSurrogate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORDtTmRng, ORFn, ExtCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsSurrogate = class(TfrmBase508Form)
    lblSurrogate: TLabel;
    cboSurrogate: TORComboBox;
    btnSurrogateDateRange: TButton;
    dlgSurrogateDateRange: TORDateRangeDlg;
    lblSurrogateText: TStaticText;
    btnRemove: TButton;
    lblStart: TStaticText;
    lblStop: TStaticText;
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSurrogateDateRangeClick(Sender: TObject);
    procedure cboSurrogateNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure cboSurrogateChange(Sender: TObject);
    procedure cboSurrogateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure LabelInfo;
  public
    { Public declarations }
  end;

var
  frmOptionsSurrogate: TfrmOptionsSurrogate;

procedure DialogOptionsSurrogate(topvalue, leftvalue, fontsize: integer; var info: string);

implementation

uses rOptions, uOptions, rCore;

var
  Surrogate, TempSurrogate: TSurrogate;

{$R *.DFM}

procedure DialogOptionsSurrogate(topvalue, leftvalue, fontsize: integer; var info: string);
// create the form and make it modal
var
  frmOptionsSurrogate: TfrmOptionsSurrogate;
begin
  frmOptionsSurrogate := TfrmOptionsSurrogate.Create(Application);
  Surrogate := TSurrogate.Create;           // saved settings
  TempSurrogate := TSurrogate.Create;       // unsaved settings
 try
    with frmOptionsSurrogate do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsSurrogate);
      with Surrogate do
      begin
        IEN := StrToInt64Def(Piece(info, '^', 1), -1);
        Name := Piece(info, '^', 2);
        Start := MakeFMDateTime(Piece(info, '^', 3));
        Stop := MakeFMDateTime(Piece(info, '^', 4));
      end;
      with TempSurrogate do
      begin
        IEN := Surrogate.IEN;
        Name := Surrogate.Name;
        Start := Surrogate.Start;
        Stop := Surrogate.Stop;
      end;
      ShowModal;
      info := '';
      info := info + IntToStr(Surrogate.IEN) + '^';
      info := info + Surrogate.Name + '^';
      info := info + FloatToStr(Surrogate.Start) + '^';
      info := info + FloatToStr(Surrogate.Stop) + '^';
    end;
  finally
    frmOptionsSurrogate.Release;
    Surrogate.Free;
    TempSurrogate.Free;
  end;
end;

procedure TfrmOptionsSurrogate.FormShow(Sender: TObject);
begin
  cboSurrogate.InitLongList(Surrogate.Name);
  cboSurrogate.SelectByIEN(Surrogate.IEN);
  LabelInfo;
end;

procedure TfrmOptionsSurrogate.btnSurrogateDateRangeClick(Sender: TObject);
var
  TempFMDate: TFMDateTime;
  ok : boolean;
begin
  ok := false;
  with dlgSurrogateDateRange do
  while not ok do
  begin
    RequireTime := true;              //cq 18349 PSPO 1225
    FMDateStart := TempSurrogate.Start;
    FMDateStop := TempSurrogate.Stop;
    if Execute then
    begin
      If (FMDateStop <> 0) and (FMDateStart > FMDateStop) then
      begin
        TempFMDate := FMDateStart;
        FMDateStart := FMDateStop;
        FMDateStop := TempFMDate;
      end;
      with TempSurrogate do
      begin
        Start := FMDateStart;
        Stop := FMDateStop;
        LabelInfo;
        if (Stop <> 0) and (Stop < DateTimeToFMDateTime(Now)) then
        begin
          beep;
          InfoBox('Stop Date must be in the future.', 'Warning', MB_OK or MB_ICONWARNING);
          Stop := 0;
        end
        else
          ok := true;
      end;
    end
    else
      ok := true;
  end;
end;

procedure TfrmOptionsSurrogate.cboSurrogateNeedData(
  Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboSurrogate.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmOptionsSurrogate.btnOKClick(Sender: TObject);
var
  info, msg: string;
  ok: boolean;
begin
  //rpcCheckSurrogate(TempSurrogate.IEN, ok, msg);   chack is now in rpcSetSurrogateInfo (v27.29 - RV)
  ok := TRUE;
  info := '';
  info := info + IntToStr(TempSurrogate.IEN) + '^';
  info := info + FloatToStr(TempSurrogate.Start) + '^';
  info := info + FloatToStr(TempSurrogate.Stop) + '^';
  rpcSetSurrogateInfo(info, ok, msg);
  if not ok then
  begin
    beep;
    InfoBox(msg, 'Warning', MB_OK or MB_ICONWARNING);
    with cboSurrogate do ItemIndex := SetExactByIEN(Surrogate.IEN, Surrogate.Name);
    cboSurrogateChange(Self);
    ModalResult := mrNone;
  end
  else
  begin
    with Surrogate do
    begin
      IEN := TempSurrogate.IEN;
      Name := TempSurrogate.Name;
      Start := TempSurrogate.Start;
      Stop := TempSurrogate.Stop;
    end;
    ModalResult := mrOK;
  end;
end;

procedure TfrmOptionsSurrogate.btnRemoveClick(Sender: TObject);
begin
  cboSurrogate.ItemIndex := -1;
  cboSurrogate.Text := '';
  with TempSurrogate do
  begin
    IEN := -1;
    Name := '';
    Start := 0;
    Stop := 0;
  end;
  LabelInfo;
end;

procedure TfrmOptionsSurrogate.LabelInfo;
begin
  with TempSurrogate do
  begin
    btnRemove.Enabled := length(Name) > 0;
    btnSurrogateDateRange.Enabled := length(Name) > 0;
    if length(Name) > 0 then
      lblSurrogateText.Caption := Name
    else
    begin
      lblSurrogateText.Caption := '<no surrogate designated>';
      Start := 0;
      Stop := 0;
    end;
    if Start > 0 then
      lblStart.Caption := 'from: ' + FormatFMDateTime('dddddd@hh:nn', Start)
    else
      lblStart.Caption := 'from: <now>';
    if Stop > 0 then
      lblStop.Caption := 'until: ' + FormatFMDateTime('dddddd@hh:nn', Stop)
    else
      lblStop.Caption := 'until: <changed>';
  end;
end;

procedure TfrmOptionsSurrogate.cboSurrogateChange(Sender: TObject);
begin
  with cboSurrogate do
  if (ItemIndex = -1) or (Text = '') then
  begin
    TempSurrogate.IEN := -1;
    TempSurrogate.Name := '';
    ItemIndex := -1;
    Text := '';
  end
  else
  begin
    TempSurrogate.IEN := ItemIEN;
    TempSurrogate.Name := DisplayText[cboSurrogate.ItemIndex];
  end;
  LabelInfo;
end;

procedure TfrmOptionsSurrogate.cboSurrogateKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if cboSurrogate.ItemIndex = -1 then       // allow typing to do change event
    Application.ProcessMessages;
end;

end.
