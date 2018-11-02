{*********************************************************}
{*                  OVCDBISE.PAS 4.06                    *}
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

unit ovcdbise;
  {-data-aware incremental search edit control}

interface

uses
  Windows, Classes, Controls, Db, ExtCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcBase, OvcConst, OvcData, OvcISEB, OvcExcpt,
  OvcMisc, OvcVer, OvcEditF, OvcDbHLL;

type
  TOvcDbSearchEdit = class(TOvcBaseISE)
  

  protected {private}
    {property variables}
    FDbEngineHelper : TOvcDbEngineHelperBase;
    FDataLink    : TDataLink;
    FLabelInfo   : TOvcLabelInfo;

    {property methods}
    function GetAbout : string;
    function GetAttachedLabel : TOvcAttachedLabel;
    function GetDataSource : TDataSource;
    procedure SetAbout(const Value : string);
    procedure SetDataSource(Value : TDataSource);

    {internal methods}
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;

    {private message methods}
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;

    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;


    {public methods}
    procedure PerformSearch;
      override;

    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;

  published
    property About : string
      read GetAbout write SetAbout stored False;
    property AutoSearch default True;
    property CaseSensitive default False;
    property Controller;
    property DataSource : TDataSource
      read GetDataSource write SetDataSource;
    property LabelInfo : TOvcLabelInfo
      read FLabelInfo write FLabelInfo;

    property KeyDelay default 500;
    property ShowResults default True;

    property DbEngineHelper : TOvcDbEngineHelperBase
      read FDbEngineHelper
      write FDbEngineHelper;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    {inherited events}
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
    property OnStartDrag;
  end;


implementation

{*** TOvcDbSearchEdit ***}

procedure TOvcDbSearchEdit.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

constructor TOvcDbSearchEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FDataLink := TDataLink.Create;

  DefaultLabelPosition := lpTopLeft;

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
end;

destructor TOvcDbSearchEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;

  inherited Destroy;
end;

function TOvcDbSearchEdit.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;

function TOvcDbSearchEdit.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbSearchEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcDbSearchEdit.LabelAttach(Sender : TObject; Value : Boolean);
var
  PF : TWinControl;
  S  : string;
begin
  if csLoading in ComponentState then
    Exit;

  PF := GetImmediateParentForm(Self);
  if Value then begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := TOvcAttachedLabel.CreateEx(PF, Self);
      FLabelInfo.ALabel.Parent := Parent;

      S := GenerateComponentName(PF, Name + 'Label');
      FLabelInfo.ALabel.Name := S;
      FLabelInfo.ALabel.Caption := S;

      FLabelInfo.SetOffsets(0, 0);
      PositionLabel;
      FLabelInfo.ALabel.BringToFront;
      {turn off auto size}
      FLabelInfo.ALabel.AutoSize := False;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;

procedure TOvcDbSearchEdit.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;

procedure TOvcDbSearchEdit.Notification(AComponent : TComponent;
                                        Operation : TOperation);
var
  PF : TWinControl;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := GetImmediateParentForm(Self);
      if Assigned(PF) and not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end;
    end;

    if (Assigned(FDBEngineHelper)) and
       (AComponent = FDbEngineHelper) then
      DBEngineHelper := nil;
  end;
end;

procedure TOvcDbSearchEdit.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;

procedure TOvcDbSearchEdit.OMPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and
     Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top;
    end else begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top - Top - Height;
    end;
    if (DX <> FLabelInfo.OffsetX) or (DY <> FLabelInfo.OffsetY) then
      PositionLabel;
  end;
end;

procedure TOvcDbSearchEdit.OMRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the re-attachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top - Top - Height);
  end;
end;

{ re-written}
procedure TOvcDbSearchEdit.PerformSearch;
var
  DataSet: TDataSet;
  BM: TBookMark;
  OK: boolean;
  Field: TField;
  Target: string;
  FoundValue: string;
  J: integer;

