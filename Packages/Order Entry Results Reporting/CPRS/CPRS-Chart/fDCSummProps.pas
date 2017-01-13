unit fDCSummProps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORDtTm, ORCtrls, ExtCtrls, uConst, rTIU, rDCSumm, uDocTree, uDCSumm,
  uTIU, fBase508Form, VA508AccessibilityManager, ORStaticText,
  VA508AccessibilityRouter,
  Vcl.ComCtrls, Math;

type

  TfrmDCSummProperties = class(TfrmBase508Form)
    bvlConsult: TBevel;
    lblNewTitle: TLabel;
    cboNewTitle: TORComboBox;
    calSumm: TORDateBox;
    lblDateTime: TLabel;
    lblAuthor: TLabel;
    cboAttending: TORComboBox;
    lblCosigner: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cboAuthor: TORComboBox;
    pnlTranscription: TPanel;
    cboTranscriptionist: TORComboBox;
    lblTranscriptionist: TLabel;
    lblUrgency: TLabel;
    cboUrgency: TORComboBox;
    pnlAdmission: TPanel;
    lblDCSumm1: TStaticText;
    lblDCSumm2: TStaticText;
    lstAdmissions: TCaptionListView;
    procedure FormShow(Sender: TObject);
    procedure cboNewTitleNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboAuthorNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboAttendingNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboNewTitleExit(Sender: TObject);
    procedure cboNewTitleMouseClick(Sender: TObject);
    procedure cboNewTitleEnter(Sender: TObject);
    procedure cboAttendingExit(Sender: TObject);
    procedure cboAuthorExit(Sender: TObject);
    procedure cboAuthorMouseClick(Sender: TObject);
    procedure cboAuthorEnter(Sender: TObject);
    procedure cboNewTitleDropDownClose(Sender: TObject);
    procedure cboNewTitleDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboNewTitleChange(Sender: TObject);
    procedure lstAdmissionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FCosignIEN: Int64; // store cosigner that was passed in
    FCosignName: string; // store cosigner that was passed in
    FDocType: Integer; // store document type that was passed in
    FAddend: Integer; // store IEN of note being addended (if make addendum)
    FLastAuthor: Int64; // set by mouseclick to avoid redundant call on exit
    FLastTitle: Integer; // set by mouseclick to avoid redundant call on exit
    FAdmitDateTime: string;
    FLocation: Integer;
    FLocationName: string;
    FVisitStr: string;
    FEditIEN: Integer;
    // FFixCursor: Boolean;    // to fix the problem where the list box is an I-bar
    FLastCosigner: Int64; // holds cosigner from previous note (for defaulting)
    FLastCosignerName: string;
    // holds cosigner from previous note (for defaulting)
    FShowAdmissions: Boolean;
    FIDNoteTitlesOnly: Boolean;
    procedure SetCosignerRequired;
    procedure ShowAdmissionList;
    procedure UMDelayEvent(var Message: TMessage); message UM_DELAYEVENT;
  public
    { Public declarations }
  end;

function ExecuteDCSummProperties(var ASumm: TEditDCSummRec;
  var ListBoxItem: string; ShowAdmissions, IDNoteTitlesOnly: Boolean): Boolean;

var
  EditLines: TStringList;

implementation

{$R *.DFM}

uses
  VAUtils, ORFn, uCore, rCore, uPCE, rPCE, rMisc;

{ Initial values in ASumm

  Title  Type    Author  DateTime  Cosigner  Location  Consult  NeedCPT
  New DCSumm    dflt   244      DUZ      NOW      dflt      Encnt      0        ?
  Edit DCSumm    ien    244      ien     DtTm       ien       ien      ien      fld
  Addend DCSumm    ien     81      DUZ      NOW        0        N/A      N/A?      no

  New Summ - setup as much as possible, then call ExecuteDCSummProperties if necessary.

}

