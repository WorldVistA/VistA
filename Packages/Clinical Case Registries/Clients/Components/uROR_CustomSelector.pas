unit uROR_CustomSelector;

interface

uses
  Buttons, Classes, Controls, ExtCtrls, OvcFiler, ComCtrls, uROR_GridView;

const
  CCRSelSplitterWidth = 32;
  CCRSelButtonSize    = 24;

type
  TSplitPos = 0..100;
  TCCRSelectorARMode = (armDefault, armSpecial);

  TCCRSelectorUpdateButtonsEvent = procedure(aSender: TObject;
    var EnableAdd, EnableAddAll, EnableRemove, EnableRemoveAll: Boolean) of object;

  TCCRCustomSelector = class(TCustomPanel)
  private
    fAdd:             TSpeedButton;
    fAddAll:          TSpeedButton;
    fAddRemoveMode:   TCCRSelectorARMode;
    fAutoSort:        Boolean;
    fCustomAdd:       Boolean;
    fCustomRemove:    Boolean;
    fFocusedList:     TWinControl;
    fIDField:         Integer;
    fOnAdd:           TNotifyEvent;
    fOnAddAll:        TNotifyEvent;
    fOnRemove:        TNotifyEvent;
    fOnRemoveAll:     TNotifyEvent;
    fOnSplitterMove:  TNotifyEvent;
    fOnUpdateButtons: TCCRSelectorUpdateButtonsEvent;
    fRemove:          TSpeedButton;
    fRemoveAll:       TSpeedButton;
    fResultChanged:   Boolean;
    fResultList:      TWinControl;
    fSourceList:      TWinControl;
    fSourcePanel:     TPanel;
    fSplitPos:        TSplitPos;
    fSplitter:        TSplitter;
    fSplitterPanel:   TPanel;

    procedure buttonOnAdd(aSender: TObject);
    procedure buttonOnAddAll(aSender: TObject);
    procedure buttonOnRemove(aSender: TObject);
    procedure buttonOnRemoveAll(aSender: TObject);

    property ResultList: TWinControl                read    fResultList;

    property SourceList: TWinControl                read    fSourceList;

  protected
    procedure ActionUpdate(aSender: TObject); virtual;
    procedure AdjustControls; virtual;
    function  CreateResultList: TWinControl; virtual;
    function  CreateSourceList: TWinControl; virtual;
    procedure CreateWnd; override;
    procedure DoEnter; override;
    procedure DoUpdateButtons(var EnableAdd, EnableAddAll,
      EnableRemove, EnableRemoveAll: Boolean); virtual;
    function  GetListItemFollowingSelection(aLastItem: TListItem): TListItem;
    function  GetResultControl: TWinControl;
    function  GetSourceControl: TWinControl;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure Resize; override;
    procedure SetEnabled(aValue: Boolean); override;
    procedure setSplitPos(const aValue: TSplitPos); virtual;
    procedure SplitterMoved(aSender: TObject); virtual;

    property AddRemoveMode: TCCRSelectorARMode      read    fAddRemoveMode
                                                    write   fAddRemoveMode
                                                    default armDefault;

    property AutoSort: Boolean                      read    fAutoSort
                                                    write   fAutoSort
                                                    default True;

    property CustomAdd: Boolean                     read    fCustomAdd
                                                    write   fCustomAdd;

    property CustomRemove: Boolean                  read    fCustomRemove
                                                    write   fCustomRemove;

    property IDField: Integer                       read    fIDField
                                                    write   fIDField
                                                    default 0;

    property OnAdd: TNotifyEvent                    read    fOnAdd
                                                    write   fOnAdd;

    property OnAddAll: TNotifyEvent                 read    fOnAddAll
                                                    write   fOnAddAll;

    property OnRemove: TNotifyEvent                 read    fOnRemove
                                                    write   fOnRemove;

    property OnRemoveAll: TNotifyEvent              read    fOnRemoveAll
                                                    write   fOnRemoveAll;

    property OnSplitterMove: TNotifyEvent           read    fOnSplitterMove
                                                    write   fOnSplitterMove;

    property OnUpdateButtons: TCCRSelectorUpdateButtonsEvent
                                                    read    fOnUpdateButtons
                                                    write   fOnUpdateButtons;

    property SourcePanel: TPanel                    read    fSourcePanel;

    property SplitPos: TSplitPos                    read    fSplitPos
                                                    write   setSplitPos
                                                    default 50;

    property Splitter: TSplitter                    read    fSplitter;

    property SplitterPanel: TPanel                  read    fSplitterPanel;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    procedure Add; virtual;
    procedure AddAll; virtual;
    procedure Clear; virtual;
    procedure LoadLayout(aStorage: TOvcAbstractStore; aSection: String = ''); virtual;
    procedure Remove; virtual;
    procedure RemoveAll; virtual;
    procedure SaveLayout(aStorage: TOvcAbstractStore; aSection: String = ''); virtual;
    procedure UpdateButtons;

    property ResultChanged: Boolean                 read    fResultChanged
                                                    write   fResultChanged;

  end;

  TCCRSelectorList = class(TCCRGridView)
  protected
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
  end;

  TCCRSourceList = class(TCCRSelectorList)
  protected
    procedure DblClick; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

  end;

