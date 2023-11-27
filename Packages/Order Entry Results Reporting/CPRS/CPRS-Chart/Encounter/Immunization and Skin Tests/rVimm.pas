unit rVimm;

interface

uses Contnrs, SysUtils, Classes, ORNet, ORFn, ORClasses, ORNetINTF, windows, uCore,
system.JSON;

type

  TVimmInputs = record
    noGrid: boolean;
    makeNote: boolean;
    collapseICE: boolean;
    canSaveData: boolean;
    isSkinTest: boolean;
//    isFromEncounter: boolean;
//    isHistorical: boolean;
    selectionType: string;
    patientName: string;
    patientIEN: string;
    userName: string;
    userIEN: Int64;
    encounterProviderName: string;
    encounterProviderIEN: Int64;
    encounterLocation: integer;
    encounterCategory: Char;
    dateEncounterDateTime: TFMDateTime;
    visitString: string;
    documentType: string;
    startInEditMode: boolean;
    adminDate: TFMDateTime;
    needOverride: boolean;
    hasPlacements: boolean;
    immunizationReading: boolean;
    defaultSeries: string;
    coSignerIEN: Int64;
    noteIEN: string;
//    EditList: TStringList;
    DataList: TStringList;
    NewList: TStringList;
    fromCover: boolean;
  end;

TVimmList = record
  //total list of items for population of additional combo box
  vimmList: TStringList;
  //list of items for population of immunization combobox when documentating an administration at the encounter
  vimmActiveList: TStringList;
  //list of items for population of immunization combobox when documentating historical events
  vimmHistoricalList: TStringList;
  //list of skin test for population of skin test combobox
  vimmSkinTestList: TStringList;
  //last encounter date
  date: TFmDateTime;
  //first administration code
  firstCode: string;
  //additional administration code
  additionalCodes: string;
  skinAdminList: TStringList;
end;

//list of vimm data objects to either send to PCE or back to CPRS
TVimmResults = record
  results: TStringList;
end;

//main immunization data object
TVimm = class(TObject)
  public
  ID: string;
  name: string;
  shortName: string;
//  maxInSeries: string;
  cvxCode: string;
  inactive: boolean;
  mnemonic: string;
  acronym: string;
  historical: boolean;
  hasLot: boolean;
  cdcList: TStringList;
  groupList: TStringList;
  synonymList: TStringList;
  complete: boolean;
  constructor Create;
  destructor Destroy; override;
end;

//Result object populated from user selection in the UI
TVimmResult = class(TObject)
private
  function GetUniqueIDValue: string;
public
  id            : string;
  name          : string;
  documType     : string;
//  orderByIEN    : string;
//  orderBy       : string;
//  adminDate     : TFMDateTime;
  outsideLocIEN  : string;
  outsideLoc    : string;
  cptCode        : string;
  dxCode        : string;
  noteText      : Tstrings;
  isSkin        : boolean;
  readByIEN     : string;
  readBy        : string;
  DelimitedStr: string;
  DelimitedStr2: string;
  DelimitedStr3: string;
  defaultDataList: TStrings;
  uniqueID           : string;
  constructor Create; overload;
  constructor Create(input, str2, str3: string; bldLayout: boolean = true); overload;
  constructor Create(input, str2, str3, unqID: string; bldLayout: boolean = true); overload;
  destructor Destroy; override;
  function isComplete: boolean;
  function getNoteText: Tstrings;
  function procedureDelimitedStr: string;
  function diagnosisDelimitedStr: string;
  procedure setfromDelimitedStr(input, encType: string);
  function findDefaultValue(name: string): string;
  function isContraindicated: boolean;
  function isRefused: boolean;
  function getSeries: string;
  function getSeriesFromString: string;
  function getReadingValue: string;
  function getReadingResult: string;
  function copy: TVimmResult;
end;

//populate initial comboBox
procedure getIMMShortList(adminDate: TFMDateTime; isSkin: boolean);
procedure setIMMShortList(shortList: TStringList);
procedure setSKShortList(shortList: TStringList);
procedure setImmShortActiveLookup(immData: TVimm);
procedure setSKShortActiveLookup(data: TVimm);
procedure setImmShortHistoricalLookup(immData: TVimm);
procedure getShortActiveLookup(var dataList: TStringList; isSkinTest, checkPlacements: boolean);
procedure getSkinReadingList(var dataList: TStringList);
procedure getShortHistoricalLookup(var immList: TStringList);
procedure getsubSetData(var immList: TStringList; dataType, id: string);
procedure getItemHist(var tmpList: TStrings; id: string);
//procedure getBillingCodes(encounterDate: TFmDateTime);
//procedure setBillingCodes(encounterDate: TFmDateTime; list: TStringList);
//procedure getCPTBillingCodes(var first, second: string);
procedure getBillingCodesList(immunizationList: TStrings; visitIEN: string; var cptLists: TStrings);
function placementsOnFile(): boolean;
function getSkinPlacementDates(): boolean;
function getSkinPlacementInfo(testID: string): string;
procedure removeSkinPlacementInfo(data: TVimmResult);
procedure checkEncounterInfo;

//set vimm initial objects and look ups
//procedure getImmData(immunization: string; date: TFMDateTime);
procedure getSkinData(skin: string; date: TFMDateTime);
procedure setImmDataDetails(tmpList: TStringList);
procedure setSkinDataDetails(tmpList: TStringList);
procedure setTopImmData(var immData: TVimm; tmp: string);
procedure setTopSkinData(var data: TVimm; tmp: string);
procedure setSubImmData(var immData: TVimm; tmp: string);
function getVImmIds(immunization: string; isHistorical: boolean): string;
procedure getReminders(var AReturn: TStrings; isSkin: boolean);
procedure getReminderMaint(IEN: integer; var aReturn: TStrings);
procedure getICEResults(var aReturn: TStrings);

//procedure and function calls for UI support
function getVimmData(data: string): TVimm;
function getVimmResultById(idx: integer): TVimmResult;
function getVimmResultByNameAndType(name, documentType: string): TVimmResult;
function getVimmResultIdx(data: TVimmResult): integer;
function hasVimmResult(input, documentationType: string): boolean;
function hasVimmResultData(input: string): boolean;
function setVimmResults(vimmData: TVimmResult): integer;
function setInitialVimmResult(item, documentType: string): integer;
procedure getVimmResultList(var resultList: TStringList);
function removeVimmResult(immunization: string): boolean;
function checkForWarning(patient, immunization: string; date: TFMDateTime): string;
function findVimmResultsByDelimitedStr(str1, str2, str3: string): TVimmResult;
function useICEForm: boolean;
function allComplete: boolean;
procedure clearResults;
procedure clearLists;
procedure clearInputs;
function getVimmResultByUniqueID(uid: string): TVimmResult;

procedure buildLayoutFromStrings(data: TVimmResult);

