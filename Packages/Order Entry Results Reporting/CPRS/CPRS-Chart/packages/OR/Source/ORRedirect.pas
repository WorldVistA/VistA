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

uses
  Vcl.Forms,
  Vcl.Controls;

type
  TORRedirect = class(TObject)
  private
    class var FOldSetFocus: procedure(Self: TWinControl);
    class var FOldFormSetFocus: procedure(Self: TCustomForm);
    class var FOldSetActiveControl: procedure(Self: TCustomForm;
      Control: TWinControl);
    class var FIsStarted: Boolean;
  protected
    class destructor Destroy;
  public
    class procedure Start;
    class procedure Stop;
    class property IsStarted: Boolean read FIsStarted;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  Vcl.Consts,
  DDetours;

procedure InterceptSetFocus(Self: TWinControl);
begin
  try
    if Assigned(TORRedirect.FOldSetFocus) and
      Assigned(Self) and (not(csDestroying in Self.ComponentState))
    then
      TORRedirect.FOldSetFocus(Self);
  except
    on E: Exception do; // nothing
  end;
end;

procedure InterceptFormSetFocus(Self: TCustomForm);
begin
  try
    if Assigned(TORRedirect.FOldFormSetFocus) and
      Assigned(Self) and (not(csDestroying in Self.ComponentState))
    then
      TORRedirect.FOldFormSetFocus(Self);
  except
    on E: Exception do; // nothing
  end;
end;

procedure InterceptSetActiveControl(Self: TCustomForm; AControl: TWinControl);
begin
  try
    if Assigned(TORRedirect.FOldSetActiveControl) and
      Assigned(Self) and (not(csDestroying in Self.ComponentState)) and
      (not Assigned(AControl) or (not(csDestroying in AControl.ComponentState)))
    then
      TORRedirect.FOldSetActiveControl(Self, AControl);
  except
    on E: Exception do; // nothing
  end;
end;

class destructor TORRedirect.Destroy;
begin
  Stop;
end;

class procedure TORRedirect.Start;

  procedure StartIntercepting;
  var
    AHandle: THandle;
    ASetProc: Pointer;
    ARttiContext: TRttiContext;
    ARttiType: TRttiType;
    ARttiProperty: TRttiProperty;
  begin
    AHandle := BeginTransaction;
    try
      // Set up the interception of TWinControl.SetFocus
      FOldSetFocus := InterceptCreate(@TWinControl.SetFocus,
        @InterceptSetFocus);
      if not Assigned(FOldSetFocus) then
        raise Exception.Create('FOldSetFocus not assigned');

      // Set up the interception of TCustomForm.SetFocus
      FOldFormSetFocus := InterceptCreate(@TCustomForm.SetFocus,
        @InterceptFormSetFocus);
      if not Assigned(FOldFormSetFocus) then
        raise Exception.Create('FOldFormSetFocus not assigned');

      // Set up the interception of the setter proc for property
      // TCustomForm.ActiveControl
      ASetProc := nil;
      ARttiType := ARttiContext.GetType(TCustomForm);
      if Assigned(ARttiType) then
      begin
        ARttiProperty := ARttiType.GetProperty('ActiveControl');
        if Assigned(ARttiProperty) and
          (ARttiProperty is TRttiInstanceProperty) and
          // GetPropInfo is abstract, so I am making sure we get a child of
          // TRttiInstanceProperty, and not an TRttiInstanceProperty
          (ARttiProperty.ClassType <> TRttiInstanceProperty) and
          Assigned(TRttiInstanceProperty(ARttiProperty).PropInfo) then
          ASetProc := TRttiInstanceProperty(ARttiProperty).PropInfo.SetProc;
      end;
      if not Assigned(ASetProc) then
        raise Exception.Create('ASetProc not assigned');
      FOldSetActiveControl := InterceptCreate(ASetProc,
        @InterceptSetActiveControl);
      if not Assigned(FOldSetActiveControl) then
        raise Exception.Create('FOldSetActiveControl not assigned');
    finally
      EndTransaction(AHandle);
    end;
  end;

begin
  if not FIsStarted then
  begin
    try
      FIsStarted := True;
      StartIntercepting;
    except
      Stop;
      raise;
    end;
  end;
end;

class procedure TORRedirect.Stop;

  procedure StopIntercepting;
  var
    AHandle: THandle;
  begin
    AHandle := BeginTransaction;
    try
      InterceptRemove(@FOldSetActiveControl);
      FOldSetActiveControl := nil;
      InterceptRemove(@FOldFormSetFocus);
      FOldFormSetFocus := nil;
      InterceptRemove(@FOldSetFocus);
      FOldSetFocus := nil;
    finally
      EndTransaction(AHandle);
    end;
  end;

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

end.
