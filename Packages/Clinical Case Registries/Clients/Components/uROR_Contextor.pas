unit uROR_Contextor;
{$I Components.inc}

interface

uses
  Dialogs, SysUtils, Classes, Controls, OleCtrls, VERGENCECONTEXTORLib_TLB,
  Unicode, AppEvnts, TRPCB, ExtCtrls, Menus, ImgList;

type

  TContextLinkStatus = (clsBroken, clsChanging, clsLink, clsUnknown);
  TContextorResumeMode = (crmAskUser, crmUseGlobalData, crmUseAppData);

  TCustomContextorIndicator = class;

  TCustomContextor = class(TComponent)
  private
    fApplicationName:  WideString;
    fContextor:        TContextorControl;
    fEnabled:          Boolean;
    fForcedChange:     Boolean;
    fIndicators:       TList;
    fLocalContext:     IContextItemCollection;
    fNotRunningReason: String;
    fOnCommitted:      TNotifyEvent;
    fOnPending:        TContextorControlPending;
    fOnResumed:        TNotifyEvent;
    fOnSuspended:      TNotifyEvent;
    fPassCode:         WideString;
    fPendingContext:   IContextItemCollection;
    fSubjects:         TWideStringList;
    fSurvey:           Boolean;
    fSuspensionCount:  Integer;
    fIsChanging:       Boolean;

    procedure committed(EnforceKnown: Boolean = False);
    function  getApplicationName: WideString;
    function  getNotificationFilter: WideString;
    function  getOnCanceled: TNotifyEvent;
    function  getPassCode: WideString;
    procedure setApplicationName(const aValue: WideString);
    procedure setNotificationFilter(const aValue: WideString);
    procedure setOnCanceled(const aValue: TNotifyEvent);
    procedure setPassCode(const aValue: WideString);
    procedure setPendingContext(const aValue: IContextItemCollection);
    procedure setSurvey(const aValue: Boolean);

  protected
    procedure AddIndicator(anIndicator: TCustomContextorIndicator); virtual;
    procedure DoOnResumed; virtual;
    procedure DoOnSuspended; virtual;
    function  getCurrentContext: IContextItemCollection;
    function  getState: TOleEnum;
    procedure ProcessOnCommitted(aSender: TObject); virtual;
    procedure ProcessOnPending(aSender: TObject;
      const aContextItemCollection: IDispatch); virtual;
    procedure RemoveIndicator(anIndicator: TCustomContextorIndicator); virtual;
    procedure RemoveSubject(const aContext: IContextItemCollection;
      const aSubject: WideString);
    procedure setEnabled(const aValue: Boolean); virtual;

    property LocalContext: IContextItemCollection    read    fLocalContext;
    property Subjects: TWideStringList               read    fSubjects;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    function  AddTXItem(const aName: WideString;
      const aValue: WideString): IContextItem;
    procedure DisplayStatus;
    function  EndContextChange(Commit: Boolean;
      const aContextItemCollection: IContextItemCollection = nil): UserResponse; virtual;
    function  GetPrivilege(const aSubject: WideString): AccessPrivilege;
    procedure ProcessKnownSubjects(Enforce: Boolean = False); virtual;
    procedure RemoveTXItem(const aName: WideString);
    procedure Resume(aMode: TContextorResumeMode);
    procedure Run;
    procedure SetSurveyResponse(const aReason: WideString);
    function  StartContextChange: Boolean; virtual;
    procedure Suspend;
    procedure UpdateIndicators; virtual;
    procedure UpdateLocalContext(const aContext: IContextItemCollection); virtual;

    property ApplicationName: WideString             read    getApplicationName
                                                     write   setApplicationName;

    property Contextor: TContextorControl            read    fContextor;
    property CurrentContext: IContextItemCollection  read    getCurrentContext;

    property Enabled: Boolean                        read    fEnabled
                                                     write   setEnabled
                                                     default False;

    property ForcedChange: Boolean                   read    fForcedChange;
    property Indicators: TList                       read    fIndicators;
    property IsChanging: Boolean                     read    fIsChanging;

    property NotificationFilter: WideString          read    getNotificationFilter
                                                     write   setNotificationFilter;

    property NotRunningReason: String                read    fNotRunningReason
                                                     write   fNotRunningReason;

    property OnCanceled: TNotifyEvent                read    getOnCanceled
                                                     write   setOnCanceled;

    property OnCommitted: TNotifyEvent               read    fOnCommitted
                                                     write   fOnCommitted;

    property OnPending: TContextorControlPending     read    fOnPending
                                                     write   fOnPending;

    property OnResumed: TNotifyEvent                 read    fOnResumed
                                                     write   fOnResumed;

    property OnSuspended: TNotifyEvent               read    fOnSuspended
                                                     write   fOnSuspended;

    property PassCode: WideString                    read    getPassCode
                                                     write   setPassCode;

    property PendingContext: IContextItemCollection  read    fPendingContext
                                                     write   setPendingContext;

    property State: TOleEnum                         read    getState;

    property Survey: Boolean                         read    fSurvey
                                                     write   setSurvey
                                                     default True;

  end;

  TCustomContextorIndicator = class(TCustomPanel)
  private
    fContextor:  TCustomContextor;
    fImages:     TImageList;
    fLinkStatus: TContextLinkStatus;
    fOnUpdate:   TNotifyEvent;

  protected
    procedure Loaded; override;
    procedure Notification(aComponent: TComponent; anOperation: TOperation); override;
    procedure ProcessBreak(aSender: TObject); virtual;
    procedure ProcessRejoin(aSender: TObject); virtual;
    procedure setContextor(const aValue: TCustomContextor);
    procedure SetEnabled(aValue: Boolean); override;
    procedure UpdateIndicator; virtual;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    property Contextor: TCustomContextor             read    fContextor
                                                     write   setContextor;

    property Images: TImageList                      read    fImages
                                                     write   fImages;

    property LinkStatus: TContextLinkStatus          read    fLinkStatus;

    property OnUpdate: TNotifyEvent                  read    fOnUpdate
                                                     write   fOnUpdate;

  end;

  TCCRContextor = class(TCustomContextor)
  private
    fDFNItemName:      WideString;
    fICNItemName:      WideString;
    fOnPatientChanged: TNotifyEvent;
    fPatientChanged:   Boolean;
    fPatientDFN:       String;
    fPatientICN:       String;
    fRPCBroker:        TRPCBroker;

  protected
    function DFNtoICN(aDFN: String): String;
    function ICNtoDFN(anICN: String): String;
    procedure Notification(aComponent: TComponent; anOperation: TOperation); override;
    procedure ProcessOnPending(aSender: TObject;
      const aContextItemCollection: IDispatch); override;
    procedure setRPCBroker(aValue: TRPCBroker); virtual;

  public
    function  PatientDFNFromContext(aContext: IContextItemCollection;
      var aValue: String): Boolean;
    function  PatientICNFromContext(aContext: IContextItemCollection;
      var aValue: String): Boolean;
    procedure ProcessKnownSubjects(Enforce: Boolean = False); override;
    function  SetPatientContext(aDFN: String = '';
      anICN: String = ''): Boolean; virtual;

    property PatientDFN: String                      read    fPatientDFN;
    property PatientICN: String                      read    fPatientICN;

  published
    property ApplicationName;
    property Enabled;
    property NotificationFilter;
    property OnCanceled;
    property OnCommitted;
    property OnPending;
    property OnResumed;
    property OnSuspended;
    property PassCode;
    property Survey default True;

    property DFNItemName: WideString                 read    fDFNItemName
                                                     write   fDFNItemName;

    property ICNItemName: WideString                 read    fICNItemName
                                                     write   fICNItemName;

    property OnPatientChanged: TNotifyEvent          read    fOnPatientChanged
                                                     write   fOnPatientChanged;

    property RPCBroker: TRPCBRoker                   read    fRPCBroker
                                                     write   setRPCBroker;

  end;

  TCCRContextorIndicator = class(TCustomContextorIndicator)
  private
    mnuBreakLink:     TMenuItem;
    mnuUseAppData:    TMenuItem;
    mnuUseGlobalData: TMenuItem;

  protected
    function  CreatePopupMenu: TPopupMenu; virtual;
    procedure Paint; override;
    procedure ProcessOnPopup(aSender: TObject); virtual;
    procedure ProcessRejoin(aSender: TObject); override;
    procedure SetName(const NewName: TComponentName); override;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

  published
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    property BevelInner                              default bvNone;
    property BevelOuter                              default bvNone;
    property BevelWidth;
    //property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    //property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    //property UseDockManager                          default True;
    //property DockSite;
    //property DragCursor;
    //property DragKind;
    //property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    //property ParentBiDiMode;
    {$IFDEF VERSION7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;   // zzzzzzandria 060614
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    //property OnDockDrop;
    //property OnDockOver;
    property OnDblClick;
    //property OnDragDrop;
    //property OnDragOver;
    //property OnEndDock;
    //property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    //property OnStartDock;
    //property OnStartDrag;
    //property OnUnDock;

    property Contextor;
    property Images;
    property OnUpdate;

  end;

implementation

uses
  Forms, StrUtils, uROR_Resources, fROR_PCall, uROR_Utilities, Graphics,
  ComObj, system.Types, system.UITypes;

const
  HL7ORG = '[hl7.org]';

var
  DefaultImages: TImageList = nil;
  DICount: Integer = 0;

function LoadDefaultImages: TImageList;
begin
  if DICount <= 0 then
    begin
      if Assigned(DefaultImages) then
        DefaultImages.Free;
      DefaultImages := TImageList.Create(nil);
      DefaultImages.ResInstLoad(HInstance, rtBitmap, 'CCOW_BROKEN_16', clFuchsia);
      DefaultImages.ResInstLoad(HInstance, rtBitmap, 'CCOW_CHANGING_16', clFuchsia);
      DefaultImages.ResInstLoad(HInstance, rtBitmap, 'CCOW_LINK_16', clFuchsia);
      DefaultImages.ResInstLoad(HInstance, rtBitmap, 'CCOW_NOTRUNNING_16', clFuchsia);
    end;
  Inc(DICount);
  Result := DefaultImages;
end;

procedure UnloadDefaultImages;
begin
  if DICount > 0 then
    begin
      Dec(DICount);
      if DICount = 0 then
        FreeAndNil(DefaultImages);
    end;
end;

////////////////////////////////// TCCRContextor \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function TCCRContextor.DFNtoICN(aDFN: String): String;
var
  rpcRes: TStringList;
begin
  rpcRes := TStringList.Create;
  try
    if CallRemoteProc(RPCBRoker, 'VAFCTFU CONVERT DFN TO ICN',
      [aDFN], nil, [rpcNoResChk], rpcRes) then
      {$IFDEF CCOW_USE_ICN_CHECKSUM}
      Result := Piece(rpcRes[0], '^');
      {$ELSE}
      Result := Piece(Piece(rpcRes[0], '^'), 'V');
      {$ENDIF}
      if StrToIntDef(Result, 0) < 0 then
        Result := '';
  except
    Result := '';
  end;
  rpcRes.Free;
end;

function TCCRContextor.ICNtoDFN(anICN: String): String;
var
  rpcRes: TStringList;
begin
  rpcRes := TStringList.Create;
  try
    if CallRemoteProc(RPCBRoker, 'VAFCTFU CONVERT ICN TO DFN',
      [Piece(anICN,'V')], nil, [rpcNoResChk], rpcRes) then
      Result := Piece(rpcRes[0], '^');
      if StrToIntDef(Result, 0) < 0 then
        Result := '';
  except
    Result := '';
  end;
  rpcRes.Free;
end;

procedure TCCRContextor.Notification(aComponent: TComponent;
  anOperation: TOperation);
begin
  inherited;
  if (aComponent = RPCBRoker) and (anOperation = opRemove) then
    RPCBroker := nil;
end;

function TCCRContextor.PatientDFNFromContext(aContext: IContextItemCollection;
  var aValue: String): Boolean;
var
  ci: IContextItem;
begin
  ci := aContext.Present(DFNItemName);
  Result := (ci <> nil);
  if Result then
    aValue := ci.Value
  else
    aValue := '';
end;

function TCCRContextor.PatientICNFromContext(aContext: IContextItemCollection;
  var aValue: String): Boolean;
var
  ci: IContextItem;
begin
  ci := aContext.Present(ICNItemName);
  Result := (ci <> nil);
  if Result then
    {$IFDEF CCOW_USE_ICN_CHECKSUM}
    aValue := ci.Value
    {$ELSE}
    aValue := Piece(ci.Value, 'V')
    {$ENDIF}
  else
    aValue := '';
end;

procedure TCCRContextor.ProcessKnownSubjects(Enforce: Boolean);
var
  pc: Integer;
begin
  if State = csParticipating then
    begin
      if Enforce or (not Survey) then
        fPatientChanged := True;
      pc := 0;
      if PatientDFNFromContext(CurrentContext, fPatientDFN) then Inc(pc);
      if PatientICNFromContext(CurrentContext, fPatientICN) then Inc(pc);
      if fPatientChanged then
        begin
          // If the context has only one patient identifier then
          // try to get the other from VistA
          if (pc = 1) and Assigned(RPCBroker) then
            begin
              if fPatientDFN = '' then
                fPatientDFN := ICNtoDFN(fPatientICN);
              if fPatientICN = '' then
                fPatientICN := DFNtoICN(fPatientDFN);
            end;
          // Call the user-defined event handler
          if Assigned(OnPatientChanged) then
            OnPatientChanged(Self);
          // Reset the flag
          fPatientChanged := False;
        end;
    end;
end;

procedure TCCRContextor.ProcessOnPending(aSender: TObject;
  const aContextItemCollection: IDispatch);
var
  i: Integer;
begin
  fPatientChanged := False;
  if (State <> csNotRunning) and Assigned(aContextItemCollection) then
    with IContextItemCollection(aContextItemCollection) do
      for i:=1 to Count do
        with Item(i) do
          if WideSameText(Subject, 'Patient') then
            fPatientChanged := True;
  inherited;
end;

function TCCRContextor.SetPatientContext(aDFN: String; anICN: String): Boolean;
var
  pc: Integer;
  commit: Boolean;
begin
  Result := True;
  {$IFNDEF CCOW_USE_ICN_CHECKSUM}
  anICN := Piece(anICN, 'V');
  {$ENDIF}

  pc := 0;
  if anICN <> '' then Inc(pc);
  if aDFN  <> '' then Inc(pc);

  if pc > 0 then
    begin
      if aDFN  = '' then aDFN  := ICNtoDFN(anICN);
      if anICN = '' then anICN := DFNtoICN(aDFN);
    end;

  if (anICN <> fPatientICN) or (aDFN <> fPatientDFN) then
    begin
      commit := False;
      if StartContextChange then
        try
          if pc > 0 then
            begin
              if anICN <> '' then
                AddTXItem(ICNItemName, Piece(anICN, 'V'));
              if aDFN <> '' then
                AddTXItem(DFNItemName, aDFN);
            end
          else
            AddTXItem(ICNItemName, '');
          commit := True;
        finally
          Result := (EndContextChange(commit) <> urCancel);
        end;

      if Result then
        begin
          fPatientICN := anICN;
          fPatientDFN := aDFN;
        end;
    end;
end;

procedure TCCRContextor.setRPCBroker(aValue: TRPCBroker);
begin
  if aValue <> fRPCBroker then
    begin
      if Assigned(fRPCBroker) then
        fRPCBroker.RemoveFreeNotification(Self);
      fRPCBroker := aValue;
      if Assigned(aValue) then
        fRPCBroker.FreeNotification(Self);
    end;
end;

//////////////////////////// TCCRContextorIndicator \\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRContextorIndicator.Create(anOwner: TComponent);
begin
  inherited;

  Height    := 24;
  PopupMenu := CreatePopupMenu;
  Width     := 24;
end;

destructor TCCRContextorIndicator.Destroy;
begin
  PopupMenu := nil;
  inherited;
end;

function TCCRContextorIndicator.CreatePopupMenu: TPopupMenu;
var
  mi: TMenuItem;
begin
  Result := TPopupMenu.Create(Self);
  with Result do
    begin
      SetSubComponent(True);
      AutoPopup := True;
      OnPopup   := ProcessOnPopup;

      mnuUseAppData := TMenuItem.Create(Self);
      mnuUseAppData.Caption := rscUseAppData;
      mnuUseAppData.OnClick := ProcessRejoin;
      Items.Add(mnuUseAppData);

      mnuUseGlobalData := TMenuItem.Create(Self);
      mnuUseGlobalData.Caption  := rscUseGlobalData;
      mnuUseGlobalData.OnClick  := ProcessRejoin;
      Items.Add(mnuUseGlobalData);

      mi := TMenuItem.Create(Self);
      mi.Caption := '-';
      Items.Add(mi);

      mnuBreakLink := TMenuItem.Create(Self);
      mnuBreakLink.Caption := rscBreakLink;
      mnuBreakLink.OnClick := ProcessBreak;
      Items.Add(mnuBreakLink);
    end;
end;

procedure TCCRContextorIndicator.Paint;
var
  imgNdx: Integer;
begin
  inherited;
  if Assigned(Images) then
    begin
      imgNdx := Ord(LinkStatus);
      if (imgNdx >= 0) and (imgNdx < Images.Count) then
        Images.Draw(Canvas,
          ClientRect.Left + (ClientWidth  - Images.Width)   div 2,
          ClientRect.Top  + (ClientHeight - Images.Height ) div 2,
          imgNdx);
    end;
end;

procedure TCCRContextorIndicator.ProcessOnPopup(aSender: TObject);
begin
  if Assigned(Contextor) then
    case Contextor.State of
      csParticipating:
        begin
          mnuBreakLink.Enabled     := True;
          mnuUseAppData.Enabled    := False;
          mnuUseGlobalData.Enabled := False;
        end;
      csSuspended:
        begin
          mnuBreakLink.Enabled     := False;
          mnuUseAppData.Enabled    := True;
          mnuUseGlobalData.Enabled := True;
        end;
      else
        begin
          mnuBreakLink.Enabled     := False;
          mnuUseAppData.Enabled    := False;
          mnuUseGlobalData.Enabled := False;
        end;
    end;
end;

procedure TCCRContextorIndicator.ProcessRejoin(aSender: TObject);
begin
  if Assigned(Contextor) then
    if aSender = mnuUseAppData then
      Contextor.Resume(crmUseAppData)
    else
      Contextor.Resume(crmUseGlobalData);
end;

procedure TCCRContextorIndicator.SetName(const NewName: TComponentName);
begin
  inherited;
  Caption := '';
end;

//////////////////////////////// TCustomContextor \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCustomContextor.Create(anOwner: TComponent);
begin
  inherited;
  fNotRunningReason := '';
  try
    fContextor := TContextorControl.Create(Self);
    fContextor.SetSubComponent(True);
  except
    on e: Exception do
      begin
        fNotRunningReason := e.Message;
        fContextor := nil;
      end;
  end;

  fSubjects := TWideStringList.Create;
  fSubjects.Delimiter := ';';
  fSubjects.Sorted    := True;
  NotificationFilter  := 'Patient;User';

  fEnabled            := True;
  fForcedChange       := False;
  fIndicators         := TList.Create;
  fIsChanging         := False;
  fLocalContext       := nil;
  fPendingContext     := nil;
  fSurvey             := True;
  fSuspensionCount    := 0;
end;

destructor TCustomContextor.Destroy;
begin
  FreeAndNil(fContextor);
  FreeAndNil(fIndicators);
  FreeAndNil(fSubjects);
  inherited;
end;

procedure TCustomContextor.AddIndicator(anIndicator: TCustomContextorIndicator);
begin
  if Assigned(Indicators) and Assigned(anIndicator) then
    begin
      Indicators.Add(anIndicator);
      FreeNotification(anIndicator);
    end;
end;

function TCustomContextor.AddTXItem(const aName: WideString;
  const aValue: WideString): IContextItem;
begin
  if Assigned(PendingContext) then
    begin
      // Check if the item with the provided name already
      // exists in the transaction context
      Result := PendingContext.Present(aName);
      // Otherwise, create a new item
      if not Assigned(Result) then
        Result := CoContextItem.Create;
      // Initialize/Update the item and add it to the transaction context
      Result.Name  := aName;
      Result.Value := aValue;
      PendingContext.Add(Result);
    end
  else
    Result := nil;
end;

procedure TCustomContextor.committed(EnforceKnown: Boolean);
var
  i, ifs: Integer;
  nf: WideString;
begin
  if State <> csNotRunning then
    begin
      LocalContext.RemoveAll;
      // If the application do not want to be surveyed then all
      // context changes are mandatory and should be enforced.
      if not Survey then
        fForcedChange := True;

      nf := NotificationFilter;
      if nf = '*' then
        begin
          // Copy all items to local context
          for i:=1 to CurrentContext.Count do
            LocalContext.Add(CurrentContext.Item(i).Clone);
        end
      else if nf <> '' then
        begin
          // Copy the items that have subjects defined by the
          // NotificationFilter property to the local context
          for i:=1 to CurrentContext.Count do
            with CurrentContext.Item(i) do
              begin
                if Subjects.Find(Subject, ifs) then
                  LocalContext.Add(Clone);
              end;
        end;

      ProcessKnownSubjects(EnforceKnown);

      if Assigned(OnCommitted) then
        OnCommitted(Self);
    end;
end;

procedure TCustomContextor.DisplayStatus;
var
  msg: String;
begin
  case State of
    csNotRunning:
      msg := RSC0003 + #13#13 + NotRunningReason;
    csParticipating:
      msg := RSC0004;
    csSuspended:
      msg := RSC0005;
    else
      msg := RSC0006;
  end;
  MessageDlg(msg, mtInformation, [mbOK], 0)
end;

procedure TCustomContextor.DoOnResumed;
begin
  if Assigned(OnResumed) then
    OnResumed(Self);
  UpdateIndicators;
end;

procedure TCustomContextor.DoOnSuspended;
begin
  if Assigned(OnSuspended) then
    OnSuspended(Self);
  UpdateIndicators;
end;

function TCustomContextor.EndContextChange(Commit: Boolean;
  const aContextItemCollection: IContextItemCollection): UserResponse;
begin
  if State = csParticipating then
    begin
      Result := urCancel;
      if Assigned(aContextItemCollection) then
        PendingContext := aContextItemCollection;
      // Cancel the transaction if there is nothing to send
      if PendingContext.Count <= 0 then
        Commit := False;
      try
        try
          Result := Contextor.EndContextChange(Commit, PendingContext);
        finally
          fIsChanging := False;
          // Reflect the suspension as a result of user selection
          if State = csSuspended then
            begin
              Inc(fSuspensionCount);
              DoOnSuspended;
            end
          else
            UpdateIndicators;
        end;
      except
        if Commit and (PendingContext.Count > 0) then
          Raise;
      end;
    end
  else
    Result := urCommit;

  // Update the local context
  if Commit and (State <> csNotRunning) and (Result <> urCancel) then
    UpdateLocalContext(PendingContext);

  PendingContext := nil;
end;

function TCustomContextor.getApplicationName: WideString;
begin
  if State <> csNotRunning then
    Result := Contextor.Name
  else
    Result := fApplicationName;
end;

function TCustomContextor.getCurrentContext: IContextItemCollection;
begin
  if State = csParticipating then
    Result := Contextor.CurrentContext
  else
    Result := LocalContext;
end;

function TCustomContextor.getNotificationFilter: WideString;
begin
  Result := Subjects.DelimitedText;
end;

function TCustomContextor.getOnCanceled: TNotifyEvent;
begin
  if State <> csNotRunning then
    Result := Contextor.OnCanceled
  else
    Result := nil;
end;

function TCustomContextor.getPassCode: WideString;
var
  i, n: Integer;
begin
  Result := fPassCode;
  if csWriting in ComponentState then
    begin
      n := Length(Result);
      for i:=1 to n do
        Result[i] := WideChar(Ord(Result[i]) xor $A5);
    end;
end;

function TCustomContextor.GetPrivilege(const aSubject: WideString): AccessPrivilege;
begin
  if State <> csNotRunning then
    Result := Contextor.GetPrivilege(aSubject)
  else
    Result := apSet;
end;

function TCustomContextor.getState: TOleEnum;
begin
  if Assigned(Contextor) and Enabled then
    Result := Contextor.State
  else
    Result := csNotRunning;
end;

procedure TCustomContextor.ProcessKnownSubjects(Enforce: Boolean);
begin
end;

procedure TCustomContextor.ProcessOnCommitted(aSender: TObject);
begin
  committed();
end;

procedure TCustomContextor.ProcessOnPending(aSender: TObject;
  const aContextItemCollection: IDispatch);
begin
  if State <> csNotRunning then
    begin
      fForcedChange := False;
      if Assigned(OnPending) then
        OnPending(Self, aContextItemCollection);
    end;
end;

procedure TCustomContextor.RemoveIndicator(anIndicator: TCustomContextorIndicator);
begin
  if Assigned(Indicators) and Assigned(anIndicator) then
    begin
      Indicators.Remove(anIndicator);
      RemoveFreeNotification(anIndicator);
    end;
end;

procedure TCustomContextor.RemoveSubject(const aContext: IContextItemCollection;
  const aSubject: WideString);
var
  ci: IContextItem;
  i: Integer;
  subj: WideString;
begin
  subj := AnsiReplaceText(aSubject, HL7ORG, '');
  for i:=aContext.Count downto 1 do
    begin
      ci := aContext.Item(i);
      if WideSameText(ci.Subject, subj) then
        aContext.Remove(ci.Name);
    end;
end;

procedure TCustomContextor.RemoveTXItem(const aName: WideString);
begin
  if Assigned(PendingContext) then
    try
      PendingContext.Remove(aName);
    except
    end;
end;

procedure TCustomContextor.Resume(aMode: TContextorResumeMode);
var
  i, n: Integer;
  ci: IContextItem;
  secured, commit: Boolean;
begin
  if fSuspensionCount > 0 then
    begin
      if (fSuspensionCount = 1) and (State = csSuspended) then
        begin
          if aMode = crmAskUser then
            if MessageDialog(RSC0001, RSC0002,
              mtConfirmation, [mbYes,mbNo], mrYes, 0) = mrYes then
              aMode := crmUseAppData
            else
              aMode := crmUseGlobalData;

          Contextor.Resume;
          Dec(fSuspensionCount);
          DoOnResumed;

          case aMode of
            crmUseGlobalData:
              begin
                fForcedChange := True;
                committed(True);
              end;
            crmUseAppData:
              begin
                commit := False;
                n := LocalContext.Count;
                if (n > 0) and StartContextChange then
                  try
                    secured := (PassCode <> '');
                    for i:=1 to n do
                      begin
                        ci := LocalContext.Item(i);
                        try
                          // Unfortunately, the GetPrivilege method does not work
                          // in nonsecured applications (it raises an exception) :-(
                          if secured then
                            begin
                              if Contextor.GetPrivilege(ci.Subject) = apSet then
                                AddTXItem(ci.Name, ci.Value);
                            end
                          else if not WideSameText(ci.Subject, 'User') then
                            AddTXItem(ci.Name, ci.Value);
                        except
                        end;
                      end;
                    commit := True;
                  finally
                    if EndContextChange(commit) = urCancel then
                      Suspend;
                  end;
              end;
          end;
        end
      else
        Dec(fSuspensionCount);
    end;
end;

procedure TCustomContextor.Run;
begin
  if Enabled then
    begin
      if (State = csNotRunning) and Assigned(Contextor) then
        begin
          try
            Contextor.Run(ApplicationName, PassCode, Survey, NotificationFilter);
          except
            on e: Exception do
              begin
                fNotRunningReason := e.Message;
                fContextor := nil;
              end;
          end;
          if State = csParticipating then
            begin
              fLocalContext := CoContextItemCollection.Create;
              with Contextor do
                begin
                  OnCommitted := ProcessOnCommitted;
                  OnPending   := ProcessOnPending;
                end;
              committed(True);
            end;
          UpdateIndicators;
        end;
    end;
end;

procedure TCustomContextor.setApplicationName(const aValue: WideString);
begin
  if State = csNotRunning then
    fApplicationName := aValue;
end;

procedure TCustomContextor.setEnabled(const aValue: Boolean);
begin
  if aValue <> fEnabled then
    begin
      if not aValue then
        Suspend;                  // Suspend before disabling
      fEnabled := aValue;
      if aValue then
        Resume(crmUseGlobalData)  // Resume after enabling
      else
        UpdateIndicators;
    end;
end;

procedure TCustomContextor.setNotificationFilter(const aValue: WideString);
begin
  Subjects.DelimitedText := AnsiReplaceStr(aValue, HL7ORG, '');
  if State <> csNotRunning then
    Contextor.NotificationFilter := Subjects.DelimitedText;
end;

procedure TCustomContextor.setOnCanceled(const aValue: TNotifyEvent);
begin
  Contextor.OnCanceled := aValue;
end;

procedure TCustomContextor.setPassCode(const aValue: WideString);
var
  i, n: Integer;
begin
  fPassCode := aValue;
  if csReading in ComponentState then
    begin
      n := Length(fPassCode);
      for i:=1 to n do
        fPassCode[i] := WideChar(Ord(fPassCode[i]) xor $A5);
    end;
end;

procedure TCustomContextor.setPendingContext(const aValue: IContextItemCollection);
begin
  if aValue <> nil then
    fPendingContext := nil;
  fPendingContext := aValue;
end;

procedure TCustomContextor.setSurvey(const aValue: Boolean);
begin
  if State = csNotRunning then
    fSurvey := aValue;
end;

procedure TCustomContextor.SetSurveyResponse(const aReason: WideString);
begin
  if (State = csParticipating) and (aReason <> '') then
    begin
      Contextor.SetSurveyResponse(aReason);
      fForcedChange := True;
    end;
end;

function TCustomContextor.StartContextChange: Boolean;
begin
  Result := False;
  case State of
    csParticipating:
      begin
        fIsChanging := True;
        UpdateIndicators;
        Contextor.StartContextChange;
        PendingContext := CoContextItemCollection.Create;
        Result := True;
      end;
    csSuspended:
      begin
        PendingContext := CoContextItemCollection.Create;
        Result := True;
      end;
  end;
end;

procedure TCustomContextor.Suspend;
begin
  if (fSuspensionCount = 0) and (State = csParticipating) then
    begin
      Contextor.Suspend;
      Inc(fSuspensionCount);
      DoOnSuspended;
    end
  else
    Inc(fSuspensionCount);
end;

procedure TCustomContextor.UpdateIndicators;
var
  i, n: Integer;
begin
  n := Indicators.Count - 1;
  for i:=0 to n do
    if Assigned(Indicators[i]) then
      TCustomContextorIndicator(Indicators[i]).UpdateIndicator;
  Application.ProcessMessages;
end;

procedure TCustomContextor.UpdateLocalContext(const aContext: IContextItemCollection);
var
  lci: IContextItem;
  i: Integer;
  subjlst: TWideStringList;
begin
  if Assigned(aContext) then
    begin
      subjlst := TWideStringList.Create;
      subjlst.Sorted := True;
      subjlst.Duplicates := dupError;
      try
        for i:=1 to aContext.Count do
          begin
            lci := aContext.Item(i).Clone;
            // Remove the standard domain name (it is redundant)
            lci.Subject := AnsiReplaceStr(lci.Subject, HL7ORG, '');
            // When a new identifier is added to the local context,
            // clear the old items with the same subject
            if WideSameText(lci.Role, 'id') then
              try
                subjlst.Add(lci.Subject);
                // If the subject is already in the list then the
                // EStringListError exception is generated and
                // the following operator is not executed
                RemoveSubject(LocalContext, lci.Subject);
              except
              end;
            // Copy the item to the local context
            LocalContext.Add(lci);
            lci := nil;
          end;
      finally
        subjlst.Free;
      end;
    end;
end;

///////////////////////// TCustomContextorIndicator \\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCustomContextorIndicator.Create(anOwner: TComponent);
begin
  inherited;

  AutoSize    := False;
  BevelInner  := bvNone;
  BevelOuter  := bvNone;
  Caption     := '';
  DockSite    := False;
  Hint        := '';

  if csDesigning in ComponentState then
    fLinkStatus := clsBroken
  else
    fLinkStatus := clsUnknown;

  Constraints.MinHeight := 16;
  Constraints.MinWidth  := 16;
end;

destructor TCustomContextorIndicator.Destroy;
begin
  Contextor := nil;
  if Images = DefaultImages then
    UnloadDefaultImages;
  inherited;
end;

procedure TCustomContextorIndicator.Loaded;
begin
  inherited;
  if not Assigned(Images) then
    Images := LoadDefaultImages;
end;

procedure TCustomContextorIndicator.Notification(aComponent: TComponent;
  anOperation: TOperation);
begin
  inherited;
  if anOperation = opRemove then
    begin
      if aComponent = Contextor then
        Contextor := nil
      else if aComponent = Images then
        Images := nil;
    end;
end;

procedure TCustomContextorIndicator.ProcessBreak(aSender: TObject);
begin
  if Assigned(Contextor) then
    Contextor.Suspend;
end;

procedure TCustomContextorIndicator.ProcessRejoin(aSender: TObject);
begin
end;

procedure TCustomContextorIndicator.setContextor(const aValue: TCustomContextor);
begin
  if aValue <> fContextor then
    begin
      if Assigned(fContextor) then
        fContextor.RemoveIndicator(Self);
      fContextor := aValue;
      if Assigned(fContextor) then
        fContextor.AddIndicator(Self);
    end;
end;

procedure TCustomContextorIndicator.SetEnabled(aValue: Boolean);
begin
  inherited;
  UpdateIndicator;
end;

procedure TCustomContextorIndicator.UpdateIndicator;
var
  newState: TContextLinkStatus;
begin
  if Assigned(Contextor) and (Enabled or (fLinkStatus <> clsUnknown)) then
    begin
      newState := clsUnknown;
      if Enabled then
        case Contextor.State of
          csParticipating:
            if Contextor.IsChanging then
              newState := clsChanging
            else
              newState := clsLink;
          csSuspended:
            newState := clsBroken;
        end;
      if newState <> fLinkStatus then
        begin
          fLinkStatus := newState;
          if Assigned(OnUpdate) then
            OnUpdate(Self);
          RePaint;
        end;
    end;
end;

end.
