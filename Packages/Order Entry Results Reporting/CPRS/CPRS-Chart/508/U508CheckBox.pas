unit U508CheckBox;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Messages,
  U508Extensions;

type
  TCheckBox = class(Vcl.StdCtrls.TCheckBox)
  private
    FStaticText: TStaticTextFocusRect;
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure Loaded; override;
    procedure DoEnabledChanged;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMVisibleChanged(var Msg: TMessage); message CM_VISIBLECHANGED;
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
  end;

implementation

uses
  System.SysUtils;

procedure TCheckBox.SetParent(AParent: TWinControl);
begin
  inherited;
  FreeAndNil(FStaticText);
  if not(csDesigning in ComponentState) and Assigned(Parent) and
    ScreenReaderActiveOnStartup then
  begin
    FStaticText := CreateHiddenStaticText(Self, 'CheckBox', Caption);
    DoEnabledChanged;
  end;
end;

procedure TCheckBox.Loaded;
begin
  inherited;
  if Assigned(FStaticText) then
  begin
    FStaticText.TabOrder := TabOrder;
    FStaticText.UpdateCaption(Caption);
  end;
end;

procedure TCheckBox.DoEnabledChanged;
begin
  if Assigned(FStaticText) then FStaticText.Visible := Visible and not Enabled;
end;

procedure TCheckBox.CMVisibleChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TCheckBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TCheckBox.CMTextChanged(var Msg: TMessage);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateCaption(Caption);
end;

procedure TCheckBox.WMSize(var Msg: TMessage);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateSize;
end;

end.
