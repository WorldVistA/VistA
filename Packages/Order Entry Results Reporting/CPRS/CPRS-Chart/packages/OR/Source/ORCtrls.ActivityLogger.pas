unit ORCtrls.ActivityLogger;
///////////////////////////////////////////////////////////////////////////////
/// This unit defines a class, TActivityLogger, that creates some "detours",
/// using DDetours.pas, to log certain system events, such as Button Clicks.
/// It logs these events in an ActivityLog, as defined in unit UActivityLog.
///
/// TActivityLogger should not be instantiated. It consists entirely of class
/// variables and methods.
///
/// TActivityLogger.Enabled: set to True to start logging and place hooks.
///   False will unhook the hooks and stop the logging.
/// TActivityLogger.Log: Other units can add events to the ActivityLog
///   maintaned by TActivityLogger by calling TActivityLogger.Log.Add.
/// TActivityLogger.LogMaxSize: TActivityLogger maintains a Timer which, every
///   minute, cuts the log down to LogMaxSize
///////////////////////////////////////////////////////////////////////////////
interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.Forms,
  ORCtrls.ActivityLog;

type
  TActivityLogger = class(TObject)
  strict private
    class constructor Create;
    class destructor Destroy;
    class procedure SetEnabled(const Value: Boolean); static;
    class var FEnabled: Boolean;
    class var FLog: TActivityLog;
    class var FCleanupTimer: TTimer;
    class procedure CleanupTimerTimer(Sender: TObject);
    class var FLogMaxSize: Integer;
  strict private
    // All intercept logic
    class var FOldControlClick: procedure(ASelf: TControl);
    class procedure InterceptControlClick(ASelf: TControl); static;
    class var FOldControlDblClick: procedure(ASelf: TControl);
    class procedure InterceptControlDblClick(ASelf: TControl); static;
    class var FOldControlChanged: procedure(ASelf: TControl);
    class procedure InterceptControlChanged(ASelf: TControl); static;
    class var FOldMenuItemClick: procedure(ASelf: TMenuItem);
    class procedure InterceptMenuItemClick(ASelf: TMenuItem); static;
    class var FOldActionExecute: function(ASelf: TBasicAction): Boolean;
    class function InterceptActionExecute(ASelf: TBasicAction): Boolean; static;
    class var FOldTabChange: procedure(ASelf: TCustomTabControl);
    class procedure InterceptTabChange(ASelf: TCustomTabControl); static;
    class var FOldTreeViewChange: procedure(ASelf: TCustomTreeView; ANode: TTreeNode);
    class procedure InterceptTreeViewChange(ASelf: TCustomTreeView; ANode: TTreeNode); static;
    class var FOldListViewChange: procedure(ASelf: TCustomListView; AItem: TListItem; AChange: Integer);
    class procedure InterceptListViewChange(ASelf: TCustomListView; AItem: TListItem; AChange: Integer); static;
    class var FOldTrackBarChanged: procedure(ASelf: TTrackBar);
    class procedure InterceptTrackBarChanged(ASelf: TTrackBar); static;
    class var FOldDateTimePickerChange: procedure(ASelf: TDateTimePicker);
    class procedure InterceptDateTimePickerChange(ASelf: TDateTimePicker); static;
    class var FOldFormDoCreate: procedure(ASelf: TCustomForm);
    class procedure InterceptFormDoCreate(ASelf: TCustomForm); static;
    class var FOldFormDoDestroy: procedure(ASelf: TCustomForm);
    class procedure InterceptFormDoDestroy(ASelf: TCustomForm); static;
    class var FOldFormCloseQuery: function(ASelf: TCustomForm): Boolean;
    class function InterceptFormCloseQuery(ASelf: TCustomForm): Boolean; static;
    class var FOldFormDoClose: procedure(ASelf: TCustomForm; var AAction: TCloseAction);
    class procedure InterceptFormDoClose(ASelf: TCustomForm; var AAction: TCloseAction); static;
    class var FOldObjectNewInstance: function(ASelf: TObject): TObject;
    class function InterceptObjectNewInstance(ASelf: TObject): TObject; static;
  public
    constructor Create;
    class property Log: TActivityLog read FLog;
    class property Enabled: Boolean read FEnabled write SetEnabled;
    class property LogMaxSize: Integer read FLogMaxSize write FLogMaxSize;
    class procedure Cleanup;
  end;

