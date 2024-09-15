unit fDrawers;
{
bugs noticed:
  if delete only note (currently editing) then drawers and encounter button still enabled
}
interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ORCtrls, ComCtrls, ImgList, uTemplates,
  Menus, ORClasses, ORFn, fBase508Form, VA508AccessibilityManager,
  VA508ImageListLabeler, U_CPTPasteDetails;

type
  TDrawer = (odNone, odTemplates, odEncounter, odReminders, odOrders);
  TDrawers = set of TDrawer;

  TfrmDrawers = class(TfrmBase508Form)
    lbOrders: TORListBox;
    sbOrders: TORAlignSpeedButton;
    sbReminders: TORAlignSpeedButton;
    sbEncounter: TORAlignSpeedButton;
    sbTemplates: TORAlignSpeedButton;
    pnlOrdersButton: TKeyClickPanel;
    pnlRemindersButton: TKeyClickPanel;
    pnlEncounterButton: TKeyClickPanel;
    pnlTemplatesButton: TKeyClickPanel;
    lbEncounter: TORListBox;
    popTemplates: TPopupMenu;
    mnuPreviewTemplate: TMenuItem;
    pnlTemplates: TPanel;
    tvTemplates: TORTreeView;
    N1: TMenuItem;
    mnuCollapseTree: TMenuItem;
    N2: TMenuItem;
    mnuEditTemplates: TMenuItem;
    pnlTemplateSearch: TPanel;
    btnFind: TORAlignButton;
    edtSearch: TCaptionEdit;
    mnuFindTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    cbMatchCase: TCheckBox;
    cbWholeWords: TCheckBox;
    mnuInsertTemplate: TMenuItem;
    tvReminders: TORTreeView;
    mnuDefault: TMenuItem;
    N3: TMenuItem;
    mnuGotoDefault: TMenuItem;
    N4: TMenuItem;
    mnuViewNotes: TMenuItem;
    mnuCopyTemplate: TMenuItem;
    N5: TMenuItem;
    mnuViewTemplateIconLegend: TMenuItem;
    fldAccessTemplates: TVA508ComponentAccessibility;
    fldAccessReminders: TVA508ComponentAccessibility;
    imgLblReminders: TVA508ImageListLabeler;
    imgLblTemplates: TVA508ImageListLabeler;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormResize(Sender: TObject);
    procedure sbTemplatesClick(Sender: TObject);
    procedure sbEncounterClick(Sender: TObject);
    procedure sbRemindersClick(Sender: TObject);
    procedure sbOrdersClick(Sender: TObject);
    procedure sbResize(Sender: TObject);
    procedure tvTemplatesGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTemplatesGetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
    procedure tvTemplatesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvTemplatesClick(Sender: TObject);
    procedure tvTemplatesDblClick(Sender: TObject);
    procedure tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure tvTemplatesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvTemplatesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure popTemplatesPopup(Sender: TObject);
    procedure mnuPreviewTemplateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuCollapseTreeClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure ToggleMenuItem(Sender: TObject);
    procedure edtSearchEnter(Sender: TObject);
    procedure edtSearchExit(Sender: TObject);
    procedure mnuFindTemplatesClick(Sender: TObject);
    procedure tvTemplatesDragging(Sender: TObject; Node: TTreeNode;
      var CanDrag: Boolean);
    procedure mnuEditTemplatesClick(Sender: TObject);
    procedure mnuNewTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlTemplateSearchResize(Sender: TObject);
    procedure cbFindOptionClick(Sender: TObject);
    procedure mnuInsertTemplateClick(Sender: TObject);
    procedure tvRemindersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvRemindersCurListChanged(Sender: TObject; Node: TTreeNode);
    procedure mnuDefaultClick(Sender: TObject);
    procedure mnuGotoDefaultClick(Sender: TObject);
    procedure mnuViewNotesClick(Sender: TObject);
    procedure mnuCopyTemplateClick(Sender: TObject);
    procedure mnuViewTemplateIconLegendClick(Sender: TObject);
    procedure pnlTemplatesButtonEnter(Sender: TObject);
    procedure pnlTemplatesButtonExit(Sender: TObject);
    procedure tvRemindersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvRemindersNodeCaptioning(Sender: TObject;
      var Caption: String);
    procedure fldAccessTemplatesStateQuery(Sender: TObject; var Text: string);
    procedure fldAccessTemplatesInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure fldAccessRemindersInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure fldAccessRemindersStateQuery(Sender: TObject; var Text: string);
  private
    FOpenToNode: string;
    FOldMouseUp: TMouseEvent;
    FEmptyNodeCount: integer;
    FOldDragDrop: TDragDropEvent;
    FOldDragOver: TDragOverEvent;
    FOldFontChanged: TNotifyEvent;
    FTextIconWidth: integer;
    FInternalResize: integer;
    FHoldResize: integer;
    FOpenDrawer: TDrawer;
    FLastOpenSize: integer;
    FButtonHeights: integer;
    FInternalExpand :boolean;
    FInternalHiddenExpand :boolean;
    FAsk :boolean;
    FAskExp :boolean;
    FAskNode :TTreeNode;
    FDragNode :TTreeNode;
    FClickOccurred: boolean;
    FRichEditControl: ORExtensions.TRichEdit;
    FFindNext: boolean;
    FLastFoundNode: TTreeNode;
    FSplitter: TSplitter;
    FOldCanResize: TCanResizeEvent;
    FSplitterActive: boolean;
    FHasPersonalTemplates: boolean;
    FRemNotifyList: TORNotifyList;
    FDefTempPiece: integer;
    FNewNoteButton: TButton;
    FCurrentVisibleDrawers: TDrawers;
    FCurrentEnabledDrawers: TDrawers;
    FCopyMonitor: TCopyPasteDetails;
    FTemplateAccess: boolean;
    function GetAlign: TAlign;
    procedure SetAlign(const Value: TAlign);
    function MinDrawerControlHeight: integer;
    procedure DisableArrowKeyMove(Sender: TObject);
  protected
    procedure PositionToReminder(Sender: TObject);
    procedure RemindersChanged(Sender: TObject);
    procedure SetFindNext(const Value: boolean);
    procedure ReloadTemplates;
    procedure SetRichEditControl(const Value: ORExtensions.TRichEdit);
    procedure CheckAsk;
    procedure FontChanged(Sender: TObject);
    procedure InitButtons;
    procedure StartInternalResize;
    procedure EndInternalResize;
    procedure ResizeToVisible;
    function ButtonHeights: integer;
    procedure GetDrawerControls(Drawer: TDrawer;
                                var Btn: TORAlignSpeedButton;
                                var Ctrl: TWinControl);
    procedure AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
    procedure MoveCaret(X, Y: integer);
    procedure NewRECDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure NewRECDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
                             var Accept: Boolean);
    procedure InsertText;
    procedure SetSplitter(const Value: TSplitter);
    procedure SplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure SetSplitterActive(Active: boolean);
    function EnableDrawer(Drawer: TDrawer; EnableIt: boolean): boolean;
    function InsertOK(Ask: boolean): boolean;
    procedure OpenToNode(Path: string = '');
    property FindNext: boolean read FFindNext write SetFindNext;
  public
    constructor CreateDrawers(AOwner: TComponent; AParent: TWinControl;
                              VisibleDrawers, EnabledDrawers: TDrawers);
    procedure ExternalReloadTemplates;
    procedure OpenDrawer(Drawer: TDrawer);
    procedure ToggleDrawer(Drawer: TDrawer);
    procedure ShowDrawers(Drawers: TDrawers);
    procedure EnableDrawers(Drawers: TDrawers);
    procedure DisplayDrawers(Show: Boolean); overload;
    procedure DisplayDrawers(Show: Boolean; AEnable, ADisplay: TDrawers); overload;
    function CanEditTemplates: boolean;
    function CanEditShared: boolean;
    procedure UpdatePersonalTemplates;
    procedure NotifyWhenRemTreeChanges(Proc: TNotifyEvent);
    procedure RemoveNotifyWhenRemTreeChanges(Proc: TNotifyEvent);
    procedure ResetTemplates;
    property RichEditControl: ORExtensions.TRichEdit read FRichEditControl write SetRichEditControl;
    property NewNoteButton: TButton read FNewNoteButton write FNewNoteButton;
    property Splitter: TSplitter read FSplitter write SetSplitter;
    property HasPersonalTemplates: boolean read FHasPersonalTemplates;
    property LastOpenSize: integer read FLastOpenSize write FLastOpenSize;
    property DefTempPiece: integer read FDefTempPiece write FDefTempPiece;
    property TheOpenDrawer: TDrawer read FOpenDrawer;
    Property CopyMonitor: TCopyPasteDetails read fCopyMonitor write fCopyMonitor;
    property TemplateAccess: boolean read FTemplateAccess write FTemplateAccess;
  published
    property Align: TAlign read GetAlign write SetAlign;
  end;

