unit ORCtrls.ActivityLog;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Menus,
  Vcl.StdCtrls,
  Winapi.Windows;

type
  TORActivityLog = class(TObject)
  private const
    OutputLineSize = 120;
    DefaultIndentLength = 2;
    SelfText = 'Self';
    BeginText = 'Begin';
    EndText = 'End; ';
    Gap = ' ';
  protected type
    TLogType = (ltActivity, ltMesssage);

    TBase = class(TObject)
    public
      // Makes sure Self and Obj both exist and have the same class
      function Equals(Obj: TObject): Boolean; override;
    end;

    TComponentInfo = class(TBase)
    strict private
      FTitle: string;
      FName: string;
      FComponentClass: TClass;
    public
      function Clone: TComponentInfo; virtual;
      constructor Create(Component: TComponent);
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
      property Title: string read FTitle write FTitle;
      property Name: string read FName;
      property ComponentClass: TClass read FComponentClass;
    end;

    TCaptionedComponentInfo = class(TComponentInfo)
    strict private
      FCaption: string;
    public
      function Clone: TComponentInfo; override;
      constructor Create(Component: TComponent);
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
      property Caption: string read FCaption;
    end;

    TParentType = (ptParent, ptFrame, ptSubForm, ptForm);

    TParentInfo = class(TComponentInfo)
    private const
      ParentTitles: array [TParentType] of string = ('.Parent', '.Frame',
        '.SubForm', '.Form');
    strict private
      FParentType: TParentType;
    public
      function Clone: TComponentInfo; override;
      constructor Create(Component: TComponent; AParentType: TParentType);
      function Equals(Obj: TObject): Boolean; override;
      property ParentType: TParentType read FParentType;
    end;

    TParents = class(TObjectList<TParentInfo>)
    public
      function Clone: TParents;
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
    end;

    // All the information used to represent a single component
    TComponentData = class(TBase)
    strict private
      FComponent: TCaptionedComponentInfo;
      FOwner: TComponentInfo;
      FParents: TParents;
    public
      function Clone: TComponentData;
      // ATitle is the title for the Component piece of the data
      constructor Create(AComponent: TComponent; ATitle: string = '');
      destructor Destroy; override;
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
    end;

    TActionType = class(TObject)
    strict private
      FLogType: TLogType;
      FPath: string;
    public
      constructor Create(APath: string; ALogType: TLogType = ltActivity);
      property LogType: TLogType read FLogType;
      property Path: string read FPath write FPath;
    end;

    TActionType<T> = class(TActionType)
    private type
      PTrampoline = ^T;
    private
      FTrampoline: Pointer;
      function GetTrampoline: T;
    public
      constructor Create(APath: string;
        const TargetProc, InterceptProc: Pointer;
        ALogType: TLogType = ltActivity);
      destructor Destroy; override;
      property Trampoline: T read GetTrampoline;
    end;

    TActionTypes = TObjectList<TActionType>;

    TActivity = class;

    TAction = class(TBase)
    strict private
      FActionType: TActionType;
      FActivity: TActivity;
      FValue: string;
    protected
      property Activity: TActivity read FActivity write FActivity;
    public
      function Clone: TAction;
      constructor Create(AActionType: TActionType; AValue: string = '');
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
      property ActionType: TActionType read FActionType;
      property Value: string read FValue write FValue;
    end;

    TMsgInfo = class;

    TActivity = class(TBase)
    strict private
      FAction: TAction;
      FActivityID: Int64;
      FMessage: TMsgInfo;
      FComponentData: TComponentData;
      FCount: Integer;
    protected
      procedure UpdateComponent;
      property Message: TMsgInfo read FMessage write FMessage;
      property ComponentData: TComponentData read FComponentData
        write FComponentData;
    public
      function Clone: TActivity;
      constructor Create(AAction: TAction; AComponent: TComponent;
        AComponentTitle: string = ''; AMessage: TMsgInfo = nil); overload;
      destructor Destroy; override;
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
      property Action: TAction read FAction;
      property ActivityID: Int64 read FActivityID;
      property Count: Integer read FCount write FCount;
    end;

    TInternalLog = class;
    TLogActivityEvent = procedure(Sender: TInternalLog; Activity: TActivity)
      of object;

    TInternalLog = class(TObject)
    strict private
      FActivities: TObjectList<TActivity>;
      FMaxSize: Integer;
      FOnLogEvent: TLogActivityEvent;
      function GetCount: Integer;
      procedure SetMaxSize(const Value: Integer);
    private
      function GetItems(Index: Integer): TActivity;
    public
      constructor Create;
      destructor Destroy; override;
      function Add(AActionType: TActionType; AValue: string;
        AComponent: TComponent; AComponentTitle: string = '';
        AMessage: TMsgInfo = nil): TActivity;
      procedure MergeActivities(OldActivity, NewActivity: TActivity);
      property Items[Index: Integer]: TActivity read GetItems; default;
      property Count: Integer read GetCount;
      property MaxSize: Integer read FMaxSize write SetMaxSize;
      property OnLogEvent: TLogActivityEvent read FOnLogEvent write FOnLogEvent;
    end;

    // TInternalLog.AddActivity combines the last activity in the Log (and
    // increments it's Count property) when the TActivity.Equals function return
    // True for the new activity being added.  This in turn calls any needed
    // TAction.Equals, TMsgInfo.Equals, and TComponentData.Equals functions.
    // TMsgInfo.Equals can behave differently than other Equals functions.
    // TMsgInfo.Equals is normally True when the Msg field's message, hwnd,
    // wParam and lParam values are all the same.  However, if
    // FDuplicateMessageType is True, TMsgInfo.Equals is True if just the
    // Msg.message value is the same.  FDuplicateMessageType is set to True for
    // a small subset of messages defined in the DUPLICATE_MESSAGE_TYPES
    // constant found in TMsgInfo.Create.  When FDuplicateMessageType is True,
    // the FMultHwnd, FMultWParams and FMultLParams fields (all TMsgMultType
    // types) are used to determine if the TMsgInfo object represents all the
    // combined message values, or just the last one.  The values of
    // TMsgMultType are:
    // mtNone: represents a single message.
    // mtAll:  all values are the same.
    // mtLast: some values differ from the previous values.  In this case,
    // the field shows the value of the last incoming message.
    // For duplicate message types, mtAll adds a '.All' to the field name, and
    // mtLast adds a '.Last' to the field name.  For example, hwnd.All = $12345
    // means all the messages were sent to the same component.

    TMsgMultType = (mtNone, mtAll, mtLast);

    TMsgInfo = class(TBase)
    strict private
      FDuplicateMessageType: Boolean;
      FMultHwnd: TMsgMultType;
      FMultWParams: TMsgMultType;
      FMultLParams: TMsgMultType;
    private
      FMsg: TMsg;
      function MultStr(Mult: TMsgMultType): string;
    public
      function Clone: TMsgInfo;
      constructor Create(AMsg: TMsg);
      function Equals(Obj: TObject): Boolean; override;
      function ToString: string; override;
      property Msg: TMsg read FMsg write FMsg;
      property MultHwnd: TMsgMultType read FMultHwnd write FMultHwnd;
      property MultWParams: TMsgMultType read FMultWParams write FMultWParams;
      property MultLParams: TMsgMultType read FMultLParams write FMultLParams;
    end;

  private type
    TMenuClickTrampoline = procedure(Self: TMenuItem);
    TActionExecuteTrampoline = function(Self: TBasicAction): Boolean;
    TControlChangedTrampoline = procedure(Self: TControl);
    TControlClickTrampoline = procedure(Self: TControl);
    TControlDblClickTrampoline = procedure(Self: TControl);
    TTabChangeTrampoline = procedure(Self: TCustomTabControl);
    TTreeViewChangeTrampoline = procedure(Self: TCustomTreeView;
      Node: TTreeNode);
    TListViewChangeTrampoline = procedure(Self: TCustomListView;
      Item: TListItem; Change: Integer);
    TTrackBarChangedTrampoline = procedure(Self: TTrackBar);
    TDateTimePickerChangeTrampoline = procedure(Self: TDateTimePicker);
    TFormCreateTrampoline = procedure(Self: TCustomForm);
    TFormCloseQueryTrampoline = function(Self: TCustomForm): Boolean;
    TFormDoCloseTrampoline = procedure(Self: TCustomForm;
      var Action: TCloseAction);
    TFormDestroyTrampoline = procedure(Self: TCustomForm);
    TDispatchMessageATrampoline = function(const lpMsg: TMsg): Longint; stdcall;
    TDispatchMessageWTrampoline = function(const lpMsg: TMsg): Longint; stdcall;

    TFormAccess = class(TCustomForm);
    TControlAccess = class(TControl);
    TButtonControlAccess = class(TButtonControl);
    TCustomTabControlAccess = class(TCustomTabControl);
    TCustomTreeViewAccess = class(TCustomTreeView);
    TCustomListViewAccess = class(TCustomListView);
    TTrackBarAccess = class(TTrackBar);
    TDateTimePickerAccess = class(TDateTimePicker);
  private
    FThreadHandle: THandle;
    FActionTypes: TActionTypes;
    FInternalLogs: array [TLogType] of TInternalLog;
    FRunning: array [TLogType] of Boolean;
    FActivityID: Int64;
    FIndentLen: Integer;
    FMenuClick: TActionType<TMenuClickTrampoline>;
    FActionExecute: TActionType<TActionExecuteTrampoline>;
    FControlChanged: TActionType<TControlChangedTrampoline>;
    FControlClick: TActionType<TControlClickTrampoline>;
    FControlDblClick: TActionType<TControlDblClickTrampoline>;
    FTabChange: TActionType<TTabChangeTrampoline>;
    FTreeViewChange: TActionType<TTreeViewChangeTrampoline>;
    FListViewChange: TActionType<TListViewChangeTrampoline>;
    FTrackBarChanged: TActionType<TTrackBarChangedTrampoline>;
    FDateTimePickerChange: TActionType<TDateTimePickerChangeTrampoline>;
    FFormCreate: TActionType<TFormCreateTrampoline>;
    FFormCloseQuery: TActionType<TFormCloseQueryTrampoline>;
    FFormDoClose: TActionType<TFormDoCloseTrampoline>;
    FFormDestroy: TActionType<TFormDestroyTrampoline>;
    FDispatchMessageA: TActionType<TDispatchMessageATrampoline>;
    FDispatchMessageW: TActionType<TDispatchMessageWTrampoline>;
    procedure BeginAddingText(InitialText: string = '';
      Nesting: Boolean = False);
    class constructor Create;
    class destructor Destroy;
    class procedure InterceptMenuClick(Self: TMenuItem); static;
    class function InterceptActionExecute(Self: TBasicAction): Boolean; static;
    class procedure InterceptControlChanged(Self: TControl); static;
    class procedure InterceptControlClick(Self: TControl); static;
    class procedure InterceptControlDblClick(Self: TControl); static;
    class procedure InterceptTabChange(Self: TCustomTabControl); static;
    class procedure InterceptTreeViewChange(Self: TCustomTreeView;
      Node: TTreeNode); static;
    class procedure InterceptListViewChange(Self: TCustomListView;
      Item: TListItem; Change: Integer); static;
    class procedure InterceptTrackBarChanged(Self: TTrackBar); static;
    class procedure InterceptDateTimePickerChange
      (Self: TDateTimePicker); static;
    class procedure InterceptFormCreate(Self: TCustomForm); static;
    class function InterceptFormCloseQuery(Self: TCustomForm): Boolean; static;
    class procedure InterceptFormDoClose(Self: TCustomForm;
      var Action: TCloseAction); static;
    class procedure InterceptFormDestroy(Self: TCustomForm); static;
    class function InterceptDispatchMessageA(const lpMsg: TMsg): Longint;
      stdcall; static;
    class function InterceptDispatchMessageW(const lpMsg: TMsg): Longint;
      stdcall; static;
    function Matches(Obj1, Obj2: TObject): Boolean;
    function UpdateLog(AActionType: TActionType; AValue: string;
      AComponent: TComponent; AComponentTitle: string = '';
      AMessage: TMsgInfo = nil): TActivity;
    function UpdateLogBegin(AActionType: TActionType; AComponent: TComponent;
      AComponentTitle: string = ''; AMessage: TMsgInfo = nil): Int64;
    procedure UpdateLogEnd(LastActivityID: Int64; AActionType: TActionType;
      AValue: string; AComponent: TComponent; AComponentTitle: string;
      AMessage: TMsgInfo = nil);
    procedure Start(ALogType: TLogType);
    procedure Stop(ALogType: TLogType);
    function ThreadSafe: Boolean;
  public type
    TLogWrapper = class(TObject)
    private
      FLogType: TLogType;
      function GetCount: Integer;
      function GetItems(Index: Integer): string;
      function GetLogActivityEvent: TLogActivityEvent;
      function GetRunning: Boolean;
      function GetMaxSize: Integer;
      procedure SetLogActivityEvent(const Value: TLogActivityEvent);
      procedure SetMaxSize(const Value: Integer);
    public
      /// <summary>The current number of entries in the log</summary>
      property Count: Integer read GetCount;
      /// <summary>The maximum number of entries to keep in the log</summary>
      property MaxSize: Integer read GetMaxSize write SetMaxSize;
      /// <summary>The strings representing a given entry in the log</summary>
      /// <param name="Index">[<see cref="system|Integer"/>]
      /// The index of the item in the log (from 0 to Count - 1</param>
      property Items[Index: Integer]: string read GetItems; default;
      /// <summary>True if the log is currently running.  To turn off the log set
      /// the size to 0</summary>
      property Running: Boolean read GetRunning;
      property OnLogEvent: TLogActivityEvent read GetLogActivityEvent
        write SetLogActivityEvent;
    end;
  private
  class var
    FActivityLog: TORActivityLog;
    FMessageLogWrapper: TLogWrapper;
    FActivityLogWrapper: TLogWrapper;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>Returns detailed component name, class type and parent
    /// information</summary>
    /// <param name="Component">[<see cref="system.classes|TComponent"/>]
    /// The Component being described</param>
    /// <param name="InitialText (Optional)">[<see cref="system|string"/>]
    /// Any initial text describing the component</param>
    /// <returns>[<see cref="system|string"/>]
    /// - Wrapped text describing the component</returns>
    class function ComponentDescription(Component: TComponent;
      InitialText: string = ''): string;
    class property ActivityLog: TORActivityLog.TLogWrapper
      read FActivityLogWrapper;
    class property MessageLog: TORActivityLog.TLogWrapper
      read FMessageLogWrapper;
  end;

