unit fVimm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  fBase508Form, mVimMBase, mVimmSelect, mVimmGrid, mVimmEdit, mVimmReminders,
  rVimm, ORFn, rmisc, mVimmICE, fPDMPCosigner, VA508AccessibilityManager, VAUtils;

type

  TvimmMainForm = class(TfrmBase508Form)
    Panel1: TPanel;
    btnCancel: TButton;
    GridPanel: TGridPanel;
    btnSave: TButton;
    ScrollBox: TScrollBox;
    pnlForm: TPanel;
    btnAdd: TButton;
    btnCancelRecord: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBoxResize(Sender: TObject);
    procedure SetScrollBarHeight(FontSize: Integer);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelRecordClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    initialList:  TStringList;
    noteString: string;
    noteIEN: string;
    visitIEN: string;
    MinFormHeight: Integer; //Determines when the scrollbars appear
    MinFormWidth: Integer;
    showICE: boolean;
    function validateInput: boolean;
    procedure createGridPanel;
    procedure setInitialGridValues;
    procedure disableButtons;
    procedure saveRecords;
  public
    { Public declarations }
  end;

  function performVimm(var resultList: TStringList; saveData: boolean = false): boolean;
var
  vimmMainForm: TvimmMainForm;

implementation
var
frmInfoDisplay, frmGrid, frmImm, frmImmEdit: TFrame;

{$R *.dfm}
// possible inputs and recommended settings
     //reminders for a single finding
     //NoGrid = true
     //collapseICE = true
     //makeNote = false
     //canSaveData = false
     //
     //reminders for a new generic finding
     //NoGrid = false
     //collapseICE = false
     //makeNote = false
     //canSaveData = false
     //
     //coversheet
     //NoGrid = false
     //collapseICE = false
     //makeNote = true
     //canSaveData = true
     //
     //BCMA
     //NoGrid - true
     //collapseICE = true
     //makeNote = true
     //canSaveData = true


function performVimm(var resultList: TStringList; saveData: boolean = false): boolean;
begin
  try
    result := false;
    if not assigned(vimmMainForm) then vimmMainForm := TVimmMainForm.Create(Application);
    if not vimmMainForm.validateInput then
      begin
        exit;
      end;
    vimmMainForm.showICE := useICEForm;
//    checkEncounterInfo;
    vimmMainForm.createGridPanel;
    vimmMainForm.setInitialGridValues;
    uVimmInputs.canSaveData := saveData;
    if uVimmInputs.selectionType = 'historical' then
      vimmMainForm.Caption :=  vimmMainForm.Caption + ' Historical Documentation Only';
    if vimmMainForm.ShowModal = mrOK then
      begin
        result := true;
        if not uVimmInputs.canSaveData then
          begin
            getVimmResultList(resultList);
//            if not uVimmInputs.isSkinTest then getBillingCodes(uVimmInputs.dateEncounterDateTime);
          end
        else if vimmMainForm.noteString <> '' then resultList.Add(vimmMainForm.noteString);
      end;
  finally
     FreeAndNil(vimmMainForm);
  end;

end;

procedure TvimmMainForm.btnSaveClick(Sender: TObject);
var
aControl: TControl;
begin
  aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
  if TFraImmEdit(aControl).isEditing and (aControl is TFraImmEdit) then
    begin
      if uVimmInputs.immunizationReading or uVimmInputs.noGrid then
        begin
          if TFraImmEdit(aControl).saveFromMain then
            modalResult := mrOk
          else
            begin
              infoBox('Cannot save with an incomplete record', 'Error', MB_OK);
              exit;
            end;
        end
      else
        begin
          ShowMessage('Cannot exit the form when editing a record.' + CRLF +
                      'Either select the "Clear" button or the "Save" button before exiting the forms');
          exit;
        end;
    end;
  if not uVimmInputs.noGrid then
    begin
      aControl := self.GridPanel.ControlCollection.Controls[0, 1];
      if (aControl is TfraGrid) then
      begin
        if (TfraGrid(aControl).gridCount < 1) then
          begin
            modalResult := mrOK;
            exit;
          end
        else
          begin
            if not TfraGrid(aControl).validateGridResults then
              begin
                infoBox('Cannot save with an incomplete record', 'Error', MB_OK);
                exit;
              end;
          end;
      end;
    end;
    saveRecords;
end;