{ There is a different instance of frmDrawers on each tab, so make the
  frmDrawers variable local to each tab, do not use this global var! }
//var
  //frmDrawers: TfrmDrawers;

const
  DrawerSplitters = 'frmDrawersSplitters';

implementation

uses fTemplateView, uCore, rTemplates, fTemplateEditor, dShared, uReminders,
  fReminderDialog, RichEdit, fRptBox, Clipbrd, fTemplateDialog, fIconLegend,
  VA508AccessibilityRouter, uVA508CPRSCompatibility, VAUtils, fFindingTemplates,
  System.Types, uMisc;

{$R *.DFM}

const
  BaseMinDrawerControlHeight = 24;
  FindNextText = 'Find Next';

function TfrmDrawers.MinDrawerControlHeight: integer;
begin
  result := ResizeHeight( BaseFont, MainFont, BaseMinDrawerControlHeight);
end;

procedure TfrmDrawers.ResizeToVisible;
var
  NewHeight: integer;
  od: TDrawer;
  Button: TORAlignSpeedButton;
  WinCtrl: TWinControl;

  procedure AllCtrls(AAlign: TAlign);
  var
    od: TDrawer;

  begin
    Parent.DisableAlign;
    try
      for od := succ(low(TDrawer)) to high(TDrawer) do
      begin
        GetDrawerControls(od, Button, WinCtrl);
        Button.Parent.Align := AAlign;
        WinCtrl.Align := AAlign;
      end;
    finally
      Parent.EnableAlign;
    end;
  end;

begin
  if((FHoldResize = 0) and Visible) then
  begin
    FButtonHeights := -1; //Force re-calculate
    NewHeight := 0;
    AllCtrls(alNone);
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Button, WinCtrl);
      if(Button.Parent.Visible) then
      begin
        Button.Parent.Top := NewHeight;
        inc(NewHeight, Button.Parent.Height);
        WinCtrl.Top := NewHeight;
        if(WinCtrl.Visible) then
        begin
          if(FLastOpenSize < 10) or (FLastOpenSize > (Parent.Height - 20)) then
          begin
            FLastOpenSize := (Parent.Height div 4) * 3;
            dec(FLastOpenSize, ButtonHeights);
            if(FLastOpenSize < MinDrawerControlHeight) then
              FLastOpenSize := MinDrawerControlHeight;
          end;
          inc(NewHeight, FLastOpenSize);
          WinCtrl.Height := FLastOpenSize;
        end
        else
          WinCtrl.Height := 0;
      end;
    end;
    AllCtrls(alTop);
    StartInternalResize;
    try
      ClientHeight := NewHeight
    finally
      EndInternalResize;
    end;
  end;
end;

procedure TfrmDrawers.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  od: TDrawer;
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;
  IsVisible: boolean;

begin
  if(FInternalResize = 0) then
  begin
    IsVisible := FALSE;
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Btn, Ctrl);
      if(Ctrl.Visible) then
      begin
        IsVisible := TRUE;
        break;
      end;
    end;
    if(not IsVisible) then
      NewHeight := ButtonHeights;
  end;
