unit ORClasses;

interface

uses
  SysUtils, System.Types, Classes, Controls, ComCtrls, ExtCtrls, StdCtrls, Forms, ORFn;

type
  TNotifyProc = procedure(Sender: TObject);

  TORNotifyList = class(TObject)
  private
    FCode: TList;
    FData: TList;
  protected
    function GetItems(index: integer): TNotifyEvent;
    procedure SetItems(index: integer; const Value: TNotifyEvent);
    function GetIsProc(index: integer): boolean;
    function GetProcs(index: integer): TNotifyProc;
    procedure SetProcs(index: integer; const Value: TNotifyProc);
  public
    constructor Create;
    destructor Destroy; override;
    function IndexOf(const NotifyProc: TNotifyEvent): integer; overload;
    function IndexOf(const NotifyProc: TNotifyProc): integer; overload;
    procedure Add(const NotifyProc: TNotifyEvent); overload;
    procedure Add(const NotifyProc: TNotifyProc); overload;
    procedure Clear;
    function Count: integer;
    procedure Delete(index: integer);
    procedure Remove(const NotifyProc: TNotifyEvent); overload;
    procedure Remove(const NotifyProc: TNotifyProc); overload;
    procedure Notify(Sender: TObject);
    property Items[index: integer]: TNotifyEvent read GetItems write SetItems; default;
    property Procs[index: integer]: TNotifyProc read GetProcs write SetProcs;
    property IsProc[index: integer]: boolean read GetIsProc;
  end;

  TCanNotifyEvent = procedure(Sender: TObject; var CanNotify: boolean) of object;

  TORNotifier = class(TObject)
  private
    FNotifyList: TORNotifyList;
    FUpdateCount: integer;
    FOwner: TObject;
    FOnNotify: TCanNotifyEvent;
    function GetOnNotify: TCanNotifyEvent;
    procedure SetOnNotify(Value: TCanNotifyEvent);
  protected
    procedure DoNotify(Sender: TObject);
  public
    constructor Create(Owner: TObject = nil; SingleInstance: boolean = FALSE);
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate(DoNotify: boolean = FALSE);
    procedure NotifyWhenChanged(Event: TNotifyEvent); overload;
    procedure NotifyWhenChanged(Event: TNotifyProc); overload;
    procedure RemoveNotify(Event: TNotifyEvent); overload;
    procedure RemoveNotify(Event: TNotifyProc); overload;
    procedure Notify; overload;
    procedure Notify(Sender: TObject); overload;
    property OnNotify: TCanNotifyEvent read GetOnNotify Write SetOnNotify;
  end;

  TORStringList = class(TStringList)
  private
    FNotifier: TORNotifier;
  protected
    function GetNotifier: TORNotifier;
    procedure Changed; override;
  public
    destructor Destroy; override;
    procedure KillObjects;
// IndexOfPiece starts looking at StartIdx+1
    function CaseInsensitiveIndexOfPiece(Value: string; Delim: Char = '^';
                                         PieceNum: integer = 1;
                                         StartIdx: integer = -1): integer;
    function IndexOfPiece(Value: string; Delim: Char = '^';
                                         PieceNum: integer = 1;
                                         StartIdx: integer = -1): integer;
    function IndexOfPieces(const Values: array of string; const Delim: Char;
                                                  const Pieces: array of integer;
                                                  StartIdx: integer = -1): integer; overload;
    function IndexOfPieces(const Values: array of string): integer; overload;
    function IndexOfPieces(const Values: array of string; StartIdx: integer): integer; overload;
    function PiecesEqual(const Index: integer;
                         const Values: array of string): boolean; overload;
    function PiecesEqual(const Index: integer;
                         const Values: array of string;
                         const Pieces: array of integer): boolean; overload;
    function PiecesEqual(const Index: integer;
                         const Values: array of string;
                         const Pieces: array of integer;
                         const Delim: Char): boolean; overload;
    procedure SetStrPiece(Index, PieceNum: integer; Delim: Char; const NewValue: string); overload;
    procedure SetStrPiece(Index, PieceNum: integer; const NewValue: string); overload; 
    procedure SortByPiece(PieceNum: integer; Delim: Char = '^');
    procedure SortByPieces(Pieces: array of integer; Delim: Char = '^');
    procedure RemoveDuplicates(CaseSensitive: boolean = TRUE);
    property Notifier: TORNotifier read GetNotifier;
  end;

