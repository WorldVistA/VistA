unit fHFSearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORFn, StdCtrls, ComCtrls, ORCtrls, ExtCtrls,
  VA508AccessibilityManager, VA508ImageListLabeler;

type
  TfrmHFSearch = class(TfrmAutoSz)
    cbxSearch: TORComboBox;
    tvSearch: TORTreeView;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    splMain: TSplitter;
    lblCat: TLabel;
    imgListHFtvSearch: TVA508ImageListLabeler;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure tvSearchDblClick(Sender: TObject);
    procedure tvSearchGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvSearchChange(Sender: TObject; Node: TTreeNode);
    procedure cbxSearchChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCode:   string;
    FChanging: boolean;
    fParentList: TStringList;
    fFullList: TStringList;
    procedure UpdateCat;
    Procedure LoadTheTree;
    procedure MyExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: boolean);
    procedure LoadNextLevel(Node: TOrTreeNode);
  public
  end;

procedure HFLookup(var Code: string);

implementation

uses rPCE, dShared, fEncounterFrame;

{$R *.DFM}

const
  CatTxt = 'Category: ';

procedure HFLookup(var Code: string);
var
  frmHFSearch: TfrmHFSearch;

begin
  frmHFSearch := TfrmHFSearch.Create(Application);
  try
    ResizeFormToFont(TForm(frmHFSearch));
    frmHFSearch.ShowModal;
    Code := frmHFSearch.FCode;
  finally
    frmHFSearch.Free;
  end;
end;

procedure TfrmHFSearch.cbxSearchChange(Sender: TObject);
var
  Node: TOrTreeNode;
  CurCat, NodeCat: TTreeNode;
  ID: string;
  CatIdx: Integer;
begin
  inherited;
  if (not FChanging) then
  begin
    FChanging := TRUE;
    try
      btnOK.Enabled := (cbxSearch.ItemIndex >= 0);
      if (cbxSearch.ItemIndex < 0) then
        tvSearch.Selected := nil
      else
      begin
        ID := cbxSearch.ItemID;
        // Grab the current selected node
        if (assigned(tvSearch.Selected)) then
        begin
          CurCat := tvSearch.Selected;
          while (assigned(CurCat.Parent)) do
            CurCat := CurCat.Parent;
        end
        else
          CurCat := nil;

        // Find the Category Node
        NodeCat := nil;
        CatIdx := fParentList.IndexOf
          (Piece(cbxSearch.Items[cbxSearch.ItemIndex], U, 4));
        if CatIdx > -1 then
          NodeCat := TOrTreeNode(fParentList.Objects[CatIdx]);

        if not assigned(NodeCat) then
          exit;

        tvSearch.LockDrawing;
        try
          if (CurCat <> NodeCat) then
          begin
            tvSearch.FullCollapse;
            NodeCat.Expand(false);
          end;

          Node := TOrTreeNode(NodeCat.getFirstChild);
          while Piece(Node.StringData, U, 1) <> ID do
          begin
            Node := TOrTreeNode(Node.getNextSibling);
          end;

          tvSearch.Selected := Node;
          Node.EnsureVisible;
        finally
          tvSearch.UnlockDrawing;
        end;

      end;
      UpdateCat;
    finally
      FChanging := false;
    end;
  end;
end;

procedure TfrmHFSearch.FormCreate(Sender: TObject);
begin
  inherited;

  fParentList := TStringList.Create;
  fFullList := TStringList.Create;

  LoadcboOther(fFullList, uEncPCEData.Location, PCE_HF);
  LoadTheTree;
end;

procedure TfrmHFSearch.FormDestroy(Sender: TObject);
begin
  fParentList.Free;
  fFullList.Free;
  inherited;
end;

procedure TfrmHFSearch.btnOKClick(Sender: TObject);
begin
  inherited;
  if cbxSearch.ItemIndex = -1 then Exit;
  FCode := cbxSearch.Items[cbxSearch.ItemIndex];
  ModalResult := mrOK;
end;

procedure TfrmHFSearch.tvSearchDblClick(Sender: TObject);
begin
  inherited;
  btnOKClick(Sender);
end;