end;

function TfrmDrawers.ButtonHeights: integer;
begin
  if(FButtonHeights < 0) then
  begin
    FButtonHeights := 0;
    if(pnlOrdersButton.Visible) then
      inc(FButtonHeights, sbOrders.Height);
    if(pnlRemindersButton.Visible) then
      inc(FButtonHeights, sbReminders.Height);
    if(pnlEncounterButton.Visible) then
      inc(FButtonHeights, sbEncounter.Height);
    if(pnlTemplatesButton.Visible) then
      inc(FButtonHeights, sbTemplates.Height);
  end;
  Result := FButtonHeights;
end;

procedure TfrmDrawers.ShowDrawers(Drawers: TDrawers);
var
  od: TDrawer;
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;
  SaveLOS: integer;

begin
  if(FCurrentVisibleDrawers = []) or (Drawers <> FCurrentVisibleDrawers) then
  begin
    FCurrentVisibleDrawers := Drawers;
    SaveLOS := FLastOpenSize;
    OpenDrawer(odNone);
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Btn, Ctrl);
      Btn.Parent.Visible := (od in Drawers);
      Ctrl.Visible := FALSE;
      Ctrl.Height := 0;
    end;
    FButtonHeights := -1;
    FLastOpenSize := SaveLOS;
    ResizeToVisible;
    if(odReminders in Drawers) then
    begin
      NotifyWhenRemindersChange(RemindersChanged);
      NotifyWhenProcessingReminderChanges(PositionToReminder);
    end
    else
    begin
      RemoveNotifyRemindersChange(RemindersChanged);
      RemoveNotifyWhenProcessingReminderChanges(PositionToReminder);
    end;
  end;
end;

procedure TfrmDrawers.OpenDrawer(Drawer: TDrawer);
var
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;

begin
  if(FOpenDrawer <> Drawer) then
  begin
    StartInternalResize;
    try
      if(FOpenDrawer <> odNone) then
      begin
        GetDrawerControls(FOpenDrawer, Btn, Ctrl);
        Btn.Down := FALSE;
        with Btn.Parent as TPanel do
          if BevelOuter = bvLowered then
            BevelOuter := bvRaised;
        Ctrl.Visible := FALSE;
        Ctrl.Height := 0;
      end;
      if(Drawer = odNone) then
      begin
        FOpenDrawer := Drawer;
        SetSplitterActive(FALSE);
      end
      else
      begin
        GetDrawerControls(Drawer, Btn, Ctrl);
        if(Btn.Parent.Visible) and (Btn.Enabled) then
        begin
          SetSplitterActive(TRUE);
          Btn.Down := TRUE;
          with Btn.Parent as TPanel do
            if BevelOuter = bvRaised then
              BevelOuter := bvLowered;
          Ctrl.Visible := TRUE;
          FOpenDrawer := Drawer;
        end
        else
          SetSplitterActive(FALSE);
      end;
    finally
      EndInternalResize;
    end;
    ResizeToVisible;
  end;
end;

procedure TfrmDrawers.GetDrawerControls(Drawer: TDrawer;
  var Btn: TORAlignSpeedButton; var Ctrl: TWinControl);
begin
  case Drawer of
    odTemplates:
      begin
        Btn  := sbTemplates;
        Ctrl := pnlTemplates;
      end;

    odEncounter:
      begin
        Btn  := sbEncounter;
        Ctrl := lbEncounter;
      end;

    odReminders:
      begin
        Btn  := sbReminders;
        Ctrl := tvReminders;
      end;

    odOrders:
      begin
        Btn  := sbOrders;
        Ctrl := lbOrders;
      end;

    else
      begin
        Btn  := nil;
        Ctrl := nil;
      end;
  end;
end;

constructor TfrmDrawers.CreateDrawers(AOwner: TComponent; AParent: TWinControl;
                VisibleDrawers, EnabledDrawers: TDrawers);
begin
  FInternalResize := 0;
  StartInternalResize;
  try
    Create(AOwner);
    FButtonHeights := -1;
    FLastOpenSize := 0;
    FOpenDrawer := odNone;
    Parent := AParent;
    Align := alBottom;
    FOldFontChanged := Font.OnChange;
    Font.OnChange := FontChanged;
    InitButtons;
    ShowDrawers(VisibleDrawers);
    EnableDrawers(EnabledDrawers);
    Show;
  finally
    EndInternalResize;
  end;
end;

function TfrmDrawers.EnableDrawer(Drawer: TDrawer; EnableIt: boolean): boolean;
var
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;

begin
  inc(FHoldResize);
  try
    GetDrawerControls(Drawer, Btn, Ctrl);
    Btn.Enabled := EnableIt;
    Btn.Parent.Enabled := EnableIt;
    if(Drawer = FOpenDrawer) and (not Btn.Parent.Enabled) then
      OpenDrawer(odNone);
  finally
    dec(FHoldResize);
  end;
  ResizeToVisible;
  Result := EnableIt;
end;

procedure TfrmDrawers.EnableDrawers(Drawers: TDrawers);
var
  od: TDrawer;

begin
  if(FCurrentEnabledDrawers = []) or (Drawers <> FCurrentEnabledDrawers) then
  begin
    FCurrentEnabledDrawers := Drawers;
    inc(FHoldResize);
    try
      for od := succ(low(TDrawer)) to high(TDrawer) do
        EnableDrawer(od, (od in Drawers));
    finally
      dec(FHoldResize);
    end;
    ResizeToVisible;
  end;
end;

procedure TfrmDrawers.FormResize(Sender: TObject);
begin
  if(FInternalResize = 0) and (FOpenDrawer <> odNone) then
  begin
    FLastOpenSize := Height;
    dec(FLastOpenSize, ButtonHeights);
    if(FLastOpenSize < MinDrawerControlHeight) then
      FLastOpenSize := MinDrawerControlHeight;
    ResizeToVisible;
  end;
end;

