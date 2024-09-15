unit fTemplateFieldEditor;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, ExtCtrls, Menus, ComCtrls, uTemplateFields, ORFn,
  ToolWin, ORClasses, ORDtTm, fBase508Form, VA508AccessibilityManager,
  System.Actions, Vcl.ActnList;

type
  TfrmTemplateFieldEditor = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlObjs: TPanel;
    cbxObjs: TORComboBox;
    lblObjs: TLabel;
    splLeft: TSplitter;
    pnlRight: TPanel;
    pnlPreview: TPanel;
    lblNotes: TLabel;
    pnlObjInfo: TPanel;
    lblName: TLabel;
    lblS2: TLabel;
    lblLM: TLabel;
    edtName: TCaptionEdit;
    splBottom: TSplitter;
    lblS1: TLabel;
    edtLMText: TCaptionEdit;
    cbxType: TORComboBox;
    lblType: TLabel;
    reNotes: ORExtensions.TRichEdit;
    btnApply: TButton;
    btnPreview: TButton;
    cbHide: TCheckBox;
    pnlTop: TPanel;
    btnNew: TButton;
    btnCopy: TButton;
    btnDelete: TButton;
    popText: TPopupMenu;
    mnuBPUndo: TMenuItem;
    N8: TMenuItem;
    mnuBPCut: TMenuItem;
    mnuBPCopy: TMenuItem;
    mnuBPPaste: TMenuItem;
    mnuBPSelectAll: TMenuItem;
    N2: TMenuItem;
    mnuBPCheckGrammar: TMenuItem;
    mnuBPSpellCheck: TMenuItem;
    lblTextLen: TLabel;
    edtTextLen: TCaptionEdit;
    udTextLen: TUpDown;
    pnlSwap: TPanel;
    edtDefault: TCaptionEdit;
    pnlNum: TPanel;
    edtURL: TCaptionEdit;
    udDefNum: TUpDown;
    edtDefNum: TCaptionEdit;
    udMinVal: TUpDown;
    edtMinVal: TCaptionEdit;
    lblMin: TLabel;
    udInc: TUpDown;
    edtInc: TCaptionEdit;
    lblInc: TLabel;
    lblMaxVal: TLabel;
    edtMaxVal: TCaptionEdit;
    udMaxVal: TUpDown;
    reItems: ORExtensions.TRichEdit;
    lblLength: TLabel;
    edtLen: TCaptionEdit;
    udLen: TUpDown;
    cbxDefault: TORComboBox;
    lblS3: TLabel;
    gbIndent: TGroupBox;
    lblIndent: TLabel;
    edtIndent: TCaptionEdit;
    udIndent: TUpDown;
    udPad: TUpDown;
    edtPad: TCaptionEdit;
    lblPad: TLabel;
    gbMisc: TGroupBox;
    cbActive: TCheckBox;
    cbRequired: TCheckBox;
    cbSepLines: TCheckBox;
    pnlDate: TPanel;
    edtDateDef: TCaptionEdit;
    cbxDateType: TORComboBox;
    lblDateType: TLabel;
    cbExclude: TCheckBox;
    lblReq: TStaticText;
    lblLine: TLabel;
    lblCol: TLabel;
    N14: TMenuItem;
    mnuInsertTemplateField: TMenuItem;
    lblCommCareLock: TLabel;
    btnErrorCheck: TButton;
    N1: TMenuItem;
    mnuErrorCheck2: TMenuItem;
    alMain: TActionList;
    acNew: TAction;
    acCopy: TAction;
    acDelete: TAction;
    acCheckForErrors: TAction;
    acCheckAll: TAction;
    acPreview: TAction;
    popMain: TPopupMenu;
    New1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    N5: TMenuItem;
    CheckforErrors1: TMenuItem;
    ErrorCheckAllTemplateFields1: TMenuItem;
    N6: TMenuItem;
    Preview1: TMenuItem;
    ToolBar1: TToolBar;
    acAction: TAction;
    tbMnuAction: TToolButton;
    procedure cbxObjsNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormCreate(Sender: TObject);
    procedure cbxObjsChange(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure cbxTypeChange(Sender: TObject);
    procedure edtLenChange(Sender: TObject);
    procedure edtDefaultChange(Sender: TObject);
    procedure cbxDefaultChange(Sender: TObject);
    procedure edtLMTextChange(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure reItemsChange(Sender: TObject);
    procedure cbHideClick(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure cbRequiredClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxObjsSynonymCheck(Sender: TObject; const Text: String;
      var IsSynonym: Boolean);
    procedure popTextPopup(Sender: TObject);
    procedure mnuBPUndoClick(Sender: TObject);
    procedure mnuBPCutClick(Sender: TObject);
    procedure mnuBPCopyClick(Sender: TObject);
    procedure mnuBPPasteClick(Sender: TObject);
    procedure mnuBPSelectAllClick(Sender: TObject);
    procedure mnuBPCheckGrammarClick(Sender: TObject);
    procedure mnuBPSpellCheckClick(Sender: TObject);
    procedure cbSepLinesClick(Sender: TObject);
    procedure edtpopControlEnter(Sender: TObject);
    procedure cbxObjsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtTextLenChange(Sender: TObject);
    procedure edtDefNumChange(Sender: TObject);
    procedure edtMinValChange(Sender: TObject);
    procedure edtMaxValChange(Sender: TObject);
    procedure edtIncChange(Sender: TObject);
    procedure edtURLChange(Sender: TObject);
    procedure edtPadChange(Sender: TObject);
    procedure edtIndentChange(Sender: TObject);
    procedure reNotesChange(Sender: TObject);
    procedure cbxDateTypeChange(Sender: TObject);
    procedure cbExcludeClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure reItemsResizeRequest(Sender: TObject; Rect: TRect);
    procedure reItemsSelectionChange(Sender: TObject);
    procedure mnuInsertTemplateFieldClick(Sender: TObject);
    procedure ControlExit(Sender: TObject);
    procedure reNotesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
//    procedure mnuErrorCheckAllTemplateFieldsClick(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acCheckAllExecute(Sender: TObject);
    procedure acPreviewExecute(Sender: TObject);
    procedure acActionExecute(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acCheckForErrorsExecute(Sender: TObject);
  private
    CopyFld, FFld: TTemplateField;
    FUpdating: boolean;
    FReloadChanges: boolean;
    FChangesPending: boolean;
    FDeleted: TORStringList;
    FHideSynonyms: boolean;
    FLastRect: TRect;
    procedure UpdateControls;
    procedure SyncItems(DoUpdate: boolean = TRUE);
    function SaveChanges: boolean;
    procedure ResetListEntry;
    procedure VerifyName;
    procedure EnableButtons;
    procedure SetFld(const Value: TTemplateField);
    procedure SetHideSynonyms(const Value: boolean);
    function GetPopupControl: TCustomEdit;
    function IsCommunityCare: boolean;
  public
    { Public declarations }
  end;

function EditDialogFields: boolean;

implementation

uses rTemplates, fTemplateDialog, Clipbrd, uSpell, uConst, System.UITypes,
     fTemplateFields, VAUtils, dShared, FTemplateReport;

{$R *.DFM}

{ TfrmDlgObjEditor }

var
  frmTemplateFields: TfrmTemplateFields = nil;


function EditDialogFields: boolean;
var
  frmTemplateFieldEditor: TfrmTemplateFieldEditor;

begin
  frmTemplateFieldEditor := TfrmTemplateFieldEditor.Create(Application);
  try
    frmTemplateFieldEditor.ShowModal;
    Result := frmTemplateFieldEditor.FReloadChanges;
  finally
    frmTemplateFieldEditor.Free;
  end;
end;

procedure TfrmTemplateFieldEditor.UpdateControls;
const
  DefTxt = 'Default:';

var
  ok, edt, txt, tmp: boolean;
  Y, idx, Max: integer;
  wpTxt: string;

  procedure SetLbl(const Text: string);
  var
    lbl: TLabel;

  begin
    inc(idx);
    case idx of
      1: lbl := lblS1;
      2: lbl := lblS2;
      3: lbl := lblS3;
      else
         lbl := nil;
    end;
    if assigned(lbl) then
      lbl.Caption := Text;
  end;

  procedure SetY(Control: TControl; const Text: string);
  begin
    if (Control.Visible) then
    begin
      Control.Top := Y;
      inc(Y, Control.Height);
      SetLbl(Text);
    end;
  end;

begin
  if(not FUpdating) then
  begin
    FUpdating := TRUE;
    try
      Y := 0;
      idx := 0;
      ok := assigned(FFld);
      if(ok) then
      begin
        edt := (FFld.FldType in EditLenTypes);
        txt := (FFld.FldType in EditDfltTypes);
      end
      else
      begin
        edt := FALSE;
        txt := FALSE;
      end;
      lblName.Enabled := ok;
      edtName.Enabled := ok;
      lblType.Enabled := ok;
      cbxType.Enabled := ok;
      lblLM.Enabled := ok;
      edtLMText.Enabled := ok;
      cbActive.Enabled := ok;

      gbMisc.Enabled := ok;
      lblNotes.Enabled := ok;
      reNotes.Enabled := ok;
      if(ok) then
      begin
        edtName.Text := FFld.FldName;
        cbxType.ItemIndex := ord(FFld.FldType);
        edtLMText.Text := FFld.LMText;
        cbActive.Checked := FFld.Inactive;
        reNotes.Lines.Text := FFld.Notes;
      end
      else
      begin
        edtName.Text := '';
        cbxType.ItemIndex := -1;
        edtLMText.Text := '';
        cbActive.Checked := FALSE;
        reNotes.Clear;
      end;

      tmp := ok and (not (FFld.FldType in NoRequired));
      cbRequired.Enabled := tmp;
      if tmp then
        cbRequired.Checked := FFld.Required
      else
        cbRequired.Checked := FALSE;

      pnlSwap.DisableAlign;
      try
        tmp := ok and (FFld.FldType in SepLinesTypes);
        cbSepLines.Enabled := tmp;
        if tmp then
          cbSepLines.Checked := FFld.SepLines
        else
          cbSepLines.Checked := FALSE;

        tmp := ok and (FFld.FldType in ExcludeText);
        cbExclude.Enabled := tmp;
        if tmp then
          cbExclude.Checked := FFld.SepLines
        else
          cbExclude.Checked := FALSE;

        lblLength.Enabled := edt;
        if ok and (FFld.FldType = dftWP) then
        begin
          lblTextLen.Caption := 'Num Lines:';
          udLen.Min := 5;
          udLen.Max := 74;
          udTextLen.Min := 2;
          udTextLen.Max := MaxTFWPLines;
        end
        else
        begin
          udLen.Min := 1;
          udLen.Max := 70;
          udTextLen.Min := 0;
          udTextLen.Max := 240;
          lblTextLen.Caption := 'Text Len:';
        end;

        lblTextLen.Enabled := edt;
        edtTextLen.Enabled := edt;
        udTextLen.Enabled := edt;
        edtLen.Enabled := edt;
        udLen.Enabled := edt;

        edtDefault.Visible := txt;
        SetY(edtDefault, DefTxt);
        Max := MaxTFEdtLen;

        if(edt) then
        begin
          udLen.Associate := edtLen;
          udLen.Position := FFld.MaxLen;
          udTextLen.Associate := edtTextLen;
          udTextLen.Position := FFld.TextLen;
          if txt then
            Max := FFld.MaxLen;
        end
        else
        begin
          udLen.Associate := nil;
          edtLen.Text := '';
          udTextLen.Associate := nil;
          edtTextLen.Text := '';
        end;

        if txt then
        begin
          edtDefault.MaxLength := Max;
          edtDefault.Text := copy(FFld.EditDefault, 1, Max);
        end;

        gbIndent.Enabled := ok;
        lblIndent.Enabled := ok;
        edtIndent.Enabled := ok;
        udIndent.Enabled := ok;
        if ok then
        begin
          udIndent.Associate := edtIndent;
          udIndent.Position := FFld.Indent;
        end
        else
        begin
          udIndent.Associate := nil;
          edtIndent.Text := '';
        end;

        tmp := ok and (not cbExclude.Checked);
        lblPad.Enabled := tmp;
        edtPad.Enabled := tmp;
        udPad.Enabled := tmp;
        if tmp then
        begin
          udPad.Associate := edtPad;
          udPad.Position := FFld.Pad;
        end
        else
        begin
          udPad.Associate := nil;
          edtPad.Text := '';
        end;

        tmp := ok and (FFld.FldType = dftNumber);
        pnlNum.Visible := tmp;
        SetY(pnlNum, DefTxt);
        if tmp then
        begin
          udDefNum.Position := StrToIntDef(FFld.EditDefault, 0);
          udMinVal.Position := FFld.MinVal;
          udMaxVal.Position := FFld.MaxVal;
          udInc.Position := FFld.Increment;
        end;

        tmp := ok and (FFld.FldType = dftDate);
        pnlDate.Visible := tmp;
        SetY(pnlDate, DefTxt);
        if tmp then
        begin
          edtDateDef.Text := FFld.EditDefault;
          cbxDateType.SelectByID(TemplateFieldDateCodes[FFld.DateType]);
        end;

        tmp := ok and (FFld.FldType in ItemDfltTypes);
        cbxDefault.Visible := tmp;
        SetY(cbxDefault, DefTxt);

        tmp := ok and (FFld.FldType = dftHyperlink);
        edtURL.Visible := tmp;
        SetY(edtURL, 'Address:');
        if tmp then
          edtURL.Text := FFld.URL;

        tmp := ok and (FFld.FldType in FldItemTypes);
        reItems.Visible := tmp;
        lblLine.Visible := tmp;
        lblCol.Visible := tmp;
        if tmp then
        begin
          if FFld.FldType = dftWP then
            wpTxt := DefTxt
          else
            wpTxt := 'Items:';
        end
        else
          wpTxt := '';
        SetY(reItems, wpTxt);
        if tmp then
          reItems.Lines.Text := FFld.Items
        else
          reItems.Clear;

      if ok then
      begin
        if FFld.CommunityCare then
          lblCommCareLock.Visible := True
        else
          lblCommCareLock.Visible := False;
        end

      finally
        pnlSwap.EnableAlign;
      end;

      SetLbl('');
      SetLbl('');
      SetLbl('');
      SyncItems(FALSE);
      FormResize(Self);
    finally
      FUpdating := FALSE;
    end;
  end;
end;

procedure TfrmTemplateFieldEditor.SyncItems(DoUpdate: boolean = TRUE);
var
  i, idx, Siz, Max1, Max2: integer;
  ChangeSizes: boolean;

begin
  if DoUpdate and FUpdating then
    exit;
  Max1 := 0;
  Max2 := 0;
  ChangeSizes := FALSE;
  FUpdating := TRUE;
  try
    cbxDefault.Items.Assign(reItems.Lines);
    idx := -1;
    if(assigned(FFld)) and reItems.Visible and cbxDefault.Visible then
    begin
      ChangeSizes := TRUE;
      for i := 0 to reItems.Lines.Count-1 do
      begin
        Siz := length(StripEmbedded(reItems.Lines[i]));
        if Max1 < Siz then
          Max1 := Siz;
        if(idx < 0) and (FFld.ItemDefault = reItems.Lines[i]) then
          idx := i;
      end;
      Max2 := Max1;
      if Max1 > MaxTFEdtLen then
        Max1 := MaxTFEdtLen;
    end;
    cbxDefault.ItemIndex := idx;
  finally
    FUpdating := FALSE;
  end;
  if ChangeSizes and DoUpdate then
  begin
    udLen.Position := Max1;
    if (not udTextLen.Enabled) or
       ((udTextLen.Position > 0) and (udTextLen.Position < Max2)) then
      udTextLen.Position := Max2;
  end;
end;

procedure TfrmTemplateFieldEditor.cbxObjsNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
var
  tmp: TORStringList;
  i, idx: Integer;
begin
  tmp := TORStringList.Create;
  try
    SubSetOfTemplateFields(StartFrom, Direction, tmp);
    for i := 0 to FDeleted.Count - 1 do
      begin
        idx := tmp.IndexOfPiece(Piece(FDeleted[i], U, 1), U, 1);
        if (idx >= 0) then
          tmp.delete(idx);
      end;
    ConvertCodes2Text(tmp, FALSE);
    cbxObjs.ForDataUse(tmp);
  finally
    FreeAndNil(tmp);
  end;
end;

procedure TfrmTemplateFieldEditor.FormCreate(Sender: TObject);
var
  i: integer;
  Child: TControl;
  Overage: integer;
begin
  FDeleted := TORStringList.Create;
  FHideSynonyms := TRUE;
  cbxObjs.InitLongList('');
  cbxObjs.ItemHeight := 15;
  UpdateControls;
  ResizeAnchoredFormToFont(self);
  //ResizeAnchoredFormToFont does the pnlObjInfo panel wrong.  So we fix it here.
  gbMisc.Top := pnlObjInfo.ClientHeight - gbMisc.Height - 5;
  gbIndent.Top := gbMisc.Top;
  edtLMText.Top := gbMisc.Top - edtLMText.Height - 2;
  lblLM.Top := edtLMText.Top + 5;
  pnlSwap.Height := lblLM.Top - pnlSwap.Top;
  Overage := edtName.Left + edtName.Width - pnlObjInfo.ClientWidth - 4;
  for i := 0 to pnlObjInfo.ControlCount-1 do begin
    Child := pnlObjInfo.Controls[i];
    if (akRight in Child.Anchors) then begin
      if (akLeft in Child.Anchors) then
        Child.Width := Child.Width - Overage
      else
        Child.Left := Child.Left - Overage;
    end;
  end;
  EnableButtons;
end;

procedure TfrmTemplateFieldEditor.cbxObjsChange(Sender: TObject);
begin
  if(cbxObjs.ItemIEN <> 0) then
    SetFld(GetTemplateField(cbxObjs.ItemID, TRUE))
  else
    SetFld(nil);
  UpdateControls;
  IsCommunityCare;
end;

procedure TfrmTemplateFieldEditor.edtNameChange(Sender: TObject);
var
  ok: boolean;

begin
  if(not FUpdating) and (assigned(FFld)) then
  begin
    if (not FFld.NameChanged) and (not FFld.NewField) then
    begin
      ok := InfoBox('*** WARNING ***' + CRLF + CRLF +
        'This template field has been saved, and may have been used in one or more' + CRLF +
        'boilerplates.  Boilerplates can be found in templates, titles, reasons for request' + CRLF +
        'and reminder dialogs.  Renaming this template field will cause any boilerplates' + CRLF +
        'that use it to no longer function correctly.' + CRLF + CRLF +
        'Are you sure you want to rename the ' + FFld.FldName + ' template field?',
        'Warning', MB_YESNO or MB_ICONWARNING) = IDYES;
      if ok then
        InfoBox('Template field will be renamed when OK or Apply is pressed.', 'Information', MB_OK or MB_ICONINFORMATION)
      else
      begin
        FUpdating := TRUE;
        try
          edtName.Text := FFld.FldName;
        finally
          FUpdating := FALSE;
        end;
      end;
    end
    else
      ok := TRUE;
    if ok then
    begin
      FFld.FldName := edtName.Text;
      edtName.Text := FFld.FldName;
      FChangesPending := TRUE;
      ResetListEntry;
    end;
  end;
end;

procedure TfrmTemplateFieldEditor.cbxTypeChange(Sender: TObject);
begin
  if(not FUpdating) and (assigned(FFld)) then
  begin
    if(cbxType.ItemIndex < 0) then
    begin
      FUpdating := TRUE;
      try
        cbxType.ItemIndex := 0;
      finally
        FUpdating := FALSE;
      end;
    end;
    FFld.FldType := TTemplateFieldType(cbxType.ItemIndex);
  end;
  EnableButtons;
  UpdateControls;
end;

procedure TfrmTemplateFieldEditor.edtLenChange(Sender: TObject);
var
  v: integer;
  ok: boolean;

begin
  EnsureText(edtLen, udLen);
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType in (EditLenTypes))) then
  begin
    EnsureText(edtLen, udLen);
    FFld.MaxLen := udLen.Position;
    udLen.Position := FFld.MaxLen;
    if edtDefault.Visible then
    begin
      edtDefault.MaxLength := FFld.MaxLen;
      edtDefault.Text := copy(edtDefault.Text,1,FFld.MaxLen);
    end;
    case FFLd.FldType of
      dftEditBox:  ok := TRUE;
      dftComboBox: ok := (udTextLen.Position > 0);
      else         ok := FALSE;
    end;
    if ok then
    begin
      v := udLen.Position;
      if udTextLen.Position < v then
        udTextLen.Position := v;
    end;
  end;
end;

procedure TfrmTemplateFieldEditor.edtDefaultChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType in EditDfltType2)) then
  begin
    FFld.EditDefault := TEdit(Sender).Text;
    TEdit(Sender).Text := FFld.EditDefault;
  end;