//the following are used when form is open from CPRS coversheet or another application beside CPRS.
//function findDefaultValue(data: TVimmResult; name: string): string;
function findOutsideLocation(data: TVimmResult): string;
procedure saveData(encDate: TFMDateTime; encLoc, encType, encProv, patient, user: String; var activeList, historicalList, noteList: TStringList);
procedure buildCurrentPCEList(currList: TStringList; encDate: TFMDateTime; encLoc, encType, encProvider, patient, vstr, noteResult: string; var PCEList: TStringList);
procedure saveHistoricalData(histList: TStringList; encProvider, patient, noteIEN, visitIEN: string);
//procedure setPCEHeader(var PCEList: TStringList; EncCat, EncDate, EncLoc, EncProv, VisitString, patient: string);
function checkForNoteTitle: string;
function saveNoteText(noteList: TStrings; encDate: TFMDateTime; encLoc, encType, vstr, patient, user, cosigner: string): string;
procedure buildVISString(dataStr, intVal: string; visCompleteList, visList: TStrings);
procedure buildLotString(dataStr, intVal: string; lotCompleteList, lotList: TStrings);
procedure showNoActiveImmMsg(name: string);
function setPrimaryDiagnosisByLocation: boolean;


var
  uVimmList: TVimmList;
  uVimmResults: TVimmResults;
  uVimmInputs: TVimmInputs;

  const
  genericIMM = 'IMMUNIZATION, NO DEFAULT SELECTED';

implementation
uses
uPCE, rPCE, rCore, rTIU;
const
  UpperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  LowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  Digits = '0123456789';

//pull initial selection list for the main combo box. The values of the list changes based off of documentation type
procedure getIMMShortList(adminDate: TFMDateTime; isSkin: boolean);
var
tmpList: TStringList;
begin
  if (isSkin) and (uVimmList.vimmSkinTestList <> nil) and (uVimmList.vimmSkinTestList.count > 0) then exit;
  if (not isSkin) and (uVimmList.vimmActiveList <> nil) and (uVimmList.vimmActiveList.count > 0) then  exit;

   uVimmList.vimmList := TStringList.Create;
   uVimmList.vimmActiveList := TStringList.Create;
   uVimmList.vimmHistoricalList := TStringList.Create;
   uVimmList.vimmSkinTestList := TStringList.Create;
   tmpList := TStringList.Create;
   try
    //call for active records
    if isSkin then
      begin
        CallVistA('PXVSK SKIN SHORT LIST',[adminDate, 'S:A', 0, IntToStr(uVimmInputs.encounterLocation)],tmpList);
        setSKShortList(tmpList);
      end
    else
      begin
        CallVistA('PXVIMM IMM SHORT LIST',['B', adminDate, 0, IntToStr(uVimmInputs.encounterLocation)],tmpList);
        setIMMShortList(tmpList);
      end;
   finally
     FreeAndNil(tmpList);
   end;

end;

procedure setIMMShortList(shortList: TStringList);
var
i, idx, j: integer;
immData: TVimm;
tmp: string;
begin
  j := 0;
   for i := 0 to shortList.Count - 1 do
     begin
        if i < j then continue;
        tmp := shortList.Strings[i];
        if Piece(tmp, U, 1) <> 'IMM' then continue;
        idx := uVimmList.vimmList.IndexOf(Piece(tmp, u, 2));
        if idx = -1 then
          begin
            immData := TVimm.Create;
            setTopImmData(immData, Pieces(tmp,u,2,99));
            j := i;
            inc(j);
            if j < shortlist.Count then
              begin
                while Piece(shortList.Strings[j], U, 1) <> 'IMM' do
                  begin
                    tmp := shortList.Strings[j];
                    setSubImmData(immData, tmp);
                    if j = shortlist.Count -1 then break;
                    inc(j);
                  end;
              end;
            immData.complete := false;
            idx := uVimmList.vimmList.addObject(immData.id, immData);
          end;
        if idx = -1 then continue;
        immData := TVimm(uVimmList.vimmList.Objects[idx]);
        if immData.historical = true then setImmShortHistoricalLookup(immData);
        if  not immData.hasLot then continue;
        if immData.inactive = false then setImmShortActiveLookup(immData);
     end;
end;

procedure setSKShortList(shortList: TStringList);
var
i, idx, j: integer;
skData: TVimm;
tmp: string;
begin
  j := 0;
   for i := 0 to shortList.Count - 1 do
     begin
        if i < j then continue;
        tmp := shortList.Strings[i];
        if Piece(tmp, U, 1) <> 'SK' then continue;
        idx := uVimmList.vimmList.IndexOf(Piece(tmp, u, 2));
        if idx = -1 then
          begin
            skData := TVimm.Create;
            setTopSkinData(skData, Pieces(tmp,u,2,99));
            j := i;
            inc(j);
            if j < shortlist.Count then
              begin
                while Piece(shortList.Strings[j], U, 1) <> 'SK' do
                  begin
                    tmp := shortList.Strings[j];
                    setSubImmData(skData, tmp);
                    if j = shortlist.Count -1 then break;
                    inc(j);
                  end;
              end;
            skData.complete := true;
            idx := uVimmList.vimmList.addObject(skData.id, skData);
          end;
        if idx = -1 then continue;
        setSKShortActiveLookup(skData);
     end;
end;

//build lookup text for the combo box
procedure setImmShortActiveLookup(immData: TVimm);
var
c: Integer;
cdc: string;
begin
  uVimmList.vimmActiveList.add(immData.ID + U + immData.name);
  if immData.mnemonic <> '' then uVimmList.vimmActiveList.add(immData.ID + U + immData.mnemonic + ' <'+ immData.name + '>');
  if (immData.cdcList <> nil) and (immData.cdcList.Count > 0) then
  begin
    for c := 0 to immData.cdcList.Count - 1 do
      begin
        cdc := immData.cdcList.Strings[c];
        uVimmList.vimmActiveList.Add(immData.ID + U + cdc + '<'+ immData.name + '>');
      end;
  end;
end;

procedure setSKShortActiveLookup(data: TVimm);
begin
  uVimmList.vimmSkinTestList.add(data.ID + U + data.name);
//  if data.acronym <> '' then uVimmList.vimmSkinTestList.add(data.ID + U + data.acronym + ' <'+ data.name + '>');
end;

//build lookup text for the combo box
procedure setImmShortHistoricalLookup(immData: TVimm);
var
c: Integer;
cdc: string;
begin
  uVimmList.vimmHistoricalList.add(immData.ID + U + immData.name);
  if immData.mnemonic <> '' then uVimmList.vimmHistoricalList.add(immData.ID + U + immData.mnemonic + ' <'+ immData.name + '>');
  if (immData.cdcList <> nil) and (immData.cdcList.Count > 0) then
  begin
    for c := 0 to immData.cdcList.Count - 1 do
      begin
        cdc := immData.cdcList.Strings[c];
        uVimmList.vimmHistoricalList.Add(immData.ID + U + cdc + '<'+ immData.name + '>');
      end;
  end;
end;

//return active lookup list to UI
procedure getShortActiveLookup(var dataList: TStringList; isSkinTest, checkPlacements: boolean);
begin
  if not isSkinTest then FastAssign(uVimmList.vimmActiveList, dataList)
  else
    begin
      if checkPlacements and placementsOnFile then getSkinReadingList(dataList)
      else FastAssign(uVimmList.vimmSkinTestList, dataList);
    end;
end;