procedure TfrmDrawers.sbTemplatesClick(Sender: TObject);
begin
  if(FOpenDrawer <> odTemplates) then
  begin
    ReloadTemplates;
    btnFind.Enabled := (edtSearch.Text <> '');
    pnlTemplateSearch.Visible := mnuFindTemplates.Checked;
  end;
  ToggleDrawer(odTemplates);
  if ScreenReaderActive then
    pnlTemplatesButton.SetFocus;
end;

procedure TfrmDrawers.sbEncounterClick(Sender: TObject);
begin
  ToggleDrawer(odEncounter);
end;

procedure TfrmDrawers.sbRemindersClick(Sender: TObject);
begin
  if(InitialRemindersLoaded) then
    ToggleDrawer(odReminders)
  else
  begin
    StartupReminders;
    if(GetReminderStatus = rsNone) then
    begin
      EnableDrawer(odReminders, FALSE);
      sbReminders.Down := FALSE;
      with sbReminders.Parent as TPanel do
        if BevelOuter = bvLowered then
          BevelOuter := bvRaised;
    end
    else
      ToggleDrawer(odReminders)
  end;
  if ScreenReaderActive then
    pnlRemindersButton.SetFocus;
end;

procedure TfrmDrawers.sbOrdersClick(Sender: TObject);
begin
  ToggleDrawer(odOrders);
end;

procedure TfrmDrawers.ToggleDrawer(Drawer: TDrawer);
begin
  if(Drawer = FOpenDrawer) then
    OpenDrawer(odNone)
  else
    OpenDrawer(Drawer);
end;

procedure TfrmDrawers.EndInternalResize;
begin
  if(FInternalResize > 0) then dec(FInternalResize);
end;

procedure TfrmDrawers.StartInternalResize;
begin
  inc(FInternalResize);
end;

procedure TfrmDrawers.sbResize(Sender: TObject);
var
  Button: TORAlignSpeedButton;
  Mar: integer; // Mar Needed because you can't assign Margin a negative value

begin
  Button := (Sender as TORAlignSpeedButton);
  Mar := (Button.Width - FTextIconWidth) div 2;
  if(Mar < 0) then
    Mar := 0;
  Button.Margin := Mar;
end;

procedure TfrmDrawers.InitButtons;
var
  od: TDrawer;
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;
  TmpWidth: integer;
  TmpHeight: integer;
  MaxHeight: integer;

begin
  StartInternalResize;
  try
    FTextIconWidth := 0;
    MaxHeight := 0;
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Btn, Ctrl);
      TmpWidth := Canvas.TextWidth(Btn.Caption) + Btn.Spacing +
                  (Btn.Glyph.Width div Btn.NumGlyphs) + 4;
      if(TmpWidth > FTextIconWidth) then
        FTextIconWidth := TmpWidth;
      TmpHeight := Canvas.TextHeight(Btn.Caption) + 9;
      if(TmpHeight > MaxHeight) then
        MaxHeight := TmpHeight;
    end;
    if(MaxHeight > 0) then
    begin
      for od := succ(low(TDrawer)) to high(TDrawer) do
      begin
        GetDrawerControls(od, Btn, Ctrl);
        Btn.Parent.Height := MaxHeight;
      end;
    end;
    Constraints.MinWidth := FTextIconWidth;
  finally
    EndInternalResize;
  end;
  ResizeToVisible;
end;

procedure TfrmDrawers.FontChanged(Sender: TObject);
var
  Ht: integer;

begin
  if(assigned(FOldFontChanged)) then
    FOldFontChanged(Sender);
  if(FInternalResize = 0) then
  begin
    InitButtons;
    ResizeToVisible;
    btnFind.Width := Canvas.TextWidth(FindNextText) + 10;
    btnFind.Height := edtSearch.Height;
    btnFind.Left := pnlTemplateSearch.Width - btnFind.Width;
    edtSearch.Width := pnlTemplateSearch.Width - btnFind.Width;
    cbMatchCase.Width := Canvas.TextWidth(cbMatchCase.Caption)+23;
    cbWholeWords.Width := Canvas.TextWidth(cbWholeWords.Caption)+23;
    Ht := Canvas.TextHeight(cbMatchCase.Caption);
    if(Ht < 17) then Ht := 17;
    pnlTemplateSearch.Height := edtSearch.Height + Ht;
    cbMatchCase.Height := Ht;
    cbWholeWords.Height := Ht;
    cbMatchCase.Top := edtSearch.Height;
    cbWholeWords.Top := edtSearch.Height;
    pnlTemplateSearchResize(Sender);
  end;
end;

procedure TfrmDrawers.AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
begin
  dmodShared.AddTemplateNode(tvTemplates, FEmptyNodeCount, tmpl, FALSE, Owner);
end;

procedure TfrmDrawers.tvTemplatesGetImageIndex(Sender: TObject;
  Node: TTreeNode);

begin
  Node.ImageIndex := dmodShared.ImgIdx(Node);
end;

procedure TfrmDrawers.tvTemplatesGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := dmodShared.ImgIdx(Node);
end;

procedure TfrmDrawers.tvTemplatesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if(assigned(Node)) then
  begin
    if(Dragging) then EndDrag(FALSE);
    if(not FInternalExpand) then
    begin
      if assigned(Node.Data) and (TTemplate(Node.Data).RealType = ttGroup) then
      begin
        FAsk := TRUE;
        FAskExp := TRUE;
        AllowExpansion := FALSE;
        FAskNode := Node;
      end;
    end;
    if(AllowExpansion) then
    begin
      FClickOccurred := FALSE;
      AllowExpansion := dmodShared.ExpandNode(tvTemplates, Node, FEmptyNodeCount);
      if(FInternalHiddenExpand) then AllowExpansion := FALSE;
    end;
  end;
end;

procedure TfrmDrawers.CheckAsk;
begin
  if(FAsk) then
  begin
    FAsk := FALSE;
    FInternalExpand := TRUE;
    try
      if(FAskExp) then
        FAskNode.Expand(FALSE)
      else
        FAskNode.Collapse(FALSE);
    finally
      FInternalExpand := FALSE;
    end;
  end;
end;

