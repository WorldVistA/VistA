unit VA508AccessibilityManager;

interface
{ TODO -oJeremy Merrill -c508 :Remove Main Form from component list}
{ TODO -oJeremy Merrill -c508 :
Figure out a way to handle a component being renamed on a parent form - the child form now
references the component under a different name }
uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Forms, Contnrs, Dialogs,
  StrUtils, Buttons, ComCtrls, ExtCtrls, TypInfo, Graphics, VAClasses, VAUtils,
  VA508AccessibilityConst;

const
  VA508AccessibilityManagerVersion = '1.10';

type
  TVA508AccessibilityManager = class;
  TVA508AccessibilityCollection = class;
  TVA508ComponentManager = class;

  TVA508AccessibilityStatus = (stsOK, stsNoTabStop, stsDefault, stsNoData);


 TColumnList=class(TPersistent)
 private
   FList:TStringList;
 protected
   function GetCount:Integer;
   function GetName(Index:Integer):String;
   function GetValue(Index:Integer):Boolean;
   procedure SetValue(Index:Integer;Value:boolean);virtual;
   function GetItem(Index:Integer):String;
   procedure SetItem(Index:Integer; Value:String);virtual;
   function GetColumn(Column:Integer):Boolean;
   procedure SetColumn(Column:Integer; Value:boolean);virtual;
   function GetColumnExist(Column:Integer):Boolean;
 public
   constructor Create;
   destructor Destroy;override;
   function Add(Column: Integer; ReadValue:Boolean):Integer;virtual;
   procedure Assign(Source:TPersistent);override;
   procedure AssignTo(Dest:TPersistent);override;
   procedure Clear;virtual;
   procedure Delete(Column:Integer);  virtual;
   procedure Insert(Column:Integer; ReadValue:Boolean);virtual;
   function IndexOf(Column:Integer):Integer;
   procedure AddColumns(List:TColumnList);

   property Count:Integer read GetCount;
   Property ColumnExist[Column:Integer]: Boolean read GetColumnExist;
   Property ColumnValues[Column:Integer]: Boolean read GetColumn write SetColumn; default;
   property Names[Index:Integer]:String read GetName;
   property Values[Index:Integer]:Boolean read GetValue write SetValue;
   Property Items[Index: Integer]: string read GetItem write SetItem;
 end;


  TVA508AccessibilityItem = class(TCollectionItem)
  private
    FComponent: TWinControl;
    FComponentManager: TVA508ComponentManager;
    FLabel: TLabel;
    FProperty: string;
    FText: string;
    FAccessCol: TColumnList;
    FDefault: boolean;
    FStatus: TVA508AccessibilityStatus;
    procedure SetComponent(const Component: TWinControl);
    procedure InitComponent(const Component: TWinControl; FromManager: boolean);
    procedure SetLabel(const Value: TLabel);
    procedure SetProperty(const Value: string);
    procedure SetText(const Value: string);
    function Parent: TVA508AccessibilityCollection;
    procedure SetDefault(const Value: boolean);
    Function GetAccessColumns: TColumnList;
    procedure SetAccessColumns(const Value: TColumnList);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure UpdateStatus;
    function Manager: TVA508AccessibilityManager;
    property Status: TVA508AccessibilityStatus read FStatus write FStatus;
    property ComponentManager: TVA508ComponentManager read FComponentManager write FComponentManager;
  //  property Collection: TVA508AccessibilityCollection read Parent;
  published
    property AccessLabel: TLabel read FLabel write SetLabel;
    property AccessProperty: string read FProperty write SetProperty;
    property AccessText: string read FText write SetText;
    property AccessColumns: TColumnList read GetAccessColumns write SetAccessColumns;
    property Component: TWinControl read FComponent write SetComponent;
    property UseDefault: boolean read FDefault write SetDefault;
    property DisplayName: string read GetDisplayName;
  end;

  TVA508AccessibilityCollection = class(TCollection)
  private
    FRegistry: TStringList;
    FManager: TVA508AccessibilityManager;
    FNotifier: TVANotificationEventComponent;
    procedure ComponentNotifyEvent(AComponent: TComponent; Operation: TOperation);
  protected
    function IsComponentRegistered(Component: TWinControl): boolean;
    procedure RegisterComponent(Component: TWinControl; Item: TVA508AccessibilityItem);
    procedure UnregisterComponent(Component: TWinControl);
    function GetItem(Index: Integer): TVA508AccessibilityItem;
    procedure SetItem(Index: Integer; Value: TVA508AccessibilityItem);
    function GetOwner: TPersistent; override;
//    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Manager: TVA508AccessibilityManager);
    destructor Destroy; override;
    procedure EnsureItemExists(Component: TWinControl);
    procedure RefreshItem(aComponent: TWinControl);
    function FindItem(Component: TWinControl; CreateIfNotFound: boolean = true): TVA508AccessibilityItem;
    function Add: TVA508AccessibilityItem;
    property Items[Index: Integer]: TVA508AccessibilityItem read GetItem write SetItem; default;
  end;

  TVA508AccessibilityManager = class(TComponent)
  private
    FDFMData: TObjectList;
    FData: TVA508AccessibilityCollection;
    function GetAccessLabel(Component: TWinControl): TLabel;
    function GetAccessProperty(Component: TWinControl): String;
    function GetAccessText(Component: TWinControl): String;
    Function GetAccessCols(Component: TWinControl): TColumnList;
    procedure SetAccessLabel(Component: TWinControl; const Value: TLabel);
    procedure SetAccessProperty(Component: TWinControl; const Value: String);
    procedure SetAccessText(Component: TWinControl; const Value: String);
    procedure SetAccessCols(Component: TWinControl; const Value: TColumnList);
    function GetRootComponent(Component: TComponent; var PropertyName: String): TComponent;
    function GetDefaultStringProperty(AComponent: TWinControl): String;
    procedure Initialize;
    function GetData: TVA508AccessibilityCollection;
    function OwnerCheck(Component: TComponent): boolean;
    function FindComponentOnForm(ComponentName: String): TComponent;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
    function GetUseDefault(Component: TWinControl): boolean;
    procedure SetUseDefault(Component: TWinControl; const Value: boolean);
    function GetComponentManager(
      Component: TWinControl): TVA508ComponentManager;
    procedure SetComponentManager(Component: TWinControl;
      const Value: TVA508ComponentManager);
  //  procedure SetupMSAA;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    function GetPropertList(Component: TWinControl): TStrings;
    function IsPropertyNameValid(Component: TWinControl; PropertyName: String): boolean;
    function ScreenReaderInquiry(Component: TWinControl): string;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetComponentName(AComponent: TComponent): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetProperties(Component: TWinControl; list: TStrings);
    procedure GetLabelStrings(list: TStringList);
    procedure RefreshComponents;
    property AccessText[Component: TWinControl]: string
                      read GetAccessText
                      write SetAccessText;
    property AccessLabel[Component: TWinControl]: TLabel read GetAccessLabel write SetAccessLabel;
    property AccessProperty[Component: TWinControl]: string read GetAccessProperty write SetAccessProperty;
    property AccessColumns[Component: TWinControl]: TColumnList read GetAccessCols write SetAccessCols;
    property ComponentManager[Component: TWinControl]: TVA508ComponentManager read GetComponentManager write SetComponentManager;
    property UseDefault[Component: TWinControl]: boolean read GetUseDefault write SetUseDefault;
  published
    property AccessData: TVA508AccessibilityCollection read GetData write FData stored FALSE;
  end;

  IVA508CustomDefaultCaption = interface(IInterface)
  ['{ED1E68FD-5432-4C9D-A250-2069F3A2CABE}']
    function GetDefaultCaption: string;
  end;

  TVA508ScreenReaderEvent = procedure(Sender: TObject; var Text: String) of object;
  TVA508ScreenReaderItemEvent = procedure(Sender: TObject; var Item: TObject) of object;

  TVA508ComponentAccessibility = class(TComponent)
  private
    FOnComponentNameQuery: TVA508ScreenReaderEvent;
    FOnCaptionQuery: TVA508ScreenReaderEvent;
    FOnValueQuery: TVA508ScreenReaderEvent;
    FOnStateQuery: TVA508ScreenReaderEvent;
    FOnInstructionsQuery: TVA508ScreenReaderEvent;
    FOnItemInstructionsQuery: TVA508ScreenReaderEvent;
    FOnItemQuery: TVA508ScreenReaderItemEvent;
    FComponentName: string;
    FCaption: string;
    FInstructions: string;
    FItemInstructions: string;
    FComponent: TWinControl;
    procedure SetComponent(const Value: TWinControl);
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    constructor Create(AOwner: TComponent); override;
    property Component: TWinControl read FComponent write SetComponent;
    property OnComponentNameQuery: TVA508ScreenReaderEvent read FOnComponentNameQuery write FOnComponentNameQuery;
    property OnCaptionQuery: TVA508ScreenReaderEvent read FOnCaptionQuery write FOnCaptionQuery;
    property OnValueQuery: TVA508ScreenReaderEvent read FOnValueQuery write FOnValueQuery;
    property OnStateQuery: TVA508ScreenReaderEvent read FOnStateQuery write FOnStateQuery;
    property OnInstructionsQuery: TVA508ScreenReaderEvent read FOnInstructionsQuery write FOnInstructionsQuery;
    property OnItemInstructionsQuery: TVA508ScreenReaderEvent read FOnItemInstructionsQuery write FOnItemInstructionsQuery;
    property OnItemQuery: TVA508ScreenReaderItemEvent read FOnItemQuery write FOnItemQuery;
    property ComponentName: string read FComponentName write FComponentName;
    property Caption: string read FCaption write FCaption;
    property Instructions: string read FInstructions write FInstructions;
    property ItemInstructions: string read FItemInstructions write FItemInstructions;
  end;