procedure getSkinReadingList(var dataList: TStringList);
var
i: integer;
tmp: string;
begin
  for I := 0 to uVimmList.skinAdminList.Count - 1 do
    begin
      tmp := uVimmList.skinAdminList.Strings[i];
      dataList.Add(Pieces(tmp, U, 2, 3));
    end;
end;

//return historical lookup list to UI
procedure getShortHistoricalLookup(var immList: TStringList);
begin
  FastAssign(uVimmList.vimmHistoricalList, immList);
end;

procedure getsubSetData(var immList: TStringList; dataType, id: string);
var
aReturn: TStrings;
d, i: integer;
editDataType, item, recordID, recordType, temp: string;
vimmData: TVimm;

begin
  if uVimmInputs.isSkinTest then editDataType := 'ST'
  else editDataType := 'IM';
  aReturn := TStringList.Create;
  try
  if dataType = 'ice' then
    begin
      recordType := Piece(id, ':', 1);
      recordID := Piece(id, ':', 2);
      for i := 0 to uVimmList.vimmList.count - 1 do
        begin
          vimmData := TVimm(uVimmList.vimmList.objects[i]);
          if vimmData.inactive then continue;
          if recordType = 'C' then
            begin
              if recordID <> vimmData.cvxCode then  continue;
              immList.add(vimmdata.id + U + vimmdata.name);
            end
          else if recordType = 'G' then
            begin
              for d := 0 to vimmData.groupList.Count - 1 do
                begin
                  temp := vimmData.groupList.Strings[d];
                  if temp <> recordId then continue;
                  immList.Add(vimmData.ID + U + vimmData.name);
                  break;
                end;
            end;
        end;
      exit;
    end;
  callVistA('ORVIMM GETITEMS', [id, editDataType], aReturn);
  for I := 0 to aReturn.Count - 1 do
    begin
      item := aReturn[i];
      for d := 0 to uVimmList.vimmList.Count - 1 do
        begin
          vimmData := TVimm(uVimmList.vimmList.Objects[d]);
          if vimmData.inactive then continue;
          if vimmData.ID <> item then continue;
          if (editDataType = 'IM') and (not vimmData.hasLot) then continue;

          immList.Add(vimmData.ID + U + vimmData.name);
        end;
    end;
  finally
    FreeAndNil(aReturn);
  end;

end;

procedure getItemHist(var tmpList: TStrings; id: string);
var
editDataType: string;
begin
  if uVimmInputs.isSkinTest then editDataType := 'ST'
  else editDataType := 'IM';
  callVistA('ORVIMM GETHIST', [id, uVimmInputs.patientIEN, editDataType], tmpList);
end;

procedure getBillingCodesList(immunizationList: TStrings; visitIEN: string; var cptLists: TStrings);
begin
  CallVistA('ORVIMM GETCODES', [visitIEN, immunizationList], cptLists);
end;

function placementsOnFile: boolean;
begin
  if uVimmInputs.selectionType = 'historical' then
  begin
    result := false;
    exit;
  end;
  if uVimmList.skinAdminList = nil then
    begin
      uVimmList.skinAdminList := TStringList.Create;
      uVimmInputs.hasPlacements := getSkinPlacementDates;
    end;
  result := uVimmInputs.hasPlacements;
end;

function getSkinPlacementDates(): boolean;
var
aReturn: TStrings;
tmp: string;
idx: integer;
begin
  result := false;
  aReturn := TStringList.Create;
  try
    callVistA('PXVSK V SKIN TEST LIST', [uVimmInputs.patientIEN, '', '', '1'], aReturn);
    for idx := 0 to aReturn.Count - 1 do
      begin
        tmp := aReturn.Strings[idx];
        if Piece(tmp, U, 1) = 'PLACEMENT' then
            begin
              result := true;
              uVimmList.skinAdminList.Add(Pieces(tmp, U, 2, 5));
            end;
      end;
  finally
    FreeAndNil(aReturn);
  end;
end;

function getSkinPlacementInfo(testID: string): string;
var
tmp: string;
idx: integer;
begin
  result := '';
  for idx := 0 to uVimmList.skinAdminList.Count - 1 do
    begin
      tmp := uVimmList.skinAdminList.Strings[idx];
      if Piece(tmp, u, 2) <> testId then continue;
      result := tmp;
    end;
end;

procedure removeSkinPlacementInfo(data: TVimmResult);
var
id,tmp: string;
idx, index: integer;
begin
  if not uVimmInputs.hasPlacements then exit;

  id := '';
  index := -1;
  for idx := 0 to data.defaultDataList.Count - 1 do
    begin
      tmp := data.defaultDataList.Strings[idx];
      if Piece(tmp, U, 1) <> 'READING ID' then continue;
      id := Piece(tmp, U, 2);
      break;
    end;
  for idx := 0 to uVimmList.skinAdminList.Count - 1 do
    begin
      tmp := uVimmList.skinAdminList.Strings[idx];
      if Piece(tmp, U, 1) <> id then continue;
      index := idx;
      break;
    end;
  if index > -1 then uVimmList.skinAdminList.Delete(index);
  if uVimmList.skinAdminList.Count = 0 then uVimmInputs.hasPlacements := false;
end;

procedure checkEncounterInfo;
var
cat: Char;
begin
  if uVimmInputs.encounterCategory <> 'H' then exit;
  cat := GetLocSecondaryVisitCode(uVimmInputs.encounterLocation);
  uVimmInputs.encounterCategory := cat;
  if cat = 'D' then uVimmInputs.dateEncounterDateTime := FMNow;
  uVimmInputs.visitString := IntToStr(uVimmInputs.encounterLocation) + ';' +
    FloatToStr(uVimmInputs.dateEncounterDateTime) + ';' + uVimmInputs.encounterCategory;
end;

procedure getSkinData(skin: string; date: TFMDateTime);
var
tmpList: TStringList;
begin
  tmpList := TStringList.Create;
  try
    callVistA('PXVSK SKIN SHORT LIST', [date], tmpList);
    setSkinDataDetails(tmpList);
  finally
     tmpList.Free;
  end;
end;

procedure setImmDataDetails(tmpList: TStringList);
var
tmp: string;
i,idx,j: integer;
immData: TVimm;
begin
  j := 0;
  idx := -1;
  if uVimmList.vimmList = nil then uVimmList.vimmList := TStringList.Create;
  for i := 0 to tmpList.Count -1 do
    begin
     if i < j then continue;
      tmp := tmpList.Strings[i];
      if Piece(tmp, U, 1) <> 'IMM' then continue;
      idx := uVimmList.vimmList.IndexOf(Piece(tmp, u, 2));
      if idx = -1 then immData := TVimm.Create
      else immData := TVimm(uVimmList.vimmList.Objects[idx]);
      setTopImmData(immData, Pieces(tmp,u,2,99));
      j := i;
      inc(j);
      if j = tmpList.Count then exit;
      while Piece(tmpList.Strings[j], U, 1) <> 'IMM' do
        begin
          tmp := tmpList.Strings[j];
          setSubImmData(immData, tmp);
          if j = tmpList.Count -1 then break;
          inc(j);
        end;
    end;
    immData.complete := true;
    if idx > -1 then uVimmList.vimmList.Objects[idx] := immdata
    else uVimmList.vimmList.addObject(immData.id, immData);
