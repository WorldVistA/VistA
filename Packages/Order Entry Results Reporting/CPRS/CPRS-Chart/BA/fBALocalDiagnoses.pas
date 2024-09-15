unit fBALocalDiagnoses;
 {.$define debug}
interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, ExtCtrls,fPCELex, uConsults, ORFn,
  rPCE,DBCtrls, DB, DBClient, uPCE, fEncounterFrame, ComCtrls, Grids, UBAGlobals,
  Buttons, Menus, UBACore, UCore, VA508AccessibilityManager;

type
  DxRecord = Record
         DxFiller1  : string;
         DxFiller2  : string;
         DxAddToPL  : string;
         DxPrimary  : string;
         DxCode     : string;
     end;
  TfrmBALocalDiagnoses = class(TfrmAutoSz)
    pnlTop: TPanel;
    lbOrders: TListBox;
    pnlMain: TPanel;
    lbSections: TORListBox;
    pnlBottom: TORAutoPanel;
    cbAddToPDList: TCheckBox;
    cbAddToPL: TCheckBox;
    btnPrimary: TButton;
    btnRemove: TButton;
    btnSelectAll: TButton;
    buOK: TButton;
    buCancel: TButton;
    btnOther: TButton;
    lbDiagnosis: TORListBox;
    lblDiagSect: TLabel;
    lblDiagCodes: TLabel;
    lblPatientName: TStaticText;
    gbProvDiag: TGroupBox;
    lvDxGrid: TListView;
    procedure buOKClick(Sender: TObject);
    procedure buCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure lbSectionsClick(Sender: TObject);
    procedure btnOtherClick(Sender: TObject);
    procedure btnPrimaryClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure cbAddToPLClick(Sender: TObject);
    procedure ProcessAddToItems;
    procedure lbDiagnosisClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddDiagnosistoPersonalDiagnosesList1Click(Sender: TObject);
    procedure AddDiagnosistoPersonalDiagnosesList2Click(Sender: TObject);

    procedure cbAddToPDListClick(Sender: TObject);
    procedure lbSectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lvDxGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvDxGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvDxGridClick(Sender: TObject);
    procedure lbOrdersMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

  private
    { Private declarations }


    inactiveCodes: integer;
    procedure MainDriver;
    procedure LoadEncounterForm;
    procedure AddProbsToDiagnosis;
    procedure AddPCEToDiagnosis;//**  adds dx's if selected currently from ecf
    procedure AddPersonalDxToDiagnosisList;
    procedure ListDiagnosisSections(Dest: TStrings);
    procedure ListDiagnosisCodes(Section : String);
    procedure DiagnosisSelection(SelectedDx: String);
    procedure EnsurePrimary;
    function  IsDxAlreadySelected(SelectedDx: string):boolean;
    procedure BuildTempDxList;
    procedure AssocDxToOrders;
    procedure BuildBADxList;
    procedure ListGlobalDx(pOrderIDList: TStringList);
    procedure ListConsultDX(pOrderDxList: TStringList);
    procedure DeselectGridItems;
    procedure ListSelectedOrders;
    procedure BuildConsultDxList(pDxList: TStringList);
    function  AddToWhatList(IsPLChecked:boolean; IsPDLChecked:boolean):string;
    procedure AddToProblemList;
    procedure AddToPersonalDxList;
    procedure InactiveICDNotification;
    procedure LoadTempDXLists;
    procedure SetAddToCBoxStatus;
    procedure SetAddToCheckBoxStatus(ADiagnosis:string);
    procedure ClearAndDisableCBoxes;
    procedure ProcessMultSelections;
    function  ProblemListDxFound(pDxCode:string):boolean;
    function  PersonalListDxFound(pDxCode:string):boolean;
    procedure ReSetCheckBoxStatus(pDxCode:String);
    procedure DeleteSelectedDx;

  public
     FLastHintItemNum: integer;
     procedure Enter(theCaller: smallint; pOrderIDList: TStringList);
     procedure LoadTempRec(var thisRec: TBADxRecord; thisOrderID: string);
  end;

  const
  TX799 = '799.9';
  PROBLEM_LIST_SECTION = 'Problem List Items';
  PERSONAL_DX_SECTION  = 'Personal Diagnoses List Items';

var
  deleteDX: boolean;
  selectingDX: boolean;
  FDxCode: string;
  FDxSection: string;
  PList: TextFile;
  FName: string;
  MaxDx : Integer;
  GridItems: integer;
  UpdatingGrid: boolean;
  whoCalled: smallint;
  currentOrderIDList: TStringList;
  ProblemDxHoldList, PersonalDxHoldList: TStringList;
  frmBALocalDiagnoses: TfrmBALocalDiagnoses;
  lexIENHoldList: TStringList;   //** OrderID^Lexicon IEN


implementation

uses rCore, rODMeds, rODBase, rOrders, fRptBox, fODMedOIFA,
  ORNet, fProbs, UBAConst,
  UBAMessages, uSignItems, fODConsult, fFrame, VAUtils;

var
  uProblems    : TStringList;
  BADiagnosis  : TStringList;
  ECFDiagnosis : TStringList;
  uLastDFN     : string;
  uLastLocation: integer;
  ListItem     : TListItem;
  uPrimaryDxHold: string;
  PrimaryChanged: boolean;
{$R *.dfm}

//*************  Entry point *****************//

procedure TfrmBALocalDiagnoses.Enter(theCaller:smallint; pOrderIDList: TStringList);
begin
   selectingDX := False;
   deleteDX    := False;
   fBALocalDiagnoses.whoCalled := theCaller;
   currentOrderIDList := pOrderIDList;
   frmBALocalDiagnoses := TfrmBALocalDiagnoses.Create(Application);
   ResizeFormToFont(TForm(frmBALocalDiagnoses));
   frmBALocalDiagnoses.ShowModal;
   frmBALocalDiagnoses.Release;
   frmBALocalDiagnoses := nil;
end;

procedure TfrmBALocalDiagnoses.FormCreate(Sender: TObject);
begin
     MaxDx := 4;
     inactiveCodes := 0;
     MainDriver;
     GridItems := 0;
     PrimaryChanged := False;
     FLastHintItemNum := -1;
     ClearAndDisableCBoxes
end;

