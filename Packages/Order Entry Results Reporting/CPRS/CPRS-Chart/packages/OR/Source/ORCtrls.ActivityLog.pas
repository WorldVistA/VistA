unit ORCtrls.ActivityLog;
///////////////////////////////////////////////////////////////////////////////
/// This unit defines TActivityLog.
/// TActivityLog.Add adds a log entry
/// TActivityLog.Modify modifies a log entry (to add a Result, for instance)
/// TActivityLog.ToString modifies a log entry (to add a Result, for instance)
/// TActivityLog.CleanUp reduces the log to the number of entrees specified
/// TActivityLog.OnChange is an event that goes off on changes to the log
///   entries.
///
/// An ActivityLog line has this format:
///   [Timestamp] with date if different than current
///   [ThreadID] if all ThreadIDs in log are the same this is omitted
///   [Qualified Class].[Event]
///   [- X times] if event occured more than once in succession, Timestamp
///     is first occurance in this case
///   [(Component data, Parent data, Owner data, Result, etc)] as available
///
/// Some Examples of lines added by ActivityLogger:
//  11:02:06.874 0000016440 Unit3.TForm3.CloseQuery (Self = Form3; Caption = "Form3"; Owner = nil; Result = True)
/// 11:02:07.858 0000016440 Vcl.StdCtrls.TButton.Click (Self = Button1; Caption = "Button1"; Form = Form1: TForm1)
/// 11:08:19.004 0000016136 System.SysUtils.Exception.NewInstance
/// 11:08:20.602 Vcl.StdCtrls.TButton.Click - 2 times (Self = Button1; Caption = "Button1"; Form = Form1: TForm1)
///////////////////////////////////////////////////////////////////////////////
interface

uses
  System.SysUtils,
  System.SyncObjs,
  System.Generics.Collections,
  System.Rtti,
  System.Classes;

type
  TParentType = (ptParent, ptOwner, ptFrame, ptSubForm, ptForm, ptMenu);

  TBaseData = class(TObject)
  strict private
    FClassData: TClass;
    FName: string;
    FCaption: string;
  strict protected
    function GetParentComponent(AComponent: TComponent): TComponent;
  public
    constructor Create(Obj: TObject);
    class function GetPropertyValue(Obj: TObject; const PropertyName: string)
      : TValue; static;
    function Equals(Obj: TObject): Boolean; override;
    function ToString: string; override;
    property Name: string read FName;
    property ClassData: TClass read FClassData;
  end;

  TParentData = class(TBaseData)
  strict private
    FParentType: TParentType;
  public
    constructor Create(AComponent: TComponent; AParentType: TParentType);
    property ParentType: TParentType read FParentType;
    function Equals(Obj: TObject): Boolean; override;
  end;

  TObjectData = class(TBaseData)
  strict private
    FFirst, FLast: string;
    FParentList: TObjectList<TParentData>;
  public
    constructor Create(Obj: TObject; const AFirst: string = '';
      const ALast: string = '');
    destructor Destroy; override;
    property First: string read FFirst;
    property Last: string read FLast write FLast;
    property ParentList: TObjectList<TParentData> read FParentList;
    function Equals(Obj: TObject): Boolean; override;
  end;

  TActivityData = class(TObjectData)
  strict private
    FID: TGuid;
    FDateTime: TDateTime;
    FActivity: string;
    FThreadID: TThreadID;
  public
    constructor Create(const AActivity: string; Obj: TObject;
      const AFirst: string = ''; const ALast: string = '');
    function Equals(Obj: TObject): Boolean; override;
    function ToString: string; overload; override;
    function ToString(ACount: Integer; AIncludeThreadIDs: Boolean = False): string;
      reintroduce; overload;
    property ID: TGuid read FID;
    property ThreadID: TThreadID read FThreadID;
  end;

  TForEachActivityEvent = reference to procedure(AData: TActivityData;
    AIndex: Integer; AIsDuplicate: Boolean; var AStop: Boolean);

  TActivityLog = class(TObject)
  strict private const
    MaxListCount = 50000; // The max number of entries in the log (only the latest X are kept)
    MaxDuplicateCount = 20; // The max number of consecutive duplicate entries (only the latest X are kept)
  strict private
    FCriticalSection: TCriticalSection;
    FList: TObjectList<TActivityData>;
    FOnChange: TNotifyEvent;
    FInOnChange: Boolean; // to prevent recursion
  strict protected
    function Find(AID: TGuid): TActivityData;
    procedure NotifyOnChange;
    function ForEach(AEvent: TForEachActivityEvent;
      AMaxUnique: Integer): string;
    procedure Lock;
    procedure Unlock;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AActivity: string; Obj: TObject;
      const AFirst: string = ''; const ALast: string = ''): TGuid;
    function Modify(const AID: TGuid; const ALast: string): Boolean;
    procedure CleanUp(AMax: Integer);
    procedure Clear;
    function IsEmpty: Boolean;
    function ToString: string; overload; override;
    function ToString(AMaxLines: Integer): string; reintroduce; overload;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.Forms,
  Vcl.Menus,
  System.Actions,
  System.DateUtils;

