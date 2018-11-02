{*********************************************************}
{*                  OVCDBIDX.PAS 4.06                    *}
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
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcdbidx;
  {-Data-aware index selection combobox component}

interface

uses
  Windows, Classes, Controls, Db, Forms, Graphics, Menus, Messages, StdCtrls,
  SysUtils, TypInfo, OvcBase, OvcConst, OvcData, OvcExcpt, OvcMisc, OvcVer,
  OvcDbHLL;

type
  {possible display modes for the items shown in the drop-down list}
  TDisplayMode   = (dmFieldLabel, dmIndexName, dmFieldNames, dmFieldNumbers, dmUserDefined);
    {
     dmFieldLabel   - Displays the DisplayLabel of the primary field in the index
     dmIndexName    - Displays the actual index name ("Default" for Paradox's primary index)
     dmFieldNames   - Displays the list of field names that make up the index
     dmFieldNumbers - Displays the list of field numbers that make of the index
     dmUserDefined  - Displays a string returned from calls to the OnGetDisplayLabel event handler
    }

type
  TOvcDbIndexSelect = class;

  TGetDisplayLabelEvent =
    procedure(Sender : TOvcDbIndexSelect; const FieldNames,
              IndexName : string; IndexOptions : TIndexOptions;
              var DisplayName : string)
    of object;

  

  TOvcIndexInfo = class(TObject)
  protected {private }
    FDisplayName  : string;            {display name}
    FFields       : TStringList;       {list of field names for this index}
    FFieldNames   : string;            {names of index fields}
    FIndexName    : string;            {name of this index}
    FIndexOptions : TIndexOptions;     {index options}
    FOwner        : TOvcDbIndexSelect;
    FDataSet      : TDataSet;          {dataset that has this index}

    procedure SetDisplayName(const Value : string);

  public
    constructor Create(AOwner : TOvcDbIndexSelect;
      ADataSet : TDataSet; const AIndexName, AFieldNames : string);
      virtual;
    destructor Destroy;
      override;

    procedure RefreshIndexInfo;

    property DisplayName : string
      read FDisplayName
      write SetDisplayName;

    property Fields : TStringList
      read FFields;

    property FieldNames : string
      read FFieldNames;

    property IndexName : string
      read FIndexName;
  end;


  

  TOvcIndexSelectDataLink = class(TDataLink)
  protected {private }
    FIndexSelect : TOvcDbIndexSelect;
  protected
    procedure ActiveChanged;
      override;
    procedure DataSetChanged;
      override;
    procedure LayoutChanged;
      override;
  public
    constructor Create(AIndexSelect : TOvcDbIndexSelect);
  end;


  TOvcDbIndexSelect = class(TCustomComboBox)
  

  protected {private}
    {property variables}
    FDbEngineHelper : TOvcDbEngineHelperBase;
    FDataLink     : TOvcIndexSelectDataLink;
    FDisplayMode  : TDisplayMode;           {what to display as index name}
    FLabelInfo    : TOvcLabelInfo;
    FMonitorIdx   : Boolean;                {True, to monitor index changes}
    FShowHidden   : Boolean;                {True, to show index for hidden fields}

    {event variables}
    FOnGetDisplayLabel : TGetDisplayLabelEvent;

    {internal variables}
    isRefreshPending : Boolean;

    {property methods}
    function GetAbout : string;
    function GetDataSource : TDataSource;
    procedure SetAbout(const Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetDisplayMode(Value : TDisplayMode);
    procedure SetMonitorIdx(Value : Boolean);
    procedure SetShowHidden(Value : Boolean);

    {internal methods}
    procedure isFindIndex;
    function GetAttachedLabel : TOvcAttachedLabel;
    function GetIndexName(ADataSet : TDataSet) : string;
    function GetIndexFieldNames(ADataSet : TDataSet) : string;
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;

    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;

    {windows message handling methods}
    procedure WMDestroy(var Msg : TWMDestroy);
      message WM_DESTROY;
    procedure WMPaint(var Msg : TWMPaint);
      message WM_PAINT;

    {private message methods}
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    procedure Change;
      override;
    procedure ClearObjects;
      virtual;
    procedure CreateWnd;
      override;
    procedure DestroyWnd;
      override;
    procedure DropDown;
      override;

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;


    procedure RefreshList;
    procedure RefreshNow;
    procedure SetRefreshPendingFlag;

    {public properties}
    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;

    property Canvas;
    property Items;
    property MaxLength;
    property Text;

  published
    {properties}
    property About : string
      read GetAbout write SetAbout stored False;
    property DataSource : TDataSource
      read GetDataSource write SetDataSource;
    property DisplayMode : TDisplayMode
      read FDisplayMode write SetDisplayMode
        default dmFieldLabel;
    property LabelInfo : TOvcLabelInfo
      read FLabelInfo write FLabelInfo;
    property MonitorIndexChanges : Boolean
      read FMonitorIdx write SetMonitorIdx
        default False;
    property ShowHidden : Boolean
      read FShowHidden write SetShowHidden
        default True;
    property DbEngineHelper : TOvcDbEngineHelperBase
      read FDbEngineHelper
      write FDbEngineHelper;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Visible;

    {events}
    property OnGetDisplayLabel : TGetDisplayLabelEvent
      read FOnGetDisplayLabel
      write FOnGetDisplayLabel;

    {inherited events}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDrawItem;
    property OnDropDown;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
  end;


implementation

{*** TOvcIndexInfo ***}

constructor TOvcIndexInfo.Create(AOwner : TOvcDbIndexSelect;
            ADataset : TDataset; const AIndexName, AFieldNames : string);
begin
  inherited Create;

  FOwner      := AOwner;
  FDataset    := ADataset;
  FIndexName  := AIndexName;
  FFieldNames := AFieldNames;

  FFields := TStringList.Create;

  RefreshIndexInfo;
end;

destructor TOvcIndexInfo.Destroy;
begin
  FFields.Free;
  FFields := nil;

  inherited Destroy;
end;

procedure TOvcIndexInfo.RefreshIndexInfo;
var
  I         : Integer;
  ID        : TIndexDef;
  Fld       : TField;
  IndexDefs : TIndexDefs;
begin
  if not FDataSet.Active then
    Exit;

  if FFieldNames = '' then begin

    {use the previously saved index name}
    FDisplayName := FIndexName;

    {is this a FlashFiler default index}
    if AnsiCompareText(FIndexName, 'Seq. Access Index') = 0 then
      FDisplayName := GetOrphStr(SCDefaultIndex);

    if (FOwner.DisplayMode = dmUserDefined) and Assigned(FOwner.FOnGetDisplayLabel) then
      FOwner.FOnGetDisplayLabel(FOwner, FFieldNames, FIndexName, FIndexOptions, FDisplayName);

    Exit;
  end;

  {get index definitions}
  IndexDefs := OvcGetIndexDefs(FOwner.DbEngineHelper, FDataSet);

  ID := nil;
  I := IndexDefs.IndexOf(FIndexName);
  if I > -1 then
    ID := IndexDefs[I];

  if Assigned(ID) then begin
    FIndexName := ID.Name;
    FIndexOptions := ID.Options;

    {fill list with field names}
    I := 1;
    FFields.Clear;
    while I < Length(FFieldNames) do
      FFields.Add(ExtractFieldName(FFieldNames, I));

    {set the text to use as the display name}
    if (FFields.Count > 0) and ((ID.Name > '') or
       (FOwner.DisplayMode in [dmFieldNames, dmFieldNumbers, dmUserDefined])) then begin
      Fld := FDataSet.FieldByName(FFields[0]);
      if (FOwner.DisplayMode = dmFieldLabel) and Assigned(Fld) then
        FDisplayName := Fld.DisplayLabel
      else if (FOwner.DisplayMode = dmFieldNames) then
        FDisplayName := FFieldNames
      else if (FOwner.DisplayMode = dmIndexName) then
        FDisplayName := FIndexName
      else if (FOwner.DisplayMode = dmFieldNumbers) and Assigned(Fld) then begin
        FDisplayName := '';
        for I := 0 to Pred(FFields.Count) do begin
          Fld := FDataSet.FieldByName(FFields[I]);
          if Assigned(Fld) then begin
            if FDisplayName > '' then
              FDisplayName := FDisplayName + ';';
            FDisplayName := FDisplayName + IntToStr(Fld.FieldNo);
          end;
        end;
      end else if (FOwner.DisplayMode = dmUserDefined) and
                   Assigned(FOwner.FOnGetDisplayLabel) then begin
        FDisplayName := FIndexName; {set up default display name}
        FOwner.FOnGetDisplayLabel(FOwner, FFieldNames, FIndexName, FIndexOptions, FDisplayName);
      {if nothing else is possible, try these}
      end else if Assigned(Fld) then
        FDisplayName := Fld.DisplayLabel
      else
        FDisplayName := FIndexName;

      if not (FOwner.DisplayMode = dmUserDefined) then
        if (ixDescending in ID.Options) then
          FDisplayName := FDisplayName  + GetOrphStr(SCDescending);
    end else
      FDisplayName := GetOrphStr(SCDefaultIndex);
  end;
end;

procedure TOvcIndexInfo.SetDisplayName(const Value : string);
begin
  if (Value <> FDisplayName) then begin
    FDisplayName := Value;
    FOwner.SetRefreshPendingFlag;
    FOwner.Invalidate;
  end;
end;


{*** TOvcIndexSelectDataLink ***}

procedure TOvcIndexSelectDataLink.ActiveChanged;
begin
  inherited ActiveChanged;

  if not (csLoading in FIndexSelect.ComponentState) then
    FIndexSelect.RefreshNow;
end;

constructor TOvcIndexSelectDataLink.Create(AIndexSelect : TOvcDbIndexSelect);
begin
  inherited Create;

  FIndexSelect := AIndexSelect;
end;

procedure TOvcIndexSelectDataLink.DataSetChanged;
begin
  inherited DataSetChanged;

  FIndexSelect.isFindIndex;
end;

procedure TOvcIndexSelectDataLink.LayoutChanged;
begin
  inherited LayOutChanged;

  if Active then
    FIndexSelect.SetRefreshPendingFlag;
end;


{*** TOvcDbIndexSelect ***}

procedure TOvcDbIndexSelect.Change;
var
  IndexInfo : TOvcIndexInfo;
begin

  if (DataSource = nil) or (DataSource.DataSet = nil)
     or (DbEngineHelper = nil)
     or (not (DataSource.DataSet.Active)) then
    Exit;

  if ItemIndex > -1 then begin
    IndexInfo := TOvcIndexInfo(Items.Objects[ItemIndex]);
    OvcSetIndexName(DbEngineHelper, DataSource.Dataset, IndexInfo.IndexName);
  end;

  inherited Change;
end;

procedure TOvcDbIndexSelect.ClearObjects;
var
  I : Integer;
begin
  if not HandleAllocated then
    Exit;

  {free all associated TOvcIndexInfo objects}
  if Items.Count > 0 then
    for I := 0 to Pred(Items.Count) do
      if (Items.Objects[I] <> nil) then begin
        Items.Objects[I].Free;
        Items.Objects[I] := nil;
      end;
end;

procedure TOvcDbIndexSelect.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

constructor TOvcDbIndexSelect.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Style := csDropDownList;

  FDataLink    := TOvcIndexSelectDataLink.Create(Self);

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
  DefaultLabelPosition := lpTopLeft;

  FDisplayMode := dmFieldLabel;
  FMonitorIdx  := False;
  FShowHidden  := True;
end;

procedure TOvcDbIndexSelect.CreateWnd;
begin
  inherited CreateWnd;

  SetRefreshPendingFlag;
end;

destructor TOvcDbIndexSelect.Destroy;
begin
  {moved from WMDestroy}
  ClearObjects;

  FDataLink.Free;
  FDataLink := nil;

  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;

  inherited Destroy;
end;

procedure TOvcDbIndexSelect.DestroyWnd;
begin
  {free field info objects here instead of in an overriden Clear
  method, because ancestor's Clear method isn't virtual}
  ClearObjects;

  inherited DestroyWnd;
end;

procedure TOvcDbIndexSelect.DropDown;
begin
  if isRefreshPending then
    RefreshList;

  inherited DropDown;
end;

function TOvcDbIndexSelect.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;

function TOvcDbIndexSelect.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbIndexSelect.GetAbout : string;
begin
  Result := OrVersionStr;
end;

function TOvcDbIndexSelect.GetIndexName(ADataSet : TDataSet) : string;
begin
  OvcGetIndexName(DbEngineHelper, ADataSet, Result);
end;

function TOvcDbIndexSelect.GetIndexFieldNames(ADataSet : TDataSet) : string;
begin
  OvcGetIndexFieldNames(DbEngineHelper, ADataSet, Result);
end;

procedure TOvcDbIndexSelect.isFindIndex;
var
  I         : Integer;
  Idx       : Integer;
  IndexInfo : TOvcIndexInfo;

begin
  if not FMonitorIdx then
    Exit;

  {exit if a refresh operation is pending--it will update the display}
  if isRefreshPending then
    Exit;

  if (DataSource = nil) or (DataSource.DataSet = nil)
  or (DbEngineHelper = nil) then Exit;

  {find the current index}
  Idx := -1;
  for I := 0 to Pred(Items.Count) do begin
    IndexInfo := TOvcIndexInfo(Items.Objects[I]);
    if Assigned(IndexInfo) then begin
      if (GetIndexFieldNames(DataSource.DataSet) = '') then begin
        if AnsiCompareText(IndexInfo.IndexName,
                           GetIndexName(DataSource.DataSet)) = 0 then
          Idx := I;
      end else begin
        if AnsiCompareText(IndexInfo.FieldNames,
                           GetIndexFieldNames(DataSource.DataSet)) = 0 then
          Idx := I;
      end;
    end;
  end;

  ItemIndex := Idx;
end;

procedure TOvcDbIndexSelect.LabelAttach(Sender : TObject; Value : Boolean);
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

procedure TOvcDbIndexSelect.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;

procedure TOvcDbIndexSelect.Notification(AComponent : TComponent;
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

    if (Assigned(DBEngineHelper)) and
       (AComponent = FDbEngineHelper) then
      DBEngineHelper := nil;
  end;
end;

procedure TOvcDbIndexSelect.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;

procedure TOvcDbIndexSelect.OMPositionLabel(var Msg : TMessage);
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

procedure TOvcDbIndexSelect.OMRecordLabelPosition(var Msg : TMessage);
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

procedure TOvcDbIndexSelect.PositionLabel;
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

procedure TOvcDbIndexSelect.RefreshList;
var
  I           : Integer;
  Idx         : Integer;
  Fld         : TField;
  IndexInfo   : TOvcIndexInfo;
  IndexDefs   : TIndexDefs;
  ActiveIndex : string;
begin
  if not isRefreshPending then
    Exit;

  if not HandleAllocated then
    Exit;

  {clear refresh flag}
  isRefreshPending := False;

  {free field info objects}
  ClearObjects;

  {remove items from list}
  Items.Clear;

  if (DataSource = nil) or (DataSource.DataSet = nil) or
     (not (DataSource.DataSet.Active))
     or (DbEngineHelper = nil)
     then
    Exit;

  if OvcIsChildDataSet(DbEngineHelper, DataSource.DataSet) then
    raise EOvcException.CreateFmt(GetOrphStr(SCChildTableError), [Self.Name]);

  {get index definitions}
  IndexDefs := OvcGetIndexDefs(DbEngineHelper, DataSource.DataSet);
  {update the index information}
  IndexDefs.Update;

  ActiveIndex := '';
  for I := 0 to Pred(IndexDefs.Count) do begin
    IndexInfo := TOvcIndexInfo.Create(Self, DataSource.DataSet,
      IndexDefs.Items[I].Name,
      IndexDefs.Items[I].Fields);
    if (Items.IndexOf(IndexInfo.DisplayName) < 0) and
       (Length(IndexInfo.DisplayName) > 0) then begin
      Items.AddObject(IndexInfo.DisplayName, IndexInfo);
      if (GetIndexFieldNames(DataSource.DataSet) = '') then begin
        if AnsiCompareText(IndexDefs.Items[I].Name, GetIndexName(DataSource.DataSet)) = 0 then
          ActiveIndex := IndexInfo.DisplayName;
      end else begin
        if AnsiCompareText(GetIndexFieldNames(DataSource.DataSet), IndexDefs.Items[I].Fields) = 0 then
          ActiveIndex := IndexInfo.DisplayName;
      end;
    end else
      IndexInfo.Free;
  end;

  {conditionally remove non-visible Fields}
  if not ShowHidden and (DataSource.DataSet.Fields.LifeCycles <> [TFieldLifeCycle.lcAutomatic]) then begin
    for I := Pred(Items.Count) downto 0 do begin
      IndexInfo := TOvcIndexInfo(Items.Objects[I]);
      Fld := DataSource.DataSet.FieldByName(IndexInfo.FFields[0]);
      if Assigned(Fld) then begin
        if not Fld.Visible then begin
          Items.Objects[I].Free;
          Items.Delete(I);
        end;
      end;
    end;
  end;

  Idx := -1;
  for I := 0 to Pred(Items.Count) do
    if AnsiCompareText(Items[I], ActiveIndex) = 0 then
      Idx := I;
  ItemIndex := Idx;
end;

procedure TOvcDbIndexSelect.RefreshNow;
begin
  SetRefreshPendingFlag;
  RefreshList;
end;

procedure TOvcDbIndexSelect.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TOvcDbIndexSelect.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  if (Value <> nil) then
    Value.FreeNotification(Self);

  if not (csLoading in ComponentState) then
    RefreshNow;
end;

procedure TOvcDbIndexSelect.SetDisplayMode(Value : TDisplayMode);
begin
  if (Value <> FDisplayMode) then begin
    FDisplayMode := Value;
    if not (csLoading in ComponentState) then
      RefreshNow;
  end;
end;

procedure TOvcDbIndexSelect.SetMonitorIdx(Value : Boolean);
begin
  if (Value <> FMonitorIdx) then begin
    FMonitorIdx := Value;
    if not (csLoading in ComponentState) then
      if FMonitorIdx then
        isFindIndex;
  end;
end;

procedure TOvcDbIndexSelect.SetRefreshPendingFlag;
begin
  isRefreshPending := True;
end;

procedure TOvcDbIndexSelect.SetShowHidden(Value : Boolean);
begin
  if (Value <> FShowHidden) then begin
    FShowHidden := Value;
    if not (csLoading in ComponentState) then
      RefreshNow;
  end;
end;

procedure TOvcDbIndexSelect.SetAbout(const Value : string);
begin
end;

procedure TOvcDbIndexSelect.WMDestroy(var Msg : TWMDestroy);
begin
{ moved to the Destructor }
//  ClearObjects;

  inherited;
end;

procedure TOvcDbIndexSelect.WMPaint(var Msg : TWMPaint);
begin
  if isRefreshPending then
    RefreshList;

  inherited;
end;


end.
