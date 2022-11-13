unit fBAOptionsDiagnoses;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, ExtCtrls, ORFn, UCore, RCore, ORNet,
  UBAGlobals, fPCELex, rPCE, Buttons, UBACore, UBAMessages, UBAConst,
  ComCtrls, VA508AccessibilityManager;

type
  TfrmBAOptionsDiagnoses = class(TfrmAutoSz)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    pnlBottom: TPanel;
    btnOther: TButton;
    btnOK: TButton;
    Panel3: TPanel;
    lbSections: TORListBox;
    Panel4: TPanel;
    lbDiagnosis: TORListBox;
    Panel5: TPanel;
    lbPersonalDx: TORListBox;
    pnlTop: TPanel;
    Panel7: TPanel;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    Splitter5: TSplitter;
    Button1: TButton;
    StaticText3: TStaticText;
    hdrCntlDx: THeaderControl;
    hdrCntlDxSections: THeaderControl;
    hdrCntlDxAdd: THeaderControl;
    procedure FormCreate(Sender: TObject);
    procedure btnOtherClick(Sender: TObject);
    procedure lbSectionsClick(Sender: TObject);
    procedure lbSectionsEnter(Sender: TObject);
    procedure lbDiagnosisClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lbDiagnosisChange(Sender: TObject);
    procedure lbPersonalDxClick(Sender: TObject);
    procedure lbDiagnosisEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function  IsDXInList(ADXCode: string):boolean;
    procedure LoadPersonalDxList;
    procedure btnRemoveAllClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure hdrCntlDxSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure LoadEncounterDx;
    procedure ListDiagnosesSections(Dest: TStrings);
    procedure AddProblemsToDxList;
    procedure ListDiagnosesCodes(Section: String);
    procedure InactiveICDNotification;
    procedure SyncDxDeleteList;
    procedure SyncDxNewList;
  
  public
    { Public declarations }
  end;

var

  uAddToP       : integer;
  uDeleteFromPDL: integer;
  uNewDxList    : TStringList;
  Problems      : TStringList;
  DxList        : TStringList;
  ECFDiagnoses  : TStringList;
  tmplst        : TStringList;
  newDxLst      : TStringList;
  delDxLst      : TStringList;
  inactiveCodes : integer;

