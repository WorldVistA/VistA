unit mVimmEditGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, mEditBase, rVimm,
  Vcl.ExtCtrls, Vcl.StdCtrls, uVimmEditObject, uEditObject, ORFn, mVimmGrid, ORCtrls;

type
  TfraVimmEditGrid = class(TfraEditGridBase)
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    isEditing: boolean;
    dataStr: string;
    needsOverride: boolean;
    function validateAndBuild: boolean;

  public
     editingRecord: boolean;
     vimmObjectIdx: integer;
     constructor Create(aOwner: TComponent); override;
     procedure setValues(data: string; edit, needsOverrideValue: boolean);
     procedure setAdditionalInputsParameters(inputs, defaultList: TStrings; layoutRequest: integer; isSaving: boolean);
     procedure setInitialValues; override;
     procedure createLayout(inputList, defaultList: TStrings; layoutRequest: integer); override;
     procedure initilizeLookups;
     function saveGridFromMain: boolean;
     procedure cancelGridFromMain;
    { Public declarations }
  end;


var
  fraVimmEditGrid: TfraVimmEditGrid;

implementation

{$R *.dfm}
 uses
 mVimmSelect;
{ TfraVimmEditGrid }

procedure TfraVimmEditGrid.btnCancelClick(Sender: TObject);
var
aControl: TControl;
aGrid: TGridPanel;
begin
  inherited;
  editingRecord := false;
  agrid := TGridPanel(self.Parent.Parent.Parent);
  aControl := agrid.ControlCollection.Controls[0, 2];
  TfraVimmSelect(aControl).clearFields;
end;

procedure TfraVimmEditGrid.btnSaveClick(Sender: TObject);
var
aControl: TControl;
aGrid: TGridPanel;
begin
  if layout.layoutType = 4 then clearGrid
  else if validateAndBuild then
    begin
      clearGrid;
      agrid := TGridPanel(self.Parent.Parent.Parent);
      aControl := agrid.ControlCollection.Controls[0, 1];
     if (aControl is TfraVimmSelect) then TfraVimmSelect(aControl).clearFields;
    end;
  editingRecord := false;
end;

procedure TfraVimmEditGrid.cancelGridFromMain;
var
aControl: TControl;
aGrid: TGridPanel;
begin
  inherited;
  editingRecord := false;
  clearGrid;
  agrid := TGridPanel(self.Parent.Parent.Parent);
  if uVimmInputs.noGrid or uVimmInputs.immunizationReading then
     aControl := agrid.ControlCollection.Controls[0, 1]
  else aControl := agrid.ControlCollection.Controls[0, 2];
  if (aControl is TfraVimmSelect) then TfraVimmSelect(aControl).clearFields;
end;

constructor TfraVimmEditGrid.Create(aOwner: TComponent);
begin
  inherited;
end;

procedure TfraVimmEditGrid.createLayout(inputList, defaultList: TStrings;
  layoutRequest: integer);
