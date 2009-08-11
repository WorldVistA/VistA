unit fHP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPage, StdCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmHP = class(TfrmPage)
    Label1: TLabel;
  private
    { Private declarations }
  public
    procedure ClearPtData; override;
    procedure DisplayPage; override;
  end;

var
  frmHP: TfrmHP;

implementation

{$R *.DFM}

procedure TfrmHP.ClearPtData;
begin
  inherited ClearPtData;
end;

procedure TfrmHP.DisplayPage;
begin
  inherited DisplayPage;
  if InitPatient then
  begin
  end;
end;

end.
