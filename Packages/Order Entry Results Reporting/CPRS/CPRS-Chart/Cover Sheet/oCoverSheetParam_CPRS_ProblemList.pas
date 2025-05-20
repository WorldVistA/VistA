unit oCoverSheetParam_CPRS_ProblemList;

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
  TCoverSheetParam_CPRS_ProblemList = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
  end;

implementation

uses
  mCoverSheetDisplayPanel_CPRS_ProblemList;

{ TCoverSheetParam_CPRS_ProblemList }

function TCoverSheetParam_CPRS_ProblemList.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_ProblemList.Create(aOwner);
end;

end.
