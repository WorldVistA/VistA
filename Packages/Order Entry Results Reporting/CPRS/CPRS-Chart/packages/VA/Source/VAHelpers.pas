unit VAHelpers;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.StdCtrls,
  System.Generics.Collections,
  Vcl.ComCtrls;

type
  TVACustomListBoxHelper = class helper for TCustomListBox
  public
    /// <summary>Forces OnMeasureItem to be called again for each item</summary>
    procedure ForceItemHeightRecalc;
  end;

  TVAComponentHelper = class helper for TComponent
  private type
    TComponentVar = class(TObject)
    private
      FName: string;
      FValue: Variant;
    public
      property Name: string read FName write FName;
      property Value: Variant read FValue write FValue;
    end;

    TComponentVars = class(TObject)
    private
      FComponent: TComponent;
      FCVars: TObjectList<TComponentVar>;
      function IndexOf(AName: string): integer;
      function GetCVar(AName: string): Variant;
      procedure SetCVar(AName: string; const AValue: Variant);
    public
      constructor Create(AComponent: TComponent);
      destructor Destroy; override;
      property Component: TComponent read FComponent;
      property CVar[AName: string]: Variant read GetCVar write SetCVar;
    end;

    TComponentNotifier = class(TComponent)
    protected
      procedure Notification(AComponent: TComponent;
        Operation: TOperation); override;
    end;

  class var
    FCVarList: TObjectList<TComponentVars>;
    FNotifier: TComponentNotifier;
  private
    class constructor Create;
    class destructor Destroy;
    class function IndexOfComponentVars(AComponent: TComponent): integer;
    function GetCVar(AName: string): Variant;
    procedure SetCVar(AName: string; const AValue: Variant);
  public
    /// <summary>Allows storing component variables dynamically</summary>
    /// <param name="AName">Case insensitive name of the component variable</param>
    property CVar[AName: string]: Variant read GetCVar write SetCVar;
    /// <summary>Deletes a specific component variables</summary>
    /// <param name="AName">Case insensitive name of the component variable</param>
    procedure CVarDelete(AName: string);
    /// <summary>Deletes all component variables</summary>
    procedure CVarDeleteAll;
    /// <summary>Returns true if the component variable has been assigned</summary>
    /// <param name="AName">Case insensitive name of the component variable</param>
    function CVarExists(AName: string): boolean;
  end;

  TListViewHelper = class helper for TListView
  public
    procedure AutoSizeReportViewColumnWidths(
      const AMinWidth: Integer = -1; const AMaxWidth: Integer = -1);
    procedure AutoSizeReportViewHeight(const AVisibleRowCount: Integer);
  end;


implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl;

{ TVACustomListBoxHelper }

procedure TVACustomListBoxHelper.ForceItemHeightRecalc;
var
  I: integer;

begin
  for I := 0 to Items.Count - 1 do
    Items[I] := Items[I];
end;

{ TVAComponentHelper }

class constructor TVAComponentHelper.Create;
begin
  inherited;
  FCVarList := TObjectList<TComponentVars>.Create(True);
  FNotifier := TComponentNotifier.Create(nil);
end;

procedure TVAComponentHelper.CVarDelete(AName: string);
var
  idx, vidx: integer;

begin
  if assigned(Self) then
  begin
    idx := IndexOfComponentVars(Self);
    if idx >= 0 then
    begin
      vidx  := FCVarList[idx].IndexOf(AName);
      if vidx >= 0 then
        FCVarList[idx].FCVars.Delete(vidx);
    end;
  end;
end;

procedure TVAComponentHelper.CVarDeleteAll;
var
  idx: integer;

begin
  if assigned(Self) then
  begin
    idx := IndexOfComponentVars(Self);
    if idx >= 0 then
      FCVarList.Delete(idx);
  end;
end;

function TVAComponentHelper.CVarExists(AName: string): boolean;
var
  idx: integer;

begin
  Result := False;
  if assigned(Self) then
  begin
    idx := IndexOfComponentVars(Self);
    if idx >= 0 then
      Result := (FCVarList[idx].IndexOf(AName) >= 0);
  end;
end;

class destructor TVAComponentHelper.Destroy;
begin
  FNotifier.Free;
  FCVarList.Free;
  inherited;
end;

class function TVAComponentHelper.IndexOfComponentVars
  (AComponent: TComponent): integer;
begin
  for Result := 0 to FCVarList.Count - 1 do
    if FCVarList[Result].Component = AComponent then
      Exit;
  Result := -1;
end;

function TVAComponentHelper.GetCVar(AName: string): Variant;
var
  idx: integer;

