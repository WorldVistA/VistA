unit fOCAccept;

interface

uses
  ORExtensions,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  fAutoSz,
  StdCtrls,
  ComCtrls,
  ORFn,
  ExtCtrls,
  VA508AccessibilityManager,
  rOrders,
  fOCMonograph,
  u508Button,
  uMisc;

type
  TRetrieveOrderChecksFunction = procedure(var aReturnList: tStringList) of object;
  TRetrieveOverrideFunction = function(aReturnList: tStringList; aOverrideType: String;
    aOverrideReason: String = ''; aOverrideComment: String = ''): boolean of object;

  TfrmOCAccept = class(TfrmAutoSz)
    memChecks: ORExtensions.TRichEdit;
    pnlBottom: TPanel;
    cmdAccept: u508Button.TButton;
    cmdCancel: u508Button.TButton;
    btnDrugMono: u508Button.TButton;
    AllergyAssessmentBtn: u508Button.TButton;
    pnlOverrideReason: TPanel;
    lblOverride: TLabel;
    lblComment: TLabel;
    cbAllergyReason: TComboBox;
    cbComment: TComboBox;
    procedure btnDrugMonoClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AllergyAssessmentBtnClick(Sender: TObject);
    procedure cbAllergyReasonChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
  private
    fOnAllergyAssesment: TRetrieveOrderChecksFunction;
    fOnOverride: TRetrieveOverrideFunction;
    procedure BuildOrderChecksDisplay(OCList: TStringList);
    procedure BuildOverriderDisplay(OCList: TStringList);
    procedure SetButtonStatus;
  public
    procedure WndProc(var Msg: TMessage); override; // Used to fire URL's in TRichEdit
    property OnAllergyAssesment: TRetrieveOrderChecksFunction read fOnAllergyAssesment write fOnAllergyAssesment;
    property OnOverrideSetup: TRetrieveOverrideFunction read fOnOverride
      write fOnOverride;
  end;

  tStringListHelper = class helper for TStringList
      function FuzzyIndexOf(const S: String): Integer;
      function ContainsStringAtPiece(const S: String; const PieceNum: Integer): boolean;
    end;

  function AcceptOrderWithChecks(OCList: tStringList; aOnAllergyAssesment: TRetrieveOrderChecksFunction = nil;
    aOnOverrideSetup: TRetrieveOverrideFunction = nil): boolean;

implementation

{$R *.DFM}

uses
  RichEdit,
  ORNet,
  uCore, uConst,
  fAllgyAR,
  ShellAPI,
  System.StrUtils;

function AcceptOrderWithChecks(OCList: tStringList; aOnAllergyAssesment: TRetrieveOrderChecksFunction = nil;
  aOnOverrideSetup: TRetrieveOverrideFunction = nil): boolean;

  Function HasAssessment: Boolean;
  var
   aReturnString: String;
  begin
    Result := OCList.FuzzyIndexOf('^Patient has no allergy assessment.') <> -1;
    if not Result then
    begin
      CallVistA('ORQQAL LIST', [Patient.DFN],aReturnString);
      Result := Trim(aReturnString) = '^No Allergy Assessment';
    end;
  end;

var
  frmOCAccept: TfrmOCAccept;
  remOC: TStringList;
  mask: NativeInt; // Fixing Defect 352249
