unit fNoteProps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORDtTm, ORCtrls, ExtCtrls, rTIU, uConst, uTIU, ORFn, ORNet,
  ComCtrls, Buttons, fBase508Form, VA508AccessibilityManager;

type
  {This object holds a List of Actions as Returned VIA the RPCBroker}
  TPRFActions = class(TObject)
  private
    FPRFActionList : TStringList;
  public
    //procedure to show the Action in a ListView, requires a listview parameter
    procedure ShowActionsOnList(DisplayList : TCaptionListView);
    //procedure to load the actions, this will call the RPC
    procedure Load(TitleIEN : Int64; DFN : String);
    //returns true if the Action at the Index passed is associated with a note
    function SelActionHasNote(lstIndex : integer) : boolean;
    //return the Action IEN at the Index passed
    function GetActionIEN(lstIndex : integer) : String;
    //return the PRF IEN at the Index passed
    function GetPRF_IEN(lstIndex : integer) : integer;
    constructor Create();
    destructor Destroy(); override;
  end;

  TfrmNoteProperties = class(TfrmBase508Form)
    lblNewTitle: TLabel;
    cboNewTitle: TORComboBox;
    lblDateTime: TLabel;
    calNote: TORDateBox;
    lblAuthor: TLabel;
    cboAuthor: TORComboBox;
    lblCosigner: TLabel;
    cboCosigner: TORComboBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlConsults: TORAutoPanel;
    bvlConsult: TBevel;
    cboProcSummCode: TORComboBox;
    lblProcSummCode: TOROffsetLabel;
    calProcDateTime: TORDateBox;
    lblProcDateTime: TOROffsetLabel;
    pnlPRF: TORAutoPanel;
    lblPRF: TLabel;
    Bevel1: TBevel;
    lvPRF: TCaptionListView;
    pnlSurgery: TORAutoPanel;
    bvlSurgery: TBevel;
    lblSurgery1: TStaticText;
    lblSurgery2: TStaticText;
    lstSurgery: TCaptionListView;
    pnlCTop: TPanel;
    pnlCButtons: TPanel;
    pnlCText: TPanel;
    lblConsult1: TLabel;
    lblConsult2: TLabel;
    btnShowList: TButton;
    btnDetails: TButton;
    lstRequests: TCaptionListView;
    procedure FormShow(Sender: TObject);
    procedure cboNewTitleNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure NewPersonNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboNewTitleExit(Sender: TObject);
    procedure cboNewTitleMouseClick(Sender: TObject);
    procedure cboNewTitleEnter(Sender: TObject);
    procedure cboCosignerExit(Sender: TObject);
    procedure cboAuthorExit(Sender: TObject);
    procedure cboAuthorMouseClick(Sender: TObject);
    procedure cboAuthorEnter(Sender: TObject);
    procedure cboNewTitleDropDownClose(Sender: TObject);
    procedure cboNewTitleDblClick(Sender: TObject);
    procedure cboCosignerNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure btnShowListClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure calNoteEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure CaptionListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    FIsNewNote : Boolean;     // Is set at the begining of the function: ExecuteNoteProperties
    FCosignIEN: Int64;      // store cosigner that was passed in
    FCosignName: string;    // store cosigner that was passed in
    FDocType: Integer;      // store document type that was passed in
    FAddend: Integer;       // store IEN of note being addended (if make addendum)
    FLastAuthor: Int64;     // set by mouseclick to avoid redundant call on exit
    FLastTitle: Integer;    // set by mouseclick to avoid redundant call on exit
    //FFixCursor: Boolean;    // to fix the problem where the list box is an I-bar
   // FLastCosigner: Int64;      // holds cosigner from previous note (for defaulting)
   // FLastCosignerName: string; // holds cosigner from previous note (for defaulting)
    FCallingTab: integer;
    FIDNoteTitlesOnly: boolean;
    FToday: string;
    FClassName: string;
    FIsClinProcNote: boolean;
    FProcSummCode: integer;
    FProcDateTime: TFMDateTime;
    FCPStatusFlag: integer;
    FPRFActions : TPRFActions;
    FStarting: boolean;
    procedure SetCosignerRequired(DoSetup: boolean);
    procedure FormatRequestList;
    procedure ShowRequestList(ShouldShow: Boolean);
    procedure ShowSurgCaseList(ShouldShow: Boolean);
    procedure ShowPRFList(ShouldShow: Boolean);
    procedure ShowClinProcFields(YesNo: boolean);
    procedure SetGenericFormSize;
    procedure UMDelayEvent(var Message: TMessage); message UM_DELAYEVENT;
  public
    { Public declarations }

  end;


function ExecuteNoteProperties(var ANote: TEditNoteRec; CallingTab: integer; IDNoteTitlesOnly,
          IsNewIDEntry: boolean; AClassName: string; CPStatusFlag: integer): Boolean;

const

 TX_USER_INACTIVE     = 'This entry can be selected, however their system account has been' +CRLF +
                        ' temporarily inactivated and that person should be contacted to resolve the issue.';

 TC_INACTIVE_USER     = 'Inactive User Alert';

 PIXEL_SPACE = 6;

