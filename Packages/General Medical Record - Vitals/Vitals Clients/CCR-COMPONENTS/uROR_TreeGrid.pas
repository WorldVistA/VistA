unit uROR_TreeGrid;

interface
{$IFNDEF NOVTREE}

uses
  SysUtils, Classes, Controls, Windows, uROR_GridView, OvcFiler, VirtualTrees,
  uROR_Utilities, Graphics;

type
  TCCRTreeGridColumn = class;
  TCCRTreeGrid = class;

  TCCRTreeGridSortEvent = procedure(aSender: TCCRTreeGrid;
    var aColumn: TColumnIndex; var aDirection: TSortDirection) of object;

  TCCRTreeGrid = class(TVirtualStringTree)
  private
    fColor: TColor;
    fItemUpdateLock: Integer;
    fOnSort: TCCRTreeGridSortEvent;

    procedure findCallback(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Data: Pointer; var Abort: Boolean);
    function  getField(aFieldIndex: Integer): TCCRTreeGridColumn;
    procedure setColor(const aColor: TColor);

  protected
    procedure ConstructNode(aNode: PVirtualNode); virtual;
    function  DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; override;
    procedure DoFreeNode(Node: PVirtualNode); override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var Text: WideString); override;
    procedure DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoSort(aColumn: TColumnIndex); virtual;
    function  formatFieldValue(aNode: PVirtualNode; aFieldIndex: Integer): String;
    function  getAsBoolean(aNode: PVirtualNode; aFieldIndex: Integer): Boolean;
    function  getAsDateTime(aNode: PVirtualNode; aFieldIndex: Integer): TDateTime;
    function  getAsDouble(aNode: PVirtualNode; aFieldIndex: Integer): Double;
    function  getAsInteger(aNode: PVirtualNode; aFieldIndex: Integer): Integer;
    function  getAsString(aNode: PVirtualNode; aFieldIndex: Integer): String;
    function  getFormatted(aNode: PVirtualNode; aFieldIndex: Integer): String;
    function  GetColumnClass: TVirtualTreeColumnClass; override;
    procedure setAsBoolean(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: Boolean);
    procedure setAsDateTime(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: TDateTime);
    procedure setAsDouble(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: Double);
    procedure setAsInteger(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: Integer);
    procedure setAsString(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: String);
    procedure SetEnabled(aValue: Boolean); override;
    procedure UpdateStringValues(aNode: PVirtualNode; const aFieldIndex: Integer = -1);

    property ItemUpdateLock: Integer read fItemUpdateLock;

  public
    constructor Create(anOwner: TComponent); override;

    function  AddChild(Parent: PVirtualNode; UserData: Pointer = nil): PVirtualNode;
    procedure AppendRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^'; const numStrPerItem: Integer = 1);
    procedure AssignRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^');
    procedure BeginItemUpdate(aNode: PVirtualNode); virtual;
    procedure EndItemUpdate(aNode: PVirtualNode); virtual;
    function  Find(const aValue: String; const aField: Integer;
      aParent: PVirtualNode = nil; const Recursive: Boolean = False): PVirtualNode;
    function  GetDataType(aFieldIndex: Integer): TCCRGridDataType;
    procedure GetRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^');
    function  GetRawNodeData(aNode: PVirtualNode; anIndexList: array of Integer;
      const Separator: String = '^'): String;
    function  InsertNode(Node: PVirtualNode; Mode: TVTNodeAttachMode; UserData: Pointer = nil): PVirtualNode;
    procedure LoadLayout(aStorage: TOvcAbstractStore; const aSection: String); virtual;
    procedure SaveLayout(aStorage: TOvcAbstractStore; const aSection: String); virtual;
    procedure SetRawNodeData(aNode: PVirtualNode; const RawData: String;
      anIndexList: array of Integer; const Separator: String = '^');
    procedure SortData; virtual;

    property AsBoolean[aNode: PVirtualNode; anIndex: Integer]: Boolean
      read  getAsBoolean  write setAsBoolean;

    property AsDateTime[aNode: PVirtualNode; anIndex: Integer]: TDateTime
      read  getAsDateTime  write setAsDateTime;

    property AsDouble[aNode: PVirtualNode; anIndex: Integer]: Double
      read  getAsDouble  write setAsDouble;

    property AsInteger[aNode: PVirtualNode; anIndex: Integer]: Integer
      read  getAsInteger  write setAsInteger;

    property AsString[aNode: PVirtualNode; anIndex: Integer]: String
      read  getAsString  write setAsString;

    property Fields[aFieldIndex: Integer]: TCCRTreeGridColumn read getField;

    property Formatted[aNode: PVirtualNode; anIndex: Integer]: String
      read getFormatted;

  published
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind default bkNone;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property ChangeDelay;
    property Ctl3D;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Images;
    property Indent;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property Visible;

    property Color: TColor                            read    fColor
                                                      write   setColor
                                                      default clWindow;

    property OnSort: TCCRTreeGridSortEvent            read    fOnSort
                                                      write   fOnSort;

  end;

  TCCRTreeGridColumn = class(TVirtualTreeColumn)
  private
    fAllowSort:    Boolean;
    fDataType:     TCCRGridDataType;
    fFMDTOptions:  TFMDateTimeMode;
    fFormat:       String;

  public
    constructor Create(aCollection: TCollection); override;

    procedure Assign(Source: TPersistent); override;

  published

    property AllowSort: Boolean                       read    fAllowSort
                                                      write   fAllowSort
                                                      default True;

    property DataType: TCCRGridDataType               read    fDataType
                                                      write   fDataType
                                                      default gftString;

    property FMDTOptions: TFMDateTimeMode             read    fFMDTOptions
                                                      write   fFMDTOptions
                                                      default fmdtShortDateTime;

    property Format: String                           read    fFormat
                                                      write   fFormat;

  end;

