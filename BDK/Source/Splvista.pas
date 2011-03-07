{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Displays VistA splash screen.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit Splvista;

{       1.1*14 Modified the tick types so that code will work with D3, D4,
        D5. -- DPC 3/30/00

        1.1*11 Changed
        from:   var StartTick: longint;
        to:     var StartTick: longword
        from:   procedure SplashClose(TimeOut: longint);
        to:     procedure SplashClose(TimeOut: longword);
        [Warning] Splvista.pas(53): Combining signed and unsigned types - widened both operands
         In Delphi 5 (ver130), GetTickCount's result is of type DWORD, longword
         danila - 9/27/99}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TfrmVistaSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVistaSplash: TfrmVistaSplash;
    StartTick: longword;

procedure SplashOpen;

  procedure SplashClose(TimeOut: longword);

implementation

{$R *.DFM}



procedure SplashOpen;
begin
  StartTick := GetTickCount;
  try
    frmVistaSplash := TfrmVistaSplash.Create(Application);
    frmVistaSplash.Show;
  except
    frmVistaSplash.Release;
    frmVistaSplash := nil;
  end;
end;



  procedure SplashClose(TimeOut: longword);
begin
  try
    while (GetTickCount - StartTick) < TimeOut do Application.ProcessMessages;
    frmVistaSplash.Release;
    frmVistaSplash := nil;
  except
  end;
end;


procedure TfrmVistaSplash.FormCreate(Sender: TObject);
begin
  {This positions the label correctly in the lower right-hand corner regardless
  of the resolution of font size.}
  Label1.Caption := 'Department of Veterans Affairs' + #13 +
                    'Veterans Health Administration';
  Label1.Left := Width - 25 - Label1.Width;       //offset 25 pixels from right
  Label1.Top  := Height - 25 - Label1.Height;     //offset 25 pixels from bottom
end;

end.
