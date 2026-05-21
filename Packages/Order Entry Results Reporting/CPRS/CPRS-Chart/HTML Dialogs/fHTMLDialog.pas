// brEdgeExecuteScript(
unit fHTMLDialog;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  System.JSON.Converters,
  System.JSON.Serializers,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Winapi.WebView2,
  Winapi.ActiveX,
  Vcl.Edge,
  Vcl.StdCtrls,
  VAShared.GenericStringList,
  VAShared.UDataTracker,
  fBase508Form,
  VA508AccessibilityManager,
  ORCtrls,
  ORCheckComboBox;

type
  TWebContentType = (wcUnknown, wcJSBody, wcJSHead, wcCSS, wcHTML, wcData,
    wcSchema, wcUISchema, wcSysData);

  TfrmHTMLDialog = class(TfrmBase508Form)
    pnlButtons: TPanel;
    brEdge: TEdgeBrowser;
    btnSave: TButton;
    btnCancel: TButton;
    tmrCancel: TTimer;
    btnRefresh: TButton;
    procedure brEdgeCreateWebViewCompleted(Sender: TCustomEdgeBrowser;
      AResult: HRESULT);
    procedure brEdgeWebMessageReceived(Sender: TCustomEdgeBrowser;
      Args: TWebMessageReceivedEventArgs);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure brEdgeWebResourceRequested(Sender: TCustomEdgeBrowser;
      Args: TWebResourceRequestedEventArgs);
    procedure tmrCancelTimer(Sender: TObject);
    procedure brEdgeExecuteScript(Sender: TCustomEdgeBrowser; AResult: HRESULT;
      const AResultObjectAsJson: string);
    procedure btnRefreshClick(Sender: TObject);
    procedure brEdgeNavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    procedure FormDestroy(Sender: TObject);
    procedure PerformSpecificFieldValidation(JSON: TJSONObject);
  public type

    TCloseQueryEvent = procedure(Sender: TfrmHTMLDialog; Content: TJSONObject;
      Canceling: Boolean; var CanClose: Boolean) of object;
    TSubmitEvent = procedure(Sender: TfrmHTMLDialog; Content: TJSONObject)
      of object;

    TParams = record
    public
      ContentName: string;
      OnSubmit: TSubmitEvent;
      OnCloseQuery: TCloseQueryEvent;
      OnCancel: TNotifyEvent;
      Modal: Boolean;
      JSONSchema: string;
      JSONUISchema: string;
      JSONData: string;
      FormID: string;
      caption: string;
      class operator Initialize(out Dest: TParams);
      constructor Create(AModal: Boolean; AContentName: string;
        AOnSubmit: TSubmitEvent; AOnCancel: TNotifyEvent;
        AOnCloseQuery: TCloseQueryEvent = nil; AJSONSchema: string = '';
        AJSONUISchema: string = ''; AJSONData: string = '';
        AFormID: string = ''; ACaption: string = '');
    end;

  private type
    TSubmitStage = (ssNormal, ssQuery, ssQueryApproved);
    TWebContentInsertType = wcJSBody .. wcCSS;

    [JsonSerialize(TJsonMemberSerialization.Public)]
    TContent = class(TObject)
    private
      FContentType: string;
      FData: string;
      FName: string;
      FReservedForSystem: Boolean;
      FWebContentType: TWebContentType;
      procedure SetContentType(const Value: string);
    public
      property ContentType: string read FContentType write SetContentType;
      property Data: string read FData write FData;
      property Name: string read FName write FName;
      property ReservedForSystem: Boolean read FReservedForSystem
        write FReservedForSystem;
      [JsonIgnore]
      property WebContentType: TWebContentType read FWebContentType;
    end;

    TJSONFormData = record
    public const
      JSONMessage = 'JSONForm';
      Saving = JSONMessage + 'Saving';
      Query = JSONMessage + 'Query';
    public
      IsJSONForm: Boolean;
      Schema: string;
      UISchema: string;
      Data: string;
      function BuildGlobalsString: string;
      procedure Clear;
    end;

  private const
    WebContentInsertTypes = [wcJSHead, wcJSBody, wcCSS];
    SubmitQuery = 'Submit Query';
    SubmitRedirect = 'Submit Redirect';
    SubmitSave = 'Submit Save';
    JSONFormRoot = 'JSON Form Root';
    JSONFormQuery = 'JSON Form Query';
    CPRSProtocol = 'cprs://';
    MaxRetries = 5;
  private
    FJSONForm: TJSONFormData;
    FLastNavString: string;
    FParams: TParams;
    FRetryCount: Integer;
    FStarted: Boolean;
    FSubmitted: Boolean;
    FSubmitStage: TSubmitStage;
    class var FFormIDPrefix: string;
    class var FJSONFormsBundledJavaScript: string;
    class var FLocalDataTracker: TDataTracker;
    class var FDialogs: TStringList<TfrmHTMLDialog>;
    class var FSystem: TStringList<TContent>;
    class constructor Create;
    class destructor Destroy;
    function SystemContent(Name: string): TContent;
    function SystemData(Name: string): string;
    function RetrieveData(Name: string): string;
  protected
    procedure ExecuteScript(const JavaScript: string);
    class function InsertTrackedData(Input: string): string;
    function NavigateToString(const AHTMLContent: string): Boolean;
    property Params: TParams read FParams write FParams;
    property Started: Boolean read FStarted write FStarted;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithParams(AParams: TParams);
    destructor Destroy; override;
    class procedure DestroyAllDialogs;
    class procedure DestroyDialog(AFormID: string);
    class procedure ClosedHTMLForms;
    property readParams: TParams read FParams;
  end;

