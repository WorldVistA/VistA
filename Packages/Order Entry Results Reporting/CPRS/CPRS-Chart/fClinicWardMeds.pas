unit fClinicWardMeds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ExtCtrls, ORCtrls,ORFn, rCore, uCore, oRNet, Math,
  VA508AccessibilityManager;

type
  TfrmClinicWardMeds = class(TfrmAutoSz)
    stxtLine3: TStaticText;
    stxtLine2: TStaticText;
    stxtLine1: TStaticText;
    btnClinic: TButton;
    btnWard: TButton;
    procedure btnClinicClick(Sender: TObject);
    procedure btnWardClick(Sender: TObject);

  private
    { Private declarations }
    procedure StartLocationCheck;
    procedure rpcChangeOrderLocation(pOrderList:TStringList);
    procedure BuildMessage(MsgSw:string);
    function  BuildOrderLocList(pOrderList:TStringList; pLocation:integer):TStringList;

  public
    { Public declarations }
    // passes order list and selected locations to rpc to be saved with order.
    procedure ClinicOrWardLocation(pOrderList:TStringList; pEncounterLoc: integer; pEncounterLocName: string; var RetLoc: integer); overload;
    // returns Location selected by user.
    function  ClinicOrWardLocation(pEncounterLoc: integer):integer;overLoad;
    function  rpcIsPatientOnWard(Patient: string): boolean;
    function  SelectPrintLocation(pEncounterLoc:integer):integer;
  end;

var
  frmClinicWardMeds: TfrmClinicWardMeds;
  ALocation,AWardLoc, AClinicLoc : integer;
  ASelectedLoc: integer;
  AName, ASvc, AWardName, AClinicName: string;
  AOrderLocList: TStringList;
  AMsgSw: string;

const
  LOCATION_CHANGE_1 = 'This patient is currently admitted to ward';
  LOCATION_CHANGE_2 = 'These orders are written at clinic';
  LOCATION_CHANGE_3 = 'Where do you want the orders administered?';
   //GE CQ9537  - Message text
  PRINT_LOCATION_1 = 'The patient has been admitted to Ward ';
  PRINT_LOCATION_2 =  'Should the orders be printed using the new location?';
  LOC_PRINT_MSG    = 'P';
  LOC_MSG          = 'L';

implementation

uses fFrame;

{$R *.dfm}

//entry point
function  TfrmClinicWardMeds.ClinicOrWardLocation(pEncounterLoc:integer):integer;
begin
  // Patient's current location
   AClinicLoc  := pEncounterLoc;
   AClinicName := Encounter.LocationName;
   AMsgSw := LOC_MSG;
   StartLocationCheck;
   Result := ASelectedLoc;
   frmClinicWardMeds.Close;
end;

//entry point
procedure TfrmClinicWardMeds.ClinicOrWardLocation(pOrderList:TStringList;pEncounterLoc:integer;pEncounterLocName:string; var RetLoc: integer);
begin
  AClinicLoc        := pEncounterLoc;
  AClinicName       := pEncounterLocName;
  AOrderLocList     := TStringList.create;
  AOrderLocList.Clear;
  AMsgSw := LOC_MSG;
  StartLocationCheck;
  if pOrderList.Count > 0 then
     begin
       rpcChangeOrderLocation(BuildOrderLocList(pOrderList, ASelectedLoc));
       RetLoc := ASelectedLoc
     end;
  if Assigned(AOrderLocList) then FreeAndNil(AOrderLocList);
  frmClinicWardMeds.Close;
end;

// returns button selected by user - ward or clinic.  print location
//entry point  -
function  TfrmClinicWardMeds.SelectPrintLocation(pEncounterLoc:integer):integer;
begin
   AClinicLoc        := pEncounterLoc;
   AMsgSw            := LOC_PRINT_MSG;
   StartLocationCheck;
   Result := ASelectedLoc;
   frmClinicWardMeds.Close;
end;

