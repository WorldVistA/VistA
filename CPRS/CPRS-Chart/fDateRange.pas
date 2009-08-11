unit fDateRange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORCtrls, StdCtrls, ORFn, ORDtTm, VA508AccessibilityManager;

type
  TfrmDateRange = class(TfrmAutoSz)
    txtStart: TORDateBox;
    txtStop: TORDateBox;
    lblStart: TLabel;
    lblStop: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblInstruct: TOROffsetLabel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    OKPressed: Boolean;
    Flags: string;
  end;

function ExecuteDateRange(var Start, Stop: string; const AFlag, ATitle, Instruct,
  StartLabel, StopLabel: string): Boolean;

implementation

{$R *.DFM}

uses rCore;

const
  TX_INVALID_DATE = 'The date/time entered could not be validated.';
  TC_INVALID_DATE = 'Unable to interpret date/time entry.';

function ExecuteDateRange(var Start, Stop: string; const AFlag, ATitle, Instruct,
  StartLabel, StopLabel: string): Boolean;
var
  frmDateRange: TfrmDateRange;
begin
  Result := False;
  frmDateRange := TfrmDateRange.Create(Application);
  try
    ResizeFormToFont(TForm(frmDateRange));
    with frmDateRange do
    begin
      if Flags      <> '' then Flags := AFlag;
      if ATitle     <> '' then Caption := ATitle;
      if Instruct   <> '' then lblInstruct.Caption := Instruct;
      if StartLabel <> '' then lblStart.Caption := StartLabel;
      if StopLabel  <> '' then lblStop.Caption := StopLabel;
      txtStart.Text := Start;
      txtStop.Text  := Stop;
      ShowModal;
      if OKPressed then
      begin
        Start := txtStart.Text;
        Stop  := txtStop.Text;
        Result := True;
      end;
    end;
  finally
    frmDateRange.Release;
  end;
end;

procedure TfrmDateRange.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmDateRange.cmdOKClick(Sender: TObject);
const
  TX_BAD_START   = 'The start date is not valid.';
  TX_BAD_STOP    = 'The stop date is not valid.';
  TX_STOPSTART   = 'The stop date must be after the start date.';
var
  x, ErrMsg: string;
begin
  inherited;
  ErrMsg := '';
  txtStart.Validate(x);
  if Length(x) > 0   then ErrMsg := ErrMsg + TX_BAD_START + CRLF;
  with txtStop do
  begin
    Validate(x);
    if Length(x) > 0 then ErrMsg := ErrMsg + TX_BAD_STOP + CRLF;
    if (Length(Text) > 0) and (FMDateTime <= txtStart.FMDateTime)
                     then ErrMsg := ErrMsg + TX_STOPSTART;
  end;
  if Length(ErrMsg) > 0 then
  begin
    InfoBox(ErrMsg, TC_INVALID_DATE, MB_OK);
    Exit;
  end;

//  if ((Length(txtStart.Text) > 0) and (ValidDateTimeStr(txtStart.Text, Flags) < 0))
//  or ((Length(txtStop.Text)  > 0) and (ValidDateTimeStr(txtStop.Text, Flags)  < 0)) then
//  begin
//    InfoBox(TX_INVALID_DATE, TC_INVALID_DATE, MB_OK);
//    Exit;
//  end;

  OKPressed := True;
  Close;
end;

procedure TfrmDateRange.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