implementation

{$R *.DFM}

uses uCore, rCore, rConsults, uConsults, rSurgery, fRptBox, VA508AccessibilityRouter;

{ Initial values in ANote

                  Title  Type    Author  DateTime  Cosigner  Location  Consult  NeedCPT
     New Note      dflt     3      DUZ      NOW      dflt      Encnt      0        ?
     New DCSumm    dflt   244      DUZ      NOW      dflt      Encnt      0        ?
    Edit Note      ien      3      ien     DtTm       ien       ien      ien      fld
    Edit DCSumm    ien    244      ien     DtTm       ien       ien      ien      fld
  Addend Note      ien     81      DUZ      NOW        0        N/A      N/A?      no
  Addend DCSumm    ien     81      DUZ      NOW        0        N/A      N/A?      no

  New Note - setup as much as possible, then call ExecuteNoteProperties if necessary.

}

const
  TX_CP_CAPTION        = 'Clinical Procedure Document Properties';
  TX_CP_TITLE          = 'Document Title:';
  TX_SR_CAPTION        = 'Surgical Report Properties';
  TX_SR_TITLE          = 'Report Title:';
  TC_REQ_FIELDS        = 'Required Information';
  TX_REQ_TITLE         = CRLF + 'A title must be selected.';
  TX_REQ_AUTHOR        = CRLF + 'The author of the note must be identified.';
  TX_REQ_REFDATE       = CRLF + 'A valid date/time for the note must be entered.';
  TX_REQ_COSIGNER      = CRLF + 'A cosigner must be identified.';
  TX_REQ_REQUEST       = CRLF + 'This title requires the selection of an associated consult request.';
  TX_REQ_SURGCASE      = CRLF + 'This title requires the selection of an associated surgery case.';
  TX_REQ_PRF_ACTION    = CRLF + 'Notes of this title require the selection of a patient record flag action.';
  TX_REQ_PRF_NOTE      = CRLF + 'This action has already been assigned to another note.';
  TX_NO_FUTURE         = CRLF + 'A reference date/time in the future is not allowed.';
  TX_COS_SELF          = CRLF + 'You cannot make yourself a cosigner.';
  TX_COS_AUTH          = CRLF + ' is not authorized to cosign this document.';
  TX_REQ_PROCSUMMCODE  = CRLF + 'A procedure summary code for this procedure must be entered.';
  TX_REQ_PROCDATETIME  = CRLF + 'A valid date/time for the procedure must be entered.';
  TX_INVALID_PROCDATETIME = CRLF + 'If entered, the date/time for the procedure must be in a valid format.';
  TX_NO_PROC_FUTURE    = CRLF + 'A procedure date/time in the future is not allowed.';
  TX_NO_TITLE_CHANGE   = 'Interdisciplinary entries may not have their titles changed.';
  TC_NO_TITLE_CHANGE   = 'Title Change Not Allowed';
  TX_NO_NEW_SURGERY    = 'New surgery reports can only be entered via the Surgery package.';
  TC_NO_NEW_SURGERY    = 'Choose another title';
  TX_UNRESOLVED_CONSULTS = 'You currently have consults awaiting resolution for this patient.' + CRLF +
                           'Would you like to see a list of these consults?';
  TX_ONE_NOTE_PER_VISIT1  = 'There is already a ';
  TX_ONE_NOTE_PER_VISIT2  = CRLF + 'Only ONE record of this type per Visit is allowed...'+
                            CRLF + CRLF + 'You can addend the existing record.';


  ACTIVE_STATUS = 'ACTIVE,PENDING,SCHEDULED';

  PRF_LABEL = 'Which Patient Record Flag Action should this Note be linked to?';

  FLAG_NAME = 1;
  PRF_IEN = 2;
  ACTION_NAME = 3;
  ACTION_IEN = 4;
  ACTION_DATE_I = 5;
  ACTION_DATE = 6;
  NOTE_IEN = 7;


var
  uConsultsList: TStringList;
  uShowUnresolvedOnly: boolean;

function ExecuteNoteProperties(var ANote: TEditNoteRec; CallingTab: integer; IDNoteTitlesOnly,
          IsNewIDEntry: boolean; AClassName: string; CPStatusFlag: integer): Boolean;
var
  frmNoteProperties: TfrmNoteProperties;
