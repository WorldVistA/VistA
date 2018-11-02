{*********************************************************}
{*                  OVCTCEDT.PAS 4.08                    *}
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

unit ovctcedt;
  {-Orpheus Table Cell - Windows edit Control type}

interface

uses
  Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
  OvcBase, OvcTCmmn, OvcTCell, OvcTCStr,
  Graphics; { - for default color definition}

type
  TOvcTCStringEdit = class(TEdit)
    protected {private}
      FCell : TOvcBaseTableCell;

    protected
      procedure WMChar(var Msg : TWMKey); message WM_CHAR;
      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
      procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;

      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
  end;

  TOvcTCCustomString = class(TOvcTCBaseString)
    protected {private}
      FEdit        : TOvcTCStringEdit;
      FMaxLength   : word;
      FAutoAdvanceChar      : boolean;
      FAutoAdvanceLeftRight : boolean;

    protected
      function GetCellEditor : TControl; override;
      function GetModified : boolean;

      property AutoAdvanceChar : boolean
         read FAutoAdvanceChar write FAutoAdvanceChar;

      property AutoAdvanceLeftRight : boolean
         read FAutoAdvanceLeftRight write FAutoAdvanceLeftRight;

      property MaxLength : word
         read FMaxLength write FMaxLength;

    public
      function CreateEditControl(AOwner : TComponent) : TOvcTCStringEdit; virtual;

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

      property Modified : boolean
         read GetModified;
  end;

  TOvcTCString = class(TOvcTCCustomString)
    published
      {properties inherited from custom ancestor}
      property Access default otxDefault;
      property Adjust default otaDefault;
      property AutoAdvanceChar default False;
      property AutoAdvanceLeftRight default False;
      property Color;
      property EllipsisMode;
      property Font;
      property Hint;
      property IgnoreCR;
      property Margin default 4;
      property MaxLength default 0;
      property ShowHint default False;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;
      property UseWordWrap default False;
      property DataStringType;
      { 07/2011 AUCOS-HKK: Reimplemented 'ASCIIZStrings' for backward compatibility }
      property UseASCIIZStrings;

      {events inherited from custom ancestor}
      property OnChange;
      property OnClick;
      property OnDblClick;
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

type
  TOvcTCMemoEdit = class(TMemo)
    protected {private}
      FCell : TOvcBaseTableCell;

    protected
      procedure WMChar(var Msg : TWMKey); message WM_CHAR;
      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
      procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;

      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
  end;

  TOvcTCCustomMemo = class(TOvcTCBaseString)
    protected {private}
      FEdit        : TOvcTCMemoEdit;
      FMaxLength   : word;
      FWantReturns : boolean;
      FWantTabs    : boolean;

    protected
      function GetCellEditor : TControl; override;
      function GetModified : boolean;

      property MaxLength : word
         read FMaxLength write FMaxLength;

      property WantReturns : boolean
         read FWantReturns write FWantReturns;

      property WantTabs : boolean
         read FWantTabs write FWantTabs;

    public
      constructor Create(AOwner : TComponent); override;
      function CreateEditControl(AOwner : TComponent) : TOvcTCMemoEdit; virtual;

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

      property Modified : boolean
         read GetModified;
  end;

  TOvcTCMemo = class(TOvcTCCustomMemo)
    published
      {properties inherited from custom ancestor}
      property Access default otxDefault;
      property Adjust default otaDefault;
      property Color;
      property DataStringType;
      property EllipsisMode;
      property Font;
      property Hint;
      property IgnoreCR;
      property Margin default 4;
      property MaxLength default 0;
      property ShowHint default False;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;
      { 07/2011 AUCOS-HKK: Reimplemented 'ASCIIZStrings' for backward compatibility }
      property UseASCIIZStrings;
      property UseWordWrap default True;
      property WantReturns default False;
      property WantTabs default False;

      {events inherited from custom ancestor}
      property OnChange;
      property OnClick;
      property OnDblClick;
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

{===TOvcTCCustomString===============================================}

function TOvcTCCustomString.CreateEditControl(AOwner : TComponent) : TOvcTCStringEdit;
  begin
    Result := TOvcTCStringEdit.Create(AOwner);
  end;
{--------}
function TOvcTCCustomString.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;
{--------}
procedure TOvcTCCustomString.EditHide;
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
procedure TOvcTCCustomString.EditMove(CellRect : TRect);
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
function TOvcTCCustomString.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
function TOvcTCCustomString.GetModified : boolean;
  begin
    if Assigned(FEdit) then
         Result := FEdit.Modified
    else Result := false;
  end ;
{--------}

