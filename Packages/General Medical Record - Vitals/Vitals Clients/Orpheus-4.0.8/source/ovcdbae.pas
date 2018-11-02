{*********************************************************}
{*                   OVCDBAE.PAS 4.06                    *}
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

unit ovcdbae;
  {-Data aware array editors}

interface

uses
  Types, Windows, Buttons, Classes, Controls, DB, DbCtrls, Forms, Graphics,
  SysUtils, Messages, OvcBase, OvcColor, OvcCmd, OvcConst, OvcData, OvcDbNf,
  OvcDbPf, OvcDbSf, OvcMisc, OvcEf, OvcStr;

type
  {event to get color of the item cell}
  TGetItemColorEvent =
    procedure(Sender : TObject; Field : TField; Row : Integer; var FG, BG : TColor)
    of object;
  {event to notify of a scroll action}
  TIndicatorClickEvent =
    procedure(Sender : TObject; Row : Integer)
    of object;

type
  

  TOvcDbSimpleCell = class(TOvcDbSimpleField)
  private
  protected
    procedure CreateWnd;
      override;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
  public
    constructor Create(AOwner : TComponent);
      override;
  end;

  TOvcDbPictureCell = class(TOvcDbPictureField)
  private
  protected
    procedure CreateWnd;
      override;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
  public
    constructor Create(AOwner : TComponent);
      override;
  end;

  TOvcDbNumericCell = class(TOvcDbNumericField)
  private
  protected
    procedure CreateWnd;
      override;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
  public
    constructor Create(AOwner : TComponent);
      override;
  end;


  {base class for data-aware array editors}
  TOvcBaseDbArrayEditor = class(TOvcCustomControlEx)
  

  protected {private}
    FActiveRow           : Integer;      {the row index of the active item}
    FAutoRowHeight       : Boolean;      {auto row height}
    FBorderStyle         : TBorderStyle; {border around the control}
    FDataField           : string;       {database field name}
    FDataSource          : TDataSource;  {data source}
    FDateOrTime          : TDateOrTime;  {determines if editing dates or times}
    FDecimalPlaces       : Byte;         {max decimal places}
    FEpoch               : Integer;      {combined epoch year and cenury}
    FFieldType           : TFieldType;   {field data type}
    FHighlightColors     : TOvcColors;   {highlight colors}
    FLineColor           : TColor;       {color of row divider lines}
    FMaxLength           : Word;         {maximum length of string}
    FOptions             : TOvcEntryFieldOptions;
    FPadChar             : AnsiChar;     {character used to pad end of string}
    FPageScroll          : Boolean;      {true to scroll like Delphi's grids}
    FPictureMask         : string;       {picture mask}
    FRowHeight           : Integer;      {pixel height of one row}
    FRowIndicatorWidth   : Integer;      {width of row indicators}
    FShowIndicator       : Boolean;      {true to show row indicators}
    FTextMargin          : Integer;      {indent from left (right)}
    FUseScrollBar        : Boolean;      {true to use vertical scroll bar}
    FZeroAsNull          : Boolean;      {true to store zero value as null}

    {cell datalink event hook variables}
    FCellOnActiveChange  : TNotifyEvent;
    FCellOnDataChange    : TNotifyEvent;
    FCellOnEditingChange : TNotifyEvent;
    FCellOnUpdateData    : TNotifyEvent;

    {event variables}
    FOnChange            : TNotifyEvent;
    FOnError             : TValidationErrorEvent;
    FOnGetItemColor      : TGetItemColorEvent;
    FOnIndicatorClick    : TIndicatorClickEvent;
    FOnUserCommand       : TUserCommandEvent;
    FOnUserValidation    : TUserValidationEvent;

    {internal/working variables}
    aeIndicators         : TImageList;    {list of indicators}
    aeNumRows            : Integer;       {visible rows in window}
    aeRangeLo            : TRangeType;    {low field range limit}
    aeRangeHi            : TRangeType;    {high field range limit}
    aeRangeLoaded        : Boolean;       {flag to tell when loaded}
    aePainting           : Boolean;       {True when painting}
    aeFocusing           : Boolean;       {True when changing focus}

    {property methods}
    function GetDataLink : TFieldDataLink;
    function GetField : TField;
    function GetRangeHi : string;
    function GetRangeLo : string;
    procedure SetActiveRow(Value : Integer);
    procedure SetAutoRowHeight(Value : Boolean);
    procedure SetBorderStyle(Value : TBorderStyle);
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetDateOrTime(Value : TDateOrTime);
    procedure SetDecimalPlaces(Value : Byte);
    procedure SetEpoch(Value : Integer);
    procedure SetFieldType(Value : TFieldType);
    procedure SetLineColor(Value : TColor);
    procedure SetMaxLength(Value : Word);
    procedure SetOptions(Value : TOvcEntryFieldOptions);
    procedure SetPadChar(Value : AnsiChar);
    procedure SetPictureMask(const Value : string);
    procedure SetRangeHi(const Value : string);
    procedure SetRangeLo(const Value : string);
    procedure SetRowHeight(Value : Integer);
    procedure SetRowIndicatorWidth(Value : Integer);
    procedure SetShowIndicator(Value : Boolean);
    procedure SetTextMargin(Value : Integer);
    procedure SetUseScrollBar(Value : Boolean);
    procedure SetZeroAsNull(Value : Boolean);

    {general (internal) routines}
    procedure aeAdjustIntegralHeight;
    procedure aeAdjustRowHeight;
    procedure aeColorChanged(AColor : TObject);
    procedure aeMoveCell(NewIndex : Integer);
    procedure aeReadRangeHi(Stream : TStream);
    procedure aeReadRangeLo(Stream : TStream);
    procedure aeUpdateActive;
    procedure aeUpdateNumRows;
    procedure aeUpdateScrollBar;
    procedure aeWriteRangeHi(Stream : TStream);
    procedure aeWriteRangeLo(Stream : TStream);

    {event handlers for attached cell datalink}
    procedure aeActiveChange(Sender : TObject);
    procedure aeDataChange(Sender : TObject);
    procedure aeEditingChange(Sender : TObject);
    procedure aeUpdateData(Sender : TObject);

    {VCL control messages}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;

    {windows message methods}
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd);
      message WM_ERASEBKGND;
    procedure WMGetMinMaxInfo(var Msg : TWMGetMinMaxInfo);
      message WM_GETMINMAXINFO;
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMMouseActivate(var Msg : TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMSize(var Msg : TWMSize);
      message WM_SIZE;
    procedure WMVScroll(var Msg : TWMScroll);
      message WM_VSCROLL;

  protected
    {internal/working variables}
    aeCell      : TOvcBaseEntryField;

    {VCL methods}
    procedure ChangeScale(M, D : Integer);
      override;
    procedure CreateParams(var Params: TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure DefineProperties(Filer : TFiler);
      override;
    procedure Paint;
      override;

    {abstract internal methods}
    procedure aeCreateEditCell;
      virtual; abstract;
      {-create the edit cell}
    procedure aeGetCellProperties;
      virtual; abstract;
      {-freshen our copy of the cell properties}

    {general internal methods}
    function aeGetEditString : PChar;
      {-return the edit cells edit string}
    procedure aeGetSampleDisplayData(P : PChar);
      {-return a sample display string}
    procedure aeRefresh;
      {-called to conditionally call refresh}

    {event wrapper methods}
    procedure DoGetItemColor(AField : TField; ARow : Integer; var FG, BG : TColor);
      virtual;
      {-get the color values for the cell}
    procedure DoOnIndicatorClick(Row : Integer);
      dynamic;
      {-perform indicator click notification}


    property AutoRowHeight : Boolean
      read FAutoRowHeight
      write SetAutoRowHeight;

    property BorderStyle : TBorderStyle
      read FBorderStyle
      write SetBorderStyle;

    property DataField : string
      read FDataField
      write SetDataField;

    property DataSource : TDataSource
      read FDataSource
      write SetDataSource;

    property DateOrTime : TDateOrTime
      read FDateOrTime
      write SetDateOrTime;

    property DecimalPlaces : Byte
      read FDecimalPlaces
      write SetDecimalPlaces;

    property Epoch : Integer
      read FEpoch
      write SetEpoch;

    property FieldType : TFieldType
      read FFieldType
      write SetFieldType;

    property HighlightColors : TOvcColors
      read FHighlightColors
      write FHighlightColors;

    property LineColor : TColor
      read FLineColor
      write SetLineColor;

    property MaxLength : Word
      read FMaxLength
      write SetMaxLength;

    property Options : TOvcEntryFieldOptions
      read FOptions
      write SetOptions;

    property PadChar : AnsiChar
      read FPadChar
      write SetPadChar;

    property PageScroll : Boolean
      read FPageScroll
      write FPageScroll;

  

    property PictureMask : string
      read FPictureMask
      write SetPictureMask;


    property RangeHi : string
      read GetRangeHi
      write SetRangeHi
      stored False;

    property RangeLo : string
      read GetRangeLo
      write SetRangeLo
      stored False;

    property RowHeight : Integer
      read FRowHeight
      write SetRowHeight;

    property RowIndicatorWidth : Integer
      read FRowIndicatorWidth
      write SetRowIndicatorWidth;

    property ShowIndicator : Boolean
      read FShowIndicator
      write SetShowIndicator;

    property TextMargin : Integer
      read FTextMargin
      write SetTextMargin;

    property UseScrollBar : Boolean
      read FUseScrollBar
      write SetUseScrollBar;

    property ZeroAsNull : Boolean
      read FZeroAsNull
      write SetZeroAsNull;

    {events echoed to the edit field object}
    property OnChange : TNotifyEvent
      read FOnChange
      write FOnChange;

    property OnError : TValidationErrorEvent
      read FOnError
      write FOnError;

    property OnGetItemColor : TGetItemColorEvent
      read FOnGetItemColor
      write FOnGetItemColor;

    property OnIndicatorClick : TIndicatorClickEvent
      read FOnIndicatorClick
      write FOnIndicatorClick;

    property OnUserCommand : TUserCommandEvent
      read FOnUserCommand
      write FOnUserCommand;

    property OnUserValidation : TUserValidationEvent
      read FOnUserValidation
      write FOnUserValidation;

  public
  

    constructor Create(AOwner : TComponent);
      override;
    destructor  Destroy;
      override;
    procedure SetFocus;
      override;


    procedure Reset;
      {-discard current changes (if any) and obtain new data from TField}
    procedure Scroll(Delta : Integer);
      {-scroll the datasource by Distance (signed)}
    procedure UpdateRecord;
      {-force cell to update its underlying TField}

    property Canvas;

  

    property ActiveRow : Integer
      read FActiveRow
      write SetActiveRow
      stored False;

    property DataLink : TFieldDataLink
      read GetDataLink;


    property Field : TField
      read GetField;

  published
  end;

  TOvcDbSimpleArrayEditor = class(TOvcBaseDbArrayEditor)
  

  protected {private}
    {virtual methods}
    procedure aeCreateEditCell;
      override;
      {-create the edit cell}
    procedure aeGetCellProperties;
      override;
      {-freshen our copies of the cell properties}

  public
    constructor Create(AOwner : TComponent);
      override;


  published
    property FieldType;
    property DataSource;
    property DataField;

    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property AutoRowHeight;
    property BorderStyle;
    property Color;
    property Controller;
    property Ctl3D;
    property DecimalPlaces;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property HighlightColors;
    property LineColor;
    property MaxLength;
    property PadChar;
    property PageScroll;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureMask;
    property PopupMenu;
    property RangeHi stored False;
    property RangeLo stored False;
    property RowHeight;
    property RowIndicatorWidth;
    property ShowHint;
    property ShowIndicator;
    property TabOrder;
    property TabStop;
    property Tag;
    property TextMargin;
    property UseScrollBar;
    property Visible;
    property Width;
    property ZeroAsNull;

    {events}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnError;
    property OnExit;
    property OnGetItemColor;
    property OnIndicatorClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnUserCommand;
    property OnUserValidation;
  end;

  TOvcDbPictureArrayEditor = class(TOvcBaseDbArrayEditor)
  

  protected {private}
    {virtual methods}
    procedure aeCreateEditCell;
      override;
      {-create the edit cell}
    procedure aeGetCellProperties;
      override;
      {-freshen our copies of the cell properties}

  public
    constructor Create(AOwner : TComponent);
      override;


  published
    property FieldType;
    property DataSource;
    property DataField;
    property DateOrTime;

    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property AutoRowHeight;
    property BorderStyle;
    property Color;
    property Controller;
    property Ctl3D;
    property DecimalPlaces;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Epoch;
    property Font;
    property Height;
    property HighlightColors;
    property LineColor;
    property MaxLength;
    property PadChar;
    property PageScroll;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureMask;
    property PopupMenu;
    property RangeHi stored False;
    property RangeLo stored False;
    property RowHeight;
    property RowIndicatorWidth;
    property ShowHint;
    property ShowIndicator;
    property TabOrder;
    property TabStop;
    property Tag;
    property TextMargin;
    property UseScrollBar;
    property Visible;
    property Width;
    property ZeroAsNull;

    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnError;
    property OnExit;
    property OnGetItemColor;
    property OnIndicatorClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnUserCommand;
    property OnUserValidation;
  end;

  TOvcDbNumericArrayEditor = class(TOvcBaseDbArrayEditor)
  

  protected {private}
    {virtual methods}
    procedure aeCreateEditCell;
      override;
      {-create the edit cell}
    procedure aeGetCellProperties;
      override;
      {-freshen our copies of the cell properties}

  public
    constructor Create(AOwner : TComponent);
      override;


  published
    property FieldType;
    property DataSource;
    property DataField;

    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property AutoRowHeight;
    property BorderStyle;
    property Color;
    property Controller;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property HighlightColors;
    property LineColor;
    property PadChar;
    property PageScroll;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureMask;
    property PopupMenu;
    property RangeHi stored False;
    property RangeLo stored False;
    property RowHeight;
    property RowIndicatorWidth;
    property ShowHint;
    property ShowIndicator;
    property TabOrder;
    property TabStop;
    property Tag;
    property TextMargin;
    property UseScrollBar;
    property Visible;
    property Width;
    property ZeroAsNull;

    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnError;
    property OnExit;
    property OnGetItemColor;
    property OnIndicatorClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnUserCommand;
    property OnUserValidation;
  end;


implementation


type
  TLocalEF = class(TOvcBaseEntryField);



{*** TOvcBaseDbArrayEditor ***}

procedure TOvcBaseDbArrayEditor.aeActiveChange(Sender : TObject);
begin
  if Assigned(FCellOnActiveChange) then
    FCellOnActiveChange(Sender);
end;

procedure TOvcBaseDbArrayEditor.aeAdjustIntegralHeight;
begin
  if not HandleAllocated then
    Exit;

  if csLoading in ComponentState then
    Exit;

  if ClientHeight <> aeNumRows*FRowHeight then
    ClientHeight := aeNumRows*FRowHeight;
end;

procedure TOvcBaseDbArrayEditor.aeAdjustRowHeight;
  {-adjust the row height based on the current font}
var
  DC         : hDC;
  SaveFont   : hFont;
  H          : Integer;
  SysMetrics : TTextMetric;
  Metrics    : TTextMetric;
begin
  if not FAutoRowHeight then
    Exit;

  if csLoading in ComponentState then
    Exit;

  DC := GetDC(0);
  try
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;

  if NewStyleControls then
    H := GetSystemMetrics(SM_CYBORDER) * 4
  else begin
    H := SysMetrics.tmHeight;
    if H > Metrics.tmHeight then
      H := Metrics.tmHeight;
    H := H div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;

  FRowHeight := Metrics.tmHeight + H;
end;

procedure TOvcBaseDbArrayEditor.aeColorChanged(AColor : TObject);
begin
  aeRefresh;
end;

procedure TOvcBaseDbArrayEditor.aeDataChange(Sender : TObject);
  {-notification routine called by an aeCell event}
begin
  if aePainting then
    Exit;

  if Assigned(FCellOnDataChange) then
    FCellOnDataChange(Sender);

  {if field data type has changed, reset properties}
  if Field <> nil then
    if Field.DataType <> FFieldType then
      aeGetCellProperties;

  {set the number of managed items}
  aeUpdateNumRows;

  {update the active record number}
  aeUpdateActive;

  {move the cell to the specified row Index}
  aeMoveCell(FActiveRow);

  {set the scroll bar range}
  aeUpdateScrollBar;

  Invalidate;
end;

procedure TOvcBaseDbArrayEditor.aeEditingChange(Sender : TObject);
begin
  if Assigned(FCellOnEditingChange) then
    FCellOnEditingChange(Sender);
end;

function TOvcBaseDbArrayEditor.aeGetEditString : PChar;
  {-return the edit cells edit string}
begin
  Result := TLocalEF(aeCell).efEditSt;
end;

procedure TOvcBaseDbArrayEditor.aeGetSampleDisplayData(P : PChar);
  {-return a sample display string}
begin
  TLocalEF(aeCell).efGetSampleDisplayData(P);
end;

procedure TOvcBaseDbArrayEditor.aeMoveCell(NewIndex : Integer);
  {-moves the cell to the specified row Index}
begin
  if Assigned(aeCell) then
    aeCell.Top := NewIndex*FRowHeight;
end;

procedure TOvcBaseDbArrayEditor.aeReadRangeHi(Stream : TStream);
  {-called to read the high range from the stream}
begin
  Stream.Read(aeRangeHi, SizeOf(TRangeType));
  aeRangeLoaded := True;
end;

procedure TOvcBaseDbArrayEditor.aeReadRangeLo(Stream : TStream);
  {-called to read the low range from the stream}
begin
  Stream.Read(aeRangeLo, SizeOf(TRangeType));
  aeRangeLoaded := True;
end;

procedure TOvcBaseDbArrayEditor.aeRefresh;
  {-called to invalidate and paint}
begin
  Refresh;
  if Assigned(aeCell) then
    aeCell.Refresh;
end;

procedure TOvcBaseDbArrayEditor.aeUpdateActive;
begin
  if csLoading in ComponentState then
    Exit;

  if (DataLink <> nil) and DataLink.Active then
    FActiveRow := DataLink.ActiveRecord;
end;

procedure TOvcBaseDbArrayEditor.aeUpdateData(Sender : TObject);
begin
  if Assigned(FCellOnUpdateData) then
    FCellOnUpdateData(Sender);
end;

procedure TOvcBaseDbArrayEditor.aeUpdateNumRows;
  {-update the number of rows}
begin
  aeNumRows := Height div FRowHeight;
  if aeNumRows < 1 then
    aeNumRows := 1;

  if DataLink <> nil then
    if DataLink.Active and (DataLink.RecordCount > 0) then
      DataLink.BufferCount := aeNumRows;
end;

procedure TOvcBaseDbArrayEditor.aeUpdateScrollBar;
  {-sets the vertical scroll bar position}
var
  SIOld, SINew : TScrollInfo;
begin
  if not FUseScrollBar then
    Exit;

  if csLoading in ComponentState then
    Exit;

  if (DataLink = nil) or not DataLink.Active then
    Exit;

  with Datalink.DataSet do begin
    SIOld.cbSize := SizeOf(SIOld);
    SIOld.fMask := SIF_ALL;
    GetScrollInfo(Self.Handle, SB_VERT, SIOld);
    SINew := SIOld;
    if IsSequenced then begin
      SINew.nMin := 1;
      SINew.nPage := aeNumRows;
      SINew.nMax := Integer(DWORD(RecordCount) + SINew.nPage - 1);
      if State in [dsInactive, dsBrowse, dsEdit] then
        SINew.nPos := RecNo;  {else keep old pos}
    end else begin
      SINew.nMin := 0;
      SINew.nPage := 0;
      SINew.nMax := 4;
      if DataLink.DataSet.BOF then
        SINew.nPos := 0
      else if DataLink.DataSet.EOF then
        SINew.nPos := 4
      else
        SINew.nPos := 2;
    end;
    if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
       (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
      SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
  end;
end;

procedure TOvcBaseDbArrayEditor.aeWriteRangeHi(Stream : TStream);
  {-called to store the high range on the stream}
begin
  Stream.Write(aeRangeHi, SizeOf(TRangeType));
end;

procedure TOvcBaseDbArrayEditor.aeWriteRangeLo(Stream : TStream);
  {-called to store the low range on the stream}
begin
  Stream.Write(aeRangeLo, SizeOf(TRangeType));
end;

procedure TOvcBaseDbArrayEditor.ChangeScale(M, D : Integer);
begin
  inherited ChangeScale(M, D);

  if M <> D then begin
    {scale row height}
    FRowHeight := MulDiv(FRowHeight, M, D);
    RecreateWnd;
  end;
end;

procedure TOvcBaseDbArrayEditor.CMCtl3DChanged(var Msg : TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;

procedure TOvcBaseDbArrayEditor.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  {optionally, adjust the row height}
  aeAdjustRowHeight;

  {adjust integral height}
  aeAdjustIntegralHeight;
end;

constructor TOvcBaseDbArrayEditor.Create(AOwner : TComponent);
var
  Bmp : Graphics.TBitmap;
begin
  inherited Create(AOwner);

  if NewStyleControls then
    ControlStyle := ControlStyle + [csClickEvents]
  else
    ControlStyle := ControlStyle + [csClickEvents, csFramed];

  {create indicators object and load bitmaps}
  Bmp := Graphics.TBitmap.Create;
  try
    Bmp.Handle := LoadBaseBitmap('ORDBARROW');
    aeIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    aeIndicators.AddMasked(Bmp, clWhite);
    Bmp.Handle := LoadBaseBitmap('ORDBEDIT');
    aeIndicators.AddMasked(Bmp, clWhite);
    Bmp.Handle := LoadBaseBitmap('ORDBINSERT');
    aeIndicators.AddMasked(Bmp, clWhite);
  finally
    Bmp.Free;
  end;

  {set default values for inherited persistent properties}
  Color             := clWindow;
  Ctl3D             := True;
  Height            := 150;
  ParentColor       := False;
  ParentCtl3D       := True;
  ParentFont        := True;
  TabStop           := True;
  Width             := 100;

  {set default values for persistent properties}
  FActiveRow        := 0;
  FAutoRowHeight    := True;
  FBorderStyle      := bsSingle;
  FFieldType        := ftUnknown;
  FRowIndicatorWidth:= 11;
  FLineColor        := clSilver;
  FPadChar          := DefPadChar;
  FPageScroll       := False;
  FRowHeight        := 17;
  FShowIndicator    := True;
  FTextMargin       := 2;
  FUseScrollBar     := True;
  ZeroAsNull        := False;

  {set defaults for working variables}
  aeNumRows         := 0;
  aeRangeLoaded     := False;

  {create and initialize colors object}
  FHighlightColors := TOvcColors.Create(clHighlightText, clHighlight);
  FHighlightColors.OnColorChange := aeColorChanged;
end;

procedure TOvcBaseDbArrayEditor.CreateParams(var Params: TCreateParams);
const
  ScrollBar : array[Boolean] of Integer = (0, WS_VSCROLL);
begin
  inherited CreateParams(Params);

  with Params do
    Style := Integer(Style) or
      ScrollBar[FUseScrollBar] or BorderStyles[FBorderStyle];

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcBaseDbArrayEditor.CreateWnd;
begin
  inherited CreateWnd;

  {optionally, adjust the row height}
  aeAdjustRowHeight;

  {set the number of managed items}
  aeUpdateNumRows;

  {adjust integral height}
  aeAdjustIntegralHeight;

  {set the number of managed items}
  aeUpdateNumRows;

  {create the edit cell control}
  aeCreateEditCell;

  if PopupMenu <> nil then
    TLocalEF(aeCell).PopupMenu := PopupMenu;

  {set the scroll bar range}
  aeUpdateScrollbar;

  {force current item to be visible}
  aeMoveCell(FActiveRow);
end;

procedure TOvcBaseDbArrayEditor.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('RangeHigh', aeReadRangeHi, aeWriteRangeHi, True);
  Filer.DefineBinaryProperty('RangeLow', aeReadRangeLo, aeWriteRangeLo, True);
end;

destructor TOvcBaseDbArrayEditor.Destroy;
begin
  {dispose of the color object}
  FHighlightColors.Free;
  FHighlightColors := nil;

  {free the edit cell}
  aeCell.Free;
  aeCell := nil;

  aeIndicators.Free;
  aeIndicators := nil;

  inherited Destroy;
end;

procedure TOvcBaseDbArrayEditor.DoGetItemColor(AField : TField; ARow : Integer;
          var FG, BG : TColor);
begin
  if Assigned(FOnGetItemColor) then
    FOnGetItemColor(Self, AField, ARow, FG, BG);
end;

procedure TOvcBaseDbArrayEditor.DoOnIndicatorClick(Row : Integer);
  {-perform indicator click notification}
begin
  if not (csDesigning in ComponentState) and Assigned(FOnIndicatorClick) then
    FOnIndicatorClick(Self, Row);
end;

function TOvcBaseDbArrayEditor.GetDataLink : TFieldDataLink;
  {-return the cell datalink}
begin
  Result := nil;
  if Assigned(aeCell) then begin
    if aeCell is TOvcDbSimpleCell then
      Result := TOvcDbSimpleCell(aeCell).FDataLink
    else if aeCell is TOvcDbPictureCell then
      Result := TOvcDbPictureCell(aeCell).FDataLink
    else if aeCell is TOvcDbNumericCell then
      Result := TOvcDbNumericCell(aeCell).FDataLink;
  end;
end;

function TOvcBaseDbArrayEditor.GetField : TField;
  {-return the associated db field object}
begin
  Result := nil;
  if aeCell <> nil then begin
    if aeCell is TOvcDbSimpleCell then
      Result := TOvcDbSimpleCell(aeCell).Field
    else if aeCell is TOvcDbPictureCell then
      Result := TOvcDbPictureCell(aeCell).Field
    else if aeCell is TOvcDbNumericCell then
      Result := TOvcDbNumericCell(aeCell).Field;
  end;
end;

function TOvcBaseDbArrayEditor.GetRangeHi : string;
  {-get the high field range string value}
begin
  Result := TLocalEF(aeCell).efRangeToStRange(aeRangeHi);
end;

function TOvcBaseDbArrayEditor.GetRangeLo : string;
  {-get the low field range string value}
begin
  Result := TLocalEF(aeCell).efRangeToStRange(aeRangeLo);
end;

procedure TOvcBaseDbArrayEditor.Paint;
var
  CR          : TRect;
  IR, Clip    : TRect;
  I           : Integer;
  X, Y        : Integer;
  SaveActive  : Integer;
  Left        : Integer;
  Indicator   : Integer;
  HasFocus    : Boolean;
  Buf         : array[0..MaxEditLen] of Char;
  FGColor     : TColor;
  BGColor     : TColor;
  SaveFGColor : TColor;
begin
  {get the client area}
  CR := ClientRect;

  {get the cliping region}
  if csDesigning in ComponentState then
    Clip := CR
  else
    GetClipBox(Canvas.Handle, Clip);

  {set up the proper font and colors}
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  if not Enabled and (Color <> clGrayText) then
    Canvas.Font.Color := clGrayText;
  SaveFGColor := Font.Color;

  {set right alignment if this is a numeric field or using right-alignment}
  if (aeCell is TOvcDbNumericCell) or (efoRightAlign in FOptions) then
    SetTextAlign(Canvas.Handle, TA_RIGHT);

  {starting offset for text}
  X := FTextMargin-1;

  HasFocus := aeCell.Focused and not (csDesigning in ComponentState);
  SaveActive := FActiveRow;
  aePainting := True;
  try
    for I := 0 to Pred(aeNumRows) do begin
      CR.Top := I*FRowHeight;
      CR.Bottom := CR.Top+FRowHeight-1;
      if I = Pred(aeNumRows) then
        CR.Bottom := ClientHeight;
      Y := CR.Top + TLocalEF(aeCell).efTopMargin;

      if Bool(IntersectRect(IR, CR, Clip)) then begin

        {display row indicator if enabled}
        if FShowIndicator then begin
          CR.Left := FRowIndicatorWidth;
          DrawButtonFace(Canvas, Rect(0, CR.Top, FRowIndicatorWidth, CR.Bottom+1),
                         1, bsNew, False, False, False);
          Canvas.Brush.Color := Color;

          if (DataLink <> nil) and DataLink.Active and (I = SaveActive) then begin
            Indicator := 0;
            if DataLink.DataSet <> nil then
              case DataLink.DataSet.State of
                dsEdit   : Indicator := 1;
                dsInsert : Indicator := 2;
              end;
            aeIndicators.BkColor := clBtnFace;
            aeIndicators.Draw(Canvas, FRowIndicatorWidth-aeIndicators.Width-3,
              (CR.Top + CR.Bottom - aeIndicators.Height) shr 1, Indicator);
          end;
        end;

        if (I <> FActiveRow) or not HasFocus then begin
          if (DataLink <> nil) and DataLink.Active and (Field <> nil)
            and (I < DataLink.RecordCount) then begin
            {change active db record}
            DataLink.ActiveRecord := I;

            {allow user to change color}
            FGColor := SaveFGColor;
            BGColor := Color;
            DoGetItemColor(Field, I, FGColor, BGColor);

            Canvas.Font.Color := FGColor;
            Canvas.Brush.Color := BGColor;

            {get text to display}
            if FFieldType = ftDateTime then begin
              case FDateOrTime of
                ftUseDate : StrPLCopy(Buf, DateToStr(Field.AsDateTime), Length(Buf) - 1);
                ftUseTime : StrPLCopy(Buf, TimeToStr(Field.AsDateTime), Length(Buf) - 1);
              else
                StrPLCopy(Buf, Field.DisplayText, Length(Buf) - 1);
              end;
            end else
              StrPLCopy(Buf, Field.DisplayText, Length(Buf) - 1);
          end else begin
            if (DataLink <> nil) and (DataLink.DataSource <> nil) and
               (DataLink.DataSource.DataSet <> nil) and
               (I < DataLink.RecordCount) then
              aeGetSampleDisplayData(Buf)
            else
              Buf[0] := #0;
          end;

          Canvas.FillRect(CR);

          if (aeCell is TOvcDbNumericCell) or (efoRightAlign in FOptions) then begin
            TrimAllSpacesPChar(Buf);
            {paint the text right aligned}
            ExtTextOut(Canvas.Handle, CR.Right-FTextMargin-1, Y,
              {ETO_OPAQUE+}ETO_CLIPPED, @CR, Buf, StrLen(Buf), nil);
          end else begin
            if Field <> nil then begin
              case Field.Alignment of
                taLeftJustify  : Left := X + CR.Left;
                taRightJustify : Left := ClientWidth - Canvas.TextWidth(StrPas(Buf)) - X;
              else
                Left := (ClientWidth - Canvas.TextWidth(StrPas(Buf))) div 2;
              end;
            end else
              Left := X + CR.Left;
            ExtTextOut(Canvas.Handle, Left, Y,
              {ETO_OPAQUE+}ETO_CLIPPED, @CR, Buf, StrLen(Buf), nil);
          end;
        end;
      end;
    end;

  finally
    {restore active record}
    if (DataLink <> nil) and DataLink.Active then
      DataLink.ActiveRecord := SaveActive;

    {clear painting flag}
    aePainting := False;
  end;

  {paint the active cell}
  FGColor := SaveFGColor;
  BGColor := Color;
  DoGetItemColor(Field, FActiveRow, FGColor, BGColor);
  aeCell.Font.Color := FGColor;
  aeCell.Color := BGColor;
  aeCell.Repaint;

  {draw cell divider lines}
  if FShowIndicator then
    X := FRowIndicatorWidth
  else
    X := 0;
  Y := -1;
  Canvas.Pen.Color := FLineColor;
  for I := 0 to Pred(aeNumRows)-1 do begin
    Inc(Y, FRowHeight);
    Canvas.PolyLine([Point(X, Y), Point(ClientWidth, Y)]);
  end;
end;

procedure TOvcBaseDbArrayEditor.Reset;
  {-discard current changes (if any) and obtain new data from TField}
begin
  if (DataLink <> nil) and DataLink.Active then
    DataLink.Reset;
end;

procedure TOvcBaseDbArrayEditor.Scroll(Delta : Integer);
  {-scroll the datasource by Delta (signed)}
begin
  if (DataLink <> nil) and DataLink.Active then
    DataLink.DataSet.MoveBy(Delta);
end;

procedure TOvcBaseDbArrayEditor.SetActiveRow(Value : Integer);
  {-set the currently selected item}
begin
  if (DataLink = nil) or not DataLink.Active then
    Exit;

  if Value < 0 then
    Value := 0;
  if Value > Pred(aeNumRows) then
    Value := Pred(aeNumRows);

  if Value <> FActiveRow then
    DataLink.DataSet.MoveBy(Value-FActiveRow);
end;

procedure TOvcBaseDbArrayEditor.SetAutoRowHeight(Value : Boolean);
  {-set the AutoRowHeight option}
begin
  if Value <> FAutoRowHeight then begin
    FAutoRowHeight := Value;
    if FAutoRowHeight then
      RecreateWnd;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetBorderStyle(Value : TBorderStyle);
  {-set the style used for the border}
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetDataField(const Value : string);
begin
  if Value <> FDataField then begin
    FDataField := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetDataSource(Value : TDataSource);
begin
  FDataSource := Value;
  RecreateWnd;
end;

procedure TOvcBaseDbArrayEditor.SetDateOrTime(Value : TDateOrTime);
begin
  if Value <> FDateOrTime then begin
    FDateOrTime := Value;
    if Assigned(aeCell) then
      TOvcDbPictureCell(aeCell).DateOrTime := FDateOrTime;
    if not (csLoading in ComponentState) then
      aeGetCellProperties;
    Refresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetDecimalPlaces(Value : Byte);
  {-set the number of decimal places for the edit field}
begin
  if FDecimalPlaces <> Value then begin
    FDecimalPlaces := Value;
    if Assigned(aeCell) then begin
      aeCell.DecimalPlaces := FDecimalPlaces;

      {reset our copy of the edit field property}
      FDecimalPlaces := aeCell.DecimalPlaces;
    end;
    aeRefresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetEpoch(Value : Integer);
begin
  if Value <> FEpoch then begin
    FEpoch := Value;
    if Assigned(aeCell) then begin
      TOvcDbPictureCell(aeCell).Epoch := FEpoch;

      {reset our copy of the edit field property}
      FEpoch := TOvcDbPictureCell(aeCell).Epoch;
    end;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetFieldType(Value : TFieldType);
begin
  FFieldType := Value;
  RecreateWnd;
end;

procedure TOvcBaseDbArrayEditor.SetFocus;
begin
  if Assigned(aeCell) and not aeCell.Focused then
    inherited SetFocus;
end;

procedure TOvcBaseDbArrayEditor.SetLineColor(Value : TColor);
  {-set the color used to draw the row divider lines}
begin
  if Value <> FLineColor then begin
    FLineColor := Value;
    Refresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetMaxLength(Value : Word);
  {-set the maximum length of the edit field}
begin
  if FMaxLength <> Value then begin
    FMaxLength := Value;
    if Assigned(aeCell) then begin
      aeCell.MaxLength := FMaxLength;

      {reset our copy of the edit field property}
      FMaxLength := aeCell.MaxLength;
    end;
    aeRefresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetOptions(Value : TOvcEntryFieldOptions);
begin
  if Value <> FOptions then begin
    FOptions := Value;
    if (efoForceInsert in FOptions) then
      Exclude(FOptions, efoForceOvertype);
    if (efoForceOvertype in FOptions) then
      Exclude(FOptions, efoForceInsert);

    if Assigned(aeCell) then begin
      aeCell.Options := FOptions;
      FOptions := aeCell.Options;
    end;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetPadChar(Value : AnsiChar);
  {-set the character used to pad the end of the edit string}
begin
  if Value <> FPadChar then begin
    FPadChar := Value;
    if Assigned(aeCell) then begin
      aeCell.PadChar := Char(FPadChar);

      {reset our copy of the edit field property}
      FPadChar := AnsiChar(aeCell.PadChar);
    end;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetPictureMask(const Value : string);
  {-set the picture mask}
begin
  if (Value <> FPictureMask) and (Value > '') then begin
    FPictureMask := Value;
    if Assigned(aeCell) then begin
      if aeCell is TOvcDbSimpleCell then begin
        if Length(FPictureMask) > 0 then
          TOvcDbSimpleCell(aeCell).PictureMask := FPictureMask[1];
        FPictureMask := TOvcDbSimpleCell(aeCell).PictureMask;
      end else if aeCell is TOvcDbPictureCell then begin
        TOvcDbPictureCell(aeCell).PictureMask := FPictureMask;
        FPictureMask := TOvcDbPictureCell(aeCell).PictureMask;
      end else if aeCell is TOvcDbNumericCell then begin
        TOvcDbNumericCell(aeCell).PictureMask := FPictureMask;
        FPictureMask := TOvcDbNumericCell(aeCell).PictureMask;
      end;
    end;
    aeRefresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetRangeHi(const Value : string);
  {-set the high field range from a string value}
begin
  if Assigned(aeCell) then begin
    aeCell.RangeHi := Value;
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetRangeLo(const Value : string);
  {-set the low field range from a string value}
begin
  if Assigned(aeCell) then begin
    aeCell.RangeLo := Value;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetRowHeight(Value : Integer);
  {-set the cell row height}
begin
  if (Value <> FRowHeight) and (Value > 0) then begin
    FRowHeight := Value;
    if not (csLoading in ComponentState) then
      FAutoRowHeight := False;
    RecreateWnd;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetRowIndicatorWidth(Value : Integer);
  {-set the row indicator width}
begin
  if (Value <> FRowIndicatorWidth) and (Value >= 0) then begin
    FRowIndicatorWidth := Value;

    {at design-time, automatically toggle the show state}
    if csDesigning in ComponentState then begin
      if FRowIndicatorWidth = 0 then
        FShowIndicator := False
      else
        FShowIndicator := True;
    end;

    if Assigned(aeCell) and FShowIndicator then
      aeCell.SetBounds(FRowIndicatorWidth, aeCell.Top,
                       ClientWidth-FRowIndicatorWidth, FRowHeight-1);
    Refresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetShowIndicator(Value : Boolean);
  {-set the show indicators option}
begin
  if Value <> FShowIndicator then begin
    FShowIndicator := Value;
    if Assigned(aeCell) then begin
      if FShowIndicator then begin
        {at design-time, automatically set width}
        if (csDesigning in ComponentState) and (FRowIndicatorWidth = 0) then
          FRowIndicatorWidth := 11;

        aeCell.SetBounds(FRowIndicatorWidth, aeCell.Top,
                         ClientWidth-FRowIndicatorWidth, FRowHeight-1);
      end else
        aeCell.SetBounds(0, aeCell.Top, ClientWidth, FRowHeight-1);
    end;
    Refresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetTextMargin(Value : Integer);
  {-set the text margin}
begin
  if (Value <> FTextMargin) and (Value >= 2) then begin
    FTextMargin := Value;
    if Assigned(aeCell) then
      aeCell.TextMargin := Value;
    Refresh;
  end;
end;

procedure TOvcBaseDbArrayEditor.UpdateRecord;
  {-force cell to update its underlying TField, returns True if valid}
begin
  if (DataLink <> nil) and DataLink.Active then
    DataLink.UpdateRecord;
end;

procedure TOvcBaseDbArrayEditor.SetUseScrollBar(Value : Boolean);
  {-set use of vertical scroll bar}
begin
  if Value <> FUseScrollBar then begin
    FUseScrollBar := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseDbArrayEditor.SetZeroAsNull(Value : Boolean);
  {-set option to store zero as null}
begin
  if Value <> FZeroAsNull then begin
    FZeroAsNull := Value;
    if Assigned(aeCell) then begin
      if aeCell is TOvcDbSimpleCell then
        TOvcDbSimpleCell(aeCell).ZeroAsNull := FZeroAsNull
      else if aeCell is TOvcDbPictureCell then
        TOvcDbPictureCell(aeCell).ZeroAsNull := FZeroAsNull
      else if aeCell is TOvcDbNumericCell then
        TOvcDbNumericCell(aeCell).ZeroAsNull := FZeroAsNull;
    end;
  end;
end;

procedure TOvcBaseDbArrayEditor.WMGetMinMaxInfo(var Msg : TWMGetMinMaxInfo);
begin
  Msg.MinMaxInfo^.ptMinTrackSize.Y := FRowHeight;
  Msg.Result := 0;
end;

procedure TOvcBaseDbArrayEditor.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;  {don't erase background}
end;

procedure TOvcBaseDbArrayEditor.WMLButtonDown(var Msg : TWMLButtonDown);
var
  P   : TPoint;
  Row : Integer;
begin
  inherited;

  {determine which row the click was in}
  P.X := Msg.Pos.X;
  P.Y := Msg.Pos.Y;
  Row := P.Y div FRowHeight;

  if (DataLink <> nil) and DataLink.Active and (DataLink.RecordCount > 0) and
     (Row <> DataLink.ActiveRecord) then begin
    aeFocusing := True;
    try
      {scroll the database as necessary}
      DataLink.DataSet.MoveBy(Row - DataLink.ActiveRecord);

      {give array editor the focus to force cell validation}
      SetFocus;

      {allow messages (if any) to get processed}
      Application.ProcessMessages;

      {exit if this focus change triggered an error}
      if Controller.ErrorPending then
        Exit;

      {update the active record number}
      aeUpdateActive;

      {give cell the focus}
      aeCell.SetFocus;
    finally
      aeFocusing := False;
    end;
  end;

  {see if the click was in an indicator region}
  if FShowIndicator and (P.X <= FRowIndicatorWidth) then
    DoOnIndicatorClick(Row);
end;

procedure TOvcBaseDbArrayEditor.WMMouseActivate(var Msg : TWMMouseActivate);
begin
  if csDesigning in ComponentState then
    Exit;

  inherited;
end;

procedure TOvcBaseDbArrayEditor.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  if csDesigning in ComponentState then
    {don't call inherited so we can bypass vcl's attempt}
    {to trap the mouse hit}
    DefaultHandler(Msg)
  else
    inherited;
end;

procedure TOvcBaseDbArrayEditor.WMSetFocus(var Msg : TWMSetFocus);
begin
  if csDesigning in ComponentState then
    Exit;

  inherited;

  if aeFocusing then
    Exit;

  {if the focus isn't comming from our child edit cell}
  if (Msg.FocusedWnd <> aeCell.Handle) then begin
    {give the edit control the focus}
    aeCell.SetFocus;
  end else
    {give the focus to the previous control}
    PostMessage(TForm(GetParentForm(Self)).Handle, WM_NEXTDLGCTL, 1, 0);
end;

procedure TOvcBaseDbArrayEditor.WMSize(var Msg : TWMSize);
begin
  inherited;

  {adjust size of edit field}
  if Assigned(aeCell) then begin
    if FShowIndicator then begin
      aeCell.Width := ClientWidth - FRowIndicatorWidth;
      aeCell.Left := FRowIndicatorWidth;
    end else
      aeCell.Width := ClientWidth;
  end;

  {set the number of managed items}
  aeUpdateNumRows;

  {adjust integral height}
  aeAdjustIntegralHeight;

  {set the number of managed items}
  aeUpdateNumRows;

  {update the active record number}
  aeUpdateActive;

  {set the scroll bar range}
  aeUpdateScrollBar;

  {move the cell to the active row Index}
  aeMoveCell(FActiveRow);
end;

procedure TOvcBaseDbArrayEditor.WMVScroll(var Msg : TWMVScroll);
var
  SI : TScrollInfo;
begin
  if (DataLink <> nil) and DataLink.Active then with DataLink do begin
    case Msg.ScrollCode of
      SB_LINEUP        :
        if FPageScroll then
          DataSet.MoveBy(-FActiveRow-1)
        else
          DataSet.MoveBy(-1);
      SB_LINEDOWN      :
        if FPageScroll then
          DataSet.MoveBy(aeNumRows-FActiveRow)
        else
          DataSet.MoveBy(+1);
      SB_PAGEUP        :
        DataSet.MoveBy(-aeNumRows);
      SB_PAGEDOWN      :
        DataSet.MoveBy(+aeNumRows);
      SB_THUMBPOSITION :
        begin
          if DataSet.IsSequenced then begin
            SI.cbSize := SizeOf(SI);
            SI.fMask := SIF_ALL;
            GetScrollInfo(Self.Handle, SB_VERT, SI);
            if SI.nTrackPos <= 1 then
              DataSet.First
            else if SI.nTrackPos >= DataSet.RecordCount then
              DataSet.Last
            else
              DataSet.RecNo := SI.nTrackPos;
          end else
          case Msg.Pos of
            0: DataSet.First;
            1: DataSet.MoveBy(-aeNumRows);
            2: Exit;
            3: DataSet.MoveBy(aeNumRows);
            4: DataSet.Last;
          end;
        end;
      SB_BOTTOM : DataSet.Last;
      SB_TOP    : DataSet.First;
    end;

    {update the active record number}
    aeUpdateActive;
  end;
  Update;
end;


{*** TOvcDbSimpleArrayEditor ***}

procedure TOvcDbSimpleArrayEditor.aeCreateEditCell;
begin
  aeCell.Free;
  aeCell := TOvcDbSimpleCell.Create(Self);

  {adjust cell size}
  if FShowIndicator then
    aeCell.SetBounds(FRowIndicatorWidth, 0, ClientWidth-FRowIndicatorWidth, FRowHeight-1)
  else
    aeCell.SetBounds(0, 0, ClientWidth, FRowHeight-1);

  {save current datalink notification event handlers}
  FCellOnActiveChange              := DataLink.OnActiveChange;
  FCellOnDataChange                := DataLink.OnDataChange;
  FCellOnEditingChange             := DataLink.OnEditingChange;
  FCellOnUpdateData                := DataLink.OnUpdateData;

  {assign new datalink event handlers}
  DataLink.OnActiveChange          := aeActiveChange;
  DataLink.OnDataChange            := aeDataChange;
  DataLink.OnEditingChange         := aeEditingChange;
  DataLink.OnUpdateData            := aeUpdateData;

  {set basic cell properties}
  aeCell.Parent                    := Self;
  aeCell.HandleNeeded;
  aeCell.Options                   := FOptions;
  aeCell.Enabled                   := Enabled;
  aeCell.EFColors.Highlight.BackColor := FHighlightColors.BackColor;
  aeCell.EFColors.Highlight.TextColor := FHighlightColors.TextColor;
  aeCell.PadChar                   := Char(FPadChar);
  aeCell.TabStop                   := TabStop;
  aeCell.TextMargin                := FTextMargin;

  {class specific property initialization}
  if Assigned(FDataSource) then begin
    TOvcDbSimpleCell(aeCell).ZeroAsNull := FZeroAsNull;
    TOvcDbSimpleCell(aeCell).DataSource := FDataSource;
    TOvcDbSimpleCell(aeCell).DataField := FDataField;
    TOvcDbSimpleCell(aeCell).UseTFieldMask := False;
    if (DataLink <> nil) and DataLink.Active then
      FFieldType := TOvcDbSimpleCell(aeCell).FieldType
    else begin
      try
        if FFieldType <> ftUnknown then
          TOvcDbSimpleCell(aeCell).FieldType := FFieldType;
      except
        FFieldType := TOvcDbSimpleCell(aeCell).FieldType;
        raise;
      end;
    end;

    if Length(FPictureMask) > 0 then
      TOvcDbSimpleCell(aeCell).PictureMask := FPictureMask[1];
    TOvcDbSimpleCell(aeCell).MaxLength := FMaxLength;
    TOvcDbSimpleCell(aeCell).DecimalPlaces := FDecimalPlaces;
  end;

  {update range limits}
  if not aeRangeLoaded then begin
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end else begin
    TLocalEF(aeCell).efRangeHi := aeRangeHi;
    TLocalEF(aeCell).efRangeLo := aeRangeLo;
  end;
end;

procedure TOvcDbSimpleArrayEditor.aeGetCellProperties;
  {-freshen our copy of the cell properties}
begin
  if not Assigned(aeCell) then
    Exit;

  FFieldType     := TOvcDbSimpleCell(aeCell).FieldType;
  FMaxLength     := TOvcDbSimpleCell(aeCell).MaxLength;
  FDecimalPlaces := TOvcDbSimpleCell(aeCell).DecimalPlaces;
  FPictureMask   := TOvcDbSimpleCell(aeCell).PictureMask;
  aeRangeHi      := TLocalEF(aeCell).efRangeHi;
  aeRangeLo      := TLocalEF(aeCell).efRangeLo;
end;

constructor TOvcDbSimpleArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set default values for persistent properties}
  FDecimalPlaces   := 0;
  FMaxLength       := 10;
  FPictureMask     := pmAnyChar;
end;


{*** TOvcDbPictureArrayEditor ***}

procedure TOvcDbPictureArrayEditor.aeCreateEditCell;
begin
  aeCell.Free;
  aeCell := TOvcDbPictureCell.Create(Self);

  {adjust cell size}
  if FShowIndicator then
    aeCell.SetBounds(FRowIndicatorWidth, 0, ClientWidth-FRowIndicatorWidth, FRowHeight-1)
  else
    aeCell.SetBounds(0, 0, ClientWidth, FRowHeight-1);

  {save current datalink notification event handlers}
  FCellOnActiveChange              := DataLink.OnActiveChange;
  FCellOnDataChange                := DataLink.OnDataChange;
  FCellOnEditingChange             := DataLink.OnEditingChange;
  FCellOnUpdateData                := DataLink.OnUpdateData;

  {assign new datalink event handlers}
  DataLink.OnActiveChange          := aeActiveChange;
  DataLink.OnDataChange            := aeDataChange;
  DataLink.OnEditingChange         := aeEditingChange;
  DataLink.OnUpdateData            := aeUpdateData;

  {set basic cell properties}
  aeCell.Parent                    := Self;
  aeCell.HandleNeeded;
  aeCell.Options                   := FOptions;
  aeCell.Enabled                   := Enabled;
  aeCell.EFColors.HighLight.BackColor := FHighlightColors.BackColor;
  aeCell.EFColors.HighLight.TextColor := FHighlightColors.TextColor;
  aeCell.PadChar                   := Char(FPadChar);
  aeCell.TabStop                   := TabStop;
  aeCell.TextMargin                := FTextMargin;

  {class specific property initialization}
  if Assigned(FDataSource) then begin
    TOvcDbPictureCell(aeCell).ZeroAsNull := FZeroAsNull;
    TOvcDbPictureCell(aeCell).DateOrTime := FDateOrTime;
    TOvcDbPictureCell(aeCell).DataSource := FDataSource;
    TOvcDbPictureCell(aeCell).DataField := FDataField;
    TOvcDbPictureCell(aeCell).Epoch := FEpoch;
    TOvcDbPictureCell(aeCell).UseTFieldMask := False;
    if (DataLink <> nil) and DataLink.Active then
      FFieldType := TOvcDbPictureCell(aeCell).FieldType
    else begin
      try
        if FFieldType <> ftUnknown then
          TOvcDbPictureCell(aeCell).FieldType := FFieldType;
      except
        FFieldType := TOvcDbPictureCell(aeCell).FieldType;
        raise;
      end;
    end;

    if Length(FPictureMask) > 0 then
      TOvcDbPictureCell(aeCell).PictureMask := FPictureMask;
    TOvcDbPictureCell(aeCell).MaxLength := FMaxLength;
    TOvcDbPictureCell(aeCell).DecimalPlaces := FDecimalPlaces;
  end;

  {update range limits}
  if not aeRangeLoaded then begin
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end else begin
    TLocalEF(aeCell).efRangeHi := aeRangeHi;
    TLocalEF(aeCell).efRangeLo := aeRangeLo;
  end;
end;

procedure TOvcDbPictureArrayEditor.aeGetCellProperties;
  {-freshend our copy of the cell properties}
begin
  if not Assigned(aeCell) then
    Exit;

  FFieldType     := TOvcDbPictureCell(aeCell).FieldType;
  FMaxLength     := TOvcDbPictureCell(aeCell).MaxLength;
  FDecimalPlaces := TOvcDbPictureCell(aeCell).DecimalPlaces;
  FPictureMask   := TOvcDbPictureCell(aeCell).PictureMask;
  aeRangeHi      := TLocalEF(aeCell).efRangeHi;
  aeRangeLo      := TLocalEF(aeCell).efRangeLo;
end;

constructor TOvcDbPictureArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set default values for persistent properties}
  FDateOrTime      := ftUseDate;
  FDecimalPlaces   := 0;
  FMaxLength       := 10;
  FPictureMask     := 'XXXXXXXXXXXXXXX';
end;


{*** TOvcDbNumericArrayEditor ***}

procedure TOvcDbNumericArrayEditor.aeCreateEditCell;
begin
  aeCell.Free;
  aeCell := TOvcDbNumericCell.Create(Self);

  {adjust cell size}
  if FShowIndicator then
    aeCell.SetBounds(FRowIndicatorWidth, 0, ClientWidth-FRowIndicatorWidth, FRowHeight-1)
  else
    aeCell.SetBounds(0, 0, ClientWidth, FRowHeight-1);

  {save current datalink notification event handlers}
  FCellOnActiveChange              := DataLink.OnActiveChange;
  FCellOnDataChange                := DataLink.OnDataChange;
  FCellOnEditingChange             := DataLink.OnEditingChange;
  FCellOnUpdateData                := DataLink.OnUpdateData;

  {assign new datalink event handlers}
  DataLink.OnActiveChange          := aeActiveChange;
  DataLink.OnDataChange            := aeDataChange;
  DataLink.OnEditingChange         := aeEditingChange;
  DataLink.OnUpdateData            := aeUpdateData;

  {set basic cell properties}
  aeCell.Parent                    := Self;
  aeCell.HandleNeeded;
  aeCell.Options                   := FOptions;
  aeCell.Enabled                   := Enabled;
  aeCell.EFColors.HighLight.BackColor := FHighlightColors.BackColor;
  aeCell.EFColors.HighLight.TextColor := FHighlightColors.TextColor;
  aeCell.PadChar                   := Char(FPadChar);
  aeCell.TabStop                   := TabStop;
  aeCell.TextMargin                := FTextMargin;

  {class specific property initialization}
  if Assigned(FDataSource) then begin
    TOvcDbNumericCell(aeCell).ZeroAsNull := FZeroAsNull;
    TOvcDbNumericCell(aeCell).DataSource := FDataSource;
    TOvcDbNumericCell(aeCell).DataField := FDataField;
    if (DataLink <> nil) and DataLink.Active then
      FFieldType := TOvcDbNumericCell(aeCell).FieldType
    else begin
      try
        if FFieldType <> ftUnknown then
          TOvcDbNumericCell(aeCell).FieldType := FFieldType;
      except
        FFieldType := TOvcDbNumericCell(aeCell).FieldType;
        raise;
      end;
    end;

    if Length(FPictureMask) > 0 then
      TOvcDbNumericCell(aeCell).PictureMask := FPictureMask;
  end;

  {update range limits}
  if not aeRangeLoaded then begin
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end else begin
    TLocalEF(aeCell).efRangeHi := aeRangeHi;
    TLocalEF(aeCell).efRangeLo := aeRangeLo;
  end;
end;

procedure TOvcDbNumericArrayEditor.aeGetCellProperties;
  {-freshend our copy of the cell properties}
begin
  if not Assigned(aeCell) then
    Exit;

  FFieldType     := TOvcDbNumericCell(aeCell).FieldType;
  FMaxLength     := TOvcDbNumericCell(aeCell).MaxLength;
  FDecimalPlaces := TOvcDbNumericCell(aeCell).DecimalPlaces;
  FPictureMask   := TOvcDbNumericCell(aeCell).PictureMask;
  aeRangeHi      := TLocalEF(aeCell).efRangeHi;
  aeRangeLo      := TLocalEF(aeCell).efRangeLo;
end;

constructor TOvcDbNumericArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set default values for persistent properties}
  FDecimalPlaces   := 0;
  FMaxLength       := 10;
  FPictureMask     := '##########';
end;


{*** TOvcDbSimpleCell ***}

constructor TOvcDbSimpleCell.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {assign edit field properties}
  ParentFont  := True;
  ParentColor := True;
  Ctl3D       := False;
  ParentCtl3D := False;
  BorderStyle := TBorderStyle(0);
  AutoSize    := False;
end;

procedure TOvcDbSimpleCell.CreateWnd;
begin
  {set controller before window is created}
  Controller := TOvcBaseDbArrayEditor(Parent).Controller;
  inherited CreateWnd;

  {assign parent event handlers to the edit cell}
  OnChange         := TOvcBaseDbArrayEditor(Parent).OnChange;
  OnClick          := TOvcBaseDbArrayEditor(Parent).OnClick;
  OnDblClick       := TOvcBaseDbArrayEditor(Parent).OnDblClick;
  OnEnter          := TOvcBaseDbArrayEditor(Parent).OnEnter;
  OnError          := TOvcBaseDbArrayEditor(Parent).OnError;
  OnExit           := TOvcBaseDbArrayEditor(Parent).OnExit;
  OnKeyDown        := TOvcBaseDbArrayEditor(Parent).OnKeyDown;
  OnKeyPress       := TOvcBaseDbArrayEditor(Parent).OnKeyPress;
  OnKeyUp          := TOvcBaseDbArrayEditor(Parent).OnKeyUp;
  OnMouseDown      := TOvcBaseDbArrayEditor(Parent).OnMouseDown;
  OnMouseMove      := TOvcBaseDbArrayEditor(Parent).OnMouseMove;
  OnMouseUp        := TOvcBaseDbArrayEditor(Parent).OnMouseUp;
  OnUserCommand    := TOvcBaseDbArrayEditor(Parent).OnUserCommand;
  OnUserValidation := TOvcBaseDbArrayEditor(Parent).OnUserValidation;
end;

procedure TOvcDbSimpleCell.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  {process keyboard commands}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  if Cmd in [ccUp, ccDown, ccFirstPage, ccLastPage, ccPrevPage, ccNextPage] then begin
    {message was handled}
    Msg.Result := 0;

    {validate cell contents if modified}
    if Modified and not ValidateSelf then
      Exit;

    case Cmd of
      ccUp        :
        Parent.Perform(WM_VSCROLL, SB_LINEUP, 0);
      ccDown      :
        Parent.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
      ccFirstPage :
        Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 0), Parent.Handle);
      ccLastPage  :
        Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 4), Parent.Handle);
      ccPrevPage  :
        Parent.Perform(WM_VSCROLL, SB_PAGEUP, 0);
      ccNextPage  :
        Parent.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
    end;
  end else
    inherited;
