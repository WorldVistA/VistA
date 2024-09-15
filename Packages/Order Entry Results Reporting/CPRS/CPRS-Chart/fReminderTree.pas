unit fReminderTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, ComCtrls, ImgList, ORFn, Menus, fBase508Form,
  VA508AccessibilityManager, VA508ImageListLabeler;

const
  WM_FORCERESYNC = WM_APP + 101;

 type
  TtvRem508Manager = class(TVA508ComponentManager)
  private
    function getDueDate(sData : String): String;
    function getLastOcc(sData : String): String;
    function getPriority(sData : String): String;
    function getName(sData : String): String;
    function getImgText(Node : TORTreeNode): String;
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
  end;

  TfrmReminderTree = class(TfrmBase508Form)
    pnlTop: TPanel;
    tvRem: TORTreeView;
    hcRem: THeaderControl;
    pnlTopRight: TPanel;
    bvlGap: TBevel;
    lbRem: TORListBox;
    mmMain: TMainMenu;
    memAction: TMenuItem;
    memEvalAll: TMenuItem;
    memEval: TMenuItem;
    N2: TMenuItem;
    memRefresh: TMenuItem;
    memEvalCat: TMenuItem;
    mnuCoverSheet: TMenuItem;
    mnuExit: TMenuItem;
    imgLblReminders: TVA508ImageListLabeler;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tvRemExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvRemCollapsed(Sender: TObject; Node: TTreeNode);
    procedure pnlTopResize(Sender: TObject);
    procedure lbRemDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbRemChange(Sender: TObject);
    procedure lbRemClick(Sender: TObject);
    procedure tvRemEnter(Sender: TObject);
    procedure tvRemExit(Sender: TObject);
    procedure hcRemSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure tvRemClick(Sender: TObject);
    procedure tvRemChange(Sender: TObject; Node: TTreeNode);
    procedure tvRemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure memEvalClick(Sender: TObject);
    procedure memEvalAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure memRefreshClick(Sender: TObject);
    procedure memActionClick(Sender: TObject);
    procedure memEvalCatClick(Sender: TObject);
    procedure mnuCoverSheetClick(Sender: TObject);
    procedure tvRemNodeCaptioning(Sender: TObject; var Caption: String);
    procedure mnuExitClick(Sender: TObject);
    procedure tvRemKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    tvRem508Manager : TtvRem508Manager;
    FLinking: boolean;
    FSortOrder: integer;
    FSortAssending: boolean;
    FSorting: boolean;
    FUpdating: boolean;
    memView: TORMenuItem;
    DateColWidth: integer;
    LastDateColWidth: integer;
    PriorityColWidth: integer;
    procedure SetRemHeaderSectionWidth( SectionIndex: integer; NewWidth: integer);
  protected
    procedure Resync(FromTree: boolean);
    procedure RemindersChanged(Sender: TObject);
    procedure ResetlbItems(RootNode: TTreeNode);
    procedure LinkTopControls(FromTree: boolean);
    procedure SyncTopControls(FromTree: boolean);
    procedure SortNode(const Node: TTreeNode);
    function SortData(Node: TORTreeNode): string;
//    procedure PositionToReminder(Sender: TObject);
    procedure ProcessedRemindersChanged(Sender: TObject);
    procedure WMMenuSelect(var Msg: TWMMenuSelect) ; message WM_MENUSELECT;
    procedure WMForceResync(var Msg: TMessage) ; message WM_FORCERESYNC;
  public
    procedure EnableActions;
    procedure SetFontSize( NewFontSize: integer);
  end;

procedure ViewReminderTree;

var
  frmReminderTree: TfrmReminderTree = nil;
  RemTreeDlgLeft: integer = 0;
  RemTreeDlgTop: integer = 0;
  RemTreeDlgWidth: integer = 0;
  RemTreeDlgHeight: integer = 0;

const
  ReminderTreeName = 'frmReminderTree';
  
implementation

