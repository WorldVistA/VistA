unit fIconLegend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, dShared,
  ComCtrls, StdCtrls, ExtCtrls, ImgList, mImgText, Menus, FAutoSz,
  VA508AccessibilityManager;

type
  TIconLegendType = (ilLast, ilNotes, ilTemplates, ilReminders, ilConsults, ilSurgery);

  TfrmIconLegend = class(TfrmAutoSz)
    pcMain: TPageControl;
    pnlBottom: TPanel;
    Templates: TTabSheet;
    Reminders: TTabSheet;
    btnOK: TButton;
    fraImgText1: TfraImgText;
    fraImgText2: TfraImgText;
    fraImgText3: TfraImgText;
    fraImgText4: TfraImgText;
    fraImgText5: TfraImgText;
    fraImgText6: TfraImgText;
    fraImgText7: TfraImgText;
    fraImgText12: TfraImgText;
    Panel1: TPanel;
    fraImgText8: TfraImgText;
    fraImgText10: TfraImgText;
    fraImgText15: TfraImgText;
    fraImgText16: TfraImgText;
    fraImgText17: TfraImgText;
    fraImgText13: TfraImgText;
    fraImgText14: TfraImgText;
    Panel2: TPanel;
    fraImgText22: TfraImgText;
    fraImgText20: TfraImgText;
    fraImgText19: TfraImgText;
    fraImgText18: TfraImgText;
    fraImgText21: TfraImgText;
    fraImgText11: TfraImgText;
    fraImgText9: TfraImgText;
    fraImgText23: TfraImgText;
    fraImgText24: TfraImgText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Notes: TTabSheet;
    fraImgText25: TfraImgText;
    fraImgText26: TfraImgText;
    fraImgText27: TfraImgText;
    fraImgText28: TfraImgText;
    fraImgText29: TfraImgText;
    fraImgText30: TfraImgText;
    fraImgText31: TfraImgText;
    fraImgText32: TfraImgText;
    fraImgText33: TfraImgText;
    fraImgText34: TfraImgText;
    Consults: TTabSheet;
    Panel3: TPanel;
    fraImgText35: TfraImgText;
    fraImgText36: TfraImgText;
    fraImgText43: TfraImgText;
    Panel4: TPanel;
    Label5: TLabel;
    fraImgText41: TfraImgText;
    fraImgText37: TfraImgText;
    fraImgText38: TfraImgText;
    fraImgText39: TfraImgText;
    fraImgText40: TfraImgText;
    Label4: TLabel;
    fraImgText44: TfraImgText;
    Surgery: TTabSheet;
    fraImgText42: TfraImgText;
    fraImgText45: TfraImgText;
    fraImgText46: TfraImgText;
    fraImgText47: TfraImgText;
    fraImgText48: TfraImgText;
    fraImgText49: TfraImgText;
    fraImgText50: TfraImgText;
    fraImgText51: TfraImgText;
    fraImgText52: TfraImgText;
    fraImgText53: TfraImgText;
    fraImgText54: TfraImgText;
    fraImgText55: TfraImgText;
    fraImgText56: TfraImgText;
    fraImgText57: TfraImgText;
    fraImgText58: TfraImgText;
    fraImgText59: TfraImgText;
    fraImgText60: TfraImgText;
    fraImgText61: TfraImgText;
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure ShowTab(tb: TIconLegendType);
    procedure SnapLabels;
  public
    class procedure SetFontSize( NewFontSize: integer);
  end;

procedure ShowIconLegend(IconType: TIconLegendType; Restart: boolean = FALSE);

implementation

uses
  fFrame, uConst, ORFn;

{$R *.DFM}

var
  frmIconLegend: TfrmIconLegend = nil;
  LastX, LastY: integer;
  FirstSize: boolean = TRUE;

procedure ShowIconLegend(IconType: TIconLegendType; Restart: boolean = FALSE);
begin
  if assigned(frmIconLegend) and Restart then
    FreeAndNil(frmIconLegend);
  if not assigned(frmIconLegend) then
  begin
    frmIconLegend := TfrmIconLegend.Create(Application);
    frmIconLegend.Surgery.TabVisible := frmFrame.TabExists(CT_SURGERY);
  end;
  frmIconLegend.ShowTab(IconType);
  TfrmIconLegend.SetFontSize( MainFontSize );
  frmIconLegend.Show;
end;

procedure TfrmIconLegend.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmIconLegend.ShowTab(tb: TIconLegendType);
begin
  case tb of
    ilTemplates: pcMain.ActivePage := Templates;
    ilReminders: pcMain.ActivePage := Reminders;
    ilNotes:     pcMain.ActivePage := Notes;
    ilConsults:  pcMain.ActivePage := Consults;
    ilSurgery:   pcMain.ActivePage := Surgery;
  end;
end;

procedure TfrmIconLegend.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;

end;

procedure TfrmIconLegend.FormDestroy(Sender: TObject);
begin
  LastX := Left;
  LastY := Top;
  frmIconLegend := nil;
end;

class procedure TfrmIconLegend.SetFontSize( NewFontSize: integer);
begin
  if Assigned(frmIconLegend) then begin
    if FirstSize or (frmIconLegend.Font.Size <> NewFontSize) then begin
      ResizeFormToFont(frmIconLegend);
      frmIconLegend.Font.Size := NewFontSize;
      frmIconLegend.SnapLabels;
      FirstSize := FALSE;
      LastX := (Screen.Width - frmIconLegend.Width) div 2;
      LastY := (Screen.Height - frmIconLegend.Height) div 2;
    end;
    frmIconLegend.Left := LastX;
    frmIconLegend.Top := LastY;
  end;
end;

procedure TfrmIconLegend.SnapLabels;
var
  i: integer;
begin
  for i := 0 to ComponentCount-1 do
    if Components[i] is TfraImgText then
      with TfraImgText(Components[i]).lblText do
        if (AutoSize and WordWrap) then begin
        {Snap width to fit.  We turn autosize off and on to snap height, too.
        If we don't tweak AutoSize, it tends to give the frame a vertical
        scroll bar.}
        AutoSize := False;
        Width := Parent.Width - Left - ScrollBarWidth;
        AutoSize := True;
      end;
end;

procedure TfrmIconLegend.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then begin
    if (ssCtrl in Shift) then begin
      if not (ActiveControl is TCustomMemo) or not TMemo(ActiveControl).WantTabs then begin
        pcMain.SelectNextPage( not (ssShift in Shift));
        Key := 0;
      end;
    end;
  end;
end;

end.



















