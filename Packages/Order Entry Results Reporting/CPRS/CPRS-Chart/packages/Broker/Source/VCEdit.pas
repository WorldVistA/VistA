{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey, Herlan Westra
  Description: Contains TRPCBroker and related components.
  Unit: VCEdit Verify Code edit dialog.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. Changed TVCEdit.ChangeVCKnowOldVC so that if old verify code was less
  than eight digits, box would not be greyed out (manually enter old VC).
  This is because using SSO, old VC is not entered in login form.
  2. Added procedure btnCancelClick to continue with login if user chooses
  to cancel changing verify code.

  Changes in v1.1.60 (HGW 11/20/2013) XWB*1.1*60
  1. Fixed process to change VC. VC change did not work if lowercase chars
  were used in the new verify code. GUI was case-sensitive, but VistA is not.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
  ************************************************** }
unit VCEdit;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {VA}
  Trpcb, XWBHash,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TVCEdit = class(TComponent)
  private
    FRPCBroker: TRPCBroker;
    FOldVC: string;
    FConfirmFailCnt: integer; // counts failed confirms.
    FHelp: string;
    FOldVCSet: Boolean; // Shows whether old code was passed in, even if NULL
    procedure NoChange(reason: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ChangeVCKnowOldVC(strOldVC: string): Boolean;
    function ChangeVC: Boolean;
  published
    property RPCBroker: TRPCBroker read FRPCBroker write FRPCBroker;
  end;

  TfrmVCEdit = class(TForm)
    lblOldVC: TLabel;
    lblNewVC: TLabel;
    lblConfirmVC: TLabel;
    edtOldVC: TEdit;
    edtNewVC: TEdit;
    edtConfirmVC: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure edtNewVCExit(Sender: TObject);
    procedure edtOldVCChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  protected
    { Private declarations }
    FVCEdit: TVCEdit; // Links form to instance of VCEdit.
  public
    { Public declarations }
  end;

function ChangeVerify(RPCBroker: TRPCBroker): Boolean;
function SilentChangeVerify(RPCBroker: TRPCBroker;
  OldVerify, NewVerify1, NewVerify2: String; var reason: String): Boolean;

var
  frmVCEdit: TfrmVCEdit;

const
  MAX_CONFIRM_FAIL: integer = 3;
  U = '^';

  { procedure Register; }

implementation

{$R *.DFM}

function ChangeVerify(RPCBroker: TRPCBroker): Boolean;
var
  VCEdit1: TVCEdit;
begin
  // Str := '';
  VCEdit1 := TVCEdit.Create(Application);
  try
    VCEdit1.RPCBroker := RPCBroker;
    if VCEdit1.ChangeVC then
      // invoke VCEdit form.                                              //VC changed.
      Result := True
    else
      Result := False;
  finally
    VCEdit1.Free;
  end;
end;

function SilentChangeVerify(RPCBroker: TRPCBroker;
  OldVerify, NewVerify1, NewVerify2: String; var reason: String): Boolean;
var
  OrigContext: String;
begin
  Result := False;
  reason := '';
  if OldVerify = NewVerify1 then
    reason := 'The new code is the same as the current one.'
  else if NewVerify1 <> NewVerify2 then
    reason := 'The confirmation code does not match.';
  if reason = '' then
    try
      with RPCBroker do
      begin
        OrigContext := CurrentContext;
        CreateContext('XUS SIGNON');
        RemoteProcedure := 'XUS CVC';
        Param[0].PType := literal;
        Param[0].Value := Encrypt(OldVerify) + U + Encrypt(NewVerify1) + U +
          Encrypt(NewVerify2);
        Call;
        reason := '';
        if Results[0] = '0' then
          Result := True
        else if Results.Count > 1 then
          reason := Results[1];
        CreateContext(OrigContext);
      end;
    except
      on E: Exception do
      begin
        RPCBroker.RPCBError := E.Message;
        if Assigned(RPCBroker.OnRPCBFailure) then
          RPCBroker.OnRPCBFailure(RPCBroker)
        else if RPCBroker.ShowErrorMsgs = semRaise then
          Raise;
      end;
    end;
end;

{ ------------------TVCEdit component------------------------------------ }

constructor TVCEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldVCSet := False;
end;

destructor TVCEdit.Destroy;
begin
  inherited Destroy;
end;

function TVCEdit.ChangeVCKnowOldVC(strOldVC: string): Boolean;
begin
  FOldVC := strOldVC;
  FOldVCSet := True;
  if Length(FOldVC) < 8 then
    FOldVCSet := False;
  Result := ChangeVC;
  FOldVCSet := False; // set it back to false in case we come in again
end;

{ --------------------------ChangeVC function--------------------------- }
function TVCEdit.ChangeVC: Boolean;
var
  OldHandle: THandle;
begin
  Result := False;
  try
    frmVCEdit := TfrmVCEdit.Create(Application);
    with frmVCEdit do
    begin
      FVCEdit := Self; // To link form to VCEdit instance.
      if FOldVCSet then // If old VC known, stuff it & disable editing.
      begin
        edtOldVC.Color := clBtnFace;
        edtOldVC.Enabled := False;
        edtOldVC.Text := FOldVC;
      end { if };
      // ShowApplicationAndFocusOK(Application);
      OldHandle := GetForegroundWindow;
      SetForegroundWindow(frmVCEdit.Handle);
      if ShowModal = mrOK then // outcome of form.
        Result := True;
      SetForegroundWindow(OldHandle);
    end { with };
    frmVCEdit.Free;
  except
    on E: Exception do
    begin
      FRPCBroker.RPCBError := E.Message;
      if Assigned(FRPCBroker.OnRPCBFailure) then
        FRPCBroker.OnRPCBFailure(FRPCBroker)
      else if FRPCBroker.ShowErrorMsgs = semRaise then
        Raise;
    end;
  end { except };
end;

{ ------------------TVCEdit.NoChange-------------------------------------
  -----------Displays error messages when change fails.------------------- }
procedure TVCEdit.NoChange(reason: string);
begin
  ShowMessage('Your VERIFY code was not changed.' + #13 + reason + #13);
end;

{ -------------------------TfrmVCEdit methods------------------------------- }
procedure TfrmVCEdit.btnOKClick(Sender: TObject);
begin
  with FVCEdit do
  begin
    edtOldVC.Text := AnsiUpperCase(edtOldVC.Text); // p60
    edtNewVC.Text := AnsiUpperCase(edtNewVC.Text); // p60
    edtConfirmVC.Text := AnsiUpperCase(edtConfirmVC.Text); // p60
    if edtOldVC.Text = edtNewVC.Text then
    begin
      NoChange('The new code is the same as the current one.');
      edtNewVC.Text := '';
      edtConfirmVC.Text := '';
      edtNewVC.SetFocus;
    end
    else if edtNewVC.Text <> edtConfirmVC.Text then
    begin
      inc(FConfirmFailCnt);
      if FConfirmFailCnt > MAX_CONFIRM_FAIL then
      begin
        edtNewVC.Text := '';
        edtConfirmVC.Text := '';
        NoChange('The confirmation code does not match.');
        edtNewVC.SetFocus;
      end
      else
      begin
        edtConfirmVC.Text := '';
        NoChange('The confirmation code does not match.  Try again.');
        edtConfirmVC.SetFocus;
      end;
    end
    else
      with FRPCBroker do
      begin
        RemoteProcedure := 'XUS CVC';
        Param[0].PType := literal;
        Param[0].Value := Encrypt(edtOldVC.Text) + U + Encrypt(edtNewVC.Text) +
          U + Encrypt(edtConfirmVC.Text);
        Call;
        if Results[0] = '0' then
        begin
          ShowMessage('Your VERIFY CODE has been changed');
          ModalResult := mrOK; // Close form.
        end
        else
        begin
          if Results.Count > 1 then
            NoChange(Results[1])
          else
            NoChange('');
          edtNewVC.Text := '';
          edtConfirmVC.Text := '';
          edtNewVC.SetFocus;
        end;
      end;
  end { with };
end;

procedure TfrmVCEdit.btnCancelClick(Sender: TObject);
begin
  with FVCEdit do
  begin
    edtOldVC.Text := AnsiUpperCase(edtOldVC.Text); // p65
    NoChange('You chose to cancel the change.');
    ModalResult := mrOK; // result
  end { with };
end;

procedure TfrmVCEdit.btnHelpClick(Sender: TObject);
begin
  with FVCEdit do
  begin
    if FHelp = '' then
    begin
      with FRPCBroker do
      begin
        RemoteProcedure := 'XUS AV HELP';
        Call;
        if Results.Count > 0 then
          FHelp := Results[0];
        FHelp := 'Enter a new verify code and then confirm it.' +
          #13#13 + FHelp;
        if FOldVC = '' then
          FHelp := 'Enter your current verify code first.' + #13#10 + FHelp;
      end { with };
    end { if };
    ShowMessage(FHelp);
  end { with };
end;

procedure TfrmVCEdit.edtNewVCExit(Sender: TObject);
begin
  if edtNewVC.Modified then
  begin
    FVCEdit.FConfirmFailCnt := 0; // Reset counter.
    edtNewVC.Modified := False;
  end;
end;

procedure TfrmVCEdit.edtOldVCChange(Sender: TObject);
// Also NewVC and ConfirmVC
begin
  btnOK.Default := ((edtNewVC.Text <> '') and // Update status of OK btn.
    (edtOldVC.Text <> '') and (edtConfirmVC.Text <> ''));
end;

end.
