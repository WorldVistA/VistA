unit uHelpManager;

interface

uses Windows;

type
  THelpManager = class(TObject)
  private
    InProgress: boolean;
    FHelpHWND: HWND;
    constructor Create;
  public
    HelpHandle: hWnd;
    destructor Destroy; override;
    class function GetInstance: THelpManager;
    function ExecHelp(Command: Word; Data: NativeInt; var CallHelp: Boolean): Boolean;
  end;

implementation

uses ORSystem, SysUtils, Dialogs, ShellAPI, Forms, uHelpNetworkMGR, system.UiTypes;

var
  HelpManager: THelpManager;

{=======================================================}
{  THelpManager - class used to manage the help system  }
{=======================================================}

type
  //  List of contexts currently in use
  THelpContexts = (hcNone,
                   hcLogin,
                   hcSignon,
                   hcConnect,
                   hcPatientSelectCbo,
                   hcPatientSelectForm,
                   hcCover,
                   hcProblem,
                   hcMeds,
                   hcOrders,
                   hcNotes,
                   hcConsults,
                   hcDischargeSumm,
                   hcLabs,
                   hcReports,
                   hcOptCoverDay,
                   hcOptCoverRemind,
                   hcOptOtherParam,
                   hcOptionsOK,
                   hcOptionsCancel,
                   hcOptionsApply,
                   hcOptDay,
                   hcOptDayLabDef,
                   hcOptDayVisitDef,
                   hcOptDayLabInp,
                   hcOptDayLabOutp,
                   hcOptStartStop,
                   hcOptRemind,
                   hcOptUp,
                   hcOptDown,
                   hcOptRemDelete,
                   hcOptRemAdd,
                   hcOptRemDisp,
                   hcOptRemNotDisp,
                   hcOptNotif,
                   hcOptNotifRemove,
                   hcOptNotifFlag,
                   hcOptSurrBtn,
                   hcOptNotifView,
                   hcOptOrderCheck,
                   hcOptOrderCheckView,
                   hcOptListTeam,
                   hcOptPatSelBtn,
                   hcOptPersList,
                   hcOptTeamBtn,
                   hcOptCombination,
                   hcOptPatSel,
                   hcOptPatSelListSrc,
                   hcOptPatSelSort,
                   hcOptPatSelProvider,
                   hcOptPatSelTreating,
                   hcOptPatSelTeam,
                   hcOptPatSelWard,
                   hcOptPatSelDayOfWeek,
                   hcOptPatSelVisitStart,
                   hcOptPatSelVisitStop,
                   hcOptList,
                   hcOptListAddByType,
                   hcOptListAddBy,
                   hcOptListPat,
                   hcOptListPersList,
                   hcOptListPersPat,
                   hcOptListAdd,
                   hcOptListAddAll,
                   hcOptListPersPatR,
                   hcOptListPersPatRA,
                   hcOptListSave,
                   hcOptListNew,
                   hcOptListDelete,
                   hcOptNewList,
                   hcOptNewListText,
                   hcOptTeam,
                   hcOptTeamPat,
                   hcOptTeamLst,
                   hcOptTeamUser,
                   hcOptTeamRemove,
                   hcOptTeamSubscr,
                   hcOptTeamPers,
                   hcOptTeamRestrict,
                   hcOptSurr,
                   hcOptSurrRemove,
                   hcOrderAlert,
                   hcOptSurrDate,
                   hcOptOther,
                   hcOptOtherTab,
                   hcOptOtherLast,
                   hcOptComb,
                   hcOptCombAddByType,
                   hcOptCombAddBy,
                   hcOptCombView,
                   hcOptCombAdd,
                   hcOptCombRemove,
                   hcOptNotesTab,
                   hcOptNotesBtn,
                   hcOptNotesTitle,
                   hcOptNotes,
                   hcOptNotesSave,
                   hcOptNotesVerify,
                   hcOptNotesAskSubj,
                   hcOptNotesCosigner,
                   hcOptTitle,
                   hcOptTitleDocClass,
                   hcOptTitleDocTitle,
                   hcOptTitleAdd,
                   hcOptTitleRemove,
                   hcOptTitleSave,
                   hcOptTitleDefault,
                   hcOptTitleYours,
                   hcOptCover,
                   hcOptOK,
                   hcOptCancel,
                   hcOptClose,
                   hcOptions,
                   hcTemplateEditor,
                   hcReminderDlg,
                   hcReminderTree,
                   hcReminderView,
                   hcUnknown);

