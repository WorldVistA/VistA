unit CCOW.CCOWManager;

interface

uses
  system.Classes,
  VCL.ExtCtrls,
  VCL.Forms,
  Winapi.ActiveX,
  Winapi.Windows,
  VERGENCECONTEXTORLib_TLB,
  TRPCB,
  CCOW.Constants,
  system.Generics.Collections,
  system.Win.ComObj;

type
  TCCOWResponse = VERGENCECONTEXTORLib_TLB.UserResponse;

const
  UrCommit = VERGENCECONTEXTORLib_TLB.UrCommit;
  UrCancel = VERGENCECONTEXTORLib_TLB.UrCancel;
  UrBreak = VERGENCECONTEXTORLib_TLB.UrBreak;

type
  ECCOW_UnableToCreate = Class(EOleSysError);

  TPendingEvent = procedure(Sender: TObject;
    const aContextItemCollection: IDispatch) of object;
  TErrorEvent = procedure(AMessage: string; CanShow: Boolean) of object;

  TApplicationHandleManager = class(TObject)
  private
    FList: TList<HWND>;
    function Get(Index: Integer): HWND;
    procedure GetAppHandles;
    function GetList: TList<HWND>;
    procedure Put(Index: Integer; const Value: HWND);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const Value: HWND): NativeInt;
    function Contains(const Value: HWND): Boolean;
    function Count: Integer;
    property Handles[Index: Integer]: HWND read Get write Put; default;
    property List: TList<HWND> read GetList;
  end;

  TLockApp = Class(TObject)
  private
    FActiveFormName: string;
    FMainForm: TForm;
    FNeedToReset: Boolean;
    FOrigActiveScreenEnabled: Boolean;
    FOrigMainFormEnabled: Boolean;
  public
    procedure LockMainApplication;
    procedure UnlockMainApplication;
  End;

  TCCOWManager = class(TObject)
  private
    FApplicationHandles: TApplicationHandleManager;
    FBusy: Boolean;
    FChanging: Boolean;
    FContextor: TContextorControl;
    FContextTimer: TTimer;
    FEnabled: Boolean;
    FError: Boolean;
    FErrorMessage: string;
    FLockApp: TLockApp;
    FOnAfterStart: TNotifyEvent;
    FOnCanceled: TNotifyEvent;
    FOnCommited: TNotifyEvent;
    FOnError: TErrorEvent;
    FOnPending: TPendingEvent;
    procedure Canceled(Sender: TObject);
    procedure ClearErrorInfo;
    procedure Committed(Sender: TObject);
    procedure DoCCOWTimer(Sender: TObject);
    function GetContextor: TContextorControl;
    function GetIsParticipating: Boolean;
    function GetIsRunning: Boolean;
    function GetIsSuspended: Boolean;
    function GetNotificationFilter: widestring;
    function GetPresent(aValue: String): Boolean;
    function GetState: TOleEnum;
    procedure HandleErrors(AMessage: string; CanShow: Boolean = True);
    procedure Pending(Sender: TObject; const aContextItemCollection: IDispatch);
    procedure SetNotificationFilter(const Value: widestring);
  public
    constructor Create;
    destructor Destroy; override;
    function FindBestDFN(aStationNumber: string;
      aIsProduction: Boolean): string;
    function GetHyperLinkResponse(aContextItemCollection: IDispatch;
      aStationNumber: string; aIsProduction: Boolean; aHWND: HWND): string;
    function IsDifferentPatient(aContextItemCollection: IDispatch;
      aStationNumber, aName, aDFN: string; aIsProduction: Boolean): Boolean;
    function IsDifferentUser(aContextItemCollection: IDispatch;
      RPCBroker: TRPCBroker): Boolean;
    procedure Resume;
    procedure SetSurveyResponse(aReason: widestring);
    function Start(ApplicationLabel, NotificationFilter: string): TCCOWResponse;
    procedure Suspend;
    function TryChangeContext(aStationNumber, aName, aDFN, aICN: string;
      aIsProduction: Boolean): TCCOWResponse;
    property Busy: Boolean read FBusy write FBusy;
    property Changing: Boolean read FChanging;
    property Contextor: TContextorControl read GetContextor;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ErrorMessage: string read FErrorMessage;
    property ErrorOccured: Boolean read FError;
    property IsParticipating: Boolean read GetIsParticipating;
    property IsRunning: Boolean read GetIsRunning;
    property IsSuspended: Boolean read GetIsSuspended;
    property NotificationFilter: widestring read GetNotificationFilter
      write SetNotificationFilter;
    property Present[aValue: String]: Boolean read GetPresent;
    property State: TOleEnum read GetState;
    property OnAfterStart: TNotifyEvent read FOnAfterStart write FOnAfterStart;
    property OnCanceled: TNotifyEvent read FOnCanceled write FOnCanceled;
    property OnCommited: TNotifyEvent read FOnCommited write FOnCommited;
    property OnError: TErrorEvent read FOnError write FOnError;
    property OnPending: TPendingEvent read FOnPending write FOnPending;
  end;

