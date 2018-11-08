unit fDCSumm;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  uPCE, ORClasses, fDrawers, rDCSumm, uDocTree, uDCSumm, uTIU, fPrintList,
  VA508AccessibilityManager, fBase508Form, VA508ImageListLabeler, ORextensions;

type
  TfrmDCSumm = class(TfrmHSplit)
    mnuSumms: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartSumms: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartCover: TMenuItem;
    Z1: TMenuItem;
    mnuViewDetail: TMenuItem;
    mnuAct: TMenuItem;
    mnuActNew: TMenuItem;
    Z2: TMenuItem;
    mnuActSave: TMenuItem;
    mnuActDelete: TMenuItem;
    mnuActEdit: TMenuItem;
    mnuActSign: TMenuItem;
    mnuActAddend: TMenuItem;
    lblSumms: TOROffsetLabel;
    pnlRead: TPanel;
    lblTitle: TOROffsetLabel;
    memSumm: TRichEdit;
    pnlWrite: TPanel;
    memNewSumm: TRichEdit;
    Z3: TMenuItem;
    mnuViewAll: TMenuItem;
    mnuViewByAuthor: TMenuItem;
    mnuViewByDate: TMenuItem;
    mnuViewUncosigned: TMenuItem;
    mnuViewUnsigned: TMenuItem;
    mnuActSignList: TMenuItem;
    cmdNewSumm: TORAlignButton;
    lblSpace1: TLabel;
    cmdPCE: TORAlignButton;
    popSummMemo: TPopupMenu;
    popSummMemoCut: TMenuItem;
    popSummMemoCopy: TMenuItem;
    popSummMemoPaste: TMenuItem;
    Z10: TMenuItem;
    popSummMemoSignList: TMenuItem;
    popSummMemoDelete: TMenuItem;
    popSummMemoEdit: TMenuItem;
    popSummMemoSave: TMenuItem;
    popSummMemoSign: TMenuItem;
    popSummList: TPopupMenu;
    popSummListAll: TMenuItem;
    popSummListByAuthor: TMenuItem;
    popSummListByDate: TMenuItem;
    popSummListUncosigned: TMenuItem;
    popSummListUnsigned: TMenuItem;
    pnlFields: TORAutoPanel;
    sptVert: TSplitter;
    memPCEShow: TRichEdit;
    mnuActIdentifyAddlSigners: TMenuItem;
    popSummMemoAddlSign: TMenuItem;
    Z11: TMenuItem;
    popSummMemoSpell: TMenuItem;
    popSummMemoGrammar: TMenuItem;
    mnuViewCustom: TMenuItem;
    N1: TMenuItem;
    mnuViewSaveAsDefault: TMenuItem;
    mnuViewReturnToDefault: TMenuItem;
    pnlDrawers: TPanel;
    lstSumms: TORListBox;
    N2: TMenuItem;
    popSummMemoTemplate: TMenuItem;
    mnuOptions: TMenuItem;
    mnuEditTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    splDrawers: TSplitter;
    N3: TMenuItem;
    mnuEditSharedTemplates: TMenuItem;
    mnuNewSharedTemplate: TMenuItem;
    timAutoSave: TTimer;
    cmdChange: TButton;
    lblNewTitle: TStaticText;
    lblVisit: TStaticText;
    lblRefDate: TStaticText;
    lblCosigner: TStaticText;
    lblDictator: TStaticText;
    lblDischarge: TStaticText;
    popSummMemoPaste2: TMenuItem;
    popSummMemoReformat: TMenuItem;
    Z4: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActLoadBoiler: TMenuItem;
    bvlNewTitle: TBevel;
    popSummMemoSaveContinue: TMenuItem;
    N4: TMenuItem;
    mnuEditDialgFields: TMenuItem;
    lvSumms: TCaptionListView;
    sptList: TSplitter;
    N5: TMenuItem;
    popSummListExpandSelected: TMenuItem;
    popSummListExpandAll: TMenuItem;
    popSummListCollapseSelected: TMenuItem;
    popSummListCollapseAll: TMenuItem;
    tvSumms: TORTreeView;
    popSummListCustom: TMenuItem;
    N6: TMenuItem;
    popSummListDetachFromIDParent: TMenuItem;
    mnuActDetachFromIDParent: TMenuItem;
    popSummListAddIDEntry: TMenuItem;
    mnuActAddIDEntry: TMenuItem;
    N7: TMenuItem;
    mnuIconLegend: TMenuItem;
    dlgFindText: TFindDialog;
    popSummMemoFind: TMenuItem;
    dlgReplaceText: TReplaceDialog;
    N8: TMenuItem;
    popSummMemoReplace: TMenuItem;
    mnuChartSurgery: TMenuItem;
    mnuActAttachtoIDParent: TMenuItem;
    popSummListAttachtoIDParent: TMenuItem;
    popSummMemoAddend: TMenuItem;
    N9: TMenuItem;
    popSummMemoPreview: TMenuItem;
    popSummMemoInsTemplate: TMenuItem;
    popSummMemoEncounter: TMenuItem;
    mnuViewInformation: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewReminders: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    mnuViewPostings: TMenuItem;
    imgLblNotes: TVA508ImageListLabeler;
    imgLblImages: TVA508ImageListLabeler;
    procedure mnuChartTabClick(Sender: TObject);
    procedure lstSummsClick(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure cmdNewSummClick(Sender: TObject);
    procedure memNewSummChange(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure mnuActAddIDEntryClick(Sender: TObject);
    procedure mnuActSaveClick(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure mnuActAddendClick(Sender: TObject);
    procedure mnuActDetachFromIDParentClick(Sender: TObject);
    procedure mnuActSignListClick(Sender: TObject);
    procedure mnuActDeleteClick(Sender: TObject);
    procedure mnuActEditClick(Sender: TObject);
    procedure mnuActSignClick(Sender: TObject);
    procedure cmdOrdersClick(Sender: TObject);
    procedure cmdPCEClick(Sender: TObject);
    procedure popSummMemoCutClick(Sender: TObject);
    procedure popSummMemoCopyClick(Sender: TObject);
    procedure popSummMemoPasteClick(Sender: TObject);
    procedure popSummMemoPopup(Sender: TObject);
    procedure pnlWriteResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuViewDetailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuActIdentifyAddlSignersClick(Sender: TObject);
    procedure popSummMemoAddlSignClick(Sender: TObject);
    procedure popSummMemoSpellClick(Sender: TObject);
    procedure popSummMemoGrammarClick(Sender: TObject);
    procedure mnuViewSaveAsDefaultClick(Sender: TObject);
    procedure mnuViewReturntoDefaultClick(Sender: TObject);
    procedure popSummMemoTemplateClick(Sender: TObject);
    procedure mnuNewTemplateClick(Sender: TObject);
    procedure mnuEditTemplatesClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuEditSharedTemplatesClick(Sender: TObject);
    procedure mnuNewSharedTemplateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure popSummMemoReformatClick(Sender: TObject);
    procedure mnuActChangeClick(Sender: TObject);
    procedure mnuActLoadBoilerClick(Sender: TObject);
    procedure popSummMemoSaveContinueClick(Sender: TObject);
    procedure mnuEditDialgFieldsClick(Sender: TObject);
    procedure tvSummsChange(Sender: TObject; Node: TTreeNode);
    procedure tvSummsClick(Sender: TObject);
    procedure tvSummsCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvSummsExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvSummsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure tvSummsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvSummsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvSummsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvSummsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvSummsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure popSummListExpandAllClick(Sender: TObject);
    procedure popSummListCollapseAllClick(Sender: TObject);
    procedure popSummListExpandSelectedClick(Sender: TObject);
    procedure popSummListCollapseSelectedClick(Sender: TObject);
    procedure popSummListPopup(Sender: TObject);
    procedure lvSummsResize(Sender: TObject);
    procedure mnuIconLegendClick(Sender: TObject);
    procedure popSummMemoFindClick(Sender: TObject);
    procedure dlgFindTextFind(Sender: TObject);
    procedure dlgReplaceTextReplace(Sender: TObject);
    procedure dlgReplaceTextFind(Sender: TObject);
    procedure popSummMemoReplaceClick(Sender: TObject);
    procedure mnuActAttachtoIDParentClick(Sender: TObject);
    procedure memNewSummKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sptHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure popSummMemoPreviewClick(Sender: TObject);
    procedure popSummMemoInsTemplateClick(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
  private
    FEditingIndex: Integer;                      // index of Summary being currently edited
    FChanged: Boolean;                           // true if any text has changed in the Summary
    FEditCtrl: TCustomEdit;
    FDischargeDate: TFMDateTime;
    FSilent: Boolean;
    FCurrentContext: TTIUContext;
    FDefaultContext: TTIUContext;
    FImageFlag: TBitmap;
    FEditDCSumm: TEditDCSummRec;
    FShowAdmissions: Boolean;
    FVerifySummTitle: Integer;
    FDocList: TStringList;
    FConfirmed: boolean;
    FDeleted: boolean;
    FLastSummID: string;
    function NoSummSelected : Boolean;
    procedure ClearEditControls;
    function StartNewEdit(NewNoteType: integer): Boolean;
    procedure DoAutoSave(Suppress: integer = 1);
    function LacksRequiredForCreate: Boolean;
    function GetTitleText(AnIndex: Integer): string;
    //function MakeTitleText(IsAddendum: Boolean = False): string;
    procedure SetEditingIndex(const Value: Integer);
    procedure DisplayPCE;
    function  LockSumm(AnIEN: Int64): Boolean;
    procedure InsertAddendum;
    procedure InsertNewSumm(IsIDChild: boolean; AnIDParent: integer);
    procedure LoadForEdit(PreserveValues: Boolean);
    procedure RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
    procedure SaveEditedSumm(var Saved: Boolean);
    procedure SaveCurrentSumm(var Saved: Boolean);
    procedure ShowPCEControls(ShouldShow: Boolean);
    function  TitleText(AnIndex: Integer): string;
    procedure ProcessNotifications;
    procedure SetViewContext(AContext: TTIUContext);
    function GetDrawers: TFrmDrawers;
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
    function VerifySummTitle: Boolean;
    //  added for treeview - see also uDocTree.pas
    procedure LoadSumms;
    procedure UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure  EnableDisableIDNotes;
    procedure DoAttachIDChild(AChild, AParent: TORTreeNode);
    function SetSummTreeLabel(AContext: TTIUContext): string;
  public
    function  AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RequestPrint; override;
    procedure RequestMultiplePrint(AForm: TfrmPrintList);
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure LstSummsToPrint;
  published
    property Drawers: TFrmDrawers read GetDrawers; // Keep Drawers published
  end;

var
  frmDCSumm: TfrmDCSumm;

implementation

{$R *.DFM}

uses fFrame, fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem, fEncounterFrame,
     rPCE, Clipbrd, fNotePrt, fAddlSigners, fNoteDR, uSpell, rVitals, fTIUView,
     fTemplateEditor, rTIU, fDCSummProps, fNotesBP, fTemplateFieldEditor, uTemplates,
     fReminderDialog, dShared, rTemplates, fIconLegend, fNoteIDParents, rECS, ORNet, trpcb,
     fTemplateDialog, uVA508CPRSCompatibility, VA508AccessibilityRouter, System.Types,
     System.UITypes;

const
  NA_CREATE     = 0;                             // New Summ action - create new Summ
  NA_SHOW       = 1;                             // New Summ action - show current
  NA_SAVECREATE = 2;                             // New Summ action - save current then create

  TYP_DC_SUMM = 244;
  DC_NEW_SUMM = -50;                             // Holder IEN for a new Summary
  DC_ADDENDUM = -60;                             // Holder IEN for a new addendum

  DC_ACT_NEW_SUMM  = 2;
  DC_ACT_ADDENDUM  = 3;
  DC_ACT_EDIT_SUMM = 4;
  DC_ACT_ID_ENTRY  = 5;
 
  TX_NEED_VISIT = 'A visit is required before creating a new Discharge Summary.';
  TX_NO_VISIT   = 'Insufficient Visit Information';
  TX_BOILERPLT  = 'You have modified the text of this Discharge Summary.  Changing the title will' +
                  ' discard the Discharge Summary text.' + CRLF + 'Do you wish to continue?';
  TX_NEWTITLE   = 'Change Discharge Summary Title';
  TX_REQD_SUMM  = 'The following information is required to save a Discharge Summary - ' + CRLF;
  TX_REQD_ADDM  = 'The following information is required to save an addendum - ' + CRLF;
  TX_REQD_COSIG = CRLF + 'Attending Physician';
  TX_REQ2       = CRLF + CRLF +
                  'It is recommended that these fields be entered before continuing' + CRLF +
                  'to prevent losing the summary should the application time out.';
  TX_CREATE_ERR = 'Error Creating Summary';
  TX_UPDATE_ERR = 'Error Updating Summary';
  TX_NO_NOTE    = 'No Discharge Summary is currently being edited';
  TX_SAVE_NOTE  = 'Save Discharge Summary';
  TX_ADDEND_NO  = 'Cannot make an addendum to a Summary that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this Discharge Summary?';
  TX_DEL_ERR    = 'Unable to Delete Summary';
  TX_SIGN       = 'Sign Summary';
  TX_COSIGN     = 'Cosign Summary';
  TX_SIGN_ERR   = 'Unable to Sign Summary';

  TX_NOSUMM     = 'No Discharge Summary is currently selected.';
  TX_NOSUMM_CAP = 'No Summary Selected';
  TX_NOPRT_NEW  = 'This Discharge Summary may not be printed until it is saved';
  TX_NOPRT_NEW_CAP = 'Save Discharge Summary';
  TX_NOT_INPATIENT = 'Discharge Summaries are only applicable to hospital admissions.';
  TX_NO_ADMISSION_CAP  = 'No hospital admission was selected';
  TX_NO_ALERT   = 'There is insufficient information to process this alert.' + CRLF +
                  'Either the alert has already been deleted, or it contained invalid data.' + CRLF + CRLF +
                  'Click the NEXT button if you wish to continue processing more alerts.';
  TX_CAP_NO_ALERT = 'Unable to Process Alert';
  TX_NO_FUTURE_DT = 'A Reference Date/Time in the future is not allowed.';
  TX_RELEASE      = 'Do you want to release this summary from DRAFT mode to UNSIGNED' + CRLF +
                    'status? This does not release the summary as the official,' + CRLF +
                    'completed Discharge Summary until it is COSIGNED.';
                    //'Do you want to release this discharge summary?';
  TC_RELEASE      = 'Release Document';
  TX_NEW_SAVE1    = 'You are currently editing:' + CRLF + CRLF;
  TX_NEW_SAVE2    = CRLF + CRLF + 'Do you wish to save this summary and begin a new one?';
  TX_NEW_SAVE3    = CRLF + CRLF + 'Do you wish to save this summary and begin a new addendum?';
  TX_NEW_SAVE4    = CRLF + CRLF + 'Do you wish to save this summary and edit the one selected?';
  TX_NEW_SAVE5    = CRLF + CRLF + 'Do you wish to save this summary and begin a new Interdisciplinary entry?';
  TC_NEW_SAVE2    = 'Create New Summary';
  TC_NEW_SAVE3    = 'Create New Addendum';
  TC_NEW_SAVE4    = 'Edit Different Summary';
  TC_NEW_SAVE5    = 'Create New Interdisciplinary Entry';
  TC_NO_LOCK      = 'Unable to Lock Summary';
  TX_EMPTY_SUMM   = CRLF + CRLF + 'This discharge summary contains no text and will not be saved.' + CRLF +
                    'Do you wish to delete this discharge summary?';
  TC_EMPTY_SUMM   = 'Empty Note';
  TX_EMPTY_SUMM1   = 'This document contains no text and can not be signed.';
  TX_ABSAVE       = 'It appears the session terminated abnormally when this' + CRLF +
                    'note was last edited. Some text may not have been saved.' + CRLF + CRLF +
                    'Do you wish to continue and sign the note?';
  TC_ABSAVE       = 'Possible Missing Text';
  TX_NO_BOIL      = 'There is no boilerplate text associated with this title.';
  TC_NO_BOIL      = 'Load Boilerplate Text';
  TX_BLR_CLEAR    = 'Do you want to clear the previously loaded boilerplate text?';
  TC_BLR_CLEAR    = 'Clear Previous Boilerplate Text';
  TX_MISSING_FIELDS = 'This document can not be saved.  An ATTENDING must first be entered.';
  TC_MISSING_FIELDS = 'Unable to save';
  TX_DETACH_CNF     = 'Confirm Detachment';
  TX_DETACH_FAILURE = 'Detach failed';
  TX_RETRACT_CAP    = 'Retraction Notice';
  TX_RETRACT        = 'This document will now be RETRACTED.  As Such, it has been removed' +CRLF +
                      ' from public view, and from typical Releases of Information,' +CRLF +
                      ' but will remain indefinitely discoverable to HIMS.' +CRLF +CRLF;
  TX_AUTH_SIGNED    = 'Author has not signed, are you SURE you want to sign.' +CRLF;

var
  uPCEShow, uPCEEdit:  TPCEData;
  ViewContext: Integer;
  frmDrawers: TfrmDrawers;
  uDCSummContext: TTIUContext;
  ColumnToSort: Integer;
  ColumnSortForward: Boolean;
  uChanging: Boolean;
  uIDNotesActive: Boolean;

{ TPage common methods --------------------------------------------------------------------- }

function TfrmDCSumm.AllowContextChange(var WhyNot: string): Boolean;
begin
  dlgFindText.CloseDialog;
  Result := inherited AllowContextChange(WhyNot);  // sets result = true
  if Assigned(frmTemplateDialog) then
    if Screen.ActiveForm = frmTemplateDialog then
    //if (fsModal in frmTemplateDialog.FormState) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'A template in progress will be aborted.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmTemplateDialog.Silent := True;
                 frmTemplateDialog.ModalResult := mrCancel;
               end;
           end;
    end;
  if EditingIndex <> -1 then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
    '1': begin
             if memNewSumm.GetTextLen > 0 then
               WhyNot := WhyNot + 'A discharge summary in progress will be saved as unsigned.  '
             else
               WhyNot := WhyNot + 'An empty discharge summary in progress will be deleted.  ';
           Result := False;
         end;
    '0': begin
           if WhyNot = 'COMMIT' then FSilent := True;
           SaveCurrentSumm(Result);
         end;
  end;
  if Assigned(frmEncounterFrame) then
    if Screen.ActiveForm = frmEncounterFrame then
    //if (fsModal in frmEncounterFrame.FormState) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := WhyNot + 'Encounter information being edited will not be saved';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmEncounterFrame.Abort := False;
                 frmEncounterFrame.Cancel := True;
               end;
           end;
    end;
end;

procedure TfrmDCSumm.LstSummsToPrint;
var
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
begin
  inherited;
  if lstSumms.ItemIEN = 0 then exit;
  SavedDocID := lstSumms.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
    LoadSumms;
    with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvSumms.Selected = nil then exit;
  AParentID := frmPrintList.SelectParentFromList(tvSumms,CT_DCSUMM);
  if AParentID = '' then exit;
  with tvSumms do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
end;

procedure TfrmDCSumm.ClearPtData;
{ clear all controls that contain patient specific information }
begin
  inherited ClearPtData;
  ClearEditControls;
  uChanging := True;
  tvSumms.Items.BeginUpdate;
  KillDocTreeObjects(tvSumms);
  tvSumms.Items.Clear;
  tvSumms.Items.EndUpdate;
  uChanging := False;
  lstSumms.Clear;
  memSumm.Clear;
  memPCEShow.Clear;
  uPCEShow.Clear;
  uPCEEdit.Clear;
  frmDrawers.ResetTemplates;
end;

procedure TfrmDCSumm.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_DCSUMM;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  frmFrame.mnuFilePrintSelectedItems.Enabled := True;
  if InitPage then
  begin
    EnableDisableIDNotes;
    FDefaultContext := GetCurrentDCSummContext;
    FCurrentContext := FDefaultContext;
    popSummMemoSpell.Visible   := SpellCheckAvailable;
    popSummMemoGrammar.Visible := popSummMemoSpell.Visible;
    Z11.Visible                := popSummMemoSpell.Visible;
    timAutoSave.Interval := User.AutoSave * 1000;  // convert seconds to milliseconds
    SetEqualTabStops(memNewSumm);
  end;
  // to indent the right margin need to set Paragraph.RightIndent for each paragraph?
  if InitPatient and not (CallingContext = CC_NOTIFICATION) then
    begin
      SetViewContext(FDefaultContext);
    end;
  case CallingContext of
    CC_INIT_PATIENT: if not InitPatient then
                       begin
                         SetViewContext(FDefaultContext);
                       end;
  CC_NOTIFICATION: ProcessNotifications;
  end;
end;

procedure TfrmDCSumm.RequestPrint;
var
  Saved: Boolean;
begin
  with lstSumms do
  begin
    if ItemIndex = EditingIndex then  
    //if ItemIEN < 0 then
    begin
      SaveCurrentSumm(Saved);
      if not Saved then Exit;
    end;
    if ItemIEN > 0 then PrintNote(ItemIEN, MakeDCSummDisplayText(Items[ItemIndex])) else
    begin
      if ItemIEN = 0 then InfoBox(TX_NO_NOTE, TX_NOSUMM_CAP, MB_OK);
      if ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  end;
end;

procedure TfrmDCSumm.RequestMultiplePrint(AForm: TfrmPrintList);
var
  NoteIEN: int64;
  i: integer;
begin
  with AForm.lbIDParents do
  begin
    for i := 0 to Items.Count - 1 do
     begin
       if Selected[i] then
        begin
         NoteIEN := ItemIEN;  //StrToInt64def(Piece(TStringList(Items.Objects[i])[0],U,1),0);
         if NoteIEN > 0 then PrintNote(NoteIEN, DisplayText[i], TRUE) else
          begin
            if ItemIEN = 0 then InfoBox(TX_NO_NOTE, TX_NOSUMM_CAP, MB_OK);
            if ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
          end;
        end; {if selected}
     end; {for}
  end {with}
end;

procedure TfrmDCSumm.SetFontSize(NewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  inherited SetFontSize(NewFontSize);
  memSumm.Font.Size := NewFontSize;
  memNewSumm.Font.Size := NewFontSize;
  lblTitle.Font.Size := NewFontSize;
  frmDrawers.Font.Size := NewFontSize;
  SetEqualTabStops(memNewSumm);
  // adjust heights of pnlAction, pnlFields, and lstEncntShow
end;

procedure TfrmDCSumm.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmDCSumm.ClearEditControls;
{ resets controls used for entering a new Discharge Summary }
begin
  // clear FEditDCSumm (should FEditDCSumm be an object with a clear method?)
  with FEditDCSumm do
  begin
    DocType              := 0;
    EditIEN              := 0;
    Title                := 0;
    TitleName            := '';
    AdmitDateTime        := 0;
    DischargeDateTime    := 0;
    DictDateTime         := 0;
    Dictator             := 0;
    DictatorName         := '';
    Cosigner             := 0;
    CosignerName         := '';
    Transcriptionist     := 0;
    TranscriptionistName := '';
    Attending            := 0;
    AttendingName        := '';
    Urgency              := '';
    UrgencyName          := '';
    Location             := 0;
    LocationName         := '';
    Addend               := 0;
    VisitStr             := '';
    {LastCosigner & LastCosignerName aren't cleared because they're used as default for next note.}
    Lines                := nil;
  end;
  // clear the editing controls (also clear the new labels?)
  memNewSumm.Clear;
  timAutoSave.Enabled := False;
  // clear the PCE object for editing
  uPCEEdit.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  FChanged := False;
end;

procedure TfrmDCSumm.ShowPCEControls(ShouldShow: Boolean);
begin
  sptVert.Visible    := ShouldShow;
  memPCEShow.Visible := ShouldShow;
  if(ShouldShow) then
    sptVert.Top := memPCEShow.Top - sptVert.Height;
  memSumm.Invalidate;
end;

procedure TfrmDCSumm.DisplayPCE;
{ displays PCE information if appropriate & enables/disabled editing of PCE data }
var
  VitalStr:   TStringlist;
  NoPCE:      boolean;
  ActionSts: TActionRec;

begin
  memPCEShow.Clear;
  with lstSumms do if ItemIndex = EditingIndex then
  begin
    with uPCEEdit do
    begin
      AddStrData(memPCEShow.Lines);
      NoPCE := (memPCEShow.Lines.Count = 0);
      VitalStr  := TStringList.create;
      try
        GetVitalsFromDate(VitalStr, uPCEEdit);
        AddVitalData(VitalStr, memPCEShow.Lines);
      finally
        VitalStr.free;
      end;
      cmdPCE.Enabled := CanEditPCE(uPCEEdit);
      ShowPCEControls(cmdPCE.Enabled or (memPCEShow.Lines.Count > 0));
      if(NoPCE and memPCEShow.Visible) then
        memPCEShow.Lines.Insert(0, TX_NOPCE);

      frmDrawers.DisplayDrawers(TRUE, [odTemplates],[odTemplates]);
      cmdNewSumm.Visible := FALSE;
      lblSpace1.Top := cmdPCE.Top - lblSpace1.Height;
    end;
  end else
  begin
    cmdPCE.Enabled := False;

    frmDrawers.DisplayDrawers(FALSE);
    cmdNewSumm.Visible := TRUE;
    lblSpace1.Top := cmdNewSumm.Top - lblSpace1.Height;

    ActOnDocument(ActionSts, lstSumms.ItemIEN, 'VIEW');
    if ActionSts.Success then
    begin
      StatusText('Retrieving encounter information...');
      with uPCEShow do
      begin
        NoteDateTime := MakeFMDateTime(Piece(lstSumms.Items[lstSumms.ItemIndex], U, 3));
        PCEForNote(lstSumms.ItemIEN, uPCEEdit);
        AddStrData(memPCEShow.Lines);
        NoPCE := (memPCEShow.Lines.Count = 0);
        VitalStr  := TStringList.create;
        try
          GetVitalsFromNote(VitalStr, uPCEShow, lstSumms.ItemIEN);
          AddVitalData(VitalStr, memPCEShow.Lines);
        finally
          VitalStr.free;
        end;
        ShowPCEControls(memPCEShow.Lines.Count > 0);
        if(NoPCE and memPCEShow.Visible) then
          memPCEShow.Lines.Insert(0, TX_NOPCE);
      end;
      StatusText('');
    end
    else
      ShowPCEControls(FALSE);
  end; {if ItemIndex}
  memPCEShow.SelStart := 0;
  popSummMemoEncounter.Enabled := cmdPCE.Enabled;
end;

procedure TfrmDCSumm.InsertNewSumm(IsIDChild: boolean; AnIDParent: integer);
{ creates the editing context for a new Discharge Summary & inserts stub into top of view list}
const
  USE_CURRENT_VISITSTR = -2;
var
  EnableAutosave, HaveRequired, Saved: Boolean;
  CreatedSumm: TCreatedDoc;
  ListItemForEdit: string;
  TmpBoilerPlate: TStringList;
  tmpNode: TTreeNode;
  x, WhyNot: string;
  DocInfo: string;
begin
  EnableAutosave := FALSE;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    FShowAdmissions := True;
    FillChar(FEditDCSumm, SizeOf(FEditDCSumm), 0);  //v15.7
    with FEditDCSumm do
    begin
      EditIEN               := 0;
      DocType               := TYP_DC_SUMM;
      Title                 := DfltDCSummTitle;
      TitleName             := DfltDCSummTitleName;
      if IsIDChild and (not CanTitleBeIDChild(Title, WhyNot)) then
        begin
          Title := 0;
          TitleName := '';
        end;
      DictDateTime          := FMNow;
      Dictator              := User.DUZ;
      DictatorName          := User.Name;
      if IsIDChild then
        IDParent            := AnIDParent
      else
        IDParent   := 0;
    end;
    // check to see if interaction necessary to get required fields
    if LacksRequiredForCreate or VerifySummTitle
      then HaveRequired := ExecuteDCSummProperties(FEditDCSumm, ListItemForEdit, FShowAdmissions, IsIDChild)
      else HaveRequired := True;
    if HaveRequired then
    begin
      if ListItemForEdit <> '' then
        begin
          lstSumms.ItemIndex := -1;
          lstSumms.SelectByID(Piece(ListItemForEdit, U, 1));
          if lstSumms.ItemIndex < 0 then
            begin
              lstSumms.Items.Insert(0, ListItemForEdit);
              lstSumms.ItemIndex := 0;
            end;
          if lstSumms.ItemIndex = EditingIndex then Exit;
          if EditingIndex > -1 then
            begin
              if InfoBox(TX_NEW_SAVE1 + MakeDCSummDisplayText(lstSumms.Items[EditingIndex]) + TX_NEW_SAVE2,
                         TC_NEW_SAVE2, MB_YESNO) = IDNO then exit
              else
                begin
                  SaveCurrentSumm(Saved);
                  if not Saved then exit;
                end;
            end;
          //if not StartNewEdit then Exit;
          lstSummsClick(Self);
          LoadForEdit(True);
          Exit;
        end
      else
        begin
          // set up uPCEEdit for entry of new note
          uPCEEdit.UseEncounter := True;
          uPCEEdit.NoteDateTime := FEditDCSumm.DischargeDateTime;
          uPCEEdit.PCEForNote(USE_CURRENT_VISITSTR, uPCEShow);
          FEditDCSumm.NeedCPT  := uPCEEdit.CPTRequired;
           // create the note
          PutNewDCSumm(CreatedSumm, FEditDCSumm);

          uPCEEdit.NoteIEN := CreatedSumm.IEN;
          if CreatedSumm.IEN > 0 then LockDocument(CreatedSumm.IEN, CreatedSumm.ErrorText);
          if CreatedSumm.ErrorText = '' then
          begin
            //x := $$RESOLVE^TIUSRVLO formatted string
            //7348^Discharge Summary^3000913^NERD, YOURA  (N0165)^1329;Rich Vertigan;VERTIGAN,RICH^8E REHAB MED^unverified^Adm: 11/05/98;2981105.095547^        ;^^0^^^2
            with FEditDCSumm do
              begin
                x := IntToStr(CreatedSumm.IEN) + U + TitleName + U + FloatToStr(DischargeDateTime) + U +
                     Patient.Name + U + IntToStr(Dictator) + ';' + DictatorName + U + LocationName + U + 'new' + U +
                     'Adm: ' + FormatFMDateTime('dddddd', AdmitDateTime) + ';' + FloatToStr(AdmitDateTime) + U +
                     'Dis: ' + FormatFMDateTime('dddddd', DischargeDateTime) + ';' + FloatToStr(DischargeDateTime) +
                     U + U + U + U + U + U;
              end;
            lstSumms.Items.Insert(0, x);
            uChanging := True;
            tvSumms.Items.BeginUpdate;
            if IsIDChild then
              begin
                tmpNode := tvSumms.FindPieceNode(IntToStr(AnIDParent), 1, U, tvSumms.Items.GetFirstNode);
                tmpNode.ImageIndex := IMG_IDNOTE_OPEN;
                tmpNode.SelectedIndex := IMG_IDNOTE_OPEN;
                tmpNode := tvSumms.Items.AddChildObjectFirst(tmpNode, MakeDCSummDisplayText(x), MakeDCSummTreeObject(x));
                tmpNode.ImageIndex := IMG_ID_CHILD;
                tmpNode.SelectedIndex := IMG_ID_CHILD;
              end
            else
              begin
                tmpNode := tvSumms.Items.AddObjectFirst(tvSumms.Items.GetFirstNode, 'New Summary in Progress',
                                                        MakeDCSummTreeObject('NEW^New Summary in Progress^^^^^^^^^^^%^0'));
                TORTreeNode(tmpNode).StringData := 'NEW^New Summary in Progress^^^^^^^^^^^%^0';
                tmpNode.ImageIndex := IMG_TOP_LEVEL;
                tmpNode := tvSumms.Items.AddChildObjectFirst(tmpNode, MakeDCSummDisplayText(x), MakeDCSummTreeObject(x));
                tmpNode.ImageIndex := IMG_SINGLE;
                tmpNode.SelectedIndex := IMG_SINGLE;
              end;
            TORTreeNode(tmpNode).StringData := x;
            tvSumms.Selected := tmpNode;
            tvSumms.Items.EndUpdate;
            uChanging := False;
            Changes.Add(CH_SUM, IntToStr(CreatedSumm.IEN), GetTitleText(0), '', CH_SIGN_YES);
            lstSumms.ItemIndex := 0;
            EditingIndex := 0;
            if not assigned(TmpBoilerPlate) then
              TmpBoilerPlate := TStringList.Create;
            LoadBoilerPlate(TmpBoilerPlate, FEditDCSumm.Title);
            FChanged := False;
            cmdChangeClick(Self); // will set captions, sign state for Changes
            lstSummsClick(Self);  // will make pnlWrite visible
            if timAutoSave.Interval <> 0 then EnableAutosave := TRUE;
            memNewSumm.SetFocus;
          end else
          begin
            InfoBox(CreatedSumm.ErrorText, TX_CREATE_ERR, MB_OK);
            HaveRequired := False;
          end; {if CreatedSumm.IEN}
        end; {loaded for edit}
    end; {if HaveRequired}
    if not HaveRequired then ClearEditControls;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(CreatedSumm.IEN), FEditDCSumm);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditDCSumm.Title, ltTitle, Self, 'Title: ' + FEditDCSumm.TitleName, DocInfo);
      memNewSumm.Lines.Text := TmpBoilerPlate.Text;
      SpeakStrings(TmpBoilerPlate);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
  end;
end;

procedure TfrmDCSumm.InsertAddendum;
{ sets up fields of pnlWrite to write an addendum for the selected Summary}
const
  AS_ADDENDUM = True;
  IS_ID_CHILD = False;
var
  HaveRequired: Boolean;
  CreatedSumm: TCreatedDoc;
  ListItemForEdit: string;
  tmpNode: TTreeNode;
  x: string;
begin
  ClearEditControls;
  FShowAdmissions := False;
  with FEditDCSumm do
  begin
    DocType          := TYP_ADDENDUM;
    Title            := TitleForNote(lstSumms.ItemIEN);
    TitleName        := Piece(lstSumms.Items[lstSumms.ItemIndex], U, 2);
    if Copy(TitleName,1,1) = '+' then TitleName := Copy(TitleName, 3, 199);
    DictDateTime     := FMNow;
    Dictator         := User.DUZ;
    DictatorName     := User.Name;
    Addend           := lstSumms.ItemIEN;
  end;
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate
    then HaveRequired := ExecuteDCSummProperties(FEditDCSumm, ListItemForEdit, FShowAdmissions, IS_ID_CHILD)
    else HaveRequired := True;
  if HaveRequired then
  begin
    with FEditDCSumm do
      begin
        uPCEEdit.NoteDateTime := DischargeDateTime;
        uPCEEdit.PCEForNote(Addend, uPCEShow);
        Location     := uPCEEdit.Location;
        LocationName := ExternalName(uPCEEdit.Location, 44);
        AdmitDateTime    := uPCEEdit.DateTime;
        DischargeDateTime := StrToFMDateTime(GetDischargeDate(Patient.DFN, FloatToStr(AdmitDateTime)));
        if DischargeDateTime <= 0 then DischargeDateTime := FMNow;
      end;
    PutDCAddendum(CreatedSumm, FEditDCSumm, FEditDCSumm.Addend);

    uPCEEdit.NoteIEN := CreatedSumm.IEN;
    if CreatedSumm.IEN > 0 then LockDocument(CreatedSumm.IEN, CreatedSumm.ErrorText);
    if CreatedSumm.ErrorText = '' then
    begin
      with FEditDCSumm do
        begin
          x := IntToStr(CreatedSumm.IEN) + U + 'Addendum to ' + TitleName + U + FloatToStr(DischargeDateTime) + U +
               Patient.Name + U + IntToStr(Dictator) + ';' + DictatorName + U + LocationName + U + 'new' + U +
               'Adm: ' + FormatFMDateTime('dddddd', AdmitDateTime) + ';' + FloatToStr(AdmitDateTime) + U +
               'Dis: ' + FormatFMDateTime('dddddd', DischargeDateTime) + ';' + FloatToStr(DischargeDateTime) +
               U + U + U + U + U + U;
        end;
      lstSumms.Items.Insert(0, x);
      uChanging := True;
      tvSumms.Items.BeginUpdate;
      tmpNode := tvSumms.Items.AddObjectFirst(tvSumms.Items.GetFirstNode, 'New Addendum in Progress',
                                              MakeDCSummTreeObject('ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvSumms.Items.AddChildObjectFirst(tmpNode, MakeDCSummDisplayText(x), MakeDCSummTreeObject(x));
      TORTreeNode(tmpNode).StringData := x;
      tmpNode.ImageIndex := IMG_ADDENDUM;
      tmpNode.SelectedIndex := IMG_ADDENDUM;
      tvSumms.Selected := tmpNode;
      tvSumms.Items.EndUpdate;
      uChanging := False;
      Changes.Add(CH_SUM, IntToStr(CreatedSumm.IEN), GetTitleText(0), '', CH_SIGN_YES);
      lstSumms.ItemIndex := 0;
      EditingIndex := 0;
      cmdChangeClick(Self); // will set captions, sign state for Changes
      lstSummsClick(Self);  // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
      memNewSumm.SetFocus;
    end else
    begin
      InfoBox(CreatedSumm.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := False;
    end; {if CreatedNote.IEN}
  end; {if HaveRequired}
  if not HaveRequired then ClearEditControls;
end;

procedure TfrmDCSumm.LoadForEdit(PreserveValues: Boolean);
{ retrieves an existing Summ and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  x: string;
begin
  if not PreserveValues then ClearEditControls;
  if not LockSumm(lstSumms.ItemIEN) then Exit;
  EditingIndex := lstSumms.ItemIndex;
  Changes.Add(CH_SUM, lstSumms.ItemID, GetTitleText(EditingIndex), '', CH_SIGN_YES);
  if not PreserveValues then GetDCSummForEdit(FEditDCSumm, lstSumms.ItemIEN);
  if FEditDCSumm.Lines <> nil then memNewSumm.Lines.Assign(FEditDCSumm.Lines);
  FChanged := False;
  if FEditDCSumm.Title = TYP_ADDENDUM then
  begin
    FEditDCSumm.DocType := TYP_ADDENDUM;
    FEditDCSumm.TitleName := Piece(lstSumms.Items[lstSumms.ItemIndex], U, 2);
    if Copy(FEditDCSumm.TitleName,1,1) = '+' then FEditDCSumm.TitleName := Copy(FEditDCSumm.TitleName, 3, 199);
    if CompareText(Copy(FEditDCSumm.TitleName, 1, 8), 'Addendum') <> 0
      then FEditDCSumm.TitleName := FEditDCSumm.TitleName + 'Addendum to ';
  end;

  uChanging := True;
  tvSumms.Items.BeginUpdate;
  tmpNode := tvSumms.FindPieceNode('EDIT', 1, U, nil);
  if tmpNode = nil then
    begin
      tmpNode := tvSumms.Items.AddObjectFirst(tvSumms.Items.GetFirstNode, 'Summary being edited',
                                              MakeDCSummTreeObject('EDIT^Summary being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Summary being edited^^^^^^^^^^^%^0';
    end
  else
    tmpNode.DeleteChildren;
  x := lstSumms.Items[lstSumms.ItemIndex];
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  tmpNode := tvSumms.Items.AddChildObjectFirst(tmpNode, MakeDCSummDisplayText(x), MakeDCSummTreeObject(x));
  TORTreeNode(tmpNode).StringData := x;
  if CompareText(Copy(FEditDCSumm.TitleName, 1, 8), 'Addendum') <> 0 then
    tmpNode.ImageIndex := IMG_SINGLE
  else
    tmpNode.ImageIndex := IMG_ADDENDUM;
  tmpNode.SelectedIndex := tmpNode.ImageIndex;
  tvSumms.Selected := tmpNode;
  tvSumms.Items.EndUpdate;
  uChanging := False;

  uPCEEdit.NoteDateTime := MakeFMDateTime(Piece(lstSumms.Items[lstSumms.ItemIndex], U, 3));
  uPCEEdit.PCEForNote(lstSumms.ItemIEN, uPCEShow);
  FEditDCSumm.NeedCPT := uPCEEdit.CPTRequired;
  cmdChangeClick(Self); // will set captions, sign state for Changes
  lstSummsClick(Self);  // will make pnlWrite visible
  if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
  memNewSumm.SetFocus;
end;

function TfrmDCSumm.TitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a Summ given the ItemIndex in lstSumms }
begin
  with lstSumms do
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(Items[AnIndex], U, 3))) +
              ' ' + Piece(Items[AnIndex], U, 2);
end;

procedure TfrmDCSumm.SaveEditedSumm(var Saved: Boolean);
{ validates fields and sends the updated Summ to the server }
var
  UpdatedSumm: TCreatedDoc;
  x: string;
begin
  Saved := False;
  if (memNewSumm.GetTextLen = 0) or (not ContainsVisibleChar(memNewSumm.Text)) then
  begin
    lstSumms.ItemIndex := EditingIndex;
    x := lstSumms.ItemID;
    uChanging := True;
    tvSumms.Selected := tvSumms.FindPieceNode(x, 1, U, tvSumms.Items.GetFirstNode);
    uChanging := False;
    tvSummsChange(Self, tvSumms.Selected);
    if FSilent or
       ((not FSilent) and
      (InfoBox(GetTitleText(EditingIndex) + TX_EMPTY_SUMM, TC_EMPTY_SUMM, MB_YESNO) = IDYES))
    then
    begin
      FConfirmed := True;
      mnuActDeleteClick(Self);
      Saved := True;
      FDeleted := True;
    end
    else
      FConfirmed := False;
    Exit;
  end;
  //ExpandTabsFilter(memNewSumm.Lines, TAB_STOP_CHARS);
  with FEditDCSumm do
    begin
      if (Attending = 0) and (not FSilent) then
        begin
          InfoBox(TX_MISSING_FIELDS, TC_MISSING_FIELDS,MB_OK);
          cmdChangeClick(mnuActSave);
          Exit;
        end;
      NeedCPT            := uPCEEdit.CPTRequired;     {*RAB*}
      Lines              := memNewSumm.Lines;
      if RequireMASVerification(lstSumms.GetIEN(EditingIndex), TYP_DC_SUMM) then
         Status := TIU_ST_UNVER;
      (*if (User.DUZ <> Dictator) and (User.DUZ <> Attending) and*)   //ALL USERS??
      if RequireRelease(lstSumms.GetIEN(EditingIndex), TYP_DC_SUMM) then
        begin
          if not FSilent then
            begin
              if InfoBox(TX_RELEASE, TC_RELEASE, MB_YESNO) = IDNO then
                Status := TIU_ST_UNREL;
            end
          else          // always save as unreleased on timeout
            Status := TIU_ST_UNREL;
        end;
    end;
  timAutoSave.Enabled := False;
  try
    PutEditedDCSumm(UpdatedSumm, FEditDCSumm, lstSumms.GetIEN(EditingIndex));
  finally
    timAutoSave.Enabled := True;
  end;
  if UpdatedSumm.IEN > 0 then
  begin
    if (FEditDCSumm.Status in [TIU_ST_UNREL, TIU_ST_UNVER]) then
      begin
        Changes.Remove(CH_SUM, IntToStr(UpdatedSumm.IEN)); // DON'T REPROMPT ON PATIENT CHANGE
        UnlockDocument(UpdatedSumm.IEN);                   // Unlock only if UNRELEASED or UNVERIFIED
      end;
    // otherwise, there's no unlocking here since the note is still in Changes after a save
    if lstSumms.ItemIndex = EditingIndex then
    begin
      EditingIndex := -1;
      lstSummsClick(Self);
    end;
    EditingIndex := -1; // make sure EditingIndex reset even if not viewing edited note
    Saved := True;
    FChanged := False;
  end else
  begin
    if not FSilent then
      InfoBox(TX_SAVE_ERROR1 + UpdatedSumm.ErrorText + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmDCSumm.SaveCurrentSumm(var Saved: Boolean);
{ called whenever a Summ should be saved - uses IEN to call appropriate save logic }
begin
  if EditingIndex < 0 then Exit;
  SaveEditedSumm(Saved);
end;

{ Form events ------------------------------------------------------------------------------ }

procedure TfrmDCSumm.pnlRightResize(Sender: TObject);
{ memSumm (TRichEdit) doesn't repaint appropriately unless its parent panel is refreshed }
begin
  inherited;
  pnlRight.Refresh;
  memSumm.Repaint;
end;

procedure TfrmDCSumm.pnlWriteResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memNewSumm, MAX_ENTRY_WIDTH - 1);
  memNewSumm.Constraints.MinWidth := TextWidthByFont(memNewSumm.Font.Handle, StringOfChar('X', MAX_ENTRY_WIDTH)) + (LEFT_MARGIN * 2) + ScrollBarWidth;
  pnlLeft.Width := self.ClientWidth - pnlWrite.Width - sptHorz.Width;
end;

{ Left panel (selector) events ------------------------------------------------------------- }

procedure TfrmDCSumm.lstSummsClick(Sender: TObject);
{ loads the text for the selected Summ or displays the editing panel for the selected Summ }
var
  x: string;
begin
  inherited;
  with lstSumms do if ItemIndex = -1 then Exit
  else if ItemIndex = EditingIndex then
  begin
    pnlWrite.Visible := True;
    pnlRead.Visible := False;
    mnuViewDetail.Enabled := False;
    mnuActChange.Enabled     := True;
    mnuActLoadBoiler.Enabled := True;
  end else
  begin
    StatusText('Retrieving selected Discharge Summary...');
    Screen.Cursor := crHourGlass;
    pnlRead.Visible := True;
    pnlWrite.Visible := False;
    lblTitle.Caption := MakeDCSummDisplayText(Items[ItemIndex]);
    lvSumms.Caption := lblTitle.Caption;
    lblTitle.Hint := lblTitle.Caption;
    //lblTitle.Caption := Piece(DisplayText[ItemIndex], #9, 1) + '  ' + Piece(DisplayText[ItemIndex], #9, 2);
    LoadDocumentText(memSumm.Lines, ItemIEN);
    memSumm.SelStart := 0;
    mnuViewDetail.Enabled := True;
    mnuViewDetail.Checked    := False;
    mnuActChange.Enabled     := False;
    mnuActLoadBoiler.Enabled := False;
    Screen.Cursor := crDefault;
    StatusText('');
  end;
  DisplayPCE;
  pnlRight.Refresh;
  memNewSumm.Repaint;
  memSumm.Repaint;
  x := 'TIU^' + lstSumms.ItemID;
  SetPiece(x, U, 10, Piece(lstSumms.Items[lstSumms.ItemIndex], U, 11));
  NotifyOtherApps(NAE_REPORT, x);
end;

procedure TfrmDCSumm.cmdNewSummClick(Sender: TObject);
{ maps 'New Summ' button to the New Discharge Summary menu item }
begin
  inherited;
  mnuActNewClick(Self);
end;

procedure TfrmDCSumm.cmdPCEClick(Sender: TObject);
begin
  inherited;
  cmdPCE.Enabled := False;
  UpdatePCE(uPCEEdit);
  cmdPCE.Enabled := True;
  if frmFrame.Closing then exit;
  DisplayPCE;
end;

procedure TfrmDCSumm.cmdOrdersClick(Sender: TObject);
begin
  inherited;
  { call add orders here }
end;

{ Right panel (editor) events -------------------------------------------------------------- }

procedure TfrmDCSumm.memNewSummChange(Sender: TObject);
{ sets FChanged to record that the Summ has really been edited }
begin
  inherited;
  FChanged := True;
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmDCSumm.mnuViewClick(Sender: TObject);
{ changes the list of Summs available for viewing }
var
  AuthCtxt: TAuthorContext;
  DateRange: TNoteDateRange;
  Saved: Boolean;
begin
  inherited;
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
  end;
  FLastSummID := lstSumms.ItemID;
  StatusText('Retrieving Discharge Summary list...');
  mnuViewDetail.Checked := False;
  if Sender is TMenuItem then ViewContext := TMenuItem(Sender).Tag
    else if FCurrentContext.Status <> '' then ViewContext := NC_CUSTOM
    else ViewContext := NC_RECENT;
  case ViewContext of
  NC_RECENT:     begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblSumms.Caption := 'Last ' + IntToStr(ReturnMaxDCSumms) + ' Summaries';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   FCurrentContext.MaxDocs := ReturnMaxDCSumms;
                   LoadSumms;
                 end;
  NC_ALL:        begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblSumms.Caption := 'All Signed Summaries';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadSumms;
                 end;
  NC_UNSIGNED:   begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblSumms.Caption := 'Unsigned Summaries';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadSumms;
                 end;
  NC_UNCOSIGNED: begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblSumms.Caption := 'Uncosigned Summaries';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadSumms;
                 end;
  NC_BY_AUTHOR:  begin
                   SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
                   with AuthCtxt do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblSumms.Caption := AuthorName + ': Signed Summaries';
                     FCurrentContext.Status := IntToStr(NC_BY_AUTHOR);
                     FCurrentContext.Author := Author;
                     FCurrentContext.TreeAscending := Ascending;
                     LoadSumms;
                   end;
                 end;
  NC_BY_DATE:    begin
                   SelectNoteDateRange(Font.Size, FCurrentContext, DateRange);
                   with DateRange do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblSumms.Caption := FormatFMDateTime('dddddd', FMBeginDate) + ' to ' +
                                         FormatFMDateTime('dddddd', FMEndDate) + ': Signed Summaries';
                     FCurrentContext.BeginDate     := BeginDate;
                     FCurrentContext.EndDate       := EndDate;
                     FCurrentContext.FMBeginDate   := FMBeginDate;
                     FCurrentContext.FMEndDate     := FMEndDate;
                     FCurrentContext.TreeAscending := Ascending;
                     FCurrentContext.Status := IntToStr(NC_BY_DATE);
                     LoadSumms;
                   end;
                 end;
  NC_CUSTOM:     begin
                   if Sender is TMenuItem then
                     begin
                       SelectTIUView(Font.Size, True, FCurrentContext, uDCSummContext);
                       //lblSumms.Caption := 'Custom List';
                     end;
                   with uDCSummContext do if Changed then
                   begin
                     //if not (Sender is TMenuItem) then lblSumms.Caption := 'Default List';
                     //if MaxDocs = 0 then MaxDocs := ReturnMaxNotes;
                     FCurrentContext.BeginDate     := BeginDate;
                     FCurrentContext.EndDate       := EndDate;
                     FCurrentContext.FMBeginDate   := FMBeginDate;
                     FCurrentContext.FMEndDate     := FMEndDate;
                     FCurrentContext.Status        := Status;
                     FCurrentContext.Author        := Author;
                     FCurrentContext.MaxDocs       := MaxDocs;
                     FCurrentContext.ShowSubject   := ShowSubject;
                     // NEW PREFERENCES:
                     FCurrentContext.SortBy        := SortBy;
                     FCurrentContext.ListAscending := ListAscending;
                     FCurrentContext.GroupBy       := GroupBy;
                     FCurrentContext.TreeAscending := TreeAscending;
                     FCurrentContext.SearchField   := SearchField;
                     FCurrentContext.Keyword       := Keyword;
                     FCurrentContext.Filtered      := Filtered;
                     LoadSumms;
                   end;
                 end;
  end; {case}
  lblSumms.Caption := SetSummTreeLabel(FCurrentContext);
  lblSumms.hint := lblSumms.Caption;
  tvSumms.Caption := lblSumms.Caption;
  StatusText('');
end;

{ Action menu events ----------------------------------------------------------------------- }

function TfrmDCSumm.StartNewEdit(NewNoteType: integer): Boolean;
{ if currently editing a note, returns TRUE if the user wants to start a new one }
var
  Saved: Boolean;
  Msg, CapMsg: string;
begin
  Result := True;
  if EditingIndex > -1 then
  begin
    case NewNoteType of
      DC_ACT_ADDENDUM:  begin
                          Msg := TX_NEW_SAVE1 + MakeDCSummDisplayText(lstSumms.Items[EditingIndex]) + TX_NEW_SAVE3;
                          CapMsg := TC_NEW_SAVE3;
                        end;
      DC_ACT_EDIT_SUMM: begin
                          Msg := TX_NEW_SAVE1 + MakeDCSummDisplayText(lstSumms.Items[EditingIndex]) + TX_NEW_SAVE4;
                          CapMsg := TC_NEW_SAVE4;
                        end;
      DC_ACT_ID_ENTRY:  begin
                          Msg := TX_NEW_SAVE1 + MakeDCSummDisplayText(lstSumms.Items[EditingIndex]) + TX_NEW_SAVE5;
                          CapMsg := TC_NEW_SAVE5;
                        end;
    else
      begin
        Msg := TX_NEW_SAVE1 + MakeDCSummDisplayText(lstSumms.Items[EditingIndex]) + TX_NEW_SAVE2;
        CapMsg := TC_NEW_SAVE2;
      end;
    end;

    if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then Result := False
    else
      begin
        SaveCurrentSumm(Saved);
        if not Saved then Result := False else LoadSumms;
      end;
  end;
end;

procedure TfrmDCSumm.mnuActNewClick(Sender: TObject);
const
  IS_ID_CHILD = False;
{ switches to current new Summ or creates a new Summ if none is being edited already }
begin
  inherited;
  if not StartNewEdit(DC_ACT_NEW_SUMM) then Exit;
  //LoadSumms;
  // a visit (time & location) need not be available before creating the summary,
  // since an admission will be prompted for to link the summary to.  (REV - v14d)
(*  if Encounter.NeedVisit then
  begin
    UpdateVisit(Font.Size);
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then
  begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    Exit;
  end;*)

  InsertNewSumm(IS_ID_CHILD, 0);
end;

procedure TfrmDCSumm.mnuActAddIDEntryClick(Sender: TObject);
const
  IS_ID_CHILD = True;
var
  AnIDParent: integer;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  AnIDParent := lstSumms.ItemIEN;
  if not StartNewEdit(DC_ACT_ID_ENTRY) then Exit;
  //LoadSumms;
  with tvSumms do Selected := FindPieceNode(IntToStr(AnIDParent), U, Items.GetFirstNode);
  // make sure a visit (time & location) is available before creating the note
  if Encounter.NeedVisit then
  begin
    UpdateVisit(Font.Size, DfltTIULocation);
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then
  begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  InsertNewSumm(IS_ID_CHILD, AnIDParent);
end;

procedure TfrmDCSumm.mnuActAddendClick(Sender: TObject);
{ make an addendum to an existing Summ }
var
  ActionSts: TActionRec;
  ASummID: string;
begin
  inherited;
  if NoSummSelected() then Exit;
  ASummID := lstSumms.ItemID;
  if not StartNewEdit(DC_ACT_ADDENDUM) then Exit;
  //LoadSumms;
  with tvSumms do Selected := FindPieceNode(ASummID, 1, U, Items.GetFirstNode);
  if lstSumms.ItemIndex = EditingIndex then
  begin
    InfoBox(TX_ADDEND_NO, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  ActOnDCDocument(ActionSts, lstSumms.ItemIEN, 'MAKE ADDENDUM');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  with lstSumms do if TitleForNote(ItemIEN) = TYP_ADDENDUM then    //v17.5  RV
  //with lstSumms do if Copy(Piece(Items[ItemIndex], U, 2), 1, 8) = 'Addendum' then
  begin
    InfoBox(TX_ADDEND_AD, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  FEditDCSumm.DischargeDateTime := FMNow;
  InsertAddendum;
end;

procedure TfrmDCSumm.mnuActDetachFromIDParentClick(Sender: TObject);
var
  DocID, WhyNot: string;
  Saved: boolean;
  SavedDocID: string;
begin
  if lstSumms.ItemIEN = 0 then exit;
  SavedDocID := lstSumms.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
    LoadSumms;
    with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if not CanBeAttached(PDocTreeObject(tvSumms.Selected.Data)^.DocID, WhyNot) then
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
      Exit;
    end;
  if (InfoBox('DETACH:   ' + tvSumms.Selected.Text + CRLF +  CRLF +
              '  FROM:   ' + tvSumms.Selected.Parent.Text + CRLF + CRLF +
              'Are you sure?', TX_DETACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
      then Exit;
  DocID := PDocTreeObject(tvSumms.Selected.Data)^.DocID;
  SavedDocID := PDocTreeObject(tvSumms.Selected.Parent.Data)^.DocID;
  if DetachEntryFromParent(DocID, WhyNot) then
    begin
      LoadSumms;
      with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
      if tvSumms.Selected <> nil then tvSumms.Selected.Expand(False);
    end
  else
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
    end;
end;


procedure TfrmDCSumm.mnuActSignListClick(Sender: TObject);
{ add the Summ to the Encounter object, see mnuActSignClick - copied}
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  ActionType, SignTitle: string;
  ActionSts: TActionRec;
begin
  inherited;
  if NoSummSelected() then Exit;
  if lstSumms.ItemIndex = EditingIndex then Exit;  // already in signature list
  if not NoteHasText(lstSumms.ItemIEN) then
    begin
      InfoBox(TX_EMPTY_SUMM1, TC_EMPTY_SUMM, MB_OK or MB_ICONERROR);
      Exit;
    end;
  if not LastSaveClean(lstSumms.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(lstSumms.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  ActOnDCDocument(ActionSts, lstSumms.ItemIEN, ActionType);
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LockSumm(lstSumms.ItemIEN);
  with lstSumms do Changes.Add(CH_SUM, ItemID, TitleText(ItemIndex), '', CH_SIGN_YES);
end;

procedure TfrmDCSumm.RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
begin
  if IEN = DC_ADDENDUM then Exit;  // no PCE information entered for an addendum
  // do we need to call DeletePCE(AVisitStr), as was done with NT_NEW_NOTE (ien=-10)???
  if AVisitStr = '' then AVisitStr := VisitStrForNote(IEN);
  Changes.Remove(CH_PCE, 'V' + AVisitStr);
  Changes.Remove(CH_PCE, 'P' + AVisitStr);
  Changes.Remove(CH_PCE, 'D' + AVisitStr);
  Changes.Remove(CH_PCE, 'I' + AVisitStr);
  Changes.Remove(CH_PCE, 'S' + AVisitStr);
  Changes.Remove(CH_PCE, 'A' + AVisitStr);
  Changes.Remove(CH_PCE, 'H' + AVisitStr);
  Changes.Remove(CH_PCE, 'E' + AVisitStr);
  Changes.Remove(CH_PCE, 'T' + AVisitStr);
end;


procedure TfrmDCSumm.mnuActDeleteClick(Sender: TObject);
{ delete the selected progress note & remove from the Encounter object if necessary }
var
  DeleteSts, ActionSts: TActionRec;
  ReasonForDelete, AVisitStr, SavedDocID: string;
  Saved: boolean;
  SavedDocIEN: integer;
begin
  inherited;
  if NoSummSelected() then Exit;
  ActOnDocument(ActionSts, lstSumms.ItemIEN, 'DELETE RECORD');
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(lstSumms.ItemIEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  // suppress prompt for deletion when called from SaveEditedNote (Sender = Self)
  if (Sender <> Self) and (InfoBox(MakeDCSummDisplayText(lstSumms.Items[lstSumms.ItemIndex]) + TX_DEL_OK,
    TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
  // do the appropriate locking
  if not LockSumm(lstSumms.ItemIEN) then Exit;
    // retraction notification message
  if JustifyDocumentDelete(lstSumms.ItemIEN) then
     InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  SavedDocID := lstSumms.ItemID;
  SavedDocIEN := lstSumms.ItemIEN;
  if (EditingIndex > -1) and (not FConfirmed) and (lstSumms.ItemIndex <> EditingIndex) and (memNewSumm.GetTextLen > 0) then
    begin
      SaveCurrentSumm(Saved);
      if not Saved then Exit;
    end;
  EditingIndex := -1;
  FConfirmed := False;
(*  if Saved then
    begin
      EditingIndex := -1;
      mnuViewClick(Self);
      with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
   end;*)
  // remove the note
  DeleteSts.Success := True;
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstSumms.ItemIEN = SavedDocIEN) then DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_SUM, SavedDocID) then UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_SUM, SavedDocID);  // this will unlock the document if in Changes
  // reset the display now that the note is gone
  if DeleteSts.Success then
  begin
    DeletePCE(AVisitStr);  // removes PCE data if this was the only note pointing to it
    ClearEditControls;
    //ClearPtData;   WRONG - fixed in v15.10 - RV
    LoadSumms;
(*    with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    if tvSumms.Selected <> nil then tvSummsChange(Self, tvSumms.Selected) else
    begin*)
      pnlWrite.Visible := False;
      pnlRead.Visible := True;
      UpdateReminderFinish;
      ShowPCEControls(False);
      frmDrawers.DisplayDrawers(FALSE);
      cmdNewSumm.Visible := TRUE;
      cmdPCE.Visible := FALSE;
      popSummMemoEncounter.Visible := cmdPCE.Visible;
      lblSpace1.Top := cmdNewSumm.Top - lblSpace1.Height;
//    end; {if ItemIndex}
  end {if DeleteSts}
  else InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
end;

procedure TfrmDCSumm.mnuActEditClick(Sender: TObject);
{ load the selected Discharge Summary for editing }
var
  ActionSts: TActionRec;
  ASummID: string;
begin
  inherited;
  if NoSummSelected() then Exit;
  if lstSumms.ItemIndex = EditingIndex then Exit;
  ASummID := lstSumms.ItemID;
  if not StartNewEdit(DC_ACT_EDIT_SUMM) then Exit;
  //LoadSumms;
  with tvSumms do Selected := FindPieceNode(ASummID, 1, U, Items.GetFirstNode);
  ActOnDCDocument(ActionSts, lstSumms.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LoadForEdit(False);
end;

procedure TfrmDCSumm.mnuActSaveClick(Sender: TObject);
{ saves the Summ that is currently being edited }
var
  Saved: Boolean;
  SavedDocID: string;
begin
  inherited;
  if EditingIndex > -1 then
    begin
      SavedDocID := Piece(lstSumms.Items[EditingIndex], U, 1);
      FLastSummID := SavedDocID;
      SaveCurrentSumm(Saved);
      if Saved and (EditingIndex < 0) and (not FDeleted) then
      //if Saved then
        begin
          LoadSumms;
          with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
       end;
    end
    else InfoBox(TX_NO_NOTE, TX_SAVE_NOTE, MB_OK or MB_ICONWARNING);
end;

procedure TfrmDCSumm.mnuActSignClick(Sender: TObject);
{ sign the currently selected Summ, save first if necessary }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  Saved, SummUnlocked: Boolean;
  ActionType, ESCode, SignTitle: string;
  ActionSts, SignSts: TActionRec;
  OK: boolean;
  SavedDocID, tmpItem: string;
  EditingID: string;                                         //v22.12 - RV
  tmpNode: TTreeNode;
begin
  inherited;
  if NoSummSelected() then Exit;
(*  if lstSumms.ItemIndex = EditingIndex then                //v22.12 - RV
  begin                                                      //v22.12 - RV
    SaveCurrentSumm(Saved);                                  //v22.12 - RV
    if (not Saved) or FDeleted then Exit;                    //v22.12 - RV
  end                                                        //v22.12 - RV
  else if EditingIndex > -1 then                             //v22.12 - RV
    tmpItem := lstSumms.Items[EditingIndex];                 //v22.12 - RV
  SavedDocID := lstSumms.ItemID;*)                           //v22.12 - RV
  SavedDocID := lstSumms.ItemID;                             //v22.12 - RV
  FLastSummID := SavedDocID;                                 //v22.12 - RV
  if lstSumms.ItemIndex = EditingIndex then                  //v22.12 - RV
  begin                                                      //v22.12 - RV
    SaveCurrentSumm(Saved);                                  //v22.12 - RV
    if (not Saved) or FDeleted then Exit;                    //v22.12 - RV
  end                                                        //v22.12 - RV
  else if EditingIndex > -1 then                             //v22.12 - RV
  begin                                                      //v22.12 - RV
    tmpItem := lstSumms.Items[EditingIndex];                 //v22.12 - RV
    EditingID := Piece(tmpItem, U, 1);                       //v22.12 - RV
  end;                                                       //v22.12 - RV
  if not NoteHasText(lstSumms.ItemIEN) then
    begin
      InfoBox(TX_EMPTY_SUMM1, TC_EMPTY_SUMM, MB_OK or MB_ICONERROR);
      Exit;
    end;
  if not LastSaveClean(lstSumms.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(lstSumms.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  if not LockSumm(lstSumms.ItemIEN) then Exit;
  // no exits after things are locked
  SummUnlocked := False;
  ActOnDCDocument(ActionSts, lstSumms.ItemIEN, ActionType);
  if ActionSts.Success then
  begin
    OK := IsOK2Sign(uPCEShow, lstSumms.ItemIEN);
    if frmFrame.Closing then exit;
    if(uPCEShow.Updated) then
    begin
      uPCEShow.CopyPCEData(uPCEEdit);
      uPCEShow.Updated := FALSE;
      lstSummsClick(Self);
    end;
    if not AuthorSignedDocument(lstSumms.ItemIEN) then
    begin
      if (InfoBox(TX_AUTH_SIGNED +
          GetTitleText(lstSumms.ItemIndex),TX_SIGN ,MB_YESNO)= ID_NO) then exit;
    end;
    if(OK) then
    begin                                       
      with lstSumms do SignatureForItem(Font.Size, MakeDCSummDisplayText(Items[ItemIndex]), SignTitle, ESCode);
      if Length(ESCode) > 0 then
      begin
        SignDCDocument(SignSts, lstSumms.ItemIEN, ESCode);
        RemovePCEFromChanges(lstSumms.ItemIEN);
        SummUnlocked := Changes.Exist(CH_SUM, lstSumms.ItemID);
        Changes.Remove(CH_SUM, lstSumms.ItemID);
        if SignSts.Success
          then lstSummsClick(Self)
          else InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end  {if Length(ESCode)}
      else
        SummUnlocked := Changes.Exist(CH_SUM, lstSumms.ItemID);
    end;
  end
  else InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  if not SummUnlocked then UnlockDocument(lstSumms.ItemIEN);
  //SetViewContext(FCurrentContext);  //v22.12 - RV
  LoadSumms;                          //v22.12 - RV
  //if EditingIndex > -1 then         //v22.12 - RV
  if (EditingID <> '') then           //v22.12 - RV
    begin
      lstSumms.Items.Insert(0, tmpItem);
      tmpNode := tvSumms.Items.AddObjectFirst(tvSumms.Items.GetFirstNode, 'Summary being edited',
                 MakeDCSummTreeObject('EDIT^Summary being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Summary being edited^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvSumms.Items.AddChildObjectFirst(tmpNode, MakeDCSummDisplayText(tmpItem), MakeDCSummTreeObject(tmpItem));
      TORTreeNode(tmpNode).StringData := tmpItem;
      SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext, CT_DCSUMM);
      EditingIndex := lstSumms.SelectByID(EditingID);                 //v22.12 - RV
    end;
  //with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);  //v22.12 - RV
  with tvSumms do                                                                  //v22.12 - RV
  begin                                                                            //v22.12 - RV
    Selected := FindPieceNode(FLastSummID, U, Items.GetFirstNode);                 //v22.12 - RV
    if Selected <> nil then tvSummsChange(Self, Selected);                         //v22.12 - RV
  end;                                                                             //v22.12 - RV
end;

procedure TfrmDCSumm.SaveSignItem(const ItemID, ESCode: string);
{ saves and optionally signs a Discharge Summary or addendum }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  AnIndex, IEN, i: Integer;
  Saved, ContinueSign: Boolean;   {*RAB* 8/26/99}
  ActionSts, SignSts: TActionRec;
  APCEObject: TPCEData;
  OK: boolean;
  ActionType, SignTitle: string;
begin
  AnIndex := -1;
  IEN := StrToIntDef(ItemID, 0);
  if IEN = 0 then Exit;
  if frmFrame.TimedOut and (EditingIndex <> -1) then FSilent := True;
  with lstSumms do for i := 0 to Items.Count - 1 do if lstSumms.GetIEN(i) = IEN then
  begin
    AnIndex := i;
    break;
  end;
  if (AnIndex > -1) and (AnIndex = EditingIndex) then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
    if FDeleted then
      begin
        FDeleted := False;
        Exit;
      end;
    AnIndex := lstSumms.SelectByIEN(IEN);
    //IEN := lstNotes.GetIEN(AnIndex);                    // saving will change IEN
  end;
  if Length(ESCode) > 0 then
  begin
    if CosignDocument(IEN) then
    begin
      SignTitle := TX_COSIGN;
      ActionType := SIG_COSIGN;
    end else
    begin
      SignTitle := TX_SIGN;
      ActionType := SIG_SIGN;
    end;
    ActOnDocument(ActionSts, IEN, ActionType);
    if not ActionSts.Success then
      begin
        InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
        ContinueSign := False;
      end
    else if not NoteHasText(IEN) then
      begin
        InfoBox(TX_EMPTY_SUMM1, TC_EMPTY_SUMM, MB_OK or MB_ICONERROR);
        ContinueSign := False;
      end
    else if not LastSaveClean(IEN) and
      (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES)
       then ContinueSign := False
    else ContinueSign := True;
    if ContinueSign then
    begin
      if (AnIndex >= 0) and (AnIndex = lstSumms.ItemIndex) then
        APCEObject := uPCEShow
      else
        APCEObject := nil;
      OK := IsOK2Sign(APCEObject, IEN);
      if frmFrame.Closing then exit;
      if(assigned(APCEObject)) and (uPCEShow.Updated) then
      begin
        uPCEShow.CopyPCEData(uPCEEdit);
        uPCEShow.Updated := FALSE;
        lstSummsClick(Self);
      end
      else
        uPCEEdit.Clear;
      if(OK) then
      begin
        SignDocument(SignSts, IEN, ESCode);
        if not SignSts.Success then InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; {if OK}
    end; {if ContinueSign}
  end; {if Length(ESCode)}

  if (AnIndex = lstSumms.ItemIndex) and (not frmFrame.ContextChanging) then
    begin
      LoadSumms;
      with tvSumms do Selected := FindPieceNode(IntToStr(IEN), U, Items.GetFirstNode);
    end;
end;

procedure TfrmDCSumm.popSummMemoPopup(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popSummMemo) is TCustomEdit
    then FEditCtrl := TCustomEdit(PopupComponent(Sender, popSummMemo))
    else FEditCtrl := nil;
  if FEditCtrl <> nil then
  begin
    popSummMemoCut.Enabled      := FEditCtrl.SelLength > 0;
    popSummMemoCopy.Enabled     := popSummMemoCut.Enabled;
    popSummMemoPaste.Enabled    := (not TORExposedCustomEdit(FEditCtrl).ReadOnly) and
                                   Clipboard.HasFormat(CF_TEXT);
    popSummMemoTemplate.Enabled := frmDrawers.CanEditTemplates and popSummMemoCut.Enabled;
    popSummMemoFind.Enabled     := FEditCtrl.GetTextLen > 0;
  end else
  begin
    popSummMemoCut.Enabled      := False;
    popSummMemoCopy.Enabled     := False;
    popSummMemoPaste.Enabled    := False;
    popSummMemoTemplate.Enabled := False;
  end;
  if pnlWrite.Visible then
  begin
    popSummMemoSpell.Enabled   := True;
    popSummMemoGrammar.Enabled := True;
    popSummMemoReformat.Enabled := True;
    popSummMemoReplace.Enabled  := (FEditCtrl.GetTextLen > 0);
    popSummMemoPreview.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
    popSummMemoInsTemplate.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
  end else
  begin
    popSummMemoSpell.Enabled   := False;
    popSummMemoGrammar.Enabled := False;
    popSummMemoReformat.Enabled := False;
    popSummMemoReplace.Enabled := False;
    popSummMemoPreview.Enabled  := False;
    popSummMemoInsTemplate.Enabled  := False;
  end;
end;

procedure TfrmDCSumm.popSummMemoCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmDCSumm.popSummMemoCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmDCSumm.popSummMemoPasteClick(Sender: TObject);
begin
  inherited;
  //FEditCtrl.SelText := Clipboard.AsText; {*KCM*}
  ScrubTheClipboard;
  FEditCtrl.PasteFromClipboard;        // use AsText to prevent formatting
end;

procedure TfrmDCSumm.popSummMemoReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memNewSumm then Exit;
  ReformatMemoParagraph(memNewSumm);
end;

procedure TfrmDCSumm.popSummMemoFindClick(Sender: TObject);
begin
  inherited;
  SendMessage(TRichEdit(popSummMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgFindText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      Options := [frDown, frHideUpDown];
      Execute;
    end;
end;

procedure TfrmDCSumm.dlgFindTextFind(Sender: TObject);
begin
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popSummMemo.PopupComponent));
end;

procedure TfrmDCSumm.popSummMemoReplaceClick(Sender: TObject);
begin
  inherited;
  SendMessage(TRichEdit(popSummMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgReplaceText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      ReplaceText := '';
      Options := [frDown, frHideUpDown];
      Execute;
    end;
end;

procedure TfrmDCSumm.dlgReplaceTextReplace(Sender: TObject);
begin
  inherited;
  dmodShared.ReplaceRichEditText(dlgReplaceText, TRichEdit(popSummMemo.PopupComponent));
end;

procedure TfrmDCSumm.dlgReplaceTextFind(Sender: TObject);
begin
  inherited;
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popSummMemo.PopupComponent));
end;

procedure TfrmDCSumm.popSummMemoSpellClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    SpellCheckForControl(memNewSumm);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmDCSumm.popSummMemoGrammarClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    GrammarCheckForControl(memNewSumm);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmDCSumm.FormCreate(Sender: TObject);
begin
  inherited;
  PageID := CT_DCSUMM;
  FDischargeDate := FMNow;
  EditingIndex := -1;
  FEditDCSumm.LastCosigner := 0;
  FEditDCSumm.LastCosignerName := '';
  FLastSummID := '';
  frmDrawers := TfrmDrawers.CreateDrawers(Self, pnlDrawers, [],[]);
  frmDrawers.Align := alBottom;
  frmDrawers.RichEditControl := memNewSumm;
  frmDrawers.Splitter := splDrawers;
  frmDrawers.DefTempPiece := 3;
  FImageFlag := TBitmap.Create;
  FDocList := TStringList.Create;
end;

procedure TfrmDCSumm.mnuViewDetailClick(Sender: TObject);
begin
  inherited;
  if lstSumms.ItemIEN <= 0 then Exit;
  mnuViewDetail.Checked := not mnuViewDetail.Checked;
  if mnuViewDetail.Checked then
    begin
      StatusText('Retrieving discharge summary details...');
      Screen.Cursor := crHourGlass;
      LoadDetailText(memSumm.Lines, lstSumms.ItemIEN);
      Screen.Cursor := crDefault;
      StatusText('');
      memSumm.SelStart := 0;
      memSumm.Repaint;
    end
  else
    lstSummsClick(Self);
  SendMessage(memSumm.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TfrmDCSumm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Saved: Boolean;
  IEN: Int64;
  ErrMsg: string;
  DeleteSts: TActionRec;
begin
  inherited;
  if frmFrame.TimedOut and (EditingIndex <> -1) then
  begin
    FSilent := True;
    if memNewSumm.GetTextLen > 0 then SaveCurrentSumm(Saved)
    else
    begin
      IEN := lstSumms.GetIEN(EditingIndex);
      if not LastSaveClean(IEN) then             // means note hasn't been committed yet
      begin
        LockDocument(IEN, ErrMsg);
        if ErrMsg = '' then
        begin
          DeleteDocument(DeleteSts, IEN, '');
          UnlockDocument(IEN);
        end; {if ErrMsg}
      end; {if not LastSaveClean}
    end; {else}
  end; {if frmFrame}
end;

procedure TfrmDCSumm.mnuActIdentifyAddlSignersClick(Sender: TObject);
var
  Exclusions: TStrings;
  Saved, x, y: boolean;
  SignerList: TSignerList;
  ActionSts: TActionRec;
  SigAction: integer;
  SavedDocID: string;
  ARefDate: TFMDateTime;
begin
  inherited;
  if NoSummSelected() then Exit;
  if lstSumms.ItemIndex = EditingIndex then
    begin
      SaveCurrentSumm(Saved);
      if not Saved then Exit;
      LoadSumms;
      with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    end;
  x := CanChangeCosigner(lstSumms.ItemIEN);
  ActOnDocument(ActionSts, lstSumms.ItemIEN, 'IDENTIFY SIGNERS');
  y := ActionSts.Success;
  if x and not y then
    begin
      if InfoBox(ActionSts.Reason + CRLF + CRLF +
                 'Would you like to change the cosigner?',
                 TX_IN_AUTH, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES then
    	SigAction := SG_COSIGNER
      else
	Exit;
    end
  else if y and not x then SigAction := SG_ADDITIONAL
  else if x and y then SigAction := SG_BOTH
  else
    begin
      InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
      Exit;
    end;

//  NEED TO PREVENT CHANGE OF COSIGNER ON DC SUMMARIES?
{  if y then SigAction := SG_ADDITIONAL
    else
    begin
      InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
      Exit;
    end;  }

  Exclusions := GetCurrentSigners(lstSumms.ItemIEN);
  ARefDate := ExtractFloat(Piece(Piece(lstSumms.Items[lstSumms.ItemIndex], U, 9), ';', 2));
  if ARefDate = 0 then        //no discharge date, so use note date
    ARefDate := StrToFloat(Piece(lstSumms.Items[lstSumms.ItemIndex], U, 3));
  SelectAdditionalSigners(Font.Size, lstSumms.ItemIEN, SigAction, Exclusions, SignerList, CT_DCSUMM, ARefDate);
  with SignerList do
    begin
      case SigAction of
        SG_ADDITIONAL:  if Changed and (Signers <> nil) and (Signers.Count > 0) then
                          UpdateAdditionalSigners(lstSumms.ItemIEN, Signers);
        SG_COSIGNER:    if Changed then ChangeAttending(lstSumms.ItemIEN, Cosigner);
        SG_BOTH:        if Changed then
                          begin
                            if (Signers <> nil) and (Signers.Count > 0) then
                              UpdateAdditionalSigners(lstSumms.ItemIEN, Signers);
                            ChangeAttending(lstSumms.ItemIEN, Cosigner);
                          end;
      end;
      lstSummsClick(Self);
    end;
end;

procedure TfrmDCSumm.popSummMemoAddlSignClick(Sender: TObject);
begin
  inherited;
  mnuActIdentifyAddlSignersClick(Self);
end;

procedure TfrmDCSumm.ProcessNotifications;
var
  x: string;
  Saved: boolean;
  tmpNode: TTreeNode;
  AnObject: PDocTreeObject;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
  end;
  lblSumms.Caption := Notifications.Text;
  tvSumms.Caption := Notifications.Text;
  EditingIndex := -1;
  lstSumms.Enabled := True ;
  pnlRead.BringToFront ;
  x := Notifications.AlertData;
  //x := MakeDCSummListItem(Notifications.AlertData);
  if StrToIntDef(Piece(x, U, 1), 0) = 0 then
    begin
      InfoBox(TX_NO_ALERT, TX_CAP_NO_ALERT, MB_OK);
      Exit;
    end;
  uChanging := True;
  tvSumms.Items.BeginUpdate;
  lstSumms.Clear;
  KillDocTreeObjects(tvSumms);
  tvSumms.Items.Clear;
  lstSumms.Items.Add(x);
  AnObject := MakeDCSummTreeObject('ALERT^Alerted Note^^^^^^^^^^^%^0');
  tmpNode := tvSumms.Items.AddObjectFirst(tvSumms.Items.GetFirstNode, AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := 'ALERT^Alerted Note^^^^^^^^^^^%^0';
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  AnObject := MakeDCSummTreeObject(x);
  tmpNode := tvSumms.Items.AddChildObjectFirst(tmpNode, AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := x;
  SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext, CT_DCSUMM);
  tvSumms.Selected := tmpNode;
  tvSumms.Items.EndUpdate;
  uChanging := False;
  tvSummsChange(Self, tvSumms.Selected);
  case Notifications.Followup of
    NF_DCSUMM_UNSIGNED_NOTE:   ;  //Automatically deleted by sig action!!!
  end;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then Notifications.Delete;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then Notifications.Delete;
end;

procedure TfrmDCSumm.SetViewContext(AContext: TTIUContext);
var
  Saved: boolean;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
  end;
  EditingIndex := -1;
  tvSumms.Enabled := True ;
  pnlRead.BringToFront ;
  if AContext.Status <> '' then with uDCSummContext do
    begin
      BeginDate      := AContext.BeginDate;
      EndDate        := AContext.EndDate;
      FMBeginDate    := AContext.FMBeginDate;
      FMEndDate      := AContext.FMEndDate;
      Status         := AContext.Status;
      Author         := AContext.Author;
      MaxDocs        := AContext.MaxDocs;
      ShowSubject    := AContext.ShowSubject;
      GroupBy        := AContext.GroupBy;
      SortBy         := AContext.SortBy;
      ListAscending  := AContext.ListAscending;
      TreeAscending  := AContext.TreeAscending;
      Keyword        := AContext.Keyword;
      SearchField    := AContext.SearchField;
      Filtered       := AContext.Filtered;
      Changed        := True;
      mnuViewClick(Self);
    end
  else
    begin
      ViewContext := NC_RECENT ;
      mnuViewClick(Self);
    end;
end;

procedure TfrmDCSumm.mnuViewSaveAsDefaultClick(Sender: TObject);
const
  TX_NO_MAX =  'You have not specified a maximum number of summaries to be returned.' + CRLF +
               'If you save this preference, the result will be that ALL summaries for every' + CRLF +
               'patient will be saved as your default view.' + CRLF + CRLF +
               'For patients with large numbers of summaries, this could result in some lengthy' + CRLF +
               'delays in loading the list of summaries.' + CRLF + CRLF +
               'Are you sure you mean to do this?';
  TX_REPLACE = 'Replace current defaults?';
begin
  inherited;
  if FCurrentContext.MaxDocs = 0 then
     if InfoBox(TX_NO_MAX,'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
       begin
         mnuViewClick(mnuViewCustom);
         Exit;
       end;
  if InfoBox(TX_REPLACE,'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      SaveCurrentDCSummContext(FCurrentContext);
      FDefaultContext := FCurrentContext;
      //lblSumms.Caption := 'Default List';
    end;
end;

procedure TfrmDCSumm.mnuViewReturntoDefaultClick(Sender: TObject);
begin
  inherited;
  SetViewContext(FDefaultContext);
end;

procedure TfrmDCSumm.popSummMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, True, FEditCtrl.SelText);
end;

procedure TfrmDCSumm.popSummListPopup(Sender: TObject);
begin
  inherited;
  N5.Visible                          := (popSummList.PopupComponent is TORTreeView);
  popSummListExpandAll.Visible        := N5.Visible;
  popSummListExpandSelected.Visible   := N5.Visible;
  popSummListCollapseAll.Visible      := N5.Visible;
  popSummListCollapseSelected.Visible := N5.Visible;
end;

procedure TfrmDCSumm.popSummListExpandAllClick(Sender: TObject);
begin
  inherited;
  tvSumms.FullExpand;
end;

procedure TfrmDCSumm.popSummListCollapseAllClick(Sender: TObject);
begin
  inherited;
  tvSumms.Selected := nil;
  lvSumms.Items.Clear;
  memSumm.Clear;
  tvSumms.FullCollapse;
  tvSumms.Selected := tvSumms.TopItem;
end;

procedure TfrmDCSumm.popSummListExpandSelectedClick(Sender: TObject);
begin
  inherited;
  if tvSumms.Selected = nil then exit;
  with tvSumms.Selected do if HasChildren then Expand(True);
end;

procedure TfrmDCSumm.popSummListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if tvSumms.Selected = nil then exit;
  with tvSumms.Selected do if HasChildren then Collapse(True);
end;

procedure TfrmDCSumm.mnuNewTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, True);
end;

procedure TfrmDCSumm.mnuEditTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self);
end;

procedure TfrmDCSumm.mnuOptionsClick(Sender: TObject);
begin
  inherited;
  mnuEditTemplates.Enabled := frmDrawers.CanEditTemplates;
  mnuNewTemplate.Enabled := frmDrawers.CanEditTemplates;
  mnuEditSharedTemplates.Enabled := frmDrawers.CanEditShared;
  mnuNewSharedTemplate.Enabled := frmDrawers.CanEditShared;
  mnuEditDialgFields.Enabled := CanEditTemplateFields;
end;         

procedure TfrmDCSumm.mnuEditSharedTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, FALSE, '', TRUE);
end;

procedure TfrmDCSumm.mnuNewSharedTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, '', TRUE);
end;

procedure TfrmDCSumm.FormDestroy(Sender: TObject);
begin
  FImageFlag.Free;
  FDocList.Free;
  KillDocTreeObjects(tvSumms);
  inherited;
end;

function TfrmDCSumm.GetDrawers: TFrmDrawers;
begin
  Result := frmDrawers;
end;

procedure TfrmDCSumm.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
end;

(*function TfrmDCSumm.MakeTitleText(IsAddendum: Boolean = False): string;
{ returns display text for list box based on FEditNote }
begin
  Result := FormatFMDateTime('mmm dd,yy', FEditDCSumm.DischargeDateTime) + U;
  if IsAddendum and (CompareText(Copy(FEditDCSumm.TitleName, 1, 8), 'Addendum') <> 0)
    then Result := Result + 'Addendum to ';
  Result := Result + FEditDCSumm.TitleName + ', ' + FEditDCSumm.LocationName + ', ' +
            FEditDCSumm.DictatorName;
end;*)

function TfrmDCSumm.LacksRequiredForCreate: Boolean;
{ determines if the fields required to create the note are present }
var
  CurTitle: Integer;
  ADateTime:  TFMDateTime;
begin
  Result := False;
  with FEditDCSumm do
  begin
    if Title <= 0    then Result := True;
    if Dictator <= 0   then Result := True;
    if AdmitDateTime <= 0 then Result := True;
    if DischargeDateTime > 0 then
      ADateTime := DischargeDateTime
    else
      ADateTime := DictDateTime;
    if (DocType = TYP_ADDENDUM) then
    begin
      if AskCosignerForDocument(Addend, Dictator, ADateTime) and (Cosigner <= 0) then Result := True;
    end else
    begin
      if Title > 0 then CurTitle := Title else CurTitle := DocType;
      if AskCosignerForTitle(CurTitle, Dictator, ADateTime) and (Cosigner <= 0) then Result := True;
    end;
  end;
end;

function TfrmDCSumm.VerifySummTitle: Boolean;
const
  VNT_UNKNOWN = 0;
  VNT_NO      = 1;
  VNT_YES     = 2;
var
  AParam: string;
begin
  if FVerifySummTitle = VNT_UNKNOWN then
  begin
    AParam := GetUserParam('ORWOR VERIFY NOTE TITLE');
    if AParam = '1' then FVerifySummTitle := VNT_YES else FVerifySummTitle := VNT_NO;
  end;
  Result := FVerifySummTitle = VNT_YES;
end;

function TfrmDCSumm.LockSumm(AnIEN: Int64): Boolean;
{ returns true if summ successfully locked }
var
  LockMsg: string;
begin
  Result := True;
  if Changes.Exist(CH_SUM, IntToStr(AnIEN)) then Exit;  // already locked
  LockDocument(AnIEN, LockMsg);
  if LockMsg <> '' then
    begin
      Result := False;
      InfoBox(LockMsg, TC_NO_LOCK, MB_OK);
    end;
end;

procedure TfrmDCSumm.DoAutoSave(Suppress: integer = 1);
var
  ErrMsg: string;
begin
  if fFrame.frmFrame.DLLActive = True then Exit;  
  if (EditingIndex > -1) and FChanged then
  begin
    StatusText('Autosaving note...');
    //PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
    timAutoSave.Enabled := False;
    try
      SetText(ErrMsg, memNewSumm.Lines, lstSumms.GetIEN(EditingIndex), Suppress);
    finally
      timAutoSave.Enabled := True;
    end;
    FChanged := False;
    StatusText('');
  end;
  if ErrMsg <> '' then
    InfoBox(TX_SAVE_ERROR1 + ErrMsg + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  //Assert(ErrMsg = '', 'AutoSave: ' + ErrMsg);
end;

procedure TfrmDCSumm.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave;
end;

function TfrmDCSumm.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstSumms }
begin
  with lstSumms do
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(Items[AnIndex], U, 3))) +
              '  ' + Piece(Items[AnIndex], U, 2) + ', ' + Piece(Items[AnIndex], U, 6) + ', ' +
              Piece(Piece(Items[AnIndex], U, 5), ';', 2)
end;

procedure TfrmDCSumm.cmdChangeClick(Sender: TObject);
var
  LastTitle: Integer;
  OKPressed, IsIDChild: Boolean;
  x: string;
  ListItemForEdit: string;
begin
  inherited;
  IsIDChild := uIDNotesActive and (FEditDCSumm.IDParent > 0);
  LastTitle   := FEditDCSumm.Title;
  if Sender <> Self then
    begin
      FShowAdmissions := False;
      OKPressed := ExecuteDCSummProperties(FEditDCSumm, ListItemForEdit, FShowAdmissions, IsIDChild);
    end
  else
    OKPressed := True;
  if not OKPressed then Exit;
  // update display fields & uPCEEdit
  lblNewTitle.Caption := ' ' + FEditDCSumm.TitleName + ' ';
  if (FEditDCSumm.Addend > 0)  and (CompareText(Copy(lblNewTitle.Caption, 2, 8), 'Addendum') <> 0) then
    lblNewTitle.Caption := 'Addendum to: ' + lblNewTitle.Caption;
  with lblNewTitle do bvlNewTitle.SetBounds(Left - 1, Top - 1, Width + 2, Height + 2);
  lblRefDate.Caption := FormatFMDateTime('dddddd@hh:nn', FEditDCSumm.DischargeDateTime);
  lblDictator.Caption  := FEditDCSumm.DictatorName;
  x := 'Adm: ' + FormatFMDateTime('ddddd', FEditDCSumm.AdmitDateTime) + '  ' + FEditDCSumm.LocationName;
  lblVisit.Caption   := x;
  x := '  Dis: ' + FormatFMDateTime('ddddd', FEditDCSumm.DischargeDateTime);
  lblDischarge.Caption := x;
  if Length(FEditDCSumm.AttendingName) > 0
    then lblCosigner.Caption := 'Attending: ' + FEditDCSumm.AttendingName
    else lblCosigner.Caption := '';
  uPCEEdit.NoteTitle  := FEditDCSumm.Title;
  // modify signature requirements if author or cosigner changed
  if (User.DUZ <> FEditDCSumm.Dictator) and (User.DUZ <> FEditDCSumm.Attending)
    then Changes.ReplaceSignState(CH_SUM, lstSumms.ItemID, CH_SIGN_NA)
    else Changes.ReplaceSignState(CH_SUM, lstSumms.ItemID, CH_SIGN_YES);
  x := lstSumms.Items[EditingIndex];
  SetPiece(x, U, 2, lblNewTitle.Caption);
  SetPiece(x, U, 3, FloatToStr(FEditDCSumm.DischargeDateTime));
  tvSumms.Selected.Text := MakeDCSummDisplayText(x);
  TORTreeNode(tvSumms.Selected).StringData := x;
  lstSumms.Items[EditingIndex] := x;
  Changes.ReplaceText(CH_SUM, lstSumms.ItemID, GetTitleText(EditingIndex));
  if LastTitle <> FEditDCSumm.Title then mnuActLoadBoilerClick(Self);
end;

procedure TfrmDCSumm.mnuActChangeClick(Sender: TObject);
begin
  inherited;
  if NoSummSelected() then Exit;
  if (FEditingIndex < 0) or (lstSumms.ItemIndex <> FEditingIndex) then Exit;
  cmdChangeClick(Sender);
end;

procedure TfrmDCSumm.mnuActLoadBoilerClick(Sender: TObject);
var
  NoteEmpty: Boolean;
  BoilerText: TStringList;
  DocInfo: string;

  procedure AssignBoilerText;
  begin
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditDCSumm.Title, ltTitle, Self, 'Title: ' + FEditDCSumm.TitleName, DocInfo);
    memNewSumm.Lines.Text := BoilerText.Text;
    SpeakStrings(BoilerText);
    FChanged := False;
  end;

begin
  inherited;
  if NoSummSelected() then Exit;
  if (FEditingIndex < 0) or (lstSumms.ItemIndex <> FEditingIndex) then Exit;
  BoilerText := TStringList.Create;
  try
    NoteEmpty := memNewSumm.Text = '';
    LoadBoilerPlate(BoilerText, FEditDCSumm.Title);
    if (BoilerText.Text <> '') or
       assigned(GetLinkedTemplate(IntToStr(FEditDCSumm.Title), ltTitle)) then begin
      DocInfo := MakeXMLParamTIU(IntToStr(lstSumms.ItemIEN), FEditDCSumm);
      if NoteEmpty then AssignBoilerText else begin
        case QueryBoilerPlate(BoilerText) of
          0:  { do nothing } ;                         // ignore
          1: begin
               ExecuteTemplateOrBoilerPlate(BoilerText, FEditDCSumm.Title, ltTitle, Self, 'Title: ' + FEditDCSumm.TitleName, DocInfo);
               memNewSumm.Lines.AddStrings(BoilerText);  // append
               SpeakStrings(BoilerText);
             end;
          2: AssignBoilerText                          // replace
        end;
      end;
    end else begin
      if Sender = mnuActLoadBoiler
        then InfoBox(TX_NO_BOIL, TC_NO_BOIL, MB_OK)
        else
        begin
          if not NoteEmpty then
            if not FChanged and (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES)
              then memNewSumm.Lines.Clear;
        end;
    end; {if BoilerText.Text <> ''}
  finally
    BoilerText.Free;
  end;
end;

procedure TfrmDCSumm.popSummMemoSaveContinueClick(Sender: TObject);
begin
  inherited;
  FChanged := True;
  DoAutoSave;
end;

procedure TfrmDCSumm.mnuEditDialgFieldsClick(Sender: TObject);
begin
  inherited;
  EditDialogFields;
end;

//===================  Added for sort/search enhancements ======================
procedure TfrmDCSumm.LoadSumms;
var
  tmpList: TStringList;
  ANode: TORTreeNode;

begin
  tmpList := TStringList.Create;
  try
    FDocList.Clear;
    uChanging := True;
    RedrawSuspend(memSumm.Handle);
    RedrawSuspend(lvSumms.Handle);
    tvSumms.Items.BeginUpdate;
    lstSumms.Items.Clear;
    KillDocTreeObjects(tvSumms);
    tvSumms.Items.Clear;
    tvSumms.Items.EndUpdate;
    lvSumms.Items.Clear;
    memSumm.Clear;
    memSumm.Invalidate;
    lblTitle.Caption := '';
    lvSumms.Caption := lblTitle.Caption;
    lblTitle.Hint := lblTitle.Caption;
    with FCurrentContext do
      begin
        if Status <> IntToStr(NC_UNSIGNED) then
          begin
            ListSummsForTree(tmpList, NC_UNSIGNED, 0, 0, 0, 0, TreeAscending);
            if tmpList.Count > 0 then
              begin
                CreateListItemsForDocumentTree(FDocList, tmpList, NC_UNSIGNED, GroupBy, TreeAscending, CT_DCSUMM);
                UpdateTreeView(FDocList, tvSumms);
              end;
            tmpList.Clear;
            FDocList.Clear;
          end;
        if Status <> IntToStr(NC_UNCOSIGNED) then
          begin
            ListSummsForTree(tmpList, NC_UNCOSIGNED, 0, 0, 0, 0, TreeAscending);
            if tmpList.Count > 0 then
              begin
                CreateListItemsForDocumentTree(FDocList, tmpList, NC_UNCOSIGNED, GroupBy, TreeAscending, CT_DCSUMM);
                UpdateTreeView(FDocList, tvSumms);
              end;
            tmpList.Clear;
            FDocList.Clear;
          end;
        ListSummsForTree(tmpList, StrToIntDef(Status, 0), FMBeginDate, FMEndDate, Author, MaxDocs, TreeAscending);
        CreateListItemsForDocumentTree(FDocList, tmpList, StrToIntDef(Status, 0), GroupBy, TreeAscending, CT_DCSUMM);
        UpdateTreeView(FDocList, tvSumms);
      end;
    with tvSumms do
      begin
        uChanging := True;
        tvSumms.Items.BeginUpdate;
        RemoveParentsWithNoChildren(tvSumms, FCurrentContext);   // moved TO here in v15.9  (RV)
        if FLastSummID <> '' then
          Selected := FindPieceNode(FLastSummID, 1, U, nil);
        if Selected = nil then
          begin
            if (FCurrentContext.GroupBy <> '') or (FCurrentContext.Filtered) then
              begin
                ANode := TORTreeNode(Items.GetFirstNode);
                while ANode <> nil do
                  begin
                    ANode.Expand(False);
                    Selected := ANode;
                    ANode := TORTreeNode(ANode.GetNextSibling);
                  end;
              end
            else
              begin
                ANode := tvSumms.FindPieceNode(FCurrentContext.Status, 1, U, nil);
                if ANode <> nil then ANode.Expand(False);
                ANode := tvSumms.FindPieceNode(IntToStr(NC_UNSIGNED), 1, U, nil);
                if ANode = nil then
                  ANode := tvSumms.FindPieceNode(IntToStr(NC_UNCOSIGNED), 1, U, nil);
                if ANode = nil then
                  ANode := tvSumms.FindPieceNode(FCurrentContext.Status, 1, U, nil);
                if ANode <> nil then
                  begin
                    if ANode.getFirstChild <> nil then
                      Selected := ANode.getFirstChild
                    else
                      Selected := ANode;
                  end;
              end;
          end;
        memSumm.Clear;
        with lvSumms do
          begin
            Selected := nil;
            if FCurrentContext.SortBy <> '' then
              ColumnToSort := Pos(FCurrentContext.SortBy, 'RDSAL') - 1;
            if not FCurrentContext.ShowSubject then
              begin
                Columns[1].Width := 2 * (Width div 5);
                Columns[2].Width := 0;
              end
            else
              begin
                Columns[1].Width := Width div 5;
                Columns[2].Width := Columns[1].Width;
              end;
          end;
        //RemoveParentsWithNoChildren(tvSumms, FCurrentContext);  //moved FROM here in v15.9  (RV)
        tvSumms.Items.EndUpdate;
        uChanging := False;
        SendMessage(tvSumms.Handle, WM_VSCROLL, SB_TOP, 0);
        if Selected <> nil then tvSummsChange(Self, Selected);
      end;
  finally
    RedrawActivate(memSumm.Handle);
    RedrawActivate(lvSumms.Handle);
    tmpList.Free;
  end;
end;

procedure TfrmDCSumm.UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
Var
 ReturnCursor: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
  with Tree do
    begin
      uChanging := True;
      Items.BeginUpdate;
      FastAddStrings(DocList, lstSumms.Items);
      ReturnCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
        BuildDocumentTree2(DocList, Tree, FCurrentContext, CT_DCSUMM);
      finally
       Screen.Cursor := ReturnCursor;
      end;
      Items.EndUpdate;
      uChanging := False;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmDCSumm.tvSummsChange(Sender: TObject; Node: TTreeNode);
var
  x, MySearch, MyNodeID: string;
  i: integer;
  WhyNot: string;
begin
  if uChanging then Exit;
  //This gives the change a chance to occur when keyboarding, so that WindowEyes
  //doesn't use the old value.
  Application.ProcessMessages;
  with tvSumms do
    begin
      memSumm.Clear;
      if Selected = nil then Exit;
      if uIDNotesActive then
        begin
          mnuActDetachFromIDParent.Enabled := (Selected.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
          popSummListDetachFromIDParent.Enabled := (Selected.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
          if (Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
            mnuActAttachtoIDParent.Enabled := CanBeAttached(PDocTreeObject(Selected.Data)^.DocID, WhyNot)
          else
            mnuActAttachtoIDParent.Enabled := False;
          popSummListAttachtoIDParent.Enabled := mnuActAttachtoIDParent.Enabled;
          if (Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                      IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                      IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
            mnuActAddIDEntry.Enabled := CanReceiveAttachment(PDocTreeObject(Selected.Data)^.DocID, WhyNot)
          else
            mnuActAddIDEntry.Enabled := False;
          popSummListAddIDEntry.Enabled := mnuActAddIDEntry.Enabled
        end;
      RedrawSuspend(lvSumms.Handle);
      RedrawSuspend(memSumm.Handle);
      popSummListExpandSelected.Enabled := Selected.HasChildren;
      popSummListCollapseSelected.Enabled := Selected.HasChildren;
      x := TORTreeNode(Selected).StringData;
      if (Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
        begin
          lvSumms.Visible := True;
          lvSumms.Items.Clear;
          lvSumms.Height := (2 * lvSumms.Parent.Height) div 5;
          with lblTitle do
            begin
              Caption := Trim(Selected.Text);
              if (FCurrentContext.SearchField <> '') and (FCurrentContext.Filtered) then
                begin
                  case FCurrentContext.SearchField[1] of
                    'T': MySearch := 'TITLE';
                    'S': MySearch := 'SUBJECT';
                    'B': MySearch := 'TITLE or SUBJECT';
                  end;
                  Caption := Caption + ' where ' + MySearch + ' contains "' + UpperCase(FCurrentContext.Keyword) + '"';
                end;
              Hint := Caption;
              lvSumms.Caption := Caption;
            end;

          if Selected.ImageIndex = IMG_TOP_LEVEL then
            MyNodeID := Piece(TORTreeNode(Selected).StringData, U, 1)
          else if Selected.Parent.ImageIndex = IMG_TOP_LEVEL then
            MyNodeID := Piece(TORTreeNode(Selected.Parent).StringData, U, 1)
          else if Selected.Parent.Parent.ImageIndex = IMG_TOP_LEVEL then
            MyNodeID := Piece(TORTreeNode(Selected.Parent.Parent).StringData, U, 1);

          uChanging := True;
          TraverseTree(tvSumms, lvSumms, Selected.GetFirstChild, MyNodeID, FCurrentContext);
          with lvSumms do
            begin
              for i := 0 to Columns.Count - 1 do
                Columns[i].ImageIndex := IMG_NONE;
              ColumnSortForward := FCurrentContext.ListAscending;
              if ColumnToSort = 5 then ColumnToSort := 0;
              if ColumnSortForward then
                Columns[ColumnToSort].ImageIndex := IMG_ASCENDING
              else
                Columns[ColumnToSort].ImageIndex := IMG_DESCENDING;
              if ColumnToSort = 0 then ColumnToSort := 5;
              AlphaSort;
              Columns[5].Width := 0;
              Columns[6].Width := 0;
            end;
          uChanging := False;
          with lvSumms do
            if Items.Count > 0 then
              begin
                Selected := Items[0];
                lvSummsSelectItem(Self, Selected, True);
              end
            else
              begin
                Selected := nil;
                lstSumms.ItemIndex := -1;
                memPCEShow.Clear;
                ShowPCEControls(False);
              end;
          pnlWrite.Visible := False;
          pnlRead.Visible := True;
(*          UpdateReminderFinish;
          ShowPCEControls(False);
          frmDrawers.DisplayDrawers(FALSE);
          cmdNewSumm.Visible := TRUE;
          cmdPCE.Visible := FALSE;
          lblSpace1.Top := cmdNewSumm.Top - lblSpace1.Height;*)
          //memSumm.Clear;
        end
      else if StrToIntDef(Piece(x, U, 1), 0) > 0 then
        begin
          memSumm.Clear;
          lvSumms.Visible := False;
          lstSumms.SelectByID(Piece(x, U, 1));
          lstSummsClick(Self);
          SendMessage(memSumm.Handle, WM_VSCROLL, SB_TOP, 0);
        end;

      //display orphaned warning
      if PDocTreeObject(Selected.Data)^.Orphaned then
       MessageDlg(ORPHANED_NOTE_TEXT, mtInformation, [mbOK], -1);

      SendMessage(tvSumms.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
      RedrawActivate(lvSumms.Handle);
      RedrawActivate(memSumm.Handle);
    end;
end;

procedure TfrmDCSumm.tvSummsCollapsed(Sender: TObject; Node: TTreeNode);
begin
  with Node do
    begin
      if (ImageIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        ImageIndex := ImageIndex - 1;
      if (SelectedIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        SelectedIndex := SelectedIndex - 1;
    end;
end;

procedure TfrmDCSumm.tvSummsExpanded(Sender: TObject; Node: TTreeNode);

  function SortByTitle(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by title
    BUT - addenda to parent document are always at the top of the sort, in date order}
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
       (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
      begin
        Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := 1
    else
      begin
        if Data = 0 then
          Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
                                  PChar(PDocTreeObject(Node2.Data)^.DocTitle))
        else
          Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
                                  PChar(PDocTreeObject(Node2.Data)^.DocTitle));
      end
  end;

  function SortByDate(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by document date
    BUT - addenda to parent document are always at the top of the sort, in date order}
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
       (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
      begin
        Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := 1
    else
      begin
        if Data = 0 then
          Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                  PChar(PDocTreeObject(Node2.Data)^.DocFMDate))
        else
          Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                  PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end;
  end;

begin
  with Node do
    begin
      if Assigned(Data) then
        if (Pos('<', PDocTreeObject(Data)^.DocHasChildren) > 0) then
          begin
            if (PDocTreeObject(Node.Data)^.OrderByTitle) then
              CustomSort(@SortByTitle, 0)
            else
              CustomSort(@SortByDate, 0);
          end;
      if (ImageIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT]) then
        ImageIndex := ImageIndex + 1;
      if (SelectedIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT]) then
        SelectedIndex := SelectedIndex + 1;
    end;
end;

procedure TfrmDCSumm.tvSummsClick(Sender: TObject);
begin
(*  if tvSumms.Selected = nil then exit;
  if (tvSumms.Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
    begin
      uChanging := True;
      lvSumms.Selected := nil;
      uChanging := False;
      memSumm.Clear;
    end;*)
end;

procedure TfrmDCSumm.tvSummsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AnItem: TORTreeNode;
begin
  Accept := False;
  if not uIDNotesActive then exit;
  AnItem := TORTreeNode(tvSumms.GetNodeAt(X, Y));
  if (AnItem = nil) or (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then Exit;
  with tvSumms.Selected do
    if (ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
      Accept := (AnItem.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                       IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                       IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT])
    else if (ImageIndex in [IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
      Accept := (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL])
    else if (ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then
      Accept := False;
end;

procedure TfrmDCSumm.tvSummsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HT: THitTests;
  Saved: boolean;
  ADestNode: TORTreeNode;
begin
  if not uIDNotesActive then
    begin
      CancelDrag;
      exit;
    end;
  if tvSumms.Selected = nil then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
  end;
  HT := tvSumms.GetHitTestInfoAt(X, Y);
  ADestNode := TORTreeNode(tvSumms.GetNodeAt(X, Y));
  DoAttachIDChild(TORTreeNode(tvSumms.Selected), ADestNode);
end;

procedure TfrmDCSumm.tvSummsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
const
  TX_CAP_NO_DRAG = 'Item cannot be moved';
  var
  WhyNot: string;
  Saved: boolean;
begin
  if (tvSumms.Selected.ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) or
     (not uIDNotesActive) or
     (lstSumms.ItemIEN = 0) then
    begin
      CancelDrag;
      Exit;
    end;
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
  end;
  if not CanBeAttached(PDocTreeObject(tvSumms.Selected.Data)^.DocID, WhyNot) then
    begin
      InfoBox(WhyNot, TX_CAP_NO_DRAG, MB_OK);
      CancelDrag;
    end;
end;

procedure TfrmDCSumm.lvSummsColumnClick(Sender: TObject; Column: TListColumn);
var
  i, ClickedColumn: Integer;
begin
  if Column.Index = 0 then ClickedColumn := 5 else ClickedColumn := Column.Index;
  if ClickedColumn = ColumnToSort then
    ColumnSortForward := not ColumnSortForward
  else
    ColumnSortForward := True;
  for i := 0 to lvSumms.Columns.Count - 1 do
    lvSumms.Columns[i].ImageIndex := IMG_NONE;
  if ColumnSortForward then lvSumms.Columns[Column.Index].ImageIndex := IMG_ASCENDING
  else lvSumms.Columns[Column.Index].ImageIndex := IMG_DESCENDING;
  ColumnToSort := ClickedColumn;
  case ColumnToSort of
    5:  FCurrentContext.SortBy := 'R';
    1:  FCurrentContext.SortBy := 'D';
    2:  FCurrentContext.SortBy := 'S';
    3:  FCurrentContext.SortBy := 'A';
    4:  FCurrentContext.SortBy := 'L';
  else
    FCurrentContext.SortBy := 'R';
  end;
  FCurrentContext.ListAscending := ColumnSortForward;
  (Sender as TCustomListView).AlphaSort;
  //with lvSumms do if Selected <> nil then Scroll(0,  Selected.Top - TopItem.Top);
end;

procedure TfrmDCSumm.lvSummsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
  if not ColumnSortForward then Compare := -Compare;
end;

procedure TfrmDCSumm.lvSummsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if uChanging or (not Selected) then Exit;
  with lvSumms do
    begin
      StatusText('Retrieving selected discharge summary...');
      lstSumms.SelectByID(Item.SubItems[5]);
      lstSummsClick(Self);
      SendMessage(memSumm.Handle, WM_VSCROLL, SB_TOP, 0);
    end;
end;

procedure TfrmDCSumm.lvSummsResize(Sender: TObject);
begin
  inherited;
  with lvSumms do
    begin
      if not FCurrentContext.ShowSubject then
        begin
          Columns[1].Width := 2 * (Width div 5);
          Columns[2].Width := 0;
        end
      else
        begin
          Columns[1].Width := Width div 5;
          Columns[2].Width := Columns[1].Width;
        end;
    end;
end;

procedure TfrmDCSumm.EnableDisableIDNotes;
begin
  uIDNotesActive := False; // := IDNotesInstalled;       Not yet on this tab
  mnuActDetachFromIDParent.Visible := uIDNotesActive;
  popSummListDetachFromIDParent.Visible := uIDNotesActive;
  mnuActAddIDEntry.Visible := uIDNotesActive;
  popSummListAddIDEntry.Visible := uIDNotesActive;
  mnuActAttachtoIDParent.Visible := uIDNotesActive;
  popSummListAttachtoIDParent.Visible := uIDNotesActive;
  if uIDNotesActive then
    tvSumms.DragMode := dmAutomatic
  else
    tvSumms.DragMode := dmManual;
end;

procedure TfrmDCSumm.mnuIconLegendClick(Sender: TObject);
begin
  inherited;
  ShowIconLegend(ilNotes);
end;

procedure TfrmDCSumm.mnuActAttachtoIDParentClick(Sender: TObject);
var
  AChildNode: TORTreeNode;
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
begin
  inherited;
  if not uIDNotesActive then exit;
  if lstSumms.ItemIEN = 0 then exit;
  SavedDocID := lstSumms.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentSumm(Saved);
    if not Saved then Exit;
    LoadSumms;
    with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvSumms.Selected = nil then exit;
  AChildNode := TORTreeNode(tvSumms.Selected);
  AParentID := SelectParentNodeFromList(tvSumms);
  if AParentID = '' then exit;
  with tvSumms do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
  DoAttachIDChild(AChildNode, TORTreeNode(tvSumms.Selected));
end;

procedure TfrmDCSumm.DoAttachIDChild(AChild, AParent: TORTreeNode);
const
  TX_ATTACH_CNF     = 'Confirm Attachment';
  TX_ATTACH_FAILURE = 'Attachment failed';
var
  ErrMsg, WhyNot: string;
  SavedDocID: string;
begin
  if (AChild = nil) or (AParent = nil) then exit;
  ErrMsg := '';
  if not CanBeAttached(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot + CRLF + CRLF;
  if not CanReceiveAttachment(PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot;
  if ErrMsg <> '' then
    begin
      InfoBox(ErrMsg, TX_ATTACH_FAILURE, MB_OK);
      Exit;
    end
  else
    begin
      WhyNot := '';
      if (InfoBox('ATTACH:   ' + AChild.Text + CRLF + CRLF +
                  '    TO:   ' + AParent.Text + CRLF + CRLF +
                  'Are you sure?', TX_ATTACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
          then Exit;
      SavedDocID := PDocTreeObject(AParent.Data)^.DocID;
    end;
  if AChild.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD] then
    begin
      if DetachEntryFromParent(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
        begin
          if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID, PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
            begin
              LoadSumms;
              with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
              if tvSumms.Selected <> nil then tvSumms.Selected.Expand(False);
            end
          else
            InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
        end
      else
        begin
          WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
          WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
          InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
          Exit;
        end;
    end
  else
    begin
      if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID, PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
        begin
          LoadSumms;
          with tvSumms do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
          if tvSumms.Selected <> nil then tvSumms.Selected.Expand(False);
        end
      else
        InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
   end;
end;

function TfrmDCSumm.SetSummTreeLabel(AContext: TTIUContext): string;
var
  x: string;

  function SetDateRangeText(AContext: TTIUContext): string;
  var
    x1: string;
  begin
    with AContext do
      if BeginDate <> '' then
        begin
          x1 := ' from ' + UpperCase(BeginDate);
          if EndDate <> '' then x1 := x1 + ' to ' + UpperCase(EndDate)
          else x1 := x1 + ' to TODAY';
        end;
    Result := x1;
  end;

begin
  with AContext do
    begin
      if MaxDocs > 0 then x := 'Last ' + IntToStr(MaxDocs) + ' ' else x := 'All ';
      case StrToIntDef(Status, 0) of
        NC_ALL        : x := x + 'Signed Summaries';
        NC_UNSIGNED   : begin
                          x := x + 'Unsigned Summaries for ';
                          if Author > 0 then x := x + ExternalName(Author, 200)
                          else x := x + User.Name;
                          x := x + SetDateRangeText(AContext);
                        end;
        NC_UNCOSIGNED : begin
                          x := x + 'Uncosigned Summaries for ';
                          if Author > 0 then x := x + ExternalName(Author, 200)
                          else x := x + User.Name;
                          x := x + SetDateRangeText(AContext);
                        end;
        NC_BY_AUTHOR  : x := x + 'Signed Summaries for ' + ExternalName(Author, 200) + SetDateRangeText(AContext);
        NC_BY_DATE    : x := x + 'Signed Summaries ' + SetDateRangeText(AContext);
      else
        x := 'Custom List';
      end;
    end;
  Result := x;
end;

procedure TfrmDCSumm.memNewSummKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then
  begin
    if ssShift in Shift then
    begin
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
      Key := 0;
    end
    else if ssCtrl	in Shift then
    begin
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
      Key := 0;
    end;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmDCSumm.sptHorzCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if pnlWrite.Visible then
     if NewSize > frmDCSumm.ClientWidth - memNewSumm.Constraints.MinWidth - sptHorz.Width then
        NewSize := frmDCSumm.ClientWidth - memNewSumm.Constraints.MinWidth - sptHorz.Width;
end;

procedure TfrmDCSumm.popSummMemoPreviewClick(Sender: TObject);
begin
  frmDrawers.mnuPreviewTemplateClick(Sender);
end;

procedure TfrmDCSumm.popSummMemoInsTemplateClick(Sender: TObject);
begin
  frmDrawers.mnuInsertTemplateClick(Sender);
end;

{Returns True & Displays a Message if Currently No D/C Summary is Selected,
 Otherwise returns false and does not display a message.}
function TfrmDCSumm.NoSummSelected: Boolean;
begin
  if lstSumms.ItemIEN <= 0 then
  begin
    InfoBox(TX_NOSUMM,TX_NOSUMM_CAP,MB_OK or MB_ICONWARNING);
    Result := true;
  end
  else
    Result := false;
end;

procedure TfrmDCSumm.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmDCSumm.mnuViewInformationClick(Sender: TObject);
begin
  inherited;
  mnuViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
  mnuViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
  mnuViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
  mnuViewMyHealtheVet.Enabled := not (Copy(frmFrame.laMHV.Hint, 1, 2) = 'No');
  mnuInsurance.Enabled := not (Copy(frmFrame.laVAA2.Hint, 1, 2) = 'No');
  mnuViewFlags.Enabled := frmFrame.lblFlag.Enabled;
  mnuViewRemoteData.Enabled := frmFrame.lblCirn.Enabled;
  mnuViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
  mnuViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

initialization
  SpecifyFormIsNotADialog(TfrmDCSumm);
  uPCEEdit := TPCEData.Create;
  uPCEShow := TPCEData.Create;

finalization
  uPCEEdit.Free;
  uPCEShow.Free;

end.