end;

procedure TfrmTemplateFieldEditor.cbxDefaultChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType in ItemDfltTypes)) then
  begin
    FFld.ItemDefault := cbxDefault.Text;
    SyncItems;
  end;
end;

procedure TfrmTemplateFieldEditor.edtLMTextChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.LMText := edtLMText.Text;
    edtLMText.Text := FFld.LMText;
  end;
end;

procedure TfrmTemplateFieldEditor.cbActiveClick(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.Inactive := cbActive.Checked;
    cbActive.Checked := FFld.Inactive;
    FChangesPending := TRUE;
    //ResetListEntry;
  end;
end;

procedure TfrmTemplateFieldEditor.acNewExecute(Sender: TObject);
begin
  SetFld(TTemplateField.Create(nil));
  if(assigned(FFld)) then
  begin
    FChangesPending := TRUE;
    if cbxObjs.ShortCount = 0 then
    begin
      cbxObjs.Items.Insert(0,LLS_LINE);
      cbxObjs.Items.Insert(1,'');
    end;
    if(assigned(CopyFld)) then
      FFld.Assign(CopyFld);
    cbxObjs.Items.Insert(0,FFld.ID + U + FFld.FldName);
    cbxObjs.SelectByID(FFld.ID);
    cbxObjsChange(nil);
    if(assigned(FFld)) then
      edtName.SetFocus;
  end
  else
    UpdateControls;
end;
procedure TfrmTemplateFieldEditor.btnOKClick(Sender: TObject);
begin
  SaveChanges;
end;

procedure TfrmTemplateFieldEditor.btnApplyClick(Sender: TObject);
var
  tmp: string;
begin
  SaveChanges;
  cbxObjs.Clear;
  if assigned(FFld) then
    tmp := FFld.FldName
  else
    tmp := '';
  cbxObjs.InitLongList(tmp);
  cbxObjs.ItemIndex := 0;
  cbxObjsChange(cbxObjs);
end;

procedure TfrmTemplateFieldEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  ans: word;

begin
  if(AnyTemplateFieldsModified) then
  begin
    ans := InfoBox('Save Changes?', 'Confirmation', MB_YESNOCANCEL or MB_ICONQUESTION);
    if(ans = IDCANCEL) then
      CanClose := FALSE
    else
    if(ans = IDYES) then
      CanClose := SaveChanges;
  end;
end;

procedure TfrmTemplateFieldEditor.btnCancelClick(Sender: TObject);
var
  i: integer;

begin
  for i := 0 to FDeleted.Count-1 do
    UnlockTemplateField(Piece(FDeleted[i],U,1));
  FDeleted.Clear;
  ClearModifiedTemplateFields;
end;

function TfrmTemplateFieldEditor.SaveChanges: boolean;
var
  ans: word;
  Errors: string;
  i: integer;

begin
  for i := 0 to FDeleted.Count-1 do
    DeleteTemplateField(Piece(FDeleted[i],U,1));
  FDeleted.Clear;
  Result := TRUE;
  Errors := SaveTemplateFieldErrors;
  if(Errors <> '') then
  begin
    ans := InfoBox(Errors + CRLF + CRLF + 'Cancel changes to these Template Fields?',
      'Confirmation', MB_YESNO or MB_ICONQUESTION);
    if(ans = IDYES) then
      ClearModifiedTemplateFields
    else
      Result := FALSE;
  end;
  if(FChangesPending) then
    FReloadChanges := TRUE;
end;

procedure TfrmTemplateFieldEditor.reItemsChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType in FldItemTypes)) then
  begin
    FFld.Items := reItems.Lines.Text;
    SyncItems;
  end;
