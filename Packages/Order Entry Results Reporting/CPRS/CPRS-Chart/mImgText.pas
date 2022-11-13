unit mImgText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls{, VA2006Utils};

type
  TfraImgText = class(TFrame)
    gp: TGridPanel;
    img: TImage;
    lblText: TStaticText;
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
  end;

implementation

uses VAUtils, VA508AccessibilityRouter;

{$R *.DFM}

{ TfraImgText }

procedure TfraImgText.FrameEnter(Sender: TObject);
begin
  gp.BorderStyle := bsSingle;
//  if parent is TGridPanel then
//    TGridPanel(parent).Hint := lblText.Caption;

  if ScreenReaderActive then
    GetScreenReader.Speak(lblText.Caption);
end;

procedure TfraImgText.FrameExit(Sender: TObject);
begin
  gp.BorderStyle := bsNone;
end;

initialization
  //SpecifyFormIsNotADialog(TfraImgText);

end.
