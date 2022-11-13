{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey, Herlan Westra
  Description: Contains TRPCBroker and related components.
  Unit: Splvista displays VistA splash screen.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 07/19/2016) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 09/11/2013) XWB*1.1*60
  1. Updated graphics and simplified coding.

  Changes in v1.1.14 (DPC 03/30/2000) XWB*1.1*14
  1. Modified the tick types so that code will work with D3, D4, D5.

  Changes in v1.1.11 (DCM 09/27/1999) XWB*1.1*11
  1. Resolved error in Delphi 5 (ver130) combining signed and unsigned
  types - widened both operands. Changed StartTick from longint to
  longword, and SplashClose(TimeOut) from longint to longword.
  GetTickCount's result is of type DWORD, longword.
  ************************************************** }
unit Splvista;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  WinTypes, WinProcs, Messages,
  {Vcl}
  Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TfrmVistaSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;

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
    while (GetTickCount - StartTick) < TimeOut do
      Application.ProcessMessages;
    frmVistaSplash.Release;
    frmVistaSplash := nil;
  except
  end;
end;

end.
