unit fOptionsNotes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsNotes = class(TfrmBase508Form)
    lblAutoSave1: TLabel;
    lblCosigner: TLabel;
    txtAutoSave: TCaptionEdit;
    spnAutoSave: TUpDown;
    chkVerifyNote: TCheckBox;
    chkAskSubject: TCheckBox;
    cboCosigner: TORComboBox;
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure txtAutoSaveChange(Sender: TObject);
    procedure txtAutoSaveKeyPress(Sender: TObject; var Key: Char);
    procedure txtAutoSaveExit(Sender: TObject);
    procedure spnAutoSaveClick(Sender: TObject; Button: TUDBtnType);
    procedure cboCosignerNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboCosignerExit(Sender: TObject);
  private
    FStartingCosigner: Int64;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptionsNotes: TfrmOptionsNotes;

procedure DialogOptionsNotes(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

{$R *.DFM}

uses
  rOptions, uOptions, rCore, rTIU, rDCSumm, VAUtils, uSimilarNames;

procedure DialogOptionsNotes(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsNotes: TfrmOptionsNotes;
begin
  frmOptionsNotes := TfrmOptionsNotes.Create(Application);
  actiontype := 0;
  try
    with frmOptionsNotes do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsNotes);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsNotes.Release;
  end;
end;

procedure TfrmOptionsNotes.FormShow(Sender: TObject);
// displays defaults
// opening tab^use last tab^autosave seconds^verify note title
var
  autosave, verify: integer;
  cosigner: Int64;
  values, cosignername: string;
begin
  values := rpcGetOther;
  autosave := strtointdef(Piece(values, '^', 3), -1);
  verify := strtointdef(Piece(values, '^', 4), 0);
  chkVerifyNote.Checked := verify = 1;
  chkVerifyNote.Tag := verify;
  spnAutoSave.Position := autosave;
  spnAutoSave.Tag := autosave;

  values := rpcGetDefaultCosigner;
  cosigner := strtoint64def(Piece(values, '^', 1), 0);
  cosignername := Piece(values, '^', 2);
  cboCosigner.Items.Add('0^<none>');
  cboCosigner.InitLongList(cosignername);
  cboCosigner.SelectByIEN(cosigner);
  TSimilarNames.RegORComboBox(cboCosigner);
  FStartingCosigner := cosigner;
  chkAskSubject.Checked := rpcGetSubject;
  if chkAskSubject.Checked then chkAskSubject.Tag := 1;
end;

procedure TfrmOptionsNotes.btnOKClick(Sender: TObject);
// only saves values if they have been changed
// opening tab^use last tab^autosave seconds^verify note title
var
  aErrMsg, values: string;

begin
  aErrMsg := '';
  if not CheckForSimilarName(cboCosigner, aErrMsg, sCo) then
  begin
    ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection');
    ModalResult := mrNone;
    exit;
  end;
  values := '';
  values := values + '^';
  values := values + '^';
  if spnAutoSave.Position <> spnAutoSave.Tag then
    values := values + inttostr(spnAutoSave.Position);
  values := values + '^';
  if chkVerifyNote.Checked then
    if chkVerifyNote.Tag <> 1 then
      values := values + '1';
  if not chkVerifyNote.Checked then
    if chkVerifyNote.Tag <> 0 then
      values := values + '0';
  rpcSetOther(values);
  with chkAskSubject do
  if (Checked and (Tag = 0)) or (not Checked and (Tag = 1)) then
    rpcSetSubject(Checked);
  with cboCosigner do
    if FStartingCosigner <> ItemIEN then
      rpcSetDefaultCosigner(ItemIEN);
  ResetTIUPreferences;
  ResetDCSummPreferences;
end;

procedure TfrmOptionsNotes.txtAutoSaveChange(Sender: TObject);
var
  maxvalue: integer;
begin
  maxvalue := spnAutoSave.Max;
  with txtAutoSave do
  begin
    if strtointdef(Text, maxvalue) > maxvalue then
    begin
      beep;
      InfoBox('Number must be < ' + inttostr(maxvalue), 'Warning', MB_OK or MB_ICONWARNING);
      if strtointdef(Text, 0) > maxvalue then
        Text := inttostr(maxvalue);
    end;
  end;
  spnAutoSaveClick(self, btNext);
end;

procedure TfrmOptionsNotes.txtAutoSaveKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
  if not CharInSet(Key, ['0'..'9', #8]) then
  begin
    Key := #0;
    beep;
  end;  
end;

procedure TfrmOptionsNotes.txtAutoSaveExit(Sender: TObject);
begin
  with txtAutoSave do
  begin
    if Text = '' then
    begin
      Text := '0';
      spnAutoSaveClick(self, btNext);
    end
    else if (Copy(Text, 1, 1) = '0') and (length(Text) > 1) then
    begin
      Text := inttostr(strtointdef(Text, 0));
      spnAutoSaveClick(self, btNext);
    end;
  end;
end;

procedure TfrmOptionsNotes.spnAutoSaveClick(Sender: TObject;
  Button: TUDBtnType);
begin
  txtAutoSave.SetFocus;
  txtAutoSave.Tag := strtointdef(txtAutoSave.Text, 0);
end;

procedure TfrmOptionsNotes.cboCosignerNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  aResults: TStringList;
begin
  aResults := TStringList.Create;
  try
    rpcGetCosigners(cboCosigner, StartFrom, Direction, aResults);
    cboCosigner.ForDataUse(aResults);
  finally
    FreeAndNil(aResults);
  end;
end;

procedure TfrmOptionsNotes.cboCosignerExit(Sender: TObject);
begin
  with cboCosigner do
  if (Text = '') or (ItemIndex = -1) then
  begin
    ItemIndex := 0;
    Text := DisplayText[0];
  end;
end;

end.