{$ENDIF}
implementation
{$IFNDEF NOVTREE}

uses
  uROR_Resources;

type
  SearchDescriptor = record
    Field: Integer;
    Value: String;
  end;

///////////////////////////////// TCCRTreeGrid \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRTreeGrid.Create(anOwner: TComponent);
begin
  inherited;

  BevelKind    := bkNone;
  fColor       := clWindow;
  NodeDataSize := SizeOf(TCCRFieldDataArray);
  ParentColor  := False;
  TreeOptions.SelectionOptions := TreeOptions.SelectionOptions + [toFullRowSelect];
  TabStop      := True;
end;

function TCCRTreeGrid.AddChild(Parent: PVirtualNode; UserData: Pointer): PVirtualNode;
begin
  Result := inherited AddChild(Parent, UserData);
  if Assigned(Result) then
    ConstructNode(Result);
end;

procedure TCCRTreeGrid.AppendRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String = '^'; const numStrPerItem: Integer = 1);
var
  i, j: Integer;
  buf: String;
  vn: PVirtualNode;
begin
  BeginUpdate;
  try
    i := 0;
    while i < RawData.Count do
      begin
        buf := RawData[i];
        Inc(i);
        for j:=2 to numStrPerItem do
          begin
            if i >= RawData.Count then
              Break;
            buf := buf + Separator + RawData[i];
            Inc(i);
          end;
        vn := AddChild(RootNode);
        SetRawNodeData(vn, buf, anIndexList, Separator);
      end;
  finally
    EndUpdate;
  end;
end;

procedure TCCRTreeGrid.AssignRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String = '^');
begin
  BeginUpdate;
  try
    Clear;
    AppendRawData(RawData, anIndexList, Separator);
  finally
    EndUpdate;
  end;
end;

procedure TCCRTreeGrid.BeginItemUpdate(aNode: PVirtualNode);
begin
  if fItemUpdateLock = 0 then
    BeginUpdate;
  Inc(fItemUpdateLock);
end;

procedure TCCRTreeGrid.EndItemUpdate(aNode: PVirtualNode);
begin
  if fItemUpdateLock > 0 then
    begin
      Dec(fItemUpdateLock);
      if fItemUpdateLock = 0 then
        begin
          UpdateStringValues(aNode);
          EndUpdate;
        end;
    end;
end;

procedure TCCRTreeGrid.ConstructNode(aNode: PVirtualNode);
var
  pfda: PCCRFieldDataArray;
begin
  pfda := GetNodeData(aNode);
  SetLength(pfda^, Header.Columns.Count);
end;

