unit ActivityLogDisplay;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  UORForm;

type
  TfrmActivityLogDisplay = class(TORForm)
    pnlActivities: TPanel;
    chkActivityLog: TCheckBox;
    btnClearActivities: TButton;
    btnClearMessages: TButton;
    chkMessageLog: TCheckBox;
    reActivities: TRichEdit;
    reMessages: TRichEdit;
    pnlMessages: TPanel;
    chkMouse: TCheckBox;
    chkPaint: TCheckBox;
    chkTimer: TCheckBox;
    pnlBottom: TPanel;
    splMain: TSplitter;
    chkPauseActivity: TCheckBox;
    chkPauseMessages: TCheckBox;
    chkWrap: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ORFormShow(Sender: TObject);
    procedure chkPauseActivityClick(Sender: TObject);
    procedure chkWrapClick(Sender: TObject);
  private
    FOldActivityLogChange: TNotifyEvent;
  protected
    procedure ActivityLogChange(Sender: TObject);
  public
    procedure UpdateDisplay;
  end;

implementation

{$R *.dfm}

uses
  System.SysUtils,
  ORCtrls.ActivityLogger,
  ORCtrls.ActivityLog;

procedure TfrmActivityLogDisplay.FormCreate(Sender: TObject);
begin
  inherited;
  FOldActivityLogChange := TActivityLogger.Log.OnChange;
  TActivityLogger.Log.OnChange := ActivityLogChange;
  chkWrapClick(Self);
end;

procedure TfrmActivityLogDisplay.FormDestroy(Sender: TObject);
begin
  TActivityLogger.Log.OnChange := FOldActivityLogChange;
  FOldActivityLogChange := nil;
  inherited;
end;

procedure TfrmActivityLogDisplay.ORFormShow(Sender: TObject);
begin
  UpdateDisplay;
end;

procedure TfrmActivityLogDisplay.ActivityLogChange(Sender: TObject);
begin
  if Visible then UpdateDisplay;
  if Assigned(FOldActivityLogChange) then FOldActivityLogChange(Sender);
end;

procedure TfrmActivityLogDisplay.UpdateDisplay;
var
  AStream: TStringStream;
begin
  if chkPauseActivity.Checked then Exit;
  reActivities.LockDrawing;
  try
    AStream := TStringStream.Create
      (TActivityLogger.Log.ToString(TActivityLogger.LogMaxSize));
    try
      reActivities.Lines.LoadFromStream(AStream);
    finally
      FreeAndNil(AStream);
    end;
  finally
    reActivities.UnlockDrawing;
  end;
end;

procedure TfrmActivityLogDisplay.chkPauseActivityClick(Sender: TObject);
begin
  UpdateDisplay;
end;

procedure TfrmActivityLogDisplay.chkWrapClick(Sender: TObject);
begin
  reActivities.LockDrawing;
  try
    reActivities.WordWrap := chkWrap.Checked;
    if reActivities.WordWrap then reActivities.ScrollBars := ssVertical
    else reActivities.ScrollBars := ssBoth;
  finally
    reActivities.UnlockDrawing;
  end;
end;

end.
