unit uOrderFlag;

{ Order Flag Info object }
{ ------------------------------------------------------------------------------
  Update History
  2016-05-17: NSR#20110719 (Order Flag Recommendations)
  ------------------------------------------------------------------------------- }
interface

uses
  rOrders, ORFn, System.Classes, Windows;

type
  TActionMode = (amUnknown, amAdd, amRemove, amEdit);

  TOrderFlag = class(TCollectionItem)
  private
    fOFStatus: Integer;
    fOFStatusInfo: String;
    fFlagSetStatus: Integer;

    function getOFStatus: Integer;
  public
    Order: TOrder;
    Description: String;
    Details: String;
    Reason: String;

    ExpiresMin,
    Expires: TDateTime;

    FlagComments: TStrings;
    Recipients: TStrings;
    RecipientsNew: TStrings;
    Tag: Integer;

    bRequiredReason: Boolean;
    bRequiredRecipients: Boolean;
    bRequiredExpires: Boolean;
    bRequiredComment: Boolean;

    constructor FlagInfoCreate(aCollection: TCollection);
    constructor FlagInfoCreateDefault;
    destructor Destroy; override;
    procedure SetByOrder(anOrder: TOrder);
    procedure deleteRecepient(aName: String);
    property OFStatusInfo: String read fOFStatusInfo write fOFStatusInfo;
    property OFStatus: Integer read getOFStatus write fOFStatus;
    property OFSetStatus: Integer read fFlagSetStatus write fFlagSetStatus;

    function FlagInfoSave:String;
    function FlagInfoRemove:String;
    function FlagInfoUpdate:String;

    function IsValid(var sError:String):Boolean;
  end;

const
  iMinTextLength = 4;
  stOFUnknown = -1;
  stOFNew = 0;
  stOFInvalid = 0;
  stOFValid = 1;
  stOFProcessed = 2;
  stOFError = 3;
  stOFNA = 4;

  ofssNotSet = 0;  // Order Flag: NOT SET
  ofssSet = 1;     // Order Flag:     SET

  ssSuccess = '1';
  ssError = '0';

  ordDivider = '----------------------------------------'+ CRLF;

procedure getOrderFlagInfoList(OrderList, FlagList: TStrings);
function getOrderFlagExpireDefault:TDateTime;

implementation

uses
  System.RegularExpressions,
  System.SysUtils, Dialogs, rCore, ORDtTm;

var
  InfoCollection: TCollection;

procedure getOrderFlagInfoList(OrderList, FlagList: TStrings);
var
  i: Integer;
  ord: TOrder;
  FlagInfo: TOrderFlag;

begin
  if (not assigned(OrderList)) or (not assigned(FlagList)) then
    exit;
  FlagList.Clear;
  for i := 0 to OrderList.Count - 1 do
  begin
    ord := TOrder(OrderList.Objects[i]);
    if assigned(ord) then
    begin
      FlagInfo := TOrderFlag.FlagInfoCreateDefault; // (OrdersToProcess);
      FlagInfo.SetByOrder(ord);
      FlagInfo.Tag := StrToIntDef(piece(OrderList[i], U, 1), -1);
      FlagList.AddObject(FlagInfo.Description, FlagInfo);
    end;
  end;
end;

function getOrderFlagExpireDefault:TDateTime;
var
  s: string;
begin
  s := GetUserParam('OR FLAG ORDER EXPIRE DEFAULT');
  Result := StrToFloatDef(s, 24.0) / 24.0;
  Result := Now + Result;
end;

////////////////////////////////////////////////////////////////////////////////

constructor TOrderFlag.FlagInfoCreate(aCollection: TCollection);
begin
  inherited Create(aCollection);
  FlagComments:= TStringList.Create;
  Recipients := TStringList.Create;
  RecipientsNew := TStringList.Create;

  bRequiredReason := True;
  bRequiredRecipients := True;
  bRequiredExpires := True;
  bRequiredComment := True;

  fOFStatus := stOFNew;
end;

constructor TOrderFlag.FlagInfoCreateDefault;
begin
  if not assigned(InfoCollection) then
    InfoCollection := TCollection.Create(TOrderFlag);
  FlagInfoCreate(InfoCollection);
end;

destructor TOrderFlag.Destroy;
begin
  FlagComments.Free;
  Recipients.Free;
  RecipientsNew.Free;
  inherited;
end;