function CCOWManager: TCCOWManager;

implementation

uses
  VCL.Dialogs,
  VCL.Controls,
  system.SysUtils,
  Winapi.Messages,
  system.Math,
  TlHelp32,
  VAPieceHelper,
  ORSystem,
  ORNet,
  VAShared.CursorHelper,
  VAShared.ScreenHelper;

var
  FCCOW: TCCOWManager;

function CCOWManager: TCCOWManager;
begin
  If not assigned(FCCOW) then
    FCCOW := TCCOWManager.Create;
  Exit(FCCOW);
end;

function EnumWindowsProc(AHandle: HWND; AParam: LPARAM): BOOL; stdcall;
{
  Callback function for EnumWindows
  Enumerates all nonchild windows associated with a thread by passing the handle
  to each window, in turn, to an application-defined callback function.
  EnumThreadWindows continues until the last window is enumerated or the callback
  function returns FALSE. To enumerate child windows of a particular window, use
  the EnumChildWindows function.
}
var
  AppObj: TApplicationHandleManager;
begin
  AppObj := TApplicationHandleManager(AParam);

  // Check if it's a visible, top-level window (likely a form)
  if IsWindowVisible(AHandle) and (GetParent(AHandle) = 0) then
    AppObj.Add(AHandle);

  Result := True; // Continue enumeration
end;

{ TCCOWManager }

constructor TCCOWManager.Create;
begin
  FLockApp := TLockApp.Create;
  FEnabled := False;
  FContextTimer := TTimer.Create(nil);
  FContextTimer.Enabled := False;
  FContextTimer.OnTimer := DoCCOWTimer;
end;

destructor TCCOWManager.Destroy;
begin
  FreeAndNil(FContextTimer);
  FreeAndNil(FLockApp);
  inherited;
end;

procedure TCCOWManager.Canceled(Sender: TObject);
begin
  if assigned(FOnCanceled) then
    FOnCanceled(Sender);
end;

procedure TCCOWManager.ClearErrorInfo;
begin
  FError := False;
  FErrorMessage := '';
end;

procedure TCCOWManager.Committed(Sender: TObject);
begin
  if assigned(FOnCommited) then
    FOnCommited(Sender);
end;

procedure TCCOWManager.DoCCOWTimer(Sender: TObject);
{
  Timer function runs when context ends. This will check to see if any context
  releated screens have been opened and if so will lock the application and wait
  for the user to take action on the newly opened window.
  The timer will "stack up" while waiting for the EndContext call so this event
  will fire multiple times. We must ensure that we only run this one time.
}
var
  FormHandle: HWND;
  HandleList: TApplicationHandleManager;
begin
  // Timer can get "looped" since it has to wait for the popup window
  if not FContextTimer.Enabled then
    Exit();

  HandleList := TApplicationHandleManager.Create;
  try
    // check if we have any newly created forms
    if assigned(FApplicationHandles) and (HandleList.Count <> FApplicationHandles.Count) then
    begin
      FLockApp.LockMainApplication;
      for FormHandle in HandleList.List do
      begin
        // If form is "new" then bring it to the foreground
        if not FApplicationHandles.Contains(FormHandle) then
          SetForegroundWindow(FormHandle);
      end;
    end;
  finally
    FreeAndNil(HandleList);
    FContextTimer.Enabled := False;
  end;
end;

function TCCOWManager.FindBestDFN(aStationNumber: string;
  aIsProduction: Boolean): string;

  function GetDFNFromICN(AnICN: string): string;
  {
    Call to "public" routine to retieve a DFN from an ICN
  }
  begin
    CallVistA('VAFCTFU CONVERT ICN TO DFN', [AnICN], Result);
    If Trim(Result).IsEmpty then
      Exit('-1')
    else
      Exit(TPiece(Result).Piece(1));
  end;