procedure TOvcTCCustomString.SaveEditedData(Data : pointer);
  {-Changes:
    04/2011, AB: UseASCIIZStrings/UsePString replaced by DataStringType }
  begin
    if Assigned(Data) then
      case FDataStringType of
        tstShortString: POvcShortString(Data)^ := ShortString(Copy(FEdit.Text, 1, MaxLength));
        tstPChar:       FEdit.GetTextBuf(PChar(Data), MaxLength);
        tstString:      PString(Data)^ := FEdit.Text;
      end;
  end;

{--------}
procedure TOvcTCCustomString.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                          CellRect : TRect;
                                    const CellAttr : TOvcCellAttributes;
                                          CellStyle: TOvcTblEditorStyle;
                                          Data : pointer);
  {-Changes:
    04/2011, AB: UseASCIIZStrings/UsePString replaced by DataStringType
    05/2011, AB: respect efoAutoSelect in Self.Table.Controller.EntryOptions }
  begin
    FEdit := CreateEditControl(FTable);
    with FEdit do
      begin
        if Data=nil then
          Text := ''
        else case FDataStringType of
          tstShortString: Text := string(POvcShortString(Data)^);
          tstPChar:       SetTextBuf(PChar(Data));
          tstString:      SetTextBuf(PChar(PString(Data)^))
        end;
        Color := CellAttr.caColor;
        Font := CellAttr.caFont;
        Font.Color := CellAttr.caFontColor;
        Left := CellRect.Left;
        Top := CellRect.Top;
        Width := CellRect.Right - CellRect.Left;
        Height := CellRect.Bottom - CellRect.Top;
        TabStop := false;
        CellOwner := Self;
        MaxLength := Self.MaxLength;
        Hint := Self.Hint;
        ShowHint := Self.ShowHint;
        Parent := FTable;
        BorderStyle := bsNone;
        Ctl3D := false;
        case CellStyle of
          tesBorder : BorderStyle := bsSingle;
          tes3D     : Ctl3D := true;
        end;{case}
        if Assigned(self.Table) and Assigned(self.Table.Controller) then
          AutoSelect := efoAutoSelect in Self.Table.Controller.EntryOptions;
        if not AutoSelect then
          SelStart := Length(Text);

        OnChange := Self.OnChange;
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
procedure TOvcTCCustomString.StopEditing(SaveValue : boolean; Data : pointer);
  {-Changes:
    04/2011, AB: UseASCIIZStrings/UsePString replaced by DataStringType }
  begin
    try
      if SaveValue and Assigned(FEdit) and Assigned(Data) then
        case FDataStringType of
          tstShortString: POvcShortString(Data)^ := ShortString(Copy(FEdit.Text, 1, MaxLength));
          tstPChar:       FEdit.GetTextBuf(PChar(Data), MaxLength+1);
          tstString:      PString(Data)^ := FEdit.Text;
        end;
    finally
      FEdit.Free;
      FEdit := nil;
    end;
  end;
{====================================================================}


{===TOvcTCStringEdit===============================================}
procedure TOvcTCStringEdit.WMChar(var Msg : TWMKey);
  var
    CurText : string;
  begin
    if (Msg.CharCode <> 13) and     {Enter}
       (Msg.CharCode <> 9) and      {Tab}
       (Msg.CharCode <> 27) then    {Escape}
      inherited;
    if TOvcTCCustomString(CellOwner).AutoAdvanceChar then
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
procedure TOvcTCStringEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
  end;
{--------}
procedure TOvcTCStringEdit.WMKeyDown(var Msg : TWMKey);
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
            if TOvcTCCustomString(CellOwner).AutoAdvanceLeftRight then
              begin
                GetSelection(SStart, SEnd);
                if (SStart = SEnd) and (SStart = 0) then
                  begin
                    CellOwner.SendKeyToTable(Msg);
                    GridUsedIt := true;
                  end;
              end;
          VK_RIGHT :
            if TOvcTCCustomString(CellOwner).AutoAdvanceLeftRight then
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
      inherited;
  end;
{--------}
procedure TOvcTCStringEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
  end;
{--------}
procedure TOvcTCStringEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}




