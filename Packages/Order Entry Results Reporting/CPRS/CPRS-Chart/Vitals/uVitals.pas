unit uVitals;
{ Old class TVital currently not used - commented out at bottom of unit }

interface

uses
  SysUtils, Dialogs, Controls, Windows, Classes, ORClasses, ORCtrls, ORFn, Forms,
  TRPCB, rMisc, WinAPI.Messages, uCore, uPCE;

const
  NoVitalOverrideValue = '^None^';

type
  TVitalType = (vtUnknown, vtTemp, vtPulse, vtResp, vtBP, vtHeight, vtWeight, vtPain,
                vtPO2, vtCVP, vtCircum);
  TValidVitalTypes = vtTemp..vtCircum;

procedure InitPainCombo(cboPain: TORComboBox);
procedure ConvertVital(VType: TVitalType; var VValue, VUnit: string);
function GetVitalStr(VType: TVitalType; rte, unt, UserStr, DateStr: string): string;
function GetVitalUser: string;
procedure AssignVitals2List(List: TStrings; ADateTime: TFMDateTime;
                       ALocation, ABP, ATemp, ATempUnits,
                       AResp, APulse, AHeight, AHeightUnits,
                       AWeight, AWeightUnits, APain: string);
function VitalInvalid(VitalControl: TControl; UnitsControl: TControl = nil;
                      OverrideValue: string = NoVitalOverrideValue): boolean;
function VitalControlTag(VType: TVitalType; UnitControl: boolean = FALSE): integer;
function ConvertHeight2Inches(Ht: string): string;
function FormatVitalForNote(VitalStr: string):String;
function FormatVitalForNoteNoConv(VitalStr: string):String;
function ConvertVitalData(const Value: string; VitalType: TVitalType; UnitType: string = ''): string;
procedure VitalsFrameCreated(Frame: TFrame);
function ValidVitalsDate(var ADate: TFMDateTime; SkipFirst: boolean = FALSE; Show: boolean = true): boolean;
function IsNumericWeight(const x: string): Boolean;

Procedure ViewPatientVitals(aBroker: TRPCBroker; aPatient: TPatient; aEncounter: TEncounter; aVitalsAbbv: string; out ChangesMade: Boolean);
function EnterPatientVitals(aBroker: TRPCBroker; aPatient: TPatient; aPCEData: TPCEData; Info: String): Boolean;
function LatestVitalsList(aBroker: TRPCBroker; aPatient: TPatient; aDelim: string; bSilent: boolean; var OutList: TStringList): Boolean;

const
  VitalPCECodes: array[TValidVitalTypes] of string =
                                        { vtTemp      } ('TMP',
                                        { vtPulse     }  'PU',
                                        { vtResp      }  'RS',
                                        { vtBP        }  'BP',
                                        { vtHeight    }  'HT',
                                        { vtWeight    }  'WT',
                                        { vtPain      }  'PN',
                                        { vtPO2       }  'PO2',
                                        { vtCVP       }  'CVP',
                                        { vtCircum    }  'CG');


  VitalCodes: array[TValidVitalTypes] of string =
                                        { vtTemp      } ('T',
                                        { vtPulse     }  'P',
                                        { vtResp      }  'R',
                                        { vtBP        }  'BP',
                                        { vtHeight    }  'HT',
                                        { vtWeight    }  'WT',
                                        { vtPain      }  'PN',
                                        { vtPO2       }  'PO2',
                                        { vtCVP       }  'CVP',
                                        { vtCircum    }  'CG');

  TAG_VITTEMP    = 2;
  TAG_VITPULSE   = 4;
  TAG_VITRESP    = 3;
  TAG_VITBP      = 1;
  TAG_VITHEIGHT  = 5;
  TAG_VITWEIGHT  = 6;
  TAG_VITTEMPUNIT= 7;
  TAG_VITHTUNIT  = 8;
  TAG_VITWTUNIT  = 9;
  TAG_VITPAIN    = 10;
  TAG_VITDATE    = 11;

  VitalDateStr     = 'VST^DT^';
  VitalPatientStr  = 'VST^PT^';
  VitalLocationStr = 'VST^HL^';

  GMV_CONTEXT = 'OR CPRS GUI CHART';
  GMV_APP_SIGNATURE = 'CPRS';
  GMV_DEFAULT_TEMPLATE = '';