var
colSize, i, rowSize: integer;
edtObject: vEditObject;
layoutControl: tLayoutControl;
editList: TStrings;
begin
  clearGrid;
  editList := TStringList.Create;
  if layout = nil then layout := TLayout.Create;
  Layout.layoutType := layoutRequest;
  try
    if layout.layoutType = -1 then
      begin
        self.btnSave.Enabled := false;
        self.btnCancel.Enabled := false;
      end
    else
      begin
        self.btnSave.Enabled := true;
        self.btnCancel.Enabled := true;
      end;
    layout.buildlayout(inputList, defaultList);
    if layout.hasNoData then exit;

    rowSize := 100 div self.layout.row;
    colSize := 100 div self.layout.column;
    grdEditPanel.RowCollection.BeginUpdate;
  // create row and size them
    for i := 0 to self.layout.row - 1 do
      begin
        grdEditPanel.RowCollection.Add;
        grdEditPanel.RowCollection[i].SizeStyle := ssPercent;
        grdEditPanel.RowCollection[i].Value := rowSize;
      end;
    grdEditPanel.RowCollection.EndUpdate;
  // create column and size them
    grdEditPanel.ColumnCollection.BeginUpdate;
    for i := 0 to self.layout.column - 1 do
      begin
        grdEditPanel.ColumnCollection.Add;
        grdEditPanel.ColumnCollection[i].SizeStyle := ssPercent;
        grdEditPanel.ColumnCollection[i].Value := colSize;
      end;
    grdEditPanel.ColumnCollection.EndUpdate;

    grdEditPanel.ControlCollection.BeginUpdate;
    for i := 0 to self.layout.controls.Count - 1 do
      begin
        layoutControl := tLayoutControl(self.layout.controls.Objects[i]);
        edtObject := vEditObject.create(layoutControl, self, grdEditPanel);
        layoutControl.uiControl := edtObject;
        edtObject.layout := layout;
        grdEditPanel.ControlCollection.AddControl(edtObject.editPanel, layoutControl.colNum, layoutControl.rowNum);
        grdEditPanel.ControlCollection[i].SetLocation(layoutControl.colNum, layoutControl.rowNum, false);
        grdEditPanel.ControlCollection[i].ColumnSpan := layoutControl.ColSpan;
      end;
    grdEditPanel.ControlCollection.EndUpdate;
    btnSave.TabStop := true;
    btnCancel.TabStop := true;
    self.ScrollBox1.Perform( WM_VSCROLL, MakeWParam(SB_Top,0),0);
//    setInitialValues;
  finally
    FreeAndNil(editList);
//    FreeAndNil(inputList);
  end;

end;

procedure TfraVimmEditGrid.initilizeLookups;
var
i: integer;
layoutControl: tLayoutControl;
editObject: vEditObject;
returnList: TStrings;
value, IEN: string;

begin
  for i := 0 to layout.controls.Count - 1 do
    begin
      layoutControl := tLayoutControl(layout.controls.Objects[i]);
      editObject := vEditObject(layoutControl.uiControl);
      if editObject.longList then
        begin
//          idx := -1;
           if editObject.name = 'ORDERING PROVIDER' then
            begin
              if editObject.editExtValue <> '' then
              begin
                value := editObject.editExtValue;
                IEN := editObject.editIntValue;
              end
              else
              begin
                value := '';
                IEN := '';
              end;
//              else
//              begin
//                value := uVimmInputs.encounterProviderName;
//                IEN := uVimmInputs.encounterProviderIEN.ToString;
//              end;

              populateProviderLookup(editObject, value, IEN);
            end
           else if editObject.name = 'ENCOUNTER PROVIDER' then
            begin
              if editObject.editExtValue <> '' then
              begin
                value := editObject.editExtValue;
                IEN := editObject.editIntValue;
              end
              else
              begin
                value := '';
                IEN := '';
              end;
//              else
//              begin
//                value := uVimmInputs.userName;
//                IEN := uVimmInputs.userIEN.ToString;
//              end;
              populateProviderLookup(editObject, value, IEN);
            end;
        end
      else
        begin
          returnList := TStringList.Create;
          try
            editObject.populateComponent;
            editObject.setDefaultValue;
            if (editObject.editComponent is TORComboBox) and
              (layoutControl.control = 'ptCBO') and
              ((editObject.editComponent as TORComboBox).Items.Count = 0) then
                begin
                  (editObject.editComponent as TORComboBox).Enabled := false;
                  (editObject.editComponent as TORComboBox).Color := cl3DLight;
                   editObject.controlEnabled := false;
                   editObject.update508Text(layoutControl.fenabled);
                end;
            if (editObject.name = 'ADMIN SITE') then
              begin
                if ((editObject.editComponent as TORComboBox).Enabled = false) and
                    ((editObject.editComponent as TORComboBox).ItemIndex = -1) then
                  begin
                    (editObject.editComponent as TORComboBox).Items.Clear;
                  end;
              end;

            if layoutControl.fAboveTheLine then
              editObject.populateAboveTheLine(layoutControl.name, layoutControl.aboveTheLineList);
          finally
            FreeAndNil(returnList);
          end;

        end;
    end;
end;

