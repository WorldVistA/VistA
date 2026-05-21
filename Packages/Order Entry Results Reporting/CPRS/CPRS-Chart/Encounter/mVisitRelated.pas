unit mVisitRelated;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Vcl.StdCtrls, ExtCtrls, rPCE, uPCE, VA508AccessibilityManager, uConst,
  uSpecialAuthorityEx, Vcl.AppEvnts, fBase508Frame;

type
  TStaticText = class(Vcl.StdCtrls.TStaticText)
  private
    FFocused: Boolean;
  protected
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  TVA508Captions = record
   CheckBox: TCheckBox;
   OrigCaption: String;
   OrigWidth: Integer;
   VA508Label: TStaticText;
  end;

  TfraVisitRelated = class(TBase508Frame)
    gbVisitRelatedTo: TGroupBox;
    sbMain: TScrollBox;
    pnlMain: TPanel;
    gpMain: TGridPanel;
    lblYes: TLabel;
    lblNo: TLabel;
    bHint: TBalloonHint;
    appEvents: TApplicationEvents;
    lblNoSAAvailable: TStaticText;
    procedure appEventsMessage(var Msg: TMsg; var Handled: Boolean);
    procedure CheckBoxCaptionQuery(Sender: TObject; var Text: string);
  private
    FSpecialAuthorities: TSpecialAuthoritiesEx;
    VA508Captions: Array of tVA508Captions;
    FOldFocusChanged: TNotifyEvent;
    FLastActiveControl: TWinControl;
    FActiveControl: TWinControl;
    procedure chkClick(Sender: TObject);
    procedure HandleVA508Caption(AWinControl: TWinControl);
    procedure ActiveControlChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetRelated(ASpecialAuthorities: TSpecialAuthoritiesEx);
    procedure InitAllow(ASpecialAuthorities: TSpecialAuthoritiesEx);
    procedure ResizeToFit;
    property SpecialAuthorities: TSpecialAuthoritiesEx read FSpecialAuthorities;
  end;

implementation

uses VA508AccessibilityRouter, VAUtils, ORFn, rMisc, uGlobalVar,
  uSpecialAuthorityTypesEx, System.StrUtils;

{$R *.DFM}

{ TStaticText }

procedure TStaticText.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocused := True;
  Invalidate;
  inherited;
end;

procedure TStaticText.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocused := False;
  Invalidate;
  inherited;
end;
procedure TStaticText.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  R: TRect;
begin
  inherited;
  if FFocused then begin
    DC := GetDC(Handle);
    GetClipBox(DC, R);
    DrawFocusRect(DC, R);
    ReleaseDC(Handle, DC);
  end;
end;

{ TfraVisitRelated }

procedure TfraVisitRelated.ActiveControlChanged(Sender: TObject);
begin
  if Assigned(FOldFocusChanged) then FOldFocusChanged(Sender);
  FLastActiveControl := FActiveControl;

  if Sender is TScreen then
    FActiveControl := TScreen(Sender).ActiveControl
  else
    FActiveControl := nil;
end;

procedure TfraVisitRelated.appEventsMessage(var Msg: TMsg;
  var Handled: Boolean);
begin
  if bHint.ShowingHint then
    case Msg.message of
      WM_LBUTTONDOWN, WM_MBUTTONDOWN, WM_RBUTTONDOWN, WM_XBUTTONDOWN,
      WM_KEYDOWN, WM_SYSKEYDOWN:
        bHint.HideHint;
    end;
end;

procedure TfraVisitRelated.CheckBoxCaptionQuery(Sender: TObject;
  var Text: string);
var
  AComponentAccessibility: TVA508ComponentAccessibility;
  ACheckBox: TSpecialAuthorityCheckBox;
  S: string;
begin
  if not (Sender is TVA508ComponentAccessibility) then Exit;
  AComponentAccessibility := TVA508ComponentAccessibility(Sender);

  if Assigned(AComponentAccessibility.Component) and
    (AComponentAccessibility.Component is TSpecialAuthorityCheckBox) then
  begin
    ACheckBox := TSpecialAuthorityCheckBox(AComponentAccessibility.Component);

    // Read TGroupBox's caption if last active control wasn't a special authority
    S := IfThen(FLastActiveControl is TSpecialAuthorityCheckBox, '', gbVisitRelatedTo.Caption);

    // Read the column name and the special authority text
    S := S + ' Column ';
    if ACheckBox.CheckBoxType = cbtYes then
      S := S + 'Yes' + IfThen(Assigned(ACheckBox.LinkedCheckBox), ACheckBox.LinkedCheckBox.Caption, '')
    else
      S := S + 'No ' + ACheckBox.Caption;

    Text := Trim(S + ' ' + Text);
  end;