var
  data: IContextItemCollection;
  anItem: IContextItem;
  tempDFN: string;

  procedure FindNextBestDFN;
  begin
    if aIsProduction then
      anItem := data.Present(CCOW_PATIENT_DFN + aStationNumber)
    else
      anItem := data.Present(CCOW_PATIENT_DFN + aStationNumber + '_TEST');
    if anItem <> nil then
      tempDFN := anItem.Get_Value();
  end;

begin
  Screen.Cursor.Change(crHourGlass);
  try
    // Get an item collection of the current context
    try
      ClearErrorInfo;
      data := FContextor.CurrentContext;

      // Retrieve the ContextItem name and value as strings
      if aIsProduction then
        anItem := data.Present(CCOW_PATIENT_ICN)
      else
        anItem := data.Present(CCOW_PATIENT_ICN + '_TEST');
      if anItem <> nil then
      begin
        tempDFN := GetDFNFromICN(anItem.Get_Value());
        if tempDFN = '-1' then
          FindNextBestDFN;
      end
      else
        FindNextBestDFN;
      Result := tempDFN;
      data := nil;
      anItem := nil;
    Except
      on E: Exception do
        HandleErrors(E.Message, False);
    end;
  finally
    Screen.Cursor.Restore;
  end;
end;

function TCCOWManager.GetContextor: TContextorControl;
begin
  Result := FContextor;
end;

function TCCOWManager.GetHyperLinkResponse(aContextItemCollection: IDispatch;
  aStationNumber: string; aIsProduction: Boolean; aHWND: HWND): string;
var
  data: IContextItemCollection;
  anItem: IContextItem;
  itemvalue: string;
  PtSubject: string;
begin
  Screen.Cursor.Change(crHourGlass);
  try
    try
      Result := '';
      data := IContextItemCollection(aContextItemCollection);
      anItem := data.Present('[hds_domain.ext]request.id.name');
      // Retrieve the ContextItem name and value as strings
      if anItem <> nil then
      begin
        itemvalue := anItem.Get_Value();
        if itemvalue = 'GetWindowHandle' then
        begin
          PtSubject := CCOW_PATIENT_DFN + aStationNumber;
          if not aIsProduction then
            PtSubject := PtSubject + '_test';
          if data.Present(PtSubject) <> nil then
            Result := '!@#$' + IntToStr(aHWND) + ':0:'
        end;
      end;
    Except
      on E: Exception do
        HandleErrors(E.Message);
    end;
  finally
     Screen.Cursor.Restore;
  end;
end;

function TCCOWManager.GetIsParticipating: Boolean;
begin
  Exit(FContextor.State in [csParticipating]);
end;

function TCCOWManager.GetIsRunning: Boolean;
begin
  Exit(not FContextor.State in [CsNotRunning]);
end;

function TCCOWManager.GetIsSuspended: Boolean;
begin
  Exit(FContextor.State in [CsSuspended]);
end;

function TCCOWManager.GetNotificationFilter: widestring;
begin
  if assigned(FContextor) then
    Exit(FContextor.NotificationFilter)
  else
    Exit('');
end;

function TCCOWManager.GetPresent(aValue: String): Boolean;
begin
  Exit(FContextor.CurrentContext.Present(aValue) <> nil);
end;

function TCCOWManager.GetState: TOleEnum;
begin
  Result := FContextor.State;
end;

procedure TCCOWManager.HandleErrors(AMessage: string; CanShow: Boolean = True);
begin
  FEnabled := False;
  FError := True;
  FErrorMessage := AMessage;
  If assigned(FOnError) then
    FOnError(AMessage, CanShow);
end;

function TCCOWManager.IsDifferentPatient(aContextItemCollection: IDispatch;
  aStationNumber, aName, aDFN: string; aIsProduction: Boolean): Boolean;
var
  data: IContextItemCollection;
  anItem: IContextItem;
  PtDFN, PtName: string;
begin
   Screen.Cursor.Change(crHourGlass);
  try
    Result := False;
    try
      PtDFN := FindBestDFN(aStationNumber, aIsProduction);
      data := IContextItemCollection(aContextItemCollection);
      // Retrieve the ContextItem name and value as strings
      anItem := data.Present(CCOW_PATIENT_NAME);
      if anItem <> nil then
        PtName := anItem.Get_Value();
      Result := not((PtDFN = aDFN) and (PtName = TPiece(aName).Piece(1, ',') +
        '^' + TPiece(aName).Piece(2, ',') + '^^^^'));
    Except
      on E: Exception do
      begin
        HandleErrors(E.Message, False);
      end;
    end;
  finally
     Screen.Cursor.Restore;
  end;
end;

