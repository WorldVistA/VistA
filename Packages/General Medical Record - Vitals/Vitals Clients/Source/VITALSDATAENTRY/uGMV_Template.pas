unit uGMV_Template;

interface

uses
  SysUtils
  ,Classes
  ,Dialogs
  ;

type
  TGMV_TemplateEntityType = (
    teUnknown,
    teDomain,
    teInstitution,
    teHospitalLocation,
    teNewPerson);

  TGMV_TemplateVital = class(TObject)
  private
    FMetric: Boolean;
    FIEN: string;
    FVitalName: string;
    FQualifiers: string;
    procedure SetIEN(const Value: string);
    procedure SetVitalName(const Value: string);
    procedure SetQualifiers(const Value: string);
    procedure SetMetric(const Value: Boolean);
    function GetDisplayQualifiers: string;
  public
    constructor Create;
    constructor CreateFromXPAR(XPARVal: string);
//    destructor Destroy; override;
 // published
    property VitalName: string read FVitalName write SetVitalName;
    property IEN: string read FIEN write SetIEN;
    property Metric: Boolean read FMetric write SetMetric;
    property Qualifiers: string read FQualifiers write SetQualifiers;
    property DisplayQualifiers: string read GetDisplayQualifiers;
  end;

  TGMV_TemplateOwner = class(TObject)
  private
    FEntity: string;
    FOwnerName: string;
    procedure SetEntity(const Value: string);
    procedure SetOwnerName(const Value: string);
  public
    constructor Create(OwnerName: string; Entity: string);
    destructor Destroy; override;
 // published
    property OwnerName: string read FOwnerName write SetOwnerName;
    property Entity: string read FEntity write SetEntity;
  end;

 TGMV_Template = class(TObject)
  private
    FEntityType: TGMV_TemplateEntityType;
    FEntity: string;
    FOwner: TGMV_TemplateOwner;
    FTemplateName: string;
    procedure SetEntityType(const Value: TGMV_TemplateEntityType);
    procedure SetEntity(const Value: string);
    procedure SetOwner(const Value: TGMV_TemplateOwner);
    procedure SetTemplateName(const Value: string);
    function GetXPARValue: string;
    procedure SetXPARValue(const Value: string);
  public
    constructor Create;
    constructor CreateFromXPAR(XPARVal: string);
    destructor Destroy; override;
    function Rename(NewName: string): Boolean;
    function SetAsDefault: Boolean;
    function VitalsCount: integer;
    function Vital(Index: integer): TGMV_TemplateVital;
 // published
    property EntityType: TGMV_TemplateEntityType read FEntityType write SetEntityType;
    property Entity: string read FEntity write SetEntity;
    property Owner: TGMV_TemplateOwner read FOwner write SetOwner;
    property TemplateName: string read FTemplateName write SetTemplateName;
    property XPARValue: string read GetXPARValue write SetXPARValue;
  end;

  TGMV_DefaultTemplates = class(TObject)
  private
    FTemplates: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function DefaultTemplate(Entity: string): string;
    function IsDefault(Entity: string; Name: string): boolean;
  end;

var
  GMVDefaultTemplates: TGMV_DefaultTemplates;
const
  GMVENTITYNAMES: array[TGMV_TemplateEntityType] of string = (
       'Unknown', 'System', 'Division', 'Location', 'User');

//procedure GetTemplateList(Entity: string; var List: TStringList);

function GetTemplateObject(Entity, Name: string): TGMV_Template;
function GetDefaultTemplateObject(Entity: string): TGMV_Template;

function CreateNewUserTemplate: TGMV_Template;

implementation

uses uGMV_Common
  , uGMV_GlobalVars
  , uGMV_FileEntry
  , uGMV_Engine
  , System.UITypes;

{ TGMV_TemplateVital }

constructor TGMV_TemplateVital.Create;
begin
  inherited;
end;

constructor TGMV_TemplateVital.CreateFromXPAR(XPARVal: string);
begin
  inherited Create;
  FIEN := Piece(XPARVal, ':', 1);
  try
    FVitalName := GMVTypes.Entries[GMVTypes.IndexOfIEN(FIEN)];
  except
    FVitalName := 'Unknown ('+FIEN+')';
  end;
  FMetric := (Piece(XPARVal, ':', 2) = '1');
  FQualifiers := Piece(XPARVal, ':', 3);
end;

//destructor TGMV_TemplateVital.Destroy;
//begin
//  inherited;
//end;

function TGMV_TemplateVital.GetDisplayQualifiers: string;
var
  i: integer;
  q: string;
  x: string;
begin
  x := '';
  i := 1;
  while Piece(FQualifiers, '~', i) <> '' do
    begin
      q := Piece(FQualifiers, '~', i);
      if x <> '' then
        x := x + ',';
      try
        x := x + GMVQuals.Entries[GMVQuals.IndexOfIEN(Piece(q, ',', 2))];
      except
      end;
      inc(i);
    end;
  Result := '[' + x + ']';//  Result := '[' + TitleCase(x) + ']';  //AAN 07/18/2002
end;

procedure TGMV_TemplateVital.SetIEN(const Value: string);
begin
  FIEN := Value;
end;

procedure TGMV_TemplateVital.SetVitalName(const Value: string);
begin
  FVitalName := Value;
end;

procedure TGMV_TemplateVital.SetQualifiers(const Value: string);
begin
  FQualifiers := Value;
