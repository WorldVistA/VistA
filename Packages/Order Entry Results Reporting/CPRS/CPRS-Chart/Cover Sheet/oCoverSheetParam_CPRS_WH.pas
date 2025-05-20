unit oCoverSheetParam_CPRS_WH;

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
  iCoverSheetIntf,
  uCore;

type
  TCoverSheetParam_CPRS_WH = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  end;

implementation

uses
  Winapi.Windows,
  VaUtils,
  mCoverSheetDisplayPanel_CPRS_WH;

{ TCoverSheetParam_CPRS_WH }

function TCoverSheetParam_CPRS_WH.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_WH.Create(aOwner);
end;

end.
