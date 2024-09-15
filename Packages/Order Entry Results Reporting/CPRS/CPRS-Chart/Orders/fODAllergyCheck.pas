unit fODAllergyCheck;
{ ------------------------------------------------------------------------------
  Update History

  2017-02-07: NSR#20071211 (Changes to Pharmacy Allergy Package)
  ------------------------------------------------------------------------------- }
interface

uses
  ORExtensions,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ORFn, ORNet, rOrders, fODBase,
  Winapi.RichEdit, ShellAPI, Vcl.ExtCtrls, fBase508Form, VA508AccessibilityManager, Vcl.ComCtrls;

type
  TfrmAllergyCheck = class(TfrmBase508Form)
    btnContinue: TButton;
    btnCancel: TButton;
    pnlBUttons: TPanel;
    Panel1: TPanel;
    lblOverride: TLabel;
    lblComment: TLabel;
    cbAllergyReason: TComboBox;
    cbComment: TComboBox;
    reInfo: ORExtensions.TRichEdit;
    procedure cbAllergyReasonChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdjustButtonSize(pButton: TButton);
    procedure AdjustFormItemPositions;
  private
    { Private declarations }
    procedure setButtonStatus;
  public
    { Public declarations }
    MedIEN : Integer;
    parentorder : TForm;
    procedure WndProc(var Msg: TMessage); override; // Used to fire URL's in TRichEdit
    procedure setup(aMedIEN:Integer;aSL: TStringList);
//    procedure setup4TubeFeeding(msg: TStringList);
  end;

function MedFieldsNeeded(aMedIEN:Integer; var aReason:String; var aComment:String; var aFillerID:String):Boolean;
function IsAllergyCheckOK(aDlgID, anItemID:Integer): Boolean;

implementation

{$R *.dfm}

uses rODDiet;

function IsAllergyCheckOK(aDlgID, anItemID:Integer): Boolean;
var
  sReason,sComment,sFillerID:String;
begin
//  Result := False;
  sFillerID := FillerIDForDialog(aDlgID);
  Result := MedFieldsNeeded(anItemID,sReason,sComment,sFillerID);
end;

function MedFieldsNeeded(aMedIEN:Integer; var aReason:String; var aComment:String; var aFillerID:String):Boolean;
var
  AllergyCheck: TfrmAllergyCheck;
  SL: TSTringList;
begin
  Result := True;
  SL := TStringList.Create;
  aReason := '';
  aCOmment := '';
  try
    OrderChecksOnMedicationSelect(SL, aFillerID, aMedIEN);
    if SL.Count > 0 then
      begin
        AllergyCheck := TfrmAllergyCheck.Create(nil);
        try
          AllergyCheck.setup(aMedIEN,SL);
          Result := AllergyCheck.ShowModal = mrOk;
          if Result then
          begin
            aReason := AllergyCheck.cbAllergyReason.Text;
            aComment := AllergyCheck.cbComment.Text;
          end;
        finally
          FreeAndNil(AllergyCheck);
        end;
      end;
  finally
    SL.Free;
  end;
end;

procedure TfrmAllergyCheck.cbAllergyReasonChange(Sender: TObject);
begin
  setButtonStatus;
end;

procedure TfrmAllergyCheck.setButtonStatus;
begin
  btnContinue.Enabled :=
    (not cbAllergyReason.Visible) or
    IsValidOverrideReason(cbAllergyReason.Text);
end;

procedure TfrmAllergyCheck.FormShow(Sender: TObject);
var
 item: TVA508AccessibilityItem;
begin
  inherited;
  Font.Size := mainFontSize + 1;
  AdjustFormItemPositions;

  item := amgrMain.AccessData.FindItem(cbComment);
  amgrMain.AccessData[item.INDEX].AccessText := Trim(cbComment.Text);

  setButtonStatus;
end;

procedure TfrmAllergyCheck.setup(aMedIEN: Integer; aSL: TStringList);
var
  OCList: TStringList;
  gridText, substr, s, commentstr: string;
  i, j: Integer;
  remOC: TStringList;
  mask: NativeInt; // Fixing Defect 352249
  enablecomment: Boolean;