// TBaseData

constructor TBaseData.Create(Obj: TObject);
var
  APropertyValue: TValue;
begin
  if not Assigned(Obj) then
    raise Exception.Create('Obj not Assigned');
  FClassData := Obj.ClassType;

  APropertyValue := GetPropertyValue(Obj, 'Name');
  if not APropertyValue.IsEmpty then
    FName := APropertyValue.ToString.Trim;

  if (Obj is TMenuItem) or (Obj is TBasicAction) then
  begin
    // Captions on other objects may contain PPI, and we can't have ppi in the
    // activity log!
    APropertyValue := GetPropertyValue(Obj, 'Caption');
    if not APropertyValue.IsEmpty then
      FCaption := StripHotKey(APropertyValue.ToString.Trim);
  end;
end;

class function TBaseData.GetPropertyValue(Obj: TObject;
  const PropertyName: string): TValue;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiProperty: TRttiProperty;
begin
  RttiType := RttiContext.GetType(Obj.ClassType);
  if not Assigned(RttiType) then Exit(TValue.Empty);
  RttiProperty := RttiType.GetProperty(PropertyName);
  if not Assigned(RttiProperty) or (not RttiProperty.IsReadable) then
    Exit(TValue.Empty);
  Result := RttiProperty.GetValue(Obj);
end;

function TBaseData.GetParentComponent(AComponent: TComponent): TComponent;
// Use Rtti to get the Parent, which will work even for MenuItems, etc.
var
  AParentValue: TValue;
  AParent: TObject;
begin
  if AComponent is TMenuItem then
  begin
    Result := TMenuItem(AComponent).GetParentMenu;
    if Assigned(Result) then Exit;
  end;
  AParentValue := GetPropertyValue(AComponent, 'Parent');
  if not AParentValue.IsObject then Exit(nil);
  AParent := AParentValue.AsObject;
  if not (AParent is TComponent) then Exit(nil);
  Result := TComponent(AParent);
end;

function TBaseData.Equals(Obj: TObject): Boolean;
begin
  Result := Assigned(Obj) and (Obj is Self.ClassType) and
    (TBaseData(Obj).FClassData = FClassData) and (TBaseData(Obj).FName = FName)
    and (TBaseData(Obj).FCaption = FCaption);
end;

function TBaseData.ToString: string;

  function AddString(var AValue: string; const AddValue: string): string;
  begin
    if AddValue = '' then Exit(AValue);
    if AValue <> '' then AValue := AValue + '; ';
    AValue := AValue + AddValue;
    Result := AValue;
  end;

const
  ParentTypeStrings: array [TParentType] of string = ('Parent', 'Owner',
    'Frame', 'SubForm', 'Form', 'Menu');
var
  AFormat: string;
  AParentTypeString: string;
  ANeedOwner: Boolean;
  AParentData: TParentData;
