unit fOCAccept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, ExtCtrls, VA508AccessibilityManager;

type
  TfrmOCAccept = class(TfrmAutoSz)
    memChecks: TRichEdit;
    pnlBottom: TPanel;
    cmdAccept: TButton;
    cmdCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function AcceptOrderWithChecks(OCList: TStringList): Boolean;

implementation

{$R *.DFM}

function AcceptOrderWithChecks(OCList: TStringList): Boolean;
var
  i: Integer;
  frmOCAccept: TfrmOCAccept;
begin
  Result := True;
  if OCList.Count > 0 then
  begin
    frmOCAccept := TfrmOCAccept.Create(Application);
    try
      ResizeFormToFont(TForm(frmOCAccept));
      for i := 0 to OCList.Count - 1 do
      begin
        frmOCAccept.memChecks.Lines.Add(Piece(OCList[i], U, 4));
        frmOCAccept.memChecks.Lines.Add('');
      end;
      frmOCAccept.memChecks.SelStart := 0;
      frmOCAccept.memChecks.SelLength := 0;
      Result := frmOCAccept.ShowModal = mrYes;
    finally
      frmOCAccept.Release;
    end;
  end;
end;

end.