end;

procedure setSkinDataDetails(tmpList: TStringList);
var
tmp: string;
i, idx, j: integer;
data: TVimm;
begin
  j := 0;
  idx := -1;
  if uVimmList.vimmList = nil then uVimmList.vimmList := TStringList.Create;
  for i := 0 to tmpList.Count -1 do
    begin
     if i < j then continue;
      tmp := tmpList.Strings[i];
      if Piece(tmp, U, 1) <> 'SK' then continue;
      idx := uVimmList.vimmList.IndexOf(Piece(tmp, u, 2));
      if idx = -1 then data := TVimm.Create
      else data := TVimm(uVimmList.vimmList.Objects[idx]);
      setTopSkinData(data, Pieces(tmp,u,2,99));
      j := i;
      inc(j);
      if j = tmpList.Count then exit;
      while Piece(tmpList.Strings[j], U, 1) <> 'SK' do
        begin
          tmp := tmpList.Strings[j];
          setSubImmData(data, tmp);
          if j = tmpList.Count -1 then break;
          inc(j);
        end;
    end;
    data.complete := true;
    if idx > -1 then uVimmList.vimmList.Objects[idx] := data
    else uVimmList.vimmList.addObject(data.id, data);
end;

//detail setter probably can be combined with setTopIMMData
procedure setTopImmData(var immData: TVimm; tmp: string);
begin
  immData.ID := Piece(tmp, U, 1);
  immData.name := Piece(tmp,u ,2);
  immData.cvxCode := Piece(tmp,u ,3);
  immData.inactive := Piece(tmp,u ,4) = '0';
  immData.historical := Piece(tmp, u, 5) = 'Y';
  immData.mnemonic := Piece(tmp,u ,6);
  immData.acronym := Piece(tmp,u ,7);
//  immData.maxInSeries := Piece(tmp, U, 8);
  immData.hasLot := Piece(tmp, u, 8) = '1';
end;

procedure setTopSkinData(var data: TVimm; tmp: string);
begin
  data.ID := Piece(tmp, U, 1);
  data.name := Piece(tmp,u ,2);
  data.acronym := Piece(tmp,u ,3);
end;

//detail setters for list of data
procedure setSubImmData(var immData: TVimm; tmp: string);
var
vimmType: string;

begin
   vimmType := Piece(tmp, U, 1);
   if vimmType = '' then exit;
   if vimmType = 'GROUP' then immData.groupList.Add(Piece(tmp, U, 2))
   else if vimmType = 'SYNONYM' then immData.synonymList.Add(Piece(tmp, U, 2))
end;

procedure getReminders(var AReturn: TStrings;  isSkin: boolean);
var
temp: string;
begin
  if isSkin then temp := '1'
  else temp := '0';
  CallVista('ORVIMM VIMMREM', [uVimmInputs.patientIEN, uVimmInputs.userIEN, uVimmInputs.encounterLocation, temp], AReturn);
end;

procedure getReminderMaint(IEN: integer; var aReturn: TStrings);
begin
  CallVistA('ORQQPXRM REMINDER DETAIL', [uVimmInputs.patientIEN, IEN], aReturn)
end;

procedure getICEResults(var aReturn: TStrings);
begin
  CallVistA('PX ICE WEB', [uVimmInputs.patientIEN, 'O', 'O'], aReturn);
end;

//returns the vimm object id for the default values in the immunization pick list
function getVImmIds(immunization: string; isHistorical: boolean): string;
var
idx: integer;
data: TVimm;
id, name: string;

  function findIndexByName(name: string; list: TStringList): string;
   var
   i: integer;
    begin
      result := '';
       for i := 0 to list.Count - 1 do
        begin
          if Piece(list.Strings[i], U, 2) = name then
            begin
              result := Piece(list.Strings[i], U, 1);
              exit;
            end;
        end;
    end;

begin
  result := '';
  id := Piece(immunization, U, 1);
  name := Piece(immunization, U, 2);
  if id = '' then
    begin
      if not isHistorical then id := findIndexByName(name, uVimmList.vimmActiveList)
      else id := findIndexByName(name, uVimmList.vimmHistoricalList);
    end;
  if id = '' then exit;
  idx := uVimmList.vimmList.IndexOf(id);
  if idx = -1 then exit;
  data := TVimm(uVimmList.vimmList.Objects[idx]);
  result := data.ID + U + data.name;
end;

//start the vimm result object when adding data to the grid.
//this will mainly be populated when the VIMM functionality is called with a default value
//like from Clinical Reminder Dialogs in CPRS
function setInitialVimmResult(item, documentType: string): integer;
var
id, name: string;
data: TVimmResult;
begin
  result := -1;
  id := Piece(item, U, 1);
  name := Piece(item, u, 2);
  if (id = '') or (name = '') then exit;
  data := TVimmResult.Create;
  data.id := id;
  data.name := name;
//  if (documentType = '0') and uVimmInputs.isSkinTest and  noReadingOnFileForTest(data) then documentType := '4';
  if documentType = '0' then data.documType := 'Administered'
  else if documentType = '1' then data.documType := 'Historical'
  else if documentType = '2' then data.documType := 'Contraindication'
  else if documentType = '3' then data.documType := 'Refused'
  else if documentType = '4' then data.documType := 'Reading';

  result := setVimmResults(data);
end;

//return the vimm object to populate values in the UI
function getVimmData(data: string): TVimm;
var
 immidx: integer;
 id, name: string;
begin
  result := nil;
  if data = '' then exit;
  name := Piece(data,U, 2);
  id := Piece(data, u, 1);
  immidx := uVimmList.vimmList.IndexOf(ID);
  if immidx = -1 then exit;
  result := TVimm(uVimmList.vimmList.Objects[immidx]);
end;

{ TVimmResult }
function getVimmResultById(idx: integer): TVimmResult;
begin
  result := TVimmResult(uVimmResults.results.Objects[idx]);
end;

function getVimmResultByNameAndType(name, documentType: string): TVimmResult;
var
i: integer;
begin
  Result := nil;
  for i := 0 to uVimmResults.results.Count - 1 do
    begin
      if (TVimmResult(uVimmResults.results.Objects[i]).name = name) and
         (TVimmResult(uVimmResults.results.Objects[i]).documType = documentType) then
          begin
            result := TVimmResult(uVimmResults.results.Objects[i]);
            exit;
          end;
    end;
end;

function getVimmResultIdx(data: TVimmResult): integer;
begin
  result := uVimmResults.results.IndexOfObject(data);
end;

function getVimmResultByUniqueID(uid: string): TVimmResult;
var
i: integer;
begin
//  result := nil;
  for i := 0 to uVimmResults.results.Count - 1 do
  begin
    result := TVimmResult(uVimmResults.results.Objects[i]);
    if result.uniqueID = uid then
      exit;
  end;
  result := nil;
end;


