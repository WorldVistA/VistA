unit fCover;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPage, StdCtrls, ORCtrls, ExtCtrls, rOrders, ORClasses, Menus, rCover, fAllgyBox,
  VA508AccessibilityManager, fBase508Form; {REV}

type
  TfrmCover = class(TfrmPage)
    pnlBase: TPanel;
    pnlTop: TPanel;
    pnlNotTheBottom: TPanel;
    pnlMiddle: TPanel;
    pnlBottom: TPanel;
    sptTop: TSplitter;
    sptBottom: TSplitter;
    pnl_Not3: TPanel;
    pnl_Not8: TPanel;
    pnl_4: TPanel;
    pnl_5: TPanel;
    pnl_6: TPanel;
    pnl_7: TPanel;
    pnl_8: TPanel;
    spt_3: TSplitter;
    spt_4: TSplitter;
    spt_5: TSplitter;
    pnl_1: TPanel;
    pnl_2: TPanel;
    pnl_3: TPanel;
    spt_1: TSplitter;
    spt_2: TSplitter;
    lbl_1: TOROffsetLabel;
    lbl_2: TOROffsetLabel;
    lbl_4: TOROffsetLabel;
    lbl_5: TOROffsetLabel;
    lbl_6: TOROffsetLabel;
    lbl_7: TOROffsetLabel;
    lbl_8: TOROffsetLabel;
    lst_1: TORListBox;
    lst_2: TORListBox;
    lst_4: TORListBox;
    lst_5: TORListBox;
    lst_6: TORListBox;
    lst_7: TORListBox;
    lst_8: TORListBox;
    timPoll: TTimer;
    popMenuAllergies: TPopupMenu;
    popNewAllergy: TMenuItem;
    popNKA: TMenuItem;
    popEditAllergy: TMenuItem;
    popEnteredInError: TMenuItem;
    pnlFlag: TPanel;
    lstFlag: TORListBox;
    lblFlag: TOROffsetLabel;
    lbl_3: TOROffsetLabel;
    lst_3: TORListBox;
    sptFlag: TSplitter;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    procedure CoverItemClick(Sender: TObject);
    procedure timPollTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RemContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sptBottomCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure sptTopCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure spt_1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure spt_2CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure spt_3CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure spt_4CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure spt_5CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure popMenuAllergiesPopup(Sender: TObject);
    procedure popNewAllergyClick(Sender: TObject);
    procedure popNKAClick(Sender: TObject);
    procedure popEditAllergyClick(Sender: TObject);
    procedure popEnteredInErrorClick(Sender: TObject);
    procedure CoverItemExit(Sender: TObject);
    procedure lstFlagClick(Sender: TObject);
    procedure lstFlagKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    FCoverList: TCoverSheetList;
    popReminders: TORPopupMenu;
    FLoadingForDFN: string;  //*DFN*
    procedure RemindersChange(Sender: TObject);
    procedure GetPatientFlag;
    procedure LoadList(const StsTxt: string; ListCtrl: TObject;
      ARpc: String; ACase, AInvert: Boolean; ADatePiece: integer; ADateFormat, AParam1, AID, ADetail: String; Reminders: boolean = FALSE);
  public
    procedure popNewAllergyExt;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); override;       {REV}
    procedure UpdateAllergiesList;
    procedure UpdateVAAButton;
  end;

var
  frmCover: TfrmCover;
  VAAFlag: TStringList;
  MHVFlag: TStringList;
  VAA_DFN: string;
  PtIsVAA: boolean;
  PtIsMHV: boolean;

const
  CoverSplitters1 = 'frmCoverSplitters1';
  CoverSplitters2 = 'frmCoverSplitters2';

implementation

{$R *.DFM}

uses ORNet, ORFn, fRptBox, fVitals, fvit, fFrame, uCore, TRPCB, uConst, uInit,
  uReminders, rReminders, fARTAllgy, uOrPtf, fPatientFlagMulti, rODAllergy, rMisc,
  VA508AccessibilityRouter, VAUtils;

const
  TAG_PROB = 10;
  TAG_ALLG = 20;
  TAG_POST = 30;
  TAG_MEDS = 40;
  TAG_RMND = 50;
  TAG_LABS = 60;
  TAG_VITL = 70;
  TAG_VSIT = 80;
  RemID    = '50';

  TX_INACTIVE_ICDCODE = 'The ICD-9-CM code for this problem is inactive.' + CRLF + CRLF +
                     'Please correct this code using the ''Problems'' tab.';
  TC_INACTIVE_ICDCODE = 'Inactive ICD-9-CM code';
  TX_INACTIVE_10DCODE = 'The ICD-10-CM code for this problem is inactive.' + CRLF + CRLF +
                     'Please correct this code using the ''Problems'' tab.';
  TC_INACTIVE_10DCODE = 'Inactive ICD-10-CM code';
  TX_INACTIVE_SCTCODE = 'The SNOMED CT code for this problem is inactive.' + CRLF + CRLF +
                     'Please correct this code using the ''Problems'' tab.';
  TC_INACTIVE_SCTCODE = 'Inactive SNOMED CT code';

