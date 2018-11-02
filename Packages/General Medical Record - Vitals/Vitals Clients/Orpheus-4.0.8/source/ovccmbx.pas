{*********************************************************}
{*                   OVCCMBX.PAS 4.08                    *}
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
{*    Sebastian Zierer (Unicode Version)                                      *}
{*    Roman Kassebaum  (D2007 support)                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovccmbx;

interface

uses
  UITypes, Types, Windows, SysUtils, Messages, Classes, Graphics,
  Controls, Forms, StdCtrls, Buttons, OvcBase, OvcConst, OvcData, OvcMisc, OvcBordr,
  OvcTimer, Themes;

type
  {this class implements a stack for keeping track of
   most recently used items in the ComboBox}
  TOvcMRUList = class
  protected {private}
    {property variables}
    FMaxItems : Integer;       {maximum items to keep}
    FList     : TStrings;      {the items themselves}

    {property methods}
    procedure SetMaxItems(Value: Integer);

  public
    procedure Clear;
    constructor Create;
    destructor Destroy; override;

    procedure NewItem(const Item: string; Obj: TObject);
    procedure Shrink;
    function RemoveItem(const Item: string): Boolean;

    property Items: TStrings read FList;

    property MaxItems: Integer read FMaxItems write SetMaxItems;
  end;

const
  cbxSeparatorHeight = 3;

type
  TOvcComboStyle = (ocsDropDown, ocsDropDownList);

  TOvcHTColors = class(TPersistent)
  protected {private}
    FHighlight : TColor;
    FShadow    : TColor;
  public
    constructor Create; virtual;
  published
    property Highlight: TColor read FHighlight write FHighlight
      default clBtnHighlight;
    property Shadow: TColor read FShadow write FShadow default clBtnShadow;
  end;

  TOvcBaseComboBox = class(TCustomComboBox)
  private
    // Vista visual styles
    FCurrentState: Cardinal;
    FNewState: Cardinal;
    FBufferedPaintInitialized: Boolean;
  protected {private}
    {property variables}
    FAutoSearch   : Boolean;
    FBorders      : TOvcBorders;
    FDrawingEdit  : Boolean;
    FDroppedWidth : Integer;
    FHotTrack     : Boolean;
    FHTBorder     : Boolean;
    FHTColors     : TOvcHTColors;
    FKeyDelay     : Integer;
    FItemHeight   : Integer;          {hides inherited property}
    FLabelInfo    : TOvcLabelInfo;
    FMRUListColor : TColor;
    FMRUListCount : Integer;
    FStyle        : TOvcComboStyle;

    {event variables}
    FAfterEnter   : TNotifyEvent;
    FAfterExit    : TNotifyEvent;
    FOnMouseWheel : TMouseWheelEvent;
    FOnSelChange  : TNotifyEvent;        {called when the selection changes}

    {internal variables}
    FEventActive         : Boolean;
    FIsFocused           : Boolean;
    FIsHot               : Boolean;
    FLastKeyWasBackSpace : Boolean;
    FMRUList             : TOvcMRUList;
    FList                : TStringList;  {Items sans MRU Items}
    FListIndex           : Integer;      {ItemIndex sans MRU Items}
    FSaveItemIndex       : Integer;
    FStandardHomeEnd     : Boolean;
    FTimer               : Integer;      {timer-pool handle}

    FCurItemIndex : integer;

    {internal methods}
    procedure HotTimerEvent(Sender : TObject; Handle : Integer;
                         Interval : Cardinal; ElapsedTime : Integer);
    procedure TimerEvent(Sender : TObject; Handle : Integer;
                         Interval : Cardinal; ElapsedTime : Integer);

    {property methods}
    procedure SetAbout(const Value : string);
    procedure SetDroppedWidth(Value : Integer);
    procedure SetHotTrack(Value : Boolean);
    procedure SetItemHeight(Value : Integer); reintroduce;
    function  GetListIndex: Integer;
    procedure SetListIndex(Value: Integer);
    function  GetList : TStrings;
    function GetMRUList: TStrings;
    procedure SetKeyDelay(Value : Integer);
    procedure SetMRUListCount(Value : Integer);
    procedure SetOcbStyle(Value : TOvcComboStyle);
    procedure SetStandardHomeEnd(Value : Boolean);

    {internal methods}
    procedure AddItemToMRUList(Index: Integer);

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    procedure CheckHot(HotWnd : TOvcHWnd{hWnd});

    function GetAttachedLabel : TOvcAttachedLabel;
    function GetAbout : string;
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;
    procedure RecalcHeight;
    procedure SetHot;
    procedure UpdateMRUList;
    procedure UpdateMRUListModified;
    procedure MRUListUpdate(Count : Integer);

    {private message methods}
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;
    procedure OMAfterEnter(var Msg : TMessage);
      message OM_AFTERENTER;
    procedure OMAfterExit(var Msg : TMessage);
      message OM_AFTEREXIT;

    {windows message methods}
    procedure CNCommand(var Message: TWmCommand);
      message CN_COMMAND;
    procedure CNDrawItem(var Msg : TWMDrawItem);
      message CN_DRAWITEM;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMMeasureItem(var Message : TMessage);
      message WM_MEASUREITEM;
    procedure WMMouseWheel(var Msg : TMessage);
      message WM_MOUSEWHEEL;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

      {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;
    procedure CMFontChanged(var Message: TMessage);
      message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message : TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message : TMessage); message CM_MOUSELEAVE;

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer); override;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DoOnMouseWheel(Shift: TShiftState;
      Delta, XPos, YPos: SmallInt); dynamic;
    procedure DoExit; override;
    procedure DrawItem(Index: Integer; ItemRect: TRect;
      State: TOwnerDrawState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MeasureItem(Index: Integer; var IHeight: Integer); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;

    procedure SelectionChanged; virtual;
    procedure Select; override;
    procedure SetItemIndex(const Value: Integer); override;

    procedure BorderChanged(ABorder : TObject);
    procedure Paint;
    procedure PaintBorders;

    procedure PaintWindow(DC : HDC); override;

    procedure WMPaint(var Msg : TWMPaint); message WM_PAINT;

    procedure SetHTBorder(Value : Boolean);
    procedure SetHTColors(Value : TOvcHTColors);

    // Vista visual styles
    function UseRuntimeThemes: Boolean;
    procedure PaintState(DC: HDC; State: Cardinal);
    procedure StartAnimation(NewState: Cardinal);
    procedure CloseUp; override;
    procedure CNCtlcoloredit(var Message: TMessage); message CN_CTLCOLOREDIT;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure DrawItemThemed(DC: HDC; Details: TThemedElementDetails; Index: Integer; Rect: TRect); virtual;

    {properties}
    property About: string read GetAbout write SetAbout stored False;
    property AutoSearch: Boolean read FAutoSearch write FAutoSearch
      default True;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property KeyDelay: Integer read FKeyDelay write SetKeyDelay default 500;
    property LabelInfo: TOvcLabelInfo read FLabelInfo write FLabelInfo;
    property MRUListColor: TColor read FMRUListColor write FMRUListColor
      default clWindow;
    property MRUListCount: Integer read FMRUListCount write SetMRUListCount
      default 3;
    property Style: TOvcComboStyle read FStyle write SetOcbStyle;

    {events}
    property AfterEnter: TNotifyEvent read FAfterEnter write FAfterEnter;
    property AfterExit: TNotifyEvent read FAfterExit write FAfterExit;
    property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel
      write FOnMouseWheel;
    property OnSelectionChange: TNotifyEvent read FOnSelChange
      write FOnSelChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DrawingEdit: Boolean read FDrawingEdit;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function AddItem(const Item: string; AObject: TObject): Integer; reintroduce;
    procedure AssignItems(Source: TPersistent);
    procedure ClearItems;
    procedure InsertItem(Index: Integer; const Item: string; AObject: TObject);
    procedure RemoveItem(const Item: string);

    procedure ClearMRUList;
    procedure ForceItemsToMRUList(Value: Integer);
    property AttachedLabel: TOvcAttachedLabel read GetAttachedLabel;
    property DroppedWidth: Integer read FDroppedWidth write SetDroppedWidth
      default -1;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property List: TStrings read GetList;
    property ListIndex: Integer read GetListIndex write SetListIndex;
    property MRUList: TStrings read GetMRUList;
    property StandardHomeEnd: Boolean read FStandardHomeEnd
      write SetStandardHomeEnd;
  published
    property Borders: TOvcBorders read FBorders write FBorders;
    property HotTrackBorder: Boolean read FHTBorder write SetHTBorder
      default True;
    property HotTrackColors: TOvcHTColors read FHTColors write SetHTColors;
    property AutoComplete default False;
  end;

  {TOvcComboBox}

  TOvcComboBox = class(TOvcBaseComboBox)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property AutoSearch;
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property DroppedWidth;
    property Enabled;
    property Font;
    property HotTrack;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property Items;
    property KeyDelay;
    property LabelInfo;
    property MaxLength;
    property MRUListColor;
    property MRUListCount;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style default ocsDropDown;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    {events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelectionChange;
    property OnStartDrag;
    property OnMouseWheel;
  end;

implementation

uses
  OvcVer, OvcExcpt, UxTheme, Math;

function ThemesEnabled: Boolean; inline;
begin
  Result := StyleServices.Enabled;
end;

function ThemeServices: TCustomStyleServices; inline;
begin
  Result := StyleServices;
end;

constructor TOvcHTColors.Create;
begin
  inherited Create;

  {create color objects and assign defaults}
  FHighlight := clBtnHighlight;
  FShadow    := clBtnShadow;
end;

{*** TOvcMRUList ***}

constructor TOvcMRUList.Create;
begin
  FList := TStringList.Create;
  FMaxItems := 3;
end;

destructor TOvcMRUList.Destroy;
begin
  FList.Free;

  inherited Destroy;
end;

procedure TOvcMRUList.NewItem(const Item: string; Obj: TObject);
var
  Index: Integer;
begin
  Index := FList.IndexOf(Item);
  if Index > -1 then begin
    { If the item is already in the list, just bring it to the top }
    FList.Delete(Index);
    FList.InsertObject(0, Item, Obj);
  end else begin
    FList.InsertObject(0, Item, Obj);
    {this may result in more items in the list than are allowed,}
    {but a call to Shrink will remove the excess items}
    Shrink;
  end;
end;

function TOvcMRUList.RemoveItem(const Item : string) : Boolean;
var
  Index : Integer;
begin
  Index := FList.IndexOf(Item);
  if (Index > -1) and (Index < FList.Count) then begin
    FList.Delete(Index);
    Result := True;
  end else
    Result := False;
end;

procedure TOvcMRUList.Shrink;
begin
  while FList.Count > FMaxItems do
    FList.Delete(FList.Count - 1);
end;

procedure TOvcMRUList.Clear;
begin
  FList.Clear;
end;

procedure TOvcMRUList.SetMaxItems(Value: Integer);
begin
  FMaxItems := Value;
  Shrink;
end;


{*** TOvcBaseComboBox ***}

procedure TOvcBaseComboBox.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

procedure TOvcBaseComboBox.ClearItems;
begin
  ClearMRUList;
  if HandleAllocated then
    Clear;
end;

procedure TOvcBaseComboBox.ClearMRUList;
var
  I : Integer;
begin
  if (FMRUList.Items.Count > 0) then begin
    for I := 1 to FMRUList.Items.Count do
      if (I <= Items.Count) then
        Items.Delete(0);
    FMRUList.Clear;
  end;
end;

procedure TOvcBaseComboBox.CloseUp;
begin
  inherited;
  StartAnimation(CBRO_NORMAL);
end;

{ - added}
procedure TOvcBaseComboBox.ForceItemsToMRUList(Value: Integer);
var
  I, J: Integer;
  Str: string;
begin
  if (Value > 0) or (Value <= FMRUList.MaxItems) then begin
    for I := 0 to pred(Value) do begin
      Str := Items.Strings[I];
      J := I + 1;
      while (J < Items.Count) and (Items.Strings[J] <> Str) do
        Inc(J);
      if (J < Items.Count) then begin
        Items.Delete(I);
        AddItemToMRUList(J - 1);
      end;
    end;
  end;

  UpdateMRUList;
end;

procedure TOvcBaseComboBox.CNDrawItem(var Msg : TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  {gather flag information that Borland left out}
  FDrawingEdit := (ODS_COMBOBOXEDIT and Msg.DrawItemStruct.itemState) <> 0;

  //SZ do not let Delphi paint the focus rect if themes are enabled
  if UseRuntimeThemes then
    with Msg.DrawItemStruct^ do
    begin
      State := TOwnerDrawState(LoWord(itemState));
      if (odComboBoxEdit in State) and (odFocused in State) then
      begin
        //Exclude(State, odFocused); This line causes a hint R.K.
        itemState := itemState and not ODS_FOCUS;
      end;
    end;

  inherited;
end;

function TOvcBaseComboBox.GetList : TStrings;
var
  I : Integer;
begin
  FList.Clear;
  FList.Assign(Items);
  if FMRUList.Items.Count > 0 then
    for I := 0 to Pred(FMRUList.Items.Count) do
      FList.Delete(0);
  Result := FList;
end;

{ - Added}
function TOvcBaseComboBox.GetMRUList: TStrings;
begin
  result := FMRUList.FList;
end;

procedure TOvcBaseComboBox.SetListIndex(Value : Integer);
  {Value is the index into the list sans MRU items}
var
  I : Integer;
begin
  I := FMRUList.Items.Count;
  if (((Value + I) < Items.Count) and (Value >= 0)) then
    ItemIndex := Value + I
  else
    ItemIndex := -1;
end;

function TOvcBaseComboBox.GetListIndex;
  {Translates ItemIndex into index sans MRU Items}
begin
  Result := ItemIndex - FMRUList.Items.Count;
end;

procedure TOvcBaseComboBox.AssignItems(Source: TPersistent);
begin
  Clear;
  Items.Assign(Source);
  RecalcHeight;
end;

function TOvcBaseComboBox.AddItem(const Item :
                                  string; AObject : TObject) : Integer;
begin
  Result := -1;
  if (Items.IndexOf(Item) < 0) then begin
    Result := Items.AddObject(Item, AObject) - FMRUList.Items.Count;
    UpdateMRUList;
  end;
  RecalcHeight;
end;

procedure TOvcBaseComboBox.InsertItem(Index : Integer;
                                      const Item : string; AObject: TObject);
var
  I : Integer;
begin
  I := FMRUList.Items.Count;
  if (Index> -1) and (Index < (Items.Count - I)) then begin
    Items.InsertObject(Index + I, Item, AObject);
    UpdateMRUList;
  end;
  RecalcHeight;
end;

procedure TOvcBaseComboBox.RemoveItem(const Item : string);
var
  I : Integer;
  SelChange : Boolean;
begin
  if FMRUList.RemoveItem(Item) then
    UpdateMRUListModified;
  I := Items.IndexOf(Item);
  if (I > -1) then begin
    SelChange := (ItemIndex = I);
    Items.Delete(I);
    UpdateMRUList;
    if SelChange then begin
      Text := '';
      SelectionChanged;
    end;
    RecalcHeight;
  end;
end;

procedure TOvcBaseComboBox.AddItemToMRUList(Index: Integer);
{ Changes:
     05/2011, AB: Bugfix: After selecting an Item from the dropdown-list, the
     ComboxBox does not react to moving down the list using the mousewheel.
     Going up works - and as soon as you went up at least once, you can move
     downwards, too.
     The source of the problem is inserting an item at the beginning of the list
     'Items' - although it is not clear (to me) how this causes the strange
     effect.
     The following code - setting ItemIndex temporarily to 0 - is just a
     workaround... }
var
  I : Integer;
begin
  I := FMRUList.Items.Count;
  if (I > -1) and (Index > -1) then begin
    FMRUList.NewItem(Items[Index], Items.Objects[Index]);
    if FMRUList.Items.Count > I then begin
      I := ItemIndex;
      Items.InsertObject(0, Items[Index], Items.Objects[Index]);
      ItemIndex := 0;
      ItemIndex := I+1;
    end;
  end;
end;

procedure TOvcBaseComboBox.UpdateMRUList;
begin
  MRUListUpdate(FMRUList.Items.Count);
end;

procedure TOvcBaseComboBox.UpdateMRUListModified;
  {Use this to update MRUList after removing item from MRUList}
begin
  MRUListUpdate(FMRUList.Items.Count + 1);
end;

function TOvcBaseComboBox.UseRuntimeThemes: Boolean;
begin
  Result := ThemesEnabled and CheckWin32Version(6, 0) {Vista} and (Style = ocsDropDownList);
end;

procedure TOvcBaseComboBox.MRUListUpdate(Count : Integer);
var
  I,
  L        : Integer;
  SrchText : PChar;
begin
  L := Length(Text) + 1;
  SrchText := StrAlloc(L); // GetMem(SrchText, L * SizeOf(Char));
  try
    StrPCopy(SrchText, Text);
    {the first items are part of the MRU list}
    if (Count > 0) then
      for I := 1 to Count do
        Items.Delete(0);
    {make sure the MRU list is limited to its maximum size}
    FMRUList.Shrink;
    {add the MRU list items to the beginning of the combo list}
    if (FMRUList.Items.Count > 0) then begin
      for I := Pred(FMRUList.Items.Count) downto 0 do
        Items.InsertObject(0, FMRUList.Items[I], FMRUList.Items.Objects[I]);

      {this is necessary because we are always inserting item 0 and Windows
       thinks that it knows the height of all other items, so it only sends
       a WM_MEASUREITEM for item 0. We need the last item of the MRU list
       to be taller so we can draw a separator under it}
      SendMessage(Handle, CB_SETITEMHEIGHT, wParam(FMRUList.Items.Count - 1),
                  lParam(FItemHeight + cbxSeparatorHeight));
    end;
    ItemIndex := SendMessage(Handle,
                             CB_FINDSTRINGEXACT,
                             FMRUList.Items.Count - 1,
                             Integer(SrchText));
  finally
    StrDispose(SrchText); // FreeMem(SrchText, L);
  end;
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
procedure TOvcBaseComboBox.CheckHot(HotWnd : TOvcHWnd{hWnd});
begin
  if FIsHot and ((HotWnd <> Handle)
    and (HotWnd <> EditHandle)) then begin
    FIsHot := False;
    Invalidate;
  end;
end;

procedure TOvcBaseComboBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  if Enabled then
    StartAnimation(CBRO_NORMAL)
  else
    StartAnimation(CBRO_DISABLED);
end;

procedure TOvcBaseComboBox.CMFontChanged(var Message: TMessage);
begin
  if not (csLoading in ComponentState) then
    RecalcHeight
end;

procedure TOvcBaseComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer);
begin
  if HotTrack and (Message.Msg = WM_NCHITTEST) then
    SetHot;
  inherited ComboWndProc(Message, ComboWnd, ComboProc);
end;

procedure TOvcBaseComboBox.CNCommand(var Message: TWmCommand);
{ Changes:
  05/2011, AB: Bugfix for issue 668019 (OnClick was fired twice when an item
           from the drop-down list is selected). }
begin
  if Message.NotifyCode = CBN_DROPDOWN then begin
    FCurItemIndex := ItemIndex;
  end else if Message.NotifyCode = CBN_CLOSEUP then begin
    if ItemIndex > -1 then begin
      AddItemToMRUList(ItemIndex);
      Text := Items[ItemIndex];
//      Click;
      SelectionChanged;
    end;
  end;

  if HotTrack then
    case Message.NotifyCode of
    CBN_CLOSEUP :
      Invalidate;
    CBN_SETFOCUS:
      begin
        FIsFocused := True;
        Invalidate;
      end;
    CBN_KILLFOCUS:
      begin
        FIsFocused := False;
        Invalidate;
      end;
    end;

  inherited;

  case Message.NotifyCode of
    CBN_DROPDOWN: StartAnimation(CBRO_PRESSED); // must be done after DropDown event
  end;
end;

procedure TOvcBaseComboBox.CNCtlcoloredit(var Message: TMessage);
begin
  if UseRuntimeThemes then
    Message.Result := GetStockObject(NULL_BRUSH)
  else
    inherited;
end;

constructor TOvcBaseComboBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if CheckWin32Version(6, 0) then
    FBufferedPaintInitialized := Succeeded(BufferedPaintInit);

  AutoComplete := false;

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
  DefaultLabelPosition := lpTopLeft;

  FList := TStringList.Create;
  FMRUList := TOvcMRUList.Create;

  FAutoSearch := True;
  FDroppedWidth := -1;
  FMRUListColor := clWindow;
  FMRUListCount := 3;
  FKeyDelay := 500;

  FSaveItemIndex := -1;
  FStandardHomeEnd := True;

  FTimer := -1;
  FLastKeyWasBackSpace := False;

  {create borders class and assign notifications}
  FBorders := TOvcBorders.Create;

  FBorders.LeftBorder.OnChange   := BorderChanged;
  FBorders.RightBorder.OnChange  := BorderChanged;
  FBorders.TopBorder.OnChange    := BorderChanged;
  FBorders.BottomBorder.OnChange := BorderChanged;

  FHTBorder := True;
  FHTColors := TOvcHTColors.Create;
  RecalcHeight;
end;

procedure TOvcBaseComboBox.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or (WS_VSCROLL or CBS_HASSTRINGS or CBS_AUTOHSCROLL);
  case FStyle of
    ocsDropDown :
      Params.Style := Params.Style or CBS_DROPDOWN or CBS_OWNERDRAWVARIABLE;
    ocsDropDownList :
      Params.Style := Params.Style or CBS_DROPDOWNLIST or CBS_OWNERDRAWVARIABLE;
  end;
  if NewStyleControls and Ctl3D then
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TOvcBaseComboBox.CreateWnd;
begin
  inherited CreateWnd;

  if FSaveItemIndex > -1 then begin
    ItemIndex := FSaveItemIndex;
    FSaveItemIndex := -1;
  end;

  if FDroppedWidth <> -1 then
    SendMessage(Handle,CB_SETDROPPEDWIDTH,FDroppedWidth,0);
end;

destructor TOvcBaseComboBox.Destroy;
begin
  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;

  FMRUList.Free;
  FMRUList := nil;
  FList.Free;
  FList := nil;

  if (FTimer > -1) then begin
    DefaultController.TimerPool.Remove(FTimer);
    FTimer := -1;
  end;

  FBorders.Free;
  FBorders := nil;

  FHTColors.Free;
  FHTColors := nil;

  if FBufferedPaintInitialized then
    BufferedPaintUnInit;

  inherited Destroy;
end;

procedure TOvcBaseComboBox.DestroyWnd;
begin
  FSaveItemIndex := ItemIndex;

  inherited DestroyWnd;
end;

procedure TOvcBaseComboBox.DoExit;
begin
  AddItemToMRUList(ItemIndex);

  inherited DoExit;
end;

procedure TOvcBaseComboBox.DoOnMouseWheel(Shift : TShiftState;
                                   Delta, XPos, YPos : SmallInt);
begin
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Self, Shift, Delta, XPos, YPos);
end;

procedure TOvcBaseComboBox.DrawItem(Index : Integer; ItemRect: TRect;
                                     State : TOwnerDrawState);
var
  SepRect    : TRect;
  BkColor    : TColor;
  TxtRect    : TRect;
  TxtItem    : string;
  BkMode     : Integer;
begin
    if UseRuntimeThemes and (odComboBoxEdit in State) then
    begin
      Canvas.Brush.Color := clBlack;
      Canvas.Handle;
      Exit;
    end;

  with Canvas do begin
    if (FMRUList.Items.Count > 0) and (Index < FMRUList.Items.Count) then
      BkColor := FMRUListColor
    else
      BkColor := Color;

    if odSelected in State then
      Brush.Color := clHighlight
    else
      Brush.Color := BkColor;
    FillRect(ItemRect);

    with ItemRect do
      TxtRect := Rect(Left + 2, Top, Right, Bottom);

    TxtItem := Items[Index]; //StrPCopy(TxtItem, Items[Index]);
    BkMode := GetBkMode(Canvas.Handle);
    SetBkMode(Canvas.Handle, TRANSPARENT);
    DrawText(Canvas.Handle, PChar(TxtItem), Length(TxtItem),
             TxtRect, DT_VCENTER or DT_LEFT);
    SetBkMode(Canvas.Handle, BkMode);
    if (FMRUList.Items.Count > 0) and
       (Index = FMRUList.Items.Count - 1) and DroppedDown then begin
      SepRect := ItemRect;
      SepRect.Top    := SepRect.Bottom - cbxSeparatorHeight;
      SepRect.Bottom := SepRect.Bottom;
      Pen.Color := clGrayText;

      if not DrawingEdit then
        with SepRect do
          Rectangle(Left-1, Top, Right+1, Bottom);
    end;
  end;

  // Set brush color so that DrawFocusRect has the correct colors
  if UseRuntimeThemes then
  begin
    Canvas.Brush.Color := clBlack;
    Canvas.Handle;
    Exit;
  end;
end;

procedure TOvcBaseComboBox.DrawItemThemed(DC: HDC; Details: TThemedElementDetails; Index: Integer; Rect: TRect);
var
  S: string;
begin
  if InRange(ItemIndex, 0, Items.Count - 1) then
    S := Items[ItemIndex]
  else
    S := '';

  ThemeServices.DrawText(DC, Details, S, Rect, [tfCenter, tfSingleLine], 0);
end;

function TOvcBaseComboBox.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;

function TOvcBaseComboBox.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcBaseComboBox.HotTimerEvent(Sender : TObject;
          Handle : Integer; Interval : Cardinal; ElapsedTime : Integer);
var
  P : TPoint;
  WindowHandle : THandle;
begin
  if FEventActive then
    exit;
  FEventActive := True;
  if FIsHot and Visible and HandleAllocated then begin
    GetCursorPos(P);
    WindowHandle := WindowFromPoint(P);
    CheckHot(WindowHandle);
  end;
  FEventActive := False;
end;

procedure TOvcBaseComboBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  Index    : Integer;
  SrchText: PChar;
begin
  FLastKeyWasBackSpace := False;
  case Key of
    VK_RETURN, 9999{timer event}:
      begin
        SrchText := StrAlloc(Length(Text) + 1); // GetMem(SrchText, (length(Text) + 1) * SizeOf(Char));
        try
          StrPCopy(SrchText, Text);
          {this will search for the first matching item}
          Index := SendMessage(Handle, CB_FINDSTRING,
                               FMRUList.Items.Count - 1,
                                 NativeInt(SrchText));
        finally
          StrDispose(SrchText); //FreeMem(SrchText, length(Text) + 1);
        end;
        if Index > -1 then begin
          Text := Items[Index];
          if Key = VK_RETURN then
            Click;
          SelLength := Length(Text);
          SelectionChanged;
        end else if Key = VK_RETURN then
          MessageBeep(0);
      end;
    VK_HOME:
      begin
        if (not StandardHomeEnd) then begin
          if Shift = [] then begin
            ItemIndex := 0;
            Change;
          end;
        end;
      end;
    VK_END:
      begin
        if (not StandardHomeEnd) then begin
          if Shift = [] then begin
            ItemIndex := Items.Count - 1;
            Change;
          end;
        end;
      end;
    VK_BACK:
      FLastKeyWasBackSpace := True;
    VK_ESCAPE:
      begin
        ItemIndex := 0;
        Change;
      end;
  else
    case Key of
      VK_LBUTTON, VK_RBUTTON, VK_CANCEL, VK_MBUTTON, VK_BACK,
      VK_TAB, VK_CLEAR, VK_RETURN, VK_SHIFT, VK_CONTROL, VK_MENU,
      VK_PAUSE, VK_CAPITAL, VK_ESCAPE, VK_PRIOR, VK_NEXT, VK_END,
      VK_HOME, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN, VK_SELECT, VK_PRINT,
      VK_EXECUTE, VK_SNAPSHOT, VK_INSERT, VK_DELETE, VK_HELP,
      VK_F1..VK_F24, VK_NUMLOCK, VK_SCROLL :
    else
      {start/reset timer}
      if AutoSearch then begin
        {see if we need to reset the timer}
        if (FTimer <> -1) then
          DefaultController.TimerPool.Remove(FTimer);
        FTimer := DefaultController.TimerPool.AddOneTime(TimerEvent, FKeyDelay);
      end;
    end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TOvcBaseComboBox.LabelAttach(Sender : TObject; Value : Boolean);
var
  PF : TForm;
  S  : string;
begin
  if csLoading in ComponentState then
    Exit;

  PF := TForm(GetParentForm(Self));
  if Value then begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := TOvcAttachedLabel.CreateEx(PF, Self);
      FLabelInfo.ALabel.Parent := Parent;

      S := GenerateComponentName(PF, Name + 'Label');
      FLabelInfo.ALabel.Name := S;
      FLabelInfo.ALabel.Caption := S;

      FLabelInfo.SetOffsets(0, 0);
      PositionLabel;
      FLabelInfo.ALabel.BringToFront;
      {turn off auto size}
      FLabelInfo.ALabel.AutoSize := False;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;

procedure TOvcBaseComboBox.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;

procedure TOvcBaseComboBox.Loaded;
begin
  inherited Loaded;

  RecalcHeight;
end;

procedure TOvcBaseComboBox.MeasureItem(Index : Integer; var IHeight : Integer);
begin
  {because Item 0 is always the one queried by WM_MEASUREITEM, we
   set the item height of the last MRU item in the AddMRU
   method of TOvcBaseComboBox. This method is still necessary because we
   need the CB_OWNERDRAWVARIABLE style.}
  IHeight := FItemHeight;
end;

procedure TOvcBaseComboBox.Notification(AComponent : TComponent;
          Operation : TOperation);
var
  PF : TForm;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := TForm(GetParentForm(Self));
      if Assigned(PF) and
         not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end;
    end;
  end;
end;

procedure TOvcBaseComboBox.WndProc(var Message: TMessage);
var
  PaintStruct : TPaintStruct;
  ArLeft : Integer;
  ds : TOwnerDrawState;
begin
  if not HotTrack or (csDesigning in ComponentState) then begin
    inherited WndProc(Message);
    exit;
  end;
  if Message.Msg = WM_NCHitTest then begin
    inherited WndProc(Message);
    SetHot;
  end else
  if Message.Msg = WM_PAINT then begin
    BeginPaint(Handle,PaintStruct);
    ArLeft := Width - 15;
    with Canvas do begin
      Handle := PaintStruct.hdc;
      Font := Self.Font;
      Pen.Color := Color; {clBtnFace;}
      Brush.Color := Color; {clBtnFace;}
      Rectangle(0,0,Width,Height);
      if DroppedDown or FIsHot or FIsFocused then begin
        Pen.Width := 1;
        if (FHTBorder) then begin
          Pen.Color := FHTColors.FShadow;
          MoveTo(1,Height-2);
          LineTo(1,1);
          LineTo(Width-1,1);
          Pen.Color := FHTColors.FHighlight;
          MoveTo(Width-2,1);
          LineTo(Width-2,Height-2);
          LineTo(1,Height-2);
          Pen.Color := Color;
          MoveTo(2,2);
          LineTo(2,Height-3);
          LineTo(Width-3,Height-3);
          LineTo(Width-3,2);
          LineTo(2,2);
        end;

        if DroppedDown then begin
          Pen.Width := 1;
          Pen.Color := clBtnFace;
          Brush.Color := clBtnFace;
{          Rectangle(ArLeft, 4, Width - 4, Height - 4);}
          DrawButtonFace(Canvas, Rect(ArLeft, 3, Width-3, Height-3),
                         1, bsAutoDetect, False, False, False);
          Brush.Color := clBlack;
          Pen.Color := clBlack;
          Polygon(
            [
              Point(ArLeft + 4, Height div 2),
              Point(ArLeft + 6, Height div 2 + 2),
              Point(ArLeft + 8, Height div 2)]);
          Pen.Color := clBtnHighlight;
          MoveTo(ArLeft,Height - 4);
          LineTo(Width - 4,Height - 4);
          LineTo(Width - 4,3);
          Pen.Color := clBtnShadow;
          MoveTo(ArLeft, Height - 4);
          LineTo(ArLeft, 3);
          LineTo(Width - 4, 3);

          if FStyle = ocsDropDownList then begin
            if FCurItemIndex <> -1 then
              DrawItem(FCurItemIndex,Rect(4,4,ArLeft-1,Height-3),[]);
          end;
        end else begin
          Pen.Color := clBtnFace;
          Pen.Width := 1;
          Brush.Color := clBtnFace;
{          Rectangle(ArLeft, 4, Width - 4, Height - 4);}
          DrawButtonFace(Canvas, Rect(ArLeft, 3, Width-3, Height-3),
                         1, bsAutoDetect, False, False, False);
          Brush.Color := clBlack;
          Pen.Color := clBlack;
          Polygon(
            [
              Point(ArLeft + 3, Height div 2 - 1),
              Point(ArLeft + 5, Height div 2 + 1),
              Point(ArLeft + 7, Height div 2 - 1)]);
          Pen.Color := Color;  {clWhite}
          MoveTo(ArLeft, Height - 4);
          LineTo(ArLeft, 3);
          LineTo(Width - 4, 3);
          if FIsFocused then begin
            ds := [odFocused];
            Font.Color := clHighLightText;
          end else begin
            ds := [];
            Font.Color := clWindowText;
          end;
          if FIsFocused and (ItemIndex <> -1) then begin
            ds := ds + [odSelected];
            Font.Color := clHighLightText;
          end;
          if FStyle = ocsDropDownList then
            if ItemIndex <> -1 then
              DrawItem(ItemIndex,Rect(4,4,ArLeft-1,Height-3),ds);
        end;
        Pen.Color := Color; {clBtnFace;}
        dec(ArLeft,2);
        MoveTo(ArLeft,3);
        LineTo(ArLeft,Height - 3);
      end else begin
        Brush.Color := Color; {clBtnHighlight;}
        Rectangle(2,2,Width-2,Height-2);
        Brush.Color := Color; {clBtnFace;}
        Rectangle(ArLeft, 4, Width - 4, Height - 4);
        Pen.Color := clBlack;
        Pen.Width := 1;
        Brush.Color := clBlack;
        Polygon(
          [
            Point(ArLeft + 3, Height div 2 - 1),
            Point(ArLeft + 5, Height div 2 + 1),
            Point(ArLeft + 7, Height div 2 - 1)]);
        Brush.Color := Color;

        Pen.Color := Color; {clBtnFace;}
        MoveTo(2,Height-3);
        LineTo(Width-3,Height-3);
        if FStyle = ocsDropDownList then
          if ItemIndex <> -1 then
            DrawItem(ItemIndex,Rect(4,4,ArLeft-1,Height-3),[]);
      end;
      PaintBorders;
      Handle := 0;
    end;
    EndPaint(Handle,PaintStruct);
    Message.Result := 1;
  end else
    inherited WndProc(Message);
end;

procedure TOvcBaseComboBox.OMAfterEnter(var Msg : TMessage);
begin
  if Assigned(FAfterEnter) then
    FAfterEnter(Self);
end;

procedure TOvcBaseComboBox.OMAfterExit(var Msg : TMessage);
begin
  if Assigned(FAfterExit) then
    FAfterExit(Self);
end;

procedure TOvcBaseComboBox.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;

procedure TOvcBaseComboBox.OMPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and
     Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top;
    end else begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top - Top - Height;
    end;
    if (DX <> FLabelInfo.OffsetX) or (DY <> FLabelInfo.OffsetY) then
      PositionLabel;
  end;
end;

procedure TOvcBaseComboBox.OMRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the re-attachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top - Top - Height);
  end;
