unit uODBase;

interface

uses
  Classes, ORFn, uConst;

{ Order Checking }
function AddFillerAppID(const AnID: string): Boolean;
procedure ClearFillerAppList;

{ Ordering Environment }
procedure SetOrderFormIDOnCreate(AFormID: Integer);
function OrderFormIDOnCreate: Integer;
procedure SetOrderEventTypeOnCreate(AType: Char);
function OrderEventTypeOnCreate: Char;
procedure SetOrderEventIDOnCreate(AnEvtID: integer);
function OrderEventIDOnCreate: integer;
procedure SetOrderEventNameOnCreate(AnEvtNm: string);
function OrderEventNameOnCreate: string;

//CQ 20854 - Display Supplies Only - JCS
procedure SetOrderFormDlgIDOnCreate(AnID: String);
function OrderFormDlgIDOnCreate: String;

function GetKeyVars: string;
procedure PopKeyVars(NumLevels: Integer = 1);
procedure PushKeyVars(const NewVals: string);
procedure ExpandOrderObjects(var Txt: string; out ContainsObjects: boolean; msg: string = '');
procedure CheckForAutoDCDietOrders(EvtID: integer; DispGrp: integer; CurrentText: string;
            var CancelText: string; Sender: TObject; tubefeeding: boolean = false);

implementation

uses
  dShared, Windows, rTemplates, SysUtils, StdCtrls, fOrders, rOrders, uCore;

var
  uOrderEventType: Char;
  uOrderEventID: Integer;
  uOrderEventName: string;
  uOrderFormID: Integer;
  uFillerAppID: TStringList;
  uKeyVarList:  TStringList;
  //CQ 20854 - Display Supplies Only - JCS
  uOrderEventDlgID: String;


{ Order Checking }

function AddFillerAppID(const AnID: string): Boolean;
begin
  Result := False;
  if uFillerAppID.IndexOf(AnID) < 0 then
  begin
    Result := True;
    uFillerAppID.Add(AnID);
  end;
end;

procedure ClearFillerAppList;
begin
  uFillerAppID.Clear;
end;

{ Ordering Environment }

procedure SetOrderFormIDOnCreate(AFormID: Integer);
begin
  uOrderFormID := AFormID;
end;

function OrderFormIDOnCreate: Integer;
begin
  Result := uOrderFormID;
end;

procedure SetOrderEventTypeOnCreate(AType: Char);
begin
  uOrderEventType := AType;
end;

function OrderEventTypeOnCreate: Char;
begin
  Result := uOrderEventType;
end;

procedure SetOrderEventIDOnCreate(AnEvtID: Integer);
begin
  uOrderEventID := AnEvtID;
end;

procedure SetOrderEventNameOnCreate(AnEvtNm: string);
begin
  uOrderEventName := AnEvtNm;
end;

function OrderEventNameOnCreate: string;
begin
  Result := uOrderEventName;
end;

function OrderEventIDOnCreate: integer;
begin
  Result := uOrderEventID;
end;

//CQ 20854 - Display Supplies Only - JCS
procedure SetOrderFormDlgIDOnCreate(AnID: String);
begin
  uOrderEventDlgID := AnID;
end;

//CQ 20854 - Display Supplies Only - JCS
function OrderFormDlgIDOnCreate: String;
begin
  Result :=uOrderEventDlgID;
end;

function GetKeyVars: string;
begin
  Result := '';
  with uKeyVarList do if Count > 0 then Result := Strings[Count - 1];
end;

procedure PopKeyVars(NumLevels: Integer = 1);
begin
  with uKeyVarList do while (NumLevels > 0) and (Count > 0) do
  begin
    Delete(Count - 1);
    Dec(NumLevels);
  end;
end;

procedure PushKeyVars(const NewVals: string);
var
  i: Integer;
  x: string;
begin
  if uKeyVarList.Count > 0 then x := uKeyVarList[uKeyVarList.Count - 1] else x := '';
  for i := 1 to MAX_KEYVARS do
    if Piece(NewVals, U, i) <> '' then SetPiece(x, U, i, Piece(NewVals, U, i));
  uKeyVarList.Add(x);
end;

procedure ExpandOrderObjects(var Txt: string; out ContainsObjects: boolean; msg: string = '');
var
  ObjList: TStringList;
  Err: TStringList;
  i, j, k, oLen: integer;
  obj, ObjTxt: string;
const
  CRDelim = #13;
  TC_BOILER_ERR  = 'Order Boilerplate Object Error';
  TX_BOILER_ERR  = 'Contact IRM and inform them about this error.' + CRLF +
                   'Make sure you give them the name of the quick' + CRLF +
                   'order that you are processing.' ;
begin
  ContainsObjects := False;
  ObjList := TStringList.Create;
  try
    Err := nil;
    if(not dmodShared.BoilerplateOK(Txt, CRDelim, ObjList, Err)) and (assigned(Err)) then
    begin
      try
        Err.Add(CRLF + TX_BOILER_ERR);
        InfoBox(Err.Text, TC_BOILER_ERR, MB_OK + MB_ICONERROR);
      finally
        Err.Free;
      end;
    end;
    if(ObjList.Count > 0) then
    begin
      ContainsObjects := True;
      GetTemplateText(ObjList, Encounter.VisitStr);
      i := 0;
      while (i < ObjList.Count) do
      begin
        if(pos(ObjMarker, ObjList[i]) = 1) then
        begin
          obj := copy(ObjList[i], ObjMarkerLen+1, MaxInt);
          if(obj = '') then break;
          j := i + 1;
          while (j < ObjList.Count) and (pos(ObjMarker, ObjList[j]) = 0) do
            inc(j);
          if((j - i) > 2) then
          begin
            ObjTxt := '';
            for k := i+1 to j-1 do
              ObjTxt := ObjTxt + #13 + ObjList[k];
          end
          else
            ObjTxt := ObjList[i+1];
          i := j;
          obj := '|' + obj + '|';
          oLen := length(obj);
          repeat
            j := pos(obj, Txt);
            if(j > 0) then
            begin
              delete(Txt, j, OLen);
              insert(ObjTxt, Txt, j);
            end;
          until(j = 0);
        end
        else
          inc(i);
      end
    end;
  finally
    ObjList.Free;
  end;
