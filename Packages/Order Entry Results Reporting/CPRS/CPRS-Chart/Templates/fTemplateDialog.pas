unit fTemplateDialog;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, AppEvnts, uTemplates, fBase508Form, uConst,
  VA508AccessibilityManager, ORDtTm
  , mRequiredFieldsNavigator, Vcl.ComCtrls,
  Vcl.Menus, U_CPTEditMonitor, U_CPTPasteDetails,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, System.Variants,
  Vcl.DBCtrls, uCore, fBaseDynamicControlsForm;

type
  TfrmTemplateDialog = class(TfrmBaseDynamicControlsForm)
    sbMain: TScrollBox;
    splFields: TSplitter;
    grdpnlBottom: TGridPanel;
    btnAllGrid: TButton;
    btnNoneGrid: TButton;
    btnPreviewGrid: TButton;
    btnOKGrid: TButton;
    btnCancelGrid: TButton;
    pnlDebug: TPanel;
    reText: ORExtensions.TRichEdit;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    T1: TMenuItem;
    N1: TMenuItem;
    S4: TMenuItem;
    pnlBottomGrid: TPanel;
    pnlBottomLeft: TPanel;
    pnlBottomRight: TPanel;
    pnlBtnTop: TPanel;
    pnlBtnBottom: TPanel;
    CPTemp: TCopyEditMonitor;
    Panel1: TPanel;
    StaticText1: TStaticText;
    btnDebug: TButton;
    btnFields: TButton;
    PopupMenu2: TPopupMenu;
    Highlight1: TMenuItem;
    splDebug: TSplitter;
    cbCdsFieldsRequired: TCheckBox;
    dbgControls: TDBGrid;
    pnlTables: TPanel;
    pnlText: TPanel;
    edTarget: TEdit;
    cbText: TCheckBox;
    procedure btnAllClick(Sender: TObject);
    procedure btnNoneClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure S1Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure S4Click(Sender: TObject);
    procedure btnDebugClick(Sender: TObject);
    procedure edTargetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFieldsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Highlight1Click(Sender: TObject);
    procedure cbCdsFieldsRequiredClick(Sender: TObject);
    procedure cbTextClick(Sender: TObject);
  private
    frRequiredFields: TRequiredFieldsFrame; // NSR20100706 AA 2015/09/29
    FFirstBuild: boolean;
    FTIUParam: Integer; // 20100706 - VISTAOR-24208 FH 2021/02/12
    SL: TStrings;
    BuildIdx: TStringList;
    Entries: TStringList;
    NoTextID: TStringList;
    Index: string;
    OneOnly: boolean;
    Count: integer;  // number of dialog controls
    RepaintBuild: boolean;
    FirstIndent: integer;
    FBuilding: boolean;
    FOldHintEvent: TShowHintEvent;
    FMaxPnlWidth: integer;
    FTabPos: integer;
    FCheck4Required: boolean;
    FSilent: boolean;
    procedure ChkAll(Chk: Boolean);
    procedure BuildCB(CBidx: integer; var Y: integer; FirstTime: boolean);
    procedure ItemChecked(Sender: TObject);
    procedure BuildAllControls;
    procedure AppShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: Controls.THintInfo);
    procedure FieldChanged(Sender: TObject);
    procedure EntryDestroyed(Sender: TObject);
    function GetObjectID( Control: TControl): string;
    function GetParentID( Control: TControl): string;
    function FindObjectByID( id: string): TControl;
    function IsAncestor( OldID: string; NewID: string): boolean;
    procedure ParentCBEnter(Sender: TObject);
    procedure ParentCBExit(Sender: TObject);
    procedure UMScreenReaderInit(var Message: TMessage); message UM_MISC;
    procedure InitScreenReaderSetup;

    procedure FieldValueChanged(Sender: TObject);  // NSR20100706 AA 2015/09/29
    procedure CMFocusChanged(var Message: TCMFocusChanged); Message CM_FocusChanged; // NSR20100706 AA 2015/09/29
    procedure UpdateControlHighlighting(ctrl:TWinControl); //NSR20100706 AA 2015/09/29
{$IFDEF DEBUG}
    procedure SetDebugInfo(aControl:TWinControl=nil); //NSR20100706 AA 2015/09/29
{$ENDIF}
  public
    property Silent: boolean read FSilent write FSilent ;

    procedure setReqHighlightAlign(aPos:Integer); // NSR20100706 AA 2015/09/29
    procedure setReqHighlightColor; // NSR20100706 AA 2015/09/29
    procedure AdjustFormToFontSize(aSize:Integer); // NSR20100706 AA 2015/09/29

    procedure UM_UpdateRequiredFieldsCount(var Message: TMessage); message UM_UpdateRFN;
    procedure setDebugLayout;
    procedure updateTemplate;

{$IFDEF DEBUG}
    procedure DebugHighlight(aControl: TWinControl);
{$ENDIF}

  published
  end;

// Returns True if Cancel button is pressed
function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE; ExtCPMon: TCopyPasteDetails = nil): boolean;
procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; PreviewMode: boolean = FALSE; ExtCPMon: TCopyPasteDetails = nil); overload;
procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; PreviewMode: boolean = FALSE; ExtCPMon: TCopyPasteDetails = nil); overload;
//procedure ShutdownTemplateDialog;  - AA: commenting out

var
  frmTemplateDialog: TfrmTemplateDialog;

implementation

uses dShared, uTemplateFields, fRptBox, uInit, rMisc, uDlgComponents,
  VA508AccessibilityRouter, VAUtils, fFrame
  , ORNet
  , fOptionsTIUTemplates
  , WinAPI.RichEdit
  , dRequiredFields
  , UResponsiveGUI;

{$R *.DFM}

var
  uTemplateDialogRunning: boolean = false;

const
  Gap = 4;
  IndentGap = 18;
  ss = ' -----------------------------------------------------------------------';

procedure GetText(SL: TStrings; IncludeEmbeddedFields: Boolean);
var
  i, p1, p2: integer;
  Txt, tmp: string;
  Save, Hidden: boolean;
  TmpCtrl: TStringList;

