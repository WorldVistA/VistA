unit oCoverSheetParam_Web;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TCoverSheetParam this parameter holds
  *                     custom items for displaying CPRS data in the CoverSheet.
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
  TCoverSheetParam_Web = class(TCoverSheetParam, ICoverSheetParam_Web)
  private
    { Private declarations }
    fHomePage: string;
    fShowNavigator: boolean;

    function getHomePage: string;
    function getShowNavigator: boolean;

    procedure setHomePage(const aValue: string);
    procedure setShowNavigator(const aValue: boolean);
  protected
    { Protected declarations }
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    { Public declarations }
    constructor Create(aInitStr: string = '');
  end;

implementation

uses
  mCoverSheetDisplayPanel_Web,
  oDelimitedString;

{ TCoverSheetParam_Web }

constructor TCoverSheetParam_Web.Create(aInitStr: string = '');
begin
  inherited Create;
  with NewDelimitedString(aInitStr) do
    try
      setTitle(GetPieceAsString(2, 'Mini-Browser'));
      fHomePage := GetPieceAsString(3, 'http://www.google.com');
      fShowNavigator := GetPieceAsBoolean(4, False);
    finally
      Free;
    end;
end;

function TCoverSheetParam_Web.getHomePage: string;
begin
  Result := fHomePage;
end;

function TCoverSheetParam_Web.getShowNavigator: boolean;
begin
  Result := fShowNavigator;
end;

procedure TCoverSheetParam_Web.setHomePage(const aValue: string);
begin
  fHomePage := aValue;
end;

procedure TCoverSheetParam_Web.setShowNavigator(const aValue: boolean);
begin
  fShowNavigator := aValue;
end;

function TCoverSheetParam_Web.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_Web.Create(aOwner);
end;

end.
