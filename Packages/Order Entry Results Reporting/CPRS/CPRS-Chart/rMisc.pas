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

function DetailPrimaryCare(const DFN: string): TStrings;  //*DFN*
procedure GetToolMenu;
procedure ListSymbolTable(Dest: TStrings);
function MScalar(const x: string): string;
procedure SetShareNode(const DFN: string; AHandle: HWND);  //*DFN*
function ServerHasPatch(const x: string): Boolean;
function SiteSpansIntlDateLine: boolean;
function RPCCheck(aRPC: TStrings):Boolean;
function ServerVersion(const Option, VerClient: string): string;
function PackageVersion(const Namespace: string): string;

function ProgramFilesDir: string;
function ApplicationDirectory: string;
function VistaCommonFilesDirectory: string;
function DropADir(DirName: string): string;
function RelativeCommonFilesDirectory: string;
function FindDllDir(DllName: string): string;
function LoadDll(DllName: string): HMODULE;
function DllVersionCheck(DllName: string; DLLVersion: string): string;

procedure SaveUserBounds(AControl: TControl);
procedure SaveUserSizes(SizingList: TStringList);
procedure SetFormPosition(AForm: TForm);
procedure SetUserBounds(var AControl: TControl);
procedure SetUserBounds2(AName: string; var v1, v2, v3, v4: integer);
procedure SetUserBoundsArray(AName: string; var SettingArray: SettingSizeArray);
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

var
  SizeHolder : TSizeHolder;

implementation

uses TRPCB, fOrders, math, Registry;

var
  uBounds, uWidths, uColumns: TStringList;

function DetailPrimaryCare(const DFN: string): TStrings;  //*DFN*
begin
  CallV('ORWPT1 PCDETAIL', [DFN]);
  Result := RPCBrokerV.Results;
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
  i, p, LastIdx, count, MenuCount: Integer;
  id, x: string;
  LastItem, item: TToolMenuItem;
  caption, action: string;
  CurrentMenuID: string;
  MenuIDs: TStringList;
begin
  if not assigned(uToolMenuItems) then
    uToolMenuItems := TObjectList.Create
  else
    uToolMenuItems.Clear;
  CallV('ORWU TOOLMENU', [nil]);
  MenuIDs := TStringList.Create;
  try
    for i := 0 to RPCBrokerV.Results.Count - 1 do
    begin
      x := Piece(RPCBrokerV.Results[i], U, 1);
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
    LastIdx := (MAX_TOOLITEMS - 1);
    count := 0;
    CurrentMenuID := '';
    i := 0;
    LastItem := nil;
    MenuCount := 0;
    repeat
      item := TToolMenuItem(uToolMenuItems[i]);
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
          uToolMenuItems.Insert(LastIdx, item);
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
end;

procedure ListSymbolTable(Dest: TStrings);
var
  i: Integer;
  x: string;
begin
  Dest.Clear;
  CallV('ORWUX SYMTAB', [nil]);
  i := 0;
  with RPCBrokerV.Results do while i < Count do
  begin
    x := Strings[i] + '=';
    Inc(i);
    if i < Count then x := x + Strings[i];
    Dest.Add(x);
    Inc(i);
  end;
end;

function MScalar(const x: string): string;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'XWB GET VARIABLE VALUE';
    Param[0].Value := x;
    Param[0].PType := reference;
    CallBroker;
    Result := Results[0];
  end;
end;

function ServerHasPatch(const x: string): Boolean;
begin
  Result := sCallV('ORWU PATCH', [x]) = '1';
end;

function SiteSpansIntlDateLine: boolean;
begin
  Result := sCallV('ORWU OVERDL', []) = '1';
end;

function RPCCheck(aRPC: TStrings):Boolean; //aRPC format array of RPC's Name^Version
//All RPC's in the list must come back true/active
var
  i: integer;
begin
  Result := false;
  CallV('XWB ARE RPCS AVAILABLE',['L',aRPC]);
  if RPCBrokerV.Results.Count > 0 then
    for i := 0 to RPCBrokerV.Results.Count - 1 do
      begin
        if RPCBrokerV.Results[i] = '1' then
          Result := true
        else
          begin
            Result := false;
            Break;
          end;
      end;
end;

function ServerVersion(const Option, VerClient: string): string;
begin
  Result := sCallV('ORWU VERSRV', [Option, VerClient]);
end;

function PackageVersion(const Namespace: string): string;
begin
  Result := sCallV('ORWU VERSION', [Namespace]);
end;

function UserFontSize: integer;
begin
  Result := StrToIntDef(sCallV('ORWCH LDFONT', [nil]),8);
  If Result = 24 then Result := 18; // CQ #12322 removed 24 pt font
end;

procedure LoadSizes;
var
  i, p: Integer;
begin
  uBounds  := TStringList.Create;
  uWidths  := TStringList.Create;
  uColumns := TStringList.Create;
  CallV('ORWCH LOADALL', [nil]);
  with RPCBrokerV do
  begin
    for i := 0 to Results.Count - 1 do    // change '^' to '='
    begin
      p := Pos(U, Results[i]);
      if p > 0 then Results[i] := Copy(Results[i], 1, p - 1) + '=' +
                                  Copy(Results[i], p + 1, Length(Results[i]));
    end;
    ExtractItems(uBounds,  RPCBrokerV.Results, 'Bounds');
    ExtractItems(uWidths,  RPCBrokerV.Results, 'Widths');
    ExtractItems(uColumns, RPCBrokerV.Results, 'Columns');
  end;
