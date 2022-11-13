unit mDSTMgr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Actions, Vcl.ActnList, oDST;

type
  TfrDSTMgr = class(TFrame)
    btnLaunchToolbox: TButton;
    alDST: TActionList;
    acDST: TAction;
    procedure acDSTExecute(Sender: TObject);
  private
    { Private declarations }
    fDstProvider: TdstProvider;
    fDstID: String;
    fDstResult: String;
    fDSTCase: String;
    fDSTMode: String;
    fDSTService: String;
    fDSTUrgency: String;
    fDSTCid: Double;
    fDSTNltd: Double;
    fDSTOutpatient: String;
    fDSTAction: Integer;
    procedure setDSTMode(aMode: String);
    procedure setDSTAction(anAction: Integer);
  public
    { Public declarations }
    property DstProvider: TdstProvider read fDstProvider write fDstProvider;
    property DSTId: String read fDstID write fDstID;
    property DSTService: String read fDSTService write fDSTService;
    property DSTUrgency: String read fDSTUrgency write fDSTUrgency;
    property DSTCid: Double read fDSTCid write fDSTCid;
    property DSTNltd: Double read fDSTNltd write fDSTNltd;
    property DSTOutpatient: String read fDSTOutpatient write fDSTOutpatient;
    property DSTCase: String read fDSTCase write fDSTCase;
    property DSTMode: String read fDSTMode write setDSTMode;
    property DSTAction: Integer read fDSTAction write setDSTAction;
    property DSTResult: String read fDstResult write fDstResult;

    procedure DSTInit(aCase: String = '');
    procedure DSTFree;
    procedure doDst;
    procedure doDSTConsultAct;
    procedure doDSTConsult(aWorkflow: String = 'ORDER');

    procedure setFontSize(aSize: Integer);
  end;

const
  DST_DST = 'D';
  DST_CTB = 'C';
  DST_OTH = 'O';

  DST_CASE_CONSULT_ACT = 'CONSULT_ACT';
  DST_CASE_CONSULT_EDIT = 'CONSULT_EDIT';
  DST_CASE_CONSULTS = 'CONSULTS';
  DST_CASE_CONSULT_OD = 'CONSULT_OD';

function isDstEnabled: Boolean;
function isCtbEnabled: Boolean;

implementation

uses
  fConsults, uSizing, uConsults, uCore, uDstConst;

function isDstEnabled: Boolean;
begin
  Result := SystemParameters.AsType<string>(DST_CTB_SWITCH) <> '0';
end;

function isCtbEnabled: Boolean;
begin
  Result := SystemParameters.AsType<string>(CTB_ENABLED) <> '0';
end;

{$R *.dfm}

procedure TfrDSTMgr.setDSTMode(aMode: string);
var
  s: String;
begin
  s := 'Disabled';
  DstProvider.DSTMode := aMode;
  if aMode = DST_DST then
    s := 'Launch DST'
  else if aMode = DST_CTB then
    s := 'Open Consult Toolbox'
  else if aMode = DST_OTH then
    Self.Visible := False
  else if aMode = '' then
    Self.Visible := False;
  btnLaunchToolbox.Caption := s;
end;

procedure TfrDSTMgr.setDSTAction(anAction: Integer);
begin
  fDSTAction := anAction;
  btnLaunchToolbox.Visible := False;
  // add comment always has a button unless Switch = 'O'
  if anAction = CN_ACT_ADD_CMT then
    btnLaunchToolbox.Visible := DstProvider.DstParameters.fComment
  else if DstProvider.DstParameters.fSwitch = 'C' then
    case anAction of
      CN_ACT_FORWARD:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.fForward;
      CN_ACT_ADMIN_COMPLETE:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.fAdminComp;
      CN_ACT_SIGFIND:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.fSigFind;
      CN_ACT_RECEIVE:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.fReceive;
      CN_ACT_SCHEDULE:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.fSchedule;
      CN_ACT_DENY:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.fCancel;
      CN_ACT_DISCONTINUE:
        btnLaunchToolbox.Visible := DstProvider.DstParameters.FDiscontinue;
    end;
  btnLaunchToolbox.Enabled := btnLaunchToolbox.Visible;
end;

procedure TfrDSTMgr.DSTInit(aCase: String = '');
begin
  InitDST; // one provider for all dialogs
  fDstProvider := DSTPro;
  fDSTMode := DSTPro.DstParameters.fSwitch; // DST_DST;
  fDSTCase := aCase;
end;

procedure TfrDSTMgr.acDSTExecute(Sender: TObject);
begin
  doDst;
end;

procedure TfrDSTMgr.DSTFree;
begin
  // if assigned(fDstProvider) then
  // fDstProvider := nil; // single DstPro is used for all dialogs/windows
end;

procedure TfrDSTMgr.doDSTConsultAct;

  function getActionName: String;
  begin
    case fDSTAction of
      CN_ACT_FORWARD:
        Result := 'FORWARD';
      CN_ACT_ADD_CMT:
        Result := 'COMMENT';
      CN_ACT_ADMIN_COMPLETE:
        Result := 'ADMINISTRATIVE COMPLETE';
      CN_ACT_SIGFIND:
        Result := 'SIGNIFICANT FINDING';
      CN_ACT_RECEIVE:
        Result := 'RECEIVE';
      CN_ACT_SCHEDULE:
        Result := 'SCHEDULE';
      CN_ACT_DENY:
        Result := 'CANCEL-DENY';
      CN_ACT_DISCONTINUE:
        Result := 'DISCONTINUE';
    else
      Result := '';
    end;
  end;

begin
  DSTId := DstProvider.getDstUuid(DSTId, DSTService, DSTUrgency,
    ConsultRec.ClinicallyIndicatedDate, ConsultRec.NoLaterThanDate,
    getActionName, DSTOutpatient);
  if DSTId <> '' then
  begin
    DstProvider.getDSTReply(DSTId);
{ 310.1
    if i <> mrOK then
    begin
      // process cancelation of review
    end
    else
}
    begin
      // process successful review
      DstResult := DstProvider.getDstReply(DSTId, getActionName());

      //1297275 - need DST team to tell what to do for this scenario
      {if DSTId <> ConsultRec.DstID then
        ShowMessage('Debugger: DST has returned an updated DST ID.' + #10#13
        + 'The consult record needs to be updated.');}
    end;
  end;
end;

procedure TfrDSTMgr.doDSTConsult(aWorkflow: String = 'ORDER');
begin
  DSTId := DstProvider.getDstUuid(DSTId, DSTService, DSTUrgency, DSTCid,
    DSTNltd, aWorkflow, DSTOutpatient);

  if DSTId <> '' then
  begin
      DstProvider.getDSTReply(DSTId);
      DSTResult := DstProvider.getDSTReply(DSTId, aWorkflow);
  end
  else
    DSTResult := '';
end;

procedure TfrDSTMgr.doDst;
begin
  if not assigned(DstProvider) then
    ShowMessage('DST Provider is not defined')
  else if DSTCase = '' then
    ShowMessage('DST execution case is not defined!')
  else if DSTCase = DST_CASE_CONSULT_ACT then
    doDSTConsultAct
  else if DSTCase = DST_CASE_CONSULT_EDIT then
    doDSTConsult('EDIT-RESUBMIT')
  else if DSTCase = DST_CASE_CONSULT_OD then
    doDSTConsult('ORDER');
end;

procedure TfrDSTMgr.setFontSize(aSize: Integer);
var
  i: Integer;
begin
  Font.Size := aSize;
  i := getMainFormTextWidth(btnLaunchToolbox.Caption) + GAP * 2;
  Width := i;
end;

end.