begin
  Txt := SL.Text;
  SL.Clear;
  TmpCtrl := TStringList.Create;
  try
    for i := 0 to frmTemplateDialog.sbMain.ControlCount-1 do
      with frmTemplateDialog.sbMain do
      begin
        tmp := IntToStr(Controls[i].Tag);
        tmp := StringOfChar('0', 7-length(tmp)) + tmp;
        TmpCtrl.AddObject(tmp, Controls[i]);
      end;
    TmpCtrl.Sort;
    for i := 0 to TmpCtrl.Count-1 do
    begin
      Save := FALSE;
      if(TmpCtrl.Objects[i] is TORCheckBox) and (TORCheckBox(TmpCtrl.Objects[i]).Checked) then
        Save := TRUE
      else
      if(frmTemplateDialog.OneOnly and (TmpCtrl.Objects[i] is TPanel)) then
        Save := TRUE;
      if(Save) then
      begin
        tmp := Piece(frmTemplateDialog.Index,U,TControl(TmpCtrl.Objects[i]).Tag);
        p1 := StrToInt(Piece(tmp,'~',1));
        p2 := StrToInt(Piece(tmp,'~',2));
        Hidden := (copy(Piece(tmp,'~',3),2,1)=BOOLCHAR[TRUE]);
        SL.Text := SL.Text + ResolveTemplateFields(Copy(Txt,p1,p2), FALSE, Hidden, IncludeEmbeddedFields);
      end;
    end;
  finally
    TmpCtrl.Free;
  end;
end;

// Returns True if Cancel button is pressed
function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE; ExtCPMon: TCopyPasteDetails = nil): boolean;
var
  i, j, idx, Indent: integer;
  DlgProps, Txt: string;
  DlgIDCounts: TStringList;
  DlgInt: TIntStruc;
  CancelDlg: Boolean;
  CancelMsg: String;

  procedure IncDlgID(var id: string); //Appends an item count in the form of id.0, id.1, id.2, etc
  var                                 //based on what is in the StringList for id.
    k: integer;

  begin
    k := DlgIDCounts.IndexOf(id);

    if (k >= 0) then
    begin
      DlgInt := TIntStruc(DlgIDCounts.Objects[k]);
      DlgInt.x := DlgInt.x + 1;
      id := id + '.' + IntToStr(DlgInt.x);
    end
    else
    begin
      DlgInt := TIntStruc.Create;
      DlgInt.x := 0;
      DlgIDCounts.AddObject(id, DlgInt);
      id := id + '.0';
    end;
  end;

  procedure CountDlgProps(var DlgID: string);  //Updates the item and parent item id's with the count
  var                                          // value id.0, id.1, id.2, id.3, etc.  The input dialog
    x: integer;                                // id is in the form 'a;b;c;d', where c is the item id
    id, pid: string;                           // and d is the parent item id

  begin
    id  := piece(DlgID,';',3);
    pid := piece(DlgID,';',4);

    if length(pid) > 0 then
      x := DlgIDCounts.IndexOf(pid)
    else
      x := -1;

    if (x >= 0) then
      begin
        DlgInt := TIntStruc(DlgIDCounts.Objects[x]);
        pid := pid + '.' + InttoStr(DlgInt.x);
      end;

    if length(id) > 0 then
      IncDlgID(id);

    SetPiece(DlgID,';',3,id);
    SetPiece(DlgID,';',4,pid);
  end;

begin
  Result := FALSE;
  CancelDlg := FALSE;
  SetTemplateDialogCanceled(FALSE);

  dmRF.ClearRequired;

  frmTemplateDialog := TfrmTemplateDialog.Create(Application);

  try
    DlgIDCounts := TStringList.Create;
    DlgIDCounts.Sorted := TRUE;
    DlgIDCounts.Duplicates := dupError;
    frmTemplateDialog.Caption := CaptionText;
    AssignFieldIDs(SL);         // assigning IDs for every template field
    frmTemplateDialog.SL := SL; // Fields IDS
    frmTemplateDialog.Index := '';
    Txt := SL.Text;
    frmTemplateDialog.OneOnly := (DelimCount(Txt, ObjMarker) = 1);
    frmTemplateDialog.Count := 0;
    idx := 1;
    frmTemplateDialog.FirstIndent := 99999;
    repeat
      i := pos(ObjMarker, Txt); // processing  ^@@^ items
      if(i > 1) then
      begin
        j := pos(DlgPropMarker, Txt);
        if(j > 0) then
          begin
            DlgProps := copy(Txt, j + DlgPropMarkerLen, (i - j - DlgPropMarkerLen));
            CountDlgProps(DlgProps);
          end
        else
          begin
            DlgProps := '';
            j := i;
          end;
        inc(frmTemplateDialog.Count);
        frmTemplateDialog.Index := frmTemplateDialog.Index +
                                   IntToStr(idx)+'~'+IntToStr(j-1)+'~'+DlgProps+U;
        inc(idx,i+ObjMarkerLen-1);
        Indent := StrToIntDef(Piece(DlgProps, ';', 5),0);
        if(frmTemplateDialog.FirstIndent > Indent) then
          frmTemplateDialog.FirstIndent := Indent;
      end;
      if(i > 0) then
        delete(txt, 1, i + ObjMarkerLen - 1);
    until (i = 0);

    if(frmTemplateDialog.Count > 0) then
    begin
      // NSR20100706 AA 2015/09/29
      { hiding frRequiredFields might be confusing as some of the fields could be disabled at opening of the dialog
      frmTemplateDialog.frRequiredFields.Visible :=
        getNumberOfMissingFields(frmTemplateDialog.sbMain)>0; left 'as is' to keep the current appearance}
      frmTemplateDialog.btnNoneGrid.Visible := not frmTemplateDialog.OneOnly;
      frmTemplateDialog.btnAllGrid.Visible := not frmTemplateDialog.OneOnly;
      frmTemplateDialog.BuildAllControls;  // build dialog controls
      frmTemplateDialog.btnOKGrid.Enabled :=
        dmRF.getNumberOfMissingFields(frmTemplateDialog.sbMain) < 1;
      frmTemplateDialog.CPTemp.RelatedPackage := 'Template: ' + CaptionText;
      repeat
         frmTemplateDialog.ShowModal;
         if(frmTemplateDialog.ModalResult = mrOK) then
           GetText(SL, TRUE)     {TRUE = Include embedded fields}
         else
          if (not PreviewMode) and (not frmTemplateDialog.Silent) and (not uInit.TimedOut) then
            begin
              CancelMsg := 'If you cancel, your changes will not be saved.  Are you sure you want to cancel?';
              if (InfoBox(CancelMsg, 'Cancel Dialog Processing', MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES) then
                begin
                  SL.Clear;
                  Result := TRUE;
                  CancelDlg := TRUE;
                end
              else
                CancelDlg := FALSE;
            end
          else
            begin
              SL.Clear;
              Result := TRUE;
              CancelDlg := TRUE;
            end;
      until CancelDlg or (frmTemplateDialog.ModalResult = mrOK)
    end
    else
      SL.Clear;
  finally
    //frmTemplateDialog.Free;    v22.11e RV
    if (Sl.Count > 0) and Assigned(ExtCPMon) then
      frmTemplateDialog.CPTemp.TransferData(ExtCPMon.EditMonitor);
    FreeAndNil(frmTemplateDialog);

// Very Important - frees up uEntries before nesting templates can create new entries.
//                  without this call the old entries are found when nesting templates.
    TResponsiveGUI.ProcessMessages;
    for i := 0 to DlgIDCounts.Count-1 do begin
      DlgIDCounts.Objects[i].Free;
    end;
    DlgIDCounts.Free;
  end;

  if Result then
    SetTemplateDialogCanceled(TRUE)
  else
  begin
    SetTemplateDialogCanceled(FALSE);
    CheckBoilerplate4Fields(SL, CaptionText, PreviewMode, ExtCPMon);
  end;
end;
{
procedure ShutdownTemplateDialog;
begin
  if uTemplateDialogRunning and assigned(frmTemplateDialog) then
  begin
    frmTemplateDialog.Silent := True;
    frmTemplateDialog.ModalResult := mrCancel;
  end;
end;
}
procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; PreviewMode: boolean = FALSE; ExtCPMon: TCopyPasteDetails = nil);
var
  i: integer;
  line: string;