implementation

uses
  Forms, SysUtils, StdCtrls, uROR_Resources, ActnList, Windows;

/////////////////////////////// TCCRCustomSelector \\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRCustomSelector.Create(anOwner: TComponent);
var
  bl: Integer;
begin
  inherited;

  LoadCCRSelectorResources;

  AutoSize   := False;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Caption    := '';
  DockSite   := False;

  Constraints.MinHeight := CCRSelButtonSize * 4;
  Constraints.MinWidth  := CCRSelSplitterWidth * 3;

  fAddRemoveMode := armDefault;
  fAutoSort      := True;
  fResultChanged := False;
  fSourcePanel   := TPanel.Create(Self);
  fSplitter      := TSplitter.Create(Self);
  fSplitterPanel := TPanel.Create(Self);

  fSourceList    := CreateSourceList;
  fResultList    := CreateResultList;
  fFocusedList   := fSourceList;

  fAdd           := TSpeedButton.Create(Self);
  fAddAll        := TSpeedButton.Create(Self);
  fRemove        := TSpeedButton.Create(Self);
  fRemoveAll     := TSpeedButton.Create(Self);

  DisableAlign;
  try
    with SourcePanel do
      begin
        Parent := Self;

        Align       := alLeft;
        BevelInner  := bvNone;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Left        := 0;
        ParentColor := True;
        Top         := 0;
      end;

    with SourceList do
      begin
        SetSubComponent(True);
        Constraints.MinWidth := CCRSelSplitterWidth;
        Parent := SourcePanel;

        Align       := alClient;
        DragKind    := dkDrag;
        DragMode    := dmAutomatic;
        Left        := 0;
        Name        := 'SourceList';
        TabStop     := True;
        Top         := 0;
      end;

    with SplitterPanel do
      begin
        Parent := SourcePanel;

        Align       := alRight;
        BevelInner  := bvNone;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Left        := SourceList.Width;
        ParentColor := True;
        Top         := 0;
        Width       := CCRSelSplitterWidth;
      end;

    with ResultList do
      begin
        SetSubComponent(True);
        Constraints.MinWidth := CCRSelSplitterWidth;
        Parent := Self;

        Align       := alClient;
        DragKind    := dkDrag;
        DragMode    := dmAutomatic;
        Left        := Splitter.Left + Splitter.Width;
        Name        := 'ResultList';
        TabStop     := True;
        Top         := 0;
      end;


    with Splitter do
      begin
        Parent := Self;
        
        Align       := alLeft;
        Beveled     := True;
        Left        := SourcePanel.Width;
        OnMoved     := SplitterMoved;
        Top         := 0;
      end;

    bl := (CCRSelSplitterWidth - CCRSelButtonSize) div 2;

    with fAdd do
      begin
        SetSubComponent(True);
        Parent := SplitterPanel;

        Action := TAction.Create(Self);
        Action.OnExecute := buttonOnAdd;
        Action.OnUpdate  := ActionUpdate;

        Flat      := True;
        Glyph     := bmAdd;
        Height    := CCRSelButtonSize;
        Hint      := rscAddHint;
        Left      := bl;
        NumGlyphs := 2;
        ShowHint  := True;
        Top       := 10;
        Visible   := False;
        Width     := CCRSelButtonSize;
      end;

    with fRemove do
      begin
        SetSubComponent(True);
        Parent := SplitterPanel;

        Action := TAction.Create(Self);
        Action.OnExecute := buttonOnRemove;
        Action.OnUpdate  := ActionUpdate;

        Flat      := True;
        Glyph     := bmRemove;
        Height    := CCRSelButtonSize;
        Hint      := rscRemoveHint;
        Left      := bl;
        NumGlyphs := 2;
        ShowHint  := True;
        Top       := 10;
        Visible   := False;
        Width     := CCRSelButtonSize;
      end;

    with fAddAll do
      begin
        SetSubComponent(True);
        Parent := SplitterPanel;

        Action := TAction.Create(Self);
        Action.OnExecute := buttonOnAddAll;
        Action.OnUpdate  := ActionUpdate;

        Flat      := True;
        Glyph     := bmAddAll;
        Height    := CCRSelButtonSize;
        Hint      := rscAddAllHint;
        Left      := bl;
        NumGlyphs := 2;
        ShowHint  := True;
        Top       := fAdd.Top + CCRSelButtonSize;
        Width     := CCRSelButtonSize;
      end;

    with fRemoveAll do
      begin
        SetSubComponent(True);
        Parent := SplitterPanel;

        Action := TAction.Create(Self);
        Action.OnExecute := buttonOnRemoveAll;
        Action.OnUpdate  := ActionUpdate;

        Flat      := True;
        Glyph     := bmRemoveAll;
        Height    := CCRSelButtonSize;
        Hint      := rscRemoveAllHint;
        Left      := bl;
        NumGlyphs := 2;
        ShowHint  := True;
        Top       := fAddAll.Top + CCRSelButtonSize;
        Width     := CCRSelButtonSize;
      end;
  finally
    EnableAlign;
  end;

  SplitPos := 50;
  UpdateButtons;
