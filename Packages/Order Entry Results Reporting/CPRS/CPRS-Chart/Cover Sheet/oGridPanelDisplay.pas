unit oGridPanelDisplay;

interface

uses
  System.Classes,
  System.SysUtils,
  System.RTLConsts,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  iGridPanelIntf;

type
  TGridPanelDisplay = class(TInterfacedObject, IGridPanelDisplay)
  private
    fGridPanel: TGridPanel;

    fRowCollapsedHeight: integer;
    fColCollapsedWidth: integer;

    fRowCollapsed: array of boolean;
    fRowStyles: array of TSizeStyle;
    fRowValues: array of Double;

    fColCollapsed: array of boolean;
    fColStyles: array of TSizeStyle;
    fColValues: array of Double;

    function getColumnCount: integer;
    function getColumnCollapsed(aIndex: integer): boolean;
    function getColumnStyle(aIndex: integer): TSizeStyle;
    function getColumnValue(aIndex: integer): Double;

    function getRowCount: integer;
    function getRowCollapsed(aIndex: integer): boolean;
    function getRowStyle(aIndex: integer): TSizeStyle;
    function getRowValue(aIndex: integer): Double;

    procedure setColumnStyle(aIndex: integer; const aValue: TSizeStyle);
    procedure setColumnValue(aIndex: integer; const aValue: Double);

    procedure setRowStyle(aIndex: integer; const aValue: TSizeStyle);
    procedure setRowValue(aIndex: integer; const aValue: Double);

    function AddColumn(aSizeStyle: TSizeStyle = ssPercent; aValue: Double = 10.0): integer;
    function AddControl(aControl: TControl; aCol: integer; aRow: integer; aAlign: TAlign): boolean;
    function FindControl(aControl: TControl; var aCol: integer; var aRow: integer): boolean;

    procedure AlignGrid;
    procedure ClearGrid;

    procedure CollapseColumn(aColumn: integer); overload;
    procedure CollapseColumn(aControl: TControl); overload;
    procedure CollapseRow(aRow: integer); overload;
    procedure CollapseRow(aControl: TControl); overload;

    procedure ExpandAllControls;

    procedure ExpandColumn(aColumn: integer); overload;
    procedure ExpandColumn(aControl: TControl); overload;
    procedure ExpandRow(aRow: integer); overload;
    procedure ExpandRow(aControl: TControl); overload;
  public
    constructor Create(aGridPanel: TGridPanel);
    destructor Destroy; override;
  end;

implementation

{ TGridPanelDisplay }

constructor TGridPanelDisplay.Create(aGridPanel: TGridPanel);
var
  i: integer;
begin
  inherited Create;
  fGridPanel := aGridPanel;
  fGridPanel.ShowCaption := False; { Since we are going to possibly be collapsing }
  fRowCollapsedHeight := 40;
  fColCollapsedWidth := 40;

  SetLength(fColCollapsed, aGridPanel.ColumnCollection.Count);
  SetLength(fColStyles, aGridPanel.ColumnCollection.Count);
  SetLength(fColValues, aGridPanel.ColumnCollection.Count);

  SetLength(fRowCollapsed, aGridPanel.RowCollection.Count);
  SetLength(fRowStyles, aGridPanel.RowCollection.Count);
  SetLength(fRowValues, aGridPanel.RowCollection.Count);

  for i := 0 to fGridPanel.ColumnCollection.Count - 1 do
    begin
      fColCollapsed[i] := False;
      fColStyles[i] := fGridPanel.ColumnCollection[i].SizeStyle;
      fColValues[i] := fGridPanel.ColumnCollection[i].Value;
    end;

  for i := 0 to fGridPanel.RowCollection.Count - 1 do
    begin
      fRowCollapsed[i] := False;
      fRowStyles[i] := fGridPanel.RowCollection[i].SizeStyle;
      fRowValues[i] := fGridPanel.RowCollection[i].Value;
    end;
end;

destructor TGridPanelDisplay.Destroy;
begin
  fGridPanel := nil;
  SetLength(fRowCollapsed, 0);
  SetLength(fRowStyles, 0);
  SetLength(fRowValues, 0);
  SetLength(fColCollapsed, 0);
  SetLength(fColStyles, 0);
  SetLength(fColValues, 0);
  inherited;
end;