begin
  Modified := false;

  if ( DataSource = nil ) then
    DataSet := nil
  else
    DataSet := DataSource.DataSet;

  if ( DataSet <> nil )
  and ( OvcGetIndexFieldCount( DbEngineHelper, DataSet ) > 0 )
  and DataSet.Active then begin
    BM := DataSet.GetBookMark;
    try
      OK := true;
      Field := OvcGetIndexField( DbEngineHelper, DataSet, 0 );
      try
        OvcFindNearestKey( DbEngineHelper, DataSet, [ Text ] );
      except
        on EConvertError do
          OK := false;
        on EDatabaseError do
          OK := false;
      else
        raise;
      end;

      if OK
      and ( Field.DataType in [ ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString] )
      and ( pos( ISUpperCase( Text ), ISUpperCase( Field.AsString ) ) <> 1 ) then
        OK := false;

      if not OK then
        DataSet.GoToBookmark( BM );

      Target := ISUpperCase( Text );
      FoundValue := ISUpperCase( Field.AsString );
      J := 0;

      while ( J < length( Target ) )
      and ( J < length( FoundValue ) )
      and ( Target[ J + 1 ] = FoundValue[ J + 1 ] ) do
        inc( J );

      if OK
      and ( J = length( Target ) ) then
        PreviousText := Target
      else
        PreviousText := '';

      if ShowResults then begin
        Text := Field.AsString;
        SelStart := J;
        SelLength := length( Text ) - J;
      end;

    finally
      DataSet.FreeBookMark( BM );
    end;
  end;

end;
{ - end}


(*********************************************************************
This is the original code prior to database engine generalization.
It's left here for the beta tests just in case the TTable SQL
  particular code is still required.

procedure TOvcDbSearchEdit.PerformSearch;
var
  Table      : TTable;
  L          : Integer;
  BM         : TBookMark;
  FoundValue : string;
begin
  if (DataSource = nil) or (DataSource.DataSet = nil) then
    Exit;

 if not DataSource.DataSet.Active then
   Exit;

 if not (DataSource.DataSet is TTable) then
   Exit;

  Table := TTable(DataSource.DataSet);
  if Table.IndexFieldCount = 0 then
    Exit;

  with Table do begin
    BM := nil;
    try
      if DataBase.isSqlBased then begin
        Screen.Cursor := crHourGlass;
        try
          DisableControls;
          try
            try
              SetRangeStart;
              BM := GetBookMark;  {save location of current record}
              IndexFields[0].AsString := Text;
              SetRangeEnd; {clear end range}
              ApplyRange;
            except
              on EConvertError do begin
                SelStart := 0;
                SelLength := Length(Text);
              end else
                raise;
            end;
          finally
            EnableControls;
          end;
        finally
          Screen.Cursor := crDefault;
        end;
      end else begin
        BM := GetBookMark;  {save location of current record}
        try
          FindNearest([Text]);
        except
          on EConvertError do begin
            SelStart := 0;
            SelLength := Length(Text);
          end else
            raise;
        end;
      end;

      {retrieve the value}
      FoundValue := IndexFields[0].AsString;

      {check to make sure match conforms to CaseSensitive setting}
      if Pos(ISUpperCase(Text), ISUpperCase(FoundValue)) <> 1 then
        GotoBookMark(BM)
      else if ShowResults then begin {found}
        {record previous value}
        PreviousText := ISUpperCase(Text);

        {assign new value and select added characters}
        L := Length(Text);
        Text := FoundValue;
        SelStart := L;
        SelLength := Length(Text)-L;
        Self.Modified := False;
      end;

    finally
      FreeBookMark(BM);
    end;
  end;
end;
*********************************************************************)

procedure TOvcDbSearchEdit.PositionLabel;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
                           (FLabelInfo.ALabel.Parent <> nil) and
                           not (csLoading in ComponentState) then begin

    if DefaultLabelPosition = lpTopLeft then begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY - FLabelInfo.ALabel.Height + Top,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end else begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY + Top + Height,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end;
  end;
end;

procedure TOvcDbSearchEdit.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TOvcDbSearchEdit.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TOvcDbSearchEdit.SetAbout(const Value : string);
begin
end;




end.
