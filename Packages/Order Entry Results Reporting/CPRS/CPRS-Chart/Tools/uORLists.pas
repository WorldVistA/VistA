unit uORLists;

interface

uses
  System.Classes,
  rCore,
  rConsults,
  ORCtrls;

procedure setClinicList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
procedure setPatientList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
procedure setPersonList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
procedure setPersonListWithClass(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
procedure setProviderList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
procedure setProcedureList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);

implementation

type
  ITEM_TYPES = (itPerson, itPersonWithClass, itClinic, itProvider, itPatient, itProcedure);

procedure setItemsList(anItem: ITEM_TYPES; AORComboBox: TORComboBox;
  aStart: string; aDirection: Integer);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    case anItem of
      itPerson: setSubSetOfPersons(AORComboBox, sl, aStart, aDirection, False);
      itPersonWithClass: setSubSetOfPersons(AORComboBox, sl, aStart, aDirection, True);
      itClinic: setSubSetOfClinics(sl, aStart, aDirection);
      itProvider: setSubSetOfProviders(AORComboBox, sl, aStart, aDirection);
      itPatient: setSubSetOfPatients(sl, aStart, aDirection);
      itProcedure: setSubSetOfProcedures(sl, aStart, aDirection);
    end;
    AORComboBox.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure setClinicList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
begin
  setItemsList(itClinic, AORComboBox, aStart, aDirection);
end;

procedure setPatientList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
begin
  setItemsList(itPatient, AORComboBox, aStart, aDirection);
end;

procedure setPersonList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
begin
  setItemsList(itPerson, AORComboBox, aStart, aDirection);
end;

procedure setPersonListWithClass(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
begin
  setItemsList(itPersonWithClass, AORComboBox, aStart, aDirection);
end;

procedure setProviderList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
begin
  setItemsList(itProvider, AORComboBox, aStart, aDirection);
end;

procedure setProcedureList(AORComboBox: TORComboBox; aStart: string;
  aDirection: Integer);
begin
  setItemsList(itProcedure, AORComboBox, aStart, aDirection);
end;

end.
