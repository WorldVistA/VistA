unit fGMV_Splash;
{
================================================================================
*
*       Application:  Vitals Manager
*       Revision:     $Revision: 1 $  $Modtime: 3/10/08 11:28a $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Generic splash form
*
*       Notes:
*
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON/fGMV_Splash.pas $
*
* $History: fGMV_Splash.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSCOMMON
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 3/10/08    Time: 4:34p
 * Updated in $/Vitals Source/Vitals/VITALSCOMMON
 * 5.0.22.5 Internal version 6
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/VitalsCommon
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
*
================================================================================
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls, jpeg;

type
  TfrmGMV_Splash = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    lblVersion: TLabel;
    lblDevelopedAt: TLabel;
    lblReleaseDate: TLabel;
    lblMessage: TLabel;
    pnlPatch: TPanel;
    lblpatch: TLabel;
    lblSecurity: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpdateMessage(NewMessage: string; Step: integer = 0);
    { Public declarations }
  end;

var
  GMVSplash: TfrmGMV_Splash;

implementation

uses fGMV_AboutDlg, uGMV_VersionInfo;

{$R *.DFM}

procedure TfrmGMV_Splash.FormCreate(Sender: TObject);
var
  version: string;
  patch: string;
  releasedate: string;
  testversion: Boolean;
  sproductname: string;
begin
  with TVersionInfo.Create(Self) do
    try
      version := VAServerVersion;
      patch := VAPatchNumber;
      releasedate := VAReleaseDate;
      testversion := VATestVersion;
      sproductname := ProductName;
    finally
      free;
    end;

  lblVersion.Caption := 'Version: ' + version;

  lblPatch.Caption := '';
  pnlPatch.Visible := (testversion or (patch <> ''));
  if patch <> '' then
    lblPatch.Caption := 'Patch ' + patch + ' ';

  if testversion then
    lblPatch.Caption := 'Test Release ' + lblPatch.Caption;

  lblReleaseDate.Caption := releasedate;
//  lblInset.Caption := sproductname;
//  lblShadow.Caption := sproductname;
//  lblInset.Font.Color := clActiveCaption;
//  lblShadow.Font.Color := clbtnHighlight;
//  lblShadow.Left := lblInset.Left + 1;
//  lblShadow.Top := lblInset.Top + 1;
//  Position := poScreenCenter;
//  pbStatus.Visible := False;
  Show;
  Application.ProcessMessages;
end;

procedure TfrmGMV_Splash.UpdateMessage(NewMessage: string; Step: integer = 0);
begin
  lblMessage.Caption := NewMessage;
//  pbStatus.Position := Step;
//  pbStatus.Visible := (Step > 0);
  Refresh;
end;

procedure TfrmGMV_Splash.FormShow(Sender: TObject);
begin
  left := (Screen.Width - width) div 2;
  top := (Screen.Height-Height)div 2;
  invalidate;
end;

end.