end;

procedure TfrmTemplateFieldEditor.cbHideClick(Sender: TObject);
begin
  SetHideSynonyms(cbHide.Checked);
end;

procedure TfrmTemplateFieldEditor.edtNameExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> btnDelete) then
    VerifyName;
end;

procedure TfrmTemplateFieldEditor.VerifyName;
var
  bad: boolean;

begin
  if assigned(FFld) then
  begin
    if FDeleted.IndexOfPiece(FFld.FldName, U, 2) >= 0 then
    begin
      ShowMsg('Template field can not be named the same as a deleted' + CRLF +
                  'field until OK or Apply has been pressed.');
      bad := TRUE;
    end
    else
      bad := TemplateFieldNameProblem(FFld);
    if bad then
      edtName.SetFocus;
  end;
end;

procedure TfrmTemplateFieldEditor.acCopyExecute(Sender: TObject);
begin
  if assigned(FFld) then
  begin
    CopyFld := FFld;
    try
      acNew.Execute;
    finally
      CopyFld := nil;
    end;
  end;
end;

procedure TfrmTemplateFieldEditor.SetFld(const Value: TTemplateField);
begin
  FFld := Value;
  EnableButtons;
end;

procedure TfrmTemplateFieldEditor.acDeleteExecute(Sender: TObject);
var
  idx: integer;
  ok: boolean;
  Answer: word;
  txt: string;
  btns: TMsgDlgButtons;

