unit u508Button;

interface

uses
  SysUtils, Windows, Classes, Controls, Vcl.StdCtrls, Messages, Forms,
  VA508AccessibilityManager, VAUtils, u508Extensions;

type
  TButton = class(Vcl.StdCtrls.TButton)
  private
    FStaticText: TStaticTextFocusRect;
    fClicking: boolean;
    fIgnore508StateChange: Boolean;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure SetIgnore508StateChange(const Value: Boolean);
  protected
    procedure Loaded; override;
  public
    constructor Create(AControl: TComponent); override;
    procedure Click; override;
    property Ignore508StateChange: Boolean read fIgnore508StateChange write SetIgnore508StateChange;
  end;

implementation

constructor TButton.Create(AControl: TComponent);
begin
  inherited Create(AControl);
  fIgnore508StateChange := false;
end;

procedure TButton.Loaded;
begin
  inherited;
  if not(csDesigning in ComponentState) then
    if ScreenReaderActiveOnStartup and not Enabled then
    begin
      if (FStaticText = nil) and (not fIgnore508StateChange) then
        FStaticText := CreateHiddenStaticText(Self, 'Button', Caption);
    end;
end;

procedure TButton.SetIgnore508StateChange(const Value: Boolean);
begin
  If fIgnore508StateChange <> Value then
  begin
    fIgnore508StateChange := Value;
    FreeAndNil(FStaticText);
  end;
end;

procedure TButton.Click;
begin
  if fClicking then
    exit;
  fClicking := True;
  try
    inherited;
  finally
    fClicking := False;
  end;
end;

procedure TButton.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if not(csLoading in ComponentState) then
    if ScreenReaderActiveOnStartup then
    begin
      if (not Enabled) and (not fIgnore508StateChange) then
        FStaticText := CreateHiddenStaticText(Self, 'Button', Caption)
      else
        FreeAndNil(FStaticText);
    end;
end;

procedure TButton.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if (FStaticText <> nil) and (not fIgnore508StateChange) then
    FStaticText.UpdateCaption(Caption);
end;

procedure TButton.WMSize(var Msg: TMessage);
begin
  inherited;
  if (FStaticText <> nil) and (not fIgnore508StateChange) then
    FStaticText.UpdateSize;
end;

end.