end;

procedure TOvcBaseComboBox.PositionLabel;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
      (FLabelInfo.ALabel.Parent <> nil) and
      not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
        FLabelInfo.OffsetY - FLabelInfo.ALabel.Height + Top,
        FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end else begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
        FLabelInfo.OffsetY + Top + Height,
        FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end;
  end;
end;

procedure TOvcBaseComboBox.RecalcHeight;
var
  DC : HDC;
  F  : HFont;
  M  : TTextMetric;
begin
  DC := GetDC(0);
  F := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, M);
  SelectObject(DC, F);
  ReleaseDC(0, DC);
  SetItemHeight(M.tmHeight{ - 1}); //SZ 09.06.2010 removed "- 1" because "q" is cut off at bottom
end;

procedure TOvcBaseComboBox.Select;
begin
  inherited;
  Invalidate; // must invalidate after selecting item using CBFindString
end;

procedure TOvcBaseComboBox.SelectionChanged;
var
  L        : Integer;
  SrchText : PChar;
begin
  if FMRUListCount > 0 then
    UpdateMRUList
  else if (FList.Count > 0) and (FAutoSearch) then begin
    L := Length(Text) + 1;
    SrchText := StrAlloc(L); // GetMem(SrchText, L * SizeOf(Char));
    try
      StrPCopy(SrchText, Text);
      ItemIndex := SendMessage(Handle,
                               CB_FINDSTRINGEXACT,
                               0,
                               NativeInt(SrchText));
    finally
      StrDispose(SrchText); // FreeMem(SrchText, L);
    end;
  end;

  if Assigned(FOnSelChange) then
    FOnSelChange(Self);
