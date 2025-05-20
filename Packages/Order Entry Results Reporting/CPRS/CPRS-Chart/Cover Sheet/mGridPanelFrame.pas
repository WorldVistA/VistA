unit mGridPanelFrame;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TFrame. This display panel is the bare
  *                     minimum for a grid panel for use within the CPRS
  *                     application.
  *
  *       Notes:        This frame is a base object and heavily inherited from.
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
  System.UITypes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ImgList,
  iCoverSheetIntf,
  iGridPanelIntf;

type
  TfraGridPanelFrame = class(TFrame, IGridPanelControl, IGridPanelFrame, ICPRS508)
    pnlMain: TPanel;
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlWorkspace: TPanel;
    pmn: TPopupMenu;
    pmnExpandCollapse: TMenuItem;
    pmnRefresh: TMenuItem;
    pmnCustomize: TMenuItem;
    pmnShowError: TMenuItem;
    sbtnExpandCollapse: TSpeedButton;
    sbtnRefresh: TSpeedButton;
    pnlVertHeader: TPanel;
    img: TImage;
  private
    fGridPanelDisplay: IGridPanelDisplay;
    fCollapsed: boolean;

    fAllowCollapse: TGridPanelCollapse;
    fAllowRefresh: boolean;
    fAllowCustomize: boolean;

    fLoadError: boolean;
    fLoadErrorMessage: string;

    fScreenReaderActive: boolean;

    { Prevents auto free when RefCount = 0 }
    function _AddRef: integer; stdcall;
    function _Release: integer; stdcall;
  protected
    { Getters and Setters }
    function getAllowCollapse: TGridPanelCollapse; virtual;
    function getAllowCustomize: boolean; virtual;
    function getAllowRefresh: boolean; virtual;
    function getBackgroundColor: TColor; virtual; final;
    function getCollapsed: boolean; virtual;
    function getGridPanelDisplay: IGridPanelDisplay; virtual; final;
    function getTitleFontColor: TColor; virtual; final;
    function getTitleFontBold: boolean; virtual; final;
    function getTitle: string; virtual;
    function getLoadError: boolean;
    function getLoadErrorMessage: string;

    procedure setAllowCollapse(const aValue: TGridPanelCollapse); virtual;
    procedure setAllowCustomize(const aValue: boolean); virtual;
    procedure setAllowRefresh(const aValue: boolean); virtual;
    procedure setBackgroundColor(const aValue: TColor); virtual; final;
    procedure setGridPanelDisplay(const aValue: IGridPanelDisplay); virtual; final;
    procedure setTitleFontColor(const aValue: TColor); virtual; final;
    procedure setTitleFontBold(const aValue: boolean); virtual; final;
    procedure setTitle(const aValue: string); virtual;

    { ICPRS508 implementation events }
    procedure OnFocusFirstControl(Sender: TObject); virtual;
    procedure OnSetFontSize(Sender: TObject; aNewSize: integer); virtual;
    procedure OnSetScreenReaderStatus(Sender: TObject; aActive: boolean); virtual;

    { Component events }
    procedure OnExpandCollapse(Sender: TObject); virtual;
    procedure OnCustomizeDisplay(Sender: TObject); virtual;
    procedure OnLoadError(Sender: TObject; E: Exception); virtual;
    procedure OnPopupMenu(Sender: TObject); virtual;
    procedure OnPopupMenuInit(Sender: TObject); virtual;
    procedure OnPopupMenuFree(Sender: TObject); virtual;
    procedure OnRefreshDisplay(Sender: TObject); virtual;
    procedure OnRefreshVerticalTitle(Sender: TObject); virtual;
    procedure OnShowError(Sender: TObject); virtual;

    { Component methods }
    procedure ClearLoadError;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  VAUtils;
	
{ TfraGridPanelFrame }

const
  IMG_COLLAPSE = 'MGRIDPANELFRAME_COLLAPSE';
  IMG_EXPAND   = 'MGRIDPANELFRAME_EXPAND';
  IMG_REFRESH  = 'MGRIDPANELFRAME_REFRESH';
  IMG_DELETE   = 'MGRIDPANELFRAME_DELETE';

