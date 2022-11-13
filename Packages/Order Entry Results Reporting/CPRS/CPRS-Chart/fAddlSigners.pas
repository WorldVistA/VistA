unit fAddlSigners;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ORCtrls, ORfn, ExtCtrls, FNoteProps, Dialogs, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmAddlSigners = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboSrcList: TORComboBox;
    DstList: TORListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    pnlBase: TPanel;
    btnRemoveSigners: TButton;
    lblAuthor: TOROffsetLabel;
    cboCosigner: TORComboBox;
    lblCosigner: TOROffsetLabel;
    txtAuthor: TCaptionEdit;
    pnlAdditional: TORAutoPanel;
    pnlButtons: TORAutoPanel;
    pnlTop: TORAutoPanel;
    btnAddSigners: TButton;
    btnRemoveAllSigners: TButton;
    procedure btnAddSignersClick(Sender: TObject);
    procedure NewPersonNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure btnRemoveSignersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cboCosignerChange(Sender: TObject);
    procedure cboSrcListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboCosignerNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboCosignerExit(Sender: TObject);
    procedure DstListChange(Sender: TObject);
    procedure btnRemoveAllSignersClick(Sender: TObject);
    procedure cboSrcListChange(Sender: TObject);
  private
    FSigners: TStringList ;
    FCosigner: int64;
    FExclusions: TStringList;
    FSigAction: integer;
    FChanged: Boolean;
    FNoteIEN: integer;
    FRefDate: TFMDateTime;
    FToday: string;
    FTabID: integer;
    function CosignerOK: Boolean;
    function DoSimilar: Boolean;
  end;

TSignerList = record
    Changed: Boolean;
    Signers: TStringList ;
    Cosigner: int64;
  end;

procedure SelectAdditionalSigners(FontSize, NoteIEN, SigAction: Integer; Exclusions: TStrings;
          var SignerList: TSignerList; TabID: integer; ARefDate: TFMDateTime) ;

const
  SG_ADDITIONAL = 1;
  SG_COSIGNER   = 2;
  SG_BOTH       = 3;

implementation

{$R *.DFM}

uses
  rCore, uCore, rTIU, uConst, rPCE, fDCSumm, uORLists, uSimilarNames;

const
  TX_SIGNER_CAP = 'Error adding signers';
  TX_SIGNER_TEXT = 'Select signers or press Cancel.';
  TX_BAD_SIGNER = 'Cannot select author, user, expected signer, or expected cosigner' ;
  TX_DUP_SIGNER = 'You have already selected that additional signer';
  TX_NO_COSIGNER = ' is not authorized to cosign this document.';
  TX_NO_COSIGNER_CAP = 'Invalid Cosigner';
  TX_NO_SIGNER_CAP = 'Invalid Signer';
  TX_NO_DELETE = 'A cosigner is required';
  TX_NO_DELETE_CAP = 'No cosigner selected';


procedure SelectAdditionalSigners(FontSize, NoteIEN, SigAction: Integer; Exclusions: TStrings;
          var SignerList: TSignerList; TabID: integer; ARefDate: TFMDateTime) ;
{ displays additional signer form for notes and returns a record of the selection }
var
  frmAddlSigners: TfrmAddlSigners;
  W, H, i: Integer;
begin
  frmAddlSigners := TfrmAddlSigners.Create(Application);
  try
    with frmAddlSigners do
    begin
      FTabID := TabID;
      FSigAction := SigAction;
      FNoteIEN := NoteIEN;
      FRefDate := ARefDate;
      FastAssign(Exclusions, FExclusions);
      FToday := FloatToStr(FMToday);
      if FSigAction = SG_COSIGNER then
        begin
          pnlAdditional.Visible := False;
          Height := Height - pnlAdditional.Height;
        end;
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      with FExclusions do for i := 0 to Count-1 do
        begin
          if Piece(Strings[i],U,3) = 'Author' then txtAuthor.Text := Piece(Strings[i], U, 2)
          else if Piece(Strings[i],U,3) = 'Expected Cosigner' then
            begin
              cboCosigner.Items.Add(Strings[i]);
              cboCosigner.ItemIndex := 0;
            end
          else
          begin
            DstList.Items.Add(Strings[i]);
            btnRemoveAllSigners.Enabled := DstList.Items.Count > 0;
          end;
        end;

      if (SigAction = SG_COSIGNER) or (SigAction = SG_BOTH) then
        begin
          lblCosigner.Caption := 'Expected cosigner';
          cboCosigner.Caption := 'Expected cosigner';
          cboCosigner.Color := clWindow;
          cboCosigner.Enabled := True;
          cboCosigner.InitLongList('');
        end;
      if (SigAction = SG_ADDITIONAL) or (SigAction = SG_BOTH) then
        cboSrcList.InitLongList('');
      FChanged := False;
      TSimilarNames.RegORComboBox(cboSrcList);
      TSimilarNames.RegORComboBox(cboCosigner);
      ShowModal;
      with SignerList do
        begin
          Signers := TStringList.Create;
          FastAssign(FSigners, Signers);
          Cosigner := FCosigner;
          Changed := FChanged ;
        end ;
    end; {with frmAddlSigners}
  finally
    frmAddlSigners.Release;
  end;
