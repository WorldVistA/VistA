unit fEncounterFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tabs, ComCtrls, ExtCtrls, Menus, StdCtrls, Buttons, fPCEBase, fStandardCodes,
  fVisitType, fDiagnoses, fProcedure, fImmunization, fSkinTest, fPatientEd,
  fHealthFactor, fExam, uPCE, rPCE, rTIU, ORCtrls, ORFn, fEncVitals, rvitals, fBase508Form,
  VA508AccessibilityManager;

const
  //tab names
  CT_VisitNm = 'Visit Type';
  CT_DiagNm  = 'Diagnoses';
  CT_ProcNm  = 'Procedures';
  CT_ImmNm   = 'Immunizations';
  CT_SkinNm  = 'Skin Tests';
  CT_PedNm   = 'Patient Ed';
  CT_HlthNm  = 'Health Factors';
  CT_XamNm   = 'Exams';
  CT_VitNm   = 'Vitals';
  CT_GAFNm   = 'GAF';
  CT_STDNm   = 'Standard Codes';

  //numbers assigned to tabs to make changes easier
  //they must be sequential
  CT_NOPAGE        = -1;
  CT_UNKNOWN       = 0;
  CT_VISITTYPE     = 1; CT_FIRST = 1;
  CT_DIAGNOSES     = 2;
  CT_PROCEDURES    = 3;
  CT_IMMUNIZATIONS = 4;
  CT_SKINTESTS     = 5;
  CT_PATIENTED     = 6;
  CT_HEALTHFACTORS = 7;
  CT_EXAMS         = 8;
  CT_VITALS        = 9;
  CT_GAF           = 10;
  CT_STANDARDCODES = 11; CT_LAST = 11;

  NUM_TABS       = 3;
  TAG_VTYPE      = 10;
  TAG_DIAG       = 20;
  TAG_PROC       = 30;
  TAG_IMMUNIZ    = 40;
  TAG_SKIN       = 50;
  TAG_PED        = 60;
  TAG_HF         = 70;
  TAG_XAM        = 80;
  TAG_TRT        = 90;

  TX_NOSECTION = '-1^No sections found';
  TX_PROV_REQ = 'A primary encounter provider must be selected before encounter data can' + CRLF +
                'be saved.  Select the Primary Encounter Provider on the VISIT TYPE tab.' + CRLF +
                'Otherwise, press <Cancel> to quit without saving data.';

  TC_PROV_REQ = 'Missing Primary Provider for Encounter';

type
  TfrmEncounterFrame = class(TfrmBase508Form)
    StatusBar1: TStatusBar;
    pnlPage: TPanel;
    Bevel1: TBevel;
    TabControl: TTabControl;

    procedure tabPageChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormResize(Sender: TObject);
    procedure SectionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabControlChange(Sender: TObject);
    procedure TabControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormShow(Sender: TObject);
    procedure TabControlEnter(Sender: TObject);

  private
    FAutoSave: boolean;
    FSaveNeeded: boolean;
    FChangeSource: Integer;
    FCancel:  Boolean; //Indicates the cancel button has been pressed;
    FAbort: boolean; // indicates that neither OK or Cancel has been pressed
    FormList: TStringList;  //Holds the types of any forms that will be used
                            //in the frame.  They must be available at compile time
    FLastPage: TfrmPCEBase;
    FGiveMultiTabMessage: boolean;
    procedure CreateChildForms(Sender: TObject; Location: integer);
    procedure SynchPCEData;
    procedure SwitchToPage(NewForm: TfrmPCEBase);   //was tfrmPage
    function PageIDToForm(PageID: Integer): TfrmPCEBase;
    function PageIDToTab(PageID: Integer): string;
    procedure LoadFormList(Location: integer);
    procedure CreateForms;
    procedure AddTabs;
    function FormListContains(item: string): Boolean;
    function SendData: boolean;
    procedure UpdateEncounter(PCE: TPCEData);
    procedure SetFormFonts;
    procedure UMValidateMag(var Message: TMessage); message UM_VALIDATE_MAG;
  public
