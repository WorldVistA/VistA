unit mColumnTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, VCL.Controls, Forms,
  Types, Dialogs, ComCtrls, Themes, UxTheme, ORFn;

type

  TColumnTreeNode = class(TTreeNode)
  private
    FColumns: TStrings;
    FVUID: String;
    FCode: String;
    FCodeSys: String;
    FCodeIEN: String;
    FParentIndex: String;
    procedure SetColumns(const Value: TStrings);
  public
    property Columns: TStrings read FColumns write SetColumns;
    property VUID: String read FVUID write FVUID;
    property Code: String read FCode write FCode;
    property CodeSys: String read FCodeSys write FCodeSys;
    property CodeIEN: String read FCodeIEN write FCodeIEN;
    property ParentIndex: String read FParentIndex write FParentIndex;
  end;

  TColumnTreeFrame = class(TFrame)
    hdrColumns: THeaderControl;
    tvTree: TTreeView;
    procedure tvTreeCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure tvTreeChange(Sender: TObject; Node: TTreeNode);
    procedure hdrColumnsSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
  private
    { Private declarations }
    FSelNode: TColumnTreeNode;
    procedure DrawExpander(ACanvas: TCanvas; ATextRect: TRect; AExpanded: Boolean; AHot: Boolean);
//    procedure ApplicationShowHint(var HintStr: String; var CanShow: Boolean;
//      var HintInfo: VCL.Controls.THintInfo);
  public
    { Public declarations }
    procedure SetColumnTreeModel(ResultSet: TStrings);
    function FindNode(AValue:String): TColumnTreeNode;
    property SelectedNode: TColumnTreeNode read FSelNode;
  end;

  // subclass THintWindow to override font size
  TTreeViewHintWindowClass = class(THintWindow)
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFontSize(fontsize: Integer);
    function GetFontSize: Integer;
  end;

implementation

{$R *.dfm}

var
  tvHintWindowClass: TTreeViewHintWindowClass;
//  tvShowHint: TShowHintEvent;

const
  BUTTON_SIZE = 5;
  TreeExpanderSpacing = 6;

{ TTreeViewHintWindowClass }

constructor TTreeViewHintWindowClass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // use CPRS font size for hint window
  SetFontSize(Application.MainForm.Font.Size);
  tvHintWindowClass := Self;
end;

function TTreeViewHintWindowClass.GetFontSize: Integer;
begin
  Result := Canvas.Font.Size;
end;

procedure TTreeViewHintWindowClass.SetFontSize(fontsize: Integer);
begin
  Canvas.Font.Size := fontsize;
end;

{ TColumnTreeNode }

procedure TColumnTreeNode.SetColumns(const Value: TStrings);
begin
  FColumns := Value;
end;

{ TColumnTreeFrame }

function TColumnTreeFrame.FindNode(AValue: String): TColumnTreeNode;
var
  Match: TColumnTreeNode;
function Locate(AValue: String): TColumnTreeNode;
var
  Node: TColumnTreeNode;
  x, Term: String;
  j: Integer;
begin
  Result := nil;
  if tvTree.Items.Count = 0 then Exit;
  Node := tvTree.Items[0] as TColumnTreeNode;
  while Node <> nil do
  begin
    Term := Node.Text;
    j := Pos(' *', Term);
    if j > 0 then
      x := UpperCase(Copy(Term, 1, j-1))
    else
      x := UpperCase(Term);

    if x = UpperCase(AValue) then
    begin
      Result := Node;
      Result.MakeVisible;
      Break;
    end;
    Node := Node.GetNext as TColumnTreeNode;
  end;
end;
begin
  Match := Locate(AValue);
  if Match <> nil then
  begin
    Match.Selected := True;
  end;
  Result := Match;
end;

procedure TColumnTreeFrame.hdrColumnsSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  tvTree.Invalidate
end;

procedure TColumnTreeFrame.SetColumnTreeModel(ResultSet: TStrings);
var
  i: Integer;
  Node: TColumnTreeNode;
  RecStr: String;
begin
  tvTree.Items.Clear;
  for i := 0 to ResultSet.Count - 1 do
  begin
    RecStr := ResultSet[i];
    if Piece(RecStr, '^', 8) = '' then
      Node := (tvTree.Items.Add(nil, Piece(RecStr, '^', 2))) as TColumnTreeNode
    else
      Node := (tvTree.Items.AddChild(tvTree.Items[(StrToInt(Piece(RecStr, '^', 8))-1)], Piece(RecStr, '^', 2))) as TColumnTreeNode;
    with Node do
    begin
      VUID := Piece(RecStr, '^', 1);
      Text := Piece(RecStr, '^', 2);
      CodeSys := Piece(RecStr, '^', 3);
      Code := Piece(RecStr, '^', 4);
      if Piece(RecStr, '^', 8) <> '' then
        ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 8)) - 1);
      Columns := TStringList.Create;
      Columns.Add(Piece(RecStr, '^', 2));
      Columns.Add(Piece(RecStr, '^', 3));
      Columns.Add(Piece(RecStr, '^', 4));
      Columns.Add(Piece(RecStr, '^', 6));
    end;
  end;
