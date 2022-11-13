unit rOTH;
///
/// Unit contains routines that support Other Than Honorable functionality
///

interface

uses Classes;

function getOTHList(DFNStr, NameStr: String; MsgList: TStringList): Boolean;
// rpk 3/22/2019
function getOTHD(DFNStr, NameStr: String; out TitleCaptionStr, TitleHintStr,
  DtlCaptionStr, DtlHintStr: String; DspList: TStringList): Boolean;
// rpk 3/6/2018

implementation

uses SysUtils, DateUtils, rMisc, ORFn, ORNet, VAUtils;

// NAME: OROTHCL GET
// ROUTINE: GET^OROTHCL
// RETURN VALUE TYPE: SINGLE VALUE
// AVAILABILITY: SUBSCRIPTION
// DESCRIPTION:
// The Other Than Honorable Discharge initiative allow for certain patients to
// have limited mental health access.  These individuals are entitled to two 90
// day terms of care in a 365 day period.  This RPC returns the status of the clock
// for an application to display as it sees fit.
//
// INPUT PARAMETER: DFN
// PARAMETER TYPE: LITERAL
// MAXIMUM DATA LENGTH: 100   need to edit this to a lower value, say 12
// REQUIRED: YES
// SEQUENCE NUMBER: 1
// DESCRIPTION: This is a pointer to the PATIENT file.
//
// RETURN PARAMETER DESCRIPTION:
// This return parameter should contain all the information the client needs to
// display information about the OTHD clock without the client having to do any
// calculations.  The return string is of the following format:
//
///
/// The Results array contains one or more rows:
/// First row contains a counter of the number of rows available starting with the second row
/// ret(0) results line contains a status code and a possible error message
/// ret(1..n) contain the message lines returned for display in the OTH button or
/// in the detailed message popup.
/// If some kind of error condition is encountered, return
// -1^error message
// -2^OTH functionality is not available (DG API is not available)
// p1 = status code that indicates a successful return when greater than zero
// 0 means patient is not OTHD eligible
// p1 greater than zero indicates the number of lines returned after ret(0)

function getOTHList(DFNStr, NameStr: String; MsgList: TStringList): Boolean;
// rpk 3/22/2019
const
  OTHRPC = 'OROTHCL GET';
var
  i, icnt, rcnt, rowcnt: Integer;
  tmpstr, p1, p2, rstr: String;
  dt: TDateTime;
  FMdt: TFMDateTime;
  DOS: String;
  tbool: Boolean;
  aRPC, Info: TStringList;

begin
  tmpstr := '';
  MsgList.Clear;
  Result := False;
//  tbool := False;
  dt := today;
  FMdt := DateTimeToFMDateTime(dt);
  DOS := FormatFMDateTime('mmm dd, yyyy', FMdt); // date of service?

  ///
  /// add check for existence of RPC
  ///
  aRPC := TStringList.Create; // rpk 1/5/2018
  try // rpk 1/5/2018
    aRPC.Clear;
    aRPC.Add(OTHRPC + '^1');
    tbool := RPCCheck(aRPC);
  finally
    aRPC.Free;
  end; // rpk 1/5/2018
  // if RPC not found, exit with False
  if not tbool then
  begin // rpk 1/5/2018
    StatusText('OTH RPC is missing');
    exit;
  end;

  Info := TStringList.Create;
  try
    CallVista(OTHRPC, [DFNStr, DOS], info); // rpk 3/27/2018
    icnt := info.Count;
    if (icnt > 0) then
    begin // rpk 5/5/2018
      tmpstr := Trim(info[0]);
      p1 := Piece(tmpstr, U, 1);
      p2 := Piece(tmpstr, U, 2);
      rcnt := StrToIntDef(p1, -3);
      // if rcnt <= 0, treat it as a status code.
      if rcnt <= 0 then
      begin
{$IFDEF DEBUG}
        if rcnt < 0 then
          // if p1 is negative, treat as error code, display p1 status and p2 message
          StatusText('OTH: ' + p1 + ':' + p2);
{$ENDIF}
        exit;
      end;
      if rcnt <> (icnt - 1) then
      begin
        // add loop which displays raw results in message after counts; rpk 5/7/2018
        rstr := tmpstr;
        for i := 1 to icnt - 1 do
          rstr := rstr + CRLF + info[i];
        ShowMsg('getOTHList: Results.Count=' + IntToStr(icnt) + ', Results[0]=' +
          IntToStr(rcnt) + ', Results=' + CRLF + rstr);
      end;
    end;

    if Length(tmpstr) = 0 then
      exit;
    p1 := Piece(tmpstr, U, 1);
    p2 := Piece(tmpstr, U, 2);
    i := StrToIntDef(p1, -3);
    if i <= 0 then
    begin
      if i < 0 then
        StatusText('getOTHList: ' + IntToStr(i) + ', ' + p2);
      exit;
    end;

    rowcnt := i;

    for i := 0 to rowcnt - 1 do
      MsgList.Add(info[i + 1]);
  finally
    info.Free;
  end;
  Result := True;
