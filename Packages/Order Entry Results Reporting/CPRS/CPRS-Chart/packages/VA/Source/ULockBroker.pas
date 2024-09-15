unit ULockBroker;

interface

// put in seperate unit so it can be shared with PKI package

procedure LockBroker;
procedure UnlockBroker;

implementation

uses
  System.SysUtils,
  System.SyncObjs;

var
  Lock: TCriticalSection = nil;

procedure LockBroker;
// OK to nest calls, as long as they are always paired with UnlockBroker calls
begin
  Lock.Acquire;
end;

procedure UnlockBroker;
begin
  Lock.Release;
end;

initialization

Lock := TCriticalSection.Create;

finalization

FreeAndNil(Lock);

end.