implementation

uses
  System.Actions,
  System.SysUtils,
  System.TypInfo,
  Winapi.Messages,
  DDetours,
  UTextWrapper,
  UWinMsgNames;

{ TORActivityLog.TBase }

function TORActivityLog.TBase.Equals(Obj: TObject): Boolean;
begin
  Result := Assigned(Self) and Assigned(Obj) and (ClassType = Obj.ClassType);
end;

{ TORActivityLog.TComponentInfo }

function TORActivityLog.TComponentInfo.Clone: TComponentInfo;
begin
  Result := Self.ClassType.Create as TComponentInfo;
  Result.FTitle := FTitle;
  Result.FName := FName;
  Result.FComponentClass := FComponentClass;
end;

constructor TORActivityLog.TComponentInfo.Create(Component: TComponent);
begin
  inherited Create;
  if Assigned(Component) then
  begin
    FComponentClass := Component.ClassType;
    FName := Component.Name;
  end;
end;

function TORActivityLog.TComponentInfo.Equals(Obj: TObject): Boolean;
begin
  Result := inherited and (FTitle = TComponentInfo(Obj).FTitle) and
    (FName = TComponentInfo(Obj).FName) and
    (FComponentClass = TComponentInfo(Obj).ComponentClass);
end;

function TORActivityLog.TComponentInfo.ToString: string;
begin
  if Assigned(FComponentClass) then
  begin
    if FTitle <> '' then
      Result := FTitle + ' = '
    else
      Result := '';
    if FName <> '' then
      Result := Result + FName + ': ';
    Result := Result + FComponentClass.ClassName + ';';
  end
  else
    Result := 'nil;';