begin
  for i := 0 to SL.Count - 1 do
  begin
    line := SL[i];
    if Length(line) >= 70 then
      line := TrimRight(line);
    if line = '' then
      line := ' ';
    if line <> SL[i] then
      SL[i] := line;
  end;
  while(HasTemplateField(SL.Text)) do
  begin
    if (BoilerplateTemplateFieldsOK(SL.Text)) then
    begin
      SL[SL.Count-1] := SL[SL.Count-1] + DlgPropMarker + '00100;0;-1;;0' + ObjMarker;
      DoTemplateDialog(SL, CaptionText, PreviewMode, ExtCPMon);
    end
    else
      SL.Clear;
  end;
  for i := 0 to SL.Count - 1 do
  begin
    line := SL[i];
    if Trim(line) = '' then
      line := '';
    SL[i] := line;
  end;
  StripScreenReaderCodes(SL);
end;

procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; PreviewMode: boolean = FALSE; ExtCPMon: TCopyPasteDetails = nil);
var
  tmp: TStringList;
  aTmpStr: String;
begin
  tmp := TStringList.Create;
  try
    tmp.text := AText;
    CheckBoilerplate4Fields(tmp, CaptionText, PreviewMode, ExtCPMon);
//    AText := tmp.text;
    AText := '';
        for aTmpStr in tmp do
        begin
         if AText <> '' then
          AText := AText + CRLF;
         AText := AText + aTmpStr;
        end;
  finally
    tmp.free;
  end;
end;

procedure TfrmTemplateDialog.ChkAll(Chk: Boolean);
begin
  for var I := 0 to sbMain.ControlCount - 1 do
  begin
    if sbMain.Controls[I] is TORCheckBox then
      TORCheckBox(sbMain.Controls[I]).Checked := Chk;
  end;

  if Assigned(frRequiredFields) and Assigned(frRequiredFields.FocusedControl)
    and (frRequiredFields.FocusedControl.CanFocus) then
  begin
    frRequiredFields.FocusedControl.SetFocus;
  end;
end;

procedure TfrmTemplateDialog.btnAllClick(Sender: TObject);
begin
  ChkAll(TRUE);
end;

procedure TfrmTemplateDialog.btnNoneClick(Sender: TObject);
begin
  ChkAll(FALSE);
end;

function TfrmTemplateDialog.GetObjectID( Control: TControl): string;
var
  idx, idx2: integer;
begin
  result := '';
  if Assigned(Control) then
  begin
    idx := Control.Tag;
    if(idx > 0) then
    begin
      idx2 := BuildIdx.IndexOfObject(TObject(idx));
      if idx2 >= 0 then
        result := BuildIdx[idx2]
      else
        result := Piece(Piece(Piece(Index, U, idx),'~',3), ';', 3);
    end;
  end;
end;

function TfrmTemplateDialog.GetParentID( Control: TControl): string;
var
  idx: integer;
begin
  result := '';
  if Assigned(Control) then
  begin
    idx := Control.Tag;
    if(idx > 0) then
      result := Piece(Piece(Piece(Index, U, idx),'~',3), ';', 4);
  end;
end;

function TfrmTemplateDialog.FindObjectByID( id: string): TControl;
var
  i: integer;
  ObjID: string;
begin
  result := nil;
  if ID <> '' then
  begin
    for i := 0 to sbMain.ControlCount-1 do
    begin
      ObjID := GetObjectID(sbMain.Controls[i]);
      if(ObjID = ID) then
      begin
        result := sbMain.Controls[i];
        break;
      end;
    end;
  end;
end;

procedure TfrmTemplateDialog.InitScreenReaderSetup;
var
  ctrl: TWinControl;
  list: TList;
begin
  if ScreenReaderSystemActive then
  begin
    list := TList.Create;
    try
      sbMain.GetTabOrderList(list);
      if list.Count > 0 then
      begin
        ctrl := TWinControl(list[0]);
        PostMessage(Handle, UM_MISC, WParam(ctrl), 0);
      end;
    finally
      list.free;
    end;
  end;