procedure TOrderFlag.SetByOrder(anOrder: TOrder);

  function getFMDTString(aDT: String; aBlank: String = ''): String;
  begin
    if aDT = '' then
      Result := aBlank
    else if IsNow(aDT) then
      Result := FormatFMDateTime('MMM-dd-YYYY', FMNow)
    else if isFMDateTime(aDT) then
      try
        Result := FormatFMDateTime('MMM-dd-YYYY', StrToFloat(aDT));
      except
        Result := aDT; // Blank;
      end
    else
      Result := aDT;
  end;

  function getOrderFlagComments: String;
  var
    SL: TStringList;

    procedure FormatComments;
    var
      sComments: TStringList;
      s: String;
      i: integer;
      bCommentHeader: Boolean;
    const
      COMMENT_BEGIN = '<COMMENT>';
      COMMENT_END = '</COMMENT>';
    begin
      bCommentHeader := False;
      sComments := TStringList.Create;
      for i := 0 to SL.Count - 1 do
        begin
          s := SL[i];

          if pos(COMMENT_BEGIN,s) = 1 then
            bCommentHeader := True
          else if pos(COMMENT_END,s)<> 1 then
            begin
              if bCommentHeader then
                begin
                  bCommentHeader := false;
                  sComments.Add(char(VK_TAB) +
                    piece(piece(s,'^',1),';',2) + ' - ' +
                    piece(piece(s,'^',2),';',2) + ':');
                  s := piece(s,'^',3);
                  if trim(s) <> '' then
                    sComments.Add(char(VK_TAB) + s + CRLF);
                end
              else
                sComments.Add(char(VK_TAB) + s);
            end;
        end;
      SL.Text := sComments.Text;
      sComments.Free;
    end;

  begin
    SL := TStringList.Create;
    try
      getFlagComponents(SL,Order.ID,'COMMENTS');
      FormatComments;
    except
      on E: Exception do
        SL.Text := 'getFlagComments error:' + CRLF + E.Message;
    end;
    Result := SL.Text;
    if assigned(SL) then
      SL.Free;
  end;

  function getOrderFlagRecipients: String;
  var
    SL: TStringList;

    procedure FormatRecipients;
    var
      i: integer;
    begin
      for i := 0 to SL.Count - 1 do
        SL[i] := char(VK_TAB) + piece(SL[i],'^',2);
    end;

  begin
    Result := '';
    if not Order.Flagged then
      exit;
    SL := TStringList.Create;
    try
      getFlagComponents(SL,Order.ID, 'RECIPIENTS');
      Recipients.Assign(SL);  // - assign values
      FormatRecipients;
      Result := SL.Text;
      if trim(Result) <> '' then
        Result := 'Recipients:' + CRLF + Result;
    except
      on E: Exception do
        Result := '';
    end;
    if assigned(SL) then
      SL.Free;
  end;

  function getFlagComments: String;
  var
    s: String;
  begin
    Result := '';
    if Order.Flagged then
    begin
      s := getOrderFlagComments;
      if trim(s) <> '' then
        Result := 'Flag Comments:' + CRLF + s;
    end
    else
      Result := '';
  end;

  function getFlagStatus: String;
  begin
    if Order.Flagged then
    begin
      Result := 'True';
    end
    else
      Result := 'False';
  end;

  function getFlagInfo:String;
  var
    SL: TStringList;
  begin
    SL := TStringList.Create;
    try
      getFlagComponents(SL,Order.ID, 'ALL');
      Result := SL.Text;
    except
      on E: Exception do
        Result := '';
    end;
    if assigned(SL) then
      SL.Free;
  end;

  function getStartStopDates:String;
  var
    s: String;
  begin
    s :=  getFMDTString(Order.StopTime);
    if s <> '' then
      Result := 'Start/Stop:'+ getFMDTString(Order.StartTime) + '/'+s
    else
      Result := 'Start:'+Char(VK_TAB)+ getFMDTString(Order.StartTime);
   end;

  function getFlagStatusText:String;
  begin
    if Order.ParkedStatus <> '' then // NSR#20090509 AA 2015/09/29
      Result := Order.ParkedStatus
    else
      Result := NameOfStatus(Order.Status); // PaPI --?
  end;

var
  AFlagInfo, AOrderFlagRecipients, AFlagComments, AFlagCommentsTime, S, T: string;
  AMatch: TMatch;
