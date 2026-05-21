unit VAHelpers;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.StdCtrls,
  System.Generics.Collections,
  VCL.Menus,
  Vcl.ComCtrls,
  VCL.Forms;

type
  TVACustomListBoxHelper = class helper for TCustomListBox
  public
    /// <summary>Forces OnMeasureItem to be called again for each item</summary>
    procedure ForceItemHeightRecalc;
  end;

  TMenuHelper = class helper for VCL.Menus.TMenu
  private
   procedure UpdateMenuItems(aMenuItem: TMenuItem);
  public
   procedure UpdateFont(aFontSize: Integer);
  end;

  TScrollingWinControlHelper = class helper for VCL.Forms.TScrollingWinControl
  public
    procedure UpdateMenuFonts(aForm: TScrollingWinControl; aFontSize: Integer);
  end;

  TListViewHelper = class helper for TListView
  public
    procedure AutoSizeReportViewColumnWidths(
      const AMinWidth: Integer = -1; const AMaxWidth: Integer = -1);
    procedure AutoSizeReportViewHeight(const AVisibleRowCount: Integer);
  end;


implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl;

{ TVACustomListBoxHelper }

procedure TVACustomListBoxHelper.ForceItemHeightRecalc;
var
  I: integer;
begin
  LockDrawing;
  try
    for I := 0 to Items.Count - 1 do
      Items[I] := Items[I];
  finally
    UnlockDrawing;
  end;
end;

{ TMenuHelper }

type
  THackMenuItem = class(vcl.menus.TMenuItem);

procedure TMenuHelper.UpdateFont(aFontSize: Integer);
begin
 If Screen.MenuFont.Size <> aFontSize then
  Screen.MenuFont.Size := aFontSize;

 OwnerDraw := True;

 for var i: Integer := 0 to Items.Count - 1 do
    UpdateMenuItems(Items[i]);
end;

procedure TMenuHelper.UpdateMenuItems(aMenuItem: TMenuItem);
begin
  THackMenuItem(aMenuItem).MenuChanged(true);
  for var I: Integer := 0 to aMenuItem.Count - 1 do
    UpdateMenuItems(aMenuItem[i]);
end;

{ TScrollingWinControlHelper }

procedure TScrollingWinControlHelper.UpdateMenuFonts(
  aForm: TScrollingWinControl; aFontSize: Integer);
var
  I: Integer;
begin

  // Update all menus (menus on first level)
  For I := 0 to aForm.ComponentCount - 1 do
  begin
    If aForm.Components[I] is TMenu then
      (aForm.Components[I] as TMenu).UpdateFont(aFontSize);
  end;

end;

{ TListViewHelper }

procedure TListViewHelper.AutoSizeReportViewColumnWidths(
  const AMinWidth: Integer; const AMaxWidth: Integer);
var
  AColumn, AItem: Integer;
  AHeaderWidth, AItemWidth: Integer;
  ACellCaption: string;
  ANewWidth: Integer;
begin
  if ViewStyle <> vsReport then Exit;

  Columns.BeginUpdate;
  LockDrawing;
  try
    for AColumn := 0 to Columns.Count - 1 do
    begin
      ANewWidth := LVSCW_AUTOSIZE_USEHEADER; // Auto-size to fit the header text

      if AMinWidth > -1 then Columns[AColumn].MinWidth := AMinWidth;
      if AMaxWidth > -1 then Columns[AColumn].MaxWidth := AMaxWidth;

      AHeaderWidth := ListView_GetStringWidth(Handle,
        PChar(Columns[AColumn].Caption));

      for AItem := 0 to Items.Count - 1 do
      begin
        // The first column uses Items and the rest use SubItems
        if AColumn = 0 then
          ACellCaption := Items[AItem].Caption
        else if AColumn <= Items[AItem].SubItems.Count  then
          ACellCaption := Items[AItem].SubItems[AColumn - 1]
        else
          ACellCaption := '';

        AItemWidth := ListView_GetStringWidth(Handle, PChar(ACellCaption));

        // Check if the cell caption is larger than the header caption
        if AItemWidth > AHeaderWidth then
        begin
          ANewWidth := LVSCW_AUTOSIZE; // Auto-size to fit the item text
          Break;
        end;
      end;

      Columns[AColumn].Width := ANewWidth;
    end;
  finally
    UnlockDrawing;
    Columns.EndUpdate;
  end;
end;

procedure TListViewHelper.AutoSizeReportViewHeight(const AVisibleRowCount: Integer);
begin
  if ViewStyle <> vsReport then Exit;

  // HiWord is height, LoWord is width
  ClientHeight := HiWord(ListView_ApproximateViewRect(Handle, Height, Width, AVisibleRowCount));
end;

end.