function hasVimmResult(input, documentationType: string): boolean;
var
data: TVimmResult;
i: integer;
vimmData: TVimm;
begin
  result := false;
  if uVimmResults.results = nil then exit;
  vimmData := getVimmData(input);
  if vimmData = nil then exit;
  i := StrToIntDef(Piece(input, U, 1), -1);
  if (i > 0) and (i < uVimmResults.results.Count) and
  (uVimmResults.results.Objects[i] <> nil)  then
    begin
      data := getVimmResultById(StrToIntDef(Piece(input, U, 1), -1));
//      if data <> nil then result := true;
      if (data.id = vimmData.ID) and
      (data.name = vimmData.name) and
      (data.documType = documentationType) then
        begin
          result := true;
          exit;
        end;

    end;
  for i := 0 to uVimmResults.results.Count - 1 do
    begin
      data := TVimmResult(uVimmResults.results.Objects[i]);
      if data = nil then continue;

      if data.id <> vimmData.ID then continue;
      if data.name <> vimmData.name then continue;
      if data.documType <> documentationType then continue;
      result := true;
      exit;
    end;
end;

function hasVimmResultData(input: string): boolean;
var
data: TVimmResult;
id, name, documentationType, uid: string;
begin
  result := false;
  if uVimmResults.results = nil then exit;
  id := Piece(input, U, 1);
  name := Piece(input, U, 2);
  if name = genericImm then exit;

  documentationType := Piece(input, u, 3);
  uid := Piece(input, U, 4);
  if uid <> '' then
    data := getVimmResultByUniqueID(uid)
  else data := getVimmResultById(StrToIntDef(id, -1));
  if data <> nil then result := true;
end;

//add or update an exisiting result in the result list
function setVimmResults(vimmData: TVimmResult): integer;
var
i: integer;
begin
  if uVimmResults.results = nil then uVimmResults.results := TStringList.Create;
  result := -1;
  for i := 0 to uVimmResults.results.Count - 1 do
    begin
        if TVimmResult(uVimmResults.results.Objects[i]).uniqueID <> vimmData.uniqueID then
          continue;
      if TVimmResult(uVimmResults.results.Objects[i]).name <> vimmData.name then
        continue;
      if TVimmResult(uVimmResults.results.Objects[i]).documType <> vimmData.documType then
        continue;
      result := i;
      break;
    end;
  if result > -1 then uVimmResults.results.Objects[result] := vimmData
  else result := uVimmResults.results.AddObject(vimmData.name, vimmData);
end;

//return list of vimm results to the main form to pass on to the calling application
procedure getVimmResultList(var resultList: TStringList);
var
i: integer;
data: TVimmResult;
begin
  if uVimmResults.results = nil then exit;

  for i := 0 to uVimmResults.results.count - 1 do
    begin
      data := getVimmResultById(i);
      resultList.AddObject(data.id + U + data.name + U + '0', data);
    end;
end;

function removeVimmResult(immunization: string): boolean;
var
input, vid: integer;
data: TVimmResult;
uid: string;
begin
  result := false;
  vid := StrToIntDef(Piece(immunization, U, 1), -1);
  if vid < 0 then exit;
  uid := Piece(immunization, U, 4);
  if uid <> '' then data := getVimmResultByUniqueID(uid)
  else data := getVimmResultByNameAndType(Piece(Immunization, U, 2), Piece(immunization, U, 3));
  try
  if data = nil then exit;
  vid := getVimmResultIdx(data);
//  data := getVimmResultById(vid);
  uVimmResults.results.Delete(vid);
  if uVimmInputs.DataList <> nil then
    begin
      input := uVimmInputs.DataList.IndexOfObject(data);
      if input > -1 then uVimmInputs.DataList.Delete(input);
    end;
  result := true;
  finally
  data.Destroy;
  end;
end;


//RPC to check to see if the paitent and immunization has a warning. Called when selecting
//an immunization
function checkForWarning(patient, immunization: string; date: TFMDateTime): string;
var
tempList: TStringList;
i: integer;
begin
  tempList := TStringList.Create;
  result := '';
  try
     CallVistA('PXVIMM VICR EVENTS', [patient, Piece(immunization, U, 1), date, 'W'], tempList);
     if (tempList.Count < 1) or (tempList.Strings[0] = '0') then exit;
     for I := 1 to tempList.Count - 1 do
      begin
         result := result + tempList.Strings[i] + CRLF;
      end;
  finally
     tempList.Free;
  end;
end;

function findVimmResultsByDelimitedStr(str1, str2, str3: string): TVimmResult;
var
i: integer;
data: TVimmResult;
  begin
    result := nil;
    if uVimmResults.results <> nil then
      begin
        for i := 0 to uVimmResults.results.Count - 1 do
          begin
            data := TVimmResult(uVimmResults.results.Objects[i]);
            if data.DelimitedStr <> str1 then continue;
            if data.DelimitedStr2 <> str2 then continue;
            if data.DelimitedStr3 <> str3 then continue;
            result := data;
            exit
          end;
      end
    else
      begin
        data := TVimmResult.Create(str1, str2, str3, true);
        result := data;
      end;
  end;

function useICEForm: boolean;
var
aReturn: string;
begin
  callVistA('ORVIMM USEICE',[],aReturn);
  result := aReturn = '1';
end;

function allComplete: boolean;
var
i: integer;
data: TVimMResult;
begin
  result := true;
  for i := 0 to uVimmResults.results.Count -1 do
    begin
      data := TVimmResult(uVimmResults.results.Objects[i]);
      if data.isComplete = false then
        begin
          result := false;
          exit;
        end;
    end;
end;

//clear result lists;
procedure clearResults;
var
i,input: integer;
data: TVimmResult;
begin
  if uVimmResults.results = nil then exit;
  for i := 0 to uVimmResults.results.count - 1 do
    begin
      data := getVimmResultById(i);
      if data <> nil then
        begin
          if uVimmInputs.DataList <> nil then
            begin
              input := uVimmInputs.DataList.IndexOfObject(data);
              if input > -1 then uVimmInputs.DataList.Delete(input);
            end;
          FreeAndNil(data);
        end;
    end;
    uVimmResults.results.Clear;
    FreeAndNil(uVimmResults.results);
end;

//clear lookup list;
procedure clearLists;
var
  i: integer;
  data: TVimm;
//  route: TVimmRoute;
begin
  if assigned(uVimmList.vimmActiveList) then
    FreeAndNil(uVimmList.vimmActiveList);
  if assigned(uVimmList.vimmHistoricalList) then
    FreeAndNil(uVimmList.vimmHistoricalList);
  if assigned(uVimmList.vimmSkinTestList) then
    FreeAndNil(uVimmList.vimmSkinTestList);
  if assigned(uVimmList.skinAdminList) then
    FreeAndNil(uVimmList.skinAdminList);
  if assigned(uVimmList.vimmList) then
  begin
    for i := 0 to uVimmList.vimmList.Count - 1 do
    begin
      data := TVimm(uVimmList.vimmList.Objects[i]);
      FreeAndNil(data);
    end;
    uVimmList.vimmList.Clear;
    FreeAndNil(uVimmList.vimmList);
//    FreeAndNil(uVimmList);
  end;
end;