procedure TfrmBALocalDiagnoses.ListDiagnosisSections(Dest: TStrings);
{ return section names in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
    for i := 0 to BADiagnosis.Count - 1 do if CharAt(BADiagnosis[i], 1) = U then
    begin
       x := Piece(BADiagnosis[i], U, 2);
       if Length(x) = 0 then x := '<No Section Name>';
       Dest.Add(IntToStr(i) + U + Piece(BADiagnosis[i], U, 2) + U + x);
    end;
end;

procedure TfrmBALocalDiagnoses.MainDriver;
begin
    BADiagnosis := TStringList.Create;
    ECFDiagnosis := TStringList.Create;
    uProblems := TStringList.Create;
    lblPatientName.Caption := Patient.Name + ' Selected Orders';
    DeselectGridItems;

    if whoCalled = F_CONSULTS then
       ListConsultDX(uBAGlobals.BAConsultDxList)
    else
       ListGlobalDx(currentOrderIDList);

    LoadEncounterForm;
    ListDiagnosisSections(lbSections.Items);
    ListSelectedOrders;
    LoadTempDXLists;
end;

procedure TfrmBALocalDiagnoses.LoadTempRec(var thisRec: TBADxRecord; thisOrderID: string);
begin
  if frmFrame.TimedOut then exit;
  thisRec := TBADxRecord.Create;
  UBAGlobals.InitializeNewDxRec(thisRec);
  //** Load it
  thisRec.FOrderID := thisOrderID;
   if pos( '(', UBAGlobals.Dx1) > 0 then
     thisRec.FBADxCode := UBACore.StripTFactors(UBAGlobals.Dx1)
   else
      thisRec.FBADxCode := UBAGlobals.Dx1;

   if pos( '(', UBAGlobals.Dx2) > 0 then
     thisRec.FBASecDx1 := UBACore.StripTFactors(UBAGlobals.Dx2)
   else
      thisRec.FBASecDx1 := UBAGlobals.Dx2;

   if pos( '(', UBAGlobals.Dx3) > 0 then
     thisRec.FBASecDx2 := UBACore.StripTFactors(UBAGlobals.Dx3)
   else
      thisRec.FBASecDx2 := UBAGlobals.Dx3;

   if pos( '(', UBAGlobals.Dx4) > 0 then
     thisRec.FBASecDx3 := UBACore.StripTFactors(UBAGlobals.Dx4)
   else
      thisRec.FBASecDx3 := UBAGlobals.Dx4;

 //**  Verify Diagnosis exists prior to adding to list.
  if UBAGlobals.Dx1 <> '' then
     BADiagnosis.Add(UBAGlobals.Dx1);
  if UBAGlobals.Dx2 <> '' then
     BADiagnosis.Add(UBAGlobals.Dx2);
  if UBAGlobals.Dx3 <> '' then
     BADiagnosis.Add(UBAGlobals.Dx3);
  if UBAGlobals.Dx4 <> '' then
     BADiagnosis.Add(UBAGlobals.Dx4);
end;

procedure TfrmBALocalDiagnoses.AssocDxToOrders;
{
var
  i: Integer;
  thisOrderID: string;
  tempDxRec: TBADxRecord;
}
begin
  // ** Initialize
  if Assigned(UBAGlobals.OrderIDList) then
    UBAGlobals.OrderIDList.Clear;

  // ** Associate Dx's to Orders
  if whoCalled = F_ORDERS_SIGN then
    begin
      {
        Removed, no longer used with this form
      }
    end
  else
    if whoCalled = F_REVIEW then
    begin
      {
        Removed, no longer used with this form
      }
    end;
end;

procedure TfrmBALocalDiagnoses.buOKClick(Sender: TObject);
begin
  inherited;
//*** Load selected diagnosis to Temp List*** /////

   if whoCalled <> F_CONSULTS then
   begin
      BuildTempDxList; //** Loop thru dx grid and build list of dx's
      BuildBADxList;   //** Save selected Dx  passed to PCE-Diagnosis Tab
      AssocDxToOrders; //** Add selected Dx to TList for display and tracking.
   end
   else
   begin
      BuildConsultDxList(UBAGlobals.BAConsultDxList); //** Loop thru dx grid and build list of dx's
      fODConsult.consultQuickOrder := False; // allow multiple dx's if first selection was a quick order
   end;
   ProcessAddToItems; //** Items flagged with 'add' will be added to the Problem list table
   lvDxGrid.Clear;
   frmBALocalDiagnoses.Close;

end;

procedure  TfrmBALocalDiagnoses.LoadEncounterForm;
{ load the major coding lists that are used by the encounter form for a given location }
var
  i: integer;
  uTempList: TStringList;
  EncDt: TFMDateTime;
begin
    uLastLocation := Encounter.Location;
    EncDt := Trunc(FMToday);
  // ** add problems to the top of diagnoses.
    uTempList := TstringList.Create;
    BADiagnosis.clear;
    CallVistA('ORWPCE DIAG',  [uLastLocation, EncDt],uTempList);
    BADiagnosis.add(utemplist.strings[0]);
    AddProbsToDiagnosis;

    // ** Loading Diagnoses if previously entered via the Encounter Form
    AddPersonalDxToDiagnosisList;

    if Assigned(BAPCEDiagList) then
    begin
       AddPCEToDiagnosis;
    end;

    for i := 1 to (uTempList.Count-1) do
       BADiagnosis.add(uTemplist.strings[i]);

end;

// **  Add problem-list enteries to Diagnosis selection list
procedure TfrmBALocalDiagnoses.AddProbsToDiagnosis;
var
  i : integer;
  EncDt: TFMDateTime;
  ProblemListTFactors: string;
begin
   // ** Get problem list
   EncDt := Trunc(FMToday);
   uLastDFN := Patient.DFN;
   CallVistA('ORWPCE ACTPROB', [Patient.DFN, EncDT],UProblems);

   if uProblems.Count > 0 then
   begin
      BADiagnosis.add('^Problem List Items');
      for i := 1 to (uProblems.count-1) do
      begin
        // ** add PL Treatment Factors to Dx Display List.
   //HDS00006194     if (Piece(uproblems.Strings[i],U,3) = '799.9') then continue;
   //HDS00006194     if (Piece(uproblems.Strings[i],U,2) = '799.9') then continue;
              // change made to allow 799.9 into selection list
        AttachPLTFactorsToDx(ProblemListTFactors,uProblems.Strings[i]);

        if (Piece(uproblems.Strings[i], U, 11) =  '#') then
        begin
           BADiagnosis.add(Piece(uProblems.Strings[i],U,3) + U +                   // PL code inactive
                           Piece(uProblems.Strings[i],U,2) + U + '#');
           inc(inactiveCodes);
        end
        else if (Piece(uproblems.Strings[i], U, 10) =  '') then                  // no inactive date for code
           BADiagnosis.add(ProblemListTFactors)
        else if (Trunc(StrToFloat(Piece(uProblems.Strings[i], U, 10))) > EncDT) then     // code active as of EncDt
           BADiagnosis.add(Piece(uProblems.Strings[i],U,3) + U +
                           ProblemListTFactors )
        else
           BADiagnosis.add(Piece(uProblems.Strings[i],U,3) + U +                   // PL code inactive
                           Piece(uProblems.Strings[i],U,2) + U + '#');
    end;
  end;
end;

procedure TfrmBALocalDiagnoses.AddPCEToDiagnosis;
var
  i: integer;
begin
     for i := 0 to (BAPCEDiagList.Count-1) do
     begin
        if CharAt(BAPCEDiagList.Strings[i], 1) = U then
           BADiagnosis.Add(BAPCEDiagList.Strings[i])  //** section header
        else
           BADiagnosis.add(Piece(BAPCEDiagList.Strings[i],U,1) + U + Piece(BAPCEDiagList.Strings[i],U,2));
    end;
end;

procedure TfrmBALocalDiagnoses.AddPersonalDxToDiagnosisList;
var
 personalDxList: TStringList;
 personalDxListSorted: TStringList;
 i,z: integer;
begin

   personalDxList := TStringList.Create;
   personalDxListSorted := TStringlist.Create;
   personalDxList.Clear;
   personalDxListSorted.Clear;
   personalDxList := rpcGetPersonalDxList(User.DUZ);
   for i := 0 to personalDxList.Count-1 do
      personalDxListSorted.Add(Piece(personalDXList.Strings[i],U,2) + U + (Piece(personalDXList.Strings[i],U,1)) );
   //******  sort personal dx list alphabetical by code name
    personalDxListSorted.Sorted := False;
    personalDxListSorted.Sorted := True ;
    personalDxList.Clear;
    for z := 0 to personalDxListSorted.Count-1 do
        personalDxList.Add(Piece(personalDXListSorted.Strings[z],U,2) + U + (Piece(personalDXListSorted.Strings[z],U,1)) );


   if personalDxList.Count > 0  then
   begin
      BADiagnosis.add(U + DX_PERSONAL_LIST_TXT);
      for i := 0 to personalDxList.Count-1 do
         BADiagnosis.Add(personalDxList.Strings[i]);
   end
   else
      BADiagnosis.add('^NO Personal Diagnoses Available');
end;


procedure TfrmBALocalDiagnoses.buCancelClick(Sender: TObject);
begin
   lvDxGrid.Clear;
   fODConsult.displayDXCode := 'DXCANCEL';// retain original dx in consult dialog
   uBAGlobals.TFactors := '';  // clear treatment factors from last order.// hds00006266
   Close;
end;

procedure TfrmBALocalDiagnoses.Button4Click(Sender: TObject);
begin
 Close;
end;

procedure TfrmBALocalDiagnoses.lbSectionsClick(Sender: TObject);
var i: integer;
begin
     for i := 0 to lbSections.Items.Count-1 do
     begin
        if(lbSections.Selected[i]) then
        begin
           lvDxGrid.ClearSelection;
           ClearAndDisableCBoxes;
           ListDiagnosisCodes(lbSections.Items[i]);
           FDXSection := lbSections.Items[i];
           Break;
        end;
    end;
end;

procedure TfrmBALocalDiagnoses.ListDiagnosisCodes(Section: String);
var
i,j: integer;
a: string;
begin
   lbDiagnosis.Clear;

   for i := 0 to BADiagnosis.Count-1 do
   begin
      a := BADiagnosis.Strings[i];
      if Piece(BADiagnosis[i], U, 2) = (Piece(Section,U,2)) then
         Break;
   end;

   inc(i);

   for j := i to BADiagnosis.Count-1 do
   begin
      if Piece(BADiagnosis[j], U, 0) = '' then
         break
      else
      begin
         a :=  Piece(BADiagnosis[j], U, 2) + U + Piece(BADiagnosis[j], U, 1) + U + '        ' + Piece(BADiagnosis[j], U, 3) ;
         if a = '' then ShowMsg('found nothing');
            lbDiagnosis.Items.Add(a);
      end;
   end;
end;

procedure TfrmBALocalDiagnoses.btnOtherClick(Sender: TObject);
var
  Match: string;
  selectedDx: string;
  //i: integer;
  lexIEN: string;
begin
  lvDxGrid.ClearSelection;
  //ProvDx.Code := ''; //** init
  lexIEN := '';
  BAPersonalDX := True; //** returns LexIEN in piece 3
  //** Execute LEXICON
  LexiconLookup(Match, LX_ICD);
  if Match = '' then Exit;
  //fOrdersSign.ProvDx.Code := Piece(Match, U, 1);
  //fOrdersSign.ProvDx.Text := Piece(Match, U, 2);
  lexIEN := Piece(Match, U, 3);
  //i := Pos(' (ICD', fOrdersSign.ProvDx.Text);
  //if i = 0 then i := Length(ProvDx.Text) + 1;
  //if fOrdersSign.ProvDx.Text[i-1] = '*' then i := i - 2;
  //fOrdersSign.ProvDx.Text := Copy(fOrdersSign.ProvDx.Text, 1, i - 1);
  //fOrdersSign.ProvDx.Text := StringReplace(fOrdersSign.ProvDx.Text,':',' ',[rfReplaceAll]);
  //fOrdersSign.ProvDx.Code := StringReplace(fOrdersSign.ProvDx.Code,':',' ',[rfReplaceAll]);

  //selectedDx := (fOrdersSign.ProvDx.Text + ':' + fOrdersSign.ProvDx.Code);
  // if strLen(PChar(lexIEN) ) > 0 then
  //    lexIENHoldList.Add(fOrdersSign.ProvDx.Code + U + lexIEN);

  //** Begin CQ4819
  if not IsDxAlreadySelected(selectedDx) then
  begin
     //if UBACore.IsICD9CodeActive(fOrdersSign.ProvDx.Code,'ICD',0) then
     //   DiagnosisSelection(selectedDx)
     //else
     //   InfoBox(BA_INACTIVE_ICD9_CODE_1 + fOrdersSign.ProvDx.Code + BA_INACTIVE_ICD9_CODE_2 , BA_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
  end;
  //** End CQ4819
  BAPersonalDX := False;
  SetAddToCheckBoxStatus(selectedDX);

end;

procedure TfrmBALocalDiagnoses.btnPrimaryClick(Sender: TObject);
var
  i: shortint;
  Primary: boolean;
begin
  inherited;
   Primary := FALSE;
   if lvDxGrid.Items.Count = 0 then Exit; //** Exit if list empty
   for i := 0 to lvDxGrid.Items.Count-1 do
   begin
   if(lvDxGrid.Items[i].Selected) then
   begin
      if not Primary then
      begin
         LvDxGrid.Items[i].SubItems[0] := UBAConst.PRIMARY_DX;
         Primary :=TRUE;
      end;
   end
   else
      LvDxGrid.Items[i].SubItems[0] := UBAConst.SECONDARY_DX ;
   end;

     if not Primary then EnsurePrimary;
end;

procedure TfrmBALocalDiagnoses.btnRemoveClick(Sender: TObject);
begin
  inherited;
  deleteDX := True;
  frmBALocalDiagnoses.DeleteSelectedDX;
  ClearAndDisableCBoxes;
  DeselectGridItems;
  EnsurePrimary;
  deleteDX := False;
  // if all dx's removed, clear out displaycode
  if lvDxGrid.items.Count = 0 then FODConsult.displayDXCode := '';
end;

procedure TfrmBALocalDiagnoses.btnSelectAllClick(Sender: TObject);
var
 i: integer;
begin
  inherited;
  for i := 0 to lvDxGrid.Items.Count-1 do
  begin
      if cbAddToPDList.Enabled then
         SetAddToCheckBoxStatus(lvDxGrid.Items[i].Subitems[1]);  //** personal dx
      if cbAddToPL.Enabled then
         SetAddToCheckBoxStatus(lvDxGrid.Items[i].Subitems[1]);; //** problem dx
  end;

  lvDxGrid.MultiSelect := true;
  lvDxGrid.SelectAll;
  lvDxGrid.Setfocus;
end;

procedure TfrmBALocalDiagnoses.DiagnosisSelection(SelectedDx: String);
begin
// ** Set up Dx grid
 if lvDxGrid.Items.Count < MaxDx then
    begin
      if lvDxGrid.Items.count = 0 then
         begin
            ListItem := lvDxGrid.Items.Add; // ** add the row instance prior to adding text //  adding text.
            ListItem.SubItems.Add(UBAConst.PRIMARY_DX);
            ListItem.SubItems.Add(SelectedDX);
         end
      else
         begin
            DeselectGridItems;
            ListItem := lvDxGrid.Items.Add;    // ** add the row instance prior to adding text.
            ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
            ListItem.SubItems.Add(SelectedDX);
         end;
    end
 else
    begin
       DeselectGridItems;
       ShowMsg(BA_MAX_DX); //** max  4 diagnoses per order
    end;
end;

// insure unique diagnoses entered.
function TfrmBALocalDiagnoses.IsDxAlreadySelected(SelectedDx: string):boolean;
var i: integer;
x: string;
begin
   Result := False;
   with lvDxGrid do
   begin
      for i := 0 to lvDxGrid.Items.Count-1 do
      begin
         x := lvDxGrid.Items[i].Subitems[1];
         if Piece(x,':',2) = Piece(SelectedDx,':',2) then
         begin
            Result := True;
            Break;
         end;
      end;
  end;
end;

function  TFrmBALocalDiagnoses.ProblemListDxFound(pDxCode:string):boolean;
var
 i: integer;
 problemDx: string;
begin
    Result := False;
    for i := 0 to ProblemDXHoldList.Count -1 do
    begin
      problemDX := ProblemDXHoldList.Strings[i];
      problemDX := Piece(ProblemDX,':',2);
      if pDxCode = problemDX then
      begin
         Result := True;
         break;
      end;
    end;//** for
end;

function  TFrmBALocalDiagnoses.PersonalListDxFound(pDxCode:string):boolean;
var
 i: integer;
 personalDx: string;
begin
   Result := False;
   for i := 0 to PersonalDxHoldList.Count -1 do
   begin
      personalDX := PersonalDXHoldList.Strings[i];
      personalDX := Piece(personalDX,':',2);
      if pDxCode = personalDX then
      begin
         Result := True;
         break;
      end;
   end;
end;


procedure TfrmBALocalDiagnoses.EnsurePrimary;
var
   Primary: boolean;
   i : integer;
begin
  Primary := False;

  for i := 0 to lvDxGrid.Items.Count-1 do
  begin
     if LvDxGrid.Items[i].SubItems[0] = UBAConst.PRIMARY_DX then
     begin
        Primary := True;
        Break;
     end;
  end;

  if not Primary then
  begin
     if lvDxGrid.Items.Count > 0 then
        lvDxGrid.Items[0].Subitems[0] := UBAConst.PRIMARY_DX;
  end;
end;

procedure TfrmBALocalDiagnoses.cbAddToPLClick(Sender: TObject);
var i: integer;
begin
  inherited;
  if cbAddToPL.Checked then
  begin
      for i := 0 to lvDxGrid.Items.Count-1 do
      begin
          if(lvDxGrid.Items[i].Selected) then
          begin
              lvDxGrid.Items[i].Caption :=  AddToWhatList(cbAddToPL.Checked,cbAddToPDList.Checked);
              cbaddToPL.Checked := true;
              lvDxGrid.Items[i].Selected := True;
              lvDxGrid.SetFocus;
          end;
      end;
   end
   else
     begin
      if not cbaddToPL.Checked then
      for i := 0 to lvDxGrid.Items.Count-1 do
      begin
         if(lvDxGrid.Items[i].Selected) then
         begin
           lvDxGrid.Items[i].Caption := AddToWhatList(cbAddToPL.Checked,cbAddToPDList.Checked);
           lvDxGrid.Items[i].Selected := True;
           lvDxGrid.SetFocus;
         end;
      end;
end;
    EnsurePrimary;
end;

procedure TfrmBALocalDiagnoses.ProcessAddToItems;
begin
   AddToProblemList;
   AddToPersonalDxList;
end;


procedure TfrmBALocalDiagnoses.AddToPersonalDxList;
var
 i,j: integer;
 tempcode,thisCode : string;
 tempList, addToPDList: TStringList;
begin
    templist := TStringList.Create;
    addToPDList := TStringList.Create;
    tempList.Clear;
    addTOPDList.Clear;
    with lvDxGrid do
    begin
       for i := 0 to Items.Count-1 do
       begin
          if StrPos(PChar(LvDxGrid.Items[i].Caption),PChar(ADD_TO_PERSONAL_DX_LIST)) <> nil then
          begin
             tempCode := lvDxGrid.Items[i].Subitems[1];
             tempCode := Piece(tempCode, ':', 2);
             tempList.Add(tempCode);
          end;
       end;
    end;

    //** add Lexicon IEN to list (if any)
    for i := 0 to tempList.Count -1 do
    begin
       thisCode := tempList.Strings[i];
       if lexIENHoldList.Count > 0 then  //HDS6393
       begin
          for j := 0 to lexIENHoldList.Count-1 do
          begin
             if thisCode = Piece(lexIENHoldList.Strings[j],U,1) then
                AddToPDList.Add(thisCode + U + Piece(lexIENHoldList.Strings[j],U,2) )  // code was selected from Lexicon
             else
                AddToPDList.Add(thisCode);
          end;
       end
       else  //HDS6393
          AddToPDList.Add(thisCode); // code was not selected from the Lexicon.  //HDS6393
    end;
    if AddToPDList.Count > 0 then
       rpcAddToPersonalDxList(User.DUZ,AddToPDList);
end;

procedure TfrmBALocalDiagnoses.AddToProblemList;
var
  i: Integer;
  tempcode, passCode: string;
  NewList: TStringList;
  PatientInfo: string;
  ProviderID: string;
  ptVAMC: string;

begin
  PatientInfo := Patient.DFN + U + Patient.Name + U;
  ProviderID := IntToStr(Encounter.Provider);
  ptVAMC := '';
  NewList := TStringList.Create;
  NewList.Clear;
  // ** Add Diagnosis to Problem List if flagged with 'Add' in First Col.
  with frmBALocalDiagnoses.lvDxGrid do
  begin
    for i := 0 to Items.Count - 1 do
    begin
      if StrPos(PChar(lvDxGrid.Items[i].Caption), PChar(ADD_TO_PROBLEM_LIST)) <> nil
      then
      begin
        tempcode := lvDxGrid.Items[i].SubItems[1];
        // ** passCode consists of Dx Code '^' Dx Desc /////
        passCode := Piece(tempcode, ':', 2) + U + Piece(tempcode, ':', 1);
        if Piece(passCode, U, 1) <> TX799 then
        begin
          NewList := BAPLRec.BuildProblemListDxEntry(passCode);
          try
            CallVistA('ORQQPL ADD SAVE', [PatientInfo, ProviderID,
              BAPLPt.ptVAMC, NewList]);
          finally
            NewList.Free;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmBALocalDiagnoses.BuildConsultDxList(pDxList: TStringList); // ** adds grid items to BAConsultDxList - uConsults
var
  i: integer;
  x: string;
begin
    UBAGlobals.BAConsultDxList.Clear;

    if lvDxGrid.Items.Count > 0 then
    with lvDxGrid do
    begin
       for i := 0 to Items.Count-1 do
       begin
          if i = 0 then fODConsult.displayDXCode := lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1];
          x:= lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1];
          if Piece(lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1],U,1) = PRIMARY_DX  then
             fODConsult.displayDXCode := Piece(lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1],U,2);
          uBAGlobals.BAConsultDxList.Add(lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1]);
       end;
       uBAGlobals.BAConsultDxList.Sort;
    end
    else
       uBAGlobals.BAConsultDxList.Clear;
