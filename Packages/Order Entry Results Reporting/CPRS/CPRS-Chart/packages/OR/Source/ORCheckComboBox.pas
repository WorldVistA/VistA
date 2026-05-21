unit ORCheckComboBox;

interface

uses
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Classes,
  System.Types,
  WinApi.Messages,
  ORCtrls,
  VAUtils;

type
  TMainCheckBoxAlignment = (calTop, calBottom, calLeft, calRight);
  TORDropDownStyle = (ddsControl, ddsEdit);

  TORCheckComboBox = class;

  TORCheckComboCheckBoxMain = class(TORCheckBox)
  strict private
    FORCheckCombobox: TORCheckCombobox;
  strict protected
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure Resize; override;
  public
    property ORCheckComboBox: TORCheckCombobox read FORCheckCombobox
      write FORCheckCombobox;
  end;

  TORCheckComboBox = class(TORComboBox)
  strict private
    FIsFirstPaint: Boolean;
    FMainCheckBox: TORCheckComboCheckBoxMain;
    FMainCheckPanel: TPanel;
    FMainCheckBoxAlignment: TMainCheckBoxAlignment;
    FDropdownStyle: TORDropdownStyle; // Is the dropdown the width of the edit or the width of the control
  strict protected
    function FontHeight: Integer;
    function cboYMargin: Integer;
    function MainRect: TRect;
    procedure Resize; override;
    function GetMainCheckBoxChecked: boolean;
    function GetMainCheckBoxCaption: string;
    function GetMainCheckBoxVisible: boolean;
    function GetOnMainCheckboxClick: TNotifyEvent;
    procedure SetMainCheckBoxChecked(const Value: boolean);
    procedure SetMainCheckBoxCaption(const Value: string);
    procedure SetMainCheckBoxVisible(const Value: boolean);
    procedure SetOnMainCheckboxClick(const Value: TNotifyEvent);
    procedure SetMainCheckBoxAlignment(const Value: TMainCheckBoxAlignment);
    property MainCheckPanel: TPanel read FMainCheckPanel write FMainCheckPanel;
    property MainCheckbox: TORCheckComboCheckBoxMain read FMainCheckBox
      write FMainCheckBox;
    procedure UMGotFocus(var Message: TMessage); message UM_GOTFOCUS;
    procedure SetStyle(Value: TORComboStyle); override;
    procedure SetFlatCheckBoxes(const Value: boolean); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure AdjustSizeOfSelf; override;
    function CalcDropDownRect(ADropDownCount, AItemHeight, ATop: Integer): TRect; override;
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    function CalcHeight(AFontHeight: Integer = -1;
      AcboYMargin: Integer = -1): Integer;
  published
    property MainCheckBoxChecked: boolean read GetMainCheckBoxChecked
      write SetMainCheckBoxChecked default False;
    property MainCheckBoxCaption: string read GetMainCheckBoxCaption
      write SetMainCheckBoxCaption;
    property MainCheckBoxVisible: boolean read GetMainCheckBoxVisible
      write SetMainCheckBoxVisible default False;
    property MainCheckBoxAlignment: TMainCheckBoxAlignment
      read FMainCheckBoxAlignment write SetMainCheckBoxAlignment default calTop;
    property OnMainCheckboxClick: TNotifyEvent read GetOnMainCheckboxClick
      write SetOnMainCheckboxClick;
    property DropdownStyle: TORDropdownStyle read FDropdownStyle
      write FDropdownStyle;
  end;

procedure Register;

implementation

uses
  Vcl.Forms,
  System.Math,
  System.SysUtils,
  WinApi.Windows,
  WinApi.UxTheme,
  OrFn;

// TORCheckComboCheckBoxMain
procedure TORCheckComboCheckBoxMain.Resize;
begin
  inherited Resize;
  FORCheckCombobox.Height := FORCheckCombobox.CalcHeight;
end;

