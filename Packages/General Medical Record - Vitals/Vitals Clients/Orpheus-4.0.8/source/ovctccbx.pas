{*********************************************************}
{*                  OVCTCCBX.PAS 4.08                    *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{$WARN SYMBOL_DEPRECATED OFF}

unit ovctccbx;
  {-Orpheus Table Cell - check combo box type}

interface

uses
  UITypes, Types, Themes, Windows, SysUtils, Messages, Graphics, Classes, Controls,
  Forms, StdCtrls, OvcBase, OvcMisc, OvcTCmmn, OvcTCell, OvcTCStr;

type
  TOvcTCComboBoxState = (otlbsUp, otlbsDown);

type
  TOvcTCComboBoxEditOld = class(TCustomComboBox)
    protected {private}

      FCell     : TOvcBaseTableCell;

      EditField : HWnd;
      PrevEditWndProc : pointer;
      NewEditWndProc  : pointer;


    protected

      procedure EditWindowProc(var Msg : TMessage);
      function  FilterWMKEYDOWN(var Msg : TWMKey) : boolean;

      procedure CMRelease(var Message: TMessage); message CM_RELEASE;

      procedure WMChar(var Msg : TWMKey); message WM_CHAR;
      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
      procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;


    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      procedure CreateWnd; override;

      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
  end;

  TOvcTCComboEdit = class(TEdit)        //introduced by SZ
  protected
    FCell : TOvcBaseTableCell;
    FFilter: string;

    function SelectItem(const AnItem: string): Boolean;
  protected
    procedure WMChar(var Msg : TWMKey); message WM_CHAR;
    procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
    procedure KeyPress(var Key: Char); override;

    property CellOwner : TOvcBaseTableCell
      read FCell write FCell;
  end;

  TOvcTCComboBoxEdit = class(TCustomControl)
  private
    FItemIndex: Integer;
    FCell: TOvcBaseTableCell;
    FMaxLength: Integer;
    FItems: TStrings;
    FSorted: Boolean;
    FStyle: TComboBoxStyle;
    FDropDownCount: Integer;
    FOnChange: TNotifyEvent;
    FOnDrawItem: TDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;
    FOnDropDown: TNotifyEvent;
    FCellAttr: TOvcCellAttributes;
    FCloseTime: Cardinal;
    FInUpdate: Boolean;
    FListBox: TListBox;
    FDropDown: TOvcPopupWindow;
    FIsDroppedDown: Boolean;
    FEditControl: TOvcTCComboEdit;
    FAutoComplete: Boolean;
    FAutoDropDown: Boolean;
    FLastTime: Cardinal;
    FAutoCompleteDelay: Cardinal;
    FFilter: string;
    procedure SetItemIndex(const Value: Integer);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetMaxLength(const Value: Integer);
    procedure SetSorted(const Value: Boolean);
    procedure SetStyle(const Value: TComboBoxStyle);
    procedure SetCellAttr(const Value: TOvcCellAttributes);
    procedure ShowDropDown;
    procedure ShowEdit;
    procedure DropDownClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxClick(Sender: TObject);
    procedure ListBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    class procedure DrawText(Canvas: TCanvas; const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean; AText: string);
    procedure DrawBackground(Canvas: TCanvas; const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean);
    class procedure DrawButton(Canvas: TCanvas; const CellRect: TRect);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure UpdateEditPosition;
    procedure EditChanged(Sender: TObject);
    procedure SetAutoDropDown(const Value: Boolean);
  protected
    procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
    procedure WMChar(var Msg : TWMKey); message WM_CHAR;
    function SelectItem(const AnItem: string): Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure Paint; override;
    procedure DestroyWindowHandle; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CMRelease(var Message: TMessage); message CM_RELEASE;
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
    property CellAttr: TOvcCellAttributes read FCellAttr write SetCellAttr;

    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property CellOwner : TOvcBaseTableCell read FCell write FCell;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property Style: TComboBoxStyle read FStyle write SetStyle default csDropDown;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property Items: TStrings read FItems write SetItems;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;

    property AutoCompleteDelay: Cardinal read FAutoCompleteDelay write FAutoCompleteDelay default 500;
    property AutoComplete: Boolean read FAutoComplete write FAutoComplete default True;
    property AutoDropDown: Boolean read FAutoDropDown write SetAutoDropDown;
    property Canvas;
  end;

  TOvcTCCustomComboBox = class(TOvcTCBaseString)
  protected {private}

    {property fields - even size}
    FDropDownCount        : Integer;
    FEdit                 : TOvcTCComboBoxEdit;
    FItems                : TStrings;
    FMaxLength            : Word;

    {property fields - odd size}
    FStyle                : TComboBoxStyle;
    FAutoAdvanceChar      : Boolean;
    FAutoAdvanceLeftRight : Boolean;
    FHideButton           : Boolean;
    FSaveStringValue      : boolean;
    FSorted               : Boolean;
    FShowArrow            : Boolean;
    FUseRunTimeItems      : Boolean;

    {events}
    FOnChange             : TNotifyEvent;
    FOnDropDown           : TNotifyEvent;
    FOnDrawItem           : TDrawItemEvent;
    FOnMeasureItem        : TMeasureItemEvent;
  private
    FTextHint: string;
    procedure SetTextHint(const Value: string);


  protected

    function GetCellEditor : TControl; override;

    procedure SetShowArrow(Value : Boolean);
    procedure SetItems(I : TStrings);
    procedure SetSorted(S : boolean);

    procedure DrawArrow(Canvas   : TCanvas;
                  const CellRect : TRect;
                  const CellAttr : TOvcCellAttributes);
    procedure DrawButton(Canvas   : TCanvas;
                   const CellRect : TRect);

    procedure tcPaint(TableCanvas : TCanvas;
                const CellRect    : TRect;
                      RowNum      : TRowNum;
                      ColNum      : TColNum;
                const CellAttr    : TOvcCellAttributes;
                      Data        : pointer); override;


    {properties}
    property AutoAdvanceChar : boolean
       read FAutoAdvanceChar write FAutoAdvanceChar;
    property AutoAdvanceLeftRight : boolean
       read FAutoAdvanceLeftRight write FAutoAdvanceLeftRight;
    property DropDownCount : Integer
       read FDropDownCount write FDropDownCount;
    property HideButton : Boolean
       read FHideButton write FHideButton;
    property Items : TStrings
       read FItems write SetItems;
    property MaxLength : word
       read FMaxLength write FMaxLength;
    property SaveStringValue : boolean
       read FSaveStringValue write FSaveStringValue;
    property Sorted : boolean
       read FSorted write SetSorted;
    property ShowArrow : Boolean
       read FShowArrow write SetShowArrow;
    property Style : TComboBoxStyle
       read FStyle write FStyle;
    property UseRunTimeItems : boolean
       read FUseRunTimeItems write FUseRunTimeItems;
    property TextHint: string read FTextHint write SetTextHint;

    {events}
    property OnChange : TNotifyEvent
       read FOnChange write FOnChange;
    property OnDropDown: TNotifyEvent
       read FOnDropDown write FOnDropDown;
    property OnDrawItem: TDrawItemEvent
       read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent
       read FOnMeasureItem write FOnMeasureItem;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function CreateEditControl : TOvcTCComboBoxEdit; virtual;

    function  EditHandle : THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect : TRect); override;

    procedure SaveEditedData(Data : pointer); override;
    procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                           CellRect : TRect;
                     const CellAttr : TOvcCellAttributes;
                           CellStyle: TOvcTblEditorStyle;
                           Data : pointer); override;
    procedure StopEditing(SaveValue : boolean;
                          Data : pointer); override;
  end;

  TOvcTCComboBox = class(TOvcTCCustomComboBox)
    published
      property AcceptActivationClick default True;
      property Access default otxDefault;
      property Adjust default otaDefault;
      property AutoAdvanceChar default False;
      property AutoAdvanceLeftRight default False;
      property Color;
      property DropDownCount default 8;
      property Font;
      property HideButton default False;
      property Hint;
      property Items;
      property ShowHint default False;
      property Margin default 4;
      property MaxLength default 0;
      property SaveStringValue default False;
      property ShowArrow default False;
      property Sorted default False;
      property Style default csDropDown;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;
      property TextHint;
      property UseRunTimeItems default False;

      {events inherited from custom ancestor}
      property OnChange;
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnDrawItem;
      property OnDropDown;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMeasureItem;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;