type
  VitalTags = TAG_VITBP..TAG_VITPAIN;

  TGMV_VitalsEnterForm = function(
         RPCBrokerV: TRPCBroker;
        aPatient, aLocation, aTemplate,aSignature:string;
        aDateTime:TDateTime): TCustomForm; stdcall;

  TGMV_VitalsEnterDLG = function(
         RPCBrokerV: TRPCBroker;
        aDFN, aLocation, aTemplate,aSignature:string;
        aDateTime:TDateTime;
        aName,anInfo:string): Integer; stdcall;

  TGFM_VitalsViewDLG = function(
         RPCBrokerV: TRPCBroker;
        aDFN, aLocation,
        DateStart, DateStop,
        aSignature,
        aContextIn,aContextOut,
        aName,anInfo,aHospitalName:string): Integer; stdcall;

  TGMV_VitalsViewForm = function(
         RPCBrokerV: TRPCBroker;
        aDFN, aLocation,
        DateStart, DateStop,
        aSignature,
        aContextIn,aContextOut,
        aName,anInfo,
        aDynamicParameter {HospitalName^Vital Type Abbreviation} :string): TCustomForm; stdcall;

  TGMV_LatestVitalsList = function (
         RPCBrokerV: TRPCBroker;
        aDFN,
        aDelim:string;
        bSilent:Boolean
        ): TStringList; stdcall;

  TGMV_VitalsExit = Procedure;


  //New brokerless calls
  TGMV_ViewPatientVitals = function(const aConnectParams: wideString;
    aDFN, ALocation, DateStart, DateStop, aSignature, aName, anInfo,
    aHospitalName: String): Boolean; stdcall;

  TGMV_EnterPatientVitals = function(const aConnectParams: wideString;
    aDFN, ALocation, aTemplate, aSignature: string; ADateTime: TDateTime;
    aName, anInfo: string): Boolean; stdcall;

  TGMV_GetLatestVitalsList = function(const aConnectParams: wideString;
  aDFN, aDelim: string; bSilent: boolean; var OutList: TStringList)
  : boolean; stdcall;
var
  VitalsDLLHandle : THandle = 0;

const
  VitalsDLLName = 'GMV_VitalsViewEnter.dll';

Function LoadVitalsDLL(): TDllRtnRec;
procedure UnloadVitalsDLL;