const
  // Context ids for contexts
  CONTEXT_VALUES: array[THelpContexts] of integer = (    0, // hcNone
                                                         1, // hcLogin
                                                         2, // hcSignon
                                                         4, // hcConnect
                                                        10, // hcPatientSelectCbo
                                                        20, // hcPatientSelectForm
                                                      1000, // hcCover
                                                      2000, // hcProblem
                                                      3000, // hcMeds
                                                      4000, // hcOrders
                                                      5000, // hcNotes
                                                      6000, // hcConsults
                                                      7000, // hcDischargeSumm
                                                      8000, // hcLabs
                                                      9000, // hcReports
                                                      9001, // hcOptCoverDay
                                                      9002, // hcOptCoverRemind
                                                      9003, // hcOptOtherParam
                                                      9007, // hcOptionsOK    
                                                      9008, // hcOptionsCancel
                                                      9009, // hcOptionsApply
                                                      9010, // hcOptDay
                                                      9011, // hcOptDayLabDef
                                                      9012, // hcOptDayVisitDef
                                                      9013, // hcOptDayLabInp
                                                      9014, // hcOptDayLabOutp
                                                      9015, // hcOptStartStop
                                                      9020, // hcOptRemind
                                                      9021, // hcOptUp
                                                      9022, // hcOptDown
                                                      9023, // hcOptRemDelete
                                                      9024, // hcOptRemAdd
                                                      9025, // hcOptRemDisp
                                                      9026, // hcOptRemNotDisp
                                                      9030, // hcOptNotif
                                                      9031, // hcOptNotifRemove
                                                      9032, // hcOptNotifFlag
                                                      9033, // hcOptSurrBtn
                                                      9035, // hcOptNotifView
                                                      9040, // hcOptOrderCheck
                                                      9041, // hcOptOrderCheckView
                                                      9050, // hcOptListTeam
                                                      9051, // hcOptPatSelBtn
                                                      9052, // hcOptPersList
                                                      9053, // hcOptTeamBtn
                                                      9054, // hcOptCombination
                                                      9060, // hcOptPatSel
                                                      9061, // hcOptPatSelListSrc
                                                      9062, // hcOptPatSelSort
                                                      9063, // hcOptPatSelProvider
                                                      9064, // hcOptPatSelTreating
                                                      9065, // hcOptPatSelTeam
                                                      9066, // hcOptPatSelWard
                                                      9067, // hcOptPatSelDayOfWeek
                                                      9068, // hcOptPatSelVisitStart
                                                      9069, // hcOptPatSelVisitStop
                                                      9070, // hcOptList
                                                      9071, // hcOptListAddByType
                                                      9072, // hcOptListAddBy
                                                      9073, // hcOptListPat
                                                      9074, // hcOptListPersList
                                                      9075, // hcOptListPersPat
                                                      9076, // hcOptListAdd
                                                      9077, // hcOptListAddAll
                                                      9078, // hcOptListPersPatR
                                                      9079, // hcOptListPersPatRA
                                                      9080, // hcOptListSave
                                                      9081, // hcOptListNew
                                                      9082, // hcOptListDelete
                                                      9085, // hcOptNewList
                                                      9086, // hcOptNewListText
                                                      9090, // hcOptTeam
                                                      9091, // hcOptTeamPat
                                                      9092, // hcOptTeamLst
                                                      9093, // hcOptTeamUser
                                                      9094, // hcOptTeamRemove
                                                      9095, // hcOptTeamSubscr
                                                      9096, // hcOptTeamPers
                                                      9097, // hcOptTeamRestrict
                                                      9100, // hcOptSurr
                                                      9101, // hcOptSurrRemove
                                                      9102, // hcOrderAlert
                                                      9103, // hcOptSurrDate
                                                      9110, // hcOptOther
                                                      9111, // hcOptOtherTab
                                                      9112, // hcOptOtherLast
                                                      9120, // hcOptComb
                                                      9121, // hcOptCombAddByType
                                                      9122, // hcOptCombAddBy
                                                      9123, // hcOptCombView
                                                      9124, // hcOptCombAdd
                                                      9125, // hcOptCombRemove
                                                      9200, // hcOptNotesTab
                                                      9201, // hcOptNotesBtn
                                                      9202, // hcOptNotesTitle
                                                      9210, // hcOptNotes
                                                      9213, // hcOptNotesSave
                                                      9214, // hcOptNotesVerify
                                                      9215, // hcOptNotesAskSubj
                                                      9216, // hcOptNotesCosigner
                                                      9230, // hcOptTitle
                                                      9231, // hcOptTitleDocClass
                                                      9232, // hcOptTitleDocTitle
                                                      9233, // hcOptTitleAdd
                                                      9234, // hcOptTitleRemove
                                                      9235, // hcOptTitleSave
                                                      9236, // hcOptTitleDefault
                                                      9237, // hcOptTitleYours
                                                      9700, // hcOptCover
                                                      9996, // hcOptOK
                                                      9997, // hcOptCancel
                                                      9998, // hcOptClose
                                                      9999, // hcOptions
                                                     10000, // hcTemplateEditor
                                                     11100, // hcReminderDlg
                                                     11200, // hcReminderTree
                                                     11300, // hcReminderView
                                                       -1); // hcUnknown
  // Context html files for contexts
  CONTEXT_FILES: array[THelpContexts] of string = ('cprs.htm',                                     // hcNone
                                                   'Signing_In_to_CPRS.htm',                       // hcLogin
                                                   'cprs.htm',                                     // hcSignon
                                                   'cprs.htm',                                     // hcConnect
                                                   'cprs.htm',                                     // hcPatientSelectCbo
                                                   'Selecting_a_Patient.htm',                      // hcPatientSelectForm
                                                   'Overview__What_is_the_Cover_Sheet_.htm',       // hcCover
                                                   'Problem_List.htm',                             // hcProblem
                                                   'Viewing_Medications.htm',                      // hcMeds
                                                   'Viewing_orders.htm',                           // hcOrders
                                                   'Viewing_Progress_Notes.htm',                   // hcNotes
                                                   'Consults.htm',                                 // hcConsults
                                                   'Discharge_Summaries.htm',                      // hcDischargeSumm
                                                   'Viewing_Laboratory_Test_Results.htm',          // hcLabs
                                                   'Viewing_a_Report.htm',                         // hcReports
                                                   'Cover_Sheet_Date_Range_Defaults.htm',          // hcOptCoverDay
                                                   'cprs.htm',                                     // hcOptCoverRemind
                                                   'Other_Parameters.htm',                         // hcOptOtherParam
                                                   'cprs.htm',                                     // hcOptionsOK
                                                   'Cancel_button.htm',                            // hcOptionsCancel
                                                   'Apply_button.htm',                             // hcOptionsApply
                                                   'cprs.htm',                                     // hcOptDay
                                                   'cprs.htm',                                     // hcOptDayLabDef
                                                   'cprs.htm',                                     // hcOptDayVisitDef
                                                   'Inpatient_Days.htm',                           // hcOptDayLabInp
                                                   'Outpatient_Days.htm',                          // hcOptDayLabOutp
                                                   'Start-Stop.htm',                               // hcOptStartStop
                                                   'Clinical_Reminders.htm',                       // hcOptRemind
                                                   'Up_arrow.htm',                                 // hcOptUp
                                                   'Down_arrow.htm',                               // hcOptDown
                                                   'cprs.htm',                                     // hcOptRemDelete
                                                   'cprs.htm',                                     // hcOptRemAdd
                                                   'cprs.htm',                                     // hcOptRemDisp
                                                   'cprs.htm',                                     // hcOptRemNotDisp
                                                   'Notifications_Tab_(Tools___Options).htm',      // hcOptNotif
                                                   'Remove_Pending_Notifications.htm',             // hcOptNotifRemove
                                                   'cprs.htm',                                     // hcOptNotifFlag
                                                   'Surrogate_Settings.htm',                       // hcOptSurrBtn
                                                   'Notifications_list.htm',                       // hcOptNotifView
                                                   'cprs.htm',                                     // hcOptOrderCheck
                                                   'Order_Check_list.htm',                         // hcOptOrderCheckView
                                                   'cprs.htm',                                     // hcOptListTeam
                                                   'Patient_Selection_Defaults.htm',               // hcOptPatSelBtn
                                                   'Personal_Lists.htm',                           // hcOptPersList
                                                   'Teams_Information.htm',                        // hcOptTeamBtn
                                                   'Source_Combinations.htm',                      // hcOptCombination
                                                   'cprs.htm',                                     // hcOptPatSel
                                                   'List_Source.htm',                              // hcOptPatSelListSrc
                                                   'Sort_Order.htm',                               // hcOptPatSelSort
                                                   'Primary_Provider.htm',                         // hcOptPatSelProvider
                                                   'Treating_Specialty.htm',                       // hcOptPatSelTreating
                                                   'Team_Personal.htm',                            // hcOptPatSelTeam
                                                   'Ward.htm',                                     // hcOptPatSelWard
                                                   'Start-Stop_(Patient_Selection).htm',           // hcOptPatSelDayOfWeek
                                                   'Start-Stop_(Patient_Selection).htm',           // hcOptPatSelVisitStart
                                                   'cprs.htm',                                     // hcOptPatSelVisitStop
                                                   'cprs.htm',                                     // hcOptList
                                                   'Select_Patients_by.htm',                       // hcOptListAddByType
                                                   'Patient.htm',                                  // hcOptListAddBy
                                                   'Patients_to_add.htm',                          // hcOptListPat
                                                   'Personal_Lists_(Personal_Lists).htm',          // hcOptListPersList
                                                   'Patients_on_personal_list.htm',                // hcOptListPersPat
                                                   'Add_button_(Personal_Lists).htm',              // hcOptListAdd
                                                   'Add_All_button_(Personal_Lists).htm',          // hcOptListAddAll
                                                   'Remove_button_(Personal_Lists).htm',           // hcOptListPersPatR
                                                   'Remove_All_button_(Personal_Lists).htm',       // hcOptListPersPatRA
                                                   'Save_Changes_button_(Personal_Lists).htm',     // hcOptListSave
                                                   'New_List_button.htm',                          // hcOptListNew
                                                   'Delete_List_button.htm',                       // hcOptListDelete
                                                   'cprs.htm',                                     // hcOptNewList
                                                   'cprs.htm',                                     // hcOptNewListText
                                                   'cprs.htm',                                     // hcOptTeam
                                                   'Patients_on_selected_teams.htm',               // hcOptTeamPat
                                                   'Team_members.htm',                             // hcOptTeamLst
                                                   'You_are_on_these_teams.htm',                   // hcOptTeamUser
                                                   'Remove_yourself_from_this_team.htm',           // hcOptTeamRemove
                                                   'Subscribe_to_a_team.htm',                      // hcOptTeamSubscr
                                                   'Include_personal_lists.htm',                   // hcOptTeamPers
                                                   'Restrict_Team_List_View.htm',                  // hcOptTeamRestrict
                                                   'Surrogate.htm',                                // hcOptSurr
                                                   'Remove_Surrogate.htm',                         // hcOptSurrRemove
                                                   'Send_MailMan_bulletin.htm',                    // hcOrderAlert
                                                   'Surrogate_Date_Range.htm',                     // hcOptSurrDate
                                                   'cprs.htm',                                     // hcOptOther
                                                   'Initial_tab_when_CPRS_starts.htm',             // hcOptOtherTab
                                                   'Use_last_selected_tab.htm',                    // hcOptOtherLast
                                                   'cprs.htm',                                     // hcOptComb
                                                   'Select_Combination_source_by.htm',             // hcOptCombAddByType
                                                   'Ward_(Source_Combinations).htm',               // hcOptCombAddBy
                                                   'Combinations.htm',                             // hcOptCombView
                                                   'Add_button_(Source_Combinations).htm',         // hcOptCombAdd
                                                   'Remove_button_(Source_Combinations).htm',      // hcOptCombRemove
                                                   'cprs.htm',                                     // hcOptNotesTab
                                                   'Notes_button.htm',                             // hcOptNotesBtn
                                                   'Document_Titles_button.htm',                   // hcOptNotesTitle
                                                   'cprs.htm',                                     // hcOptNotes
                                                   'Interval_for_autosave.htm',                    // hcOptNotesSave
                                                   'Verify_note_title.htm',                        // hcOptNotesVerify
                                                   'Ask_subject.htm',                              // hcOptNotesAskSubj
                                                   'Default_cosigner.htm',                         // hcOptNotesCosigner
                                                   'cprs.htm',                                     // hcOptTitle
                                                   'Document_class.htm',                           // hcOptTitleDocClass
                                                   'Document_titles.htm',                          // hcOptTitleDocTitle
                                                   'Add_button_(Document_Titles).htm',             // hcOptTitleAdd
                                                   'Remove_button_(Document_Titles).htm',          // hcOptTitleRemove
                                                   'Save_Changes_(Document_Titles).htm',           // hcOptTitleSave
                                                   'Set_Default_Note_button.htm',                  // hcOptTitleDefault
                                                   'Your_list_of_titles.htm',                      // hcOptTitleYours
                                                   'cprs.htm',                                     // hcOptCover
                                                   'cprs.htm',                                     // hcOptOK
                                                   'Cancel_button_2.htm',                          // hcOptCancel
                                                   'Close_button.htm',                             // hcOptClose
                                                   'cprs.htm',                                     // hcOptions
                                                   'Document_Templates_(overview).htm',            // hcTemplateEditor
                                                   'The_Main_Reminders_Processing_Dialog.htm',     // hcReminderDlg
                                                   'The_Reminders_Button_Tree_View.htm',           // hcReminderTree
                                                   'Write_a_New_Progress_Note.htm',                // hcReminderView
                                                   'cprs.htm');                                    // hcUnknown