var
  uIPAddress: string;
  uARTCoverSheetParams: string;

procedure TfrmCover.popNewAllergyExt;
begin
  inherited;
  popNewAllergy.Click;
end;

procedure TfrmCover.ClearPtData;
{ clears all lists displayed on the cover sheet }
begin
  timPoll.Enabled := False;
  if Length(FLoadingForDFN) > 0 then StopCoverSheet(FLoadingForDFN, uIPAddress, frmFrame.Handle);  //*DFN*
  FLoadingForDFN := '';  //*DFN*
  inherited ClearPtData;
  lst_1.Clear;
  lst_2.Clear;
  lst_3.Clear;
  lst_4.Clear;
  lst_5.Clear;
  lst_6.Clear;
  lst_7.Clear;
  lst_8.Clear;
  pnl_1.Visible := false;
  pnl_2.Visible := false;
  pnl_3.Visible := false;
  pnl_4.Visible := false;
  pnl_5.Visible := false;
  pnl_6.Visible := false;
  pnl_7.Visible := false;
  pnl_8.Visible := false;
end;

procedure TfrmCover.LoadList(const StsTxt: string; ListCtrl: TObject;
  ARpc: String; ACase, AInvert: Boolean; ADatePiece: integer; ADateFormat, AParam1, AID, ADetail: String; Reminders: boolean = FALSE);
begin
  StatusText(StsTxt);
  if(ListCtrl is TORListBox) then
  begin
    ListGeneric((ListCtrl as TORListBox).Items, ARpc, ACase, AInvert, ADatePiece, ADateFormat, AParam1, ADetail, AID);
    if((ListCtrl as TORListBox).Items.Count = 0) then
      (ListCtrl as TORListBox).Items.Add(NoDataText(Reminders));
  end
  else
  begin
    ListGeneric(ListCtrl as TStrings, ARpc, ACase, AInvert, ADatePiece, ADateFormat, AParam1, ADetail, AID);
    if((ListCtrl as TStrings).Count = 0) then
      (ListCtrl as TStrings).Add(NoDataText(Reminders));
  end;
  StatusText('');
end;

procedure TfrmCover.DisplayPage;
{ loads the cover sheet lists if the patient has just been selected }
var
  DontDo, ForeGround: string;
  WaitCount: Integer;
  RemSL: TStringList;
  uCoverSheetList: TStringList;
  i, iRem: Integer;
  aIFN, aRPC, aCase, aInvert, aDatePiece, aDateFormat, aTextColor, aStatus, aParam1, aID, aQualifier, aTabPos, aName, aPiece, aDetail, x: string;
  bCase, bInvert: Boolean;
  iDatePiece: Integer;

(*  procedure LoadList(const StsTxt: string; ListCtrl: TObject;
    ARpc: String; ACase, AInvert: Boolean; ADatePiece: integer; ADateFormat, AParam1, AID, ADetail: String; Reminders: boolean = FALSE);
  begin
    StatusText(StsTxt);
    if(ListCtrl is TORListBox) then
    begin
      ListGeneric((ListCtrl as TORListBox).Items, ARpc, ACase, AInvert, ADatePiece, ADateFormat, AParam1, ADetail, AID);
      if((ListCtrl as TORListBox).Items.Count = 0) then
        (ListCtrl as TORListBox).Items.Add(NoDataText(Reminders));
    end
    else
    begin
      ListGeneric(ListCtrl as TStrings, ARpc, ACase, AInvert, ADatePiece, ADateFormat, AParam1, ADetail, AID);
      if((ListCtrl as TStrings).Count = 0) then
        (ListCtrl as TStrings).Add(NoDataText(Reminders));
    end;
    StatusText('');
  end;*)

  procedure WaitList(ListCtrl: TORListBox);
  begin
    ListCtrl.Clear;
    Inc(WaitCount);
    ListCtrl.Items.Add('0^Retrieving in background...');
    ListCtrl.Repaint;
  end;

