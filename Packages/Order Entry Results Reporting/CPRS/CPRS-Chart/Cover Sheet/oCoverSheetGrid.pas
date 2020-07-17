unit oCoverSheetGrid;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.RTLConsts,
  iCoverSheetIntf;

type
  TCoverSheetGrid = class(TInterfacedObject, ICoverSheetGrid)
  private
    fRowCount: integer;
    fCoordinates: array of TPoint;

    function getPanelCount: integer;
    function getRowCount: integer;
    procedure ErrorCheck(aPanelIndex: integer);
    function getPanelXY(aPanelIndex: integer): TPoint;
    function getPanelRow(aPanelIndex: integer): integer;
    function getPanelColumn(aPanelIndex: integer): integer;

    procedure setPanelCount(const aValue: integer);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TCoverSheetGrid }

constructor TCoverSheetGrid.Create;
begin
  inherited Create;
end;

destructor TCoverSheetGrid.Destroy;
begin
  SetLength(fCoordinates, 0);
  inherited;
end;

procedure TCoverSheetGrid.ErrorCheck(aPanelIndex: integer);
begin
  if (aPanelIndex < 0) or (aPanelIndex >= Length(fCoordinates)) then
    raise EListError.CreateFmt(LoadResString(@SListIndexError), [aPanelIndex]) at ReturnAddress;
end;

function TCoverSheetGrid.getPanelColumn(aPanelIndex: integer): integer;
begin
  ErrorCheck(aPanelIndex);
  Result := fCoordinates[aPanelIndex].X;
end;

function TCoverSheetGrid.getPanelCount: integer;
begin
  Result := Length(fCoordinates);
end;

function TCoverSheetGrid.getPanelRow(aPanelIndex: integer): integer;
begin
  ErrorCheck(aPanelIndex);
  Result := fCoordinates[aPanelIndex].Y;
end;

function TCoverSheetGrid.getPanelXY(aPanelIndex: integer): TPoint;
begin
  ErrorCheck(aPanelIndex);
  Result := fCoordinates[aPanelIndex];
end;

function TCoverSheetGrid.getRowCount: integer;
begin
  Result := fRowCount;
end;

procedure TCoverSheetGrid.setPanelCount(const aValue: integer);
begin
  SetLength(fCoordinates, 0);

  if (aValue < 1) or (aValue > 12) then
    raise Exception.CreateFmt('Panel count of %d not currently supported.', [aValue])
  else
    SetLength(fCoordinates, aValue);

  case aValue of
    1:
      begin
        fRowCount := 1;

        fCoordinates[0] := Point(0, 0);
      end;
    2:
      begin
        fRowCount := 1;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
      end;
    3:
      begin
        fRowCount := 2;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);

        fCoordinates[2] := Point(0, 1);
      end;
    4:
      begin
        fRowCount := 2;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);

        fCoordinates[2] := Point(0, 1);
        fCoordinates[3] := Point(1, 1);
      end;
    5:
      begin
        fRowCount := 2;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);

        fCoordinates[3] := Point(0, 1);
        fCoordinates[4] := Point(1, 1);
      end;
    6:
      begin
        fRowCount := 2;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);

        fCoordinates[3] := Point(0, 1);
        fCoordinates[4] := Point(1, 1);
        fCoordinates[5] := Point(2, 1);
      end;
    7:
      begin
        fRowCount := 3;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);

        fCoordinates[3] := Point(0, 1);
        fCoordinates[4] := Point(1, 1);

        fCoordinates[5] := Point(0, 2);
        fCoordinates[6] := Point(1, 2);
      end;
    8:
      begin
        fRowCount := 3;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);

        fCoordinates[3] := Point(0, 1);
        fCoordinates[4] := Point(1, 1);

        fCoordinates[5] := Point(0, 2);
        fCoordinates[6] := Point(1, 2);
        fCoordinates[7] := Point(2, 2);
      end;
    9:
      begin
        fRowCount := 3;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);

        fCoordinates[3] := Point(0, 1);
        fCoordinates[4] := Point(1, 1);
        fCoordinates[5] := Point(2, 1);

        fCoordinates[6] := Point(0, 2);
        fCoordinates[7] := Point(1, 2);
        fCoordinates[8] := Point(2, 2);
      end;
    10:
      begin
        fRowCount := 3;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);
        fCoordinates[3] := Point(3, 0);

        fCoordinates[4] := Point(0, 1);
        fCoordinates[5] := Point(1, 1);
        fCoordinates[6] := Point(2, 1);

        fCoordinates[7] := Point(0, 2);
        fCoordinates[8] := Point(1, 2);
        fCoordinates[9] := Point(2, 2);
      end;
    11:
      begin
        fRowCount := 3;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);
        fCoordinates[3] := Point(3, 0);

        fCoordinates[4] := Point(0, 1);
        fCoordinates[5] := Point(1, 1);
        fCoordinates[6] := Point(2, 1);

        fCoordinates[7] := Point(0, 2);
        fCoordinates[8] := Point(1, 2);
        fCoordinates[9] := Point(2, 2);
        fCoordinates[10] := Point(3, 2);
      end;
    12:
      begin
        fRowCount := 3;

        fCoordinates[0] := Point(0, 0);
        fCoordinates[1] := Point(1, 0);
        fCoordinates[2] := Point(2, 0);
        fCoordinates[3] := Point(3, 0);

        fCoordinates[4] := Point(0, 1);
        fCoordinates[5] := Point(1, 1);
        fCoordinates[6] := Point(2, 1);
        fCoordinates[7] := Point(3, 1);

        fCoordinates[8] := Point(0, 2);
        fCoordinates[9] := Point(1, 2);
        fCoordinates[10] := Point(2, 2);
        fCoordinates[11] := Point(3, 2);
      end;
  else
    fRowCount := 0;
  end;

end;

end.