end;

destructor TCCRCustomSelector.Destroy;
begin
  fAdd.Glyph        := nil;
  fAddAll.Glyph     := nil;
  fRemove.Glyph     := nil;
  fRemoveAll.Glyph  := nil;

  fAdd.Action.Free;
  fAddAll.Action.Free;
  fRemove.Action.Free;
  fRemoveAll.Action.Free;

  fAdd.Action       := nil;
  fAddAll.Action    := nil;
  fRemove.Action    := nil;
  fRemoveAll.Action := nil;

  FreeAndNil(fAdd);
  FreeAndNil(fAddAll);
  FreeAndNil(fRemove);
  FreeAndNil(fRemoveAll);

  FreeAndNil(fSplitterPanel);
  FreeAndNil(fSourcePanel);
  FreeAndNil(fSplitter);

  FreeAndNil(fSourceList);
  FreeAndNil(fResultList);

  inherited;
end;

procedure TCCRCustomSelector.ActionUpdate(aSender: TObject);
begin
  UpdateButtons;
end;

procedure TCCRCustomSelector.Add;
begin
end;

procedure TCCRCustomSelector.AddAll;
begin
end;

procedure TCCRCustomSelector.AdjustControls;
var
  wd: Integer;
begin
  wd := Trunc((Width - CCRSelSplitterWidth - Splitter.Width) * SplitPos / 100);
  SourcePanel.Width := wd + CCRSelSplitterWidth;
  SourceList.Width := wd;  // Just in case
end;

procedure TCCRCustomSelector.buttonOnAdd(aSender: TObject);
begin
  Add;
end;

procedure TCCRCustomSelector.buttonOnAddAll(aSender: TObject);
begin
  AddAll;
end;

procedure TCCRCustomSelector.buttonOnRemove(aSender: TObject);
begin
  Remove;
end;

procedure TCCRCustomSelector.buttonOnRemoveAll(aSender: TObject);
begin
  RemoveAll;
end;

procedure TCCRCustomSelector.Clear;
begin
end;

function TCCRCustomSelector.CreateResultList: TWinControl;
begin
  Result := nil;
end;

function TCCRCustomSelector.CreateSourceList: TWinControl;
begin
  Result := nil;
end;

procedure TCCRCustomSelector.CreateWnd;
begin
  inherited;
  AdjustControls;
end;

procedure TCCRCustomSelector.DoEnter;
begin
  if Assigned(SourceList) then
    begin
      if SourceList.Focused then
        Exit;
      if Assigned(ResultList) and ResultList.Focused then
        Exit;
      SourceList.SetFocus;
    end;
  inherited;
end;

procedure TCCRCustomSelector.DoUpdateButtons(var EnableAdd, EnableAddAll,
  EnableRemove, EnableRemoveAll: Boolean);
begin
end;

function TCCRCustomSelector.GetListItemFollowingSelection(aLastItem: TListItem): TListItem;
begin
  Result := nil;
  if Assigned(aLastItem.ListView) then
    with aLastItem.ListView do
      if SelCount > 0 then
        begin
          //--- Find the last selected item
          Result := aLastItem;
          if not Result.Selected then
            Result := GetNextItem(Result, sdAbove, [isSelected]);
          //--- Find the next non-selected item
          if Assigned(Result) then
            begin
              Result := GetNextItem(Result, sdBelow, [isNone]);
              if Assigned(Result) and Result.Selected then
                Result := nil;
            end;
        end;
