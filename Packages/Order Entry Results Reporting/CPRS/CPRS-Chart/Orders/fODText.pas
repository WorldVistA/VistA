unit fODText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ORCtrls, ComCtrls, ExtCtrls, ORFn, uConst, ORDtTm,
  VA508AccessibilityManager;

type
  TfrmODText = class(TfrmODBase)
    memText: TMemo;
    lblText: TLabel;
    txtStart: TORDateBox;
    txtStop: TORDateBox;
    lblStart: TLabel;
    lblStop: TLabel;
    VA508CompMemOrder: TVA508ComponentAccessibility;
    lblOrderSig: TLabel;
    gpMain: TGridPanel;
    pnlGridMessage: TPanel;
    pnlButtons: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure VA508CompMemOrderStateQuery(Sender: TObject; var Text: string);
    procedure lblOrderSigClick(Sender: TObject);
  private
    fShowMessage: Boolean;
    procedure UpdateVisualControls;
  public
    procedure InitDialog; override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure Validate(var AnErrMsg: string); override;
    procedure setupControls;
    procedure ShowOrderMessage(Show: boolean); override;
    procedure SetFontSize(FontSize: integer); override;
  end;

var
  frmODText: TfrmODText;

implementation

{$R *.DFM}

uses rCore, VAUtils, uSizing, uOwnerWrapper, UResponsiveGUI;

const
  TX_NO_TEXT = 'Some text must be entered.';
  TX_STARTDT = 'Unable to interpret start date.';
  TX_STOPDT  = 'Unable to interpret stop date.';
  TX_GREATER = 'Stop date must be greater than start date.';

{ TfrmODBase common methods }

procedure TfrmODText.FormCreate(Sender: TObject);
begin
  inherited;
  FillerID := 'OR';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'OR GXTEXT WORD PROCESSING ORDER';  // loads formatting info
  //StatusText('Loading Default Values');                // there are no defaults for text only
  //CtrlInits.LoadDefaults(ODForText);
  AutoSizeDisabled := true;
  InitDialog;
  StatusText('');
end;

procedure TfrmODText.InitDialog;
begin
  inherited;                 // inherited clears dialog controls and responses
  setupControls;
  fShowMessage := False;
  ShowOrderMessage(fShowMessage);
  ActiveControl := memText;  //SetFocusedControl(memText);
end;

procedure TfrmODText.lblOrderSigClick(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG} // Test of ShowOrderMessage
//  fShowMessage := not fShowMessage;
//  ShowOrderMessage(fShowMessage);
{$ENDIF}
end;

procedure TfrmODText.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    SetControl(memText,  'COMMENT', 1);
    SetControl(txtStart, 'START',   1);
    SetControl(txtStop,  'STOP',    1);
  end
  else txtStart.Text := 'NOW';
end;

procedure TfrmODText.VA508CompMemOrderStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memOrder.Text;
end;

procedure TfrmODText.Validate(var AnErrMsg: string);
const
  SPACE_CHAR = 32;
var
  ContainsPrintable: Boolean;
  i: Integer;
  StartTime, StopTime: TFMDateTime;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  ContainsPrintable := False;
  for i := 1 to Length(memText.Text) do if Ord(memText.Text[i]) > SPACE_CHAR then
  begin
    ContainsPrintable := True;
    break;
  end;
  if not ContainsPrintable then SetError(TX_NO_TEXT);
  with txtStart do if Length(Text) > 0
    then StartTime := StrToFMDateTime(Text)
    else StartTime := 0;
  with txtStop do if Length(Text) > 0
    then StopTime := StrToFMDateTime(Text)
    else StopTime := 0;
  if StartTime = -1 then SetError(TX_STARTDT);
  if StopTime  = -1 then SetError(TX_STARTDT);
  if (StopTime > 0) and (StopTime < StartTime) then SetError(TX_GREATER);
  //the following is commented out because should be using relative times
  //if AnErrMsg = '' then
  //begin
  //  Responses.Update('START', 1, FloatToStr(StartTime), txtStart.Text);
  //  Responses.Update('STOP', 1, FloatToStr(StopTime), txtStop.Text);
  //end;
end;

procedure TfrmODText.cmdAcceptClick(Sender: TObject);
var
  ReleasePending: boolean;
  Msg: TMsg;