function TfraVimmEditGrid.saveGridFromMain: boolean;
var
aControl: TControl;
aGrid: TGridPanel;
begin
  if layout.layoutType = -1 then
    begin
      ShowMessage('No immunization/skin test to update');
      clearGrid;
      result := false;
      exit;
    end;
  if layout.layoutType = 4 then
    begin
      clearGrid;
      result := true;
    end
  else result := validateAndBuild;
  if not result then exit;
  clearGrid;
  agrid := TGridPanel(self.Parent.Parent.Parent);
  if uVimmInputs.noGrid or uVimmInputs.immunizationReading then
     aControl := agrid.ControlCollection.Controls[0, 1]
  else aControl := agrid.ControlCollection.Controls[0, 2];
  if (aControl is TfraVimmSelect) then TfraVimmSelect(aControl).clearFields;
  editingRecord := false;

end;

procedure TfraVimmEditGrid.setAdditionalInputsParameters(inputs, defaultList: TStrings; layoutRequest: integer; isSaving: boolean);
var
temp,vid: string;
dataResult : TVimmResult;
begin
  try
  if uVimmInputs.isSkinTest then inputs.Add('TYPE' + U + 'SKIN TEST')
  else inputs.Add('TYPE' + U + 'IMMUNIZATION');
//   if isEditing and (not isSaving) then
   if (layoutRequest > -1) and (isEditing) and (not isSaving) then
      begin
        if uVimmInputs.immunizationReading then
          begin
            dataResult := getVimmResultById(0);
            if dataResult <> nil then
              SetPiece(dataStr, U, 1, '0');
          end
        else if uVimmInputs.isSkinTest and (uVimmInputs.selectionType = 'historical') then
          begin
            dataResult := getVimmResultById(0);
            if dataResult <> nil then
              SetPiece(dataStr, U, 1, '0');
          end
        else
          begin
            if Piece(dataStr, U, 4) <> '' then
              dataResult := getVimmResultByUniqueId(Piece(dataStr, U, 4))
            else
              dataResult := getVimmResultById(StrToIntDef(Piece(dataStr,U,1),-1));
          end;
        if dataResult <> nil then
          begin
            vimmObjectIdx := getVimmResultIdx(dataResult);
//            vimmObjectIdx := StrToIntDef(Piece(dataStr,U,1),-1);
            vid := dataResult.id;
            if dataResult.defaultDataList <> nil then FastAssign(dataResult.defaultDataList, defaultList);
            dataStr := dataResult.id + U + dataResult.name + U + dataResult.documType;
            inputs.Add('VIMMTYPE' + U + dataResult.documType);
          end;
      end
    else
      begin
        vid := Piece(dataStr, U, 1);
//        vimmObjectIdx := -1;
      end;
    inputs.Add('DOCUMENTTYPE' + U + IntToStr(layoutRequest));
    inputs.Add('NAME' + U + Piece(dataStr, u, 2));
    inputs.Add('ID' + U + vid);
    inputs.Add('DATETIME' + U + FloatToStr(uvimminputs.dateEncounterDateTime));
    inputs.Add('ENCOUNTERTYPE' + U + uvimmInputs.encounterCategory);
    inputs.Add('PATIENTID' + U + uVimmInputs.patientIEN);
    inputs.Add('VISITSTR' + U + uVimmInputs.visitString);
    if uVimmInputs.fromCover then
      inputs.Add('FROMCOVER' + U + '1')
    else inputs.Add('FROMCOVER' + U + '0');
    if needsOverride then inputs.Add('NEEDSOVERRIDE' + U + '1')
    else inputs.Add('NEEDSOVERRIDE' + U + '0');
    if uVimmInputs.encounterProviderIEN > 0 then
      begin
        inputs.Add('ENCOUNTERPROVIDERIEN' + U + IntToStr(uVimmInputs.encounterProviderIEN));
        inputs.Add('ENCOUNTERPROVIDERNAME' + U + uVimmInputs.encounterProviderName);
      end;
    inputs.Add('USERIEN' + U + IntToStr(uvimmInputs.userIEN));
    inputs.Add('USERNAME' + U + uVimmInputs.userName);

    if (uVimmInputs.isSkinTest) and (not isSaving) and uVimmInputs.hasPlacements then
      begin
        temp := getSkinPlacementInfo(vid);
        inputs.Add('PLACEMENT IEN' + U + Piece(temp, U, 1));
        inputs.Add('PLACEMENTTEST' + U + Piece(temp, U, 2));
        inputs.Add('PLACEMENTNAME' + U + Piece(temp, U, 3));
        inputs.Add('PLACEMENTDATE' + U + Piece(temp, U, 4));
      end;

  finally

  end;

