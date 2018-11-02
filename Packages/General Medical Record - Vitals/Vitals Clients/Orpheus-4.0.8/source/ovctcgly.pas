{*********************************************************}
{*                  OVCTCGLY.PAS 4.08                    *}
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
{* Roman Kassebaum                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcgly;
  {-Orpheus Table Cell - Glyph type}

interface

uses
  Windows, SysUtils, Messages, Graphics, Classes, Controls,
  OvcTCmmn, OvcTCell, OvcTGRes, OvcTCBmp;

type
  TOvcTCGlyphEdit = class(TCustomControl)
    protected {private}

      FValue  : Integer;
      FCell   : TOvcBaseTableCell;
      FRow    : TRowNum;
      FCol    : TColNum;
      FCellAttr : TOvcCellAttributes;


    protected

      procedure SetValue(V : integer);

      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
      procedure WMLButtonDown(var Msg : TWMMouse); message WM_LBUTTONDOWN;
      procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;


    public
      constructor Create(AOwner : TComponent); override;
      procedure Paint; override;

      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
      property Value : integer
         read FValue write SetValue;
  end;

  TOvcTCCustomGlyph = class(TOvcTCBaseBitMap)
    protected {private}

      FCellGlyphs : TOvcCellGlyphs;
      FEdit       : TOvcTCGlyphEdit;


    protected

      function GetCellEditor : TControl; override;
      procedure SetCellGlyphs(CBG : TOvcCellGlyphs);

      procedure GlyphsHaveChanged(Sender : TObject);

      {painting}
      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;


      {properties}
      property CellGlyphs : TOvcCellGlyphs
        read FCellGlyphs write SetCellGlyphs;

    public
      {create/destroy}
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      function CreateEditControl : TOvcTCGlyphEdit; virtual;

      function  CanAssignGlyphs(CBG : TOvcCellGlyphs) : boolean; virtual;

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

  TOvcTCGlyph = class(TOvcTCCustomGlyph)
    published
      {properties inherited from custom ancestor}
      property AcceptActivationClick default True;
      property Access default otxDefault;
      property Adjust default otaDefault;
      property CellGlyphs;
      property Color;
      property Hint;
      property Margin default 4;
      property ShowHint default False;
      property Table;
      property TableColor default True;

      {events inherited from custom ancestor}
      property OnClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;

implementation


{===TOvcTCCustomGlyph creation/destruction===========================}
constructor TOvcTCCustomGlyph.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    FCellGlyphs := TOvcCellGlyphs.Create;
    FCellGlyphs.OnCfgChanged := GlyphsHaveChanged;
    FAcceptActivationClick := true;
  end;
{--------}
destructor TOvcTCCustomGlyph.Destroy;
  begin
    FCellGlyphs.Free;
    inherited Destroy;
  end;
{--------}
function  TOvcTCCustomGlyph.CanAssignGlyphs(CBG : TOvcCellGlyphs) : boolean;
  begin
    Result := true;
  end;
{--------}
function TOvcTCCustomGlyph.CreateEditControl : TOvcTCGlyphEdit;
  begin
    Result := TOvcTCGlyphEdit.Create(FTable);
  end;
{--------}
function TOvcTCCustomGlyph.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
procedure TOvcTCCustomGlyph.GlyphsHaveChanged(Sender : TObject);
  begin
    tcDoCfgChanged;
  end;
{--------}
procedure TOvcTCCustomGlyph.SetCellGlyphs(CBG : TOvcCellGlyphs);
  begin
    if CanAssignGlyphs(CBG) then
      FCellGlyphs.Assign(CBG);
  end;
{====================================================================}


{===TOvcTCCustomGlyph painting================================}
procedure TOvcTCCustomGlyph.tcPaint(TableCanvas : TCanvas;
                              const CellRect    : TRect;
                                    RowNum      : TRowNum;
                                    ColNum      : TColNum;
                              const CellAttr    : TOvcCellAttributes;
                                    Data        : pointer);
  var
    B : ^integer absolute Data;
    BitMapInfo : TCellBitMapInfo;
  begin
    {set up a bitmap info record}
    with BitMapInfo do
      begin
        BM := FCellGlyphs.BitMap;
        ActiveCount := FCellGlyphs.ActiveGlyphCount;
        Count := FCellGlyphs.GlyphCount;
        if (Data = nil) then
          begin
            if (csDesigning in ComponentState) then
              Index := (RowNum mod ActiveCount)      {for testing purposes}
            else
              Index := -1
          end
        else
          Index := B^;
        if (Index >= ActiveCount) then
          Index := pred(ActiveCount);
      end;
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @BitMapInfo);
  end;
{====================================================================}