procedure TvimmMainForm.saveRecords;
var
activeList, historicalList, noteList, PCEList: TStringList;
noteResult, vStr: String;

  procedure BuildCurrentData(activeList: TStringList; encDate: TFMDateTime; encLoc, encType, encProv, patient, vStr: String; var PCEList: TStringList);
    begin
      buildCurrentPCEList(activeList, encDate, encLoc, encType, encProv, patient, vStr, self.noteString, pcelist);
    end;

  procedure BuildHistoricalData(historicalList: TStringList; encProv, patient: String; var PCEList);
    begin
      saveHistoricalData(historicalList, encProv, patient, self.noteIEN, self.visitIEN);
    end;

begin
  activeList := TStringList.Create;
  historicalList := TStringList.Create;
  noteList := TStringList.Create;
  PCEList := TStringList.Create;
  try
  //canSaveData is true if called from CPRS coversheet or external application
  if uVimmInputs.CanSaveData then
      saveData(uVimmInputs.dateEncounterDateTime, IntToStr(uVimmInputs.encounterLocation), uVimmInputs.encounterCategory,
                      IntToStr(uVimmInputs.encounterProviderIEN) + U + uVimmInputs.encounterProviderName, uVimmInputs.patientIEN,
                      IntToStr(uVimmInputs.userIEN), activeList, historicalList, noteList);
   vStr := IntToStr(uVimmInputs.encounterLocation) + ';' + FloatToStr(uVimmInputs.dateEncounterDateTime) + ';' + uVimmInputs.encounterCategory;

  if noteList.Count > 0 then
    begin
      noteResult := saveNoteText(noteList, uVimmInputs.dateEncounterDateTime, IntToStr(uVimmInputs.encounterLocation),
                                uVimmInputs.encounterCategory, uVimmInputs.visitString, uVimmInputs.patientIEN,
                                IntToStr(uVimmInputs.userIEN), IntToStr(uVimmInputs.coSignerIEN));
      if Piece(noteResult, U, 1)= '0' then
        begin
          infoBox(Piece(noteResult, U, 2), 'Could not save note', MB_OK);
        end
      else
        begin
        self.noteString := noteResult;
        self.noteIEN := Piece(noteResult, u, 1);
//        self.visitIEN := Piece(noteResult, u, 3);
        end;
    end;

  if historicalList.Count > 0 then
    begin
      if PCEList.Count > 0 then PCEList.Clear;
      BuildHistoricalData(historicalList, IntToStr(uVimmInputs.encounterProviderIEN) + U + uVimmInputs.encounterProviderName,
                          uVimmInputs.patientIEN, PCEList);
    end;
  if activeList.Count > 0 then
    begin
      BuildCurrentData(activeList, uVimmInputs.dateEncounterDateTime, IntToStr(uVimmInputs.encounterLocation), uVimmInputs.encounterCategory,
                       IntToStr(uVimmInputs.encounterProviderIEN) + U + uVimmInputs.encounterProviderName, uVimmInputs.patientIEN,
                       uVimmInputs.visitString, PCEList);
//      if PCEList.Count > 0 then SavePCEData(PCEList, 0, uVimmInputs.encounterLocation);
    end;

  if uVimmInputs.canSaveData then clearResults;

  modalResult := mrOK;
  finally
  FreeAndNil(activeList);
  FreeAndNil(historicalList);
  FreeAndNil(noteList);
  FreeAndNil(PCEList);
  end;

end;

procedure TvimmMainForm.btnAddClick(Sender: TObject);
var
aControl: TControl;
begin
  aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
  modalResult := mrNone;
  if (acontrol is TFraImmEdit) then TFraImmEdit(aControl).saveFromMain;
end;

procedure TvimmMainForm.btnCancelClick(Sender: TObject);
var
aControl: TControl;
begin
  modalResult := mrCancel;
  aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
  if (uVimmInputs.immunizationReading or uVimmInputs.noGrid) and
    ((aControl is TFraImmEdit) and TFraImmEdit(aControl).isEditing) then
    begin
//      aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
      if (aControl is TFraImmEdit) then
        TFraImmEdit(aControl).cancelFromMain;
    end;
  if uVimmInputs.canSaveData then
    clearResults;
  Release;
end;



procedure TvimmMainForm.btnCancelRecordClick(Sender: TObject);
var
aControl: TControl;
begin
  aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
  if (aControl is TFraImmEdit) then TFraImmEdit(aControl).cancelFromMain;
  modalResult := mrNone;
end;

