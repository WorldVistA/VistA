unit oCoverSheetParam_CPRS_Appts;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TCoverSheetParam_CPRS. Special functions
  *                     for the appointment/visit/admission display
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  Vcl.Controls,
  oCoverSheetParam_CPRS,
  iCoverSheetIntf;

type
  TCoverSheetParam_CPRS_Appts = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    { Public declarations }
  end;

implementation

uses
  mCoverSheetDisplayPanel_CPRS_Appts;

{ TCoverSheetParam_CPRS_Appts }

function TCoverSheetParam_CPRS_Appts.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_Appts.Create(aOwner);
end;

end.
