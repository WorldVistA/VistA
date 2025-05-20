unit iGridPanelIntf;
{
  ================================================================================
  *
  *       Application:  CPRS - Utiliies
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Main interface to the common TGridPanel utilies and
  *                     methods.
  *
  *       Notes:        Provides common access via GridPanelFunctions method.
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
  Vcl.Graphics;

type
  TGridPanelCollapse = (gpcNone, gpcRow, gpcColumn);

  IGridPanelDisplay = interface;
  IGridPanelControl = interface;
  IGridPanelFrame = interface;
  IGridPanelFunctions = interface;

  IGridPanelDisplay = interface(IInterface)
    ['{B1067A53-DD6B-458D-B1A1-9F8CCA851BD3}']
    function getColumnCollapsed(aIndex: integer): boolean;
    function getColumnCount: integer;
    function getColumnStyle(aIndex: integer): TSizeStyle;
    function getColumnValue(aIndex: integer): Double;

    function getRowCollapsed(aIndex: integer): boolean;
    function getRowCount: integer;
    function getRowStyle(aIndex: integer): TSizeStyle;
    function getRowValue(aIndex: integer): Double;

    procedure setColumnValue(aIndex: integer; const aValue: Double);
    procedure setColumnStyle(aIndex: integer; const aValue: TSizeStyle);

    procedure setRowValue(aIndex: integer; const aValue: Double);
    procedure setRowStyle(aIndex: integer; const aValue: TSizeStyle);

    function AddColumn(aSizeStyle: TSizeStyle = ssPercent; aValue: Double = 10.0): integer;
    function AddControl(aControl: TControl; aCol: integer; aRow: integer; aAlign: TAlign): boolean;
    function FindControl(aControl: TControl; var aCol: integer; var aRow: integer): boolean;

    procedure AlignGrid;
    procedure ClearGrid;
    procedure ExpandAllControls;

    procedure CollapseColumn(aColumn: integer); overload;
    procedure CollapseColumn(aControl: TControl); overload;
    procedure CollapseRow(aRow: integer); overload;
    procedure CollapseRow(aControl: TControl); overload;

    procedure ExpandColumn(aColumn: integer); overload;
    procedure ExpandColumn(aControl: TControl); overload;
    procedure ExpandRow(aRow: integer); overload;
    procedure ExpandRow(aControl: TControl); overload;

    property ColumnCollapsed[aIndex: integer]: boolean read getColumnCollapsed;
    property ColumnCount: integer read getColumnCount;
    property ColumnStyle[aIndex: integer]: TSizeStyle read getColumnStyle write setColumnStyle;
    property ColumnValue[aIndex: integer]: Double read getColumnValue write setColumnValue;

    property RowCollapsed[aIndex: integer]: boolean read getRowCollapsed;
    property RowCount: integer read getRowCount;
    property RowStyle[aIndex: integer]: TSizeStyle read getRowStyle write setRowStyle;
    property RowValue[aIndex: integer]: Double read getRowValue write setRowValue;
  end;

  IGridPanelControl = interface(IInterface)
    ['{0CFB3780-7AF7-4A66-810E-2187D0E77462}']
    function getGridPanelDisplay: IGridPanelDisplay;

    procedure setGridPanelDisplay(const aValue: IGridPanelDisplay);

    property GridPanelDisplay: IGridPanelDisplay read getGridPanelDisplay write setGridPanelDisplay;
  end;

  IGridPanelFrame = interface(IGridPanelControl)
    ['{D04C6393-9780-4E28-B56C-36ADF49EDBAA}']
    function getAllowCollapse: TGridPanelCollapse;
    function getAllowRefresh: boolean;
    function getBackgroundColor: TColor;
    function getCollapsed: boolean;
    function getTitleFontColor: TColor;
    function getTitleFontBold: boolean;
    function getTitle: string;

    procedure setAllowCollapse(const aValue: TGridPanelCollapse);
    procedure setAllowRefresh(const aValue: boolean);
    procedure setBackgroundColor(const aValue: TColor);
    procedure setTitleFontColor(const aValue: TColor);
    procedure setTitleFontBold(const aValue: boolean);
    procedure setTitle(const aValue: string);

    procedure OnExpandCollapse(Sender: TObject);

    property AllowCollapse: TGridPanelCollapse read getAllowCollapse write setAllowCollapse;
    property AllowRefresh: boolean read getAllowRefresh write setAllowRefresh;
    property BackgroundColor: TColor read getBackgroundColor write setBackgroundColor;
    property Collapsed: boolean read getCollapsed;
    property TitleFontColor: TColor read getTitleFontColor write setTitleFontColor;
    property TitleFontBold: boolean read getTitleFontBold write setTitleFontBold;
    property Title: string read getTitle write setTitle;
  end;

  IGridPanelFunctions = interface(IInterface)
    ['{A8821FA6-142B-4678-B7CE-D2AAF4E00EAD}']
    function AddCoverSheetControl(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign = alNone): boolean;

    function AddRow(aGridPanel: TGridPanel; aSizeStyle: TSizeStyle; aValue: Double): integer;
    function AddColumn(aGridPanel: TGridPanel; aSizeStyle: TSizeStyle; aValue: Double): integer;
    function AddControl(aGridPanel: TGridPanel; aControl: TControl; aCol, aRow: integer; aAlign: TAlign = alNone): boolean;

    function AlignColumns(aGridPanel: TGridPanel): boolean;
    function AlignRows(aGridPanel: TGridPanel): boolean;

    function ClearGrid(aGridPanel: TGridPanel): boolean;

    function GetContents(aGridPanel: TGridPanel; aOutput: TStrings): integer;
    function GetSizeStyleName(aSizeStyle: TSizeStyle): string;

    function CollapseRow(aControl: TControl; aCollapsedHeight: integer): boolean;

    procedure FormatRows(aGridPanel: TGridPanel; aStyles: array of TSizeStyle; aValues: array of Double);
  end;

function GridPanelFunctions: IGridPanelFunctions;
function NewGridPanel(aOwner: TComponent; aColumns, aRows: integer; var aGridPanel: TGridPanel): boolean;
function NewGridPanelDisplay(aGridPanel: TGridPanel; var aGridPanelDisplay): boolean;

implementation

uses
  oGridPanelDisplay,
  oGridPanelFunctions;

var
  fGridPanelFunctions: IGridPanelFunctions;

function GridPanelFunctions: IGridPanelFunctions;
begin
  fGridPanelFunctions.QueryInterface(IGridPanelFunctions, Result);
end;

function NewGridPanel(aOwner: TComponent; aColumns, aRows: integer; var aGridPanel: TGridPanel): boolean;
begin
  aGridPanel := TGridPanel.Create(aOwner);
  try
    aGridPanel.RowCollection.Clear;
    aGridPanel.ColumnCollection.Clear;

    { Set the rows }
    while aGridPanel.RowCollection.Count < aRows do
      with aGridPanel.RowCollection.Add do
        begin
          SizeStyle := ssPercent;
          Value := 10;
        end;

    { Set the columns }
    while aGridPanel.ColumnCollection.Count < aColumns do
      with aGridPanel.ColumnCollection.Add do
        begin
          SizeStyle := ssPercent;
          Value := 10;
        end;

    { Default settings }
    aGridPanel.ShowCaption := False;
    aGridPanel.TabStop := False;
    aGridPanel.BorderStyle := bsNone;
    aGridPanel.BevelInner := bvNone;
    aGridPanel.BevelOuter := bvNone;
    aGridPanel.ParentColor := True;
    aGridPanel.Align := alClient;
    Result := True;
  except
    FreeAndNil(aGridPanel);
    Result := False;
  end;
end;

function NewGridPanelDisplay(aGridPanel: TGridPanel; var aGridPanelDisplay): boolean;
begin
  Result := TGridPanelDisplay.Create(aGridPanel).GetInterface(IGridPanelDisplay, aGridPanelDisplay);
end;

initialization

TGridPanelFunctions.Create.GetInterface(IGridPanelFunctions, fGridPanelFunctions);

finalization

fGridPanelFunctions := nil;

end.
