unit mVimmSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, VCL.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, mVimmBase, Vcl.StdCtrls, Vcl.ExtCtrls, mVimmEdit, ORCtrls, ORFn, rVimm,
  Vcl.ImgList, Vcl.Buttons, System.ImageList, Vcl.ComCtrls, VAUtils, fBase508Form, VA508AccessibilityRouter;

type
  TfraVimmSelect = class(TfraParent)
    rgpDocumentation: TRadioGroup;
    lblImm: TLabel;
    cboImm: TORComboBox;
    gridPanel: TGridPanel;
    pnlImm: TPanel;

    procedure rgpDocumentationClick(Sender: TObject);
    procedure rgpDocumentationEnter(Sender: TObject);
    procedure cboImmKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboImmMouseClick(Sender: TObject);
  private
    { Private declarations }
    adminDate: TFMDateTime;
    remSelectId: string;
    iceSelectData: string;
    patientIEN: string;
    editingRecord : boolean;
    function getDocumentType: string;
    function getLayoutValue: integer;
    procedure selectPage(data: string; details, edit: boolean);
//    function getEditControl: TControl;
    function performCheck(immunization, patient: string; edit: boolean): integer;
    function isActiveLookup: boolean;
    procedure clearSelectionLookup;
    function checkReadingList: boolean;
    procedure populateSelectionList;
    procedure startFromSelectionLookup;
    function returnPendingPlacements: string;
    function findReadingIndex: integer;
    function findAdminIndex: integer;
  protected
    isEditing: boolean;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    procedure setSelectionType(isSkin: boolean);
    procedure startEdits(data: string = ''; details: boolean = false; edit: boolean = true);
    function startEditsFromMain(data: string; edit: boolean): boolean;
    function setEditFields(immunization: string): boolean;
    procedure collapse;
    procedure expand;
    procedure disableImmLookup;
    procedure clearFields;
    procedure clearEditFields;
    procedure setEncounterData(date: TFMDateTime; patient: string; isSkin: boolean);
    procedure startFromReminders(input: string);
    procedure startFromIce(input: string);
    function canChange(input, inputType: string): boolean;
    procedure controlRadioGroup(enable: boolean);
    function getEditControl: TControl;
  end;

//var
//  fraVimmSelect: TfraVimmSelect;

implementation

{$R *.dfm}
var
tempImm: string;
isSkinTest: boolean;

function TfraVimmSelect.canChange(input, inputType: string): boolean;
begin
  result := true;
  if inputType <> 'rem' then exit;

  if isEditing and (remSelectId <> '') and (remSelectId <> Input) then
    begin
    if InfoBox('Currently editing a record. All data will be lost if you continue.' + CRLF + CRLF+
    'Click Yes to Continue.', 'WARNING', MB_YESNO) = IDNO then
      begin
        rgpDocumentation.ItemIndex := rgpDocumentation.Tag;
        result := false;
        exit;
      end
      else
        begin
          clearFields;
        end;
    end;
end;

procedure TfraVimmSelect.cboImmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

  if Key = VK_LEFT then
    Key := VK_UP;
  if Key = VK_RIGHT then
    Key := VK_DOWN;
  if Key = VK_RETURN then
    begin
      cboImm.OnMouseClick(cboImm);
    end;
end;

procedure TfraVimmSelect.cboImmMouseClick(Sender: TObject);
var
tmp: string;
begin
  inherited;
  if cboImm.itemIndex = -1 then exit;
  tmp := cboImm.Items.Strings[cboImm.ItemIndex];
  selectPage(tmp, false, false);
end;

{function TfraVimmSelect.changeDocumentationType: boolean;
begin
  result := true;
  if isEditing and (rgpDocumentation.Tag > -1)  and
  (InfoBox('Currently editing a record. All data will be lost if you continue.' + CRLF + CRLF+
  'Click Yes to Continue.', 'WARNING', MB_YESNO) = IDNO) then
  begin
    rgpDocumentation.ItemIndex := rgpDocumentation.Tag;
    result := false;
  end;
end;
}