procedure clearInputs;
var
data: TVimmResult;
i: integer;
begin

  if assigned(uVimmInputs.DataList) then
    begin
      for i := 0 to uVimmInputs.DataList.Count - 1 do
        begin
          data := TVimmResult(uVimmInputs.DataList.Objects[i]);
          if data <> nil then FreeAndNil(data);
        end;
      uVimmInputs.DataList.Clear;
      FreeAndNil(uVimmInputs.DataList);
    end;
  if assigned(uVimmInputs.NewList) then
    begin
      uVimmInputs.NewList.Clear;
      FreeAndNil(uVimmInputs.NewList);
    end;

  clearLists;
  uVimmInputs.hasPlacements := false;
  uVimmInputs.defaultSeries := '';
  uVimmInputs.coSignerIEN := 0;
  uVimmInputs.noteIEN := '';
  uVimmInputs.fromCover := false;
end;

//build note text for reminders. May be replace with new code that calls VistA
function TVimmResult.getNoteText: Tstrings;
begin
  result := self.noteText;
end;

function TVimmResult.findDefaultValue(name: string): string;
var
i: integer;
begin
  result := '';
  if defaultDataList = nil then exit;
  if defaultDataList.count = 0 then exit;
  for i := 0 to defaultDataList.count - 1 do
    begin
      if Piece(defaultDataList.Strings[i], u, 1) = name then
        begin
          result := Pieces(defaultDataList.Strings[i], U, 2, 3);
          exit;
        end;
    end;
end;

function TVimmResult.isContraindicated: boolean;
begin
  result := false;
  if Piece(DelimitedStr, u, 1) <> 'ICR+' then exit;
  if pos('PXV(920.4',Piece(self.DelimitedStr, u, 2)) > 0 then result := true;
end;

function TVimmResult.isRefused: boolean;
begin
  result := false;
  if Piece(DelimitedStr, u, 1) <> 'ICR+' then exit;
  if pos('PXV(920.5',Piece(self.DelimitedStr, u, 2)) > 0 then result := true;
end;

function TVimmResult.getSeries: string;
var
i: integer;
temp: string;
begin
  result := '';
  if Piece(DelimitedStr, u, 1) <> 'IMM+' then exit;
  for i := 0 to defaultDataList.Count - 1 do
    begin
      temp := defaultDataList[i];
      if Piece(temp , u, 1) <> 'SERIES' then continue;
      result := Piece(temp, u, 3);
    end;
end;

function TVimmResult.getSeriesFromString: string;
var
series: string;
begin
 result := '';
 if POS('IMM', Piece(DelimitedStr, U, 1)) = 0 then
  exit;
 series := Piece(DelimitedStr, U, 5);
 if (series = '') or (series = '@') then
  exit;
 result := getSeriesExternal(series);
end;

function TVimmResult.GetUniqueIDValue: string;
var
  aGUID: TGUID;

begin
  CreateGUID(aGUID);
  Result := GUIDToString(aGUID);
end;

function TVimmResult.getReadingValue: string;
begin
  result := '';
  if Piece(DelimitedStr, u, 1) <> 'SK+' then exit;
  result := Piece(delimitedStr, u, 7);
end;

function TVimmResult.getReadingResult: string;
begin
  result := '';
  if Piece(DelimitedStr, u, 1) <> 'SK+' then exit;
  result := Piece(delimitedStr, u, 5);
end;

//build procedure code string to send data back to PCE
function TVimmResult.procedureDelimitedStr: string;
var
orderBy: string;
begin
   result := '';
//   temp := findDefaultValue('CODES CPT');
   orderBy := findDefaultValue('ORDERING PROVIDER');
   if cptCode = '' then exit;
   result := 'CPT' + '+' + U + Piece(cptCode, u, 1) + U + U + Piece(cptCode, u, 2) + U + '1' + U + Piece(orderBy, U, 1);
end;

procedure TVimmResult.setfromDelimitedStr(input, encType: string);
begin
   id := Piece(input, '~', 2);
   name := Piece(input, '~', 4);
end;

//build diagnosis code string to send data back to PCE
function TVimmResult.diagnosisDelimitedStr: string;
var
  orderBY: string;
begin
  result := '';
  orderBy := findDefaultValue('ORDERING PROVIDER');
  if dxCode = '' then exit;
//  result := 'POV' + '+' + U + Piece(dxCode, u, 1) + U + U + Piece(dxCode, u, 2)  + U + U + Piece(orderBy, U, 1);
  result := 'POV' + '+' + U + Piece(dxCode, u, 1) + U + U + Piece(dxCode, u, 2)  + U + U;
end;

constructor TVimmResult.Create;
begin
  defaultDataList := TStringList.Create;
  uniqueID := GetUniqueIDValue;
end;

function TVimmResult.copy: TVimmResult;
begin
  result := TVimmResult.Create(self.DelimitedStr, self.DelimitedStr2, self.DelimitedStr3, self.uniqueID, false);
  result.outsideLocIEN := self.outsideLocIEN;
  result.outsideLoc := self.outsideLoc;
  result.noteText := TStringList.Create;
  result.defaultDataList := TStringList.Create;
  result.noteText.Assign(self.noteText);
  result.defaultDataList.Assign(self.defaultDataList);
  result.documType := self.documType;
  result.cptCode := self.cptCode;
  result.dxCode := self.dxCode;
end;

constructor TVimmResult.Create(input, str2, str3: string; bldLayout: boolean = true);
var
 finalr, temp: string;
begin
  defaultDataList := TStringList.Create;
  finalr := GetUniqueIDValue;
  if Piece(input, U, 1) = 'ICR+' then
    begin
      temp := Piece(input, u, 5);
      ID := Piece(temp, ';', 1);
      name := Piece(temp, ';', 2);
      DelimitedStr := input;
      DelimitedStr2 := str2;
      DelimitedStr3 := str3;
      temp := Piece(input, U, 2);
      if Pos('920.4', temp) > 0  then  documType := 'Contraindication'
      else documType := 'Refused';
      uniqueID := finalR;
      if bldLayout then buildLayoutFromStrings(self);
      exit;
    end;
  ID := Piece(input, U, 2);
  name := Piece(input, U, 4);
  if Pos('SK',Piece(input, U, 1)) > 0  then
      begin
        isSkin := true;
        if (Piece(input, u, 5) <> '') and (Piece(Input, u, 7) <> '') then documType := 'Reading'
        else documType := 'Administered';
      end
  else
    begin
      isSkin := false;
      if (Piece(input, U, 12) <> '') and (Pos('00', input) = 0) then documType := 'Historical'
      else documType := 'Administered';
    end;
  DelimitedStr := input;
  DelimitedStr2 := str2;
  DelimitedStr3 := str3;
  uniqueID := finalR;
  if bldLayout then buildLayoutFromStrings(self);
end;

constructor TVimmResult.Create(input, str2, str3, unqID: string;
  bldLayout: boolean);
var
 temp: string;
