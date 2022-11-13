unit fBaseDynamicControlsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager;

type
  TfrmBaseDynamicControlsForm = class(TfrmBase508Form)
  private
    { Private declarations }
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TBaseDynamicControlsForm }

// Because of how these forms dynamically create and swap out components
// we would sometimes get errors in WMActivate when it was trying to
// activate components that were in the middle of being destroyed
procedure TfrmBaseDynamicControlsForm.WMActivate(var Message: TWMActivate);
begin
  if not (csDestroying in ComponentState) then
  begin
    try
      inherited;
    except
    end;
  end;
end;

end.