uses uReminders, dShared, uConst, fReminderDialog, fNotes, rMisc,
     rReminders, fRemCoverSheet, VA2006Utils, VA508AccessibilityRouter, VAUtils;

{$R *.DFM}

const
  UnscaledDateColWidth = 70;
  UnscaledLastDateColWidth = 89;
  UnscaledPriorityColWidth = 43;

procedure ViewReminderTree;

begin
  if(not InitialRemindersLoaded) then
    StartupReminders;
  if(not assigned(frmReminderTree)) then
    frmReminderTree := TfrmReminderTree.Create(Application);
  frmReminderTree.Show;
end;

procedure TfrmReminderTree.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;
                                                              
procedure TfrmReminderTree.FormCreate(Sender: TObject);
begin
  FixHeaderControlDelphi2006Bug(hcRem);
  memView := TORMenuItem.Create(mmMain);
  memView.Caption := '&View';
  memView.Add(TORMenuItem.Create(memView));
  mmMain.Items.Insert(0, memView);

  bvlGap.Height := GetSystemMetrics(SM_CYHSCROLL);
  FSortOrder := -1;
  FSortAssending := TRUE;
  SetReminderMenuSelectRoutine(memView);
  NotifyWhenRemindersChange(RemindersChanged);
//  NotifyWhenProcessingReminderChanges(PositionToReminder);
  ProcessedReminders.Notifier.NotifyWhenChanged(ProcessedRemindersChanged);
  SetFontSize(MainFontSize);
  SetReminderFormBounds(Self, 0, 0, Self.Width, Self.Height,
                        RemTreeDlgLeft, RemTreeDlgTop, RemTreeDlgWidth, RemTreeDlgHeight);
  tvRem508Manager := TtvRem508Manager.Create;
  amgrMain.ComponentManager[tvRem] := tvRem508Manager;
end;

procedure TfrmReminderTree.LinkTopControls(FromTree: boolean);
var
  idx: integer;

begin
  if(not FLinking) then
  begin
    FLinking := TRUE;
    try
      if(FromTree) then
      begin
        if(assigned(tvRem.Selected)) then
        begin
          idx := lbRem.Items.IndexOfObject(tvRem.Selected);
          lbRem.ItemIndex := idx;
          tvRem.Selected := TTreeNode(lbRem.Items.Objects[lbRem.ItemIndex]);
          tvRem.SetFocus;
        end
        else
          lbRem.ItemIndex := -1;
      end
      else
      begin
        if(lbRem.ItemIndex < 0) then
          tvRem.Selected := nil
        else
          begin
            tvRem.Selected := TTreeNode(lbRem.Items.Objects[lbRem.ItemIndex]);
            if not tvRem.Focused then
              tvRem.SetFocus;
          end;
      end;
    finally
      FLinking := FALSE;
    end;
  end;
end;

procedure TfrmReminderTree.RemindersChanged(Sender: TObject);
const
  ARTxt = 'Available Reminders';

var
  OldUpdating: boolean;

begin
  EnableActions;
  if(GetReminderStatus = rsNone) then
  begin
    tvRem.Selected := nil;
    Close;
    exit;
  end;
  OldUpdating := FUpdating;
  try
    FUpdating := TRUE;
    lbRem.Items.BeginUpdate;
    try
      try
        BuildReminderTree(tvRem);
        lbRem.Clear;
        ResetlbItems(nil);
        LinkTopControls(TRUE);
        SyncTopControls(TRUE);
        pnlTopResize(Self);
      finally
        FUpdating := FALSE;
        tvRem.Invalidate;
        lbRem.Invalidate;
      end;
      if(RemindersEvaluatingInBackground) then
        hcRem.Sections[0].Text := ARTxt + ' (Evaluating Reminders...)'
      else
        hcRem.Sections[0].Text := ARTxt;
    finally
      lbRem.Items.EndUpdate;
    end;
  finally
    FUpdating := OldUpdating;
  end;
