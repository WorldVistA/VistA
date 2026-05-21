unit mPtInfoPanel;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  System.ImageList,
  Vcl.ImgList,
  Vcl.ExtCtrls,
  Vcl.AppEvnts,
  Vcl.StdCtrls,
  ORCtrls,
  uPtInfoCore,
  uPtInfoCommon,
  ORSymbolLabel,
  fBase508Frame;

type
  TfraPtInfoPanel = class(TBase508Frame)
    pnlMain: TPanel;
    gpMain: TGridPanel;
    ptInfoAppEvents: TApplicationEvents;
    gpDetails: TGridPanel;
    gpTop: TGridPanel;
    pnlLeft: TKeyClickPanel;
    pnlRight: TKeyClickPanel;
    imgLeft: TImage;
    imgRight: TImage;
    sbMain: TScrollBox;
    imgExpand: TImage;
    imgCollapse: TImage;
    slblMain: TORSymbolLabel;
    imgListPtInfo: TImageList;
    procedure ptInfoAppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure pnlTopEnter(Sender: TObject);
    procedure pnlTopLeave(Sender: TObject);
    procedure pnlLeftClick(Sender: TObject);
    procedure pnlRightClick(Sender: TObject);
  private
    FPtInfo: TPtInfoData;
    FSVParent: TPtInfoSplitViewBase;
    function GetPanel(Sender: TObject): TPanel;
    procedure pnlRefreshClick(Sender: TObject);
    procedure pnlPinClick(Sender: TObject);
    procedure UpdateMargins(Panel: TPanel);
  protected
    procedure SetParent(AParent: TWinControl); override;
  public
    property PtInfo: TPtInfoData read FPtInfo write FPtInfo;
  end;

implementation

{$R *.dfm}

uses
  Vcl.WinXCtrls,
  ORFn,
  rPtInfo,
  fFrame,
  uConst;

{ TfraPtInfoPanel }

procedure TfraPtInfoPanel.ptInfoAppEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
var
  Rect: TRect;
begin
  if (not(csdestroying in ComponentState)) and (FSVParent.FloatMonitoring) and
    (FSVParent.OpenState = osFloating) and (not FSVParent.IsInternalCall) and
    ((Msg.Message = WM_LBUTTONDOWN) or (Msg.Message = WM_RBUTTONDOWN) or
    (Msg.Message = WM_MBUTTONDOWN) or (Msg.Message = WM_XBUTTONDOWN)) then
  begin
    Rect.TopLeft := ClientOrigin;
    Rect.Bottom := Rect.Top + Height;
    Rect.Right := Rect.Left + FSVParent.PinnedWidth;
    if not Rect.Contains(Mouse.CursorPos) then
    begin
      FSVParent.OpenState := osUnpinned;
      if FSVParent.WarningDisplayed then
        Handled := True
      else if Assigned(FPtInfo) then
        Handled := not FPtInfo.GeneralParameters.ProcessMouseClickWhenFloating
      else
        Handled := True;
    end;
  end;
end;

function TfraPtInfoPanel.GetPanel(Sender: TObject): TPanel;
begin
  if Sender is TPanel then
    Result := Sender as TPanel
  else if (Sender is TControl) and ((Sender as TControl).Parent is TPanel) then
    Result := (Sender as TControl).Parent as TPanel
  else
    Result := nil;
end;

procedure TfraPtInfoPanel.pnlLeftClick(Sender: TObject);
begin
  if FSVParent.Placement = svpLeft then
    pnlRefreshClick(Sender)
  else
    pnlPinClick(Sender);
end;

procedure TfraPtInfoPanel.pnlRefreshClick(Sender: TObject);
begin
  FSVParent.Reload;
end;

procedure TfraPtInfoPanel.pnlRightClick(Sender: TObject);
begin
  if FSVParent.Placement = svpRight then
    pnlRefreshClick(Sender)
  else
    pnlPinClick(Sender);
end;

procedure TfraPtInfoPanel.pnlTopEnter(Sender: TObject);
var
  Panel: TPanel;
begin
  Panel := GetPanel(Sender);
  if Assigned(Panel) then
  begin
    Panel.BevelOuter := bvRaised;
    UpdateMargins(Panel);
  end;
end;

procedure TfraPtInfoPanel.pnlTopLeave(Sender: TObject);
var
  Panel: TPanel;
begin
  Panel := GetPanel(Sender);
  if Assigned(Panel) then
  begin
    Panel.BevelOuter := bvNone;
    UpdateMargins(Panel);
  end;
end;

procedure TfraPtInfoPanel.pnlPinClick(Sender: TObject);
var
  Panel: TPanel;
begin
  Panel := GetPanel(Sender);
  if Assigned(Panel) and (Panel.BevelOuter = bvRaised) then
    SendMessage(Panel.Handle, WM_MOUSELEAVE, 0, 0);
  case FSVParent.OpenState of
    osUnpinned:
      FSVParent.OpenState := osFloating;
    osFloating:
      if FSVParent.CanPin then
        FSVParent.OpenState := osPinned
      else
      begin
        if FSVParent.HasActiveEmbeddedForm then
          FSVParent.WarningMessage :=
            'There is not enough room to pin the patient information panel.' +
            CRLF + CRLF;
        FSVParent.OpenState := osUnpinned;
      end;
    osPinned:
      FSVParent.OpenState := osUnpinned;
  end;
end;

procedure TfraPtInfoPanel.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(AParent) and (AParent is TPtInfoSplitViewBase) then
    FSVParent := AParent as TPtInfoSplitViewBase;
end;

procedure TfraPtInfoPanel.UpdateMargins(Panel: TPanel);
var
  i, Adj: Integer;
begin
  if Panel.BevelOuter = bvNone then
    Adj := 1
  else
    Adj := 0;
  for i := 0 to Panel.ControlCount - 1 do
    if Panel.Controls[i] is TImage then
    begin
      Panel.Controls[i].Margins.Top := Adj;
      Panel.Controls[i].Margins.Left := 2 + Adj;
      Panel.Controls[i].Margins.Right := 2 + Adj
    end;
end;

end.
