unit fOCAccept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, ExtCtrls, VA508AccessibilityManager, rOrders, fOCMonograph;

type
  TfrmOCAccept = class(TfrmAutoSz)
    memChecks: TRichEdit;
    pnlBottom: TPanel;
    cmdAccept: TButton;
    cmdCancel: TButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
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
  i,j: Integer;
  frmOCAccept: TfrmOCAccept;
  substring: String;
  remOC: TStringList;
begin          
  remOC := TStringList.Create;
  Result := True;
  if OCList.Count > 0 then
  begin
    frmOCAccept := TfrmOCAccept.Create(Application);
    try
      ResizeFormToFont(TForm(frmOCAccept));
      frmOCAccept.Button1.Enabled := false;
      if IsMonograph then frmOCAccept.Button1.Enabled := true;

      for i := 0 to OCList.Count - 1 do
      begin
        substring := Copy(Piece(OCList[i], U, 4),0,2);
        if substring='||' then
        begin
          substring := Copy(Piece(OCList[i], U, 4),3,Length(Piece(OCList[i], U, 4)));
          GetXtraTxt(remOC,Piece(substring,'&',1),Piece(substring,'&',2));
          frmOCAccept.memChecks.Lines.Add('('+inttostr(i+1)+' of '+inttostr(OCList.Count)+')  ' + Piece(substring,'&',2));
          for j:= 0 to remOC.Count - 1 do frmOCAccept.memChecks.Lines.Add('      '+remOC[j]);
//          frmOCAccept.memChecks.Lines.Add('           ');
        end
        else
        begin
          frmOCAccept.memChecks.Lines.Add('('+inttostr(i+1)+' of '+inttostr(OCList.Count)+')  ' + Piece(OCList[i], U, 4));
        end;
       
        frmOCAccept.memChecks.Lines.Add('');
      end;
      frmOCAccept.memChecks.SelStart := 0;
      frmOCAccept.memChecks.SelLength := 0;
      Result := frmOCAccept.ShowModal = mrYes;
    finally
      frmOCAccept.Release;
      remOC.Destroy;
    end;
  end;
end;

procedure TfrmOCAccept.Button1Click(Sender: TObject);
var
  monoList: TStringList;
begin
  inherited;
  monoList := TStringList.Create;
  GetMonographList(monoList);
  ShowMonographs(monoList);
  monoList.Free;
end;

procedure TfrmOCAccept.cmdCancelClick(Sender: TObject);
begin
  inherited;
  DeleteMonograph;
end;

procedure TfrmOCAccept.FormResize(Sender: TObject);
begin
  inherited;
  memChecks.Refresh;
end;

end.
