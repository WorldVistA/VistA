unit fGAF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, Buttons, ExtCtrls, Grids, ORFn, ORNet, ORCtrls,
  ORDtTm, ComCtrls, fPCEBaseGrid, Menus, VA508AccessibilityManager;

type
  TfrmGAF = class(TfrmPCEBaseGrid)
    lblGAF: TStaticText;
    edtScore: TCaptionEdit;
    udScore: TUpDown;
    dteGAF: TORDateBox;
    lblEntry: TStaticText;
    lblScore: TLabel;
    lblDate: TLabel;
    lblDeterminedBy: TLabel;
    cboGAFProvider: TORComboBox;
    btnURL: TButton;
    Spacer1: TLabel;
    Spacer2: TLabel;
    procedure cboGAFProviderNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure edtScoreChange(Sender: TObject);
    procedure dteGAFExit(Sender: TObject);
    procedure cboGAFProviderExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnURLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataLoaded: boolean;
    procedure LoadScores;
    function BADData(ShowMessage: boolean): boolean;
  public
    procedure AllowTabChange(var AllowChange: boolean); override;
    procedure GetGAFScore(var Score: integer; var Date: TFMDateTime; var Staff: Int64);
    function CheckSimilarNameOK: Boolean;
  end;

function ValidGAFData(Score: integer; Date: TFMDateTime; Staff: Int64): boolean;

var
  frmGAF: TfrmGAF;

implementation

uses rPCE, rCore, uCore, uPCE, fEncounterFrame, VA508AccessibilityRouter,
  uORLists, uSimilarNames;

{$R *.DFM}

function ValidGAFData(Score: integer; Date: TFMDateTime; Staff: Int64): boolean;
begin
  if(Score < 1) or (Score > 100) or (Date <= 0) or (Staff = 0) then
    Result := FALSE
  else
    Result := ((Patient.DateDied <= 0) or (Date <= Patient.DateDied));
end;

procedure TfrmGAF.LoadScores;
var
  i: Integer;
  tmp: string;
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
    RecentGafScores(sl, 3);
    if (sl.Count > 0) and (sl[0] = '[DATA]') then
    begin
      for i := 1 to sl.Count - 1 do
      begin
        tmp := sl[i];
        lstCaptionList.Add(Piece(tmp, U, 5) + U + Piece(Piece(tmp, U, 2),
          NoPCEValue, 1) + U + Piece(tmp, U, 7) + U + Piece(tmp, U, 8));
      end;
    end;
    if lstCaptionList.Items.Count = 0 then
      lstCaptionList.Add('No GAF scores found.');
  finally
    sl.Free;
  end;
end;

procedure TfrmGAF.cboGAFProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList(cboGAFProvider,StartFrom, Direction);
end;

function TfrmGAF.BADData(ShowMessage: boolean): boolean;
var
  PName, msg: string;
  GAFDate: TFMDateTime;
  UIEN: Int64;

begin
  GAFDate := dteGAF.FMDateTime;
  msg := ValidateGAFDate(GAFDate);
  if(dteGAF.FMDateTime <> GAFDate) then
    dteGAF.FMDateTime := GAFDate;

  if(cboGAFProvider.ItemID = '') then
  begin
    if(msg <> '') then
      msg := msg + CRLF;
    msg := msg + 'A determining party is required to enter a GAF score.';
    UIEN := uProviders.PCEProvider;
    if(UIEN <> 0) then
    begin
      PName := uProviders.PCEProviderName;
      msg := msg + '  Determined By changed to ' + PName + '.';
      cboGAFProvider.SetExactByIEN(UIEN, PName);
      TSimilarNames.RegORComboBox(cboGAFProvider);
    end;
  end;

  if(ShowMessage and (msg <> '')) then
    InfoBox(msg, 'Invalid GAF Data', MB_OK);

  if(udScore.Position > udScore.Min) then
    Result := (msg <> '')
  else
    Result := FALSE;
end;

procedure TfrmGAF.edtScoreChange(Sender: TObject);
var
  i: integer;

begin
  inherited;
  i := StrToIntDef(edtScore.Text,udScore.Min);
  if(i < udScore.Min) or (i > udScore.Max) then
    i := udScore.Min;
  udScore.Position := i;
  edtScore.Text := IntToStr(i);
  edtScore.SelStart := length(edtScore.Text);
end;

procedure TfrmGAF.dteGAFExit(Sender: TObject);
begin
  inherited;
//  BadData(TRUE);
end;

procedure TfrmGAF.cboGAFProviderExit(Sender: TObject);
begin
  inherited;
  BadData(TRUE);
end;

procedure TfrmGAF.AllowTabChange(var AllowChange: boolean);
begin
  AllowChange := (not BadData(TRUE));
  if AllowChange then
    AllowChange := CheckSimilarNameOK;
end;

procedure TfrmGAF.GetGAFScore(var Score: integer; var Date: TFMDateTime; var Staff: Int64);
begin
  Score := udScore.Position;
  if(Score > 0) then BadData(TRUE);
  Date := dteGAF.FMDateTime;
  Staff := cboGAFProvider.ItemIEN;
  if(not ValidGAFData(Score, Date, Staff)) then
  begin
    Score := 0;
    Date := 0;
    Staff := 0
  end;
end;

function TfrmGAF.CheckSimilarNameOK: Boolean;
var
  aErrMsg: String;
begin
  Result := true;
  if (udScore.Position > 0) and
    (not CheckForSimilarName(cboGAFProvider, aErrMsg, sPr)) then
  begin
    if Trim(aErrMsg) = '' then
      aErrMsg := 'A determining party is required to enter a GAF score.';
    ShowMessage(aErrMsg);
    Result := false;
  end;
end;

procedure TfrmGAF.FormActivate(Sender: TObject);
begin
  inherited;
  if(not FDataLoaded) then
  begin
    FDataLoaded := TRUE;
    LoadScores;
    if uEncPCEData.Providers.PCEProviderForce > 0 then
    begin
      cboGAFProvider.SetExactByIEN(uEncPCEData.Providers.PCEProviderForce,
        uEncPCEData.Providers.PCEProviderNameForce);
      TSimilarNames.RegORComboBox(cboGAFProvider);
    end
    else
      cboGAFProvider.InitLongList('');
    BadData(FALSE);
  end;
end;

procedure TfrmGAF.FormShow(Sender: TObject);
begin
  inherited;
  FormActivate(Sender);
end;

procedure TfrmGAF.btnURLClick(Sender: TObject);
begin
  inherited;
  GotoWebPage(GAFURL);
end;

procedure TfrmGAF.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_GAFNm;
  btnURL.Visible := (User.WebAccess and (GAFURL <> ''));
  FormActivate(Sender);
end;

initialization
  SpecifyFormIsNotADialog(TfrmGAF);

end.