begin
  inherited DisplayPage;
  iRem := -1;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  if InitPage then
    uIPAddress := DottedIPStr;
  if InitPatient then
    begin
      WaitCount := 0;
      if InteractiveRemindersActive then
      begin
        if(InitialRemindersLoaded) then
        begin
          DontDo := RemID+';';
          NotifyWhenRemindersChange(RemindersChange);
        end
        else
        begin
          DontDo := '';
          RemoveNotifyRemindersChange(RemindersChange);
        end;
      end;
      ForeGround := StartCoverSheet(uIPAddress, frmFrame.Handle,
                    DontDo, InteractiveRemindersActive);
      uCoverSheetList := TStringList.Create;
      LoadCoverSheetList(uCoverSheetList);
      for i := 0 to uCoverSheetList.Count - 1 do
        begin
          x := uCoverSheetList[i];
          aName := Piece(x,'^',2);
          aRPC := Piece(x,'^',6);
          aCase := Piece(x,'^',7);
          aInvert := Piece(x,'^',8);
          aDatePiece := Piece(x,'^',11);
          aDateFormat := Piece(x,'^',10);
          aTextColor := Piece(x,'^',9);
          aStatus := 'Searching for ' + Piece(x,'^',2) + '...';
          aParam1 := Piece(x,'^',12);
          aID := Piece(x,'^',1);         //TAG_PROB, TAG_RMND, ETC.
          aQualifier := Piece(x,'^',13);
          aTabPos := Piece(x,'^',14);
          aPiece := Piece(x,'^',15);
          aDetail := Piece(x,'^',16);
          aIFN := Piece(x,'^',17);
          bCase := FALSE;
          bInvert := FALSE;
          iDatePiece := 0;
          if aCase = '1' then bCase := TRUE;
          if aInvert = '1' then bInvert := TRUE;
          if Length(aDatePiece) > 0 then iDatePiece := StrToInt(aDatePiece);
          if Length(aTextColor) > 0 then aTextColor := 'cl' + aTextColor;
          // Assign properties to components
          FCoverList.CVlbl(i).Caption := aName;
          FCoverList.CVlst(i).Caption := aName;
          if Length(aTabPos) > 0 then FCoverList.CVlst(i).TabPositions := aTabPos;
          if Length(aTextColor) > 0 then FCoverList.CVlst(i).Font.Color :=
                                            Get508CompliantColor(StringToColor(aTextColor));
          if Length(aPiece) > 0 then FCoverList.CVlst(i).Pieces := aPiece;
          FCoverList.CVlst(i).Tag := StrToInt(aID);
          if(aID <> RemID) then
          begin
            if((aID = '20') or (Pos(aID + ';', ForeGround) > 0)) then
              LoadList(aStatus, FCoverList.CVlst(i), aRpc, bCase, bInvert, iDatePiece, aDateFormat, aParam1, aID, aDetail)
            else
              Waitlist(FCoverList.CVlst(i));
            if (aID = '20') and ARTPatchInstalled then with FCoverList.CVlst(i) do
              begin
                uARTCoverSheetParams := x;
                PopupMenu := popMenuAllergies;
                RightClickSelect := True;
                popMenuAllergies.PopupComponent := FCoverList.CVlst(i);
              end;
          end;
          FCoverList.CVpln(i).Visible := true;
          if aID = RemID then
            begin
              FCoverList.CVLst(i).OnContextPopup := RemContextPopup;
              FCoverList.CVlst(i).RightClickSelect := True;
              iRem := FCoverList.CVlst(i).ComponentIndex;
              if InteractiveRemindersActive then
                begin
                  if(InitialRemindersLoaded) then
                    CoverSheetRemindersInBackground := FALSE
                  else
                    begin
                      InitialRemindersLoaded := TRUE;
                      CoverSheetRemindersInBackground := (Pos(aID + ';', ForeGround) = 0);
                      if(not CoverSheetRemindersInBackground) then
                        begin
                          //InitialRemindersLoaded := TRUE;
                          RemSL := TStringList.Create;
                          try
                            LoadList(aStatus, RemSL, aRpc, bCase, bInvert, iDatePiece, aDateFormat, aParam1, aID, aDetail);
                            RemindersEvaluated(RemSL);
                          finally;
                            RemSL.Free;
                          end;
                          NotifyWhenRemindersChange(RemindersChange);
                        end
                      else
                          Waitlist(FCoverList.CVlst(i));
                    end;
                end
              else
                if Pos(aID + ';', ForeGround) > 0 then
                    LoadList(aStatus, FCoverList.CVlst(i), aRpc, bCase, bInvert, iDatePiece, aDateFormat, aParam1, aID, aDetail, TRUE)
                else
                    Waitlist(FCoverList.CVlst(i));
              if WaitCount > 0 then
                begin
                  FLoadingForDFN := Patient.DFN;
                  timPoll.Enabled := True;
                end
              else FLoadingForDFN := '';  //*DFN*
              if InteractiveRemindersActive then
                begin
                  RemindersStarted := TRUE;
                  LoadReminderData(CoverSheetRemindersInBackground);
                end;
            end;
          if WaitCount > 0 then
            begin
              FLoadingForDFN := Patient.DFN;
              timPoll.Enabled := True;
            end
          else FLoadingForDFN := '';  //*DFN*
        end;
      FocusFirstControl;
      spt_2.Left := pnl_Not3.Left + pnl_Not3.Width;
      spt_5.Left := pnl_Not8.Left + pnl_Not8.Width;
      GetPatientFlag;
    end;
  if InitPage then
    begin
      popReminders := TORPopupMenu.Create(Self);
      if InteractiveRemindersActive then
        begin
          SetReminderPopupCoverRoutine(popReminders);
          if iRem > -1 then
            (frmCover.Components[iRem] as TORListBox).PopupMenu := popReminders;
        end
      else
        begin
          if iRem > -1 then
            begin
              (frmCover.Components[iRem] as TORListBox).RightClickSelect := FALSE;
              (frmCover.Components[iRem] as TORListBox).OnMouseUp := nil;
            end;
        end;
    end;