begin
  frmNoteProperties := TfrmNoteProperties.Create(Application);
  frmNoteProperties.FIsNewNote := ANote.IsNewNote;
  uConsultsList := TStringList.Create;
  try
    ResizeAnchoredFormToFont(frmNoteProperties);
    with frmNoteProperties do
    begin
      // setup common fields (title, reference date, author)
      FToday := FloatToStr(FMToday);
      FCallingTab := CallingTab;
      FIDNoteTitlesOnly := IDNoteTitlesOnly;
      FClassName := AClassName;
      FIsClinProcNote := (AClassName = DCL_CLINPROC);
      FCPStatusFlag := CPStatusFlag;
      //uShowUnresolvedOnly := False;                      //v26.5 (RV)
      uShowUnresolvedOnly := True;                         //v26.5 (RV)
      if ANote.DocType <> TYP_ADDENDUM then
        begin
          case FCallingTab of
            CT_CONSULTS:  begin
                            Caption := 'Consult Note Properties';
                            cboNewTitle.InitLongList('');
                            if FIsClinProcNote then
                              begin
                                Caption := TX_CP_CAPTION;
                                lblNewTitle.Caption := TX_CP_TITLE;
                                ListClinProcTitlesShort(cboNewTitle.Items);
                                cboAuthor.InitLongList(User.Name);
                                cboAuthor.SelectByIEN(User.DUZ);
                                cboProcSummCode.SelectByIEN(ANote.ClinProcSummCode);
                                calProcDateTime.FMDateTime := ANote.ClinProcDateTime;
                              end
                            else   // not CP note
                              begin
                                ListConsultTitlesShort(cboNewTitle.Items);
                                cboAuthor.InitLongList(ANote.AuthorName);
                                if ANote.Author > 0 then cboAuthor.SelectByIEN(ANote.Author);
                              end;
                          end ;
           CT_SURGERY:    begin
                            Caption := TX_SR_CAPTION;
                            lblNewTitle.Caption := TX_SR_TITLE;
                            cboNewTitle.InitLongList('');
                            cboAuthor.InitLongList(ANote.AuthorName);
                            if ANote.Author > 0 then cboAuthor.SelectByIEN(ANote.Author);
                            ListSurgeryTitlesShort(cboNewTitle.Items, FClassName);
                          end;
           CT_NOTES:      begin
                            Caption := 'Progress Note Properties';
                            if ANote.IsNewNote then
                            begin
                              GetUnresolvedConsultsInfo; // v26.5 (RV) removed nag screen
                            end;
                            cboNewTitle.InitLongList('');
                            cboAuthor.InitLongList(ANote.AuthorName);
                            if ANote.Author > 0 then cboAuthor.SelectByIEN(ANote.Author);
                            ListNoteTitlesShort(cboNewTitle.Items);
                            // HOW TO PREVENT TITLE CHANGE ON ID CHILD, BUT NOT ON INITIAL CREATE?????
                            cboNewTitle.Enabled := not ((ANote.IDParent > 0) and (ANote.Title > 0) and (not IsNewIDEntry));
                            if not cboNewTitle.Enabled then
                              begin
                                cboNewTitle.Color := clBtnFace;
                                InfoBox(TX_NO_TITLE_CHANGE, TC_NO_TITLE_CHANGE, MB_OK);
                              end;
                          end;
            end;
        end
      else //if addendum
        begin
          Caption := 'Addendum Properties';
          cboNewTitle.Items.Insert(0, IntToStr(ANote.Title) + U + ANote.TitleName);
          cboAuthor.InitLongList(ANote.AuthorName);
          if ANote.Author > 0 then cboAuthor.SelectByIEN(ANote.Author);
        end;
      ShowClinProcFields(FIsClinProcNote);
      FStarting := True;
      if ANote.Title > 0 then cboNewTitle.SelectByIEN(ANote.Title);
      if (ANote.Title > 0) and (cboNewTitle.ItemIndex < 0)
        then cboNewTitle.SetExactByIEN(ANote.Title, ANote.TitleName);
      FStarting := False;
      calNote.FMDateTime := ANote.DateTime;
      // setup cosigner fields
      FAddend           := ANote.Addend;
      FCosignIEN        := ANote.Cosigner;
      FCosignName       := ANote.CosignerName;
      FDocType          := ANote.DocType;
     // FLastCosigner     := ANote.LastCosigner;
     // FLastCosignerName := ANote.LastCosignerName;
      SetCosignerRequired(True);
      // setup package fields
      SetGenericFormSize;
      case FCallingTab of
        CT_CONSULTS:  begin
                        ShowRequestList(False);
                        ShowSurgCaseList(False);
                        ShowPRFList(False);
                      end;
        CT_SURGERY :  begin
                        ShowRequestList(False);
                        ShowSurgCaseList(False);
                        ShowPRFList(False);
                      end;
        CT_NOTES   :  begin
                        with uUnresolvedConsults do                          // v26.5 (RV)
                          ShowRequestList(IsConsultTitle(ANote.Title) or
                            (UnresolvedConsultsExist and ShowNagScreen));    // v26.5 (RV)
                        ShowSurgCaseList(IsSurgeryTitle(ANote.Title));
                        ShowPRFList(IsPRFTitle(ANote.Title));
                      end;
      end;
      // restrict edit of title if addendum
      if FDocType = TYP_ADDENDUM then
      begin
        lblNewTitle.Caption := 'Addendum to:';
        cboNewTitle.Enabled := False;
        cboNewTitle.Color   := clBtnFace;
      end;
      cboNewTitle.Caption := lblNewTitle.Caption;
      FStarting := True;
      cboNewTitleExit(frmNoteProperties);        // force display of request/case list
      FStarting := False;
      if uShowUnresolvedOnly then                // override previous display if SHOW ME clicked on entrance
      begin
        //cboNewTitle.ItemIndex := -1;      CQ#7587, v26.25 - RV
        uShowUnresolvedOnly := not uShowUnresolvedOnly;
        FormatRequestList;
      end ;
      Result := ShowModal = idOK;                // display the form
      if Result then with ANote do
      begin
        if FDocType <> TYP_ADDENDUM then
        begin
          Title := cboNewTitle.ItemIEN;
          TitleName := PrintNameForTitle(Title);
        end;
        IsNewNote := False;
        DateTime := calNote.FMDateTime;
        Author := cboAuthor.ItemIEN;
        AuthorName := Piece(cboAuthor.Items[cboAuthor.ItemIndex], U, 2);
        if cboCosigner.Visible then
        begin
          Cosigner := cboCosigner.ItemIEN;
          CosignerName := Piece(cboCosigner.Items[cboCosigner.ItemIndex], U, 2);
          // The LastCosigner fields are used to default the cosigner in subsequent notes.
          // These fields are not reset with new notes & not passed into TIU.
         // LastCosigner := Cosigner;
         // LastCosignerName := CosignerName;
        end else
        begin
          Cosigner := 0;
          CosignerName := '';
        end;
        if FIsClinProcNote then
          begin
            ClinProcSummCode := FProcSummCode;
            ClinProcDateTime := FProcDateTime;
            if Location <= 0 then
              begin
                Location := Encounter.Location;
                LocationName := Encounter.LocationName;
              end;
            if VisitDate <= 0 then VisitDate := Encounter.DateTime;
          end;
        case FCallingTab of
          CT_CONSULTS:  ;// no action required
          CT_SURGERY :  ;// no action required
                        (*begin
                          PkgIEN := lstSurgery.ItemIEN;
                          PkgPtr := PKG_SURGERY;
                          PkgRef := IntToStr(PkgIEN) + ';' + PkgPtr;
                        end;*)
          CT_NOTES   :  begin
                          if pnlConsults.Visible then
                            begin
                              PkgIEN := lstRequests.ItemIEN;
                              PkgPtr := PKG_CONSULTS;
                              PkgRef := IntToStr(PkgIEN) + ';' + PkgPtr;
                            end
                          else if pnlSurgery.Visible then
                            begin
                              PkgIEN := lstSurgery.ItemIEN;
                              PkgPtr := PKG_SURGERY;
                              PkgRef := IntToStr(PkgIEN) + ';' + PkgPtr;
                            end
                          else if (pnlPRF.Visible) and (lvPRF.ItemIndex >= 0) then //PRF
                            begin
                              PRF_IEN := FPRFActions.GetPRF_IEN(lvPRF.ItemIndex);
                              ActionIEN := FPRFActions.GetActionIEN(lvPRF.ItemIndex);
                            end
                          else
                            begin
                              PkgIEN := 0;
                              PkgPtr := '';
                              PkgRef := '';
                            end;
                        end;
        end;
      end;
    end;
  finally
    if Assigned(uConsultsList) then uConsultsList.Free;
    frmNoteProperties.Free;
  end;