{ Do NOT add ANTHING to the ORExposed Classes except to change the scope
  of a property.  If you do, existing code could generate Access Violations }
  TORExposedCustomEdit = class(TCustomEdit)
  public
    property ReadOnly;
  end;

  TORExposedAnimate = class(TAnimate)
  public
    property OnMouseUp;
    property OnMouseDown;
  end;

  TORExposedControl = class(TControl)
  public
    property Font;
    property Text;
    property ParentFont;
  end;

{ AddToNotifyWhenCreated allows you to add an event handler before the object that
  calls that event handler is created.  This only works when there is only one
  instance of a given object created (like TPatient or TEncounter).  For an object
  to make use of this feature, it must call ObjectCreated in the constructor,
  which will return the TORNotifyList that was created for that object. }
procedure AddToNotifyWhenCreated(ProcToAdd: TNotifyEvent; CreatedClass: TClass); overload;
procedure AddToNotifyWhenCreated(ProcToAdd: TNotifyProc; CreatedClass: TClass); overload;
procedure ObjectCreated(CreatedClass: TClass; var NotifyList: TORNotifyList);

type
  TORInterfaceList = class(TList)
  private
    function GetItem(Index: Integer): IUnknown;
    procedure SetItem(Index: Integer; const Value: IUnknown);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function Add(Item: IUnknown): Integer;
    function Extract(Item: IUnknown): IUnknown;
    function First: IUnknown;
    function IndexOf(Item: IUnknown): Integer;
    procedure Insert(Index: Integer; Item: IUnknown);
    function Last: IUnknown;
    function Remove(Item: IUnknown): Integer;
    property Items[Index: Integer]: IUnknown read GetItem write SetItem; default;
  end;

implementation

var
  NotifyLists: TStringList = nil;

function IndexOfClass(CreatedClass: TClass): integer;
begin
  if(not assigned(NotifyLists)) then
    NotifyLists := TStringList.Create;
  Result := NotifyLists.IndexOf(CreatedClass.ClassName);
  if(Result < 0) then
    Result := NotifyLists.AddObject(CreatedClass.ClassName, TORNotifyList.Create);
end;

procedure AddToNotifyWhenCreated(ProcToAdd: TNotifyEvent; CreatedClass: TClass); overload;
var
  idx: integer;

begin
  idx := IndexOfClass(CreatedClass);
  TORNotifyList(NotifyLists.Objects[idx]).Add(ProcToAdd);
end;

procedure AddToNotifyWhenCreated(ProcToAdd: TNotifyProc; CreatedClass: TClass); overload;
var
  idx: integer;

begin
  idx := IndexOfClass(CreatedClass);
  TORNotifyList(NotifyLists.Objects[idx]).Add(ProcToAdd);
end;

procedure ObjectCreated(CreatedClass: TClass; var NotifyList: TORNotifyList);
var
  idx: integer;

begin
  if(assigned(NotifyLists)) then
  begin
    idx := IndexOfClass(CreatedClass);
    if(idx < 0) then
      NotifyList := nil
    else
    begin
      NotifyList := (NotifyLists.Objects[idx] as TORNotifyList);
      NotifyLists.Delete(idx);
      if(NotifyLists.Count <= 0) then
        KillObj(@NotifyLists);
    end;
  end;
end;

{ TORNotifyList }

constructor TORNotifyList.Create;
begin
  inherited;
  FCode := TList.Create;
  FData := TList.Create;
end;

destructor TORNotifyList.Destroy;
begin
  KillObj(@FCode);
  KillObj(@FData);
  inherited
end;

function TORNotifyList.IndexOf(const NotifyProc: TNotifyEvent): integer;
var
  m: TMethod;

begin
  if(assigned(NotifyProc) and (FCode.Count > 0)) then
  begin
    m := TMethod(NotifyProc);
    Result := 0;
    while((Result < FCode.Count) and ((FCode[Result] <> m.Code) or
          (FData[Result] <> m.Data))) do inc(Result);
    if Result >= FCode.Count then Result := -1;
  end
  else
    Result := -1;
end;

procedure TORNotifyList.Add(const NotifyProc: TNotifyEvent);
var
  m: TMethod;