function TCCRTreeGrid.DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer;
var
  dt1, dt2, dt: TCCRGridDataType;
  iv1, iv2: Integer;
  dv1, dv2: Double;
  bv1, bv2: Boolean;
  pfda1, pfda2: PCCRFieldDataArray;
begin
  Result := 0;
  if (Column < 0) or (Column >= Header.Columns.Count) then Exit;
  dt := Fields[Column].DataType;

  if dt = gftMUMPS then
    begin
      pfda1 := GetNodeData(Node1);
      pfda2 := GetNodeData(Node2);
      //--- Get the actual data types
      dt1 := pfda1^[Column].MType;
      dt2 := pfda2^[Column].MType;
      //--- If they are different, perform MUMPS-like comparison.
      //--- Otherwise, skip to the regular comparison of values.
      if dt1 <> dt2 then
        begin
          //--- Item1
          if getAsString(Node1, Column) = '' then
              Dec(Result, 1)
          else if dt1 = gftDouble then
              Inc(Result, 1)
          else if dt1 = gftString then
              Inc(Result, 2);
          //--- Item2
          if getAsString(Node2, Column) = '' then
              Inc(Result, 1)
          else if dt2 = gftDouble then
              Dec(Result, 1)
          else if dt2 = gftString then
              Dec(Result, 2);
          {
          dv1\dv2 | empty | number | string
          --------+-------+--------+---------
          empty   |   0   |   -2   |   -3
          --------+-------+--------+---------
          number  |   2   |  cmp.  |   -1
          --------+-------+--------+---------
          string  |   3   |    1   |  cmp.
          }
          if Result < -1 then
            Result := -1;
          if Result > 1 then
            Result := 1;
        end
      else
        dt := dt1;
    end;
  //--- Regular comparison of field values
  case dt of
    gftBoolean:
      begin
        bv1 := getAsBoolean(Node1, Column);
        bv2 := getAsBoolean(Node2, Column);
        if      bv1 > bv2 then Result :=  1
        else if bv1 < bv2 then Result := -1;
      end;
    gftDateTime, gftDouble, gftFMDate:
      begin
        dv1 := getAsDouble(Node1, Column);
        dv2 := getAsDouble(Node2, Column);
        if      dv1 > dv2 then Result :=  1
        else if dv1 < dv2 then Result := -1;
      end;
    gftInteger:
      begin
        iv1 := getAsInteger(Node1, Column);
        iv2 := getAsInteger(Node2, Column);
        if      iv1 > iv2 then Result :=  1
        else if iv1 < iv2 then Result := -1;
      end;
    gftString:
      Result := CompareStr(
        getAsString(Node1, Column),
        getAsString(Node2, Column));
  end;
end;

procedure TCCRTreeGrid.DoFreeNode(Node: PVirtualNode);
var
  pfda: PCCRFieldDataArray;
begin
  try
    pfda := GetNodeData(Node);
    Finalize(pfda^);
  except
  end;
  inherited;
end;

procedure TCCRTreeGrid.DoGetText(Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var Text: WideString);
begin
  if TextType = ttNormal then
    Text := formatFieldValue(Node, Column);
  inherited DoGetText(Node, Column, TextType, Text);
end;

procedure TCCRTreeGrid.DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button <> mbLeft) or (Shift <> []) then
    inherited DoHeaderClick(Column, Button, Shift, X, Y)
  else if Fields[Column].AllowSort then
    DoSort(Column);
end;

procedure TCCRTreeGrid.DoSort(aColumn: TColumnIndex);
var
  dir: TSortDirection;
begin
  if aColumn <> Header.SortColumn then
    dir := sdAscending
  else if Header.SortDirection = sdAscending then
    dir := sdDescending
  else
    dir := sdAscending;

  if not (toAutoSort in TreeOptions.AutoOptions) then
    begin
      if Assigned(OnSort) then
        OnSort(Self, aColumn, dir);
      //---
      Header.SortColumn := aColumn;
      Header.SortDirection := dir;
      //---
      if not Assigned(OnSort) then
        SortTree(aColumn, dir);
    end
  else
    begin
      Header.SortColumn := aColumn;
      Header.SortDirection := dir;
    end;
end;

function TCCRTreeGrid.Find(const aValue: String; const aField: Integer;
  aParent: PVirtualNode; const Recursive: Boolean): PVirtualNode;
