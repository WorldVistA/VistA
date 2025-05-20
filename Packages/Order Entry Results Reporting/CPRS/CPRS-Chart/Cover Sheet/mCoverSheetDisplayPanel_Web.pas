unit mCoverSheetDisplayPanel_Web;
{
  ================================================================================
  *
  *       Application:  Demo
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Web Browser/Web Page display panel for CPRS Coversheet.
  *
  *       Notes:
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
  SHDocVw,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.OleCtrls,
  mCoverSheetDisplayPanel,
  iCoverSheetIntf;

type
  TfraCoverSheetDisplayPanel_Web = class(TfraCoverSheetDisplayPanel, ICoverSheetDisplayPanel)
    brwsr: TWebBrowser;
    sbtnBack: TSpeedButton;
    pnlNavigator: TPanel;
    sbtnForward: TSpeedButton;
    edtURL: TEdit;
    sbtnGO: TSpeedButton;
    sbtnHome: TSpeedButton;
    procedure sbtnGOClick(Sender: TObject);
    procedure edtURLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure brwsrNavigateComplete2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
  private
    { Private declarations }
  protected
    { Inherited methods }
    procedure setParam(const aValue: ICoverSheetParam); override;

    procedure OnRefreshDisplay(Sender: TObject); override;

    { Introduced methods }
    function WebParams: ICoverSheetParam_Web; virtual; final;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_Web: TfraCoverSheetDisplayPanel_Web;

implementation

uses
  ORExtensions;

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_Web }

procedure TfraCoverSheetDisplayPanel_Web.brwsrNavigateComplete2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  //
end;

constructor TfraCoverSheetDisplayPanel_Web.Create(aOwner: TComponent);
begin
  inherited;
  SetUserDataFolder(brwsr);
end;

procedure TfraCoverSheetDisplayPanel_Web.edtURLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sbtnGOClick(Sender);
end;

procedure TfraCoverSheetDisplayPanel_Web.OnRefreshDisplay(Sender: TObject);
begin
  inherited;
  if WebParams.ShowNavigator then
    //
  else
    brwsr.Navigate(WebParams.HomePage);
end;

procedure TfraCoverSheetDisplayPanel_Web.sbtnGOClick(Sender: TObject);
begin
  if edtURL.Text <> '' then
    brwsr.Navigate(edtURL.Text);
end;

procedure TfraCoverSheetDisplayPanel_Web.setParam(const aValue: ICoverSheetParam);
begin
  inherited;
  pnlNavigator.Visible := WebParams.ShowNavigator;
end;

function TfraCoverSheetDisplayPanel_Web.WebParams: ICoverSheetParam_Web;
begin
  getParam.QueryInterface(ICoverSheetParam_Web, Result);
end;

end.