function TfraVimmSelect.checkReadingList: boolean;
begin
  result := true;
  if isSkinTest and (rgpDocumentation.ItemIndex = 1) and (not editingRecord) then
    begin
      if not placementsOnFile then
        begin
          ShowMessage('A skin test reading cannot be entered without documentation of the application of the skin test.' + CRLF +
                     'Document application of the skin test and then enter the reading of that entry.');
          result := false;
        end;
    end;
end;

procedure TfraVimmSelect.clearEditFields;
var
aControl: TControl;
begin
  clearFields;
  aControl := getEditControl;
  if (aControl is TFraImmEdit) then  TFraImmEdit(aControl).cancelFromMain;
end;

procedure TfraVimmSelect.clearFields;
begin
  if (isEditing) or (rgpDocumentation.ItemIndex > -1) then
    begin
//      cboImm.itemIndex := -1;
//      cboImm.text := '';
//      cboImm.Enabled := false;
      clearSelectionLookup;
      cboImm.Enabled := false;
      rgpDocumentation.ItemIndex := -1;
      isEditing := false;
      rgpDocumentation.Enabled := false;
    end;
  remSelectId := '';
  iceSelectData := '';
end;

procedure TfraVimmSelect.clearSelectionLookup;
begin
  cboImm.ItemIndex := -1;
  cboImm.Text := '';
  cboImm.Items.Clear;
end;

procedure TfraVimmSelect.collapse;
begin
  if not fCollapsed then spbtnExpandCollapseClick(self);
end;

procedure TfraVimmSelect.controlRadioGroup(enable: boolean);
begin
  self.rgpDocumentation.Enabled := enable;
end;

constructor TfraVimmSelect.Create(aOwner: TComponent);
begin
  inherited;
  style := ssAbsolute;
  minValue := pnlWorkspace.Top + pnlWorkspace.Height;
  isEditing := false;
  remSelectId := '';
  iceSelectData := '';
  if screenReaderActive then
    rgpDocumentation.Caption := rgpDocumentation.Caption + ' (Required)'
  else rgpDocumentation.Caption := rgpDocumentation.Caption + '*';
//  if isSkin then

end;

procedure TfraVimmSelect.disableImmLookup;
begin
  cboImm.Enabled := false;
end;

procedure TfraVimmSelect.expand;
begin
  if fCollapsed then spbtnExpandCollapseClick(self);
end;

function TfraVimmSelect.findAdminIndex: integer;
var
i: integer;
begin
 result := -1;
 for i := 0 to rgpDocumentation.Items.Count - 1 do
  begin
     if rgpDocumentation.Items.Strings[i] = '&Administered' then
      begin
        result := i;
        exit;
      end;
  end;
end;

function TfraVimmSelect.findReadingIndex: integer;
var
i: integer;
begin
 result := -1;
 for i := 0 to rgpDocumentation.Items.Count - 1 do
  begin
     if rgpDocumentation.Items.Strings[i] = '&Reading' then
      begin
        result := i;
        exit;
      end;
  end;
end;

//get the edit frame control. Always the last row in the parent grid panel
function TfraVimmSelect.getDocumentType: string;
begin
  if not isSkinTest then
    begin
      if uVimmInputs.selectionType = 'historical' then
            begin
              case rgpDocumentation.ItemIndex of
                0: result := 'Historical';
                1: result := 'Contraindication/Precaution';
                2: result := 'Refused';
              end;
            end
          else if uVimmInputs.selectionType = 'current' then
            begin
              case rgpDocumentation.ItemIndex of
                0: result := 'Administered';
                1: result := 'Contraindication/Precaution';
                2: result := 'Refused';
              end
            end
          else
            begin
              case rgpDocumentation.ItemIndex of
                0: result := 'Administered';
                1: result := 'Historical';
                2: result := 'Contraindication/Precaution';
                3: result := 'Refused';
            end;
          end;
        end
    else
      begin
        if uVimmInputs.selectionType = 'historical' then
          begin
             case rgpDocumentation.ItemIndex of
              0: result := 'Historical';
            end;
          end
        else if uVimmInputs.selectionType = 'current' then
          begin
            case rgpDocumentation.ItemIndex of
              0: result := 'Administered';
              1: result := 'Reading';
            end;
          end
        else
          begin
            case rgpDocumentation.ItemIndex of
              0: result := 'Administered';
              1: result := 'Reading';
              2: result := 'Historical';
            end;
          end;
      end;
