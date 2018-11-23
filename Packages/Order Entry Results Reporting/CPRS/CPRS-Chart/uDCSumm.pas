{
  Most of Code is Public Domain.
  Date Formats modified by OSEHRA/Sam Habiel (OSE/SMH) for Plan VI (c) Sam Habiel 2018
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}
unit uDCSumm;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst;

type
  TEditDCSummRec = record
    Title: Integer;
    DocType: integer;
    Addend: integer;
    EditIEN: integer;
    AdmitDateTime: TFMDateTime;
    DischargeDateTime: TFMDateTime;
    TitleName: string;
    DictDateTime: TFMDateTime;
    Dictator: Int64;
    DictatorName: string;
    Cosigner: Int64;
    CosignerName: string;
    Transcriptionist: int64;
    TranscriptionistName: string;
    Attending: int64;
    AttendingName: string;
    Urgency: string;
    UrgencyName: string;
    Location: Integer;
    LocationName: string;
    VisitStr: string;
    NeedCPT: Boolean;
    Status: integer;       
    LastCosigner: Int64;
    LastCosignerName: string;
    IDParent: integer;
    Lines: TStrings;
  end;

  TDCSummRec = TEditDCSummRec;

  TAdmitRec = record
    AdmitDateTime: TFMDateTime;
    Location: integer;
    LocationName: string;
    VisitStr: string;
  end;

  TDCSummTitles = class
    DfltTitle: Integer;
    DfltTitleName: string;
    ShortList: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TDCSummPrefs = class
    DfltLoc: Integer;
    DfltLocName: string;
    SortAscending: Boolean;
    AskCosigner: Boolean;
    DfltCosigner: Int64;
    DfltCosignerName: string;
    MaxSumms: Integer;
  end;

function  MakeDCSummDisplayText(RawText: string): string;

implementation

function MakeDCSummDisplayText(RawText: string): string;
var
  x: string;
begin
  x := RawText;
  if Copy(Piece(x, U, 9), 1, 4) = '    ' then SetPiece(x, U, 9, 'Dis: ');
  if CharInSet(Piece(x, U, 1)[1], ['A', 'N', 'E']) then
    Result := Piece(x, U, 2)
  else
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) + '  ' +
              Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2) +
              '  (' + Piece(x,U,7) + '), ' + Piece(Piece(x, U, 8), ';', 1) + ', ' +
              Piece(Piece(x, U, 9), ';', 1);
end;

{ Discharge Summary Titles  -------------------------------------------------------------------- }

constructor TDCSummTitles.Create;
{ creates an object to store Discharge Summary titles so only obtained from server once }
begin
  inherited Create;
  ShortList := TStringList.Create;
end;

destructor TDCSummTitles.Destroy;
{ frees the lists that were used to store the Discharge Summary titles }
begin
  ShortList.Free;
  inherited Destroy;
end;

end.
