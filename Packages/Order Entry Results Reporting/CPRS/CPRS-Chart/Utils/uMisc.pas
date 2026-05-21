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
  Vcl.Controls,
   // Application units...
//  uProg,
  orNet,
  orFn,
  uConst,
  uCore,
  U508Extensions;

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

  TMisc = class
  public
    class function GetEnumValueFromString<T>(const AName: string;
      const Prefix: string = ''): T;
  end;

function CalcSize(list: TStrings; index: integer = -1): integer;
//function GetControlInfo(AFormatedFormName: string): Boolean;
function IsParameterOn(AParameter: string): Boolean; overload;
function IsParameterOn(AParameter: string;
  ADefault: Boolean): Boolean; overload;

function IsNonVAProvidersFeatureEnabled: Boolean;
function IncludeNonVAProviders(AControl: TControl): Boolean;

procedure MarkMostRecent(list: TStrings; index: integer);
procedure PurgeOldIfNeeded(list: TStrings; MaxSize: integer);

procedure InitSL(var list: TStringList);
procedure NumericKeyPress(Sender: TObject; var Key: Char);

function AssignedAndHasData(Node: TTreeNode): boolean;

function StripAllExcept(Input, KeepChars: string): string;

function IsDigits(str: string): boolean;

function IsObject(P: PPointer): Boolean;

implementation

uses
 System.Rtti,
 System.TypInfo;

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

function IsParameterOn(AParameter: string): Boolean; overload;
// AParameter is a fully qualified path name to a Boolean value in
// SystemParameters
begin
  Result := SystemParameters.AsType<Boolean>(AParameter);
end;

function IsParameterOn(AParameter: string;
  ADefault: Boolean): Boolean; overload;
begin
  Result := SystemParameters.AsTypeDef<Boolean>(AParameter, ADefault);
end;

function IsNonVAProvidersFeatureEnabled: Boolean;
var
  AOldCaseSensitive: Boolean;
begin
  AOldCaseSensitive := SystemParameters.CaseSensitive;
  SystemParameters.CaseSensitive := False;
  try
    Result := IsParameterOn(System.SysUtils.Format('%0:s.%1:s',
      [SPJ_NVA_PROVIDERS, SPJ_NVA_FEATURESWITCH]), False);
  finally
    SystemParameters.CaseSensitive := AOldCaseSensitive;
  end;
end;

function IncludeNonVAProviders(AControl: TControl): Boolean;
var
  AForm: TCustomForm;
  AOldCaseSensitive: Boolean;
begin
  // We return False when feature switch is off, but we do return non-VA
  // providers from the server (because we are never sending NVAP).
  if not IsNonVAProvidersFeatureEnabled then Exit(False);
  AForm := GetParentForm(AControl);
  if not Assigned(AForm) then Exit(False);

  AOldCaseSensitive := SystemParameters.CaseSensitive;
  SystemParameters.CaseSensitive := False;
  try
    Result := IsParameterOn(SysUtils.Format('%0:s.%1:s.%2:s.%3:s',
      [SPJ_NVA_PROVIDERS, SPJ_NVA_FORMS, AForm.Name, AControl.Name]), False);
  finally
    SystemParameters.CaseSensitive := AOldCaseSensitive;
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
  FreeObjects: Boolean;
begin
  size := CalcSize(list);
  while (list.Count > 0) and (size > MaxSize) do
  begin
    FreeObjects := True;
    if (list is TStringList) and (list as TStringList).OwnsObjects then
      FreeObjects := False;
    dec(size, CalcSize(list, 0));
    if FreeObjects and assigned(list.Objects[0]) then
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

{ TMisc }

class function TMisc.GetEnumValueFromString<T>(const AName, Prefix: string): T;
var
  IValue: Integer;
  ATypeInf: PTypeInfo;
  TypeData: PTypeData;
  Value: TValue;
begin
  ATypeInf := TypeInfo(T);
  IValue := GetEnumValue(ATypeInf, AName);
  if (IValue < 0) and (Prefix <> '') then
    IValue := GetEnumValue(ATypeInf, Prefix + AName);
  TypeData := ATypeInf^.TypeData;
  if (IValue < TypeData^.MinValue) or (IValue > TypeData^.MaxValue) then
    IValue := TypeData^.MinValue;
  TValue.Make(@IValue, ATypeInf, Value);
  Result := Value.AsType<T>;
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

function IsObject(P: PPointer): Boolean;
// Code from https://stackoverflow.com/questions/74740944/test-if-a-pointer-is-a-tobject-instance (slight rework)
// Use: if IsObject(List[I]) then... etc.
{$IFDEF MSWINDOWS}
var
  MemInfo: TMemoryBasicInformation;
{$ENDIF}
  function IsValidAddress(Address: Pointer): Boolean;
  begin
    // Must be above 64k and 4 byte aligned
    if (UIntPtr(Address) > $FFFF) and (UIntPtr(Address) and 3 = 0) then
    begin
{$IFDEF MSWINDOWS}
      // do we need to recheck the virtual memory?
      if (UIntPtr(MemInfo.BaseAddress) > UIntPtr(Address)) or
        ((UIntPtr(MemInfo.BaseAddress) + MemInfo.RegionSize) <
        (UIntPtr(Address) + SizeOf(Pointer))) then
      begin
        // retrieve the status for the pointer
        MemInfo.RegionSize := 0;
        VirtualQuery(Address, MemInfo, SizeOf(MemInfo));
      end;
      // check the readability of the memory address
      if (MemInfo.RegionSize >= SizeOf(Pointer)) and
        (MemInfo.State = MEM_COMMIT) and
        (MemInfo.Protect and (PAGE_READONLY or PAGE_READWRITE or
        PAGE_WRITECOPY or PAGE_EXECUTE or PAGE_EXECUTE_READ or
        PAGE_EXECUTE_READWRITE or PAGE_EXECUTE_WRITECOPY) <> 0) and
        (MemInfo.Protect and PAGE_GUARD = 0) then
{$ENDIF}
        Exit(True);
    end;
    Result := False;
  end;

begin
  if not Assigned(P) then Exit(False);
  try
{$IFDEF MSWINDOWS}
    MemInfo.RegionSize := 0;
{$ENDIF}
    if IsValidAddress(P)
    // not a class pointer - they point to themselves in the vmtSelfPtr slot
      and not(IsValidAddress(PByte(P) + vmtSelfPtr) and
      (P = PPointer(PByte(P) + vmtSelfPtr)^)) then
      if IsValidAddress(P^) and IsValidAddress(PByte(P^) + vmtSelfPtr)
      // looks to be an object, it points to a valid class pointer
        and (P^ = PPointer(PByte(P^) + vmtSelfPtr)^) then Exit(True);
  except
    Exit(False);
  end;
  Result := False;
end;

end.
