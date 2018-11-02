{*********************************************************}
{*                  OVCTCBEF.PAS 4.08                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcbef;
  {-Orpheus Table Cell - base entry field type}

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  OvcBase, OvcCmd, OvcData, OvcConst, OvcEF, OvcCaret, OvcTCmmn, OvcTCell, OvcTable, OvcTCStr;

type
  TOvcTCBaseEntryField = class(TOvcTCBaseString)
    protected {private}
      FEdit        : TOvcBaseEntryField;
      FEditDisplay : TOvcBaseEntryField;

      FOnError          : TValidationErrorEvent;
      FOnUserCommand    : TUserCommandEvent;
      FOnUserValidation : TUserValidationEvent;

    protected
      function GetCaretIns : TOvcCaret;
      function GetCaretOvr : TOvcCaret;
      function GetControlCharColor : TColor;
      function GetDataSize : integer;
      function GetDecimalPlaces : byte;
      function GetOptions : TOvcEntryFieldOptions;
      function GetEFColors : TOvcEFColors;
      function GetMaxLength : word;
      function GetModified : boolean;
      function GetPadChar : Char;
      function GetPasswordChar : Char;
      function GetRangeHi : string;
      function GetRangeLo : string;
      function GetTextMargin : integer;

      procedure SetCaretIns(CI : TOvcCaret);
      procedure SetCaretOvr(CO : TOvcCaret);
      procedure SetControlCharColor(CCC : TColor);
      procedure SetDecimalPlaces(DP : byte);
      procedure SetEFColors(Value : TOvcEFColors);
      procedure SetMaxLength(ML : word);
      procedure SetOptions(Value : TOvcEntryFieldOptions);
      procedure SetPadChar(PC : Char);
      procedure SetPasswordChar(PC : Char);
      procedure SetRangeHi(const RI : string);
      procedure SetRangeLo(const RL : string);
      procedure SetTextMargin(TM : integer);

      procedure DefineProperties(Filer: TFiler); override;

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;

      {properties for entry fields, to be exposed by descendants}
      property CaretIns : TOvcCaret
         read GetCaretIns write SetCaretIns;

      property CaretOvr : TOvcCaret
         read GetCaretOvr write SetCaretOvr;

      property ControlCharColor : TColor
         read GetControlCharColor write SetControlCharColor;

      property DecimalPlaces : byte
         read GetDecimalPlaces write SetDecimalPlaces;

      property EFColors : TOvcEFColors
         read GetEFColors write SetEFColors;

      property MaxLength : word
         read GetMaxLength write SetMaxLength;

      property Options : TOvcEntryFieldOptions
         read GetOptions write SetOptions;

      property PadChar : Char
         read GetPadChar write SetPadChar;

      property PasswordChar : Char
         read GetPasswordChar write SetPasswordChar;

      property RangeHi : string
         read GetRangeHi write SetRangeHi
         stored false;

      property RangeLo : string
         read GetRangeLo write SetRangeLo
         stored false;

      property TextMargin : integer
         read GetTextMargin write SetTextMargin;

      {events}
      property OnError : TValidationErrorEvent
         read FOnError write FOnError;

      property OnUserCommand : TUserCommandEvent
         read FOnUserCommand write FOnUserCommand;

      property OnUserValidation : TUserValidationEvent
         read FOnUserValidation write FOnUserValidation;

    public
      constructor Create(AOwner : TComponent); override;
      function CreateEntryField(AOwner : TComponent) : TOvcBaseEntryField; virtual; abstract;

      function  EditHandle : THandle; override;
      procedure EditHide; override;
      procedure EditMove(CellRect : TRect); override;

      function CanSaveEditedData(SaveValue : boolean) : boolean; override;
      procedure SaveEditedData(Data : pointer); override;
      procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                             CellRect : TRect;
                       const CellAttr : TOvcCellAttributes;
                             CellStyle: TOvcTblEditorStyle;
                             Data : pointer); override;
      procedure StopEditing(SaveValue : boolean;
                            Data : pointer); override;

      property DataSize : integer
         read GetDataSize;

      property Modified : boolean
         read GetModified;

    published
      property About;
  end;

implementation

uses
  Dialogs;