begin
  if(assigned(NotifyProc) and (IndexOf(NotifyProc) < 0)) then
  begin
    m := TMethod(NotifyProc);
    FCode.Add(m.Code);
    FData.Add(m.Data);
  end;
end;

procedure TORNotifyList.Remove(const NotifyProc: TNotifyEvent);
var
  idx: integer;

begin
  idx := IndexOf(NotifyProc);
  if(idx >= 0) then
  begin
    FCode.Delete(idx);
    FData.Delete(idx);
  end;
end;

function TORNotifyList.GetItems(index: integer): TNotifyEvent;
begin
  TMethod(Result).Code := FCode[index];
  TMethod(Result).Data := FData[index];
end;

procedure TORNotifyList.SetItems(index: integer; const Value: TNotifyEvent);
begin
  FCode[index] := TMethod(Value).Code;
  FData[index] := TMethod(Value).Data;
end;

procedure TORNotifyList.Notify(Sender: TObject);
var
  i: integer;
  evnt: TNotifyEvent;
  proc: TNotifyProc;

begin
  for i := 0 to FCode.Count-1 do
  begin
    if(FData[i] = nil) then
    begin
      proc := FCode[i];
      if(assigned(proc)) then proc(Sender);
    end
    else
    begin
      TMethod(evnt).Code := FCode[i];
      TMethod(evnt).Data := FData[i];
      if(assigned(evnt)) then evnt(Sender);
    end;
  end;
end;

procedure TORNotifyList.Clear;
begin
  FCode.Clear;
  FData.Clear;
end;

function TORNotifyList.Count: integer;
begin
  Result := FCode.Count;
end;

procedure TORNotifyList.Delete(index: integer);
begin
  FCode.Delete(index);
  FData.Delete(index);
end;

procedure TORNotifyList.Add(const NotifyProc: TNotifyProc);
begin
  if(assigned(NotifyProc) and (IndexOf(NotifyProc) < 0)) then
  begin
    FCode.Add(@NotifyProc);
    FData.Add(nil);
  end;
end;

function TORNotifyList.IndexOf(const NotifyProc: TNotifyProc): integer;
var
  prt: ^TNotifyProc;

begin
  prt := @NotifyProc;
  if(assigned(NotifyProc) and (FCode.Count > 0)) then
  begin
    Result := 0;
    while((Result < FCode.Count) and ((FCode[Result] <> prt) or
          (FData[Result] <> nil))) do inc(Result);
    if Result >= FCode.Count then Result := -1;
  end
  else
    Result := -1;
end;

procedure TORNotifyList.Remove(const NotifyProc: TNotifyProc);
var
  idx: integer;

begin
  idx := IndexOf(NotifyProc);
  if(idx >= 0) then
  begin
    FCode.Delete(idx);
    FData.Delete(idx);
  end;
end;

function TORNotifyList.GetIsProc(index: integer): boolean;
begin
  Result := (not assigned(FData[index]));
end;

function TORNotifyList.GetProcs(index: integer): TNotifyProc;
begin
  Result := FCode[index];
end;

procedure TORNotifyList.SetProcs(index: integer; const Value: TNotifyProc);
begin
  FCode[index] := @Value;
  FData[index] := nil;
end;

{ TORNotifier }

constructor TORNotifier.Create(Owner: TObject = nil; SingleInstance: boolean = FALSE);
begin
  FOwner := Owner;
  if(assigned(Owner) and SingleInstance) then
    ObjectCreated(Owner.ClassType, FNotifyList);
end;

destructor TORNotifier.Destroy;
begin
  KillObj(@FNotifyList);
  inherited;
end;

procedure TORNotifier.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure TORNotifier.EndUpdate(DoNotify: boolean = FALSE);
begin
  if(FUpdateCount > 0) then
  begin
    dec(FUpdateCount);
    if(DoNotify and (FUpdateCount = 0)) then Notify(FOwner);
  end;
end;

procedure TORNotifier.Notify(Sender: TObject);
begin
  if((FUpdateCount = 0) and assigned(FNotifyList) and (FNotifyList.Count > 0)) then
    DoNotify(Sender);
end;

procedure TORNotifier.Notify;
begin
  if((FUpdateCount = 0) and assigned(FNotifyList) and (FNotifyList.Count > 0)) then
    DoNotify(FOwner);
end;

