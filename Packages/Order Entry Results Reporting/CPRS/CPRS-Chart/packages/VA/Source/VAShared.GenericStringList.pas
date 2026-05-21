unit VAShared.GenericStringList;

interface

uses
  System.Classes;

type
  TStringList<T: class> = class(TStringList)
  private
    function GetObject(Index: Integer): T; reintroduce;
    procedure PutObject(Index: Integer; const Value: T); reintroduce;
  public
    constructor Create; overload;
    constructor Create(OwnsObjects: Boolean); overload;
    constructor Create(QuoteChar, Delimiter: Char); overload;
    constructor Create(QuoteChar, Delimiter: Char;
      Options: TStringsOptions); overload;
    constructor Create(Duplicates: TDuplicates; Sorted: Boolean;
      CaseSensitive: Boolean); overload;
    function AddObject(const S: string; AObject: T): Integer; reintroduce;
    function IndexOfObject(AObject: T): Integer; reintroduce;
    procedure InsertObject(Index: Integer; const S: string; AObject: T);
      reintroduce;
    procedure AddStrings(Strings: TStrings); reintroduce; overload;
    procedure AddStrings(const Strings: array of string); overload;
    procedure AddStrings(const Strings: array of string;
      const Objects: array of T); overload;
    function ContainsObject(const AObject: T): Boolean; inline;
    function ToObjectArray: TArray<T>;
    property Objects[Index: Integer]: T read GetObject write PutObject;
  end;

implementation

{ TStringList<T> }

function TStringList<T>.AddObject(const S: string; AObject: T): Integer;
begin
  Result := inherited AddObject(S, AObject);
end;

procedure TStringList<T>.AddStrings(const Strings: array of string;
  const Objects: array of T);
var
  i: Integer;
  ObjectArray: array of TObject;
begin
  SetLength(ObjectArray, Length(Objects));
  for i := 0 to Length(Objects) - 1 do
    ObjectArray[i] := Objects[i];
  inherited AddStrings(Strings, ObjectArray);
  SetLength(ObjectArray, 0);
end;

procedure TStringList<T>.AddStrings(const Strings: array of string);
begin
  inherited AddStrings(Strings);
end;

procedure TStringList<T>.AddStrings(Strings: TStrings);
begin
  inherited AddStrings(Strings);
end;

function TStringList<T>.ContainsObject(const AObject: T): Boolean;
begin
  Result := inherited ContainsObject(AObject);
end;

constructor TStringList<T>.Create(OwnsObjects: Boolean);
begin
  inherited Create(OwnsObjects);
end;

constructor TStringList<T>.Create(QuoteChar, Delimiter: Char);
begin
  inherited Create(QuoteChar, Delimiter);
  OwnsObjects := True;
end;

constructor TStringList<T>.Create(QuoteChar, Delimiter: Char;
  Options: TStringsOptions);
begin
  inherited Create(QuoteChar, Delimiter, Options);
  OwnsObjects := True;
end;

constructor TStringList<T>.Create(Duplicates: TDuplicates;
  Sorted, CaseSensitive: Boolean);
begin
  inherited Create(Duplicates, Sorted, CaseSensitive);
  OwnsObjects := True;
end;

constructor TStringList<T>.Create;
begin
  Create(True);
end;

function TStringList<T>.GetObject(Index: Integer): T;
begin
  Result := inherited GetObject(Index) as T;
end;

function TStringList<T>.IndexOfObject(AObject: T): Integer;
begin
  Result := inherited IndexOfObject(AObject);
end;

procedure TStringList<T>.InsertObject(Index: Integer; const S: string;
  AObject: T);
begin
  inherited InsertObject(Index, S, AObject);
end;

procedure TStringList<T>.PutObject(Index: Integer; const Value: T);
begin
  inherited PutObject(Index, Value);
end;

function TStringList<T>.ToObjectArray: TArray<T>;
var
  i: Integer;
  ObjectArray: TArray<TObject>;
begin
  ObjectArray := inherited ToObjectArray;
  SetLength(Result, Length(ObjectArray));
  for i := 0 to Length(ObjectArray) - 1 do
    Result[i] := ObjectArray[i] as T;
end;

end.
