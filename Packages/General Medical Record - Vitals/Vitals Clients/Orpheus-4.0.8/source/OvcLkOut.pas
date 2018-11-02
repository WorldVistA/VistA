{*********************************************************}
{*                  OVCLKOUT.PAS 4.06                    *}
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

unit ovclkout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Menus, ExtCtrls, MMSystem, StdCtrls, OvcBase, OvcData, OvcConst,
  OvcMisc, OvcSpeed, OvcFiler, OvcState;

type
  TOvcIconSize = (isLarge, isSmall);
  TOvcBackgroundMethod = (bmNone, bmNormal, bmStretch, bmTile);
  TOvcFolderDrawingStyle = (dsDefault, dsEtched);

type
  TOvcLookOutItem = class(TOvcCollectible)
  protected {private}
    {property variables}
    FCaption     : string;
    FDescription : string;
    FIconIndex   : Integer;
    FIconRect    : TRect;
    FLabelRect   : TRect;

    {internal variables}
    liDisplayName : string;

    {property methods}
    procedure SetCaption(const Value : string);
    procedure SetIconIndex(Value : Integer);

  protected
    function GetBaseName : string;
      override;
    function GetDisplayText : string;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    procedure Assign(Source: TPersistent); override;

    property IconRect : TRect
      read FIconRect;

    property LabelRect : TRect
      read FLabelRect;

  published
    property Caption : string
      read FCaption
      write SetCaption;

    property Description : string
      read FDescription
      write FDescription;

    property IconIndex : Integer
      read FIconIndex
      write SetIconIndex;
  end;

  TOvcLookOutFolder = class(TOvcCollectible)
  protected {private}
    {property variables}
    FCaption      : string;
    FEnabled      : Boolean;
    FIconSize     : TOvcIconSize;
    FItems        : TOvcCollection;

    {internal variables}
    lfDisplayName : string;
    lfRect        : TRect;

    {property methods}
    function GetItem(Index : Integer) : TOvcLookOutItem;
    function GetItemCount : Integer;
    procedure SetCaption(const Value : string);
    procedure SetEnabled(Value : Boolean);
    procedure SetIconSize(Value : TOvcIconSize);
    procedure SetItem(Index : Integer; Value : TOvcLookOutItem);

    procedure lfGetEditorCaption(var Caption : string);
    procedure lfItemChange(Sender : TObject);

  protected
    function GetBaseName : string;
      override;
    function GetDisplayText : string;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    property Items[Index : Integer] : TOvcLookOutItem
      read GetItem;

    property ItemCount : Integer
      read GetItemCount;

  published
    property Caption : string
      read FCaption
      write SetCaption;

    property Enabled : Boolean
      read FEnabled
      write SetEnabled;

    property ItemCollection : TOvcCollection
      read FItems
      write FItems;

    property IconSize : TOvcIconSize
      read FIconSize
      write SetIconSize;
  end;

  TOvcRenameEdit = class(TCustomMemo)
  private

  protected
    procedure KeyPress(var Key: Char);
      override;

  public
    FolderIndex : Integer;
    ItemIndex   : Integer;

    constructor Create(AOwner : TComponent);
      override;
  end;

  TOvcFolderClickEvent = procedure(Sender : TObject;
                                Button : TMouseButton;
                                Shift : TShiftState;
                                Index : Integer) of object;
  TOvcItemClickEvent = procedure(Sender : TObject;
                              Button : TMouseButton;
                              Shift : TShiftState;
                              Index : Integer) of object;

  TOvcFolderChangeEvent = procedure(Sender : TObject;
                                 Index : Integer;
                                 var AllowChange : Boolean;
                                 Dragging : Boolean) of object;

  TOvcFolderChangedEvent = procedure(Sender : TObject;
                                  Index : Integer) of object;

  TOvcLOBDragOverEvent = procedure(Sender, Source: TObject;
                                   X, Y: Integer; State: TDragState;
                                   var AcceptFolder, AcceptItem: Boolean)
                                   of object;
  TOvcLOBDragDropEvent = procedure(Sender, Source: TObject;
                                   X, Y: Integer;
                                   FolderIndex, ItemIndex : Integer)
                                   of object;
  TOvcMouseOverItemEvent = procedure(Sender : TObject;
                                     Item : TOvcLookOutItem) of object;

  TOvcLookOutBar = class(TOvcCustomControlEx)
  protected {private}
    {property variables}
    FActiveFolder     : Integer;
    FActiveItem       : Integer;
    FAllowRearrange   : Boolean;
    FBackgroundColor  : TColor;
    FBackgroundImage  : TBitmap;
    FBackgroundMethod : TOvcBackgroundMethod;
    FBorderStyle      : TBorderStyle;
    FButtonHeight     : Integer;
    FDrawingStyle     : TOvcFolderDrawingStyle;
    FFolders          : TOvcCollection;
    FHotFolder        : Integer;
    FImages           : TImageList;
    FItemFont         : TFont;
    FItemSpacing      : Word;
    FPreviousFolder   : Integer;
    FPreviousItem     : Integer;
    FPlaySounds       : Boolean;
    FSelectedItem     : Integer;
    FSelectedItemFont : TFont;
    FScrollDelta      : Integer;
    FShowButtons      : Boolean;
    FSoundAlias       : string;
    FStorage          : TOvcAbstractStore;

    {event variables}
    FOnArrange       : TNotifyEvent;
    FOnDragDrop      : TOvcLOBDragDropEvent;
    FOnDragOver      : TOvcLOBDragOverEvent;
    FOnFolderChange  : TOvcFolderChangeEvent;
    FOnFolderChanged : TOvcFolderChangedEvent;
    FOnFolderClick   : TOvcFolderClickEvent;
    FOnItemClick     : TOvcItemClickEvent;
    FOnMouseOverItem : TOvcMouseOverItemEvent;

    {internal variables}
    lobChanging         : Boolean;
    lobEdit             : TOvcRenameEdit;
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
    lobTimer            : Integer;         {timer-pool handle}
    lobExternalDragItem : Integer;
    lobFolderAccept     : Boolean;
    lobItemAccept       : Boolean;
    lobCursorOverItem   : Boolean;
    lobAcceptAny        : Boolean;
    lobLastMouseOverItem: Integer;

    {property methods}
    function GetFolder(Index : Integer) : TOvcLookOutFolder;
    function GetFolderCount : Integer;
    procedure SetActiveFolder(Value : Integer);
    procedure SetBackgroundColor(Value : TColor);
    procedure SetBackgroundImage(Value : TBitmap);
    procedure SetBackgroundMethod(Value : TOvcBackgroundMethod);
    procedure SetDrawingStyle(Value : TOvcFolderDrawingStyle);
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetButtonHeight(Value : Integer);
    procedure SetImages(Value : TImageList);
    procedure SetItemFont(Value : TFont);
    procedure SetItemSpacing(Value : Word);
    procedure SetSelectedItemFont(Value : TFont);
    procedure SetScrollDelta(Value : Integer);
    procedure SetStorage(Value : TOvcAbstractStore);

    {internal methods}
    function lobButtonRect(Index : Integer) : TRect;
    procedure lobCommitEdit(Sender : TObject);
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    function lobDropHitTest(X, Y : Integer) : Boolean;
    procedure lobFolderChange(Sender : TObject);
    procedure lobFolderSelected(Sender : TObject; Index : Integer);
    procedure lobFontChanged(Sender : TObject);
    procedure lobGetEditorCaption(var Caption : string);
    function lobGetFolderArea(Index : Integer) : TRect;
    procedure lobGetHitTest(X, Y : Integer; var FolderIndex : Integer; var ItemIndex : Integer);
    procedure lobImagesChanged(Sender : TObject);
    procedure lobRecalcDisplayNames;
    procedure lobScrollDownBtnClick(Sender : TObject);
    procedure lobScrollUpBtnClick(Sender : TObject);
    function lobShowScrollUp : Boolean;
    function lobShowScrollDown : Boolean;
    procedure lobTimerEvent(Sender : TObject; Handle : Integer;
                            Interval : Cardinal; ElapsedTime : Integer);

    {VCL message methods}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Message: TMessage);
      message CM_FONTCHANGED;
    procedure CMParentColorChanged(var Message: TMessage);
      message CM_PARENTCOLORCHANGED;

    {windows message response methods}
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd);
      message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;
    procedure WMSetCursor(var Msg : TWMSetCursor);
      message WM_SETCURSOR;

  protected
    procedure CreateParams(var Params: TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure Loaded;
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;
    procedure Paint;
      override;

    procedure DoArrange;
    procedure DoFolderChange(Index : Integer; var AllowChange : Boolean);
    procedure DoFolderChanged(Index : Integer);
    procedure DoFolderClick(Button : TMouseButton; Shift : TShiftState; Index : Integer);
    procedure DoItemClick(Button : TMouseButton; Shift : TShiftState; Index : Integer);
    procedure DoMouseOverItem(X, Y, ItemIndex : Integer);

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;
    { Declared public because TControl's DragDrop is public. }
    procedure DragDrop(Source: TObject; X, Y: Integer);
      override;

    procedure BeginUpdate;
    procedure EndUpdate;
    function GetFolderAt(X, Y : Integer) : Integer;
    function GetItemAt(X, Y : Integer) : Integer;
    procedure InsertFolder(const ACaption : string; AFolderIndex : Integer);
    procedure InsertItem(const ACaption : string; AFolderIndex, AItemIndex, AIconIndex : Integer);
    procedure InvalidateItem(FolderIndex, ItemIndex : Integer);
    procedure RemoveFolder(AFolderIndex : Integer);
    procedure RemoveItem(AFolderIndex, AItemIndex : Integer);
    procedure RenameFolder(AFolderIndex : Integer);
    procedure RenameItem(AFolderIndex, AItemIndex : Integer);
    procedure RestoreState(const Section : string = '');
    procedure SaveState(const Section : string = '');

    property ActiveItem : Integer
      read FActiveItem;

    property Folders[Index : Integer] : TOvcLookOutFolder
      read GetFolder;

    property FolderCount : Integer
      read GetFolderCount;

    property PreviousFolder  : Integer
      read FPreviousFolder;

    property PreviousItem  : Integer
      read FPreviousItem;

  published
    {properties}
    property ActiveFolder : Integer
      read FActiveFolder
      write SetActiveFolder
      default -1;

    property AllowRearrange : Boolean
      read FAllowRearrange
      write FAllowRearrange
      default True;

    property BackgroundColor : TColor
      read FBackgroundColor
      write SetBackgroundColor
      default clInactiveCaption;

    property BackgroundImage : TBitmap
      read FBackgroundImage
      write SetBackgroundImage;

    property BackgroundMethod : TOvcBackgroundMethod
      read FBackgroundMethod
      write SetBackgroundMethod
      default bmNormal;

    property BorderStyle : TBorderStyle
      read FBorderStyle
      write SetBorderStyle
      default bsSingle;

    property ButtonHeight : Integer
      read FButtonHeight
      write SetButtonHeight
      default 20;

    property DrawingStyle : TOvcFolderDrawingStyle
      read FDrawingStyle
      write SetDrawingStyle
      default dsDefault;

    property FolderCollection : TOvcCollection
      read FFolders
      write FFolders;

    property Images : TImageList
      read FImages
      write SetImages;

    property ItemFont : TFont
      read FItemFont
      write SetItemFont;

    property ItemSpacing : Word
      read FItemSpacing
      write SetItemSpacing;

    property PlaySounds : Boolean
      read FPlaySounds
      write FPlaySounds
      default False;

    property ScrollDelta : Integer
      read FScrollDelta write SetScrollDelta default 2;

    property SelectedItem : Integer
      read FSelectedItem
      write FSelectedItem
      default -1;

    property SelectedItemFont : TFont
      read FSelectedItemFont
      write SetSelectedItemFont;

    property ShowButtons : Boolean
      read FShowButtons
      write FShowButtons
      default True;

    property SoundAlias : string
      read FSoundAlias
      write FSoundAlias
      stored FPlaySounds;

    property Storage : TOvcAbstractStore
      read FStorage write SetStorage;

    {inherited Events}
    property AfterEnter;
    property AfterExit;
    property OnMouseWheel;

    {events}
    property OnArrange : TNotifyEvent
      read FOnArrange
      write FOnArrange;
    property OnDragDrop : TOvcLOBDragDropEvent
      read FOnDragDrop
      write FOnDragDrop;

    property OnDragOver : TOvcLOBDragOverEvent
      read FOnDragOver
      write FOnDragOver;

    property OnFolderClick : TOvcFolderClickEvent
      read FOnFolderClick
      write FOnFolderClick;

    property OnItemClick : TOvcItemClickEvent
      read FOnItemClick
      write FOnItemClick;

    property OnFolderChange : TOvcFolderChangeEvent
      read FOnFolderChange
      write FOnFolderChange;

    property OnFolderChanged : TOvcFolderChangedEvent
      read FOnFolderChanged
      write FOnFolderChanged;

    property OnMouseOverItem : TOvcMouseOverItemEvent
      read FOnMouseOverItem
      write FOnMouseOverItem;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property Controller;
    property Ctl3D;
    property DragCursor;
    property Enabled;
    property Font;
    { The following properties are not published to avoid  }
    { conflicts with OnFolderClick and OnItemClick.        }
    {
    property OnClick;
    property OnDblClick;
    }
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

uses
  Types, UITypes;

const
  lobTimerInterval = 200;


{*** TRenameEdit ***}

constructor TOvcRenameEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Ctl3D := False;
  Visible := False;
  WantReturns := False;
  FolderIndex := -1;
  ItemIndex   := -1;
end;

procedure TOvcRenameEdit.KeyPress(var Key: Char);
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


{*** TOvcLookOutItem ***}

constructor TOvcLookOutItem.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FIconIndex := -1;
end;

procedure TOvcLookOutItem.Assign(Source: TPersistent);
begin
  if Source is TOvcLookOutItem then begin
    Caption := TOvcLookOutItem(Source).Caption;
    Description := TOvcLookOutItem(Source).Description;
    IconIndex := TOvcLookOutItem(Source).IconIndex;
    Tag := TOvcLookOutItem(Source).Tag;
  end else
    inherited Assign(Source);
end;

function TOvcLookOutItem.GetBaseName : string;
begin
  Result := GetOrphStr(SCItemBaseName);
end;

function TOvcLookOutItem.GetDisplayText : string;
begin
  if Caption > '' then
    Result := Caption + ': ' + ClassName
  else
    Result := Name + ': ' + ClassName;
end;

procedure TOvcLookOutItem.SetCaption(const Value : string);
begin
  if Value <> FCaption then begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TOvcLookOutItem.SetIconIndex(Value : Integer);
begin
  if Value <> FIconIndex then begin
    FIconIndex := Value;
    Changed;
  end;
end;


{*** TOvcLookOutFolder ***}

constructor TOvcLookOutFolder.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FItems := TOvcCollection.Create(Self, TOvcLookOutItem);
  FItems.OnChanged := lfItemChange;
  FItems.OnGetEditorCaption := lfGetEditorCaption;

  FEnabled := True;
  FIconSize := isLarge;
end;

destructor TOvcLookOutFolder.Destroy;
begin
  FItems.Free;
  FItems := nil;

  inherited Destroy;
end;

function TOvcLookOutFolder.GetBaseName : string;
begin
  Result := GetOrphStr(SCFolderBaseName);
end;

function TOvcLookOutFolder.GetDisplayText : string;
begin
  if Caption > '' then
    Result := Caption + ': ' + ClassName
  else
    Result := Name + ': ' + ClassName;
end;

function TOvcLookOutFolder.GetItem(Index : Integer) : TOvcLookOutItem;
begin
  Result := TOvcLookOutItem(FItems[Index]);
end;

function TOvcLookOutFolder.GetItemCount : Integer;
begin
  Result := FItems.Count;
end;

procedure TOvcLookOutFolder.lfGetEditorCaption(var Caption : string);
begin
  Caption := GetOrphStr(SCEditingItems);
end;

procedure TOvcLookOutFolder.lfItemChange(Sender : TObject);
begin
  if not (csDestroying in Owner.ComponentState) then begin
    TOvcLookOutBar(Owner).lobRecalcDisplayNames;
    TOvcLookOutBar(Owner).Invalidate;
  end;
end;

procedure TOvcLookOutFolder.SetCaption(const Value : string);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TOvcLookOutFolder.SetEnabled(Value : Boolean);
begin
  if Value <> FEnabled then begin
    FEnabled := Value;
    Changed;
  end;
end;

procedure TOvcLookOutFolder.SetIconSize(Value : TOvcIconSize);
begin
  if FIconSize <> Value then begin
    FIconSize := Value;
    Changed;
  end;
end;

procedure TOvcLookOutFolder.SetItem(Index : Integer; Value : TOvcLookOutItem);
begin
  FItems[Index] := Value;
end;


{*** TOvcLookOutBar ***}

procedure TOvcLookOutBar.BeginUpdate;
begin
  lobChanging := True;
end;

procedure TOvcLookOutBar.CMCtl3DChanged(var Msg : TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;

procedure TOvcLookOutBar.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  Msg.Result := Integer(lobOverButton);
end;

procedure TOvcLookOutBar.CMFontChanged(var Message: TMessage);
begin
  lobRecalcDisplayNames;
end;

procedure TOvcLookOutBar.CMParentColorChanged(var Message: TMessage);
begin
  inherited;

  if ParentColor then
    SetBackgroundColor(Color);
end;

constructor TOvcLookOutBar.Create(AOwner : TComponent);
var
  HSnd : THandle;
begin
  inherited Create(AOwner);

  FShowButtons := True;

  if Classes.GetClass(TOvcLookOutFolder.ClassName) = nil then
    Classes.RegisterClass(TOvcLookOutFolder);
  if Classes.GetClass(TOvcLookOutItem.ClassName) = nil then
    Classes.RegisterClass(TOvcLookOutItem);

  FFolders := TOvcCollection.Create(Self, TOvcLookOutFolder);
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
      // FreeResource(HSnd);  //SZ FreeResource is a compatibility function for 16 bit Windows. It is not needed anymore.
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
    lobEdit := TOvcRenameEdit.Create(Self);
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

procedure TOvcLookOutBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
    Style := Integer(Style) or BorderStyles[FBorderStyle];

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcLookOutBar.CreateWnd;
begin
  inherited CreateWnd;

  lobRecalcDisplayNames;
end;

destructor TOvcLookOutBar.Destroy;
begin
  Images := nil; {unregister any image list notification}
  lobChanging := True;

  FFolders.Free;
  FFolders := nil;

  FItemFont.Free;
  FItemFont := nil;

  FSelectedItemFont.Free;
  FSelectedItemFont := nil;

  FBackgroundImage.Free;
  FBackgroundImage := nil;

  if ControllerAssigned and (lobTimer > -1) then begin
    Controller.TimerPool.Remove(lobTimer);
    lobTimer := -1;
  end;

  inherited Destroy;
end;

procedure TOvcLookOutBar.DoArrange;
begin
  if Assigned(FOnArrange) then
    FOnArrange(Self);
end;

procedure TOvcLookOutBar.DoFolderChange(Index : Integer;
  var AllowChange: Boolean);
begin
  if Assigned(FOnFolderChange) then
    FOnFolderChange(Self, Index, AllowChange, lobDragFromItem <> -1);
end;

procedure TOvcLookOutBar.DoFolderChanged(Index : Integer);
begin
  if Assigned(FOnFolderChanged) then
    FOnFolderChanged(Self, Index);
end;

procedure TOvcLookOutBar.DoFolderClick(Button : TMouseButton; Shift : TShiftState; Index : Integer);
begin
  if Assigned(FOnFolderClick) then
    FOnFolderClick(Self, Button, Shift, Index);
end;

procedure TOvcLookOutBar.DoItemClick(Button : TMouseButton; Shift : TShiftState; Index : Integer);
begin
  if Assigned(FOnItemClick) then
    FOnItemClick(Self, Button, Shift, Index);
end;

procedure TOvcLookOutBar.DoMouseOverItem(X, Y, ItemIndex : Integer);
begin
  if Assigned(FOnMouseOverItem) then
    FOnMouseOverItem(Self,
      Folders[ActiveFolder].Items[GetItemAt(X, Y)]);
end;

procedure TOvcLookOutBar.EndUpdate;
begin
  lobChanging := False;
  lobRecalcDisplayNames;
end;

function TOvcLookOutBar.GetFolderCount : Integer;
begin
  Result := FFolders.Count;
end;

function TOvcLookOutBar.GetFolder(Index : Integer)  : TOvcLookOutFolder;
begin
  Result := TOvcLookOutFolder(FFolders.Item[Index]);
end;

function TOvcLookOutBar.GetFolderAt(X, Y : Integer) : Integer;
var
  Dummy : Integer;
begin
  lobGetHitTest(X, Y, Result, Dummy);
end;

function TOvcLookOutBar.GetItemAt(X, Y : Integer) : Integer;
var
  Dummy : Integer;
begin
  lobGetHitTest(X, Y, Dummy, Result);
end;

procedure TOvcLookOutBar.InsertFolder(const ACaption : string; AFolderIndex : Integer);
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

procedure TOvcLookOutBar.InsertItem(const ACaption : string; AFolderIndex, AItemIndex,
          AIconIndex : Integer);
var
  AFolder : TOvcLookOutFolder;
begin
  AFolder := Folders[AFolderIndex];
  AFolder.FItems.Insert(AItemIndex);
  AFolder.Items[AItemIndex].Caption := ACaption;
  AFolder.Items[AItemIndex].IconIndex := AIconIndex;
  Invalidate;
end;

procedure TOvcLookOutBar.InvalidateItem(FolderIndex, ItemIndex : Integer);
var
  F : TRect;
  R : TRect;
begin
  R := TOvcLookOutItem(Folders[FolderIndex].Items[ItemIndex]).FIconRect;
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
  if HeightOf(R) > 0 then
    InvalidateRect(Handle, @R, False);
end;

function GetLargeIconDisplayName(Canvas : TCanvas;
                                  Rect : TRect;
                                  const Name : string) : string;
  {-given a string, and a rectangle, find the string that can be displayed
    using two lines. Add ellipsis to the end of each line if necessary and
    possible}
var
  TestRect : TRect;
  SH, DH : Integer;
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
  SH := DrawText(Canvas.Handle, 'W W', 3, TestRect, DT_SINGLELINE or DT_CALCRECT);

  {get double line height}
  with TestRect do begin
    Left := 0;
    Top := 0;
    Right := 1;
    Bottom := 1;
  end;
  DH := DrawText(Canvas.Handle, 'W W', 3, TestRect, DT_WORDBREAK or DT_CALCRECT);

  {see if the text can fit within the existing rect without growing}
  TestRect := Rect;
  DrawText(Canvas.Handle, PChar(TempName), Length(TempName), TestRect,
            DT_WORDBREAK or DT_CALCRECT);
  I := Pos(' ', TempName);
  if (HeightOf(TestRect) = SH) or (I < 2) then
    Result := GetDisplayString(Canvas, TempName, 1, WidthOf(Rect))
  else begin
    {the first line only has ellipsis if there's only one word on it and
    that word won't fit}
    Temp2 := GetDisplayString(Canvas, Copy(TempName, 1, I-1), 1,
                              WidthOf(Rect));
    if CompareStr(Temp2, Copy(TempName, 1, I-1)) <> 0 then begin
      Result := GetDisplayString(Canvas, Copy(TempName, 1, I-1), 1,
                                 WidthOf(Rect)) +
                ' ' +
                GetDisplayString(Canvas, Copy(TempName, I+1,
                                 Length(TempName) - I), 1, WidthOf(Rect));
    end else begin
      {2 or more lines, and the first line isn't getting an ellipsis}
      if (HeightOf(TestRect) = DH) and
         (WidthOf(TestRect) <= WidthOf(Rect)) then
        {it will fit}
        Result := TempName
      else begin
        {it won't fit, but the first line wraps OK - 2nd line needs an ellipsis}
        TestRect.Right := Rect.Right + 1;
        while (WidthOf(TestRect) > WidthOf(Rect)) or
              (HeightOf(TestRect) > DH) do begin
          if Length(TempName) > 1 then begin
            TestRect := Rect;
            Delete(TempName, Length(TempName), 1);
            TempName := Trim(TempName);
            DrawText(Canvas.Handle, PChar(TempName + '...'), Length(TempName) + 3, TestRect, DT_WORDBREAK or DT_CALCRECT);
            Result := TempName + '...';
          end else begin
            Result := TempName + '..';
            TestRect := Rect;
            DrawText(Canvas.Handle, PChar(Result){Buf}, Length(Result), TestRect,
                      DT_WORDBREAK or DT_CALCRECT);
            if (WidthOf(TestRect) <= WidthOf(Rect)) and
              (HeightOf(TestRect) > DH) then
                Break;
            Result := TempName + '.';
            TestRect := Rect;
            DrawText(Canvas.Handle, PChar(Result){Buf}, Length(Result), TestRect,
                      DT_WORDBREAK or DT_CALCRECT);
            if (WidthOf(TestRect) <= WidthOf(Rect)) and
              (HeightOf(TestRect) > DH) then
                Break;
            Result := TempName;
          end;
        end;
      end;
    end;
  end;
end;

function TOvcLookOutBar.lobButtonRect(Index : Integer) : TRect;
begin
  Result := Folders[Index].lfRect;
end;

procedure TOvcLookOutBar.lobCommitEdit(Sender : TObject);
var
  Folder : TOvcLookOutFolder;
  Item   : TOvcLookOutItem;
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

function TOvcLookOutBar.lobDropHitTest(X, Y : Integer) : Boolean;
  {given an X, Y, is this a legal spot to drop a folder?}
var
  I           : Integer;
  SpaceTop    : Integer;
  SpaceBottom : Integer;
  OldDrop     : Integer;
  Folder      : TOvcLookOutFolder;
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
        SpaceTop := TOvcLookOutItem(Folder.Items[I-1]).FLabelRect.Bottom+1;
      SpaceBottom := TOvcLookOutItem(Folder.Items[I]).FIconRect.Top-1;
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
    SpaceTop := TOvcLookOutItem(Folder.Items[Folder.ItemCount-1]).FLabelRect.Bottom+1;
    SpaceBottom := lobItemsRect.Bottom-1;
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

procedure TOvcLookOutBar.lobFolderChange(Sender : TObject);
begin
  if not (csDestroying in ComponentState) then begin
    if FolderCount = 0 then
      FActiveFolder := -1
    else begin
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

procedure TOvcLookOutBar.lobFolderSelected(Sender : TObject; Index : Integer);
begin
  if not (csDestroying in ComponentState) then
    ActiveFolder := Index;
end;

procedure TOvcLookOutBar.lobFontChanged(Sender : TObject);
begin
  Perform(CM_FONTCHANGED, 0, 0);
end;

procedure TOvcLookOutBar.lobGetEditorCaption(var Caption : string);
begin
  Caption := GetOrphStr(SCEditingFolders);
end;

procedure TOvcLookOutBar.lobGetHitTest(X, Y : Integer; var FolderIndex : Integer; var ItemIndex : Integer);
var
  I      : Integer;
  Item   : TOvcLookOutItem;
  Folder : TOvcLookOutFolder;
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

function TOvcLookOutBar.lobGetFolderArea(Index : Integer) : TRect;
var
  I : Integer;
begin
  Result := ClientRect;
  for I := 0 to ActiveFolder do
    Inc(Result.Top, FButtonHeight);
  for I := FolderCount-1 downto ActiveFolder+1 do
    Dec(Result.Bottom, FButtonHeight);
end;

procedure TOvcLookOutBar.lobImagesChanged(Sender : TObject);
begin
  Invalidate;
end;

procedure TOvcLookOutBar.lobRecalcDisplayNames;
var
  I : Integer;
begin
  if not HandleAllocated then
    exit;
  Canvas.Font := Self.Font;
  {figure out display names for each folder...}
  for I := 0 to FolderCount-1 do
    Folders[I].lfDisplayName := GetDisplayString(Canvas, Folders[I].Caption, 1, ClientWidth);
  Invalidate;
end;

function TOvcLookOutBar.lobShowScrollDown : Boolean;
var
  Folder : TOvcLookOutFolder;
  Item   : TOvcLookOutItem;
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

procedure TOvcLookOutBar.lobScrollDownBtnClick(Sender : TObject);
begin
  if lobShowScrollDown then begin
    Inc(lobTopItem);
    InvalidateRect(Handle, @lobItemsRect, False);
  end;
end;

function TOvcLookOutBar.lobShowScrollUp : Boolean;
begin
  Result := lobTopItem > 0;
end;

procedure TOvcLookOutBar.lobScrollUpBtnClick(Sender : TObject);
begin
  if lobTopItem > 0 then begin
    Dec(lobTopItem);
    InvalidateRect(Handle, @lobItemsRect, False);
  end;
end;

procedure TOvcLookOutBar.lobTimerEvent(Sender : TObject; Handle : Integer;
          Interval : Cardinal; ElapsedTime : Integer);
var
  Pt : TPoint;
  Form : TCustomForm;
begin
  GetCursorPos(Pt);
  Pt := ScreenToClient(Pt);
  if not PtInRect(ClientRect, Pt) then begin
    if not lobMouseDown then begin
      Controller.TimerPool.Enabled[lobTimer] := False;
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

procedure TOvcLookOutBar.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
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

procedure TOvcLookOutBar.MouseMove(Shift : TShiftState; X, Y : Integer);
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
          if lobTimer < 0 then begin
            lobTimer := Controller.TimerPool.Add(lobTimerEvent, lobTimerInterval);
            Controller.TimerPool.Enabled[lobTimer] := True;
          end;
        end;
      end;
    end else if FActiveItem <> -1 then begin
      InvalidateItem(FActiveFolder, FActiveItem);
      FActiveItem := -1;
    end;
    if FolderIndex <> -1 then begin
      if (FolderIndex <> FHotFolder) then begin
        if FHotFolder <> -1 then
          {invalidate the old activeItem}
          Invalidate;
        FHotFolder := FolderIndex;
        if FHotFolder <> -1 then begin
          {invalidate the new active item}
          Invalidate;
          if lobTimer < 0 then begin
            lobTimer := Controller.TimerPool.Add(lobTimerEvent, lobTimerInterval);
            Controller.TimerPool.Enabled[lobTimer] := True;
          end;
        end;
      end;
    end else if FHotFolder <> -1 then begin
      Invalidate;
      FHotFolder := -1;
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

procedure TOvcLookOutBar.MouseUp(Button : TMouseButton; Shift : TShiftState;
          X, Y : Integer);
var
  FolderIndex : Integer;
  ItemIndex   : Integer;
  Folder      : TOvcLookOutFolder;
  Item        : TOvcLookOutItem;
  FromItem    : TOvcLookOutItem;
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
          FromItem := TOvcLookOutItem(Folder.Items[lobDragFromItem]);
          {create the new item}
          Folder := Folders[lobDragToFolder];
          Item := TOvcLookOutItem(Folder.FItems.Insert(lobDragToItem));
          Item.Assign(FromItem);
          SourceName := FromItem.Name;
          {Item.Caption := FromItem.Caption;}
          {Item.IconIndex := FromItem.IconIndex;}
          {free the old item}
          FromItem.Free;
          Item.Name := SourceName;
          lobRecalcDisplayNames;
          DoArrange;
        end;
        lobDragFromFolder := -1;
        lobDragFromItem := -1;
      end;

      if (ItemIndex = -1) and (FolderIndex <> -1) then begin
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

procedure TOvcLookOutBar.Notification(AComponent : TComponent;
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

procedure TOvcLookOutBar.Paint;
var
  I          : Integer;
  J          : Integer;
  X          : Integer;
  W          : Integer;
  H          : Integer;
  CurPos     : Integer;
  yOffset    : Integer;
  BkMode     : Integer;
  LabelWidth : Integer;
  Flags      : Integer;
  MyRect     : TRect;
  TR         : TRect;
  BkColor    : TColor;
  Folder     : TOvcLookOutFolder;
  Item       : TOvcLookOutItem;
  DrawBmp    : TBitmap;
  Text       : string;
  DrawFolder : Boolean;
  BM         : TBitmap;
  RowStart   : Integer;
  ILeft      : Integer;
  IHeight    : Integer;
  IWidth     : integer;
begin
  if lobChanging then
    Exit;

  DrawBmp := TBitMap.Create;
  try
    DrawBmp.Width  := ClientWidth;
    DrawBmp.Height := ClientHeight;

    DrawBmp.Canvas.Font := Self.Font;
    with DrawBmp.Canvas do begin
      Pen.Color := FBackgroundColor;
      Brush.Color := FBackgroundColor;

      MyRect := ClientRect;

      DrawFolder :=
        not ((FolderCount = 1) and (Folders[0].Caption = ''))
          or (csDesigning in ComponentState);

      if DrawFolder then
        TR := lobGetFolderArea(FActiveFolder)
      else
        TR := ClientRect;

      if FBackgroundImage.Empty or (FBackgroundMethod = bmNone) then begin
        Rectangle(TR.Left, TR.Top, TR.Right, TR.Bottom);
      end else begin
        case FBackgroundMethod of
          bmNormal  : Draw(TR.Left, TR.Top, FBackgroundImage);
          bmStretch : StretchDraw(TR, FBackgroundImage);
          bmTile    :
            begin
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
        end
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

          { Switch statement so we can add more styles later. }
          case FDrawingStyle of
            { Regular button style. }
            dsDefault :
              TR := DrawButtonFace(DrawBmp.Canvas, MyRect, 1, bsNew, False, (I = FHotFolder) and lobMouseDown, False);
            { Etched style (Outlook98). }
            dsEtched :
              begin
                Brush.Color := clBtnFace;
                FillRect(MyRect);
                Pen.Color := clBtnShadow;
                Brush.Style := bsClear;
                Rectangle(MyRect.Left, MyRect.Top, MyRect.Right - 1, MyRect.Bottom);
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
          end;
          Inc(TR.Top);
          Flags := DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
          if Folders[I].Enabled then begin
            DrawText(DrawBmp.Canvas.Handle, PChar(Folders[I].lfDisplayName){Buf},
              length(Folders[I].lfDisplayName){StrLen(Buf)}, TR, Flags);
            if (I = FHotFolder) and not lobMouseDown then begin
              case FDrawingStyle of
                { Regular button style. }
                dsDefault :
                  begin
                    InflateRect(TR,1,1);
                    inc(TR.Left);
                    Frame3D(DrawBmp.Canvas, TR, clBtnHighlight, clWindowFrame, 1);
                  end;
                { Etched style (Outlook98). }
                dsEtched :
                  begin
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
            DrawBmp.Canvas.Font.Color := clHighlightText;
            SetBkMode(Canvas.Handle, OPAQUE);
            DrawText(DrawBmp.Canvas.Handle, PChar(Folders[I].lfDisplayName){Buf}, -1, TR, Flags);
            SetBkMode(DrawBmp.Canvas.Handle, TRANSPARENT);
            DrawBmp.Canvas.Font.Color := clBtnShadow;
            OffsetRect(TR, -2, -1);
            DrawText(DrawBmp.Canvas.Handle, PChar(Folders[I].lfDisplayName){Buf}, -1, TR, Flags);
            DrawBmp.Canvas.Font.Color := Self.Font.Color;
          end;
          Inc(CurPos, FButtonHeight);
        end;
      end else begin
        if FDrawingStyle = dsEtched then begin
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
          TOvcLookOutItem(Folder.Items[J]).FLabelRect.Bottom :=
             lobItemsRect.Bottom + 1;

        for J := lobTopItem to Folder.ItemCount-1 do begin
          if (FSelectedItem = J) then
            DrawBmp.Canvas.Font := FSelectedItemFont
          else
            DrawBmp.Canvas.Font := FItemFont;

          Item := Folder.Items[J];
          if (csDesigning in ComponentState) and (Item.Caption = '') then
            Text := Item.Name
          else
            Text := Item.Caption;

          if Folder.IconSize = isLarge then begin {large icons}
            {glyph is at the top}
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
                  FImages.Draw(DrawBmp.Canvas, Item.FIconRect.Left + 2,
                    Item.FIconRect.Top + 2, Item.IconIndex);
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
              Item.liDisplayName := GetLargeIconDisplayName(DrawBmp.Canvas, Item.FLabelRect, Text);
              X := DrawBmp.Canvas.TextWidth(Item.liDisplayName);
              Left := (ClientWidth - X) div 2;
              if Left < 5 then
                Left := 5;
              Right := Left + X;
              if Right > ClientWidth-5 then
                Right := ClientWidth-5;
              if Top > lobItemsRect.Bottom then
                Break;
            end;

            DrawText(DrawBmp.Canvas.Handle, PChar(Item.liDisplayName){Buf}, Length(Item.liDisplayName),
                     Item.FLabelRect, DT_CENTER or DT_VCENTER or
                     DT_WORDBREAK or DT_CALCRECT);
            LabelWidth := WidthOf(Item.FLabelRect);
            with Item.FLabelRect do begin
              Left := (ClientWidth - LabelWidth) div 2;
              Right := Left + LabelWidth + 1;
            end;
            BkMode := SetBkMode(DrawBmp.Canvas.Handle, TRANSPARENT);
            Inc(CurPos, DrawText(DrawBmp.Canvas.Handle, PChar(Item.liDisplayName){Buf},
                      Length(Item.liDisplayName),
                      Item.FLabelRect,
                      DT_CENTER or DT_VCENTER or DT_WORDBREAK));
            SetBkMode(DrawBmp.Canvas.Handle, BkMode);

            Inc(CurPos, FItemSpacing);
            {Inc(CurPos, Abs(DrawBmp.Canvas.Font.Height) + 3);}
          end else begin {small icons}
            {glyph is at the left}
            with Item.FIconRect do begin
              Top := CurPos;
              yOffset := (Abs(DrawBmp.Canvas.Font.Height)) div 2;
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
                    FImages.Draw(BM.Canvas, 0, 0, Item.IconIndex);
                    {FImages.GetBitmap(Item.IconIndex, BM);}
                    DrawBmp.Canvas.BrushCopy(Item.FIconRect, BM,
                      Rect(0, 0, BM.Width, BM.Height), BM.Canvas.Pixels[0, BM.Height-1]);
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
(*
              if Item.liDisplayName > '' then
                X := DrawBmp.Canvas.TextWidth(Item.liDisplayName)
              else
                X := DrawBmp.Canvas.TextWidth(Text);
*)
              Right := Left + X;
              if Top > lobItemsRect.Bottom then
                Break;
            end;
            Item.liDisplayName :=
              GetDisplayString(DrawBmp.Canvas, Text, 1, WidthOf(Item.FLabelRect));
            DrawText(DrawBmp.Canvas.Handle, PChar(Item.liDisplayName){Buf}, Length(Item.liDisplayName),
                     Item.FLabelRect, DT_LEFT or DT_VCENTER or DT_CALCRECT);
            LabelWidth := WidthOf(Item.FLabelRect);
            with Item.FLabelRect do
              Right := Left + LabelWidth + 1;
            DrawText(DrawBmp.Canvas.Handle, PChar(Item.liDisplayName){Buf}, Length(Item.liDisplayName),
                     Item.FLabelRect, DT_LEFT or DT_VCENTER);

            Inc(CurPos, FItemSpacing);
            {Inc(CurPos, TextHeight('Yg')*2);}
          end;
        end;
      end;

      {now, draw the folder buttons at the bottom}
      DrawBmp.Canvas.Font := Self.Font;
      SetBkMode(Handle, BkMode);
      SetBkColor(Handle, BkColor);
      case FDrawingStyle of
        { Regular button style. }
        dsDefault :
          CurPos := ClientHeight - FButtonHeight;
        { Etched style (Outlook98). }
        dsEtched :
          CurPos := ClientHeight - FButtonHeight - 1;
      end;
      for I := FolderCount-1 downto FActiveFolder+1 do begin
        MyRect.Top := CurPos;
        MyRect.Bottom := CurPos + FButtonHeight;
        Folders[I].lfRect := MyRect;
        case FDrawingStyle of
          { Regular button style. }
          dsDefault :
            TR := DrawButtonFace(DrawBmp.Canvas, MyRect, 1, bsNew, False, (I = FHotFolder) and lobMouseDown, False);
          { Etched style (Outlook98). }
          dsEtched :
            begin
              Brush.Color := clBtnFace;
              FillRect(MyRect);
              Pen.Color := clBtnShadow;
              Brush.Style := bsClear;
              Rectangle(MyRect.Left, MyRect.Top, MyRect.Right - 1, MyRect.Bottom);
              Pen.Color := clBtnHighlight;
              MoveTo(MyRect.Left + 1, MyRect.Bottom - 2);
              LineTo(MyRect.Left + 1, MyRect.Top + 1);
              LineTo(MyRect.Right - 2, MyRect.Top + 1);
              Pen.Color := clBtnHighlight;
              MoveTo(Width - 1, 0);
              LineTo(Width - 1, Height);
              TR := MyRect;
            end;
        end;
        Inc(TR.Top);
        Flags := DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX;
        if Folders[I].Enabled then begin
          DrawText(DrawBmp.Canvas.Handle, PChar(Folders[I].lfDisplayName){Buf},
          length(Folders[I].lfDisplayName){StrLen(Buf)}, TR, Flags);
          if (I = FHotFolder) and not lobMouseDown then begin
            case FDrawingStyle of
              { Regular button style. }
              dsDefault :
                begin
                  InflateRect(TR,1,1);
                  inc(TR.Left);
                  Frame3D(DrawBmp.Canvas, TR, clBtnHighlight, clWindowFrame, 1);
                end;
              { Etched style (Outlook98). }
              dsEtched :
                begin
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
          DrawBmp.Canvas.Font.Color := clHighlightText;
          SetBkMode(Canvas.Handle, OPAQUE);
          DrawText(DrawBmp.Canvas.Handle, PChar(Folders[I].lfDisplayName){Buf}, -1, TR, Flags);
          SetBkMode(DrawBmp.Canvas.Handle, TRANSPARENT);
          DrawBmp.Canvas.Font.Color := clBtnShadow;
          OffsetRect(TR, -2, -1);
          DrawText(DrawBmp.Canvas.Handle, PChar(Folders[I].lfDisplayName){Buf}, -1, TR, Flags);
          DrawBmp.Canvas.Font.Color := Self.Font.Color;
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
          DrawBmp.Canvas.Polygon([ Point(3,lobDropY+4),
                           Point(7,lobDropY),
                           Point(3, lobDropY-4)]);
          DrawBmp.Canvas.FloodFill(5, lobDropY, clBlack, fsBorder);
          DrawBmp.Canvas.Polygon([ Point(ClientWidth-3,lobDropY+4),
                           Point(ClientWidth-7,lobDropY),
                           Point(ClientWidth-3,lobDropY-4)]);
          DrawBmp.Canvas.FloodFill(ClientWidth-5, lobDropY, clBlack, fsBorder);
        end;
      end;
    end;
  finally
    Canvas.CopyMode := cmSrcCopy;
    Canvas.CopyRect(ClientRect, DrawBmp.Canvas, ClientRect);
    DrawBmp.Free;
  end;

end;

procedure TOvcLookOutBar.RemoveFolder(AFolderIndex : Integer);
begin
  BeginUpdate;
  try
    FFolders[AFolderIndex].Free;
    if FolderCount > 0 then
      ActiveFolder := 0
    else
      ActiveFolder := -1;
    lobTopItem := 0;
  finally
    EndUpdate;
  end;
end;

procedure TOvcLookOutBar.RemoveItem(AFolderIndex, AItemIndex : Integer);
var
  AFolder : TOvcLookOutFolder;
begin
  AFolder := Folders[AFolderIndex];
  BeginUpdate;
  try
    TOvcLookOutItem(AFolder.Items[AItemIndex]).Free;
    if AItemIndex <= lobTopItem then
      lobTopItem := 0;
    if AItemIndex <= FActiveItem then
      FActiveItem := 0;
    if AFolder.ItemCount = 0 then begin
      FActiveItem := -1;
      FSelectedItem := -1;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TOvcLookOutBar.RenameFolder(AFolderIndex : Integer);
var
  Folder : TOvcLookOutFolder;
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

procedure TOvcLookOutBar.RenameItem(AFolderIndex, AItemIndex : Integer);
var
  Item   : TOvcLookOutItem;
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


procedure TOvcLookOutBar.RestoreState(const Section : string = '');
var
  F, FC       : Integer;
  I, IC       : Integer;
  Folder      : TOvcLookOutFolder;
  Item        : TOvcLookOutItem;
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
        Folder := TOvcLookOutFolder(FolderCollection.Add);
        Folder.Caption := FStorage.ReadString(SectionName, S + '.Caption', '');
        Folder.Enabled := FStorage.ReadBoolean(SectionName, S + '.Enabled', True);
        Folder.IconSize := TOvcIconSize(FStorage.ReadInteger(SectionName, S + '.IconSize', Ord(isLarge)));
        Folder.Tag := FStorage.ReadInteger(SectionName, S + '.Tag', 0);
        {load item count}
        IC := FStorage.ReadInteger(SectionName, S + '.ItemCount', 0);
        {load each item's information}
        for I := 0 to IC-1 do begin
          Item := TOvcLookOutItem(Folder.ItemCollection.Add);
          S := 'Folder.' + IntToStr(F) + '.Item.' + IntToStr(I);
          Item.Caption := FStorage.ReadString(SectionName, S + '.Caption', '');
          Item.Description := FStorage.ReadString(SectionName, S + '.Description', '');
          Item.IconIndex := FStorage.ReadInteger(SectionName, S + '.IconIndex', -1);
          Item.Tag := FStorage.ReadInteger(SectionName, S + '.Tag', 0);
        end;
      end;
    finally
      FStorage.Close;
    end;
  end;
end;


procedure TOvcLookOutBar.SaveState(const Section : string = '');
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
        FStorage.WriteInteger(SectionName, S + '.IconSize', Ord(Folders[F].IconSize));
        FStorage.WriteInteger(SectionName, S + '.Tag', Folders[F].Tag);
        {save item count}
        FStorage.WriteInteger(SectionName, S + '.ItemCount', Folders[F].ItemCount);
        {save each item's information}
        for I := 0 to Folders[F].ItemCount-1 do begin
          S := 'Folder.' + IntToStr(F) + '.Item.' + IntToStr(I);
          FStorage.WriteString(SectionName, S + '.Caption', Folders[F].Items[I].Caption);
          FStorage.WriteString(SectionName, S + '.Description', Folders[F].Items[I].Description);
          FStorage.WriteInteger(SectionName, S + '.IconIndex', Folders[F].Items[I].IconIndex);
          FStorage.WriteInteger(SectionName, S + '.Tag', Folders[F].Items[I].Tag);
        end;
      end;
    finally
      FStorage.Close;
    end;
  end;
end;

procedure TOvcLookOutBar.SetActiveFolder(Value : Integer);
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
        Y := HeightOf(R)-FScrollDelta;
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

procedure TOvcLookOutBar.SetBackgroundColor(Value : TColor);
begin
  if Value <> FBackgroundColor then begin
    FBackgroundColor := Value;
    Invalidate;
  end;
end;

procedure TOvcLookOutBar.SetBackgroundImage(Value : TBitmap);
begin
  if Assigned(Value) then
    FBackgroundImage.Assign(Value)
  else begin
    FBackgroundImage.Free;
    FBackgroundImage := TBitmap.Create;
  end;
  Invalidate;
end;

procedure TOvcLookOutBar.SetBackgroundMethod(Value : TOvcBackgroundMethod);
begin
  if Value <> FBackgroundMethod then begin
    FBackgroundMethod := Value;
    Invalidate;
  end;
end;

procedure TOvcLookOutBar.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcLookOutBar.SetButtonHeight(Value : Integer);
begin
  if Value <> FButtonHeight then begin
    FButtonHeight := Value;
    Invalidate;
  end;
end;

procedure TOvcLookOutBar.SetDrawingStyle(Value: TOvcFolderDrawingStyle);
begin
  if Value <> FDrawingStyle then begin
    FDrawingStyle := Value;
    if FDrawingStyle = dsEtched then
      BorderStyle := bsNone;
    Invalidate;
  end;
end;

procedure TOvcLookOutBar.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  lobRecalcDisplayNames;
end;

procedure TOvcLookOutBar.SetImages(Value : TImageList);
begin
  if FImages <> nil then
    FImages.OnChange := nil;
  FImages := Value;
  if FImages <> nil then begin
    Images.OnChange := lobImagesChanged;
    Invalidate;
  end;
end;

procedure TOvcLookOutBar.SetItemFont(Value : TFont);
begin
  if Assigned(Value) then
    FItemFont.Assign(Value);
end;


procedure TOvcLookOutBar.SetItemSpacing(Value : Word);
begin
  if (Value > 0) then begin
    FItemSpacing := Value;
    Invalidate;
  end;
end;



procedure TOvcLookOutBar.SetSelectedItemFont(Value : TFont);
begin
  if Assigned(Value) then
    FSelectedItemFont.Assign(Value);
end;


procedure TOvcLookOutBar.SetScrollDelta(Value: Integer);
begin
  if Value <= 0 then
    FScrollDelta := 1
  else
    FScrollDelta := Value;
end;


procedure TOvcLookOutBar.SetStorage(Value : TOvcAbstractStore);
begin
  FStorage := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TOvcLookOutBar.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;  {don't erase background}
end;

procedure TOvcLookOutBar.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  {tell windows we are a static control to avoid receiving the focus}
  Msg.Result := DLGC_STATIC;
end;

procedure TOvcLookOutBar.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  inherited;

  lobHitTest.X := Msg.Pos.X;
  lobHitTest.Y := Msg.Pos.Y;
end;

procedure TOvcLookOutBar.WMSetCursor(var Msg : TWMSetCursor);
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

procedure TOvcLookOutBar.Loaded;
begin
  inherited Loaded;
  if DrawingStyle = dsEtched then
    BorderStyle := bsNone;
end;

{ Overridden DragOver method. }
procedure TOvcLookOutBar.DragOver(Source: TObject; X, Y: Integer; State: TDragState;
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

procedure TOvcLookOutBar.DragDrop(Source: TObject; X, Y : Integer);
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

end.
