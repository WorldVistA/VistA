unit fTemplateEditor;
{The OwnerScan conditional compile varaible was created because there were too
 many things that needed to be done to incorporate the viewing of other user's
 personal templates by clinical coordinators.  These include:
   Changing the Personal tree.
   expanding entirely new personal list when personal list changes
   when click on stop editing shared button, and personal is for someone else,
     need to resync to personal list.

HOT HEYS NOT YET ASSIGNED:
JFKQRUVZ
}
{$DEFINE OwnerScan}
{$UNDEF OwnerScan}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, ORCtrls, Buttons, Mask, ORFn, ORNet,
  uTemplates, Menus, ImgList, Clipbrd, ToolWin, MenuBar, TypInfo, MSXML_TLB, fBase508Form,
  VA508AccessibilityManager, VA508ImageListLabeler;

type
  TTemplateTreeControl = (tcDel, tcUp, tcDown, tcLbl, tcCopy);
  TTemplateTreeType = (ttShared, ttPersonal);

  TfrmTemplateEditor = class(TfrmBase508Form)
    splMain: TSplitter;
    pnlBottom: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    pnlTop: TPanel;
    pnlRightTop: TPanel;
    splProperties: TSplitter;
    pnlCopyBtns: TPanel;
    sbCopyLeft: TBitBtn;
    sbCopyRight: TBitBtn;
    lblCopy: TLabel;
    splMiddle: TSplitter;
    pnlShared: TPanel;
    lblShared: TLabel;
    tvShared: TORTreeView;
    pnlSharedBottom: TPanel;
    sbShUp: TBitBtn;
    sbShDown: TBitBtn;
    sbShDelete: TBitBtn;
    cbShHide: TCheckBox;
    pnlSharedGap: TPanel;
    pnlPersonal: TPanel;
    lblPersonal: TLabel;
    tvPersonal: TORTreeView;
    pnlPersonalBottom: TPanel;
    sbPerUp: TBitBtn;
    sbPerDown: TBitBtn;
    sbPerDelete: TBitBtn;
    cbPerHide: TCheckBox;
    pnlPersonalGap: TPanel;
    popTemplates: TPopupMenu;
    mnuCollapseTree: TMenuItem;
    mnuFindTemplates: TMenuItem;
    popBoilerplate: TPopupMenu;
    mnuBPInsertObject: TMenuItem;
    mnuBPErrorCheck: TMenuItem;
    mnuBPSpellCheck: TMenuItem;
    tmrAutoScroll: TTimer;
    popGroup: TPopupMenu;
    mnuGroupBPCopy: TMenuItem;
    mnuBPCut: TMenuItem;
    N2: TMenuItem;
    mnuBPCopy: TMenuItem;
    mnuBPPaste: TMenuItem;
    N4: TMenuItem;
    mnuGroupBPSelectAll: TMenuItem;
    mnuBPSelectAll: TMenuItem;
    N6: TMenuItem;
    mnuNodeCopy: TMenuItem;
    mnuNodePaste: TMenuItem;
    mnuNodeDelete: TMenuItem;
    N8: TMenuItem;
    mnuBPUndo: TMenuItem;
    cbEditShared: TCheckBox;
    pnlProperties: TPanel;
    gbProperties: TGroupBox;
    lblName: TLabel;
    lblLines: TLabel;
    cbExclude: TORCheckBox;
    cbActive: TCheckBox;
    edtGap: TCaptionEdit;
    udGap: TUpDown;
    edtName: TCaptionEdit;
    mnuMain: TMainMenu;
    mnuEdit: TMenuItem;
    mnuUndo: TMenuItem;
    N9: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuSelectAll: TMenuItem;
    N11: TMenuItem;
    mnuInsertObject: TMenuItem;
    mnuErrorCheck: TMenuItem;
    mnuSpellCheck: TMenuItem;
    N13: TMenuItem;
    mnuGroupBoilerplate: TMenuItem;
    mnuGroupCopy: TMenuItem;
    mnuGroupSelectAll: TMenuItem;
    mnuTemplate: TMenuItem;
    mnuTCopy: TMenuItem;
    mnuTPaste: TMenuItem;
    mnuTDelete: TMenuItem;
    N12: TMenuItem;
    pnlShSearch: TPanel;
    btnShFind: TORAlignButton;
    edtShSearch: TCaptionEdit;
    cbShMatchCase: TCheckBox;
    cbShWholeWords: TCheckBox;
    pnlPerSearch: TPanel;
    btnPerFind: TORAlignButton;
    edtPerSearch: TCaptionEdit;
    cbPerMatchCase: TCheckBox;
    cbPerWholeWords: TCheckBox;
    mnuFindShared: TMenuItem;
    mnuFindPersonal: TMenuItem;
    N3: TMenuItem;
    mnuShCollapse: TMenuItem;
    mnuPerCollapse: TMenuItem;
    pnlMenuBar: TPanel;
    lblPerOwner: TLabel;
    cboOwner: TORComboBox;
    btnNew: TORAlignButton;
    pnlMenu: TPanel;
    mbMain: TMenuBar;
    mnuNewTemplate: TMenuItem;
    Bevel1: TBevel;
    mnuNodeNew: TMenuItem;
    mnuBPCheckGrammar: TMenuItem;
    mnuCheckGrammar: TMenuItem;
    N1: TMenuItem;
    N7: TMenuItem;
    N14: TMenuItem;
    mnuSort: TMenuItem;
    N15: TMenuItem;
    mnuNodeSort: TMenuItem;
    mnuTry: TMenuItem;
    mnuBPTry: TMenuItem;
    mnuAutoGen: TMenuItem;
    mnuNodeAutoGen: TMenuItem;
    popNotes: TPopupMenu;
    mnuNotesUndo: TMenuItem;
    MenuItem2: TMenuItem;
    mnuNotesCut: TMenuItem;
    mnuNotesCopy: TMenuItem;
    mnuNotesPaste: TMenuItem;
    MenuItem6: TMenuItem;
    mnuNotesSelectAll: TMenuItem;
    MenuItem8: TMenuItem;
    mnuNotesGrammar: TMenuItem;
    mnuNotesSpelling: TMenuItem;
    cbNotes: TCheckBox;
    gbDialogProps: TGroupBox;
    cbDisplayOnly: TCheckBox;
    cbOneItemOnly: TCheckBox;
    cbHideItems: TORCheckBox;
    cbFirstLine: TCheckBox;
    cbHideDlgItems: TCheckBox;
    cbIndent: TCheckBox;
    mnuTools: TMenuItem;
    mnuEditTemplateFields: TMenuItem;
    N16: TMenuItem;
    mnuImportTemplate: TMenuItem;
    mnuExportTemplate: TMenuItem;
    mnuBPInsertField: TMenuItem;
    mnuInsertField: TMenuItem;
    cbEditUser: TCheckBox;
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
    cbxType: TCaptionComboBox;
    lblType: TLabel;
    cbxRemDlgs: TORComboBox;
    lblRemDlg: TLabel;
    N17: TMenuItem;
    mnuTemplateIconLegend: TMenuItem;
    cbLock: TORCheckBox;
    mnuRefresh: TMenuItem;
    pnlCOM: TPanel;
    lblCOMParam: TLabel;
    edtCOMParam: TCaptionEdit;
    cbxCOMObj: TORComboBox;
    lblCOMObj: TLabel;
    pnlLink: TPanel;
    cbxLink: TORComboBox;
    lblLink: TLabel;
    imgLblTemplates: TVA508ImageListLabeler;
    Panel1: TPanel;
    pnlBoilerplate: TPanel;
    splBoil: TSplitter;
    splNotes: TSplitter;
    reBoil: TRichEdit;
    pnlGroupBP: TPanel;
    lblGroupBP: TLabel;
    lblGroupRow: TLabel;
    lblGroupCol: TLabel;
    reGroupBP: TRichEdit;
    pnlGroupBPGap: TPanel;
    pnlBP: TPanel;
    lblBoilerplate: TLabel;
    lblBoilRow: TLabel;
    lblBoilCol: TLabel;
    cbLongLines: TCheckBox;
    pnlNotes: TPanel;
    lblNotes: TLabel;
    reNotes: TRichEdit;
    procedure btnNewClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboOwnerNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboOwnerChange(Sender: TObject);
    procedure tvPersonalExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvSharedExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvTreeGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTreeGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTreeChange(Sender: TObject; Node: TTreeNode);
    procedure splMainMoved(Sender: TObject);
    procedure pnlBoilerplateResize(Sender: TObject);
    procedure edtNameOldChange(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure cbExcludeClick(Sender: TObject);
    procedure edtGapChange(Sender: TObject);
    procedure tvTreeEnter(Sender: TObject);
    procedure tvTreeNodeEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure cbShHideClick(Sender: TObject);
    procedure cbPerHideClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbMoveUpClick(Sender: TObject);
    procedure sbMoveDownClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure tvTreeDragging(Sender: TObject; Node: TTreeNode;
      var CanDrag: Boolean);
    procedure tvTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sbCopyLeftClick(Sender: TObject);
    procedure sbCopyRightClick(Sender: TObject);
    procedure reBoilChange(Sender: TObject);
    procedure cbEditSharedClick(Sender: TObject);
    procedure popTemplatesPopup(Sender: TObject);
    procedure mnuCollapseTreeClick(Sender: TObject);
    procedure mnuFindTemplatesClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtShSearchEnter(Sender: TObject);
    procedure edtShSearchExit(Sender: TObject);
    procedure edtPerSearchEnter(Sender: TObject);
    procedure edtPerSearchExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuBPInsertObjectClick(Sender: TObject);
    procedure mnuBPErrorCheckClick(Sender: TObject);
    procedure popBoilerplatePopup(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuBPSpellCheckClick(Sender: TObject);
    procedure splBoilMoved(Sender: TObject);
    procedure edtGapKeyPress(Sender: TObject; var Key: Char);
    procedure edtNameExit(Sender: TObject);
    procedure tmrAutoScrollTimer(Sender: TObject);
    procedure tvTreeStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure tvTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure mnuGroupBPCopyClick(Sender: TObject);
    procedure popGroupPopup(Sender: TObject);
    procedure mnuBPCutClick(Sender: TObject);
    procedure mnuBPCopyClick(Sender: TObject);
    procedure mnuBPPasteClick(Sender: TObject);
    procedure mnuGroupBPSelectAllClick(Sender: TObject);
    procedure mnuBPSelectAllClick(Sender: TObject);
    procedure mnuNodeDeleteClick(Sender: TObject);
    procedure mnuNodeCopyClick(Sender: TObject);
    procedure mnuNodePasteClick(Sender: TObject);
    procedure mnuBPUndoClick(Sender: TObject);
    procedure tvTreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuEditClick(Sender: TObject);
    procedure mnuGroupBoilerplateClick(Sender: TObject);
    procedure cbShFindOptionClick(Sender: TObject);
    procedure cbPerFindOptionClick(Sender: TObject);
    procedure mnuTemplateClick(Sender: TObject);
    procedure mnuFindSharedClick(Sender: TObject);
    procedure mnuFindPersonalClick(Sender: TObject);
    procedure mnuShCollapseClick(Sender: TObject);
    procedure mnuPerCollapseClick(Sender: TObject);
    procedure pnlShSearchResize(Sender: TObject);
    procedure pnlPerSearchResize(Sender: TObject);
    procedure pnlPropertiesResize(Sender: TObject);
    procedure mbMainResize(Sender: TObject);
    procedure mnuBPCheckGrammarClick(Sender: TObject);
    procedure mnuSortClick(Sender: TObject);
    procedure pnlBoilerplateCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure mnuBPTryClick(Sender: TObject);
    procedure mnuAutoGenClick(Sender: TObject);
    procedure reNotesChange(Sender: TObject);
    procedure mnuNotesUndoClick(Sender: TObject);
    procedure mnuNotesCutClick(Sender: TObject);
    procedure mnuNotesCopyClick(Sender: TObject);
    procedure mnuNotesPasteClick(Sender: TObject);
    procedure mnuNotesSelectAllClick(Sender: TObject);
    procedure mnuNotesGrammarClick(Sender: TObject);
    procedure mnuNotesSpellingClick(Sender: TObject);
    procedure popNotesPopup(Sender: TObject);
    procedure cbNotesClick(Sender: TObject);
    procedure cbDisplayOnlyClick(Sender: TObject);
    procedure cbFirstLineClick(Sender: TObject);
    procedure cbOneItemOnlyClick(Sender: TObject);
    procedure cbHideDlgItemsClick(Sender: TObject);
    procedure cbHideItemsClick(Sender: TObject);
    procedure cbIndentClick(Sender: TObject);
    procedure mnuToolsClick(Sender: TObject);
    procedure mnuEditTemplateFieldsClick(Sender: TObject);
    procedure mnuBPInsertFieldClick(Sender: TObject);
    procedure mnuExportTemplateClick(Sender: TObject);
    procedure mnuImportTemplateClick(Sender: TObject);
    procedure cbxTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbxTypeChange(Sender: TObject);
    procedure cbxRemDlgsChange(Sender: TObject);
    procedure mnuTemplateIconLegendClick(Sender: TObject);
    procedure cbLongLinesClick(Sender: TObject);
    procedure cbLockClick(Sender: TObject);
    procedure mnuRefreshClick(Sender: TObject);
    procedure reResizeRequest(Sender: TObject; Rect: TRect);
    procedure reBoilSelectionChange(Sender: TObject);
    procedure reGroupBPSelectionChange(Sender: TObject);
    procedure cbxCOMObjChange(Sender: TObject);
    procedure edtCOMParamChange(Sender: TObject);
    procedure cbxLinkNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cbxLinkExit(Sender: TObject);
    procedure reBoilKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure reBoilKeyPress(Sender: TObject; var Key: Char);
    procedure reBoilKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure splMainCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
  private
    FLastRect: TRect;
    FForceContainer: boolean;
    FSavePause: integer;
    FCopyNode: TTreeNode;
    FPasteNode: TTreeNode;
    FCopying: boolean;
    FDropNode: TTreeNode;
    FDropInto: boolean;
    FDragNode: TTreeNode;
    FPersonalEmptyNodeCount: integer;
    FSharedEmptyNodeCount: integer;
//    FOldPersonalTemplate: TTemplate;
    FCurrentPersonalUser: Int64;
    FCanEditPersonal: boolean;
    FCanEditShared: boolean;
    FUpdating: boolean;
    FCurTree: TTreeView;
    FTreeControl: array[TTemplateTreeType, TTemplateTreeControl] of TControl;
    FInternalHiddenExpand: boolean;
    FFindShOn: boolean;
    FFindShNext: boolean;
    FLastFoundShNode: TTreeNode;
    FFindPerOn: boolean;
    FFindPerNext: boolean;
    FLastFoundPerNode: TTreeNode;
    FFirstShow: boolean;
    FFocusName: boolean;
    FOK2Close: boolean;
    FBtnNewNode: TTreeNode;
    FLastDropNode: TTreeNode;
    FFromMainMenu: boolean;
    FMainMenuTree: TTreeView;
    FDragOverCount: integer;
    FBPOK: boolean;
    FImportingFromXML: boolean;
    FXMLTemplateElement: IXMLDOMNode;
    FXMLFieldElement: IXMLDOMNode;
    FCanDoReminders: boolean;
    FCanDoCOMObjects: boolean;
    //FPersonalObjects: TStringList;
    FShowingTemplate: TTemplate;
    FConsultServices: TStringList;
    FNavigatingTab: boolean;
  protected
    procedure UpdateXY(re: TRichEdit; lblX, lblY: TLabel);
    function IsTemplateLocked(Node: TTreeNode): boolean;
    procedure RefreshData;
    procedure ShowTemplateType(Template: TTemplate);
    procedure DisplayBoilerplate(Node: TTreeNode);
    procedure NewPersonalUser(UsrIEN: Int64);
    procedure HideControls;
    procedure EnableControls(ok, Root: boolean);
    procedure EnableNavControls;
    procedure MoveCopyButtons;
    procedure ShowInfo(Node: TTreeNode);
    function ChangeTree(NewTree: TTreeView): boolean;
    procedure Resync(const Templates: array of TTemplate);
    function AllowMove(ADropNode, ADragNode: TTreeNode): boolean;
    function CanClone(const Node: TTreeNode): boolean;
    function Clone(Node: TTreeNode): boolean;
    procedure SharedEditing;
    function GetTree: TTreeView;
    procedure SetFindNext(const Tree: TTreeView; const Value: boolean);
    function ScanNames: boolean;
    function PasteOK: boolean;
    function AutoDel(Template: TTemplate): boolean;
    procedure cbClick(Sender: TCheckBox; Index: integer);
    procedure UpdateInsertsDialogs;
    procedure AutoLongLines(Sender: TObject);
    //procedure UpdatePersonalObjects;
    procedure UpdateApply(Template: TTemplate);
    procedure TemplateLocked(Sender: TObject);
    procedure InitTrees;
    procedure AdjustControls4FontChange;
    procedure ShowGroupBoilerplate(Visible: boolean);
    procedure ShowBoilerPlate(Hide: Boolean);
    function GetLinkType(const ANode: TTreeNode): TTemplateLinkType;
  end;

procedure EditTemplates(Form: TForm; NewTemplate: boolean = FALSE; CopiedText: string = ''; Shared: boolean = FALSE);

const
  TemplateEditorSplitters = 'frmTempEditSplitters';
  TemplateEditorSplitters2 = 'frmTempEditSplitters2';

var
  tmplEditorSplitterMiddle: integer = 0;
  tmplEditorSplitterProperties: integer = 0;
  tmplEditorSplitterMain: integer = 0;
  tmplEditorSplitterBoil: integer = 0;
  tmplEditorSplitterNotes: integer = 0;

implementation

{$R *.DFM}

uses dShared, uCore, rTemplates, fTemplateObjects, uSpell, fTemplateView,
  fTemplateAutoGen, fDrawers, mDrawers, fTemplateFieldEditor, fTemplateFields, XMLUtils,
  fIconLegend, uReminders, uConst, rCore, rEventHooks, rConsults, VAUtils,
  rMisc, fFindingTemplates, System.UITypes;

const
  PropText = ' Template Properties ';
//  GroupTag = 5;
  BPDisplayOnlyFld = 0;
  BPFirstLineFld = 1;
  BPOneItemOnlyFld = 2;
  BPHideDlgItemsFld = 3;
  BPHideItemsFld = 4;
  BPIndentFld = 5;
  BPLockFld = 6;
  NoIE5 = 'You must have Internet Explorer 5 or better installed to %s Templates';
  NoIE5Header = 'Need Internet Explorer 5';
  VK_A = Ord('A');
  VK_C = Ord('C');
  VK_E = Ord('E');
  VK_F = Ord('F');
  VK_G = Ord('G');
  VK_I = Ord('I');
  VK_S = Ord('S');
  VK_T = Ord('T');
  VK_V = Ord('V');
  VK_X = Ord('X');
  VK_Z = Ord('Z');

type
  TTypeIndex = (tiTemplate, tiFolder, tiGroup, tiDialog, tiRemDlg, tiCOMObj);

const
  tiNone = TTypeIndex(-1);
//  TypeTag: array[TTypeIndex] of integer = (7, 6, 8, -8, 7, 7);
  ttDialog = TTemplateType(-ord(ttGroup));

  TypeTag: array[TTypeIndex] of TTemplateType = (ttDoc, ttClass, ttGroup, ttDialog, ttDoc, ttDoc);
  ForcedIdx: array[boolean, TTypeIndex] of integer = ((0, 1, 2, 3, 4, 5), (-1, 0, 1, 2, -1, -1));
  IdxForced: array[boolean, 0..5] of TTypeIndex = ((tiTemplate, tiFolder, tiGroup, tiDialog, tiRemDlg, tiCOMObj),
    (tiFolder, tiGroup, tiDialog, tiNone, tiNone, tiNone));
  iMessage = 'This template has one or more new fields, and you are not authorized to create new fields.  ' +
    'If you continue, the program will import the new template without the new fields.  Do you wish ' +
    'to do this?';
  iMessage2 = 'The imported template fields had XML errors.  ';
  iMessage3 = 'No Fields were imported.';

var
  frmTemplateObjects: TfrmTemplateObjects = nil;
  frmTemplateFields: TfrmTemplateFields = nil;

procedure EditTemplates(Form: TForm; NewTemplate: boolean = FALSE; CopiedText: string = ''; Shared: boolean = FALSE);
var
  frmTemplateEditor: TfrmTemplateEditor;
  Drawers: TObject;
  ExpandStr, SelectStr: string;
  SelNode: TTreeNode;
  SelShared: boolean;
  View: TORTreeView;
begin
  if (UserTemplateAccessLevel in [taReadOnly, taNone]) then exit;

  ExpandStr := '';
  SelectStr := '';
  View := nil;
  Drawers := nil;
  if (not NewTemplate) and (CopiedText = '') then
  begin
    if Form is TfrmDrawers then begin
      View := TfrmDrawers(Form).tvTemplates;
    end else begin
      if IsPublishedProp(Form, DrawersProperty) then begin
        Drawers := GetObjectProp(Form, DrawersProperty);
        if Drawers is TfrmDrawers then begin
          View := TFrmDrawers(Drawers).tvTemplates;
        end else if Drawers is TfraDrawers then begin
          View := TfraDrawers(Drawers).tvTemplates;
        end;
      end;
    end;
  end;

  if assigned(Drawers) then
  begin
    ExpandStr := View.GetExpandedIDStr(1, ';');
    SelectStr := View.GetNodeID(TORTreeNode(View.Selected), 1, ';');
  end;

  frmTemplateEditor := TfrmTemplateEditor.Create(Application);
  try
    with frmTemplateEditor do
    begin
      Font := Form.Font;
      reBoil.Font.Size := Form.Font.Size;
      reGroupBP.Font.Size := Form.Font.Size;
      reNotes.Font.Size := Form.Font.Size;
      dmodShared.ExpandTree(tvShared, ExpandStr, FSharedEmptyNodeCount);
      SelNode := tvShared.FindPieceNode(SelectStr, 1, ';');
      SelShared := assigned(SelNode);
      dmodShared.ExpandTree(tvPersonal, ExpandStr, FPersonalEmptyNodeCount);
      if not SelShared then
        SelNode := tvPersonal.FindPieceNode(SelectStr, 1, ';');

      if (SelShared and (not Shared)) then
        Shared := TRUE;

      if (Shared and (UserTemplateAccessLevel = taEditor)) then
      begin
        cbEditShared.Checked := TRUE;
        ActiveControl := tvShared;
        if SelShared then
          tvShared.Selected := SelNode
        else
          tvShared.Selected := tvShared.Items.GetFirstNode;
      end
      else
        if (not SelShared) and (assigned(SelNode)) then
          tvPersonal.Selected := SelNode;
      if (NewTemplate) then
      begin
        btnNewClick(frmTemplateEditor);
        if (CopiedText <> '') then
        begin
          TTemplate(FBtnNewNode.Data).Boilerplate := CopiedText;
          ShowInfo(FBtnNewNode);
        end;
      end;
      if (frmTemplateEditor.ShowModal = mrOK) then begin
        if assigned(Drawers) then begin
          if Drawers is TfraDrawers then begin
            if assigned(TfraDrawers(Drawers).OnTemplateEditEvent) then
              TfraDrawers(Drawers).OnTemplateEditEvent;
          end;
        end;
      end;
    end;
  finally
    frmTemplateEditor.Free;
  end;
end;

procedure TfrmTemplateEditor.btnNewClick(Sender: TObject);
var
  idx: integer;
  Tmp, Owner: TTemplate;
  Node, PNode: TTreeNode;
  ownr: string;
  ok: boolean;
  ACheckBox: TCheckBox;

begin
  if ((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if (FCurTree = tvShared) and (FCanEditShared) then
      ok := TRUE
    else
      if (FCurTree = tvPersonal) and (FCanEditPersonal) then
        ok := TRUE
      else
        ok := FALSE;
    if (ok) then
    begin
      Node := FCurTree.Selected;
      PNode := Node;
      if (TTemplate(Node.Data).RealType = ttDoc) then
        PNode := Node.Parent;
      if CanClone(PNode) then
      begin
        Clone(PNode);
        Owner := TTemplate(PNode.Data);
        if assigned(Owner) and Owner.CanModify then
        begin
          if Node = PNode then
            idx := 0
          else
            idx := Owner.Items.IndexOf(Node.Data) + 1;
          if (FCurTree = tvShared) then
          begin
            ownr := '';
            ACheckBox := cbShHide;
          end
          else
          begin
            ownr := IntToStr(User.DUZ);
            ACheckBox := cbPerHide;
          end;
          if FImportingFromXML then
          begin
            Tmp := TTemplate.CreateFromXML(FXMLTemplateElement, ownr);
            ACheckBox.Checked := ACheckBox.Checked and Tmp.Active;
          end
          else
          begin
            Tmp := TTemplate.Create('0^T^A^' + NewTemplateName + '^^^' + ownr);
            Tmp.BackupItems;
            Templates.AddObject(Tmp.ID, Tmp);
          end;
          btnApply.Enabled := TRUE;
          if (idx >= Owner.Items.Count) then
            Owner.Items.Add(Tmp)
          else
            Owner.Items.Insert(idx, Tmp);
          Resync([Owner]);
          Node := FCurTree.Selected;
          if (Node.Data <> Tmp) then
          begin
            if (TTemplate(Node.Data).RealType = ttDoc) then
              Node := Node.GetNextSibling
            else
            begin
              Node.Expand(FALSE);
              Node := Node.GetFirstChild;
            end;
            FCurTree.Selected := Node;
          end;
          FBtnNewNode := Node;
          if (FFirstShow) then
            FFocusName := TRUE
          else
          begin
            edtName.SetFocus;
            edtName.SelectAll;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.btnApplyClick(Sender: TObject);
begin
  if (ScanNames) then
  begin
    SaveAllTemplates;
    BtnApply.Enabled := BackupDiffers;
    if not BtnApply.Enabled then
      UnlockAllTemplates;
  end;
end;

procedure TfrmTemplateEditor.FormCreate(Sender: TObject);
begin
  SetFormPosition(Self);
  ResizeAnchoredFormToFont(self);
  //Now fix everything the resize messed up
  lblLines.Width := cbLock.Left - lblLines.Left - 15;
  sbPerDelete.Left := pnlPersonalBottom.ClientWidth - sbPerDelete.Width - 1;
  sbPerDown.Left := sbPerDelete.Left - sbPerDown.Width - 2;
  sbPerUp.Left := sbPerDown.Left - sbPerUp.Width - 2;
  cbPerHide.Width := sbPerUp.Left - 3;
  btnPerFind.Left := pnlPerSearch.ClientWidth - btnPerFind.Width;

  FSavePause := Application.HintHidePause;
  Application.HintHidePause := FSavePause * 2;
  if InteractiveRemindersActive then
  begin
//    QuickCopy(GetTemplateAllowedReminderDialogs, cbxRemDlgs.Items);
    cbxRemDlgs.Items.Text := GetTemplateAllowedReminderDialogs.Text;
    FCanDoReminders := (cbxRemDlgs.Items.Count > 0);
  end
  else
    FCanDoReminders := FALSE;

//  QuickCopy(GetAllActiveCOMObjects, cbxCOMObj.Items);
  cbxCOMObj.Items.Text := GetAllActiveCOMObjects.Text;
  FCanDoCOMObjects := (cbxCOMObj.Items.Count > 0);

  FUpdating := TRUE;
  FFirstShow := TRUE;

  FTreeControl[ttShared, tcDel] := sbShDelete;
  FTreeControl[ttShared, tcUp] := sbShUp;
  FTreeControl[ttShared, tcDown] := sbShDown;
  FTreeControl[ttShared, tcLbl] := lblCopy;
  FTreeControl[ttShared, tcCopy] := sbCopyRight;
  FTreeControl[ttPersonal, tcDel] := sbPerDelete;
  FTreeControl[ttPersonal, tcUp] := sbPerUp;
  FTreeControl[ttPersonal, tcDown] := sbPerDown;
  FTreeControl[ttPersonal, tcLbl] := lblCopy;
  FTreeControl[ttPersonal, tcCopy] := sbCopyLeft;
  dmodShared.InEditor := TRUE;
  dmodShared.OnTemplateLock := TemplateLocked;

  gbProperties.Caption := PropText;
  pnlShSearch.Visible := FALSE;
  pnlPerSearch.Visible := FALSE;
  FCanEditPersonal := TRUE;

{ Don't mess with the order of the following commands! }
  InitTrees;

  tvPersonal.Selected := tvPersonal.Items.GetFirstNode;

  ClearBackup;

  cboOwner.SelText := MixedCase(User.Name);
  NewPersonalUser(User.DUZ);

  cbEditShared.Visible := (UserTemplateAccessLevel = taEditor);
  FCanEditShared := FALSE;
  SharedEditing;

  HideControls;

  lblCopy.AutoSize := TRUE;
  lblCopy.AutoSize := FALSE; // resets height based on font
  lblCopy.Width := pnlCopyBtns.Width + splMiddle.Width;
  MoveCopyButtons;

  cbShHide.Checked := TRUE;
  cbPerHide.Checked := TRUE;

  BtnApply.Enabled := BackupDiffers;
  //SetFormPosition(Self);
end;

procedure TfrmTemplateEditor.HideControls;
begin
  sbCopyRight.Visible := FCanEditPersonal;
  if (not FCanEditPersonal) then
    cbPerHide.Checked := TRUE;
  cbPerHide.Visible := FCanEditPersonal;
  sbPerDelete.Visible := FCanEditPersonal;
  sbPerUp.Visible := FCanEditPersonal;
  sbPerDown.Visible := FCanEditPersonal;
  tvPersonal.ReadOnly := not FCanEditPersonal;
  MoveCopyButtons;
end;

procedure TfrmTemplateEditor.cboOwnerNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
//  cboOwner.ForDataUse(SubSetOfTemplateOwners(StartFrom, Direction));
end;

procedure TfrmTemplateEditor.cboOwnerChange(Sender: TObject);
begin
  NewPersonalUser(cboOwner.ItemIEN);
end;

procedure TfrmTemplateEditor.NewPersonalUser(UsrIEN: Int64);
var
  NewEdit: boolean;

begin
  FCurrentPersonalUser := UsrIEN;
  NewEdit := (FCurrentPersonalUser = User.DUZ);
  if (FCanEditPersonal <> NewEdit) then
  begin
    FCanEditPersonal := NewEdit;
    HideControls;
  end;
end;

procedure TfrmTemplateEditor.tvPersonalExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  AllowExpansion := dmodShared.ExpandNode(tvPersonal, Node,
    FPersonalEmptyNodeCount, not cbPerHide.Checked);
  if (AllowExpansion and FInternalHiddenExpand) then
    AllowExpansion := FALSE;
end;

procedure TfrmTemplateEditor.tvSharedExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  AllowExpansion := dmodShared.ExpandNode(tvShared, Node,
    FSharedEmptyNodeCount, not cbShHide.Checked);
  if (AllowExpansion and FInternalHiddenExpand) then
    AllowExpansion := FALSE;
end;

procedure TfrmTemplateEditor.tvTreeGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.ImageIndex := dmodShared.ImgIdx(Node);
end;

procedure TfrmTemplateEditor.tvTreeGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := dmodShared.ImgIdx(Node);
end;

function TfrmTemplateEditor.IsTemplateLocked(Node: TTreeNode): boolean;
var
  Template: TTemplate;

begin
  Result := FALSE;
  if assigned(Node) then
  begin
    Template := TTemplate(Node.Data);
    if Template.AutoLock then
      Result := TRUE
    else
      if (Template.PersonalOwner = 0) then
      begin
        if RootTemplate.IsLocked then
          Result := TRUE
        else
        begin
          Result := TTemplate(Node.Data).IsLocked;
          if (not Result) and assigned(Node.Parent) and
            (TTemplate(Node.Parent).PersonalOwner = 0) then
            Result := IsTemplateLocked(Node.Parent);
        end;
      end;
  end;
end;

procedure TfrmTemplateEditor.tvTreeChange(Sender: TObject;
  Node: TTreeNode);
var
  ok, Something: boolean;
  Template: TTemplate;

begin
  ChangeTree(TTreeView(Sender));
  Something := assigned(Node);
  if Something then
  begin
    Template := TTemplate(Node.Data);
    Something := assigned(Template);
    if Something then
    begin
      if (Sender = tvPersonal) then
      begin
        ok := FCanEditPersonal;
        if ok and (Template.PersonalOwner = 0) and IsTemplateLocked(Node) then
          ok := FALSE;
      end
      else
        ok := FCanEditShared;
      EnableControls(ok, (Template.RealType in AllTemplateRootTypes));
      ShowInfo(Node);
    end;
  end;
  if not Something then
  begin
    gbProperties.Caption := PropText;
    EnableControls(FALSE, FALSE);
    ShowInfo(nil);
  end;
end;

procedure TfrmTemplateEditor.EnableControls(ok, Root: boolean);
begin
  cbLock.Enabled := ok and (FCurTree = tvShared);
  if (ok and Root) then
  begin
    ok := FALSE;
    lblName.Enabled := TRUE;
    edtName.Enabled := TRUE;
    reNotes.ReadOnly := FALSE;
  end
  else
  begin
    lblName.Enabled := ok;
    edtName.Enabled := ok;
    reNotes.ReadOnly := not ok;
  end;
  lblNotes.Enabled := (not reNotes.ReadOnly);
  UpdateReadOnlyColorScheme(reNotes, reNotes.ReadOnly);
  cbxType.Enabled := ok;
  lblType.Enabled := ok;
  lblRemDlg.Enabled := ok;
  cbxRemDlgs.Enabled := ok and FCanDoReminders;
  cbActive.Enabled := ok;
  cbExclude.Enabled := ok;
  cbDisplayOnly.Enabled := ok;
  cbFirstLine.Enabled := ok;
  cbOneItemOnly.Enabled := ok;
  cbHideDlgItems.Enabled := ok;
  cbHideItems.Enabled := ok;
  cbIndent.Enabled := ok;
  edtGap.Enabled := ok;
  udGap.Enabled := ok;
  udGap.Invalidate;
  lblLines.Enabled := ok;
  reBoil.ReadOnly := not ok;
  UpdateReadOnlyColorScheme(reBoil, not ok);
  lblLink.Enabled := ok;
  cbxLink.Enabled := ok;
  ok := ok and FCanDoCOMObjects;
  cbxCOMObj.Enabled := ok;
  lblCOMObj.Enabled := ok;
  edtCOMParam.Enabled := ok;
  lblCOMParam.Enabled := ok;
  UpdateInsertsDialogs;
  EnableNavControls;
end;

procedure TfrmTemplateEditor.MoveCopyButtons;
var
  tmpHeight: integer;

begin
  tmpHeight := tvShared.Height;
  dec(tmpHeight, lblCopy.Height);
  if (sbCopyLeft.Visible) then
    dec(tmpHeight, sbCopyLeft.Height + 5);
  if (sbCopyRight.Visible) then
    dec(tmpHeight, sbCopyRight.Height + 5);
  tmpHeight := (tmpHeight div 2) + tvShared.Top;
  lblCopy.Top := tmpHeight;
  inc(tmpHeight, lblCopy.height + 5);
  if (sbCopyLeft.Visible) then
  begin
    sbCopyLeft.Top := tmpHeight;
    inc(tmpHeight, sbCopyLeft.Height + 5);
  end;
  if (sbCopyRight.Visible) then
    sbCopyRight.Top := tmpHeight;
end;

procedure TfrmTemplateEditor.splMainCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  inherited;
  if (pnlGroupBP.Height - (NewSize - splMain.Top) <= pnlGroupBP.Constraints.MinHeight) and (NewSize > splMain.Top) then begin
    //Moving Down
    Accept := False;
    NewSize := splMain.Top;
  end else Accept := True; //Moving Up
end;

procedure TfrmTemplateEditor.splMainMoved(Sender: TObject);
begin
  MoveCopyButtons;
end;

procedure TfrmTemplateEditor.ShowGroupBoilerplate(Visible: boolean);
begin
  pnlGroupBP.Visible := Visible;
  splBoil.Visible := Visible;
  if Visible then
  begin
    reBoil.Align := alTop;
    pnlGroupBP.Align := alClient;
    reBoil.Height := tmplEditorSplitterBoil;
    splBoil.Top := pnlGroupBP.Top - splBoil.Height;
  end
  else
  begin
    pnlGroupBP.Align := alBottom;
    reBoil.Align := alClient;
    pnlNotes.Constraints.MaxHeight := 0;
  end;
end;

procedure TfrmTemplateEditor.ShowBoilerPlate(Hide: Boolean);
begin
 LockWindowUpdate(Self.Handle);
 PnlBP.Visible := Hide;

 lblBoilerplate.Visible := Hide;
 reBoil.Visible := Hide;
 LockWindowUpdate(0);
end;


procedure TfrmTemplateEditor.ShowInfo(Node: TTreeNode);
var
  OldUpdating, ClearName, ClearRB, ClearAll: boolean;
  Idx: TTypeIndex;
  CanDoCOM: boolean;
  lt: TTemplateLinkType;
  lts: string;

begin
  OldUpdating := FUpdating;
  FUpdating := TRUE;
  try
    if (assigned(Node)) then
    begin
      FShowingTemplate := TTemplate(Node.Data);
      with FShowingTemplate do
      begin
        ClearName := FALSE;
        ClearRB := FALSE;
        ClearAll := FALSE;
        ShowTemplateType(TTemplate(Node.Data));
        lt := GetLinkType(Node);
        if (lt = ltNone) or (IsReminderDialog and (not (lt in [ltNone, ltTitle]))) then
          pnlLink.Visible := FALSE
        else
        begin
          pnlLink.Visible := TRUE;
          pnlLink.Tag := ord(lt);
          case lt of
            ltTitle: lts := 'Title';
            ltConsult: lts := 'Consult Service';
            ltProcedure: lts := 'Procedure';
          else lts := '';
          end;
          cbxLink.Clear;
          if lt = ltConsult then
          begin
            cbxLink.LongList := FALSE;
            if not assigned(FConsultServices) then
            begin
              FConsultServices := TStringList.Create;
              FastAssign(LoadServiceListWithSynonyms(1), FConsultServices);
              SortByPiece(FConsultServices, U, 2);
            end;
            FastAssign(FConsultServices, cbxLink.Items);
          end
          else
          begin
            cbxLink.LongList := TRUE;
            cbxLink.HideSynonyms := TRUE;
            cbxLink.InitLongList(LinkName);
          end;
          cbxLink.SelectByID(LinkIEN);
          lblLink.Caption := ' Associated ' + lts + ': ';
          cbxLink.Caption := lblLink.Caption;
        end;

        edtName.Text := PrintName;
        reNotes.Lines.Text := Description;
        if (PersonalOwner = 0) and (FCurTree = tvShared) and (cbEditShared.Checked) then
        begin
          cbLock.Checked := IsLocked;
          if AutoLock then
            cbLock.Enabled := FALSE;
        end
        else
        begin
          cbLock.Checked := IsTemplateLocked(Node);
          cbLock.Enabled := FALSE;
        end;
        CanDoCom := FCanDoCOMObjects and (PersonalOwner = 0);
        if (RealType in AllTemplateRootTypes) then
        begin
          ClearRB := TRUE;
          ClearAll := TRUE;
        end
        else
        begin
          case RealType of
            ttDoc: begin
                if IsReminderDialog then
                  Idx := tiRemDlg
                else
                  if IsCOMObject then
                    Idx := tiCOMObj
                  else
                    Idx := tiTemplate;
              end;
            ttGroup: begin
                if (Dialog) then
                  Idx := tiDialog
                else
                  Idx := tiGroup;
              end;
            ttClass: Idx := tiFolder;
          else Idx := tiNone;
          end;
          FForceContainer := ((RealType in [ttGroup, ttClass]) and (Children <> tcNone));
          cbxType.Items.Clear;
          if not FForceContainer then
            cbxType.Items.Add('Template');
          cbxType.Items.Add('Folder');
          cbxType.Items.Add('Group Template');
          cbxType.Items.Add('Dialog');
          if (not FForceContainer) then
          begin
            if (FCanDoReminders or CanDoCOM) then
              cbxType.Items.Add('Reminder Dialog');
            if (CanDoCOM) then
              cbxType.Items.Add('COM Object');
          end;
          cbxType.ItemIndex := ForcedIdx[FForceContainer, Idx];
          if (Idx = tiRemDlg) and FCanDoReminders then
            cbxRemDlgs.SelectByID(ReminderDialogIEN)
          else
          begin
            lblRemDlg.Enabled := FALSE;
            cbxRemDlgs.Enabled := FALSE;
            cbxRemDlgs.ItemIndex := -1;
          end;
          if (Idx = tiCOMObj) and CanDoCOM then
          begin
            pnlCOM.Visible := TRUE;
            cbxCOMObj.SelectByIEN(COMObject);
            edtCOMParam.Text := COMParam;
          end
          else
          begin
            pnlCOM.Visible := FALSE;
            cbxCOMObj.ItemIndex := -1;
            edtCOMParam.Text := '';
          end;
          cbActive.Checked := Active;
          if (RealType in [ttClass, ttGroup]) then
            cbHideItems.Checked := HideItems
          else
          begin
            cbHideItems.Checked := FALSE;
            cbHideItems.Enabled := FALSE;
          end;
          if ((RealType in [ttDoc, ttGroup]) and (assigned(Node.Parent)) and
            (TTemplate(Node.Parent.Data).RealType = ttGroup) and
            (not IsReminderDialog) and (not IsCOMObject)) then
            cbExclude.Checked := Exclude
          else
          begin
            cbExclude.Checked := FALSE;
            cbExclude.Enabled := FALSE;
          end;
          if dmodShared.InDialog(Node) and (not IsReminderDialog) and (not IsCOMObject) then
          begin
            cbDisplayOnly.Checked := DisplayOnly;
            cbFirstLine.Checked := FirstLine;
          end
          else
          begin
            cbDisplayOnly.Checked := FALSE;
            cbDisplayOnly.Enabled := FALSE;
            cbFirstLine.Checked := FALSE;
            cbFirstLine.Enabled := FALSE;
          end;
          if (RealType in [ttGroup, ttClass]) and (Children <> tcNone) and
            (dmodShared.InDialog(Node)) then
          begin
            cbOneItemOnly.Checked := OneItemOnly;
            cbIndent.Checked := IndentItems;
            if (RealType = ttGroup) and (Boilerplate <> '') then
            begin
              cbHideDlgItems.Checked := HideDlgItems;
            end
            else
            begin
              cbHideDlgItems.Checked := FALSE;
              cbHideDlgItems.Enabled := FALSE;
            end;
          end
          else
          begin
            cbOneItemOnly.Checked := FALSE;
            cbOneItemOnly.Enabled := FALSE;
            cbHideDlgItems.Checked := FALSE;
            cbHideDlgItems.Enabled := FALSE;
            cbIndent.Checked := FALSE;
            cbIndent.Enabled := FALSE;
          end;
          if (RealType = ttGroup) then
            edtGap.Text := IntToStr(Gap)
          else
          begin
            edtGap.Text := '0';
            edtGap.Enabled := FALSE;
            udGap.Enabled := FALSE;
            udGap.Invalidate;
            lblLines.Enabled := FALSE;
          end;
          DisplayBoilerPlate(Node);
        end;
      end;
    end
    else
    begin
      ClearAll := TRUE;
      ClearRB := TRUE;
      ClearName := TRUE;
      gbProperties.Caption := PropText;
    end;
    if (ClearName) then
    begin
      edtName.Text := '';
      reNotes.Clear;
    end;
    if (ClearRB) then
    begin
      cbxType.ItemIndex := Ord(tiNone);
    end;
    if (ClearAll) then
    begin
      cbActive.Checked := FALSE;
      cbExclude.Checked := FALSE;
      cbDisplayOnly.Checked := FALSE;
      cbFirstLine.Checked := FALSE;
      cbOneItemOnly.Checked := FALSE;
      cbHideDlgItems.Checked := FALSE;
      cbHideItems.Checked := FALSE;
      cbIndent.Checked := FALSE;
      edtGap.Text := '0';
      reBoil.Clear;
      ShowGroupBoilerplate(False);
      pnlBoilerplateResize(Self);
      pnlCOM.Visible := FALSE;
      pnlLink.Visible := FALSE;
    end;
    if cbDisplayOnly.Enabled or
      cbFirstLine.Enabled or
      cbIndent.Enabled or
      cbOneItemOnly.Enabled or
      cbHideDlgItems.Enabled then
      gbDialogProps.Font.Color := clWindowText
    else
      gbDialogProps.Font.Color := clInactiveCaption;
  finally
    FUpdating := OldUpdating;
  end;
end;

procedure TfrmTemplateEditor.pnlBoilerplateResize(Sender: TObject);
var
  Max: integer;

begin
  if (pnlGroupBP.Visible) and (pnlGroupBP.Height > (pnlBoilerplate.Height - 29)) then
  begin
    pnlGroupBP.Height := pnlBoilerplate.Height - 29;
  end;
  if cbLongLines.checked then
    Max := 240
  else
    Max := MAX_ENTRY_WIDTH - 1;
  LimitEditWidth(reBoil, Max);
  LimitEditWidth(reNotes, MAX_ENTRY_WIDTH);
end;

procedure TfrmTemplateEditor.edtNameOldChange(Sender: TObject);
var
  i: integer;
  Template: TTemplate;
  DoRefresh: boolean;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      DoRefresh := Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        Template.PrintName := edtName.Text;
        UpdateApply(Template);
        for i := 0 to Template.Nodes.Count - 1 do
          TTreeNode(Template.Nodes.Objects[i]).Text := Template.PrintName;
        if (DoRefresh) then
        begin
          tvShared.Invalidate;
          tvPersonal.Invalidate;
        end;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.cbActiveClick(Sender: TObject);
var
  i: integer;
  Template: TTemplate;
  Node: TTreeNode;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        Template.Active := cbActive.Checked;
        UpdateApply(Template);
        for i := 0 to Template.Nodes.Count - 1 do
        begin
          Node := TTreeNode(Template.Nodes.Objects[i]);
          Node.Cut := not Template.Active;
        end;
        if (FCurTree = tvShared) then
        begin
          cbPerHideClick(Sender);
          cbShHideClick(Sender);
        end
        else
        begin
          cbShHideClick(Sender);
          cbPerHideClick(Sender);
        end;
        tvTreeChange(FCurTree, FCurTree.Selected);
        EnableNavControls;
        if cbActive.CanFocus then
          cbActive.SetFocus;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.cbExcludeClick(Sender: TObject);
var
  i: integer;
  Template: TTemplate;
  Node: TTreeNode;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        Template.Exclude := cbExclude.Checked;
        UpdateApply(Template);
        for i := 0 to Template.Nodes.Count - 1 do
        begin
          Node := TTreeNode(Template.Nodes.Objects[i]);
          Node.ImageIndex := dmodShared.ImgIdx(Node);
          Node.SelectedIndex := dmodShared.ImgIdx(Node);
        end;
        tvShared.Invalidate;
        tvPersonal.Invalidate;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.edtGapChange(Sender: TObject);
var
  DoRefresh: boolean;
  Template: TTemplate;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      DoRefresh := Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        Template.Gap := StrToIntDef(edtGap.Text, 0);
        UpdateApply(Template);
        DisplayBoilerPlate(FCurTree.Selected);
        if (DoRefresh) then
        begin
          tvShared.Invalidate;
          tvPersonal.Invalidate;
        end;
      end;
    end;
  end;
end;

function TfrmTemplateEditor.ChangeTree(NewTree: TTreeView): boolean;
var
  i: TTemplateTreeControl;

begin
  Result := FALSE;
  tvShared.HideSelection := TRUE;
  tvPersonal.HideSelection := TRUE;
  if (NewTree <> FCurTree) then
  begin
    Result := TRUE;
    if (assigned(FCurTree)) then
    begin
      for i := low(TTemplateTreeControl) to high(TTemplateTreeControl) do
        FTreeControl[TTemplateTreeType(FCurTree.Tag), i].Enabled := FALSE;
    end;
    FCurTree := NewTree;
  end;
  if (assigned(FCurTree)) then
  begin
    FCurTree.HideSelection := FALSE;
    if (FCurTree = tvPersonal) and (Screen.ActiveControl = tvShared) then
      tvPersonal.SetFocus
    else
      if (FCurTree = tvShared) and (Screen.ActiveControl = tvPersonal) then
        tvShared.SetFocus;
  end;
end;

procedure TfrmTemplateEditor.tvTreeEnter(Sender: TObject);
begin
  if ((Sender is TTreeView) and (ChangeTree(TTreeView(Sender)))) then
    tvTreeChange(Sender, TTreeView(Sender).Selected);
end;

procedure TfrmTemplateEditor.tvTreeNodeEdited(Sender: TObject;
  Node: TTreeNode; var S: string);
begin
  FUpdating := TRUE;
  try
    edtName.Text := S;
  finally
    FUpdating := FALSE;
  end;
  edtNameOldChange(edtName);
end;

procedure TfrmTemplateEditor.cbShHideClick(Sender: TObject);
var
  Node: TTreeNode;

begin
  Node := tvShared.Items.GetFirstNode;
  while assigned(Node) do
  begin
    dmodShared.Resync(Node, not cbShHide.Checked, FSharedEmptyNodeCount);
    Node := Node.getNextSibling;
  end;
  tvTreeChange(tvShared, tvShared.Selected);
  EnableNavControls;
end;

procedure TfrmTemplateEditor.cbPerHideClick(Sender: TObject);
begin
  dmodShared.Resync(tvPersonal.Items.GetFirstNode, not cbPerHide.Checked,
    FPersonalEmptyNodeCount);
  tvTreeChange(tvPersonal, tvPersonal.Selected);
  EnableNavControls;
end;

procedure TfrmTemplateEditor.DisplayBoilerplate(Node: TTreeNode);
var
  OldUpdating, ItemOK, BPOK, LongLines: boolean;
  i: integer;
  TmpSL: TStringList;

begin
  OldUpdating := FUpdating;
  FUpdating := TRUE;
  try
    pnlBoilerplateResize(pnlBoilerplate);
    reBoil.Clear;
    ItemOK := FALSE;
    BPOK := TRUE;
    with Node, TTemplate(Node.Data) do
    begin
      if (RealType in [ttDoc, ttGroup]) then
      begin
        TmpSL := TStringList.Create;
        try
          if (RealType = ttGroup) and (not reBoil.ReadOnly) then
          begin
            ItemOK := TRUE;
            TmpSL.Text := Boilerplate;
            reGroupBP.Clear;
            reGroupBP.SelText := FullBoilerplate;
          end
          else
            TmpSL.Text := FullBoilerplate;
          LongLines := FALSE;
          for i := 0 to TmpSL.Count - 1 do
          begin
            if length(TmpSL[i]) > MAX_ENTRY_WIDTH then
            begin
              LongLines := TRUE;
              break;
            end;
          end;
          cbLongLines.Checked := LongLines;
          reBoil.SelText := TmpSL.Text;
        finally
          TmpSL.Free;
        end;
      end
      else
      begin
        reBoil.ReadOnly := TRUE;
        UpdateReadOnlyColorScheme(reBoil, TRUE);
        UpdateInsertsDialogs;
      end;

      if (not ItemOK) and (IsReminderDialog or IsCOMObject) then
        BPOK := FALSE;

      ShowBoilerPlate(BPOK);
      ShowGroupBoilerplate(ItemOK);

      pnlBoilerplateResize(Self);
      pnlCOM.Visible := (not BPOK) and IsCOMObject;
    end;
  finally
    FUpdating := OldUpdating;
  end;
end;

procedure TfrmTemplateEditor.FormDestroy(Sender: TObject);
begin
  KillObj(@FConsultServices);
  Application.HintHidePause := FSavePause;
  if (assigned(frmTemplateObjects)) then
  begin
    frmTemplateObjects.Free;
    frmTemplateObjects := nil;
  end;
  if (assigned(frmTemplateFields)) then
  begin
    frmTemplateFields.Free;
    frmTemplateFields := nil;
  end;
  //---------- CQ #8665 - RV --------
  //KillObj(@FPersonalObjects);
  if (assigned(uPersonalObjects)) then
  begin
    KillObj(@uPersonalObjects);
    uPersonalObjects.Free;
    uPersonalObjects := nil;
  end;
  // ----  end CQ #8665 -------------
  dmodShared.OnTemplateLock := nil;
  dmodShared.InEditor := FALSE;
  RemoveAllNodes;
  ClearBackup;
  UnlockAllTemplates;
  dmodShared.Reload;
end;

procedure TfrmTemplateEditor.sbMoveUpClick(Sender: TObject);
var
  idx: integer;
  ChangeLevel: boolean;
  ParentsParent, ParentNode, Node: TTreeNode;
  NodeTemplate, ParentTemplate, Template: TTemplate;
  Hide, First, ok: boolean;

begin
  if ((assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    (assigned(FCurTree.Selected.Parent))) then
  begin
    Node := FCurTree.Selected;
    NodeTemplate := TTemplate(Node.Data);
    ParentNode := Node.Parent;
    Template := TTemplate(ParentNode.Data);
    idx := Template.Items.IndexOf(NodeTemplate);
    ChangeLevel := (idx < 1);
    if (not ChangeLevel) then
    begin
      if (TTemplateTreeType(TBitBtn(Sender).Tag) = ttShared) then
        Hide := cbShHide.Checked
      else
        Hide := cbPerHide.Checked;
      First := TRUE;
      while (idx > 0) do
      begin
        if First then
        begin
          ok := FALSE;
          First := FALSE;
          if CanClone(ParentNode) then
          begin
            if (Clone(ParentNode)) then
              Template := TTemplate(ParentNode.Data);
            if Template.CanModify then
              ok := TRUE;
          end;
        end
        else
          ok := TRUE;
        if ok then
        begin
          Template.Items.Exchange(idx - 1, idx);
          if (Hide and (not TTemplate(Template.Items[idx]).Active)) then
          begin
            dec(idx);
            ChangeLevel := (idx < 1);
          end
          else
            idx := 0;
        end
        else
          idx := 0;
      end;
    end;
    if (ChangeLevel) then
    begin
      ParentsParent := ParentNode.Parent;
      if (assigned(ParentsParent)) then
      begin
        ParentTemplate := TTemplate(ParentsParent.Data);
        if (ParentTemplate.Items.IndexOf(NodeTemplate) >= 0) then
          InfoBox(ParentsParent.Text + ' already contains the ' +
            NodeTemplate.PrintName + ' template.',
            'Error', MB_OK or MB_ICONERROR)
        else
        begin
          if CanClone(ParentNode) then
          begin
            if (Clone(ParentNode)) then
              Template := TTemplate(ParentNode.Data);
            if Template.CanModify and CanClone(ParentsParent) then
            begin
              if (Clone(ParentsParent)) then
                ParentTemplate := TTemplate(ParentsParent.Data);
              if ParentTemplate.CanModify then
              begin
                Template.Items.Delete(idx);
                idx := ParentTemplate.Items.IndexOf(Template);
                if (idx >= 0) then
                begin
                  ParentTemplate.Items.Insert(idx, NodeTemplate);
                  Resync([ParentTemplate, Template]);
                  btnApply.Enabled := TRUE;
                end;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      Resync([Template]);
      btnApply.Enabled := TRUE;
    end;
  end;
end;

procedure TfrmTemplateEditor.sbMoveDownClick(Sender: TObject);
var
  max, idx: integer;
  ChangeLevel: boolean;
  ParentsParent, ParentNode, Node: TTreeNode;
  NodeTemplate, ParentTemplate, Template: TTemplate;
  Hide, First, ok: boolean;

begin
  if ((assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    (assigned(FCurTree.Selected.Parent))) then
  begin
    Node := FCurTree.Selected;
    NodeTemplate := TTemplate(Node.Data);
    ParentNode := Node.Parent;
    Template := TTemplate(ParentNode.Data);
    idx := Template.Items.IndexOf(NodeTemplate);
    max := Template.Items.Count - 1;
    ChangeLevel := (idx >= max);
    if (not ChangeLevel) then
    begin
      if (TTemplateTreeType(TBitBtn(Sender).Tag) = ttShared) then
        Hide := cbShHide.Checked
      else
        Hide := cbPerHide.Checked;
      First := TRUE;
      while (idx < max) do
      begin
        if First then
        begin
          ok := FALSE;
          First := FALSE;
          if CanClone(ParentNode) then
          begin
            if (Clone(ParentNode)) then
              Template := TTemplate(ParentNode.Data);
            if Template.CanModify then
              ok := TRUE;
          end;
        end
        else
          ok := TRUE;
        if ok then
        begin
          Template.Items.Exchange(idx, idx + 1);
          if (Hide and (not TTemplate(Template.Items[idx]).Active)) then
          begin
            inc(idx);
            ChangeLevel := (idx >= max);
          end
          else
            idx := max;
        end
        else
          idx := max;
      end;
    end;
    if (ChangeLevel) then
    begin
      ParentsParent := ParentNode.Parent;
      if (assigned(ParentsParent)) then
      begin
        ParentTemplate := TTemplate(ParentsParent.Data);
        if (ParentTemplate.Items.IndexOf(NodeTemplate) >= 0) then
          InfoBox(ParentsParent.Text + ' already contains the ' +
            NodeTemplate.PrintName + ' template.',
            'Error', MB_OK or MB_ICONERROR)
        else
        begin
          if CanClone(ParentNode) then
          begin
            if (Clone(ParentNode)) then
              Template := TTemplate(ParentNode.Data);
            if Template.CanModify and CanClone(ParentsParent) then
            begin
              if (Clone(ParentsParent)) then
                ParentTemplate := TTemplate(ParentsParent.Data);
              if ParentTemplate.CanModify then
              begin
                Template.Items.Delete(idx);
                idx := ParentTemplate.Items.IndexOf(Template);
                if (idx >= 0) then
                begin
                  if (idx = (ParentTemplate.Items.Count - 1)) then
                    ParentTemplate.Items.Add(NodeTemplate)
                  else
                    ParentTemplate.Items.Insert(idx + 1, NodeTemplate);
                  Resync([ParentTemplate, Template]);
                  btnApply.Enabled := TRUE;
                end;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      Resync([Template]);
      btnApply.Enabled := TRUE;
    end;
  end;
end;

procedure TfrmTemplateEditor.sbDeleteClick(Sender: TObject);
var
  PNode, Node: TTreeNode;
  Template, Parent: TTemplate;
  DoIt: boolean;
  Answer: Word;

begin
  if ((assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    (assigned(FCurTree.Selected.Parent))) then
  begin
    Node := FCurTree.Selected;
    Template := TTemplate(Node.Data);
    PNode := Node.Parent;
    Parent := TTemplate(PNode.Data);
    if (AutoDel(Template)) then
      DoIt := TRUE
    else
      if (Template.Active) and (cbActive.Checked) then
      begin
        DoIt := FALSE;
        Answer := MessageDlg('Once you delete a template you may not be able to retrieve it.' + CRLF +
          'Rather than deleting, you may want to inactivate a template instead.' + CRLF +
          'You may inactivate this template by pressing the Ignore button now.' + CRLF +
          'Are you sure you want to delete the "' + Node.Text +
          '" Template?', mtConfirmation, [mbYes, mbNo, mbIgnore], 0);
        if (Answer = mrYes) then
          DoIt := TRUE
        else
          if (Answer = mrIgnore) then
            cbActive.Checked := FALSE;
      end
      else
        DoIt := InfoBox('Are you sure you want to delete the "' + Node.Text +
          '" Template?', 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES;
    if (DoIt and CanClone(PNode)) then
    begin
      if (Clone(PNode)) then
        Parent := TTemplate(PNode.Data);
      if assigned(Parent) and Parent.CanModify then
      begin
        btnApply.Enabled := TRUE;
        Parent.RemoveChild(Template);
        MarkDeleted(Template);
        Resync([Parent]);
        tvTreeChange(FCurTree, FCurTree.Selected);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.EnableNavControls;
var
  i: TTemplateTreeControl;
  AllowUp, AllowDown, AllowSet: boolean;
  Node: TTreeNode;
  Tree: TTemplateTreeType;
  Curok: boolean;
  OldActiveControl: TControl;
begin
  if (Assigned(FCurTree)) then
  begin
    Tree := TTemplateTreeType(FCurTree.Tag);
    Node := FCurTree.Selected;
    if (Assigned(Node)) then
      Curok := (TTemplate(Node.Data).RealType in [ttDoc, ttGroup, ttClass])
    else
      Curok := FALSE;
    if (Curok) then
    begin
      OldActiveControl := ActiveControl;
      FTreeControl[Tree, tcDel].Enabled := TRUE;
      AllowSet := FALSE;
      if (Node.Index > 0) then
        AllowUp := TRUE
      else
      begin
        AllowUp := AllowMove(Node.Parent.Parent, Node);
        AllowSet := TRUE;
      end;
      FTreeControl[Tree, tcUp].Enabled := AllowUp;
      AllowDown := AllowUp;
      if (Node.Index < (Node.Parent.Count - 1)) then
        AllowDown := TRUE
      else
      begin
        if (not AllowSet) then
          AllowDown := AllowMove(Node.Parent.Parent, Node);
      end;
      FTreeControl[Tree, tcDown].Enabled := AllowDown;
      if not AllowUp and (OldActiveControl = FTreeControl[Tree, tcUp]) then
        (FTreeControl[Tree, tcDown] as TWinControl).SetFocus;
      if not AllowDown and (OldActiveControl = FTreeControl[Tree, tcDown]) then
        (FTreeControl[Tree, tcUp] as TWinControl).SetFocus;
      FTreeControl[Tree, tcCopy].Enabled := FTreeControl[TTemplateTreeType(1 - ord(Tree)), tcDel].Visible;
      if (FTreeControl[Tree, tcCopy].Enabled) then
      begin
        if (Tree = ttShared) then
          Node := tvPersonal.Selected
        else
          Node := tvShared.Selected;
        if (assigned(Node)) then
        begin
          if (TTemplate(Node.Data).RealType = ttDoc) then
            Node := Node.Parent;
          FTreeControl[Tree, tcCopy].Enabled := AllowMove(Node, FCurTree.Selected);
        end
        else
          FTreeControl[Tree, tcCopy].Enabled := FALSE;
      end;
      FTreeControl[Tree, tcLbl].Enabled := FTreeControl[Tree, tcCopy].Enabled;
    end
    else
    begin
      for i := low(TTemplateTreeControl) to high(TTemplateTreeControl) do
        FTreeControl[Tree, i].Enabled := FALSE;
    end;
    if (FCurTree = tvShared) and (FCanEditShared) then
      btnNew.Enabled := TRUE
    else
      if (FCurTree = tvPersonal) and (FCanEditPersonal) then
        btnNew.Enabled := TRUE
      else
        btnNew.Enabled := FALSE;
  end
  else
    btnNew.Enabled := FALSE;
end;

procedure TfrmTemplateEditor.tvTreeDragging(Sender: TObject;
  Node: TTreeNode; var CanDrag: Boolean);

begin
  CanDrag := (TTemplate(Node.Data).RealType in [ttDoc, ttGroup, ttClass]);
  if (CanDrag) then
    FDragNode := Node
  else
    FDragNode := nil;
end;

procedure TfrmTemplateEditor.tvTreeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  TmpNode: TTreeNode;
  Tree: TTreeView;

begin
  FDropNode := nil;
  Accept := FALSE;
  if (Source is TTreeView) and (assigned(FDragNode)) then
  begin
    Tree := TTreeView(Sender);
    FDropNode := Tree.GetNodeAt(X, Y);
    if Tree.ScreenToClient(Mouse.CursorPos).Y >= (Tree.ClientHeight - 5) then
       Tree.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    if (((Tree = tvShared) and (FCanEditShared)) or
      ((Tree = tvPersonal) and (FCanEditPersonal))) then
    begin
      if (assigned(FDropNode)) then
      begin
        FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
        if (FDropInto) then
          TmpNode := FDropNode
        else
          TmpNode := FDropNode.Parent;
        Accept := AllowMove(TmpNode, FDragNode);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.tvTreeDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Src, Template, Item: TTemplate;
  SIdx, idx: integer;
  TmpNode: TTreeNode;

begin
  if (assigned(FDragNode)) and (assigned(FDropNode)) and (FDragNode <> FDropNode) then
  begin
    Item := TTemplate(FDragNode.Data);
    if (FDropInto) then
    begin
      TmpNode := FDropNode;
      idx := 0;
    end
    else
    begin
      TmpNode := FDropNode.Parent;
      idx := TTemplate(FDropNode.Parent.Data).Items.IndexOf(FDropNode.Data);
    end;
    if (AllowMove(TmpNode, FDragNode) and (idx >= 0)) then
    begin
      Template := TTemplate(TmpNode.Data);
      if (Template <> FDragNode.Parent.Data) and
        (Template.Items.IndexOf(Item) >= 0) then
        InfoBox(Template.PrintName + ' already contains the ' +
          Item.PrintName + ' template.',
          'Error', MB_OK or MB_ICONERROR)
      else
      begin
        Src := TTemplate(FDragNode.Parent.Data);
        Sidx := Src.Items.IndexOf(Item);
        if CanClone(TmpNode) then
        begin
          if (Clone(TmpNode)) then
            Template := TTemplate(TmpNode.Data);
          if assigned(Template) and Template.CanModify then
          begin
            if (Sidx >= 0) and (FDragNode.TreeView = FDropNode.TreeView) and
              (not FCopying) then // if same tree delete source
            begin
              if CanClone(FDragNode.Parent) then
              begin
                if (Clone(FDragNode.Parent)) then
                  Src := TTemplate(FDragNode.Parent.Data);
                if assigned(Src) and Src.CanModify then
                begin
                  Src.Items.Delete(Sidx);
                  if (Template = Src) then
                    Src := nil;
                end
                else
                  Src := nil;
              end
              else
                Src := nil;
            end
            else
              Src := nil;
            if (idx > 0) then
              idx := TTemplate(FDropNode.Parent.Data).Items.IndexOf(FDropNode.Data);
            Template.Items.Insert(idx, Item);
            if (TTreeView(FDropNode.TreeView) = tvShared) then
            begin
              Item.PersonalOwner := 0;
              tvPersonal.Invalidate;
            end;
            TTreeView(FDragNode.TreeView).Selected := FDragNode;
            TTreeView(FDragNode.TreeView).SetFocus;
            Resync([Src, Template]);
            btnApply.Enabled := TRUE;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.Resync(const Templates: array of TTemplate);
var
  i, j: integer;
  NodeList: TStringList;
  TemplateList: TStringList;
  Node: TTreeNode;
  tmpl: TTemplate;
  NodeID: string;

begin
  NodeList := TStringList.Create;
  try
    TemplateList := TStringList.Create;
    try
      for i := low(Templates) to high(Templates) do
      begin
        tmpl := Templates[i];
        if (assigned(tmpl)) then
        begin
          for j := 0 to tmpl.Nodes.Count - 1 do
          begin
            Node := TTreeNode(tmpl.Nodes.Objects[j]);
            if (NodeList.IndexOfObject(Node) < 0) then
            begin
              NodeID := IntToStr(Node.Level);
              NodeID := copy('000', 1, 4 - length(NodeID)) + NodeID + U + tmpl.Nodes[j];
              TemplateList.AddObject(NodeID, tmpl);
              NodeList.AddObject(NodeId, Node);
            end;
          end;
        end;
      end;

    { By Sorting by Node Level, we prevent a Resync
      of nodes deeper within the heirchary }

      NodeList.Sort;

      for i := 0 to NodeList.Count - 1 do
      begin
        NodeID := NodeList[i];
        Node := TTreeNode(NodeList.Objects[i]);
        j := TemplateList.IndexOf(NodeID);
        if (j >= 0) then
        begin
          tmpl := TTemplate(TemplateList.Objects[j]);
          NodeID := Piece(NodeID, U, 2);
          if (tmpl.Nodes.IndexOf(NodeID) >= 0) then
          begin
            if (Node.TreeView = tvShared) then
              dmodShared.Resync(Node, not cbShHide.Checked, FSharedEmptyNodeCount)
            else
              if (Node.TreeView = tvPersonal) then
                dmodShared.Resync(Node, not cbPerHide.Checked, FPersonalEmptyNodeCount);
          end;
        end;
      end;
    finally
      TemplateList.Free;
    end;
  finally
    NodeList.Free;
  end;
  EnableNavControls;
  if ((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
    tvTreeChange(FCurTree, FCurTree.Selected)
  else
    tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
  FCopyNode := nil;
end;

procedure TfrmTemplateEditor.sbCopyLeftClick(Sender: TObject);
begin
  if (assigned(tvPersonal.Selected)) then
  begin
    if (not assigned(tvShared.Selected)) then
      tvShared.Selected := tvShared.Items.GetFirstNode;
    FDragNode := tvPersonal.Selected;
    FDropNode := tvShared.Selected;
    FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
    tvTreeDragDrop(tvPersonal, tvShared, 0, 0);
  end;
end;

procedure TfrmTemplateEditor.sbCopyRightClick(Sender: TObject);
begin
  if (assigned(tvShared.Selected)) then
  begin
    if (not assigned(tvPersonal.Selected)) then
      tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
    FDragNode := tvShared.Selected;
    FDropNode := tvPersonal.Selected;
    FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
    tvTreeDragDrop(tvShared, tvPersonal, 0, 0);
  end;
end;

procedure TfrmTemplateEditor.AdjustControls4FontChange;
var
  x: integer;

  procedure Adjust(Control: TWinControl);
  begin
    x := x - Control.Width - 2;
    Control.Left := x;
  end;

begin
  if FCanEditShared then
  begin
    x := pnlSharedBottom.Width;
    Adjust(sbSHDelete);
    Adjust(sbSHDown);
    Adjust(sbSHUp);
    cbSHHide.Width := x;
  end;
  x := pnlBottom.Width;
  Adjust(btnApply);
  Adjust(btnCancel);
  Adjust(btnOK);
  cbEditShared.Width := TextWidthByFont(cbEditShared.Font.Handle, cbEditShared.Caption) + 25;
  cbNotes.Left := cbEditShared.Left + cbEditShared.Width + 60;
  cbNotes.Width := TextWidthByFont(cbNotes.Font.Handle, cbNotes.Caption) + 25;
end;

function TfrmTemplateEditor.AllowMove(ADropNode, ADragNode: TTreeNode): boolean;
var
  i: integer;
  TmpNode: TTreeNode;
  DragTemplate, DropTemplate: TTemplate;

begin
  if (assigned(ADropNode) and assigned(ADragNode)) then
  begin
    DropTemplate := TTemplate(ADropNode.Data);
    DragTemplate := TTemplate(ADragNode.Data);
    if IsTemplateLocked(ADropNode) then
      Result := FALSE
    else
      Result := (DragTemplate.RealType in [ttDoc, ttGroup, ttClass]);
    if (Result) then
    begin
      if (FCopying) then
      begin
        if (DropTemplate.Items.IndexOf(DragTemplate) >= 0) then
          Result := FALSE;
      end
      else
        if ((assigned(ADragNode.Parent)) and (ADropNode <> ADragNode.Parent) and
          (DropTemplate.Items.IndexOf(DragTemplate) >= 0)) then
          Result := FALSE;
    end;
    if (Result) then
    begin
      for i := 0 to DropTemplate.Nodes.Count - 1 do
      begin
        TmpNode := TTreeNode(DropTemplate.Nodes.Objects[i]);
        while (Result and (assigned(TmpNode.Parent))) do
        begin
          if (TmpNode.Data = DragTemplate) then
            Result := FALSE
          else
            TmpNode := TmpNode.Parent;
        end;
        if (not Result) then break;
      end;
    end;
  end
  else
    Result := FALSE;
end;

function TfrmTemplateEditor.Clone(Node: TTreeNode): boolean;
var
  idx: integer;
  Prnt, OldT, NewT: TTemplate;
  PNode: TTreeNode;
  ok: boolean;

begin
  Result := FALSE;
  if ((assigned(Node)) and (TTreeView(Node.TreeView) = tvPersonal)) then
  begin
    OldT := TTemplate(Node.Data);
    if (OldT.PersonalOwner <> User.DUZ) then
    begin
      PNode := Node.Parent;
      Prnt := nil;
      if (assigned(PNode)) then
      begin
        ok := CanClone(PNode);
        if ok then
        begin
          Clone(PNode);
          Prnt := TTemplate(PNode.Data);
          ok := Prnt.CanModify;
        end;
      end
      else
        ok := TRUE;
      if ok then
      begin
        BtnApply.Enabled := TRUE;
        Result := TRUE;
        NewT := OldT.Clone(User.DUZ);
        OldT.RemoveNode(Node);
        MarkDeleted(OldT);
        Node.Data := NewT;
        NewT.AddNode(Node);
        if (assigned(Prnt)) then
        begin
          idx := Prnt.Items.IndexOf(OldT);
          if (idx >= 0) then
            Prnt.Items[idx] := NewT;
        end;
        tvPersonal.Invalidate;
        ShowTemplateType(NewT);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.reBoilChange(Sender: TObject);
var
  DoInfo, DoRefresh: boolean;
  TmpBPlate: string;
  Template: TTemplate;
  x: integer;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    Template := TTemplate(FCurTree.Selected.Data);
    TmpBPlate := reBoil.Lines.Text;
    if (Template.Boilerplate <> TmpBPlate) then
    begin
      if CanClone(FCurTree.Selected) then
      begin
        DoRefresh := Clone(FCurTree.Selected);
        if (DoRefresh) then
          Template := TTemplate(FCurTree.Selected.Data);
        if assigned(Template) and Template.CanModify then
        begin
          DoInfo := FALSE;
          if (Template.Boilerplate = '') or (TmpBPlate = '') then
            DoInfo := TRUE;
          Template.Boilerplate := TmpBPlate;
          TTemplate(FCurTree.Selected.Data).Gap := StrToIntDef(edtGap.Text, 0);
          if (Template.RealType = ttGroup) then
          begin
            reGroupBP.Text := Template.FullBoilerplate;
          end;
          if (DoRefresh) then
          begin
            tvShared.Invalidate;
            tvPersonal.Invalidate;
          end;
          if (DoInfo) then
          begin
            x := reBoil.SelStart;
            ShowInfo(FCurTree.Selected);
            reBoil.SelStart := x;
          end;
        end;
      end;
      btnApply.Enabled := TRUE;
//        reBoil.Lines.Text := Template.Boilerplate;
    end;
  end;
end;

procedure TfrmTemplateEditor.SharedEditing;
begin
{$IFDEF OwnerScan}
  lblPerOwner.Visible := FCanEditShared;
  cboOwner.Visible := FCanEditShared;
{$ELSE}
  lblPerOwner.Visible := FALSE;
  cboOwner.Visible := FALSE;
{$ENDIF}
  sbCopyLeft.Visible := FCanEditShared;
  if (not FCanEditShared) then
    cbShHide.Checked := TRUE;
  cbShHide.Visible := FCanEditShared;
  sbShDelete.Visible := FCanEditShared;
  sbShUp.Visible := FCanEditShared;
  sbShDown.Visible := FCanEditShared;
  tvShared.ReadOnly := not FCanEditShared;
  MoveCopyButtons;
  tvTreeChange(FCurTree, FCurTree.Selected);
  if FCanEditShared then
    AdjustControls4FontChange;
end;

procedure TfrmTemplateEditor.cbEditSharedClick(Sender: TObject);
begin
  FCanEditShared := cbEditShared.Checked;
  SharedEditing;
end;

procedure TfrmTemplateEditor.popTemplatesPopup(Sender: TObject);
var
  Tree: TTreeView;
  Node: TTreeNode;
  FindOn: boolean;
  Txt: string;

begin
  FFromMainMenu := FALSE;
  Tree := GetTree;
  Node := Tree.Selected;
  Tree.Selected := Node; // This line prevents selected from changing after menu closes
  mnuCollapseTree.Enabled := dmodShared.NeedsCollapsing(Tree);
  if (Tree = tvShared) then
  begin
    Txt := 'Shared';
    FindOn := FFindShOn;
    mnuNodeDelete.Enabled := ((sbShDelete.Visible) and (sbShDelete.Enabled));
  end
  else
  begin
    Txt := 'Personal';
    FindOn := FFindPerOn;
    mnuNodeDelete.Enabled := ((sbPerDelete.Visible) and (sbPerDelete.Enabled));
  end;
  mnuFindTemplates.Checked := FindOn;
  mnuCollapseTree.Caption := 'Collapse ' + Txt + ' &Tree';
  mnuFindTemplates.Caption := '&Find ' + Txt + ' Templates';

  if (assigned(Tree) and assigned(Tree.Selected) and assigned(Tree.Selected.Data)) then
  begin
    mnuNodeCopy.Enabled := (TTemplate(Tree.Selected.Data).RealType in [ttDoc, ttGroup, ttClass]);
    mnuNodeSort.Enabled := (TTemplate(Tree.Selected.Data).RealType in AllTemplateFolderTypes) and
      (Tree.Selected.HasChildren) and
      (Tree.Selected.GetFirstChild.GetNextSibling <> nil);
  end
  else
  begin
    mnuNodeCopy.Enabled := FALSE;
    mnuNodeSort.Enabled := FALSE;
  end;
  FPasteNode := Tree.Selected;
  mnuNodePaste.Enabled := PasteOK;
  mnuNodeNew.Enabled := btnNew.Enabled;
  mnuNodeAutoGen.Enabled := btnNew.Enabled;
end;

procedure TfrmTemplateEditor.mnuCollapseTreeClick(Sender: TObject);
begin
  if (GetTree = tvShared) then
  begin
    tvShared.Selected := tvShared.Items.GetFirstNode;
    tvShared.FullCollapse;
  end
  else
  begin
    tvPersonal.Selected := tvShared.Items.GetFirstNode;
    tvPersonal.FullCollapse;
  end;
end;

procedure TfrmTemplateEditor.mnuFindTemplatesClick(Sender: TObject);
var
  Tree: TTreeView;

begin
  Tree := GetTree;
  if (Tree = tvShared) then
  begin
    FFindShOn := not FFindShOn;
    pnlShSearch.Visible := FFindShOn;
    if (FFindShOn) then
    begin
      edtShSearch.SetFocus;
      btnShFind.Enabled := (edtShSearch.Text <> '');
    end;
  end
  else
  begin
    FFindPerOn := not FFindPerOn;
    pnlPerSearch.Visible := FFindPerOn;
    if (FFindPerOn) then
    begin
      edtPerSearch.SetFocus;
      btnPerFind.Enabled := (edtPerSearch.Text <> '');
    end;
  end;
  SetFindNext(Tree, FALSE);
end;

procedure TfrmTemplateEditor.ShowTemplateType(Template: TTemplate);
begin
  if (Template.PersonalOwner > 0) then
    gbProperties.Caption := 'Personal'
  else
    gbProperties.Caption := 'Shared';
  gbProperties.Caption := gbProperties.Caption + PropText;
end;

function TfrmTemplateEditor.GetTree: TTreeView;
begin
  if (FFromMainMenu) then
    Result := FMainMenuTree
  else
  begin
    if (TTemplateTreeType(PopupComponent(popTemplates, popTemplates).Tag) = ttShared) then
      Result := tvShared
    else
      Result := tvPersonal;
  end;
end;

procedure TfrmTemplateEditor.btnFindClick(Sender: TObject);
var
  Found: TTreeNode;
  edtSearch: TEdit;
  IsNext: boolean;
  FindNext: boolean;
  FindWholeWords: boolean;
  FindCase: boolean;
  Tree: TTreeView;
  LastFoundNode, TmpNode: TTreeNode;
//  S1,S2: string;

begin
  if (TTemplateTreeType(TButton(Sender).Tag) = ttShared) then
  begin
    Tree := tvShared;
    edtSearch := edtShSearch;
    FindNext := FFindShNext;
    FindWholeWords := cbShWholeWords.Checked;
    FindCase := cbShMatchCase.Checked;
    LastFoundNode := FLastFoundShNode;
  end
  else
  begin
    Tree := tvPersonal;
    edtSearch := edtPerSearch;
    FindNext := FFindPerNext;
    FindWholeWords := cbPerWholeWords.Checked;
    FindCase := cbPerMatchCase.Checked;
    LastFoundNode := FLastFoundPerNode;
  end;
  if (edtSearch.text <> '') then
  begin
    IsNext := ((FindNext) and assigned(LastFoundNode));
    if IsNext then

      TmpNode := LastFoundNode
    else
      TmpNode := Tree.Items.GetFirstNode;
    FInternalHiddenExpand := TRUE;
    try
      Found := FindTemplate(edtSearch.Text, Tree, Self, TmpNode,
        IsNext, not FindCase, FindWholeWords);
    finally
      FInternalHiddenExpand := FALSE;
    end;
    if Assigned(Found) then
    begin
      Tree.Selected := Found;
      if (Tree = tvShared) then
        FLastFoundShNode := Found
      else
        FLastFoundPerNode := Found;
      SetFindNext(Tree, TRUE);
    end;
  end;
  edtSearch.SetFocus;
end;

procedure TfrmTemplateEditor.edtSearchChange(Sender: TObject);
begin
  if (TTemplateTreeType(TEdit(Sender).Tag) = ttShared) then
  begin
    btnShFind.Enabled := (edtShSearch.Text <> '');
    SetFindNext(tvShared, FALSE);
  end
  else
  begin
    btnPerFind.Enabled := (edtPerSearch.Text <> '');
    SetFindNext(tvPersonal, FALSE);
  end;
end;

procedure TfrmTemplateEditor.SetFindNext(const Tree: TTreeView; const Value: boolean);
begin
  if (Tree = tvShared) then
  begin
    if (FFindShNext <> Value) then
    begin
      FFindShNext := Value;
      if (FFindShNext) then btnShFind.Caption := 'Find Next'
      else btnShFind.Caption := 'Find';
    end;
  end
  else
  begin
    if (FFindPerNext <> Value) then
    begin
      FFindPerNext := Value;
      if (FFindPerNext) then btnPerFind.Caption := 'Find Next'
      else btnPerFind.Caption := 'Find';
    end;
  end;
end;

procedure TfrmTemplateEditor.edtShSearchEnter(Sender: TObject);
begin
  btnShFind.Default := TRUE;
end;

procedure TfrmTemplateEditor.edtShSearchExit(Sender: TObject);
begin
  btnShFind.Default := FALSE;
end;

procedure TfrmTemplateEditor.edtPerSearchEnter(Sender: TObject);
begin
  btnPerFind.Default := TRUE;
end;

procedure TfrmTemplateEditor.edtPerSearchExit(Sender: TObject);
begin
  btnPerFind.Default := FALSE;
end;

procedure TfrmTemplateEditor.btnOKClick(Sender: TObject);
begin
  if (ScanNames) then
  begin
    if (SaveAllTemplates) then
    begin
      FOK2Close := TRUE;
      ModalResult := mrOK;
    end
    else
      BtnApply.Enabled := BackupDiffers;
  end;
end;

procedure TfrmTemplateEditor.FormShow(Sender: TObject);
begin
  if (FFirstShow) then
  begin
    FUpdating := FALSE;
    FFirstShow := FALSE;
    if (FFocusName) then
    begin
      edtName.SetFocus;
      edtName.SelectAll;
    end;
    pnlBoilerplateResize(Self);
    AdjustControls4FontChange;
    MoveCopyButtons;
  end;
end;

procedure TfrmTemplateEditor.mnuBPInsertObjectClick(Sender: TObject);
var
  i: integer;
  DoIt: boolean;

begin
  if (not assigned(frmTemplateObjects)) then
  begin
    dmodShared.LoadTIUObjects;
    frmTemplateObjects := TfrmTemplateObjects.Create(Self);
    DoIt := TRUE;
    if (UserTemplateAccessLevel <> taEditor) then
    begin
      UpdatePersonalObjects;
      if uPersonalObjects.Count > 0 then // -------- CQ #8665 - RV ------------
      begin
        DoIt := FALSE;
        for i := 0 to dmodShared.TIUObjects.Count - 1 do
          if uPersonalObjects.IndexOf(Piece(dmodShared.TIUObjects[i], U, 2)) >= 0 then // -------- CQ #8665 - RV ------------
            frmTemplateObjects.cboObjects.Items.Add(dmodShared.TIUObjects[i]);
      end;
    end;
    if DoIt then
      FastAssign(dmodShared.TIUObjects, frmTemplateObjects.cboObjects.Items);
    frmTemplateObjects.Font := Font;
    frmTemplateObjects.re := reBoil;
    frmTemplateObjects.AutoLongLines := AutoLongLines;
  end;
  frmTemplateObjects.Show;
end;

procedure TfrmTemplateEditor.mnuBPErrorCheckClick(Sender: TObject);
begin
  FBPOK := FALSE;
  if (reBoil.Lines.Count > 0) then
  begin
    if (dmodShared.TemplateOK(FCurTree.Selected.Data, 'OK')) then
    begin
      TestBoilerplate(reBoil.Lines);
      if (RPCBrokerV.Results.Count > 0) then
        InfoBox('Boilerplate Contains Errors:' + CRLF + CRLF +
          RPCBrokerV.Results.Text, 'Error', MB_OK or MB_ICONERROR)
      else
      begin
        FBPOK := TRUE;
        if (assigned(Sender)) then
          InfoBox('No Errors Found in Boilerplate.', 'Information', MB_OK or MB_ICONINFORMATION);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.popBoilerplatePopup(Sender: TObject);
var
  tryOK, ok: boolean;

begin
  ok := not reBoil.ReadOnly;
  mnuBPInsertObject.Enabled := ok;
  mnuBPInsertField.Enabled := ok;

  mnuBPPaste.Enabled := (ok and Clipboard.HasFormat(CF_TEXT));
  if (ok) then
    ok := (reBoil.Lines.Count > 0);
  tryOK := (reBoil.Lines.Count > 0) or ((pnlGroupBP.Visible) and (reGroupBP.Lines.Count > 0));
  mnuBPErrorCheck.Enabled := tryOK;
  mnuBPTry.Enabled := tryOK;
  mnuBPSpellCheck.Enabled := ok and SpellCheckAvailable;
  mnuBPCheckGrammar.Enabled := ok and SpellCheckAvailable;

  mnuBPCopy.Enabled := (reBoil.SelLength > 0);
  mnuBPCut.Enabled := (ok and (reBoil.SelLength > 0));
  mnuBPSelectAll.Enabled := (reBoil.Lines.Count > 0);
  mnuBPUndo.Enabled := (reBoil.Perform(EM_CANUNDO, 0, 0) <> 0);
end;

function TfrmTemplateEditor.ScanNames: boolean;
var
  Errors: TList;
  msg: string;
  i: integer;
  Node: TTreeNode;

  procedure ScanTree(Tree: TTreeView);
  begin
    Node := Tree.Items.GetFirstNode;
    while (assigned(Node)) do
    begin
      if (Node.Text <> EmptyNodeText) and (assigned(Node.Data)) then
      begin
        if (BadTemplateName(Node.Text)) then
          Errors.Add(Node);
      end;
      Node := Node.GetNext;
    end;
  end;

begin
  Errors := TList.Create;
  try
    ScanTree(tvShared);
    ScanTree(tvPersonal);
    if (Errors.Count > 0) then
    begin
      if (Errors.Count > 1) then
        msg := IntToStr(Errors.Count) + ' Templates have invalid names'
      else
        msg := 'Template has an invalid name';
      msg := msg + ': ';
      for i := 0 to Errors.Count - 1 do
      begin
        if (i > 0) then msg := msg + ', ';
        Node := TTreeNode(Errors[i]);
        msg := msg + Node.Text;
        Node.MakeVisible;
      end;
      msg := msg + '.' + BadNameText;
      InfoBox(msg, 'Error', MB_OK or MB_ICONERROR);
      TTreeView(Node.TreeView).Selected := TTreeNode(Errors[0]);
    end;
  finally
    Result := (Errors.Count = 0);
    Errors.Free;
  end;
end;

procedure TfrmTemplateEditor.btnCancelClick(Sender: TObject);
begin
  FOK2Close := TRUE;
end;

procedure TfrmTemplateEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;

procedure TfrmTemplateEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  ans: word;

begin
  if (not FOK2Close) and (BackupDiffers) then
  begin
    ans := InfoBox('Save Changes?', 'Confirmation', MB_YESNOCANCEL or MB_ICONQUESTION);
    if (ans = IDCANCEL) then
      CanClose := FALSE
    else
      if (ans = IDYES) then
      begin
        CanClose := FALSE;
        if (ScanNames) then
        begin
          if (SaveAllTemplates) then
            CanClose := TRUE
          else
            BtnApply.Enabled := BackupDiffers;
        end;
      end;
  end;
end;

procedure TfrmTemplateEditor.mnuBPSpellCheckClick(Sender: TObject);
begin
  SpellCheckForControl(reBoil);
end;

procedure TfrmTemplateEditor.splBoilMoved(Sender: TObject);
begin
  if reboil.Visible and pnlGroupBP.Visible then
    tmplEditorSplitterBoil := reBoil.Height;
  if pnlNotes.Visible then
    tmplEditorSplitterNotes := pnlNotes.Height;
  pnlBoilerplateResize(Self);
  if not PnlNotes.visible and (PnlNotes.Top <= pnlGroupBP.Top - pnlGroupBP.Constraints.MinHeight) then
    tmplEditorSplitterNotes := (pnlGroupBP.Height - pnlGroupBP.Constraints.MinHeight) - splNotes.Height - 10;
  if not pnlGroupBP.visible and (pnlGroupBP.Top >= pnlNotes.Top + pnlGroupBP.Constraints.MinHeight) then
    tmplEditorSplitterBoil := reBoil.Height - pnlGroupBP.Constraints.MinHeight - 10;
end;

procedure TfrmTemplateEditor.edtGapKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not CharInSet(Key, ['0', '1', '2', '3'])) then Key := #0;
end;

procedure TfrmTemplateEditor.edtNameExit(Sender: TObject);
var
  Warn: boolean;

begin
  Warn := (ActiveControl <> btnCancel) and (BadTemplateName(edtName.Text));
  if (Warn and ((ActiveControl = sbShDelete) or (ActiveControl = sbPerDelete))) then
  begin
    if ((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
      Warn := not AutoDel(TTemplate(FCurTree.Selected.Data));
  end;
  if (Warn) then
  begin
    InfoBox('Template has an invalid name: ' + edtName.Text + '.' + BadNameText, 'Error', MB_OK or MB_ICONERROR);
    edtName.SetFocus;
  end;
end;

procedure TfrmTemplateEditor.tmrAutoScrollTimer(Sender: TObject);
const
  EdgeScroll = 16;

var
  TopNode: TTreeNode;
  Redraw: boolean;
  TmpPt: TPoint;
  ht: THitTests;
  HPos, RMax: integer;

begin
  if (assigned(FDropNode)) then
  begin
    TopNode := FDropNode.TreeView.TopItem;
    Redraw := FALSE;
    TmpPt := FDropNode.TreeView.ScreenToClient(Mouse.CursorPos);
    if (TopNode = FDropNode) and (TopNode <> TTreeView(FDropNode.TreeView).Items.GetFirstNode) then
    begin
      FDropNode.TreeView.TopItem := TopNode.GetPrevVisible;
      Redraw := TRUE;
    end
    else
    begin
      RMax := FDropNode.TreeView.ClientHeight - EdgeScroll;
      if ((TmpPt.Y > RMax) and (FDropNode.GetNextVisible <> nil)) then
      begin
        TORTreeView(FDropNode.TreeView).VertScrollPos :=
          TORTreeView(FDropNode.TreeView).VertScrollPos + 1;
        Redraw := TRUE;
      end;
    end;
    if (FLastDropNode <> FDropNode) then
    begin
      if ((assigned(FDropNode)) and (FDropNode.GetNext = nil)) then
        Redraw := TRUE
      else
        if ((assigned(FLastDropNode)) and (FLastDropNode.GetNext = nil)) then
          Redraw := TRUE;
      FLastDropNode := FDropNode;
      FDragOverCount := 0;
    end
    else
    begin
      if (FDropNode.HasChildren) and (not FDropNode.Expanded) then
      begin
        ht := FDropNode.TreeView.GetHitTestInfoAt(TmpPt.X, TmpPt.Y);
        if (htOnButton in ht) then
        begin
          inc(FDragOverCount);
          if (FDragOverCount > 4) then
          begin
            TopNode := FDropNode.TreeView.TopItem;
            FDropNode.Expand(FALSE);
            FDropNode.TreeView.TopItem := TopNode;
            FDragOverCount := 0;
            Redraw := TRUE;
          end;
        end
        else
          FDragOverCount := 0;
      end;
      if (not Redraw) then
      begin
        HPos := TORTreeView(FDropNode.TreeView).HorzScrollPos;
        if (HPos > 0) and (TmpPt.X < EdgeScroll) then
        begin
          TORTreeView(FDropNode.TreeView).HorzScrollPos :=
            TORTreeView(FDropNode.TreeView).HorzScrollPos - EdgeScroll;
          Redraw := TRUE;
        end
        else
        begin
          RMax := FDropNode.TreeView.ClientWidth - EdgeScroll;
          if (TmpPt.X > RMax) then
          begin
            TORTreeView(FDropNode.TreeView).HorzScrollPos :=
              TORTreeView(FDropNode.TreeView).HorzScrollPos + EdgeScroll;
            Redraw := TRUE;
          end;
        end;
      end;
    end;
    if (Redraw) then
    begin
      TmpPt := Mouse.CursorPos; // Wiggling the mouse causes needed windows messages to fire
      inc(TmpPt.X);
      Mouse.CursorPos := TmpPt;
      dec(TmpPt.X);
      Mouse.CursorPos := TmpPt;
      FDropNode.TreeView.Invalidate;
    end;
  end;
end;

procedure TfrmTemplateEditor.tvTreeStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FDropNode := nil;
  FLastDropNode := nil;
  FDragOverCount := 0;
  tmrAutoScroll.Enabled := TRUE;
end;

procedure TfrmTemplateEditor.tvTreeEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  tmrAutoScroll.Enabled := FALSE;
end;

procedure TfrmTemplateEditor.mnuGroupBPCopyClick(Sender: TObject);
begin
  reGroupBP.CopyToClipboard;
end;

procedure TfrmTemplateEditor.popGroupPopup(Sender: TObject);
begin
  mnuGroupBPCopy.Enabled := (pnlGroupBP.Visible and (reGroupBP.SelLength > 0));
  mnuGroupBPSelectAll.Enabled := (pnlGroupBP.Visible and (reGroupBP.Lines.Count > 0));
end;

procedure TfrmTemplateEditor.mnuBPCutClick(Sender: TObject);
begin
  reBoil.CutToClipboard;
end;

procedure TfrmTemplateEditor.mnuBPCopyClick(Sender: TObject);
begin
  reBoil.CopyToClipboard;
end;

procedure TfrmTemplateEditor.mnuBPPasteClick(Sender: TObject);
begin
  reBoil.SelText := Clipboard.AsText;
end;

procedure TfrmTemplateEditor.mnuGroupBPSelectAllClick(Sender: TObject);
begin
  reGroupBP.SelectAll;
end;

procedure TfrmTemplateEditor.mnuBPSelectAllClick(Sender: TObject);
begin
  reBoil.SelectAll;
end;

procedure TfrmTemplateEditor.mnuNodeDeleteClick(Sender: TObject);
begin
  if (FCurTree = tvShared) and (sbShDelete.Visible) and (sbShDelete.Enabled) then
    sbDeleteClick(sbShDelete)
  else
    if (FCurTree = tvPersonal) and (sbPerDelete.Visible) and (sbPerDelete.Enabled) then
      sbDeleteClick(sbPerDelete);
end;

procedure TfrmTemplateEditor.mnuNodeCopyClick(Sender: TObject);
begin
  if (assigned(FCurTree)) then
    FCopyNode := FCurTree.Selected
  else
    FCopyNode := nil;
end;

procedure TfrmTemplateEditor.mnuNodePasteClick(Sender: TObject);
begin
  if (PasteOK) then
  begin
    FDragNode := FCopyNode;
    FDropNode := FPasteNode;
    FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
    FCopying := TRUE;
    try
      tvTreeDragDrop(tvShared, tvPersonal, 0, 0);
    finally
      FCopying := FALSE;
    end;
  end;
  FCopyNode := nil;
end;

function TfrmTemplateEditor.PasteOK: boolean;
var
  OldCopying: boolean;
  Node: TTreeNode;

begin
  Result := assigned(FCopyNode) and assigned(FPasteNode);
  if (Result) then
    Result := (FTreeControl[TTemplateTreeType(FPasteNode.TreeView.Tag), tcDel].Visible);
  if (Result) then
  begin
    OldCopying := FCopying;
    FCopying := TRUE;
    try
      Node := FPasteNode;
      if (TTemplate(Node.Data).RealType = ttDoc) then
        Node := Node.Parent;
      Result := AllowMove(Node, FCopyNode);
    finally
      FCopying := OldCopying;
    end;
  end;
end;

procedure TfrmTemplateEditor.mnuBPUndoClick(Sender: TObject);
begin
  reBoil.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmTemplateEditor.tvTreeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_DELETE) then
  begin
    if (Sender = tvShared) then
    begin
      if (sbShDelete.Visible and sbShDelete.Enabled) then
        sbDeleteClick(sbShDelete);
    end
    else
    begin
      if (sbPerDelete.Visible and sbPerDelete.Enabled) then
        sbDeleteClick(sbPerDelete);
    end;
  end;
   //Code Added to provide CTRL Key access for 508 compliance  GRE 3/03
  if (ssCtrl in Shift) and (Key = VK_A) then
    reBoil.SelectAll
  else
    if (ssCtrl in Shift) and (Key = VK_C) then
      reBoil.CopyToClipboard
    else
      if (ssCtrl in Shift) and (Key = VK_E) then
        mnuBPErrorCheckClick(Self)
      else
        if (ssCtrl in Shift) and (Key = VK_F) then
          mnuBPInsertFieldClick(Self)
        else
          if (ssCtrl in Shift) and (Key = VK_G) then
            GrammarCheckForControl(reBoil)
          else
            if (ssCtrl in Shift) and (Key = VK_I) then
              mnuBPInsertObjectClick(Self)
            else
              if (ssCtrl in Shift) and (Key = VK_S) then
                SpellCheckForControl(reBoil)
              else
                if (ssCtrl in Shift) and (Key = VK_T) then
                  mnuBPTryClick(Self)
                else
                  if (ssCtrl in Shift) and (Key = VK_V) then
                    reBoil.SelText := Clipboard.AsText
                  else
                    if (ssCtrl in Shift) and (Key = VK_X) then
                      reBoil.CutToClipboard
                    else
                      if (ssCtrl in Shift) and (Key = VK_Z) then
                        reBoil.Perform(EM_UNDO, 0, 0);
  //End of ---- Code Added to provide CTRL Key access for 508 compliance  GRE 3/03
end;

procedure TfrmTemplateEditor.mnuEditClick(Sender: TObject);
var
  tryOK, ok: boolean;

begin
  if reboil.Visible then
  begin
    ok := (not reBoil.ReadOnly);
    mnuInsertObject.Enabled := ok;
    mnuInsertField.Enabled := ok;
    mnuPaste.Enabled := (ok and Clipboard.HasFormat(CF_TEXT));
    if (ok) then
      ok := (reBoil.Lines.Count > 0);
    tryOK := (reBoil.Lines.Count > 0) or ((pnlGroupBP.Visible) and (reGroupBP.Lines.Count > 0));
    mnuErrorCheck.Enabled := tryOK;
    mnuTry.Enabled := tryOK;
    mnuSpellCheck.Enabled := ok and SpellCheckAvailable;
    mnuCheckGrammar.Enabled := ok and SpellCheckAvailable;

    mnuCopy.Enabled := (reBoil.SelLength > 0);
    mnuCut.Enabled := (ok and (reBoil.SelLength > 0));
    mnuSelectAll.Enabled := (reBoil.Lines.Count > 0);
    mnuUndo.Enabled := (reBoil.Perform(EM_CANUNDO, 0, 0) <> 0);
    mnuGroupBoilerplate.Enabled := pnlGroupBP.Visible;
  end
  else
  begin
    mnuInsertObject.Enabled := FALSE;
    mnuInsertField.Enabled := FALSE;
    mnuPaste.Enabled := FALSE;
    mnuErrorCheck.Enabled := FALSE;
    mnuTry.Enabled := FALSE;
    mnuSpellCheck.Enabled := FALSE;
    mnuCheckGrammar.Enabled := FALSE;
    mnuCopy.Enabled := FALSE;
    mnuCut.Enabled := FALSE;
    mnuSelectAll.Enabled := FALSE;
    mnuUndo.Enabled := FALSE;
    mnuGroupBoilerplate.Enabled := FALSE;
  end;
end;

procedure TfrmTemplateEditor.mnuGroupBoilerplateClick(Sender: TObject);
begin
  mnuGroupCopy.Enabled := (pnlGroupBP.Visible and (reGroupBP.SelLength > 0));
  mnuGroupSelectAll.Enabled := (pnlGroupBP.Visible and (reGroupBP.Lines.Count > 0));
end;

procedure TfrmTemplateEditor.cbShFindOptionClick(Sender: TObject);
begin
  SetFindNext(tvShared, FALSE);
  if (pnlShSearch.Visible) then edtShSearch.SetFocus;
end;

procedure TfrmTemplateEditor.cbPerFindOptionClick(Sender: TObject);
begin
  SetFindNext(tvPersonal, FALSE);
  if (pnlPerSearch.Visible) then edtPerSearch.SetFocus;
end;

procedure TfrmTemplateEditor.mnuTemplateClick(Sender: TObject);
var
  Tree: TTreeView;

begin
  FFromMainMenu := TRUE;
  Tree := FCurTree;
  if (assigned(Tree) and assigned(Tree.Selected)) then
  begin
    if (Tree = tvShared) then
      mnuTDelete.Enabled := ((sbShDelete.Visible) and (sbShDelete.Enabled))
    else
      mnuTDelete.Enabled := ((sbPerDelete.Visible) and (sbPerDelete.Enabled));
    if (assigned(Tree) and assigned(Tree.Selected) and assigned(Tree.Selected.Data)) then
    begin
      mnuTCopy.Enabled := (TTemplate(Tree.Selected.Data).RealType in [ttDoc, ttGroup, ttClass]);
      mnuSort.Enabled := (TTemplate(Tree.Selected.Data).RealType in AllTemplateFolderTypes) and
        (Tree.Selected.HasChildren) and
        (Tree.Selected.GetFirstChild.GetNextSibling <> nil);
    end
    else
    begin
      mnuTCopy.Enabled := FALSE;
      mnuSort.Enabled := FALSE;
    end;
    FPasteNode := Tree.Selected;
    mnuTPaste.Enabled := PasteOK;
  end
  else
  begin
    mnuTCopy.Enabled := FALSE;
    mnuTPaste.Enabled := FALSE;
    mnuTDelete.Enabled := FALSE;
    mnuSort.Enabled := FALSE;
  end;
  mnuNewTemplate.Enabled := btnNew.Enabled;
  mnuAutoGen.Enabled := btnNew.Enabled;
  mnuFindShared.Checked := FFindShOn;
  mnuFindPersonal.Checked := FFindPerOn;
  mnuShCollapse.Enabled := dmodShared.NeedsCollapsing(tvShared);
  mnuPerCollapse.Enabled := dmodShared.NeedsCollapsing(tvPersonal);
end;

procedure TfrmTemplateEditor.mnuFindSharedClick(Sender: TObject);
begin
  FMainMenuTree := tvShared;
  mnuFindTemplatesClick(tvShared);
end;

procedure TfrmTemplateEditor.mnuFindPersonalClick(Sender: TObject);
begin
  FMainMenuTree := tvPersonal;
  mnuFindTemplatesClick(tvPersonal);
end;

procedure TfrmTemplateEditor.mnuShCollapseClick(Sender: TObject);
begin
  FMainMenuTree := tvShared;
  mnuCollapseTreeClick(tvShared);
end;

procedure TfrmTemplateEditor.mnuPerCollapseClick(Sender: TObject);
begin
  FMainMenuTree := tvPersonal;
  mnuCollapseTreeClick(tvPersonal);
end;

procedure TfrmTemplateEditor.pnlShSearchResize(Sender: TObject);
begin
  if ((cbShMatchCase.Width + cbShWholeWords.Width) > pnlShSearch.Width) then
    cbShWholeWords.Left := cbShMatchCase.Width
  else
    cbShWholeWords.Left := pnlShSearch.Width - cbShWholeWords.Width;
end;

procedure TfrmTemplateEditor.pnlPerSearchResize(Sender: TObject);
begin
  if ((cbPerMatchCase.Width + cbPerWholeWords.Width) > pnlPerSearch.Width) then
    cbPerWholeWords.Left := cbPerMatchCase.Width
  else
    cbPerWholeWords.Left := pnlPerSearch.Width - cbPerWholeWords.Width;
end;

procedure TfrmTemplateEditor.pnlPropertiesResize(Sender: TObject);
begin
  btnNew.Width := pnlProperties.Width;
end;

procedure TfrmTemplateEditor.mbMainResize(Sender: TObject);
begin
  pnlMenu.Width := mbMain.Width + 4;
  mbMain.Width := pnlMenu.Width - 3;
end;

procedure TfrmTemplateEditor.mnuBPCheckGrammarClick(Sender: TObject);
begin
  GrammarCheckForControl(reBoil);
end;

procedure TfrmTemplateEditor.mnuSortClick(Sender: TObject);
var
  Tree: TTreeView;

begin
  Tree := FCurTree;
  if (assigned(Tree) and assigned(Tree.Selected) and Tree.Selected.HasChildren) then
  begin
    TTemplate(Tree.Selected.Data).SortChildren;
    Resync([TTemplate(Tree.Selected.Data)]);
    btnApply.Enabled := TRUE;
  end;
end;

procedure TfrmTemplateEditor.pnlBoilerplateCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if (NewHeight < 40) then Resize := FALSE;
end;

function TfrmTemplateEditor.AutoDel(Template: TTemplate): boolean;
begin
  if (assigned(Template)) then
    Result := (((Template.ID = '0') or (Template.ID = '')) and
      (Template.PrintName = NewTemplateName) and
      (Template.Boilerplate = ''))
  else
    Result := FALSE;
end;

procedure TfrmTemplateEditor.mnuBPTryClick(Sender: TObject);
var
  R: TRect;
  Move: boolean;
  tmpl: TTemplate;
  txt: string;

begin
  mnuBPErrorCheckClick(nil);
  if (FBPOK) or (reBoil.Lines.Count = 0) then
  begin
    Move := assigned(frmTemplateView);
    if (Move) then
    begin
      R := frmTemplateView.BoundsRect;
      frmTemplateView.Free;
      frmTemplateView := nil;
    end;
    tmpl := TTemplate(FCurTree.Selected.Data);
    tmpl.TemplatePreviewMode := TRUE; // Prevents "Are you sure?" dialog when canceling
    txt := tmpl.Text;
    if (not tmpl.DialogAborted) then
      ShowTemplateData(Self, tmpl.PrintName, txt);
    if (Move) then
      frmTemplateView.BoundsRect := R;
    tmpl.TemplatePreviewMode := FALSE;
  end;
end;

procedure TfrmTemplateEditor.mnuAutoGenClick(Sender: TObject);
var
  AName, AText: string;

begin
  dmodShared.LoadTIUObjects;
  UpdatePersonalObjects;
  GetAutoGenText(AName, AText, uPersonalObjects); // -------- CQ #8665 - RV ------------
  if (AName <> '') and (AText <> '') then
  begin
    btnNewClick(Self);
    TTemplate(FBtnNewNode.Data).PrintName := AName;
    TTemplate(FBtnNewNode.Data).Boilerplate := AText;
    ShowInfo(FBtnNewNode);
    edtNameOldChange(Self);
  end;
end;

procedure TfrmTemplateEditor.reNotesChange(Sender: TObject);
var
  Template: TTemplate;
  DoRefresh: boolean;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      DoRefresh := Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        Template.Description := reNotes.Lines.Text;
        UpdateApply(Template);
        if (DoRefresh) then
        begin
          tvShared.Invalidate;
          tvPersonal.Invalidate;
        end;
      end;
    end;
    btnApply.Enabled := TRUE;
//      reNotes.Lines.Text := Template.Description;
  end;
end;

procedure TfrmTemplateEditor.mnuNotesUndoClick(Sender: TObject);
begin
  reNotes.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmTemplateEditor.mnuNotesCutClick(Sender: TObject);
begin
  reNotes.CutToClipboard;
end;

procedure TfrmTemplateEditor.mnuNotesCopyClick(Sender: TObject);
begin
  reNotes.CopyToClipboard;
end;

procedure TfrmTemplateEditor.mnuNotesPasteClick(Sender: TObject);
begin
  reNotes.SelText := Clipboard.AsText;
end;

procedure TfrmTemplateEditor.mnuNotesSelectAllClick(Sender: TObject);
begin
  reNotes.SelectAll;
end;

procedure TfrmTemplateEditor.mnuNotesGrammarClick(Sender: TObject);
begin
  GrammarCheckForControl(reNotes);
end;

procedure TfrmTemplateEditor.mnuNotesSpellingClick(Sender: TObject);
begin
  SpellCheckForControl(reNotes);
end;

procedure TfrmTemplateEditor.popNotesPopup(Sender: TObject);
var
  ok: boolean;

begin
  ok := not reNotes.ReadOnly;
  mnuNotesPaste.Enabled := (ok and Clipboard.HasFormat(CF_TEXT));
  if (ok) then
    ok := (reNotes.Lines.Count > 0);
  mnuNotesSpelling.Enabled := ok and SpellCheckAvailable;
  mnuNotesGrammar.Enabled := ok and SpellCheckAvailable;
  mnuNotesCopy.Enabled := (reNotes.SelLength > 0);
  mnuNotesCut.Enabled := (ok and (reNotes.SelLength > 0));
  mnuNotesSelectAll.Enabled := (reNotes.Lines.Count > 0);
  mnuNotesUndo.Enabled := (reNotes.Perform(EM_CANUNDO, 0, 0) <> 0);
end;

procedure TfrmTemplateEditor.cbNotesClick(Sender: TObject);
var
  ScreenPoint: TPoint;
  NewHeight: Integer;
begin
  pnlNotes.Visible := cbNotes.Checked;
  splNotes.Visible := cbNotes.Checked;
  if cbNotes.Checked then
  begin
    If (pnlGroupBP.Visible) and (tmplEditorSplitterNotes >= pnlGroupBP.Height - pnlGroupBP.Constraints.MinHeight) then
     tmplEditorSplitterNotes := pnlNotes.Constraints.MinHeight;

    pnlNotes.Height := tmplEditorSplitterNotes;
    pnlNotes.Top := pnlBottom.Top - pnlNotes.Height;
    splNotes.Top := pnlNotes.Top - 3;
    if pnlGroupBP.Height <= pnlGroupBP.Constraints.MinHeight then begin
      //Clear the points
      ScreenPoint.Y := 0;
      ScreenPoint.X := 0;
      if pnlNotes.ClientToScreen(ScreenPoint).Y + 30 > pnlBottom.Top then begin
        if pnlNotes.ClientToScreen(ScreenPoint).Y > pnlBottom.Top then
          NewHeight := pnlNotes.Height + (pnlNotes.ClientToScreen(ScreenPoint).Y - pnlBottom.Top)
        else
          NewHeight := pnlNotes.Height - (pnlNotes.ClientToScreen(ScreenPoint).Y - pnlBottom.Top);
        Reboil.Height := Reboil.Height - (NewHeight + 10);
        PnlNotes.Constraints.MinHeight := 30;
        pnlNotes.Height := PnlNotes.Constraints.MinHeight;
        if reboil.Height = reboil.Constraints.MinHeight then
          PnlTop.height := PnlTop.height - 100;
      end;
    end;
  end else begin
    pnlNotes.Constraints.MinHeight := 1;
    pnlNotes.Height := 1;
  end;
  pnlBoilerplateResize(Self);
end;

procedure TfrmTemplateEditor.cbDisplayOnlyClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPDisplayOnlyFld);
end;

procedure TfrmTemplateEditor.cbFirstLineClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPFirstLineFld);
end;

procedure TfrmTemplateEditor.cbOneItemOnlyClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPOneItemOnlyFld);
end;

procedure TfrmTemplateEditor.cbHideDlgItemsClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPHideDlgItemsFld);
end;

procedure TfrmTemplateEditor.cbHideItemsClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPHideItemsFld);
end;

procedure TfrmTemplateEditor.cbClick(Sender: TCheckBox; Index: integer);
var
  Template: TTemplate;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        case Index of
          BPDisplayOnlyFld: Template.DisplayOnly := Sender.Checked;
          BPFirstLineFld: Template.FirstLine := Sender.Checked;
          BPOneItemOnlyFld: Template.OneItemOnly := Sender.Checked;
          BPHideDlgItemsFld: Template.HideDlgItems := Sender.Checked;
          BPHideItemsFld: Template.HideItems := Sender.Checked;
          BPIndentFld: Template.IndentItems := Sender.Checked;
          BPLockFld: Template.Lock := Sender.Checked;
        end;
        UpdateApply(Template);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.cbIndentClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPIndentFld);
end;

procedure TfrmTemplateEditor.mnuToolsClick(Sender: TObject);
begin
  mnuEditTemplateFields.Enabled := CanEditTemplateFields;
  mnuImportTemplate.Enabled := btnNew.Enabled;
  mnuExportTemplate.Enabled := (assigned(FCurTree) and assigned(FCurTree.Selected) and
    assigned(FCurTree.Selected.Data));
end;

procedure TfrmTemplateEditor.mnuEditTemplateFieldsClick(Sender: TObject);
begin
  if assigned(frmTemplateObjects) then
    frmTemplateObjects.Hide;
  if assigned(frmTemplateFields) then
    frmTemplateFields.Hide;
  if EditDialogFields and assigned(frmTemplateFields) then
    FreeAndNil(frmTemplateFields);
end;

procedure TfrmTemplateEditor.mnuBPInsertFieldClick(Sender: TObject);
begin
  if (not assigned(frmTemplateFields)) then
  begin
    frmTemplateFields := TfrmTemplateFields.Create(Self);
    frmTemplateFields.Font := Font;
    frmTemplateFields.re := reBoil;
    frmTemplateFields.AutoLongLines := AutoLongLines;
  end;
  frmTemplateFields.Show;
end;

procedure TfrmTemplateEditor.UpdateInsertsDialogs;
begin
  if assigned(frmTemplateObjects) then
    frmTemplateObjects.UpdateStatus;
  if assigned(frmTemplateFields) then
    frmTemplateFields.UpdateStatus;
end;

procedure TfrmTemplateEditor.mnuExportTemplateClick(Sender: TObject);
var
  Tmpl, Flds: TStringList;
  i: integer;
  XMLDoc: IXMLDOMDocument;
  err: boolean;

begin
  err := FALSE;
  if (assigned(FCurTree) and assigned(FCurTree.Selected) and assigned(FCurTree.Selected.Data)) then
  begin
    dlgExport.FileName := ValidFileName(TTemplate(FCurTree.Selected.Data).PrintName);
    if dlgExport.Execute then
    begin
      Tmpl := TStringList.Create;
      try
        Flds := TStringList.Create;
        try
          Tmpl.Add('<' + XMLHeader + '>');
          if TTemplate(FCurTree.Selected.Data).CanExportXML(Tmpl, Flds, 2) then
          begin
            if (Flds.Count > 0) then begin
              ExpandEmbeddedFields(Flds);
              FastAssign(ExportTemplateFields(Flds), Flds);
              for i := 0 to Flds.Count - 1 do
                Flds[i] := '  ' + Flds[i];
              FastAddStrings(Flds, Tmpl);
            end; {if}
            Tmpl.Add('</' + XMLHeader + '>');
            try
              XMLDoc := CoDOMDocument.Create;
              try
                XMLDoc.preserveWhiteSpace := TRUE;
                XMLDoc.LoadXML(Tmpl.Text);
                XMLDoc.Save(dlgExport.FileName);
              finally
                XMLDoc := nil;
              end;
            except
              InfoBox(Format(NoIE5, ['Export']), NoIE5Header, MB_OK);
              err := TRUE;
            end;
            if not err then
              InfoBox('Template ' + TTemplate(FCurTree.Selected.Data).PrintName +
                ' Exported.', 'Template Exported', MB_OK);
          end;
        finally
          Flds.Free;
        end;
      finally
        Tmpl.Free;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.mnuImportTemplateClick(Sender: TObject);
const
  Filter1 = 'Template Files|*.txml';
  WordFilter = '|Word Documents|*.doc;*.dot';
  Filter2 = '|XML Files|*.xml|All Files|*.*';

var
  XMLDoc: IXMLDOMDocument;
  RootElement: IXMLDOMElement;
  ImportedTemplate: TTemplate;
  AppData, Flds, ResultSet: TStringList;
  tmp, j, p3: string;
  err, ok, changes, xmlerr: boolean;
  i: integer;
  choice: word;

  procedure ClearFields;
  begin
    Flds.Text := '';
    ResultSet.Text := '';
  end;

begin
  tmp := Filter1;
  err := FALSE;
  if WordImportActive then
    tmp := tmp + WordFilter;
  tmp := tmp + Filter2;
  dlgImport.Filter := tmp;
  if btnNew.Enabled and dlgImport.Execute then
  begin
    tmp := ExtractFileExt(dlgImport.FileName);
    if (WordImportActive and ((CompareText(tmp, '.doc') = 0) or
      (CompareText(tmp, '.dot') = 0))) then
      AppData := TStringList.Create
    else
      AppData := nil;
    try
      try
        XMLDoc := CoDOMDocument.Create;
      except
        InfoBox(Format(NoIE5, ['Import']), NoIE5Header, MB_OK);
        exit;
      end;
      try
        if assigned(AppData) then
        begin
          try
            ok := GetXMLFromWord(dlgImport.FileName, AppData);
          except
            ok := FALSE;
            err := TRUE;
          end;
        end
        else
          ok := TRUE;
        if ok and assigned(XMLDoc) then
        begin
          XMLDoc.preserveWhiteSpace := TRUE;
          if assigned(AppData) then
            XMLDoc.LoadXML(AppData.Text)
          else
            XMLDoc.Load(dlgImport.FileName);
          RootElement := XMLDoc.DocumentElement;
          if not assigned(RootElement) then
            XMLImportError(0);
          try
            if (RootElement.tagName <> XMLHeader) then
              XMLImportError(0)
            else
            begin
              ImportedTemplate := nil;
              FXMLTemplateElement := FindXMLElement(RootElement, XMLTemplateTag);
              if assigned(FXMLTemplateElement) then
              begin
                FXMLFieldElement := FindXMLElement(RootElement, XMLTemplateFieldsTag);
                if (assigned(FXMLFieldElement)) then
                begin
                  Flds := TStringList.Create;
                  ResultSet := TStringList.Create;
                  try
                    Flds.Text := FXMLFieldElement.Get_XML;
                    choice := IDOK;
                    changes := FALSE;
                    Application.ProcessMessages;
                    if not BuildTemplateFields(Flds) then //Calls RPC to transfer all field XML
                      choice := IDCANCEL; //for processing
                    Flds.Text := '';
                    Application.ProcessMessages;
                    if choice = IDOK then
                      CheckTemplateFields(Flds);
                    if Flds.Count > 0 then
                    begin
                      for i := 1 to Flds.Count do
                      begin
                        j := piece(Flds[i - 1], U, 2);
                        if (j = '0') or (j = '2') then
                        begin
                          p3 := piece(Flds[i - 1], U, 3);
                          if p3 = 'XML FORMAT ERROR' then
                            choice := IDCANCEL;
                          changes := TRUE;
                          if j = '2' then begin
                            j := Flds[i - 1];
                            SetPiece(j, U, 2, '1');
                            Flds[i - 1] := j
                          end;
                        end;
                      end;
                    end
                    else
                      choice := IDCANCEL;
                    if choice <> IDOK then
                      InfoBox(iMessage2 + iMessage3, 'Error', MB_OK or MB_ICONERROR)
                    else
                      if (not CanEditTemplateFields) and
                        changes {(there is at least one new field)} then
                      begin
                        choice := InfoBox(iMessage, 'Warning', MB_OKCANCEL or MB_ICONWARNING);
                        Flds.Text := '';
                      end;
                    if choice <> IDCANCEL then
                    begin
                      FImportingFromXML := TRUE;
                      try
                        btnNewClick(Self);
                        ImportedTemplate := TTemplate(FBtnNewNode.Data);
                      finally
                        FImportingFromXML := FALSE;
                      end; {try}
                      Application.ProcessMessages;
                      if assigned(ImportedTemplate) and (Flds.Count > 0) then
                        if not ImportLoadedFields(ResultSet) then begin
                          InfoBox(iMessage2 + iMessage3, 'Error', MB_OK or MB_ICONERROR);
                          ClearFields;
                          choice := IDCANCEL;
                        end; //if
                      if Flds.Count = 0 then
                        choice := IDCANCEL;
                    end {if choice <> mrCancel}
                    else
                      ClearFields;

                    xmlerr := FALSE;
                    if (Flds.Count > 0) and
                      (ResultSet.Count > 0) and
                      (Flds.Count = ResultSet.Count) then
                      for i := 0 to Flds.Count - 1 do begin
                        if piece(ResultSet[i], U, 2) = '0' then begin
                          j := piece(Flds[i], U, 1) + U + '0' + U + piece(ResultSet[i], U, 3);
                          Flds[i] := j;
                        end
                      end
                    else
                      xmlerr := TRUE;

                    if xmlerr and (choice <> IDCANCEL) then begin
                      InfoBox(iMessage2, 'Warning', MB_OK or MB_ICONWARNING);
                      ClearFields;
                    end;

                    i := 0;
                    while (i < Flds.Count) do begin
                      if Piece(Flds[i], U, 2) <> '0' then
                        Flds.Delete(i)
                      else
                        inc(i);
                    end; //while
                    if (Flds.Count > 0) then
                    begin
                      if assigned(frmTemplateFields) then
                        FreeAndNil(frmTemplateFields);
                      ImportedTemplate.UpdateImportedFieldNames(Flds);
                      if not assigned(AppData) then
                      begin
                        for i := 0 to Flds.Count - 1 do
                          Flds[i] := '  Field "' + Piece(Flds[i], U, 1) + '" has been renamed to "' +
                            Piece(Flds[i], U, 3) + '"';
                        if Flds.Count = 1 then
                          tmp := 'A template field has'
                        else
                          tmp := IntToStr(Flds.Count) + ' template fields have';
                        Flds.Insert(0, tmp + ' been imported with the same name as');
                        Flds.Insert(1, 'existing template fields, but with different field definitions.');
                        Flds.Insert(2, 'These imported template fields have been renamed as follows:');
                        Flds.Insert(3, '');
                        InfoBox(Flds.Text, 'Information', MB_OK or MB_ICONINFORMATION);
                      end;
                    end;
                  finally
                    Flds.Free;
                    ResultSet.Free;
                  end;
                end
                else {There are no fields to consider...}
                begin
                  FImportingFromXML := TRUE;
                  try
                    btnNewClick(Self);
                    ImportedTemplate := TTemplate(FBtnNewNode.Data);
                  finally
                    FImportingFromXML := FALSE;
                  end; {try}
                end;
              end;
              if assigned(ImportedTemplate) then
                ShowInfo(FBtnNewNode);
            end;
          finally
            RootElement := nil;
          end;
        end;
      finally
        XMLDoc := nil;
      end;
    finally
      if assigned(AppData) then
      begin
        AppData.Free;
        if err then
          InfoBox('An error occured while Importing Word Document.  Make sure Word is closed and try again.', 'Import Error', MB_OK);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.cbxTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ImgIdx: integer;

begin
  cbxType.Canvas.FillRect(Rect);
  case IdxForced[FForceContainer, Index] of
    tiTemplate: ImgIdx := 4;
    tiFolder: ImgIdx := 3;
    tiGroup: ImgIdx := 5;
    tiDialog: ImgIdx := 23;
    tiRemDlg: ImgIdx := 27;
    tiCOMObj: ImgIdx := 28;
  else
    ImgIdx := ord(tiNone);
  end;
  if ImgIdx >= 0 then
    dmodShared.imgTemplates.Draw(cbxType.Canvas, Rect.Left + 1, Rect.Top + 1, ImgIdx);
  if Index >= 0 then
    cbxType.Canvas.TextOut(Rect.Left + 21, Rect.Top + 2, cbxType.Items[Index]);
end;

procedure TfrmTemplateEditor.cbxTypeChange(Sender: TObject);
var
  i, tg: integer;
  Template: TTemplate;
  ttyp: TTemplateType;
  Node: TTreeNode;
  idx: TTypeIndex;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    tg := cbxType.ItemIndex;
    if tg >= 0 then
    begin
      if CanClone(FCurTree.Selected) then
      begin
        idx := IdxForced[FForceContainer, tg];
        if (idx = tiRemDlg) and (not (GetLinkType(FCurTree.Selected) in [ltNone, ltTitle])) then
        begin
          FUpdating := TRUE;
          try
            cbxType.ItemIndex := ord(tiTemplate);
          finally
            FUpdating := FALSE;
          end;
          ShowMsg('Can not assign a Reminder Dialog to a Reason for Request');
        end
        else
        begin
          Clone(FCurTree.Selected);
          Template := TTemplate(FCurTree.Selected.Data);
          if assigned(Template) and Template.CanModify then
          begin
            ttyp := TypeTag[idx];
            if (not FForceContainer) or (not (idx in [tiTemplate, tiRemDlg])) then
            begin
              if (ttyp = ttDialog) then
              begin
                Template.Dialog := TRUE;
                ttyp := ttGroup;
              end
              else
                Template.Dialog := FALSE;
              Template.RealType := ttyp;
              if (Template.RealType = ttDoc) and (idx = tiRemDlg) then
                Template.IsReminderDialog := TRUE
              else
                Template.IsReminderDialog := FALSE;
              if (Template.RealType = ttDoc) and (idx = tiCOMObj) then
                Template.IsCOMObject := TRUE
              else
                Template.IsCOMObject := FALSE;
              UpdateApply(Template);
            end;
            for i := 0 to Template.Nodes.Count - 1 do
            begin
              Node := TTreeNode(Template.Nodes.Objects[i]);
              Node.ImageIndex := dmodShared.ImgIdx(Node);
              Node.SelectedIndex := dmodShared.ImgIdx(Node);
            end;
            tvShared.Invalidate;
            tvPersonal.Invalidate;
            Node := FCurTree.Selected;
            tvTreeChange(TTreeView(Node.TreeView), Node);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.cbxRemDlgsChange(Sender: TObject);
var
  Template: TTemplate;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    FCanDoReminders) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      Template := TTemplate(FCurTree.Selected.Data);
      if assigned(Template) and Template.CanModify then
      begin
        if cbxRemDlgs.ItemIndex < 0 then
          Template.ReminderDialog := ''
        else
          Template.ReminderDialog := cbxRemDlgs.Items[cbxRemDlgs.ItemIndex];
        UpdateApply(Template);
      end;
    end;
  end;
end;

procedure TfrmTemplateEditor.mnuTemplateIconLegendClick(Sender: TObject);
begin
  ShowIconLegend(ilTemplates, TRUE);
end;

procedure TfrmTemplateEditor.cbLongLinesClick(Sender: TObject);
begin
  pnlBoilerplateResize(Self);
  pnlBoilerplateResize(Self); // Second Call is Needed!
end;

procedure TfrmTemplateEditor.AutoLongLines(Sender: TObject);
begin
  cbLongLines.Checked := TRUE;
end;

(*procedure TfrmTemplateEditor.UpdatePersonalObjects;
var
  i: integer;

begin
  if not assigned(FPersonalObjects) then
  begin
    FPersonalObjects := TStringList.Create;
    GetAllowedPersonalObjects;
    for i := 0 to RPCBrokerV.Results.Count-1 do
      FPersonalObjects.Add(Piece(RPCBrokerV.Results[i],U,1));
    FPersonalObjects.Sorted := TRUE;
  end;
end;*)

(*function TfrmTemplateEditor.ModifyAllowed(const Node: TTreeNode): boolean;
var
  tmpl: TTemplate;

  function GetFirstPersonalNode(Node: TTreeNode): TTreeNode;
  begin
    Result := Node;
    if assigned(Node.Parent) and (TTemplate(Node.Data).PersonalOwner <> User.DUZ) then
      Result := GetFirstPersonalNode(Node.Parent);
  end;

begin
  if(assigned(Node)) then
  begin
    if (TTreeView(Node.TreeView) = tvPersonal) then
      Result := TTemplate(GetFirstPersonalNode(Node).Data).CanModify
    else
      Result := TRUE;
  end
  else
    Result := FALSE;
  if Result then
  begin
    tmpl := TTemplate(Node.Data);
    if (tmpl.PersonalOwner = 0) or (tmpl.PersonalOwner = User.DUZ) then
      Result := tmpl.CanModify;
  end;
end;
*)

{ Returns TRUE if Cloning is not needed or if Cloning is needed and
  the top personal Node in the tree is locked. }

function TfrmTemplateEditor.CanClone(const Node: TTreeNode): boolean;
var
  Template: TTemplate;

  function GetFirstPersonalNode(Node: TTreeNode): TTreeNode;
  begin
    Result := Node;
    if assigned(Node.Parent) and (TTemplate(Node.Data).PersonalOwner <> User.DUZ) then
      Result := GetFirstPersonalNode(Node.Parent);
  end;

begin
  if (assigned(Node)) and assigned(Node.Data) then
  begin
    if (TTreeView(Node.TreeView) = tvPersonal) then
    begin
      Template := TTemplate(Node.Data);
      if Template.IsCOMObject or (Template.FileLink <> '') then
        Result := FALSE
      else
        Result := TTemplate(GetFirstPersonalNode(Node).Data).CanModify
    end
    else
      Result := TRUE;
  end
  else
    Result := FALSE;
end;

procedure TfrmTemplateEditor.UpdateApply(Template: TTemplate);
begin
  if (not btnApply.Enabled) then
    btnApply.Enabled := Template.Changed;
end;

procedure TfrmTemplateEditor.TemplateLocked(Sender: TObject);
begin
  Resync([TTemplate(Sender)]);
  ShowMsg(Format(TemplateLockedText, [TTemplate(Sender).PrintName]));
end;

procedure TfrmTemplateEditor.cbLockClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPLockFLD);
end;

procedure TfrmTemplateEditor.mnuRefreshClick(Sender: TObject);
begin
  if btnApply.Enabled then
  begin
    if InfoBox('All changes must be saved before you can Refresh.  Save Changes?',
      'Confirmation', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      exit;
  end;
  btnApplyClick(Sender);
  if BtnApply.Enabled then
    InfoBox('Save not completed - unable to refresh.', 'Error', MB_OK or MB_ICONERROR)
  else
    RefreshData;
end;

procedure TfrmTemplateEditor.RefreshData;
var
  exp1, exp2, s1, s2, t1, t2: string;
  focus: TWinControl;

begin
  focus := FCurTree;
  exp1 := tvShared.GetExpandedIDStr(1, ';');
  exp2 := tvPersonal.GetExpandedIDStr(1, ';');
  s1 := tvShared.GetNodeID(TORTreeNode(tvShared.Selected), 1, ';');
  s2 := tvPersonal.GetNodeID(TORTreeNode(tvPersonal.Selected), 1, ';');
  t1 := tvShared.GetNodeID(TORTreeNode(tvShared.TopItem), 1, ';');
  t2 := tvPersonal.GetNodeID(TORTreeNode(tvPersonal.TopItem), 1, ';');
  tvPersonal.Items.BeginUpdate;
  try
    tvShared.Items.BeginUpdate;
    try
      ReleaseTemplates;
      tvPersonal.Items.Clear;
      tvShared.Items.Clear;
      InitTrees;
      tvShared.SetExpandedIDStr(1, ';', exp1);
      tvShared.TopItem := tvShared.FindPieceNode(t1, 1, ';');
      tvShared.Selected := tvShared.FindPieceNode(s1, 1, ';');
      tvPersonal.SetExpandedIDStr(1, ';', exp2);
      tvPersonal.TopItem := tvPersonal.FindPieceNode(t2, 1, ';');
      tvPersonal.Selected := tvPersonal.FindPieceNode(s2, 1, ';');
    finally
      tvShared.Items.EndUpdate;
    end;
  finally
    tvPersonal.Items.EndUpdate;
  end;
  ActiveControl := focus;
end;

procedure TfrmTemplateEditor.InitTrees;
begin
  LoadTemplateData;
  if (not assigned(RootTemplate)) then
    SaveTemplate(AddTemplate('0^R^A^Shared Templates'), -1);
  if (not assigned(MyTemplate)) then
    AddTemplate('0^P^A^My Templates^^^' + IntToStr(User.DUZ));
  dmodShared.AddTemplateNode(tvPersonal, FPersonalEmptyNodeCount, MyTemplate);
  dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, RootTemplate);
  if (UserTemplateAccessLevel = taEditor) then
  begin
    if CanEditLinkType(ttTitles) then
      dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, TitlesTemplate);
    if CanEditLinkType(ttConsults) then
      dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, ConsultsTemplate);
    if CanEditLinkType(ttProcedures) then
      dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, ProceduresTemplate);
  end;
