unit mEditBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.JSON,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uEditObject, ORFn,
  Vcl.StdCtrls, Vcl.ExtCtrls, rEditObject, fBase508Frame;

type
  TfraEditGridBase = class(TBase508Frame)
    pnlButtons: TPanel;
    grdEditPanel: TGridPanel;
    btnSave: TButton;
    btnCancel: TButton;
    ScrollBox1: TScrollBox;
    pnlForm: TPanel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    procedure InternalCreateLayout(inputList, defaultList: TStrings; layoutRequest: integer;
      AInputJSON: TJSONObject; LayoutJSON: TJSONValue);
    { Private declarations }
  protected
    procedure AdjustGridForCheckComboBoxes;
  published
    layout: tLayout;
    procedure clearGrid;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  function validateAndBuildResults(inputs: TStrings): boolean;
  public
    procedure setAdditionalInputsParameter(inputs, defaultList: TStrings; layoutRequest: integer; isSaving: boolean); virtual;
    procedure createLayout(inputList, defaultList: TStrings; layoutRequest: integer); virtual;
    procedure createLayoutFromJSON(InputJSON: TJSONObject; LayoutJSON: TJSONValue);
    procedure setInitialValues; virtual;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  System.Generics.Collections,
  ORCheckComboBox,
  ORExtensions,
  UJSONValueHelper,
  UJSONParameters,
  uPtInfoCommon,
  uPtInfoCore;

procedure TfraEditGridBase.AdjustGridForCheckComboBoxes;
var
  i: Integer;
  rowSize, rowSize2, baseRowSize: Double;
  ExtendedRows: TList<Integer>;
  layoutControl: tLayoutControl;
  editObj: TEditObject;
begin
  ExtendedRows := nil;
  grdEditPanel.BeginUpdate;
  try
    ExtendedRows := TList<Integer>.Create;
    for i := 0 to self.layout.Controls.Count - 1 do
    begin
      layoutControl := tLayoutControl(self.layout.Controls.Objects[i]);
      if layoutControl.uiControl is TEditObject then
        editObj := layoutControl.uiControl as TEditObject
      else
        Continue;
      if (editObj.editComponent is TORCheckComboBox) and
        (editObj.editComponent as TORCheckComboBox).MainCheckBoxVisible and
        (ExtendedRows.Indexof(layoutControl.rowNum) < 0) then
        ExtendedRows.Add(layoutControl.rowNum);
    end;
    if ExtendedRows.Count > 0 then
    begin
      baseRowSize := 100 / (grdEditPanel.RowCollection.Count * 2 + ExtendedRows.Count);
      rowSize := baseRowSize * 2;
      rowSize2 := baseRowSize * 3;
      for i := 0 to grdEditPanel.RowCollection.Count - 1 do
        if ExtendedRows.IndexOf(i) < 0 then
          grdEditPanel.RowCollection[i].Value := rowSize
        else
          grdEditPanel.RowCollection[i].Value := rowSize2;
    end;
  finally
    FreeAndNil(ExtendedRows);
    grdEditPanel.EndUpdate;
  end;

end;

procedure TfraEditGridBase.btnCancelClick(Sender: TObject);
begin
  clearGrid;
end;

procedure TfraEditGridBase.btnSaveClick(Sender: TObject);
var
inputList: TStrings;
begin
  inputList := TStringList.Create;
  try
    FastAssign(layout.inputList, inputList);
    if validateAndBuildResults(inputList) then
      clearGrid;
  finally
    FreeAndNil(inputList);
  end;
end;

procedure TfraEditGridBase.clearGrid;
begin
  layout.clearLayoutControls;
  grdEditPanel.ControlCollection.Clear;
  grdEditPanel.RowCollection.Clear;
  grdEditPanel.ColumnCollection.Clear;
  self.btnSave.Enabled := false;
  self.btnCancel.Enabled := false;
end;

constructor TfraEditGridBase.Create(aOwner: TComponent);
begin
  inherited;
  layout := tLayout.Create;
end;

procedure TfraEditGridBase.createLayout(inputList, defaultList: TStrings; layoutRequest: integer);
begin
  InternalCreateLayout(inputList, defaultList, layoutRequest, nil, nil);
end;

procedure TfraEditGridBase.createLayoutFromJSON(InputJSON: TJSONObject; LayoutJSON: TJSONValue);
begin
  InternalCreateLayout(nil, nil, -1, InputJSON, LayoutJSON);
end;

destructor TfraEditGridBase.Destroy;
begin
  layout.clearLayoutControls;
  FreeAndNil(layout);
  inherited;
end;

procedure TfraEditGridBase.InternalCreateLayout(inputList, defaultList: TStrings;
  layoutRequest: integer; AInputJSON: TJSONObject; LayoutJSON: TJSONValue);
