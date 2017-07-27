unit OR2006Compatibility;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

{$IFDEF VER140}
  Compile Error // should not be used in Delphi 6!
{$ENDIF}

type
  Tfrm2006Compatibility = class(TForm)
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

var
  frm2006Compatibility: Tfrm2006Compatibility;

implementation

{$R *.dfm}

{ Tfrm2006Compatibility }

constructor Tfrm2006Compatibility.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
// - if Form is pulled up in Delphi 6, the value stored in the DFM will be erased
  position := poDesigned;
  AutoScroll := True;
end;

end.