end;

procedure TfrmCover.SetFontSize(NewFontSize: Integer);
var
  i: integer;
begin
  inherited;
  with frmCover do
          for i := ComponentCount - 1 downto 0 do
            begin
              if Components[i] is TORListBox then
                begin
                  case Components[i].Tag of
                    30: (Components[i] as TORListBox).Font.Size := NewFontSize;
                  end;
                end;
            end;
end;

procedure TfrmCover.CoverItemClick(Sender: TObject);
{ displays details for an item that has been clicked on the cover sheet }
var
  i: integer;
  aDetail: string;
  lb: TORListBox;
begin
  inherited;
  lb := TORListBox(Sender);
  if lb.ItemIndex <> -1 then begin
    aDetail := Uppercase(Piece(lb.Items[lb.ItemIndex],'^',12));
    case lb.Tag of
      TAG_PROB:
             if lb.ItemIEN > 0  then begin
               i := lb.ItemIndex;
               if Piece(lb.Items[lb.ItemIndex], U, 13) = '#' then
               begin
                 if Piece(lb.Items[lb.ItemIndex], U, 16) = '10D' then
                   InfoBox(TX_INACTIVE_10DCODE, TC_INACTIVE_10DCODE, MB_ICONWARNING or MB_OK)
                 else
                   InfoBox(TX_INACTIVE_ICDCODE, TC_INACTIVE_ICDCODE, MB_ICONWARNING or MB_OK);
               end
               else if Piece(lb.Items[lb.ItemIndex], U, 13) = '$' then
                 InfoBox(TX_INACTIVE_SCTCODE, TC_INACTIVE_SCTCODE, MB_ICONWARNING or MB_OK);
               lb.ItemIndex := i;
               ReportBox(DetailGeneric(lb.ItemIEN, lb.ItemID, aDetail), lb.DisplayText[lb.ItemIndex], True);
             end;
      TAG_ALLG:
    { TODO -oRich V. -cART/Allergy : What to do about NKA only via right-click menu?  Add here? }
             if lb.ItemIEN > 0 then begin
               if ARTPatchInstalled then begin
                 AllergyBox(DetailGeneric(lb.ItemIEN, lb.ItemID, aDetail), lb.DisplayText[lb.ItemIndex], True, lb.ItemIEN);
                 //TDP - Fixed allergy form focus problem
                 if (frmARTAllergy <> nil) and frmARTAllergy.Showing then frmARTAllergy.SetFocus;
               end else begin
                 ReportBox(DetailGeneric(lb.ItemIEN, lb.ItemID, aDetail), lb.DisplayText[lb.ItemIndex], True);
               end;
             end;
      TAG_POST:
             if lb.DisplayText[lb.ItemIndex] = 'Allergies' then begin
               ReportBox(DetailPosting('A'), lb.DisplayText[lb.ItemIndex], True);
             end else if lb.ItemID <> '' then begin
               NotifyOtherApps(NAE_REPORT, 'TIU^' + lb.ItemID);
               ReportBox(DetailPosting(lb.ItemID), lb.DisplayText[lb.ItemIndex], True);
             end;
      TAG_MEDS:
             if (lb.ItemID <> '') and (lb.ItemID <> '0') then begin
               ReportBox(DetailMed(lb.ItemID), lb.DisplayText[lb.ItemIndex], True);
             end;
      TAG_RMND:
             if lb.ItemIEN > 0  then begin
               ReportBox(DetailReminder(lb.ItemIEN), ClinMaintText + ': ' + lb.DisplayText[lb.ItemIndex], True);
             end;
      TAG_LABS:
             if (lb.ItemID <> '') and (Piece(lb.ItemID,';',1) <> '0') and
                (not ContainsAlpha(Piece(lb.ItemID,';',1))) then begin
               ReportBox(DetailGeneric(lb.ItemIEN, lb.ItemID, aDetail), lb.DisplayText[lb.ItemIndex], True);
             end;
      TAG_VITL:
             if lb.ItemID <> '' then begin
               //agp prevent double clicking on Vitals which can cause CPRS to shut down when exiting vitals
               TORListBox(Sender).Enabled := false;
               SelectVitals(Piece(lb.DisplayText[lb.ItemIndex],Char(9),1)); //Char(9) = Tab Character
               ClearPtData;
               //agp set InitialRemindersLoaded to False only if reminders are still evaluating. This prevent
               //a problem with reminders not finishing the evaluation if the Vital DLL is launch and it prevent
               //an automatic re-evaluation of reminders if reminders are done evaluating.
               if RemindersEvaluatingInBackground = true then  InitialRemindersLoaded := False;
               DisplayPage;
               TORListBox(Sender).Enabled := True;
             end;
      TAG_VSIT:
             if (lb.ItemID <> '') and (lb.ItemID <> '0') then begin
               ReportBox(DetailGeneric(lb.ItemIEN, lb.ItemID, aDetail), lb.DisplayText[lb.ItemIndex], True);
             end
    else
      //don't try to display a detail report
    end;
  end;
  lb.SetFocus;
  if uInit.TimedOut then                       // Fix for CQ: 8011
    Abort
  else
    lb.ItemIndex := -1;
