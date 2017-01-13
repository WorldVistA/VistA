unit VA508Classes;

interface
  uses SysUtils, Classes, Contnrs, StrUtils, Windows, HRParser, HRParserPas, Forms, Dialogs;

type
  TFormData = class
  private
    FFileName: string;
    FlcFormClassName: string;
    FInheritedForm: boolean;
    FParent: TFormData;
    FManagerComponentName: string;
    FInheritedManager: boolean;
    FFormClassName: string;
    FEmptyManager: boolean; 
    procedure SetFormClassName(const Value: string);
  public
    function HasManager: boolean;
    function HasParent: boolean;
    property FormClassName: string read FFormClassName write SetFormClassName;
    property lcFormClassName: string read FlcFormClassName;
    property EmptyManager: boolean read FEmptyManager write FEmptyManager; 
    property FileName: string read FFileName write FFileName;
    property Parent: TFormData read FParent write FParent;
    property InheritedForm: boolean read FInheritedForm write FInheritedForm;
    property InheritedManager: boolean read FInheritedManager write FInheritedManager;
    property ManagerComponentName: string read FManagerComponentName write FManagerComponentName;
  end;

  EVA508AccessibilityException = class(Exception);

  TParentChildErrorCode = (pcNoParentManager, pcValidRelationship,
                           pcNoInheritence, pcNoChildComponent, pcEmptyManagerComponent,
                           pcOtherChildComponent, pcInheritedNoParent);
const
  TParentChildPassCodes = [pcNoParentManager, pcValidRelationship];
  TParentChildFailCodes = [pcNoInheritence, pcNoChildComponent, pcEmptyManagerComponent,
                           pcOtherChildComponent, pcInheritedNoParent];
  TAutoFixFailCodes = [pcNoInheritence, pcEmptyManagerComponent, pcNoChildComponent, pcInheritedNoParent];

type
  TParentChildFormTracker = class
  private
    FData: TObjectList;
    function FindForm(AFormClassName: String): TFormData;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddForm(AFileName, AFormClassName, AManagerComponentName: string;
                      AEmptyManager: boolean; AInheritedForm, AInheritedManager: boolean);
    procedure AddLink(ParentFormClassName, ChildFormClassName: string);
    function FormCount: integer;
    function GetFormData(index: integer): TFormData;
    function ParentChildErrorStatus(index: integer): TParentChildErrorCode;
    function ParentChildErrorDescription(index: integer): string;
  end;

 TUnitSection = (usUnknown, usInterface, usImplementation);
  TTokenState = (tsNormal, tsPendingEqualChar, tsPendingClassSymbol, tsPendingParenChar,
                  tsPendingClassName, tsPendingEndOfClass);

  TVA508Parser = class
  private
    FClassName: String;
    FParentClass: String;
    FPendingParentClass: string;
    FParser: THRParserPas;
    FToken: THRToken;
    FLastLine: integer;
    FLastPos: integer;
    FTokenName: String;
    FState: TTokenState;
    FUnitSection: TUnitSection;
    FDone: boolean;
    FIsSymbol: boolean;
    FIsChar: boolean;
    procedure ParseToken;
  public
    function GetParentClassName(ClassName, FileName: String;
                                InStream: TStream; var OutStream: TStream): String;
    function LastLineRead: integer;
    function LastPosition: integer;
  end;

procedure VA508ComponentCreationCheck(AComponent, AOwner: TComponent;
            AllowDataModules: boolean; ManagerRequired: boolean);
procedure VA508ComponentDestructionCheck(AComponent: TComponent);

const
  NO_OWNER_ERROR = 'Cannot create a %s component without an owner';

implementation

uses
  UITypes, VA508AccessibilityManager, VA508ImageListLabeler;

const
  MANAGER_CLASS_REQUIRED = 'Cannot create a %s component without a ' + #13#10 +
                           '%s component on the same form';
  OTHER_COMPONENTS_DELETED = 'Deleting this %s component also deletes all' + #13#10 +
                             'A %s components on this form';
  OWNER_NOT_ALLOWED = 'You may not place a %s component on a %s';
  OWNER_REQUIREMENTS = '%s component can only be added to a %s';
  HAS_EXISTING_MANAGER_ERROR = '%s alread has a %s component';

function HasAnotherAccessibilityManager(Root, AComponent: TComponent): boolean;
var
  i: integer;
  comp: TComponent;
