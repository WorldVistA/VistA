unit u508Button;

interface

uses
  SysUtils, Windows, Classes, Controls, StdCtrls, Messages, Forms,
  VA508AccessibilityManager, VAUtils;

type
  //Add dynamic 508 support to the buttons (should be global to CPRS)
  TButton = class(StdCtrls.TButton)
  private
    fMgr: TVA508AccessibilityManager;
    f508Label: TVA508StaticText;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure RegisterWithMGR;
    function GetIsScreenReaderActive: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property IsScreenReaderActive: Boolean read GetIsScreenReaderActive;
  end;

implementation

procedure TButton.WMSize(Var Msg: TMessage);
begin
  inherited;
  if Assigned(f508Label) then
  begin
    f508Label.width := Self.width + 5;
    f508Label.height := Self.height + 5;
  end;
end;

procedure TButton.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if not IsScreenReaderActive then
    exit;

  if not self.Enabled then
  begin
    f508Label := TVA508StaticText.Create(self);
    f508Label.Parent := self.Parent;
    f508Label.SendToBack;
    // self.SendToBack;
    f508Label.TabStop := true;
    f508Label.TabOrder := self.TabOrder;
    f508Label.Caption := ' ' + self.Caption + ' button disabled';
    f508Label.Top := self.Top - 2;
    f508Label.Left := self.Left - 2;
    f508Label.Width := self.Width + 5;
    f508Label.Height := self.Height + 5;
    RegisterWithMGR;
  end
  else
  begin
    FreeAndNil(f508Label);
  end;
end;

constructor TButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fMgr := nil;
end;

function TButton.GetIsScreenReaderActive: Boolean;
begin
  Result := ScreenReaderActive;
end;

procedure TButton.RegisterWithMGR;
var
  aFrm: TCustomForm;
  I: Integer;
begin
  if not assigned(fMgr) then
  begin
    aFrm := GetParentForm(self);

    if not assigned(aFrm) then
      raise Exception.Create('Procedure: RegisterWithMGR - Unable to find parent form for ' + self.Name);

    for I := 0 to aFrm.ComponentCount - 1 do
    begin
      if aFrm.Components[I] is TVA508AccessibilityManager then
      begin
        fMgr := TVA508AccessibilityManager(aFrm.Components[I]);
        break;
      end;
    end;
  end;

  if assigned(fMgr) then
    fMgr.AccessData.EnsureItemExists(f508Label);
end;


end.
