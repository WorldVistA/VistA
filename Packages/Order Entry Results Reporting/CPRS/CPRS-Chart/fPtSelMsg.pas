unit fPtSelMsg;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPtSelMsg = class(TfrmBase508Form)
    cmdClose: TButton;
    timClose: TTimer;
    memMessages: ORExtensions.TRichEdit;
    pnlButtons: TPanel;
    Panel1: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdCloseClick(Sender: TObject);
    procedure timCloseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FSeconds: Integer;
    FChanging: boolean;
    FEventsActive: boolean;
    FOldActiveFormChanged: TNotifyEvent;
    FOldTabChanged: TNotifyEvent;
    procedure ClearEvents;
    procedure TabChanged(Sender: TObject);
    procedure ActiveFormChanged(Sender: TObject);
  public
    { Public declarations }
  end;

procedure ShowPatientSelectMessages(const AMsg: string);
procedure HidePatientSelectMessages;

implementation

{$R *.DFM}

uses ORFn, uCore, fFrame, VAUtils, rMisc;

var
  frmPtSelMsg: TfrmPtSelMsg = nil;

procedure ShowPatientSelectMessages(const AMsg: string);
begin
  if assigned(frmPtSelMsg) then
  begin
    frmPtSelMsg.Free;
    frmPtSelMsg := nil;
  end;
  if Length(AMsg) = 0 then Exit;
  frmPtSelMsg := TfrmPtSelMsg.Create(Application);
  SetFormPosition(frmPtSelMsg);
  ResizeAnchoredFormToFont(frmPtSelMsg);
  frmPtSelMsg.memMessages.Lines.SetText(PChar(AMsg));  // Text := AMsg doesn't seem to work
  frmPtSelMsg.memMessages.SelStart := 0;
  if User.PtMsgHang = 0
    then frmPtSelMsg.timClose.Enabled := False
    else
    begin
      //frmPtSelMsg.timClose.Interval := User.PtMsgHang * 1000;
      frmPtSelMsg.FSeconds := User.PtMsgHang;
      frmPtSelMsg.timClose.Enabled := True;
    end;
  frmPtSelMsg.Show;
end;

procedure HidePatientSelectMessages;
begin
  if assigned(frmPtSelMsg) then
  begin
    frmPtSelMsg.Free;
    frmPtSelMsg := nil;
  end;
end;

procedure TfrmPtSelMsg.timCloseTimer(Sender: TObject);
begin
  Dec(FSeconds);
  if FSeconds > 0
//    then Caption := 'Patient Lookup Messages   (Auto-Close in ' + IntToStr(FSeconds) + ' seconds)'
    then pnlButtons.Caption := '  Auto-Close in ' + IntToStr(FSeconds) + ' seconds...'
  else Close;
end;

procedure TfrmPtSelMsg.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPtSelMsg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;

begin
  Action := caFree;
  SaveUserBounds(Self);
  // VISTAOR 26913
  // Some modal dialogs displayed on top of this dialog are assigned a windows
  // parent of this dialog.  If these dialogs are not reset to another parent
  // at the time this dialog closes it can erroneously close the modal dialog,
  // locking up the application because it's still in the form's ShowModal
  // loop.  See vcl.Forms procedure TCustomForm.CreateParams
  for i := PopupChildren.Count - 1 downto 0 do
    TForm(PopupChildren[i]).PopupMode := pmExplicit;
end;

procedure TfrmPtSelMsg.FormCreate(Sender: TObject);
begin
  FOldActiveFormChanged := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := ActiveFormChanged;
  FOldTabChanged := frmFrame.OnTabChanged;
  frmFrame.OnTabChanged := TabChanged;
  FEventsActive := TRUE;
end;

procedure TfrmPtSelMsg.FormDestroy(Sender: TObject);
begin
  ClearEvents;
  frmPtSelMsg := nil;
end;

procedure TfrmPtSelMsg.ActiveFormChanged(Sender: TObject);
begin
  if assigned(FOldActiveFormChanged) then
    FOldActiveFormChanged(Sender);
  if (not FChanging) and (Screen.ActiveForm <> Self) and
     (not (csDestroying in Self.ComponentState)) then
  begin
    FChanging := TRUE;
    try
      SetFocus;
    finally
      FChanging := FALSE;
    end;
  end;
end;

procedure TfrmPtSelMsg.ClearEvents;
begin
  if FEventsActive then
  begin
    Screen.OnActiveFormChange := FOldActiveFormChanged;
    frmFrame.OnTabChanged := FOldTabChanged;
    FEventsActive := FALSE;
  end;
end;

procedure TfrmPtSelMsg.TabChanged(Sender: TObject);
begin
  if assigned(FOldTabChanged) then
    FOldTabChanged(Sender);
  ClearEvents;
end;

end.
