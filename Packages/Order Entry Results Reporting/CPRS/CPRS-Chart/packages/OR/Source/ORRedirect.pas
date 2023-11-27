unit ORRedirect;

///////////////////////////////////////////////////////////////////////////////
///  This unit intercepts
///  - TWinControl.SetFocus
///  - TCustomForm.SetFocus
///  - The setter proc for property TCustomForm.ActiveControl
///      (TCustomForm.SetActiveControl)
///
///  Call TORRedirect.Start to set up and start the intercepting
///////////////////////////////////////////////////////////////////////////////

interface

type
  TORRedirect = class(TObject)
  private
    class var FIsStarted: Boolean;
  public
    class procedure Start;
    class procedure Stop;
    class procedure Init; // for compatibility
    class property IsStarted: Boolean read FIsStarted;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  Vcl.Consts,
  Vcl.Forms,
  Vcl.Controls,
  DDetours;

var
  SetFocusTrampoline: procedure(Self: TWinControl) = nil;
  FormSetFocusTrampoline: procedure(Self: TCustomForm) = nil;
  SetActiveControlTrampoline: procedure(Self: TCustomForm;
    Control: TWinControl) = nil;

var
  SParentRequiredMatch: string;

function ShouldRaiseFocusException(E: Exception): Boolean;
// Returns true if exception should not be swallowed
begin
  // This Result := False; statement is only here for v32 of CPRS.
  // It should be removed for v33.
  Result := False;
  // Uncomment these lines for v33
  // if not(E is EInvalidOperation) then
  //   Exit(True);
  // Result := (Pos(SCannotFocus, E.Message) <= 0) and
  //   (Pos(SParentRequiredMatch, E.Message) <= 0);
end;

procedure InterceptSetFocus(Self: TWinControl);
begin
  try
    if Assigned(Self) and (not(csDestroying in Self.ComponentState)) then
      SetFocusTrampoline(Self);
  except
    on E: Exception do
      if ShouldRaiseFocusException(E) then
        raise;
  end;
end;

procedure InterceptFormSetFocus(Self: TCustomForm);
begin
  try
    if Assigned(Self) and (not(csDestroying in Self.ComponentState)) then
      FormSetFocusTrampoline(Self);
  except
    on E: Exception do
      if ShouldRaiseFocusException(E) then
        raise;
  end;
end;

procedure InterceptSetActiveControl(Self: TCustomForm; Control: TWinControl);
begin
  try
    if Assigned(Self) and (not(csDestroying in Self.ComponentState)) and
      (not Assigned(Control) or (not(csDestroying in Control.ComponentState)))
    then
      SetActiveControlTrampoline(Self, Control);
  except
    on E: Exception do
      if ShouldRaiseFocusException(E) then
        raise;
  end;
end;

function FindRttiType(ARttiContext: TRttiContext; AClass: TClass): TRttiType;
begin
  Result := ARttiContext.GetType(AClass);
end;

function FindRttiProperty(ARttiContext: TRttiContext; AClass: TClass;
  const APropertyName: string): TRttiProperty;
var
  ARttiType: TRttiType;
begin
  ARttiType := FindRttiType(ARttiContext, AClass);
  if Assigned(ARttiType) then
    Result := ARttiType.GetProperty(APropertyName)
  else
    Result := nil;
end;

function FindPropertySet(ARttiContext: TRttiContext; AClass: TClass;
  APropertyName: string): Pointer;
var
  ARttiProperty: TRttiProperty;
begin
  ARttiProperty := FindRttiProperty(ARttiContext, AClass, APropertyName);
  if Assigned(ARttiProperty) and (ARttiProperty is TRttiInstanceProperty) and
    Assigned(TRttiInstanceProperty(ARttiProperty).PropInfo) then
    Result := TRttiInstanceProperty(ARttiProperty).PropInfo^.SetProc
  else
    Result := nil;
end;

procedure StartIntercepting;
var
  AHandle: THandle;
  ARttiContext: TRttiContext;
  APropSetAddr: pointer;
begin
  AHandle := BeginTransaction;
  try
    SParentRequiredMatch := Copy(SParentRequired, Length(SParentRequired)
      - 19, 20);

    // Set up the interception of TWinControl.SetFocus
    SetFocusTrampoline := InterceptCreate(@TWinControl.SetFocus,
      @InterceptSetFocus);

    // Set up the interception of TCustomForm.SetFocus
    FormSetFocusTrampoline := InterceptCreate(@TCustomForm.SetFocus,
      @InterceptFormSetFocus);

    // Set up the interception of the setter proc for property
    // TCustomForm.ActiveControl
    ARttiContext := TRttiContext.Create;
    try
      APropSetAddr := FindPropertySet(ARttiContext, TCustomForm,
        'ActiveControl');
      if Assigned(APropSetAddr) then
        SetActiveControlTrampoline := InterceptCreate(APropSetAddr,
          @InterceptSetActiveControl);
    finally
      ARttiContext.Free;
    end;

  finally
    EndTransaction(AHandle);
  end;
end;

procedure StopIntercepting;
var
  AHandle: THandle;
begin
  AHandle := BeginTransaction;
  try
    InterceptRemove(@SetActiveControlTrampoline);
    SetActiveControlTrampoline := nil;
    InterceptRemove(@FormSetFocusTrampoline);
    FormSetFocusTrampoline := nil;
    InterceptRemove(@SetFocusTrampoline);
    SetFocusTrampoline := nil;
  finally
    EndTransaction(AHandle);
  end;
end;

// TORRedirect
class procedure TORRedirect.Start;
begin
  if not FIsStarted then
  begin
    try
      StartIntercepting;
      FIsStarted := True;
    except
      StopIntercepting;
      raise;
    end;
  end;
end;

class procedure TORRedirect.Stop;
begin
  if FIsStarted then
  begin
    try
      StopIntercepting;
    finally
      FIsStarted := False;
    end;
  end;
end;

class procedure TORRedirect.Init;
begin
  Start;
end;

initialization

finalization

TORRedirect.Stop;

end.
