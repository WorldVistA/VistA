unit UNewPersonParams;
////////////////////////////////////////////////////////////////////////////////
// ORNEWPERS NEWPERSON parameters
// FROM       Starting position of the index [IEN for similar provider]
// DIR        Direction to search index [default=1, -1=reverse]
// KEY        Name of SECURITY KEY that must be assigned to the user
// DATE       FileMan format, used when evaluating termination date, person
//            class, ASU user class, and co-signer evaluation
// RDV        Allow visitors, uses "B" index [boolean, default=0]
// ALL        Allow disabled & terminated users, uses "B" index [boolean,
//            default=0]
// PDMP       User must have PDMP authorization [boolean, default=0]
// SPN        Perform similar provider name lookup [boolean, default=0]
// EXC        Use OR CPRS USER CLASS EXCLUDE [boolean, default=0]
// NVAP       Include non-VA Providers [boolean, default=1]
// DFC        Perform default co-signer lookup [boolean, default=0]
// TIUDA      IEN of document File #8925, used for co-signer evaluation
// TYPE       IEN of document definition #8925.1, used for co-signer
//            evaluation
// HELP       Returns remote procedure help [boolean, default=1]
////////////////////////////////////////////////////////////////////////////////

interface
uses
  ORCtrls,
  ORNetIntf;

type
  TIncludeNonVAProviders = (nvaTrue, nvaFalse, nvaCalculate);

  TNewPersonParams = class(TObject)
  strict private
    FORComboBox: TORComboBox;
    FIncludeNonVAProviders: TIncludeNonVAProviders;
    FFrom: string;
    FDirection: Integer;
    FKey: string;
    FDate: string;
    FRDV: Integer;
    FALL: Integer;
    FPDMP: Integer;
    FPerformSimilarProviderLookup: Integer;
    FExcludeClass: Integer;
    FDefaultCosigner: Integer;
    FTIUDA: Int64;
    FDOCIEN: Int64;
    FHELP: Integer;
    function GetIncludeNonVAProviders: Integer;
  strict protected
    property IncludeNonVAProviders: Integer read GetIncludeNonVAProviders;
  public
    constructor Create(AORComboBox: TORComboBox;
      AIncludeNonVAProviders: TIncludeNonVAProviders = nvaCalculate);
    property From: string read FFrom write FFrom;
    property Direction: Integer read FDirection write FDirection;
    property Key: string read FKey write FKey;
    property Date: string read FDate write FDate;
    property RDV: Integer read FRDV write FRDV;
    property ALL: Integer read FALL write FALL;
    property PDMP: Integer read FPDMP write FPDMP;
    property PerformSimilarProviderLookup: Integer
      read FPerformSimilarProviderLookup write FPerformSimilarProviderLookup;
    property ExcludeClass: Integer read FExcludeClass write FExcludeClass;
    property DefaultCosigner: Integer read FDefaultCosigner
      write FDefaultCosigner;
    property TIUDA: Int64 read FTIUDA write FTIUDA;
    property DOCIEN: Int64 read FDOCIEN write FDOCIEN;
    property HELP: Integer read FHELP write FHELP;

    function CreateORNetMult: IORNetMult;
  end;

implementation

uses
  uMisc,
  ORCheckComboBox,
  System.SysUtils;

constructor TNewPersonParams.Create(AORComboBox: TORComboBox;
  AIncludeNonVAProviders: TIncludeNonVAProviders = nvaCalculate);
begin
  inherited Create;
  if not Assigned(AORComboBox) then
      raise Exception.Create('AORComboBox not assigned');
  FORComboBox := AORComboBox;
  FIncludeNonVAProviders := AIncludeNonVAProviders;
  FDirection := 1;
  FTIUDA := -1;
  FDOCIEN := -1;
end;

function TNewPersonParams.CreateORNetMult: IORNetMult;
begin
  NewORNetMult(Result);
  Result.AddSubscript('FROM', FFrom);
  Result.AddSubscript('DIR',  FDirection);
  if Trim(FKEY) <> '' then
    Result.AddSubscript('KEY',FKey);
  if Trim(FDATE) <> '' then
    Result.AddSubscript('DATE', FDate);
  Result.AddSubscript('RDV',  FRDV);
  Result.AddSubscript('ALL',  FALL);
  Result.AddSubscript('PDMP', FPDMP);
  Result.AddSubscript('SPN',  FPerformSimilarProviderLookup);
  Result.AddSubscript('EXC',  FExcludeClass);
  if uMisc.IsNonVAProvidersFeatureEnabled then
      Result.AddSubscript('NVAP', IncludeNonVAProviders);
  Result.AddSubscript('DFC',  FDefaultCosigner);
  if FTIUDA >= 0 then
    Result.AddSubscript('TIUDA', FTIUDA);
  if FDOCIEN >= 0 then
    Result.AddSubscript('TYPE', FDOCIEN);
  Result.AddSubscript('HELP', FHelp);
end;

function TNewPersonParams.GetIncludeNonVAProviders: Integer;
begin
  case FIncludeNonVAProviders of
    nvaTrue: Exit(True.ToInteger);
    nvaFalse: Exit(False.ToInteger);
  else
    begin
      if not(FORComboBox is TORCheckComboBox) then Exit(False.ToInteger);
      if not TORCheckComboBox(FORComboBox).MainCheckBoxVisible then
          Exit(False.ToInteger);
      Result := TORCheckComboBox(FORComboBox).MainCheckBoxChecked.ToInteger;
    end;
  end;
end;

end.
