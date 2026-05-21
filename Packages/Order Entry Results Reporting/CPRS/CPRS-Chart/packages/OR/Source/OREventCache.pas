unit OREventCache;
///////////////////////////////////////////////////////////////////////////////
/// TOREventCache saves and restores event fields (aka fields with the
///   fieldtype tkMethod) for any object.
///
/// BaseClass inherited event fields do get stored, but any events introduced
///   in classes BaseClass inherits from do not. Set BaseClass to nil to store
///   all event fields.
/// When using this event cache for an object, define that object with the
///   compiler directives {$RTTI EXPLICIT FIELDS([vcPrivate, vcProtected,
///   vcPublic, vcPublished])} to ensure that all fields at all
///   visibility levels are being recorded.
///////////////////////////////////////////////////////////////////////////////
interface

uses
  System.Generics.Collections,
  System.Rtti;

type
  TOREventCache = class(TObject)
  private

    type
      TEventItem = class(TObject)
      strict private
        FName: string;
        FValue: TValue;
      public
        constructor Create(const AName: string; AValue: TValue);
        property Name: string read FName;
        property Value: TValue read FValue;
      end;

  private
    FInstance: TObject;
    FBaseClass: TClass;
    FEventList: TObjectList<TEventItem>;
  public
    constructor Create(AInstance: TObject; ABaseClass: TClass = nil);
    destructor Destroy; override;
    procedure SaveEvents(NilEvents: Boolean = True);
    procedure RestoreEvents;
  end;

implementation

uses
  System.TypInfo,
  System.SysUtils;

// TOREventCache

constructor TOREventCache.Create(AInstance: TObject; ABaseClass: TClass = nil);
// AInstance: the object for which we are replacing and restoring events
// ABaseClass: see top comment on this unit
begin
  if not Assigned(AInstance) then
    raise Exception.Create('AInstance not Assigned');
  inherited Create;
  FInstance := AInstance;
  FBaseClass := ABaseClass;
  FEventList := TObjectList<TEventItem>.Create;
end;

destructor TOREventCache.Destroy;
begin
  FreeAndNil(FEventList);
  inherited Destroy;
end;

procedure TOREventCache.RestoreEvents;
var
  AEventItem: TEventItem;
  ARttiContext: TRttiContext;
  ARttiType: TRttiType;
  ARttiField: TRttiField;
begin
  ARttiType := ARttiContext.GetType(FInstance.ClassType);
  for AEventItem in FEventList do
  begin
    ARttiField := ARttiType.GetField(AEventItem.Name);
    if Assigned(ARttiField) then
      ARttiField.SetValue(FInstance, AEventItem.Value);
  end;
  FEventList.Clear;
end;

procedure TOREventCache.SaveEvents(NilEvents: Boolean = True);
// NilEvents = True will also nil the property after the event is saved to
// the eventcache.
var
  ARttiContext: TRttiContext;
  ARttiType: TRttiType;
  ARttiFields: TArray<TRttiField>;
  ARttiField: TRttiField;
  AValue: TValue;
begin
  ARttiType := ARttiContext.GetType(FInstance.ClassType);
  ARttiFields := ARttiType.GetFields;
  for ARttiField in ARttiFields do
  begin
    if Assigned(ARttiField) and Assigned(ARttiField.FieldType) and
      (ARttiField.FieldType.TypeKind = tkMethod) and
      (
        not Assigned(FBaseClass) or
        (
          Assigned(ARttiField.Parent) and
          (ARttiField.Parent is TRttiInstanceType) and
          ARttiField.Parent.AsInstance.MetaclassType.InheritsFrom(FBaseClass)
        )
      ) then
    begin
      AValue := ARttiField.GetValue(FInstance);
      if not AValue.IsEmpty then
      begin
        FEventList.Add(TEventItem.Create(ARttiField.Name, AValue));
        if NilEvents then ARttiField.SetValue(FInstance, AValue.Empty);
      end;
    end;
  end;
end;

// TOREventCache.TEventItem

constructor TOREventCache.TEventItem.Create(const AName: string;
  AValue: TValue);
begin
  if AName = '' then
    raise Exception.Create('TEventItem requires a Name property.');
  inherited Create;
  FName := AName;
  FValue := AValue;
end;

end.