procedure DialogOptionsDiagnoses(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

{$R *.dfm}

uses
	VAUtils;

var

  LastDFN      : string;
  LastLocation : integer;
  FDxSection: string;
  BADxCode: String;

procedure DialogOptionsDiagnoses(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
var
 frmBAOptionsDiagnoses: TfrmBAOptionsDiagnoses;
 begin
 frmBAOptionsDiagnoses := TfrmBAOptionsDiagnoses.Create(Application);
  actiontype := 0;
  with frmBAOptionsDiagnoses do
   begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmBAOptionsDiagnoses);
      ShowModal;
   end;

end;

procedure TfrmBAOptionsDiagnoses.FormCreate(Sender: TObject);
begin
    inactiveCodes := 0;
    LoadEncounterDx;
    ListDiagnosesSections(lbSections.Items);
  //  lbPersonalDx.Items := rpcGetPersonalDxList(User.DUZ);
    LoadPersonalDxList;
    btnOK.Enabled := False;
    hdrCntlDx.Sections[0].Width := lbPersonalDX.Width;
    hdrCntlDxSections.Sections[0].Width := lbSections.Width;
    hdrCntlDxAdd.Sections[0].Width := lbDiagnosis.Width;
  //  lbPersonalDx.Sorted := false;
 //  lbPersonalDx.Sorted := True;
    lbPersonalDX.Repaint;
end;


procedure  TfrmBAOptionsDiagnoses.LoadEncounterDx;
{ load the major coding lists that are used by the encounter form for a given location }
var
  i: integer;
  TempList: TStringList;
  EncDt: TFMDateTime;
begin
 Caption := 'Personal Diagnoses List for ' + User.Name;
 LastLocation := Encounter.Location;
 EncDt := Trunc(FMToday);
  //add problems to the top of diagnoses.
  TempList := TstringList.Create;
  DxList.clear;
  CallVistA('ORWPCE DIAG',  [LastLocation, EncDt],TempList);
  DxList.add(templist.strings[0]);
  AddProblemsToDxList;
    for i := 1 to (TempList.Count-1) do
    begin
      DxList.add(Templist.strings[i]);
    end;
end;

procedure  TfrmBAOptionsDiagnoses.ListDiagnosesSections(Dest: TStrings);
var
  i: Integer;
  x: string;
begin
  for i := 0 to DxList.Count - 1 do if CharAt(DxList[i], 1) = U then
  begin
    x := Piece(DxList[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(DxList[i], U, 2) + U + x);
  end;
end;

procedure TfrmBAOptionsDiagnoses.ListDiagnosesCodes(Section: String);
var
i,j: integer;
a: string;
begin
   lbDiagnosis.Clear;
   a := '';
   for i := 0 to DxList.Count-1 do
      begin
         a := DxList.Strings[i];
         if Piece(DxList[i], U, 2) = (Piece(Section,U,2)) then
            break;
     end;
     inc(i);
     for j := i to DxList.Count-1 do
     begin
        if Piece(DxList[j], U, 0) = '' then
           break
        else
        begin
           a :=  Piece(DxList[j], U, 2) + '^' + Piece(DxList[j], U, 1);
           if not UBACore.IsICD9CodeActive(Piece(a,U,2),'ICD',Encounter.DateTime) then
           begin
              a := a + '    ' + UBAConst.BA_INACTIVE_CODE;
              inc(inactiveCodes);
           end;
           lbDiagnosis.Items.Add(a);
        end;
     end;
end;

procedure TfrmBAOptionsDiagnoses.AddProblemsToDxList;
var
  i : integer;
  EncDt: TFMDateTime;
  x : String;
begin
   //Get problem list
   EncDt := Trunc(FMToday);
   LastDFN := Patient.DFN;
   CallVistA('ORWPCE ACTPROB', [Patient.DFN, EncDT],Problems);
   if Problems.Count > 0 then
   begin
      DxList.add('^Problem List Items');
      for i := 1 to (Problems.count-1) do
      begin
         x :=(Piece(Problems.Strings[i],U,3) + U +
          Piece(Problems.Strings[i],U,2));
       //  if (Piece(Problems.Strings[i],U,3) = '799.9') then continue;            // DON'T INCLUDE 799.9 CODES

         if (Piece(problems.Strings[i], U, 11) =  '#') then
           DxList.add(Piece(Problems.Strings[i],U,3) + U +                   // PL code inactive
            Piece(Problems.Strings[i],U,2) + U + '#')
         else if (Piece(problems.Strings[i], U, 10) =  '') then                  // no inactive date for code
           DxList.add(Piece(Problems.Strings[i],U,3) + U +
             Piece(Problems.Strings[i],U,2))
         else if (Trunc(StrToFloat(Piece(Problems.Strings[i], U, 10))) > EncDT) then     // code active as of EncDt
           DxList.add(Piece(Problems.Strings[i],U,3) + U +
             Piece(Problems.Strings[i],U,2))
         else
           DxList.add(Piece(Problems.Strings[i],U,3) + U +                   // PL code inactive
             Piece(Problems.Strings[i],U,2) + U + '#');
    end;
  end;
end;

procedure  TfrmBAOptionsDiagnoses.btnOtherClick(Sender: TObject);
 var
  Match: string;
  SelectedList : TStringList;
  lexIEN: string;
begin
 inherited;
  BAPersonalDX := True;
  SelectedList := TStringList.Create;
  if Assigned (SelectedList) then SelectedList.Clear;
  BADxCode := ''; //init
   //Execute LEXICON
  LexiconLookup(Match, LX_ICD);
  if Match = '' then Exit;
  if strLen(PChar(Piece(Match, U, 3)))> 0 then
     lexIEN := Piece(Match, U, 3);

  BADxCode := Piece(Match,U,2) + '  ' + Piece(Match, U, 1);
  if IsDXInList(Piece(Match,U,1) ) then Exit; // eliminate duplicates
  if UBACore.IsICD9CodeActive(Piece(Match,U,1),'ICD',Encounter.DateTime) then
  begin
     lbPersonalDx.Items.Add(BADxCode);
     if strLen(PChar(lexIEN)) > 0 then
        newDxLst.Add(Piece(Match,U,1) + U + lexIEN)
     else
        newDxLst.Add(Piece(Match,U,1));
  end
  else
     InfoBox(BA_INACTIVE_ICD9_CODE_1 + BADxCode + BA_INACTIVE_ICD9_CODE_2 , BA_INACTIVE_CODE, MB_ICONWARNING or MB_OK);

  lexIEN := '';
  BAPersonalDX := False;
  if newDxLst.Count > 0 then btnOK.Enabled := True;
end;

procedure TfrmBAOptionsDiagnoses.lbSectionsClick(Sender: TObject);
var i: integer;
begin
 inherited;
for i := 0 to lbSections.Items.Count-1 do
begin
    if(lbSections.Selected[i]) then
    begin
       ListDiagnosesCodes(lbSections.Items[i]);
       FDXSection := lbSections.Items[i];
       Break;
    end;
 end;
end;

procedure TfrmBAOptionsDiagnoses.lbSectionsEnter(Sender: TObject);
begin
  inherited;
   lbSections.Selected[0] := true;
end;

procedure TfrmBAOptionsDiagnoses.lbDiagnosisClick(Sender: TObject);
var
 i : integer;
  newDxCodes: TStringList;
  selectedCode: String;
begin
  inherited;
  newDxCodes := TStringList.Create;
  newDxCodes.Clear;
  for i := 0 to lbDiagnosis.Items.Count-1 do
  begin
        if(lbDiagnosis.Selected[i]) then
        begin
           selectedCode := Piece(lbDiagnosis.Items[i],U,2);
           newDxCodes.Add(selectedCode);
        end;
        if newDxCodes.Count > 0 then
        begin
           rpcAddToPersonalDxList(User.DUZ,NewDxCodes);
           NewDxCodes.Clear;
           lbPersonalDx.Items := rpcGetPersonalDxList(User.DUZ);
        end;
  end;
end;

procedure TfrmBAOptionsDiagnoses.btnCancelClick(Sender: TObject);
begin
  inherited;
        Close;
end;

procedure TfrmBAOptionsDiagnoses.btnOKClick(Sender: TObject);
begin
  inherited;
  if delDxLst.Count > 0 then
  begin
     //  delete selected dx's
     rpcDeleteFromPersonalDxList(User.DUZ,delDxLst);
     delDxLst.Clear;
  end;

  if newDxLst.Count > 0 then
  begin
     newDxLst.Sort;
     newDxLst.Duplicates := dupIgnore;
      //  add selected dx's
     rpcAddToPersonalDxList(User.DUZ,newDxLst);
     newDxLst.Clear;
  end;
  Close;
end;

procedure TfrmBAOptionsDiagnoses.btnAddClick(Sender: TObject);
var
 i : integer;
  newDxCode: string;

begin
  inherited;
  for i := 0 to lbDiagnosis.Items.Count-1 do
  begin
     if(lbDiagnosis.Selected[i]) then
     begin
         newDxCode := Piece(lbDiagnosis.Items[i],U,2);
        if (not IsDxInList(newDxCode) ) then
         begin
              if UBACore.IsICD9CodeActive(newDxCode,'ICD',Encounter.DateTime) then
              begin
                 newDxLst.Add(newDxCode);
                 lbPersonalDx.Items.Add(Piece(lbDiagnosis.Items[i],U,2) + U + Piece(lbDiagnosis.Items[i],U,1) )
              end
              else
                 InfoBox(BA_INACTIVE_ICD9_CODE_1 + Trim(Piece(newDxCode,'#',1)) + BA_INACTIVE_ICD9_CODE_2 , BA_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
        end;
     end;
  end;
     btnAdd.Enabled := False;
     lbDiagnosis.ClearSelection;
     if newDxLst.Count > 0 then btnOK.Enabled := True;
end;

procedure TfrmBAOptionsDiagnoses.btnDeleteClick(Sender: TObject);
var
   i, c: integer;
begin
  inherited;
  SyncDxDeleteList;
  SyncDxNewList;
 // delete selected dx from listbox.
 with lbPersonalDX do
 begin
    i := Items.Count - 1;
    c := SelCount;
    Items.BeginUpdate;
    while (i >= 0) and (c > 0) do
    begin
       if Selected[i] = true then
       begin
          Dec(c);
          Items.Delete(i);
       end;
       Dec(i);
    end;
    Items.EndUpdate;
 end;

 btnDelete.Enabled := False;
 lbDiagnosis.ClearSelection;
 if delDxLst.Count > 0 then btnOK.Enabled := True;
end;

procedure TfrmBAOptionsDiagnoses.lbDiagnosisChange(Sender: TObject);
begin
  inherited;
 if lbDiagnosis.Count = 0 then
    btnAdd.Enabled := False
 else
 begin
    if (lbDiagnosis.SelCount > 0) then
       btnAdd.Enabled := True
    else
       btnAdd.Enabled := False;
 end;
end;

procedure TfrmBAOptionsDiagnoses.lbPersonalDxClick(Sender: TObject);
var i : integer;
begin
  inherited;
   for i := 0 to lbPersonalDX.Count-1 do
   begin
     if(lbPersonalDX.Selected[i]) then
     begin
        btnDelete.Enabled := True;
        break;
     end
     else
        btnDelete.Enabled := False;
  end;
end;

procedure TfrmBAOptionsDiagnoses.lbDiagnosisEnter(Sender: TObject);
begin
  inherited;
if lbDiagnosis.Count > 0 then
     lbDiagnosis.Selected[0] := true;
end;

procedure TfrmBAOptionsDiagnoses.FormShow(Sender: TObject);
begin
  inherited;
   if lbSections.Count > 0 then
      ListDiagnosesCodes(lbSections.Items[0]);
   lbSections.SetFocus;
end;

procedure TfrmBAOptionsDiagnoses.Button1Click(Sender: TObject);
begin
  inherited;
   newDxLst.Clear;
   Close;
end;

procedure TfrmBAOptionsDiagnoses.InactiveICDNotification;
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


procedure TfrmBAOptionsDiagnoses.FormActivate(Sender: TObject);
begin
  inherited;
  InactiveICDNotification;
end;

function  TfrmBAOptionsDiagnoses.IsDXInList(ADXCode: string):boolean;
var
 i: integer;
 //x,y: string;
begin
     Result := False;
     for i := 0 to lbPersonalDx.Count-1 do
        if ADXCode = Piece(lbPersonalDx.Items[i],U,1) then
        begin
           Result := True;
           Break;
        end;
end;


procedure TfrmBAOptionsDiagnoses.LoadPersonalDxList;
var
 i: integer;
 dxList: TStringList;
 inActiveDx: string;
begin
  dxList := TStringList.Create;
  dxList.Clear;
  dxList := rpcGetPersonalDxList(User.DUZ);
  if dxList.Count > 0 then
  begin
     for i := 0 to dxList.Count -1 do
     begin
        if not UBACore.IsICD9CodeActive(Piece(dxList.Strings[i],U,1),'ICD',Encounter.DateTime ) then
        begin
           inActiveDx := Piece(dxList.Strings[i],U,1)  + '  ' + BA_INACTIVE_CODE + U + Piece(DxList.Strings[i],U,2);
           lbPersonalDx.Items.Add(inActiveDx);
        end
        else
           lbPersonalDx.Items.Add(dxList.Strings[i]);
     end;
  end;
end;

procedure TfrmBAOptionsDiagnoses.btnRemoveAllClick(Sender: TObject);
var
  i: integer;
  delDxCode: string;
begin
  inherited;
 // save dx seleted for deletion, update file when ok is pressed
  for i := 0 to lbPersonalDX.Count-1 do
  begin
     delDxCode := Piece(lbPersonalDX.Items[i],U,1);
     delDxLst.Add(delDxCode);
  end;


 // delete selected dx from listbox.
 with lbPersonalDX do
 begin
    i := Items.Count - 1;
    Items.BeginUpdate;
    while (i >= 0)  do
    begin
       Items.Delete(i);
       Dec(i);
    end;
    Items.EndUpdate;
 end;

 btnDelete.Enabled := False;
 lbDiagnosis.ClearSelection;
 if delDxLst.Count > 0 then btnOK.Enabled := True;
end;

procedure TfrmBAOptionsDiagnoses.btnAddAllClick(Sender: TObject);
var
 i : integer;
  newDxCode: string;

begin
  inherited;
  for i := 0 to lbDiagnosis.Items.Count-1 do
  begin
     newDxCode := Piece(lbDiagnosis.Items[i],U,2);
     if (not IsDxInList(newDxCode) ) then
     begin
        if UBACore.IsICD9CodeActive(newDxCode,'ICD',Encounter.DateTime) then
        begin
           newDxLst.Add(newDxCode);
           lbPersonalDx.Items.Add(Piece(lbDiagnosis.Items[i],U,2) + U + Piece(lbDiagnosis.Items[i],U,1) )
        end
        else
           InfoBox(BA_INACTIVE_ICD9_CODE_1 + Trim(Piece(newDxCode,'#',1)) + BA_INACTIVE_ICD9_CODE_2 , BA_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
        end;
  end;
     btnAdd.Enabled := False;
     lbDiagnosis.ClearSelection;
     if newDxLst.Count > 0 then btnOK.Enabled := True;

end;

procedure TfrmBAOptionsDiagnoses.hdrCntlDxSectionClick(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  lbPersonalDx.Sorted := false;
  lbPersonalDx.Sorted := True;
  lbPersonalDX.Repaint;
end;

procedure TfrmBAOptionsDiagnoses.FormResize(Sender: TObject);
begin
  inherited;
  hdrCntlDxSections.Sections[0].Width := lbSections.Width;
  hdrCntlDxAdd.Sections[0].Width :=  lbDiagnosis.Width;
  hdrCntlDx.Sections[0].Width := lbPersonalDx.Width;
end;

procedure TfrmBAOptionsDiagnoses.SyncDxDeleteList;
var
 i: integer;
 delDxCode: string;
begin
// save dx selected for deletion, update file when ok is pressed
  for i := 0 to lbPersonalDX.Count-1 do
  begin
     if(lbPersonalDX.Selected[i]) then
     begin
        delDxCode := Piece(lbPersonalDX.Items[i],U,1);
        delDxLst.Add(delDxCode);
     end;
 end;
end;

procedure TfrmBAOptionsDiagnoses.SyncDxNewList;
var
i,j :integer;
begin
 // remove diagnoses selected for deletion from newdxList;
   for i := 0 to lbPersonalDX.Count-1 do
   begin
      if lbPersonalDX.Selected[i] then
      begin
        for j := 0 to newDxLst.Count-1 do
        begin
           if (Piece(lbPersonalDX.Items[i],U,1)) = (newDxLst.Strings[j]) then
           begin
              newDxLst.Delete(j);
              Break;
           end;
        end;
     end;
  end;
end;


initialization
  uAddToPDL := 0;
  uDeleteFromPDL := 0;

  Problems     := TStringList.Create;
  DxList       := TStringList.Create;
  ECFDiagnoses := TStringList.Create;
  uNewDxList   := TStringList.Create;
  tmplst       := TStringList.Create;
  newDxLst     := TStringList.Create;
  delDxLst     := TStringList.Create;

  Problems.Clear;
  DxList.Clear;
  ECFDiagnoses.Clear;
  uNewDxList.Clear;
  tmplst.Clear;
  newDxLst.Clear;
  delDxLst.Clear;

finalization
  FreeAndNil(Problems);
  FreeAndNil(DxList);
  FreeAndNil(ECFDiagnoses);
  FreeAndNil(uNewDxList);
  FreeAndNil(tmplst);
  FreeAndNil(newDxLst);
  FreeAndNil(delDxLst);

end.
