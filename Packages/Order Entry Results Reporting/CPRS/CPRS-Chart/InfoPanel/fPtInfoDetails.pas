unit fPtInfoDetails;

interface

{$TYPEINFO ON}

uses
  System.Classes,
  System.JSON,
  System.SysUtils,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Edge,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  Winapi.WebView2,
  Winapi.ActiveX,
  ORFn,
  fBase508Form,
  VA508AccessibilityManager,
  uPtInfoCommon,
  uPtInfoCore,
  mEditBase, fBase508Frame;

type
  TPtInfoDetailType = (dtNone, dtInfo, dtWeb, dtEditor, dtCustom);

  TfrmPtInfoDetails = class(TfrmBase508Form)
    memDetails: TRichEdit;
    wbEdgeBrowser: TEdgeBrowser;
    pnlBottom: TPanel;
    btnClose: TButton;
    pnlHeader: TPanel;
    fraEditGrid: TfraEditGridBase;
    sbCustom: TScrollBox;
    sbClose: TSpeedButton;
    lblHeader: TVA508StaticText;
    btnPrint: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure fraEditGridBtnSaveClick(Sender: TObject);
    procedure pnlHeaderResize(Sender: TObject);
    procedure memDetailsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCloseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPrintClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fraEditGridpnlButtonsResize(Sender: TObject);
  private
    FIsActive: Boolean;
    FControls: array [TPtInfoDetailType] of TWinControl;
    FDetailType: TPtInfoDetailType;
    FPtInfoLink: TPtInfoLink;
    procedure resetFocus;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(APresentation: TPtInfoPresentation;
      AGridPanel: TGridPanel); reintroduce;
    destructor Destroy; override;
    procedure ResetFont;
    procedure SetupButtons(SaveText, CancelText: string);
    procedure SetupDetails(ADetailType: TPtInfoDetailType);
    property IsActive: Boolean read FIsActive;
    property PtInfoLink: TPtInfoLink read FPtInfoLink;
  end;

implementation

{$R *.dfm}

uses
  Winapi.RichEdit,
  Winapi.ShellAPI,
  ORNet,
  VAUtils,
  uConst,
  fRptBox,
  rMisc,
  fFrame,
  mPtInfoPanel,
  uCore,
  fEncnt,
  rPtInfo,
  UJSONValueHelper,
  uPCE,
  uEditObject;

{ TfrmPtInfoDetails }

procedure TfrmPtInfoDetails.btnCloseClick(Sender: TObject);
begin
  inherited;
  if FDetailType = dtEditor then
    fraEditGrid.btnCancelClick(Sender);
  FIsActive := False;
  Close;
  if (PtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.ResetToCollapse = true) and
     (PtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.OpenState = osFloating) then
    PtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.OpenState := osUnPinned;
end;

procedure TfrmPtInfoDetails.btnCloseKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (FDetailType = dtInfo) and (Key = VK_ESCAPE) and (Shift = []) then
    btnClose.Click;
end;

procedure TfrmPtInfoDetails.btnPrintClick(Sender: TObject);
begin
  inherited;
  PrintStrings(Self, memDetails.Lines, Self.Caption, 'End of report');
  memDetails.Invalidate;
end;

constructor TfrmPtInfoDetails.Create(APresentation: TPtInfoPresentation;
  AGridPanel: TGridPanel);
begin
  inherited Create(nil);
  FPtInfoLink := TPtInfoLink.Create(Self, nil, APresentation, AGridPanel);
end;

destructor TfrmPtInfoDetails.Destroy;
begin
  FPtInfoLink.Free;
  inherited;
end;

procedure TfrmPtInfoDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(PtInfoLink.Presentation) and
    (PtInfoLink.Presentation.PopOutType in [popShowModal, popShowNonModal]) then
    SaveUserBounds(Self, Self.ClassName + '_', PtInfoLink.Presentation.panelId);
  Action := caHide;
  PtInfoLink.OrphanControl;
  if FPtInfoLink.Presentation.PopOutType = popShowEmbedded then
  begin
    FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.FormGrid.Visible := False;
    FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.PanelGrid.Visible := True;
  end;
    resetFocus;
end;

procedure TfrmPtInfoDetails.FormCreate(Sender: TObject);
begin
  FControls[dtInfo] := memDetails;
  FControls[dtWeb] := wbEdgeBrowser;
  FControls[dtEditor] := fraEditGrid;
  FControls[dtCustom] := sbCustom;
  ResetFont;
end;

procedure TfrmPtInfoDetails.FormDestroy(Sender: TObject);
begin
  if PtInfoLink.Presentation.PopOutType = popShowEmbedded then
    Close;
  inherited;
end;

