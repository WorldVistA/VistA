{*********************************************************}
{*                    OVCMRU.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

(*Changes)

  02/19/02 - Modify the hint property to default to the item text.
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcmru;
  {-most recent used (MRU) file list}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Menus,
  Forms,
  Controls,
  OvcBase,
  OvcExcpt,
  OvcConst,
  OvcFiler,
  OvcMisc;

type
  TOvcMRUOption = (moAddAccelerators, moStripPath, moAddSeparator);
  TOvcMRUAddPosition = (apAnchor, apTop, apBottom);
  TOvcMRUStyle = (msNormal, msSplit);
  TOvcMRUClickAction = (caMoveToTop, caRemove, caNoAction);

  TOvcMRUOptions = set of TOvcMRUOption;

  TOvcMRUClickEvent = procedure (Sender : TObject;
                                 const ItemText : string;
                                 var Action : TOvcMRUClickAction)
                                 of object;
  { Used internally. }
  TOvcMRUAddPositions = set of TOvcMRUAddPosition;


  TOvcMenuMRU = class(TOvcComponent)

  protected {private}
    {property variables}
    FAddPosition  : TOvcMRUAddPosition;
    FAnchorItem   : TMenuItem;
    FCount        : Integer;
    FEnabled      : Boolean;
    FGroupIndex   : Integer;
    FHint         : string;
    FItems        : TStrings;
    FMaxItems     : Integer;
    FMaxMenuWidth : Integer;
    FMenuItem     : TMenuItem;
    FOptions      : TOvcMRUOptions;
    FStyle        : TOvcMRUStyle;
    FStore        : TOvcAbstractStore;
    FVisible      : Boolean;

    {events}
    FOnClick   : TOvcMRUClickEvent;

    {internal variables}
    mruSplits         : TOvcMRUAddPositions;
    mruDisableUpdates : Boolean;
    mruStoreKey       : string;

  protected
    {property methods}
    function  GetCount: Integer;
    procedure SetAnchorItem(const Value : TMenuItem);
    procedure SetEnabled(const Value: Boolean);
    procedure SetGroupIndex(const Value: Integer);
    procedure SetHint(const Value: string);
    procedure SetItems(const Value : TStrings);
    procedure SetMaxItems(const Value : Integer);
    procedure SetMaxMenuWidth(const Value : Integer);
    procedure SetMenuItem(const Value : TMenuItem);
    procedure SetOptions(const Value : TOvcMRUOptions);
    procedure SetStyle(const Value : TOvcMRUStyle);
    procedure SetVisible(const Value : Boolean);
    procedure DoClick(const Value : string; var Action : TOvcMRUClickAction);

    {internal functions}
    procedure GenerateMenuItems;
    procedure ListChange(Sender : TObject);
    procedure MenuClick(Sender : TObject);
    function  FixupDisplayString(S : string; N : Integer) : string;
    procedure LoadList;
    procedure StoreList;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure Loaded;
      override;
    procedure Notification(Component: TComponent;
                           Operation: TOperation);
      override;
    procedure Add(const Value : string);
    procedure AddSplit(const Value : string; Position : TOvcMRUAddPosition);
    procedure Clear;
    procedure Remove(const Value : string);
    property Count : Integer
      read GetCount;


  published
    property AddPosition : TOvcMRUAddPosition
      read FAddPosition
      write FAddPosition default apAnchor;

    property AnchorItem : TMenuItem
      read FAnchorItem
      write SetAnchorItem;

    property Enabled : Boolean
      read FEnabled
      write SetEnabled
      default True;

    property GroupIndex : Integer
      read FGroupIndex
      write SetGroupIndex
      default 0;

    property Hint : string
      read FHint
      write SetHint;

    property Items : TStrings
      read FItems
      write SetItems;

    property MaxItems : Integer
      read FMaxItems
      write SetMaxItems default 4;

    property MaxMenuWidth : Integer
      read FMaxMenuWidth
      write SetMaxMenuWidth default 0;

    property MenuItem : TMenuItem
      read FMenuItem
      write SetMenuItem;

    property Options : TOvcMRUOptions
      read FOptions
      write SetOptions
      default [moAddAccelerators, moAddSeparator];

    property Store : TOvcAbstractStore
      read FStore
      write FStore;

    property Style : TOvcMRUStyle
      read FStyle
      write SetStyle default msNormal;

    property Visible : Boolean
      read FVisible
      write SetVisible
      default True;

    {events}
    property OnClick : TOvcMRUClickEvent
      read FOnClick
      write FOnClick;

  end;


implementation

{ TOvcMenuMRU }

constructor TOvcMenuMRU.Create(AOwner: TComponent);
var
  I  : Integer;
  S  : string;
begin
  inherited Create(AOwner);
  FItems        := TStringList.Create;
  FEnabled      := True;
  FGroupIndex   := 0;
  FMaxItems     := 4;
  FMaxMenuWidth := 0;
  FAnchorItem   := nil;
  FOptions      := [moAddAccelerators, moAddSeparator];
  FAddPosition  := apAnchor;
  FStyle        := msNormal;
  FVisible      := True;

  mruSplits        := [];

  with FItems as TStringList do
    OnChange := ListChange;

  { Assume the user wants MS Office-style MRU lists. }
  { This will place the MRU list above the Exit menu }
  { item on the File menu. }
  if csDesigning in ComponentState then
    with Owner as TForm do begin
      { No menu on the form - exit. }
      if (Menu = nil) or (Menu.Items.Count =0) then
        Exit;
      { Assume the File menu is the first top-level menu. }
      FMenuItem := Menu.Items[0];
      { Look for the Exit menu item. }
      for I := Pred(FMenuItem.Count) downto 0 do begin
        S := AnsiUpperCase(FMenuItem.Items[I].Caption);
        if (S = 'E&XIT') or (S = 'EXIT') then
          { Set AnchorItem to the Exit menu item. }
          FAnchorItem := FMenuItem.Items[I];
      end;
    end;
end;

destructor TOvcMenuMRU.Destroy;
begin
  if Assigned(FStore) then
    StoreList;
  FItems.Free;
  inherited Destroy;
end;

procedure TOvcMenuMRU.Loaded;
begin
  inherited Loaded;
  if Assigned(FStore) then
    FStore.FreeNotification(Self);
  FItems.Clear;
  mruDisableUpdates := True;
  try
    LoadList;
  finally
    mruDisableUpdates := False;
  end;
  GenerateMenuItems;
end;

procedure TOvcMenuMRU.Notification(Component: TComponent;
                                   Operation: TOperation);
begin
  inherited Notification(Component, Operation);

  if (Operation = opRemove) then begin
    if (Component is TControl) then begin
      if (Component is TMenuItem) then begin
        if TMenuItem(Component) = FAnchorItem then
          AnchorItem := nil
        else if TMenuItem(Component) = FMenuItem then
          MenuItem := nil;
      end;
    end else if (Component is TOvcAbstractStore) then begin
      if TOvcAbstractStore(Component) = FStore then
      begin
        StoreList;    //added storelist otherwise MRUList would not be saved
        Store := nil; //we can not be sure that store will exist later on - but data has been saved and Store is not referenced from in here
      end;
    end;
  end;
end;


{ Add method. Adds an item to the MRU list. }
procedure TOvcMenuMRU.Add(const Value : string);
var
  I : Integer;
begin
  if (FStyle = msSplit) then
    raise EMenuMRUError.CreateRes(SCInvalidOperation);
  { Check to see if the item is already in the list. }
  { If the file being added is already the first item }
  { in the list then in the case where the first item refers to a}
  { file that no longer exists and the programmer wants to remove the}
  { item, immediately exiting does not properly update the list and even}
  { when the Remove method is properly called, the list is not updated,}
  { i.e., the removed item is still displayed but clicking on anything}
  { below it can generate a "List Index out of bounds" exception}
  mruDisableUpdates := True;
  if (FItems.Count > 0) then begin
    if (AnsiCompareText(FItems[0], Value) = 0) then begin
      mruDisableUpdates := False;
      GenerateMenuItems;
      Exit;
    end;
    for I := pred(FItems.Count) downto 0 do begin
      if (AnsiCompareText(FItems[I], Value) = 0) then begin
        FItems.Delete(I);
        break;
      end;
    end;
  end;

  { Add the string to the list. }
  FItems.Insert(0, Value);
  { Remove last entry if MaxItems is exceeded. }
  if (FItems.Count > FMaxItems) then
    FItems.Delete(FItems.Count - 1);
  mruDisableUpdates := False;
  GenerateMenuItems;
end;

{ AddSplit method. Adds an item to either the top or the }
{ bottom of a split menu. }
procedure TOvcMenuMRU.AddSplit(const Value : string; Position : TOvcMRUAddPosition);
var
  I : Integer;
  SepPos : Integer;
begin
  { apAnchor is an invalid parameters for the AddSplit method. }
  if (Position = apAnchor) then
    raise EMenuMRUError.CreateRes(SCInvalidParameter);

  if (FStyle = msNormal) then
    raise EMenuMRUError.CreateRes(SCInvalidParameter);

  { FMenuItem might not be assigned. }
  if (not Assigned(FMenuItem)) then
    raise EMenuMRUError.CreateRes(SCNoMenuAssigned);

  { Add the position to a set so we can tell whether }
  { both top and bottom positions contain items. }
  mruSplits := mruSplits + [Position];

  { Is the list empty? If so, just add the item. }
  mruDisableUpdates := True;
  if FItems.Count = 0 then begin
    FItems.Add(Value)
  end else begin
    { If the entry already exist, remove it. }
    SepPos := -1;
    for I := Pred(FItems.Count) downto 0 do
      if (FItems[I] = Value) then
        FItems.Delete(I);

    { Find the separator. }
    for I := 0 to Pred(FItems.Count) do
      if (FItems[I] = '-') then
        SepPos := I;

    { Are we adding to the top or the bottom of the split list? }
    case Position of
      apTop :
        begin
          FItems.Insert(0, Value);
          { Separator? }
          if SepPos <> -1 then begin
            { We just inserted an item so SepPos is }
            { actually off by one at this point. }
            Inc(SepPos);
            { Have we exceeded MaxItems for this part of the  }
            { split menu?  }
            if SepPos > FMaxItems then
              FItems.Delete(SepPos - 1);
          { Is there a separator in the list? }
          end else begin
            { No separator. }
            { Any bottom items? }
            if not (apBottom in mruSplits) then
              { Check MaxItems. }
              if FItems.Count > FMaxItems then
                FItems.Delete(Pred(FItems.Count));
            { Are there items at both top and bottom? }
            if (apTop in mruSplits) and (apBottom in mruSplits) then
              { Yes, add a separator. }
              FItems.Insert(1, '-');
          end;
        end;
      apBottom :
        begin
          { Separator? }
          if SepPos <> -1 then begin
            { Yes. Insert new item after. }
            FItems.Insert(SepPos + 1, Value);
            { Have we exceeded MaxItems for this }
            { part of the split menu? }
            if (FItems.Count - FMaxItems) > FMaxItems + 1 then
              FItems.Delete(Pred(FItems.Count));
          end else begin
            { No separator. }
            { Is there an item in the top section? }
            if apTop in mruSplits then begin
              { Yes, add a separator. }
              FItems.Add('-');
              { Add the item. }
              FItems.Add(Value);
            end else begin
              { Insert the item at the top of the list. }
              FItems.Insert(0, Value);
              { Have we exceeded MaxItems? }
              if FItems.Count > FMaxItems then
                FItems.Delete(Pred(FItems.Count));
            end;
          end;

        end;
    end;
  end;
  mruDisableUpdates := False;
  GenerateMenuItems;
end;

{ Clear method. Calls FItems.Clear to clear the list }
{ and then GenerateMenuItems to update the menu. }
procedure TOvcMenuMRU.Clear;
begin
  FItems.Clear;
  mruSplits := [];
  GenerateMenuItems;
end;

{ Remove method. Removes an item from the MRU list. }
procedure TOvcMenuMRU.Remove(const Value: string);
var
  I : Integer;
begin
  I := FItems.IndexOf(Value);
  if (I > -1) then
    FItems.Delete(I);
{    FItems.Delete(FItems.IndexOf(Value));}
end;

{ GenerateMenuItems internal method. Does all the work }
{ of updating the menu. }
procedure TOvcMenuMRU.GenerateMenuItems;
var
  I   : Integer;
  J   : Integer;
  N   : Integer;
  MI  : TMenuItem;
begin
  { FMenuItem might not be assigned yet or the MUR list may }
  { be a stand-alone MRU list not associated with a menu.   }
  if FMenuItem = nil then
    Exit;

  { First delete all the menu items. }
  for I := Pred(FMenuItem.Count) downto 0 do
    if Pos('OvcMRU' + Name, FMenuItem.Items[I].Name) <> 0 then
      FMenuItem.Items[I].Free;

  { If the list of files is empty or if Visible is False }
  { then there's nothing to do. }
  if (Items.Count = 0) or (FVisible = False) then
    Exit;

  { Determine the position at which we insert menu items. }
  case FAddPosition of
    apAnchor :
      if (Assigned(FAnchorItem)) then
        I := FMenuItem.IndexOf(FAnchorItem)
      else
        I := 0;
    apBottom :
      I := FMenuItem.Count;
  else
    I := 0;
  end;

  { Insert the separator if needed. }
  if (moAddSeparator in FOptions) then begin
    MI := TMenuItem.Create(FMenuItem.Parent);
    MI.Name := 'OvcMRU' + Name + 'Separator';
    MI.Caption := '-';
    FMenuItem.Insert(I, MI);
    if (FAddPosition = apBottom) then
      Inc(I);
  end;

  { Insert the MRU items. }
  { If the MRU is being generated because of a toolbar button attached}
  { to a memnu item, the VCL appears to lose track of which menu is being}
  { used and a duplicate menu item exception is the usual result.}
  { The try..except block with an empty exception block avoids the exception}
  { yet allows the MRU to function when fired by either a menu item directly}
  { or indirectly via a toolbar button}

  N := 0;
  for J := 0 to Pred(FItems.Count) do begin
    try
      { Create a new TMenuItem. }
      MI := TMenuItem.Create(FMenuItem.Parent);
      MI.Enabled := FEnabled;
      MI.GroupIndex := FGroupIndex;
      {MI.Hint := FHint;}
      { Generate a Name base on the property Name. This  }
      { is necessary so that multiple TOvcMenuMRUs don't }
      { conflict with one another. }
      MI.Name := 'OvcMRU' + Name + IntToStr(J + 1);
      { Assign the OnClick event to our handler. }
      MI.OnClick := MenuClick;
      { Save the item's position in the string list so that }
      { we can send it to the user in the OnClick event. }
      MI.Tag := J;
      { Don't add numeric values to separators. }
      if FItems[J] = '-' then
        MI.Caption := '-'
      else begin
        Inc(N);
        MI.Caption := FixupDisplayString(FItems[J], N);
      end;
      FMenuItem.Insert(I + J, MI);
      MI.Hint := FItems[J];
      except
        {}
      end;
  end;
end;

procedure TOvcMenuMRU.ListChange(Sender : TObject);
begin
  if (not mruDisableUpdates) and
     (not (csLoading in ComponentState)) and
     (not (csDesigning in ComponentState)) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetAnchorItem(const Value : TMenuItem);
begin
  FAnchorItem := Value;
  if csDesigning in ComponentState then
    if (Value <> nil) then
      FAddPosition := apAnchor;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetGroupIndex(const Value: Integer);
begin
  FGroupIndex := Value;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetHint(const Value: string);
begin
  FHint := Value;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetItems(const Value : TStrings);
begin
  FItems.Assign(Value);
  if (not (csLoading in ComponentState)) and
     (not (csDesigning in ComponentState)) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetMaxItems(const Value : Integer);
var
  I : Integer;
begin
  if (Value <= 0) then
    Exit;
  FMaxItems := Value;
  { Regenerate the MRU menu items. }
  if not (csLoading in ComponentState) then
    if (FItems.Count > FMaxItems) then
      for I := Pred(FItems.Count) downto FMaxItems do
        FItems.Delete(I);
end;

procedure TOvcMenuMRU.SetOptions(const Value : TOvcMRUOptions);
begin
  FOptions := Value;
  { Regenerate the MRU menu items. }
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetStyle(const Value : TOvcMRUStyle);
begin
  FStyle := Value;
  if Value = msSplit then
    FOptions := FOptions - [moAddSeparator];
end;

procedure TOvcMenuMRU.SetMenuItem(const Value : TMenuItem);
var
  I : Integer;
  Found : Boolean;
begin
  FMenuItem := Value;
  { Check to see if the current AnchorItem is valid. }
  Found := False;
  if (FMenuItem = nil) then Exit;
  for I := 0 to Pred(FMenuItem.Count) do
    if FMenuItem.Items[I] = FAnchorItem then
      Found := True;
  if not Found then
    FAnchorItem := nil;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

procedure TOvcMenuMRU.MenuClick(Sender : TObject);
var
  I      : Integer;
  SepPos : Integer;
  S      : string;
  Action : TOvcMRUClickAction;
begin
  with Sender as TMenuItem do
    S := FItems[Tag];
  Action := caMoveToTop;
  DoClick(S, Action);
  case Action of
    caMoveToTop :
      begin
        if FStyle <> msSplit then
          Add(S)
        else begin
          SepPos := -1;
          for I := 0 to Pred(FItems.Count) do
            { Note the position of the separator. }
            if (FItems[I] = '-') then
              SepPos := I;

          if SepPos = -1 then begin
            { No separator. Add to top or bottom of according }
            { to what the mruSplits set contains. }
            if apTop in mruSplits then
              AddSplit(S, apTop)
            else
              AddSplit(S, apBottom);
          end else begin
            { Separator found. Is this item from the top }
            { portion of the list or the bottom? }
            if FItems.IndexOf(S) > SepPos then
              AddSplit(S, apBottom)
            else
              AddSplit(S, apTop);
          end;
        end;
      end;
    caRemove :
      FItems.Delete(FItems.IndexOf(S));
  end;
end;

procedure TOvcMenuMRU.DoClick(const Value : string;
                              var Action : TOvcMRUClickAction);
begin
  if (Assigned(FOnClick)) then
    FOnClick(Self, Value, Action);
end;

procedure TOvcMenuMRU.SetMaxMenuWidth(const Value : Integer);
begin
  FMaxMenuWidth := Value;
  if not (csLoading in ComponentState) then
    GenerateMenuItems;
end;

function TOvcMenuMRU.FixupDisplayString(S : string; N : Integer): string;
begin
  if moStripPath in FOptions then
    S := ExtractFileName(S);
  if (moAddAccelerators in FOptions) then begin
    if N < 10 then
      { Add the numeric hotkey identifier. }
      Result := Format('&%d %s', [N,
        PathEllipsis(S, FMaxMenuWidth)])
    else begin
      { Can't go beyond 'Z'. }
      if N < 36 then
        { Add an alphabetic hotkey identifier. }
        Result := Format('&%s %s', [Char(55 + N),
          PathEllipsis(S, FMaxMenuWidth)])
      else
        { Add the item with no hotkey. }
        Result := Format('%s',
          [PathEllipsis(S, FMaxMenuWidth)]);
    end;
  end else
    Result := PathEllipsis(S, FMaxMenuWidth);
end;

function TOvcMenuMRU.GetCount: Integer;
begin
  if Style = msNormal then
    Result := FItems.Count
  else begin
    { Account for the separator in a split MRU. }
    if (apTop in mruSplits) and (apBottom in mruSplits) then
      Result := FItems.Count - 1
    else
      Result := FItems.Count;
  end;
end;

procedure TOvcMenuMRU.StoreList;
var
  I,
  N : Integer;
begin
  if Assigned(FStore) and not (csDesigning in ComponentState) then begin
    FStore.Open;
    try
      FStore.EraseSection(mruStoreKey);
      FStore.WriteInteger(mruStoreKey, 'Count', FItems.Count);
      N := FItems.Count;
      if (N > FMaxItems) then
        N := FMaxItems;
      for I := 0 to Pred(N) do
        FStore.WriteString(mruStoreKey, IntToStr(I), FItems[I]);
    finally
      FStore.Close;
    end;
  end;
end;

procedure TOvcMenuMRU.LoadList;
var
  I : Integer;
  N : Integer;
begin
  if Owner <> nil then
    mruStoreKey := Format('%s.%s.%s', [Owner.Name, Name, 'Items'])
  else
    mruStoreKey := Format('%s.%s', [Name, 'Items']);
  if (FStore <> nil) and not (csDesigning in ComponentState) then begin
    FStore.Open;
    try
      N := FStore.ReadInteger(mruStoreKey, 'Count', 0);
      if (N > FMaxItems) then
        N := FMaxItems;
      for I := 0 to Pred(N) do
        FItems.Add(FStore.ReadString(mruStoreKey, IntToStr(I), ''));
    finally
      FStore.Close;
    end;
  end;
end;

end.
