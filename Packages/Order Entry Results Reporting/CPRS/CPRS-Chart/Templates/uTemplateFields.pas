unit uTemplateFields;

interface

uses
  Forms, SysUtils, Classes, Dialogs, StdCtrls, ExtCtrls, Controls, Contnrs,
  Graphics, ORClasses, ComCtrls, ORDtTm, uDlgComponents, TypInfo, ORFn, StrUtils,
  uConst, ORNet;

type
  TTemplateFieldType = (dftUnknown, dftEditBox, dftComboBox, dftButton, dftCheckBoxes,
    dftRadioButtons, dftDate, dftNumber, dftHyperlink, dftWP, dftText,
// keep dftScreenReader as last entry - users can not create this type of field
    dftScreenReader);

  TTmplFldDateType = (dtUnknown, dtDate, dtDateTime, dtDateReqTime,
                                 dtCombo, dtYear, dtYearMonth);

const
  FldItemTypes  = [dftComboBox, dftButton, dftCheckBoxes, dftRadioButtons, dftWP, dftText];
  SepLinesTypes = [dftCheckBoxes, dftRadioButtons];
  EditLenTypes  = [dftEditBox, dftComboBox, dftWP];
  EditDfltTypes = [dftEditBox, dftHyperlink];
  EditDfltType2 = [dftEditBox, dftHyperlink, dftDate];
  ItemDfltTypes = [dftComboBox, dftButton, dftCheckBoxes, dftRadioButtons];
  NoRequired    = [dftHyperlink, dftText];
  ExcludeText   = [dftHyperlink, dftText];
  DateComboTypes = [dtCombo, dtYear, dtYearMonth];

type
  TTemplateDialogEntry = class(TObject)
  private
    FID: string;
    FFont: TFont;
    FPanel: TDlgFieldPanel;
    FControls: TStringList;
    FIndents: TStringList;
    FFirstBuild: boolean;
    FOnChange: TNotifyEvent;
    FText: string;
    FInternalID: string;
    FObj: TObject;
    FFieldValues: string;
    FUpdating: boolean;
    FAutoDestroyOnPanelFree: boolean;
    FOnDestroy: TNotifyEvent;
    FOldPanelDestroy: TNotifyEvent;
    procedure KillLabels;
    function GetFieldValues: string;
    procedure SetFieldValues(const Value: string);
    procedure SetAutoDestroyOnPanelFree(const Value: boolean);
    function StripCode(var txt: string; code: char): boolean;
  protected
    procedure UpDownChange(Sender: TObject);
    procedure DoChange(Sender: TObject);
    function GetControlText(CtrlID: integer; NoCommas: boolean;
                            var FoundEntry: boolean; AutoWrap: boolean;
                            emField: string = ''; CrntLnTxt: String = '';  AutoWrapIndent:Integer = 0;
                            NoFormat: Boolean = false): string;
    function GetControl(CtrlID: integer): TControl; // NSR20100706 AA 2015/10/09
    procedure SetControlText(CtrlID: integer; AText: string);
    procedure PanelDestroy(Sender: TObject);
  public
    constructor Create(AParent: TWinControl; AID, Text: string);
    destructor Destroy; override;
    function GetPanel(MaxLen: integer; AParent: TWinControl;
                      OwningCheckBox: TCPRSDialogParentCheckBox): TDlgFieldPanel;
    function GetText: string;
    property Text: string read FText write FText;
    property InternalID: string read FInternalID write FInternalID;
    property ID: string read FID;
    property Obj: TObject read FObj write FObj;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property FieldValues: string read GetFieldValues write SetFieldValues;
    property AutoDestroyOnPanelFree: boolean read FAutoDestroyOnPanelFree
                                             write SetAutoDestroyOnPanelFree;
  end;

  TTemplateField = class(TObject)
  private
    FMaxLen: integer;
    FFldName: string;
    FNameChanged: boolean;
    FLMText: string;
    FEditDefault: string;
    FNotes: string;
    FItems: string;
    FInactive: boolean;
    FItemDefault: string;
    FFldType: TTemplateFieldType;
    FRequired: boolean;
    FSepLines: boolean;
    FTextLen: integer;
    FIndent: integer;
    FPad: integer;
    FMinVal: integer;
    FMaxVal: integer;
    FIncrement: integer;
    FURL: string;
    FDateType: TTmplFldDateType;
    FModified: boolean;
    FID: string;
    FLocked: boolean;
    FCommunityCare: boolean;
    procedure SetEditDefault(const Value: string);
    procedure SetFldName(const Value: string);
    procedure SetFldType(const Value: TTemplateFieldType);
    procedure SetInactive(const Value: boolean);
    procedure SetRequired(const Value: boolean);
    procedure SetSepLines(const Value: boolean);
    procedure SetItemDefault(const Value: string);
    procedure SetItems(const Value: string);
    procedure SetLMText(const Value: string);
    procedure SetMaxLen(const Value: integer);
    procedure SetNotes(const Value: string);
    procedure SetID(const Value: string);
    procedure SetIncrement(const Value: integer);
    procedure SetIndent(const Value: integer);
    procedure SetMaxVal(const Value: integer);
    procedure SetMinVal(const Value: integer);
    procedure SetPad(const Value: integer);
    procedure SetTextLen(const Value: integer);
    procedure SetURL(const Value: string);
    function GetTemplateFieldDefault: string;
    procedure CreateDialogControls(Entry: TTemplateDialogEntry;
                                   var Index: Integer; CtrlID: integer);
    function SaveError: string;
    function Width: integer;
    function GetRequired: boolean;
    procedure SetDateType(const Value: TTmplFldDateType);
    function GetTIUParam: Integer;
  public
    constructor Create(AData: TStrings);
    destructor Destroy; override;
    procedure Assign(AFld: TTemplateField);
    function NewField: boolean;
    function CanModify: boolean;
    procedure ErrorCheckText(sl: TStrings);
    property ID: string read FID write SetID;
    property FldName: string read FFldName write SetFldName;
    property NameChanged: boolean read FNameChanged;
    property FldType: TTemplateFieldType read FFldType write SetFldType;
    property MaxLen: integer read FMaxLen write SetMaxLen;
    property EditDefault: string read FEditDefault write SetEditDefault;
    property Items: string read FItems write SetItems;
    property ItemDefault: string read FItemDefault write SetItemDefault;
    property LMText: string read FLMText write SetLMText;
    property Inactive: boolean read FInactive write SetInactive;
    property Required: boolean read GetRequired write SetRequired;
    property SepLines: boolean read FSepLines write SetSepLines;
    property TextLen: integer read FTextLen write SetTextLen;
    property Indent: integer read FIndent write SetIndent;
    property Pad: integer read FPad write SetPad;
    property MinVal: integer read FMinVal write SetMinVal;
    property MaxVal: integer read FMaxVal write SetMaxVal;
    property Increment: integer read FIncrement write SetIncrement;
    property URL: string read FURL write SetURL;
    property DateType: TTmplFldDateType read FDateType write SetDateType;
    property Notes: string read FNotes write SetNotes;
    property TemplateFieldDefault: string read GetTemplateFieldDefault;
    property CommunityCare: boolean read FCommunityCare;
    property TIUParam: Integer read GetTIUParam; // 20100706 - VISTAOR-24208 FH 2021/02/12
  end;

  TIntStruc = class(TObject)
  public
    x: integer;
  end;

function GetDialogEntry(AParent: TWinControl; AID, AText: string): TTemplateDialogEntry;
procedure FreeEntries(SL: TStrings);
procedure AssignFieldIDs(var Txt: string); overload;
procedure AssignFieldIDs(SL: TStrings); overload;
function ResolveTemplateFields(Text: string; AutoWrap: boolean; Hidden: boolean = FALSE; IncludeEmbedded: boolean = FALSE; AutoWrapIndent: Integer = 0): string;
function AreTemplateFieldsRequired(const Text: string; FldValues: TORStringList =  nil): boolean;
function HasTemplateField(txt: string): boolean;

function GetTemplateField(ATemplateField: string; ByIEN: boolean): TTemplateField;
function TemplateFieldNameProblem(Fld: TTemplateField): boolean;
function SaveTemplateFieldErrors: string;
procedure ClearModifiedTemplateFields;
function AnyTemplateFieldsModified: boolean;
procedure ListTemplateFields(const AText: string; ErrorList, FieldList: TStrings);
function BoilerplateTemplateFieldsOK(const AText: string; Msg: string = ''): boolean;
procedure EnsureText(edt: TEdit; ud: TUpDown);
procedure ConvertCodes2Text(sl: TStrings; Short: boolean);
function StripEmbedded(iItems: string): string;
procedure StripScreenReaderCodes(var Text: string); overload;
procedure StripScreenReaderCodes(SL: TStrings); overload;
function HasScreenReaderBreakCodes(SL: TStrings): boolean;
function getUTmplFlds: TList;// NSR20100706 AA 2010/10/09

Function RightTrimChars(Str: String; TrimChars: TSysCharSet): String;
function SafeWrapText(const Line, BreakStr: string;
    const BreakChars: TSysCharSet; const MaxCol: integer; MaxLineLength: integer = -1): string;
function SafeWrapTextVariable(const Line, BreakStr: string; const BreakChars: TSysCharSet;
  const MaxCol1, MaxCol2: integer; Const MaxLineLength: integer = -1): string;

const
  TemplateFieldSignature = '{FLD';
  TemplateFieldBeginSignature = TemplateFieldSignature + ':';
  TemplateFieldEndSignature = '}';
  ScreenReaderCodeSignature = '{SR-';
  ScreenReaderCodeType = '  Screen Reader Code';
  ScreenReaderCodeCount = 2;
  ScreenReaderShownCount = 1;
  ScreenReaderStopCode = ScreenReaderCodeSignature + 'STOP' + TemplateFieldEndSignature;
  ScreenReaderStopCodeLen = Length(ScreenReaderStopCode);
  ScreenReaderStopCodeID = '-43';
  ScreenReaderStopName = 'SCREEN READER STOP CODE **';
  ScreenReaderStopCodeLine = ScreenReaderStopCodeID + U + ScreenReaderStopName + U + ScreenReaderCodeType;
  ScreenReaderContinueCode = ScreenReaderCodeSignature + 'CONT' + TemplateFieldEndSignature;
  ScreenReaderContinueCodeLen = Length(ScreenReaderContinueCode);
  ScreenReaderContinueCodeOld = ScreenReaderCodeSignature + 'CONTINUE' + TemplateFieldEndSignature;
  ScreenReaderContinueCodeOldLen = Length(ScreenReaderContinueCodeOld);
  ScreenReaderContinueCodeID = '-44';
  ScreenReaderContinueCodeName = 'SCREEN READER CONTINUE CODE ***';
  ScreenReaderContinueCodeLine = ScreenReaderContinueCodeID + U + ScreenReaderContinueCodeName + U + ScreenReaderCodeType;
  MissingFieldsTxt = 'One or more required fields must still be entered.';

  ScreenReaderCodes:     array[0..ScreenReaderCodeCount] of string  =
      (ScreenReaderStopCode, ScreenReaderContinueCode, ScreenReaderContinueCodeOld);
  ScreenReaderCodeLens:  array[0..ScreenReaderCodeCount] of integer =
      (ScreenReaderStopCodeLen, ScreenReaderContinueCodeLen, ScreenReaderContinueCodeOldLen);
  ScreenReaderCodeIDs:   array[0..ScreenReaderShownCount] of string  =
      (ScreenReaderStopCodeID, ScreenReaderContinueCodeID);
  ScreenReaderCodeLines: array[0..ScreenReaderShownCount] of string  =
      (ScreenReaderStopCodeLine, ScreenReaderContinueCodeLine);

  TemplateFieldTypeCodes: array[TTemplateFieldType] of string =
                         {  dftUnknown      } ('',
                         {  dftEditBox      }  'E',
                         {  dftComboBox     }  'C',
                         {  dftButton       }  'B',
                         {  dftCheckBoxes   }  'X',
                         {  dftRadioButtons }  'R',
                         {  dftDate         }  'D',
                         {  dftNumber       }  'N',
                         {  dftHyperlink    }  'H',
                         {  dftWP           }  'W',
                         {  dftText         }  'T',
                         {  dftScreenReader }  'S');

  TemplateFieldTypeDesc: array[TTemplateFieldType, boolean] of string =
                         {  dftUnknown      } (('',''),
                         {  dftEditBox      }  ('Edit Box',           'Edit'),
                         {  dftComboBox     }  ('Combo Box',          'Combo'),
                         {  dftButton       }  ('Button',             'Button'),
                         {  dftCheckBoxes   }  ('Check Boxes',        'Check'),
                         {  dftRadioButtons }  ('Radio Buttons',      'Radio'),
                         {  dftDate         }  ('Date',               'Date'),
                         {  dftNumber       }  ('Number',             'Num'),
                         {  dftHyperlink    }  ('Hyperlink',          'Link'),
                         {  dftWP           }  ('Word Processing',    'WP'),
                         {  dftText         }  ('Display Text',       'Text'),
                         {  dftScreenReader }  ('Screen Reader Stop', 'SRStop'));

  TemplateDateTypeDesc: array[TTmplFldDateType, boolean] of string =
                         { dtUnknown        } (('',''),
                         { dtDate           }  ('Date',           'Date'),
                         { dtDateTime       }  ('Date & Time',    'Time'),
                         { dtDateReqTime    }  ('Date & Req Time','R.Time'),
                         { dtCombo          }  ('Date Combo',     'C.Date'),
                         { dtYear           }  ('Year',           'Year'),
                         { dtYearMonth      }  ('Year & Month',   'Month'));

  FldNames: array[TTemplateFieldType] of string =
                   { dftUnknown      }  ('',
                   { dftEditBox      }  'EDIT',
                   { dftComboBox     }  'LIST',
                   { dftButton       }  'BTTN',
                   { dftCheckBoxes   }  'CBOX',
                   { dftRadioButtons }  'RBTN',
                   { dftDate         }  'DATE',
                   { dftNumber       }  'NUMB',
                   { dftHyperlink    }  'LINK',
                   { dftWP           }  'WRDP',
                   { dftTExt         }  'TEXT',
                   { dftScreenReader }  'SRST');

  TemplateFieldDateCodes: array[TTmplFldDateType] of string =
                         { dtUnknown        } ('',
                         { dtDate           }  'D',
                         { dtDateTime       }  'T',
                         { dtDateReqTime    }  'R',
                         { dtCombo          }  'C',
                         { dtYear           }  'Y',
                         { dtYearMonth      }  'M');

  MaxTFWPLines = 20;
  MaxTFEdtLen = 70;