procedure TORCheckComboCheckBoxMain.CMFontChanged(var Message: TMessage);
begin
  inherited CMFontChanged(Message);
  if not (csLoading in ORCheckComboBox.ComponentState) then
    ORCheckComboBox.AdjustSizeOfSelf;
end;

// TORCheckComboBox
constructor TORCheckComboBox.Create(AOwner: TComponent);
begin
  FIsFirstPaint := True;
  inherited Create(AOwner);

  ParentColor := True;

  FMainCheckPanel := TPanel.Create(Self);
  FMainCheckPanel.Parent := Self;
  FMainCheckPanel.Align := alTop;
  FMainCheckPanel.BevelOuter := bvNone;
  FMainCheckPanel.BevelInner := bvNone;
  FMainCheckPanel.BorderStyle := bsNone;
  FMainCheckPanel.ParentColor := True;
  FMainCheckPanel.TabStop := False;

  FMainCheckBox := TORCheckComboCheckBoxMain.Create(Self);
  FMainCheckBox.ORCheckComboBox := Self;
  FMainCheckBox.ControlStyle := FMainCheckBox.ControlStyle +
    [csNoDesignVisible];
  FMainCheckBox.Visible := False;
  FMainCheckBox.Parent := FMainCheckPanel;
  FMainCheckBox.ParentColor := True;
  FMainCheckBox.Align := alTop;
  FMainCheckBoxAlignment := calTop;

  FMainCheckBox.TabStop := True;
  FMainCheckBox.TabOrder := 0;
  FMainCheckPanel.TabOrder := 0;

  FMainCheckBox.Flat := FlatCheckBoxes;

  EditBox.ParentColor := True;
end;

destructor TORCheckComboBox.Destroy;
begin
  FreeAndNil(FMainCheckBox);
  FreeAndNil(FMainCheckPanel);
  inherited Destroy;
end;

function TORCheckComboBox.FontHeight: Integer;
begin
  Result := FontHeightPixel(Font.Handle);
end;

function TORCheckComboBox.cboYMargin: Integer;
begin
  if TemplateField then
  begin
    Result := 0;
  end else begin
    Result := CBO_CYMARGIN;
  end;
end;

function TORCheckComboBox.CalcDropDownRect(ADropDownCount,
  AItemHeight, ATop: Integer): TRect;
begin
  // Use of ATop makes no sense, but it's the code that was there. I am using
  // it as a modifier to Left, which is how it seems to be used in the parent,
  // even if it only ever seems to be 0.
  case FDropdownStyle of
    ddsEdit:
      Result.Left := EditControl.Left + ATop;
  else
    Result.Left := ATop;
  end;
  Result.Top := EditControl.Top + EditControl.Height;
  Result.TopLeft := ClientToScreen(Result.TopLeft);
  case FDropdownStyle of
    ddsEdit:
      Result.Width := EditControl.Width - ATop;
  else
    Result.Width := Width;
  end;
  Result.Height := (AItemHeight * ADropDownCount) + CBO_CXFRAME;
end;

function TORCheckComboBox.CalcHeight(AFontHeight: Integer = -1;
  AcboYMargin: Integer = -1): Integer;
begin
  if AFontHeight < 0 then AFontHeight := FontHeight;
  if AcboYMargin < 0 then AcboYMargin := cboYMargin;

  // must be at least as high as text
  Result := Max(AFontHeight + AcboYMargin, Height);

  if Style = orcsDropDown then
  begin
    case MainCheckBoxAlignment of
      calTop, calBottom: // DropDown can only be text height
        if MainCheckBoxVisible then
          Result := FMainCheckBox.Height + AFontHeight + AcboYMargin +
            MainCheckPanel.Margins.Top + MainCheckPanel.Margins.Bottom
        else
          Result := AFontHeight + AcboYMargin;
      calLeft, calRight: // DropDown can only be text height
        Result := AFontHeight + AcboYMargin;
    end;
  end;
end;