function InWebServerDevMode: Boolean;
procedure CreateHTMLDialog(AParams: TfrmHTMLDialog.TParams);

implementation

{$R *.dfm}

uses
  System.Zip,
  System.TypInfo,
  System.NetEncoding,
  Winapi.UxTheme,
  Vcl.Themes,
  VAShared.UJSONValueHelper,
  VAShared.RttiUtils,
  VAUtils,
  ORFn,
  ORNet,
  uCore,
  rMisc,
  uMessageAdapterManager,
  uORLists,
  rHTMLDialog,
  uSimilarNames;

function InWebServerDevMode: Boolean;
begin
{$IFDEF DEBUG}
  Result := False;//User.DUZ = 520824667;
{$ELSE}
  Result := False;
{$ENDIF}
end;

procedure CreateHTMLDialog(AParams: TfrmHTMLDialog.TParams);
var
  HTMLDialog: TfrmHTMLDialog;
begin
  HTMLDialog := TfrmHTMLDialog.CreateWithParams(AParams);
  if AParams.Modal then
    HTMLDialog.ShowModal
  else
    HTMLDialog.Show;
  // no need to Free form, it frees itself when closed
end;

{ TfrmHTMLDialog.TParams }

constructor TfrmHTMLDialog.TParams.Create(AModal: Boolean; AContentName: string;
  AOnSubmit: TSubmitEvent; AOnCancel: TNotifyEvent;
  AOnCloseQuery: TCloseQueryEvent = nil; AJSONSchema: string = '';
  AJSONUISchema: string = ''; AJSONData: string = ''; AFormID: string = ''; ACaption: string = '');
begin
  ContentName := AContentName;
  OnSubmit := AOnSubmit;
  OnCancel := AOnCancel;
  OnCloseQuery := AOnCloseQuery;
  Modal := AModal;
  JSONSchema := AJSONSchema;
  JSONUISchema := AJSONUISchema;
  JSONData := AJSONData;
  if AFormID <> '' then
    FormID := AFormID
  else
    FormID := AContentName;
  FormID := TfrmHTMLDialog.FFormIDPrefix + FormID;
  caption := ACaption;
end;

class operator TfrmHTMLDialog.TParams.Initialize(out Dest: TParams);
begin
  Dest.ContentName := '';
  Dest.OnSubmit := nil;
  Dest.OnCancel := nil;
  Dest.OnCloseQuery := nil;
  Dest.Modal := False;
  Dest.JSONSchema := '';
  Dest.JSONUISchema := '';
  Dest.JSONData := '';
  Dest.FormID := '';
end;

{ TfrmHTMLDialog.TContent }

procedure TfrmHTMLDialog.TContent.SetContentType(const Value: string);
begin
  if FContentType <> Value then
  begin
    FContentType := Value;
    FWebContentType := TRttiUtils.GetEnumValueFromString<TWebContentType>
      (Value, 'wc');
  end;
end;

{ TfrmHTMLDialog.TJSONFormData }

function TfrmHTMLDialog.TJSONFormData.BuildGlobalsString: string;
var
  MyFont: TFont;

  procedure Add(Key, Value: string; Quotes: Boolean = True); overload;
  begin
    Result := Result + 'window.initialJSON' + Key + ' = ';
    if Quotes then
      Result := Result + '''';
    Result := Result + Value;
    if Quotes then
      Result := Result + '''';
    Result := Result + ';' + CRLF;
  end;

  procedure Add(Key: string; Value: Integer); overload;
  begin
    Add(Key, Value.ToString, False);
  end;

  procedure AddColor(Key: string; Color: TColor);
  var
    RGBColor: TColor;
    RedValue, GreenValue, BlueValue: Byte;
    JsColorString: string;
  begin
    RGBColor := ColorToRGB(Color);
    RedValue := GetRValue(RGBColor);
    GreenValue := GetGValue(RGBColor);
    BlueValue := GetBValue(RGBColor);
    JsColorString := Format('rgb(%d, %d, %d)',
      [RedValue, GreenValue, BlueValue]);
    Add(Key, JsColorString);
  end;

  function GetThumbColor: TColor;
  var
    Theme: HTHEME;
    ThumbColor: COLORREF;
  begin
    Result := clBtnShadow;
    Theme := OpenThemeData(Application.Handle, 'SCROLLBAR');
    if Theme <> 0 then
      try
        if Succeeded(GetThemeColor(Theme, SBP_THUMBBTNHORZ, SCRBS_NORMAL,
          TMT_FILLCOLOR, ThumbColor)) then
        begin
          Result := TColor(ThumbColor);
        end;
      finally
        CloseThemeData(Theme);
      end;
  end;

