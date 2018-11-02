{*********************************************************}
{*                   OVCDBED.PAS 4.06                    *}
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

unit ovcdbed;
  {-Data aware editor component}

interface

uses
  Windows, Classes, Controls, Db, DbConsts, DbCtrls,
  Messages, SysUtils, OvcBase, OvcData,  OvcEdit,
  StdCtrls, { for ssBoth definition}
  Graphics, { for color definition}
  Forms; { for bsSingle definition}

type
  TOvcDbEditor = class(TOvcCustomEditor)
  

  protected
    {property variables}
    FAutoUpdate : Boolean;
    FDataLink   : TFieldDataLink;

    {internal variables}
    edUpdating  : Boolean;

    {property methods}
    function GetField : TField;
    function GetDataField : string;
    function GetDataSource : TDataSource;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);

    {internal methods}
    procedure eddbGetEditorValue;
    procedure eddbDataChange(Sender : TObject);
    procedure eddbEditingChange(Sender : TObject);
    procedure eddbSetEditorValue;
    procedure eddbUpdateData(Sender : TObject);

    {vcl methods}
    procedure CMEnter(var Msg : TMessage);
      message CM_ENTER;
    procedure CMExit(var Msg : TMessage);
      message CM_EXIT;
    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

    {windows message methods}
    procedure WMChar(var Msg : TWMChar);
      message WM_CHAR;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN    ;

    procedure CreateWnd;
      override;
    procedure edAddSampleParas;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    {virtual property methods}
    function GetReadOnly : Boolean;
      override;
      {-return the read-only status}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

    procedure CutToClipboard;
      override;
      {-copy highlighted text to the clipboard and then delete it}
    procedure Redo;
      {-redo the last undone operation}
      override;
    function Replace(const S, R : string;
                     Options : TSearchOptionSet) : Integer;
      {-search for a string and replace it with another string}
      override;
    procedure PasteFromClipboard;
      override;
      {-paste the contents of the clipboard}
    procedure Undo;
      {-undo the last change}
      override;

    property Field : TField
      read GetField;

  published
    property AutoUpdate : Boolean
      read FAutoUpdate
      write FAutoUpdate default True;

    property DataField : string
      read GetDataField
      write SetDataField;

    property DataSource : TDataSource
      read GetDataSource
      write SetDataSource;

    property Anchors;
    property Constraints;
    property DragKind;
    property AutoIndent default False;
    property Borders;
    property BorderStyle default bsSingle;
    property ByteLimit default 2147483647;
    property CaretIns;
    property CaretOvr;
    property FixedFont;
    property HideSelection default True;
    property HighlightColors;
    property InsertMode default True;
    property LabelInfo;
    property LeftMargin default 15;
    property MarginColor default clWindow;
    property ParaLengthLimit default 32767;
    property ParaLimit default 2147483647;
    property ReadOnly default False;
    property RightMargin default 5;
    property ScrollBars default ssBoth;
    property ScrollBarsAlways default False;
    property ScrollPastEnd default False;
    property ShowBookmarks default True;
    property TabSize default 8;
    property TabType default ttReal;
    property UndoBufferSize default 8192;
    property WantEnter default True;
    property WantTab default False;
    property WordWrap default False;
    property WrapAtLeft default True;
    property WrapColumn default 80;
    property WrapToWindow default False;
    property WheelDelta default 1;
    property OnError;
    property OnShowStatus;
    property OnUserCommand;

    {inherited properties}
    property Align;
    property Color;
    property Controller;
    property Ctl3D;
    property Cursor default crIBeam;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    {inherited events}
    property AfterEnter;
    property AfterExit;
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
    property OnStartDrag;
  end;

implementation

{*** TOvcDbEditor ***}

procedure TOvcDbEditor.CMEnter(var Msg : TMessage);
begin
  FDataLink.Reset;

  inherited;
end;

procedure TOvcDbEditor.CMExit(var Msg : TMessage);
begin
  if Modified and AutoUpdate then
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;

  inherited;
end;

