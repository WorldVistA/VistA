unit mTreeGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Types, Dialogs, ComCtrls, CommCtrl, Themes, UxTheme, ORFn, ExtCtrls, StdCtrls;

type

  TLexTreeNode = class(TTreeNode)
  private
    FVUID: string;
    FCode: string;
    FCodeSys: string;
    FCodeIEN: string;
    FCodeDescription: string;
    FCodeFullDescription: string;
    FDesignationID: string;
    FTargetCodeSys: string;
    FTargetCode: string;
    FTargetCodeIEN: string;
    FTargetCodeDescription: string;
    FParentIndex: string;
    FResultLine: string;
  public
//    Columns: TStrings;
    property VUID: string read FVUID write FVUID;
    property Code: string read FCode write FCode;
    property CodeSys: string read FCodeSys write FCodeSys;
    property CodeIEN: string read FCodeIEN write FCodeIEN;
    property CodeDescription: string read FCodeDescription write FCodeDescription;
    property CodeFullDescription: string read FCodeFullDescription write FCodeFullDescription;
    property DesignationID: string read FDesignationID write FDesignationID;
    property TargetCode: string read FTargetCode write FTargetCode;
    property TargetCodeSys: string read FTargetCodeSys write FTargetCodeSys;
    property TargetCodeIEN: string read FTargetCodeIEN write FTargetCodeIEN;
    property TargetCodeDescription: string read FTargetCodeDescription write FTargetCodeDescription;
    property ParentIndex: string read FParentIndex write FParentIndex;
    property ResultLine: string read fResultLine write FResultLine;
  end;

  TTreeGridFrame = class(TFrame)
    tv: TTreeView;
    pnlTop: TPanel;
    stTitle: TStaticText;
    pnlSpace: TPanel;
    pnlHint: TPanel;
    pnlTarget: TPanel;
    mmoTargetCode: TMemo;
    pnlTargetCodeSys: TPanel;
    pnlCode: TPanel;
    mmoCode: TMemo;
    pnlCodeSys: TPanel;
    pnlDesc: TPanel;
    mmoDesc: TMemo;
    pnlDescText: TPanel;
    procedure tvCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure pnlTopResize(Sender: TObject);
  private
    fHorizPanelSpace: integer;
    fVertPanelSpace: integer;
    fShowDesc: boolean;
    fShowCode: boolean;
    fShowTargetCode: boolean;
    tvHintText: String;
    fDefTreeViewWndProc: TWndMethod;
    function GetSelectedNode: TLexTreeNode;
    procedure SetSelectedNode(const Value: TLexTreeNode);
    procedure SetShowCode(const Value: boolean);
    procedure SetShowDescription(const Value: boolean);
    procedure SetShowTargetCode(const Value: boolean);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure ResizePanels;
    procedure PopulatePanels;
    procedure SetHorizPanelSpace(const Value: integer);
    function GetShowCode: boolean;
    function GetShowDescription: boolean;
    function GetShowTargetCode: boolean;
    procedure SetVertPanelSpace(const Value: integer);
    procedure SetCodeTitle(const Value: string);
    procedure SetDescTitle(const Value: string);
    procedure SetTargetTitle(const Value: string);
    function GetCodeTitle: string;
    function GetDescTitle: string;
    function GetTargetTitle: string;
    function NumLinesWrapped(mmo: TMemo): integer;
    function GetSeparatorSpace: integer;
    procedure SetSeparatorSpace(const Value: integer);
  protected
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    { Public declarations }
    procedure SetColumnTreeModel(ResultSet: TStrings);
    procedure TreeViewWndProc(var Message: TMessage);
    function FindNode(AValue:String; ByDesc: boolean = false): TLexTreeNode;
    property SelectedNode: TLexTreeNode read GetSelectedNode write SetSelectedNode;
    property ShowDescription: boolean read GetShowDescription write SetShowDescription;
    property ShowCode: boolean read GetShowCode write SetShowCode;
    property ShowTargetCode: boolean read GetShowTargetCode write SetShowTargetCode;
    property Title: string read GetTitle write SetTitle;
    property HorizPanelSpace: integer read fHorizPanelSpace write SetHorizPanelSpace;
    property VertPanelSpace: integer read fVertPanelSpace write SetVertPanelSpace;
    property DescTitle: string read GetDescTitle write SetDescTitle;
    property CodeTitle: string read GetCodeTitle write SetCodeTitle;
    property TargetTitle: string read GetTargetTitle write SetTargetTitle;
    property SeparatorSpace: integer read GetSeparatorSpace write SetSeparatorSpace;
    property DefTreeViewWndProc: TWndMethod read fDefTreeViewWndProc write fDefTreeViewWndProc;
    procedure ClearData;
  end;