begin
  enablecomment := False;
  commentstr := '';
  mask := SendMessage(reInfo.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(reInfo.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(reInfo.Handle, EM_AUTOURLDETECT, Integer(True), 0);

  GetAllergyReasonList(cbAllergyReason.Items, MedIEN, 'A');
  GetAllergyReasonList(cbComment.Items, MedIEN, 'AR');

  remOC := TStringList.Create;
  try
    OCList := aSL;
    for i := 0 to OCList.Count - 1 do
    begin
      s := Piece(OCList[i], U, 4);
      if not enablecomment then
      begin
        enablecomment := StrToBool(Piece(OCList[i], U, 5));
        if enablecomment then
          commentstr := Piece(OCList[i], U, 7);
      end;

      gridText := s;
      substr := Copy(s, 0, 2);
      if substr = '||' then
      begin
        gridText := '';
        substr := Copy(s, 3, Length(s));
        GetXtraTxt(remOC, Piece(substr, '&', 1), Piece(substr, '&', 2));
        reInfo.Lines.Add('(' + inttostr(i + 1) + ' of ' +
          inttostr(OCList.Count) + ')  ');
        for j := 0 to remOC.Count - 1 do
          reInfo.Lines.Add('      ' + remOC[j]);
      end
      else
        reInfo.Lines.Add(gridText + CRLF);
    end;
  finally
    remOC.Free;
  end;

  if enablecomment then
  begin
    lblComment.Visible := True;
    cbComment.Visible := True;
    cbComment.Text := commentstr;
  end;
end;

(*
procedure TfrmAllergyCheck.setup4TubeFeeding(msg: TStringList);
var
  i: integer;
  enablecomment, enableReason: Boolean;
  s, commentstr: string;

begin
  enablecomment := false;
  enableReason := TRUE;

  cbAllergyReason.Visible := enableReason;
  lblOverride.Visible := enableReason;
  if enablereason then
    GetAllergyReasonList(cbAllergyReason.Items, 0, 'A');

  for i := 0 to msg.Count - 1 do
  begin
    s := Piece(msg[i], U, 4);
    if not enablecomment then
    begin
      enablecomment := StrToBool(Piece(msg[i], U, 5));
      if enablecomment then
      begin
        commentstr := Piece(msg[i], U, 7);
        GetAllergyReasonList(cbComment.Items, 0, 'AR');
      end;
    end;
    if reinfo.Lines.Count > 0 then
      reinfo.Lines.Add('');
    reinfo.Lines.Add(s);
  end;

  if enablecomment then
  begin
    lblComment.Visible := True;
    cbComment.Visible := True;
    cbComment.Text := commentstr;
  end;
end;
*)

procedure TfrmAllergyCheck.WndProc(var Msg: TMessage);
var
  p: TENLink;
  sURL: string;
begin
  if (Msg.Msg = WM_NOTIFY) then
    begin
      if (PNMHDR(Msg.lParam).code = EN_LINK) then
        begin
          p := TENLink(Pointer(TWMNotify(Msg).NMHdr)^);
          if (p.Msg = WM_LBUTTONDOWN) then
            begin
              try
                SendMessage(reInfo.Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
                sURL := reInfo.SelText;
                ShellExecute(Handle, 'open', PChar(sURL), NIL, NIL, SW_SHOWNORMAL);
              except
                ShowMessage('Error opening HyperLink');
              end;
            end;
        end;
    end;
  inherited;
end;

procedure TfrmAllergyCheck.AdjustButtonSize(pButton: TButton);
const
  Gap = 5;
begin
  if pButton.Width < Canvas.TextWidth(pButton.Caption) then // CQ2737  GE
      pButton.Width := (Canvas.TextWidth(pButton.Caption) + Gap + Gap); // CQ2737  GE
  if pButton.Height < Canvas.TextHeight(pButton.Caption) then // CQ2737  GE
    pButton.Height := Canvas.TextHeight(pButton.Caption) + Gap; // CQ2737  GE
end;

procedure TfrmAllergyCheck.AdjustFormItemPositions;
begin
  reInfo.Font.Size := mainFontSize;
  case mainFontSize of
    18: begin
          Height := 520;
          Width := 780;
        end;
    14: begin
          Height := 510;
          Width := 770;
        end;
    12: begin
          Height := 470;
          Width := 760;
        end;
    10: begin
          Height := 430;
          Width := 750;
        end;
    8: begin
         Height := 410;
         Width := 710;
       end;
  end;

//  lblOverride.Top := reInfo.Top + reInfo.Height + 10;
//  cbAllergyReason.Top := lblOverride.Top - 5;
//  cbAllergyReason.Left := lblOverride.Left + lblOverride.Width + 5;
//  cbAllergyReason.Width := Width-cbAllergyReason.Left - 12;

//  lblComment.Top := cbComment.Top + 2;
//  cbComment.Left := lblComment.Left + lblComment.Width + 5;
//  cbComment.Width := Width - cbComment.Left - 12;

//  AdjustButtonSize(btnContinue);
//  AdjustButtonSize(btnCancel);
//  btnContinue.Left := ClientWidth - (btnContinue.Width+btnCancel.Width+20);
//  btnCancel.Left := ClientWidth - (btnCancel.Width+10);
end;

end.