implementation

uses
  rTemplates, ORCtrls, mTemplateFieldButton, dShared, uCore, rCore, Windows,
  VAUtils, VA508AccessibilityManager, VA508AccessibilityRouter, System.UITypes, System.Types,
  fTemplateDialog, dRequiredFields, system.Math, uTemplates;

const
  NewTemplateField = 'NEW TEMPLATE FIELD';
  TemplateFieldSignatureLen = length(TemplateFieldBeginSignature);
  TemplateFieldSignatureEndLen = length(TemplateFieldEndSignature);

var
  uTmplFlds: TList = nil;
  uEntries: TStringList = nil;
  uNewTemplateFieldIDCnt: longint = 0;
  uRadioGroupIndex: integer = 0;
  uInternalFieldIDCount: integer = 0;

const
  FieldIDDelim = '`';
  FieldIDLen = 6;
  NewLine = 'NL';

function getUTmplFlds:TList;   // - access to template fields NSR20100706 AA 2015/10/07
begin
  Result := uTmplFlds;
end;

function GetNewFieldID: string;
begin
  inc(uInternalFieldIDCount);
  Result := IntToStr(uInternalFieldIDCount);
  Result := FieldIDDelim +
            copy(StringOfChar('0', FieldIDLen-2) + Result, length(Result), FieldIDLen-1);
end;

function GetDialogEntry(AParent: TWinControl; AID, AText: string): TTemplateDialogEntry;
var
  idx: integer;
begin
  Result := nil;
  if AID = '' then exit;
  if(not assigned(uEntries)) then
    uEntries := TStringList.Create;
  idx := uEntries.IndexOf(AID);
  if(idx < 0) then
  begin
    Result := TTemplateDialogEntry.Create(AParent, AID, AText);
    uEntries.AddObject(AID, Result);
  end
  else
    Result := TTemplateDialogEntry(uEntries.Objects[idx]);
end;

procedure FreeEntries(SL: TStrings);
var
  i, idx, cnt: integer;

begin
  if(assigned(uEntries)) then
  begin
    for i := SL.Count-1 downto 0 do
    begin
      idx := uEntries.IndexOf(SL[i]);
      if(idx >= 0) then
      begin
        cnt := uEntries.Count;
        if(assigned(uEntries.Objects[idx])) then
        begin
          TTemplateDialogEntry(uEntries.Objects[idx]).AutoDestroyOnPanelFree := FALSE;
          uEntries.Objects[idx].Free;
        end;
        if cnt = uEntries.Count then
          uEntries.Delete(idx);
      end;
    end;
    if(uEntries.Count = 0) then
      uInternalFieldIDCount := 0;
  end;
end;

procedure AssignFieldIDs(var Txt: string);
var
  i: integer;

begin
  i := 0;
  while (i < length(Txt)) do
  begin
    inc(i);
    if(copy(Txt,i,TemplateFieldSignatureLen) = TemplateFieldBeginSignature) then
    begin
      inc(i,TemplateFieldSignatureLen);
      if(i < length(Txt)) and (copy(Txt,i,1) <> FieldIDDelim) then
      begin
        insert(GetNewFieldID, Txt, i);
        inc(i, FieldIDLen);
      end;
    end;
  end;
end;

procedure AssignFieldIDs(SL: TStrings);
var
  i: integer;
  txt: string;

begin
  for i := 0 to SL.Count-1 do
  begin
    txt := SL[i];
    if pos(TemplateFieldBeginSignature,txt) > 0 then  //  20190618
      AssignFieldIDs(txt);
    SL[i] := txt;
  end;
end;

