unit fNoteDR;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, VA508AccessibilityManager;

type
  TfrmNoteDelReason = class(TfrmAutoSz)
    lblInstruction: TStaticText;
    cmdOK: TButton;
    cmdCancel: TButton;
    radPrivacy: TRadioButton;
    radAdmin: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function SelectDeleteReason(ANote: Integer): string;

implementation

{$R *.DFM}

uses ORFn, rTIU, uConst;

const
  TX_REQRSN = 'A reason must be selected, otherwise press cancel.';
  TC_REQRSN = 'Reason Required';

function SelectDeleteReason(ANote: Integer): string;
var
  frmNoteDelReason: TfrmNoteDelReason;
begin
  if not JustifyDocumentDelete(ANote) then
  begin
    Result := DR_NOTREQ;
    Exit;
  end;
  Result := DR_CANCEL;
  frmNoteDelReason := TfrmNoteDelReason.Create(Application);
  try
    ResizeFormToFont(TForm(frmNoteDelReason));
    frmNoteDelReason.ShowModal;
    with frmNoteDelReason do if OKPressed then
    begin
      if radPrivacy.Checked then Result := DR_PRIVACY;
      if radAdmin.Checked then Result := DR_ADMIN;
    end;
  finally
    frmNoteDelReason.Release;
  end;
end;

procedure TfrmNoteDelReason.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmNoteDelReason.cmdOKClick(Sender: TObject);
begin
  inherited;
  if not (radPrivacy.Checked or radAdmin.Checked) then
  begin
    InfoBox(TX_REQRSN, TC_REQRSN, MB_OK);
    Exit;
  end;
  OKPressed := True;
  Close;
end;

procedure TfrmNoteDelReason.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
