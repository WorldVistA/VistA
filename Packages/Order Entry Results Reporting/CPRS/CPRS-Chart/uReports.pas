unit uReports;

interface

uses ORExtensions, sysutils, classes, ORFN, ComCtrls, Forms, Graphics;

type

TCellObject = class          //Data Object for each Cell in ListView
  private
    FName     : string;      //Column Name
    FSite     : string;      //Site (#;name)
    FInclude  : string;      //Set if data is to be included in detailed report
    FTextType : string;      //Type of data (WP)
    FVisible  : string;      //Set if column property is visible
    FHandle   : string;      //Row:Col identifier
    FDataType : string;      //Data Type of data in column (null or 0:freetext, 1:integer, 2:datetime)
    FData     : TStringList; //Data for this field (could be WP)
    FCount    : integer;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ASite, AHandle, AColumnData: string; AData: TStringList);
    property Name       :string read FName write FName;
    property Site       :string read FSite write FSite;
    property Include    :string read FInclude write FInclude;
    property TextType   :string read FTextType write FTextType;
    property Visible    :string read FVisible write FVisible;
    property Handle     :string read FHandle write FHandle;
    property DataType   :string read FDataType write FDatatype;
    property Data       :TStringList read FData write FData;
    property Count      :integer read FCount write FCount;
  end;

TRowObject = class           //List of Row objects for ReportsTab ListView
  private
    FCount     :integer;
    FColumnList:TList;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Add(ASite, AHandle, AColumnData: string; AData: TStringList);
    procedure   Clear;
    property    Count           :integer     read FCount;
    property    ColumnList      :TList       read FColumnList;
  end;

TLabRowObject = class           //List of Row objects for Labs Tab ListView
  private
    FCount     :integer;
    FColumnList:TList;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Add(ASite, AHandle, AColumnData: string; AData: TStringList);
    procedure   Clear;
    property    Count           :integer     read FCount;
    property    ColumnList      :TList       read FColumnList;
  end;

type
  PReportTreeObject = ^TReportTreeObject;
  TReportTreeObject = Record
    ID         : String;         //Report ID           ID:Text => when passed to broker add: ;Remote~uHState
    Heading    : String;         //Report Heading
    Qualifier  : String;         //Report Qualifier
    Remote     : String;         //Remote Data Capable
    RptType    : String;         //Report Type
    Category   : String;         //Report Category
    RPCName    : String;         //Associated RPC
    IFN        : String;         //IFN of report in file 101.24
    HSTAG      : String;         //Report extract      tag;routine;component #
    SortOrder  : String;         //#:# of columns to use in a multi-column sort
    MaxDaysBack: String;         //Maximum number of Days allowed for report
    Direct     : String;         //Direct Remote Call flag
    HDR        : String;         //HDR is data source if = 1
    FHIE       : String;         //FHIE is data source if = 1
    FHIEONLY   : String;         //FHIEONLY if data is to only include FHIE
    procedure Clear;
end;

type
  PProcTreeObj = ^TProcedureTreeObject;
  TProcedureTreeObject = Record
    ParentName   : String;      //Parent procedure name for exam/print sets
    ProcedureName: String;      //Same as ParentName for stand-alone procedures
    MemberOfSet  : String;      //1 = descendant procedures have individual reports
                                //2 = descendant procedures have one shared report
    ExamDtTm   : String;        //Exam Date Time
    Associate  : Integer;       //Index of the associated TListItem in the lvReports
end;

var
  RowObjects: TRowObject;
  LabRowObjects: TLabRowObject;

//procedures & functions for Report Tree & ListView objects

function MakeReportTreeObject(x: string): PReportTreeObject;
function IsValidNumber(S: string; var V: extended): boolean;
function StringToFMDateTime(Str: string): TFMDateTime;
function ShortDateStrToDate(shortdate: string): string ;
function StripSpace(str:string):string;
function MakeProcedureTreeObject(x: string): PProcTreeObj;
function MakePrntProcTreeObject(x: string): PProcTreeObj;

//procedures & functions for Report Fonts

procedure ReportTextFontChange(Self, Sender: TObject);
function CreateReportTextComponent(ParentForm: TForm): ORExtensions.TRichEdit;


implementation

const
  Months: array[1..12] of String = ('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');

constructor TCellObject.Create;

