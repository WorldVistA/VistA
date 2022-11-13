{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Joel Ivey, Brian Juergensmeyer, Roy Gaber
  Description: Contains TRPCBroker and related components.
  Unit: fRPCBErrMsg Error Display to permit application control
  over bringing it to the front.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.
  2. Corrected issue where error dialog was being
  hidden behind the parent application when an
  invalid access/verify code was entered for the
  second and subsequent times.

  Changes in v1.1.65 (HGW 10/06/2016) XWB*1.1*65
  1. Resolved CPRS Defect 329516 for 508 compliance (code submitted
  by Brian Juergensmeyer). Replaced MessageDlg (not 508 compliant)
  with MessageBox (508 compliant).

  Changes in v1.1.60 (HGW 12/16/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
  ************************************************** }

unit fRPCBErrMsg;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmErrMsg = class(TForm)
    Button1: TButton;
    mmoErrorMessage: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure RPCBShowException(Sender: TObject; E: Exception);
  end;

procedure RPCBShowErrMsg(ErrorText: String);

var
  frmErrMsg: TfrmErrMsg;

implementation

{$R *.DFM}

procedure RPCBShowErrMsg(ErrorText: String);
begin
  {
    blj 6 Oct 2016 - Jazz item 329516
    Removing full form.  Simply use MessageBox for better 508 compliance.
  }
  // p71 - Added Application.NormalizeTopMosts to ensure error
  // dialog is sent to the top when presented
  Application.NormalizeTopMosts;
  MessageBox(0, PWideChar(ErrorText), nil, MB_ICONERROR or MB_OK);

  // frmErrMsg := TfrmErrMsg.Create(Application);
  // frmErrMsg.mmoErrorMessage.Lines.Add(ErrorText);
  // frmErrMsg.ShowModal;
  // frmErrMsg.Free;
end;

class procedure TfrmErrMsg.RPCBShowException(Sender: TObject; E: Exception);
begin
  {
    blj 6 Oct 2016 - Jazz item 329516
    Removing full form.  Simply use MessageBox for better 508 compliance.
  }
  // p71 - Added Application.NormalizeTopMosts to ensure error
  // dialog is sent to the top when presented
  Application.NormalizeTopMosts;
  MessageBox(0, PWideChar(E.Message), nil, MB_ICONERROR or MB_OK);

  // frmErrMsg := TfrmErrMsg.Create(Application);
  // frmErrMsg.mmoErrorMessage.Lines.Add(ErrorText);
  // frmErrMsg.ShowModal;
  // frmErrMsg.Free;
end;

end.
