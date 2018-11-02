{*********************************************************}
{*                  OVCTCSIM.PAS 4.08                    *}
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

unit ovctcsim;
  {-Orpheus Table Cell - Simple field type}

interface

uses
  Windows, SysUtils, Messages, Classes, Controls,
  OvcData, OvcEF, OvcSF, OvcTCmmn, OvcTCell, OvcTCBEF,
  Graphics; { - for default color definition}

type
  {The editor class for TOvcTCSimpleField cell components}
  TOvcTCSimpleFieldEdit = class(TOvcSimpleField)
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


    published
      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
  end;

  {The simple field cell component class}
  TOvcTCCustomSimpleField = class(TOvcTCBaseEntryField)
    protected

      function GetCellEditor : TControl; override;
      function GetDataType : TSimpleDataType;
      function GetPictureMask : Char;

      procedure SetDataType(DT : TSimpleDataType);
      procedure SetPictureMask(PM : Char);


      property DataType : TSimpleDataType
         read GetDataType write SetDataType;

      property PictureMask : Char
         read GetPictureMask write SetPictureMask;

    public
      function CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField; override;
  end;

  TOvcTCSimpleField = class(TOvcTCCustomSimpleField)
    published
      {properties inherited from custom ancestor}
      property Access default otxDefault;
      property Adjust default otaDefault;
      property CaretIns;
      property CaretOvr;
      property Color;
      property ControlCharColor default clRed;
      property DataStringType;
      property DataType default sftString;
      property DecimalPlaces default 0;
      property EFColors;
      property EllipsisMode;
      property Font;
      property Hint;
      property Margin default 4;
      property MaxLength default 15;
      property Options default [efoCaretToEnd, efoTrimBlanks];
      property PadChar default ' ';
      property PasswordChar default '*';
      property PictureMask default 'X';
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


{===TOvcTCCustomSimpleField=========================================}
function TOvcTCCustomSimpleField.CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField;
  begin
    Result := TOvcTCSimpleFieldEdit.Create(AOwner);
    TOvcTCSimpleFieldEdit(Result).CellOwner := Self;
  end;
{--------}
function TOvcTCCustomSimpleField.GetCellEditor : TControl;
  begin
    Result := FEdit;
  end;
{--------}
function TOvcTCCustomSimpleField.GetDataType : TSimpleDataType;
  begin
    if Assigned(FEdit) then Result := TOvcTCSimpleFieldEdit(FEdit).DataType
      else Result := sftString;
  end;
{--------}
function TOvcTCCustomSimpleField.GetPictureMask : Char;
  begin
    if Assigned(FEdit) then Result := TOvcTCSimpleFieldEdit(FEdit).PictureMask
      else Result := pmAnyChar;
  end;
{--------}
procedure TOvcTCCustomSimpleField.SetDataType(DT : TSimpleDataType);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCSimpleFieldEdit(FEdit).DataType := DT;
        TOvcTCSimpleFieldEdit(FEditDisplay).DataType := DT;
      end;
  end;
{--------}
procedure TOvcTCCustomSimpleField.SetPictureMask(PM : Char);
  begin
    if Assigned(FEdit) then
      begin
        TOvcTCSimpleFieldEdit(FEdit).PictureMask := PM;
        TOvcTCSimpleFieldEdit(FEditDisplay).PictureMask := PM;
      end;
  end;
{====================================================================}


{===TOvcTCSimpleFieldEdit==============================================}
procedure TOvcTCSimpleFieldEdit.efMoveFocusToNextField;
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
procedure TOvcTCSimpleFieldEdit.efMoveFocusToPrevField;
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
procedure TOvcTCSimpleFieldEdit.WMChar(var Msg : TWMKey);
  begin
    if (Msg.CharCode <> 9) then {filter tab characters}
      inherited;
  end;
{--------}
procedure TOvcTCSimpleFieldEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
  end;
{--------}
procedure TOvcTCSimpleFieldEdit.WMKeyDown(var Msg : TWMKey);
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
procedure TOvcTCSimpleFieldEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, LastError);
  end;
{--------}
procedure TOvcTCSimpleFieldEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}

end.