end;

procedure TfrmCover.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  timPoll.Enabled := False;
  if Length(FLoadingForDFN) > 0 then StopCoverSheet(FLoadingForDFN, uIPAddress, frmFrame.Handle);  //*DFN*
  FLoadingForDFN := '';  //*DFN*
end;

procedure TfrmCover.timPollTimer(Sender: TObject);
const
  RemUnchanged = '[{^Reminders @ @ @ Unchanged^]}';

var
  Done: Boolean;
  ReminderSL: TStringList;
  ProbSL, PostSL, MedsSL, RemSL, LabsSL, VitSL, VisitSL: TStringList;
  i, iProb, iPost, iMeds, iRem, iLabs, iVit, iVisit: integer;
begin
  inherited;
  iProb := -1;
  iPost := -1;
  iMeds := -1;
  iRem := -1;
  iLabs := -1;
  iVit := -1;
  iVisit := -1;
  with frmCover do
    for i := ComponentCount - 1 downto 0 do
      begin
        if Components[i] is TORListBox then
          begin
            case Components[i].Tag of
              TAG_PROB: iProb := i;
              TAG_POST: iPost := i;
              TAG_MEDS: iMeds := i;
              TAG_RMND: iRem := i;
              TAG_LABS: iLabs := i;
              TAG_VITL: iVit := i;
              TAG_VSIT: iVisit := i;
            end;
          end;
      end;
  ProbSL := TStringList.Create;
  PostSL := TStringList.Create;
  MedsSL := TStringList.Create;
  RemSL := TStringList.Create;
  LabsSL := TStringList.Create;
  VitSL := TStringList.Create;
  VisitSL := TStringList.Create;
  if InteractiveRemindersActive then
  begin
    ReminderSL := TStringList.Create;
    try
      ReminderSL.Add(RemUnchanged);
      ListAllBackGround(Done, ProbSL, PostSL, MedsSL, ReminderSL, LabsSL, VitSL, VisitSL, uIPAddress, frmFrame.Handle);
      if (iProb > -1) and (ProbSL.Count > 0) then FastAssign(ProbSL, (Components[iProb] as TORListBox).Items);
      if (iPost > -1) and (PostSL.Count > 0) then FastAssign(PostSL, (Components[iPost] as TORListBox).Items);
      if (iMeds > -1) and (MedsSL.Count > 0) then FastAssign(MedsSL, (Components[iMeds] as TORListBox).Items);
      if (iLabs > -1) and (LabsSL.Count > 0) then FastAssign(LabsSL, (Components[iLabs] as TORListBox).Items);
      if (iVit > -1) and (VitSL.Count > 0) then FastAssign(VitSL, (Components[iVit] as TORListBox).Items);
      if (iVisit > -1) and (VisitSL.Count > 0) then FastAssign(VisitSL, (Components[iVisit] as TORListBox).Items);
      // since this RPC is connected to a timer, clear the results each time to make sure that
      // the results aren't passed to another RPC in the case that there is an error
      RPCBrokerV.ClearResults := True;
      if Done then
      begin
        timPoll.Enabled := False;
        FLoadingForDFN := '';  //*DFN*
      end;
      if(not InitialRemindersLoaded) and
        (ReminderSL.Count <> 1) or (ReminderSL[0] <> RemUnchanged) then
      begin
        CoverSheetRemindersInBackground := FALSE;
//        InitialRemindersLoaded := TRUE;
        RemindersEvaluated(ReminderSL);
        NotifyWhenRemindersChange(RemindersChange);
      end;
    finally
      ReminderSL.Free;
    end;
  end
  else
  begin
    ListAllBackGround(Done, ProbSL, PostSL, MedsSL, RemSL, LabsSL, VitSL, VisitSL, uIPAddress, frmFrame.Handle);
    if (iProb > -1) and (ProbSL.Count > 0) then FastAssign(ProbSL, (Components[iProb] as TORListBox).Items);
    if (iPost > -1) and (PostSL.Count > 0) then FastAssign(PostSL, (Components[iPost] as TORListBox).Items);
    if (iMeds > -1) and (MedsSL.Count > 0) then FastAssign(MedsSL, (Components[iMeds] as TORListBox).Items);
    if (iRem > -1) and (RemSL.Count > 0) then FastAssign(RemSL, (Components[iRem] as TORListBox).Items);
    if (iLabs > -1) and (LabsSL.Count > 0) then FastAssign(LabsSL, (Components[iLabs] as TORListBox).Items);
    if (iVit > -1) and (VitSL.Count > 0) then FastAssign(VitSL, (Components[iVit] as TORListBox).Items);
    if (iVisit > -1) and (VisitSL.Count > 0) then FastAssign(VisitSL, (Components[iVisit] as TORListBox).Items);
    // since this RPC is connected to a timer, clear the results each time to make sure that
    // the results aren't passed to another RPC in the case that there is an error
    RPCBrokerV.ClearResults := True;
    if Done then
    begin
      timPoll.Enabled := False;
      FLoadingForDFN := '';  //*DFN*
    end;
  end;
  ProbSL.Free;
  PostSL.Free;
  MedsSL.Free;
  RemSL.Free;
  LabsSL.Free;
  VitSL.Free;
  VisitSL.Free;