const
  TC_REQ_FIELDS = 'Required Information';
  TX_REQ_TITLE = CRLF + 'A title must be selected.';
  TX_REQ_AUTHOR = CRLF + 'The author of the note must be identified.';
  TX_REQ_REFDATE = CRLF + 'A valid date/time for the note must be entered.';
  TX_REQ_COSIGNER = CRLF + 'An attending must be identified.';
  TX_NO_FUTURE = CRLF + 'A reference date/time in the future is not allowed.';
  TX_COS_SELF = CRLF + 'You cannot make yourself a cosigner.';
  TX_COS_AUTH = CRLF + ' is not authorized to cosign this document.';
  TX_BAD_ADMISSION = CRLF + 'Admission information is missing or invalid.';
  TX_NO_ADMISSION = CRLF + 'An admission must be selected';
  TX_NO_MORE_SUMMS = CRLF +
    'Only one discharge summary may be written for each admission.';
  TC_NO_EDIT = 'Unable to Edit';
  TC_EDIT_EXISTING = 'Unsigned document in progress';
 // TX_EDIT_EXISTING =
//    'Would you like to continue editing the existing unsigned summary for this admission?';
  TX_EDIT_EXISTING =
      'Would you like to continue editing the existing unsigned summary for the %s addminsion to %s on %s?';

function ExecuteDCSummProperties(var ASumm: TEditDCSummRec;
  var ListBoxItem: string; ShowAdmissions, IDNoteTitlesOnly: Boolean): Boolean;
var
  frmDCSummProperties: TfrmDCSummProperties;
  x: string;
begin
  frmDCSummProperties := TfrmDCSummProperties.Create(Application);
  EditLines := TStringList.Create;
  try
    ResizeAnchoredFormToFont(frmDCSummProperties);
    with frmDCSummProperties do
    begin
      // setup common fields (title, reference date, author)
      FShowAdmissions := ShowAdmissions;
      FIDNoteTitlesOnly := IDNoteTitlesOnly;
      pnlTranscription.Visible := False; { was never used on old form }
      if not pnlTranscription.Visible then
      begin
        Height := Height - pnlTranscription.Height;
        Top := Top - pnlTranscription.Height;
      end;
      if ASumm.DocType <> TYP_ADDENDUM then
      begin
        cboNewTitle.InitLongList('');
        ListDCSummTitlesShort(cboNewTitle.Items);
      end
      else // if addendum
        cboNewTitle.Items.Insert(0, IntToStr(ASumm.Title) + U +
          ASumm.TitleName);
      if ASumm.Title > 0 then
        cboNewTitle.SelectByIEN(ASumm.Title);
      if (ASumm.Title > 0) and (cboNewTitle.ItemIndex < 0) then
        cboNewTitle.SetExactByIEN(ASumm.Title, ASumm.TitleName);
      cboAuthor.InitLongList(ASumm.DictatorName);
      if ASumm.Dictator > 0 then
        cboAuthor.SelectByIEN(ASumm.Dictator);
      FastAssign(LoadDCUrgencies, cboUrgency.Items);
      cboUrgency.SelectByID('R');
      if ASumm.Attending = 0 then
      begin
        ASumm.Attending := FLastCosigner;
        ASumm.AttendingName := FLastCosignerName;
      end;
      calSumm.FMDateTime := ASumm.DictDateTime;
      if FShowAdmissions then
        ShowAdmissionList;
      FAddend := ASumm.Addend;
      FDocType := ASumm.DocType;
      FLastCosigner := ASumm.LastCosigner;
      FLastCosignerName := ASumm.LastCosignerName;
      FEditIEN := 0;
      cboAttending.InitLongList(ASumm.AttendingName);
      if ASumm.Attending > 0 then
        cboAttending.SelectByIEN(ASumm.Attending);
      // restrict edit of title if addendum
      if FDocType = TYP_ADDENDUM then
      begin
        lblNewTitle.Caption := 'Addendum to:';
        cboNewTitle.Caption := 'Addendum to:';
        cboNewTitle.Enabled := False;
        cboNewTitle.Color := clBtnFace;
      end;
      Result := ShowModal = idOK; // display the form
      if Result then
        with ASumm do
        begin
          if FDocType <> TYP_ADDENDUM then
          begin
            Title := cboNewTitle.ItemIEN;
            TitleName := PrintNameForTitle(Title);
          end;
          Urgency := cboUrgency.ItemID;
          DictDateTime := calSumm.FMDateTime;
          Dictator := cboAuthor.ItemIEN;
          DictatorName := Piece(cboAuthor.Items[cboAuthor.ItemIndex], U, 2);
          Attending := cboAttending.ItemIEN;
          AttendingName :=
            Piece(cboAttending.Items[cboAttending.ItemIndex], U, 2);
          if Attending = Dictator then
            Cosigner := 0
          else
          begin
            Cosigner := cboAttending.ItemIEN;
            CosignerName :=
              Piece(cboAttending.Items[cboAttending.ItemIndex], U, 2);
            // The LastCosigner fields are used to default the cosigner in subsequent notes.
            // These fields are not reset with new notes & not passed into TIU.
            LastCosigner := Cosigner;
            LastCosignerName := CosignerName;
          end;
          Transcriptionist := cboTranscriptionist.ItemIEN;
          if FShowAdmissions then
          begin
            AdmitDateTime := StrToFMDateTime(FAdmitDateTime);
            DischargeDateTime := StrToFMDateTime(GetDischargeDate(Patient.DFN,
              FAdmitDateTime));
            if DischargeDateTime <= 0 then
              DischargeDateTime := FMNow;
            Location := FLocation;
            LocationName := FLocationName;
            VisitStr := IntToStr(Location) + ';' +
              FloatToStr(AdmitDateTime) + ';H';
          end;
          EditIEN := FEditIEN;
          if FEditIEN > 0 then
          begin
            x := GetTIUListItem(FEditIEN);
            ListBoxItem := x;
            if Lines = nil then
              Lines := TStringList.Create;
            FastAssign(EditLines, Lines);
          end
          else
          begin
            ListBoxItem := '';
          end;
        end;
      // The following fields in TEditDCSummRec are not set:
      // DocType, NeedCPT, Lines (unless editing an existing summary)
    end;
  finally
    EditLines.Free;
    frmDCSummProperties.Release;
  end;