// automatically freed when component is destroyed
  TManagedType = (mtNone, mtCaption, mtComponentName, mtInstructions, mtValue, mtData,
                  mtState, mtStateChange, // NOTE - should ALWAYS use mtStateChange when mtState is used!!!
                  mtItemChange, mtItemInstructions, mtComponentRedirect);
  TManagedTypes = set of TManagedType;

  TVA508ComponentManager = class(TObject)
  private
    FManagedTypes: TManagedTypes;
  protected
    constructor Create(ManagedTypes: TManagedTypes); overload;
  public
    constructor Create; overload; virtual; abstract;
    function GetCaption(Component: TWinControl): string; virtual;
    function GetComponentName(Component: TWinControl): string; virtual;
    function GetInstructions(Component: TWinControl): string; virtual;
    function GetItemInstructions(Component: TWinControl): string; virtual;
    function GetValue(Component: TWinControl): string; overload; virtual;
    function GetData(Component: TWinControl; Value: string): string; overload; virtual;
    function GetState(Component: TWinControl): string; virtual;
    function GetItem(Component: TWinControl): TObject; virtual;
    function ManageCaption(Component: TWinControl): boolean; virtual;
    function ManageComponentName(Component: TWinControl): boolean; virtual;
    function ManageInstructions(Component: TWinControl): boolean; virtual;
    function ManageItemInstructions(Component: TWinControl): boolean; virtual;
    function ManageValue(Component: TWinControl): boolean; virtual;
    function ManageData(Component: TWinControl): boolean; virtual;
    function ManageState(Component: TWinControl): boolean; virtual;
    function MonitorForStateChange(Component: TWinControl): boolean; virtual;
    function MonitorForItemChange(Component: TWinControl): boolean; virtual;
    function RedirectsComponent(Component: TWinControl): boolean; virtual;
    function Redirect(Component: TWinControl; var ManagedType: TManagedType): TWinControl; virtual;
  end;

  TVA508StaticText = class;

  TVA508ChainedLabel = class(TLabel)
  private
    FStaticLabelParent: TVA508StaticText;
    FPreviousLabel: TControl;
    FNextLabel: TVA508ChainedLabel;
    procedure SetNextLabel(const Value: TVA508ChainedLabel);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    property NextLabel: TVA508ChainedLabel read FNextLabel write SetNextLabel;
  end;

  TVA508StaticText = class(TPanel)
  private
    FLabel: TLabel;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FNextLabel: TVA508ChainedLabel;
    FDeletingChain: boolean;
    FInitTabStop: boolean;
    FWordWrap: Boolean;
    procedure DeleteChain(FromLabel, ToLabel: TVA508ChainedLabel);
    procedure SetNextLabel(const Value: TVA508ChainedLabel);
    function GetLabelCaption: string;
    procedure SetLabelCaption(const Value: string);
    function GetRootName: string;
    procedure SetRootName(const Value: string);
    function GetShowAccelChar: boolean;
    procedure SetShowAccelChar(const Value: boolean);
    procedure UpdateSize;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    function GetAlignment: TAlignment;
    procedure SetAlignment(const Value: TAlignment);
    function GetWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);
    function GetLabelAlignment: TAlignment;
    function GetLabelLayout: TTextLayout;
    procedure SetLabelAlignment(const Value: TAlignment);
    procedure SetLabelLayout(const Value: TTextLayout);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure SetParent(AParent: TWinControl); override;
    property StaticLabel: TLabel read FLabel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateAll;
    property NextLabel: TVA508ChainedLabel read FNextLabel write SetNextLabel;
  published
    property TabStop default false;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    property Caption: string read GetLabelCaption write SetLabelCaption;
    property Name: string read GetRootName write SetRootName;
    property ShowAccelChar: boolean read GetShowAccelChar write SetShowAccelChar;
    property Alignment: TAlignment read GetAlignment write SetAlignment;
    Property WordWrap: Boolean read GetWordWrap write SetWordWrap;
    property LabelAlignment: TAlignment read GetLabelAlignment write SetLabelAlignment;
    property LabelLayout: TTextLayout read GetLabelLayout write SetLabelLayout;
  end;

  TVA508SilentComponent = class(TVA508ComponentManager)
  public
    function GetComponentName(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
    function GetValue(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
  end;

  TVA508AlternateHandleFunc = function(Component: TWinControl): HWnd;

  TVA508ManagedComponentClass = class(TVA508ComponentManager)
  private
    FClassType: TWinControlClass;
    FManageDescendentClasses: boolean;
  protected
    constructor Create(AClassType: TWinControlClass; ManageTypes: TManagedTypes;
                       AManageDescendentClasses: boolean = FALSE); overload;
    property ManageDescendentClasses: boolean read FManageDescendentClasses write FManageDescendentClasses;
  public
    property ComponentClassType: TWinControlClass read FClassType;
  end;

  TVA508ComplexComponentManager = class(TObject)
  private
    FComponentList: TObjectList;
    FSubComponentXRef: TObjectList;
    FComponentClass: TWinControlClass;
    FComponentNotifier: TVANotificationEventComponent;
    FSubComponentNotifier: TVANotificationEventComponent;
    procedure ComponentNotifyEvent(AComponent: TComponent; Operation: TOperation);
    procedure SubComponentNotifyEvent(AComponent: TComponent; Operation: TOperation);
    function IndexOfComponentItem(Component: TWinControl): integer;
    function IndexOfSubComponentXRef(Component: TWinControl): integer;
    function GetSubComponentList(Component: TWinControl): TList;
  protected
    procedure ClearSubControls(Component: TWinControl);
    procedure AddSubControl(ParentComponent, SubControl: TWinControl;
                            AccessibilityManager: TVA508AccessibilityManager);
    procedure RemoveSubControl(ParentComponent, SubControl: TWinControl);
  public
    constructor Create(AComponentClass: TWinControlClass); overload;
    destructor Destroy; override;
    procedure Refresh(Component: TWinControl;
                      AccessibilityManager: TVA508AccessibilityManager); virtual; abstract;
    function SubControlCount(Component: TWinControl): integer;
    function GetSubControl(Component: TWinControl; Index: integer): TWinControl;
    property ComponentClass: TWinControlClass read FComponentClass;
  end;


procedure RegisterAlternateHandleComponent(ComponentClass: TWinControlClass;
                                           AlternateHandleFunc: TVA508AlternateHandleFunc);
procedure RegisterComplexComponentManager(Manager: TVA508ComplexComponentManager);
procedure RegisterManagedComponentClass(Manager: TVA508ManagedComponentClass);
procedure RegisterMSAAQueryClassProc(MSAAClass: TWinControlClass; Proc: TVA508QueryProc);
procedure RegisterMSAAQueryListClassProc(MSAAClass: TWinControlClass; Proc: TVA508ListQueryProc);

Function GetComponentManager(Component: TWinControl): TVA508AccessibilityManager;

function StrToPChar(const AString: String):PChar;

{Registers a subcontrol with a 508 manager for the main control}
procedure RegisterDynamicSubControl(aControl, aSubControl: TWinControl);


const
  ComponentManagerSilentText = ' '; // '' does not silence the screen reader

  AccessibilityLabelPropertyName    = 'AccessLabel';
  AccessibilityPropertyPropertyName = 'AccessProperty';
  AccessibilityTextPropertyName     = 'AccessText';
  AccessibilityUseDefaultPropertyName = 'UseDefault';
//  AccessibilityEventPropertyName    = 'OnAccessRequest';   // AccessEvent

  AccessDataStatusText = 'Status';
  AccessDataLabelText = 'Label';
  AccessDataPropertyText = 'Property';
  AccessDataTextText = 'Text';
//  AccessDataEventText = 'Event';
  AccessDataComponentText = 'Component';
  AccessDataColumns = 'Columns';


  VA508DataPropertyName = 'AccessData';
  VA508DFMDataPropertyName = 'Data';

  EQU = ' = ';
  EQU_LEN = length(EQU);

type
  TDefaultStringPropertyValuePair = record
    ClassType: TWinControlClass;
    PublishedPropertyName: String;
  end;

const
  CaptionedControlClassCount = 6;
  CaptionProperty = 'Caption';
  ControlsWithDefaultPropertySettings: array[1..CaptionedControlClassCount] of TDefaultStringPropertyValuePair =

   ((ClassType: TCustomForm; PublishedPropertyName: CaptionProperty),
  // includes TButton, TBitBtn, TCheckBox, TRadioButton, TDBCheckBox, and TGroupButton
    (ClassType: TButtonControl; PublishedPropertyName: CaptionProperty),
  // includes TPanel, TFlowPanel and TGridPanel, but not TDBNAvigator or TDecisionPivot
  //                               because they do not have a published Caption property
    (ClassType: TCustomPanel; PublishedPropertyName: CaptionProperty),
  // Includes TGroupBox, TRadioGroup and TDBRadioGroupBox
    (ClassType: TCustomGroupBox; PublishedPropertyName: CaptionProperty),
  // TStaticText only
    (ClassType: TCustomStaticText; PublishedPropertyName: CaptionProperty),
  // TLabeledEdit only
    (ClassType: TCustomLabeledEdit; PublishedPropertyName: 'EditLabel.' + CaptionProperty));

implementation

// VA508DelphiCompatibility added to ensure initialization section runs
uses ComObj, VA508Classes, VA508AccessibilityRouter, VA508DelphiCompatibility,
  VA508ScreenReaderDLLLinker, Types, VA508MSAASupport;

type
  TVA508RegistrationScreenReader = class(TVA508ScreenReader);

  TComponentHelper = class(TObject)
  private
    FRedirectedComponent: TWinControl;
    FRedirectedHelper: TComponentHelper;
    FRedirectedHelperType: TManagedType;
    FHandleKey: string;
    FComponent: TWinControl;
    FManager: TVA508AccessibilityManager;
    FManagedClassData: TVA508ManagedComponentClass;
    FFieldObject: TVA508ComponentAccessibility;
    FComponentManager: TVA508ComponentManager;
    FComplexManager: TVA508ComplexComponentManager;
    procedure ClearRedirect;
    function Redirect(RedirectType: TManagedType): boolean;
//  published
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitializeComponentManager;
    function GetCaption(var DataResult: LongInt): string;
    function GetComponentName(var DataResult: LongInt): string;
    function GetInstructions(var DataResult: LongInt): string;
    function GetItemInstructions(var DataResult: LongInt): string;
    function GetValue(var DataResult: LongInt): string;
    function GetData(var DataResult: LongInt; Value: string): string;
    function GetState(var DataResult: LongInt): string;
    function GetItem: TObject;
    function ManageComponentName: boolean;
    function ManageInstructions: boolean;
    function ManageItemInstructions: boolean;
    function ManageValue: boolean;
    function ManageData: boolean;
    function MonitorForStateChange: boolean;
    function MonitorForItemChange: boolean;
    function ManageCaption: boolean;
    function StandardComponent: boolean;
    property ComponentManager: TVA508ComponentManager read FComponentManager;
    property HandleKey: string read FHandleKey write FHandleKey;
    property Component: TWinControl read FComponent write FComponent;
    property Manager: TVA508AccessibilityManager read FManager write FManager;
    property ManagedClassData: TVA508ManagedComponentClass read FManagedClassData write FManagedClassData;
    property FieldObject: TVA508ComponentAccessibility read FFieldObject write FFieldObject;
    property ComplexManager: TVA508ComplexComponentManager read FComplexManager write FComplexManager;
  end;

  TComponentData = record
    Handle:           HWND;
    CaptionQueried:   boolean;
    ValueQueried:     boolean;
    StateQueried:     boolean;
    ItemInstrQueried: boolean;
    Caption:          string;
    Item:             TObject;
    State:            string;
    ItemInstructions: string;
  end;

const
  //IIDelim = '^';    Nope.  A type that starts with II is NOT a constant.  It's an interface.
  DELIM = '^';

  NewComponentData: TComponentData =
    (Handle:           0;
     CaptionQueried:   FALSE;
     ValueQueried:     FALSE;
     StateQueried:     FALSE;
     ItemInstrQueried: FALSE;
     Caption:          '';
     Item:             nil;
     State:            '';
     ItemInstructions: DELIM);
type
  TScreenReaderEventType = (sreCaption, sreValue, sreState, sreInstructions, sreItemInstructions);

  TVAGlobalComponentRegistry = class(TObject)
  private
    class var
      FActive: boolean;
      FGetMsgHookHandle: HHOOK;
  private
    FCurrentHelper: TComponentHelper;
    FDestroying: boolean;
    FComponentRegistry: TStringList;
    FHandlesXREF: TStringList;
    FHandlesPending: TStringList;
    FPendingRecheckTimer: TTimer;
    FCheckingPendingList: boolean;
    FUnregisteringComponent: boolean;
    FComponentData: TComponentData;
    FPendingFieldObjects: TStringList;
    function GetComponentHelper(WindowHandle: HWND): TComponentHelper;
    procedure CheckForChangeEvent;
    function GetComponentHandle(Component: TWinControl): Hwnd;
    function HasHandle(Component: TWinControl; var HandleKey: String): boolean;
    function GetCompKey(Component: TWinControl): String;
    procedure UpdateHandles(WindowHandle: HWnd; var HandlesModified: boolean);
  protected
    procedure TimerEvent(Sender: TObject);
    procedure ComponentDataNeededEvent(const WindowHandle: HWND; var DataStatus: LongInt;
        var Caption: PChar; var Value: PChar; var Data: PChar; var ControlType: PChar;
        var State: PChar; var Instructions: PChar; var ItemInstructions: PChar);
    procedure RegisterMSAA(Component: TWinControl);
    procedure UnregisterMSAA(Component: TWinControl);
  public
    constructor Create;
    destructor Destroy; override;
    function GetFieldObject(Component: TWinControl): TVA508ComponentAccessibility;
    procedure RegisterFieldObject(Component: TWinControl; FieldObject: TVA508ComponentAccessibility;
                                    Adding: boolean);
    procedure RegisterComponent(component: TWinControl; Manager: TVA508AccessibilityManager);
    procedure UnregisterComponent(component: TWinControl);
  end;


  TDFMColumnData = record
   var
    fColumn: Integer;
    fValue: Boolean;
   procedure Add(aColumn: Integer; aValue: Boolean);
   property Column: Integer read fColumn;
   property Value: Boolean read fValue;
  end;

  TDFMData = class(TObject)
  private
    ComponentName: string;
    LabelName: string;
    PropertyName: string;
    Text: string;
    Status: TVA508AccessibilityStatus;
    Columns: Array of TDFMColumnData;
//    Event: TVA508ComponentScreenReaderEvent;
   public
    destructor Destroy; Override;
  end;

  TMSAAData = class(TObject)
  private
    MSAAClass: TWinControlClass;
    Proc: TVA508QueryProc;
    ListProc: TVA508ListQueryProc;
  end;

{ TVA508AccessibilityItem }

const
  INVALID_COMPONENT_ERROR = 'Internal Error - Invalid Component';
  NAME_DELIM = '.';

var
  MasterPropertyList: TStringList = nil;
  GlobalRegistry: TVAGlobalComponentRegistry = nil;
  AltHandleClasses: TObjectList = nil;
  ManagedClasses: TObjectList = nil;
  ComplexClasses: TObjectList = nil;
  MSAAQueryClasses: TObjectList = nil;


function StrToPChar(const AString: String):PChar;
var
  I,
  BufSize: Integer;
begin
  //BufSize := (length(AString) + 1) *2;
  BufSize := (length(AString) * SizeOf(PChar)) + 1;
  result := AllocMem(BufSize);
  //Delphi strings are 1-indexed, not 0-indexed.
  for I := 1 to Length(AString) do
    result[I - 1] := AString[I];
end;

procedure CreateGlobalRegistry;
begin
  if ScreenReaderSystemActive and (not assigned(GlobalRegistry)) then
    GlobalRegistry := TVAGlobalComponentRegistry.Create;
end;

procedure CreateGlobalVars;
begin
  if not assigned(MasterPropertyList) then
    MasterPropertyList := TStringList.create;
  CreateGlobalRegistry;
end;

procedure FreeGlobalVars;
begin
  if assigned(MasterPropertyList) then
    FreeAndNilTStringsAndObjects(MasterPropertyList);
  if assigned(GlobalRegistry) then
    FreeAndNil(GlobalRegistry);
  if assigned(AltHandleClasses) then
    FreeAndNil(AltHandleClasses);
  if assigned(ManagedClasses) then
    FreeAndNil(ManagedClasses);
  if assigned(ComplexClasses) then
    FreeAndNil(ComplexClasses);
  if assigned(MSAAQueryClasses) then
    FreeAndNil(MSAAQueryClasses);
end;

procedure TVA508AccessibilityItem.Assign(Source: TPersistent);
var
  item: TVA508AccessibilityItem;
begin
  if Source is TVA508AccessibilityItem then
  begin
    item := TVA508AccessibilityItem(Source);
    FComponent := item.FComponent;
    FComponentManager := item.ComponentManager;
    FLabel := item.FLabel;
    FProperty := item.FProperty;
    FText := item.FText;
    FDefault := item.FDefault;
    FStatus := item.FStatus;
  end
  else inherited Assign(Source);
end;

constructor TVA508AccessibilityItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  if Assigned(Component) then
  begin
   if Component is TListView then
   begin
     if not Assigned(FAccessCol) then
      FAccessCol := TColumnList.Create;
   end;
  end;
end;

destructor TVA508AccessibilityItem.Destroy;
begin
  Parent.UnregisterComponent(FComponent);
  if assigned(FComponentManager) then
    FreeAndNil(FComponentManager);
  if Assigned(FAccessCol) then
   FreeAndNil(FAccessCol);
  inherited;
end;

function TVA508AccessibilityItem.GetDisplayName: string;
begin
  if assigned(FComponent) then
  begin
    Result := Manager.GetComponentName(FComponent) +
              '  (' + FComponent.ClassName + ')'
  end
  else
    Result := TVA508AccessibilityItem.ClassName;
end;

procedure TVA508AccessibilityItem.InitComponent(const Component: TWinControl; FromManager: boolean);
begin
  FComponent := Component;
  if Component is TListView then
   begin
     if not Assigned(FAccessCol) then
      FAccessCol := TColumnList.Create;
   end;
  if FromManager and (not (csReading in Manager.ComponentState)) then
    FDefault := TRUE;
end;

function TVA508AccessibilityItem.Manager: TVA508AccessibilityManager;
begin
  Result := TVA508AccessibilityCollection(Collection).FManager;
end;

function TVA508AccessibilityItem.Parent: TVA508AccessibilityCollection;
begin
  Result := TVA508AccessibilityCollection(Collection);
end;

Function TVA508AccessibilityItem.GetAccessColumns: TColumnList;
begin
  if not Assigned(FAccessCol) then
   FAccessCol := TColumnList.Create;

  result := FAccessCol;
end;

procedure TVA508AccessibilityItem.SetAccessColumns(const Value: TColumnList);
begin
  if not Assigned(FAccessCol) then
   FAccessCol := TColumnList.Create;

  FAccessCol.Assign(Value);
end;

procedure TVA508AccessibilityItem.SetComponent(const Component: TWinControl);
begin
  if (FComponent <> Component) and
    (([csDesigning, csFixups, csLoading, csReading, csUpdating] * Manager.ComponentState) <> []) and
    (not Parent.IsComponentRegistered(Component)) then
  begin
    Parent.UnregisterComponent(FComponent);
    InitComponent(Component, FALSE);
    Parent.RegisterComponent(Component, Self);
    if (Component is TListView) and (not Assigned(FAccessCol)) then
    begin
      FAccessCol := TColumnList.Create;
    end;
  end;
end;

procedure TVA508AccessibilityItem.SetDefault(const Value: boolean);
begin
  if FDefault <> Value then
  begin
    FDefault := Value;
    if FDefault then
    begin
      FLabel := nil;
      FText := '';
      FProperty := '';
    end
    else if (FProperty = '') and (not (csReading in Manager.ComponentState)) then
      FProperty := Manager.GetDefaultStringProperty(FComponent);
  end;
end;

procedure TVA508AccessibilityItem.SetLabel(const Value: TLabel);
begin
  if FLabel <> Value then
  begin
    FLabel := Value;
    if assigned(FLabel) then
    begin
      FProperty := '';
      FText := '';
      FDefault := FALSE;
    end;
  end;
end;

procedure TVA508AccessibilityItem.SetProperty(const Value: string);
begin
  if (FProperty <> Value) and
        ((Value = '') or (csreading in Manager.ComponentState) or
          Manager.IsPropertyNameValid(Component, Value)) then
  begin
    FProperty := Value;
    if (FProperty <> '') then
    begin
      FLabel := nil;
      FText := '';
      FDefault := FALSE;
    end;
  end;
end;

procedure TVA508AccessibilityItem.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    if FText <> '' then
    begin
      FLabel := nil;
      FProperty := '';
      FDefault := FALSE;
    end;
  end;
end;

procedure TVA508AccessibilityItem.UpdateStatus;
begin
  FStatus := stsNoData;
  if assigned(FComponent) then
  begin
    if FDefault then
      FStatus := stsDefault
    else
{ TODO : FIX THIS!!!!!!!!!!!!!!!! }
    if assigned(FLabel) or (AccessProperty <> '') or (FText <> '') then //or assigned(FEvent) then
      FStatus := stsOK
    else
    if FComponent.TabStop = FALSE then
      FStatus := stsNoTabStop;
  end;
end;

{ TVA508AccessibilityCollection }

function TVA508AccessibilityCollection.Add: TVA508AccessibilityItem;
begin
  Result := TVA508AccessibilityItem(inherited Add);
end;

procedure TVA508AccessibilityCollection.ComponentNotifyEvent(
  AComponent: TComponent; Operation: TOperation);
var
  item: TVA508AccessibilityItem;
begin
  if (Operation = opRemove) and (AComponent is TWinControl) then
  begin
    if ScreenReaderSystemActive then
      GlobalRegistry.UnregisterComponent(TWinControl(AComponent));

    item := FindItem(TWinControl(AComponent), FALSE);
    if assigned(item) then
      item.Free;
  end;
end;

constructor TVA508AccessibilityCollection.Create(
  Manager: TVA508AccessibilityManager);
begin
  inherited Create(TVA508AccessibilityItem);
  FManager := Manager;
  FRegistry := TStringList.Create;
  FRegistry.Sorted := TRUE;
  FRegistry.Duplicates := dupAccept; // speeds things up
  FNotifier := TVANotificationEventComponent.NotifyCreate(nil, ComponentNotifyEvent);
end;

destructor TVA508AccessibilityCollection.Destroy;
begin
  FNotifier.OnNotifyEvent := nil;
  FNotifier.Free;
  FreeAndNil(FRegistry);
 //FRegistry.Free;
  inherited;
end;

procedure TVA508AccessibilityCollection.EnsureItemExists(
  Component: TWinControl);
begin
  FindItem(Component);
end;

procedure TVA508AccessibilityCollection.RefreshItem(aComponent: TWinControl);
begin
  UnregisterComponent(aComponent);
  FindItem(aComponent);
end;

function TVA508AccessibilityCollection.FindItem(
  Component: TWinControl; CreateIfNotFound: boolean = true): TVA508AccessibilityItem;
var
  key: string;
  idx: integer;
begin
   Result := nil;
  if assigned(Component) then
  begin
    key := FastIntToHex(Integer(Component));
    idx := FRegistry.IndexOf(key);
    if idx < 0 then
    begin
      if CreateIfNotFound then
      begin
        Result := Add;
        Result.InitComponent(Component, TRUE);
        RegisterComponent(Component, Result);
      end;
    end
    else
      Result := TVA508AccessibilityItem(FRegistry.Objects[idx]);
  end;
end;

function TVA508AccessibilityCollection.GetItem(
  Index: Integer): TVA508AccessibilityItem;
begin
  Result := TVA508AccessibilityItem(inherited GetItem(Index));
end;

function TVA508AccessibilityCollection.GetOwner: TPersistent;
begin
  Result := FManager;
end;

function TVA508AccessibilityCollection.IsComponentRegistered(
  Component: TWinControl): boolean;
begin
  if assigned(Component) then
    Result := FRegistry.IndexOf(FastIntToHex(Integer(Component))) >= 0
  else
    Result := TRUE;
end;

procedure TVA508AccessibilityCollection.UnregisterComponent(
  Component: TWinControl);
var
  key: string;
  idx: integer;
begin
  if ScreenReaderSystemActive then
    GlobalRegistry.UnregisterComponent(Component);

  if (not assigned(Component)) or (not Assigned(FRegistry)) then exit;
  key := FastIntToHex(Integer(Component));
  idx := FRegistry.IndexOf(key);
  if idx >= 0 then
  begin
    FRegistry.Delete(idx);
    Component.RemoveFreeNotification(FNotifier);
  end;
end;

procedure TVA508AccessibilityCollection.SetItem(Index: Integer;
  Value: TVA508AccessibilityItem);
begin
  inherited SetItem(Index, Value);
end;
{
procedure TVA508AccessibilityCollection.Update(Item: TCollectionItem);
begin
  inherited;
end;
}
procedure TVA508AccessibilityCollection.RegisterComponent(Component: TWinControl; Item: TVA508AccessibilityItem);
var
  key: string;
begin
  if ScreenReaderSystemActive then
    GlobalRegistry.RegisterComponent(Component, FManager);

  if (not assigned(Component)) or (not assigned(item)) then exit;
  key := FastIntToHex(Integer(Component));
  if FRegistry.IndexOf(key) < 0 then
  begin
    FRegistry.AddObject(key, Item);
    Component.FreeNotification(FNotifier);
  end;
end;

{ TVA508AccessibilityManager }

constructor TVA508AccessibilityManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  VA508ComponentCreationCheck(Self, AOwner, FALSE, FALSE);
  CreateGlobalVars;
  FData := TVA508AccessibilityCollection.Create(Self);
  Initialize;
end;

destructor TVA508AccessibilityManager.Destroy;
begin
  VA508ComponentDestructionCheck(Self);
  if assigned(FData) then
    FData.Free;
  if assigned(FDFMData) then
    FreeAndNil(FDFMData);
  inherited;
end;

function TVA508AccessibilityManager.FindComponentOnForm(
  ComponentName: String): TComponent;
var
  p: integer;
  comp: TComponent;
  name: String;

  function FindOwnedComponent(AComponent: TComponent; ComponentName: String): TComponent;
  var
    i: integer;
  begin
    Result := nil;
    if AnsiCompareText(ComponentName, AComponent.Name)= 0 then
    begin
      Result := AComponent;
      exit;
    end;
    for i := 0 to AComponent.ComponentCount - 1 do
    begin
      if (AnsiCompareText(ComponentName, AComponent.Components[i].Name)= 0) then
      begin
        Result := AComponent.Components[i];
        exit;
      end;
    end;
  end;

begin
  if RightStr(ComponentName,1) <> NAME_DELIM then
    ComponentName := ComponentName + NAME_DELIM;
  Result := nil;
  comp := owner;
  repeat
    p := pos(NAME_DELIM, ComponentName);
    if p > 0 then
    begin
      name := copy(ComponentName, 1, p-1);
      delete(ComponentName, 1, p);
      comp := FindOwnedComponent(comp, name);
    end;
  until p = 0;
  if assigned(comp) then
    Result := comp;
end;

function TVA508AccessibilityManager.GetAccessLabel(Component: TWinControl): TLabel;
begin
  Result := FData.FindItem(Component).AccessLabel;
end;

function TVA508AccessibilityManager.GetAccessProperty(Component: TWinControl): String;
begin
  Result := FData.FindItem(Component).AccessProperty;
end;

function TVA508AccessibilityManager.GetAccessText(Component: TWinControl): String;
begin
  Result := FData.FindItem(Component).AccessText;
end;

function TVA508AccessibilityManager.GetAccessCols(Component: TWinControl): TColumnList;
begin
  Result := nil;
  if Component is TListView then
  begin
   Result := FData.FindItem(Component).AccessColumns;
  end;
end;

function TVA508AccessibilityManager.GetComponentManager(
  Component: TWinControl): TVA508ComponentManager;
begin
  Result := FData.FindItem(Component).ComponentManager;
end;

function TVA508AccessibilityManager.GetComponentName(
  AComponent: TComponent): String;
var
  comp: TComponent;

  procedure error;
  begin
    raise EVA508AccessibilityException.Create(INVALID_COMPONENT_ERROR);
  end;

  function BasicComponentCheck(var Name: string): boolean;
  begin
    Result := TRUE;
    Name := '';
    if (not assigned(AComponent)) then error;
    if AComponent = owner then
    begin
      Name := AComponent.Name;
      exit;
    end;
    if not assigned(AComponent.Owner) then error;
    if (AComponent.owner = owner) then
      Name := AComponent.Name
    else
      Result := FALSE;
  end;

begin
  if BasicComponentCheck(Result) then exit;
  comp := AComponent;
  Result := AComponent.Name;
  while assigned(comp.Owner) and (comp.Owner <> Owner) do
  begin
    comp := comp.Owner;
    if Trim(Result) = '' then
      Result := comp.Name + NAME_DELIM + AComponent.ClassName
    else
      Result := comp.Name + NAME_DELIM + Result;
  end;
  if not assigned(comp.Owner) then error;
end;

function TVA508AccessibilityManager.GetData: TVA508AccessibilityCollection;
begin
  Result := FData;
end;

function TVA508AccessibilityManager.GetDefaultStringProperty(AComponent: TWinControl): String;
var
  i: integer;
  ValuePair: TDefaultStringPropertyValuePair;
  PropName: string;
begin
  Result := '';
  if not assigned(AComponent) then exit;
  for i := 1 to CaptionedControlClassCount do
  begin
    ValuePair := ControlsWithDefaultPropertySettings[i];
    if AComponent is ValuePair.ClassType then
    begin
      PropName := ValuePair.PublishedPropertyName;
      if IsPropertyNameValid(AComponent, PropName) then
        Result := PropName;
      break;
    end;
  end;
end;

procedure TVA508AccessibilityManager.GetLabelStrings(list: TStringList);

  procedure AddLabels(Component: TWinControl);
  var
    i: integer;
    control: TControl;
  begin
    for I := 0 to Component.ControlCount-1 do
    begin
      control := Component.Controls[i];
      if control is TLabel then
        list.Add(GetComponentName(control) + '="' + TLabel(control).Caption + '"')
      else
      begin
        if (control is TWinControl) and
           ((csAcceptsControls in control.ControlStyle) or (control is TFrame) or (control is TPageControl)) then
            AddLabels(TWinControl(control));
      end;
    end;
  end;

begin
  AddLabels(TWinControl(Owner));
  list.Sort;
end;

procedure TVA508AccessibilityManager.GetProperties(Component: TWinControl; list: TStrings);
begin
  list.Assign(GetPropertList(Component));
end;

function TVA508AccessibilityManager.GetPropertList(Component: TWinControl): TStrings;
const
//  STRING_FILTER = [tkChar, tkString, tkWChar, tkLString, tkWString];
  STRING_FILTER = [tkString, tkLString, tkWString, tkUString];
var
  pList: PPropList;
  i, idx, pCount, pSize: Integer;
  ClsInfo: Pointer;
  name: string;
  info: TStringList;
begin
  idx := MasterPropertyList.IndexOf(Component.ClassName);
  if idx < 0 then
  begin
    info := TStringList.Create;
    try
      ClsInfo := Component.ClassInfo;
      pCount := GetPropList(ClsInfo, STRING_FILTER, nil);
      pSize := pCount * SizeOf(Pointer);
      GetMem(pList, pSize);
      try
        GetPropList(ClsInfo, STRING_FILTER, pList);
        for i := 0 to pCount - 1 do
        begin
          name := String(pList^[I]^.Name);
          if (info.IndexOf(name) < 0) then
            info.Add(name);
        end;
      finally
        FreeMem(pList, pSize);
      end;
      info.Sorted := TRUE;
    finally
      MasterPropertyList.AddObject(Component.ClassName, info);
    end;
  end
  else
    info := TStringList(MasterPropertyList.Objects[idx]);
  Result := info;
end;

function TVA508AccessibilityManager.GetRootComponent(Component: TComponent;
  var PropertyName: String): TComponent;
var
  p: integer;
  CompName: string;
  root: TObject;

begin
  Root := Component;
  repeat
    p := pos(NAME_DELIM, PropertyName);
    if p > 0 then
    begin
      CompName := copy(PropertyName,1,p-1);
      delete(PropertyName,1,p);
      if IsPublishedProp(root, CompName) then
      begin
        root := GetObjectProp(root, CompName);
      end
      else
        root := nil;
    end;
  until (p=0) or (not assigned(root));
  if assigned(root) and (root is TComponent) and IsPublishedProp(root, PropertyName) then
    Result := TComponent(root)
  else
    Result := nil;
end;

function TVA508AccessibilityManager.GetUseDefault(
  Component: TWinControl): boolean;
begin
  Result := FData.FindItem(Component).UseDefault;
end;

function TVA508AccessibilityManager.IsPropertyNameValid(Component: TWinControl;
  PropertyName: String): boolean;
var
  list: TStrings;
begin
  if not assigned(Component) then
    Result := FALSE
  else
  begin
    list := GetPropertList(Component);
    Result := list.IndexOf(PropertyName) >= 0;
  end;
end;

procedure TVA508AccessibilityManager.Loaded;
var
  i, x: integer;
  data: TDFMData;
  component: TComponent;
  item: TVA508AccessibilityItem;

begin
  inherited;
  if assigned(FDFMData) then
  begin
    for i := 0 to FDFMData.Count-1 do
    begin
      data := TDFMData(FDFMData[i]);
      component := FindComponentOnForm(data.ComponentName);
      if assigned(component) and (component is TWinControl) then
      begin
        item := FData.FindItem(TWinControl(component));
        if data.LabelName <> '' then
        begin
          component := FindComponentOnForm(data.LabelName);
          if assigned(component) and (component is TLabel) then
            item.AccessLabel := TLabel(component);
        end;
        if data.PropertyName <> '' then
          item.AccessProperty := data.PropertyName;
        if data.Text <> '' then
          item.AccessText := data.Text;
        if data.Status = stsDefault then
          item.UseDefault := TRUE;
        if Length(data.Columns) > 0 then
        begin
          for x := Low(data.Columns) to High(data.Columns) do
            item.AccessColumns.Add(data.Columns[x].Column, data.Columns[x].Value);
        end;
      end;
    end;
    FData.EnsureItemExists(TWinControl(Owner));
    FreeAndNil(FDFMData);
  end;
  if not (csDesigning in ComponentState) then
    Initialize;
end;

procedure TVA508AccessibilityManager.Notification(AComponent: TComponent;
  Operation: TOperation);

  procedure UpdateComponent(Component: TWinControl; Adding: boolean);
  var
    i: integer;
    Control : TWinControl;
    item: TVA508AccessibilityItem;
  begin
    if Adding then
      FData.EnsureItemExists(Component)
    else
    begin
      item := FData.FindItem(Component, FALSE);
      if assigned(item) then
        item.Free;
    end;
    if (csAcceptsControls in Component.ControlStyle) then
    begin
      for I := 0 to Component.ControlCount - 1 do
      begin
        if Component.Controls[I] is TWinControl then
        begin
          Control := TWinControl(Component.Controls[I]);
          if OwnerCheck(Control) then
            UpdateComponent(Control, Adding);
        end;
      end;
    end;
  end;

begin
  inherited Notification(AComponent, Operation);
  if (not assigned(AComponent)) or (not (AComponent is TWinControl)) or
          (csDestroying in ComponentState) then exit;
  if Operation = opInsert then
    UpdateComponent(TWinControl(AComponent), TRUE)
  else
    UpdateComponent(TWinControl(AComponent), FALSE);
end;

function TVA508AccessibilityManager.OwnerCheck(Component: TComponent): boolean;
var
  root: TComponent;
begin
  Result := false;
  root := component;
  while assigned(root) do
  begin
    if root = owner then
    begin
      Result := true;
      exit;
    end;
    root := root.Owner;
  end;
end;

procedure TVA508AccessibilityManager.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty(VA508DFMDataPropertyName, ReadData, WriteData, TRUE);
end;

procedure TVA508AccessibilityManager.ReadData(Reader: TReader);
var
  data: TDFMData;
  line: string;
  name, value: string;
  idx: integer;

begin
  FData.Clear;
  if assigned(FDFMData) then
    FDFMData.Clear
  else
    FDFMData := TObjectList.Create;
  Reader.ReadListBegin;
  try
    while not Reader.EndOfList do
    begin
      Reader.ReadListBegin;
      try
        data := TDFMData.Create;
        FDFMData.Add(data);
        while not Reader.EndOfList do
        begin
          line := Reader.ReadString;
          idx := pos(EQU, line);
          if idx > 0 then
          begin
            name := copy(line,1,idx-1);
            value := copy(line, idx+EQU_LEN, MaxInt);
            if name = AccessDataComponentText then
              data.ComponentName := value
            else if name = AccessDataLabelText then
              data.LabelName := value
            else if name = AccessDataPropertyText then
              data.PropertyName := value
            else if name = AccessDataTextText then
              data.Text := value
            else if name = AccessDataStatusText then
              data.Status := TVA508AccessibilityStatus(GetEnumValue(
                                TypeInfo(TVA508AccessibilityStatus), value))

          end else begin
            if Trim(line) = AccessDataColumns then
            begin
              Reader.ReadListBegin;
              try
                while not Reader.EndOfList do
                begin
                  line := Reader.ReadString;
                  idx := pos(EQU, line);
                  if idx > 0 then
                  begin
                    name := copy(line,1,idx-1);
                    value := copy(line, idx+EQU_LEN, MaxInt);
                    SetLength(data.Columns, Length(data.Columns) + 1);
                    data.Columns[High(data.Columns)].Add(StrToIntDef(name, -1), StrToBoolDef(value, true));
                  end;
                end;
              finally
                Reader.ReadListEnd
              end;
            end;
          end;
        end;
      finally
        Reader.ReadListEnd
      end;
    end;
  finally
    Reader.ReadListEnd;
  end;
end;

procedure TVA508AccessibilityManager.RefreshComponents;
begin
  Initialize;
end;

procedure TVA508AccessibilityManager.WriteData(Writer: TWriter);
var
  i, X: integer;
  item: TVA508AccessibilityItem;
  tmpStr: String;
begin
// ??????????????????
//  for i := FData.Count-1 downto 0 do
//  begin
//    if not assigned(FData.Items[i].Component) then
//      FData.Delete(i);
//  end;

  Writer.WriteListBegin;
  try
    for i := 0 to FData.Count - 1 do
    begin
      item := FData.Items[i];
      if assigned(item.Component) then
      begin
        item.UpdateStatus;
        Writer.WriteListBegin;
        try
          Writer.WriteString(AccessDataComponentText + EQU +
                              GetComponentName(item.Component));
          if assigned(item.AccessLabel) then
            Writer.WriteString(AccessDataLabelText + EQU +
                              GetComponentName(item.AccessLabel));
          if item.AccessProperty <> '' then
            Writer.WriteString(AccessDataPropertyText + EQU + item.AccessProperty);
          if item.AccessText <> '' then
            Writer.WriteString(AccessDataTextText + EQU + item.AccessText);

          Writer.WriteString(AccessDataStatusText + EQU +
              GetEnumName(TypeInfo(TVA508AccessibilityStatus), ord(item.Status)));

          if Assigned(item.AccessColumns) then
          begin
            if item.AccessColumns.Count > 0 then
            begin
              Writer.WriteString(AccessDataColumns);
              Writer.WriteListBegin;
              for X := 0 to item.AccessColumns.Count - 1 do
              begin
                 if item.AccessColumns.Values[x] then
                  tmpStr := 'True'
                 else
                  tmpStr := 'False';

                 Writer.WriteString(item.AccessColumns.Names[x] + EQU + tmpStr);
              end;
              Writer.WriteListEnd;
            end;
          end;


        finally
          Writer.WriteListEnd;
        end;
      end;
    end;
  finally
    Writer.WriteListEnd;
  end;
end;

type
  AccessComponent = class(TWinControl);

function TVA508AccessibilityManager.ScreenReaderInquiry(
  Component: TWinControl): string;
var
  item: TVA508AccessibilityItem;
  prop: string;
  comp: TComponent;
  DynaComp: IVADynamicProperty;

begin
  Result := '';
  item := FData.FindItem(Component);

  if item.UseDefault then
  begin
    if AccessComponent(Component).QueryInterface(IVADynamicProperty,DynaComp) = S_OK then
    begin
      try
        if DynaComp.SupportsDynamicProperty(DynaPropAccesibilityCaption) then
          Result := DynaComp.GetDynamicProperty(DynaPropAccesibilityCaption);
      finally
        DynaComp := nil;
      end;
    end;
  end
  else
  begin
    if assigned(item.AccessLabel) then
      Result := item.AccessLabel.Caption
    else if item.AccessText <> '' then
      Result := item.AccessText
    else
    begin
      prop := item.AccessProperty;
      if prop <> '' then
      begin
        comp := GetRootComponent(Component, prop);
        if assigned(comp) then
          Result := GetPropValue(comp, prop);
      end;
    end;
  end;
end;

procedure TVA508AccessibilityManager.SetAccessLabel(Component: TWinControl;
  const Value: TLabel);
begin
  FData.FindItem(Component).AccessLabel := Value;
end;

procedure TVA508AccessibilityManager.SetAccessProperty(Component: TWinControl;
  const Value: String);
begin
  FData.FindItem(Component).AccessProperty := Value;
end;

procedure TVA508AccessibilityManager.SetAccessText(Component: TWinControl;
  const Value: String);
begin
  FData.FindItem(Component).AccessText := Value;
end;

procedure TVA508AccessibilityManager.SetAccessCols(Component: TWinControl;
  const Value: TColumnList);
begin
  if Component is TListView then
  begin
   FData.FindItem(Component).AccessColumns := Value;
  end;
end;

procedure TVA508AccessibilityManager.SetComponentManager(Component: TWinControl;
  const Value: TVA508ComponentManager);
begin
  FData.FindItem(Component).ComponentManager := Value;
end;

procedure TVA508AccessibilityManager.SetUseDefault(Component: TWinControl;
  const Value: boolean);
begin
  FData.FindItem(Component).UseDefault := Value;
end;

procedure TVA508AccessibilityManager.Initialize;
var
  list: TList;
  i, idx: integer;
  control: TWinControl;
  item: TVA508AccessibilityItem;

  procedure Update(Component: TWinControl);
  var
    i: integer;
  begin
    if (not assigned(Component.Parent)) or
      ((csAcceptsControls in Component.Parent.ControlStyle) and
      ((not(csDesigning in Component.ComponentState)) or
      (Trim(Component.name) <> ''))) then
      list.add(Component);
    for I := 0 to Component.ControlCount - 1 do
    begin
      if Component.Controls[I] is TWinControl then
      begin
        Control := TWinControl(Component.Controls[I]);
        if (not assigned(Control.Owner)) or OwnerCheck(Control) then
          Update(Control);
      end;
    end;
  end;

begin
  list := TList.Create;
  try
    if (Owner is TWinControl) and ([csLoading{, csDesignInstance}] * Owner.ComponentState = []) then
      Update(TWinControl(Owner));

    for I := FData.Count - 1 downto 0 do
    begin
      item := FData[i];

      if assigned(item.Component) then
      begin
        idx := list.IndexOf(item.Component);
        if idx < 0 then
          item.Free
        else
          list.delete(idx);
      end
      else
        item.free;
    end;

    for I := 0 to List.Count - 1 do
    begin
      FData.EnsureItemExists(TWinControl(list[i]));
    end;
  finally
    list.free;
  end;
end;

{ Registration }
type
  TAlternateHandleData = class
    ComponentClass: TWinControlClass;
    GetHandle: TVA508AlternateHandleFunc;
  end;

procedure RegisterAlternateHandleComponent(ComponentClass: TWinControlClass;
                                           AlternateHandleFunc: TVA508AlternateHandleFunc);
var
  data: TAlternateHandleData;
  i: integer;
begin
  if not ScreenReaderSystemActive then exit;
  if not assigned(AltHandleClasses) then
    AltHandleClasses := TObjectList.Create
  else
  begin
    for i := 0 to AltHandleClasses.Count - 1 do
    begin
      if assigned(AltHandleClasses[i]) then
      begin
        data := TAlternateHandleData(AltHandleClasses[i]);
        if ComponentClass = data.ComponentClass then exit;
      end;
    end;
  end;
  data := TAlternateHandleData.Create;
  data.ComponentClass := ComponentClass;
  data.GetHandle := AlternateHandleFunc;
  AltHandleClasses.Add(data);
end;

procedure RegisterComplexComponentManager(Manager: TVA508ComplexComponentManager);
var
  data: TVA508ComplexComponentManager;
  i: integer;
begin
  if ScreenReaderSystemActive then
  begin
    if not assigned(ComplexClasses) then
      ComplexClasses := TObjectList.Create
    else
    begin
      for i := 0 to ComplexClasses.Count - 1 do
      begin
        data := TVA508ComplexComponentManager(ComplexClasses[i]);
        if data.ComponentClass = Manager.ComponentClass then
        begin
          Manager.Free;
          exit;
        end;
      end;
    end;
    ComplexClasses.Add(Manager);
  end
  else
    Manager.Free;
end;

procedure RegisterManagedComponentClass(Manager: TVA508ManagedComponentClass);
var
  data: TVA508ManagedComponentClass;
  i: integer;
begin
  if ScreenReaderSystemActive then
  begin
    if not assigned(ManagedClasses) then
      ManagedClasses := TObjectList.Create
    else
    begin
      for i := 0 to ManagedClasses.Count - 1 do
      begin
        data := TVA508ManagedComponentClass(ManagedClasses[i]);
        if Manager.ComponentClassType = data.ComponentClassType then
        begin
          if Manager <> data then
            Manager.Free;
          exit;
        end;
      end;
    end;
    ManagedClasses.Add(Manager);
  end
  else
    Manager.Free;
end;

function FindMSAAQueryData(MSAAClass: TWinControlClass): TMSAAData;
var
  i: integer;
begin
  Result := nil;
  if not assigned(MSAAQueryClasses) then exit;
  for i := 0 to MSAAQueryClasses.Count - 1 do
  begin
    Result := TMSAAData(MSAAQueryClasses[i]);
    if MSAAClass.InheritsFrom(Result.MSAAClass) then exit;
  end;
  Result := nil;
end;

procedure RegisterMSAAProc(MSAAClass: TWinControlClass;
          Proc: TVA508QueryProc; ListProc: TVA508ListQueryProc);
var
  Data: TMSAAData;
begin
  if not assigned(MSAAQueryClasses) then
    MSAAQueryClasses := TObjectList.Create;
  Data := FindMSAAQueryData(MSAAClass);
  if not assigned(Data) then
  begin
    Data := TMSAAData.Create;
    Data.MSAAClass := MSAAClass;
    Data.Proc := Proc;
    Data.ListProc := ListProc;
    MSAAQueryClasses.Add(Data);
  end;
end;

procedure RegisterMSAAQueryClassProc(MSAAClass: TWinControlClass; Proc: TVA508QueryProc);
begin
  RegisterMSAAProc(MSAAClass, Proc, nil);
end;

procedure RegisterMSAAQueryListClassProc(MSAAClass: TWinControlClass; Proc: TVA508ListQueryProc);
begin
  RegisterMSAAProc(MSAAClass, nil, Proc);
end;

Function GetComponentManager(Component: TWinControl): TVA508AccessibilityManager;
var
  Helper: TComponentHelper;
begin
  Helper := GlobalRegistry.GetComponentHelper(Component.Handle);
  
  if assigned(Helper) then
    result := Helper.Manager
  else
    result := nil;  
end;

{ TVAGlobalComponentRegistry }

procedure TVAGlobalComponentRegistry.CheckForChangeEvent;
var
  Helper: TComponentHelper;
  NewCaption: string;
  NewState: string;

  NewItem: TObject;
  SendData: boolean;
  CheckState: boolean;
  DataResult: LongInt;
  DataStatus: LongInt;
  NewItemInstructions: string;
  Temp: string;

  Caption: String;
  Value: String;
  Data: String;
  ControlType: String;
  State: String;
  Instructions: String;
  ItemInstructions: String;

  function HandleStillValid: boolean;
  begin
    Result := IsWindow(FComponentData.Handle) and IsWindowVisible(FComponentData.Handle);
  end;

  function NoChangeNeeded: boolean;
  begin
    Result := TRUE;
    if not assigned(SRComponentData) then exit;
    if not assigned(SRConfigChangePending) then exit;
    if FComponentData.Handle = 0 then exit;
    Helper := GetComponentHelper(FComponentData.Handle);
    if not assigned(Helper) then exit;
    Helper.InitializeComponentManager;
    if Helper.StandardComponent then exit;
    if SRConfigChangePending then exit;
    Result := FALSE;
  end;

  procedure Init;
  begin
    DataResult := DATA_NONE;
    DataStatus := DATA_NONE;
    {
    Caption := nil;
    Value := nil;
    Data := nil;
    ControlType := nil;
    State := nil;
    Instructions := nil;
    ItemInstructions := nil;
    CheckState := TRUE;
    }
  end;

  procedure ProcessCaptionChange;
  begin
    if FComponentData.CaptionQueried and Helper.ManageCaption then
    begin
      NewCaption := Helper.GetCaption(DataResult);
      if (FComponentData.Caption <> NewCaption) then
      begin
        FComponentData.Caption := NewCaption;
        if ((DataResult and DATA_CAPTION) <> 0) then
        begin
          DataStatus := DataStatus OR DATA_CAPTION;
          Caption := PChar(NewCaption);
        end;
      end;
    end;
  end;

  procedure ProcessItemChange;
  var
    TempValue: string;
  begin
    if FComponentData.ValueQueried and Helper.MonitorForItemChange then
    begin
      NewItem := Helper.GetItem;
      if (FComponentData.Item <> NewItem) then
      begin
        FComponentData.Item := NewItem;
        CheckState := FALSE;
        SendData := FALSE;

        if Helper.ManageValue then
        begin
          Value := PChar(Helper.GetValue(DataResult));
          if (DataResult AND DATA_VALUE) <> 0 then
          begin
            SendData := TRUE;
            DataStatus := DataStatus OR DATA_VALUE;
          end;
        end;

        if Helper.ManageData then
        begin
          if Helper.ManageValue then
            TempValue := Value
          else
            TempValue := '';
          Data := PChar(Helper.GetData(DataResult, Value));
          if (DataResult AND DATA_DATA) <> 0 then
          begin
            SendData := TRUE;
            DataStatus := DataStatus OR DATA_DATA;
          end;
        end;

        if FComponentData.StateQueried and Helper.MonitorForStateChange then
        begin
          NewState := Helper.GetState(DataResult);
          if FComponentData.State <> NewState then
            FComponentData.State := NewState;
          if (DataResult AND DATA_STATE) <> 0 then
          begin
            State := PChar(NewState);
            SendData := TRUE;
            DataStatus := DataStatus OR DATA_STATE;
            if FComponentData.ItemInstrQueried and Helper.ManageItemInstructions then
            begin
              NewItemInstructions := Helper.GetItemInstructions(DataResult);
              if NewItemInstructions <> '' then
              begin
                temp := DELIM + NewItemInstructions + DELIM;
                if pos(temp, FComponentData.ItemInstructions) < 1  then
                begin
                  FComponentData.ItemInstructions := FComponentData.ItemInstructions + NewItemInstructions + DELIM;
                  ItemInstructions := PChar(NewItemInstructions);
                  if (DataResult AND DATA_ITEM_INSTRUCTIONS) <> 0 then
                    DataStatus := DataStatus OR DATA_ITEM_INSTRUCTIONS;
                end;
              end;
            end;
          end;
        end;
        if SendData then
          DataStatus := DataStatus OR DATA_ITEM_CHANGED;
      end;
    end;
  end;

  procedure ProcessStateChange;
  begin
    if CheckState and FComponentData.StateQueried and Helper.MonitorForStateChange then
    begin
      NewState := Helper.GetState(DataResult);
      if FComponentData.State <> NewState then
      begin
        FComponentData.State := NewState;
        if (DataResult AND DATA_STATE) <> 0 then
        begin
          State := PChar(NewState);
          DataStatus := DataStatus OR DATA_STATE;
        end;
      end;
    end;
  end;

  procedure AddControlType;
  begin
    if (DataStatus <> DATA_NONE) and Helper.ManageComponentName then
    begin
      if not assigned(Helper) then
        raise EVA508AccessibilityException.Create('Helper not assigned in VA508AccessibilityManager.AddControlType');
        
      ControlType := Helper.GetComponentName(DataResult);
      if ControlType = '' then
        raise EVA508AccessibilityException.Create('ControlType nil in VA508AccessibilityManager.AddControlType');
        
      if (DataResult AND DATA_CONTROL_TYPE) <> 0 then
      begin
        DataStatus := DataStatus OR DATA_CONTROL_TYPE;
      end;
    end;
  end;

  procedure SendChangeData;
  var
    pCaption: PChar;
    pValue: PChar;
    pData: PChar;
    pControlType: PChar;
    pState: PChar;
    pInstructions: PChar;
    pItemInstructions: PChar;
  begin
    if (DataStatus <> DATA_NONE) then
    begin
      DataStatus := DataStatus OR DATA_CHANGE_EVENT;
      pCaption := StrToPChar(Caption);
      pValue := StrToPChar(Value);
      pData := StrToPChar(Data);
      pControlType := StrToPChar(ControlType);
      pState := StrToPChar(State);
      pInstructions := StrToPChar(Instructions);
      pItemInstructions := StrToPChar(ItemInstructions);
      try

        SRComponentData(FComponentData.Handle, DataStatus, pCaption, pValue, pData, pControlType,
                        pState, pInstructions, pItemInstructions);
      finally
        FreeMem(pItemInstructions);
        FreeMem(pInstructions);
        FreeMem(pState);
        FreeMem(pControlType);
        FreeMem(pData);
        Freemem(pValue);
        FreeMem(pCaption);
      end;
    end;
  end;

begin
  if NoChangeNeeded then
  begin
    exit;
  end;
  // HandleStillValid needed because reminders destroy check boxes from underneath us
  if HandleStillValid then Init;
  if HandleStillValid then ProcessCaptionChange;
  if HandleStillValid then ProcessItemChange;
  if HandleStillValid then ProcessStateChange;
  if HandleStillValid then AddControlType;
  if HandleStillValid then SendChangeData;
end;


procedure TVAGlobalComponentRegistry.ComponentDataNeededEvent(const WindowHandle: HWND;
    var DataStatus: LongInt; var Caption: PChar; var Value: PChar; var Data: PChar;
    var ControlType: PChar; var State: PChar; var Instructions: PChar; var ItemInstructions: PChar);
var
  DataResult: LongInt;
  UseCaption: boolean;
  UseValue: boolean;
  UseControlType: boolean;
  UseState: boolean;
  UseInstructions: boolean;
  UseItemInstructions: boolean;
  NewCaption: string;
  NewState: string;
  NewItemInstructions: string;
  NewValue: string;
  NewData: string;
  NewInstructions: string;
  NewControlType: string;
  Component: TWinControl;
  HelperInvalid: boolean;
  Done: boolean;
  temp: string;

  function HelperValid: boolean;
  begin
    if HelperInvalid then
    begin
      Result := FALSE;
      exit;
    end;
    try
      Result := assigned(FCurrentHelper) and
                assigned(FCurrentHelper.FComponent) and
                IsWindow(FCurrentHelper.FComponent.Handle) and
                IsWindowVisible(FCurrentHelper.FComponent.Handle);
    except
      Result := FALSE;
    end;
    if not Result then
    begin
      HelperInvalid := TRUE;
    end;
  end;

  procedure UpdateComponentData;
  begin
    if (FComponentData.Handle = WindowHandle) then
    begin
      if UseCaption then
      begin
        FComponentData.CaptionQueried := TRUE;
        FComponentData.Caption := NewCaption;
      end;
      if UseValue then
      begin
        FComponentData.ValueQueried := TRUE;
        if FCurrentHelper.MonitorForItemChange and HelperValid then
          FComponentData.Item := FCurrentHelper.GetItem;
      end;
      if UseState then
      begin
        FComponentData.StateQueried := TRUE;
        FComponentData.State := NewState;
      end;
      if UseItemInstructions then
      begin
        FComponentData.ItemInstrQueried := TRUE;
        FComponentData.ItemInstructions := DELIM + NewItemInstructions + DELIM;
      end;
    end;
  end;

  procedure InitializeVars;
  begin
    DataResult          := DATA_NONE;
    UseCaption          := ((DataStatus and DATA_CAPTION) <> 0);
    UseValue            := ((DataStatus and DATA_VALUE) <> 0);
    UseControlType      := ((DataStatus and DATA_CONTROL_TYPE) <> 0);
    UseState            := ((DataStatus and DATA_STATE) <> 0);
    UseInstructions     := ((DataStatus and DATA_INSTRUCTIONS) <> 0);
    UseItemInstructions := ((DataStatus and DATA_ITEM_INSTRUCTIONS) <> 0);

    NewCaption := '';
    NewState := '';
    NewItemInstructions := '';

    if HelperValid then FCurrentHelper.InitializeComponentManager;
  end;

  procedure GetDataValues;
  begin
    if UseCaption and HelperValid then
    begin
      NewCaption := FCurrentHelper.GetCaption(DataResult);
      Caption := PChar(NewCaption);
    end;

    if UseValue and HelperValid then
    begin
    //PChars are pointers - must point to string - if point to function thier values change unpredictably
      NewValue := FCurrentHelper.GetValue(DataResult);
      Value := PChar(NewValue);
      NewData := FCurrentHelper.GetData(DataResult, NewValue);
      Data := PChar(NewData);
    end;

    if UseControlType and HelperValid then
    begin
      NewControlType := FCurrentHelper.GetComponentName(DataResult);
      ControlType := PChar(NewControlType);
    end;

    if UseState and HelperValid then
    begin
      NewState := FCurrentHelper.GetState(DataResult);
      State := PChar(NewState);
    end;

    if UseInstructions and HelperValid then
    begin
      NewInstructions := FCurrentHelper.GetInstructions(DataResult);
      Instructions := PChar(NewInstructions);
    end;

    if UseItemInstructions and HelperValid then
    begin
      NewItemInstructions := FCurrentHelper.GetItemInstructions(DataResult);
      ItemInstructions := PChar(NewItemInstructions);
    end;
  end;

begin
  if FDestroying then exit;
  if (FComponentData.Handle <> WindowHandle) then
  begin
    FComponentData := NewComponentData;
    FComponentData.Handle := WindowHandle;
  end;

  HelperInvalid := FALSE;
  FCurrentHelper := GetComponentHelper(WindowHandle);
  if not assigned(FCurrentHelper) then
    DataResult := DATA_ERROR
  else
  begin
    if HelperValid then
    begin
      try
        repeat
          Done := TRUE;
          if HelperValid then
            Component := FCurrentHelper.FComponent
          else
            Component := nil;
          if HelperValid then InitializeVars;
          if HelperValid then temp := FCurrentHelper.Component.ClassName;
          if HelperValid then GetDataValues;
          if HelperValid then UpdateComponentData;
          if (not assigned(FCurrentHelper)) and assigned(Component) then
          begin
            try
              FCurrentHelper := GetComponentHelper(Component.Handle);
              Done := FALSE;
              HelperInvalid := FALSE;
            except
            end;
          end;
        until Done;
      finally
        FCurrentHelper := nil;
      end;
      if HelperInvalid and (DataResult = DATA_NONE) then
        DataResult := DATA_ERROR;
    end
    else
    begin
      FCurrentHelper := nil;
      DataResult := DATA_ERROR;
    end;
  end;
  DataStatus := DataResult;
end;

var
  CanAssignFocus: boolean = TRUE;

var
  CanCheckEvent: boolean = TRUE;

function GetMessageHookProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  pMessage: PMsg;
  msg: UINT;

begin
  if CanCheckEvent then
  begin
    CanCheckEvent := FALSE;
    try
      if TVAGlobalComponentRegistry.FActive and (code >= 0) then
      begin
        pMessage := pointer(lParam);
        msg := pMessage^.message and $ffff;
        case msg of
          WM_KEYFIRST .. WM_KEYLAST,
          (WM_MOUSEFIRST + 1) .. WM_MOUSELAST: // WM_MOUSEFIRST = WM_MOUSEMOVE
          GlobalRegistry.CheckForChangeEvent;
        end;
      end;
    finally
      CanCheckEvent := TRUE;
    end;
  end;
  Result := CallNextHookEx(TVAGlobalComponentRegistry.FGetMsgHookHandle, Code, wParam, lParam);
end;

constructor TVAGlobalComponentRegistry.Create;
begin
  FPendingFieldObjects := TStringList.Create;
  FComponentRegistry := TStringList.Create;
  FComponentRegistry.Duplicates := dupAccept;
  FComponentRegistry.Sorted := TRUE;
  FHandlesXREF := TStringList.Create;
  FHandlesXREF.Duplicates := dupAccept;
  FHandlesXREF.Sorted := TRUE;
  FHandlesPending := TStringList.Create;
  FPendingRecheckTimer := TTimer.Create(nil);
  FPendingRecheckTimer.Enabled := FALSE;
  FPendingRecheckTimer.OnTimer := TimerEvent;
  FPendingRecheckTimer.Interval := 500;
  FComponentData := NewComponentData;
  FGetMsgHookHandle := SetWindowsHookEx(WH_GETMESSAGE, GetMessageHookProc, 0, GetCurrentThreadID);
  TVA508RegistrationScreenReader(GetScreenReader).
              AddComponentDataNeededEventHandler(ComponentDataNeededEvent);
  FActive := TRUE;
end;

destructor TVAGlobalComponentRegistry.Destroy;
begin
  FDestroying := TRUE;
  FActive := FALSE;
  TVA508RegistrationScreenReader(GetScreenReader).RemoveComponentDataNeededEventHandler(ComponentDataNeededEvent);
  UnhookWindowsHookEx(FGetMsgHookHandle);
  FreeAndNil(FPendingRecheckTimer);
  FreeAndNil(FHandlesPending);
  FreeAndNil(FHandlesXREF);
  FreeAndNil(FPendingFieldObjects);
  FreeAndNilTStringsAndObjects(FComponentRegistry);
  inherited;
end;

function TVAGlobalComponentRegistry.GetCompKey(Component: TWinControl): String;
begin
  Result := FastIntToHex(Integer(Component));
end;

function TVAGlobalComponentRegistry.GetComponentHandle(Component: TWinControl): Hwnd;
var
  i: integer;
  UseDefault: boolean;
  data: TAlternateHandleData;
  ok: boolean;
begin
  Result := 0;
  ok := Component.Visible;
  if ok then
  begin
    ok := Component is TCustomForm;
    if not ok then
    begin
      ok := assigned(Component.parent);
      if ok then
        ok := Component.parent.Visible;
    end;
  end;
  if ok then
  begin
    UseDefault := TRUE;
    if assigned(AltHandleClasses) then
    begin
      for i := 0 to AltHandleClasses.Count-1 do
      begin
        if assigned(AltHandleClasses[i]) then
        begin
          data := TAlternateHandleData(AltHandleClasses[i]);
          if Component.InheritsFrom(data.ComponentClass) then
          begin
            UseDefault := FALSE;
            Result := data.GetHandle(Component);
          end;
        end;
      end;
    end;
    if UseDefault then
    begin
      try
        Result := Component.Handle
      except
        Result := 0;
      end;
    end;
  end;
end;

function TVAGlobalComponentRegistry.GetFieldObject(Component: TWinControl): TVA508ComponentAccessibility;
var
  idx: integer;
  compKey: string;
begin
  compKey := GetCompKey(component);
  idx := FComponentRegistry.IndexOf(compkey);
  if idx < 0 then
  begin
    idx := FPendingFieldObjects.IndexOf(compKey);
    if idx < 0 then
      Result := nil
    else
      Result := TVA508ComponentAccessibility(FPendingFieldObjects.Objects[idx]);
  end
  else
    Result := TComponentHelper(FComponentRegistry.Objects[idx]).FieldObject;
end;

function TVAGlobalComponentRegistry.GetComponentHelper(WindowHandle: HWND): TComponentHelper;
var
  key: string;
  idx: integer;
  Recheck: boolean;
begin
  Result := nil;
  if IsWindow(WindowHandle) and IsWindowVisible(WindowHandle) then
  begin
    key := FastIntToHex(WindowHandle);
    idx := FHandlesXREF.IndexOf(key);
    if idx < 0 then
    begin
      UpdateHandles(WindowHandle, Recheck);
      if Recheck then
        idx := FHandlesXREF.IndexOf(key);
    end;
    if idx >= 0 then
    begin
      Result := TComponentHelper(FHandlesXREF.Objects[idx]);
    end;
  end;
end;

function TVAGlobalComponentRegistry.HasHandle(Component: TWinControl;
  var HandleKey: String): boolean;
begin
  Result := FALSE;
  HandleKey := '';
  if FDestroying then exit;
  try
    if Component.Visible and ((Component.Parent <> nil) or (Component is TCustomForm)) then
      HandleKey := FastIntToHex(GetComponentHandle(Component));
  except
    HandleKey := '';
  end;
  Result := (HandleKey <> '') and (HandleKey <> '00000000');
end;

procedure TVAGlobalComponentRegistry.RegisterFieldObject(
  Component: TWinControl; FieldObject: TVA508ComponentAccessibility;
  Adding: boolean);
var
  idx: integer;
  compKey: string;
  Helper: TComponentHelper;

begin
  if FDestroying or (not assigned(Component)) then exit;
  compKey := GetCompKey(component);
  idx := FComponentRegistry.IndexOf(compkey);
  if idx < 0 then
  begin
    if Adding then
    begin
      if FPendingFieldObjects.IndexOf(CompKey) < 0 then
        FPendingFieldObjects.AddObject(compKey, FieldObject)
    end
    else
    begin
      idx := FPendingFieldObjects.IndexOf(CompKey);
      if idx >= 0 then
        FPendingFieldObjects.Delete(idx);
    end;
  end
  else
  begin
    Helper := TComponentHelper(FComponentRegistry.Objects[idx]);
    if Adding then
      Helper.FieldObject := FieldObject
    else
      Helper.FieldObject := nil;
  end;
end;

procedure TVAGlobalComponentRegistry.RegisterMSAA(Component: TWinControl);
var
  Data: TMSAAData;
begin
  if Component.InheritsFrom(TWinControl) then
  begin
    Data := FindMSAAQueryData(TWinControlClass(Component.ClassType));
    if assigned(Data) then
    begin
      if assigned(data.Proc) then
        RegisterMSAAComponentQueryProc(Component, Data.Proc)
      else
        RegisterMSAAComponentListQueryProc(Component, Data.ListProc)
    end;
  end;
end;

procedure TVAGlobalComponentRegistry.RegisterComponent(
      component: TWinControl; Manager: TVA508AccessibilityManager);
var
  Helper: TComponentHelper;
  compKey, handleKey: string;

  procedure CheckManagedClasses;
  var
    cls: TClass;
    pass: integer;
    i: integer;
    mData: TVA508ManagedComponentClass;
    found, ok: boolean;
  begin
    if assigned(ManagedClasses) then
    begin
      cls := Component.ClassType;
      found := FALSE;
      for pass := 0 to 1 do
      begin
        for i := 0 to ManagedClasses.Count - 1 do
        begin
          mData := TVA508ManagedComponentClass(ManagedClasses[i]);
          if mData.ManageDescendentClasses then
          begin
            if (pass = 1) then
              ok := cls.InheritsFrom(mData.ComponentClassType)
            else
              ok := false;
          end
          else
          begin
            if (pass = 0) then
              ok := (mData.ComponentClassType = cls)
            else
              ok := false;
          end;
          if ok then
          begin
            Helper.ManagedClassData := mData;
            found := TRUE;
            break;
          end;
        end;
        if found then
          break;
      end;
    end;
  end;

  procedure CheckComplexClasses;
  var
    cls: TClass;
    i: integer;
    mgr: TVA508ComplexComponentManager;
  begin
    if assigned(ComplexClasses) then
    begin
      cls := Component.ClassType;
      for i := 0 to ComplexClasses.Count - 1 do
      begin
        mgr := TVA508ComplexComponentManager(ComplexClasses[i]);
        if cls.InheritsFrom(mgr.ComponentClass) then
        begin
          Helper.ComplexManager := mgr;
          mgr.Refresh(Component, Manager);
          break;
        end;
      end;
    end;
  end;

  procedure CreateHelper;  //TVA508ComplexComponentManager(ComplexClasses[i]);
  var
    idx: integer;
  begin
    Helper := TComponentHelper.Create;
    Helper.Component := Component;
    Helper.Manager := Manager;
    Helper.ManagedClassData := nil;
    CheckComplexClasses;
    CheckManagedClasses;
    idx := FPendingFieldObjects.IndexOf(compKey);
    if idx >= 0 then
    begin
      Helper.FieldObject := TVA508ComponentAccessibility(FPendingFieldObjects.Objects[idx]);
      FPendingFieldObjects.Delete(idx);
    end;
  end;

  procedure RegisterComponent;
  begin
    compKey := GetCompKey(component);
    if FComponentRegistry.IndexOf(compkey) < 0 then
    begin
      CreateHelper;
      FComponentRegistry.AddObject(compKey, Helper);
      if HasHandle(Component, HandleKey) then
      begin
        Helper.HandleKey := HandleKey;
        FHandlesXREF.AddObject(HandleKey, Helper);
        RegisterMSAA(Component);
      end
      else
      begin
        FHandlesPending.AddObject(compKey, Helper);
        if not FPendingRecheckTimer.Enabled then
          FPendingRecheckTimer.Enabled := TRUE;
      end;
    end;
  end;

begin
  if FDestroying or (not assigned(Component)) then exit;
  RegisterComponent;
end;

procedure TVAGlobalComponentRegistry.TimerEvent(Sender: TObject);
var
  idx: integer;
  Helper: TComponentHelper;
  handleKey: string;

  function SkipCheck: boolean;
  begin
    Result := FDestroying or FUnregisteringComponent;
  end;

begin
  if SkipCheck or FCheckingPendingList then exit;
  FCheckingPendingList := TRUE;
  try
    idx := FHandlesPending.Count-1;
    while (idx >= 0) and (not SkipCheck) do
    begin
      Helper := TComponentHelper(FHandlesPending.Objects[idx]);
      if HasHandle(Helper.Component, handleKey) then
      begin
        Helper.HandleKey := handleKey;
        FHandlesXREF.AddObject(handleKey, Helper);
        FHandlesPending.Delete(idx);
        RegisterMSAA(Helper.Component);
      end;
      dec(idx);
    end;
    if FHandlesPending.Count = 0 then
      FPendingRecheckTimer.Enabled := FALSE;
  finally
    FCheckingPendingList := FALSE;
  end;
end;

procedure TVAGlobalComponentRegistry.UnregisterComponent(
  component: TWinControl);
var
  idx: integer;
  compKey, handleKey: string;
  Helper: TComponentHelper;
begin
  if FDestroying or (not assigned(component)) then exit;
  FUnregisteringComponent := TRUE;
  try
    compKey := GetCompKey(Component);
    idx := FComponentRegistry.IndexOf(compkey);
    if idx >= 0 then
    begin
      Helper := TComponentHelper(FComponentRegistry.Objects[idx]);
      handleKey := Helper.HandleKey;
      FComponentRegistry.Delete(idx);
      idx := FHandlesXREF.IndexOf(handleKey);
      if idx >= 0 then
        FHandlesXREF.Delete(idx);
      idx := FHandlesPending.IndexOf(compKey);
      if idx >= 0 then
        FHandlesPending.Delete(idx);
      Helper.Free;
      if assigned(Component) then
        UnregisterMSAA(Component);
    end;
  finally
    FUnregisteringComponent := FALSE;
  end;
end;


procedure TVAGlobalComponentRegistry.UnregisterMSAA(Component: TWinControl);
var
  Data: TMSAAData;
begin
  if Component.InheritsFrom(TWinControl) then
  begin
    Data := FindMSAAQueryData(TWinControlClass(Component.ClassType));
    if assigned(Data) then
    begin
      if assigned(Data.Proc) then
        UnregisterMSAAComponentQueryProc(Component, Data.Proc)
      else
        UnregisterMSAAComponentListQueryProc(Component, Data.ListProc);
    end;
  end;
end;

procedure TVAGlobalComponentRegistry.UpdateHandles(WindowHandle: HWnd; var HandlesModified: boolean);
var
  Handle: Hwnd;
  TimerRunning: boolean;
  HandleIndex: integer;

  procedure UpdateHandle(index: integer);
  var
    Helper: TComponentHelper;
    StatedHandle, TrueHandle: HWnd;
    key : string;
    idx: integer;

  begin
    StatedHandle := FastHexToInt(FHandlesXREF[index]);
    Helper := TComponentHelper(FHandlesXREF.Objects[index]);
    if assigned(Helper) and assigned(Helper.Component) then
    begin
      TrueHandle := GetComponentHandle(Helper.Component);
      if TrueHandle <> 0 then
      begin
        if StatedHandle <> TrueHandle then
        begin
          key := FastIntToHex(TrueHandle);
          Helper.HandleKey := key;
          HandlesModified := TRUE;
          if FHandlesXREF.Sorted then
          begin
            FHandlesXREF.Delete(index);
            FHandlesXREF.AddObject(key, Helper);
          end
          else
            FHandlesXREF[index] := key;
        end;
      end
      else
      begin
        Helper.HandleKey := '';
        FHandlesPending.AddObject(GetCompKey(Helper.component), Helper);
        FHandlesXREF.Delete(index);
        TimerRunning := TRUE;
      end;
    end
    else
    begin
      FHandlesXREF.Delete(index);
      if assigned(Helper) then
      begin
        key := GetCompKey(Helper.component);
        idx := FComponentRegistry.IndexOf(key);
        if idx >= 0 then
          FComponentRegistry.delete(idx);
        Helper.Free;
      end;
    end;
  end;

  function FindRootHandle(WindowHandle: HWnd; var idx: integer): Hwnd;
  var
    done: boolean;
    key: string;

  begin
    Result := WindowHandle;
    done := FALSE;
    repeat
      key := FastIntToHex(Result);
      idx := FHandlesXREF.IndexOf(key);
      if idx < 0 then
      begin
        Result := Windows.GetAncestor(Result, GA_PARENT);
        if Result = 0 then
          done := TRUE;
      end
      else
        done := TRUE;
    until done;
  end;

  procedure UpdateAllHandles;
  var
    i: integer;
  begin
    FHandlesXREF.Sorted := FALSE;
    try
      for I := FHandlesXREF.Count - 1 downto 0 do
      begin
        UpdateHandle(i);
      end;
    finally
      FHandlesXREF.Sorted := TRUE;
    end;
  end;

  procedure UpdateChildrenHandles(idx: integer);
  var
    i, objIdx, hexidx: integer;
    Helper, child: TComponentHelper;
    objKey, key: string;
    ctrl: TControl;
  begin
    Helper := TComponentHelper(FHandlesXREF.Objects[idx]);
    if assigned(Helper) then
    begin
      if assigned(Helper.ComplexManager) then
        Helper.ComplexManager.Refresh(Helper.Component, Helper.Manager);
      for i := 0 to Helper.component.ControlCount-1 do
      begin
        ctrl := Helper.component.Controls[i];
        if assigned(ctrl) and (ctrl is TWinControl) then
        begin
          objKey := GetCompKey(TWinControl(ctrl));
          objIdx := FComponentRegistry.IndexOf(objKey);
          if objidx >= 0 then
          begin
            child := TComponentHelper(FComponentRegistry.Objects[objidx]);
            if assigned(child) then
            begin
              key := child.HandleKey;
              hexidx := FHandlesXREF.IndexOf(key);
              if hexidx >= 0 then
              begin
                UpdateHandle(hexidx);
                if key <> child.HandleKey then
                begin
                  hexidx := FHandlesXREF.IndexOf(child.HandleKey);
                  if hexidx >= 0 then
                  begin
                    UpdateChildrenHandles(hexidx);
                  end;
                end;
              end;
            end;
          end
        end;
      end;
    end;
  end;

begin
  TimerRunning := FPendingRecheckTimer.Enabled;
  FPendingRecheckTimer.Enabled := FALSE;
  HandlesModified := FALSE;
  try
    Handle := FindRootHandle(WindowHandle, HandleIndex);
    if Handle = 0 then
      UpdateAllHandles
    else
      UpdateChildrenHandles(HandleIndex);
  finally
    FPendingRecheckTimer.Enabled := TimerRunning;
  end;
end;

{ TVA508ComponentManager }

constructor TVA508ComponentManager.Create(ManagedTypes: TManagedTypes);
begin
  FManagedTypes := ManagedTypes;
end;

function TVA508ComponentManager.GetCaption(Component: TWinControl): string;
begin
  Result := '';
end;

function TVA508ComponentManager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := '';
end;

function TVA508ComponentManager.GetData(Component: TWinControl; Value: string): string;
begin
  Result := '';
end;

function TVA508ComponentManager.GetInstructions(Component: TWinControl): string;
begin
  Result := '';
end;

function TVA508ComponentManager.GetItem(Component: TWinControl): TObject;
begin
  Result := nil;
end;

function TVA508ComponentManager.GetItemInstructions(
  Component: TWinControl): string;
begin
  Result := '';
end;

function TVA508ComponentManager.GetState(Component: TWinControl): string;
begin
  Result := '';
end;

function TVA508ComponentManager.GetValue(Component: TWinControl): string;
begin
  Result := '';
end;

function TVA508ComponentManager.ManageCaption(Component: TWinControl): boolean;
begin
  Result := mtCaption in FManagedTypes;
end;

function TVA508ComponentManager.ManageComponentName(
  Component: TWinControl): boolean;
begin
  Result := mtComponentName in FManagedTypes;
end;

function TVA508ComponentManager.ManageData(Component: TWinControl): boolean;
begin
  Result := mtData in FManagedTypes;
end;

function TVA508ComponentManager.ManageInstructions(
  Component: TWinControl): boolean;
begin
  Result := mtInstructions in FManagedTypes;
end;

function TVA508ComponentManager.ManageItemInstructions(
  Component: TWinControl): boolean;
begin
  Result := mtItemInstructions in FManagedTypes;
end;

function TVA508ComponentManager.ManageState(Component: TWinControl): boolean;
begin
  Result := mtState in FManagedTypes;
end;

function TVA508ComponentManager.ManageValue(Component: TWinControl): boolean;
begin
  Result := mtValue in FManagedTypes;
end;

function TVA508ComponentManager.MonitorForItemChange(
  Component: TWinControl): boolean;
begin
  Result := mtItemChange in FManagedTypes;
end;

function TVA508ComponentManager.MonitorForStateChange(
  Component: TWinControl): boolean;
begin
  Result := mtStateChange in FManagedTypes;
end;

function TVA508ComponentManager.Redirect(Component: TWinControl;
  var ManagedType: TManagedType): TWinControl;
begin
  Result := nil;
  ManagedType := mtNone;
end;

function TVA508ComponentManager.RedirectsComponent(Component: TWinControl): boolean;
begin
  Result := mtComponentRedirect in FManagedTypes;
end;

{ TVA508ManagedComponentClass }

constructor TVA508ManagedComponentClass.Create(AClassType: TWinControlClass;
                     ManageTypes: TManagedTypes; AManageDescendentClasses: boolean = FALSE);
begin
  FClassType := AClassType;
  FManageDescendentClasses := AManageDescendentClasses;
  inherited Create(ManageTypes);
end;

{ TVA508SilentComponent }

function TVA508SilentComponent.GetComponentName(Component: TWinControl): string;
begin
  Result := ComponentManagerSilentText;
end;

function TVA508SilentComponent.GetInstructions(Component: TWinControl): string;
begin
  Result := ComponentManagerSilentText;
end;

function TVA508SilentComponent.GetState(Component: TWinControl): string;
begin
  Result := ComponentManagerSilentText;
end;

function TVA508SilentComponent.GetValue(Component: TWinControl): string;
begin
  Result := ComponentManagerSilentText;
end;

{ TVA508AccessibilityEvents }

constructor TVA508ComponentAccessibility.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  VA508ComponentCreationCheck(Self, AOwner, FALSE, TRUE);
  CreateGlobalRegistry;
end;

procedure TVA508ComponentAccessibility.SetComponent(const Value: TWinControl);
var
  i: integer;
  Comp: TComponent;
begin
  if FComponent <> Value then
  begin
    if assigned(Value) then
    begin
      for i := 0 to Owner.ComponentCount-1 do
      begin
        Comp := Owner.Components[i];
        if (Comp is TVA508ComponentAccessibility) and (Comp <> Self) then
        begin
          if TVA508ComponentAccessibility(Comp).Component = Value then
            raise TVA508Exception.Create(Value.Name + ' is already assigned to another ' +
                    TVA508ComponentAccessibility.ClassName + ' component');
        end;
      end;
      if assigned(GlobalRegistry) then
      begin
        if assigned(FComponent) then
          GlobalRegistry.RegisterFieldObject(FComponent, Self, FALSE);
        GlobalRegistry.RegisterFieldObject(Value, Self, TRUE);
      end;
      FComponent := Value;
    end
    else
    begin
      if assigned(FComponent) and assigned(GlobalRegistry) then
        GlobalRegistry.RegisterFieldObject(FComponent, Self, FALSE);
      FComponent := nil;
    end;
  end;
end;

{ TComponentHelper }

procedure TComponentHelper.InitializeComponentManager;

var
  ClsManager: TVA508ManagedComponentClass;
  CompManager: TVA508ComponentManager;
  data: string;

  procedure InitializeComponentHelper;
  begin
    if assigned(FComponentManager) and FComponentManager.RedirectsComponent(FComponent) then
    begin
      FRedirectedComponent := FComponentManager.Redirect(FComponent, FRedirectedHelperType);
      if FRedirectedComponent.Visible then
      begin
        FRedirectedHelper := GlobalRegistry.GetComponentHelper(FRedirectedComponent.Handle);
        if assigned(FRedirectedHelper) then
          FRedirectedHelper.InitializeComponentManager
        else
          ClearRedirect;

        data := FRedirectedComponent.ClassName + ' / ';
        if assigned(FRedirectedHelper.ComponentManager) then
          data := data + FRedirectedHelper.ComponentManager.ClassName
        else data := data +' no manager';
      end
      else
        ClearRedirect;
    end
    else
      ClearRedirect;
  end;

begin
  ClsManager := ManagedClassData;
  CompManager := Manager.ComponentManager[Component];
  if assigned(ClsManager) or assigned(CompManager) then
  begin
    if assigned(CompManager) then
      FComponentManager := CompManager
    else
      FComponentManager := ClsManager;
  end
  else
    FComponentManager := nil;
  InitializeComponentHelper;
end;

procedure TComponentHelper.ClearRedirect;
begin
  FRedirectedHelper := nil;
  FRedirectedHelperType := mtNone;
  FRedirectedComponent := nil;
end;

constructor TComponentHelper.Create;
begin
  ClearRedirect;
end;

destructor TComponentHelper.Destroy;
begin
  if Assigned(GlobalRegistry) and (GlobalRegistry.FCurrentHelper = Self) then
    GlobalRegistry.FCurrentHelper := nil;
  if Assigned(GlobalRegistry) and assigned(GlobalRegistry.FCurrentHelper) and
    (GlobalRegistry.FCurrentHelper.FRedirectedHelper = Self) then
    GlobalRegistry.FCurrentHelper := nil;
  inherited;
end;

function TComponentHelper.GetCaption(var DataResult: Integer): string;
begin
  if Redirect(mtCaption) then
    Result := FRedirectedHelper.GetCaption(DataResult)
  else
  begin
    Result := Manager.ScreenReaderInquiry(FComponent);
    if Result = '' then
    begin
      if assigned(FFieldObject) and (FFieldObject.FCaption <> '') then
        Result := FFieldObject.FCaption
      else
      if assigned(FComponentManager) and FComponentManager.ManageCaption(FComponent) then
        Result := FComponentManager.GetCaption(FComponent)
    end;
    if assigned(FieldObject) and assigned(FieldObject.OnCaptionQuery) then
      FieldObject.OnCaptionQuery(FieldObject, Result);
    if Result <> '' then
      DataResult := DataResult OR DATA_CAPTION;
  end;
end;

function TComponentHelper.GetComponentName(var DataResult: Integer): string;
begin
  if Redirect(mtComponentName) then
    Result := FRedirectedHelper.GetComponentName(DataResult)
  else
  begin
    Result := '';
    if assigned(FFieldObject) and (FFieldObject.FComponentName <> '') then
      Result := FFieldObject.FComponentName
    else if assigned(FComponentManager) and FComponentManager.ManageComponentName(FComponent) then
      Result := FComponentManager.GetComponentName(FComponent);
    if assigned(FFieldObject) and assigned(FFieldObject.FOnComponentNameQuery) then
      FFieldObject.FOnComponentNameQuery(FFieldObject, Result);
    if Result <> '' then
      DataResult := DataResult OR DATA_CONTROL_TYPE;
  end;
end;

function TComponentHelper.GetData(var DataResult: Integer; Value: string): string;
begin
  if Redirect(mtData) then
    Result := FRedirectedHelper.GetData(DataResult, Value)
  else
  begin
    Result := '';
    if assigned(FComponentManager) and FComponentManager.ManageData(FComponent) then
    begin
      Result := FComponentManager.GetData(FComponent, Value);
      if Result <> '' then
        DataResult := DataResult OR DATA_DATA;
    end;
  end;
end;

function TComponentHelper.GetInstructions(var DataResult: Integer): string;
begin
  if Redirect(mtInstructions) then
    Result := FRedirectedHelper.GetInstructions(DataResult)
  else
  begin
    Result := '';
    if assigned(FFieldObject) and (FFieldObject.FInstructions <> '') then
      Result := FFieldObject.FInstructions
    else if assigned(FComponentManager) and FComponentManager.ManageInstructions(FComponent) then
      Result := FComponentManager.GetInstructions(FComponent);
    if assigned(FFieldObject) and assigned(FFieldObject.FOnInstructionsQuery) then
      FFieldObject.FOnInstructionsQuery(FFieldObject, Result);
    if Result <> '' then
      DataResult := DataResult OR DATA_INSTRUCTIONS;
  end;
end;

function TComponentHelper.GetItem: TObject;
begin
  if Redirect(mtItemChange) then
    FRedirectedHelper.GetItem
  else
  begin
    Result := nil;
    if assigned(FComponentManager) and FComponentManager.MonitorForItemChange(FComponent) then
      Result := FComponentManager.GetItem(FComponent);
    if assigned(FFieldObject) and assigned(FFieldObject.FOnItemQuery) then
      FFieldObject.FOnItemQuery(FFieldObject, Result);
  end;
end;

function TComponentHelper.GetItemInstructions(var DataResult: Integer): string;
begin
  if Redirect(mtItemInstructions) then
    Result := FRedirectedHelper.GetItemInstructions(DataResult)
  else
  begin
    Result := '';
    if assigned(FFieldObject) and (FFieldObject.FItemInstructions <> '') then
      Result := FFieldObject.FItemInstructions
    else if assigned(FComponentManager) and FComponentManager.ManageItemInstructions(FComponent) then
      Result := FComponentManager.GetItemInstructions(FComponent);
    if assigned(FFieldObject) and assigned(FFieldObject.FOnItemInstructionsQuery) then
      FFieldObject.FOnItemInstructionsQuery(FFieldObject, Result);
    if Result <> '' then
      DataResult := DataResult OR DATA_ITEM_INSTRUCTIONS;
  end;
end;

function TComponentHelper.GetState(var DataResult: Integer): string;
begin
  Result := '';
  try
    if Redirect(mtState) then
      Result := FRedirectedHelper.GetState(DataResult)
    else
    begin
      if assigned(FComponentManager) and FComponentManager.MonitorForStateChange(FComponent) and
                                              FComponentManager.ManageState(FComponent) then
        Result := FComponentManager.GetState(FComponent);
      if assigned(FFieldObject) and assigned(FFieldObject.FOnStateQuery) then
        FFieldObject.FOnStateQuery(FFieldObject, Result);
      if Result <> '' then
        DataResult := DataResult OR DATA_STATE;
    end;
  except
  // access violations occur here during reminder dialogs - could never figure out why
  // Self = nil when looking at FFieldObject, but checks before that line showed Self <> nil
  end;
end;

function TComponentHelper.GetValue(var DataResult: Integer): string;
begin
  if Redirect(mtValue) then
  begin
    Result := FRedirectedHelper.GetValue(DataResult);
  end
  else
  begin
    Result := '';
    if assigned(FComponentManager) and FComponentManager.ManageValue(FComponent) then
      Result := FComponentManager.GetValue(FComponent);
    if assigned(FFieldObject) and assigned(FFieldObject.FOnValueQuery) then
      FFieldObject.FOnValueQuery(FFieldObject, Result);
    if Result <> '' then
      DataResult := DataResult OR DATA_VALUE;
  end;
end;

function TComponentHelper.ManageComponentName: boolean;
begin
  if Redirect(mtComponentName) then
    Result := FRedirectedHelper.ManageComponentName
  else
  begin
    if assigned(FFieldObject) and
      (assigned(FFieldObject.FOnComponentNameQuery) or (FFieldObject.FComponentName <> '')) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.ManageComponentName(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.ManageData: boolean;
begin
  if Redirect(mtData) then
    Result := FRedirectedHelper.ManageData
  else
  begin
    if assigned(FComponentManager) then
      Result := FComponentManager.ManageData(FComponent)
    else
      Result := FALSE;
  end;
end;

function TComponentHelper.ManageInstructions: boolean;
begin
  if Redirect(mtInstructions) then
    Result := FRedirectedHelper.ManageInstructions
  else
  begin
    if assigned(FFieldObject) and
      (assigned(FFieldObject.FOnInstructionsQuery) or (FFieldObject.FInstructions <> '')) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.ManageInstructions(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.ManageItemInstructions: boolean;
begin
  if Redirect(mtItemInstructions) then
    Result := FRedirectedHelper.ManageItemInstructions
  else
  begin
    if assigned(FFieldObject) and
      (assigned(FFieldObject.FOnItemInstructionsQuery) or (FFieldObject.FItemInstructions <> '')) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.ManageItemInstructions(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.ManageValue: boolean;
begin
  if Redirect(mtValue) then
  begin
    Result := FRedirectedHelper.ManageValue;
  end
  else
  begin
    if assigned(FFieldObject) and assigned(FFieldObject.FOnValueQuery) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.ManageValue(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.ManageCaption: boolean;
begin
  if Redirect(mtCaption) then
    Result := FRedirectedHelper.ManageCaption
  else
  begin
    if assigned(FFieldObject) and
      (assigned(FFieldObject.OnCaptionQuery) or (FFieldObject.FCaption <> '')) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.ManageCaption(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.MonitorForItemChange: boolean;
begin
  if Redirect(mtItemChange) then
    Result := FRedirectedHelper.MonitorForItemChange
  else
  begin
    if assigned(FFieldObject) and assigned(FFieldObject.FOnItemQuery) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.MonitorForItemChange(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.MonitorForStateChange: boolean;
begin
  if Redirect(mtStateChange) then
    Result := FRedirectedHelper.MonitorForStateChange
  else
  begin
    if assigned(FFieldObject) and assigned(FFieldObject.OnStateQuery) then
      Result := TRUE
    else
    begin
      if assigned(FComponentManager) then
        Result := FComponentManager.MonitorForStateChange(FComponent) and
                  FComponentManager.ManageState(FComponent)
      else
        Result := FALSE;
    end;
  end;
end;

function TComponentHelper.Redirect(RedirectType: TManagedType): boolean;
begin
  Result := FALSE;
  if assigned(FRedirectedHelper) and assigned(FRedirectedComponent) and
     (FRedirectedHelperType = RedirectType) then
    Result := TRUE;
end;

function TComponentHelper.StandardComponent: boolean;
begin
  Result := ((not assigned(FComponentManager)) and (not assigned(FFieldObject)));
end;

{ TVA508StaticText }
type
  TFriendLabel = class(TLabel);

procedure TVA508StaticText.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateSize;
end;

procedure TVA508StaticText.CMTextChanged(var Message: TMessage);
begin
  inherited;
  UpdateSize;
end;

constructor TVA508StaticText.Create;
begin
  inherited;
  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Align := alClient;
  FWordWrap := False;
  ControlStyle := ControlStyle - [csAcceptsControls];
  FInitTabStop := (not TabStop);
end;

procedure TVA508StaticText.DeleteChain(FromLabel, ToLabel: TVA508ChainedLabel);
var
  next, lbl: TVA508ChainedLabel;
  prev: TControl;
begin
  if FDeletingChain then exit;
  if FromLabel = ToLabel then exit;
  FDeletingChain := TRUE;
  try
    next := NextLabel;
    while assigned(next) and (next <> FromLabel) do
      next := next.NextLabel;
    if assigned(next) then
    begin
      prev := next.FPreviousLabel;
      repeat
        lbl := next;
        next := next.NextLabel;
        lbl.Free;
      until (not assigned(next)) or (next = ToLabel);
      if assigned(ToLabel) then
        ToLabel.FPreviousLabel := prev;
    end;
  finally
    FDeletingChain := FALSE;
  end;
end;

destructor TVA508StaticText.Destroy;
begin
  if assigned(FNextLabel) then
    DeleteChain(FNextLabel, nil);
  inherited;
end;

procedure TVA508StaticText.DoEnter;
begin
  inherited DoEnter;
  InvalidateAll;
  if Assigned(FOnEnter) then
     FOnEnter(Self);
end;

procedure TVA508StaticText.DoExit;
begin
  inherited DoExit;
  InvalidateAll;
  if Assigned(FOnExit) then
     FOnExit(Self);
end;

procedure TVA508StaticText.Resize;
begin
  inherited Resize;
  InvalidateAll;
  if AutoSize then
    TFriendLabel(FLabel).AdjustBounds;
end;

function TVA508StaticText.GetAlignment: TAlignment;
begin
  Result := FLabel.Alignment;
end;

function TVA508StaticText.GetLabelAlignment: TAlignment;
begin
 Result := FLabel.Alignment;
end;

function TVA508StaticText.GetLabelCaption: string;
begin
  Result := FLabel.Caption;
end;

function TVA508StaticText.GetLabelLayout: TTextLayout;
begin
  Result := FLabel.Layout;
end;

function TVA508StaticText.GetRootName: string;
begin
  result := inherited Name;
end;

function TVA508StaticText.GetShowAccelChar: boolean;
begin
  Result := FLabel.ShowAccelChar;
end;

function TVA508StaticText.GetWordWrap: Boolean;
begin
 Result := FWordWrap;
end;

procedure TVA508StaticText.InvalidateAll;
var
  next: TVA508ChainedLabel;
begin
  invalidate;
  next := FNextLabel;
  while assigned(next) do
  begin
    next.Invalidate;
    next := next.NextLabel;
  end;
end;

procedure TVA508StaticText.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then exit;
  if (Operation = opRemove) and (AComponent = FNextLabel) and (not FDeletingChain) then
    SetNextLabel(nil);
end;

procedure TVA508StaticText.Paint;
var
  x1, x2, y1, y2: integer;

  procedure Init;
  begin
    Canvas.Font := Self.Font;
    with Canvas do
    begin
      Pen.Width := 1;
      Brush.Color := clNone;
      Brush.Style := bsClear;
    end;
  end;

//  procedure DrawText;
//  begin
//    with Canvas do
//    begin
//      Pen.color := Self.Font.Color;
//      Pen.Style := psSolid;
//      TextOut(1, 0, Caption);
//    end;
//  end;

  procedure InitDrawBorder;
  var
    r: TRect;
  begin
    with Canvas do
    begin
      if Focused then
      begin
        Pen.Style := psDot;
        Pen.Color := Self.Font.Color;
      end
      else
      begin
        Pen.Style := psSolid;
        pen.Color := Self.Color;
      end;
    end;
    R := ClientRect;
    R.Bottom := R.Bottom - 1;
    R.Right := R.Right - 1;
    x1 := R.Left;
    y1 := R.Top;
    x2 := R.Right;
    y2 := R.Bottom;
  end;

  procedure DrawTop;
  begin
    With Canvas do
    begin
      MoveTo(x1, y2);
      LineTo(x1, y1);
      LineTo(x2, y1);
      LineTo(x2, y2);
    end;
  end;

  procedure DrawBottom;
  var
    bx1,bx2, max: integer;
    r: TRect;
    r2: TRect;
  begin
    with Canvas do
    begin
      if assigned(FNextLabel) then
      begin
        r := BoundsRect;
        r2 := FNextLabel.BoundsRect;
        if r.top < r2.top then
        begin
          bx1 := r2.Left - r.Left;
          if (bx1 > 0) then
          begin
            if bx1 > x2 then
              max := x2
            else
              max := bx1;
            moveto(x1,y2);
            lineto(max,y2);
          end;
          bx2 := x2 - (r.Right - r2.Right);
          if bx2 < x2 then
          begin
            if bx2 < x1 then
              max := x1
            else
              max := bx2;
            moveto(x2,y2);
            lineto(max,y2);
          end;
        end;
      end
      else
        LineTo(x1, y2);
    end;
  end;

begin
  Init;
//  if Focused then
//    DrawText;
  InitDrawBorder;
  DrawTop;
  DrawBottom;
//  if not Focused then
//    DrawText;
end;

procedure TVA508StaticText.SetAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := Value;
end;

procedure TVA508StaticText.SetLabelAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := Value
end;

procedure TVA508StaticText.SetLabelCaption(const Value: string);
begin
  if FLabel.Caption <> Value then
  begin
    FLabel.Caption := Value;
    UpdateSize;
  end;
end;

procedure TVA508StaticText.SetLabelLayout(const Value: TTextLayout);
begin
  FLabel.Layout := Value;
end;

procedure TVA508StaticText.SetRootName(const Value: string);
var
  OldName: String;
begin
  OldName := Name;
  inherited;
  if OldName <> Value then
  begin
    if FLabel.Caption = OldName then
      FLabel.Caption := Value;
  end;
end;

procedure TVA508StaticText.SetNextLabel(const Value: TVA508ChainedLabel);
begin
  if FNextLabel <> Value then
  begin
    if assigned(FNextLabel) then
      DeleteChain(FNextLabel, Value);
    FNextLabel := Value;
    if assigned(FNextLabel) then
    begin
      FNextLabel.FStaticLabelParent := Self;
      FNextLabel.FPreviousLabel := Self;
    end;
    invalidate;
  end;
end;

procedure TVA508StaticText.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if assigned(AParent) then
  begin
    if FInitTabStop then
    begin
      if csDesigning in ComponentState then
        TabStop := FALSE
      else
        TabStop := ScreenReaderActive;
      FInitTabStop := FALSE;
    end;
    Perform(CM_FONTCHANGED, 0, 0);
  end;
end;

procedure TVA508StaticText.SetShowAccelChar(const Value: boolean);
begin
  FLabel.ShowAccelChar := Value;
end;

procedure TVA508StaticText.SetWordWrap(const Value: Boolean);
begin
  FWordWrap := Value;

  if FWordWrap then
  begin
    FLabel.Align := alTop;
    FLabel.AutoSize := True;
    FLabel.WordWrap := True;
  end
  else
  begin
    FLabel.Align := alClient;
    Self.AutoSize := FALSE;
  end;
end;

procedure TVA508StaticText.UpdateSize;
var
  RtnAlignment: TAlign;
begin
  if not AutoSize then
  begin
    RtnAlignment := FLabel.Align;
    FLabel.Align := alNone;
    try
      TFriendLabel(FLabel).AdjustBounds;
      Height := FLabel.Height + 2;
      Width := FLabel.Width + 2;
    finally
      FLabel.Align := RtnAlignment;
    end;
  end;
end;

{ TVA508ChainedLabel }

procedure TVA508ChainedLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if not assigned(FStaticLabelParent) then exit;
  if csDestroying in ComponentState then exit;
  if (Operation = opRemove) and (AComponent = FNextLabel) and (not FStaticLabelParent.FDeletingChain) then
    SetNextLabel(nil);
end;

procedure TVA508ChainedLabel.Paint;
var
  x1, x2, y1, y2: integer;

  procedure Init;
  begin
    Canvas.Font := Self.Font;
    with Canvas do
    begin
      Pen.Width := 1;
      Brush.Color := clNone;
      Brush.Style := bsClear;
    end;
  end;

  procedure DrawText;
  begin
    with Canvas do
    begin
      Pen.color := Self.Font.Color;
      Pen.Style := psSolid;
      TextOut(0, 0, Caption);
    end;
  end;

  procedure InitDrawBorder;
  var
    r: TRect;
  begin
    with Canvas do
    begin
      if FStaticLabelParent.Focused then
      begin
        Pen.Style := psDot;
        Pen.Color := Self.Font.Color;
      end
      else
      begin
        if transparent then
        begin
          Pen.Style := psClear;
          Pen.Color := clNone;
        end
        else
        begin
          Pen.Style := psSolid;
          pen.Color := Self.Color;
        end;
      end;
    end;
    R := ClientRect;
    R.Bottom := R.Bottom - 1;
    R.Right := R.Right - 1;
    x1 := R.Left;
    y1 := R.Top;
    x2 := R.Right;
    y2 := R.Bottom;
  end;

  procedure DrawPartials(x3, x4, y: integer);
  var
    max: integer;
  begin
    with Canvas do
    begin
      if (x3 > x1) then
      begin
        if x3 > x2 then
          max := x2
        else
          max := x3;
        moveto(x1,y);
        lineto(max,y);
      end;
      if x4 < x2 then
      begin
        if x4 < x1 then
          max := x1
        else
          max := x4;
        moveto(x2,y);
        lineto(max,y);
      end;
    end;
  end;

  procedure DrawTop;
  var
    r, r2: TRect;
    tx1,tx2: integer;
  begin
    With Canvas do
    begin
      r2 := BoundsRect;
      r := FPreviousLabel.BoundsRect;
      if r.top < r2.top then
      begin
        tx1 := r.Left - r2.Left;
        tx2 := x2 - (r2.Right - r.Right);
        DrawPartials(tx1,tx2,y1);
      end
      else
      begin
        MoveTo(x1, y1);
        LineTo(x2, y1);
      end;
    end;
  end;

  procedure DrawSides;
  begin
    With Canvas do
    begin
      MoveTo(x1,y1);
      LineTo(x1,y2);
      MoveTo(x2,y1);
      LineTo(x2,y2);
    end;
  end;

  procedure DrawBottom;
  var
    r, r2: TRect;
    doBottom: boolean;
    bx1,bx2: integer;
  begin
    With Canvas do
    begin
      if assigned(FNextLabel) then
      begin
        r := BoundsRect;
        r2 := FNextLabel.BoundsRect;
        if r.top < r2.top then
        begin
          doBottom := FALSE;
          bx1 := r2.Left - r.Left;
          bx2 := x2 - (r.Right - r2.Right);
          DrawPartials(bx1,bx2,y2);
        end
        else
          doBottom := TRUE;
      end
      else
        doBottom := TRUE;
      if DoBottom then
      begin
        MoveTo(x1, y2);
        LineTo(x2, y2);
      end;
    end;
  end;

begin
  Init;
  if FStaticLabelParent.Focused then
    DrawText;
  InitDrawBorder;
  DrawTop;
  DrawSides;
  DrawBottom;
  if not FStaticLabelParent.Focused then
    DrawText;
end;

procedure TVA508ChainedLabel.SetNextLabel(const Value: TVA508ChainedLabel);
begin
  if not assigned(FStaticLabelParent) then exit;
  if FNextLabel <> Value then
  begin
    if assigned(FNextLabel) then
      FStaticLabelParent.DeleteChain(FNextLabel, Value);
    FNextLabel := Value;
    if assigned(FNextLabel) then
    begin
      FNextLabel.FStaticLabelParent := FStaticLabelParent;
      FNextLabel.FPreviousLabel := Self;
    end;
    invalidate;
  end;
end;

{ TVA508ComplexComponentManager }

type
  TComplexDataItem = class(TObject)
  private
    FList: TList;
    FComponent: TWinControl;
    FSubComponent: TWinControl;
  public
    constructor Create(Component, SubComponent: TWinControl);
    destructor Destroy; override;
  end;

{ TComplexDataItem }

constructor TComplexDataItem.Create(Component, SubComponent: TWinControl);
begin
  FComponent := Component;
  FSubComponent := SubComponent;
  if assigned(FSubComponent) then
    FList := nil
  else
    FList := TList.Create;
end;

destructor TComplexDataItem.Destroy;
begin
  if assigned(FList) then
    FList.Free;
  inherited;
end;


procedure TVA508ComplexComponentManager.AddSubControl(ParentComponent, SubControl: TWinControl;
                            AccessibilityManager: TVA508AccessibilityManager);
var
  list: TList;
  item : TComplexDataItem;
begin
  if (not assigned(ParentComponent)) or (not assigned(SubControl)) then exit;
  list := GetSubComponentList(ParentComponent);
  if list.IndexOf(SubControl) < 0 then
  begin
    list.Add(SubControl);
    if IndexOfSubComponentXRef(SubControl) < 0 then
    begin
      item := TComplexDataItem.Create(ParentComponent, SubControl);
      FSubComponentXRef.Add(item);
      SubControl.FreeNotification(FSubComponentNotifier);
    end;
    if assigned(AccessibilityManager) and assigned(GlobalRegistry) then
      GlobalRegistry.RegisterComponent(SubControl, AccessibilityManager);
  end;
end;

procedure TVA508ComplexComponentManager.RemoveSubControl(ParentComponent, SubControl: TWinControl);
var
  list: TList;
  idx: integer;
begin
  if (not assigned(ParentComponent)) or (not assigned(SubControl)) then exit;
  list := GetSubComponentList(ParentComponent);
  idx := list.IndexOf(SubControl);
  if idx >= 0 then
  begin
    List.Delete(idx);
    idx := IndexOfSubComponentXRef(SubControl);
    if idx >= 0 then
    begin
      FSubComponentXRef.Delete(idx);
      SubControl.RemoveFreeNotification(FSubComponentNotifier);
    end;
    if assigned(GlobalRegistry) then
      GlobalRegistry.UnregisterComponent(SubControl);
  end;
end;

procedure TVA508ComplexComponentManager.ClearSubControls(Component: TWinControl);
var
  list: TList;
  idx, i: integer;
  SubControl: TWinControl;

begin
  if (not assigned(Component)) then exit;
  list := GetSubComponentList(Component);
  for i := 0 to list.Count - 1 do
  begin
    SubControl := TWinControl(list[i]);
    idx := IndexOfSubComponentXRef(SubControl);
    if idx >= 0 then
    begin
      FSubComponentXRef.Delete(idx);
      SubControl.RemoveFreeNotification(FSubComponentNotifier);
    end;
    if assigned(GlobalRegistry) then
      GlobalRegistry.UnregisterComponent(SubControl);
  end;
  list.Clear;
end;

constructor TVA508ComplexComponentManager.Create(
  AComponentClass: TWinControlClass);
begin
  FComponentClass := AComponentClass;
  FComponentNotifier := TVANotificationEventComponent.NotifyCreate(nil, ComponentNotifyEvent);
  FSubComponentNotifier := TVANotificationEventComponent.NotifyCreate(nil, SubComponentNotifyEvent);
  FComponentList := TObjectList.Create;
  FSubComponentXRef := TObjectList.Create;
end;

destructor TVA508ComplexComponentManager.Destroy;
begin
  FSubComponentXRef.Free;
  FComponentList.Free;
  FComponentNotifier.Free;
  FSubComponentNotifier.Free;
  inherited;
end;

function TVA508ComplexComponentManager.GetSubComponentList(Component: TWinControl): TList;
var
  i: integer;
  item: TComplexDataItem;
begin
  i := IndexOfComponentItem(Component);
  if i < 0 then
  begin
    item := TComplexDataItem.Create(Component, nil);
    i := FComponentList.Add(item);
    Component.FreeNotification(FComponentNotifier);
  end;
  Result := TComplexDataItem(FComponentList[i]).FList;
end;

function TVA508ComplexComponentManager.GetSubControl(Component: TWinControl;
  Index: integer): TWinControl;
begin
  if assigned(Component) then
    Result := TWinControl(GetSubComponentList(Component)[Index])
  else
    Result := nil;
end;

function TVA508ComplexComponentManager.IndexOfComponentItem(
  Component: TWinControl): integer;
var
  i:integer;
  item: TComplexDataItem;
begin
  for i := 0 to FComponentList.Count -1 do
  begin
    item := TComplexDataItem(FComponentList[i]);
    if item.FComponent = Component then
    begin
      Result := i;
      exit;
    end;
  end;
  Result := -1;
end;

function TVA508ComplexComponentManager.IndexOfSubComponentXRef(
  Component: TWinControl): integer;
var
  i:integer;
  item: TComplexDataItem;
begin
  for i := 0 to FSubComponentXRef.Count -1 do
  begin
    item := TComplexDataItem(FSubComponentXRef[i]);
    if item.FSubComponent = Component then
    begin
      Result := i;
      exit;
    end;
  end;
  Result := -1;
end;

procedure TVA508ComplexComponentManager.ComponentNotifyEvent(AComponent: TComponent;
  Operation: TOperation);
var
  idx: integer;
begin
  if (Operation = opRemove) and assigned(AComponent) and (AComponent is TWinControl) then
  begin
    ClearSubControls(TWinControl(AComponent));
    idx := IndexOfComponentItem(TWinControl(AComponent));
    if idx >= 0 then
      FComponentList.Delete(idx);
  end;
end;

procedure TVA508ComplexComponentManager.SubComponentNotifyEvent(
  AComponent: TComponent; Operation: TOperation);
var
  idx: integer;
  Parent: TWinControl;
  item: TComplexDataItem;
begin
  if (Operation = opRemove) and assigned(AComponent) and (AComponent is TWinControl) then
  begin
    idx := IndexOfSubComponentXRef(TWinControl(AComponent));
    if idx >= 0 then
    begin
      item := TComplexDataItem(FSubComponentXRef[idx]);
      Parent := item.FComponent;
      RemoveSubControl(Parent, TWinControl(AComponent));
    end;
  end;
end;

function TVA508ComplexComponentManager.SubControlCount(Component: TWinControl): integer;
begin
  if assigned(Component) then
    Result := GetSubComponentList(Component).Count
  else
    Result := 0;
end;

//// TColumnList

function TColumnList.GetCount:Integer;
begin
 Result:=FList.Count;
end;

function TColumnList.GetName(Index:Integer):String;
begin
 result := fList.Names[Index];
end;

function TColumnList.GetValue(Index:Integer):Boolean;
begin
 result := StrToBoolDef(fList.ValueFromIndex[Index], True);
end;

procedure TColumnList.SetValue(Index:Integer;Value:boolean);
begin
 fList.ValueFromIndex[Index] := BoolToStr(Value);
end;

function TColumnList.GetItem(Index:Integer):String;
begin
 Result := FList[Index];
end;

procedure TColumnList.SetItem(Index:Integer; Value:String);
begin
 FList[Index] := Value;
end;

function TColumnList.GetColumn(Column:Integer):Boolean;
begin
 Result:= StrToBoolDef(FList.Values[IntToStr(Column)], true);
end;

function TColumnList.GetColumnExist(Column:Integer):Boolean;
begin
 Result := FList.Values[IntToStr(Column)] <> '';
end;

procedure TColumnList.SetColumn(Column:Integer; Value:Boolean);
begin
 FList.Values[IntToStr(Column)] := BoolToStr(Value)
end;

constructor TColumnList.Create;
begin
 inherited Create;
 FList:=TStringList.Create;
end;

destructor TColumnList.Destroy;
begin
 Clear;
 FList.Free;
 inherited Destroy;
end;

function TColumnList.Add(Column: Integer; ReadValue:Boolean):Integer;
begin
 Insert(Column,ReadValue);
 Result:=IndexOf(Column);
end;

 procedure TColumnList.Assign(Source:TPersistent);
begin
 if Source is TColumnList then
  begin
   Clear;
   AddColumns(TColumnList(Source));
  end
 else
  inherited Assign(Source);
end;

 procedure TColumnList.AssignTo(Dest:TPersistent);
var i:integer;
    FStr:TStringList;
begin
 if Dest is TStringList
 then
 begin
   FStr:=TStringList(Dest);
   FStr.Clear;
   for i:=0 to Count-1 do
    FStr.Add(Items[i]);
 end
 else inherited AssignTo(Dest);
end;

procedure TColumnList.Clear;
begin
 FList.Clear;
end;

procedure TColumnList.Delete(Column:Integer);
begin
 FList.Delete(FList.IndexOfName(IntToStr(Column)));
end;

procedure TColumnList.Insert(Column:Integer; ReadValue:Boolean);
begin
 FList.Values[IntToStr(Column)] := BoolToStr(ReadValue);
end;

function TColumnList.IndexOf(Column:Integer):Integer;
begin
 Result:= FList.IndexOfName(IntToStr(Column));
end;

procedure TColumnList.AddColumns(List:TColumnList);
var I:Integer;
begin
 for I:=0 to Pred(List.Count) do
  Add(StrToIntDef(List.Names[I], -1), List.Values[i]);
end;

procedure TDFMColumnData.Add(aColumn: Integer; aValue: Boolean);
begin
 fColumn := aColumn;
 fValue := aValue;
end;

destructor TDFMData.Destroy;
begin
 SetLength(Columns, 0);
 inherited;
end;


procedure RegisterDynamicSubControl(aControl, aSubControl: TWinControl);
var
  aFrm: TCustomForm;
  fMgr: TVA508AccessibilityManager;
  i: integer;
begin
  fMgr := nil;
  aFrm := GetParentForm(aControl);
  if not assigned(aFrm) then
   exit;
  for i := 0 to aFrm.ComponentCount - 1 do
  begin
    if aFrm.Components[i] is TVA508AccessibilityManager then
    begin
      fMgr := TVA508AccessibilityManager(aFrm.Components[i]);
      break;
    end;
  end;
  if assigned(fMgr) then
    fMgr.AccessData.EnsureItemExists(aSubControl);
end;

initialization

finalization
  FreeGlobalVars;

end.

