unit mODAnatPathBuilder;

// Developer: Theodore Fontana
// 02/24/17

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.RichEdit, System.SysUtils,
  System.Variants, System.Classes, System.Generics.Collections, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Graphics,
  Vcl.Menus, Vcl.CheckLst, ORCtrls, ORextensions, fODBase,
  oODAnatPath, rODAnatPath, VA508AccessibilityManager, fBase508Form;

const
  LEFT_MARGIN = 4;
  MAX_STR_LEN = 73;

type
  TfraAnatPathBuilder = class;

  TLabText = class(TObject)
  private
    FOwner: TfraAnatPathBuilder;
    FPromptID: string;
    FRestoredText: TStringList;
  public
    constructor Create(AOwner: TfraAnatPathBuilder); overload;
    destructor Destroy; override;
    procedure GetHeader(var oText: TStringList);
    procedure SetText(const slValue: TStringList);
    procedure GetText(var oText: TStringList);
    property Owner: TfraAnatPathBuilder read FOwner write FOwner;
    property PromptID: string read FPromptID write FPromptID;
    property RestoredText: TStringLIst read FRestoredText write FRestoredText;
  end;

  TfraAnatPathBuilder = class(TfrmBase508Form)
    pnl1: TPanel;
    pnl2: TPanel;
    pnl4: TPanel;
    pnl3: TPanel;
    lstCheckList: TCaptionCheckListBox;
    pnlSpacer3: TPanel;
    pnlSpacer4: TPanel;
    pnlSpacer5: TPanel;
    lblWPField: TLabel;
    memNote: TCaptionMemo;
    mnuNoteMemo: TPopupMenu;
    mnuNoteMemoCut: TMenuItem;
    mnuNoteMemoCopy: TMenuItem;
    mnuNoteMemoPaste: TMenuItem;
    sbx1: TScrollBox;
    sbx2: TScrollBox;
    mnuNoteMenuInsert: TMenuItem;
    lblCheckList: TLabel;
    VA508ListBox: TVA508ComponentAccessibility;
    procedure VA508CaptionQuery(Sender: TObject; var Text: string);
    procedure pnl4Resize(Sender: TObject);
    procedure memNoteEnter(Sender: TObject);
    procedure memNoteExit(Sender: TObject);
    procedure mnuNoteMemoCutClick(Sender: TObject);
    procedure mnuNoteMemoCopyClick(Sender: TObject);
    procedure mnuNoteMemoPasteClick(Sender: TObject);
    procedure lstCheckListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FLabText: TLabText;
    FShownPanels: array of Boolean;
    FElements: TObjectList<TBuilderElement>;
    procedure SetLabText(const ltValue: TLabText);
    procedure SetRequired(const bValue: Boolean);
    procedure ToggleMemo;
    procedure GetTextHeader(var oText: TStringList);
    procedure GetText(var oText: TStringList);
    function GetRequired: Boolean;
    function PageReference: string;
    function PageCaption: string;
  protected
    procedure GetTextFromElements(var oText: TStringList);
    procedure GetListText(var oText: TStringList);
    procedure GetMemoText(oText: TStringList);
    procedure AddValuesCheckList(sVals,sDefault: string);
    procedure AddControlItem(sIEN,sTitle,sList,sDefault,sVals: string);
    procedure TabSort(sbx: TScrollBox);
    procedure UpdateForm(sValue: string);
    procedure CreateBuildReturn(sValue: string;
      var BuildList: TObjectList<TBuildReturn>);
    procedure FinishBuildingThisFrame(cBit: TBitmap);
    function InternalHeight(sbx: TScrollBox): Integer;
  public
    constructor CreateBuilder(FontSize: integer; AOwner: TComponent);
    destructor Destroy; override;
    function GetCaption: string;
    function GetPromptID: string;
    function Valid: Boolean;
    property Required: Boolean read GetRequired write SetRequired Default False;
    property Elements: TObjectList<TBuilderElement> read FElements;
    property LabText: TLabText read FLabText write SetLabText;
  end;