end;


procedure TfrmBALocalDiagnoses.BuildTempDxList;
var
   i : integer;
   tempStr1,tempStr2, tempStr3: string;
   tempFactor1: string;
   tempStrList: TStringList;
begin
   tempStrList := TStringList.Create;
   if Assigned(tempStrList) then tempStrList.Clear;

   UBAGlobals.Dx1 := '';
   UBAGlobals.Dx2 := '';
   UBAGlobals.Dx3 := '';
   UBAGlobals.Dx4 := '';
   UBAGlobals.TFactors := '';
   tempstr1 := '';
   tempstr2 := '';
   tempstr3 := '';
   tempFactor1 := '';

   if frmBALocalDiagnoses.lvDxGrid.Items.Count > 0 then
   with frmBALocalDiagnoses.lvDxGrid do
   begin
      for i := 0 to Items.Count-1 do
      begin
     //    x := lvDxGrid.Items[i].Subitems[0];
     //    x := lvDxGrid.Items[i].Subitems[1];
     //    x:= lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1];
         tempStrList.Add(lvDxGrid.Items[i].Subitems[0] + '^' + lvDxGrid.Items[i].Subitems[1]);
      end;
      if tempStrList.Count > 0 then
         tempStrList.Sort;  //**  Sort list Ascending order.
      with  tempStrList do
      begin
         tempFactor1 := (Piece(tempStrList.Strings[0],'(',2)); //** 0 = Primary
         tempFactor1 := (Piece(tempFactor1,')',1) );
         if (Length(tempFactor1) > 0) then
            UBAGLobals.TFactors := tempFactor1;
         for i := 0 to  tempStrList.Count-1 do
         begin
            tempstr1 := (Piece(tempStrList.Strings[i],U,2));
            tempstr2 := (Piece(tempstr1,':',1) + '^'+ Piece(tempstr1,':',2));
            if i = 0 then //** has primary dx changed
            begin
               if tempStr2 <> uPrimaryDxHold then
               begin
                  if tempStr2 <> '' then
                     PrimaryChanged := True;
               end;
            end;
            if tempstr2 = U then
               tempstr2 := DXREC_INIT_FIELD_VAL;
            case i of
               0: UBAGlobals.Dx1 := tempStr2;
               1: UBAGlobals.Dx2 := tempStr2;
               2: UBAGlobals.Dx3 := tempStr2;
               3: UBAGlobals.Dx4 := tempStr2;
            else
               Exit;
            end;
         end;
   end;
  end
   else
      if lvDxGrid.Items.Count = 0 then
      begin
         UBAGlobals.Dx1 := DXREC_INIT_FIELD_VAL;
         UBAGlobals.Dx2 := DXREC_INIT_FIELD_VAL;
         UBAGlobals.Dx3 := DXREC_INIT_FIELD_VAL;
         UBAGlobals.Dx4 := DXREC_INIT_FIELD_VAL;
      end;
