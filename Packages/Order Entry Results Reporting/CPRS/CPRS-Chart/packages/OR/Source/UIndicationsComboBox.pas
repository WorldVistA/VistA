unit UIndicationsComboBox;
///////////////////////////////////////////////////////////////////////////////
///  This unit exists for backwards compatibility with v32c of CPRS. There is
///  no reason to keep this code around after v32c completes its SDLC. Do not
///  create instances of this class outside of v32c of CPRS.
///////////////////////////////////////////////////////////////////////////////

interface
uses
  ORCtrls;

type
  TIndicationsComboBox = class(TORComboBox)
  end;

procedure Register;

implementation
uses
  System.Classes;

procedure Register;
begin
  RegisterComponents('CPRS', [TIndicationsComboBox]);
end;

end.
