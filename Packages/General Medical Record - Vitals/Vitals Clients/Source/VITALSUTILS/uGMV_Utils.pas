unit uGMV_Utils;

interface

uses SysUtils
  ,Forms;

Type
  TVitalFunction = (
    vfInit,
    vfAdd,
    vfSubtract);


function TitleCase(Value: string): string;
function StrToFloatDef(const Str: string; Def: extended): extended;
procedure VitalMath(var Value: string; FuncValue, Default: extended; Func: TVitalFunction; Decml: integer);
function ReplacePunctuation(s:String):String;
function formatSSN(sSSN:String):String;
function formatPatientName(sInfo:String):String;
function formatPatientInfo(sInfo:String):String;

function CalculateBMI(const WeightInLbs: Double; const HeightInInches: Double): Double;
function ConvertInToCm(const Inches: Double): Double;
function ConvertCmToIn(const Centimeters: Double): Double;
function ConvertLbsToKgs(const Pounds: Double): Double;
function ConvertKgsToLbs(const Kilograms: Double): Double;
function ConvertFToC(const Fahrenheight: Double): Double;
function ConvertCToF(const Celsius: Double): Double;
function ConvertcmH20TommHg(const cmH20: Double): Double;
function ConvertmmHgTocmH20(const mmHg: Double): Double;

  function iPOx(sValue:String): integer;
  function iVal(gStr: string): integer;
  function BPMean(BP: string): integer;
  function HasNumericValue(s: string): Boolean;
  function SeriesLabel(sLbl: string): string;


implementation

uses uGMV_Common;


function TitleCase(Value: string): string;
{Returns a string value in Title Case format}
begin
  Result := UpperCase(Copy(Value, 1, 1));
  while Length(Value) > 1 do
    begin
      if
        ((Copy(Value, 1, 1) >= 'A') and (Copy(Value, 1, 1) <= 'Z')) or
        ((Copy(Value, 1, 1) >= 'a') and (Copy(Value, 1, 1) <= 'z')) then
        Result := Result + LowerCase(Copy(Value, 2, 1))
      else
        Result := Result + Copy(Value, 2, 1);
      Value := Copy(Value, 2, Length(Value) - 1);
    end;
end;

procedure VitalMath(var Value: string; FuncValue, Default: extended; Func: TVitalFunction; Decml: integer);
var
  tmp: extended;
begin
  if (Func = vfInit) then
    tmp := Default
  else
    begin
      tmp := StrToFloatDef(Value, Default);
      case Func of
        vfAdd: tmp := tmp + FuncValue;
        vfSubtract: tmp := tmp - FuncValue;
      end;
    end;
  if tmp <= 0 then tmp := 0; //added zzzzzzandria 050707
  if (tmp = 0) then
    Value := ''
  else
    Value := FloatToStrF(tmp, ffFixed, 8, Decml);
end;

function StrToFloatDef(const Str: string; Def: extended): extended;
begin
  if (Str = '') then
    Result := 0
  else
    begin
      try
        Result := StrToFloat(Str);
      except
        on EConvertError do
          Result := Def
      else
        raise;
      end;
    end;
end;

function ReplacePunctuation(s:String):String;
var
  ss: String;
  i: Integer;
const
  ALPHA = 'qwertyuiopasdfghjklzxcvbnm1234567890#QWERTYUIOPASDFGHJKLZXCVBNM-/';
  // "/" added 2008-02-12 zzzzzzandria ===================================>
begin
  ss := '';
  for i := 1 to length(s) do
    if pos(copy(s,i,1),ALPHA) = 0 then
      ss := ss + ' '
    else
      ss := ss +copy(s,i,1);
  Result := ss;
end;

function formatPatientName(sInfo:String):String;
var
  s: String;
begin
  s := sInfo;
  while (copy(s,length(s),1)<>' ') and (Length(s)>0) do
   s := copy(s,1,length(s)-1);
  result := s;
end;

function formatPatientInfo(sInfo:String):String;
var
  sSSN,
  sDOB,
  sAge : String;
