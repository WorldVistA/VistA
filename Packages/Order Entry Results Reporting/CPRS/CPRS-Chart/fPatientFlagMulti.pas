unit fPatientFlagMulti;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fAutoSz, ORCtrls, ExtCtrls, ComCtrls, rMisc, fBase508Form,
  VA508AccessibilityManager;

type
  {This object holds a List of Notes Linked to a PRF as Returned VIA the RPCBroker}
  TPRFNotes = class(TObject)
  private
    FPRFNoteList : TStringList;
  public
    //procedure to show the Notes in a ListView, requires a listview parameter
    procedure ShowActionsOnList(DisplayList : TCaptionListView);
    //procedure to load the notes, this will call the RPC
    procedure Load(TitleIEN : Int64; DFN : String);
    function getNoteIEN(index: integer): String;
    constructor create;
    destructor Destroy(); override;
  end;

  TfrmFlags = class(TfrmBase508Form)
    Panel1: TPanel;
    Splitter3: TSplitter;
    Splitter1: TSplitter;
    lblFlags: TLabel;
    lstFlagsCat2: TORListBox;
    memFlags: ORExtensions.TRichEdit;
    pnlNotes: TPanel;
    lvPRF: TCaptionListView;
    lblNoteTitle: TLabel;
    Splitter2: TSplitter;
    pnlBottom: TORAutoPanel;
    btnClose: TButton;
    lstFlagsCat1: TORListBox;
    lblCat1: TLabel;
    TimerTextFlash: TTimer;
    procedure lstFlagsCat1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure lvPRFClick(Sender: TObject);
    procedure lvPRFKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerTextFlashTimer(Sender: TObject);
    procedure lstFlagsCat2Click(Sender: TObject);
  private
    FFlagID: integer;
    FPRFNotes : TPRFNotes;
    FNoteTitle: String;
    procedure GetNotes(SelectedList : TORListBox);
    procedure MakeCat1FlagsStandOut;
    procedure LoadSelectedFlagData(SelectedList : TORListBox);
    procedure ActivateSpecificFlag;
    procedure PutFlagsOnLists(flags, Cat1List,  Cat2List: TStrings);
    function GetListToActivate : TORListBox;
  public
    { Public declarations }
  end;
const
  HIDDEN_COL = 'Press enter or space bar to view this note:';
  //TIU GET LINKED PRF NOTES, return position constants
  NOTE_IEN_POS = 1;
  ACTION_POS = 2;
  NOTE_DATE_POS = 3;
  AUTHOR_POS = 4;
  //TIU GET PRF TITLE, return position constants
  NOTE_TITLE_IEN = 1;
  NOTE_TITLE = 2;


procedure ShowFlags(FlagId: integer = 0);

implementation

uses uCore,uOrPtf,ORFn, ORNet, uConst, fRptBox, rCover, VAUtils;
{$R *.dfm}

procedure ShowFlags(FlagId: integer);
var
  frmFlags: TfrmFlags;
begin
  frmFlags := TFrmFlags.Create(Nil);
  try
    SetFormPosition(frmFlags);
    if HasFlag then
    begin
      with frmFlags do begin
        FFlagID := FlagId;
        PutFlagsOnLists(FlagList, lstFlagsCat1.Items, lstFlagsCat2.Items);
      end;
      frmFlags.memFlags.SelStart := 0;
      ResizeFormToFont(TForm(frmFlags));
      frmFlags.ShowModal;
    end
  finally
    frmFlags.Release;
  end;
end;

procedure TfrmFlags.lstFlagsCat1Click(Sender: TObject);
begin
  if lstFlagsCat1.ItemIndex >= 0 then
  begin
    with lstFlagsCat2 do
      Selected[ItemIndex] := False;
    LoadSelectedFlagData(lstFlagsCat1);
  end;
end;

procedure TfrmFlags.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;


procedure TfrmFlags.FormShow(Sender: TObject);
begin
  inherited;
  SetFormPosition(Self);
  if lstFlagsCat1.Count > 0 then
    MakeCat1FlagsStandOut;

  ActivateSpecificFlag;