end;

procedure TOvcBaseComboBox.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TOvcBaseComboBox.SetDroppedWidth(Value : Integer);
begin
  if Value <> FDroppedWidth then begin
    if HandleAllocated then
      if Value <> -1 then
        SendMessage(Handle,CB_SETDROPPEDWIDTH,Value,0)
      else
        SendMessage(Handle,CB_SETDROPPEDWIDTH,0,0);
    FDroppedWidth := Value;
  end;
end;

procedure TOvcBaseComboBox.SetHot;
begin
  if not FIsHot and Application.Active then begin
    FIsHot := True;
    Invalidate;
  end;
end;

procedure TOvcBaseComboBox.SetHotTrack(Value : Boolean);
begin
  if not (csDesigning in ComponentState) then
  begin
    if ThemesEnabled then
      Value := False;
  end;

  if FHotTrack <> Value then begin
    FHotTrack := Value;
    Invalidate;
  end;
end;

{Changed !!.04}
procedure TOvcBaseComboBox.SetItemHeight(Value : Integer);
begin
  if Value <> FItemHeight then begin
    FItemHeight := Value;
// QEC080430-12:12 - Removed the commenting-out as it prevented the correct
//                   setting of the ComboBox Height!!!!!!!
//    (* !!.05
    inherited SetItemHeight(Value);