end;

procedure SetShareNode(const DFN: string; AHandle: HWND);  //*DFN*
begin
  // sets node that allows other apps to see which patient is currently selected
  sCallV('ORWPT SHARE', [DottedIPStr, IntToHex(AHandle, 8), DFN]);
end;

procedure SetUserBounds(var AControl: TControl);
var
  x: string;
begin
  if uBounds = nil then LoadSizes;
  x := AControl.Name;
  if not (AControl is TForm) and (Assigned(AControl.Owner)) then x := AControl.Owner.Name + '.' + x;
  x := uBounds.Values[x];
  if (x = '0,0,0,0') and (AControl is TForm)
    then TForm(AControl).WindowState := wsMaximized
    else
    begin
      AControl.Left   := HigherOf(StrToIntDef(Piece(x, ',', 1), AControl.Left), 0);
      AControl.Top    := HigherOf(StrToIntDef(Piece(x, ',', 2), AControl.Top), 0);
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
    end;
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


procedure SetUserWidths(var AControl: TControl);
var
  x: string;
begin
  if uWidths = nil then LoadSizes;
  x := AControl.Name;
  if not (AControl is TForm) and (Assigned(AControl.Owner)) then x := AControl.Owner.Name + '.' + x;
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
  couldSet := False;
  if uColumns = nil then LoadSizes;
  x := AControl.Name;
  if not (AControl is TForm) and (Assigned(AControl.Owner)) then x := AControl.Owner.Name + '.' + x;
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

procedure SaveUserBounds(AControl: TControl);
var
  x: string;
  NewHeight: integer;
begin
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
  SizeHolder.SetSize(AControl.Name, x);
end;

procedure SaveUserSizes(SizingList: TStringList);
begin
  CallV('ORWCH SAVEALL', [SizingList]);
end;

procedure SaveUserFontSize( FontSize: integer);
begin
  CallV('ORWCH SAVFONT', [IntToStr(FontSize)]);
end;

procedure SetFormPosition(AForm: TForm);
var
  x: string;
  Rect: TRect;
begin
//  x := sCallV('ORWCH LOADSIZ', [AForm.Name]);
  x := SizeHolder.GetSize(AForm.Name);
  if x = '' then Exit; // allow default bounds to be passed in, else screen center?
  if (x = '0,0,0,0') then
    AForm.WindowState := wsMaximized
  else
  begin
    AForm.SetBounds(StrToIntDef(Piece(x, ',', 1), AForm.Left),
                    StrToIntDef(Piece(x, ',', 2), AForm.Top),
                    StrToIntDef(Piece(x, ',', 3), AForm.Width),
                    StrToIntDef(Piece(x, ',', 4), AForm.Height));
    Rect := AForm.BoundsRect;
    ForceInsideWorkArea(Rect);
    AForm.BoundsRect := Rect;
  end;
end;

function StrUserBounds(AControl: TControl): string;
var
  x: string;
begin
  x := AControl.Name;
  if not (AControl is TForm) and (Assigned(AControl.Owner)) then x := AControl.Owner.Name + '.' + x;
  with AControl do Result := 'B' + U + x + U + IntToStr(Left) + ',' + IntToStr(Top) + ',' +
                                               IntToStr(Width) + ',' + IntToStr(Height);
  if (AControl is TForm) and (TForm(AControl).WindowState = wsMaximized)
    then Result := 'B' + U + x + U + '0,0,0,0';
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
  for i := 0 to (Length(SizeArray) - 1) do begin
    Result := Result + ',' + IntToStr(SizeArray[i]);
  end;
end;

function StrUserWidth(AControl: TControl): string;
var
  x: string;
begin
  x := AControl.Name;
  if not (AControl is TForm) and (Assigned(AControl.Owner)) then x := AControl.Owner.Name + '.' + x;
  with AControl do Result := 'W' + U + x + U + IntToStr(Width);
end;

function StrUserColumns(AControl: TControl): string;
var
  x: string;
  i: Integer;
  shouldSave: boolean;
begin
  shouldSave := False;
  x := AControl.Name;
  if not (AControl is TForm) and (Assigned(AControl.Owner)) then x := AControl.Owner.Name + '.' + x;
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
    rSizeVal := sCallV('ORWCH LOADSIZ', [AName]);
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

function LoadDll(DllName: string): HMODULE;
var
  LibName: string;
begin
  LibName := FindDllDir(DllName);
  if LibName = '' then begin
    Result := LoadLibrary(PWideChar(DllName));
  end else begin
    Result := LoadLibrary(PWideChar(LibName));
  end;
end;

function DllVersionCheck(DllName: string; DLLVersion: string): string;
begin
  Result := sCallV('ORUTL4 DLL', [DllName, DllVersion]);
end;

initialization
  // nothing for now

finalization
  if uBounds  <> nil then uBounds.Free;
  if uWidths  <> nil then uWidths.Free;
  if uColumns <> nil then uColumns.Free;
  if assigned(uToolMenuItems) then
    FreeAndNil(uToolMenuItems);

end.
