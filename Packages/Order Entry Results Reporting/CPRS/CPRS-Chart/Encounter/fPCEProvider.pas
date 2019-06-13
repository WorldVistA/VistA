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

unit fPCEProvider;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, uPCE, ORFn, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmPCEProvider = class(TfrmBase508Form)
    cboPrimary: TORComboBox;
    lblMsg: TMemo;
    btnYes: TButton;
    btnNo: TButton;
    btnSelect: TButton;
    Spacer1: TLabel;
    procedure cboPrimaryNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboPrimaryChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    FPCEData: TPCEData;
    FUseDefault: boolean;
    FIEN: array[boolean] of Int64;
    FName: array[boolean] of string;
  public
    procedure AskUser(ForceSelect: boolean);
  end;

function NoPrimaryPCEProvider(AProviders: TPCEProviderList; PCEData: TPCEData): boolean;

implementation

uses rCore, uCore, rTIU, rPCE;

{$R *.DFM}

const
  AreYouStr = 'Are You, ';
  PEPStr2 = ' the Primary Provider for this Encounter';
  PEPStr = PEPStr2 + '?';
  IsStr = 'Is ';
  SelectStr = 'Please Select' + PEPStr2 + '.';

function NoPrimaryPCEProvider(AProviders: TPCEProviderList; PCEData: TPCEData): boolean;
var
  frmPCEProvider: TfrmPCEProvider;
  idx: integer;
  b: boolean;
  X: string;
  mr: TModalResult;

begin
  if(AProviders.PrimaryIdx < 0) then
    SetDefaultProvider(AProviders, PCEData);
  if(AProviders.PrimaryIdx < 0) then
  begin
    frmPCEProvider := TfrmPCEProvider.Create(Application);
    try
      with frmPCEProvider do
      begin
        FPCEData := PCEData;
        for b := FALSE to TRUE do
        begin
          FIEN[b] := AProviders.PendingIEN(b);
          FName[b] := AProviders.PendingNAME(b);
        end;
        if(FIEN[TRUE] = 0) and (FIEN[FALSE] = 0) then
        begin
          AskUser(TRUE);
          mr := ModalResult;
        end
        else
        begin
          FUseDefault := TRUE;
          AskUser(FALSE);
          mr := ModalResult;
          if((mr in [mrAbort, mrNo]) and (FIEN[TRUE] <> FIEN[FALSE])) then
          begin
            FUseDefault := FALSE;
            AskUser(FALSE);
            mr := ModalResult;
          end;
        end;
        if (mr = mrYes) then
        begin
          AProviders.AddProvider(IntToStr(FIEN[FUseDefault]), FName[FUseDefault], TRUE);
        end
        else
        if (mr = mrOK) then
        begin
          idx := cboPrimary.ItemIndex;
          if(idx >= 0) then
          begin
            X := frmPCEProvider.cboPrimary.Items[idx];
            AProviders.AddProvider(Piece(X, U, 1), Piece(X, U, 2), TRUE);
          end;
        end;
      end;
    finally
      frmPCEProvider.Free;
    end;
    Result := (AProviders.PrimaryIdx < 0);
  end
  else
    Result := FALSE;
end;

{ TfrmPCEProvider }

procedure TfrmPCEProvider.cboPrimaryNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  if(FPCEData.VisitCategory = 'E') then
    cboPrimary.ForDataUse(SubSetOfPersons(StartFrom, Direction))
  else
    cboPrimary.ForDataUse(SubSetOfUsersWithClass(StartFrom, Direction,
                                                 FloatToStr(FPCEData.PersonClassDate, TFormatSettings.Create('en-US'))));
end;

procedure TfrmPCEProvider.cboPrimaryChange(Sender: TObject);
var
  txt: string;

begin
  if(cboPrimary.ItemIEN <> 0) and (FPCEData.VisitCategory <> 'E') then
  begin
    txt := InvalidPCEProviderTxt(cboPrimary.ItemIEN, FPCEData.PersonClassDate);
    if(txt <> '') then
    begin
      InfoBox(cboPrimary.DisplayText[cboPrimary.ItemIndex] + txt, TX_BAD_PROV, MB_OK);
      cboPrimary.ItemIndex := -1;
    end;
  end;
end;

procedure TfrmPCEProvider.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  ClientHeight := cboPrimary.Top;
end;

procedure TfrmPCEProvider.btnSelectClick(Sender: TObject);
begin
  ClientHeight := cboPrimary.Top + cboPrimary.Height + 5;
  cboPrimary.Visible := TRUE;
  btnSelect.Visible := FALSE;
  btnYes.Caption := '&OK';
  btnYes.ModalResult := mrOK;
  btnNo.Caption := '&Cancel';
  btnNo.ModalResult := mrCancel;
  lblMsg.Text := SelectStr;
  cboPrimary.Caption := lblMsg.Text;
  cboPrimary.InitLongList(User.Name);
end;

procedure TfrmPCEProvider.AskUser(ForceSelect: boolean);
var
  msg: string;

begin
  if(ForceSelect) then
  begin
    btnSelectClick(Self);
  end
  else
  begin
    if(FIEN[FUseDefault] = 0) then
    begin
      ModalResult := mrAbort;
      exit;
    end
    else
    begin
      if(FIEN[FUseDefault] = User.DUZ) then
        msg := AreYouStr + FName[FUseDefault] + ',' + PEPStr
      else
        msg := IsStr + FName[FUseDefault] + PEPStr;
    end;
    lblMsg.text := msg;
    cboPrimary.Caption := lblMsg.text;
  end;
  ShowModal;
end;

end.
