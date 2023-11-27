unit fConsultBS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ORCtrls, StdCtrls, ORFn, ComCtrls, uConsults, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmConsultsByService = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblService: TLabel;
    radSort: TRadioGroup;
    cmdOK: TButton;
    cmdCancel: TButton;
    treService: TORTreeView;
    cboService: TORComboBox;
    Panel1: TPanel;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure cboServiceSelect(Sender: TObject);
  private
    FChanged: Boolean;
    FService: string;
    FServiceName: string;
    FAscending: Boolean;
    fConsultUser: boolean ;
  end;

  TServiceContext = record
    Changed: Boolean;
    Service: string;
    ServiceName: string;
    Ascending: Boolean;
    ConsultUser: Boolean ;
  end;

function SelectService(FontSize: Integer; CurrentContext: TSelectContext; var ServiceContext: TServiceContext): boolean;

implementation

{$R *.DFM}

uses rConsults, rCore, uCore;

var
  SvcList: TStrings ;
  SvcInfo: string ;
  uChanging: Boolean;

const
  TX_SVC_TEXT = 'Select a consult service or press Cancel.';
  TX_SVC_CAP = 'Missing Service';

function SelectService(FontSize: Integer; CurrentContext: TSelectContext; var ServiceContext: TServiceContext): boolean;
{ displays service select form for consults and returns a record of the selection }
var
  frmConsultsByService: TfrmConsultsByService;
  W, H, i: Integer;
  CurrentService: string;
begin
  frmConsultsByService := TfrmConsultsByService.Create(Application);
  try
    with frmConsultsByService do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      //FastAssign(LoadServiceList(CN_SVC_LIST_DISP), SvcList);                         {RV}
      setServiceListWithSynonyms(SvcList, CN_SVC_LIST_DISP);             {RV}
//      SortByPiece(TStringList(SvcList), U, 2);                                   {RV}
      SortByPiece(SvcList, U, 2);                                   {RV}
      for i := 0 to SvcList.Count - 1 do
        if cboService.Items.IndexOf(Trim(Piece(SvcList.Strings[i], U, 2))) = -1 then   {RV}
        //if cboService.SelectByID(Piece(SvcList.Strings[i], U, 1)) = -1 then
          cboService.Items.Add(SvcList.Strings[i]);
      BuildServiceTree(treService, SvcList) ;
      with treService do
      begin
        for i := 0 to Items.Count-1 do
          begin
            if Items[i].Level > 0 then Items[i].Expanded := False else Items[i].Expanded := True;
          end ;
        if Items.Count > 0 then
        begin
          TopItem := Items[0] ;
          Selected := Items[0] ;
        end;
      end;
      FAscending := CurrentContext.Ascending;
      radSort.ItemIndex := Ord(not FAscending);
      CurrentService := CurrentContext.Service;
      if StrToIntDef(CurrentService, 0) > 0 then
        begin
          cboservice.SelectByID(CurrentService);
          cboServiceSelect(frmConsultsByService);
        end;
      ShowModal;
      with ServiceContext do
      begin
        Changed := FChanged;
        Service := FService;
        ServiceName := FServiceName;
        Ascending := FAscending;
        ConsultUser := FConsultUser ;
        Result := Changed ;
      end; {with ServiceContext}
    end; {with frmConsultsByService}
  finally
    frmConsultsByService.Release;
  end;
end;

procedure TfrmConsultsByService.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultsByService.cmdOKClick(Sender: TObject);
begin
  if (treService.Selected = nil) and (StrToIntDef(FService, 0) = 0 ) then
  begin
    InfoBox(TX_SVC_TEXT, TX_SVC_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  FChanged     := True;
  FService     := Piece(SvcInfo,u,1);
  FServiceName := Piece(SvcInfo,u,2) ;
  FAscending   := (radSort.ItemIndex = 0);
  FConsultUser := ConsultServiceUser(StrToIntDef(FService, 0), User.DUZ) ;
  Close;
end;

procedure TfrmConsultsByService.treServiceChange(Sender: TObject;
  Node: TTreeNode);
begin
   if uChanging then Exit;
   if not assigned(treService.Selected) then
   begin
     SvcInfo  := '';
     cboService.ItemIndex := -1;
     exit;
   end;
   SvcInfo  := TORTreeNode(treService.Selected).StringData ;
   cboService.ItemIndex := cboService.Items.IndexOf(Trim(treService.Selected.Text));  {RV}
   //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1));
end;

procedure TfrmConsultsByService.cboServiceSelect(Sender: TObject);
var
  i: integer;
begin                                                                    
  uChanging := True;
  treService.Selected := nil;
  with treService do for i := 0 to Items.Count-1 do
    begin
      if Piece(TORTreeNode(Items[i]).StringData, U, 1) = cboService.ItemID then
        begin
          Selected := Items[i];
          //treServiceChange(Self, Items[i]);
          break;
        end;
    end;
  uChanging := False;
  if assigned(treService.Selected) then
    SvcInfo := TORTreeNode(treService.Selected).StringData
  else
    SvcInfo := '';
end;

initialization
   SvcList := TStringList.Create ;

finalization
   SvcList.Free ;

end.
