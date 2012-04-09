unit fIVRoutes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, ExtCtrls, ORFn, rMisc, rODMeds, VA508AccessibilityManager, VAUtils, fAutoSz;

type
  TfrmIVRoutes = class(TfrmAutoSz)
    pnlTop: TPanel;
    cboAllIVRoutes: TORComboBox;
    pnlBottom: TORAutoPanel;
    BtnOK: TButton;
    btnCancel: TButton;
    procedure BtnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

function ShowOtherRoutes(var Route: string): boolean;

var
  frmIVRoutes: TfrmIVRoutes;

implementation

{$R *.dfm}
function ShowOtherRoutes(var Route: string): boolean;
var
idx: integer;
begin
     Result := false;
     frmIVRoutes := TfrmIVRoutes.Create(Application);
     ResizeFormToFont(TForm(frmIVRoutes));
     SetFormPosition(frmIVRoutes);
     //LoadAllIVRoutes(frmIVRoutes.cboAllIVRoutes.Items);
     if frmIVRoutes.ShowModal = mrOK then
       begin
         idx := frmIVRoutes.cboAllIVRoutes.ItemIndex;
         if idx > -1 then
           begin
             Route := frmIVRoutes.cboAllIVRoutes.Items.Strings[idx];
             setPiece(Route,U,5,'1');
           end
         else Route := '';
         Result := True;
       end;
     frmIVRoutes.Free;
end;
{ TfrmIVRoutes }

procedure TfrmIVRoutes.btnCancelClick(Sender: TObject);
begin
  frmIVRoutes.cboAllIVRoutes.ItemIndex := -1;
  modalResult := mrOK;
end;

procedure TfrmIVRoutes.BtnOKClick(Sender: TObject);
begin
  if frmIVRoutes.cboAllIVRoutes.ItemIndex = -1 then
    begin
       infoBox('A route from the list must be selected','Warning', MB_OK);
       Exit;
    end;
  modalResult := mrOK;
end;


procedure TfrmIVRoutes.FormCreate(Sender: TObject);
begin
   frmIVRoutes := nil;
   LoadAllIVRoutes(cboAllIVRoutes.Items);
end;

procedure TfrmIVRoutes.FormDestroy(Sender: TObject);
begin
  inherited;
  frmIVRoutes := nil;
end;

end.