//    *)
    RecreateWnd;
  end;
end;

procedure TOvcBaseComboBox.SetItemIndex(const Value: Integer);
begin
  inherited;
  Invalidate; // must repaint after SetItemIndex when themed
end;

procedure TOvcBaseComboBox.SetMRUListCount(Value: Integer);
begin
  if ([csDesigning, csLoading] * ComponentState) = [] then
    ClearMRUList;
  FMRUList.MaxItems := Value;
  FMRUListCount := Value;
end;

procedure TOvcBaseComboBox.SetKeyDelay(Value : Integer);
begin
  if (Value <> FKeyDelay) and (Value >= 0) then begin
    FKeyDelay := Value;
  end;
end;

procedure TOvcBaseComboBox.SetOcbStyle(Value : TOvcComboStyle);
begin
  if Value <> FStyle then begin
    FStyle := Value;
    RecreateWnd;
  end;
end;


procedure TOvcBaseComboBox.SetStandardHomeEnd(Value : Boolean);
begin
  if (Value <> FStandardHomeEnd) then
    FStandardHomeEnd := Value;
end;



procedure TOvcBaseComboBox.StartAnimation(NewState: Cardinal);
begin
  FNewState := NewState;
  if UseRuntimeThemes then
    InvalidateRect(Handle, nil, True);
