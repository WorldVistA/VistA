unit oPDMPData;

interface

uses
  Classes, Winapi.Windows, Winapi.Messages, System.SysUtils, vcl.ExtCtrls, ORFn;

type
  TpdmpDataObject = class(TObject)
  private
    fLoadAttempt: Integer;
    fDataLoaded: Boolean;
    fStatus: Integer;
    fAuthorizedUserIEN: string;
    fAuthorizedUserName: string;
    fErrorOccurred: string;
    fEncounterLocation: string;
    fEncounterProviderIEN: string;
    fEncounterProviderName: string;
    fHasDEA: Boolean;
    fSignOnUserIEN: string;
    fSignOnUserName: string;
    fStatusManager: HWND;
    fPatIEN: string;
    fPatName: string;
    fPDMPList: TStrings;
    fVisitString: string;
    fVistATask: String;
    fPDMPReportURL: String;
    fLongMessage: String;
    fNoteIEN: String;

    procedure NotifyStatusManager(aMessage, aW, aL: Integer);
    procedure setVistATask(aValue: String);
    procedure setStatusManager(aHWND: HWND);

    function getNoteHeader: String;
    function getReportURL: String;
  public
    pdmpTimer: TTimer;

    constructor Create;
    destructor Destroy; override;

    property pdmpStatus: Integer read fStatus;
    property LongMessage: String read fLongMessage;

    property AuthorizedUserIEN: String read fAuthorizedUserIEN
      write fAuthorizedUserIEN;
    property AuthorizedUserName: String read fAuthorizedUserName
      write fAuthorizedUserName;
    property DataLoaded: Boolean read fDataLoaded;
    property ErrorOccurred: String read fErrorOccurred;
    property EncounterLocation: String read fEncounterLocation
      write fEncounterLocation;
    property EncounterProviderIEN: String read fEncounterProviderIEN
      write fEncounterProviderIEN;
    property EncounterProviderName: String read fEncounterProviderName
      write fEncounterProviderName;
    property HasDEA: Boolean read fHasDEA write fHasDEA;
    property LoadAttempt: Integer read fLoadAttempt;
    property PatIEN: String read fPatIEN write fPatIEN;
    property PatName: String read fPatName write fPatName;
    property PDMPList: TStrings read fPDMPList write fPDMPList;
    property StatusManager: HWND read fStatusManager write setStatusManager;
    property SignOnUserIEN: String read fSignOnUserIEN write fSignOnUserIEN;
    property SignOnUserName: String read fSignOnUserName write fSignOnUserName;
    property VisitString: String read fVisitString write fVisitString;
    property VistATask: String read fVistATask write setVistATask;
    property NoteIEN: String read fNoteIEN write fNoteIEN;

    property NoteHeader: String read getNoteHeader;
    property ReportURL: String read getReportURL;

    procedure pollPDMPResult(Sender: TObject);
    procedure Init(user, encounterProvider, location, patient, vstStr: string;
      aHasDEA: Boolean; MGR: HWND = 0);

    procedure pdmpClearData;
    function loadData(aCosignerIEN: String = ''): Integer;
    procedure abortLoad;
    procedure doCancelTask(aTask: String);
    function updatePDMP(aList: TStrings; bInitialCall: Boolean = false): Integer;
  end;

implementation

uses
  rPDMP, Forms,
  fPDMPUser,
  uConst,
  uPDMP;

{ TpdmpDataObject }
procedure TpdmpDataObject.pollPDMPResult(Sender: TObject);
begin
  pdmpGetResultsPoll(PDMPList, PatIEN, VistATask);
  updatePDMP(PDMPList);
end;

constructor TpdmpDataObject.Create;
begin
  inherited;
  PDMPList := TStringList.Create;
  pdmpTimer := TTimer.Create(nil);
  pdmpTimer.Interval := PDMP_PollingInterval;
  pdmpTimer.OnTimer := pollPDMPResult;
  pdmpTimer.Enabled := false;
end;

destructor TpdmpDataObject.Destroy;
begin
  FreeAndNil(pdmpTimer);
  FreeAndNil(fPDMPList);
  inherited;
end;

function TpdmpDataObject.getReportURL: String;
begin
  Result := '';
  if PDMPList.Count > 1 then
    Result := PDMPList[1];
end;

function TpdmpDataObject.getNoteHeader: String;
begin
  Result := '';
  if PDMPList.Count > 0 then
    Result := Piece(PDMPList[0], '^', 3);
end;

/// <summary> Setting up the default values of the object properties </summary>
procedure TpdmpDataObject.Init(user, encounterProvider, location, patient,
  vstStr: string; aHasDEA: Boolean; MGR: HWND = 0);
begin
  fLoadAttempt := 0;
  PatIEN := Piece(patient, U, 1);
  PatName := Piece(patient, U, 2);
  HasDEA := aHasDEA;
  SignOnUserIEN := Piece(user, U, 1);
  SignOnUserName := Piece(user, U, 2);
  EncounterLocation := location;
  EncounterProviderIEN := Piece(encounterProvider, U, 1);
  EncounterProviderName := Piece(encounterProvider, U, 2);
  VisitString := vstStr;
  fDataLoaded := false;
  fErrorOccurred := '';
  StatusManager := MGR;
  fVistATask := '';
  fPDMPReportURL := '';
  fLongMessage := '';
  fNoteIEN := '';
end;