end;

procedure TColumnTreeFrame.DrawExpander(ACanvas: TCanvas; ATextRect: TRect; AExpanded: Boolean;
  AHot: Boolean);
var
  ExpanderRect: TRect;
  ThemeData: HTHEME;
  ElementPart: Integer;
  ElementState: Integer;
  ExpanderSize: TSize;
begin
  if StyleServices.Enabled then
  begin
    if AHot then
//      ElementPart := TVP_HOTGLYPH
      ElementPart := TVP_GLYPH
    else
      ElementPart := TVP_GLYPH;

    if AExpanded then
      ElementState := GLPS_OPENED
    else
      ElementState := GLPS_CLOSED;

    ThemeData := OpenThemeData(tvTree.Handle, 'TREEVIEW');
    GetThemePartSize(ThemeData, ACanvas.Handle, ElementPart, ElementState, nil,
      TS_TRUE, ExpanderSize);
    ExpanderRect.Left := ATextRect.Left - TreeExpanderSpacing - ExpanderSize.cx;
    ExpanderRect.Right := ExpanderRect.Left + ExpanderSize.cx;
    ExpanderRect.Top := ATextRect.Top + (ATextRect.Bottom - ATextRect.Top - ExpanderSize.cy) div 2;
    ExpanderRect.Bottom := ExpanderRect.Top + ExpanderSize.cy;
    DrawThemeBackground(ThemeData, ACanvas.Handle, ElementPart, ElementState, ExpanderRect, nil);
    CloseThemeData(ThemeData);
  end
  else
  begin

    // Drawing expander without themes...

  end;
end;

procedure TColumnTreeFrame.tvTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages,
  DefaultDraw: Boolean);
var
  i: Integer;
  CTNode: TColumnTreeNode;
  NodeRect: TRect;
  NodeTextRect: TRect;
  Text: string;
  ThemeData: HTHEME;
  TreeItemState: Integer;
begin
  DefaultDraw := True;
  CTNode := Node as TColumnTreeNode;
  if (CTNode.Columns <> nil) and (CTNode.Columns.Count > 0) then
  begin
  if Stage = cdPrePaint then
  begin
    NodeRect := Node.DisplayRect(False);
    NodeTextRect := Node.DisplayRect(True);

    // Drawing background
    if (cdsSelected in State) and Sender.Focused then
      TreeItemState := TREIS_SELECTED
    else
//      if (cdsSelected in State) and (cdsHot in State) then
//        TreeItemState := TREIS_HOTSELECTED
//      else
      if cdsSelected in State then
        TreeItemState := TREIS_SELECTEDNOTFOCUS
      else
        if cdsHot in State then
          TreeItemState := TREIS_HOT
        else
          TreeItemState := TREEITEMStateFiller0;

    if TreeItemState <> TREEITEMStateFiller0 then
    begin
      ThemeData := OpenThemeData(Sender.Handle, 'TREEVIEW');
      DrawThemeBackground(ThemeData, Sender.Canvas.Handle, TVP_TREEITEM, TreeItemState,
        NodeRect, nil);
      CloseThemeData(ThemeData);
    end;

    // Drawing expander
    if Node.HasChildren then
      DrawExpander(Sender.Canvas, NodeTextRect, Node.Expanded, cdsHot in State);

    // Set the background mode and selection text color
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    if cdsSelected in State then
      SetTextColor(Sender.Canvas.Handle, clBlue);

    // Drawing the column text for each node
    for i := 0 to hdrColumns.Sections.Count - 1 do
    begin
      NodeRect := CTNode.DisplayRect(True);
      if i > 0 then
        NodeRect.Left := hdrColumns.Sections[i].Left;
      NodeRect.Right := hdrColumns.Sections[i].Right;
      Text := CTNode.Columns[i];
      Sender.Canvas.TextRect(NodeRect, Text,[tfVerticalCenter, tfSingleLine, tfWordEllipsis, tfLeft]);
    end;

  end;

  PaintImages := False;
  DefaultDraw := False;
  end;
end;

procedure TColumnTreeFrame.tvTreeChange(Sender: TObject; Node: TTreeNode);
begin
  FSelNode := Node as TColumnTreeNode;
end;

procedure TColumnTreeFrame.tvTreeCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TColumnTreeNode;
end;

// override ApplicationShowHint to assign TTreeHintWindow for tvTree
{procedure TColumnTreeFrame.ApplicationShowHint(var HintStr: String;
  var CanShow: Boolean; var HintInfo: VCL.Controls.THintInfo);
begin
  if HintInfo.HintControl = tvTree then
  begin
    HintInfo.HintWindowClass := TTreeViewHintWindowClass;
    if tvHintWindowClass <> nil then
      if tvHintWindowClass.GetFontSize <> Application.MainForm.Font.Size then
        tvHintWindowClass.SetFontSize(Application.MainForm.Font.Size);
  end;
end;}

end.