var
  OvcComboBoxBitmap      : TBitmap;
  OvcComboBoxButtonWidth : Integer;

implementation

uses
  Math,
  StrUtils;

function ThemesEnabled: Boolean; inline;
begin
  Result := StyleServices.Enabled;
end;

function ThemeServices: TCustomStyleServices; inline;
begin
  Result := StyleServices;
end;

const
  ComboBoxHeight = 24;

var
  ComboBoxResourceCount : Integer = 0;

{===TOvcTCComboBoxEditOld================================================}
constructor TOvcTCComboBoxEditOld.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    NewEditWndProc := MakeObjectInstance(EditWindowProc);
  end;
{--------}
destructor TOvcTCComboBoxEditOld.Destroy;
  begin
    if (Style = csDropDown) or (Style = csSimple) then
      SetWindowLong(EditField, GWL_WNDPROC, NativeInt(PrevEditWndProc));
    FreeObjectInstance(NewEditWndProc);
    inherited Destroy;
  end;
{--------}
procedure TOvcTCComboBoxEditOld.CreateWnd;
  begin
    inherited CreateWnd;

    if (Style = csDropDown) or (Style = csSimple) then
      begin
        EditField := GetWindow(Handle, GW_CHILD);
        if (Style = csSimple) then
          EditField := GetWindow(EditField, GW_HWNDNEXT);
        PrevEditWndProc := pointer(GetWindowLong(EditField, GWL_WNDPROC));
        SetWindowLong(EditField, GWL_WNDPROC, NativeInt(NewEditWndProc));
      end;
  end;
{--------}
procedure TOvcTCComboBoxEditOld.EditWindowProc(var Msg : TMessage);
  var
    GridUsedIt : boolean;
    KeyMsg : TWMKey absolute Msg;
  begin
    GridUsedIt := false;
    if (Msg.Msg = WM_KEYDOWN) then
      GridUsedIt := FilterWMKEYDOWN(KeyMsg)
    else if (Msg.Msg = WM_CHAR) then
      if (KeyMsg.CharCode = 9) or
         (KeyMsg.CharCode = 13) or
         (KeyMsg.CharCode = 27) then
        GridUsedIt := true;
    if not GridUsedIt then
      with Msg do
        Result := CallWindowProc(PrevEditWndProc, EditField, Msg, wParam, lParam);
  end;
{--------}
function  TOvcTCComboBoxEditOld.FilterWMKEYDOWN(var Msg : TWMKey) : boolean;
  procedure GetSelection(var S, E : word);
    type
      LH = packed record L, H : word; end;
    var
      GetSel : Integer;
    begin
      GetSel := SendMessage(EditField, EM_GETSEL, 0, 0);
      S := LH(GetSel).L;
      E := LH(GetSel).H;
    end;
  var
    GridReply    : TOvcTblKeyNeeds;
    SStart, SEnd : word;
    GridUsedIt   : boolean;
    PassIton     : boolean;
  begin
    GridUsedIt := false;
    GridReply := otkDontCare;
    if (CellOwner <> nil) then
      GridReply := CellOwner.FilterTableKey(Msg);
    case GridReply of
      otkMustHave :
        begin
          CellOwner.SendKeyToTable(Msg);
          GridUsedIt := true;
        end;
      otkWouldLike :
        begin
          PassItOn := false;
          case Msg.CharCode of
            VK_LEFT :
              begin
                case Style of
                  csDropDown, csSimple :
                    if TOvcTCCustomComboBox(CellOwner).AutoAdvanceLeftRight then
                      begin
                        GetSelection(SStart, SEnd);
                        if (SStart = SEnd) and (SStart = 0) then
                          PassItOn := true;
                      end;
                else
                  PassItOn := true;
                end;{case}
              end;
            VK_RIGHT :
              begin
                case Style of
                  csDropDown, csSimple :
                    if TOvcTCCustomComboBox(CellOwner).AutoAdvanceLeftRight then
                      begin
                        GetSelection(SStart, SEnd);
                        if ((SStart = SEnd) or (SStart = 0)) and
                           (SEnd = GetTextLen) then
                          PassItOn := true;
                      end;
                else
                  PassItOn := true;
                end;{case}
              end;
          end;{case}
          if PassItOn then
            begin
              CellOwner.SendKeyToTable(Msg);
              GridUsedIt := true;
            end;
        end;
    end;{case}
    Result := GridUsedIt;
  end;
{--------}


  procedure TOvcTCComboBoxEditOld.CMRelease(var Message: TMessage);
  begin
    Free;
  end;

  procedure TOvcTCComboBoxEditOld.WMChar(var Msg : TWMKey);
  var
    CurText : string;
  begin
    inherited;
    if TOvcTCCustomComboBox(CellOwner).AutoAdvanceChar then
      begin
        CurText := Text;
        if (length(CurText) >= MaxLength) then
          begin
            FillChar(Msg, sizeof(Msg), 0);
            with Msg do
              begin
                Msg := WM_KEYDOWN;
                CharCode := VK_RIGHT;
              end;
            CellOwner.SendKeyToTable(Msg);
          end;
      end;
  end;
{--------}
procedure TOvcTCComboBoxEditOld.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
  end;
{--------}
procedure TOvcTCComboBoxEditOld.WMKeyDown(var Msg : TWMKey);
  var
    GridUsedIt : boolean;
  begin
    if (Style <> csDropDown) and (Style <> csSimple) then
      begin
        GridUsedIt := FilterWMKEYDOWN(Msg);
        if not GridUsedIt then
          inherited;
      end
    else
      inherited;
  end;
{--------}
procedure TOvcTCComboBoxEditOld.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    {ComboBox posts cbn_killfocus message to table}
  end;
{--------}
procedure TOvcTCComboBoxEditOld.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}


