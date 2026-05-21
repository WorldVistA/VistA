unit VAShared.ScreenHelper;

interface

uses
  VCL.Forms;

type
  TScreenHelper = Class helper for TScreen
  public
   function FormByName(FormName: string): TForm;
  End;

implementation

uses
  System.SysUtils;

{ TScreenHelper }

function TScreenHelper.FormByName(FormName: string): TForm;
begin
  Result := nil;
  for var i := 0 to Screen.FormCount - 1 do
  begin
    if string.Compare(Screen.Forms[i].Name, FormName, True) = 0 then
      Exit(Screen.Forms[i]);
  end;
end;

end.