begin
  LockOwnerWrapper(Self);
  try
    inherited;
    // if the order dialog has ASK FOR ANOTHER ORDER set to YES, the form
    // will need to stick around
    // this is verified in the inherited cmdAcceptClick by calling AskAnotherOrder(..)
    // so if we're not *already* releasing, don't force the issue
    ReleasePending := PeekMessage(Msg, Handle, CM_RELEASE, CM_RELEASE, PM_REMOVE);
    TResponsiveGUI.ProcessMessages; //CQ 14670
    memText.Lines.Text := Trim(memText.Lines.Text); //CQ 14670
    if ReleasePending then
      Release;
  finally
    UnlockOwnerWrapper(Self);
  end;
end;

procedure TfrmODText.ControlChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  with memText  do if GetTextLen > 0   then Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
  with txtStart do if Length(Text) > 0 then Responses.Update('START', 1, Text, Text);
  with txtStop  do if Length(Text) > 0 then Responses.Update('STOP', 1, Text, Text);
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODText.SetupControls;
begin
  // Move inherited controls onto the TGridPanel
  gpMain.ControlCollection.BeginUpdate;
  try
    gpMain.ControlCollection.AddControl(memOrder, 0, 7);
    gpMain.ControlCollection.ControlItems[0, 7].ColumnSpan := 2;

    memOrder.Parent := gpMain;
    memOrder.Align := alClient;
    memOrder.AlignWithMargins := True;

    gpMain.ControlCollection.AddControl(pnlButtons, 2, 7);
    pnlButtons.Parent := gpMain;
    pnlButtons.Align := alClient;

    cmdAccept.Parent := pnlButtons;
    cmdAccept.Align := alTop;
    cmdAccept.AlignWithMargins := True;

    cmdQuit.Parent := pnlButtons;
    cmdQuit.Align := alTop;
    cmdQuit.AlignWithMargins := True;

  finally
    gpMain.ControlCollection.EndUpdate;
  end;

  UpdateVisualControls;

  pnlGridMessage.Margins.Right := round(gpMain.ColumnCollection[2].Value);

  pnlMessage.Parent := pnlGridMessage;
  pnlMessage.Align := alClient;
  pnlMessage.AlignWithMargins := True;

end;

procedure TfrmODText.ShowOrderMessage(Show: boolean);
begin
  fShowMessage := Show;

  pnlGridMessage.Visible := Show;
  memMessage.TabStop := Show;
  if Show then
    pnlGridMessage.Top := Height - pnlGridMessage.Height;

  lblOrderSig.Top := gpMain.Top - lblOrderSig.Height;

  pnlMessage.BringToFront;
  pnlMessage.Visible := True;

  Invalidate;
end;

procedure TfrmODText.UpdateVisualControls;
var
  i, iHeight, iWidth: Integer;
begin
  iHeight := getMainFormTextHeight;
  gpMain.ControlCollection.BeginUpdate;
  gpMain.RowCollection[0].Value := iHeight + 8;
  gpMain.RowCollection[2].Value := iHeight + 8;
  gpMain.RowCollection[3].Value := iHeight + 8 + 6;
  gpMain.RowCollection[4].Value := iHeight + 8;
  gpMain.RowCollection[5].Value := iHeight + 8 + 6;
  gpMain.RowCollection[6].Value := iHeight + 8;

  iWidth := getMainFormTextWidth(lblText.Caption);
  gpMain.ColumnCollection[0].Value := iWidth + 8;

  i := (iHeight + 10) * 3 + 8;
  if gpMain.RowCollection[7].Value < i then
    gpMain.RowCollection[7].Value := i;
  constraints.MinHeight := i * 5;

  pnlGridMessage.Height := round(gpMain.RowCollection[7].Value);

  i := getMainFormTextWidth('Accept Order') + 24;
  if gpMain.ColumnCollection[2].Value < i then
    gpMain.ColumnCollection[2].Value := i;

  constraints.MinWidth := i * 8;
  gpMain.ControlCollection.EndUpdate;
end;

procedure TfrmODText.SetFontSize(FontSize: Integer);


begin
  Font.Size := FontSize;
  memMessage.DefAttributes.Size := FontSize;
  UpdateVisualControls;
end;

end.