end;

function TfrmTemplateDialog.IsAncestor( OldID: string; NewID: string): boolean;
begin
  if (OldID = '') or (NewID = '') then
    result := False
  else if OldID = NewID then
    result := True
  else
    result := IsAncestor(OldID, GetParentID(FindObjectByID(NewID)));
end;

procedure TfrmTemplateDialog.BuildCB(CBidx: Integer; var Y: Integer; FirstTime: Boolean);
var
  bGap, Indent, i, idx, p1, p2: Integer;
  EID, id, pid, DlgProps, tmp, Txt, tmpID: string;
  pctrl, ctrl: TControl;
  pnl: TPanel;
  KillCtrl, doHint, dsp, noTextParent: Boolean;
  Entry: TTemplateDialogEntry;
  // StringIn, StringOut: string;
  cb: TCPRSDialogParentCheckBox;

  procedure NextTabCtrl(ACtrl: TControl);
  begin
    if (ACtrl is TWinControl) then
    begin
      inc(FTabPos);
      TWinControl(ACtrl).TabOrder := FTabPos;
    end;
  end;

begin
  tmp := Piece(Index, U, CBidx);      // Index:     tmp^tmp^tmp
                                      // tmp:       p1~p2~DlgProps
  p1 := StrToInt(Piece(tmp,'~',1));   //            p1 - position
  p2 := StrToInt(Piece(tmp,'~',2));   //            p2 - length
  DlgProps := Piece(tmp,'~',3);       // set of flags
                                      //            1 - visibility
                                      //            2 - Group Index (radio button?)
                                      //            3 - ?
                                      //            4 - ?
                                      //            5 - gap in CRLFs
  ID := Piece(DlgProps, ';', 3);      // DlgProps:  ...;...;ID;PID
                                      // ID links that CB with one of the sbMain Controls
  PID := Piece(DlgProps, ';', 4);

  ctrl := nil;
  pctrl := nil;
  if(PID <> '') then             // NoTextID - list of items without checkboxed parents ?
    noTextParent := (NoTextID.IndexOf(PID) < 0)
  else
    noTextParent := TRUE;        // noTextParent - no Text Parent
  if not FirstTime then          // FirstTime there are no controls - ctrl is nil
    ctrl := FindObjectByID(ID);  // find Control on sbMain by ID
                                 // - for every control on sbMain with (tag<>0)
                                 //   get the control ID from BuildIdx or from Index
                                 // - if ID is found then compare it with the original one

  if noTextParent and (pid <> '') then
    pctrl := FindObjectByID(pid);// find parent control by ID

  if (pid = '') then
    KillCtrl := FALSE            // Don't kill if no parent
  else
  begin
    if (Assigned(pctrl)) then
    begin
      if (not(pctrl is TORCheckBox)) or (copy(DlgProps, 3, 1) = BOOLCHAR[TRUE])
      then                       // show if parent is unchecked
        KillCtrl := FALSE
      else                       // Kill only if unchecked if parent is Checkbox
        KillCtrl := (not TORCheckBox(pctrl).Checked);
    end
    else
      KillCtrl := noTextParent;  // if no pctrl defined or no pctrl found in NoTextID list
                                 // use noTextParent flag
  end;

  if KillCtrl then  // Kill the ctrl with no TextParent (exclude from BuildIdx, free if exists)
  begin
    if (Assigned(ctrl)) then     // Hide Associate (the control linked to TORCheckBox)
    begin
      if (ctrl is TORCheckBox) and (Assigned(TORCheckBox(ctrl).Associate)) then
        TORCheckBox(ctrl).Associate.Hide;
      idx := BuildIdx.IndexOfObject(TObject(ctrl.Tag)); // remove ctrl from BuildIdx
      if idx >= 0 then
        BuildIdx.delete(idx);
      dmRF.RemoveChildFieldControls(TWinControl(ctrl));
      ctrl.Free;                                        // free ctrl
    end;
    exit;                       // EXIT if ctrl is killed
  end;

  tmp := copy(SL.Text, p1, p2);
  if (copy(tmp, length(tmp) - 1, 2) = CRLF) then // remove trailing CRLFs
    delete(tmp, length(tmp) - 1, 2);

  bGap := StrToIntDef(copy(DlgProps, 5, 1), 0); // remove header CRLFs
  while bGap > 0 do
  begin
    if (copy(tmp, 1, 2) = CRLF) then
    begin
      delete(tmp, 1, 2);
      dec(bGap);
    end
    else
      bGap := 0;
  end;

  if (tmp = NoTextMarker) then // '<@>'
  begin
    if (NoTextID.IndexOf(id) < 0) then
      NoTextID.Add(id); // add CB (dialog?)  ID to NoTextID list
    exit; // EXIT if the template is NoText
  end;

  if (not Assigned(ctrl)) then
  begin
    dsp := (copy(DlgProps, 1, 1) = BOOLCHAR[TRUE]); // template visibility
    EID := 'DLG' + IntToStr(CBidx);
    idx := Entries.IndexOf(EID);  // Entries - List of TTemplateDialogEntries - visible DLGnnn
    doHint := FALSE;
    Txt := tmp; // tmp holds template text without Index
    if (idx < 0) then // DLG is not found in Entries list
    begin
      if (copy(DlgProps, 2, 1) = BOOLCHAR[TRUE]) then  // GroupIndex (chop first 70 chars only?)
      begin
        i := pos(CRLF, tmp);
        if (i > 0) then
        begin
          dec(i);
          if i > 70 then
          begin
            i := 71;
            while (i > 0) and (tmp[i] <> ' ') do
              dec(i);
            if i = 0 then
              i := 70
            else
              dec(i);
          end;
          doHint := TRUE;
          tmp := copy(tmp, 1, i) + ' ...';
        end;
      end;
      Entry := GetDialogEntry(sbMain, EID, tmp); // Creates TTemplateDialogEntry
      Entry.AutoDestroyOnPanelFree := TRUE;      // top level of the template
      Entry.OnDestroy := EntryDestroyed;
      Entries.AddObject(EID, Entry);

      // Populate the Copy/Paste control
    end
    else
      Entry := TTemplateDialogEntry(Entries.Objects[idx]);

    if (dsp or OneOnly) then // if VISIBLE or only 1 ObjMarket found in Template
      cb := nil              // then no need in TCheckBox
    else                     // else create Parent Check Box
      cb := TCPRSDialogParentCheckBox.Create(Self);

    pnl := Entry.GetPanel(FMaxPnlWidth, sbMain, cb); // TDlgFieldPanel
