{*********************************************************}
{*                  O32LKOUT.PAS 4.06                    *}
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

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit o32lkout;

interface

uses
  UITypes, Types, Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, Buttons, Menus, ExtCtrls, MMSystem, StdCtrls, OvcBase,
  OvcVer, OvcData, OvcConst, OvcMisc, OvcSpeed, OvcFiler, OvcState;

type
  {Forward Declaration}
  TO32LookOutFolder = class;
  TO32CustomLookoutBar = class;

  TO32IconSize = (isLarge, isSmall);
  TlobOrientation = (loHorizontal, loVertical);
  TO32BackgroundMethod = (bmNone, bmNormal, bmStretch, bmTile);
  TO32FolderDrawingStyle = (dsDefButton, dsEtchedButton, dsCoolTab,
    dsStandardTab);
  TO32FolderType = (ftDefault, ftContainer);

  TO32FolderContainer = class(TPanel)
  protected{Private}
    FLookoutBar    : TO32CustomLookoutBar;
    FIndex         : Integer;
    function GetChildOwner: TComponent; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    property Index: Integer Read FIndex;
    property LookoutBar: TO32CustomLookoutBar read FLookoutBar;
  end;

  TO32LookOutBtnItem = class(TO32CollectionItem)
  protected {private}
    {property variables}
    FFolder      : TO32LookoutFolder;
    FCaption     : string;
    FDescription : String;
    FIconIndex   : Integer;
    FIconRect    : TRect;
    FLabelRect   : TRect;
    FTag         : Integer;
    {internal variables}
    liDisplayName : string;
    {property methods}
    procedure SetCaption(const Value : string);
    procedure SetIconIndex(Value : Integer);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Folder: TO32LookoutFolder read FFolder;
    procedure Assign(Source: TPersistent); override;
    property IconRect : TRect read FIconRect;
    property LabelRect : TRect read FLabelRect;
  published
    property Caption : string
      read FCaption write SetCaption;
    property Description : string
      read FDescription write FDescription;
    property IconIndex : Integer
      read FIconIndex write SetIconIndex;
    property Name;
    property Tag: Integer
      read FTag write FTag;
  end;

  TO32LookOutFolder = class(TO32CollectionItem)
  protected {private}
    {property variables}
    FLookoutBar     : TO32CustomLookoutBar;
    FCaption        : string;
    FEnabled        : Boolean;
    FIconSize       : TO32IconSize;
    FFolderType     : TO32FolderType;
    FContainerIndex : Integer;
    FItems          : TO32Collection;
    {internal variables}
    lfDisplayName   : string;
    lfRect          : TRect;
    FTag            : Integer;
    {property methods}
    function GetItem(Index : Integer) : TO32LookOutBtnItem;
    function GetItemCount : Integer;
    procedure SetCaption(const Value : string);
    procedure SetEnabled(Value : Boolean);
    procedure SetFolderType(Value: TO32FolderType);
    function CreateContainer: Integer;
    procedure SetIconSize(Value : TO32IconSize);
    procedure SetItem(Index : Integer; Value : TO32LookOutBtnItem);
    procedure lfGetEditorCaption(var Caption : string);
    procedure lfItemChange(Sender : TObject);
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadIndex(Reader: TReader);
    procedure WriteIndex(Writer: TWriter);
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;

    function GetContainer: TO32FolderContainer;

    property Items[Index : Integer] : TO32LookOutBtnItem
      read GetItem;
    property ItemCount : Integer
      read GetItemCount;
    property ContainerIndex: Integer
      read FContainerIndex write FContainerIndex;
  published
    property Caption : string
      read FCaption write SetCaption;
    property Enabled : Boolean
      read FEnabled write SetEnabled;
    property FolderType: TO32FolderType
      read FFolderType write SetFolderType;
    property ItemCollection : TO32Collection
      read FItems write FItems;
    property IconSize : TO32IconSize
      read FIconSize write SetIconSize;
    property Name;
    property Tag: Integer
      read FTag write FTag;
  end;

  TO32RenameEdit = class(TCustomMemo)
  private
  protected
    procedure KeyPress(var Key: Char); override;
  public
    FolderIndex : Integer;
    ItemIndex   : Integer;
    constructor Create(AOwner : TComponent); override;
  end;

  {LookoutBar Events}
  TO32FolderClickEvent =
    procedure(Sender : TObject; Button : TMouseButton; Shift : TShiftState;
      Index : Integer) of object;
  TO32ItemClickEvent =
    procedure(Sender : TObject; Button : TMouseButton; Shift : TShiftState;
      Index : Integer) of object;
  TO32FolderChangeEvent =
    procedure(Sender : TObject; Index : Integer; var AllowChange : Boolean;
      Dragging : Boolean) of object;
  TO32FolderChangedEvent =
    procedure(Sender : TObject; Index : Integer) of object;
  TO32LOBDragOverEvent =
    procedure(Sender, Source: TObject; X, Y: Integer; State: TDragState;
      var AcceptFolder, AcceptItem: Boolean) of object;
  TO32LOBDragDropEvent =
    procedure(Sender, Source: TObject; X, Y: Integer;
      FolderIndex, ItemIndex : Integer) of object;
  TO32MouseOverItemEvent =
    procedure(Sender : TObject; Item : TO32LookOutBtnItem) of object;


  TO32CustomLookOutBar = class(TO32CustomControl)
  protected {private}
    {property variables}
    FActiveFolder       : Integer;
    FActiveItem         : Integer;
    FOrientation        : TLobOrientation;
    FAllowRearrange     : Boolean;
    FBackgroundColor    : TColor;
    FBackgroundImage    : TBitmap;
    FBackgroundMethod   : TO32BackgroundMethod;
    FBorderStyle        : TBorderStyle;
    FButtonHeight       : Integer;
    FContainers         : TO32ContainerList;
    FDrawingStyle       : TO32FolderDrawingStyle;
    FFolders            : TO32Collection;
    FHotFolder          : Integer;
    FImages             : TImageList;
    FItemFont           : TFont;
    FItemSpacing        : Word;
    FPreviousFolder     : Integer;
    FPreviousItem       : Integer;
    FPlaySounds         : Boolean;
    FSelectedItem       : Integer;
    FSelectedItemFont   : TFont;
    FScrollDelta        : Integer;
    FShowButtons        : Boolean;
    FSoundAlias         : string;
    FStorage            : TOvcAbstractStore;
    FLoadingFolder      : Integer;

    {event variables}
    FOnArrange          : TNotifyEvent;
    FOnDragDrop         : TO32LOBDragDropEvent;
    FOnDragOver         : TO32LOBDragOverEvent;
    FOnFolderChange     : TO32FolderChangeEvent;
    FOnFolderChanged    : TO32FolderChangedEvent;
    FOnFolderClick      : TO32FolderClickEvent;
    FOnItemClick        : TO32ItemClickEvent;
    FOnMouseOverItem    : TO32MouseOverItemEvent;

    {internal variables}
    lobChanging         : Boolean;
    lobEdit             : TO32RenameEdit;
    lobTopItem          : Integer;
    lobExternalDrag     : Boolean;
    lobDragFromItem     : Integer;
    lobDragFromFolder   : Integer;
    lobDragToItem       : Integer;
    lobDragToFolder     : Integer;
    lobDropY            : Integer;
    lobHitTest          : TPoint;     {location of mouse cursor}
    lobItemsRect        : TRect;
    lobMouseDown        : Boolean;
    lobOverButton       : Boolean;
    lobScrollDownBtn    : TOvcSpeedButton;
    lobScrollUpBtn      : TOvcSpeedButton;
    lobTimer            : Integer;    {timer-pool handle}
    lobExternalDragItem : Integer;
    lobFolderAccept     : Boolean;
    lobItemAccept       : Boolean;
    lobCursorOverItem   : Boolean;
    lobAcceptAny        : Boolean;
    lobLastMouseOverItem: Integer;

    {property methods}
    function GetFolder(Index : Integer) : TO32LookOutFolder;
    function GetFolderCount : Integer;
    function GetContainer(Index: Integer):TO32FolderContainer;
    procedure SetActiveFolder(Value : Integer);
    procedure SetBackgroundColor(Value : TColor);
    procedure SetBackgroundImage(Value : TBitmap);
    procedure SetBackgroundMethod(Value : TO32BackgroundMethod);
    procedure SetDrawingStyle(Value : TO32FolderDrawingStyle);
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetButtonHeight(Value : Integer);
    procedure SetImages(Value : TImageList);
    procedure SetItemFont(Value : TFont);
    procedure SetItemSpacing(Value : Word);
    procedure SetOrientation(Value: TLobOrientation);
    procedure SetSelectedItem(Value: Integer);
    procedure SetSelectedItemFont(Value : TFont);
    procedure SetScrollDelta(Value : Integer);
    procedure SetStorage(Value : TOvcAbstractStore);

    {internal methods}
    function lobButtonRect(Index : Integer) : TRect;
    procedure lobCommitEdit(Sender : TObject);
    procedure DragOver(Source: TObject;
                       X, Y: Integer;
                       State: TDragState;
                   var Accept: Boolean); override;
    function lobDropHitTest(X, Y : Integer) : Boolean;
    procedure lobFolderChange(Sender : TObject);
    procedure lobFolderSelected(Sender : TObject; Index : Integer);
    procedure lobFontChanged(Sender : TObject);
    procedure lobGetEditorCaption(var Caption : string);
    function lobGetFolderArea(Index : Integer) : TRect;
    procedure lobGetHitTest(X, Y : Integer;
                        var FolderIndex : Integer;
                        var ItemIndex : Integer);
    procedure lobImagesChanged(Sender : TObject);
    procedure lobRecalcDisplayNames;
    procedure lobScrollDownBtnClick(Sender : TObject);
    procedure lobScrollUpBtnClick(Sender : TObject);
    function lobShowScrollUp : Boolean;
    function lobShowScrollDown : Boolean;
    procedure lobTimerEvent(Sender : TObject;
                            Handle : Integer;
                            Interval : Cardinal;
                            ElapsedTime : Integer);

    {VCL message methods}
    procedure CMCtl3DChanged(var Msg : TMessage); message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentColorChanged(var Message: TMessage);
      message CM_PARENTCOLORCHANGED;

    {windows message response methods}
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMNCHitTest(var Msg : TWMNCHitTest);  message WM_NCHITTEST;
    procedure WMSetCursor(var Msg : TWMSetCursor); message WM_SETCURSOR;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

    {Compound component streaming methods}
    procedure Loaded; override;
    function GetChildOwner: TComponent; override;
    function AddContainer(Container: TO32FOlderContainer): Integer;
    procedure RemoveContainer(Container: TO32FolderContainer);

    procedure MouseDown(Button : TMouseButton;
                        Shift : TShiftState;
                        X, Y : Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button : TMouseButton;
                      Shift : TShiftState;
                      X, Y : Integer); override;
    procedure Notification(AComponent : TComponent;
                           Operation : TOperation); override;
    procedure Paint; override;
    procedure DoArrange;
    procedure DoFolderChange(Index : Integer; var AllowChange : Boolean);
    procedure DoFolderChanged(Index : Integer);
    procedure DoFolderClick(Button : TMouseButton;
                            Shift : TShiftState;
                            Index : Integer);
    procedure DoItemClick(Button : TMouseButton;
                          Shift : TShiftState;
                          Index : Integer);
    procedure DoMouseOverItem(X, Y, ItemIndex : Integer);

    {properties}
    property ActiveFolder : Integer
      read FActiveFolder write SetActiveFolder;
    property AllowRearrange : Boolean
      read FAllowRearrange write FAllowRearrange;
    property BackgroundColor : TColor
      read FBackgroundColor write SetBackgroundColor;
    property BackgroundImage : TBitmap
      read FBackgroundImage write SetBackgroundImage;
    property BackgroundMethod : TO32BackgroundMethod
      read FBackgroundMethod write SetBackgroundMethod;
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle;
    property ButtonHeight : Integer
      read FButtonHeight write SetButtonHeight;
    property DrawingStyle : TO32FolderDrawingStyle
      read FDrawingStyle write SetDrawingStyle;
    property FolderCollection : TO32Collection
      read FFolders write FFolders;
    property Images : TImageList
      read FImages write SetImages;
    property ItemFont : TFont
      read FItemFont write SetItemFont;
    property ItemSpacing : Word
      read FItemSpacing write SetItemSpacing;
    property Orientation : TLobOrientation
      read FOrientation write SetOrientation;
    property PlaySounds : Boolean
      read FPlaySounds write FPlaySounds;
    property ScrollDelta : Integer
      read FScrollDelta write SetScrollDelta default 2;
    property SelectedItem : Integer
      read FSelectedItem write SetSelectedItem;
    property SelectedItemFont : TFont
      read FSelectedItemFont write SetSelectedItemFont;
    property ShowButtons : Boolean
      read FShowButtons write FShowButtons;
    property SoundAlias : string
      read FSoundAlias write FSoundAlias;
    property Storage : TOvcAbstractStore
      read FStorage write SetStorage;

    {inherited Events}
    property AfterEnter;
    property AfterExit;
    property OnMouseWheel;

    {events}
    property OnArrange : TNotifyEvent
      read FOnArrange write FOnArrange;
    property OnDragDrop : TO32LOBDragDropEvent
      read FOnDragDrop write FOnDragDrop;
    property OnDragOver : TO32LOBDragOverEvent
      read FOnDragOver write FOnDragOver;
    property OnFolderClick : TO32FolderClickEvent
      read FOnFolderClick write FOnFolderClick;
    property OnItemClick : TO32ItemClickEvent
      read FOnItemClick write FOnItemClick;
    property OnFolderChange : TO32FolderChangeEvent
      read FOnFolderChange write FOnFolderChange;
    property OnFolderChanged : TO32FolderChangedEvent
      read FOnFolderChanged write FOnFolderChanged;
    property OnMouseOverItem : TO32MouseOverItemEvent
      read FOnMouseOverItem write FOnMouseOverItem;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer); override;
    { Declared public because TControl's DragDrop is public. }
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

    procedure BeginUpdate;
    procedure ClampSelectedItemInView;
    procedure ItemChanged(FolderIndex, ItemIndex: Integer);
    procedure FolderChanged(FolderIndex: Integer);
    procedure EndUpdate;
    function GetFolderAt(X, Y : Integer) : Integer;
    function GetItemAt(X, Y : Integer) : Integer;
    function Container: TO32FolderContainer;
    procedure InsertFolder(const ACaption : string; AFolderIndex : Integer);
    procedure AddFolder(const ACaption : string);
    procedure RenameFolder(AFolderIndex : Integer);
    procedure InsertItem(const ACaption : string; AFolderIndex, AItemIndex,
      AIconIndex : Integer);
    procedure AddItem(const ACaption : string; AFolderIndex,
      AIconIndex : Integer);
    procedure InvalidateItem(FolderIndex, ItemIndex : Integer);
    procedure RenameItem(AFolderIndex, AItemIndex : Integer);
    procedure RestoreState(
      const Section : string = '');
    procedure SaveState(
      const Section : string = '');

    property ActiveItem : Integer
      read FActiveItem;
    property Containers[Index: Integer]: TO32FolderContainer
      read GetContainer;
    property Folders[Index : Integer] : TO32LookOutFolder
      read GetFolder;
    property FolderCount : Integer
      read GetFolderCount;
    property PreviousFolder  : Integer
      read FPreviousFolder;
    property PreviousItem  : Integer
      read FPreviousItem;
  end;


  TO32LookoutBar = class(TO32CustomLookOutBar)
  published
    property ActiveFolder;
    property AllowRearrange;
    property BackgroundColor;
    property BackgroundImage;
    property BackgroundMethod;
    property BorderStyle;
    property ButtonHeight;
    property DrawingStyle default dsDefButton;
    property FolderCollection;
    property Images;
    property ItemFont;
    property ItemSpacing;
    property Orientation default loVertical;
    property PlaySounds default False;
    property ScrollDelta;
    property SelectedItem default -1;
    property SelectedItemFont;
    property ShowButtons default True;
    property SoundAlias;
    property Storage;

    {inherited Events}
    property AfterEnter;
    property AfterExit;
    property OnMouseWheel;

    {events}
    property OnArrange;
    property OnDragDrop;
    property OnDragOver;
    property OnFolderClick;
    property OnItemClick;
    property OnFolderChange;
    property OnFolderChanged;
    property OnMouseOverItem;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property Ctl3D;
    property DragCursor;
    property Enabled;
    property Font;
(*
    The following properties are not published to avoid conflicts with
    OnFolderClick and OnItemClick.
    property OnClick;
    property OnDblClick;
*)
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;


implementation

const
  lobTimerInterval = 200;

{DrawLookoutTab - returns the usable text area inside the tab rect.}
function DrawLookoutTab(Canvas: TCanvas;
                  const Client: TRect;
                        BevelWidth: Integer;
                        TabColor: TColor;
                        TabNumber: Integer;
                        CoolTab,
                        IsFocused,
                        IsMouseOver: Boolean): TRect;
var
//  NewStyle: Boolean;
  R: TRect;
//  DC: THandle;
//  Height, Width: Integer;
begin
  R := Client;
//  Height := R.Bottom;
//  Width := R.Right;

  with Canvas do begin
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    Pen.Color := TabColor;

    {fill the tab area}
    Polygon([Point(R.Left, R.Bottom),
             Point(R.Left, R.Top),
             Point(R.Right, R.Top),
             Point(R.Right, R.Bottom)]);

    if CoolTab then
    {Draw Cool Tabs}
    begin

      Pen.Color := clBlack;

      {Draw the bottom, left line}
      MoveTo(R.Left, R.Bottom - 1);
      LineTo(R.Left + 5, R.Bottom - 1);

      {Draw the bottom, left curve}
      PolyBezier([Point(R.Left + 5,    R.Bottom - 1),   {StartPoint}
                  Point(R.Left + 11,   R.Bottom - 2),   {ControlPoint}
                  Point(R.Left + 12,   R.Bottom - 7),   {ControlPoint}
                  Point(R.Left + 13,   R.Bottom - 9)]); {EndPoint}

      {Draw the left side of the tab}
      MoveTo(R.Left + 13, R.Bottom - 9);
      LineTo(R.Left + 13, R.Top + 9);

      {Draw the top, left corner of the tab}
      PolyBezier([Point(R.Left + 13,   R.Top + 9),     {StartPoint}
                  Point(R.Left + 14,   R.Top + 7),     {ControlPoint}
                  Point(R.Left + 15,   R.Top + 2),     {ControlPoint}
                  Point(R.Left + 21,   R.Top + 1)]);   {EndPoint}

      {Draw the top of the tab}
      MoveTo(R.Left + 21,   R.Top + 1);
      LineTo(R.Right - 16,  R.Top + 1);

      {Draw the Top, Right corner of the tab}
      PolyBezier([Point(R.Right - 16,   R.Top + 1),     {StartPoint}
                  Point(R.Right - 10,   R.Top + 2),     {ControlPoint}
                  Point(R.Right -  9,   R.Top + 7),     {ControlPoint}
                  Point(R.Right -  8,   R.Top + 9)]);   {EndPoint}

      {Draw the right side of the tab}
      MoveTo(R.Right - 8, R.Top + 9);
      LineTo(R.Right - 8, R.Bottom - 9);

      {Draw the bottom, Right curve of the tab which should finish against the
       right side.}
      PolyBezier([Point(R.Right - 8,   R.Bottom - 9),   {StartPoint}
                  Point(R.Right - 7,   R.Bottom - 7),   {ControlPoint}
                  Point(R.Right - 6,   R.Bottom - 2),   {ControlPoint}
                  Point(R.Right,       R.Bottom - 1)]); {EndPoint}

    end else begin
    {Draw Standard Tabs}

      if TabNumber > 0 then begin
        Brush.Color := TabColor;
        Brush.Style := bsSolid;
        Pen.Color := TabColor;

        {fill the tab area}
        Polygon([Point(R.Left, R.Bottom),
                 Point(R.Left, R.Top),
                 Point(R.Right, R.Top),
                 Point(R.Right, R.Bottom)]);
      end;

      Brush.Color := TabColor;
      Brush.Style := bsSolid;

      {Draw Tab}
      Pen.Color := TabColor;
      Polygon([Point(R.Left + 10,       R.Bottom - 1),
               Point(R.Left + 10,       R.Top + 3),
               Point(R.Left + 12,       R.Top + 1),
               Point(R.Right-4,    R.Top+1),
               Point(R.Right-2,    R.Top+3),
               Point(R.Right-2,    R.Bottom-1)]);

      {highlight tab}
      Pen.Color := clBtnHighlight;
      PolyLine([Point(R.Left,          R.Bottom - 2),
                Point(R.Left + 8,      R.Bottom - 2),
                Point(R.Left + 9,      R.Bottom - 3),
                Point(R.Left + 9,      R.Top + 3),
                Point(R.Left + 11,     R.Top + 1),
                Point(R.Right - 1,     R.Top + 1)]);

      {draw border}
      Pen.Color := clBlack;
      PolyLine([Point(R.Left,       R.Bottom - 1),
                Point(R.Left + 9,   R.Bottom - 1),
                Point(R.Left + 10,  R.Bottom - 2),
                Point(R.Left + 10,  R.Top + 4),
                Point(R.Left + 11,  R.Top + 3),
                Point(R.Left + 12,  R.Top + 2),
                Point(R.Right-2,    R.Top + 2),
                Point(R.Right-1,    R.Top + 3),
                Point(R.Right-1,    R.Bottom-1)]);

      {draw shadow}
    end;
  end;

  Result := Rect(Client.Left + 1, Client.Top + 1,
    Client.Right - 2, Client.Bottom - 2);
  if IsFocused then OffsetRect(Result, 1, 1);
end;

{===== TO32FolderContainer ===========================================}
constructor TO32FolderContainer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLookoutBar := TO32CustomLookoutBar(AOwner);
  Width := 0;
  Height := 0;
  Visible := false;
  {Add self to container list}
  FIndex := FLookoutBar.AddContainer(Self);
end;
{=====}

destructor TO32FolderContainer.Destroy;
begin
  {FComponentList.Free;}
  inherited;
end;
{=====}

function TO32FolderContainer.GetChildOwner: TComponent;
begin
  Result := Owner.Owner;
end;
{=====}

procedure TO32FolderContainer.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  C: TControl;
begin
  inherited GetChildren(Proc, Self);
  for I := 0 to ControlCount - 1 do begin
    C := Controls[I];
    C.Parent := Self;
    Proc(C);
  end;
end;

{===== TRenameEdit ===================================================}

constructor TO32RenameEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Ctl3D := False;
  Visible := False;
  WantReturns := False;
  FolderIndex := -1;
  ItemIndex   := -1;
end;
{=====}

procedure TO32RenameEdit.KeyPress(var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    DoExit;
  end else if Key = #27 then begin
    FolderIndex := -1;
    ItemIndex   := -1;
    Key := #0;
    DoExit;
  end;
end;

{===== Miscellaneous routines ========================================}

function RectWidth(Rect : TRect) : Integer;
begin
  Result := Rect.Right - Rect.Left;
end;
{=====}

function RectHeight(Rect : TRect) : Integer;
begin
  Result := Rect.Bottom - Rect.Top;
end;


{===== TO32LookOutBtnItem ===============================================}

constructor TO32LookOutBtnItem.Create(Collection : TCollection);
begin
  inherited Create(Collection);
  FFolder := TO32LookoutFolder((TO32Collection(Collection)).GetOwner);
  FIconIndex := -1;
  Name := 'Item' + IntToStr(FFolder.Index) + '-' + IntToStr(Index);
  FFolder.FLookoutBar.Invalidate;
end;
{=====}

destructor TO32LookOutBtnItem.Destroy;
var
  LoBar: TO32CustomLookoutBar;
  FolderIndex: Integer;
begin
  LoBar := FFolder.FLookoutBar;
  FolderIndex := FFolder.Index;
  inherited Destroy;
  LoBar.FolderChanged(FolderIndex);
end;
{=====}

procedure TO32LookOutBtnItem.Assign(Source: TPersistent);
begin
  if Source is TO32LookOutBtnItem then begin
    Caption := TO32LookOutBtnItem(Source).Caption;
    Description := TO32LookOutBtnItem(Source).Description;
    IconIndex := TO32LookOutBtnItem(Source).IconIndex;
    Tag := TO32LookOutBtnItem(Source).Tag;
  end else
    inherited Assign(Source);
end;
{=====}

procedure TO32LookOutBtnItem.SetCaption(const Value : string);
begin
  if Value <> FCaption then begin
    FCaption := Value;
    Changed(false);
    FFolder.FLookoutBar.ItemChanged(FFolder.Index, Index);
  end;
end;
{=====}

procedure TO32LookOutBtnItem.SetIconIndex(Value : Integer);
begin
  if Value <> FIconIndex then begin
    FIconIndex := Value;
    Changed(false);
    FFolder.FLookoutBar.ItemChanged(FFolder.Index, Index);
  end;
end;

{===== TO32LookOutBtnFolder =============================================}

constructor TO32LookOutFolder.Create(Collection : TCollection);
begin
  inherited Create(Collection);
  RegisterClass(TO32FolderContainer);
  FLookoutBar := TO32CustomLookoutBar(TO32Collection(Collection).GetOwner);
  FLookoutBar.ActiveFolder := Index;
  FItems := TO32Collection.Create(Self, TO32LookOutBtnItem);
  Name := 'LookoutFolder' + IntToStr(Index);
  FEnabled := True;
  FIconSize := isLarge;
end;
{=====}

destructor TO32LookOutFolder.Destroy;
begin
  {Change the Active Folder to one that will still exist}
  if not(csDestroying in FLookoutBar.ComponentState) then begin
    if Index > 0 then
      FLookoutBar.ActiveFolder := Index - 1
    else if Collection.Count > 1 then
      FLookoutBar.ActiveFolder := 0
    else
      FLookoutBar.ActiveFolder := -1;

    FLookoutBar.FolderChanged(Index);
  end;

  FItems.Free;
  FItems := nil;
  inherited Destroy;
end;
{=====}

function TO32LookOutFolder.GetItem(Index : Integer) : TO32LookOutBtnItem;
begin
  Result := TO32LookOutBtnItem(FItems[Index]);
end;
{=====}

function TO32LookOutFolder.GetItemCount : Integer;
begin
  Result := FItems.Count;
end;
{=====}

function TO32LookOutFolder.GetContainer: TO32FolderContainer;
begin
  if FolderType = ftContainer then
    result := FLookoutBar.FContainers[FContainerIndex]
  else
    result := nil;
end;
{=====}

procedure TO32LookOutFolder.lfGetEditorCaption(var Caption : string);
begin
  Caption := GetOrphStr(SCEditingItems);
end;
{=====}

procedure TO32LookOutFolder.lfItemChange(Sender : TObject);
begin
  if (TO32Collection(Collection).GetOwner is TComponent) then
    if not (csDestroying in
      TComponent(TO32Collection(Collection).GetOwner).ComponentState)
    then begin
      TO32LookOutBar(TO32Collection(Collection).GetOwner).lobRecalcDisplayNames;
      TO32LookOutBar(TO32Collection(Collection).GetOwner).Invalidate;
    end;
end;
{=====}

procedure TO32LookOutFolder.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('ContainerIndex', ReadIndex, WriteIndex,
    FFolderType = ftContainer);
end;
{=====}

procedure TO32LookOutFolder.ReadIndex(Reader: TReader);
begin
  ContainerIndex := trunc(Reader.ReadFloat);
end;
{=====}

procedure TO32LookOutFolder.WriteIndex(Writer: TWriter);
begin
  Writer.WriteFloat(ContainerIndex);
end;
{=====}

procedure TO32LookOutFolder.SetCaption(const Value : string);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Changed(false);
    FLookoutBar.FolderChanged(Index);
  end;
end;
{=====}

procedure TO32LookOutFolder.SetEnabled(Value : Boolean);
begin
  if Value <> FEnabled then begin
    FEnabled := Value;
    Changed(false);
    FLookoutBar.FolderChanged(Index);
  end;
end;
{=====}

procedure TO32LookOutFolder.SetFolderType(Value: TO32FolderType);
begin
  if Value <> FFolderType then begin
    FFolderType := Value;

    if not (csLoading in FLookoutBar.ComponentState) then begin
      if FFolderType = ftContainer then
        ContainerIndex := CreateContainer
      else begin
        FLookoutBar.FContainers.Delete(FContainerIndex);
        FContainerIndex := -1;
      end;
    FLookoutBar.FolderChanged(Index);
    end;
  end;
end;
{=====}

function TO32LookOutFolder.CreateContainer: Integer;
var
  New: TO32FolderContainer;
begin
  New := TO32FolderContainer.Create(FLookoutBar);
  New.Parent := FLookoutBar;
  result := New.Index;
  New.Name := 'Container' + IntToStr(Result);
  New.Caption := '';
  New.BevelOuter := bvNone;
  New.BevelInner := bvNone;
  New.Color := FLookoutBar.FBackgroundColor;
end;
{=====}

procedure TO32LookOutFolder.SetIconSize(Value : TO32IconSize);
begin
  if FIconSize <> Value then begin
    FIconSize := Value;
    Changed(false);
    FLookoutBar.FolderChanged(Index);
  end;
end;
{=====}

procedure TO32LookOutFolder.SetItem(Index : Integer; Value : TO32LookOutBtnItem);
begin
  SetItem(Index, Value);
end;

{===== TO32LookOutBar ================================================}
constructor TO32CustomLookOutBar.Create(AOwner : TComponent);
var
  HSnd : THandle;
begin
  inherited Create(AOwner);

  DoubleBuffered := true;

  FContainers := TO32ContainerList.Create(Self);

  FLoadingFolder := -1;
  FShowButtons := True;
  FOrientation := loVertical;
  if Classes.GetClass(TO32LookOutFolder.ClassName) = nil then
    Classes.RegisterClass(TO32LookOutFolder);
  if Classes.GetClass(TO32LookOutBtnItem.ClassName) = nil then
    Classes.RegisterClass(TO32LookOutBtnItem);

  FFolders := TO32Collection.Create(Self, TO32LookOutFolder);
  FFolders.OnChanged := lobFolderChange;
  FFolders.OnGetEditorCaption := lobGetEditorCaption;
  FFolders.OnItemSelected := lobFolderSelected;

  FItemFont := TFont.Create;
  FItemFont.Name := Font.Name;
  FItemFont.OnChange := lobFontChanged;
  FItemFont.Color := clWhite;
  FItemSpacing := abs(FItemFont.Height) + 3;

  FSelectedItemFont := TFont.Create;
  FSelectedItemFont.Name := Font.Name;
  FSelectedItemFont.OnChange := lobFontChanged;
  FSelectedItemFont.Color := FItemFont.Color;
  FSelectedItemFont.Style := FItemFont.Style;
  FSelectedItemFont.Size  := FItemFont.Size;

  {force drivers to load by playing empty wave data}
  HSnd := FindResource(HInstance, 'OREMPTYWAVE', RT_RCDATA);
  if HSnd > 0 then begin
    HSnd := LoadResource(HInstance, HSnd);
    if HSnd > 0 then begin
      sndPlaySound(LockResource(HSnd), SND_ASYNC or SND_MEMORY);
      // FreeResource(HSnd); //SZ FreeResource is a compatibility function for 16 bit Windows. It is not needed anymore.
    end;
  end;

  lobScrollUpBtn := TOvcSpeedButton.Create(Self);
  with lobScrollUpBtn do begin
    Visible := False;
    Parent := Self;
    OnClick := lobScrollUpBtnClick;
    Glyph.Handle := LoadBaseBitmap('ORUPARROW');
    NumGlyphs := 1;
    Left := -20;
    Height := 15;
    Width := 17;
    AutoRepeat := True;
  end;

  lobScrollDownBtn := TOvcSpeedButton.Create(Self);
  with lobScrollDownBtn do begin
    Visible := False;
    Parent := Self;
    OnClick := lobScrollDownBtnClick;
    Glyph.Handle := LoadBaseBitmap('ORDOWNARROW');
    NumGlyphs := 1;
    Left := -20;
    Height := 15;
    Width := 17;
    AutoRepeat := True;
  end;

  {create edit control}
  if not (csDesigning in ComponentState) then begin
    lobEdit := TO32RenameEdit.Create(Self);
    lobEdit.Parent := Self;
    lobEdit.OnExit := lobCommitEdit;
  end;

  Height := 240;
  Width := 120;
  ParentColor := False;

  FAllowRearrange  := True;
  FBackgroundColor := clInactiveCaption;
  FBackgroundImage := TBitmap.Create;
  FBackgroundMethod := bmNormal;
  FBorderStyle := bsSingle;
  FButtonHeight := 20;
  FActiveFolder := -1;
  FActiveItem := -1;
  FSelectedItem := -1;
  FHotFolder := -1;
  FPreviousFolder := -1;
  FPreviousItem := -1;
  FPlaySounds := False;
  FScrollDelta := 2;
  FSoundAlias := 'MenuCommand';

  lobMouseDown := False;
  lobChanging := False;
  lobTopItem := 0;
  lobDragFromItem := -1;
  lobDragFromFolder := -1;
  lobDropY := -1;
  lobTimer := -1;
  lobLastMouseOverItem := -1;
end;
{=====}

destructor TO32CustomLookOutBar.Destroy;
begin
  Images := nil; {unregister any image list notification}
  lobChanging := True;

  FContainers.Free;

  FFolders.Free;
  FFolders := nil;

  FItemFont.Free;
  FItemFont := nil;

  FSelectedItemFont.Free;
  FSelectedItemFont := nil;

  FBackgroundImage.Free;
  FBackgroundImage := nil;

  inherited Destroy;
end;
{=====}

procedure TO32CustomLookOutBar.BeginUpdate;
begin
  lobChanging := True;
end;
{=====}

{ - Added}
procedure TO32CustomLookOutBar.ClampSelectedItemInView;
begin
  lobTopItem := SelectedItem;
  Invalidate;
end;
{=====}

procedure TO32CustomLookOutBar.ItemChanged(FolderIndex, ItemIndex: Integer);
begin
  InvalidateItem(FolderIndex, ItemIndex);
  if not (csDestroying in ComponentState) then
    RecreateWnd;
end;
{=====}

procedure TO32CustomLookOutBar.FolderChanged(FolderIndex: Integer);
begin
  Invalidate;
  if not (csDestroying in ComponentState) then
    RecreateWnd;
end;
{=====}

procedure TO32CustomLookOutBar.CMCtl3DChanged(var Msg : TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;
{=====}

procedure TO32CustomLookOutBar.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  Msg.Result := Integer(lobOverButton);
end;
{=====}

procedure TO32CustomLookOutBar.CMFontChanged(var Message: TMessage);
begin
  lobRecalcDisplayNames;
end;
{=====}

procedure TO32CustomLookOutBar.CMParentColorChanged(var Message: TMessage);
begin
  inherited;

  if ParentColor then
    SetBackgroundColor(Color);
end;
{=====}

procedure TO32CustomLookOutBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
    Style := Integer(Style) or BorderStyles[FBorderStyle];

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.CreateWnd;
begin
  if (csDestroying in ComponentState) then exit;
  inherited CreateWnd;

  lobRecalcDisplayNames;
end;
{=====}

procedure TO32CustomLookOutBar.Loaded;
begin
  inherited Loaded;
  if DrawingStyle = dsEtchedButton then
    BorderStyle := bsNone;
  if FolderCollection.Count > 0 then
    FActiveFolder := 0
  else
    FActiveFolder := -1;
end;
{=====}

procedure TO32CustomLookOutBar.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FContainers.Count - 1 do
    Proc(TComponent(FContainers[I]));
end;
{=====}

function TO32CustomLookOutBar.AddContainer(
  Container: TO32FolderContainer): Integer;
begin
  result := FContainers.Add(Container);
end;
{=====}

procedure TO32CustomLookOutBar.RemoveContainer(Container: TO32FolderContainer);
begin
  FContainers.Remove(Container);
  Container.Free;
end;
{=====}

procedure TO32CustomLookOutBar.DoArrange;
begin
  if Assigned(FOnArrange) then
    FOnArrange(Self);
end;
{=====}

procedure TO32CustomLookOutBar.DoFolderChange(Index : Integer;
  var AllowChange: Boolean);
begin
  if Assigned(FOnFolderChange) then
    FOnFolderChange(Self, Index, AllowChange, lobDragFromItem <> -1);
end;
{=====}

procedure TO32CustomLookOutBar.DoFolderChanged(Index : Integer);
begin
  if Assigned(FOnFolderChanged) then
    FOnFolderChanged(Self, Index);
end;
{=====}

procedure TO32CustomLookOutBar.DoFolderClick(Button : TMouseButton;
                                       Shift : TShiftState;
                                       Index : Integer);
begin
  if Assigned(FOnFolderClick) then
    FOnFolderClick(Self, Button, Shift, Index);
end;
{=====}

procedure TO32CustomLookOutBar.DoItemClick(Button : TMouseButton;
                                     Shift : TShiftState;
                                     Index : Integer);
begin
  if Assigned(FOnItemClick) then
    FOnItemClick(Self, Button, Shift, Index);
end;
{=====}

procedure TO32CustomLookOutBar.DoMouseOverItem(X, Y, ItemIndex : Integer);
begin
  if Assigned(FOnMouseOverItem) then
    FOnMouseOverItem(Self,
      Folders[ActiveFolder].Items[GetItemAt(X, Y)]);
end;
{=====}

procedure TO32CustomLookOutBar.EndUpdate;
begin
  lobChanging := False;
  lobRecalcDisplayNames;
end;
{=====}

function TO32CustomLookOutBar.GetFolderCount : Integer;
begin
  Result := FFolders.Count;
end;
{=====}

function TO32CustomLookOutBar.GetFolder(Index : Integer)  : TO32LookOutFolder;
begin
  Result := TO32LookOutFolder(FFolders.GetItem(Index));
end;
{=====}

function TO32CustomLookOutBar.GetFolderAt(X, Y : Integer) : Integer;
var
  Dummy : Integer;
begin
  lobGetHitTest(X, Y, Result, Dummy);
end;
{=====}

function TO32CustomLookOutBar.GetContainer(Index: Integer):TO32FolderContainer;
begin
  try
    result := FContainers[Index];
  except
    result := nil;
  end;
end;
{=====}

function TO32CustomLookOutBar.GetItemAt(X, Y : Integer) : Integer;
var
  Dummy : Integer;
begin
  lobGetHitTest(X, Y, Dummy, Result);
end;
{=====}

function TO32CustomLookOutBar.Container: TO32FolderContainer;
begin
  if Folders[FActiveFolder].FolderType = ftContainer then
    result := FContainers[Folders[FActiveFolder].ContainerIndex]
  else
    result := nil;
end;
{=====}

procedure TO32CustomLookOutBar.InsertFolder(const ACaption : string;
                                                  AFolderIndex : Integer);
begin
  FFolders.Insert(AFolderIndex);
  Folders[AFolderIndex].Caption := ACaption;
  if FolderCount = 1 then begin
    FActiveFolder := 0;
    FActiveItem := -1;
    FSelectedItem := -1;
  end;
  lobRecalcDisplayNames;
end;
{=====}

procedure TO32CustomLookOutBar.AddFolder(const ACaption : string);
var
  NewFolder: TO32LookoutFolder;
begin
  NewFolder := TO32LookoutFolder(FFolders.Add);
  NewFolder.Caption := ACaption;
  if FolderCount = 1 then begin
    FActiveFolder := 0;
    FActiveItem := -1;
    FSelectedItem := -1;
  end;
  lobRecalcDisplayNames;
end;
{=====}

procedure TO32CustomLookOutBar.RenameFolder(AFolderIndex: Integer);
var
  Folder : TO32LookOutFolder;
begin
  Folder := Folders[AFolderIndex];
  lobEdit.FolderIndex := AFolderIndex;
  lobEdit.ItemIndex := -1;
  lobEdit.Font.Size := Font.Size;
  lobEdit.BorderStyle := bsNone;
  lobEdit.Top := Folder.lfRect.Top+2;
  lobEdit.Left := Folder.lfRect.Left+2;
  lobEdit.Height := HeightOf(Folder.lfRect)-5;
  lobEdit.Width := Folder.lfRect.Right - Folder.lfRect.Left-5;
  lobEdit.Visible := True;
  lobEdit.Text := Folder.Caption;
  lobEdit.SelectAll;
  lobEdit.SetFocus;
end;
{=====}

procedure TO32CustomLookOutBar.InsertItem(const ACaption : string;
                                    AFolderIndex, AItemIndex,
                                    AIconIndex : Integer);
var
  AFolder : TO32LookOutFolder;
begin
  AFolder := Folders[AFolderIndex];
  AFolder.FItems.Insert(AItemIndex);
  AFolder.Items[AItemIndex].Caption := ACaption;
  AFolder.Items[AItemIndex].IconIndex := AIconIndex;
  Invalidate;
end;
{=====}

procedure TO32CustomLookOutBar.AddItem(const ACaption : string;
                                             AFolderIndex,
                                             AIconIndex : Integer);
var
  AFolder : TO32LookOutFolder;
  AItem: TO32LookoutBtnItem;
begin
  AFolder := Folders[AFolderIndex];
  AItem := TO32LookoutBtnItem(AFolder.FItems.Add);
  AItem.Caption := ACaption;
  AItem.IconIndex := AIconIndex;
  Invalidate;
end;
{=====}

procedure TO32CustomLookOutBar.InvalidateItem(FolderIndex, ItemIndex : Integer);
var
  F : TRect;
  R : TRect;
begin
  R := TO32LookOutBtnItem(Folders[FolderIndex].Items[ItemIndex]).FIconRect;
  {expand rect}
  Dec(R.Top);
  Dec(R.Left);
  Inc(R.Bottom, 2);
  Inc(R.Right, 2);
  { Might be a hidden folder. }
  if (not ((FolderCount = 1) and (Folders[0].Caption = '')))
     or (csDesigning in ComponentState) then
    F := lobGetFolderArea(FolderIndex)
  else
    F := R;
  R.Top := MaxI(R.Top, F.Top);
  R.Bottom := MinI(R.Bottom, F.Bottom);
  if RectHeight(R) > 0 then
    InvalidateRect(Handle, @R, False);
end;
{=====}

procedure TO32CustomLookOutBar.RenameItem(AFolderIndex, AItemIndex : Integer);
var
  Item   : TO32LookOutBtnItem;
begin
  Item := Folders[AFolderIndex].Items[AItemIndex];
  lobEdit.FolderIndex := AFolderIndex;
  lobEdit.ItemIndex := AItemIndex;
  lobEdit.Font.Size := ItemFont.Size;
  lobEdit.Font.Size := ItemFont.Size;
  lobEdit.BorderStyle := bsSingle;
  lobEdit.Top := Item.LabelRect.Top-1;
  lobEdit.Left := 10;
  lobEdit.Height := HeightOf(Item.LabelRect) + 2;
  lobEdit.Width := Width - 24;
  lobEdit.Visible := True;
  lobEdit.Text := Item.Caption;
  lobEdit.SelectAll;
  lobEdit.SetFocus;
end;
{=====}

function GetLargeIconDisplayName(Canvas : TCanvas;
                                  Rect : TRect;
                                  const Name : string) : string;
  {-given a string, and a rectangle, find the string that can be displayed
    using two lines. Add ellipsis to the end of each line if necessary and
    possible}
var
  TestRect : TRect;
  SH, DH : Integer;
  Buf : array[0..255] of Char;
  I : Integer;
  TempName : string;
  Temp2 : string;
begin
  TempName := Trim(Name);
  {get single line height}
  with TestRect do begin
    Left := 0;
    Top := 0;
    Right := 1;
    Bottom := 1;
  end;
  SH := DrawText(Canvas.Handle, 'W W', 3, TestRect,
    DT_SINGLELINE or DT_CALCRECT);

  {get double line height}
  with TestRect do begin
    Left := 0;
    Top := 0;
    Right := 1;
    Bottom := 1;
  end;
  DH := DrawText(Canvas.Handle, 'W W', 3, TestRect,
    DT_WORDBREAK or DT_CALCRECT);

  {see if the text can fit within the existing rect without growing}
  TestRect := Rect;
  StrPLCopy(Buf, TempName, 255);
  DrawText(Canvas.Handle, Buf, Length(TempName), TestRect,
            DT_WORDBREAK or DT_CALCRECT);
  I := Pos(' ', TempName);
  if (RectHeight(TestRect) = SH) or (I < 2) then
    Result := GetDisplayString(Canvas, TempName, 1, RectWidth(Rect))
  else begin
    {the first line only has ellipsis if there's only one word on it and
    that word won't fit}
    Temp2 := GetDisplayString(Canvas, Copy(TempName, 1, I-1), 1,
                              RectWidth(Rect));
    if CompareStr(Temp2, Copy(TempName, 1, I-1)) <> 0 then begin
      Result := GetDisplayString(Canvas, Copy(TempName, 1, I-1), 1,
                                 RectWidth(Rect)) +
                ' ' +
                GetDisplayString(Canvas, Copy(TempName, I+1,
                                 Length(TempName) - I), 1, RectWidth(Rect));
    end else begin
      {2 or more lines, and the first line isn't getting an ellipsis}
      if (RectHeight(TestRect) = DH) and
         (RectWidth(TestRect) <= RectWidth(Rect)) then
        {it will fit}
        Result := TempName
      else begin
        {it won't fit, but the first line wraps OK - 2nd line needs an ellipsis}
        TestRect.Right := Rect.Right + 1;
        while (RectWidth(TestRect) > RectWidth(Rect)) or
              (RectHeight(TestRect) > DH) do begin
          if Length(TempName) > 1 then begin
            TestRect := Rect;
            Delete(TempName, Length(TempName), 1);
            TempName := Trim(TempName);
            StrPLCopy(Buf, TempName + '...', 255);
            DrawText(Canvas.Handle, Buf, Length(TempName) + 3, TestRect,
              DT_WORDBREAK or DT_CALCRECT);
            Result := TempName + '...';
          end else begin
            Result := TempName + '..';
            TestRect := Rect;
            StrPLCopy(Buf, Result, 255);
            DrawText(Canvas.Handle, Buf, Length(Result), TestRect,
                      DT_WORDBREAK or DT_CALCRECT);
            if (RectWidth(TestRect) <= RectWidth(Rect)) and
              (RectHeight(TestRect) > DH) then
                Break;
            Result := TempName + '.';
            TestRect := Rect;
            StrPLCopy(Buf, Result, 255);
            DrawText(Canvas.Handle, Buf, Length(Result), TestRect,
                      DT_WORDBREAK or DT_CALCRECT);
            if (RectWidth(TestRect) <= RectWidth(Rect)) and
              (RectHeight(TestRect) > DH) then
                Break;
            Result := TempName;
          end;
        end;
      end;
    end;
  end;
end;
{=====}

function TO32CustomLookOutBar.lobButtonRect(Index : Integer) : TRect;
begin
  Result := Folders[Index].lfRect;
end;
{=====}

procedure TO32CustomLookOutBar.lobCommitEdit(Sender : TObject);
var
  Folder : TO32LookOutFolder;
  Item   : TO32LookOutBtnItem;
begin
  if not Assigned(lobEdit) then
    Exit;

  if (lobEdit.FolderIndex > -1) then begin
    if lobEdit.ItemIndex = -1 then begin
      {rename the folder}
      Folder := Folders[lobEdit.FolderIndex];
      Folder.Caption := lobEdit.Text;
    end else begin
      Item := Folders[lobEdit.FolderIndex].Items[lobEdit.ItemIndex];
      Item.Caption := lobEdit.Text;
    end;
  end;
  lobEdit.FolderIndex := -1;
  lobEdit.ItemIndex   := -1;
  lobEdit.Visible     := False;
  Update;
end;
{=====}

function TO32CustomLookOutBar.lobDropHitTest(X, Y : Integer) : Boolean;
  {given an X, Y, is this a legal spot to drop a folder?}
var
  I           : Integer;
  SpaceTop    : Integer;
  SpaceBottom : Integer;
  OldDrop     : Integer;
  Folder      : TO32LookOutFolder;
begin
  Result := False;
  {assume that X,Y aren't on a folder or item}
  OldDrop := lobDropY;
  try
    lobDragToFolder := -1;
    lobDragToItem := -1;
    if FolderCount = 0 then
      Exit;

    Folder := Folders[FActiveFolder];
    if Y <= Folder.lfRect.Bottom then
      Exit;

    if FolderCount > FActiveFolder+1 then
      if Y >= Folders[FActiveFolder+1].lfRect.Top then
        Exit;

    if (X < 0) or (X > ClientWidth) then
      Exit;

    {we're somewhere in the active folder}
    if Folder.ItemCount = 0 then begin
      {the active folder is empty}
      lobDropY := Folders[FActiveFolder].lfRect.Bottom + 3;
      lobDragToFolder := FActiveFolder;
      lobDragToItem := 0;
      Result := True;
      Exit;
    end;

    for I := lobTopItem to Folder.ItemCount-1 do begin
      {is there space above this item?}
      if I = lobTopItem then
        SpaceTop := Folder.lfRect.Bottom+1
      else
        SpaceTop := TO32LookOutBtnItem(Folder.Items[I - 1]).FLabelRect.Bottom + 1;
      SpaceBottom := TO32LookOutBtnItem(Folder.Items[I]).FIconRect.Top - 1;
      if (Y >= SpaceTop) and (Y <= SpaceBottom) then begin
        if SpaceTop - SpaceBottom < 6 then
          lobDropY := SpaceTop + (SpaceBottom - SpaceTop) div 2
        else
          lobDropY := SpaceTop + 3;
        Result := True;
        lobDragToFolder := FActiveFolder;
        lobDragToItem := I;
        lobExternalDragItem := I;
        Exit;
      end;
    end;

    {check below the last item...}
    SpaceTop :=
      TO32LookOutBtnItem(Folder.Items[Folder.ItemCount - 1]).FLabelRect.Bottom+1;
    SpaceBottom := lobItemsRect.Bottom - 1;
    if (Y >= SpaceTop) and (Y <= SpaceBottom) then begin
      lobDropY := SpaceTop + 3;
      lobDragToFolder := FActiveFolder;
      lobDragToItem := Folder.ItemCount;
      if lobFolderAccept then
        lobExternalDragItem := lobDragToItem
      else
        lobExternalDragItem := Folder.ItemCount - 1;
      Result := True;
    end;

  finally
    if (lobDropY <> OldDrop) then
      Repaint;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.lobFolderChange(Sender : TObject);
var
  ParentForm: TCustomForm;
begin
  if not (csDestroying in ComponentState) then begin

    if FolderCount = 0 then
      FActiveFolder := -1
    else begin
      if Folders[FActiveFolder].FolderType = ftContainer then begin
        ParentForm := GetParentForm(Self);
        if ParentForm <> nil then
          if ContainsControl(ParentForm.ActiveControl) then
            ParentForm.ActiveControl := Self;
      end;
      if FActiveFolder = -1 then
        FActiveFolder := 0;
      if FActiveFolder >= FolderCount then
        FActiveFolder := 0;
    end;
    lobTopItem := 0;
    lobRecalcDisplayNames;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.lobFolderSelected(Sender : TObject; Index : Integer);
begin
  if not (csDestroying in ComponentState) then
    ActiveFolder := Index;
end;
{=====}

procedure TO32CustomLookOutBar.lobFontChanged(Sender : TObject);
begin
  Perform(CM_FONTCHANGED, 0, 0);
end;
{=====}

procedure TO32CustomLookOutBar.lobGetEditorCaption(var Caption : string);
begin
  Caption := GetOrphStr(SCEditingFolders);
end;
{=====}

procedure TO32CustomLookOutBar.lobGetHitTest(X, Y : Integer;
                                       var FolderIndex : Integer;
                                       var ItemIndex : Integer);
var
  I      : Integer;
  Item   : TO32LookOutBtnItem;
  Folder : TO32LookOutFolder;
begin
  FolderIndex := -1;
  ItemIndex := -1;

  if FolderCount > 0 then begin
    {see if we've hit a folder}
    for I := 0 to FolderCount-1 do begin
      Folder := Folders[I];
      if PtInRect(Folder.lfRect, Point(X, Y)) then begin
      lobCursorOverItem := False;
        FolderIndex := I;
        Exit;
      end;
    end;

    {nope, check the active folder to see if we've hit an item}
    Folder := Folders[FActiveFolder];
    for I := lobTopItem to Folder.ItemCount-1 do begin
      Item := Folder.Items[I];
      if PtInRect(Item.FIconRect, Point(X,Y)) or
         (PtInRect(Item.FLabelRect, Point(X,Y)) and
         (Item.Caption <> '')) then begin
        if lobExternalDrag then begin
          lobCursorOverItem := True;
          lobExternalDragItem := I;
        end;
        ItemIndex := I;
        Exit;
      end else
        if lobExternalDrag then
          lobCursorOverItem := False;
    end;
  end;
end;
{=====}

function TO32CustomLookOutBar.lobGetFolderArea(Index : Integer) : TRect;
var
  I : Integer;
begin
  Result := ClientRect;
  for I := 0 to ActiveFolder do
    Inc(Result.Top, FButtonHeight);
  for I := FolderCount-1 downto ActiveFolder+1 do
    Dec(Result.Bottom, FButtonHeight);
end;
{=====}

procedure TO32CustomLookOutBar.lobImagesChanged(Sender : TObject);
begin
  Invalidate;
end;
{=====}

procedure TO32CustomLookOutBar.lobRecalcDisplayNames;
var
  I : Integer;
begin
  if not HandleAllocated then
    exit;
  Canvas.Font := Self.Font;
  {figure out display names for each folder...}
  for I := 0 to FolderCount-1 do
    Folders[I].lfDisplayName := GetDisplayString(Canvas, Folders[I].Caption, 1,
      ClientWidth);
  Invalidate;
end;
{=====}

function TO32CustomLookOutBar.lobShowScrollDown : Boolean;
var
  Folder : TO32LookOutFolder;
  Item   : TO32LookOutBtnItem;
begin
  Result := False;
  if (FolderCount > 0) then begin
    Folder := Folders[FActiveFolder];
    if Folder.ItemCount > 0 then begin
      Item := Folder.Items[Folder.ItemCount-1];
      Result := Item.FLabelRect.Bottom > lobItemsRect.Bottom;
    end;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.lobScrollDownBtnClick(Sender : TObject);
begin
  if lobShowScrollDown then begin
    Inc(lobTopItem);
    InvalidateRect(Handle, @lobItemsRect, False);
  end;
end;
{=====}

function TO32CustomLookOutBar.lobShowScrollUp : Boolean;
begin
  Result := lobTopItem > 0;
end;
{=====}

procedure TO32CustomLookOutBar.lobScrollUpBtnClick(Sender : TObject);
begin
  if lobTopItem > 0 then begin
    Dec(lobTopItem);
    InvalidateRect(Handle, @lobItemsRect, False);
  end;
end;
{=====}

procedure TO32CustomLookOutBar.lobTimerEvent(Sender : TObject; Handle : Integer;
          Interval : Cardinal; ElapsedTime : Integer);
var
  Pt : TPoint;
  Form : TCustomForm;
begin
  GetCursorPos(Pt);
  Pt := ScreenToClient(Pt);
  if not PtInRect(ClientRect, Pt) then begin
    if not lobMouseDown then begin
      {we're not doing internal dragging anymore}
      lobMouseDown := False;
      lobDragFromFolder := -1;
      lobDragFromItem := -1;
      if lobDropY <> -1 then begin
        lobDropY := -1;
        Repaint;
      end;
      if FActiveItem <> -1 then begin
        InvalidateItem(FActiveFolder, FActiveItem);
        FActiveItem := -1;
      end;
    end else if FAllowRearrange then begin
      Form := GetParentForm(Self);
      if (Form <> nil) then
        if Form.Active then begin
          SetCursor(Screen.Cursors[crNoDrop]);
          lobDropY := -1;
          Repaint;
        end;
    end;
  end else begin
    if lobDragFromItem <> -1 then begin
      {we're still doing internal dragging - update the cursor}
      if lobDropHitTest(Pt.X, Pt.Y) then
        SetCursor(Screen.Cursors[DragCursor])
      else begin
        SetCursor(Screen.Cursors[crNoDrop]);
        lobDropY := -1;
        Repaint;
      end;
    end;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.MouseDown(Button : TMouseButton;
                                   Shift  : TShiftState;
                                   X, Y   : Integer);
begin
  {complete any editing}
  lobCommitEdit(nil);

  {get folder/item clicked}
  lobGetHitTest(X, Y, FPreviousFolder, FPreviousItem);

  {was it a click on a folder button?}
  if FPreviousFolder <> -1 then begin
    if Folders[FPreviousFolder].Enabled or
       (csDesigning in ComponentState) then begin
      if (Button = mbLeft) then begin
        lobMouseDown := True;
        Invalidate;
      end;
      Exit;
    end;
  end;

  if FPreviousItem <> -1 then begin
    if Folders[FActiveFolder].Enabled or
       (csDesigning in ComponentState) then begin
      if (Button = mbLeft) then begin
        InvalidateItem(FActiveFolder, FPreviousItem);
        lobMouseDown := True;
      end;
    end;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;
{=====}

procedure TO32CustomLookOutBar.MouseMove(Shift : TShiftState; X, Y : Integer);
var
  ItemIndex   : Integer;
  FolderIndex : Integer;
begin
  lobGetHitTest(X, Y, FolderIndex, ItemIndex);

  {if FActiveItem is valid, and mouse is down, we're starting dragging}
  if lobMouseDown or lobExternalDrag then begin
    if lobScrollDownBtn.Visible then begin
      if Y > lobScrollDownBtn.Top then begin
        Inc(lobTopItem);
        InvalidateRect(Handle, @lobItemsRect, False);
        inherited MouseMove(Shift, X, Y);
        Exit;
      end;
    end;
    if lobScrollUpBtn.Visible then begin
      if Y < (lobScrollUpBtn.Top + lobScrollUpBtn.Height)then begin
        Dec(lobTopItem);
        InvalidateRect(Handle, @lobItemsRect, False);
        inherited MouseMove(Shift, X, Y);
        Exit;
      end;
    end;
    if (FActiveItem <> -1) and (ItemIndex = -1) and FAllowRearrange then begin
      lobDragFromFolder := FActiveFolder;
      lobDragFromItem := FActiveItem;
      if (FolderIndex = -1) then begin
        if lobDropHitTest(X, Y) then
          SetCursor(Screen.Cursors[DragCursor])
        else begin
          SetCursor(Screen.Cursors[crNoDrop]);
          lobDropY := -1;
          Repaint;
        end;
      end;
    end;
    if (FolderIndex <> -1) and FAllowRearrange then begin
      ActiveFolder := FolderIndex;
      lobDropY := -1;
      FActiveItem := -1;
      Repaint;
    end;
  end else begin
    if ItemIndex <> -1 then begin
      if (ItemIndex <> FActiveItem) then begin
        if FActiveItem <> -1 then
          {invalidate the old activeItem}
          InvalidateItem(FActiveFolder, FActiveItem);
        FActiveItem := ItemIndex;
        if FActiveItem <> -1 then begin
          {invalidate the new active item}
          InvalidateItem(FActiveFolder, FActiveItem);
        end;
      end;
    end else if FActiveItem <> -1 then begin
      InvalidateItem(FActiveFolder, FActiveItem);
      FActiveItem := -1;
    end;
(*
!!.06 - Change
   Updating the flyover buttons causes a painting problem in container folders.
   This functionality has been disabled while a container folder is visible,
   until I can figure out how to solve the painting problem.
*)
    {Fix for problem 742134 kindly provided by Chris Milham - cmilham
     If no folders have been added to the lookoutbar an index out of
     bounds would appear. The first if avoids this.
     }
    if FActiveFolder>=0 then
      if (Folders[FActiveFolder].FFolderType = ftDefault) then begin
        if (FolderIndex <> -1) then begin
          if (FolderIndex <> FHotFolder) then begin
            if FHotFolder <> -1 then
              {invalidate the old activeItem}
              Invalidate;
            FHotFolder := FolderIndex;
            if FHotFolder <> -1 then begin
              {invalidate the new active item}
              Invalidate;
            end;
          end;
        end else if FHotFolder <> -1 then begin
          Invalidate;
          FHotFolder := -1;
        end;
      end;
  end;

  if ItemIndex <> - 1 then begin
    if lobLastMouseOverItem <> ItemIndex then
      DoMouseOverItem(X, Y, ItemIndex);
    lobLastMouseOverItem := ItemIndex;
  end else
    lobLastMouseOverItem := -1;

  inherited MouseMove(Shift, X, Y);
end;
{=====}

procedure TO32CustomLookOutBar.MouseUp(Button : TMouseButton; Shift : TShiftState;
          X, Y : Integer);
var
  FolderIndex : Integer;
  ItemIndex   : Integer;
  Folder      : TO32LookOutFolder;
  Item        : TO32LookOutBtnItem;
  FromItem    : TO32LookOutBtnItem;
  SourceName  : string;
begin

  if lobMouseDown then begin
    try
      lobGetHitTest(X, Y, FolderIndex, ItemIndex);

      if (FActiveItem <> -1) and (ItemIndex <> -1) then begin
        FSelectedItem := ItemIndex;
        InvalidateItem(FActiveFolder, ItemIndex);
        if FActiveItem = ItemIndex then
          DoItemClick(Button, Shift, ItemIndex);
      end;

      if lobDragFromItem <> -1 then begin
        if lobDropHitTest(X, Y) then begin
          {get the old item}
          Folder := Folders[lobDragFromFolder];
          FromItem := TO32LookOutBtnItem(Folder.Items[lobDragFromItem]);
          {create the new item}
          Folder := Folders[lobDragToFolder];


          Item := TO32LookOutBtnItem(Folder.FItems.Insert(lobDragToItem));
          Item.Assign(FromItem);
          SourceName := FromItem.Name;
          FromItem.Free;
          Item.Name := SourceName;
          lobRecalcDisplayNames;
          DoArrange;
        end;
        lobDragFromFolder := -1;
        lobDragFromItem := -1;
      end;

      if (ItemIndex = -1) then begin
        { Fire the OnFolderClick event. }
        DoFolderClick(Button, Shift, FolderIndex);
        ActiveFolder := FolderIndex;
      end;
    finally
      Invalidate;
      lobMouseDown := False;
    end;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;
{=====}

procedure TO32CustomLookOutBar.Notification(AComponent : TComponent;
                                            Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);


  if Operation = opRemove then begin
    if AComponent = FImages then
      Images := nil;
    if (AComponent = FStorage) then
      FStorage := nil;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.Paint;
var
  I             : Integer;
  J             : Integer;
  X             : Integer;
  W             : Integer;
  H             : Integer;
  CurPos        : Integer;
  HorzLeft      : Integer;
  yOffset       : Integer;
  BkMode        : Integer;
  LabelWidth    : Integer;
  Flags         : Integer;
  MyRect        : TRect;
  TR            : TRect;
  BkColor       : TColor;
  Folder        : TO32LookOutFolder;
  Item          : TO32LookOutBtnItem;
//  DrawBmp       : TBitmap;
  Text          : string;
  Buf           : array[0..255] of Char;
  DrawFolder    : Boolean;
  BM            : TBitmap;
  RowStart      : Integer;
  ILeft         : Integer;
  IHeight       : Integer;
  IWidth        : integer;

begin
  if lobChanging then
    Exit;

(*
  DrawBmp := TBitMap.Create;
  try
    DrawBmp.Width  := ClientWidth;
    DrawBmp.Height := ClientHeight;
*)
  {DrawBmp.}Canvas.Font := Self.Font;
  with {DrawBmp.}Canvas do begin
    Pen.Color := FBackgroundColor;
    Brush.Color := FBackgroundColor;

    MyRect := ClientRect;

    DrawFolder := (FolderCount > 0);

    if DrawFolder then
      TR := lobGetFolderArea(FActiveFolder)
    else
      TR := ClientRect;

    if FBackgroundImage.Empty or (FBackgroundMethod = bmNone) then
      Rectangle(TR.Left, TR.Top, TR.Right, TR.Bottom)

    else begin
      case FBackgroundMethod of
        bmNormal  :
            Draw(TR.Left, TR.Top, FBackgroundImage);

        bmStretch :
            StretchDraw(TR, FBackgroundImage);

        bmTile    :
          begin
            {Tile the background in the default folder}
            RowStart := 0;
            IHeight := FBackgroundImage.Height;
            IWidth  := FBackgroundImage.Width;
            ILeft   := 0;
            while (RowStart < ClientRect.Bottom) do begin
              while (ILeft < ClientRect.Right) do begin
                Draw(TR.Left + ILeft, RowStart, FBackgroundImage);
                Inc(ILeft, IWidth);
              end;
              ILeft := 0;
              Inc(RowStart, IHeight)
            end;
          end;
      end;
    end;

    CurPos := 0;
    if FolderCount = 0 then begin
      lobScrollUpBtn.Visible := False;
      lobScrollDownBtn.Visible := False;
      Exit;
    end;

    {draw the folder buttons at the top}
    if DrawFolder then begin
      for I := 0 to FActiveFolder do begin
        MyRect.Top := CurPos;
        MyRect.Bottom := CurPos + FButtonHeight;
        Folders[I].lfRect := MyRect;

        {Draw the top tabs based on the selected style...}
        case FDrawingStyle of

          dsDefButton : begin
            {Draw regular buttons}
            TR := DrawButtonFace({DrawBmp.}Canvas, MyRect, 1, bsNew,
              False, (I = FHotFolder) and lobMouseDown, False);
          end;

          dsEtchedButton : begin
            {Draw regular etched (Win98 style) buttons}
            Brush.Color := clBtnFace;
            FillRect(MyRect);
            Pen.Color := clBtnShadow;
            Brush.Style := bsClear;
            Rectangle(MyRect.Left, MyRect.Top, MyRect.Right - 1,
              MyRect.Bottom);
            Pen.Color := clBtnHighlight;
            MoveTo(MyRect.Left + 1, MyRect.Bottom - 2);
            LineTo(MyRect.Left + 1, MyRect.Top + 1);
            LineTo(MyRect.Right - 2, MyRect.Top + 1);
            { Draw border around control. }
            MoveTo(Width - 1, Top);
            LineTo(Width - 1, Height - 1);
            LineTo(0, Height - 1);
            Pen.Color := clWindowFrame;
            MoveTo(Width - 1, MyRect.Bottom);
            LineTo(1, MyRect.Bottom);
            LineTo(1, Height - 1);
            TR := MyRect;
          end;

         dsCoolTab: begin
            {Draw cool (Netscape Sidebar style) tabs}
            TR := DrawLookoutTab({DrawBmp.}Canvas,     {Canvas}
                          MyRect,                      {Client Rect}
                          1,                           {Bevel Width}
                          FBackgroundColor,            {Tab Color}
                          I,                           {Tab Number}
                          true,                        {Cool Tabs?}
                          (I = FHotFolder),            {Is Focused}
                          (I = lobLastMouseOverItem)); {MouseOverItem}
          end;

          dsStandardTab: begin
            {Draw regular old tabs}
            TR := DrawLookoutTab({DrawBmp.}Canvas,     {Canvas}
                          MyRect,                      {Client Rect}
                          1,                           {Bevel Width}
                          FBackgroundColor,            {Tab Color}
                          I,                           {Tab Number}
                          false,                       {Cool Tabs?}
                          (I = FHotFolder),            {Is Focused}
                          (I = lobLastMouseOverItem)); {MouseOverItem}
          end;

        end;
        StrPLCopy(Buf, Folders[I].lfDisplayName, 255);
        Inc(TR.Top);
        Flags := DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
        if Folders[I].Enabled then begin
          DrawText({DrawBmp.}Canvas.Handle, Buf, StrLen(Buf), TR, Flags);
          if (I = FHotFolder) and not lobMouseDown then begin

            case FDrawingStyle of

              dsDefButton : begin
                { Regular button style. }
                  InflateRect(TR,1,1);
                  inc(TR.Left);
                  Frame3D({DrawBmp.}Canvas, TR, clBtnHighlight,
                    clWindowFrame, 1);
                end;

              dsEtchedButton : begin
                { Etched style (Outlook98). }
                Pen.Color := clWindowFrame;
                MoveTo(TR.Right - 2, TR.Top);
                LineTo(TR.Right - 2, TR.Bottom - 1);
                LineTo(0, TR.Bottom - 1);
                Pen.Color := clBtnShadow;
                if I = ActiveFolder then
                  yOffset := 1
                else
                  yOffset := 2;
                MoveTo(TR.Right - 3, TR.Top - 2);
                LineTo(TR.Right - 3, TR.Bottom - yOffset);
                LineTo(1, TR.Bottom - yOffset);
                if I = ActiveFolder then
                  Pixels[1, TR.Bottom - yOffset] := clBtnHighlight;
              end;
            end;
          end;
        end else begin
          {use shadow text for inactive folder text}
          {DrawBmp.}Canvas.Font.Color := clHighlightText;
          SetBkMode(Canvas.Handle, OPAQUE);
          DrawText({DrawBmp.}Canvas.Handle, Buf, -1, TR, Flags);
          SetBkMode({DrawBmp.}Canvas.Handle, TRANSPARENT);
          {DrawBmp.}Canvas.Font.Color := clBtnShadow;
          OffsetRect(TR, -2, -1);
          DrawText({DrawBmp.}Canvas.Handle, Buf, -1, TR, Flags);
          {DrawBmp.}Canvas.Font.Color := Self.Font.Color;
        end;
        Inc(CurPos, FButtonHeight);
      end;
    end else begin
      if FDrawingStyle = dsEtchedButton then begin
        { Draw border around control. }
        Pen.Color := clBtnHighlight;
        MoveTo(Width - 1, Top);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        Pen.Color := clWindowFrame;
        MoveTo(0, Height - 1);
        LineTo(0, 1);
        LineTo(Width - 2, 1);
      end;
      CurPos := 0;
    end;

    BkMode := GetBkMode(Handle);
    BkColor := GetBkColor(Handle);
    SetBkColor(Handle, DWord(FBackgroundColor));
    SetBkMode(Handle, TRANSPARENT);

    {draw the items for the active folder}
    Folder := Folders[FActiveFolder];

    if Folder.FolderType = ftDefault then
      if Folder.ItemCount > 0 then begin
        Inc(CurPos, 8);
        with lobItemsRect do begin
          Top := CurPos;
          Left := 0;
          Right := ClientWidth;
          Bottom := ClientHeight
                  - (FolderCount - FActiveFolder - 1) * FButtonHeight + 1;
        end;

        for J := 0 to Folder.ItemCount-1 do
          TO32LookOutBtnItem(Folder.Items[J]).FLabelRect.Bottom :=
             lobItemsRect.Bottom + 1;

        {Horizontal Left Side}
        HorzLeft := 5;

        for J := lobTopItem to Folder.ItemCount-1 do begin
          if (FSelectedItem = J) then
            {DrawBmp.}Canvas.Font := FSelectedItemFont
          else
            {DrawBmp.}Canvas.Font := FItemFont;

          Item := Folder.Items[J];
          {If the caption is empty at designtime then display the item's name
           instead}
          if (csDesigning in ComponentState) and (Item.Caption = '') then
            Text := Item.Name
          else
            Text := Item.Caption;

          if Folder.IconSize = isLarge then begin {large icons}
          {glyph is at the top}
{ - begin}
            if Orientation = loVertical then begin
              { vertical orientation (Default) }
              with Item.FIconRect do begin
                { If an image list is assigned then use the image }
                { size. If no image list is assinged then assume  }
                { a 32 x 32 image size. }
                if Assigned(FImages) then begin
                  W := FImages.Width + 2;
                  H := FImages.Height + 2;
                end else begin
                  W := 32;
                  H := 32;
                end;
                Top := CurPos;
                Bottom := CurPos + H;
                Left := (ClientWidth - W) shr 1;
                Right := Left + W;
                if Top > lobItemsRect.Bottom then
                  Break;
                if FShowButtons then begin
                  if FActiveItem = J then begin
                    if lobMouseDown then
                      Pen.Color := clBlack
                    else
                      Pen.Color := clWhite;
                    MoveTo(Left-1, Bottom+1);
                    LineTo(Left-1, Top-1);
                    LineTo(Right+1, Top-1);
                    if lobMouseDown then
                      Pen.Color := clWhite
                    else
                      Pen.Color := clBlack;
                    LineTo(Right+1, Bottom+1);
                    LineTo(Left-1, Bottom+1);
                  end else begin
                    Pen.Color := FBackgroundColor;
                    Brush.Color := FBackgroundColor;
                  end;
                  if Assigned(FImages) and
                     (Item.IconIndex >= 0) and
                     (Item.IconIndex < FImages.Count) then
                    FImages.Draw({DrawBmp.}Canvas,
                      Item.FIconRect.Left + 2, Item.FIconRect.Top + 2,
                      Item.IconIndex);
                  {make the icon's bottom blend into the label's top}
                  Item.FIconRect.Bottom := Item.FIconRect.Bottom + 4;
                end;
              end;
              Inc(CurPos, H + 4);

              {now, draw the text}
              with Item.FLabelRect do begin
                Top := CurPos;
                Bottom := CurPos + (FButtonHeight shl 1) - 7;
                Left := 0;
                Right := ClientWidth - 1;
                Item.liDisplayName := GetLargeIconDisplayName(
                  {DrawBmp.}Canvas, Item.FLabelRect, Text);
                X := {DrawBmp.}Canvas.TextWidth(Item.liDisplayName);
                Left := (ClientWidth - X) div 2;
                if Left < 5 then
                  Left := 5;
                Right := Left + X;
                if Right > ClientWidth-5 then
                  Right := ClientWidth-5;
                if Top > lobItemsRect.Bottom then
                  Break;
              end;
            end else begin
              { Horizontal orientation (optional) }
              {Set up the text rect size}
              Item.FLabelRect.Top := lobItemsRect.Top + FButtonHeight + 2;
              Item.FLabelRect.Bottom := Top + (FButtonHeight shl 1) - 7;
              Item.FLabelRect.Left := HorzLeft;
              Item.FLabelRect.Right := lobItemsRect.Right - 2;
              Item.liDisplayName := GetLargeIconDisplayName(
                {DrawBmp.}Canvas, Item.FLabelRect, Text);
              X := {DrawBmp.}Canvas.TextWidth(Item.liDisplayName);
              Item.FLabelRect.Right := Item.FLabelRect.Left + X;
              if Item.FLabelRect.Right > lobItemsRect.Right then
                Break;
              with Item.FIconRect do begin
                { If an image list is assigned then use the image }
                { size. If no image list is assinged then assume  }
                { a 32 x 32 image size. }
                if Assigned(FImages) then begin
                  W := FImages.Width + 2;
                  H := FImages.Height + 2;
                end else begin
                  W := 32;
                  H := 32;
                end;

                Top := lobItemsRect.Top;
                Bottom := Top + H;
                Left := HorzLeft + ((Item.FLabelRect.Right - Item.FLabelRect.Left) div 2)
                  - (FButtonHeight div 2) ;
                Right := Left + FButtonHeight;
                if Right > lobItemsRect.Right then
                  Break;

                if FShowButtons then begin
                  if FActiveItem = J then begin
                    if lobMouseDown then
                      Pen.Color := clBlack
                    else
                      Pen.Color := clWhite;
                    MoveTo(Left-1, Bottom+1);
                    LineTo(Left-1, Top-1);
                    LineTo(Right+1, Top-1);
                    if lobMouseDown then
                      Pen.Color := clWhite
                    else
                      Pen.Color := clBlack;
                    LineTo(Right+1, Bottom+1);
                    LineTo(Left-1, Bottom+1);
                  end else begin
                    Pen.Color := FBackgroundColor;
                    Brush.Color := FBackgroundColor;
                  end;
                  if Assigned(FImages) and
                     (Item.IconIndex >= 0) and
                     (Item.IconIndex < FImages.Count) then
                    FImages.Draw({DrawBmp.}Canvas,
                      Item.FIconRect.Left + 2, Item.FIconRect.Top + 2,
                      Item.IconIndex);
                  {make the icon's bottom blend into the label's top}
                  Item.FIconRect.Bottom := Item.FIconRect.Bottom + 4;
                end;
              end;
              Inc(HorzLeft, Item.FLabelRect.Right - Item.FLabelRect.Left + 10);
            end;
{ - end}
            StrPLCopy(Buf, Item.liDisplayName, 255);
            DrawText({DrawBmp.}Canvas.Handle, Buf,
              Length(Item.liDisplayName), Item.FLabelRect,
              DT_CENTER or DT_VCENTER or
                     DT_WORDBREAK or DT_CALCRECT);
            LabelWidth := RectWidth(Item.FLabelRect);
            if Orientation = loVertical then
              with Item.FLabelRect do begin
                Left := (ClientWidth - LabelWidth) div 2;
                Right := Left + LabelWidth + 1;
              end;

            BkMode := SetBkMode({DrawBmp.}Canvas.Handle, TRANSPARENT);
            Inc(CurPos, DrawText({DrawBmp.}Canvas.Handle, Buf,
                      Length(Item.liDisplayName),
                      Item.FLabelRect,
                      DT_CENTER or DT_VCENTER or DT_WORDBREAK));
            SetBkMode({DrawBmp.}Canvas.Handle, BkMode);
            if Orientation = loVertical then
              Inc(CurPos, FItemSpacing);


          end else begin {small icons}
            {glyph is at the left}
            with Item.FIconRect do begin
              Top := CurPos;
              yOffset := (Abs({DrawBmp.}Canvas.Font.Height)) div 2;
              if yOffset > 8 then
                Top := Top + yOffset - 8;
              Bottom := Top + 16;
              Left := 8;
              Right := Left + 16;
              if Top > lobItemsRect.Bottom then
                Break;

              if FShowButtons then begin
                if FActiveItem = J then begin
                  if lobMouseDown then
                    Pen.Color := clBlack
                  else
                    Pen.Color := clWhite;
                  MoveTo(Left-1, Bottom+1);
                  LineTo(Left-1, Top-1);
                  LineTo(Right+1, Top-1);
                  if lobMouseDown then
                    Pen.Color := clWhite
                  else
                    Pen.Color := clBlack;
                  LineTo(Right+1, Bottom+1);
                  LineTo(Left-1, Bottom+1);
                  Brush.Color := FBackgroundColor;
                end else begin
                  Pen.Color := FBackgroundColor;
                  Brush.Color := FBackgroundColor;
                  Rectangle(Item.FIconRect.Left - 1,
                             Item.FIconRect.Top - 1,
                             Item.FIconRect.Right + 1,
                             Item.FIconRect.Bottom + 1);
                end;
                if Assigned(FImages) then begin
                  BM := TBitmap.Create;
                  try
                    BM.Width := FImages.Width;
                    BM.Height := FImages.Height;
                    { 04.05.2011: Change suggested by Nathan Sutcliffe
                      fixes the problem that images with transparent color were not
                      painted properly when "small icons" are used (issue 1307362). }
                    BM.Canvas.Brush.Color := FBackgroundColor;
                    BM.Canvas.FillRect( Rect( 0, 0, BM.Width, BM.Height ) );
                    FImages.Draw(BM.Canvas, 0, 0, Item.IconIndex);
                    {DrawBmp.}Canvas.BrushCopy(Item.FIconRect, BM,
                      Rect(0, 0, BM.Width, BM.Height), BM.Canvas.Pixels[0,
                        BM.Height-1]);
                  finally
                    BM.Free;
                  end;
                end;
              end;
              {make the icon's right blend into the label's left}
              Item.FIconRect.Right := Item.FIconRect.Right + 3;
            end;

            {now, draw the text}
            with Item.FLabelRect do begin
              Top := CurPos;
              Bottom := CurPos + (FButtonHeight shl 1) -7;
              Left := Item.FIconRect.Right;
              X := Self.ClientWidth - Left - 7;
              Right := Left + X;
              if Top > lobItemsRect.Bottom then
                Break;
            end;
            Item.liDisplayName :=
              GetDisplayString({DrawBmp.}Canvas, Text, 1,
                RectWidth(Item.FLabelRect));
            StrPLCopy(Buf, Item.liDisplayName, 255);
            DrawText({DrawBmp.}Canvas.Handle, Buf,
              Length(Item.liDisplayName), Item.FLabelRect,
              DT_LEFT or DT_VCENTER or DT_CALCRECT);
            LabelWidth := RectWidth(Item.FLabelRect);
            with Item.FLabelRect do
              Right := Left + LabelWidth + 1;
            DrawText({DrawBmp.}Canvas.Handle, Buf,
              Length(Item.liDisplayName), Item.FLabelRect,
              DT_LEFT or DT_VCENTER);

            Inc(CurPos, FItemSpacing);
          end;
        end;
    end;


    {now, draw the folder buttons at the bottom}
    {DrawBmp.}Canvas.Font := Self.Font;
    SetBkMode(Handle, BkMode);
    SetBkColor(Handle, BkColor);

    case FDrawingStyle of
      { Regular button style. }
      dsDefButton :
        CurPos := ClientHeight - FButtonHeight;
      { Etched style (Outlook98). }
      dsEtchedButton :
        CurPos := ClientHeight - FButtonHeight - 1;
      { Cool Tab }
      dsCoolTab:
        CurPos := ClientHeight - FButtonHeight;
      { Regular Tab }
      dsStandardTab:
        CurPos := ClientHeight - FButtonHeight;
    end;

    for I := FolderCount-1 downto FActiveFolder+1 do begin
      MyRect.Top := CurPos;
      MyRect.Bottom := CurPos + FButtonHeight;
      Folders[I].lfRect := MyRect;
      case FDrawingStyle of

        dsDefButton : begin
          {Regular Old Buttons}
          TR := DrawButtonFace({DrawBmp.}Canvas, MyRect, 1, bsNew, False,
            (I = FHotFolder) and lobMouseDown, False);
        end;

        dsEtchedButton : begin
          {Etched (Outlook98 style) buttons}
          Brush.Color := clBtnFace;
          FillRect(MyRect);
          Pen.Color := clBtnShadow;
          Brush.Style := bsClear;
          Rectangle(MyRect.Left, MyRect.Top, MyRect.Right - 1,
            MyRect.Bottom);
          Pen.Color := clBtnHighlight;
          MoveTo(MyRect.Left + 1, MyRect.Bottom - 2);
          LineTo(MyRect.Left + 1, MyRect.Top + 1);
          LineTo(MyRect.Right - 2, MyRect.Top + 1);
          Pen.Color := clBtnHighlight;
          MoveTo(Width - 1, 0);
          LineTo(Width - 1, Height);
          TR := MyRect;
        end;

        dsCoolTab: begin
          {Draw cool (Netscape Sidebar style) tabs}
          TR := DrawLookoutTab({DrawBmp.}Canvas,     {Canvas}
                        MyRect,                      {Client Rect}
                        1,                           {Bevel Width}
                        FBackgroundColor,            {Tab Color}
                        I,                           {Tab Number}
                        true,                        {Cool Tabs?}
                        (I = FHotFolder),            {Is Focused}
                        (I = lobLastMouseOverItem)); {MouseOverItem}
        end;

        dsStandardTab: begin
          {Draw regular old tabs}
          TR := DrawLookoutTab({DrawBmp.}Canvas,     {Canvas}
                        MyRect,                      {Client Rect}
                        1,                           {Bevel Width}
                        FBackgroundColor,            {Tab Color}
                        I,                           {Tab Number}
                        false,                       {Cool Tabs?}
                        (I = FHotFolder),            {Is Focused}
                        (I = lobLastMouseOverItem)); {MouseOverItem}
        end;

      end;
      Inc(TR.Top);
      StrPLCopy(Buf, Folders[I].lfDisplayName, 255);
      Flags := DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
      if Folders[I].Enabled then begin
        DrawText({DrawBmp.}Canvas.Handle, Buf, StrLen(Buf), TR, Flags);
        if (I = FHotFolder) and not lobMouseDown then begin
          case FDrawingStyle of

            dsDefButton : begin
              { Regular button style. }
              InflateRect(TR,1,1);
              inc(TR.Left);
              Frame3D({DrawBmp.}Canvas, TR, clBtnHighlight,
                clWindowFrame, 1);
            end;

            dsEtchedButton : begin
              { Etched (Outlook98 style). }
              Pen.Color := clWindowFrame;
              MoveTo(TR.Right - 2, TR.Top);
              LineTo(TR.Right - 2, TR.Bottom - 1);
              LineTo(0, TR.Bottom - 1);
              Pen.Color := clBtnShadow;
              MoveTo(TR.Right - 3, TR.Top - 2);
              LineTo(TR.Right - 3, TR.Bottom - 2);
              LineTo(1, TR.Bottom - 2);
            end;
          end;
        end;
      end else begin
        {use shadow text for inactive folder text}
        {DrawBmp.}Canvas.Font.Color := clHighlightText;
        SetBkMode(Canvas.Handle, OPAQUE);
        DrawText({DrawBmp.}Canvas.Handle, Buf, -1, TR, Flags);
        SetBkMode({DrawBmp.}Canvas.Handle, TRANSPARENT);
        {DrawBmp.}Canvas.Font.Color := clBtnShadow;
        OffsetRect(TR, -2, -1);
        DrawText({DrawBmp.}Canvas.Handle, Buf, -1, TR, Flags);
        {DrawBmp.}Canvas.Font.Color := Self.Font.Color;
      end;
      Dec(CurPos, FButtonHeight);
    end;

    if not (csDesigning in ComponentState) then begin
      {show the top scroll button}
      if lobShowScrollUp then begin
        lobScrollUpBtn.Top := Folders[FActiveFolder].lfRect.Bottom + 5;
        lobScrollUpBtn.Left := ClientWidth - 20;
        lobScrollUpBtn.Visible := True;
      end else
        lobScrollUpBtn.Visible := False;

      {show the bottom scroll button}
      if lobShowScrollDown then begin
        if FActiveFolder = FolderCount-1 then
          {there are no folders beyond the active one}
          lobScrollDownBtn.Top := ClientHeight -20
        else
          lobScrollDownBtn.Top := Folders[FActiveFolder+1].lfRect.Top - 20;
        lobScrollDownBtn.Left := ClientWidth - 20;
        lobScrollDownBtn.Visible := True;
      end else
        lobScrollDownBtn.Visible := False;
    end;
    {if we're dragging, show the drag marker}
    if (lobDragFromItem <> -1) or lobExternalDrag then begin
      if (lobDropY <> -1) then begin
        { Don't draw the drag marker if we're doing external }
        { dragging and the cursor is over an item. }
        if lobExternalDrag then
          if not lobFolderAccept or lobCursorOverItem then
            Exit;
        Pen.Color := clBlack;
        Brush.Color := clBlack;
        MoveTo(5, lobDropY);
        LineTo(ClientWidth - 5, lobDropY);
        {DrawBmp.}Canvas.Polygon([ Point(3,lobDropY+4),
                         Point(7,lobDropY),
                         Point(3, lobDropY-4)]);
        {DrawBmp.}Canvas.FloodFill(5, lobDropY, clBlack, fsBorder);
        {DrawBmp.}Canvas.Polygon([ Point(ClientWidth-3,lobDropY+4),
                         Point(ClientWidth-7,lobDropY),
                         Point(ClientWidth-3,lobDropY-4)]);
        {DrawBmp.}Canvas.FloodFill(ClientWidth-5, lobDropY, clBlack,
          fsBorder);
      end;
    end;
  end;
(*
  finally
    Canvas.CopyMode := cmSrcCopy;
    Canvas.CopyRect(ClientRect, DrawBmp.Canvas, ClientRect);
    DrawBmp.Free;
  end;
*)

  {For container style folders...}

  {Hide the containers for all inactive folders}
  for I := 0 to FFolders.Count - 1 do begin
    if I <> FActiveFolder then begin
      if Folders[i].FolderType = ftContainer then
      with Containers[Folders[i].ContainerIndex] do begin
        Width := 0;
        Height := 0;
        Visible := false;
      end;
    end;
  end;

  Folder := Folders[FActiveFolder];
  TR := lobGetFolderArea(FActiveFolder);

  if Folder.FolderType = ftContainer then
  with Containers[Folder.ContainerIndex] do begin
  {Position and show the folder's container}
    Height := TR.Bottom - TR.Top;
    Top := TR.Top;
    Left := TR.Left;
    Width := TR.Right - TR.Left;
    Visible := true;
    BringToFront;

    for I := 0 to ControlCount - 1 do
      Controls[i].Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.RestoreState(const Section : string = '');
var
  F, FC       : Integer;
  I, IC       : Integer;
  Folder      : TO32LookOutFolder;
  Item        : TO32LookOutBtnItem;
  S           : string;
  SectionName : string;
begin
  if Assigned(FStorage) then begin
    FFolders.Clear;
    if Section = '' then
      SectionName := GetDefaultSection(Self)
    else
      SectionName := Section;
    FStorage.Open;
    try
      {load folder count}
      FC := FStorage.ReadInteger(SectionName, 'FolderCount', 0);
      {load each folder's information}
      for F := 0 to FC-1 do begin
        S := 'Folder.' + IntToStr(F);
        Folder := TO32LookOutFolder(FolderCollection.Add);
        Folder.Caption := FStorage.ReadString(SectionName, S + '.Caption', '');
        Folder.Enabled := FStorage.ReadBoolean(SectionName, S + '.Enabled',
          True);
        Folder.IconSize := TO32IconSize(FStorage.ReadInteger(SectionName, S
          + '.IconSize', Ord(isLarge)));
        Folder.Tag := FStorage.ReadInteger(SectionName, S + '.Tag', 0);
        {load item count}
        IC := FStorage.ReadInteger(SectionName, S + '.ItemCount', 0);
        {load each item's information}
        for I := 0 to IC-1 do begin
          Item := TO32LookOutBtnItem(Folder.ItemCollection.Add);
          S := 'Folder.' + IntToStr(F) + '.Item.' + IntToStr(I);
          Item.Caption := FStorage.ReadString(SectionName, S + '.Caption', '');
          Item.Description := FStorage.ReadString(SectionName, S
            + '.Description', '');
          Item.IconIndex := FStorage.ReadInteger(SectionName, S
            + '.IconIndex', -1);
          Item.Tag := FStorage.ReadInteger(SectionName, S + '.Tag', 0);
        end;
      end;
    finally
      FStorage.Close;
    end;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SaveState(const Section : string = '');
var
  F           : Integer;
  I           : Integer;
  S           : string;
  SectionName : string;
begin
  if Assigned(FStorage) then begin
    if Section = '' then
      SectionName := GetDefaultSection(Self)
    else
      SectionName := Section;
    FStorage.Open;
    try
      FStorage.EraseSection(SectionName);
      {save folder count}
      FStorage.WriteInteger(SectionName, 'FolderCount', FolderCount);
      {save each folder's information}
      for F := 0 to FolderCount-1 do begin
        S := 'Folder.' + IntToStr(F);
        FStorage.WriteString(SectionName, S + '.Caption', Folders[F].Caption);
        FStorage.WriteBoolean(SectionName, S + '.Enabled', Folders[F].Enabled);
        FStorage.WriteInteger(SectionName, S + '.IconSize',
          Ord(Folders[F].IconSize));
        FStorage.WriteInteger(SectionName, S + '.Tag', Folders[F].Tag);
        {save item count}
        FStorage.WriteInteger(SectionName, S + '.ItemCount',
          Folders[F].ItemCount);
        {save each item's information}
        for I := 0 to Folders[F].ItemCount-1 do begin
          S := 'Folder.' + IntToStr(F) + '.Item.' + IntToStr(I);
          FStorage.WriteString(SectionName, S + '.Caption',
            Folders[F].Items[I].Caption);
          FStorage.WriteString(SectionName, S + '.Description',
            Folders[F].Items[I].Description);
          FStorage.WriteInteger(SectionName, S + '.IconIndex',
            Folders[F].Items[I].IconIndex);
          FStorage.WriteInteger(SectionName, S + '.Tag',
            Folders[F].Items[I].Tag);
        end;
      end;
    finally
      FStorage.Close;
    end;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetActiveFolder(Value : Integer);
var
  Y      : Integer;
  YDelta : Integer;
  R      : TRect;
  R2     : TRect;
  Buf    : array[0..1023] of Char;
  AllowChange : Boolean;
begin
  if Value <> FActiveFolder then begin

    if FolderCount = 0 then
      FActiveFolder := -1
    else if (Value > -1) and (Value < FolderCount) then begin

    { Fire DoFolderChange only if not dragging. }
    if lobDragFromItem = -1 then begin
      { Default for AllowChange is True. }
      AllowChange := True;
      { Fire the OnFolderChange event. }
      DoFolderChange(Value, AllowChange);
      { If AllowChange is False then bail out. }
      if not AllowChange then
        Exit;
    end;
      {animated scroll}
      if FActiveFolder > -1 then begin
        {play sound}
        if FPlaySounds and (FSoundAlias > '') then begin
          StrPLCopy(Buf, FSoundAlias, Length(Buf)-1);
          FPlaySounds := PlaySound(@Buf, 0, SND_ASYNC);
        end;

        if Parent <> nil then begin
          {scroll selection}
          Canvas.Brush.Color := FBackgroundColor;
          R := lobGetFolderArea(FActiveFolder);
          R2 := R;
          if Value > FActiveFolder then begin
            {up}
            YDelta := -FScrollDelta;
            Inc(R.Bottom, Abs(Value-FActiveFolder)*FButtonHeight);
            R2.Top := R2.Bottom+Abs(Value-FActiveFolder)*FButtonHeight;
            R2.Bottom := R2.Top;
          end else begin
            {down}
            YDelta := +FScrollDelta;
            Dec(R.Top, Abs(Value-FActiveFolder)*FButtonHeight);
            R2.Bottom := R2.Top-Abs(Value-FActiveFolder)*FButtonHeight;
            R2.Top := R2.Bottom;
          end;
          Y := RectHeight(R)-FScrollDelta;
          while Y > 0 do begin
            ScrollWindow(Handle, 0, YDelta, @R, @R);
            Dec(Y, FScrollDelta);
            {fill scrolled area}
            if YDelta > 0 then
              Inc(R2.Bottom, FScrollDelta)
            else
              Dec(R2.Top, FScrollDelta);
            Canvas.FillRect(R2);
          end;
        end;
      end;

      FActiveFolder := Value;
      lobTopItem := 0;
      FActiveItem := -1;
      FSelectedItem := -1;

      Invalidate;

    end;
    { Fire the OnFolderChanged event. }
    DoFolderChanged(FActiveFolder)
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetBackgroundColor(Value : TColor);
begin
  if Value <> FBackgroundColor then begin
    FBackgroundColor := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetBackgroundImage(Value : TBitmap);
begin
  if Assigned(Value) then
    FBackgroundImage.Assign(Value)
  else begin
    FBackgroundImage.Free;
    FBackgroundImage := TBitmap.Create;
  end;
  Invalidate;
end;
{=====}

procedure TO32CustomLookOutBar.SetBackgroundMethod(Value : TO32BackgroundMethod);
begin
  if Value <> FBackgroundMethod then begin
    FBackgroundMethod := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetButtonHeight(Value : Integer);
begin
  if Value <> FButtonHeight then begin
    {Minimum ButtonHeight for CoolTabs is 17}
    if FDrawingStyle = dsCoolTab then begin
      if Value < 17 then FButtonHeight := 17
      else FButtonHeight := Value;
    end else
      FButtonHeight := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetDrawingStyle(Value: TO32FolderDrawingStyle);
begin
  if Value <> FDrawingStyle then begin
    FDrawingStyle := Value;
    if FDrawingStyle = dsEtchedButton  then
      BorderStyle := bsNone
    else
      BorderStyle := bsSingle;

    {Minimum ButtonHeight for CoolTabs is 17}
    if (FDrawingStyle = dsCoolTab) and (FButtonHeight < 17) then
      FButtonHeight := 17;

    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  lobRecalcDisplayNames;
end;
{=====}

procedure TO32CustomLookOutBar.SetImages(Value : TImageList);
begin
  if FImages <> nil then
    FImages.OnChange := nil;
  FImages := Value;
  if FImages <> nil then begin
    Images.OnChange := lobImagesChanged;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetItemFont(Value : TFont);
begin
  if Assigned(Value) then
    FItemFont.Assign(Value);
end;
{=====}

procedure TO32CustomLookOutBar.SetItemSpacing(Value : Word);
begin
  if (Value > 0) then begin
    FItemSpacing := Value;
    Invalidate;
  end;
end;
{=====}

{ - Added}
procedure TO32CustomLookOutBar.SetOrientation(Value: TLobOrientation);
begin
  if Value <> FOrientation then begin
    FOrientation := Value;
    Invalidate;
  end;
end;
{=====}

{ - Added}
procedure TO32CustomLookOutBar.SetSelectedItem(Value: Integer);
begin
  if (Value <> FSelectedItem) and (Value < Folders[FActiveFolder].ItemCount)
  then begin
    FSelectedItem := Value;
    Invalidate;

  end;
end;
{=====}

procedure TO32CustomLookOutBar.SetSelectedItemFont(Value : TFont);
begin
  if Assigned(Value) then
    FSelectedItemFont.Assign(Value);
end;
{=====}

procedure TO32CustomLookOutBar.SetScrollDelta(Value: Integer);
begin
  if Value <= 0 then
    FScrollDelta := 1
  else
    FScrollDelta := Value;
end;
{=====}

procedure TO32CustomLookOutBar.SetStorage(Value : TOvcAbstractStore);
begin
  FStorage := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;
{=====}

procedure TO32CustomLookOutBar.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;  {don't erase background}
end;
{=====}

procedure TO32CustomLookOutBar.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  {tell windows we are a static control to avoid receiving the focus}
  Msg.Result := DLGC_STATIC;
end;
{=====}

procedure TO32CustomLookOutBar.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  inherited;
  lobHitTest.X := Msg.Pos.X;
  lobHitTest.Y := Msg.Pos.Y;
end;
{=====}

procedure TO32CustomLookOutBar.WMSetCursor(var Msg : TWMSetCursor);
var
  I : Integer;
  R : TRect;
begin
  if csDesigning in ComponentState then begin
    if (Msg.HitTest = HTCLIENT) then begin
      lobOverButton := False;
      lobHitTest := ScreenToClient(lobHitTest);
      {check if mouse is over a button}
      for I := 0 to FolderCount-1 do begin
        R := lobButtonRect(I);
        if PtInRect(R, lobHitTest) then begin
          lobOverButton := True;
          Break;
        end;
      end;
    end;
  end;
  inherited;
end;
{=====}

{ Overridden DragOver method. }
procedure TO32CustomLookOutBar.DragOver(Source: TObject;
                                  X, Y: Integer;
                                  State: TDragState;
                              var Accept: Boolean);
var
  ItemIndex    : Integer;
  FolderIndex  : Integer;
begin
  { If State is dsDragLeave then the user has dragged }
  { outside us. Invalidate the component to get rid   }
  { of any left-over drawing and exit. }
  if State = dsDragLeave then begin
    lobExternalDrag := False;
    lobFolderAccept := False;
    lobItemAccept := False;
    lobMouseDown := False;
    lobChanging := False;
    lobTopItem := 0;
    lobDragFromItem := -1;
    lobDragFromFolder := -1;
    Invalidate;
    lobAcceptAny := False;
    inherited DragOver(Source, X, Y, State, lobAcceptAny);
    Exit;
  end;

  lobFolderAccept := True;
  lobItemAccept   := True;
  { Call the user's OnDragOver. }
  if Assigned(FOnDragOver) then
    FOnDragOver(Self, Source,
      X, Y, State, lobFolderAccept, lobItemAccept);

  { Might have to scroll the items in the folder. }
  if lobScrollDownBtn.Visible then begin
    if Y > lobScrollDownBtn.Top then begin
      Inc(lobTopItem);
      InvalidateRect(Handle, @lobItemsRect, False);
    end;
  end;
  if lobScrollUpBtn.Visible then begin
    if Y < (lobScrollUpBtn.Top + lobScrollUpBtn.Height)then begin
      Dec(lobTopItem);
      InvalidateRect(Handle, @lobItemsRect, False);
    end;
  end;

  Accept := lobFolderAccept or lobItemAccept;
  if lobFolderAccept or lobItemAccept then begin
    lobGetHitTest(X, Y, FolderIndex, ItemIndex);
    lobDropHitTest(X, Y);
    lobExternalDrag := True;
    { Change folder if necessary. }
    if (FolderIndex <> -1) and (FolderIndex <> FActiveFolder) then
      ActiveFolder := FolderIndex;
    if lobItemAccept then
      FActiveItem := ItemIndex;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLookOutBar.DragDrop(Source: TObject; X, Y : Integer);
begin
  if Assigned(FOnDragDrop) then
    FOnDragDrop(Self, Source, X, Y, FActiveFolder, lobExternalDragItem);
  lobExternalDrag := False;
  lobFolderAccept := False;
  lobItemAccept := False;
  lobMouseDown := False;
  lobChanging := False;
  lobTopItem := 0;
  lobDragFromFolder := -1;
  Invalidate;
  inherited DragDrop(Source, X, Y);
end;
{=====}

function TO32CustomLookOutBar.GetChildOwner: TComponent;
begin
  Result := Self;
end;

end.
