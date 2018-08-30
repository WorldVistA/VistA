{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey, Brian Juergensmeyer
	Description: Contains TRPCBroker and related components.
  Unit: fRPCBErrMsg Error Display to permit application control
        over bringing it to the front.
	Current Release: Version 1.1 Patch 50
*************************************************************** }

{ **************************************************
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
  Graphics, Controls, Forms, Dialogs, StdCtrls;

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
  MessageBox(0, PWideChar(ErrorText), nil, MB_ICONERROR or MB_OK);

//  frmErrMsg := TfrmErrMsg.Create(Application);
//  frmErrMsg.mmoErrorMessage.Lines.Add(ErrorText);
//  frmErrMsg.ShowModal;
//  frmErrMsg.Free;
end;

class procedure TfrmErrMsg.RPCBShowException(Sender: TObject; E: Exception);
begin
  {
  blj 6 Oct 2016 - Jazz item 329516
    Removing full form.  Simply use MessageBox for better 508 compliance.
  }
  MessageBox(0, PWideChar(E.Message), nil, MB_ICONERROR or MB_OK);

//  frmErrMsg := TfrmErrMsg.Create(Application);
//  frmErrMsg.mmoErrorMessage.Lines.Add(ErrorText);
//  frmErrMsg.ShowModal;
//  frmErrMsg.Free;
end;

end.
