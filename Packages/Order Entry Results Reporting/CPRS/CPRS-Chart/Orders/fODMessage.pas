unit fODMessage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmODMessage = class(TfrmBase508Form)
    memMessage: TRichEdit;
    imgMessage: TImage;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowOrderMessage(Sender: TForm; const AMsg: string);
procedure HideOrderMessage;

implementation

{$R *.DFM}

uses ORFn;

var
  frmODMessage: TfrmODMessage;

procedure ShowOrderMessage(Sender: TForm; const AMsg: string);
begin
  frmODMessage := TfrmODMessage.Create(Application);
  ResizeFormToFont(TForm(frmODMessage));
  with frmODMessage do
  begin
    memMessage.Text := AMsg;
    SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, SWP_NOACTIVATE);
    Show;
    Sender.SetFocus;
  end;
end;

procedure HideOrderMessage;
begin
  if frmODMessage <> nil then frmODMessage.Release;
end;

procedure TfrmODMessage.FormDestroy(Sender: TObject);
begin
  frmODMessage := nil;
end;

procedure TfrmODMessage.FormCreate(Sender: TObject);
begin
  imgMessage.Picture.Icon.Handle := LoadIcon(0, IDI_ASTERISK);
end;

end.

