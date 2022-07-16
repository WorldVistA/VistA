{ ******************************************************************************

    ___  __  ____  _  _      _    ____   __   ____  ____  ____
   / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
  ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
   \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  Extended Controls unit

  Components:

    TCollapseBtn = Extend the TButton class

    TSelectorBox = Extend the TListBox class

    TTrackOnlyItem = The collection item for the MonitorCollection

    TTrackOnlyCollection = The collection that will hold the items we want to track

    TCopyPasteThread =  Thread used to task off the lookup when pasting


  { ****************************************************************************** }

unit U_CPTExtended;

interface

uses
  Winapi.Windows, Classes, Vcl.StdCtrls, Vcl.Graphics, Vcl.Controls,
  Winapi.Messages, U_CPTCommon, System.SysUtils,
  Vcl.Clipbrd, Vcl.ComCtrls, Vcl.Forms, Vcl.ExtCtrls;

Type
  // -------- OverWrite Classes --------//
  TCollapseBtn = class(TButton)
    public
      procedure Click; override;
  end;

  TSelectorBox = class(TListBox)
  private
    fSelectorColor: TColor;
    fLinkedRichEdit: TRichEdit;
    procedure OurDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKilFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    procedure Click; override;
    constructor Create(AOwner: TComponent); override;
    Property SelectorColor: TColor Read fSelectorColor write fSelectorColor;
    Property LinkedRichEdit: TRichEdit read fLinkedRichEdit write fLinkedRichEdit;
  end;

  TTrackOnlyItem = class(TCollectionItem)
  private
    FObject: TCustomEdit;
    FOurOrigWndProc: TWndMethod;
    procedure SetTrackObject(const Value: TCustomEdit);
    procedure OurWndProc(var Message: TMessage);
  protected
    function GetDisplayName: String; override;
    procedure SetCollection(Value: TCollection); override;
  public
    procedure Assign(Source: TPersistent); override;
    Property TrackObjectOrigWndProc: TWndMethod read FOurOrigWndProc
      write FOurOrigWndProc;
  published
    property TrackObject: TCustomEdit read FObject write SetTrackObject;
  end;

  TTrackOnlyCollection = class(TCollection)
  private
    FOwner: TComponent;
    procedure SetObjectToMonitor(TrackItem: TTrackOnlyItem);
  protected
    function GetOwner: TPersistent; override;
    procedure SetItem(Index: Integer; Value: TTrackOnlyItem);
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy(); override;
    procedure Delete(Index: Integer);
    function Add: TTrackOnlyItem;
    function GetItem(Index: Integer): TTrackOnlyItem;
    function Insert(Index: Integer): TTrackOnlyItem;
    property Items[Index: Integer]: TTrackOnlyItem read GetItem
      write SetItem; default;
  end;

  // -------- Threads --------//

  TCopyPasteThread = class(TThread)
  private
    fAppMonitor: TComponent;

    fEdtMonitor: TObject;

    fItemIEN: Int64;
    fPasteDetails: String;
    fPasteText: String;

    fClipInfo: tClipInfo;

  protected
    procedure Execute; override;
  public
    constructor Create(PasteText, PasteDetails: string; ItemIEN: Int64;
      AppMonitor: TComponent; EditMonitor: TObject; ClipInfo: tClipInfo);
    destructor Destroy; override;
    property TheadOwner: Int64 read fItemIEN;
  end;

  TCopyPasteThreadArry = Array of TCopyPasteThread;

implementation

Uses
  U_CPTAppMonitor, U_CPTEditMonitor, U_CPTPasteDetails,
  WinApi.RichEdit, System.SyncObjs;

{$REGION 'Thread'}

constructor TCopyPasteThread.Create(PasteText, PasteDetails: String;
  ItemIEN: Int64; AppMonitor: TComponent; EditMonitor: TObject;
  ClipInfo: tClipInfo);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  fAppMonitor := AppMonitor;
  fEdtMonitor := EditMonitor;
  fPasteText := PasteText;
  fPasteDetails := PasteDetails;
  fClipInfo := ClipInfo;
  fItemIEN := ItemIEN;

  TCopyApplicationMonitor(fAppMonitor).LogText('THREAD', 'Thread created');

end;

destructor TCopyPasteThread.Destroy;
var
  I: Integer;

  procedure DeleteX(const Index: Cardinal);
  var
    ALength: Cardinal;
    x: Integer;
  begin
    with TCopyApplicationMonitor(fAppMonitor) do
    begin
      TCopyApplicationMonitor(fAppMonitor).CriticalSection.Enter;
    try
      ALength := Length(fCopyPasteThread);
      for x := Index + 1 to ALength - 1 do
        fCopyPasteThread[x - 1] := fCopyPasteThread[x];
      SetLength(fCopyPasteThread, ALength - 1);
    finally
     TCopyApplicationMonitor(fAppMonitor).CriticalSection.Leave;
    end;

    end;
  end;

begin
  inherited;
  with TCopyApplicationMonitor(fAppMonitor) do
  begin
    TCopyApplicationMonitor(fAppMonitor).CriticalSection.Enter;
    try
    for I := high(fCopyPasteThread) downto low(fCopyPasteThread) do
    begin
      if fCopyPasteThread[I] = Self then
      begin
        DeleteX(I);
        LogText('THREAD', 'Thread deleted');
      end;
    end;
    Finally
      TCopyApplicationMonitor(fAppMonitor).CriticalSection.Leave;
    end;

  end;

end;

procedure TCopyPasteThread.Execute;
begin
    TCopyApplicationMonitor(fAppMonitor).LogText('THREAD',
      'Looking for matches');
    TCopyApplicationMonitor(fAppMonitor).PasteToCopyPasteClipboard(fPasteText,
      fPasteDetails, fItemIEN, fClipInfo);
end;

{$ENDREGION}
{$REGION 'TCollapseBtn'}

procedure TCollapseBtn.Click;
begin
  inherited;
  TCopyPasteDetails(Self.owner).CloseInfoPanel(Self);
  // Do not put any code past this line (event is triggered above)
end;

{$ENDREGION}
{$REGION 'TSelectorBox'}

constructor TSelectorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then
  begin
    Self.Style := lbOwnerDrawFixed;
    OnDrawItem := OurDrawItem;
  end;
end;

procedure TSelectorBox.Click;
begin
  inherited;
  if not (csDesigning in ComponentState) then
   TCopyPasteDetails(Self.owner).lbSelectorClick(Self);
end;

procedure TSelectorBox.WMSetFocus(var Message: TWMSetFocus);
begin
  if not (csDesigning in ComponentState) then
    SelectorColor := clHighlight;
  inherited;
end;

procedure TSelectorBox.WMKilFocus(var Message: TWMKillFocus);
begin
  if not (csDesigning in ComponentState) then
    SelectorColor := clLtGray;
  inherited;
end;

procedure TSelectorBox.OurDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Self.Canvas do
  begin
    if odSelected in State then
      Brush.Color := Self.SelectorColor;

    FillRect(Rect);

    TextOut(Rect.Left, Rect.Top, Self.Items[Index]);
    if odFocused In State then
    begin
      Brush.Color := Self.Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

 procedure TSelectorBox.CMFontChanged(var Message: TMessage);
 var
    ResetMask: Integer;
 begin
   inherited;
   //grab the font
   canvas.font := font;
   with Self.Canvas do
   begin
    if ItemHeight <> TextHeight('Az') then
    begin
      //If font adjusted then update the item height
      ItemHeight := TextHeight('Az');
      Invalidate;
      if Assigned(fLinkedRichEdit) then
      begin
        ResetMask := fLinkedRichEdit.Perform(EM_GETEVENTMASK, 0, 0);
        fLinkedRichEdit.Perform(EM_SETEVENTMASK, 0, 0);
        fLinkedRichEdit.Perform(WM_SETREDRAW, Ord(False), 0);
        try
          fLinkedRichEdit.SelAttributes.Size := font.Size;
          fLinkedRichEdit.font.Size := font.Size;
        finally
          fLinkedRichEdit.Perform(WM_SETREDRAW, Ord(true), 0);
          InvalidateRect(fLinkedRichEdit.Handle, NIL, true);
          fLinkedRichEdit.Perform(EM_SETEVENTMASK, 0, ResetMask);
        end;
      end;
    end;
   end;
 end;

{$ENDREGION}
{$REGION 'TTrackOnlyItem'}

procedure TTrackOnlyItem.Assign(Source: TPersistent);
begin
  if Source is TTrackOnlyItem then
    TrackObject := TTrackOnlyItem(Source).TrackObject
  else
    inherited; // raises an exception
end;

function TTrackOnlyItem.GetDisplayName: String;
begin
  if Assigned(FObject) then
    Result := FObject.Name
  else
    Result := Format('Track Edit %d', [Index]);
end;

procedure TTrackOnlyItem.SetTrackObject(const Value: TCustomEdit);
// var
// CollOwner: TComponent;
begin

  FObject := Value;
  if not (csDesigning in Application.ComponentState) then
  begin
  // CollOwner := TTrackOnlyCollection(Collection).FOwner;
  if Assigned(Value) then
  begin
    FOurOrigWndProc := FObject.WindowProc;
    FObject.WindowProc := OurWndProc;
  end;
  end;
end;

procedure TTrackOnlyItem.OurWndProc(var Message: TMessage);
var
  ShiftState: TShiftState;
  FireMessage: Boolean;

  Procedure PerformPaste(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit);
  var
    ClpInfo: tClipInfo;
  begin
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      ClpInfo := EditMonitorObj.CopyMonitor.GetClipSource;
      EditMonitorObj.PasteToMonitor(Self, TheEdit, true, ClpInfo);
    end;
  end;

  Procedure PerformCopyCut(EditMonitorObj: TCopyEditMonitor;
    TheEdit: TCustomEdit; CMsg: Cardinal);
  begin
    EditMonitorObj.CopyToMonitor(TheEdit, true, CMsg);
  end;

begin
  FireMessage := true;
  if Assigned(TTrackOnlyCollection(Collection).FOwner) then
  begin
    if Assigned(TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner)
      .CopyMonitor) then
    begin
      if TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner).CopyMonitor.Enabled
      then
      begin
        case Message.Msg of
          WM_PASTE:
            begin
              PerformPaste(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                .FOwner), FObject);
              FireMessage := false;
            end;
          WM_COPY:
            begin
              PerformCopyCut(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                .FOwner), FObject, Message.Msg);
              FireMessage := false;
            end;
          WM_CUT:
            begin
              PerformCopyCut(TCopyEditMonitor(TTrackOnlyCollection(Collection)
                .FOwner), FObject, Message.Msg);
              FireMessage := false;
            end;
          WM_KEYDOWN:
            begin
              if (FObject is TRichEdit) then
              begin
                ShiftState := KeyDataToShiftState(Message.WParam);
                if (ssCtrl in ShiftState) then
                begin
                  if (Message.WParam = Ord('V')) then
                  begin
                    PerformPaste
                      (TCopyEditMonitor(TTrackOnlyCollection(Collection)
                      .FOwner), FObject);
                    FireMessage := false;
                  end
                  else if (Message.WParam = Ord('C')) then
                  begin
                    PerformCopyCut
                      (TCopyEditMonitor(TTrackOnlyCollection(Collection)
                      .FOwner), FObject, Message.Msg);
                    FireMessage := false;
                  end
                  else if (Message.WParam = Ord('X')) then
                  begin
                    PerformCopyCut
                      (TCopyEditMonitor(TTrackOnlyCollection(Collection)
                      .FOwner), FObject, Message.Msg);
                    FireMessage := false;
                  end
                  else if (Message.WParam = VK_INSERT) then
                  begin
                    PerformPaste
                      (TCopyEditMonitor(TTrackOnlyCollection(Collection)
                      .FOwner), FObject);
                    FireMessage := false;
                  end;
                end
                else if (ssShift in ShiftState) then
                begin
                  if (Message.WParam = VK_INSERT) then
                  begin
                    PerformPaste
                      (TCopyEditMonitor(TTrackOnlyCollection(Collection)
                      .FOwner), FObject);
                    FireMessage := false;
                  end;
                end;
              end;
            end;
        end;
      end;
    end;
  end;

  if FireMessage then
    FOurOrigWndProc(Message);