begin
  Result := false;
  for i := 0 to AComponent.ComponentCount-1 do
  begin
    comp := AComponent.Components[i];
    if (comp <> Root) and (comp is TVA508AccessibilityManager) then
    begin
      Result := true;
      exit;
    end;
    if HasAnotherAccessibilityManager(Root, AComponent.Components[i]) then
    begin
      Result := true;
      exit;
    end;
  end;
end;

procedure VA508ComponentCreationCheck(AComponent, AOwner: TComponent;
            AllowDataModules: boolean; ManagerRequired: boolean);
var
  msg: string;

  procedure EnsureManager;
  var
    i: integer;
    error: boolean;
  begin
    if (csDesigning in AOwner.ComponentState) and (not (csLoading in AOwner.ComponentState)) then
    begin
      error := TRUE;
      for i := 0 to AOwner.ComponentCount-1 do
      begin
        if AOwner.Components[i] is TVA508AccessibilityManager then
        begin
          error := FALSE;
          break;
        end;
      end;
      if error then
      begin
        raise EVA508AccessibilityException.CreateFmt(MANAGER_CLASS_REQUIRED,
                                [AComponent.ClassName, TVA508AccessibilityManager.ClassName]);
      end;
    end;
  end;

begin
  if not assigned(AOwner) then
    raise EVA508AccessibilityException.CreateFmt(NO_OWNER_ERROR, [AComponent.ClassName]);
  if (AOwner is TDataModule) then
  begin
    if AllowDataModules then
      exit
    else
      raise EVA508AccessibilityException.CreateFmt(OWNER_NOT_ALLOWED, [AComponent.ClassName, TDataModule.ClassName]);
  end;
  if not (AOwner is TCustomForm) then
  begin
    msg := 'Form';
    if AllowDataModules then
      msg := msg + ' or a Data Module';
    raise EVA508AccessibilityException.CreateFmt(OWNER_REQUIREMENTS, [AComponent.ClassName, msg]);
  end;
  if ManagerRequired then
    EnsureManager
  else
  begin
    if HasAnotherAccessibilityManager(AComponent, AOwner) then
      raise EVA508AccessibilityException.Create(Format(HAS_EXISTING_MANAGER_ERROR,
            [AOwner.ClassName, AComponent.ClassName]));
  end;
end;

procedure VA508ComponentDestructionCheck(AComponent: TComponent);
var
  i: integer;
  list: TObjectList;
  msg: string;
  ComponentAccessFound, ImageListLabelerFound: boolean;
  Owner: TComponent;

begin
  if not assigned(AComponent) then exit;
  Owner := AComponent.Owner;
  if not assigned(Owner) then exit;
  if HasAnotherAccessibilityManager(AComponent, Owner) then exit;
  if (csDesigning in AComponent.ComponentState) and (not (csDestroying in Owner.ComponentState)) then
  begin
    list := TObjectList.Create;
    try
      ComponentAccessFound := FALSE;
      ImageListLabelerFound := FALSE;
      for I := 0 to Owner.ComponentCount-1 do
      begin
        if Owner.Components[i] is TVA508ComponentAccessibility then
        begin
          ComponentAccessFound := TRUE;
          list.Add(Owner.Components[i]);
        end
        else
        if Owner.Components[i] is TVA508ImageListLabeler then
        begin
          ImageListLabelerFound := TRUE;
          list.Add(Owner.Components[i]);
        end
      end;
      msg := '';
      if ImageListLabelerFound then
        msg := TVA508ImageListLabeler.ClassName;
      if ComponentAccessFound then
      begin
        if msg <> '' then
          msg := msg + ' and ';
        msg := msg + TVA508ComponentAccessibility.ClassName;
      end;
      if msg <> '' then
      begin
        MessageDlg(Format(OTHER_COMPONENTS_DELETED, [AComponent.ClassName, msg]), mtWarning, [mbOK], 0);
      end;
    finally
      list.Free;
    end;
  end;
end;

{ TFormData }

function TFormData.HasManager: boolean;
begin
  Result := ManagerComponentName <> '';
end;

function TFormData.HasParent: boolean;
begin
  Result := assigned(Parent);
end;

procedure TFormData.SetFormClassName(const Value: string);
begin
  FFormClassName := Value;
  FlcFormClassName := lowerCase(Value);
end;

{ TParentChildFormTracker }

procedure TParentChildFormTracker.AddForm(AFileName, AFormClassName, AManagerComponentName: string;
                                AEmptyManager: boolean; AInheritedForm, AInheritedManager: boolean);
