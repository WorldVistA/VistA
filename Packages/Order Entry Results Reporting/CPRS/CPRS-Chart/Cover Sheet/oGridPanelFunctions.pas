unit oGridPanelFunctions;
{
  ================================================================================
  *
  *       Application:  CPRS - Utilities
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Provides a singleton interface to common CPRS funtions
  *                     used with the TGridPanel object.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  iGridPanelIntf;

type
  TGridPanelFunctions = class(TInterfacedObject, IGridPanelFunctions)
  public
    function AddCoverSheetControl(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign = alNone): boolean;

    function AddRow(aGridPanel: TGridPanel; aSizeStyle: TSizeStyle; aValue: double): integer;
    function AddColumn(aGridPanel: TGridPanel; aSizeStyle: TSizeStyle; aValue: double): integer;
    function AddControl(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign = alNone): boolean;

    function AlignColumns(aGridPanel: TGridPanel): boolean;
    function AlignRows(aGridPanel: TGridPanel): boolean;

    function ClearGrid(aGridPanel: TGridPanel): boolean;
    function GetContents(aGridPanel: TGridPanel; aOutput: TStrings): integer;
    function GetSizeStyleName(aSizeStyle: TSizeStyle): string;

    function CollapseRow(aControl: TControl; aCollapsedHeight: integer): boolean;
    function ExpandRow(aControl: TControl; aHeight: double; aStyle: TSizeStyle): boolean;

    procedure FormatRows(aGridPanel: TGridPanel; aStyles: array of TSizeStyle; aValues: array of double);
  end;

implementation

{ TGridPanelFunctions }

function TGridPanelFunctions.AddColumn(aGridPanel: TGridPanel; aSizeStyle: TSizeStyle; aValue: double): integer;
begin
  { Make sure row[0] exists }
  while aGridPanel.RowCollection.Count < 1 do
    aGridPanel.RowCollection.Add;

  with aGridPanel.ColumnCollection.Add do
    begin
      SizeStyle := aSizeStyle;
      Value := aValue;
    end;

  Result := aGridPanel.ColumnCollection.Count;
end;

function TGridPanelFunctions.AddControl(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign): boolean;
begin
  try
    { Make sure col[0] exists }
    while aGridPanel.ColumnCollection.Count < 1 do
      aGridPanel.ColumnCollection.Add;

    { Make sure the row as aRow exists }
    while aGridPanel.RowCollection.Count < (aRow + 1) do
      aGridPanel.RowCollection.Add;

    aControl.Parent := aGridPanel;

    aGridPanel.ControlCollection.AddControl(aControl, aCol, aRow);
    aControl.Align := aAlign;
    aControl.Show;
    Result := true;
  except
    Result := false;
  end;
end;

function TGridPanelFunctions.AddCoverSheetControl(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign): boolean;
var
  aGridPanelRow: TGridPanel;
begin
  try
    { Make sure col[0] exists }
    while aGridPanel.ColumnCollection.Count < 1 do
      begin
        aGridPanel.ColumnCollection.Add;
        AlignColumns(aGridPanel);
      end;

    { Make sure the row as aRow exists }
    while aGridPanel.RowCollection.Count < (aRow + 1) do
      begin
        aGridPanel.RowCollection.Add;
        aGridPanelRow := TGridPanel.Create(aGridPanel);
        aGridPanelRow.Name := Format('%s_Row_%d', [aGridPanelRow.ClassName, aGridPanel.RowCollection.Count]);
        ClearGrid(aGridPanelRow);
        aGridPanelRow.RowCollection.Add;
        aGridPanelRow.ColumnCollection.Add;
        aGridPanelRow.Parent := aGridPanel;
        aGridPanelRow.ShowCaption := false;
        aGridPanelRow.TabStop := false;
        aGridPanelRow.BorderStyle := bsNone;
        aGridPanelRow.BevelInner := bvNone;
        aGridPanelRow.BevelOuter := bvNone;
        aGridPanelRow.ParentColor := true;
        aGridPanelRow.Align := alClient;

        aGridPanel.ControlCollection.AddControl(aGridPanelRow, 0, aGridPanel.RowCollection.Count - 1);

      end;

    AlignRows(aGridPanel);

    { Select the GridPane that is aRow }
    aGridPanelRow := TGridPanel(aGridPanel.ControlCollection.Controls[0, aRow]);

    { Make sure the column exists }
    while aGridPanelRow.ColumnCollection.Count < (aCol + 1) do
      with aGridPanelRow.ColumnCollection.Add do
        begin
          Value := 20;
          SizeStyle := ssPercent;
        end;

    AlignColumns(aGridPanelRow);

    aControl.Parent := aGridPanelRow;

    aGridPanelRow.ControlCollection.AddControl(aControl, aCol, 0);
    aControl.Align := aAlign;
    aControl.Visible := true;

    Result := true;
  except
    Result := false;
  end;
end;

function TGridPanelFunctions.AddRow(aGridPanel: TGridPanel; aSizeStyle: TSizeStyle; aValue: double): integer;
begin
  { Make sure col[0] exists }
  while aGridPanel.ColumnCollection.Count < 1 do
    aGridPanel.ColumnCollection.Add;

  aGridPanel.RowCollection.BeginUpdate;
  try
    with aGridPanel.RowCollection.Add do
      begin
        SizeStyle := aSizeStyle;
        Value := aValue;
      end;
  finally
    aGridPanel.RowCollection.EndUpdate;
  end;

  Result := aGridPanel.RowCollection.Count;
end;

function TGridPanelFunctions.AlignColumns(aGridPanel: TGridPanel): boolean;
var
  i: integer;
  j: integer;
begin
  aGridPanel.ColumnCollection.BeginUpdate;
  try
    j := 0;
    for i := 0 to aGridPanel.ColumnCollection.Count - 1 do
      if aGridPanel.ColumnCollection[i].SizeStyle = ssPercent then
        inc(j);

    for i := 0 to aGridPanel.ColumnCollection.Count - 1 do
      if aGridPanel.ColumnCollection[i].SizeStyle = ssPercent then
        aGridPanel.ColumnCollection[i].Value := (100 / j);

    aGridPanel.ColumnCollection.EndUpdate;
    Result := true;
  except
    aGridPanel.ColumnCollection.EndUpdate;
    Result := false;
  end;
end;

function TGridPanelFunctions.AlignRows(aGridPanel: TGridPanel): boolean;
var
  i: integer;
  j: integer;
begin
  aGridPanel.RowCollection.BeginUpdate;
  try
    j := 0;
    for i := 0 to aGridPanel.RowCollection.Count - 1 do
      if aGridPanel.RowCollection[i].SizeStyle = ssPercent then
        inc(j);

    for i := 0 to aGridPanel.RowCollection.Count - 1 do
      if aGridPanel.RowCollection[i].SizeStyle = ssPercent then
        aGridPanel.RowCollection[i].Value := (100 / j);

    aGridPanel.RowCollection.EndUpdate;
    Result := true;
  except
    aGridPanel.RowCollection.EndUpdate;
    Result := false;
  end;
end;

function TGridPanelFunctions.ClearGrid(aGridPanel: TGridPanel): boolean;
var
  aControl: TControl;
begin
  try
    while aGridPanel.ControlCollection.Count > 0 do
      begin
        aControl := aGridPanel.ControlCollection[0].control;
        if aControl is TGridPanel then
          begin
            ClearGrid(TGridPanel(aControl));
            TGridPanel(aControl).ControlCollection.Clear;
            TGridPanel(aControl).ColumnCollection.Clear;
            TGridPanel(aControl).RowCollection.Clear;
          end;
        aGridPanel.ControlCollection.RemoveControl(aControl);
        FreeAndNil(aControl);
      end;

    aGridPanel.ControlCollection.Clear;
    aGridPanel.RowCollection.Clear;
    aGridPanel.ColumnCollection.Clear;

    Result := true;
  except
    Result := false;
  end;
end;

function TGridPanelFunctions.CollapseRow(aControl: TControl; aCollapsedHeight: integer): boolean;
var
  aGridPanel: TGridPanel;
  aIndex: integer;
begin
  if aControl.Parent.ClassNameIs('TGridPanel') then
    begin
      aGridPanel := TGridPanel(aControl.Parent);
      aIndex := aGridPanel.ControlCollection.IndexOf(aControl);
      if aIndex < 0 then
        raise Exception.Create('Control not in parent control collection');

      aGridPanel.RowCollection.BeginUpdate;
      with aGridPanel do
        try
          RowCollection[aIndex].SizeStyle := ssAbsolute;
          RowCollection[aIndex].Value := aCollapsedHeight;
        finally
          RowCollection.EndUpdate;
        end;
      Result := true;
    end
  else
    Result := false;
end;

function TGridPanelFunctions.ExpandRow(aControl: TControl; aHeight: double; aStyle: TSizeStyle): boolean;
var
  aGridPanel: TGridPanel;
  aIndex: integer;
begin
  if aControl.Parent.ClassNameIs('TGridPanel') then
    begin
      aGridPanel := TGridPanel(aControl.Parent);
      aIndex := aGridPanel.ControlCollection.IndexOf(aControl);
      if aIndex < 0 then
        raise Exception.Create('Control not in parent control collection');

      aGridPanel.RowCollection.BeginUpdate;
      with aGridPanel do
        try
          RowCollection[aIndex].SizeStyle := aStyle;
          RowCollection[aIndex].Value := aHeight;
        finally
          RowCollection.EndUpdate;
        end;
      Result := true;
    end
  else
    Result := false;
end;

procedure TGridPanelFunctions.FormatRows(aGridPanel: TGridPanel; aStyles: array of TSizeStyle; aValues: array of double);
var
  i: integer;
begin
  aGridPanel.RowCollection.BeginUpdate;
  try
    if High(aStyles) <> High(aValues) then
      raise Exception.Create('MisMatch in number of styles vs values.');

    if High(aStyles) <> (aGridPanel.RowCollection.Count - 1) then
      raise Exception.Create('MisMatch in number of styles/values vs rows.');

    for i := Low(aStyles) to High(aStyles) do
      begin
        aGridPanel.RowCollection[i].SizeStyle := aStyles[i];
        aGridPanel.RowCollection[i].Value := aValues[i];
      end;
  finally
    aGridPanel.RowCollection.EndUpdate;
  end;
end;

function TGridPanelFunctions.GetContents(aGridPanel: TGridPanel; aOutput: TStrings): integer;
var
  i: integer;
  aControl: TControl;
begin
  try
    aOutput.Add('Here''s the stats so far');
    aOutput.Add(Format('TGridPanel: %s (Rows: %d, Cols: %d)', [aGridPanel.Name, aGridPanel.RowCollection.Count, aGridPanel.ColumnCollection.Count]));

    aOutput.Add('Rows');
    aOutput.Add('----');

    for i := 0 to aGridPanel.RowCollection.Count - 1 do
      begin
        aOutput.Add(Format('  Row %d, SizeStyle: %d', [i, ord(aGridPanel.RowCollection[i].SizeStyle)]));
        aOutput.Add(Format('          Value    : %0.5f', [aGridPanel.RowCollection[i].Value]));
      end;

    aOutput.Add('Columns');
    aOutput.Add('-------');

    for i := 0 to aGridPanel.ColumnCollection.Count - 1 do
      begin
        aOutput.Add(Format('  Col %d, SizeStyle: %d', [i, ord(aGridPanel.ColumnCollection[i].SizeStyle)]));
        aOutput.Add(Format('          Value    : %0.5f', [aGridPanel.ColumnCollection[i].Value]));
      end;

    aOutput.Add('Controls');
    aOutput.Add('--------');

    for i := 0 to aGridPanel.ControlCollection.Count - 1 do
      begin
        aControl := aGridPanel.ControlCollection[i].control;
        aOutput.Add(Format('  Control %d, ClassName: %s (Name: %s)', [i, aControl.ClassName, aControl.Name]));
        with aGridPanel.ControlCollection[i] do
          aOutput.Add(Format('    Row: %d, Col: %d', [row, column]));

        if aControl.ClassNameIs(aGridPanel.ClassName) then
          begin
            aOutput.Add(' ');
            aOutput.Add('  Embedded TGridPanel');
            aOutput.Add('  ===================');
            GetContents(TGridPanel(aControl), aOutput);
            aOutput.Add('  ===================');
            aOutput.Add('  Embedded TGridPanel');
            aOutput.Add(' ');
          end;
      end;
  except
    on e: Exception do
      aOutput.Add(e.message);
  end;

  Result := aOutput.Count;
end;

function TGridPanelFunctions.GetSizeStyleName(aSizeStyle: TSizeStyle): string;
begin
  case aSizeStyle of
    ssAbsolute: Result := 'ssAbsolute';
    ssPercent: Result := 'ssPercent';
    ssauto: Result := 'ssAuto';
  else
    Result := 'Unknown';
  end;
end;

end.
