unit mEditBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uEditObject, ORFn,
  Vcl.StdCtrls, Vcl.ExtCtrls, rEditObject;

type
  TfraEditGridBase = class(TFrame)
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
    { Private declarations }
  published
    layout: tLayout;
    procedure clearGrid;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  function validateAndBuildResults(inputs: TStrings): boolean;
  public
    procedure setAdditionalInputsParameter(inputs, defaultList: TStrings; layoutRequest: integer; isSaving: boolean); virtual;
    procedure createLayout(inputList, defaultList: TStrings; layoutRequest: integer); virtual;
    procedure setInitialValues; virtual;
    { Public declarations }
  end;

implementation

{$R *.dfm}

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
var
colSize, i, rowSize: integer;
edtObject: tEditObject;
layoutControl: tLayoutControl;
editList: TStrings;
begin
  clearGrid;
  editList := TStringList.Create;
  Layout.layoutType := layoutRequest;
//  if Layout.inputList = nil then
//    layout.inputList := TStringList.Create
//  else
    if layout.inputList <> nil then
      layout.inputList.Clear;
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
    layout.buildlayout(inputList, defaultList);
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
        edtObject := tEditObject.create(layoutControl, self, grdEditPanel);
        layoutControl.uiControl := edtObject;
        grdEditPanel.ControlCollection.AddControl(edtObject.editPanel, layoutControl.colNum, layoutControl.rowNum);
        grdEditPanel.ControlCollection[i].SetLocation(layoutControl.colNum, layoutControl.rowNum, false);
        grdEditPanel.ControlCollection[i].ColumnSpan := layoutControl.ColSpan;
      end;
    grdEditPanel.ControlCollection.EndUpdate;
    btnSave.TabStop := true;
    btnCancel.TabStop := true;
//    setInitialValues;
  finally
    FreeAndNil(editList);
  end;
end;


destructor TfraEditGridBase.Destroy;
begin
  layout.clearLayoutControls;
  FreeAndNil(layout);
  inherited;
end;


procedure TfraEditGridBase.ScrollBox1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  If RectContains(self.ScrollBox1.BoundsRect, self.ScrollBox1.ScreenToClient(MousePos)) then
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