end;


{*** TOvcDbPictureCell ***}

constructor TOvcDbPictureCell.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {assign edit field properties}
  ParentFont  := True;
  ParentColor := True;
  Ctl3D       := False;
  ParentCtl3D := False;
  BorderStyle := TBorderStyle(0);
  AutoSize    := False;
end;

procedure TOvcDbPictureCell.CreateWnd;
begin
  {set controller before window is created}
  Controller := TOvcBaseDbArrayEditor(Parent).Controller;
  inherited CreateWnd;

  {assign parent event handlers to the edit cell}
  OnChange         := TOvcBaseDbArrayEditor(Parent).OnChange;
  OnClick          := TOvcBaseDbArrayEditor(Parent).OnClick;
  OnDblClick       := TOvcBaseDbArrayEditor(Parent).OnDblClick;
  OnEnter          := TOvcBaseDbArrayEditor(Parent).OnEnter;
  OnError          := TOvcBaseDbArrayEditor(Parent).OnError;
  OnExit           := TOvcBaseDbArrayEditor(Parent).OnExit;
  OnKeyDown        := TOvcBaseDbArrayEditor(Parent).OnKeyDown;
  OnKeyPress       := TOvcBaseDbArrayEditor(Parent).OnKeyPress;
  OnKeyUp          := TOvcBaseDbArrayEditor(Parent).OnKeyUp;
  OnMouseDown      := TOvcBaseDbArrayEditor(Parent).OnMouseDown;
  OnMouseMove      := TOvcBaseDbArrayEditor(Parent).OnMouseMove;
  OnMouseUp        := TOvcBaseDbArrayEditor(Parent).OnMouseUp;
  OnUserCommand    := TOvcBaseDbArrayEditor(Parent).OnUserCommand;
  OnUserValidation := TOvcBaseDbArrayEditor(Parent).OnUserValidation;
