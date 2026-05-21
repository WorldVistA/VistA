unit U508ORCheckComboBox;

interface

uses
  System.Classes,
  Vcl.Controls,
  Messages,
  ORCheckComboBox,
  U508Extensions;

type
  TORCheckComboBox = class(ORCheckComboBox.TORCheckComboBox)
  private
    FStaticText: TStaticTextFocusRect;
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure VA508CaptionFromManager;
    procedure Loaded; override;
    procedure DoEnabledChanged;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMVisibleChanged(var Msg: TMessage); message CM_VISIBLECHANGED;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
  end;

implementation

uses
  System.SysUtils;

procedure TORCheckComboBox.SetParent(AParent: TWinControl);
begin
  inherited;
  FreeAndNil(FStaticText);
  if not(csDesigning in ComponentState) and Assigned(Parent) and
    ScreenReaderActiveOnStartup then
  begin
    FStaticText := CreateHiddenStaticText(Self, 'Edit Combo', '');
    VA508CaptionFromManager;
    DoEnabledChanged;
  end;
end;

procedure TORCheckComboBox.VA508CaptionFromManager;
begin
  if Assigned(FStaticText) then begin
    var Manager := FStaticText.VA508Manager;
    if Assigned(Manager) then
    begin
      var S := Manager.AccessText[Self];
      if S <> '' then FStaticText.UpdateCaption(S);
    end;
  end;
end;

procedure TORCheckComboBox.Loaded;
begin
  inherited;
  if Assigned(FStaticText) then begin
    FStaticText.TabOrder := TabOrder;
    VA508CaptionFromManager;
  end;
end;

procedure TORCheckComboBox.DoEnabledChanged;
begin
  if Assigned(FStaticText) then FStaticText.Visible := Visible and not Enabled;
end;

procedure TORCheckComboBox.CMVisibleChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TORCheckComboBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TORCheckComboBox.WMSize(var Msg: TMessage);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateSize;
end;

end.