var
  data: TFormData;
begin
  if FindForm(AFormClassName) = nil then
  begin
    Data := TFormData.Create;
    data.FileName := AFileName;
    data.FormClassName := AFormClassName;
    data.ManagerComponentName := AManagerComponentName;
    data.Parent := nil;
    data.InheritedForm := AInheritedForm;
    data.InheritedManager := AInheritedManager;
    data.EmptyManager := AEmptyManager;
    FData.Add(data);
  end;
end;

procedure TParentChildFormTracker.AddLink(ParentFormClassName, ChildFormClassName: string);
var
  child,parent: TFormData;
begin
  child := FindForm(ChildFormClassName);
  parent := FindForm(ParentFormClassName);
  if assigned(child) and assigned(parent) then
    child.Parent := parent;
end;

procedure TParentChildFormTracker.Clear;
begin
  FData.Clear;
end;

constructor TParentChildFormTracker.Create;
begin
  FData := TObjectList.Create;
end;

destructor TParentChildFormTracker.Destroy;
begin
  FData.Free;
  inherited;
end;

function TParentChildFormTracker.FindForm(AFormClassName: String): TFormData;
var
  i: integer;
  name: string;
begin
  name := lowercase(AFormClassName);
  Result := nil;
  for i := 0 to FData.Count - 1 do
  begin
    if GetFormData(i).lcFormClassName = Name then
    begin
      Result := GetFormData(i);
      exit;
    end;
  end;
end;

function TParentChildFormTracker.FormCount: integer;
begin
  Result := FData.Count;
end;

function TParentChildFormTracker.GetFormData(index: integer): TFormData;
begin
  Result := TFormData(FData[index]);
end;

function TParentChildFormTracker.ParentChildErrorDescription(index: integer): string;
var
  code: TParentChildErrorCode;
  parent: TFormData;
  child: TFormData;
begin
  code := ParentChildErrorStatus(index);
  Result := '';
  if code in [pcNoParentManager, pcValidRelationship] then exit;
  child := GetFormData(index);
  parent := child.Parent;
  case code of
    pcNoInheritence: Result := 'Form ' + child.FormClassName + ' descends from form ' + parent.FormClassName +
                                ' but uses the word "object" instead of "inherited" in the .dfm file.';
    pcNoChildComponent, pcEmptyManagerComponent: Result := 'Form ' + child.FormClassName +
                                ' .dfm file needs to be rebuilt.    To fix manually, view the form as text, then as a form, ' +
                                ' make sure the form is in a modified state, and save it.';
    pcOtherChildComponent: Result := 'Form ' + child.FormClassName + ' has two ' + TVA508AccessibilityManager.ClassName +
                                ' components, one from an inherited form, and one on the form.' +
                                '  Remove the component on the form and use the inherited component';
    pcInheritedNoParent: Result := 'Form ' + child.FormClassName + ' has a ' + TVA508AccessibilityManager.ClassName +
                                ' component, ' + child.ManagerComponentName +
                                ', that was inherited from a parent form, but ' + child.ManagerComponentName +
                                ' has been deleted from the parent form.  To Remove the component, view the form as text, then as a form, ' +
                                ' make sure the form is in a modified state, and save it.  Or you can add the ' +
                                TVA508AccessibilityManager.ClassName + ' component back onto the parent form.';
    else Result := '';
  end;
end;

function TParentChildFormTracker.ParentChildErrorStatus(
  index: integer): TParentChildErrorCode;
var
  parent: TFormData;
  child: TFormData;
  bad: boolean;

begin
  Result := pcNoParentManager;
  child := GetFormData(index);
  if not assigned(child) then exit;

  bad := false;
  if child.InheritedManager then
  begin
    bad := not child.HasParent;
    if not bad then
      bad := not child.InheritedForm;
    if not bad then
      bad := not child.Parent.HasManager;
  end;

  try
    if not child.HasParent then exit;
    parent := child.Parent;
    if not parent.HasManager then exit;
    if child.InheritedForm then
    begin
      if child.HasManager then
      begin
        if (parent.ManagerComponentName = child.ManagerComponentName) and
            (child.InheritedManager) then
        begin
          if child.EmptyManager then
            Result := pcEmptyManagerComponent
          else
            Result := pcValidRelationship
        end
        else
          Result := pcOtherChildComponent
      end
      else
        Result := pcNoChildComponent;
    end
    else
      Result := pcNoInheritence;
  finally
    if bad and (Result = pcNoParentManager) then
      Result := pcInheritedNoParent;
  end;