const
  VitalTagSet = [TAG_VITBP..TAG_VITPAIN];
  VitalDateTagSet = [TAG_VITBP..TAG_VITDATE];

  VitalTagCodes: array[VitalTags] of TVitalType =
                            { TAG_VITBP         } (vtBP,
                            { TAG_VITTEMP       }  vtTemp,
                            { TAG_VITRESP       }  vtResp,
                            { TAG_VITPULSE      }  vtPulse,
                            { TAG_VITHEIGHT     }  vtHeight,
                            { TAG_VITWEIGHT     }  vtWeight,
                            { TAG_VITTEMPUNIT   }  vtTemp,
                            { TAG_VITHTUNIT     }  vtHeight,
                            { TAG_VITWTUNIT     }  vtWeight,
                            { TAG_VITPAIN       }  vtPain);

  VitalDesc: array[TVitalType] of string =
                                  { vtUnknown   } ('Unknown',
                                  { vtTemp      }  'Temperature',
                                  { vtPulse     }  'Pulse',
                                  { vtResp      }  'Respiration',
                                  { vtBP        }  'Blood Pressure',
                                  { vtHeight    }  'Height',
                                  { vtWeight    }  'Weight',
                                  { vtPain      }  'Pain Score',
                                  { vtPO2       }  'Pulse Oximetry',
                                  { vtCVP       }  'Central Venous Pressure',
                                  { vtCircum    }  'Circumference/Girth');

  VitalFormatedDesc: array[TValidVitalTypes] of string =
                                  { vtTemp      } ('Temperature ',
                                  { vtPulse     }  'Pulse       ',
                                  { vtResp      }  'Resp        ',
                                  { vtBP        }  'Blood Press. ',
                                  { vtHeight    }  'Height      ',
                                  { vtWeight    }  'Weight      ',
                                  { vtPain      }  'Pain Scale. ',
                                  { vtPO2       }  'Pulse Ox.   ',
                                  { vtCVP       }  'Cnt Vns Pres ',
                                  { vtCircum    }  'Circum/Girth ');
  vnumType  = 2;
  vnumValue = 3;
  vnumDate  = 4;
  // vnumPrimary and vnumSecondary only apply to vtTemp, vtHeight, vtWeight
  vnumPrimary = 5;
  vnumSecondary = 6;

implementation

uses
  rCore, rVitals, Contnrs, fVitalsDate, VAUtils, System.UITypes;

var
  uVitalFrames: TComponentList = nil;

procedure CloseVitalsDLL(Handle: THandle);
var
  VitalsExit : TGMV_VitalsExit;
begin
  if Handle <> 0 then
  begin
    @VitalsExit := GetProcAddress(Handle,PChar('GMV_VitalsExit'));
    if assigned(VitalsExit) then
      VitalsExit();
  end;
end;

function VitalErrorText(VType: TVitalType): string;
begin
  case VType of
    vtTemp, vtHeight, vtWeight:
      Result := '- check rate and unit.';
    else
      Result := 'reading entered.';
  end;
  Result := 'Invalid ' + VitalDesc[VType] + ' ' + Result;
end;

procedure InitPainCombo(cboPain: TORComboBox);
begin
  cboPain.Items.Clear;
  cboPain.Items.Add('0^  - no pain');
  cboPain.Items.Add('1^  - slightly uncomfortable');
  cboPain.Items.Add('2^');
  cboPain.Items.Add('3^');
  cboPain.Items.Add('4^');
  cboPain.Items.Add('5^');
  cboPain.Items.Add('6^');
  cboPain.Items.Add('7^');
  cboPain.Items.Add('8^');
  cboPain.Items.Add('9^');
  cboPain.Items.Add('10^  - worst imaginable');
  cboPain.Items.Add('99^ - unable to respond');
end;

procedure ConvertVital(VType: TVitalType; var VValue, VUnit: string);
begin
  case VType of
    vtTemp:     if(VUnit = 'C') then  //if metric, convert to standard
                begin
                  if StrToFloat(VValue) > 0 then
                    //VValue := FloatToStr(StrToFloat(VValue) * 9.0 / 5.0 +32.0);
                    VValue := FloatToStr(Round((StrToFloat(VValue) * 9.0 / 5.0 +32.0)*100)/100);
                  VUnit := 'F';
                end;

    vtHeight:   if VUnit = 'CM' then
                begin
                  if StrToFloat(VValue) > 0 then
                    //VValue := FloatToStr(StrtoFloat(VValue) / 2.54);
                    VValue := FloatToStr(Round((StrtoFloat(VValue) / 2.54)*1000)/1000);
                  VUnit := 'IN';
                end;

    vtWeight:   if VUnit = 'KG' then
                begin
                  if StrToFloat(VValue) > 0 then
                    //VValue := FloatToStr(StrtoFloat(VValue) * 2.2046);
                    //
                    // the vitals package uses 2.2 (not 2.2046), so the GUI needs to use the
                    // same so conversions back & forth don't lead to errors
                    // this probably shouldn't even be done here - it should be done by the
                    // vitals package - KCM
                    //
                    VValue := FloatToStr(Round(StrtoFloat(VValue) * 2.2{046} *1000)/1000);
                  VUnit := 'LB';
                end;
  end;