end;

{ Form events }

procedure TfrmNoteProperties.FormShow(Sender: TObject);
begin
  //if cboNewTitle.Text = '' then PostMessage(Handle, UM_DELAYEVENT, 0, 0);
end;

procedure TfrmNoteProperties.UMDelayEvent(var Message: TMessage);
{ let the window finish displaying before dropping list box, otherwise listbox drop
  in the design position rather then new windows position (ORCtrls bug?) }
begin
//  Screen.Cursor := crArrow;
//  FFixCursor := TRUE;
//  cboNewTitle.DroppedDown := True;
//  lblDateTime.Visible := False;
//  lblAuthor.Visible   := False;
//  lblCosigner.Visible := False;
end;

{ General calls }

procedure TfrmNoteProperties.SetCosignerRequired(DoSetup: boolean);
{ called initially & whenever title or author changes }
begin
  if FDocType = TYP_ADDENDUM then
  begin
    lblCosigner.Visible := AskCosignerForDocument(FAddend, cboAuthor.ItemIEN, calNote.FMDateTime)
  end else
  begin
    if cboNewTitle.ItemIEN = 0
      then lblCosigner.Visible := AskCosignerForTitle(FDocType,            cboAuthor.ItemIEN, calNote.FMDateTime)
      else lblCosigner.Visible := AskCosignerForTitle(cboNewTitle.ItemIEN, cboAuthor.ItemIEN, calNote.FMDateTime);
  end;
  cboCosigner.Visible := lblCosigner.Visible;
  if DoSetup then
    begin
      if lblCosigner.Visible then
      begin
       { if FCosignIEN = 0 then
        begin
          FCosignIEN  := FLastCosigner;
          FCosignName := FLastCosignerName;
        end; }
        if FCosignIEN = 0 then DefaultCosigner(FCosignIEN, FCosignName);
        cboCosigner.InitLongList(FCosignName);
        if FCosignIEN > 0 then cboCosigner.SelectByIEN(FCosignIEN);
      end
      else   // if lblCosigner not visible, clear values  {v19.10 - RV}
      begin
        FCosignIEN  := 0;
        FCosignName := '';
        cboCosigner.ItemIndex := -1;
      end;
    end;
end;