end; // getOTHList

///
/// Added PopupList to return optional popup message list
///
/// Processing results from getOTHD:
/// line 1: piece 1 for OTH Title caption, piece 2 for OTH Title hint
/// line 2: piece 1 for OTH Detail caption, piece 2 for OTH Detail hint
/// line 3..n: piece 1 for line in button click popup, piece 2 for line in
/// optional initial popup message
/// NOTE: for lines 3..n, the code expects at least one character or blank space
/// in a piece in order to include that line in the list for that piece.
///
function getOTHD(DFNStr, NameStr: String; out TitleCaptionStr, TitleHintStr,
  DtlCaptionStr, DtlHintStr: String; DspList: TStringList): Boolean;
const
  OTHDMINDAYS = 7;
var
  i, icnt, popcnt: Integer;
  tmpstr: String;
  p1, p2: String;
  dt: TDateTime;
  FMdt: TFMDateTime;
  DOS: String;
  tbool: Boolean;
  aResults, PopupList: TStringList;

begin
  Result := False;
  tmpstr := '';
  p1 := '';
  p2 := '';
  TitleCaptionStr := ''; // rpk 3/27/2019
  TitleHintStr := ''; // rpk 3/27/2019
  DtlCaptionStr := '';
  DtlHintStr := '';
  if Assigned(DspList) then
    DspList.Clear;
  dt := today;
  FMdt := DateTimeToFMDateTime(dt);
  DOS := FormatFMDateTime('mmm dd, yyyy', FMdt);

  aResults := TStringList.Create; // rpk 3/25/2019
  try
    tbool := getOTHList(DFNStr, DOS, aResults);
    if not tbool then
      exit;
    icnt := aResults.Count;
    if icnt > 0 then
    begin // rpk 5/3/2018
      tmpstr := Trim(aResults[0]);
    end;
    if Length(tmpstr) = 0 then
      exit;

    TitleCaptionStr := Piece(tmpstr, U, 1); // rpk 3/27/2019
    TitleHintStr := Piece(tmpstr, U, 2); // rpk 4/1/2019
    if icnt > 1 then
    begin
      tmpstr := Trim(aResults[1]);
      DtlCaptionStr := Piece(tmpstr, U, 1); // rpk 3/27/2019
      DtlHintStr := Piece(tmpstr, U, 2); // rpk 4/1/2019
    end;
    if (icnt > 2) then
    begin
      PopupList := TStringList.Create;
      try
        PopupList.Clear;
        popcnt := 0;
        for i := 2 to icnt - 1 do
        begin
          tmpstr := aResults[i];
          p1 := Piece(tmpstr, U, 1);
          p2 := Piece(tmpstr, U, 2);
          // need at least a blank space to include this line in dsplist
          if (p1 > '') and Assigned(DspList) then
            DspList.Add(p1);
          // need at least a blank space to include this line in popuplist
          if p2 > '' then
          begin
            Inc(popcnt);
            PopupList.Add(p2);
          end;
        end; // for i
        if popcnt > 0 then // have non-empty lines
          ShowMsg(PopupList.Text);
      finally
        PopupList.Free;
      end;
    end;
    Result := True;
  finally
    aResults.Free;
  end; // rpk 1/5/2018

end; // getOTHD

end.