begin
  if assigned(FFld) then
  begin
    ok := (FFld.NewField);
    if not ok then
    begin
      btns := [mbYes, mbNo];
      if FFld.Inactive then
        txt := ''
      else
      begin
        txt := '  Rather than deleting, you may want' + CRLF +
               'to inactivate this template field instead.  You may inactivate this template by' + CRLF +
               'pressing the Ignore button now.';
        include(btns, mbIgnore);
      end;
      Answer := MessageDlg('*** WARNING ***' + CRLF + CRLF +
                    'This template field has been saved, and may have been used in one or more' + CRLF +
                    'boilerplates.  Boilerplates can be found in templates, titles, reasons for request' + CRLF +
                    'and reminder dialogs.  Deleting this template field will cause any boilerplates' + CRLF +
                    'that use it to no longer function correctly.' + txt + CRLF + CRLF +
                    'Are you sure you want to delete the ' + FFld.FldName + ' template field?',
                     mtWarning, btns, 0);
      ok := (Answer = mrYes);
      if(Answer = mrIgnore) then
        cbActive.Checked := TRUE;
    end;
    if ok then
    begin
      if(FFld.NewField or FFld.CanModify) then
      begin
        if FFld.NewField then
        begin
          idx := cbxObjs.ItemIndex;
          cbxObjs.ItemIndex := -1;
          cbxObjs.Items.Delete(idx);
          if (cbxObjs.Items.Count > 1) and (cbxObjs.Items[0] = LLS_LINE) then
          begin
            cbxObjs.Items.Delete(1);
            cbxObjs.Items.Delete(0);
          end;
        end
        else
        begin
          FDeleted.Add(FFld.ID + U + FFld.FldName);
          cbxObjs.ItemIndex := -1;
        end;
      end;
      FFld.Free;
      SetFld(nil);
      UpdateControls;
      cbxObjs.InitLongList('');
      FChangesPending := TRUE;
    end;
  end;