function TORCheckComboBox.MainRect: TRect;
begin
  case FMainCheckPanel.Align of
    alTop:
      begin
        Result.Top := FMainCheckPanel.Height;
        Result.Bottom := ClientHeight;
        Result.Left := 0;
        Result.Right := ClientWidth;
      end;
    alBottom:
      begin
        Result.Top := 0;
        Result.Bottom := ClientHeight - FMainCheckPanel.Height;
        Result.Left := 0;
        Result.Right := ClientWidth;
      end;
    alLeft:
      begin
        Result.Top := 0;
        Result.Bottom := ClientHeight;
        Result.Left := FMainCheckPanel.Width;
        Result.Right := ClientWidth;
      end;
    alRight:
      begin
        Result.Top := 0;
        Result.Bottom := ClientHeight;
        Result.Left := 0;
        Result.Right := ClientWidth - FMainCheckPanel.Width;
      end;
  end;
end;

procedure TORCheckComboBox.AdjustSizeOfSelf;
// Adjusts the components of the combobox to fit within the control boundaries
// Note that this specifically does not call inherited when Maincheckbox is
//   visible!

  procedure AdjustSizeOfMainCheckPanel;

    function CheckboxSize(ACheckBox: TCheckBox): TSize;
    // Ask the API for the size of the checkbox itself
    var
      AHandle: HTHEME;
      AControlCanvas: TControlCanvas;
    begin
      AControlCanvas := TControlCanvas.Create;
      try
        AControlCanvas.Control := ACheckBox;
        AHandle := OpenThemeData(Handle, 'BUTTON');
        try
          if not Succeeded(GetThemePartSize(AHandle, AControlCanvas.Handle,
            BP_CHECKBOX, CBS_UNCHECKEDNORMAL, nil, TS_DRAW, Result)) then
          begin
            Result.cx := 0;
            Result.cy := 0;
          end;
        finally
          CloseThemeData(AHandle);
        end;
      finally
        FreeAndNil(AControlCanvas);
      end;
    end;

  var
    APadding, AHeight, AWidth: Integer;
  begin
    if MainCheckBoxVisible then
    begin
      case MainCheckBoxAlignment of
        calTop:
          begin
            EditControl.Align := alTop;
            MainCheckPanel.Align := alTop;
            ListBox.Align := alTop;
            MainCheckBox.Align := alTop;

            ListBox.Top := 0;
            EditControl.Top := 0;
            MainCheckPanel.Top := 0;

            MainCheckPanel.Padding.Left := 0;
            MainCheckPanel.Padding.Right := 0;
            MainCheckPanel.Padding.Top := 0;
            MainCheckPanel.Padding.Bottom := 0;
            MainCheckPanel.TabOrder := 0;
            EditControl.TabOrder := 1;
          end;
        calBottom:
          begin
            EditControl.Align := alTop;
            ListBox.Align := alTop;
            MainCheckPanel.Align := alTop;
            MainCheckBox.Align := alBottom;

            MainCheckPanel.Top := 0;
            ListBox.Top := 0;
            EditControl.Top := 0;

            MainCheckPanel.Padding.Left := 0;
            MainCheckPanel.Padding.Right := 0;
            MainCheckPanel.Padding.Top := 0;
            MainCheckPanel.Padding.Bottom := 0;
            MainCheckPanel.TabOrder := 99;
            EditControl.TabOrder := 0;
          end;
        calLeft:
          begin
            EditControl.Align := alNone;
            ListBox.Align := alNone;
            MainCheckPanel.Align := alLeft;
            if Style = orcsDropDown then
            begin
              MainCheckBox.Align := alTop;
              APadding := (CalcHeight - MainCheckBox.Height) div 2;
              APadding := Max(0, APadding);
              MainCheckPanel.Padding.Top := APadding;
              MainCheckPanel.Padding.Bottom := APadding;
            end else begin
              MainCheckBox.Align := alLeft;
              MainCheckPanel.Padding.Top := 0;
              MainCheckPanel.Padding.Bottom := 0;
            end;
            MainCheckPanel.Padding.Left := MainCheckBox.Margins.Left;
            MainCheckPanel.Padding.Right := MainCheckBox.Margins.Right;
            MainCheckPanel.TabOrder := 0;
            EditControl.TabOrder := 1;
          end;
        calRight:
          begin
            EditControl.Align := alNone;
            ListBox.Align := alNone;
            MainCheckPanel.Align := alRight;
            if Style = orcsDropDown then
            begin
              MainCheckBox.Align := alTop;
              APadding := (CalcHeight - MainCheckBox.Height) div 2;
              APadding := Max(0, APadding);
              MainCheckPanel.Padding.Top := APadding;
              MainCheckPanel.Padding.Bottom := APadding;
            end else begin
              MainCheckBox.Align := alRight;
              MainCheckPanel.Padding.Top := 0;
              MainCheckPanel.Padding.Bottom := 0;
            end;
            MainCheckPanel.Padding.Left := MainCheckBox.Margins.Left;
            MainCheckPanel.Padding.Right := MainCheckBox.Margins.Right;
            MainCheckPanel.TabOrder := 99;
            EditControl.TabOrder := 0;
          end;
      else raise Exception.Create('Alignment not implemented');
      end;

      AHeight := TextHeightByFont(MainCheckBox.Font.Handle,
        MainCheckBox.Caption + 'Yy');
      MainCheckBox.Height := AHeight;
      MainCheckPanel.Height := AHeight + MainCheckBox.Margins.Top +
        MainCheckBox.Margins.Bottom;
      case FMainCheckBoxAlignment of
        calLeft, calRight:
          begin
            AWidth := CheckboxSize(MainCheckBox).cx +
              TextWidthByFont(MainCheckBox.Font.Handle,
              '  ' + MainCheckBox.Caption);
            MainCheckBox.Width := AWidth;
            MainCheckPanel.Width := AWidth + MainCheckBox.Margins.Left +
              MainCheckBox.Margins.Right;
          end;
      end;

      case MainCheckBoxAlignment of
        calTop: MainCheckBox.Align := alTop;
        calBottom: MainCheckBox.Align := alBottom;
        calLeft: if Style = orcsDropDown then MainCheckBox.Align := alTop
          else MainCheckBox.Align := alLeft;
        calRight: if Style = orcsDropDown then MainCheckBox.Align := alTop
          else MainCheckBox.Align := alRight;
      end;

    end else begin
      MainCheckPanel.Height := 0;
      MainCheckPanel.Width := 0;
    end;
  end;