implementation

uses Math, VAUtils;

{$R *.dfm}

const
  BUTTON_SIZE = 5;
  TreeExpanderSpacing = 6;

{ TTreeGridFrame }

procedure TTreeGridFrame.TreeViewWndProc(var Message: TMessage);
var
  Pt: TPoint;
  Node: TTreeNode;
  LItemRect: TRect;
  LMaxWidth: integer;
begin
  if Message.Msg = WM_NOTIFY then
  begin
    with TWMNotify(Message) do
    begin
      if NMHdr^.Code = TTN_NEEDTEXTW then
      begin
        if (PToolTipTextW(NMHdr)^.uFlags and TTF_IDISHWND) <> 0 then
        begin
          GetCursorPos(Pt);
          Pt := tv.ScreenToClient(Pt);
          Node := tv.GetNodeAt(Pt.X, Pt.Y);
          if Node <> nil then
          begin
            tvHintText := Node.Text;

            with PToolTipTextW(NMHdr)^ do
            begin
              lpszText := PWideChar(tvHintText);
              hInst := 0;
            end;

            LItemRect := Node.DisplayRect(True);
            if LItemRect.Left < 0 then
              LItemRect.Left := 0;
            LItemRect.TopLeft := tv.ClientToScreen
              (LItemRect.TopLeft);

            LMaxWidth := SendMessage(NMHdr^.hwndFrom, TTM_GETMAXTIPWIDTH, 0, 0);
            if LMaxWidth = -1 then
            begin
              LMaxWidth := 250; // use whatever you need...
              SendMessage(NMHdr^.hwndFrom, TTM_SETMAXTIPWIDTH, LMaxWidth, 0);
            end;

            SendMessage(NMHdr^.hwndFrom, TTM_ADJUSTRECT, WPARAM(True),
              LPARAM(@LItemRect));
            SetWindowPos(NMHdr^.hwndFrom, HWND_TOP, LItemRect.Left,
              LItemRect.Top, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or
              SWP_NOOWNERZORDER);

            Message.Result := 1;
          end;
        end;
      end;

      Exit;
    end;
  end;
  fDefTreeViewWndProc(Message);
end;

procedure TTreeGridFrame.ClearData;
begin
  tv.Items.Clear;
  if assigned(pnlHint) then begin
    fShowDesc := False;
    fShowCode := False;
    fShowTargetCode := False;
    SelectedNode := nil;  // fires off populate panels
  end;
end;

procedure TTreeGridFrame.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResizePanels;
end;

function TTreeGridFrame.FindNode(AValue: String; ByDesc: boolean = false): TLexTreeNode;
var
  Node: TLexTreeNode; // Current search node
  SearchText: string;    // search text
  StarPos: integer;      // position of indicator
begin
  AValue := Uppercase(AValue);
  Result := nil;
  if (tv.Items.Count <> 0) then begin
    Node := TLexTreeNode(tv.Items[0]);
    repeat
      if ByDesc then
        SearchText := Node.CodeDescription
      else
        SearchText := Node.Text;
      StarPos := Pos(' *', SearchText);
      if (StarPos > 0) then
        SearchText := UpperCase(Copy(SearchText, 1, StarPos - 1))
      else
        SearchText := UpperCase(SearchText);

      if (SearchText = AValue) then begin
        Result := Node;
        Result.MakeVisible;
        Result.Selected := True;
      end;
      Node := TLexTreeNode(Node.GetNext);
    until (assigned(Result) or (Node = nil));
  end;
end;

function TTreeGridFrame.GetCodeTitle: string;
begin
  Result := pnlCodeSys.Caption;
end;

function TTreeGridFrame.GetDescTitle: string;
begin
  Result := pnlDescText.Caption;
end;

function TTreeGridFrame.GetTargetTitle: string;
begin
  Result := pnlTargetCodeSys.Caption;
end;

function TTreeGridFrame.GetSelectedNode: TLexTreeNode;
begin
  Result := TLexTreeNode(tv.Selected);