constructor TfraGridPanelFrame.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  name := 'fra' + NewGUID;
  fCollapsed := False;
  fAllowCollapse := gpcNone;
  fAllowRefresh := False;
  fAllowCustomize := False;

  sbtnExpandCollapse.OnClick := OnExpandCollapse;
  sbtnExpandCollapse.Visible := fAllowCollapse in [gpcRow, gpcColumn];
  sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_COLLAPSE);

  sbtnRefresh.OnClick := OnRefreshDisplay;
  sbtnRefresh.Visible := fAllowRefresh;
  sbtnRefresh.Glyph.LoadFromResourceName(HInstance, IMG_REFRESH);

  { Default settings according to the current Windows Pallet - SHOULD NOT BE CHANGED HERE, EVER!!!! }
  pnlMain.Color := clActiveCaption;
  lblTitle.Font.Color := clCaptionText;
  lblTitle.Font.Style := [fsBold];

  { Call this so that descendant panels can customize the menu if needed }
  OnPopupMenuInit(Self);
end;

destructor TfraGridPanelFrame.Destroy;
begin
  OnPopupMenuFree(Self);
  inherited;
end;

function TfraGridPanelFrame._AddRef: integer;
begin
  Result := -1;
end;

function TfraGridPanelFrame._Release: integer;
begin
  Result := -1;
end;

procedure TfraGridPanelFrame.ClearLoadError;
begin
  pmnShowError.Visible := False;
  fLoadError := False;
  fLoadErrorMessage := '';
end;

procedure TfraGridPanelFrame.OnLoadError(Sender: TObject; E: Exception);
begin
  pmnShowError.Visible := True;
  fLoadError := True;
  fLoadErrorMessage := Format('LoadError: [%s] - %s', [Sender.ClassName, E.Message]);
end;

procedure TfraGridPanelFrame.OnCustomizeDisplay(Sender: TObject);
begin
  { Virtual method for the descendants to implement if needed }
end;

procedure TfraGridPanelFrame.OnExpandCollapse(Sender: TObject);
var
  aRow: integer;
  aCol: integer;
begin
  try
    fCollapsed := not fCollapsed;

    { Find out where we are on the grid }
    fGridPanelDisplay.FindControl(Self, aCol, aRow);

    case fAllowCollapse of
      gpcRow:
        if fCollapsed then
          begin
            pnlWorkspace.Hide;
            sbtnRefresh.Hide;
            sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_EXPAND);
            pnlVertHeader.TabStop := true;
            fGridPanelDisplay.CollapseRow(aRow);
            pnlVertHeader.SetFocus;
          end
        else
          begin
            fGridPanelDisplay.ExpandRow(aRow);
            pnlVertHeader.TabStop := false;
            sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_COLLAPSE);
            if fAllowRefresh then
              sbtnRefresh.Show;
            pnlWorkspace.Show;
            pnlWorkspace.SetFocus;
          end;
      gpcColumn:
        if fCollapsed then
          begin
            pnlWorkspace.Hide;
            sbtnRefresh.Hide;
            pnlVertHeader.Visible := True;
            OnRefreshVerticalTitle(Sender);
            sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_EXPAND);
            pnlVertHeader.TabStop := True;
            fGridPanelDisplay.CollapseColumn(aCol);
            pnlVertHeader.SetFocus;
          end
        else
          begin
            fGridPanelDisplay.ExpandColumn(aCol);
            pnlVertHeader.TabStop := false;
            sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_COLLAPSE);
            if fAllowRefresh then
              sbtnRefresh.Show;
            pnlWorkspace.Show;
            pnlWorkspace.SetFocus;
            pnlVertHeader.Visible := false;
          end;
    end;
  except
    ShowMessage('Error in ExpandCollapseClick method.');
  end;
end;