procedure TfrmClinicWardMeds.StartLocationCheck;
begin

  frmClinicWardMeds := TfrmClinicWardMeds.Create(Application);
 // ResizeFormToFont(TForm(frmClinicWardMeds));
  CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
  AWardLoc := ALocation; //current location
  AWardName := AName; // current location name
  if AMsgSW = LOC_PRINT_MSG then BuildMessage(AMsgSw)
  else
     if (ALocation > 0) and (ALocation <> AClinicLoc) then BuildMessage(AMsgSw); //Location has changed, patient admitted
end;

procedure TfrmClinicWardMeds.btnClinicClick(Sender: TObject);
begin
  inherited;
  ASelectedLoc := AClinicLoc;
  frmClinicWardMeds.Close;
end;

procedure TfrmClinicWardMeds.btnWardClick(Sender: TObject);
begin
  inherited;
   ASelectedLoc := AWardLoc;
   frmClinicWardMeds.Close;
end;

procedure TfrmClinicWardMeds.BuildMessage(MsgSw:string);
var
 ALine1Len, ALine2Len, ALine3Len, ALongLine: integer;
begin
    with frmClinicWardMeds do
    begin
       btnWard.Caption   := 'Ward';
       btnClinic.Caption := 'Clinic';
       // message text
       if MsgSw = LOC_MSG then
       begin
          //AClinicName := 'this is my long test clinic Name';
          stxtLine1.Caption := LOCATION_CHANGE_1 + ' :' + AWardName;
          stxtLine2.Caption := LOCATION_CHANGE_2+ ' :' + AClinicName;
          stxtLine3.Caption := LOCATION_CHANGE_3;
       end
       else
          begin
              stxtLine1.Caption := PRINT_LOCATION_1 + ':' + AWardName;
              stxtLine2.Caption := PRINT_LOCATION_2;
              stxtLine3.Caption := '';
          end;
    stxtLine2.Left := stxtLine1.left;
    stxtLine3.Left := stxtLine1.left;
    ALine1Len := TextWidthByFont(frmClinicWardMeds.stxtLine1.Font.Handle, frmClinicWardMeds.stxtLine1.Caption);
    ALine2Len := TextWidthByFont(frmClinicWardMeds.stxtLine2.Font.Handle, frmClinicWardMeds.stxtLine2.Caption);
    ALine3Len := TextWidthByFont(frmClinicWardMeds.stxtLine3.Font.Handle, frmClinicWardMeds.stxtLine3.Caption)+25;
    ALongLine := Max(ALine1Len,ALine2Len);
    ALongLine := Max(ALine3Len,ALongLine);
    frmClinicWardMeds.Width := (ALongLine + frmClinicWardMeds.stxtLine1.Left + 15);
    end;
    frmClinicWardMeds.ShowModal;
    frmClinicWardMeds.Release;
    frmClinicWardMeds := nil;
end;

function  TfrmClinicWardMeds.BuildOrderLocList(pOrderList:TStringList; pLocation:integer):TStringList;
var i:integer;
    AOrderLoc: string;
begin
   AOrderLocList.clear;
   for i := 0 to pOrderList.Count -1 do
   begin
      AOrderLoc := Piece(pOrderList.Strings[i],U,1) + U + IntToStr(pLocation);
      AOrderLocList.Add(AOrderLoc);
   end;
   Result := AOrderLocList; //return value
end;

procedure TfrmClinicWardMeds.rpcChangeOrderLocation(pOrderList:TStringList);
begin
// OrderIEN^Location^1  -- used to alter location if ward is selected RPC expected third value to determine if
//order is an IMO order. If it is being called from here assumed IMO order.

  CallVistA('ORWDX CHANGE',[pOrderList, Patient.DFN, '1']);
end;

function TfrmClinicWardMeds.rpcIsPatientOnWard(Patient: string): boolean;
var
  aStr: string;
begin
  CallVistA('ORWDX1 PATWARD', [Patient], aStr);
  Result := (aStr = '1');
end;

end.