end;

procedure TfrmAddlSigners.NewPersonNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  Astrings: TStrings;
begin
  // SDS - See also V32 issue #126 M changes by AB - #129 is a Delphi follow-on to #126
  // SDS - We only show providers for additional signers, by request from field users
  // setProviderList(TORComboBox(Sender), StartFrom, Direction);    // SDS Aug 2017 V32 Test Issue #129
  // FH Oct 2019 - Revert Back from providerlist to personlist
  Astrings := TStringList.Create;
  try
    setSubSetOfPersons(cboSrcList, Astrings, StartFrom, Direction, True);
    cboSrcList.ForDataUse(Astrings);
  finally
    FreeAndNil(Astrings);
  end;
end;


procedure TfrmAddlSigners.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddlSigners.cmdOKClick(Sender: TObject);
var
  i: integer;
begin
  FChanged := False;
  if (FSigAction = SG_ADDITIONAL) and ((DstList.Items.Count = 0) and (FSigners.Count = 0)) then
  begin
    InfoBox(TX_SIGNER_TEXT, TX_SIGNER_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  if not CosignerOK then Exit;
  if not DoSimilar then Exit;
  FChanged := True;
  FCosigner := cboCosigner.ItemIEN;
  for i := 0 to DstList.Items.Count-1 do
    begin
      if fExclusions.IndexOf(DstList.Items[i]) < 0 then FSigners.Add(DstList.Items[i]);
    end;
  Close;
end;

procedure TfrmAddlSigners.btnRemoveAllSignersClick(Sender: TObject);
begin
  inherited;
  DstList.SelectAll;
  btnRemoveSignersClick(self);
end;

procedure TfrmAddlSigners.btnRemoveSignersClick(Sender: TObject);
var
  i,j: integer;
begin
  with DstList do
    begin
      if ItemIndex = -1 then exit ;
      for i := Items.Count-1 downto 0 do
        if Selected[i] then
          begin
            j := FExclusions.IndexOf(Items[i]);
            FSigners.Add(ORFn.Pieces(Items[i], U, 1, 2) + '^REMOVE');
            if j > -1 then FExclusions.Delete(j);
            Items.Delete(i) ;
          end;
    end;
end;

procedure TfrmAddlSigners.btnAddSignersClick(Sender: TObject);
var
  i: integer;
  aErrMsg: String;
begin
  if not CheckForSimilarName(cboSrcList, aErrMsg, sPr, DstList.Items) then
  begin
    ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, TX_NO_SIGNER_CAP);
    Exit;
  end;

  if cboSrcList.ItemIndex = -1 then
    exit;
  if UserInactive(cboSrcList.ItemID) then
    if (InfoBox(fNoteProps.TX_USER_INACTIVE, TC_INACTIVE_USER, MB_OKCANCEL)= IDCANCEL) then
      exit;

  if (DstList.SelectByID(cboSrcList.ItemID) <> -1) then
    begin
      InfoBox(TX_DUP_SIGNER, TX_SIGNER_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  for i := 0 to FExclusions.Count-1 do
    if (Piece(FExclusions.Strings[i],U,1) = cboSrcList.ItemID) then
      begin
        InfoBox(TX_BAD_SIGNER, TX_SIGNER_CAP, MB_OK or MB_ICONWARNING);
        Exit;
      end;

  DstList.Items.Add(cboSrcList.Items[cboSrcList.Itemindex]);
  btnRemoveSigners.Enabled := DstList.SelCount > 0;
  btnRemoveAllSigners.Enabled := DstList.Items.Count > 0;
end;

procedure TfrmAddlSigners.cboCosignerChange(Sender: TObject);
var
  i: integer;
begin
  with cboCosigner do
  begin
    if UserInactive(ItemID) then
      if (InfoBox(fNoteProps.TX_USER_INACTIVE, TC_INACTIVE_USER, MB_OKCANCEL)= IDCANCEL) then exit;
    if not CosignerOK then Exit;
    i := DstList.SelectByID(ItemID);
    if i > -1 then
    begin
      DstList.Items.Delete(i);
      FSigners.Add(ORFn.Pieces(Items[ItemIndex], U, 1, 2) + '^REMOVE');
    end;
    for i := 0 to FExclusions.Count - 1 do
      if (Piece(FExclusions.Strings[i],U,3) = 'Expected Cosigner') then
        FExclusions.Strings[i] := ORFn.Pieces(Items[ItemIndex], U, 1, 2) + '^Expected Cosigner';
  end;
end;

procedure TfrmAddlSigners.FormCreate(Sender: TObject);
begin
  FSigners := TStringList.Create;
  FExclusions := TStringList.Create;
end;

procedure TfrmAddlSigners.FormDestroy(Sender: TObject);
begin
  FSigners.Free;
  FExclusions.Free;
end;

procedure TfrmAddlSigners.DstListChange(Sender: TObject);
begin
  inherited;
  if DstList.SelCount = 1 then
    if Piece(DstList.Items[0], '^', 1) = '' then
    begin
      btnRemoveSigners.Enabled := false;
      btnRemoveAllSigners.Enabled := false;
      exit;
    end;
  btnRemoveSigners.Enabled := DstList.SelCount > 0;
  btnRemoveAllSigners.Enabled := DstList.Items.Count > 0;
end;

procedure TfrmAddlSigners.cboSrcListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then btnAddSignersClick(Self);
end;

function TfrmAddlSigners.CosignerOK: Boolean;
begin
  Result := False;
  if not cboCosigner.Enabled then
    begin
      Result := True;
      Exit;
    end;
  if cboCosigner.ItemIndex < 0 then
    begin
      InfoBox(TX_NO_DELETE, TX_NO_DELETE_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;


  case FTabID of
    CT_NOTES, CT_CONSULTS:
    begin
      if (not CanCosign(TitleForNote(FNoteIEN), 0, cboCosigner.ItemIEN, FRefDate)) then
        begin
          InfoBox(cboCosigner.Text + TX_NO_COSIGNER, TX_NO_COSIGNER_CAP, MB_OK or MB_ICONWARNING);
          Exit;
        end;
    end;
    CT_DCSUMM:
    begin
      if not IsUserAProvider(cboCosigner.ItemIEN, FMNow) then
        begin
          InfoBox(cboCosigner.Text + TX_NO_COSIGNER, TX_NO_COSIGNER_CAP, MB_OK or MB_ICONWARNING);
          Exit;
        end;
    end;
  end;
  Result := True;
end;

function TfrmAddlSigners.DoSimilar: Boolean;
var
  sError: String;
begin
  Result := CheckForSimilarName(cboCosigner, sError, sCo);
  if not Result then
  begin
    ShowMsgOn(Trim(sError) <> '' , sError, TX_NO_COSIGNER_CAP);
    exit;
  end;
end;

procedure TfrmAddlSigners.cboCosignerNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TStrings;
  cbo: TORComboBox;

begin
  cbo := (Sender as TORComboBox);
  sl := TStringList.Create;
  try
    case FTabID of
      CT_CONSULTS, CT_NOTES:
        setSubSetOfUsersWithClass(cbo, sl, StartFrom, Direction, FToday);
      CT_DCSUMM://CQ #17218 - Updated to properly filter co-signers - JCS
        setSubSetOfCosigners(cbo, sl, StartFrom, Direction, FMToday,
          frmDCSumm.lstSumms.ItemIEN, 0);
    end;
    cbo.ForDataUse(sl);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TfrmAddlSigners.cboCosignerExit(Sender: TObject);
begin
  with cboCosigner do if Text = '' then ItemIndex := -1;
end;

procedure TfrmAddlSigners.cboSrcListChange(Sender: TObject);
begin
  inherited;
  btnAddSigners.Enabled := CboSrcList.ItemIndex > -1;
  if (DstList.SelectByID(cboSrcList.ItemID) <> -1) then
    btnAddSigners.Enabled := false;
end;

end.