procedure TpdmpDataObject.pdmpClearData;
begin
  fLoadAttempt := 0;
  AuthorizedUserIEN := '';
  AuthorizedUserName := '';
  PatIEN := '';
  PatName := '';
  HasDEA := false;
  SignOnUserIEN := '';
  SignOnUserName := '';
  EncounterLocation := '';
  EncounterProviderIEN := '';
  EncounterProviderName := '';
  VisitString := '';
  fDataLoaded := false;
  fErrorOccurred := '';
  StatusManager := 0;
  fVistATask := '';
  fPDMPReportURL := '';
  fLongMessage := '';
  fNoteIEN := '';
  if assigned(pdmpTimer) then
    pdmpTimer.Enabled := false;
end;

function TpdmpDataObject.loadData(aCosignerIEN: String = ''): Integer;
var
  sDelegate: String;
begin
  try
    inc(fLoadAttempt);
    sDelegate := AuthorizedUserIEN;
    if sDelegate = SignOnUserIEN then
      sDelegate := '';
    // update to pass co-signer
    if aCosignerIEN <> '' then
      sDelegate := aCosignerIEN;

    pdmpGetResults(PDMPList, SignOnUserIEN, sDelegate, VisitString, PatIEN);

    Result := updatePDMP(PDMPList, true);
  finally
  end;
end;

function TpdmpDataObject.updatePDMP(aList: TStrings; bInitialCall: Boolean = false): Integer;
var
  i: Integer;
  s, sRC, sNoteIEN, sChange, sChangeDate, sVistATask, sCosigner: String;
begin

  if (aList.Count < 1) or ((pdmpTimer.Enabled) and (PDMPList.Count = 0)) then
  begin
    fStatus := UM_PDMP_ERROR;
    fErrorOccurred := PDMP_MSG_RPCReturnedNoData;
    fLongMessage := PDMP_MSG_RPCReturnedNoData;
  end
  else
  begin
    s := aList[0];
    sRC := Piece(s, U, 1);
    sNoteIEN := Piece(s, U, 2);
    sChange := Piece(s, U, 3);
    sChangeDate := Piece(s, U, 4);
    sVistATask := Piece(s, U, 5);
    sCosigner := Piece(s, U, 6);

    Result := StrToIntDef(sRC, -99);
    case Result of
      0:
        begin
          if not pdmpTimer.Enabled then
          begin
            pdmpTimer.Enabled := True;
            VistATask := sNoteIEN; // task kept in 2nd piece if Result is '0'
          end;
          fStatus := UM_PDMP_Loading;
        end;
      1:
        begin
          pdmpTimer.Enabled := false;
          fDataLoaded := True;
          fStatus := UM_PDMP_Ready;
          fNoteIEN := sNoteIEN;
          fVistATask := sVistATask;
          fLongMessage := '';
          fAuthorizedUserIEN := sCosigner;
          for i := 1 to aList.Count - 1 do
            fLongMessage := fLongMessage + aList[i] + CRLF;

          PDMPList.Text := aList.Text;

          s := '';
          if aList.Count > 1 then
            for i := 2 to aList.Count - 1 do
              begin
                s := s + aList[i] + CRLF;
//                if pos('LBL^Last prior',aList[i]) = 1 then
//                  fLastRequest := piece(aList[i],'^',2);
              end;
          PDMP_REVIEW_OPTIONS := s;
        end;
    else
      begin
        fNoteIEN := sNoteIEN;

        fDataLoaded := True;
        pdmpTimer.Enabled := false;

        fStatus := UM_PDMP_ERROR;

        fLongMessage := '';
        for i := 1 to aList.Count - 1 do
          fLongMessage := fLongMessage + aList[i] + CRLF;

        fErrorOccurred := 'Error processing the results of PDMP request' + CRLF
          + 'Error Code : ' + IntToStr(Result) + CRLF + 'Description: ' +
          fLongMessage;
      end;
    end;
  end;

  i := 0;
  if bInitialCall then
    inc(i);

  NotifyStatusManager(fStatus, Integer(self), i);

  Result := fStatus;
end;

procedure TpdmpDataObject.NotifyStatusManager(aMessage: Integer; aW: Integer;
  aL: Integer);
begin
  PostMessage(StatusManager, aMessage, aW, aL);
end;

procedure TpdmpDataObject.setStatusManager(aHWND: HWND);
begin
  if aHWND = 0 then
    fStatusManager := application.MainForm.Handle
  else
    fStatusManager := aHWND;
end;

procedure TpdmpDataObject.setVistATask(aValue: String);
begin
  if fVistATask = '' then
    fVistATask := aValue
  else if aValue = '' then
    abortLoad
  else if VistATask <> aValue then
  begin
    fErrorOccurred := 'Task mismatch:' + CRLF + 'Old Task: ' + fVistATask + CRLF
      + 'New Task: ' + aValue + CRLF + CRLF + PDMP_MSG_DataRetrievingAbort;
    InfoBox(fErrorOccurred, PDMP_MSG_Title, MB_OK + MB_ICONERROR);
    abortLoad;
  end;
end;

procedure TpdmpDataObject.abortLoad;
begin
  pdmpTimer.Enabled := false;
  if VistATask <> '' then
    doCancelTask(VistATask);
end;

procedure TpdmpDataObject.doCancelTask(aTask: String);
begin
  fStatus := UM_PDMP_ABORT;
  if pdmpKillTask(aTask) = 0 then
    fVistATask := ''
  else
    InfoBox('Job ' + aTask + ' NOT Killed!', PDMP_MSG_Title + ' Cancel Job',
      MB_OK + MB_ICONWARNING);
  NotifyStatusManager(fStatus, Integer(self), 0);
end;

end.