end;

function TfraVimmSelect.getEditControl: TControl;
var
grid: TGridPanel;
begin
    grid := TGridPanel(self.Parent);
    result := grid.ControlCollection.Controls[0, grid.RowCollection.Count - 1];
end;

function TfraVimmSelect.getLayoutValue: integer;
begin
 if isSkinTest then
  begin
    if uVimmInputs.selectionType = 'historical' then
      result := 2
    else result := rgpDocumentation.ItemIndex;
  end
 else
  begin
    if uVimmInputs.selectionType = 'historical' then
      begin
        result := rgpDocumentation.ItemIndex + 1
      end
    else if uVimmInputs.selectionType = 'current' then
      begin
        if rgpDocumentation.ItemIndex = 0 then result := 0
        else result := rgpDocumentation.ItemIndex + 1
      end
    else result := rgpDocumentation.ItemIndex;
  end;

end;

function TfraVimmSelect.isActiveLookup: boolean;
var
idx: integer;
begin
   idx := rgpDocumentation.ItemIndex;
   if idx > 0 then result := false
   else if uVimmInputs.selectionType = 'historical' then
    result := false
   else result := true;
end;

//check per documenting an administration of an immunization if patient has an refusal or a
//contraindication on file
function TfraVimmSelect.performCheck(immunization, patient: string; edit: boolean): integer;
var
warn, warn1: string;
begin
  // result = 0 no warning display, -1 user cancel the process, 1 user ok the warning continue the process
  result := 0;
  warn1 := 'Click Ok to continue or Cancel to Quit';
  if (self.rgpDocumentation.ItemIndex = 0) and (Pos('Admin', self.rgpDocumentation.Items[0])>0) then
    begin
      warn := checkForWarning(patient, immunization, self.adminDate);
      if warn <> '' then
        begin
//          if edit then
//            begin
//              result := 1;
//              exit;
//            end;
          if messageDlg(warn + CRLF + CRLF + warn1, mtWarning, [mbOK, mbCancel], 0) = mrCancel then result := -1
          else result := 1;
        end;
    end;
end;

procedure TfraVimmSelect.populateSelectionList;
var
tmpList: TStringList;
begin
  tmpList := TStringList.Create;
  try
    if isSkinTest and (remSelectId <> '') then getSubSetData(tmpList, 'rem', remSelectId)
    else if isSkinTest then getShortActiveLookup(tmpList, true, not editingRecord)
    else if iceSelectData <> '' then getSubSetData(tmpList, 'ice', iceSelectData)
    else if remSelectId <> '' then getSubSetData(tmpList, 'rem', remSelectId)
    else if isActiveLookup then getShortActiveLookup(tmpList, false, false)
    else getShortHistoricalLookup(tmpList);
    if isSkinTest and uVimmInputs.hasPlacements then cboImm.Sorted := false
    else cboImm.Sorted := true;
    FastAssign(tmpList, cboImm.Items);
    if isSkinTest and uVimmInputs.hasPlacements and (cboImm.Items.Count = 1) then
      cboImm.ItemIndex := 0;
  finally
    FreeAndNil(tmpList);
  end;

end;