end;

procedure TfrmCover.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);    {REV}
var
  i: integer;
begin
  case OrderAction of
  ORDER_SIGN:
    begin
      with frmCover do
          for i := ComponentCount - 1 downto 0 do
            begin
              if Components[i] is TORListBox then
                begin
                  case Components[i].Tag of
                    20: UpdateAllergiesList;
                    30: ListPostings((Components[i] as TORListBox).Items);
                  end;
                end;
            end;
    end;
  end;
end;

procedure TfrmCover.RemindersChange(Sender: TObject);
var
  i: integer;
  tmp: string;
  lb: TORListBox;

begin
  lb := nil;
  with frmCover do
    for i := ComponentCount - 1 downto 0 do
    begin
      if (Components[i] is TORListBox) and (Components[i].Tag = TAG_RMND) then
      begin
        lb := (Components[i] as TORListBox);
        break;
      end;
    end;
  if assigned(lb) then
  begin
    lb.Clear;
   //i := -1;
    //AGP Change 26.8 this changes allowed Reminders to display on the coversheet
    //even if they had an error on evaluation
    for i := 0 to ActiveReminders.Count-1 do
      begin
        if Piece(ActiveReminders.Strings[i],U,6)='1' then
           begin
             tmp := ActiveReminders[i];
             SetPiece(tmp, U, 3, FormatFMDateTimeStr('mmm dd,yy', Piece(tmp, U, 3)));
             lb.Items.Add(tmp);
           end;
        if Piece(ActiveReminders.Strings[i],U,6)='3' then
           begin
             tmp := ActiveReminders[i];
             SetPiece(tmp, U, 3, 'Error');
             lb.Items.Add(tmp);
           end;
        if Piece(ActiveReminders.Strings[i],U,6)='4' then
           begin
             tmp := ActiveReminders[i];
             SetPiece(tmp, U, 3, 'CNBD');
             lb.Items.Add(tmp);
           end;
      end;
      //AGP End Change for 26.8
    if(RemindersEvaluatingInBackground) then
      lb.Items.Insert(0,'0^Evaluating Reminders...')
    //AGP added code below to change the reminder panel picture if the clock has not stop by this point. CQ
    else if(lb.Items.Count = 0) and (RemindersStarted) then
      begin
        lb.Items.Add(NoDataText(TRUE));
        if frmFrame.anmtRemSearch.Visible = true then
          begin
            frmFrame.anmtRemSearch.Visible := FALSE;
            frmFrame.imgReminder.Visible := TRUE;
            frmFrame.imgReminder.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMP_REMINDERS_APPLICABLE');
            frmFrame.anmtRemSearch.Active := FALSE;
          end;
      end
    else if (lb.Items.Count > 0) and (RemindersStarted) and (frmFrame.anmtRemSearch.Visible = true) then
       begin
            frmFrame.anmtRemSearch.Visible := FALSE;
            frmFrame.imgReminder.Visible := TRUE;
            frmFrame.imgReminder.Picture.Bitmap.LoadFromResourceName(hInstance, 'BMP_REMINDERS_DUE');
            frmFrame.anmtRemSearch.Active := FALSE;
       end;
  end;
end;

Procedure TfrmCover.RemContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  idx: integer;
  i, iRem: integer;
begin
  inherited;
  Handled := TRUE;
  iRem := -1;
  with frmCover do
    for i := ComponentCount - 1 downto 0 do
      begin
        if Components[i] is TORListBox then
          begin
            case Components[i].Tag of
              TAG_RMND: iRem := i;
            end;
          end;
      end;
  if iRem > -1 then
    if ((frmCover.Components[iRem] as TORListBox).ItemIndex >= 0) then
      begin
        idx := StrToIntDef(Piece((frmCover.Components[iRem] as TORListBox).Items[(frmCover.Components[iRem] as TORListBox).ItemIndex],U,1),0);
        if(idx <> 0) then
        begin
          popReminders.Data := RemCode + (frmCover.Components[iRem] as TORListBox).Items[(frmCover.Components[iRem] as TORListBox).ItemIndex];
          Handled := FALSE;
        end;
      end;
end;