implementation

{$R *.dfm}

uses
  ORNet, ORfn, VAUtils, uConst, fODAnatPath, mODAnatpathSpecimen,
  VA508AccessibilityRouter;

{$REGION 'TLabText'}

// Public ----------------------------------------------------------------------

constructor TLabText.Create(AOwner: TfraAnatPathBuilder);
begin
  inherited Create;

  FOwner := AOwner;
  FRestoredText := TStringList.Create;

  if ALabTest <> nil then
    ALabTest.LabTextList.Add(Self);
end;

destructor TLabText.Destroy;
begin
  if ALabTest <> nil then
  begin
    ALabTest.LabTextList.Extract(Self);
    frmODAnatPath.UpdateTextResponses(True);
  end;
  FRestoredText.Free;

  inherited;
end;

procedure TLabText.GetHeader(var oText: TStringList);
begin
  oText.Clear;
  if FOwner <> nil then
    FOwner.GetTextHeader(oText);
end;

procedure TLabText.SetText(const slValue: TStringList);
begin
  if FOwner <> nil then
    FOwner.memNote.Text := slValue.Text;
end;

procedure TLabText.GetText(var oText: TStringList);
begin
  oText.Clear;
  if FOwner <> nil then
    FOwner.GetText(oText);
end;

{$ENDREGION}

{$REGION 'TfraAnatPathBuilder'}

procedure TfraAnatPathBuilder.VA508CaptionQuery(Sender: TObject;
  var Text: string);
var
  sText: string;
begin
  if TComponent(Sender).Tag = 1 then
  begin
    if Length(lblCheckList.Caption) > 0 then
      if lblCheckList.Caption[1] = '*' then
      begin
        sText := lblCheckList.Caption;
        Delete(sText, 1, 1);
        Text := 'Required field ' + sText;
      end;
  end;
end;

procedure TfraAnatPathBuilder.pnl4Resize(Sender: TObject);
begin
  inherited;

  LimitEditWidth(memNote, MAX_STR_LEN);
  memNote.Constraints.MinWidth := TextWidthByFont(memNote.Font.Handle,
                                                  StringOfChar('X', MAX_STR_LEN)) +
                                                 (LEFT_MARGIN * 2) + ScrollBarWidth;

  if memNote.Constraints.MinWidth > (pnl4.Width - 20) then
    memNote.Constraints.MinWidth := 0;
  memNote.Width := pnl4.Width - 20;
end;

procedure TfraAnatPathBuilder.memNoteEnter(Sender: TObject);
begin
  ToggleMemo;
  CurrentFocusedwp := memNote;
end;

procedure TfraAnatPathBuilder.memNoteExit(Sender: TObject);
begin
  ToggleMemo;
  CurrentFocusedwp := nil;
end;

procedure TfraAnatPathBuilder.mnuNoteMemoCutClick(Sender: TObject);
begin
  inherited;

  memNote.CutToClipboard;
end;

procedure TfraAnatPathBuilder.mnuNoteMemoCopyClick(Sender: TObject);
begin
  inherited;

  memNote.CopyToClipboard;
end;

procedure TfraAnatPathBuilder.mnuNoteMemoPasteClick(Sender: TObject);
begin
  inherited;

  ClipboardFilemanSafe;
  memNote.PasteFromClipboard;
  pnl4Resize(pnl4);
end;

procedure TfraAnatPathBuilder.lstCheckListKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ScreenReaderSystemActive then
    if lstCheckList.ItemIndex <> -1 then
    begin
      if lstCheckList.Checked[lstCheckList.ItemIndex] then
        GetScreenReader.Speak('Checked')
      else
        GetScreenReader.Speak('Not Checked');
    end;
end;

// Private ---------------------------------------------------------------------

procedure TfraAnatPathBuilder.SetLabText(const ltValue: TLabText);
begin
  FLabText := ltValue;
  FLabText.Owner := Self;
  memNote.Lines.Text := FLabText.RestoredText.Text;