{===========================================}
{  Substitued for Application.OnHelp event  }
{  ---------------------------------------  }
{  Command  : Type of help command          }
{  Data     : Context                       }
{  CallHelp : Call Win help system          }
{  Returns true if help called              }
{===========================================}
function THelpManager.ExecHelp(Command: word; Data: NativeInt; var CallHelp: boolean): boolean;
var
//  hc: THelpContexts; // loop variable
//  errorcode: integer;
//  FilePath, FileName: string;
  CrRtn: Integer;
begin
  CallHelp := False; // don't run the win help system
  if not InProgress then begin
    InProgress := True;

    CrRtn := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
    LoadHelpFile(Application.HelpFile);
    finally
      Screen.Cursor := CrRtn;
    end;

    if Data > 0 then
      FHelpHWND := HtmlHelp(Application.Handle, PChar(Application.HelpFile), HH_HELP_CONTEXT, Data)
    else
      FHelpHWND := HtmlHelp(Application.Handle, PChar(Application.HelpFile), HH_DISPLAY_TOC, Data);

    {hc := hcNone;
    while (hc <> hcUnknown) and (CONTEXT_VALUES[hc] <> Data) do inc(hc); // loop through and find a context
    Filepath := FullToPathPart(Application.ExeName) + 'Help\';
    Filename := Filepath + CONTEXT_FILES[hc];
//    ShowMessage('Help: ' + inttostr(Data) + ' ' + Context_Files[hc]); errorcode := 33; // diagnostic
    errorcode := ShellExecute(HelpHandle, 'open', PChar(Filename), nil, nil, SW_SHOWNORMAL); // Tell windows to bring up the html file with the default browser
    case errorcode of
      0:                      ShowMessage('Help system: The operating system is out of memory or resources.');
      ERROR_FILE_NOT_FOUND:   ShowMessage('Help system: ' + CONTEXT_FILES[hc] + ' was not found in ' + FilePath + '.');
      ERROR_PATH_NOT_FOUND:   ShowMessage('Help system: ' + FilePath + ' was not found.');
      ERROR_BAD_FORMAT:       ShowMessage('Help system: The .exe file is invalid (non-Microsoft Win32� .exe or error in .exe image).');
      SE_ERR_ACCESSDENIED:    ShowMessage('Help system: The operating system denied access to ' + Filename + '.');
      SE_ERR_ASSOCINCOMPLETE: ShowMessage('Help system: The file name association is incomplete or invalid. (.htm)');
      SE_ERR_DDEBUSY:         ShowMessage('Help system: The Dynamic Data Exchange (DDE) transaction could not be completed because other DDE transactions were being processed.');
      SE_ERR_DDEFAIL:         ShowMessage('Help system: The DDE transaction failed.');
      SE_ERR_DDETIMEOUT:      ShowMessage('Help system: The DDE transaction could not be completed because the request timed out.');
      SE_ERR_DLLNOTFOUND:     ShowMessage('Help system: The specified dynamic-link library (DLL) was not found.');
      SE_ERR_NOASSOC:         ShowMessage('Help system: There is no application associated with the given file name extension. (.htm)');
      SE_ERR_OOM:             ShowMessage('Help system: There was not enough memory to complete the operation.');
      SE_ERR_SHARE:           ShowMessage('Help system: A sharing violation occurred.');
    end;
    Result := (errorcode >= 32);   }
    Result := true;
    InProgress := False;
  end else begin
    Result := True;
  end;
end;

{ THelpManager }

constructor THelpManager.Create;
begin
  inherited;
  HelpHandle := Application.Handle;
  InProgress := False;
end;

destructor THelpManager.Destroy;
begin
if (FHelpHWND <> 0) and IsWindow(FHelpHWND) then
  begin
    HtmlHelp(Application.Handle, nil, HH_CLOSE_ALL, 0);
    Sleep(0);
  end;
end;

class function THelpManager.GetInstance: THelpManager;
begin
  if not assigned(HelpManager) then
    HelpManager := THelpManager.Create;
  Result := HelpManager;
end;

initialization

finalization
  if assigned(HelpManager) then
    HelpManager.Free;

end.

