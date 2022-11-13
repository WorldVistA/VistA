unit fTIUView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORFN,
  StdCtrls, ExtCtrls, ORCtrls, ComCtrls, ORDtTm, Spin, uTIU, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmTIUView = class(TfrmBase508Form)
    pnlBase: TORAutoPanel;
    lblBeginDate: TLabel;
    calBeginDate: TORDateBox;
    lblEndDate: TLabel;
    calEndDate: TORDateBox;
    lblStatus: TLabel;
    lstStatus: TORListBox;
    lblAuthor: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cboAuthor: TORComboBox;
    lblMaxDocs: TLabel;
    edMaxDocs: TCaptionEdit;
    lblContains: TLabel;
    txtKeyword: TCaptionEdit;
    grpListView: TGroupBox;
    radListSort: TRadioGroup;
    lblSortBy: TLabel;
    cboSortBy: TORComboBox;
    grpTreeView: TGroupBox;
    lblGroupBy: TOROffsetLabel;
    cboGroupBy: TORComboBox;
    radTreeSort: TRadioGroup;
    Bevel2: TBevel;
    cmdClear: TButton;
    ckShowSubject: TCheckBox;
    grpWhereEitherOf: TGroupBox;
    ckTitle: TCheckBox;
    ckSubject: TCheckBox;
    pnlButtons: TPanel;
    pnlStatus: TPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    pnlAuthor: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnlOptions: TPanel;
    pnlOp: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstStatusSelect(Sender: TObject);
    procedure cboAuthorNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdClearClick(Sender: TObject);
  private
    FChanged: Boolean;
    FBeginDate: string;
    FFMBeginDate: TFMDateTime;
    FEndDate: string;
    FFMEndDate: TFMDateTime;
    FStatus: string;
    FAuthor: Int64;
    FMaxDocs: integer;
    FShowSubject: Boolean;
    FSortBy: string;
    FListAscending: Boolean;
    FGroupBy: string;
    FTreeAscending: Boolean;
    FSearchField: string;
    FKeyWord: string;
    FFiltered: Boolean;
    FCurrentContext: TTIUContext;
  end;

function SelectTIUView(FontSize: Integer; ShowForm: Boolean; CurrentContext: TTIUContext; var TIUContext: TTIUContext): boolean ;

implementation

{$R *.DFM}

uses rCore, uCore, rTIU(*, fNotes, fDCSumm, rDCSumm*), uSimilarNames;

const
   TX_DATE_ERR = 'Enter valid beginning and ending dates or press Cancel.';
   TX_DATE_ERR_CAP = 'Error in Date Range';
   TX_AUTH_ERR = 'You must select an author for this retrieval method.';
   TX_AUTH_ERR_CAP = 'No author selected';

function SelectTIUView(FontSize: Integer; ShowForm: Boolean; CurrentContext: TTIUContext; var TIUContext: TTIUContext): boolean ;
{ displays select form for Notes and returns a record of the selection }
var
  frmTIUView: TfrmTIUView;
  W, H: Integer;
  CurrentAuthor: Int64;
  CurrentStatus: string;
begin
  frmTIUView := TfrmTIUView.Create(Application);
  try
    with frmTIUView do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      FFiltered := False;
      FCurrentContext := CurrentContext;
      calBeginDate.Text := CurrentContext.BeginDate;
      calEndDate.Text   := CurrentContext.EndDate;
      if calEndDate.Text = '' then calEndDate.Text := 'TODAY';
      CurrentStatus := CurrentContext.Status;
      with lstStatus do
        if CurrentStatus <> '' then
          SelectByID(CurrentStatus)
        else
          SelectByID('1');
      //lstStatusSelect(frmTIUView);  moved down - v24.1 (RV)
      CurrentAuthor := CurrentContext.Author;
      with cboAuthor do
        if CurrentAuthor > 0 then
          begin
            InitLongList(ExternalName(CurrentAuthor, 200));
            if Enabled then SelectByIEN(CurrentAuthor);
            FAuthor := CurrentAuthor;
          end
        else
          begin
            InitLongList(User.Name);
            SelectByIEN(User.DUZ);
            FAuthor := ItemIEN;
          end;
      TSimilarNames.RegORComboBox(cboAuthor);
      if CurrentContext.MaxDocs > 0 then
        edMaxDocs.Text :=  IntToStr(CurrentContext.MaxDocs)
      else
        edMaxDocs.Text := '';
      FMaxDocs := StrToIntDef(edMaxDocs.Text, 0);
      txtKeyword.Text := CurrentContext.Keyword;
      if CurrentContext.SearchField <> '' then
        begin
          ckTitle.Checked := CharInSet(CurrentContext.SearchField[1], ['T','B']) and (CurrentContext.Keyword <> '');
          ckSubject.Checked := CharInSet(CurrentContext.SearchField[1], ['S','B']) and (CurrentContext.Keyword <> '');
        end;
      ckShowSubject.Checked := CurrentContext.ShowSubject;
      //with radTreeSort do if SortNotesAscending then ItemIndex := 1 else ItemIndex := 0;
      with radTreeSort do if CurrentContext.TreeAscending then ItemIndex := 0 else ItemIndex := 1;
      with radListSort do if CurrentContext.ListAscending then ItemIndex := 0 else ItemIndex := 1;
      cboSortBy.SelectByID(CurrentContext.SortBy);
      cboGroupBy.SelectByID(CurrentContext.GroupBy);
      lstStatusSelect(frmTIUView);    //  from above in v24.1, (RV)

      if ShowForm then ShowModal else cmdOKClick(frmTIUView);

      with TIUContext do
       begin
        Changed := FChanged;
        BeginDate := FBeginDate;
        FMBeginDate := FFMBeginDate;
        EndDate := FEndDate;
        FMEndDate := FFMEndDate;
        Status := FStatus;
        Author := FAuthor;
        MaxDocs := FMaxDocs;
        ShowSubject := FShowSubject;
        SortBy := FSortBy;
        ListAscending := FListAscending;
        GroupBy := FGroupBy;
        TreeAscending := FTreeAscending;
        SearchField := FSearchField;
        KeyWord := FKeyWord;
        Filtered := FFiltered;
        Result := Changed ;
      end;

    end; {with frmTIUView}
  finally
    frmTIUView.Release;
  end;
