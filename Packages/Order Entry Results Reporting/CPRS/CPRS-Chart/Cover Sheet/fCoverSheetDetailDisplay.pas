unit fCoverSheetDetailDisplay;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         ####-##-##
  *
  *       Description:  Main form for displaying detail on coversheet items.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  fBase508Form,
  VA508AccessibilityManager;

type
  TfrmCoverSheetDetailDisplay = class(TfrmBase508Form)
    pnlOptions: TPanel;
    btnClose: TButton;
    memDetails: TMemo;
    btnPrint: TButton;
    lblFontSizer: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCoverSheetDetailDisplay: TfrmCoverSheetDetailDisplay;

function ReportBox(aText: TStrings; aTitle: string; aAllowPrint: boolean): boolean;

implementation

{$R *.dfm}

{ TfrmCoverSheetDetailDisplay }

function ReportBox(aText: TStrings; aTitle: string; aAllowPrint: boolean): boolean;
var
  aStr: string;
  aWidth: integer;
  aCurWidth: integer;
  aMaxWidth: integer;
begin
  with TfrmCoverSheetDetailDisplay.Create(Application.MainForm) do
    try
      memDetails.Lines.Clear;
      memDetails.ScrollBars := ssVertical;
      aCurWidth := 300;
      aMaxWidth := Screen.Width - 100;
      lblFontSizer.Font := memDetails.Font;
      for aStr in aText do
        begin
          aWidth := lblFontSizer.Canvas.TextWidth(aStr);
          if aWidth > aCurWidth then
            if aWidth < aMaxWidth then
              aCurWidth := aWidth
            else
              begin
                aCurWidth := aMaxWidth;
                memDetails.ScrollBars := ssHorizontal;
              end;
          memDetails.Lines.Add(aStr);
        end;
      Caption := aTitle;
      btnPrint.Visible := aAllowPrint;
      ClientWidth := aCurWidth + 50;
      ShowModal;
    finally
      Free;
    end;
  Result := True;
end;

end.
