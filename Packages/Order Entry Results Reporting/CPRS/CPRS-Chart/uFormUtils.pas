unit uFormUtils;

interface

uses
  Controls, Forms, WinApi.Windows;

type
  TViewMode = (vmParentedForm, vmDialog, vmConfirmationDlg);

procedure setFormParented(aForm: TForm; aParent: TWinControl;
  anAlign: TAlign = alClient; aShow: Boolean = true);
procedure ListViewClearSortIndicator(aHandle:HWND; aColumn: Integer);
function CombineHeights(ctrl: array of TControl): integer;

implementation
uses
  WinApi.CommCtrl;

procedure setFormParented(aForm: TForm; aParent: TWinControl;
  anAlign: TAlign = alClient; aShow: Boolean = true);
begin
  if aForm.Parent <> aParent then
  begin
    aForm.BorderStyle := bsNone;
    aForm.Parent := aParent;
    aForm.Align := anAlign;
    aForm.Menu := nil;
    if aShow then
      aForm.Show;
  end;
end;

procedure ListViewClearSortIndicator(aHandle:HWND; aColumn: Integer);
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(aHandle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;

  // Clear the previous arrow
  Header_GetItem(Header, aColumn, Item);
  Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);//remove both flags
  Header_SetItem(Header, aColumn, Item);
end;

function CombineHeights(ctrl: array of TControl): integer;
var
  i: integer;

begin
  Result := 0;
  for i := Low(ctrl) to High(ctrl) do
  begin
    if ctrl[i].Visible then
    begin
      if ctrl[i].Align = alClient then
        inc(Result, ctrl[i].Constraints.MinHeight)
      else
        inc(Result, ctrl[i].Height);
      if ctrl[i].AlignWithMargins then
        inc(Result, ctrl[i].Margins.Top + ctrl[i].Margins.Bottom);
    end;
  end;
end;



end.