procedure TfrmDrawers.tvTemplatesClick(Sender: TObject);
begin
  FClickOccurred := TRUE;
  CheckAsk;
end;

procedure TfrmDrawers.tvTemplatesDblClick(Sender: TObject);
begin
  if(not FClickOccurred) then CheckAsk
  else
  begin
    FAsk := FALSE;
    if AssignedAndHasData(tvTemplates.Selected) and
       (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup]) then
      InsertText;
  end;
end;

procedure TfrmDrawers.tvTemplatesCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  if(assigned(Node)) then
  begin
    if(Dragging) then EndDrag(FALSE);
    if(not FInternalExpand) then
    begin
      if assigned(Node.Data) and (TTemplate(Node.Data).RealType = ttGroup) then
      begin
        FAsk := TRUE;
        FAskExp := FALSE;
        AllowCollapse := FALSE;
        FAskNode := Node;
      end;
    end;
    if(AllowCollapse) then
      FClickOccurred := FALSE;
  end;
end;

procedure TfrmDrawers.tvTemplatesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckAsk;
  case Key of
  VK_SPACE, VK_RETURN:
    begin
      InsertText;
      Key := 0;
    end;
  end;
end;

procedure TfrmDrawers.tvTemplatesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckAsk;
end;

procedure TfrmDrawers.SetRichEditControl(const Value: ORExtensions.TRichEdit);
begin
  if(FRichEditControl <> Value) then
  begin
    if(assigned(FRichEditControl)) then
    begin
      FRichEditControl.OnDragDrop := FOldDragDrop;
      FRichEditControl.OnDragOver := FOldDragOver;
    end;
    FRichEditControl := Value;
    if(assigned(FRichEditControl)) then
    begin
      FOldDragDrop := FRichEditControl.OnDragDrop;
      FOldDragOver := FRichEditControl.OnDragOver;
      FRichEditControl.OnDragDrop := NewRECDragDrop;
      FRichEditControl.OnDragOver := NewRECDragOver;
    end;
  end;
end;


procedure TfrmDrawers.MoveCaret(X, Y: integer);
var
  pt: TPoint;

begin
  FRichEditControl.SetFocus;
  pt := Point(x, y);
  FRichEditControl.SelStart := FRichEditControl.Perform(EM_CHARFROMPOS,0,LParam(@pt));
end;


procedure TfrmDrawers.NewRECDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if(Source = tvTemplates) then
  begin
    MoveCaret(X, Y);
    InsertText;
  end
  else
  if(assigned(FOldDragDrop)) then
    FOldDragDrop(Sender, Source, X, Y);
end;

procedure TfrmDrawers.NewRECDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);

begin
  Accept := FALSE;
  if(Source = tvTemplates) then
  begin
    if(AssignedAndHasData(FDragNode)) and
      (TTemplate(FDragNode.Data).RealType in [ttDoc, ttGroup]) then
    begin
      Accept := TRUE;
      MoveCaret(X, Y);
    end;
  end
  else
  if(assigned(FOldDragOver)) then
    FOldDragOver(Sender, Source, X, Y, State, Accept);
end;

procedure TfrmDrawers.InsertText;
var
  BeforeLine, AfterTop: integer;
  txt, DocInfo: string;
  Template: TTemplate;

