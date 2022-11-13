unit fCsltNote;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ORCtrls, ORfn, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmCsltNote = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboCsltNote: TORComboBox;
    lblAction: TLabel;
    pnlBase: TORAutoPanel;
    pnlButtons: TPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FNoteIEN: string  ;
    FChanged: Boolean;
  end;

procedure SelectNoteForProcessing(FontSize: Integer; ActionType: integer; NoteList: TStrings;
           var NoteIEN: integer; CPStatus: integer) ;

implementation

{$R *.DFM}

uses rConsults, rCore, uCore, fConsults, uConsults;

const
  TX_NOTE_TEXT = 'Select a document or press Cancel.';
  TX_NOTE_CAP = 'No Document Selected';

procedure SelectNoteForProcessing(FontSize: Integer; ActionType: integer; NoteList: TStrings;
           var NoteIEN: integer; CPStatus: integer) ;
{ displays progress note selection form and returns a record of the selection }
var
  frmCsltNote: TfrmCsltNote;
  W, H, i: Integer;
begin
  frmCsltNote := TfrmCsltNote.Create(Application);
  try
    with frmCsltNote do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      Caption := fConsults.ActionType[ActionType];
      case ActionType of
        CN_ACT_CP_COMPLETE:
          begin
            if CPStatus = CP_INSTR_INCOMPLETE then
              begin
                lblAction.Caption := 'Interpret Clinical Procedure Results:';
                cboCsltNote.Caption := lblAction.Caption;
                for i := 0 to NoteList.Count-1 do
                  if ((not (Copy(Piece(Piece(NoteList[i], U, 1), ';', 2), 1, 4) = 'MCAR')) and
                     (Piece(NoteList[i], U, 13) <> '%') and
                     (Piece(NoteList[i], U, 7)  <> 'completed')) then
                       cboCsltNote.Items.Add(Piece(NoteList[i], U, 1) + U + MakeConsultNoteDisplayText(Notelist[i]));
                cboCsltNote.ItemIndex := 0;
                FNoteIEN := cboCsltNote.ItemID;
                //ShowModal;
              end
            else if CPStatus in [CP_NO_INSTRUMENT, CP_INSTR_COMPLETE] then
              begin
                lblAction.Caption := 'Select incomplete note to continue with:';
                cboCsltNote.Caption := lblAction.Caption;
                for i := 0 to NoteList.Count-1 do
                  if ((not (Copy(Piece(Piece(NoteList[i], U, 1), ';', 2), 1, 4) = 'MCAR')) and
                     (Piece(NoteList[i], U, 7)  <> 'completed') and
                     ((Piece(Piece(NoteList[i], U, 5), ';', 1) = IntToStr(User.DUZ)) or
                     (Piece(Piece(NoteList[i], U, 5), ';', 1) = '0')))  then
                    cboCsltNote.Items.Add(Piece(NoteList[i], U, 1) + U + MakeConsultNoteDisplayText(Notelist[i]));
                if cboCsltNote.Items.Count > 0 then cboCsltNote.Items.Insert(0, CN_NEW_CP_NOTE + '^<Create new note>');
                if cboCsltNote.Items.Count > 0 then
                  ShowModal
                else
                  FNoteIEN := CN_NEW_CP_NOTE;
              end;
          end;
        CN_ACT_COMPLETE:
          begin
            lblAction.Caption := 'Select incomplete note to continue with:';
            cboCsltNote.Caption := lblAction.Caption;
            for i := 0 to NoteList.Count-1 do
              if ((not (Copy(Piece(Piece(NoteList[i], U, 1), ';', 2), 1, 4) = 'MCAR')) and
                 (Piece(NoteList[i], U, 7)  <> 'completed') and
                 (Piece(Piece(NoteList[i], U, 5), ';', 1) = IntToStr(User.DUZ)))  then
                cboCsltNote.Items.Add(Piece(NoteList[i], U, 1) + U + MakeConsultNoteDisplayText(Notelist[i]));
            if cboCsltNote.Items.Count > 0 then cboCsltNote.Items.Insert(0, CN_NEW_CSLT_NOTE + '^<Create new note>');
            if cboCsltNote.Items.Count > 0 then
              ShowModal
            else
              FNoteIEN := CN_NEW_CSLT_NOTE;
          end;
(*      CN_ACT_ADDENDUM:     //  no longer called in v15
          begin
            lblAction.Caption := 'Select completed note to addend to:';
            for i := 0 to NoteList.Count-1 do
              begin
                if Copy(Piece(NoteList[i], U, 2), 1, 8) = 'Addendum' then continue;
                if Piece(NoteList[i], U, 13) = '%' then continue;
                cboCsltNote.Items.Add(Piece(NoteList[i], U, 1) + U + MakeConsultNoteDisplayText(Notelist[i]));
              end;
            if cboCsltNote.Items.Count > 0 then
              ShowModal
            else
              FNoteIEN := '-30';
          end;*)
      end; {case}

      NoteIEN:= StrToIntDef(FNoteIEN, -1) ;
    end; {with frmCsltNote}
  finally
    frmCsltNote.Release;
  end;
end;

procedure TfrmCsltNote.cmdCancelClick(Sender: TObject);
begin
  FNoteIEN := '-1';
  Close;
end;

procedure TfrmCsltNote.cmdOKClick(Sender: TObject);
begin
 with cboCsltNote do
   begin
     if ItemIEN = 0 then
       begin
         InfoBox(TX_NOTE_TEXT, TX_NOTE_CAP, MB_OK or MB_ICONWARNING);
         FChanged := False ;
         FNoteIEN := '-1';
         Exit;
       end;
     FChanged := True;
     FNoteIEN := Piece(Items[ItemIndex],U,1);
     Close;
   end ;
end;

end.
