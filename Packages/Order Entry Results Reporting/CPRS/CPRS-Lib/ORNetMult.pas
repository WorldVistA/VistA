unit ORNetMult;

interface

uses
  System.Classes,
  System.SysUtils,
  ORNetIntf,
  TRPCB;

type
  TORNetMult = class(TInterfacedObject, IORNetParam, IORNetMult)
  private
    fSubscripts: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddSubscript(aSubscript: string; aValue: string); overload;
    procedure AddSubscript(aSubscript: string; aValue: integer); overload;
    procedure AddSubscript(aSubscript: string; aValue: double; aPrecision: integer = 2); overload;

    procedure AddSubscript(aSubscript: integer; aValue: string); overload;
    procedure AddSubscript(aSubscript: integer; aValue: integer); overload;
    procedure AddSubscript(aSubscript: integer; aValue: double; aPrecision: integer = 2); overload;

    procedure AddSubscript(aSubscripts: array of const; aValue: string); overload;
    procedure AddSubscript(aSubscripts: array of const; aValue: integer); overload;
    procedure AddSubscript(aSubscripts: array of const; aValue: double; aPrecision: integer = 2); overload;

    procedure AssignToParamRecord(aParam: TParamRecord);
  end;

implementation

{ TORNetMultiple }

constructor TORNetMult.Create;
begin
  inherited;
  fSubscripts := TStringList.Create;
end;

destructor TORNetMult.Destroy;
begin
  FreeAndNil(fSubscripts);
  inherited;
end;

procedure TORNetMult.AddSubscript(aSubscript: string; aValue: string);
begin
  AddSubscript([aSubscript], aValue);
end;

procedure TORNetMult.AddSubscript(aSubscript: string; aValue: integer);
begin
  AddSubscript([aSubscript], aValue);
end;

procedure TORNetMult.AddSubscript(aSubscript: string; aValue: double; aPrecision: integer = 2);
begin
  AddSubscript([aSubscript], aValue, aPrecision);
end;

procedure TORNetMult.AddSubscript(aSubscript: integer; aValue: string);
begin
  AddSubscript([aSubscript], aValue);
end;

procedure TORNetMult.AddSubscript(aSubscript: integer; aValue: double; aPrecision: integer = 2);
begin
  AddSubscript([aSubscript], aValue, aPrecision);
end;

procedure TORNetMult.AddSubscript(aSubscript: integer; aValue: integer);
begin
  AddSubscript([aSubscript], aValue);
end;

procedure TORNetMult.AddSubscript(aSubscripts: array of const; aValue: integer);
begin
  AddSubscript(aSubscripts, IntToStr(aValue));
end;

procedure TORNetMult.AddSubscript(aSubscripts: array of const; aValue: double; aPrecision: integer);
begin
  AddSubscript(aSubscripts, Format('%0.*f', [aPrecision, aValue]));
end;

procedure TORNetMult.AddSubscript(aSubscripts: array of const; aValue: string);
{
  Do NOT modify!!!  This is the final overload for all other AddSubscript methods!!!
  Issues with an AddSubscript method should be addressed in the proper method above
  before this method is called.
}
var
  i: integer;
  aNode: string;
  aSubnode: string;
begin
  aNode := '';
  aSubnode := '';

  if Length(aSubscripts) = 0 then
    raise Exception.CreateFmt('Error-%s: Must have at least 1 subscript.', [Self.ClassName]);

  for i := Low(aSubscripts) to High(aSubscripts) do
    begin
      case aSubscripts[i].VType of
        vtInteger:
          aSubnode := AnsiQuotedStr(IntToStr(aSubscripts[i].VInteger), '"');

        vtInt64:
          aSubnode := AnsiQuotedStr(IntToStr(aSubscripts[i].VInt64^), '"');

        vtString:
          aSubnode := AnsiQuotedStr(string(aSubscripts[i].VString), '"');

        vtWideChar:
          aSubnode := AnsiQuotedStr(string(aSubscripts[i].VWideChar), '"');

        vtAnsiString:
          aSubnode := AnsiQuotedStr(string(aSubscripts[i].VAnsiString), '"');

        vtUnicodeString:
          aSubnode := AnsiQuotedStr(string(aSubscripts[i].VUnicodeString), '"');
      else
        raise Exception.CreateFmt('Error-%s: Only Integer, Int64, String, WideChar, AnsiString, and UnicodeString types allowed as subscripts.', [Self.ClassName]);
      end;

      if Length(aSubnode) = 0 then
        raise Exception.CreateFmt('Error-%s: Null subscript error.', [Self.ClassName]);

      case Length(aNode) of
        0: aNode := aSubnode;
      else
        aNode := Format('%s,%s', [aNode, aSubnode]);
      end;
    end;

  fSubscripts.Values[aNode] := aValue;
end;

procedure TORNetMult.AssignToParamRecord(aParam: TParamRecord);
var
  i: integer;
begin
  aParam.PType := list;
  for i := 0 to fSubscripts.Count - 1 do
    aParam.Mult[fSubscripts.Names[i]] := fSubscripts.ValueFromIndex[i];
end;

end.
