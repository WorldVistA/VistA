unit fNoteCPFields;
{------------------------------------------------------------------------------
Update History

    2016-03-03: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORCtrls, ORFn, ORDtTm, VA508AccessibilityManager,
  Vcl.ExtCtrls, fBase508Form;

type

  TfrmNoteCPFields = class(TfrmBase508Form)
    lblAuthor: TLabel;
    cboAuthor: TORComboBox;
    lblProcSummCode: TOROffsetLabel;
    cboProcSummCode: TORComboBox;
    lblProcDateTime: TOROffsetLabel;
    calProcDateTime: TORDateBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cboAuthorNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
  private
    FAuthor: int64;
    FProcSummCode: integer;
    FProcDateTime: TFMDateTime;
    FCPStatusFlag: integer;
    FOKPressed: Boolean;
    Function ValidateFields(var ErrMsg: string): Boolean;
  end;

const
  TC_REQ_FIELDS        = 'Required Information';
  TX_REQ_AUTHOR        = CRLF + 'The author of the note must be identified.';
  TX_REQ_AUTHOR_DUPL   = CRLF + 'The author confirmation failed.';
  TX_NO_FUTURE         = CRLF + 'A reference date/time in the future is not allowed.';
  TX_REQ_PROCSUMMCODE  = CRLF + 'A procedure summary code for this procedure must be entered.';
  TX_REQ_PROCDATETIME  = CRLF + 'A valid date/time for the procedure must be entered.';
  TX_INVALID_PROCDATETIME = CRLF + 'If entered, the date/time for the procedure must be in a valid format.';
  TX_NO_PROC_FUTURE    = CRLF + 'A procedure date/time in the future is not allowed.';
  TX_REQ_CANCEL        = 'You will be required to enter these fields before the note can be saved or signed.' + CRLF +
                         'Click the "Change" button to enter this information at any time while editing.';

procedure EnterClinProcFields(ACPStatusFlag: integer; ErrMsg: string; var AProcSummCode: integer; var AProcDate: TFMDateTime; var AnAuthor: int64);

implementation

{$R *.DFM}

uses rCore, uConst, uConsults, uCore, uORLists, uSimilarNames;

procedure EnterClinProcFields(ACPStatusFlag: integer; ErrMsg: string; var AProcSummCode: integer; var AProcDate: TFMDateTime; var AnAuthor: int64);
var
  frmNoteCPFields: TfrmNoteCPFields;
begin
  frmNoteCPFields := TfrmNoteCPFields.Create(Application);
  with frmNoteCPFields do
    try
      ResizeFormToFont(TForm(frmNoteCPFields));
      FCPStatusFlag := ACPStatusFlag;
      FProcSummCode := AProcSummCode;
      FProcDateTime := AProcDate;
      cboProcSummCode.SelectByIEN(AProcSummCode);
      calProcDateTime.FMDateTime := AProcDate;
      ShowModal;
      if FOKPressed then
      begin
        AnAuthor := FAuthor;
        AProcSummCode := FProcSummCode;
        AProcDate := FProcDateTime;
      end;
    finally
      Release;
    end;
end;

procedure TfrmNoteCPFields.FormCreate(Sender: TObject);
begin
  inherited;
  FOKPressed := False;
  cboAuthor.InitLongList(User.Name);
  cboAuthor.SelectByIEN(User.DUZ);
end;

procedure TfrmNoteCPFields.cmdOKClick(Sender: TObject);
var
  ErrMsg: string;
begin
  inherited;
  If not ValidateFields(ErrMsg) then
  begin
    ShowMsgOn(Length(ErrMsg) > 0, ErrMsg, TC_REQ_FIELDS);
    Exit
  end else
    begin
      FOKPressed := True;
      ModalResult := mrOK;
    end;
end;

Function TfrmNoteCPFields.ValidateFields(var ErrMsg: string): Boolean;
var
  rtnErrMsg: String;
begin
  Result := True;

  if (FCPStatusFlag = CP_INSTR_INCOMPLETE) then
    begin
      if cboProcSummCode.ItemIEN = 0 then ErrMsg := ErrMsg + TX_REQ_PROCSUMMCODE
        else FProcSummCode := cboProcSummCode.ItemIEN;
      if not calProcDateTime.IsValid then ErrMsg := ErrMsg + TX_REQ_PROCDATETIME
       else if calProcDateTime.IsValid and (calProcDateTime.FMDateTime > FMNow) then ErrMsg := ErrMsg + TX_NO_PROC_FUTURE
       else FProcDateTime := calProcDateTime.FMDateTime;
    end
  else
    begin
      FProcSummCode := cboProcSummCode.ItemIEN;
      if (calProcDateTime.FMDateTime > 0) then
        begin
          if (not calProcDateTime.IsValid) then ErrMsg := ErrMsg + TX_INVALID_PROCDATETIME
           else if calProcDateTime.IsValid and (calProcDateTime.FMDateTime > FMNow) then ErrMsg := ErrMsg + TX_NO_PROC_FUTURE
           else FProcDateTime := calProcDateTime.FMDateTime;
        end;
    end;

  if not CheckForSimilarName(cboAuthor, rtnErrMsg, sPr) then
  begin
    if Trim(rtnErrMsg) <> '' then
      ErrMsg := ErrMsg + rtnErrMsg;
  end;

  ErrMsg := Trim(ErrMsg);

  if Result then
    Result := ErrMsg = '';
end;

procedure TfrmNoteCPFields.cmdCancelClick(Sender: TObject);
var
  ErrMsg: string;
begin
  inherited;
  If not ValidateFields(ErrMsg) then
  begin
    ShowMsgOn(Length(ErrMsg) > 0, TX_REQ_CANCEL + CRLF + ErrMsg, TC_REQ_FIELDS);
    exit;
  end;
  FOKPressed := False;
  Close;
end;

procedure TfrmNoteCPFields.cboAuthorNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  setPersonList((Sender as TORComboBox), StartFrom, Direction);
end;

end.
