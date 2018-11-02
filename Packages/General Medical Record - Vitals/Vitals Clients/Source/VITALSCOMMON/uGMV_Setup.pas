unit uGMV_Setup;

interface

procedure setUpGlobals;
procedure CleanUpGlobals;

implementation

uses uGMV_User, uGMV_FileEntry, uGMV_Template, SysUtils;

var
  InstanceCounter: Integer;

procedure setUpGlobals;
begin
  Inc(InstanceCounter);
  if InstanceCounter > 1 then Exit;

  GMVUser := TGMV_User.Create;
  GMVTypes := TGMV_VitalType.Create;

  InitVitalsIENS;

  GMVQuals := TGMV_VitalQual.Create;
  GMVCats := TGMV_VitalCat.Create;
  GMVClinics := TGMV_Clinics.Create;
  GMVDefaultTemplates := TGMV_DefaultTemplates.Create;
////////////////////////////////////////////////// exist in the main Application
//  GMVTeams := TGMV_Teams.Create;
//  GMVNursingUnits := TGMV_NursingUnit.Create;
//  GMVWardLocations := TGMV_WardLocation.Create;
////////////////////////////////////////////////////////////////////////////////
end;

procedure CleanUpGlobals;
begin
  Exit; // zzzzzzandria 20080929 No more then 1 instance allowed.

  FreeAndNil(GMVDefaultTemplates);
  FreeAndNil(GMVTypes);
  FreeAndNil(GMVQuals);
  FreeAndNil(GMVCats);
  FreeAndNil(GMVClinics);
  FreeAndNil(GMVUser);
end;

initialization
  instanceCounter := 0;
end.