end;

procedure TOvcBaseComboBox.SetAbout(const Value : string);
begin
end;

procedure TOvcBaseComboBox.TimerEvent(Sender : TObject;
          Handle : Integer; Interval : Cardinal; ElapsedTime : Integer);
var
  Key : Word;
  S   : Word;
  SP  : Word;
  EP  : Integer;
begin
  FTimer := -1;
  if FLastKeyWasBackSpace then
    Exit;

(*
  S := Length(Text); {remember current length}
*)
  SendMessage(Self.EditHandle, EM_GETSEL, WPARAM(@SP), LPARAM(@EP));
  S := SP;
  Key := 9999{timer event};
  {fake a key return to force the field to update}
  KeyDown(Key, []);
  SelStart := S;
  SelLength := Length(Text) - S;
end;

procedure TOvcBaseComboBox.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  PostMessage(Handle, OM_AFTEREXIT, 0, 0);
end;

procedure TOvcBaseComboBox.WMMeasureItem(var Message : TMessage);
var
  PMStruct : PMeasureItemStruct;
  IHeight  : Integer;
begin
  PMStruct := PMeasureItemStruct(Message.lParam);
  with PMStruct^ do begin
    ItemWidth  := ClientWidth;
    IHeight := ItemHeight;
    MeasureItem(ItemID, IHeight);
    ItemHeight := IHeight;
  end;