//    pnl.BorderStyle := bsSingle;              //1022950
//    pnl.ShowCaption := True;                  //1022950
//    pnl.Alignment := taRightJustify;          //1022950
//    pnl.Name := 'pnl'+IntToStr(Integer(pnl)); //1022950
//    pnl.Width := pnl.Width + 150;             //1022950
    pnl.Show;
    if (doHint and (not pnl.ShowHint)) then
    begin
      pnl.ShowHint := TRUE;
      Entry.Obj := pnl;
      Entry.Text := Txt;
      pnl.hint := Entry.GetText;
      Entry.OnChange := FieldChanged; // tracking control changes for NSR20100706
    end
// NSR20100706 AA 2015/09/29 --------------------------------------------- begin
    else // notification on changes to the Field
      Entry.OnChange := FieldValueChanged;
// NSR20100706 AA 2015/09/29 ----------------------------------------------- end

    if not Assigned(cb) then
      ctrl := pnl
    else
    begin
// 20190702     AddParentCheckbox(Entry, cb); // NSA20100706 AA 2015/09/29
      ctrl := cb;
      ctrl.Parent := sbMain;

      TORCheckBox(ctrl).OnEnter := frmTemplateDialog.ParentCBEnter;
      TORCheckBox(ctrl).OnExit := frmTemplateDialog.ParentCBExit;

      TORCheckBox(ctrl).Height := TORCheckBox(ctrl).Height + 5;
      TORCheckBox(ctrl).Width := 17;

      { Insert next line when focus fixed }
      // ctrl.Width := IndentGap;
      { Remove next line when focus fixed }
      TORCheckBox(ctrl).AutoSize := FALSE;
      TORCheckBox(ctrl).Associate := pnl;
      pnl.Tag := Integer(ctrl); // panel Tag assigned to the ctlr (pointer)
      tmpID := copy(id, 1, (pos('.', id) - 1));
      { copy the ID without the decimal place }
      // if Templates.IndexOf(tmpID) > -1 then
      // StringIn := 'Sub-Template: ' + TTemplate(Templates.Objects[Templates.IndexOf(tmpID)]).PrintName
      // else
      // StringIn := 'Sub-Template:';
      // StringOut := StringReplace(StringIn, '&', '&&', [rfReplaceAll]);
      // TORCheckBox(ctrl).Caption := StringOut;
      UpdateColorsFor508Compliance(ctrl);

    end;
    ctrl.Tag := CBIdx;  // ctrl is TDlgFieldPanel
                        // or
                        // Template Entry parent TORCheckBox

    // adjust position for visible control
    Indent := StrToIntDef(Piece(DlgProps, ';', 5), 0) - FirstIndent;
    if dsp then
      inc(Indent);
    ctrl.Left := Gap + (Indent * IndentGap);
    // ctrl.Width := sbMain.ClientWidth - Gap - ctrl.Left - ScrollBarWidth;
    if (ctrl is TORCheckBox) then
      pnl.Left := ctrl.Left + IndentGap;

    if (ctrl is TORCheckBox) then
      with TORCheckBox(ctrl) do
      begin
        GroupIndex := StrToIntDef(Piece(DlgProps, ';', 2), 0);
        if (GroupIndex <> 0) then
          RadioStyle := TRUE; // RadioStyle for "groupped" ctrl
        OnClick := ItemChecked;
        StringData := DlgProps;
      end;

    // registration in BuildIdx list - all controls of sbMain are included
    if BuildIdx.IndexOfObject(TObject(CBIdx)) < 0 then
      BuildIdx.AddObject(Piece(Piece(Piece(Index, U, CBIdx),'~',3), ';', 3), TObject(CBIdx));
  end;

  // adjustnment of the ctrl Y position
  ctrl.Top := Y;
  // adjustmnt of the available Y position
  NextTabCtrl(ctrl);
  if(ctrl is TORCheckBox) then
  begin
    TORCheckBox(ctrl).Associate.Top := Y;
    NextTabCtrl(TORCheckBox(ctrl).Associate);
    inc(Y, TORCheckBox(ctrl).Associate.Height+1);
  end
  else
    inc(Y, ctrl.Height+1);
end;

procedure TfrmTemplateDialog.ParentCBEnter(Sender: TObject);
begin
  (Sender as TORCheckbox).FocusOnBox := true;
end;

procedure TfrmTemplateDialog.ParentCBExit(Sender: TObject);
begin
  (Sender as TORCheckbox).FocusOnBox := false;
end;

procedure TfrmTemplateDialog.ItemChecked(Sender: TObject);
begin
  if(copy(TORCheckBox(Sender).StringData,4,1) = '1') then
  begin
    RepaintBuild := TRUE;
    Invalidate;
  end;
  UpdateControlHighlighting(TCheckBox(Sender)); // NSR20100706
end;

procedure TfrmTemplateDialog.BuildAllControls;
var
  iPos,  // RTC 1022950
  i, Y: integer;
  FirstTime: boolean;

begin
  if FBuilding then exit;
  FBuilding := TRUE;
  try
    FTabPos := 0;
    FirstTime := (sbMain.ControlCount = 0);
    NoTextID.Clear;
    iPos := sbMain.VertScrollBar.Position; // RTC 1022950
    sbMain.VertScrollBar.Position := 0; // RTC 1022950

    Y := Gap - sbMain.VertScrollBar.Position;

    for i := 1 to Count do // all @@
      BuildCB(i, Y, FirstTime); // BUild CB
    if ScreenReaderSystemActive then
    begin
      amgrMain.RefreshComponents;
      TResponsiveGUI.ProcessMessages;
    end;
    CPTemp.MonitorAllAvailable;
    sbMain.VertScrollBar.Position := iPos; // RTC 1022950
  finally
    FBuilding := FALSE;
  end;

  dmRF.RefreshCdsControls(sbMain);
  dmRF.FindFocusedControl(ActiveControl);
  if Assigned(frRequiredFields) then
  begin
    frRequiredFields.RequiredTotal := dmRF.getNumberOfMissingFields(sbMain);
  end;
