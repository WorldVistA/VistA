unit fWVEIEReasonsDlg;
{
  ================================================================================
  *
  *       Application:  TDrugs Patch OR*3*377 and WV*1*24
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Simple form that accepts a list of free text reasons
  *                     to enter an item in error as well as a custom reason.
  *                     List is returned as TStings via the GetReasons method.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Actions,
  Vcl.ActnList,
  fBase508Form,
  VA508AccessibilityManager;

type
  TfrmWVEIEReasonsDlg = class(TfrmBase508Form)
    btnCancel: TButton;
    btnOK: TButton;
    chkbxOther: TCheckBox;
    edtOtherReason: TEdit;
    pnlOther: TPanel;
    stxtReason: TStaticText;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkbxOtherClick(Sender: TObject);
    procedure edtOtherReasonChange(Sender: TObject);
  private
    fReasons: TStringList;

    procedure CheckUnCheckReason(Sender: TObject);
  public
    function AddReason(aReason: string): integer; overload;
    function AddReason(aReasons: array of string): integer; overload;
    function AddReason(aReasons: TStrings): integer; overload;
    function Execute: boolean;
    function GetReasons(aTStrings: TStrings): integer;
    function ValidReasons: boolean;
  end;

function NewWVEIEReasonsDlg: TfrmWVEIEReasonsDlg;

implementation

{$R *.dfm}


function NewWVEIEReasonsDlg: TfrmWVEIEReasonsDlg;
begin
  Result := TfrmWVEIEReasonsDlg.Create(Application.MainForm);
  Result.Position := poOwnerFormCenter;
end;

function TfrmWVEIEReasonsDlg.AddReason(aReason: string): integer;
begin
  fReasons.Add(aReason);
  Result := fReasons.Count;
end;

function TfrmWVEIEReasonsDlg.AddReason(aReasons: array of string): integer;
var
  i: integer;
begin
  for i := low(aReasons) to high(aReasons) do
    AddReason(aReasons[i]);
  Result := fReasons.Count;
end;

function TfrmWVEIEReasonsDlg.AddReason(aReasons: TStrings): integer;
begin
  fReasons.AddStrings(aReasons);
  Result := fReasons.Count;
end;

procedure TfrmWVEIEReasonsDlg.CheckUnCheckReason(Sender: TObject);
begin
  if Sender.ClassNameIs('TCheckBox') then
    with TCheckBox(Sender) do
      begin
        if Checked then
          fReasons.Add(Caption)
        else
          fReasons.Delete(fReasons.IndexOf(Caption));
      end;
  btnOK.Enabled := ValidReasons;
end;

procedure TfrmWVEIEReasonsDlg.chkbxOtherClick(Sender: TObject);
begin
  stxtReason.Enabled := chkbxOther.Checked;
  edtOtherReason.Enabled := chkbxOther.Checked;
  if not chkbxOther.Checked then
    edtOtherReason.Text := '';
  btnOK.Enabled := ValidReasons;
end;

procedure TfrmWVEIEReasonsDlg.edtOtherReasonChange(Sender: TObject);
begin
  btnOK.Enabled := ValidReasons;
end;

function TfrmWVEIEReasonsDlg.Execute: boolean;
var
  i: integer;
  aWidth: integer;
begin
  ClientHeight := 80 + (fReasons.Count * 25);
  aWidth := ClientWidth - 20;

  for i := 0 to fReasons.Count - 1 do
    with TCheckBox.Create(Self) do
      begin
        Parent := Self;
        name := Format('chkbx%d', [i + 1]);
        Top := (i * 25) + 10;
        Left := 10;
        Width := aWidth;
        Anchors := [akLeft, akTop, akRight];
        Caption := fReasons[i];
        OnClick := CheckUnCheckReason;
      end;
  pnlOther.Top := (fReasons.Count * 25) + 10;
  fReasons.Clear;

  Result := (ShowModal = mrOk);
end;

procedure TfrmWVEIEReasonsDlg.FormCreate(Sender: TObject);
begin
  fReasons := TStringList.Create;
end;

procedure TfrmWVEIEReasonsDlg.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fReasons);
end;

function TfrmWVEIEReasonsDlg.GetReasons(aTStrings: TStrings): integer;
begin
  aTStrings.Clear;

  // Add the predefined reasons
  aTStrings.Text := fReasons.Text;

  // Add the custom reason if it exists
  if chkbxOther.Checked and (edtOtherReason.Text <> '') then
    aTStrings.Add(edtOtherReason.Text);

  Result := aTStrings.Count;
end;

function TfrmWVEIEReasonsDlg.ValidReasons: boolean;
begin
  if chkbxOther.Checked then
    Result := (Length(edtOtherReason.Text) > 2)
  else
    Result := (fReasons.Count > 0);
end;

end.
