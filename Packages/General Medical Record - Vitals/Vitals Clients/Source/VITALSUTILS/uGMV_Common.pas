unit uGMV_Common;
{
================================================================================
*
*       Package:
*       Date Created:   $Revision: 1 $  $Modtime: 2/23/09 6:33p $
*       Site:           Hines OIFO
*       Developers:
*                       Andrey Andriyevskiy
*                       Sergey Gavrilov
*
*       Description:    Common Utils
*
*       Notes:
*
================================================================================
*
* $History: uGMV_Common.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSUTILS
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 6/17/08    Time: 4:04p
 * Updated in $/Vitals/5.0 (Version 5.0)/VitalsGUI2007/Vitals/VITALSUTILS
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/18/07    Time: 12:50p
 * Updated in $/Vitals GUI 2007/Vitals-5-0-18/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:30a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:44p
 * Created in $/Vitals/VITALS-5-0-18/VitalsUtils
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsUtils
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 5:04p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsUtils
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:24p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSUTILS
 *
*
================================================================================
}

interface
uses
  Classes,
  SysUtils,
  Dialogs,
  StdCtrls,
  Forms,
  Controls,
  comctrls,
  Graphics,
  extctrls
  , ShlObj
  , Windows
  ;

Type
  TFMDateTimeMode = set of (
    fmdtDateOnly,       // Convert date only
    fmdtShortDate,      // Short date (digits only)
    fmdtYear2,          // 2 digit year
    fmdtTimeOnly,       // Convert time only
    fmdtShortTime,      // Do not convert seconds
    fmdtTime24          // Military time format
  );

  function  CmdLineSwitch( swlst: array of String ): Boolean; overload;
  function  CmdLineSwitch( swlst: array of String; var swval: String ): Boolean; overload;

  function  FMDateTimeStr(DateTime: String; Mode: TFMDateTimeMode = []): String;

  function  FMDateToWindowsDate( FMDate: Double ): TDate;
  function  FMDateTimeToWindowsDateTime( FMDateTime: Double ): TDateTime;

  function  InString( S: String; SubStrs: array of String;
              CaseSensitive: Boolean = True ): Boolean;
  function  IntVal( str: String ): Integer;

  function  MessageDialog( const ACaption: string; const Msg: string;
              DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; DefButton: Integer;
              HelpCtx: Longint ): Word;

  function  Piece( Value, Delimiter: String;
              StartPiece: Integer = 1 ): String; overload;
  function  Piece( Value, Delimiter: String;
              StartPiece: Integer; EndPiece: Integer ): String; overload;

  function  WindowsDateTimeToFMDateTime( WinDate: TDateTime ): Double;
  function  WindowsDateToFMDate( WinDate: TDate ): Double;

  function AddKeyToValue(Value,Key,Delim:String):String;
  function DelKeyFromValue(Value,Key,Delim:String):String;

  function FormatSSN(aSSN:String):String;
  function ReFormatSSN(aSSN:String):String;

  procedure DelLVSelectedLine(LVFrom:TListView);
  procedure CopySelectedLVLines(LVFrom, LVTo:TListView;Mode:Boolean);
  procedure CopyAllLVLine(LVFrom, LVTo:TListView);
  procedure CopyLVLine(LVFrom, LVTo:TListView;Mode:Boolean);
  procedure CopyLVHeaders(LVFrom, LVTo:TListView);

  procedure UpdateAndNotClearListView(aStrings: TStrings;aLV: TListView;
    iCaptionIndex: Integer;anIndexes: array of integer);
  procedure UpdateListView(aStrings: TStrings;aLV: TListView;
    iCaptionIndex: Integer;anIndexes: array of integer);
  procedure ListViewToParamList(aLV: TListView;anIndex:Integer;var aStrings:TStringList);
  procedure UpdateStringList(aStrings:TStrings;aSL: TStringList);

  procedure StringListToListView(aSL: TStringList;aLV: TListView;
    iCaptionIndex: Integer;anIndexes: array of integer);
  procedure ListViewToStringList(aLV: TListView;aL: TStringList;anIndexes: array of Integer;
      aStart,aDelim:String);

  procedure LoadColumnsWidth(aName:String;aColumns:TListColumns;sL: TStringList);
  procedure AddParam(aName,aValue:String;sL:TStringList);
  procedure SaveColumnsWidth(aName:String;aColumns:TListColumns;sL:TStringList);

  function StringByKey(aStrings:TStrings;aKey:String;aPosition:Integer):String;
  procedure UpdateEdit(var Key: Char; Sender: TObject);

  procedure SetPanelStatus(aPanel:TPanel;aStatus:Boolean;aColor:TColor);

  function dVal(gStr,sDateTime: string): Double;
  function getCellDateTime(s:String):TDateTime;
  function ReplaceStr(aLine,aTarget,aReplacement:String):String;

  procedure PositionForm(aForm: TForm);
  function GetProgramFilesPath: String;

