{*********************************************************}
{*                  OVCSTORE.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcstore;
  {-storage containers for form and component state components}

interface

uses
  Windows, Registry, Classes, Controls, Forms, SysUtils, IniFiles, OvcFiler,
  OvcData, OvcConst;

type
  TOvcReadStrEvent =
    procedure(const Section, Item : string; var Value : string) of object;
  TOvcWriteStrEvent =
    procedure(const Section, Item, Value : string) of object;
  TOvcEraseSectEvent =
    procedure(const Section : string) of object;

  TOvcVirtualStore = class(TOvcAbstractStore)
  protected {private}
    {event variables}
    FOnCloseStore   : TNotifyEvent;
    FOnOpenStore    : TNotifyEvent;
    FOnReadString   : TOvcReadStrEvent;
    FOnWriteString  : TOvcWriteStrEvent;
    FOnEraseSection : TOvcEraseSectEvent;
  protected
    procedure DoOpen; override;
    procedure DoClose; override;
  public
    function ReadString(const Section, Item,
                        DefaultValue : string) : string; override;
    procedure WriteString(const Section, Item, Value : string); override;
    procedure EraseSection(const Section : string); override;
  published
    {events}
    property OnCloseStore : TNotifyEvent read FOnCloseStore write FOnCloseStore;
    property OnOpenStore : TNotifyEvent read FOnOpenStore write FOnOpenStore;
    property OnReadString : TOvcReadStrEvent read FOnReadString
      write FOnReadString;
    property OnWriteString : TOvcWriteStrEvent read FOnWriteString
      write FOnWriteString;
    property OnEraseSection : TOvcEraseSectEvent read FOnEraseSection
      write FOnEraseSection;
  end;

  TOvcRegistryRoot = (rrCurrentUser, rrLocalMachine);
  TOvcRegistryStore = class(TOvcAbstractStore)
  protected {private}
    FKeyName      : string;
    FRegistryRoot : TOvcRegistryRoot;
    FStore        : TRegIniFile;
    function GetKeyName : string;
    procedure SetKeyName(const Value : string);
    procedure DoOpen; override;
    procedure DoClose; override;
  public
    function ReadString(const Section, Item,
                        DefaultValue : string) : string; override;
    procedure WriteString(const Section, Item, Value : string); override;
    procedure EraseSection(const Section : string); override;
  published
    property KeyName : string read GetKeyName write SetKeyName;
    property RegistryRoot : TOvcRegistryRoot read FRegistryRoot
      write FRegistryRoot default rrCurrentUser;
  end;

  TOvcIniFileStore = class(TOvcAbstractStore)
  protected {private}
    FIniFileName : string;
    FStore       : TIniFile;
    FUseExeDir   : Boolean;
    function GetIniFileName : string;
    procedure DoOpen; override;
    procedure DoClose; override;
  public
    function ReadString(const Section, Item,
                        DefaultValue: string) : string; override;
    procedure WriteString(const Section, Item, Value : string); override;
    procedure EraseSection(const Section : string); override;
  published
    property IniFileName : string read GetIniFileName write FIniFileName;
    property UseExeDir : Boolean read FUseExeDir write FUseExeDir
      default False;
  end;

  TElement = class
    ElementName: String;
    Index: Integer;
    ParentIndex: Integer;
    Indent: String;
    Value: String;
    EndingTag: Boolean;
  end;

  TO32XMLFileStore = class(TOvcAbstractStore)
  protected {private}
    FXMLFileName  : string;
    FStore        : TStringList;
    FUseExeDir    : Boolean;
    xsElementList : TList;
    xsTagStart    : Integer;
    xsTagStop     : Integer;
    xsChanged     : Boolean;

    function GetXMLFileName : string;
    procedure DoOpen; override;
    procedure DoClose; override;
    {internal methods}
    procedure xsInitialize;
    procedure xsInitializeElementList;
    function  xsIsValidXMLFile: Boolean;
    procedure xsParseXML;
    function  xsParseElement(BeginPos: Integer): Integer;
    procedure xsAddToElementList(const ElementName: string;
                                 ParentIndex: Integer;
                                 const Indent, Value: string;
                                 EndingTag: Boolean);
    procedure xsInsertInElementList(Index: Integer;
                                    const ElementName: string;
                                    ParentIndex: Integer;
                                    const Indent, Value: string);
    procedure xsDeleteFromElementList(Index: Integer);
    procedure xsWriteXMLFile;
    function  xsStripElement(const Element: string): string;
    function  xsGetIndentOf(ElementIndex: Integer): String;
    function  xsGetFStoreIndentOf(Index: Integer): string;
    function  xsGetFStoreValueOf(Index: Integer): String;
    function  xsFindElement(const Item: String; StartAt: Integer): Integer;
    procedure xsAdjustParentIndex(StartingAt: Integer; Inc: Boolean);
    function  xsFindClosingTag(OpeningTagIndex: Integer): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function ReadString(const Section, Item,
                        DefaultValue : string): string; override;
    procedure WriteString(const Section, Item, Value : string); override;
    procedure   WriteBoolean (const Parent, Element: string; Value: Boolean);
    procedure   WriteInteger (const Parent, Element: string; Value: Integer);
    procedure   WriteStr     (const Parent, Element: string; const Value: string);
    function    ReadBoolean  (const Parent, Element: string): Boolean;
    function    ReadInteger  (const Parent, Element: string): Integer;
    function    ReadStr      (const Parent, Element,
                              DefaultValue: string): string;
    procedure   EraseSection (const Section : string); override;
  published
    property XMLFileName : string   read GetXMLFileName write FXMLFileName;
    property UseExeDir   : Boolean  read FUseExeDir     write FUseExeDir
      default False;
  end;

implementation

{===== TOvcVirtualStore ==============================================}

procedure TOvcVirtualStore.DoClose;
begin
  if Assigned(FOnCloseStore) then
    FOnCloseStore(Self);
end;


procedure TOvcVirtualStore.DoOpen;
begin
  if Assigned(FOnOpenStore) then
    FOnOpenStore(Self);
end;

procedure TOvcVirtualStore.EraseSection(const Section : string);
begin
  if Assigned(FOnEraseSection) then
    FOnEraseSection(Section);
end;

function TOvcVirtualStore.ReadString(const Section, Item,
                                     DefaultValue : string) : string;
begin
  Result := DefaultValue;
  if Assigned(FOnReadString) then
    FOnReadString(Section, Item, Result);
end;

procedure TOvcVirtualStore.WriteString(const Section, Item, Value : string);
begin
  if Assigned(FOnWriteString) then
    FOnWriteString(Section, Item, Value);
end;


{===== TOvcRegistryStore =============================================}

procedure TOvcRegistryStore.DoClose;
begin
  FStore.CloseKey;
  FStore.Free;
end;

procedure TOvcRegistryStore.EraseSection(const Section : string);
begin
  FStore.EraseSection(Section);
end;

function TOvcRegistryStore.GetKeyName : string;
begin
  Result := FKeyName;
  if (Result = '') and not (csDesigning in ComponentState) then
    Result := 'Software\'
    + ExtractFileName(ChangeFileExt(Application.ExeName, ''))
end;

procedure TOvcRegistryStore.DoOpen;
begin
  FStore := TRegIniFile.Create(KeyName);
  FStore.CloseKey;
  case FRegistryRoot of
    rrCurrentUser  : FStore.RootKey := HKEY_CURRENT_USER;
    rrLocalMachine : FStore.RootKey := HKEY_LOCAL_MACHINE;
  end;
  FStore.OpenKey(GetKeyName, True);
end;

function TOvcRegistryStore.ReadString(const Section, Item,
                                      DefaultValue : string) : string;
begin
  Result := FStore.ReadString(Section, Item, DefaultValue);
end;

procedure TOvcRegistryStore.SetKeyName(const Value : string);
begin
  if Value <> FKeyName then begin
    FKeyName := Value;
    {strip leading andtrailing slashes}
    while (Length(FKeyName) > 0) and (FKeyName[1] = '\') do
      Delete(FKeyName, 1, 1);
    while (Length(FKeyName) > 0) and (FKeyName[Length(FKeyName)] = '\') do
      Delete(FKeyName, Length(FKeyName), 1);
  end;
end;

procedure TOvcRegistryStore.WriteString(const Section, Item, Value : string);
begin
  FStore.WriteString(Section, Item, Value);
end;

{===== TOvcIniFileStore ==============================================}

procedure TOvcIniFileStore.DoClose;
begin
  FStore.Free;
  FStore := nil;
end;

procedure TOvcIniFileStore.EraseSection(const Section : string);
begin
  FStore.EraseSection(Section);
end;

function TOvcIniFileStore.GetIniFileName : string;
begin
  Result := FIniFileName;
  if (Result = '') and not (csDesigning in ComponentState) then
    Result := ExtractFileName(ChangeFileExt(Application.ExeName, '.INI'));
  if not (csDesigning in ComponentState) then
    if Pos('.', Result) = 0 then
      Result := Result + '.INI';
end;

procedure TOvcIniFileStore.DoOpen;
var
  S : string;
  P : string;
begin
  S := GetIniFileName;
  if FUseExeDir then begin
    P := ExtractFilePath(ParamStr(0));
    if (Length(P) > 0) then begin
      if P[Length(P)] <> '\' then
        P := P + '\';
    end;
    S := P + ExtractFileName(S);
  end;
  FStore := TIniFile.Create(S);
end;

function TOvcIniFileStore.ReadString(const Section, Item,
                                     DefaultValue : string) : string;
begin
  Result := FStore.ReadString(Section, Item, DefaultValue);
end;

procedure TOvcIniFileStore.WriteString(const Section, Item, Value : string);
begin
  FStore.WriteString(Section, Item, Value);
end;

{===== TO32XMLFileStore ==============================================}

(*
   Sample file.  All files must adhere to this format or they will not be read
   by the storage component.  This component is not for implementing full-blown
   XML capabilities.

<?xml version='1.0' encoding='us-ascii' ?>
<!-- Orpheus TO32XMLStore Data File -->
<FORMS>
  <TForm1>
    <Bevel2>
      <Width value="201"/>
      <Visible value="True"/>
      <Top value="48"/>
      <Tag value="0"/>
      <Style value="bsLowered"/>
      <ShowHint value="False"/>
      <Shape value="bsBox"/>
      <ParentShowHint value="True"/>
      <Name value="Bevel2"/>
      <Left value="8"/>
      <Hint value="booboo"/>
      <Height value="305"/>
      <Cursor value="0"/>
      <ConstraintsMaxHeight value="0"/>
      <ConstraintsMaxWidth value="0"/>
      <ConstraintsMinHeight value="0"/>
      <ConstraintsMinWidth value="0"/>
      <Anchors value="[akLeft,akTop]"/>
      <Align value="alNone"/>
    </Bevel2>
    <Button1>
      <Width value="123"/>
      <Visible value="True"/>
      <Top value="8"/>
      <Tag value="0"/>
      <TabStop value="True"/>
      <TabOrder value="0"/>
      <ShowHint value="False"/>
      <ParentShowHint value="True"/>
      <ParentFont value="True"/>
      <ParentBiDiMode value="True"/>
      <Name value="Button1"/>
      <ModalResult value="0"/>
      <Left value="96"/>
      <Hint value="Smokin!"/>
      <HelpContext value="0"/>
      <Height value="25"/>
      <FontCharset value="1"/>
      <FontColor value="-2147483640"/>
      <FontHeight value="-11"/>
      <FontName value="MS Sans Serif"/>
      <FontPitch value="fpDefault"/>
      <FontSize value="8"/>
      <FontStyle value="[]"/>
      <Enabled value="True"/>
      <DragMode value="dmManual"/>
      <DragKind value="dkDrag"/>
      <DragCursor value="-12"/>
      <Default value="False"/>
      <Cursor value="0"/>
      <ConstraintsMaxHeight value="0"/>
      <ConstraintsMaxWidth value="0"/>
      <ConstraintsMinHeight value="0"/>
      <ConstraintsMinWidth value="0"/>
      <Caption value="Load XML File"/>
      <Cancel value="False"/>
      <BiDiMode value="bdLeftToRight"/>
      <Anchors value="[akLeft,akTop]"/>
    </Button1>
  </TForm1>
</FORMS>
*)

constructor TO32XMLFileStore.Create(AOwner: TComponent);
begin
  xsElementList := TList.Create;
  xsChanged := false;
  inherited;
end;
{=====}

destructor TO32XMLFileStore.Destroy;
var
  I: Integer;
begin
  for I := 0 to xsElementList.Count - 1 do
    TElement(xsElementList.Items[I]).Free;
  xsElementList.Free;
  xsElementList := nil;
  inherited;
end;
{=====}

function TO32XMLFileStore.GetXMLFileName : string;
begin
  Result := FXMLFileName;
  if (Result = '') and not (csDesigning in ComponentState) then
    Result := ExtractFileName(ChangeFileExt(Application.ExeName, '.XML'));
  if not (csDesigning in ComponentState) then
    if Pos('.', Result) = 0 then
      Result := Result + '.XML';
end;
{=====}

procedure TO32XMLFileStore.DoOpen;
var
  S : string;
  P : string;
begin
  S := GetXMLFileName;

  if FUseExeDir then begin
    P := ExtractFilePath(ParamStr(0));
    if (Length(P) > 0) then begin
      if P[Length(P)] <> '\' then
        P := P + '\';
    end;
    S := P + ExtractFileName(S);
  end;

  FStore := TStringList.Create;
  if FileExists(S) then
    FStore.LoadFromFile(S);
  xsInitialize;
end;
{=====}

procedure TO32XMLFileStore.DoClose;
begin
  if xsChanged then
    xsWriteXMLFile;

  while xsElementList.Count > 0 do begin
    TElement(xsElementList.Items[0]).Free;
    xsElementList.Delete(0);
  end;

  FStore.Free;
  FStore := nil;
end;
{=====}

{ Parses the XML Document and creates the xsElementList }
procedure TO32XMLFileStore.xsParseXML;
{var
  I       : Integer;}
begin
  xsInitializeElementList;
  { add the anchor tags to the list. }
  xsAddToElementList(xsStripElement(FStore[xsTagStart]), -1, '', '', false);
  { Parse its children and add them to the list }
  if xsParseElement(xsTagStart) <> xsTagStop then
    { parsing ended at an unexpected location. }
    raise Exception.Create(GetOrphStr(SCInvalidXMLFile));
end;
{=====}

{ Parses the element and returns the index of its ending tag }
function TO32XMLFileStore.xsParseElement(BeginPos: Integer): Integer;
var
  I : Integer;
begin
  { assume the worst }
  Result := -1;
  I := BeginPos + 1;
  while I <= xsTagStop do begin
    if (Pos('value=', FStore[I]) > 0) or (Pos('value =', FStore[I]) > 0) then
      { If its a child element with an attribute then... }
      xsAddToElementList(xsStripElement(FStore[I]), BeginPos,
        xsGetFStoreIndentOf(I), xsGetFStoreValueOf(I), false)
    else begin
      if Pos('</', FStore[I]) > 0 then begin
        { If its the end of this element then... }
        xsAddToElementList('/' + xsStripElement(FStore[I]), BeginPos,
          xsGetFStoreIndentOf(I), '', true);
        result := I;
        Exit;
      end else begin
      { its a child element with no attributes then... }
        xsAddToElementList(xsStripElement(FStore[I]), BeginPos,
          xsGetFStoreIndentOf(I), xsGetFStoreValueOf(I), false);
        I := xsParseElement(I);
      end;
    end;
    Inc(I);
  end;
end;
{=====}

procedure TO32XMLFileStore.xsInitializeElementList;
begin
  { Clear xsElementList }
  while xsElementList.Count > 0 do begin
    TElement(xsElementList.Items[0]).Free;
    xsElementList.Delete(0);
  end;
end;
{=====}

function TO32XMLFileStore.xsIsValidXMLFile: Boolean;
var
  I: Integer;
begin
  xsTagStart := -1;
  xsTagStop := -1;

  if FStore.Count > 0 then begin
    { Locate the start of our XML file }
    for I := 0 to FStore.Count - 1 do begin
      if Pos('<FORMS>', AnsiUppercase(FStore[I])) > 0 then begin
        xsTagStart := I;
        Break;
      end;
    end;

    { Locate the end of our XML file }
    if xsTagStart > -1 then
      for I := FStore.Count - 1 downto xsTagStart do begin
        if Pos('</FORMS>', AnsiUppercase(FStore[I])) > 0 then begin
          xsTagStop := I;
          Break;
        end;
      end;
  end;

  result := not((xsTagStart = -1) or (xsTagStop < xsTagStart));
end;
{=====}

procedure TO32XMLFileStore.xsWriteXMLFile;
var
  I             : Integer;
  TagStr, P, S  : String;
  Element       : TElement;
  ClosingTagLoc : Integer;
begin
  { Build filename }
  S := GetXMLFileName;

  if FUseExeDir then begin
    P := ExtractFilePath(ParamStr(0));
    if (Length(P) > 0) then begin
      if P[Length(P)] <> '\' then
        P := P + '\';
    end;
    S := P + ExtractFileName(S);
  end;

  { Delete tags from FStore }
  for I := xsTagStop downto xsTagStart do
    FStore.Delete(I);

  { Iterate through the ElementList, writing the tags into FStore }
  for I := 0 to xsElementList.Count -1 do begin
    Element := xsElementList[I];
    { Build TagString }
    TagStr := Element.Indent + '<';

    TagStr := TagStr + Element.ElementName;


    if Element.Value = '' then begin
      { If this element's value is empty then find it's closing tag }
      ClosingTagLoc := xsFindClosingTag(I);
      { if the closing tag is either not found and this isn't a closing tag }
      { then... }
      if (ClosingTagLoc <= I) and (Element.ElementName[1] <> '/') then
        { add an empty value to this tag and terminate it. }
        TagStr := TagStr + ' value=""/>'
      else
        { Otherwise, leave it alone }
        TagStr := TagStr + '>';
    end else
     { otherwise write it as it appears. }
      TagStr := TagStr + ' value="' + Element.Value + '"/>';

    FStore.Insert(xsTagStart + I, TagStr);
  end;

  FStore.SaveToFile(S);
end;
{=====}

function TO32XMLFileStore.ReadString(const Section, Item,
                                     DefaultValue : string): string;
var
  {Str: string;}
  Location: Integer;
begin
  { assume the worst. }
  result := DefaultValue;

  { Find form }
  Location := xsFindElement(Section, 0);
  if Location > -1 then begin
    { If the form is found then recursively search for the desired tag }
    Location := xsFindElement(Item, Location);
    { If the tag was found then return the value of the element at the tag's }
    { location. }
    if Location > -1 then
      result := TElement(xsElementList.Items[Location]).Value;
  end;
end;
{=====}

function TO32XMLFileStore.xsFindElement(const Item: String; StartAt: Integer): Integer;
var
  Path: string;
  ElementName: string;
  I : Integer;
  ParentElement: string;
begin
  { assume the worst }
  result := -1;
  Path := Item;
  ParentElement := TElement(xsElementList.Items[StartAt]).ElementName;
  { Strip out the name of this element from the Item list. }
  if Pos('.', Path) > 0 then begin
    ElementName := Copy(Path, 1, Pos('.', Path) - 1);
    Delete(Path, 1, Pos('.', Path));
  end else begin
    ElementName := Path;
    Path := '';
  end;
  { iterate through the parent's items, looking for a match... }
  for I := StartAt to xsElementList.Count - 1 do begin
    if AnsiUppercase(TElement(xsElementList.Items[I]).ElementName)
      = AnsiUppercase(ElementName) then
    begin
      { if a match was found and there are no more elements in the list then }
      { return the index of the found element. }
      if Path = '' then begin
        result := I;
        exit;
      end else begin
      { if a match was found and there are more elements to locate, then keep }
      { going. }
        result := xsFindElement(Path, I);
        exit;
      end;
    end
    else
      { if we come to the parent element's closing tag, then the element was }
      { not found.  Return -1 and bail out. }
      if AnsiUppercase(TElement(xsElementList.Items[I]).ElementName)
        = '/' + AnsiUppercase(ParentElement) then
      begin
        result := -1;
        exit;
      end;
  end;
end;
{=====}

procedure TO32XMLFileStore.WriteString(const Section, Item, Value : string);
var
  ItemList, ElementName : string;
  FormLocation   : Integer;
  InsertPoint: Integer;
  LastFoundParent: Integer;
  ParentIndent: String;
  Temp: Integer;
  EndingTagLoc: Integer;
begin
  ItemList := Item;

  { Find form }
  FormLocation := xsFindElement(Section, 0);
  { If the form wasn't found then add it }
  if FormLocation = -1 then begin
    xsInsertInElementList(xsElementList.Count - 1, Section, 0, '  ', '');
    FormLocation := xsFindElement(Section, 0);
  end;

  if FormLocation > -1 then begin
    LastFoundParent := FormLocation;
    ParentIndent := '  ';
    { iterate through the item list, inserting those which don't exist. }
    while ItemList <> '' do begin
      if Pos('.', ItemList) > 0 then begin
        ElementName := copy(ItemList, 1, Pos('.', ItemList) - 1);

        Delete(ItemList, 1, Pos('.', ItemList));
      end else begin
        ElementName := ItemList;
        ItemList := '';
      end;

      Temp := xsFindElement(ElementName, LastFoundParent);

      if (ItemList <> '') and (Temp > -1) then begin
        LastFoundParent := Temp;
        ParentIndent := TElement(xsElementList.Items[Temp]).Indent;
      end
      else begin
        { add an item to LastFoundParent }
        if (ItemList = '') then begin
          { We have burrowed down to the end of the list and are adding or }
          { modifying the target item }
          if Temp > 0 then { Make sure we don't try to update the anchor tag }
            { the item exists so we're just updating it }

            { if the tag currently has no value then make sure it doesn't have }
            { any children.}
            if TElement(xsElementList.Items[Temp]).Value = '' then begin
              EndingTagLoc := xsFindClosingTag(Temp);
              { if it's a compound tag with no children then we can delete the }
              { closing tag and update it without any problems }
              if EndingTagLoc = Temp + 1 then begin
                { It's a parent tag with no children so we can delete its }
                { closing tag and update it }
                xsAdjustParentIndex(EndingTagLoc, false);
                xsDeleteFromElementList(EndingTagLoc);
                TElement(xsElementList.Items[Temp]).Value := Value
       end else if (EndingTagLoc = Temp) or (EndingTagLoc = -1) then
                { It is a regular tag that just happens to have an empty value }
                { so go ahead and update it }
                TElement(xsElementList.Items[Temp]).Value := Value
            end else
              TElement(xsElementList.Items[Temp]).Value := Value
          else begin
            { the item doesn't exist so we're inserting it at the end of the }
            { parent's items }
            InsertPoint := xsFindClosingTag(LastFoundParent);
            xsInsertInElementList(InsertPoint, ElementName, LastFoundParent,
            ParentIndent + '  ', Value);
          end;
        end else begin
          { We haven't burrowed down to the end of the list yet but we have }
          { stumbled upon an item that doesn't exist in the list so we need to }
          { add it. }
          InsertPoint := xsFindClosingTag(LastFoundParent);
          xsInsertInElementList(InsertPoint, ElementName, LastFoundParent,
            ParentIndent + '  ', '');
          LastFoundParent := InsertPoint;
          ParentIndent := TElement(xsElementList.Items[InsertPoint]).Indent;
        end;
      xsChanged := true;
      end;
    end;
  end else
    raise Exception.Create('Error creating tag entry');
end;
{=====}

function TO32XMLFileStore.xsFindClosingTag(OpeningTagIndex: Integer): Integer;
var
  I: Integer;
  ElementName: string;
begin
  { if this is a self contained tag, then return the passed in index... }
  {if (TElement(xsElementList.Items[OpeningTagIndex]).value <> '') then
    result := OpeningTagIndex;}

  { otherwise, Get the name of the element for which we're searching for a }
  { closing tag . }
  ElementName := AnsiUppercase(
    TElement(xsElementList.Items[OpeningTagIndex]).ElementName);

  { assume the worst... }
  result := -1;

  { spin through the element's children, looking for its closing tag... }
  for I := OpeningTagIndex + 1 to xsElementList.Count - 1 do begin
    if AnsiUppercase(TElement(xsElementList.Items[I]).ElementName) = '/'
      + ElementName then
    begin
      result := I;
      break;
    end;
  end;
end;
{=====}

procedure TO32XMLFileStore.xsAddToElementList(const ElementName: string;
                                              ParentIndex: Integer;
                                              const Indent, Value: string;
                                              EndingTag: Boolean);
var
  Element: TElement;
begin
  Element := TElement.Create;
  Element.ElementName := ElementName;
  Element.ParentIndex := ParentIndex;
  Element.Indent := Indent;
  Element.Value := Value;
  Element.EndingTag := EndingTag;
  xsElementList.Add(Element);
end;
{=====}

procedure TO32XMLFileStore.xsDeleteFromElementList(Index: Integer);
begin
  { Free the element object at the specified index... }
  TElement(xsElementList.Items[Index]).Free;
  { Delete the item from the TList }
  xsElementList.Delete(Index);
  xsChanged := true;
end;
{=====}

function TO32XMLFileStore.xsGetFStoreValueOf(Index: Integer): String;
var
  Rslt, Str: String;
  Start, Stop: Integer;
  I : Integer;
  Done: Boolean;
  QuoteChar: Char;
begin
  Str := FStore[Index];
  Stop := -1;

  if Pos(#34, Str) > 0 then
    QuoteChar := #34  {"}
  else if Pos(#39, Str) > 0 then
    QuoteChar := #39 {'}
  else exit;

  { find beginning of value }
  Start := Pos(QuoteChar, FStore[Index]) + 1;

  { Find end of value }
  I := Length(Str);
  Done := false;
  while not done and (I > 0) do begin
    if Str[I] = QuoteChar then begin
      Stop := I;
      Done := true;
    end else
      Dec(I);
  end;

  if I = 0 then
    raise Exception.Create(GetOrphStr(SCUnterminatedElement));

  Rslt := Copy(Str, Start, Stop - Start);
  result := Rslt;
end;
{=====}

procedure TO32XMLFileStore.xsInsertInElementList(Index: Integer;
                                                 const ElementName: string;
                                                 ParentIndex: Integer;
                                                 const Indent, Value: string);
var
  Element: TElement;
  {Parent: Boolean;}
begin
  { Create new element object... }
  Element := TElement.Create;
  { Set its values... }
  Element.ElementName := ElementName;
  Element.ParentIndex := ParentIndex;
  Element.Indent := Indent;
  Element.Value := Value;
  Element.EndingTag := false;
  { pre-emptively adjust the parent indexes of all remaining objects... }
  xsAdjustParentIndex(Index, True);
  { Insert our new object in the list at the sepcified location... }
  xsElementList.Insert(Index, Element);

  { Insert an ending tag for the newly inserted parent... }
  if Value = '' then begin
    {Element := nil;}
    Element := TElement.Create;
    Element.ElementName := '/' + ElementName;
    Element.ParentIndex := Index;
    Element.Indent := Indent;
    Element.Value := '';
    Element.EndingTag := true;
    xsAdjustParentIndex(Index + 1, True);
    xsElementList.Insert(Index + 1, Element);
  end;
end;
{=====}

procedure TO32XMLFileStore.xsAdjustParentIndex(StartingAt: Integer; Inc: Boolean);
var
  I : Integer;
  J : Integer;
  {ParentName : string;}
begin
  for I := StartingAt to xsElementList.Count - 1 do begin
    { if this is a parent element, then... }
    if TElement(xsElementList.Items[I]).Value = '' then begin
      {ParentName := TElement(xsElementList.Items[I]).ElementName;}
      { spin through its children, incrementing ParentIndex by one... }
      for J := I + 1 to xsElementList.Count - 1 do begin
        if TElement(xsElementList.Items[J]).ParentIndex = I then
          if Inc then
            TElement(xsElementList.Items[J]).ParentIndex := I + 1
          else
            TElement(xsElementList.Items[J]).ParentIndex := I - 1;
      end;
    end;
  end;
end;
{=====}

procedure TO32XMLFileStore.EraseSection(const Section : string);
var
  I, StartPos, StopPos: Integer;
begin
  { If we can find the section to delete... }
  StartPos := xsFindElement(Section, 0);
  if StartPos > -1 then begin
    { Find its ending tag }
    StopPos := xsFindClosingTag(StartPos);
    if StopPos = StartPos then begin
      xsAdjustParentIndex(StartPos, False);
      xsDeleteFromElementList(StartPos);
    end else begin
      for I := StopPos downto StartPos do begin
        xsAdjustParentIndex(I, False);
        xsDeleteFromElementList(I);
      end;
    end;
  end;
end;
{=====}

function TO32XMLFileStore.xsStripElement(const Element: string): string;
var
  Str: string;
begin
  { Strips all extranneous tag characters from the element, leaving just the }
  { element's name. }
  Str := Element;
  { Remove any leading spaces... }
  while Str[1] = ' ' do
    Delete(Str, 1, 1);
  if Str <> '' then begin
    if Str[1] = '<' then Delete(Str, 1, 1);
    if Str[Length(Str)] = '>' then Delete(Str, Length(Str), 1);
    while Pos('/', Str) > 0 do
      Delete(Str, Pos('/', Str), 1);
    if Str[Length(Str)] = '/' then Delete(Str, Length(Str), 1);
    if Pos(' ', Element) > 0 then Delete(Str, Pos(' ', Str),
      Length(Str));
  end;
  result := Str;
end;
{=====}


function TO32XMLFileStore.xsGetIndentOf(ElementIndex: Integer): String;
begin
  if (ElementIndex > 0) and (ElementIndex < xsELementList.Count - 1) then
    result := TElement(xsElementList[ElementIndex]).Indent
  else
    result := '';
end;
{=====}

function TO32XMLFileStore.xsGetFStoreIndentOf(Index: Integer): string;
var
 Str: string;
 I: Integer;
begin
  I := 1;
  Str := '';
  while FStore[Index][I] = #32 do begin
    Str := Str + #32;
    Inc(I);
  end;
  result := Str;
end;
{=====}

procedure TO32XMLFileStore.xsInitialize;
{var}
  {I: Integer;}
  {Acceptable: Boolean;}
begin
  if not xsIsValidXMLFile then begin
    FStore.Insert(0, '<?xml version=''1.0'' encoding=''us-ascii'' ?>');
    FStore.Insert(1, '<!-- Orpheus TO32XMLStore Data File -->');
    FStore.Insert(2, '<FORMS>');
    FStore.Insert(3, '</FORMS>');

    if not xsIsValidXMLFile then
      raise Exception.Create(GetOrphStr(SCInvalidXMLFile))
    else begin
      { Load the list... }
      xsParseXML;
      { mark dirty }
      xsChanged := true;
    end;
  end else begin
    { Load the list... }
    xsParseXML;
    xsChanged := False;
  end;
end;
{=====}

procedure TO32XMLFileStore.WriteBoolean(const Parent,
                                        Element: string; Value: Boolean);
begin
  if Value then
    WriteString(Parent, Element, '1')
  else
    WriteString(Parent, Element, '0');
end;
{=====}

procedure TO32XMLFileStore.WriteInteger(const Parent,
                                        Element: string; Value: Integer);
begin
  WriteString(Parent, Element, IntToStr(Value));
end;
{=====}

procedure TO32XMLFileStore.WriteStr(const Parent,
                                    Element: string; const Value: string);
begin
  WriteString(Parent, Element, Value);
end;
{=====}

function TO32XMLFileStore.ReadBoolean(const Parent, Element: string): Boolean;
begin
  result := (ReadString(Parent, Element, '0') = '1');
end;
{=====}

function TO32XMLFileStore.ReadInteger(const Parent, Element: string): Integer;
begin
  result := StrToInt(ReadString(Parent, Element, '-1'));
end;
{=====}

function TO32XMLFileStore.ReadStr(const Parent, Element,
                                  DefaultValue: string): string;
begin
  result := ReadString(Parent, Element, DefaultValue);
end;
{=====}

end.
