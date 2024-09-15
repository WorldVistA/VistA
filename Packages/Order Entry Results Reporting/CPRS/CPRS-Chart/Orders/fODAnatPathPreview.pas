unit fODAnatPathPreview;

// Developer: Theodore Fontana
// 02/24/17

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Graphics, Vcl.Menus, Vcl.CheckLst, Vcl.Buttons, ORCtrls,
  fODBase, VA508AccessibilityManager, ORExtensions, fBase508Form;

type
  TfrmAnatPathPreview = class(TfrmBase508Form)
    lvwSpecimen: ORExtensions.TListView;
    memText: TCaptionMemo;
    pnlBottom: TPanel;
    btnAccept: TBitBtn;
    btnBack: TBitBtn;
    pnlSummary: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
  public
  end;

var
  frmAnatPathPreview: TfrmAnatPathPreview;

implementation

{$R *.dfm}

uses
  fODAnatPath, mODAnatPathBuilder, mODAnatpathSpecimen, uDocTree, Winapi.CommCtrl;

procedure TfrmAnatPathPreview.FormCreate(Sender: TObject);
var
  I, x: Integer;
  LabSpecimen: TLabSpecimen;
  lvwItem: TListItem;
  sOrderComment: string;
  sl,hl: TStringList;
begin
  if assigned(Owner) and (Owner is TForm) then
    Font.Size := TForm(Owner).Font.Size;

  pnlSummary.Caption := frmODAnatPath.GetSummary;

  if ALabTest <> nil then
    for I := 0 to ALabTest.LabSpecimenList.Count - 1 do
    begin
      LabSpecimen := ALabTest.LabSpecimenList.Items[I];
      lvwItem := lvwSpecimen.Items.Add;
      lvwItem.Caption := IntToStr(I + 1);
      lvwItem.SubItems.Add(LabSpecimen.SpecimenExternal);
      lvwItem.SubItems.Add(LabSpecimen.SpecimenDescription);
      lvwItem.SubItems.Add(LabSpecimen.CollectionSampleExternal);
    end;

  sOrderComment := frmODAnatPath.GetOrderComment;
  if sOrderComment <> '' then
  begin
    memText.Lines.Add('Order Comment');
    memText.Lines.Add('--------------------------------------------------------------------------');
    memText.Lines.Add(sOrderComment);
    memText.Lines.Add('');
  end;

  sl := TStringList.Create;
  try
    hl := TStringList.Create;
    try
      if ALabTest <> nil then
        for I := 0 to ALabTest.LabTextList.Count - 1 do
        begin
          ALabTest.LabTextList.Items[I].GetText(sl);
          if sl.Count > 0 then
          begin
            ALabTest.LabTextList.Items[I].GetHeader(hl);
            memText.Lines.AddStrings(hl);
            memText.Lines.AddStrings(sl);
            memText.Lines.Add('');
          end;
        end;
    finally
      hl.Free;
    end;
  finally
    sl.Free;
  end;
  lvwSpecimen.Columns[2].AutoSize := False;
  try
    AutoSizeColumns(lvwSpecimen, [0, 1, 2, 3]);
    if ListView_GetCountPerPage(lvwSpecimen.Handle) <= lvwSpecimen.Items.Count
    then
      x := GetSystemMetrics(SM_CXVSCROLL) + 24
    else
      x := 20;
    for I := 0 to 3 do
      x := x + lvwSpecimen.Columns[I].Width;
    if Width < x then
    begin
      if x > Screen.WorkAreaWidth then
        x := Screen.WorkAreaWidth;
      Width := x;
    end;
    if Width > x then
      lvwSpecimen.Columns[2].Width := lvwSpecimen.Columns[2].Width + Width - x;
  finally
    lvwSpecimen.Columns[2].AutoSize := True;
  end;
end;

procedure TfrmAnatPathPreview.btnBackClick(Sender: TObject);
begin
  Close;
end;

end.