end;

procedure TfraAnatPathBuilder.SetRequired(const bValue: Boolean);
var
  tbsht: TTabSheet;
  sCaption: string;
begin
  if ((Owner = nil) or not (Owner is TTabSheet)) then
    Exit;

  tbsht := TTabSheet(Owner);
  sCaption := tbsht.Caption;

  if sCaption <> '' then
  begin
    if bValue then
    begin
      if sCaption[1] <> '*' then
        tbsht.Caption := '*' + sCaption;
    end
    else
    begin
      if sCaption[1] = '*' then
      begin
        Delete(sCaption, 1, 1);
        tbsht.Caption := sCaption;
      end;
    end;
  end;
end;

procedure TfraAnatPathBuilder.ToggleMemo;
begin
  if FShownPanels[2] = pnl3.Visible then
    pnl3.Visible := False
  else
  begin
    pnl3.Visible := True;
    pnl3.Left := 0;
  end;

  if FShownPanels[1] = pnl2.Visible then
    pnl2.Visible := False
  else
  begin
    pnl2.Visible := True;
    pnl2.Left := 0;
  end;

  if FShownPanels[0] = pnl1.Visible then
    pnl1.Visible := False
  else
  begin
    pnl1.Visible := True;
    pnl1.Left := 0;
  end;
end;

procedure TfraAnatPathBuilder.GetTextHeader(var oText: TStringList);
var
  sCaption: string;
begin
  oText.Clear;
  sCaption := GetCaption;

  if sCaption <> '' then
  begin
    oText.Insert(0, '--------------------------------------------------------------------------');
    oText.Insert(0, sCaption);
  end;
end;

procedure TfraAnatPathBuilder.GetText(var oText: TStringList);
begin
  oText.Clear;

  GetTextFromElements(oText);
  GetListText(oText);
  GetMemoText(oText);
end;

function TfraAnatPathBuilder.GetRequired: Boolean;
var
  sCaption: string;
begin
  Result := False;

  sCaption := PageCaption;
  if sCaption <> '' then
    if sCaption[1] = '*' then
      Result := True;
end;

function TfraAnatPathBuilder.PageReference: string;
begin
  Result := 'PG;0';

  if ((Owner = nil) or not (Owner is TTabSheet)) then
    Exit;

  Result := 'PG;' + IntToStr(TTabSheet(Owner).PageIndex + 1);
end;

function TfraAnatPathBuilder.PageCaption: string;
begin
  Result := '';

  if ((Owner = nil) or not (Owner is TTabSheet)) then
    Exit;

  Result := TTabSheet(Owner).Caption;
end;

// Protected -------------------------------------------------------------------

procedure TfraAnatPathBuilder.GetTextFromElements(var oText: TStringList);
var
  I: Integer;
begin
  for I := 0 to FElements.Count - 1 do
    if FElements.Items[I].Value <> '' then
    begin
      if FElements.Items[I].GetCaptionwoReq <> '' then
      begin
        oText.Add(FElements.Items[I].GetCaptionwoReq);
        oText.Add('  ' + FElements.Items[I].Value + ' ' + FElements.Items[I].ValueEx);
        oText.Add('');
      end
      else
      begin
        oText.Add(FElements.Items[I].Value + ' ' + FElements.Items[I].ValueEx);
        oText.Add('');
      end;
    end;
end;

procedure TfraAnatPathBuilder.GetListText(var oText: TStringList);
var
  I: Integer;
  sl: TStringList;
  bTitle: Boolean;
begin
  if lstCheckList.Visible then
  begin
    sl := TStringList.Create;
    try
      bTitle := Trim(lblCheckList.Caption) <> '';

      for I := 0 to lstCheckList.Count - 1 do
        if lstCheckList.Checked[I] then
        begin
          if bTitle then
            sl.Add('  - ' + lstCheckList.Items[I])
          else
            sl.Add('- ' + lstCheckList.Items[I]);
        end;

      if sl.Count > 0 then
      begin
        if bTitle then
          oText.Add(lblCheckList.Caption);
        oText.AddStrings(sl);
        oText.Add('');
      end;
    finally
      sl.Free;
    end;
  end;