end;

{ Form events }

procedure TfrmDCSummProperties.FormShow(Sender: TObject);
var
  srActive: Boolean;
begin
  SetFormPosition(Self);
  srActive := ScreenReaderActive;

  lblDCSumm1.TabStop := srActive;
  lblDCSumm2.TabStop := srActive;
  { stLocation.TabStop := srActive;
    stDate.TabStop := srActive;
    stType.TabStop := srActive;
    stSummStatus.TabStop := srActive; }
  // if cboNewTitle.Text = '' then PostMessage(Handle, UM_DELAYEVENT, 0, 0);
end;

procedure TfrmDCSummProperties.UMDelayEvent(var Message: TMessage);
{ let the window finish displaying before dropping list box, otherwise listbox drop
  in the design position rather then new windows position (ORCtrls bug?) }
begin
  (* Screen.Cursor := crArrow;
    FFixCursor := TRUE;
    cboNewTitle.DroppedDown := True;
    lblDateTime.Visible := False;
    lblAuthor.Visible   := False;
    lblCosigner.Visible := False; *)
end;

{ General calls }

procedure TfrmDCSummProperties.SetCosignerRequired;
{ called initially & whenever title or author changes }
begin
  (* if FDocType = TYP_ADDENDUM then
    begin
    lblCosigner.Visible := AskCosignerForDocument(FAddend, cboAuthor.ItemIEN)
    end else
    begin
    if cboNewTitle.ItemIEN = 0
    then lblCosigner.Visible := AskCosignerForTitle(FDocType,            cboAuthor.ItemIEN)
    else lblCosigner.Visible := AskCosignerForTitle(cboNewTitle.ItemIEN, cboAuthor.ItemIEN);
    end; *)
  lblCosigner.Visible := True;
  cboAttending.Visible := lblCosigner.Visible;
end;

procedure TfrmDCSummProperties.ShowAdmissionList;
var
  i, Status: Integer;
  TempList: TStringList;
  TempString: String;
begin
  TempList := TStringList.Create;
  try

      ListAdmitAll(TempList, Patient.DFN);
      if TempList.Count > 0 then
      begin

        for i := 0 to TempList.Count - 1 do
        begin
          TempString := TempList[i];
           SetPiece(TempString, '^', 8, FormatFMDateTimeStr('mmm dd,yyyy  hh:nn',
            Piece(TempList[i], U, 1)));
          Status := StrToIntDef(Piece(TempList[i], U, 7), 0);
          case Status of
            0:
              TempString := TempString + '^None on file';
            1:
              TempString := TempString + '^Completed';
            2:
              TempString := TempString + '^Unsigned';
          end;
          TempList[i] := TempString;
        end;
        lstAdmissions.ItemsStrings.Assign(TempList);
      end
      else
        FAdmitDateTime := '-1^No admissions were found for this patient.';

  finally
    TempList.Free;
  end;

