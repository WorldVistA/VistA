unit uROR_AdvColGrid;

interface
{$IFNDEF NOTMSPACK}

uses
  SysUtils, Classes, Controls, Grids, BaseGrid, AdvGrid, AdvCGrid, OvcFiler;

type
  TAssignRawDataEvent = procedure(Sender: TObject; aCol, aRow: Integer; const RawValue: String; var   CellValue: String) of object;
  TGetRawDataEvent    = procedure(Sender: TObject; aCol, aRow: Integer; var   RawValue: String; const CellValue: String) of object;

  TCCRAdvColGrid = class(TAdvColumnGrid)
  private
    fModified: Boolean;
    fOnAssignRawData: TAssignRawDataEvent;
    fOnGetRawData: TGetRawDataEvent;

  public
    constructor Create(anOwner: TComponent); override;

    procedure AppendRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^');
    procedure AssignRawData(const aRealRow: Integer; const RawData: String;
      anIndexList: array of Integer; const Separator: String = '^'); overload;
    procedure AssignRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^'); overload;

    procedure AddRow;

    function  FindString(const aValue: String; aFieldIndex: Integer;
      aStartRow: Integer = 0): Integer;

    procedure GetRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^'); overload;
    function  GetRawData(const aRealRow: Integer; anIndexList: array of Integer;
      const Separator: String = '^'): String; overload;

    procedure RemoveAll;
    procedure RemoveRow(const aRow: Integer);
    procedure RemoveSelectedRows(const RestoreSel: Boolean = True);

    procedure LoadLayout(aStorage: TOvcAbstractStore; const aSection: String); virtual;
    procedure SaveLayout(aStorage: TOvcAbstractStore; const aSection: String); virtual;

    property Modified: Boolean read fModified write fModified;

  published
    property OnAssignRawData: TAssignRawDataEvent read fOnAssignRawData write fOnAssignRawData;
    property OnGetRawData: TGetRawDataEvent read fOnGetRawData write fOnGetRawData;

  end;

{$ENDIF}
implementation
{$IFNDEF NOTMSPACK}

uses
  uROR_Utilities, Graphics;

constructor TCCRAdvColGrid.Create(anOwner: TComponent);
begin
  inherited;

  ActiveCellColor    := clBtnFace;
  ActiveCellColorTo  := clBtnFace;
  FixedCols          := 1;
  FixedRows          := 1;
  FixedRowAlways     := True;
  Look               := glClassic;
  SelectionColor     := clHighlight;
  SelectionColorTo   := clHighlight;
  SelectionTextColor := clHighlightText;

  with ControlLook do
    begin
      ControlStyle := csClassic;
    end;

  with DragDropSettings do
    begin
      OleAcceptFiles := False;
      OleAcceptText  := False;
    end;

  with SortSettings do
    begin
      Show := True;
    end;

  fModified := False;
end;

procedure TCCRAdvColGrid.AddRow;
begin
  inherited AddRow;
  Modified := True;
end;

procedure TCCRAdvColGrid.AppendRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String = '^');
var
  ii, lastItem: Integer;
begin
  BeginUpdate;
  try
    lastItem := RawData.Count - 1;
    for ii:=0 to lastItem do
      begin
        AddRow;
        AssignRawData(AllRowCount-1, RawData[ii], anIndexList, Separator);
      end;
  finally
    AutoSizeRows(False, 0);
    EndUpdate;
  end;
end;

procedure TCCRAdvColGrid.AssignRawData(const aRealRow: Integer; const RawData: String;
  anIndexList: array of Integer; const Separator: String = '^');
var
  i, ip, n: Integer;
  val: String;
begin
  n := AllColCount - 1;
  if n > High(anIndexList) then n := High(anIndexList);
  for i:=0 to n do
    begin
      ip := anIndexList[i];
      if ip > 0 then
        if Assigned(OnAssignRawData) then
          begin
            val := Piece(RawData, Separator, ip);
            OnAssignRawData(Self, i, aRealRow, Piece(RawData,Separator,ip), val);
            GridCells[i,ARealRow] := val;
          end
        else
          GridCells[i,aRealRow] := Piece(RawData, Separator, ip);
    end;