end;

procedure TfrmFlags.FormCreate(Sender: TObject);
begin
  inherited;
  FFlagID := 0;
end;

procedure TfrmFlags.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
end;

procedure TfrmFlags.GetNotes(SelectedList: TORListBox);
var
  NoteTitleIEN, FlagId: Int64;
  sl: TStrings;
begin
  if FPRFNotes = nil then
    FPRFNotes := TPRFNotes.create;
  FlagId := SelectedList.ItemID;
  sl := TStringList.create;
  try
    CallVistA('TIU GET PRF TITLE', [Patient.DFN, FlagId], sl);
    if sl.Count > 0 then
    begin
      FNoteTitle := Piece(sl[0], U, NOTE_TITLE);
      NoteTitleIEN := StrToInt(Piece(sl[0], U, NOTE_TITLE_IEN));
      FPRFNotes.Load(NoteTitleIEN, Patient.DFN);
    end
    else
    begin
      FNoteTitle := '';
      FPRFNotes.FPRFNoteList.Clear;
    end;
    lblNoteTitle.Caption := 'Signed, Linked Notes of Title: '+ FNoteTitle;
    FPRFNotes.ShowActionsOnList(lvPRF);
    with lvPRF do
    begin
      Columns.BeginUpdate;
      Columns.EndUpdate;
    end;
  finally
    sl.Free;
  end;
end;
{ TPRFNotes }

constructor TPRFNotes.create;
begin
  inherited;
  FPRFNoteList := TStringList.create;
end;

destructor TPRFNotes.Destroy;
begin
  FPRFNoteList.Free;
  inherited;
end;

function TPRFNotes.getNoteIEN(index: integer): String;
begin
 Result := Piece(FPRFNoteList[index],U,NOTE_IEN_POS);
end;

procedure TPRFNotes.Load(TitleIEN: Int64; DFN: String);
const
  REVERSE_CHRONO = 1;
var
  sl: TStrings;
begin
  sl := TSTringList.Create;
  try
    if CallVistA('TIU GET LINKED PRF NOTES', [DFN,TitleIEN,REVERSE_CHRONO],sl) then
      FastAssign(sl, FPRFNoteList);
  finally
    sl.Free;
  end;
end;

procedure TPRFNotes.ShowActionsOnList(DisplayList: TCaptionListView);
var
  i : integer;
  ListItem: TListItem;
begin
  DisplayList.Clear;
  for i := 0 to FPRFNoteList.Count-1 do
  begin
    //Caption="Text for Screen Reader" SubItem1=Flag SubItem2=Date SubItem3=Action SubItem4=Note
    ListItem := DisplayList.Items.Add;
    ListItem.Caption := HIDDEN_COL; //Screen readers don't read the first column title on a listview.
    ListItem.SubItems.Add(Piece(FPRFNoteList[i],U,NOTE_DATE_POS));
    ListItem.SubItems.Add(Piece(FPRFNoteList[i],U,ACTION_POS));
    ListItem.SubItems.Add(Piece(FPRFNoteList[i],U,AUTHOR_POS));
  end;
end;

procedure TfrmFlags.FormDestroy(Sender: TObject);
begin
  FPRFNotes.Free;
end;

procedure TfrmFlags.lvPRFClick(Sender: TObject);
begin
  if lvPRF.ItemIndex > -1 then
  begin
    NotifyOtherApps(NAE_REPORT, 'TIU^' + FPRFNotes.getNoteIEN(lvPRF.ItemIndex));
    ReportBox(DetailPosting(FPRFNotes.getNoteIEN(lvPRF.ItemIndex)), FNoteTitle, True);
  end;
end;

procedure TfrmFlags.lvPRFKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) or (Key = VK_RETURN) then
    lvPRFClick(Sender);
end;


procedure TfrmFlags.MakeCat1FlagsStandOut;
Const
  FONT_INC = 4;
  clBrightOrange = TColor($3ABEF3);  //Blue 58 Green 190 Red 243
