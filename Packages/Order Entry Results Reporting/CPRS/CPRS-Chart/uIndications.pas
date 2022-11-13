unit uIndications;

interface

uses
  Windows, Classes, Messages, SysUtils, ORCtrls, fODBase;

const
  INDICAT_LINE = '______________________________________________________________________';
  FLD_INDICATIONS = 99;
  TX_INDICATION_LIM = 'Indication must be between 3 and 40 characters.';
  TX_NO_INDICATION = 'Indication must be entered.';

type
  TIndications = class(TObject)
  private
    FDefaultIndications: TStringList;
    FIndications: TStringList;
//    FcboIndications: TORComboBox;
    FCtrlInits: TCtrlInits;
    FIsComplex: Boolean;
    FIsUNKNOWN: Boolean;
    // prefered Indications
    procedure LoadDefaultIndication;
    // all other indications
    procedure LoadIndications;
  public
    constructor Create(Owner: TCtrlInits);
    destructor Destroy; override;
    property CtrlInits: TCtrlInits read FCtrlInits write FCtrlInits;
    property IsComplex: Boolean read FIsComplex write FIsComplex;
    property IsUNKNOWN: Boolean read FIsUNKNOWN write FIsUNKNOWN;
    function GetIndicationList: String;
    function IsSelectedIndicationValid(pIndicationSelected: string): boolean;
    function IsIndicationLine(pIndicationSelected: string): Boolean;
    // Loads all indications for the ComboBox
    procedure Load;
    procedure ResetStringLists;
  end;

implementation

{ TIndications }

constructor TIndications.Create(Owner: TCtrlInits);
begin
  inherited Create;
  // Initialize
  CtrlInits := Owner;
  FDefaultIndications := TStringList.Create;
  FIndications := TStringList.Create;
end;

destructor TIndications.Destroy;
begin
  // Free
  FIndications.Free;
  FDefaultIndications.Free;
  inherited;
end;

procedure TIndications.ResetStringLists;
begin
  // To reset free the tstringlist and
  // create a new instance.

  FIndications.Free;
  FDefaultIndications.Free;

  // Creating New Instances
  FDefaultIndications := TStringList.Create;
  FIndications := TStringList.Create;
end;

function TIndications.IsSelectedIndicationValid(pIndicationSelected: string) : boolean;
begin
  Result := True;
  if (IsIndicationLine(pIndicationSelected)) or (Trim(pIndicationSelected) = '') then
    Result := False;
end;

function TIndications.IsIndicationLine(pIndicationSelected: string): Boolean;
begin
  result := Pos(INDICAT_LINE, pIndicationSelected) <> 0;
end;

function TIndications.GetIndicationList: String;
var
  aIndications: TStringList;
begin
  // Enter the list of indications available
  aIndications := TStringList.Create;
  try
    aIndications.AddStrings(FDefaultIndications);

    // Only Medications that are not complex will
    // get a line seperator
    if not IsComplex then
    begin
      // Making sure we don't put just the line
      // when there are no default indications.
      if (aIndications.Count > 0) and
         (FIndications.Count > 0) then
      begin
        aIndications.Add(INDICAT_LINE);
        aIndications.Add('');
      end;
    end;

    aIndications.AddStrings(FIndications);

    // This is only for NON VA Meds
    // This property is set only for NON VA Meds
    if IsUNKNOWN then
      aIndications.Add('UNKNOWN');

     //Return StringList
    Result := aIndications.Text;
    // Reset Only when UNKNOWN is Set to True
    if IsUNKNOWN then
      ResetStringLists;

  finally
    aIndications.Free;
  end;
end;

procedure TIndications.Load;
begin
  // Loads the Default and the rest of the indications
  LoadDefaultIndication;
  LoadIndications;
end;

procedure TIndications.LoadDefaultIndication;
begin
  // Get Default indications first
  FDefaultIndications.Text := CtrlInits.DefaultText('Indication');
end;

procedure TIndications.LoadIndications;
var
  //  I: Integer;
  aIndications: TStringList;
begin
  // Enter the list of indications available
  aIndications := TStringList.Create;
  try
    aIndications.Text := CtrlInits.TextOf('Indication');

    // Per the Group desided to leave the blank
    // fields

    // Check if there are blanks and remove them.
    //    for I := aIndications.Count -1 downto 0 do
    //    begin
    //      if Trim(aIndications[I]) = '' then
    //        aIndications.Delete(I);
    //    end;

    // Sort and add it to the main StringList
    aIndications.Sort;
    // add the rest of indications to the main StringList
    FIndications.AddStrings(aIndications);
  finally
    aIndications.Free;
  end;
end;

end.
