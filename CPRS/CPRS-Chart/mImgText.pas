unit mImgText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfraImgText = class(TFrame)
    img: TImage;
    lblText: TLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses VA508AccessibilityRouter;

{$R *.DFM}

{ TfraImgText }

constructor TfraImgText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := FALSE;
end;

initialization
  SpecifyFormIsNotADialog(TfraImgText);

end.
