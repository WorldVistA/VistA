unit ORRedirect;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, System.RTTI, Vcl.Controls,
  Vcl.Forms;

const
  ASMCNT = 4;

type
  TASMData = array [0 .. ASMCNT] of byte;

  TRedirectToken = record
    Addr: ^TASMData;
    OldData, NewData: TASMData;
    OldMethod: TMethod;
  end;

function BeginAPIRedirect(FromAPI, ToAPI: Pointer): TRedirectToken;
procedure EndAPIRedirect(Token: TRedirectToken);

type
  TORRedirect = class
  private
    class var FInitialized: Boolean;
    class var FWinControlSetFocusToken: TRedirectToken;
    class var FFormSetFocusToken: TRedirectToken;
    class var FFormSetActiveControlToken: TRedirectToken;
    class var FParentRequiredText: string;
    class function AllowException(E: Exception): boolean;
    class procedure NewWinControlSetFocus(Self: TObject); static;
    class procedure NewFormSetFocus(Self: TObject); static;
    class procedure NewFormSetActiveControl(Self: TObject;
      Control: TWinControl); static;
  public
    class procedure Init;
  end;

implementation

uses
  Vcl.Consts;

function BeginAPIRedirect(FromAPI, ToAPI: Pointer): TRedirectToken;
type
  TPtrRec = record
    case integer of
      1:
        (lw: Pointer);
      2:
        (b1, b2, b3, b4: byte);
  end;

var
  rec: TPtrRec;
  dwNull: DWORD;

begin
  VirtualProtect(FromAPI, ASMCNT + 1, PAGE_EXECUTE_READWRITE, dwNull);
  with Result do
  begin
    Addr := FromAPI;
    OldMethod.Code := FromAPI;
    OldData := Addr^;
    rec.lw := Pointer(integer(ToAPI) - integer(FromAPI) - 5);
    NewData[0] := $E9;
    NewData[1] := rec.b1;
    NewData[2] := rec.b2;
    NewData[3] := rec.b3;
    NewData[4] := rec.b4;
    Addr^ := NewData;
  end;
end;

procedure EndAPIRedirect(Token: TRedirectToken);
begin
  Token.Addr^ := Token.OldData;
end;

  { TORRedirect }

type
  TSetFocusMethod = procedure of object;
  TSetActiveControlMethod = procedure(Control: TWinControl) of object;

class procedure TORRedirect.NewWinControlSetFocus(Self: TObject);
begin
  with FWinControlSetFocusToken do
  begin
    Addr^ := OldData;
    try
      try
        try
          OldMethod.Data := Self;
          TSetFocusMethod(OldMethod);
        except
          // This inner Try..Except is only here for v32 of CPRS.
          // It should be removed for v33
        end;
      except
        on E: Exception do
          if AllowException(E) then
            raise;
      end;
    finally
      Addr^ := NewData;
    end;
  end;
end;

class procedure TORRedirect.NewFormSetFocus(Self: TObject);
begin
  with FFormSetFocusToken do
  begin
    Addr^ := OldData;
    try
      try
        try
          OldMethod.Data := Self;
          TSetFocusMethod(OldMethod);
        except
          // This inner Try..Except is only here for v32 of CPRS.
          // It should be removed for v33
        end;
      except
        on E: Exception do
          if AllowException(E) then
            raise;
      end;
    finally
      Addr^ := NewData;
    end;
  end;
end;

class procedure TORRedirect.NewFormSetActiveControl(Self: TObject;
  Control: TWinControl);
begin
  with FFormSetActiveControlToken do
  begin
    Addr^ := OldData;
    try
      try
        try
          OldMethod.Data := Self;
          TSetActiveControlMethod(OldMethod)(Control);
        except
          // This inner Try..Except is only here for v32 of CPRS.
          // It should be removed for v33
        end;
      except
        on E: Exception do
          if AllowException(E) then
            raise;
      end;
    finally
      Addr^ := NewData;
    end;
  end;
end;

class function TORRedirect.AllowException(E: Exception): boolean;
begin
  Result := True;
  if (E is EInvalidOperation) then
  begin
    if pos(SCannotFocus, E.Message) > 0 then
      Result := False
    else if pos(FParentRequiredText, E.Message) > 0 then
      Result := False;
  end;
end;

class procedure TORRedirect.Init;
var
  SetActiveControlAddr: Pointer;

  function FindSetActiveControlAddr: Pointer;
  var
    ctx: TRTTIContext;
    typ: TRttiType;
    prop: TRttiProperty;

  begin
    Result := nil;
    typ := ctx.GetType(TCustomForm);
    if assigned(typ) then
    begin
      prop := typ.GetProperty('ActiveControl');
      if assigned(prop) and (prop is TRttiInstanceProperty) then
        Result := TRttiInstanceProperty(prop).PropInfo^.SetProc;
    end;
  end;

begin
  if not FInitialized then
  begin
    SetActiveControlAddr := FindSetActiveControlAddr;
    if SetActiveControlAddr <> nil then
    begin
      FParentRequiredText := copy(SParentRequired, SParentRequired.Length - 19, 20);
      FWinControlSetFocusToken := BeginAPIRedirect(@TWinControl.SetFocus,
        @NewWinControlSetFocus);
      FFormSetFocusToken := BeginAPIRedirect(@TCustomForm.SetFocus,
        @NewFormSetFocus);
      FFormSetActiveControlToken := BeginAPIRedirect(SetActiveControlAddr,
        @NewFormSetActiveControl);
    end;
    FInitialized := True;
  end;
end;

end.