procedure TfraGridPanelFrame.OnPopupMenu(Sender: TObject);
begin
  if fCollapsed then
    pmnExpandCollapse.Caption := 'Expand'
  else
    pmnExpandCollapse.Caption := 'Collapse';

  pmnExpandCollapse.Visible := fAllowCollapse in [gpcRow, gpcColumn];
  pmnRefresh.Visible := fAllowRefresh;
  pmnCustomize.Visible := fAllowCustomize;
  pmnShowError.Visible := fLoadError;
end;

procedure TfraGridPanelFrame.OnPopupMenuFree(Sender: TObject);
begin
  // Nothing needed here, the menu items are all owned properly by the frame.
end;

procedure TfraGridPanelFrame.OnPopupMenuInit(Sender: TObject);
begin
  pmnExpandCollapse.OnClick := OnExpandCollapse;
  pmnExpandCollapse.Visible := fAllowCollapse in [gpcRow, gpcColumn];

  pmnRefresh.OnClick := OnRefreshDisplay;
  pmnRefresh.Visible := fAllowRefresh;

  pmnCustomize.OnClick := OnCustomizeDisplay;
  pmnCustomize.Visible := fAllowCustomize;

  pmnShowError.OnClick := OnShowError;
  pmnShowError.Visible := False;

  pmn.OnPopup := OnPopupMenu;
end;

procedure TfraGridPanelFrame.OnRefreshDisplay(Sender: TObject);
begin
  { Virtual method for the descendants to implement if needed }
end;

procedure TfraGridPanelFrame.OnRefreshVerticalTitle(Sender: TObject);
var
  aStr: string;
  X: integer;
  Y: integer;
  H: integer;
  i: integer;
begin
  if fCollapsed then
    begin
      img.Picture := nil;
      img.Canvas.Brush.Color := pnlMain.Color;
      img.Canvas.FillRect(Rect(0, 0, img.Width, img.Height));
      img.Canvas.Font.Color := lblTitle.Font.Color;
      img.Canvas.Font.Style := lblTitle.Font.Style;
      Y := 0;
      H := img.Canvas.TextHeight('|');
      for i := 1 to Length(lblTitle.Caption) do
        begin
          aStr := Copy(lblTitle.Caption, i, 1);
          X := (img.Width - img.Canvas.TextWidth(aStr)) div 2;
          img.Canvas.TextOut(X, Y, aStr);
          inc(Y, H);
          if Y > (img.Height - H) then
            Break;
        end;
      img.Repaint;
    end;
end;

procedure TfraGridPanelFrame.OnFocusFirstControl(Sender: TObject);
begin
  if pnlWorkspace.Visible and pnlWorkspace.Enabled then
    pnlWorkspace.SetFocus;
end;

procedure TfraGridPanelFrame.OnSetFontSize(Sender: TObject; aNewSize: integer);
var
  aComponent: TComponent;
  aCPRS508: ICPRS508;
