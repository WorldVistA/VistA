unit uGMV_Patient;

interface
uses
  Classes, StdCtrls,ExtCtrls
  ;

type
  TMessageLevel = (mlError, mlInfo, mlWarning, mlSecurity);

type
  TPatient = class(TObject)
  private
    FDFN: string;
    FIdentifiers: TList;
    FMessages: TList;
    FSensitive: Boolean;

    FSex,
    FDOB,
    FName,
    FSSN,
    FAge:String;

    FLocationName:String;
    FLocationID:String;

    procedure SetSensitive(NewVal: Boolean);
  public
    constructor Create;
    constructor CreatePatientByDFN(aDFN:String);
    destructor Destroy; override;
//  published
    property DFN: string              read FDFN write FDFN;
    property Identifiers: TList       read FIdentifiers write FIdentifiers;
    property Messages: TList          read FMessages write FMessages;
    property Sensitive: Boolean       read FSensitive write SetSensitive;

    property Name: String             read FName;
    property SSN: String              read FSSN;
    property Age: String              read FAge;
    property DOB: String              read FDOB;
    property LocationName: String     read FLocationName;
    property LocationID: String       read FLocationID;
  end;

type
  TPtIdentifier = class(TObject)
  private
    FCaption: string;
    FDisplayNonSensitive: string;
    FDisplaySensitive: string;
    FDisplayLabel: TLabel;
  public
    constructor Create;
    destructor Destroy; override;
 // published
    property Caption: string
      read FCaption write FCaption;
    property DisplayNonSensitive: string
      read FDisplayNonSensitive write FDisplayNonSensitive;
    property DisplaySensitive: string
      read FDisplaySensitive write FDisplaySensitive;
    property DisplayLabel: TLabel
      read FDisplayLabel write FDisplayLabel;
  end;

type
  TPtMessage = class(TObject)
  protected
    FLevel: TMessageLevel;
    FHeader: string;
    FText: TStringList;
    FPanel: TPanel;
  public
    constructor Create(Level: TMessageLevel; HeaderText: string);
    destructor Destroy; override;
    property MessageLevel: TMessageLevel
      read FLevel write FLevel;
    property Header: string
      read FHeader write FHeader;
    property Text: TStringList
      read FText write FText;
    property Panel: TPanel
      read FPanel write FPanel;
  end;

implementation

uses
  SysUtils
  , uGMV_Common
  , uGMV_Utils
  , uGMV_Engine;

//* TPtMessage *//

constructor TPtMessage.Create(Level: TMessageLevel; HeaderText: string);
begin
  FText := TStringList.Create;
  FLevel := Level;
  FHeader := HeaderText;
end;

destructor TPtMessage.Destroy;
begin
  FText.Clear;
  FText.free;
end;

//* TPtIdentifier *//

constructor TPtIdentifier.Create;
begin
  inherited Create;
end;

destructor TPtIdentifier.Destroy;
begin
  inherited Destroy;
end;

//* TPatient *//

constructor TPatient.Create;
begin
  inherited Create;
  FIdentifiers := TList.Create;
  FMessages := TList.Create;
end;

constructor TPatient.CreatePatientByDFN(aDFN:String);
var
  i: Integer;
  PtID: TPtIdentifier;
  PtMsg: TPtMessage;
  S: String;
  SL: TStringList;

begin
  inherited Create;
  FIdentifiers := TList.Create;
  FMessages := TList.Create;
  Sensitive := False;
  SL := getPatientInfo(aDFN);
  try
    {Build the Patient Identifiers}
    i := 0;
    while i < SL.Count do
      begin
        s := SL[i];
        if Piece(s, '^', 1) = '$$PTID' then
          begin
            PtId := TPtIdentifier.Create;
            PtId.Caption := TitleCase(Piece(s, '^', 2));
            PtId.DisplayNonSensitive := Piece(s, '^', 3);
            PtId.DisplaySensitive := Piece(s, '^', 4);
            if PtId.DisplaySensitive = '' then
              PtId.DisplaySensitive := PtId.DisplayNonSensitive;

            if PtId.Caption = 'Sex' then              FSex := PtId.DisplayNonSensitive;
            if PtId.Caption = 'Name' then             FName := PtId.DisplayNonSensitive;
            if PtId.FCaption = 'Social Security Number' then  FSSN := PtId.DisplayNonSensitive;
            if PtId.Caption = 'Date Of Birth' then
              begin
                FAge := PtId.DisplayNonSensitive;
                FDOB := PtId.DisplaySensitive;
              end;

            if PtId.Caption = 'Ward Location' then  // 050104 zzzzzzandria
              begin
                FLocationName := PtId.DisplayNonSensitive;
                FLocationID := Piece(s,'^',4);
                // zzzzzzandria 2008-02-27 -------------------------------------
                if FLocationID = '' then
                  begin
                    s := getHospitalLocationByID(aDFN);
                    if s <> '' then
                      FLocationID := s;
                  end;
                // zzzzzzandria 2008-02-27 -------------------------------------
              end;

            FIdentifiers.Add(ptId);
          end;
        inc(i);
      end;
    {Load any messages}
    i := 0;
    while i < SL.Count - 1 do
      begin
        if Piece(SL[i], '^', 1) = '$$MSGHDR' then
          begin
            case StrToIntDef(Piece(SL[i], '^', 2), -1) of
              0: PtMsg := TPtMessage.Create(mlError, Piece(SL[i], '^', 3));
              1: PtMsg := TPtMessage.Create(mlInfo, Piece(SL[i], '^', 3));
              2: PtMsg := TPtMessage.Create(mlWarning, Piece(SL[i], '^', 3));
              3:
                begin
                  PtMsg := TPtMessage.Create(mlSecurity, Piece(SL[i], '^', 3));
                  Sensitive := True;
                end;
            else
              PtMsg := TPtMessage.Create(mlInfo, Piece(SL[i], '^', 3));
            end;

            inc(i);

            while (i < SL.Count - 1) and
              (Piece(SL[i], '^', 1) <> '$$MSGEND') do
              begin
                ptMsg.Text.Add(SL[i]);
                inc(i);
              end;
            FMessages.Add(PtMsg);
          end;
        inc(i);
      end;

    except
    end;
  SL.Free;
end;

destructor TPatient.Destroy;
begin

  while FIdentifiers.Count > 0 do
    begin
      TPtIdentifier(FIdentifiers[0]).free;
      FIdentifiers.Delete(0);
    end;
  FIdentifiers.free;

  while FMessages.Count > 0 do
    begin
      TPtMessage(FMessages[0]).free;
      FMessages.Delete(0);
    end;
  FMessages.free;

  inherited Destroy;
end;

procedure TPatient.SetSensitive(NewVal: Boolean);
var
  i: Integer;
begin
  FSensitive := NewVal;
  for i := 0 to Self.FIdentifiers.Count - 1 do
    with TPtIdentifier(Self.FIdentifiers[i]) do
      case NewVal of
        True: DisplayLabel.Caption := DisplaySensitive;
        False: DisplayLabel.Caption := DisplayNonSensitive;
      end;
end;


end.