end;

procedure TfraAnatPathBuilder.GetMemoText(oText: TStringList);
var
  I: Integer;
begin
  LimitEditWidth(memNote, MAX_STR_LEN);
  memNote.Constraints.MinWidth := TextWidthByFont(memNote.Font.Handle,
                                                  StringOfChar('X', MAX_STR_LEN)) +
                                                 (LEFT_MARGIN * 2) + ScrollBarWidth;

  if (memNote.Lines.Count < 1) or
     ((memNote.Lines.Count = 1) and (Trim(memNote.Lines[0]) = '')) then
  begin
    if memNote.Constraints.MinWidth > (pnl4.Width - 20) then
      memNote.Constraints.MinWidth := 0;
    memNote.Width := pnl4.Width - 20;
    Exit;
  end;

  if ((lblWPField.Caption <> '') and
     (memNote.Lines.Count > 0) and (memNote.Lines[0] <> lblWPField.Caption)) then
  begin
    oText.Add(lblWPField.Caption);
    for I := 0 to memNote.Lines.Count - 1 do
      oText.Add('  ' + memNote.Lines[I]);
  end
  else
    oText.AddStrings(memNote.Lines);

  if memNote.Constraints.MinWidth > (pnl4.Width - 20) then
    memNote.Constraints.MinWidth := 0;
  memNote.Width := pnl4.Width - 20;
end;

procedure TfraAnatPathBuilder.AddValuesCheckList(sVals,sDefault: string);
var
  sl: TStringList;
  I: Integer;
  sItem: string;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '|';
    sl.StrictDelimiter := True;
    sl.DelimitedText := sVals;

    for I := 0 to sl.Count - 1 do
    begin
      sItem := Piece(sl[I],';',1);
      lstCheckList.Items.Add(sItem);
      if sItem = sDefault then
        lstCheckList.Checked[lstCheckList.Count - 1] := True;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfraAnatPathBuilder.AddControlItem(sIEN,sTitle,sList,sDefault,sVals: string);
var
  BuilderElement: TBuilderElement;
  i, w, max, InternalHeightSbx1, InternalHeightSbx2: Integer;
begin
  // CheckList
  if sList = '1' then
  begin
    // Only one CheckList is allowed, if pnl3 is visible then it was already
    // populated so any additional list entries will fail.
    if pnl3.Visible then
      Exit;

    pnl3.Visible := True;
    lblCheckList.Caption := sTitle;
    AddValuesCheckList(sVals, sDefault);
    if sTitle = '' then
    begin
      max := 0;
      lblCheckList.Align := alNone;
    end
    else
    begin
      max := Canvas.TextWidth(sTitle);
      lblCheckList.Align := alTop;
    end;
    for i := 0 to lstCheckList.Count-1 do
    begin
      w := Canvas.TextWidth(lstCheckList.Items[i]) + 25;
      if max < w then
        max := w;
    end;
    pnl3.Width := max + lstCheckList.Margins.Left + lstCheckList.Margins.Right;
  end
  else
  begin
    BuilderElement := TBuilderElement.Create(Self);
    try
      InternalHeightSbx1 := InternalHeight(sbx1);
      if (not pnl1.Visible) or (InternalHeightSbx1 < 150) then
      begin
        pnl1.Visible := True;
        BuilderElement.Parent := sbx1;
      end else begin
        InternalHeightSbx2 := InternalHeight(sbx2);
        if (not pnl2.Visible) or (InternalHeightSbx2 < 150) then
        begin
          pnl2.Visible := True;
          BuilderElement.Parent := sbx2;
        end else begin
          // Put the element on the smallest scrollbox if both are full
          if InternalHeightSbx1 < InternalHeightSbx2 then
            BuilderElement.Parent := sbx1
          else
            BuilderElement.Parent := sbx2;
        end;
      end;
      BuilderElement.IEN := sIEN;

      // Need to have the BuilderElement added to FElements first
      // before running Add due to vDefault
      FElements.Add(BuilderElement);
    except
      FreeAndNil(BuilderElement);
      raise;
    end;

    BuilderElement.Caption := sTitle;
    BuilderElement.Align := alTop;
    BuilderElement.Build(sVals, sDefault, '');
  end;