begin
  if assigned(Self) then
  begin
    idx := IndexOfComponentVars(Self);
    if idx >= 0 then
     Exit(FCVarList[idx].CVar[AName]);
  end;
  raise EVariantError.Create(AName + ' not found.');
end;

procedure TVAComponentHelper.SetCVar(AName: string; const AValue: Variant);
var
  idx: integer;
  cVars: TComponentVars;

begin
  idx := IndexOfComponentVars(Self);
  if idx < 0 then
    cVars := TComponentVars.Create(Self)
  else
    cVars := FCVarList[idx];
  cVars.CVar[AName] := AValue;
end;

{ TVAComponentHelper.TComponentVars }

constructor TVAComponentHelper.TComponentVars.Create(AComponent: TComponent);
begin
  if not assigned(AComponent) then
    raise EComponentError.Create
      ('TVAComponentHelper.TComponentVars.Create requires a TComponent');
  inherited Create;
  FCVars := TObjectList<TComponentVar>.Create(True);
  FComponent := AComponent;
  FCVarList.Add(Self);
  FComponent.FreeNotification(FNotifier);
end;

destructor TVAComponentHelper.TComponentVars.Destroy;
begin
  FComponent.RemoveFreeNotification(FNotifier);
  FCVars.Free;
  inherited;
end;

function TVAComponentHelper.TComponentVars.GetCVar(AName: string): Variant;
var
  idx: integer;

begin
  idx := IndexOf(AName);
  if idx < 0 then
    raise EVariantError.Create(AName + ' not found.');
  Result := FCVars[idx].Value;
end;

function TVAComponentHelper.TComponentVars.IndexOf(AName: string): integer;
begin
  for Result := 0 to FCVars.Count - 1 do
    if CompareText(AName, FCVars[Result].Name) = 0 then
      Exit;
  Result := -1;
end;

procedure TVAComponentHelper.TComponentVars.SetCVar(AName: string;
  const AValue: Variant);
var
  idx: integer;
  CVar: TComponentVar;

begin
  idx := IndexOf(AName);
  if idx < 0 then
  begin
    CVar := TComponentVar.Create;
    CVar.Name := AName;
    FCVars.Add(CVar);
  end
  else
    CVar := FCVars[idx];
  CVar.Value := AValue;
end;

{ TVAComponentHelper.TComponentNotifier }

procedure TVAComponentHelper.TComponentNotifier.Notification
  (AComponent: TComponent; Operation: TOperation);
var
  idx: integer;

begin
  inherited;
  if Operation = opRemove then
  begin
    idx := IndexOfComponentVars(AComponent);
    if idx >= 0 then
      FCVarList.Delete(idx);
  end;
end;

{ TListViewHelper }

procedure TListViewHelper.AutoSizeReportViewColumnWidths(
  const AMinWidth: Integer; const AMaxWidth: Integer);
var
  AColumn, AItem: Integer;
  AHeaderWidth, AItemWidth: Integer;
  ACellCaption: string;
  ANewWidth: Integer;
begin
  if ViewStyle <> vsReport then Exit;

  Columns.BeginUpdate;
  LockDrawing;
  try
    for AColumn := 0 to Columns.Count - 1 do
    begin
      ANewWidth := LVSCW_AUTOSIZE_USEHEADER; // Auto-size to fit the header text

      if AMinWidth > -1 then Columns[AColumn].MinWidth := AMinWidth;
      if AMaxWidth > -1 then Columns[AColumn].MaxWidth := AMaxWidth;

      AHeaderWidth := ListView_GetStringWidth(Handle,
        PChar(Columns[AColumn].Caption));

      for AItem := 0 to Items.Count - 1 do
      begin
        // The first column uses Items and the rest use SubItems
        if AColumn = 0 then
          ACellCaption := Items[AItem].Caption
        else if AColumn <= Items[AItem].SubItems.Count  then
          ACellCaption := Items[AItem].SubItems[AColumn - 1]
        else
          ACellCaption := '';

        AItemWidth := ListView_GetStringWidth(Handle, PChar(ACellCaption));

        // Check if the cell caption is larger than the header caption
        if AItemWidth > AHeaderWidth then
        begin
          ANewWidth := LVSCW_AUTOSIZE; // Auto-size to fit the item text
          Break;
        end;
      end;

      Columns[AColumn].Width := ANewWidth;
    end;
  finally
    UnlockDrawing;
    Columns.EndUpdate;
  end;
end;

procedure TListViewHelper.AutoSizeReportViewHeight(const AVisibleRowCount: Integer);
begin
  if ViewStyle <> vsReport then Exit;

  // HiWord is height, LoWord is width
  ClientHeight := HiWord(ListView_ApproximateViewRect(Handle, Height, Width, AVisibleRowCount));
end;

end.
