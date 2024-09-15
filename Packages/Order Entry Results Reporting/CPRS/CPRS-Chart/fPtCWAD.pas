unit fPtCWAD;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  fAutoSz,
  ORCtrls,
  StdCtrls,
  ORFn,
  ExtCtrls,
  VA508AccessibilityManager,
  Vcl.ComCtrls,
  System.Math;

type
  TfrmPtCWAD = class(TfrmAutoSz)
    lstNotes: TORListBox;
    lblNotes: TOROffsetLabel;
    pnlBottom: TPanel;
    btnClose: TButton;
    lstAllergies: TCaptionListView;
    procedure FormCreate(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure lstAllergiesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstAllergiesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowCWAD;

implementation

{$R *.DFM}


uses
  rCover,
  fRptBox,
  uCore,
  uConst,
  rODAllergy;

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
  I: integer;
  aList: TStringList;
begin
  inherited;
  StatusText(TX_LST_ALLG);
  aList := TStringList.Create;
  try
    ListAllergies(aList);
    FastAssign(aList, lstAllergies.ItemsStrings);
  finally
    FreeAndNil(aList);
  end;
  StatusText(TX_LST_POST);
  ListPostings(lstNotes.Items);
  with lstNotes do
    for I := Items.Count - 1 downto 0 do
      if Items[I] = '^Allergies^' then Items.Delete(I);
  StatusText('');
end;

procedure TfrmPtCWAD.lstAllergiesClick(Sender: TObject);
var
  ReportTitle: string;
begin
  with lstAllergies do
    begin
      if ItemIEN > 0 then
        begin
          ReportTitle := Selected.Caption + ' ' + Selected.SubItems.Strings[0] + ' ' + Selected.SubItems.Strings[1];
          ReportBox(DetailAllergy(ItemIEN), ReportTitle, True);
        end;
    end;
end;

procedure TfrmPtCWAD.lstAllergiesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if lstAllergies.Focused then
    begin
      case Key of
        VK_RETURN: lstAllergiesClick(Sender);
      end;
    end;
end;

procedure TfrmPtCWAD.lstNotesClick(Sender: TObject);
var
  mItem: string;
begin
  inherited;
  with lstNotes do
    begin
      if ItemIndex > -1 then
        mItem := UpperCase(MItems[ItemIndex])
      else
        mItem := '';
      if ItemID <> '' then
        if UpperCase(ItemID) = 'WH' then // TDrugs Patch OR*3*377 and WV*1*24 - DanP@SLC 11-20-2015
          ReportBox(DetailPosting(mItem), DisplayText[ItemIndex], False)
        else
          begin
            NotifyOtherApps(NAE_REPORT, 'TIU^' + lstNotes.ItemID);
            ReportBox(DetailPosting(ItemID), DisplayText[ItemIndex], True);
          end;
    end;
end;

procedure TfrmPtCWAD.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
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