procedure TvimmMainForm.createGridPanel;
var
aRow, aCol: integer;

  procedure PlaceFrame(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign);
  var
  i: integer;
    begin
      aControl.Parent := aGridPanel;
      aGridPanel.ControlCollection.AddControl(aControl, aCol, aRow);
      aControl.Align := aAlign;
      aGridPanel.RowCollection[aRow].SizeStyle := TFraParent(aControl).style;
      aGridPanel.RowCollection[aRow].Value := TFraParent(aControl).minValue;
      if ScreenReaderActive then
        begin
          for i := 0 to AControl.ComponentCount - 1 do
            begin
              if AControl.Components[i] is TWinControl then
                self.amgrMain.AccessData.EnsureItemExists(AControl.Components[i] as TWinControl);
            end;
        end;
    end;

begin
  try
    if not application.Terminated then
      begin
        gridPanel.RowCollection.BeginUpdate;
        if uVimmInputs.noGrid then
          begin
            if gridPanel.RowCollection.Count > 3 then gridPanel.RowCollection[3].Destroy;
          end
        else if gridPanel.RowCollection.Count = 3 then
          begin
            gridPanel.RowCollection.Add
          end;
        aCol := 0;
        aRow := 0;
        if showICE then frmInfoDisplay := TFraICE.Create(gridPanel)
        else frmInfoDisplay := TfraReminders.create(gridPanel);
        placeFrame(gridPanel, frmInfoDisplay, aCol, aRow, alClient);
        if (not showICE) and (ScreenReaderActive) then TfraReminders(frmInfoDisplay).setup508Controls(self.amgrMain);

        //noGrid is true if called from Reminders with a specific immunization or from external application
        if uVimmInputs.noGrid = false then
          begin
            inc(ARow);
            frmGrid := TfraGrid.Create(gridPanel);
            placeFrame(gridPanel, frmGrid, aCol, aRow, alClient);
            TFraGrid(frmGrid).setText(uVimmInputs.isSkinTest);
            if (not showICE) and (ScreenReaderActive) then TFraGrid(frmGrid).setup508Controls(self.amgrMain);
          end;
        inc(aRow);
        frmImm := TfraVimmSelect.Create(gridPanel);
        placeFrame(gridPanel, frmImm, aCol, aRow, alClient);
        TfraVimmSelect(frmImm).setSelectionType(uVimmInputs.isSkinTest);
        TfraVimmSelect(frmImm).setEncounterData(uVimmInputs.dateEncounterDateTime, uVimmInputs.patientIEN, uVimmInputs.isSkinTest);
        frmImmEdit := TfraImmEdit.Create(gridPanel);
        inc(aRow);
        placeFrame(gridPanel, frmImmEdit, aCol, aRow, alClient);
        TfraImmEdit(frmImmEdit).setEncounterData(uVimmInputs.dateEncounterDateTime, uVimmInputs.encounterProviderName,
                                                IntToStr(uVimmInputs.encounterProviderIEN), uVimmInputs.userName,
                                                IntToStr(uVimmInputs.userIEN), IntToStr(uVimmInputs.encounterLocation),
                                                uVimmInputs.visitString);
        if uVimmInputs.noGrid = true then
          begin
//            TfraImmEdit(frmImmEdit).btnOk.Caption := 'Save and Exit';
            disableButtons;
          end;
        gridPanel.RowCollection.EndUpdate;
        self.btnCancel.TabStop := true;
        self.btnSave.TabStop := true;
      end;
  finally
  end;
end;

//disable edit frame buttons if the application is updating one item only.
//reminders with spedific finding or external application
procedure TvimmMainForm.disableButtons;
begin
//   aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
//   TfraImmEdit(aControl).btnOk.Enabled := false;
//   TfraImmEdit(aControl).btnCancel.Enabled := false;
//   TfraImmEdit(aControl).pnlBottom.Visible := false;
end;

procedure TvimmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  try
    SaveUserBounds(Self);
    Action := caFree;
  finally
    Action := caFree;
  end;
end;

procedure TvimmMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
aControl: TControl;
begin
  inherited;
  if modalResult = mrOk then
    exit;
  modalResult := mrCancel;
  aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
  if (uVimmInputs.immunizationReading or uVimmInputs.noGrid) and
    ((aControl is TFraImmEdit) and TFraImmEdit(aControl).isEditing) then
    begin
//      aControl := self.GridPanel.ControlCollection.Controls[0, self.GridPanel.RowCollection.Count - 1];
      if (aControl is TFraImmEdit) then
        TFraImmEdit(aControl).cancelFromMain;
    end;
  if uVimmInputs.canSaveData then
    clearResults;
  Release;
end;