end;

procedure TOvcBaseComboBox.WMMouseWheel(var Msg : TMessage);
begin
  inherited;

  with Msg do
    DoOnMouseWheel(KeysToShiftState(LOWORD(wParam)) {fwKeys},
                   HIWORD(wParam) {zDelta},
                   LOWORD(lParam) {xPos},   HIWORD(lParam) {yPos});
end;

procedure TOvcBaseComboBox.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;

  PostMessage(Handle, OM_AFTERENTER, 0, 0);
  if UseRuntimeThemes then
    Invalidate;
end;

procedure TOvcBaseComboBox.WMSize(var Message: TMessage);
begin
  if UseRuntimeThemes then
    BufferedPaintStopAllAnimations(Handle);

  inherited;
end;

procedure TOvcBaseComboBox.SetHTBorder(Value : Boolean);
begin
  if (Value <> FHTBorder) then begin
    FHTBorder := Value;
    if (FHTBorder) then begin
      FBorders.BottomBorder.Enabled := False;
      FBorders.LeftBorder.Enabled   := False;
      FBorders.RightBorder.Enabled  := False;
      FBorders.TopBorder.Enabled    := False;
    end;
  end;
end;

procedure TOvcBaseComboBox.SetHTColors(Value : TOvcHTColors);
begin
  FHTColors.FHighlight := Value.FHighlight;
  FHTColors.FShadow    := Value.FShadow;