function TfraVimmSelect.returnPendingPlacements: string;
var
i: integer;
node: string;
begin
  result := '';
  for I := 0 to uVimmList.skinAdminList.Count - 1 do
    begin
      node := uVimmList.skinAdminList.Strings[i];
      result := Result + CRLF +
      Piece(node, U, 3) + ' placed on: ' + FormatFMDateTime('mm/dd/yyyy@hh:nn', StrToFloat(Piece(node,u,4)));
    end;
end;

procedure TfraVimmSelect.rgpDocumentationClick(Sender: TObject);
var
//tmpList: TStringList;
aControl: TControl;
idx: integer;
name, orgImm: string;
isDisable: boolean;
begin
//  tmpList := TStringList.Create;
  try
    //prompt for warning when changing documentation status and in the middle of an edit process
//    if isEditing and ((rgpDocumentation.Tag > -1) and  (rgpDocumentation.ItemIndex <> rgpDocumentation.Tag)) and
//    (InfoBox('Currently editing a record. All data will be lost if you continue.' + CRLF + CRLF+
//    'Click Yes to Continue.', 'WARNING', MB_YESNO) = IDNO) then
//      begin
//        rgpDocumentation.ItemIndex := rgpDocumentation.Tag;
//        exit;
//      end;
//    if isEditing and (rgpDocumentation.ItemIndex = rgpDocumentation.Tag) then exit;

//    if (rgpDocumentation.ItemIndex <> rgpDocumentation.Tag) and (not changeDocumentationType)
//      then exit;


    isDisable := cboImm.Enabled = false;
    if rgpDocumentation.ItemIndex > -1 then cboImm.Enabled := true;
    if rgpDocumentation.Tag > -1 then
      begin
        aControl := getEditControl;
        if (aControl is TFraImmEdit) then
          TFraImmEdit(aControl).createLayout(-1, '', '', false, false);
      end;
    rgpDocumentation.Tag := rgpDocumentation.ItemIndex;

    if isDisable then orgImm := cboImm.Text;
    if not checkReadingList then
      begin
        rgpDocumentation.ItemIndex := findAdminIndex;
//        clearSelectionLookup;
        exit;
      end;
    if ((remSelectId <> '') or (iceSelectData <> '')) and (cboImm.Items.Count > 1) then
      begin
        cboImm.ItemIndex := -1;
        cboImm.Caption := '';
      end;
    if (remSelectId = '') and (iceSelectData = '') then
      begin
        clearSelectionLookup;


//      if isSkinTest and (remId <> '') then getSubSetData(tmpList, 'rem', remId)
//      else if isSkinTest then getShortActiveLookup(tmpList, true, not editingRecord)
//      else if iceData <> '' then getSubSetData(tmpList, 'ice', iceData)
//      else if remId <> '' then getSubSetData(tmpList, 'rem', remId)
//      else if isActiveLookup then getShortActiveLookup(tmpList, false, false)
//      else getShortHistoricalLookup(tmpList);
//      if isSkinTest and uVimmInputs.hasPlacements then cboImm.Sorted := false
//      else cboImm.Sorted := true;
//
//      FastAssign(tmpList, cboImm.Items);
        populateSelectionList;
      end;
    if isSkinTest and placementsOnFile and (not editingRecord) then
      begin
        if (rgpDocumentation.ItemIndex = 0) and (rgpDocumentation.Items.Count > 1) then
          begin
            ShowMessage('Cannot document application of a new skin test when a previously applied skin test has not been read. '+
                        'A reading of the previously placed skin test must be documented prior to creating a new entry.'
                        + CRLF + returnPendingPlacements);
            rgpDocumentation.ItemIndex := findReadingIndex;
            exit;
          end;
      end;

    if cboImm.Items.Count = 1 then
      begin
        cboImm.ItemIndex := 0;
        startFromSelectionLookup;