end;

procedure TfraAnatPathBuilder.TabSort(sbx: TScrollBox);
var
  iTop,I: Integer;
  wControl: TWinControl;
begin
  iTop := 0;
  if sbx.ControlCount > 0 then
  begin
    wControl := TWinControl(sbx.Controls[0]);
    iTop := wControl.Top;
    wControl.TabOrder := 0;
  end;

  if sbx.ControlCount > 1 then
    for I := 1 to sbx.ControlCount - 1 do
    begin
      wControl := TWinControl(sbx.Controls[I]);
      if wControl.Top < iTop then
        wControl.TabOrder := 0;
      iTop := wControl.Top;
    end;
end;

procedure TfraAnatPathBuilder.UpdateForm(sValue: string);
var
  sText: string;
begin
  sText := Piece(sValue,U,3);
  lblWPField.Caption := sText;

  if Length(sText) > 0 then
    if sText[1] = '*' then
    begin
      Delete(sText, 1, 1);
      sText := 'Required field ' + sText;
    end;

  memNote.Caption := sText;
end;

procedure TfraAnatPathBuilder.CreateBuildReturn(sValue: string;
  var BuildList: TObjectList<TBuildReturn>);
var
  BuildReturn: TBuildReturn;
begin
  // PWB applies to a Builder Element
  // PWV applies to the values of a Builder Element

  BuildReturn := BuildReturnbyIEN(BuildList, Piece(sValue,U,3));
  if BuildReturn = nil then
  begin
    BuildReturn := TBuildReturn.Create;
    BuildReturn.IEN := Piece(sValue,U,3);
    BuildList.Add(BuildReturn);
  end;

  if Piece(sValue,U,1) = 'PWB' then
    BuildReturn.B := sValue
  else if Piece(sValue,U,1) = 'PWV' then
    BuildReturn.V := sValue;
end;

procedure TfraAnatPathBuilder.FinishBuildingThisFrame(cBit: TBitmap);

  procedure SetPanelWidth(sb: TScrollBox);
  var
    I, J, w, max: integer;
    be: TBuilderElement;

  begin
    if not sb.Parent.Visible then exit;
    max := 0;
    for I := 0 to sb.ControlCount - 1 do
    begin
      if sb.Controls[I] is TBuilderElement then
      begin
        be := TBuilderElement(sb.Controls[I]);
        if assigned(be) and assigned(be.RadioGroupRef) then
        begin
          w := Canvas.TextWidth(be.Caption) + 40;
          if max < w then
            max := w;
          for J := 0 to be.RadioGroupRef.ButtonCount-1 do
          begin
            w := Canvas.TextWidth(be.RadioGroupRef.Buttons[J].Caption) + 40;
            if max < w then
              max := w;
          end;
        end;
      end;
    end;
    if max > 0 then
      sb.Parent.Width := max;
  end;

begin
  FShownPanels[0] := pnl1.Visible;
  FShownPanels[1] := pnl2.Visible;
  FShownPanels[2] := pnl3.Visible;

  SetPanelWidth(sbx1);
  SetPanelWidth(sbx2);

  if ((pnl3.Visible) and (Trim(lblCheckList.Caption) = '')) then
  begin
    lstCheckList.Top := lblCheckList.Top;
    lstCheckList.Height := lstCheckList.Height + lblCheckList.Height + 2;
  end;

  if Trim(lblWPField.Caption) = '' then
    lblWPField.Align := alNone
  else
    lblWPField.Align := alTop;

  if pnl1.Visible then
    TabSort(sbx1);
  if pnl2.Visible then
    TabSort(sbx2);

  pnl4Resize(pnl4);
