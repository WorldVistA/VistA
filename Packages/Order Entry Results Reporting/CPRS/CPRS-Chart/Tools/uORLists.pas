unit uORLists;
interface
uses
  System.Classes,
  rCore,
  rConsults,
  ORCtrls;

procedure setClinicList(aComponent: TORComboBox; aStart: string; aDirection: Integer);
procedure setPatientList(aComponent: TORComboBox; aStart: string; aDirection: Integer);
procedure setPersonList(aComponent: TORComboBox; aStart: string; aDirection: Integer);
procedure setProviderList(aComponent: TORComboBox; aStart: string; aDirection: Integer);
procedure setProcedureList(aComponent: TORComboBox; aStart: string; aDirection: Integer);

implementation
type
  ITEM_TYPES = (itPerson, itClinic, itProvider, itPatient, itProcedure);

procedure setItemsList(anItem: ITEM_TYPES; aComponent: TORComboBox; aStart: String; aDirection: Integer);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    case anItem of
      itPerson: setSubSetOfPersons(aComponent, sl, aStart, aDirection);
      itClinic: setSubSetOfClinics(sl, aStart, aDirection);
      itProvider: setSubSetOfProviders(aComponent, sl, aStart, aDirection);
      itPatient: setSubSetOfPatients(sl, aStart, aDirection);
      itProcedure: setSubSetOfProcedures(sl, aStart, aDirection);
    end;
    aComponent.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure setClinicList(aComponent: TORComboBox; aStart: String; aDirection: Integer);
begin
  setItemsList(itClinic, aComponent, aStart, aDirection);
end;

procedure setPatientList(aComponent: TORComboBox; aStart: String; aDirection: Integer);
begin
  setItemsList(itPatient, aComponent, aStart, aDirection);
end;

procedure setPersonList(aComponent: TORComboBox; aStart: String; aDirection: Integer);
begin
  setItemsList(itPerson, aComponent, aStart, aDirection);
end;

procedure setProviderList(aComponent: TORComboBox; aStart: String; aDirection: Integer);
begin
  setItemsList(itProvider, aComponent, aStart, aDirection);
end;

procedure setProcedureList(aComponent: TORComboBox; aStart: String; aDirection: Integer);
begin
  setItemsList(itProcedure, aComponent, aStart, aDirection);
end;

end.