var
  sd: SearchDescriptor;
begin
  Result := nil;
  if Recursive then
    begin
      sd.Field := aField;
      sd.Value := aValue;
      Result := IterateSubtree(aParent, findCallback, @sd);
    end
  else
    begin
      Result := GetFirstChild(aParent);
      while Assigned(Result) do
        if AsString[Result,aField] = aValue then
          Break
        else
          Result := GetNextSibling(Result);
    end;
end;

procedure TCCRTreeGrid.findCallback(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
begin
  with SearchDescriptor(Data^) do
    Abort := (AsString[Node,Field] = Value);
end;

function TCCRTreeGrid.formatFieldValue(aNode: PVirtualNode; aFieldIndex: Integer): String;
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  Result := '';
  pfda := GetNodeData(aNode);
  if (aFieldIndex < 0) or (aFieldIndex > High(pfda^)) then Exit;

  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;

  //--- Get the default external value of the field
  case dt of
    gftBoolean:
      Result := BooleanToString(
                    pfda^[aFieldIndex].VBoolean,
                    Fields[aFieldIndex].Format);
    gftDateTime:
     if pfda^[aFieldIndex].VDateTime > 0 then
        Result := FormatDateTime(
                    Fields[aFieldIndex].Format,
                    pfda^[aFieldIndex].VDateTime);
    gftDouble:
      Result := FormatFloat(
                    Fields[aFieldIndex].Format,
                    pfda^[aFieldIndex].VDouble);
    gftFMDate:
      if pfda^[aFieldIndex].VDouble > 0 then
        Result := FMDateTimeStr(
                    FloatToStr(pfda^[aFieldIndex].VDouble),
                    Fields[aFieldIndex].FMDTOptions);
    gftInteger:
      if Fields[aFieldIndex].Format <> '' then
        Result := Format(
                    Fields[aFieldIndex].Format,
                    [pfda^[aFieldIndex].VInteger])
      else
        Result := IntToStr(pfda^[aFieldIndex].VInteger);
    gftString, gftMUMPS:
      if Fields[aFieldIndex].Format <> '' then
        Result := Format(
                    Fields[aFieldIndex].Format,
                    [pfda^[aFieldIndex].VString])
      else
        Result := pfda^[aFieldIndex].VString;
  end;
end;

function TCCRTreeGrid.getAsBoolean(aNode: PVirtualNode; aFieldIndex: Integer): Boolean;
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  Result := False;
  pfda := GetNodeData(aNode);
  if aFieldIndex <= High(pfda^) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := pfda^[aFieldIndex].MType;
      case dt of
        gftBoolean:
          Result := pfda^[aFieldIndex].VBoolean;
        gftDateTime:
          Result := (pfda^[aFieldIndex].VDateTime > 0);
        gftDouble:
          Result := (pfda^[aFieldIndex].VDouble <> 0);
        gftFMDate:
          Result := (pfda^[aFieldIndex].VDouble > 0);
        gftInteger:
          Result := (pfda^[aFieldIndex].VInteger <> 0);
        gftString:
           Result := StrToBoolDef(pfda^[aFieldIndex].VString, False);
      end;
    end;
end;

function TCCRTreeGrid.getAsDateTime(aNode: PVirtualNode; aFieldIndex: Integer): TDateTime;
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  Result := 0;
  pfda := GetNodeData(aNode);
  if aFieldIndex <= High(pfda^) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := pfda^[aFieldIndex].MType;
      case dt of
        gftBoolean:
            Result := -1;
        gftDateTime:
          Result := pfda^[aFieldIndex].VDateTime;
        gftDouble, gftFMDate:
          Result := pfda^[aFieldIndex].VDouble;
        gftInteger:
          Result := pfda^[aFieldIndex].VInteger;
        gftString:
          Result := StrToFloatDef(pfda^[aFieldIndex].VString, 0);
      end;
    end;
  if Result < 0 then
    raise EConvertError.Create(RSC0020);
end;

function TCCRTreeGrid.getAsDouble(aNode: PVirtualNode; aFieldIndex: Integer): Double;
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  Result := 0;
  pfda := GetNodeData(aNode);
  if aFieldIndex <= High(pfda^) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := pfda^[aFieldIndex].MType;
      case dt of
        gftBoolean:
          if pfda^[aFieldIndex].VBoolean then
            Result := 1
          else
            Result := 0;
        gftDateTime:
          Result := pfda^[aFieldIndex].VDateTime;
        gftDouble, gftFMDate:
          Result := pfda^[aFieldIndex].VDouble;
        gftInteger:
          Result := pfda^[aFieldIndex].VInteger;
        gftString:
          Result := StrToFloatDef(pfda^[aFieldIndex].VString, 0);
      end;
    end;
end;

function TCCRTreeGrid.getAsInteger(aNode: PVirtualNode; aFieldIndex: Integer): Integer;
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  Result := 0;
  pfda := GetNodeData(aNode);
  if aFieldIndex <= High(pfda^) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := pfda^[aFieldIndex].MType;
      case dt of
        gftBoolean:
          if pfda^[aFieldIndex].VBoolean then
            Result := 1
          else
            Result := 0;
        gftDateTime:
          Result := Trunc(pfda^[aFieldIndex].VDateTime);
        gftDouble, gftFMDate:
          Result := Trunc(pfda^[aFieldIndex].VDouble);
        gftInteger:
          Result := pfda^[aFieldIndex].VInteger;
        gftString:
          Result := StrToIntDef(pfda^[aFieldIndex].VString, 0);
      end;
    end;
end;

function TCCRTreeGrid.getAsString(aNode: PVirtualNode; aFieldIndex: Integer): String;
var
  pfda: PCCRFieldDataArray;
begin
  Result := '';
  if Assigned(aNode) then
    begin
      pfda := GetNodeData(aNode);
      if (aFieldIndex >= 0) and (aFieldIndex <= High(pfda^)) then
        Result := pfda^[aFieldIndex].VString;
    end;
end;

function TCCRTreeGrid.GetColumnClass: TVirtualTreeColumnClass;
begin
  Result := TCCRTreeGridColumn;
end;

function TCCRTreeGrid.GetDataType(aFieldIndex: Integer): TCCRGridDataType;
begin
  Result := gftUnknown;
  if (aFieldIndex >= 0) and (aFieldIndex < Header.Columns.Count) then
    Result := Fields[aFieldIndex].DataType;
end;

function TCCRTreeGrid.getField(aFieldIndex: Integer): TCCRTreeGridColumn;
begin
  Result := inherited Header.Columns[aFieldIndex] as TCCRTreeGridColumn;
end;

function TCCRTreeGrid.getFormatted(aNode: PVirtualNode; aFieldIndex: Integer): String;
begin
  if (aFieldIndex < 0) or (aFieldIndex >= Header.Columns.Count) then
    Result := ''
  else
    Result := formatFieldValue(aNode, aFieldIndex);
end;

procedure TCCRTreeGrid.GetRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String = '^');
var
  buf: String;
  vn: PVirtualNode;