procedure TvimmMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  SetFormPosition(Self);
  ResizeFormToFont(self);
  SetScrollBarHeight(MainFontSize);
end;

procedure TvimmMainForm.ScrollBoxResize(Sender: TObject);
begin
  inherited;
  ScrollBox.OnResize := nil;
  //At least minimum
   if (pnlForm.Width < MinFormWidth) or (pnlForm.Height < MinFormHeight) then
   pnlForm.Align := alNone;
   pnlForm.AutoSize := false;
   if (pnlForm.Width < MinFormWidth) then pnlForm.Width := MinFormWidth;
   if pnlForm.Height < MinFormHeight then pnlForm.Height := MinFormHeight;


  if (ScrollBox.Width >= MinFormWidth) then
  begin
   if (ScrollBox.Height >= (MinFormHeight)) then
   begin
       pnlForm.Align := alClient;
   end else begin
     pnlForm.Align := alTop;
     pnlForm.AutoSize := true;
   end;
  end else begin
   if (ScrollBox.Height >= (MinFormHeight)) then
   begin
    pnlForm.Align := alNone;
    pnlForm.Top := 0;
    pnlForm.Left := 0;
    pnlForm.AutoSize := false;
    pnlForm.Width := MinFormWidth;
    pnlForm.height :=  ScrollBox.Height;
   end else begin
    pnlForm.Align := alNone;
    pnlForm.Top := 0;
    pnlForm.Left := 0;
    pnlForm.AutoSize := true;
   end;
  end;
  ScrollBox.OnResize := ScrollBoxResize;
end;

procedure TvimmMainForm.setInitialGridValues;
var
aControl: TControl;
immunization: string;
edit,generalImm: boolean;
data: TVimmResult;

begin
 //ice collapse determine by calling application
  generalImm := false;
  aControl := gridPanel.ControlCollection.Controls[0, 0];

  if not showICE then
    begin
      if (aControl is TfraReminders) then
        TfraReminders(aControl).populateReminders;
    end;
  if uVimmInputs.collapseICE = true then
    begin
      if showICE then
        begin
          if (aControl is TFraICE) then
            TFraICE(aControl).collapse;
        end
      else
        begin
          if(aControl is TfraReminders) then
            TfraReminders(aControl).collapse;
        end;
    end;
  //noGrid determine by calling application
  if uVimmInputs.noGrid = true then
    begin
      aControl := gridPanel.ControlCollection.Controls[0, 1];
      if (aControl is TfraVimmSelect) then
        TfraVimmSelect(aControl).expand;
      if initialList.Count = 1 then
        begin
          immunization := initialList.Strings[0];
          if StrToInt(Piece(immunization, U, 3)) > -1 then
            begin
              edit := true;
              data := TVimmResult(initialList.Objects[0]);
              if data.documType = 'Administered' then uVimmInputs.documentType := '0'
              else if data.documType = 'Historical' then uVimmInputs.documentType := '1'
              else if data.documType = 'Contraindication' then uVimmInputs.documentType := '2'
              else if data.documType = 'Refused' then uVimmInputs.documentType := '3'
              else if data.documType = 'Reading' then uVimmInputs.documentType := '4';
//              if (data.documType = 'Historical') and uVimmInputs.isSkinTest then uVimmInputs.documentType := '0';
            end
          else
            begin
              edit := false;
              if Piece(Immunization, U, 2) = genericIMM then
                begin
                  generalImm := true;
                  edit := true
                end
              else immunization := getVImmIds(immunization, false) + U + uVimmInputs.documentType;
            end;
          if not generalImm and (immunization = '')  then
            begin
              ShowMessage('Cannot find immunization entry');
              exit;
            end;
          if (aControl is TfraVimmSelect) then
            if TfraVimmSelect(aControl).startEditsFromMain(immunization, edit) = false then self.Close;
        end;
    end
  else
    begin
      aControl := gridPanel.ControlCollection.Controls[0,2];
      if (aControl is TfraVimmSelect) then TfraVimmSelect(aControl).collapse;
      aControl := gridPanel.ControlCollection.Controls[0,3];
      if (aControl is TfraImmEdit) then TfraImmEdit(aControl).collapse;
//      TfraImmEdit(aControl).expand;
      aControl := gridPanel.ControlCollection.Controls[0,1];
      if (aControl is TfraGrid) then
        begin
          TfraGrid(aControl).expand;
          if initialList <> nil then TFraGrid(aControl).addListToGrid(initialList, uVimmInputs.documentType)
          else TFraGrid(aControl).startUpdates('', false);
        end;
    end;
   if uVimmInputs.noGrid then
    begin
      self.btnAdd.Enabled := false;
      self.btnCancelRecord.Enabled := false;
    end;
