{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Handles Division selection for multidivision
	             users.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

{**************************************************
This will ONLY be invoked when user has more than one division to select from
in NEW Person file.  If user only has one division, that division will be used;
else it will default to whatever is in the Kernel Site Parameter file.

XWB*1.1*13, Silent Login, allows for silent log-in functionality - DCM
last updated: 5/24/00
------------------------------------------------------------------------------}


unit SelDiv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MFunStr, Buttons, Trpcb;

type
  TSelDivForm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnHelp: TBitBtn;
    DivLabel1: TLabel;
    DivListBox: TListBox;
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

function ChooseDiv(userid : string; MDivBroker: TRPCBroker): Boolean;
function SetDiv(division : string; MDivBroker: TRPCBroker): boolean;  //p13
function MultDiv(MDivBroker: TRPCBroker): boolean;
function SelectDivision(DivisionArray: TStrings; MDivBroker: TRPCBroker): Boolean;

var
  SelDivForm: TSelDivForm;

implementation

var
   DivSel : string;
   CntDiv : integer;
   DivArray : TStrings; //Holds Results from 'XUS Division Get'
{$R *.DFM}

{------------------------------ChooseDiv---------------------------------}
{  This function will retrieve the divisions for a user. The user will
   then choose one division for signon. 'USERID' parameter is for future use
   that will bring back a list of divisions for a user based on their DUZ
   (or username to lookup DUZ), not based on the DUZ as it exists in the
   symbol table. }

function ChooseDiv(userid : string; MDivBroker: TRPCBroker): Boolean;
var
   division : string;
begin
     Result := false; // stays 'false' if user not select division.
     with MDivBroker do begin
          if userid <> '' then         // future use - - DUZ is passed in.
          begin
             with Param[0] do begin
               Value := userid;
               PType := literal;
             end;
          end;
          RemoteProcedure := 'XUS DIVISION GET';
          Call;
          CntDiv := StrToInt(MDivBroker.Results[0]); //count of divisions.
     end;{with}

     if CntDiv = 0 then Result := true; //using the Kernel default division.

     if CntDiv > 0 then
     begin
          DivArray := TStringlist.Create;       //Put Results in DivArray
          DivArray.Assign(MDivBroker.Results);
          try
             SelDivForm := TSelDivForm.Create(Application); //create division form.
             ShowApplicationAndFocusOK(Application);
             SetForegroundWindow(SelDivForm.Handle);
             SelDivForm.Enter;
          finally;
             SelDivForm.Free;
          end;
     end;{if/begin}

     if SelDiv.DivSel <> '' then
     begin
        Result := True; //user selected a division.
        division := Piece((Piece(SelDiv.DivSel,'(',2)),')',1);
        if SetDiv(division,MDivBroker) then MDivBroker.User.Division := Division;

     end;{if/begin}
end;{procedure}

function SelectDivision(DivisionArray: TStrings; MDivBroker: TRPCBroker): Boolean;
var
  division : string;
begin
  Result := false;
  with MDivBroker do
  begin
    if DivisionArray.Count = 0 then
      begin
      RemoteProcedure := 'XUS DIVISION GET';
      Call;
      CntDiv := StrToInt(Results[0]); //count of divisions.
      DivisionArray.Assign(Results);
      end;
    end;{with}
  if CntDiv = 0 then //using the Kernel default division.
    begin
    Result := true;
    exit;
    end;
  if CntDiv > 0 then
    begin
    DivArray := TStringlist.Create;       //Put Results in DivArray
    DivArray.Assign(DivisionArray);
    try
      SelDivForm := TSelDivForm.Create(Application); //create division form.
      ShowApplicationAndFocusOK(Application);
      SetForegroundWindow(SelDivForm.Handle);
      SelDivForm.Enter;
    finally;
      SelDivForm.Free;
    end; {try}
    end; {if/begin}
  if DivSel <> '' then
    begin
    Result := True; //user selected a division.
    division := Piece((Piece(SelDiv.DivSel,'(',2)),')',1);
    //division := Piece(SelDiv.DivSel,'^',2);
    if SetDiv(division,MDivBroker) then MDivBroker.User.Division := Division;
    end{if divsel}
  else MDivBroker.LogIn.ErrorText := 'Invalid Division';
end;{function}

function MultDiv(MDivBroker: TRPCBroker): boolean;
begin
  Result := False;
  with MDivBroker do
    begin
      RemoteProcedure := 'XUS DIVISION GET';
      Call;
      CntDiv := StrToInt(Results[0]); //count of divisions.
      if CntDiv > 0 then
      with Login do
        begin
        DivList.Assign(Results);//store the divisions
        MultiDivision := True;
        Result := True;
        end;
      end;
end;

{----------------------------SetDiv--------------------------------}
{ This function will set DUZ(2) to the division the user selected. }

function SetDiv(division : string; MDivBroker: TRPCBroker): boolean;
begin
  Result := False;
  with MDivBroker do begin
    Param[0].Value := division;
    Param[0].PType := literal;
    RemoteProcedure := 'XUS DIVISION SET';
    Call;
    if Results[0] = '1' then Result := True //1= DUZ(2) set successfully to division.
    else  Login.ErrorText := 'Invalid Division';
    end;{with}                             //0= DUZ(2) NOT able to set to division.
end;

procedure TSelDivForm.Enter;
begin
     try
        ShowModal; //invoke division form
     finally

     end;
end;

procedure TSelDivForm.btnOKClick(Sender: TObject);
begin
     if DivListBox.ItemIndex = -1 then   //nothing selected.
        ShowMessage('A Division was not selected!')
     else
     begin
        SelDiv.DivSel := DivListBox.Items [DivListBox.ItemIndex]; //division
        close;                                                     // selected.
     end;
end;

procedure TSelDivForm.btnCancelClick(Sender: TObject);
begin
     close;
end;

procedure TSelDivForm.btnHelpClick(Sender: TObject);
begin
     ShowMessage('Select a division from the list and click OK.'+
     '  A division must be selected in order to continue with your signon.' +
     '  To abort process click on Cancel but signon will NOT be completed.')
end;

procedure TSelDivForm.FormCreate(Sender: TObject);
var
   I : integer;
   X : string;
   y,def: string;
begin
  def := '';
     SelDiv.DivSel := ''; //clear any old selection
     I := 1;
     while not (I > CntDiv) do
         begin
         X := DivArray[I];
         y := '(' + Piece(X,U,3) + ') ' + Piece(X,U,2); //p13 moved div# in front
                                                        //of div name
         DivListBox.Items.Add(y); // + '                                     ^' + IntToStr(I));
         if Piece(X,U,4) = '1' then def := y;
         I := I + 1;
         end;
     DivListBox.Sorted := TRUE;
     if def <> '' then DivListBox.ItemIndex := DivListBox.Items.Indexof(def);     //use itemindex to highlight the default division
end;

end.