procedure TfrmHFSearch.tvSearchGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
  if(piece(TORTreeNode(Node).StringData,U,3)= 'C') then
  begin
    if(Node.Expanded) then
      Node.ImageIndex := 3
    else
      Node.ImageIndex := 2;
  end
  else
    Node.ImageIndex := -1;
  Node.SelectedIndex := Node.ImageIndex;
//  tvSearch.Invalidate;
end;

procedure TfrmHFSearch.tvSearchChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  if(not FChanging) then
  begin
    FChanging := TRUE;
    try
      if(assigned(Node)) then
        cbxSearch.SelectByID(Piece(TORTreeNode(Node).StringData,U,1))
      else
        cbxSearch.ItemIndex := -1;
      btnOK.Enabled := (cbxSearch.ItemIndex >= 0);
      UpdateCat;
    finally
      FChanging := FALSE;
    end;
  end;
end;

procedure TfrmHFSearch.UpdateCat;
var
  NodeCat: TTreeNode;
  
begin
  NodeCat := tvSearch.Selected;
  if(assigned(NodeCat)) then
  begin
    while (assigned(NodeCat.Parent)) do
      NodeCat := NodeCat.Parent;
    lblCat.Caption := CatTxt + NodeCat.Text;
  end
  else
    lblCat.Caption := CatTxt;
  cbxSearch.Caption := lblCat.Caption;
end;

Procedure TfrmHFSearch.LoadTheTree();
var
  i: Integer;
  CatNode, ChldNode: TOrTreeNode;
  aLookupStr: String;
  RtnCursor: TCursor;
Begin
  tvSearch.Items.BeginUpdate;
  RtnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try

    // Sort backwards
    SortByPieces(fFullList, U, [3, 2], DIR_BKWRD);

    // Add the parents
    for i := fFullList.Count - 1 downto 0 do
    begin
      aLookupStr := Piece(fFullList[i], U, 3);
      if (aLookupStr = 'C') then
      begin
        CatNode := TOrTreeNode(tvSearch.Items.Add(nil, ''));
        with CatNode do
        begin
          StringData := fFullList[i];
          ImageIndex := 2;
          SelectedIndex := 2;
        end;
        fParentList.AddObject(Piece(fFullList[i], U, 1), CatNode);
        ChldNode := TOrTreeNode(tvSearch.Items.AddChild(CatNode, ''));
        ChldNode.StringData := '';

        fFullList.Delete(i);
      end
      Else if aLookupStr = 'F' then
        break
      else
      begin
        fFullList.Delete(i);
        continue;
      end;
    end;

    for i := fFullList.Count - 1 downto 0 do
      cbxSearch.Items.Add(fFullList[i]);

    // set up the dynamice load
    tvSearch.OnExpanding := MyExpanding;
    SortByPiece(fFullList, U, 4, DIR_FRWRD);

  finally
    tvSearch.Items.EndUpdate;
    Screen.Cursor := RtnCursor;
  end;
end;

procedure TfrmHFSearch.LoadNextLevel(Node: TOrTreeNode);
var
  i: Integer;
  CAT: String;
  Child: TOrTreeNode;
  Found: boolean;
begin
  //
  Found := false;
  CAT := Piece(Node.StringData, U, 1);
  for i := fFullList.Count - 1 downto 0 do
  begin

    if (Piece(fFullList[i], U, 4) = CAT) then
    begin
      Child := TOrTreeNode(tvSearch.Items.AddChild(Node, ''));
      Child.StringData := pieces(fFullList[i], U, 1, 2);
      Child.ImageIndex := -1;
      Child.StateIndex := -1;
      Found := TRUE;
      fFullList.Delete(i);
    end
    else
    begin
      if Found then
        break;
    end;
  end;
end;

procedure TfrmHFSearch.MyExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: boolean);
var
  n2: TOrTreeNode;
  RtnCsr: TCursor;
begin
  RtnCsr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    n2 := TOrTreeNode(Node.getFirstChild);
    if n2.StringData = '' then
    begin
      // Now we know this is a "dummy" node and needs to be populated with child nodes
      n2.Delete; // Delete this dummy node
      LoadNextLevel(TOrTreeNode(Node));
    end;
  finally
    Screen.Cursor := RtnCsr;
  end;
end;

end.
