{*********************************************************}
{*                    O32VLOP1.PAS 4.06                  *}
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

unit o32vlop1;
  {-ValidatorOptions class for use in components and classes which contain
    their own validator objects, like the ValidatorPool, FlexEdit, Etc...}

interface


uses
  Windows, Controls, Classes, Forms, Messages, SysUtils,
  O32Vldtr, OvcData, OvcExcpt, OvcConst;

type
  TValidationType = (vtNone, vtUser, vtValidator);

  TProtectedControl = class(TWinControl);

  TValidatorOptions = class(TPersistent)
  protected {private}
    FOwner          : TWinControl;
    FHookedControl  : TWinControl;
    FValidationType : TValidationType;
    FValidatorType  : String;
    FValidatorClass : TValidatorClass;
    FSoftValidation : Boolean;
    FMask           : String;
    FLastValid      : Boolean;
    FLastErrorCode  : Word;
    FBeepOnError    : Boolean;
    FInputRequired  : Boolean;
    FEnableHooking  : Boolean;
    FUpdating       : Integer;

    {Event for which this object will execute a validation}
    FEvent          : TValidationEvent;

    {WndProc Pointers}
    NewWndProc      : Pointer;
    PrevWndProc     : Pointer;

    procedure HookControl;
    procedure UnHookControl;
    procedure voWndProc(var Msg : TMessage);

    procedure RecreateHookedWnd;
    function Validate: Boolean;

    procedure AssignValidator;
    procedure SetValidatorType(const VType: String);
    procedure SetEvent(Event: TValidationEvent);
    procedure SetEnableHooking(Value: Boolean);

    property InputRequired: Boolean read FInputRequired write FInputRequired;

  public
    constructor Create(AOwner: TWinControl); dynamic;
    destructor Destroy; override;

    procedure AttachTo(Value : TWinControl);
    procedure SetLastErrorCode(Code: Word);
    procedure SetLastValid(Valid: Boolean);

    procedure BeginUpdate;
    procedure EndUpdate;

    property LastValid: Boolean read FLastValid;
    property LastErrorCode: Word read FLastErrorCode;
    property EnableHooking: Boolean read FEnableHooking write SetEnableHooking;
    property ValidatorClass: TValidatorClass read FValidatorClass
      write FValidatorClass;
  published
    property BeepOnError: Boolean read FBeepOnError write FBeepOnError;


    property SoftValidation: Boolean read FSoftValidation write FSoftValidation;

    property ValidationEvent: TValidationEvent read FEvent write SetEvent
      stored true;
    property ValidatorType : string
      read FValidatorType write SetValidatorType stored true;
    property ValidationType: TValidationType
      read FValidationType write FValidationType stored true;
    property Mask: String read FMask write FMask stored true;
  end;

implementation

{===== TValidatorOptions =============================================}
constructor TValidatorOptions.Create(AOwner: TWinControl);
begin
  inherited Create;

  FOwner := AOwner;

  {create a callable window proc pointer}
    NewWndProc := Classes.MakeObjectInstance(voWndProc);

  ValidatorType := 'None';
  FSoftValidation := false;
  ValidationType := vtNone;
  ValidationEvent := veOnExit;
  FInputRequired := false;
  FEnableHooking := true;
  BeepOnError := true;
  FValidatorClass := nil;
  FMask := '';
  FLastValid := false;
  FLastErrorCode := 0;
end;
{=====}

destructor TValidatorOptions.Destroy;
begin
  UnhookControl;
  FValidatorClass := nil;
  inherited destroy;
end;
{=====}

procedure TValidatorOptions.HookControl;
var
  P : Pointer;
