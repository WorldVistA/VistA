{*********************************************************}
{*                   OVCXFER.PAS 4.06                    *}
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
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcxfer;
  {-Data transfer non-visual component}

interface

uses
  Windows, Classes, Controls, ExtCtrls, Forms, StdCtrls, SysUtils, OvcBase,
  OvcConst, OvcData, OvcEF, OvcRLbl, OvcEdit;

{***************************************************************
  Supported types         Data to transfer
----------------------------------------------------------------
  TLabel                  String, array of Char or ShortString
  TPanel                  String, array of Char or ShortString
  TEdit                   String, array of Char or ShortString
  TMemo                   TStrings, array of Char or ShortString
  TCheckBox               Boolean
  TRadioButton            Boolean
  TListBox                Integer, TStrings
  TComboBox               Integer, string, TStrings
  TOvcRotatedLabel        String, array of Char or ShortString
  TOvcBaseEntryField      variable (size obtained from field)
  TOvcEditor              String, array of Char or ShortString
*****************************************************************}

const
  xfrMaxPChar = 255;

type
  { TxfrStringtype defines the method used to store string-field in the data-structur:
    xfrString:
      The type 'string' is used, so 'TransferFromFormPrim' and 'TransferToFormPrim'
      expect fields of this type to store the contents of string-fields.
      This is the preferable method - however, as the data-structure does not
      contain the strings itself (string-fields as pointers, after all), the
      data-structure cannot easily be used to store the collected data e.g. in a file.
    xfrPChar:
      The type 'array[0..] of Char' is used. The strings as stored as Null-terminated
      strings inside the data-record. One may store the record e.g. in a file.
      The disadvantage is, that fields with unlimited size are store in fields of
      type 'array[0..xfrMaxPChar] of Char'; so this method is of limited use here.
    xfrShortString:
      The type string[..] is used. This method is mainly implemented for backward
      compatibility (e.g the demo-Project 'AddrBook.dpr'). It has the same limitations
      as xfrPChar. On top of this, unicode-characters cannot be stored as ShortStrings
      always contain single-byte characters. }
  TxfrStringtype = (xfrString, xfrPChar, xfrShortString);

  {structure used to transfer data for a TListBox component}
  PListBoxTransfer = ^TListBoxTransfer;
  TListBoxTransfer = packed record
    ItemIndex : Integer;
    Items     : TStrings;
  end;

  {structure used to transfer data for a TComboBox component}
  PComboBoxTransfer = ^TComboBoxTransfer;
  TComboBoxTransfer = packed record
    ItemIndex : Integer;
    Text      : string;
    Items     : TStrings;
  end;

  PComboBoxTransfer_xfrPChar = ^TComboBoxTransfer_xfrPChar;
  TComboBoxTransfer_xfrPChar = packed record
    ItemIndex : Integer;
    Text      : array[0..xfrMaxPChar] of Char;
    Items     : TStrings;
  end;

  PComboBoxTransfer_xfrShortString = ^TComboBoxTransfer_xfrShortString;
  TComboBoxTransfer_xfrShortString = packed record
    ItemIndex : Integer;
    Text      : string[255];
    Items     : TStrings;
  end;

type
  TOvcTransfer = class(TOvcComponent)

  protected {private}
    xfrList : TList;

    function xfrGetComponentDataSize(C : TComponent; xfrStringtype : TxfrStringtype) : Word;
      {-return the size of the data for this component}

  public
    {for internal use by the property editor}
    procedure GetTransferList(L : TList);
      {-return the list of components}

    function GetTransferBufferSizePrim(CNA : array of TComponent; xfrStringtype : TxfrStringtype) : Word;
    function GetTransferBufferSize(CNA : array of TComponent) : Word;
    function GetTransferBufferSizeZ(CNA : array of TComponent) : Word;
    function GetTransferBufferSizeS(CNA : array of TComponent) : Word;
      {-return the required size for the transfer buffer}

    procedure TransferFromFormPrim(CNA : array of TComponent; var Data; xfrStringtype : TxfrStringtype);
    procedure TransferFromForm(CNA : array of TComponent; var Data);
    procedure TransferFromFormZ(CNA : array of TComponent; var Data);
    procedure TransferFromFormS(CNA : array of TComponent; var Data);
      {-transfer forms data to structure pointed to by Data
        The three methods differ in the string format used in 'Data':
        TransferFromForm: string
        TransferFromFormZ: PChar
        TransferFromFormS: ShortString}
    procedure TransferToFormPrim(CNA : array of TComponent; const Data; xfrStringtype : TxfrStringtype);
    procedure TransferToForm(CNA : array of TComponent; const Data);
    procedure TransferToFormZ(CNA : array of TComponent; const Data);
    procedure TransferToFormS(CNA : array of TComponent; const Data);
      {-transfer data from structure pointed to by Data to form
        The three methods differ in the string format used in 'Data':
        TransferFromForm: string
        TransferFromFormZ: PChar
        TransferFromFormS: ShortString}
  end;


