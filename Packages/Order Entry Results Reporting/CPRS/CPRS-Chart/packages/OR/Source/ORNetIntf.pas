unit ORNetIntf;

interface

uses
  System.Classes,
  System.SysUtils,
  TRPCB;

type
  IORNetMult = interface;
  IORNetParam = interface;

  IORNetMult = interface(IInterface)
    ['{6C393A44-D6D4-4328-9D69-CA0A09D39D19}']
    procedure AddSubscript(aSubscript: string; aValue: string); overload;
    procedure AddSubscript(aSubscript: string; aValue: Int64); overload;
    procedure AddSubscript(aSubscript: string; aValue: Double; aPrecision: Integer = -1); overload;

    procedure AddSubscript(aSubscript: Integer; aValue: string); overload;
    procedure AddSubscript(aSubscript: Integer; aValue: Int64); overload;
    procedure AddSubscript(aSubscript: Integer; aValue: Double; aPrecision: Integer = -1); overload;

    procedure AddSubscript(aSubscripts: array of const; aValue: string); overload;
    procedure AddSubscript(aSubscripts: array of const; aValue: Int64); overload;
    procedure AddSubscript(aSubscripts: array of const; aValue: Double; aPrecision: Integer = -1); overload;
  end;

  IORNetParam = interface(IInterface)
    ['{D7254EDB-349C-43DE-8885-F11134EFCCB0}']
    procedure AssignToParamRecord(aParam: TParamRecord);
  end;

function NewORNetMult(var aORNetMult: IORNetMult): boolean;

implementation

uses
  ORNetMult;

function NewORNetMult(var aORNetMult: IORNetMult): boolean;
begin
  Result := TORNetMult.Create.GetInterface(IORNetMult, aORNetMult);
end;

end.