end;

procedure TfrmTemplateFieldEditor.ResetListEntry;
var
  txt: string;

begin
  if(assigned(FFld) and FFld.NewField and (cbxObjs.ItemIndex >= 0)) then
  begin
    txt := FFld.ID + U + FFld.FldName;
    //if(FFld.Inactive) then
      //txt := txt + ' <Inactive>';
    cbxObjs.Items[cbxObjs.ItemIndex] := txt;
    cbxObjs.ItemIndex := cbxObjs.ItemIndex;
  end;
end;

procedure TfrmTemplateFieldEditor.acPreviewExecute(Sender: TObject);
var
  TmpSL: TStringList;

begin
  if(assigned(FFld)) then
  begin
    TmpSL := TStringList.Create;
    try
      TmpSL.Add(TemplateFieldBeginSignature + FFld.FldName + TemplateFieldEndSignature);
      CheckBoilerplate4Fields(TmpSL, 'Preview Template Field: ' + FFld.FldName, TRUE);
    finally
      TmpSL.Free;
    end;
  end;
end;

function TfrmTemplateFieldEditor.IsCommunityCare: boolean;

 procedure ApplyCommunityCareLock(AllowEdit: Boolean; aCtrl: TWinControl);
 var
  I:integer;

 begin
  for i := 0 to aCtrl.ControlCount - 1 do
  begin
   if aCtrl.Controls[i] is TWinControl then
   begin
    if TWinControl(aCtrl.Controls[i]).ControlCount > 0 then
     ApplyCommunityCareLock(AllowEdit, TWinControl(aCtrl.Controls[i]));

     TWinControl(aCtrl.Controls[i]).Enabled := AllowEdit;
   end;
  end;
 end;

