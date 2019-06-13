{
  Most of Code is Public Domain.
  Number Formats modified by OSEHRA/Sam Habiel (OSE/SMH) for Plan VI (c) Sam Habiel 2019
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit fODText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ORCtrls, ComCtrls, ExtCtrls, ORFn, uConst, ORDtTm,
  VA508AccessibilityManager;

type
  TfrmODText = class(TfrmODBase)
    memText: TMemo;
    lblText: TLabel;
    txtStart: TORDateBox;
    txtStop: TORDateBox;
    lblStart: TLabel;
    lblStop: TLabel;
    VA508CompMemOrder: TVA508ComponentAccessibility;
    lblOrderSig: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure VA508CompMemOrderStateQuery(Sender: TObject; var Text: string);
  public
    procedure InitDialog; override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure Validate(var AnErrMsg: string); override;
  end;

var
  frmODText: TfrmODText;

implementation

{$R *.DFM}

uses rCore;

const
  TX_NO_TEXT = 'Some text must be entered.';
  TX_STARTDT = 'Unable to interpret start date.';
  TX_STOPDT  = 'Unable to interpret stop date.';
  TX_GREATER = 'Stop date must be greater than start date.';

{ TfrmODBase common methods }

procedure TfrmODText.FormCreate(Sender: TObject);
begin
  inherited;
  FillerID := 'OR';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'OR GXTEXT WORD PROCESSING ORDER';  // loads formatting info
  //StatusText('Loading Default Values');                // there are no defaults for text only
  //CtrlInits.LoadDefaults(ODForText);
  InitDialog;
  StatusText('');
end;

procedure TfrmODText.InitDialog;
begin
  inherited;                             // inherited clears dialog controls and responses
  ActiveControl := memText;  //SetFocusedControl(memText);
end;

procedure TfrmODText.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    SetControl(memText,  'COMMENT', 1);
    SetControl(txtStart, 'START',   1);
    SetControl(txtStop,  'STOP',    1);
  end
  else txtStart.Text := 'NOW';
end;

procedure TfrmODText.VA508CompMemOrderStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memOrder.Text;
end;

procedure TfrmODText.Validate(var AnErrMsg: string);
const
  SPACE_CHAR = 32;
var
  ContainsPrintable: Boolean;
  i: Integer;
  StartTime, StopTime: TFMDateTime;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  ContainsPrintable := False;
  for i := 1 to Length(memText.Text) do if Ord(memText.Text[i]) > SPACE_CHAR then
  begin
    ContainsPrintable := True;
    break;
  end;
  if not ContainsPrintable then SetError(TX_NO_TEXT);
  with txtStart do if Length(Text) > 0
    then StartTime := StrToFMDateTime(Text)
    else StartTime := 0;
  with txtStop do if Length(Text) > 0
    then StopTime := StrToFMDateTime(Text)
    else StopTime := 0;
  if StartTime = -1 then SetError(TX_STARTDT);
  if StopTime  = -1 then SetError(TX_STARTDT);
  if (StopTime > 0) and (StopTime < StartTime) then SetError(TX_GREATER);
  //the following is commented out because should be using relative times
  //if AnErrMsg = '' then
  //begin
  //  Responses.Update('START', 1, FloatToStr(StartTime, TFormatSettings.Create('en-US')), txtStart.Text);
  //  Responses.Update('STOP', 1, FloatToStr(StopTime, TFormatSettings.Create('en-US')), txtStop.Text);
  //end;
end;

procedure TfrmODText.cmdAcceptClick(Sender: TObject);
begin
  inherited;
  Application.ProcessMessages; //CQ 14670
  memText.Lines.Text := Trim(memText.Lines.Text); //CQ 14670
end;

procedure TfrmODText.ControlChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  with memText  do if GetTextLen > 0   then Responses.Update('COMMENT', 1, TX_WPTYPE, Text);
  with txtStart do if Length(Text) > 0 then Responses.Update('START', 1, Text, Text);
  with txtStop  do if Length(Text) > 0 then Responses.Update('STOP', 1, Text, Text);
  memOrder.Text := Responses.OrderText;
end;

end.