type {for typecast to get around protected clause}
  TOvcBEF = class(TOvcBaseEntryField)
    public
      property CaretIns;
      property CaretOvr;
      property ControlCharColor;
      property DecimalPlaces;
      property EFColors;
      property MaxLength;
      property Options;
      property PadChar;
      property PasswordChar;
      property RangeHi;
      property RangeLo;
      property ShowHint;
      property TextMargin;
  end;

{===TOvcTCBaseEntryField=============================================}

constructor TOvcTCBaseEntryField.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    FEdit := CreateEntryField(Self);
    FEdit.Visible := false;

    FEditDisplay := CreateEntryField(Self);
    FEditDisplay.Visible := false;
  end;

{--------}
function TOvcTCBaseEntryField.CanSaveEditedData(SaveValue : boolean) : boolean;
  begin
    Result := true;
    if Assigned(FEdit) then
      if SaveValue then
        with TOvcBEF(FEdit) do
          if Controller.ErrorPending then
            Result := false
          else
            Result := ValidateSelf
      else
        FEdit.Restore;
  end;

{--------}
function TOvcTCBaseEntryField.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;

{--------}
procedure TOvcTCBaseEntryField.EditHide;
  begin
    if Assigned(FEdit) then
      with FEdit do
        begin
          SetWindowPos(FEdit.Handle, HWND_TOP,
                       0, 0, 0, 0,
                       SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        end;

  end;

{--------}
procedure TOvcTCBaseEntryField.EditMove(CellRect : TRect);
  var
    EditHandle : HWND;
  begin
    if Assigned(FEdit) then
      begin
        EditHandle := FEdit.Handle;
        with CellRect do
          SetWindowPos(EditHandle, HWND_TOP,
                       Left, Top, Right-Left, Bottom-Top,
                       SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        InvalidateRect(EditHandle, nil, false);
        UpdateWindow(EditHandle);

      end;
  end;

{--------}
procedure TOvcTCBaseEntryField.tcPaint(TableCanvas : TCanvas;
                                 const CellRect    : TRect;
                                       RowNum      : TRowNum;
                                       ColNum      : TColNum;
                                 const CellAttr    : TOvcCellAttributes;
                                       Data        : pointer);
{  -Changes
    05/2011, AB: Use 'FDataStringType' to determine what kind of string 'Data' points
                 to (in case the data-type is string). }
  var
    S  : string;
    sS : ShortString;
  begin
    if (Data = nil) then
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data)
    else
      begin
        FEditDisplay.Controller := TOvcTable(FTable).Controller;
        if (FEditDisplay.Controller = nil) then
          ShowMessage('NIL in tcPaint');
        FEditDisplay.Parent := FTable;
        SetWindowPos(FEditDisplay.Handle, HWND_TOP, 0, 0, 0, 0,
                     SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        { In most cases, 'Data' can simply passed on to 'FEditDisplay'. However, in case
          of strings, some extra care is needed:
          The kind of string 'Data' points to differs and is determined by 'DataStringType' -
          FEditDisplay needs a pointer to a string; so a conversion might be necessary }
        if (TOvcBEF(FEditDisplay).efDataType mod fcpDivisor = fsubString) and
           (FDataStringType <> tstString) then begin
          if FDataStringType = tstShortString then
            S := string(POvcShortString(Data)^)
          else {FDataStringType = tstPChar}
            S := string(PChar(Data));
          FEditDisplay.SetValue(S);
        end else
          FEditDisplay.SetValue(Data^);
        S := Trim(FEditDisplay.DisplayString);
        { Usually, 'S' can be passed on to the inherited method. However, if FDataStringType
          <> tstString then a different kind of string-type is expected by the
          inherited method. }
        case FDataStringType of
          tstShortString: begin
                            sS := ShortString(S);
                            Data := @sS;
                          end;
          tstPChar:       Data := @S[1];
          tstString:      Data := @S;
        end;
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);
      end;
  end;

{--------}
procedure TOvcTCBaseEntryField.SaveEditedData(Data : pointer);
  begin
    if Assigned(Data) then
      FEdit.GetValue(Data^);
  end;

{--------}
procedure TOvcTCBaseEntryField.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                           CellRect : TRect;
                                     const CellAttr : TOvcCellAttributes;
                                           CellStyle: TOvcTblEditorStyle;
                                           Data : pointer);
{  -Changes
    05/2011, AB: Use 'FDataStringType' to determine what kind of string 'Data' points
                 to (in case the data-type is string). }
  var
    S: string;
  begin
    with TOvcBEF(FEdit) do
      begin
        Parent := FTable;
        Font := CellAttr.caFont;
        Font.Color := CellAttr.caFontColor;
        Color := CellAttr.caColor;
        BorderStyle := bsNone;
        Ctl3D := false;
        case CellStyle of
          tesBorder : BorderStyle := bsSingle;
          tes3D     : Ctl3D := true;
        end;{case}
        Left := CellRect.Left;
        Top := CellRect.Top;
        Width := CellRect.Right - CellRect.Left;
        Height := CellRect.Bottom - CellRect.Top;
        Hint := Self.Hint;
        ShowHint := Self.ShowHint;
        TabStop := false;
        Controller := TOvcTable(FTable).Controller;
        if (Controller = nil) then
          ShowMessage('NIL in StartEditing');
        if Assigned(Data) then begin
          { In most cases, 'Data' can simply passed on to 'FEdit'. However, in case
            of strings, some extra care is needed:
            The kind of string 'Data' points to differs and is determined by 'DataStringType' -
            FEdit needs a pointer to a string; so a conversion might be necessary. }
          if (efDataType mod fcpDivisor = fsubString) and
             (FDataStringType <> tstString) then begin
            if FDataStringType = tstShortString then
              S := string(POvcShortString(Data)^)
            else {FDataStringType = tstPChar}
              S := string(PChar(Data));
            SetValue(S);
          end else
            SetValue(Data^);
        end else
          ClearContents;
        Visible := true;

        OnChange := Self.OnChange;
        OnClick := Self.OnClick;
        OnDblClick := Self.OnDblClick;
        OnDragDrop := Self.OnDragDrop;
        OnDragOver := Self.OnDragOver;
        OnEndDrag := Self.OnEndDrag;
        OnEnter := Self.OnEnter;
        OnError := Self.OnError;
        OnExit := Self.OnExit;
        OnKeyDown := Self.OnKeyDown;
        OnKeyPress := Self.OnKeyPress;
        OnKeyUp := Self.OnKeyUp;
        OnMouseDown := Self.OnMouseDown;
        OnMouseMove := Self.OnMouseMove;
        OnMouseUp := Self.OnMouseUp;
        OnUserCommand := Self.OnUserCommand;
        OnUserValidation := Self.OnUserValidation;
      end;
  end;

