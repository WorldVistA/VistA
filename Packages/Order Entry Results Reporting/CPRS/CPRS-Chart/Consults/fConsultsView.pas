unit fConsultsView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORFN,
  StdCtrls, ExtCtrls, ORCtrls, ComCtrls, ORDtTm, uConsults, Menus, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmConsultsView = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblBeginDate: TLabel;
    calBeginDate: TORDateBox;
    lblEndDate: TLabel;
    calEndDate: TORDateBox;
    radSort: TRadioGroup;
    lblStatus: TLabel;
    lstStatus: TORListBox;
    lblService: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    treService: TORTreeView;
    cboService: TORComboBox;
    cboGroupBy: TORComboBox;
    Label1: TLabel;
    popStatus: TPopupMenu;
    popStatusSelectNone: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure treServiceChange(Sender: TObject; Node: TTreeNode);
    procedure cboServiceSelect(Sender: TObject);
    procedure popStatusSelectNoneClick(Sender: TObject);
  private
    FChanged: Boolean;
    FBeginDate: string;
    FEndDate: string;
    FGroupBy: string;
    FAscending: Boolean;
    FService: string;
    FServiceName: string;
    FConsultUser: boolean ;
    FStatus: string;
    FStatusName: string;
  end;

function SelectConsultsView(FontSize: Integer; CurrentContext: TSelectContext; var SelectContext: TSelectContext): boolean ;

var
  uChanging: Boolean;

implementation

{$R *.DFM}

uses rCore, uCore, rConsults;

var
  SvcList: TStrings ;
  SvcInfo: string ;

const
   TX_DATE_ERR = 'Enter valid beginning and ending dates or press Cancel.';
   TX_DATE_ERR_CAP = 'Error in Date Range';

function SelectConsultsView(FontSize: Integer; CurrentContext: TSelectContext; var SelectContext: TSelectContext): boolean ;
{ displays select form for Consults and returns a record of the selection }
var
  frmConsultsView: TfrmConsultsView;
  W, H, i, j: Integer;
  CurrentStatus, CurrentBegin, CurrentEnd, CurrentService: string;
begin
  frmConsultsView := TfrmConsultsView.Create(Application);
  try
    with frmConsultsView do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      with radSort do ItemIndex := 1;
      setServiceListWithSynonyms(SvcList, CN_SVC_LIST_DISP);           {RV}
//      SortByPiece(TStringList(SvcList), U, 2);                                   {RV}
      SortByPiece(SvcList, U, 2);                                   {RV}
      for i := 0 to SvcList.Count - 1 do
        if cboService.Items.IndexOf(Trim(Piece(SvcList.Strings[i], U, 2))) = -1 then   {RV}
        //if cboService.SelectByID(Piece(SvcList.Strings[i], U, 1)) = -1 then
          cboService.Items.Add(SvcList.Strings[i]);
      BuildServiceTree(treService, SvcList) ;
      with treService do
      begin
        for i:=0 to Items.Count-1 do
          begin
            if Items[i].Level > 0 then Items[i].Expanded := False else Items[i].Expanded := True;
          end ;
        if Items.Count > 0 then
        begin
          TopItem := Items[0] ;
//          Selected := Items[0] ;
        end;
      end;
      CurrentService := CurrentContext.Service;
      if StrToIntDef(CurrentService, 0) > 0 then
        begin
          cboservice.SelectByID(CurrentService);
          cboServiceSelect(frmConsultsView);
        end;
      setSubSetOfStatus(lstStatus.Items);
      CurrentStatus := CurrentContext.Status;
      if CurrentStatus <> '' then with lstStatus do
        begin
          i := 1;
          while Piece(CurrentStatus, ',', i) <> '' do
            begin
              j := SelectByID(Piece(CurrentStatus, ',', i));
              if j > -1 then Selected[j] := True;
              Inc(i);
            end;
        end;
      CurrentBegin := CurrentContext.BeginDate;
      CurrentEnd := CurrentContext.EndDate;
      if CurrentBegin <> '' then
        calBeginDate.Text := CurrentBegin;
      if CurrentEnd <> '' then
        calEndDate.Text := CurrentEnd;
      if calEndDate.Text = '' then calEndDate.Text := 'TODAY';
      cboGroupBy.SelectByID(CurrentContext.GroupBy);
      ShowModal;

      with SelectContext do
       begin
        Changed := FChanged;
        BeginDate := FBeginDate;
        EndDate := FEndDate;
        Ascending := FAscending;
        Service := FService;
        ServiceName := FServiceName;
        ConsultUser := FConsultUser ;
        Status := FStatus;
        StatusName := FStatusName;
        GroupBy := FGroupBy;
        Result := Changed ;
      end;

    end; {with frmConsultsView}
  finally
    frmConsultsView.Release;
  end;