end;

procedure TfrmBALocalDiagnoses.BuildBADxList;
begin
   if not assigned(BADiagnosisList) then
   begin
      BADiagnosisList := TStringList.Create;
      BADiagnosisList.Duplicates := dupIgnore;
      BADiagnosisList.Sorted := True;
   end;

   if UBAGlobals.Dx1 <> '' then
      BADiagnosisList.Add(U + UBAGlobals.Dx1 + U);

   if UBAGlobals.Dx2 <> '' then
      BADiagnosisList.Add(U + UBAGlobals.Dx2 + U);

   if UBAGlobals.Dx3 <> '' then
      BADiagnosisList.Add(U + UBAGlobals.Dx3 + U);

   if UBAGlobals.Dx4 <> '' then
      BADiagnosisList.Add(U + UBAGlobals.Dx4 + U);
end;

procedure TfrmBALocalDiagnoses.ListConsultDX(pOrderDxList: TStringList);
var
 i: integer;
 dx1,dx2,dx3,dx4: string;
 begin
   if UBAGlobals.BAConsultDxList.Count = 0 then Exit;
   dx1 := '';
   dx2 := '';
   dx3 := '';
   dx4 := '';
   for i := 0 to BAConsultDxList.Count-1 do
   begin
     case i of
       0: dx1 := BAConsultDxList.Strings[i];
       1: dx2 := BAConsultDxList.Strings[i];
       2: dx3 := BAConsultDxList.Strings[i];
       3: dx4 := BAConsultDxList.Strings[i];
     end;
   end;

   ListItem := lvDxGrid.Items.Add;
   if Length(dx1) > 0 then
      ListItem.SubItems.Add(UBAConst.PRIMARY_DX)
   else
       ListItem.SubItems.Add(DXREC_INIT_FIELD_VAL);
       ListItem.SubItems.Add(Piece(dx1,U,2));

       if Length(dx2) > 1 then
       begin
          ListItem := lvDxGrid.Items.Add;
          ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
          ListItem.SubItems.Add(Piece(dx2,U,2));
       end;

       if Length(dx3) > 1 then
       begin
          ListItem := lvDxGrid.Items.Add;
          ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
          ListItem.SubItems.Add(Piece(dx3,U,2));
       end;

       if Length(dx4) > 1 then
       begin
          ListItem := lvDxGrid.Items.Add;
          ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
          ListItem.SubItems.Add(Piece(dx4,U,2));
       end;