end;

{ TORActivityLog.TCaptionedComponentInfo }

function TORActivityLog.TCaptionedComponentInfo.Clone: TComponentInfo;
begin
  Result := Inherited Clone;
  TCaptionedComponentInfo(Result).FCaption := FCaption;
end;

constructor TORActivityLog.TCaptionedComponentInfo.Create
  (Component: TComponent);
begin
  inherited;
  if (Component is TMenuItem) or (Component is TContainedAction) then
    FCaption := StripHotKey(GetStrProp(Component, 'Caption'));
end;

function TORActivityLog.TCaptionedComponentInfo.Equals(Obj: TObject): Boolean;
begin
  Result := inherited and (FCaption = TCaptionedComponentInfo(Obj).FCaption);
end;

function TORActivityLog.TCaptionedComponentInfo.ToString: string;
begin
  Result := inherited;
  if FCaption <> '' then
    Result := Result + Gap + '.Caption = "' + FCaption + '";';
end;

{ TORActivityLog.TParentInfo }

function TORActivityLog.TParentInfo.Clone: TComponentInfo;
begin
  Result := Inherited Clone;
  TParentInfo(Result).FParentType := FParentType;
end;

constructor TORActivityLog.TParentInfo.Create(Component: TComponent;
  AParentType: TParentType);
begin
  inherited Create(Component);
  FParentType := AParentType;
  Title := ParentTitles[AParentType];
end;

function TORActivityLog.TParentInfo.Equals(Obj: TObject): Boolean;
begin
  Result := inherited and (FParentType = TParentInfo(Obj).FParentType);
end;

{ TORActivityLog.TParents }

function TORActivityLog.TParents.Clone: TParents;
var
  i: Integer;
begin
  Result := TParents.Create;
  Result.OwnsObjects := OwnsObjects;
  for i := 0 to Count - 1 do
    Result.Add(Items[i].Clone as TParentInfo);
end;

function TORActivityLog.TParents.Equals(Obj: TObject): Boolean;
var
  i: Integer;
  AParents: TParents;
begin
  Result := Assigned(Self) and Assigned(Obj) and (ClassType = Obj.ClassType);
  if Result then
  begin
    AParents := TParents(Obj);
    Result := Count = AParents.Count;
    if Result then
      for i := 0 to Count - 1 do
        if not Items[i].Equals(AParents[i]) then
        begin
          Result := False;
          break;
        end;
  end;
end;

function TORActivityLog.TParents.ToString: string;
var
  i: Integer;
begin
  FActivityLog.BeginAddingText;
  try
    for i := 0 to Count - 1 do
      TTextWrapper.Add(Items[i].ToString, Gap);
  finally
    Result := TTextWrapper.RetrieveTextEndWrapping;
  end;
