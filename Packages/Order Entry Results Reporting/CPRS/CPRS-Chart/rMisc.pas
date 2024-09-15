unit rMisc;

interface

uses SysUtils, Windows, Classes, Forms, Controls, ComCtrls, Grids, ORFn, ORNet,
    Menus, Contnrs, StrUtils;

const
  MAX_TOOLITEMS = 30;

type
  TToolMenuItem = class
  public
    Caption: string;
    Caption2: string;
    Action: string;
    MenuID: string;
    SubMenuID: string;
    MenuItem: TMenuItem;
  end;

  TDLL_Return_Type = (DLL_Success, DLL_Missing, DLL_VersionErr);
  TDLLCloseProc = reference to procedure(Handle: THandle);

  TDllRtnRec = record
    DLLName: string;
    LibName: string;
    DLL_HWND: HMODULE;
    Return_Type: TDLL_Return_Type;
    Return_Message: String;
    ForceCloseProc: TDLLCloseProc;
  end;

var
  uToolMenuItems: TObjectList = nil;

type
  {An Object of this Class is Created to Hold the Sizes of Controls(Forms)
   while the app is running, thus reducing calls to RPCs SAVESIZ and LOADSIZ}
  TSizeHolder = class(TObject)
  private
    FSizeList,FNameList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function GetSize(AName: String): String;
    procedure SetSize(AName,ASize: String);
    procedure AddSizesToStrList(theList: TStringList);
  end;

  SettingSizeArray = array of integer;


function setDetailPrimaryCare(aDest:TSTrings;const DFN: string): Integer;  //*DFN*
procedure GetToolMenu;
procedure ListSymbolTable(aDest: TStrings);
function MScalar(const x: string): string; deprecated;
procedure SetShareNode(const DFN: string; AHandle: HWND);  //*DFN*
function ServerHasPatch(const x: string): Boolean;
function SiteSpansIntlDateLine: boolean;
function RPCCheck(aRPC: TStrings):Boolean; overload;
function RPCCheck(aRPC: String):Boolean;  overload;
function RPCCheckList(aRPC: TStrings; aDest: TStrings): Boolean;

function ServerVersion(const Option, VerClient: string): string;
function PackageVersion(const Namespace: string): string;

function ProgramFilesDir: string;
function ApplicationDirectory: string;
function VistaCommonFilesDirectory: string;
function DropADir(DirName: string): string;
function RelativeCommonFilesDirectory: string;
function FindDllDir(DllName: string): string;
function LoadDll(DllName: string; CloseProc: TDLLCloseProc): TDllRtnRec;
procedure ForceCloseAllDLLs;
function DllVersionCheck(DllName: string; DLLVersion: string): string;
function GetMOBDLLName(): string;

procedure SaveUserBounds(AControl: TControl; ID: string = '');
procedure SaveUserSizes(SizingList: TStringList);
procedure SetFormPosition(AForm: TForm; FormID: string = '';
  NoShrinkAllowed: Boolean = False);
procedure SetUserBounds(var AControl: TControl);
procedure SetUserBounds2(AName: string; var v1, v2, v3, v4: integer);
//procedure SetUserBoundsArray(AName: string; var SettingArray: SettingSizeArray);
procedure SetUserWidths(var AControl: TControl);
procedure SetUserColumns(var AControl: TControl);
procedure SetUserString(StrName: string; var Str: string);
function StrUserBounds(AControl: TControl): string;
function StrUserBounds2(AName: string; v1, v2, v3, v4: integer): string;
function StrUserBoundsArray(AName: string; SizeArray: SettingSizeArray): string;
function StrUserWidth(AControl: TControl): string;
function StrUserColumns(AControl: TControl): string;
function StrUserString(StrName: string; Str: string): string;
function UserFontSize: integer;
procedure SaveUserFontSize( FontSize: integer);

/// <summary>Returns value of the specified piece. First piece reserved for ID.
/// Defaults if ID is not found</summary>
function getPieceByFieldID(aSource: TStrings; anID: String; aPiece: Integer;
  Default: String = ''): String;

function FindDT(aSource: TStrings; const FieldID: string; aPiece: Integer)
: TFMDateTime;
function FindExt(aSource: TStrings; const FieldID: string;
  aPiece: Integer): string;
