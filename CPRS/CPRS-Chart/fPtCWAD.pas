unit fPtCWAD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORCtrls, StdCtrls, ORFn, ExtCtrls, VA508AccessibilityManager;

type
  TfrmPtCWAD = class(TfrmAutoSz)
    lstAllergies: TORListBox;
    lstNotes: TORListBox;
    lblNotes: TOROffsetLabel;
    pnlBottom: TPanel;
    btnClose: TButton;
    lblAllergies: TOROffsetLabel;
    procedure FormCreate(Sender: TObject);
    procedure lstAllergiesClick(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowCWAD;

implementation

{$R *.DFM}

uses rCover, fRptBox, uCore, uConst, fAllgyBox, rODAllergy;

const
  TX_LST_ALLG = 'Searching for allergies...';
  TX_LST_POST = 'Searching for postings...';

procedure ShowCWAD;
{ displays CWAD notices (future - allow updates of allergy info from here? }
var
  frmPtCWAD: TfrmPtCWAD;
begin
  frmPtCWAD := TfrmPtCWAD.Create(Application);
  try
    ResizeFormToFont(TForm(frmPtCWAD));
    frmPtCWAD.ShowModal;
  finally
    frmPtCWAD.Release;
  end;
end;


procedure TfrmPtCWAD.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  StatusText(TX_LST_ALLG);
  ListAllergies(lstAllergies.Items);
  StatusText(TX_LST_POST);
  ListPostings(lstNotes.Items);
  with lstNotes do for i := Items.Count - 1 downto 0 do
    if Items[i]='^Allergies^' then Items.Delete(i);
  StatusText('');
end;

procedure TfrmPtCWAD.lstAllergiesClick(Sender: TObject);
begin
  inherited;
  with lstAllergies do
    if ItemIEN > 0 then
    begin
{ TODO -oRich V. -cART/Allergy : Allergy Box to update CWAD allergies list? }
(*      if ARTPatchInstalled then
        AllergyBox(DetailAllergy(ItemIEN), DisplayText[ItemIndex], True, ItemIEN)
      else*)
        ReportBox(DetailAllergy(ItemIEN), DisplayText[ItemIndex], True);
    end;
end;

procedure TfrmPtCWAD.lstNotesClick(Sender: TObject);
begin
  inherited;
  with lstNotes do
    if ItemID <> '' then
      begin
        NotifyOtherApps(NAE_REPORT, 'TIU^' + lstNotes.ItemID);
        ReportBox(DetailPosting(ItemID), DisplayText[ItemIndex], True);
      end;
end;

procedure TfrmPtCWAD.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmPtCWAD.btnCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