end;

procedure TfraVimmEditGrid.setInitialValues;
begin
  initilizeLookups;
end;

procedure TfraVimmEditGrid.setValues(data: string; edit,
  needsOverrideValue: boolean);
begin
  dataStr := data;
  isEditing := edit;
  needsOverride := needsOverrideValue;
end;

function TfraVimmEditGrid.validateAndBuild: boolean;
var
codeList, compList, dataList, defaultList, inputList, layoutDefaultList: TStrings;
noteList, tempList, lotList, visList: TStrings;
charCount, idx, lotIDX, visIDX: integer;
adminDate, delimitedStr, delimitedStr2, delimitedStr3, int, temp: string;
dxcode, cptCode, msgStr, outLoc: string;
data: TVimmResult;
grid: TGridPanel;
aControl: TControl;
begin
  inputList := TStringList.Create;
  compList := TStringList.Create;
  dataList := TStringList.Create;
  tempList := TStringList.Create;
  visList := TStringList.Create;
  lotList := TStringList.Create;
  defaultList := TStringList.Create;
  noteList := TStringList.Create;
  codeList := TStringList.Create;
  layoutDefaultList := TStringList.Create;
  msgStr := '';
  try
    setAdditionalInputsParameters(inputList, defaultList ,layout.layoutType, true);
    result := layout.validateData(compList);
    if not result  then
      begin
        if compList.Count = 0 then
          ShowMessage('No immunization/skin test selected to document. Either select an immunization/skin test to document or click the Clear button')
        else ShowMessage(compList.Strings[0]);
        exit;
      end;
    visIDX := -1;
    lotIDX := -1;
  if not uVimmInputs.isSkinTest and (layout.layoutType = 0) then
    begin
      for idx := 0 to compList.Count - 1 do
        begin
          if (Piece(compList.Strings[idx], U, 1) <> 'VIS OFFERED') and (Piece(compList.Strings[IDX],U,1) <> 'LOT NUMBER') then continue;
          temp := compList.Strings[idx];
          int := Piece(temp, U, 2);
          self.layout.returnComponentDataList(Piece(compList.Strings[idx], U, 1), tempList);
          if Piece(compList.Strings[idx], U, 1) = 'VIS OFFERED' then
            begin
              visIDX := idx;
              buildVISString(dataStr, int, tempList, visList);
            end;
          if Piece(compList.Strings[IDX],U,1) = 'LOT NUMBER' then
            begin
              lotIDX := idx;
              buildLotString(dataStr, int, tempList, lotList);
            end;

//          compList.Strings[idx] :=  'VIS OFFERED' + U + int + U + ext;
        end;
      if visIDX > -1 then
        begin
          compList.Delete(visIDX);
          for idx := 0 to visList.Count - 1 do
              compList.Add(visList.Strings[idx]);
        end;
      if lotIDX > -1 then
        begin
          compList.Delete(lotIDX);
          for idx := 0 to lotList.Count - 1 do
              compList.Add(lotList.Strings[idx]);
        end;
    end;
  result := self.layout.validate(compList, inputList, dataList);
  if not result then
    begin
      ShowMessage(dataList.Strings[0]);
      exit;
    end;

  if Piece(dataList.Strings[0], u, 1) = '1' then adminDate := Piece(dataList.Strings[0], u, 2);
  outLoc := '';
  for idx := 1 to dataList.Count - 1 do
    begin
      temp := dataList.Strings[idx];
      if Piece(temp, U, 1) = 'NOTE' then
        notelist.Add(Piece(temp, u, 2))
      else if Piece(temp, U, 1) = 'LAYOUT' then
        begin
          charCount := temp.CountChar(U);
          layoutDefaultList.Add(Pieces(temp, u, 2, charCount + 1));
          if Piece(temp,u,2)='CODES CPT' then cptCode := Pieces(temp,u,3,4)
          else if Piece(temp,u,2)='CODES DX' then dxCode := Pieces(temp,u,3,4)
          else if Piece(temp, U, 2) = 'LOCATION' then  outLoc := Pieces(temp, u, 3, 4);

        end
      else if Piece(temp, U, 1) = 'DATA' then
        delimitedStr := Pieces(temp, u, 2, 40)
      else if Piece(temp, U, 1) = 'DATA1' then
        delimitedStr2 := Pieces(temp, u, 2, 4)
      else if Piece(temp, U, 1) = 'DATA2' then
        delimitedStr3 := Pieces(temp, u, 2, 4)
      else if Piece(temp, U, 1) = 'MSG' then
        begin
          if msgStr <> '' then msgStr := msgStr + CRLF + Piece(temp, U, 2)
          else msgStr := Piece(temp, U, 2);
        end;
    end;
    if msgStr <> '' then
      ShowMessage(msgStr);
    if vimmObjectIdx > -1 then
      begin
        data := getVimmResultById(vimmObjectIdx);
        data.DelimitedStr :=  delimitedStr;
        data.DelimitedStr2 := delimitedStr2;
        data.DelimitedStr3 := delimitedStr3;
      end
    else data := TVimmResult.Create(delimitedStr, delimitedStr2, delimitedStr3, false);
