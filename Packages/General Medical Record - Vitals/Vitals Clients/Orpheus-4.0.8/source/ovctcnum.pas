{*********************************************************}
{*                  OVCTCNUM.PAS 4.06                    *}
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

unit ovctcnum;
  {-Orpheus Table Cell - Numeric field type}

interface

uses
  Windows, SysUtils, Messages, Classes, Controls,
  OvcEF, OvcNF, OvcTCmmn, OvcTCell, OvcTCBEF,
  Graphics; { for default color definitions}

type
  {The editor class for TOvcTCNumericField cell components}
  TOvcTCNumericFieldEdit = class(TOvcNumericField)
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

  {The numeric field cell component class}
  TOvcTCCustomNumericField = class(TOvcTCBaseEntryField)
    protected

      function GetCellEditor : TControl; override;
      function GetDataType : TNumericDataType;
      function GetPictureMask : string;

      procedure SetDataType(DT : TNumericDataType);
      procedure SetPictureMask(const PM : string);


      property DataType : TNumericDataType
         read GetDataType write SetDataType;

      property PictureMask : string
         read GetPictureMask write SetPictureMask;

    public
      function CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField; override;
  end;

  TOvcTCNumericField = class(TOvcTCCustomNumericField)
    published
      {properties inherited from custom ancestor}
      property Access default otxDefault;
      property Adjust default otaDefault;
      property CaretIns;
      property Color;
      property DataType default nftLongInt;
      property EFColors;
      property Font;
      property Hint;
      property Margin default 4;
      property Options default [];
      property PadChar default ' ';
      property PictureMask;
      property RangeHi stored False;
      property RangeLo stored False;
      property ShowHint default False;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextMargin default 2;
      property TextHiColor default clBtnHighlight;
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


{===TOvcTCCustomNumericField=========================================}
function TOvcTCCustomNumericField.CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField;
  begin
    Result := TOvcTCNumericFieldEdit.Create(AOwner);
    TOvcTCNumericFieldEdit(Result).CellOwner := Self;
  end;
{--------}
function TOvcTCCustomNumericField.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
function TOvcTCCustomNumericField.GetDataType : TNumericDataType;
  begin
    if Assigned(FEdit) then Result := TOvcTCNumericFieldEdit(FEdit).DataType
      else Result := nftLongInt;
  end;
{--------}
function TOvcTCCustomNumericField.GetPictureMask : string;
  begin
    if Assigned(FEdit) then Result := TOvcTCNumericFieldEdit(FEdit).PictureMask;
  end;
{--------}
procedure TOvcTCCustomNumericField.SetDataType(DT : TNumericDataType);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCNumericFieldEdit(FEdit).DataType := DT;
        TOvcTCNumericFieldEdit(FEditDisplay).DataType := DT;
      end;
  end;
{--------}
procedure TOvcTCCustomNumericField.SetPictureMask(const PM : string);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCNumericFieldEdit(FEdit).PictureMask := PM;
        TOvcTCNumericFieldEdit(FEditDisplay).PictureMask := PM;
      end;
  end;
{====================================================================}


{===TOvcTCNumericFieldEdit==============================================}
procedure TOvcTCNumericFieldEdit.efMoveFocusToNextField;
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
procedure TOvcTCNumericFieldEdit.efMoveFocusToPrevField;
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
procedure TOvcTCNumericFieldEdit.WMChar(var Msg : TWMKey);
  begin
    if (Msg.CharCode <> 9) then {filter tab characters}
      inherited;
  end;
{--------}
procedure TOvcTCNumericFieldEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
  end;
{--------}
procedure TOvcTCNumericFieldEdit.WMKeyDown(var Msg : TWMKey);
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
procedure TOvcTCNumericFieldEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, LastError);
  end;
{--------}
procedure TOvcTCNumericFieldEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}

end.