end;

{$ENDREGION}
{$REGION 'TTrackOnlyCollection'}

function TTrackOnlyCollection.Add: TTrackOnlyItem;
begin
  Result := TTrackOnlyItem(inherited Add);
  SetObjectToMonitor(Result);
end;

constructor TTrackOnlyCollection.Create(AOwner: TComponent);
begin
  inherited Create(TTrackOnlyItem);
  FOwner := AOwner;
end;

destructor TTrackOnlyCollection.Destroy();
begin
  inherited Destroy;
end;

procedure TTrackOnlyCollection.Delete(Index: Integer);
begin
  // TTrackOnlyItem(GetItem(Index)).FObject.WindowProc :=  TTrackOnlyItem(GetItem(Index)).FOurOrigWndProc;
  inherited Delete(Index);
end;

function TTrackOnlyCollection.GetItem(Index: Integer): TTrackOnlyItem;
begin
  Result := TTrackOnlyItem(inherited GetItem(Index));
end;

function TTrackOnlyCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTrackOnlyCollection.Insert(Index: Integer): TTrackOnlyItem;
begin
  Result := TTrackOnlyItem(inherited Insert(Index));
  SetObjectToMonitor(Result);
end;

procedure TTrackOnlyCollection.SetItem(Index: Integer; Value: TTrackOnlyItem);
begin
  inherited SetItem(Index, Value);
  SetObjectToMonitor(Value);
end;

procedure TTrackOnlyCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

procedure TTrackOnlyCollection.SetObjectToMonitor(TrackItem: TTrackOnlyItem);
begin

end;

{ procedure TTrackOnlyCollection.RemoveItem(Item: TCollectionItem);
  begin
  if Item is TTrackOnlyItem then
  begin
  TTrackOnlyItem(Item).FObject.WindowProc := TTrackOnlyItem(Item).FOurOrigWndProc;
  end;
  inherited;
  end; }

procedure TTrackOnlyItem.SetCollection(Value: TCollection);
begin
  // if (Collection <> Value) and assigned(Collection) then
  // FObject.WindowProc := FOurOrigWndProc;
  inherited;
end;

{$ENDREGION}

end.