end;

{ TORActivityLog.TComponentData }

function TORActivityLog.TComponentData.Clone: TComponentData;
begin
  Result := Self.ClassType.Create as TComponentData;
  if Assigned(FComponent) then
    Result.FComponent := FComponent.Clone as TCaptionedComponentInfo;
  if Assigned(FOwner) then
    Result.FOwner := FOwner.Clone;
  if Assigned(FParents) then
    Result.FParents := FParents.Clone;
end;

constructor TORActivityLog.TComponentData.Create(AComponent: TComponent;
  ATitle: string);
var
  Parent: TControl;
  NeedParent: Boolean;
  ParentType: TParentType;
begin
  FComponent := TCaptionedComponentInfo.Create(AComponent);
  FComponent.Title := ATitle;
  FParents := TParents.Create;
  if (AComponent is TControl) then
  begin
    NeedParent := (AComponent.Name = '');
    Parent := TControl(AComponent);
    while Assigned(Parent) do
    begin
      Parent := Parent.Parent;
      if Assigned(Parent) then
      begin
        if NeedParent and (Parent.Name <> '') then
        begin
          FParents.Add(TParentInfo.Create(Parent, ptParent));
          NeedParent := False;
        end;
        if Parent is TCustomFrame then
          FParents.Add(TParentInfo.Create(Parent, ptFrame))
        else if Parent is TCustomForm then
        begin
          if Assigned(Parent.Parent) then
            ParentType := ptSubForm
          else
            ParentType := ptForm;
          FParents.Add(TParentInfo.Create(Parent, ParentType));
        end;
      end;
    end;
  end;
  if Assigned(AComponent.Owner) and (FParents.Count = 0) then
  begin
    FOwner := TComponentInfo.Create(AComponent.Owner);
    FOwner.Title := '.Owner';
  end;
end;

destructor TORActivityLog.TComponentData.Destroy;
begin
  FreeAndNil(FComponent);
  FreeAndNil(FOwner);
  FreeAndNil(FParents);
  inherited;
end;

function TORActivityLog.TComponentData.Equals(Obj: TObject): Boolean;
var
  AComponentData: TComponentData;
begin
  Result := inherited;
  if Result then
  begin
    AComponentData := TComponentData(Obj);
    Result := FActivityLog.Matches(FComponent, AComponentData.FComponent) and
      FActivityLog.Matches(FOwner, AComponentData.FOwner) and
      FActivityLog.Matches(FParents, AComponentData.FParents);
  end;
end;

function TORActivityLog.TComponentData.ToString: string;

  procedure Add(Obj: TObject);
  begin
    if Assigned(Obj) then
      TTextWrapper.Add(Obj.ToString, Gap);
  end;

begin
  FActivityLog.BeginAddingText;
  try
    Add(FComponent);
    Add(FOwner);
    Add(FParents);
  finally
    Result := TTextWrapper.RetrieveTextEndWrapping;
  end;
end;

{ TORActivityLog.TActionType }

constructor TORActivityLog.TActionType.Create(APath: string;
  ALogType: TLogType = ltActivity);
var
  Max: Integer;
begin
  Max := (OutputLineSize div 2) - Length(Gap) - 2;
  if Length(APath) > Max then
    raise EArgumentException.CreateFmt
      ('%s.Create APath can not exceed a length of %i.', [ClassName, Max]);
  inherited Create;
  FPath := APath;
  FLogType := ALogType;
  FActivityLog.FActionTypes.Add(Self);
end;

{ TORActivityLog.TActionType<T> }

constructor TORActivityLog.TActionType<T>.Create(APath: string;
  const TargetProc, InterceptProc: Pointer; ALogType: TLogType);
begin
  Inherited Create(APath, ALogType);
  FTrampoline := InterceptCreate(TargetProc, InterceptProc);
end;

destructor TORActivityLog.TActionType<T>.Destroy;
begin
  InterceptRemove(FTrampoline);
  inherited;
end;

function TORActivityLog.TActionType<T>.GetTrampoline: T;
begin
  Result := PTrampoline(@FTrampoline)^;
end;

{ TORActivityLog.TAction }

function TORActivityLog.TAction.Clone: TAction;
begin
  Result := TAction.Create(FActionType, FValue);
end;

constructor TORActivityLog.TAction.Create(AActionType: TActionType;
  AValue: string);
begin
  inherited Create;
  FActionType := AActionType;
  FValue := AValue;
end;

function TORActivityLog.TAction.Equals(Obj: TObject): Boolean;
begin
  Result := inherited and (FActionType = TAction(Obj).FActionType) and
    (FValue = TAction(Obj).FValue);
end;

function TORActivityLog.TAction.ToString: string;
begin
  FActivityLog.BeginAddingText;
  try
    if Assigned(FActivity) and (FActivity.Count > 1) then
      TTextWrapper.Add(FActivity.Count.ToString + ' times;', Gap);
    if FValue <> '' then
      TTextWrapper.Add(FValue + ';', Gap);
  finally
    Result := TTextWrapper.RetrieveTextEndWrapping;
  end;
end;

{ TORActivityLog.TActivity }

function TORActivityLog.TActivity.Clone: TActivity;
begin
  Result := Self.ClassType.Create as TActivity;
  if Assigned(FAction) then
  begin
    Result.FAction := FAction.Clone;
    Result.FAction.Activity := Result;
  end;
  Result.FActivityID := FActivityID;
  if Assigned(FMessage) then
    Result.FMessage := FMessage.Clone;
  if Assigned(FComponentData) then
    Result.FComponentData := FComponentData.Clone;
  Result.FCount := FCount;
end;

constructor TORActivityLog.TActivity.Create(AAction: TAction;
  AComponent: TComponent; AComponentTitle: string; AMessage: TMsgInfo);
begin
  if not Assigned(AAction) then
    raise EArgumentException.Create(ClassName + '.Create requires an Action.');
  FAction := AAction;
  FAction.Activity := Self;
  FCount := 1;
  if Assigned(AComponent) then
    FComponentData := TComponentData.Create(AComponent, AComponentTitle);
  if Assigned(AMessage) then
    FMessage := AMessage;
  Inc(FActivityLog.FActivityID);
  FActivityID := FActivityLog.FActivityID;
end;

destructor TORActivityLog.TActivity.Destroy;
begin
  FreeAndNil(FAction);
  FreeAndNil(FComponentData);
  FreeAndNil(FMessage);
  inherited;