end;

procedure TfraVisitRelated.chkClick(Sender: TObject);
begin
  inherited;
  if ScreenReaderActive then
  begin
    if (FActiveControl is TCheckBox) then
    begin
      if (FActiveControl as TCheckBox).Checked then
        GetScreenReader.Speak('Checked')
      else if not (FActiveControl as TCheckBox).Checked then
        GetScreenReader.Speak('Not Checked');
    end;
    HandleVA508Caption(Self);
  end;
end;

constructor TfraVisitRelated.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSpecialAuthorities := TSpecialAuthoritiesEx.Create;
  FOldFocusChanged := Screen.OnActiveControlChange;
  Screen.OnActiveControlChange := ActiveControlChanged;
end;

destructor TfraVisitRelated.Destroy;
begin
  Screen.OnActiveControlChange := FOldFocusChanged;
  SetLength(VA508Captions, 0);
  FreeAndNil(FSpecialAuthorities);
  inherited;
end;

procedure TfraVisitRelated.GetRelated(ASpecialAuthorities: TSpecialAuthoritiesEx);
begin
  ASpecialAuthorities.CopyFrom(FSpecialAuthorities, [ctCopyValues, ctCopyChanged]);
end;

procedure TfraVisitRelated.InitAllow(ASpecialAuthorities: TSpecialAuthoritiesEx);

  procedure SetupCheckBox508(ACheckBox: TSpecialAuthorityCheckBox);
  var
    AComponentAccessibility: TVA508ComponentAccessibility;
  begin
    AComponentAccessibility := TVA508ComponentAccessibility.Create(Owner);
    AComponentAccessibility.Component := ACheckBox;
    AComponentAccessibility.OnCaptionQuery := CheckBoxCaptionQuery;
  end;

const
  CheckBoxSize = 13;
var
  I, RowHeight, YesWidth, NoWidth, YesMargin, NoMargin: Integer;
  Row: TRowItem;
  cbYes, cbNo: TSpecialAuthorityCheckBox;
  APanel: TPanel;
  checkBoxShowing: boolean;
begin
  FSpecialAuthorities.CopyFrom(ASpecialAuthorities, [ctCopyVisible, ctCopyValues,
    ctClearChanged]);
  checkBoxShowing := false;
  gpMain.Visible := true;
  lblNoSAAvailable.Visible := false;
  gpMain.BeginUpdate;
  try
    RowHeight := FontHeightInPixels(MainFont);
    gpMain.RowCollection[0].Value := RowHeight;
    inc(RowHeight, 2);
    if RowHeight < 17 then
      RowHeight := 17;
    YesWidth := FontWidthInPixels(MainFont, lblYes.Caption) - 1;
    if YesWidth < RowHeight then
      YesWidth := RowHeight;
    gpMain.ColumnCollection[0].Value := YesWidth + 5;
    NoWidth := FontWidthInPixels(MainFont, lblNo.Caption) - 1;
    if YesWidth > CheckBoxSize then
      YesMargin := (YesWidth - CheckBoxSize) Div 2
    else
      YesMargin := 0;
    if NoWidth > CheckBoxSize then
      NoMargin := (NoWidth - CheckBoxSize) Div 2
    else
      NoMargin := 0;
    for I := gpMain.ControlCount - 1 downto 0 do
      if gpMain.Controls[I] is TSpecialAuthorityCheckBox then
      begin
        gpMain.ControlCollection.RemoveControl(gpMain.Controls[I]);
        gpMain.Controls[I].Free;
      end;
    for I := gpMain.RowCollection.Count - 1 downto 1 do
      gpMain.RowCollection.Delete(I);
    for I := 0 to FSpecialAuthorities.Count - 1 do
    begin
      if FSpecialAuthorities[I].Visible and
        Assigned(FSpecialAuthorities[I].SpecialAuthorityTypeEx) then
      begin
        checkBoxShowing := true;
        Row := gpMain.RowCollection.Add;
        Row.SizeStyle := ssAbsolute;
        Row.Value := RowHeight;

        cbYes := TSpecialAuthorityCheckBox.Create(Owner, FSpecialAuthorities[I],
          cbtYes, bHint);
        cbYes.Parent := gpMain;
        cbYes.Align := alClient;
        cbYes.FocusOnBox := True;

        if ScreenReaderActive then
          SetupCheckBox508(cbYes);

        if YesMargin > 0 then
        begin
          cbYes.Margins.Left := YesMargin;
          cbYes.Margins.Right := 0;
          cbYes.Margins.Top := 0;
          cbYes.Margins.Bottom := 0;
          cbYes.AlignWithMargins := True;
        end;

        APanel := TPanel.Create(Self);
        APanel.Align := alClient;
        APanel.BevelOuter := bvNone;
        APanel.Parent := gpMain;
        gpMain.ControlCollection.AddControl(APanel, 1, Row.Index);

        cbNo := TSpecialAuthorityCheckBox.Create(Owner, FSpecialAuthorities[I],
          cbtNo, bHint, cbYes);
        cbNo.Parent := APanel;
        cbNo.Align := alClient;

        if ScreenReaderActive then
          SetupCheckBox508(cbNo);

        if NoMargin > 0 then
        begin
          cbNo.Margins.Left := NoMargin;
          cbNo.Margins.Right := 0;
          cbNo.Margins.Top := 0;
          cbNo.Margins.Bottom := 0;
          cbNo.AlignWithMargins := True;
        end;

        cbYes.OnClick := chkClick;
        cbNo.OnClick := chkClick;
      end;
    end;
    pnlMain.Height := RowHeight * (gpMain.RowCollection.Count + 1) + 12;
  finally
    gpMain.EndUpdate;
    if not checkBoxShowing then
    begin
      gpMain.Visible := false;
      lblNoSAAvailable.Visible := true;
    end;
  end;

  FSpecialAuthorities.ApplyDefaults;

  if ScreenReaderActive then
    HandleVA508Caption(Self);

  ResizeToFit;
