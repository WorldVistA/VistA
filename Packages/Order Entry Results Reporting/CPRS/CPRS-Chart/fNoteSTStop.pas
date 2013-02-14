unit fNoteSTStop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fAutoSz, VA508AccessibilityManager;

type
  TfrmSearchStop = class(TfrmAutoSz)
    btnSearchStop: TButton;
    lblSearchStatus: TStaticText;
    procedure btnSearchStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSearchStop: TfrmSearchStop;

implementation

{$R *.dfm}
uses fNotes, ORFn;

procedure TfrmSearchStop.btnSearchStopClick(Sender: TObject);
begin
  SearchTextStopFlag := True;
end;

procedure TfrmSearchStop.FormShow(Sender: TObject);
begin
  ResizeFormToFont(frmSearchStop);
end;

end.