end;

function TORActivityLog.TActivity.Equals(Obj: TObject): Boolean;
var
  Activity: TActivity;
begin
  Result := inherited;
  if Result then
  begin
    Activity := TActivity(Obj);
    // Dont include Count
    Result := FActivityLog.Matches(FAction, Activity.FAction) and
      FActivityLog.Matches(FMessage, Activity.FMessage);
    if Result and Assigned(FMessage) then;
    begin
      if (not Assigned(FComponentData)) and Assigned(Activity.ComponentData)
      then
        UpdateComponent;
      if Assigned(FComponentData) and (not Assigned(Activity.ComponentData))
      then
        Activity.UpdateComponent;
    end;
    Result := Result and FActivityLog.Matches(FComponentData,
      Activity.FComponentData);
  end;
end;

function TORActivityLog.TActivity.ToString: string;

  procedure Add(Obj: TObject);
  begin
    if Assigned(Obj) then
      TTextWrapper.Add(Obj.ToString, Gap);
  end;

begin
  FActivityLog.BeginAddingText(FAction.ActionType.Path + ' (', True);
  try
    UpdateComponent;
    Add(FAction);
    Add(FMessage);
    Add(FComponentData);
  finally
    Result := TrimRight(TTextWrapper.RetrieveTextEndWrapping);
  end;
  if Result.EndsWith(';') then
    Delete(Result, Length(Result), 1);
  if Result.EndsWith('(') then
    Delete(Result, Length(Result), 1)
  else
    Result := Result + ')';
end;

procedure TORActivityLog.TActivity.UpdateComponent;
var
  WinCtrl: TWinControl;
begin
  if Assigned(FMessage) and (not Assigned(FComponentData)) then
  begin
    WinCtrl := FindControl(FMessage.Msg.hwnd);
    if Assigned(WinCtrl) then
      FComponentData := TComponentData.Create(WinCtrl,
        'WinControl' + FMessage.MultStr(FMessage.MultHwnd));
  end;
end;

{ TORActivityLog.TInternalLog }

function TORActivityLog.TInternalLog.Add(AActionType: TActionType;
  AValue: string; AComponent: TComponent; AComponentTitle: string = '';
  AMessage: TMsgInfo = nil): TActivity;
var
  AActivity: TActivity;
  Duplicate: Boolean;
begin
  Duplicate := False;
  AActivity := TActivity.Create(TAction.Create(AActionType, AValue), AComponent,
    AComponentTitle, AMessage);
  try
    if (FActivities.Count > 0) and FActivities[FActivities.Count - 1]
      .Equals(AActivity) then
    begin
      Result := FActivities[FActivities.Count - 1];
      Duplicate := True;
      MergeActivities(Result, AActivity);
    end
    else
    begin
      Result := AActivity;
      FActivities.Add(AActivity);
      while FActivities.Count > FMaxSize do
        FActivities.Delete(0);
    end;
    if Assigned(Result) and Assigned(FOnLogEvent) then
      FOnLogEvent(Self, Result);
  finally
    if Duplicate then
      FreeAndNil(AActivity);
  end;
end;

constructor TORActivityLog.TInternalLog.Create;
begin
  inherited Create;
  FActivities := TObjectList<TActivity>.Create;
end;

destructor TORActivityLog.TInternalLog.Destroy;
begin
  FreeAndNil(FActivities);
  inherited;
end;

function TORActivityLog.TInternalLog.GetCount: Integer;
begin
  Result := FActivities.Count;
end;

function TORActivityLog.TInternalLog.GetItems(Index: Integer): TActivity;
begin
  Result := FActivities[Index];
end;

procedure TORActivityLog.TInternalLog.MergeActivities(OldActivity,
  NewActivity: TActivity);
var
  Msg1, Msg2: TMsgInfo;
begin
  OldActivity.Count := OldActivity.Count + 1;
  Msg1 := OldActivity.Message;
  Msg2 := NewActivity.Message;
  if Assigned(Msg1) and Assigned(Msg2) then
  begin
    if Msg1.Msg.hwnd <> Msg2.Msg.hwnd then
      Msg1.MultHwnd := mtLast
    else if Msg1.MultHwnd = mtNone then
      Msg1.MultHwnd := mtAll;
    Msg1.FMsg.hwnd := Msg2.Msg.hwnd;
    if Msg1.Msg.wParam <> Msg2.Msg.wParam then
      Msg1.MultWParams := mtLast
    else if Msg1.MultWParams = mtNone then
      Msg1.MultWParams := mtAll;
    Msg1.FMsg.wParam := Msg2.Msg.wParam;

    if Msg1.Msg.lParam <> Msg2.Msg.lParam then
      Msg1.MultLParams := mtLast
    else if Msg1.MultLParams = mtNone then
      Msg1.MultLParams := mtAll;
    Msg1.FMsg.lParam := Msg2.Msg.lParam;
  end;
end;

procedure TORActivityLog.TInternalLog.SetMaxSize(const Value: Integer);
begin
  FMaxSize := Value;
  if FMaxSize < 0 then
    FMaxSize := 0;
  While FActivities.Count > FMaxSize do
    FActivities.Delete(0);
  FActivities.Capacity := FMaxSize;
end;

{ TORActivityLog.TMsgInfo }

function TORActivityLog.TMsgInfo.Clone: TMsgInfo;
begin
  Result := TMsgInfo.Create(FMsg);
  Result.FMultHwnd := FMultHwnd;
  Result.FMultWParams := FMultWParams;
  Result.FMultLParams := FMultLParams;
end;

constructor TORActivityLog.TMsgInfo.Create(AMsg: TMsg);
const
  DUPLICATE_MESSAGE_TYPES: array of UINT = [WM_PAINT, WM_NCPAINT,
    WM_NCMOUSEMOVE, EM_SCROLL, EM_LINESCROLL, WM_HSCROLL, WM_VSCROLL,
    WM_MOUSEMOVE, WM_MOUSEWHEEL, WM_SIZING, WM_MOVING, WM_TIMER];
var
  i: Integer;
begin
  inherited Create;
  FMsg := AMsg;
  for i := Low(DUPLICATE_MESSAGE_TYPES) to High(DUPLICATE_MESSAGE_TYPES) do
    if FMsg.Message = DUPLICATE_MESSAGE_TYPES[i] then
    begin
      FDuplicateMessageType := True;
      break;
    end;