end;

procedure TfrmBALocalDiagnoses.ListGlobalDx(pOrderIDList: TStringList);  //  need to get rec based on orderid
var
  i :integer;
begin

   if not Assigned(UBAGlobals.globalDxRec) then Exit;

   if (Assigned(UBAGlobals.globalDxRec)) and (UBAGlobals.globalDxRec.FBADxCode = '') then Exit;

    for i := 0 to pOrderIDList.Count-1 do
    begin
       if tempDxNodeExists(pOrderIDList.Strings[i]) then
          begin
             UBAGlobals.globalDxRec.FOrderID :=  pOrderIDList.Strings[i];
             break;
          end;
    end;
    ListItem := lvDxGrid.Items.Add;
    if Length(UBAGlobals.globalDxRec.FBADxCode) > 0 then
       ListItem.SubItems.Add(UBAConst.PRIMARY_DX)
    else
       ListItem.SubItems.Add(DXREC_INIT_FIELD_VAL);
       uPrimaryDxHold := UBAGlobals.globalDxRec.FBADxCode;
       ListItem.SubItems.Add(UBAGlobals.globalDxRec.FBADxCode);

       if Length(UBAGlobals.globalDxRec.FBASecDx1) > 1 then
       begin
          ListItem := lvDxGrid.Items.Add;
          ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
          ListItem.SubItems.Add(UBAGlobals.globalDxRec.FBASecDx1);
       end;

       if Length(UBAGlobals.globalDxRec.FBASecDx2) > 1 then
       begin
          ListItem := lvDxGrid.Items.Add;
          ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
          ListItem.SubItems.Add(UBAGlobals.globalDxRec.FBASecDx2);
       end;

       if Length(UBAGlobals.globalDxRec.FBASecDx3) > 1 then
       begin
          ListItem := lvDxGrid.Items.Add;
          ListItem.SubItems.Add(UBAConst.SECONDARY_DX);
          ListItem.SubItems.Add(UBAGlobals.globalDxRec.FBASecDx3);
       end;
