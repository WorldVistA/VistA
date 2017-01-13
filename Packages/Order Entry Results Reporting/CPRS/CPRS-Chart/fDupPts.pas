unit fDupPts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ORCtrls, ExtCtrls, OrFn, fBase508Form,
  VA508AccessibilityManager, Vcl.ComCtrls;

type
  TfrmDupPts = class(TfrmBase508Form)
    pnlDupPts: TPanel;
    pnlSelDupPt: TPanel;
    lblSelDupPts: TLabel;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lboSelPt: TCaptionListView;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lboSelPtDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDupPts: TfrmDupPts;

implementation

{$R *.dfm}

uses rCore, uCore, fPtSel;

procedure TfrmDupPts.btnCancelClick(Sender: TObject);
begin

close;

end;

procedure TfrmDupPts.FormCreate(Sender: TObject);
var
  theDups: tStringList;
begin
  fPtSel.DupDFN := 'Cancel'; // Pre-set as default.
  theDups := tStringList.create;
  FastAssign(fPtSel.PtStrs, theDups);
  FastAssign(theDups, lboSelPt.ItemsStrings);
  ResizeAnchoredFormToFont(self);
end;

procedure TfrmDupPts.btnOKClick(Sender: TObject);
begin

if not (Length(lboSelPt.ItemID) > 0) then  //*DFN*
begin
  infoBox('A patient has not been selected.', 'No Patient Selected', MB_OK);
  exit;
end;

fPtSel.DupDFN := lboSelPt.ItemID;  //*DFN*
close;

end;

procedure TfrmDupPts.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (key = VK_ESCAPE) then
    btnCancel.click;
end;

procedure TfrmDupPts.lboSelPtDblClick(Sender: TObject);
begin
  btnOKClick(btnOK);
end;

end.