{--------}
procedure TOvcTCBaseEntryField.StopEditing(SaveValue : boolean;
                                           Data : pointer);
{  -Changes
    05/2011, AB: Use 'FDataStringType' to determine what kind of string 'Data' points
                 to (in case the data-type is string). }
  var
    S: string;
  begin
    if SaveValue and Assigned(Data) then begin
      if (TOvcBEF(FEdit).efDataType mod fcpDivisor = fsubString) and
         (FDataStringType <> tstString) then begin
        { The data-type is string, but 'Data' doesn't point to a string (but ShortString
          or array of char). FEdit.GetValue(Data^) cannot be used directly in this case. }
        FEdit.GetValue(S);
        if FDataStringType = tstShortString then
          POvcShortString(Data)^ := ShortString(Copy(S, 1, MaxLength))
        else {FDataStringType = tstPChar}
          StrPLCopy(Data, S, MaxLength);
      end else
        FEdit.GetValue(Data^);
    end;
    EditHide;
  end;

{====================================================================}


{===TOvcTCBaseEntryField property access=============================}
procedure TOvcTCBaseEntryField.DefineProperties(Filer: TFiler);
  begin
    inherited DefineProperties(Filer);
    with Filer do
      begin
        DefineBinaryProperty('RangeHigh',
           TOvcBEF(FEdit).efReadRangeHi, TOvcBEF(FEdit).efWriteRangeHi, true);
        DefineBinaryProperty('RangeLow',
           TOvcBEF(FEdit).efReadRangeLo, TOvcBEF(FEdit).efWriteRangeLo, true);
      end;
  end;

{--------}
function TOvcTCBaseEntryField.GetOptions : TOvcEntryFieldOptions;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Options
    else
      Result := [];
  end;

