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

uses Vcl.StdCtrls, Winapi.Messages, Vcl.Controls,
  System.SysUtils, System.Classes, Vcl.Forms, vaUtils, Winapi.Windows,
  ComCtrls, VA508AccessibilityManager, ORCtrls;

const
  WM_FREE508LBL = WM_USER + 1;

type
  TButton = class(Vcl.StdCtrls.TButton)
  private
    fMgr: TVA508AccessibilityManager;
    f508Label: TVA508StaticText;
    fScreenReaderActive: Boolean;
    fClicking: boolean;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    Procedure WMFree508Lbl(var Msg: TMessage); message WM_FREE508LBL;
    procedure RegisterWithMGR;
  public
    constructor Create(AControl: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
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

implementation

uses
uMisc;
//  uUtilities;

{$REGION '508Button'}

constructor TButton.Create(AControl: TComponent);
begin
  inherited Create(AControl);
  fScreenReaderActive := ScreenReaderActive;
  fMgr := nil;
end;

procedure TButton.RegisterWithMGR;
var
  aFrm: TCustomForm;
  I: Integer;
begin
  if not assigned(fMgr) then
  begin
    aFrm := GetParentForm(self);
    for I := 0 to aFrm.ComponentCount - 1 do
    begin
      if aFrm.Components[I] is TVA508AccessibilityManager then
      begin
        fMgr := TVA508AccessibilityManager(aFrm.Components[I]);
        break;
      end;
    end;
  end;

  if assigned(fMgr) then
    fMgr.AccessData.EnsureItemExists(f508Label);
end;

procedure TButton.Click;
begin
  if fClicking then
    exit;
  fClicking := True;
  try
    inherited;
  finally
    fClicking := False;
  end;
end;

procedure TButton.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if not fScreenReaderActive then
    exit;

  if not self.Enabled then
  begin
    f508Label := TVA508StaticText.Create(self);
    f508Label.Parent := self.Parent;
    f508Label.SendToBack;
    // self.SendToBack;
    f508Label.TabStop := true;
    f508Label.TabOrder := self.TabOrder;
    f508Label.Caption := ' ' + self.Caption + ' button disabled';
    f508Label.Top := self.Top - 2;
    f508Label.Left := self.Left - 2;
    f508Label.Width := self.Width + 5;
    f508Label.Height := self.Height + 5;
    RegisterWithMGR;
  end
  else
  begin
    PostMessage(self.Handle, WM_FREE508LBL, 0, 0);
  end;
end;

procedure TButton.WMSize(var Msg: TMessage);
begin
  inherited;
  if not fScreenReaderActive then
    exit;

  if assigned(f508Label) then
  begin
    f508Label.Top := self.Top - 2;
    f508Label.Left := self.Left - 2;
    f508Label.Width := self.Width + 5;
    f508Label.Height := self.Height + 5;
  end;
end;

Procedure TButton.WMFree508Lbl(var Msg: TMessage);
begin
  FreeAndNil(f508Label);
end;

destructor TButton.Destroy;
begin
  Inherited;
end;
{$ENDREGION}
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

    AddTxt := '';
    for I := 0 to ListView.Columns.Count - 1 do
    begin
      if I = 0 then
        AddTxt := ListView.Columns[I].Caption + ' ' + ListItem.Caption
      else
        AddTxt := ListView.Columns[I].Caption + ' ' + ListItem.SubItems[I - 1];

      Result := Result + ' ' + AddTxt;
    end;
  end;

end;

{$ENDREGION}

end.
