unit ORCtrls.ActivityLogDisplay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, UORForm, ORCtrls.ActivityLog, ORCtrls;

type
  TfrmActivityLogDisplay = class(TORForm)
    pnlActivities: TPanel;
    cbActivityLog: TCheckBox;
    btnClearActivities: TButton;
    btnClearMessages: TButton;
    cbMessageLog: TCheckBox;
    reActivities: TRichEdit;
    reMessages: TRichEdit;
    pnlMessages: TPanel;
    cbMouse: TCheckBox;
    cbPaint: TCheckBox;
    cbTimer: TCheckBox;
    pnlBottom: TPanel;
    splMain: TSplitter;
    cbPauseActivity: TCheckBox;
    cbPauseMessages: TCheckBox;
    procedure ORFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ORFormDestroy(Sender: TObject);
    procedure cbActivityLogClick(Sender: TObject);
    procedure cbMessageLogClick(Sender: TObject);
    procedure ORFormShow(Sender: TObject);
    procedure ORFormCreate(Sender: TObject);
  private type
    TAccessActivityLog = class(TORActivityLog)
    private type
      TAccessActivity = class(TORActivityLog.TActivity);
    private
      class var FLastActivity: TORActivityLog.TActivity;
      class var FLastMessage: TORActivityLog.TActivity;
      class procedure OnLogActivity(Sender: TORActivityLog.TInternalLog;
        Activity: TORActivityLog.TActivity);
      class procedure OnLogMessage(Sender: TORActivityLog.TInternalLog;
        Activity: TORActivityLog.TActivity);
      class procedure UpdateLog(Sender: TORActivityLog.TInternalLog;
        ARichEdit: TRichEdit; var ALastActivity,
        AActivity: TORActivityLog.TActivity);
    end;
  private
    procedure UpdateDisplay;
  public
    procedure SetFontSize(NewFontSize: Integer);
  end;

var
  frmActivityLogDisplay: TfrmActivityLogDisplay;

implementation

{$R *.dfm}

uses
  ORFn;

procedure TfrmActivityLogDisplay.cbActivityLogClick(Sender: TObject);
begin
  if cbActivityLog.Checked then
    TORActivityLog.ActivityLog.OnLogEvent := TAccessActivityLog.OnLogActivity
  else
    TORActivityLog.ActivityLog.OnLogEvent := nil;
  UpdateDisplay;
end;

procedure TfrmActivityLogDisplay.cbMessageLogClick(Sender: TObject);
begin
  if cbMessageLog.Checked then
    TORActivityLog.MessageLog.OnLogEvent := TAccessActivityLog.OnLogMessage
  else
    TORActivityLog.MessageLog.OnLogEvent := nil;
  UpdateDisplay;
end;

procedure TfrmActivityLogDisplay.ORFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  TORActivityLog.ActivityLog.OnLogEvent := nil;
  TORActivityLog.MessageLog.OnLogEvent := nil;
end;

procedure TfrmActivityLogDisplay.ORFormCreate(Sender: TObject);
begin
  SetFontSize(MainFont.Size);
end;

procedure TfrmActivityLogDisplay.ORFormDestroy(Sender: TObject);
begin
  frmActivityLogDisplay := nil;
  FreeAndNil(TAccessActivityLog.FLastActivity);
  FreeAndNil(TAccessActivityLog.FLastMessage);
end;

procedure TfrmActivityLogDisplay.ORFormShow(Sender: TObject);
begin
  UpdateDisplay;
end;

procedure TfrmActivityLogDisplay.SetFontSize(NewFontSize: Integer);
var
  min: Integer;

  procedure Adjust(AControl: TControl);
  var
    txt: string;
    AFont: TFont;
  begin
    if AControl is TCheckBox then
    begin
      txt := TCheckBox(AControl).Caption;
      AFont := TCheckBox(AControl).Font;
    end
    else if AControl is TButton then
    begin
      txt := TButton(AControl).Caption;
      AFont := TButton(AControl).Font;
    end
    else
      exit;
    AControl.Width := TextWidthByFont(AFont.Handle, txt) + 24;
    inc(min, AControl.Width + AControl.Margins.Left + AControl.Margins.Right);
  end;

  procedure AdjustPanel(APanel: TPanel);
  var
    i: Integer;
  begin
    min := 0;
    for i := 0 to APanel.ControlCount - 1 do
      Adjust(APanel.Controls[i]);
  end;

begin
  Font.Size := NewFontSize;
  reActivities.Font.Size := NewFontSize;
  reMessages.Font.Size := NewFontSize;
  AdjustPanel(pnlActivities);
  AdjustPanel(pnlMessages);
  if ClientWidth < min then
    ClientWidth := min;
end;