var
  AFontHeight, AcboYMargin: Integer;
begin
  DroppedDown := False;
  AFontHeight := FontHeight;
  AcboYMargin := cboYMargin;
  AdjustSizeOfMainCheckPanel;
  if Style = orcsDropDown then
  begin
    DropBtn.Width := AFontHeight + 6; //same as TORDateBox
    if (Align <> alClient) and (not MainCheckBoxVisible) then
      Height := FontHeight + cboYMargin;
  end else begin
    ListBox.SetBounds(MainRect.Left, MainRect.Top + AFontHeight +
      CBO_CYMARGIN, MainRect.Width, MainRect.Height - AFontHeight -
      CBO_CYMARGIN);
  end;
  EditControl.SetBounds(MainRect.Left, MainRect.Top, MainRect.Width,
    AFontHeight + AcboYMargin);
  if (Assigned(EditPanel)) then
      EditBox.SetBounds(2, 3, EditPanel.Width - 4, EditPanel.Height - 5);
  SetEditRect(MainRect);
end;

procedure TORCheckComboBox.Resize;
begin
  if not (csLoading in ComponentState) then AdjustSizeOfSelf;
  inherited Resize;
end;

procedure TORCheckComboBox.UMGotFocus(var Message: TMessage);
// This specifically does not call inherited!
var
  AFirstFoundControl, ACurControl, AFoundControl: TWinControl;
  AGoForward, AFoundFocusedControl: Boolean;