//        cboImm.OnClick(cboImm);
      end;
    if isDisable then
      begin
        cboImm.Enabled := true;
        idx := cboImm.Items.IndexOf(orgImm);
        if idx > 0 then
          begin
            cboImm.ItemIndex := idx;
//            cboImm.OnClick(cboImm);
            cboImm.Enabled := false;
            startFromSelectionLookup;
          end;
      end;

    //tempIMM defined when calling the calling the frame with an immunization but no documentation
    //status
    if tempIMM <> '' then
      begin
        name := Piece(tempIMM, U, 2);
        idx := cboImm.items.indexOf(name);
        if idx = -1 then exit;
        cboImm.itemIndex := idx;
        startFromSelectionLookup;
//        cboImm.text := name;
//        selectPage(cboImm.Items.Strings[idx], false, false);
      end;
  finally
//    FreeAndNil(tmpList);
  end;
end;

procedure TfraVimmSelect.rgpDocumentationEnter(Sender: TObject);
begin
  inherited;
  rgpDocumentation.Tag := rgpDocumentation.ItemIndex;
//  if ScreenReaderActive then
//    getScreenReader.Speak(rgpDocumentation.Caption + ' use up down arrow keys to navigate through the selection');
  if TabIsPressed or ShiftTabIsPressed then
    begin
      if rgpDocumentation.ItemIndex > -1 then
        begin
          rgpDocumentation.Buttons[rgpDocumentation.ItemIndex].SetFocus;
        end
      else rgpDocumentation.Buttons[0].SetFocus;
    end;
end;

//called
procedure TfraVimmSelect.selectPage(data: string; details, edit: boolean);
var
aControl: TControl;
warn: integer;
needsOverride: boolean;
layout: integer;
documType: string;
begin
  aControl := getEditControl;
  needsOverride := false;
  if details = true then
    begin
//      TFraImmEdit(aControl).setPage(TFraImmEdit(aControl).pgDetails, data, edit, needsOverride);
      controlRadioGroup(false);
      if (aControl is TFraImmEdit) then
        TFraImmEdit(aControl).createLayout(4, '', data, true, false);
      spbtnExpandCollapseClick(self);
      exit;
    end;
  isEditing := true;
  if (rgpDocumentation.ItemIndex = 0) and (cboImm.ItemIndex > -1) and (not isSkinTest) then
    begin
      warn := performCheck(cboImm.Items.Strings[cboImm.ItemIndex], self.patientIEN, edit);
      if warn = -1 then
        begin
          rgpDocumentation.ItemIndex := -1;
          cboImm.Text := '';
          cboImm.ItemIndex := -1;
          if (aControl is TFraImmEdit) then
            TFraImmEdit(aControl).cancelFromMain;
          exit;
        end
      else if warn = 1 then needsOverride := true;
  end;
  layout := getLayoutValue;
  documType := getDocumentType;
//  if (edit = false) and (not editingRecord) then
  if (not edit) and (not editingRecord) and (documType <> 'Historical') then
    begin
      if hasVimmResult(data, documType) then
        begin
          ShowMessage('Cannot add more than one record with the same documentation Type');
          exit;
        end;
    end;
  if edit and (rgpDocumentation.ItemIndex > -1) then controlRadioGroup(false)
  else controlRadioGroup(true);
  if (aControl is TFraImmEdit) then
    TFraImmEdit(aControl).createLayout(layout, documType, data, edit, needsOverride);
end;