procedure TfrmNoteProperties.ShowRequestList(ShouldShow: Boolean);
{ called initially & whenever title changes }
const
  ALL_CONSULTS        = 'The following consults are currently available for selection:';
  UNRESOLVED_CONSULTS = 'The following consults are currently awaiting resolution:';
var
  i: Integer;
  SavedIEN: integer;
  item: TVA508AccessibilityItem;
begin
  ShouldShow := ShouldShow and (FCallingTab = CT_NOTES);
  if FDocType = TYP_ADDENDUM then ShouldShow := False;
  pnlConsults.Visible := ShouldShow;
  if ShouldShow then
  begin
    SavedIEN := lstRequests.ItemIEN;
    ClientHeight := cboCosigner.Top + cboCosigner.Height + PIXEL_SPACE + pnlConsults.Height;
    lstRequests.Items.Clear;
    if uConsultsList.Count = 0 then ListConsultRequests(uConsultsList);
    if uShowUnresolvedOnly then
    begin
      for i := 0 to uConsultsList.Count - 1 do
        if Pos(Piece(uConsultsList[i], U, 5), ACTIVE_STATUS) > 0 then
          lstRequests.Add(uConsultsList[i]);
      lblConsult2.Caption := UNRESOLVED_CONSULTS;
    end
    else
    begin
      lblConsult2.Caption := ALL_CONSULTS;
      FastAssign(uConsultsList, lstRequests.ItemsStrings);
    end;
    lblConsult1.Visible := (cboNewTitle.ItemIndex > -1);
    lstRequests.SelectByIEN(SavedIEN);
    btnDetails.Enabled := Assigned(lstRequests.Selected);
    //update 508
    item := amgrMain.AccessData.FindItem(lstRequests, False);
    if lblConsult1.Visible then
     amgrMain.AccessData[item.Index].AccessText := lblConsult1.Caption +' '+ lblConsult2.Caption
    else
     amgrMain.AccessData[item.Index].AccessText := lblConsult2.Caption;
  end
end;

procedure TfrmNoteProperties.ShowSurgCaseList(ShouldShow: Boolean);
{ called initially & whenever title changes }
var
 item: TVA508AccessibilityItem;
begin
  pnlSurgery.Visible := ShouldShow;
  if FDocType = TYP_ADDENDUM then ShouldShow := False;
  if ShouldShow then
  begin
    ClientHeight := cboCosigner.Top + cboCosigner.Height + PIXEL_SPACE + pnlSurgery.Height;
    if lstSurgery.Items.Count = 0 then ListSurgeryCases(lstSurgery.ItemsStrings);
    item := amgrMain.AccessData.FindItem(lstSurgery, False);
    amgrMain.AccessData[item.Index].AccessText := lblSurgery1.Caption + ' ' + lblSurgery2.Caption;
  end;

end;

{ cboNewTitle events }

procedure TfrmNoteProperties.cboNewTitleNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  case FCallingTab of
    CT_CONSULTS:  begin
                    if FIsClinProcNote then
                      cboNewTitle.ForDataUse(SubSetOfClinProcTitles(StartFrom, Direction, FIDNoteTitlesOnly))
                    else
                      cboNewTitle.ForDataUse(SubSetOfConsultTitles(StartFrom, Direction, FIDNoteTitlesOnly));
                  end;
    CT_SURGERY:   cboNewTitle.ForDataUse(SubSetOfSurgeryTitles(StartFrom, Direction, FClassName));
    CT_NOTES:     cboNewTitle.ForDataUse(SubSetOfNoteTitles(StartFrom, Direction, FIDNoteTitlesOnly));
  end;
end;

procedure TfrmNoteProperties.cboNewTitleEnter(Sender: TObject);
begin
  FLastTitle := 0;
end;

procedure TfrmNoteProperties.cboNewTitleMouseClick(Sender: TObject);
const
  TX_NEED_CONSULT_TITLE = 'You currently have unresolved consults awaiting completion.' + CRLF +
                          'The selected title cannot be used to complete consults.' + CRLF +
                          'You must select a Consults title to complete a consult.' + CRLF + CRLF +
                          'Answer "YES" to continue with this title and not complete a consult.' + CRLF +
                          'Answer "NO" to select a different title.' + CRLF + CRLF +
                          'Do you want to use this title and continue?';                          
  TC_NOT_CONSULT_TITLE = 'Not a consult title';
var
  WantsToCompleteConsult: boolean;
  ConsultTitle: boolean;