end;

procedure TfrmConsultsView.cmdOKClick(Sender: TObject);
var
  bdate, edate: TFMDateTime;
  i: integer;
begin
  if calBeginDate.Text <> '' then
     bdate := StrToFMDateTime(calBeginDate.Text)
  else
     bdate := 0 ;

  if calEndDate.Text <> '' then
     edate   := StrToFMDateTime(calEndDate.Text)
  else
     edate := 0 ;

  if (bdate <= edate) then
    begin
      FAscending := radSort.ItemIndex = 0;
      FBeginDate := calBeginDate.Text;
      FEndDate := calEndDate.Text;
    end
  else
    begin
      InfoBox(TX_DATE_ERR, TX_DATE_ERR_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;

  if treService.Selected <> nil then
   begin
     FService := Piece(SvcInfo,u,1) ;
     FServiceName := Piece(SvcInfo,u,2) ;
     FConsultUser := ConsultServiceUser(StrToIntDef(FService, 0), User.DUZ) ;
   end
  else
     FService := '' ;

  if lstStatus.SelCount > 0 then
   begin
      with lstStatus do for i := 0 to Items.Count-1 do if Selected[i] then
        begin
          if Piece(Items[i], U, 1) <> '999' then
            FStatus := FStatus + Piece(Items[i], U, 1) + ','
          else
            FStatus := FStatus + Piece(Items[i],U,3) ;
          FStatusName := FStatusName + DisplayText[i] + ',' ;
        end;
      FStatus := Copy(FStatus, 1, Length(FStatus)-1);
      FStatusName := Copy(FStatusName, 1, Length(FStatusName)-1);
   end
  else
     FStatus := '' ;

  if cboGroupBy.ItemID <> '' then
    FGroupBy := cboGroupBy.ItemID
  else
    FGroupBy := '';

  FChanged := True;
  Close;
end;

procedure TfrmConsultsView.cmdCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmConsultsView.treServiceChange(Sender: TObject; Node: TTreeNode);
begin
   if uChanging then Exit;
   if assigned(treService.Selected) then
   begin
     SvcInfo  := TORTreeNode(treService.Selected).StringData ;
     cboService.ItemIndex := cboService.Items.IndexOf(Trim(treService.Selected.Text));  {RV}
   //cboService.SelectByID(Piece(string(treService.Selected.Data), U, 1));
   end
   else
   begin
     SvcInfo  := '';
     cboService.ItemIndex := -1;
   end;
end;

procedure TfrmConsultsView.cboServiceSelect(Sender: TObject);
var                                                                      
  i: integer;                                                            
begin
  with treService do
  begin
    uChanging := True;
    try
      Selected := nil;
      for i := 0 to Items.Count-1 do
      begin
        if Piece(TORTreeNode(Items[i]).StringData,U,1) = cboService.ItemID then
          begin
            Selected := Items[i];
            //treServiceChange(Self, Items[i]);
            break;
          end;
      end;
    finally
      uChanging := False;
    end;
    if assigned(Selected) then
      SvcInfo  := TORTreeNode(treService.Selected).StringData
    else
      SvcInfo := '';
  end;
end;                                                                     

procedure TfrmConsultsView.popStatusSelectNoneClick(Sender: TObject);
var
  i: integer;
begin
  with lstStatus do
    begin
      for i := 0 to Items.Count - 1 do
        Selected[i] := False;
      ItemIndex := -1;
    end;
end;

initialization
   SvcList := TStringList.Create ;

finalization
   SvcList.Free ;

end.