function TGridPanelDisplay.getColumnCollapsed(aIndex: integer): boolean;
begin
  if (aIndex < 0) or (aIndex >= Length(fColCollapsed)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  Result := fColCollapsed[aIndex];
end;

function TGridPanelDisplay.getColumnCount: integer;
begin
  Result := fGridPanel.ColumnCollection.Count;
end;

function TGridPanelDisplay.getColumnValue(aIndex: integer): Double;
begin
  if (aIndex < 0) or (aIndex >= Length(fColValues)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  Result := fColValues[aIndex];
end;

function TGridPanelDisplay.getColumnStyle(aIndex: integer): TSizeStyle;
begin
  if (aIndex < 0) or (aIndex >= Length(fColStyles)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  Result := fColStyles[aIndex];
end;

function TGridPanelDisplay.getRowCollapsed(aIndex: integer): boolean;
begin
  if (aIndex < 0) or (aIndex >= Length(fRowCollapsed)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  Result := fRowCollapsed[aIndex];
end;

function TGridPanelDisplay.getRowCount: integer;
begin
  Result := fGridPanel.RowCollection.Count;
end;

function TGridPanelDisplay.getRowValue(aIndex: integer): Double;
begin
  if (aIndex < 0) or (aIndex >= Length(fRowValues)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  Result := fRowValues[aIndex];
end;

function TGridPanelDisplay.getRowStyle(aIndex: integer): TSizeStyle;
begin
  if (aIndex < 0) or (aIndex >= Length(fRowStyles)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  Result := fRowStyles[aIndex];
end;

procedure TGridPanelDisplay.setColumnStyle(aIndex: integer; const aValue: TSizeStyle);
begin
  if (aIndex < 0) or (aIndex >= Length(fColStyles)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  fColStyles[aIndex] := aValue;
end;

procedure TGridPanelDisplay.setColumnValue(aIndex: integer; const aValue: Double);
begin
  if (aIndex < 0) or (aIndex >= Length(fColValues)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  fColValues[aIndex] := aValue;
end;

procedure TGridPanelDisplay.setRowValue(aIndex: integer; const aValue: Double);
begin
  if (aIndex < 0) or (aIndex >= Length(fRowValues)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  fRowValues[aIndex] := aValue;
end;

procedure TGridPanelDisplay.setRowStyle(aIndex: integer; const aValue: TSizeStyle);
begin
  if (aIndex < 0) or (aIndex >= Length(fRowStyles)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aIndex]) at ReturnAddress;
  fRowStyles[aIndex] := aValue;
end;

function TGridPanelDisplay.AddColumn(aSizeStyle: TSizeStyle = ssPercent; aValue: Double = 10.0): integer;
begin
  try
    fGridPanel.ColumnCollection.BeginUpdate;
    with fGridPanel.ColumnCollection.Add do
      begin
        SizeStyle := aSizeStyle;
        Value := aValue;

        SetLength(fColCollapsed, fGridPanel.ColumnCollection.Count);
        SetLength(fColStyles, fGridPanel.ColumnCollection.Count);
        SetLength(fColValues, fGridPanel.ColumnCollection.Count);

        fColCollapsed[fGridPanel.ColumnCollection.Count - 1] := False;
        fColStyles[fGridPanel.ColumnCollection.Count - 1] := aSizeStyle;
        fColValues[fGridPanel.ColumnCollection.Count - 1] := aValue;
      end;
  finally
    fGridPanel.ColumnCollection.EndUpdate;
  end;
  Result := fGridPanel.ColumnCollection.Count;
end;

function TGridPanelDisplay.AddControl(aControl: TControl; aCol, aRow: integer; aAlign: TAlign): boolean;
var
  aGridPanelControl: IGridPanelControl;
begin
  try
    if aRow > (fGridPanel.RowCollection.Count - 1) then
      raise Exception.CreateFmt('Not enough rows, Need %d - Have %d', [aRow + 1, fGridPanel.RowCollection.Count]);

    if aCol > (fGridPanel.ColumnCollection.Count - 1) then
      raise Exception.CreateFmt('Not enough cols, Need %d - Have %d', [aCol + 1, fGridPanel.ColumnCollection.Count]);

    aControl.Parent := fGridPanel;

    if aControl.GetInterface(IGridPanelControl, aGridPanelControl) then
      aGridPanelControl.GridPanelDisplay := Self;

    fGridPanel.ControlCollection.Controls[aCol, aRow] := aControl;
    aControl.Align := aAlign;
    aControl.Show;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TGridPanelDisplay.AlignGrid;
var
  i: integer;
begin
  if (fGridPanel.RowCollection.Count > Length(fRowStyles)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError),
      [fGridPanel.RowCollection.Count - 1]) at ReturnAddress;
  if (fGridPanel.RowCollection.Count > Length(fRowValues)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError),
      [fGridPanel.RowCollection.Count - 1]) at ReturnAddress;
  if (fGridPanel.ColumnCollection.Count > Length(fColStyles)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError),
      [fGridPanel.ColumnCollection.Count - 1]) at ReturnAddress;
  if (fGridPanel.ColumnCollection.Count > Length(fColValues)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError),
      [fGridPanel.ColumnCollection.Count - 1]) at ReturnAddress;

  fGridPanel.RowCollection.BeginUpdate;
  fGridPanel.ColumnCollection.BeginUpdate;
  try
    for i := 0 to fGridPanel.RowCollection.Count - 1 do
      if fRowCollapsed[i] then
        begin
          fGridPanel.RowCollection[i].SizeStyle := ssAbsolute;
          fGridPanel.RowCollection[i].Value := fRowCollapsedHeight;
        end
      else
        begin
          fGridPanel.RowCollection[i].SizeStyle := fRowStyles[i];
          fGridPanel.RowCollection[i].Value := fRowValues[i];
        end;

    for i := 0 to fGridPanel.ColumnCollection.Count - 1 do
      if fColCollapsed[i] then
        begin
          fGridPanel.ColumnCollection[i].SizeStyle := ssAbsolute;
          fGridPanel.ColumnCollection[i].Value := fColCollapsedWidth;
        end
      else
        begin
          fGridPanel.ColumnCollection[i].SizeStyle := fColStyles[i];
          fGridPanel.ColumnCollection[i].Value := fColValues[i];
        end;
  finally
    fGridPanel.ColumnCollection.EndUpdate;
    fGridPanel.RowCollection.EndUpdate;
  end;
end;

procedure TGridPanelDisplay.ClearGrid;
begin
  with fGridPanel do
    begin
      ControlCollection.Clear; { Note: This frees the controls in the list as well }
      RowCollection.Clear;
      ColumnCollection.Clear;
      SetLength(fRowCollapsed, 0);
      SetLength(fRowStyles, 0);
      SetLength(fRowValues, 0);
      SetLength(fColCollapsed, 0);
      SetLength(fColStyles, 0);
      SetLength(fColValues, 0);
      RowCollection.Add;
      ColumnCollection.Add;
    end;
end;

procedure TGridPanelDisplay.CollapseColumn(aControl: TControl);
var
  aCol, aRow: integer;
begin
  if FindControl(aControl, aCol, aRow) then
    CollapseColumn(aCol);
end;

procedure TGridPanelDisplay.CollapseColumn(aColumn: integer);
begin
  if (aColumn < 0) or (aColumn >= Length(fColCollapsed)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aColumn]) at ReturnAddress;
  fColCollapsed[aColumn] := True;
  fGridPanel.ColumnCollection[aColumn].SizeStyle := ssAbsolute;
  fGridPanel.ColumnCollection[aColumn].Value := fColCollapsedWidth;
  AlignGrid;
end;

procedure TGridPanelDisplay.CollapseRow(aControl: TControl);
var
  aCol, aRow: integer;
begin
  if FindControl(aControl, aCol, aRow) then
    CollapseRow(aRow);
end;

procedure TGridPanelDisplay.CollapseRow(aRow: integer);
begin
  if (aRow < 0) or (aRow >= Length(fRowCollapsed)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aRow]) at ReturnAddress;
  fRowCollapsed[aRow] := True;
  fGridPanel.RowCollection[aRow].SizeStyle := ssAbsolute;
  fGridPanel.RowCollection[aRow].Value := fRowCollapsedHeight;
  AlignGrid;
end;

procedure TGridPanelDisplay.ExpandAllControls;
var
  aIndex: integer;
  aGridPanelFrame: IGridPanelFrame;
begin
  for aIndex := 0 to fGridPanel.ControlCount - 1 do
    if Supports(fGridPanel.Controls[aIndex], IGridPanelFrame, aGridPanelFrame) then
      if aGridPanelFrame.Collapsed then
        aGridPanelFrame.OnExpandCollapse(nil);
end;

procedure TGridPanelDisplay.ExpandColumn(aControl: TControl);
var
  aCol, aRow: integer;
begin
  if FindControl(aControl, aCol, aRow) then
    ExpandColumn(aCol);
end;

procedure TGridPanelDisplay.ExpandColumn(aColumn: integer);
begin
  if (aColumn < 0) or (aColumn >= Length(fColCollapsed)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aColumn]) at ReturnAddress;
  fColCollapsed[aColumn] := False;
  fGridPanel.ColumnCollection[aColumn].SizeStyle := fColStyles[aColumn];
  fGridPanel.ColumnCollection[aColumn].Value := fColValues[aColumn];
  AlignGrid;
end;

procedure TGridPanelDisplay.ExpandRow(aControl: TControl);
var
  aCol, aRow: integer;
begin
  if FindControl(aControl, aCol, aRow) then
    ExpandRow(aRow);
end;

procedure TGridPanelDisplay.ExpandRow(aRow: integer);
begin
  if (aRow < 0) or (aRow >= Length(fRowCollapsed)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aRow]) at ReturnAddress;
  fRowCollapsed[aRow] := False;
  fGridPanel.RowCollection[aRow].SizeStyle := fRowStyles[aRow];
  fGridPanel.RowCollection[aRow].Value := fRowValues[aRow];
  AlignGrid;
end;

function TGridPanelDisplay.FindControl(aControl: TControl; var aCol: integer; var aRow: integer): boolean;
var
  c, r: integer;
begin
  for c := 0 to fGridPanel.ColumnCollection.Count - 1 do
    for r := 0 to fGridPanel.RowCollection.Count - 1 do
      if fGridPanel.ControlCollection.Controls[c, r] = aControl then
        begin
          aCol := c;
          aRow := r;
          Exit(True);
        end;
  Result := False;
end;

end.
