unit U508ORComboBox;

interface

uses
  System.Classes,
  Vcl.Controls,
  Messages,
  ORCtrls,
  U508Extensions;

type
  TORComboBox = class(ORCtrls.TORComboBox)
  private
    FStaticText: TStaticTextFocusRect;
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure VA508CaptionFromManager;
    procedure Loaded; override;
    procedure SetCaption(const Value: string); override;
    procedure DoEnabledChanged;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMVisibleChanged(var Msg: TMessage); message CM_VISIBLECHANGED;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
  end;

implementation

uses
  System.SysUtils;

procedure TORComboBox.SetCaption(const Value: string);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateCaption(Caption);
end;

procedure TORComboBox.SetParent(AParent: TWinControl);
begin
  inherited;
  FreeAndNil(FStaticText);
  if not(csDesigning in ComponentState) and Assigned(Parent) and
    ScreenReaderActiveOnStartup then
  begin
    FStaticText := CreateHiddenStaticText(Self, 'Edit Combo',
      inherited Caption);
    if FStaticText.Caption = '' then VA508CaptionFromManager;
    DoEnabledChanged;
  end;
end;

procedure TORComboBox.VA508CaptionFromManager;
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

procedure TORComboBox.Loaded;
begin
  inherited;
  if Assigned(FStaticText) then
  begin
    FStaticText.TabOrder := TabOrder;
    FStaticText.UpdateCaption(inherited Caption);
    if FStaticText.Caption = '' then VA508CaptionFromManager;
  end;
end;

procedure TORComboBox.DoEnabledChanged;
begin
  if Assigned(FStaticText) then FStaticText.Visible := Visible and not Enabled;
end;

procedure TORComboBox.CMVisibleChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TORComboBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TORComboBox.WMSize(var Msg: TMessage);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateSize;
end;

end.
