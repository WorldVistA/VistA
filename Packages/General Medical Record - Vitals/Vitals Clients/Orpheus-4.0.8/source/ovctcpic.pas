{*********************************************************}
{*                  OVCTCPIC.PAS 4.08                    *}
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
{*   Roman Kassebaum                                                          *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcpic;
  {-Orpheus Table Cell - Picture field type}

interface

uses
  Windows, SysUtils, Messages, Classes, Controls,
  OvcEF, OvcPF, OvcTCmmn, OvcTCell, OvcTCBEF, OvcUser,
  Graphics; { - for default color definitions}

type
  {The editor class for TOvcTCPictureField cell components}
  TOvcTCPictureFieldEdit = class(TOvcPictureField)
    protected {private}
      FCell : TOvcBaseTableCell;

    protected
      procedure efMoveFocusToNextField; override;
      procedure efMoveFocusToPrevField; override;

      procedure WMChar(var Msg : TWMKey); message WM_CHAR;
      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
      procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;

    public
      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
  end;

  {The picture field cell component class}
  TOvcTCCustomPictureField = class(TOvcTCBaseEntryField)
    protected
      function GetCellEditor : TControl; override;
      function GetDataType : TPictureDataType;
      function GetEpoch : integer;
      function GetPictureMask : string;
      function GetFloatScale : SmallInt;
      function GetUserData: TOvcUserData;

      procedure SetDataType(DT : TPictureDataType);
      procedure SetEpoch(E : integer);
      procedure SetPictureMask(const PM : string);
      procedure SetFloatScale(FS : SmallInt);
      procedure SetUserData(UD : TOvcUserData);

      property DataType : TPictureDataType
         read GetDataType write SetDataType;

      property Epoch : integer
         read GetEpoch write SetEpoch;

      property PictureMask : string
         read GetPictureMask write SetPictureMask;
      { 06/2011 AB: New property 'FloatScale' }
      property FloatScale : SmallInt
        read GetFloatScale write SetFloatScale;

    public
      function CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField; override;

      { 06/2011 AB: New property 'UserData' to gain access to FEdit's/FDisplayEdit's
                Userdata-property}
      property UserData :  TOvcUserData
        read GetUserData write SetUserData;
  end;

  TOvcTCPictureField = class(TOvcTCCustomPictureField)
    published
      {inherited from ancestor}
      property DataType default pftString;
      property PictureMask;
      property MaxLength default 15;

      property Access default otxDefault;
      property Adjust default otaDefault;
      property CaretIns;
      property CaretOvr;
      property Color;
      property ControlCharColor default clRed;
      property DataStringType;
      property DecimalPlaces default 0;
      property EFColors;
      property EllipsisMode;
      property Epoch default 0;
      property FloatScale default 0;
      property Font;
      property Hint;
      property Margin default 4;
      property Options default [efoCaretToEnd];
      property PadChar default ' ';
      property PasswordChar default '*';
      property RangeHi stored False;
      property RangeLo stored False;
      property ShowHint default False;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextMargin default 2;
      property TextStyle default tsFlat;

      {events inherited from custom ancestor}
      property OnChange;
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnEnter;
      property OnError;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
      property OnUserCommand;
      property OnUserValidation;
  end;


implementation

uses
  Forms;

type
  TPForm = class(TCustomForm);

{===TOvcTCCustomPictureField=========================================}
function TOvcTCCustomPictureField.CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField;
  begin
    Result := TOvcTCPictureFieldEdit.Create(AOwner);
    TOvcTCPictureFieldEdit(Result).CellOwner := Self;
  end;
{--------}
function TOvcTCCustomPictureField.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
function TOvcTCCustomPictureField.GetDataType : TPictureDataType;
  begin
    if Assigned(FEdit) then
      Result := TOvcTCPictureFieldEdit(FEdit).DataType
    else
      Result := pftString;
  end;
{--------}
function TOvcTCCustomPictureField.GetEpoch : integer;
  begin
    if Assigned(FEdit) then
      Result := TOvcTCPictureFieldEdit(FEdit).Epoch
    else
      Result := 0;
  end;
{--------}
function TOvcTCCustomPictureField.GetPictureMask : string;
  begin
    if Assigned(FEdit) then
      Result := TOvcTCPictureFieldEdit(FEdit).PictureMask
    else
      Result := 'XXXXXXXXXXXXXXX';
  end;
{--------}
function TOvcTCCustomPictureField.GetFloatScale : SmallInt;
  begin
    if Assigned(FEdit) then
      Result := TOvcTCPictureFieldEdit(FEdit).FloatScale
    else
      Result := 0;
  end;
{--------}
function TOvcTCCustomPictureField.GetUserData : TOvcUserData;
  begin
    if Assigned(FEdit) then
      Result := TOvcTCPictureFieldEdit(FEdit).UserData
    else
      Result := nil;
  end;
{--------}
procedure TOvcTCCustomPictureField.SetDataType(DT : TPictureDataType);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCPictureFieldEdit(FEdit).DataType := DT;
        TOvcTCPictureFieldEdit(FEditDisplay).DataType := DT;
      end;
  end;
{--------}
procedure TOvcTCCustomPictureField.SetEpoch(E : integer);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCPictureFieldEdit(FEdit).Epoch := E;
        TOvcTCPictureFieldEdit(FEditDisplay).Epoch := E;
      end;
  end;
{--------}
procedure TOvcTCCustomPictureField.SetPictureMask(const PM : string);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCPictureFieldEdit(FEdit).PictureMask := PM;
        TOvcTCPictureFieldEdit(FEditDisplay).PictureMask := PM;
        {force re-initialization of internal flags}
        TOvcTCPictureFieldEdit(FEdit).RecreateWnd;
        TOvcTCPictureFieldEdit(FEditDisplay).RecreateWnd;
      end;
  end;
{--------}
procedure TOvcTCCustomPictureField.SetFloatScale(FS : SmallInt);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCPictureFieldEdit(FEdit).FloatScale := FS;
        TOvcTCPictureFieldEdit(FEditDisplay).FloatScale := FS;
      end;
  end;
{--------}
procedure TOvcTCCustomPictureField.SetUserData(UD : TOvcUserData);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCPictureFieldEdit(FEdit).UserData := UD;
        TOvcTCPictureFieldEdit(FEditDisplay).UserData := UD;
      end;
  end;
{====================================================================}


{===TOvcTCPictureFieldEdit==============================================}
procedure TOvcTCPictureFieldEdit.efMoveFocusToNextField;
  var
    Msg : TWMKey;
  begin
    FillChar(Msg, sizeof(Msg), 0);
    with Msg do
      begin
        Msg := WM_KEYDOWN;
        CharCode := VK_RIGHT;
      end;
    CellOwner.SendKeyToTable(Msg);
  end;
{--------}
procedure TOvcTCPictureFieldEdit.efMoveFocusToPrevField;
  var
    Msg : TWMKey;
  begin
    FillChar(Msg, sizeof(Msg), 0);
    with Msg do
      begin
        Msg := WM_KEYDOWN;
        CharCode := VK_LEFT;
      end;
    CellOwner.SendKeyToTable(Msg);
  end;
{--------}
procedure TOvcTCPictureFieldEdit.WMChar(var Msg : TWMKey);
  begin
    if (Msg.CharCode <> 9) then {filter tab characters}
      inherited;
  end;
{--------}
procedure TOvcTCPictureFieldEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
  end;
{--------}
procedure TOvcTCPictureFieldEdit.WMKeyDown(var Msg : TWMKey);
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
    pForm: TCustomForm;
  begin
    pForm := GetParentForm(Self);
    if pForm <> nil then
    begin
      if pForm.KeyPreview and TPForm(pForm).DoKeyDown(Msg) then
        Exit;
    end;

    GridUsedIt := false;
    GridReply := otkDontCare;
    if (CellOwner <> nil) then
      GridReply := CellOwner.FilterTableKey(Msg);
    case GridReply of
      otkMustHave :
        begin
          {the entry field must also process this key - to restore its contents}
          if (Msg.CharCode = VK_ESCAPE) then
            Restore;

          CellOwner.SendKeyToTable(Msg);
          GridUsedIt := true;
        end;
      otkWouldLike :
        case Msg.CharCode of
          VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN :
            begin
              if ValidateSelf then
                begin
                  CellOwner.SendKeyToTable(Msg);
                  GridUsedIt := true;
                end;
            end;
          {Note: VK_LEFT, VK_RIGHT are processed by efMoveFocusToNext(Next)Field}
        end;
    end;{case}

    if not GridUsedIt then
      inherited;
  end;
{--------}
procedure TOvcTCPictureFieldEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, LastError);
  end;
{--------}
procedure TOvcTCPictureFieldEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}

end.