begin
  if Self is TParentData then
  begin
    AParentTypeString := ParentTypeStrings[TParentData(Self).ParentType];
    if FName <> '' then AFormat := '%0:s = %1:s: %2:s'
    else AFormat := '%0:s: %2:s';
  end else begin
    AParentTypeString := '';
    if FName <> '' then begin
      AFormat := 'Self = %1:s'
    end else begin
      if FClassData.InheritsFrom(TComponent) then AFormat := 'No name'
      else AFormat := '';
    end;
  end;
  Result := Format(AFormat, [AParentTypeString, FName,
    FClassData.ClassName.Trim]);

  if Self is TObjectData then
  begin
    AddString(Result, TObjectData(Self).First);

    if FCaption <> '' then
    begin
      if Length(FCaption) <= 30 then
        AddString(Result, Format('Caption = "%s"', [FCaption]))
      else AddString(Result, Format('Caption = "%s"',
        [Copy(FCaption, 1, 25) + '[...]'])); // use elipsis for long captions
    end;

    ANeedOwner := FClassData.InheritsFrom(TComponent);
    for AParentData in TObjectData(Self).ParentList do
    begin
      if AParentData.ParentType in [ptParent, ptFrame, ptForm, ptSubForm] then
        ANeedOwner := False;
      if (AParentData.ParentType <> ptOwner) or ANeedOwner then
      begin
        // We only log the owner if we need it. It is always the last item in
        // the parentlist
        AddString(Result, AParentData.ToString);
        if AParentData.ParentType = ptOwner then ANeedOwner := False;
      end;
    end;
    if ANeedOwner then AddString(Result, 'Owner = nil');
    AddString(Result, TObjectData(Self).Last);
  end;
end;

// TParentData

constructor TParentData.Create(AComponent: TComponent;
  AParentType: TParentType);
begin
  inherited Create(AComponent);
  FParentType := AParentType;
end;

function TParentData.Equals(Obj: TObject): Boolean;
begin
  Result := inherited Equals(Obj) and
    (TParentData(Obj).FParentType = FParentType);
end;

// TObjectData

constructor TObjectData.Create(Obj: TObject;
  const AFirst: string = ''; const ALast: string = '');
var
  AComponent: TComponent;
  ANeedNamedParent: Boolean;
  AParent: TComponent;
  AParentType: TParentType;
begin
  inherited Create(Obj);
  FFirst := AFirst;
  FLast := ALast;
  FParentList := TObjectList<TParentData>.Create;

  if Obj is TComponent then
  begin
    AComponent := TComponent(Obj);
    ANeedNamedParent := AComponent.Name = '';
    AParent := GetParentComponent(AComponent);
    while Assigned(AParent) do
    begin
      if AParent is TCustomFrame then
      begin
        FParentList.Add(TParentData.Create(AParent, ptFrame));
        ANeedNamedParent := False;
      end else begin
        if AParent is TCustomForm then
        begin
          if Assigned(TCustomForm(AParent).Parent) then AParentType := ptSubForm
          else AParentType := ptForm;
          FParentList.Add(TParentData.Create(AParent, AParentType));
          ANeedNamedParent := False;
        end else begin
          if AParent is TMenu then
          begin
            FParentList.Add(TParentData.Create(AParent, ptMenu));
            ANeedNamedParent := False;
          end;
        end;
      end;

      if ANeedNamedParent and (AParent.Name <> '') then
      begin
        FParentList.Add(TParentData.Create(AParent, ptParent));
        ANeedNamedParent := False;
      end;

      AParent := GetParentComponent(AParent);
    end;

    if Assigned(AComponent.Owner) then
      FParentList.Add(TParentData.Create(AComponent.Owner, ptOwner));
  end;
end;

destructor TObjectData.Destroy;
begin
  FreeAndNil(FParentList);
  inherited;
end;

function TObjectData.Equals(Obj: TObject): Boolean;
var
  I: Integer;
begin
  Result := inherited Equals(Obj) and
    (TObjectData(Obj).FFirst = FFirst) and
    (TObjectData(Obj).FLast = FLast) and
    (TObjectData(Obj).FParentList.Count = FParentList.Count);
  if not Result then Exit;
  for I := 0 to FParentList.Count - 1 do
  begin
    Result := Result and FParentList[I]
      .Equals(TObjectData(Obj).FParentList[I]);
    if not Result then Exit;
  end;
end;

// .TActivityData

constructor TActivityData.Create(const AActivity: string;
  Obj: TObject; const AFirst: string = ''; const ALast: string = '');
begin
  inherited Create(Obj, AFirst, ALast);
  FID := TGuid.NewGuid;
  FDateTime := Now;
  FActivity := AActivity;
  FThreadID := TThread.Current.ThreadID;
end;