begin
  with cboNewTitle do
    if (ItemIEN > 0) and (ItemIEN = FLastTitle) then Exit
    else if ItemIEN = 0 then
      begin
        if FLastTitle > 0 then SelectByIEN(FLastTitle)
        else ItemIndex := -1;
        //Exit;
      end;
    case FCallingTab of
      CT_CONSULTS:  ;  // no action
      CT_SURGERY :  ;  // no action
      CT_NOTES   :  begin            // v26.5 (RV) main changes here
                      WantsToCompleteConsult := False;
                      ConsultTitle := IsConsultTitle(cboNewTitle.ItemIEN);
                      if (pnlConsults.Visible) and
                         (lstRequests.Items.Count > 0) and
                         (not FStarting) and
                         (*(lstRequests.ItemID <> '') and*)
                         (not ConsultTitle) then
                          WantsToCompleteConsult := (InfoBox(TX_NEED_CONSULT_TITLE,
                                                            TC_NOT_CONSULT_TITLE,
                                                            MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2) = IDNO);
                      if WantsToCompleteConsult and (not ConsultTitle) then cboNewTitle.ItemIndex := -1;
                      SetGenericFormSize;
                      ShowRequestList(WantsToCompleteConsult or ConsultTitle);
                      ShowSurgCaseList(IsSurgeryTitle(cboNewTitle.ItemIEN));
                      ShowPRFList(IsPRFTitle(cboNewTitle.ItemIEN));
                    end;
    end;
  SetCosignerRequired(True);
  FLastTitle := cboNewTitle.ItemIEN;
end;

procedure TfrmNoteProperties.cboNewTitleExit(Sender: TObject);
begin
  if cboNewTitle.ItemIEN <> FLastTitle then cboNewTitleMouseClick(Self);
end;

procedure TfrmNoteProperties.cboNewTitleDblClick(Sender: TObject);
begin
  cmdOKClick(Self);
end;

{ cboAuthor & cboCosigner events }