end;

procedure TfrmTemplateDialog.FormPaint(Sender: TObject);
begin
// RTC#122950 ------------------------------------------------------------ begin
  if RepaintBuild then
  begin
    try
      RepaintBuild := FALSE;
      BuildAllControls;
      WinApi.Windows.PostMessage(Handle, UM_UpdateRFN, 0, 0); // reset navigator status
      InitScreenReaderSetup;
      {$IFDEF DEBUG}
      SetDebugInfo(nil);
      {$ENDIF}
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;
// RTC#122950 -------------------------------------------------------------- end
end;

procedure TfrmTemplateDialog.FormShow(Sender: TObject);
begin
  inherited;
  if FFirstBuild then
  begin
    FFirstBuild := FALSE;
    InitScreenReaderSetup;
  end;
  if Assigned(frRequiredFields) then
  begin
    frRequiredFields.setAlign(ReqHighlightAlign);  // NSR20100706 AA 2015/09/29
    dmRF.HighlightControls(ReqHighlight);         // NSR20100706 AA 2015/09/29
  end;
end;

procedure TfrmTemplateDialog.FormCreate(Sender: TObject);

  procedure setupRequiredFields;                 // NSR20100706 AA 2015/09/29
  begin
    restoreHighlightOptions;

    frRequiredFields := TRequiredFieldsFrame.Create(Self);
    frRequiredFields.Parent := Self;
    frRequiredFields.adjustButtonSize(Application.MainForm.Font.Size);
    AdjustFormToFontSize(Application.MainForm.Font.Size);

    S1.Checked := ReqHighlight;

    dbgControls.DataSource := dmRF.dsControls;
 {$IFDEF DEBUG}
    N1.Visible := True;
    T1.Visible := True;
    btnFields.Visible := True;
    btnDebug.Visible := True;
{$ENDIF}
  end;

var
 DteStr: String;
begin
  uTemplateDialogRunning := True;
  FFirstBuild := TRUE;
  BuildIdx := TStringList.Create;
  Entries := TStringList.Create;
  NoTextID := TStringList.Create;
  FOldHintEvent := Application.OnShowHint;
  Application.OnShowHint := AppShowHint;
  FMaxPnlWidth := FontWidthPixel(sbMain.Font.Handle) * MAX_WRAP_WIDTH;
  SetFormPosition(Self);
  ResizeAnchoredFormToFont(Self);
  FTIUParam := StrToIntDef(systemParameters.AsType<String>('tmRequiredFldsOff'), 1);
//// 20100706 - VISTAOR-24208 FH 2021/02/12 -------------------------------- Begin
  if (FTIUParam = 0) then
  begin
    setUpRequiredFields; // NSR20100706 AA 2015/09/29
    sbMain.PopupMenu := PopupMenu1; // VISTAOR-24695
  end else begin
    sbMain.PopupMenu := nil; // VISTAOR-24695
  end;

//// 20100706 - VISTAOR-24208 FH 2021/02/12 ---------------------------------- end
  DteStr := FormatDateTime('mmddyyhhmmss', Now);
  CPTemp.ItemIEN := StrToInt64Def(DteStr, 3) * -1;
{$IFDEF DEBUG}
  pnlDebug.Width := width div 2;
{$ENDIF}
end;

procedure TfrmTemplateDialog.AppShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: Controls.THintInfo);
const
  HistHintDelay = 1200000; // 20 minutes

begin
//  if(HintInfo.HintControl.Parent = sbMain) then
    HintInfo.HideTimeout := HistHintDelay;
  if(assigned(FOldHintEvent)) then
    FOldHintEvent(HintStr, CanShow, HintInfo);
end;

procedure TfrmTemplateDialog.FormDestroy(Sender: TObject);
begin
  //Application.OnShowHint := FOldHintEvent;   v22.11f - RV - moved to OnClose
  NoTextID.Free;
  FreeEntries(Entries);
  Entries.Free;
  BuildIdx.Free;
  uTemplateDialogRunning := False;
end;

procedure TfrmTemplateDialog.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  If RectContains(sbMain.BoundsRect, SbMain.ScreenToClient(MousePos)) then
  begin
    ScrollControl(sbMain, (WheelDelta > 0));
    Handled := True;
  end;
end;

procedure TfrmTemplateDialog.FieldChanged(Sender: TObject);
begin
  with TTemplateDialogEntry(Sender) do
      TPanel(Obj).hint := GetText;
  fieldValueChanged(Sender); // notifying dialog the value have changed NSR20100706 AA 2015/09/29
end;

procedure TfrmTemplateDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Txt, tmp: string;
  i, p1, p2: Integer;
  Save: Boolean;

begin
  CanClose := TRUE;
  if FCheck4Required then
  begin
    // NSR2010706 enables OK button only if all the required fields are populated.
    // Since FCheck4Required is set TRUE by OK button this code won't be called.
    // Leaving "as is" in case it is needed for reminder dialogs processing

    FCheck4Required := FALSE;
    Txt := SL.Text;
    for i := 0 to sbMain.ControlCount - 1 do
    begin
      Save := FALSE;
      if (sbMain.Controls[i] is TORCheckBox) and
        (TORCheckBox(sbMain.Controls[i]).Checked) then
        Save := TRUE
      else if (OneOnly and (sbMain.Controls[i] is TPanel)) then
        Save := TRUE;
      if (Save) then
      begin
        tmp := Piece(index, U, sbMain.Controls[i].Tag);
        p1 := StrToInt(Piece(tmp, '~', 1));
        p2 := StrToInt(Piece(tmp, '~', 2));
        if AreTemplateFieldsRequired(copy(Txt, p1, p2)) then
          CanClose := FALSE;
      end;
    end;
    if not CanClose then
    begin
      if (FTIUParam = 1) then // 20100706 - VISTAOR-24208 FH 2021/02/12
      begin
        // To Show the original message.
        ShowMsg(MissingFieldsTxt);
        Abort;
      end else begin
        // NSR20100706 AA -------------------------------------------- begin
          i := dmRF.getNumberOfMissingFields(sbMain);
          case i of
            0:
              Txt := '';
            1:
              Txt := 'One required is not populated' + CRLF;
          else
            Txt := 'Several required fields are not populated' + CRLF;
          end;
          if i > 0 then
          begin
            ReqHighlight := TRUE;
            frRequiredFields.Visible := TRUE;
            dmRF.HighlightControls(ReqHighlight);

            frRequiredFields.acFirst.Execute; // scroll to the first blank field
            ShowMsg(Txt);
          end;
      end;
    end; // NSR20100706 AA ---------------------------------------------- end
  end;
