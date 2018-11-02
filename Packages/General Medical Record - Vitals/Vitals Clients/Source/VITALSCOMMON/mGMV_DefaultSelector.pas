unit mGMV_DefaultSelector;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrDefaultSelector = class(TFrame)
    lblName: TLabel;
    cbQualifiers: TComboBox;
    procedure cbQualifiersEnter(Sender: TObject);
    procedure cbQualifiersExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure setPopupLayout;
    procedure setDDWidth;
  end;

implementation

{$R *.dfm}

procedure TfrDefaultSelector.cbQualifiersEnter(Sender: TObject);
begin
  cbQualifiers.Color := clInfoBk;
  lblName.Font.Style := [];
  cbQualifiers.Font.Style := [];
end;

procedure TfrDefaultSelector.cbQualifiersExit(Sender: TObject);
begin
  cbQualifiers.Color := clWindow;
end;

procedure TfrDefaultSelector.setDDWidth;
begin
  cbQualifiers.Width := self.Width - cbQualifiers.Left - 4;
end;

procedure TfrDefaultSelector.setPopupLayout;
begin
  lblName.Alignment := taLeftJustify;
  lblName.Left := 24;
  cbQualifiers.Left := 100;
  setDDWidth;
end;

end.
