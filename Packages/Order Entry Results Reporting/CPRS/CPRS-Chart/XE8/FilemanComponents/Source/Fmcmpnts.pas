{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{          (originally developed at Albany CIOFO)       }
{                                                       }
{       Revision Date: 03/17/99                         }
{                                                       }
{       Distribution Date:  2/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}
unit Fmcmpnts;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,Forms,
  Dialogs, StdCtrls, ExtCtrls,
  xwbut1, trpcb, mfunstr, {RPCBroker units}
  DiTypLib, DiAccess, Didataprob; {FMComponent units}

const
  U = '^';

type
  TFMStr50      = string;
//  TFMStr50      = string[50];
  TFMStr250     = string;
//  TFMStr250     = string[250];
  TFilerStatus  = (Edited, Not_Edited);   //d0
  TFMFile       = string;
//  TFMFile       = string[100];
  TListerFlag   = (lfBackwards, lfInternal);
  TListerFlags  = set of TListerFlag;
  TListerOption = (loPackedResults,loReturnWriteIDs, loReturnIXValues, loQuickList);
  TListerOptions = set of TListerOption;
  TGetsFlag   = (gfExternal, gfInternal);
  TGetsFlags  = set of TGetsFlag;
  TGetsOption = (goDDHelp);
  TGetsOptions = set of TGetsOption;
  TFilerFlag  = (ffLock);
  TFilerFlags = set of TFilerFlag;
  TFilerOption = (foNotEditable,foProcessProblemList);
  TFilerOptions = set of TFilerOption;
  TFinderFlag = (fnfAllowNumeric,fnfMultipleIndex,fnfOnlyExact,fnfQuickLookup,fnfXactMatch);
  TFinderFlags = set of TFinderFlag;
  TFinderOption = (foReturnWriteIDs);
  TFinderOptions = set of TFinderOption;
  TFindOneOption = (foRecall);
  TFindOneOptions = set of TFindOneOption;

  {***** TFMLister *****}

  TFMLister = class(TFMAccess)
  private
  protected
    FFile,FIENS,FFlags,FNumber,FIndex,FScreen,FIdentifier: string;
    FDelimiter: char;
    FFromIEN,FPFromIEN,FOptions, FFLD {,FDDFile,FDDField}: string;
    FMore: boolean;
    FResults,FDisplayFields,FFieldNumbers: TStrings;
    FListerFlags : TListerFlags;
    FFromList:  TStrings;
    FPFromList: TStrings;
    FPartList:  TStrings;
    FListerOptions: TListerOptions;
    FFLDCnt,FIXcnt: Integer;
    procedure SetFieldNumbers(FieldNumbers: TStrings); virtual;
    procedure SetDisplayFields(DisplayFields: TStrings); virtual;
    procedure SetPartList(Values: TStrings); virtual;
    procedure ParseResults(source, target: TStrings); virtual;
    procedure SetIENS(IENS: string); virtual;
    procedure GoGetList(target: TStrings); virtual;
    function  SetBrokerInfo: Boolean; virtual;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure LoadUnpackedResults(Source, Target: TStrings); virtual;
    function  DisplayData(s: TFMRecordObj): string; virtual;
    procedure LoadIXVals(s: String; var RecObj: TFMRecordObj); virtual;
    procedure LoadFLDVals(s: String; var RecObj: TFMRecordObj); virtual;
    procedure LoadWIDVals(s: String; var RecObj: TFMRecordObj; zz: integer); virtual;
    procedure LoadIXVal(s: TStrings; var R: TFMRecordObj; c: integer); virtual;
    procedure LoadFLDVal(s: TStrings; var R: TFMRecordObj; c: integer); virtual; //same as LoadFLDVals
    procedure LoadWIDVal(s: TStrings); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property More: Boolean read FMore write FMore default False;
    property Results: TStrings read FResults;
    property FromIEN: string read FFromIEN write FFromIEN;
    property FromList: TStrings read FFromList write FFromList;
    procedure GetList(target: TStrings); virtual;
    procedure GetMore(target: TStrings); virtual;
    procedure CopyTo(ALister :TFMLister); virtual;      //d0
    function GetRecord(IEN: String): TFMRecordObj; virtual;
  published
    property FieldNumbers: TStrings read FFieldNumbers write SetFieldNumbers;
    property DisplayFields: TStrings read FDisplayFields write SetDisplayFields;
    {property DDFile: string read FDDFile write FDDFile;
    property DDField: string read FDDField write FDDField;}
    property IENS: string read FIENS write SetIENS;
    property ListerFlags : TListerFlags read FListerFlags write FListerFlags;
    property Delimiter: char read FDelimiter write FDelimiter;
    property Number: string read FNumber write FNumber;
    property PartList: TStrings read FPartList write SetPartList;
    property Screen: string read FScreen write FScreen;
    property FMIndex: string read FIndex write FIndex;
    property Identifier: string read FIdentifier write FIdentifier;
    property FileNumber: string read FFile write FFile;
    property ListerOptions: TListerOptions read FListerOptions write FListerOptions;
  end;

  {***** TFMGets *****}

  TFMGets = class(TFMAccess)
  private
  protected
    FFile,FIENS,FFlags,FOptions: string;
    FResults,FFields: TStrings;
    FFMObjects: TList;
    FGetsFlags : TGetsFlags;
    FGetsOptions : TGetsOptions;
    procedure ParseResults(source: TStrings); virtual;
    procedure SetFields(Fields: TStrings); virtual;
    procedure SetIENS(IENS: string); virtual;
    procedure SetCtrlData(Entry, Intern, Extern: String); virtual;
    function  SetBrokerInfo: Boolean; virtual;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure FillHelp(source: TStrings); virtual;
    procedure FldObjLoad(Source: TStrings); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure  GetData; virtual;
    procedure  FillData; virtual;
    procedure  GetAndFill; virtual;
    procedure  ClearCtrlData; virtual;
    procedure  SetUpNewEntry(PlaceHolder: String); virtual;
    procedure  StuffIENS(Entry: String); virtual;
    procedure  AddCtrl(Sender: TObject; FMField: String); virtual; //d0
    procedure  AddField(FMField: String); virtual;
    procedure  RemoveCtrl(Sender: TObject; FMField: String); virtual; //d0
    procedure  RemoveField(FMField: String); virtual;
    property   Results: TStrings read FResults;
    function   GetField(FMField: string): TFMFieldObj; virtual;
  published
    property FieldNumbers: TStrings read FFields write SetFields;
    property FileNumber: string read FFile write FFile;
    property IENS: string read FIENS write SetIENS;
    property GetsFlags: TGetsFlags read FGetsFlags write FGetsFlags;
    property GetsOptions: TGetsOptions read FGetsOptions write FGetsOptions;
  end;

  {***** TFMValidator *****}

  TFMValidator = class(TFMAccess)
  private
  protected
    FFile     : String;
    FIENS     : String;
    FField    : String;
    FValue    : String;
    FResults   : TStrings;
    procedure SetIENS(IENS: string); virtual;
    procedure ParseResults(source: TStrings); virtual;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Validate: Boolean; virtual;
    procedure Clear; virtual;
    property Results: TStrings read FResults;
    procedure SetUp(FileNumber,IENS,FieldNumber,Value: String); virtual;
  published
    property FileNumber: String read FFile write FFile;
    property IENS: String read FIENS write SetIENS;
    property FieldNumber: String read FField write FField;
    property Value: String read FValue write FValue;
  end;

  {***** TFMFiler *****}

  TFMFiler = class(TFMAccess)
  private
  protected
    FStatus           : TFilerStatus;
    FNewIENs          : TStrings;
    FPlaceHolder      : TStrings;
    FFMCtrlsList      : TList;
    FChangedCtrlsList : TList;
    FFDAList          : array of TFMFDAObj;
    FFilerFlags       : TFilerFlags;
    FFlags, FMode     : string;
    FDataProblemList  : TStrings;
    FFilerOptions     : TFilerOptions;
    FFilerProbListForm : TfrmDataProblemList;
    FIENsList           : TStrings;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetMode(IENS: String); virtual;
    procedure AddDataProblem(fld: TComponent); virtual;
  protected
    //function Validate: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure AddFDA(FileNumber, IENS, FieldNumber, Value: String); virtual;
    procedure AddChgdControl(Sender: TObject); virtual;
    procedure RemoveChgdControl(Sender: TObject); virtual;
    procedure RemoveCtrl(Sender: TObject); virtual; //d0
    procedure AddCtrl(Sender: TObject); virtual; //d0
    function  DataProblemCheck: Boolean; virtual;
    function  Update: Boolean; virtual;
    function  FindIen(PlaceHolder: String): String; virtual;
    function  AnythingToFile : Boolean; virtual;
    procedure ProcessDataProblemList; virtual;
    property  NewIENs: TStrings read FNewIENs;
    property DataProblemList: TStrings read FDataProblemList;
    procedure AddIEN(PlaceHolder, IEN: String); virtual;
  published
    property FilerFlags: TFilerFlags read FFilerFlags write FFilerFlags;
    property FilerOptions: TFilerOptions read FFilerOptions write FFilerOptions;
  end;

  {***** TFMHelp *****}

  TFMHelp = class(TFMAccess)
  private
  protected
    FFileNumber,FFieldNumber,FHelpFlags: string;
    FDisplayPanel: TPanel;
    FHelpObj: TFMHelpObj;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    function SetBrokerInfo: Boolean; virtual;
  public
    property HelpObj: TFMHelpObj read FHelpObj write FHelpObj;
    procedure GetAndDisplayHelp; virtual;
    function GetHelp: TFMHelpObj; virtual;
    procedure DisplayHelp; virtual;
    procedure DisplyHlp(FHelp: TFMHelpObj); virtual;   //d0
  published
    property FileNumber: string read FFileNumber write FFileNumber;
    property FieldNumber: string read FFieldNumber write FFieldNumber;
    property DisplayPanel: TPanel read FDisplayPanel write FDisplayPanel;
    property HelpFlags: string read FHelpFlags write FHelpFlags;
  end;

  {***** TFMFinder *****}

  TFMFinder = class(TFMAccess)
  private
  protected
    FFileNumber,FIENS,FFlags,FNumber,FFMIndex,FScreen,FIdentifier: string;
    FOptions,FFLD,FValue : string;
    FMore: boolean;
    FResults,FDisplayFields,FFieldNumbers: TStrings;
    FFLDCnt: Integer;
    FFinderFlags : TFinderFlags;
    FFinderOptions: TFinderOptions;
    procedure SetFieldNumbers(FieldNumbers: TStrings); virtual;
    procedure SetDisplayFields(DisplayFields: TStrings); virtual;
    procedure SetIENS(IENS: string); virtual;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure GoGetList(target: TStrings); virtual;
    procedure ParseResults(source, target: TStrings); virtual;
    function  SetBrokerInfo: Boolean; virtual;
    function  DisplayData(s: TFMRecordObj): string; virtual;
    procedure LoadFLDVal(s: TStrings; var R: TFMRecordObj; c: integer); virtual;
    procedure LoadWIDVal(s: TStrings); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property More: Boolean read FMore write FMore default False;
    property Results: TStrings read FResults;
    procedure GetFinderList(target: TStrings); virtual;
    function GetRecord(IEN: String): TFMRecordObj; virtual;
  published
    property FieldNumbers: TStrings read FFieldNumbers write SetFieldNumbers;
    property DisplayFields: TStrings read FDisplayFields write SetDisplayFields;
    property IENS: string read FIENS write SetIENS;
    property FinderFlags : TFinderFlags read FFinderFlags write FFinderFlags;
    property Number: string read FNumber write FNumber;
    property Screen: string read FScreen write FScreen;
    property FMIndex: string read FFMIndex write FFMIndex;
    property Identifier: string read FIdentifier write FIdentifier;
    property FileNumber: string read FFileNumber write FFileNumber;
    property Value: string read FValue write FValue;
    property FinderOptions: TFinderOptions read FFinderOptions write FFinderOptions;
  end;

  {***** TFMFindOne *****}

  TFMFindOne = class(TFMAccess)
  private
  protected
    FFileNumber,FIENS,FFlags,FValue,FFMIndex,FScreen,FOptions: string;
    FFinderFlags : TFinderFlags;
    FFindOneOptions: TFindOneOptions;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetIENS(IENS: string); virtual;
    function SetBrokerInfo: boolean; virtual;
  public
    function GetIEN: String; virtual;
  published
    property FileNumber: string read FFileNumber write FFileNumber;
    property IENS: string read FIENS write SetIENS;
    property FinderFlags : TFinderFlags read FFinderFlags write FFinderFlags;
    property Value: string read FValue write FValue;
    property FMIndex: string read FFMIndex write FFMIndex;
    property Screen: string read FScreen write FScreen;
    property FindOneOptions: TFindOneOptions read FFindOneOptions write FFindOneOptions;
  end;

procedure Register;

implementation

uses
  System.Types,
  Fmcntrls;

  { ******************** TFMLister Component ************************* }

constructor TFMLister.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResults := TStringList.Create;
  FDisplayFields := TStringList.Create;
  FFieldNumbers := TStringList.Create;
  FFieldNumbers.Add('.01');
  FNumber := '*';
  FDisplayFields.Add('.01');
  FFromList := TStringList.Create;
  FPFromList := TStringList.Create;
  FPartList := TStringList.Create;
end;

destructor TFMLister.Destroy;
begin
  FResults.Free;
  FDisplayFields.Free;
  FFieldNumbers.Free;
  FPFromList.Free;
  FFromList.Free;
  FPartList.Free;
  inherited Destroy;
end;

procedure TFMLister.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

procedure TFMLister.CopyTo(ALister :TFMLister);
begin
  FFile := ALister.FFile;
  FIENS := ALister.FIENS;
  FListerFlags := ALister.FListerFlags;
  FNumber := ALister.FNumber;
  FFromList.Assign(ALister.FFromList);
  FPartList.Assign(ALister.FPartList);
  FIndex := ALister.FIndex;
  FScreen := ALister.FScreen;
  FIdentifier := ALister.FIdentifier;
  FFromIEN := ALister.FFromIEN;
  FDisplayFields.Assign(ALister.FDisplayFields);
  FFieldNumbers.Assign(ALister.FFieldNumbers);
  FRPCBroker := ALister.FRPCBroker;
  FListerOptions := ALister.FListerOptions;
end;

procedure TFMLister.GetList(target: TStrings);
begin
  FPFromList.Clear;
  FPFromIEN := '';
  FResults.Clear;
  if target <> nil then target.Clear;
  GoGetList(target);
end;

procedure TFMLister.GetMore(target: TStrings);
begin
  FPFromList.Assign(FFromList);
  FPFromIEN := FFromIEN;
  GoGetList(target);
end;

procedure TFMLister.GoGetList(target: TStrings);
begin
  FMore     := False;
  ErrorList.Clear;
  try
    if BrokerOK(Self) and SetBrokerInfo then begin
      RPCBroker.Call;
      ParseResults(RPCBroker.Results, target);
      ParseHelpErrors(RPCBroker);
      end
    else
      RPCBroker.ClearParameters := True;
  except
    raise;
  end;
end;

function TFMLister.SetBrokerInfo: Boolean;
var
  sfld : string;
  i    : integer;
begin
  FOptions := '';
  FFlags := '';
  Result := False;
  if PropertyOK(Self) then begin
      Result := True;
      for i := 0 to (FFieldNumbers.Count - 1) do
        if FFieldNumbers[i] <> '' then
          sfld := sfld + FFieldNumbers[i] + ';';
      RPCBroker.RemoteProcedure := 'DDR LISTER';
      RPCBroker.RPCVersion := '1';
      {set up DDR array}
      with RPCBroker.Param[0] do begin
        Ptype  := list;
        Mult['"FILE"']   := FFile;
        Mult['"FIELDS"'] := sfld;
        if (lfInternal in FListerFlags) then
          FFlags := FFlags + 'I';
        if (lfBackwards in FListerFlags) then
          FFlags := FFlags + 'B';
        if (loPackedResults in FListerOptions) then
          FFlags := FFlags + 'P';
        if (loQuickList in FListerOptions) then
          FFlags := FFlags + 'Q';
        if FFlags <> '' then
          Mult['"FLAGS"'] := FFlags;
        if FIdentifier <> '' then begin
          Mult['"ID"'] := FIdentifier;
          FOptions := FOptions + 'WID';
          end;
        if FIENS <> '' then
          Mult['"IENS"'] := FIENS;
        if FNumber <> '' then
          Mult['"MAX"'] := FNumber;
        if FPartList.Count > 0 then
          Mult['"PART"'] := FPartList[0];
        if FScreen <> '' then
          Mult['"SCREEN"'] := FScreen;
        if FIndex <> '' then
          Mult['"XREF"'] := FIndex;
        if FPFromList.Count > 0 then
          Mult['"FROM"'] := FPFromList[0];
        if FPFromIEN <> '' then
          Mult['"FROM","IEN"'] := FPFromIEN;
        if (loReturnWriteIDs in FListerOptions) and (Pos('WID', FOptions)= 0) then
          FOptions := FOptions + 'WID';
        if (loReturnIXValues in FListerOptions) and (Pos('IX', FOptions)= 0) then
          FOptions := FOptions + 'IX';
        Mult['"OPTIONS"'] := FOptions;
          {currently not used}
        {if FDDFile <> '' then
          Mult['"DDFILE"'] := FDDFile;
        if FDDField <> '' then
          Mult['"DDFIELD"'] := FDDField;}
      end;
  end;
end;

procedure TFMLister.ParseResults(source, target: TStrings);
var
  i: integer;
  x: String;
  datatype : String[10];
  RecObj : TFMRecordObj;
  zz: integer;
begin
  datatype :='';
  FFromList.Clear;
  //packed-format results aren't manipulated on the server
  //manipulation will occur here
  if source.count = 0 then exit;
  if (loPackedResults in FListerOptions) then begin
    i := 0;
    x := Source[i];
    zz := FFieldNumbers.Count;
    if x = '[Misc]' then begin
      inc(i);
      x := source[i];
      FMore := true;
      FFromList.Add(Piece(x,U,2));
      FFromIEN := Piece(x,U,3);
      inc(i);
      x := source[i];
      end;
    if x = BEGINERRORS then exit;
    if x = BEGINDATA then begin
      inc(i);
      for i := i to source.Count - 1 do begin
        x := source[i];
        if x = ENDDATA then break;
        RecObj := TFMRecordObj.Create;
        RecObj.IEN := Piece (x, U, 1);
        LoadFLDVals(x, RecObj);
        if loReturnWriteIDs in FListerOptions then LoadWIDVals(x, RecObj, zz);
        FResults.AddObject(Piece(x, U, 1), RecObj);
        if (Target <> nil) then Target.AddObject(DisplayData(RecObj), RecObj);
        end;
      end;
    end
  else
    LoadUnpackedResults(Source, Target);
end;

procedure TFMLister.SetFieldNumbers(FieldNumbers: TStrings);
begin
  FFieldNumbers.Assign(FieldNumbers);
end;

procedure TFMLister.SetDisplayFields(DisplayFields: TStrings);
begin
  FDisplayFields.Assign(DisplayFields);
end;

procedure TFMLister.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMLister.SetPartList(Values: TStrings);
begin
  FPartList.Assign(Values);
end;

procedure TFMLister.LoadUnpackedResults(Source, Target: TStrings);
var
  RecObj : TFMRecordObj;
  x : string;
  i, cnt : integer;
begin
  //get FFldCnt - number of fields returned per record
  FFLDCnt := 0;
  i := Source.IndexOf('BEGIN_IDVALUES');
  if i <> -1 then begin
    inc(i);
    x := Source[i];
    FFLD := Piece(x, U, 1);
    FFLDCnt := StrToInt(Piece(x, U, 2));
    end;
  //get FIXCnt - number of indexvalue fields per record
  FIXCnt := 0;
  i := Source.IndexOf('BEGIN_IXVALUES');
  if i <> -1 then begin
    inc(i);
    FIXCnt := StrToInt(Source[i]);
    end;
  x := '';
  i := 0;
  cnt := 0;
  x := Source[i];
  if x = '[Misc]' then begin
    inc(i);
    x := Source[i];
    FMore := true;
    FFromList.Add(Piece(x,U,2));
    FFromIEN := Piece(x,U,3);
    inc(i);
    x := Source[i];
    end;
  //(main loop is IENs nodes)
  i := Source.Indexof('BEGIN_IENs');
  if i = -1 then Exit;
  while (x <> 'END_IENs') do begin
    inc(i);
    cnt := cnt+1;
    x := Source[i];
    if x = 'END_IENs' then break;
    RecObj := TFMRecordObj.Create;
    RecObj.IEN := x;
    if FIXCnt > 0 then LoadIXVal(Source, RecObj, cnt);
    if FFLDCnt > 0 then LoadFLDVal(Source, RecObj, cnt);
    FResults.AddObject(x, RecObj);
    if (Target <> nil) then Target.AddObject(DisplayData(RecObj), RecObj);
    end;
  if (Source.IndexOf('BEGIN_WIDVALUES') <> -1) then LoadWIDVal(Source);
end;

procedure TFMLister.LoadIXVal(s: TStrings; var R: TFMRecordObj; c: integer);
var
  i, z : integer;
  x : string;
begin
  i := S.IndexOf('BEGIN_IXVALUES');
  if i = -1 then exit;
  inc(i);
  i := i + (c*FIXCnt) - FIXCnt;
  z := 0;
  repeat
    inc(i);
    x := S[i];
    if x = 'END_IXVALUES' then exit;
    if lfInternal in FListerFlags then R.FMIXInternalValues.Add(x)
    else R.FMIXExternalValues.Add(x);
    inc(z);
  until z = FIXCnt;
end;

procedure TFMLister.LoadFLDVal(s: TStrings; var R: TFMRecordObj; c: integer);
var
  i, z : integer;
  x, fld : string;
  obj : TFMFieldObj;
begin
  i := S.IndexOf('BEGIN_IDVALUES');
  if i = -1 then exit;
  inc(i);
  i := i + (c*FFLDCnt) - FFLDCnt;
  z := 0;
  repeat
    inc(i);
    x := S[i];
    fld := Piece(FFLD, ';', z+1);
    if x = 'END_IDVALUES' then exit;
    obj := R.GetField(fld);
    if (obj = nil) then obj:= TFMFieldObj.Create;
    obj.FMField := fld;
    obj.IENS := R.IEN + ',' + FIENS;
    if not (lfInternal in FListerFlags) then obj.FMDBExternal := x
    else obj.FMDBInternal :=x;
    R.FMFLDValues.Addobject(fld , obj);
    inc(z);
  until z = FFLDCnt;
end;

procedure TFMLister.LoadWIDVal(s: TStrings);
var
  i, z , y ,zien: integer;
  x, ien : string;
  recobj  : TFMRecordObj;
begin
  i := S.IndexOf('BEGIN_WIDVALUES');
  while (x <> 'END_WIDVALUES') do begin
    inc(i);
    x := S[i];
    if x = 'END_WIDVALUES' then break;
    if Piece(x, U, 1) = 'WID' then begin
      ien := Piece(x, U, 2);
      zien := FResults.IndexOf(ien);
      recobj := TFMRecordObj(FResults.Objects[zien]);
      z := StrtoInt(Piece(x, U, 3));
      y := 0;
      repeat
        inc(i);
        x := S[i];
        recobj.FMWIDValues.Add(x);
        inc(y);
      until y = z;
      end;
    end;
end;

function TFMLister.DisplayData(s: TFMRecordObj): string;
var
  zfld, zitem, zval : string;
  i,ix : integer;
  z   : TObject;
  delimiter: string;
  dellength: integer;
begin
  if (FDelimiter<>'') and (FDelimiter<>#0) then delimiter:=FDelimiter else delimiter:='    ';
  zitem := '';
  for i := 0 to FDisplayFields.Count - 1 do begin
    zfld := FDisplayFields[i];
    ix := s.FMFLDValues.Indexof(zfld);
    if ix = -1 then continue;
    z := s.FMFLDValues.Objects[ix];
    if (z <> nil) and (z is TFMFieldObj) then begin
      if  not (lfInternal in FListerFlags) then zval := TFMFieldObj(z).FMDBExternal
      else zval := TFMFieldObj(z).FMDBInternal;
      end;
    zitem := zitem + zval + delimiter;
    end;
  dellength:=4;
  if Fdelimiter<>#0 then dellength:=length(FDelimiter);
  Result := Copy(zitem, 1, Length(zitem)-dellength);
end;

{This procedure will be supported in V22 of FM when 'IXIE' specifier is supported}
procedure TFMLister.LoadIXVals(s: String; var RecObj: TFMRecordObj);
begin
  //in v22, look at MAP node (FMapped & FMapNode)
  //set RecObj.FMIXInternalValues if IXI in map node
  RecObj.FMIXExternalValues.Add(Piece(s, U, 2));
end;

procedure TFMLister.LoadFLDVals(s: String; var RecObj: TFMRecordObj);
var
  fld, x : string;
  i      : integer;
  FldObj : TFMFieldObj;
begin
  for i := 0 to FFieldNumbers.Count - 1 do begin
    fld := FFieldNumbers[i];
    FldObj := RecObj.GetField(fld);
    if (FldObj = nil) then FldObj := TFMFieldObj.Create;
    FldObj.IENS := Piece(s, U, 1) + ',' + FIENS;
    FldObj.FMField := fld;
    x := Piece(s, U, i + 2);
    if not (lfInternal in FListerFlags) then FldObj.FMDBExternal := x
    else FldObj.FMDBInternal := x;
    RecObj.FMFLDValues.AddObject(fld, FldObj);
    end;
end;

procedure TFMLister.LoadWIDVals(s: String; var RecObj: TFMRecordObj; zz: integer);
var
  x, z : integer;
  y : string;
begin
  x := zz + 1;
  z := UpArrowPiece(s);
  repeat
    if x = z then exit;
    inc(x);
    y := Piece(s, U, x);
    RecObj.FMWIDValues.Add(y);
  until
    x = z;
end;

function TFMLister.GetRecord(IEN: String): TFMRecordObj;
var
  z : TObject;
begin
  Result := nil;
  if (IEN <> '') and (FResults.IndexOf(IEN) <> -1) then begin
    z := FResults.Objects[FResults.IndexOf(IEN)];
    if (z <> nil) and (z is TFMRecordObj) then Result := TFMRecordObj(z);
    end;
end;

{ ************************** TFMGets Component ********************* }

constructor TFMGets.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResults    := TStringList.Create;
  FFMObjects := TList.Create;
  FFields    := TStringList.Create;
  FFields.Add('.01');
  FGetsFlags := [gfInternal, gfExternal];
end;

destructor TFMGets.Destroy;
begin
  FResults.Free;
  FFields.Free;
  FFMObjects.Free;
  inherited Destroy;
end;

procedure TFMGets.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

procedure TFMGets.GetAndFill;
begin
  GetData;
  FillData;
end;

procedure TFMGets.GetData;
begin
  ErrorList.Clear;
  try
    if BrokerOK(Self) and SetBrokerInfo then begin
      RPCBroker.Call;
      ParseResults(RPCBroker.Results);
      ParseHelpErrors(RPCBroker);
      if (goDDHelp in FGetsOptions) then FillHelp(RPCBroker.Results);
      end
    else
      RPCBroker.ClearParameters := True;
  except
    raise;
  end;
end;

function TFMGets.SetBrokerInfo: Boolean;
var
  sfld : String;
  i: Integer;
begin
  FFlags := '';
  FOptions := '';
  Result := False;
  if PropertyOK(Self) then begin
    sfld := '';
    for i := 0 to (FFields.Count - 1) do
      if FFields[i] <> '' then sfld := sfld + FFields[i] + ';';
    RPCBroker.RemoteProcedure := 'DDR GETS ENTRY DATA';
    RPCBroker.RPCVersion := '1';
    {set up DDR array}
    with RPCBroker.Param[0] do begin
      PType  := list;
      Mult['"FILE"'] := FFile;
      Mult['"FIELDS"'] := sfld;
      Mult['"IENS"'] := FIENS;
      Result := True;
      {-- make sure if FMGets is used by data-aware controls that 'I' & 'E'
      are in FFlags}
      if FFMObjects.Count > 0 then begin
        if Pos('I', FFlags) = 0 then FFlags := FFlags + 'I';
        if Pos('E', FFlags) = 0 then FFlags := FFlags + 'E';
        end
      else begin
        if (gfInternal in FGetsFlags) and (pos('I',FFlags) = 0) then
          FFlags := FFlags + 'I';
        if (gfExternal in FGetsFlags) and (pos('E',FFlags) = 0)  then
          FFlags := FFlags + 'E';
        end;
      if FFlags <> '' then Mult['"FLAGS"'] := FFlags;
      FOptions := FOptions + 'U'; //unpacked mode on the server
      if (goDDHelp in FGetsOptions) then FOptions := FOptions + '?';
      Mult['"OPTIONS"'] := FOptions;
      end;
    end;
end;

procedure TFMGets.ParseResults(source: TStrings);
begin
  FResults.Clear;
  ErrorList.Clear;
  FldObjLoad(source);
end;

procedure TFMGets.SetFields(Fields: TStrings);
begin
  FieldNumbers.Assign(Fields);
end;

procedure TFMGets.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMGets.AddCtrl(Sender: TObject; FMField: String);
begin
  if FFMObjects.IndexOf(Sender) = -1 then FFMObjects.Add(Sender);
  AddField(FMField);
end;

procedure TFMGets.AddField(FMField: String);
begin
  if FFields.Indexof(FMField) = -1 then FFields.Add(FMField);
end;

procedure TFMGets.RemoveCtrl(Sender: TObject; FMField: String);
begin
  if FFMObjects.IndexOf(Sender) <> -1 then
    FFMObjects.Delete(FFMObjects.IndexOf(Sender));
  RemoveField(FMField);
end;

procedure TFMGets.RemoveField(FMField: String);
begin
  if FFields.Indexof(FMField) <> -1 then
    FFields.Delete(FFields.Indexof(FMField));
end;

procedure TFMEditFill(var fld: TFMEdit; fldobj: TFMFieldObj); forward;
procedure TFMCheckBoxFill(var fld: TFMCheckBox; fldobj: TFMFieldObj); forward;
procedure TFMComboBoxFill(var fld: TFMComboBox; fldobj: TFMFieldObj); forward;
procedure TFMComboBoxLookUpFill(var fld: TFMComboBoxLookUp; fldobj: TFMFieldObj); forward;
procedure TFMRadioButtonFill(var fld: TFMRadioButton; fldobj: TFMFieldObj); forward;
procedure TFMLabelFill(var fld: TFMLabel; fldobj: TFMFieldObj); forward;
procedure TFMRadioGroupFill(var fld: TFMRadioGroup; fldobj: TFMFieldObj); forward;
procedure TFMListBoxFill(var fld: TFMListBox; fldobj: TFMFieldObj); forward;
procedure TFMMemoFill(var fld: TFMMemo; fldobj: TFMFieldObj); forward;

procedure TFMGets.FillData;
var
  i: integer;
  fld: TObject;
begin
  for i := 0 to (FFMObjects.Count - 1) do begin
    fld := FFMObjects[i];
    if      TObject(fld) is TFMEdit then
      TFMEditFill(TFMEdit(fld), GetField(TFMEdit(fld).FMField))
    else if TObject(fld) is TFMComboBox then
      TFMComboBoxFill(TFMComboBox(fld), GetField(TFMComboBox(fld).FMField))
    else if TObject(fld) is TFMComboBoxLookUp then
      TFMComboBoxLookUpFill(TFMComboBoxLookUp(fld), GetField(TFMComboBoxLookUp(fld).FMField))
    else if TObject(fld) is TFMCheckBox then
      TFMCheckBoxFill(TFMCheckBox(fld), GetField(TFMCheckBox(fld).FMField))
    else if TObject(fld) is TFMRadioButton then
      TFMRadioButtonFill(TFMRadioButton(fld), GetField(TFMRadioButton(fld).FMField))
    else if TObject(fld) is  TFMRadioGroup then
      TFMRadioGroupFill(TFMRadioGroup(fld), GetField(TFMRadioGroup(fld).FMField))
    else if TObject(fld) is TFMLabel then
      TFMLabelFill(TFMLabel(fld), GetField(TFMLabel(fld).FMField))
    else if TObject(fld) is TFMListBox then
      TFMListBoxFill(TFMListBox(fld), GetField(TFMListBox(fld).FMField))
    else if TObject(fld) is TFMMemo then
      TFMMemoFill(TFMMemo(fld), GetField(TFMMemo(fld).FMField));
    end;
end;

procedure TFMGets.ClearCtrlData;
begin
  SetCtrlData('','','');
end;

procedure TFMGets.SetCtrlData(Entry, Intern, Extern: String);
var
  i: integer;
  fld: TObject;
  fldobj: TFMFieldObj;
begin
  fldobj := TFMFieldObj.Create;
  fldobj.IENS := entry;
  fldobj.FMDBInternal := intern;
  fldobj.FMDBExternal := extern;
  for i := 0 to (FFMObjects.Count - 1) do begin
    fld := FFMObjects[i];
    if      TObject(fld) is TFMEdit then
      TFMEditFill(TFMEdit(fld), fldobj)
    else if TObject(fld) is TFMComboBoxLookUp then
      TFMComboBoxLookUpFill(TFMComboBoxLookUp(fld), fldobj)
    else if TObject(fld) is TFMComboBox then
      TFMComboBoxFill(TFMComboBox(fld), fldobj)
    else if TObject(fld) is TFMCheckBox then
      TFMCheckBoxFill(TFMCheckBox(fld), fldobj)
    else if TObject(fld) is TFMRadioButton then
      TFMRadioButtonFill(TFMRadioButton(fld), fldobj)
    else if TObject(fld) is TFMRadioGroup then
      TFMRadioGroupFill(TFMRadioGroup(fld), fldobj)
    else if TObject(fld) is TFMLabel then
      TFMLabelFill(TFMLabel(fld), fldobj)
    else if TObject(fld) is TFMListBox then
      TFMListBoxFill(TFMListBox(fld), fldobj)
    else if TObject(fld) is TFMMemo then
      TFMMemoFill(TFMMemo(fld), fldobj);
    end;
  fldobj.free;
end;

procedure TFMGets.SetUpNewEntry(PlaceHolder: String);
begin
  ClearCtrlData;
  StuffIENS(PlaceHolder);
end;

procedure TFMGets.StuffIENS(Entry: String);
var
  i: integer;
  cls: string;
  fld: TObject;
begin
  for i := 0 to (FFMObjects.Count - 1) do begin
    fld := FFMObjects[i];
    cls := TObject(fld).ClassName;
    if TObject(fld) is TFMEdit then
      TFMEdit(fld).IENS := Entry
    else if TObject(fld) is TFMComboBoxLookUp then
      TFMComboBoxLookUp(fld).IENS := Entry
    else if TObject(fld) is TFMComboBox then
      TFMComboBox(fld).IENS := Entry
    else if TObject(fld) is TFMCheckBox then
      TFMCheckBox(fld).IENS := Entry
    else if TObject(fld) is TFMListBox then
      TFMListBox(fld).IENS := Entry
    else if TObject(fld) is TFMRadioButton then
      TFMRadioButton(fld).IENS := Entry
    else if TObject(fld) is TFMRadioGroup then
      TFMRadioGroup(fld).IENS := Entry
    else if TObject(fld) is TFMLabel then
      TFMLabel(fld).IENS := Entry
    else if TObject(fld) is TFMMemo then
      TFMMemo(fld).IENS := Entry;
    end;
end;

procedure TFMGets.FldObjLoad(Source: TStrings);
var
  fldobj : TFMFieldObj;
  x,flag : string;
  nxtloop, z, i : integer;
  ext, int, wp : boolean;
begin
  x := '';
  i := 0;
  int := False;
  ext := False;
  wp := False;
  while (x <> ENDDATA) and (i <> Source.Count - 1) do begin
    inc(i);
    x := Source[i];
    if (x = ENDDATA) or (x = BEGINERRORS) or (x = BEGINHELP) then break;
    {process one fldobj}
    fldobj := TFMFieldObj.Create;
    z := 0;
    fldobj.IENS := Piece(x, U, 2);
    fldobj.FMField := Piece(x, U, 3);
    flag := Piece(x, U, 4);
    nxtloop := 0;
    if pos('E', flag) > 0 then ext := true;
    if pos('I', flag) > 0 then int := true;
    if pos('B', flag) > 0 then begin
      nxtloop :=2;
      ext := true;
      int := true;
      end;
    if pos('W', flag) > 0 then begin
      nxtloop := StrToInt(Piece(x, U, 5));
      wp := True;
      int := False;
      ext := False;
      end;
    repeat
      if nxtloop = 0 then break;
      inc(i);
      x := Source[i];
      if ext then begin
        fldobj.FMDBExternal := x;
        if int then begin
          inc(i);
          x := Source[i];
          inc(z);
          end;
        end;
      if int then begin
        fldobj.FMDBInternal := x;
        end;
      if wp then fldobj.FMWPTextlines.Add(x);
      inc(z)
    until (z = nxtloop) or (z > nxtloop);
    FResults.AddObject(fldobj.FMField, fldobj);
  end;
end;

function TFMGets.GetField(FMField: string): TFMFieldObj;
var
   z : TObject;
begin
  Result := nil;
  if FResults.IndexOf(FMField)=-1 then exit;
  z := FResults.Objects[FResults.IndexOf(FMField)];
  if (z <> nil) and (z is TFMFieldObj) then Result := TFMFieldObj(z);
end;

procedure TFMEditFill(var fld: TFMEdit; fldobj: TFMFieldObj);
begin
  if fldobj = nil then exit;
  with fld do begin
    IENS       := fldobj.IENS;
    Text       := fldobj.FMDBExternal;
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := Text;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMLabelFill(var fld: TFMLabel; fldobj: TFMFieldObj);
begin
  if fldobj = nil then exit;
  with fld do begin
    IENS       := fldobj.IENS;
    Caption    := fldobj.FMDBExternal;
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := Caption;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMCheckBoxFill(var fld: TFMCheckBox; fldobj: TFMFieldObj);
var
  x : String;
begin
  if fldobj = nil then exit;
  with fld do begin
    x := fldobj.FMDBInternal;
    if x = FMValueChecked then begin
      FMTag := True;
      Checked := True;
      end
    else
      if (x = FMValueUnchecked) or (x = '') then begin
        FMTag := False;
        Checked := False;
        end
      else begin
        FMTag := False;
        State := cbGrayed;
        end;
    IENS       := fldobj.IENS;
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := fldobj.FMDBExternal;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMComboBoxFill(var fld: TFMComboBox; fldobj: TFMFieldObj);
var
  ndx : integer;
begin
  if fldobj = nil then exit;
  with fld do begin
    if (fld.Sorted = true) then fld.SortResults;
    IENS := fldobj.IENS;
    ndx := fld.FMLister.Results.Indexof(fldobj.FMDBInternal);
    ItemIndex := ndx;
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := fldobj.FMDBExternal;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMComboBoxLookupFill(var fld: TFMComboBoxLookup; fldobj: TFMFieldObj);
var
  tempfinder : TFMFinder;
begin
  if fldobj = nil then exit;
  with fld do begin
    Items.Clear;
    if (fldobj.FMDBInternal <> '') and (FMLister <> nil) then
      //a Lister call here causes long delay in getandfill
      begin
      TempFinder := TFMFinder.Create(application);
      TempFinder.DisplayFields.Assign(FMLister.DisplayFields);
      TempFinder.FieldNumbers.Assign(FMLister.FieldNumbers);
      TempFinder.FileNumber := FMLister.FileNumber;
      TempFinder.FMIndex := FMLister.FMIndex;
      TempFinder.Identifier := FMLister.Identifier;
      TempFinder.IENS := FMLister.IENS;
      TempFinder.RPCBroker := FMLister.RPCBroker;
      TempFinder.Screen := 'I Y=' + fldobj.FMDBInternal;
      TempFinder.Value := fldobj.FMDBExternal;
      if loReturnWriteIDs in FMLister.ListerOptions then
        TempFinder.FinderOptions := [foReturnWriteIDs];
      TempFinder.GetFinderList(fld.Items);
      if TempFinder.ErrorList.Count <> 0 then begin
        TempFinder.DisplayErrors;
        Exit;
        end;
      end;
    IENS       := fldobj.IENS;
    ItemIndex  := fld.Items.Indexof(fldobj.FMDBExternal);
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := fldobj.FMDBExternal;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMRadioButtonFill(var fld: TFMRadioButton; fldobj: TFMFieldObj);
begin
  if fldobj = nil then exit;
  with fld do begin
    IENS       := fldobj.IENS;
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := fldobj.FMDBExternal;
    FMTag := (FMValueChecked = FMCtrlInternal);
    Checked := (FMValueChecked = FMCtrlInternal);
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMRadioGroupFill(var fld: TFMRadioGroup; fldobj: TFMFieldObj);
begin
  if fldobj = nil then exit;
  with fld do begin
    IENS       := fldobj.IENS;
    ItemIndex  := fld.FMInternalCodes.Indexof(fldobj.FMDBInternal);
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := fldobj.FMDBExternal;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMListBoxFill(var fld: TFMListBox; fldobj: TFMFieldObj);
var
  ndx : integer;
begin
  if fldobj = nil then exit;
  with fld do begin
    if (fld.Sorted = true) then fld.SortResults;
    IENS       := fldobj.IENS;
    ndx := fld.FMLister.Results.Indexof(fldobj.FMDBInternal);
    ItemIndex := ndx;
    FMCtrlInternal := fldobj.FMDBInternal;
    FMDBInternal := FMCtrlInternal;
    FMDBEXternal := fldobj.FMDBExternal;
    FMCtrlExternal := FMDBExternal;
  end;
end;

procedure TFMMemoFill(var fld: TFMMemo; fldobj: TFMFieldObj);
var
  i : integer;
  x, space, prev : string;
begin
  if fldobj = nil then exit;
  with fld do begin
    IENS := fldobj.IENS;
    Lines.Clear;
    if FMMemoStyle = msByLines then Lines := fldobj.FMWPTextLines
    else begin
      text := '';
      space := ' ';
      for i := 0 to fldobj.FMWPTextLines.Count - 1 do begin
        x := fldobj.FMWPTextLines[i];
        if (x <> '') and (x <> ' ')  then begin
          if (pos(' ', x) = 1) or (text = '') then space := '';
          text := text + space + x;
          prev := x;
          end
        else begin
          if prev <> x then text := text + #13#10#13#10
          else text := text + #13#10;
          prev := x;
          end
        end;
      end;
    end;
end;

procedure TFMEditHelpFill(var fld: TFMEdit; source: TStrings); forward;
procedure TFMCheckBoxHelpFill(var fld: TFMCheckBox; source: TStrings); forward;
procedure TFMComboBoxHelpFill(var fld: TFMComboBox; source: TStrings); forward;
procedure TFMComboBoxLookUpHelpFill(var fld: TFMComboBoxLookUp; source: TStrings); forward;
procedure TFMRadioButtonHelpFill(var fld: TFMRadioButton; source: TStrings); forward;
procedure TFMRadioGroupHelpFill(var fld: TFMRadioGroup; source: TStrings); forward;
procedure TFMListBoxHelpFill(var fld: TFMListBox; source: TStrings); forward;
procedure TFMMemoHelpFill(var fld: TFMMemo; source: TStrings); forward;

{loop thru FFMObjects, for each object call the associated FillHelp procedure.
the FillHelp procedure loops thru the entire help (results) array and looks
for a matching file & field combo.  This is tedious and the only way this
could be done now.  If the fmcontrol is associated w/ the FFields, (or if
FFMObject is associated w/ a field), then this could be modified to loop thru
results array first, for each help record, get field, find field in FFields
list and find the associated object.}
procedure TFMGets.FillHelp(source: TStrings);
var
  i: integer;
  cls: string;
  fld: TObject;
begin
  for i := 0 to (FFMObjects.Count - 1) do begin
    fld := FFMObjects[i];
    cls := TObject(fld).ClassName;
    if TObject(fld) is TFMEdit then
      TFMEditHelpFill(TFMEdit(fld), source)
    else if TObject(fld) is TFMComboBox then
      TFMComboBoxHelpFill(TFMComboBox(fld), source)
    else if TObject(fld) is TFMComboBoxLookUp then
      TFMComboBoxLookupHelpFill(TFMComboBoxLookUp(fld), source)
    else if TObject(fld) is TFMCheckBox then
      TFMCheckBoxHelpFill(TFMCheckBox(fld), source)
    else if TObject(fld) is TFMRadioButton then
      TFMRadioButtonHelpFill(TFMRadioButton(fld), source)
    else if TObject(fld) is TFMRadioGroup then
      TFMRadioGroupHelpFill(TFMRadioGroup(fld), source)
    else if TObject(fld) is TFMListBox then
      TFMListBoxHelpFill(TFMListBox(fld), source)
    else if TObject(fld) is TFMMemo then
      TFMMemoHelpFill(TFMMemo(fld), source);
    end;
end;

procedure TFMEditHelpFill(var fld: TFMEdit; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMEdit(fld).FMFile;
  fl := TFMEdit(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMEdit(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMCheckBoxHelpFill(var fld: TFMCheckBox; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMCheckBox(fld).FMFile;
  fl := TFMCheckBox(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMCheckBox(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMComboBoxHelpFill(var fld: TFMComboBox; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMComboBox(fld).FMFile;
  fl := TFMComboBox(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMComboBox(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMComboBoxLookUpHelpFill(var fld: TFMComboBoxLookUp; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMComboBoxLookup(fld).FMFile;
  fl := TFMComboBoxLookup(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMComboBoxLookup(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMRadioButtonHelpFill(var fld: TFMRadioButton; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMRadioButton(fld).FMFile;
  fl := TFMRadioButton(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMRadioButton(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMRadioGroupHelpFill(var fld: TFMRadioGroup; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMRadioGroup(fld).FMFile;
  fl := TFMRadioGroup(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMRadioGroup(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMListBoxHelpFill(var fld: TFMListBox; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMListBox(fld).FMFile;
  fl := TFMListBox(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMListBox(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

procedure TFMMemoHelpFill(var fld: TFMMemo; source: TStrings);
var
  fi, fl, x, y: String;
  item: integer;
begin
  fi := TFMMemo(fld).FMFile;
  fl := TFMMemo(fld).FMField;
  x := fi + u + fl + u + '?';
  item := source.indexof(BEGINHELP);
  if item >0 then begin
    while (y <> ENDHELP) and (item <> source.count-1) do begin
      inc(item);
      y := source[item];
      if pos(x, y) > 0 then begin
{$WARN UNSAFE_CAST OFF}
        TFMMemo(fld).FMHelpObj := TFMGets(fld).LoadOneHelp(source, item, y);
{$WARN UNSAFE_CAST ON}
        break;
        end;
      end;
    end;
end;

{********************* TFMValidator Component *************************** }

constructor TFMValidator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResults  := TStringList.Create;
end;

destructor TFMValidator.Destroy;
begin
  FResults.Free;
  inherited Destroy;
end;

procedure TFMValidator.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

procedure TFMValidator.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMValidator.Clear;
begin
     FFile    := '';
     FIENS    := '';
     FField   := '';
     FValue   := '';
     FResults.Clear;
end;

function TFMValidator.Validate: Boolean;
begin
  Result := False;
  ErrorList.Clear;
  if BrokerOK(Self) and PropertyOK(Self) then begin
    RPCBroker.RemoteProcedure := 'DDR VALIDATOR';
    RPCBroker.RPCVersion := '1';
    with RPCBroker.Param[0] do begin
      Value  := '.DDR';
      Ptype  := list;
      Mult['"FILE"']  := FFile;
      Mult['"IENS"']  := FIENS;
      Mult['"FIELD"'] := FField;
      Mult['"VALUE"'] := FValue;
    end;
    RPCBroker.Call;
    ParseResults(RPCBroker.Results);
    ParseHelpErrors(RPCBroker);
    Result := (FResults[0] <> U);
  end
end;

procedure TFMValidator.ParseResults(source: TStrings);
var
  i : integer;
  datatype, x : String;
begin
  FResults.Clear;
  datatype :='';
  for i := 0 to source.Count - 1 do begin
    x := source[i];
    if x = BEGINERRORS then break
    else if x = '[Data]' then datatype := 'Data'
    else if datatype = 'Data' then FResults.Add(x);
  end;
end;

procedure TFMValidator.SetUp(FileNumber, IENS, FieldNumber, Value: String);
begin
     Clear;
     FFile  := FileNumber;
     FIENS  := IENS;
     FField := FieldNumber;
     FValue := Value;
end;

{***** TFMFiler Component ***** }

procedure TFMEditUpdate(fld: TFMEdit; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMCheckBoxUpdate(fld: TFMCheckBox; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMComboBoxUpdate(fld: TFMComboBox; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMLabelUpdate(fld: TFMLabel; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMListBoxUpdate(fld: TFMListBox; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMMemoUpdate(fld: TFMMemo; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMRadioButtonUpdate(fld: TFMRadioButton; RPCBroker: TRPCBroker; subcnt: Integer); forward;
procedure TFMRadioGroupUpdate(fld: TFMRadioGroup; RPCBroker: TRPCBroker; subcnt: Integer); forward;

constructor TFMFiler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNewIENs          := TStringList.Create;
  FPlaceHolder      := TStringList.Create;
  FStatus           := Not_Edited;
  FChangedCtrlsList := TList.Create;
  FFMCtrlsList      := TList.Create;
  FDataProblemList  := TStringList.Create;
  FIENsList          := TStringList.Create;
end;

destructor TFMFiler.Destroy;
begin
  FNewIENs.Free;
  FPlaceHolder.Free;
  self.Clear;
  FChangedCtrlsList.Free;
  FFMCtrlsList.Free;
  SetLength(FFDAList, 0);
  FDataProblemList.Free;
  FIENsList.Free;
  inherited Destroy;
end;

procedure TFMFiler.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

{Allows app to cancel entire update/save.}
procedure TFMFiler.Clear;
var
  i      : Integer;
begin
  FChangedCtrlsList.Clear;
  FDataProblemList.Clear;
  for i := 0 to Length(FFDAList) - 1 do begin
    FFDAList[i].free;
  end;
  SetLength(FFDAList, 0);
  FStatus := Not_Edited;
  FIENsList.Clear;
end;

{Allows app to cancel an individual object's data from being sent
after a call to AddCtrl}
procedure TFMFiler.RemoveChgdControl(Sender: TObject);
var
  i   : Integer;
  obj : TObject;
begin
  i := FChangedCtrlsList.IndexOf(Sender);
  if i <> -1 then begin
    obj := FChangedCtrlsList[i];
    FChangedCtrlsList.Remove(Obj);
    FChangedCtrlsList.Pack;
    end;
end;

{Allows app to tell filer which objects' data to send}
procedure TFMFiler.AddChgdControl(Sender: TObject);
begin
  if FChangedCtrlsList.IndexOf(Sender) = -1 then begin
    FChangedCtrlsList.Add(Sender);
    FStatus := Edited;
    end;
end;

{Allows controls to register with Filer for processing checks,
like required data.}
procedure TFMFiler.AddCtrl(Sender: TObject);
begin
  if FFMCtrlsList.IndexOf(Sender) = -1 then FFMCtrlsList.Add(Sender);
end;

{Removes control from the Filer's list of controls}
procedure TFMFiler.RemoveCtrl(Sender: TObject);
begin
  if FFMCtrlsList.IndexOf(Sender) <> -1 then
    FFMCtrlsList.Delete(FFMCtrlsList.IndexOf(Sender));
end;

{performs check to see if data entered is ok}
function TFMFiler.DataProblemCheck: Boolean;
var
  i: Integer;
  fld: TObject;
  ok: Boolean;
  chklist : TList;
begin
  Result := False;
  FDataProblemList.Clear;
  chkList := TList.Create;
  ok := True;
  for i := 0 to (FChangedCtrlsList.Count - 1) do begin
    fld := FChangedCtrlsList[i];
    if fld <> nil then begin
      chkList.Add(fld);
      if fld is TFMEdit then ok :=TFMEdit(fld).FieldCheck
      else if fld is TFMCheckBox then ok := TFMCheckBox(fld).FieldCheck
      else if (fld is TFMComboBox) or (fld is TFMComboBoxLookUp)then
        ok := TFMComboBox(fld).FieldCheck
      else if fld is TFMLabel then ok := TFMLabel(fld).FieldCheck
      else if fld is TFMListBox then ok := TFMListBox(fld).FieldCheck
      else if fld is TFMMemo then ok := TFMMemo(fld).FieldCheck
      else if fld is TFMRadioButton then ok := TFMRadioButton(fld).FieldCheck
      else if fld is TFMRadioGroup then ok := TFMRadioGroup(fld).FieldCheck;
      if not ok then AddDataProblem(TComponent(fld));
      end;
    end;

  {check fields on AddEntry but not entered}
    for i := 0 to (FFMCtrlsList.Count - 1) do begin
      fld := FFMCtrlsList.Items[i];
      if (fld <> nil) and (chkList.IndexOf(fld) = -1) then begin
        chkList.Add(fld);
        if fld is TFMEdit then ok := (fld as TFMEdit).FieldCheck
        else if fld is TFMCheckBox then ok := TFMCheckBox(fld).FieldCheck
        else if (fld is TFMComboBox) or (fld is TFMComboBoxLookUp) then
          ok := TFMComboBox(fld).FieldCheck
        else if fld is TFMLabel then ok := TFMLabel(fld).FieldCheck
        else if fld is TFMListBox then ok := TFMListBox(fld).FieldCheck
        else if fld is TFMMemo then ok := TFMMemo(fld).FieldCheck
        else if fld is TFMRadioButton then ok := TFMRadioButton(fld).FieldCheck
        else if fld is TFMRadioGroup then ok := TFMRadioGroup(fld).FieldCheck;
        if not ok then AddDataProblem(TComponent(fld));
        end;
      end;
  chkList.Free;
  if FDataProblemList.Count > 0 then begin
    Result := True;
    if (foProcessProblemList in FFilerOptions) then ProcessDataProblemList;
    end;
  if Assigned(FFilerProbListForm) and (FDataProblemList.Count = 0) then FFilerProbListForm.Close;
end;

{Add control to data problem list}
procedure TFMFiler.AddDataProblem(fld: TComponent);
var
  name: TFMStr50;
begin
  if fld is TFMEdit then name := TFMEdit(fld).FMDisplayName
  else if fld is TFMCheckBox then name := TFMCheckBox(fld).FMDisplayName
  else if (fld is TFMComboBox) or (fld is TFMComboBoxLookUp)then
    name := TFMComboBox(fld).FMDisplayName
  else if fld is TFMLabel then name := TFMLabel(fld).FMDisplayName
  else if fld is TFMListBox then name := TFMListBox(fld).FMDisplayName
  else if fld is TFMMemo then name := TFMMemo(fld).FMDisplayName
  else if fld is TFMRadioButton then name := TFMRadioButton(fld).FMDisplayName
  else if fld is TFMRadioGroup then name := TFMRadioGroup(fld).FMDisplayName;
  if name = '' then name := '<<<none defined>>';
  FDataProblemList.AddObject(name, fld);
end;

procedure TFMFiler.ProcessDataProblemList;
var
  name : string;
  i    : integer;
  obj : TObject;
begin
  if FDataProblemList.Count > 0 then begin
    if not Assigned (FFilerProbListForm)
      then FFilerProbListForm := TfrmDataProblemList.Create(Owner);
    FFilerProbListForm.ProblemListBox.Items.Clear;
    for i := 0 to FDataProblemList.Count - 1 do begin
      name := FDataProblemList[i];
      obj := TObject(FDataProblemList.Objects[i]);
      FFilerProbListForm.ProblemListBox.Items.AddObject(name, obj);
      end;
    FFilerProbListForm.show;
    end;
end;

{Used to add data to list of things to file when data not
associated with a FM control.}
procedure TFMFiler.AddFDA(FileNumber, IENS, FieldNumber, Value: String);
var
  fda: TFMFDAObj;
  i: integer;
begin
  fda := TFMFDAObj.Create;
  fda.FMFileNumber := FileNumber;
  fda.FMFieldNumber := FieldNumber;
  fda.IENS := IENS;
  fda.FMInternal := Value;
  i := Length(FFDAList);
  SetLength(FFDAList, i+1);
  FFDAList[i] := fda;
end;

{Indicates if either of TFMFiler's lists contain items to file}
function  TFMFiler.AnythingToFile : Boolean;
var
  obj           : Tobject;
begin
  Result := False;
  //before starting, autovalidate activecontrol
  if (Owner is Tform) and (Tform(Owner).ActiveControl <> nil) then begin
   Obj := Tform(owner).ActiveControl;
   if (Obj is TFMEdit) then TFMEdit(Obj).AutoValidate
   else if (Obj is TFMMemo) then TFMMemo(Obj).AutoValidate
   else if (Obj is TFMListBox) then TFMListBox(Obj).AutoValidate
   else if (Obj is TFMComboBox) then TFMComboBox(Obj).AutoValidate
   else if (Obj is TFMRadioButton) then TFMRadioButton(Obj).AutoValidate
   else if (Obj is TFMRadioGroup) then TFMRadioGroup(Obj).AutoValidate
   else if (Obj is TFMCheckBox) then TFMCheckBox(Obj).AutoValidate;
   end;
  if FChangedCtrlsList.Count > 0 then Result := True;
  if Length(FFDAList) > 0 then Result := True;
end;

function TFMFiler.Update: boolean;
var
  i,index,subcnt: integer;
  fld           : TObject;
  cls,x         : String;
  datatype      : String;
  fda           : TFMFDAObj;
  source        : TStrings;
  obj           : Tobject;
  iens          : string;
begin
  FFlags := '';          // need to evaluate this further jli 3-16-99
  //before starting, autovalidate activecontrol
 if (Owner is Tform) and (Tform(Owner).ActiveControl <> nil) then begin
   Obj := Tform(owner).ActiveControl;
   if (Obj is TFMEdit) then TFMEdit(Obj).AutoValidate
   else if (Obj is TFMMemo) then TFMMemo(Obj).AutoValidate
   else if (Obj is TFMListBox) then TFMListBox(Obj).AutoValidate
   else if (Obj is TFMComboBox) then TFMComboBox(Obj).AutoValidate
   else if (Obj is TFMRadioButton) then TFMRadioButton(Obj).AutoValidate
   else if (Obj is TFMRadioGroup) then TFMRadioGroup(Obj).AutoValidate
   else if (Obj is TFMCheckBox) then TFMCheckBox(Obj).AutoValidate;
   end;
  {Before starting check if filing is appropriate.}
  if (not AnythingToFile) or (foNotEditable in FFilerOptions) then begin
    Result := True;  {No error in filing, Update returns True}
    exit;
    end;
  Result := False;
  ErrorList.Clear;
  try
    if BrokerOK(Self) then begin
      source := TStringList.Create;
      Screen.Cursor := crHourglass;
      FNewIENs.Clear;
      FPlaceHolder.Clear;
      RPCBroker.RemoteProcedure := 'DDR FILER';
      RPCBroker.RPCVersion := '1';
      {set up edited fields array}
      with RPCBroker.Param[1] do Ptype  := list;
      subcnt  := 0;
      for index := 0 to (FChangedCtrlsList.Count - 1) do begin
        fld := FChangedCtrlsList[index];
        if fld <> nil then begin
          inc(subcnt);
          cls := TObject(fld).ClassName;
          if fld is TFMEdit then
            TFMEditUpdate(TFMEdit(fld),RPCBroker, subcnt)
          else if fld is TFMCheckBox then
            TFMCheckBoxUpdate(TFMCheckBox(fld),RPCBroker, subcnt)
          else if (fld is TFMComboBox) or (fld is TFMComboBoxLookUp) then
            TFMComboBoxUpdate(TFMComboBox(fld),RPCBroker, subcnt)
          else if fld is TFMLabel then
            TFMLabelUpdate(TFMLabel(fld),RPCBroker, subcnt)
          else if fld is TFMListBox then
            TFMListBoxUpdate(TFMListBox(fld),RPCBroker, subcnt)
          else if fld is TFMMemo then
            TFMMemoUpdate(TFMMemo(fld),RPCBroker, subcnt)
          else if fld is TFMRadioButton then
            TFMRadioButtonUpdate(TFMRadioButton(fld),RPCBroker, subcnt)
          else if fld is TFMRadioGroup then
            TFMRadioGroupUpdate(TFMRadioGroup(fld),RPCBroker, subcnt)
          else
            dec(subcnt);
          end;
        iens := Piece(RPCBroker.Param[1].Mult[IntToStr(subcnt)], U, 3);
        SetMode(IENS);
        end;
      {Add any required/key values to fda array scheme}
      for index := 0 to (Length(FFDAList) - 1) do begin
        fda := FFDAList[index];
        if fda.FMFileNumber <> '' then begin
          inc(subcnt);
          RPCBroker.Param[1].Mult[IntToStr(subcnt)] :=
            fda.FMFileNumber
            + U + fda.FMFieldNumber
            + U + fda.IENS
            + U + fda.FMInternal;
          end;
        iens := Piece(RPCBroker.Param[1].Mult[IntToStr(subcnt)], U, 3);
        SetMode(IENS);
        end;

      {set up edit-mode parameter}
      with RPCBroker.Param[0] do begin
        if FMode = 'AddEntry'  then Value := 'ADD'
        else if FMode = 'EditEntry' then Value := 'EDIT';
        Ptype  := literal;
        end;

      {send loc'K' flag}
      with RPCBroker.Param[2] do begin
        Ptype := literal;
        if (FMode = 'EditEntry') and (ffLock in FFilerFlags) then
          Value := FFlags + 'K';
        end;

      {send IENs array}
      if FIENsList.Count >0 then
      with RPCBroker.Param[1] do begin
        Ptype := list;
        for i := 0 to FIENsList.Count - 1 do
          Mult['"IENs",' + '"' + Piece(FIENsList[i], U, 1) + '"'] := Piece(FIENsList[i], U, 2);
        end;

      {Make call to broker}
      RPCBroker.Call;
      source.Assign(RPCBroker.Results);
      datatype := '';
      for i := 0 to source.Count - 1 do begin
        x := source[i];
        if x = BEGINERRORS then break
        else if x = '[Data]' then datatype := 'Data'
        else if datatype = 'Data' then begin
          FNewIENs.Add(x);
          FPlaceHolder.Add(Piece(x, U, 1));
          end
        end;
      source.Free;
      ParseHelpErrors(RPCBroker);
      Result := (ErrorList.Count = 0);
      {Clean up processing}
      Self.Clear;
      Screen.Cursor := crDefault;
    end;
  except
    raise;
  end;
end;

{This function finds the IEN associated with a placeholder
(such as +1) after calling Update.}
function TFMFiler.FindIEN(PlaceHolder: String): String;
var
  i: Integer;
begin
  Result := '';
  i := FPlaceHolder.IndexOf(PlaceHolder);
  if i <> -1 then Result := Piece(FNewIENs[i], U, 2);
end;

{Allows app to validate all objects specified via Add code
function TFMFiler.Validate: Boolean;
begin
     Result := True;
end;}

procedure TFMEditUpdate(fld: TFMEdit; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
            fld.FMFile
      + U + fld.FMField
      + U + fld.IENS
      + U + fld.FMCtrlInternal;
    end;
end;

procedure TFMCheckBoxUpdate(fld: TFMCheckBox; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
            fld.FMFile
      + U + fld.FMField
      + U + fld.IENS
      + U + fld.FMCtrlInternal;
    end;
end;

procedure TFMComboBoxUpdate(fld: TFMComboBox; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
             fld.FMFile
       + U + fld.FMField
       + U + fld.IENS
       + U + fld.FMCtrlInternal;
    end;
end;

procedure TFMLabelUpdate(fld: TFMLabel; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
             fld.FMFile
       + U + fld.FMField
       + U + fld.IENS
       + U + fld.FMCtrlInternal;
    end;
end;

procedure TFMListBoxUpdate(fld: TFMListBox; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
             fld.FMFile
       + U + fld.FMField
       + U + fld.IENS
       + U + fld.FMCtrlInternal;
    end;
end;

procedure TFMMemoUpdate(fld: TFMMemo; RPCBroker: TRPCBroker; subcnt: Integer);
var
  i, last: integer;
begin
  i := 0;
  with RPCBroker.Param[1] do begin
    {place file, field & entry info in parent node}
    Mult[IntToStr(subcnt)] :=
            fld.FMFile
      + U + fld.FMField
      + U + fld.IENS
      + U + 'DDRROOT('+ IntToStr(subcnt) + ')';
      {add memo field data}
      if fld.Lines.Count > 0 then begin
        last := fld.Lines.Count-1;
        for i := 0 to last do begin
          Mult[IntToStr(subcnt) + ',' + IntToStr(i+1)] := fld.Lines[i];
          end;
        end
      else Mult[IntToStr(subcnt) + ',' + IntToStr(i+1)] := '';
    end;
end;

procedure TFMRadioButtonUpdate(fld: TFMRadioButton; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
            fld.FMFile
      + U + fld.FMField
      + U + fld.IENS
      + U + fld.FMCtrlInternal;
     end;
end;

procedure TFMRadioGroupUpdate(fld: TFMRadioGroup; RPCBroker: TRPCBroker; subcnt: Integer);
begin
  with RPCBroker.Param[1] do begin
    Mult[IntToStr(subcnt)] :=
            fld.FMFile
      + U + fld.FMField
      + U + fld.IENS
      + U + fld.FMCtrlInternal;
     end;
end;

procedure TFMFiler.SetMode(IENS: String);
begin
  if FMode = 'AddEntry' then exit;
  if pos('?', IENS) > 0 then FMode := 'AddEntry'
  else if pos('+', IENS) > 0 then FMode := 'AddEntry'
  else FMode := 'EditEntry';
end;

procedure TFMFiler.AddIEN(PlaceHolder, IEN: string);
begin
  if pos('+', PlaceHolder) = 0 then FIENsList.Add(PlaceHolder + U + IEN)
  else  FIENsList.Add(Copy(PlaceHolder, Pos('+', PlaceHolder) + 1, 255) + U + IEN);
end;

{**************** TFMHelp Component *********** }

procedure TFMHelp.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

procedure TFMHelp.GetAndDisplayHelp;
begin
  FHelpObj := GetHelp;
  if Assigned (FHelpObj) then DisplayHelp;
end;

function TFMHelp.GetHelp: TFMHelpObj;
var
  x : string;
  item : integer;
  Hlp : TFMHelpObj;
begin
  try
    Result := nil;
    Hlp := nil;
    item := 0;
    if SetBrokerInfo then begin
      RPCBroker.Call;
      while (x <> ENDHELP) and (item < RPCBroker.Results.Count -1) do begin
        inc(item);
        x := RPCBroker.Results[item];
        if x = ENDHELP then break;
        Hlp := LoadOneHelp(RPCBroker.Results, item, x);
        end;
      Result := Hlp;
      end;
  except
    raise;
  end;
end;

procedure TFMHelp.DisplayHelp;
begin
  if FDisplayPanel = nil then FHelpObj.DisplayHelp
  else
    FDisplayPanel.Caption := FHelpObj.HelpText[0];
end;

procedure TFMHelp.DisplyHlp(FHelp: TFMHelpObj);
begin
  if (FDisplayPanel <> nil) and (FHelp.Helptext.Count > 0) then FDisplayPanel.Caption := FHelp.HelpText[0];
end;

function TFMHelp.SetBrokerInfo: Boolean;
begin
  Result := False;
  if BrokerOK(Self) and PropertyOK(Self) then begin
    RPCBroker.RemoteProcedure := 'DDR GET DD HELP';
    RPCBroker.RPCVersion := '1';
    with RPCBroker.Param[0] do begin
      PType := list;
      Mult['"FILE"'] := FFileNumber;
      Mult['"FIELD"']  := FFieldNumber;
      if FHelpFlags = '' then FHelpFlags := '?';
      Mult['"FLAGS"'] := FHelpFlags;
      end;
    Result := True;
    end;
end;

{*************** TFMFinder Component ***************}

constructor TFMFinder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResults := TStringList.Create;
  FDisplayFields := TStringList.Create;
  FFieldNumbers := TStringList.Create;
  FFieldNumbers.Add('.01');
  FNumber := '*';
  FDisplayFields.Add('.01');
end;

destructor TFMFinder.Destroy;
begin
  FResults.Free;
  FDisplayFields.Free;
  FFieldNumbers.Free;
  inherited Destroy;
end;

procedure TFMFinder.SetFieldNumbers(FieldNumbers: TStrings);
begin
  FFieldNumbers.Assign(FieldNumbers);
end;

procedure TFMFinder.SetDisplayFields(DisplayFields: TStrings);
begin
  FDisplayFields.Assign(DisplayFields);
end;

procedure TFMFinder.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

procedure TFMFinder.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

procedure TFMFinder.GetFinderList(target: TStrings);
begin
  FResults.Clear;
  if target <> nil then target.Clear;
  GoGetList(target);
end;

procedure TFMFinder.GoGetList(target: TStrings);
begin
  FMore := False;
  ErrorList.Clear;
  try
    if BrokerOK(Self) and SetBrokerInfo then begin
      RPCBroker.Call;
      ParseResults(RPCBroker.Results, target);
      ParseHelpErrors(RPCBroker);
      end
    else
      RPCBroker.ClearParameters := True;
  except
    raise;
  end;
end;

function TFMFinder.SetBrokerInfo: Boolean;
var
  sfld : string;
  i    : integer;
begin
  FFlags := '';
  FOptions := '';
  Result := False;
  if PropertyOK(Self) then begin
    Result := True;
    for i := 0 to (FFieldNumbers.Count - 1) do
      if FFieldNumbers[i] <> '' then
        sfld := sfld + FFieldNumbers[i] + ';';
    RPCBroker.RemoteProcedure := 'DDR FINDER';
    RPCBroker.RPCVersion := '1';
    {set up DDR array}
    with RPCBroker.Param[0] do begin
      Ptype  := list;
      Mult['"FILE"']   := FFileNumber;
      Mult['"FIELDS"'] := sfld;
      Mult['"VALUE"']  := FValue;
      if (fnfAllowNumeric in FinderFlags) then FFlags := FFlags + 'A';
      if (fnfMultipleIndex in FinderFlags) then FFlags := FFlags + 'M';
      if (fnfOnlyExact in FinderFlags) then FFlags := FFlags + 'O';
      if (fnfQuickLookup in FinderFlags) then FFlags := FFlags + 'Q';
      if (fnfXactMatch in FinderFlags) then FFlags := FFlags + 'X';
      if FFlags <> '' then Mult['"FLAGS"'] := FFlags;
      if FScreen <> '' then Mult['"SCREEN"'] := FScreen;
      if FFMIndex <> '' then Mult['"XREF"'] := FFMIndex;
      if FIdentifier <> '' then begin
        Mult['"ID"'] := FIdentifier;
        FOptions := FOptions + 'WID';
        end;
      if (foReturnWriteIDs in FFinderOptions) and (Pos(FOptions, 'WID')=0) then
        FOptions := FOptions + 'WID';
      if FOptions <> '' then Mult['"OPTIONS"'] := FOptions;
      if FIENS <> '' then Mult['"IENS"'] := FIENS;
      if FNumber <> '' then Mult['"MAX"'] := FNumber;
      end;
  end;
end;

procedure TFMFinder.ParseResults(source, target: TStrings);
var
  i, cnt: integer;
  x: String;
  RecObj : TFMRecordObj;
begin
  if source.count = 0 then exit;
  //get FFldCnt - number of fields returned per record
  FFLDCnt := 0;
  i := Source.IndexOf('BEGIN_IDVALUES');
  if i <> -1 then begin
    inc(i);
    x := Source[i];
    FFLD := Piece(x, U, 1);
    FFLDCnt := StrToInt(Piece(x, U, 2));
    end;
  x := '';
  i := 0;
  cnt := 0;
  x := Source[i];
  if x = '[Misc]' then begin
    inc(i);
    x := Source[i];
    FMore := true;
    inc(i);
    x := Source[i];
    end;
  //(main loop is IENs nodes)
  i := Source.Indexof('BEGIN_IENs');
  if i = -1 then exit;
  while (x <> 'END_IENs') do begin
    inc(i);
    cnt := cnt+1;
    x := Source[i];
    if x = 'END_IENs' then break;
    RecObj := TFMRecordObj.Create;
    RecObj.IEN := x;
    if FFLDCnt > 0 then LoadFLDVal(Source, RecObj, cnt);
    FResults.AddObject(x, RecObj);
    if (Target <> nil) then Target.AddObject(DisplayData(RecObj), RecObj);
    end;
  if (source.IndexOf('BEGIN_WIDVALUES') <> -1) then LoadWIDVal(source);
end;

{This procedure should include processing of each record's IX nodes if requested}
procedure TFMFinder.LoadFLDVal(s: TStrings; var R: TFMRecordObj; c: integer);
var
  i, z : integer;
  x, fld : string;
  obj : TFMFieldObj;
begin
  i := S.IndexOf('BEGIN_IDVALUES');
  if i = -1 then exit;
  inc(i);
  i := i + (c*FFLDCnt) - FFLDCnt;
  z := 0;
  repeat
    inc(i);
    x := S[i];
    fld := Piece(FFLD, ';', z+1);
    if x = 'END_IDVALUES' then exit;
    obj := R.GetField(fld);
    if (obj = nil) then obj := TFMFieldObj.Create;
    obj.FMDBExternal := x;
    obj.FMField := fld;
    obj.IENS := R.IEN + ',' + FIENS;
    R.FMFLDValues.Addobject(fld , obj);
    inc(z);
  until z = FFLDCnt;
end;

procedure TFMFinder.LoadWIDVal(s: TStrings);
var
  i, z , y ,zien: integer;
  x, ien : string;
  recobj  : TFMRecordObj;
begin
  i := S.IndexOf('BEGIN_WIDVALUES');
  while (x <> 'END_WIDVALUES') do begin
    inc(i);
    x := S[i];
    if x = 'END_WIDVALUES' then break;
    if Piece(x, U, 1) = 'WID' then begin
      ien := Piece(x, U, 2);
      zien := FResults.IndexOf(ien);
      recobj := TFMRecordObj(FResults.Objects[zien]);
      z := StrtoInt(Piece(x, U, 3));
      y := 0;
      repeat
        inc(i);
        x := S[i];
        recobj.FMWIDValues.Add(x);
        inc(y);
      until y = z;
      end;
    end;
end;

function TFMFinder.DisplayData(s: TFMRecordObj): string;
var
  zfld, zitem, zval : string;
  i,ix : integer;
  z   : TObject;
begin
  zitem := '';
  for i := 0 to FDisplayFields.Count - 1 do begin
    zfld := FDisplayFields[i];
    ix := s.FMFLDValues.Indexof(zfld);
    if ix = -1 then continue;
    z := s.FMFLDValues.Objects[ix];
    if (z <> nil) and (z is TFMFieldObj) then zval := TFMFieldObj(z).FMDBExternal;
    zitem := zitem + zval + '    ';
    end;
  Result := Copy(zitem, 1, Length(zitem)-4);
end;

function TFMFinder.GetRecord(IEN: String): TFMRecordObj;
var
  z : TObject;
begin
  Result := nil;
  if (IEN <> '') and (FResults.IndexOf(IEN) <> -1) then begin
    z := FResults.Objects[FResults.IndexOf(IEN)];
    if (z <> nil) and (z is TFMRecordObj) then Result := TFMRecordObj(z);
    end;
end;

{*** TFMFindOne Component ***}

procedure TFMFindOne.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FRPCBroker) then
    FRPCBroker := nil;
end;

procedure TFMFindOne.SetIENS(IENS: string);
begin
  FIENS := FixIENS(IENS);
end;

function TFMFindOne.GetIEN: String;
begin
  Result := '';
  Errorlist.clear;
  try
    if SetBrokerInfo then begin
      RPCBroker.Call;
      Result := RPCBroker.Results[0];
      ParseHelpErrors(RPCBroker);
    end;
  except
    Result := ''; {error condition outside of M}
    raise;
  end;
end;

function TFMFindOne.SetBrokerInfo: Boolean;
begin
  FFlags := '';
  FOptions := '';
  Result := False;
  if BrokerOK(self) and PropertyOK(Self) then begin
    RPCBroker.RemoteProcedure := 'DDR FIND1';
    RPCBroker.RPCVersion := '1';
    with RPCBroker.Param[0] do begin
      Ptype  := list;
      Mult['"FILE"']   := FFileNumber;
      Mult['"VALUE"']  := FValue;
      if FIENS <> '' then Mult['"IENS"'] := FIENS;
      if (fnfAllowNumeric in FinderFlags) then FFlags := FFlags + 'A';
      if (fnfMultipleIndex in FinderFlags) then FFlags := FFlags + 'M';
      if (fnfOnlyExact in FinderFlags) then FFlags := FFlags + 'O';
      if (fnfQuickLookup in FinderFlags) then FFlags := FFlags + 'Q';
      if (fnfXactMatch in FinderFlags) then FFlags := FFlags + 'X';
      if (foRecall in FFindOneOptions) then FOptions := 'R';
      if FFlags <> '' then Mult['"FLAGS"'] := FFlags;
      if FScreen <> '' then Mult['"SCREEN"'] := FScreen;
      if FFMIndex <> '' then Mult['"XREF"'] := FFMIndex;
      if FOptions <> '' then Mult['"OPTIONS"'] := FOptions;
      end;
    Result := True;
    end;
end;

{***************  General ***************}

procedure Register;
begin
     RegisterComponents('FileMan', [TFMLister]);
     RegisterComponents('FileMan', [TFMGets]);
     RegisterComponents('FileMan', [TFMValidator]);
     RegisterComponents('FileMan', [TFMFiler]);
     RegisterComponents('FileMan', [TFMHelp]);
     RegisterComponents('FileMan', [TFMFinder]);
     RegisterComponents('FileMan', [TFMFindOne]);
end;

end.