implementation


{*** TOvcTransfer ***}

function TOvcTransfer.GetTransferBufferSizePrim(CNA : array of TComponent; xfrStringtype : TxfrStringtype) : Word;
  {-return the required size for the transfer buffer}
var
  I : Integer;
begin
  result := 0;
  for I := Low(CNA) to High(CNA) do
    Inc(result, xfrGetComponentDataSize(CNA[I],xfrStringtype));
end;

function TOvcTransfer.GetTransferBufferSize(CNA : array of TComponent) : Word;
begin
  result := GetTransferBufferSizePrim(CNA, xfrString);
end;

function TOvcTransfer.GetTransferBufferSizeZ(CNA : array of TComponent) : Word;
begin
  result := GetTransferBufferSizePrim(CNA, xfrPChar);
end;

function TOvcTransfer.GetTransferBufferSizeS(CNA : array of TComponent) : Word;
begin
  result := GetTransferBufferSizePrim(CNA, xfrShortString);
end;


procedure TOvcTransfer.GetTransferList(L : TList);
  {-build list of all components that require data transfer}

  function CanAdd(C : TComponent) : Boolean;
  begin
    Result := False;

    {don't add ourself}
    if (C = Self) then
      Exit;

    {if component isn't owned by out form, don't add}
    if (C.Owner <> Self.Owner) then
      Exit;

    {if a component doesn't have a name, don't add}
    if (C.Name = '') then
      Exit;

    if (C is TEdit) then
      Result := True
    else if (C is TLabel) then
      Result := True
    else if (C is TPanel) then
      Result := True
    else if (C is TMemo) then
      Result := True
    else if (C is TCheckBox) then
      Result := True
    else if (C is TRadioButton) then
      Result := True
    else if (C is TListBox) then
      Result := True
    else if (C is TComboBox) then
      Result := True
    else if (C is TOvcBaseEntryField) and
            (Pos('TOrDB', AnsiUpperCase(C.ClassName)) = 0) then
      Result := True
    else if (C is TOvcRotatedLabel) then
      Result := True
    else if (C is TOvcEditor) then
      Result := True;
  end;

  procedure AddComponent(C : TComponent);
  begin
    if CanAdd(C) then
      L.Add(C);
  end;

  procedure FindComponents(C : TComponent);
  var
    I  : Integer;
  begin
    if not Assigned(C) then
      Exit;

    {look through all of the owned components}
    for I := 0 to C.ComponentCount-1 do begin
      {conditionally add to the list}
      AddComponent(C.Components[I]);

      {see if this component owns other componets}
      FindComponents(C.Components[I]);
    end;
  end;

begin
  {find all components belonging to the form}
  FindComponents(Owner);
end;


type
  TLocalEF = class (TOvcBaseEntryField);


function isOvcBaseEntryField_with_string(C:TComponent): Boolean;
begin
  result := (C is TOvcBaseEntryField) and
            ((TLocalEF(C).efDataType mod fcpDivisor) = fsubString);
end;

procedure TOvcTransfer.TransferFromFormPrim(CNA : array of TComponent; var Data; xfrStringtype : TxfrStringtype);
  {-transfer forms data to structure pointed to by Data

   -Changes
    03/2011, AB: New parameter 'xfrStringtype' defines the type of strings used in 'Data'}
var
  I  : Integer;
  P  : PByte;
  C  : TComponent;
  St : TStrings;
  s  : string;
begin
  P := PByte(@Data);
  if P = nil then
    Exit;

  {transfer data to the buffer for each component in the list}
  for I := Low(CNA) to High(CNA) do begin
    C := CNA[I];
    if (C is TEdit) or (C is TLabel) or (C is TPanel) or (C is TOvcRotatedLabel) or
       (C is TOvcEditor) then begin
      if C is TEdit then
        s := TEdit(C).Text
      else if C is TLabel then
        s := TLabel(C).Caption
      else if C is TPanel then
        s := TPanel(C).Caption
      else if C is TOvcEditor then
        s := TOvcEditor(C).Text
      else
        s := TOvcRotatedLabel(C).Caption;
      case xfrStringtype of
        xfrString:
          string(Pointer(P)^) := s;
        xfrPChar:
          StrPLCopy(PChar(P), s, xfrMaxPChar);
        xfrShortString:
          PShortString(P)^ := ShortString(s);
      end;
    end else if C is TMemo then begin
      { It would be easier to store the contents of a TMemo as a string in the case xfrString;
        however, to not break existing code, we use TStrings. }
      case xfrStringtype of
        xfrString: begin
          Move(P^, St, SizeOf(TStrings));
          St.Assign(TMemo(C).Lines);
        end;
        xfrPChar:
          StrPLCopy(PChar(P), TMemo(C).Lines.Text, xfrMaxPChar);
        xfrShortString:
          PShortString(P)^ := ShortString(TMemo(C).Lines.Text);
      end;
    end else if C is TCheckBox then
      Boolean(P^) := TCheckBox(C).Checked
    else if C is TRadioButton then
      Boolean(P^) := TRadioButton(C).Checked
    else if C is TListBox then begin
      PListBoxTransfer(P)^.ItemIndex := TListBox(C).ItemIndex;
      PListBoxTransfer(P)^.Items.Assign(TListBox(C).Items);
    end else if C is TComboBox then begin
      PComboBoxTransfer(P)^.ItemIndex := TComboBox(C).ItemIndex;
      PComboBoxTransfer(P)^.Text := TComboBox(C).Text;
      PComboBoxTransfer(P)^.Items.Assign(TComboBox(C).Items);
    end else if isOvcBaseEntryField_with_string(C) then begin
      case xfrStringtype of
        xfrString:
          TOvcBaseEntryField(C).GetValue(PString(P)^);
        xfrPChar: begin
          TOvcBaseEntryField(C).GetValue(s);
          StrPLCopy(PChar(P), s, xfrMaxPChar);
        end;
        xfrShortString: begin
          TOvcBaseEntryField(C).GetValue(s);
          PShortString(P)^ := Shortstring(s);
        end;
      end;
    end else if C is TOvcBaseEntryField then
      TOvcBaseEntryField(C).GetValue(P^);

    {position to next item in the transfer buffer}
    Inc(P, xfrGetComponentDataSize(C, xfrStringtype));
  end;
end;


procedure TOvcTransfer.TransferFromForm(CNA : array of TComponent; var Data);
  {-transfer forms data to structure pointed to by Data }
begin
  TransferFromFormPrim(CNA, Data, xfrString);
end;


procedure TOvcTransfer.TransferFromFormZ(CNA : array of TComponent; var Data);
  {-transfer forms data to structure pointed to by Data }
begin
  TransferFromFormPrim(CNA, Data, xfrPChar);
end;


(*
procedure TOvcTransfer.TransferFromFormZ(CNA : array of TComponent; var Data);
  {-transfer forms data to structure pointed to by Data}
var
  I  : Integer;
  P  : PByte;
  C  : TComponent;
  St : TStrings;
begin
  P := PByte(@Data);
  if P = nil then
    Exit;

  xfrList := TList.Create;
  try
    {fill list with components}
    for I := Low(CNA) to High(CNA) do
      xfrList.Add(CNA[I]);

    {transfer data to the buffer for each component in the list}
    for I := 0 to xfrList.Count-1 do begin
      C := TComponent(xfrList.Items[I]);
      if C is TEdit then
        StrPCopy(PChar(P), TEdit(C).Text)
      else if C is TLabel then
        StrPCopy(PChar(P), TLabel(C).Caption)
      else if C is TPanel then
        StrPCopy(PChar(P), TPanel(C).Caption)
      else if C is TMemo then begin
        Move(P^, ST, SizeOf(TStrings));
        ST.Assign(TMemo(C).Lines);
      end else if C is TCheckBox then
        Boolean(P^) := TCheckBox(C).Checked
      else if C is TRadioButton then
        Boolean(P^) := TRadioButton(C).Checked
      else if C is TListBox then begin
        PListBoxTransfer(P)^.ItemIndex := TListBox(C).ItemIndex;
        PListBoxTransfer(P)^.Items.Assign(TListBox(C).Items);
      end else if C is TComboBox then begin
        PComboBoxTransfer(P)^.ItemIndex := TComboBox(C).ItemIndex;
        PComboBoxTransfer(P)^.Text := TComboBox(C).Text;
        PComboBoxTransfer(P)^.Items.Assign(TComboBox(C).Items);
      end else if C is TOvcBaseEntryField then
        if isOvcBaseEntryField_with_string(C) then
          StrPCopy(PChar(P), TOvcBaseEntryField(C).AsString)
        else
          TOvcBaseEntryField(C).GetValue(P^)
      else if C is TOvcRotatedLabel then
        String(Pointer(P)^) := TOvcRotatedLabel(C).Caption;

      {position to next item in the transfer buffer}
      Inc(P, xfrGetComponentDataSize(C));
    end;
  finally
    xfrList.Free;
  end;
end;
*)


procedure TOvcTransfer.TransferFromFormS(CNA : array of TComponent; var Data);
  {-transfer forms data to structure pointed to by Data }
begin
  TransferFromFormPrim(CNA, Data, xfrShortString);
end;


procedure TOvcTransfer.TransferToFormPrim(CNA : array of TComponent; const Data; xfrStringtype : TxfrStringtype);
  {-transfer data from structure pointed to by Data to form

   -Changes
    03/2011, AB: Bugfix: Data-transfer from 'Data' did not work in case of TOvcBaseEntryField
                 with datatype string. }
var
  I  : Integer;
  P  : PByte;
  C  : TComponent;
  St : TStrings;
  s  : string;
begin
  P := PByte(@Data);
  if P = nil then
    Exit;

  {transfer data to the form for each component in the list}
  for I := Low(CNA) to High(CNA) do begin
    C := CNA[I];
    if (C is TEdit) or (C is TLabel) or (C is TPanel) or (C is TOvcRotatedLabel) or
       (C is TOvcEditor) then begin
      case xfrStringtype of
        xfrString:
          s := string(Pointer(P)^);
        xfrPChar:
          s := PChar(P);
        xfrShortString:
          s := string(PShortString(P)^);
      end;
      if C is TEdit then
        TEdit(C).Text := s
      else if C is TLabel then
        TLabel(C).Caption := s
      else if C is TPanel then
        TPanel(C).Caption := s
      else if C is TOvcEditor then
        TOvcEditor(C).Text := s
      else
        TOvcRotatedLabel(C).Caption := s;
    end else if C is TMemo then begin
      case xfrStringtype of
        xfrString: begin
          Move(P^, St, SizeOf(TStrings));
          TMemo(C).Lines.Assign(St);
        end;
        xfrPChar:
          TMemo(C).Lines.Text := PChar(P);
        xfrShortString:
          TMemo(C).Lines.Text := string(PShortString(P)^);
      end;
    end else if C is TCheckBox then
      TCheckBox(C).Checked := Boolean(P^)
    else if C is TRadioButton then
      TRadioButton(C).Checked := Boolean(P^)
    else if C is TListBox then begin
      TListBox(C).Items.Assign(PListBoxTransfer(P)^.Items);
      TListBox(C).ItemIndex := PListBoxTransfer(P)^.ItemIndex;
    end else if C is TComboBox then begin
      TComboBox(C).Items.Assign(PComboBoxTransfer(P)^.Items);
      TComboBox(C).ItemIndex := PComboBoxTransfer(P)^.ItemIndex;
      TComboBox(C).Text := PComboBoxTransfer(P)^.Text;
    end else if isOvcBaseEntryField_with_string(C) then begin
      case xfrStringtype of
        xfrString:
          TOvcBaseEntryField(C).SetValue(PString(P)^);
        xfrPChar: begin
          s := StrPas(PChar(P));
          TOvcBaseEntryField(C).SetValue(s);
        end;
        xfrShortString: begin
          s := string(PShortString(P)^);
          TOvcBaseEntryField(C).SetValue(s);
        end;
      end;
    end else if C is TOvcBaseEntryField then
      TOvcBaseEntryField(C).SetValue(P^);

    {position to next item in the transfer buffer}
    Inc(P, xfrGetComponentDataSize(C, xfrStringtype));
  end;
end;


procedure TOvcTransfer.TransferToForm(CNA : array of TComponent; const Data);
begin
  TransferToFormPrim(CNA, Data, xfrString);
end;


procedure TOvcTransfer.TransferToFormZ(CNA : array of TComponent; const Data);
begin
  TransferToFormPrim(CNA, Data, xfrPChar);
end;

(*
procedure TOvcTransfer.TransferToFormZ({const} CNA : array of TComponent; const Data);
  {-transfer data from structure pointed to by Data to form}
var
  I  : Integer;
  P  : PByte;
  C  : TComponent;
  St : TStrings;
begin
  P := PByte(@Data);
  if P = nil then
    Exit;

  xfrList := TList.Create;
  try
    {fill list with components}
    for I := Low(CNA) to High(CNA) do
      xfrList.Add(CNA[I]);

    {transfer data to the form for each component in the list}
    for I := 0 to xfrList.Count-1 do begin
      C := TComponent(xfrList.Items[I]);
      if C is TEdit then
        TEdit(C).Text := StrPas(PChar(P))
      else if C is TLabel then
        TLabel(C).Caption := StrPas(PChar(P))
     else if C is TPanel then
        TPanel(C).Caption := StrPas(PChar(P))
     else if C is TMemo then begin
        Move(P^, ST, SizeOf(TStrings));
        TMemo(C).Lines.Assign(ST);
      end else if C is TCheckBox then
        TCheckBox(C).Checked := Boolean(P^)
      else if C is TRadioButton then
        TRadioButton(C).Checked := Boolean(P^)
      else if C is TListBox then begin
        TListBox(C).Items.Assign(PListBoxTransfer(P)^.Items);
        TListBox(C).ItemIndex := PListBoxTransfer(P)^.ItemIndex;
      end else if C is TComboBox then begin
        TComboBox(C).Items.Assign(PComboBoxTransfer(P)^.Items);
        TComboBox(C).ItemIndex := PComboBoxTransfer(P)^.ItemIndex;
        TComboBox(C).Text := PComboBoxTransfer(P)^.Text;
      end else if C is TOvcBaseEntryField then
        if isOvcBaseEntryField_with_string(C) then
           TOvcBaseEntryField(C).AsString := StrPas(PChar(P))
        else
          TOvcBaseEntryField(C).SetValue(P^)
      else if C is TOvcRotatedLabel then
        TOvcRotatedLabel(C).Caption := String(Pointer(P)^);

      {position to next item in the transfer buffer}
      Inc(P, xfrGetComponentDataSize(C, xfrStringtype));
    end;
  finally
    xfrList.Free;
  end;
end;
*)


procedure TOvcTransfer.TransferToFormS(CNA : array of TComponent; const Data);
begin
  TransferToFormPrim(CNA, Data, xfrShortString);
end;


function TOvcTransfer.xfrGetComponentDataSize(C : TComponent; xfrStringtype : TxfrStringtype) : Word;
  {-return the size of the data for this component

   -Changes
    03/2011, AB: New parameter 'xfrStringtype' defines the datatype used to store strings }
begin
  Result := 0;
  if C is TEdit then begin
    case xfrStringtype of
      xfrString:
        result := SizeOf(string);
      xfrPChar:
        if TEdit(C).MaxLength=0 then
          result := (xfrMaxPChar+1)*SizeOf(Char)
        else
          result := (TEdit(C).MaxLength+1)*SizeOf(Char);
      xfrShortString:
        if TEdit(C).MaxLength=0 then
          result := SizeOf(ShortString)
        else
          result := TEdit(C).MaxLength+1;
    end;
  end else if (C is TLabel) or (C is TPanel) or (C is TOvcRotatedLabel) or
              (C is TOvcEditor) then begin
    case xfrStringtype of
      xfrString:
        result := SizeOf(string);
      xfrPChar:
        result := (xfrMaxPChar+1)*SizeOf(Char);
      xfrShortString:
        result := SizeOf(ShortString);
    end;
  end else if C is TListBox then
    Result := SizeOf(TListBoxTransfer)
  else if C is TComboBox then
    Result := SizeOf(TComboBoxTransfer)
  else if C is TMemo then begin
    case xfrStringtype of
      xfrString:
        result := SizeOf(TStrings);
      xfrPChar:
        result := (xfrMaxPChar+1)*SizeOf(Char);
      xfrShortString:
        result := SizeOf(ShortString);
    end;
  end else if (C is TCheckbox) or (C is TRadioButton) then
    Result := SizeOf(Boolean)
  else if isOvcBaseEntryField_with_string(C) then begin
    {-the size needed for string-type TOvcBaseEntryFields depends on 'xfrStringtype'}
    case xfrStringtype of
      xfrString:
        { The data-record contains string fields; so only pointers to the actual strings are
          stored; the size needed for this pointer is given by SizeOf(string). }
        result := SizeOf(string);
      xfrPChar:
        { The data-record contains null-terminated strings; so space for MaxLength+1
          characters (ansi or unicode, depending on the compiler) is needed. }
        result := (TLocalEF(C).MaxLength+1)*SizeOf(Char);
      xfrShortString:
        { The data-record contains ShortStrings. These are always single-byte-character strings,
          so MaxLength+1 bytes are used. }
        result := TLocalEF(C).MaxLength+1;
    end;
  end else if C is TOvcBaseEntryField then
    Result := TOvcBaseEntryField(C).DataSize
  else
    Result := 0;
end;


end.
