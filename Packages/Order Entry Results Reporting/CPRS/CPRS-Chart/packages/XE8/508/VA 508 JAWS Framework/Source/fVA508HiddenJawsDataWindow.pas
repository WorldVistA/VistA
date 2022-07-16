unit fVA508HiddenJawsDataWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DateUtils, ComCtrls, ExtCtrls, AppEvnts;

type
  TfrmVA508HiddenJawsDataWindow = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
  protected
  public
  end;

implementation

uses VAUtils, JAWSCommon, VA508AccessibilityConst;

{$R *.dfm}

{ TfrmVA508HiddenJawsWindow }

procedure TfrmVA508HiddenJawsDataWindow.FormCreate(Sender: TObject);
begin
  ErrorCheckClassName(Self, DLL_DATA_WINDOW_CLASS);
end;

end.