end;

procedure TGMV_TemplateVital.SetMetric(const Value: Boolean);
begin
  FMetric := Value;
end;

{ TGMV_Template }

constructor TGMV_Template.Create;
begin
  inherited Create;
end;

constructor TGMV_Template.CreateFromXPAR(XPARVal: string);
begin
  inherited Create;
  case StrToIntDef(Piece(XPARVal, '^', 1), 0) of
    1: FEntityType := teDomain;
    2: FEntityType := teInstitution;
    3: FEntityType := teHospitalLocation;
    4: FEntityType := teNewPerson;
  else
    FEntityType := teUnknown;
  end;
  FEntity := Piece(XParVal, '^', 2);
  FOwner := TGMV_TemplateOwner.Create(Piece(XPARVal, '^', 3), FEntity);
  FTemplateName := Piece(XParVal, '^', 4);
  //  FXPARValue := Piece(XParVal,'^',5);
end;

destructor TGMV_Template.Destroy;
begin
  inherited;
end;

procedure TGMV_Template.SetEntityType(const Value: TGMV_TemplateEntityType);
begin
  FEntityType := Value;
end;

procedure TGMV_Template.SetEntity(const Value: string);
begin
  FEntity := Value;
end;

procedure TGMV_Template.SetOwner(const Value: TGMV_TemplateOwner);
begin
  FOwner := Value;
end;

procedure TGMV_Template.SetTemplateName(const Value: string);
begin
  FTemplateName := Value;
end;

procedure TGMV_Template.SetXPARValue(const Value: string);
begin
  setTemplate(FEntity,FTemplateName,Value);
end;

function TGMV_Template.GetXPARValue: string;
begin
  Result := Piece(getTemplateValue(FEntity,FTemplateName), '^', 5);
end;

function TGMV_Template.Rename(NewName: string): Boolean;
begin
  if renameTemplate(FEntity,FTemplateName,NewName)<>'-1' then
    begin
      Result := True;
      FTemplateName := NewName;
    end
  else
    Result := False;
end;

function TGMV_Template.SetAsDefault: Boolean;
begin
  Result := (Piece(SetDefaultTemplate(FEntity,FTemplateName), '^', 1) <> '-1');
end;

function TGMV_Template.Vital(Index: integer): TGMV_TemplateVital;
begin
  ShowMessage('This is supposed to return a TGMV_TemplateVital');
  Result := nil;
end;

function TGMV_Template.VitalsCount: integer;
begin
  Result := 0;
end;

{ TGMV_TemplateOwner }

constructor TGMV_TemplateOwner.Create(OwnerName: string; Entity: string);
begin
  inherited Create;
  FEntity := Entity;
  FOwnerName := OwnerName;
end;

destructor TGMV_TemplateOwner.Destroy;
begin
  inherited;
end;

procedure TGMV_TemplateOwner.SetEntity(const Value: string);
begin
  FEntity := Value;
end;

procedure TGMV_TemplateOwner.SetOwnerName(const Value: string);
begin
  FOwnerName := Value;
end;

/////////////////////////////////////////////////////////////////////

function GetDefaultTemplateObject(Entity: string): TGMV_Template;
var
  s: String;
begin
  s := getDefaultTemplateByID(Entity);
  if Piece(s, '^', 1) = '-1' then
      Result := nil
  else
    Result := GetTemplateObject(Entity, s);
end;

function GetTemplateObject(Entity, Name: string): TGMV_Template;
var
  s: String;
begin
  s := getTemplateValue(Entity,Name);
  try
    Result := TGMV_Template.CreateFromXPAR(s);
  except
    Result := nil;
  end;
end;

(*
procedure GetTemplateList(Entity: string; var List: TStringList);
var
  i: integer;
  SL: TStringList;
begin
  if List = nil then List := TStringList.Create;
  List.Clear;

  SL := getTemplateListByID(Entity);
  for i := 0 to SL.Count - 1 do
    List.AddObject(Piece(SL[i], '^', 4), TGMV_Template.CreateFromXPAR(SL[i]));
end;
*)

function CreateNewUserTemplate: TGMV_Template;
var
  s,
  TemplateName: string;
begin
  if InputQuery('Create New Template', 'Template Name:', TemplateName) then
    begin
      s := createUserTemplateByName(Templatename);
      if Piece(s, '^') = '-1' then
        begin
          MessageDlg('Unable to Create New Template'#13#13+
            Piece(s, '^',3), mtError, [mbOK], 0);
          Result := nil;
        end
      else
        Result := TGMV_Template.CreateFromXPAR(S);
    end
  else
    Result := nil;
end;

{ TGMV_DefaultTemplates }

constructor TGMV_DefaultTemplates.Create;
begin
  inherited Create;
  FTemplates := getDefaultTemplateList;
end;

function TGMV_DefaultTemplates.DefaultTemplate(Entity: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FTemplates.Count - 1 do
    if Piece(FTemplates[i], '^', 1) = Entity then
      begin
        Result := Piece(FTemplates[i], '^', 2);
        Exit;
      end
end;

destructor TGMV_DefaultTemplates.Destroy;
begin
  FreeAndNil(FTemplates);
  inherited;
end;


function TGMV_DefaultTemplates.IsDefault(Entity, Name: string): boolean;
begin
  Result := (FTemplates.IndexOf(Entity + '^' + Name) > -1);
end;

end.