begin
  lblCat1.Font.Size := lblCat1.Font.Size + FONT_INC;
  lstFlagsCat1.Font.Size := lstFlagsCat1.Font.Size + FONT_INC;
  lblCat1.Color := Get508CompliantColor(clBrightOrange);
  lstFlagsCat1.Color := Get508CompliantColor(clBrightOrange);
  lblCat1.Font.Color := Get508CompliantColor(clWhite);
  lstFlagsCat1.Font.Color := Get508CompliantColor(clWhite);
  TimerTextFlash.Enabled := true;
end;

procedure TfrmFlags.TimerTextFlashTimer(Sender: TObject);
begin
  if lblCat1.Font.Color = Get508CompliantColor(clWhite) then
    lblCat1.Font.Color := Get508CompliantColor(clBlack)
  else
    lblCat1.Font.Color := Get508CompliantColor(clWhite);
end;

procedure TfrmFlags.LoadSelectedFlagData(SelectedList: TORListBox);
var
  FlagArray: TStringList;
begin
  FlagArray := TStringList.create;
  try
    GetActiveFlg(FlagArray, Patient.DFN, SelectedList.ItemID);
    if FlagArray.Count > 0 then
      QuickCopy(FlagArray, memFlags);
    memFlags.SelStart := 0;
    GetNotes(SelectedList);
  finally
    FlagArray.Free;
  end;
end;

procedure TfrmFlags.lstFlagsCat2Click(Sender: TObject);
begin
  if lstFlagsCat2.ItemIndex >= 0 then
  begin
    with lstFlagsCat1 do
      Selected[ItemIndex] := False;
    LoadSelectedFlagData(lstFlagsCat2);
  end;
end;

procedure TfrmFlags.ActivateSpecificFlag;
var
  idx: integer;
  SelectedList : TORListBox;
begin
  idx := 0;
  SelectedList := GetListToActivate;
  if FFlagID > 0 then
    idx := SelectedList.SelectByIEN(FFlagId);
  SelectedList.ItemIndex := idx;
  SelectedList.OnClick(Self);
  if ScreenReaderActive then
    ActiveControl := SelectedList
  else
    ActiveControl := memFlags;
  GetNotes(SelectedList);
end;

function TfrmFlags.GetListToActivate: TORListBox;
begin
  Result := nil;
  if FFlagID > 0 then begin
    if lstFlagsCat1.SelectByIEN(FFlagId) > -1 then
      Result := lstFlagsCat1
    else if lstFlagsCat2.SelectByIEN(FFlagId) > -1 then
      Result := lstFlagsCat2
  end;
  if Result = nil then
    if lstFlagsCat1.Items.Count > 0 then
      Result := lstFlagsCat1
    else
      Result := lstFlagsCat2;

end;

procedure TfrmFlags.PutFlagsOnLists(flags, Cat1List, Cat2List: TStrings);
Const
  FLAG_TYPE_POS = 3;
  TRUE_STRING = '1';
var
  i, TypeOneCount, TypeTwoCount : integer;
begin
  TypeOneCount := 0;
  TypeTwoCount := 0;
  for i := 0 to flags.Count-1 do begin
    if Piece(flags[i],U,FLAG_TYPE_POS) = TRUE_STRING then begin
      Cat1List.Add(flags[i]);
      Inc(TypeOneCount);
    end else begin
      Cat2List.Add(flags[i]);
      Inc(TypeTwoCount);
    end;
  end;
  If TypeOneCount > 0 then
   lblCat1.Caption := 'Category I Flags: ' + IntToStr(TypeOneCount) + ' Item(s)'
  else
   lblCat1.Caption := 'Category I Flags';

  If TypeTwoCount > 0 then
   lblFlags.Caption := 'Category II Flags: ' + IntToStr(TypeTwoCount) + ' Item(s)'
  else
   lblFlags.Caption := 'Category II Flags';
end;


end.
