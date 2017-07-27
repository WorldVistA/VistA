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

  /// <summary><para>Extend the TButton class</para></summary>
  TCollapseBtn = class(TButton)
  public
    procedure Click; override;
  end;

  /// <summary><para>Extend the TListBox class</para></summary>
  TSelectorBox = class(TListBox)
  private
    /// <summary>Color of the selector</summary>
    fSelectorColor: TColor;
    /// <summary><para>Custom draw procedure</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Control">Control<para><b>Type: </b><c>TWinControl</c></para></param>
    /// <param name="Index">Index<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="Rect">Rect<para><b>Type: </b><c>TRect</c></para></param>
    /// <param name="State">State<para><b>Type: </b><c>TOwnerDrawState</c></para></param>
    procedure OurDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    /// <summary><para>Used to change the color when focus is set</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TWMSetFocus</c></para></param>
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    /// <summary><para>Used to change the color when focus is killed</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TWMSetFocus</c></para></param>
    procedure WMKilFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
  public
    /// <summary><para>used to fire off the correct selection</para><para><b>Type: </b><c>Integer</c></para></summary>
    procedure Click; override;
    /// <summary><para>constructor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="AOwner">AOwner<para><b>Type: </b><c>TComponent</c></para></param>
    constructor Create(AOwner: TComponent); override;
    Property SelectorColor: TColor Read fSelectorColor write fSelectorColor;
  end;

  /// <summary>The collection item for the MonitorCollection</summary>
  TTrackOnlyItem = class(TCollectionItem)
  private
    /// <summary>The collection object to monitor</summary>
    FObject: TCustomEdit;
    /// <summary>Pointer to the original WndProc</summary>
    FOurOrigWndProc: TWndMethod;
    /// <summary><para>Setter for TrackObject which also hooks into the object</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Value">The object to monitor<para><b>Type: </b><c>TCustomEdit</c></para></param>
    procedure SetTrackObject(const Value: TCustomEdit);
    /// <summary><para>Custom WndProc</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Message">Message<para><b>Type: </b><c>TMessage</c></para></param>
    procedure OurWndProc(var Message: TMessage);
  protected
    /// <summary><para>Override for GetDisplayName</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <returns><para><b>Type: </b><c>String</c></para> </returns>
    function GetDisplayName: String; override;
    procedure SetCollection(Value: TCollection); override;
  public
    /// <summary><para>Assigns the customedit to the trackitem</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="Source">Source<para><b>Type: </b><c>TPersistent</c></para></param>
    procedure Assign(Source: TPersistent); override;
    Property TrackObjectOrigWndProc: TWndMethod read FOurOrigWndProc
      write FOurOrigWndProc;
  published
    /// <summary><para>The TCustomEdit we want to monitor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="TrackItem">TrackItem<para><b>Type: </b><c>TTrackOnlyItem</c></para></param>
    property TrackObject: TCustomEdit read FObject write SetTrackObject;
  end;

  /// <summary><para>The collection that will hold the items we want to track</para></summary>
  TTrackOnlyCollection = class(TCollection)
  private
    FOwner: TComponent;
    procedure SetObjectToMonitor(TrackItem: TTrackOnlyItem);
    // procedure RemoveItem(Item: TCollectionItem); override;
  protected
    function GetOwner: TPersistent; override;
    // function GetItem(Index: Integer): TTrackOnlyItem;
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

  /// <summary>Thread used to task off the lookup when pasting</summary>
  TCopyPasteThread = class(TThread)
  private
    /// <summary><para>Lookup item's <see cref="U_CPTAppMonitor|TCopyApplicationMonitor" /></para><para><b>Type: </b><c>TCopyApplicationMonitor</c></para></summary>
    fAppMonitor: TComponent;

    fEdtMonitor: TObject;

    /// <summary><para>Lookup item's IEN</para><para><b>Type: </b><c>Integer</c></para></summary>
    fItemIEN: Int64;
    /// <summary><para>Lookup item's copy/paste format details</para><para><b>Type: </b><c>String</c></para></summary>
    fPasteDetails: String;
    /// <summary><para>Lookup item's text</para><para><b>Type: </b><c>String</c></para></summary>
    fPasteText: String;

    fClipInfo: tClipInfo;

  protected
    /// <summary><para>Call to execute the thread</para></summary>
    procedure Execute; override;
  public
    /// <summary><para>Constructor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="PasteText">Pasted text<para><b>Type: </b><c>String</c></para></param>
    /// <param name="PasteDetails">Pasted details<para><b>Type: </b><c>String</c></para></param>
    /// <param name="ItemIEN">Documents IEN that text was pasted into<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="EditMonitor">Documents <see cref="U_CPTEditMonitor|TCopyEditMonitor" /> that text was pasted into<para><b>Type: </b><c>TComponent</c></para></param>
    constructor Create(PasteText, PasteDetails: string; ItemIEN: Int64;
      AppMonitor: TComponent; EditMonitor: TObject; ClipInfo: tClipInfo);
    /// <summary><para>Destructor</para></summary>
    destructor Destroy; override;
    /// <summary><para>Item IEN that this thread belongs to</para><para><b>Type: </b><c>Integer</c></para></summary>
    property TheadOwner: Int64 read fItemIEN;
  end;

  TCopyPasteThreadArry = Array of TCopyPasteThread;

implementation

Uses
  U_CPTAppMonitor, U_CPTEditMonitor, U_CPTPasteDetails;

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
      ALength := Length(fCopyPasteThread);
      for x := Index + 1 to ALength - 1 do
        fCopyPasteThread[x - 1] := fCopyPasteThread[x];
      SetLength(fCopyPasteThread, ALength - 1);

      { ALength := Length(fCopyPasteThread);
        Assert(ALength > 0);
        Assert(Index < ALength);
        TailElements := ALength - Index;
        if TailElements > 0 then
        Move(CopyPasteThread[Index + 1], CopyPasteThread[Index],
        SizeOf(CopyPasteThread) * TailElements);

        SetLength(CopyPasteThread, ALength - 1); }
    end;
  end;

begin
  inherited;
  with TCopyApplicationMonitor(fAppMonitor) do
  begin

    for I := high(fCopyPasteThread) downto low(fCopyPasteThread) do
    begin
      if fCopyPasteThread[I] = Self then
      begin
        DeleteX(I);
        LogText('THREAD', 'Thread deleted');
      end;
    end;

  end;

end;

procedure TCopyPasteThread.Execute;
begin
  TCopyApplicationMonitor(fAppMonitor).CriticalSection.Acquire;
  try
    TCopyApplicationMonitor(fAppMonitor).LogText('THREAD',
      'Looking for matches');
    TCopyApplicationMonitor(fAppMonitor).PasteToCopyPasteClipboard(fPasteText,
      fPasteDetails, fItemIEN, fClipInfo);

  finally
    TCopyApplicationMonitor(fAppMonitor).CriticalSection.Release;
  end;
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
      .FCopyMonitor) then
    begin
      if TCopyEditMonitor(TTrackOnlyCollection(Collection).FOwner).FCopyMonitor.Enabled
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