end;

procedure TfrmTemplateDialog.btnOKClick(Sender: TObject);
begin
  FCheck4Required := TRUE;
end;

procedure TfrmTemplateDialog.btnPreviewClick(Sender: TObject);
var
  TmpSL: TStringList;

begin
  TmpSL := TStringList.Create;
  try
    FastAssign(SL, TmpSL);
    GetText(TmpSL, FALSE);  {FALSE = Do not include embedded fields}
    StripScreenReaderCodes(TmpSL);
    ReportBox(TmpSL, 'Dialog Preview', FALSE);
  finally
    TmpSL.Free;
  end;
end;

procedure TfrmTemplateDialog.EntryDestroyed(Sender: TObject);
var
  idx: integer;

begin
  idx := Entries.IndexOf(TTemplateDialogEntry(Sender).ID);
  if idx >= 0 then
    Entries.delete(idx);
end;

procedure TfrmTemplateDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.OnShowHint := FOldHintEvent;
  SaveUserBounds(Self);

  // Prevent to save if is cancel
  if ModalResult = mrOk then
    saveHighlightOptions; // NSR20100706 AA 2015/09/29
end;

procedure TfrmTemplateDialog.UMScreenReaderInit(var Message: TMessage);
var
  ctrl: TWinControl;
  item: TVA508AccessibilityItem;
begin
  ctrl := TWinControl(Message.WParam);
  // Refresh the accessibility manager entry -
  // fixes bug where first focusable check boxes weren't working correctly
  if ctrl is TCPRSDialogParentCheckBox then
  begin
    item := amgrMain.AccessData.FindItem(ctrl, FALSE);
    if assigned(item) then
      item.free;
    amgrMain.AccessData.EnsureItemExists(ctrl);
  end;
end;

// NSR20100706 AA 2015/09/29 --------------------------------------------- begin
procedure TfrmTemplateDialog.FieldValueChanged(Sender: TObject);
begin
  UpdateControlHighlighting(ActiveControl);
end;

procedure TfrmTemplateDialog.S1Click(Sender: TObject);
begin
  inherited;
  S1.Checked := not S1.Checked;
  ReqHighlight := S1.Checked;
  SaveHighlightOptions;  // Correlation between session and server
  dmRF.HighlightControls(ReqHighlight);
end;

procedure TfrmTemplateDialog.S4Click(Sender: TObject);
begin
  inherited;
  UpdateRequiredFieldsPreferences(false, CurrentPosition); // don't reload values from server
  frRequiredFields.setAlign(ReqHighlightAlign);
  setReqHighlightColor;
  S1.Checked := ReqHighlight;  // Correlation between session and server
end;



procedure TfrmTemplateDialog.CMFocusChanged(var Message: TCMFocusChanged);
var
  ctrl, pctrl: TWinControl;
  ok: boolean;

  function IsCtrlAllowed(aControl: TWinControl): boolean;
  begin
    if assigned(aControl.Parent) then
    begin
      if aControl.Parent = sbMain then
        Result := True
      else
        Result := IsCtrlAllowed(AControl.Parent);
    end
    else
      Result := False;
  end;

begin
  try
    ctrl := TWinControl(message.Sender);
    if not assigned(ctrl) then
      exit;

  // to address TORComboEdit
    ok := IsCtrlAllowed(ctrl);
    pctrl := ctrl;
    if ok then
    begin
      if ctrl is TORComboEdit then
        pctrl := ctrl.Parent
      else if ctrl is TORYearEdit then
        pctrl := ctrl.Parent;
    end;
    if Assigned(frRequiredFields) and ok then
      frRequiredFields.FocusedControl := pctrl;

  {$IFDEF DEBUG}
    Caption := ctrl.Name + ' ' +
      ctrl.ClassName +
      ' @'+IntToStr(Integer(ctrl));
    DebugHighlight(ctrl);
  {$ENDIF}
    if ok then
      dmRF.cdsControls.Locate('CTRL_OBJ', VarArrayOf([Integer(pctrl)]), []);
  finally
    inherited;
  end;
end;

function IsTemplateControl(aCtrl, aCtrlMain: TObject): boolean;
begin
  Result := False;
  if aCtrl = nil then
    Exit;
  if TWinControl(aCtrl).Parent = aCtrlMain then
    Result := True
  else
    Result := (TWinControl(aCtrl).Parent <> nil) and
      IsTemplateControl(TWinControl(aCtrl).Parent, aCtrlMain);
end;

procedure TfrmTemplateDialog.UpdateControlHighlighting(ctrl:TWinControl);
begin
  if IsTemplateControl(ctrl,sbMain) then
    begin
      dmRF.HighlightControls(ReqHighlight);
      PostMessage(handle,UM_UpdateRFN,0,0); // RTC 1022950
    end;
end;

procedure TfrmTemplateDialog.setReqHighlightColor;
begin
  try
    dmRF.HighlightControls(ReqHighlight);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmTemplateDialog.setReqHighlightAlign(aPos:Integer);
begin
  try
    frRequiredFields.setAlign(aPos);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmTemplateDialog.AdjustFormToFontSize(aSize:Integer);
var
  W: Integer;

  procedure adjustWidthToFont(aSize:Integer; var X:Integer);
  begin
    case aSize of
    8,9:
        X := 800;
    10,11:
        X := 800;
    12,13:
        X := 840;
    14,15,16,17:
        X := 1020;
    18:
        X := 1200;
    else
        X := 1280;
    end;
  end;