begin
  if not AssignedAndHasData(tvTemplates.Selected) then
    Exit;
  DocInfo := '';
  if InsertOK(TRUE) and (dmodShared.TemplateOK(tvTemplates.Selected.Data)) then
  begin
    Template := TTemplate(tvTemplates.Selected.Data);
    Template.TemplatePreviewMode := FALSE;
    Template.ExtCPMon := FCopyMonitor;
    if Template.IsReminderDialog then
      Template.ExecuteReminderDialog(TForm(Owner))
    else
    begin
      if Template.IsCOMObject then
        txt := Template.COMObjectText('', DocInfo)
      else
        txt := Template.Text;
      if(txt <> '') then
      begin
        CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName);
        if txt <> '' then
        begin
          BeforeLine := SendMessage(FRichEditControl.Handle, EM_EXLINEFROMCHAR, 0, FRichEditControl.SelStart);
          FRichEditControl.SelText := txt;
          FRichEditControl.SetFocus;
          SendMessage(FRichEditControl.Handle, EM_SCROLLCARET, 0, 0);
          AfterTop := SendMessage(FRichEditControl.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
          SendMessage(FRichEditControl.Handle, EM_LINESCROLL, 0, -1 * (AfterTop - BeforeLine));
          SpeakTextInserted;

          //show copy/paste entries
          CopyMonitor.ManuallyShowNewHighlights;
        end;
      end;
    end;
  end;
end;

procedure TfrmDrawers.popTemplatesPopup(Sender: TObject);
var
  Node: TTreeNode;
  ok, ok2, NodeFound: boolean;
  Def: string;

begin
  ok := FALSE;
  ok2 := FALSE;
  if(FOpenDrawer = odTemplates) then
  begin
    Node := tvTemplates.Selected;
    tvTemplates.Selected := Node; // This line prevents selected from changing after menu closes
    NodeFound := (AssignedAndHasData(Node));
    if(NodeFound) then
    begin
      with TTemplate(Node.Data) do
      begin
        ok := (RealType in [ttDoc, ttGroup]);
        ok2 := ok and (not IsReminderDialog) and (not IsCOMObject);
      end;
    end;
    Def := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
    mnuGotoDefault.Enabled := (Def <> '');
    mnuViewNotes.Enabled := NodeFound and (TTemplate(Node.Data).Description <> '');
    mnuDefault.Enabled := NodeFound;
    mnuDefault.Checked := NodeFound and (tvTemplates.GetNodeID(TORTreeNode(Node), 1, ';') = Def);
  end
  else
  begin
    mnuDefault.Enabled := FALSE;
    mnuGotoDefault.Enabled := FALSE;
    mnuViewNotes.Enabled := FALSE;
  end;
  mnuPreviewTemplate.Enabled := ok2;
  mnuCopyTemplate.Enabled := ok2;
  mnuInsertTemplate.Enabled := ok and InsertOK(FALSE);
  mnuFindTemplates.Enabled := (FOpenDrawer = odTemplates);
  mnuCollapseTree.Enabled := ((FOpenDrawer = odTemplates) and
                              (dmodShared.NeedsCollapsing(tvTemplates)));
  mnuEditTemplates.Enabled := (UserTemplateAccessLevel in [taAll, taEditor]);
  mnuNewTemplate.Enabled := (UserTemplateAccessLevel in [taAll, taEditor]);
end;

procedure TfrmDrawers.mnuPreviewTemplateClick(Sender: TObject);
var
  tmpl: TTemplate;
  txt: String;

begin
  if AssignedAndHasData(tvTemplates.Selected) then
  begin
    if(dmodShared.TemplateOK(tvTemplates.Selected.Data,'template preview')) then
    begin
      tmpl := TTemplate(tvTemplates.Selected.Data);
      tmpl.TemplatePreviewMode := TRUE; // Prevents "Are you sure?" dialog when canceling
      txt := tmpl.Text;
      if(not tmpl.DialogAborted) then
        ShowTemplateData(Self, tmpl.PrintName, txt);
    end;
  end;
end;

procedure TfrmDrawers.FormDestroy(Sender: TObject);
begin
  dmodShared.RemoveDrawerTree(Self);
  KillObj(@FRemNotifyList);
end;

procedure TfrmDrawers.mnuCollapseTreeClick(Sender: TObject);
begin
  tvTemplates.Selected := nil;
  tvTemplates.FullCollapse;
end;

procedure TfrmDrawers.ReloadTemplates;
begin
  SetFindNext(FALSE);
  LoadTemplateData;
  if(UserTemplateAccessLevel <> taNone) and (assigned(MyTemplate)) and
    (MyTemplate.Children in [tcActive, tcBoth]) then
  begin
    AddTemplateNode(MyTemplate);
    FHasPersonalTemplates := TRUE;
  end;
  AddTemplateNode(RootTemplate);
  OpenToNode;
end;

procedure TfrmDrawers.btnFindClick(Sender: TObject);
var
  Found, TmpNode: TTreeNode;
  IsNext: boolean;

begin
  if(edtSearch.text <> '') then
  begin
    IsNext := ((FFindNext) and assigned (FLastFoundNode));
    if IsNext then
      TmpNode := FLastFoundNode
    else
      TmpNode := tvTemplates.Items.GetFirstNode;
    FInternalExpand := TRUE;
    FInternalHiddenExpand := TRUE;
    try
      Found := FindTemplate(edtSearch.Text, tvTemplates, Application.MainForm, TmpNode,
                            IsNext, not cbMatchCase.Checked, cbWholeWords.Checked);
    finally
      FInternalExpand := FALSE;
      FInternalHiddenExpand := FALSE;
    end;

    if assigned(Found) then
    begin
      FLastFoundNode := Found;
      SetFindNext(TRUE);
      FInternalExpand := TRUE;
      try
        tvTemplates.Selected := Found;
      finally
        FInternalExpand := FALSE;
      end;
    end;
  end;
  edtSearch.SetFocus;
end;

procedure TfrmDrawers.SetFindNext(const Value: boolean);
begin
  if(FFindNext <> Value) then
  begin
    FFindNext := Value;
    if(FFindNext) then btnFind.Caption := FindNextText
    else btnFind.Caption := 'Find';
  end;
end;

procedure TfrmDrawers.edtSearchChange(Sender: TObject);
begin
  btnFind.Enabled := (edtSearch.Text <> '');
  SetFindNext(FALSE);
end;

procedure TfrmDrawers.ToggleMenuItem(Sender: TObject);
var
  TmpMI: TMenuItem;

begin
  TmpMI := (Sender as TMenuItem);
  TmpMI.Checked := not TmpMI.Checked;
  SetFindNext(FALSE);
  if(pnlTemplateSearch.Visible) then edtSearch.SetFocus;
end;

procedure TfrmDrawers.edtSearchEnter(Sender: TObject);
begin
  btnFind.Default := TRUE;
end;

procedure TfrmDrawers.edtSearchExit(Sender: TObject);
begin
  btnFind.Default := FALSE;
end;

procedure TfrmDrawers.mnuFindTemplatesClick(Sender: TObject);
var
  FindOn: boolean;

begin
  mnuFindTemplates.Checked := not mnuFindTemplates.Checked;
  FindOn := mnuFindTemplates.Checked;
  pnlTemplateSearch.Visible := FindOn;
  if(FindOn) and (FOpenDrawer = odTemplates) then
    edtSearch.SetFocus;
end;

procedure TfrmDrawers.tvTemplatesDragging(Sender: TObject; Node: TTreeNode;
  var CanDrag: Boolean);

begin
  if AssignedAndHasData(Node) and (TTemplate(Node.Data).RealType in [ttDoc, ttGroup]) then
  begin
    FDragNode := Node;
    CanDrag := TRUE;
  end
  else
  begin
    FDragNode := nil;
    CanDrag := FALSE;
  end;
end;

procedure TfrmDrawers.mnuEditTemplatesClick(Sender: TObject);
begin
  EditTemplates(Self);
end;

procedure TfrmDrawers.mnuNewTemplateClick(Sender: TObject);
begin
  EditTemplates(Self, TRUE);
end;

procedure TfrmDrawers.FormCreate(Sender: TObject);
begin
  dmodShared.AddDrawerTree(Self);
  FHasPersonalTemplates := FALSE;
end;

procedure TfrmDrawers.ExternalReloadTemplates;
begin
  if(FOpenToNode = '') and (assigned(tvTemplates.Selected)) then
    FOpenToNode := tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected),1,';');
  tvTemplates.Items.Clear;
  FHasPersonalTemplates := FALSE;
  FEmptyNodeCount := 0;
  ReloadTemplates;
end;

procedure TfrmDrawers.fldAccessRemindersInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if FOpenDrawer = odReminders then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmDrawers.fldAccessRemindersStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if FOpenDrawer = odReminders then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