function TCCOWManager.IsDifferentUser(aContextItemCollection: IDispatch;
  RPCBroker: TRPCBroker): Boolean;
var
  data: IContextItemCollection;
begin
   Screen.Cursor.Change(crHourGlass);
  try
    Result := False;
    try
      data := IContextItemCollection(aContextItemCollection);
      Result := RPCBroker.IsUserContextPending(data);
    Except
      on E: Exception do
      begin
        HandleErrors(E.Message, False);
      end;
    end;
  finally
     Screen.Cursor.Restore;
  end;
end;

procedure TCCOWManager.Pending(Sender: TObject;
  const aContextItemCollection: IDispatch);
begin
  if assigned(FOnPending) then
    FOnPending(Sender, aContextItemCollection);
end;

procedure TCCOWManager.Resume;
begin
  try
    ClearErrorInfo;
    FContextor.Resume;
  Except
    on E: Exception do
    begin
      HandleErrors(E.Message, False);
    end;
  end;
end;

procedure TCCOWManager.SetNotificationFilter(const Value: widestring);
begin
  ClearErrorInfo;
  if assigned(FContextor) then
    FContextor.NotificationFilter := Value;
end;

procedure TCCOWManager.SetSurveyResponse(aReason: widestring);
begin
  ClearErrorInfo;
  FContextor.SetSurveyResponse(aReason);
end;

function TCCOWManager.Start(ApplicationLabel, NotificationFilter: string)
  : TCCOWResponse;

  Procedure TryToStart(AppLabel, NotFilter: string);
  begin
    Try
      ClearErrorInfo;
      Try
        FContextor := TContextorControl.Create(Application);
      Except
        on E: EOleSysError do
          raise ECCOW_UnableToCreate.Create(E.Message, E.ErrorCode,
            E.HelpContext)
        else
          raise;
      End;

      try
        FContextor.OnPending := Pending;
        FContextor.OnCommitted := Committed;
        FContextor.OnCanceled := Canceled;
        FBusy := False;
        FEnabled := True;
        FContextor.Run(AppLabel, '', True, NotFilter);
      Except
        FreeAndNil(FContextor);
        raise;
      end;
    Except
      FEnabled := False;
      raise;
    end;
  end;

const
    TX_CCOW_ERROR    = 'CPRS was unable to communicate with the CCOW Context Vault. Please manualy rejoin context from the file menu.';
    TC_CCOW_ERROR    = 'CCOW Error';
begin
   Screen.Cursor.Change(crHourGlass);
  try
    Result := UrCommit;
    try
      TryToStart(ApplicationLabel, NotificationFilter);
    except
      on e: ECCOW_UnableToCreate do
      begin
        Result := UrCancel;
      end else
      begin
        try
          TryToStart(ApplicationLabel + '#', NotificationFilter);
          Result := UrBreak;
        except
          begin
            Result := UrBreak;
            var ErrMsg := TTaskDialog.Create(Application);
            try
              ErrMsg.Title := TC_CCOW_ERROR;
              ErrMsg.Caption := TC_CCOW_ERROR;
              ErrMsg.Text := TX_CCOW_ERROR;
              ErrMsg.CommonButtons := [tcbOk];
              ErrMsg.MainIcon := tdiError;
              ErrMsg.Execute;
            finally
              Free;
            end;
          end;
        end;
      end;
    end;
  finally
     Screen.Cursor.Restore;
  end;
end;

procedure TCCOWManager.Suspend;
begin
  try
    ClearErrorInfo;
    FContextor.Suspend;
  Except
    on E: Exception do
    begin
      HandleErrors(E.Message, False);
    end;
  end;
end;

function TCCOWManager.TryChangeContext(aStationNumber, aName, aDFN,
  aICN: string; aIsProduction: Boolean): TCCOWResponse;
var
  PtData: IContextItemCollection;
  PtDataItem2, PtDataItem3, PtDataItem4: IContextItem;