end;

function TORActivityLog.TMsgInfo.Equals(Obj: TObject): Boolean;
begin
  Result := inherited and (FMsg.Message = TMsgInfo(Obj).FMsg.Message) and
    (FDuplicateMessageType = TMsgInfo(Obj).FDuplicateMessageType);
  if Result and (not FDuplicateMessageType) then
    Result := (FMsg.hwnd = TMsgInfo(Obj).FMsg.hwnd) and
      (FMsg.wParam = TMsgInfo(Obj).FMsg.wParam) and
      (FMsg.lParam = TMsgInfo(Obj).FMsg.lParam);
end;

function TORActivityLog.TMsgInfo.MultStr(Mult: TMsgMultType): string;
begin
  Result := '';
  if FDuplicateMessageType then
    case Mult of
      mtAll:
        Result := '.All';
      mtLast:
        Result := '.Last';
    end;
end;

function TORActivityLog.TMsgInfo.ToString: string;
var
  Text: string;
begin
  FActivityLog.BeginAddingText;
  try
    Text := 'message = ' + TWinMsgNames.Name[Msg.Message] + ';';
    TTextWrapper.Add(Text, Gap);
    Text := Format('hwnd%s = $%x;', [MultStr(MultHwnd), Msg.hwnd]);
    TTextWrapper.Add(Text, Gap);
    Text := Format('wParam%s = $%x;', [MultStr(MultWParams), Msg.wParam]);
    TTextWrapper.Add(Text, Gap);
    Text := Format('lParam%s = $%x;', [MultStr(MultLParams), Msg.lParam]);
    TTextWrapper.Add(Text, Gap);
  finally
    Result := TTextWrapper.RetrieveTextEndWrapping;
  end;
end;

{ TORActivityLog.TLogWrapper }

function TORActivityLog.TLogWrapper.GetCount: Integer;
begin
  Result := FActivityLog.FInternalLogs[FLogType].Count;
end;

function TORActivityLog.TLogWrapper.GetItems(Index: Integer): string;
begin
  Result := FActivityLog.FInternalLogs[FLogType][Index].ToString;
end;

function TORActivityLog.TLogWrapper.GetLogActivityEvent: TLogActivityEvent;
begin
  Result := FActivityLog.FInternalLogs[FLogType].OnLogEvent;
end;

function TORActivityLog.TLogWrapper.GetRunning: Boolean;
begin
  Result := FActivityLog.FRunning[FLogType];
end;

function TORActivityLog.TLogWrapper.GetMaxSize: Integer;
begin
  Result := FActivityLog.FInternalLogs[FLogType].MaxSize;
end;

procedure TORActivityLog.TLogWrapper.SetLogActivityEvent
  (const Value: TLogActivityEvent);
begin
  FActivityLog.FInternalLogs[FLogType].OnLogEvent := Value;
end;

procedure TORActivityLog.TLogWrapper.SetMaxSize(const Value: Integer);
begin
  FActivityLog.FInternalLogs[FLogType].MaxSize := Value;
  if Value > 0 then
    FActivityLog.Start(FLogType)
  else
    FActivityLog.Stop(FLogType);
end;

{ TORActivityLog }

procedure TORActivityLog.BeginAddingText(InitialText: string; Nesting: Boolean);
const
  DefaultSplitters: TArray<Char> = [TWinMsgNames.Delim, ';', '=', ':', ' '];
var
  Len, OldIndent: Integer;
begin
  OldIndent := FIndentLen;
  try
    if Nesting then
    begin
      Len := Length(InitialText);
      if Len > 0 then
        FIndentLen := Len;
    end;
    TTextWrapper.BeginWrapping(InitialText, Nesting, OutputLineSize, FIndentLen,
      DefaultSplitters);
  finally
    FIndentLen := OldIndent;
  end;
end;

class function TORActivityLog.ComponentDescription(Component: TComponent;
  InitialText: string): string;
var
  Data: TComponentData;
begin
  FActivityLog.BeginAddingText(InitialText);
  try
    Data := TComponentData.Create(Component, '');
    try
      TTextWrapper.Add(Data.ToString, '');
    finally
      Data.Free;
    end;
  finally
    Result := TTextWrapper.RetrieveTextEndWrapping;
  end;
end;

constructor TORActivityLog.Create;
var
  lt: TLogType;
begin
  if Assigned(FActivityLog) then
    raise Exception.Create('Only one instance of ' + ClassName +
      ' may exist at the same time.');
  inherited Create;
  FThreadHandle := TThread.CurrentThread.Handle;
  for lt := Low(TLogType) to High(TLogType) do
  begin
    FInternalLogs[lt] := TInternalLog.Create;
    FRunning[lt] := False;
  end;
  FActionTypes := TActionTypes.Create;
  FIndentLen := DefaultIndentLength;
end;

class constructor TORActivityLog.Create;
begin
  FActivityLog := TORActivityLog.Create;
  // I didn't make the log type a TLogWrapper.Create parameter because TLogType
  // isn't a public type, and TLogWrapper is a public type.
  FActivityLogWrapper := TLogWrapper.Create;
  FActivityLogWrapper.FLogType := ltActivity;
  FMessageLogWrapper := TLogWrapper.Create;
  FMessageLogWrapper.FLogType := ltMesssage;
end;

destructor TORActivityLog.Destroy;
var
  lt: TLogType;
begin
  for lt := High(TLogType) downto Low(TLogType) do
    FreeAndNil(FInternalLogs[lt]);
  FreeAndNil(FActionTypes);
  inherited;
end;

class destructor TORActivityLog.Destroy;
begin
  FreeAndNil(FActivityLogWrapper);
  FreeAndNil(FMessageLogWrapper);
  FreeAndNil(FActivityLog);
end;

class function TORActivityLog.InterceptActionExecute
  (Self: TBasicAction): Boolean;
var
  ActivityID: Int64;
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) and Assigned(Self.OnExecute) then
    ActivityID := FActivityLog.UpdateLogBegin(FActivityLog.FActionExecute,
      Self, SelfText)
  else
    ActivityID := 0;
  Result := FActivityLog.FActionExecute.Trampoline(Self);
  if ActivityID > 0 then
    FActivityLog.UpdateLogEnd(ActivityID, FActivityLog.FActionExecute,
      'Result = ' + BoolToStr(Result, True), Self, SelfText);
end;