procedure TfrmPtInfoDetails.fraEditGridBtnSaveClick(Sender: TObject);
var
  i, p: Integer;
  Line, IValue, IValues, EValue, EValues, Error: string;
  CompList: TStringList;
  JSONResults: TJSONValue;
  Results: TPtInfoSaveResults;
  JSON, Editor, Item, Value: TJSONObject;
  Layout, Values: TJSONArray;
  DoReload: Boolean;
begin
  DoReload := False;
  FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.FloatMonitoring := False;
  try
    CompList := nil;
    JSON := PtInfoLink.Presentation.DataToJSON;
    try
      CompList := TStringList.Create;
      if not fraEditGrid.Layout.validateData(CompList) then
      begin
        if CompList.Count > 0 then
          ShowMessage(CompList.Text)
        else
          ShowMessage('Unknown data validation error');
        exit;
      end;
      Editor := TJSONObject.Create;
      JSON.AddPair('editor', Editor);
      Editor.AddPair('id', fraEditGrid.Layout.layoutType -
        TPtInfoDataTypes.EditorLayoutTypeOffset);
      Layout := nil;
      for i := 0 to CompList.Count - 1 do
      begin
        if not Assigned(Layout) then
        begin
          Layout := TJSONArray.Create;
          Editor.AddPair('layout', Layout);
        end;
        Item := TJSONObject.Create;
        Layout.AddElement(Item);
        Line := CompList[i];
        Item.AddPair('id', Piece(Line, U, 1));
        IValues := Piece(Line, U, 2);
        EValues := Piece(Line, U, 3);
        Values := nil;
        p := 0;
        repeat
          inc(p);
          IValue := Piece(IValues, tEditObject.DLim, p);
          EValue := Piece(EValues, tEditObject.DLim, p);
          if (IValue <> '') or (EValue <> '') then
          begin
            if not Assigned(Values) then
            begin
              Values := TJSONArray.Create;
              Item.AddPair('values', Values);
            end;
            Value := TJSONObject.Create;
            Values.AddElement(Value);
            if IValue <> '' then
              Value.AddPair('internal', IValue);
            if EValue <> '' then
              Value.AddPair('external', EValue);
          end;
        until IValue = '';
      end;
      JSONResults := CreateJSONfromEditorSave(JSON, Error);
      try
        if Error <> '' then
        begin
          ShowMessage(Error);
          exit;
        end
        else if Assigned(JSONResults) then
        begin
          Results := TPtInfoDataConverter.ToObject<TPtInfoSaveResults>
            (JSONResults);
          try
            if Assigned(PtInfoLink.PtInfoData) and
              Assigned(PtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase) and
              Results.RefreshAllInfoPanels then
              DoReload := True;
            if Assigned(Results.NoteInformation) and
              (Results.NoteInformation.ID > 0) then
            begin
              Changes.Add(CH_DOC, Results.NoteInformation.ID.ToString,
                Results.NoteInformation.Details, '', CH_SIGN_YES);
              PostMessage(Application.MainForm.Handle, UM_NEWNOTE, 0, 0);
            end;
          finally
            FreeAndNil(Results);
          end;
        end
        else
          exit;
      finally
        FreeAndNil(JSONResults);
      end;
    finally
      FreeAndNil(CompList);
      FreeAndNil(JSON);
    end;
    FIsActive := False;
    Close;
  finally
    FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.FloatMonitoring := True;
  end;
  if DoReload then
    PtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.Reload
  else resetFocus;
end;

procedure TfrmPtInfoDetails.fraEditGridpnlButtonsResize(Sender: TObject);
begin
  inherited;
  SetupButtons(fraEditGrid.btnSave.Caption, fraEditGrid.btnCancel.Caption);
end;

procedure TfrmPtInfoDetails.memDetailsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (FDetailType = dtInfo) and (Shift = []) and
    ((Key = VK_ESCAPE) or ((Sender <> btnPrint) and (Key = VK_RETURN))) then
    btnClose.Click;
end;

procedure TfrmPtInfoDetails.pnlHeaderResize(Sender: TObject);
begin
  inherited;
  sbClose.Width := sbClose.Height;
  if TextWidthByFont(lblHeader.Font.Handle,lblHeader.Caption)  > Width then
    lblHeader.Alignment := taLeftJustify
  else lblHeader.Alignment := taCenter;
end;

procedure TfrmPtInfoDetails.resetFocus;
begin
  if FPtInfoLink = nil  then exit;
  if FPtInfoLink.Presentation = nil then exit;
  if FPtInfoLink.Presentation.ItemPanel = nil then exit;
  if FPtInfoLink.Presentation.ItemPanel.PtInfoLink = nil then exit;
  if not assigned(FPtInfoLink.Presentation.ItemPanel.PtInfoLink.Control) then exit;
  FPtInfoLink.Presentation.ItemPanel.PtInfoLink.Control.SetFocus;