end;

procedure TOvcDbPictureCell.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  {process keyboard commands}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  if Cmd in [ccUp, ccDown, ccFirstPage, ccLastPage, ccPrevPage, ccNextPage] then begin
    {message was handled}
    Msg.Result := 0;

    {validate cell contents if modified}
    if Modified and not ValidateSelf then
      Exit;

    case Cmd of
      ccUp        :
        Parent.Perform(WM_VSCROLL, SB_LINEUP, 0);
      ccDown      :
        Parent.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
      ccFirstPage :
        Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 0), Parent.Handle);
      ccLastPage  :
        Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 4), Parent.Handle);
      ccPrevPage  :
        Parent.Perform(WM_VSCROLL, SB_PAGEUP, 0);
      ccNextPage  :
        Parent.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
    end;
  end else
    inherited;
end;

{*** TOvcDbNumericCell ***}

constructor TOvcDbNumericCell.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {assgin edit field properties}
  ParentFont  := True;
  ParentColor := True;
  Ctl3D       := False;
  ParentCtl3D := False;
  BorderStyle := TBorderStyle(0);
  AutoSize    := False;
end;

procedure TOvcDbNumericCell.CreateWnd;
begin
  {set controller before window is created}
  Controller := TOvcBaseDbArrayEditor(Parent).Controller;
  inherited CreateWnd;

  {assign parent event handlers to the edit cell}
  OnChange         := TOvcBaseDbArrayEditor(Parent).OnChange;
  OnClick          := TOvcBaseDbArrayEditor(Parent).OnClick;
  OnDblClick       := TOvcBaseDbArrayEditor(Parent).OnDblClick;
  OnEnter          := TOvcBaseDbArrayEditor(Parent).OnEnter;
  OnError          := TOvcBaseDbArrayEditor(Parent).OnError;
  OnExit           := TOvcBaseDbArrayEditor(Parent).OnExit;
  OnKeyDown        := TOvcBaseDbArrayEditor(Parent).OnKeyDown;
  OnKeyPress       := TOvcBaseDbArrayEditor(Parent).OnKeyPress;
  OnKeyUp          := TOvcBaseDbArrayEditor(Parent).OnKeyUp;
  OnMouseDown      := TOvcBaseDbArrayEditor(Parent).OnMouseDown;
  OnMouseMove      := TOvcBaseDbArrayEditor(Parent).OnMouseMove;
  OnMouseUp        := TOvcBaseDbArrayEditor(Parent).OnMouseUp;
  OnUserCommand    := TOvcBaseDbArrayEditor(Parent).OnUserCommand;
  OnUserValidation := TOvcBaseDbArrayEditor(Parent).OnUserValidation;
end;

procedure TOvcDbNumericCell.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  {process keyboard commands}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  if Cmd in [ccUp, ccDown, ccFirstPage, ccLastPage, ccPrevPage, ccNextPage] then begin
    {message was handled}
    Msg.Result := 0;

    {validate cell contents if modified}
    if Modified and not ValidateSelf then
      Exit;

    case Cmd of
      ccUp        :
        Parent.Perform(WM_VSCROLL, SB_LINEUP, 0);
      ccDown      :
        Parent.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
      ccFirstPage :
        Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 0), Parent.Handle);
      ccLastPage  :
        Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 4), Parent.Handle);
      ccPrevPage  :
        Parent.Perform(WM_VSCROLL, SB_PAGEUP, 0);
      ccNextPage  :
        Parent.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
    end;
  end else
    inherited;
end;



end.