function FindInt(aSource: TStrings; const FieldID: string;
  aPiece: Integer): Integer;
function FindInt64(aSource: TStrings; const FieldID: string;
  aPiece: Integer): Int64;
function FindVal(aSource:TStrings;const FieldID: string;aPiece:Integer): string;
procedure GetDDAttributes(Dest: TStrings; FileNum, FieldNum: Extended; Flags, Attributes: string);

var
  SizeHolder : TSizeHolder;

implementation

uses TRPCB, fOrders, math, Registry, ORSystem, rCore, System.Generics.Collections;

var
  uBounds, uWidths, uColumns: TStringList;
function setDetailPrimaryCare(aDest:TStrings;const DFN: string): Integer;  //*DFN*
begin
  CallVistA('ORWPT1 PCDETAIL', [DFN],aDest);
  Result := aDest.Count;
end;


const
  SUBMENU_KEY = 'SUBMENU';
  SUBMENU_KEY_LEN = length(SUBMENU_KEY);
  SUB_LEFT = '[';
  SUB_RIGHT = ']';
  MORE_ID = 'MORE^';
  MORE_NAME = 'More...';

procedure GetToolMenu;
var
  i, p, LastIdx, count, MenuCount, SubCount: Integer;
  id, x: string;
  LastItem, item: TToolMenuItem;
  caption, action: string;
  CurrentMenuID: string;
  MenuIDs: TStringList;
  Results: TSTrings;
begin
  if not assigned(uToolMenuItems) then
    uToolMenuItems := TObjectList.Create
  else
    uToolMenuItems.Clear;

  Results := TSTringList.Create;
  try
  CallVistA('ORWU TOOLMENU', [nil],Results);
  MenuIDs := TStringList.Create;
  try
    for i := 0 to {RPCBrokerV.}Results.Count - 1 do
    begin
      x := Piece({RPCBrokerV.}Results[i], U, 1);
      item := TToolMenuItem.Create;
      Caption := Piece(x, '=', 1);
      Action := Copy(x, Pos('=', x) + 1, Length(x));
      item.Caption2 := Caption;
      if UpperCase(copy(Action,1,SUBMENU_KEY_LEN)) = SUBMENU_KEY then
      begin
        id := UpperCase(Trim(Copy(Action, SUBMENU_KEY_LEN+1, MaxInt)));
        if (LeftStr(id,1) = SUB_LEFT) and (RightStr(id,1) = SUB_RIGHT) then
          id := copy(id, 2, length(id)-2);
        item.MenuID := id;
        Action := '';
        if MenuIDs.IndexOf(item.MenuID) < 0 then
          MenuIDs.Add(item.MenuID)
        else
        begin
          item.SubMenuID := item.MenuID;
          item.MenuID := '';
        end;
      end;
      if RightStr(Caption, 1) = SUB_RIGHT then
      begin
        p := length(Caption) - 2;
        while (p > 0) and (Caption[p] <> SUB_LEFT) do
          dec(p);
        if (p > 0) and (Caption[p] = SUB_LEFT) then
        begin
          item.SubMenuID := UpperCase(Trim(copy(Caption,p+1, length(Caption)-1-p)));
          Caption := copy(Caption,1,p-1);
        end;
      end;
      item.Caption := Caption;
      item.Action := Action;
      uToolMenuItems.add(item);
    end;
    // see if all child menu items have parents
    for I := 0 to uToolMenuItems.Count - 1 do
    begin
      item := TToolMenuItem(uToolMenuItems[i]);
      if MenuIDs.IndexOf(item.SubMenuID) < 0 then
      begin
        item.SubMenuID := '';
        item.Caption := item.Caption2;
      end;
    end;

    // see if there are more than MAX_TOOLITEMS in the root menu
    // if there are, add automatic sub menus
    // SubCount tracks items for sub menus and is used as offsent when inserting
    // More... into the list of menu items
    LastIdx := (MAX_TOOLITEMS - 1);
    count := 0;
    CurrentMenuID := '';
    i := 0;
    LastItem := nil;
    MenuCount := 0;
    SubCount := 0;
    repeat
      item := TToolMenuItem(uToolMenuItems[i]);
      if item.SubMenuID <> '' then inc(SubCount);
      if item.SubMenuID = '' then
      begin
        item.SubMenuID := CurrentMenuID;
        inc(count);
        if Count > MAX_TOOLITEMS then
        begin
          item.SubMenuID := '';
          inc(MenuCount);
          item := TToolMenuItem.Create;
          item.Caption := MORE_NAME;
          item.MenuID := MORE_ID + IntToStr(MenuCount);
          item.SubMenuID := CurrentMenuID;
          CurrentMenuID := item.MenuID;
          LastItem.SubMenuID := CurrentMenuID;
          uToolMenuItems.Insert(LastIdx + SubCount, item);
          inc(LastIdx,MAX_TOOLITEMS);
          Count := 1;
        end;
        LastItem := item;
      end;
      inc(i);
    until i >= uToolMenuItems.Count;

  finally
    MenuIDs.Free;
  end;
  finally
    Results.Free;
  end;