end;

function TfraAnatPathBuilder.InternalHeight(sbx: TScrollBox): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to sbx.ControlCount - 1 do
    if sbx.Controls[I] is TBuilderElement then
      Result := Result + TBuilderElement(sbx.Controls[I]).Height;
end;

// Public ----------------------------------------------------------------------

constructor TfraAnatPathBuilder.CreateBuilder(FontSize: integer; AOwner: TComponent);
var
  BuildList: TObjectList<TBuildReturn>;
  sl: TStringList;
  cBit: TBitmap;
  I: Integer;
begin
  inherited Create(AOwner);
  Font.Size := FontSize;


  FLabText := TLabText.Create(Self);
  SetLength(FShownPanels, 3);
  FElements := TObjectList<TBuilderElement>.Create(True);

  BuildList := TObjectList<TBuildReturn>.Create(True);
  try
    sl := TStringList.Create;
    try
      cBit := TBitmap.Create;
      try
        ConfigureFrame(PageReference, ALabTest.OrderableItemInternal, sl);
        if (sl.Count > 0) and (sl[0] <> '0') then
        begin
          // PWB^PAGE^IEN^TITLE^LIST(1,0)^DEFAULT_VALUE
          // PWV^PAGE^IEN^VAL;D-CODE;#|VAL;E;#| (D(ate),E(dit))
          // PWW^PAGE^TITLE

          // Date Codes = PDT (Past Date/Time), FDT (Future Date/Time)
          //               PD (Past Date Only),  FD (Future Date Only)
          for I := 0 to sl.Count - 1 do
          begin
            if Piece(sl[I],U,1) = 'PWW' then
              UpdateForm(sl[I])
            else
              CreateBuildReturn(sl[I], BuildList);
          end;

          for I := 0 to BuildList.Count - 1 do
            AddControlItem(Piece(BuildList[I].B,U,3), Piece(BuildList[I].B,U,4),
                           Piece(BuildList[I].B,U,5), Piece(BuildList[I].B,U,6),
                           Piece(BuildList[I].V,U,4));

          // Due to defaulting it may be that some BuilderElements had to do something, tried,
          // and failed due to the other item not being created yet, so we need to trigger it
          // once everything has been built
          for I := 0 to FElements.Count - 1 do
            if FElements.Items[I].Value <> '' then
              FElements.Items[I].Value := FElements.Items[I].Value;
        end;

        FinishBuildingThisFrame(cBit);
      finally
        cBit.Free;
      end;
    finally
      sl.Free;
    end;
  finally
    BuildList.Free;
  end;
end;

destructor TfraAnatPathBuilder.Destroy;
begin
  if Assigned(FLabText) then
    FLabText.Free;
  SetLength(FShownPanels, 0);
  FElements.Free;

  inherited;
end;

function TfraAnatPathBuilder.GetCaption;
var
  sCaption: string;
begin
  sCaption := PageCaption;
  if sCaption <> '' then
    if sCaption[1] = '*' then
      Delete(sCaption, 1, 1);
  Result := sCaption;
end;

function TfraAnatPathBuilder.GetPromptID: string;
begin
  Result := '';

  if FLabText <> nil then
    Result := FLabText.PromptID;
end;

function TfraAnatPathBuilder.Valid: Boolean;
var
  sl: TStringList;
  I: Integer;
begin
  Result := True;

  sl := TStringList.Create;
  try
    GetText(sl);

    for I := 0 to FElements.Count - 1 do
      if not FElements.Items[I].Valid then
      begin
        Result := False;
        Break;
      end;

    if ((not Result) and (Assigned(FLabText))) then
      if ((FLabText.RestoredText.Count > 0) and
          (memNote.Text = FLabText.RestoredText.Text)) then
        Result := True;

    if Result and Required then
      if sl.Count < 1 then
        Result := False;
  finally
    sl.Free;
  end;
end;

{$ENDREGION}

end.