{===TOvcTCCustomComboBox=============================================}
constructor TOvcTCCustomComboBox.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    FItems := TStringList.Create;
    FDropDownCount := 8;
    if (ComboBoxResourceCount = 0) then
      begin
        OvcComboBoxBitmap := TBitMap.Create;
        OvcComboBoxBitmap.Handle := LoadBaseBitMap('ORTCCOMBOARROW');
        OvcComboBoxButtonWidth := OvcComboBoxBitmap.Width + 11;
      end;
    inc(ComboBoxResourceCount);
    FAcceptActivationClick := true;
    FShowArrow := False;
    FHideButton := False;
  end;
{--------}
destructor TOvcTCCustomComboBox.Destroy;
  begin
    FItems.Free;
    dec(ComboBoxResourceCount);
    if (ComboBoxResourceCount = 0) then
      OvcComboBoxBitmap.Free;
    inherited Destroy;
  end;
{--------}
function TOvcTCCustomComboBox.CreateEditControl : TOvcTCComboBoxEdit;
  begin
    Result := TOvcTCComboBoxEdit.Create(FTable);
  end;
{--------}
procedure TOvcTCCustomComboBox.DrawArrow(Canvas   : TCanvas;
                                   const CellRect : TRect;
                                   const CellAttr : TOvcCellAttributes);
  var
    ArrowDim : Integer;
    X, Y     : Integer;
    LeftPoint, RightPoint, BottomPoint : TPoint;
    Width    : integer;
    Height   : integer;
    R        : TRect;
  begin
    R := CellRect;
    R.Left := R.Right - OvcComboBoxButtonWidth;
    Width := R.Right - R.Left;
    Height := R.Bottom - R.Top;
    with Canvas do
      begin
        Brush.Color := CellAttr.caColor;
        FillRect(R);
        Pen.Color := CellAttr.caFont.Color;
        Brush.Color := Pen.Color;
        ArrowDim := MinI(Width, Height) div 3;
        X := R.Left + (Width - ArrowDim) div 2;
        Y := R.Top + (Height - ArrowDim) div 2;
        LeftPoint := Point(X, Y);
        RightPoint := Point(X+ArrowDim, Y);
        BottomPoint := Point(X+(ArrowDim div 2), Y+ArrowDim);
        Polygon([LeftPoint, RightPoint, BottomPoint]);
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.DrawButton(Canvas       : TCanvas;
                                    const CellRect     : TRect);
  var
    EffCellWidth : Integer;
    Wd, Ht       : Integer;
    TopPixel     : Integer;
    BotPixel     : Integer;
    LeftPixel    : Integer;
    RightPixel   : Integer;
    SrcRect      : TRect;
    DestRect     : TRect;
  Details: TThemedElementDetails;
  BtnRect: TRect;
  begin
    {Calculate the effective cell width (the cell width less the size
     of the button)}
    EffCellWidth := CellRect.Right - CellRect.Left - OvcComboBoxButtonWidth;

    {Calculate the black border's rectangle}
    LeftPixel := CellRect.Left + EffCellWidth;
    RightPixel := CellRect.Right - 1;
    TopPixel := CellRect.Top + 1;
    BotPixel := CellRect.Bottom - 1;

    if ThemeServices.ThemesEnabled then
    begin
      Details := ThemeServices.GetElementDetails(tcDropDownButtonNormal);
      BtnRect := CellRect;
      BtnRect.Left := CellRect.Right - OvcComboBoxButtonWidth;
      ThemeServices.DrawElement(canvas.handle, Details, BtnRect);
    end
    else
    {Paint the button}
    with Canvas do
      begin
        {FIRST: paint the black border around the button}
        Pen.Color := clBlack;
        Pen.Width := 1;
        Brush.Color := clBtnFace;
        {Note: Rectangle excludes the Right and bottom pixels}
        Rectangle(LeftPixel, TopPixel, RightPixel, BotPixel);
        {SECOND: paint the highlight border on left/top sides}
        {decrement drawing area}
        inc(TopPixel);
        dec(BotPixel);
        inc(LeftPixel);
        dec(RightPixel);
        {Note: PolyLine excludes the end points of a line segment,
               but since the end points are generally used as the
               starting point of the next we must adjust for it.}
        Pen.Color := clBtnHighlight;
        PolyLine([Point(RightPixel-1, TopPixel),
                  Point(LeftPixel, TopPixel),
                  Point(LeftPixel, BotPixel)]);
        {THIRD: paint the highlight border on bottom/right sides}
        Pen.Color := clBtnShadow;
        PolyLine([Point(LeftPixel, BotPixel-1),
                  Point(RightPixel-1, BotPixel-1),
                  Point(RightPixel-1, TopPixel-1)]);
        inc(TopPixel);
        dec(BotPixel);
        inc(LeftPixel);
        dec(RightPixel);
        PolyLine([Point(LeftPixel, BotPixel-1),
                  Point(RightPixel-1, BotPixel-1),
                  Point(RightPixel-1, TopPixel-1)]);
        {THIRD: paint the arrow bitmap}
        Wd := OvcComboBoxBitmap.Width;
        Ht := OvcComboBoxBitmap.Height;
        SrcRect := Rect(0, 0, Wd, Ht);
        with DestRect do
          begin
            Left := CellRect.Left + EffCellWidth + 5;
            Top := CellRect.Top +
                   ((CellRect.Bottom - CellRect.Top - Ht) div 2);
            Right := Left + Wd;
            Bottom := Top + Ht;
          end;
        BrushCopy(DestRect, OvcComboBoxBitmap, SrcRect, clSilver);
      end;
  end;
{--------}
function TOvcTCCustomComboBox.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;
{--------}
procedure TOvcTCCustomComboBox.EditHide;
  begin
    if Assigned(FEdit) then
      with FEdit do
        begin
          SetWindowPos(FEdit.Handle, HWND_TOP,
                       0, 0, 0, 0,
                       SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        end;
  end;
{--------}
procedure TOvcTCCustomComboBox.EditMove(CellRect : TRect);
  var
    EditHandle : HWND;
    NewTop : Integer;
  begin
    if Assigned(FEdit) then
      begin
        EditHandle := FEdit.Handle;
        with CellRect do
          begin
            NewTop := Top;
            if FEdit.Ctl3D then
              InflateRect(CellRect, -1, -1);
            SetWindowPos(EditHandle, HWND_TOP,
                         Left, NewTop, Right-Left, Bottom - Top {SZ: was ComboBoxHeight},
                         SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
          end;
        InvalidateRect(EditHandle, nil, false);
        UpdateWindow(EditHandle);
      end;
  end;

function TOvcTCCustomComboBox.GetCellEditor : TControl;
begin
  Result := FEdit;
end;

procedure TOvcTCCustomComboBox.tcPaint(TableCanvas : TCanvas;
                                 const CellRect    : TRect;
                                       RowNum      : TRowNum;
                                       ColNum      : TColNum;
                                 const CellAttr    : TOvcCellAttributes;
                                       Data        : pointer);
var
  ItemRec   : PCellComboBoxInfo absolute Data;
  ActiveRow : TRowNum;
  ActiveCol : TColNum;
  R         : TRect;
  S         : String;
  OurItems  : TStrings;
  LCellAttr : TOvcCellAttributes;
begin
  LCellAttr := CellAttr; // make a local copy of the attributes (needed for the TextHint)
  {Note: Data is a pointer to an integer, or to an integer and a
         string. The first is used for drop down ListBoxes
         (only) and the latter with simple and drop down combo boxes.

         SZ: 02.02.2010 replaced shortstring with string for Unicode support

         AB: 18.04.2011 The inherited method needs a pointer to a string to work;
             using PChar(S) leads to an exception. (Changed PChar(S) to @S in
             'inherited tcPaint...') }

  {If the cell is invisible let the ancestor do all the work}
  if (LCellAttr.caAccess = otxInvisible) then begin
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, nil);
    Exit;
  end;

  {If we have valid data, get the string to display from the stringlist
   or from the Data pointer. }
  S := '';
  if (Data <> nil) then
  begin
    if UseRunTimeItems then
      OurItems := ItemRec^.RTItems
    else
      OurItems := Items;
    if (0 <= ItemRec^.Index) and (ItemRec^.Index < OurItems.Count) then
      S := OurItems[ItemRec^.Index]
    else if (Style = csDropDown) or (Style = csSimple) then
    begin
      if UseRunTimeItems then
        S := ItemRec^.RTSt
      else
        S := ItemRec^.St;
    end;

    // if nothing is displayed, display TextHint instead
    // TextHint from ItemRec
    if (S = '') and (ItemRec^.TextHint <> '') then
    begin
      S := ItemRec^.TextHint;
      LCellAttr.caFontColor := clGray;
    end;
    // if still no hint available, try using the TextHint TOvcTCComboBox
    if (S = '') and (FTextHint <> '') then
    begin
      S := FTextHint;
      LCellAttr.caFontColor := clGray;
    end;
  end
  {Otherwise, mock up a string in design mode.}
  else if (csDesigning in ComponentState) and (Items.Count > 0) then
    S := Items[RowNum mod Items.Count];

  ActiveRow := tcRetrieveTableActiveRow;
  ActiveCol := tcRetrieveTableActiveCol;
  {Calculate the effective cell width (the cell width less the size of the button)}
  R := CellRect;
  dec(R.Right, OvcComboBoxButtonWidth);
  if (ActiveRow = RowNum) and (ActiveCol = ColNum) or LCellAttr.caAlwaysShowDropDown then begin
    if FHideButton then begin
      {let ancestor paint the text}
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, @S);
    end else begin
      {Paint the string in the restricted rectangle}
      inherited tcPaint(TableCanvas, R, RowNum, ColNum, LCellAttr, @S);
      {Paint the button on the right side}
      DrawButton(TableCanvas, CellRect);
    end;
  end else if FShowArrow then begin
    {paint the string in the restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, LCellAttr, @S);
    {Paint the arrow on the right side}
    DrawArrow(TableCanvas, CellRect, LCellAttr);
  end else
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, @S);