implementation

uses
  DDetours,
  Vcl.StdCtrls,
  System.SysUtils,
  System.TypInfo;

class constructor TActivityLogger.Create;
begin
  FLog := TActivityLog.Create;
  FLogMaxSize := 100;

  // Set up a timer that prunes the log every minute
  FCleanupTimer := TTimer.Create(nil);
  FCleanupTimer.Enabled := False;
  FCleanupTimer.OnTimer := CleanupTimerTimer;
  FCleanupTimer.Interval := 60000;
end;

class destructor TActivityLogger.Destroy;
begin
  Enabled := False;
  FreeAndNil(FCleanupTimer);
  FreeAndNil(FLog);
end;

constructor TActivityLogger.Create;
begin
  raise Exception.Create('Do not instantiate TActivityLogger. You need to '+
   'use this class through its class methods and class properties. Please '+
   'read the comment section in the header of unit TActivityLogger');
end;

class procedure TActivityLogger.Cleanup;
begin
  FLog.CleanUp(FLogMaxSize);
end;

class procedure TActivityLogger.CleanupTimerTimer(Sender: TObject);
begin
  CleanUp;
end;

type
  TCustomFormAccess = class(TCustomForm);
  TControlAccess = class(TControl);
  TCustomTabControlAccess = class(TCustomTabControl);
  TCustomTreeViewAccess = class(TCustomTreeView);
  TCustomListViewAccess = class(TCustomListView);
  TTrackBarAccess = class(TTrackBar);
  TDateTimePickerAccess = class(TDateTimePicker);

class procedure TActivityLogger.SetEnabled(const Value: Boolean);

  function InterceptRemove(var ATrampoLine: Pointer): Integer;
  begin
    Result := DDetours.InterceptRemove(ATrampoLine);
    ATrampoLine := nil;
  end;

begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FEnabled then
    begin
      FOldControlClick := InterceptCreate(@TControlAccess.Click, @InterceptControlClick);
      FOldControlDblClick:= InterceptCreate(@TControlAccess.DblClick, @InterceptControlDblClick);
      FOldControlChanged := InterceptCreate(@TControlAccess.Changed, @InterceptControlChanged);
      FOldMenuItemClick := InterceptCreate(@TMenuItem.Click, @InterceptMenuItemClick);
      FOldActionExecute := InterceptCreate(@TBasicAction.Execute, @InterceptActionExecute);
      FOldTabChange := InterceptCreate(@TCustomTabControlAccess.Change, @InterceptTabChange);
      FOldTreeViewChange := InterceptCreate(@TCustomTreeViewAccess.Change, @InterceptTreeViewChange);
      FOldListViewChange := InterceptCreate(@TCustomListViewAccess.Change, @InterceptListViewChange);
      FOldTrackBarChanged := InterceptCreate(@TTrackBarAccess.Changed, @InterceptTrackBarChanged);
      FOldDateTimePickerChange := InterceptCreate(@TDateTimePickerAccess.Change, @InterceptDateTimePickerChange);
      FOldFormDoCreate := InterceptCreate(@TCustomFormAccess.DoCreate, @InterceptFormDoCreate);
      FOldFormDoDestroy := InterceptCreate(@TCustomFormAccess.DoDestroy, @InterceptFormDoDestroy);
      FOldFormCloseQuery := InterceptCreate(@TCustomFormAccess.CloseQuery, @InterceptFormCloseQuery);
      FOldFormDoClose := InterceptCreate(@TCustomFormAccess.DoClose, @InterceptFormDoClose);
      FOldObjectNewInstance := InterceptCreate(@TObject.NewInstance, @InterceptObjectNewInstance);
      FCleanupTimer.Enabled := True;
    end else begin
      FCleanupTimer.Enabled := False;
      InterceptRemove(@FOldObjectNewInstance);
      InterceptRemove(@FOldFormDoClose);
      InterceptRemove(@FOldFormCloseQuery);
      InterceptRemove(@FOldFormDoDestroy);
      InterceptRemove(@FOldFormDoCreate);
      InterceptRemove(@FOldDateTimePickerChange);
      InterceptRemove(@FOldTrackBarChanged);
      InterceptRemove(@FOldListViewChange);
      InterceptRemove(@FOldTreeViewChange);
      InterceptRemove(@FOldTabChange);
      InterceptRemove(@FOldActionExecute);
      InterceptRemove(@FOldMenuItemClick);
      InterceptRemove(@FOldControlChanged);
      InterceptRemove(@FOldControlDblClick);
      InterceptRemove(@FOldControlClick);
    end;
  end;