end;

procedure TfrmPtInfoDetails.ResetFont;
begin
  if Visible then
  begin
    ResizeFormToFont(Self);
    memDetails.Font.Size := MainFontSize;
    pnlHeader.Height := PtInfoLink.PtInfoData.RowHeight + 10;
    pnlHeader.Realign;
    if fraEditGrid.Visible then
      SetupButtons(fraEditGrid.btnSave.Caption, fraEditGrid.btnCancel.Caption);
  end;
end;

procedure TfrmPtInfoDetails.SetupButtons(SaveText, CancelText: string);
var
  B1, B2: TButton;
  Adj, CW, W1, W2, Gap, Needed, Wanted: Integer;

  procedure AddHint(Btns: TArray<TButton>);
  var
    Btn: TButton;
  begin
    for Btn in Btns do
    begin
      Btn.ShowHint := (Adj < 5);
      Btn.Hint := Btn.Caption;
    end;
  end;

  procedure AdjGap(Btns: TArray<TButton>);
  var
    Btn: TButton;
  begin
    for Btn in Btns do
      if Btn.AlignWithMargins then
        inc(Gap, Btn.Margins.Left + Btn.Margins.Right);
  end;

begin
  Adj := 40;
  B1 := fraEditGrid.btnSave;
  B2 := fraEditGrid.btnCancel;
  B1.Caption := SaveText;
  B2.Caption := CancelText;
  Gap := 0;
  AdjGap([B1, B2]);
  W1 := Canvas.TextWidth(SaveText);
  W2 := Canvas.TextWidth(CancelText);
  Needed := W1 + W2 + Gap;
  Wanted := Needed + (Adj * 2);
  CW := fraEditGrid.pnlButtons.ClientWidth;
  if Wanted > CW then
    dec(Adj, (Wanted - CW) div 2);
  B1.Width := W1 + Adj;
  B2.Width := W2 + Adj;
  AddHint([B1, B2]);
end;

procedure TfrmPtInfoDetails.SetupDetails(ADetailType: TPtInfoDetailType);
begin
  FDetailType := ADetailType;
  memDetails.Font.Size := MainFontSize;
  pnlBottom.Visible := (ADetailType <> dtEditor);
  btnPrint.Visible := (ADetailType = dtInfo);
  sbClose.Visible := False;
  if (not IsActive) and Assigned(PtInfoLink.Presentation) and
    (PtInfoLink.Presentation.PopOutType in [popShowModal, popShowNonModal]) then
  begin
    ResizeFormToFont(Self);
    pnlHeader.Height := PtInfoLink.PtInfoData.RowHeight;
    // frmPtInfoDetails.Name doesn't work - Multiple forms have name_1, name_2, etc.
    SetFormPosition(Self, Self.ClassName + '_',
      PtInfoLink.Presentation.panelId);
    KeepBounds := False;
  end
  else
  begin
    // sbClose.Visible := True;
    // sbClose.Width := sbClose.Height;
  end;
  for var dt := Low(TPtInfoDetailType) to High(TPtInfoDetailType) do
  begin
    if Assigned(FControls[dt]) then
    begin
      FControls[dt].Visible := (ADetailType = dt);
      if ADetailType = dt then
        FControls[dt].Align := alClient
      else
        FControls[dt].Align := alNone;
    end;
  end;
  if FPtInfoLink.Presentation.PopOutType = popShowEmbedded then
  begin
    FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.FormGrid.Visible := True;
    FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.FormGrid.Align := alClient;
    FPtInfoLink.PtInfoData.OwnerPtInfoSplitViewBase.PanelGrid.Visible := False;
  end;
  FPtInfoLink.PtInfoData.CloseEmbeddedDetails(Self);
  FIsActive := True;
end;

procedure TfrmPtInfoDetails.WndProc(var Message: TMessage);
var
  p: TENLink;
  AURL: string;
begin
  if (Message.Msg = WM_NOTIFY) then
  begin
    if (PNMHDR(Message.LParam).Code = EN_LINK) then
    begin
      p := TENLink(Pointer(TWMNotify(Message).NMHdr)^);
      if (p.Msg = WM_LBUTTONDOWN) then
      begin
        SendMessage(memDetails.Handle, EM_EXSETSEL, 0, LongInt(@(p.chrg)));
        AURL := memDetails.SelText;
        ShellExecute(Handle, 'open', PChar(AURL), NIL, NIL, SW_SHOWNORMAL);
      end
    end
  end;
  inherited;
end;

end.