begin
  adjustWidthToFont(aSize,w);
  Width := w;
  Constraints.MinWidth := w;

  pnlBottomGrid.Height := frRequiredFields.szButtonY +
      pnlBtnTop.Height + pnlBtnBottom.Height;

  grdpnlBottom.ColumnCollection[0].Value := frRequiredFields.szButtonX;
  grdpnlBottom.ColumnCollection[1].Value := frRequiredFields.szButtonX;
  grdpnlBottom.ColumnCollection[3].Value := frRequiredFields.szButtonX;
  grdpnlBottom.ColumnCollection[5].Value := frRequiredFields.szButtonX;
  grdpnlBottom.ColumnCollection[6].Value := frRequiredFields.szButtonX;

  pnlBottomRight.Width := frRequiredFields.pnlRMargin.Width;
  pnlBottomLeft.Width := frRequiredFields.pnlLMargin.Width;
end;

procedure TfrmTemplateDialog.T1Click(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
  T1.Checked := not T1.Checked;
  SetDebugInfo(ActiveControl);
{$ENDIF}
end;

{$IFDEF DEBUG}
procedure TfrmTemplateDialog.SetDebugInfo(aControl: TWinControl = nil);
begin
  reText.Lines.Clear;
  setDebugLayout;
  if pnlDebug.Visible then
  begin
    reText.Lines.Text := reText.Lines.Text + CRLF + 'RFN.Focused Control: ' +
      IntToStr(Integer(frRequiredFields.FocusedControl)) + ' -- ' +
      frRequiredFields.FocusedControl.ClassName;

    reText.Lines.Text := reText.Lines.Text + CRLF + dmRF.RequiredFields2Str;

    reText.SelStart := 0;
    reText.Perform(EM_SCROLLCARET, 0, 0);

    DebugHighlight(frRequiredFields.FocusedControl);
  end;
end;
{$ENDIF}
// NSR20100706 AA 2015/09/29 ----------------------------------------------- end

procedure TfrmTemplateDialog.UM_UpdateRequiredFieldsCount(var Message: TMessage);
begin
  if (FTIUParam = 0) then // 20100706 - VISTAOR-24208 FH 2021/02/12
  begin
    frRequiredFields.RequiredTotal := dmRF.getNumberOfMissingFields(sbMain);
    btnOKGrid.Enabled := frRequiredFields.RequiredTotal < 1;
  end;
{$IFDEF DEBUG}
  SetDebugInfo(nil);
{$ENDIF}
  dmRF.RefreshCdsControls(sbMain);

  if assigned(ActiveControl) then
    dmRF.cdsControls.Locate('CTRL_OBJ', VarArrayOf([Integer(ActiveControl)]), []);

end;

procedure TfrmTemplateDialog.edTargetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  CharPos, CharPos2: Integer;

  procedure HighlightRichEdit(re: ORExtensions.TRichEdit; StartChar, EndChar: Integer;
    HighLightColor: TColor; Flag: Integer = SCF_SELECTION);
  var
    Format: CHARFORMAT2;
  begin
    re.SelStart := StartChar;
    re.SelLength := EndChar;
    // Set the background color
    FillChar(Format, SizeOf(Format), 0);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := HighLightColor;
    re.Perform(EM_SETCHARFORMAT, Flag, Longint(@Format));
  end;

begin
  inherited;
  if (Key = VK_RETURN) then
  begin
    HighlightRichEdit(reText, 0, length(reText.Text), reText.Color);
    CharPos := 0;
    repeat
      // find the text and save the position
      CharPos2 := reText.FindText(edTarget.Text, CharPos,
        length(reText.Text), []);
      CharPos := CharPos2 + 1;
      if CharPos = 0 then
        break;

      HighlightRichEdit(reText, CharPos2, length(edTarget.Text), clYellow);

    until CharPos = 0;
    Key := 0;
  end;
end;

procedure TfrmTemplateDialog.btnDebugClick(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
  SetDebugInfo(ActiveControl);
{$ENDIF}
end;

procedure TfrmTemplateDialog.btnFieldsClick(Sender: TObject);
begin
  inherited;
  Windows.PostMessage(Self.Handle,UM_UpdateRFN,0,0);
end;

procedure TfrmTemplateDialog.updateTemplate;
begin
  if RepaintBuild then
  begin
    RepaintBuild := FALSE;
    BuildAllControls;
    Windows.PostMessage(Handle, UM_UpdateRFN, 0, 0); // reset navigator status RTC 1022950
    InitScreenReaderSetup;
  end;
end;

procedure TfrmTemplateDialog.FormResize(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
  pnlDebug.Width := width div 2;
{$ENDIF}
end;

procedure TfrmTemplateDialog.setDebugLayout;
var
  fDebug: Boolean;

begin
  fDebug := T1.Checked;
  pnlDebug.Visible := fDebug;
  if not fDebug then
    begin
      splFields.Align := alTop;
      splFields.Visible := False;
    end
  else
    begin
      splFields.Visible := True;
      splFields.Align := alRight;
      splFields.Left := Width - pnlDebug.Width - splFields.Width;
    end;
end;

{$IFDEF DEBUG}
procedure TfrmTemplateDialog.DebugHighlight(aControl: TWinControl);
var
  K: Word;
begin
  edTarget.Text := IntToStr(Integer(aControl));
  K := VK_RETURN;
  edTargetKeyDown(edTarget,K,[]);
end;
{$ENDIF}

procedure TfrmTemplateDialog.Highlight1Click(Sender: TObject);
var
  K: Word;
begin
  inherited;
  edTarget.Text := reText.SelText;
  K := VK_RETURN;
  edTargetKeyDown(edTarget,K,[]);
end;

procedure TfrmTemplateDialog.cbCdsFieldsRequiredClick(Sender: TObject);
begin
  inherited;
  dmRF.setFilterFieldsRequired(cbCdsFieldsRequired.Checked);
end;

procedure TfrmTemplateDialog.cbTextClick(Sender: TObject);
begin
  inherited;
  pnlText.Visible := cbText.Checked;
  splDebug.Top := Height - pnlText.Height - 1;
end;

end.
