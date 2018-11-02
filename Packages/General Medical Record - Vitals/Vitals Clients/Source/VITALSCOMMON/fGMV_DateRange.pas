unit fGMV_DateRange;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 12/20/07 12:43p $
*       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Selects two date ranges.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON/fGMV_DateRange.pas $
*
* $History: fGMV_DateRange.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/VitalsCommon
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 2/10/04    Time: 2:56p
 * Created in $/VitalsLite/VitalsDLL
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:08p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsUser
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 8/30/02    Time: 4:06p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Labor Day Backup
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzpetitd Date: 6/20/02    Time: 9:32a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * t27 Build
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:13a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Roll-up to 5.0.0.27
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 11:53a
 * Created in $/Vitals GUI Version 5.0/Vitals User
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
  Dialogs,
  StdCtrls,
  ComCtrls,
  ExtCtrls;

type
  TfrmGMV_DateRange = class(TForm)
    Panel1: TPanel;
    Panel5: TPanel;
    GroupBox1: TGroupBox;
    lblFrom: TLabel;
    lblTo: TLabel;
    dtpFrom: TDateTimePicker;
    dtpTo: TDateTimePicker;
    Panel2: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtpFromEnter(Sender: TObject);
    procedure dtpFromExit(Sender: TObject);
    procedure dtpToExit(Sender: TObject);
    procedure dtpToEnter(Sender: TObject);
  private
  public
    { Public declarations }
  end;

  function GetDateRange(var FromDate, ToDate: TDateTime; AllowFutureDate: Boolean = True; AllowPastDate: Boolean = True): Boolean;

implementation

uses uGMV_Common, System.UITypes;


{$R *.DFM}

function GetDateRange(var FromDate, ToDate: TDateTime; AllowFutureDate: Boolean = True; AllowPastDate: Boolean = True): Boolean;
begin
  with TfrmGMV_DateRange.Create(Application) do
    try
      dtpFrom.DateTime := FromDate;
      dtpTo.DateTime := ToDate;
      dtpFrom.MaxDate := TRunc(Now);
      dtpTo.MaxDate := dtpFrom.MaxDate;
      activeControl := dtpFrom;
      ShowModal;
      if ModalResult = mrOK then
        begin
          FromDate := dtpFrom.Date;
          ToDate := dtpTo.Date;
          Result := True;
        end
      else
        Result := False;
    finally
      free;
    end;
end;

procedure TfrmGMV_DateRange.btnOKClick(Sender: TObject);
begin
  if trunc(dtpFrom.DateTime) <= trunc(dtpTo.DateTime) then
    ModalResult := mrOk
  else
    MessageDlg('The ''Start with Date'' must be less' + #13 +
    'than the ''Go to Date'' value.',
      mtInformation, [mbok], 0);
end;

procedure TfrmGMV_DateRange.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmGMV_DateRange.dtpFromEnter(Sender: TObject);
begin
  dtpFrom.Color := clTabIn;
end;

procedure TfrmGMV_DateRange.dtpFromExit(Sender: TObject);
begin
  dtpFrom.Color := clTabOut;
end;

procedure TfrmGMV_DateRange.dtpToExit(Sender: TObject);
begin
  dtpTo.Color := clTabOut;
end;

procedure TfrmGMV_DateRange.dtpToEnter(Sender: TObject);
begin
  dtpTo.Color := clTabIn;
end;

end.

