unit VAInfoDialog;

interface

uses
  System.Classes,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Winapi.Windows;

const
  NilNotifyEvent: TNotifyEvent = nil;

type
  TVAInfoDialog = class
  private type
    TButtonInfo = record
      Button: TButton;
      TextWidth: integer;
      ButtonWidth: integer;
    end;

  public type
    // dbsNormal: Uses the same button sizes that are generated by
    //            CreateMessageDialog.  If button sizes would cut off the text
    //            of one or more buttons, or if this will make one or more
    //            buttons appear outside the dialog, dbsMax will be used instead.
    // dbsMax:    Make all buttons the same size based on the length of the
    //            button caption with the longest caption.  If this will make
    //            one or more buttons appear outside the dialog dbsAuto will
    //            be used instead.
    // dbsAuto:   Button are sized based on the length of each button's caption
    TDialogButtonSizing = (dbsNormal, dbsMax, dbsAuto);
    TStringArray = array of string;
    TEventArray = array of TNotifyEvent;

    TFeatures = record
    public
      DialogButtonSizing: TDialogButtonSizing;
      mrDefault: integer;
      mrCancel: integer;
      FontSize: integer;
      OnBeforeShow: TNotifyEvent;
      OnAfterClose: TNotifyEvent;
      CheckBoxVisible: Boolean;
      CheckBoxCaption: string;
      CheckBoxOnClick: TNotifyEvent;
      class operator Initialize(out Dest: TFeatures);
    end;

    TOutput = record
    public
      CheckBoxChecked: Boolean;
    end;

  private
    class procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: Boolean);

  public
    class function Show(const Text, Caption: string; DlgType: TMsgDlgType;
      ModalResults: array of integer): integer; overload;

    class function Show(const Text, Caption: string; DlgType: TMsgDlgType;
      ModalResults: array of integer; const Features: TFeatures;
      ButtonCaption: TStringArray = []; ButtonOnClick: TEventArray = [])
      : integer; overload;

    class function Show(const Text, Caption: string; DlgType: TMsgDlgType;
      ModalResults: array of integer; const Features: TFeatures;
      out Output: TOutput; ButtonCaption: TStringArray = [];
      ButtonOnClick: TEventArray = []): integer; overload;
  end;

implementation

uses
  System.SysUtils,
  System.UITypes,
  Vcl.Consts,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  VAUtils;

type
  TStaticText4ScreenReader = class(TStaticText)
  private
    FTimer: TTimer;
    FDefaultButton, FFirstButton: TButton;
    FFocusOnDefault: Boolean;
    procedure LblTimer(Sender: TObject);
    procedure LblEnter(Sender: TObject);
    procedure LblKeyPress(Sender: TObject; var Key: Char);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TStaticText4ScreenReader }

constructor TStaticText4ScreenReader.Create(AOwner: TComponent);
var
  cc: integer;
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 500;
  FTimer.Enabled := False;
  FTimer.OnTimer := LblTimer;
  OnEnter := LblEnter;
  OnKeyPress := LblKeyPress;
  FFocusOnDefault := True;
  if (AOwner is TForm) and ((AOwner as TForm).ActiveControl is TButton) then
  begin
    FDefaultButton := (AOwner as TForm).ActiveControl as TButton;
    FDefaultButton.Default := False;
    for cc := 0 to FDefaultButton.Parent.ControlCount - 1 do
      if (FDefaultButton.Parent.Controls[cc] is TButton) then
      begin
        FFirstButton := (FDefaultButton.Parent.Controls[cc] as TButton);
        break;
      end;
  end;
end;

procedure TStaticText4ScreenReader.LblTimer(Sender: TObject);
begin
  FTimer.Enabled := False;
  if FFocusOnDefault then
  begin
    if ShouldFocus(FDefaultButton) then
      FDefaultButton.SetFocus;
    FFocusOnDefault := False;
  end
  else
  begin
    if ShouldFocus(FFirstButton) then
      FFirstButton.SetFocus
    else if ShouldFocus(FDefaultButton) then
      FDefaultButton.SetFocus;
  end;
end;

procedure TStaticText4ScreenReader.LblEnter(Sender: TObject);
begin
  FTimer.Enabled := True;
end;