begin
  RawData.BeginUpdate;
  try
    RawData.Clear;
    vn := GetFirstChild(RootNode);
    while Assigned(vn) do
      begin
        buf := GetRawNodeData(vn, anIndexList, Separator);
        RawData.Add(buf);
        vn := getNextSibling(vn);
      end;
  finally
    RawData.EndUpdate;
  end;
end;

function TCCRTreeGrid.GetRawNodeData(aNode: PVirtualNode; anIndexList: array of Integer;
  const Separator: String = '^'): String;
var
  i, ifld, lastFld: Integer;
begin
  Result := '';
  if Assigned(aNode) then
    begin
      lastFld := Header.Columns.Count - 1;
      for i:=0 to High(anIndexList) do
        begin
          ifld := anIndexList[i];
          if (ifld >= 0) and (ifld <= lastFld) then
            Result := Result + AsString[aNode,ifld] + Separator
          else
            Result := Result + Separator;
        end;
    end;
end;

function TCCRTreeGrid.InsertNode(Node: PVirtualNode; Mode: TVTNodeAttachMode; UserData: Pointer): PVirtualNode;
begin
  Result := inherited InsertNode(Node, Mode, UserData);
  if Assigned(Result) then
    ConstructNode(Result);
end;

procedure TCCRTreeGrid.LoadLayout(aStorage: TOvcAbstractStore; const aSection: String);
var
  i, n, wd: Integer;