end;

procedure TfrmTIUView.cmdOKClick(Sender: TObject);
var
  bdate, edate: TFMDateTime;
  ErrMsg: string;

begin
  FStatus := lstStatus.ItemID;

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
      FBeginDate := calBeginDate.Text;
      FFMBeginDate := bdate;
      FEndDate := calEndDate.Text;
      FFMEndDate := edate;
    end
  else
    begin
      InfoBox(TX_DATE_ERR, TX_DATE_ERR_CAP, MB_OK or MB_ICONWARNING);
      Exit;
    end;

  FAuthor := cboAuthor.ItemIEN;
  if (FStatus = '4') and (FAuthor = 0) then
  begin
    InfoBox(TX_AUTH_ERR, TX_AUTH_ERR_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  if cboAuthor.Enabled and (not CheckForSimilarName(cboAuthor, ErrMsg, sPr)) then
  begin
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'Signed Document by Author Error');
    Exit;
  end;
  FSortBy := cboSortBy.ItemID;
  if FSortBy = '' then FSortBy := 'R';
  FListAscending := (radListSort.ItemIndex = 0);
  FTreeAscending := (radTreeSort.ItemIndex = 0);

  FKeyWord := txtKeyWord.Text;
  if (ckTitle.Checked) and (ckSubject.Checked) then
    FSearchField := 'B'
  else if ckTitle.Checked then
    FSearchField := 'T'
  else if ckSubject.Checked then
    FSearchField := 'S'
  else if not (ckTitle.Checked or ckSubject.Checked) then
    begin
      FKeyWord := '';
      FSearchField := '';
    end;
  if (FKeyword <> '') then
    FFiltered := True;

  if ckSubject.Checked then ckShowSubject.Checked := True;
  FShowSubject := ckShowSubject.Checked;
  FMaxDocs := StrToIntDef(edMaxDocs.Text, 0);
  if cboGroupBy.ItemID <> '' then
    FGroupBy := cboGroupBy.ItemID
  else
    FGroupBy := '';
  FChanged := True;
  Close;
end;

procedure TfrmTIUView.cmdCancelClick(Sender: TObject);
begin
  FChanged := False;
  Close;
end;

procedure TfrmTIUView.lstStatusSelect(Sender: TObject);
var
  EnableDates: Boolean;
begin
  EnableDates := (lstStatus.ItemID <> '1');
  lblBeginDate.Enabled := EnableDates;
  calBeginDate.Enabled := EnableDates;
  lblEndDate.Enabled := EnableDates;
  calEndDate.Enabled := EnableDates;
  if not EnableDates then
    begin
      calBeginDate.Text := '';
      calEndDate.Text := '';
    end
  else
    begin
      calBeginDate.Text := FCurrentContext.BeginDate;
      calEndDate.Text   := FCurrentContext.EndDate;
      if FCurrentContext.EndDate = '' then calEndDate.FMDateTime := FMToday;
    end;
  if lstStatus.ItemID = '3' then
    lblAuthor.Caption := 'Expected Cosigner:'
  else
    lblAuthor.Caption := 'Author:';
  cboAuthor.Caption := lblAuthor.Caption;
  if (lstStatus.ItemID = '1') or (lstStatus.ItemID = '5') then
    begin
      cboAuthor.ItemIndex := -1;
      cboAuthor.Enabled := False;
      lblAuthor.Enabled := False;
      if FMaxDocs > 0 then
        edMaxDocs.Text := IntToStr(FMaxDocs)
      else
        edMaxDocs.Text := '';
      edMaxDocs.Enabled := True;
      lblMaxDocs.Enabled := True;
    end
  else
    begin
      cboAuthor.Enabled := True;
      cboAuthor.SelectByIEN(FAuthor);
      lblAuthor.Enabled := True;
      edMaxDocs.Text := '';
      edMaxDocs.Enabled := False;
      lblMaxDocs.Enabled := False;
    end;
end;


procedure TfrmTIUView.cboAuthorNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  sl := TSTringList.Create;
  try
    setSubSetOfActiveAndInactivePersons(cboAuthor, sl, StartFrom, Direction);
    cboAuthor.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmTIUView.cmdClearClick(Sender: TObject);
begin
  cboSortBy.ItemIndex := -1;
  cboGroupBy.ItemIndex := -1;
  ckTitle.Checked := False;
  ckSubject.Checked := False;
  txtKeyWord.Text := '';
  radTreeSort.ItemIndex := 1;
  radListSort.ItemIndex := 1;
end;

end.