end;

{ - Hdc changed to TOvcHdc for BCB Compatibility }
procedure TOvcBaseComboBox.PaintWindow(DC : TOvcHDC{Hdc});
var
  animParams: BP_ANIMATIONPARAMS;
  rc: TRect;
  hbpAnimation: HANIMATIONBUFFER;
  hdcFrom, hdcTo: HDC;
begin
  if UseRuntimeThemes then
  begin
    TControlCanvas(Canvas).UpdateTextFlags;

    // See if this paint was generated by a soft-fade animation
    if not BufferedPaintRenderAnimation(Handle, Canvas.Handle) then
    begin
        FillChar(animParams, sizeof(animParams), 0);
        animParams.cbSize := sizeof(BP_ANIMATIONPARAMS);
        animParams.style := BPAS_LINEAR;

        GetThemeTransitionDuration(ThemeServices.Theme[teComboBox], CP_READONLY, FCurrentState,
                                       FNewState, TMT_TRANSITIONDURATIONS, animParams.dwDuration);

        RC := ClientRect;

        hbpAnimation := BeginBufferedAnimation(Handle, DC {Canvas.Handle}, rc, BPBF_COMPATIBLEBITMAP, nil, &animParams, &hdcFrom, &hdcTo);
        if hbpAnimation <> 0 then
        begin
          if hdcFrom <> 0 then
            PaintState(hdcFrom, FCurrentState);
          if hdcTo <> 0 then
            PaintState(hdcTo, FNewState);

          FCurrentState := FNewState;
          EndBufferedAnimation(hbpAnimation, TRUE);
        end;
    end;
  end
  else
  begin
    inherited PaintWindow(DC);
    Canvas.Handle := DC;
    try
      PaintBorders;
    finally
      Canvas.Handle := 0;
    end;
  end;