end;

function TTreeGridFrame.GetSeparatorSpace: integer;
begin
  Result := pnlSpace.Height;
end;

function TTreeGridFrame.GetShowCode: boolean;
begin
  Result := fShowCode;
end;

function TTreeGridFrame.GetShowDescription: boolean;
begin
  Result := fShowDesc;
end;

function TTreeGridFrame.GetShowTargetCode: boolean;
begin
  Result := fShowTargetCode;
end;

function TTreeGridFrame.GetTitle: string;
begin
  Result := stTitle.Caption;
end;

function TTreeGridFrame.NumLinesWrapped(mmo: TMemo): integer;
var
  sl: TStringList;
  c: TCanvas;
begin
  c := TCanvas.Create;
  c.Font.Assign(mmo.Font);
  try
    c.Handle := GetDC(0);
    sl := WrapTextByPixels(mmo.lines.Text, mmo.Width, c, PreSeparatorChars, PostSeparatorChars);
    if assigned(sl) then begin
      Result := sl.Count;
      sl.Free;
    end else begin
      Result := 1;
    end;
  finally
    if assigned(c) then c.Free;
  end;
end;

procedure TTreeGridFrame.pnlTopResize(Sender: TObject);
begin
  ResizePanels;
end;

procedure TTreeGridFrame.PopulatePanels;
var
  x: string;
begin
  if assigned(SelectedNode) then begin
    if mmoDesc.Visible then
    begin
      x := trim(SelectedNode.CodeFullDescription);
      if x = '' then
        x := SelectedNode.CodeDescription;
      mmoDesc.Lines.Text := x;
    end;
    if pnlCodeSys.Visible and (SelectedNode.CodeSys <> '') then begin
      CodeTitle := SelectedNode.CodeSys + ':  ';
    end;
    if mmoCode.Visible and (SelectedNode.Code <> '') then begin
      mmoCode.Lines.Text := SelectedNode.Code;
    end;
    if pnlTargetCodeSys.Visible and (SelectedNode.TargetCodeSys <> '') then begin
      TargetTitle := SelectedNode.TargetCodeSys + ':  ';
    end;
    if mmoTargetCode.Visible and (SelectedNode.TargetCode <> '') then begin
      mmoTargetCode.Lines.Text := SelectedNode.TargetCode;
    end;
  end else begin
    if mmoDesc.Visible then begin
      mmoDesc.Lines.Clear;
    end;
    if mmoCode.Visible then begin
      mmoCode.Lines.Clear;
    end;
    if mmoTargetCode.Visible then begin
      mmoTargetCode.Lines.Clear;
    end;
  end;
  ResizePanels;
end;

procedure TTreeGridFrame.ResizePanels;
var
  MinWidth: integer;
  NumLines: integer;
  HintHeight: integer;
begin
  MinWidth := 0;
  HintHeight := 1;
  if assigned(pnlDesc) then begin
    if fShowDesc then begin
      NumLines := NumLinesWrapped(mmoDesc);
      pnlDesc.Height := TextHeightByFont(Font.Handle, mmoDesc.Lines.Text) * NumLines +
                        fVertPanelSpace * (NumLines - 1);
      MinWidth := Max(TextWidthByFont(Font.Handle, pnlDescText.Caption) + fHorizPanelSpace, MinWidth);
    end else begin
      pnlDesc.Height := 1;
    end;
    inc(HintHeight, pnlDesc.Height);
  end;
  if assigned(pnlCode) then begin
    pnlCode.Top := pnlDesc.Height + 1;
    if fShowCode then begin
      NumLines := NumLinesWrapped(mmoCode);
      pnlCode.Height := TextHeightByFont(Font.Handle, mmoCode.Lines.Text) * NumLines +
                        fVertPanelSpace * (NumLines - 1);
      MinWidth := Max(TextWidthByFont(Font.Handle, pnlCodeSys.Caption) + fHorizPanelSpace, MinWidth);
    end else begin
      pnlCode.Height := 1;
    end;
    inc(HintHeight, pnlCode.Height);
  end;
  if assigned(pnlTarget) then begin
    pnlTarget.Top := pnlCode.Top + pnlCode.Height + 1;
    if fShowTargetCode then begin
      NumLines := NumLinesWrapped(mmoTargetCode);
      pnlTarget.Height := TextHeightByFont(Font.Handle, mmoTargetCode.Lines.Text) * NumLines +
                         fVertPanelSpace * (NumLines - 1);
      MinWidth := Max(TextWidthByFont(Font.Handle, pnlTargetCodeSys.Caption) + fHorizPanelSpace, MinWidth);
    end else begin
      pnlTarget.Height := 1;
    end;
    inc(HintHeight, pnlTarget.Height);
  end;
  if assigned(pnlHint) then begin
    pnlHint.Height := HintHeight;
  end;
  if assigned(pnlDesc) then begin
    pnlDescText.Width := MinWidth;
  end;
  if assigned(pnlCode) then begin
    pnlCodeSys.Width := MinWidth;
  end;
  if assigned(pnlTarget) then begin
    pnlTargetCodeSys.Width := MinWidth;
  end;