end;

procedure TfrmTemplateEditor.reResizeRequest(Sender: TObject;
  Rect: TRect);
var
  R: TRect;

begin
  R := TRichEdit(Sender).ClientRect;
  if (FLastRect.Right <> R.Right) or
    (FLastRect.Bottom <> R.Bottom) or
    (FLastRect.Left <> R.Left) or
    (FLastRect.Top <> R.Top) then
  begin
    FLastRect := R;
    pnlBoilerplateResize(Self);
  end;
end;

procedure TfrmTemplateEditor.reBoilSelectionChange(Sender: TObject);
begin
  UpdateXY(reBoil, lblBoilCol, lblBoilRow);
end;

procedure TfrmTemplateEditor.reGroupBPSelectionChange(Sender: TObject);
begin
  UpdateXY(reGroupBP, lblGroupCol, lblGroupRow);
end;

procedure TfrmTemplateEditor.UpdateXY(re: TRichEdit; lblX, lblY: TLabel);
var
  p: TPoint;

begin
  p := re.CaretPos;
  lblY.Caption := 'Line: ' + inttostr(p.y + 1);
  lblX.Caption := 'Column: ' + inttostr(p.x + 1);
end;

procedure TfrmTemplateEditor.cbxCOMObjChange(Sender: TObject);
var
  Template: TTemplate;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    FCanDoCOMObjects and (FCurTree = tvShared)) then
  begin
    Template := TTemplate(FCurTree.Selected.Data);
    if assigned(Template) and Template.CanModify then
    begin
      if cbxCOMObj.ItemIndex < 0 then
        Template.COMObject := 0
      else
        Template.COMObject := cbxCOMObj.ItemID;
      UpdateApply(Template);
    end;
  end;
