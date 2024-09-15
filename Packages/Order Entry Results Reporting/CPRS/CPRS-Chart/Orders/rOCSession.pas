unit rOCSession;
{------------------------------------------------------------------------------
Update History

    2016-09-20: NSR#20101203 (Critical/Hight Order Check Display)
-------------------------------------------------------------------------------}
interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fOCMonograph,
  fAutoSz, StdCtrls, ORFn, uConst, ORCtrls, ExtCtrls, VA508AccessibilityManager,
  Grids, strUtils, uDlgComponents, VAUtils, VA508AccessibilityRouter,
  Vcl.ComCtrls, Winapi.RichEdit, ShellAPI, system.UITypes, Data.Bind.Components,
  system.Math;

type
  TTextRange = record
    chrg: TCharRange;
    lpstrText: PWideChar;
  end;

  PENLink = ^TENLink;

  // Allow the enumerator to "look" ahead at the next entries text
  {
  TStringsEnumeratorHelper = class helper for TStringsEnumerator
  Private
    Function GetNext: String;
  public
    property Next: string read GetNext;
  end;
  }
  // Add lookup by piece
  TStringListHelper = class helper for TStringList
  public
    function IndexOfPiece(const PieceNum: Integer; const S: string): Integer;
  end;

  // Add URL support to the TRichedit
  TRichEdit = class(ORExtensions.TRichEdit)
  private
    FAutoDetect: Boolean; // URL Auto Detection
    FClickRange: TCharRange; // Range when left mouse button clicked
    FRchState: TObject; // Holds text for recreate
    procedure CNNotify(var Msg: TWMNotify); message CN_NOTIFY;
    function GetAutoURLDetect: Boolean;
    function GetTextRange(StartPos, EndPos: Longint): string;
    procedure SetAutodetect(aValue: Boolean);
    procedure WMSetText(var Msg: TMessage); message WM_SETTEXT;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    property AutoDetect: Boolean read GetAutoURLDetect write SetAutodetect
      default true;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  end;

  TRichEditState = class(TObject)
  private
    FModified: Boolean; // Holds the previous modified property
    FSelLength: Integer; // Holds the previous selection length
    FSelStart: Integer; // Holds the previous selection start point
    FStream: TMemoryStream; // Holds the previous text
  public
    constructor Create;
    destructor Destroy; override;
    procedure Restore(RE: TRichEdit);
    procedure Store(RE: TRichEdit);
  end;

  // Hold information about the order
  TOrderRec = class(TObject)
  Private
    fIsCritical: Boolean;
    fHaveComment: Boolean;
    fOrderID: String;
    fCanceled: Boolean;
    fOrderCheckTxt: TStringList;
    fCommentTxt: TStringList;
    fOverRideReasons: TStringList;
    fOverRideSel: String;
    fIsComplete: Boolean;
    fOrderName: String;
    procedure UpdateOrderRec(OrderList: tStringList);
  public
    constructor Create(aOrderID, OrderName: string; aOrderChecks: TStringList);
    destructor Destroy(); override; // required to acoid overriding virtual method
    procedure SetOrderCheckText(aValue: tStringList);
    Property IsCritical: Boolean read fIsCritical;
    Property HaveComment: Boolean read fHaveComment;
    property Canceled: Boolean read fCanceled write fCanceled;
    Property OrderID: String read fOrderID;
    Property OrderCheckTxt: TStringList read fOrderCheckTxt;
    Property CommentTxt: TStringList read fCommentTxt write fCommentTxt;
    Property OverRideReasons: TStringList read fOverRideReasons;
    Property OverRideSel: String read fOverRideSel write fOverRideSel;
    property IsComplete: Boolean read fIsComplete write fIsComplete;
    Property OrderName: String read fOrderName;
  end;

  // Add disabled gray background
  TORComboBox = class (ORCtrls.TORComboBox)
  private
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
  end;

implementation

uses
  rOrders;

{$REGION 'TRichEdit'}

procedure TRichEdit.CreateWnd;
var
  mask: LRESULT; //Word; <- "word" generates "range check" eror