end;

procedure ListSymbolTable(aDest: TSTrings);
var
  Results: TSTrings;
  i: integer;
  x: string;
begin
  aDest.Clear;
  Results := TStringList.Create;
  try
    CallVistA('ORWUX SYMTAB', [nil], Results);
    i := 0;
    with { RPCBrokerV. } Results do
      while i < Count do
      begin
        x := Strings[i] + '=';
        inc(i);
        if i < Count then
          x := x + Strings[i];
        aDest.Add(x);
        inc(i);
      end;
  finally
    Results.Free;
  end;
end;

function MScalar(const x: string): string;
begin
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'XWB GET VARIABLE VALUE';
      Param[0].Value := x;
      Param[0].PType := reference;
      CallBroker;
      if Results.Count > 0 then
        Result := Results[0]
      else
        Result := '';
    end;
  finally
    UnlockBroker;
  end;
end;

function ServerHasPatch(const x: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWU PATCH', [x],s) and ( s = '1');
end;

function SiteSpansIntlDateLine: boolean;
var
  s: String;
begin
  Result := CallVistA('ORWU OVERDL', [],s) and (s = '1');
end;

function RPCCheck(aRPC: TStrings):Boolean; //aRPC format array of RPC's Name^Version
//All RPC's in the list must come back true/active
var
  Results: TStrings;
  i: integer;
begin
  Result := false;
  Results := TStringList.Create;
  try
  CallVistA('XWB ARE RPCS AVAILABLE',['L',aRPC],Results);
  if Results.Count > 0 then
    for i := 0 to Results.Count - 1 do
      begin
        if Results[i] = '1' then
          Result := true
        else
          begin
            Result := false;
            Break;
          end;
      end;
  finally
    Results.Free;
  end;
end;

function RPCCheck(aRPC: String):Boolean; //aRPC format array of RPC's Name^Version
//All RPC's in the list must come back true/active
var
  aList,
  Results: TStrings;
begin
  Results := TStringList.Create;
  aList := TStringList.Create;
  aList.Add(aRPC);
  try
    Result := CallVistA('XWB ARE RPCS AVAILABLE',['L',aList],Results) and
      (Results.Count > 0) and (Results[0] = '1');
 finally
    Results.Free;
    aList.Free;
  end;
end;



function RPCCheckList(aRPC: TSTrings; aDest: TSTrings): Boolean;
var
  s: String;
  i: integer;
begin
  try
    CallVistA('XWB ARE RPCS AVAILABLE', ['L', aRPC], aDest);
    Result := aRPC.Count = aDest.Count;
    if Result then
      for i := 0 to aDest.Count - 1 do
      begin
        if (aDest[i] = '1') or (aRPC[i]=' ') or (pos('---',aRPC[i])=1) then
          s := ' '
        else
          s := '?';
        aDest[i] := aDest[i] + ' ' + s + ' ' + aRPC[i];
      end;
  finally
  end;
end;


function ServerVersion(const Option, VerClient: string): string;
begin
  CallVistA('ORWU VERSRV', [Option, VerClient],Result);
end;

function PackageVersion(const Namespace: string): string;
begin
  CallVistA('ORWU VERSION', [Namespace],Result);
end;

function UserFontSize: integer;
begin
  if not CallVistA('ORWCH LDFONT', [nil],Result,8) then // RTC 822208 - adding RPC default result '8'
    Result := 8;
  if Result < 8 then Result := 8;
  If Result = 24 then Result := 18; // CQ #12322 removed 24 pt font
  if Result = 18 then Result := 14; // Same thing as before, can't handle font size anymore
end;

procedure LoadSizes;
var
  Results: TStrings;
  i, p: integer;
begin
  uBounds := TStringList.Create;
  uWidths := TStringList.Create;
  uColumns := TStringList.Create;

  Results := TStringList.Create;
  try
    CallVistA('ORWCH LOADALL', [nil], Results);
    begin
      for i := 0 to Results.Count - 1 do // change '^' to '='
      begin
        p := Pos(U, Results[i]);
        if p > 0 then
          Results[i] := Copy(Results[i], 1, p - 1) + '=' +
            Copy(Results[i], p + 1, length(Results[i]));
      end;
      ExtractItems(uBounds, Results, 'Bounds');
      ExtractItems(uWidths, Results, 'Widths');
      ExtractItems(uColumns, Results, 'Columns');
    end;
  finally
    Results.Free;
  end;
end;

procedure SetShareNode(const DFN: string; AHandle: HWND);  //*DFN*
begin
  // sets node that allows other apps to see which patient is currently selected
  CallVistA('ORWPT SHARE', [DottedIPStr, IntToHex(AHandle, 8), DFN]);
end;

function GetControlName(var AControl: TControl): string;
begin
  Result := '';
  try
    if assigned(AControl) then
    begin
      Result := AControl.Name;
      if (not (AControl is TForm)) and Assigned(AControl.Owner) then
        Result := AControl.Owner.Name + '.' + Result;
    end;
  except
    Result := '';
  end;
end;

procedure SetUserBounds(var AControl: TControl);
var
  x: string;
  kb: IORKeepBounds;

begin
  x := GetControlName(AControl);
  if x = '' then
    exit;
  if uBounds = nil then LoadSizes;
  x := uBounds.Values[x];
  if (x = '0,0,0,0') and (AControl is TForm) then
    TForm(AControl).WindowState := wsMaximized
  else
  begin
      AControl.Left   := HigherOf(StrToIntDef(Piece(x, ',', 1), AControl.Left), 0);
      AControl.Top    := HigherOf(StrToIntDef(Piece(x, ',', 2), AControl.Top), 0);

//      if (AControl is TForm) then
//       TForm(AControl).MakeFullyVisible;

      if Assigned( AControl.Parent ) then
      begin
        AControl.Width  := LowerOf(StrToIntDef(Piece(x, ',', 3), AControl.Width), AControl.Parent.Width - AControl.Left);
        AControl.Height := LowerOf(StrToIntDef(Piece(x, ',', 4), AControl.Height), AControl.Parent.Height - AControl.Top);
      end
      else
      begin
        AControl.Width  := StrToIntDef(Piece(x, ',', 3), AControl.Width);
        AControl.Height := StrToIntDef(Piece(x, ',', 4), AControl.Height);
      end;
          if (AControl is TForm) then
       TForm(AControl).MakeFullyVisible;
  end;
  if (AControl is TForm) and AControl.GetInterface(IORKeepBounds, kb) and assigned(kb) then
    kb.KeepBounds := True;
  //if (x = '0,0,' + IntToStr(Screen.Width) + ',' + IntToStr(Screen.Height)) and
  //  (AControl is TForm) then TForm(AControl).WindowState := wsMaximized;
end;

procedure SetUserBounds2(AName: string; var v1, v2, v3, v4: integer);
var
  x: string;
begin
  if uBounds = nil then LoadSizes;
  x := uBounds.Values[AName];
  v1 := StrToIntDef(Piece(x, ',', 1), 0);
  v2 := StrToIntDef(Piece(x, ',', 2), 0);
  v3 := StrToIntDef(Piece(x, ',', 3), 0);
  v4 := StrToIntDef(Piece(x, ',', 4), 0);
end;

{
procedure SetUserBoundsArray(AName: string; var SettingArray: SettingSizeArray);
var
  i: integer;
  x: string;
begin
  if uBounds = nil then LoadSizes;
  x := uBounds.Values[AName];
  SetLength(SettingArray, uBounds.Count);
  for i := 0 to (uBounds.Count - 1) do begin
    SettingArray[i] := StrToIntDef(Piece(x, ',', i), 0);
  end;
end;
}

procedure SetUserWidths(var AControl: TControl);
var
  x: string;
begin
  x := GetControlName(AControl);
  if x = '' then
    exit;
  if uWidths = nil then LoadSizes;
  x := uWidths.Values[x];
  if Assigned (AControl.Parent) then
    AControl.Width := LowerOf(StrToIntDef(x, AControl.Width), AControl.Parent.Width - AControl.Left)
  else
    AControl.Width := StrToIntDef(x, AControl.Width);
end;

procedure SetUserColumns(var AControl: TControl);
var
  x: string;
  i, AWidth: Integer;
  couldSet: boolean;
begin
  x := GetControlName(AControl);
  if x = '' then
    exit;
  couldSet := False;
  if uColumns = nil then LoadSizes;
  if AnsiCompareText(x,'frmOrders.hdrOrders')=0 then
    couldSet := True;
  x := uColumns.Values[x];
  if AControl is THeaderControl then with THeaderControl(AControl) do
    for i := 0 to Sections.Count - 1 do
    begin
      //Make sure all of the colmumns fit, even if it means scrunching the last ones.
      AWidth := LowerOf(StrToIntDef(Piece(x, ',', i + 1), 0), HigherOf(ClientWidth - (Sections.Count - i)*5 - Sections.Items[i].Left, 5));
      if AWidth > 0 then Sections.Items[i].Width := AWidth;
      if couldSet and (i=0) and (AWidth>0) then
        frmOrders.EvtColWidth := AWidth;
    end;
  if AControl is TCustomGrid then {nothing for now};
end;

procedure SetUserString(StrName: string; var Str: string);
begin
  Str := uColumns.Values[StrName];
end;

procedure SaveUserBounds(AControl: TControl; ID: string = '');
var
  x, n: string;
  NewHeight: integer;
begin
  n := GetControlName(AControl);
  if n = '' then
    exit;
  n := n + ID;
  if (AControl is TForm) and (TForm(AControl).WindowState = wsMaximized) then
    x := '0,0,0,0'
  else
    with AControl do
      begin
        //Done to remove the adjustment for Window XP style before saving the form size
        NewHeight := Height - (GetSystemMetrics(SM_CYCAPTION) - 19);
        x := IntToStr(Left) + ',' + IntToStr(Top) + ',' +
           IntToStr(Width) + ',' + IntToStr(NewHeight);
      end;
//  CallV('ORWCH SAVESIZ', [AControl.Name, x]);
  SizeHolder.SetSize(n, x);
end;

procedure SaveUserSizes(SizingList: TStringList);
begin
  CallVistA('ORWCH SAVEALL', [SizingList]);
end;

procedure SaveUserFontSize( FontSize: integer);
begin
  CallVistA('ORWCH SAVFONT', [IntToStr(FontSize)]);
end;

procedure SetFormPosition(AForm: TForm; FormID: string = '';
  NoShrinkAllowed: Boolean = False);
var
  x: string;
  kb: IORKeepBounds;

begin
  x := SizeHolder.GetSize(AForm.Name + FormID);
  if x = '' then Exit; // allow default bounds to be passed in, else screen center?
  if (x = '0,0,0,0') then
    AForm.WindowState := wsMaximized
  else
  begin
    if NoShrinkAllowed then
    begin
      if StrToIntDef(Piece(x, ',', 3), 0) < AForm.Width then
        SetPiece(x, ',', 3, AForm.Width.ToString);
      if StrToIntDef(Piece(x, ',', 4), 0) < AForm.Height then
        SetPiece(x, ',', 4, AForm.Height.ToString);
    end;
    AForm.SetBounds(StrToIntDef(Piece(x, ',', 1), AForm.Left),
                    StrToIntDef(Piece(x, ',', 2), AForm.Top),
                    StrToIntDef(Piece(x, ',', 3), AForm.Width),
                    StrToIntDef(Piece(x, ',', 4), AForm.Height));
    if not assigned(AForm.Parent) then
      ForceInsideWorkArea(AForm);
  end;
  if AForm.GetInterface(IORKeepBounds, kb) and assigned(kb) then
    kb.KeepBounds := True;
end;

function StrUserBounds(AControl: TControl): string;
var
  x: string;
begin
  x := GetControlName(AControl);
  if x = '' then
    Result := ''
  else
  begin
    with AControl do Result := 'B' + U + x + U + IntToStr(Left) + ',' + IntToStr(Top) + ',' +
                                                 IntToStr(Width) + ',' + IntToStr(Height);
    if (AControl is TForm) and (TForm(AControl).WindowState = wsMaximized) then
      Result := 'B' + U + x + U + '0,0,0,0';
  end;
end;

function StrUserBounds2(AName: string; v1, v2, v3, v4: integer): string;
begin
  Result := 'B' + U + AName + U + IntToStr(v1) + ',' + IntToStr(v2) + ',' +
                                  IntToStr(v3) + ',' + IntToStr(v4);
end;

function StrUserBoundsArray(AName: string; SizeArray: SettingSizeArray): string;
var
  i: integer;
begin
  Result := 'B' + U + AName + U;
  for i := 0 to (Length(SizeArray) - 1) do
  begin
    if i > 0 then
      Result := Result + ',';
    Result := Result + IntToStr(SizeArray[i]);
  end;
end;

function StrUserWidth(AControl: TControl): string;
var
  x: string;
begin
  x := GetControlName(AControl);
  if x = '' then
    Result := ''
  else
  begin
    with AControl do
      Result := 'W' + U + x + U + IntToStr(Width);
  end;
end;

function StrUserColumns(AControl: TControl): string;
var
  x: string;
  i: Integer;
  shouldSave: boolean;
begin
  x := GetControlName(AControl);
  if x = '' then
    Result := ''
  else
  begin
    shouldSave := False;
    if AnsiCompareText(x,'frmOrders.hdrOrders') = 0 then
      shouldSave := True;
    Result := 'C' + U + x + U;
    if AControl is THeaderControl then with THeaderControl(AControl) do
      for i := 0 to Sections.Count - 1 do
      begin
        if shouldSave and (i = 0) then
          Result := Result + IntToStr(frmOrders.EvtColWidth) + ','
        else
          Result := Result + IntToStr(Sections.Items[i].Width) + ',';
      end;
    if AControl is TCustomGrid then {nothing for now};
    if CharAt(Result, Length(Result)) = ',' then Result := Copy(Result, 1, Length(Result) - 1);
  end;
end;

function StrUserString(StrName: string; Str: string): string;
begin
  Result := 'C' + U + StrName + U + Str;
end;

{ TSizeHolder }

procedure TSizeHolder.AddSizesToStrList(theList: TStringList);
{Adds all the Sizes in the TSizeHolder Object to theList String list parameter}
var
  i: integer;
begin
  for i := 0 to FNameList.Count-1 do
    theList.Add('B' + U + FNameList[i] + U + FSizeList[i]);
end;

constructor TSizeHolder.Create;
begin
  inherited;
  FNameList := TStringList.Create;
  FSizeList := TStringList.Create;
end;


destructor TSizeHolder.Destroy;
begin
  FNameList.Free;
  FSizeList.Free;
  inherited;
end;

function TSizeHolder.GetSize(AName: String): String;
{Fuctions returns a String of the Size(s) Of the Name parameter passed,
 if the Size(s) are already loaded into the object it will return those,
 otherwise it will make the apropriate RPC call to LOADSIZ}
var
  rSizeVal: String; //return Size value
  nameIndex: integer;
begin
  rSizeVal := '';
  nameIndex := FNameList.IndexOf(AName);
  if nameIndex = -1 then //Currently Not in the NameList
  begin
    CallVistA('ORWCH LOADSIZ', [AName],rSizeVal);
    if rSizeVal <> '' then
    begin
      FNameList.Add(AName);
      FSizeList.Add(rSizeVal);
    end;
  end
  else //Currently is in the NameList
    rSizeVal := FSizeList[nameIndex];
  result := rSizeVal;
end;

procedure TSizeHolder.SetSize(AName, ASize: String);
{Store the Size(s) Of the ASize parameter passed, Associate it with the AName
 Parameter. This only stores the sizes in the objects member variables.
 to Store on the MUMPS Database call SendSizesToDB()}
var
  nameIndex: integer;
begin
  nameIndex := FNameList.IndexOf(AName);
  if nameIndex = -1 then //Currently Not in the NameList
  begin
    FNameList.Add(AName);
    FSizeList.Add(ASize);
  end
  else //Currently is in the NameList
    FSizeList[nameIndex] := ASize;
end;

function ProgramFilesDir: string;
var
  Registry: TRegistry;
begin
  Result := '';
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion');
    if (TOSVersion.Architecture = arIntelX64) then begin
      Result := Registry.ReadString('ProgramFilesDir (x86)');
    end else begin
      Result := Registry.ReadString('ProgramFilesDir');
    end;
    Registry.CloseKey;
    Result := IncludeTrailingPathDelimiter(Result);
  finally
    Registry.Free;
  end;
end;

function ApplicationDirectory: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
end;

function VistaCommonFilesDirectory: string;
begin
  Result := ProgramFilesDir + 'Vista\Common Files\';
end;

function DropADir(DirName: string): string;
var
  i: integer;
begin
  Result := DirName;
  i := Length(Result) - 1;
  while (i > 0) and (Result[i] <> '\') do dec(i);
  if (i = 0) then
    Result := ''
  else
    Result := IncludeTrailingPathDelimiter(copy(Result, 1, i));
end;

function RelativeCommonFilesDirectory: string;
begin
  Result := DropADir(ApplicationDirectory) + 'Common Files\';
end;

function FindDllDir(DllName: string): string;
begin
  if FileExists(ApplicationDirectory + DllName) then begin
    Result := ApplicationDirectory + DllName;
  end else if FileExists(RelativeCommonFilesDirectory + DllName) then begin
    Result := RelativeCommonFilesDirectory + DllName;
  end else if FileExists(VistaCommonFilesDirectory + DllName) then begin
    Result := VistaCommonFilesDirectory + DllName;
  end else begin
    Result := '';
  end;

end;

var
  ConfigureLoadOnce: boolean = True;
  LoadOnce: boolean = False;
  LoadedDLLs: TList<TDllRtnRec> = nil;

function LoadDll(DllName: string; CloseProc: TDLLCloseProc): TDllRtnRec;
var
  LibName, TmpStr, HelpTxt: string;
  i: integer;
  add2List: boolean;

  procedure ConfigLoadOnce;
  begin
    if ConfigureLoadOnce then
    begin
      ConfigureLoadOnce := False;
      LoadOnce := GetUserParam('OR CPRS DISABLE DLL LOAD ONCE') <> '1';
      if LoadOnce then
        LoadedDLLs := TList<TDllRtnRec>.Create;
    end;
  end;

  function LoadLib(Rec: TDllRtnRec): HMODULE;
  begin
    if Rec.LibName = '' then
      Result := LoadLibrary(PWideChar(Rec.DllName))
    else
      Result := LoadLibrary(PWideChar(Rec.LibName));
  end;

  procedure IncReferenceCount;
  begin
    if Result.Return_Type = DLL_Success then
      LoadLib(Result);
  end;

begin
  ConfigLoadOnce;
  if LoadOnce then
  begin
    for i := 0 to LoadedDLLs.count - 1 do
      if LoadedDLLs[i].DLLName = DLLName then
      begin
        Result := LoadedDLLs[i];
        if Result.Return_Type = DLL_Success then
        begin
          IncReferenceCount;
          exit;
        end
        else
          break;
      end;
  end;

  LibName := FindDllDir(DllName);
  Result.DLLName := DLLName;
  Result.LibName := LibName;
  Result.DLL_HWND := LoadLib(Result);
  Result.ForceCloseProc := CloseProc;
  add2List := False;
  if Result.DLL_HWND <> 0 then
  Begin
    // DLL exist
    Result.Return_Type := DLL_Success;
    // Now check for the version string
    TmpStr := DllVersionCheck(DLLName, ClientVersion(LibName));
    if Piece(TmpStr, U, 1) = '-1' then
    begin
      Result.Return_Message := StringReplace(Piece(TmpStr, U, 2), '#13', CRLF,
        [rfReplaceAll]);
      // DLL version mismatch
      Result.Return_Type := DLL_VersionErr;
      FreeLibrary(Result.DLL_HWND);
      Result.DLL_HWND := 0;
    end
    else
    begin
      add2List := True;
      Result.Return_Message := '';
    end;
  end
  else
  begin
    Result.Return_Type := DLL_Missing;
    HelpTxt := GetUserParam('OR CPRS HELP DESK TEXT');
    if Trim(HelpTxt) <> '' then
      HelpTxt := CRLF + CRLF + 'Please contact ' + HelpTxt +
        ' to obtain this file.';
    TmpStr := 'File must be located in one of these directories:' + CRLF +
      ApplicationDirectory + CRLF + RelativeCommonFilesDirectory + CRLF +
      VistaCommonFilesDirectory;
    Result.Return_Message := DLLName + ' was not found. ' + HelpTxt + CRLF +
      CRLF + TmpStr;
  end;
  if LoadOnce and Add2List then
  begin
    LoadedDLLs.Add(Result);
    IncReferenceCount;
  end;
end;

procedure ForceCloseAllDLLs;
var
  i: integer;

begin
  if LoadOnce then
    for i := LoadedDLLs.Count - 1 downto 0 do
      with LoadedDLLs[i] do
        if (Return_Type = DLL_Success) and (DLL_HWND <> 0) then
        begin
          if assigned(ForceCloseProc) then
            ForceCloseProc(DLL_HWND);
          // When LoadOnce is true LoadDll can load a DLL multiple times
          // to prevent FreeLibrary from actually freeing the DLL.  We call
          // FreeLibrary multiple times here to make sure the DLL is actually
          // unloaded.
          FreeLibrary(DLL_HWND);
          FreeLibrary(DLL_HWND);
          FreeLibrary(DLL_HWND);
          LoadedDLLs.Delete(i);
        end;
end;

function DllVersionCheck(DllName: string; DLLVersion: string): string;
begin
  CallVistA('ORUTL4 DLL', [DllName, DllVersion],Result);
end;

function GetMOBDLLName(): string;
begin
  Result := GetUserParam('OR MOB DLL NAME');
end;

function getPieceByFieldID(aSource: TStrings; anID: String; aPiece: Integer;
  Default: String = ''): String;
var
  s: String;
begin
  Result := Default;
  if not assigned(aSource) then
    exit;
  for s in aSource do
    if Piece(s, U, 1) = anID then
    begin
      Result := Piece(s, U, aPiece);
      break;
    end;
end;

function FindDT(aSource: TStrings; const FieldID: string; aPiece: Integer)
  : TFMDateTime;
var
  x: String;
begin
  Result := 0;
  x := getPieceByFieldID(aSource, FieldID, aPiece);
  if x <> '' then
    Result := MakeFMDateTime(x);
end;

function FindExt(aSource: TStrings; const FieldID: string;
  aPiece: Integer): string;
begin
  Result := getPieceByFieldID(aSource, FieldID, aPiece);
end;

function FindInt(aSource: TStrings; const FieldID: string;
  aPiece: Integer): Integer;
var
  x: String;
begin
  x := getPieceByFieldID(aSource, FieldID, aPiece);
  Result := StrToIntDef(x, 0);
end;

function FindInt64(aSource: TStrings; const FieldID: string;
  aPiece: Integer): Int64;
var
  x: String;
begin
  x := getPieceByFieldID(aSource, FieldID, aPiece);
  Result := StrToInt64Def(x, 0);
end;

function FindVal(aSource:TStrings;const FieldID: string;aPiece:Integer): string;
begin
  Result := getPieceByFieldID(aSource,FieldID,aPiece);
end;

procedure GetDDAttributes(Dest: TStrings; FileNum, FieldNum: Extended; Flags, Attributes: string);
begin
  CallVistA('ORWU FLDINFO', [FileNum, FieldNum, Flags, Attributes], Dest);
end;

initialization
  // nothing for now

finalization
  if uBounds  <> nil then uBounds.Free;
  if uWidths  <> nil then uWidths.Free;
  if uColumns <> nil then uColumns.Free;
  if assigned(uToolMenuItems) then
    FreeAndNil(uToolMenuItems);
  if assigned(LoadedDLLs) then
    FreeAndNil(LoadedDLLs);

end.