end;

procedure TfrmReminderTree.ResetlbItems(RootNode: TTreeNode);
var
  Firsti, i: integer;
  First, Node: TTreeNode;
  sl: TStringList;
  lvl: integer;
  Add2LB: boolean;
  Tmp, Data: string;

  function IsVis(Node: TTreeNode): boolean; // IsVisible doesn't work when updating
  begin
    Result := TRUE;
    Node := Node.Parent;
    while(Result and (assigned(Node))) do
    begin
      Result := Node.Expanded;
      Node := Node.Parent;
    end;
  end;

begin
  if(not FSorting) then
  begin
    if(assigned(RootNode)) then
    begin
      Node := RootNode.GetFirstChild;
      lvl := RootNode.Level;
      Add2LB := RootNode.Expanded;
      Firsti := lbRem.Items.IndexOfObject(RootNode)+1;
    end
    else
    begin
      Node := tvRem.Items.GetFirstNode;
      lvl := -1;
      Add2LB := TRUE;
      Firsti := 0;
    end;
    First := Node;
    if(assigned(Node)) then
    begin
      sl := TStringList.Create;
      try
        sl.Assign(lbRem.Items); // Must use regualr assign, FastAssign doesn't copy objects.
        while(assigned(Node) and (Node.Level > lvl)) do
        begin
          i := sl.IndexOfObject(Node);
          if(i >= 0) then
            sl.Delete(i);
          Node := Node.GetNext;
        end;
        if(Add2LB) then
        begin
          i := Firsti;
          Node := First;
          while(assigned(Node) and (Node.Level > lvl)) do
          begin
            if(IsVis(Node)) then
            begin
              Tmp := TORTreeNode(Node).StringData;
              Data := Piece(Tmp,U,RemTreeDateIdx) + U + Piece(Tmp,U,RemTreeDateIdx+1) + U +
                      RemPriorityText[StrToIntDef(Piece(Tmp, U, 5), 2)];
              sl.InsertObject(i, Data, Node);
              inc(i);
            end;
            Node := Node.GetNext;
          end;
        end;
        lbRem.Items.Assign(sl);
      finally
        sl.Free;
      end;
    end;
  end;
end;

procedure TfrmReminderTree.SyncTopControls(FromTree: boolean);
begin
  if(lbRem.Items.Count > 0) and (tvRem.TopItem <> lbRem.Items.Objects[lbRem.TopIndex]) then
  begin
    if(FromTree) then
      lbRem.TopIndex := lbRem.Items.IndexOfObject(tvRem.TopItem)
    else
      tvRem.TopItem := TTreeNode(lbRem.Items.Objects[lbRem.TopIndex]);
  end;
end;

procedure TfrmReminderTree.tvRemExpanded(Sender: TObject; Node: TTreeNode);
begin
  if(FUpdating) then exit;
  FUpdating := TRUE;
  try
    tvRem.Selected := Node;
    ResetlbItems(Node);
    pnlTopResize(Self);
  finally
    FUpdating := FALSE;
  end;
end;

procedure TfrmReminderTree.tvRemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_LEFT) or (Key = VK_RIGHT) then  tvRemClick(Sender);    
end;

procedure TfrmReminderTree.tvRemCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
  if(FUpdating) then exit;
  FUpdating := TRUE;
  try
    tvRem.Selected := Node;
    ResetlbItems(Node);
    pnlTopResize(Self);
  finally
    FUpdating := FALSE;
  end;
end;

procedure TfrmReminderTree.pnlTopResize(Sender: TObject);
var
  Tmp,Adj: integer;