begin
  Result := '';
  Add('FontSize', Application.MainForm.Font.Size + 2);
  MyFont := TFont.Create;
  try
    MyFont.Assign(MainFont);
    MyFont.Size := MyFont.Size + 2;
    Add('FontHeight', TextHeightByFont(MainFont.Handle, 'XyZ') + 2);
  finally
    FreeAndNil(MyFont);
  end;
  Add('FontFamily', Application.MainForm.Font.Name);
  AddColor('FontColor', Application.MainForm.Font.Color);
  Add('ScrollBarWidth', Winapi.Windows.GetSystemMetrics(SM_CXVSCROLL));
  AddColor('ScrollBarColor', GetSysColor(COLOR_SCROLLBAR));
  Add('ThumbHeight', Winapi.Windows.GetSystemMetrics(SM_CYVTHUMB));
  Add('ThumbWidth', Winapi.Windows.GetSystemMetrics(SM_CXVSCROLL) * 3 div 8);
  AddColor('ThumbColor', GetThumbColor);
  Add('Schema', Schema, False);
  if UISchema <> '' then
    Add('UISchema', UISchema, False);
  if Data <> '' then
    Add('Data', Data, False);
end;

procedure TfrmHTMLDialog.TJSONFormData.Clear;
begin
  IsJSONForm := False;
  Schema := '';
  UISchema := '';
  Data := '';
end;

{ TfrmHTMLDialog }

procedure TfrmHTMLDialog.brEdgeCreateWebViewCompleted
  (Sender: TCustomEdgeBrowser; AResult: HRESULT);
