unit oCoverSheetParam_CPRS_Allergies;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from base. This parameter is used to override
  *                     the NewCoverSheetControl method.
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
  TCoverSheetParam_CPRS_Allergies = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
  end;

implementation

uses
  mCoverSheetDisplayPanel_CPRS_Allergies;

{ TCoverSheetParam_CPRS_Allergies }

function TCoverSheetParam_CPRS_Allergies.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_Allergies.Create(aOwner);
end;

end.
