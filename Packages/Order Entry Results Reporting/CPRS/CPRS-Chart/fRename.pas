unit fRename;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmRename = class(TfrmAutoSz)
    lblRename: TLabel;
    txtName: TCaptionEdit;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteRename(var AName: string; const APrompt: string): Boolean;

implementation

{$R *.DFM}

function ExecuteRename(var AName: string; const APrompt: string): Boolean;
var
  frmRename: TfrmRename;
begin
  Result := False;
  frmRename := TfrmRename.Create(Application);
  try
    ResizeFormToFont(TForm(frmRename));
    with frmRename do
    begin
      lblRename.Caption := APrompt;
      txtName.Text := AName;
      txtName.SelectAll;
      ShowModal;
      if OKPressed then
      begin
        AName := txtName.Text;
        Result := True;
      end;
    end;
  finally
    frmRename.Release;
  end;
end;

procedure TfrmRename.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmRename.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmRename.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
