unit oCoverSheetParam_WidgetClock;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Proof of concept for multiple types of panels.
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
  oCoverSheetParam,
  iCoverSheetIntf;

type
  TCoverSheetParam_WidgetClock = class(TCoverSheetParam, ICoverSheetParam)
  protected
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    constructor Create(aInitStr: string = '');
  end;

implementation

uses
  oDelimitedString,
  mCoverSheetDisplayPanel_WidgetClock;

{ TCoverSheetParam_WidgetClock }

constructor TCoverSheetParam_WidgetClock.Create(aInitStr: string = '');
begin
  inherited Create;
  with NewDelimitedString(aInitStr) do
    try
      setTitle(GetPieceAsString(2, 'Clock'));
    finally
      Free;
    end;
end;

function TCoverSheetParam_WidgetClock.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_WidgetClock.Create(aOwner);
end;

end.
