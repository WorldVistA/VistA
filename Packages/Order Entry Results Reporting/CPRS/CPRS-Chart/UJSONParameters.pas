unit UJSONParameters;

////////////////////////////////////////////////////////////////////////////////
// This unit introduces TJSONParameters, which allows for saving and loading
//   parameters to a JSON format. If a parameter is saved to a position (a path)
//   that already exists, then that parameter is saved to the existing type at
//   that position. If the parameter is saved to a new position, then the type
//   passed into the SetAsType function will determine what type the parameter
//   is set to in the JSON.
//
// To set a parameter:
//   SystemParameters.SetAsType<string>('ParameterName', S);
//
// To retrieve a parameter:
//   S := SystemParameters.AsType<string>('ParameterName');
// To retrieve a parameter with a default value:
//   S := SystemParameters.AsTypeDef<string>('ParameterName','Default');
// To retrieve a parameter without raising an error:
//   S := SystemParameters.TryAsType<string>('ParameterName');
//
// TJSONParameters.EnumeratedIsString: If true, enumerated types are saved by
//   their name. If false, they are saved by their ordinal values (this only has
//   effect if the path does not exist in the object)
// TJSONParameters.TrueStrings
// TJSONParameters.FalseStrings: Interpreting booleans is governed by these
//   two properties
//
// If saving to the special CPRS type "PieceString", and the path does not
//   yet exist, use SetAsType<TPieceString> to force creation of the correct
//   structure.
// Example:
//   SystemParameters.SetAsType<PieceString>('CopyPaste.ExcludeApps', S);
//
////////////////////////////////////////////////////////////////////////////////

interface

uses
  ORNetIntf,
  System.Classes,
  System.JSON;

const
  DefaultObjectDelimiter = #13#10;
  DefaultPairDelimiter = '^';
  DefaultNameValueSeparator = '=';

type
  // Used in ToIORNetMults
  TIORNetMults = array of IORNetMult;

  // TPieceString enables setting of new piece strings in the JSON by using
  //  JSONParameters.SetAsType<TPieceString>(Path, StringValue);
  TPieceString = type string;

  // This makes assigning to record type property work as you would expect
  // Example:
  //   JSONParameters.PieceStringFormat.PairDelimiter := '^';
  PPieceStringFormat = ^TPieceStringFormat;

  TPieceStringFormat = record
    ObjectDelimiter: string;
    PairDelimiter: string;
    NameValueSeparator: string;
  end;

  PBooleanFormat = ^TBooleanFormat;

  TBooleanFormat = record
    TrueStrings: array of string;
    FalseStrings: array of string;
  end;

  TJSONParameters = class(TObject)
  private
    // Private Fields
    FOwnsDataObject: Boolean;
    FDataObject: TJSONObject;
    FEnumeratedIsString: Boolean;
    FPieceStringFormat: TPieceStringFormat;
    FBooleanFormat: TBooleanFormat;
    // Generics conversion functions
    // These will all break horribly if you do not do a typecheck before calling
    class function GenericToInt64(const AValue): Int64;
    class function GenericToShortInt(const AValue): ShortInt;
    class function GenericToByte(const AValue): Byte;
    class function GenericToWord(const AValue): Word;
    class function GenericToSmallInt(const AValue): SmallInt;
    class function GenericToLongInt(const AValue): LongInt;
    class function GenericToLongWord(const AValue): LongWord;
    class function GenericToCurrency(const AValue): Currency;
    class function GenericToExtended(const AValue): Extended;
    class function GenericToDouble(const AValue): Double;
    class function GenericToSingle(const AValue): Single;
    class function GenericToboolean(const AValue): Boolean;
    class function GenericToShortString(const AValue): ShortString;
    class function GenericToAnsiString(const AValue): AnsiString;
    class function GenericToUnicodeString(const AValue): UnicodeString;
    class function GenericToWideString(const AValue): WideString;
    class function GenericToAnsiChar(const AValue): AnsiChar;
    class function GenericToWideChar(const AValue): WideChar;
  protected
    // Getters that are implemented with path parameters as public methods
    function AsString(AJSONValue: TJSONValue): string; overload;
    function AsBoolean(AJSONValue: TJSONValue): Boolean; overload;
    function AsType<T>(AJSONValue: TJSONValue): T; overload;
    // Property Getters and Setters
    function GetData: string;
    procedure SetData(const AValue: string);
    function GetJSONValue(const APath: string): TJSONValue;
    function GetPieceStringFormat: PPieceStringFormat;
    procedure SetPieceStringFormat(const Value: PPieceStringFormat);
    function GetBooleanFormat: PBooleanFormat;
    procedure SetBooleanFormat(const Value: PBooleanFormat);
    // Helper class methods
    class function ParseJSONObject(const AData: string = '{}'): TJSONObject;
    class function FindValue(AJSONObj: TJSONObject; const APath: string; AJSONVal: TJSONValue = nil; ForcePath: Boolean = False): TJSONValue;
    class function StrToBool(const AValue: string; const ABooleanFormat: TBooleanFormat): Boolean; overload;
    class function StrToBool(const AValue: string; const ABooleanFormat: PBooleanFormat): Boolean; overload;
    class function BoolToStr(const AValue: Boolean; const ABooleanFormat: TBooleanFormat; AOldValue: string = ''): string; overload;
    class function BoolToStr(const AValue: Boolean; const ABooleanFormat: PBooleanFormat; AOldValue: string = ''): string; overload;
    class function StrToIORNetMult(AString: string; PageSize: integer; const HDRDelimiter: string = DefaultPairDelimiter): TIORNetMults;
  public
    // Main functionality
    constructor Create(ADataObject: TJSONObject; OwnsDataObject: Boolean = True); overload;
    constructor Create(const AData: string = '{}'); overload;
    destructor Destroy; override;
    function ToString: string; overload; override;
    function ToString(LineSize: integer): string; reintroduce; overload;
    property DataObject: TJSONObject read FDataObject;
    property Data: string read GetData write SetData;
    property JSONValue[const APath: string]: TJSONValue read GetJSONValue;
    property EnumeratedIsString: Boolean read FEnumeratedIsString write FEnumeratedIsString;
    property PieceStringFormat: PPieceStringFormat read GetPieceStringFormat write SetPieceStringFormat;
    property BooleanFormat: PBooleanFormat read GetBooleanFormat write SetBooleanFormat;
    // Getter functions
    function AsType<T>(const APath: string): T; overload; // Use this to get a value
    function AsType<T>(const APath: string; out AJSONValue: TJSONValue): T; overload;
    function TryAsType<T>(const APath: string; out AValue: T): Boolean; // Use this to get a value (and also pass in a default value)returned in AValue) but not an error
    function AsTypeDef<T>(const APath: string; const Def: T): T; // Use this to get a value and also pass in a default value
    function AsString(const APath: string): string; overload;
    function AsBoolean(const APath: string): Boolean; overload;
    // Setter functions
    procedure SetAsType<T>(const APath: string; const AValue: T); // Use this to set a value
    procedure SetAsInteger(const APath: string; const AValue: Int64);
    procedure SetAsInt64(const APath: string; const AValue: Int64);
    procedure SetAsCurrency(const APath: string; const AValue: Currency);
    procedure SetAsFloat(const APath: string; const AValue: Extended);
    procedure SetAsExtended(const APath: string; const AValue: Extended);
    procedure SetAsChar(const APath: string; const AValue: Char);
    procedure SetAsString(const APath: string; const AValue: string; IsPieceString: Boolean = False);
    procedure SetAsBoolean(const APath: string; const AValue: Boolean);
    procedure SetAsEnumerated<T>(const APath: string; const AValue: T);
  public
    // Export to VistA format
    function ToIORNetMults(LineSize, PageSize: integer): TIORNetMults;
  end;

