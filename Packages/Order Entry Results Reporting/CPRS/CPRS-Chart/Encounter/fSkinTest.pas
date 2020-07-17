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
    edtDtRead: TCaptionEdit;
    edtDTGiven: TCaptionEdit;
    cboSkinResults: TORComboBox;
    cboReading: TComboBox;
    procedure cboSkinResultsChange(Sender: TObject);
//    procedure EdtReadingChange(Sender: TObject);
    procedure edtDtReadChange(Sender: TObject);
    procedure edtDTGivenChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure UpDnReadingChanging(Sender: TObject;
//      var AllowChange: Boolean);
    procedure lstCaptionListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure cboReadingChange(Sender: TObject);

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

procedure TfrmSkinTests.cboReadingChange(Sender: TObject);
var
read: string;
i: integer;
begin
  inherited;
begin
  if(NotUpdating) then
  begin
    read := cboReading.Text;
    for i := 0 to lstCaptionList.Items.Count-1 do
      if(lstCaptionList.Items[i].Selected) then
        TPCESkin(lstCaptionList.Objects[i]).Reading := read;
    GridChanged;
  end;
end;
end;

procedure TfrmSkinTests.cboSkinResultsChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboSkinResults.Text <> '') then
  begin
    for i := 0 to lstCaptionList.Items.Count-1 do
      if(lstCaptionList.Items[i].Selected) then begin
        TPCESkin(lstCaptionList.Objects[i]).Results := cboSkinResults.ItemID;
        If UpperCase(cboSkinResults.Text) = 'NO TAKE' then begin
          cboReading.Visible := false;
//          EdtReading.Visible := False;
//          UpDnReading.Visible := False;
//          lblReading.Visible := False;
        end else begin
          cboReading.Visible := true;
//          EdtReading.Visible := True;
//          UpDnReading.Visible := True;
//          lblReading.Visible := True;
        end;
      end;

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
//procedure TfrmSkinTests.EdtReadingChange(Sender: TObject);
//var
//  x, i: integer;
//
//begin
//  if(NotUpdating) then
//  begin
//    x := StrToIntDef(EdtReading.Text, 0);
//    for i := 0 to lstCaptionList.Items.Count-1 do
//      if(lstCaptionList.Items[i].Selected) then
//        TPCESkin(lstCaptionList.Objects[i]).Reading := x;
//
//    GridChanged;
//  end;
//end;

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

procedure TfrmSkinTests.lstCaptionListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  inherited;
  If UpperCase(cboSkinResults.Text) = 'NO TAKE' then begin
    cboReading.Visible := false;
//   EdtReading.Visible := False;
//   UpDnReading.Visible := False;
//   lblReading.Visible := False;
  end else begin
    cboReading.Visible := true;
//   EdtReading.Visible := True;
//   UpDnReading.Visible := True;
//   lblReading.Visible := True;
  end;

end;

procedure TfrmSkinTests.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumSkinResults, NoPCEValue);
  SetPiece(x, U, pnumSkinReading, '');
//  SetPiece(x, U, pnumSkinDTRead);
//  SetPiece(x, U, pnumSkinDTGiven);
end;

procedure TfrmSkinTests.UpdateControls;
var
  ok, First: boolean;
  SameRes, SameRead, objRead: boolean;
  i,idx: integer;
  Res: string;
//  Read: integer;
  Read: string;
  Obj: TPCESkin;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount > 0);
      lblSkinResults.Enabled := ok;
      lblReading.Enabled := ok;
      cboSkinResults.Enabled := ok;
      cboReading.Enabled := ok;
//      EdtReading.Enabled := ok;
//      UpDnReading.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameRes := TRUE;
        SameRead := TRUE;
        Res := NoPCEValue;
        objRead := false;
        Read := '0';
       for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected then
          begin
            Obj := TPCESkin(lstCaptionList.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Res := Obj.Results;
              Read := Obj.Reading;
              objRead := true;
            end
            else
            begin
              if(SameRes) then
                SameRes := (Res = Obj.Results);
              if(SameRead) then
                begin
                  SameRead := (Read = Obj.Reading);
                end;
            end;
          end;
        end;
     
        if(SameRes) then
          cboSkinResults.SelectByID(Res)
        else
          cboSkinResults.Text := '';
        if(SameRead) then
        begin
          if not objRead then cboReading.ItemIndex := 0
          else
            begin
              idx := cboReading.Items.IndexOf(Read);
              cboReading.ItemIndex := idx;
            end;
//          UpDnReading.Position := Read;
//          EdtReading.Text := IntToStr(Read);
//          EdtReading.SelStart := length(EdtReading.Text);
        end
        else
        begin
          cboReading.ItemIndex := -1;
//          UpDnReading.Position := 0;
//          EdtReading.Text := '';
        end;
      end
      else
      begin
        cboSkinResults.Text := '';
//        EdtReading.Text := '';
        cboReading.ItemIndex := -1;
        cboReading.Text := '';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

//procedure TfrmSkinTests.UpDnReadingChanging(Sender: TObject;
//  var AllowChange: Boolean);
//begin
//  inherited;
//  if(UpDnReading.Position = 0) then
//    EdtReadingChange(Sender);
//end;

initialization
  SpecifyFormIsNotADialog(TfrmSkinTests);

end.
  