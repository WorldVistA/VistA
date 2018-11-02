unit uROR_Utilities;
{$I Components.inc}
{
================================================================================
*
*       Package:        ROR - Clinical Case Registries
*       Date Created:   $Revision: 1 $  $Modtime: 12/20/07 12:43p $
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
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/CCR-COMPONENTS/uROR_Utilities.pas $
*
* $History: uROR_Utilities.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:28a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/CCR-COMPONENTS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:37p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/CCR-COMPONENTS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:25p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/CCR-COMPONENTS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 2:55p
 * Created in $/Vitals GUI/CCR-COMPONENTS
 * CCR Components. Version used in Vitals GUI 5.0.18
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 2:36p
 * Created in $/Vitals/CCR-COMPONENTS
 * 
 * *****************  Version 9  *****************
 * User: Zzzzzzgavris Date: 9/26/05    Time: 3:53p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 8  *****************
 * User: Zzzzzzgavris Date: 8/08/05    Time: 3:55p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzgavris Date: 12/01/04   Time: 3:36p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzgavris Date: 11/29/04   Time: 8:33a
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzgavris Date: 11/15/04   Time: 4:54p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzgavris Date: 10/22/04   Time: 3:55p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzgavris Date: 10/21/04   Time: 3:34p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzgavris Date: 10/14/04   Time: 3:52p
 * Updated in $/CCR v1.0/Current/Components
 *
 * *****************  Version 15  *****************
 * User: Zzzzzzgavris Date: 8/06/04    Time: 4:08p
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 14  *****************
 * User: Zzzzzzgavris Date: 6/14/04    Time: 3:54p
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 13  *****************
 * User: Zzzzzzgavris Date: 5/07/04    Time: 3:55p
 * Updated in $/CCR v1.0/Current
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
  extctrls;

type
  TFMDateTimeMode = set of (
    fmdtDateOnly,       // Convert date only
    fmdtShortDate,      // Short date (digits only)
    fmdtYear2,          // 2 digit year
    fmdtTimeOnly,       // Convert time only
    fmdtShortTime,      // Do not convert seconds
    fmdtTime24          // Military time format
  );

function BooleanToString(const aValue: Boolean; const aFormat: String = ''): String;
function StringToBoolean(const aValue: String; const aFormat: String = ''): Boolean;

function CCRDateTimeFormat(Mode: TFMDateTimeMode = []): String;

function  CmdLineSwitch( swlst: array of String ): Boolean; overload;
function  CmdLineSwitch( swlst: array of String; var swval: String ): Boolean; overload;

function  FMDateTimeStr(DateTime: String; Mode: TFMDateTimeMode = [];
            DfltValue: String = ''): String;

function  InString( S: String; SubStrs: array of String;
            CaseSensitive: Boolean = True ): Boolean;

function  MessageDialog( const ACaption: string; const Msg: string;
            DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; DefButton: Integer;
            HelpCtx: Longint ): Word;

function  Piece( Value, Delimiter: String;
            StartPiece: Integer = 1 ): String; overload;
function  Piece( Value, Delimiter: String;
            StartPiece: Integer; EndPiece: Integer ): String; overload;

const
  fmdtShortDateTime = [fmdtShortDate, fmdtShortTime, fmdtTime24];

var
  FMDateFormat: array[1..2,1..3] of String;


implementation

uses
  Windows,
  {$IFNDEF NOORPHEUS}OvcIntl, {$ENDIF}
  StrUtils;

function BooleanToString(const aValue: Boolean; const aFormat: String = ''): String;
begin
  if aFormat <> '' then
    begin
      if aValue then
        Result := Piece(aFormat, ';', 1)
      else
        Result := Piece(aFormat, ';', 2);
    end
  else if aValue then
    {$IFNDEF NOORPHEUS}
    Result := OvcIntlSup.TrueChar
    {$ELSE}
    Result := 'T'
    {$ENDIF}
   else
    {$IFNDEF NOORPHEUS}
     Result := OvcIntlSup.FalseChar;
    {$ELSE}
    Result := 'F';
    {$ENDIF}
end;

function CCRDateTimeFormat(Mode: TFMDateTimeMode = []): String;
var
  tfrm: String;
begin
  Result := '';

  if Not (fmdtTimeOnly in Mode) then
    begin
      if fmdtShortDate in Mode then
        Result := FMDateFormat[2][1]
      else
        Result := FMDateFormat[1][1];

      if fmdtYear2 in Mode then
        Result := StringReplace(Result, 'YYYY', 'YY', []);
    end;

  if Not (fmdtDateOnly in Mode) then
    begin
      if fmdtTime24 in Mode then
        if fmdtShortTime in Mode then
          tfrm := 'HH:NN'
        else
          tfrm := 'HH:NN:SS'
      else
        if fmdtShortTime in Mode then
          tfrm := 'T'
        else
          tfrm := 'TT';

      if Result <> '' then
        Result := Result + '  ' + tfrm
      else
        Result := tfrm;
    end;
end;

function FMDateTimeStr(DateTime: String; Mode: TFMDateTimeMode;
         DfltValue: String): String;
var
  buf, format: String;
  day, month, year: Word;
  hour, min, sec: Word;
  date, time: TDate;
  dateType, datePart: Integer;
begin
  if DateTime = '' then
    begin
      Result := DfltValue;
      Exit;
    end;
  Result := '';

  buf := Piece(DateTime, '.', 1);
  if( Not (fmdtTimeOnly in Mode)) and (buf <> '') then
    begin
      year  := StrToIntDef(Copy(buf, 1, 3), 0) + 1700;
      month := StrToIntDef(Copy(buf, 4, 2), 0);
      day   := StrToIntDef(Copy(buf, 6, 2), 0);

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

      hour := StrToIntDef(Copy(buf, 1, 2), 0);
      min  := StrToIntDef(Copy(buf, 3, 2), 0);
      sec  := StrToIntDef(Copy(buf, 5, 2), 0);

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

function StringToBoolean(const aValue: String; const aFormat: String = ''): Boolean;
begin
  Result := False;
  if (aFormat <> '') and (aValue = Piece(aFormat, ';')) then Result := True
  {$IFNDEF NOORPHEUS}
  else if AnsiStartsText(aValue, OvcIntlSup.TrueChar)   then Result := True
  else if AnsiStartsText(aValue, OvcIntlSup.YesChar)    then Result := True
  {$ELSE}
  else if AnsiStartsText(aValue, 'T')                   then Result := True
  else if AnsiStartsText(aValue, 'Y')                   then Result := True
  {$ENDIF}
  else if StrToIntDef(aValue, 0) <> 0                   then Result := True;
end;

initialization
  FMInitFormatArray;

end.
