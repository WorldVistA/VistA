unit mCoPayDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORCtrls, UBAConst, VA508AccessibilityManager, rMisc, uConst,
  uSpecialAuthorityEx, Vcl.AppEvnts, fBase508Frame;

type
  TfraCoPayDesc = class(TBase508Frame)
    lblCaption: TStaticText;
    pnlSCandRD: TPanel;
    lblSCDisplay: TLabel;
    memSCDisplay: TCaptionMemo;
    pnlRight: TPanel;
    gpRight: TGridPanel;
    gpMain: TGridPanel;
    pnlBorderLeft: TPanel;
    pnlBorderRight: TPanel;
    sbRight: TScrollBox;
    bHint: TBalloonHint;
    appEvents: TApplicationEvents;
    procedure lblEnter(Sender: TObject);
    procedure lblExit(Sender: TObject);
    procedure gpRightResize(Sender: TObject);
    procedure appEventsMessage(var Msg: TMsg; var Handled: Boolean);
  private
    FlblWidth: array[0..1] of integer;
    FRowHeight: Integer;
    FSpecialAuthorities: TSpecialAuthoritiesEx;
    procedure AdjustLblGrid;
    procedure ConvertShortLabelsToLong;
    procedure InitRowHeight;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AdjustAndGetSize: integer;
    procedure Init(ASpecialAuthorities1, ASpecialAuthorities2: TSpecialAuthoritiesEx);
    procedure LabelCaptionsOn(CaptionsOn : Boolean = true);
  end;

implementation

uses uGlobalVar, rPCE, UBAGlobals, VAUtils, VA508AccessibilityRouter, ORFn;

{$R *.DFM}

type
  TCopayLabel = class(TVA508StaticText)
  private
    FSpecialAuthority: TSpecialAuthorityEx;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  end;

  TCustomHintAccess = class(TCustomHint);

{ TCopayLabel }

procedure TCopayLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  if IsAccel(Message.CharCode, Caption) then
  begin
    Message.Result := 1;
    if Assigned(CustomHint) then
      TCustomHintAccess(CustomHint).ShowHint(Self);
  end
  else
    inherited;
end;

{ TfraCoPayDesc }

constructor TfraCoPayDesc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := FALSE;
  ListSCDisabilities(memSCDisplay.Lines);
  if ScreenReaderActive then
    ConvertShortLabelsToLong;
  FSpecialAuthorities := TSpecialAuthoritiesEx.Create;
end;


destructor TfraCoPayDesc.Destroy;
begin
  FreeAndNil(FSpecialAuthorities);
  inherited;
end;

procedure TfraCoPayDesc.gpRightResize(Sender: TObject);
var
  adj: integer;

begin
  adj :=  (gpRight.Width - FlblWidth[0] - FlblWidth[1]) div 2;
  gpRight.ColumnCollection[0].Value := FlblWidth[0] + adj;
end;

procedure TfraCoPayDesc.Init(ASpecialAuthorities1, ASpecialAuthorities2: TSpecialAuthoritiesEx);
var
  I, Column: Integer;
  ctrl: TControl;
  Row: TRowItem;
  lbl: TCopayLabel;

  procedure Merge(ASpecialAuthorities: TSpecialAuthoritiesEx);
  begin
    if Assigned(ASpecialAuthorities) then
      for var i := 0 to ASpecialAuthorities.Count - 1 do
        if ASpecialAuthorities[i].Visible then
          FSpecialAuthorities[ASpecialAuthorities[i].Code].Visible := True;
  end;

begin
  FSpecialAuthorities.Clear(True);
  Merge(ASpecialAuthorities1);
  Merge(ASpecialAuthorities2);
  InitRowHeight;
  gpRight.BeginUpdate;
  try
    for I := gpRight.ControlCollection.Count - 1 downto 0 do
    begin
      ctrl := gpRight.ControlCollection[I].Control;
      gpRight.ControlCollection.RemoveControl(ctrl);
      ctrl.Free;
    end;
    gpRight.RowCollection.Clear;
    AdjustLblGrid;
    gpRightResize(nil);
    for I := 0 to FSpecialAuthorities.Count - 1 do
      if FSpecialAuthorities[I].Visible then
      begin
        Row := gpRight.RowCollection.Add;
        Row.SizeStyle := ssAbsolute;
        Row.Value := FRowHeight;
        for Column := 0 to 1 do
        begin
          lbl := TCopayLabel.Create(Owner);
          lbl.CustomHint := bHint;
          lbl.StaticLabel.CustomHint := bHint;
          lbl.ParentCustomHint := True;
          lbl.StaticLabel.ParentCustomHint := True;
          lbl.FSpecialAuthority := FSpecialAuthorities[I];
          lbl.Parent := gpRight;
          gpRight.ControlCollection.AddControl(lbl, Column, Row.Index);
          lbl.LabelLayout := tlCenter;
          lbl.ShowHint := True;
          lbl.Hint := FSpecialAuthorities[I].SpecialAuthorityTypeEx.Description;
          lbl.StaticLabel.Hint := lbl.Hint;
          lbl.OnEnter := lblEnter;
          lbl.OnExit := lblExit;
          lbl.TabStop := True;
          if Column = 0 then
          begin
            lbl.Caption := FSpecialAuthorities[I].SpecialAuthorityTypeEx.abbreviation + ' -';
            lbl.Align := alRight;
          end
          else
          begin
            lbl.Caption := FSpecialAuthorities[I].SpecialAuthorityTypeEx.displayName;
            lbl.Align := alLeft;
          end;
        end;
      end;
  finally
    gpRight.EndUpdate;
  end;
