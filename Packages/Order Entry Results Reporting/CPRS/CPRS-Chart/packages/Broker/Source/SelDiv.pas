{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: SelDiv handles Division selection for multidivision users.
  Current Release: Version 1.1 Patch 71
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.
  2. Changed ChooseDiv function - if a user is not multi-divisional the
  original code would set RPCBroker1.User.Division equal to the value of
  the Kernel parameter

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 11/03/2016) XWB*1.1*65
  1. Refactor form. Not all screen resolutions were displaying properly.

  Changes in v1.1.60 (HGW 09/18/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.13 (DCM 05/24/2000) XWB*1.1*13
  1. Silent Login, allows for silent log-in functionality.
  ************************************************** }

{ ------------------------------------------------------------------------------
  This will ONLY be invoked when user has more than one division to select from
  in NEW Person file.  If user only has one division, that division will be used;
  else it will default to whatever is in the Kernel Site Parameter file.
  ------------------------------------------------------------------------------ }

unit SelDiv;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {VA}
  MFunStr, Trpcb,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TSelDivForm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    DivLabel1: TLabel;
    DivListBox: TListBox;
    ListBox1: TListBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Enter;
  end;

function ChooseDiv(userid: string; MDivBroker: TRPCBroker): Boolean;
function SetDiv(division: string; MDivBroker: TRPCBroker): Boolean; // p13
function MultDiv(MDivBroker: TRPCBroker): Boolean;
function SelectDivision(DivisionArray: TStrings;
  MDivBroker: TRPCBroker): Boolean;

var
  SelDivForm: TSelDivForm;

implementation

var
  DivSel: string;
  selectedDiv: string;
  CntDiv: integer;
  DivArray: TStrings; // Holds Results from 'XUS Division Get'
{$R *.DFM}
  { ------------------------------ChooseDiv--------------------------------- }
  { This function will retrieve the divisions for a user. The user will
    then choose one division for signon. 'USERID' parameter is for future use
    that will bring back a list of divisions for a user based on their DUZ
    (or username to lookup DUZ), not based on the DUZ as it exists in the
    symbol table. }

function ChooseDiv(userid: string; MDivBroker: TRPCBroker): Boolean;
var
  division: string;
begin
  Result := false; // stays 'false' if user not select division.
  with MDivBroker do
  begin
    if userid <> '' then // future use - - DUZ is passed in.
    begin
      with Param[0] do
      begin
        Value := userid;
        PType := literal;
      end;
    end;
    RemoteProcedure := 'XUS DIVISION GET';
    Call;
    CntDiv := StrToInt(MDivBroker.Results[0]); // count of divisions.
  end; { with }
  if CntDiv = 0 then
//p72 start
  begin
    try
      MDivBroker.RemoteProcedure := 'XUS GET USER INFO';
      MDivBroker.Call;
      if MDivBroker.Results.Count > 0 then
          MDivBroker.User.Division := MDivBroker.Results[3]
    except
      begin
        ShowMessage('Unable to set division');
      end;
    end;
    Result := true; // using the Kernel default division.
  end;
//p72 end
  // if CntDiv = 1 then ? //if a user is assigned to one division, use it?
  // if CntDiv > 1 then   //pop up form below
  if CntDiv > 0 then
  begin
    DivArray := TStringlist.Create; // Put Results in DivArray
    DivArray.Assign(MDivBroker.Results);
    SelDivForm := TSelDivForm.Create(Application); // create division form.
    try
      ShowApplicationAndFocusOK(Application);
      SetForegroundWindow(SelDivForm.Handle);
      SelDivForm.Enter;
    finally;
      DivArray.Destroy;
      SelDivForm.Free;
    end;
  end; { if/begin }
  if DivSel <> '' then
  begin
    Result := true; // user selected a division.
    division := Piece(selectedDiv, '^', 3);
    //division := Piece((Piece(DivSel, '(', 2)), ')', 1);
    if SetDiv(division, MDivBroker) then
      MDivBroker.User.division := selectedDiv;
  end; { if/begin }
end; { procedure }