end;

class procedure TActivityLogger.InterceptControlClick(ASelf: TControl);
var
  Form: TCustomForm;
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    // The list below is because we already log other events on those classes
    (not(ASelf is TCustomTreeView)) and (not(ASelf is TCustomListView)) and
    (not(ASelf is TTrackBar)) and (not(ASelf is TDateTimePicker)) and
    (not(ASelf is TCustomTabControl)) then
  begin
    if Assigned(TControlAccess(ASelf).OnClick) then
    begin
      // If we don't already log the action, let's log the buttonclick
      if ((not Assigned(ASelf.Action)) or
        (TMethod(TControlAccess(ASelf).OnClick) <>
        TMethod(ASelf.Action.OnExecute))) then FLog.Add('Click', ASelf);
    end else begin
      // We also want to log a Button with a ModalResult on a Form that's shown
      // modal, even if the Button.OnCick isn't assigned
      if (ASelf is TCustomButton) and
        (TCustomButton(ASelf).ModalResult <> mrNone) and
        ((not Assigned(ASelf.Action)) or (not Assigned(ASelf.Action.OnExecute)))
      then
      begin
        Form := GetParentForm(ASelf);
        if Assigned(Form) and (fsModal in Form.FormState) then
          FLog.Add('Click', ASelf);
      end;
    end;
  end;
  FOldControlClick(ASelf);
end;

class procedure TActivityLogger.InterceptControlDblClick(ASelf: TControl);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    Assigned(TControlAccess(ASelf).OnDblClick) then
      FLog.Add('DblClick', ASelf);
  FOldControlDblClick(ASelf);
end;

class procedure TActivityLogger.InterceptControlChanged(ASelf: TControl);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    (not(ASelf is TCustomEdit)) then FLog.Add('Changed', ASelf);
end;

class procedure TActivityLogger.InterceptMenuItemClick(ASelf: TMenuItem);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    Assigned(ASelf.OnClick) and ((not Assigned(ASelf.Action)) or
    (TMethod(ASelf.OnClick) <> TMethod(ASelf.Action.OnExecute))) then
      FLog.Add('Click', ASelf);
  FOldMenuItemClick(ASelf);
end;

class function TActivityLogger.InterceptActionExecute
  (ASelf: TBasicAction): Boolean;
var
  ActivityID: TGuid;
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    Assigned(ASelf.OnExecute) then
  begin
    ActivityID := FLog.Add('Execute', ASelf);
    Result := FOldActionExecute(ASelf);
    FLog.Modify(ActivityID, 'Result = ' + BoolToStr(Result, True));
  end else begin
    Result := FOldActionExecute(ASelf);
  end;
end;

class procedure TActivityLogger.InterceptTabChange(ASelf: TCustomTabControl);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) then
  begin
    FLog.Add('Change', ASelf,
      Format('TabIndex = %d', [TCustomTabControlAccess(ASelf).TabIndex]));
  end;
  FOldTabChange(ASelf);
