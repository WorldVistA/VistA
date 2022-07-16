unit VA508DelphiCompatibility;

interface

uses
  SysUtils, Classes, Controls, Windows, StdCtrls, CheckLst, ExtCtrls, Forms,
  ValEdit, DBGrids, Calendar, ComCtrls, VA508AccessibilityManager;

function GetCheckBoxComponentName(AllowGrayed: boolean): string;
function GetCheckBoxInstructionMessage(Checked: boolean): string;
function GetCheckBoxStateText(State: TCheckBoxState): String;

procedure ListViewIndexQueryProc(Sender: TObject; ItemIndex: integer; var Text: string);

type
  TVA508StaticTextManager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetCaption(Component: TWinControl): string; override;
    function GetValue(Component: TWinControl): string; override;
  end;

implementation

uses Grids, VA508AccessibilityRouter,  VA508AccessibilityConst, VA508MSAASupport,
  VAUtils;

type
  TCheckBox508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
  end;

  TCheckListBox508Manager = class(TVA508ManagedComponentClass)
  private
    function GetIndex(Component: TWinControl): integer;
  public
    constructor Create; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
    function GetItemInstructions(Component: TWinControl): string; override;
  end;

  TVA508EditManager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
  end;

  TVA508ComboManager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
  end;

  TCustomGrid508Manager = class(TVA508ManagedComponentClass)
  private
  public
    constructor Create; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
//    function GetData(Component: TWinControl; Value: string): string; override;
  end;

  TVA508RegistrationScreenReader = class(TVA508ScreenReader);

function CustomComboAlternateHandle(Component: TWinControl): HWnd; forward;

procedure ListViewIndexQueryProc(Sender: TObject; ItemIndex: integer; var Text: string);
var
  temp, ImgTxt, state, overlay: string;
  view: TListView;
  item: TListItem;
  i: integer;
  include,
  ColValue: boolean;
  CtrlManager: TVA508AccessibilityManager;

  function Append(data: array of string): string; overload;
  var
    i: integer;
  begin
    Result := '';
    for i := low(data) to high(data) do
    begin
      if data[i] <> '' then
      begin
        if result <> '' then
          Result := Result + ' ';
        Result := Result + data[i];
      end;
    end;
  end;

  procedure Append(txt: string); overload;
  begin
    if txt = '' then exit;
    if text <> '' then
      text := text + ' ';
    text := text + txt + ',';
  end;

  procedure AppendHeader(txt: string);
  begin
    if txt = '' then
      txt := 'blank header';
    Append(txt);
  end;

begin
  view := TListView(Sender);
  Text := '';
  include := TRUE;
  CtrlManager :=  GetComponentManager(view);
  if (ItemIndex < 0) or (ItemIndex >= view.Items.Count) then exit;
  item := view.Items.Item[ItemIndex];
  if (view.ViewStyle = vsReport) and (view.Columns.Count > 0) then
  begin
    //-1 and -2 are valid widths
    if (view.Columns[0].Width = 0) or (view.Columns[0].Width < -3) then
      include := FALSE
    else
      AppendHeader(view.Columns[0].Caption);
  end;
  if include then
  begin
    //Load the image
    ImgTxt := '';
    state := '';
    overlay := '';

    if assigned(view.StateImages) then
      state := GetImageListText(view, iltStateImages, item.StateIndex);
    if view.ViewStyle = vsIcon then
      ImgTxt := GetImageListText(view, iltLargeImages, item.ImageIndex)
    else
      ImgTxt := GetImageListText(view, iltSmallImages, item.ImageIndex);

    if (item.OverlayIndex >= 0) then
      overlay := GetImageListText(view, iltOverlayImages, item.OverlayIndex);

    ImgTxt := Append([state, ImgTxt, overlay]);


    temp := item.Caption;

    // Added to protect from a/v in case CtrlManager isn't assigned.
    ColValue := false;

    if assigned (CtrlManager) then
    begin
      if assigned (CtrlManager.AccessColumns[view]) then
        ColValue := CtrlManager.AccessColumns[view].ColumnValues[0];
    end;

    if (temp = '') and ColValue then
      temp := 'blank';
    temp := Append([ImgTxt, temp]);
    Append(temp);
  end;

  if view.ViewStyle = vsReport then
  begin
    for i := 1 to view.Columns.Count - 1 do
    begin
      if (view.Columns[i].Width > 0) or (view.Columns[i].Width = -1) or (view.Columns[i].Width = -3) then
      begin
        AppendHeader(view.Columns[i].Caption);

        ImgTxt := '';

        //Get subimages
        if Assigned(View.SmallImages) then
         ImgTxt := GetImageListText(view, iltSmallImages, item.SubItemImages[I-1]);

        if (i-1) < item.SubItems.Count then
          temp := item.SubItems[i-1]
        else
          temp := '';

        // Added to protect from a/v in case CtrlManager isn't assigned.
        ColValue := false;

        if assigned (CtrlManager) then
        begin
          if assigned (CtrlManager.AccessColumns[view]) then
            ColValue := CtrlManager.AccessColumns[view].ColumnValues[0];
        end;

        if (temp = '') and ColValue then
        begin
          temp := 'blank';
        end;

        temp := Append([ImgTxt, temp]);

        Append(temp);
      end;
    end;
  end;
