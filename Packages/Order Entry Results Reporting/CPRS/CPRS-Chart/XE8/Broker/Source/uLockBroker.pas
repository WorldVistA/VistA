unit uLockBroker;

interface

// put in seperate unit so it can be shared with PKI package

procedure LockBroker;  // OK to nest calls as long as always paired with UnlockBroker calls
procedure UnlockBroker;

implementation

uses
  System.SyncObjs;

var
  uLock: TCriticalSection = nil;

procedure LockBroker;  // OK to nest calls as long as always paired with UnlockBroker calls
begin
  uLock.Acquire;
end;

procedure UnlockBroker;
begin
  uLock.Release;
end;

initialization
  uLock := TCriticalSection.Create;

finalization
  uLock.Free;

end.
