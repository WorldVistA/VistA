unit oDelimitedString;
{
  ================================================================================
  *
  *       Application:  CPRS - Utility
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  A better (IMHO) way of handling delimited strings from M
  *                     as well as a way to store the strings as an object.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  System.Classes,
  System.SysUtils;

type
  TDelimitedStringDateTimeStyle = (dsdtsFileman, dsdtsSQL);
  TDelimitedStringDateTimeFormat = (dsdtfDateTime, dsdtfDateOnly, dsdtfTimeOnly);

  TDelimitedString = class(TObject)
  private
    fDelimiter: Char;
    fList: TStringList;
    fTrue: string;
    fFalse: string;
    fDateTimeStyle: TDelimitedStringDateTimeStyle;
    fDouble: double;
    fInteger: integer;

    function getFalseStr: string;
    function getTrueStr: string;
    function getCount: integer;
    function getStyle: TDelimitedStringDateTimeStyle;

    procedure setFalseStr(const aValue: string);
    procedure setTrueStr(const aValue: string);
    procedure setStyle(const aValue: TDelimitedStringDateTimeStyle);
  public
    constructor Create(aString: string; aDelimiter: Char = '^');
    destructor Destroy; override;

    function GetPiece(aIndex: integer): string; overload;
    function GetPiece(aStart: integer; aStop: integer): string; overload;
    function GetPieceAsString(aIndex: integer; aDefault: string = ''): string;
    function GetPieceAsInteger(aIndex: integer; aDefault: integer = 0): integer;
    function GetPieceAsDouble(aIndex: integer; aDefault: double = 0.0): double;
    function GetPieceAsBoolean(aIndex: integer; aDefault: boolean = False): boolean;
    function GetPieceAsFMDateTimeStr(aIndex: integer; aDefault: double = 0.0): string;
    function GetPieceAsTDateTime(aIndex: integer; aDefault: TDateTime = 0.0; aFormat: TDelimitedStringDateTimeFormat = dsdtfDateTime): TDateTime;
    function GetPieceEquals(aIndex: integer; aCompareValue: string; aCaseSensitive: boolean = True): boolean; overload;
    function GetPieceEquals(aIndex: integer; aCompareValue: integer): boolean; overload;
    function GetPieceEquals(aIndex: integer; aCompareValue: double): boolean; overload;
    function GetPieceEquals(aIndex: integer; aCompareValue: boolean): boolean; overload;
    function GetPieceIsDouble(aIndex: integer): boolean;
    function GetPieceIsInteger(aIndex: integer): boolean;
    function GetPieceIsNotNull(aIndex: integer): boolean;
    function GetPieceIsNull(aIndex: integer): boolean;
    function GetPieceIsTDateTime(aIndex: integer): boolean;

    function GetDelimitedString: string;
    function GetStringInfo: string;

    procedure SetPiece(aIndex: integer; aValue: string); overload;
    procedure SetPiece(aIndex: integer; aValue: integer); overload;
    procedure SetPiece(aIndex: integer; aValue: double; aPrecision: integer = 2); overload;
    procedure SetPiece(aIndex: integer; aValue: boolean); overload;
    procedure SetPiece(aIndex: integer; aValue: TDateTime); overload;

    property FalseStr: string read getFalseStr write setFalseStr;
    property TrueStr: string read getTrueStr write setTrueStr;
    property Style: TDelimitedStringDateTimeStyle read getStyle write setStyle;
    property Count: integer read getCount;
    property Piece[aIndex: integer]: string read GetPiece; default;
  end;

function NewDelimitedString(aString: string; aDelimiter: Char = '^'): TDelimitedString;

implementation

function NewDelimitedString(aString: string; aDelimiter: Char = '^'): TDelimitedString;
begin
  Result := TDelimitedString.Create(aString, aDelimiter);
end;

{ TDelimitedString }

constructor TDelimitedString.Create(aString: string; aDelimiter: Char = '^');
begin
  inherited Create;
  fTrue := '1';
  fFalse := '0';
  fDateTimeStyle := dsdtsFileman;
  fDelimiter := aDelimiter;
  fList := TStringList.Create;
  fList.Delimiter := aDelimiter;
  fList.StrictDelimiter := True;
  fList.DelimitedText := aString;
end;

destructor TDelimitedString.Destroy;
begin
  fList.Clear;
  FreeAndNil(fList);
  inherited;
end;

function TDelimitedString.getCount: integer;
begin
  Result := fList.Count;
end;

function TDelimitedString.GetDelimitedString: string;
begin
  Result := fList.DelimitedText;
end;

function TDelimitedString.getFalseStr: string;
begin
  Result := fFalse;
end;

function TDelimitedString.getStyle: TDelimitedStringDateTimeStyle;
begin
  Result := fDateTimeStyle;
end;

function TDelimitedString.getTrueStr: string;
begin
  Result := fTrue;
end;

procedure TDelimitedString.setFalseStr(const aValue: string);
begin
  fFalse := aValue;
end;

procedure TDelimitedString.setStyle(const aValue: TDelimitedStringDateTimeStyle);
begin
  fDateTimeStyle := aValue;
end;

procedure TDelimitedString.setTrueStr(const aValue: string);
begin
  fTrue := aValue;
end;

function TDelimitedString.GetPiece(aIndex: integer): string;
{ Does the actual 'reading' of the values - all other methods come here }
begin
  if fList.Count > 0 then
    if (aIndex <= fList.Count) and (aIndex > 0) then
      Result := fList[aIndex - 1]
    else
      Result := ''
  else
    Result := '';
end;

function TDelimitedString.GetPiece(aStart: integer; aStop: integer): string;
var
  i: integer;
begin
  Result := '';
  for i := aStart to aStop do
    begin
      Result := Result + GetPiece(i);
      if i < aStop then
        Result := Result + fDelimiter;
    end;
end;

function TDelimitedString.GetPieceAsBoolean(aIndex: integer; aDefault: boolean): boolean;
begin
  Result := CompareStr(GetPiece(aIndex), fTrue) = 0;
end;

function TDelimitedString.GetPieceAsDouble(aIndex: integer; aDefault: double): double;
begin
  Result := StrToFloatDef(GetPiece(aIndex), aDefault);
end;

function TDelimitedString.GetPieceAsFMDateTimeStr(aIndex: integer; aDefault: double = 0.0): string;
var
  aStr: string;
  aDT: TDateTime;
  YY, MM, DD: integer;
  h, m, s: integer;
begin
  if GetPieceIsNotNull(aIndex) then
    try
      aStr := FloatToStr(GetPieceAsDouble(aIndex, aDefault) + 0.0000001);

      YY := StrToIntDef(Copy(aStr, 1, 3), 0) + 1700;
      MM := StrToIntDef(Copy(aStr, 4, 2), 0);
      DD := StrToIntDef(Copy(aStr, 6, 2), 0);

      h := StrToIntDef(Copy(aStr, 9, 2), 0);
      m := StrToIntDef(Copy(aStr, 11, 2), 0);
      s := StrToIntDef(Copy(aStr, 13, 2), 0);

      aStr := 'MMM DD, YYYY';

      if (MM = 0) then
        begin
          MM := 1;
          DD := 1;
          aStr := 'YYYY';
        end
      else if (DD = 0) then
        begin
          DD := 1;
          aStr := 'MMM YYYY';
        end;

      aDT := EncodeDate(YY, MM, DD);
      if (h > 0) or (m > 0) or (s > 0) then
        begin
          aDT := aDT + EncodeTime(h, m, s, 0);
          aStr := aStr + ' @ hh:mm:ss';
        end;

      Result := FormatDateTime(aStr, aDT);
    except
      Result := '##' + GetPiece(aIndex) + '##';
    end
  else
    Result := '';
end;

function TDelimitedString.GetPieceAsInteger(aIndex, aDefault: integer): integer;
begin
  Result := StrToIntDef(GetPiece(aIndex), aDefault);
end;

function TDelimitedString.GetPieceAsString(aIndex: integer; aDefault: string): string;
begin
  Result := GetPiece(aIndex);
  if Result = '' then
    Result := aDefault;
end;

function TDelimitedString.GetPieceAsTDateTime(aIndex: integer; aDefault: TDateTime = 0.0; aFormat: TDelimitedStringDateTimeFormat = dsdtfDateTime): TDateTime;
var
  aDT: string;
  YY, MM, DD: Word;
  h, m, s: Word;
begin
  Result := aDefault;

  aDT := GetPiece(aIndex);
  if aDT = '' then
    Exit;

  case fDateTimeStyle of
    dsdtsFileman: { VA Fileman YYYMMDD.hhmmss }
      try
        aDT := FloatToStr(StrToFloat(aDT) + 0.0000001); // May need to use FORMAT HERE!!!
        YY := StrToInt(Copy(aDT, 1, 3)) + 1700;
        MM := StrToInt(Copy(aDT, 4, 2));
        DD := StrToInt(Copy(aDT, 6, 2));
        h := StrToInt(Copy(aDT, 9, 2));
        m := StrToInt(Copy(aDT, 11, 2));
        s := StrToInt(Copy(aDT, 13, 2));
        Result := EncodeDate(YY, MM, DD) + EncodeTime(h, m, s, 0);
      except
        Result := aDefault;
      end;
    dsdtsSQL: { SQL DATE TIME YYYY-MM-DD hh:mm:ss }
      try
        YY := StrToInt(Copy(aDT, 1, 4));
        MM := StrToInt(Copy(aDT, 6, 2));
        DD := StrToInt(Copy(aDT, 9, 2));
        h := StrToInt(Copy(aDT, 12, 2));
        m := StrToInt(Copy(aDT, 15, 2));
        s := StrToInt(Copy(aDT, 18, 2));
        Result := EncodeDate(YY, MM, DD) + EncodeTime(h, m, s, 0);
      except
        Result := aDefault;
      end;
  else
    Result := aDefault;
  end;
end;

function TDelimitedString.GetPieceEquals(aIndex: integer; aCompareValue: double): boolean;
var
  aPiece: double;
begin
  if GetPieceIsNotNull(aIndex) then
    begin
      aPiece := GetPieceAsDouble(aIndex, aCompareValue - 1);
      Result := aPiece = aCompareValue;
    end
  else
    Result := False;
end;

function TDelimitedString.GetPieceEquals(aIndex, aCompareValue: integer): boolean;
var
  aPiece: integer;
begin
  if GetPieceIsNotNull(aIndex) then
    begin
      aPiece := GetPieceAsInteger(aIndex, aCompareValue - 1);
      Result := aPiece = aCompareValue;
    end
  else
    Result := False;
end;

function TDelimitedString.GetPieceEquals(aIndex: integer; aCompareValue: boolean): boolean;
begin
  case aCompareValue of
    True:
      Result := (CompareStr(GetPiece(aIndex), fTrue) = 0);
    False:
      Result := (CompareStr(GetPiece(aIndex), fFalse) = 0);
  else
    Result := False;
  end;
end;

function TDelimitedString.GetPieceEquals(aIndex: integer; aCompareValue: string; aCaseSensitive: boolean = True): boolean;
var
  aPiece: string;
begin
  aPiece := GetPiece(aIndex);
  case aCaseSensitive of
    True:
      Result := (CompareStr(aPiece, aCompareValue) = 0);
    False:
      Result := (CompareText(aPiece, aCompareValue) = 0);
  else
    Result := False;
  end;
end;

function TDelimitedString.GetStringInfo: string;
var
  aLst: TStringList;
  i: integer;
begin
  aLst := TStringList.Create;
  try
    aLst.Add('Delimited String');
    aLst.Add('  String ......: ' + GetDelimitedString);
    aLst.Add('  Count .......: ' + IntToStr(fList.Count));
    aLst.Add('  Delimiter ...: ' + fDelimiter);
    aLst.Add('  True/False ..: ' + fTrue + '/' + fFalse);
    for i := 0 to fList.Count - 1 do
      aLst.Add(Format('  %2.2d:  %s', [i + 1, fList[i]]));
    Result := aLst.Text;
  finally
    FreeAndNil(aLst);
  end;
end;

procedure TDelimitedString.SetPiece(aIndex: integer; aValue: string);
{ Does the actual setting of the piece - all others convert and come here }
begin
  while fList.Count < aIndex do
    fList.Add('');
  fList[aIndex - 1] := aValue;
end;

procedure TDelimitedString.SetPiece(aIndex: integer; aValue: boolean);
begin
  if aValue then
    SetPiece(aIndex, fTrue)
  else
    SetPiece(aIndex, fFalse);
end;

procedure TDelimitedString.SetPiece(aIndex: integer; aValue: TDateTime);
var
  aFMDT: double;
  YY: Word;
  MM: Word;
  DD: Word;
  h: Word;
  m: Word;
  s: Word;
  ms: Word;
begin
  DecodeDate(aValue, YY, MM, DD);
  DecodeTime(aValue, h, m, s, ms);

  case fDateTimeStyle of
    dsdtsFileman:
      begin
        YY := YY - 1700;
        aFMDT := (YY * 10000) + (MM * 100) + DD;
        if (h + m + s) > 0 then
          aFMDT := aFMDT + (h * 0.01) + (m * 0.0001) + (s * 0.000001);
        SetPiece(aIndex, Format('%.6f', [aFMDT]));
      end;
    dsdtsSQL:
      begin
        SetPiece(aIndex, FormatDateTime('YYYY-MM-DD hh:nn:ss', aValue));
      end;
  else
  end;
end;

procedure TDelimitedString.SetPiece(aIndex: integer; aValue: double; aPrecision: integer = 2);
begin
  SetPiece(aIndex, Format('%1.*f', [aPrecision, aValue]));
end;

procedure TDelimitedString.SetPiece(aIndex: integer; aValue: integer);
begin
  SetPiece(aIndex, IntToStr(aValue))
end;

function TDelimitedString.GetPieceIsDouble(aIndex: integer): boolean;
var
  aCode: integer;
begin
  try
    if GetPieceIsNotNull(aIndex) then
      begin
        Val(GetPiece(aIndex), fDouble, aCode);
        Result := (aCode = 0);
      end
    else
      Result := False;
  except
    on E: EConvertError do
      Result := False;
    on E: Exception do
      raise E;
  end;
end;

function TDelimitedString.GetPieceIsInteger(aIndex: integer): boolean;
var
  aCode: integer;
begin
  try
    if GetPieceIsNotNull(aIndex) then
      begin
        Val(GetPiece(aIndex), fInteger, aCode);
        Result := (aCode = 0);
      end
    else
      Result := False;
  except
    on E: EConvertError do
      Result := False;
    on E: Exception do
      raise E;
  end;
end;

function TDelimitedString.GetPieceIsNotNull(aIndex: integer): boolean;
begin
  Result := (Length(GetPiece(aIndex)) > 0);
end;

function TDelimitedString.GetPieceIsNull(aIndex: integer): boolean;
begin
  Result := (Length(GetPiece(aIndex)) = 0);
end;

function TDelimitedString.GetPieceIsTDateTime(aIndex: integer): boolean;
begin
  try
    GetPieceAsTDateTime(aIndex);
    Result := True;
  except
    Result := False;
  end;
end;

end.
