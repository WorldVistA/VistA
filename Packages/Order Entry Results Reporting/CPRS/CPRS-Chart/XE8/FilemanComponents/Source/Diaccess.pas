{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{                                                       }
{       Revision Date: 11/25/97                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}

unit Diaccess;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  {FileMan Units}
  Dityplib,
  {Broker Units}
  mfunstr, trpcb, xwbut1;

const
  BEGINDATA   = '[BEGIN_diDATA]';
  ENDDATA     = '[END_diDATA]';
  BEGINERRORS = '[BEGIN_diERRORS]';
  ENDERRORS   = '[END_diERRORS]';
  BEGINHELP   = '[BEGIN_diHELP]';
  ENDHELP     = '[END_diHELP]';
  fi = ' File Number';
  fl = ' Field Number';
  ie = ' Record Number (IENS)';
  va = ' Value';

type
  ENoBrokerLink = class(Exception);
  EMissingProp = class(Exception);
  ENullParam = class(Exception);

  TFMAccess = class(TComponent)
  private
  protected
    // Variables and procedures moved from private -----------------------------
    FErrorList    : TList;
    FHelpList     : TList;
    FHelpBtn      : Boolean;
    FRPCBroker : TRPCBroker;
    procedure LoadErrors(RPCBroker: TRPCBroker; var item: integer); virtual;
    procedure AddError(AError : TFMErrorObj); virtual;
    procedure LoadHelp(RPCBroker: TRPCBroker; var item: integer); virtual;
    procedure AddHelp(AHelp : TFMHelpObj); virtual;
    procedure ClearHelp; virtual;
    // End of variables and procedures moved from private ------------------------
  public
    property ErrorList : TList read FErrorList write FErrorList;
    property HelpList : TList read FHelpList write FHelpList;    //d0
    property HelpBtn : Boolean read FHelpBtn write FHelpBtn default False;  //d0
    constructor Create(AOwner :TComponent); override;
    destructor  Destroy; override;
    procedure DisplayErrors; virtual;
    procedure ClearErrors; virtual;
    procedure ParseHelpErrors(RPCBroker: TRPCBroker); virtual;    //d0
    function LoadOneHelp(source: TStrings; var item :integer; x: string): TFMHelpObj; virtual; //d0
  published
    property RPCBroker : TRPCBroker read FRPCBRoker write FRPCBroker;
  end;

function BrokerOK(Sender: TObject): Boolean;
function PropertyOK(Sender: TObject): Boolean;
function null(val: String): Boolean;
function ParamOK(Param: String): Boolean;

implementation

uses Fmcmpnts;

function BrokerOK(Sender: TObject) : Boolean;
var
  RPCBroker: TRPCBroker;
begin
  RPCBroker := TFMAccess(Sender).RPCBroker;
  if RPCBroker <> nil then
    begin
      RPCBroker.ClearResults := True;
      RPCBroker.ClearParameters := True;
      RPCBroker.RPCVersion := '1';
      Result := True;
    end
  else
    raise ENoBrokerLink.Create('"'+TComponent(Sender).Name +
                                    '" is not associated with a Broker link.'
                                    +#13#10+
                                    'Please contact developer for assistance');
end;

procedure TFMGetsCheck(var obj: TFMGets; var msg: string); forward;
procedure TFMValidatorCheck(var obj: TFMValidator; var msg: string); forward;
procedure TFMListerCheck(var obj: TFMLister; var msg: string); forward;
procedure TFMFindOneCheck(var obj: TFMFindOne; var msg: string); forward;
procedure TFMHelpCheck(var obj: TFMHelp; var msg: string); forward;
procedure TFMFinderCheck(var obj: TFMFinder; var msg: string); forward;

function PropertyOK(Sender: TObject): Boolean;
var
  msg: string;
begin
  msg := '';
  if Sender is TFMValidator then TFMValidatorCheck(TFMValidator(Sender), msg)
  else if Sender is TFMLister then TFMListerCheck(TFMLister(Sender), msg)
  else if Sender is TFMGets then TFMGetsCheck(TFMGets(Sender), msg)
  else if Sender is TFMFindOne then TFMFindOneCheck(TFMFindOne(Sender), msg)
  else if Sender is TFMHelp then TFMHelpCheck(TFMHelp(Sender), msg)
  else if Sender is TFMFinder then TFMFinderCheck(TFMFinder(Sender), msg);
  if msg <> '' then raise EMissingProp.Create(TComponent(Sender).Name +
                         msg + ' is not initialized');
  Result := True;
end;

function null(val: String): Boolean;
begin
  Result := False;
  if val = '' then Result := True;
end;

function ParamOK(Param: String): Boolean;
begin
  if null(Param) then raise ENullParam.Create('"Required Parameter" is null')
  else
    Result := True;
end;

procedure TFMGetsCheck(var obj: TFMGets; var msg: string);
begin
  if null(TFMGets(obj).FileNumber) then msg := fi;
  if null(TFMGets(obj).IENS) then msg := ie;
end;

procedure TFMValidatorCheck(var obj: TFMValidator; var msg: string);
begin
  if null(TFMValidator(obj).FileNumber) then msg := fi;
  if null(TFMValidator(obj).FieldNumber) then msg := fl;
  if null(TFMValidator(obj).IENS) then msg := ie;
end;

procedure TFMListerCheck(var obj: TFMLister; var msg: string);
begin
  if null(TFMLister(obj).FileNumber) then msg := fi;
end;

procedure TFMFindOneCheck(var obj: TFMFindOne; var msg: string);
begin
  if null(TFMFindOne(obj).FileNumber) then msg := fi;
  if null(TFMFindOne(obj).Value) then msg := va;
end;

procedure TFMHelpCheck(var obj: TFMHelp; var msg: string);
begin
  if null(TFMHelp(obj).FileNumber) then msg := fi;
  if null(TFMHelp(obj).FieldNumber) then msg := fi;
end;

procedure TFMFinderCheck(var obj: TFMFinder; var msg: string);
begin
  if null(TFMFinder(obj).FileNumber) then msg := fi;
  if null(TFMFinder(obj).Value) then msg := va;
end;

{**********TFMAccess methods**********}
constructor TFMAccess.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FErrorList := TList.Create;
  FHelpList := TList.Create;
end;

destructor TFMAccess.Destroy;
begin
  FErrorList.Free;
  FHelpList.Free;
  inherited Destroy;
end;

{Adds an error object to the FErrorList}
procedure TFMAccess.AddError(AError : TFMErrorObj);
begin
  FErrorList.Add(AError);
end;

{Displays all error on the component's error list.}
procedure TFMAccess.DisplayErrors;
var
  i : integer;
begin
  if FErrorList.Count = 0 then Exit;
  for i := 0 to FErrorList.Count-1 do
{$WARN UNSAFE_CAST OFF}
    TFMErrorObj(FErrorList.Items[i]).DisplayError(HelpBtn, FHelpList);
{$WARN UNSAFE_CAST ON}
end;

{frees TFMErrorObj objects attached to FErrorList}
procedure TFMAccess.ClearErrors;
var
  i : integer;
begin
{$WARN UNSAFE_CAST OFF}
  for i := 0 to FErrorList.Count - 1 do TFMErrorObj(FErrorList.Items[i]).Free;
{$WARN UNSAFE_CAST ON}
  FErrorList.Clear;
  ClearHelp;
end;

procedure TFMAccess.ParseHelpErrors(RPCBroker: TRPCBroker);
var
  i : integer;
begin
  i := RPCBroker.Results.Indexof(BEGINHELP);
  if i > -1 then LoadHelp(RPCBroker, i);
  i := RPCBroker.Results.IndexOf(BEGINERRORS);
  if i > -1 then LoadErrors(RPCBroker, i);
end;

{process all errors}
procedure TFMAccess.LoadErrors(RPCBroker: TRPCBroker; var item: integer);
var
  Error : TFMErrorObj;
  x, w : string;
  y, z, txtlines, paramcnt : integer;
begin
  while (x <> ENDERRORS) and (item <> RPCBroker.Results.Count -1) do begin
    inc(item);
    x := RPCBroker.Results[item];
    if x = ENDERRORS then break;
    {process one error}
    Error := TFMErrorObj.Create;
    y := 0;
    z := 0;
    txtlines := 0;
    paramcnt := 0;
    with Error do begin
      ErrorNumber := Piece(x, U, 1);
      FMFile      := Piece(x, U, 3);
      IENS        := Piece (x, U, 4);
      FMField     := Piece (x, U, 5);
      end;
    w := Piece(x, U, 2);
    if w <> '' then txtlines := StrToInt(w);
    w := Piece(x, U, 6);
    if w <> '' then paramcnt := StrToInt(w);
    if paramcnt > 0 then
      repeat
        inc(item);
        x := RPCBroker.Results[item];
        Error.Params.Add(x);
        inc(y);
      until y = paramcnt;
    if txtlines > 0 then
      repeat
        inc(item);
        x := RPCBroker.Results[item];
        Error.ErrorText.Add(x);
        inc(z);
      until z = txtlines;
    Adderror(Error);
  end;
end;

procedure TFMAccess.LoadHelp(RPCBroker: TRPCBroker; var item: integer);
var
  Help: TFMHelpObj;
  x : string;
begin
  while (x <> ENDHELP) and (item <> RPCBroker.Results.Count -1) do begin
    inc(item);
    x := RPCBroker.Results[item];
    if x = ENDHELP then break;
    {process one help object}
    Help := LoadOneHelp(RPCBroker.Results, item, x);
    AddHelp(Help);
  end;
  HelpBtn := (FHelpList.Count > -1);
end;

function TFMAccess.LoadOneHelp(source: TStrings; var item :integer; x: string): TFMHelpObj;
var
  Help : TFMHelpObj;
  w : string;
  z, txtlines : integer;
begin
  Help := TFMHelpObj.Create;
  z := 0;
  txtlines := 0;
  with Help do begin
    FMFile      := Piece(x, U, 1);
    FMField     := Piece (x, U, 2);
    end;
  w := Piece(x, U, 4);
  if w <> '' then txtlines := StrToInt(w);
  if txtlines > 0 then
    repeat
      inc(item);
      x := source[item];
      Help.HelpText.Add(x);
      inc(z);
    until z = txtlines;
  Result := Help;
end;

{Adds a Help object to the FHelpList}
procedure TFMAccess.AddHelp(AHelp : TFMHelpObj);
begin
  FHelpList.Add(AHelp);
end;

{frees TFMHelpObj objects attached to FHelpList}
procedure TFMAccess.ClearHelp;
var
  i : integer;
begin
{$WARN UNSAFE_CAST OFF}
  for i := 0 to FHelpList.Count - 1 do TFMHelpObj(FHelpList.Items[i]).Free;
{$WARN UNSAFE_CAST ON}
  FHelpList.Clear;
end;

{**********End TFMAccess**********}


end.