end;

procedure TTreeGridFrame.SetCodeTitle(const Value: string);
begin
  pnlCodeSys.Caption := Value;
end;

procedure TTreeGridFrame.SetColumnTreeModel(ResultSet: TStrings);
var
  i: integer;
  Node: TLexTreeNode;
  RecStr, Desc: string;
begin
  if not assigned(ResultSet) or (ResultSet.Text = '') then begin
    ClearData;
  end else begin
    //  1     2        3      4       5       6         7          8     9       10
    //VUID^SCT TEXT^ICDCODE^ICDIEN^CODE SYS^CONCEPT^DESIGNATION^ICDVER^PARENT^FULL DESCRIPTION
    tv.Items.Clear;
    tv.Refresh;

    for i := 0 to ResultSet.Count - 1 do begin
      RecStr := ResultSet[i];
      Desc := Piece(RecStr, '^', 10);
      if Desc = '' then
        Desc := Piece(RecStr, '^', 2);
      if Desc <> '' then begin
        if Piece(RecStr, '^', 9) = '' then
          Node := TLexTreeNode(tv.Items.Add(nil, Desc))
        else
          Node := TLexTreeNode(tv.Items.AddChild(tv.Items[(StrToInt(Piece(RecStr, '^', 9))-1)], Desc));
        Node.ResultLine := RecStr;
        Node.VUID := Piece(RecStr, '^', 1);
        Node.Text := Desc;
        Node.CodeDescription := Piece(RecStr, '^', 2);
        Node.CodeFullDescription := Desc;

        Node.CodeIEN := Piece(RecStr, '^', 4);
        Node.CodeSys := Piece(RecStr, '^', 5);
        Node.Code := Piece(RecStr, '^', 6);
        Node.TargetCode := Piece(RecStr, '^', 3);
        Node.TargetCodeIEN := Piece(RecStr, '^', 4);
        Node.TargetCodeSys := Piece(RecStr, '^', 8);

        if Piece(RecStr, '^', 9) <> '' then
          Node.ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 9)) - 1);
      end;
    end;
    //sort tree nodes
    tv.AlphaSort(True);
    tv.Enabled := True;
    tv.SetFocus;
  end;
end;

procedure TTreeGridFrame.SetDescTitle(const Value: string);
begin
  pnlDescText.Caption := Value;
end;

procedure TTreeGridFrame.SetHorizPanelSpace(const Value: integer);
begin
  fHorizPanelSpace := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetTargetTitle(const Value: string);
begin
  pnlTargetCodeSys.Caption := Value;
end;

procedure TTreeGridFrame.SetSelectedNode(const Value: TLexTreeNode);
begin
  tv.Selected := Value;
  PopulatePanels;
end;

procedure TTreeGridFrame.SetSeparatorSpace(const Value: integer);
begin
  pnlSpace.Height := Value;
end;

procedure TTreeGridFrame.SetShowCode(const Value: boolean);
begin
  fShowCode := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetShowDescription(const Value: boolean);
begin
  fShowDesc := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetShowTargetCode(const Value: boolean);
begin
  fShowTargetCode := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetTitle(const Value: string);
begin
  stTitle.Caption := Value;
end;

procedure TTreeGridFrame.SetVertPanelSpace(const Value: integer);
begin
  fVertPanelSpace := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.tvChange(Sender: TObject; Node: TTreeNode);
begin
  SelectedNode := TLexTreeNode(Node);
end;

procedure TTreeGridFrame.tvCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TLexTreeNode;
end;

end.