var
 HasAccess: Boolean;
begin
  if assigned(FFld) then
    HasAccess := FFld.CommunityCare
  else
    HasAccess := False;
 Result := not HasAccess;
 if HasAccess then
   ApplyCommunityCareLock(not HasAccess, pnlRight);
 btnOK.Enabled := not HasAccess;
 btnApply.Enabled := not HasAccess;
end;

procedure TfrmTemplateFieldEditor.EnableButtons;
begin
  acCopy.Enabled := assigned(FFld) and not FFld.CommunityCare;
//  btnCopy.Enabled := assigned(FFld) and not FFld.CommunityCare;
//  mnuCopy.Enabled := btnCopy.Enabled;
  acDelete.Enabled := btnCopy.Enabled; // (assigned(FFld) and FFld.NewField);
//  btnDelete.Enabled := btnCopy.Enabled; // (assigned(FFld) and FFld.NewField);
//  mnuDelete.Enabled := btnDelete.Enabled;
  acPreview.Enabled := assigned(FFld) and (FFld.FldType <> dftUnknown);
//  btnPreview.Enabled := assigned(FFld) and (FFld.FldType <> dftUnknown);
//  mnuPreview.Enabled := btnPreview.Enabled;
  acCheckForErrors.Enabled := assigned(FFld) and (FFld.FldType <> dftUnknown);
//  btnErrorCheck.Enabled := assigned(FFld) and (FFld.FldType <> dftUnknown);
//  mnuErrorCheck.Enabled := btnErrorCheck.Enabled;
  mnuErrorCheck2.Enabled := btnErrorCheck.Enabled;
end;

procedure TfrmTemplateFieldEditor.acActionExecute(Sender: TObject);
var
  p: TPoint;
begin
  inherited;
  EnableButtons;
  p := tbMnuAction.ClientToScreen(TPoint.Create(0,0));
  popMain.Popup(p.X,p.Y + pnlTop.Height);
end;