end;

const
  INTERFACE_NAME      = 'interface';
  IMPLEMENTATION_NAME = 'implementation';

  CLASS_NAME = 'class';
  LEFT_PAREN  = '(';
  RIGHT_PAREN = ')';
  COMMA       = ',';
//  EQUALS      = '=';

{ TVA508Parser }

function TVA508Parser.GetParentClassName(ClassName, FileName: String;
                                InStream: TStream; var OutStream: TStream): String;
begin
  FClassName := lowerCase(ClassName);
  FParentClass := '';
  FState := tsNormal;
  FUnitSection := usUnknown;
  FDone := false;

  if(assigned(FParser)) then
    FParser.Free;
  FParser := THRParserPas.Create;
  FLastLine := 0;
  FLastPos := 0;
  if assigned(InStream) then
    FParser.Source := InStream
  else
    FParser.Source := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
  try
    while (not FDone) and (FParser.NextToken.TokenType <> HR_TOKEN_EOF) do
    begin
      FToken := FParser.Token;
      FLastLine := FToken.Line;
      FLastPos := FToken.SourcePos;
      ParseToken;
    end;
  finally
    if assigned(InStream) then
    begin
      InStream.Free;
      OutStream := nil;
    end
    else
      OutStream := FParser.Source;
    FreeAndNil(FParser);
  end;
  Result := FParentClass;  
end;

function TVA508Parser.LastLineRead: integer;
begin
  Result := FLastLine;
end;

function TVA508Parser.LastPosition: integer;
begin
  Result := FLastPos + 1;
end;

procedure TVA508Parser.ParseToken;

  function IgnoreToken: boolean;
  begin
    if(FUnitSection = usImplementation) then
    begin
      Result := TRUE;
      exit;
    end;
    case FToken.TokenType of
      HR_TOKEN_TEXT_SPACE, HR_TOKEN_PAS_COMMENT_SLASH,
      HR_TOKEN_PAS_COMMENT_BRACE_OPEN, HR_TOKEN_PAS_COMMENT_BRACE,
      HR_TOKEN_PAS_COMMENT_BRACKET_OPEN, HR_TOKEN_PAS_COMMENT_BRACKET:
        Result := TRUE;
      else
        Result := FALSE;
    end;
  end;

  function InvalidSection: boolean;
  var
    changed: boolean;
  begin
    changed := false;
    if FIsSymbol then
    begin
      if FTokenName = INTERFACE_NAME then
      begin
        FUnitSection := usInterface;
        changed := true;
      end
      else if FTokenName = IMPLEMENTATION_NAME then
      begin
        FUnitSection := usImplementation;
        FDone := TRUE;
        changed := true;
      end;
    end;
    Result := (FUnitSection <> usInterface);
    if changed then
      FState := tsNormal;
  end;

begin
  if(IgnoreToken) then exit;

  FTokenName := LowerCase(FToken.Token);
  FIsSymbol  := (FToken.TokenType = HR_TOKEN_TEXT_SYMBOL);
  FIsChar    := (FToken.TokenType = HR_TOKEN_CHAR);

  if(InvalidSection) then exit;
  case FState of
    tsNormal:               if FIsSymbol and (FTokenName = FClassName) then
                              FState := tsPendingEqualChar;
    tsPendingEqualChar:     if FIsChar and (FTokenName = '=') then
                              FState := tsPendingClassSymbol
                            else
                              FState := tsNormal;
    tsPendingClassSymbol:   if FIsSymbol and (FTokenName = CLASS_NAME) then
                              FState := tsPendingParenChar
                            else
                              FState := tsNormal;
    tsPendingParenChar:     if FIsChar and (FTokenName = LEFT_PAREN) then
                              FState := tsPendingClassName
                            else
                              FState := tsNormal;
    tsPendingClassName:     if FIsSymbol then
                            begin
                              FPendingParentClass := FToken.Token;
                              FState := tsPendingEndOfClass;
                            end
                            else
                              FState := tsNormal;
    tsPendingEndOfClass:    begin
                              if FIsChar and ((FTokenName = RIGHT_PAREN) or
                                  (FTokenName = COMMA)) then
                              begin
                                FParentClass := FPendingParentClass;
                                FDone := TRUE;
                              end;
                              FState := tsNormal;
                            end;
  else
    FState := tsNormal;
  end;
end;


end.