begin
  defaultDataList := TStringList.Create;
  if Piece(input, U, 1) = 'ICR+' then
    begin
      temp := Piece(input, u, 5);
      ID := Piece(temp, ';', 1);
      name := Piece(temp, ';', 2);
      DelimitedStr := input;
      DelimitedStr2 := str2;
      DelimitedStr3 := str3;
      temp := Piece(input, U, 2);
      if Pos('920.4', temp) > 0  then  documType := 'Contraindication'
      else documType := 'Refused';
      uniqueId := unqID;
      if bldLayout then buildLayoutFromStrings(self);
      exit;
    end;
  ID := Piece(input, U, 2);
  name := Piece(input, U, 4);
  if Pos('SK',Piece(input, U, 1)) > 0  then
      begin
        isSkin := true;
        if (Piece(input, u, 5) <> '') and (Piece(Input, u, 7) <> '') then documType := 'Reading'
        else documType := 'Administered';
      end
  else
    begin
      isSkin := false;
      if (Piece(input, U, 12) <> '') and (Pos('00', input) = 0) then documType := 'Historical'
      else documType := 'Administered';
    end;
  DelimitedStr := input;
  DelimitedStr2 := str2;
  DelimitedStr3 := str3;
  uniqueId := unqID;
  if bldLayout then buildLayoutFromStrings(self);

end;

destructor TVimmResult.Destroy;
begin
  if noteText <> nil then FreeAndNil(noteText);
  if defaultDataList <> nil then FreeAndNil(defaultDataList);

  inherited;
end;

//detemine if the required fields has been populated used by the main grid
function TVimmResult.isComplete: boolean;
begin
 result := true;
 if (self.name = '') or (self.documType = '') or ((self.defaultDataList = nil) or
    (self.defaultDataList.Count = 0)) then
    result := false;
end;

//code to create two list an active list and historical list. Can update PCE with both list.
procedure saveData(encDate: TFMDateTime; encLoc, encType, encProv, patient, user: String; var activeList, historicalList, noteList: TStringList);
var
vStr: string;
i: integer;
data: TVimmResult;
begin
  vStr := encLoc + ';' + FloatToStr(encDate) + ';' + encType;
  for i := 0 to uVimmResults.results.Count -1 do
    begin
       data := TVimmResult(uVimmResults.results.Objects[i]);
       if data.documType = 'Historical' then historicalList.AddObject(data.id, data)
       else activeList.AddObject(data.id, data);
       //build note text for autosave
//       if noteList.Count > 0 then noteList.Add('');
       if data.noteText <> nil then noteList.AddStrings(data.noteText);
    end;
end;

function findOutsideLocation(data: TVimmResult): string;
begin
  result := data.findDefaultValue('LOCATION');
  if result = '' then result := '0' + U + ''
  else if Piece(result, u, 1) = '' then setPiece(result, u, 1, '0');
end;

//set the active, refuse, and contraindication array to send to PCE. WIll be for the encounter date sent in from the calling application
procedure buildCurrentPCEList(currList: TStringList; encDate: TFMDateTime; encLoc, encType, encProvider, patient, vstr, noteResult: string; var PCEList: TStringList);
var
addCodes: string;
i,j: integer;
data: TVimmResult;
uPCEEdit: TPCEData;
tempList, codesList: TStrings;
povList, cptList: TStringList;
pceProc: TPCEProc;
pceDiag: TPCEDiag;
visit: integer;
hasPrimaryDiagnosis, setPrimaryDiagnosis: boolean;
tmp: string;
begin
  tempList := TStringList.Create;
  povList := TStringList.Create;
  cptList := TStringList.Create;
  codesList := TStringList.Create;
  uPCEEdit := TPCEData.Create;
  try
    uPCEEdit.location := uVimmInputs.encounterLocation;
    uPCEEdit.VisitCategory := uVimmInputs.encounterCategory;
    uPCEEdit.DateTime := uVimmInputs.dateEncounterDateTime;
    uPCEEdit.PCEForNote(-1);
    uPCEEdit.UseEncounter := true;
    setPrimaryDiagnosis := false;
    if setPrimaryDiagnosisByLocation then
      begin
        hasPrimaryDiagnosis := false;
        for i := 0 to uPCEEdit.Diagnoses.Count - 1 do
          begin
            if TPCEDiag(uPCEEdit.Diagnoses[i]).Primary then
              begin
                hasPrimaryDiagnosis := true;
                break;
              end;
          end;
        if not hasPrimaryDiagnosis then
          setPrimaryDiagnosis := true;
      end;
    uPCEEdit.NoteIEN := StrToIntDef(Piece(noteResult, u, 1), 0);
    uPceEdit.NoteDateTime := StrToFloat(Piece(noteResult, u, 3));
    if not CheckDailyHospitalization(uPCEEdit) then
      infoBox('Problem linking secondary visit to note', 'Error', MB_OK);
    visit := StrToIntDef(GetVisitIEN(uPCEEdit.NoteIEN), 0);
    if visit > 0 then uPCEEdit.VisitIEN := visit;
//    getBillingCodes(encDate);
    for i := 0 to currList.Count -1 do
      begin
        data := TVimmResult(currList.Objects[i]);
        tempList.Add('IMM' + U + data.id + U + U + data.name + U);
        if Pos('IMM', Piece(data.DelimitedStr, U, 1)) > 0 then
          begin
            codesList.Add(data.DelimitedStr);
//            inc(immCnt);
          end;
        uPCEEdit.SetImmunizations(tempList, false, data);
        if data.diagnosisDelimitedStr <> '' then
          begin
            pceDiag := TPCEDiag.Create;
            try
              tmp := data.diagnosisDelimitedStr;
              if setPrimaryDiagnosis then
                SetPiece(tmp, U, pnumDiagPrimary, '1');
              pceDiag.SetFromString(tmp);
              codesList.Add(tmp);
              povList.AddObject(tmp, pceDiag);
            finally
//              FreeAndNil(pceDiag);
            end;
          end;
        if data.procedureDelimitedStr <> '' then
          begin
            pceProc := TPCEProc.Create;
            try
              pceProc.SetFromString(data.procedureDelimitedStr);
              codesList.Add(data.procedureDelimitedStr);
              cptList.AddObject(data.procedureDelimitedStr, pceProc);
            finally
//              FreeAndNil(pceProc);
            end;

          end;
      end;
    if (codesList <> nil) and (codesList.Count > 0) then
      begin
        tempList.Clear;
        try
          getBillIngCodesList(codesList, IntToStr(uPCEEdit.VisitIEN), tempList);
          for j := 0 to tempList.Count - 1 do
            begin
              addCodes := tempList[j];
              if pos('CPT', Piece(addCodes, U, 1)) > 0 then
                begin
                  pceProc := TPCEProc.Create;
                  if StrToIntDef(encProvider, 0) = 0 then
                    setPiece(addCodes, U, 6, encProvider);
                  pceProc.SetFromString(addCodes);
                  cptList.AddObject(addCodes, pceProc);
                end
              else if pos('POV', Piece(addCodes, U, 1)) > 0 then
                begin
                  pceDiag := TPCEDiag.Create;
                  if setPrimaryDiagnosis then
                    SetPiece(addCodes, U, pnumDiagPrimary, '1');
                  pceDiag.SetFromString(addCodes);
                  povList.AddObject(addCodes, pceDiag);
                end;
            end;
        finally
        end;
      end;
      uPCEEdit.SetDiagnoses(povList, false);
      uPCEEdit.SetProcedures(cptList, false);
      uPCEEdit.Save;
  finally