(*
  {Are we just displaying a button on the active cell?}
  if not FHideButton then begin
    {If we are not the active cell, let the ancestor do the painting (we only
     paint a button when the cell is the active one)}
    if (ActiveRow <> RowNum) or (ActiveCol <> ColNum) then begin
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, @S);
      Exit;
    end;
    {Calculate the effective cell width (the cell width less the size
     of the button)}
    R := CellRect;
    dec(R.Right, OvcComboBoxButtonWidth);
    {Paint the string in this restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, LCellAttr, @S);
    {Paint the button on the right side}
    DrawButton(TableCanvas, CellRect);
  end else if FShowArrow then begin
    {Calculate the effective cell width (the cell width less the size
     of the button)}
    R := CellRect;
    dec(R.Right, OvcComboBoxButtonWidth);
    {Paint the string in this restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, LCellAttr, @S);
    {Paint the arrow on the right side}
    DrawArrow(TableCanvas, CellRect, LCellAttr);
  end else
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, @S);
*)
end;

procedure TOvcTCCustomComboBox.SaveEditedData(Data : pointer);
  var
    ItemRec : PCellComboBoxInfo absolute Data;
  begin
    if Assigned(Data) then
      begin
        ItemRec^.Index := FEdit.ItemIndex;
        if (Style = csDropDown) or (Style = csSimple) or SaveStringValue then
          begin
            if (ItemRec^.Index = -1) then
              if UseRunTimeItems then
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.RTSt, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(FEdit.Text, 1, MaxLength)
                {$IFEND}
              else
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.St, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.St := Copy(FEdit.Text, 1, MaxLength)
                {$IFEND}
            else
              if UseRunTimeItems then
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.RTSt, Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength)
                {$IFEND}
              else
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.St, Copy(Items[ItemRec^.Index], 1, MaxLength));
                {$ELSE}
                ItemRec^.St := Copy(Items[ItemRec^.Index], 1, MaxLength);
                {$IFEND}
          end;
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.SetItems(I : TStrings);
  begin
    FItems.Assign(I);
    if Sorted then
      TStringList(FItems).Sorted := true;
    tcDoCfgChanged;
  end;

procedure TOvcTCCustomComboBox.SetShowArrow(Value : Boolean);
begin
  if (Value <> FShowArrow) then begin
    FShowArrow := Value;
    tcDoCfgChanged;
  end;
end;

procedure TOvcTCCustomComboBox.SetSorted(S : boolean);
  begin
    if (S <> Sorted) then
      begin
        FSorted := S;
        if Sorted then
          TStringList(Items).Sorted := True;
        tcDoCfgChanged;
      end;
  end;

procedure TOvcTCCustomComboBox.SetTextHint(const Value: string);
begin
  FTextHint := Value;
  if Assigned(FTable) then
    FTable.Invalidate;
end;

{--------}
procedure TOvcTCCustomComboBox.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                           CellRect : TRect;
                                     const CellAttr : TOvcCellAttributes;
                                           CellStyle: TOvcTblEditorStyle;
                                           Data : pointer);
  var
    ItemRec : PCellComboBoxInfo absolute Data;
  begin
    FEdit := CreateEditControl;
//    with FEdit do
      begin
        FEdit.Color := CellAttr.caColor;
        FEdit.Ctl3D := false;
        case CellStyle of
          tes3D     : FEdit.Ctl3D := true;
        end;{case}
        FEdit.Left := CellRect.Left;
        FEdit.Top := CellRect.Top;
        FEdit.Width := CellRect.Right - CellRect.Left;
        FEdit.Height := CellRect.Bottom - CellRect.Top;
        FEdit.Font := CellAttr.caFont;
        FEdit.Font.Color := CellAttr.caFontColor;
        FEdit.MaxLength := Self.MaxLength;
        FEdit.Hint := Self.Hint;
        FEdit.ShowHint := Self.ShowHint;
        FEdit.Visible := true;
        FEdit.CellOwner := Self;
        FEdit.TabStop := false;
        FEdit.Parent := FTable;
        FEdit.DropDownCount := Self.DropDownCount;
        FEdit.Sorted := Self.Sorted;
        FEdit.Style := Self.Style;
        if UseRunTimeItems then
          FEdit.Items := ItemRec^.RTItems
        else
          FEdit.Items := Self.Items;
        if Data = nil then
          FEdit.ItemIndex := -1
        else
          begin
            FEdit.ItemIndex := ItemRec^.Index;
            if (FEdit.ItemIndex = -1) and
               ((FEdit.Style = csDropDown) or (FEdit.Style = csSimple)) then
              if UseRunTimeItems then
                {$IF defined(CBuilder)}
                FEdit.Text := StrPas(ItemRec^.RTSt)
                {$ELSE}
                FEdit.Text := ItemRec^.RTSt
                {$IFEND}
              else
                {$IF defined(CBuilder)}
                FEdit.Text := StrPas(ItemRec^.St)
                {$ELSE}
                FEdit.Text := ItemRec^.St;
                {$IFEND}
          end;