begin
  Order := anOrder;
  if assigned(Order) then
  begin
    AFlagInfo := getFlagInfo;
    // The below code extracts Recipients and Comments from AFlagInfo
    AOrderFlagRecipients := Copy(AFlagInfo, 1, Pos('<COMMENT>', AFlagInfo) - 1);
    AFlagComments := '';
    // The following line just grabs everything between and including the
    // <comment> and </comment> tags and stores it in a Match object.
    // (?..): directive
    //   s: Include "special characters" in the definition of "any character" when the . is used, for instance in (.*).
    //   i: Ignore case in all matching.
    // (..): a set
    //   .: any character
    //   *: previous character 0 or more times, greedy
    //   ?: makes the .* non-greedy (match as little as possible)
    AMatch := TRegEx.Match(AFlagInfo, '(?si)<COMMENT>(.*?)</COMMENT>');
    while AMatch.Value <> '' do begin
      // (?<=..): Lookbehind assertion, match the set after this only if preceded by..
      // (?=..): Lookahead assertion, match the set before this only if followed by..
      // The following line just grabs everything between the <comment> and </comment> tags
      S := TRegEx.Match(AMatch.Value, '(?si)(?<=<COMMENT>).*(?=</COMMENT>)').Value;
      AFlagCommentsTime := Piece(Piece(S, U, 1), ';', 2); // Gets the time
      S := Piece(S, U, 2); // Reduces FlagComments to the second piece
      S := TRegEx.Match(S, '(?si)(?<=;).*').Value; // Get everything after the semicolon
      AFlagComments := Trim(Format('%s'#13#10#13#10'%s - %s', [AFlagComments, AFlagCommentsTime, S]));
      AMatch := AMatch.NextMatch;
    end;
    S := AOrderFlagRecipients;
    AOrderFlagRecipients := '';
    while S <> '' do begin
      T := TRegEx.Match(S + #13#10, '.*').Value; // Get the first line
      S := TRegEx.Match(S, '(?s)(?<='#13#10').*').Value; // Get the rest
      AOrderFlagRecipients := Format('%s'#13#10'%s', [AOrderFlagRecipients, Piece(T, U, 2)]); // Add the second piece to the string;
    end;
    AOrderFlagRecipients := Trim(AOrderFlagRecipients);
    // The above code extracts Recipients and Comments from AFlagInfo

    if AOrderFlagRecipients <> '' then
      AOrderFlagRecipients := 'Recipients:'#13#10#9 + StringReplace(AOrderFlagRecipients, #13#10, #13#10#9, [rfReplaceAll]);
    if AFlagComments <> '' then
      AFlagComments := 'Flag Comments:'#13#10#9 + StringReplace(AFlagComments, #13#10, #13#10#9, [rfReplaceAll]);

    Details := Order.Text + CRLF + CRLF+
      'Provider:' + Char(VK_TAB) + Order.ProviderName + CRLF +
      'Location:' + Char(VK_TAB) + Order.OrderLocName + CRLF +
      getStartStopDates + CRLF +
      'Status:' + Char(VK_TAB) + getFlagStatusText + CRLF +
      'Group:' + Char(VK_TAB) + NameOfDGroup(Order.DGroup) + CRLF +
      AOrderFlagRecipients + CRLF +
      AFlagComments;
    Description := Order.Text;

    if Order.Flagged then
    begin
      OFStatus := stOFProcessed;
      OFStatusInfo := piece(Description, U, 3);
      OFSetStatus := ofssSet;
    end
    else
    begin
      OFStatus := stOFNew;
      OFStatusInfo := piece(Description, U, 3);
      OFSetStatus := ofssNotSet;
    end;
  end;
end;

procedure TOrderFlag.deleteRecepient(aName: String);
var
  i: Integer;
begin
  i := Recipients.IndexOf(aName);
  if i > -1 then
    Recipients.Delete(i);
end;

function TOrderFlag.getOFStatus: Integer;
var
  Err:String;
begin
  isValid(Err);
  Result := fOFStatus;
end;

function TOrderFlag.IsValid(var sError:String):Boolean;
var
  b: Boolean;
  s: String;

  procedure AppendString(var sResult: String; aCondition: Boolean;
    sComment: String);
  begin
    if aCondition then
    begin
      if sResult <> '' then
        sResult := sResult + CRLF;
      sResult := sResult + sComment;
    end;
  end;

  function isExpiredDateValid: Boolean;
  begin
    Result := Expires >  FMDateTimeToDateTime(FMNow);
  end;

begin

  b := True;
  s := '';
  if bRequiredReason then
  begin
    b := b and (Reason <> '');
    AppendString(s, Reason = '', 'Reason is not defined');
  end;
  if bRequiredExpires or (Expires > 0.0) then
  begin
    b := b and isExpiredDateValid;
    AppendString(s, not isExpiredDateValid, 'Date "' +
      FormatDateTime('MMM-dd-YYYY hh:mm', Expires) +
      '" is not valid or in the past');
  end;

  if bRequiredRecipients then
  begin
    b := b and (Recipients.Count > 0);
    AppendString(s, Recipients.Count = 0, 'Recipients are not defined');
  end;

  if bRequiredComment then
  begin
    b := b and (Length(Trim(FlagComments.Text)) >= iMinTextLength);
    AppendString(s, Length(Trim(FlagComments.Text)) >=iMinTextLength, 'No comments provided');
  end;

  if b then
  begin
    fOFStatus := stOFValid;
    fOFStatusInfo := 'Ready for processing'; // Order.ID;
  end
  else
  begin
    fOFStatus := stOFInvalid;
    fOFStatusInfo := trim(s);
  end;
  Result := b;

  sError := s;
end;

function TOrderFlag.FlagInfoSave: String;
// saving new flag
var
  SL: TStrings;
  sDate: String;
begin
  if not IsValid(Result) then
  begin
    OFSetStatus := ofssNotSet;
    OFStatusInfo := Result;
    Result := ssError + U + OFStatusInfo;
  end else begin
    if Expires > 0.0 then sDate := FloatToStr(DateTimeToFMDateTime(Expires))
    else sDate := '';
    SL := TStringList.Create;
    try
      getFlagOrderResults(Order, Reason, sDate, Recipients, SL);
      if pos('ERROR', UpperCase(SL.Text)) > 0 then
      begin
        Result := SL.Text;
        if Order.Flagged then
          OFSetStatus := ofssSet
        else
          OFSetStatus := ofssNotSet;
      end else begin
        setOrderFromResults(Order, SL);
        OFSetStatus := ofssSet;
        OFStatusInfo := 'Flag SET: OK (' + Description + ')';
        Result := ssSuccess + U + OFStatusInfo;
      end;
    finally
      SL.Free;
    end;
  end;

  OFStatus := stOFProcessed;
end;

function TOrderFlag.FlagInfoRemove: String;
// removing flag
var
  S: string;
  SL: TStrings;
  sError:String;
begin
  S := FlagComments.Text;
  if Copy(S, Length(S)-1, 2) = CRLF then
    S := Copy(S, 1, Length(S) - 2); // Stripping off the CRLF if it is there (VISTAOR-23685)
  SL := unFlagOrder(Order, S, sError);
  try
    if sError = '' then
    begin
      setOrderFromResults(Order,SL);
      OFSetStatus := ofssNotSet;
      OFStatusInfo := 'Flag REMOVED: OK (' + Description + ')';
      Result := ssSuccess + U + OFStatusInfo;
    end else begin
      Result := sError;
      if Order.Flagged then
        OFSetStatus := ofssSet
      else
        OFSetStatus := ofssNotSet;
    end;
  finally
    FreeAndNil(SL);
  end;
  OFStatus := stOFProcessed;
end;

function TOrderFlag.FlagInfoUpdate: String;
var
  s: String;
  slResult:TStrings;

  function Success(aResult:TStrings):Boolean;
  begin
    Result := pos('0^Error',aResult.Text) <> 1;
  end;

  procedure ProcessError(aList:TStrings);
{
    LST(1)="0^Error adding Comments "
    LST(1)="0^Error adding recipient "_117
    LST(1)="1^Comments successfully added."
}
  var
    bFound: Boolean;
    i: Integer;
    s,
    sPrefix,
    sError,
    sRecipient:String;
  begin
    sPrefix := piece(aList.Text,U,1);
    if sPrefix <> '0' then
      begin
        sError := piece(aList.Text,U,2);
        sRecipient := piece(sError,' ',4);
        bFound := pos(UpperCase(sError),'COMMENT') > 0;
        i := 0;
        // removing all Recipients  starting with the one in the error list
        // remove all if comments were not added
        while i < RecipientsNew.Count do
          if bFound then
            RecipientsNew.Delete(i)
          else
            begin
              s := piece(RecipientsNew[i],U,4);
              bFound := s = sRecipient;
              if bFound then
                RecipientsNew.Delete(i)
            end;
      end;
  end;

begin
  slResult := TStringList.Create;
  setFlagComments(Order.ID,FlagComments,RecipientsNew,slResult);

  if Success(slResult) then
    begin
      for s in RecipientsNew do
        Recipients.Add(s);
      OFStatusInfo := 'Flag UPDATE: OK (' + Description + ')';
      Result := ssSuccess + U + OFStatusInfo;
    end
  else
    begin
      Result := slResult.Text;
      ProcessError(slResult);
      for s in RecipientsNew do  // add all that were processed successfully
        Recipients.Add(s);
    end;

  if Order.Flagged then
    OFSetStatus := ofssSet
  else
    OFSetStatus := ofssNotSet;

  RecipientsNew.Clear;

  OFStatus := stOFProcessed;

  slResult.Free;
end;

initialization

finalization

if assigned(InfoCollection) then
  InfoCollection.Free;

end.