//    data.adminDate := StrToFloatDef(adminDate, 0);
    if data.noteText = nil then data.noteText := TStringList.Create;
//    data.documType := '';
  if not uvimmInputs.isSkinTest then
    begin
      case layout.layoutType of
        0: data.documType := 'Administered';
        1: data.documType := 'Historical';
        2: data.documType := 'Contraindication';
        3: data.documType := 'Refused';
      end;
    end
  else
    begin
       case layout.layoutType of
        0: data.documType := 'Administered';
        1: data.documType := 'Reading';
        2: data.documType := 'Historical';
       end;
    end;
    FastAssign(noteList, data.noteText);
    FastAssign(layoutDefaultList, data.defaultDataList);

    if CPTCode <> '' then
      begin
         layout.returnComponentDataList('CODES CPT', codeList);
         for idx := 0 to codeList.Count -1 do
          begin
            if Piece(codeList.Strings[idx], u, 1) = Piece(CPTCode, u, 1) then
              begin
                data.cptCode := Pieces(codeList.Strings[idx], u, 3, 4);
                break;
              end;
          end;
      end;
    if DXCode <> '' then
      begin
        codeList.Clear;
         layout.returnComponentDataList('CODES DX', codeList);
         for idx := 0 to codeList.Count -1 do
          begin
            if Piece(codeList.Strings[idx], u, 1) = Piece(DXCode, u, 1) then
              begin
                data.dxCode := Pieces(codeList.Strings[idx], u, 3, 4);
                break;
              end;
          end;
      end;
    if outLoc <> '' then
      begin
        data.outsideLocIEN := Piece(outLoc, U, 1);
        data.outsideLoc := Piece(outLoc, U, 2);
      end;
//    idx := -1;
    if vimmObjectIdx > -1 then
      begin
        uVimmResults.results.Objects[vimmObjectIdx] := data;
//        idx := vimmObjectIdx;
        vimmObjectIdx := -1;
      end
    else setVimmResults(data);
//    else idx := setVimmResults(data);
    if uVimmInputs.isSkinTest then removeSkinPlacementInfo(data);
//  idx :=  StrToIntDef(temp,-1);
//  if idx = -1 then exit;
    result := true;
    if uVimmInputs.immunizationReading or uVimmInputs.noGrid then exit;
    grid := TGridPanel(self.Parent.Parent.Parent);
    aControl := grid.ControlCollection.Controls[0, 1];
    clearValues;
    TfraGrid(aControl).updateGrid;
  finally
    FreeAndNil(inputList);
    FreeAndNil(compList);
    FreeAndNil(dataList);
    FreeAndNil(tempList);
    FreeAndNil(visList);
    FreeAndNil(lotList);
    FreeAndNil(defaultList);
    FreeAndNil(layoutDefaultList);
    FreeAndNil(NoteList);
    FreeAndNil(codeList);
  end;
end;

end.
