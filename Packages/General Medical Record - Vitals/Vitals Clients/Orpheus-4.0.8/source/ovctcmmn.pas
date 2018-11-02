{*********************************************************}
{*                  OVCTCMMN.PAS 4.08                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcmmn;
  {-Orpheus table: common unit}

interface

uses
  Types, Windows, SysUtils, Messages, Graphics, Forms, StdCtrls, Classes,
  Controls, OvcBase, OvcData, OvcExcpt, OvcMisc;

{---Enumeration types}
type
  TOvcTblAdjust = (                {data adjustment in cell}
              otaDefault,          {the default for the next higher class}
              otaTopLeft,          {top left hand corner}
              otaTopCenter,        {top, centered horizontally}
              otaTopRight,         {top right hand corner}
              otaCenterLeft,       {left hand side, centered vertically}
              otaCenter,           {centered vertically and horizontally}
              otaCenterRight,      {right hand side, centered vertically}
              otaBottomLeft,       {bottom left hand corner}
              otaBottomCenter,     {bottom, centered horizontally}
              otaBottomRight);     {bottom right hand corner}

  TOvcTblAccess = (                {cell access types}
              otxDefault,          {the default for the next higher class}
              otxNormal,           {read & write}
              otxReadOnly,         {read only, no write}
              otxInvisible);       {no read or write, ie invisible}

  TOvcTblState = (                 {grid states}
                                   {..Major}
              otsFocused,          {  focused, or cell being edited}
              otsUnfocused,        {  unfocused}
              otsDesigning,        {  being designed}
                                   {..Minor}
              otsNormal,           {  normal}
              otsEditing,          {  cell being edited}
              otsHiddenEdit,       {  ditto, however currently hidden}
              otsMouseSelect,      {  mouse is selecting}
              otsShowSize,         {  row/col sizing cursor shown}
              otsSizing,           {  row/col being resized}
              otsShowMove,         {  row/col move cursor shown}
              otsMoving,           {  row/col is being moved}
                                   {..Qualifiers}
              otsDoingRow,         {  moving/sizing a row}
              otsDoingCol,         {  moving/sizing a column}

              otsANOther);
  TOvcTblStates = set of TOvcTblState;

  TOvcTblKeyNeeds = (              {grid's requirements for keystrokes}
              otkDontCare,         {grid does not need key}
              otkWouldLike,        {grid would like key, but cell can take it}
              otkMustHave);        {grid must have key}

  TOvcTblRegion = (                {table regions}
              otrInMain,           {..main table area}
              otrInLocked,         {..locked row or col area}
              otrInUnused,         {..unused bit}
              otrOutside);         {..outside table client area}

  TOvcTblOption = (                {table options}
              otoBrowseRow,        {Highlight row when browsing}
              otoNoRowResizing,    {No run-time row resizing allowed}
              otoNoColResizing,    {No run-time column resizing allowed}
              otoTabToArrow,       {Tab moves cell to right, ShiftTab left}
              otoEnterToArrow,     {Enter stops editing and moves cell right}
              otoAlwaysEditing,    {Edit mode is always active}
              otoNoSelection,      {No run-time selection allowed}
              otoMouseDragSelect,  {dragging with mouse selects}
              otoRowSelection,     {clicking on row header selects entire row}
              otoColSelection,     {clicking on column header selects entire column}
              otoThumbTrack,       {Scrollbar thumb-tracking}
              otoAllowColMoves,    {Enable column moves}
              otoAllowRowMoves);   {Enable row moves}
  TOvcTblOptionSet = set of TOvcTblOption;

  TOvcScrollBar = (                {scroll bar identifiers}
              otsbVertical,        {..the vertical one}
              otsbHorizontal);     {..the horizontal one}

  TOvcTblActions = (               {configuration actions on rows/columns}
              taGeneral,           {..general}
              taSingle,            {..changing a single row/column}
              taAll,               {..changing all rows/columns}
              taInsert,            {..inserting a row/column}
              taDelete,            {..deleting a row/column}
              taExchange);         {..exchanging two rows/columns}

  TOvcCellDataPurpose = (          {OnGetCellData data request purpose}
              cdpForPaint,         {..for painting}
              cdpForEdit,          {..for editing}
              cdpForSave);         {..for saving an edited data}

  TOvcTextStyle = (                {text painting styles}
              tsFlat,              {..flat}
              tsRaised,            {..raised look}
              tsLowered);          {..lowered look}

  TOvcTblSelectionType = (         {Internal selection type}
              tstDeselectAll,      {..deselect all selections}
              tstAdditional);      {..additional selection/deselection}

  TOvcTblEditorStyle = (           {Table's cell editor style}
              tesNormal,           {..normal (ie nothing special)}
              tesBorder,           {..with border}
              tes3D);              {..3D look}

  TOvcTblStringtype = (
              tstShortString,
              tstPChar,
              tstString);

{---Row/Column number (index) types}
type
  TRowNum = Integer;  {actually 0..2 billion}
  TColNum = integer;  {actually 0..16K}

{---record types for cells---}
type
  PCellBitMapInfo = ^TCellBitMapInfo;
  TCellBitMapInfo = packed record
    BM          : TBitMap;    {bitmap object to display}
    Count       : integer;    {number of glyphs}
    ActiveCount : integer;    {number of active glyphs}
    Index       : integer;    {index of glyph to display}
  end;

  PCellComboBoxInfo = ^TCellComboBoxInfo;
  TCellComboBoxInfo = packed record
    Index : integer;                {index into Items list}
      St      : string;    {string value if Index = -1}  //SZ 02.02.2010: replaced array[0..255] of char with string. We cannot use a variant record anymore, but the lower memory usage of the string compensates for that. This also should make upgrading projects easier
      RTItems : TStrings;  {run-time items list}
      RTSt    : string;    {run-time string value if Index = -1}
      TextHint: string;    {text that is displayed in gray if an empty string would be displayed }
  end;

  TOvcCellAttributes = packed record {display attributes for a cell}
    caAccess      : TOvcTblAccess;   {..access rights}
    caAdjust      : TOvcTblAdjust;   {..data adjustment}
    caColor       : TColor;          {..background color}
    caFont        : TFont;           {..text font}
    caFontColor   : TColor;          {..text color}
    caFontHiColor : TColor;          {..text highlight color}
    caTextStyle   : TOvcTextStyle;   {..text style}

    // SZ new attributes for cell border 15.02.2011
    caBorderColor : TColor;          {..Border Color - clOvcTableDefault}
    caBorderStyle : TPenStyle;       {..Border Style (solid, dotted, ...}
    caBorderWidth : Integer;         {..Border Thickness}

    // SZ new attributes for cell dropdown 05.09.2015
    caAlwaysShowDropDown: Boolean;
  end;

  TOvcRowAttributes = packed record // SZ attributes for row border 15.02.2011
    caBorderColor : TColor;          {..Border Color - clOvcTableDefault}
    caBorderStyle : TPenStyle;       {..Border Style (solid, dotted, ...}
    caBorderWidth : Integer;         {..Border Thickness}
  end;


{---Table cell ancestor---}
  TOvcTableCellAncestor = class(TComponent)
    protected {private}

      FOnCfgChanged : TNotifyEvent;

    protected

      procedure tcChangeScale(M, D : integer); dynamic;
      procedure tcDoCfgChanged;

    public {protected}

      procedure tcResetTableValues; virtual; abstract;
      property OnCfgChanged : TNotifyEvent
        write FOnCfgChanged;

    public
  end;

{---Table ancestor---}

  TOvcTableAncestor = class(TO32CustomControl)
    protected {private}
      FController : TOvcController;
      taCellList : TList;
      taLoadList : TStringList;

      function ControllerAssigned : Boolean;
      procedure SetController(Value : TOvcController); virtual;

    protected
      procedure CreateWnd;
        override;
      procedure Notification(AComponent : TComponent; Operation : TOperation);
        override;

      {streaming routines}
      procedure ChangeScale(M, D : integer); override;
      procedure DefineProperties(Filer : TFiler); override;
      procedure Loaded; override;

      procedure tbFinishLoadingCellList;
      procedure tbReadCellData(Reader : TReader);
      procedure tbWriteCellData(Writer : TWriter);

      procedure tbCellChanged(Sender : TObject); virtual; abstract;

    public {protected}
      {internal use only methods}
      procedure tbExcludeCell(Cell : TOvcTableCellAncestor);
      procedure tbIncludeCell(Cell : TOvcTableCellAncestor);
      procedure tbNotifyCellsOfTableChange;

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      property Controller : TOvcController
        read FController
        write SetController;

      function FilterKey(var Msg : TWMKey) : TOvcTblKeyNeeds; virtual; abstract;
      procedure ResolveCellAttributes(RowNum : TRowNum; ColNum : TColNum;
                                      var CellAttr : TOvcCellAttributes); virtual; abstract;
  end;

type
  POvcSparseAttr = ^TOvcSparseAttr;
{attributes for cells in sparse matrix--INTERNAL USE}
  TOvcSparseAttr = packed record
    scaAccess : TOvcTblAccess;
    scaAdjust : TOvcTblAdjust;
    scaColor  : TColor;
    scaFont   : TFont;
    scaCell   : TOvcTableCellAncestor;
  end;

  POvcTableNumberArray = ^TOvcTableNumberArray;
{structure passed to GetDisplayedRow(Col)Numbers}
  TOvcTableNumberArray = packed record
    NumElements : Integer;      {..number of elements in Number array}
    Count       : Integer;      {..return count of used elements in Number array}
    Number      : array [0..29] of Integer; {..Number array}
  end;

{---Row style type}
type
  PRowStyle = ^TRowStyle;
  TRowStyle = packed record
    Height : Integer; {-1 means default}
    Hidden : boolean;
  end;

{---Short string type (length-byte string)}
type
  POvcShortString = ^ShortString;  {pointer to shortstring}

{---Exception classes}
type
  EOrpheusTable = class(Exception);

{---Notification events}
type
  TRowNotifyEvent = procedure (Sender : TObject; RowNum : TRowNum) of object;
  TColNotifyEvent = procedure (Sender : TObject; ColNum : TColNum) of object;
  TColResizeEvent = procedure ( Sender: TObject; ColNum : TColNum;
    NewWidth: Integer) of object;
  TRowResizeEvent = procedure ( Sender: TObject; RowNum : TRowNum;
    NewHeight: Integer) of object;
  TCellNotifyEvent = procedure (Sender : TObject;
                                RowNum : TRowNum; ColNum : TColNum) of object;
  TCellDataNotifyEvent = procedure (Sender : TObject;
                                    RowNum : TRowNum; ColNum : TColNum;
                                    var Data : pointer;
                                    Purpose : TOvcCellDataPurpose) of object;
  TCellAttrNotifyEvent = procedure (Sender : TObject;
                                    RowNum : TRowNum; ColNum : TColNum;
                                    var CellAttr : TOvcCellAttributes) of object;
  TRowAttrNotifyEvent = procedure (Sender : TObject; RowNum : TRowNum;
                                    var RowAttr : TOvcRowAttributes) of object;
  TCellPaintNotifyEvent = procedure (Sender : TObject;
                                     TableCanvas : TCanvas;
                               const CellRect    : TRect;
                                     RowNum      : TRowNum;
                                     ColNum      : TColNum;
                               const CellAttr    : TOvcCellAttributes;
                                     Data        : pointer;
                                 var DoneIt      : boolean) of object;
  TCellBeginEditNotifyEvent = procedure (Sender : TObject;
                                         RowNum : TRowNum; ColNum : TColNum;
                                         var AllowIt : boolean) of object;
  TCellEndEditNotifyEvent = procedure (Sender : TObject;
                                       Cell : TOvcTableCellAncestor;
                                       RowNum : TRowNum; ColNum : TColNum;
                                       var AllowIt : boolean) of object;
  TCellMoveNotifyEvent = procedure (Sender : TObject; Command : word;
                                    var RowNum : TRowNum;
                                    var ColNum : TColNum) of object;
  TCellChangeNotifyEvent = procedure (Sender : TObject;
                                      var RowNum : TRowNum;
                                      var ColNum : TColNum) of object;
  TRowChangeNotifyEvent = procedure (Sender : TObject; RowNum1, RowNum2 : TRowNum;
                                     Action : TOvcTblActions) of object;
  TColChangeNotifyEvent = procedure (Sender : TObject; ColNum1, ColNum2 : TColNum;
                                     Action : TOvcTblActions) of object;
  TSizeCellEditorNotifyEvent = procedure (Sender   : TObject;
                                          RowNum   : TRowNum;
                                          ColNum   : TColNum;
                                      var CellRect : TRect;
                                      var CellStyle: TOvcTblEditorStyle) of object;
  TSelectionIterator = function(RowNum1 : TRowNum; ColNum1 : TColNum;
                                RowNum2 : TRowNum; ColNum2 : TColNum;
                                ExtraData : pointer) : boolean of object;


{---Cell-Table interaction messages---}
const
  ctim_Base = WM_USER + $4545;
  ctim_QueryOptions = ctim_Base;
  ctim_QueryColor = ctim_Base + 1;
  ctim_QueryFont = ctim_Base + 2;
  ctim_QueryLockedCols = ctim_Base + 3;
  ctim_QueryLockedRows = ctim_Base + 4;
  ctim_QueryActiveCol = ctim_Base + 5;
  ctim_QueryActiveRow = ctim_Base + 6;

  ctim_RemoveCell = ctim_Base + 10;
  ctim_StartEdit = ctim_Base + 11;
  ctim_StartEditMouse = ctim_Base + 12;
  ctim_StartEditKey = ctim_Base + 13;

  ctim_SetFocus = ctim_Base + 14;
  ctim_KillFocus = ctim_Base + 15;

  ctim_LoadDefaultCells = ctim_Base + 20;

{---Property defaults}
const
  tbDefAccess = otxNormal;
  tbDefAdjust = otaCenterLeft;
  tbDefBorderStyle = bsSingle;
  tbDefColCount = 10;
  tbDefColWidth = 150;
  tbDefGridColor = clBlack;
  tbDefHeight = 100;
  tbDefLockedCols = 1;
  tbDefLockedRows = 1;
  tbDefMargin = 4;
  tbDefRowCount = 10;
  tbDefRowHeight = 30;
  tbDefScrollBars = ssBoth;
  tbDefTableColor = clBtnFace;
  tbDefWidth = 300;

{---Default color for cells (to force them to table color)}
const
  clOvcTableDefault = $2FFFFFF;

{---Handy extra constants for table's CalcRowColFromXY method}
const
  CRCFXY_RowAbove = -2;    {Y is above all table cells}
  CRCFXY_RowBelow = -1;    {Y is below all table cells}
  CRCFXY_ColToLeft = -2;   {X is to left of all table cells}
  CRCFXY_ColToRight = -1;  {X is to right of all table cells}

{---Handy extra constants for TRowNum variables, Row Heights}
const
  RowLimitChanged = -2;
  UseDefHt = -1;

type {internal use only}
  TOvcTblDisplayItem = packed record
    Number : Integer;
    Offset : Integer;
  end;
  POvcTblDisplayArray = ^TOvcTblDisplayArray;
  TOvcTblDisplayArray = packed record
    AllocNm : word;
    Count : word;
    Ay : array [0..127] of TOvcTblDisplayItem; {127 is arbitrary}
  end;

function MakeRowStyle(AHeight : Integer; AHidden : boolean) : TRowStyle;
  {-Make a row style variable from a height and hidden flag.}

procedure TableError(const Msg : string);
  {-Raise an exception with supplied string}
procedure TableErrorRes(StringCode : word);
  {-Raise an exception with supplied string resource code}

procedure AssignDisplayArray(var A : POvcTblDisplayArray; Num : word);
  {-Table internal: (re)assign a display array}

implementation

{===Standard routines================================================}
{--------}
procedure TableError(const Msg : string);
  begin
    raise EOrpheusTable.Create(Msg);
  end;
{--------}
procedure TableErrorRes(StringCode : word);
  begin
    raise EOrpheusTable.Create(GetOrphStr(StringCode));
  end;
{--------}
procedure AssignDisplayArray(var A : POvcTblDisplayArray; Num : word);
  var
    NewA : POvcTblDisplayArray;
    NumToXfer : word;
  begin
    NewA := nil;
    if (Num > 0) then
       begin
         GetMem(NewA, Num*sizeof(TOvcTblDisplayItem)+2*sizeof(word));
         {$IFOPT D+}
         FillChar(NewA^, Num*sizeof(TOvcTblDisplayItem)+2*sizeof(word), $CC);
         {$ENDIF}
         if Assigned(A) then
           begin
             NumToXfer := MinL(Num, A^.Count);
             if (NumToXfer > 0) then
               Move(A^.Ay, NewA^.Ay, NumToXFer*sizeof(TOvcTblDisplayItem));
           end
         else
           NumToXfer := 0;
         with NewA^ do
           begin
             AllocNm := Num;
             Count := NumToXfer;
           end;
       end;
    if Assigned(A) then
      FreeMem(A, A^.AllocNm*sizeof(TOvcTblDisplayItem)+2*sizeof(word));
    A := NewA;
  end;
{--------}
function MakeRowStyle(AHeight : Integer; AHidden : boolean) : TRowStyle;
  begin
    with Result do
      begin
        Height := AHeight;
        Hidden := AHidden;
      end;
  end;
{====================================================================}


{===TOvcTableCellAncestor============================================}
procedure TOvcTableCellAncestor.tcChangeScale(M, D : integer);
  begin
    {do nothing at this level in the cell component hierarchy}
  end;
{--------}
procedure TOvcTableCellAncestor.tcDoCfgChanged;
  begin
    if Assigned(FOnCfgChanged) then
      FOnCfgChanged(Self);
  end;
{====================================================================}


{===TOvcTableAncestor================================================}
constructor TOvcTableAncestor.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    taCellList := TList.Create;
  end;
{--------}
destructor TOvcTableAncestor.Destroy;
  begin
    taLoadList.Free;
    taCellList.Free;
    inherited Destroy;
  end;
{--------}

function TOvcTableAncestor.ControllerAssigned : Boolean;
begin
  Result := Assigned(FController);
end;

procedure TOvcTableAncestor.CreateWnd;
var
  OurForm : TWinControl;

begin
  OurForm := GetImmediateParentForm(Self);

  {do this only when the component is first dropped on the form, not during loading}
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    ResolveController(OurForm, FController);

  if not Assigned(FController) and not (csLoading in ComponentState) then begin
    {try to find a controller on this form that we can use}
    FController := FindController(OurForm);

    {if not found and we are not designing, use default controller}
    if not Assigned(FController) and not (csDesigning in ComponentState) then
      FController := DefaultController;
  end;

  inherited CreateWnd;
end;

procedure TOvcTableAncestor.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    if (AComponent = FController) then
      FController := nil;
  end else if (Operation = opInsert) and (FController = nil) and
              (AComponent is TOvcController) then
    FController := TOvcController(AComponent);
end;

procedure TOvcTableAncestor.SetController(Value : TOvcController);
begin
  FController := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TOvcTableAncestor.ChangeScale(M, D : integer);
  var
    i : integer;
  begin
    inherited ChangeScale(M, D);
    if (M <> D) then
      for i := 0 to pred(taCellList.Count) do
        TOvcTableCellAncestor(taCellList[i]).tcChangeScale(M, D);
  end;
{--------}
procedure TOvcTableAncestor.DefineProperties(Filer : TFiler);
  begin
    inherited DefineProperties(Filer);
    Filer.DefineProperty('CellData', tbReadCellData, tbWriteCellData, true);
  end;
{--------}
procedure TOvcTableAncestor.tbExcludeCell(Cell : TOvcTableCellAncestor);
  begin
    taCellList.Remove(pointer(Cell));
  end;
{--------}
procedure TOvcTableAncestor.tbFinishLoadingCellList;
  {Local methods}
  function GetImmediateParentForm(Control : TControl) : TWinControl;
    var
      ParentCtrl : TControl;
    begin
      ParentCtrl := Control.Parent;
      while Assigned(ParentCtrl) and
            (not ((ParentCtrl is TCustomForm) or
                  (ParentCtrl is TCustomFrame))) do
        ParentCtrl := ParentCtrl.Parent;
      Result := TWinControl(ParentCtrl);
    end;

  {------}

  function FormNamesEqual(const CmptFormName, FormName : string) : boolean;
    var
      PosUL : integer;
    begin
      Result := true;
      if (FormName = '') or (CmptFormName = FormName) then
        Exit;
      PosUL := length(FormName);
      while (PosUL > 0) and (FormName[PosUL] <> '_') do
        dec(PosUL);
      if (PosUL > 0) then
        if (CmptFormName = Copy(FormName, 1, pred(PosUL))) then
          Exit;
      Result := false;
    end;
  {------}

  function GetFormName(const S, FormName : string) : string;
    var
      PosDot : integer;
    begin
      PosDot := Pos('.', S);
      if (PosDot <> 0) then
        Result := Copy(S, 1, pred(PosDot))
      else
        Result := FormName;
    end;
  {------}

  function GetComponentName(const S : string) : string;
    var
      PosDot : integer;
    begin
      PosDot := Pos('.', S);
      if (PosDot <> 0) then
        Result := Copy(S, succ(PosDot), length(S))
      else
        Result := S;
    end;
  {------}
var
  i      : integer;
  Form   : TWinControl;
  Compnt : TComponent;
  DM     : integer;
  DataMod: TDataModule;
  DMCount: integer;
begin
  if Assigned(taLoadList) then
    begin
      {fixup the cell component list: the cells now exist}
      try
        Form := GetImmediateParentForm(Self);
        for i := pred(taLoadList.Count) downto 0 do
          if FormNamesEqual(GetFormName(taLoadList[i], Form.Name),
                            Form.Name) then
            begin
              Compnt := Form.FindComponent(GetComponentName(taLoadList[i]));
              if Assigned(Compnt) and (Compnt is TOvcTableCellAncestor) then
                begin
                  tbIncludeCell(TOvcTableCellAncestor(Compnt));
                  taLoadList.Delete(i);
                end;
            end;
        {fixup references to cell components on any data modules}
        if (taLoadList.Count <> 0) then
          begin
            DM := 0;
            DMCount := Screen.DataModuleCount;
            while (taLoadList.Count > 0) and (DM < DMCount) do
              begin
                DataMod := Screen.DataModules[DM];
                for i := pred(taLoadList.Count) downto 0 do
                  if (GetFormName(taLoadList[i], Form.Name) = DataMod.Name) then
                    begin
                      Compnt := DataMod.FindComponent(GetComponentName(taLoadList[i]));
                      if Assigned(Compnt) and (Compnt is TOvcTableCellAncestor) then
                        begin
                          tbIncludeCell(TOvcTableCellAncestor(Compnt));
                          taLoadList.Delete(i);
                        end;
                    end;
                inc(DM);
              end;
          end;
      finally
        taLoadList.Free;
        taLoadList := nil;
      end;
    end;
end;
{--------}
procedure TOvcTableAncestor.tbIncludeCell(Cell : TOvcTableCellAncestor);
  begin
    if Assigned(Cell) then
      with taCellList do
        if (IndexOf(pointer(Cell)) = -1) then
          begin
            Add(pointer(Cell));
            Cell.OnCfgChanged := tbCellChanged;
          end;
  end;
{--------}
procedure TOvcTableAncestor.Loaded;
  begin
    inherited Loaded;
  end;
{--------}
procedure TOvcTableAncestor.tbNotifyCellsOfTableChange;
  var
    i : integer;
  begin
    if Assigned(taCellList) then
      for i := 0 to pred(taCellList.Count) do
        TOvcTableCellAncestor(taCellList[i]).tcResetTableValues;
  end;
{--------}
procedure TOvcTableAncestor.tbReadCellData(Reader : TReader);
  begin
    if Assigned(taLoadList) then
      taLoadList.Clear
    else
      taLoadList := TStringList.Create;
    with Reader do
      begin
        ReadListBegin;
        while not EndOfList do
          taLoadList.Add(ReadString);
        ReadListEnd;
      end;
  end;
{--------}
procedure TOvcTableAncestor.tbWriteCellData(Writer : TWriter);
  var
    i : integer;
    Cell : TOvcTableCellAncestor;
    S : string;
  begin
    with Writer do
      begin
        WriteListBegin;
        for i := 0 to pred(taCellList.Count) do
          begin
            Cell := TOvcTableCellAncestor(taCellList[i]);
            S := Cell.Owner.Name;
            if (S <> '') then
              S := S + '.' + Cell.Name
            else
              S := Cell.Name;
            WriteString(S);
          end;
        WriteListEnd;
      end;
  end;
{====================================================================}

end.