begin
  FData := TStringList.Create;
end;

destructor TCellObject.Destroy;
begin
  FData.Free;
end;

procedure TCellObject.Add(ASite, AHandle, AColumnData: string; AData: TStringList);

begin
  FName := piece(AColumnData,'^',1);
  FSite := ASite;
  FInclude := piece(AColumnData,'^',5);
  FTextType := piece(AColumnData,'^',4);
  FVisible := piece(AColumnData,'^',2);
  FDataType := piece(AColumnData,'^',9);
  FHandle := AHandle;
  FCount := AData.Count;
  FastAssign(AData, FData);
end;

function MakeReportTreeObject(x: string): PReportTreeObject;
var
  AnObject: PReportTreeObject;
begin
  //x=id^Name^Qualifier^HSTag;Routine^Entry^Routine^Remote^Type^Category^RPC^ifn^SortOrder^MaxDaysBack^Direct^HDR^FHIE
  New(AnObject);
  with AnObject^ do
    begin
      ID              := UpperCase(Piece(x, U, 1)) + ':' + UpperCase(Piece(x, U, 2));
      Heading         := Piece(x, U, 2);
      Qualifier       := Piece(x, U, 3);
      Remote          := Piece(x, U, 7);
      RptType         := Piece(x, U, 8);
      Category        := Piece(x, U, 9);
      RPCName         := UpperCase(Piece(x, U, 10));
      IFN             := Piece(x, U, 11);
      HSTag           := UpperCase(Piece(x, U, 4));
      SortOrder       := Piece(x, U, 12);
      MaxDaysBack     := Piece(x, U, 13);
      Direct          := Piece(x, U, 14);
      HDR             := Piece(x, U, 15);
      FHIE            := Piece(x, U, 16);
      FHIEONLY        := Piece(x, U, 17);
    end;
  Result := AnObject;
end;

constructor TRowObject.Create;
begin
  FColumnList := TList.Create;
  FCount := 0;
end;

destructor TRowObject.Destroy;
begin
  Clear;
  FColumnList.Free;
  inherited Destroy;
end;

procedure TRowObject.Add(ASite, AHandle, AColumnData: string; AData: TStringList);
var
  ACell: TCellObject;
begin
  ACell := TCellObject.Create;
  ACell.Add(ASite,AHandle,AColumnData,AData);
  FColumnList.Add(ACell);
  FCount := FColumnList.Count;
end;

procedure TRowObject.Clear;
var
  i: Integer;
begin
  with FColumnList do
    for i := 0 to Count - 1 do
      if assigned(Items[i]) then
        TCellObject(Items[i]).Free;
  FColumnList.Clear;
  FCount := 0;
end;

constructor TLabRowObject.Create;
begin
  FColumnList := TList.Create;
  FCount := 0;
end;

destructor TLabRowObject.Destroy;
begin
  Clear;
  FColumnList.Free;
  inherited Destroy;
end;

procedure TLabRowObject.Add(ASite, AHandle, AColumnData: string; AData: TStringList);
var
  ACell: TCellObject;
begin
  ACell := TCellObject.Create;
  ACell.Add(ASite,AHandle,AColumnData,AData);
  FColumnList.Add(ACell);
  FCount := FColumnList.Count;
end;

procedure TLabRowObject.Clear;
var
  i: Integer;
begin
  with FColumnList do
    for i := 0 to Count - 1 do
      if assigned(Items[i]) then
        TCellObject(Items[i]).Free;
  FColumnList.Clear;
  FCount := 0;
end;

function IsValidNumber(S: string; var V: extended): boolean;
var
  NumCode: integer;
  FirstSpace: integer;
begin
  FirstSpace := Pos(' ', S);
  if FirstSpace > 0 then
    S := Copy(S, 1, FirstSpace - 1);
  Val(S, V, NumCode);
  Result := (NumCode = 0);
  if not Result then
  begin
      // Remove thousands seperators
    S := StringReplace(S, FormatSettings.ThousandSeparator, '', [rfReplaceAll]);
      // change DecimalSeperator to '.' because Val only recognizes that, not
      // the locale specific decimal char... then try again.  Stupid Val.
    S := StringReplace(S, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]);
    Val(S, V, NumCode);
    Result := (NumCode = 0);
  end;
end;