function SelectDivision(DivisionArray: TStrings;
  MDivBroker: TRPCBroker): Boolean;
var
  division: string;
begin
  Result := false;
  with MDivBroker do
  begin
    if DivisionArray.Count = 0 then
    begin
      RemoteProcedure := 'XUS DIVISION GET';
      Call;
      CntDiv := StrToInt(Results[0]); // count of divisions.
      DivisionArray.Assign(Results);
    end;
  end; { with }
  if CntDiv = 0 then // using the Kernel default division.
  begin
    Result := true;
    exit;
  end;
  if CntDiv > 0 then
  begin
    DivArray := TStringlist.Create; // Put Results in DivArray
    DivArray.Assign(DivisionArray);
    try
      SelDivForm := TSelDivForm.Create(Application); // create division form.
      ShowApplicationAndFocusOK(Application);
      SetForegroundWindow(SelDivForm.Handle);
      SelDivForm.Enter;
    finally;
      SelDivForm.Free;
    end; { try }
  end; { if/begin }
  if DivSel <> '' then
  begin
    Result := true; // user selected a division.
    division := selectedDiv;
    //division := Piece((Piece(DivSel, '(', 2)), ')', 1);
    if SetDiv(division, MDivBroker) then
        MDivBroker.User.division := division;
  end { if divsel }
  else
    MDivBroker.LogIn.ErrorText := 'Invalid Division';
end; { function }

function MultDiv(MDivBroker: TRPCBroker): Boolean;
begin
  Result := false;
  with MDivBroker do
  begin
    RemoteProcedure := 'XUS DIVISION GET';
    Call;
    CntDiv := StrToInt(Results[0]); // count of divisions.
    if CntDiv > 0 then
      with LogIn do
      begin
        DivList.Assign(Results); // store the divisions
        MultiDivision := true;
        Result := true;
      end;
  end;
end;

{ ----------------------------SetDiv-------------------------------- }
{ This function will set DUZ(2) to the division the user selected. }

function SetDiv(division: string; MDivBroker: TRPCBroker): Boolean;
begin
  Result := false;
  with MDivBroker do
  begin
    Param[0].Value := division;
    Param[0].PType := literal;
    RemoteProcedure := 'XUS DIVISION SET';
    Call;
    if Results[0] = '1' then
      Result := true // 1= DUZ(2) set successfully to division.
    else
      LogIn.ErrorText := 'Invalid Division';
  end; { with }
  // 0= DUZ(2) NOT able to set to division.
end;

procedure TSelDivForm.Enter;
begin
  try
    ShowModal; // invoke division form
  finally

  end;
end;

procedure TSelDivForm.btnOKClick(Sender: TObject);
begin
  if DivListBox.ItemIndex = -1 then // nothing selected.
    ShowMessage('A Division was not selected!')
  else
  begin
    DivSel := DivListBox.Items[DivListBox.ItemIndex]; // division
    selectedDiv := ListBox1.Items[DivListBox.ItemIndex];

    close; // selected.
  end;
end;

procedure TSelDivForm.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TSelDivForm.btnHelpClick(Sender: TObject);
begin
  ShowMessage('Select a division from the list and click OK.' +
    '  A division must be selected in order to continue with your signon.' +
    '  To abort process click on Cancel but signon will NOT be completed.')
end;

procedure TSelDivForm.FormCreate(Sender: TObject);
var
  I: integer;
  X: string;
  y, def: string;
begin
  def := '';
  DivSel := ''; // clear any old selection
  I := 1;
  while not(I > CntDiv) do
  begin
    X := DivArray[I];
    ListBox1.Items.Add(X);
    y := '(' + Piece(X, U, 3) + ') ' + Piece(X, U, 2);
    // p13 moved div# in front
    // of div name
    DivListBox.Items.Add(y);
    // + '                                     ^' + IntToStr(I));
    if Piece(X, U, 4) = '1' then
      def := y;
    I := I + 1;
  end;
  //DivListBox.Sorted := true;
  if def <> '' then
    DivListBox.ItemIndex := DivListBox.Items.Indexof(def);
  // use itemindex to highlight the default division
end;

end.