procedure TOvcDbEditor.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FAutoUpdate               := True;
  FDataLink                 := TFieldDataLink.Create;
  FDataLink.Control         := Self;
  FDataLink.OnDataChange    := eddbDataChange;
  FDataLink.OnEditingChange := eddbEditingChange;
  FDataLink.OnUpdateData    := eddbUpdateData;
end;

procedure TOvcDbEditor.CreateWnd;
begin
  inherited CreateWnd;

  if Field <> nil then
    eddbSetEditorValue;
end;

procedure TOvcDbEditor.CutToClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);

  inherited CutToClipboard;
  {eddbGetEditorValue;}
  FDataLink.Modified;
end;

destructor TOvcDbEditor.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

procedure TOvcDbEditor.edAddSampleParas;
begin
  {do nothing}
end;

procedure TOvcDbEditor.eddbDataChange(Sender : TObject);
begin
  if Showing then
    eddbSetEditorValue;
end;

procedure TOvcDbEditor.eddbEditingChange(Sender : TObject);
begin
{}
end;

procedure TOvcDbEditor.eddbGetEditorValue;
var
  B     : TStream;
  I     : Integer;
  Len   : Word;
  Para  : PChar;
  Count : Integer;
  CrLf  : array[0..2] of Char;
begin
  HandleNeeded;
  StrCopy(Crlf, #13#10#0);
  if Field <> nil then begin
    if Field.DataType in [ftMemo, ftBlob, ftFmtMemo] then begin
      B := Field.DataSet.CreateBlobStream(TBlobField(Field), bmWrite);
      try
        Count := ParaCount;
        for I := 1 to Count do begin
          Para := GetPara(I, Len);
          B.Write(Para^, Len);
          if I <> Count then
            {end each paragraph with a crlf}
            B.Write(Crlf, 2)
          else if Len > 0 then
            {end last paragraph with crlf if it has length > 0}
            B.Write(Crlf, 2)
        end;
      finally
        B.Free;
      end;
    end;
  end;
end;

procedure TOvcDbEditor.eddbSetEditorValue;
const
  BufSize   = 4096;
var
  B         : TStream;
  HaveSel   : Boolean;
  C, C1, C2 : Integer;
  L, L1, L2 : Integer;
  TL        : Integer;
  Buf       : PChar;
  BytesRead : Integer;
  Paras     : PChar;
  SaveUndo  : Integer;
begin
  HandleNeeded;
  SaveUndo := UndoBufferSize;
  UndoBufferSize := 0; {disable undo}
  if Field <> nil then begin
    if Field.DataType in [ftMemo, ftBlob, ftFmtMemo] then begin
      {save current caret and selection status}
      HaveSel := GetSelection(L1, C1, L2, C2) and (FDataLink.Editing);
      L := GetCaretPosition(C);
      {save current top line}
      TL := TopLine;
      BeginUpdate;
      try
        DeleteAll(True);
        B := Field.DataSet.CreateBlobStream(TBlobField(Field), bmRead);
        try
          Buf := StrAlloc(BufSize+2);
          try
            B.Position :=0;
            repeat
              BytesRead := B.Read(Buf^, BufSize);
              Buf[BytesRead] := #0;
              edUpdating := True;
              try
                Insert(Buf);
              finally
                edUpdating := False;
              end;
            until BytesRead < BufSize;
          finally
            StrDispose(Buf);
          end;
        finally
          B.Free;
        end;
      {end;}
      finally
        EndUpdate;
      end;

      {reset top row}
      if TL <= LineCount then
        TopLine := TL
      else
        TopLine := 1;

      {set caret and highlight state}
      if HaveSel then
        SetSelection(L1, C1, L2, C2, (L > L1) or ((L = L1) and (C > C1)))
      else begin
        if (L <= LineCount) and (C <= LineLength[L]+1) then
          SetCaretPosition(L, C)
        else
          SetCaretPosition(1, 1);
      end;

    end else begin  {not a supported field}
      Paras := StrAlloc(256);
      try
        StrPCopy(Paras, Field.ClassName);
        StrLCat(Paras, ')', 255);
        Paras[0] := '(';
        SetText(Paras);
        SetCaretPosition(1, 1);
      finally
        StrDispose(Paras);
      end;
    end;
  end else
    inherited edAddSampleParas;

  Modified := False;
  UndoBufferSize := SaveUndo; {restore size}
end;

procedure TOvcDbEditor.eddbUpdateData(Sender : TObject);
begin
  eddbGetEditorValue;
end;

function TOvcDbEditor.GetReadOnly : Boolean;
  {-return read-only status}
begin
  if edUpdating then begin
    Result := False;
    Exit;
  end;

  if csDesigning in ComponentState then
    Result := inherited GetReadOnly
  else begin
    Result := inherited GetReadOnly or (DataSource = nil) or (not FDataLink.CanModify);
    if Field <> nil then
    if not (Field.DataType in [ftMemo, ftBlob, ftFmtMemo]) then
      Result := True;
    if not Result then
      Result := not (DataSource.State in [dsEdit, dsInsert]);
  end;
end;

function TOvcDbEditor.GetField : TField;
begin
  Result := FDataLink.Field;
end;

function TOvcDbEditor.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbEditor.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

procedure TOvcDbEditor.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = DataSource) then begin
    DataSource := nil;
    Refresh;
  end;