end;

procedure TfrmBALocalDiagnoses.lbDiagnosisClick(Sender: TObject);
var
 i : integer;
  newDxCode, initDxCode: string;
begin
  inherited;
    for i := 0 to lbDiagnosis.Count-1 do
    begin
       if(lbDiagnosis.Selected[i]) then
       begin
          initDxCode :=  StringReplace(lbDiagnosis.Items[i],':',' ',[rfReplaceAll]);
          newDxCode := (Piece(initDxCode,U,1) + ':'+ Piece(initDxCode,U,2));
          if UBACore.IsICD9CodeActive(Piece(newDxCode,':',2),'ICD',Encounter.DateTime) then
          begin
             if not IsDxAlreadySelected(newDxCode) then
             begin
                 DiagnosisSelection(newDxCode);
                 SetAddToCheckBoxStatus(newDxCode);
             end
             else
                begin
                   DeselectGridItems;
                   lvDxGrid.Items[lvDxGrid.items.Count-1].Selected := true;
                   InfoBox(BA_DUP_DX_DISALLOWED_1 + Piece(newDxCode,':',2) + BA_DUP_DX_DISALLOWED_2,BA_DUP_DX ,MB_ICONINFORMATION or MB_OK);
                end;
           end
           else
              InfoBox(BA_INACTIVE_ICD9_CODE_1 + Piece(newDxCode,':',2) + BA_INACTIVE_ICD9_CODE_2 , BA_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
    end;
  end;
end;


procedure TfrmBALocalDiagnoses.DeselectGridItems;
var
i: integer;
begin
    if lvDxGrid.Items.Count = 0 then
       lvDxGrid.Clear
    else
       begin
       for i := 0 to lvDxGrid.Items.Count-1 do
          lvDxGrid.Items[i].Selected := false;
       end;
end;

procedure TfrmBALocalDiagnoses.FormActivate(Sender: TObject);
begin
  inherited;
     InactiveICDNotification;
end;

procedure TfrmBALocalDiagnoses.FormShow(Sender: TObject);
begin
  lbSections.Selected[0] := false;

   if lbSections.Count > 0 then
      ListDiagnosisCodes(lbSections.Items[0]);
end;

procedure TfrmBALocalDiagnoses.ListSelectedOrders;
var i: integer;
begin
    if BAtmpOrderList.Count > 0 then
    try
       for i:= 0 to BAtmpOrderList.Count -1 do
       begin
          lbOrders.Items.Add(StringReplace(BAtmpOrderList.Strings[i],CRLF,'  ',[rfReplaceAll]) );

       end;
   except
      on EListError do
         begin
//         Show508Message('EListError in frmBALocalDiagnoses.ListSelectedOrders()');
         raise;
         end;
    end; //try

end;

procedure TfrmBALocalDiagnoses.AddDiagnosistoPersonalDiagnosesList1Click(Sender: TObject);
var
   i: integer;
   pCodeList: TStringList;
   selectedList: TStringList;
begin
  inherited;
  pCodeList := TStringList.Create;
  selectedList := TStringList.Create;

  if Assigned(pCodeList) then pCodeList.Clear;
  if Assigned(selectedList) then selectedList.Clear;

  try
     for i := 0 to lbDiagnosis.Items.Count-1 do
        if(lbDiagnosis.Selected[i]) then
             selectedList.Add((Piece(lbDiagnosis.Items[i],U,2)) );
   except
      on EListError do
         begin
//         Show508Message('EListError in frmBALocalDiagnoses.AddDiagnosisToPersonalDiagnosesListClick()');
         raise;
         end;
    end; //try

     if selectedList.Count > 0 then
       if UBACore.rpcAddToPersonalDxList(User.DUZ,selectedList) then
       begin
          ShowMsg(UBAMessages.BA_PERSONAL_LIST_UPDATED);
          LoadEncounterForm;
          Refresh;
       end;

end;

procedure TfrmBALocalDiagnoses.AddDiagnosistoPersonalDiagnosesList2Click(
  Sender: TObject);
  var i:integer;
      selectedList: TStringList;
begin
  inherited;
  selectedList := TStringList.Create;
  if Assigned(selectedList) then selectedList.create;

  for i := 0 to lvDxGrid.Items.Count-1 do
  begin
  if(lvDxGrid.Items[i].Selected) then
     selectedList.Add( piece(LvDxGrid.Items[i].SubItems[1],':',2) );
  end;
  if UBACore.rpcAddToPersonalDxList(User.DUZ,selectedList) then
  begin
     ShowMsg(UBAMessages.BA_PERSONAL_LIST_UPDATED);
     LoadEncounterForm;
     Refresh;
  end;
end;


procedure TfrmBALocalDiagnoses.cbAddToPDListClick(Sender: TObject);
var i: integer;
begin
  inherited;

   if cbAddToPDList.Checked then
      begin
      for i := 0 to lvDxGrid.Items.Count-1 do
      begin
          if(lvDxGrid.Items[i].Selected) then
          begin
              lvDxGrid.Items[i].Caption := AddToWhatList(cbAddToPL.Checked,cbAddToPDList.Checked);
              cbaddToPDList.Checked := true;
              lvDxGrid.SetFocus;
          end
          else
             if(lvDxGrid.Items[i].Selected) then
             begin
                lvDxGrid.Items[i].Caption := AddToWhatList(cbAddToPL.Checked,cbAddToPDList.Checked);
                cbaddToPL.Checked := false;
                lvDxGrid.SetFocus;
             end;
      end;
   end
   else
     begin
      if not cbaddToPDList.Checked then
      for i := 0 to lvDxGrid.Items.Count-1 do
      begin
         if(lvDxGrid.Items[i].Selected) then
            lvDxGrid.Items[i].Caption := AddToWhatList(cbAddToPL.Checked,cbAddToPDList.Checked);
      end;
end;
    EnsurePrimary;
end;

function  TfrmBALocalDiagnoses.AddToWhatList(IsPLChecked:boolean; IsPDLChecked:boolean):string;
begin
  Result := '';

  if IsPLChecked and IsPDLChecked then
     Result := 'PL/PD'
  else
    if IsPLChecked then
       Result := 'PL'
  else
    if IsPDLChecked then
       Result := 'PD';

end;

procedure TfrmBALocalDiagnoses.InactiveICDNotification;
begin
   if inactiveCodes > 0 then
   begin
      if (not BAFWarningShown) and (inactiveCodes > 0)  then
      begin
       InfoBox('There are ' + IntToStr(inactiveCodes) + ' active problem(s) flagged with a "#" as having' + #13#10 +
               'inactive ICD codes as of today''s date.  Please correct these' + #13#10 +
               'problems via the Problems Tab - Change" option.', 'Inactive ICD Codes Found', MB_ICONWARNING or MB_OK);
       BAFWarningShown := True;
      end;
   end;
end;

procedure TfrmBALocalDiagnoses.lbSectionsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  inherited;
  lbsections.Font.Size := MainFontSize;
  if (control as Tlistbox).items[index] = DX_PROBLEM_LIST_TXT then
     (Control as TListBox).Canvas.Font.Style := [fsBold]
  else
     if (control as Tlistbox).items[index] = DX_PERSONAL_LIST_TXT then
        (Control as TListBox).Canvas.Font.Style := [fsBold]
  else
     if (control as Tlistbox).items[index] = DX_ENCOUNTER_LIST_TXT then
        (Control as TListBox).Canvas.Font.Style := [fsBold];

  (Control as TListBox).Canvas.TextOut(Rect.Left+2, Rect.Top+1, (Control as
              TListBox).Items[Index]); {** display the text }

end;

//** Loads string lists containing Diagnoses contained in the Problem and Personal DX List.
//** These lists will be used to insure duplicates can not be entered via add to check boxes.
procedure TfrmBALocalDiagnoses.LoadTempDXLists;
var
  i: integer;
  sChar,probDX,x: string;
  updatingProblemList, updatingPersonalList: boolean;
begin
   sChar := ')';
   updatingProblemList := FALSE;
   updatingPersonalList := FALSE;
   if Assigned(ProblemDxHoldList) then ProblemDxHoldList.Clear;
   if Assigned(PersonalDxHoldList) then PersonalDxHoldList.Clear;
   for i := 0 to BADiagnosis.Count - 1 do
   begin
      x := BADiagnosis.Strings[i];
      if CharAt(BADiagnosis[i], 1) = U then
      begin
         if Piece(BADiagnosis.Strings[i],U,2) = PROBLEM_LIST_SECTION then
         begin
            updatingProblemList := TRUE;
            updatingPersonalList := FALSE;
         end
         else
         begin
            if Piece(BADiagnosis.Strings[i],U,2) = PERSONAL_DX_SECTION then
            begin
              updatingProblemList :=  FALSE;
              updatingPersonalList := TRUE;
            end
            else
            begin
               updatingProblemList := FALSE;
               updatingPersonalList := FALSE;
            end;
         end;
     end;
     if updatingProblemList then
     begin
        if Piece(BADiagnosis.Strings[i],U,2) = PROBLEM_LIST_SECTION then lbSections.Selected[0] := true;
        if strPos(pChar(BADiagnosis.Strings[i]) , pChar(sChar) ) <> nil then
        begin
           probDX := StringReplace(BADiagnosis.Strings[i],'(','^',[rfReplaceAll]);
           probDX := StringReplace(probDX,')','^',[rfReplaceAll]);
           probDX := Piece(probDX,U,2) + ':' + Piece(probDX,U,1);
           probDX := StringReplace(probDX,' ','',[rfReplaceAll]);
           ProblemDXHoldList.Add(probDX);
        end
        else
           ProblemDxHoldList.Add(Piece(BADiagnosis.Strings[i],U,2) +':' +Piece(BADiagnosis.Strings[i],U,1) );
     end
     else
       if updatingPersonalList then
          PersonalDxHoldList.Add(Piece(BADiagnosis.Strings[i],U,2) + ':' + Piece(BADiagnosis.Strings[i],U,1) );
      end;
end;

procedure TfrmBALocalDiagnoses.lvDxGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if(ssShift in Shift) or(ssCtrl in Shift) then
     selectingDX := True;
end;

//** set Add To Check Boxes status.
procedure TfrmBALocalDiagnoses.SetAddToCBoxStatus;
var
    i: integer;
    x: string;
begin
  UpdatingGrid := False;

  // ** detemine status of "add to" check boxes.....

  //** if dx selected already exists in Problem or Personal Dx List then
  //** add to checkboxes are disabled.
  for i := 0 to lvDxGrid.Items.Count-1 do
  begin
     if lvDxGrid.Items[i].Selected then
     begin
         x:= lvDxGrid.Items[i].Subitems[1];
         lvDxGrid.Items[i].Selected := True;
         SetAddToCheckBoxStatus(lvDxGrid.Items[i].Subitems[1]);
         lvDxGrid.SetFocus;
     end;
  end;

  for i := 0 to lvDxGrid.Items.Count-1 do
  begin
     if lvDxGrid.Items[i].Selected then
        if lvDxGrid.Items[i].Caption = 'PL/PD' then
        begin
           UpdatingGrid := True;
           lvDxGrid.Items[i].Selected := True;
           cbaddToPL.Checked := True;
           cbAddToPDList.Checked := true;
           ResetCheckBoxStatus(lvDxGrid.Items[i].Subitems[1]);
           lvDxGrid.SetFocus;
        end
        else if lvDxGrid.Items[i].Caption = 'PL' then
        begin
           UpdatingGrid := True;
           lvDxGrid.Items[i].Selected := True;
           cbaddToPL.Checked := True;
           cbAddToPDList.Checked := False;
           ResetCheckBoxStatus(lvDxGrid.Items[i].Subitems[1]);
           lvDxGrid.SetFocus;
        end
        else if lvDxGrid.Items[i].Caption = 'PD' then
        begin
           UpdatingGrid := True;
           lvDxGrid.Items[i].Selected := True;
           cbaddToPL.Checked := False;
           cbAddToPDList.Checked := True;
           ResetCheckBoxStatus(lvDxGrid.Items[i].Subitems[1]);
           lvDxGrid.SetFocus;
        end;
  end;
   // ** end determine check box status................
end;


procedure TfrmBALocalDiagnoses.lvDxGridKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
     selectingDX := False;
end;

procedure TfrmBALocalDiagnoses.lvDxGridClick(Sender: TObject);
begin
  inherited;
if deleteDX then Exit;

if lvDxGrid.SelCount > 1 then
   ProcessMultSelections
else
   SetAddToCBoxStatus;
end;

procedure TfrmBALocalDiagnoses.lbOrdersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  lstIndex: integer;
begin
  inherited;
  //** CQ4739
  with lbOrders do
     begin
     lstIndex := SendMessage(Handle, LB_ITEMFROMPOINT, 0, MakeLParam(X, Y));
     if (lstIndex >= 0) and (lstIndex <= Items.Count-1) then
        Hint := Items[lstIndex]
     else
        Hint := '';
     end;
  //** end CQ4739
end;

procedure TfrmBALocalDiagnoses.SetAddToCheckBoxStatus(ADiagnosis:string);
var
 selectedDX :string;
 i: integer;
 begin
 if (cbAddToPL.Checked or cbAddToPDList.Checked) then
 begin
    for i := 0 to LvDxGrid.Items.Count-1 do
    begin
       if(lvDxGrid.Items[i].Selected) then
       begin
          if StrPos(PChar(LvDxGrid.Items[i].Caption),PChar(ADD_TO_PERSONAL_DX_LIST)) <> nil then Exit;
          if StrPos(PChar(LvDxGrid.Items[i].Caption),PChar(ADD_TO_PROBLEM_LIST)) <> nil then Exit;
       end;
    end;
 end;

   if lvDxGrid.SelCount = 0 then
   begin
      ClearAndDisableCBoxes;
      Exit;
   end;
   selectedDX:= Piece(ADiagnosis,':',2);
   //** loop thru problem list dx, if match check box disabled
   if ProblemListDxFound(selectedDx) then
   begin
      cbAddToPL.Enabled := False;
      cbAddToPL.Checked := False;
   end
   else
   begin
      cbAddToPL.Enabled := True;
      cbAddToPL.Checked := False;
   end;

   if  PersonalListDxFound(selectedDx) then
   begin
      cbAddToPDList.Enabled  := False;
      cbAddToPDList.Checked  := False;
   end
   else
   begin
      cbAddToPDList.Enabled  := True;
      cbAddToPDList.Checked  := False;
   end;

end;

procedure TfrmBALocalDiagnoses.ProcessMultSelections;
var
 i: integer;
 selectedDX: string;
 PLFound, PDLFound: boolean;
begin
   PLFound  := False;
   PDLFound := False;
   for i := 0 to lvDxGrid.Items.Count-1 do
   begin
       if(lvDxGrid.Items[i].Selected) then
       begin
          selectedDX := lvDxGrid.Items[i].Subitems[1];
          selectedDX := Piece(selectedDX,':',2);
          if not PLFound then
             PLFound := ProblemListDxFound(selectedDX);
          if not PDLFound then
             PDLFound := PersonalListDXFound(selectedDX);
       end;
   end;
   if not PDLFound then
   begin
      cbAddToPDList.Enabled := True;
      cbAddTOPDList.Checked := False;
   end
   else
   begin
      cbAddToPDList.Enabled := False;
      cbAddTOPDList.Checked := False;
   end;
   if not PLFound then
   begin
      cbAddToPL.Enabled := True;
      cbAddToPL.Checked := False;
   end
   else
   begin
      cbAddToPL.Enabled := False;
      cbAddToPL.Checked := False;
   end;
end;

procedure TfrmBALocalDiagnoses.ClearAndDisableCBoxes;
begin
     cbAddToPL.Checked := False;
     cbAddToPDList.Checked := False;
     lvDxGrid.ClearSelection;
     cbAddToPL.Enabled := False;
     cbAddToPDList.Enabled := False;
end;

procedure TfrmBALocalDiagnoses.ResetCheckBoxStatus(pDxCode:string);
begin
 if Not ProblemListDxFound(pDxCode) then
    cbAddToPL.Enabled := True;
 if  Not PersonalListDxFound(pDxCode) then
    cbAddToPDList.Enabled  := True;
end;

procedure TfrmBALocalDiagnoses.DeleteSelectedDx;
var
  I: Integer;
begin
  frmBALocalDiagnoses.lvDxGrid.Items.BeginUpdate;
  try
    for I := frmBALocalDiagnoses.lvDxGrid.Items.Count - 1 downto 0 do
      if  frmBALocalDiagnoses.lvDxGrid.Items[I].Selected then
        frmBALocalDiagnoses.lvdxGrid.Items[I].delete;
  finally
    lvDxGrid.Items.EndUpdate;
  end;

end;


Initialization
  BADiagnosis        := TStringList.Create;
  currentOrderIDList := TStringList.Create;
  ProblemDxHoldList  := TStringList.Create;
  PersonalDxHoldList := TStringList.Create;
  lexIENHoldList     := TStringList.Create;
  BADiagnosis.Clear;
  currentOrderIDList.Clear;
  PersonalDxHoldList.Clear;
  ProblemDxHoldList.Clear;
  lexIENHoldList.Clear;

finalization
  FreeAndNil(BADiagnosis);
  FreeAndNil(currentOrderIDList);
  FreeAndNil(ProblemDxHoldList);
  FreeAndNil(PersonalDxHoldList);
  FreeAndNil(lexIENHoldList);

end.
