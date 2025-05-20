unit mCoverSheetDisplayPanel;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TfraGridPanelFrame. This display panel
  *                     provides the minimum functionality for displaying anything
  *                     in the CPRS CoverSheet.
  *
  *       Notes:        This frame is an ancestor object and heavily inherited from.
  *                     ABSOLUTELY NO CHANGES SHOULD BE MADE WITHOUT FIRST
  *                     CONFERRING WITH THE CPRS DEVELOPMENT TEAM ABOUT POSSIBLE
  *                     RAMIFICATIONS WITH DESCENDANT FRAMES.
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ImgList,
  Vcl.Menus,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  iGridPanelIntf,
  iCoverSheetIntf,
  mGridPanelFrame;

type
  TfraCoverSheetDisplayPanel = class(TfraGridPanelFrame, ICoverSheetDisplayPanel, ICPRS508)
  private
    fParam: ICoverSheetParam;
  protected
    { Protected declarations }

    function getParam: ICoverSheetParam; virtual;
    procedure setParam(const aValue: ICoverSheetParam); virtual;
    function getIsFinishedLoading: boolean; virtual;

    { Introduced events }
    procedure OnClearPtData(Sender: TObject); virtual;
    procedure OnBeginUpdate(Sender: TObject); virtual;
    procedure OnEndUpdate(Sender: TObject); virtual;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fraCoverSheetDisplayPanel: TfraCoverSheetDisplayPanel;

implementation

{$R *.dfm}

{ TfraCoverSheetDisplayPanel }

constructor TfraCoverSheetDisplayPanel.Create(aOwner: TComponent);
begin
  inherited;
end;

destructor TfraCoverSheetDisplayPanel.Destroy;
begin
  inherited;
end;

procedure TfraCoverSheetDisplayPanel.OnBeginUpdate(Sender: TObject);
begin
  //
end;

procedure TfraCoverSheetDisplayPanel.OnClearPtData(Sender: TObject);
begin
  //
end;

procedure TfraCoverSheetDisplayPanel.OnEndUpdate(Sender: TObject);
begin
  //
end;

function TfraCoverSheetDisplayPanel.getIsFinishedLoading: boolean;
begin
  Result := True;
end;

function TfraCoverSheetDisplayPanel.getParam: ICoverSheetParam;
begin
  Supports(fParam, ICoverSheetParam, Result);
end;

procedure TfraCoverSheetDisplayPanel.setParam(const aValue: ICoverSheetParam);
begin
  Supports(aValue, ICoverSheetParam, fParam);
end;

end.