//    procedure savePCEVimmSubData;
//    procedure SynchPCEVimmSubData;
    procedure getCodesList(var tmpList: TStrings);
    procedure synchPCEVimmData(povList, cptList: TStringList);
    procedure SelectTab(NewTabName: string);
    property ChangeSource:    Integer read FChangeSource;
    property Forms:           tstringlist read FormList;
    property Cancel:          Boolean read FCancel write FCancel;
    property Abort:          Boolean read FAbort write FAbort;
  end;

var
  frmEncounterFrame: TfrmEncounterFrame;
  uSCCond:              TSCConditions;
  uVisitType:           TPCEProc;       // contains info for visit type page
  uEncPCEData: TPCEData;
  uProviders: TPCEProviderList;

// Returns true if PCE data still needs to be saved - vitals/gaf are always saved
function UpdatePCE(PCEData: TPCEData; KeepPrimaryProvider: boolean = FALSE): boolean;

implementation

uses
  uCore,
  fGAF, uConst,
  rCore, fPCEProvider, rMisc, VA508AccessibilityRouter, VAUtils,
  UResponsiveGUI, uWriteAccess, uInit;

{$R *.DFM}

{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmEncounterFrame.PageIDToTab(PageID: Integer): String;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: returns the tab index that corresponds to a given PageID .
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.PageIDToTab(PageID: Integer): String;
begin
  result := '';
  case PageID of
    CT_NOPAGE:        Result := '';
    CT_UNKNOWN:       Result := '';
    CT_VISITTYPE:     Result := CT_VisitNm;
    CT_DIAGNOSES:     Result := CT_DiagNm;
    CT_PROCEDURES:    Result := CT_ProcNm;
    CT_IMMUNIZATIONS: Result := CT_ImmNm;
    CT_SKINTESTS:     Result := CT_SkinNm;
    CT_PATIENTED:     Result := CT_PedNm;
    CT_HEALTHFACTORS: Result := CT_HlthNm;
    CT_EXAMS:         Result := CT_XamNm;
    CT_VITALS:        Result := CT_VitNm;
    CT_GAF:           Result := CT_GAFNm;
  end;
end;


//procedure TfrmEncounterFrame.savePCEVimmSubData;
//begin
//  if uEncPCEData = nil then exit;
//  if FormListContains(CT_DiagNm) then
//    uEncPCEData.SetDiagnoses(frmDiagnoses.lstCaptionList.ItemsStrings);
//  if FormListContains(CT_ProcNm) then
//    uEncPCEData.SetProcedures(frmProcedures.lstCaptionList.ItemsStrings);
//end;

{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmEncounterFrame.PageIDToForm(PageID: Integer): TfrmPCEBase;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: return the form name based on the PageID}
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.PageIDToForm(PageID: Integer): TfrmPCEBase;
begin
  case PageID of
    CT_VISITTYPE:     Result := frmVisitType;
    CT_DIAGNOSES:     Result := frmDiagnoses;
    CT_PROCEDURES:    Result := frmProcedures;
    CT_IMMUNIZATIONS: Result := frmImmunizations;
    CT_SKINTESTS:     Result := frmSkinTests;
    CT_PATIENTED:     Result := frmPatientEd;
    CT_HEALTHFACTORS: Result := frmHealthFactors;
    CT_EXAMS:         Result := frmExams;
    CT_VITALS:        Result := frmEncVitals;
    CT_GAF:           Result := frmGAF;
    CT_STANDARDCODES: Result := frmStandardCodes;
  else  //not a valid form
    result := frmPCEBase;
  end;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.CreatChildForms(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Finds out what pages to display, has the pages and tabs created.
///////////////////////////////////////////////////////////////////////////////}


procedure TfrmEncounterFrame.CreateChildForms(Sender: TObject; Location: integer);
begin
  //load FormList with a list of all forms to display.
  inherited;
  LoadFormList(Location);
  AddTabs;
  CreateForms;
end;



{///////////////////////////////////////////////////////////////////////////////
//Name: TfrmEncounterFrame.LoadFormList;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Loads Formlist with the forms to create, will be replaced by RPC call.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.LoadFormList(Location: integer);
begin
  //change this to an RPC in RPCE.pas
  FormList.clear;
  FormList.add(CT_VisitNm);
  FormList.add(CT_DiagNm);
  FormList.add(CT_ProcNm);
  formList.add(CT_VitNm);
  formList.add(CT_ImmNm);
  formList.add(CT_SkinNm);
  formList.add(CT_PedNm);
  formList.add(CT_HlthNm);
  formList.add(CT_XamNm);
  if MHClinic(Location) then
    formList.add(CT_GAFNm);
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmEncounterFrame.FormListContains(item: string): Boolean;
//Created: 12/06/98
//By: Robert Bott
//Location: ISL
//Description: Returns a boolean value indicating if a given string exists in
// the formlist.
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.FormListContains(item: string): Boolean;
begin
  result := false;
  if (FormList.IndexOf(item) <> -1 ) then
    result := true;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.CreateForms;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:  Creates all of the forms in the list.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.CreateForms;
var
  i: integer;
begin
  //could this be placed in a loop using PagedIdToTab & PageIDToFOrm & ?

  if FormListContains(CT_VisitNm) then
    frmVisitType  := TfrmVisitType.CreateLinked(pnlPage);
  if FormListContains(CT_DiagNm) then
    frmDiagnoses  := TfrmDiagnoses.CreateLinked(pnlPage);
  if FormListContains(CT_ProcNm) then
    frmProcedures := TfrmProcedures.CreateLinked(pnlPage);
  if FormListContains(CT_VitNm) then
    frmEncVitals := TfrmEncVitals.CreateLinked(pnlPage);
  if FormListContains(CT_ImmNm) then
    frmImmunizations := TfrmImmunizations.CreateLinked(pnlPage);
  if FormListContains(CT_SkinNm) then
    frmSkinTests := TfrmSkinTests.CreateLinked(pnlPage);
  if FormListContains(CT_PedNm) then
    frmPatientEd := TfrmPatientEd.CreateLinked(pnlPage);
  if FormListContains(CT_HlthNm) then
    frmHealthFactors := TfrmHEalthFactors.CreateLinked(pnlPage);
  if FormListContains(CT_XamNm) then
    frmExams := TfrmExams.CreateLinked(pnlPage);
  if FormListContains(CT_GAFNm) then
    frmGAF := TfrmGAF.CreateLinked(pnlPage);
  if FormListContains(CT_STDNm) then
    frmStandardCodes := TfrmStandardCodes.CreateLinked(pnlPage);
  //must switch based on caption, as all tabs may not be present.
  for i := CT_FIRST to CT_LAST do
  begin
    if Formlist.IndexOf(PageIdToTab(i)) <> -1 then
      PageIDToForm(i).Visible := (Formlist.IndexOf(PageIdToTab(i)) = 0);
  end;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: TfrmEncounterFrame.SwitchToPage(NewForm: tfrmPCEBase);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Brings the selected page to the front for display.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.SwitchToPage(NewForm: tfrmPCEBase);// was TfrmPage);
{ unmerge/merge menus, bring page to top of z-order, call form-specific OnDisplay code }
begin
  if (NewForm = nil) or (FLastPage = NewForm) then Exit;
  if Assigned(FLastPage) then
    FLastPage.Hide;
  FLastPage := NewForm;
//  KeyPreview := (NewForm = frmEncVitals);
  NewForm.DisplayPage;  // this calls BringToFront for the form
end;



{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.tabPageChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Finds the page, and calls SwithToPage to display it.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.tabPageChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
{ switches to form linked to NewTab }
var
  i: integer;
begin
//must switch based on caption, as all tabs may not be present.
for i := CT_FIRST to CT_LAST do
  begin
  With Formlist do
    if NewTab = IndexOf(PageIdToTab(i)) then
    begin
      PageIDToForm(i).show;
      SwitchToPage(PageIDToForm(i));
    end;
  end;
end;

{ Resize and Font-Change procedures --------------------------------------------------------- }

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormResize(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Resizes all windows when parent changes.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FormResize(Sender: TObject);
var
  i: integer;
begin
 for i := CT_FIRST to CT_LAST do
   if (FormList.IndexOf(PageIdToTab(i)) <> -1) then
     MoveWindow(PageIdToForm(i).Handle, 0, 0, pnlPage.ClientWidth, pnlpage.ClientHeight, true);
  self.repaint;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.AddTabs;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: adds a tab for each page that will be displayed
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.AddTabs;

var
  i: integer;
begin
  TabControl.Tabs.Clear;
  for I := 0 to (Formlist.count - 1) do
    TabControl.Tabs.Add(Formlist.Strings[i]);
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure UpdatePCE(PCEData: TPCEData);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: The main call to open the encounter frame and capture encounter
// information.
///////////////////////////////////////////////////////////////////////////////}
function UpdatePCE(PCEData: TPCEData; KeepPrimaryProvider: boolean = FALSE): boolean;
var
//  FontHeight,
//  FontWidth: Integer;
  AUser, PrimaryProvider: string;

begin
 if not WriteAccess(waEncounter, True) then
  begin
    Result := False;
    exit;
  end;
  if KeepPrimaryProvider and (PCEData.Providers.PrimaryIdx >= 0) then
    PrimaryProvider := PCEData.Providers.Strings[PCEData.Providers.PrimaryIdx]
  else
    PrimaryProvider := '';
  PCEData.PCEForNote(PCEData.NoteIEN); // VISTAOR-24269
  if (PCEData.Location = 0) and (PCEData.VisitCategory = #0) and (PCEData.VisitIEN = 0) then
  begin
    InfoDlg('You cannot edit this encounter because there is no visit associated with this note.',
      'Encounter Edit Error', mtError, [mbOK], mbOK);
    Result := False;
    exit;
  end;
  if (PrimaryProvider <> '') and (PCEData.Providers.PrimaryIdx < 0) then
    PCEData.Providers.Add(PrimaryProvider);

  frmEncounterFrame := TfrmEncounterFrame.Create(Application);
  try
    frmEncounterFrame.FAutoSave := True;

    uEncPCEData := PCEData;
    try
      if(uEncPCEData.Empty and ((uEncPCEData.Location = 0) or (uEncPCEData.VisitDateTime = 0)) and
        (not Encounter.NeedVisit)) then
        uEncPCEData.UseEncounter := TRUE;
      frmEncounterFrame.Caption := 'Encounter Form for ' + ExternalName(uEncPCEData.Location, 44) +
                                    '  (' + FormatFMDateTime('mmm dd,yyyy@hh:nn', uEncPCEData.VisitDateTime) + ')';
      uProviders.Assign(uEncPCEData.Providers);
      SetDefaultProvider(uProviders, uEncPCEData);
      AUser := IntToStr(uProviders.PendingIEN(FALSE));
      if(AUser <> '0') and (uProviders.IndexOfProvider(AUser) < 0) and
         AutoCheckout(uEncPCEData.Location) then
        uProviders.AddProvider(AUser, uProviders.PendingName(FALSE), FALSE);

      frmEncounterFrame.CreateChildForms(frmEncounterFrame, PCEData.Location);
      SetFormPosition(frmEncounterFrame);
      ResizeAnchoredFormToFont(frmEncounterFrame);
      //SetFormPosition(frmEncounterFrame);

      with frmEncounterFrame do
      begin
        SetRPCEncLocation(PCEData.Location);
        SynchPCEData;
        TabControl.Tabindex := 0;
        TabControlChange(TabControl);

        ShowModal;
        Result := FSaveNeeded;
      end;

      PCEData.PCEForNote(PCEData.NoteIEN); // VISTAOR-24268
      if KeepPrimaryProvider and (PrimaryProvider <> '') and
        (PCEData.Providers.PrimaryIdx < 0) then
      begin
        PCEData.Providers.Add(PrimaryProvider);
        Result := True;
      end;

    finally
      uEncPCEData := nil;
    end;

  finally
    // frmEncounterFrame.Free;   v22.11 (JD and SM)
    frmEncounterFrame.Release;
    frmEncounterFrame := nil;
  end;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: TfrmEncounterFrame.SectionClick(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Call the procedure apropriate for the selected tab
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.SectionClick(Sender: TObject);
begin
  with Sender as TListBox do case Tag of
  TAG_VTYPE:   if FormListContains(CT_VisitNm) then
               begin
                 with frmVisitType do
                   lstVTypeSectionClick(Sender);
               end;
  end;
end;

procedure EmptyProc(Dest: TStrings);
begin
  // used by Sync Standard Codes
end;
{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.SynchPCEData;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Synchronize any existing PCE data with what is displayed in the form.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.SynchPCEData;

  procedure InitList(AListBox: TORListBox);
  var
    DoClick: boolean;

  begin
    with AListBox do
    begin
      DoClick := TRUE;
      case Tag of
        TAG_VTYPE:   begin
                       if FormListContains(CT_VisitNm) then
                          ListVisitTypeSections(Items);
                       DoClick := AutoSelectVisit(PCERPCEncLocation);
                     end;
      end;
      if Items.Count > 0 then
      begin
        if DoClick then
        begin
          ItemIndex := 0;
          SectionClick(AListBox);
        end;
      end
      else Items.Add(TX_NOSECTION);
    end;
  end;

begin
  if FormListContains(CT_VisitNm) then
  with frmVisitType do
    begin
      InitList(frmVisitType.lstVTypeSection);                     // set up Visit Type page
      ListSCDisabilities(memSCDisplay.Lines);
      uSCCond := EligbleConditions(uEncPCEData);
      frmVisitType.fraVisitRelated.InitAllow(uSCCond);
    end;
  with uEncPCEData do                               // load any existing data from PCEData
  begin
    if FormListContains(CT_VisitNm) then
      frmVisitType.fraVisitRelated.InitRelated(uEncPCEData);
    if FormListContains(CT_DiagNm) then
      frmDiagnoses.InitTab(CopyDiagnoses, ListDiagnosisSections);
    if FormListContains(CT_ProcNm) then
      frmProcedures.InitTab(CopyProcedures, ListProcedureSections);
    if FormListContains(CT_ImmNm) then
      frmImmunizations.InitTab(CopyImmunizations,ListImmunizSections);
    if FormListContains(CT_SkinNm) then
      frmSkinTests.InitTab(CopySkinTests, ListSkinSections);
    if FormListContains(CT_PedNm) then
      frmPatientEd.InitTab(CopyPatientEds, ListPatientSections);
    if FormListContains(CT_HlthNm) then
      frmHealthFactors.InitTab(CopyHealthFactors, ListHealthSections);
    if FormListContains(CT_XamNm) then
      frmExams.InitTab(CopyExams, ListExamsSections);
    if FormListContains(CT_STDNm) then
      frmStandardCodes.InitTab(CopyStandardCodes, EmptyProc);
    uVisitType.Assign(VisitType);
    if FormListContains(CT_VisitNm) then
    with frmVisitType do
    begin
      MatchVType;
    end;
  end;
end;


procedure TfrmEncounterFrame.synchPCEVimmData(povList, cptList: TStringList);
var
i: integer;
str: string;
begin
  if FormListContains(CT_DiagNm) and (povList.Count >0) then
    begin
      for i := povList.Count -1 downto 0 do
        begin
          str := povList.Strings[i];
          if Piece(str, U, 1) = 'POV-' then
            frmDiagnoses.deleteFromList(str)
          else frmDiagnoses.addToList(str);
        end;
    end;
  if FormListContains(CT_ProcNm) and (cptList.Count >0) then
    begin
      for i := cptList.Count -1 downto 0 do
        begin
          str := cptList.Strings[i];
          if Piece(str, U, 1) = 'CPT-' then
            frmProcedures.deleteFromList(str)
          else frmProcedures.addToList(str);
        end;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
// Name: procedure TfrmEncounterFrame.FormDestroy(Sender: TObject);
// Created: Jan 1999
// By: Robert Bott
// Location: ISL
// Description: Free up objects in memory when destroying form.
///////////////////////////////////////////////////////////////////////////////

procedure TfrmEncounterFrame.FormDestroy(Sender: TObject);
begin
  FormList.Clear;
  FreeAndNil(uProviders);
  FreeAndNil(uVisitType);
  FreeAndNil(FormList);
  if (not uInit.TimedOut) and (not Application.Terminated) then
    TResponsiveGUI.ProcessMessages;
  inherited;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormCreate(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Create instances of the objects needed.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FormCreate(Sender: TObject);
begin
  uProviders := TPCEProviderList.Create;
  uVisitType := TPCEProc.create;
  //uVitalOld  := TStringList.create;
  //uVitalNew  := TStringList.create;
  FormList := TStringList.create;
  fCancel := False;
  FAbort := TRUE;
  SetFormFonts;
  FGiveMultiTabMessage := ScreenReaderSystemActive;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.SendData;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Send Data back to the M side sor storing.
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.SendData: boolean;
//send PCE data to the RPC
var
  GAFScore: integer;
  GAFDate: TFMDateTime;
  GAFStaff: Int64;
begin
  inherited;
  // do validation for vitals & anything else here
  Result := true;

  if(FormListContains(CT_GAFNm)) then
  begin
    frmGAF.GetGAFScore(GAFScore, GAFDate, GAFStaff);
    if(GAFScore > 0) then
      SaveGAFScore(GAFScore, GAFDate, GAFStaff);
  end;

  //PCE
  UpdateEncounter(uEncPCEData);
  with uEncPCEData do
  begin
    if FAutoSave then
      begin
        if not uEncPCEData.validateMagnitudeValues then
          begin
            result := false;
            exit;
          end;
        if not uEncPCEData.proceduresMissingProvider then
          begin
            ShowMessage('Each procedure must have a provider assign to it');
            result := false;
          end
        else result := Save;
      end
    else
      FSaveNeeded := TRUE;
  end;
  if Result then Close;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormCloseQuery(Sender: TObject;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Check to see if the Cancel button was pressed, if not, call
// procedure to send the data to the server.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);

const
  TXT_SAVECHANGES = 'Save Changes?';

var
  TmpPCEData: TPCEData;
  ask, ChangeOK: boolean;

begin
  ClearPostValidateMag(Self);
  CanClose := True;
  if(FAbort) then
  begin
  // TfrmProcedures, CheckSimilarNameOK is called by cboProvider.OnExit.
  // Because OnExit can be called during the InfoBox command below, in order to
  // check for a cancel condition in CheckSimilarNameOK we set FCancel to true
  // here, then reset it to the result of the InfoBox call.  If Cancel is then
  // set to false we call CheckSimilarNameOK below
    FCancel := True;
    FCancel := (InfoBox(TXT_SAVECHANGES, TXT_SAVECHANGES, MB_YESNO) = ID_NO);
  end;
  if FCancel then Exit;  //*KCM*

  if(uProviders.PrimaryIdx >= 0) then
    ask := TRUE
  else
  begin
    TmpPCEData := TPCEData.Create;
    try
      uEncPCEData.CopyPCEData(TmpPCEData);
      UpdateEncounter(TmpPCEData);
      ask := TmpPCEData.NeedProviderInfo;
    finally
      TmpPCEData.Free;
    end;
  end;
  if ask and (NoPrimaryPCEProvider(uProviders, uEncPCEData)) then
  begin
    InfoBox(TX_PROV_REQ, TC_PROV_REQ, MB_OK or MB_ICONWARNING);
    CanClose := False;
    Exit;
  end;

  uVisitType.Provider := uProviders.PrimaryIEN;  {RV - v20.1}

  if CanClose and FormListContains(CT_ProcNm) then
    begin
      CanClose := frmProcedures.OK2SaveProcedures;
      if not CanClose then
        begin
          tabPageChange(Self, FormList.IndexOf(CT_ProcNm), ChangeOK);
          SwitchToPage(PageIDToForm(CT_PROCEDURES));
          TabControl.TabIndex := FormList.IndexOf(CT_ProcNm);
        end;
    end;

   if TabControl.TabIndex = FormList.IndexOf(CT_GAFNm) then
    CanClose := frmGAF.CheckSimilarNameOK;

   if TabControl.TabIndex = FormList.IndexOf(CT_ProcNm) then
    CanClose := frmProcedures.CheckSimilarNameOK;


  if CanClose then CanClose := SendData;  //*KCM*

end;

procedure TfrmEncounterFrame.TabControlChange(Sender: TObject);
var
  i: integer;
begin
//must switch based on caption, as all tabs may not be present.
  if (sender as tTabControl).tabindex = -1 then exit;

  if TabControl.CanFocus and Assigned(FLastPage) and not TabControl.Focused then
    TabControl.SetFocus;  //CQ: 14845

  for i := CT_FIRST to CT_LAST do
  begin
    with Formlist do
      with sender as tTabControl do
        if Tabindex = IndexOf(PageIdToTab(i)) then
      begin
        PageIDToForm(i).show;
        SwitchToPage(PageIDToForm(i));
        Exit;
      end;
  end;
end;

procedure TfrmEncounterFrame.TabControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if(assigned(FLastPage)) then
    FLastPage.AllowTabChange(AllowChange);
end;

procedure TfrmEncounterFrame.UMValidateMag(var Message: TMessage);
begin
  HandlePostValidateMag(Message);
end;

procedure TfrmEncounterFrame.UpdateEncounter(PCE: TPCEData);
begin
  with PCE do
  begin
    if FormListContains(CT_VisitNm) then
    begin
      VisitType := uVisitType;
      frmVisitType.fraVisitRelated.GetRelated(uEncPCEData);
      Providers.Merge(uProviders);
    end;
    //ZZZZZZBELLC
    if FormListContains(CT_DiagNm) then
      SetDiagnoses(frmDiagnoses.lstCaptionList.ItemsStrings);
    if FormListContains(CT_ProcNm) then
     SetProcedures(frmProcedures.lstCaptionList.ItemsStrings);
    if FormListContains(CT_ImmNm) then
       SetImmunizations(frmImmunizations.lstCaptionList.ItemsStrings);
    if FormListContains(CT_SkinNm) then
       SetSkinTests(frmSkinTests.lstCaptionList.ItemsStrings);
    if FormListContains(CT_PedNm) then
      SetPatientEds(frmPatientEd.lstCaptionList.ItemsStrings);
    if FormListContains(CT_HlthNm) then
      SetHealthFactors(frmHealthFactors.lstCaptionList.ItemsStrings);
    if FormListContains(CT_XamNm) then
      SetExams(frmExams.lstCaptionList.ItemsStrings);
    if FormListContains(CT_STDNm) then
      SetStandardCodes(frmStandardCodes.lstCaptionList.ItemsStrings);
  end;
end;

procedure TfrmEncounterFrame.SelectTab(NewTabName: string);
var
  AllowChange: boolean;
begin
  if FormList <> nil then
  begin
    var idx := FormList.IndexOf(NewTabName);
    if idx <> -1 then
    begin
      AllowChange := True;
      tabControl.TabIndex := idx;
      tabPageChange(Self, tabControl.TabIndex, AllowChange);
    end;
  end;
end;

procedure TfrmEncounterFrame.TabControlEnter(Sender: TObject);
begin
  if FGiveMultiTabMessage then // CQ#15483
  begin
    FGiveMultiTabMessage := FALSE;
    GetScreenReader.Speak('Multi tab form');
  end;
end;

procedure TfrmEncounterFrame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  CanChange: boolean;
begin
  inherited;
  if (Key = VK_ESCAPE) then
  begin
    Key := 0;
    FLastPage.btnCancel.Click;
  end
  else if Key = VK_TAB then
  begin
    if ssCtrl in Shift then
    begin
      CanChange := True;
      if Assigned(TabControl.OnChanging) then
        TabControl.OnChanging(TabControl, CanChange);
      if CanChange then
      begin
        if ssShift in Shift then
        begin
          if TabControl.TabIndex < 1 then
            TabControl.TabIndex := TabControl.Tabs.Count -1
          else
            TabControl.TabIndex := TabControl.TabIndex - 1;
        end
        else
          TabControl.TabIndex := (TabControl.TabIndex + 1) mod TabControl.Tabs.Count;
        if Assigned(TabControl.OnChange) then
          TabControl.OnChange(TabControl);
      end;
      Key := 0;
    end;
  end;
end;

procedure TfrmEncounterFrame.SetFormFonts;
var
  NewFontSize: integer;
begin
  NewFontSize := MainFontsize;
  if FormListContains(CT_VisitNm) then
    frmVisitType.Font.Size := NewFontSize;
  if FormListContains(CT_DiagNm) then
    frmDiagnoses.Font.Size := NewFontSize;
  if FormListContains(CT_ProcNm) then
    frmProcedures.Font.Size := NewFontSize;
  if FormListContains(CT_ImmNm) then
    frmImmunizations.Font.Size := NewFontSize;
  if FormListContains(CT_SkinNm) then
    frmSkinTests.Font.Size := NewFontSize;
  if FormListContains(CT_PedNm) then
    frmPatientEd.Font.Size := NewFontSize;
  if FormListContains(CT_HlthNm) then
    frmHealthFactors.Font.Size := NewFontSize;
  if FormListContains(CT_XamNm) then
    frmExams.Font.Size := NewFontSize;
  if FormListContains(CT_VitNm) then
    frmEncVitals.Font.Size := NewFontSize;
  if FormListContains(CT_GAFNm) then
    frmGAF.SetFontSize(NewFontSize);
  if FormListContains(CT_STDNm) then
    frmStandardCodes.SetFontSize(NewFontSize);
end;

procedure TfrmEncounterFrame.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;

procedure TfrmEncounterFrame.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  //CQ4740
  if NewWidth < 200 then
     begin
     NewWidth := 200;
     Resize := false;
     end;
end;

procedure TfrmEncounterFrame.FormShow(Sender: TObject);
begin
  inherited;
  if TabControl.CanFocus then
    TabControl.SetFocus;
end;

procedure TfrmEncounterFrame.getCodesList(var tmpList: TStrings);
var
i: integer;
APCEProc: TPCEProc;
APCEITem: TPCEItem;
tmp: String;
begin
  if FormListContains(CT_DiagNm) then
    begin
      for i := 0 to frmDiagnoses.lstCaptionList.Items.Count - 1 do
        begin
          APCEItem := TPCEItem(frmDiagnoses.lstCaptionList.Objects[i]);
          tmp := 'POV^'+ APCEitem.Code + '^^' + APCEItem.Narrative;
          tmpList.Add(tmp);
        end;
    end;
  if FormListContains(CT_ProcNm) then
    begin
      for i := 0 to frmProcedures.lstCaptionList.Items.Count - 1 do
        begin
          APCEProc := TPCEProc(frmProcedures.lstCaptionList.Objects[i]);
          tmp := 'CPT^'+ APCEProc.Code + '^^' + APCEProc.Narrative + '^' + IntToStr(APCEProc.Quantity);
          tmpList.Add(tmp);
        end;
    end;
end;

end.