begin
  remOC := TStringList.Create;
  try
    Result := True;
    if OCList.Count > 0 then
    begin
      frmOCAccept := TfrmOCAccept.Create(Application);
      try
        ResizeFormToFont(TForm(frmOCAccept));
        frmOCAccept.memChecks.Font.Size := MainFontSize;

        frmOCAccept.AllergyAssessmentBtn.Enabled  := HasAssessment;

        // Begin URL Detection setup for TRichEdit
        mask := SendMessage(frmOCAccept.memChecks.Handle, EM_GETEVENTMASK, 0, 0);
        SendMessage(frmOCAccept.memChecks.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
        SendMessage(frmOCAccept.memChecks.Handle, EM_AUTOURLDETECT, Integer(True), 0);
        // End URL Detection setup for TRichEdit

        frmOCAccept.btnDrugMono.Enabled := false;
        if IsMonograph then
          frmOCAccept.btnDrugMono.Enabled := True;

        frmOCAccept.OnOverrideSetup := aOnOverrideSetup;
        frmOCAccept.OnAllergyAssesment := aOnAllergyAssesment;

        frmOCAccept.BuildOrderChecksDisplay(OCList);
        frmOCAccept.BuildOverriderDisplay(OCList);

        Result := frmOCAccept.ShowModal = mrYes;
      finally
        frmOCAccept.Release;
      end;
    end;
  finally
    remOC.Free;
  end;
end;

procedure TfrmOCAccept.AllergyAssessmentBtnClick(Sender: TObject);
var
  OCList: TStringList;
begin
  if EnterEditAllergy(0, True, False, nil,-1,True) then
  begin
    AllergyAssessmentBtn.Enabled := false;
    if assigned(fOnAllergyAssesment) then
    begin
      OCList := TStringList.Create;
      try
        fOnAllergyAssesment(OCList);
        if OCList.Count > 0 then
        begin
          // rebuild order checks
          BuildOrderChecksDisplay(OCList);
          //rebuild override reason
          BuildOverriderDisplay(OCList);
        end else
          memChecks.Text := 'No order checks';
      Finally
        FreeAndNil(OCList);
      end;
    end;
  end;
end;


procedure TfrmOCAccept.BuildOrderChecksDisplay(OCList: tStringList);
Var
  i, j: Integer;
  substring: String;
  remOC: tStringList;
begin
  remOC := tStringList.Create;
  try
    memChecks.Clear;
    for i := 0 to OCList.Count - 1 do
    begin
      substring := Copy(Piece(OCList[i], U, 4), 0, 2);
      if substring = '||' then
      begin
        substring := Copy(Piece(OCList[i], U, 4), 3,
          Length(Piece(OCList[i], U, 4)));
        GetXtraTxt(remOC, Piece(substring, '&', 1), Piece(substring, '&', 2));
        memChecks.Lines.Add('(' + inttostr(i + 1) + ' of ' +
          inttostr(OCList.Count) + ')  ' + Piece(substring, '&', 2));
        for j := 0 to remOC.Count - 1 do
          memChecks.Lines.Add('      ' + remOC[j]);
      end
      else
      begin
        memChecks.Lines.Add('(' + inttostr(i + 1) + ' of ' +
          inttostr(OCList.Count) + ')  ' + Piece(OCList[i], U, 4));
      end;

      memChecks.Lines.Add('');
    end;
    memChecks.SelStart := 0;
    memChecks.SelLength := 0;
  finally
    FreeAndNil(remOC);
  end;
end;

procedure TfrmOCAccept.BuildOverriderDisplay(OCList: tStringList);
var
  OverrideReturnList: TStringList;
  CanShow: boolean;
begin
  // if allergy in orders then check
  if OCList.ContainsStringAtPiece('3', 2) then
  begin
    if assigned(fOnOverride) then
    begin
      OverrideReturnList := tStringList.Create;
      try

        // are we allowed to show the override section
        CanShow := fOnOverride(OverrideReturnList, 'A');

        pnlOverrideReason.Visible := CanShow;

        if CanShow then
        begin
          cbAllergyReason.Items.Assign(OverrideReturnList);

          //do we need to show the comment section
          if OCList.ContainsStringAtPiece('1', 5) then
          begin
            // Get the possible comments
            OverrideReturnList.clear;
            fOnOverride(OverrideReturnList, 'AR');

            cbComment.Items.Assign(OverrideReturnList);
            lblComment.Visible := True;
            cbComment.Visible := True;
          end;
        end;

      finally
        FreeAndNil(OverrideReturnList);
      end;
    end;
  end else
    pnlOverrideReason.Visible := false
end;

procedure TfrmOCAccept.btnDrugMonoClick(Sender: TObject);
var
  monoList: TStringList;
begin
  inherited;
  monoList := TStringList.Create;
  try
    GetMonographList(monoList);
    ShowMonographs(monoList);
  finally
    monoList.Free;
  end;
end;

procedure TfrmOCAccept.cbAllergyReasonChange(Sender: TObject);
begin
  inherited;
  SetButtonStatus;
end;

procedure TfrmOCAccept.cmdAcceptClick(Sender: TObject);
begin
  inherited;
  if assigned(fOnOverride) and pnlOverrideReason.Visible then
    fOnOverride(nil, 'SAVE', cbAllergyReason.Text, cbComment.Text);
end;

procedure TfrmOCAccept.cmdCancelClick(Sender: TObject);
begin
  inherited;
  DeleteMonograph;
end;

procedure TfrmOCAccept.FormResize(Sender: TObject);
begin
  inherited;
  memChecks.Refresh;
end;

procedure TfrmOCAccept.FormShow(Sender: TObject);
begin
  inherited;
  SetButtonStatus;
end;

procedure TfrmOCAccept.WndProc(var Msg: TMessage);
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
                SendMessage(memChecks.Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
                sURL := memChecks.SelText;
                ShellExecute(Handle, 'open', PChar(sURL), NIL, NIL, SW_SHOWNORMAL);
              except
                ShowMessage('Error opening HyperLink');
              end;
            end;
        end;
    end;

  inherited;
end;


{ tStringListHelper }

function tStringListHelper.FuzzyIndexOf(const S: String): Integer;
var
  I: Integer;
begin
  Result := -1;

  // Loop though each item and see if it contains the given text
  for I := 0 to Count - 1 do
  begin
    if ContainsText(Strings[I], S) then
    begin
      //Return index
      Result := I;
      break;
    end;

  end;
end;

//Looks for given text at a specific piece
function tStringListHelper.ContainsStringAtPiece(const S: String; const PieceNum: Integer): Boolean;
var
  CheckString: String;
begin
  result := false;
  for CheckString in self do
  begin
    if trim(Piece(CheckString, U, PieceNum)) = Trim(S) then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TfrmOCAccept.SetButtonStatus;
begin
  cmdAccept.Enabled :=
    (not pnlOverrideReason.Visible) or
    IsValidOverrideReason(cbAllergyReason.Text);
end;

end.