procedure TfrmDrawers.fldAccessTemplatesInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if FOpenDrawer = odTemplates then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmDrawers.fldAccessTemplatesStateQuery(Sender: TObject;
  var Text: string);
begin
  if FOpenDrawer = odTemplates then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

procedure TfrmDrawers.DisplayDrawers(Show: Boolean);
begin
  DisplayDrawers(Show, [], []);
end;

procedure TfrmDrawers.DisplayDrawers(Show: Boolean; AEnable, ADisplay: TDrawers);
begin
  if(not (csLoading in ComponentState)) then
  begin
    if Show then
    begin
      EnableDrawers(AEnable);
      ShowDrawers(ADisplay);
    end
    else
    begin
      ShowDrawers([]);
    end;
    if(assigned(FSplitter)) then
    begin
      if(Show and (FOpenDrawer <> odNone)) then
        SetSplitterActive(TRUE)
      else
        SetSplitterActive(FALSE);
    end;
  end;
end;

function TfrmDrawers.CanEditTemplates: boolean;
begin
  Result := FTemplateAccess and (UserTemplateAccessLevel in [taAll, taEditor]);
end;

function TfrmDrawers.CanEditShared: boolean;
begin
  Result := FTemplateAccess and (UserTemplateAccessLevel = taEditor);
end;

procedure TfrmDrawers.pnlTemplateSearchResize(Sender: TObject);
begin
  if((cbMatchCase.Width + cbWholeWords.Width) > pnlTemplateSearch.Width) then
    cbWholeWords.Left := cbMatchCase.Width
  else
    cbWholeWords.Left := pnlTemplateSearch.Width - cbWholeWords.Width;
end;

procedure TfrmDrawers.cbFindOptionClick(Sender: TObject);
begin
  SetFindNext(FALSE);
  if(pnlTemplateSearch.Visible) then edtSearch.SetFocus;
end;

procedure TfrmDrawers.mnuInsertTemplateClick(Sender: TObject);
begin
  if AssignedAndHasData(tvTemplates.Selected) and
     (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup]) then
  InsertText;
end;

procedure TfrmDrawers.SetSplitter(const Value: TSplitter);
begin
  if(FSplitter <> Value) then
  begin
    if(assigned(FSplitter)) then
      FSplitter.OnCanResize := FOldCanResize;
    FSplitter := Value;
    if(assigned(FSplitter)) then
    begin
      FOldCanResize := FSplitter.OnCanResize;
      FSplitter.OnCanResize := SplitterCanResize;
      SetSplitterActive(FSplitterActive);
    end;
  end;
end;

procedure TfrmDrawers.SplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin
  Accept := FSplitterActive;
end;

procedure TfrmDrawers.SetSplitterActive(Active: boolean);
begin
  FSplitterActive := Active;
  if(Active) then
  begin
    FSplitter.Cursor := crVSplit;
    FSplitter.ResizeStyle := rsPattern;
  end
  else
  begin
    FSplitter.Cursor := crDefault;
    FSplitter.ResizeStyle := ExtCtrls.rsNone;
  end;
end;

procedure TfrmDrawers.UpdatePersonalTemplates;
var
  NeedPersonal: boolean;
  Node: TTreeNode;

  function FindNode: TTreeNode;
  begin
    Result := tvTemplates.Items.GetFirstNode;
    while AssignedAndHasData(Result) do
    begin
      if(Result.Data = MyTemplate) then exit;
      Result := Result.getNextSibling;
    end;
  end;

begin
  NeedPersonal := (UserTemplateAccessLevel <> taNone);
  if(NeedPersonal <> FHasPersonalTemplates) then
  begin
    if(NeedPersonal) then
    begin
      if(assigned(MyTemplate)) and (MyTemplate.Children in [tcActive, tcBoth]) then
      begin
        AddTemplateNode(MyTemplate);
        FHasPersonalTemplates := TRUE;
        if(assigned(MyTemplate)) then
        begin
          Node := FindNode;
          if(assigned(Node)) then
            Node.MoveTo(nil, naAddFirst);
        end;
      end;
    end
    else
    begin
      if(assigned(MyTemplate)) then
      begin
        Node := FindNode;
        if(assigned(Node)) then Node.Delete;
      end;
      FHasPersonalTemplates := FALSE;
    end;
  end;
end;

procedure TfrmDrawers.RemindersChanged(Sender: TObject);
begin
  inc(FHoldResize);
  try
    if FTemplateAccess and (EnableDrawer(odReminders, (GetReminderStatus <> rsNone))) then
    begin
      BuildReminderTree(tvReminders);
      FOldMouseUp := tvReminders.OnMouseUp;
    end
    else
    begin
      FOldMouseUp := nil;
      tvReminders.PopupMenu := nil;
    end;
    tvReminders.OnMouseUp := tvRemindersMouseUp;
  finally
    dec(FHoldResize);
  end;
end;

procedure TfrmDrawers.tvRemindersMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(Button = mbLeft) and (assigned(tvReminders.Selected)) and
    (htOnItem in tvReminders.GetHitTestInfoAt(X, Y)) then
    ViewReminderDialog(ReminderNode(tvReminders.Selected));
end;

procedure TfrmDrawers.PositionToReminder(Sender: TObject);
var
  Rem: TReminder;

begin
  if(assigned(Sender)) then
  begin
    if(Sender is TReminder) then
    begin
      Rem := TReminder(Sender);
      if(Rem.CurrentNodeID <> '') then
        tvReminders.Selected := tvReminders.FindPieceNode(Rem.CurrentNodeID, 1, IncludeParentID)
      else
      begin
        tvReminders.Selected := tvReminders.FindPieceNode(RemCode + (Sender as TReminder).IEN, 1);
        if(assigned(tvReminders.Selected)) then
          TORTreeNode(tvReminders.Selected).EnsureVisible;
      end;
      Rem.CurrentNodeID := '';
    end;
  end
  else
    tvReminders.Selected := nil;