begin
  Tmp := DateColWidth + LastDateColWidth + PriorityColWidth + 4;
  if(lbRem.Width <> (lbRem.ClientWidth + 4)) then
    Adj := ScrollBarWidth
  else
    Adj := 0;
  pnlTopRight.Width := Tmp + Adj;
  Tmp := pnlTop.Width - DateColWidth - LastDateColWidth - PriorityColWidth - 2 - Adj;
  SetRemHeaderSectionWidth( 0, Tmp);
  tvRem.Items.BeginUpdate;
  try
    tvRem.Height := pnlTop.Height - hcRem.Height;
    if(tvRem.Width <> (tvRem.ClientWidth+4)) then
      inc(Tmp, ScrollBarWidth);
    tvRem.Width := Tmp;
  finally
    tvRem.Items.EndUpdate;
  end;
  bvlGap.Visible := (tvRem.Height <> (tvRem.ClientHeight+4));
end;

procedure TfrmReminderTree.lbRemDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Tmp: string;
  Flags: Longint;

begin
  SyncTopControls(FALSE);
  if (odSelected in State) then
  begin
    if((ActiveControl = lbRem) or (ActiveControl = tvRem)) then
    begin
      lbRem.Canvas.Brush.Color := clHighlight;
      lbRem.Canvas.Font.Color := clHighlightText
    end
    else
    begin
      lbRem.Canvas.Brush.Color := clInactiveBorder;
      lbRem.Canvas.Font.Color := clWindowText;
    end;
  end;
  Flags := lbRem.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER);
  Tmp := piece(lbRem.Items[Index],U,1);
  lbRem.Canvas.FillRect(Rect);
  Inc(Rect.Left, 6);
  DrawText(lbRem.Canvas.Handle, PChar(Tmp), Length(Tmp), Rect, Flags);
  inc(Rect.Left, DateColWidth);
  Tmp := piece(lbRem.Items[Index],U,2);
  DrawText(lbRem.Canvas.Handle, PChar(Tmp), Length(Tmp), Rect, Flags);
  inc(Rect.Left, LastDateColWidth);
  Tmp := piece(lbRem.Items[Index],U,3);
  DrawText(lbRem.Canvas.Handle, PChar(Tmp), Length(Tmp), Rect, Flags);
end;

procedure TfrmReminderTree.lbRemChange(Sender: TObject);
begin
  Resync(FALSE);
  tvRem.SetFocus;
end;

procedure TfrmReminderTree.lbRemClick(Sender: TObject);
begin
  tvRem.SetFocus;
end;

procedure TfrmReminderTree.tvRemEnter(Sender: TObject);
begin
  if(FUpdating) then exit;
  if(ActiveControl = lbRem) or (ActiveControl = tvRem) then
    lbRem.Invalidate;
end;

procedure TfrmReminderTree.tvRemExit(Sender: TObject);
begin
  if(FUpdating) then exit;
  if(ActiveControl <> lbRem) and (ActiveControl <> tvRem) then
    lbRem.Invalidate;
end;

procedure TfrmReminderTree.hcRemSectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
var
  i, SortIdx: integer;
  exp: boolean;
  Sel, Node: TTreeNode;

begin
  SortIdx := -1;
  for i := 0 to 3 do
  begin
    if(Section = hcRem.Sections[i]) then
    begin
      SortIdx := i;
      break;
    end;
  end;
  if(SortIdx >= 0) then
  begin
    Sel := tvRem.Selected;
    if(FSortOrder = SortIdx) then
      FSortAssending := not FSortAssending
    else
      FSortOrder := SortIdx;

    FSorting := TRUE;
    tvRem.Items.BeginUpdate;
    try
      Node := tvRem.Items.GetFirstNode;
      while(assigned(Node)) do
      begin
        exp := Node.Expanded;
        SortNode(Node);
        if(Node.Expanded <> exp) then
          Node.Expanded := exp;
        Node := Node.GetNextSibling;
      end;
    finally
      tvRem.Items.EndUpdate;
      FSorting := FALSE;
    end;
    ResetlbItems(nil);
    tvRem.Selected := Sel;
  end;
end;

procedure TfrmReminderTree.SortNode(const Node: TTreeNode);
var
  i: integer;
  sl: TStringList;
  Tmp, TmpLast: TTreeNode;
  exp: boolean;