begin
  try
    aStorage.Open;
    try
      n := Header.Columns.Count - 1;
      for i:=0 to n do
        begin
          wd := aStorage.ReadInteger(aSection, Fields[i].GetNamePath, -1);
          if wd >= 0 then Fields[i].Width := wd;
        end;
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRTreeGrid.SaveLayout(aStorage: TOvcAbstractStore; const aSection: String);
  var
    i, n: Integer;
begin
  try
    aStorage.Open;
    try
      n := Header.Columns.Count - 1;
      for i:=0 to n do
        aStorage.WriteInteger(aSection, Fields[i].GetNamePath, Fields[i].Width);
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRTreeGrid.setAsBoolean(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: Boolean);
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  if not Assigned(aNode) then Exit;
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;
  pfda := GetNodeData(aNode);

  if aFieldIndex > High(pfda^) then
    SetLength(pfda^, aFieldIndex+1);
  if dt = gftMUMPS then
    begin
      pfda^[aFieldIndex].MType := gftDouble;
      dt := gftDouble;
    end;
  case dt of
    gftBoolean:
      pfda^[aFieldIndex].VBoolean := aValue;
    gftDateTime, gftFMDate:
      raise EConvertError.Create(RSC0020);
    gftDouble:
      if aValue then
        pfda^[aFieldIndex].VDouble := 1
      else
        pfda^[aFieldIndex].VDouble := 0;
    gftInteger:
      if aValue then
        pfda^[aFieldIndex].VInteger := 1
      else
        pfda^[aFieldIndex].VInteger := 0;
    gftString:
      pfda^[aFieldIndex].VString := BoolToStr(aValue);
  end;
  UpdateStringValues(aNode, aFieldIndex);
end;

procedure TCCRTreeGrid.setAsDateTime(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: TDateTime);
begin
  setAsDouble(aNode, aFieldIndex, aValue);
end;

procedure TCCRTreeGrid.setAsDouble(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: Double);
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  if not Assigned(aNode) then Exit;
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;
  pfda := GetNodeData(aNode);

  if aFieldIndex > High(pfda^) then
    SetLength(pfda^, aFieldIndex+1);
  if dt = gftMUMPS then
    begin
      pfda^[aFieldIndex].MType := gftDouble;
      dt := gftDouble;
    end;
  case dt of
    gftBoolean:
      pfda^[aFieldIndex].VBoolean := (aValue <> 0);
    gftDateTime:
      pfda^[aFieldIndex].VDateTime := aValue;
    gftDouble, gftFMDate:
      pfda^[aFieldIndex].VDouble := aValue;
    gftInteger:
      pfda^[aFieldIndex].VInteger := Trunc(aValue);
    gftString:
      pfda^[aFieldIndex].VString := FloatToStr(aValue);
  end;
  UpdateStringValues(aNode, aFieldIndex);
end;

procedure TCCRTreeGrid.setAsInteger(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: Integer);
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  if not Assigned(aNode) then Exit;
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;
  pfda := GetNodeData(aNode);

  if aFieldIndex > High(pfda^) then
    SetLength(pfda^, aFieldIndex+1);
  if dt = gftMUMPS then
    begin
      pfda^[aFieldIndex].MType := gftDouble;
      dt := gftDouble;
    end;
  case dt of
    gftBoolean:
      pfda^[aFieldIndex].VBoolean := (aValue <> 0);
    gftDateTime:
      pfda^[aFieldIndex].VDateTime := aValue;
    gftDouble, gftFMDate:
      pfda^[aFieldIndex].VDouble := aValue;
    gftInteger:
      pfda^[aFieldIndex].VInteger := aValue;
    gftString:
      pfda^[aFieldIndex].VString := IntToStr(aValue);
  end;
  UpdateStringValues(aNode, aFieldIndex);
end;

procedure TCCRTreeGrid.setAsString(aNode: PVirtualNode; aFieldIndex: Integer; const aValue: String);
var
  dt: TCCRGridDataType;
  pfda: PCCRFieldDataArray;
