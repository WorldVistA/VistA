unit fPCELex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmPCELex = class(TfrmAutoSz)
    txtSearch: TCaptionEdit;
    cmdSearch: TButton;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblSearch: TLabel;
    lblSelect: TLabel;
    lstSelect: TORListBox;
    procedure cmdSearchClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure lstSelectClick(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
    procedure lstSelectDblClick(Sender: TObject);
  private
    FLexApp: Integer;
    FCode:   string;
    FDate:   TFMDateTime;
    procedure SetApp(LexApp: Integer);
    procedure SetDate(ADate: TFMDateTime);
  end;

procedure LexiconLookup(var Code: string; LexApp: Integer; ADate: TFMDateTime = 0);

implementation

{$R *.DFM}

uses rPCE,UBAGlobals;

procedure LexiconLookup(var Code: string; LexApp: Integer; ADate: TFMDateTime = 0);
var
  frmPCELex: TfrmPCELex;
begin
  frmPCELex := TfrmPCELex.Create(Application);
  try
    ResizeFormToFont(TForm(frmPCELex));
    frmPCELex.SetApp(LexApp);
    frmPCELex.SetDate(ADate);
    frmPCELex.ShowModal;
    Code := frmPCELex.FCode;
  finally
    frmPCELex.Free;
  end;
end;

procedure TfrmPCELex.FormCreate(Sender: TObject);
begin
  inherited;
  FCode := '';
end;

procedure TfrmPCELex.SetApp(LexApp: Integer);
begin
  FLexApp := LexApp;
  case LexApp of
  LX_ICD: begin
            Caption := 'Lookup Diagnosis';
            lblSearch.Caption := 'Search for Diagnosis';
          end;
  LX_CPT: begin
            Caption := 'Lookup Procedure';
            lblSearch.Caption := 'Search for Procedure';
          end;
  end;
end;

procedure TfrmPCELex.SetDate(ADate: TFMDateTime);
begin
  FDate := ADate;
end;

procedure TfrmPCELex.txtSearchChange(Sender: TObject);
begin
  inherited;
  cmdSearch.Default := True;
  cmdOK.Default := False;
end;

procedure TfrmPCELex.cmdSearchClick(Sender: TObject);
begin
  inherited;
  if Length(txtSearch.Text) = 0 then Exit;
  StatusText('Searching clinical lexicon...');
  ListLexicon(lstSelect.Items, txtSearch.Text, FLexApp, FDate);
  if lstSelect.GetIEN(0) = -1 then
  begin
    lblSelect.Visible := False;
    txtSearch.SetFocus;
    txtSearch.SelectAll;
    cmdOK.Default := False;
    cmdSearch.Default := True;
  end else
  begin
    lblSelect.Visible := True;
    lstSelect.SetFocus;
    cmdSearch.Default := False;
  end;
  StatusText('');
end;

procedure TfrmPCELex.lstSelectClick(Sender: TObject);
begin
  inherited;
  if(lstSelect.ItemIndex > -1) and (lstSelect.ItemIEN > 0) then
  begin
    cmdSearch.Default := False;
    cmdOK.Default := True;
  end;
end;

procedure TfrmPCELex.cmdOKClick(Sender: TObject);
begin
  inherited;
  if(lstSelect.ItemIndex = -1) or (lstSelect.ItemIEN <= 0) then Exit;
  with lstSelect do
  begin
    if BAPersonalDX then
      FCode := (LexiconToCode(ItemIEN, FLexApp, FDate) + U + DisplayText[ItemIndex] + U + IntToStr(ItemIEN) )
   else
       FCode := LexiconToCode(ItemIEN, FLexApp, FDate) + U + DisplayText[ItemIndex];
    Close;
  end;
end;

procedure TfrmPCELex.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FCode := '';
  Close;
end;

procedure TfrmPCELex.lstSelectDblClick(Sender: TObject);
begin
  inherited;
  lstSelectClick(Sender);
  cmdOKClick(Sender);
end;

end.