{===TOvcTCCustomGlyph editing========================================}
function TOvcTCCustomGlyph.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;
{--------}
procedure TOvcTCCustomGlyph.EditHide;
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
procedure TOvcTCCustomGlyph.EditMove(CellRect : TRect);
  var
    EditHandle : HWND;
  begin
    if Assigned(FEdit) then
      begin
        EditHandle := FEdit.Handle;
        with CellRect do
          SetWindowPos(EditHandle, HWND_TOP,
                       Left, Top, Right-Left, Bottom-Top,
                       SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        InvalidateRect(EditHandle, nil, false);
        UpdateWindow(EditHandle);
      end;
  end;
{--------}
procedure TOvcTCCustomGlyph.SaveEditedData(Data : pointer);
  begin
    if Assigned(Data) then
      Integer(Data^) := FEdit.Value;
  end;
{--------}
procedure TOvcTCCustomGlyph.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                           CellRect : TRect;
                                     const CellAttr : TOvcCellAttributes;
                                           CellStyle: TOvcTblEditorStyle;
                                           Data : pointer);
  begin
    FEdit := CreateEditControl;
    with FEdit do
      begin
        CellOwner := Self;
        if Data = nil then
          Value := 0
        else
          Value := Integer(Data^);
        FRow := RowNum;
        FCol := ColNum;
        FCellAttr := CellAttr;
        Color := CellAttr.caColor;
        Ctl3D := false;
        case CellStyle of
          tes3D     : Ctl3D := true;
        end;{case}
        Left := CellRect.Left;
        Top := CellRect.Top;
        Width := CellRect.Right - CellRect.Left;
        Height := CellRect.Bottom - CellRect.Top;
        Hint := Self.Hint;
        ShowHint := Self.ShowHint;
        Parent := FTable;
        Visible := true;
        TabStop := false;

        OnClick := Self.OnClick;
        OnDblClick := Self.OnDblClick;
        OnDragDrop := Self.OnDragDrop;
        OnDragOver := Self.OnDragOver;
        OnEndDrag := Self.OnEndDrag;
        OnEnter := Self.OnEnter;
        OnExit := Self.OnExit;
        OnKeyDown := Self.OnKeyDown;
        OnKeyPress := Self.OnKeyPress;
        OnKeyUp := Self.OnKeyUp;
        OnMouseDown := Self.OnMouseDown;
        OnMouseMove := Self.OnMouseMove;
        OnMouseUp := Self.OnMouseUp;
      end;
  end;
{--------}
procedure TOvcTCCustomGlyph.StopEditing(SaveValue : boolean;
                                        Data : pointer);
var
  pEdit: TOvcTCGlyphEdit;
  begin
    if FEdit <> nil then begin
      if SaveValue and Assigned(Data) then
        Integer(Data^) := FEdit.Value;
      pEdit := FEdit;
      FEdit := nil;
      pEdit.Free;
    end;
  end;
{====================================================================}


{---TOvcTCGlyphEdit===========================================}
constructor TOvcTCGlyphEdit.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    ControlStyle := ControlStyle - [csDoubleClicks];
  end;
{--------}
procedure TOvcTCGlyphEdit.Paint;
  var
    R   : TRect;
  begin
    Windows.GetClientRect(Handle, R);
    FCell.Paint(Canvas, R, FRow, FCol, FCellAttr, @FValue);
  end;
{--------}
procedure TOvcTCGlyphEdit.SetValue(V : integer);
  begin
    if (V <> FValue) then
      begin
        if (V < 0) then
          V := 0
        else if (V >= TOvcTCGlyph(CellOwner).CellGlyphs.ActiveGlyphCount) then
          V := TOvcTCGlyph(CellOwner).CellGlyphs.ActiveGlyphCount;
        FValue := V;
        if HandleAllocated then
          begin
            Invalidate;
            Update;
          end;
      end;
  end;
{--------}
procedure TOvcTCGlyphEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    Msg.Result := DLGC_WANTARROWS;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
  end;
{--------}
procedure TOvcTCGlyphEdit.WMKeyDown(var Msg : TWMKey);
  var
    GridReply : TOvcTblKeyNeeds;
    GridUsedIt : boolean;
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
        if Msg.CharCode <> VK_SPACE then
          begin
            CellOwner.SendKeyToTable(Msg);
            GridUsedIt := true;
          end;
    end;{case}

    if not GridUsedIt then
      begin
        inherited;
        if (Msg.CharCode = VK_SPACE) then
          begin
            inc(FValue);
            if (FValue >= TOvcTCGlyph(FCell).FCellGlyphs.ActiveGlyphCount) then
              FValue := 0;
            Invalidate;
            Update;

            if ((@TOvcTCGlyph(FCell).FOnClick) <> nil) then
              OnClick(Self);
          end
        else if (Msg.CharCode = VK_BACK) then
          begin
            dec(FValue);
            if (FValue < 0) then
              FValue := pred(TOvcTCGlyph(FCell).FCellGlyphs.ActiveGlyphCount);
            Invalidate;
            Update;

            if ((@TOvcTCGlyph(FCell).FOnClick) <> nil) then
              OnClick(Self);
          end;
      end;
  end;
{--------}
procedure TOvcTCGlyphEdit.WMLButtonDown(var Msg : TWMMouse);
  begin
    inc(FValue);
    if (FValue >= TOvcTCGlyph(FCell).FCellGlyphs.ActiveGlyphCount) then
      FValue := 0;
    Invalidate;
    Update;

    inherited;
  end;
{--------}
procedure TOvcTCGlyphEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
  end;
{--------}
procedure TOvcTCGlyphEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}


end.
