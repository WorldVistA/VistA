unit fODLabImmedColl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORDtTm, ExtCtrls, ORFn, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmODLabImmedColl = class(TfrmBase508Form)
    memImmedCollect: TCaptionMemo;
    calImmedCollect: TORDateBox;
    cmdOK: TORAlignButton;
    cmdCancel: TORAlignButton;
    pnlBase: TORAutoPanel;
    lblImmedColl: TOROffsetLabel;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure calImmedCollectKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FCollTime: string;
    { Private declarations }
  public
    { Public declarations }
  end;

function SelectImmediateCollectTime(FontSize: integer; CollTime: string): string;

implementation

{$R *.DFM}

uses  rODLab;

const
  TX_NOTIME_TEXT = 'Enter or select a collection time or press Cancel.';
  TX_NOTIME_CAP = 'Missing Date/Time';
  TX_BADTIME_CAP = 'Invalid Immediate Collect Time';

function SelectImmediateCollectTime(FontSize: integer; CollTime: string): string;
{ displays select form for immediate collect time and returns a record of the selection }
var
  frmODLabImmedColl: TfrmODLabImmedColl;
begin
  frmODLabImmedColl := TfrmODLabImmedColl.Create(Application);
  try
    ResizeAnchoredFormToFont(frmODLabImmedColl);
    with frmODLabImmedColl do
    begin
      FCollTime := CollTime;
      ShowModal;
      Result := FCollTime;
    end;
  finally
    frmODLabImmedColl.Release;
  end;
end;

procedure TfrmODLabImmedColl.cmdCancelClick(Sender: TObject);
begin
  FCollTime := '-1' ;
  Close;
end;

procedure TfrmODLabImmedColl.cmdOKClick(Sender: TObject);
var
  x: string;
begin
  if calImmedCollect.FMDateTime = 0 then
   begin
    InfoBox(TX_NOTIME_TEXT, TX_NOTIME_CAP, MB_OK or MB_ICONWARNING);
    Exit;
   end;
  if calImmedCollect.FMDateTime > 0 then
    begin
      x := ValidImmCollTime(calImmedCollect.FMDateTime);
      if Piece(x ,U, 1) = '1' then
        FCollTime := calImmedCollect.Text
      else
        begin
          InfoBox(MixedCase(Piece(x ,U, 2)), TX_BADTIME_CAP, MB_OK or MB_ICONWARNING);
          Exit;
        end;
    end
  else
    FCollTime := '-1';
  Close;
end;


procedure TfrmODLabImmedColl.FormShow(Sender: TObject);
begin
  setImmediateCollectTimes(memImmedCollect.Lines);
  if Length(FCollTime) > 0 then
    calImmedCollect.Text := FCollTime
  else
    calImmedCollect.FMDateTime := GetDefaultImmCollTime;
  ActiveControl := calImmedCollect;
end;

procedure TfrmODLabImmedColl.calImmedCollectKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    cmdCancelClick(cmdCancel);
  end;
end;

end.