end;

procedure TfrmDrawers.tvRemindersCurListChanged(Sender: TObject;
  Node: TTreeNode);
begin
  if(assigned(FRemNotifyList)) then
    FRemNotifyList.Notify(Node);
end;

procedure TfrmDrawers.NotifyWhenRemTreeChanges(Proc: TNotifyEvent);
begin
  if(not assigned(FRemNotifyList)) then
    FRemNotifyList := TORNotifyList.Create;
  FRemNotifyList.Add(Proc);
end;

procedure TfrmDrawers.RemoveNotifyWhenRemTreeChanges(Proc: TNotifyEvent);
begin
  if(assigned(FRemNotifyList)) then
    FRemNotifyList.Remove(Proc);
end;

function TfrmDrawers.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

procedure TfrmDrawers.SetAlign(const Value: TAlign);
begin
  inherited Align := Value;
  ResizeToVisible;
end;

procedure TfrmDrawers.ResetTemplates;
begin
  FOpenToNode := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
end;

procedure TfrmDrawers.mnuDefaultClick(Sender: TObject);
var
  NodeID: string;
  UserTempDefNode: string;
begin
  NodeID := tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected), 1, ';');
  UserTempDefNode := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
  if NodeID <> UserTempDefNode then
    SetUserTemplateDefaults(tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected), 1, ';'),
                          FDefTempPiece)
  else SetUserTemplateDefaults('', FDefTempPiece);                      
end;

procedure TfrmDrawers.OpenToNode(Path: string = '');
var
  OldInternalHE, OldInternalEX: boolean;

begin
  if(Path <> '') then
    FOpenToNode := PATH;
  if(FOpenToNode <> '') then
  begin
    OldInternalHE := FInternalHiddenExpand;
    OldInternalEX := FInternalExpand;
    try
      FInternalExpand := TRUE;
      FInternalHiddenExpand := FALSE;
      dmodShared.SelectNode(tvTemplates, FOpenToNode, FEmptyNodeCount);
    finally
      FInternalHiddenExpand := OldInternalHE;
      FInternalExpand := OldInternalEX;
    end;
    FOpenToNode := '';
  end;
end;

procedure TfrmDrawers.mnuGotoDefaultClick(Sender: TObject);
begin
  OpenToNode(Piece(GetUserTemplateDefaults, '/', FDefTempPiece));
end;

procedure TfrmDrawers.mnuViewNotesClick(Sender: TObject);
var
  tmpl: TTemplate;
  tmpSL: TStringList;

begin
  if AssignedAndHasData(tvTemplates.Selected) then
  begin
    tmpl := TTemplate(tvTemplates.Selected.Data);
    if(tmpl.Description = '') then
      ShowMsg('No notes found for ' + tmpl.PrintName)
    else
    begin
      tmpSL := TStringList.Create;
      try
        tmpSL.Text := tmpl.Description;
        ReportBox(tmpSL, tmpl.PrintName + ' Notes:', TRUE);
      finally
        tmpSL.Free;
      end;
    end;
  end;
end;

procedure TfrmDrawers.mnuCopyTemplateClick(Sender: TObject);
var
  txt: string;
  Template: TTemplate;

begin
  txt := '';
  if AssignedAndHasData(tvTemplates.Selected) and
     (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup]) and
     dmodShared.TemplateOK(tvTemplates.Selected.Data) then
  begin
    Template := TTemplate(tvTemplates.Selected.Data);
    txt := Template.Text;
    CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName, False, FCopyMonitor);
    if txt <> '' then
    begin
      Clipboard.SetTextBuf(PChar(txt));
      GetScreenReader.Speak('Text Copied to Clip board');
    end;
  end;
  if txt <> '' then
    StatusText('Templated Text copied to clipboard.');
end;

function TfrmDrawers.InsertOK(Ask: boolean): boolean;

  function REOK: boolean;
  begin
    Result := assigned(FRichEditControl) and
              FRichEditControl.Visible and
              FRichEditControl.Parent.Visible;
  end;

begin
  Result := REOK;
  if (not ask) and (not Result) and (assigned(FNewNoteButton)) then
    Result := TRUE
  else
  if ask and (not Result) and assigned(FNewNoteButton) and
     FNewNoteButton.Visible and FNewNoteButton.Enabled then
  begin
    FNewNoteButton.Click;
    Result := REOK;
  end;
end;

procedure TfrmDrawers.mnuViewTemplateIconLegendClick(Sender: TObject);
begin
  ShowIconLegend(ilTemplates);
end;

procedure TfrmDrawers.pnlTemplatesButtonEnter(Sender: TObject);
begin
  with Sender as TPanel do
    if (ControlCount > 0) and (Controls[0] is TSpeedButton) and (TSpeedButton(Controls[0]).Down)
    then
      BevelOuter := bvLowered
    else
      BevelOuter := bvRaised;
end;

procedure TfrmDrawers.pnlTemplatesButtonExit(Sender: TObject);
begin
  with Sender as TPanel do
    BevelOuter := bvNone;
  DisableArrowKeyMove(Sender);
end;

procedure TfrmDrawers.tvRemindersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_RETURN, VK_SPACE:
    begin
      ViewReminderDialog(ReminderNode(tvReminders.Selected));
      Key := 0;
    end;
  end;
end;

procedure TfrmDrawers.tvRemindersNodeCaptioning(Sender: TObject;
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

procedure TfrmDrawers.DisableArrowKeyMove(Sender: TObject);
var
  CurrPanel : TKeyClickPanel;
begin
  if Sender is TKeyClickPanel then
  begin
    CurrPanel := Sender as TKeyClickPanel;
    If Boolean(Hi(GetKeyState(VK_UP)))
       OR Boolean(Hi(GetKeyState(VK_DOWN)))
       OR Boolean(Hi(GetKeyState(VK_LEFT)))
       OR Boolean(Hi(GetKeyState(VK_RIGHT))) then
    begin
      if Assigned(CurrPanel) then
        CurrPanel.SetFocus;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmDrawers);

end.

