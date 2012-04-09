unit fOptionsSubscribe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORFn, fBase508Form, VA508AccessibilityManager;

type
  TfrmOptionsSubscribe = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    bvlBottom: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptionsSubscribe: TfrmOptionsSubscribe;

procedure DialogOptionsSubscribe(fontsize: integer; var actiontype: Integer);

implementation

{$R *.DFM}

procedure DialogOptionsSubscribe(fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsSubscribe: TfrmOptionsSubscribe;
begin
  frmOptionsSubscribe := TfrmOptionsSubscribe.Create(Application);
  actiontype := 0;
  try
    with frmOptionsSubscribe do
    begin
      Font.Size := MainFontSize;
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsSubscribe.Release;
  end;
end;

end.
