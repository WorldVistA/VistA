unit UIndicationsComboBox;
///////////////////////////////////////////////////////////////////////////////
///  This unit should not exist in v33, it only exist to isolate changes to
///  ORComboBox for indications in v32c. The changes that were made to
///  TORCombobox ahould be carried forward into that object and made to affect
///  every TORComboBox in v33.
///////////////////////////////////////////////////////////////////////////////

interface
uses
  ORCtrls,
  System.Classes,
  Vcl.Controls;

type
  TIndicationsComboBox = class(TORComboBox)
  private
    FPrevEditBoxText: string; // Contents of FEditBox.Text when FKeyIsDown
    FOldEditKeyUp: TKeyEvent;
    FOldEditKeyDown: TKeyEvent;
  protected
    procedure FwdChange(Sender: TObject); override;
    procedure FwdChangeDelayed; override;
    procedure DoEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation
uses
  Winapi.Windows,
  Winapi.Messages;

procedure Register;
begin
  RegisterComponents('CPRS', [TIndicationsComboBox]);
end;

{ TIndicationsComboBox }

constructor TIndicationsComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FOldEditKeyDown := EditBox.OnKeyDown;
  EditBox.OnKeyDown := DoEditKeyDown;
  FOldEditKeyUp := EditBox.OnKeyUp;
  EditBox.OnKeyUp := DoEditKeyUp;
end;

procedure TIndicationsComboBox.DoEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if Assigned(FOldEditKeyDown) then FOldEditKeyDown(Sender, Key, Shift);
  finally
    FPrevEditBoxText := EditBox.Text;
  end;
end;

procedure TIndicationsComboBox.DoEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FPrevEditBoxText := '';
  if Assigned(FOldEditKeyUp) then FOldEditKeyUp(Sender, Key, Shift);
end;

procedure TIndicationsComboBox.FwdChange(Sender: TObject);
var
  IsChangeDeleteOnly: Boolean;
begin
  if FromSelf then Exit;
  IsChangeDeleteOnly := Copy(FPrevEditBoxText, 1, Length(EditBox.Text)) = EditBox.Text;
  FPrevEditBoxText := EditBox.Text;
  if not IsChangeDeleteOnly then ChangePending := True;
  if ListBox.LongList and KeyIsDown then Exit;
  if not IsChangeDeleteOnly then FwdChangeDelayed;
end;

procedure TIndicationsComboBox.FwdChangeDelayed;
{ when user types in the editbox, find a partial match in the listbox & set into editbox }
var
  SelectIndex, ASelStart: Integer;
  x: string;
begin
  ChangePending := False;
  if (not ListItemsOnly) and (Length(EditBox.Text) > 0) and (EditBox.SelStart = 0) then Exit; // **KCM** test this!

  if SelLength > 0 then
  begin
    x := Copy(EditBox.Text, 1, SelStart);
    ASelStart := -1;
  end else begin
    x := EditBox.Text;
    ASelStart := SelStart;
  end;

  LastInput := x;
  SelectIndex := -1;
  if Length(x) >= CharsNeedMatch then
    SelectIndex := ListBox.SelectString(x);
  if (Length(x) < CharsNeedMatch) and (ListBox.ItemIndex > -1) then
    SelectIndex := ListBox.SelectString(x);
  if UniqueAutoComplete then
    SelectIndex := ListBox.VerifyUnique(SelectIndex, x);
  if ListItemsOnly and (SelectIndex < 0) and (x <> '') then
  begin
    FromSelf := True;
    x := LastFound;
    SelectIndex := ListBox.SelectString(x);
    EditBox.Text := GetEditBoxText(SelectIndex);
    if (not ListBox.CheckBoxes) then
      SendMessage(EditBox.Handle, EM_SETSEL, Length(EditBox.Text), Length(x));
    FromSelf := False;
    Exit; // OnChange not called in this case
  end;
  FromSelf := True;
  if SelectIndex > -1 then
  begin
    EditBox.Text := GetEditBoxText(SelectIndex);
    LastFound := x;
    if (not ListBox.CheckBoxes) then
      SendMessage(EditBox.Handle, EM_SETSEL, Length(EditBox.Text), Length(x));
  end else
  begin
    if (ListBox.CheckBoxes) then
      EditBox.Text := GetEditBoxText(SelectIndex)
    else
      EditBox.Text := x; // no match, so don't set FLastFound
    if ASelStart < 0 then
    begin
      EditBox.SelStart := Length(x);
    end else begin
      EditBox.SelStart := ASelStart;
    end;
  end;
  FromSelf := False;
  if (not ListBox.CheckBoxes) then
    if Assigned(OnChange) then OnChange(Self);
end;

end.