procedure TfrmCover.FormCreate(Sender: TObject);
begin
  inherited;
  PageID := CT_COVER;
  FCoverList := TCoverSheetList.Create;
  FCoverList.Add(pnl_1, lbl_1, lst_1);
  FCoverList.Add(pnl_2, lbl_2, lst_2);
  FCoverList.Add(pnl_3, lbl_3, lst_3);
  FCoverList.Add(pnl_4, lbl_4, lst_4);
  FCoverList.Add(pnl_5, lbl_5, lst_5);
  FCoverList.Add(pnl_6, lbl_6, lst_6);
  FCoverList.Add(pnl_7, lbl_7, lst_7);
  FCoverList.Add(pnl_8, lbl_8, lst_8);
end;

procedure TfrmCover.FormDestroy(Sender: TObject);
begin
  inherited;
  FCoverList.Free;
end;

procedure TfrmCover.FormShow(Sender: TObject);
begin
  inherited;
  //If a Dx was added to the PL, Update the Problem List on the Coversheet
  if Changes.RefreshCoverPL then
  begin
    ListActiveProblems(lst_1.Items);
    Changes.RefreshCoverPL := False;
  end;
end;

procedure TfrmCover.sptBottomCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  inherited;
    if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.sptTopCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
    if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.spt_1CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.spt_2CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.spt_3CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.spt_4CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.spt_5CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if NewSize < 50 then
      Newsize := 50;
end;

procedure TfrmCover.popMenuAllergiesPopup(Sender: TObject);
const
  NO_ASSESSMENT = 'No Allergy Assessment';
var
  AListBox: TORListBox;
  x: string;
begin
  inherited;
  AListBox := (popMenuAllergies.PopupComponent as TORListBox);
  popEditAllergy.Enabled := (AListBox.ItemIEN > 0) and IsARTClinicalUser(x);
  popEnteredInError.Enabled := (AListBox.ItemIEN > 0) and IsARTClinicalUser(x);
  popNKA.Enabled := (AListBox.Items.Count = 1) and
                    (Piece(AListBox.Items[0], U, 2) = NO_ASSESSMENT);
                    //and  IsARTClinicalUser(x);           v26.12
  popNewAllergy.Enabled := True;  //IsARTClinicalUser(x);  v26.12
 end;

procedure TfrmCover.popNewAllergyClick(Sender: TObject);
const
  NEW_ALLERGY = True;
  ENTERED_IN_ERROR = True;
begin
  inherited;
  EnterEditAllergy(0, NEW_ALLERGY, not ENTERED_IN_ERROR);
end;

procedure TfrmCover.popNKAClick(Sender: TObject);
var
  Changed: boolean;
begin
  inherited;
  Changed := EnterNKAForPatient;
  if Changed then UpdateAllergiesList;
end;

procedure TfrmCover.popEditAllergyClick(Sender: TObject);
const
  NEW_ALLERGY = True;
  ENTERED_IN_ERROR = True;
begin
  inherited;
  EnterEditAllergy((popMenuAllergies.PopupComponent as TORListBox).ItemIEN, not NEW_ALLERGY, not ENTERED_IN_ERROR);
end;

procedure TfrmCover.popEnteredInErrorClick(Sender: TObject);
begin
  inherited;
  MarkEnteredInError((popMenuAllergies.PopupComponent as TORListBox).ItemIEN);
end;

procedure TfrmCover.UpdateAllergiesList;
var
  bCase, bInvert: boolean;
  iDatePiece: integer ;
  x, aRPC, aDateFormat, aParam1, aID, aDetail, aStatus, aName, aCase, aInvert, aDatePiece, aTextColor, aQualifier, aTabPos, aPiece, aIFN: string;
begin
  x := uARTCoverSheetParams;
  if x = '' then exit;
  aName := Piece(x,'^',2);
  aRPC := Piece(x,'^',6);
  aCase := Piece(x,'^',7);
  aInvert := Piece(x,'^',8);
  aDatePiece := Piece(x,'^',11);
  aDateFormat := Piece(x,'^',10);
  aTextColor := Piece(x,'^',9);
  aStatus := 'Searching for ' + Piece(x,'^',2) + '...';
  aParam1 := Piece(x,'^',12);
  aID := Piece(x,'^',1);         //TAG_PROB, TAG_RMND, ETC.
  aQualifier := Piece(x,'^',13);
  aTabPos := Piece(x,'^',14);
  aPiece := Piece(x,'^',15);
  aDetail := Piece(x,'^',16);
  aIFN := Piece(x,'^',17);
  bCase := FALSE;
  bInvert := FALSE;
  iDatePiece := 0;
  if aCase = '1' then bCase := TRUE;
  if aInvert = '1' then bInvert := TRUE;
  if Length(aDatePiece) > 0 then iDatePiece := StrToInt(aDatePiece);
  if Length(aTextColor) > 0 then aTextColor := 'cl' + aTextColor;
  // Assign properties to components
  if Length(aTabPos) > 0 then (popMenuAllergies.PopupComponent as TORListBox).TabPositions := aTabPos;
  if Length(aTextColor) > 0 then (popMenuAllergies.PopupComponent as TORListBox).Font.Color :=
                                                      Get508CompliantColor(StringToColor(aTextColor));
  if Length(aPiece) > 0 then (popMenuAllergies.PopupComponent as TORListBox).Pieces := aPiece;
  (popMenuAllergies.PopupComponent as TORListBox).Tag := StrToInt(aID);
  LoadList(aStatus, (popMenuAllergies.PopupComponent as TORListBox), aRpc, bCase, bInvert, iDatePiece, aDateFormat, aParam1, aID, aDetail);
  with frmFrame do
    begin
      lblPtCWAD.Caption := GetCWADInfo(Patient.DFN);
      if Length(lblPtCWAD.Caption) > 0
        then lblPtPostings.Caption := 'Postings'
        else lblPtPostings.Caption := 'No Postings';
      pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
    end;
