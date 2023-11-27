unit OREventCache;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TOREventCache = class(TObject)
  private
    type
      TEventItem = class(TObject)
      strict private
        FName: string;
        FMethod: TMethod;
      public
        constructor Create(const AName: string; AMethod: TMethod);
        property Name: string read FName;
        property Method: TMethod read FMethod;
      end;
      TEventItemList = TObjectList<TEventItem>;
  private
    FInstance: TObject;
    FEventCache: TEventItemList;
    FSaveAndNilEventsCount: integer;
  public
    constructor Create(AInstance: TObject);
    destructor Destroy; override;
    procedure SaveAndNilEvents(AEvents: array of string);
    procedure RestoreEvents;
  end;

implementation

uses
  TypInfo;
{ TOREventCache }

constructor TOREventCache.Create(AInstance: TObject);
begin
  inherited Create;
  FInstance := AInstance;
  FEventCache := TEventItemList.Create;
end;

destructor TOREventCache.Destroy;
begin
  FEventCache.Free;
  inherited;
end;

procedure TOREventCache.RestoreEvents;
var
  AEventItem: TEventItem;

begin
  Dec(FSaveAndNilEventsCount);
  if FSaveAndNilEventsCount <= 0 then
  begin
    for AEventItem in FEventCache do
      SetMethodProp(FInstance, AEventItem.Name, AEventItem.Method);
    FEventCache.Clear;
    FSaveAndNilEventsCount := 0;
  end;
end;

procedure TOREventCache.SaveAndNilEvents(AEvents: array of string);
var
  AName: string;
  AEventItem: TEventItem;
  AMethod: TMethod;

begin
  Inc(FSaveAndNilEventsCount);
  for AName in AEvents do
  begin
    AMethod := GetMethodProp(FInstance, AName);
    if (AMethod.Code = nil) and (AMethod.Data = nil) then
      continue;
    AEventItem := TEventItem.Create(AName, AMethod);
    FEventCache.Add(AEventItem);
    AMethod.Data := nil;
    AMethod.Code := nil;
    SetMethodProp(FInstance, AName, AMethod);
  end;
end;

{ TOREventCache.TEventItem }

constructor TOREventCache.TEventItem.Create(const AName: string;
  AMethod: TMethod);
begin
  if AName = '' then
    raise Exception.Create('TEventItem requires a Name property.');
  inherited Create;
  FName := AName;
  FMethod := AMethod;
end;

end.