procedure TfrmTemplateFieldEditor.cbRequiredClick(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.Required := cbRequired.Checked;
    cbRequired.Checked := FFld.Required;
  end;
end;

procedure TfrmTemplateFieldEditor.FormDestroy(Sender: TObject);
begin
  FDeleted.Free;
  if(assigned(frmTemplateFields)) then begin
    frmTemplateFields.FRee;
    frmTemplateFields := nil;
  end; {if}

end;

procedure TfrmTemplateFieldEditor.SetHideSynonyms(const Value: boolean);
begin
  FHideSynonyms := Value;
  cbxObjs.HideSynonyms := FALSE; // Refresh Display
  cbxObjs.HideSynonyms := TRUE;
end;

procedure TfrmTemplateFieldEditor.cbxObjsSynonymCheck(Sender: TObject;
  const Text: String; var IsSynonym: Boolean);
begin
  if not FHideSynonyms then
    IsSynonym := FALSE;
  if(FDeleted.Count > 0) and (FDeleted.IndexOfPiece(Text,U,2) >= 0) then
    IsSynonym := TRUE;
end;

procedure TfrmTemplateFieldEditor.popTextPopup(Sender: TObject);
var
  HasText, CanEdit, isre: boolean;
  ce: TCustomEdit;
  ShowTempField: boolean;

begin
  ce := GetPopupControl;
  if assigned(ce) then
  begin
    isre := (ce is TRichEdit);
    CanEdit := (not TORExposedCustomEdit(ce).ReadOnly);
    mnuBPUndo.Enabled := (CanEdit and (ce.Perform(EM_CANUNDO, 0, 0) <> 0));
    if isre then
      HasText := (TRichEdit(ce).Lines.Count > 0)
    else
      HasText := (Text <> '');
    mnuBPSelectAll.Enabled := HasText;
    mnuBPCopy.Enabled := HasText and (ce.SelLength > 0);
    mnuBPPaste.Enabled := (CanEdit and Clipboard.HasFormat(CF_TEXT));
    mnuBPCut.Enabled := (CanEdit and HasText and (ce.SelLength > 0));
    ShowTempField := FALSE;
    if CanEdit then
      if (not assigned(frmTemplateFields)) or
         (assigned(frmTemplateFields) and not frmTemplateFields.Visible) then
        if (ce = reItems) or
           (ce = edtDefault) then
          ShowTempField := TRUE;
    mnuInsertTemplateField.Enabled := ShowTempField;
  end
  else
  begin
    isre := FALSE;
    HasText := FALSE;
    CanEdit := FALSE;
    mnuBPPaste.Enabled := FALSE;
    mnuBPCopy.Enabled := FALSE;
    mnuBPCut.Enabled := FALSE;
    mnuBPSelectAll.Enabled := FALSE;
    mnuBPUndo.Enabled := FALSE;
    mnuInsertTemplateField.Enabled := FALSE;
  end;

  mnuBPSpellCheck.Visible := isre;
  mnuBPCheckGrammar.Visible := isre;

  if isre and HasText and CanEdit then
  begin
    mnuBPSpellCheck.Enabled   := SpellCheckAvailable;
    mnuBPCheckGrammar.Enabled := SpellCheckAvailable;
  end
  else
  begin
    mnuBPSpellCheck.Enabled   := FALSE;
    mnuBPCheckGrammar.Enabled := FALSE;
  end;
end;

function TfrmTemplateFieldEditor.GetPopupControl: TCustomEdit;
begin
  if assigned(popText.PopupComponent) and (popText.PopupComponent is TCustomEdit) then
    Result := TCustomEdit(popText.PopupComponent)
  else
    Result := nil;
end;

procedure TfrmTemplateFieldEditor.mnuBPUndoClick(Sender: TObject);
var
  ce: TCustomEdit;

begin
  ce := GetPopupControl;
  if assigned(ce) then
    ce.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmTemplateFieldEditor.mnuBPCutClick(Sender: TObject);
var
  ce: TCustomEdit;
  
begin
  ce := GetPopupControl;
  if assigned(ce) then
    ce.CutToClipboard;
end;

procedure TfrmTemplateFieldEditor.mnuBPCopyClick(Sender: TObject);
var
  ce: TCustomEdit;
  
begin
  ce := GetPopupControl;
  if assigned(ce) then
    ce.CopyToClipboard;
end;

procedure TfrmTemplateFieldEditor.mnuBPPasteClick(Sender: TObject);
var
  ce: TCustomEdit;
  
begin
  ce := GetPopupControl;
  if assigned(ce) then
    ce.SelText := Clipboard.AsText;
end;

procedure TfrmTemplateFieldEditor.mnuBPSelectAllClick(Sender: TObject);
var
  ce: TCustomEdit;

begin
  ce := GetPopupControl;
  if assigned(ce) then
    ce.SelectAll;
end;

procedure TfrmTemplateFieldEditor.mnuBPCheckGrammarClick(Sender: TObject);
var
  ce: TCustomEdit;

begin
  ce := GetPopupControl;
  if(assigned(ce) and (ce is TRichEdit)) then
    GrammarCheckForControl(TRichEdit(ce));
end;

procedure TfrmTemplateFieldEditor.mnuBPSpellCheckClick(Sender: TObject);
var
  ce: TCustomEdit;

begin
  ce := GetPopupControl;
  if(assigned(ce) and (ce is TRichEdit)) then
    SpellCheckForControl(TRichEdit(ce));
end;

procedure TfrmTemplateFieldEditor.cbSepLinesClick(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.SepLines := cbSepLines.Checked;
    cbSepLines.Checked := FFld.SepLines;
  end;
end;

procedure TfrmTemplateFieldEditor.edtpopControlEnter(Sender: TObject);
begin
  popText.PopupComponent := TComponent(Sender);
  if assigned(frmTemplateFields) then
    begin
    if ((Sender = reItems) or (Sender = edtDefault)) then
      begin
      frmTemplateFields.btnInsert.Enabled := TRUE;
      if Sender = reItems then
        frmTemplateFields.re := reItems
      else
        frmTemplateFields.re := edtDefault;
      end
    else
      frmTemplateFields.btnInsert.Enabled := FALSE;
    end;
end;

procedure TfrmTemplateFieldEditor.cbxObjsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_DELETE) and btnDelete.Enabled then
    acDelete.Execute;
end;

procedure TfrmTemplateFieldEditor.edtTextLenChange(Sender: TObject);
var
  v: integer;

begin
  EnsureText(edtTextLen, udTextLen);
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType in EditLenTypes)) then
  begin
    FFld.TextLen := udTextLen.Position;
    udTextLen.Position := FFld.TextLen;
    if FFld.FldType = dftEditBox then
    begin
      v := udTextLen.Position;
      if udLen.Position > v then
        udLen.Position := v;
    end;
  end;
end;

procedure TfrmTemplateFieldEditor.edtDefNumChange(Sender: TObject);
var
  v: integer;

begin
  EnsureText(edtDefNum, udDefNum);
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType = dftNumber)) then
  begin
    FFld.EditDefault := IntToStr(udDefNum.Position);
    udDefNum.Position := StrToIntDef(FFld.EditDefault, 0);
    v := udDefNum.Position;
    if udMinVal.Position > v then
      udMinVal.Position := v;
    if udMaxVal.Position < v then
      udMaxVal.Position := v;
  end;
end;

procedure TfrmTemplateFieldEditor.edtMinValChange(Sender: TObject);
var
  v: integer;