{===TOvcTCCustomMemo=================================================}
constructor TOvcTCCustomMemo.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    UseWordWrap := true;
  end;
{--------}
function TOvcTCCustomMemo.CreateEditControl(AOwner : TComponent) : TOvcTCMemoEdit;
  begin
    Result := TOvcTCMemoEdit.Create(AOwner);
  end;
{--------}
function TOvcTCCustomMemo.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;
{--------}
procedure TOvcTCCustomMemo.EditHide;
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
procedure TOvcTCCustomMemo.EditMove(CellRect : TRect);
  begin
    if Assigned(FEdit) then
      begin
        with CellRect do
          SetWindowPos(FEdit.Handle, HWND_TOP,
                       Left, Top, Right-Left, Bottom-Top,
                       SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        InvalidateRect(FEdit.Handle, nil, false);
        UpdateWindow(FEdit.Handle);
      end;
  end;
{--------}
function TOvcTCCustomMemo.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
function TOvcTCCustomMemo.GetModified : boolean;
  begin
    if Assigned(FEdit) then
         Result := FEdit.Modified
    else Result := false;
  end ;
{--------}
procedure TOvcTCCustomMemo.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                           CellRect : TRect;
                                     const CellAttr : TOvcCellAttributes;
                                           CellStyle: TOvcTblEditorStyle;
                                           Data : pointer);
  begin
    FEdit := CreateEditControl(FTable);
    with FEdit do
      begin
        if Data=nil then
          Text := ''
        else case FDataStringType of
          tstShortString: Text := string(POvcShortString(Data)^);
          tstPChar:       SetTextBuf(PChar(Data));
          tstString:      SetTextBuf(PChar(PString(Data)^))
        end;
        Color := CellAttr.caColor;
        Font := CellAttr.caFont;
        Font.Color := CellAttr.caFontColor;
        MaxLength := Self.MaxLength;
        WantReturns := Self.WantReturns;
        WantTabs := Self.WantTabs;
        Left := CellRect.Left;
        Top := CellRect.Top;
        Width := CellRect.Right - CellRect.Left;
        Height := CellRect.Bottom - CellRect.Top;
        Visible := true;
        TabStop := false;
        CellOwner := Self;
        Hint := Self.Hint;
        ShowHint := Self.ShowHint;
        Parent := FTable;
        BorderStyle := bsNone;
        Ctl3D := false;
        case CellStyle of
          tesBorder : BorderStyle := bsSingle;
          tes3D     : Ctl3D := true;
        end;{case}

        OnChange := Self.OnChange;
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

procedure TOvcTCCustomMemo.StopEditing(SaveValue : boolean; Data : pointer);
  {-Changes:
    04/2011, AB: UseASCIIZStrings/UsePString replaced by DataStringType }
  begin
    try
      if SaveValue and Assigned(FEdit) and Assigned(Data) then
        case FDataStringType of
          tstShortString: POvcShortString(Data)^ := ShortString(Copy(FEdit.Text, 1, MaxLength));
          tstPChar:       FEdit.GetTextBuf(PChar(Data), MaxLength+1);
          tstString:      PString(Data)^ := FEdit.Text;
        end;
    finally
      FEdit.Free;
      FEdit := nil;
    end;
  end;

procedure TOvcTCCustomMemo.SaveEditedData(Data : pointer);
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;

{====================================================================}


{===TOvcTCMemoEdit===============================================}
procedure TOvcTCMemoEdit.WMChar(var Msg : TWMKey);
  begin
    if (not CellOwner.TableWantsTab) or
       (Msg.CharCode <> 9) then
      inherited;
  end;
{--------}
procedure TOvcTCMemoEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
  end;
{--------}
procedure TOvcTCMemoEdit.WMKeyDown(var Msg : TWMKey);
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
          VK_RETURN :
            if not WantReturns then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := true;
              end;
          VK_LEFT :
            begin
              GetSelection(SStart, SEnd);
              if (SStart = SEnd) and (SStart = 0) then
                begin
                  CellOwner.SendKeyToTable(Msg);
                  GridUsedIt := true;
                end;
            end;
          VK_RIGHT :
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
      inherited;
  end;
{--------}
procedure TOvcTCMemoEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
  end;
{--------}
procedure TOvcTCMemoEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;

end.
