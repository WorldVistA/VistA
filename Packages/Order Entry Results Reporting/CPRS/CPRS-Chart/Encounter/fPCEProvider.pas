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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

uses rCore, uCore, rTIU, rPCE, uORLists, uSimilarNames;

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
var
  sl: TStrings;
begin
  if (FPCEData.VisitCategory = 'E') then
    setPersonList(cboPrimary, StartFrom, Direction)
  else
  begin
    sl := TStringList.Create;
    try
      setSubSetOfUsersWithClass(cboPrimary, sl, StartFrom, Direction,
        FloatToStr(FPCEData.PersonClassDate));
      cboPrimary.ForDataUse(sl);
    finally
      sl.Free;
    end;
  end;
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

procedure TfrmPCEProvider.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  ErrMsg: string;
begin
  inherited;
  CanClose := (not (ModalResult in [mrOK, mrYes, mrYesToAll]));
  if not CanClose then
  begin
    CanClose := CheckForSimilarName(cboPrimary, ErrMsg, sPr);
  end;
  if not CanClose then
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'Provider Selection');
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
