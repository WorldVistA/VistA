unit fSkinTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ORCtrls, StdCtrls, ComCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, rCore, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmSkinTests = class(TfrmPCEBaseMain)
    lblSkinResults: TLabel;
    lblDTRead: TLabel;
    lblReading: TLabel;
    lblDTGiven: TLabel;
    UpDnReading: TUpDown;
    EdtReading: TCaptionEdit;
    edtDtRead: TCaptionEdit;
    edtDTGiven: TCaptionEdit;
    cboSkinResults: TORComboBox;
    procedure cboSkinResultsChange(Sender: TObject);
    procedure EdtReadingChange(Sender: TObject);
    procedure edtDtReadChange(Sender: TObject);
    procedure edtDTGivenChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpDnReadingChanging(Sender: TObject;
      var AllowChange: Boolean);
  private
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
  end;

var
  frmSkinTests: TfrmSkinTests;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter;

procedure TfrmSkinTests.cboSkinResultsChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboSkinResults.Text <> '') then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCESkin(lstRenameMe.Objects[i]).Results := cboSkinResults.ItemID;

    GridChanged;
  end;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name:procedure TfrmSkinTests.EdtReadingChange(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:Change the reading assigned to the skin test.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmSkinTests.EdtReadingChange(Sender: TObject);
var
  x, i: integer;

begin
  if(NotUpdating) then
  begin
    x := StrToIntDef(EdtReading.Text, 0);
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCESkin(lstRenameMe.Objects[i]).Reading := x;

    GridChanged;
  end;
end;

procedure TfrmSkinTests.edtDtReadChange(Sender: TObject);
begin
end;
(*
var
  DtRead: TFMDateTime;
  ASkinTest: TPCESkin;
begin
  inherited;
  if lstSkinSelect.ItemIndex < 0 then Exit;

  with lstSkinSelect do ASkinTest := TPCESkin(Items.Objects[ItemIndex]);
  DtRead := StrToFMDateTime(edtReading.text);
  with lstSkinSelect do if (ItemIndex > -1) then
  begin
    ASkinTest.DTRead := DTRead;
    Items[ItemIndex] := ASkinTest.ItemStr;
  end;
end;
*)

procedure TfrmSkinTests.edtDTGivenChange(Sender: TObject);
begin
end;
(*
var
  DtGiven: TFMDateTime;
  ASkinTest: TPCESkin;
begin
  inherited;
  if lstSkinSelect.ItemIndex < 0 then Exit;

  with lstSkinSelect do ASkinTest := TPCESkin(Items.Objects[ItemIndex]);
  DtGiven := StrToFMDateTime(edtDTGiven.text);
  with lstSkinSelect do if (ItemIndex > -1) then
  begin
    ASkinTest.DTGiven := DTGIven;
    Items[ItemIndex] := ASkinTest.ItemStr;
  end;
end;
*)
(*
procedure TfrmSkinTests.CheckSkinRules;
begin
  //Results must be between 0 and 40
  if StrToInt(EdtReading.Text) < 0 then EdtReading.text := '0';
  if StrToInt(EdtReading.Text) > 40 then EdtReading.text := '40';

(*  //if reading >10, result must be "positive"
  if (StrToInt(EdtReading.Text) > 9) and
    (CompareText(Piece(cboSkinResults.items[cboSkinResults.itemindex],U,1),'P') <> 0) then
    begin
      if (Piece(cboSkinResults.items[cboSkinResults.itemindex],U,1) = '@') then    // not selected
      begin
        cboSkinResults.SelectById('P');
      end
      else
      begin
        Show508Message('If the reading is over 9, the results are required to be positive.');
        cboSkinResults.SelectById('P');
       end;
    end;
end;
*)

procedure TfrmSkinTests.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_SkinNm;
  FPCEListCodesProc := ListSkinCodes;
  FPCEItemClass := TPCESkin;
  FPCECode := 'SK';
  PCELoadORCombo(cboSkinResults);
end;

procedure TfrmSkinTests.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumSkinResults, NoPCEValue);
  SetPiece(x, U, pnumSkinReading, '0');
//  SetPiece(x, U, pnumSkinDTRead);
//  SetPiece(x, U, pnumSkinDTGiven);
end;

procedure TfrmSkinTests.UpdateControls;
var
  ok, First: boolean;
  SameRes, SameRead: boolean;
  i: integer;
  Res: string;
  Read: integer;
  Obj: TPCESkin;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstRenameMe.SelCount > 0);
      lblSkinResults.Enabled := ok;
      lblReading.Enabled := ok;
      cboSkinResults.Enabled := ok;
      EdtReading.Enabled := ok;
      UpDnReading.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameRes := TRUE;
        SameRead := TRUE;
        Res := NoPCEValue;
        Read := 0;
       for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if lstRenameMe.Items[i].Selected then
          begin
            Obj := TPCESkin(lstRenameMe.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Res := Obj.Results;
              Read := Obj.Reading;
            end
            else
            begin
              if(SameRes) then
                SameRes := (Res = Obj.Results);
              if(SameRead) then
                SameRead := (Read = Obj.Reading);
            end;
          end;
        end;
     
        if(SameRes) then
          cboSkinResults.SelectByID(Res)
        else
          cboSkinResults.Text := '';
        if(SameRead) then
        begin
          UpDnReading.Position := Read;
          EdtReading.Text := IntToStr(Read);
          EdtReading.SelStart := length(EdtReading.Text);
        end
        else
        begin
          UpDnReading.Position := 0;
          EdtReading.Text := '';
        end;
      end
      else
      begin
        cboSkinResults.Text := '';
        EdtReading.Text := '';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmSkinTests.UpDnReadingChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  if(UpDnReading.Position = 0) then
    EdtReadingChange(Sender);
end;

initialization
  SpecifyFormIsNotADialog(TfrmSkinTests);

end.
  