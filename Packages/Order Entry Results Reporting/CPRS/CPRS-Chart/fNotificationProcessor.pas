unit fNotificationProcessor;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Actions,
  Vcl.ActnList,
  fBase508Form,
  VA508AccessibilityManager;

type
  TNotificationAction = (naCancel, naNewNote, naAddendum);

  TfrmNotificationProcessor = class(TfrmBase508Form)
    btnCancel: TButton;
    btnOK: TButton;

    bvlBottom: TBevel;

    lbxCurrentNotesAvailable: TListBox;

    memNotificationSpecifications: TMemo;

    rbtnNewNote: TRadioButton;
    rbtnAddendOneOfTheFollowing: TRadioButton;

    stxtNotificationName: TStaticText;
    btnDefer: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NewOrAddendClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnDeferClick(Sender: TObject);
  private
    fAlert: string;
    fAlertDescription: string;
    fDFN: string;
    fName: string;
    fNotificationAction: TNotificationAction;
    fNotificationName: string;
    fNotificationIEN: integer;
    fNoteTitleIEN: integer;
    fNoteTitle: string;
    fNoteAllowAddendum: boolean;
    fNoteDescription: TStringList;
    fNoteList: TStringList;
    fParams: TStringList;
    fNoteIndex: integer;

    procedure Setup;
  public
    class function Execute(aParams: TStringList; aDescription: string;
      CancelButton: boolean = False): TNotificationAction;
  end;

var
  NotificationProcessor: TfrmNotificationProcessor;

implementation

uses
  mFunStr,
  uCore,
  ORNet,
  ORFn,
  fFrame,
  fDeferDialog;

{$R *.dfm}

type
  TAvailableNote = class(TObject)
  private
    FIEN: integer;
    FTitle: string;
    FDate: string;
  end;

const
  STXT_CAPTION = 'Notification - %s';
  NOTE_CAPTION = 'Create New Note [Title: %s]';
  RBTN_CAPTION = '%d Notes available to addend';

procedure TfrmNotificationProcessor.btnDeferClick(Sender: TObject);
var
  aResult: string;
begin
  with TfrmDeferDialog.Create(Self) do
    try
      Title := 'Defer Patient Notification';
      Description := StringReplace(fAlertDescription,fAlert,'', [rfReplaceAll]);
      if Execute then
        try
          Self.ModalResult := mrCancel;
          CallVistA('ORB3UTL DEFER', [User.DUZ, fAlert, DeferUntilFM],aResult);
          if aResult <> '1' then
            raise Exception.Create(Copy(aResult, Pos(aResult, '^') + 1, Length(aResult)))
          else
          begin
            fNotificationAction := naCancel;
          end;
        except
          on e: Exception do
            MessageDlg(e.Message, mtError, [mbOk], 0);
        end
      else
        MessageDlg('Deferral cancelled', mtInformation, [mbOk], 0);
    finally
      Free;
    end;
end;

procedure TfrmNotificationProcessor.btnOKClick(Sender: TObject);
var
  aNoteToAddend: TAvailableNote;
begin
  if rbtnNewNote.Checked then
    fNotificationAction := naNewNote
  else if rbtnAddendOneOfTheFollowing.Checked then
    begin
      fNoteIndex := lbxCurrentNotesAvailable.ItemIndex;
      fNotificationAction := naAddendum;
      aNoteToAddend := TAvailableNote(lbxCurrentNotesAvailable.Items.Objects[fNoteIndex]);
      fParams.Values['ADDEND NOTE IEN'] := IntToStr(aNoteToAddend.FIEN);
      fParams.Values['ADDEND NOTE TITLE'] := aNoteToAddend.FTitle;
    end
  else
    fNotificationAction := naCancel;
end;

class function TfrmNotificationProcessor.Execute(aParams: TStringList;
  aDescription: string; CancelButton: boolean = False): TNotificationAction;
var
  notProcFrm: TfrmNotificationProcessor;

  procedure Adjust(btn: TButton);
  begin
    btn.Width := TextWidthByFont(notProcFrm.Font.Handle, btn.Caption) + 20;
  end;

begin
  notProcFrm := TfrmNotificationProcessor.Create(Application);
  notProcFrm.fAlertDescription := aDescription;
  with notProcFrm do
  begin
    try
      fParams := aParams;

      Setup;

      if CancelButton then
      begin
        btnCancel.Caption := 'Cancel';
        btnDefer.ModalResult := mrNone;
      end;

      Adjust(btnDefer);
      Adjust(btnCancel);
      btnCancel.Left := ClientWidth - btnCancel.Width - 10;
      btnOK.Left := btnCancel.Left - btnOK.Width - 10;

      case ShowModal of
        mrOk:
          Result := fNotificationAction;
        mrCancel:
          Result := naCancel;
      else
        Result := naCancel;
      end;
      if Result = naCancel then
      begin
        CallVistA('ORBSMART OUSMALRT', [fAlert]);
      end;

    finally
      Free;
    end;
  end;
