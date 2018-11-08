unit uTIU;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls, Controls;

type

  TEditNoteRec = record
    DocType: Integer;
    IsNewNote: boolean;
    Title: Integer;
    TitleName: string;
    DateTime: TFMDateTime;
    Author: Int64;
    AuthorName: string;
    Cosigner: Int64;
    CosignerName: string;
    Subject: string;
    Location: Integer;
    LocationName: string;
    VisitDate: TFMDateTime;
    PkgRef: string;      // 'IEN;GMR(123,' or 'IEN;SRF('
    PkgIEN: integer;     // file IEN
    PkgPtr: string;      // 'GMR(123,' or 'SRF(' 
    NeedCPT: Boolean;
    Addend: Integer;
    LastCosigner: Int64;
    LastCosignerName: string;
    IDParent: integer;
    ClinProcSummCode: integer;
    ClinProcDateTime: TFMDateTime;
    Lines: TStrings;
    PRF_IEN: integer;
    ActionIEN: string;
  end;

  TNoteRec = TEditNoteRec;

  TActionRec = record
    Success: Boolean;
    Reason: string;
  end;

  TCreatedDoc = record
    IEN: Integer;
    ErrorText: string;
  end;

  TTIUContext = record
    Changed: Boolean;
    BeginDate: string;
    EndDate: string;
    FMBeginDate: TFMDateTime;
    FMEndDate: TFMDateTime;
    Status: string;
    Author: int64;
    MaxDocs: integer;
    ShowSubject: Boolean;
    SortBy: string;
    ListAscending: Boolean;
    GroupBy: string;
    TreeAscending: Boolean;
    SearchField: string;
    KeyWord: string;
    Filtered: Boolean;
    SearchString: String;  // Text Search CQ: HDS00002856
  end ;

  TNoteTitles = class
    DfltTitle: Integer;
    DfltTitleName: string;
    ShortList: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TTIUPrefs = class
    DfltLoc: Integer;
    DfltLocName: string;
    SortAscending: Boolean;
    SortBy: string;    // D,R,S,A
    AskNoteSubject: Boolean;
    AskCosigner: Boolean;
    DfltCosigner: Int64;
    DfltCosignerName: string;
    MaxNotes: Integer;
  end;

//  notes tab specific procedures
function MakeNoteDisplayText(RawText: string): string;
function MakeConsultDisplayText(RawText:string): string;
function SetLinesTo74ForSave(AStrings: TStrings; AParent: TWinControl): TStrings;

const
  TX_SAVE_ERROR1 = 'An error was encountered while trying to save the note you are editing.' + CRLF + CRLF + '    Error:  ';
  TX_SAVE_ERROR2 = CRLF + CRLF + 'Please try again now using CTRL-SHIFT-S, or ''Save without signature''.' + CRLF +
                   'These actions will improve the likelihood that no text will be lost.' + CRLF + CRLF +
                   'If problems continue, or network connectivity is lost, please copy all of your text to' + CRLF +
                   'the clipboard and paste it into Microsoft Word before continuing or before closing CPRS.';
  TC_SAVE_ERROR =  'Error saving note text';

implementation

function MakeConsultDisplayText(RawText:string): string;
var
 x: string;
begin
   x := RawText;
   Result := Piece(x, U, 2) + ',' + Piece(x, U, 3) + ',' +
             Piece(x, U, 4) + ', '+ Piece(x, U, 5);

end;

function MakeNoteDisplayText(RawText: string): string;
var
  x: string;
begin
  x := RawText;
  if Piece(x, U, 1) = '' then
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) + '  ' +
        Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2)
  else if CharInSet(Piece(x, U, 1)[1], ['A', 'N', 'E']) then
    Result := Piece(x, U, 2)
  else
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) + '  ' +
              Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2);
end;


{ Progress Note Titles  -------------------------------------------------------------------- }
constructor TNoteTitles.Create;
{ creates an object to store progress note titles so only obtained from server once }
begin
  inherited Create;
  ShortList := TStringList.Create;
end;

destructor TNoteTitles.Destroy;
{ frees the lists that were used to store the progress note titles }
begin
  ShortList.Free;
  inherited Destroy;
end;

function SetLinesTo74ForSave(AStrings: TStrings; AParent: TWinControl): TStrings;
var
  ARichEdit74: TRichEdit;
begin
  Result := AStrings;
  ARichEdit74 := TRichEdit.Create(AParent);
  try
    ARichEdit74.Parent := AParent;
    ARichEdit74.Lines.Text := AStrings.Text;
    ARichEdit74.Width := 525;
    Result.Text := ARichEdit74.Lines.Text;
    //QuickCopy(ARichEdit74, Result);
  finally
    ARichEdit74.Free;
  end;
end;

end.