begin
  inherited CreateWnd;
  try
    // Enable the use of auto detect url
    mask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
    SendMessage(Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
    SendMessage(Handle, EM_AUTOURLDETECT, Integer(true), 0);
    FAutoDetect := true;

    // If restoring the handle then stream in the previous text
    if Assigned(FRchState) then
    begin
      TRichEditState(FRchState).Restore(Self);
      FreeAndNil(FRchState);
    end;
  except
    FAutoDetect := false;
  end;
end;

procedure TRichEdit.DestroyWnd;
begin
  if csRecreating in ControlState then
  begin
    // If recreating the handle then store off the text
    FRchState := TRichEditState.Create;
    TRichEditState(FRchState).Store(Self);
  end;

  inherited DestroyWnd;
end;

procedure TRichEdit.SetAutodetect(aValue: Boolean);
begin
  if aValue <> FAutoDetect then
  begin
    FAutoDetect := aValue;
    if HandleAllocated then
      SendMessage(Handle, EM_AUTOURLDETECT, WPARAM(FAutoDetect), 0);
  end;
end;

function TRichEdit.GetAutoURLDetect: Boolean;
begin
  Result := FAutoDetect;
  if HandleAllocated and not(csDesigning in ComponentState) then
  begin
    Result := Boolean(SendMessage(Handle, EM_GETAUTOURLDETECT, 0, 0));
  end;
end;

function TRichEdit.GetTextRange(StartPos, EndPos: Longint): string;
var
  TextRange: TTextRange;
begin
  SetLength(Result, EndPos - StartPos + 1);
  TextRange.chrg.cpMin := StartPos;
  TextRange.chrg.cpMax := EndPos;
  TextRange.lpstrText := PChar(Result);
  SetLength(Result, SendMessage(Handle, EM_GETTEXTRANGE, 0,
    LPARAM(@TextRange)));
end;

procedure TRichEdit.CNNotify(var Msg: TWMNotify);
begin
  with Msg do
  begin
    case NMHdr^.code of
      EN_LINK:
        with PENLink(NMHdr)^ do
        begin
          case Msg of
            WM_LBUTTONDOWN:
              // capture the click range
              FClickRange := chrg;
            WM_LBUTTONUP:
              begin
                // If we are still within the url region then shell execute the url
                if (FClickRange.cpMin = chrg.cpMin) and
                  (FClickRange.cpMax = chrg.cpMax) then
                  // This could be handled off in it's own event in the future
                  ShellExecute(Handle, 'open',
                    PChar(GetTextRange(chrg.cpMin, chrg.cpMax)), nil, nil,
                    SW_SHOWNORMAL);
                // clear the click range
                with FClickRange do
                begin
                  cpMin := -1;
                  cpMax := -1;
                end;
              end;
          end;
        end;
    end;
    inherited;
  end;
end;

procedure TRichEdit.WMSetText(var Msg: TMessage);
begin
  if AutoDetect then
    HandleNeeded;
  inherited;
end;

constructor TRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRchState := nil;
end;

destructor TRichEdit.Destroy();
begin
  FRchState.free;
  inherited;
end;

{$ENDREGION}
{$REGION 'TRichEditState'}

constructor TRichEditState.Create;
begin
  inherited Create;
  FStream := TMemoryStream.Create;
end;

destructor TRichEditState.Destroy;
begin
  FStream.free;
  inherited Destroy;
end;

procedure TRichEditState.Restore(RE: TRichEdit);
begin
  FStream.Position := 0; // start of the stream
  RE.Lines.LoadFromStream(FStream); // Load from the stream
  RE.SelStart := FSelStart; // Restore the selection start
  RE.SelLength := FSelLength; // Restore the selection length
  RE.Modified := FModified; // Restore the modified
end;

procedure TRichEditState.Store(RE: TRichEdit);
begin
  FModified := RE.Modified; // Store the previous modified
  FSelStart := RE.SelStart; // Store the previous selection start
  FSelLength := RE.SelLength; // Store the previous selection length
  RE.Lines.SaveToStream(FStream); // Store the previous text
end;

{$ENDREGION}
{$REGION 'TStringsEnumeratorHelper'}
{
Function TStringsEnumeratorHelper.GetNext: String;
begin
  Result := '';
  if Self.FIndex < Self.FStrings.Count - 1 then
    Result := Self.FStrings[Self.FIndex + 1];
end;
}
{$ENDREGION}
{$REGION 'TStringListHelper'}

function TStringListHelper.IndexOfPiece(const PieceNum: Integer;
  const S: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Self.Count - 1 do
  begin
    if CompareStrings(Piece(Self.Strings[I], '^', PieceNum), S) = 0 then
    begin
      Result := I;
      Break;
    end;
  end;

end;

{$ENDREGION}
{$REGION 'TOrderRec'}

constructor TOrderRec.Create(aOrderID, OrderName: string; aOrderChecks: TStringList);

function GetModifiedOutText(aIn: String): String;
var
  tmpLst: TStringList;
begin
  tmpLst := TStringList.Create;
  try
    GetXtraTxt(tmpLst, Piece(aIn, '&', 1), Piece(aIn, '&', 2));
    Result := tmpLst.Text;
  finally
    tmpLst.free;
  end;
end;

begin

  fIsCritical := false;
  fHaveComment := false;
  fOrderID := aOrderID;
  fOverRideSel := '';
  fOrderName := OrderName;

  fOrderCheckTxt := TStringList.Create;
  fCommentTxt := TStringList.Create;
  fOverRideReasons := TStringList.Create;

  if not Assigned(aOrderChecks) then
    exit;

  // setup
  UpdateOrderRec(aOrderChecks);
  // Fill out the fRichEdit
  // SortByPiece(aOrderChecks, U, 1);
  GetAllergyReasonList(fOverRideReasons, StrToIntDef(Piece(fOrderID,
    ';', 1), 0), 'O');
end;

destructor TOrderRec.Destroy();
begin
  fOverRideReasons.free;
  fCommentTxt.free;
  fOrderCheckTxt.free;
end;

procedure TOrderRec.SetOrderCheckText(aValue: tStringList);
begin
  fOrderCheckTxt.clear;
  UpdateOrderRec(aValue);
end;

procedure TOrderRec.UpdateOrderRec(OrderList: tStringList);

function GetModifiedOutText(aIn: String): String;
var
  tmpLst: TStringList;
begin
  tmpLst := TStringList.Create;
  try
    GetXtraTxt(tmpLst, Piece(aIn, '&', 1), Piece(aIn, '&', 2));
    Result := tmpLst.Text;
  finally
    tmpLst.free;
  end;
end;

var
  I:integer;
  tmpStr: String;
  sCritical: String;
  MultipleCriticals: boolean;

begin
  MultipleCriticals := False;
  SortByPiece(OrderList, U, 1);
  // Add the order checks
  for I := 0 to OrderList.Count - 1 do
  begin
    if (Piece(OrderList.Strings[I], U, 1) = '1') then
      sCritical := ' *** '
    else
      sCritical := '';

    if Pos('||', Piece(OrderList.Strings[I], U, 2)) = 1 then
    begin
     tmpStr := Copy(Piece(OrderList.Strings[I], U, 2), 3, Length(Piece(OrderList.Strings[I], U, 2)));
     fOrderCheckTxt.Add(Piece(OrderList.Strings[I], U, 1) + '^' + sCritical + GetModifiedOutText(tmpStr));
    end else
      fOrderCheckTxt.Add(Piece(OrderList.Strings[I], U, 1) + '^' + sCritical +
        Piece(OrderList.Strings[I], U, 2));

    // Preload the next sections
    if (not MultipleCriticals) and (Piece(OrderList.Strings[I], U, 1) = '1') then
    begin
      if (IsCritical) then
        MultipleCriticals := True
      else
        fIsCritical := true;
    end;
    if (not fHaveComment) and (Piece(OrderList.Strings[I], U, 3) = '1')
      and (Piece(OrderList.Strings[I], U, 4) <> '') then //TDP - Added the extra And
    begin
      fHaveComment := true;
      fCommentTxt.Add(Piece(OrderList.Strings[I], U, 4))
    end;
    //TDP - Added setting of fOverRideSel
    if Piece(OrderList.Strings[I], U, 5) <> '' then
      fOverRideSel := Piece(OrderList.Strings[I], U, 5);
  end;
  if MultipleCriticals then
    fOverRideSel := '';
end;

{$ENDREGION}
{$REGION 'TORComboBox'}

procedure TORComboBox.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if Self.Enabled then
   Color := clWindow
  else
   Color := clMedGray;
end;

{$ENDREGION}


end.