begin
   Screen.Cursor.Change(crHourGlass);
  try
    try
      ClearErrorInfo;
      FContextor.StartContextChange();

      // Set the new proposed context data.
      PtData := CoContextItemCollection.Create();

      PtDataItem2 := CoContextItem.Create();
      PtDataItem2.Set_Name(CCOW_PATIENT_NAME); // Patient.Name
      PtDataItem2.Set_Value(TPiece(aName).Piece(1, ',') + '^' + TPiece(aName)
        .Piece(2, ',') + '^^^^');
      PtData.Add(PtDataItem2);

      PtDataItem3 := CoContextItem.Create();
      if not aIsProduction then
        PtDataItem3.Set_Name(CCOW_PATIENT_DFN + aStationNumber + '_TEST')
        // Patient.DFN
      else
        PtDataItem3.Set_Name(CCOW_PATIENT_DFN + aStationNumber);
      // Patient.DFN
      PtDataItem3.Set_Value(aDFN);
      PtData.Add(PtDataItem3);

      if aICN <> '' then
      begin
        PtDataItem4 := CoContextItem.Create();
        if not aIsProduction then
          PtDataItem4.Set_Name(CCOW_PATIENT_ICN + '_TEST')
          // Patient.ICN
        else
          PtDataItem4.Set_Name(CCOW_PATIENT_ICN); // Patient.ICN
        PtDataItem4.Set_Value(aICN);
        PtData.Add(PtDataItem4);
      end;

      FContextTimer.Enabled := True;
      try
        // Get open window count
        FApplicationHandles := TApplicationHandleManager.Create;
        try
          ClearErrorInfo;
          // End the context change transaction.
          Result := FContextor.EndContextChange(True, PtData);
          Case Result of
            UrCancel, UrBreak:
              PtData.RemoveAll;
          End;
        finally
          FreeAndNil(FApplicationHandles);
        end;
      Except
        on E: Exception do
        begin
          Result := UrBreak;
          HandleErrors(E.Message);
          Exit;
        end;
      end;
    finally
      FContextTimer.Enabled := False;
      FLockApp.UnlockMainApplication;
    end;

  finally
     Screen.Cursor.Restore;
  end;
end;

constructor TApplicationHandleManager.Create;
begin
  inherited;
  FList := TList<HWND>.Create;
  GetAppHandles;
end;

destructor TApplicationHandleManager.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

{ TApplicationHandles }

function TApplicationHandleManager.Add(const Value: HWND): NativeInt;
begin
  Exit(FList.Add(Value));
end;

function TApplicationHandleManager.Contains(const Value: HWND): Boolean;
begin
  Exit(FList.Contains(Value));
end;

function TApplicationHandleManager.Count: Integer;
begin
  Exit(FList.Count);
end;

function TApplicationHandleManager.Get(Index: Integer): HWND;
begin
  Exit(FList[Index]);
end;

procedure TApplicationHandleManager.GetAppHandles;
begin
  EnumThreadWindows(system.MainThreadID, @EnumWindowsProc, LPARAM(Self));
end;

function TApplicationHandleManager.GetList: TList<HWND>;
begin
  Exit(FList);
end;

procedure TApplicationHandleManager.Put(Index: Integer; const Value: HWND);
begin
  if system.Math.InRange(Index, 0, FList.Count) then
    FList[Index] := Value
  else
    FList.Add(Value);
end;

{ TLockApp }

procedure TLockApp.LockMainApplication;
begin
  FNeedToReset := True;

  FMainForm := Application.MainForm;
  FOrigMainFormEnabled := FMainForm.Enabled;
  FMainForm.Enabled := False;

  // Retrieve the name here because the 'active form' may change,
  // or the pointer may become invalid when re-enabled.
  // During site testing, there was an instance where the pointer to this form
  // became invalid, causing access violations.
  FActiveFormName := Screen.ActiveForm.Name;
  FOrigActiveScreenEnabled := Screen.ActiveForm.Enabled;
  Screen.ActiveForm.Enabled := False;

end;

procedure TLockApp.UnlockMainApplication;
begin
  If FNeedToReset then
  begin
    try
      try
        if assigned(FMainForm) then
          FMainForm.Enabled := FOrigMainFormEnabled;
        // Try to re-enable the form that was "active form" when we disabled
        var ActiveForm := Screen.FormByName(FActiveFormName);
        if assigned(ActiveForm) then
          ActiveForm.Enabled := FOrigActiveScreenEnabled;
      Except
        // Swallow, we did see a dangling pointer at sites, so best to swallow
        // the exception (cant recreate issue)
      end;
    Finally
      // Saftey net to ensure the "main form" and the "active form" are enabled
      if assigned(Application.MainForm) and (not Application.MainForm.Enabled)
      then
        Application.MainForm.Enabled := FOrigMainFormEnabled;
      if assigned(Screen.ActiveForm) and (not Screen.ActiveForm.Enabled) then
        Screen.ActiveForm.Enabled := FOrigActiveScreenEnabled;
    end;
  end;
end;

Initialization

Finalization

FreeAndNil(FCCOW);

end.