function TActivityData.Equals(Obj: TObject): Boolean;
begin
  Result := SameText(TActivityData(Obj).FActivity, FActivity) and
    (TActivityData(Obj).FThreadID = FThreadID) and
    inherited Equals(Obj);
end;

function TActivityData.ToString: string;
begin
  Result := ToString(1);
end;

function TActivityData.ToString(ACount: Integer;
  AIncludeThreadIDs: Boolean = False): string;
// ACount is the "x times" returned in the log string
// AIncludeThreadIDs determines if the ThreadID should be added to the string
var
  AFormat, ATimeFormat, AThreadIDString: string;
begin
  Result := inherited ToString;

  if ACount > 1 then AFormat := '%0:s.%1:s - %2:d times'
  else AFormat := '%0:s.%1:s';
  if Result <> '' then AFormat := AFormat + ' (%3:s)';

  if DateOf(FDateTime) = DateOf(Now) then
    ATimeFormat := 'hh:nn:ss.zzz '
  else ATimeFormat := 'mm/dd/yyyy hh:nn:ss.zzz ';

  if AIncludeThreadIDs then AThreadIDString := Format('%.10d ', [FThreadID])
  else AThreadIDString := '';

  Result := FormatDateTime(ATimeFormat, FDateTime) +
    AThreadIDString +
    Format(AFormat, [ClassData.QualifiedClassName, FActivity, ACount,
    Result]);
end;

// TActivityLog

constructor TActivityLog.Create;
begin
  inherited;
  FCriticalSection := TCriticalSection.Create;
  FList := TObjectList<TActivityData>.Create(True);
end;

destructor TActivityLog.Destroy;
begin
  FreeAndNil(FList);
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TActivityLog.Lock;
// Match every Lock with an unlock
// Lock implements thread safety. No two thread can lock at the same time
begin
  FCriticalSection.Enter;
end;

procedure TActivityLog.Unlock;
begin
  FCriticalSection.Leave;
end;

function TActivityLog.Add(const AActivity: string; Obj: TObject;
  const AFirst: string = ''; const ALast: string = ''): TGuid;
// AActivity = string that gets added to the class. So for Component.Change,
//   pass in "Change"
// AFirst = text to report on before all other parts, but after Self. Pass in
//   something like "Tab = 1" to get "(Self = MainTabs; Tab = 1; Form = ... etc
// Result is a GUID that's an ID of the activity, for lookup later (in the
//   Modify call)
var
  AActivityData: TActivityData;
begin
  Lock;
  try
    if FList.Count > MaxListCount then
      // Safety triggered: start the cleanup.
      Cleanup(-1);
    AActivityData := TActivityData.Create(AActivity, Obj, AFirst, ALast);
    FList.Add(AActivityData);
    Result := AActivityData.ID;
  finally
    Unlock;
  end;
  NotifyOnChange;
end;

function TActivityLog.Find(AID: TGuid): TActivityData;
var
  I: Integer;
begin
  Lock;
  try
    for I := FList.Count - 1 downto 0 do
      // High to low is probably most efficient
      if FList[I].ID = AID then Exit(FList[I]);
    Result := nil;
  finally
    Unlock;
  end;
end;

function TActivityLog.Modify(const AID: TGuid; const ALast: string): Boolean;
// ALast is a string that's shown unmodified as the last element within
// the brackets. Use it to, for instance, set a Result after making an inherited
// function call. If you set the ALast parameter in the Add call, it will be
// overwritten.
// If the Activity with the AID cannot be found, this function returns false
// and does nothing.
var
  AActivityData: TActivityData;
begin
  Lock;
  try
    AActivityData := Find(AID);
    if Assigned(AActivityData) then AActivityData.Last := ALast;
    Result := Assigned(AActivityData);
  finally
    Unlock;
  end;
  NotifyOnChange;
end;

procedure TActivityLog.CleanUp(AMax: Integer);
// Reduce log entrees to AMax, but dont count the dupes
// Reduce the dupes to MaxDuplicateCount as well
// If AMax < 0 only dupes are reduced
var
  AUniqueCount, ADuplicateCount: Integer;
  FIsChanged: Boolean;