end;

class procedure TActivityLogger.InterceptTreeViewChange(ASelf: TCustomTreeView;
  ANode: TTreeNode);
var
  ANodeText: string;
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) then
  begin
    // No logging of Node.Text for fear of capturing PPI
    if not Assigned(ANode) then
    begin
      ANodeText := 'Node = nil';
    end else begin
      ANodeText := Format('Node.Level = %:d', [ANode.Level]);
      if ANode.ClassType <> TTreeNode then
        ANodeText := Format('Node: %0:s; %1:s', [ANode.ClassName, ANodeText]);
    end;
    FLog.Add('Change', ASelf, ANodeText);
  end;
  FOldTreeViewChange(ASelf, ANode);
end;

class procedure TActivityLogger.InterceptListViewChange(ASelf: TCustomListView;
  AItem: TListItem; AChange: Integer);
var
  AItemText: string;
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) then
  begin
    // No logging of Item.Caption for fear of capturing PPI
    if not Assigned(AItem) then
    begin
      AItemText := Format('Item = nil; Change = %d', [AChange]);
    end else begin
      if AItem.ClassType = TListItem then
        AItemText := 'Change = %1:d'
      else AItemText := 'Item: %0:s; Change = %1:d';
      AItemText := Format(AItemText, [AItem.ClassName, AChange])
    end;
    FLog.Add('Change', ASelf, AItemText);
  end;
  FOldListViewChange(ASelf, AItem, AChange);
end;

class procedure TActivityLogger.InterceptTrackBarChanged(ASelf: TTrackBar);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) then
    FLog.Add('Changed', ASelf);
  FOldTrackBarChanged(ASelf);
end;

class procedure TActivityLogger.InterceptDateTimePickerChange(
  ASelf: TDateTimePicker);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) then
    FLog.Add('Change', ASelf);
  FOldDateTimePickerChange(ASelf);
end;

class procedure TActivityLogger.InterceptFormDoCreate(ASelf: TCustomForm);
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) then
    FLog.Add('Create', ASelf);
  FOldFormDoCreate(ASelf);
end;

class procedure TActivityLogger.InterceptFormDoDestroy(ASelf: TCustomForm);
begin
  if Assigned(ASelf) then FLog.Add('Destroy', ASelf);
  FOldFormDoDestroy(ASelf);
end;

class function TActivityLogger.InterceptFormCloseQuery
  (ASelf: TCustomForm): Boolean;
var
  AID: TGuid;
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    Assigned(TCustomFormAccess(ASelf).OnCloseQuery) then
  begin
    AID := FLog.Add('CloseQuery', ASelf);
    Result := FOldFormCloseQuery(ASelf);
    FLog.Modify(AID, 'Result = ' + BoolToStr(Result, True));
  end else begin
    Result := FOldFormCloseQuery(ASelf);
  end;
end;

class procedure TActivityLogger.InterceptFormDoClose(ASelf: TCustomForm;
  var AAction: TCloseAction);
var
  AID: TGuid;
begin
  if Assigned(ASelf) and (not(csDestroying in ASelf.ComponentState)) and
    Assigned(TCustomFormAccess(ASelf).OnClose) then
  begin
    AID := FLog.Add('DoClose', ASelf, '', 'Action (before) = ' +
      GetEnumName(TypeInfo(TCloseAction), Ord(AAction)));
    FOldFormDoClose(ASelf, AAction);
    FLog.Modify(AID, 'Action = ' + GetEnumName(TypeInfo(TCloseAction),
      Ord(AAction)));
  end else begin
    FOldFormDoClose(ASelf, AAction);
  end;
end;

class function TActivityLogger.InterceptObjectNewInstance(ASelf: TObject): TObject;
begin
  Result := FOldObjectNewInstance(ASelf);
  if Assigned(Result) and (Result is Exception) then
  begin
    FLog.Add('NewInstance', Result);
  end;
end;

end.
