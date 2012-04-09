unit fxServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ORNet, fBase508Form, VA508AccessibilityManager;

type
  TfrmDbgServer = class(TfrmBase508Form)
    memSymbols: TRichEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure DebugShowServer;

implementation

{$R *.DFM}

uses rMisc, ORFn;

procedure DebugShowServer;
var
  frmDbgServer: TfrmDbgServer;
begin
  frmDbgServer := TfrmDbgServer.Create(Application);
  try
    ResizeAnchoredFormToFont(frmDbgServer);
    frmDbgServer.ShowModal;
  finally
    frmDbgServer.Release;
  end;
end;

procedure TfrmDbgServer.FormCreate(Sender: TObject);
begin
  ListSymbolTable(memSymbols.Lines);
end;

procedure TfrmDbgServer.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