var
  FMDateFormat: array[1..2,1..3] of String;

const
//  clTabIn  = clInfoBk;
  clTabIn  = clWindow;
  clTabOut = clInfoBk;

  iIgnore = - 999999;
  

implementation

uses
 System.UITypes;

function FMDateTimeStr(DateTime: String; Mode: TFMDateTimeMode): String;
var
  buf, format: String;
  day, month, year: Word;
  hour, min, sec: Word;
  date, time: TDate;
  dateType, datePart: Integer;
begin
  Result := '';

  buf := Piece(DateTime, '.', 1);
  if( Not (fmdtTimeOnly in Mode)) and (buf <> '') then
    begin
      year  := IntVal(Copy(buf, 1, 3)) + 1700;
      month := IntVal(Copy(buf, 4, 2));
      day   := IntVal(Copy(buf, 6, 2));

      if fmdtShortDate in Mode then
        dateType := 2
      else
        dateType := 1;

      datePart := 1;
      if day = 0 then
        begin
          day := 1;
          datePart := 2;
          if month = 0 then
            begin
              month := 1;
              datePart := 3;
            end;
        end;

      format := FMDateFormat[dateType][datePart];
      if fmdtYear2 in Mode then
        format := StringReplace(format, 'YYYY', 'YY', []);

      date := EncodeDate(year, month, day);
      Result := FormatDateTime(format, date);
    end;

  buf := Piece(DateTime, '.', 2);
  if (Not (fmdtDateOnly in Mode)) And (buf <> '') then
    begin
      buf := Copy(buf + '000000', 1, 6);

      hour := IntVal(Copy(buf, 1, 2));
      min  := IntVal(Copy(buf, 3, 2));
      sec  := IntVal(Copy(buf, 5, 2));

      if hour >= 24 then
        begin
          hour := 23; min := 59; sec := 59;
        end
      else if min >= 60 then
        begin
          min := 59; sec := 59;
        end
      else if sec >= 60 then
        sec := 59;

      time := EncodeTime(hour, min, sec, 0);

      if fmdtTime24 in Mode then
        if fmdtShortTime in Mode then
          format := 'HH:NN'
        else
          format := 'HH:NN:SS'
      else
        if fmdtShortTime in Mode then
          format := 'T'
        else
          format := 'TT';

      if Result <> '' then
         Result := Result + '  ' + FormatDateTime(format, time)
      else
         Result := FormatDateTime(format, time);
    end;
end;

procedure FMInitFormatArray;
var
  format: String;
