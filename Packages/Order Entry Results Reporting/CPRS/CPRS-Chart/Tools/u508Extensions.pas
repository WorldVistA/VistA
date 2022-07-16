unit u508Extensions;

interface

uses vcl.ComCtrls, vcl.Controls, VA508AccessibilityManager;

type
  Tlv508Manager = class(TVA508ComponentManager)
  private
    Function GetText(ListItem: TListItem; ListView: TListView): String;
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
  end;

implementation

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
//
//    if ListView.GroupView then
//    begin
//      Group := ListView.Groups.FindItemByGroupID(ListItem.GroupID);
//      if assigned(Group) then
//        Result := 'Group: ' + Group.Header;
//    end;

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