begin
  EnsureText(edtMinVal, udMinVal);
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType = dftNumber)) then
  begin
    FFld.MinVal := udMinVal.Position;
    udMinVal.Position := FFld.MinVal;
    v := udMinVal.Position;
    if udDefNum.Position < v then
      udDefNum.Position := v;
    if udMaxVal.Position < v then
      udMaxVal.Position := v;
  end;
end;

procedure TfrmTemplateFieldEditor.edtMaxValChange(Sender: TObject);
var
  v: integer;

begin
  EnsureText(edtMaxVal, udMaxVal);
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType = dftNumber)) then
  begin
    FFld.MaxVal := udMaxVal.Position;
    udMaxVal.Position := FFld.MaxVal;
    v := udMaxVal.Position;
    if udDefNum.Position > v then
      udDefNum.Position := v;
    if udMinVal.Position > v then
      udMinVal.Position := v;
  end;
end;

procedure TfrmTemplateFieldEditor.edtIncChange(Sender: TObject);
begin
  EnsureText(edtInc, udInc);
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType = dftNumber)) then
  begin
    FFld.Increment := udInc.Position;
    udInc.Position := FFld.Increment;
  end;
end;

procedure TfrmTemplateFieldEditor.edtURLChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType = dftHyperlink)) then
  begin
    FFld.URL := edtURL.Text;
    edtURL.Text := FFld.URL;
  end;
end;

procedure TfrmTemplateFieldEditor.edtPadChange(Sender: TObject);
begin
  EnsureText(edtPad, udPad);
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.Pad := udPad.Position;
    udPad.Position := FFld.Pad;
  end;
end;

procedure TfrmTemplateFieldEditor.edtIndentChange(Sender: TObject);
begin
  EnsureText(edtIndent, udIndent);
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.Indent := udIndent.Position;
    udIndent.Position := FFld.Indent;
  end;
end;

procedure TfrmTemplateFieldEditor.reNotesChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld)) and FFld.CanModify) then
    FFld.Notes := reNotes.Lines.Text;
end;

procedure TfrmTemplateFieldEditor.cbxDateTypeChange(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld)) and (FFld.FldType = dftDate)) then
  begin
    if cbxDateType.ItemIndex >= 0 then
      FFld.DateType := TTmplFldDateType(cbxDateType.ItemIndex + 1)
    else
      FFld.DateType := dtDate;
    cbxDateType.SelectByID(TemplateFieldDateCodes[FFld.DateType]);
  end;

end;

procedure TfrmTemplateFieldEditor.cbExcludeClick(Sender: TObject);
begin
  if((not FUpdating) and (assigned(FFld))) then
  begin
    FFld.SepLines := cbExclude.Checked;
    cbExclude.Checked := FFld.SepLines;
    UpdateControls;
  end;
end;

procedure TfrmTemplateFieldEditor.FormResize(Sender: TObject);
begin
  LimitEditWidth(reItems, 240);
  LimitEditWidth(reNotes, MAX_ENTRY_WIDTH);
end;

procedure TfrmTemplateFieldEditor.reItemsResizeRequest(Sender: TObject;
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
    FormResize(Self);
  end;
end;

procedure TfrmTemplateFieldEditor.reItemsSelectionChange(Sender: TObject);
var
  p: TPoint;

begin
  if lblLine.Visible then
  begin
    p := reItems.CaretPos;
    lblLine.Caption := 'Line: ' + inttostr(p.y + 1);
    lblCol.Caption  := 'Col: ' + inttostr(p.x + 1);
  end;
end;

procedure TfrmTemplateFieldEditor.mnuInsertTemplateFieldClick(Sender: TObject);
var
  iCon: TCustomEdit;
  ShowButton: boolean;
begin
  iCon := GetPopupControl;
  if iCon <> nil then
    begin
    if (not Assigned(ActiveControl)) or (iCon.Name <> ActiveControl.Name) then
      begin
      ActiveControl := iCon;
      iCon.SelStart := iCon.SelLength;
      end;
    if (not assigned(frmTemplateFields)) then
      begin
      frmTemplateFields := TfrmTemplateFields.Create(Self);
      frmTemplateFields.Font := Font;
      end;
    ShowButton := False;
    if iCon = reItems then
      begin
      frmTemplateFields.re := reItems;
      ShowButton := TRUE;
      end
    else if iCon = edtDefault then
      begin
      frmTemplateFields.re := edtDefault;
      ShowButton := TRUE;
      end;
    frmTemplateFields.btnInsert.Enabled := ShowButton;

    frmTemplateFields.Show;
    end

end;

procedure TfrmTemplateFieldEditor.acCheckAllExecute(Sender: TObject);
begin
  inherited;
  RunTemplateErrorReport(True);
end;

procedure TfrmTemplateFieldEditor.acCheckForErrorsExecute(Sender: TObject);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    fFld.ErrorCheckText(sl);
    if pos('|', sl.Text) > 0 then
      InfoBox('Patient Data Object Delimiter "|" found.' + CRLF +
        'Patient Data Objects do not function inside Template Fields.','Error',
        MB_OK or MB_ICONINFORMATION)
    else
      if BoilerplateTemplateFieldsOK(sl.Text, 'OK') then
        InfoBox('No Errors Found.','Error Check', MB_OK or MB_ICONINFORMATION);
  finally
    sl.free;
  end;
end;

procedure TfrmTemplateFieldEditor.ControlExit(Sender: TObject);
begin
  if assigned(frmTemplateFields) then
    frmTemplateFields.btnInsert.Enabled := FALSE;
end;

procedure TfrmTemplateFieldEditor.reNotesKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
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

end.