end;

procedure TfrmTemplateEditor.edtCOMParamChange(Sender: TObject);
var
  Template: TTemplate;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    FCanDoCOMObjects and (FCurTree = tvShared)) then
  begin
    Template := TTemplate(FCurTree.Selected.Data);
    if assigned(Template) and Template.CanModify then
    begin
      Template.COMParam := edtCOMParam.Text;
      UpdateApply(Template);
    end;
  end;
end;

function TfrmTemplateEditor.GetLinkType(const ANode: TTreeNode): TTemplateLinkType;
var
  Node: TTreeNode;

begin
  Result := ltNone;
  if assigned(ANode) then
  begin
    if (not assigned(ANode.Data)) or (TTemplate(ANode.Data).RealType <> ttClass) then
    begin
      Node := ANode.Parent;
      repeat
        if assigned(Node) and assigned(Node.Data) then
        begin
          if (TTemplate(Node.Data).FileLink <> '') then
            Node := nil
          else
            if (TTemplate(Node.Data).RealType in AllTemplateLinkTypes) then
            begin
              case TTemplate(Node.Data).RealType of
                ttTitles: Result := ltTitle;
                ttConsults: Result := ltConsult;
                ttProcedures: Result := ltProcedure;
              end;
            end
            else
              Node := Node.Parent;
        end
        else
          Node := nil;
      until (Result <> ltNone) or (not assigned(Node));
    end;
  end;
