unit fPrintList;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, fConsult513Prt, VA508AccessibilityManager;

type
  TfrmPrintList = class(TfrmAutoSz)
    lbIDParents: TORListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblListName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);

  private
    { Private declarations }
     FParentNode: string;
  public
    { Public declarations }
    function SelectParentFromList(ATree: TORTreeView; PageID: Integer): string;
  end;

var
  frmPrintList: TfrmPrintList;
  HLDPageID: Integer;

implementation

{$R *.dfm}
uses
  uTIU, rTIU, uConst, fNotes, fNotePrt, ORFn, fConsults, fDCSumm, fFrame;

procedure TfrmPrintList.FormCreate(Sender: TObject);
begin
  inherited;
   FParentNode := '';
end;

procedure TfrmPrintList.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FParentNode := '';
  Close;
end;

procedure TfrmPrintList.cmdOKClick(Sender: TObject);
begin
  inherited;
  case HLDPageID of
    CT_NOTES:        frmNotes.RequestMultiplePrint(Self);
    CT_CONSULTS:     frmConsults.RequestMultiplePrint(Self);
    CT_DCSUMM:       frmDCSumm.RequestMultiplePrint(Self);
  end; {case}
  FParentNode := lbIDParents.ItemID;
  Close;
end;

function TfrmPrintList.SelectParentFromList(ATree: TORTreeView; PageID: Integer): string;
var
  frmPrintList: TfrmPrintList;
  i, AnImg: integer;
  x: string;
  tmpList: TStringList;
  //strObj: TStringList;
begin
  HLDPageID := PageID;
  frmPrintList := TfrmPrintList.Create(Application);
  frmPrintList.Parent := Self;
  tmpList := TStringList.Create;
   try
    ResizeFormToFont(TForm(frmPrintList));
    for i := 0 to ATree.Items.Count - 1 do
      begin
        AnImg := TORTreeNode(ATree.Items.Item[i]).ImageIndex;
        if AnImg in [IMG_SINGLE, IMG_PARENT,IMG_IDNOTE_SHUT, IMG_IDNOTE_OPEN,
                         IMG_IDPAR_ADDENDA_SHUT, IMG_IDPAR_ADDENDA_OPEN] then
          begin
            x := TORTreeNode(ATree.Items.Item[i]).Stringdata;
            tmpList.Add(x);
            //strObj := TStringList.Create;
            //strObj.Insert(0,x);
            //tmpList.AddObject(x, strObj)  // notes and dc/summs & Consults
          end; {if}
      end; {for}

    frmPrintList.lbIDParents.Sorted := FALSE;

      case PageID of
      CT_NOTES:
         begin
           SortByPiece(tmpList, U, 3);
           InvertStringList(tmpList);
           for i := 0 to tmpList.Count - 1 do
             begin
               x := tmpList[i];
               tmpList[i] := Piece(x, U, 1) + U + (MakeNoteDisplayText(x));
             end;
           frmPrintList.lblListName.Caption := 'Select Notes to be printed.';
         end;
      CT_CONSULTS:
         begin
           SortByPiece(tmpList, U, 11);
           InvertStringList(tmpList);
           for i := 0 to tmpList.Count - 1 do
             begin
               x := tmpList[i];
               tmpList[i] := Piece(x, U, 1) + U + (MakeConsultDisplayText(x));
             end;
           frmPrintList.lblListName.Caption := 'Select Consults to be printed.';
         end;
      CT_DCSUMM:
         begin
           SortByPiece(tmpList, U, 3);
           InvertStringList(tmpList);
           for i := 0 to tmpList.Count - 1 do
             begin
               x := tmpList[i];
               tmpList[i] := Piece(x, U, 1) + U + (MakeNoteDisplayText(x));
             end;
           frmPrintList.lblListName.Caption := 'Select Discharge Summaries to be printed.';
         end;
      end; //case

    FastAssign(tmpList, frmPrintList.lbIDParents.Items);
    frmPrintList.ShowModal;
    Result := frmPrintList.FParentNode;
  finally
    tmpList.Free;
    frmPrintList.Release;
  end;
end;

end.
