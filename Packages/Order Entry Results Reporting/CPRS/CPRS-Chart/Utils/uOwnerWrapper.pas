unit uOwnerWrapper;

{ What this is, and why it's needed:

  The Problem:

  1) Order Menu or Order Set or Reminder Dialog calls ActivateOrderDialog.  The
  Dialog created is an auto-accept quick order, so the dialog is created but
  never displayed to the user.  The calling form (order menu, order set or
  reminder dialog) is the owner of the hidden order dialog.

  2) While the dialog is running the user hits ESC or Alt-F4 or something to
  close the parent dialog (the order menu, or order set, etc.), sending a
  WM_CLOSE message to the parent form

  3) Because it's an auto-accept quick order ActivateOrderDialog calls
  cmdAcceptClick to process the hidden dialog.

  4) There are places in cmdAcceptClick that ends up calling
  TResponsiveGUI.ProcessMessages.  This causes the parent form to process
  the waiting WM_CLOSE message, which ends up destroying all it's owned
  components, including the order dialog

  5) cmdAcceptClick keeps running, expecting Self to be valid, when the order
  dialog has been destroyed, thus causing access violations.


  The Solution

  1) When the order dialog is created, a wrapper owner component is created that
  becomes the order dialog's owner, rather than the calling form (order menu,
  order set, etc.).  A Notification component is created that is added to the
  calling form's owned components.

  2) When the order dialog is working, it calls LockWrapper and UnlockWrapper in
  a try/finally block, to signal that it's not to be destroyed if it's parent
  is destroyed, while inside this block of code.

  3) If the calling form is destroyed, it destroys the Notificaation component.
  The notification compoent has a link to the Wrapper component, and looks to
  see if the weapper it locked.  If it is, the Wrapper is placed in a Queue
  list of components waiting destruction when UnlockWrapper is called.  If the
  wrapper is not locked it destroys the wrapper, whick subsequently destroys
  the order dialog.


  This wrapper functionality has been placed in a seperate unit from uOrders in
  case some other code runs into a similar problem and needs to use it.
}

interface

uses
  System.Classes, vcl.Controls;

function CreateWrappedComponent(Owner: TComponent; ComponentClass: TComponentClass): TComponent;
function UnwrappedOwner(obj: TComponent): TComponent;
procedure LockOwnerWrapper(obj: TComponent);
procedure UnlockOwnerWrapper(obj: TComponent);

implementation

uses
  vcl.Forms, System.Generics.Collections, uConst, WinAPI.Messages, WinAPI.Windows;

type
  TNotifier = class;

  TWrapper = class(TComponent)
  private
    FNotifier: TNotifier;
    FLockCount: integer;
    FNotified: boolean;
    FChild: TComponent;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
  end;

  TNotifier = class(TComponent)
  private
    FWrapper: TWrapper;
  public
    destructor Destroy; override;
  end;

var
  WaitingWrappers: TList<TWrapper> = nil;

function CreateWrappedComponent(Owner: TComponent; ComponentClass: TComponentClass): TComponent;
var
  Notifier: TNotifier;
  Wrapper: TWrapper;

begin
  if (Owner = nil) or (Owner = Application) then
  begin
    Result := ComponentClass.Create(Owner);
    exit;
  end;
  Wrapper := TWrapper.Create(Application);
  Result := ComponentClass.Create(Wrapper);
  Wrapper.FChild := Result;
  Notifier := TNotifier.Create(Owner);
  Wrapper.FNotifier := Notifier;
  Notifier.FWrapper := Wrapper;
end;

function UnwrappedOwner(obj: TComponent): TComponent;
begin
  if assigned(obj) then
  begin
    Result := obj.Owner;
    if assigned(Result) and (Result is TWrapper) and assigned(TWrapper(Result).FNotifier) then
      Result := TWrapper(Result).FNotifier.Owner;
  end
  else
    Result := nil;
end;

procedure LockOwnerWrapper(obj: TComponent);
begin
  if assigned(obj) and assigned(obj.Owner) and (obj.Owner is TWrapper) then
    inc(TWrapper(obj.Owner).FLockCount);
end;

procedure UnlockOwnerWrapper(obj: TComponent);
var
  idx: integer;
  w: TWrapper;

begin
  if assigned(obj) and assigned(obj.Owner) and (obj.Owner is TWrapper) then
  begin
    w := TWrapper(obj.Owner);
    if w.FLockCount > 0 then
      dec(w.FLockCount);
    if (w.FLockCount = 0) and assigned(WaitingWrappers) then
    begin
      idx := WaitingWrappers.IndexOf(w);
      if (idx >= 0) and not (csDestroying in WaitingWrappers[idx].ComponentState) then
        WaitingWrappers[idx].Free;
    end;
  end;
end;

{ TWrapper }

destructor TWrapper.Destroy;
var
  idx: integer;

begin
  if assigned(FNotifier) then
  begin
    FNotifier.FWrapper := nil;
    if not (csDestroying in FNotifier.ComponentState) then
      FNotifier.Free;
  end;
  if assigned(WaitingWrappers) then
  begin
    idx := WaitingWrappers.IndexOf(Self);
    if idx >= 0 then
      WaitingWrappers.Delete(idx);
  end;
  inherited;
end;

procedure TWrapper.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (not FNotified) and assigned(Self) and
    (AComponent = FChild) and (not (csDestroying in ComponentState)) then
  begin
    FNotified := true;
    PostMessage(Application.Handle, UM_OBJDESTROY, WParam(Self), 0);
  end;
end;

{ TNotifier }

destructor TNotifier.Destroy;
begin
  if assigned(FWrapper) then
  begin
    FWrapper.FNotifier := nil;
    if FWrapper.FLockCount > 0 then
    begin
      if not assigned(WaitingWrappers) then
        WaitingWrappers := TList<TWrapper>.Create;
      if WaitingWrappers.IndexOf(FWrapper) < 0 then
        WaitingWrappers.Add(FWrapper);
    end
    else if not (csDestroying in FWrapper.ComponentState) then
      FWrapper.Free;
  end;
  inherited;
end;

initialization

finalization

if assigned(WaitingWrappers) then
begin
  while WaitingWrappers.Count > 0 do
    WaitingWrappers[WaitingWrappers.Count - 1].Free;
  WaitingWrappers.Free;
end;

end.