end;

procedure TfrmTemplateEditor.cbxLinkNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  tmpSL: TStringList;
  i: integer;
  tmp: string;

begin
  tmpSL := TStringList.Create;
  try
    case TTemplateLinkType(pnlLink.Tag) of
      ltTitle: FastAssign(SubSetOfAllTitles(StartFrom, Direction), tmpSL);
//      ltConsult:
      ltProcedure:
        begin
          FastAssign(SubSetOfProcedures(StartFrom, Direction), tmpSL);
          for i := 0 to tmpSL.Count - 1 do
          begin
            tmp := tmpSL[i];
            setpiece(tmp, U, 1, piece(piece(tmp, U, 4), ';', 1));
            tmpSL[i] := tmp;
          end;
        end;
    end;
    cbxLink.ForDataUse(tmpSL);
  finally
    tmpSL.Free;
  end;
end;

procedure TfrmTemplateEditor.cbxLinkExit(Sender: TObject);
var
  Template, LinkTemplate: TTemplate;
  update: boolean;

begin
  if ((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
    (FCurTree = tvShared)) then
  begin
    Template := TTemplate(FCurTree.Selected.Data);
    if assigned(Template) and Template.CanModify then
    begin
      update := true;
      if cbxLink.ItemIEN > 0 then
      begin
        LinkTemplate := GetLinkedTemplate(cbxLink.ItemID, TTemplateLinkType(pnlLink.tag));
        if (assigned(LinkTemplate) and (LinkTemplate <> Template)) then
        begin
          ShowMsg(GetLinkName(cbxLink.ItemID, TTemplateLinkType(pnlLink.tag)) +
            ' is already assigned to another template.');
          cbxLink.SetFocus;
          cbxLink.SelectByID(Template.LinkIEN);
          update := False;
        end
        else
        begin
          Template.FileLink := ConvertFileLink(cbxLink.ItemID, TTemplateLinkType(pnlLink.tag));
          if Template.LinkName <> '' then
            edtName.Text := copy(Template.LinkName, 1, edtName.MaxLength);
        end;
      end
      else
        Template.FileLink := '';
      if update then
        UpdateApply(Template);
    end;
  end;
end;

procedure TfrmTemplateEditor.reBoilKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl in Shift then
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmTemplateEditor.reBoilKeyPress(Sender: TObject;
  var Key: Char);
begin
  if FNavigatingTab then
    Key := #0; //Disable shift-tab processinend;
end;

procedure TfrmTemplateEditor.reBoilKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //The navigating tab controls were inadvertantently adding tab characters
  //This should fix it
  FNavigatingTab := (Key = VK_TAB) and ([ssShift, ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

end.