class procedure TORActivityLog.InterceptControlChanged(Self: TControl);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) and (not(Self is TCustomEdit))
  then
    FActivityLog.UpdateLog(FActivityLog.FControlChanged, '', Self, SelfText);
  FActivityLog.FControlChanged.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptControlClick(Self: TControl);
var
  Form: TCustomForm;
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) and (not(Self is TCustomListBox))
    and (not(Self is TCustomTreeView)) and (not(Self is TCustomListView)) and
    (not(Self is TTrackBar)) and (not(Self is TDateTimePicker)) and
    (not(Self is TCustomTabControl)) then
  begin
    if Assigned(TControlAccess(Self).OnClick) then
    begin
      if ((not Assigned(Self.Action)) or (TMethod(TControlAccess(Self).OnClick)
        <> TMethod(Self.Action.OnExecute))) then
        FActivityLog.UpdateLog(FActivityLog.FControlClick, '', Self, SelfText)
    end
    else if ((not Assigned(Self.Action)) or (not Assigned(Self.Action.OnExecute)
      )) and (Self is TCustomButton) and
      (TCustomButton(Self).ModalResult <> mrNone) then
    begin
      Form := GetParentForm(Self);
      if Assigned(Form) and (fsModal in Form.FormState) then
        FActivityLog.UpdateLog(FActivityLog.FControlClick, '', Self, SelfText)
    end;
  end;
  FActivityLog.FControlClick.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptControlDblClick(Self: TControl);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) and
    Assigned(TControlAccess(Self).OnDblClick) then
    FActivityLog.UpdateLog(FActivityLog.FControlDblClick, '', Self, SelfText);
  FActivityLog.FControlDblClick.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptDateTimePickerChange
  (Self: TDateTimePicker);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
    FActivityLog.UpdateLog(FActivityLog.FDateTimePickerChange, '', Self,
      SelfText);
  FActivityLog.FDateTimePickerChange.Trampoline(Self);
end;

class function TORActivityLog.InterceptDispatchMessageA
  (const lpMsg: TMsg): Longint;
var
  Info: TMsgInfo;
begin
  if FActivityLog.ThreadSafe then
  begin
    Info := TMsgInfo.Create(lpMsg);
    FActivityLog.UpdateLog(FActivityLog.FDispatchMessageA, '', nil, '', Info);
  end;
  Result := FActivityLog.FDispatchMessageA.Trampoline(lpMsg);
end;

class function TORActivityLog.InterceptDispatchMessageW
  (const lpMsg: TMsg): Longint;
var
  Info: TMsgInfo;
begin
  if FActivityLog.ThreadSafe then
  begin
    Info := TMsgInfo.Create(lpMsg);
    FActivityLog.UpdateLog(FActivityLog.FDispatchMessageW, '', nil, '', Info);
  end;
  Result := FActivityLog.FDispatchMessageW.Trampoline(lpMsg);
end;

class function TORActivityLog.InterceptFormCloseQuery
  (Self: TCustomForm): Boolean;
var
  ActivityID: Int64;
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) and
    Assigned(TFormAccess(Self).OnCloseQuery) then
    ActivityID := FActivityLog.UpdateLogBegin(FActivityLog.FFormCloseQuery,
      Self, SelfText)
  else
    ActivityID := 0;
  Result := FActivityLog.FFormCloseQuery.Trampoline(Self);
  if ActivityID > 0 then
    FActivityLog.UpdateLogEnd(ActivityID, FActivityLog.FFormCloseQuery,
      'Result = ' + BoolToStr(Result, True), Self, SelfText);
end;

class procedure TORActivityLog.InterceptFormCreate(Self: TCustomForm);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
    FActivityLog.UpdateLog(FActivityLog.FFormCreate, '', Self, SelfText);
  FActivityLog.FFormCreate.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptFormDestroy(Self: TCustomForm);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) then
    FActivityLog.UpdateLog(FActivityLog.FFormDestroy, '', Self, SelfText);
  FActivityLog.FFormDestroy.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptFormDoClose(Self: TCustomForm;
  var Action: TCloseAction);
var
  ActivityID: Int64;
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) and
    Assigned(TFormAccess(Self).OnClose) then
    ActivityID := FActivityLog.UpdateLogBegin(FActivityLog.FFormDoClose,
      Self, SelfText)
  else
    ActivityID := 0;
  FActivityLog.FFormDoClose.Trampoline(Self, Action);
  if ActivityID > 0 then
    FActivityLog.UpdateLogEnd(ActivityID, FActivityLog.FFormDoClose,
      'Action = ' + GetEnumName(TypeInfo(TCloseAction), ord(Action)), Self,
      SelfText);
end;

class procedure TORActivityLog.InterceptListViewChange(Self: TCustomListView;
  Item: TListItem; Change: Integer);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
    FActivityLog.UpdateLog(FActivityLog.FListViewChange, '', Self, SelfText);
  FActivityLog.FListViewChange.Trampoline(Self, Item, Change);
end;

class procedure TORActivityLog.InterceptMenuClick(Self: TMenuItem);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
  begin
    if Assigned(Self.OnClick) and
      ((not Assigned(Self.Action)) or
      (TMethod(Self.OnClick) <> TMethod(Self.Action.OnExecute))) then
      FActivityLog.UpdateLog(FActivityLog.FMenuClick, '', Self, SelfText);
  end;
  FActivityLog.FMenuClick.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptTabChange(Self: TCustomTabControl);
var
  Text: string;
  idx: Integer;
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
  begin
    idx := TCustomTabControlAccess(Self).TabIndex;
    if (idx < 0) or (idx >= TCustomTabControlAccess(Self).Tabs.Count) then
      Text := 'None'
    else
      Text := TCustomTabControlAccess(Self).Tabs[idx];
    FActivityLog.UpdateLog(FActivityLog.FTabChange, 'Tab = ' + Text, Self,
      SelfText);
  end;
  FActivityLog.FTabChange.Trampoline(Self);
end;

class procedure TORActivityLog.InterceptTrackBarChanged(Self: TTrackBar);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
    FActivityLog.UpdateLog(FActivityLog.FTrackBarChanged, '', Self, SelfText);
  FActivityLog.FTrackBarChanged.Trampoline(Self)
end;

class procedure TORActivityLog.InterceptTreeViewChange(Self: TCustomTreeView;
  Node: TTreeNode);