end;

procedure TfraVisitRelated.HandleVA508Caption(AWinControl: TWinControl);
var
  I, X: Integer;
  LabelExist: Boolean;
  ParentCheckBox: TCheckBox;
begin
  for X := 0 to AWinControl.ControlCount - 1 do
  begin
    if AWinControl.Controls[X] is TCheckBox then
    begin
      ParentCheckBox := TCheckBox(AWinControl.Controls[X]);

      LabelExist := False;
      for I := Low(VA508Captions) to High(VA508Captions) do
      begin
        if VA508Captions[I].CheckBox = ParentCheckBox then
        begin
          LabelExist := True;
          //Setup the caption
          if ParentCheckBox.Enabled then
          begin
            VA508Captions[I].CheckBox.Caption := VA508Captions[I].OrigCaption;
            VA508Captions[I].CheckBox.Width := VA508Captions[I].OrigWidth;
          end else begin
            VA508Captions[I].CheckBox.Caption := '';
            VA508Captions[I].CheckBox.Width := 20;
          end;
          //handle the label's visibility
          VA508Captions[I].VA508Label.Visible := not ParentCheckBox.Enabled;
          Break;
        end;
        if LabelExist then Break;
      end;

      if (not ParentCheckBox.Enabled) and (ParentCheckBox.Visible) and
        (not LabelExist) and (Trim(ParentCheckBox.Caption) <> '') then
      begin
        SetLength(VA508Captions, Length(VA508Captions) + 1);
        with VA508Captions[High(VA508Captions)] do
        begin
          CheckBox := ParentCheckBox;
          OrigCaption := ParentCheckBox.Caption;
          OrigWidth := ParentCheckBox.Width;
          ParentCheckBox.Width := 20;
          ParentCheckBox.Caption := '';

          VA508Label := TStaticText.Create(ParentCheckBox.Owner);
          VA508Label.Parent := ParentCheckBox.Parent;
          VA508Label.Top := ParentCheckBox.Top;
          VA508Label.Left := ParentCheckBox.Left + 15;
          VA508Label.TabStop := True;
          VA508Label.Caption := Trim(OrigCaption) + ' disabled';
          VA508Label.TabOrder := ParentCheckBox.TabOrder;
          VA508Label.Visible := True;
        end;
      end;
    end;

    if AWinControl.Controls[X] is TWinControl then
      HandleVA508Caption(TWinControl(AWinControl.Controls[X]));
  end;
end;

procedure TfraVisitRelated.ResizeToFit;
var
  MinSize, TempSize, Adjustment: Integer;
begin
  MinSize := TextWidthByFont(MainFont.Handle, gbVisitRelatedTo.Caption) + 16;
  Adjustment := Trunc(gpMain.ColumnCollection[0].Value) + (Font.Size * 2) + 30;
  for var i := 0 to FSpecialAuthorities.Count - 1 do
    if FSpecialAuthorities[i].Visible and Assigned(FSpecialAuthorities[i].CheckBox[cbtNo]) then
    begin
      TempSize := Adjustment + FSpecialAuthorities[I].CheckBox[cbtNo]
        .CheckBoxWidth + TextWidthByFont(MainFont.Handle,
        ' ' + FSpecialAuthorities[I].SpecialAuthorityTypeEx.DisplayText);
      if MinSize < TempSize then
        MinSize := TempSize;
    end;
  Width := MinSize;
end;

initialization
  SpecifyFormIsNotADialog(TfraVisitRelated);
end.

