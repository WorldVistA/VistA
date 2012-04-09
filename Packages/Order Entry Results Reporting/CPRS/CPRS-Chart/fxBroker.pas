unit fxBroker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateUtils, ORNet, ORFn, rMisc, ComCtrls, Buttons, ExtCtrls,
  ORCtrls, ORSystem, fBase508Form, VA508AccessibilityManager;

type
  TfrmBroker = class(TfrmBase508Form)
    pnlTop: TORAutoPanel;
    lblMaxCalls: TLabel;
    txtMaxCalls: TCaptionEdit;
    cmdPrev: TBitBtn;
    cmdNext: TBitBtn;
    udMax: TUpDown;
    memData: TRichEdit;
    lblCallID: TStaticText;
    btnRLT: TButton;
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
  private
    { Private declarations }
    FRetained: Integer;
    FCurrent: Integer;
  public
    { Public declarations }
  end;

procedure ShowBroker;

implementation

{$R *.DFM}

procedure ShowBroker;
var
  frmBroker: TfrmBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  try
    ResizeAnchoredFormToFont(frmBroker);
    with frmBroker do
    begin
      FRetained := RetainedRPCCount - 1;
      FCurrent := FRetained;
      LoadRPCData(memData.Lines, FCurrent);
      memData.SelStart := 0;
      lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
      ShowModal;
    end;
  finally
    frmBroker.Release;
  end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  FCurrent := HigherOf(FCurrent - 1, 0);
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  FCurrent := LowerOf(FCurrent + 1, FRetained);
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5))
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.FormCreate(Sender: TObject);
begin
  udMax.Position := GetRPCMax;
end;

procedure TfrmBroker.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmBroker.btnRLTClick(Sender: TObject);
var
  startTime, endTime: tDateTime;
  clientVer, serverVer, diffDisplay: string;
  theDiff: integer;
const
  TX_OPTION  = 'OR CPRS GUI CHART';
  disclaimer = 'NOTE: Strictly relative indicator:';
begin

clientVer := clientVersion(Application.ExeName); // Obtain before starting.

// Check time lapse between a standard RPC call:
startTime := now;
serverVer :=  serverVersion(TX_OPTION, clientVer);
endTime := now;
theDiff := milliSecondsBetween(endTime, startTime);
diffDisplay := intToStr(theDiff);

// Show the results:
infoBox('Lapsed time (milliseconds) = ' + diffDisplay + '.', disclaimer, MB_OK);

end;

end.
