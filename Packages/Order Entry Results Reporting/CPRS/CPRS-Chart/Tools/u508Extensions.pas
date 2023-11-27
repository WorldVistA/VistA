// Mandatory unit header per GUI SAC, Section 6.1.1
// Package: Provider Role Tool GUI application
// Date Created: August 2017
// Site Name: CPRS EP1 Remote Development Team
// Developers: Chris Bell (Delphi)
// Jamie Crumley (M)
// Description:
// Note: This application requires OR_3_453 in order to run.

unit U508Extensions;

interface

uses Vcl.StdCtrls, Winapi.Messages, Vcl.Controls, Graphics,
  System.SysUtils, System.Classes, Vcl.Forms, vaUtils, Winapi.Windows,
  ComCtrls, VA508AccessibilityManager, ORCtrls;

type
  TStaticTextFocusRect = class(Vcl.StdCtrls.TStaticText)
  private
    FControl: TWinControl;
    FControlType: string;
    F508Manager: TVA508AccessibilityManager;
    FCaptionSet: boolean;
    FFocused: boolean;
    FCanvas: TCanvas;
  protected
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    procedure UpdateSize;
    procedure UpdateCaption(const aCaption: string);
  end;

  tIntArray = Array of Integer;

  Ttv508Manager = class(TVA508ComponentManager)
  private
    fReadParent: Boolean;
    fParentText: String;
    fHC: THeaderControl;
    fTextPieces: tIntArray;
    Function GetParentText(Node: TORTreeNode): String;
    Function GetText(Node: TORTreeNode): String;
  public
    // constructor Create; override;
    constructor Create(HeaderControl: THeaderControl;
      TextPieces: tIntArray); overload;
    constructor Create(HeaderControl: THeaderControl; TextPieces: tIntArray;
      ReadParent: Boolean; ParentText: String); overload;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
  end;

  Tlv508Manager = class(TVA508ComponentManager)
  private
    Function GetText(ListItem: TListItem; ListView: TListView): String;
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
  end;

function FindControl508Manager(aControl: TWinControl)
  : TVA508AccessibilityManager;

function CreateHiddenStaticText(aControl: TWinControl;
  const aType, aCaption: string): TStaticTextFocusRect;

var
  ScreenReaderActiveOnStartup: boolean;

implementation

uses
  System.TypInfo, uMisc, VA508AccessibilityRouter;

const
  StaticTextFocusOffset = 1;

constructor TStaticTextFocusRect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
end;

procedure TStaticTextFocusRect.UpdateSize;
begin
  SetBounds(FControl.Left - StaticTextFocusOffset, FControl.Top - StaticTextFocusOffset,
    FControl.Width + StaticTextFocusOffset * 2, FControl.Height + StaticTextFocusOffset * 2);
end;

procedure TStaticTextFocusRect.UpdateCaption(const aCaption: string);
begin
  Caption := Format('%s %s Disabled', [aCaption, FControlType]);
end;

procedure TStaticTextFocusRect.WMSetFocus(var Message: TWMSetFocus);
var
  PropStr: string;
begin
  if (F508Manager <> nil) and not FCaptionSet then
  begin
    if F508Manager.AccessData.FindItem(FControl, False) <> nil then
    begin
      if not F508Manager.UseDefault[FControl] then
      begin
        if F508Manager.AccessText[FControl] <> '' then
          Caption := Format('%s %s Disabled',
            [F508Manager.AccessText[FControl], FControlType])
        else if F508Manager.AccessLabel[FControl] <> nil then
          Caption := Format('%s %s Disabled',
            [F508Manager.AccessLabel[FControl].Caption, FControlType])
        else if F508Manager.AccessProperty[FControl] <> '' then
        begin
          PropStr := GetPropValue(FControl, F508Manager.AccessProperty[FControl]);
          Caption := Format('%s %s Disabled', [PropStr, FControlType]);
        end;
      end;
    end;
    FCaptionSet := True;
  end;
  FFocused := True;
  Invalidate;
  inherited;
end;

procedure TStaticTextFocusRect.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocused := False;
  Invalidate;
  inherited;
end;

procedure TStaticTextFocusRect.WMPaint(var Message: TWMPaint);
begin
  inherited;
  FCanvas.Lock;
  try
    FCanvas.Handle := Message.DC;
    try
      TControlCanvas(FCanvas).UpdateTextFlags;
      FCanvas.Brush.Color := Color;
      FCanvas.FillRect(ClientRect);
      if FFocused then
        FCanvas.DrawFocusRect(ClientRect);
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

{$REGION 'TreeView508Manager'}

constructor Ttv508Manager.Create(HeaderControl: THeaderControl;
  TextPieces: tIntArray);
begin
  if not assigned(HeaderControl) then
    exit;
  Create(HeaderControl, TextPieces, False, '');
end;

constructor Ttv508Manager.Create(HeaderControl: THeaderControl;
  TextPieces: tIntArray; ReadParent: Boolean; ParentText: String);
begin
  if not assigned(HeaderControl) then
    exit;

  inherited Create([mtValue, mtItemChange]);
  fHC := HeaderControl;
  fReadParent := ReadParent;
  fParentText := ParentText;
  fTextPieces := TextPieces;
end;

function Ttv508Manager.GetItem(Component: TWinControl): TObject;
var
  tv: TORTreeView;
