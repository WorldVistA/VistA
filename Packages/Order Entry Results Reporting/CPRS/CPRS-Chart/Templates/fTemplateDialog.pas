unit fTemplateDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, AppEvnts, uTemplates, fBase508Form, uConst,
  VA508AccessibilityManager;

type
  TfrmTemplateDialog = class(TfrmBase508Form)
    sbMain: TScrollBox;
    pnlBottom: TScrollBox;
    btnCancel: TButton;
    btnOK: TButton;
    btnAll: TButton;
    btnNone: TButton;
    lblFootnote: TStaticText;
    btnPreview: TButton;
    procedure btnAllClick(Sender: TObject);
    procedure btnNoneClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FFirstBuild: boolean;
    SL: TStrings;
    BuildIdx: TStringList;
    Entries: TStringList;
    NoTextID: TStringList;
    Index: string;
    OneOnly: boolean;
    Count: integer;
    RepaintBuild: boolean;
    FirstIndent: integer;
    FBuilding: boolean;
    FOldHintEvent: TShowHintEvent;
    FMaxPnlWidth: integer;
    FTabPos: integer;
    FCheck4Required: boolean;
    FSilent: boolean;
    procedure SizeFormToCancelBtn();
    procedure ChkAll(Chk: boolean);
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
  public
    property Silent: boolean read FSilent write FSilent ;
  published
  end;

// Returns True if Cancel button is pressed
function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE): boolean;
procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; PreviewMode: boolean = FALSE); overload;
procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; PreviewMode: boolean = FALSE); overload;
procedure ShutdownTemplateDialog;

var
  frmTemplateDialog: TfrmTemplateDialog;

implementation

uses dShared, uTemplateFields, fRptBox, uInit, rMisc, uDlgComponents,
  VA508AccessibilityRouter, VAUtils, fFrame;

{$R *.DFM}

var
  uTemplateDialogRunning: boolean = false;

const
  Gap = 4;
  IndentGap = 18;


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
function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE): boolean;
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
      id := id + '.' + InttoStr(DlgInt.x);
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
  frmTemplateDialog := TfrmTemplateDialog.Create(Application);
  try
    DlgIDCounts := TStringList.Create;
    DlgIDCounts.Sorted := TRUE;
    DlgIDCounts.Duplicates := dupError;
    frmTemplateDialog.Caption := CaptionText;
    AssignFieldIDs(SL);
    frmTemplateDialog.SL := SL;
    frmTemplateDialog.Index := '';
    Txt := SL.Text;
    frmTemplateDialog.OneOnly := (DelimCount(Txt, ObjMarker) = 1);
    frmTemplateDialog.Count := 0;
    idx := 1;
    frmTemplateDialog.FirstIndent := 99999;
    repeat
      i := pos(ObjMarker, Txt);
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
      if(frmTemplateDialog.OneOnly) then
      begin
        frmTemplateDialog.btnNone.Visible := FALSE;
        frmTemplateDialog.btnAll.Visible := FALSE;
      end;
      frmTemplateDialog.BuildAllControls;
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
    frmTemplateDialog.Release;
    //frmTemplateDialog := nil;  access violation source?  removed 7/28/03 RV
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
    CheckBoilerplate4Fields(SL, CaptionText, PreviewMode);
  end;
  
end;

procedure ShutdownTemplateDialog;
begin
  if uTemplateDialogRunning and assigned(frmTemplateDialog) then
  begin
    frmTemplateDialog.Silent := True;
    frmTemplateDialog.ModalResult := mrCancel;
  end;
end;

procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; PreviewMode: boolean = FALSE);
begin
  while(HasTemplateField(SL.Text)) do
  begin
    if (BoilerplateTemplateFieldsOK(SL.Text)) then
    begin
      SL[SL.Count-1] := SL[SL.Count-1] + DlgPropMarker + '00100;0;-1;;0' + ObjMarker;
      DoTemplateDialog(SL, CaptionText, PreviewMode);
    end
    else
      SL.Clear;
  end;
  StripScreenReaderCodes(SL);
end;

procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; PreviewMode: boolean = FALSE);
var
  tmp: TStringList;

begin
  tmp := TStringList.Create;
  try
    tmp.text := AText;
    CheckBoilerplate4Fields(tmp, CaptionText, PreviewMode);
    AText := tmp.text;
  finally
    tmp.free;
  end;
end;

procedure TfrmTemplateDialog.ChkAll(Chk: boolean);
var
  i: integer;

begin
  for i := 0 to sbMain.ControlCount-1 do
  begin
    if(sbMain.Controls[i] is TORCheckBox) then
      TORCheckBox(sbMain.Controls[i]).Checked := Chk;
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

procedure TfrmTemplateDialog.BuildCB(CBidx: integer; var Y: integer; FirstTime: boolean);
var
  bGap, Indent, i, idx, p1, p2: integer;
  EID, ID, PID, DlgProps, tmp, txt, tmpID: string;
  pctrl, ctrl: TControl;
  pnl: TPanel;
  KillCtrl, doHint, dsp, noTextParent: boolean;
  Entry: TTemplateDialogEntry;