//        if Assigned(self.Table) and Assigned(self.Table.Controller) then
//          FEdit.AutoSelect := efoAutoSelect in Self.Table.Controller.EntryOptions;
//        if not AutoSelect then
//          SelStart := Length(Text);

        FEdit.OnChange := Self.OnChange;
        FEdit.OnClick := Self.OnClick;
        FEdit.OnDblClick := Self.OnDblClick;
        FEdit.OnDragDrop := Self.OnDragDrop;
        FEdit.OnDragOver := Self.OnDragOver;
        FEdit.OnDrawItem := Self.OnDrawItem;
        FEdit.OnDropDown := Self.OnDropDown;
        FEdit.OnEndDrag := Self.OnEndDrag;
        FEdit.OnEnter := Self.OnEnter;
        FEdit.OnExit := Self.OnExit;
        FEdit.OnKeyDown := Self.OnKeyDown;
        FEdit.OnKeyPress := Self.OnKeyPress;
        FEdit.OnKeyUp := Self.OnKeyUp;
        FEdit.OnMeasureItem := Self.OnMeasureItem;
        FEdit.OnMouseDown := Self.OnMouseDown;
        FEdit.OnMouseMove := Self.OnMouseMove;
        FEdit.OnMouseUp := Self.OnMouseUp;

        FEdit.ShowEdit;
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.StopEditing(SaveValue : boolean;
                                          Data : pointer);
  var
    ItemRec : PCellComboBoxInfo absolute Data;
  begin
    if SaveValue and Assigned(Data) then
      begin
        ItemRec^.Index := FEdit.ItemIndex;
        if (Style = csDropDown) or (Style = csSimple) or SaveStringValue then
          begin
            if (ItemRec^.Index = -1) then
              if UseRunTimeItems then
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.RTSt, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(FEdit.Text, 1, MaxLength)
                {$IFEND}
              else
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.St, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.St := Copy(FEdit.Text, 1, MaxLength)
                {$IFEND}
            else
              if UseRunTimeItems then
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.RTSt, Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength)
                {$IFEND}
              else
                {$IF defined(CBuilder)}
                StrPCopy(ItemRec^.St, Copy(Items[ItemRec^.Index], 1, MaxLength));
                {$ELSE}
                ItemRec^.St := Copy(Items[ItemRec^.Index], 1, MaxLength);
                {$IFEND}
          end;
      end;
    PostMessage(FEdit.Handle, CM_RELEASE, 0, 0);
    {FEdit.Free;}
    FEdit := nil;
  end;
{====================================================================}

{ TOvcTCComboBoxEdit }

procedure TOvcTCComboBoxEdit.CMRelease(var Message: TMessage);
begin
  Free;
end;

procedure TOvcTCComboBoxEdit.CMTextChanged(var Message: TMessage);
begin
  case Style of
    csDropDown: if Assigned(FEditControl) then
                  begin
                    FEditControl.Text := Caption; FItemIndex := FItems.IndexOf(Text);
                  end;
    csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable: ItemIndex := FItems.IndexOf(Text);
  end;
end;

constructor TOvcTCComboBoxEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Width := 145;
  Height := 21;
  DropDownCount := 8;
  ControlStyle := ControlStyle + [csOpaque];
  FCellAttr.caAccess := otxDefault;
  FCellAttr.caAdjust := otaDefault;
  FCellAttr.caColor := clWindow; // Background Color
  FCellAttr.caFont := Font;
  FCellAttr.caFontColor := clBtnText;
  FCellAttr.caFontHiColor := clHighlightText;
  FCellAttr.caTextStyle := tsFlat;
  FDropDown := TOvcPopupWindow.CreateNew(Self);
  FDropDown.CloseAction := caHide;
  FDropDown.OnClose := DropDownClose;
  FDropDown.Color := clBlack;
  FItems := TStringList.Create;
  FListBox := TListBox.Create(FDropDown);
  FListBox.OnClick := ListBoxClick;
  FListBox.Align := alClient;
  FListBox.AlignWithMargins := True; // Align with Margins = 1 so we get a black border
  FListBox.Margins.Left := 1;
  FListBox.Margins.Top:= 1;
  FListBox.Margins.Right := 1;
  FListBox.Margins.Bottom := 1;
  FListBox.BorderStyle := bsNone;
  FListBox.Parent := FDropDown;
//  FListBox.WantDblClicks := False;
  FListBox.OnMouseMove := ListBoxMouseMove;
  FDropDown.ActiveControl := FListBox;
  TabStop := True;
  Style := csDropDown;
  AutoComplete := True;
  AutoCompleteDelay := 500;
//  autodropdown := true;
end;

procedure TOvcTCComboBoxEdit.CreateWnd;
begin
  inherited;
  if Style = csDropDown then
  begin
    FEditControl := TOvcTCComboEdit.Create(Self);
    FEditControl.CellOwner := CellOwner;
    FEditControl.BorderStyle := bsNone;
    FEditControl.Parent := Self;
    FEditControl.OnChange := EditChanged;
    FEditControl.AutoSelect := True;
    UpdateEditPosition;
  end;
end;

destructor TOvcTCComboBoxEdit.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TOvcTCComboBoxEdit.DestroyWindowHandle;
begin
  FreeAndNil(FEditControl);
  inherited;
end;

procedure TOvcTCComboBoxEdit.DrawBackground(Canvas: TCanvas;
  const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean);
var
  R: TRect;
begin
  with Canvas do
  begin
    Brush.Color := CellAttr.caColor;
    Pen.Color := clBlack;
    Rectangle(CellRect);
    R := CellRect;
    Inc(R.Top, 2);
    Inc(R.Left, 2);
    Dec(R.Bottom, 2);
    Dec(R.Right, 1 + OvcComboBoxButtonWidth);
    if Focused then
    begin
      Brush.Color := clHighlight;
      FillRect(R);
      Brush.Color := CellAttr.caColor;
      DrawFocusRect(R);
    end;
  end;
end;

class procedure TOvcTCComboBoxEdit.DrawButton(Canvas: TCanvas;
  const CellRect: TRect);
var
  EffCellWidth : Integer;
  Wd, Ht       : Integer;
  TopPixel     : Integer;
  BotPixel     : Integer;
  LeftPixel    : Integer;
  RightPixel   : Integer;
  SrcRect      : TRect;
  DestRect     : TRect;
  Details: TThemedElementDetails;
  BtnRect: TRect;