begin
  Self.Font.Size := aNewSize;
  lblTitle.Font.Size := aNewSize; { Bolded so ParentFont = False :( }
  pnlHeader.Height := lblTitle.Canvas.TextHeight(lblTitle.Caption) + lblTitle.Margins.Top + lblTitle.Margins.Bottom; { So the big ole title displays properly }

  { Now walk any other items that may be ICPRS_508 implementors }
  for aComponent in Self do
    if Supports(aComponent, ICPRS508, aCPRS508) then
      aCPRS508.OnSetFontSize(Self, aNewSize);
end;

procedure TfraGridPanelFrame.OnSetScreenReaderStatus(Sender: TObject; aActive: boolean);
begin
  fScreenReaderActive := aActive;
  // DRM NOTE: Parent form hasn't been set yet, so there's no way to find 508 manager.
end;

procedure TfraGridPanelFrame.OnShowError(Sender: TObject);
begin
  if fLoadError then
    ShowMessage(fLoadErrorMessage)
  else
    ShowMessage('No load error message.');
end;

function TfraGridPanelFrame.getLoadError: boolean;
begin
  Result := fLoadError;
end;

function TfraGridPanelFrame.getLoadErrorMessage: string;
begin
  Result := fLoadErrorMessage;
end;

function TfraGridPanelFrame.getAllowCollapse: TGridPanelCollapse;
begin
  Result := fAllowCollapse;
end;

function TfraGridPanelFrame.getAllowCustomize: boolean;
begin
  Result := fAllowCustomize;
end;

function TfraGridPanelFrame.getAllowRefresh: boolean;
begin
  Result := fAllowRefresh;
end;

function TfraGridPanelFrame.getBackgroundColor: TColor;
begin
  Result := pnlMain.Color;
end;

function TfraGridPanelFrame.getCollapsed: boolean;
begin
  Result := fCollapsed;
end;

function TfraGridPanelFrame.getGridPanelDisplay: IGridPanelDisplay;
begin
  {
    When a control is added through the AddControl Method of the ICPRSGridPanel
    if it supports ICPRSGridPanelFrame fCPRSGridPanel will br set to the
    ICPRSGridPanel that it is added to.
  }
  if fGridPanelDisplay <> nil then
    fGridPanelDisplay.QueryInterface(IGridPanelDisplay, Result)
  else
    Result := nil;
end;

function TfraGridPanelFrame.getTitle: string;
begin
  Result := lblTitle.Caption;
end;

function TfraGridPanelFrame.getTitleFontBold: boolean;
begin
  Result := (fsBold in lblTitle.Font.Style);
end;

function TfraGridPanelFrame.getTitleFontColor: TColor;
begin
  Result := lblTitle.Font.Color;
end;

procedure TfraGridPanelFrame.setAllowCollapse(const aValue: TGridPanelCollapse);
begin
  fAllowCollapse := aValue;
  case fAllowCollapse of
    gpcNone:
      begin
        sbtnExpandCollapse.Visible := False;
        sbtnExpandCollapse.Glyph := nil;
      end;
    gpcRow:
      begin
        if fCollapsed then
          sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_EXPAND)
        else
          sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_COLLAPSE);
        sbtnExpandCollapse.Visible := True;
      end;
    gpcColumn:
      begin
        if fCollapsed then
          sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_EXPAND)
        else
          sbtnExpandCollapse.Glyph.LoadFromResourceName(HInstance, IMG_COLLAPSE);
        sbtnExpandCollapse.Visible := True;
      end;
  end;
end;

procedure TfraGridPanelFrame.setAllowCustomize(const aValue: boolean);
begin
  fAllowCustomize := aValue;
end;

procedure TfraGridPanelFrame.setAllowRefresh(const aValue: boolean);
begin
  fAllowRefresh := aValue;
  sbtnRefresh.Visible := fAllowRefresh;
end;

procedure TfraGridPanelFrame.setBackgroundColor(const aValue: TColor);
begin
  pnlMain.Color := aValue;
end;

procedure TfraGridPanelFrame.setGridPanelDisplay(const aValue: IGridPanelDisplay);
begin
  if aValue <> nil then
    aValue.QueryInterface(IGridPanelDisplay, fGridPanelDisplay)
  else
    fGridPanelDisplay := nil;
end;

procedure TfraGridPanelFrame.setTitle(const aValue: string);
begin
  lblTitle.Caption := aValue;
  {
    Set pnlWorkspace.Caption as the lblTitle.Caption so when
    ScreenReader taps in it will have something to say.
  }
  pnlWorkspace.Caption := aValue;
  pnlVertHeader.Caption := aValue + ' minimized';
end;

procedure TfraGridPanelFrame.setTitleFontBold(const aValue: boolean);
begin
  if aValue and not(fsBold in lblTitle.Font.Style) then
    lblTitle.Font.Style := lblTitle.Font.Style + [fsBold]
  else
    lblTitle.Font.Style := lblTitle.Font.Style - [fsBold];
end;

procedure TfraGridPanelFrame.setTitleFontColor(const aValue: TColor);
begin
  lblTitle.Font.Color := aValue;
end;

end.