procedure TfrmNoteProperties.NewPersonNeedData(Sender: TObject; const StartFrom: String;
  Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmNoteProperties.cboAuthorEnter(Sender: TObject);
begin
  FLastAuthor := 0;
end;

procedure TfrmNoteProperties.cboAuthorMouseClick(Sender: TObject);
begin
  SetCosignerRequired(True);
  FLastAuthor := cboAuthor.ItemIEN;
end;

procedure TfrmNoteProperties.cboAuthorExit(Sender: TObject);
begin
  if cboAuthor.ItemIEN <> FLastAuthor then cboAuthorMouseClick(Self);
end;

procedure TfrmNoteProperties.cboCosignerExit(Sender: TObject);
{ make sure FCosign fields stay up to date in case SetCosigner gets called again }
//var x: string;
begin
  with cboCosigner do if ((Text = '') or (ItemIEN = 0)) then
  begin
    ItemIndex := -1;
    FCosignIEN := 0;
    FCosignName := '';
    exit;
  end;
  FCosignIEN := cboCosigner.ItemIEN;
  FCosignName := Piece(cboCosigner.Items[cboCosigner.ItemIndex], U, 2);
end;

{ Command Button events }

procedure TfrmNoteProperties.cmdOKClick(Sender: TObject);
var
  ErrMsg, WhyNot, AlertMsg: string;
begin
  cmdOK.SetFocus;                                // make sure cbo exit events fire
  Application.ProcessMessages;
(*  case FCallingTab of
    CT_CONSULTS:  ;  //no action
    CT_SURGERY :  ;  //no action
    CT_NOTES   :  if IsConsultTitle(cboNewTitle.ItemIEN) then
                    ShowRequestList(True)
                  else if IsSurgeryTitle(cboNewTitle.ItemIEN) then
{ TODO -oRich V. -cSurgery/TIU : Disallow new surgery notes here - MUST be business rule for "BE ENTERED": }
     //  New TIU RPC required, to check user and title against business rules.
     //  Must allow OK button click if surgery title on edit of surgery original.
     //  Can't pre-screen titles because need to allow change on edit.
     //  May need additional logic here to distinguish between NEW or EDITED document.
                    ShowSurgCaseList(True)
                  else
                    begin
                       ShowRequestList(False);
                       ShowSurgCaseList(False);
                       ShowPRFList(False);
                    end;
  end;*)
  SetCosignerRequired(False);
  ErrMsg := '';
  if cboNewTitle.ItemIEN = 0 then
    ErrMsg := ErrMsg + TX_REQ_TITLE ;
  if ErrMsg = '' then
    begin
      if FDocType = TYP_ADDENDUM then
        begin
          if OneNotePerVisit(TYP_ADDENDUM, Patient.DFN, Encounter.VisitStr)then
            ErrMsg := ErrMsg + TX_ONE_NOTE_PER_VISIT1
                     + 'Addendum to ' + Piece(cboNewTitle.Items[cboNewTitle.ItemIndex],U,2)
                     + TX_ONE_NOTE_PER_VISIT2;
        end
        //code added 12/2002  check note parm - one per visit  GRE
      else if OneNotePerVisit(CboNewTitle.ItemIEN, Patient.DFN, Encounter.VisitStr)then
            ErrMsg := ErrMsg + TX_ONE_NOTE_PER_VISIT1
                     + Piece(cboNewTitle.Items[cboNewTitle.ItemIndex],U,2)
                     + TX_ONE_NOTE_PER_VISIT2;
    end;
  if ErrMsg = '' then
    begin
      if FIDNoteTitlesOnly then
        begin
          if (not CanTitleBeIDChild(cboNewTitle.ItemIEN, WhyNot)) then
            ErrMsg := ErrMsg + CRLF + WhyNot;
        end
      else
        begin
          if ((pnlConsults.Visible) and (not Assigned(lstRequests.Selected))) then
            ErrMsg := ErrMsg + TX_REQ_REQUEST
          else if ((pnlSurgery.Visible) and (Assigned(lstSurgery.Selected))) then
            ErrMsg := ErrMsg + TX_REQ_SURGCASE
          else if (pnlPRF.Visible) then
          begin
            if (lvPRF.ItemIndex < 0) and (FIsNewNote) then
              ErrMsg := ErrMsg + TX_REQ_PRF_ACTION;
            if (lvPRF.ItemIndex >= 0) and (FPRFActions.SelActionHasNote(lvPRF.ItemIndex)) then
              ErrMsg := ErrMsg + TX_REQ_PRF_NOTE;
          end;
        end;
    end;
  if cboAuthor.ItemIEN = 0   then ErrMsg := ErrMsg + TX_REQ_AUTHOR;
  if not calNote.IsValid     then ErrMsg := ErrMsg + TX_REQ_REFDATE;
  if calNote.IsValid and (calNote.FMDateTime > FMNow)    then ErrMsg := ErrMsg + TX_NO_FUTURE;
  if cboCosigner.Visible then
    begin
       if (cboCosigner.ItemIEN = 0)     then ErrMsg := ErrMsg + TX_REQ_COSIGNER;
      //if (cboCosigner.ItemIEN = User.DUZ) then ErrMsg := TX_COS_SELF;  // (CanCosign will do this check)
      if (cboCosigner.ItemIEN > 0) and not CanCosign(cboNewTitle.ItemIEN, FDocType, cboCosigner.ItemIEN, calNote.FMDateTime)
        then ErrMsg := cboCosigner.Text + TX_COS_AUTH;
        //code added 02/2003  check if User is Inactive   GRE
        if UserInactive(IntToStr(cboCosigner.ItemIEN)) then
        if (InfoBox(fNoteProps.TX_USER_INACTIVE, TC_INACTIVE_USER, MB_OKCANCEL)= IDCANCEL) then exit;
    end;
  if FIsClinProcNote then
    begin
      if (FCPStatusFlag = CP_INSTR_INCOMPLETE) then
        begin
          if cboProcSummCode.ItemIEN = 0 then ErrMsg := ErrMsg + TX_REQ_PROCSUMMCODE
            else FProcSummCode := cboProcSummCode.ItemIEN;
          if not calProcDateTime.IsValid then ErrMsg := ErrMsg + TX_REQ_PROCDATETIME
           else if calProcDateTime.IsValid and (calProcDateTime.FMDateTime > FMNow) then ErrMsg := ErrMsg + TX_NO_PROC_FUTURE
           else FProcDateTime := calProcDateTime.FMDateTime;
        end
      else
        begin
          FProcSummCode := cboProcSummCode.ItemIEN;
          if (calProcDateTime.FMDateTime > 0) then
            begin
              if (not calProcDateTime.IsValid) then ErrMsg := ErrMsg + TX_INVALID_PROCDATETIME
               else if calProcDateTime.IsValid and (calProcDateTime.FMDateTime > FMNow) then ErrMsg := ErrMsg + TX_NO_PROC_FUTURE
               else FProcDateTime := calProcDateTime.FMDateTime;
            end;
        end;
    end;
  if ShowMsgOn(Length(ErrMsg) > 0, ErrMsg, TC_REQ_FIELDS)
    then Exit
    else ModalResult := mrOK;

    //Code added to handle inactive users.  2/26/03
  if ShowMsgOn(Length(AlertMsg) > 0, AlertMsg, TC_INACTIVE_USER ) then
     ModalResult := mrOK;
end;

procedure TfrmNoteProperties.cmdCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  //Close;
end;

procedure TfrmNoteProperties.cboNewTitleDropDownClose(Sender: TObject);
begin
//  if FFixCursor then
//  begin
//    Screen.Cursor := crDefault;
//    FFixCursor := FALSE;
//  end;
//  lblDateTime.Visible := True;
//  lblAuthor.Visible   := True;
//  lblCosigner.Visible := True;
end;

procedure TfrmNoteProperties.cboCosignerNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfUsersWithClass(StartFrom, Direction, FToday));
end;

procedure TfrmNoteProperties.ShowClinProcFields(YesNo: boolean);
begin
  lblProcSummCode.Visible := YesNo;
  cboProcSummCode.Visible := YesNo;
  lblProcDateTime.Visible := YesNo;
  calProcDateTime.Visible := YesNo;
end;

procedure TfrmNoteProperties.btnShowListClick(Sender: TObject);
begin
  FormatRequestList;
end;

procedure TfrmNoteProperties.FormatRequestList;
const
  SHOW_UNRESOLVED = 'Show Unresolved';
  SHOW_ALL = 'Show All';
begin
  uShowUnresolvedOnly := not uShowUnresolvedOnly;
  with btnShowList do
    if uShowUnresolvedOnly then
      Caption := SHOW_ALL
    else
      Caption := SHOW_UNRESOLVED;
  with uUnresolvedConsults do if (UnresolvedConsultsExist and ShowNagScreen) then pnlConsults.Visible := TRUE;  //v26.27 (RV)
  ShowRequestList(pnlConsults.Visible);      //v26.5 (RV)
  //ShowRequestList(True);                   //v26.5 (RV)
