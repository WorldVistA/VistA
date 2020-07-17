unit oWVWebSite;

interface

uses
  System.Classes,
  System.SysUtils,
  iWVInterface;

type
  TWVWebSite = class(TInterfacedObject, IWVWebSite)
  private
    fName: string;
    fURL: string;

    function _AddRef: integer; stdcall;
    function _Release: integer; stdcall;
  public
    constructor Create(aInitString: string);
    destructor Destroy; override;

    function GetName: string;
    function GetURL: string;
  end;

implementation

{ TWVWebSite }

constructor TWVWebSite.Create(aInitString: string);
begin
  inherited Create;
  fName := Copy(aInitString, 1, Pos('^', aInitString) - 1);
  fURL := Copy(aInitString, Pos('^', aInitString) + 1, Length(aInitString));
end;

function TWVWebSite._AddRef: integer;
begin
  Result := -1;
end;

function TWVWebSite._Release: integer;
begin
  Result := -1;
end;

destructor TWVWebSite.Destroy;
begin
  inherited;
end;

function TWVWebSite.GetName: string;
begin
  Result := fName;
end;

function TWVWebSite.GetURL: string;
begin
  Result := fURL;
end;

end.
