unit fOMHTML;
{ ------------------------------------------------------------------------------
  Update History

  2018-09-17: RTC 272867 (Replacing old server calls with CallVistA)
  ---------------------------------------------------------------------------- }

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fOMAction, StdCtrls, OleCtrls, SHDocVw, MSHTML, activex, rOrders, uConst,
  ExtCtrls, VA508AccessibilityManager;

type
  TfrmOMHTML = class(TfrmOMAction)
    btnOK: TButton;
    btnCancel: TButton;
    btnBack: TButton;
    pnlWeb: TPanel;
    btnShow: TButton;
    webView: TWebBrowser;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure webViewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure webViewDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
  private
    FOwnedBy: TComponent;
    FRefNum:  Integer;
    FDialog:  Integer;
    FSetList: TStringList;
    FPageCache: TList;
    FCurrentIndex: Integer;
    FCurrentURL: string;
    FCurrentDoc: IHtmlDocument2;
    FDelayEvent: TOrderDelayEvent;
    FHistoryStack: TStringList;
    FHistoryIndex: Integer;
    function GetPageIndex(const URL: string): Integer;
    function MetaElementExists(const AName, AContent: string): Boolean;
    procedure AddPageToCache;
    procedure SaveState;
    procedure RestoreState;
    procedure SetDialog(Value: Integer);
  public
    procedure SetEventDelay(AnEvent: TOrderDelayEvent);
    property Dialog:  Integer     read FDialog  write SetDialog;
    property OwnedBy: TComponent  read FOwnedBy write FOwnedBy;
    property RefNum:  Integer     read FRefNum  write FRefNum;
    property SetList: TStringList read FSetList write FSetList;
  end;

var
  frmOMHTML: TfrmOMHTML;

implementation

{$R *.DFM}

uses ORFn, rCore, uCore, uOrders, ORNet, TRPCB, rMisc, ORNetIntf, ORExtensions;

const
  TAB = #9;

type
  TPageState = class
  private
    FURL:        string;
    FTagStates:  TStringList;
    FSubmitData: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TPageState }

constructor TPageState.Create;
begin
  FTagStates  := TStringList.Create;
  FSubmitData := TStringList.Create;
end;

destructor TPageState.Destroy;
begin
  FTagStates.Free;
  FSubmitData.Free;
  inherited;
end;

