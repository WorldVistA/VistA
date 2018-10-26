unit fProbCmt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, Buttons, fBase508Form, VA508AccessibilityManager, uCore;

type
  TfrmProbCmt = class(TfrmBase508Form)
    edComment: TCaptionEdit;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    lblComment: TOROffsetLabel;
    procedure bbCancelClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
  private
    fCmtResult: string ;
  end;

function NewComment: string ;
function EditComment(OldValue: string): string ;


var
  frmProbCmt: TfrmProbCmt;

implementation

uses
    uProbs, ORfn, rCore ;

const
  TX_INVALID_CHAR = 'The character "^" cannot be used in a comment';
  TC_INVALID_CHAR = 'Invalid character';

{$R *.DFM}

function NewComment: string ;
begin
  frmProbCmt := TfrmProbCmt.Create(Application) ;
  try
    ResizeAnchoredFormToFont(frmProbCmt);
    with frmProbCmt do
      begin
        ShowModal;
        Result := fCmtResult;
      end;
  finally
    frmProbCmt.Free ;
  end ;
end ;

function EditComment(OldValue: string): string ;
begin
  frmProbCmt := TfrmProbCmt.Create(Application) ;
  try
    with frmProbCmt do
      begin
        edComment.Text := Piece(OldValue, U, 2);
        ShowModal;
        Result := fCmtResult;
      end;
  finally
    frmProbCmt.Free ;
  end ;
end ;


procedure TfrmProbCmt.bbCancelClick(Sender: TObject);
begin
  fCmtResult := '0^Cancelled' ;
end;

procedure TfrmProbCmt.bbOKClick(Sender: TObject);
begin
  if (edComment.Text <> '') then
    begin
      if Pos('^', edComment.Text) > 0 then
      begin
        InfoBox(TX_INVALID_CHAR, TC_INVALID_CHAR, MB_ICONERROR);
        fCmtResult := '';
        ModalResult := mrNone;
      end
      else
      begin
        fCmtResult := '1^'+FormatFMDateTime('yyyy/mm/dd',FMToday)+'^'+ edComment.Text + '^' + IntToStr(User.DUZ);
        ModalResult := mrOK;
      end;
    end
  else
    begin
      fCmtResult := '';
      ModalResult := mrNone;
    end;
end;

end.