begin
  if(Node.HasChildren) then
  begin
    sl := TStringList.Create;
    try
      Tmp := Node.GetFirstChild;
      while assigned(Tmp) do
      begin
        sl.AddObject(SortData(TORTreeNode(Tmp)), Tmp);
        Tmp := Tmp.GetNextSibling;
      end;
      sl.sort;
      TmpLast := Node;
      for i := 0 to sl.Count-1 do
      begin
        if(FSortAssending) then
          Tmp := TTreeNode(sl.Objects[i])
        else
          Tmp := TTreeNode(sl.Objects[sl.Count-1-i]);
        exp := Tmp.Expanded;
        if(i = 0) then
          Tmp.MoveTo(TmpLast, naAddChildFirst)
        else
          Tmp.MoveTo(TmpLast, naInsert);
        TmpLast := Tmp;
        SortNode(Tmp);
        Tmp.Expanded := exp;
      end;
    finally
      sl.Free;
    end;
  end;
end;

function TfrmReminderTree.SortData(Node: TORTreeNode): string;

  function ZForm(str: string; Num: integer): string;
  begin
    Result := copy(StringOfChar('0', Num)+str,1+length(str),Num);
  end;

begin
  Result := ZForm(piece(Node.StringData, U, RemTreeDateIdx+2),5);
  case FSortOrder of
    1: Result := ZForm(Piece(Node.StringData, U, 3), 15)+'.'+Result;
    2: Result := ZForm(Piece(Node.StringData, U, 4), 15)+'.'+Result;
    3: Result := Piece(Node.StringData, U, 5)+'.'+Result;
  end;
end;

procedure TfrmReminderTree.tvRemClick(Sender: TObject);
begin
  Resync(TRUE);
end;

procedure TfrmReminderTree.tvRemChange(Sender: TObject; Node: TTreeNode);
var
  p1: string;

begin
  memView.Data := '';
  if(assigned(Node)) then
  begin
    p1 := Piece((Node as TORTreeNode).StringData, U, 1);
    if(Copy(p1,1,1) = RemCode) then
    begin
      memView.Data := (Node as TORTreeNode).StringData;
    end;
  end;
  EnableActions;

  Resync(TRUE);
end;

procedure TfrmReminderTree.tvRemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //Resync(TRUE);
end;

procedure TfrmReminderTree.Resync(FromTree: boolean);
begin
  if(FUpdating) then exit;
  FUpdating := TRUE;
  try
    LinkTopControls(FromTree);
    SyncTopControls(FromTree);
  finally
    FUpdating := FALSE;
  end;
end;

{procedure TfrmReminderTree.PositionToReminder(Sender: TObject);
begin
  if(assigned(Sender)) then
  begin
    if(Sender is TReminder) then
    begin
      tvRem.Selected := tvRem.FindPieceNode(RemCode + (Sender as TReminder).IEN, 1);
      if(assigned(tvRem.Selected)) then
        TORTreeNode(tvRem.Selected).EnsureVisible;
    end;
  end
  else
    tvRem.Selected := nil;
end;}

procedure TfrmReminderTree.memEvalClick(Sender: TObject);
var
  Node: TORTreeNode;
  p1: string;

begin
  Node := TORTreeNode(tvRem.Selected);
  if(assigned(Node)) then
  begin
    p1 := Piece(Node.StringData, U, 1);
    if(Copy(p1,1,1) = RemCode) then
      EvalReminder(StrToIntDef(Copy(p1,2,MaxInt),0));
  end;
end;

procedure TfrmReminderTree.EnableActions;
var
  OK: boolean;
  Node: TORTreeNode;
  p1: string;

