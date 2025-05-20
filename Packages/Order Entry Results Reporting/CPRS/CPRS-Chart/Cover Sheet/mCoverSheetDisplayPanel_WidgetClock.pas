unit mCoverSheetDisplayPanel_WidgetClock;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Proof of concept and a fun idea.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  mCoverSheetDisplayPanel,
  iCoverSheetIntf;

type
  TfraCoverSheetDisplayPanel_WidgetClock = class(TfraCoverSheetDisplayPanel)
    tmrClock: TTimer;
    lblTime: TStaticText;
    procedure tmrClockTimer(Sender: TObject);
  private
    { Private declarations }
    fUse24HourClock: TMenuItem;
    fShowDayOfWeek: TMenuItem;
  protected
    { Protected declerations }
    procedure Use24HourClock(Sender: TObject);
    procedure ShowDayOfWeek(Sender: TObject);
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_WidgetClock: TfraCoverSheetDisplayPanel_WidgetClock;

implementation

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_WidgetClock }

constructor TfraCoverSheetDisplayPanel_WidgetClock.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fUse24HourClock := NewItem('Use 24 Hour Clock', 0, False, True, Use24HourClock, 0, 'pmnClock_Use24Hour');
  fShowDayOfWeek := NewItem('Show Day Of Week', 0, False, True, ShowDayOfWeek, 0, 'pmnClock_ShowDayOfWeek');

  pmn.Items.Add(NewItem('-', 0, False, False, nil, 0, 'pmnClock_Separator'));
  pmn.Items.Add(fUse24HourClock);
  pmn.Items.Add(fShowDayOfWeek);

  tmrClock.Interval := 60000;
  tmrClockTimer(nil);
  tmrClock.Enabled := True;
end;

procedure TfraCoverSheetDisplayPanel_WidgetClock.ShowDayOfWeek(Sender: TObject);
begin
  fShowDayOfWeek.Checked := not fShowDayOfWeek.Checked;
  tmrClockTimer(Sender);
end;

procedure TfraCoverSheetDisplayPanel_WidgetClock.Use24HourClock(Sender: TObject);
begin
  fUse24HourClock.Checked := not fUse24HourClock.Checked;
  tmrClockTimer(Sender);
end;

procedure TfraCoverSheetDisplayPanel_WidgetClock.tmrClockTimer(Sender: TObject);
var
  aDayOfWeek: string;
begin
  if fShowDayOfWeek.Checked then
    aDayOfWeek := #13#10 + FormatDateTime('dddd', Now) + #13#10
  else
    aDayOfWeek := #13#10;

  if fUse24HourClock.Checked then
    lblTime.Caption := aDayOfWeek + FormatDateTime('mmm d, yyyy', Now) + #13#10 + 'Time: ' + FormatDateTime('hhnn', Now)
  else
    lblTime.Caption := aDayOfWeek + FormatDateTime('mmm d, yyyy', Now) + #13#10 + 'Time: ' + FormatDateTime('h:nn am/pm', Now);
end;

end.