function StringToFMDateTime(Str: string): TFMDateTime;
var
  mm,dd,yy,hh: integer;
  day,time,hr,min: string;
begin
  day := piece(str,' ',1);
  time := piece(str,' ',2);
  hh := 0;
  if length(time) > 0 then
    begin
      hr := piece(time,':',1);
      if Copy(hr,1,1) = '0' then hr := Copy(hr,2,1);
      if Copy(hr,1,1) = '0' then hr := '';
      min := piece(time,':',2);
      if Copy(min,1,1) = '0' then min := Copy(min,2,1);
      if Copy(min,1,1) = '0' then min := '';
      hh := StrToIntDef(hr + min,0);
    end;
  mm := StrToIntDef(piece(day,'/',1),0);
  dd := StrToIntDef(piece(day,'/',2),0);
  yy := StrToIntDef(piece(day,'/',3),0) - 1700;
  Result := (yy * 10000) + (mm * 100) + dd + (hh/10000);
end;

function ShortDateStrToDate(shortdate: string): string ;
{Converts date in format 'mmm dd,yy' or 'mmm dd,yyyy' to standard 'mm/dd/yy'}
var
  month,day,year: string ;
  i: integer ;
begin
  result := 'ERROR' ;
  if (Pos(' ',shortdate) <> 4) or ((Pos(',',shortdate) <> 7) and (Pos(',',shortdate) <> 6)) then exit ;  {no spaces or comma}
  for i := 1 to 12 do
    if Months[i] = UpperCase(Copy(shortdate,1,3)) then month := IntToStr(i);
  if month = '' then exit ;    {invalid month name}
  if length(month) = 1 then month := '0' + month;
  if Pos(',',shortdate) = 7 then
    begin
      day  := IntToStr(StrToInt(Copy(shortdate,5,2))) ;
      year := IntToStr(StrToInt(Copy(shortdate,8,99))) ;
    end;
  if Pos(',',shortdate) = 6 then
    begin
      day  := '0' + IntToStr(StrToInt(Copy(shortdate,5,1))) ;
      year := IntToStr(StrToInt(Copy(shortdate,7,99))) ;
    end;
  result := month+'/'+day+'/'+year ;
end ;

function StripSpace(str: string): string;
var
  i,j: integer;
begin
  i := 1;
  j := length(str);
  while str[i] = #32 do inc(i);
  while str[j] = #32 do dec(j);
  result := copy(str, i, j-i+1);
end;

function MakeProcedureTreeObject(x: string): PProcTreeObj;
var
  AnObject: PProcTreeObj;
begin
  New(AnObject);
  with AnObject^ do
    begin
      ParentName := Piece(x, U, 11);
      ProcedureName := Piece(x, U, 4);
      MemberOfSet := Piece(x, U, 10);
      ExamDtTm := Piece(x, U, 2);
      Associate := -1;
    end;
  Result := AnObject;
end;

function MakePrntProcTreeObject(x: string): PProcTreeObj;
var
  AnObject: PProcTreeObj;
begin
  New(AnObject);
  with AnObject^ do
    begin
      ParentName := Piece(x, U, 11);
      ExamDtTm := Piece(x, U, 2);
      Associate := -1;
    end;
  Result := AnObject;
end;

procedure ReportTextFontChange(Self, Sender: TObject);
begin
  TFont(Sender).Size := 8;
end;

// CQ#70295
function CreateReportTextComponent(ParentForm: TForm): ORExtensions.TRichEdit;
var
  m: TMethod;
begin
  Result := ORExtensions.TRichEdit.Create(ParentForm);
  with Result do
  begin
    Parent := ParentForm;
    Visible := False;
    Width := 600;
    Font.Name := 'Courier New';
    Font.Size := 8;
    m.Code := @ReportTextFontChange;
    m.Data := ParentForm;
    Font.OnChange := TNotifyEvent(m);
  end;
end;

{ TReportTreeObject }

procedure TReportTreeObject.Clear;
begin
  ID := '';
  Heading := '';
  Qualifier := '';
  Remote := '';
  RptType := '';
  Category := '';
  RPCName := '';
  IFN := '';
  HSTAG := '';
  SortOrder := '';
  MaxDaysBack := '';
  Direct := '';
  HDR := '';
  FHIE := '';
  FHIEONLY := '';
  inherited;
end;

end.