procedure TfrmActivityLogDisplay.UpdateDisplay;
begin
  LockDrawing;
  try
    if reActivities.Visible and (not cbActivityLog.Checked) then
    begin
      reActivities.Visible := False;
      pnlBottom.Align := alClient;
    end
    else if (not reActivities.Visible) and cbActivityLog.Checked then
    begin
      reActivities.Visible := True;
      pnlBottom.Align := alBottom;
      pnlBottom.ClientHeight := (ClientHeight div 2);
      if not cbMessageLog.Checked then
        pnlBottom.ClientHeight := pnlMessages.Height;
    end
    else if reMessages.Visible and (not cbMessageLog.Checked) then
    begin
      reMessages.Visible := False;
      if cbActivityLog.Checked then
        pnlBottom.ClientHeight := pnlMessages.Height;
    end
    else if (not reMessages.Visible) and cbMessageLog.Checked then
    begin
      reMessages.Visible := True;
      if not cbActivityLog.Checked then
        pnlBottom.Align := alClient
      else
      begin
        pnlBottom.Align := alBottom;
        pnlBottom.ClientHeight := (ClientHeight div 2);
      end;
    end;
    splMain.Visible := (cbActivityLog.Checked and cbMessageLog.Checked);
    splMain.Top := pnlBottom.Top - splMain.Height;
  finally
    UnlockDrawing;
  end;
end;

{ TAccessActivityLog }

class procedure TfrmActivityLogDisplay.TAccessActivityLog.OnLogActivity
  (Sender: TORActivityLog.TInternalLog; Activity: TORActivityLog.TActivity);
begin
  if not frmActivityLogDisplay.cbPauseActivity.Checked then
    UpdateLog(Sender, frmActivityLogDisplay.reActivities, FLastActivity,
      Activity);
end;

class procedure TfrmActivityLogDisplay.TAccessActivityLog.OnLogMessage
  (Sender: TORActivityLog.TInternalLog; Activity: TORActivityLog.TActivity);
const
  MOUSE_UNKNOWN1 = $60;
  MOUSE_UNKNOWN2 = $118;
var
  Msg: Integer;
begin
  if (not frmActivityLogDisplay.cbPauseMessages.Checked) and Assigned(Activity)
    and Assigned(TAccessActivity(Activity).Message) then
  begin
    Msg := TAccessActivity(Activity).Message.Msg.Message;
    if (not frmActivityLogDisplay.cbPaint.Checked) and (Msg = WM_PAINT) then
      exit;
    if (not frmActivityLogDisplay.cbMouse.Checked) and
      (((Msg >= WM_MOUSEFIRST) and (Msg <= WM_MOUSELAST)) or
      ((Msg >= WM_NCMOUSEMOVE) and (Msg <= WM_NCXBUTTONDBLCLK)) or
      (Msg = WM_MOUSEHOVER) or (Msg = WM_MOUSELEAVE) or (Msg = WM_NCMOUSEMOVE)
      or (Msg = WM_NCMOUSELEAVE) or ((Msg >= WM_TOUCH) and
      (Msg <= WM_POINTERROUTEDRELEASED)) or (Msg = MOUSE_UNKNOWN1) or
      (Msg = MOUSE_UNKNOWN2)) then
      exit;
    if (not frmActivityLogDisplay.cbTimer.Checked) and (Msg = WM_TIMER) then
      exit;
    TORActivityLog.MessageLog.OnLogEvent := nil;
    try
      UpdateLog(Sender, frmActivityLogDisplay.reMessages, FLastMessage,
        Activity);
    finally
      TORActivityLog.MessageLog.OnLogEvent := OnLogMessage;
    end;
  end;
end;

class procedure TfrmActivityLogDisplay.TAccessActivityLog.UpdateLog
  (Sender: TORActivityLog.TInternalLog; ARichEdit: TRichEdit;
  var ALastActivity, AActivity: TORActivityLog.TActivity);
var
  i: Integer;
begin
  ARichEdit.LockDrawing;
  try
    if Assigned(ALastActivity) and Assigned(AActivity) and
      ALastActivity.Equals(AActivity) then
    begin
      Sender.MergeActivities(ALastActivity, AActivity);
      i := ARichEdit.Lines.Count;
      repeat
        dec(i);
        if (i >= 0) and (not ARichEdit.Lines[i].StartsWith(' ')) then
        begin
          while i < ARichEdit.Lines.Count do
            ARichEdit.Lines.Delete(ARichEdit.Lines.Count - 1);
          i := -1;
        end;
      until i < 0;
    end
    else
    begin
      FreeAndNil(ALastActivity);
      ALastActivity := AActivity.Clone;
    end;
    ARichEdit.Lines.Add(ALastActivity.ToString);
  finally
    ARichEdit.UnlockDrawing;
  end;
end;

end.