implementation

uses
  System.Generics.Collections,
  System.TypInfo,
  System.SysUtils,
  System.SysConst,
  System.JSONConsts,
  System.Rtti;

constructor TJSONParameters.Create(ADataObject: TJSONObject; OwnsDataObject: Boolean = True);
// ADataObject: A JSONObject representing the JSONParameters
// OwnsDataObject: If True, TJSONParameters will become responsible for
//   destroying ADataObject
begin
  inherited Create;
  if not Assigned(ADataObject) then raise Exception.Create('ADataObject not Assigned');
  FOwnsDataObject := OwnsDataObject;
  FDataObject := ADataObject;
  PieceStringFormat.ObjectDelimiter := DefaultObjectDelimiter;
  PieceStringFormat.PairDelimiter := DefaultPairDelimiter;
  PieceStringFormat.NameValueSeparator := DefaultNameValueSeparator;
  BooleanFormat.TrueStrings := ['true', 'TRUE', 'True', 'yes', 'YES', 'Yes', 't', 'T', 'y', 'Y', '1'];
  BooleanFormat.FalseStrings := ['false', 'FALSE', 'False', 'no', 'NO', 'No', 'f', 'F', 'n', 'N', '0'];
end;

constructor TJSONParameters.Create(const AData: string = '{}');
// AData: A JSON string representing the JSONParameters, which will be parsed
begin
  Create(ParseJSONObject(AData), True);
end;

destructor TJSONParameters.Destroy;
begin
  if FOwnsDataObject then FreeAndNil(FDataObject);
  inherited;
end;