begin
  Result := nil;
  if assigned(Component) and (Component is TORTreeView) then
  begin
    tv := TORTreeView(Component);
    Result := tv.Selected;
  end;
end;

function Ttv508Manager.GetParentText(Node: TORTreeNode): String;
begin
  Result := '';
  if assigned(Node) then
  begin
    if assigned(Node.Parent) then
      Result := fParentText + ' ' + Node.Parent.Caption
  end;
end;

function Ttv508Manager.GetText(Node: TORTreeNode): String;
var
  I: Integer;
  AddTxt: String;
begin
  Result := '';
  if assigned(Node) then
  begin
    if fReadParent then
      Result := GetParentText(Node);

    if ((Node.Level = 0) or (Node.HasChildren)) then
      Result := fParentText + ' ' + Node.Caption
    else
    begin
      AddTxt := '';
      for I := 0 to fHC.Sections.Count - 1 do
      begin
        AddTxt := fHC.Sections[I].Text;
        if I <= High(fTextPieces) then
          AddTxt := AddTxt + ' ' + Piece(Node.StringData, '^', fTextPieces[I]);
        Result := Result + ' ' + AddTxt;
      end;
    end;
  end;
end;

function Ttv508Manager.GetValue(Component: TWinControl): string;
var
  Node: TORTreeNode;
begin
  if assigned(Component) and (Component is TORTreeView) then
  begin
    Node := TORTreeNode(TORTreeView(Component).Selected);
    if assigned(Node) then
      Result := GetText(Node);
  end;
end;
{$ENDREGION}

function GetRealParentForm(Control: TControl; TopForm: Boolean = True): TCustomForm;
begin
  while (TopForm or not (Control is TCustomForm)) and (Control.Parent <> nil) do
    Control := Control.Parent;
  if Control is TCustomForm then
    Result := TCustomForm(Control) else
    Result := nil;
end;

function FindControl508Manager(aControl: TWinControl)
  : TVA508AccessibilityManager;
var
  aParentForm: TCustomForm;
  ii: integer;
begin
{$WARN SYMBOL_PLATFORM OFF}
  try
    if DebugHook = 0 then
      Result := GetComponentManager(aControl)
    else
      Result := nil;
  except
    Result := nil;
  end;
  if Result = nil then
  begin
    aParentForm := GetRealParentForm(aControl);
    if aParentForm <> nil then
    begin
      for ii := 0 to aParentForm.ComponentCount - 1 do
      begin
        if aParentForm.Components[ii] is TVA508AccessibilityManager then
        begin
          Result := TVA508AccessibilityManager(aParentForm.Components[ii]);
          break;
        end;
      end;
    end;
  end;
{$WARN SYMBOL_PLATFORM ON}
end;

function CreateHiddenStaticText(aControl: TWinControl;
  const aType, aCaption: string): TStaticTextFocusRect;
begin
  Result := TStaticTextFocusRect.Create(aControl.Owner);
  Result.Parent := aControl.Parent;
  Result.SendToBack;
  Result.FControl := aControl;
  Result.FControlType := aType;
  Result.F508Manager := FindControl508Manager(aControl);
  Result.TabStop := True;
  Result.TabOrder := aControl.TabOrder;
  Result.UpdateCaption(aCaption);
  Result.UpdateSize;
end;

{$REGION 'ListView508Manager'}

constructor Tlv508Manager.Create;
begin
  inherited Create([mtValue, mtItemChange]);
end;

function Tlv508Manager.GetItem(Component: TWinControl): TObject;
var
  lv: TListView;
begin
  Result := nil;
  if Component is TListView then
  begin
    lv := TListView(Component);
    if assigned(lv) then
      Result := lv.Selected;
  end;
end;

function Tlv508Manager.GetValue(Component: TWinControl): string;
var
  lv: TListView;
  lvItm: TListItem;
begin
  if assigned(Component) and (Component is TListView) then
  begin
    lv := TListView(Component);
    lvItm := lv.Selected;
    Result := GetText(lvItm, lv);
  end;
end;

function Tlv508Manager.GetText(ListItem: TListItem;
  ListView: TListView): String;

  function GetTextOrBlank(const aValue: string): string;
  begin
    if Trim(aValue) = '' then
      Result := 'blank'
    else
      Result := aValue;
  end;

var
  I: Integer;
  AddTxt: String;
  Group: TListGroup;
begin
  Result := '';

  if assigned(ListItem) and assigned(ListView) then
  begin

    if ListView.GroupView then
    begin
      Group := ListView.Groups.FindItemByGroupID(ListItem.GroupID);
      if assigned(Group) then
        Result := 'Group: ' + Group.Header;
    end;

    for I := 0 to ListView.Columns.Count - 1 do
    begin
      AddTxt := '';
      if I = 0 then
        AddTxt := ListView.Columns[I].Caption + ', ' + GetTextOrBlank(ListItem.Caption)
      else
      begin
        if (I - 1) < ListItem.SubItems.Count then
          AddTxt := ListView.Columns[I].Caption + ', ' + GetTextOrBlank(ListItem.SubItems[I - 1]);
      end;

      Result := Result + ' ' + AddTxt + ', ';
    end;
  end;

end;

{$ENDREGION}

initialization
  ScreenReaderActiveOnStartup := ScreenReaderSystemActive;
end.
