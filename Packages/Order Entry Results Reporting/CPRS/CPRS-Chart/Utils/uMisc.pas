unit uMisc;

interface

uses
  SysUtils,
  Classes,
  DateUtils,
  messages,
  Comctrls,
  System.Generics.Collections,
  System.Generics.Defaults,
  Winapi.Windows,
  Forms,
  system.uitypes,
  vcl.Dialogs,
  Vcl.StdCtrls,
   // Application units...
//  uProg,
  orNet,
  orFn;

type
  tSrchDictGroup = TDictionary<String, TListGroup>;
  tSrchDict = TDictionary<String, TListItem>;

  THelperListGroups = class helper for TListGroups
  public
    function FindItemByGroupID(GroupID: Integer): TListGroup;
    function FindItemByGroupHeader(GroupHeader: String): TListGroup;
    function FindLastGroupID: Integer;
    function FindItemByGroup(aLookup: String; const SrchDict: tSrchDictGroup)
      : TListGroup;
  end;

  tStringlistHelper = class helper for TStringList
    function IndexOfPiece(const S: string; const PieceDelim: Char; const PieceNum: integer): Integer;
    function IndexOfPieceEx(const S: string; const PieceDelim: Char; const PieceNum: integer; const StartFrom: Integer): Integer;
    function FindByPiece(const S: string; var Index: Integer; const PieceDelim: Char; const PieceNum: integer): Boolean;
    function FindByPieceEx(const S: string; var Index: Integer; const PieceDelim: Char; const PieceNum: integer;const StartFrom: Integer): Boolean;
  end;

function CalcSize(list: TStrings; index: integer = -1): integer;
procedure MarkMostRecent(list: TStrings; index: integer);
procedure PurgeOldIfNeeded(list: TStrings; MaxSize: integer);

procedure InitSL(var list: TStringList);
procedure NumericKeyPress(Sender: TObject; var Key: Char);

function AssignedAndHasData(Node: TTreeNode): boolean;

function StripAllExcept(Input, KeepChars: string): string;

function IsDigits(str: string): boolean;

implementation

function CalcSize(list: TStrings; index: integer = -1): integer;
var
  i, j, cz, i1, i2: integer;
  sub: TStrings;

begin
  Result := 0;
  cz := sizeof(Char);
  if index >= 0 then
  begin
    i1 := index;
    i2 := index;
  end
  else
  begin
    i1 := 0;
    i2 := list.Count - 1;
  end;
  for i := i1 to i2 do
  begin
    inc(Result, length(list[i]) * cz);
    if assigned(list.Objects[i]) then
    begin
      if list.Objects[i] is TStrings then
      begin
        sub := TStrings(list.Objects[i]);
        for j := 0 to sub.Count - 1 do
          inc(Result, length(sub[j]) * cz);
      end;
    end;
  end;
end;

procedure MarkMostRecent(list: TStrings; index: integer);
begin
  if index < list.Count - 1 then
    list.Move(index, list.Count - 1);
end;

procedure PurgeOldIfNeeded(list: TStrings; MaxSize: integer);
var
  size: integer;

begin
  size := CalcSize(list);
  while (list.Count > 0) and (size > MaxSize) do
  begin
    dec(size, CalcSize(list, 0));
    if assigned(list.Objects[0]) then
      list.Objects[0].Free;
    list.Delete(0);
  end;
end;


procedure InitSL(var list: TStringList);
begin
  if assigned(list) then
    list.Clear
  else
    list := TStringList.Create;
end;

procedure NumericKeyPress(Sender: TObject; var Key: Char);
var
  uText: string;

begin
  if (Key <> '.') and (Key <> '-') and (Key > #31) and
    ((Key < '0') or (Key > '9')) then
    Key := #0
  else if (Sender is TCustomEdit) then
    with TCustomEdit(Sender) do
    begin
      if (Key = '-') and (SelStart > 0) then
        Key := #0
      else if (Key = '.') then
      begin
        uText := Text;
        if SelLength > 0 then
          Delete(uText, SelStart + 1, SelLength);
        if pos('.', uText) > 0 then
          Key := #0;
      end;
    end;
end;

{ THelperListGroups }

function THelperListGroups.FindItemByGroup(aLookup: String;
  const SrchDict: tSrchDictGroup): TListGroup;
begin
  Result := nil;
  SrchDict.TryGetValue(aLookup, Result);
end;

function THelperListGroups.FindItemByGroupHeader(
  GroupHeader: String): TListGroup;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if trim(Result.Header) = trim(GroupHeader) then
      Exit;
  end;
  Result := nil;
end;

function THelperListGroups.FindItemByGroupID(GroupID: Integer): TListGroup;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if Result.GroupID = GroupID then
      Exit;
  end;
  Result := nil;
end;

function THelperListGroups.FindLastGroupID: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := Count - 1 downto 0 do
  begin
    if Items[i].GroupID > Result then
      Result := Items[i].GroupID;
  end;
end;

{ tStringlistHelper }

function tStringlistHelper.IndexOfPiece(const S: string; const PieceDelim: Char; const PieceNum: integer): Integer;
begin
 Result := IndexOfPieceEx(S, PieceDelim, PieceNum, 0);
end;

function tStringlistHelper.IndexOfPieceEx(const S: string; const PieceDelim: Char; const PieceNum: integer; const StartFrom: Integer): Integer;
var
  Count: Integer;
  SLen: Integer;
  aStr: String;
begin
  Count := GetCount;

  if StartFrom > count then
  begin
    Result := -1;
    exit;
  end;

  if not Sorted then
  begin

    SLen := Length(S);
    for Result := StartFrom to Count - 1 do
    begin
      aStr := Piece(self.Strings[Result], PieceDelim, PieceNum);
      if (Length(aStr) = SLen) and (CompareStrings(aStr, S) = 0) then
        Exit;
    end;
    Result := -1;
  end
  else
    if not FindByPieceEx(S, Result, PieceDelim, PieceNum, StartFrom) then
      Result := -1;
end;

function tStringlistHelper.FindByPiece(const S: string; var Index: Integer; const PieceDelim: Char; const PieceNum: integer): Boolean;
begin
  Result := FindByPieceEx(S, Index, PieceDelim, PieceNum, 0);
end;

function tStringlistHelper.FindByPieceEx(const S: string; var Index: Integer; const PieceDelim: Char; const PieceNum: integer; const StartFrom: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := GetCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(Piece(self.Strings[I], PieceDelim, PieceNum), S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function AssignedAndHasData(Node: TTreeNode): boolean;
begin
  Result := assigned(Node) and assigned(Node.Data);
end;

function StripAllExcept(Input, KeepChars: string): string;
var
  i: integer;

begin
  Result := Input;
  for i := length(Result) downto 1 do
    if pos(Result[i], KeepChars) = 0 then
      delete(Result, i, 1);
end;

function IsDigits(str: string): boolean;
var
  i: integer;

begin
  if str = '' then
    Exit(False);
  for i := 1 to Length(str) do
    if not CharInSet(str[i], ['0'..'9']) then
      Exit(False);
  Result := True;
end;

end.