end;

function GetVitalStr(VType: TVitalType; rte, unt, UserStr, DateStr: string): string;
begin
  Result := '';
  ConvertVital(VType, rte, unt);
  if rte <> '' then
  begin
    if(VType = vtPain) then unt := U;
    Result := 'VIT'+U+VitalPCECodes[VType]+U+U+U+rte+U+UserStr+U+unt+U+DateStr;
  end;
end;

function GetVitalUser: string;
var
  UserID: Int64;

begin
  UserID := Encounter.Provider;
  if UserID <= 0 then
    UserID := User.DUZ;
  Result := IntToStr(UserID);
end;

procedure AssignVitals2List(List: TStrings; ADateTime: TFMDateTime;
                       ALocation, ABP, ATemp, ATempUnits,
                       AResp, APulse, AHeight, AHeightUnits,
                       AWeight, AWeightUnits, APain: string);
var
  UserStr, DateStr: string;

  procedure AddVital(VType: TVitalType; ARte: string; AUnit: string = '');
  var
    VStr: string;

  begin
    VStr := GetVitalStr(VType, ARte, AUnit, UserStr, DateStr);
    if(VStr <> '') then
      List.Add(VStr);
  end;

begin
  with List do
  begin
    UserStr := GetVitalUser;
    DateStr := FloatToStr(ADateTime);
    clear;

    Add(VitalDateStr     + DateStr);
    Add(VitalPatientStr  + Patient.DFN);       // encounter Patient  //*DFN*
    Add(VitalLocationStr + ALocation);
    AddVital(vtBP,     ABP);                   // Blood Pressure
    AddVital(vtTemp,   ATemp, ATempUnits);     // Temperature
    AddVital(vtResp,   AResp);                 // Resp
    AddVital(vtPulse,  APulse);                // Pulse
    AddVital(vtHeight, AHeight, AHeightUnits); // Height
    AddVital(vtWeight, AWeight, AWeightUnits); // Weight
    AddVital(vtPain,   APain);                 // Pain
  end;
end;

function VitalInvalid(VitalControl: TControl; UnitsControl: TControl = nil;
                       OverrideValue: string = NoVitalOverrideValue): boolean;
var
  rte, unt: string;
  Tag: integer;
  VType: TVitalType;

  procedure TrimControl(Ctrl: TControl);
  begin
    TORExposedControl(Ctrl).Text := trim(TORExposedControl(Ctrl).Text);
  end;

begin
  Tag := -1;

  if(OverrideValue = NoVitalOverrideValue) then
  begin
    if(assigned(VitalControl)) then
    begin
      TrimControl(VitalControl);
      rte := TORExposedControl(VitalControl).Text;
      Tag := VitalControl.Tag;
    end
    else
      rte := '';
  end
  else
  begin
    rte := OverrideValue;
    if(assigned(VitalControl)) then
      Tag := VitalControl.Tag;
  end;

  if(assigned(UnitsControl)) then
  begin
    TrimControl(UnitsControl);
    unt := TORExposedControl(UnitsControl).Text;
    if(Tag < 0) then
      Tag := UnitsControl.Tag;
  end
  else
    unt := '';

  if(Tag >= low(VitalTags)) and (Tag <= high(VitalTags)) then
    VType := VitalTagCodes[Tag]
  else
    VType := vtUnknown;
 //pain does not need to be validated because the combo box limits the selection.
  if(VType = vtPain) then
    Result := FALSE
  else
  begin
    Result := TRUE;
    if(VType <> vtUnknown) then
    begin
      if (rte = '') then
        Result := FALSE
      else
      if (VerifyVital(VitalPCECodes[VType],rte,unt) = True) then
        Result := FALSE;
    end;
  end;
  //  GRE 2/12/03 added to disallow user entering "lb" with weight NOIS MWV-0103-22037
  if VType = vtWeight then
  begin
     if (IsNumericWeight(rte) = FALSE) then
         Result := True;
  end;
  if(Result) then
    ShowMsg(VitalErrorText(VType));