begin
  Node := TORTreeNode(tvRem.Selected);
  if(assigned(Node)) then
    p1 := Piece(Node.StringData, U, 1)
  else
    p1 := '';
  if(assigned(Node)) then
    OK := (Copy(p1,1,1) = RemCode)
  else
    OK := FALSE;
  memEval.Enabled := OK;
  memEvalAll.Enabled := (ProcessedReminders.Count > 0);
  memRefresh.Enabled := (not ReminderDialogActive);
  mnuCoverSheet.Enabled := (NewRemCoverSheetListActive or CanEditAllRemCoverSheetLists);
  memAction.Enabled := (OK or memEvalAll.Enabled or memRefresh.Enabled or mnuCoverSheet.Enabled);
  if(assigned(Node)) then
    OK := ((Copy(p1,1,1) = CatCode) and (p1 <> OtherCatID) and (Node.HasChildren))
  else
    OK := FALSE;
  memEvalCat.Enabled := OK;
  memEvalCat.Tag := integer(Node);
end;

procedure TfrmReminderTree.ProcessedRemindersChanged(Sender: TObject);
begin
  EnableActions;
end;

procedure TfrmReminderTree.memEvalAllClick(Sender: TObject);
begin
  EvalProcessed;
end;

procedure TfrmReminderTree.FormDestroy(Sender: TObject);
begin
  frmReminderTree := nil;
  ProcessedReminders.Notifier.RemoveNotify(ProcessedRemindersChanged);
//  RemoveNotifyWhenProcessingReminderChanges(PositionToReminder);
  RemoveNotifyRemindersChange(RemindersChanged);
  RemTreeDlgLeft   := Self.Left;
  RemTreeDlgTop    := Self.Top;
  RemTreeDlgWidth  := Self.Width;
  RemTreeDlgHeight := Self.Height;
end;

procedure TfrmReminderTree.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  control: TWinControl;
begin
  control := FindVCLWindow(MousePos);
  inherited;
  if (control = tvRem) then
  begin
    PostMessage(Handle, WM_FORCERESYNC, 1, 0);
  end;
end;

procedure TfrmReminderTree.memRefreshClick(Sender: TObject);
begin
  KillObj(@ReminderDialogInfo, TRUE);
  UpdateReminderDialogStatus;
  EnableActions;
end;


//Hack for jaws so that "checked" and "not checked" will be read
procedure TfrmReminderTree.WMMenuSelect(var Msg: TWMMenuSelect) ;
var
 menuItem : TMenuItem;
begin
 inherited;
 If ScreenReaderSystemActive then
 begin
  if (Msg.MenuFlag <> $FFFF) or (Msg.IDItem <> 0) then
  begin
   if Msg.MenuFlag and MF_POPUP <> MF_POPUP then
   begin
    menuItem := Self.Menu.FindItem(Msg.IDItem, fkCommand) ;
    if (UpperCase(menuItem.Parent.Caption) = '&VIEW') and (menuItem.ImageIndex > 0) then
    begin
      if (menuItem.ImageIndex mod 2) > 0 then
       GetScreenReader.Speak('Checked')
      else
       GetScreenReader.Speak('Not Checked');
    end;

   end;
  end;
 end;

end;

procedure TfrmReminderTree.WMForceResync(var Msg: TMessage);
begin
  Resync((Msg.WParam <> 0));
end;

procedure TfrmReminderTree.memActionClick(Sender: TObject);
begin
  EnableActions;
end;

procedure TfrmReminderTree.memEvalCatClick(Sender: TObject);
begin
  EvaluateCategoryClicked(nil, Sender);
end;

procedure TfrmReminderTree.mnuCoverSheetClick(Sender: TObject);
begin
  EditCoverSheetReminderList(not CanEditAllRemCoverSheetLists);
end;

procedure TfrmReminderTree.SetFontSize(NewFontSize: integer);
var
  TotalWidth: integer;