end;

procedure TOvcDbEditor.PasteFromClipboard;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);

  inherited PasteFromClipboard;

  {eddbGetEditorValue;}
  FDataLink.Modified;
end;

procedure TOvcDbEditor.Redo;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);

  inherited Redo;

  {eddbGetEditorValue;}
  FDataLink.Modified;
end;

function TOvcDbEditor.Replace(const S, R : string;
                              Options : TSearchOptionSet) : Integer;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);

  Result := inherited Replace(S, R, Options);

  {eddbGetEditorValue;}
  FDataLink.Modified;
end;

procedure TOvcDbEditor.SetDataField(const Value : string);
begin
  FDataLink.FieldName := Value;
  Refresh;
end;

procedure TOvcDbEditor.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  Refresh;
end;

procedure TOvcDbEditor.Undo;
begin
  if not FDataLink.Editing then
    DatabaseError(SNotEditing);

  inherited Undo;

  {eddbGetEditorValue;}
  FDataLink.Modified;
end;

procedure TOvcDbEditor.WMChar(var Msg : TWMChar);
begin
  with Msg do begin
    if (CharCode in [32..255]) and (Field <> nil) and
       not Field.IsValidChar(Char(Lo(CharCode))) then
      MessageBeep(0)
    else
      inherited;
  end;
end;

procedure TOvcDbEditor.WMKeyDown(var Msg : TWMKeyDown);
var
  Shift  : Boolean;
  Insert : Boolean;

  procedure DoChange;
  begin
    if FDataLink.Editing then
      FDataLink.Modified
    else if (DataSource <> nil) and DataSource.AutoEdit then
      if not inherited GetReadOnly then begin
        if FDataLink.Edit then
          FDataLink.Modified;
      end;
  end;
begin
  case Msg.CharCode of
    VK_NEXT,
    VK_PRIOR,
    VK_ESCAPE,
    VK_NONE,
    VK_SHIFT,
    VK_CONTROL,
    VK_ALT,
    VK_CAPITAL,
    VK_NUMLOCK,
    VK_SCROLL,
    VK_HOME,
    VK_END,
    VK_UP,
    VK_DOWN,
    VK_LEFT,
    VK_RIGHT    : {};
    VK_TAB      : if WantTab or
                    (GetAsyncKeyState(VK_CONTROL) and $8000 <> 0) then
                    DoChange;
    VK_RETURN   : if WantEnter then
                    DoChange;
  else
    Shift := (GetAsyncKeyState(VK_SHIFT) and $8000 <> 0);
    Insert := (Msg.CharCode = VK_INSERT);
    if not Insert or (Shift and Insert) then
      DoChange;
  end;

  inherited;
end;

function TOvcDbEditor.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbEditor.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.