begin
  {Calculate the effective cell width (the cell width less the size
   of the button)}
  EffCellWidth := CellRect.Right - CellRect.Left - OvcComboBoxButtonWidth;

  {Calculate the black border's rectangle}
  LeftPixel := CellRect.Left + EffCellWidth;
  RightPixel := CellRect.Right - 1;
  TopPixel := CellRect.Top + 1;
  BotPixel := CellRect.Bottom - 1;

  if ThemesEnabled then
  begin
    Details := ThemeServices.GetElementDetails(tcDropDownButtonNormal);
    BtnRect := CellRect;
    BtnRect.Left := CellRect.Right - OvcComboBoxButtonWidth;
    ThemeServices.DrawElement(canvas.handle, Details, BtnRect);
  end
  else
  {Paint the button}
  with Canvas do
    begin
      {FIRST: paint the black border around the button}
      Pen.Color := clBlack;
      Pen.Width := 1;
      Brush.Color := clBtnFace;
      {Note: Rectangle excludes the Right and bottom pixels}
      Rectangle(LeftPixel, TopPixel, RightPixel, BotPixel);
      {SECOND: paint the highlight border on left/top sides}
      {decrement drawing area}
      inc(TopPixel);
      dec(BotPixel);
      inc(LeftPixel);
      dec(RightPixel);
      {Note: PolyLine excludes the end points of a line segment,
             but since the end points are generally used as the
             starting point of the next we must adjust for it.}
      Pen.Color := clBtnHighlight;
      PolyLine([Point(RightPixel-1, TopPixel),
                Point(LeftPixel, TopPixel),
                Point(LeftPixel, BotPixel)]);
      {THIRD: paint the highlight border on bottom/right sides}
      Pen.Color := clBtnShadow;
      PolyLine([Point(LeftPixel, BotPixel-1),
                Point(RightPixel-1, BotPixel-1),
                Point(RightPixel-1, TopPixel-1)]);
      inc(TopPixel);
      dec(BotPixel);
      inc(LeftPixel);
      dec(RightPixel);
      PolyLine([Point(LeftPixel, BotPixel-1),
                Point(RightPixel-1, BotPixel-1),
                Point(RightPixel-1, TopPixel-1)]);
      {THIRD: paint the arrow bitmap}
      Wd := OvcComboBoxBitmap.Width;
      Ht := OvcComboBoxBitmap.Height;
      SrcRect := Rect(0, 0, Wd, Ht);
      with DestRect do
        begin
          Left := CellRect.Left + EffCellWidth + 5;
          Top := CellRect.Top +
                 ((CellRect.Bottom - CellRect.Top - Ht) div 2);
          Right := Left + Wd;
          Bottom := Top + Ht;
        end;
      BrushCopy(DestRect, OvcComboBoxBitmap, SrcRect, clSilver);
    end;
end;

class procedure TOvcTCComboBoxEdit.DrawText(Canvas: TCanvas;
  const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean;
  AText: string);
var
  S: string;
  R: TRect;
begin
  R := CellRect;
  Inc(R.Top, 2);
  Inc(R.Left, 2);
  Dec(R.Bottom, 2);
  Dec(R.Right, 1 + OvcComboBoxButtonWidth);

  S := AText;
  Canvas.Brush.Style := bsClear;
  Canvas.Font := CellAttr.caFont;
  if Focused then
    Canvas.Font.Color := CellAttr.caFontHiColor
  else
    Canvas.Font.Color := CellAttr.caFontColor;
  Canvas.TextRect(R, S, [tfVerticalCenter, tfEndEllipsis, tfSingleLine]);
end;

procedure TOvcTCComboBoxEdit.DropDownClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FIsDroppedDown := False;
  FCloseTime := GetTickCount;
  Invalidate;
  if Assigned(FEditControl) then
    Windows.SetFocus(FEditControl.Handle);
end;

procedure TOvcTCComboBoxEdit.EditChanged(Sender: TObject);
begin
  Text := FEditControl.Text;
end;

procedure TOvcTCComboBoxEdit.ListBoxClick(Sender: TObject);
begin
  ItemIndex := FListBox.ItemIndex;
  FDropDown.Close;
  FCloseTime := 0;
end;

procedure TOvcTCComboBoxEdit.ListBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  I := FListBox.ItemAtPos(Point(x, y), True);
  if I <> -1 then
    if not FListBox.Selected[I] then
      FListBox.Selected[I] := True;
end;

procedure TOvcTCComboBoxEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssDouble in Shift then
    Exit;

  Windows.SetFocus(Handle);
  if (Button = mbLeft) then
    if not FIsDroppedDown and (GetTickCount - FCloseTime > GetDoubleClickTime) then
    begin
      if (FStyle in [csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable]) or ((FStyle = csDropDown) and (X > ClientWidth - OvcComboBoxButtonWidth)) then
        ShowDropDown
      else
        ShowEdit;
    end
    else
      FCloseTime := 0;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TOvcTCComboBoxEdit.Paint;
var
  LText: string;
  LState: TOwnerDrawState;
begin
  inherited;

  LText := '';

  case Style of
    csDropDown: ;
//    csSimple: ;
    csDropDownList: if InRange(ItemIndex, 0, FItems.Count - 1) then LText := FItems[ItemIndex];
//    csOwnerDrawFixed: ;
//    csOwnerDrawVariable: ;
  end;

  DrawBackground(Canvas, ClientRect, FCellAttr, Focused and not FIsDroppedDown and not Assigned(FEditControl));
  if not Assigned(FEditControl) then
  begin
    if Style in [csOwnerDrawFixed, csOwnerDrawVariable] then
    begin
       // (odSelected, odGrayed, odDisabled, odChecked, odFocused, odDefault, odHotLight, odInactive, odNoAccel, odNoFocusRect, odReserved1, odReserved2, odComboBoxEdit)
      LState := [];
      if Focused then
        Include(LState, odFocused);
      if ItemIndex <> -1 then
        Include(LState, odSelected);
      if not Enabled then
        Include(LState, odDisabled);
      if Assigned(FOnDrawItem) then
        FOnDrawItem(Self, ItemIndex, ClientRect, LState);
    end
    else
      DrawText(Canvas, ClientRect, FCellAttr, Focused and not FIsDroppedDown, LText);
  end;
  DrawButton(Canvas, ClientRect);
end;

function TOvcTCComboBoxEdit.SelectItem(const AnItem: string): Boolean;
var
  Idx: Integer;
  ValueChange: Boolean;
  I: Integer;
begin
  if Length(AnItem) = 0 then
  begin
    Result := False;
    ItemIndex := -1;
//    Change;
    exit;
  end;
  Idx := -1;
  for I := 0 to Items.Count - 1 do
    if AnsiStartsText(AnItem, Items[I]) then
    begin
      Idx := I;
      Break;
    end;

  Result := (Idx <> -1);
  if not Result then exit;
  ValueChange := Idx <> ItemIndex;
//  if AutoCloseUp and (Items.IndexOf(AnItem) <> -1) then
//    SendMessage(Handle, CB_SHOWDROPDOWN, 0, 0);
//  SendMessage(Handle, CB_SETCURSEL, Idx, 0);
//  if (Style in [csDropDown, csSimple]) then
//  begin
//    Text := AnItem + Copy(ComboBox.Items[Idx], Length(AnItem) + 1, MaxInt);
//    SendMessage(Handle, EM_SETSEL, Length(AnItem), Length(Text));
//  end
//  else
  begin
    ItemIndex := Idx;
    FFilter := AnItem;
  end;
  if ValueChange then
  begin
    Click;
//    Select;
  end;
end;

procedure TOvcTCComboBoxEdit.SetAutoDropDown(const Value: Boolean);
begin
  FAutoDropDown := Value;
end;

procedure TOvcTCComboBoxEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  UpdateEditPosition;
end;

procedure TOvcTCComboBoxEdit.SetCellAttr(const Value: TOvcCellAttributes);
begin
  FCellAttr := Value;
  Invalidate;
end;

procedure TOvcTCComboBoxEdit.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TOvcTCComboBoxEdit.SetItemIndex(const Value: Integer);
begin
  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
  if (Style = csDropDown) and Assigned(FEditControl) then
  begin
    if InRange(Value, 0, FItems.Count - 1) then
      FEditControl.Text := FItems[Value]
    else
      FEditControl.Text := '';
  end;
  Invalidate;
end;

procedure TOvcTCComboBoxEdit.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TOvcTCComboBoxEdit.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
end;

procedure TOvcTCComboBoxEdit.SetSorted(const Value: Boolean);
begin
  FSorted := Value;
end;

procedure TOvcTCComboBoxEdit.SetStyle(const Value: TComboBoxStyle);
begin
  FStyle := Value;
  RecreateWnd;
end;

procedure TOvcTCComboBoxEdit.ShowDropDown;
var
  P: TPoint;
  I: Integer;
  Monitor: TMonitor;
begin
  UpdateEditPosition;
  P := ClientToScreen(Point(0, Height));
  case Style of
    csDropDown, csSimple, csDropDownList: FListBox.Style := lbStandard;
    csOwnerDrawFixed: FListBox.Style := lbOwnerDrawFixed;
    csOwnerDrawVariable: FListBox.Style := lbOwnerDrawVariable;
  end;

  FListBox.OnDrawItem := FOnDrawItem;
  FListBox.OnMeasureItem := FOnMeasureItem;
  FListBox.Items.BeginUpdate;
  FInUpdate := True;
  try
    FListBox.Items.Clear;
    for I := 0 to FItems.Count - 1 do
    begin
      FListBox.Items.Add(FItems[I]);
    end;
    FListBox.ItemIndex := ItemIndex;
  finally
    FInUpdate := False;
    FListBox.Items.EndUpdate;
  end;
  FDropDown.Width := Self.Width;
  FDropDown.Height := FListBox.ItemHeight * MinI(FItems.Count, FDropDownCount) + 2;
  // keep dropdown within screen
  Monitor := Screen.MonitorFromPoint(P);
  if Assigned(Monitor) and (P.Y + FDropDown.Height > Monitor.WorkareaRect.Bottom) then
  begin
    P := ClientToScreen(Point(0, 0));
    P.Y := P.Y - FDropDown.Height;
    if P.Y < Monitor.Top then
      P.Y := Monitor.Top;
  end;

  FDropDown.Popup(P);
  FIsDroppedDown := True;
end;

procedure TOvcTCComboBoxEdit.ShowEdit;
begin
  if Assigned(FEditControl) then
  begin
    FEditControl.MaxLength := MaxLength;
    Windows.SetFocus(FEditControl.Handle); // FEditControl.SetFocus;
    UpdateEditPosition;
  end;
end;

procedure TOvcTCComboBoxEdit.UpdateEditPosition;
begin
  if HandleAllocated and Assigned(FEditControl) then
  begin
    FEditControl.SetBounds(2, 1 + (ClientHeight div 2) - (FEditControl.Height div 2), ClientWidth - 3 - OvcComboBoxButtonWidth, FEditControl.Height);
  end;
end;

procedure TOvcTCComboBoxEdit.WMChar(var Msg: TWMKey);
var
//  StartPos, EndPos: Integer;
//  OldText: string;
  SaveText: string;
//  LastByte: Integer;
  LMsg : TMSG;

  Key: Char;
begin
  inherited;

  if not AutoComplete then exit;
  if (Style in [csDropDown, csSimple]) then Exit;

   if GetTickCount - FLastTime >= FAutoCompleteDelay then
      FFilter := '';
    FLastTime := GetTickCount;

  Key := Char(Msg.CharCode);

  case Ord(Key) of
    VK_ESCAPE: exit;
//    VK_TAB:
//      if FAutoDropDown and FIsDroppedDown then
//        DroppedDown := False;
    VK_BACK:
      begin
        while ByteType(FFilter, Length(FFilter)) = mbTrailByte do
          Delete(FFilter, Length(FFilter), 1);
        Delete(FFilter, Length(FFilter), 1);
//        Change;
      end;
  else // case
    SaveText := FFilter + Key;
    if FAutoDropDown and not FIsDroppedDown then
      ShowDropDown; // DroppedDown := True;

    if IsLeadChar(Key) then
    begin
      if PeekMessage(LMsg, Handle, 0, 0, PM_NOREMOVE) and (LMsg.Message = WM_CHAR) then
      begin
        if SelectItem(SaveText + Key) then
        begin
          PeekMessage(LMsg, Handle, 0, 0, PM_REMOVE);
        end;
      end;
    end
    else
      SelectItem(SaveText);
  end; // case
end;

procedure TOvcTCComboBoxEdit.WMKeyDown(var Msg: TWMKey);
begin
  inherited;
  if Msg.CharCode = VK_F4 then
    ShowDropDown
  else if Assigned(FEditControl) then
  begin
    UpdateEditPosition;
    Windows.SetFocus(FEditControl.Handle);
    PostMessage(FEditControl.Handle, WM_KEYDOWN, Msg.CharCode, Msg.KeyData);
  end;
end;

procedure TOvcTCComboBoxEdit.WMKillFocus(var Msg: TWMKillFocus);
begin

end;

procedure TOvcTCComboBoxEdit.WMSetFocus(var Msg: TWMSetFocus);
begin
//  ShowEdit;
  if Assigned(CellOwner) then
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
end;

{ TOvcTCComboEdit }

procedure TOvcTCComboEdit.KeyPress(var Key: Char);
var
  ComboBox: TOvcTCComboBoxEdit;

  function HasSelectedText(var StartPos, EndPos: Integer): Boolean;
  begin
    if ComboBox.Style in [csDropDown, csSimple] then
    begin
      SendGetIntMessage(Handle, EM_GETSEL, StartPos, EndPos);
      Result := EndPos > StartPos;
    end
    else
      Result := False;
  end;

  procedure DeleteSelectedText(const StartPos, EndPos: DWORD);
  var
     OldText: String;
  begin
    OldText := Text;
    Delete(OldText, StartPos + 1, EndPos - StartPos);
//    SendMessage(Handle, CB_SETCURSEL, WPARAM(-1), 0);
    Text := OldText;
    SendMessage(Handle, EM_SETSEL, StartPos, StartPos);
  end;

var
  StartPos, EndPos: Integer;
  OldText: string;
  SaveText: string;
  LastByte: Integer;
  Msg : TMSG;

begin
  ComboBox := Parent as TOvcTCComboBoxEdit;

  inherited KeyPress(Key);

  if not ComboBox.AutoComplete then exit;
  FFilter := Text;

  case Ord(Key) of
    VK_ESCAPE: exit;
//    VK_TAB:
//      if ComboBox.AutoDropDown and DroppedDown then
//        DroppedDown := False;
    VK_BACK:
      begin
        if HasSelectedText(StartPos, EndPos) then
          DeleteSelectedText(StartPos, EndPos)
        else
          if (ComboBox.Style in [csDropDown, csSimple]) and (Length(Text) > 0) then
          begin
            SaveText := Text;
            LastByte := StartPos;
            while ByteType(SaveText, LastByte) = mbTrailByte do Dec(LastByte);
            OldText := Copy(SaveText, 1, LastByte - 1);
//            SendMessage(Handle, EM_SETCURSEL, WPARAM(-1), 0);
            Text := OldText + Copy(SaveText, EndPos + 1, MaxInt);
            SendMessage(Handle, EM_SETSEL, LastByte - 1, LastByte - 1);
            FFilter := Text;
          end
          else
          begin
            while ByteType(FFilter, Length(FFilter)) = mbTrailByte do
              Delete(FFilter, Length(FFilter), 1);
            Delete(FFilter, Length(FFilter), 1);
          end;
        Key := #0;
        Change;
      end;
  else // case
    HasSelectedText(StartPos, EndPos); // This call sets StartPos and EndPos
    if (ComboBox.Style < csDropDownList) and (StartPos < Length(FFilter))  then
      SaveText := Copy(FFilter, 1, StartPos) + Key + Copy(FFilter, EndPos+1, Length(FFilter))
    else
      SaveText := FFilter + Key;
    if ComboBox.AutoDropDown and not ComboBox.FIsDroppedDown then
      ComboBox.ShowDropDown; // DroppedDown := True;

    if IsLeadChar(Key) then
    begin
      if PeekMessage(Msg, Handle, 0, 0, PM_NOREMOVE) and (Msg.Message = WM_CHAR) then
      begin
        if SelectItem(SaveText + Char(Msg.wParam)) then
        begin
          PeekMessage(Msg, Handle, 0, 0, PM_REMOVE);
          Key := #0
        end;
      end;
    end
    else
    if SelectItem(SaveText) then
      Key := #0
  end; // case
end;

function TOvcTCComboEdit.SelectItem(const AnItem: string): Boolean;
var
  Idx: Integer;
  ValueChange: Boolean;
  ComboBox: TOvcTCComboBoxEdit;
  I: Integer;
begin
  ComboBox := Parent as TOvcTCComboBoxEdit;

  if Length(AnItem) = 0 then
  begin
    Result := False;
    ComboBox.ItemIndex := -1;
    Change;
    exit;
  end;
  Idx := -1;
  for I := 0 to ComboBox.Items.Count - 1 do
    if AnsiStartsText(AnItem, ComboBox.Items[I]) then
    begin
      Idx := I;
      Break;
    end;

  Result := (Idx <> -1);
  if not Result then exit;
  ValueChange := Idx <> ComboBox.ItemIndex;
//  if AutoCloseUp and (Items.IndexOf(AnItem) <> -1) then
//    SendMessage(Handle, CB_SHOWDROPDOWN, 0, 0);
//  SendMessage(Handle, CB_SETCURSEL, Idx, 0);
  if (ComboBox.Style in [csDropDown, csSimple]) then
  begin
    Text := AnItem + Copy(ComboBox.Items[Idx], Length(AnItem) + 1, MaxInt);
    SendMessage(Handle, EM_SETSEL, Length(AnItem), Length(Text));
  end
  else
  begin
    ComboBox.ItemIndex := Idx;
    FFilter := AnItem;
  end;
  if ValueChange then
  begin
    Click;
//    Select;
  end;
end;

procedure TOvcTCComboEdit.WMChar(var Msg: TWMKey);
//var
//  CurText : string;
begin
  if (Msg.CharCode <> 13) and     {Enter}
     (Msg.CharCode <> 9) and      {Tab}
     (Msg.CharCode <> 27) then    {Escape}
    inherited;

{  if (CellOwner as TOvcTCComboEdit).AutoAdvanceChar then
    begin
      CurText := Text;
      if (length(CurText) >= MaxLength) then
        begin
          FillChar(Msg, sizeof(Msg), 0);
          with Msg do
            begin
              Msg := WM_KEYDOWN;
              CharCode := VK_RIGHT;
            end;
          CellOwner.SendKeyToTable(Msg);
        end;
    end;  }
end;

procedure TOvcTCComboEdit.WMGetDlgCode(var Msg: TMessage);
begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
end;

procedure TOvcTCComboEdit.WMKeyDown(var Msg: TWMKey);
  procedure GetSelection(var S, E : word);
    type
      LH = packed record L, H : word; end;
    var
      GetSel : Integer;
    begin
      GetSel := SendMessage(Handle, EM_GETSEL, 0, 0);
      S := LH(GetSel).L;
      E := LH(GetSel).H;
    end;

var
  GridReply : TOvcTblKeyNeeds;
  GridUsedIt : boolean;
  SStart, SEnd : word;
begin
  GridUsedIt := false;
  GridReply := otkDontCare;
  if (CellOwner <> nil) then
    GridReply := CellOwner.FilterTableKey(Msg);
  case GridReply of
    otkMustHave :
      begin
        CellOwner.SendKeyToTable(Msg);
        GridUsedIt := true;
      end;
    otkWouldLike :
      case Msg.CharCode of
        VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN :
          begin
            CellOwner.SendKeyToTable(Msg);
            GridUsedIt := true;
          end;
        VK_LEFT :
          if (CellOwner as TOvcTCCustomComboBox).AutoAdvanceLeftRight then
            begin
              GetSelection(SStart, SEnd);
              if (SStart = SEnd) and (SStart = 0) then
                begin
                  CellOwner.SendKeyToTable(Msg);
                  GridUsedIt := true;
                end;
            end;
        VK_RIGHT :
          if (CellOwner as TOvcTCCustomComboBox).AutoAdvanceLeftRight then
            begin
              GetSelection(SStart, SEnd);
              if ((SStart = SEnd) or (SStart = 0)) and (SEnd = GetTextLen) then
                begin
                  CellOwner.SendKeyToTable(Msg);
                  GridUsedIt := true;
                end;
            end;
      end;
  end;{case}

  if not GridUsedIt then
  begin
    if Msg.CharCode = VK_F4 then
    begin
      PostMessage(Parent.Handle, WM_KEYDOWN, Msg.CharCode, Msg.KeyData);
      GridUsedIt := True;
    end;
  end;

  if not GridUsedIt then
    inherited;
end;

procedure TOvcTCComboEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
end;

procedure TOvcTCComboEdit.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
end;

end.