end;

{ cboNewTitle events }

procedure TfrmDCSummProperties.cboNewTitleNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  cboNewTitle.ForDataUse(SubSetOfDCSummTitles(StartFrom, Direction,
    FIDNoteTitlesOnly));
end;

procedure TfrmDCSummProperties.cboNewTitleEnter(Sender: TObject);
begin
  FLastTitle := 0;
end;

procedure TfrmDCSummProperties.cboNewTitleMouseClick(Sender: TObject);
begin
  with cboNewTitle do
    if (ItemIEN > 0) and (ItemIEN = FLastTitle) then
      Exit
    else if ItemIEN = 0 then
    begin
      if FLastTitle > 0 then
        SelectByIEN(FLastTitle)
      else
        ItemIndex := -1;
      Exit;
    end;
  SetCosignerRequired;
  if FShowAdmissions and (not pnlAdmission.Visible) then
  begin
    pnlAdmission.Visible := True;
    pnlAdmission.Top := cmdCancel.Top + cmdCancel.Height + 8;
    pnlAdmission.Height := Height - pnlAdmission.Top;
  end;
  FLastTitle := cboNewTitle.ItemIEN;
end;

procedure TfrmDCSummProperties.cboNewTitleExit(Sender: TObject);
begin
  if cboNewTitle.ItemIEN <> FLastTitle then
    cboNewTitleMouseClick(Self);
  if pnlAdmission.Visible then
  begin
    If ScreenReaderSystemActive then
      GetScreenreader.Speak
        ('This discharge summary must be associated with an admission. Select one below or press cancel.');
  end;
end;

{ cboAuthor & cboAttending events }

procedure TfrmDCSummProperties.cboAuthorNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmDCSummProperties.cboAttendingNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  TitleIEN: Int64;
begin
  // (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));

  // CQ#11666
  // (Sender as TORComboBox).ForDataUse(SubSetOfCosigners(StartFrom, Direction,
  // FMToday, cboNewTitle.ItemIEN, FDocType));

  // CQ #17218 - Updated to properly filter co-signers - JCS
  TitleIEN := cboNewTitle.ItemIEN;
  if TitleIEN = 0 then
    TitleIEN := FDocType;

  (Sender as TORComboBox).ForDataUse(SubSetOfCosigners(StartFrom, Direction,
    FMToday, TitleIEN, 0));
end;

procedure TfrmDCSummProperties.cboAuthorEnter(Sender: TObject);
begin
  FLastAuthor := 0;
end;

procedure TfrmDCSummProperties.cboAuthorMouseClick(Sender: TObject);
begin
  SetCosignerRequired;
  FLastAuthor := cboAuthor.ItemIEN;
end;

procedure TfrmDCSummProperties.cboAuthorExit(Sender: TObject);
begin
  if cboAuthor.ItemIEN <> FLastAuthor then
    cboAuthorMouseClick(Self);
end;

procedure TfrmDCSummProperties.cboAttendingExit(Sender: TObject);
{ make sure FCosign fields stay up to date in case SetCosigner gets called again }
begin
  with cboAttending do
    if Text = '' then
      ItemIndex := -1;
  if cboAttending.ItemIndex < 0 then
  begin
    FCosignIEN := 0;
    FCosignName := '';
  end
  else
  begin
    FCosignIEN := cboAttending.ItemIEN;
    FCosignName := Piece(cboAttending.Items[cboAttending.ItemIndex], U, 2);
  end;
end;

{ Command Button events }

procedure TfrmDCSummProperties.cmdOKClick(Sender: TObject);
var
  ErrMsg, ItemText, WhyNot: string;