//set initial edit values either from the grid or the main form
//for first time new immunization entry. Most likely have the immunization but not the
//documentation status
function TfraVimmSelect.setEditFields(immunization: string): boolean;
var
vid,name,documType: string;
idx: integer;
tmpList: TStringList;
begin
  result := false;
  tempImm := '';
  vid := Piece(immunization, U, 1);
  name := Piece(immunization, U, 2);
  documType := Piece(immunization, u, 3);
  if documType = 'Contraindication' then
    documType := 'Contraindication/Precaution';
  if name = genericIMM then
    begin
      if uVimmInputs.documentType = '0' then documType := 'Administered'
      else if uVimmInputs.documentType = '1' then documType := 'Historical'
    end;
  if documType = '' then
    begin
      tempImm := immunization;
      result := true;
      rgpDocumentation.Enabled := true;
      exit;
    end;
    idx := rgpDocumentation.Items.IndexOf('&' + documType);
    if idx = -1 then
      begin
        showMessage(documType + ' not found in the documenation Type list.');
        exit;
      end;
    rgpDocumentation.ItemIndex := idx;
//    rgpDocumentationClick(rgpDocumentation);
    if cboImm.Items.Count = 0 then
    begin
      tmpList := TStringLIst.Create;
      try
        getShortActiveLookup(tmpList, true, not editingRecord);
        FastAssign(tmpList, cboImm.Items);
      finally
        FreeAndNil(tmpList);
      end;
    end;
  if (name <> genericIMM) and (name <> '') then
    begin
      idx := cboImm.items.indexOf(name);
      if idx = -1 then
        begin
          showNoActiveImmMsg(name);
          self.rgpDocumentation.ItemIndex := -1;
//          showMessage(name + ' - No inventory or lot numbers of this vaccine are recorded in CPRS as being available for administration at this site.' +
//              CRLF + ' Please contact whoever manages your local vaccine inventory.');
          exit;
        end;
      cboImm.itemIndex := idx;
      cboImm.Enabled := false;
      result := true;
    end
    else
      begin
        cboImm.itemIndex := -1;
        cboImm.Enabled := true;
//        result := true;
      end;
end;

//procedure to set encounter data from the form
procedure TfraVimmSelect.setEncounterData(date: TFMDateTime; patient: string; isSkin: boolean);
begin
  isSkinTest := isSkin;
  self.adminDate := date;
  self.patientIEN := patient;
  if uVimmInputs.encounterCategory = 'H' then
    getIMMShortList(0, isSkinTest)
  else getIMMShortList(date, isSkinTest);
end;

procedure TfraVimmSelect.setSelectionType(isSkin: boolean);
begin
//  if isSkin then self.pgeSelector.ActivePage := pgSkin
//  else self.pgeSelector.ActivePage := pgImm;
  isSkinTest := isSkin;
  if isSkinTest then
      begin
        lblImm.Caption := 'Select a Skin Test';
        rgpDocumentation.Items.Clear;
        if uVimmInputs.selectionType = 'historical' then
          rgpDocumentation.Items.Add('&Historical')
        else if uVimmInputs.selectionType = 'current' then
          begin
            rgpDocumentation.Items.Add('&Administered');
            rgpDocumentation.Items.Add('&Reading');
//            rgpDocumentation.Items.Add('&Historical');
          end
        else
          begin
            rgpDocumentation.Items.Add('&Administered');
            rgpDocumentation.Items.Add('&Reading');
            rgpDocumentation.Items.Add('&Historical');
          end;
        lblHeader.Caption := 'Skin Test Selection';
      end
  else
      begin
        lblImm.Caption := 'Select an Immunization';
        rgpDocumentation.Items.Clear;
        if uVimmInputs.selectionType = 'historical' then
          begin
            rgpDocumentation.Items.Add('&Historical');
            rgpDocumentation.Items.Add('&Contraindication/Precaution');
            rgpDocumentation.Items.Add('&Refused');
          end
        else if uVimmInputs.selectionType = 'current' then
          begin
            rgpDocumentation.Items.Add('&Administered');
            rgpDocumentation.Items.Add('&Contraindication/Precaution');
            rgpDocumentation.Items.Add('&Refused');
          end
        else
          begin
            rgpDocumentation.Items.Add('&Administered');
            rgpDocumentation.Items.Add('&Historical');
            rgpDocumentation.Items.Add('&Contraindication/Precaution');
            rgpDocumentation.Items.Add('&Refused');
          end;
        lblHeader.Caption := 'Immunization Selection';
      end;
  if screenReaderActive then
    lblImm.Caption := lblImm.Caption + ' (Required)'
  else lblImm.Caption := lblImm.Caption + '*';