{--------}
function TOvcTCBaseEntryField.GetCaretIns : TOvcCaret;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).CaretIns
    else Result := nil;
  end;

{--------}
function TOvcTCBaseEntryField.GetCaretOvr : TOvcCaret;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).CaretOvr
    else Result := nil;
  end;

{--------}
function TOvcTCBaseEntryField.GetControlCharColor : TColor;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).ControlCharColor
    else Result := clRed;
  end;

{--------}
function TOvcTCBaseEntryField.GetDataSize : integer;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).DataSize
    else Result := 0;
  end ;
{--------}
function TOvcTCBaseEntryField.GetDecimalPlaces : byte;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).DecimalPlaces
    else Result := 0;
  end ;
{--------}
function TOvcTCBaseEntryField.GetEFColors : TOvcEFColors;
  begin
    Result := nil;
    if Assigned(FEdit) then
      Result := TOvcBEF(FEdit).EFColors;
  end;
{--------}
function TOvcTCBaseEntryField.GetModified : boolean;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).Modified
    else Result := false;
  end ;
{--------}
function TOvcTCBaseEntryField.GetMaxLength : word;
  begin
    if Assigned(FEdit) then
        Result := TOvcBEF(FEdit).MaxLength
    else Result := 0;
  end;
{--------}
function TOvcTCBaseEntryField.GetPadChar : Char;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).PadChar
    else Result := ' ';
  end;
{--------}
function TOvcTCBaseEntryField.GetPasswordChar : Char;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).PasswordChar
    else Result := '*';
  end;
{--------}
function TOvcTCBaseEntryField.GetRangeHi : string;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).RangeHi
    else Result := '';
  end;
{--------}
function TOvcTCBaseEntryField.GetRangeLo : string;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).RangeLo
    else Result := '';
  end;
{--------}
function TOvcTCBaseEntryField.GetTextMargin : integer;
  begin
    if Assigned(FEdit) then
         Result := TOvcBEF(FEdit).TextMargin
    else Result := 0;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetCaretIns(CI : TOvcCaret);
  begin
    if Assigned(FEdit) then TOvcBEF(FEdit).CaretIns := CI;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetCaretOvr(CO : TOvcCaret);
  begin
    if Assigned(FEdit) then TOvcBEF(FEdit).CaretOvr := CO;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetControlCharColor(CCC : TColor);
  begin
    if Assigned(FEdit) then TOvcBEF(FEdit).ControlCharColor := CCC;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetDecimalPlaces(DP : byte);
  begin
    if Assigned(FEdit) then
      begin
        TOvcBEF(FEdit).DecimalPlaces := DP;
        TOvcBEF(FEditDisplay).DecimalPlaces := DP;
      end;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetEFColors(Value : TOvcEFColors);
  begin
    if Assigned(FEdit) then
      TOvcBEF(FEdit).EFColors := Value;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetMaxLength(ML : word);
  begin
    if Assigned(FEdit) then begin
      TOvcBEF(FEdit).MaxLength := ML;
      TOvcBEF(FEditDisplay).MaxLength := ML;
    end;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetOptions(Value : TOvcEntryFieldOptions);
  begin
    if Assigned(FEdit) then begin
      TOvcBEF(FEdit).Options := Value;
      TOvcBEF(FEditDisplay).Options := Value;
    end;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetPadChar(PC : Char);
  begin
    if Assigned(FEdit) then
      begin
        TOvcBEF(FEdit).PadChar := PC;
        TOvcBEF(FEditDisplay).PadChar := PC;
      end;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetPasswordChar(PC : Char);
  begin
    if Assigned(FEdit) then
      begin
        TOvcBEF(FEdit).PasswordChar := PC;
        TOvcBEF(FEditDisplay).PasswordChar := PC;
      end;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetRangeHi(const RI : string);
  begin
    if Assigned(FEdit) then TOvcBEF(FEdit).RangeHi := RI;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetRangeLo(const RL : string);
  begin
    if Assigned(FEdit) then TOvcBEF(FEdit).RangeLo := RL;
  end;
{--------}
procedure TOvcTCBaseEntryField.SetTextMargin(TM : integer);
  begin
    if Assigned(FEdit) then TOvcBEF(FEdit).TextMargin := TM;
  end;

end.
