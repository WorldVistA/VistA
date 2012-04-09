unit fPostings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPostings = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPostings: TfrmPostings;

implementation

{$R *.DFM}

end.
