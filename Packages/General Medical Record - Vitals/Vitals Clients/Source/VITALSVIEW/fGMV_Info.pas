unit fGMV_Info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ActnList, StdActns;

type
  TfrmGMV_Info = class(TForm)
    reReport: TRichEdit;
    BitBtn1: TBitBtn;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    PrintDialog1: TPrintDialog;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGMV_Info: TfrmGMV_Info;

implementation


{$R *.dfm}
uses
  Printers;


procedure TfrmGMV_Info.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Escape then Close;
end;

procedure TfrmGMV_Info.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmGMV_Info.Button1Click(Sender: TObject);
begin
  try
    if SaveDialog1.Execute then
      reReport.Lines.SaveToFile(SaveDialog1.FileName);
  except
  end;
end;

procedure TfrmGMV_Info.Button2Click(Sender: TObject);
var
  rr: TRect;
  iPage,
  i,j: Integer;

  procedure DrawFrame(aR:TRect);
    begin
      Printer.Canvas.Brush.Color := clBlack;
      Printer.Canvas.FrameRect(aR);
      Printer.Canvas.Brush.Style := bsClear;
    end;

  procedure ClosePage;
    begin
      Printer.Canvas.TextOut(Printer.PageWidth-400,Printer.PageHeight-100,IntToStr(iPage));
      inc(iPage);
    end;

begin
  if PrintDialog1.Execute then
    with Printer do
      begin
//        Printer.Canvas.Font.Assign(FontEdit1.Dialog.Font);
//        if spbLandscape.Down then Orientation := poLandscape
//        else
          Orientation := poPortrait;

        rr := Rect(580,180,(Pagewidth - 180),(PageHeight - 180));

        BeginDoc;
        Canvas.Brush.Style := bsClear;
        j := 0;
        iPage := 1;
        for i := 0 to ReReport.Lines.Count do
          begin
            if ((j+1) * Canvas.TextHeight(reReport.Lines.Strings[i]))> (Pageheight - 400) then
              begin
                DrawFrame(rr);
                ClosePage;
                Newpage;
                j := 0;
              end;
            Canvas.TextOut(600,200 + (j *
                     Canvas.TextHeight(reReport.Lines.Strings[i])),
                     reReport.Lines.Strings[i]);
            inc(j);
          end;
//        DrawFrame(rr);
        ClosePage;
        EndDoc;
      end;
end;

end.
