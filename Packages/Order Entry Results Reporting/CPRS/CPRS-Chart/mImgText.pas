unit mImgText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls{, VA2006Utils};

type
  TfraImgText = class(TFrame)
    img: TImage;
    lblText: TLabel;
  end;

implementation

//uses VA508AccessibilityRouter;

{$R *.DFM}

{ TfraImgText }

initialization
  //SpecifyFormIsNotADialog(TfraImgText);

end.