procedure TORNotifier.NotifyWhenChanged(Event: TNotifyEvent);
begin
  if(not assigned(FNotifyList)) then
    FNotifyList := TORNotifyList.Create;
  FNotifyList.Add(Event);
end;

procedure TORNotifier.NotifyWhenChanged(Event: TNotifyProc);
begin
  if(not assigned(FNotifyList)) then
    FNotifyList := TORNotifyList.Create;
  FNotifyList.Add(Event);
end;

procedure TORNotifier.RemoveNotify(Event: TNotifyEvent);
begin
  if(assigned(FNotifyList)) then
    FNotifyList.Remove(Event);
end;

procedure TORNotifier.RemoveNotify(Event: TNotifyProc);
begin
  if(assigned(FNotifyList)) then
    FNotifyList.Remove(Event);
end;

function TORNotifier.GetOnNotify: TCanNotifyEvent;
begin
  Result := FOnNotify;
end;

procedure TORNotifier.SetOnNotify(Value: TCanNotifyEvent);
begin
  FOnNotify := Value;
end;

procedure TORNotifier.DoNotify(Sender: TObject);
var
  CanNotify: boolean;

begin
  CanNotify := TRUE;
  if(assigned(FOnNotify)) then
    FOnNotify(Sender, CanNotify);
  if(CanNotify) then
    FNotifyList.Notify(Sender);
end;

{ TORStringList }

destructor TORStringList.Destroy;
begin
  FreeAndNil(FNotifier);
  inherited;
end;

procedure TORStringList.Changed;
var
  OldEvnt: TNotifyEvent;

begin
{ We redirect the OnChange event handler, rather than calling
  FNotifyList.Notify directly, because inherited may not call
  OnChange, and we don't have access to the private variables
  inherited uses to determine if OnChange should be called    }

  if(assigned(FNotifier)) then
  begin
    OldEvnt := OnChange;
    try
      OnChange := FNotifier.Notify;//Method;
      inherited; // Conditionally Calls FNotifier.Notify
    finally
      OnChange := OldEvnt;
    end;
  end;
  inherited; // Conditionally Calls the old OnChange event handler
end;

function TORStringList.IndexOfPiece(Value: string; Delim: Char;
                                                   PieceNum: integer;
                                                   StartIdx: integer): integer;
begin
  Result := StartIdx;
  inc(Result);
  while((Result >= 0) and (Result < Count) and
        (Piece(Strings[Result], Delim, PieceNum) <> Value)) do
    inc(Result);
  if(Result < 0) or (Result >= Count) then Result := -1;
end;

function TORStringList.IndexOfPieces(const Values: array of string; const Delim: Char;
                                           const Pieces: array of integer;
                                           StartIdx: integer = -1): integer;
var
  Done: boolean;

begin
  Result := StartIdx;
  repeat
    inc(Result);
    if(Result >= 0) and (Result < Count) then
      Done := PiecesEqual(Result, Values, Pieces, Delim)
    else
      Done := TRUE;
  until(Done);
  if(Result < 0) or (Result >= Count) then Result := -1;
end;

function TORStringList.IndexOfPieces(const Values: array of string): integer;
begin
  Result := IndexOfPieces(Values, U, [], -1);
end;

function TORStringList.IndexOfPieces(const Values: array of string;
  StartIdx: integer): integer;
begin
  Result := IndexOfPieces(Values, U, [], StartIdx);
end;

function TORStringList.GetNotifier: TORNotifier;
begin
  if(not assigned(FNotifier)) then
    FNotifier := TORNotifier.Create(Self);
  Result := FNotifier;
end;

procedure TORStringList.KillObjects;
var
  i: integer;

begin
  for i := 0 to Count-1 do
  begin
    if(assigned(Objects[i])) then
    begin
      Objects[i].Free;
      Objects[i] := nil;
    end;
  end;
end;

function TORStringList.PiecesEqual(const Index: integer;
                                   const Values: array of string): boolean;
begin
  Result := PiecesEqual(Index, Values, [], U);
end;

function TORStringList.PiecesEqual(const Index: integer;
                                   const Values: array of string;
                                   const Pieces: array of integer): boolean;
begin
  Result := PiecesEqual(Index, Values, Pieces, U);
end;

function TORStringList.PiecesEqual(const Index: integer;
                                   const Values: array of string;
                                   const Pieces: array of integer;
                                   const Delim: Char): boolean;
