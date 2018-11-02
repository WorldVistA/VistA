{*********************************************************}
{*                  ORXFRC1.PAS 4.08                     *}
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
{* Armin Biernaczyk                                                           *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.$W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcxfrc1;
  {-Property editor for the transfer component}

interface

uses
  Windows, Classes, ClipBrd, Graphics, Forms, Controls, Buttons, StdCtrls,
  ExtCtrls, SysUtils, OvcConst, OvcData, OvcEF, OvcRLbl, OvcBase, OvcNbk, OvcLB,
  OvcEdit;

type
  TOvcfrmTransfer = class(TForm)
    NB: TOvcNotebook;
    memoTransfer: TMemo;
    memoInitialize: TMemo;
    memoSample: TMemo;
    btnClearAll: TButton;
    btnSelectAll: TButton;
    btnCopyToClipboard: TBitBtn;
    btnClose: TBitBtn;
    cbInitialize: TCheckBox;
    cbTransfer: TCheckBox;
    cbSample: TCheckBox;
    gbGenerate: TGroupBox;
    lbAllComponents: TOvcListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OvcController1: TOvcController;
    Label4: TLabel;
    gbStringOptions: TGroupBox;
    rbString: TRadioButton;
    rbPChar: TRadioButton;
    rbShortString: TRadioButton;
    btnGenerate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnCopyToClipboardClick(Sender: TObject);
    procedure NBPageChanged(Sender: TObject; Index: Integer);
  public
    ComponentForm : TComponent;
    ComponentList : TList;

    procedure SetButtonStatus;
    procedure SetInstructionText;
  end;

implementation

{$R *.DFM}

uses
  ovcxfer;

type
  TLocalEF = class(TOvcBaseEntryField);


{*** TfrmTransfer ***}

procedure TOvcfrmTransfer.SetButtonStatus;
begin
  btnGenerate.Enabled :=
    (lbAllComponents.SelCount > 0) and
    (cbInitialize.Checked or cbTransfer.Checked or cbSample.Checked);
end;

procedure TOvcfrmTransfer.SetInstructionText;
begin
  Label2.Caption := 'Copy the method declaration to the form''s ' +
                    '"private" section in the header and place the ' +
                    'method definition in the source unit for the form.';
  Label1.Caption := 'Copy this declaration to the form''s header, ' +
                    'prior to the form class'' declaration.';
end;

procedure TOvcfrmTransfer.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  SetButtonStatus;
end;

procedure TOvcfrmTransfer.btnSelectAllClick(Sender: TObject);
var
  I : Integer;
begin
  with lbAllComponents do
    for I := 0 to Items.Count-1 do
      Selected[I] := True;
  SetButtonStatus;
end;

procedure TOvcfrmTransfer.btnClearAllClick(Sender: TObject);
var
  I : Integer;
begin
  with lbAllComponents do
    for I := 0 to Items.Count-1 do
      Selected[I] := False;
  SetButtonStatus;
end;

procedure TOvcfrmTransfer.SelectionChange(Sender: TObject);
begin
  SetButtonStatus;
end;

procedure TOvcfrmTransfer.btnGenerateClick(Sender: TObject);
var
  I, J, L, Len : Integer;
  C            : TComponent;
  S            : string;
  NL           : TStringList;
  stype        : TxfrStringtype;


  function Spaces(Len : Integer) : string;
  begin
    result := StringOfChar(' ', Len);
  end;

begin
  {get the method for storing strings }
  if rbString.Checked then
    stype := xfrString
  else if rbPChar.Checked then
    stype := xfrPChar
  else
    stype := xfrShortString;

  {get length of longest name}
  Len := 0;
  for I := 0 to ComponentList.Count-1 do begin
    if not lbAllComponents.Selected[I] then
      Continue;
    C := TComponent(ComponentList.Items[I]);
    J := Length(C.Name);

    {adjust length for tag added to end of field name}
    {(e.g., the "Text" added to string fields)}
    if (C is TEdit) or (C is TLabel) or
       (C is TPanel) or (C is TOvcRotatedLabel) or (C is TOvcEditor) then
      Inc(J, 4)
    else if (C is TMemo) or (C is TOvcBaseEntryField) then
      Inc(J, 5)
    else if (C is TCheckBox) or (C is TRadioButton) then
      Inc(J, 7)
    else if (C is TListBox) or (C is TComboBox) then
      Inc(J, 14);

    if  J > Len then
      Len := J;
  end;

  if cbTransfer.Checked then with memoTransfer do begin
    memoTransfer.Clear;

    {emit record definition}
    Lines.Add(       'type');
    Lines.Add(Format('  {transfer buffer for the %s form}', [ComponentForm.Name]));
    Lines.Add(Format('  T%sTransferRec = packed record', [ComponentForm.Name]));

    {emit data declaration for each component}
    for I := 0 to ComponentList.Count-1 do begin
      if not lbAllComponents.Selected[I] then
        Continue;
      C := TComponent(ComponentList.Items[I]);
      J := Length(C.Name);

      if (C is TEdit) or (C is TLabel) or (C is TPanel) or (C is TOvcRotatedLabel) or
         (C is TOvcEditor) then begin
        if (C is TEdit) and (TEdit(C).MaxLength > 0) then
          L := TEdit(C).MaxLength
        else
          L := 255;
        case stype of
          xfrString:
            Lines.Add(Format('    %sText%*s : string;', [C.Name, Len-J-4, ' ']));
          xfrPChar:
            Lines.Add(Format('    %sText%*s : array[0..%d] of Char;', [C.Name, Len-J-4, ' ', L]));
          xfrShortString:
            Lines.Add(Format('    %sText%*s : string[%d];', [C.Name, Len-J-4, ' ', L]));
        end;
      end else if (C is TCheckBox) or (C is TRadioButton) then begin
        Lines.Add(Format('    %sChecked%s : Boolean;', [C.Name, Spaces(Len-J-7)]));
      end else if C is TMemo then begin
        Lines.Add(Format('    %sLines%s : TStrings;', [C.Name, Spaces(Len-J-5)]));
      end else if C is TListBox then begin
        Lines.Add(Format('    %sXfer%s : TListBoxTransfer;', [C.Name, Spaces(Len-J-4)]));
      end else if C is TComboBox then begin
        Lines.Add(Format('    %sXfer%s : TComboBoxTransfer;', [C.Name, Spaces(Len-J-4)]));
      end else if C is TOvcBaseEntryField then begin
        case TLocalEF(C).efDataType mod fcpDivisor of
          fsubString   : begin
            case stype of
              xfrString:
                S := 'string;';
              xfrPChar:
                S := Format('array[0..%d] of Char;',[TLocalEF(C).MaxLength]);
              xfrShortString:
                S := Format('string[%d];',[TLocalEF(C).MaxLength]);
              else
                S := '';
            end;
          end;
          fsubChar     : S := 'Char;';
          fsubBoolean  : S := 'Boolean;';
          fsubYesNo    : S := 'Boolean;';
          fsubLongInt  : S := 'LongInt;';
          fsubWord     : S := 'Word;';
          fsubInteger  : S := 'SmallInt;';
          fsubByte     : S := 'Byte;';
          fsubShortInt : S := 'ShortInt;';
          fsubReal     : S := 'Real;';
          fsubExtended : S := 'Extended;';
          fsubDouble   : S := 'Double;';
          fsubSingle   : S := 'Single;';
          fsubComp     : S := 'Comp;';
          fsubDate     : S := 'TStDate;';
          fsubTime     : S := 'TStTime;';
        else
          S := '';
        end;
        Lines.Add(Format('    %sValue%s : %s',
         [C.Name, Spaces(Len-J-5), S]));
      end;
    end;
    {end of record structure}
    Lines.Add('  end;');
  end;

  if cbInitialize.Checked then with memoInitialize do begin
    memoInitialize.Clear;

    {create stub for initialization method}
    Lines.Add(Format('procedure Init%sTransfer(var Data : T%0:sTransferRec);', [ComponentForm.Name]));
    Lines.Add(       '  {-initialize transfer buffer}');
    Lines.Add(       ' ');

    {create initialization method}
    Lines.Add(Format('procedure T%s.Init%0:sTransfer(var Data : T%0:sTransferRec);',
     [ComponentForm.Name]));
    Lines.Add(       '  {-initialize transfer buffer}');
    Lines.Add(       'begin');
    Lines.Add(       '  with Data do begin');

    {initialize each field in the record}
    for I := 0 to ComponentList.Count-1 do begin
      if not lbAllComponents.Selected[I] then
        Continue;
      C := TComponent(ComponentList.Items[I]);
      J := Length(C.Name);

      if (C is TEdit) or (C is TLabel) or
         (C is TPanel) or (C is TOvcRotatedLabel) or (C is TOvcEditor) then begin
        Lines.Add(Format('    %sText%s := '''';',
         [C.Name, Spaces(Len-J-4)]));
      end else if (C is TCheckBox) or (C is TRadioButton) then begin
        Lines.Add(Format('    %sChecked%s := False;',
         [C.Name, Spaces(Len-J-7)]));
      end else if (C is TMemo) then begin
        Lines.Add(Format('    %sLines%s := TStringList.Create;',
         [C.Name, Spaces(Len-J-5)]));
      end else if (C is TListBox) then begin
        Lines.Add(Format('    %sXfer.Items%s := TStringList.Create;',
         [C.Name, Spaces(Len-J-10)]));
        Lines.Add(Format('    %sXfer.ItemIndex%s := 0;',
         [C.Name, Spaces(Len-J-14)]));
      end else if (C is TComboBox) then begin
        Lines.Add(Format('    %sXfer.Items%s := TStringList.Create;',
         [C.Name, Spaces(Len-J-10)]));
        Lines.Add(Format('    %sXfer.ItemIndex%s := 0;',
         [C.Name, Spaces(Len-J-14)]));
        Lines.Add(Format('    %sXfer.Text%s := '''';',
         [C.Name, Spaces(Len-J-9)]));
      end else if (C is TOvcBaseEntryField) then begin
        case TLocalEF(C).efDataType mod fcpDivisor of
          fsubString   : S := ''''';';
          fsubChar     : S := ''' '';';
          fsubBoolean,
          fsubYesNo    : S := 'False;';
          fsubLongInt,
          fsubWord,
          fsubInteger,
          fsubByte,
          fsubShortInt,
          fsubReal,
          fsubExtended,
          fsubDouble,
          fsubSingle,
          fsubComp     : S := '0;';
          fsubDate     : S := 'OvcDate.CurrentDate; {in OvcDate unit}';
          fsubTime     : S := 'OvcDate.CurrentTime; {in OvcDate unit}';
        else
          S := '';
        end;
        Lines.Add(Format('    %sValue%s := %s',
         [C.Name, Spaces(Len-J-5), S]));
      end;
    end;

    {add end of with and method}
    Lines.Add('  end; {with}');
    Lines.Add('end;');
  end;

  if cbSample.Checked then with memoSample do begin
    memoSample.Clear;

    Lines.Add(       'var');
    Lines.Add(       '{transfer record declaration}');
    Lines.Add(Format('  TR : T%sTransferRec;', [ComponentForm.Name]));
    Lines.Add(       #13);
    Lines.Add(       '{call to initialize the transfer record}');
    Lines.Add(Format('Init%sTransfer(TR);', [ComponentForm.Name]));

    NL := TStringList.Create;
    try
      {build list of component names}
      for I := 0 to ComponentList.Count-1 do
        if lbAllComponents.Selected[I] then
          NL.Add(TComponent(ComponentList.Items[I]).Name);

      Lines.Add(#13);
      Lines.Add('{call to transfer data to the form}');
      case stype of
        xfrPChar:       S := 'OrTransfer1.TransferToFormZ([';
        xfrShortString: S := 'OrTransfer1.TransferToFormS([';
        else            S := 'OrTransfer1.TransferToForm([';
      end;
      Len := Length(S);

      if NL.Count = 1 then
        Lines.Add(S + NL[0] + '], TR);')
      else begin
        for I := 0 to NL.Count-2 do begin
          if I = 0 then
            Lines.Add(S + NL[0] + ',')
          else
            Lines.Add(Spaces(Len) + NL[I] + ',');
        end;

        {add the last item}
        Lines.Add(Spaces(Len) + NL[NL.Count-1] + '], TR);');
      end;

      Lines.Add(#13);
      Lines.Add('{call to transfer data from the form}');
      case stype of
        xfrPChar:       S := 'OrTransfer1.TransferFromFormZ([';
        xfrShortString: S := 'OrTransfer1.TransferFromFormS([';
        else            S := 'OrTransfer1.TransferFromForm([';
      end;
      Len := Length(S);

      if NL.Count = 1 then
        Lines.Add(S + NL[0] + '], TR);')
      else begin
        for I := 0 to NL.Count-2 do begin
          if I = 0 then
            Lines.Add(S + NL[0] + ',')
          else
            Lines.Add(Spaces(Len) + NL[I] + ',');
        end;

        {add the last item}
        Lines.Add(Spaces(Len) + NL[NL.Count-1] + '], TR);');
      end;

    finally
      NL.Free;
    end;
  end;

  if cbTransfer.Checked then
    NB.Pages[1].Enabled := True;
  if cbInitialize.Checked then
    NB.Pages[2].Enabled := True;
  if cbSample.Checked then
    NB.Pages[3].Enabled := True;

  {enable button for clipboard copy}
  btnCopyToClipboard.Enabled := True;
end;

procedure TOvcfrmTransfer.btnCopyToClipboardClick(Sender: TObject);
var
  I : Integer;
  M : TStringList;
  P : Integer;
begin
  {get active notebook page index}
  P := NB.PageIndex;

  M := TStringList.Create;
  try
    {copy transfer record to string list}
    if ((P = 0) or (P = 1)) and (memoTransfer.Lines.Count > 0) then begin
      M.Add(#13#10'>>> Transfer record <<<'#13#10);
      for I := 0 to memoTransfer.Lines.Count-1 do
        M.Add(memoTransfer.Lines[I]);
    end;

    {copy init code to the string list}
    if ((P = 0) or (P = 2)) and (memoInitialize.Lines.Count > 0) then begin
      M.Add(#13#10'>>> Initialization header and method <<<'#13#10);
      for I := 0 to memoInitialize.Lines.Count-1 do
        M.Add(memoInitialize.Lines[I]);
    end;

    {copy sample transfer calls to string list}
    if ((P = 0) or (P = 3)) and (memoSample.Lines.Count > 0) then begin
      M.Add(#13#10'>>> Sample transfer calls <<<'#13#10);
      for I := 0 to memoSample.Lines.Count-1 do
        M.Add(memoSample.Lines[I]);
    end;

    {copy string list to the clipboard}
    if M.Count > 0 then
      Clipboard.SetTextBuf(PChar(M.Text));
  finally
    M.Free;
  end;
end;

procedure TOvcfrmTransfer.NBPageChanged(Sender: TObject; Index: Integer);
begin
  btnCopyToClipboard.Caption := NB.Pages[Index].Hint;
end;

end.
