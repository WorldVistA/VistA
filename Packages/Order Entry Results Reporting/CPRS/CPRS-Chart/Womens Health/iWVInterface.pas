unit iWVInterface;
{
  ================================================================================
  *
  *       Application:  TDrugs Patch OR*3*377 and WV*1*24
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Main interface unit for other applications to use.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  System.Classes;

type
  TWVAbleToConceive = (atcUnknown, atcYes, atcNo);
  TWVLactationStatus = (lsUnknown, lsYes, lsNo);
  TWVPregnancyStatus = (psUnknown, psYes, psNo, psUnsure);

  IWVController = interface;
  IWVPatient = interface;
  IWVWebSite = interface;

  IWVController = interface(IInterface)
    ['{46CCE409-CE72-4157-8876-BF169BEE315F}']
    function getWebSite(aIndex: integer): IWVWebSite;
    function getWebSiteCount: integer;
    function getWebSiteListName: string;

    function EditPregLacData(aDFN: string): boolean;
    function SavePregnancyAndLactationData(aList: TStrings): boolean;
    function MarkAsEnteredInError(aItemID: string): boolean;
    function InitController(aForceInit: boolean = False): boolean;
    function IsValidWVPatient(aDFN: string): boolean;
    function GetRecordIDType(aRecordID: string; var aType: string): boolean;
    function GetLastError: string;
    function GetWebSiteURL(aWebSiteName: string): string;
    function OpenExternalWebsite(aWebSite: IWVWebSite): boolean;

    property WebSite[aIndex: integer]: IWVWebSite read getWebSite;
    property WebSiteCount: integer read getWebSiteCount;
    property WebSiteListName: string read getWebSiteListName;
  end;

  IWVPatient = interface(IInterface)
    ['{B99012A3-5DE8-4AEF-9D78-E15C11BF8017}']
    function getDFN: string;

    procedure setDFN(const aValue: string);

    property DFN: string read getDFN write setDFN;
  end;

  IWVWebSite = interface(IInterface)
    ['{FB801C45-686F-4994-9326-10A32E84CC45}']
    function GetName: string;
    function GetURL: string;

    property Name: string read GetName;
    property URL: string read GetURL;
  end;

const
  WV_ABLE_TO_CONCEIVE: array [TWVAbleToConceive] of string = ('Unknown', 'Yes', 'No');
  WV_LACTATION_STATUS: array [TWVLactationStatus] of string = ('Unknown', 'Yes', 'No');
  WV_PREGNANCY_STATUS: array [TWVPregnancyStatus] of string = ('Unknown', 'Yes', 'No', 'Unsure');

function WomensHealth: IWVController;

implementation

uses
  oWVController;

var
  fWVController: IWVController;

function WomensHealth: IWVController;
begin
  fWVController.QueryInterface(IWVController, Result);
end;

initialization

TWVController.Create.GetInterface(IWVController, fWVController);

end.