{ temporary RPC's }

function GetIENforHtml(const AnID: string): Integer;
{AnID, O.name or O.ien for 101.41, H.name or H.ien for 101.14}
begin
//  Result := StrToIntDef(sCallV('ORWDHTM GETIEN', [AnID]), 0);
  if not CallVistA('ORWDHTM GETIEN', [AnID],Result) then
    Result := 0;
end;

function GetHTMLText(AnIEN: Integer): string;
{return HTML text from 101.14 given IEN}
var
  sl: TStrings;
begin
//  CallV('ORWDHTM HTML', [AnIEN, Patient.DFN]);
//  Result := RPCBrokerV.Results.Text;
  sl := TSTringList.Create;
  try
    if CallVistA('ORWDHTM HTML', [AnIEN, Patient.DFN],sl) then
      Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function GetURLforDialog(AnIEN: Integer): string;
begin
//  Result := sCallV('ORWDHTM URL', [AnIEN]);
//  if Result = '' then Result := 'about:URL not found';
  if not CallVistA('ORWDHTM URL', [AnIEN],Result) then
    Result := 'Error calling "ORWDHTM URL"'
  else
    if Result = '' then Result := 'about:URL not found';
end;

procedure NameValueToViewList(Src, Dest: TStringList);
{ xform name<TAB>value into DlgIEN^DlgType^DisplayName list }
var
  i: Integer;
  Subs: string;
  aList: iORNetMult;
begin
  newORNetMult(aList);
  for i := 0 to Pred(Src.Count) do
  begin
    Subs := IntToStr(Succ(i));
    aList.AddSubscript([Subs],  Copy(Src[i], 1, 245));
  end; {for i}
  CallVistA('ORWDHTM NV2DNM',[aList],dest);
end;

procedure NameValueToOrderSet(Src, Dest: TStringList);
{ xform name<TAB>value into DlgIEN^DlgType^DisplayName list }
var
  i, j: Integer;
  Subs: string;
  WPText: TStringList;
  aList: iORNetMult;
begin
  WPText := TStringList.Create;
  newORNetMult(aList);
  for i := 0 to Pred(Src.Count) do
  begin
    WPText.Clear;
    WPText.Text := Copy(Src[i], Pos(TAB, Src[i]) + 1, Length(Src[i]));
    Subs := IntToStr(Succ(i)); // "Succ is equivalent in performance to simple addition, or the Inc procedure"
    if WPText.Count = 1 then
      aList.AddSubscript([Subs], Src[i])
    else
    begin
      aList.AddSubscript(['WP', Subs], Piece(Src[i], TAB, 1) + TAB + 'NMVAL("WP",' + Subs + ')');

      for j := 0 to Pred(WPText.Count) do
        aList.AddSubscript(['WP', Subs,Succ(j),0], WPText[j]);
    end; { if WPText }
  end; { for i }
  WPText.Free;
  CallVistA('ORWDHTM NV2SET',[aList],Dest);
end;

{ general procedures }

procedure TfrmOMHTML.SetEventDelay(AnEvent: TOrderDelayEvent);
begin
  FDelayEvent := AnEvent;
end;

function TfrmOMHTML.GetPageIndex(const URL: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pred(FPageCache.Count) do
    if TPageState(FPageCache[i]).FURL = URL then
    begin
      Result := i;
      break;
    end;
end;

function TfrmOMHTML.MetaElementExists(const AName, AContent: string): Boolean;
var
  i: Integer;
  AnElement: IHtmlElement;
  AllElements: IHtmlElementCollection;
begin
  Result := False;
  AllElements := FCurrentDoc.All;
  for i := 0 to Pred(AllElements.Length) do
  begin
    AnElement := AllElements.Item(i, 0) as IHtmlElement;
    if AnElement.tagName = 'META' then
      with AnElement as IHtmlMetaElement do
        if (CompareText(name, AName) = 0) and (CompareText(content, AContent) = 0)
           then Result := True;
    if Result then Break;
  end;
end;

procedure TfrmOMHTML.AddPageToCache;
var
  APageState: TPageState;
begin
  APageState := TPageState.Create;
  APageState.FURL := FCurrentURL;
  FCurrentIndex := FPageCache.Add(APageState);
end;

procedure TfrmOMHTML.SaveState;
var
  i: Integer;
  SelectName, State, NmVal, x: string;
  APageState: TPageState;
  AnElement: IHtmlElement;
  AnInput: IHtmlInputElement;
  ASelect: IHtmlSelectElement;
  AnOption: IHtmlOptionElement;
  ATextArea: IHtmlTextAreaElement;
  AllElements: IHtmlElementCollection;
begin
  if FCurrentIndex < 0 then Exit;
  Assert(Assigned(FCurrentDoc));
  APageState := FPageCache[FCurrentIndex];
  APageState.FTagStates.Clear;
  APageState.FSubmitData.Clear;
  if not MetaElementExists('VistAuse', 'ORWDSET') then Exit;

  AllElements := FCurrentDoc.All;
  for i := 0 to Pred(AllElements.Length) do
  begin
    AnElement := AllElements.Item(i, 0) as IHtmlElement;
    NmVal := '';
    State := '';
    if AnElement.tagName = 'INPUT' then
    begin
      AnInput := AnElement as IHtmlInputElement;
      if AnInput.type_ = 'checkbox' then
      begin
        if AnInput.checked then
        begin
          State := AnInput.name + TAB + '1';
          NmVal := AnInput.name + TAB + '1';
        end
        else State := AnInput.name + TAB + '0';
      end; {checkbox}
      if AnInput.type_ = 'radio' then
      begin
        if AnInput.checked then
        begin
          State := AnInput.name + AnInput.Value + TAB + '1';
          NmVal := AnInput.value + TAB + '1';
        end
        else State := AnInput.name + AnInput.Value + TAB + '0';
      end; {radio}
      if (AnInput.type_ = 'hidden') or (AnInput.type_ = 'password') or (AnInput.type_ = 'text') then
      begin
        State := AnInput.name + TAB + AnInput.value;
        NmVal := State;
      end; {hidden, password, text}
    end; {INPUT}
    if AnElement.tagname = 'SELECT' then
    begin
      ASelect := AnElement as IHtmlSelectElement;
      SelectName := ASelect.name;
    end; {SELECT}
    if AnElement.tagName = 'OPTION' then
    begin
      AnOption := AnElement as IHtmlOptionElement;
      x := AnOption.value;
      if x = '' then x := AnOption.text;
      if AnOption.Selected then
      begin
        State := SelectName + x + TAB + '1';
        NmVal := SelectName + TAB + x;
      end
      else State := SelectName + x + TAB + '0';
    end; {OPTION}
    if AnElement.tagName = 'TEXTAREA' then
    begin
      ATextArea := AnElement as IHtmlTextAreaElement;
      State := ATextArea.name + TAB + ATextArea.value;
      NmVal := State;
    end; {TEXTAREA}
    if Length(State) > 0 then APageState.FTagStates.Add(State);
    if Length(NmVal) > 0 then APageState.FSubmitData.Add(NmVal);
  end; {for i}
end;

procedure TfrmOMHTML.RestoreState;
var
  i: Integer;
  SelectName, x: string;
  APageState: TPageState;
  AnElement: IHtmlElement;
  AnInput: IHtmlInputElement;
  ASelect: IHtmlSelectElement;
  AnOption: IHtmlOptionElement;
  ATextArea: IHtmlTextAreaElement;
  AllElements: IHtmlElementCollection;

  function GetStateFromName(const AName: string): string;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to Pred(APageState.FTagStates.Count) do
    begin
      if Piece(APageState.FTagStates[i], TAB, 1) = AName then
      begin
        Result := Piece(APageState.FTagStates[i], TAB, 2);
        Break;
      end; {if Piece}
    end; {for i}
  end; {GetStateFromName}

begin
  APageState := TPageState(FPageCache.Items[FCurrentIndex]);
  if APageState.FTagStates.Count = 0 then Exit;
  AllElements := FCurrentDoc.All;
  for i := 0 to Pred(AllElements.Length) do
  begin
    AnElement := AllElements.Item(i, 0) as IHtmlElement;
    if AnElement.tagName = 'INPUT' then
    begin
      AnInput := AnElement as IHtmlInputElement;
      if AnInput.type_ = 'checkbox'
        then AnInput.Set_checked(GetStateFromName(AnInput.name) = '1');
      if AnInput.Type_ = 'radio'
        then AnInput.Set_checked(GetStateFromName(AnInput.name + AnInput.Value) = '1');
      if (AnInput.type_ = 'hidden') or (AnInput.type_ = 'password') or (AnInput.type_ = 'text')
        then AnInput.Set_value(GetStateFromName(AnInput.name));
    end; {INPUT}
    if AnElement.tagname = 'SELECT' then
    begin
      ASelect := AnElement as IHtmlSelectElement;
      SelectName := ASelect.name;
    end; {SELECT}
    if AnElement.tagName = 'OPTION' then
    begin
      AnOption := AnElement as IHtmlOptionElement;
      x := AnOption.value;
      if x = '' then x := AnOption.text;
      AnOption.Set_selected(GetStateFromName(SelectName + x) = '1');
    end; {OPTION}
    if AnElement.tagName = 'TEXTAREA' then
    begin
      ATextArea := AnElement as IHtmlTextAreaElement;
      ATextArea.Set_value(GetStateFromName(ATextArea.name));
    end; {TEXTAREA}
  end; {for i}
end;

procedure TfrmOMHTML.SetDialog(Value: Integer);
begin
  FDialog := Value;
  webView.Navigate(GetURLForDialog(FDialog));
end;

{ Form events (get the initial page loaded) }

procedure TfrmOMHTML.FormCreate(Sender: TObject);
begin
  SetUserDataFolder(webView);
  AutoSizeDisabled := True;
  inherited;
  FPageCache := TList.Create;
  FSetList := TStringList.Create;
  FHistoryStack := TStringList.Create;
  FHistoryIndex := -1;
  FCurrentIndex := -1;
end;

procedure TfrmOMHTML.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
  if (FOwnedBy <> nil) and (FOwnedBy is TWinControl)
      then SendMessage(TWinControl(FOwnedBy).Handle, UM_DESTROY, FRefNum, 0);
end;

procedure TfrmOMHTML.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := Pred(FPageCache.Count) downto 0 do TPageState(FPageCache[i]).Free;
  DestroyingOrderHTML;
  FSetList.Free;
  FHistoryStack.Free;
  inherited;
end;

{ webBrowser events }

procedure TfrmOMHTML.webViewDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
{ This event happens after a navigation.  It is at this point that there is an instantiated
  instance of IHtmlDocument available. }
begin
  inherited;
  if not Assigned(webView.Document) then Exit;
  FCurrentDoc := webView.Document as IHtmlDocument2;
  FCurrentURL := URL;
  FHistoryStack.Add(FCurrentURL);
  btnBack.Enabled := FHistoryStack.Count > 1;
  FCurrentIndex := GetPageIndex(FCurrentURL);
  if FCurrentIndex >= 0 then RestoreState else AddPageToCache;
end;

function CopyToCtrlChar(const Src: string; StartAt: Integer): string;
var
  i: Integer;
begin
  Result := '';
  if StartAt < 1 then StartAt := 1;
  for i := StartAt to Length(Src) do
    if Ord(Src[i]) > 31 then Result := Result + Src[i] else break;
end;

procedure TfrmOMHTML.webViewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  inherited;
  SaveState;
  // activate order dialog here, i.e., 'about:CPRSOrder=FHW1'
end;

{ button events }

procedure TfrmOMHTML.btnOKClick(Sender: TObject);
var
  i, j: Integer;
  APageState: TPageState;
begin
  inherited;
  SaveState;
  // create an order set based on all the saved states of pages navigated to
  for i := 0 to Pred(FPageCache.Count) do
  begin
    APageState := FPageCache[i];
    for j := 0 to Pred(APageState.FSubmitData.Count) do
    begin
      FSetList.Add(APageState.FSubmitData[j]);
    end;
  end;
  NameValueToOrderSet(FSetList, FSetList);
  // put in reference number, key variables, & caption later as necessary
  //ActivateOrderList(NameValuePairs, FDelayEvent, Self, 0, '', '');
  Close;
end;

procedure TfrmOMHTML.btnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmOMHTML.btnBackClick(Sender: TObject);
var
  BackURL: string;
begin
  inherited;
  if FHistoryStack.Count > 1 then
  begin
    FHistoryStack.Delete(Pred(FHistoryStack.Count));
    BackURL := FHistoryStack[Pred(FHistoryStack.Count)];
    FHistoryStack.Delete(Pred(FHistoryStack.Count));
    if FHistoryStack.Count < 2 then btnBack.Enabled := False;
    webView.Navigate(BackURL);
  end;
end;

procedure TfrmOMHTML.btnShowClick(Sender: TObject);
var
  i, j: Integer;
  APageState: TPageState;
  tmpList: TStringList;
begin
  inherited;
  SaveState;
  tmpList := TStringList.Create;
  // create an order set based on all the saved states of pages navigated to
  for i := 0 to Pred(FPageCache.Count) do
  begin
    APageState := FPageCache[i];
    for j := 0 to Pred(APageState.FSubmitData.Count) do
    begin
      tmpList.Add(APageState.FSubmitData[j]);
    end;
  end;
  NameValueToViewList(tmpList, tmpList);
  InfoBox(tmpList.Text, 'Current Selections', MB_OK);
  tmpList.Free;
end;

{ was assigned to OnBeforeNavigate:

  SaveState;
  // activate order dialog here, i.e., 'about:CPRSOrder=FHW1'
}
end.
