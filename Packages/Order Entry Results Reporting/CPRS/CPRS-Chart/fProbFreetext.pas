unit fProbFreetext;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, uProbs,
  Dialogs, fBase508Form, VA508AccessibilityManager, ExtCtrls, StdCtrls, Buttons;

type
  TfrmProbFreetext = class(TfrmBase508Form)
    pnlButton: TPanel;
    pnlLeft: TPanel;
    pnlDialog: TPanel;
    bbYes: TBitBtn;
    bbNo: TBitBtn;
    edtComment: TLabeledEdit;
    ckbNTRT: TCheckBox;
    imgIcon: TImage;
    pnlNTRT: TPanel;
    pnlMessage: TPanel;
    memMessage: TMemo;
    lblUse: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure ckbNTRTClick(Sender: TObject);
    procedure bbYesClick(Sender: TObject);
    procedure edtCommentChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function CreateFreetextMessage(term: String; ICDVersion: String): TForm;

var
  frmProbFreetext: TfrmProbFreetext;

implementation

{$R *.dfm}

uses
  VAUtils, ORFn;

const
  TXR69 = 'A suitable term was not found based on user input and current defaults.' + CRLF + 'If you proceed with this nonspecific term, an ICD code of "R69 - ILLNESS, UNSPECIFIED" will be filed.';

procedure TfrmProbFreetext.bbYesClick(Sender: TObject);
begin
  inherited;
  RequestNTRT := ckbNTRT.Checked;
  NTRTComment := edtComment.Text;
end;

procedure TfrmProbFreetext.ckbNTRTClick(Sender: TObject);
begin
  inherited;
  edtComment.Visible := ckbNTRT.Checked;
  if edtComment.Visible then
    edtComment.SetFocus
  else
    edtComment.Clear;
end;

procedure TfrmProbFreetext.edtCommentChange(Sender: TObject);
begin
  inherited;
  bbNo.Default := False;
  bbYes.Default := True;
end;

procedure TfrmProbFreetext.FormCreate(Sender: TObject);
begin
  inherited;
  with imgIcon do
  begin
    Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
  end;

  memMessage.TabStop := ScreenReaderActive;
  lblUse.TabStop := ScreenReaderActive;
end;

function CreateFreetextMessage(term: String; ICDVersion: String): TForm;
begin
  Result := TfrmProbFreetext.Create(Application);
  with Result as TfrmProbFreetext do
  begin
    if Piece(ICDVersion, '^', 1) = '10D' then
    begin
      memMessage.Lines.Clear;
      memMessage.Lines[0] := TXR69;
    end;
    lblUse.Caption := lblUse.caption + ' ' + term + '?';
    bbNo.Default := True;
    ActiveControl := bbNo;
    with ckbNTRT do
    begin
      Hint := 'Check this box if you would like ' + UpperCase(term) +
              ' to be considered for inclusion'#13#10'in future revisions of SNOMED CT.';
      ShowHint := True;
    end;
    Invalidate;
  end;
end;
end.