begin
  if not FEnableHooking then exit;
  {hook into owner's window procedure}
  if (FHookedControl <> nil) then begin
    if not FHookedControl.HandleAllocated then FHookedControl.HandleNeeded;
    {save original window procedure if not already saved}
    P := Pointer(GetWindowLong(FHookedControl.Handle, GWL_WNDPROC));
    if (P <> NewWndProc) then begin
      PrevWndProc := P;
      {redirect message handling to ours}
      SetWindowLong(FHookedControl.Handle, GWL_WNDPROC, NativeInt(NewWndProc));
    end;
  end;
end;
{=====}

procedure TValidatorOptions.UnHookControl;
begin
  if (FHookedControl <> nil) then begin
    if Assigned(PrevWndProc) and FHookedControl.HandleAllocated then
      SetWindowLong(FHookedControl.Handle, GWL_WNDPROC, NativeInt(PrevWndProc));
  end;
  PrevWndProc := nil;
end;
{=====}

procedure TValidatorOptions.AttachTo(Value : TWinControl);
var
  WC : TWinControl;
begin
  if not FEnableHooking then Exit;

  FHookedControl := Value;

  {unhook from attached control's window procedure}
  UnHookControl;

  {insure that we are the only one to hook to this control}
  if not (csLoading in FOwner.ComponentState) and Assigned(Value) then begin
    {send message asking if this control is attached to anything}
    {the control itself won't be able to respond unless it is attached}
    {in which case, it will be our hook into the window procedure that}
    {is actually responding}

    if not Value.HandleAllocated then
      Value.HandleNeeded;

    if Value.HandleAllocated then begin
      WC := TWinControl(SendMessage(Value.Handle, OM_ISATTACHED, 0, 0));
      if Assigned(WC) then
        raise EOvcException.CreateFmt(GetOrphStr(SCControlAttached),
          [WC.Name])
      else
        HookControl;
    end;
  end;
end;
{=====}

procedure TValidatorOptions.SetEvent(Event: TValidationEvent);
begin
  if Event <> FEvent then
    FEvent := Event;
end;
{=====}

procedure TValidatorOptions.SetEnableHooking(Value: Boolean);
begin
  if FEnableHooking <> Value then begin
    FEnableHooking := Value;
    if FEnableHooking and (FHookedControl <> nil) then
      AttachTo(FHookedControl);
  end else
    UnHookControl;
end;
{=====}

procedure TValidatorOptions.RecreateHookedWnd;
begin
  if not (csDestroying in FHookedControl.ComponentState) then
    PostMessage(FHookedControl.Handle, OM_RECREATEWND, 0, 0);
end;
{=====}

procedure TValidatorOptions.voWndProc(var Msg : TMessage);
begin
  with Msg do begin
    case FEvent of
      veOnEnter        : if Msg =  CM_ENTER   then
        Validate;

      veOnExit         : if Msg = CM_EXIT    then
        if (not Validate) and (not FSoftValidation) then begin
          FHookedControl.SetFocus;
          {Fix for problem 882550.
           If the validation fails, we should not pass the message on since
           this will cause focus change messages to be generated, which is
           wrong, since we don't allow a focus change.}
          exit;
        end;

      {TextChanged}
      veOnChange       : if Msg = 48435 then
        Validate;

    end;

    {Pass the message on...}
    if PrevWndProc <> nil then
      Result := CallWindowProc(PrevWndProc, FHookedControl.Handle, Msg,
        WParam, LParam)
    else
      Result := CallWindowProc(TProtectedControl(FHookedControl).DefWndProc,
        FHookedControl.Handle, Msg, wParam, lParam);
  end;
end;
{=====}

procedure TValidatorOptions.AssignValidator;
begin
  if (FValidatorType = 'None') or (FValidatorType = '')then
    FValidatorClass := nil
  else try
    FValidatorClass := TValidatorClass(FindClass(FValidatorType));
  except
    FValidatorClass := nil;
  end;
end;
{=====}

procedure TValidatorOptions.SetLastErrorCode(Code: Word);
begin
  FLastErrorCode := Code;
end;
{=====}

function TValidatorOptions.Validate: Boolean;
begin
  {Don't validate if we're in the middle of updates.}
  if FUpdating > 0 then begin
    result := true;
    exit;
  end;

  {Send a Validate message to the Owner}
  SetLastErrorCode(SendMessage(FOwner.Handle, OM_VALIDATE, 0, 0));
  SetLastValid(FLastErrorCode = 0);
  result := FLastValid;
end;

procedure TValidatorOptions.SetLastValid(Valid: Boolean);
begin
  FLastValid := Valid;
end;
{=====}

procedure TValidatorOptions.BeginUpdate;
begin
  Inc(FUpdating);
end;
{=====}

procedure TValidatorOptions.EndUpdate;
begin
  Dec(FUpdating);
  if FUpdating < 0 then
    FUpdating := 0;
end;
{=====}

procedure TValidatorOptions.SetValidatorType(const VType: String);
begin
  if FValidatorType <> VType then begin
    FValidatorType := VType;
    AssignValidator;
  end;
end;


end.