begin
  sSSN := Piece(sInfo,'DOB:',1);
  while (Length(sSSN) > 0) and (
    (pos('1',sSSN) <> 1) and
    (pos('2',sSSN) <> 1) and
    (pos('3',sSSN) <> 1) and
    (pos('4',sSSN) <> 1) and
    (pos('5',sSSN) <> 1) and
    (pos('6',sSSN) <> 1) and
    (pos('7',sSSN) <> 1) and
    (pos('8',sSSN) <> 1) and
    (pos('9',sSSN) <> 1) and
    (pos('0',sSSN) <> 1)
    ) do
      sSSN := copy(sSSN,2,Length(sSSN)-1);
  if pos('*S',sSSN) <> 1 then
    sSSN := copy(sSSN,1,3)+'-'+copy(sSSN,4,2)+'-'+copy(sSSN,6,4);
  sAge := '('+piece(sInfo,'Age:',2)+')';
  sDOB := piece(Piece(sInfo,'DOB: ',2),' ',1);
  Result := sSSN + '   ' + sDOB + ' '+SAge;
end;


function formatSSN(sSSN:String):String;
var
  s: String;
begin
  s := sSSN;
  While pos(' ',s) = 1 do
    s := copy(s,2,length(s)-1);
  if pos('*S',s)=1 then
    Result := s
  else
    Result := copy(s,1,3)+'-'+copy(s,4,2)+'-'+copy(s,6,Length(s)-5);
end;

function CalculateBMI(const WeightInLbs: Double; const HeightInInches: Double): Double;
begin
  Result := Round(WeightInLbs / (HeightInInches * HeightInInches)*100)*0.01;
end;

function ConvertInToCm(const Inches: Double): Double;
begin
  Result := Round(Inches * 2.54 * 100) * 0.01;
end;

function ConvertCmToIn(const Centimeters: Double): Double;
begin
  Result := Round(Centimeters / 2.54 * 1000) * 0.001;
end;

// R153954 
function ConvertLbsToKgs(const Pounds: Double): Double;
begin
////  Result := Round(Pounds*100 / 2.2026431718)*0.01;
//  Result := Round(Pounds*100 / 2.20462262)*0.01;
  Result := Round(Pounds*100 * 0.45359237)*0.01;
end;

function ConvertKgsToLbs(const Kilograms: Double): Double;
begin
////  Result := Round(Kilograms * 220.26431718)*0.01;
//  Result := Round(Kilograms * 220.462262)*0.01;
  Result := Round(Kilograms/0.45359237 * 100)*0.01;
end;

function ConvertFToC(const Fahrenheight: Double): Double;
begin
  Result := Round(((Fahrenheight - 32) * 5.0 / 9.0) * 10) * 0.1;
end;

function ConvertCToF(const Celsius: Double): Double;
begin
  Result := Round(((Celsius * 9.0 / 5.0) + 32) * 10) * 0.1;
end;

function ConvertcmH20TommHg(const cmH20: Double): Double;
begin
  Result := cmH20 / 1.36;//AAN 07/03/2002
end;

function ConvertmmHgTocmH20(const mmHg: Double): Double;
begin
  Result := mmHg * 1.36;//AAN 07/03/2002
end;

function iPOx(sValue:String): integer;
var
  s: String;
begin
  if sValue = '' then
    begin
      Result := 0;
      Exit;
    end;
  if pos('*',sValue) <> 0 then
    s := piece(sValue,'*',1)
  else
    s := piece(sValue,' ',1);

  try
    Result := StrToInt(s);
  except
    Result := 0;
  end;
end;

  function iVal(gStr: string): integer;
  var
    i: integer;
  begin
    i := 1;
    while StrToIntDef(Copy(gStr, i, 1), -1) > -1 do
      inc(i);
    Result := StrToIntDef(Copy(gStr, 1, i - 1), 0);
  end;


  function BPMean(BP: string): integer;
  begin
    Result := (iVal(BP) + iVal(Piece(BP, '/', 2))) div 2;
  end;

  function HasNumericValue(s: string): Boolean;
  begin
    Result := (StrToIntDef(Copy(s, 1, 1), 9999) <> 9999)
      or (copy(s,1,1)='-') // zzzzzzandria 051107
      ;
  end;

  function SeriesLabel(sLbl: string): string;
  begin
    while Copy(sLbl, 1, 1) = ' ' do
      sLbl := Copy(sLbl, 2, Length(sLbl));

    Result := Copy(sLbl, 1, Pos(' ', sLbl) - 1) + #13 +
      Copy(sLbl, Pos(' ', sLbl) + 1, Length(sLbl));
  end;

end.



