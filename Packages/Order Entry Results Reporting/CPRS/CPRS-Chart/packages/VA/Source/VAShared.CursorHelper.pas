unit VAShared.CursorHelper;

interface

uses
  VCL.Controls, VCL.Forms;

type
  TCursorHelper = record helper for TCursor
    public
      procedure Change(aCursor: TCursor);
      procedure Restore;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils;

var
  FCursorStack: TStack<TCursor>;

{ TCursorHelper }

procedure TCursorHelper.Change(aCursor: TCursor);
begin
  If not Assigned(FCursorStack) then
    FCursorStack := TStack<TCursor>.Create;

  FCursorStack.Push(Screen.Cursor);
  Screen.Cursor := aCursor;
end;

procedure TCursorHelper.Restore;
begin
  if not FCursorStack.IsEmpty then
    Screen.Cursor := FCursorStack.Pop;
end;

initialization

finalization
  FreeAndNil(FCursorStack);


end.