procedure WordWrapText(var Txt: string);
var
  TmpSL: TStringList;
  i: integer;
  lineSpacer: string;

  function WrappedText(const Str: string): string;
  var
    i, i2, j, k: integer;
    Temp: string;

  begin
    Temp := Str;
    Result := '';
    i2 := 0;

    repeat
      i := pos(TemplateFieldBeginSignature, Temp);

      if i>0 then
        j := pos(TemplateFieldEndSignature, copy(Temp, i, MaxInt))
      else
        j := 0;

      if (j > 0) then
        begin
        i2 := pos(TemplateFieldBeginSignature, copy(Temp, i+TemplateFieldSignatureLen, MaxInt));
        if (i2 = 0) then
          i2 := MaxInt
        else
          i2 := i + TemplateFieldSignatureLen + i2 - 1;
        end;

      if (i>0) and (j=0) then
        i := 0;

      if (i>0) and (j>0) then
        if (j > i2) then
          begin
          Result := Result + copy(Temp, 1, i2-1);
          delete(Temp, 1, i2-1);
          end
        else
          begin
          for k := (i+TemplateFieldSignatureLen) to (i+j-2) do
            if Temp[k]=' ' then
              Temp[k]:= #1;
          i := i + j - 1;
          Result := Result + copy(Temp,1,i);
          delete(Temp,1,i);
          end;

    until (i = 0);

    Result := Result + Temp;
    Result := SafeWrapText(Result, #13#10, [' '], MAX_WRAP_WIDTH);
    repeat
      i := pos(#1, Result);
      if i > 0 then
        Result[i] := ' ';
    until i = 0;
  end;

begin
  TmpSL := TStringList.Create;
  try
    TmpSL.Text := Txt;
    txt := '';
    lineSpacer := '';
    for i := 0 to TmpSL.Count - 1 do
      begin
        if i > 0 then lineSpacer := CRLF;
        if length(tmpsl[i]) > Max_Wrap_Width then
            Txt := Txt + lineSpacer + WrappedText(tmpsl[i])
        else
            txt := txt + lineSpacer + tmpsl[i];
      end;
  finally
    TmpSL.Free;
  end;
end;

function ResolveTemplateFields(Text: string;
                               AutoWrap: boolean;
                               Hidden: boolean = FALSE;
                               IncludeEmbedded: boolean = FALSE;
                               AutoWrapIndent: Integer = 0): string;
var
  flen, CtrlID, i, j: integer;
  Entry: TTemplateDialogEntry;
  iField, Temp, NewTxt, Fld: string;
  FoundEntry: boolean;
  TmplFld: TTemplateField;
  TempCopy: String;

  procedure AddNewTxt;
  begin
    if(NewTxt <> '') then
    begin
      insert(StringOfChar('x',length(NewTxt)), Temp, i);
      insert(NewTxt, Result, i);
      inc(i, length(NewTxt));
    end;
  end;

begin
  if AutoWrapIndent > 0 then
    MAX_WRAP_WIDTH := AutoWrapIndent;
  try
  if(not assigned(uEntries)) then
    uEntries := TStringList.Create;
  Result := Text;
  Temp := Text; // Use Temp to allow template fields to contain other template field references
  repeat
    i := pos(TemplateFieldBeginSignature, Temp);
    if(i > 0) then
    begin
      CtrlID := 0;
      if(copy(Temp, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then
      begin
        CtrlID := StrToIntDef(copy(Temp, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(Temp,i + TemplateFieldSignatureLen, FieldIDLen);
        delete(Result,i + TemplateFieldSignatureLen, FieldIDLen);
      end;
      j := pos(TemplateFieldEndSignature, copy(Temp, i + TemplateFieldSignatureLen, MaxInt));
      Fld := '';
      if(j > 0) then
      begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        Fld := copy(Temp,i + TemplateFieldSignatureLen, flen);
        delete(Temp,i,flen + TemplateFieldSignatureLen + 1);
        delete(Result,i,flen + TemplateFieldSignatureLen + 1);
      end
      else
      begin
        delete(Temp,i,TemplateFieldSignatureLen);
        delete(Result,i,TemplateFieldSignatureLen);
      end;
      if(CtrlID > 0) then
      begin
        FoundEntry := FALSE;
        for j := 0 to uEntries.Count-1 do
        begin
          Entry := TTemplateDialogEntry(uEntries.Objects[j]);
          if(assigned(Entry)) then
          begin
            if IncludeEmbedded then
              iField := Fld
            else
              iField := '';
            TempCopy := copy(Temp, 1, i - 1);
            if POS(CRLF, TempCopy) > 0 then
              TempCopy := Copy(TempCopy, LastDelimiter(CRLF, TempCopy) + 1, i);

            NewTxt := Entry.GetControlText(CtrlID, FALSE, FoundEntry, AutoWrap, iField, TempCopy, AutoWrapIndent);
            TmplFld := GetTemplateField(Fld, FALSE);
            if (assigned(TmplFld)) and (TmplFld.DateType in DateComboTypes) then {if this is a TORDateBox}
               NewTxt := Piece(NewTxt,':',1);          {we only want the first piece of NewTxt}
            AddNewTxt;
          end;
          if FoundEntry then break;
        end;
        if Hidden and (not FoundEntry) and (Fld <> '') then
        begin
          NewTxt := TemplateFieldBeginSignature + Fld + TemplateFieldEndSignature;
          AddNewTxt;
        end;
      end;
    end;
  until(i = 0);
  if not AutoWrap then
    WordWrapText(Result);
  finally
    MAX_WRAP_WIDTH := MAX_ENTRY_WIDTH;
  end;
end;

function AreTemplateFieldsRequired(const Text: string; FldValues: TORStringList =  nil): boolean;
var
  flen, CtrlID, i, j: integer;
  Entry: TTemplateDialogEntry;
  Fld: TTemplateField;
  Temp, NewTxt, FldName: string;
  FoundEntry: boolean;

begin
  if(not assigned(uEntries)) then
    uEntries := TStringList.Create;
  Temp := Text;
  Result := FALSE;
  repeat
    i := pos(TemplateFieldBeginSignature, Temp);
    if(i > 0) then
    begin
      CtrlID := 0;
      if(copy(Temp, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then
      begin
        CtrlID := StrToIntDef(copy(Temp, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(Temp,i + TemplateFieldSignatureLen, FieldIDLen);
      end;
      j := pos(TemplateFieldEndSignature, copy(Temp, i + TemplateFieldSignatureLen, MaxInt));
      if(j > 0) then
      begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        FldName := copy(Temp, i + TemplateFieldSignatureLen, flen);
        Fld := GetTemplateField(FldName, FALSE);
        delete(Temp,i,flen + TemplateFieldSignatureLen + 1);
      end
      else
      begin
        delete(Temp,i,TemplateFieldSignatureLen);
        Fld := nil;
      end;
      if(CtrlID > 0) and (assigned(Fld)) and (Fld.Required) then
      begin
        FoundEntry := FALSE;
        for j := 0 to uEntries.Count-1 do
        begin
          Entry := TTemplateDialogEntry(uEntries.Objects[j]);
          if(assigned(Entry)) then
          begin
            NewTxt := Entry.GetControlText(CtrlID, TRUE, FoundEntry, FALSE);
            if FoundEntry and (NewTxt = '') then{(Trim(NewTxt) = '') then //CODE ADDED BACK IN - ZZZZZZBELLC}
              Result := True;
          end;
          if FoundEntry then break;
        end;
        if (not FoundEntry) and assigned(FldValues) then
        begin
          j := FldValues.IndexOfPiece(IntToStr(CtrlID));
          if(j < 0) or (Piece(FldValues[j],U,2) = '') then
            Result := TRUE;
        end;
      end;
    end;
  until((i = 0) or Result);
end;

function HasTemplateField(txt: string): boolean;
begin
  Result := (pos(TemplateFieldBeginSignature, txt) > 0);
end;

function GetTemplateField(ATemplateField: string; ByIEN: boolean): TTemplateField;
var
  i, idx: integer;
  aData: TStringList;
begin
  Result := nil;
  if(not assigned(uTmplFlds)) then
    uTmplFlds := TList.Create;
  idx := -1;
  for i := 0 to uTmplFlds.Count-1 do
  begin
    if(ByIEN) then
    begin
      if(TTemplateField(uTmplFlds[i]).FID = ATemplateField) then
      begin
        idx := i;
        break;
      end;
    end
    else
    begin
      if(TTemplateField(uTmplFlds[i]).FFldName = ATemplateField) then
      begin
        idx := i;
        break;
      end;
    end;
  end;
  if(idx < 0) then
  begin
      AData := TStringList.Create;
      try
    if(ByIEN) then
          LoadTemplateFieldByIEN(ATemplateField, aData)
    else
          LoadTemplateField(ATemplateField, AData);
    if(AData.Count > 1) then
      Result := TTemplateField.Create(AData);
      finally
        FreeAndNil(AData);
      end;
  end
  else
    Result := TTemplateField(uTmplFlds[idx]);
end;

function TemplateFieldNameProblem(Fld: TTemplateField): boolean;
const
  DUPFLD = 'Field Name is not unique';

var
  i: integer;
  msg: string;

begin
  msg := '';
  if(Fld.FldName = NewTemplateField) then
    msg := 'Field Name can not be ' + NewTemplateField
  else
  if(length(Fld.FldName) < 3) then
    msg := 'Field Name must be at least three characters in length'
  else
  if(not CharInSet(Fld.FldName[1], ['A'..'Z','0'..'9'])) then
    msg := 'First Field Name character must be "A" - "Z", or "0" - "9"'
  else
  if(assigned(uTmplFlds)) then
  begin
    for i := 0 to uTmplFlds.Count-1 do
    begin
      if(Fld <> uTmplFlds[i]) and
        (CompareText(TTemplateField(uTmplFlds[i]).FFldName, Fld.FFldName) = 0) then
      begin
        msg := DUPFLD;
        break;
      end;
    end;
  end;
  if(msg = '') and (not IsTemplateFieldNameUnique(Fld.FFldName, Fld.ID)) then
    msg := DUPFLD;
  Result := (msg <> '');
  if(Result) then
    ShowMsg(msg);
end;

function SaveTemplateFieldErrors: string;
var
  i: integer;
  Errors: TStringList;
  Fld: TTemplateField;
  msg: string;

begin
  Result := '';
  if(assigned(uTmplFlds)) then
  begin
    Errors := nil;
    try
      for i := 0 to uTmplFlds.Count-1 do
      begin
        Fld := TTemplateField(uTmplFlds[i]);
        if(Fld.FModified) then
        begin
          msg := Fld.SaveError;
          if(msg <> '') then
          begin
            if(not assigned(Errors)) then
            begin
              Errors := TStringList.Create;
              Errors.Add('The following template field save errors have occurred:');
              Errors.Add('');
            end;
            Errors.Add('  ' + Fld.FldName + ': ' + msg);
          end;
        end;
      end;
    finally
      if(assigned(Errors)) then
      begin
        Result := Errors.Text;
        Errors.Free;
      end;
    end;
  end;
end;

procedure ClearModifiedTemplateFields;
var
  i: integer;
  Fld: TTemplateField;

begin
  if(assigned(uTmplFlds)) then
  begin
    for i := uTmplFlds.Count-1 downto 0 do
    begin
      Fld := TTemplateField(uTmplFlds[i]);
      if(assigned(Fld)) and (Fld.FModified) then
      begin
        if Fld.FLocked then
          UnlockTemplateField(Fld.FID);
        Fld.Free;
      end;
    end;
  end;
end;

function AnyTemplateFieldsModified: boolean;
var
  i: integer;

begin
  Result := FALSE;
  if(assigned(uTmplFlds)) then
  begin
    for i := 0 to uTmplFlds.Count-1 do
    begin
      if(TTemplateField(uTmplFlds[i]).FModified) then
      begin
        Result := TRUE;
        break;
      end;
    end;
  end;
end;

procedure ListTemplateFields(const AText: string; ErrorList, FieldList: TStrings);
var
  i, j, k, dlen, EmptyCount: integer;
  tmp, fld: string;
  TmpList, SplitList, BadList: TStringList;
  InactiveList, MissingList: TStringList;
  FldObj: TTemplateField;
  IsBad, IsSplit, doFields, doErrors: boolean;

  procedure add2(sl: TStrings; str: string);
  begin
    if assigned(sl) and (sl.IndexOf(str) < 0) then
      sl.Add(str)
  end;

  procedure addError(sl: TStrings; str: string);
  begin
    if doErrors then
      add2(sl, '  "' + str + '"');
  end;

  procedure Validate;
  begin
    j := pos(TemplateFieldBeginSignature, fld);
    if j > 0 then
    begin
      delete(fld, j, MaxInt);
      IsBad := True;
    end;
  end;

  procedure bump;
  begin
    if(ErrorList.Count > 0) then
      ErrorList.Add('');
  end;

  procedure AddErrorList(sl: TStringList; txt: string);
  begin
    if assigned(sl) and (sl.Count > 0) then
    begin
      bump;
      ErrorList.Add(txt);
      ErrorList.AddStrings(sl);
    end;
  end;

begin
  // These 2 lines broke export - called recursively to add children to list
  // if assigned(ErrorList) then ErrorList.Clear;
  // if assigned(FieldList) then FieldList.Clear;
  if(AText = '') then exit;
  doFields := assigned(FieldList);
  doErrors := assigned(ErrorList);
  if (not doFields) and (not doErrors) then
    exit;
  EmptyCount := 0;
  if doErrors then
  begin
    InactiveList := TStringList.Create;
    SplitList := TStringList.Create;
    MissingList := TStringList.Create;
    BadList := TStringList.Create;
  end
  else
  begin
    InactiveList := nil;
    SplitList := nil;
    MissingList := nil;
    BadList := nil;
  end;
  try
    TmpList := TStringList.Create;
    try
      TmpList.Text := AText;
      for k := 0 to TmpList.Count-1 do
      begin
        tmp := TmpList[k];
        repeat
          i := pos(TemplateFieldBeginSignature, tmp);
          if(i > 0) then
          begin
            fld := '';
            IsBad := False; // had no trailing TemplateFieldEndSignature
            IsSplit := False; // Split across lines, IsBad takes precedence
            j := pos(TemplateFieldEndSignature, tmp, i + TemplateFieldSignatureLen);
            if j > 0 then
            begin
              fld := copy(tmp,i + TemplateFieldSignatureLen, j - i - TemplateFieldSignatureLen);
              Validate;
            end
            else
            begin
              fld := copy(tmp, i + TemplateFieldSignatureLen, MaxInt);
              Validate;
              if (k >= TmpList.Count-1) then
                IsBad := True;
              if not IsBad then
              begin
                j := pos(TemplateFieldEndSignature, TmpList[k+1]);
                if j > 0 then
                begin
                  fld := fld + copy(TmpList[k + 1], 1, j - TemplateFieldSignatureEndLen);
                  Validate;
                  if not IsBad then
                    IsSplit := True;
                end
                else
                  IsBad := True;
              end;
            end;
            dlen := length(fld) + TemplateFieldSignatureLen;
            if (not IsBad) and (not IsSplit) then
              inc(dlen, TemplateFieldSignatureEndLen);
            delete(tmp, i, dlen);
            if IsBad then
              AddError(BadList, fld)
            else if IsSplit then
              AddError(SplitList, fld)
            else if fld = '' then
              inc(EmptyCount)
            else
            begin
              FldObj := GetTemplateField(fld, FALSE);
              if assigned(FldObj) then
              begin
                if FldObj.Inactive then
                  AddError(InactiveList, fld)
                else if doFields then
                  Add2(FieldList, fld);
              end
              else
                AddError(MissingList, fld);
            end;
          end;
        until (i = 0);
      end;
    finally
      TmpList.Free;
    end;
    if doErrors then
    begin
      AddErrorList(MissingList, 'Template fields not found:');
      AddErrorList(InactiveList, 'Inactive template fields found:');
      AddErrorList(SplitList, 'Template fields split onto different lines:');
      AddErrorList(BadList, 'Template fields starting with "' +
          TemplateFieldBeginSignature + '" with no ending "' +
          TemplateFieldEndSignature + '":');
      if (EmptyCount > 0) then
      begin
        bump;
        if(EmptyCount = 1) then
          tmp := 'was one'
        else
          tmp := 'were ' + IntToStr(EmptyCount);
        tmp := 'There ' + tmp + ' empty template field';
        if(EmptyCount > 1) then
          tmp := tmp + 's';
        ErrorList.Add(tmp + '.');
      end;
    end;
  finally
    if doErrors then
    begin
      BadList.Free;
      MissingList.Free;
      SplitList.Free;
      InactiveList.Free;
    end;
  end;
end;

function BoilerplateTemplateFieldsOK(const AText: string; Msg: string = ''): boolean;
var
  tmp, Errors, tested: TStringList;
  btns: TMsgDlgButtons;
  fieldPath: string;

  procedure CheckNestedFields(const txt: string);
  var
    i, j: integer;
    Fields: TStringList;
    fld: TTemplateField;

  begin
    Fields := TStringList.Create;
    try
      ListTemplateFields(txt, Errors, Fields);
      if Errors.Count = 0 then
      begin
        for i := 0 to Fields.Count-1 do
        begin
          if tested.IndexOf(Fields[i]) < 0 then
          begin
            tested.Add(Fields[i]);
            fld := GetTemplateField(Fields[i], False);
            if assigned(fld) then
            begin
              fieldPath := fieldPath + ' | ' + Fields[i];
              tmp.Clear;
              Fld.ErrorCheckText(tmp);
              CheckNestedFields(tmp.Text);
              if Errors.Count > 0 then
                break;
              j := length(fieldPath);
              while(fieldPath[j] <> '|') do
                dec(j);
              fieldPath := copy(fieldPath,1,j-2);
            end;
          end;
        end;
      end;
    finally
      Fields.Free;
    end;
  end;

begin
  Result := True;
  Errors := TStringList.Create;
  tmp := TStringList.Create;
  tested := TStringList.Create;
  try
    CheckNestedFields(AText);
    if(Errors.Count > 0) then
    begin
      if length(fieldPath)>0 then
      begin
        delete(fieldPath,1,3);
        Errors.Insert(0,'Errors found in Template Field ' + fieldPath + ':' + CRLF);
      end;
      if(Msg = 'OK') then
        btns := [mbOK]
      else
      begin
        btns := [mbAbort, mbIgnore];
        Errors.Add('');
        if(Msg = '') then
          Msg := 'text insertion';
        Errors.Add('Do you want to Abort ' + Msg + ', or Ignore the error and continue?');
      end;
//      Result := (MessageDlg(Errors.Text, mtError, btns, 0) = mrIgnore);
      Result := (InfoDlg(Errors.Text, 'Template Field Errors', mtError, btns) = mrIgnore);
    end;
  finally
    tested.Free;
    tmp.Free;
    Errors.Free;
  end;
end;

procedure EnsureText(edt: TEdit; ud: TUpDown);
var
  v: integer;
  s: string;

begin
  if assigned(ud.Associate) then
  begin
    v := StrToIntDef(edt.Text, ud.Position);
    if (v < ud.Min) or (v > ud.Max) then
      v := ud.Position;
    s := IntToStr(v);
    if edt.Text <> s then
      edt.Text := s;
  end;
  edt.SelStart := edt.GetTextLen;
end;

function TemplateFieldCode2Field(const Code: string): TTemplateFieldType;
var
  typ: TTemplateFieldType;

begin
  Result := dftUnknown;
  for typ := low(TTemplateFieldType) to high(TTemplateFieldType) do
    if Code = TemplateFieldTypeCodes[typ] then
    begin
      Result := typ;
      break;
    end;
end;

function TemplateDateCode2DateType(const Code: string): TTmplFldDateType;
var
  typ: TTmplFldDateType;

begin
  Result := dtUnknown;
  for typ := low(TTmplFldDateType) to high(TTmplFldDateType) do
    if Code = TemplateFieldDateCodes[typ] then
    begin
      Result := typ;
      break;
    end;
end;

procedure ConvertCodes2Text(sl: TStrings; Short: boolean);
var
  i: integer;
  tmp, output: string;
  ftype: TTemplateFieldType;
  dtype: TTmplFldDateType;

begin
  for i := 0 to sl.Count-1 do
  begin
    tmp := sl[i];
    if piece(tmp,U,4) = BOOLCHAR[TRUE] then
      output := '* '
    else
      output := '  ';
    ftype := TemplateFieldCode2Field(Piece(tmp, U, 3));
    if ftype = dftDate then
    begin
      dtype := TemplateDateCode2DateType(Piece(tmp, U, 5));
      output := output + TemplateDateTypeDesc[dtype, short];
    end
    else
      output := output + TemplateFieldTypeDesc[ftype, short];
    SetPiece(tmp, U, 3, output);
    sl[i] := tmp;
  end;
end;

{ TTemplateField }

constructor TTemplateField.Create(AData: TStrings);
var
  tmp, p1: string;
  AFID, i,idx,cnt: integer;

begin
  AFID := 0;
  if(assigned(AData)) then
  begin
    if AData.Count > 0 then
      AFID := StrToIntDef(AData[0],0);
    if(AFID > 0) and (AData.Count > 1) then
    begin
      FID := IntToStr(AFID);
      FFldName := Piece(AData[1],U,1);
      FFldType := TemplateFieldCode2Field(Piece(AData[1],U,2));
      FInactive := (Piece(AData[1],U,3) = '1');
      FMaxLen := StrToIntDef(Piece(AData[1],U,4),0);
      FEditDefault := Piece(AData[1],U,5);
      FLMText := Piece(AData[1],U,6);
      idx := StrToIntDef(Piece(AData[1],U,7),0);
      cnt := 0;
      for i := 2 to AData.Count-1 do
      begin
        tmp := AData[i];
        p1 := Piece(tmp,U,1);
        tmp := Piece(tmp,U,2);
        if(p1 = 'D') then
          FNotes := FNotes + tmp + CRLF
        else
        if(p1 = 'U') then
          FURL := tmp
        else
        if(p1 = 'I') then
        begin
          inc(cnt);
          FItems := FItems + tmp + CRLF;
          if(cnt=idx) then
            FItemDefault := tmp;
        end;
      end;
      FRequired  := (Piece(AData[1],U,8) = '1');
      FSepLines  := (Piece(AData[1],U,9) = '1');
      FTextLen   := StrToIntDef(Piece(AData[1],U,10),0);
      FIndent    := StrToIntDef(Piece(AData[1],U,11),0);
      FPad       := StrToIntDef(Piece(AData[1],U,12),0);
      FMinVal    := StrToIntDef(Piece(AData[1],U,13),0);
      FMaxVal    := StrToIntDef(Piece(AData[1],U,14),0);
      FIncrement := StrToIntDef(Piece(AData[1],U,15),0);
      FDateType  := TemplateDateCode2DateType(Piece(AData[1],U,16));
      FCommunityCare := (Piece(AData[1],U,17) = '1');
      FModified  := FALSE;
      FNameChanged := FALSE;
    end;
  end;
  if(AFID = 0) then
  begin
    inc(uNewTemplateFieldIDCnt);
    FID := IntToStr(-uNewTemplateFieldIDCnt);
    FFldName := NewTemplateField;
    FModified := TRUE;
  end;
  if(not assigned(uTmplFlds)) then
    uTmplFlds := TList.Create;
  uTmplFlds.Add(Self);
end;

function TTemplateField.GetTemplateFieldDefault: string;
begin
    case FFldType of
      dftEditBox, dftNumber:  Result := FEditDefault;

      dftComboBox,
      dftButton,
      dftCheckBoxes,          {Clear out embedded fields}
      dftRadioButtons:        Result := StripEmbedded(FItemDefault);

      dftDate:                if FEditDefault <> '' then Result := FEditDefault;

      dftHyperlink, dftText:  if FEditDefault <> '' then
                                 Result := StripEmbedded(FEditDefault)
                              else
                                 Result := URL;

      dftWP:                  Result := Items;
    end;
end;

function TTemplateField.GetTIUParam: Integer;
begin
  result := StrToIntDef(systemParameters.AsType<String>('tmRequiredFldsOff'), 1);
end;

procedure TTemplateField.CreateDialogControls(Entry: TTemplateDialogEntry;
                                     var Index: Integer; CtrlID: integer);

var
  i, Aht, w, tmp, AWdth: integer;
  STmp: string;
  TmpSL: TStringList;
  edt: TEdit;
  cbo: TORComboBox;
  cb: TORCheckBox;
  btn: TfraTemplateFieldButton;
  dbox: TORDateBox;
  dcbo: TORDateCombo;
  lbl: TCPRSTemplateFieldLabel;
  re: TRichEdit;
  pnl: TCPRSDialogNumber;
  DefDate: TFMDateTime;
  ctrl: TControl;

  function wdth: integer;
  begin
    if(Awdth < 0) then
      Awdth := FontWidthPixel(Entry.FFont.Handle);
    Result := Awdth;
  end;

  function ht: integer;
  begin
    if(Aht < 0) then
      Aht := FontHeightPixel(Entry.FFont.Handle);
    Result := Aht;
  end;

  procedure UpdateIndents(AControl: TControl);
  var
    idx: integer;

  begin
    if (FIndent > 0) or (FPad > 0) then
    begin
      idx := Entry.FIndents.IndexOfObject(AControl);
      if idx < 0 then
        Entry.FIndents.AddObject(IntToStr(FIndent * wdth) + U + IntToStr(FPad), AControl);
    end;
  end;

begin
  if(not FInactive) and (FFldType <> dftUnknown) then
  begin
    AWdth := -1;
    Aht := -1;
    ctrl := nil;

    case FFldType of
      dftEditBox:
        begin
          edt := TCPRSDialogFieldEdit.Create(nil);
          (edt as ICPRSDialogComponent).RequiredField := Required;
          edt.Parent := Entry.FPanel;
          edt.BorderStyle := bsNone;
          edt.Height := ht;
          edt.Width := (wdth * Width + 4);
          if FTextLen > 0 then
            edt.MaxLength := FTextLen
          else
            edt.MaxLength := FMaxLen;
          edt.Text := FEditDefault;
          edt.Tag := CtrlID;
          edt.OnChange := Entry.DoChange;
          UpdateColorsFor508Compliance(edt, TRUE);
          ctrl := edt;
        end;

      dftComboBox:
        begin
          cbo := TCPRSDialogComboBox.Create(nil);
          (cbo as ICPRSDialogComponent).RequiredField := Required;
          cbo.Parent := Entry.FPanel;
          cbo.TemplateField := TRUE;
          w := Width;
          cbo.MaxLength := w;
          if FTextLen > 0 then
            cbo.MaxLength := FTextLen
          else
            cbo.ListItemsOnly := TRUE;
          {Clear out embedded fields}
          cbo.Items.Text := StripEmbedded(Items);
          cbo.SelectByID(StripEmbedded(FItemDefault));
          cbo.Tag := CtrlID;
          cbo.OnChange := Entry.DoChange;

          if cbo.Items.Count > 12 then
          begin
            cbo.Width := (wdth * w) + ScrollBarWidth + 8;
            cbo.DropDownCount := 12;
          end
          else
          begin
            cbo.Width := (wdth * w) + 18;
            cbo.DropDownCount := cbo.Items.Count;
          end;
          UpdateColorsFor508Compliance(cbo, TRUE);
          ctrl := cbo;
        end;

      dftButton:
        begin
          btn := TfraTemplateFieldButton.Create(nil);
          (btn as ICPRSDialogComponent).RequiredField := Required;
          btn.Parent := Entry.FPanel;
          {Clear out embedded fields}
          btn.Items.Text := StripEmbedded(Items);
          btn.ButtonText := StripEmbedded(FItemDefault);
          btn.Height := ht;
          btn.Width := (wdth * Width) + 6;
          btn.Tag := CtrlID;
          btn.OnChange := Entry.DoChange;
          UpdateColorsFor508Compliance(btn);
          ctrl := btn;
        end;

      dftCheckBoxes, dftRadioButtons:
        begin
          if FFldType = dftRadioButtons then
            inc(uRadioGroupIndex);
          TmpSL := TStringList.Create;
          try
            {Clear out embedded fields}
            TmpSL.Text := StripEmbedded(Items);
            for i := 0 to TmpSL.Count-1 do
            begin
              cb := TCPRSDialogCheckBox.Create(nil);
              if i = 0 then
                (cb as ICPRSDialogComponent).RequiredField := Required;
              cb.Parent := Entry.FPanel;
              cb.Caption := TmpSL[i];
              cb.AutoSize := TRUE;
              cb.AutoAdjustSize;
  //              cb.AutoSize := FALSE;
  //              cb.Height := ht;
              if FFldType = dftRadioButtons then
              begin
                cb.GroupIndex := uRadioGroupIndex;
                cb.RadioStyle := TRUE;
              end;
              if(TmpSL[i] = StripEmbedded(FItemDefault)) then
                cb.Checked := TRUE;
              cb.Tag := CtrlID;
              if FSepLines and (FFldType in SepLinesTypes) then
                cb.StringData := NewLine;
              cb.OnClick := Entry.DoChange;
              UpdateColorsFor508Compliance(cb);
              inc(Index);
              Entry.FControls.InsertObject(Index, '', cb);

              if TIUParam = 0 then // 20100706 - VISTAOR-24208 FH 2021/02/12
                dmRF.AddFieldControl(self,cb,IntToStr(ctrlID)); // NSR20100706 AA 2015/10/09. Adding Fld.FID to track Fld by control

              if (i=0) or FSepLines then
                UpdateIndents(cb);
            end;
          finally
            TmpSL.Free;
          end;
        end;

      dftDate:
        begin
          if FEditDefault <> '' then
            DefDate := StrToFMDateTime(FEditDefault)
          else
            DefDate := 0;
          if FDateType in DateComboTypes then
          begin
            dcbo := TCPRSDialogDateCombo.Create(nil);
            (dcbo as ICPRSDialogComponent).RequiredField := Required;
            dcbo.Parent := Entry.FPanel;
            dcbo.Tag := CtrlID;
            dcbo.IncludeBtn := (FDateType = dtCombo);
            dcbo.IncludeDay := (FDateType = dtCombo);
            dcbo.IncludeMonth := (FDateType <> dtYear);
            dcbo.FMDate := DefDate;
            dcbo.TemplateField := TRUE;
            dcbo.OnChange := Entry.DoChange;
            UpdateColorsFor508Compliance(dcbo, TRUE);
            ctrl := dcbo;
          end
          else
          begin
            dbox := TCPRSDialogDateBox.Create(nil);
            (dbox as ICPRSDialogComponent).RequiredField := Required;
            dbox.Parent := Entry.FPanel;
            dbox.Tag := CtrlID;
            dbox.DateOnly := (FDateType = dtDate);
            dbox.RequireTime := (FDateType = dtDateReqTime);
            dbox.TemplateField := TRUE;
            dbox.FMDateTime := DefDate;
            if (FDateType = dtDate) then
              tmp := 11
            else
              tmp := 17;
            dbox.Width := (wdth * tmp) + 18;
            dbox.OnChange := Entry.DoChange;
            UpdateColorsFor508Compliance(dbox, TRUE);
            ctrl := dbox;
          end;
        end;

      dftNumber:
        begin
          pnl := TCPRSDialogNumber.CreatePanel(nil);
          (pnl as ICPRSDialogComponent).RequiredField := Required;
          pnl.Parent := Entry.FPanel;
          pnl.BevelOuter := bvNone;
          pnl.Tag := CtrlID;
          pnl.Edit.Height := ht;
          pnl.Edit.Width := (wdth * 5 + 4);
          pnl.UpDown.Min := MinVal;
          pnl.UpDown.Max := MaxVal;
          pnl.UpDown.Min := MinVal; // Both ud.Min settings are needeed!
          i := Increment;
          if i < 1 then i := 1;
          pnl.UpDown.Increment := i;
          pnl.UpDown.Position := StrToIntDef(EditDefault, 0);
          pnl.Edit.OnChange := Entry.UpDownChange;
          pnl.Height := pnl.Edit.Height;
          pnl.Width := pnl.Edit.Width + pnl.UpDown.Width;
          UpdateColorsFor508Compliance(pnl, TRUE);
          //CQ 17597 wat
          pnl.Edit.Align := alLeft;
          pnl.UpDown.Align := alLeft;
          //end 17597
          ctrl := pnl;
        end;

      dftHyperlink, dftText:
        begin
          if (FFldType = dftHyperlink) and User.WebAccess then
            lbl := TCPRSDialogHyperlinkLabel.Create(nil)
          else
            lbl := TCPRSTemplateFieldLabel.Create(nil);
          lbl.Parent := Entry.FPanel;
          lbl.ShowAccelChar := FALSE;
          lbl.Exclude := FSepLines;
          if (FFldType = dftHyperlink) then
          begin
            if FEditDefault <> '' then
              lbl.Caption := StripEmbedded(FEditDefault)
            else
              lbl.Caption := URL;
          end
          else
          begin
            STmp := StripEmbedded(Items);
            if copy(STmp,length(STmp)-1,2) = CRLF then
              delete(STmp,length(STmp)-1,2);
            lbl.Caption := STmp;
          end;
          if lbl is TCPRSDialogHyperlinkLabel then
            TCPRSDialogHyperlinkLabel(lbl).Init(FURL);
          lbl.Tag := CtrlID;
          UpdateColorsFor508Compliance(lbl);
          ctrl := lbl;
        end;

      dftWP:
        begin
          re := TCPRSDialogRichEdit.Create(nil);
          (re as ICPRSDialogComponent).RequiredField := Required;
          re.Parent := Entry.FPanel;
          re.Tag := CtrlID;
          tmp := FMaxLen;
          if tmp < 5 then
            tmp := 5;
          re.Width := wdth * tmp;
          tmp := FTextLen;
          if tmp < 2 then
            tmp := 2
          else
          if tmp > MaxTFWPLines then
            tmp := MaxTFWPLines;
          re.Height := ht * tmp;
          re.BorderStyle := bsNone;
          re.ScrollBars := ssVertical;
          re.Lines.Text := Items;
          re.OnChange := Entry.DoChange;
          UpdateColorsFor508Compliance(re, TRUE);
          ctrl := re;
        end;
    end;
    if assigned(ctrl) then
    begin
      inc(Index);
      Entry.FControls.InsertObject(Index, '', ctrl);

      if TIUParam = 0 then // 20100706 - VISTAOR-24208 FH 2021/02/12
        dmRF.addFieldControl(self,TWinControl(ctrl),IntToStr(ctrlID)); // NSR20100706  AA 2015/10/09 adding Fld.FID to track Fld by control

      UpdateIndents(ctrl);
    end;
  end;
end;

function TTemplateField.CanModify: boolean;
begin
  if((not FModified) and (not FLocked) and (StrToIntDef(FID,0) > 0)) then
  begin
    FLocked := LockTemplateField(FID);
    Result := FLocked;
    if(not FLocked) then
      ShowMsg('Template Field ' + FFldName + ' is currently being edited by another user.');
  end
  else
    Result := TRUE;
  if(Result) then FModified := TRUE;
end;

procedure TTemplateField.SetEditDefault(const Value: string);
begin
  if(FEditDefault <> Value) and CanModify then
// DRM - I9259852FY16/529128 - 2017/7/21 - Restrict default value to printable ASCII characters + TAB
//    FEditDefault := Value;
    FEditDefault := FilteredString(Value);
// DRM - I9259852FY16/529128 - 2017/7/21 ---
end;

procedure TTemplateField.SetFldName(const Value: string);
begin
  if(FFldName <> Value) and CanModify then
  begin
    FFldName := Value;
    FNameChanged := TRUE;
  end;
end;

procedure TTemplateField.SetFldType(const Value: TTemplateFieldType);
begin
  if(FFldType <> Value) and CanModify then
  begin
    FFldType := Value;
    if(Value = dftEditBox) then
    begin
      if (FMaxLen < 1) then
        FMaxLen := 1;
      if FTextLen < FMaxLen then
        FTextLen := FMaxLen;
    end
    else
    if(Value = dftHyperlink) and (FURL = '') then
      FURL := 'http://'
    else
    if(Value = dftComboBox) and (FMaxLen < 1) then
    begin
      FMaxLen := Width;
      if FMaxLen < 1 then
        FMaxLen := 1;
    end
    else
    if(Value = dftWP) then
    begin
      if (FMaxLen = 0) then
        FMaxLen := MAX_WRAP_WIDTH
      else
      if (FMaxLen < 5) then
          FMaxLen := 5;
      if FTextLen < 2 then
        FTextLen := 2;
    end
    else
    if(Value = dftDate) and (FDateType = dtUnknown) then
      FDateType := dtDate;
  end;
end;

procedure TTemplateField.SetID(const Value: string);
begin
//  if(FID <> Value) and CanModify then
    FID := Value;
end;

procedure TTemplateField.SetInactive(const Value: boolean);
begin
  if(FInactive <> Value) and CanModify then
    FInactive := Value;
end;

procedure TTemplateField.SetItemDefault(const Value: string);
begin
  if(FItemDefault <> Value) and CanModify then
    FItemDefault := Value;
end;

procedure TTemplateField.SetItems(const Value: string);
begin
  if(FItems <> Value) and CanModify then
    FItems := Value;
end;

procedure TTemplateField.SetLMText(const Value: string);
begin
  if(FLMText <> Value) and CanModify then
    FLMText := Value;
end;

procedure TTemplateField.SetMaxLen(const Value: integer);
begin
  if(FMaxLen <> Value) and CanModify then
    FMaxLen := Value;
end;

procedure TTemplateField.SetNotes(const Value: string);
begin
  if(FNotes <> Value) and CanModify then
    FNotes := Value;
end;

function TTemplateField.SaveError: string;
var
  TmpSL, FldSL: TStringList;
  AID,Res: string;
  idx, i: integer;
  IEN64: Int64;
  NewRec: boolean;

begin
  if(FFldName = NewTemplateField) then
  begin
    Result := 'Template Field can not be named "' + NewTemplateField + '"';
    exit;
  end;
  Result := '';
  NewRec := (StrToIntDef(FID,0) < 0);
  if(FModified or NewRec) then
  begin
    TmpSL := TStringList.Create;
    try
      FldSL := TStringList.Create;
      try
        if(StrToIntDef(FID,0) > 0) then
          AID := FID
        else
          AID := '0';
        FldSL.Add('.01='+FFldName);
        FldSL.Add('.02='+TemplateFieldTypeCodes[FFldType]);
        FldSL.Add('.03='+BOOLCHAR[FInactive]);
        FldSL.Add('.04='+IntToStr(FMaxLen));
        FldSL.Add('.05='+FEditDefault);
        FldSL.Add('.06='+FLMText);
        idx := -1;
        if(FItems <> '') and (FItemDefault <> '') then
        begin
          TmpSL.Text := FItems;
          for i := 0 to TmpSL.Count-1 do
            if(FItemDefault = TmpSL[i]) then
            begin
              idx := i;
              break;
            end;
        end;
        FldSL.Add('.07='+IntToStr(Idx+1));
        FldSL.Add('.08='+BOOLCHAR[fRequired]);
        FldSL.Add('.09='+BOOLCHAR[fSepLines]);
        FldSL.Add('.1=' +IntToStr(FTextLen));
        FldSL.Add('.11='+IntToStr(FIndent));
        FldSL.Add('.12='+IntToStr(FPad));
        FldSL.Add('.13='+IntToStr(FMinVal));
        FldSL.Add('.14='+IntToStr(FMaxVal));
        FldSL.Add('.15='+IntToStr(FIncrement));
        if FDateType = dtUnknown then
          FldSL.Add('.16=@')
        else
          FldSL.Add('.16='+TemplateFieldDateCodes[FDateType]);

        if FURL='' then
          FldSL.Add('3=@')
        else
          FldSL.Add('3='+FURL);

        if(FNotes <> '') or (not NewRec) then
        begin
          if(FNotes = '') then
            FldSL.Add('2,1=@')
          else
          begin
            TmpSL.Text := FNotes;
            for i := 0 to TmpSL.Count-1 do
              FldSL.Add('2,'+IntToStr(i+1)+',0='+TmpSL[i]);
          end;
        end;
        if((FItems <> '') or (not NewRec)) then
        begin
          if(FItems = '') then
            FldSL.Add('10,1=@')
          else
          begin
            TmpSL.Text := FItems;
            for i := 0 to TmpSL.Count-1 do
              FldSL.Add('10,'+IntToStr(i+1)+',0='+TmpSL[i]);
          end;
        end;

        Res := UpdateTemplateField(AID, FldSL);
        IEN64 := StrToInt64Def(Piece(Res,U,1),0);
        if(IEN64 > 0) then
        begin
          if(NewRec) then
            FID := IntToStr(IEN64)
          else
            UnlockTemplateField(FID);
          FModified := FALSE;
          FNameChanged := FALSE;
          FLocked := FALSE;
        end
        else
          Result := Piece(Res, U, 2);
      finally
        FldSL.Free;
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

procedure TTemplateField.Assign(AFld: TTemplateField);
begin
  FMaxLen        := AFld.FMaxLen;
  FFldName       := AFld.FFldName;
  FLMText        := AFld.FLMText;
  FEditDefault   := AFld.FEditDefault;
  FNotes         := AFld.FNotes;
  FItems         := AFld.FItems;
  FInactive      := AFld.FInactive;
  FItemDefault   := AFld.FItemDefault;
  FFldType       := AFld.FFldType;
  FRequired      := AFld.FRequired;
  FSepLines      := AFld.FSepLines;
  FTextLen       := AFld.FTextLen;
  FIndent        := AFld.FIndent;
  FPad           := AFld.FPad;
  FMinVal        := AFld.FMinVal;
  FMaxVal        := AFld.FMaxVal;
  FIncrement     := AFld.FIncrement;
  FDateType      := AFld.FDateType;
  FURL           := AFld.FURL;
  FCommunityCare := AFld.FCommunityCare;
end;

function TTemplateField.Width: integer;
var
  i, ilen: integer;
  TmpSL: TStringList;

begin
  if(FFldType = dftEditBox) then
    Result := FMaxLen
  else
  begin
    if FMaxLen > 0 then
      Result := FMaxLen
    else
    begin
      Result := -1;
      TmpSL := TStringList.Create;
      try
        TmpSL.Text := StripEmbedded(FItems);
        for i := 0 to TmpSL.Count-1 do
        begin
          ilen := length(TmpSL[i]);
          if(Result < ilen) then
            Result := ilen;
        end;
      finally
        TmpSL.Free;
      end;
    end;
  end;
  if Result > MaxTFEdtLen then
    Result := MaxTFEdtLen;
end;

destructor TTemplateField.Destroy;
begin
  uTmplFlds.Remove(Self);
  inherited;
end;

procedure TTemplateField.ErrorCheckText(sl: TStrings);
begin
  case FFldType of
    dftEditBox,
    dftDate:  sl.Add(FEditDefault);
//      dftNumber,
    dftHyperlink: begin
                    sl.Add(FEditDefault);
                    sl.Add(FURL);
                  end;

    dftComboBox,
    dftButton,
    dftCheckBoxes,
    dftRadioButtons:  begin
                        sl.Add(FItems);
                        sl.Add(FItemDefault);
                      end;

    dftWP,
    dftText: sl.Add(FItems);
//      dftScreenReader
  end;
  sl.Add(FLMText);
end;

procedure TTemplateField.SetRequired(const Value: boolean);
begin
  if(FRequired <> Value) and CanModify then
    FRequired := Value;
end;

function TTemplateField.NewField: boolean;
begin
  Result := (StrToIntDef(FID,0) <= 0);
end;

procedure TTemplateField.SetSepLines(const Value: boolean);
begin
  if(FSepLines <> Value) and CanModify then
    FSepLines := Value
end;

procedure TTemplateField.SetIncrement(const Value: integer);
begin
  if(FIncrement <> Value) and CanModify then
    FIncrement := Value;
end;

procedure TTemplateField.SetIndent(const Value: integer);
begin
  if(FIndent <> Value) and CanModify then
    FIndent := Value;
end;

procedure TTemplateField.SetMaxVal(const Value: integer);
begin
  if(FMaxVal <> Value) and CanModify then
    FMaxVal := Value;
end;

procedure TTemplateField.SetMinVal(const Value: integer);
begin
  if(FMinVal <> Value) and CanModify then
    FMinVal := Value;
end;

procedure TTemplateField.SetPad(const Value: integer);
begin
  if(FPad <> Value) and CanModify then
    FPad := Value;
end;

procedure TTemplateField.SetTextLen(const Value: integer);
begin
  if(FTextLen <> Value) and CanModify then
    FTextLen := Value;
end;

procedure TTemplateField.SetURL(const Value: string);
begin
  if(FURL <> Value) and CanModify then
    FURL := Value;
end;

function TTemplateField.GetRequired: boolean;
begin
  if FFldType in NoRequired then
    Result := FALSE
  else
    Result := FRequired;
end;

procedure TTemplateField.SetDateType(const Value: TTmplFldDateType);
begin
  if(FDateType <> Value) and CanModify then
    FDateType := Value;
end;

{ TTemplateDialogEntry }
const
  EOL_MARKER = #182;
  SR_BREAK   = #186;

procedure TTemplateDialogEntry.PanelDestroy(Sender: TObject);
var
  idx: integer;
begin
  FPanel := nil; // FPanel is no longer owned by TTemplateDialogEntry!
  idx := uEntries.IndexOf(FID);
  if(idx >= 0) then uEntries.Delete(idx);
  if Assigned(FOldPanelDestroy) then
    FOldPanelDestroy(Sender);
  Free;
end;

constructor TTemplateDialogEntry.Create(AParent: TWinControl; AID, Text: string);
var
  CtrlID, idx, i, j, flen: integer;
  txt, FldName: string;
  Fld: TTemplateField;
begin
  FID := AID;
  FText := Text;
  FControls := TStringList.Create;
  FIndents := TStringList.Create;
  FFont := TFont.Create;
  FFont.Assign(TORExposedControl(AParent).Font);
  FControls.Text := Text;
  if(FControls.Count > 1) then
  begin
    for i := 1 to FControls.Count-1 do
      FControls[i] := EOL_MARKER + FControls[i];
    if not ScreenReaderSystemActive then
      StripScreenReaderCodes(FControls);
  end;
  FFirstBuild := TRUE;

  if Assigned(AParent) then
  begin
    FPanel := TDlgFieldPanel.Create(AParent.Owner);
    FPanel.Parent := AParent;
    FPanel.BevelOuter := bvNone;
    FPanel.Caption := '';
    FPanel.Font.Assign(FFont);
    UpdateColorsFor508Compliance(FPanel, TRUE);
  end;

  idx := 0;
  while (idx < FControls.Count) do
  begin
    txt := FControls[idx];
    i := pos(TemplateFieldBeginSignature, txt);
    if(i > 0) then
    begin
      if(copy(txt, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then
      begin
        CtrlID := StrToIntDef(copy(txt, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(txt,i + TemplateFieldSignatureLen, FieldIDLen);
      end
      else
        CtrlID := 0;
      j := pos(TemplateFieldEndSignature, copy(txt, i + TemplateFieldSignatureLen, MaxInt));
      if(j > 0) then
      begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        FldName := copy(txt, i + TemplateFieldSignatureLen, flen);
        Fld := GetTemplateField(FldName, FALSE);
        delete(txt,i,flen + TemplateFieldSignatureLen + 1);
        if(assigned(Fld)) then
        begin
          FControls[idx] := copy(txt,1,i-1);
          if(Fld.Required) then
          begin
            if ScreenReaderSystemActive then
            begin
              if Fld.FFldType in [dftCheckBoxes, dftRadioButtons] then
                FControls[idx] := FControls[idx] + ScreenReaderStopCode;
            end;
            FControls[idx] := FControls[idx] + '*';
          end;
          Fld.CreateDialogControls(Self, idx, CtrlID);  // Creates controls
          FControls.Insert(idx+1,copy(txt,i,MaxInt));
        end
        else
        begin
          FControls[idx] := txt;
          dec(idx);
        end;
      end
      else
      begin
        delete(txt,i,TemplateFieldSignatureLen);
        FControls[idx] := txt;
        dec(idx);
      end;
    end;
    inc(idx);
  end;
  if ScreenReaderSystemActive then
  begin
    idx := 0;
    while (idx < FControls.Count) do
    begin
      txt := FControls[idx];
      i := pos(ScreenReaderStopCode, txt);
      if i > 0 then
      begin
        FControls[idx] := copy(txt, 1, i-1);
        txt := copy(txt, i + ScreenReaderStopCodeLen, MaxInt);
        FControls.Insert(idx+1, SR_BREAK + txt);
      end;
      inc(idx);
    end;
  end;
end;

destructor TTemplateDialogEntry.Destroy;
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
  KillLabels;
  KillObj(@FControls, TRUE);
  if Assigned(FPanel) then
  begin
    FPanel.Owner.RemoveComponent(FPanel);
    FreeAndNil(FPanel);
  end;
  FreeAndNil(FFont);
  FreeAndNil(FIndents);
  inherited;
end;

procedure TTemplateDialogEntry.DoChange(Sender: TObject);
begin
  if (not FUpdating) and assigned(FOnChange) then
    FOnChange(Self);
end;

function TTemplateDialogEntry.GetControlText(CtrlID: integer; NoCommas: boolean;
  var FoundEntry: boolean; AutoWrap: boolean; emField: string = '';
  CrntLnTxt: String = ''; AutoWrapIndent: integer = 0;
  NoFormat: boolean = false): string;
var
  x, i, j, ind, idx: integer;
  ctrl: TControl;
  Done: boolean;
  iString: string;
  iField: TTemplateField;
  iTemp: TStringList;
  TmpChar, IndPos: integer;
  RtnString, aStr, WrapTxt, TmpCrnt: String;
  TmpEvt: TNotifyEvent;
  TmpSelStart: Integer;

  function GetOriginalItem(istr: string): string;
  begin
    Result := '';
    if emField <> '' then
    begin
      iField := GetTemplateField(emField, false);
      iTemp := nil;
      if iField <> nil then
        try
          iTemp := TStringList.Create;
          iTemp.Text := StripEmbedded(iField.Items);
          x := iTemp.IndexOf(istr);
          if x >= 0 then
          begin
            iTemp.Text := iField.Items;
            Result := iTemp.Strings[x];
          end;
        finally
          iTemp.Free;
        end;
    end;
  end;

begin
  Result := '';
  Done := false;
  ind := -1;
  TmpEvt := nil;
  for i := 0 to FControls.Count - 1 do
  begin
    ctrl := TControl(FControls.Objects[i]);
    if (assigned(ctrl)) and (ctrl.Tag = CtrlID) then
    begin
      FoundEntry := TRUE;
      Done := TRUE;
      if ind < 0 then
      begin
        idx := FIndents.IndexOfObject(ctrl);
        if idx >= 0 then
          ind := StrToIntDef(Piece(FIndents[idx], U, 2), 0)
        else
          ind := 0;
      end;
      if (ctrl is TCPRSTemplateFieldLabel) then
      begin
        if not TCPRSTemplateFieldLabel(ctrl).Exclude then
        begin
          if emField <> '' then
          begin
            iField := GetTemplateField(emField, false);
            case iField.FldType of
              dftHyperlink:
                if iField.EditDefault <> '' then
                  Result := iField.EditDefault
                else
                  Result := iField.URL;
              dftText:
                begin
                  iString := iField.Items;
                  if copy(iString, Length(iString) - 1, 2) = CRLF then
                    Delete(iString, Length(iString) - 1, 2);
                  Result := iString;
                end;
            else { case }
              Result := TCPRSTemplateFieldLabel(ctrl).Caption
            end; { case iField.FldType }
          end { if emField }
          else
            Result := TCPRSTemplateFieldLabel(ctrl).Caption;
        end;
      end
      else
        // !!!!!! CODE ADDED BACK IN - ZZZZZZBELLC !!!!!!
        if (ctrl is TEdit) then
          Result := TEdit(ctrl).Text
        else if (ctrl is TORComboBox) then
        begin
          Result := TORComboBox(ctrl).Text;
          iString := GetOriginalItem(Result);
          if iString <> '' then
            Result := iString;
        end
        else if (ctrl is TORDateCombo) then
          Result := TORDateCombo(ctrl).Text + ':' + FloatToStr(TORDateCombo(ctrl).FMDate)
        else
          { !!!!!! THIS HAS BEEN REMOVED AS IT CAUSED PROBLEMS WITH REMINDER DIALOGS - ZZZZZZBELLC !!!!!!
            if(Ctrl is TORDateBox) then begin
            if TORDateBox(Ctrl).IsValid then
            Result := TORDateBox(Ctrl).Text
            else
            Result := '';
            end else
          }
          // !!!!!! CODE ADDED BACK IN - ZZZZZZBELLC !!!!!!
          if (ctrl is TORDateBox) then
            Result := TORDateBox(ctrl).Text
          else if (ctrl is TRichEdit) then
          begin
            // If we do not need to format this (Reminder values) or there is no indent and not autowrap
            if ((ind = 0) and (not AutoWrap)) or NoFormat then
              //Result := TRichEdit(ctrl).Lines.Text
              Result := TRichEdit(ctrl).Text
            else
            begin
              { for j := 0 to TRichEdit(Ctrl).Lines.Count-1 do
                begin
                if AutoWrap then
                begin
                if(Result <> '') then
                Result := Result + ' ';
                Result := Result + TRichEdit(Ctrl).Lines[j];
                end
                else
                begin
                if(Result <> '') then
                Result := Result + CRLF;
                Result := Result + StringOfChar(' ', ind) + TRichEdit(Ctrl).Lines[j];
                end;
                end; }
              // If the object shares a line with text than take this into account
              If Length(CrntLnTxt) > 0 then
              begin
                // Save the previous version of the text
                RtnString := TRichEdit(ctrl).Text;
                // We nee di disable the onchange event temporarily (Reminders)
                TmpEvt := nil;
                TmpEvt := TRichEdit(ctrl).OnChange;
                TRichEdit(ctrl).OnChange := nil;
                TmpSelStart := TRichEdit(ctrl).SelStart;

                //Account for the header
                TRichEdit(ctrl).Text :=  CrntLnTxt + TRichEdit(ctrl).Text;

              end
              else
                TmpSelStart := 0;
              // If we are adding CTLF and we exceed MAX_WRAP_WIDTH characters
              if (not AutoWrap) then // and ((ind + Length(TRichEdit(ctrl).Lines[0])) > MAX_WRAP_WIDTH) then
              begin
                // If we are sharing a line, do not add leading indent
                WrapTxt := TRichEdit(ctrl).Text;

                // Wrap the text
                If Length(CrntLnTxt) > 0 then
                begin
                  WrapTxt := SafeWrapTextVariable(WrapTxt,
                    CRLF + StringOfChar(' ', ind), [' '], MAX_WRAP_WIDTH,
                    (MAX_WRAP_WIDTH - ind), MAX_WRAP_WIDTH);
                  // SafeWrapTextVariable may add additional CRLF and indents to
                  // WrapTxt.  These need to be added to CrntLnTxt so that when
                  //   Delete(Result, 1, Length(CrntLnTxt));
                  // is called these are removed from Result - withouth this
                  // erroneous xxxxxx can be added to the start of Result.
                  CrntLnTxt := SafeWrapTextVariable(CrntLnTxt,
                    CRLF + StringOfChar(' ', ind), [' '], MAX_WRAP_WIDTH,
                    (MAX_WRAP_WIDTH - ind), MAX_WRAP_WIDTH);
                  if CrntLnTxt.EndsWith(CRLF) then
                    delete(CrntLnTxt, length(CrntLnTxt) - length(CRLF) + 1, MaxInt);
                end
                else
                  WrapTxt := SafeWrapText(WrapTxt,
                    CRLF + StringOfChar(' ', ind), [' '],
                    (MAX_WRAP_WIDTH - ind), MAX_WRAP_WIDTH);

                if Length(CrntLnTxt) > 0 then
                  Result := WrapTxt
                else
                  Result := StringOfChar(' ', ind) +  WrapTxt;
              end
              else
              begin
                // If this is autowrap then wrap with END OF LINE ASCII char
                if AutoWrap then
                begin
                  // If we are sharing a line, do not add leading indent
                  WrapTxt := TRichEdit(ctrl).Text;

                  // Wrap the text
                  If Length(CrntLnTxt) > 0 then
                  begin
                    WrapTxt := SafeWrapTextVariable(WrapTxt,
                      #3 + StringOfChar(' ', ind), [' '], AutoWrapIndent,
                      (AutoWrapIndent - ind), AutoWrapIndent);
                    // SafeWrapTextVariable may add additional CRLF and indents to
                    // WrapTxt.  These need to be added to CrntLnTxt so that when
                    //   Delete(Result, 1, Length(CrntLnTxt));
                    // is called these are removed from Result - withouth this
                    // erroneous xxxxxx can be added to the start of Result.
                    CrntLnTxt := SafeWrapTextVariable(CrntLnTxt,
                      #3 + StringOfChar(' ', ind), [' '], AutoWrapIndent,
                      (AutoWrapIndent - ind), AutoWrapIndent);
                    if CrntLnTxt.EndsWith(CRLF) then
                      delete(CrntLnTxt, length(CrntLnTxt) - length(CRLF) + 1, MaxInt);
                  end
                  else
                    WrapTxt := SafeWrapText(WrapTxt,
                      #3 + StringOfChar(' ', ind), [' '],
                      (AutoWrapIndent - ind), AutoWrapIndent);

                  if Length(CrntLnTxt) > 0 then
                    Result := WrapTxt
                  else
                    Result := StringOfChar(' ', ind) +  WrapTxt;
                end else
                begin
                  // we can fit our text within MAX_WRAP_WIDTH.
                  for j := 0 to TRichEdit(ctrl).Lines.Count - 1 do
                  begin
                    if (Result <> '') then
                      Result := Result + CRLF + StringOfChar(' ', ind);
                    if (Length(CrntLnTxt) = 0) and (Result = '') then
                      Result := StringOfChar(' ', ind) + TRichEdit(ctrl).Lines[j]
                    else
                      Result := Result + TRichEdit(ctrl).Lines[j];
                  end;
                end;
              end;
              // If we are sharing a line then we need to remove its text from the
              if Length(CrntLnTxt) > 0 then
              begin
                Delete(Result, 1, Length(CrntLnTxt));

                // Reset text and change event
                TRichEdit(ctrl).Text := RtnString;
                if TRichEdit(ctrl).SelStart <> TmpSelStart then
                  TRichEdit(ctrl).SelStart := TmpSelStart;
                TRichEdit(ctrl).OnChange := TmpEvt;
                TmpEvt := nil;
              end;
              ind := 0;
            end;
          end
          else
            { !!!!!! THIS HAS BEEN REMOVED AS IT CAUSED PROBLEMS WITH REMINDER DIALOGS - ZZZZZZBELLC !!!!!!
              if(Ctrl is TEdit) then
              Result := TEdit(Ctrl).Text
              else }
            if (ctrl is TORCheckBox) then
            begin
              Done := false;
              if (TORCheckBox(ctrl).Checked) then
              begin
                if (Result <> '') then
                begin
                  if NoCommas then
                    Result := Result + '|'
                  else
                    Result := Result + ', ';
                end;
                iString := GetOriginalItem(TORCheckBox(ctrl).Caption);
                if iString <> '' then
                  Result := Result + iString
                else
                  Result := Result + TORCheckBox(ctrl).Caption;
              end;
            end
            else if (ctrl is TfraTemplateFieldButton) then
            begin
              Result := TfraTemplateFieldButton(ctrl).ButtonText;
              iString := GetOriginalItem(Result);
              if iString <> '' then
                Result := iString;
            end
            else if (ctrl is TPanel) then
            begin
              for j := 0 to ctrl.ComponentCount - 1 do
                if ctrl.Components[j] is TUpDown then
                begin
                  Result := IntToStr(TUpDown(ctrl.Components[j]).Position);
                  break;
                end;
            end;
    end;
    if Done then
      break;
  end;
  if (ind > 0) and (not NoCommas) then
    Result := StringOfChar(' ', ind) + Result;
end;

function TTemplateDialogEntry.GetFieldValues: string;
var
  i: integer;
  Ctrl: TControl;
  CtrlID: integer;
  TmpIDs: TList;
  TmpSL: TStringList;
  Dummy: boolean;

begin
  Result := '';
  TmpIDs := TList.Create;
  try
    TmpSL := TStringList.Create;
    try
      for i := 0 to FControls.Count-1 do
      begin
        Ctrl := TControl(FControls.Objects[i]);
        if(assigned(Ctrl)) then
        begin
          CtrlID := Ctrl.Tag;
          if(TmpIDs.IndexOf(Pointer(CtrlID)) < 0) then
          begin
            TmpSL.Add(IntToStr(CtrlID) + U + StringReplace(GetControlText(CtrlID,TRUE, Dummy, FALSE, '','',0,true), CRLF, '',[rfReplaceAll, rfIgnoreCase]));
            TmpIDs.Add(Pointer(CtrlID));
          end;
        end;
      end;
      Result := TmpSL.CommaText;
    finally
      TmpSL.Free;
    end;
  finally
    TmpIDs.Free;
  end;
end;

function TTemplateDialogEntry.GetPanel(MaxLen: integer; AParent: TWinControl;
                                       OwningCheckBox: TCPRSDialogParentCheckBox): TDlgFieldPanel;
var
  i, x, y, cnt, idx, ind, yinc, ybase, MaxX: integer;
  MaxTextLen: integer;  {Max num of chars per line in pixels}
  MaxChars: integer;    {Max num of chars per line}
  txt: string;
  ctrl: TControl;
  LastLineBlank: boolean;
  sLbl: TCPRSDialogStaticLabel;
  nLbl: TVA508ChainedLabel;
  sLblHeight: integer;
  TabOrdr: integer;
const
  FOCUS_RECT_MARGIN = 2; {The margin around the panel so the label won't
                        overlay the focus rect on its parent panel.}

  procedure Add2TabOrder(ctrl: TWinControl);
  begin
    ctrl.TabOrder := TabOrdr;
    inc(TabOrdr);
  end;

  function StripSRCode(var txt: string; code: string; len: integer): integer;
  begin
    Result := pos(code, txt);
    if Result > 0 then
    begin
      delete(txt,Result,len);
      dec(Result);
    end
    else
      Result := -1;
  end;

  procedure DoLabel(Atxt: string);
  var
    ctrl: TControl;
    tempLbl: TVA508ChainedLabel;

  begin
    if ScreenReaderSystemActive then
    begin
      if assigned(sLbl) then
      begin
        tempLbl := TVA508ChainedLabel.Create(nil);
        if assigned(nLbl) then
          nLbl.NextLabel := tempLbl
        else
          sLbl.NextLabel := tempLbl;
        nLbl := tempLbl;
        ctrl := nLbl;
      end
      else
      begin
        sLbl := TCPRSDialogStaticLabel.Create(nil);
        ctrl := sLbl;
      end;
    end
    else
      ctrl := TLabel.Create(nil);
    SetOrdProp(ctrl, ShowAccelCharProperty, ord(FALSE));
    SetStrProp(ctrl, CaptionProperty, Atxt);
    ctrl.Parent := FPanel;
    ctrl.Left := x;
    ctrl.Top := y;
    if ctrl = sLbl then
    begin
      Add2TabOrder(sLbl);
      sLbl.Height := sLblHeight;
      ScreenReaderSystem_CurrentLabel(sLbl);
    end;
    if ScreenReaderSystemActive then
      ScreenReaderSystem_AddText(Atxt);
    UpdateColorsFor508Compliance(ctrl);
    inc(x, ctrl.Width);
  end;

  procedure Init;
  var
    lbl : TLabel;
  begin
    if(FFirstBuild) then
      FFirstBuild := FALSE
    else
      KillLabels;
    y := FOCUS_RECT_MARGIN; {placement of labels on panel so they don't cover the}
    x := FOCUS_RECT_MARGIN; {focus rectangle}
    MaxX := 0;
    //ybase := FontHeightPixel(FFont.Handle) + 1 + (FOCUS_RECT_MARGIN * 2);  AGP commentout line for
                                                                           //reminder spacing
    ybase := FontHeightPixel(FFont.Handle) + 2;
    yinc := ybase;
    LastLineBlank := FALSE;
    sLbl := nil;
    nLbl := nil;
    TabOrdr := 0;
    if ScreenReaderSystemActive then
    begin
      ScreenReaderSystem_CurrentCheckBox(OwningCheckBox);
      lbl := TLabel.Create(nil);
      try
        lbl.Parent := FPanel;
        sLblHeight := lbl.Height + 2;
      finally
        lbl.Free;
      end;

    end;
  end;

  procedure Text508Work;
  var
    ContinueCode: boolean;
  begin
    if StripCode(txt, SR_BREAK) then
    begin
      ScreenReaderSystem_Stop;
      nLbl := nil;
      sLbl := nil;
    end;

    ContinueCode := FALSE;
    while StripSRCode(txt, ScreenReaderContinueCode, ScreenReaderContinueCodeLen) >= 0 do
      ContinueCode := TRUE;
    while StripSRCode(txt, ScreenReaderContinueCodeOld, ScreenReaderContinueCodeOldLen) >= 0 do
      ContinueCode := TRUE;
    if ContinueCode then
      ScreenReaderSystem_Continue;
  end;

  procedure Ctrl508Work(ctrl: TControl);
  var
    lbl: TCPRSTemplateFieldLabel;
  begin
    if (Ctrl is TCPRSTemplateFieldLabel) and (not (Ctrl is TCPRSDialogHyperlinkLabel)) then
    begin
      lbl := Ctrl as TCPRSTemplateFieldLabel;
      if trim(lbl.Caption) <> '' then
      begin
        ScreenReaderSystem_CurrentLabel(lbl);
        ScreenReaderSystem_AddText(lbl.Caption);
      end
      else
      begin
        lbl.TabStop := FALSE;
        ScreenReaderSystem_Stop;
      end;
      Add2TabOrder(TWinControl(ctrl));
    end
    else
    begin
      if ctrl is TWinControl then
        Add2TabOrder(TWinControl(ctrl));
      if Supports(ctrl, ICPRSDialogComponent) then
        ScreenReaderSystem_CurrentComponent(ctrl as ICPRSDialogComponent);
    end;
    sLbl := nil;
    nLbl := nil;
  end;

  procedure NextLine;
  begin
    if(MaxX < x) then
      MaxX := x;
    x := FOCUS_RECT_MARGIN;  {leave two pixels on the left for the Focus Rect}
    inc(y, yinc);
    yinc := ybase;
  end;

begin
  MaxTextLen := MaxLen - (FOCUS_RECT_MARGIN * 2);{save room for the focus rectangle on the panel}
  if(FFirstBuild or (FPanel.Width <> MaxLen)) then
  begin
    Init;
    for i := 0 to FControls.Count-1 do
    begin
      txt := FControls[i];
      if ScreenReaderSystemActive then
        Text508Work;
      if StripCode(txt,EOL_MARKER) then
      begin
        if((x <> 0) or LastLineBlank) then
          NextLine;
        LastLineBlank := (txt = '');
      end;
      if(txt <> '') then
      begin
        while(txt <> '') do
        begin
          cnt := NumCharsFitInWidth(FFont.Handle, txt, MaxTextLen-x);
          if (cnt < 1) and (x = FOCUS_RECT_MARGIN) then
            cnt := 1;
          MaxChars := cnt;
          if(cnt >= length(txt)) then
          begin
            DoLabel(txt);
            txt := '';
          end
          else
          if(cnt < 1) then
            NextLine
          else
          begin
            repeat
              if(txt[cnt+1] = ' ') then
              begin
                DoLabel(copy(txt,1,cnt));
                NextLine;
                txt := copy(txt, cnt + 1, MaxInt);
                break;
              end
              else
                dec(cnt);
            until(cnt = 0);
            if(cnt = 0) then
            begin
              if(x = FOCUS_RECT_MARGIN) then {If x is at the far left margin...}
              begin
                DoLabel(Copy(txt,1,MaxChars));
                NextLine;
                txt := copy(txt, MaxChars + 1, MaxInt);
              end
              else
                NextLine;
            end;
          end;
        end;
      end
      else
      begin
        ctrl := TControl(FControls.Objects[i]);
        if(assigned(ctrl)) then
        begin
          if ScreenReaderSystemActive then
            Ctrl508Work(ctrl);
          idx := FIndents.IndexOfObject(Ctrl);
          if idx >= 0 then
            ind := StrToIntDef(Piece(FIndents[idx], U, 1), 0)
          else
            ind := 0;
          if(x > 0) then
          begin
            if (x < MaxLen) and (Ctrl is TORCheckBox) and (TORCheckBox(Ctrl).StringData = NewLine) then
              x := MaxLen;
            if((ctrl.Width + x + ind) > MaxLen) then
              NextLine;
          end;
          inc(x,ind);
          Ctrl.Left := x;
          Ctrl.Top := y;
          inc(x, Ctrl.Width + 4);
          if yinc <= Ctrl.Height then
            yinc := Ctrl.Height + 2;
          if (x < MaxLen) and ((Ctrl is TRichEdit) or
             ((Ctrl is TLabel) and (pos(CRLF, TLabel(Ctrl).Caption) > 0))) then
            x := MaxLen;
        end;
      end;
    end;
    NextLine;
    FPanel.Height := (y-1) + (FOCUS_RECT_MARGIN * 2); //AGP added Focus_rect_margin for Reminder spacing
    FPanel.Width := MaxX + FOCUS_RECT_MARGIN;
  end;
  if(FFieldValues <> '') then
    SetFieldValues(FFieldValues);
  if ScreenReaderSystemActive then
    ScreenReaderSystem_Stop;
  Result := FPanel;
end;

function TTemplateDialogEntry.GetText: string;
begin
  Result := ResolveTemplateFields(FText, FALSE);
end;

procedure TTemplateDialogEntry.KillLabels;
var
  i, idx: integer;
  obj: TObject;
  max: integer;

begin
  if(assigned(FPanel)) then
  begin
    max := FPanel.ControlCount-1;
    for i := max downto 0 do
    begin
// deleting TVA508StaticText can delete several TVA508ChainedLabel components
      if i < FPanel.ControlCount then
      begin
        obj := FPanel.Controls[i];
        if (not (obj is TVA508ChainedLabel)) and
           ((obj is TLabel) or (obj is TVA508StaticText)) then
        begin
          idx := FControls.IndexOfObject(obj);
          if idx < 0 then
            obj.Free;
        end;
      end;
    end;
  end;
end;

procedure TTemplateDialogEntry.SetAutoDestroyOnPanelFree(
  const Value: boolean);
begin
  if Value <> FAutoDestroyOnPanelFree then
  begin
    FAutoDestroyOnPanelFree := Value;
    if FAutoDestroyOnPanelFree then
    begin
      FOldPanelDestroy := FPanel.OnDestroy;
      FPanel.OnDestroy := PanelDestroy;
    end else begin
      FPanel.OnDestroy := FOldPanelDestroy;
      FOldPanelDestroy := nil;
    end;
  end;
end;

procedure TTemplateDialogEntry.SetControlText(CtrlID: integer; AText: string);
var
  cnt, i, j: integer;
  Ctrl: TControl;
  Done: boolean;

begin
  FUpdating := TRUE;
  try
    Done := FALSE;
    cnt := 0;
    for i := 0 to FControls.Count-1 do
    begin
      Ctrl := TControl(FControls.Objects[i]);
      if(assigned(Ctrl)) and (Ctrl.Tag = CtrlID) then
      begin
        Done := TRUE;
        if(Ctrl is TLabel) then
          TLabel(Ctrl).Caption := AText
        else
        if(Ctrl is TEdit) then
          TEdit(Ctrl).Text := AText
        else
        if(Ctrl is TORComboBox) then
          TORComboBox(Ctrl).SelectByID(AText)
        else
        if(Ctrl is TRichEdit) then
          TRichEdit(Ctrl).Lines.Text := AText
        else
        if(Ctrl is TORDateCombo) then
          TORDateCombo(Ctrl).FMDate := MakeFMDateTime(piece(AText,':',2))
        else
        if(Ctrl is TORDateBox) then
          TORDateBox(Ctrl).Text := AText
        else
        if(Ctrl is TORCheckBox) then
        begin
          Done := FALSE;
          TORCheckBox(Ctrl).Checked := FALSE;        //<-PSI-06-170-ADDED THIS LINE - v27.23 - RV
          if(cnt = 0) then
            cnt := DelimCount(AText, '|') + 1;
          for j := 1 to cnt do
          begin
            if(TORCheckBox(Ctrl).Caption = piece(AText,'|',j)) then
              TORCheckBox(Ctrl).Checked := TRUE;
          end;
        end
        else
        if(Ctrl is TfraTemplateFieldButton) then
          TfraTemplateFieldButton(Ctrl).ButtonText := AText
        else
        if(Ctrl is TPanel) then
        begin
          for j := 0 to Ctrl.ComponentCount-1 do
            if Ctrl.Components[j] is TUpDown then
            begin
              TUpDown(Ctrl.Components[j]).Position := StrToIntDef(AText,0);
              break;
            end;
        end;
      end;
      if Done then break;
    end;
  finally
    FUpdating := FALSE;
  end;
end;

procedure TTemplateDialogEntry.SetFieldValues(const Value: string);
var
  i: integer;
  TmpSL: TStringList;

begin
  FFieldValues := Value;
  TmpSL := TStringList.Create;
  try
    TmpSL.CommaText := Value;
    for i := 0 to TmpSL.Count-1 do
      SetControlText(StrToIntDef(Piece(TmpSL[i], U, 1), 0), Piece(TmpSL[i], U, 2));
  finally
    TmpSL.Free;
  end;
end;

function TTemplateDialogEntry.StripCode(var txt: string; code: char): boolean;
var
  p: integer;
begin
  p := pos(code, txt);
  Result := (p > 0);
  if Result then
  begin
    while p > 0 do
    begin
      delete(txt, p, 1);
      p := pos(code, txt);
    end;
  end;
end;

procedure TTemplateDialogEntry.UpDownChange(Sender: TObject);
begin
  EnsureText(TEdit(Sender), TUpDown(TEdit(Sender).Tag));
  DoChange(Sender);
end;

function StripEmbedded(iItems: string): string;
var
  i, j: integer;

begin
  Result := iItems;
  i := pos(TemplateFieldBeginSignature,Result);
  while i > 0 do
  begin
    j := pos(TemplateFieldEndSignature,Result,i + TemplateFieldSignatureLen);
    if j < 1 then
      j := length(Result);
    while(j>=i) do
    begin
    // removing CRLF causes sync error between stripped and actual text
      if(Result[j] <> #13) and (Result[j] <> #10) then
        delete(Result, j, 1);
      dec(j);
    end;
    i := pos(TemplateFieldBeginSignature,Result,i);
  end;
end;

procedure StripScreenReaderCodes(var Text: string);
var
  p, j: integer;
begin
  for j := low(ScreenReaderCodes) to high(ScreenReaderCodes) do
  begin
    p := 1;
    while (p > 0) do
    begin
      p := posex(ScreenReaderCodes[j], Text, p);
      if p > 0 then
        delete(Text, p, ScreenReaderCodeLens[j]);
    end;
  end;
end;

procedure StripScreenReaderCodes(SL: TStrings);
var
  temp: string;
  i: integer;

begin
  for i := 0 to SL.Count - 1 do
  begin
    temp := SL[i];
    StripScreenReaderCodes(temp);
    SL[i] := temp;
  end;
end;

function HasScreenReaderBreakCodes(SL: TStrings): boolean;
var
  i: integer;

begin
  Result := TRUE;
  for i := 0 to SL.Count - 1 do
  begin
    if pos(ScreenReaderCodeSignature, SL[i]) > 0 then
      exit;
  end;
  Result := FALSE;
end;

// NSR20100706 AA 20150706 ----------------------------------------------- begin
function TTemplateDialogEntry.GetControl(CtrlID: integer): TControl;
Var
 I: Integer;
 Ctrl: TControl;
begin
 Result := nil;
 for i := 0 to FControls.Count-1 do
  begin
    Ctrl := TControl(FControls.Objects[i]);
    if(assigned(Ctrl)) and (Ctrl.Tag = CtrlID) then
    begin
      Result := Ctrl;
      break;
    end;
  end;
end;
// NSR20100706 AA 20150706 ------------------------------------------------- end

Function RightTrimChars(Str: String; TrimChars: TSysCharSet): String;
var
  x: integer;
begin
  // Loop by char and remove any trailing
  for x := Length(Str) - 1 downto 0 do
    if CharInSet(Str[x + 1], TrimChars) then
      Delete(Str, x + 1, 1)
    else
      break;
  Result := Str;
end;

function SafeWrapText(const Line, BreakStr: string;
  const BreakChars: TSysCharSet; const MaxCol: integer; MaxLineLength: integer = -1): string;
Const
  ARep = #26;
  QRep = #28;
var
  TmpStrLst, RtnLst, MainLst: TStringList;
  MainStr, tmpStr: String;
  WrapAt: integer;
begin
  // Setup
  TmpStrLst := TStringList.Create;
  RtnLst := TStringList.Create;
  MainLst := TStringList.Create;
  try
    // clear the return
    RtnLst.Clear;
    // get all "current' lines for the wrap
    MainLst.Text := Line;

    //Set the max length to the col if not passed in
    if MaxLineLength = -1 then
      MaxLineLength := MaxCol;

    // Loop through all lines in the text and wrap
    for MainStr in MainLst do
    begin
      // replace the apostrophes
      tmpStr := StringReplace(MainStr, '''', aRep, [rfReplaceAll, rfIgnoreCase]);

      // replace the quote
      tmpStr := StringReplace(tmpStr, '"', QRep, [rfReplaceAll, rfIgnoreCase]);

      // Wrap the text
      WrapAt := Min(MaxCol, MaxLineLength);
      TmpStrLst.Text := WrapText(tmpStr, BreakStr, BreakChars, WrapAt);

      // Replace the apostrophes
      TmpStrLst.Text := StringReplace(TmpStrLst.Text, ARep, '''', [rfReplaceAll, rfIgnoreCase]);

      // Replace the quote
      TmpStrLst.Text := StringReplace(TmpStrLst.Text, QRep, '"', [rfReplaceAll, rfIgnoreCase]);

      // If we have already added text then add the break string
      if RtnLst.Count > 0 then
        RtnLst.Text := RightTrimChars(RtnLst.Text, [#10, #13]) + BreakStr + RightTrimChars(TmpStrLst.Text, [#10, #13])
      else
      // else just add this line
        RtnLst.Text := RightTrimChars(RtnLst.Text, [#10, #13]) + RightTrimChars(TmpStrLst.Text, [#10, #13]);
    end;

  finally
    // Set the result
    Result := RightTrimChars(RtnLst.Text, [#10, #13]);
    // Cleanup
    MainLst.Free;
    TmpStrLst.Free;
    RtnLst.Free;
  end;

end;

function SafeWrapTextVariable(const Line, BreakStr: string;
  const BreakChars: TSysCharSet; const MaxCol1, MaxCol2: integer; const MaxLineLength
  : integer = -1): string;
var
  TmpStrLst: TStringList;
  RemainTxt: String;
begin
  // Setup
  TmpStrLst := TStringList.Create;
  try
    // Wrap first line
    TmpStrLst.Text := SafeWrapText(Line, BreakStr, BreakChars, MaxCol1, MaxLineLength);
    if TmpStrLst.Count > 0 then
    begin
      // Add the first line
      Result := TmpStrLst[0];

      // grab remianign text
      RemainTxt := Line;

      // Remove the added line
      Delete(RemainTxt, 1, Length(TmpStrLst[0]));

      if Length(RemainTxt) > 0 then
      begin
        // wrap the remaining lines
        TmpStrLst.Text := SafeWrapText(RemainTxt, BreakStr, BreakChars, MaxCol2,
          MaxLineLength);
        // Add to the result
        Result := Result + BreakStr + TmpStrLst.Text;
      end;
    end;

  finally
    // Cleanup
    TmpStrLst.Free;
  end;
end;

initialization

finalization
  KillObj(@uTmplFlds, TRUE);
  KillObj(@uEntries, TRUE);

end.
