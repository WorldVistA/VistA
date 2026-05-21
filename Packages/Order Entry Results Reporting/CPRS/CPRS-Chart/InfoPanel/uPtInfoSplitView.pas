unit uPtInfoSplitView;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Winapi.Messages,
  Winapi.Windows,
  mPtInfoPanel,
  uPtInfoCommon,
  uPtInfoCore,
  VA508AccessibilityManager,
  VA508AccessibilityRouter,
  fBase508Form,
  uConst;

type
  TSplitView = class(TPtInfoSplitViewBase)
  private const
    FalseSplitterWidth = 4;
    ImageRefreshIndex = 3;
    PlacementOffset: array [TSplitViewPlacement] of Integer = (0, 4);
    HintText: array [0 .. 3] of string = ('Expand', 'Pin', 'Unpin',
      'Refresh Patient Information Panel');
  private
    FMaxFloatingWidth: Integer;
    FMaxPinnedWidth: Integer;
    FMinPinnedWidth: Integer;
    FMinUnpinnedWidth: Integer;
    FNotePanelLeft: TPanel;
    FNotePanelRight: TPanel;
    FNotePanelMinWidthLeft: Integer;
    FNoteTab: Boolean;
    FOldActiveControlChanged: TNotifyEvent;
    FOldOpenState: TPtInfoDataTypes.TOpenState;
    FOpenState: TPtInfoDataTypes.TOpenState;
    FOverlay: TWinControl;
    FOverlayOldWindowProc: TWndMethod;
    FPtInfoData: TPtInfoData;
    FPtInfoPanelFrame: TfraPtInfoPanel;
    FTransitionToFloatingWidth: Integer;
    FTransitionToPinnedWidth: Integer;
    FWarningDisplayed: Boolean;
    procedure ActiveControlChanged(Sender: TObject);
    function GetDisplayMode: TSplitViewDisplayMode;
    function GetPtInfoPanelFrame: TfraPtInfoPanel;
    procedure OverlayWindowProc(var Message: TMessage);
    procedure SetDisplayMode(const Value: TSplitViewDisplayMode);
    procedure UpdatePinImages;
    procedure CMControlListChanging(var Msg: TCMControlListChanging);
      message CM_CONTROLLISTCHANGING;
    procedure CMVisibleChanged(var Message: TMessage);
      message CM_VISIBLECHANGED;
    procedure UMMisc(var Message: TMessage); message UM_MISC;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMHitTest(var Message: TCMHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging);
      message WM_WINDOWPOSCHANGING;
  protected
    function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure DoClosed; override;
    procedure DoOpened; override;
    function GetFormGrid: TGridPanel; override;
    function GetOpenState: TPtInfoDataTypes.TOpenState; override;
    function GetPanelGrid: TGridPanel; override;
    function GetPinnedWidth: Integer; override;
    function GetWarningDisplayed: Boolean; override;
    procedure Resize; override;
    procedure SetOpenState(const Value: TPtInfoDataTypes.TOpenState); override;
    procedure SetPinnedWidth(const Value: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdjustPanels; override;
    function CanCloseEmbeddedForm: Boolean;
    function CanPin: Boolean; override;
    function HasActiveEmbeddedForm: Boolean; override;
    procedure InitPatient; override;
    procedure InitPanels(PageID: Integer); override;
    procedure FontChanged; override;
    procedure Reload; override;
    procedure ResetMaxConstraints;
    procedure ResetOpenState; override;
    procedure UpdatePlacement;
    property DisplayMode: TSplitViewDisplayMode read GetDisplayMode
      write SetDisplayMode;
    property PtInfoPanelFrame: TfraPtInfoPanel read GetPtInfoPanelFrame;
  end;

implementation

uses
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,
  ORCtrls,
  ORFn,
  ORDtTm,
  ORSymbolLabel,
  VAInfoDialog,
  VAUtils,
  rPtInfo,
  fPtInfoDetails,
  fHTMLDialog,
  fFrame,
  fNotes,
  fConsults,
  fDCSumm,
  fSurgery;

{ TSplitView }

procedure TSplitView.ActiveControlChanged(Sender: TObject);
begin
  if (not(csdestroying in ComponentState)) then
  begin
    if FloatMonitoring and frmFrame.Activated and (not IsInternalCall) and
      (FOpenState = osFloating) and (not ContainsControl(Screen.ActiveControl))
    then
      OpenState := osUnpinned;
    if Assigned(FOldActiveControlChanged) then
      FOldActiveControlChanged(Sender);
  end;
end;

procedure TSplitView.AdjustPanels;
begin
  inherited;
  if Assigned(FPtInfoData) then
    FPtInfoData.AdjustPanels;
end;

// prevents image flickering when resizing Info Panel
procedure TSplitView.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 0;
end;

procedure TSplitView.WMHitTest(var Message: TCMHitTest);
var
  P: TPoint;
begin
  inherited;
  if Assigned(FPtInfoData) and (OpenState in [osPinned, osFloating, osUnpinned])
  then
  begin
    P.X := Message.XPos;
    P.Y := Message.YPos;
    P := ScreenToClient(P);
    if (P.Y >= 0) and (P.Y < Height) then
    begin
      if (FPtInfoData.GeneralParameters.PanelPlacement = svpLeft) and
        (P.X <= Width) and (P.X >= (Width - FPtInfoPanelFrame.Margins.Right))
      then
        Message.Result := HTRIGHT
      else if (FPtInfoData.GeneralParameters.PanelPlacement = svpRight) and
        (P.X >= 0) and (P.X <= (FPtInfoPanelFrame.Margins.Left)) then
        Message.Result := HTLEFT;
    end;
  end;
end;

procedure TSplitView.WMSetCursor(var Msg: TWMSetCursor);
begin
  if Assigned(FPtInfoData) then
  begin
    if ((FPtInfoData.GeneralParameters.PanelPlacement = svpLeft) and
      (Msg.HitTest = HTRIGHT)) or
      ((FPtInfoData.GeneralParameters.PanelPlacement = svpRight) and
      (Msg.HitTest = HTLEFT)) then
    begin
      Winapi.Windows.SetCursor(Screen.Cursors[crHSplit]);
      Msg.Result := 1;
    end;
  end;
end;

procedure TSplitView.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
  if (Placement = svpRight) then
    Msg.WindowPos.X := Parent.Width - Width;
  inherited;
end;

function TSplitView.CanCloseEmbeddedForm: Boolean;
var
  Dialog: TfrmPtInfoDetails;
  Features: TVAInfoDialog.TFeatures;
  DlgResult: Integer;
begin
  Result := True;
  if HasActiveEmbeddedForm then
  begin
    if IsInternalCall then
    begin
      Result := False;
      Exit;
    end;
    BeginInternalCall;
    try
      Dialog := FPtInfoData.CurrentEmbeddedPresentation.Dialog as
        TfrmPtInfoDetails;
      case FPtInfoData.CurrentEmbeddedPresentation.ActionType of
        actShowURL:
          begin
            Features.mrDefault := mrClose;
            Features.mrCancel := mrAbort;
            DlgResult := TVAInfoDialog.Show(WarningMessage + 'Close web page?',
              'Close web page', mtWarning, [mrClose, mrAbort], Features,
              ['Yes', 'No']);

          end;
        actShowEditor:
          begin
            Features.mrDefault := mrYes;
            Features.mrCancel := mrAbort;
            DlgResult := TVAInfoDialog.Show
              (WarningMessage + 'What would you like to do with "' +
              Dialog.lblHeader.Caption + '"?', Dialog.lblHeader.Caption,
              mtWarning, [mrYes, mrClose, mrAbort], Features,
              [Dialog.fraEditGrid.btnSave.Caption,
              Dialog.fraEditGrid.btnCancel.Caption, 'Keep Open']);
          end;
      else
        DlgResult := mrClose;
      end;
      FWarningDisplayed := True;
      WarningMessage := '';
      case DlgResult of
        mrYes:
          begin
            Dialog.fraEditGridBtnSaveClick(Dialog.fraEditGrid.btnSave);
            if Dialog.IsActive then
              Result := False;
          end;
        mrClose:
          Dialog.btnCloseClick(Dialog.btnClose);
        mrAbort:
          Result := False;
      end;
    finally
      EndInternalCall;
    end;
  end;
end;

function TSplitView.CanPin: Boolean;
begin
  Result := (FMaxPinnedWidth >= FMinPinnedWidth);
end;

function TSplitView.CanResize(var NewWidth, NewHeight: Integer): Boolean;
var
  Diff, Diff1, Diff2: Integer;
  CanClose: Boolean;
begin
  Result := inherited;
  if Result and (not IsInternalCall) and (not frmFrame.Closing) then
  begin
    BeginInternalCall;
    try
      case FOpenState of
        osUnpinned:
          if (NewWidth > FMinUnpinnedWidth) and
            (NewWidth < FTransitionToPinnedWidth) then
            Result := False
          else if (NewWidth >= FTransitionToPinnedWidth) then
          begin
            NewWidth := FMinPinnedWidth;
            if CanPin then
              OpenState := osPinned
            else
              OpenState := osFloating;
          end;
        osFloating, osPinned:
          if (NewWidth < FMinPinnedWidth) and
            (NewWidth > FTransitionToPinnedWidth) then
            Result := False
          else if (NewWidth < FTransitionToPinnedWidth) then
          begin
            EndInternalCall;
            try
              CanClose := CanCloseEmbeddedForm;
            finally
              BeginInternalCall;
            end;
            if CanClose then
            begin
              OpenState := osUnpinned;
              NewWidth := FMinUnpinnedWidth
            end
            else
            begin
              Result := False;
              NewWidth := FMinPinnedWidth;
            end;
          end
          else if (FOpenState = osPinned) then
          begin
            if (NewWidth > FMaxPinnedWidth) and
              (NewWidth < FTransitionToFloatingWidth) then
              NewWidth := FMaxPinnedWidth
            else if (NewWidth > FMaxPinnedWidth) and
              (NewWidth >= FTransitionToFloatingWidth) then
              OpenState := osFloating;
            if FNoteTab then
            begin
              Diff1 := FNotePanelRight.Width -
                FNotePanelRight.Constraints.MinWidth;
              Diff2 := NewWidth - Width;
              if Diff1 < Diff2 then
              begin
                Diff := FNotePanelLeft.Width - (Diff2 - Diff1);
                if Diff >= FNotePanelMinWidthLeft then
                  FNotePanelLeft.Width := Diff
                else
                  Result := False;
              end;
            end;
          end;
      end;
    finally
      EndInternalCall;
    end;
  end;
end;

procedure TSplitView.CMControlListChanging(var Msg: TCMControlListChanging);
begin
  if (Msg.ControlListItem.Parent = Self) and
    (Msg.ControlListItem.Control is TfraPtInfoPanel) then
    if Msg.Inserting then
    begin
      FPtInfoPanelFrame := Msg.ControlListItem.Control as TfraPtInfoPanel;
      ImageCollapse := FPtInfoPanelFrame.imgCollapse;
      ImageExpand := FPtInfoPanelFrame.imgExpand;
      SymbolLabel := FPtInfoPanelFrame.slblMain;
    end
    else
    begin
      FPtInfoPanelFrame := nil;
      ImageCollapse := nil;
      ImageExpand := nil;
      SymbolLabel := nil;
    end;
end;

procedure TSplitView.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  // A bug in TSplitView doesn't hide the internal FOverlayPadding
  if Visible then
    CloseStyle := svcCompact
  else
  begin
    Constraints.MinWidth := 0;
    CloseStyle := svcCollapse;
  end;
end;

constructor TSplitView.Create(AOwner: TComponent);
begin
  inherited;
  FloatMonitoring := True;
  FOldOpenState := osUnpinned;
  CloseStyle := svcCompact;
  UseAnimation := False;
  FOldActiveControlChanged := Screen.OnActiveControlChange;
  Screen.OnActiveControlChange := ActiveControlChanged;
end;

destructor TSplitView.Destroy;
begin
  FreeAndNil(FPtInfoData);
  inherited;
end;

procedure TSplitView.DoClosed;
begin
  inherited;
  if Assigned(FPtInfoData) then
    FPtInfoData.ResetPanelText(False);
end;

procedure TSplitView.DoOpened;
begin
  inherited;
  if Assigned(FPtInfoData) then
    FPtInfoData.ResetPanelText(True);
end;

procedure TSplitView.Resize;
begin
  ResetMaxConstraints;
  if Visible and (not IsInternalCall) then
  begin
    BeginInternalCall;
    try
      if Opened then
        PinnedWidth := Width;
    finally
      EndInternalCall;
    end;
  end;
  AdjustPanels;
  // Keep inherited at the bottom
  inherited;
end;

procedure TSplitView.FontChanged;
begin
  inherited;
  Font.Size := Application.MainForm.Font.Size;
  if Assigned(FPtInfoData) then
    FPtInfoData.ResetFont(MainFontTextHeight + Font.Size +
      TPtInfoDataTypes.RowHeightOffset[FPtInfoData.HasImages]);
  UpdatePlacement;
end;

function TSplitView.GetDisplayMode: TSplitViewDisplayMode;
begin
  Result := inherited DisplayMode;
end;

function TSplitView.GetWarningDisplayed: Boolean;
begin
  Result := FWarningDisplayed;
  FWarningDisplayed := False;
end;

function TSplitView.HasActiveEmbeddedForm: Boolean;
var
  Presentation: TPtInfoPresentation;
begin
  Result := False;
  if (not frmFrame.TimedOut) and Assigned(FPtInfoData) then
  begin
    Presentation := FPtInfoData.CurrentEmbeddedPresentation;
    Result := Assigned(Presentation) and Assigned(Presentation.Dialog) and
      Presentation.Dialog.Visible and
      (Presentation.ActionType in [actShowURL, actShowEditor]);
  end;
end;

function TSplitView.GetFormGrid: TGridPanel;
begin
  Result := FPtInfoPanelFrame.gpDetails;
end;

function TSplitView.GetOpenState: TPtInfoDataTypes.TOpenState;
begin
  Result := FOpenState;
end;

function TSplitView.GetPanelGrid: TGridPanel;
begin
  Result := FPtInfoPanelFrame.gpMain;
end;

function TSplitView.GetPinnedWidth: Integer;
begin
  Result := OpenedWidth;
end;

function TSplitView.GetPtInfoPanelFrame: TfraPtInfoPanel;
begin
  Result := FPtInfoPanelFrame;
end;

procedure TSplitView.InitPanels(PageID: Integer);
var
  InfoFound: Boolean;
begin
  inherited;
  InfoFound := False;
  ResetMaxConstraints;
  if Assigned(FPtInfoData) then
    InfoFound := FPtInfoData.SetupPanels(PageID, MainFontTextHeight +
      TPtInfoDataTypes.RowHeightOffset[FPtInfoData.HasImages]);
  if not InfoFound then
    OpenState := osClosed
  else if OpenState = osClosed then
    OpenState := osRestored
  else
    ResetOpenState;
end;

procedure TSplitView.InitPatient;
var
  Error: string;
begin
  inherited;
  FreeAndNil(FPtInfoData);
  FPtInfoData := CreatePtInfoData(Self, Error);
  FPtInfoPanelFrame.PtInfo := FPtInfoData;
  if Error <> '' then
    ShowMessage(Error)
  else if Assigned(FPtInfoData) then
  begin
    UpdatePinImages;
    FPtInfoPanelFrame.Color := FPtInfoData.GeneralParameters.DefaultColorValue;
    UpdatePlacement;
  end;
end;

procedure TSplitView.OverlayWindowProc(var Message: TMessage);
begin
  if Message.Msg = WM_WINDOWPOSCHANGED then
  begin
    Top := FOverlay.Top;
    Height := FOverlay.Height;
  end;
  if Assigned(FOverlayOldWindowProc) then
    FOverlayOldWindowProc(Message);
end;

procedure TSplitView.Reload;
begin
  if CanCloseEmbeddedForm then
    PostMessage(Self.Handle, UM_MISC, 1, 0);
end;

type
  TAccessWinControl = class(TWinControl);

procedure TSplitView.ResetMaxConstraints;
var
  CalcMin, PageID, MinH, MaxW, MaxH, Adj: Integer;
begin
  BeginInternalCall;
  try
    FMaxFloatingWidth := ((Owner as TForm).ClientWidth div 2);
    Constraints.MaxWidth := FMaxFloatingWidth;
    FMaxPinnedWidth := FMaxFloatingWidth;
    if FMaxPinnedWidth < Constraints.MinWidth then
      FMaxPinnedWidth := Constraints.MinWidth;
    PageID := frmFrame.TabToPageID(frmFrame.tabPage.TabIndex);
    case PageID of
      CT_NOTES:
        begin
          if frmNotes = nil then exit;
          FNotePanelLeft := frmNotes.pnlLeft;
          FNotePanelRight := frmNotes.pnlRight;
          Adj := frmNotes.splHorz.Width;
          FNoteTab := True;
        end;
      CT_CONSULTS:
        begin
          if frmConsults = nil then exit;
          FNotePanelLeft := frmConsults.pnlLeft;
          FNotePanelRight := frmConsults.pnlRight;
          Adj := frmConsults.sptHorz.Width;
          FNoteTab := True;
        end;
      CT_DCSUMM:
        begin
          if frmDCSumm = nil then exit;
          FNotePanelLeft := frmDCSumm.pnlLeft;
          FNotePanelRight := frmDCSumm.pnlRight;
          Adj := frmConsults.sptHorz.Width;
          FNoteTab := True;
        end;
      CT_SURGERY:
        begin
          if frmSurgery = nil then exit;
          FNotePanelLeft := frmSurgery.pnlLeft;
          FNotePanelRight := frmSurgery.pnlRight;
          Adj := frmSurgery.sptHorz.Width;
          FNoteTab := True;
        end;
    else
      begin
        FNotePanelLeft := nil;
        FNotePanelRight := nil;
        FNoteTab := False;
        Adj := 0;
        FNotePanelMinWidthLeft := 0;
      end;
    end;
    if FNoteTab then
    begin
      FNotePanelMinWidthLeft := 0;
      MinH := FNotePanelLeft.Height;
      MaxW := FNotePanelLeft.Width;
      MaxH := FNotePanelLeft.Height;
      TAccessWinControl(FNotePanelLeft).ConstrainedResize
        (FNotePanelMinWidthLeft, MinH, MaxW, MaxH);
      CalcMin := frmFrame.ClientWidth - FNotePanelRight.Constraints.MinWidth -
        FNotePanelMinWidthLeft - Adj - 2;
      if CalcMin < FMinPinnedWidth then
        CalcMin := FMinUnpinnedWidth;
      if FMaxPinnedWidth > CalcMin then
        FMaxPinnedWidth := CalcMin;
    end;
    if (OpenedWidth > FMaxPinnedWidth) and (FOpenState = osPinned) then
      OpenedWidth := FMaxPinnedWidth;
    FTransitionToFloatingWidth := FTransitionToPinnedWidth;
    if CanPin then
    begin
      if (FMaxFloatingWidth > FMaxPinnedWidth) then
      begin
        FTransitionToFloatingWidth := FMaxPinnedWidth + FMinUnpinnedWidth;
        if (FTransitionToFloatingWidth > FMaxFloatingWidth) then
          FTransitionToFloatingWidth := FMaxPinnedWidth;
      end
      else
        FTransitionToFloatingWidth := MaxInt;
    end;
  finally
    EndInternalCall;
  end;
end;

procedure TSplitView.ResetOpenState;
var
  i, Min, Len, OldMin, OldCompactWidth: Integer;
  Panel: TPtInfoPanel;
  BoldFont, AFont: TFont;
  HasScrollBars, HasBevelWidth2: Boolean;

  procedure AdjustForNoteTab;
  var
    Diff, RightPanelRemainingSpace, ChangeNeeded: Integer;
  begin
    if FNoteTab then
    begin
      if DisplayMode = svmDocked then
      begin
        DisplayMode := svmOverlay;
        Realign;
      end;
      RightPanelRemainingSpace := FNotePanelRight.Width -
        FNotePanelRight.Constraints.MinWidth;
      ChangeNeeded := OpenedWidth - CompactWidth;
      if RightPanelRemainingSpace < ChangeNeeded then
      begin
        Diff := FNotePanelLeft.Width -
          (ChangeNeeded - RightPanelRemainingSpace);
        if Diff < FNotePanelMinWidthLeft then
        begin
          OpenedWidth := OpenedWidth - (FNotePanelMinWidthLeft - Diff);
          if OpenedWidth < FMinPinnedWidth then
          begin
            FMaxPinnedWidth := FMinUnpinnedWidth;
            OpenState := osUnpinned;
            Exit;
          end;
          FMaxPinnedWidth := OpenedWidth;
          Diff := FNotePanelMinWidthLeft;
        end;
        FNotePanelLeft.Width := Diff
      end;
    end;
  end;

begin
  BeginInternalCall;
  try
    frmFrame.pnlPatientSelected.LockDrawing;
    try
      Resize;
      if FOpenState = osClosed then
      begin
        if Assigned(FPtInfoData) then
          FPtInfoData.CloseAllDetails;
        Constraints.MinWidth := 0;
        Visible := False;
      end
      else
      begin
        UpdatePinImages;
        Min := FPtInfoPanelFrame.imgLeft.Width +
          FPtInfoPanelFrame.imgRight.Width;
        HasBevelWidth2 := False;
        BoldFont := TFont.Create;
        try
          BoldFont.Assign(MainFont);
          BoldFont.Style := [fsBold];
          for i := 0 to FPtInfoPanelFrame.gpMain.ControlCount - 1 do
            if FPtInfoPanelFrame.gpMain.Controls[i] is TPtInfoPanel then
            begin
              Panel := FPtInfoPanelFrame.gpMain.Controls[i] as TPtInfoPanel;
              if Panel.PtInfoLink.SectionPanel then
                AFont := BoldFont
              else
                AFont := MainFont;
              Len := TextWidthByFont(AFont.Handle, Panel.ShortText);
              if Panel.PtInfoLink.SectionPanel then
                inc(Len);
              if Panel.Alignment = taRightJustify then
                inc(Len, Panel.Width - Panel.TextLabel.BoundsRect.Right +
                  Panel.TextLabel.Margins.Right)
              else
                inc(Len, Panel.TextLabel.Left + Panel.TextLabel.Margins.Right);
              if Min < Len then
                Min := Len;
              HasBevelWidth2 := (Panel.BevelWidth = 2);
            end;
        finally
          FreeAndNil(BoldFont);
        end;
        inc(Min, TPtInfoDataTypes.LabelMarginSize + FalseSplitterWidth +
          frmFrame.pnlPtInfoGap.Width);
        HasScrollBars := (FPtInfoPanelFrame.gpMain.Align = alTop);
        if HasScrollBars then
          inc(Min, ScrollBarWidth);
        if HasBevelWidth2 then
          inc(Min, 2);
        FMinUnpinnedWidth := Min;
        FMinPinnedWidth := Min * 2;
        FTransitionToPinnedWidth := Min * 3 div 2;
        if Constraints.MinWidth <> Min then
        begin
          // needed to fix bug in TSplitView
          Constraints.MinWidth := Min + 1;
          Constraints.MinWidth := Min;
        end;
        if OpenedWidth < FMinPinnedWidth then
          OpenedWidth := FMinPinnedWidth;
        CompactWidth := Min;
        ResetMaxConstraints;
        Visible := True;
        case FOpenState of
          osUnpinned:
            begin
              Close;
              DisplayMode := svmOverlay;
              if Assigned(FPtInfoData) then
                FPtInfoData.CloseEmbeddedDetails(nil);
            end;
          osFloating:
            begin
              DisplayMode := svmOverlay;
              Open;
            end;
          osPinned:
            begin
              if OpenedWidth > FMaxPinnedWidth then
                OpenedWidth := FMaxPinnedWidth;
              AdjustForNoteTab;
              if (OpenState = osPinned) and (OpenedWidth >= FMinPinnedWidth)
              then
              begin
                // work around TSplitView bug
                OldMin := Constraints.MinWidth;
                OldCompactWidth := CompactWidth;
                try
                  Constraints.MinWidth := 0;
                  Close;
                  DisplayMode := svmDocked;
                  Open;
                finally
                  CompactWidth := OldCompactWidth;
                  Constraints.MinWidth := OldMin;
                end;
              end
              else
                OpenState := osUnpinned;
            end;
        end;
      end;
    finally
      if (Placement = svpRight) and (OpenState = osUnpinned) then
        Left := Parent.Width - Width;
      frmFrame.pnlPatientSelected.UnlockDrawing;
    end;
  finally
    EndInternalCall;
  end;
end;

procedure TSplitView.SetDisplayMode(const Value: TSplitViewDisplayMode);
var
  i: Integer;
begin
  inherited DisplayMode := Value;
  FOverlay := nil;
  for i := 0 to ComponentCount - 1 do
    if Components[i].ClassType = TWinControl then
    begin
      FOverlay := Components[i] as TWinControl;
      if TMethod(FOverlay.WindowProc).Data <> Self then
      begin
        FOverlayOldWindowProc := FOverlay.WindowProc;
        FOverlay.WindowProc := OverlayWindowProc;
        break;
      end;
    end;
end;

procedure TSplitView.SetOpenState(const Value: TPtInfoDataTypes.TOpenState);
begin
  inherited;
  FWarningDisplayed := False;
  if FOpenState <> Value then
  begin
    if (Value = osUnpinned) and (not CanCloseEmbeddedForm) then
      Exit;
    BeginInternalCall;
    try
      if Value = osClosed then
        FOldOpenState := FOpenState;
      FOpenState := Value;
      if Value = osRestored then
        FOpenState := FOldOpenState;
      ResetOpenState;
    finally
      EndInternalCall;
    end;
  end;
end;

procedure TSplitView.SetPinnedWidth(const Value: Integer);
begin
  inherited;
  if Value < FMinPinnedWidth then
    OpenedWidth := FMinPinnedWidth
  else
    OpenedWidth := Value;
end;

procedure TSplitView.UMMisc(var Message: TMessage);
var
  PageID: Integer;
begin
  if Message.WParam = 0 then
  begin
    if Assigned(FPtInfoData) and (FPtInfoData.ResetPanels) then
    begin
      PageID := frmFrame.TabToPageID(frmFrame.tabPage.TabIndex);
      if PageID <> CT_NOPAGE then
        InitPanels(PageID);
    end;
  end
  else
  begin
    LockDrawing;
    try
      InitPatient;
      PageID := frmFrame.TabToPageID(frmFrame.tabPage.TabIndex);
      if PageID = CT_NOPAGE then
        OpenState := osClosed
      else
        InitPanels(PageID);
    finally
      UnlockDrawing;
    end;
  end;
end;

procedure TSplitView.UpdatePinImages;
var
  imgRefresh, imgPin: TImage;
  PinIndex: Integer;
begin
  if Constraints.MaxWidth < FMinPinnedWidth then
    OpenState := osUnpinned;
  if Placement = svpLeft then
  begin
    imgRefresh := FPtInfoPanelFrame.imgLeft;
    imgPin := FPtInfoPanelFrame.imgRight;
  end
  else
  begin
    imgRefresh := FPtInfoPanelFrame.imgRight;
    imgPin := FPtInfoPanelFrame.imgLeft;
  end;
  imgRefresh.Visible := (not Assigned(FPtInfoData)) or
    FPtInfoData.GeneralParameters.showRefreshButton;
  imgRefresh.Parent.Visible := imgRefresh.Visible;
  if imgRefresh.Visible and (imgRefresh.Tag <> ImageRefreshIndex) then
  begin
    FPtInfoPanelFrame.imgListPtInfo.GetIcon(ImageRefreshIndex,
      imgRefresh.Picture.Icon);
    imgRefresh.Tag := ImageRefreshIndex;
    imgRefresh.Hint := HintText[ImageRefreshIndex];
    imgRefresh.Parent.Hint := imgRefresh.Hint;
    if ScreenReaderActive then
    begin
      (GetParentForm(FPtInfoPanelFrame.pnlLeft.Parent) as TfrmBase508Form).amgrMain.AccessText[FPtInfoPanelFrame.pnlLeft] := 'Press spacebar to ' + imgRefresh.Hint;
      if imgRefresh.Parent.Focused then
        GetScreenReader.Speak('Press spacebar to ' + imgRefresh.Hint)
    end;
  end;
  PinIndex := ord(FOpenState) + PlacementOffset[Placement];
  if (FOpenState in [osUnpinned, osFloating, osPinned]) and
    (imgPin.Tag <> PinIndex) then
  begin
    imgPin.Visible := True;
    imgPin.Parent.Visible := True;
    FPtInfoPanelFrame.imgListPtInfo.GetIcon(PinIndex, imgPin.Picture.Icon);
    imgPin.Tag := PinIndex;
    imgPin.Hint := HintText[ord(FOpenState)];
    if ScreenReaderActive then
    begin
        (GetParentForm(FPtInfoPanelFrame.pnlRight.Parent) as TfrmBase508Form).amgrMain.AccessText[FPtInfoPanelFrame.pnlRight] := 'Press spacebar to ' + imgPin.Hint + ' the Information Panel Section';
        if imgPin.Parent.Focused then
          GetScreenReader.Speak('Press spacebar to ' + imgPin.Hint + ' the Information Panel Section')
    end;
    imgPin.Parent.Hint := imgPin.Hint;
  end;
end;

procedure TSplitView.UpdatePlacement;
var
  MLeft, MRight: Integer;
begin
  if Assigned(FPtInfoData) and Assigned(FPtInfoPanelFrame) then
  begin
    Placement := FPtInfoData.GeneralParameters.PanelPlacement;
    if Placement = svpLeft then
      frmFrame.pnlPtInfoGap.Align := alLeft
    else
      frmFrame.pnlPtInfoGap.Align := alRight;
    MLeft := 0;
    MRight := 0;
    if FPtInfoData.GeneralParameters.PanelPlacement = svpRight then
      MLeft := FalseSplitterWidth
    else
      MRight := FalseSplitterWidth;
    FPtInfoPanelFrame.Margins.Left := MLeft;
    FPtInfoPanelFrame.Margins.Right := MRight;
  end;
end;

end.