end;

procedure TfraCoPayDesc.InitRowHeight;
begin
  FRowHeight := TextHeightByFont(MainFont.Handle, 'Tg') + 2;
end;

procedure TfraCoPayDesc.LabelCaptionsOn(CaptionsOn: Boolean);
var
  lbl: TCopayLabel;
begin
  if Assigned(FSpecialAuthorities) then
    for var i := 0 to gpRight.RowCollection.Count - 1 do
      if gpRight.ControlCollection.Controls[1, i] is TCopayLabel then
      begin
        lbl := gpRight.ControlCollection.Controls[1, i] as TCopayLabel;
        if CaptionsOn then
          lbl.Caption := lbl.FSpecialAuthority.SpecialAuthorityTypeEx.displayName
        else
          lbl.Caption := lbl.FSpecialAuthority.SpecialAuthorityTypeEx.displayText;
      end;
end;

procedure TfraCoPayDesc.lblEnter(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [fsBold];
end;

procedure TfraCoPayDesc.lblExit(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [];
end;

procedure TfraCoPayDesc.Loaded;
begin
  inherited;
  AdjustLblGrid;
  gpRightResize(nil);
end;

function TfraCoPayDesc.AdjustAndGetSize: integer;
begin
  InitRowHeight;
  lblCaption.Height := FRowHeight;
  lblSCDisplay.Height := FRowHeight;
  Result := 0;
  gpRight.RowCollection.BeginUpdate;
  try
    for var i := 0 to gpRight.RowCollection.Count - 1 do
      if gpRight.RowCollection[i].Value > 0 then
      begin
        gpRight.RowCollection[i].Value := FRowHeight;
        inc(Result, FRowHeight);
      end;
    gpRight.Height := Result;
  finally
    gpRight.RowCollection.EndUpdate;
  end;
  if Result < (FRowHeight * 8) then
    Result := (FRowHeight * 8);
  inc(Result, FRowHeight + 14);
end;

procedure TfraCoPayDesc.AdjustLblGrid;
var
  i, j, TextWidth: integer;
  Text: string;
begin
  FlblWidth[0] := 0;
  FlblWidth[1] := 0;
  if Assigned(FSpecialAuthorities) then
  begin
    for i := 0 to FSpecialAuthorities.Count - 1 do
      if FSpecialAuthorities[i].Visible then
      begin
        for j := 0 to 1 do
        begin
          if j = 0 then
            Text := FSpecialAuthorities[i].SpecialAuthorityTypeEx.abbreviation
          else
            Text := FSpecialAuthorities[i].SpecialAuthorityTypeEx.DisplayText;
          TextWidth := TextWidthByFont(MainFont.Handle, Text);
          if FlblWidth[j] < TextWidth then
            FlblWidth[j] := TextWidth;
        end;
      end;
  end;
  inc(FlblWidth[0], 10);
  inc(FlblWidth[1], 10);
  gpRight.Constraints.MinWidth := FlblWidth[0] + FlblWidth[1] + 12;
end;

procedure TfraCoPayDesc.appEventsMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if bHint.ShowingHint then
    case Msg.message of
      WM_LBUTTONDOWN, WM_MBUTTONDOWN, WM_RBUTTONDOWN, WM_XBUTTONDOWN,
      WM_KEYDOWN, WM_SYSKEYDOWN:
        bHint.HideHint;
    end;
end;

procedure TfraCoPayDesc.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    AdjustLblGrid;
    gpRightResize(nil);
  end;
end;

procedure TfraCoPayDesc.ConvertShortLabelsToLong;
var
  lbl: TVA508StaticText;
begin
  for var Row := 0 to gpRight.RowCollection.Count - 1 do
    if gpRight.ControlCollection.Controls[1, Row] is TVA508StaticText then
    begin
      lbl := gpRight.ControlCollection.Controls[1, Row] as TVA508StaticText;
      lbl.Caption := lbl.Hint;
    end;
end;

initialization
  SpecifyFormIsNotADialog(TfraCoPayDesc);

end.