end;

// Check for diet orders that will be auto-DCd on release because of start/stop overlaps.
// Moved here for visibility because it also needs to be checked on an auto-accept order.
procedure CheckForAutoDCDietOrders(EvtID: integer; DispGrp: integer; CurrentText: string;
            var CancelText: string; Sender: TObject; tubefeeding: boolean = false);
const
  TX_CX_CUR = 'A new diet order will CANCEL and REPLACE this current diet now unless ' +
              'you specify a start date for when the new diet should replace the current diet' +
               CRLF + CRLF;
  TX_CX_FUT = 'A new diet order with no expiration date will CANCEL and REPLACE these diets:' + CRLF + CRLF;
  TX_CX_DELAYED1 =  'There are other delayed diet orders for this release event:';
  TX_CX_DELAYED2 =  'This new diet order may cancel and replace those other diets ' +
                    'IMMEDIATELY ON RELEASE, unless you either:' + CRLF + CRLF +

                    '1. Specify an expiration date/time for this order that will' + CRLF +
                    '   be prior to the start date/time of those other orders; or' + CRLF + CRLF +

                    '2. Specify a later start date/time for this order for when you' + CRLF +
                    '   would like it to cancel and replace those other orders.';

var
  i: integer;
  AStringList: TStringList;
  AList: TList;
  x, PtEvtIFN, PtEvtName: string;
  //AResponse: TResponse;
begin
  if EvtID = 0 then   // check current and future released diets
  begin
    x := CurrentText;
    if Piece(x, #13, 1) <> 'Current Diet:  ' then
    begin
      AStringList := TStringList.Create;
      try
        if x = '' then
          x := ' ';
        AStringList.Text := x;
        if tubefeeding = false then CancelText := TX_CX_CUR + #9 + Piece(AStringList[0], ':', 1) + ':' + CRLF + CRLF
                 + #9 + Copy(AStringList[0], 16, 99) + CRLF
        else CancelText := Piece(AStringList[0], ':', 1) + ':' + CRLF + CRLF
                 + #9 + Copy(AStringList[0], 16, 99) + CRLF;
        if AStringList.Count > 1 then
        begin
          if tubefeeding = false then CancelText := CancelText + CRLF + CRLF +
                   TX_CX_FUT + #9 + Piece(AStringList[1], ':', 1) + ':' + CRLF + CRLF
                   + #9 + Copy(AStringList[1], 22, 99) + CRLF
          else CancelText := CancelText + CRLF + CRLF +
                   'Future Orders:' + #9 + Piece(AStringList[1], ':', 1) + ':' + CRLF + CRLF
                   + #9 + Copy(AStringList[1], 22, 99) + CRLF;
          if AStringList.Count > 2 then
          for i := 2 to AStringList.Count - 1 do
            CancelText := CancelText + #9 + TrimLeft(AStringList[i]) + CRLF;
        end;
      finally
        AStringList.Free;
      end;
    end;
  end 
  else if Sender is TButton then     // delayed orders code here - on accept only
  begin
    //AResponse := Responses.FindResponseByName('STOP', 1);
    //if (AResponse <> nil) and (AResponse.EValue <> '') then exit;
    AList := TList.Create;
    try
      PtEvtIFN := IntToStr(frmOrders.TheCurrentView.EventDelay.PtEventIFN);
      PtEvtName := frmOrders.TheCurrentView.EventDelay.EventName;
      LoadOrdersAbbr(AList, frmOrders.TheCurrentView, PtEvtIFN);
      for i := AList.Count - 1 downto 0 do
      begin
        if TOrder(Alist.Items[i]).DGroup <> DispGrp then
        begin
          TOrder(AList.Items[i]).Free;
          AList.Delete(i);
        end;
      end;
      if AList.Count > 0 then
      begin
        x := '';
        RetrieveOrderFields(AList, 0, 0);
        CancelText := TX_CX_DELAYED1 + CRLF + CRLF + 'Release event: ' + PtEvtName; 
        for i := 0 to AList.Count - 1 do
          with TOrder(AList.Items[i]) do
          begin
            x := x + #9 + Text + CRLF;
(*            if StartTime <> '' then
              x := #9 + x + 'Start:   ' + StartTime + CRLF
            else
              x := #9 + x + 'Ordered: ' + FormatFMDateTime('mmm dd,yyyy@hh:nn', OrderTime) + CRLF;*)
          end;
        CancelText := CancelText + CRLF + CRLF + x;
        CancelText := CancelText + CRLF + CRLF + TX_CX_DELAYED2;
      end;
    finally
      with AList do for i := 0 to Count - 1 do TOrder(Items[i]).Free;
      AList.Free;
    end;
  end;
end;


initialization
  uOrderEventType := #0;
  uOrderFormID := 0;
  uOrderEventName := '';
  uFillerAppID := TStringList.Create;
  uKeyVarList  := TStringList.Create;

finalization
  uFillerAppID.Free;
  uKeyVarList.Free;

end.