end;

procedure RegisterStandardDelphiComponents;
begin
  RegisterAlternateHandleComponent(TCustomCombo, CustomComboAlternateHandle);
  RegisterManagedComponentClass(TCheckBox508Manager.Create);
  RegisterManagedComponentClass(TCheckListBox508Manager.Create);
  RegisterManagedComponentClass(TCustomGrid508Manager.Create);
  RegisterManagedComponentClass(TVA508StaticTextManager.Create);
  RegisterManagedComponentClass(TVA508EditManager.Create);
  RegisterManagedComponentClass(TVA508ComboManager.Create);

  with TVA508RegistrationScreenReader(GetScreenReader) do
  begin
    // even though TListView is in Default.JCF, we add it here to clear out previous MSAA setting
    RegisterCustomClassBehavior(TListView.ClassName, CLASS_BEHAVIOR_LIST_VIEW);
    RegisterCustomClassBehavior(TVA508StaticText.ClassName, CLASS_BEHAVIOR_STATIC_TEXT);
  end;

  RegisterMSAAQueryListClassProc(TListView, ListViewIndexQueryProc);

{ TODO -oJeremy Merrill -c508 : 
Add these components as ones that need an alternate handle
TColorBox
TValueListEditor ?? - may be fixed because it's a TStringGrid
TCaptionStringGrid
TToolBar (not needed when the tool bar doesn't have focus)
TPageScroller

add stuff for image processing
descendents of TCustomTabControl


}

{ TODO -oJeremy Merrill -c508 :Need to create a fix for the list box stuff here}
end;

{ TCustomCombo Alternate Handle }

type
  TExposedCustomCombo = class(TCustomCombo)
  public
    property EditHandle;
  end;

  TExposedCustomComboBox = class(TCustomComboBox)
  public
    property Style;
  end;

function CustomComboAlternateHandle(Component: TWinControl): HWnd;
begin
  if (Component is TCustomComboBox) and
    not (TExposedCustomComboBox(Component).Style in [csDropDown, csSimple]) then
    Result := Component.Handle
  else
  Result := TExposedCustomCombo(Component).EditHandle;
end;

{ Check Box Utils - used by multiple classes }

function GetCheckBoxComponentName(AllowGrayed: boolean): string;
begin
  if AllowGrayed then
    Result := 'Three State Check Box'
  else
    Result := 'Check Box';
end;

function GetCheckBoxInstructionMessage(Checked: boolean): string;
begin
  if not Checked then // handles clear and gray entries
    Result := 'to check press space bar'
  else
    Result := 'to clear check mark press space bar';
end;

function GetCheckBoxStateText(State: TCheckBoxState): String;
begin
  case State of
    cbUnchecked: Result := 'not checked';
    cbChecked:   Result := 'checked';
    cbGrayed:    Result := 'Partially Checked';
    else         Result := '';
  end;
end;
{ TCheckBox508Manager }

constructor TCheckBox508Manager.Create;
begin
  inherited Create(TCheckBox, [mtComponentName, mtInstructions, mtState, mtStateChange]);
end;

function TCheckBox508Manager.GetComponentName(Component: TWinControl): string;
begin
  Result := GetCheckBoxComponentName(TCheckBox(Component).AllowGrayed);
end;

function TCheckBox508Manager.GetInstructions(Component: TWinControl): string;
begin
  Result := GetCheckBoxInstructionMessage(TCheckBox(Component).Checked);
end;

function TCheckBox508Manager.GetState(Component: TWinControl): string;
begin
  Result := GetCheckBoxStateText(TCheckBox(Component).State);
end;

{ TCheckListBox508Manager }

constructor TCheckListBox508Manager.Create;
begin
  inherited Create(TCheckListBox, [mtComponentName, mtState, mtStateChange, mtItemChange, mtItemInstructions]);
end;

function TCheckListBox508Manager.GetComponentName(
  Component: TWinControl): string;
var
  lb : TCheckListBox;
begin
  lb := TCheckListBox(Component);
  if lb.AllowGrayed then
    Result := 'Three State Check List Box'
  else
    Result := 'Check List Box';
end;

function TCheckListBox508Manager.GetItemInstructions(
  Component: TWinControl): string;
var
  lb : TCheckListBox;
  idx: integer;
begin
  lb := TCheckListBox(Component);
  idx := GetIndex(Component);
  if (idx < 0) then
    Result := ''
  else
    Result := GetCheckBoxInstructionMessage(lb.Checked[idx]);
end;

function TCheckListBox508Manager.GetIndex(Component: TWinControl): integer;
var
  lb : TCheckListBox;
begin
  lb := TCheckListBox(Component);
  if (lb.ItemIndex < 0) then
  begin
    if lb.Count > 0 then
      Result := 0
    else
      Result := -1
  end
  else
    Result := lb.ItemIndex;
end;

function TCheckListBox508Manager.GetItem(Component: TWinControl): TObject;
var
  lb : TCheckListBox;
begin
  lb := TCheckListBox(Component);
  Result := TObject((lb.items.Count * 10000) + (lb.ItemIndex + 2));
end;

function TCheckListBox508Manager.GetState(Component: TWinControl): string;
var
  lb : TCheckListBox;
  idx: integer;
begin
  lb := TCheckListBox(Component);
  idx := GetIndex(Component);
  if idx < 0 then
    Result := ''
  else
    Result := GetCheckBoxStateText(lb.State[idx]);
end;

{ TCustomForm508Manager }

type
  TAccessGrid = class(TCustomGrid);

constructor TCustomGrid508Manager.Create;
begin
{ TODO : Add support for other string grid features - like state changes for editing or selecting cells }
//  inherited Create(TStringGrid, TRUE, TRUE, TRUE, FALSE, FALSE, TRUE);
  inherited Create(TCustomGrid, [mtComponentName, mtInstructions, mtValue, mtItemChange], TRUE);
//  FLastX := -1;
//  FLastY := -1;
end;

// Data pieces
// 1 = Column header, if any
// 2 = Column #
// 3 = number of columns
// 4 = Row header, if any
// 5 = Row #
// 6 = number of rows
// 7 = Cell #
// 8 = total # of cells
// 9 = cell contents

const
  DELIM = '^';

function TCustomGrid508Manager.GetComponentName(Component: TWinControl): string;
begin
  Result := ' grid ';
  // don't use 'grid' - we're abandoning the special code in the JAWS scripts for
  // grids - it's too messy, and based on the 'grid' component name
end;
{
function TCustomGrid508Manager.GetData(Component: TWinControl; Value: string): string;

var
  grid: TAccessGrid;
  row, col: integer;
  cnt, x, y, max, mult: integer;
  txt: string;

  procedure Add(txt: integer); overload;
  begin
    Result := Result + inttostr(txt) + DELIM;
  end;

  procedure Add(txt: string); overload;
  begin
    Result := Result + Piece(txt,DELIM,1) + DELIM;
  end;

begin
  grid := TAccessGrid(Component);
  row := grid.Row;
  col := grid.Col;
  if (row >= 0) and (col >= 0) then
  begin
    if grid.FixedRows > 0 then
      Add(grid.GetEditText(col, 0))
    else
      Add('');
    Add(col - grid.FixedCols + 1);
    Add(grid.ColCount - grid.FixedCols);

    if grid.FixedCols > 0 then
      Add(grid.GetEditText(0, row))
    else
      Add('');
    Add(row - grid.FixedRows + 1);
    Add(grid.RowCount - grid.FixedRows);

    x := grid.ColCount - grid.FixedCols;
    y := grid.RowCount - grid.FixedRows;
    max := x * y;
    x := grid.Col - grid.FixedCols;
    y := grid.Row - grid.FixedRows;
    mult := grid.ColCount - grid.FixedCols;

    if (mult > 0) and
       (x >= 0) and (x < grid.ColCount) and
       (y >= 0) and (y < grid.RowCount) then
    begin
      cnt := (y * mult) + x + 1;
      Add(cnt);
    end
    else
      Add(0);
    Add(max);

    if Value = '' then
      txt := grid.GetEditText(col, row)
    else
      txt := Value;

    Add(txt);
    delete(Result,length(Result),1); // remove trailing delimeter
  end
  else
    Result := '';
end;      }

function TCustomGrid508Manager.GetInstructions(Component: TWinControl): string;
var
  grid: TAccessGrid;
//  cnt, x, y, max, mult: integer;
begin
  Result := '';
  grid := TAccessGrid(Component);
//  x := grid.ColCount - grid.FixedCols;
//  y := grid.RowCount - grid.FixedRows;
//  max := x * y;
//  x := grid.Col - grid.FixedCols;
//  y := grid.Row - grid.FixedRows;
//  mult := grid.ColCount - grid.FixedCols;
//
//  if (mult > 0) and
//     (x >= 0) and (x < grid.ColCount) and
//     (y >= 0) and (y < grid.RowCount) then
//  begin
//    cnt := (y * mult) + x + 1;
//    Result := IntToStr(cnt) + ' of ' + inttostr(max) + ', ';
//  end;
  Result := Result + 'To move to items use the arrow ';
  if goTabs in grid.Options then
    Result := Result + ' or tab ';
  Result := Result + 'keys';
end;
  
//  if
//  key
//end;
(*
listbox
column 120 row 430

unavailable (text of cell?)  read only

20 or 81



listbox
column 3 of 10
row 6 of 10

unavailable (text of cell?)  read only

20 or 81



with each navigation:

column 3 of 10 
row 6 of 10

unavailable (text of cell?)  read only
*)


function TCustomGrid508Manager.GetItem(Component: TWinControl): TObject;
var
  grid: TAccessGrid;
  row, col, maxRow: integer;
begin
  grid := TAccessGrid(Component);
  row := grid.Row + 2;
  col := grid.Col + 2;
  MaxRow := grid.RowCount + 3;
  if MaxRow < 1000 then
    MaxRow := 1000;
  Result := TObject((row * maxRow) + col);
end;

//function TCustomGrid508Manager.GetValue(Component: TWinControl): string;
//var
//  grid: TAccessGrid;
//begin
//  grid := TAccessGrid(Component);
//  Result := Piece(grid.GetEditText(grid.Col, grid.Row), DELIM, 1);
//end;


function TCustomGrid508Manager.GetValue(Component: TWinControl): string;
var
  grid: TAccessGrid;
  row, col: integer;
  colHdr, rowHdr, txt: string;

begin
  grid := TAccessGrid(Component);
  row := grid.Row;
  col := grid.Col;
  if (row >= 0) and (col >= 0) then
  begin
//    if col <> FLastX then
//    begin
      if grid.FixedRows > 0 then
        colHdr := Piece(grid.GetEditText(col, 0), DELIM, 1)
      else
        colHdr := '';
      if colHdr = '' then
        colHdr := inttostr(col+1-grid.FixedCols) + ' of ' + inttostr(grid.ColCount-grid.FixedCols);
      colHdr := 'column ' + colhdr + ', ';
//    end
//    else
//      colHdr := '';
//    FLastX := col;

//    if row <> FLastY then
//    begin
      if grid.FixedCols > 0 then
        rowHdr := Piece(grid.GetEditText(0, row), DELIM, 1)
      else
        rowHdr := '';
      if rowHdr = '' then
        rowHdr := inttostr(row+1-grid.FixedRows) + ' of ' + inttostr(grid.RowCount-grid.FixedRows);
      rowHdr := 'row ' + rowhdr + ', ';
//    end
//    else
//      rowHdr := '';
//    FLastY := row;

    txt := Piece(grid.GetEditText(col, row), DELIM, 1);
    if txt = '' then
      txt := 'blank';
    Result := colHdr + rowHdr + txt;
  end
  else
    Result := ' ';
end;


{ TVA508StaticTextManager }

constructor TVA508StaticTextManager.Create;
begin
  inherited Create(TVA508StaticText, [mtComponentName, mtCaption, mtValue], TRUE);
end;

function TVA508StaticTextManager.GetCaption(Component: TWinControl): string;
begin
  Result := ' ';
end;

function TVA508StaticTextManager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := 'label';
end;

function TVA508StaticTextManager.GetValue(Component: TWinControl): string;
var
  next: TVA508ChainedLabel;
  comp: TVA508StaticText;
begin
  comp := TVA508StaticText(Component);
  Result := comp.Caption;
  next := comp.NextLabel;
  while assigned(next) do
  begin
    Result := Result + ' ' + next.Caption;
    next := next.NextLabel;
  end;
end;

{ TVA508EditManager }

constructor TVA508EditManager.Create;
begin
  inherited Create(TEdit, [mtValue], TRUE);
end;

function TVA508EditManager.GetValue(Component: TWinControl): string;
begin
  Result := TEdit(Component).Text;
end;

{ TVA508ComboManager }

constructor TVA508ComboManager.Create;
begin
  inherited Create(TComboBox, [mtValue], TRUE);
end;

function TVA508ComboManager.GetValue(Component: TWinControl): string;
begin
  Result := TComboBox(Component).Text;
end;

initialization
  RegisterStandardDelphiComponents;

end.