begin
  cmdOK.SetFocus; // make sure cbo exit events fire
  Application.ProcessMessages;
  SetCosignerRequired;
  ErrMsg := '';
  if cboNewTitle.ItemIEN = 0 then
    ErrMsg := ErrMsg + TX_REQ_TITLE
  else if FIDNoteTitlesOnly and
    (not CanTitleBeIDChild(cboNewTitle.ItemIEN, WhyNot)) then
    ErrMsg := ErrMsg + CRLF + WhyNot;
  if cboAuthor.ItemIEN = 0 then
    ErrMsg := ErrMsg + TX_REQ_AUTHOR;
  if not calSumm.IsValid then
    ErrMsg := ErrMsg + TX_REQ_REFDATE;
  if calSumm.IsValid and (calSumm.FMDateTime > FMNow) then
    ErrMsg := ErrMsg + TX_NO_FUTURE;
  if cboAttending.Visible and (cboAttending.ItemIEN = 0) then
    ErrMsg := ErrMsg + TX_REQ_COSIGNER;
  // if cboAttending.ItemIEN = User.DUZ                      then ErrMsg := TX_COS_SELF;

  // --------------------------------- REPLACED THIS BLOCK IN V27.37-----------------------------------------------
  /// if (cboAttending.ItemIEN > 0) and not IsUserAProvider(cboAttending.ItemIEN, FMNow) then
  // //if (cboAttending.ItemIEN > 0) and not CanCosign(cboNewTitle.ItemIEN, FDocType, cboAttending.ItemIEN) then
  // ErrMsg := cboAttending.Text + TX_COS_AUTH;
  // ------------------------------------ NEW CODE FOLLOWS --------------------------------------------------------
  if (cboAttending.ItemIEN > 0) then
    if ((not IsUserAUSRProvider(cboAttending.ItemIEN, FMNow)) or
      (not CanCosign(cboNewTitle.ItemIEN, FDocType, cboAttending.ItemIEN,
      calSumm.FMDateTime))) then
      ErrMsg := cboAttending.Text + TX_COS_AUTH;
  // -----------------------------------END OF NEW REPLACEMENT CODE -----------------------------------------------

  if pnlAdmission.Visible then
    with lstAdmissions do
    begin
      if not Assigned(Selected) then
        ErrMsg := TX_NO_ADMISSION
      else
      begin
       ItemText:= Strings[Selected.Index];
            if (Piece(ItemText, U, 7) = '1') then
            begin
              FVisitStr := Piece(ItemText, U, 2) + ';' +
                Piece(ItemText, U, 1) + ';H';
              if (OneNotePerVisit(cboNewTitle.ItemIEN, Patient.DFN, FVisitStr))
              then
              begin
                FEditIEN := 0;
                InfoBox(TX_NO_MORE_SUMMS, TC_NO_EDIT, MB_OK);
                Selected := nil;
              end;
            end
            else
            begin
              FAdmitDateTime := Piece(ItemText, U, 1);
              FLocation := StrToIntDef(Piece(ItemText, U, 2), 0);
              if (MakeFMDateTime(FAdmitDateTime) = -1) or (FLocation = 0) then
                ErrMsg := TX_BAD_ADMISSION
              else
                FLocationName := ExternalName(FLocation, 44);
            end;
        end;
    end;

  if ShowMsgOn(Length(ErrMsg) > 0, ErrMsg, TC_REQ_FIELDS) then
    Exit
  else
    ModalResult := mrOK;
end;

procedure TfrmDCSummProperties.cmdCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmDCSummProperties.cboNewTitleDropDownClose(Sender: TObject);
begin
  (* if FFixCursor then
    begin
    Screen.Cursor := crDefault;
    FFixCursor := FALSE;
    end;
    lblDateTime.Visible := True;
    lblAuthor.Visible   := True;
    lblCosigner.Visible := True; *)
end;


procedure TfrmDCSummProperties.lstAdmissionsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
{Using the message dialogs makes additonal calls to this event. We need to ignore the select sometimes}
const
  OldItem: TListItem = nil;
  CanSelect: Boolean = True;
var
  ItemText, ADType, ADLocation, ADDate: string;
  AnEditSumm: TEditDCSummRec;
  ActionSts: TActionRec;
