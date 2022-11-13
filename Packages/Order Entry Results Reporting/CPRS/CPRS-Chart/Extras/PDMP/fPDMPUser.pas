unit fPDMPUser;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  ORCtrls,
  fBase508Form;

type
  TpdmpUserForm = class(TfrmBase508Form)
    cboProviderDEA: TORComboBox;
    lblUser: TLabel;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnAccept: TButton;
    pnlMain: TPanel;
    btnDebug: TButton;
    procedure cboProviderDEANeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnDebugClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboProviderDEADblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fHasDEA, fCosignerRequired: Boolean;
    fEncounterProvider: string;
    fCosignerIEN: String;
    fCosignerName: String;
    procedure initProviderLookup;
    procedure setCosigner(bRequired: Boolean = false);
    procedure setAuthorizedUser(bRequired: Boolean = false);
  public
    procedure SetFontSize(aSize: Integer);
    property HasDEA: Boolean read fHasDEA write setAuthorizedUser;
    property CosignerRequired: Boolean read fCosignerRequired write setCosigner;
    property CosignerIEN: String read fCosignerIEN write fCosignerIEN;
    property CosignerName: String read fCosignerName write fCosignerName;
  end;

function pdmpSelectUser(encounterProvider: string;
  bAuthorized, bCosigner: Boolean): string;

implementation

uses
  rCore,
  rTIU,
  rPDMP,
  uSimilarNames,
  ORFn,
  uSizing,
  oPDMPData,
  uPDMP;

{$R *.dfm}

var
  pdmpUserForm: TpdmpUserForm;

function pdmpSelectUser(encounterProvider: string;
  bAuthorized, bCosigner: Boolean): string;
var
  idx: Integer;
begin
  result := '-1'; //
  pdmpUserForm := TpdmpUserForm.Create(Application);
  with pdmpUserForm do
    try
      SetFontSize(Application.MainForm.Font.Size);
      fEncounterProvider := encounterProvider;
      setCosigner(bCosigner);
      setAuthorizedUser(bAuthorized);
      // pdmpUserForm.cboProviderDEA.InitLongList(Piece(encounterProvider, U, 2));
      if ShowModal = mrOK then
      begin
        idx := cboProviderDEA.ItemIndex;
        result := Pieces(cboProviderDEA.Items.Strings[idx], U, 1, 2);

        result := result + '^' + CosignerIEN + '^' + CosignerName;
      end
      else
        result := '-2'; // user canceled selection
    finally
      FreeAndNil(pdmpUserForm);
    end;
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TpdmpUserForm.setCosigner(bRequired: Boolean = false);
begin
  fCosignerRequired := bRequired;
end;

procedure TpdmpUserForm.setAuthorizedUser(bRequired: Boolean = false);
begin
  fHasDEA := bRequired;
end;

procedure TpdmpUserForm.btnDebugClick(Sender: TObject);
begin
  inherited;
  cboProviderDEA.ItemIndex := -1;
end;

procedure TpdmpUserForm.cboProviderDEADblClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOK;
end;

procedure TpdmpUserForm.cboProviderDEANeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  dest: TStrings;
begin
  if True then
    dest := TStringList.Create;
  try
    pdmpSetSubSetOfAuthorizedUsers(cboProviderDEA, dest, StartFrom, Direction);
    cboProviderDEA.ForDataUse(dest);
  finally
    FreeAndNil(dest);
  end;
end;

procedure TpdmpUserForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ErrMsg: String;
begin
  inherited;
  if ModalResult = mrCancel then
    exit;

  ErrMsg := '';

  if not CheckForSimilarName(cboProviderDEA, ErrMsg, sPr) then
  begin
    CanClose := False;
  end else begin
    if (ModalResult <> mrCancel) and (cboProviderDEA.ItemIndex < 0) then
      ErrMsg := PDMP_MSG_NO_COSIGNER_SELECTED;
    CanClose := (ModalResult = mrCancel) or (cboProviderDEA.ItemIndex >= 0);
    if CanClose and CosignerRequired then
    begin
      CanClose := (ModalResult = mrCancel) or
        CanCosign(PDMP_NoteTitleID, 0, cboProviderDEA.ItemIEN, FMNow);
      if not CanClose then
        ErrMsg := cboProviderDEA.Text + TX_COS_AUTH;
    end;
  end;

  if ErrMsg <> '' then
    InfoBox(ErrMsg, PDMP_MSG_TITLE, MB_OK + MB_ICONWARNING);
end;

procedure TpdmpUserForm.FormCreate(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
  btnDebug.Visible := True;
{$ENDIF}
end;

procedure TpdmpUserForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TpdmpUserForm.FormShow(Sender: TObject);
begin
  initProviderLookup;
end;

procedure TpdmpUserForm.initProviderLookup;
var
  idx: Integer;
begin
  cboProviderDEA.InitLongList(fEncounterProvider);
  idx := cboProviderDEA.Items.IndexOf(fEncounterProvider);
  if idx > -1 then
  begin
    cboProviderDEA.ItemIndex := idx;
    TSimilarNames.RegORComboBox(cboProviderDEA);
  end;
end;

procedure TpdmpUserForm.SetFontSize(aSize: Integer);
begin
  Font.Size := aSize;
  adjustBtn(btnDebug);
  adjustBtn(btnAccept);
  adjustBtn(btnCancel);
end;

end.