end;

function VitalControlTag(VType: TVitalType; UnitControl: boolean = FALSE): integer;
var
  i,cnt: integer;

begin
  if UnitControl then
    cnt := 0
  else
    cnt := 1;
  Result := -1;
  for i := low(VitalTags) to high(VitalTags) do
  begin
    if(VitalTagCodes[i] = VType) then
    begin
      inc(cnt);
      if(cnt = 2) then
      begin
        Result := i;
        break;
      end;
    end;
  end;
end;

function ConvertHeight2Inches(Ht: string): string;
var
 c: char;
 i: integer; //counter
 inchstr,feetstr : string;
 feet: boolean;
 v: double;

begin
  feet := False;
  result := '';
  feetstr := '';
  inchstr := '';

  // check for feet
  for i := 1 to (length(Ht)) do
  begin
    c := Ht[i];
    if (c = '''') then feet := True;
  end;

  if (feet = True) then
  begin
    i := 1;
    while (Ht[i] <> '''') do
    begin
      if CharInSet(Ht[i], ['0'..'9']) or (Ht[i] = '.') then
        feetstr := feetstr + Ht[i];
      inc(i);
    end;
    while (i <= length(Ht)) and (Ht[i] <> '"') and
     (Ht[i] <> '') do
      begin
      if CharInSet(Ht[i], ['0'..'9']) or (Ht[i] = '.') then
        inchstr := inchstr + Ht[i];
        inc(i);
      end;
    v := 0;
    if (feetstr <> '') then
      v := v + (StrTofloat(feetstr)*12);
    if(inchstr <> '') then
      v := v + StrToFloat(inchstr);
    result := floatToStr(v);
    //add here to convert to CM if CM is the unit

  end
  else //no feet
  begin
    for i := 1 to (length(Ht)) do
    begin
      c := Ht[i]; //first character
      if CharInSet(c, ['0'..'9']) or (c = '.') then
        result := result + c;
      if (c = '"') then break;
    end;
  end;
end;

{
1215^T^98.6^2991108.11^98.6 F^(37.0 C)
1217^P^70^2991108.11^70
1216^R^18^2991108.11^18
1214^BP^120/70^2991108.11^120/70
1218^HT^70^2991108.11^70 in^(177.8 cm)
1219^WT^200^2991108.11^200 lb^(90.0 kg)
1220^PN^1^2991108.11^1
}
  //format string as it should appear on the PCE panel.
function FormatVitalForNote(VitalStr: string):String;
var
  Code, Value: string;
  v: TVitalType;

begin
  Result := '';
  Code := UpperCase(Piece(VitalStr, U, vnumType));
  for v := low(TValidVitalTypes) to high(TValidVitalTypes) do
  begin
    if(Code = VitalCodes[v]) then
    begin
      Value := ConvertVitalData(Piece(VitalStr, U, vnumValue), v);
      if(v = vtPain) and (Value = '99') then
        Value := 'Unable to respond.';
      Result := VitalFormatedDesc[v] + Value + '    ' +
      FormatFmDateTime('mmm dd,yyyy hh:nn',(StrToFloat(Piece(VitalStr, U, vnumDate))));
    end
  end;
end;

function FormatVitalForNoteNoConv(VitalStr: string):String;
var
  Code, Value: string;
  v: TVitalType;
begin
  Result := '';
  Code := UpperCase(Piece(VitalStr, U, vnumType));
  for v := low(TValidVitalTypes) to high(TValidVitalTypes) do
  begin
    if(Code = VitalCodes[v]) then
    begin
      if v in [vtTemp, vtHeight, vtWeight] then
      begin
        Value := Piece(VitalStr, U, vnumPrimary) + ' ' +
          Piece(VitalStr, U, vnumSecondary);
      end
      else
      begin
        Value := Piece(VitalStr, U, vnumValue);
        if(v = vtPain) and (Value = '99') then
          Value := 'Unable to respond.';
      end;
      Result := VitalFormatedDesc[v] + Value + '    ' +
      FormatFmDateTime('mmm dd,yyyy hh:nn',(StrToFloat(Piece(VitalStr, U, vnumDate))));
    end
  end;
end;

function ConvertVitalData(const Value: string; VitalType: TVitalType; UnitType: string = ''): string;
var
  dbl: Double;

begin
  Result := Value;
  if(VitalType in [vtTemp, vtHeight, vtWeight]) then
  begin
    try
      dbl := StrToFloat(Value);
    except
      on EConvertError do
        dbl := 0
      else
        raise;
    end;
    if(dbl <> 0) then
    begin
      UnitType := UpperCase(UnitType);
      case VitalType of
        vtTemp:
          begin
            if(UnitType = 'C') then
            begin
              dbl := dbl * (9/5);
              dbl := dbl + 32;
              dbl := round(dbl * 10) / 10;
              Result := FloatToStr(dbl) + ' F (' + Result + ' C)';
            end
            else
            begin
              dbl := dbl - 32;
              dbl := dbl * (5/9);
              dbl := round(dbl * 10) / 10;
              Result := Result + ' F (' + FloatToStr(dbl) + ' C)';
            end;
          end;

        vtHeight:
          begin
            if(UnitType = 'CM') then
            begin
              dbl := dbl / 2.54;
              dbl := round(dbl * 10) / 10;
              Result := FloatToStr(dbl) + ' in [' + Result + ' cm)';
            end
            else
            begin
              dbl := dbl * 2.54;
              dbl := round(dbl * 10) / 10;
              Result := Result + ' in [' + FloatToStr(dbl) + ' cm)';
            end;
          end;

        vtWeight:
          begin
            if(UnitType = 'KG') then
            begin
              dbl := dbl * 2.2;
              dbl := round(dbl * 10) / 10;
              Result := FloatToStr(dbl) + ' lb (' + Result + ' kg)';
            end
            else
            begin
              dbl := dbl / 2.2;
              dbl := round(dbl * 10) / 10;
              Result := Result + ' lb (' + FloatToStr(dbl) + ' kg)';
            end;
          end;
      end;
    end;
  end;
end;

procedure VitalsFrameCreated(Frame: TFrame);
begin
  if not assigned(uVitalFrames) then
    uVitalFrames := TComponentList.Create(FALSE);
  uVitalFrames.Add(Frame);
end;

function ValidVitalsDate(var ADate: TFMDateTime; SkipFirst: boolean = FALSE; Show: boolean = true): boolean;   //AGP Change 26.1
var
  frmVitalsDate: TfrmVitalsDate;
  ok: boolean;

begin
  Result := TRUE;
  while (Result and (SkipFirst or (ADate > FMNow))) do
  begin
    if(SkipFirst) then
    begin
      ok := TRUE;
      SkipFirst := FALSE;
    end
    else
    ok := (InfoBox('Vital sign Date/Time entered (' + FormatFMDateTime('mmm dd yyyy hh:nn', ADate) +
            ') cannot be in the future.' + CRLF +
            'If you do not change the entered date/time vitals information will be lost.' + CRLF +
            'Do you want to enter a new Date/Time?',
            'Invalid Vital Entry Date/Time',
            MB_YESNO + MB_ICONWARNING) = ID_YES);
    if ok then
    begin
      frmVitalsDate := TfrmVitalsDate.Create(Application);
      try
        frmVitalsDate.dteVitals.FMDateTime := ADate;
        frmVitalsDate.btnNow.Visible := Show; //AGP Change 26.1
        if frmVitalsDate.ShowModal = mrOK then
          ADate := frmVitalsDate.dteVitals.FMDateTime;
      finally
        frmVitalsDate.Free;
      end;
    end
    else
      Result := FALSE;
  end;
end;

function IsNumericWeight(const x: string): Boolean;
var
    i: Integer;
begin
  Result := True;
  for i := 1 to Length(x) do if not CharInSet(x[i], ['0'..'9','.']) then Result := False;
end;

function LoadVitalsDLL(): TDllRtnRec;
// If error then set VitalsDLLHandle to -1 and show error
begin
  if VitalsDLLHandle = 0 then
  begin
   Result := LoadDll(VitalsDLLName, CloseVitalsDLL);
   VitalsDLLHandle := Result.DLL_HWND;
  end;
end;

procedure UnloadVitalsDLL;
begin
  if VitalsDLLHandle <> 0 then
  begin
    FreeLibrary(VitalsDLLHandle);
    VitalsDLLHandle := 0;
  end;
end;

Procedure ViewPatientVitals(aBroker: TRPCBroker; aPatient: TPatient;
  aEncounter: TEncounter; aVitalsAbbv: string; out ChangesMade: boolean);
var
  aFunctionAddr: TGMV_ViewPatientVitals;
  aFunctionName: AnsiString;
  aRtnRec: TDllRtnRec;
  aStartDate: string;
  aConnectionParams: string;
begin
  aFunctionName := 'GMV_ViewPatientVitals';
  ChangesMade := FALSE;
  aRtnRec := LoadVitalsDLL;
  try
    case aRtnRec.Return_Type of
      DLL_Success:
        try
          @aFunctionAddr := GetProcAddress(VitalsDLLHandle,
            PAnsiChar(aFunctionName));
          if assigned(aFunctionAddr) then
          begin
            if Patient.Inpatient then
              aStartDate := FormatDateTime('mm/dd/yy', Now - 7)
            else
              aStartDate := FormatDateTime('mm/dd/yy', IncMonth(Now, -6));

            aConnectionParams := GMV_CONTEXT + '^' + TRPCB.GetAppHandle(aBroker)
              + '^' + aBroker.Server + '^' + IntToStr(aBroker.ListenerPort) +
              '^' + Piece(aBroker.User.Division, U, 3);

            ChangesMade := aFunctionAddr(aConnectionParams, aPatient.DFN,
              IntToStr(aEncounter.Location), aStartDate,
              FormatDateTime('mm/dd/yy', Now), GMV_APP_SIGNATURE, aPatient.Name,
              Format('%s    %d', [aPatient.SSN, aPatient.Age]),
              aEncounter.LocationName + U + aVitalsAbbv);

          end
          else
            MessageDLG('Can''t find function "GMV_ViewPatientVitals".', mtError,
              [mbok], 0);
        except
          on E: Exception do
            MessageDLG('Error running Vitals Lite: ' + E.Message, mtError,
              [mbok], 0);
        end;
      DLL_Missing:
        begin
          TaskMessageDlg('File Missing or Invalid', aRtnRec.Return_Message,
            mtError, [mbok], 0);
        end;
      DLL_VersionErr:
        begin
          TaskMessageDlg('Incorrect Version Found', aRtnRec.Return_Message,
            mtError, [mbok], 0);
        end;
    end;
  finally
    UnloadVitalsDLL;
  end;
end;

function EnterPatientVitals(aBroker: TRPCBroker; aPatient: TPatient;
  aPCEData: TPCEData; Info: String): boolean;
var
  VLPtVitals: TGMV_EnterPatientVitals;
  aConnectionParams: String;
  GMV_Fname: AnsiString;
begin
  Result := FALSE;
  if VitalsDLLHandle = 0 then
    Exit; // The DLL was initialized on Create, but just in case....
  GMV_Fname := 'GMV_EnterPatientVitals';

  @VLPtVitals := GetProcAddress(VitalsDLLHandle, PAnsiChar(GMV_Fname));
  if assigned(VLPtVitals) then
  begin

    aConnectionParams := GMV_CONTEXT + '^' + TRPCB.GetAppHandle(aBroker) + '^' +
      aBroker.Server + '^' + IntToStr(aBroker.ListenerPort) + '^' +
      Piece(aBroker.User.Division, U, 3);

    Result := VLPtVitals(aConnectionParams, aPatient.DFN,
      IntToStr(aPCEData.Location), GMV_DEFAULT_TEMPLATE, GMV_APP_SIGNATURE,
      FMDateTimeToDateTime(aPCEData.DateTime), aPatient.Name, Info);
  end
  else
    MessageDLG('Unable to find function "' + string(GMV_Fname) + '".', mtError,
      [mbok], 0);
end;

Function LatestVitalsList(aBroker: TRPCBroker; aPatient: TPatient;
  aDelim: string; bSilent: boolean; var OutList: TStringList): boolean;
var
  VLPtVitals: TGMV_GetLatestVitalsList;
  aConnectionParams: String;
  GMV_Fname: AnsiString;
begin
  Result := FALSE;
  if VitalsDLLHandle = 0 then
    Exit; // The DLL was initialized on Create, but just in case....
  GMV_Fname := 'GMV_GetLatestVitalsList';
  @VLPtVitals := GetProcAddress(VitalsDLLHandle, PAnsiChar(GMV_Fname));
  if assigned(VLPtVitals) then
  begin
    aConnectionParams := GMV_CONTEXT + '^' + TRPCB.GetAppHandle(aBroker) + '^' +
      aBroker.Server + '^' + IntToStr(aBroker.ListenerPort) + '^' +
      Piece(aBroker.User.Division, U, 3) + '^';

    Result := VLPtVitals(aConnectionParams, aPatient.DFN, aDelim,
      bSilent, OutList);

  end
  else
    MessageDLG('Can''t find function "' + string(GMV_Fname) + '".', mtError,
      [mbok], 0);
end;

(* Old class currently not used
{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses SysUtils, Classes;

type
  TVital = class(TObject)
  {class for vital}
  Private
    Fsend:   Boolean;  //do we need this?
  public
    Typ:      String;      //type
    Value:    Single;
    Unt:      String;      //unit
    Provider: Integer;
    procedure Assign(Src: TVital);  //will we need assign?
    procedure Clear;
    procedure SetFromString(const x: string);
    function DelimitedStr: string;
  end;


implementation

uses ORFn, fPCEEdit, uPCE;

Procedure TVital.Assign(Src: TVital);
{assigns the values from one vital to another}
begin
  Fsend    := Src.Fsend;
  Typ      := Src.Typ;
  Value    := Src.Value;
  Unt      := Src.Unt;
  provider := Src.Provider;
end;

procedure Tvital.Clear;
{clear all fields}
begin
  Fsend := False;
  Typ   := '';
  Value := 0.0;
  Unt   := '';  //will default to Inches/LBs/Farenheit on M side,
                //depending on the Type
  //Provider := UProvider;
end;

Procedure TVital.SetFromString(const X: string);
begin
  Typ      := Piece(x, U, 2);
  Value    := StrToFloat(Piece(x, U, 5));
  Provider := StrToInt(Piece(x, U, 6));
  Unt      := Piece(x, U, 7);
end;

function TVital.DelimitedStr: string;
begin
  Result := 'VIT' + U + Typ + U + U + U + FloatToStr(Value) + U +
    IntToStr(Provider) + U + Unt;
end;
*)

initialization

finalization
  KillObj(@uVitalFrames);

end.