begin
  if (Selected) and (Item.Focused) then
  begin
    if ((OldItem = nil) or (OldItem <> Item)) then
    begin
      CanSelect := True;
      with lstAdmissions do
      begin

            ItemText := Strings[Selected.Index];
            if (StrToIntDef(Piece(ItemText, U, 7), 0) = 2) then
            begin
              { Prompt for edit first - proceed as below if yes, else proceed as if '1' }
              ADType := Piece(ItemText, '^', 4);
              ADLocation := Piece(ItemText, '^', 3);
              ADDate := Piece(ItemText, '^', 5);
              if InfoBox(Format(TX_EDIT_EXISTING, [ADType,ADLocation,ADDate]), TC_EDIT_EXISTING, MB_YESNO) = MRYES
              then
              begin
                FillChar(AnEditSumm, SizeOf(AnEditSumm), 0);
                FEditIEN := StrToInt(Piece(ItemText, U, 6));
                ActOnDCDocument(ActionSts, FEditIEN, 'EDIT RECORD');
                if not ActionSts.Success then
                begin
                  InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
                  ClearSelection;
                  CanSelect := False;
                  exit;
                end;
                GetDCSummForEdit(AnEditSumm, FEditIEN);
                EditLines.Assign(AnEditSumm.Lines);
                cboNewTitle.InitLongList(AnEditSumm.TitleName);
                ListDCSummTitlesShort(cboNewTitle.Items);
                if AnEditSumm.Title > 0 then
                  cboNewTitle.SelectByIEN(AnEditSumm.Title);
                cboAuthor.InitLongList(AnEditSumm.DictatorName);
                if AnEditSumm.Dictator > 0 then
                  cboAuthor.SelectByIEN(AnEditSumm.Dictator);
                FastAssign(LoadDCUrgencies, cboUrgency.Items);
                cboUrgency.SelectByID('R');
                cboAttending.InitLongList(AnEditSumm.AttendingName);
                if AnEditSumm.Attending > 0 then
                  cboAttending.SelectByIEN(AnEditSumm.Attending);
                calSumm.FMDateTime := AnEditSumm.DictDateTime;
              end
              else // if user answers NO to edit existing document, can new one be created?
              begin
                FVisitStr := Piece(ItemText, U, 2) + ';' +
                  Piece(ItemText, U, 1) + ';H';
                if (OneNotePerVisit(cboNewTitle.ItemIEN, Patient.DFN, FVisitStr))
                then
                begin
                  FEditIEN := 0;
                  InfoBox(TX_NO_MORE_SUMMS, TC_NO_EDIT, MB_OK);
                  ClearSelection;
                  CanSelect := False;
                end;
              end;
            end
            else if Piece(ItemText, U, 7) = '1' then
            begin
              FVisitStr := Piece(ItemText, U, 2) + ';' +
                Piece(ItemText, U, 1) + ';H';
              if (OneNotePerVisit(cboNewTitle.ItemIEN, Patient.DFN, FVisitStr))
              then
              begin
                FEditIEN := 0;
                InfoBox(TX_NO_MORE_SUMMS, TC_NO_EDIT, MB_OK);
                ClearSelection;
                CanSelect := False;
              end;
            end
            else
            begin
              FEditIEN := 0;
              (* cboNewTitle.ItemIndex := -1;
                cboAttending.ItemIndex := -1;
                calSumm.FMDateTime := FMNow; *)
            end;

      end;
      OldItem := Item;
    end
    else if OldItem = Item then
    begin
      if Not CanSelect then
        lstAdmissions.ClearSelection;
      OldItem := nil;
    end;
  end;

end;

procedure TfrmDCSummProperties.cboNewTitleChange(Sender: TObject);
var
  IEN: Int64;
  name: string;
  Index: Integer;

begin
  inherited;
  index := cboAttending.ItemIndex;
  if index >= 0 then
  begin
    IEN := cboAttending.ItemIEN;
    name := cboAttending.DisplayText[index];
  end
  else
  begin
    name := '';
    IEN := 0;
  end;
  cboAttending.InitLongList(name);
  if index >= 0 then
    cboAttending.SelectByIEN(IEN);
end;

procedure TfrmDCSummProperties.cboNewTitleDblClick(Sender: TObject);
begin
  cmdOKClick(Self);
end;

procedure TfrmDCSummProperties.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;


end.
