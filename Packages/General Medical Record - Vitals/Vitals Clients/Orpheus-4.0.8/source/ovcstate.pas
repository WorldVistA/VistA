{*********************************************************}
{*                  OVCSTATE.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcstate;
  {-component to save and restore the form state}

interface

uses
  Windows, Classes, Controls, Forms, Messages, SysUtils,
  OvcBase, OvcData, OvcMisc, OvcFiler, OvcExcpt, OvcConst;

type
  TOvcFormStateOption  = (fsState, fsPosition, fsNoSize, fsColor,
    fsActiveControl, fsDefaultMonitor);
  TOvcFormStateOptions = set of TOvcFormStateOption;

type
  TOvcAbstractState = class(TOvcComponent)

  protected {private}
    {property variables}
    FActive             : Boolean;
    FSection            : string;
    FStorage            : TOvcAbstractStore;

    {event variables}
    FOnSaveState        : TNotifyEvent;
    FOnRestoreState     : TNotifyEvent;

    {internal variables}
    isDestroying         : Boolean;
    isRestored           : Boolean;
    isSaved              : Boolean;
    isSaveFormCreate     : TNotifyEvent;
    isSaveFormDestroy    : TNotifyEvent;
    isSaveFormCloseQuery : TCloseQueryEvent;

    {property methods}
    function GetForm  : TWinControl;
    function GetSection : string;
    function GetSpecialValue(const Item : string): string;
    procedure SetSpecialValue(const Item : string; const Value : string);
    procedure SetStorage(Value : TOvcAbstractStore);

    {internal methods}
    procedure FormCloseQuery(Sender : TObject; var CanClose : Boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure RestoreEvents;

  protected
    procedure Loaded;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    procedure DoOnRestoreState;
      dynamic;
    procedure DoOnSaveState;
      dynamic;

    procedure RestoreStatePrim;
      virtual; abstract;
    procedure SaveStatePrim;
      virtual; abstract;
    procedure SetEvents;
      dynamic;

    property Form : TWinControl
      read GetForm;


    {properties}
    property Active : Boolean
      read FActive write FActive;
    property Section : string
      read GetSection write FSection;
    property Storage : TOvcAbstractStore
      read FStorage write SetStorage;

    {events}
    property OnSaveState : TNotifyEvent
      read FOnSaveState write FOnSaveState;

    property OnRestoreState : TNotifyEvent
      read FOnRestoreState write FOnRestoreState;

  public

    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    procedure RestoreState;
    procedure SaveState;

    property SpecialValue[const Item : string] : string
      read GetSpecialValue write SetSpecialValue;
  end;

  TOvcFormState = class(TOvcAbstractState)

  protected {private}
    {property variables}
    FOptions     : TOvcFormStateOptions;

    {internal variables}
    FDefMaximize : Boolean;

    {internal methods}
    procedure UpdateFormState;
(*
    procedure ReadFormState(Form : TCustomForm; const Section : string);
    procedure WriteFormState(Form : TCustomForm; const Section : string);
*)
    procedure ReadFormState(Form : TWinControl; const Section : string);
    procedure WriteFormState(Form : TWinControl; const Section : string);

  protected
    procedure RestoreStatePrim;
      override;
    procedure SaveStatePrim;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;


  published
    {properties}
    property Active default True;
    property Options : TOvcFormStateOptions
      read FOptions write FOptions;
    property Section;
    property Storage;

    {events}
    property OnSaveState;
    property OnRestoreState;
  end;

  TOvcComponentState = class(TOvcAbstractState)

  protected {private}
    {property variables}
    FStoredProperties : TStrings;

    procedure SetStoredProperties(Value : TStrings);

  protected
    procedure Loaded;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;
    procedure RestoreStatePrim;
      override;
    procedure SaveStatePrim;
      override;
    procedure WriteState(Writer: TWriter);
      override;

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetNotification;

    procedure UpdateStoredProperties;

  published
    {properties}
    property Active default True;
    property Section;
    property Storage;
    property StoredProperties : TStrings
      read FStoredProperties write SetStoredProperties;

    {events}
    property OnSaveState;
    property OnRestoreState;
  end;

  TOvcPersistentState = class(TOvcComponent)

  protected {private}
    {property variables}
    FStorage : TOvcAbstractStore;

    {property methods}
    procedure SetStorage(Value : TOvcAbstractStore);

  protected
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;


  public
    procedure RestoreState(AnObject : TPersistent; const ASection : string);
    procedure SaveState(AnObject : TPersistent; const ASection : string);

  published
    {properties}
    property Storage : TOvcAbstractStore
      read FStorage write SetStorage;
  end;



function GetDefaultSection(Component : TComponent) : string;



implementation

const
  cActiveCtrl = 'ActiveControl';
  cFlags      = 'Flags';
  cItem       = 'Item%d';
  cListCount  = 'Count';
  cMDIChild   = 'MDI Children';
  cNormPos    = 'NormalPos';
  cShowCmd    = 'ShowCmd';
  cMonitor    = 'DefaultMonitor';
  cFormColor  = 'Color';
  cPixelsPerInch = 'PixelsPerInch';


{*** utility routines ***}

        {revised}
function GetDefaultSection(Component : TComponent) : string;
var
(*
  F     : TForm;
*)
  F     : TWinControl;
  Owner : TComponent;
begin
  if Component <> nil then begin
    if (Component is TCustomForm) then
      Result := Component.ClassName
    else if (Component is TCustomFrame) then
      Result := Component.Owner.ClassName
    else begin
      Result := Component.Name;
      if Component is TControl then begin
(*
        F := TForm(GetParentForm(TControl(Component)));
*)
        F := GetImmediateParentForm(TControl(Component));
        if F <> nil then begin
          if F.Name > '' then
            Result := Format('%s.%s', [F.Name, Result])
          else
            Result := Format('%s.%s', [F.ClassName, Result]);
        end else begin
          if TControl(Component).Parent <> nil then
            Result := Format('%s.%s', [TControl(Component).Parent.Name, Result]);
        end;
      end else begin
        Owner := Component.Owner;
        if (Owner is TCustomForm) or (Owner is TCustomFrame) then
          Result := Format('%s.%s', [Owner.ClassName, Result]);
      end;
    end;
  end else
    Result := '';
end;


{*** TOvcAbstractState ***}

constructor TOvcAbstractState.Create(AOwner : TComponent);
begin
  if not ((AOwner is TCustomForm) or
          (AOwner is TCustomFrame)) then
    raise EOvcException.Create(GetOrphStr(SCFormUseOnly));

  inherited Create(AOwner);

  FActive := True;
end;

destructor TOvcAbstractState.Destroy;
begin
  if not (csDesigning in ComponentState) then
    RestoreEvents;

  inherited Destroy;
end;

procedure TOvcAbstractState.DoOnSaveState;
begin
  if Assigned(FOnSaveState) then
    FOnSaveState(Self);
end;

procedure TOvcAbstractState.DoOnRestoreState;
begin
  if Assigned(FOnRestoreState) then
    FOnRestoreState(Self);
end;

procedure TOvcAbstractState.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin
  if Assigned(isSaveFormCloseQuery) then
    isSaveFormCloseQuery(Sender, CanClose);

  if CanClose and Active and (Form.Handle <> 0) then
    try
      SaveState;
    except
      Application.HandleException(Self);
    end;
end;

procedure TOvcAbstractState.FormCreate(Sender : TObject);
begin
  {call original OnCreate event for form}
  if Assigned(isSaveFormCreate) then
    isSaveFormCreate(Sender);

  if Active then begin
    try
      RestoreState;
    except
      Application.HandleException(Self);
    end;
  end;
end;

procedure TOvcAbstractState.FormDestroy(Sender : TObject);
begin
  if Active and not isSaved then begin
    isDestroying := True;
    try
      SaveState;
    except
      Application.HandleException(Self);
    end;
    isDestroying := False;
  end;

  if Assigned(isSaveFormDestroy) then
    isSaveFormDestroy(Sender);
end;


function TOvcAbstractState.GetForm : TWinControl;
begin
  if (Owner is TCustomForm) then
    Result := Owner as TWinControl
  else begin
    Result := Owner.Owner as TWinControl;
  end;
end;


function TOvcAbstractState.GetSection : string;
begin
  if FSection > '' then
    Result := FSection
  else
    Result := GetDefaultSection(Owner);
end;


function TOvcAbstractState.GetSpecialValue(const Item: string) : string;
begin
  if Assigned(FStorage) then begin
    FStorage.Open;
    try
      Result := FStorage.ReadString(FSection, Item, '');
    finally
      FStorage.Close;
    end;
  end else
    Result := '';
end;

procedure TOvcAbstractState.Loaded;
var
  WasLoading : Boolean;
begin
  WasLoading := csLoading in ComponentState;

  inherited Loaded;

  if not (csDesigning in ComponentState) then
    if WasLoading then
      SetEvents;
end;

procedure TOvcAbstractState.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if (AComponent = FStorage) then begin
      FActive := False;
      FStorage := nil;
    end;
end;

procedure TOvcAbstractState.RestoreEvents;
begin
  if Owner <> nil then
    with TForm(Form) do begin
      OnCreate := isSaveFormCreate;
      OnCloseQuery := isSaveFormCloseQuery;
      OnDestroy := isSaveFormDestroy;
    end;
end;

procedure TOvcAbstractState.RestoreState;
begin
  isSaved := False;
  RestoreStatePrim;
  isRestored := True;
  DoOnRestoreState;
end;

procedure TOvcAbstractState.SaveState;
begin
  if isRestored or not Active then begin
    SaveStatePrim;
    DoOnSaveState;
    isSaved := True;
  end;
end;

procedure TOvcAbstractState.SetEvents;
begin
  with TForm(Form) do begin
    isSaveFormCreate := OnCreate;
    OnCreate := FormCreate;
    isSaveFormCloseQuery := OnCloseQuery;
    OnCloseQuery := FormCloseQuery;
    isSaveFormDestroy := OnDestroy;
    OnDestroy := FormDestroy;
  end;
end;


procedure TOvcAbstractState.SetSpecialValue(const Item : string; const Value : string);
begin
  if Assigned(FStorage) then begin
    FStorage.Open;
    try
      FStorage.WriteString(FSection, Item, Value);
    finally
      FStorage.Close;
    end;
  end;
end;

procedure TOvcAbstractState.SetStorage(Value : TOvcAbstractStore);
begin
  FStorage := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;


{*** TOvcFormState ***}

constructor TOvcFormState.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if (AOwner is TCustomForm) or (AOwner is TCustomFrame) then begin
    FOptions := [fsState, fsPosition];
  end else
    FOptions := [];
end;

{$HINTS OFF}
type
  TLocalForm = class(TScrollingWinControl)
  private
    FActiveControl  : TWinControl;
    FFocusedControl : TWinControl;
    FBorderIcons    : TBorderIcons;
    FBorderStyle    : TFormBorderStyle;
    FWindowState    : TWindowState;
  end;

procedure TOvcFormState.ReadFormState(Form : TWinControl; const Section : string);
  {Changes:
     01/2013, AB: Bugfix: if this method was called for a visible TForm, then the form
        disappeared, because SetWindowPlacement was called with Placement.ShowCmd =
        SW_HIDE. }
const
  Delims = [',', ' '];
  ShowCommands: array[TWindowState] of Integer =
    (SW_SHOWNORMAL, SW_MINIMIZE, SW_SHOWMAXIMIZED);
var
  Placement : TWindowPlacement;
  WinState  : TWindowState;
  S         : string;
  X         : Integer;
  AForm     : TCustomForm;
begin
  if (Form is TCustomForm) then
    AForm := TCustomForm(Form)
  else
    Exit;

  if not Assigned(FStorage) then
    Exit;
  if not ((fsState in FOptions) or (fsPosition in FOptions)) then
    Exit;


  {see if screen res has changed - if so, exit rather than mess things up}
  X := FStorage.ReadInteger(Section, cPixelsPerInch, TForm(Form).PixelsPerInch);
  if X <> TForm(AForm).PixelsPerInch then
    Exit;

  FillChar(Placement, SizeOf(Placement), #0);
  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @Placement);

  with Placement, TForm(Form) do begin
    { Do not set ShowCmd to SW_HIDE when the form is visible - otherwise the call to
      SetWindowPlacement later on will make the window disappear. }
    if Visible then
      ShowCmd := ShowCommands[WindowState]
    else
      ShowCmd := SW_HIDE;
    if (fsPosition in FOptions) then begin
      Flags := StrToIntDef(FStorage.ReadString(Section, cFlags, ''), Flags);
      S := FStorage.ReadString(Section, cNormPos, '');
      if S <> '' then begin
        if (Form is TForm) then
          TForm(Form).Position := poDesigned;
        if (fsNoSize in FOptions) then begin
          rcNormalPosition.Left := StrToIntDef(ExtractWord(1, S, Delims), Left);
          rcNormalPosition.Top := StrToIntDef(ExtractWord(2, S, Delims), Top);
          Top := rcNormalPosition.Top;
          Left := rcNormalPosition.Left;
        end else begin
          rcNormalPosition.Left := StrToIntDef(ExtractWord(1, S, Delims), Left);
          rcNormalPosition.Top := StrToIntDef(ExtractWord(2, S, Delims), Top);
          rcNormalPosition.Right := StrToIntDef(ExtractWord(3, S, Delims), Left + Width);
          rcNormalPosition.Bottom := StrToIntDef(ExtractWord(4, S, Delims), Top + Height);
          if not (BorderStyle in [bsSizeable, bsSizeToolWin]) then
            rcNormalPosition := Rect(rcNormalPosition.Left, rcNormalPosition.Top,
              rcNormalPosition.Left + Width, rcNormalPosition.Top + Height);
          if rcNormalPosition.Right > rcNormalPosition.Left then
            SetWindowPlacement(Handle, @Placement);
        end;
      end
      else Exit;
    end;

    if (fsState in FOptions) then begin
      WinState := wsNormal;
      {default maximize MDI main form}
      if (Application.MainForm = Form) and (FormStyle = fsMDIForm) then
        WinState := wsMaximized;
      ShowCmd := StrToIntDef(FStorage.ReadString(Section, cShowCmd, ''), SW_HIDE);
      case ShowCmd of
        SW_SHOWNORMAL, SW_RESTORE, SW_SHOW : WinState := wsNormal;
        SW_MINIMIZE, SW_SHOWMINIMIZED      : WinState := wsMinimized;
        SW_MAXIMIZE                        : WinState := wsMaximized;
      else
        WinState := wsNormal;
      end;
      if (WinState = wsMinimized) and (Form = Application.MainForm) then begin
        PostMessage(Application.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
        Exit;
      end;
      WindowState := WinState;
    end;

    if fsDefaultMonitor in FOptions then begin
      S :=FStorage.ReadString(Section, cMonitor, '');
      if (S > '') then
        try
          DefaultMonitor := TDefaultMonitor(StrToInt(S));
        except
        end;
    end;

    if (fsColor in FOptions) then
      AForm.Color :=
        FStorage.ReadInteger(Section, cFormColor, AForm.Color);

    Update;
  end;
end;


(*
procedure TOvcFormState.WriteFormState(Form : TCustomForm; const Section : string);
*)
procedure TOvcFormState.WriteFormState(Form : TWinControl; const Section : string);
var
  Placement : TWindowPlacement;
  AForm     : TCustomForm;
begin
  if not (Form is TCustomForm) then
    Exit
  else
    AForm := TCustomForm(Form);

  if not Assigned(FStorage) then
    Exit;

  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(AForm.Handle, @Placement);

  with Placement, TForm(AForm) do begin
    if (AForm = Application.MainForm) and IsIconic(Application.Handle) then
      ShowCmd := SW_SHOWMINIMIZED;
    if (FormStyle = fsMDIChild) and (WindowState = wsMinimized) then
      Flags := Flags or WPF_SETMINPOSITION;
    FStorage.WriteString(Section, cFlags, IntToStr(Flags));
    FStorage.WriteString(Section, cShowCmd, IntToStr(ShowCmd));
    FStorage.WriteString(Section, cNormPos, Format('%d,%d,%d,%d',
      [rcNormalPosition.Left, rcNormalPosition.Top, rcNormalPosition.Right,
      rcNormalPosition.Bottom]));
    FStorage.WriteInteger(Section, cPixelsPerInch, PixelsPerInch);

    if fsDefaultMonitor in Options then
      FStorage.WriteString(Section, cMonitor, IntToStr(Ord(DefaultMonitor)));

    FStorage.WriteInteger(Section, cFormColor, Color);
  end;
end;

procedure TOvcFormState.RestoreStatePrim;
var
  ActiveCtrl : TComponent;
  S          : string;
begin
  if not Assigned(FStorage) then
    Exit;

  FStorage.Open;
  try
    ReadFormState(Form, FSection);
    if fsActiveControl in Options then begin
      S := FStorage.ReadString(FSection, cActiveCtrl, '');
      ActiveCtrl := Form.FindComponent(S);
      if (ActiveCtrl <> nil) and (ActiveCtrl is TWinControl) and
        TWinControl(ActiveCtrl).CanFocus then
          TCustomForm(Form).ActiveControl := TWinControl(ActiveCtrl);
    end;
    UpdateFormState;
  finally
    FStorage.Close;
  end;
end;

procedure TOvcFormState.SaveStatePrim;
var
  AForm : TCustomForm;
begin
  if not Assigned(FStorage) then
    Exit;

  AForm := TCustomForm(Form);
  FStorage.Open;
  try
    WriteFormState(Form, FSection);
    if (fsActiveControl in Options) and
       (AForm.ActiveControl <> nil) then
      FStorage.WriteString(FSection,
                           cActiveCtrl,
                           AForm.ActiveControl.Name);
  finally
    FStorage.Close;
  end;
end;

procedure TOvcFormState.UpdateFormState;
const
  Metrics: array[bsSingle..bsSizeToolWin] of Word =
    (SM_CXBORDER, SM_CXFRAME, SM_CXDLGFRAME, SM_CXBORDER, SM_CXFRAME);
var
  Placement : TWindowPlacement;
begin
  if (Owner <> nil) and Form.HandleAllocated and not (csLoading in ComponentState) then begin
    Placement.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(Form.Handle, @Placement);
    if TForm(Form).BorderStyle <> bsNone then begin
      Placement.ptMaxPosition.X :=
        -GetSystemMetrics(Metrics[TForm(Form).BorderStyle]);
      Placement.ptMaxPosition.Y :=
        -GetSystemMetrics(Metrics[TForm(Form).BorderStyle] + 1);
    end else
      Placement.ptMaxPosition := Point(0, 0);

    if IsWindowVisible(Form.Handle) then
      SetWindowPlacement(Form.Handle, @Placement);
  end;
end;

{*** TOvcComponentState ***}

constructor TOvcComponentState.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FStoredProperties := TStringList.Create;
end;

destructor TOvcComponentState.Destroy;
begin
  FStoredProperties.Free;
  FStoredProperties := nil;

  inherited Destroy;
end;

procedure TOvcComponentState.Loaded;
begin
  inherited Loaded;

  UpdateStoredList(TWinControl(Owner), FStoredProperties, True);
end;

procedure TOvcComponentState.Notification(AComponent : TComponent; Operation : TOperation);
var
  I         : Integer;
  Component : TComponent;
begin
  inherited Notification(AComponent, Operation);

  if not (csDestroying in ComponentState) and (Operation = opRemove) and
      (FStoredProperties <> nil) then
    for I := FStoredProperties.Count - 1 downto 0 do begin
      Component := TComponent(FStoredProperties.Objects[I]);
      if Component = AComponent then
        FStoredProperties.Delete(I);
    end;
end;

procedure TOvcComponentState.RestoreStatePrim;
begin
  if not Assigned(FStorage) then
    Exit;

  isRestored := True;
  with TOvcDataFiler.Create do
  try
    Section := Self.FSection;
    Storage := Self.FStorage;
    FStorage.Open;
    try
      try
        LoadObjectsProps(Form, FStoredProperties);
      except
      end;
    finally
      FStorage.Close;
    end;
  finally
    Free;
  end;
end;

procedure TOvcComponentState.SaveStatePrim;
begin
  if not Assigned(FStorage) then
    Exit;

  with TOvcDataFiler.Create do
  try
    Section := Self.FSection;
    Storage := Self.FStorage;
    FStorage.Open;
    try
      StoreObjectsProps(TWinControl(Owner), FStoredProperties);
    finally
      FStorage.Close;
    end;
  finally
    Free;
  end;
end;

procedure TOvcComponentState.SetNotification;
var
  I         : Integer;
  Component : TComponent;
begin
  for I := FStoredProperties.Count - 1 downto 0 do begin
    if FStoredProperties.Objects[I] is TComponent then begin
      Component := TComponent(FStoredProperties.Objects[I]);
      if Component <> nil then
        Component.FreeNotification(Self)
    end;
  end;
end;

procedure TOvcComponentState.SetStoredProperties(Value : TStrings);
begin
  FStoredProperties.Assign(Value);
  SetNotification;
end;

procedure TOvcComponentState.WriteState(Writer : TWriter);
begin
  if (csAncestor in ComponentState) then
    Exit;

  UpdateStoredList(TWinControl(Owner), FStoredProperties, False);

  inherited WriteState(Writer);
end;


procedure TOvcComponentState.UpdateStoredProperties;
begin
  UpdateStoredList(TWinControl(Owner), FStoredProperties, True);
end;


{*** TOvcPersistentState ***}

procedure TOvcPersistentState.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if AComponent = FStorage then
      FStorage := nil;
end;

procedure TOvcPersistentState.RestoreState(AnObject : TPersistent;
          const ASection : string);
begin
  if not Assigned(FStorage) then
    Exit;

  with TOvcDataFiler.Create do
  try
    Section := ASection;
    Storage := Self.FStorage;
    try
      FStorage.Open;
      try
        LoadAllProperties(AnObject);
      finally
        FStorage.Close;
      end;
    except
    end;
  finally
    Free;
  end;
end;

procedure TOvcPersistentState.SaveState(AnObject : TPersistent;
          const ASection : string);
begin
  if not Assigned(FStorage) then
    Exit;

  with TOvcDataFiler.Create do
  try
    Section := ASection;
    Storage := Self.FStorage;
    FStorage.Open;
    try
      StoreAllProperties(AnObject);
    finally
      FStorage.Close;
    end;
  finally
    Free;
  end;
end;

procedure TOvcPersistentState.SetStorage(Value : TOvcAbstractStore);
begin
  FStorage := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;


end.