begin
  DateColWidth := ResizeWidth(Font, MainFont, UnscaledDateColWidth);
  LastDateColWidth := ResizeWidth(Font, MainFont, UnscaledLastDateColWidth);
  PriorityColWidth := ResizeWidth(Font, MainFont, UnscaledPriorityColWidth);
  ResizeAnchoredFormToFont(self);
  TotalWidth := hcRem.Width;
  SetRemHeaderSectionWidth( 0, TotalWidth - DateColWidth - LastDateColWidth - PriorityColWidth);
  SetRemHeaderSectionWidth( 1, DateColWidth);
  SetRemHeaderSectionWidth( 2, LastDateColWidth);
  SetRemHeaderSectionWidth( 3, PriorityColWidth);

  lbRem.ItemHeight := ((Abs(Font.Height)+ 6) div 2)*2; //tvRem.ItemHeight;
  //This is called "best guess calibration"
  if Font.Size > 12 then lbRem.ItemHeight := lbRem.ItemHeight + 2;
  //I am reluctant to use an alignment on the tvRem as there si lots of resizing
  //tricks going on with the scroll bar at the bottom.
  tvRem.Top := hcRem.Top+hcRem.Height;
  pnlTopResize(self);
end;

procedure TfrmReminderTree.SetRemHeaderSectionWidth( SectionIndex: integer; NewWidth: integer);
begin
  hcRem.Sections[SectionIndex].MinWidth := 0;
  hcRem.Sections[SectionIndex].MaxWidth := NewWidth;
  hcRem.Sections[SectionIndex].MinWidth := NewWidth;
  hcRem.Sections[SectionIndex].Width := NewWidth;
end;

procedure TfrmReminderTree.tvRemNodeCaptioning(Sender: TObject;
  var Caption: String);
var
  StringData: string;
begin
  StringData := (Sender as TORTreeNode).StringData;
  if (Length(StringData) > 0) and (StringData[1] = 'R') then  //Only tag reminder statuses
    case StrToIntDef(Piece(StringData,'^',6 {Due}),-1) of
      0: Caption := Caption + ' -- Applicable';
      1: Caption := Caption + ' -- DUE';
      2: Caption := Caption + ' -- Not Applicable';
      else Caption := Caption + ' -- Not Evaluated';
    end;
end;

procedure TfrmReminderTree.mnuExitClick(Sender: TObject);
begin
  Close;
end;

{ TGrdLab508Manager }

constructor TtvRem508Manager.Create;
begin
  inherited Create([mtValue, mtItemChange]);
end;

function TtvRem508Manager.getDueDate(sData: String): String;
begin
  Result := Piece(sData,U,3);
  if Result <> '' then
    Result := ' Due Date: ' + FormatFMDateTimeStr('mm/dd/yyyy',Result);
end;

function TtvRem508Manager.getImgText(Node: TORTreeNode): String;
begin
  Result := '';
  if Node.ImageIndex > -1 then
    Result := frmReminderTree.imgLblReminders.RemoteLabeler.Labels.Items[Node.ImageIndex].Caption + ' ';
end;

function TtvRem508Manager.GetItem(Component: TWinControl): TObject;
var
  tv : TORTreeView;
begin
  tv := TORTreeView(Component);
  Result :=  tv.Selected;
end;

function TtvRem508Manager.getLastOcc(sData: String): String;
begin
  Result := Piece(sData,U,4);
  if Result <> '' then
    Result := ' Last Occurrence: ' + FormatFMDateTimeStr('mm/dd/yyyy',Result);
end;

function TtvRem508Manager.getName(sData: String): String;
begin
  Result := Piece(sData,U,2);
end;

function TtvRem508Manager.getPriority(sData: String): String;
begin
  Result := Piece(sData,U,5);
  if Result = '2' then
    Result := '';
  if Result <> '' then
    Result := ' Priority: ' + Result;
end;

function TtvRem508Manager.GetValue(Component: TWinControl): string;
var
    Node: TORTreeNode;
begin
  Node := TORTreeNode(TORTreeView(Component).Selected);
  Result := getImgText(Node) + getName(Node.StringData) + getDueDate(Node.StringData) +
            getLastOcc(Node.StringData) + getPriority(Node.StringData);
end;


end.