begin
  if FActivityLog.ThreadSafe and Assigned(Self) and
    (not(csDestroying in Self.ComponentState)) then
    FActivityLog.UpdateLog(FActivityLog.FTreeViewChange, '', Self, SelfText);
  FActivityLog.FTreeViewChange.Trampoline(Self, Node);
end;

function TORActivityLog.Matches(Obj1, Obj2: TObject): Boolean;
begin
  if Assigned(Obj1) and Assigned(Obj2) then
    Result := Obj1.Equals(Obj2)
  else
    Result := (not Assigned(Obj1)) and (not Assigned(Obj2));
end;

procedure TORActivityLog.Start(ALogType: TLogType);
begin
  if not FRunning[ALogType] then
  begin
    case ALogType of
      ltActivity:
        begin
          FMenuClick := TActionType<TMenuClickTrampoline>.Create
            (TMenuItem.QualifiedClassName + '.Click', @TMenuItem.Click,
            @InterceptMenuClick);
          FActionExecute := TActionType<TActionExecuteTrampoline>.Create
            (TBasicAction.QualifiedClassName + '.Execute',
            @TBasicAction.Execute, @InterceptActionExecute);
          FControlChanged := TActionType<TControlChangedTrampoline>.Create
            (TControl.QualifiedClassName + '.Changed', @TControlAccess.Changed,
            @InterceptControlChanged);
          FControlClick := TActionType<TControlClickTrampoline>.Create
            (TControl.QualifiedClassName + '.Click', @TControlAccess.Click,
            @InterceptControlClick);
          FControlDblClick := TActionType<TControlDblClickTrampoline>.Create
            (TControl.QualifiedClassName + '.DblClick',
            @TControlAccess.DblClick, @InterceptControlDblClick);
          FTabChange := TActionType<TTabChangeTrampoline>.Create
            (TCustomTabControl.QualifiedClassName + '.Change',
            @TCustomTabControlAccess.Change, @InterceptTabChange);
          FTreeViewChange := TActionType<TTreeViewChangeTrampoline>.Create
            (TCustomTreeView.QualifiedClassName + '.Change',
            @TCustomTreeViewAccess.Change, @InterceptTreeViewChange);
          FListViewChange := TActionType<TListViewChangeTrampoline>.Create
            (TCustomListView.QualifiedClassName + '.Change',
            @TCustomListViewAccess.Change, @InterceptListViewChange);
          FTrackBarChanged := TActionType<TTrackBarChangedTrampoline>.Create
            (TTrackBar.QualifiedClassName + '.Changed',
            @TTrackBarAccess.Changed, @InterceptTrackBarChanged);
          FDateTimePickerChange := TActionType<TDateTimePickerChangeTrampoline>.
            Create(TDateTimePicker.QualifiedClassName + '.Change',
            @TDateTimePickerAccess.Change, @InterceptDateTimePickerChange);
          FFormCreate := TActionType<TFormCreateTrampoline>.Create
            (TCustomForm.QualifiedClassName + '.Create',
            @TCustomForm.AfterConstruction, @InterceptFormCreate);
          FFormCloseQuery := TActionType<TFormCloseQueryTrampoline>.Create
            (TCustomForm.QualifiedClassName + '.CloseQuery',
            @TFormAccess.CloseQuery, @InterceptFormCloseQuery);
          FFormDoClose := TActionType<TFormDoCloseTrampoline>.Create
            (TCustomForm.QualifiedClassName + '.DoClose', @TFormAccess.DoClose,
            @InterceptFormDoClose);
          FFormDestroy := TActionType<TFormDestroyTrampoline>.Create
            (TCustomForm.QualifiedClassName + '.Destroy',
            @TCustomForm.BeforeDestruction, @InterceptFormDestroy);
        end;
      ltMesssage:
        begin
          FDispatchMessageW := TActionType<TDispatchMessageWTrampoline>.Create
            ('Winapi.Windows.DispatchMessageW', @DispatchMessageW,
            @InterceptDispatchMessageW, ltMesssage);
          FDispatchMessageA := TActionType<TDispatchMessageATrampoline>.Create
            ('Winapi.Windows.DispatchMessageA', @DispatchMessageA,
            @InterceptDispatchMessageA, ltMesssage);
        end;
    end;
    FRunning[ALogType] := True;
  end;
end;

procedure TORActivityLog.Stop(ALogType: TLogType);
var
  i: Integer;
begin
  if FRunning[ALogType] then
  begin
    try
      for i := FActionTypes.Count - 1 downto 0 do
        if FActionTypes[i].LogType = ALogType then
          FActionTypes.Delete(i);
    finally
      FRunning[ALogType] := False;
    end;
  end;
end;

function TORActivityLog.ThreadSafe: Boolean;
begin
  Result := FThreadHandle = TThread.CurrentThread.Handle;
end;

function TORActivityLog.UpdateLog(AActionType: TActionType; AValue: string;
  AComponent: TComponent; AComponentTitle: string = '';
  AMessage: TMsgInfo = nil): TActivity;
var
  lt: TLogType;
begin
  Result := nil;
  lt := AActionType.LogType;
  if FRunning[lt] then
    Result := FInternalLogs[lt].Add(AActionType, AValue, AComponent,
      AComponentTitle, AMessage);
end;

function TORActivityLog.UpdateLogBegin(AActionType: TActionType;
  AComponent: TComponent; AComponentTitle: string = '';
  AMessage: TMsgInfo = nil): Int64;
var
  lt: TLogType;
begin
  Result := 0;
  lt := AActionType.LogType;
  if FRunning[lt] then
    Result := UpdateLog(AActionType, BeginText, AComponent, AComponentTitle,
      AMessage).ActivityID;
end;

procedure TORActivityLog.UpdateLogEnd(LastActivityID: Int64;
  AActionType: TActionType; AValue: string; AComponent: TComponent;
  AComponentTitle: string; AMessage: TMsgInfo = nil);
var
  lt: TLogType;
begin
  lt := AActionType.LogType;
  if FRunning[lt] then
  begin
    if (FInternalLogs[lt].Count > 0) and
      (FInternalLogs[lt][FInternalLogs[lt].Count - 1]
      .ActivityID = LastActivityID) then
      FInternalLogs[lt][FInternalLogs[lt].Count - 1].Action.Value := AValue
    else
      UpdateLog(AActionType, EndText + AValue, AComponent, AComponentTitle,
        AMessage);
  end;
end;

end.
