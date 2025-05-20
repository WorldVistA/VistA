unit mCoverSheetDisplayPanel_CPRS_WH;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TfraCoverSheetDisplayPanel_CPRS. This
  *                     display panel adds the tweeks for properly displaying
  *                     Womens Health data in the CPRS CoverSheet.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  System.StrUtils,
  System.Types,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  mCoverSheetDisplayPanel_CPRS,
  iCoverSheetIntf,
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_WH = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    fValidData: boolean;

    fSeparator: TMenuItem;
    fUpdateData: TMenuItem;
    fMarkAsEnteredInError: TMenuItem;
    fWebSitesRoot: TMenuItem;
  protected
    { Inherited events - TfraGridPanel }
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuFree(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;

    { Inherited events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aResult: TStrings); override;
    procedure OnBeginUpdate(Sender: TObject); override;
    procedure OnEndUpdate(Sender: TObject); override;

    { Introduced events }
    procedure OnEnteredInError(Sender: TObject);
    procedure OnUpdateData(Sender: TObject);
    procedure OnSelectWebSite(Sender: TObject);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_WH: TfraCoverSheetDisplayPanel_CPRS_WH;

implementation

uses
  uCore,
  iWVInterface,
  ORNet,
  VAUtils, uWriteAccess;

{$R *.dfm}

{ TfraCoverSheetDisplayPanel_CPRS_WH }

constructor TfraCoverSheetDisplayPanel_CPRS_WH.Create(aOwner: TComponent);
begin
  inherited;
  fValidData := False;
end;

destructor TfraCoverSheetDisplayPanel_CPRS_WH.Destroy;
begin
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aStr: string;
begin
  if aList.Count > 0 then
    begin
      fValidData := StrToIntDef(Piece(aList[0], '^', 1), 0) > -1;
      if fValidData then
      begin
        aList.Delete(0);
        if aList.Count = 0 then
          with lvData.Items.Add do
            begin
              Caption := 'Not Applicable.';
              Data := TDelimitedString.Create('^Not Applicable');
            end
        else
          for aStr in aList do
            with lvData.Items.Add do
              begin
                aRec := TDelimitedString.Create(aStr);
                Caption := Format('%s %s', [aRec.GetPiece(2), aRec.GetPiece(3)]);
                Data := aRec;
              end;
        end
        else
          with lvData.Items.Add do
          begin
            Caption := 'Error';
            Data := TDelimitedString.Create(aList[0]);
          end;
    end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnGetDetail(aRec: TDelimitedString; aResult: TStrings);
begin
  if fValidData then
    begin
      CallVistA(CPRSParams.DetailRPC, [aRec.GetPiece(1)], aResult);
    end
  else
    begin
      aResult.Append(aRec.GetPiece(2));
    end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnBeginUpdate(Sender: TObject);
begin
  if Sender.ClassType = TSpeedButton then
  begin
    CPRSParams.Param1 := '1';
  end
  else
  begin
    CPRSParams.Param1 := '0';
  end;
{$IFDEF DEBUG}
  CPRSParams.Param1 := ''; // prevent error loading coversheet. v32b
{$ENDIF}
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnEndUpdate(Sender: TObject);
begin
  if Sender.ClassType = TSpeedButton then
  begin
    CPRSParams.Param1 := '0';
  end;
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnPopupMenu(Sender: TObject);
var
  aRec: TDelimitedString;
begin
  inherited;
  if not WriteAccess(waWomenHealth) then exit;
  fUpdateData.Enabled := fValidData;

  fMarkAsEnteredInError.Enabled := False;
  fMarkAsEnteredInError.Caption := 'Nothing selected to Mark as entered in error.';

  if lvData.Selected <> nil then
    if lvData.Selected.Data <> nil then
      begin
        aRec := TDelimitedString(lvData.Selected.Data);
        if Length(SplitString(aRec[1],';,')) > 1 then
          if StrToIntDef(SplitString(aRec[1], ';,^')[1], 0) > 0 then
            begin
              fMarkAsEnteredInError.Enabled := True;
              fMarkAsEnteredInError.Caption := 'Mark ''' + lvData.Selected.Caption + ''' as entered in error ...';
            end;

        { -Changed from
          4;1,61,^Lactating:^Not Applicable
          ^ Piece one is always Type of data (4=pregnancy, 5= lactating);iens
          ^ Piece two is always Caption
          ^ Piece three is always Value

          if primary ien of iens string (AKA DA) = zero do NOT enable EnteredInError menu!

          if aRec.GetPieceIsNotNull(1) then
          begin
          fMarkAsEnteredInError.Enabled := True;
          fMarkAsEnteredInError.Caption := 'Mark ''' + lvData.Selected.Caption + ''' as entered in error ...';
          end;
        }
      end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnPopupMenuFree(Sender: TObject);
var
  aSubMenu: TMenuItem;
begin
  FreeAndNil(fSeparator);
  if WriteAccess(waWomenHealth) then
  begin
    FreeAndNil(fUpdateData);
    FreeAndNil(fMarkAsEnteredInError);
  end;
  for aSubMenu in fWebSitesRoot do
    aSubMenu.Free;
  fWebSitesRoot.Clear;
  FreeAndNil(fWebSitesRoot);
  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnPopupMenuInit(Sender: TObject);
var
  aSubMenu: TMenuItem;
  i: integer;
begin
  inherited;
  fSeparator := NewLine;
  if WriteAccess(waWomenHealth) then
  begin
    fUpdateData := NewItem('Add New Data ...', 0, False, False, OnUpdateData, 0, 'pmnWH_UpdateData');
    fMarkAsEnteredInError := NewItem('Mark as Entered In Error ...', 0, False, False, OnEnteredInError, 0, 'pmnWH_EnteredInError');
  end;
  fWebSitesRoot := NewSubMenu(WomensHealth.WebSiteListName, 0, 'pmnWH_WebSites', [], (WomensHealth.WebSiteCount > 0));

  for i := 0 to WomensHealth.WebSiteCount - 1 do
    begin
      aSubMenu := NewItem(WomensHealth.WebSite[i].Name, 0, False, True, OnSelectWebSite, 0, Format('pmnWebSite_%d', [i]));
      aSubMenu.Tag := i;
      fWebSitesRoot.Add(aSubMenu);
    end;

  pmn.Items.Add(fSeparator);
  if WriteAccess(waWomenHealth) then
  begin
    pmn.Items.Add(fUpdateData);
    pmn.Items.Add(fMarkAsEnteredInError);
  end;
  pmn.Items.Add(fWebSitesRoot);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnSelectWebSite(Sender: TObject);
var
  aWebSite: IWVWebSite;
begin
  WomensHealth.WebSite[TMenuItem(Sender).Tag].QueryInterface(IWVWebSite, aWebSite);
  if aWebSite = nil then
    MessageDlg('Unable to get WebSite information', mtError, [mbOk], 0)
  else if not WomensHealth.OpenExternalWebsite(aWebSite) then
    MessageDlg(Format('Error: %s', [WomensHealth.GetLastError]), mtError, [mbOk], 0);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnEnteredInError(Sender: TObject);
begin
  if lvData.Selected <> nil then
    if lvData.Selected.Data <> nil then
      with TDelimitedString(lvData.Selected.Data) do
        if WomensHealth.MarkAsEnteredInError(GetPiece(1)) then
          begin
            CoverSheet.OnRefreshPanel(Self, CV_CPRS_WVHT); // This is me, just letting the CoverSheet do it's thing!
            CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);
            CoverSheet.OnRefreshPanel(Self, CV_CPRS_RMND);
            CoverSheet.OnRefreshCWAD(Self);
          end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_WH.OnUpdateData(Sender: TObject);
begin
  if WomensHealth.EditPregLacData(Patient.DFN) then
    begin
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_WVHT); // This is me, just letting the CoverSheet do it's thing!
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);
      CoverSheet.OnRefreshPanel(Self, CV_CPRS_RMND);
      CoverSheet.OnRefreshCWAD(Self);
    end
  else if WomensHealth.GetLastError <> '' then
    begin
      MessageDlg(Format('Error: %s', [WomensHealth.GetLastError]), mtError, [mbOk], 0);
    end;
end;

end.