//     FreeAndNil(pceDiag);
//     FreeAndNil(pceProc);
    FreeAndNil(uPCEEdit);
    FreeAndNil(codesList);
    FreeAndNil(tempList);
    KillObj(@povList, True);
    KillObj(@cptList, True);
  end;
end;
//build historical inputs for historical data. Can call PCE multiple times
procedure saveHistoricalData(histList: TStringList; encProvider, patient, noteIEN, visitIEN: string);
var
FileDate, visitDate: string;
i: integer;
data: TVimmResult;
uPCEEdit: TPCEData;
tempList: TStrings;
begin
  uPCEEdit := nil;
  tempList := TStringList.Create;
  uPCEEdit := TPCEData.Create;
  try
    while histList.Count > 0 do
      begin
        FileDate := '';
        tempList.Clear;
        for i := histlist.Count - 1 downto 0 do
          begin
            data := TVimmResult(histList.Objects[i]);
            visitDate := data.findDefaultValue('VISIT DATE TIME');
            if FileDate = '' then FileDate := Piece(visitDate, u, 1);
            if FileDate <> Piece(visitDate, u, 1) then continue
            else
              begin
                uPCEEdit.HistoricalLocation := findOutsideLocation(data);;
                uPCEEdit.VisitCategory := 'E';
                uPCEEdit.DateTime := StrToFloat(Piece(visitDate, u, 1));
                uPCEEdit.Parent := visitIEN;
              end;
            tempList.Add('IMM' + U + data.id + U + U + data.name + U);
            uPCEEdit.SetImmunizations(tempList, false, data);
            histList.Delete(i);
          end;
        if tempList.Count > 0 then
          begin
            uPCEEdit.Save;
            uPCEEdit.Clear;
            tempList.Clear;
          end;
      end;
  finally
     FreeAndNil(uPCEEdit);
     FreeAndNil(tempList);
     FreeAndNil(uPCEEdit);
  end;
end;

function checkForNoteTitle: string;
var
aReturn, tmpName: string;
tmpIEN: Int64;
begin
  CallVistA('ORVIMM CHKTITLE',[uvimmInputs.userIEN, uvimmInputs.encounterProviderIEN, uvimmInputs.dateEncounterDateTime],aReturn);
  if Piece(aReturn, U, 1) = '-1' then result := Piece(aReturn, U, 2)
  else if Piece(aReturn, u, 1) = '0' then
    begin
      result := '0';
      uVimmInputs.noteIEN := Piece(aReturn, U, 2);
      DefaultCosigner(tmpIEN, tmpName);
      if tmpIEN > 0 then
        begin
          uVimmInputs.coSignerIEN := tmpIEN;
          result := '';
        end;
    end
  else if Piece(aReturn, u, 1) = '1' then
    begin
      uVimmInputs.noteIEN := Piece(aReturn, U, 2);
      uVimmInputs.coSignerIEN := StrToIntDef(Piece(aReturn, U, 3), -1);
      result := '';
    end
  else begin
    uVimmInputs.noteIEN := aReturn;
    result := '';
  end;
end;

//RPC to create a note. Only used from the coversheet in CPRS or if the calling applicaiton is not CPRS
function saveNoteText(noteList: TStrings; encDate: TFMDateTime; encLoc, encType, vstr, patient, user, cosigner: string): string;
var
aReturn: string;
begin
    CallVistA('ORVIMM MAKENOTE', [noteList, FloatToStr(encDate), encLoc, encType, vstr, patient, user, cosigner], aReturn);
    Result := aReturn;
end;


procedure buildVISString(dataStr, intVal: string; visCompleteList, visList: TStrings);
var
visItems: TStringList;
i,v: integer;
visData: string;
visI, visTMP: string;
begin
  visItems := TStringList.Create;
  try
    PiecestoList(intVal, ';', visItems);
    for i := 0 to visItems.Count - 1 do
      begin
        visI := visItems.Strings[i];
        for v := 0 to visCompleteList.Count - 1 do
        begin
           visData := visCompleteList.Strings[v];
           if Piece(visData, U, 1) <> visI then continue;
           visTmp := Piece(visData, U, 2) + ';' + Piece(visData, u, 3) + ';' + Piece(visData, u, 5);
           visList.add('VIS OFFERED' + U + visI + U + visTMP);
        end;
     end;
  finally
    FreeAndNil(visItems);
  end;
end;

procedure buildLotString(dataStr, intVal: string; lotCompleteList, lotList: TStrings);
var
i: integer;
lotInfo: String;
begin
  lotInfo := '';
   for I := 0 to lotCompleteList.Count - 1 do
    begin
      if Piece(lotCompleteList.Strings[i], u, 1) = intVal then
        begin
          lotInfo := lotCompleteList.Strings[i];
          break;
        end;
    end;
  if lotInfo <> '' then lotList.Add('LOT NUMBER' + U + lotInfo);
end;

procedure showNoActiveImmMsg(name: string);
var
aReturn: String;
begin
  CallVistA('ORVIMM GETCTINF', [IntToStr(uVimmInputs.encounterLocation)], aReturn);
  showMessage(name + ' - No inventory or lot numbers of this vaccine are recorded in CPRS as being available for administration at this site.' +
              CRLF + aReturn);
end;

function setPrimaryDiagnosisByLocation: boolean;
var
aReturn: string;
begin
  callVistA('ORVIMM PLOC', [IntToStr(uVimmInputs.encounterLocation)], aReturn);
  if aReturn = '1' then
    result := true
  else result := false;
end;

{ TVimm }

constructor TVimm.Create;
begin
  groupList := TStringList.Create;
  synonymList := TStringList.Create;
end;

destructor TVimm.Destroy;
begin
  FreeAndNil(groupList);
  FreeAndNil(synonymList);
  FreeAndNil(cdcList);
  inherited;
end;

procedure buildLayoutFromStrings(data: TVimmResult);
var
tempList: TStrings;
control,encounterType: string;

begin
  if data.defaultDataList <> nil then data.defaultDataList.Clear
  else data.defaultDataList := TStringList.Create;
  tempList := TStringList.Create;
  try
    if data.isSkin then
      begin
        control := 'SKIN TEST';
        if data.documType = 'Administered' then encounterType := '0'
        else if data.documType = 'Historical' then encounterType := '2'
        else if data.documType = 'Reading' then encounterType := '1';
      end
    else
      begin
        control := 'IMMUNIZATION';
        if data.documType = 'Administered' then encounterType := '0'
        else if data.documType = 'Historical' then encounterType := '1'
        else if data.documType = 'Contraindication' then encounterType := '2'
        else if data.documType = 'Refused' then encounterType := '3';
      end;
      tempList.Add(data.DelimitedStr);
      tempList.Add(data.DelimitedStr2);
      tempList.Add(data.DelimitedStr3);
     CallVistA('ORFEDT BLDLAYOT',[tempList, encounterType, control], data.defaultDataList);
  finally
    FreeAndNil(tempList);
  end;
end;

{ TVimmLayoutControls }


initialization

finalization
  clearLists;

end.
