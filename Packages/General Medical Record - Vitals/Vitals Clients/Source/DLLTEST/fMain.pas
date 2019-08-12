unit fMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    dlgGetDLLName: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


type
  TGMV_CallVitalsDLL = function(aParams: PWideChar): integer; stdcall;

procedure TForm1.Button1Click(Sender: TObject);
var
  aDLLName: string;
  aParams: string;
  aDLLHandle: NativeUInt;
  aDLLFuncAddr: TGMV_CallVitalsDLL;
const
  aDLLFuncName = 'GMV_VitalsViewDLG';
begin
  if dlgGetDLLName.Execute then
    aDLLName := dlgGetDLLName.Filename
  else
    Exit;

  aDLLHandle := LoadLibrary(PWideChar(aDLLName));
  if aDLLHandle = 0 then
    begin
      ShowMessageFmt('Cannot load DLL: %s', [aDLLName]);
      Exit;
    end;

  @aDLLFuncAddr := GetProcAddress(aDLLHandle, PAnsiChar(aDLLFuncName));
  if not Assigned(aDLLFuncAddr) then
    begin
      ShowMessageFmt('Cannot find function: %s', [aDLLFuncName]);
      Exit;
    end;

  try
    aParams := 'server=127.0.0.1;port=9210';

  finally
    aDLLFuncAddr := nil;
    FreeLibrary(aDLLHandle);
    aDLLHandle := 0;
  end;
end;

(*
  procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnUpdateVitals(Sender: TObject);
  var
  aFunctionAddr: TGMV_VitalsViewForm;
  aFunctionName: AnsiString;
  aRtnRec: TDllRtnRec;
  aStartDate: string;
  begin
  { Availble Forms:
  GMV_FName :='GMV_VitalsEnterDLG';
  GMV_FName :='GMV_VitalsEnterForm';
  GMV_FName :='GMV_VitalsViewForm';
  GMV_FName :='GMV_VitalsViewDLG';
  }
  try
  aFunctionName := 'GMV_VitalsViewDLG';
  aRtnRec := LoadVitalsDLL;

  case aRtnRec.Return_Type of
  DLL_Success:
  try
  @aFunctionAddr := GetProcAddress(VitalsDLLHandle, PAnsiChar(aFunctionName));
  if Assigned(aFunctionAddr) then
  begin
  if Patient.Inpatient then
  aStartDate := FormatDateTime('mm/dd/yy', Now - 7)
  else
  aStartDate := FormatDateTime('mm/dd/yy', IncMonth(Now, -6));

  aFunctionAddr(RPCBrokerV, Patient.DFN, IntToStr(Encounter.Location), aStartDate, FormatDateTime('mm/dd/yy', Now), GMV_APP_SIGNATURE, GMV_CONTEXT, GMV_CONTEXT, Patient.Name, Format('%s    %d', [Patient.SSN, Patient.Age]), Encounter.LocationName + U);
  end
  else
  MessageDLG('Can''t find function "GMV_VitalsViewDLG".', mtError, [mbok], 0);
  except
  on E: Exception do
  MessageDLG('Error running Vitals Lite: ' + E.Message, mtError, [mbok], 0);
  end;
  DLL_Missing:
  begin
  TaskMessageDlg('File Missing or Invalid', aRtnRec.Return_Message, mtError, [mbok], 0);
  end;
  DLL_VersionErr:
  begin
  TaskMessageDlg('Incorrect Version Found', aRtnRec.Return_Message, mtError, [mbok], 0);
  end;
  end;
  finally
  @aFunctionAddr := nil;
  UnloadVitalsDLL;
  end;

  CoverSheet.OnRefreshPanel(Self, CV_CPRS_VITL);
  CoverSheet.OnRefreshPanel(Self, CV_CPRS_RMND);
  end;
*)

end.