end;

function TCCRCustomSelector.GetResultControl: TWinControl;
begin
  Result := fResultList;
end;

function TCCRCustomSelector.GetSourceControl: TWinControl;
begin
  Result := fSourceList;
end;

procedure TCCRCustomSelector.LoadLayout(aStorage: TOvcAbstractStore; aSection: String);
begin
end;

procedure TCCRCustomSelector.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited;
  if AOperation = opRemove then
    if AComponent = SourceList then
      fSourceList := nil
    else if AComponent = ResultList then
      fResultList := nil
end;

procedure TCCRCustomSelector.Remove;
begin
end;

procedure TCCRCustomSelector.RemoveAll;
begin
end;

procedure TCCRCustomSelector.Resize;
begin
  SplitPos := SplitPos;
  inherited;
end;

procedure TCCRCustomSelector.SaveLayout(aStorage: TOvcAbstractStore; aSection: String);
begin
end;

procedure TCCRCustomSelector.SetEnabled(aValue: Boolean);
begin
  inherited;
  if Assigned(ResultList) then
    ResultList.Enabled := aValue;
  if Assigned(SourceList) then
    SourceList.Enabled := aValue;
end;

procedure TCCRCustomSelector.setSplitPos(const aValue: TSplitPos);
begin
  if aValue < 0 then fSplitPos := 0
  else if aValue > 100 then fSplitPos := 100
  else fSplitPos := aValue;

  AdjustControls;

  if Assigned(OnSplitterMove) then
    OnSplitterMove(Self);
end;

procedure TCCRCustomSelector.SplitterMoved(aSender: TObject);
begin
  if (Width <> 0) and Assigned(SourceList) then
    begin
      fSplitPos := Trunc(SourceList.Width / (Width - CCRSelSplitterWidth - Splitter.Width) * 100);
      if Assigned(OnSplitterMove) then
        OnSplitterMove(Self);
    end;
end;

procedure TCCRCustomSelector.UpdateButtons;
var
  EnableAdd, EnableAddAll, EnableRemove, EnableRemoveAll: Boolean;
begin
  EnableAdd       := False;
  EnableAddAll    := False;
  EnableRemove    := False;
  EnableRemoveAll := False;

  if Enabled then
    begin
      DoUpdateButtons(EnableAdd, EnableAddAll, EnableRemove, EnableRemoveAll);
      if Assigned(OnUpdateButtons) then
        OnUpdateButtons(Self, EnableAdd, EnableAddAll, EnableRemove, EnableRemoveAll);
    end;

  if SourceList.ContainsControl(Screen.ActiveControl) then
    begin
      fAdd.Visible    := True;
      fRemove.Visible := False;
    end
  else if ResultList.ContainsControl(Screen.ActiveControl) then
    begin
      fAdd.Visible    := False;
      fRemove.Visible := True;
    end
  else
    begin
      fRemove.Visible := False;
      fAdd.Visible    := False;
    end;

  fAdd.Enabled        := EnableAdd;
  fAddAll.Enabled     := EnableAddAll;
  fRemove.Enabled     := EnableRemove;
  fRemoveAll.Enabled  := EnableRemoveAll;
end;

//////////////////////////////// TCCRSelectortList \\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRSelectorList.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if Source <> Self then
    if (Source is TControl) and (TControl(Source).Owner = Owner) then
      begin
        Accept := True;
        if Assigned(OnDragOver) then
          inherited;
      end;
end;

///////////////////////////////// TCCRSourceList \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRSourceList.DblClick;
begin
  inherited;
  if Assigned(Owner) and (Owner is TCCRCustomSelector) then
    TCCRCustomSelector(Owner).Add;
end;

procedure TCCRSourceList.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Source <> Self then
    if (Source is TControl) and (TControl(Source).Owner = Owner) then
      if Assigned(Owner) and (Owner is TCCRCustomSelector) then
        TCCRCustomSelector(Owner).Remove;
end;

procedure TCCRSourceList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Shift = [] then
    if (Key = VK_RETURN) or (Key = Word(' ')) then
      if Assigned(Owner) and (Owner is TCCRCustomSelector) then
        TCCRCustomSelector(Owner).Add;
end;

end.