const HTMLInsertBegin: array [TWebContentInsertType] of string =
    ('<script type="text/javascript">', '<script type="text/javascript">',
    '<style>');
  HTMLInsertEnd: array [TWebContentInsertType] of string = ('</script>',
    '</script>', '</style>');
  HeadBeginHTML = '<head>';
  HeadEndHTML = '</head>';
  BodyBeginHTML = '<body>';
  BodyEndHTML = '</body>';

  procedure Error(Text1: string; Text2: string = '');
  var
    Text: string;
  begin
    Text := Text1 + ' web Content ''' + Params.ContentName + '''.';
    if Text2 <> '' then
      Text := Text + CRLF + Text2;
    ShowMessage(Text);
    Release;
  end;

var
  JSON: TJSONObject;
  List: TJSONArray;
  Content: TContent; KillContent: Boolean;
  Strings: array [TWebContentType] of string;
  Data, Err: string;
begin
  if AResult <> S_OK then
  begin
    inc(FRetryCount);
    if FRetryCount < MaxRetries then
      brEdge.CreateWebView
    else
      raise Exception.CreateFmt
        ('Error Message %d in TEdgeBrowser.CreateWebView', [AResult]);
    exit;
  end;
  FRetryCount := 0;
  FJSONForm.Clear;
  brEdge.AddWebResourceRequestedFilter(CPRSProtocol + '*',
    COREWEBVIEW2_WEB_RESOURCE_CONTEXT_ALL);

  // brEdge.DefaultInterface.OpenDevToolsWindow;

  for var I := Low(TWebContentType) to High(TWebContentType) do
    Strings[I] := '';
  if (Params.ContentName <> '') or (not Assigned(FSystem)) or (FSystem.Count = 0)
  then
  begin
    if not Assigned(FSystem) then
      FSystem := TStringList<TContent>.Create(True);
    JSON := CreateWebContentJSON(Params.ContentName, Err, FSystem.Count = 0);
  end
  else
    JSON := nil;
  try
    if Assigned(JSON) then
    begin
      if not JSON.AsTypeDef<Boolean>('success', False) then
      begin
        Error('Error retrieving', JSON.AsTypeDef<string>('error', ''));
        exit;
      end;
      List := JSON.AsTypeDef<TJSONArray>('contents', nil);
      if Assigned(List) then
      begin
        for var I := 0 to List.Count - 1 do
        begin
          KillContent := True;
          Content := List[I].ToObject<TContent>;
          try
            if Content.ReservedForSystem then
            begin
              FSystem.AddObject(Content.Name, Content);
              KillContent := False;
            end
            else
            begin
              if Content.WebContentType in WebContentInsertTypes then
              begin
                Strings[Content.WebContentType] :=
                  Strings[Content.WebContentType] + HTMLInsertBegin
                  [Content.WebContentType] + Content.Data + HTMLInsertEnd
                  [Content.WebContentType];
              end
              else
              begin
                if Strings[Content.WebContentType] <> '' then
                begin
                  Data := GetEnumName(TypeInfo(TWebContentType),
                    ord(Content.WebContentType));
                  Data := Copy(Data, 3, MaxInt);
                  Error('Multiple ' + Data + ' entries in');
                  exit;
                end
                else
                begin
                  Strings[Content.WebContentType] := Content.Data;
                  if Content.WebContentType <> wcHTML then
                    FJSONForm.IsJSONForm := True;
                end;
              end;
            end;
          finally
            if KillContent then
              FreeAndNil(Content);
          end;
        end;
      end;
    end;

    if Params.JSONSchema <> '' then
    begin
      Strings[wcSchema] := Params.JSONSchema;
      FJSONForm.IsJSONForm := True;
    end;
    if Params.JSONUISchema <> '' then
    begin
      Strings[wcUISchema] := Params.JSONUISchema;
      FJSONForm.IsJSONForm := True;
    end;
    if Params.JSONData <> '' then
    begin
      Strings[wcData] := Params.JSONData;
      FJSONForm.IsJSONForm := True;
    end;

    if FJSONForm.IsJSONForm and (Strings[wcHTML] = '') then
      Strings[wcHTML] := SystemData(JSONFormRoot);

    if Strings[wcHTML] = '' then
    begin
      Error('No HTML found in');
      exit;
    end;
    if (pos(HeadBeginHTML, Strings[wcHTML]) = 0) or
      (pos(HeadEndHTML, Strings[wcHTML]) = 0) then
    begin
      Error('HTML has no ' + HeadBeginHTML + 'section in');
      exit;
    end;
    if (pos(BodyBeginHTML, Strings[wcHTML]) = 0) or
      (pos(BodyEndHTML, Strings[wcHTML]) = 0) then
    begin
      Error('HTML has no ' + BodyBeginHTML + 'section in');
      exit;
    end;

    if Strings[wcCSS] <> '' then
      Strings[wcHTML] := StringReplace(Strings[wcHTML], HeadEndHTML,
        Strings[wcCSS] + HeadEndHTML, []);

    if not FJSONForm.IsJSONForm then
    begin
      Content := SystemContent(SubmitRedirect);
      if Assigned(Content) and (Content.WebContentType in WebContentInsertTypes)
      then
      begin
        Strings[Content.WebContentType] := Strings[Content.WebContentType] +
          HTMLInsertBegin[Content.WebContentType] + Content.Data + HTMLInsertEnd
          [Content.WebContentType];
      end;
    end;

    if Strings[wcJSHead] <> '' then
      Strings[wcHTML] := StringReplace(Strings[wcHTML], HeadEndHTML,
        Strings[wcJSHead] + HeadEndHTML, []);

    if Strings[wcJSBody] <> '' then
      Strings[wcHTML] := StringReplace(Strings[wcHTML], BodyEndHTML,
        Strings[wcJSBody] + BodyEndHTML, []);

    if FJSONForm.IsJSONForm then
    begin
      if (Strings[wcSchema] = '') then
      begin
        Error('JSON Form missing schema in');
        exit;
      end;
      FJSONForm.Schema := Strings[wcSchema];
      if (Strings[wcUISchema] <> '') then
        FJSONForm.UISchema := Strings[wcUISchema];
      if (Strings[wcData] <> '') then
        FJSONForm.Data := Strings[wcData];
    end;

  finally
    FreeAndNil(JSON);
  end;
  if InWebServerDevMode then
  begin
    brEdge.Navigate('http://localhost:9000')
  end
  else
    NavigateToString(Strings[wcHTML]);
end;

procedure TfrmHTMLDialog.brEdgeExecuteScript(Sender: TCustomEdgeBrowser;
  AResult: HRESULT; const AResultObjectAsJson: string);
begin
  // if AResult <> S_OK then
  // if AResultObjectAsJson <> '' then
  // ShowMessage(AResultObjectAsJson);

end;

procedure TfrmHTMLDialog.brEdgeNavigationCompleted(Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
begin
  inherited;
  if not IsSuccess then
  begin
    inc(FRetryCount);
    if FRetryCount < MaxRetries then
    begin
      brEdge.NavigateToString(FLastNavString);
      exit;
    end;
  end;
  FRetryCount := 0;
  Caption := brEdge.DocumentTitle;
  if Params.caption <> '' then Caption := Params.caption;
  brEdge.SetFocus;
  btnRefresh.Visible := True;
end;

procedure TfrmHTMLDialog.brEdgeWebMessageReceived(Sender: TCustomEdgeBrowser;
  Args: TWebMessageReceivedEventArgs);
var
  JSonStr: PWideChar;
  JSON, DelphiMessage: TJSONObject;
  MessageType, Script, CallID: string;
  CanClose: Boolean;
  Adapter: TMessageAdapter;

  procedure Submitted;
  begin
    CanClose := True;
    if Assigned(Params.OnCloseQuery) then
      Params.OnCloseQuery(Self, JSON, False, CanClose);
    if CanClose then
    begin
      FSubmitted := True;
      FSubmitStage := ssQueryApproved;
      if Assigned(Params.OnSubmit) then
        Params.OnSubmit(Self, JSON);
      Close;
    end
    else
    begin
      FSubmitted := False;
      FSubmitStage := ssNormal;
    end;
  end;

  procedure Query;
  begin
    tmrCancel.Enabled := False;
    FSubmitted := False;
    CanClose := True;
    if Assigned(Params.OnCloseQuery) then
      Params.OnCloseQuery(Self, JSON, True, CanClose);
    if CanClose then
    begin
      FSubmitStage := ssQueryApproved;
      Close;
    end
    else
      FSubmitStage := ssNormal;
  end;

begin
  if Args.ArgsInterface.TryGetWebMessageAsString(JSonStr) = S_OK then
  begin
    JSON := TJSONValue.ParseJSONValue(JSonStr) as TJSONObject;
    try
      DelphiMessage := JSON.AsTypeDef<TJSONObject>(DelphiMessageStr, nil);
      if not Assigned(DelphiMessage) then
        exit;
      MessageType := DelphiMessage.AsTypeDef<string>('type', '');
      if (MessageType = 'submit') then
      begin
        JSON.RemovePair(DelphiMessageStr);
        FreeAndNil(DelphiMessage);
        if FSubmitStage = ssNormal then
          Submitted
        else if (FSubmitStage = ssQuery) and
          (JSON.AsTypeDef<Boolean>('CloseQuery', False)) then
          Query;
      end
      else if (MessageType.StartsWith(TJSONFormData.JSONMessage)) then
      begin
        JSON.RemovePair(DelphiMessageStr);
        PerformSpecificFieldValidation(JSON);
        FreeAndNil(DelphiMessage);
        if MessageType = TJSONFormData.Saving then
          Submitted
        else if MessageType = TJSONFormData.Query then
          Query;
      end
      else
      begin
        Adapter := TMessageAdapterManager.Adapter[MessageType];
        if Assigned(Adapter) then
        begin
          Adapter.UpdateMessage(Self, JSON, RetrieveData);
          CallID := DelphiMessage.AsTypeDef<string>('callId', '');
          Script := 'window.updateData[''' + CallID + '''](''' +
            JSON.ToString + ''');';
          if Script <> '' then
            ExecuteScript(Script);
        end;
      end;
    finally
      FreeAndNil(JSON);
    end;
  end;

end;

procedure TfrmHTMLDialog.brEdgeWebResourceRequested(Sender: TCustomEdgeBrowser;
  Args: TWebResourceRequestedEventArgs);
var
  Request: ICoreWebView2WebResourceRequest;
  Response: ICoreWebView2WebResourceResponse;
  URL, RName, RData: string;
  PURL: PWideChar;
begin
  Args.ArgsInterface.get_Request(Request);
  Request.get_Uri(PURL);
  URL := PURL;

  if URL.StartsWith(CPRSProtocol) then
  begin
    Response := nil;
    RName := Copy(URL, Length(CPRSProtocol) + 1, MaxInt);
    RData := '';
    if RName = 'bundle.js' then
      RData := FJSONFormsBundledJavaScript
    else if RName = 'globals.js' then
      RData := FJSONForm.BuildGlobalsString;
    if RData <> '' then
    begin
      RData := InsertTrackedData(RData);
      brEdge.EnvironmentInterface.CreateWebResourceResponse
        (TStreamAdapter.Create(TStringStream.Create(RData), soOwned), 200, 'OK',
        'Content-Type: application/javascript', Response);
      Args.ArgsInterface.Set_Response(Response);
    end;
  end;
end;

procedure TfrmHTMLDialog.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHTMLDialog.btnRefreshClick(Sender: TObject);
begin
  inherited;
  brEdge.Refresh;
end;

procedure TfrmHTMLDialog.btnSaveClick(Sender: TObject);
begin
  if FJSONForm.IsJSONForm then
    ExecuteScript(Format(SystemData(JSONFormQuery), [FJSONForm.Saving]))
  else
    ExecuteScript(SystemData(SubmitSave));
end;

class procedure TfrmHTMLDialog.DestroyAllDialogs;
begin
  if Assigned(FDialogs) then
  begin
    FDialogs.OwnsObjects := True;
    try
      FDialogs.Clear;
    finally
      FDialogs.OwnsObjects := False;
    end;
  end;
end;

class procedure TfrmHTMLDialog.DestroyDialog(AFormID: string);
var
  Index: Integer;
begin
  if Assigned(FDialogs) then
  begin
    Index := FDialogs.IndexOf(FFormIDPrefix + AFormID);
    if Index >= 0 then
    begin
      FDialogs.Objects[Index].Free;
      FDialogs.Delete(Index);
    end;
  end;
end;

class procedure TfrmHTMLDialog.ClosedHTMLForms;
var
i: integer;
begin
  if Assigned(FDialogs) then
  begin
    try
      for i := 0 to FDialogs.Count - 1 do
      begin
        if (FDialogs.Objects[i] is TfrmHTMLDialog) then
        begin
          if not (FDialogs.Objects[i] as TfrmHTMLDialog).Showing then
            continue;
          if fsModal in (FDialogs.Objects[i] as TfrmHTMLDialog).FormState then
          begin
            (FDialogs.Objects[i] as TfrmHTMLDialog).ModalResult := mrCancel;
            (FDialogs.Objects[i] as TfrmHTMLDialog).CloseModal;
          end
          else
            (FDialogs.Objects[i] as TfrmHTMLDialog).Close;
        end;
      end;
    finally

    end;
  end;
end;

constructor TfrmHTMLDialog.Create(AOwner: TComponent);
begin
  raise Exception.Create
    ('Don''t use TfrmHTMLDialog.Create, use TfrmHTMLDialog.CreateWithParams');
end;

class constructor TfrmHTMLDialog.Create;
begin
  FFormIDPrefix := TfrmHTMLDialog.ClassName + '_';
end;

constructor TfrmHTMLDialog.CreateWithParams(AParams: TParams);

  procedure InitClassVariables;
  const ScriptFile = 'bundle.js';
  var
    ResourceStream: TResourceStream;
    ZipFile: TZipFile;
    ExtractedStream: TMemoryStream;
    JavaScriptBytes: TBytes;
    StringList: TStringList;
  begin
    if not Assigned(FLocalDataTracker) then
    begin
      FLocalDataTracker := TDataTracker.Create;
      FLocalDataTracker.AddData('Font', @Application.MainForm.Font,
        TypeInfo(TFont));
    end;
    if FJSONFormsBundledJavaScript = '' then
    begin
      ZipFile := nil;
      ExtractedStream := nil;
      StringList := nil;
      ResourceStream := TResourceStream.Create(HInstance, 'JSONFormsJS',
        RT_RCDATA);
      try
        ZipFile := TZipFile.Create;
        ExtractedStream := TMemoryStream.Create;
        StringList := TStringList.Create;
        StringList.LineBreak := '';
        // Open the ZIP file from the resource stream
        ZipFile.Open(ResourceStream, zmRead);

        // Extract the JavaScript file from the ZIP (assuming the file inside is named "bundle.js")
        if ZipFile.IndexOf(ScriptFile) >= 0 then
        begin
          ZipFile.Read(ScriptFile, JavaScriptBytes);
          ExtractedStream.WriteBuffer(JavaScriptBytes[0],
            Length(JavaScriptBytes));
          ExtractedStream.Position := 0;
          // Reset the stream position for reading
          StringList.LoadFromStream(ExtractedStream);
          // Load into a string list
          FJSONFormsBundledJavaScript := StringList.Text; // Convert to string
        end
        else
        begin
          raise Exception.Create
            (ScriptFile +
            ' file not found in JSONFormsJS RC_DATA Zip resource.');
        end;
      finally
        ZipFile.Free;
        ResourceStream.Free;
        ExtractedStream.Free;
        StringList.Free;
      end;
    end;
  end;

begin
  if (AParams.ContentName = '') then
  begin
    if AParams.JSONSchema = '' then
      raise EArgumentException.Create
        ('CreateHTMLDialog requires a Content Name or a JSON Schema.');
    if AParams.FormID = FFormIDPrefix then
      raise EArgumentException.Create
        ('CreateHTMLDialog requires a Content Name or a Form ID.');
  end;
  inherited Create(nil);
  InitClassVariables;
  FJSONForm.Clear;
  FParams := AParams;
  if not Assigned(FDialogs) then
    FDialogs := TStringList<TfrmHTMLDialog>.Create(False);
  FDialogs.AddObject(FParams.FormID, Self);
  SetFormPosition(Self, FParams.FormID);
end;

destructor TfrmHTMLDialog.Destroy;
var
  Index: Integer;
begin
  SaveUserBounds(Self, FParams.FormID);
  Index := FDialogs.IndexOf(FParams.FormID);
  if Index >= 0 then
    FDialogs.Delete(Index);
  inherited;
end;

procedure TfrmHTMLDialog.ExecuteScript(const JavaScript: string);
begin
  brEdge.ExecuteScript(InsertTrackedData(JavaScript));
end;

class destructor TfrmHTMLDialog.Destroy;
begin
  DestroyAllDialogs;
  FreeAndNil(FDialogs);
  FreeAndNil(FSystem);
  FreeAndNil(FLocalDataTracker);
end;

procedure TfrmHTMLDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if (not FSubmitted) and Assigned(Params.OnCancel) then
    Params.OnCancel(Self);
end;

procedure TfrmHTMLDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Params.OnCloseQuery) and (FSubmitStage <> ssQueryApproved) then
  begin
    CanClose := False;
    FSubmitStage := ssQuery;
    if FJSONForm.IsJSONForm then
    begin
      ExecuteScript(Format(SystemData(JSONFormQuery), [FJSONForm.Query]));
    end
    else
      ExecuteScript(SystemData(SubmitQuery));
    tmrCancel.Enabled := True;
  end;
end;

procedure TfrmHTMLDialog.FormCreate(Sender: TObject);
begin
  FSubmitStage := ssNormal;
end;

procedure TfrmHTMLDialog.FormDestroy(Sender: TObject);
begin
  if InWebServerDevMode then
  begin
  end;
  inherited;
end;

procedure TfrmHTMLDialog.FormShow(Sender: TObject);
begin
  if not FStarted then
  begin
    brEdge.CreateWebView;
    FStarted := True;
  end;
end;

class function TfrmHTMLDialog.InsertTrackedData(Input: string): string;
var
  Done: Boolean;
  idx1, Idx2, p: Integer;
  Name, Data: string;
begin
  Result := Input;
  Done := False;
  p := 1;
  repeat
    idx1 := pos('{{', Result, p);
    if idx1 > 0 then
    begin
      Idx2 := pos('}}', Result, idx1);
      if Idx2 > 0 then
      begin
        p := idx1;
        Name := Copy(Result, idx1 + 2, Idx2 - idx1 - 2);
        Data := '';
        if Assigned(FLocalDataTracker) then
        begin
          if FLocalDataTracker.HasData(Name) then
            Data := FLocalDataTracker.Data[Name].ToString
          else if FLocalDataTracker.HasValue(Name) then
            Data := FLocalDataTracker.Value[Name]
        end;
        if Data = '' then
        begin
          if DataTracker.HasData(Name) then
            Data := DataTracker.Data[Name].ToString
          else if DataTracker.HasValue(Name) then
            Data := DataTracker.Value[Name];
        end;
        Result := Copy(Result, 1, idx1 - 1) + Data +
          Copy(Result, Idx2 + 2, MaxInt);
      end
      else
        Done := True;
    end
    else
      Done := True;
  until Done;
end;

function TfrmHTMLDialog.NavigateToString(const AHTMLContent: string): Boolean;
begin
  FLastNavString := InsertTrackedData(AHTMLContent);
  Result := brEdge.NavigateToString(FLastNavString);
end;

procedure TfrmHTMLDialog.PerformSpecificFieldValidation(JSON: TJSONObject);
var
  Schema, InitialData, InitialValue, InputJSON, Item, FormData, FormDataValue, ReturnData: TJSONObject;
  Properties, PropSchema: TJSONObject;
  Data: TJSONValue;
  Pair: TJSONPair;
  ReturnArray: TJSONArray;
  error, PropName, InitialConst, FormDataConst, FormDataTitle, ConstValue, DisplayValue, titleValue, xValudationCall: string;
  xSingleCall: boolean;
  AExceptions, PossibleValues: TStrings;
  i: Integer;
  AID: Int64;

  procedure UpdateJSONValue(JSONObj: TJSONObject; const Key: string; const Value: string);
  var
    Pair: TJSONPair;
  begin
    Pair := JSONObj.Get(Key);
    if Assigned(Pair) then
      Pair.JsonValue := TJSONString.Create(Value)
    else
      JSONObj.AddPair(Key, TJSONString.Create(Value));
  end;

begin
  // Parse the JSON strings to TJSONObject
  Schema := TJSONObject.ParseJSONValue(self.Params.JSONSchema) as TJSONObject;
  InitialData := TJSONObject.ParseJSONValue(self.Params.JSONData) as TJSONObject;
  FormData := JSON as TJSONObject;

  try
    if Assigned(Schema) and Schema.TryGetValue<TJSONObject>('properties', Properties) then
    begin
      for Pair in Properties do
      begin
        PropName := Pair.JsonString.Value;
        PropSchema := Pair.JsonValue as TJSONObject;
        PropSchema.TryGetValue('x-singleCall', xSingleCall);
        PropSchema.TryGetValue('x-validationCall', xValudationCall);

        // Check for x-singleCall = true and x-validationCall is not empty
        if (not xSingleCall) and (xValudationCall <> '') then
        begin
          // Try to get initial and form data values, handle if not defined
          if not InitialData.TryGetValue<TJSONObject>(PropName, InitialValue) then
            begin
              InitialValue := nil;
              InitialConst := '';
            end
          else
            InitialValue.TryGetValue<string>('const', InitialConst);
          if not FormData.TryGetValue<TJSONObject>(PropName, FormDataValue) then
            Break; // if FormDataValue is not defined, break the loop

          // Compare values and perform validation
          if Assigned(FormDataValue) and FormDataValue.TryGetValue<string>('const', FormDataConst) and
             (InitialConst <> FormDataConst) then
          begin
            InputJSON := TJSONObject.Create;
            PossibleValues := TStringList.Create;
            AExceptions := TStringList.Create;
            try
              FormDataValue.TryGetValue<string>('title', FormDataTitle);
              InputJSON.AddPair('lookupType', xValudationCall);
              InputJSON.AddPair('startFrom', FormDataTitle);
              InputJSON.AddPair('startId', FormDataConst);
              InputJSON.AddPair('direction', 'down');

//              ShowMessage(Format('Value change detected for "%s": %s -> %s',
//                [PropName, InitialConst, FormDataConst]));

              Data := CreateJSONFromVistACall('ORHRPC LOOKUP', error, InputJSON);

              // Process the returned JSON data
              if Assigned(Data) and (Data is TJSONObject) then
              begin
                ReturnData := Data as TJSONObject;

                if ReturnData.TryGetValue<TJSONArray>('data', ReturnArray) then
                begin
                  if ReturnArray.Count = 1 then Exit;
                  for i := 0 to ReturnArray.Count - 1 do
                  begin
                    Item := ReturnArray.Items[i] as TJSONObject;
                    Item.TryGetValue<string>('const', ConstValue);
                    Item.TryGetValue<string>('display', DisplayValue);
                    Item.TryGetValue<string>('title', titleValue);
                    if (ConstValue <> '') and (DisplayValue <> '') then
                      PossibleValues.Add(ConstValue + U + titleValue + U + Piece(DisplayValue, '-', 2));
                  end;
                  AID := StrToInt64Def(getItemIDFromList(PossibleValues, sPr, AExceptions), -1);
                  if AID = -1 then
                    break;

                  if StrToInt64Def(InitialConst, -1) <> AID then
                  begin
                    // Update passed in JSON value property const with AID and update title field from ReturnArray entry that matches the new AID value.
                    for i := 0 to ReturnArray.Count - 1 do
                    begin
                      Item := ReturnArray.Items[i] as TJSONObject;
                      if Item.TryGetValue<string>('const', ConstValue) and (ConstValue = IntToStr(AID)) then
                      begin
                        // Update the JSON value itself
                        UpdateJSONValue(FormDataValue, 'const', ConstValue);
                        if Item.TryGetValue<string>('title', DisplayValue) then
                          UpdateJSONValue(FormDataValue, 'title', DisplayValue);
//                        if Item.TryGetValue<string>('display', DisplayValue) then
//                        begin
//                          FormDataTitle := DisplayValue;
//                          UpdateJSONValue(FormDataValue, 'title', FormDataTitle);
//                        end;
                        Break;
                      end;
                    end;
                  end;
                end;
              end;
            finally
              FreeAndNil(InputJSON);
              FreeAndNil(PossibleValues);
              FreeAndNil(AExceptions);
            end;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(Schema);
    FreeAndNil(InitialData);
  end;
end;

function TfrmHTMLDialog.RetrieveData(Name: string): string;
begin
  Result := SystemData(Name);
  Result := InsertTrackedData(Result);
end;

function TfrmHTMLDialog.SystemContent(Name: string): TContent;
var
  idx: Integer;
begin
  Result := nil;
  if Assigned(FSystem) then
  begin
    idx := FSystem.IndexOf(Name);
    if idx >= 0 then
      Result := FSystem.Objects[idx];
  end;
end;

function TfrmHTMLDialog.SystemData(Name: string): string;
var
  Content: TContent;
begin
  Content := SystemContent(Name);
  if Assigned(Content) then
    Result := Trim(Content.Data)
  else
    Result := '';
end;

procedure TfrmHTMLDialog.tmrCancelTimer(Sender: TObject);
begin
  tmrCancel.Enabled := False;
  FSubmitStage := ssQueryApproved;
  Close;
end;

end.