procedure TStaticText4ScreenReader.LblKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, [#13, ' ']) and Assigned(FDefaultButton) then
    FDefaultButton.Click;
end;

{ TVAInfoDialog }

class procedure TVAInfoDialog.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  with (Sender as TScrollBox).VertScrollBar do
    Position := Position - WheelDelta;
  Handled := True;
end;

class function TVAInfoDialog.Show(const Text, Caption: string;
  DlgType: TMsgDlgType; ModalResults: array of integer): integer;
var
  Features: TFeatures;
begin
  Result := Show(Text, Caption, DlgType, ModalResults, Features);
end;

class function TVAInfoDialog.Show(const Text, Caption: string;
  DlgType: TMsgDlgType; ModalResults: array of integer;
  const Features: TFeatures; ButtonCaption: TStringArray = [];
  ButtonOnClick: TEventArray = []): integer;
var
  Output: TOutput;
begin
  Result := Show(Text, Caption, DlgType, ModalResults, Features, Output,
    ButtonCaption, ButtonOnClick);
end;

type
  TExposedLabel = class(TLabel);

class function TVAInfoDialog.Show(const Text, Caption: string;
  DlgType: TMsgDlgType; ModalResults: array of integer;
  const Features: TFeatures; out Output: TOutput;
  ButtonCaption: TStringArray = []; ButtonOnClick: TEventArray = []): integer;
const
  MAX_BUTTONS = ord(high(TMsgDlgBtn)) + 1;
var
  BtnCount, MaxWidth, BorderGap, LabelGap, CtrlTop, CtrlBottom: integer;
  Dlg: TForm;
  MessageLabel: TExposedLabel;
  CheckBox: TCheckBox;
  WorkArea: TRect;

  procedure CheckLen(Len: integer);
  begin
    if Len > MAX_BUTTONS then
      raise Exception.Create(ClassName + ' cannot have more than ' +
        IntToStr(MAX_BUTTONS) + ' buttons.');
    if BtnCount < Len then
      BtnCount := Len;
  end;

  procedure ManageButtonsAndWidth;
  const
    BTN_MIN_GAP = 2;
    BTN_MIN_PAD = 6;
    BTN_PAD_MULT = 4;
    BTN_MARGIN_MULT = 8;
  var
    btns: array of TButtonInfo;
    maxTextWidth, totalButtonWidth, btnGap, btnPad, btnMargin: integer;

    procedure InitBtns;
    var
      UseBtnSize: TDialogButtonSizing;
      ChangeNeeded: Boolean;

      procedure SetButtonWidths;
      var
        i: integer;
      begin
        totalButtonWidth := (btnGap * BtnCount) + btnMargin;
        for i := 0 to BtnCount do
        begin
          case UseBtnSize of
            dbsNormal:
              btns[i].ButtonWidth := btns[i].Button.Width;
            dbsAuto:
              btns[i].ButtonWidth := btns[i].TextWidth + btnPad;
            dbsMax:
              btns[i].ButtonWidth := maxTextWidth + btnPad;
          end;
          inc(totalButtonWidth, btns[i].ButtonWidth);
        end;
        ChangeNeeded := (totalButtonWidth > MaxWidth);
      end;

      function BtnModalResult(Index: integer): integer;
      begin
        if length(ModalResults) > Index then
          Result := ModalResults[Index]
        else
          Result := mrNone;
      end;

      function BtnCaption(Index: integer): string;
      begin
        Result := '';
        if (length(ButtonCaption) > Index) and (ButtonCaption[Index] <> '') then
          Exit(ButtonCaption[Index]);
        case BtnModalResult(Index) of
          mrOk:
            Result := LoadResString(@SMsgDlgOk);
          mrCancel:
            Result := LoadResString(@SMsgDlgCancel);
          mrAbort:
            Result := LoadResString(@SMsgDlgAbort);
          mrRetry:
            Result := LoadResString(@SMsgDlgRetry);
          mrIgnore:
            Result := LoadResString(@SMsgDlgIgnore);
          mrYes:
            Result := LoadResString(@SMsgDlgYes);
          mrNo:
            Result := LoadResString(@SMsgDlgNo);
          mrClose:
            Result := LoadResString(@SMsgDlgClose);
          mrHelp:
            Result := LoadResString(@SMsgDlgHelp);
          mrTryAgain:
            Result := '&Try Again';
          mrContinue:
            Result := 'Continue';
          mrAll:
            Result := LoadResString(@SMsgDlgAll);
          mrNoToAll:
            Result := LoadResString(@SMsgDlgNoToAll);
          mrYesToAll:
            Result := LoadResString(@SMsgDlgYesToAll);
        end;
      end;

      function BtnOnClick(Index: integer): TNotifyEvent;
      begin
        if length(ButtonOnClick) > Index then
          Result := ButtonOnClick[Index]
        else
          Result := nil;
      end;

    var
      DefaultNeeded, CancelNeeded: Boolean;

      procedure UpdateDefaultAndCancelAsNeeded;
      var
        i, idxOK, idxYes, idxRetry, idxCancel, idxNo: integer;
      begin
        if DefaultNeeded or CancelNeeded then
        begin
          idxOK := -1;
          idxYes := -1;
          idxRetry := -1;
          idxCancel := -1;
          idxNo := -1;
          for i := 0 to BtnCount do
            case BtnModalResult(i) of
              mrOk:
                if idxOK < 0 then
                  idxOK := i;
              mrYes:
                if idxYes < 0 then
                  idxYes := i;
              mrRetry:
                if idxRetry < 0 then
                  idxRetry := i;
              mrCancel:
                if idxCancel < 0 then
                  idxCancel := i;
              mrNo:
                if idxNo < 0 then
                  idxNo := i;
            end;
          if DefaultNeeded then
          begin
            if idxOK >= 0 then
              i := idxOK
            else if idxYes >= 0 then
              i := idxYes
            else if idxRetry >= 0 then
              i := idxRetry
            else
              i := -1;
            if i >= 0 then
            begin
              btns[i].Button.Default := True;
              Dlg.SetFocusedControl(btns[i].Button);
            end;
          end;
          if CancelNeeded then
          begin
            if idxCancel >= 0 then
              i := idxCancel
            else if idxNo >= 0 then
              i := idxNo
            else if idxOK >= 0 then
              i := idxOK
            else
              i := -1;
            if i >= 0 then
              btns[i].Button.Cancel := True;
          end;
        end;
      end;

      procedure SetButtonVars;
      var
        SavedbtnGap, SavedbtnPad, SavedbtnMargin: integer;
      begin
        UseBtnSize := Features.DialogButtonSizing;
        CtrlBottom := CtrlBottom + btns[0].Button.Height;
        btnGap := Dlg.Font.Size + 1;
        btnPad := btnGap * BTN_PAD_MULT;
        btnMargin := btnGap * BTN_MARGIN_MULT;
        SavedbtnGap := btnGap;
        SavedbtnPad := btnPad;
        SavedbtnMargin := btnMargin;
        if (UseBtnSize = dbsNormal) and
          (btns[0].Button.Width < (maxTextWidth + btnPad)) then
          UseBtnSize := dbsMax;
        SetButtonWidths;
        if ChangeNeeded and (UseBtnSize = dbsNormal) and
          (btns[0].ButtonWidth > (maxTextWidth + btnPad)) then
        begin
          UseBtnSize := dbsMax;
          SetButtonWidths;
        end;
        while ChangeNeeded do
        begin
          if btnGap > BTN_MIN_GAP then
          begin
            dec(btnGap);
            btnPad := btnGap * BTN_PAD_MULT;
            btnMargin := btnGap * BTN_MARGIN_MULT;
          end
          else if btnPad > BTN_MIN_PAD then
          begin
            dec(btnPad);
            btnMargin := btnGap * BTN_MARGIN_MULT;
          end
          else
            dec(btnMargin); // allowed to go negative
          SetButtonWidths;
          if (btnMargin < 0) and (UseBtnSize <> dbsAuto) then
          begin
            UseBtnSize := dbsAuto;
            btnGap := SavedbtnGap;
            btnPad := SavedbtnPad;
            btnMargin := SavedbtnMargin;
            SetButtonWidths;
          end;
        end;
      end;

    var
      i, bidx, temp: integer;
      btn: TButton;
    begin
      bidx := 0;
      DefaultNeeded := True;
      CancelNeeded := True;
      maxTextWidth := 0;
      for i := 0 to Dlg.ComponentCount - 1 do
      begin
        if (Dlg.Components[i] is TButton) then
        begin
          btn := TButton(Dlg.Components[i]);
          btns[bidx].Button := btn;
          btn.Caption := BtnCaption(bidx);
          btn.ModalResult := BtnModalResult(bidx);
          btn.OnClick := BtnOnClick(bidx);
          if DefaultNeeded and (Features.mrDefault > 0) and
            (btn.ModalResult = Features.mrDefault) then
          begin
            btn.Default := True;
            DefaultNeeded := False;
            Dlg.SetFocusedControl(btn);
          end
          else
            btn.Default := False;
          if CancelNeeded and (Features.mrCancel > 0) and
            (btn.ModalResult = Features.mrCancel) then
          begin
            btn.Cancel := True;
            CancelNeeded := False;
          end
          else
            btn.Cancel := False;
          temp := Dlg.Canvas.TextWidth(btn.Caption);
          btns[bidx].TextWidth := temp;
          if maxTextWidth < temp then
            maxTextWidth := temp;
          inc(bidx);
        end;
      end;
      UpdateDefaultAndCancelAsNeeded;
      SetButtonVars;
    end;

  var
    i, x: integer;
  begin
    if BtnCount < 0 then
      Exit;
    SetLength(btns, BtnCount + 1);
    try
      InitBtns;
      x := WorkArea.Width div 4;
      if Dlg.Width < x then
        Dlg.Width := x;
      if Dlg.ClientWidth < totalButtonWidth then
        Dlg.ClientWidth := totalButtonWidth;
      if Dlg.ClientWidth > MaxWidth then
        Dlg.ClientWidth := MaxWidth;
      MessageLabel.Width := Dlg.ClientWidth - LabelGap - MessageLabel.Left;
      MessageLabel.AdjustBounds;
      x := CtrlBottom - CtrlTop;
      CtrlTop := MessageLabel.Top + MessageLabel.Height + BorderGap;
      CtrlBottom := CtrlTop + x;
      btnMargin := Dlg.ClientWidth - totalButtonWidth + btnMargin;
      x := btnMargin div 2;
      for i := 0 to BtnCount do
      begin
        btns[i].Button.Left := x;
        btns[i].Button.Width := btns[i].ButtonWidth;
        btns[i].Button.Top := CtrlTop;
        inc(x, btns[i].ButtonWidth + btnGap);
      end;
    finally
      SetLength(btns, 0);
    end;
  end;

  procedure AddCheckBox;
  begin
    if not Features.CheckBoxVisible then
      Exit;
    if not Assigned(Dlg) then
      raise Exception.Create('Dialog unassigned');
    CheckBox := TCheckBox.Create(Dlg);
    CheckBox.Parent := Dlg;
    CheckBox.Caption := Features.CheckBoxCaption;
    CheckBox.OnClick := Features.CheckBoxOnClick;
    CheckBox.Width := Dlg.Canvas.TextWidth(Features.CheckBoxCaption) + 20;
    CheckBox.Height := Dlg.Canvas.TextHeight(Features.CheckBoxCaption);
    CheckBox.Top := CtrlBottom + BorderGap;
    CtrlBottom := CheckBox.Top + CheckBox.Height;
    CheckBox.Left := MessageLabel.Left;
  end;

  procedure AddScreenReaderLabelIfNeeded;
  var
    Lbl: TStaticText4ScreenReader;
  begin
    if ScreenReaderActive then
    begin
      if not Assigned(Dlg) then
        raise Exception.Create('Dialog unassigned');
      Dlg.Caption := Dlg.Caption + ' Dialog';
      Lbl := TStaticText4ScreenReader.Create(Dlg);
      Lbl.Parent := Dlg;
      Lbl.Top := -1000;
      Lbl.Left := 0;
      Lbl.Caption := Text;
      Lbl.TabStop := True;
      Lbl.TabOrder := 99; // tab order *after* any buttons
      Dlg.SetFocusedControl(Lbl);
    end;
  end;

  procedure AddScrollBoxIfNeeded;
  var
    Idx, Dx: integer;
    BoxWidth, NeededWidth: integer;
    Box: TScrollBox;
  begin
    if not Assigned(Dlg) then
      raise Exception.Create('Dialog unassigned');
    if Dlg.Height > WorkArea.Height then
    begin
      for Idx := 0 to Dlg.ControlCount - 1 do
        if (Dlg.Controls[Idx] is TButton) or (Dlg.Controls[Idx] is TCheckBox)
        then
          Dlg.Controls[Idx].Anchors := [AkLeft, AkBottom];
      Dx := Dlg.Height;
      Dlg.Height := WorkArea.Height - (BorderGap * 2);
      dec(Dx, Dlg.Height);
      dec(CtrlTop, Dx);
      BoxWidth := Dlg.ClientWidth - BorderGap - MessageLabel.Left;
      NeededWidth := MessageLabel.Width + GetSystemMetrics(SM_CXVSCROLL) +
        Dlg.Font.Size;
      Dx := 0;
      if NeededWidth > BoxWidth then
      begin
        Dx := NeededWidth - BoxWidth;
        Dlg.Width := Dlg.Width + Dx;
        inc(BoxWidth, Dx);
        Dx := Dx div 2;
      end;
      for Idx := 0 to Dlg.ControlCount - 1 do
        if (Dlg.Controls[Idx] is TButton) or (Dlg.Controls[Idx] is TCheckBox)
        then
          Dlg.Controls[Idx].Left := Dlg.Controls[Idx].Left + Dx;
      Box := TScrollBox.Create(Dlg);
      Box.Parent := Dlg;
      Box.Left := MessageLabel.Left;
      Box.Width := BoxWidth;
      Box.Top := MessageLabel.Top;
      Box.Height := CtrlTop - (BorderGap * 2);
      Box.VertScrollBar.Tracking := True;
      Box.VertScrollBar.Style := SsHotTrack;
      Box.BorderStyle := BsNone;
      Box.OnMouseWheel := ScrollBoxMouseWheel;
      MessageLabel.Parent := Box;
      MessageLabel.Top := 0;
      MessageLabel.Left := 0;
    end;
  end;

  procedure FindMessageLabel;
  var
    i: integer;
  begin
    MessageLabel := nil;
    for i := 0 to Dlg.ComponentCount - 1 do
      if Dlg.Components[i] is TLabel then
      begin
        MessageLabel := TExposedLabel(Dlg.Components[i]);
        BorderGap := MessageLabel.Top;
        CtrlTop := MessageLabel.Top + MessageLabel.Height + BorderGap;
        CtrlBottom := CtrlTop;
        LabelGap := Dlg.ClientWidth - MessageLabel.Left - MessageLabel.Width;
        if LabelGap > BorderGap then
          LabelGap := BorderGap;
        break;
      end;
  end;

var
  OldFontSize, Dx: integer;
  dbtn: TMsgDlgBtn;
  dbtns: TMsgDlgButtons;
begin
  BtnCount := 0;
  CheckLen(length(ModalResults));
  CheckLen(length(ButtonCaption));
  CheckLen(length(ButtonOnClick));
  dec(BtnCount);
  dbtns := [];
  for dbtn := low(TMsgDlgBtn) to TMsgDlgBtn(BtnCount) do
    dbtns := dbtns + [dbtn];
  if Assigned(Screen.ActiveCustomForm) then
    WorkArea := Screen.ActiveCustomForm.Monitor.WorkareaRect
  else
    WorkArea := Screen.WorkareaRect;
  MaxWidth := Round(WorkArea.Width * 0.9);
  Dlg := nil;
  OldFontSize := Screen.MessageFont.Size;
  try
    Screen.MessageFont.Size := Features.FontSize;
    Dlg := CreateMessageDialog(Text, DlgType, dbtns);
    Dlg.DefaultMonitor := dmDesktop;
    if Caption = '' then
      Dlg.Caption := Application.Title
    else
      Dlg.Caption := Caption;
    FindMessageLabel;
    if not Assigned(MessageLabel) then
      Exit(mrCancel);
    ManageButtonsAndWidth;
    AddCheckBox;
    Dlg.ClientHeight := CtrlBottom + BorderGap;
    AddScreenReaderLabelIfNeeded;
    AddScrollBoxIfNeeded;
    Dx := (WorkArea.Width - Dlg.Width) div 2;
    Dlg.Left := WorkArea.Left + Dx;
    Dx := (WorkArea.Height - Dlg.Height) div 2;
    Dlg.Top := WorkArea.Top + Dx;

    if Assigned(Features.OnBeforeShow) then
      Features.OnBeforeShow(Dlg);

    Result := Dlg.ShowModal;

    if Assigned(Features.OnAfterClose) then
      Features.OnAfterClose(Dlg);

    Output.CheckBoxChecked := Features.CheckBoxVisible and CheckBox.Checked;

  finally
    FreeAndNil(Dlg);
    Screen.MessageFont.Size := OldFontSize;
  end;
end;

{ TVAInfoDialog.TFeatures }

class operator TVAInfoDialog.TFeatures.Initialize(out Dest: TFeatures);
begin
  Dest.DialogButtonSizing := dbsNormal;
  Dest.mrDefault := mrNone;
  Dest.mrCancel := mrNone;
  if Assigned(Application.MainForm) then
    Dest.FontSize := Application.MainForm.Font.Size
  else
    Dest.FontSize := Screen.MessageFont.Size;
  Dest.OnBeforeShow := nil;
  Dest.OnAfterClose := nil;
  Dest.CheckBoxVisible := False;
  Dest.CheckBoxCaption := '';
  Dest.CheckBoxOnClick := nil;
end;

end.