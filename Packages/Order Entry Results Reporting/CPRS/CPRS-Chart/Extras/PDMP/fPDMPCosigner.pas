unit fPDMPCosigner;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  ORCtrls,
  fBase508Form,
  Vcl.ExtCtrls,
  ORFn;

type
  TpdmpCosigner = class(TfrmBase508Form)
    cboCosigner: TORComboBox;
    lblCosigner: TLabel;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnAccept: TButton;
    pnlMain: TPanel;
    btnDebug: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnDebugClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboCosignerDblClick(Sender: TObject);
    procedure cboCosignerNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboCosignerExit(Sender: TObject);
  private
    fEncounterProvider: string;
    fDateTime: TFMDateTime;
    fDocType: Integer;
    fCosignerIEN: String;
    fCosignerName: String;
    procedure initLookup;
  public
    property CosignerIEN: String read fCosignerIEN write fCosignerIEN;
    property CosignerName: String read fCosignerName write fCosignerName;
    procedure SetFontSize(aSize: Integer);
  end;

function pdmpSelectCosigner(encounterProvider: string; aDocType: Integer;
  encDate:TFMDateTime): string; overload;
function pdmpSelectCosigner(encounterProvider: string; aDocType: Integer;
  encDate:TFMDateTime; header: string; noteIEN: Integer): string; overload;

implementation

uses
  rCore,
  rPDMP,
  rTIU,
  uSimilarNames,
  uSizing,
  oPDMPData,
  uPDMP;

{$R *.dfm}

function pdmpSelectCosigner(encounterProvider: string; aDocType: Integer;
  encDate:TFMDateTime): string;
var
  pdmpUserForm: TpdmpCosigner;
  idx: Integer;
begin
  result := '-1'; //
  pdmpUserForm := TpdmpCosigner.Create(Application);
  with pdmpUserForm do
    try
      SetFontSize(Application.MainForm.Font.Size);
      fEncounterProvider := encounterProvider;
      fDateTime := encDate;
      fDocType := aDocType;
      // pdmpUserForm.cboCosigner.InitLongList(Piece(encounterProvider, U, 2));
      if ShowModal = mrOK then
      begin
        idx := cboCosigner.ItemIndex;
        result := Pieces(cboCosigner.Items.Strings[idx], U, 1, 2);
      end
      else
        result := '-2'; // user canceled selection
    finally
      FreeAndNil(pdmpUserForm);
    end;
end;

function pdmpSelectCosigner(encounterProvider: string; aDocType: Integer;
  encDate:TFMDateTime; header: string; noteIEN: Integer): string; overload;
var
  pdmpUserForm: TpdmpCosigner;
  idx: Integer;
begin
  result := '-1'; //
  pdmpUserForm := TpdmpCosigner.Create(Application);
  pdmpUserForm.Caption := header;
  PDMP_NoteTitleID := noteIEN;
  with pdmpUserForm do
    try
      SetFontSize(Application.MainForm.Font.Size);
      fEncounterProvider := encounterProvider;
      fDateTime := encDate;
      fDocType := aDocType;
      // pdmpUserForm.cboCosigner.InitLongList(Piece(encounterProvider, U, 2));
      if ShowModal = mrOK then
      begin
        idx := cboCosigner.ItemIndex;
        result := Pieces(cboCosigner.Items.Strings[idx], U, 1, 2);
      end
      else
        result := '-2'; // user canceled selection
    finally
      FreeAndNil(pdmpUserForm);
    end;
end;
/// /////////////////////////////////////////////////////////////////////////////

procedure TpdmpCosigner.btnDebugClick(Sender: TObject);
begin
  inherited;
  cboCosigner.ItemIndex := -1;
end;

procedure TpdmpCosigner.cboCosignerExit(Sender: TObject);
begin
  with cboCosigner do
    if ((Text = '') or (ItemIEN = 0)) then
    begin
      ItemIndex := -1;
      CosignerIEN := '0';
      CosignerName := '';
    end
    else
    begin
      CosignerIEN := IntToStr(cboCosigner.ItemIEN);
      CosignerName := Piece(cboCosigner.Items[cboCosigner.ItemIndex], U, 2);
    end;
end;

procedure TpdmpCosigner.cboCosignerNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
  cbo: TORComboBox;

begin
  sl := TSTringList.Create;
  try
    cbo := (Sender as TORComboBox);
    setSubSetOfUsersWithClass(cbo, sl, StartFrom, Direction, FloatToStr(FMToday));
    cbo.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TpdmpCosigner.cboCosignerDblClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOK;
end;

procedure TpdmpCosigner.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ErrMsg: String;
begin
  inherited;
  if ModalResult = mrCancel then
  begin
    CanClose := True;
  end else begin
    if not CheckForSimilarName(cboCosigner, ErrMsg, sCo) then
    begin
      CanClose := False;
    end else begin
      if cboCosigner.ItemIndex >= 0 then
      begin
        CanClose := CanCosign(PDMP_NoteTitleID, FDocType, cboCosigner.ItemIEN, fDateTime);
        if CanClose then ErrMsg := ''
        else ErrMsg := cboCosigner.Text + TX_COS_AUTH;
      end else begin
        ErrMsg := PDMP_MSG_NO_COSIGNER_SELECTED;
        CanClose := False;
      end;
      if not CanClose then InfoBox(ErrMsg, PDMP_MSG_TITLE, MB_OK + MB_ICONWARNING);
    end;
  end;
end;

procedure TpdmpCosigner.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TpdmpCosigner.FormShow(Sender: TObject);
begin
  initLookup;
end;

procedure TpdmpCosigner.initLookup;
var
  idx: Integer;
begin
  cboCosigner.InitLongList(fEncounterProvider);
  idx := cboCosigner.Items.IndexOf(fEncounterProvider);
  if idx > -1 then
  begin
    cboCosigner.ItemIndex := idx;
    TSimilarNames.RegORComboBox(cboCosigner);
  end;
end;

procedure TpdmpCosigner.SetFontSize(aSize: Integer);
begin
  Font.Size := aSize;
  adjustBtn(btnDebug);
  adjustBtn(btnAccept);
  adjustBtn(btnCancel);
end;

end.
