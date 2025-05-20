unit oCoverSheetParam_CPRS_Reminders;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TCoverSheetParam_CPRS. Special functions
  *                     for the CLinical Reminders display
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  oCoverSheetParam_CPRS,
  iCoverSheetIntf;

type
  TCoverSheetParam_CPRS_Reminders = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function getDetailRPC: string; override;
    function getInvert: boolean; override;
    function getMainRPC: string; override;

    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    { Public declarations }
  end;

implementation

uses
  mCoverSheetDisplayPanel_CPRS_Reminders,
  uReminders,
  uCore;

{ TCoverSheetParam_CPRS_Reminders }

function TCoverSheetParam_CPRS_Reminders.getDetailRPC: string;
begin
  Result := 'ORQQPX REMINDER DETAIL';
end;

function TCoverSheetParam_CPRS_Reminders.getInvert: boolean;
begin
  Result := False;
end;

function TCoverSheetParam_CPRS_Reminders.getMainRPC: string;
begin
  if InteractiveRemindersActive then
    begin
      Result := 'ORQQPXRM REMINDERS APPLICABLE';
      setParam1(IntToStr(encounter.location));
    end
  else
    begin
      Result := 'ORQQPX REMINDERS LIST';
      setParam1('');
    end;

end;

function TCoverSheetParam_CPRS_Reminders.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_Reminders.Create(aOwner);
end;

end.