end;

procedure TfrmNotificationProcessor.FormCreate(Sender: TObject);
begin
  Font := Application.MainForm.Font;
  fNoteDescription := TStringList.Create;
  fNoteList := TStringList.Create;
  fNoteIndex := -1;
end;

procedure TfrmNotificationProcessor.FormDestroy(Sender: TObject);
begin
  while lbxCurrentNotesAvailable.Count > 0 do
    begin
      lbxCurrentNotesAvailable.Items.Objects[0].Free;
      lbxCurrentNotesAvailable.Items.Delete(0);
    end;
  FreeAndNil(fNoteDescription);
  FreeAndNil(fNoteList);
end;

procedure TfrmNotificationProcessor.NewOrAddendClick(Sender: TObject);
begin
  if not rbtnAddendOneOfTheFollowing.Checked then
    begin
      lbxCurrentNotesAvailable.ItemIndex := -1;
      lbxCurrentNotesAvailable.Enabled := False;
    end
  else
    begin
      lbxCurrentNotesAvailable.Enabled := True;
    end;

  if fNoteAllowAddendum and rbtnAddendOneOfTheFollowing.Checked then
    btnOK.Enabled := lbxCurrentNotesAvailable.ItemIndex > -1
  else
    btnOK.Enabled := rbtnNewNote.Checked;
end;

procedure TfrmNotificationProcessor.Setup;
var
  aAvailableNote: TAvailableNote;
  y: integer;
begin
  fNotificationAction := naCancel; // Just to make sure ;-)

  fAlert := fParams.Values['ALERT'];

  fNotificationIEN := StrToIntDef(fParams.Values['NOTIFICATION IEN'], -1);
  fNotificationName := fParams.Values['NOTIFICATION NAME'];

  fNoteTitle := fParams.Values['NOTE TITLE'];
  fNoteTitleIEN := StrToIntDef(fParams.Values['NOTE TITLE IEN'], -1);
  fNoteAllowAddendum := fParams.Values['ALLOW ADDENDUM'] = '1';
  fDFN := fParams.Values['DFN'];
  fName := fParams.Values['PATIENT NAME'];

  self.Caption := self.Caption + ' (' + fName + ')';

  // Sets this alert as in process on M side in user context
  CallVistA('ORBSMART INSMALRT', [fAlert]);

  CallVistA('ORB3UTL GET DESCRIPTION', [fAlert], fNoteDescription);


  if fNoteAllowAddendum then
    begin
      CallVistA('ORB3UTL GET EXISTING NOTES', [fNoteTitleIEN, fDFN], fNoteList);
      lbxCurrentNotesAvailable.Items.Clear;
      while fNoteList.Count > 1 do
        begin
          aAvailableNote := TAvailableNote.Create;
          aAvailableNote.FIEN := StrToIntDef(Piece(fNoteList[1], '^', 1), -1);
          aAvailableNote.FTitle := Piece(fNoteList[1], '^', 2);
          aAvailableNote.FDate := Piece(fNoteList[1], '^', 3);
          lbxCurrentNotesAvailable.Items.AddObject(aAvailableNote.FTitle + ' ' + aAvailableNote.FDate, aAvailableNote);
          fNoteList.Delete(1);
        end;

      if lbxCurrentNotesAvailable.Count > 0 then
        rbtnAddendOneOfTheFollowing.Caption := Format(RBTN_CAPTION, [lbxCurrentNotesAvailable.Count])
      else
      begin
        y := lbxCurrentNotesAvailable.Top + lbxCurrentNotesAvailable.Height;
        rbtnAddendOneOfTheFollowing.Caption := 'No notes available to addend';
        rbtnAddendOneOfTheFollowing.Visible := false;
        rbtnNewNote.Visible := false;
        lbxCurrentNotesAvailable.Visible := false;
        memNotificationSpecifications.Height := y - memNotificationSpecifications.Top;
      end;

      rbtnAddendOneOfTheFollowing.Enabled := (lbxCurrentNotesAvailable.Count > 0);
      lbxCurrentNotesAvailable.Enabled := False;
    end
  else
    begin
      rbtnAddendOneOfTheFollowing.Caption := 'Addendums not allowed for this notification';
      rbtnAddendOneOfTheFollowing.Enabled := False;
      lbxCurrentNotesAvailable.Enabled := False;
    end;

  stxtNotificationName.Caption := Format(STXT_CAPTION, [fNotificationName]);

  rbtnNewNote.Caption := Format(NOTE_CAPTION, [fNoteTitle]);
  rbtnNewNote.Checked := True; // Default to new note

  memNotificationSpecifications.Text := fNoteDescription.Text;

  lbxCurrentNotesAvailable.ItemIndex := -1;
end;

end.
