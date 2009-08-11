unit fNoteIDParents;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORCtrls, ComCtrls, StdCtrls, ORFn, VA508AccessibilityManager;

type
  TfrmNoteIDParents = class(TfrmAutoSz)
    cmdOK: TButton;
    cmdCancel: TButton;
    lstIDParents: TORListBox;
    lblSelectParent: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
  private
    FParentNode: string;
  public
    { Public declarations }
  end;

function SelectParentNodeFromList(ATree: TORTreeView): string;

implementation

{$R *.DFM}

uses
  uTIU, rTIU, uConst;

function SelectParentNodeFromList(ATree: TORTreeView): string;
var
  frmNoteIDParents: TfrmNoteIDParents;
  i, AnImg: integer;
  x: string;
  tmpList: TStringList;
begin
  frmNoteIDParents := TfrmNoteIDParents.Create(Application);
  tmpList := TStringList.Create;
  try
    ResizeFormToFont(TForm(frmNoteIDParents));
    for i := 0 to ATree.Items.Count - 1 do
      begin
        AnImg := TORTreeNode(ATree.Items.Item[i]).ImageIndex;
        if AnImg in [IMG_SINGLE, IMG_PARENT,IMG_IDNOTE_SHUT, IMG_IDNOTE_OPEN,
                         IMG_IDPAR_ADDENDA_SHUT, IMG_IDPAR_ADDENDA_OPEN] then
          begin
            x := TORTreeNode(ATree.Items.Item[i]).Stringdata;
            tmpList.Add(Piece(x, U, 1) + U + MakeNoteDisplayText(x) + U + Piece(x, U, 3));
          end;
      end;
    SortByPiece(tmpList, U, 3);
    InvertStringList(tmpList);
    FastAssign(tmpList, frmNoteIDParents.lstIDParents.Items);
    frmNoteIDParents.ShowModal;
    Result := frmNoteIDParents.FParentNode;
  finally
    tmpList.Free;
    frmNoteIDParents.Release;
  end;
end;

procedure TfrmNoteIDParents.FormCreate(Sender: TObject);
begin
  inherited;
  FParentNode := '';
end;

procedure TfrmNoteIDParents.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FParentNode := '';
  Close;
end;

procedure TfrmNoteIDParents.cmdOKClick(Sender: TObject);
const
  TX_ATTACH_FAILURE = 'Attachment failed';
var
  WhyNot, ErrMsg: string;
begin
  inherited;
  ErrMsg := '';
  if not CanReceiveAttachment(lstIDParents.ItemID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot;
  if ErrMsg <> '' then
    begin
      InfoBox(ErrMsg, TX_ATTACH_FAILURE, MB_OK);
      Exit;
    end;
  FParentNode := lstIDParents.ItemID;
  Close;
end;

end.