end;

procedure TvimmMainForm.SetScrollBarHeight(FontSize: Integer);
begin
  MinFormHeight := 300;
  case FontSize of
    8:
      begin
        MinFormWidth := 600;
        MinFormHeight := 300;
      end;
    10:
      begin
        MinFormWidth := 600;
        MinFormHeight := 300;
      end;
    12:
      begin
        MinFormWidth := 800;
        MinFormHeight := 400;
      end;
    14:
      begin
        MinFormWidth := 800;
        MinFormHeight := 400;
      end;
  end;
  self.Constraints.MinHeight := MinFormHeight;
  self.Constraints.MinWidth := minFormWidth div 2;
end;

function TvimmMainForm.validateInput: boolean;
var
i, idx: integer;
error,tmp, cosigner: string;
tmpList: TStringList;
data: TVimmResult;

  procedure buildError(fieldName: String; var error: string);
  begin
    if error = '' then error := 'The following value(s) are missing:' + CRLF;
    error := error + CRLF + fieldName;
  end;

begin
  tmpList := TStringList.Create;
  try
  result := true;
  error := '';
    if uvimmInputs.noGrid = null then buildError('grid policy', error);
    if uvimmInputs.makeNote = null then buildError('create note policy', error);
    if uvimmInputs.collapseICE = null then buildError('ICE display policy', error);
    if uvimmInputs.canSaveData = null then buildError('save data policy', error);
    if uvimmInputs.encounterLocation = 0 then buildError('encounter location', error);
    if uvimmInputs.encounterCategory = '' then buildError('encounter category', error);
    if uvimmInputs.userIEN = null then buildError('user ID', error);
    if uvimmInputs.userName = '' then buildError('user Name', error);
    if uvimmInputs.patientIEN = '' then buildError('patient ID', error);
    if uvimmInputs.patientName = '' then buildError('patient name', error);
    if uVimmInputs.fromCover then
      begin
        if uvimmInputs.encounterProviderIEN = null then buildError('encounter provider ID', error);
        if uvimmInputs.encounterProviderName = '' then buildError('encounter provider name', error);
      end;
    if uvimmInputs.visitString = '' then buildError('visit string', error);
//    if vimmInputs.documentType = '' then buildError('document type', error);
    if uvimmInputs.dateEncounterDateTime = 0 then buildError('encounter date time', error);
    if uVimmInputs.canSaveData then
      begin
        tmp := checkForNoteTitle;
        if tmp = '0' then
          begin
            cosigner := pdmpSelectCosigner('', StrToInt(uVimmInputs.noteIEN),
                        uVimmInputs.dateEncounterDateTime, 'Immunization Note Cosigner Selection',
                        StrToIntDef(uVimmInputs.noteIEN, -1));
            if Piece(cosigner, U, 1) = '-2' then
              buildError('Cosigner needed for the Immunization Note', error)
            else uVimmInputs.coSignerIEN := StrToInt64Def(Piece(cosigner, U, 1), -1);
          end
        else if tmp <> '' then buildError(tmp, error);
      end;
    if error <> '' then
      begin
        result := false;
        error := error + CRLF + CRLF + 'Cannot Enter Immunization/Skin Test Data at this time.';
        infoBox(error, 'Error', MB_OK);
      end;
      if uVimmInputs.NewList <> nil then
        begin
          for i := 0 to uVimmInputs.NewList.Count - 1 do
            begin
              tmp := uVimmInputs.NewList.Strings[i];
              if initialList = nil then initialList := TStringList.Create;
              if Piece(tmp, U, 3) = genericImm then uVimmInputs.startInEditMode := true;
              initialList.Add(Pieces(tmp, u, 2, 3) + U + '-1');
            end;
        end;
        if uVimmInputs.DataList <> nil then
          begin
            for i := 0 to uVimmInputs.DataList.Count - 1 do
              begin
                data := TVimmResult(uVimmInputs.DataList.Objects[i]);
                if initialList = nil then initialList := TStringList.Create;
                idx := setVimmResults(data);
                if idx = -1 then ShowMessage('Problem adding previous results to the form');
                initialList.AddObject(data.id + U + data.name + U + IntToStr(idx), data);
              end;
          end;
      if uVimmInputs.isSkinTest then self.Caption := 'Enter Skin Test'
      else self.Caption := 'Enter Immunization';
  finally
    tmpList.Free;
  end;
end;

end.
