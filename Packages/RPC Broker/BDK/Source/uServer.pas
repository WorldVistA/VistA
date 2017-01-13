unit uServer;

interface

type
  TServerEntry = class(TObject)
  private
    fTitle: string;
    fDNS: string;
    fPort: integer;
  protected
  public
    property Title: string read fTitle write fTitle;
    property DNS: string read fDNS write fDNS;
    property Port: integer read fPort write fPort;
    constructor Create(ATitle: string = ''; ADNS: string = 'BROKERSERVER'; APort: integer = 9200);
    destructor Destroy; override;
  end;

  TServerEntryList = class(TObject)
  private
    function GetByDNS(ADNS: string): TServerEntry;
    function GetByTitle(ATitle: string): TServerEntry;
    procedure SetByDNS(ADNS: string; const Value: TServerEntry);
    procedure SetByTitle(ATitle: string; const Value: TServerEntry);
  protected
    function GetByIdx(AnIdx: integer): TServerEntry;
    procedure SetByIdx(AnIdx: integer; const Value: TServerEntry);
  public
    property ByIdx[AnIdx: integer]: TServerEntry read GetByIdx write SetByIdx;
    property ByDNS[ADNS: string]: TServerEntry read GetByDNS write SetByDNS;
    property ByTitle[ATitle: string]: TServerEntry read GetByTitle write SetByTitle;
    constructor Create;
    destructor Destroy; override;
    function FindIdx(AnEntry: TServerEntry): integer;
    function FindTitle(ATitle: string): integer;
    function FindDNS(ADNS: string): integer;
    procedure PopulateFromHostFile;
    procedure PopulateFromRegistry;
    procedure PopulateByApplication(AnApplication: string);
    procedure WriteToHostFile;
    procedure WriteToRegistry;
  end;


implementation

{ TServerEntryList }

constructor TServerEntryList.Create;
begin

end;

destructor TServerEntryList.Destroy;
begin

  inherited;
end;

function TServerEntryList.FindDNS(ADNS: string): integer;
begin

end;

function TServerEntryList.FindIdx(AnEntry: TServerEntry): integer;
begin

end;

function TServerEntryList.FindTitle(ATitle: string): integer;
begin

end;

function TServerEntryList.GetByDNS(ADNS: string): TServerEntry;
begin

end;

function TServerEntryList.GetByIdx(AnIdx: integer): TServerEntry;
begin

end;

function TServerEntryList.GetByTitle(ATitle: string): TServerEntry;
begin

end;

procedure TServerEntryList.PopulateByApplication(AnApplication: string);
begin

end;

procedure TServerEntryList.PopulateFromHostFile;
begin

end;

procedure TServerEntryList.PopulateFromRegistry;
begin

end;

procedure TServerEntryList.SetByDNS(ADNS: string; const Value: TServerEntry);
begin

end;

procedure TServerEntryList.SetByIdx(AnIdx: integer; const Value: TServerEntry);
begin

end;

procedure TServerEntryList.SetByTitle(ATitle: string; const Value: TServerEntry);
begin

end;

{ TServerEntry }

constructor TServerEntry.Create(ATitle, ADNS: string; APort: integer);
begin

end;

destructor TServerEntry.Destroy;
begin

  inherited;
end;

end.
