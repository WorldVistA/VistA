unit fBase508Frame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TBase508Frame = class(TFrame)
  private
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    { Public declarations }
  end;

implementation

uses
  VAHelpers,
  ORFn;

{$R *.dfm}

procedure TBase508Frame.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateMenuFonts(Self, MainFont.Size);
end;

end.
