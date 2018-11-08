unit fGMV_DeviceSelector;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/02/09 9:47a $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Form for selecting a kernel device in applications
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER/fGMV_DeviceSelector.pas $
*
* $History: fGMV_DeviceSelector.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 3:12p
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:40p
 * Created in $/Vitals/VITALS-5-0-18/APP-VitalsManager
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:30p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/APP-VitalsManager
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 4:56p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsManager-503
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:21p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSMANAGER-503
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:06p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/Common
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 10/29/03   Time: 4:14p
 * Created in $/Vitals503/Common
 * Version 5.0.3
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 7/18/02    Time: 5:57p
 * Updated in $/Vitals GUI Version 5.0/Common
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 7/12/02    Time: 5:01p
 * Updated in $/Vitals GUI Version 5.0/Common
 * GUI Version T28
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/05/02    Time: 3:49p
 * Updated in $/Vitals GUI Version 5.0/Common
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 5/15/02    Time: 12:12p
 * Created in $/Vitals GUI Version 5.0/Common
 * Initial check-in
 *
 *
*
================================================================================
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  uGMV_Common,
  Dialogs,
  StdCtrls,
  ComCtrls,
  mGMV_Lookup, ExtCtrls
  , mGMV_PrinterSelector
  ,uGMV_Const
  ;

type
  TfrmGMV_DeviceSelector = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    dtpTime: TDateTimePicker;
    dtpDate: TDateTimePicker;
    fraPrinterSelector: TfrGMV_PrinterSelector;
    Panel3: TPanel;
    gbQueue: TGroupBox;
    gbSelected: TGroupBox;
    edDevice: TEdit;
    edTime: TEdit;
    Panel4: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure dtpTimeChange(Sender: TObject);
    procedure dtpDateChange(Sender: TObject);
    procedure fraPrinterSelectorExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gbQueueEnter(Sender: TObject);
    procedure gbQueueExit(Sender: TObject);
    procedure gbSelectedEnter(Sender: TObject);
    procedure gbSelectedExit(Sender: TObject);
  private
    fDeviceString: string;
    fQueueDateTime: Double;
    CurrentTime: TDateTime;

    procedure CM_UpdateSelection(var Message: TMessage); message CM_UPDATELOOKUP;
    procedure updateDateTime;
  public
    { Public declarations }

  end;

  TFMDateTime = Double;

function GetKernelDevice(var DeviceString: string; var QueueDateTime: TFMDateTime): Boolean;

implementation

uses uGMV_User, uGMV_Engine;

{$R *.DFM}

function GetKernelDevice(var DeviceString: string; var QueueDateTime: TFMDateTime): Boolean;
var
  sID, sName: String;
begin
  with TfrmGMV_DeviceSelector.Create(Application) do
    try
      sID := GMVUser.Setting[usLastVistAPrinter];
      sName := getFileField('3.5','.01',sID);
      if sName = '' then
          fraPrinterSelector.ClearSelection
      else
        begin
          fraPrinterSelector.DeviceIEN := sID;
          fraPrinterSelector.DeviceName := sName;
          fraPrinterSelector.edTarget.Text := sName;
//          fraPrinterSelector.lblDevice.Caption := sName;
          fraPrinterSelector.edTarget.selStart := 1;
          fraPrinterSelector.edTarget.selLength := Length(sName);
          edDevice.Text := sName;
        end;
      btnOK.Enabled := sID <> '';

      Result := (ShowModal = mrOK);
      if Result then
        begin
          DeviceString := fDeviceString;
          QueueDateTime := fQueueDateTime;
        end;
    finally
      free;
    end;
end;

procedure TfrmGMV_DeviceSelector.FormCreate(Sender: TObject);
begin
  CurrentTime := Now;
  dtpDate.DateTime := CurrentTime;
  dtpDate.MinDate := trunc(CurrentTime);
  dtpTime.DateTime := CurrentTime;
end;

procedure TfrmGMV_DeviceSelector.btnOKClick(Sender: TObject);
begin
  GMVUser.Setting[usLastVistaPrinter] := fraPrinterSelector.DeviceIEN;// fraDevice.IEN;
  fDeviceString := fraPrinterSelector.DeviceName;// fraDevice.edtValue.Text;
  fQueueDateTime := WindowsDateTimeToFMDateTime(trunc(dtpDate.Date) + (dtpTime.Time - trunc(dtpTime.Date)));
  ModalResult := mrOK;
end;

procedure TfrmGMV_DeviceSelector.dtpTimeChange(Sender: TObject);
begin
  if trunc(dtpDate.Date) + frac(dtpTime.Time) < CurrentTime then
    dtpTime.DateTime := CurrentTime;
  UpdateDateTime;
end;

procedure TfrmGMV_DeviceSelector.dtpDateChange(Sender: TObject);
begin
  try
    if dtpDate.DateTime < CurrentTime then
      dtpDate.DateTime := CurrentTime;
  except
  end;
  UpdateDateTime;
end;

procedure TfrmGMV_DeviceSelector.CM_UpdateSelection(var Message: TMessage);
begin
  btnOK.Enabled := (fraPrinterSelector.DeviceIEN <> '');
  btnOK.Default := btnOk.Enabled;

  edDevice.Text := fraPrinterSelector.DeviceName;
  UpdateDateTime;
end;

procedure TfrmGMV_DeviceSelector.fraPrinterSelectorExit(
  Sender: TObject);
begin
  btnOK.Enabled := (fraPrinterSelector.DeviceIEN <> '');
  btnOK.Default := btnOk.Enabled;
end;

procedure TfrmGMV_DeviceSelector.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if Key = VK_ESCAPE then ModalResult := mrCancel;
end;

procedure TfrmGMV_DeviceSelector.updateDateTime;
begin
  edTime.Text := FormatDateTime('mm/dd/yyyy',dtpDate.Date)+ ' '+
                 FormatDateTime('hh:mm:ss',dtpTime.Time);
end;

procedure TfrmGMV_DeviceSelector.gbQueueEnter(Sender: TObject);
begin
  gbQueue.Font.Style := [fsBold];
  dtpDate.Font.Style := [];
  dtpTime.Font.Style := [];
end;

procedure TfrmGMV_DeviceSelector.gbQueueExit(Sender: TObject);
begin
    gbQueue.Font.Style := [];
end;

procedure TfrmGMV_DeviceSelector.gbSelectedEnter(Sender: TObject);
begin
  gbSelected.Font.Style := [fsBold];
  edDevice.FOnt.Style := [];
  edTime.FOnt.Style := [];
end;

procedure TfrmGMV_DeviceSelector.gbSelectedExit(Sender: TObject);
begin
  gbSelected.Font.Style := [];
end;

end.

