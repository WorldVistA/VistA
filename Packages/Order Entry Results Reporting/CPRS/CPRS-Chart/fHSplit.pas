unit fHSplit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPage, ExtCtrls, VA508AccessibilityManager;

type
  TfrmHSplit = class(TfrmPage)
    pnlLeft: TPanel;
    pnlRight: TPanel;
    sptHorz: TSplitter;
  private
  public
    { Public declarations }
  end;

var
  frmHSplit: TfrmHSplit;

implementation

{$R *.DFM}

end.