begin
  AGoForward := Boolean(Message.wParam);
  AFirstFoundControl := nil;
  AFoundControl := nil;
  ACurControl := nil;
  AFoundFocusedControl := False;
  repeat
    if not Assigned(ACurControl) then
    begin
      ACurControl := FindNextControl(ACurControl, AGoForward, True, False);
      AFirstFoundControl := ACurControl;
    end else begin
      ACurControl := FindNextControl(ACurControl, AGoForward, True, False);
      if ACurControl = AFirstFoundControl then ACurControl := nil;
    end;
    AFoundFocusedControl := AFoundFocusedControl or
      (Assigned(ACurControl) and ACurControl.Focused);
    if not Assigned(AFoundControl) and ShouldFocus(ACurControl) then
      AFoundControl := ACurControl;
  until (not Assigned(ACurControl)) or AFoundFocusedControl;
  if Assigned(AFoundControl) and (not AFoundFocusedControl) then
    AFoundControl.SetFocus;
end;

procedure TORCheckComboBox.WMPaint(var Message: TWMPaint);
begin
  if FIsFirstPaint then begin
    // This AdjustSizeOfSelf fixes weird issues with sizing. For instance, the
    // component does NOT want to look right with style orcsSimple and checkbox
    // visible and calBottom aligned without this.
    AdjustSizeOfSelf;
    FIsFirstPaint := False;
  end;
  inherited;
end;

procedure TORCheckComboBox.SetStyle(Value: TORComboStyle);
begin
  inherited SetStyle(Value);
  Height := CalcHeight;
  if not (csLoading in ComponentState) then AdjustSizeOfSelf;
end;

procedure TORCheckComboBox.Invalidate;
begin
  inherited Invalidate;
  FMainCheckPanel.Invalidate;
  FMainCheckBox.Invalidate;
end;

function TORCheckComboBox.GetMainCheckBoxChecked: boolean;
begin
  Result := FMainCheckBox.Checked;
end;

function TORCheckComboBox.GetMainCheckBoxCaption: string;
begin
  Result := FMainCheckBox.Caption;
end;

function TORCheckComboBox.GetMainCheckBoxVisible: boolean;
begin
  Result := FMainCheckBox.Visible;
end;

procedure TORCheckComboBox.SetMainCheckBoxChecked(const Value: boolean);
begin
  FMainCheckBox.Checked := Value;
end;

procedure TORCheckComboBox.SetMainCheckBoxAlignment
  (const Value: TMainCheckBoxAlignment);
begin
  FMainCheckBoxAlignment := Value;
  Height := CalcHeight;
  if not (csLoading in ComponentState) then AdjustSizeOfSelf;
end;

procedure TORCheckComboBox.SetMainCheckBoxCaption(const Value: string);
begin
  FMainCheckBox.Caption := Value;
  if not (csLoading in ComponentState) then AdjustSizeOfSelf;
end;

procedure TORCheckComboBox.SetMainCheckBoxVisible(const Value: boolean);
begin
  FMainCheckBox.Visible := Value;
  if not (csLoading in ComponentState) then AdjustSizeOfSelf;
end;

procedure TORCheckComboBox.SetEnabled(Value: Boolean);
begin
  inherited;
  FMainCheckBox.Enabled := Value;
end;

procedure TORCheckComboBox.SetFlatCheckBoxes(const Value: boolean);
begin
  inherited SetFlatCheckBoxes(Value);
  FMainCheckBox.Flat := Value;
end;

function TORCheckComboBox.GetOnMainCheckboxClick: TNotifyEvent;
begin
  Result := FMainCheckBox.OnClick;
end;

procedure TORCheckComboBox.SetOnMainCheckboxClick(const Value: TNotifyEvent);
begin
  FMainCheckBox.OnClick := Value;
end;

procedure Register;
begin
  RegisterComponents('CPRS', [TORCheckComboBox]);
end;

end.
