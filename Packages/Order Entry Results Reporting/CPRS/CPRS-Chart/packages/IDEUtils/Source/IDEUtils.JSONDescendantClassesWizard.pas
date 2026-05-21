unit IDEUtils.JSONDescendantClassesWizard;

interface

uses
  System.Classes, System.SysUtils, DesignIntf, ToolsAPI;

procedure Register;

var
  AJSONDescendantClassesWizard: IOTARepositoryWizard260;

implementation

uses
  vcl.Forms, IDEUtils.JSONDescendantClassesWizardForm;

type
  TJSONDescendantClassesWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard,
    IOTARepositoryWizard, IOTARepositoryWizard60, IOTARepositoryWizard80,
    IOTARepositoryWizard160, IOTARepositoryWizard190, IOTARepositoryWizard260)
  public
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    function GetGlyph: THandle;
    // IOTARepositoryWizard60
    function GetDesigner: string;
    // IOTARepositoryWizard80
    function GetGalleryCategory: IOTAGalleryCategory;
    function GetPersonality: string;
    // IOTARepositoryWizard160
    function GetFrameworkTypes: TArray<string>;
    function GetPlatforms: TArray<string>;
    // IOTARepositoryWizard190
    function GetSupportedPlatforms: TArray<string>;
    // IOTARepositoryWizard260
    function GetGalleryCategories: TArray<IOTAGalleryCategory>;
  end;

  { TJSONDescendantClassesWizard }

procedure TJSONDescendantClassesWizard.Execute;
var
  WizardForm: TfrmJSONDescendantClassesWizardForm;
begin
  WizardForm := TfrmJSONDescendantClassesWizardForm.Create(Application);
  try
    WizardForm.ShowModal;
  finally
    WizardForm.Free;
  end;
end;

function TJSONDescendantClassesWizard.GetAuthor: string;
begin
  Result := 'Department of Veteran''s Affairs';
end;

function TJSONDescendantClassesWizard.GetComment: string;
begin
  Result := 'Generates Delphi types descending from types created from the ' +
      'JSON Data Binding Wizard, including JSON library binding for the ' +
      'descendant classes.';
end;

function TJSONDescendantClassesWizard.GetDesigner: string;
begin
  Result := dVCL;
end;

function TJSONDescendantClassesWizard.GetFrameworkTypes: TArray<string>;
begin
  SetLength(Result, 1);
  Result[0] := sFrameworkTypeVCL;
end;

function TJSONDescendantClassesWizard.GetGalleryCategories: TArray<IOTAGalleryCategory>;
begin
  SetLength(Result, 1);
  Result[0] := GetGalleryCategory;
end;

function TJSONDescendantClassesWizard.GetGalleryCategory: IOTAGalleryCategory;
var
  Category: IOTAGalleryCategory;
  CatManager: IOTAGalleryCategoryManager;
begin
  CatManager := (BorlandIDEServices as IOTAGalleryCategoryManager);
  if Assigned(CatManager) then
  begin
    Category := CatManager.FindCategory(sCategoryDelphiWeb);
    Result := Category;
  end;
end;

function TJSONDescendantClassesWizard.GetGlyph: THandle;
begin
  Result := 0;
end;

function TJSONDescendantClassesWizard.GetIDString: string;
begin
  Result := '{C4ECB346-2175-452F-A2C1-2D0CDF0C3111}';
end;

function TJSONDescendantClassesWizard.GetName: string;
begin
  Result := 'JSON Data Binding Descendant Classes';
end;

function TJSONDescendantClassesWizard.GetPage: string;
begin
  Result := 'New';
end;

function TJSONDescendantClassesWizard.GetPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TJSONDescendantClassesWizard.GetPlatforms: TArray<string>;
begin
  SetLength(Result, 1);
  Result[0] := 'Win32';
end;

function TJSONDescendantClassesWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TJSONDescendantClassesWizard.GetSupportedPlatforms: TArray<string>;
begin
  SetLength(Result, 1);
  Result[0] := 'Win32';
end;

procedure Register;
begin
  AJSONDescendantClassesWizard := TJSONDescendantClassesWizard.Create;
  RegisterPackageWizard(AJSONDescendantClassesWizard);
end;

end.
