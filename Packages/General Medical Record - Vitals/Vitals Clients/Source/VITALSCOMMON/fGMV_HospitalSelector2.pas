unit fGMV_HospitalSelector2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls
  , StdCtrls, ComCtrls;

type
  TfrmGMV_HospitalSelector2 = class(TForm)
    Panel1: TPanel;
    tmSearch: TTimer;
    lblLeft: TLabel;
    btnOK: TButton;
    Button2: TButton;
    pcMain: TPageControl;
    tsByApointment: TTabSheet;
    lvAppt: TListView;
    tsAdmissions: TTabSheet;
    pnlApptTest: TPanel;
    sbFindAppt: TSpeedButton;
    pnlAdmitTest: TPanel;
    sbFindAdmit: TSpeedButton;
    edDFN: TEdit;
    edFrom: TEdit;
    edTo: TEdit;
    edFlag: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edAdmitDFN: TEdit;
    lvAdmit: TListView;
    Panel3: TPanel;
    Label7: TLabel;
    edSelected: TEdit;
    tsByName: TTabSheet;
    Panel2: TPanel;
    lvH: TListView;
    Panel4: TPanel;
    Label1: TLabel;
    cmbTarget: TComboBox;
    procedure tmSearchTimer(Sender: TObject);
    procedure lvHChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cmbTargetChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure cmbTargetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbTargetEnter(Sender: TObject);
    procedure cmbTargetExit(Sender: TObject);
    procedure lvHExit(Sender: TObject);
    procedure lvHEnter(Sender: TObject);
    procedure lvHKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvHDblClick(Sender: TObject);
    procedure sbFindApptClick(Sender: TObject);
    procedure sbFindAdmitClick(Sender: TObject);
    procedure sbFindNameClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure edTargetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    iCycle:Integer;
    fDFN:String;
    fID,
    fName: String;
//    procedure Search;
    function ReadyToSelect:Boolean;
  public
    { Public declarations }
    property HospitalID:String read fID;
    property HospitalName:String read fName;
  end;

var
  frmGMV_HospitalSelector2: TfrmGMV_HospitalSelector2;

function SelectLocation2(aDFN:String;var anID:String;var aName:String):Boolean;

implementation

uses uGMV_Engine, uGMV_Common, uGMV_GlobalVars
// zzzzzzandria 2007-10-04
// uncomment the next line to correlate search delay with user preference value
//  , uGMV_User
  ;

{$R *.DFM}

function SelectLocation2(aDFN:String;var anID:String;var aName:String):Boolean;
begin
  Result := False;
  if not Assigned(frmGMV_HospitalSelector2) then
    begin
      Application.CreateForm(TfrmGMV_HospitalSelector2, frmGMV_HospitalSelector2);
{$IFDEF AANTEST}
      frmGMV_HospitalSelector2.lblLeft.Visible := True;
      frmGMV_HospitalSelector2.pnlAdmitTest.Visible := True;
      frmGMV_HospitalSelector2.pnlApptTest.Visible := True;
{$ELSE}
      frmGMV_HospitalSelector2.lblLeft.Visible := False;
      frmGMV_HospitalSelector2.pnlAdmitTest.Visible := False;
      frmGMV_HospitalSelector2.pnlApptTest.Visible := False;
{$ENDIF}
    end;
  if  frmGMV_HospitalSelector2 = nil then exit;

  frmGMV_HospitalSelector2.edDFN.Text := aDFN;
  frmGMV_HospitalSelector2.edAdmitDFN.Text := aDFN;

  frmGMV_HospitalSelector2.sbFindAdmitClick(nil);
  frmGMV_HospitalSelector2.sbFindApptClick(nil);

  frmGMV_HospitalSelector2.fDFN := aDFN;
  try
    frmGMV_HospitalSelector2.pcMain.ActivePageIndex := 0;
    frmGMV_HospitalSelector2.pcMainChange(nil);
    frmGMV_HospitalSelector2.ActiveControl := frmGMV_HospitalSelector2.lvAppt;
  except
  end;

  if frmGMV_HospitalSelector2.ShowModal = mrOK then
    begin
      frmGMV_HospitalSelector2.tmSearch.Enabled := False;
      aName := frmGMV_HospitalSelector2.HospitalName;
      anID := frmGMV_HospitalSelector2.HospitalID;
      Result := True;
    end;
{
  try
    FreeAndNil(frmGMV_HospitalSelector2);
  except
  end;
}
end;

procedure TfrmGMV_HospitalSelector2.tmSearchTimer(Sender: TObject);
begin
  if iCycle > 1 then
    begin
      iCycle := iCycle - 1;
      lblLeft.Caption := IntToStr(iCycle);
    end
  else
    begin
      tmSearch.Enabled := False;
      sbFindNameClick(nil);
    end;