end;

procedure TfrmCover.CoverItemExit(Sender: TObject);
begin
  with Sender as TORListBox do
    Selected[ItemIndex] := False;
  inherited;
end;

procedure TfrmCover.GetPatientFlag;
begin
  pnlFlag.Visible := HasFlag;
  sptFlag.Visible := HasFlag;
  FastAssign(FlagList, lstFlag.Items);
end;

procedure TfrmCover.lstFlagClick(Sender: TObject);
begin
  if lstFlag.ItemIndex >= 0 then
    ShowFlags(lstFlag.ItemID);
  lstFlag.ItemIndex := -1;
end;

procedure TfrmCover.lstFlagKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    lstFlagClick(Self);
end;

procedure TfrmCover.UpdateVAAButton;
const
  MHVLabelOrigTop = 3;
  PtInsLabelOrigTop = 27;
//var
//  PtIsVAA: boolean;
//  PtIsMHV: boolean;
begin
//VAA & MHV
  PtIsVAA := false;
  PtIsMHV := false;

  VAAFlag := TStringList.Create;
  MHVFlag := TStringList.Create;
  VAA_DFN := Patient.DFN;
  tCallV(VAAFlag, 'ORVAA VAA', [VAA_DFN]);
  tCallV(MHVFlag, 'ORWMHV MHV', [VAA_DFN]);
  if VAAFlag[0] <> '0' then
     begin
     PtIsVAA := true;

     with frmFrame do
        begin
        laVAA2.Caption := Piece(VAAFlag[0], '^', 1);
        laVAA2.Hint := Piece(VAAFlag[0], '^', 2); //CQ7626 was piece '6'
        end;
     end
  else
     begin
     with frmFrame do
        begin
        laVAA2.Caption := #0;
        laVAA2.Hint := 'No active insurance'; //CQ7626 added this line
        end;
     end;

  //MHV flag
  if MHVFlag[0] <> '0' then
     begin
     PtIsMHV := true;

      with frmFrame do
        begin
         laMHV.Caption := Piece(MHVFlag[0], '^', 1);
         laMHV.Hint := Piece(MHVFlag[0], '^', 2);

         if VAAFlag[0] = '0' then
           laMHV.Caption := 'MHV';
        end;
     end
  else
     begin
     with frmFrame do
        begin
        laMHV.Caption := #0;
        laMHV.Hint := 'No MyHealthyVet data'; //CQ7626 added this line
        end;
     end;

  with frmFrame do
     begin
     //Modified this 'with' section for CQ7783
     paVAA.Hide; //Start by hiding it.  Show it only if one of the conditions below is true, else it stays invisible.
     paVAA.Height := pnlPrimaryCare.Height;

     if ((PtIsVAA and PtIsMHV)) then  //CQ7411 - this line
        begin
        laMHV.Top := paVAA.Top;
        laMHV.Width := paVAA.Width - 1;
        laMHV.Height := (paVAA.ClientHeight div 2) - 1;
        laMHV.Visible := true;

        laVAA2.Top := laMHV.Top + laMHV.Height + 1;
        laVAA2.Width := paVAA.Width - 1;
        laVAA2.Height := (paVAA.ClientHeight div 2);
        laVAA2.Visible := true;

        paVAA.Show;
        end
     else
        if ((PtIsMHV and (not PtIsVAA))) then
           begin
           laMHV.Top := paVAA.Top;
           paVAA.Height := pnlPrimaryCare.Height;
           laMHV.Height := paVAA.ClientHeight - 1;
           laMHV.Visible := true;
           laVAA2.Visible  := false;
           paVAA.Show;
           end
     else
        if ((PtIsVAA and (not PtIsMHV))) then
           begin
           laVAA2.Top := paVAA.Top;
           paVAA.Height := pnlPrimaryCare.Height-2;
           laVAA2.Height := paVAA.ClientHeight - 1;
           laVAA2.Width := paVAA.Width - 1;
           laVAA2.Visible := true;
           laMHV.Visible := false;

           paVAA.Show;
           end
     else begin
      LaVAA2.Visible := False;
      LaMHV.Visible := False;
      PaVAA.Hide;

     end;
  end; //with
//end VAA & MHV
end;


initialization
  SpecifyFormIsNotADialog(TfrmCover);

finalization
  if Assigned(fCover.VAAFlag) then fCover.VAAFlag.Free; //VAA

end.

