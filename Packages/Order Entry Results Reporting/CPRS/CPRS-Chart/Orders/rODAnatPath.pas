unit rODAnatPath;

// Developer: Theodore Fontana
// 02/24/17

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.ComCtrls,
  ORCtrls;

type
  TBuildReturn = class(TObject)
    IEN: string;
      B: string;
      V: string;
  end;

  procedure ConfigureFrame(sPageRef,sOrderableItem: string; var oText: TStringList);
  procedure OrderElements(sType,sOrderItemIEN: string; var oText: TStringList);
  procedure APSpecimenList(sOrderItemIEN: string; var oText: TStringList);

  function CustomChangeMessage(sOrderItemIEN: string): string;
  function ItemInList(cbx: TORComboBox; sValue: string): Integer; overload;
  function ItemInList(cbx: TORComboBox; eValue: Extended; sPc: string): Integer; overload;
  function CompareStrSpaces(s1,s2: string): Boolean;
  function BuildReturnbyIEN(const BuildList: TObjectList<TBuildReturn>;
    sIEN: string): TBuildReturn;
  procedure SubSetOfAPOrderItems(aDest:TStrings; QuickOrderDlgIen: Integer;
              AccessData: string);

implementation

uses
  ORFn, ORNet;

procedure ConfigureFrame(sPageRef,sOrderableItem: string; var oText: TStringList);
begin
  oText.Clear;
  CallVistA('ORWLRAP1 CONFIG', [sPageRef, sOrderableItem], oText);
end;

procedure OrderElements(sType,sOrderItemIEN: string; var oText: TStringList);
begin
  oText.Clear;
  CallVistA('ORWLRAP1 CONFIG', [sType, sOrderItemIEN], oText);
end;

procedure APSpecimenList(sOrderItemIEN: string; var oText: TStringList);
begin
  oText.Clear;
  CallVistA('ORWLRAP1 SPEC', [sOrderItemIEN], oText);
end;

function CustomChangeMessage(sOrderItemIEN: string): string;
begin
  CallVistA('ORWLRAP1 CONFIG', ['OCM', sOrderItemIEN], Result);
end;

function ItemInList(cbx: TORComboBox; sValue: string): Integer;
var
  I,P: Integer;
  C: Char;
begin
  Result := -1;

  P := StrToIntDef(cbx.Pieces, 2);
  C := cbx.Delimiter;
  if Length(C) = 0 then
    C := U;

  for I := 0 to cbx.Items.Count - 1 do
    if Piece(cbx.Items[I], C, P) = sValue then
    begin
      Result := I;
      Break;
    end;
end;

function ItemInList(cbx: TORComboBox; eValue: Extended; sPc: string): Integer;
var
  I,P: Integer;
  C: Char;
  sValue: string;
begin
  Result := -1;

  sValue := FloatToStr(eValue);
  P := StrToIntDef(sPc, StrToInt(cbx.Pieces));
  C := cbx.Delimiter;
  if Length(C) = 0 then
    C := U;

  for I := 0 to cbx.Items.Count - 1 do
    if Piece(cbx.Items[I], C, P) = sValue then
    begin
      Result := I;
      Break;
    end;
end;

function CompareStrSpaces(s1,s2: string): Boolean;
begin
  Result := False;

  s1 := StringReplace(s1, ' ', '', [rfReplaceAll]);
  s2 := StringReplace(s2, ' ', '', [rfReplaceAll]);

  if AnsiCompareText(s1, s2) = 0 then
    Result := True;
end;

function BuildReturnbyIEN(const BuildList: TObjectList<TBuildReturn>;
  sIEN: string): TBuildReturn;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to BuildList.Count - 1 do
    if BuildList[I].IEN = sIEN then
    begin
      Result := BuildList[I];
      Break;
    end;
end;

procedure SubSetOfAPOrderItems(aDest:TStrings; QuickOrderDlgIen: Integer;
  AccessData: string);
begin
  aDest.Clear;
  CallVistA('ORWLRAP1 APORDITM', [QuickOrderDlgIen, AccessData], aDest);
end;


end.
