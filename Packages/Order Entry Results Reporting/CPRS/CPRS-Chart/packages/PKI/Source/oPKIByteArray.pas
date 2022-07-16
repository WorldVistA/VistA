unit oPKIByteArray;

interface

uses
  System.Classes,
  System.SysUtils,
  oPKIEncryption,
  oPKIEncryptionEx;

type
  TPKIByteArray = class(TInterfacedObject, IPKIByteArray, IPKIByteArrayEx)
  private
    fByteArray: array of Byte;
  protected
    function getPByte: PByte;

    function getArrayLength: integer;
    function getAsAnsiString: AnsiString;
    function getAsHex: string;
    function getAsMime: string;
    function getAsString: string;

    procedure setArrayLength(const aValue: integer);

    procedure setAsAnsiString(const aValue: AnsiString);
    procedure setAsHex(const aValue: string);
    procedure setAsMime(const aValue: string);
    procedure setAsString(const aValue: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure GetArrayValues(aList: TStrings);

    property AsAnsiString: AnsiString read getAsAnsiString;
    property AsHex: string read getAsHex;
    property AsMime: string read getAsMime;
    property AsString: string read getAsString write setAsString;
    property ArrayLength: integer read getArrayLength;
  end;

implementation

uses
  XlfMime;

constructor TPKIByteArray.Create;
begin
  inherited;
  SetLength(fByteArray, 0);
end;

destructor TPKIByteArray.Destroy;
begin
  SetLength(fByteArray, 0);
  inherited;
end;

procedure TPKIByteArray.Clear;
begin
  SetLength(fByteArray, 0);
end;

procedure TPKIByteArray.GetArrayValues(aList: TStrings);
var
  i: integer;
begin
  aList.Clear;
  for i := 0 to Length(fByteArray) - 1 do
    aList.Add(Format('[%d] = (%3d) - %s', [i, Ord(fByteArray[i]), Chr(fByteArray[i])]));
end;

function TPKIByteArray.getArrayLength: integer;
begin
  Result := Length(fByteArray);
end;

function TPKIByteArray.getPByte: PByte;
begin
  Result := @fByteArray[0];
end;

procedure TPKIByteArray.setArrayLength(const aValue: integer);
begin
  SetLength(fByteArray, 0);
  if (aValue > -1) then
    SetLength(fByteArray, aValue);
end;

(*
  *                     _  _____ _        _
  *     /\             (_)/ ____| |      (_)
  *    /  \   _ __  ___ _| (___ | |_ _ __ _ _ __   __ _
  *   / /\ \ | '_ \/ __| |\___ \| __| '__| | '_ \ / _` |
  *  / ____ \| | | \__ \ |____) | |_| |  | | | | | (_| |
  * /_/    \_\_| |_|___/_|_____/ \__|_|  |_|_| |_|\__, |
  *                                                __/ |
  *                                               |___/
*)

function TPKIByteArray.getAsAnsiString: AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := 0 to Length(fByteArray) - 1 do
    Result := Result + AnsiChar(fByteArray[i]);
end;

procedure TPKIByteArray.setAsAnsiString(const aValue: AnsiString);
var
  aAnsiChar: AnsiChar;
  i: integer;
begin
  i := 0;
  setArrayLength(Length(aValue));
  for aAnsiChar in aValue do
    begin
      fByteArray[i] := Ord(aAnsiChar);
      inc(i);
    end;
end;

(*
  *   _    _                    _           _                 _
  *  | |  | |                  | |         (_)               | |
  *  | |__| | _____  ____ _  __| | ___  ___ _ _ __ ___   __ _| |
  *  |  __  |/ _ \ \/ / _` |/ _` |/ _ \/ __| | '_ ` _ \ / _` | |
  *  | |  | |  __/>  < (_| | (_| |  __/ (__| | | | | | | (_| | |
  *  |_|  |_|\___/_/\_\__,_|\__,_|\___|\___|_|_| |_| |_|\__,_|_|
  *
*)

function TPKIByteArray.getAsHex: string;
var
  i: integer;
  j: integer;
  x: Char;
begin
  Result := '';
  for i := 0 to Length(fByteArray) - 1 do
    begin
      x := Chr(fByteArray[i]);
      j := Ord(x);
      Result := Result + IntToHex(j, 2);
    end;
end;

procedure TPKIByteArray.setAsHex(const aValue: string);
var
  aStringValue: string;
  i: integer;
begin
  i := 1;
  aStringValue := '';
  while i < Length(aValue) do
    begin
      aStringValue := aStringValue + Char(StrToInt('$' + Copy(aValue, i, 2)));
      inc(i, 2);
    end;

  setAsString(aStringValue);
end;

(*
  *   __  __ _
  *  |  \/  (_)
  *  | \  / |_ _ __ ___   ___
  *  | |\/| | | '_ ` _ \ / _ \
  *  | |  | | | | | | | |  __/
  *  |_|  |_|_|_| |_| |_|\___|
  *
*)
function TPKIByteArray.getAsMime: string;
var
  aSignatureStr: AnsiString;
begin
  SetLength(aSignatureStr, MimeEncodedSize(Length(getAsAnsiString)));
  aSignatureStr := MimeEncodeString(getAsAnsiString);
  Result := String(aSignatureStr);
end;

procedure TPKIByteArray.setAsMime(const aValue: string);
begin
  setAsAnsiString(MimeDecodeString(AnsiString(aValue)));
end;

(*
  *   _____ _        _
  *  / ____| |      (_)
  * | (___ | |_ _ __ _ _ __   __ _
  *  \___ \| __| '__| | '_ \ / _` |
  *  ____) | |_| |  | | | | | (_| |
  * |_____/ \__|_|  |_|_| |_|\__, |
  *                           __/ |
  *                          |___/
*)

function TPKIByteArray.getAsString: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to Length(fByteArray) - 1 do
    Result := Result + Chr(fByteArray[i]);
end;

procedure TPKIByteArray.setAsString(const aValue: string);
var
  aChar: Char;
  i: integer;
begin
  i := 0;
  setArrayLength(Length(aValue));
  for aChar in aValue do
    begin
      fByteArray[i] := Ord(aChar);
      inc(i);
    end;
end;

end.