var
  i, cnt, p: integer;

begin
  cnt := 0;
  Result := TRUE;
  for i := low(Values) to high(Values) do
  begin
    inc(cnt);
    if(i >= low(Pieces)) and (i <= high(Pieces)) then
      p := Pieces[i]
    else
      p := cnt;
    if(Piece(Strings[Index], Delim, p) <> Values[i]) then
    begin
      Result := FALSE;
      break;
    end;
  end;
end;

procedure TORStringList.SortByPiece(PieceNum: integer; Delim: Char = '^');
begin
  SortByPieces([PieceNum], Delim);
end;

procedure TORStringList.RemoveDuplicates(CaseSensitive: boolean = TRUE);
var
  i: integer;
  Kill: boolean;

begin
  i := 1;
  while (i < Count) do
  begin
    if(CaseSensitive) then
      Kill := (Strings[i] = Strings[i-1])
    else
      Kill := (CompareText(Strings[i],Strings[i-1]) = 0);
    if(Kill) then
      Delete(i)
    else
      inc(i);
  end;
end;

function TORStringList.CaseInsensitiveIndexOfPiece(Value: string; Delim: Char = '^';
                            PieceNum: integer = 1; StartIdx: integer = -1): integer;
begin
  Result := StartIdx;
  inc(Result);
  while((Result >= 0) and (Result < Count) and
        (CompareText(Piece(Strings[Result], Delim, PieceNum), Value) <> 0)) do
    inc(Result);
  if(Result < 0) or (Result >= Count) then Result := -1;
end;

procedure TORStringList.SortByPieces(Pieces: array of integer;
  Delim: Char = '^');

  procedure QSort(L, R: Integer);
  var
    I, J: Integer;
    P: string;

  begin
    repeat
      I := L;
      J := R;
      P := Strings[(L + R) shr 1];
      repeat
        while ComparePieces(Strings[I], P, Pieces, Delim, TRUE) < 0 do Inc(I);
        while ComparePieces(Strings[J], P, Pieces, Delim, TRUE) > 0 do Dec(J);
        if I <= J then
        begin
          Exchange(I, J);
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then QSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if not Sorted and (Count > 1) then
  begin
    Changing;
    QSort(0, Count - 1);
    Changed;
  end;
end;


procedure TORStringList.SetStrPiece(Index, PieceNum: integer; Delim: Char;
  const NewValue: string);
var
  tmp: string;

begin
  tmp := Strings[Index];
  ORFn.SetPiece(tmp,Delim,PieceNum,NewValue);
  Strings[Index] := tmp;
end;

procedure TORStringList.SetStrPiece(Index, PieceNum: integer;
  const NewValue: string);
begin
  SetStrPiece(Index, PieceNum, '^', NewValue);
end;

{ TORInterfaceList }

function TORInterfaceList.Add(Item: IUnknown): Integer;
begin
  Result := inherited Add(Pointer(Item));
end;

function TORInterfaceList.Extract(Item: IUnknown): IUnknown;
begin
  Result := IUnknown(inherited Extract(Pointer(Item)));
end;

function TORInterfaceList.First: IUnknown;
begin
  Result := IUnknown(inherited First);
end;

function TORInterfaceList.GetItem(Index: Integer): IUnknown;
begin
  Result := IUnknown(inherited Get(Index));
end;

function TORInterfaceList.IndexOf(Item: IUnknown): Integer;
begin
  Result := inherited IndexOf(Pointer(Item));
end;

procedure TORInterfaceList.Insert(Index: Integer; Item: IUnknown);
begin
  inherited Insert(Index, Pointer(Item));
end;

function TORInterfaceList.Last: IUnknown;
begin
  Result := IUnknown(inherited Last);
end;

procedure TORInterfaceList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  case Action of
    lnAdded:                IUnknown(Ptr)._AddRef;
    lnDeleted, lnExtracted: IUnknown(Ptr)._Release;
  end;
end;

function TORInterfaceList.Remove(Item: IUnknown): Integer;
begin
  Result := inherited Remove(Pointer(Item));
end;

procedure TORInterfaceList.SetItem(Index: Integer; const Value: IUnknown);
begin
  inherited Put(Index, Pointer(Value));
end;


initialization

finalization
  KillObj(@NotifyLists, TRUE);

end.