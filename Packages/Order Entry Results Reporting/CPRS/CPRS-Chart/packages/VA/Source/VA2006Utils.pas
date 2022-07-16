unit VA2006Utils;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, CommCtrl,
  Forms;

type

  //This class exists to workaround TFrame tabstop set to True
  //Known defect with Delphi 2006: http://qc.embarcadero.com/wc/qcmain.aspx?d=12257
  TfraTabStopFalse = class(TFrame)
  private
    function GetTabStop: Boolean;
    procedure SetTabStop(const Value: Boolean);
  published
    property TabStop: Boolean read GetTabStop write SetTabStop stored False;
  end;

// Fixes bug in Delphi 2006, where clicking on a header control section after
// any other section have been added or deleted could cause access violations
procedure FixHeaderControlDelphi2006Bug(HeaderControl: THeaderControl);

implementation

uses
  VAUtils;

type

  THeaderControl2006BugFixer = class(TComponent)
  private
    FHeaderControl: THeaderControl;
    procedure HeaderControlMessageHandler(var Msg: TMessage; var Handled: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor CreateWrapper(HeaderControl: THeaderControl);
  end;

procedure THeaderControl2006BugFixer.HeaderControlMessageHandler
                      (var Msg: TMessage; var Handled: Boolean);
var
  OnSectionClick: TSectionNotifyEvent;
begin
  // BLJ 19 Dec 2016: For some reason, Delphi's short circuit boolean evaluation
  // wasn't short circuiting in the case where Msg.Msg <> CN_NOTIFY.  Changed
  // to a nested IF to force the issue.
  if (Msg.Msg = CN_NOTIFY) then
    if(PHDNotify(Msg.LParam)^.Hdr.code = HDN_ITEMCLICK) then
    begin
      Handled := TRUE;
      Msg.Result := 0;
      OnSectionClick := FHeaderControl.OnSectionClick;
      if assigned(OnSectionClick) then
        OnSectionClick(FHeaderControl, FHeaderControl.Sections[PHDNotify(Msg.lParam)^.Item]);
    end;
end;

procedure THeaderControl2006BugFixer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FHeaderControl) then
  begin
    RemoveMessageHandler(FHeaderControl, HeaderControlMessageHandler);
    Self.Free;
  end;
end;

constructor THeaderControl2006BugFixer.CreateWrapper(HeaderControl: THeaderControl);
begin
  inherited Create(nil);
  FHeaderControl := HeaderControl;
  FHeaderControl.FreeNotification(self);
  AddMessageHandler(HeaderControl, HeaderControlMessageHandler);
end;

procedure FixHeaderControlDelphi2006Bug(HeaderControl: THeaderControl);
begin
  THeaderControl2006BugFixer.CreateWrapper(HeaderControl);
end;

{ TfraTabStopFalse }

function TfraTabStopFalse.GetTabStop: Boolean;
begin
  Result := False;
end;

procedure TfraTabStopFalse.SetTabStop(const Value: Boolean);
begin
 //Do nothing here, just ignore the Value
end;

end.