begin
  if not Assigned(aNode) then Exit;
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;
  pfda := GetNodeData(aNode);

  if aFieldIndex > High(pfda^) then
    SetLength(pfda^, aFieldIndex+1);
  case dt of
    gftBoolean:
      pfda^[aFieldIndex].VBoolean := StrToBoolDef(aValue, False);
    gftDateTime:
      pfda^[aFieldIndex].VDateTime := StrToDateTimeDef(aValue, 0);
    gftDouble, gftFMDate:
      pfda^[aFieldIndex].VDouble := StrToFloatDef(aValue, 0);
    gftInteger:
      pfda^[aFieldIndex].VInteger := StrToIntDef(aValue, 0);
    gftMUMPS:
      try
        pfda^[aFieldIndex].VDouble := StrToFloat(aValue);
        pfda^[aFieldIndex].MType   := gftDouble;
      except
        pfda^[aFieldIndex].VString := aValue;
        pfda^[aFieldIndex].MType   := gftString;
      end;
    gftString:
      pfda^[aFieldIndex].VString := aValue;
  end;
  UpdateStringValues(aNode, aFieldIndex);
end;

procedure TCCRTreeGrid.setColor(const aColor: TColor);
begin
  if aColor <> fColor then
    begin
      fColor := aColor;
      if Enabled then
        inherited Color := aColor;
    end;
end;

procedure TCCRTreeGrid.SetEnabled(aValue: Boolean);
begin
  if aValue <> Enabled then
    begin
      inherited;
      if aValue then
        inherited Color := fColor
      else
        inherited Color := clBtnFace;
    end;
end;

procedure TCCRTreeGrid.SetRawNodeData(aNode: PVirtualNode; const RawData: String;
  anIndexList: array of Integer; const Separator: String = '^');
var
  i, ip, n: Integer;
begin
  if not Assigned(aNode) then Exit;
  n := header.Columns.Count - 1;
  if n > High(anIndexList) then n := High(anIndexList);
  BeginItemUpdate(aNode);
  try
    for i:=0 to n do
      begin
        ip := anIndexList[i];
        if ip > 0 then
          AsString[aNode,i] := Piece(RawData, Separator, ip);
      end;
  finally
    EndItemUpdate(aNode);
  end;
end;

procedure TCCRTreeGrid.SortData;
var
  dir: TSortDirection;
  col: TColumnIndex;
begin
  col := Header.SortColumn;
  dir := Header.SortDirection;
  if Assigned(OnSort) then
    OnSort(Self, col, dir)
  else
    SortTree(col, dir);
end;

procedure TCCRTreeGrid.UpdateStringValues(aNode: PVirtualNode; const aFieldIndex: Integer);
var
  i, n: Integer;
  pfda: PCCRFieldDataArray;

  procedure update_field(const aFieldIndex: Integer);
  var
    dt: TCCRGridDataType;
  begin
    dt := GetDataType(aFieldIndex);
    if (dt = gftUnknown) or (aFieldIndex > High(pfda^)) then
      Exit;
    //--- Update the internal string value of the field
    with pfda^[aFieldIndex] do
      begin
        if dt = gftMUMPS then
          dt := MType;
        case dt of
          gftBoolean:
            VString := BoolToStr(VBoolean);
          gftDateTime:
            VString := FloatToStr(VDateTime);
          gftDouble, gftFMDate:
            VString := FloatToStr(VDouble);
          gftInteger:
            VString := IntToStr(VInteger);
        end;
      end;
  end;

begin
  if not Assigned(aNode) then
    Exit;
  pfda := GetNodeData(aNode);

  if ItemUpdateLock = 0 then
    if aFieldIndex >= 0 then
      update_field(aFieldIndex)
    else
      begin
        n := Header.Columns.Count - 1;
        for i:=0 to n do
          update_field(i);
      end;
end;

////////////////////////////// TCCRTreeGridColumn \\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRTreeGridColumn.Create(aCollection: TCollection);
begin
  inherited;
  fAllowSort   := True;
  fDataType    := gftString;
  fFMDTOptions := fmdtShortDateTime;
end;

procedure TCCRTreeGridColumn.Assign(Source: TPersistent);
begin
  if Source is TCCRTreeGridColumn then
    with TCCRTreeGridColumn(Source) do
      begin
        Self.AllowSort   := AllowSort;
        Self.DataType    := DataType;
        Self.FMDTOptions := FMDTOptions;
        Self.Format      := Format;
      end;
  inherited;
end;

{$ENDIF}
end.