begin
  FIsChanged := False;
  Lock;
  try
    if AMax = 0 then begin
      FIsChanged := FList.Count > 0;
      FList.Clear;
    end else begin
      AUniqueCount := 1;
      ADuplicateCount := 1;
      ForEach(
        procedure(AData: TActivityData; AIndex: Integer; AIsDuplicate: Boolean;
          var AStop: Boolean)
        begin
          if (AUniqueCount > AMax) and (AMax >= 0) then
          begin
            FList.Delete(AIndex);
            FIsChanged := True;
          end else begin
            if not AIsDuplicate then
            begin
              Inc(AUniqueCount);
              ADuplicateCount := 1;
            end else begin
              if ADuplicateCount < MaxDuplicateCount then
              begin
                Inc(ADuplicateCount);
              end else begin
                FList.Delete(AIndex);
                FIsChanged := True;
              end;
            end;
          end;
        end, -1);
      // And, to ensure we do not just go way overboard regardless:
      while FList.Count > MaxListCount do FList.Delete(0);
    end;
  finally
    Unlock;
  end;
  if FIsChanged then NotifyOnChange;
end;

procedure TActivityLog.Clear;
begin
  Cleanup(0);
end;

function TActivityLog.IsEmpty: Boolean;
begin
  Lock;
  try
    Result := FList.Count <= 0;
  finally
    UnLock;
  end;
end;

procedure TActivityLog.NotifyOnChange;
begin
  if not FInOnChange and Assigned(FOnChange) then
  begin
    FInOnChange := True;
    try
      FOnChange(Self);
    finally
      FInOnChange := False;
    end;
  end;
end;

function TActivityLog.ToString: string;
begin
  Result := ToString(-1);
end;

function TActivityLog.ForEach(AEvent: TForEachActivityEvent;
  AMaxUnique: Integer): string;
// Fires AEvent for each item in FList, from last to first. If the item is the
// same as the item before it, then IsDuplicate = True, else it's False.
// It stops when the number of items with IsDuplicate = False returned is equal
// to MaxUnique. or when the end (the start) of FList is reached.
// If AMaxUnique < 0 then no MaxUnique
// Set AStop to True in the event handler to break out of ForEach immediately.
var
  I, AUniqueCount: Integer;
  AIsDuplicate, AStop: Boolean;
begin
  Lock;
  try
    AUniqueCount := 0;
    AStop := False;
    for I := FList.Count - 1 downto 0 do
    begin
      AIsDuplicate := (I > 0) and FList[I].Equals(FList[I - 1]);
      AEvent(FList[I], I, AIsDuplicate, AStop);
      if not AIsDuplicate then
      begin
        Inc(AUniqueCount);
        if (AMaxUnique >= 0) and (AUniqueCount >= AMaxUnique) then Exit;
      end;
      if AStop then Exit;
    end;
  finally
    Unlock;
  end;
end;

function TActivityLog.ToString(AMaxLines: Integer): string;
// If AMaxLines < 0 then no MaxLines
var
  ADuplicateCount: Integer;
  AIncludeThreadIDs: Boolean;
  AThreadID: TThreadID;
  AResult: string;
begin
  Result := '';
  if AMaxLines = 0 then Exit;
  Lock;
  try
    if FList.Count <= 0 then Exit;

    AIncludeThreadIDs := False;
    AThreadID := FList[0].ThreadID;
    ForEach(
      // Determine wether to log ThreadIDs
      procedure(AData: TActivityData; AIndex: Integer; AIsDuplicate: Boolean;
        var AStop: Boolean)
      begin
        AIncludeThreadIDs := AData.ThreadID <> AThreadID;
        AStop := AIncludeThreadIDs;
      end,
      AMaxLines);

    ADuplicateCount := 1;
    AResult := '';
    ForEach(
      // Log the lines
      procedure(AData: TActivityData; AIndex: Integer; AIsDuplicate: Boolean;
        var AStop: Boolean)
      begin
        if AIsDuplicate then
        begin
          Inc(ADuplicateCount);
        end else begin
          // With duplicates, the time logged is from the first item
          AResult := Format('%0:s'#13#10'%1:s',
            [AResult, AData.ToString(ADuplicateCount, AIncludeThreadIDs)]);
          ADuplicateCount := 1;
        end;
      end,
      AMaxLines);

    Result := AResult.Trim;
  finally
    Unlock;
  end;
end;

end.
