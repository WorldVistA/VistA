unit uWriteAccess;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Character,
  System.Generics.Collections,
  ORFn,
  uConst;

type
  TWriteAccessType = (waNone, waConsults, waConsultTemplates, waDCSumm,
    waDCSummTemplates, waMeds, waProgressNotes, waProgressNoteTemplates,
    waOrders, waProblems, waSurgery, waSurgeryTemplates, waAllergies,
    waDelayedOrders, waEncounter, waImmunization, waReminderEditor, waVitals,
    waWomenHealth);

  TActionType = (atNone, atWrite, atCopy, atChange, atRenew, atHold,
    atDiscontinue, atUnhold, atFlag, atFlagComment, atUnflag, atComplete,
    atAlert, atRefill, atVerify, atChartReview, atReleaseWithoutSig, atSign,
    atSignedOnChart, atComment, atTransfer, atChangeRelease, atReleaseDelayed,
    atPark, atUnpark);

  TWriteAccess = class(TObject)
  public type
    TDGWriteAccess = class(TObject)
    private
      FIEN: Integer;
      FName: string;
      FShortName: string;
      FDisplayName: string;
      FWriteAccess: Boolean;
    public
      constructor Create; virtual;
      property IEN: Integer read FIEN;
      property Name: string read FName;
      property ShortName: string read FShortName;
      property DisplayName: string read FDisplayName;
      property WriteAccess: Boolean read FWriteAccess;
    end;

    TDGWriteAccessClass = class of TDGWriteAccess;

    TDGWriteAccessParent = class(TDGWriteAccess)
    private
      FChildWriteAccess: Boolean;
      FAccessData: string;
      FAccessGroups: string;
      FMissingGroups: string;
      FDoBuild: Boolean;
    protected
      procedure EnsureBuild;
      procedure UpdateChildFields(children: string);
      procedure Build; virtual; abstract;
      procedure UpdateAccessData(obj: TDGWriteAccess); virtual;
      function GetChildWriteAccess: Boolean;
      function GetParentDisplayName: string; virtual;
    public
      constructor Create; override;
      property ChildWriteAccess: Boolean read GetChildWriteAccess;
      property AccessData: string read FAccessData;
      property AccessGroups: string read FAccessGroups;
      property MissingGroups: string read FMissingGroups;
      property ParentDisplayName: string read GetParentDisplayName;
    end;

    TDGWriteAccessLab = class(TDGWriteAccessParent)
    private
      class var FLabGroups: string;
    protected
      procedure Build; override;
      procedure UpdateAccessData(obj: TDGWriteAccess); override;
    public
      constructor Create; override;
    end;

    TDGWriteAccessImaging = class(TDGWriteAccessParent)
    protected
      procedure Build; override;
    end;

    TDGWriteAccessDietetics = class(TDGWriteAccessParent)
    public type
      TCodeInfo = class
        DisplayGroup: Integer;
        TabCode: string;
      end;
      class var CodeInfo: TObjectList<TCodeInfo>;
      class constructor Create;
      class destructor Destroy;
    private
      FTabCode: string;
      function GetTabCode: string;
    protected
      class var FChildren: string;
      class var FDieteticsDisplayName: string;
      procedure Build; override;
      function GetParentDisplayName: string; override;
    public
      property TabCode: string read GetTabCode;
    end;

  private type
    TWriteAccessErrorList = class(TStringList)
    private
      AccessType: TWriteAccessType;
      ActionType: TActionType;
    end;

    TWriteAccessErrorSubList = class(TStringList)
    private
      DisplayGroupIEN: Integer;
      RequireChildAccess: Boolean;
    end;

  private const
    ErrorIndent = 3;

  private
    FAccess: array [TWriteAccessType] of Boolean;
    FLoaded: array [TWriteAccessType] of Boolean;
    FIgnorelErrors: Boolean;
    FErrors: TStringList;
    FErrorProcessingCount: Integer;
    FOrderAccessList: TObjectList<TDGWriteAccess>;
    FPad: string;
    FSystemErrorText: string;
    procedure CleanUpErrorText(Sender: TObject);
    function Errors: TStringList;
    function SystemErrorText: string;
    procedure ShowErrorMessage(SortErrors: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function ActionType(ActionCode: String): TActionType;
    function WriteAccess(warType: TWriteAccessType; ShowError: Boolean = False;
      ErrorMessage: String = ''): Boolean; overload;
    function WriteAccess(warType: TWriteAccessType; ActionType: TActionType;
      ShowError: Boolean = False; ErrorMessage: String = ''): Boolean; overload;
    function OrderAccess(obj: TDGWriteAccess; ActionType: TActionType;
      ShowError: Boolean = False; ErrorMessage: String = '';
      RequireChildAccess: Boolean = False): Boolean;
    procedure BeginErrors;
    procedure Error(warType: TWriteAccessType; ActionType: TActionType;
      ErrorMessage: String = ''; DisplayGroup: Integer = 0;
      RequireChildAccess: Boolean = False); overload;
    procedure Error(warType: TWriteAccessType; ErrorMessage: String = '';
      DisplayGroup: Integer = 0; RequireChildAccess: Boolean = False); overload;
    procedure EndErrors(SortErrors: Boolean);
    procedure IgnoreErrors;
    procedure ShowPermissions(Sender: TObject);
    function DGWriteAccess(IEN: Integer): TDGWriteAccess; overload;
    function DGWriteAccess(Name: string): TDGWriteAccess; overload;
    procedure InitCPRSDisplayGroups;
  end;

function WriteAccess(warType: TWriteAccessType; ShowError: Boolean = False;
  ErrorMessage: String = ''): Boolean; overload;
function WriteAccess(warType: TWriteAccessType; ActionType: TActionType;
  ShowError: Boolean = False; ErrorMessage: String = ''): Boolean; overload;

var
  WriteAccessV: TWriteAccess;

implementation

uses
  System.JSON,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.StdCtrls,
  uCore,
  ORClasses,
  ORNet,
  fRptBox,
  rOrders,
  rODBase,
  rMisc,
  rODRad,
  VAInfoDialog;

{ TWriteAccess }

type
  TActionInfo = record
    Code: string;
    Desc: string;
  end;

  TWriteAccessInfo = record
  type
    TWAPluralType = (ptNormal, ptYies, ptNone, ptThisNone);
    TWA3DigitInt = 100 .. 999;
  public
    Priority: TWA3DigitInt; // MUST be unique in warInfo constant
    Item: String;
    PluralType: TWAPluralType;
    Desc: String;
    JSON: String;
  end;

const
  warActionInfo: array [TActionType] of TActionInfo = (
    { atNone } (Code: ''; Desc: 'act on %s %%s'),
    { atWrite } (Code: ''; Desc: 'write %s %%s'),
    { atCopy } (Code: OA_COPY; Desc: 'copy %s %%s'),
    { atChange } (Code: OA_CHANGE; Desc: 'change %s %%s'),
    { atRenew } (Code: OA_RENEW; Desc: 'renew %s %%s'),
    { atHold } (Code: OA_HOLD; Desc: 'hold %s %%s'),
    { atDiscontinue } (Code: OA_DC; Desc: 'discontinue %s %%s'),
    { atUnhold } (Code: OA_UNHOLD; Desc: 'release the hold on %s %%s'),
    { atFlag } (Code: OA_FLAG; Desc: 'flag %s %%s'),
    { atFlagComment } (Code: OA_FLAGCOMMENT;
    Desc: 'enter flag comments for %s %%s'),
    { atUnflag } (Code: OA_UNFLAG; Desc: 'unflag %s %%s'),
    { atComplete } (Code: OA_COMPLETE; Desc: 'complete %s %%s'),
    { atAlert } (Code: OA_ALERT;
    Desc: 'get an alert when results are available for %s %%s'),
    { atRefill } (Code: OA_REFILL; Desc: 'refill %s %%s'),
    { atVerify } (Code: OA_VERIFY; Desc: 'verify %s %%s'),
    { atChartReview } (Code: OA_CHART; Desc: 'chart review %s %%s'),
    { atReleaseWithoutSig } (Code: OA_RELEASE;
    Desc: 'release %s %%s without MD signature'),
    { atSign } (Code: OA_SIGN; Desc: 'sign %s %%s'),
    { atSignedOnChart } (Code: OA_ONCHART;
    Desc: 'mark %s %%s as signed on chart'),
    { atComment } (Code: OA_COMMENT; Desc: 'comment on %s %%s'),
    { atTransfer } (Code: OA_TRANSFER; Desc: 'transfer %s %%s'),
    { atChangeRelease } (Code: OA_CHGEVT;
    Desc: 'change %s %%s''%s release event%s'),
    { atReleaseDelayed } (Code: OA_EDREL; Desc: 'release %s delayed %%s'),
    { atPark } (Code: OA_PARK; Desc: 'park %s %%s'),
    { atUnpark } (Code: OA_UNPARK; Desc: 'unpark %s %%s'));

  warInfo: array [TWriteAccessType] of TWriteAccessInfo = (
    { waNone } (Priority: 999; Item: 'Unknown Item';
    Desc: 'an Unknown Write-Access Type'),
    { waConsults } (Priority: 230; Item: 'Consult Note';
    Desc: 'the Consults Tab'; JSON: 'cprsAccess.consults.writeAccess'),
    { waConsultTemplates } (Priority: 232; Item: 'Consult Note Template';
    Desc: 'Consult Note Templates'; JSON: 'cprsAccess.consults.templateAccess'),
    { waDCSumm } (Priority: 250; Item: 'Discharge Summar'; PluralType: ptYies;
    Desc: 'the Discharge Summaries tab'; JSON: 'cprsAccess.dcSumm.writeAccess'),
    { waDCSummTemplates } (Priority: 252; Item: 'Discharge Summary Template';
    Desc: 'Discharge Summary Templates';
    JSON: 'cprsAccess.dcSumm.templateAccess'),
    { waMeds } (Priority: 200; Item: 'Medication'; Desc: 'the Meds tab';
    JSON: 'cprsAccess.meds.writeAccess'),
    { waProgressNotes } (Priority: 220; Item: 'Progress Note';
    Desc: 'the Notes tab'; JSON: 'cprsAccess.notes.writeAccess'),
    { waProgressNoteTemplates } (Priority: 222; Item: 'Progress Note Template';
    Desc: 'Progress Note Templates'; JSON: 'cprsAccess.notes.templateAccess'),
    { waOrders } (Priority: 260; Item: 'Order'; Desc: 'the Orders tab';
    JSON: 'cprsAccess.orders.writeAccess'),
    { waProblems } (Priority: 180; Item: 'Problem'; Desc: 'the Problems tab';
    JSON: 'cprsAccess.problems.writeAccess'),
    { waSurgery } (Priority: 240; Item: 'Surgery Note'; Desc: 'the Surgery tab';
    JSON: 'cprsAccess.surgery.writeAccess'),
    { waSurgeryTemplates } (Priority: 242; Item: 'Surgery Note Template';
    Desc: 'Surgery Note Templates'; JSON: 'cprsAccess.surgery.templateAccess'),
    { waAllergies } (Priority: 110; Item: 'Allerg'; PluralType: ptYies;
    Desc: 'Allergies'; JSON: 'cprsAccess.allergy.writeAccess'),
    { waDelayedOrders } (Priority: 215; Item: 'Delayed Order';
    Desc: 'Delayed Orders'; JSON: 'cprsAccess.delayedOrders.writeAccess'),
    { waEncounter } (Priority: 300; Item: 'Encounter';
    Desc: 'the Encounters Form'; JSON: 'cprsAccess.encounters.writeAccess'),
    { waImmunization } (Priority: 130; Item: 'Immunization';
    Desc: 'Cover Sheet Immunizations';
    JSON: 'cprsAccess.immunization.writeAccess'),
    { waReminderEditor } (Priority: 150; Item: 'Cover Sheet Reminder';
    Desc: 'Cover Sheet Reminders List Editor';
    JSON: 'cprsAccess.reminderEditor.writeAccess'),
    { waVitals } (Priority: 120; Item: 'Vital Sign'; PluralType: ptNone;
    Desc: 'Cover Sheet Vitals'; JSON: 'cprsAccess.vital.writeAccess'),
    { waWomenHealth } (Priority: 140; Item: 'Women''s Health information';
    PluralType: ptThisNone; Desc: 'Cover Sheet Women''s Health';
    JSON: 'cprsAccess.womenHealth.writeAccess'));

function TWriteAccess.ActionType(ActionCode: String): TActionType;
begin
  for Result := low(TActionType) to high(TActionType) do
    if warActionInfo[Result].Code = ActionCode then
      Exit;
  Result := atNone;
end;

procedure TWriteAccess.BeginErrors;
begin
  inc(FErrorProcessingCount);
end;

procedure TWriteAccess.CleanUpErrorText(Sender: TObject);
var
  Dlg: TForm;
  lbl: TLabel;
  line, buffer: String;
  i, j, max, minChars: Integer;
  input, output: TStringList;
begin
  Dlg := Sender as TForm;
  lbl := nil;
  for i := 0 to Dlg.ComponentCount - 1 do
    if Dlg.Components[i] is TLabel then
    begin
      lbl := TLabel(Dlg.Components[i]);
      break;
    end;
  if not Assigned(lbl) then
    Exit;
  input := nil;
  output := nil;
  try
    input := TStringList.Create;
    output := TStringList.Create;
    max := lbl.Width;
    minChars := Trunc(max / MainFontWidth) div 4;
    input.Text := lbl.Caption;
    for i := 0 to input.Count - 1 do
    begin
      line := TrimRight(input[i]);
      if line <> '' then
      begin
        buffer := '';
        while Dlg.Canvas.TextWidth(line) > max do
        begin
          while Dlg.Canvas.TextWidth(line) > max do
          begin
            j := length(line);
            while (j > minChars) and (line[j] <> ' ') do
              dec(j);
            if j > minChars then
            begin
              buffer := TrimLeft(copy(line, j, MaxInt)) + ' ' + buffer;
              line := TrimRight(copy(line, 1, j));
            end;
          end;
          if buffer <> '' then
          begin
            output.Add(line);
            line := FPad + buffer;
            buffer := '';
          end;
        end;
      end;
      output.Add(line);
    end;
    lbl.Caption := output.Text;
  finally
    output.Free;
    input.Free;
  end;
end;

constructor TWriteAccess.Create;
begin
  if Assigned(WriteAccessV) then
    raise Exception.Create('Cannot create TWriteAccess instance');
  inherited Create;
  FPad := StringOfChar(' ', ErrorIndent * 3);
end;

destructor TWriteAccess.Destroy;
begin
  FErrors.Free;
  inherited;
end;

function TWriteAccess.DGWriteAccess(IEN: Integer): TDGWriteAccess;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(FOrderAccessList) and (IEN > 0) then
    for i := 0 to FOrderAccessList.Count - 1 do
    begin
      if FOrderAccessList[i].IEN = IEN then
      begin
        Result := FOrderAccessList[i];
        Exit;
      end;
    end;
end;

function TWriteAccess.DGWriteAccess(Name: string): TDGWriteAccess;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(FOrderAccessList) and (Name <> '') then
  begin
    Name := UpperCase(Name);
    for i := 0 to FOrderAccessList.Count - 1 do
    begin
      if (FOrderAccessList[i].Name = Name) or
        (FOrderAccessList[i].ShortName = Name) then
      begin
        Result := FOrderAccessList[i];
        Exit;
      end;
    end;
  end;
end;

procedure TWriteAccess.EndErrors(SortErrors: Boolean);
begin
  if FErrorProcessingCount > 0 then
    dec(FErrorProcessingCount);
  ShowErrorMessage(SortErrors);
end;

procedure TWriteAccess.Error(warType: TWriteAccessType; ActionType: TActionType;
  ErrorMessage: String = ''; DisplayGroup: Integer = 0;
  RequireChildAccess: Boolean = False);
var
  idx: Integer;
  key: string;
  list: TWriteAccessErrorList;
  subList: TWriteAccessErrorSubList;
  errText: TStringList;
  dgObj: TDGWriteAccess;
begin
  key := IntToStr(warInfo[warType].Priority);
  idx := Errors.IndexOf(key);
  if idx < 0 then
  begin
    list := TWriteAccessErrorList.Create(True);
    list.AccessType := warType;
    list.ActionType := ActionType;
    Errors.AddObject(key, list);
  end
  else
  begin
    list := TWriteAccessErrorList(Errors.Objects[idx]);
    if (list.ActionType <> ActionType) then
      raise Exception.Create('Mutliple action types used between ' +
        'TWriteAccess.BeginError and TWriteAccess.EndError.');
  end;
  if (warType = waOrders) and (DisplayGroup <> 0) and WriteAccess(waOrders) then
  begin
    dgObj := DGWriteAccess(DisplayGroup);
    if Assigned(dgObj) then
      key := dgObj.DisplayName
    else
      key := 'Unknown Display Group (IEN:' + DisplayGroup.ToString + ')';
  end
  else
    key := '';
  idx := list.IndexOf(key);
  if idx < 0 then
  begin
    subList := TWriteAccessErrorSubList.Create(True);
    if warType = waOrders then
    begin
      subList.DisplayGroupIEN := DisplayGroup;
      subList.RequireChildAccess := RequireChildAccess;
    end;
    list.AddObject(key, subList);
  end
  else
    subList := TWriteAccessErrorSubList(list.Objects[idx]);
  if ErrorMessage = '' then
  begin
    key := '';
    if subList.IndexOf(key) < 0 then
      subList.AddObject(key, nil);
  end
  else
  begin
    errText := TStringList.Create;
    errText.Text := ErrorMessage;
    key := ErrorMessage.Replace(CRLF, '', [rfReplaceAll]);
    idx := 10001;
    while subList.IndexOf(key + idx.ToString) >= 0 do
      inc(idx);
    subList.AddObject(key + idx.ToString, errText);
  end;
  ShowErrorMessage(False);
end;

procedure TWriteAccess.Error(warType: TWriteAccessType;
  ErrorMessage: String = ''; DisplayGroup: Integer = 0;
  RequireChildAccess: Boolean = False);
begin
  Error(warType, atNone, ErrorMessage, DisplayGroup, RequireChildAccess);
end;

function TWriteAccess.Errors: TStringList;
begin
  if FErrors = nil then
    FErrors := TStringList.Create(True);
  Result := FErrors;
end;

procedure TWriteAccess.InitCPRSDisplayGroups;
var
  ClassTypes: TStringList;

  procedure LoadJSONData;
  const
    KeepUpperCase: array of string = ['Iv ', 'Ct ', 'Non-Va '];

  var
    arrayJson: TJSONArray;
    jsv1, orderJV, value: TJSONValue;
    obj: TDGWriteAccess;
    IEN, i, idx: Integer;
    cls: TDGWriteAccessClass;
    ShortName: string;

  begin
    orderJV := SystemParameters.JSONValue['cprsAccess.orders.displayGroups'];
    if orderJV = nil then
      Exit;
    arrayJson := orderJV as TJSONArray;
    for value in arrayJson do
    begin
      if value.TryGetValue('ien', jsv1) then
      begin
        IEN := StrToIntDef(jsv1.value, 0);
        if IEN > 0 then
        begin
          if value.TryGetValue('shortName', jsv1) then
          begin
            ShortName := UpperCase(jsv1.value);
            idx := ClassTypes.IndexOf(ShortName);
            if idx < 0 then
              cls := TDGWriteAccess
            else
              cls := TDGWriteAccessClass(ClassTypes.Objects[idx]);
            obj := cls.Create;
            obj.FIEN := IEN;
            if value.TryGetValue('name', jsv1) then
              obj.FName := UpperCase(jsv1.value);
            obj.FShortName := ShortName;
            obj.FDisplayName := MixedCase(obj.FName);
            for i := low(KeepUpperCase) to high(KeepUpperCase) do
              if obj.FDisplayName.StartsWith(KeepUpperCase[i]) then
              begin
                idx := length(KeepUpperCase[i]) - 1;
                obj.FDisplayName[idx] := obj.FDisplayName[idx].ToUpper;
                break;
              end;
            if value.TryGetValue('writeAccess', jsv1) then
              obj.FWriteAccess := (jsv1.value = '1');
            FOrderAccessList.Add(obj);
          end;
        end;
      end;
    end;
  end;

  procedure InitDieteticsInfo;
  const
    DietDGNames = 'DO^TF^D AO^E/L T^PREC^MEAL';
  var
    DietList: TORStringList;
    line, DG, Code, SName: string;
    i, DGIdx: Integer;
  begin
    DietList := TORStringList.Create;
    try
      GetDieteticsGroupInfo(DietList);
      if (DietList.Count < 1) or (DietList[0] <> 'DIETETICS') then
        DietList.Insert(0, 'DIETETICS');
      i := 0;
      repeat
        inc(i);
        SName := Piece(DietDGNames, U, i);
        if (SName <> '') and (DietList.IndexOfPiece(SName, U, 3) < 0) then
        begin
          if SName = 'D AO' then
            Code := 'A'
          else
            Code := SName[1];
          DGIdx := DisplayGroupByName(SName);
          if DGIdx <= 0 then
            raise Exception.Create('Dietetics Display Group ' + SName +
              ' missing from Display Group file.');
          DietList.Add(DGIdx.ToString + U + Code + U + SNAME)
        end;
      until SName = '';
      with TDGWriteAccessDietetics do
      begin
        for i := 0 to DietList.Count - 1 do
        begin
          line := DietList[i];
          if i = 0 then
            FDieteticsDisplayName := MixedCase(line)
          else
          begin
            DG := Piece(line, U, 1);
            Code := Piece(line, U, 2);
            SName := Piece(line, U, 3);
            with CodeInfo[CodeInfo.Add(TCodeInfo.Create)] do
            begin
              DisplayGroup := StrToIntDef(DG, -1);
              TabCode := Code;
            end;
            FChildren := FChildren + DG + U;
            ClassTypes.AddObject(SName, TObject(TDGWriteAccessDietetics));
          end;
        end;
      end;
    finally
      DietList.Free;
    end;
  end;

begin
  if Assigned(FOrderAccessList) then
    Exit;
  FOrderAccessList := TObjectList<TDGWriteAccess>.Create(True);
  ClassTypes := TStringList.Create;
  try
    ClassTypes.AddObject('LAB', TObject(TDGWriteAccessLab));
    ClassTypes.AddObject('AP', TObject(TDGWriteAccessLab));
    ClassTypes.AddObject('XRAY', TObject(TDGWriteAccessImaging));
    InitDieteticsInfo;
    LoadJSONData;
  finally
    ClassTypes.Free;
  end;
end;

function TWriteAccess.OrderAccess(obj: TDGWriteAccess; ActionType: TActionType;
  ShowError: Boolean; ErrorMessage: String;
  RequireChildAccess: Boolean): Boolean;
begin
  Result := True;
  if (ActionType = atAlert) and (not EHRActive) then
    Exit;
  if not WriteAccess(waOrders) then
  begin
    if ShowError then
      Error(waOrders, ActionType, ErrorMessage);
    Result := False;
    Exit;
  end;
  if ActionType = atAlert then
    Exit;
  if Assigned(obj) then
  begin
    RequireChildAccess := RequireChildAccess and (obj is TDGWriteAccessParent);
    if RequireChildAccess then
      Result := TDGWriteAccessParent(obj).ChildWriteAccess
    else
      Result := obj.WriteAccess;
    if (not Result) and ShowError then
      Error(waOrders, ActionType, ErrorMessage, obj.IEN, RequireChildAccess);
  end;
end;

procedure TWriteAccess.ShowErrorMessage(SortErrors: Boolean);
const
  TX_NO_WRITE_ACCESS = 'you do not have write-access to %s.';
  TX_NO_VALID_GROUPS =
    'there are no active orderable items for this order dialog.';
var
  i, j, k, l: Integer;
  Text, ItemDesc, ActionDesc, OrderTypeText, AccessText: string;
  header, lastHeader, s1, s2, s3, indent: string;
  list: TWriteAccessErrorList;
  subList: TWriteAccessErrorSubList;
  errList: TStringList;
  info: TWriteAccessInfo;
  Features: TVAInfoDialog.TFeatures;
  plural, warError, genError: Boolean;
  dgObj: TDGWriteAccess;
  btnCaptions: TVAInfoDialog.TStringArray;
  OnClicks: TVAInfoDialog.TEventArray;
begin
  if (FErrorProcessingCount > 0) or (not Assigned(FErrors)) or
    (FErrors.Count = 0) then
    Exit;
  try
    if FIgnorelErrors then
    begin
      FErrors.Clear;
      FIgnorelErrors := False;
      Exit;
    end;
    if SortErrors then
      FErrors.Sort;
    Text := '';
    lastHeader := '';
    warError := False;
    for i := 0 to FErrors.Count - 1 do
    begin
      list := Errors.Objects[i] as TWriteAccessErrorList;
      if list.Count = 0 then
        continue;
      if SortErrors then
        list.Sort;
      info := warInfo[list.AccessType];
      for j := 0 to list.Count - 1 do
      begin
        subList := list.Objects[j] as TWriteAccessErrorSubList;
        if SortErrors then
          subList.Sort;
        genError := (list.ActionType = atNone) and (subList[j] = '') and
          (not Assigned(subList.Objects[j]));
        if genError and (list.AccessType = waOrders) and
          (subList.DisplayGroupIEN <> 0) then
          genError := False;
        if genError then
        begin
          header := Format(TX_NO_WRITE_ACCESS, [info.Desc]);
          warError := True;
        end
        else
        begin
          ItemDesc := info.Item;
          plural := (subList.Count > 1);
          case info.PluralType of
            ptNormal:
              if plural then
                ItemDesc := ItemDesc + 's';
            ptYies:
              if plural then
                ItemDesc := ItemDesc + 'ies'
              else
                ItemDesc := ItemDesc + 'y';
          end;
          if plural and (info.PluralType <> ptThisNone) then
          begin
            s1 := 'these';
            s2 := '';
            s3 := 's';
          end
          else
          begin
            s1 := 'this';
            s2 := 's';
            s3 := '';
          end;
          ActionDesc := Format(warActionInfo[list.ActionType].Desc,
            [s1, s2, s3]);
          ActionDesc := 'you cannot ' + ActionDesc + ' because ';
          if (list.AccessType = waOrders) and (subList.DisplayGroupIEN <> 0)
          then
            dgObj := DGWriteAccess(subList.DisplayGroupIEN)
          else
            dgObj := nil;
          if Assigned(dgObj) then
          begin
            if subList.RequireChildAccess and (dgObj is TDGWriteAccessParent)
            then
            begin
              OrderTypeText := TDGWriteAccessParent(dgObj)
                .ParentDisplayName + ' ';
              AccessText := TDGWriteAccessParent(dgObj).MissingGroups;
            end
            else
            begin
              OrderTypeText := '';
              AccessText := dgObj.DisplayName;
            end;
            if AccessText = '' then
              header := Format(ActionDesc + TX_NO_VALID_GROUPS,
                [OrderTypeText + ItemDesc])
            else
            begin
              header := Format(ActionDesc + TX_NO_WRITE_ACCESS,
                [OrderTypeText + ItemDesc, AccessText]);
              warError := True;
            end;
          end
          else
          begin
            header := Format(ActionDesc + TX_NO_WRITE_ACCESS,
              [ItemDesc, info.Desc]);
            warError := True;
          end;
        end;
        header[1] := header[1].ToUpper;
        if (header <> lastHeader) then
        begin
          if Text <> '' then
            Text := Text + CRLF + CRLF;
          Text := Text + header + FPad;
          lastHeader := header;
        end;
        for k := 0 to subList.Count - 1 do
        begin
          if Assigned(subList.Objects[k]) then
          begin
            errList := subList.Objects[k] as TStringList;
            if Assigned(errList) then
            begin
              indent := StringOfChar(' ', ErrorIndent);
              for l := 0 to errList.Count - 1 do
              begin
                Text := Text + CRLF + indent + TrimLeft(errList[l] + FPad);
                if l = 0 then
                  indent := indent + indent;
              end;
            end;
          end;
        end;
      end;
    end;
    if warError then
    begin
      Text := Text + CRLF + CRLF + TrimLeft(SystemErrorText);
      btnCaptions := ['', 'Write Access Permissions'];
      OnClicks := [NilNotifyEvent, ShowPermissions];
      Features.DialogButtonSizing := dbsAuto;
    end
    else
    begin
      btnCaptions := [];
      OnClicks := [];
      Features.DialogButtonSizing := dbsNormal;
    end;
    Features.OnBeforeShow := CleanUpErrorText;
    TVAInfoDialog.Show(Text, 'Write Access Error', mtError, [mrOK], Features,
      btnCaptions, OnClicks);
  finally
    FErrors.Clear;
  end;
end;

procedure TWriteAccess.IgnoreErrors;
begin
  FIgnorelErrors := True;
end;

procedure TWriteAccess.ShowPermissions(Sender: TObject);
var
  sl: TStringList;

begin
  sl := TStringList.Create;
  try
    CallVista('ORACCESS GETNOTES', [User.DUZ], sl);
    ReportBox(sl, 'Write Access Permissions', True);
  finally
    sl.Free;
  end;
end;

function TWriteAccess.SystemErrorText: string;
begin
  if FSystemErrorText = '' then
    FSystemErrorText := SystemParameters.AsType<string>
      ('cprsAccess.errorMessage');
  Result := FSystemErrorText;
end;

function TWriteAccess.WriteAccess(warType: TWriteAccessType;
  ShowError: Boolean = False; ErrorMessage: String = ''): Boolean;
begin
  Result := WriteAccess(warType, atNone, ShowError, ErrorMessage);
end;

function TWriteAccess.WriteAccess(warType: TWriteAccessType;
  ActionType: TActionType; ShowError: Boolean = False;
  ErrorMessage: String = ''): Boolean;
begin
  if FLoaded[warType] then
    Result := FAccess[warType]
  else
  begin
    if warType = waNone then
    begin
      Result := True;
      FLoaded[warType] := True;
      FAccess[warType] := True;
    end
    else
      Result := (SystemParameters.AsTypeDef<string>(warInfo[warType].JSON,
        '') = '1');
    FAccess[warType] := Result;
    FLoaded[warType] := True;
  end;
  if (not Result) and ShowError then
    Error(warType, ActionType, ErrorMessage);
end;

{ TWriteAccess.TDGWriteAccess }

constructor TWriteAccess.TDGWriteAccess.Create;
begin
end;

{ TWriteAccess.TDGWriteAccessParent }

constructor TWriteAccess.TDGWriteAccessParent.Create;
begin
  inherited;
  FDoBuild := True;
end;

procedure TWriteAccess.TDGWriteAccessParent.EnsureBuild;
begin
  if FDoBuild then
  begin
    Build;
    FDoBuild := False;
  end;
end;

function TWriteAccess.TDGWriteAccessParent.GetChildWriteAccess: Boolean;
begin
  EnsureBuild;
  Result := FChildWriteAccess;
end;

function TWriteAccess.TDGWriteAccessParent.GetParentDisplayName: string;
begin
  Result := FDisplayName;
end;

procedure TWriteAccess.TDGWriteAccessParent.UpdateAccessData
  (obj: TDGWriteAccess);
begin
end;

procedure TWriteAccess.TDGWriteAccessParent.UpdateChildFields(children: string);
var
  p, DG, i: Integer;
  missing, found: TStringList;
  obj: TDGWriteAccess;

begin
  missing := TStringList.Create;
  found := TStringList.Create;
  try
    FChildWriteAccess := False;
    FAccessData := '';
    FAccessGroups := '';
    FMissingGroups := '';
    p := 1;
    repeat
      DG := StrToIntDef(Piece(children, U, p), 0);
      if DG > 0 then
      begin
        obj := WriteAccessV.DGWriteAccess(DG);
        if Assigned(obj) then
        begin
          if obj.WriteAccess then
          begin
            FChildWriteAccess := True;
            UpdateAccessData(obj);
            found.Add(obj.DisplayName);
          end
          else
            missing.Add(obj.DisplayName);
        end;
        inc(p);
      end;
    until (DG = 0);
    UpdateAccessData(nil);
    if found.Count > 0 then
    begin
      found.Sort;
      for i := 0 to found.Count - 1 do
      begin
        if i > 0 then
        begin
          if i < (found.Count - 1) then
            FAccessGroups := FAccessGroups + ', '
          else
            FAccessGroups := FAccessGroups + ' and ';
        end;
        FAccessGroups := FAccessGroups + found[i];
      end;
    end;
    if missing.Count > 0 then
    begin
      missing.Sort;
      for i := 0 to missing.Count - 1 do
      begin
        if i > 0 then
        begin
          if i < (missing.Count - 1) then
            FMissingGroups := FMissingGroups + ', '
          else
            FMissingGroups := FMissingGroups + ' or ';
        end;
        FMissingGroups := FMissingGroups + missing[i];
      end;
      FMissingGroups := FMissingGroups + '.';
    end;
  finally
    found.Free;
    missing.Free;
  end;
end;

{ TWriteAccess.TDGWriteAccessLab }

procedure TWriteAccess.TDGWriteAccessLab.Build;
var
  p: Integer;
  used, Code, children: string;
  obj: TDGWriteAccess;

begin
  used := GetGroupsUsedByXRef(ShortName);
  children := '';
  p := 1;
  repeat
    Code := Piece(FLabGroups, U, p);
    if (Code <> '') and (pos(U + Code + U, used) > 0) then
    begin
      obj := WriteAccessV.DGWriteAccess(Code);
      if Assigned(obj) then
        children := children + IntToStr(obj.IEN) + U;
    end;
    inc(p);
  until (Code = '');
  UpdateChildFields(children);
end;

constructor TWriteAccess.TDGWriteAccessLab.Create;

  procedure InitLabGroups;
  var
    info: TStringList;
    p: Integer;
    temp, Code: string;

  begin
    if FLabGroups <> '' then
      Exit;
    info := TStringList.Create;
    try
      GetDDAttributes(info, 101.43, 60.6, '', 'POINTER');
      if (info.Count > 0) and (Piece(info[0], U, 1) = 'POINTER') then
      begin
        temp := Piece(info[0], U, 2);
        p := 1;
        repeat
          Code := Piece(Piece(temp, ';', p), ':', 1);
          if (Code <> '') then
            FLabGroups := FLabGroups + Code + U;
          inc(p)
        until (Code = '');
      end;
    finally
      info.Free;
    end;
  end;

begin
  inherited;
  InitLabGroups;
end;

procedure TWriteAccess.TDGWriteAccessLab.UpdateAccessData(obj: TDGWriteAccess);
begin
  FAccessData := FAccessData + U;
  if Assigned(obj) then
    FAccessData := FAccessData + obj.ShortName;
end;

{ TWriteAccess.TDGWriteAccessImaging }

procedure TWriteAccess.TDGWriteAccessImaging.Build;
var
  children: string;
  info: TStringList;
  i: Integer;

begin
  info := TStringList.Create;
  try
    children := '';
    SubsetOfImagingTypes(info, False);
    for i := 0 to info.Count - 1 do
      children := children + Piece(info[i], U, 4) + U;
  finally
    info.Free;
  end;
  UpdateChildFields(children);
end;
{ TWriteAccess.TDGWriteAccessDietetics }

procedure TWriteAccess.TDGWriteAccessDietetics.Build;
var
  i: Integer;

begin
  FTabCode := '';
  for i := 1 to CodeInfo.Count - 1 do
    if FIEN = CodeInfo[i].DisplayGroup then
    begin
      FTabCode := CodeInfo[i].TabCode;
      break;
    end;
  UpdateChildFields(FChildren);
end;

class constructor TWriteAccess.TDGWriteAccessDietetics.Create;
begin
  CodeInfo := TObjectList<TCodeInfo>.Create(True);
end;

class destructor TWriteAccess.TDGWriteAccessDietetics.Destroy;
begin
  CodeInfo.Free;
end;

function TWriteAccess.TDGWriteAccessDietetics.GetParentDisplayName: string;
begin
  Result := FDieteticsDisplayName;
end;

function TWriteAccess.TDGWriteAccessDietetics.GetTabCode: string;
begin
  EnsureBuild;
  Result := FTabCode;
end;

function WriteAccess(warType: TWriteAccessType; ShowError: Boolean = False;
  ErrorMessage: String = ''): Boolean;
begin
  Result := WriteAccessV.WriteAccess(warType, ShowError, ErrorMessage);
end;

function WriteAccess(warType: TWriteAccessType; ActionType: TActionType;
  ShowError: Boolean = False; ErrorMessage: String = ''): Boolean;
begin
  Result := WriteAccessV.WriteAccess(warType, ActionType, ShowError,
    ErrorMessage);
end;

initialization

WriteAccessV := TWriteAccess.Create;

finalization

FreeAndNil(WriteAccessV);

end.