//  StringIn, StringOut: string;
  cb: TCPRSDialogParentCheckBox;

  procedure NextTabCtrl(ACtrl: TControl);
  begin
    if(ACtrl is TWinControl) then
    begin
      inc(FTabPos);
      TWinControl(ACtrl).TabOrder := FTabPos;
    end;
  end;

begin
  tmp := Piece(Index, U, CBidx);
  p1 := StrToInt(Piece(tmp,'~',1));
  p2 := StrToInt(Piece(tmp,'~',2));
  DlgProps := Piece(tmp,'~',3);
  ID := Piece(DlgProps, ';', 3);
  PID := Piece(DlgProps, ';', 4);

  ctrl := nil;
  pctrl := nil;
  if(PID <> '') then
    noTextParent := (NoTextID.IndexOf(PID) < 0)
  else
    noTextParent := TRUE;
  if not FirstTime then
    ctrl := FindObjectByID(ID);
  if noTextParent and (PID <> '') then
    pctrl := FindObjectByID(PID);
  if(PID = '') then
    KillCtrl := FALSE
  else
  begin
    if(assigned(pctrl)) then
    begin
      if(not (pctrl is TORCheckBox)) or
        (copy(DlgProps,3,1) = BOOLCHAR[TRUE]) then // show if parent is unchecked
        KillCtrl := FALSE
      else
        KillCtrl := (not TORCheckBox(pctrl).Checked);
    end
    else
      KillCtrl := noTextParent;
  end;
  if KillCtrl then
  begin
    if(assigned(ctrl)) then
    begin
      if(ctrl is TORCheckBox) and (assigned(TORCheckBox(ctrl).Associate)) then
        TORCheckBox(ctrl).Associate.Hide;
      idx := BuildIdx.IndexOfObject(TObject(ctrl.Tag));
      if idx >= 0 then
        BuildIdx.delete(idx);
      ctrl.Free;
    end;
    exit;
  end;
  tmp := copy(SL.Text, p1, p2);
  if(copy(tmp, length(tmp)-1, 2) = CRLF) then
    delete(tmp, length(tmp)-1, 2);
  bGap := StrToIntDef(copy(DlgProps,5,1),0);
  while bGap > 0 do
  begin
    if(copy(tmp, 1, 2) = CRLF) then
    begin
      delete(tmp, 1, 2);
      dec(bGap);
    end
    else
      bGap := 0;
  end;
  if(tmp = NoTextMarker) then
  begin
    if(NoTextID.IndexOf(ID) < 0) then
      NoTextID.Add(ID);
    exit;
  end;
  if(not assigned(ctrl)) then
  begin
    dsp := (copy(DlgProps,1,1)=BOOLCHAR[TRUE]);
    EID := 'DLG' + IntToStr(CBIdx);
    idx := Entries.IndexOf(EID);
    doHint := FALSE;
    txt := tmp;
    if(idx < 0) then
    begin
      if(copy(DlgProps,2,1)=BOOLCHAR[TRUE]) then // First Line Only
      begin
        i := pos(CRLF, tmp);
        if(i > 0) then
        begin
          dec(i);
          if i > 70 then
          begin
            i := 71;
            while (i > 0) and (tmp[i] <> ' ') do dec(i);
            if i = 0 then
              i := 70
            else
              dec(i);
          end;
          doHint := TRUE;
          tmp := copy(tmp, 1, i) + ' ...';
        end;
      end;
      Entry := GetDialogEntry(sbMain, EID, tmp);
      Entry.AutoDestroyOnPanelFree := TRUE;
      Entry.OnDestroy := EntryDestroyed;
      Entries.AddObject(EID, Entry);

      //Populate the Copy/Paste control
    end
    else
      Entry := TTemplateDialogEntry(Entries.Objects[idx]);

    if(dsp or OneOnly) then
      cb := nil
    else
      cb := TCPRSDialogParentCheckBox.Create(Self);

    pnl := Entry.GetPanel(FMaxPnlWidth, sbMain, cb);
    pnl.Show;
    if(doHint and (not pnl.ShowHint)) then
    begin
      pnl.ShowHint := TRUE;
      Entry.Obj := pnl;
      Entry.Text := txt;
      pnl.hint := Entry.GetText;
      Entry.OnChange := FieldChanged;
    end;
    if not assigned(cb) then
      ctrl := pnl
    else
    begin
      ctrl := cb;
      ctrl.Parent := sbMain;

      TORCheckbox(ctrl).OnEnter := frmTemplateDialog.ParentCBEnter;
      TORCheckbox(ctrl).OnExit := frmTemplateDialog.ParentCBExit;

      TORCheckBox(ctrl).Height := TORCheckBox(ctrl).Height + 5;
      TORCheckBox(ctrl).Width := 17;

    {Insert next line when focus fixed}
    //  ctrl.Width := IndentGap;
    {Remove next line when focus fixed}
      TORCheckBox(ctrl).AutoSize := false;
      TORCheckBox(ctrl).Associate := pnl;
      pnl.Tag := Integer(ctrl);
      tmpID := copy(ID, 1, (pos('.', ID) - 1)); {copy the ID without the decimal place}
