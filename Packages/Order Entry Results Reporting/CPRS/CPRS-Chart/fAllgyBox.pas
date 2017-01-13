unit fAllgyBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fRptBox, StdCtrls, ExtCtrls, ComCtrls, fARTAllgy, ORFn,
  VA508AccessibilityManager, Vcl.Menus;

type
  TfrmAllgyBox = class(TfrmReportBox)
    cmdEdit: TButton;
    cmdAdd: TButton;
    cmdInError: TButton;
    procedure cmdAddClick(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
    procedure cmdInErrorClick(Sender: TObject);
  private
    { Private declarations }
    FAllergyIEN: integer;
    procedure RefreshText;
  public
    { Public declarations }
  end;

procedure AllergyBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; AllergyIEN: integer);

var
  frmAllgyBox: TfrmAllgyBox;

implementation

{$R *.dfm}

uses rCover, fCover, rODAllergy, uCore;

const
  NEW_ALLERGY = True;
  ENTERED_IN_ERROR = True;

function CreateAllergyBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean): TfrmAllgyBox;
var
  i, AWidth, MaxWidth, AHeight: Integer;
  Rect: TRect;
  // %$@# buttons!
  BtnArray: array of TButton;
  BtnRight: array of integer;
  BtnLeft:  array of integer;
  j, k: integer;
  x: string;
begin
  Result := TfrmAllgyBox.Create(Application);
  try
    with Result do
    begin
      k := 0;
      with pnlButton do for j := 0 to ControlCount - 1 do
        if Controls[j] is TButton then
          begin
            SetLength(BtnArray, k+1);
            SetLength(BtnRight, k+1);
            BtnArray[j] := TButton(Controls[j]);
            BtnRight[j] := ResizeWidth(Font, MainFont, BtnArray[j].Width - BtnArray[j].Width - BtnArray[j].Left);
            k := k + 1;
          end;
      MaxWidth := 350;
      for i := 0 to ReportText.Count - 1 do
      begin
        AWidth := lblFontTest.Canvas.TextWidth(ReportText[i]);
        if AWidth > MaxWidth then MaxWidth := AWidth;
      end;
      MaxWidth := MaxWidth + GetSystemMetrics(SM_CXVSCROLL);
      AHeight := (ReportText.Count * (lblFontTest.Height + 2)) + pnlbutton.Height;
      AHeight := HigherOf(AHeight, 250);
      if AHeight > (Screen.Height - 80) then AHeight := Screen.Height - 80;
      if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
      ClientWidth := MaxWidth;
      ClientHeight := AHeight;
      Rect := BoundsRect;
      ForceInsideWorkArea(Rect);
      BoundsRect := Rect;
      ResizeAnchoredFormToFont(Result);

      //CQ6889 - force Print & Close buttons to bottom right of form regardless of selected font size
      cmdClose.Left := (pnlButton.Left+pnlButton.Width)-cmdClose.Width;
      cmdPrint.Left := (cmdClose.Left-cmdPrint.Width) - 1;
      //end CQ6889

      Constraints.MinWidth := cmdAdd.Width + cmdEdit.Width + cmdInError.Width + cmdPrint.Width + cmdClose.Width + 20;
      Constraints.MinHeight := 2*pnlButton.Height + memReport.Height;
      cmdAdd.Left := 1;
      cmdEdit.Left := (cmdAdd.Left + cmdAdd.Width) + 1;
      cmdInError.Left := (cmdEdit.Left + cmdEdit.Width) + 1;

      SetLength(BtnLeft, k);
      for j := 0 to k - 1 do
        BtnLeft[j] := pnlButton.Width - BtnArray[j].Width - BtnRight[j];
      QuickCopy(ReportText, memReport);
      for i := 1 to Length(ReportTitle) do if ReportTitle[i] = #9 then ReportTitle[i] := ' ';
      Caption := ReportTitle;
      memReport.SelStart := 0;
      cmdPrint.Visible := AllowPrint;
      cmdAdd.Enabled := True;  //IsARTClinicalUser(x);   v26.12
      cmdEdit.Enabled := IsARTClinicalUser(x);  
      cmdInError.Enabled := IsARTClinicalUser(x);
    end;
  except
    if assigned(Result) then Result.Free;
    raise;
  end;
end;

procedure AllergyBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; AllergyIEN: integer);
begin
  frmAllgyBox := CreateAllergyBox(ReportText, ReportTitle, AllowPrint);
  try
    with frmAllgyBox do
    begin
      FAllergyIEN := AllergyIEN;
      if not ContainsVisibleChar(memReport.Text) then RefreshText;
      ShowModal;
    end;
  finally
    frmAllgyBox.Release;
  end;
end;

procedure TfrmAllgyBox.cmdAddClick(Sender: TObject);
begin
  inherited;
  Visible := False;
  EnterEditAllergy(0, NEW_ALLERGY, not ENTERED_IN_ERROR);
  Close;
end;

procedure TfrmAllgyBox.cmdEditClick(Sender: TObject);
var
  Changed: boolean;
begin
  inherited;
  Visible := False;
  Changed := EnterEditAllergy(FAllergyIEN, not NEW_ALLERGY, not ENTERED_IN_ERROR);
  if Changed then RefreshText;
  Visible := True;
end;

procedure TfrmAllgyBox.cmdInErrorClick(Sender: TObject);
begin
  inherited;
  Visible := False;
  MarkEnteredInError(FAllergyIEN);
  Close;
end;

procedure TfrmAllgyBox.RefreshText;
begin
  memReport.Clear;
  QuickCopy(DetailAllergy(FAllergyIEN), memReport);
end;

end.
