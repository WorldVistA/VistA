unit oCoverSheetParam;

{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Simple object that maintains the parameters for any
  *                     CoverSheet panel.
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
  Vcl.Graphics,
  iCoverSheetIntf;

type
  TCoverSheetParam = class(TInterfacedObject, ICoverSheetParam)
  private
    //
  protected
    fID: integer;
    fDisplayCol: integer;
    fDisplayRow: integer;
    fTitle: string;

    function getID: integer;
    function getDisplayColumn: integer;
    function getDisplayRow: integer;
    function getTitle: string;

    procedure setDisplayColumn(const aValue: integer);
    procedure setDisplayRow(const aValue: integer);
    procedure setTitle(const aValue: string);

    function NewCoverSheetControl(aOwner: TComponent): TControl; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TCoverSheetParam }

constructor TCoverSheetParam.Create;
begin
  inherited Create;
  fID := 0;
  fDisplayCol := -1;
  fDisplayRow := -1;
  fTitle := 'Base TCoverSheetParam';
end;

destructor TCoverSheetParam.Destroy;
begin
  inherited;
end;

function TCoverSheetParam.getID: integer;
begin
  Result := fID;
end;

function TCoverSheetParam.getDisplayColumn: integer;
begin
  Result := fDisplayCol;
end;

function TCoverSheetParam.getDisplayRow: integer;
begin
  Result := fDisplayRow;
end;

function TCoverSheetParam.getTitle: string;
begin
  Result := fTitle;
end;

procedure TCoverSheetParam.setDisplayColumn(const aValue: integer);
begin
  fDisplayCol := aValue;
end;

procedure TCoverSheetParam.setDisplayRow(const aValue: integer);
begin
  fDisplayRow := aValue;
end;

procedure TCoverSheetParam.setTitle(const aValue: string);
begin
  fTitle := aValue;
end;

end.
