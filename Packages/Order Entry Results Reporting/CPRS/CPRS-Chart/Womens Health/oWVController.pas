unit oWVController;
{
  ================================================================================
  *
  *       Application:  TDrugs Patch OR*3*377 and WV*1*24
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Primary controller accessed via the WVController
  *                     method in iWVInterface.pas as IWVController.
  *
  *       Notes:        Implementation uses clause contains non-standard link to
  *                     CPRS file ORNet.pas for use with CPRS.
  *
  ================================================================================
}

interface

uses
  Dialogs,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.UITypes,
  iWVInterface,
  oWVWebSite;

type
  TWVController = class(TInterfacedObject, IWVController)
  private
    { Private declerations }
    calcEDD: integer;
    fInitialized: boolean;
    fLastError: string;
    fWebSiteListName: string;
    fWebSites: TObjectList<TWVWebSite>;

    function getWebSite(aIndex: integer): IWVWebSite;
    function getWebSiteCount: integer;
    function getWebSiteListName: string;
  protected
    { Protected declarations }
    function GetLastError: string;

    function EditPregLacData(aDFN: string): boolean;
    function GetRecordIDType(aRecordID: string; var aType: string): boolean;
    function GetWebSiteURL(aWebSiteName: string): string;
    function InitController(aForceInit: boolean = False): boolean; virtual;
    function IsValidWVPatient(aDFN: string): boolean;
    function MarkAsEnteredInError(aItemID: string): boolean;
    function OpenExternalWebsite(aWebsite: IWVWebSite): boolean;
    function SavePregnancyAndLactationData(aList: TStrings): boolean;
  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  fWVPregLacStatusUpdate, // Update Form
  fWVEIEReasonsDlg, // Reason Selection Dialog
  oDelimitedString,
  ORNet, // Access to CallVistA() method in CPRS so RPC's are logged - Would like to route this through an event.
  WinAPI.Windows, // Call to ShellExecute for the WebSites
  ShellAPI, // Call to ShellExecute for the WebSites
  VAUtils;

