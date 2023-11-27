unit fSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, fBase508Form, VA508AccessibilityManager, Vcl.AppEvnts;

type
  TfrmSplash = class(TfrmBase508Form)
    pnlMain: TPanel;
    lblVersion: TStaticText;
    lblCopyright: TStaticText;
    pnlImage: TPanel;
    Image1: TImage;
    lblSplash: TStaticText;
    pnl508Disclaimer: TPanel;
    mm: TMemo;
    ae: TApplicationEvents;
    lblCRC: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmChange(Sender: TObject);
    procedure aeIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
    procedure UpdateMemoSize;
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

uses VAUtils, ORFn;

type
  TCRCThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(form: TfrmSplash); overload;
  end;

var
  fSplashForm: TfrmSplash;

procedure TfrmSplash.aeIdle(Sender: TObject; var Done: Boolean);
begin
  inherited;
  HideCaret(mm.Handle);
end;

procedure TfrmSplash.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  inherited;
  lblVersion.Caption := 'version ' + FileVersionValue(Application.ExeName,
    FILE_VER_FILEVERSION);
  lblSplash.Invalidate;
//  TCRCThread.Create(Self);
end;

procedure TfrmSplash.FormDestroy(Sender: TObject);
begin
  fSplashForm := nil;
  inherited;
end;

procedure TfrmSplash.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_Escape then
    Close;
end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  inherited;
  UpdateMemoSize;
end;

procedure TfrmSplash.mmChange(Sender: TObject);
begin
  inherited;
  UpdateMemoSize;
end;

procedure TfrmSplash.UpdateMemoSize;
var
  newHeight,
  LineHeight: Integer;
  DC: HDC;
  SaveFont : HFont;
  Metrics : TTextMetric;
  Increase: Integer;
  LC: Integer;
begin
  DC := GetDC(mm.Handle);
  SaveFont := SelectObject(DC, mm.Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(mm.Handle, DC);
  LineHeight := Metrics.tmHeight;
  Increase := mm.Height;
  LC := mm.Lines.Count;
  newHeight := (LC + 1) * LineHeight + 8;
  Increase := newHeight - Increase;
  self.Height := self.Height + Increase;
end;

{ TCRCThread }

constructor TCRCThread.Create(form: TfrmSplash);
begin
  fSplashForm := form;
  FreeOnTerminate := True;
  inherited Create(false);
end;

procedure TCRCThread.Execute;
var
  crc: string;

begin
  crc := IntToHex(CRCForFile(Application.ExeName), 8);
  Synchronize(
    procedure
    begin
      if assigned(fSplashForm) then
      begin
        fSplashForm.lblCRC.Caption := 'CRC: ' + crc;
        fSplashForm.lblCRC.Refresh;
      end;
    end);
end;

end.