//    Search;
end;
(*
procedure TfrmGMV_HospitalSelector2.Search;
var
  tmpList: TStringList;
  i: integer;
  LI: TlistItem;

    function WardClinicFilter(aValue:String): Boolean;
      begin
        Result := True;
      end;

begin
  if (cmbTarget.Text='') then Exit;
  
  tmSearch.Enabled := False;
  lblLeft.Caption := '';
  btnOK.Enabled := False;

  // CHECK IF THE LISTS ARE READY....

    try
      tmpList := getLookupEntries('44',cmbTarget.Text);
      if tmpList.Count < 1 then
        begin
          MessageDlg('No entries found matching ''' + cmbTarget.Text + '''.', mtInformation, [mbok], 0);
          cmbTarget.SetFocus;
          cmbTarget.SelectAll;

          FreeAndNil(tmpList);
          Exit;
        end;

      if Piece(tmpList[0], '^', 1) = '-1' then
        begin
          MessageDlg(Piece(tmpList[0], '^', 2), mtError, [mbok], 0);
          cmbTarget.SelectAll;
          cmbTarget.SetFocus;
        end
      else if Piece(tmpList[0], '^', 1) = '0' then
        begin
          MessageDlg('No entries found matching ''' + cmbTarget.Text + '''.', mtInformation, [mbok], 0);
          cmbTarget.SetFocus;
          cmbTarget.SelectAll;
        end
      else
        begin
          tmpList.Delete(0); {Contains the header count record}
          lvH.Items.Clear;
          for i := 0 to tmpList.Count - 1 do
            begin
              /// SCREEN FOR wARDS AND CLINICS ONLY
              IF WardClinicFilter(tmpList[i]) THEN
                BEGIN
              li := lvH.Items.Add;
              li.Caption := Piece(tmpList[i], '^', 2);
              li.SubItems.Add(Piece(Piece(tmpList[i], '^', 1),';',2));
                END;
            end;
          lvH.SetFocus;
          lvH.ItemFocused := lvH.Items[0];
          lvH.ItemIndex := 0;
        end;
    finally
      FreeAndNil(tmpList);
    end;
  if (cmbTarget.Text<>'') and (cmbTarget.Items.IndexOf(cmbTarget.Text) = -1) then
   cmbTarget.Items.Add(cmbTarget.Text);

end;
*)
procedure TfrmGMV_HospitalSelector2.lvHChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  lv: TListView;
begin
  lv := TListView(Sender);
  try
    fID := lv.Selected.SubItems[0];
    fName := lv.Selected.Caption;
    btnOK.Enabled := ReadyToSelect;
    lblLeft.Caption := fName + '('+fID+')';
    edSelected.Text := fName;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.cmbTargetChange(Sender: TObject);
begin
  if cmbTarget.Text = '' then Exit;
  tmSearch.Enabled := True;
// zzzzzzandria 2007-10-04
// uncomment the next line to correlate search delay with user preference value
//  GMVSearchDelay := GMVUser.Setting[usSearchDelay];// zzzzzzandria 2007-10-04

  iCycle := round(StrToFloat(GMVSearchDelay)*2);
//  iCycle := 3;
//  tmSearch.Interval := 1000;
  tmSearch.Interval := 500;
  lblLeft.Caption := IntToStr(iCycle);
end;

procedure TfrmGMV_HospitalSelector2.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = char(VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TfrmGMV_HospitalSelector2.FormActivate(Sender: TObject);
begin
  try
    cmbTarget.SetFocus;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.cmbTargetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_Return then
    begin
//    Search;
      sbFindNameClick(nil);
      try
        if (cmbTarget.Text <>'')
          and ( pos(cmbTarget.Text+#13#10,cmbTarget.Items.Text) = 0)
          and ( (lvH.Items.Count > 1) or
               ((lvH.Items.Count = 1) and (pos('No entries',lvH.Items[1].Caption) <> 1)))
        then
          cmbTarget.Items.Insert(0,cmbTarget.Text);
      except
      end;
    end
  else if Key = VK_Down then
    begin
     if (lvH.Selected = nil) and (lvH.Items.Count > 0) then
       begin
         lvH.Selected := lvH.Items[0];
       end;
     lvH.SetFocus;
    end;
end;

procedure TfrmGMV_HospitalSelector2.cmbTargetEnter(Sender: TObject);
begin
  cmbTarget.Color := clTabIn;
end;

procedure TfrmGMV_HospitalSelector2.cmbTargetExit(Sender: TObject);
begin
  cmbTarget.Color := clTabOut;
end;

procedure TfrmGMV_HospitalSelector2.lvHExit(Sender: TObject);
begin
  lvH.Color := clTabOut;
end;

procedure TfrmGMV_HospitalSelector2.lvHEnter(Sender: TObject);
begin
  lvH.Color := clTabIn;
end;

procedure TfrmGMV_HospitalSelector2.lvHKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lv: TListView;
begin
  try
  lv := TListView(Sender);
  if lv <> nil then
    case Key of
     VK_RETURN:
      if (lv.ItemIndex > -1) then
        begin
          Key := 0;
          fID := lv.Selected.SubItems[0];
          fName := lv.Selected.Caption;
          ModalResult := mrOK;
        end;
     end;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.lvHDblClick(Sender: TObject);
var
  lv: TListView;
begin
  lv := TListView(Sender);
  if lv <> nil then
    try
//      fID := lv.Selected.SubItems[0];
//      fName := lv.Selected.Caption;
      if fID <> '' then
        ModalResult := mrOK;
    except
    end;
end;

procedure TfrmGMV_HospitalSelector2.sbFindApptClick(Sender: TObject);
var
  i: integer;
  s: String;
  li: TListItem;
  SL: TStringList;
begin
  try
    lvAppt.Items.Clear;
    SL := TStringList.Create;
    s := getLocationsByAppt(edDFN.Text,edFrom.Text,edTo.Text,edFlag.Text);
    SL.Text := s;
    for i := 0 to sl.Count - 1 do
      begin
        s := SL[i];
        if (i=0) and (pos('-1',s) <> 1) then
          continue;
        li := lvAppt.Items.Add;
        li.Caption := Piece(s,'^',4);
        li.SubItems.Add(Piece(s,'^',3));
        li.SubItems.Add(Piece(s,'^',2));
        li.SubItems.Add(Piece(s,'^',6));
//        li.SubItems.Add(Piece(s,'^',8));
      end;
    SL.Free;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.sbFindAdmitClick(Sender: TObject);
var
  ii,i: integer;
  ss,s: String;
  li: TListItem;
  SL: TStringList;
begin
  try
    lvAdmit.Items.Clear;
    SL := TStringList.Create;
    s := getLocationsByAdmit(edAdmitDFN.Text);
    SL.Text := s;
    for i := 0 to sl.Count - 1 do
      begin
        s := SL[i];
        if (i=0) and (pos('-1',s) <> 1) then
          continue;
        ss := Piece(s,'^',2);
        ii := StrToIntDef(ss,-1);
        if ii < 1 then continue; // zzzzzzandria 060112
        li := lvAdmit.Items.Add;
        li.Caption := Piece(s,'^',3);
        li.SubItems.Add(Piece(s,'^',2)); //ID
        li.SubItems.Add(Piece(s,'^',1)); // convert!!!
        li.SubItems.Add(Piece(s,'^',4));
      end;
    SL.Free;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.sbFindNameClick(Sender: TObject);
var
  i: integer;
  s: String;
  li: TListItem;
  SL: TStringList;
begin
  try
    lvH.Items.Clear;
    SL := TStringList.Create;
    s := getLocationsByName('44^'+cmbTarget.Text);
    SL.Text := s;
    for i := 0 to sl.Count - 1 do
      begin
        s := SL[i];
        if (i=0) and (pos('-1',s) <> 1) then
          continue;
        li := lvH.Items.Add;
        li.Caption := Piece(s,'^',2);
//        li.SubItems.Add(Piece(Piece(s,'^',1),':',2));
//        li.SubItems.Add(Piece(s,'^',1));
        li.SubItems.Add(Piece(Piece(s,'^',1),';',2));
      end;
    SL.Free;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.pcMainChange(Sender: TObject);
var
  lv: TListView;
begin
  lv := lvAppt;
  case pcMain.ActivePageIndex of
    0:lv := lvAppt;
    1:lv := lvAdmit;
    2:lv := lvH;
  end;
  btnOK.Enabled := readyToSelect;
  if Assigned(lv.Selected) then // zzzzzzandria 2007-07-16
  try
    fID := lv.Selected.SubItems[0];
    fName := lv.Selected.Caption;
    edSelected.Text := fName;
  except
    fID := '';
    fName := '';
  end;

  lblLeft.Caption := fName + '('+fID+')';

  try
    case pcMain.ActivePageIndex of
      0:ActiveControl := lvAppt;
      1:ActiveControl := lvAdmit;
      2:ActiveControl := cmbTarget;
    end;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector2.edTargetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_Return then
    sbFindNameClick(nil);
end;

procedure TfrmGMV_HospitalSelector2.FormDestroy(Sender: TObject);
begin
//  setUserSettings('HospitalSelections',cmbTarget.Items.Text);
end;

procedure TfrmGMV_HospitalSelector2.FormCreate(Sender: TObject);
begin
  try
//    cmbTarget.Items.Text := getUserSettings('HospitalSelections');
  except
  end;
end;

function TfrmGMV_HospitalSelector2.ReadyToSelect:Boolean;
var
  lv: TListView;
begin
  Result := False;
  case pcMain.ActivePageIndex of
    0:begin
        lv := lvAppt;
        Result := (lv.Items.Count>0) and (lv.Selected <> nil);
      end;
    1:begin
        lv := lvAdmit;
        Result := (lv.Items.Count>0) and (lv.Selected <> nil);
      end;
    2:begin
        lv := lvH;
        Result := (lv.Selected <> nil) and
          ((pos('No entries',lvH.Items[0].Caption) <> 1) and
           (pos('The input parameter',lvH.Items[0].Caption) <> 1))
      end;
  end;
end;

end.