const
  { VistA RPC's }
  RPC_CONSAVE = 'WVRPCOR CONSAVE';
  RPC_COVER = 'WVRPCOR COVER';
  RPC_EIE = 'WVRPCOR EIE';
  RPC_SAVEDATA = 'WVRPCOR SAVEDATA';
  RPC_REASONS = 'WVRPCOR REASONS';
  RPC_WEBSITES = 'WVRPCOR SITES';

  { TWVController }

constructor TWVController.Create;
begin
  inherited Create;
  fInitialized := False;
  fLastError := '';

  fWebSites := TObjectList<TWVWebSite>.Create;
  fWebSites.OwnsObjects := True;
end;

destructor TWVController.Destroy;
begin
  inherited;
  FreeAndNil(fWebSites);
end;

function TWVController.EditPregLacData(aDFN: string): boolean;
var
  aList: TStringList;
begin
  aList := TStringList.Create;
  Result := False;
  try
    CallVistA(RPC_CONSAVE, [aDFN], aList);
    if aList.Count > 1 then
    begin
      with NewDelimitedString(aList[1]) do
      try
        calcEDD := StrToIntDef(GetPiece(2),0);
      finally
        Free;
      end;
    end
    else
    begin
      calcEDD := 0;
    end;

    if aList.Count < 1 then
    begin
      fLastError := 'Unknown error from server';
      Result := False;
      Exit;
    end;

    if Copy(aList[0], 1, 2) = '1^' then // Get confirmation to result or exit.
      if MessageDlg(Copy(aList[0], 3, Length(aList[0])), mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        begin
          Result := True;
          Exit;
        end;

    if Copy(aList[0], 1, 3) = '-1^' then // Error from server, abort.
      begin
        fLastError := aList[0];
        Result := False;
        Exit;
      end;

    with NewPLUpdateForm(aDFN) do
      try
          EDD := calcEDD;
          fLastError := '';

        if Execute then
          begin
            if GetData(aList) then
              Result := SavePregnancyAndLactationData(aList)
            else
              begin
                fLastError := Copy(aList[0], 3, Length(aList[0]));
                Result := False;
              end
          end
        else
          Result := False;
      finally
        Free;
      end;
  except
    on E: Exception do
      fLastError := E.Message;
  end;
  FreeAndNil(aList);
end;

function TWVController.GetLastError: string;
begin
  Result := fLastError;
end;

function TWVController.GetRecordIDType(aRecordID: string; var aType: string): boolean;
begin
  try
    case StrToInt(Copy(aRecordID, 1, Pos(';', aRecordID) - 1)) of
      4:
        begin
          aType := 'Pregnancy Status';
          Result := True;
        end;
      5:
        begin
          aType := 'Lactation Status';
          Result := True;
        end;
    else
      begin
        aType := 'Unknown Record ID Type ' + aRecordID;
        Result := False;
      end;
    end;
  except
    on E: Exception do
      begin
        aType := 'Error getting Record ID Type ' + E.Message;
        Result := False;
      end;
  end;
end;


function TWVController.getWebSite(aIndex: integer): IWVWebSite;
begin
  InitController;
  try
    fWebSites.Items[aIndex].GetInterface(IWVWebSite, Result);
  except
    Result := nil;
  end;
end;

function TWVController.GetWebSiteURL(aWebSiteName: string): string;
var
  aWebsite: TWVWebSite;
begin
  for aWebsite in fWebSites do
    if CompareStr(aWebsite.GetName, aWebSiteName) = 0 then
      begin
        Result := aWebsite.GetURL;
        Break;
      end;
end;

function TWVController.getWebSiteCount: integer;
begin
  InitController;
  Result := fWebSites.Count;
end;

function TWVController.getWebSiteListName: string;
begin
  InitController;
  Result := fWebSiteListName;
end;

function TWVController.InitController(aForceInit: boolean = False): boolean;
var
  aReturn: TStringList;
  i: integer;
begin
  if not fInitialized then
    begin
      aReturn := TStringList.Create;
      try
        CallVistA(RPC_WEBSITES, [], aReturn);
        if aReturn.Count < 1 then
          fWebSiteListName := 'Error loading Web Sites!'
        else
          begin
            fWebSiteListName := aReturn[0];
            for i := 1 to aReturn.Count - 1 do
              fWebSites.Add(TWVWebSite.Create(aReturn[i]));
          end;
        fInitialized := True;
      finally
        FreeAndNil(aReturn);
      end;
    end;
  Result := fInitialized;
end;

function TWVController.IsValidWVPatient(aDFN: string): boolean;
var
  aList: TStringList;
begin
  aList := TStringList.Create;
  try
    CallVistA(RPC_COVER, [aDFN], aList);
    if aList.Count > 0 then
      Result := aList[0] <> '0'
    else
      Result := False;
  except
    Result := False;
  end;
  FreeAndNil(aList);
end;

function TWVController.MarkAsEnteredInError(aItemID: string): boolean;
var
  aList: TStringList;
begin
  fLastError := '';
  aList := TStringList.Create;
  with NewWVEIEReasonsDlg do
    try
      CallVistA(RPC_REASONS, [], aList);
      AddReason(aList);
      if Execute then
        try
          GetReasons(aList);
          CallVistA(RPC_EIE, [aItemID, aList], aList);
          if aList.Count < 1 then
          begin
            fLastError := 'Unknown Error from Server';
            Result := False;
          end
          else with NewDelimitedString(aList[0]) do
            try
              Result := GetPieceAsInteger(1) = 1;
              if not Result then
                fLastError := GetPiece(2);
            finally
              Free;
            end;
        except
          on E: Exception do
            begin
              fLastError := E.Message;
              Result := False;
            end;
        end
      else
        Result := False;
    finally
      Free;
    end;
  FreeAndNil(aList);
end;

function TWVController.OpenExternalWebsite(aWebsite: IWVWebSite): boolean;
begin
  try
    fLastError := '';
    ShellExecute(0, 'open', PWideChar(aWebsite.URL), nil, nil, SW_SHOWNORMAL);
    Result := True;
  except
    on E: Exception do
      begin
        fLastError := E.Message;
        Result := False;
      end;
  end;
end;

function TWVController.SavePregnancyAndLactationData(aList: TStrings): boolean;
begin
  try
    CallVistA(RPC_SAVEDATA, [aList], aList);
    if aList.Count < 1 then
    begin
      fLastError := 'Unknown Error from Server';
      Result := False;
    end
    else with NewDelimitedString(aList[0]) do
      try
        Result := (GetPieceAsInteger(1) = 1);
        if not Result then
          fLastError := GetPiece(2);
      finally
        Free;
      end;
  except
    on E: Exception do
      begin
        fLastError := E.Message;
        Result := False;
      end;
  end;
end;

end.
