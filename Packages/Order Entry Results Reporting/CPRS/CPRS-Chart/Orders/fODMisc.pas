unit fODMisc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ORCtrls, ORDtTm, ComCtrls, ExtCtrls, ORFn, uConst,
  VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmODMisc = class(TfrmODBase)
    cboCare: TORComboBox;
    lblStart: TLabel;
    calStart: TORDateBox;
    lblStop: TLabel;
    calStop: TORDateBox;
    lblCare: TLabel;
    lblComment: TLabel;
    txtComment: TCaptionEdit;
    procedure ControlChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboCareNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
  private
    { }
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

var
  frmODMisc: TfrmODMisc;

implementation

{$R *.DFM}

uses rODBase, VAUtils;

const
  TX_NO_CAREITEM = 'A patient care item must be selected.';
  TX_BAD_START   = 'The start date is not valid.';
  TX_BAD_STOP    = 'The stop date is not valid.';
  TX_STOPSTART   = 'The stop date must be after the start date.';

procedure TfrmODMisc.FormCreate(Sender: TObject);
begin
  inherited;
  FillerID := 'OR';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'OR GXMISC GENERAL';       // loads formatting info
  StatusText('Loading Default Values');
  //CtrlInits.LoadDefaults(ODForMisc);           // there are no defaults for OR GXMISC
  InitDialog;
  StatusText('');
  if ScreenReaderSystemActive then memOrder.TabStop := true;
end;

procedure TfrmODMisc.InitDialog;
begin
  inherited;
  cboCare.InitLongList('');
  txtComment.Text := '';
end;

procedure TfrmODMisc.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    Changing := True;
    SetControl(cboCare,    'ORDERABLE', 1);
    SetControl(txtComment, 'COMMENT',   1);
    SetControl(calStart,   'START',     1);
    SetControl(calStop,    'STOP',      1);
    Changing := False;
    ControlChange(Self);
    if not ScreenReaderSystemActive then SetFocusedControl(txtComment);
  end;
end;

procedure TfrmODMisc.Validate(var AnErrMsg: string);
var
  ErrMsg: string;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  if cboCare.ItemIEN <= 0 then SetError(TX_NO_CAREITEM);
  calStart.Validate(ErrMsg);
  if Length(ErrMsg) > 0   then SetError(TX_BAD_START);
  with calStop do
  begin
    Validate(ErrMsg);
    if Length(ErrMsg) > 0 then SetError(TX_BAD_STOP);
    if (Length(Text) > 0) and (FMDateTime <= calStart.FMDateTime)
                          then SetError(TX_STOPSTART);
  end; {with calStop}
end;

procedure TfrmODMisc.cboCareNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  inherited;
  // cboCare.ForDataUse(SubSetOfOrderItems(StartFrom, Direction, 'S.NURS', Responses.QuickOrder));
  sl := TStringList.Create;
  try
    setSubSetOfOrderItems(sl, StartFrom, Direction, 'S.NURS',
      Responses.QuickOrder);
    cboCare.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmODMisc.ControlChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  Responses.Clear;
  with cboCare    do if ItemIEN > 0      then Responses.Update('ORDERABLE', 1, ItemID, Text);
  with txtComment do if Length(Text) > 0 then Responses.Update('COMMENT',   1, Text,   Text);
  with calStart   do if Length(Text) > 0 then Responses.Update('START',     1, Text,   Text);
  with calStop    do if Length(Text) > 0 then Responses.Update('STOP',      1, Text,   Text);
  memOrder.Text := Responses.OrderText;
end;

end.
