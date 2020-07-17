unit fOrdersPickEvent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, ExtCtrls, VA508AccessibilityManager, rOrders, fOCMonograph, ORCtrls;

type
  TfrmOrdersPickEvent = class(TfrmAutoSz)
    pnlBottom: TPanel;
    cmdOK: TButton;
    lstOrders: TORListBox;
    lblMain: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function OrdersPickED(eventList: TStrings): integer;

implementation

{$R *.DFM}

function OrdersPickED(eventList: TStrings): integer;
var
  frmOrdersPickED: TfrmOrdersPickEvent;
  i: integer;
begin
  Result := 0;
  if eventList.Count > 0 then
  begin
    frmOrdersPickED := TfrmOrdersPickEvent.Create(Application);
    try
      ResizeFormToFont(TForm(frmOrdersPickED));

      for i := 0 to eventList.Count - 1 do
      begin
        frmOrdersPickED.lstOrders.Items.Add(Piece(eventList[i],U,2));
      end;

      frmOrdersPickED.ShowModal;
      Result := frmOrdersPickED.lstOrders.ItemIndex;
    finally
      frmOrdersPickED.Release;
    end;
  end;
end;

end.
