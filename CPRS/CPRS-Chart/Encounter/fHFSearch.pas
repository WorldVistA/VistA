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
  private
    FCode:   string;
    FChanging: boolean;
    procedure UpdateCat;
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
  Node: TORTreeNode;
  CurCat, NodeCat: TTreeNode;
  ID: string;

begin
  inherited;
  if(not FChanging) then
  begin
    FChanging := TRUE;
    try
      btnOK.Enabled := (cbxSearch.ItemIndex >= 0);
      if(cbxSearch.ItemIndex < 0) then
        tvSearch.Selected := nil
      else
      begin
        ID := cbxSearch.ItemID;
        if(assigned(tvSearch.Selected)) then
        begin
          CurCat := tvSearch.Selected;
          while (assigned(CurCat.Parent)) do
            CurCat := CurCat.Parent;
        end
        else
          CurCat := nil;
        Node := TORTreeNode(tvSearch.Items.GetFirstNode);
        while assigned(Node) do
        begin
          if(piece(Node.StringData,U,1)= ID) then
          begin
            NodeCat := Node;
            while (assigned(NodeCat.Parent)) do
              NodeCat := NodeCat.Parent;
            RedrawSuspend(tvSearch.Handle);
            try
              if(CurCat <> NodeCat) then
                tvSearch.FullCollapse;
              tvSearch.Selected := Node;
              Node.EnsureVisible;
            finally
              RedrawActivate(tvSearch.Handle);
            end;
            break;
          end;
          Node := TORTreeNode(Node.GetNext);
        end;
      end;
      UpdateCat;
    finally
      FChanging := FALSE;
    end;
  end;
end;


procedure TfrmHFSearch.FormCreate(Sender: TObject);
var
  HFList: TStringList;
  i: integer;
  Node, Child :TORTreeNode;
  CAT: string;

begin
  inherited;
  HFList := TStringList.Create;
  try
    LoadcboOther(HFList, uEncPCEData.Location, PCE_HF);
    for i := 0 to HFList.Count-1 do
    begin
      if(Piece(HFList[i],U,3)='F') then
        cbxSearch.Items.Add(pieces(HFList[i],U,1,2));
    end;
    for i := 0 to HFList.Count-1 do
    begin
      if(Piece(HFList[i],U,3)='C') then
      begin
        with TORTreeNode(tvSearch.Items.Add(nil, '')) do
        begin
          StringData := HFList[i];
          ImageIndex := 2;
          SelectedIndex := 2;
        end;
      end;
    end;
    for i := 0 to HFList.Count-1 do
    begin
      if(Piece(HFList[i],U,3)='F') then
      begin
        CAT := piece(HFList[i],U,4);
        Node := TORTreeNode(tvSearch.Items.GetFirstNode);
        while(assigned(Node)) do
        begin
          if(Piece(Node.StringData, U, 1) = CAT) then
            break;
          Node := TORTreeNode(Node.GetNextSibling);
        end;
        Child := TORTreeNode(tvSearch.Items.AddChild(Node, ''));
        Child.StringData := Pieces(HFList[i],U,1,2);
        Child.ImageIndex := -1;
        Child.StateIndex := -1;
      end;
    end;
//    tvSearch.Invalidate;
  finally
    HFList.Free;
  end;
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

end.