class function TJSONParameters.ParseJSONObject(const AData: string = '{}'): TJSONObject;
begin
  if Trim(AData) = '' then
  begin
    Result := TJSONObject.Create;
  end else begin
    Result := TJSONObject.ParseJSONValue(StringReplace(AData, #13#10, '', [rfReplaceAll, rfIgnoreCase])) as TJSONObject;
  end;
  if not Assigned(Result) then raise Exception.Create('Unable to parse JSON');
end;

class function TJSONParameters.GenericToAnsiString(const AValue): AnsiString;
begin
  Result := AnsiString(AValue);
end;

class function TJSONParameters.GenericToboolean(const AValue): Boolean;
begin
  Result := Boolean(AValue);
end;

class function TJSONParameters.GenericToAnsiChar(const AValue): AnsiChar;
begin
  Result := AnsiChar(AValue);
end;

class function TJSONParameters.GenericToCurrency(const AValue): Currency;
begin
  Result := Currency(AValue);
end;

class function TJSONParameters.GenericToDouble(const AValue): Double;
begin
  Result := Double(AValue);
end;

class function TJSONParameters.GenericToExtended(const AValue): Extended;
begin
  Result := Extended(AValue);
end;

class function TJSONParameters.GenericToInt64(const AValue): Int64;
begin
  Result := Int64(AValue);
end;

class function TJSONParameters.GenericToShortInt(const AValue): ShortInt;
begin
  Result := ShortInt(AValue);
end;

class function TJSONParameters.GenericToByte(const AValue): Byte;
begin
  Result := Byte(AValue);
end;

class function TJSONParameters.GenericToWord(const AValue): Word;
begin
  Result := Word(AValue);
end;

class function TJSONParameters.GenericToSmallInt(const AValue): SmallInt;
begin
  Result := SmallInt(AValue);
end;

class function TJSONParameters.GenericToLongInt(const AValue): LongInt;
begin
  Result := LongInt(AValue);
end;

class function TJSONParameters.GenericToLongWord(const AValue): LongWord;
begin
  Result := LongWord(AValue);
end;

class function TJSONParameters.GenericToShortString(const AValue): ShortString;
begin
  Result := ShortString(AValue);
end;

class function TJSONParameters.GenericToSingle(const AValue): Single;
begin
  Result := Single(AValue);
end;

class function TJSONParameters.GenericToUnicodeString(const AValue): UnicodeString;
begin
  Result := UnicodeString(AValue);
end;

class function TJSONParameters.GenericToWideChar(const AValue): WideChar;
begin
  Result := WideChar(AValue);
end;

class function TJSONParameters.GenericToWideString(const AValue): WideString;
begin
  Result := WideString(AValue);
end;

class function TJSONParameters.StrToBool(const AValue: string; const ABooleanFormat: TBooleanFormat): Boolean;
//Decide wether to use StrToBool for this, which allows setting the globals
//TrueBoolStr and FalseBoolStr to do the conversion
var
  S: string;
  I: Int64;
  E: Extended;
begin
  for S in ABooleanFormat.TrueStrings do
  begin
    if SameText(S, AValue) then Exit(True);
  end;
  for S in ABooleanFormat.FalseStrings do
  begin
    if SameText(S, AValue) then Exit(False);
  end;
  if TryStrToFloat(AValue, E) then Exit(E = 0);
  if TryStrToInt64(AValue, I) then Exit(I = 0);
  raise EConvertError.CreateFmt(SInvalidboolean, [AValue]);
end;

class function TJSONParameters.StrToBool(const AValue: string; const ABooleanFormat: PBooleanFormat): Boolean;
begin
  Result := StrToBool(AValue, ABooleanFormat^);
end;

class function TJSONParameters.BoolToStr(const AValue: Boolean; const ABooleanFormat: TBooleanFormat; AOldValue: string = ''): string;

  function DefaultStr: string;
  begin
    Result := GetEnumName(TypeInfo(Boolean), Ord(AValue));
  end;

var
  AOldValueB: Boolean;
  I, Found: integer;
begin
  if AOldValue = '' then Exit(DefaultStr);
  if high(ABooleanFormat.TrueStrings) <> high(ABooleanFormat.FalseStrings) then Exit(DefaultStr);

  try
    AOldValueB := Self.StrToBool(AOldValue, ABooleanFormat);
  except
    Exit(DefaultStr);
  end;
  if AOldValueB = AValue then Exit(AOldValue);

  // When we get here, AOldValueB <> AValue and we found a match in ABooleanFormat
  // We first look for an exact match. If we don't find that, then we look for a
  // case-insensitive match
  Found := -1;
  for I := low(ABooleanFormat.TrueStrings) to high(ABooleanFormat.TrueStrings) do
  begin
    if AOldValueB then
    begin
      if AOldValue = ABooleanFormat.TrueStrings[I] then Exit(ABooleanFormat.FalseStrings[I]);
      if SameText(AOldValue, ABooleanFormat.TrueStrings[I]) then Found := I;
    end else begin
      if AOldValue = ABooleanFormat.FalseStrings[I] then Exit(ABooleanFormat.TrueStrings[I]);
      if SameText(AOldValue, ABooleanFormat.FalseStrings[I]) then Found := I;
    end;
    if Found >= 0 then
    begin // this SHOULD always be the case
      if AOldValueB then Exit(ABooleanFormat.FalseStrings[Found])
      else Exit(ABooleanFormat.TrueStrings[Found]);
    end;
  end;

  Result := DefaultStr; // We should NEVER get here.
end;

class function TJSONParameters.BoolToStr(const AValue: Boolean; const ABooleanFormat: PBooleanFormat; AOldValue: string = ''): string;
begin
  Result := BoolToStr(AValue, ABooleanFormat^, AOldValue);
end;

class function TJSONParameters.FindValue(AJSONObj: TJSONObject; const APath: string; AJSONVal: TJSONValue = nil; ForcePath: Boolean = False): TJSONValue;
// This function returns the JSONValue at APath. If a AJSONVal is passed in then
//   then the value at APath will be replaced, if possible. If ForcePath is set
//   to True then the path will be created is AJSONVal <> nil.
// AJSONObject = root object on which to apply APath.
// APath = a path like in TJSONObject.FindValue.
// AJSONVal = the value to be inserted at APath. If nil, no value will be
//   inserted and the value that is there will be returned.
// ForcePath = if the path does not exist, force-create it (analogous to
//   ForceDirectories). If AJSONVal = nil then this parameter has no effect.
// Result = the value at APath after FindValue completes.
var
  I: integer;
  CurrentValue: TJSONValue;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  JSONElements: TList<TJSONValue>;
  JSONPair: TJSONPair;
  CurrentPath, NextPath: TJSONPathParser; //TJSONPathParser = record
begin
  ForcePath := ForcePath and Assigned(AJSONVal);
  if (not Assigned(AJSONObj)) or (APath = '') then Exit(nil);
  CurrentValue := AJSONObj;
  NextPath := TJSONPathParser.Create(APath);
  CurrentPath := NextPath;
  NextPath.NextToken;
  while not CurrentPath.IsEof do
  begin
    CurrentPath := NextPath;
    NextPath.NextToken;
    case CurrentPath.Token of
      TJSONPathParser.TToken.Name:
        begin
          if CurrentValue.ClassType <> TJSONObject then Exit(nil);
          JSONObject := TJSONObject(CurrentValue);
          CurrentValue := JSONObject.Values[CurrentPath.TokenName];
          if Assigned(CurrentValue) then
          begin
            case NextPath.Token of
              TJSONPathParser.TToken.Eof: if Assigned(AJSONVal) then
                begin
                  // Replace the value at the path with AJSONVal
                  JSONPair := JSONObject.Get(CurrentPath.TokenName);
                  JSONPair.JSONValue := AJSONVal;
                  CurrentValue := AJSONVal;
                end;
            end;
          end else begin
            if not ForcePath then Exit(nil);
            case NextPath.Token of
              TJSONPathParser.TToken.Name: CurrentValue := TJSONObject.Create;
              TJSONPathParser.TToken.ArrayIndex: CurrentValue := TJSONArray.Create;
              TJSONPathParser.TToken.Eof: CurrentValue := AJSONVal;
            end;
            if not Assigned(CurrentValue) then Exit(nil);
            try
              JSONPair := TJSONPair.Create(CurrentPath.TokenName, CurrentValue);
              try
                JSONObject.AddPair(JSONPair);
              except
                FreeAndNil(JSONPair);
                CurrentValue := nil; // because CurrentPair owned it
                raise;
              end;
            except
              if CurrentValue <> AJSONVal then FreeAndNil(CurrentValue);
              raise;
            end;
          end;
        end;

      TJSONPathParser.TToken.ArrayIndex:
        begin
          if CurrentValue.ClassType <> TJSONArray then Exit(nil);
          JSONArray := TJSONArray(CurrentValue);
          if CurrentPath.TokenArrayIndex < JSONArray.Count then
          begin

            CurrentValue := JSONArray.Items[CurrentPath.TokenArrayIndex];
            case NextPath.Token of
              TJSONPathParser.TToken.Eof: if Assigned(AJSONVal) then
                begin
                  // Replace the value at the path with AJSONVal
                  JSONElements := TList<TJSONValue>.Create;
                  try
                    for I := 0 to JSONArray.Count - 1 do
                    begin
                      if I = CurrentPath.TokenArrayIndex then JSONElements.Add(AJSONVal)
                      else JSONElements.Add(JSONArray.Items[I]);
                    end;
                  except
                    FreeAndNil(JSONElements);
                    raise;
                  end;
                  try
                    for I := JSONArray.Count - 1 downto 0 do
                    begin
                      // if we do not do this, JSONArray will free the elements for us.
                      if I <> CurrentPath.TokenArrayIndex then JSONArray.Remove(I);
                    end;
                  finally
                    // if we get here because of an error we may have serious issues
                    JSONArray.SetElements(JSONElements);
                  end;
                  CurrentValue := AJSONVal;
                end;
            end;

          end
          else if CurrentPath.TokenArrayIndex = TJSONArray(CurrentValue).Count then
          begin
            if not ForcePath then Exit(nil);
            //We add to the end of the array, exactly 1 item!
            case NextPath.Token of
              TJSONPathParser.TToken.Name: CurrentValue := TJSONObject.Create;
              TJSONPathParser.TToken.ArrayIndex: CurrentValue := TJSONArray.Create;
              TJSONPathParser.TToken.Eof: CurrentValue := AJSONVal;
            end;
            if not Assigned(CurrentValue) then Exit(nil);
            try
              JSONArray.AddElement(CurrentValue);
            except
              if CurrentValue <> AJSONVal then FreeAndNil(CurrentValue);
              raise;
            end;
          end
          else Exit(nil); // Skipping indexes in arrays is not allowed.
        end;

      TJSONPathParser.TToken.Error, TJSONPathParser.TToken.Undefined: Exit(nil);
      TJSONPathParser.TToken.Eof:;
    end;
  end;
  Result := CurrentValue;
end;

function TJSONParameters.ToString: string;
begin
  Result := DataObject.Format(2);
end;

function TJSONParameters.ToString(LineSize: integer): string;
// This returns JSON Data as a string.
var
  I, Lines: integer;
begin
  if LineSize <= 0 then
  begin
    Result := ToString;
  end else begin
    Result := DataObject.ToJSON;
    Lines := (Length(Result) - 1) div LineSize;
    for I := Lines downto 1 do
    begin
      Insert(#13#10, Result, I * LineSize + 1);
    end;
  end;
end;

function TJSONParameters.GetData: string;
// This returns JSON Data as a readable string.
begin
  Result := ToString;
end;

procedure TJSONParameters.SetData(const AValue: string);
// This should accept string Data from Vista, as well as regular JSON. If these
// are incompatible, we should make a setter for each (but presumably we are
// just removing CRLF from the VISTA string to get to the JSON, which is what is
// implemented here now.)
var
  JSONObj: TJSONObject;
begin
  JSONObj := ParseJSONObject(AValue);
  try
    if FOwnsDataObject then FreeAndNil(FDataObject);
    FDataObject := JSONObj;
  except
    FreeAndNil(JSONObj);
    raise;
  end;
end;

function TJSONParameters.GetPieceStringFormat: PPieceStringFormat;
begin
  Result := @FPieceStringFormat;
end;

procedure TJSONParameters.SetPieceStringFormat(const Value: PPieceStringFormat);
begin
  FPieceStringFormat := Value^;
end;

function TJSONParameters.GetBooleanFormat: PBooleanFormat;
begin
  Result := @FBooleanFormat;
end;

procedure TJSONParameters.SetBooleanFormat(const Value: PBooleanFormat);
begin
  FBooleanFormat := Value^;
end;

function TJSONParameters.GetJSONValue(const APath: string): TJSONValue;
// Retrieve a JSONValue from the internal FData object. Returns nil
//   if any part is wrong (even if FData is nil!)
// APath = JSON Path as used in TJSONObject.FindValue, so the name
//   parameter cannot contain periods (you can apply special formatting is you
//   do need a period, see Delphi help)
begin
  Result := FindValue(DataObject, APath);
end;

function TJSONParameters.AsString(AJSONValue: TJSONValue): string;
// Strings get special formatting. The return value of this function can be
//   loaded as the Text parameter of a StringList if desired.
// AJSONValue: The value to convert to a string
// Result: The retrieved value
var
  S: string;
  BJSONValue: TJSONValue;
  AJSONPair: TJSONPair;
begin
  if not Assigned(AJSONValue) then
  begin
    Result := '';
  end else begin
    if not(AJSONValue is TJSONArray) then
    begin
      try
        Result := AJSONValue.AsType<string>;
      except
        Result := '';
      end;
    end else begin
      Result := '';
      for BJSONValue in TJSONArray(AJSONValue) do
      begin
        if BJSONValue is TJSONObject then
        begin
          S := '';
          for AJSONPair in TJSONObject(BJSONValue) do
          begin
            if S <> '' then S := S + PieceStringFormat.PairDelimiter;
            S := Format('%s%s%s%s', [S, AJSONPair.JsonString.Value, PieceStringFormat.NameValueSeparator, AJSONPair.JSONValue.AsType<string>]);
          end;
          if Result <> '' then Result := Result + PieceStringFormat.ObjectDelimiter;
          Result := Result + S;
        end;
      end;
    end;
  end;
end;

function TJSONParameters.AsString(const APath: string): string;
// Return the String at the APath location
// APath: The location of the string
// Result: The retrieved value
var
  AJSONValue: TJSONValue;
begin
  AJSONValue := JSONValue[APath];
  Result := AsString(AJSONValue);
end;

function TJSONParameters.AsBoolean(AJSONValue: TJSONValue): Boolean;
// Special boolean handling to ensure all "boolean words" are correctly
//   interpreted as True or False (Example: "Yes" is now interpreted as True)
// AJSONValue: The value to convert to a boolean
// Result: The retrieved value
begin
  try
    // Using AJSONValue.AsType<string> because we do not want special string
    // handling for this!
    Result := StrToBool(AJSONValue.AsType<string>, BooleanFormat);
  except
    on EJSONException do
    begin
      // This ensures the proper boolean error, instead of a string error
      raise EJSONException.CreateResFmt(@SCannotConvertJSONValueToType, [AJSONValue.ClassName, 'boolean']);
    end
    else
      raise;
  end;
end;

function TJSONParameters.AsBoolean(const APath: string): Boolean;
// Return the boolean at the APath location
// APath: The location of the boolean
// Result: The retrieved value
var
  AJSONValue: TJSONValue;
begin
  AJSONValue := JSONValue[APath];
  Result := AsBoolean(AJSONValue);
end;

function TJSONParameters.AsType<T>(AJSONValue: TJSONValue): T;
// Retrieve the JSONValue from the internal FData object as the passed
//   in type.
// AJSONValue: The element that represents the value
// Result: The retrieved value
begin
  case GetTypeKind(T) of
    //Special formatting for strings
    tkString: PShortString(@Result)^ := ShortString(AsString(AJSONValue));
    tkLString: PAnsiString(@Result)^ := AnsiString(AsString(AJSONValue));
    tkUString: PUnicodeString(@Result)^ := AsString(AJSONValue);
    tkWString: PWideString(@Result)^ := AsString(AJSONValue);
    tkEnumeration:
      begin
        if SameText(GetTypeName(TypeInfo(T)), 'boolean') then
        begin
          //Special interpretation for booleans
          PBoolean(@Result)^ := AsBoolean(AJSONValue);
        end else begin
          Result := AJSONValue.AsType<T>;
        end;
      end;
  else
    begin
      Result := AJSONValue.AsType<T>;
    end;
  end;
end;

function TJSONParameters.TryAsType<T>(const APath: string; out AValue: T): Boolean;
// Try to retrieve the JSONValue from the internal FData object as the passed
//   in type. Do not raise an error and intercept those that occur
// APath: The location of the value
// AValue: The retrieved value
// Result: Did retrieving succeed? If Result = False, AValue does not contain
//   valid data and should not be accessed.
var
  S: string;
  AJSONValue: TJSONValue;
begin
  try
    AJSONValue := JSONValue[APath];
    if not Assigned(AJSONValue) then
    begin
      Result := False;
    end else begin
      AValue := AsType<T>(AJSONValue);
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TJSONParameters.AsType<T>(const APath: string; out AJSONValue: TJSONValue): T;
// Retrieve the JSONValue from the internal FData object as the passed in type
// APath: The location of the value
// AJSONValue: The JSONValue object at APath (still owned by FDataObject!)
// Result: The retrieved value
var
  S: string;
begin
  AJSONValue := JSONValue[APath];
  if not Assigned(AJSONValue) then
  begin
    raise Exception.CreateFmt('%s does not exist', [APath]);
  end else begin
    Result := AsType<T>(AJSONValue);
  end;
end;

function TJSONParameters.AsType<T>(const APath: string): T;
var
  AJSONValue: TJSONValue;
begin
  Result := AsType<T>(APath, AJSONValue);
end;

function TJSONParameters.AsTypeDef<T>(const APath: string; const Def: T): T;
// Try to retrieve the JSONValue from the internal FData object as the passed
//   in type. If this fail, return ADef.
// APath: The location of the value
// Def: The Default value
// Result: The retrieved value
var
  Success: Boolean;
begin
  Success := TryAsType<T>(APath, Result);
  if not Success then Result := Def;
end;

procedure TJSONParameters.SetAsInt64(const APath: string; const AValue: Int64);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
var
  OldJSONValue, NewJSONValue: TJSONValue;
begin
  NewJSONValue := nil;
  OldJSONValue := FindValue(DataObject, APath);
  try
    if Assigned(OldJSONValue) then
    begin
      // If the pair exists we will replace it with the passed in value as the same type
      if OldJSONValue is TJSONArray then raise Exception.Create('Unable to cast AValue to a JSONArray')
      else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
      else if OldJSONValue is TJSONBool then NewJSONValue := TJSONBool.Create(AValue <> 0)
      else if OldJSONValue is TJSONNumber then NewJSONValue := TJSONNumber.Create(AValue)
      else if OldJSONValue is TJSONString then NewJSONValue := TJSONString.Create(AValue.ToString)
      else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
    end else begin
      // The JSON pair does NOT exist at the path.
      NewJSONValue := TJSONNumber.Create(AValue);
    end;
    if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set Int64 value');
  except
    FreeAndNil(NewJSONValue);
    raise;
  end;
end;

procedure TJSONParameters.SetAsInteger(const APath: string; const AValue: Int64);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
begin
  SetAsInt64(APath, AValue);
end;

procedure TJSONParameters.SetAsExtended(const APath: string; const AValue: Extended);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
var
  OldJSONValue, NewJSONValue: TJSONValue;
begin
  NewJSONValue := nil;
  OldJSONValue := FindValue(DataObject, APath);
  try
    if Assigned(OldJSONValue) then
    begin
      // If the pair exists we will replace it with the passed in value as the same type
      if OldJSONValue is TJSONArray then raise Exception.Create('Unable to cast AValue to a JSONArray')
      else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
      else if OldJSONValue is TJSONBool then NewJSONValue := TJSONBool.Create(AValue <> 0)
      else if OldJSONValue is TJSONNumber then NewJSONValue := TJSONNumber.Create(AValue)
      else if OldJSONValue is TJSONString then NewJSONValue := TJSONString.Create(FloatToStr(AValue))
      else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
    end else begin
      // The JSON pair does NOT exist at the path.
      NewJSONValue := TJSONNumber.Create(AValue);
    end;
    if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set Extended value');
  except
    FreeAndNil(NewJSONValue);
    raise;
  end;
end;

procedure TJSONParameters.SetAsFloat(const APath: string; const AValue: Extended);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
begin
  SetAsExtended(APath, AValue);
end;

procedure TJSONParameters.SetAsCurrency(const APath: string; const AValue: Currency);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
var
  OldJSONValue, NewJSONValue: TJSONValue;
begin
  NewJSONValue := nil;
  OldJSONValue := FindValue(DataObject, APath);
  try
    if Assigned(OldJSONValue) then
    begin
      // If the pair exists we will replace it with the passed in value as the same type
      if OldJSONValue is TJSONArray then raise Exception.Create('Unable to cast AValue to a JSONArray')
      else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
      else if OldJSONValue is TJSONBool then NewJSONValue := TJSONBool.Create(AValue <> 0)
      else if OldJSONValue is TJSONNumber then NewJSONValue := TJSONNumber.Create(AValue)
      else if OldJSONValue is TJSONString then NewJSONValue := TJSONString.Create(CurrToStr(AValue))
      else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
    end else begin
      // The JSON pair does NOT exist at the path.
      NewJSONValue := TJSONNumber.Create(AValue);
    end;
    if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set Currency value');
  except
    FreeAndNil(NewJSONValue);
    raise;
  end;
end;

procedure TJSONParameters.SetAsBoolean(const APath: string; const AValue: Boolean);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
var
  OldJSONValue, NewJSONValue: TJSONValue;

begin
  NewJSONValue := nil;
  OldJSONValue := FindValue(DataObject, APath);
  try
    if Assigned(OldJSONValue) then
    begin
      // If the pair exists we will replace it with the passed in value as the same type
      if OldJSONValue is TJSONArray then raise Exception.Create('Unable to cast AValue to a JSONArray')
      else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
      else if OldJSONValue is TJSONBool then NewJSONValue := TJSONBool.Create(AValue)
      else if OldJSONValue is TJSONNumber then NewJSONValue := TJSONNumber.Create(Ord(AValue))
      else if OldJSONValue is TJSONString then
      begin
        // When setting a boolean as a string, we try and match up with the
        // existing value. This is done by taking the same index from the array.
        // so if the current value matches TrueStrings[3] and we need to set to
        // false. we replace with FalseStrings[3].
        NewJSONValue := TJSONString.Create(BoolToStr(AValue, BooleanFormat, OldJSONValue.AsType<string>));
      end
      else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
    end else begin
      // The JSON pair does NOT exist at the path.
      NewJSONValue := TJSONBool.Create(AValue);
    end;
    if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set boolean value');
  except
    FreeAndNil(NewJSONValue);
    raise;
  end;
end;

procedure TJSONParameters.SetAsChar(const APath: string; const AValue: Char);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
var
  E: Extended;
  I: Int64;
  OldJSONValue, NewJSONValue: TJSONValue;
begin
  NewJSONValue := nil;
  OldJSONValue := FindValue(DataObject, APath);
  try
    if Assigned(OldJSONValue) then
    begin
      // If the pair exists we will replace it with the passed in value as the same type
      if OldJSONValue is TJSONArray then raise Exception.Create('Unable to cast AValue to a JSONArray')
      else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
      else if OldJSONValue is TJSONBool then NewJSONValue := TJSONBool.Create(Self.StrToBool(AValue, BooleanFormat))
      else if OldJSONValue is TJSONNumber then
      begin
        if TryStrToFloat(AValue, E) or TryStrToInt64(AValue, I) then NewJSONValue := TJSONNumber.Create(AValue)
        else raise Exception.Create('Unable to cast AValue to a number');
      end
      else if OldJSONValue is TJSONString then NewJSONValue := TJSONString.Create(AValue)
      else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
    end else begin
      // The JSON pair does NOT exist at the path.
      NewJSONValue := TJSONString.Create(AValue);
    end;
    if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set string value');
  except
    FreeAndNil(NewJSONValue);
    raise;
  end;
end;

procedure TJSONParameters.SetAsString(const APath: string; const AValue: string; IsPieceString: Boolean = False);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
// IsPieceString: If True, the creation of the special PieceString structure is
//   enforced. IsPieceString is only relevant if the path needs to be
//   force-created! If it already exists then IsPieceString is ignored, and the
//   existing JSON type at APath is used to determine how to save AValue.

  function CreateJSONPieceStringArray(const AValue: string): TJSONArray;
  // The very specific CPRS piece format
  // In the string:
  //   The string represents a JSON Array
  //   each line (CRLF separated) is a JSON object
  //   each piece is delimited on a line by a caret (^)
  //   each piece is a name value pair with a = in between
  //   The value of a piece is always a string
  // For Example, the string
  //   'name=natspeak.exe^Enabled=-1'#13#10'name=Chris.exe^Enabled=1'
  // Would become the JSON
  //   [{"name":"natspeak.exe","Enabled":"-1"}, {"name":"Chris.exe","Enabled":"1"}]
  // An empty AValue ('') generates an empty array
  // An empty line is ignored
  // A piece without a "=" is interpreted as a name with an empty string as value
  // A piece with more than one = is interpreted as name = part before first "=",
  //   the rest is all the value.
  var
    I, J, K: integer;
    S: string;
    JSONObject: TJSONObject;
    JSONPair: TJSONPair;
    Objects, Pieces, Pair: TArray<string>;
  begin
    Objects := AValue.Split([PieceStringFormat.ObjectDelimiter]);
    Result := TJSONArray.Create;
    try
      for I := low(Objects) to high(Objects) do
      begin
        JSONObject := TJSONObject.Create;
        try
          Pieces := Objects[I].Split([PieceStringFormat.PairDelimiter]);
          for J := low(Pieces) to high(Pieces) do
          begin
            Pair := Pieces[J].Split([PieceStringFormat.NameValueSeparator]);
            try
              case Length(Pair) of
                0: JSONPair := nil;
                1: JSONPair := TJSONPair.Create(Pair[0], '');
                2: JSONPair := TJSONPair.Create(Pair[0], Pair[1]);
              else
                begin
                  S := Pair[1];
                  for K := low(Pair) + 2 to high(Pair) do S := Format('%s=%s', [S, Pair[K]]);
                  JSONPair := TJSONPair.Create(Pair[0], S);
                end;
              end;
              if Assigned(JSONPair) then JSONObject.AddPair(JSONPair);
            except
              FreeAndNil(JSONPair);
              raise;
            end;
          end;
          Result.Add(JSONObject);
        except
          FreeAndNil(JSONObject);
          raise;
        end;
      end;
    except
      FreeAndNil(Result);
      raise;
    end;
  end;

var
  E: Extended;
  I: Int64;
  OldJSONValue, NewJSONValue: TJSONValue;
begin
  NewJSONValue := nil;
  OldJSONValue := FindValue(DataObject, APath);
  try
    if Assigned(OldJSONValue) then
    begin
      // If the pair exists we will replace it with the passed in value as the same type
      if OldJSONValue is TJSONArray then NewJSONValue := CreateJSONPieceStringArray(AValue)
      else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
      else if OldJSONValue is TJSONBool then NewJSONValue := TJSONBool.Create(Self.StrToBool(AValue, BooleanFormat))
      else if OldJSONValue is TJSONNumber then
      begin
        if TryStrToFloat(AValue, E) or TryStrToInt64(AValue, I) then NewJSONValue := TJSONNumber.Create(AValue)
        else raise Exception.Create('Unable to cast AValue to a number');
      end
      else if OldJSONValue is TJSONString then NewJSONValue := TJSONString.Create(AValue)
      else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
    end else begin
      // The JSON pair does NOT exist at the path.
      if IsPieceString then
      begin
        NewJSONValue := CreateJSONPieceStringArray(AValue);
      end else begin
        NewJSONValue := TJSONString.Create(AValue);
      end;
    end;
    if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set string value');
  except
    FreeAndNil(NewJSONValue);
    raise;
  end;
end;

procedure TJSONParameters.SetAsEnumerated<T>(const APath: string; const AValue: T);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
// The property EnumeratedIsString determines wether the enumerated type is
//   saved by its Ordinal Value, or by its element name (retrieved through RTTI)
//   It only has effect if the value is new. When replacing an existing value,
//   the type of the old value is used instead to determine how to save the
//   AValue.
var
  JSONPair: TJSONPair;
  OldJSONValue, NewJSONValue: TJSONValue;
  OrdinalValue: Int64;
  ATypeInfo: PTypeInfo;
  EnumName: string;
begin
  case GetTypeKind(T) of
    tkEnumeration: if SameText(GetTypeName(TypeInfo(T)), 'boolean') then
      begin
        SetAsBoolean(APath, GenericToboolean(AValue));
      end else begin
        case Sizeof(T) of
          1: OrdinalValue := GenericToByte(AValue);
          2: OrdinalValue := GenericToWord(AValue);
          4: OrdinalValue := GenericToLongWord(AValue);
        end;
        ATypeInfo := TypeInfo(T);
        if Assigned(ATypeInfo) then
        begin
          if OrdinalValue < GetTypeData(ATypeInfo).MinValue then OrdinalValue := GetTypeData(ATypeInfo).MinValue;
          if OrdinalValue > GetTypeData(ATypeInfo).MaxValue then OrdinalValue := GetTypeData(ATypeInfo).MaxValue;
          EnumName := GetEnumName(TypeInfo(T), OrdinalValue);
        end else begin
          EnumName := OrdinalValue.ToString;
        end;
        NewJSONValue := nil;
        OldJSONValue := FindValue(DataObject, APath);
        try
          if Assigned(OldJSONValue) then
          begin
            // If the pair exists we will replace it with the passed in value as the same type
            if OldJSONValue is TJSONArray then raise Exception.Create('Unable to cast AValue to a JSONArray')
            else if OldJSONValue is TJSONObject then raise Exception.Create('Unable to cast AValue to a JSONObject')
            else if OldJSONValue is TJSONBool then raise Exception.Create('Unable to cast AValue to a boolean')
            else if OldJSONValue is TJSONNumber then NewJSONValue := TJSONNumber.Create(OrdinalValue)
            else if OldJSONValue is TJSONString then NewJSONValue := TJSONString.Create(EnumName)
            else raise Exception.CreateFmt('Functionality for %s is missing', [OldJSONValue.ClassName]);
          end else begin
            // The JSON pair does NOT exist at the path.
            if EnumeratedIsString then
            begin
              NewJSONValue := TJSONNumber.Create(OrdinalValue);
            end else begin
              NewJSONValue := TJSONString.Create(GetEnumName(TypeInfo(T), OrdinalValue));
            end;
          end;
          if not Assigned(FindValue(DataObject, APath, NewJSONValue, True)) then raise Exception.Create('Unable to set enumerated type');
        except
          FreeAndNil(NewJSONValue);
          raise;
        end;
      end;
  else raise Exception.Create('AValue is not an enumerated type');
  end;
end;

procedure TJSONParameters.SetAsType<T>(const APath: string; const AValue: T);
// Set the value at APath to AValue. Create a new node if there is not one.
// APath: The location of the value
// AValue: The value that should be set
//
// Use the special type "PieceString" to force PieceString structure creation (
//   an array containg objects with name\value pairs) on saving a new
//   PieceString (otherwise you will just save the string as a regular string
//   value.)
// Example:
//   SystemParameters.SetAsType<PieceString>('CopyPaste.ExcludeApps', S);
var
  JSONPair: TJSONPair;
  OldJSONValue, NewJSONValue: TJSONValue;
  S: string;
  B: Boolean;
  ATypeInfo: PTypeInfo;
begin
  case GetTypeKind(T) of
    tkEnumeration: SetAsEnumerated<T>(APath, AValue);
    tkInteger: case GetTypeData(TypeInfo(T))^.OrdType of
        otSByte: SetAsInt64(APath, GenericToShortInt(AValue));
        otUByte: SetAsInt64(APath, GenericToByte(AValue));
        otSWord: SetAsInt64(APath, GenericToSmallInt(AValue));
        otUWord: SetAsInt64(APath, GenericToWord(AValue));
        otSLong: SetAsInt64(APath, GenericToLongInt(AValue));
        otULong: SetAsInt64(APath, GenericToLongWord(AValue));
      else raise Exception.CreateFmt('Functionality for %s is missing', [GetTypeName(TypeInfo(T))]);
      end;
    tkInt64: SetAsInt64(APath, GenericToInt64(AValue));
    tkFloat:
      begin
        ATypeInfo := TypeInfo(T);
        if not Assigned(ATypeInfo) then raise Exception.Create('Functionality for Real48 is missing');
        case GetTypeData(ATypeInfo)^.FloatType of
          ftSingle: SetAsExtended(APath, GenericToSingle(AValue));
          ftDouble: SetAsExtended(APath, GenericToDouble(AValue));
          ftExtended: SetAsExtended(APath, GenericToExtended(AValue));
          ftCurr: SetAsCurrency(APath, GenericToCurrency(AValue));
        else raise Exception.CreateFmt('Functionality for %s is missing', [GetTypeName(ATypeInfo)]);
        end;
      end;
    tkChar: SetAsChar(APath, Char(GenericToAnsiChar(AValue)));
    tkWChar: SetAsChar(APath, GenericToWideChar(AValue));
    tkString: SetAsString(APath, string(GenericToShortString(AValue)));
    tkLString: SetAsString(APath, string(GenericToAnsiString(AValue)));
    tkUString:
      begin
        ATypeInfo := TypeInfo(T);
        if Assigned(ATypeInfo) and SameText(GetTypeName(ATypeInfo), 'TPieceString') then
        begin
          SetAsString(APath, GenericToUnicodeString(AValue), True);
        end else begin
          SetAsString(APath, GenericToUnicodeString(AValue));
        end;
      end;
    tkWString: SetAsString(APath, GenericToWideString(AValue));
  else raise Exception.CreateFmt('Functionality for %s is missing', [GetTypeName(TypeInfo(T))]);
  end;
end;

class function TJSONParameters.StrToIORNetMult(AString: string; PageSize: integer; const HDRDelimiter: string = DefaultPairDelimiter): TIORNetMults;
// This function generates an array of IORNetMult interfaces. They can be sent
// to VistA with calls to
//   CallVistA('VistAEndPoint', [AIEN, AIORNetMult, 0], AReturn);
// for each AIORNetMult interface in the array. See rTIU.SetText for how CPRS
// does this for notes. Remember that in Delphi, interfaces ARE reference
// counted.
//
// AString: The string to be converted
// PageSize: The number of lines per page
// HDRDelimiter: The delimiter used in the HDR Subscript element at the
//   bottom of each page.
// Result: An array of IORNetMult interfaces.
var
  I, Pages, Page, PageStart, PageEnd: integer;
  StringList: TStringList;
begin
  if PageSize <= 0 then raise Exception.Create('PageSize must be > 0');
  StringList := TStringList.Create;
  try
    StringList.Text := AString;
    Pages := (StringList.Count div PageSize);
    if (StringList.Count mod PageSize) > 0 then Inc(Pages);
    SetLength(Result, Pages);
    for Page := 0 to Pages - 1 do
    begin
      if not NewORNetMult(Result[Page]) then raise Exception.Create('Call to NewORNetMult failed');
      PageStart := Page * PageSize;
      PageEnd := (Page + 1) * PageSize - 1;
      if PageEnd >= StringList.Count then PageEnd := StringList.Count - 1;
      for I := PageStart to PageEnd do
      begin
        Result[Page].AddSubscript(['TEXT', I + 1, 0], StringList[I]);
      end;
      Result[Page].AddSubscript('HDR', Format('%d%s%d', [Page + 1, HDRDelimiter, Pages]));
    end;
  finally
    FreeAndNil(StringList);
  end;
end;

function TJSONParameters.ToIORNetMults(LineSize, PageSize: integer): TIORNetMults;
// This function generates an array of IORNetMult interfaces. They can be sent
// to VistA with calls to
//   CallVistA('VistAEndPoint', [AIEN, AIORNetMult, 0], AReturn);
// for each AIORNetMult interface in the array. See rTIU.SetText for how CPRS
// does this for notes.
//
// LineSize: The number of characters per line (of JSON, not including the
//   overhead that IORNetMult imposes!)
// PageSize: The number of lines per page (Of JSON, again, not including the
//   overhead that IORNetMult imposes!)
// Result: An array of IORNetMult interfaces.
begin
  Result := StrToIORNetMult(ToString(LineSize), PageSize, PieceStringFormat.PairDelimiter);
end;

end.