//      if Templates.IndexOf(tmpID) > -1 then
//        StringIn := 'Sub-Template: ' + TTemplate(Templates.Objects[Templates.IndexOf(tmpID)]).PrintName
//      else
//        StringIn := 'Sub-Template:';
//      StringOut := StringReplace(StringIn, '&', '&&', [rfReplaceAll]);
//      TORCheckBox(ctrl).Caption := StringOut;
      UpdateColorsFor508Compliance(ctrl);

    end;
    ctrl.Tag := CBIdx;

    Indent := StrToIntDef(Piece(DlgProps, ';', 5),0) - FirstIndent;
    if dsp then inc(Indent);
    ctrl.Left := Gap + (Indent * IndentGap);
    //ctrl.Width := sbMain.ClientWidth - Gap - ctrl.Left - ScrollBarWidth;
    if(ctrl is TORCheckBox) then
      pnl.Left := ctrl.Left + IndentGap;

    if(ctrl is TORCheckBox) then with TORCheckBox(ctrl) do
    begin
      GroupIndex := StrToIntDef(Piece(DlgProps, ';', 2),0);
      if(GroupIndex <> 0) then
        RadioStyle := TRUE;
      OnClick := ItemChecked;
      StringData := DlgProps;
    end;
    if BuildIdx.IndexOfObject(TObject(CBIdx)) < 0 then
      BuildIdx.AddObject(Piece(Piece(Piece(Index, U, CBIdx),'~',3), ';', 3), TObject(CBIdx));
  end;
  ctrl.Top := Y;
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
end;

procedure TfrmTemplateDialog.BuildAllControls;
var
  i, Y: integer;
  FirstTime: boolean;

begin
  if FBuilding then exit;
  FBuilding := TRUE;
  try
    FTabPos := 0;
    FirstTime := (sbMain.ControlCount = 0);
    NoTextID.Clear;
    Y := Gap - sbMain.VertScrollBar.Position;
    for i := 1 to Count do
      BuildCB(i, Y, FirstTime);
    if ScreenReaderSystemActive then
    begin
      amgrMain.RefreshComponents;
      Application.ProcessMessages;
    end;
  finally
    FBuilding := FALSE;
  end;
end;

procedure TfrmTemplateDialog.FormPaint(Sender: TObject);
begin
  if RepaintBuild then
  begin
    RepaintBuild := FALSE;
    BuildAllControls;
    InitScreenReaderSetup;
  end;
end;

procedure TfrmTemplateDialog.FormShow(Sender: TObject);
begin
  inherited;
  if FFirstBuild then
  begin
    FFirstBuild := FALSE;
    InitScreenReaderSetup;
  end;
end;

procedure TfrmTemplateDialog.FormCreate(Sender: TObject);
begin
  uTemplateDialogRunning := True;
  FFirstBuild := TRUE;
  BuildIdx := TStringList.Create;
  Entries := TStringList.Create;
  NoTextID := TStringList.Create;
  FOldHintEvent := Application.OnShowHint;
  Application.OnShowHint := AppShowHint;
  //ResizeAnchoredFormToFont(Self);
  FMaxPnlWidth := FontWidthPixel(sbMain.Font.Handle) * MAX_ENTRY_WIDTH; //AGP change Template Dialog to wrap at 80 instead of 74
  SetFormPosition(Self);
  ResizeAnchoredFormToFont(Self);
  SizeFormToCancelBtn();
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
end;

procedure TfrmTemplateDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Txt, tmp: string;
  i, p1, p2: integer;
  Save: boolean;

begin
  CanClose := TRUE;
  if FCheck4Required then
  begin
    FCheck4Required := FALSE;
    Txt := SL.Text;
    for i := 0 to sbMain.ControlCount-1 do
    begin
      Save := FALSE;
      if(sbMain.Controls[i] is TORCheckBox) and
        (TORCheckBox(sbMain.Controls[i]).Checked) then
        Save := TRUE
      else
      if(OneOnly and (sbMain.Controls[i] is TPanel)) then
        Save := TRUE;
      if(Save) then
      begin
        tmp := Piece(Index,U,sbMain.Controls[i].Tag);
        p1 := StrToInt(Piece(tmp,'~',1));
        p2 := StrToInt(Piece(tmp,'~',2));
        if AreTemplateFieldsRequired(Copy(Txt,p1,p2)) then
          CanClose := FALSE;
      end;
      if not CanClose then
      begin
        ShowMsg(MissingFieldsTxt);
        break;
      end;
    end;
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
end;

procedure TfrmTemplateDialog.SizeFormToCancelBtn;
const
  RIGHT_MARGIN = 12;
var
  minWidth : integer;
begin
  minWidth := btnCancel.Left + btnCancel.Width + RIGHT_MARGIN;
  if minWidth > Self.Width then
    Self.Width := minWidth;
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

end.