var
  i: integer;
  colSize, rowSize: Double;
  edtObject: tEditObject;
  layoutControl: tLayoutControl;
  editList: TStrings;
begin
  clearGrid;
  editList := TStringList.Create;

  if Assigned(AInputJSON) then
    Layout.InputJSON := TJSONParameters.Create(AInputJSON);

  if Assigned(LayoutJSON) then
  begin
    Layout.layoutType := LayoutJSON.AsTypeDef<Integer>('editor.id', -1);
    if Layout.layoutType > -1 then
      Layout.layoutType := Layout.layoutType + TPtInfoDataTypes.EditorLayoutTypeOffset;
  end
  else
    Layout.layoutType := layoutRequest;

  if layout.inputList <> nil then
    layout.inputList.Clear;

  if not Assigned(LayoutJSON) then
    FastAssign(inputList, layout.inputList);

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

    if Assigned(LayoutJSON) then
      layout.buildLayoutFromJSON(LayoutJSON)
    else
      layout.buildlayout(inputList, defaultList);

    rowSize := 100 / self.layout.row;
    colSize := 100 / self.layout.column;
    // create row and size them
    grdEditPanel.RowCollection.BeginUpdate;
    try
      for i := 0 to self.layout.row - 1 do
        begin
          grdEditPanel.RowCollection.Add;
          grdEditPanel.RowCollection[i].SizeStyle := ssPercent;
          grdEditPanel.RowCollection[i].Value := rowSize;
        end;
    finally
      grdEditPanel.RowCollection.EndUpdate;
    end;
  // create column and size them
    grdEditPanel.ColumnCollection.BeginUpdate;
    try
      for i := 0 to self.layout.column - 1 do
        begin
          grdEditPanel.ColumnCollection.Add;
          grdEditPanel.ColumnCollection[i].SizeStyle := ssPercent;
          grdEditPanel.ColumnCollection[i].Value := colSize;
        end;
    finally
      grdEditPanel.ColumnCollection.EndUpdate;
    end;
    grdEditPanel.ControlCollection.BeginUpdate;
    try
      for i := 0 to self.layout.controls.Count - 1 do
        begin
          layoutControl := tLayoutControl(self.layout.controls.Objects[i]);
          edtObject := tEditObject.create(Self.layout, layoutControl, self, grdEditPanel);
          layoutControl.uiControl := edtObject;
          grdEditPanel.ControlCollection.AddControl(edtObject.editPanel, layoutControl.colNum, layoutControl.rowNum);
          grdEditPanel.ControlCollection[i].SetLocation(layoutControl.colNum, layoutControl.rowNum, false);
          grdEditPanel.ControlCollection[i].ColumnSpan := layoutControl.ColSpan;
          grdEditPanel.ControlCollection[i].RowSpan := layoutControl.RowSpan;
        end;
    finally
      grdEditPanel.ControlCollection.EndUpdate;
    end;
    btnSave.TabStop := true;
    btnCancel.TabStop := true;
//    setInitialValues;
  finally
    FreeAndNil(editList);
  end;
  AdjustGridForCheckComboBoxes;
end;

procedure TfraEditGridBase.ScrollBox1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  If RectContains(self.ScrollBox1.BoundsRect, self.ScrollBox1.ScreenToClient(MousePos)) and
    (not (FindVCLWindow(MousePos) is ORExtensions.TRichEdit)) then
  begin
    ScrollControl(self.ScrollBox1, (WheelDelta > 0));
    Handled := TRUE;
  end;
//
//  self.ScrollBox1.VertScrollBar.Position := wheelDelta;
end;

procedure TfraEditGridBase.setAdditionalInputsParameter(inputs, defaultList: TStrings; layoutRequest: integer; isSaving: boolean);
begin
end;

procedure TfraEditGridBase.setInitialValues;
begin
  layout.initilizeLookups;
end;

function TfraEditGridBase.validateAndBuildResults(inputs: TStrings): boolean;
var
compList, dataList: TStrings;
begin
  compList := TStringList.Create;
  dataList := TStringList.Create;
  try
    result := layout.validateData(compList);
    if not result  then
      begin
        if compList.Count > 0 then
          ShowMessage('A value for ' + compList.Strings[0] + ' is not defined.')
        else
          ShowMessage('Unknown data validation error');
        exit;
      end;
  result := layout.validate(compList, inputs, dataList);
  if not result then
    begin
      if dataList.Count > 0 then
        ShowMessage(dataList.Strings[0])
      else
        ShowMessage('Unknown validation error');
      exit;
    end;
  finally
    FreeAndNil(compList);
    FreeAndNil(DataList);
  end;
end;

end.