end;

//edit process called form the immunization grid frame. Use when the grid is showing
procedure TfraVimmSelect.startEdits(data: string = ''; details: boolean = false; edit: boolean = true);
begin
  if self.fCollapsed then self.expand;
  rgpDocumentation.Enabled := true;
  editingRecord := edit;
  if isSkinTest and ((uVimmInputs.documentType = '0') or (uVimmInputs.documentType = '')) and (not editingRecord)  then
    begin
      if placementsOnFile then
        begin
          self.rgpDocumentation.ItemIndex := 1;
          SetPiece(data, u, 3, 'Reading');
          if uVimmList.skinAdminList.Count = 1 then
            begin
              SetPieces(data, u, [1,2], Pieces(uVimmList.skinAdminList.Strings[0], u, 2,3));
            end;

        end
      else self.rgpDocumentation.ItemIndex := 0;
    end;
  if (data <> '') and (details = false) and (not setEditFields(data)) then exit;
  if data <> '' then selectPage(data, details, edit);
end;

//edit process called from the form. This is used when the the immunization grid does not show in the form
function TfraVimmSelect.startEditsFromMain(data: string; edit: boolean): boolean;
var
documentType: string;
begin
   result := true;
   documentType :=  Piece(data, U, 3);
    if documentType <> '' then
      begin
        documentType := Copy(self.rgpDocumentation.Items.Strings[StrToInt(documentType)], 2,
          Length(self.rgpDocumentation.Items.Strings[StrToInt(documentType)]));
        setPiece(data, U, 3, documentType);
      end;
   if not setEditFields(data) then
    begin
      result := false;
      exit;
    end;

    self.spBtnExpandCollapse.Visible := false;
    self.lblHeader.Left := 5;
    if cboImm.ItemIndex > -1 then
        begin
          self.lblHeader.Caption := Piece(self.cboImm.Items.Strings[self.cboImm.ItemIndex], U, 2) + ' ' + documentType + ' documentation';
          self.gridPanel.ColumnCollection.BeginUpdate;
          self.gridPanel.ColumnCollection[0].Value := 0;
          self.gridPanel.ColumnCollection[1].Value := 100;
          self.gridPanel.ColumnCollection.EndUpdate;
          cboImm.Enabled := false;
        end;
    selectPage(data, false, edit);
end;

procedure TfraVimmSelect.startFromIce(input: string);
begin
  iceSelectData := Piece(input, U, 1);
  clearSelectionLookup;
  populateSelectionList;
  if cboImm.Items.Count = 0 then
    begin
      ShowNoActiveImmMsg(iceSelectData);
      self.rgpDocumentation.ItemIndex := -1;
      iceSelectData := '';
      exit;
    end;
  rgpDocumentation.ItemIndex := 0;
  rgpDocumentationClick(rgpDocumentation);
end;

procedure TfraVimmSelect.startFromReminders(input: string);
var
name: string;
begin
  name := Piece(input, U, 2);
  remSelectId := Piece(input, U, 1);
  clearSelectionLookup;
  populateSelectionList;
  if cboImm.Items.Count = 0 then
    begin
      ShowNoActiveImmMsg(name);
      self.rgpDocumentation.ItemIndex := -1;
      remSelectId := '';
      exit;
    end;
  rgpDocumentation.ItemIndex := 0;
  rgpDocumentation.Enabled := true;
//  rgpDocumentationClick(rgpDocumentation);
end;

procedure TfraVimmSelect.startFromSelectionLookup;
var
tmp: string;
begin
  tmp := cboImm.Items.Strings[cboImm.ItemIndex];
  selectPage(tmp, false, false);
end;

end.