end;

procedure TCCRAdvColGrid.AssignRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String = '^');
begin
  BeginUpdate;
  try
    RemoveAll;
    AppendRawData(RawData, anIndexList, Separator);
    Modified := False;
  finally
    EndUpdate;
  end;
end;

function TCCRAdvColGrid.FindString(const aValue: String; aFieldIndex: Integer;
  aStartRow: Integer = 0): Integer;
var
  i, n: Integer;
begin
  Result := -1;
  n := AllRowCount - 1;
  for i:=RealRowIndex(FixedRows) to n do
    if AllCells[aFieldIndex,i] = aValue then
      begin
        Result := i;
        Break;
      end;
end;

function TCCRAdvColGrid.GetRawData(const aRealRow: Integer;
  anIndexList: array of Integer; const Separator: String = '^'): String;
var
  i, ifld, lastFld: Integer;
  val: String;
begin
  Result := '';
  lastFld := AllColCount - 1;
  for i:=0 to High(anIndexList) do
    begin
      ifld := anIndexList[i];
      if (ifld < 0) or (ifld > lastFld) then
        Result := Result + Separator
      else if Assigned(OnGetRawData) then
        begin
          val := GridCells[ifld,aRealRow];
          OnGetRawData(Self, ifld, aRealRow, val, val);
          Result := Result + val + Separator;
        end
      else
        Result := Result + GridCells[ifld,aRealRow] + Separator;
    end;
end;

procedure TCCRAdvColGrid.GetRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String = '^');
var
  ir, lastRow: Integer;
begin
  RawData.BeginUpdate;
  try
    lastRow := AllRowCount - 1;
    RawData.Clear;
    for ir:=RealRowIndex(FixedRows) to lastRow do
      RawData.Add(GetRawData(ir, anIndexList, Separator));
  finally
    RawData.EndUpdate;
  end;
end;

procedure TCCRAdvColGrid.LoadLayout(aStorage: TOvcAbstractStore; const aSection: String);
var
  i, n, wd: Integer;
  cid: String;
begin
  try
    aStorage.Open;
    try
      n := AllColCount - 1;
      for i:=0 to n do
        begin
          cid := Columns[i].Name;
          if cid = '' then
            cid := Format('Col[%d]', [i]);
          wd := aStorage.ReadInteger(aSection, cid, -1);
          if wd >= 0 then
            AllColWidths[i] := wd;
        end;
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRAdvColGrid.RemoveAll;
begin
  if AllRowCount>FixedRows then
    begin
      RemoveRows(FixedRows, AllRowCount-FixedRows); //???
      Modified := True;
    end;
end;

procedure TCCRAdvColGrid.RemoveRow(const aRow: Integer);
begin
  inherited RemoveRows(aRow, 1);
  Modified := True;
end;

procedure TCCRAdvColGrid.RemoveSelectedRows(const RestoreSel: Boolean);
var
  cri, i: Integer;
begin
  cri := Row;
//  inherited RemoveSelectedRows;  //It does not work properly
  BeginUpdate;
  try
    for i:=RowCount-1 downto FixedRows do
      if RowSelect[i] then
        RemoveRows(i,1);
  finally
    EndUpdate;
  end;

  Modified := True;
  if RestoreSel then
    begin
      if cri >= RowCount then
        cri := RowCount - 1;
      if cri >= FixedRows then
        begin
          SelectRows(cri, 1);
          Row := cri;
        end;
    end;
end;

procedure TCCRAdvColGrid.SaveLayout(aStorage: TOvcAbstractStore; const aSection: String);
var
  i, n: Integer;
  cid: String;
begin
  try
    aStorage.Open;
    try
      n := AllColCount - 1;
      for i:=0 to n do
        begin
          cid := Columns[i].Name;
          if cid = '' then
            cid := Format('Col[%d]', [i]);
          aStorage.WriteInteger(aSection, cid, AllColWidths[i]);
        end;
    finally
      aStorage.Close;
    end;
  except
  end;
end;

{$ENDIF}
end.
