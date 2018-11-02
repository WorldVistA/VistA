unit uGMV_VitalTypes;

interface

type
  TVitalType = (
    vtUnknown,
    vtTemp,
    vtPulse,
    vtResp,
    vtBP,
    vtHeight,
    vtWeight,
    vtPain,
    vtPO2,
    vtCVP,
    vtCircum);

  TGMV_ImageIndex = (
    iiFolderOpen,
    iiFolderClosed,
    iiTemplate,
    iiDefaultTemplate,
    iiSave,
    iiDelete,
    iiVital,
    iiAbnormal);


function VitalTypeByString(aType:String): TVitalType;
function VitalTypeByABBR(aType:String): TVitalType;
function ErrorAbbByString(aCode:String):String;
function VitalAbbByString(aType:String): String;

var
  GMVVitalTypeIEN: array[TVItalType] of string = ('-1', '2', '5', '3', '1', '8', '9', '22', '21', '19', '20');
  GMVVitalHiRange: array[TVitalType] of Double;
  GMVVitalLoRange: array[TVitalType] of Double;
  GMVVitalTypeAbbv: array[TVItalType] of string = ('xx', 'T', 'P', 'R', 'BP', 'HT', 'WT', 'PN', 'PO2', 'CVP', 'CG');


implementation

function VitalTypeByABBR(aType:String): TVitalType;
begin
  if      aType = GMVVitalTypeAbbv[vtTemp] then result := vtTemp
  else if aType = GMVVitalTypeAbbv[vtPulse] then result := vtPulse
  else if aType = GMVVitalTypeAbbv[vtResp] then result := vtResp
  else if aType = GMVVitalTypeAbbv[vtBP] then result := vtBP
  else if aType = GMVVitalTypeAbbv[vtHeight] then result := vtHeight
  else if aType = GMVVitalTypeAbbv[vtWeight] then result := vtWeight
  else if aType = GMVVitalTypeAbbv[vtPain] then result := vtPain
  else if aType = GMVVitalTypeAbbv[vtPO2] then result := vtPO2
  else if aType = GMVVitalTypeAbbv[vtCVP] then result := vtCVP
  else if aType = GMVVitalTypeAbbv[vtCircum] then result := vtCircum

//  else if aType = 'BMI' then result := vtBMI // zzzzzzandria 060913 BMI

  else result := vtUnknown;
end;

function VitalTypeByString(aType:String): TVitalType;
begin
  if      aType = GMVVitalTypeIEN[vtTemp] then result := vtTemp
  else if aType = GMVVitalTypeIEN[vtPulse] then result := vtPulse
  else if aType = GMVVitalTypeIEN[vtResp] then result := vtResp
  else if aType = GMVVitalTypeIEN[vtBP] then result := vtBP
  else if aType = GMVVitalTypeIEN[vtHeight] then result := vtHeight
  else if aType = GMVVitalTypeIEN[vtWeight] then result := vtWeight
  else if aType = GMVVitalTypeIEN[vtPain] then result := vtPain
  else if aType = GMVVitalTypeIEN[vtPO2] then result := vtPO2
  else if aType = GMVVitalTypeIEN[vtCVP] then result := vtCVP
  else if aType = GMVVitalTypeIEN[vtCircum] then result := vtCircum
  else result := vtUnknown;
end;

function VitalAbbByString(aType:String): String;
begin
  if      aType = GMVVitalTypeIEN[vtTemp] then result := 'T'
  else if aType = GMVVitalTypeIEN[vtPulse] then result := 'P'
  else if aType = GMVVitalTypeIEN[vtResp] then result := 'R'
  else if aType = GMVVitalTypeIEN[vtBP] then result := 'BP'
  else if aType = GMVVitalTypeIEN[vtHeight] then result := 'HT'
  else if aType = GMVVitalTypeIEN[vtWeight] then result := 'WT'
  else if aType = GMVVitalTypeIEN[vtPain] then result := 'PN'
  else if aType = GMVVitalTypeIEN[vtPO2] then result := 'PO2'
  else if aType = GMVVitalTypeIEN[vtCVP] then result := 'CVP'
  else if aType = GMVVitalTypeIEN[vtCircum] then result := 'CG'
  else result := 'Unk';
end;

function ErrorAbbByString(aCode:String):String;
begin
  if aCode = '1' then result := 'Date/Time'
  else if aCode = '2' then result := 'Reading'
  else if aCode = '3' then result := 'Patient'
  else if aCode = '4' then result := 'Record'
  else
    result := '';
end;

initialization
begin
    {GMVVitalHiRange[Vital] all values are US Standard}
    GMVVitalHiRange[vtUnknown] := 0;
    GMVVitalHiRange[vtTemp] := 120;
    GMVVitalHiRange[vtPulse] := 300;
    GMVVitalHiRange[vtResp] := 100;
    GMVVitalHiRange[vtBP] := 300;
    GMVVitalHiRange[vtHeight] := 100;//AAN 07/03/2002 was 300
    GMVVitalHiRange[vtWeight] := 1500;//AAN 07/03/2002 was 500
    GMVVitalHiRange[vtPain] := 10;
    GMVVitalHiRange[vtPO2] := 100;
    GMVVitalHiRange[vtCVP] := 136;//AAN 07/03/2002
    GMVVitalHiRange[vtCircum] := 200;//AAN 07/03/2002 was 300;

    GMVVitalLoRange[vtUnknown] := 0;
    GMVVitalLoRange[vtTemp] := 45;
    GMVVitalLoRange[vtPulse] := 0;
    GMVVitalLoRange[vtResp] := 0;
    GMVVitalLoRange[vtBP] := 0;
    GMVVitalLoRange[vtHeight] := 10; // zzzzzzandria 050321. was 0. See Remedy HD0000000068371
    GMVVitalLoRange[vtWeight] := 0;
    GMVVitalLoRange[vtPain] := 0;
    GMVVitalLoRange[vtPO2] := 0;
    GMVVitalLoRange[vtCVP] := -13.6;//AAN 07/03/2002    was -10;
    GMVVitalLoRange[vtCircum] := 1;// zzzzzzandria 050706 was 0

  end;
end.
 