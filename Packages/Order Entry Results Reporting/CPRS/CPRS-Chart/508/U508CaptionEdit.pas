unit U508CaptionEdit;

interface

uses
  System.Classes,
  Vcl.Controls,
  Messages,
  ORCtrls,
  U508Extensions;

type
  TCaptionEdit = class(ORCtrls.TCaptionEdit)
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

procedure TCaptionEdit.SetParent(AParent: TWinControl);
begin
  inherited;
  FreeAndNil(FStaticText);
  if not(csDesigning in ComponentState) and Assigned(Parent) and
    ScreenReaderActiveOnStartup then
  begin
    if Assigned(FCaptionComponent) then
      FStaticText := CreateHiddenStaticText(Self, 'Edit',
        FCaptionComponent.Caption)
    else FStaticText := CreateHiddenStaticText(Self, 'Edit', '');
    if FStaticText.Caption = '' then VA508CaptionFromManager;
    DoEnabledChanged;
  end;
end;

procedure TCaptionEdit.VA508CaptionFromManager;
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

procedure TCaptionEdit.Loaded;
begin
  inherited;
  if Assigned(FStaticText) then
  begin
    FStaticText.TabOrder := TabOrder;
    if Assigned(FCaptionComponent) then
      FStaticText.UpdateCaption(FCaptionComponent.Caption)
    else FStaticText.UpdateCaption('');
    if FStaticText.Caption = '' then VA508CaptionFromManager;
  end;
end;

procedure TCaptionEdit.SetCaption(const Value: string);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateCaption(Caption);
end;

procedure TCaptionEdit.DoEnabledChanged;
begin
  if Assigned(FStaticText) then FStaticText.Visible := Visible and not Enabled;
end;

procedure TCaptionEdit.CMVisibleChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TCaptionEdit.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  DoEnabledChanged;
end;

procedure TCaptionEdit.WMSize(var Msg: TMessage);
begin
  inherited;
  if Assigned(FStaticText) then FStaticText.UpdateSize;
end;

end.
