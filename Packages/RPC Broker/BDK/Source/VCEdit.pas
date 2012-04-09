{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Verify Code edit dialog.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit VCEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  {Broker units}
  Trpcb, Hash;

type
  TVCEdit = class(TComponent)
    private
      FRPCBroker : TRPCBroker;
      FOldVC     : string;
      FConfirmFailCnt : integer;  //counts failed confirms.
      FHelp      : string;
      FOldVCSet: Boolean;  // Shows whether old code was passed in, even if NULL
      procedure NoChange(reason : string);
    protected
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function ChangeVCKnowOldVC(strOldVC : string) : Boolean;
      function ChangeVC : Boolean;
    published
      property RPCBroker : TRPCBroker read FRPCBroker write FRPCBroker;
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
  protected
    { Private declarations }
    FVCEdit : TVCEdit;   //Links form to instance of VCEdit.
  public
    { Public declarations }
  end;

function ChangeVerify(RPCBroker: TRPCBroker): Boolean;
function SilentChangeVerify(RPCBroker: TRPCBroker; OldVerify, NewVerify1, NewVerify2: String; var Reason: String): Boolean;

var
  frmVCEdit: TfrmVCEdit;

const
  MAX_CONFIRM_FAIL : integer = 3;
  U = '^';

{procedure Register;}

implementation

{$R *.DFM}

function ChangeVerify(RPCBroker: TRPCBroker): Boolean;
var
  VCEdit1: TVCEdit;
begin
//  Str := '';
  VCEdit1 := TVCEdit.Create(Application);
  try
    VCEdit1.RPCBroker := RPCBroker;
    if VCEdit1.ChangeVC then  //invoke VCEdit form.                                              //VC changed.
      Result := True
    else
      Result := False;
  finally
    VCEdit1.Free;
  end;
end;

function SilentChangeVerify(RPCBroker: TRPCBroker; OldVerify, NewVerify1, NewVerify2: String; var Reason: String): Boolean;
var
  OrigContext: String;
begin
  Result := False;
  Reason := '';
  if OldVerify = NewVerify1 then
    Reason := 'The new code is the same as the current one.'
  else
  if NewVerify1 <> NewVerify2 then
    Reason := 'The confirmation code does not match.';
  if Reason = '' then
  try
    with RPCBroker do
    begin
      OrigContext := CurrentContext;
      CreateContext('XUS SIGNON');
      RemoteProcedure := 'XUS CVC';
      Param[0].PType := literal;
      Param[0].Value := Encrypt(OldVerify)
                        + U + Encrypt(NewVerify1)
                        + U + Encrypt(NewVerify2) ;
      Call;
      Reason := '';
      if Results[0] = '0' then
        Result := True
      else if Results.Count > 1 then
        Reason := Results[1];
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

{------------------TVCEdit component------------------------------------}

constructor TVCEDit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldVCSet := False;
end;

destructor TVCEDit.Destroy;
begin
  inherited Destroy;
end;


function TVCEdit.ChangeVCKnowOldVC(strOldVC : string) : Boolean;
begin
  FOldVC := strOldVC;
  FOldVCSet := True;
  Result := ChangeVC;
  FOldVCSet := False;  // set it back to false in case we come in again
end;

{--------------------------ChangeVC function---------------------------}
function TVCEdit.ChangeVC : Boolean;
var
  OldHandle: THandle;
begin
  Result := False;
  try
    frmVCEDit := TfrmVCEDit.Create(application);
    with frmVCEDit do
    begin
      FVCEdit := Self;      //To link form to VCEdit instance.
      if FOldVCSet then      //If old VC known, stuff it & disable editing.
      begin
        edtOldVC.Color := clBtnFace;
        edtOldVC.Enabled := False;
        edtOldVC.Text := FOldVC;
      end{if};
//          ShowApplicationAndFocusOK(Application);
      OldHandle := GetForegroundWindow;
      SetForegroundWindow(frmVCEdit.Handle);
      if ShowModal = mrOK then    //outcome of form.
        Result := True;
      SetForegroundWindow(OldHandle);
    end{with};
  frmVCEDit.Free;
  except
    on E: Exception do
    begin
      FRPCBroker.RPCBError := E.Message;
      if Assigned(FRPCBroker.OnRPCBFailure) then
        FRPCBroker.OnRPCBFailure(FRPCBroker)
      else if FRPCBroker.ShowErrorMsgs = semRaise then
        Raise;
    end;
  end{except};
end;

{------------------TVCEdit.NoChange-------------------------------------
-----------Displays error messages when change fails.-------------------}
procedure TVCEdit.NoChange(reason : string);
begin
  ShowMessage('Your VERIFY code was not changed.' + #13 +
              reason + #13 );
end;


{-------------------------TfrmVCEdit methods-------------------------------}
procedure TfrmVCEdit.btnOKClick(Sender: TObject);
begin
  with FVCEdit do
  begin
    if edtOldVC.Text = edtNewVC.Text then
    begin
      NoChange('The new code is the same as the current one.');
      edtNewVC.Text := '';
      edtConfirmVC.Text := '';
      edtNewVC.SetFocus;
    end
    else
    if edtNewVC.Text <> edtConfirmVC.Text then
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
        edtConfirmVC.text := '';
        NoChange('The confirmation code does not match.  Try again.');
        edtConfirmVC.SetFocus;
      end;
    end
    else
    with FRPCBroker do
    begin
      RemoteProcedure := 'XUS CVC';
      Param[0].PType := literal;
      Param[0].Value := Encrypt(edtOldVC.Text)
                        + U + Encrypt(edtNewVC.Text)
                        + U + Encrypt(edtConfirmVC.Text) ;
      Call;
      if Results[0] = '0' then
      begin
        ShowMessage('Your VERIFY CODE has been changed');
        ModalResult := mrOK;  //Close form.
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
  end{with};
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
        FHelp := 'Enter a new verify code and then confirm it.'
                 + #13#13 + FHelp;
        if FOldVC = '' then
          FHelp := 'Enter your current verify code first.' + #13#10 + FHelp;
      end{with};
    end{if};
    ShowMessage(FHelp);
  end{with};
end;

procedure TfrmVCEdit.edtNewVCExit(Sender: TObject);
begin
  if edtNewVC.Modified then
  begin
    FVCEdit.FConfirmFailCnt := 0;                //Reset counter.
    edtNewVC.Modified := False;
  end;
end;

procedure TfrmVCEdit.edtOldVCChange(Sender: TObject); //Also NewVC and ConfirmVC
begin
  btnOk.Default := ((edtNewVC.Text <> '') and        //Update status of OK btn.
                    (edtOldVC.Text <> '') and
                    (edtConfirmVC.Text <> '') );
end;

end.