begin
  format := UpperCase(FormatSettings.ShortDateFormat);
  if Pos('M', format) > Pos('D', format) then
    begin
      FMDateFormat[1][1] := 'DD MMM YYYY';
      FMDateFormat[1][2] := 'MMM YYYY';
      FMDateFormat[1][3] := 'YYYY';

      FMDateFormat[2][1] := 'DD/MM/YYYY';
      FMDateFormat[2][2] := 'MM/YYYY';
      FMDateFormat[2][3] := 'YYYY';
    end
  else
    begin
      FMDateFormat[1][1] := 'MMM DD, YYYY';
      FMDateFormat[1][2] := 'MMM YYYY';
      FMDateFormat[1][3] := 'YYYY';

      FMDateFormat[2][1] := 'MM/DD/YYYY';
      FMDateFormat[2][2] := 'MM/YYYY';
      FMDateFormat[2][3] := 'YYYY';
    end;
end;

function CmdLineSwitch(swlst: array of String): Boolean;
var
  swval: String;
begin
  Result := CmdLineSwitch(swlst, swval);
end;

function CmdLineSwitch(swlst: array of String; var swval: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  swval := '';
  for i := 1 to ParamCount do
  begin
    if InString(ParamStr(i), swlst, False) then
      begin
        swval := Piece(ParamStr(i), '=', 2);
        Result := True;
        break;
      end;
  end;
end;

function InString(S: String; SubStrs: array of String; CaseSensitive: Boolean = True): Boolean;
var
  i: integer;
begin
  i := 0;
  Result := False;
  while (i <= High(SubStrs)) and (Result = False) do
  begin
    if CaseSensitive then
      begin
        if Pos(SubStrs[i], S) > 0 then
          Result := True
        else
          Inc(i)
      end
    else
      begin
        if Pos(LowerCase(SubStrs[i]), LowerCase(S)) > 0 then
          Result := True
        else
          Inc(i)
      end;
  end
end;

function IntVal(str: String): Integer;
begin
  if str <> '' then
    try
      Result := StrToInt(str);
    except
      on EConvertError do Result := 0;
      else raise;
    end
  else
    Result := 0;
end;

{-----------------------------------------------------------------------
   Source:   Torry's Delphi page
   Author:   Thomas Stutz
   Homepage: http://www.swissdelphicenter.ch
 -----------------------------------------------------------------------}

function MessageDialog(const ACaption: string; const Msg: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; DefButton: Integer;
  HelpCtx: Longint): Word;
var
  i: Integer;
  btn: TButton;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Caption := ACaption;
      HelpContext := HelpCtx;
      for i := 0 to ComponentCount - 1 do
      begin
        if (Components[i] is TButton) then
          begin
            btn := TButton(Components[i]);
            btn.default := btn.ModalResult = DefButton;
            if btn.default then ActiveControl := btn;
          end;
      end;
      Result := ShowModal;
    finally
      Free;
    end;
end;

function Piece(Value, Delimiter: string; StartPiece: Integer = 1): string;
begin
  Result := Piece(Value, Delimiter, StartPiece, StartPiece);
end;

function Piece(Value, Delimiter: string; StartPiece: Integer; EndPiece: Integer): string;
var
  dlen, i, pnum: Integer;
  buf: String;
begin
  Result := '';
  if (Value <> '') And (StartPiece > 0) And (EndPiece >= StartPiece) then
    begin
      dlen := Length(Delimiter);
      i := Pos(Delimiter, Value) - 1;
      if i >= 0 then
        begin
          buf := Value;
          pnum := 1;
          repeat
            if pnum > EndPiece then
              break;
            if i < 0  then
              i := Length(buf);
            if pnum = StartPiece then
              Result := Copy(buf, 1, i)
            else if pnum > StartPiece then
              Result := Result + Delimiter + Copy(buf, 1, i);
            Delete(buf, 1, i+dlen);
            i := Pos(Delimiter, buf) - 1;
            Inc(pnum);
          until (i < 0) And (buf = '');
        end
      else if StartPiece = 1 then
        Result := Value;
    end;
end;


function WindowsDateToFMDate(WinDate: TDate): Double;
var
  Year, Month, Day: Word;
begin
  DecodeDate(WinDate, Year, Month, Day);
  Result := ((Year - 1700) * 10000) + (Month * 100) + Day;
end;

function FMDateToWindowsDate(FMDate: Double): TDate;
var
  FMString: string;
  Year, Month, Day: Word;
begin
  FMString := FloatToStr(FMDate);
  try
    Year := StrToInt(Copy(FMString, 1, 3)) + 1700;
    Month := StrToInt(Copy(FMString, 4, 2));
    Day := StrToInt(Copy(FMString, 6, 2));
    Result := EncodeDate(Year, Month, Day);
  except
    on E: EConvertError do
      begin
        MessageDlg('Error Converting Date ' + FMString, mtError, [mbok], 0);
        Result := Now;
      end;
  else
    raise;
  end;
end;

function WindowsDateTimeToFMDateTime(WinDate: TDateTime): Double;
var
  Hour, Min, Sec, Msec: Word;
begin
  Result := WindowsDateToFMDate(WinDate);
  DecodeTime(WinDate, Hour, Min, Sec, Msec);
  Result := Result + (Hour * 0.01) + (Min * 0.0001) + (Sec * 0.000001);
end;

function FMDateTimeToWindowsDateTime(FMDateTime: Double): TDateTime;
var
  FMString: string;
  Hour, Min, Sec: Word;
begin
  FMString := FLoatToStr(FMDateTime);
  Result := FMDateToWindowsDate(FMDateTime);
  Hour := StrToIntDef(Copy(FMString, 9, 2), 0);
  Min := StrToIntDef(Copy(FMString, 11, 2), 0);
  Sec := StrToIntDef(Copy(FMString, 13, 2), 0);
  Result := Result + EncodeTime(Hour, Min, Sec, 0);
end;

function AddKeyToValue(Value,Key,Delim:String):String;
var
  i: Integer;
begin
  i := pos(Delim+Key,Value);
  if i > 0 then
    Result := Value
  else
    begin
      i := pos(Key,Value);
      if i = 1 then
        Result := Value
      else
        begin
          if Value = '' then Result := Key
          else Result := Value +Delim+Key;
        end;
    end;
end;

function DelKeyFromValue(Value,Key,Delim:String):String;
var
  i: Integer;
  s : String;
begin
  i := pos(Key,Value);
  if i = 0 then Result := Value
  else
    begin
      s := Delim+Key;
      i := pos(s,Value);
      if i <> 0 then
        s := copy(Value,1,i-1)+copy(Value,i+Length(s),Length(Value))
      else
        if pos(Key,Value)=1 then
        s := copy(Value,Length(Key)+1,Length(Value));
      if pos(Delim,s)= 1 then
      S := copy(s,Length(Delim)+1,Length(s));  
      Result := S;
    end;
end;

function FormatSSN(aSSN:String):String;
var
  s: String;
begin
  try
    s := aSSN;
    While pos(' ',s) = 1 do
      s := copy(s,2,length(s)-1);
    if pos('*S',s)=1 then
      Result := s
    else
      Result := Copy(aSSN,1,3)+'-'+Copy(aSSN,4,2)+'-'+Copy(aSSN,6,99);
  except
    Result := aSSN
  end;
end;

function ReFormatSSN(aSSN:String):String;
var
  i : Integer;
  sResult: String;
begin
  i := pos('-',aSSN);
  sResult := aSSN;
  while i <> 0 do
    begin
      sResult := copy(sResult,1,i-1)+copy(sResult,i+1,99);
      i := pos('-',sResult);
    end;
  Result := sResult;
end;

procedure DelLVSelectedLine(LVFrom:TListView);
var
  iPrev,i: Integer;
begin
  if not Assigned(LVFrom) then Exit;
  iPrev := lvFrom.ItemFocused.Index;
  i := 0;
  while i < lvFrom.Items.Count do
    begin
      if lvFrom.Items[i].Selected then
        lvFrom.Items.Delete(i)
      else
        inc(i);
    end;
  try
    if lvFrom.Items.Count < iPrev  then
      iPrev := lvFrom.Items.Count - 1;
    if iPrev >=0 then
      lvFrom.Selected := lvFrom.Items[iPrev];
  except
    on E: Exception do
      MessageDlg('Error Deleting Element list'+#13+E.Message, mtInformation, [mbok], 0);
  end;

EXIT;
  try
    if lvFrom.ItemFocused = nil then
      lvFrom.Items.Delete(0)
    else
      lvFrom.Items.Delete(lvFrom.ItemFocused.Index);

    lvFrom.Selected := lvFrom.ItemFocused;
  except
  end;
end;

procedure CopyLVLine(LVFrom, LVTo:TListView;Mode:Boolean);
var
  i: Integer;
  liFrom,
  li:TListItem;
begin
  if lvFrom.ItemFocused = nil then
    liFrom := lvFrom.Items[0]
  else
    liFrom := lvFrom.ItemFocused;

  try
    for i := 0 to lvTo.Items.Count - 1 do
      if lvTo.Items[i].Caption = liFrom.Caption then
        begin
          lvTo.ItemFocused := lvTo.Items[i];
          Exit;
        end;

    li := lvTo.Items.Add;
    li.Caption := liFrom.Caption;
    for i := 0 to liFrom.SubItems.Count - 1 do
        li.SubItems.Add(liFrom.SubItems[i]);


    if Mode then
      lvFrom.Items.Delete(liFrom.Index)
    else
      if liFrom.Index < lvFrom.Items.Count - 1 then
        lvFrom.ItemFocused := lvFrom.Items[liFrom.Index+1];

    lvFrom.Selected := lvFrom.ItemFocused;
  except
  end;
end;

procedure CopySelectedLVLines(LVFrom, LVTo:TListView;Mode:Boolean);
var
  iPrev, iCurr,
  i: Integer;
  liFrom,
  li:TListItem;
begin
  iPrev := lvFrom.ItemFocused.Index;
  iCurr := 0;
  while iCurr < lvFrom.Items.Count  do
    begin
      liFrom := lvFrom.Items[iCurr];
      if not liFrom.Selected then
        begin
          Inc(iCurr);
          Continue;
        end;
      liFrom.Selected := False;
      for i := 0 to lvTo.Items.Count - 1 do
        if lvTo.Items[i].Caption = lvFrom.Items[iCurr].Caption then
            break;
      if i < lvTo.Items.Count then
        begin
          inc(iCurr);
          continue;
        end;

      li := lvTo.Items.Add;
      li.Caption := liFrom.Caption;
      for i := 0 to liFrom.SubItems.Count - 1 do
          li.SubItems.Add(liFrom.SubItems[i]);

      if Mode then
        lvFrom.Items.Delete(iCurr)
      else
        inc(iCurr);

    end;

  try
    if lvFrom.Items.Count < iPrev  then
      iPrev := lvFrom.Items.Count - 1
    else
      Inc(iPrev);
    if iPrev >=0 then
      begin
        lvFrom.ItemFocused := lvFrom.Items[iPrev];
        lvFrom.Selected := lvFrom.ItemFocused;
      end;
  except
    on E: Exception do
      MessageDlg('Error Deleting Element list'+#13+E.Message, mtInformation, [mbok], 0);
  end;
end;

procedure CopyAllLVLine(LVFrom, LVTo:TListView);
var
  j,
  i: Integer;
begin
  try
    j := lvFrom.ItemFocused.Index;
  except
    j := 0;
  end;

  for i := 0 to lvFrom.Items.Count - 1 do
    begin
      lvFrom.ItemFocused := lvFrom.Items[i];
      CopyLVLine(LVFrom, LVTo,False);
    end;
  lvFrom.ItemFocused := lvFrom.Items[j];
end;

procedure CopyLVHeaders(LVFrom, LVTo:TListView);
var
  lc:TListColumn;
  i: Integer;
begin
  LVTo.Columns.Clear;
  for i := 0 to lvFrom.Columns.Count - 1 do
    begin
      lc := lvTo.Columns.Add;
      lc.Caption := lvFrom.Columns[i].Caption;
      lc.Width := lvFrom.Columns[i].Width;
    end;
end;

procedure UpdateListView(aStrings: TStrings;aLV: TListView;
  iCaptionIndex: Integer;anIndexes: array of integer);
var
  s: String;
  li:TListItem;
  j,
  i,iCount: Integer;
begin
   try
     iCount := StrToInt(piece(aStrings[0],'^',1));
     if iCount > aStrings.Count - 1 then
       iCount := aStrings.Count - 1;
   except
     iCount := 0;
   end;
   aLV.Items.Clear;
   for i := 1 to iCount do
     begin
       s := aStrings[i];
       li := aLV.Items.Add;
       li.Caption := piece(s,'^',iCaptionIndex);
       for j := Low(anIndexes) to High(anIndexes) do
         li.SubItems.Add(piece(s,'^',anIndexes[j]));
     end;
   try
     if aLV.Items.Count < 1 then exit;
     aLV.ItemFocused := aLV.Items[0];
     aLV.ItemFocused.Selected := True;
   except
   end;
end;

procedure UpdateAndNotClearListView(aStrings: TStrings;aLV: TListView;
  iCaptionIndex: Integer;anIndexes: array of integer);
var
  s: String;
  li:TListItem;
  j,
  i,iCount: Integer;
begin
   try
     iCount := StrToInt(piece(aStrings[0],'^',1));
     if iCount > aStrings.Count - 1 then
       iCount := aStrings.Count - 1;
   except
     iCount := 0;
   end;
//   aLV.Items.Clear;
   for i := 1 to iCount do
     begin
       s := aStrings[i];
       li := aLV.Items.Add;
       li.Caption := piece(s,'^',iCaptionIndex);
       for j := Low(anIndexes) to High(anIndexes) do
         li.SubItems.Add(piece(s,'^',anIndexes[j]));
     end;
   try
     if aLV.Items.Count < 1 then exit;
     aLV.ItemFocused := aLV.Items[0];
     aLV.ItemFocused.Selected := True;
   except
   end;
end;

procedure StringListToListView(aSL: TStringList;aLV: TListView;
  iCaptionIndex: Integer;anIndexes: array of integer);
var
  li:TListItem;
  j,i: Integer;
begin
   aLV.Items.Clear;
   for i := 0 to aSL.Count -1 do
     begin
       li := aLV.Items.Add;
       li.Caption := piece(aSL[i],'^',iCaptionIndex);
       for j := Low(anIndexes) to High(anIndexes) do
         li.SubItems.Add(piece(aSL[i],'^',anIndexes[j]));
     end;
   try
     aLV.ItemFocused := aLV.Items[0];
     aLV.ItemFocused.Selected := True;
   except
   end;
end;

procedure ListViewToParamList(aLV: TListView;anIndex:Integer;var aStrings:TStringList);
var
  i: Integer;
begin
  for i := 0 to aLV.Items.Count - 1 do
    begin
      if anIndex = 0 then
        aStrings.Add(aLV.Items[i].Caption)
      else
        aStrings.Add(aLV.Items[i].SubItems[anIndex-1]);
    end;
end;

procedure UpdateStringList(aStrings:TStrings;aSL: TStringList);
var
  i, iCount: Integer;
begin
  aSL.Clear;
  if aStrings.Count > 0 then
    begin
      iCount := IntVal(Piece(aStrings[0],'^',1));
      for i := 1 to iCount do
        aSL.Add(aStrings[i]);
    end;
end;

procedure ListViewToStringList(aLV: TListView;aL: TStringList;anIndexes: array of Integer;
  aStart,aDelim:String);
var
  i, j: Integer;
  s: String;
begin
  for i := 0 to aLV.Items.Count - 1 do
    begin
      s := aStart;
      for j := Low(anIndexes) to High(anIndexes) do
        s := s + aDelim+ aLV.Items[i].SubItems[j];
      aL.Add(s);
    end;
end;

procedure LoadColumnsWidth(aName:String;aColumns:TListColumns;sL: TStringList);
var
  i: Integer;
  s: String;
begin
  if aColumns = nil then Exit;
  for i := 0 to aColumns.Count - 1 do
    try
      s := sL.Values[aName+'-'+IntToStr(i)];
      aColumns[i].Width := StrToIntDef(sL.Values[s],aColumns[i].Width);
    except
    end;
end;

procedure AddParam(aName,aValue:String;sL:TStringList);
begin
  sL.Add(aName + '='+aValue);
end;

procedure SaveColumnsWidth(aName:String;aColumns:TListColumns;sL:TStringList);
var
  i: Integer;
begin
  for i := 0 to aColumns.Count - 1 do
    begin
      AddParam(aName+'-'+IntToStr(i),IntToStr(aColumns[i].Width),sL);
    end;
end;

function StringByKey(aStrings:TStrings;aKey:String;aPosition:Integer):String;
var
  s: String;
  i: Integer;
begin
  s := '';
  for i := 1 to aStrings.Count - 1 do
    if piece(aStrings[i],'^',aPosition) = aKey then
      s := aStrings[i];
  Result := s;
end;

procedure  UpdateEdit(var Key: Char; Sender: TObject);
var
  s,sY,sM: String;
begin
  if ((pos(Upcase(Key),'0123456789/') = 0))  then
    begin
      if Key <> Char(#13) then
        Key := Char(#8);
      exit;
    end;
  s := TEdit(Sender).Text;
  sY := piece(s,'/',2);
  sM := piece(s,'/',1);
  if ((s='') and (Key='/')) then
    begin
      Key := Char(#8);
      exit;
    end
  else if (pos('/',s)<>0) and (Key='/') then
    begin
      Key := Char(#0);
      exit;
    end
  else  if sY = '' then
    begin
      case Length(sM) of
        0:;
        1:
          begin
            if (sM<>'0') and (sM<>'1') then
              begin
                if Key <> '/' then
                  begin

                    TEdit(Sender).Text := '0'+sM +'/';
                  end
                else
                  TEdit(Sender).Text := '0'+sM;
                TEdit(Sender).SelStart := 3;
              end
            else if (sM = '0') and ((Key='/') or (Key='0')) then
              begin
                Key := Char(#0);
                exit;
              end;
          end;
        2:
          if (sM <> '11') and (sM <>'12') then
            begin
              if pos('0',sM) = 0 then
                begin
                  sM := '0'+copy(sM,1,1);
                  sY := copy(sM,2,4);
                end;
              TEdit(Sender).Text := sM +'/'+sY;
              TEdit(Sender).SelStart := 4;
              if Key='/' then Key:=Char(#0);
            end
          else
            begin
              if Key <>'/' then
                begin
                  if pos('/',s) <> 0 then
                    s := s +Key
                  else
                    s := s + '/'+Key
                end
              else
                s := s + '/';
              TEdit(Sender).Text := s;
              TEdit(Sender).SelStart := 4;
              Key := Char(#0);
            end;
        end;
    end
  else
    begin
      if (Key = Char(#8)) and
        (TEdit(Sender).SelStart = 3) then
        Key := Char(#0);
    end;
end;

procedure SetPanelStatus(aPanel:TPanel;aStatus:Boolean;aColor:TColor);
var
  i: Integer;
begin
  aPanel.Enabled := aStatus;
  for i := 0 to aPanel.ControlCount - 1 do
    begin
      if aPanel.Controls[i] is TPanel then
        SetPanelStatus(TPanel(aPanel.Controls[i]),aStatus,aColor)
      else if aPanel.Controls[i] is TEdit then
        TEdit(aPanel.Controls[i]).Color := aColor
      else if aPanel.Controls[i] is TListView then
        TListView(aPanel.Controls[i]).Color := aColor
      else if aPanel.Controls[i] is TTreeView then
        TTreeView(aPanel.Controls[i]).Color := aColor
      else if aPanel.Controls[i] is TCheckBox then
        TCheckBox(aPanel.Controls[i]).Enabled := aStatus
      else if aPanel.Controls[i] is TRadioButton then
        TRadioButton(aPanel.Controls[i]).Enabled := aStatus
      else if aPanel.Controls[i] is TComboBox then
        TComboBox(aPanel.Controls[i]).Color := aColor;
    end;
end;


function dVal(gStr,sDateTime: string): Double;
var
  i: integer;
begin
  Result := iIgnore; // zzzzzzandria 060123
  if trim(gStr) = '' then Exit;

  i := 1;
  if pos('-',gStr)=1 then i := 2; // zzzzzzandria 051107
  while (StrToIntDef(Copy(gStr, i, 1), -1) > -1)
     or (Copy(gStr, i, 1) = '.') do  inc(i);
  try
    Result := StrToFloat(Copy(gStr, 1, i - 1));
//      Result := StrToFloat(Piece(gStr, ' ',1));

  except
    on E: EConvertError do
      begin
        if not ((pos('Ref',gStr) = 1) or (pos('Una',gStr) =1) or (pos('Pass',gStr)=1)) then
        MessageDlg(
          'Error converting value to numeric' + #13 +
          'Value: ' + gStr + #13#13+
          'Date/Time: ' + sDateTime +#13#13 +
          '  A value of 0 (zero) will be used instead.',
          mtWarning, [mbok], 0);
        Result := 0;
      end;
  else
    raise;
  end;
end;

function getCellDateTime(s:String):TDateTime;
var
  i: Integer;
  d: double;
begin
  (* OSE/SMH - Don't do that! i18n dates break
  i := pos('-',s);
  while i > 0 do
    begin
      s := copy(s,1,i-1)+'/'+copy(s,i+1,Length(s));
      i := pos('-',s);
    end;
  *)
  try
    d := StrToDateTime(s);
  except
    d := now;
  end;
  Result := d;
end;

function ReplaceStr(aLine,aTarget,aReplacement:String):String;
var
  s: String;
  i: Integer;
begin
  Result := aLine;
  if aTarget = aReplacement then Exit;
  if aTarget = '' then Exit;
  i := pos(aTarget,aLine);
  s := aLine;
  while i > 0 do
    begin
      s := copy(s,1,i-1)+aReplacement+copy(s,i+Length(aTarget),Length(s));
      i := pos(aTarget,s);
    end;
  Result := s;
end;

procedure PositionForm(aForm: TForm);
var
  iHeight,
  iWidth: Integer;
begin
  iHeight := Screen.WorkAreaHeight;
  iWidth := Screen.WorkAreaWidth;

  if aForm.Width > iWidth then aForm.Width := iWidth;
  if aForm.Height > iHeight then aForm.Height := iHeight;

  if aForm.Top> iHeight then aForm.Top := 0;
  if aForm.Left> iWidth then aForm.Left := 0;
  if aForm.Top < 0 then aForm.Top := 0;
  if aForm.Left < 0 then aForm.Left := 0;

  if aForm.Top + aForm.Height > iHeight then
    aForm.Top := iHeight - aForm.Height;

  if aForm.Left + aForm.Width > iWidth then
    aForm.Left := iWidth - aForm.Width;
end;

//  SHARE_DIR = '\VISTA\Common Files\';
function GetProgramFilesPath: String;
Const
  CSIDL_PROGRAM_FILES = $0026;
var
  Path: array[0..Max_Path] of Char;
begin
  Path := '';
  SHGetSpecialFolderPath(0,Path,CSIDL_PROGRAM_FILES,false);
  Result := Path;
end;

initialization
  FMInitFormatArray;

end.











