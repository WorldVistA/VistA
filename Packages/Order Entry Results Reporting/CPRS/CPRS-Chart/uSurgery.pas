unit uSurgery;

interface

uses
  SysUtils, Windows, Messages, Controls, Classes, StdCtrls, ORfn, dialogs;

type
  TSurgeryTitles = class
    ClassName: string;
    DfltTitle: Integer;
    DfltTitleName: string;
    ShortList: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

function  MakeSurgeryCaseDisplayText(InputString: string): string;
function  MakeSurgeryReportDisplayText(RawText: string): string;
//procedure DisplayOpTop(ANoteIEN: integer);

const
(*  SG_ALL        = 1;                             // Case context - all cases
  SG_BY_SURGEON = 2;                             // Case context - all cases by surgeon
  SG_BY_DATE    = 3;                             // Case context - all cases by date range*)

  SG_TV_TEXT = 'Surgery Cases';

  OP_TOP_NEVER_SHOW   = 0;
  OP_TOP_ALWAYS_SHOW  = 1;
  OP_TOP_ASK_TO_SHOW  = 2;

implementation

uses
  uConst, rSurgery, fRptBox;

constructor TSurgeryTitles.Create;
{ creates an object to store Surgery titles so only obtained from server once }
begin
  inherited Create;
  ShortList := TStringList.Create;
end;

destructor TSurgeryTitles.Destroy;
{ frees the lists that were used to store the Surgery titles }
begin
  ShortList.Free;
  inherited Destroy;
end;

function MakeSurgeryCaseDisplayText(InputString: string): string;
(*
CASE #^Operative Procedure^Date/Time of Operation^Surgeon^^^^^^^^^+^Context
*)
var
  x: string;
begin
  x := InputString;
  x := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) + '  ' + Piece(x, U, 2) +
       ', ' + Piece(Piece(x, U, 4), ';', 2) + ', ' + 'Case #: ' + Piece(x, u, 1);
  Result := x;
end;

function MakeSurgeryReportDisplayText(RawText: string): string;
var
  x: string;
begin
  x := RawText;
  x := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) + '  ' + Piece(x, U, 2) +
       ' (#' + Piece(x, U, 1) + '), ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2);
  Result := x;
end;

(*procedure DisplayOpTop(ANoteIEN: integer);
const
{ TODO -oRich V. -cSurgery/TIU : What should be the text of the prompt for display OpTop on signature? }
  TX_OP_TOP_PROMPT = 'Would you like to first review the OpTop for this surgery report?';
var
  AList: TStringList;
  ACaseIEN: integer;
  IsNonORProc: boolean;
  ShouldShowOpTop: integer;
  x: string;
  ShowReport: boolean;
begin
  AList := TStringList.Create;
  try
    ShowReport := False;
    x := GetSurgCaseRefForNote(ANoteIEN);
    ACaseIEN := StrToIntDef(Piece(x, ';', 1), 0);
    ShouldShowOpTop := ShowOpTopOnSignature(ACaseIEN);
    case ShouldShowOpTop of
      OP_TOP_NEVER_SHOW   : ; // do nothing
      OP_TOP_ALWAYS_SHOW  : begin
                              x := GetSingleCaseListItemWithoutDocs(ANoteIEN);
                              IsNonORProc := IsNonORProcedure(ACaseIEN);
                              LoadOpTop(AList, ACaseIEN, IsNonORProc, ShowReport);
                              ReportBox(AList, MakeSurgeryCaseDisplayText(x), True);
                            end;
      OP_TOP_ASK_TO_SHOW  :   if InfoBox(TX_OP_TOP_PROMPT, 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
                                begin
                                  x := GetSingleCaseListItemWithoutDocs(ANoteIEN);
                                  IsNonORProc := IsNonORProcedure(ACaseIEN);
                                  LoadOpTop(AList, ACaseIEN, IsNonORProc, ShowReport);
                                  ReportBox(AList, MakeSurgeryCaseDisplayText(x), True);
                                end;
    end;
  finally
    AList.Free;
  end;
end;*)

end.