end;


procedure TOvcBaseComboBox.Paint;
begin
  PaintBorders;
end;


procedure TOvcBaseComboBox.WMPaint(var Msg : TWMPaint);
begin
  // SZ inherited calls PaintHandler if csCustomPaint is set
  // PaintHandler(Msg);
  ControlState := ControlState + [csCustomPaint];
  inherited;
  ControlState := ControlState - [csCustomPaint];
end;

procedure TOvcBaseComboBox.PaintBorders;
var
  R : TRect;
  C : TCanvas;
  L : Integer;
  DC: HDC;
  DoRelease : Boolean;
begin
  if (not Assigned(FBorders)) then Exit;

  R.Left   := 0;
  R.Top    := 0;
  R.Right  := Width;
  R.Bottom := Height;

  DoRelease := True;
  DC := GetDC(self.handle);
  Canvas.Handle := DC;

  if (HotTrack) then
    L := 17
  else
    L := 19;

  try
    C := Canvas;
    if (FBorders.LeftBorder <> nil) then begin
      if (FBorders.LeftBorder.Enabled) then begin
        C.Pen.Color := FBorders.LeftBorder.PenColor;
        C.Pen.Width := FBorders.LeftBorder.PenWidth;
        C.Pen.Style := FBorders.LeftBorder.PenStyle;

        C.MoveTo(R.Left + (FBorders.LeftBorder.PenWidth div 2), R.Top);
        C.LineTo(R.Left + (FBorders.LeftBorder.PenWidth div 2), R.Bottom);
      end;
    end;

    if (FBorders.RightBorder <> nil) then begin
      if (FBorders.RightBorder.Enabled) then begin
        C.Pen.Color := FBorders.RightBorder.PenColor;
        C.Pen.Width := FBorders.RightBorder.PenWidth;
        C.Pen.Style := FBorders.RightBorder.PenStyle;

        C.MoveTo(R.Right - L - (FBorders.RightBorder.PenWidth div 2), R.Top);
        C.LineTo(R.Right - L - (FBorders.RightBorder.PenWidth div 2), R.Bottom);
      end;
    end;

    if (FBorders.TopBorder <> nil) then begin
      if (FBorders.TopBorder.Enabled) then begin
        C.Pen.Color := FBorders.TopBorder.PenColor;
        C.Pen.Width := FBorders.TopBorder.PenWidth;
        C.Pen.Style := FBorders.TopBorder.PenStyle;

        C.MoveTo(R.Left, R.Top + (FBorders.TopBorder.PenWidth div 2));
        C.LineTo(R.Right - L, R.Top + (FBorders.TopBorder.PenWidth div 2));
      end;
    end;

    if (FBorders.BottomBorder <> nil) then begin
      if (FBorders.BottomBorder.Enabled) then begin
        C.Pen.Color := FBorders.BottomBorder.PenColor;
        C.Pen.Width := FBorders.BottomBorder.PenWidth;
        C.Pen.Style := FBorders.BottomBorder.PenStyle;

        C.MoveTo(R.Left, R.Bottom - (FBorders.BottomBorder.PenWidth div 2));
        C.LineTo(R.Right - L-1, R.Bottom - (FBorders.BottomBorder.PenWidth div 2));
      end;
    end;
  finally
    if DoRelease then begin
      ReleaseDC(Self.Handle, DC);
      Canvas.Handle := 0;
    end;
  end;
end;

procedure TOvcBaseComboBox.PaintState(DC: HDC; State: Cardinal);
var
  Details: TThemedElementDetails;
  R: TRect;
  Original: HGDIOBJ;
  pcbi: TComboBoxInfo;
begin
  Details.Element := teComboBox;
  Details.Part := CP_READONLY;
  Details.State := State;
  R := ClientRect;

  FillChar(pcbi, SizeOf(pcbi), 0);
  pcbi.cbSize := SizeOf(pcbi);
  GetComboBoxInfo(Handle, pcbi);

  ThemeServices.DrawParentBackground(Handle, DC, Details, True, @R);
  ThemeServices.DrawElement(DC, Details, ClientRect);
  R := pcbi.rcItem;
  Inc(R.Left, 1);
  Canvas.Font := Font;
  Original := SelectObject(DC, Font.Handle);
  DrawItemThemed(DC, Details, ItemIndex, R);
//  ThemeServices.DrawText(DC, Details, S, R, DT_VCENTER or DT_SINGLELINE, 0);
  SelectObject(DC, Original);

  if Focused and not DroppedDown then
    DrawFocusRect(DC, pcbi.rcItem);
  // Draw dropdown arrow
  Details.Part := CP_DROPDOWNBUTTONRIGHT;
  Details.State := 0;
  if Enabled then
    Details.State := 0
  else
    Details.State := CBRO_DISABLED;
  ThemeServices.DrawElement(DC, Details, pcbi.rcButton);
end;

procedure TOvcBaseComboBox.BorderChanged(ABorder : TObject);
begin
  if (FBorders.BottomBorder.Enabled) or
     (FBorders.LeftBorder.Enabled) or
     (FBorders.RightBorder.Enabled) or
     (FBorders.TopBorder.Enabled) then begin
    FHTBorder := False;
    FHotTrack := True;
    Ctl3D := False;
  end else begin
    Ctl3D := True;
    FHTBorder := False;
    FHotTrack := False;
  end;

  RecreateWnd;
end;


procedure TOvcBaseComboBox.CMMouseEnter(var Message: TMessage);
begin
  if UseRuntimeThemes then
    StartAnimation(CBRO_HOT)
  else if not FIsHot and HotTrack then begin
    FIsHot := True;
    Invalidate;
  end;
end;

procedure TOvcBaseComboBox.CMMouseLeave(var Message: TMessage);
begin
  if UseRuntimeThemes then
  begin
    if not DroppedDown and Enabled then
      StartAnimation(CBRO_NORMAL);
  end
  else if FIsHot and HotTrack then begin
    FIsHot := False;
    Invalidate;
  end;
end;

end.
