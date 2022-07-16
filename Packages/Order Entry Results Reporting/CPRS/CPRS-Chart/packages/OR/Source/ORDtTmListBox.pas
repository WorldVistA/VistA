unit ORDtTmListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls, Graphics, Controls, Forms, Dialogs;
type
  TORDtTmListBox = class(StdCtrls.TListBox)
  Private
    fMinTime: Integer;
    fMaxTime: Integer;
  protected
    // procedure Click; override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
    procedure SetItemIndex(const Value: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property MaxTime: Integer read fMaxTime write fMaxTime;
    property MinTime: Integer read fMinTime write fMinTime;
  end;

procedure Register;

implementation

procedure Register;
{ used by Delphi to put components on the Palette }
begin
  RegisterComponents('CPRS', [TORDtTmListBox]);
end;

function stripCharSet(AString: String; aSet: TSysCharSet): String;
var
  i: Integer;
begin
  Result := AString;
  for i := Length(Result) downto 1 do
    if not CharInSet(Result[i], aSet) then
      Delete(Result, i, 1);
end;

function stripChars(AString: String): String;
begin
  Result := stripCharSet(AString, ['0' .. '9']);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TORDtTmListBox.SetItemIndex(const Value: Integer);
var
  TempStr: String;

begin
  if Value <> -1 then
  begin
    TempStr := self.Items[Value];
    TempStr := stripChars(TempStr);

    if fMinTime > -1 then
      if StrToIntDef(TempStr, -1) < fMinTime then
        exit;
    if fMaxTime > -1 then
      if StrToIntDef(TempStr, -1) > fMaxTime then
        exit;
  end;
  inherited;
end;

procedure TORDtTmListBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  ind: Integer;
  TempStr: String;
begin
  if Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_PRIOR, VK_NEXT] then
  begin
    case Key of
      VK_UP, VK_LEFT:
        ind := ItemIndex - 1;
      VK_DOWN, VK_RIGHT:
        ind := ItemIndex + 1;
      VK_PRIOR:
        ind := ItemIndex - 11;
      VK_NEXT:
        ind := ItemIndex + 11;
    else
      ind := ItemIndex;
    end;
    if (ind < 0) or (ind >= Items.Count) then
      Key := 0
    else
    begin
      TempStr := self.Items[ind];
      TempStr := stripChars(TempStr);

      if fMinTime > -1 then
        if StrToIntDef(TempStr, -1) < fMinTime then
          Key := 0;
      if fMaxTime > -1 then
        if StrToIntDef(TempStr, -1) > fMaxTime then
          Key := 0;
    end;
  end;

  inherited;
end;

procedure TORDtTmListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  FontClr, BrshClr: TColor;
  TempStr: String;
begin
  // Draw invalid here
  TempStr := self.Items[Index];
  TempStr := stripChars(TempStr);

  With self.Canvas do
  begin
    BrshClr := clWindow;
    FontClr := clWindowText;
    if (odSelected in State) then
    begin
      BrshClr := clHighlight;
      FontClr := clHighlightText;
    end;
    if fMinTime > -1 then
    begin
      if StrToIntDef(TempStr, -1) < fMinTime then
        BrshClr := clLtGray;
    end;
    if fMaxTime > -1 then
    begin
      if StrToIntDef(TempStr, -1) > fMaxTime then
        BrshClr := clLtGray;
    end;
    Brush.Color := BrshClr;
    Font.Color := FontClr;

    FillRect(Rect);

    TextRect(Rect, Rect.Left, Rect.Top, Items.Strings[Index]);
  end;
end;

procedure TORDtTmListBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
  TempStr: String;
begin
  inherited;
  if (fMinTime > -1) or (fMaxTime > -1) then
  begin
    with Message.DrawItemStruct{$IFNDEF CLR}^{$ENDIF} do
    begin
      TempStr := self.Items[ItemID];
      TempStr := stripChars(TempStr);

      State := TOwnerDrawState(LoWord(itemState));

      if fMinTime > -1 then
      begin
        if StrToIntDef(TempStr, -1) < fMinTime then
        begin
          if (odFocused in State) then
            DrawFocusRect(hDC, rcItem);
        end;

      end
      else if fMaxTime > -1 then
      begin
        if StrToIntDef(TempStr, -1) > fMaxTime then
        begin
          if (odFocused in State) then
            DrawFocusRect(hDC, rcItem);
        end;
      end;
    end;
  end;
end;

constructor TORDtTmListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fMinTime := -1;
  fMaxTime := -1;
end;

destructor TORDtTmListBox.Destroy;
begin
  inherited;
end;

end.