end;

procedure TfrmNoteProperties.FormResize(Sender: TObject);
const
  SPACE: integer = 10;
begin
  cboNewTitle.Width := Self.ClientWidth - cboNewTitle.Left - cmdOK.Width - SPACE * 2;
  cmdOK.Left := Self.ClientWidth - cmdOK.Width - SPACE;
  cmdCancel.Left := Self.ClientWidth - cmdCancel.Width - SPACE;
  if (cboAuthor.Width + cboAuthor.Left) > Self.ClientWidth then
    cboAuthor.Width := Self.ClientWidth - cboAuthor.Left - SPACE;
end;

procedure TfrmNoteProperties.calNoteEnter(Sender: TObject);
begin
  if Sender is TORDateBox then
    (Sender as TORDateBox).SelectAll;
end;

procedure TfrmNoteProperties.CaptionListView1Change(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  btnDetails.Enabled := (lstRequests.ItemIEN > 0);
end;

procedure TfrmNoteProperties.ShowPRFList(ShouldShow: Boolean);
var
 item: TVA508AccessibilityItem;
begin
  pnlPRF.Visible := ShouldShow and not (FDocType = TYP_ADDENDUM);
  if pnlPRF.Visible then
  begin
    ClientHeight := cboCosigner.Top + cboCosigner.Height + PIXEL_SPACE + pnlPRF.Height;
    if FPRFActions = nil then
      FPRFActions := TPRFActions.Create;
    FPRFActions.Load(cboNewTitle.ItemIEN,Patient.DFN);
    if RPCBrokerV.Results.Count <> 0 then
      lblPRF.Caption := PRF_LABEL
    else
      lblPRF.Caption := 'No Linkable Actions for this Patient and/or Title.';
    FPRFActions.ShowActionsOnList(lvPRF);
    //Fix for CQ: 6926
    lvPRF.Columns.BeginUpdate;
    lvPRF.Columns.EndUpdate;
    //End Fix for CQ: 6926

    item := amgrMain.AccessData.FindItem(lvPRF, False);
    amgrMain.AccessData[item.Index].AccessText := lblPRF.Caption;
  end
end;

procedure TfrmNoteProperties.SetGenericFormSize;
begin
  ClientHeight := cboCosigner.Top + cboCosigner.Height + PIXEL_SPACE;
end;

{ TPRFActions }

constructor TPRFActions.Create;
begin
  inherited;
  FPRFActionList := TStringList.Create;
end;

destructor TPRFActions.Destroy;
begin
  FPRFActionList.Free;
  inherited;
end;

function TPRFActions.GetActionIEN(lstIndex: integer): String;
begin
  Result := Piece(FPRFActionList[lstIndex],U,ACTION_IEN);
end;

function TPRFActions.GetPRF_IEN(lstIndex: integer): integer;
begin
  Result := StrToInt(Piece(FPRFActionList[lstIndex],U,PRF_IEN));
end;

procedure TPRFActions.Load(TitleIEN : Int64; DFN : String);
begin
  CallV('TIU GET PRF ACTIONS', [TitleIEN,DFN]);
  FastAssign(RPCBrokerV.Results, FPRFActionList);
end;

function TPRFActions.SelActionHasNote(lstIndex: integer): boolean;
begin
  Result := false;
  if Piece(FPRFActionList[lstIndex],U,NOTE_IEN) <> '' then
    Result := true;
end;

procedure TPRFActions.ShowActionsOnList(DisplayList: TCaptionListView);
var
  i : integer;
  ListItem: TListItem;
begin
  DisplayList.Clear;
  for i := 0 to FPRFActionList.Count-1 do
  begin
    //Caption="Text for Screen Reader" SubItem1=Flag SubItem2=Date SubItem3=Action SubItem4=Note
    ListItem := DisplayList.Items.Add;
    ListItem.Caption := PRF_LABEL; //Screen readers don't read the first column title on a listview.
    ListItem.SubItems.Add(Piece(FPRFActionList[i],U,FLAG_NAME));
    ListItem.SubItems.Add(Piece(FPRFActionList[i],U,ACTION_DATE));
    ListItem.SubItems.Add(Piece(FPRFActionList[i],U,ACTION_NAME));
    if SelActionHasNote(i) then
      ListItem.SubItems.Add('Yes')
    else
      ListItem.SubItems.Add('No');
  end;
end;

procedure TfrmNoteProperties.FormDestroy(Sender: TObject);
begin
  FPRFActions.Free;
end;

procedure TfrmNoteProperties.btnDetailsClick(Sender: TObject);
var
  ConsultDetail: TStringList;
begin
  if lstRequests.ItemIEN <= 0 then exit;
  ConsultDetail := TStringList.Create;
  try
    LoadConsultDetail(ConsultDetail, lstRequests.ItemIEN) ;
    ReportBox(ConsultDetail, 'Consult Details: #' + lstRequests.ItemID + ' - ' +
               Piece(lstRequests.Strings[lstRequests.Selected.Index], U, 3), TRUE);
  finally
    ConsultDetail.Free;
  end;
end;

end.
