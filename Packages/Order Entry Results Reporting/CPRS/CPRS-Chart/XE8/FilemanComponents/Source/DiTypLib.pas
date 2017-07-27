{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{                                                       }
{       Revision Date: 02/27/98                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}

unit DiTypLib;

interface

uses
  classes, dialogs, SysUtils, trpcb, xwbut1, dihlp, mfunstr, dierr;

type
  LockOperation = (UnLock, Lock);

  TFMErrorObj = class(TObject)  {Class holds single error info.}
  private
  protected
    FErrorText   : TStrings;
    FErrorNumber : String;
    FFMFile      : String;
    FFMField     : String;
    FIENS        : String;
    FParams      : TStrings;
  public
    property ErrorText: TStrings read FErrorText write FErrorText;
    property ErrorNumber: String read FErrorNumber write FErrorNumber;
    property FMFile: String read FFMFile write FFMFile;
    property FMField: String read FFMField write FFMField;
    property IENS: String read FIENS write FIENS;
    property Params: TStrings read FParams write FParams;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure DisplayError(HlpBtn: Boolean; HlpLst: TList); virtual; //d0
  end;

  TFMFieldObj = class(TObject)  {Class holds single field info.}
  private
  protected
    FIENS      : String;
    FFMField     : String;
    FFMDBExternal: String;
    FFMDBInternal: String;
    FFMWordProc    : Boolean;
    FFMWPTextLines : TStrings;
    procedure SetIENS(IENS: string); virtual;
  public
    property IENS: String read FIENS write SetIENS;
    property FMField: String read FFMField write FFMField;
    property FMDBExternal: String read FFMDBExternal write FFMDBExternal;
    property FMDBInternal: String read FFMDBInternal write FFMDBInternal;
    property FMWordProc: Boolean read FFMWordProc write FFMWordProc;
    property FMWPTextLines: TStrings read FFMWPTextLines write FFMWPTextLines;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TFMRecordObj = class(TObject)  {Class holds single record info.}
  private
  protected
    FIEN        : String;
    FFMIXExternalValues, FFMIXInternalValues : TStrings;
    FFMFLDValues : TStrings;
    FFMWIDValues : TSTrings;
    FObjects  : TObject;
  public
    property Objects: TObject read FObjects write FObjects;
    property IEN: String read FIEN write FIEN;
    property FMIXExternalValues: TStrings read FFMIXExternalValues write FFMIXExternalValues;
    property FMIXInternalValues: TStrings read FFMIXInternalValues write FFMIXInternalValues;
    property FMFLDValues: TStrings read FFMFLDValues write FFMFLDValues;
    property FMWIDValues: TSTrings read FFMWIDValues write FFMWIDValues;
    constructor Create; virtual;
    destructor Destroy; override;
    function GetField(fld: string): TFMFieldObj; virtual;
    function GetTObject: TObject; virtual;
  end;

  TFMHelpObj = class(TObject)  {Class holds single field help info.}
  private
  protected
    FHelpText   : TStrings;
    FFMFile      : String;
    FFMField     : String;
  public
    property HelpText: TStrings read FHelpText write FHelpText;
    property FMFile: String read FFMFile write FFMFile;
    property FMField: String read FFMField write FFMField;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure DisplayHelp; virtual;
  end;

  TFMFDAObj = class (TObject)  {Class holds single FDA node info}
  private
  protected
    FFMFieldNumber : string;
    FFMFileNumber  : string;
    FIENS    : string;
    FFMInternal   : string;
    procedure SetIENS(IENS: string); virtual;
  public
    property FMFileNumber: string read FFMFileNumber write FFMFileNumber;
    property FMFieldNumber: string read FFMFieldNumber write FFMFieldNumber;
    property IENS: string read FIENS write SetIENS;
    property FMInternal: string read FFMInternal write FFMInternal;
  end;

function FixIENS(IENS : string) : string;
function FixFMDate(FMDate: string) : string;
function DeleteRecord(RPCBroker: TRPCBroker; FMFile, IENS: String): Boolean;
function LockNode(RPCBroker: TRPCBroker; GlobalNode: String; LockMode: LockOperation; TimeOut: Integer): Boolean;
function UpArrowPiece(s: string): integer;

implementation

uses Diaccess;

{Appends , to IENS if it's not there.}
function FixIENS(IENS : string) : string;
begin
  if (IENS = '') or (copy(IENS, length(IENS), 1) = ',') then
    Result := IENS
  else
    Result := IENS + ',';
end;

{Strips non-canonic trailing 0s from FM date/time}
function FixFMDate(FMDate: string) : string;
begin
  if pos('.',FMDate)>0 then
  while copy(FMDate,length(FMDate),1) = '0' do
    FMDate := copy(FMDate,1,length(FMDate)-1);
  Result := FMDate;
end;

{Deletes record using ^DIK}
function DeleteRecord(RPCBroker: TRPCBroker; FMFile, IENS: String): Boolean;
begin
  result := False;
  try
    if RPCBroker = nil then raise ENoBrokerLink.Create('No Broker link associated with the Deleter Call');
    if (ParamOK(FMFile)) and (ParamOK(IENS)) then
      begin
        RPCBroker.RemoteProcedure := 'DDR DELETE ENTRY';
        with RPCBroker.Param[0] do begin
          PType := list;
          Mult['"FILE"'] := FMFile;
          Mult['"IENS"']  := IENS;
          Result := (RPCBroker.strCall = '1')
        end;
      end;
  except
    raise;
  end;
end;

{Locks global node}
function LockNode(RPCBroker: TRPCBroker; GlobalNode: String; LockMode: LockOperation; TimeOut: Integer): Boolean;
begin
  result := False;
  try
    if RPCBroker = nil then raise ENoBrokerLink.Create('No Broker link associated with the Lock Call');
    if (ParamOK(GlobalNode)) and (ParamOK(IntToStr(Ord(LockMode)))) and (ParamOK(IntToStr(TimeOut))) then
      begin
        RPCBroker.RemoteProcedure := 'DDR LOCK/UNLOCK NODE';
        with RPCBroker.Param[0] do begin
          PType := list;
          Mult['"NODE"'] := GlobalNode;
          Mult['"LOCKMODE"']  := IntToStr(Ord(LockMode));
          Mult['"TIMEOUT"'] := IntToStr(Timeout);
          Result := (RPCBroker.strCall = '1')
        end;
      end;
  except
    raise;
  end;
end;

function UpArrowPiece(s: string): integer; // returns the number of ^ pieces in s;
var
  x, cnt, len : integer;
  y : string;
begin
  cnt := 0;
  len := length(s);
  y := s;
  repeat
    x := pos(u, y);
    if x <> 0 then begin
      cnt := cnt + 1;
      y := copy(y, x+1, len);
      end;
  until
    x = 0;
  Result := cnt + 1;
end;

{***** TFMErrorObj Methods *****}
constructor TFMErrorObj.Create;
begin
  inherited Create;
  FErrorText := TStringList.Create;
  FParams    := TStringList.Create;
end;

destructor TFMErrorObj.Destroy;
begin
  FErrorText.Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TFMErrorObj.DisplayError(HlpBtn: Boolean; HlpLst: TList);
var
  frm : TFrmDisplayError;
begin
  frm := TFrmDisplayError.Create(nil);
  try
    frm.Caption := 'Error # ' + ErrorNumber + ' Report';
    frm.lblFile.Caption := FMFile;
    frm.lblField.Caption := FMField;
    frm.lblIENS.Caption := Iens;
    frm.memError.Lines := ErrorText;
    frm.btnHelp.visible := HlpBtn;
    frm.HlpList := HlpLst;
    frm.ShowModal;
  finally
    frm.free;
  end;
end;

{***** TFMHelpObj Methods *****}
constructor TFMHelpObj.Create;
begin
  inherited Create;
  FHelpText := TStringList.Create;
end;

destructor TFMHelpObj.Destroy;
begin
  FHelpText.Free;
  inherited Destroy;
end;

procedure TFMHelpObj.DisplayHelp;
var
  frm : TFrmDisplayHelp;
begin
  frm := TFrmDisplayHelp.Create(nil);
  try
    frm.Caption := 'Help Display';
    frm.memHelp.Lines := HelpText;
    frm.bbtnPrint.Visible := False;
    frm.ShowModal;
  finally
    frm.free;
  end;
end;

{***** TFMFieldObj *****}
constructor TFMFieldObj.Create;
begin
  inherited Create;
  FFMWPTextLines := TStringList.Create;
end;

destructor TFMFieldObj.Destroy;
begin
  FFMWPTextLines.Free;
  inherited Destroy;
end;

procedure TFMFieldObj.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

{***** TFMRecordObj *****}
constructor TFMRecordObj.Create;
begin
  inherited Create;
  FFMIXExternalValues := TStringList.Create;
  FFMIXInternalValues := TStringList.Create;
  FFMWIDValues := TStringList.Create;
  FFMFLDValues := TStringList.Create;
end;

destructor TFMRecordObj.Destroy;
begin
  FFMIXExternalValues.Free;
  FFMIXInternalValues.Free;
  FFMWIDValues.Free;
  FFMFLDValues.Free;
  inherited Destroy;
end;

function TFMRecordObj.GetField(fld: string): TFMFieldObj;
var
  ix : integer;
begin
  ix := FFMFLDValues.indexof(fld);
  if ix <> -1 then Result:= TFMFieldObj(FFMFLDValues.objects[ix])
  else Result := nil;
end;

function TFMRecordObj.GetTObject: TObject;
begin
  Result := nil;
  if Assigned(FObjects) then Result := FObjects;
end;

{***** TFMFDAObj *****}
procedure TFMFDAObj.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

end.
