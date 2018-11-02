unit uROR_SearchEdit;

interface

uses
  ActnList, Buttons, Classes, Controls, Dialogs, ExtCtrls, Forms, Graphics,
  StdCtrls, SysUtils, Windows, uROR_GridView, uROR_Selector;

type

  TCCRValidateCode = (vcOk, vcInvalid, vcTooShort);

  TCCRInlineEdit = class(TCustomEdit)
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    property Text;

  published
    //property Anchors;
    property AutoSelect;
    //property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    //property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    //property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    //property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    //property Visible;

    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

  end;

  TCCRSearchCommand = (cscContinue, cscFinish, cscCancel);

  TCCRSearchEvent = procedure(aSender: TObject; var aCommand: TCCRSearchCommand) of object;
  TCCRValidateEvent = procedure(aSender: TObject; var aMessage: String) of object;

  TCCRSearchEdit = class(TCustomPanel)
  private
    fCancelAction:   TCustomAction;
    fEdit:           TCCRInlineEdit;
    fEditColor:      TColor;
    fEnableCancel:   Boolean;
    fGoButton:       TSpeedButton;
    fMinLength:      Word;
    fOnSearch:       TCCRSearchEvent;
    fOnSearchEnd:    TCCRSearchEvent;
    fOnSearchStart:  TCCRSearchEvent;
    fOnValidate:     TCCRValidateEvent;
    fSearchCursor:   TCursor;
    fSearching:      Boolean;

    procedure ButtonClick(aSender: TObject);
    function  getMaxLength: Word;
    procedure setCancelAction(anAction: TCustomAction);
    procedure setMaxLength(const aValue: Word);
    procedure setSearching(const aValue: Boolean);

  protected
    procedure DoEnter; override;
    procedure DoSearch(var aCommand: TCCRSearchCommand); virtual;
    procedure DoSearchEnd(var aCommand: TCCRSearchCommand); virtual;
    procedure DoSearchStart(var aCommand: TCCRSearchCommand); virtual;
    function  getModified: Boolean; virtual;
    function  getText: String; virtual;
    procedure Loaded; override;
    procedure Resize; override;
    procedure SetEnabled(aValue: Boolean); override;
    procedure SetName(const NewName: TComponentName); override;
    procedure setModified(aValue: Boolean); virtual;
    procedure setText(aValue: String); virtual;

    property GoButton: TSpeedButton          read fGoButton;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    procedure CancelSearch; virtual;
    function  Search: Boolean; virtual;
    function  Validate(var aMessage: String): TCCRValidateCode; virtual;

    property Modified: Boolean               read    getModified
                                             write   setModified;

    property Searching: Boolean              read    fSearching
                                             write   setSearching;

  published
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    //property BevelInner;
    //property BevelOuter;
    //property BevelWidth;
    //property BiDiMode;
    //property BorderWidth;
    //property BorderStyle;
    //property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    //property UseDockManager default True;
    //property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    //property Locked;
    //property ParentBiDiMode;
    {$IFDEF VERSION7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    //property OnDockDrop;
    //property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    //property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    //property OnUnDock;

    property CancelAction: TCustomAction     read    fCancelAction
                                             write   setCancelAction;

    property Edit: TCCRInlineEdit            read    fEdit;

    property EnableCancel: Boolean           read    fEnableCancel
                                             write   fEnableCancel
                                             default False;

    property MaxLength: Word                 read    getMaxLength
                                             write   setMaxLength;

    property MinLength: Word                 read    fMinLength
                                             write   fMinLength;

    property SearchCursor: TCursor           read    fSearchCursor
                                             write   fSearchCursor;

    property OnSearch: TCCRSearchEvent       read    fOnSearch
                                             write   fOnSearch;

    property OnSearchEnd: TCCRSearchEvent    read    fOnSearchEnd
                                             write   fOnSearchEnd;

    property OnSearchStart: TCCRSearchEvent  read    fOnSearchStart
                                             write   fOnSearchStart;

    property OnValidate: TCCRValidateEvent   read    fOnValidate
                                             write   fOnValidate;

    property Text: String                    read    getText
                                             write   setText;

  end;

  TCCRVistASearchEdit = class(TCCRSearchEdit)
  private
    fRawData:            TStringList;
    fSearchFromIndex:    Integer;
    fSearchGrid:         TCCRGridView;
    fSearchMaxCount:     Integer;
    fSearchRPCName:      String;
    fSearchSelector:     TCCRSelector;
    fSearchStrPerItem:   Integer;
    fSuspendGridUpdates: Boolean;

    function  getSearchFields: String;
    procedure setSearchFields(const aValue: String);

  protected
    procedure DoSearchStart(var aCommand: TCCRSearchCommand); override;
    procedure Notification(aComponent: TComponent; Operation: TOperation); override;

  public
    SearchCount:       Integer;
    SearchFieldsArray: array of Integer;
    SearchParams:      array of String;

    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    function  Search: Boolean; override;
    procedure SetParams(Params: array of String);

    property RawData: TStringList            read    fRawData;

  published
    property SearchFields: String            read    getSearchFields
                                             write   setSearchFields;

    property SearchFromIndex: Integer        read    fSearchFromIndex
                                             write   fSearchFromIndex
                                             default -1;

    property SearchGrid: TCCRGridView        read    fSearchGrid
                                             write   fSearchGrid;

    property SearchMaxCount: Integer         read    fSearchMaxCount
                                             write   fSearchMaxCount
                                             default 0;

    property SearchRPCName: String           read    fSearchRPCName
                                             write   fSearchRPCName;

    property SearchSelector: TCCRSelector    read    fSearchSelector
                                             write   fSearchSelector;

    property SearchStrPerItem: Integer       read    fSearchStrPerItem
                                             write   fSearchStrPerItem
                                             default 1;

    property SuspendGridUpdates: Boolean     read     fSuspendGridUpdates
                                             write    fSuspendGridUpdates
                                             default  True;

  end;

implementation

uses
  uROR_Resources, uROR_Utilities;

///////////////////////////////// TCCRInlineEdit \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRInlineEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key in [VK_RETURN, VK_DOWN]) and Assigned(Owner) then
    if Owner is TCCRSearchEdit then
      TCCRSearchEdit(Owner).Search;
end;

///////////////////////////////// TCCRSearchEdit \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRSearchEdit.Create(anOwner: TComponent);
begin
  inherited;

  LoadCCREditSearchResources;

  fEdit          := TCCRInlineEdit.Create(Self);
  fGoButton      := TSpeedButton.Create(Self);

  AutoSize       := False;
  BevelInner     := bvNone;
  BevelOuter     := bvNone;
  BorderStyle    := bsSingle;
  Caption        := '';
  DockSite       := False;
  ParentBiDiMode := True;
  Searching      := False;

  Constraints.MinHeight := 16;
  Constraints.MinWidth  := 16;

  with Edit do
    begin
      SetSubComponent(True);
      Parent      := Self;
      BorderStyle := bsNone;
      Name        := 'Edit';
      Text        := '';
    end;

  with GoButton do
    begin
      SetSubComponent(True);
      Parent  := Self;

      Name           := 'Search';
      Caption        := '';
      Flat           := False;
      Glyph          := bmSearchStart;
      Hint           := RSC0012;
      OnClick        := ButtonClick;
      ParentShowHint := True;
      Visible        := True;
    end;

  SetBounds(Left, Top, Edit.Width + Edit.Height + 2, Edit.Height + 2);
end;

destructor TCCRSearchEdit.Destroy;
begin
  fCancelAction := nil;
  with fGoButton do
    begin
      Action := nil;
      Glyph  := nil;
    end;
  FreeAndNil(fEdit);
  FreeAndNil(fGoButton);
  inherited;
end;

procedure TCCRSearchEdit.ButtonClick(aSender: TObject);
begin
  if Searching then
    CancelSearch
  else
    Search;
end;

procedure TCCRSearchEdit.CancelSearch;
begin
  Searching := False;
end;

procedure TCCRSearchEdit.DoEnter;
begin
  inherited;
  Edit.SetFocus;
end;

procedure TCCRSearchEdit.DoSearch(var aCommand: TCCRSearchCommand);
begin
  if Assigned(OnSearch) then
    OnSearch(Self, aCommand);
end;

procedure TCCRSearchEdit.DoSearchEnd(var aCommand: TCCRSearchCommand);
begin
  if Assigned(OnSearchEnd) then
    OnSearchEnd(Self, aCommand);
end;

procedure TCCRSearchEdit.DoSearchStart(var aCommand: TCCRSearchCommand);
begin
  if Assigned(OnSearchStart) then
    OnSearchStart(Self, aCommand);
end;

function TCCRSearchEdit.getMaxLength: Word;
begin
  if Assigned(Edit) then
    Result := Edit.MaxLength
  else
    Result := 0;
end;

function TCCRSearchEdit.getModified: Boolean;
begin
  if Assigned(Edit) then
    Result := Edit.Modified
  else
    Result := False;
end;

function TCCRSearchEdit.getText: String;
begin
  if Assigned(Edit) then
    Result := Edit.Text
  else
    Result := '';
end;

procedure TCCRSearchEdit.Loaded;
begin
  inherited;
  if Assigned(Edit) and Edit.ParentColor then
    begin
      Edit.ParentColor := False;  // Enforce correct Parent Color
      Edit.ParentColor := True;
    end;
  Resize;
end;

procedure TCCRSearchEdit.Resize;
begin
  inherited;
  Edit.SetBounds(0, 0, ClientWidth - ClientHeight, ClientHeight);
  GoButton.SetBounds(Edit.Width, 0, ClientHeight, ClientHeight);
end;

function TCCRSearchEdit.Search: Boolean;
var
  vc: TCCRValidateCode;
  cmd: TCCRSearchCommand;
  oldCursor: TCursor;
  restoreCursor: Boolean;
  aMsg: String;
begin
  Result := False;

  vc := Validate(aMsg);
  case vc of
    vcTooShort:
      MessageDlg(Format(RSC0010, [MinLength]), mtWarning, [mbOK], 0);
    vcInvalid:
      MessageDlg(RSC0011 + #13 + aMsg, mtWarning, [mbOK], 0);
    vcOk:
      begin
        cmd := cscContinue;
        oldCursor := Screen.Cursor;
        if Screen.Cursor <> SearchCursor then
          begin
            Screen.Cursor := SearchCursor;
            restoreCursor := True;
          end
        else
          restoreCursor := False;
        Searching := True;
        try
          DoSearchStart(cmd);
          if cmd = cscContinue then
            begin
              repeat
                Application.ProcessMessages;
                if not Searching then
                  begin
                    cmd := cscCancel;
                    Break;
                  end;
                DoSearch(cmd);
              until cmd <> cscContinue;
            end;
        finally
          Searching := False;
          if restoreCursor then
            Screen.Cursor := oldCursor;
        end;
        DoSearchEnd(cmd);
        Result := (cmd <> cscCancel);
      end;
  end;
  if not Result then
    Edit.SetFocus;
end;

procedure TCCRSearchEdit.setCancelAction(anAction: TCustomAction);
begin
  if anAction <> fCancelAction then
    begin
      fCancelAction := anAction;
      if Assigned(fCancelAction) then
        fCancelAction.Caption := '';
    end;
end;

procedure TCCRSearchEdit.SetEnabled(aValue: Boolean);
begin
  if aValue <> Enabled then
    begin
      inherited;
      if aValue then
        Edit.Color := fEditColor
      else
        begin
          fEditColor := Edit.Color;
          Edit.ParentColor := True;
        end;
      Edit.Enabled := aValue;
    end;
end;

procedure TCCRSearchEdit.setMaxLength(const aValue: Word);
begin
  if Assigned(Edit) then
    Edit.MaxLength := aValue;
end;

procedure TCCRSearchEdit.setModified(aValue: Boolean);
begin
  if Assigned(Edit) then
    Edit.Modified := aValue;
end;

procedure TCCRSearchEdit.SetName(const NewName: TComponentName);
begin
  inherited;
  Caption := '';
end;

procedure TCCRSearchEdit.setSearching(const aValue: Boolean);
begin
  if aValue <> fSearching then
    if aValue then
      begin
        fSearching := True;
        if EnableCancel then
          begin
            with GoButton do
              begin
                Action := CancelAction;
                Glyph  := bmSearchCancel;
                Hint   := RSC0013;
              end;
          end;
      end
    else
      begin
        if EnableCancel then
          begin
            with GoButton do
              begin
                Action  := nil;
                Glyph   := bmSearchStart;
                Hint    := RSC0012;
                OnClick := ButtonClick;
              end;
          end;
        fSearching := False;
      end;
end;

procedure TCCRSearchEdit.setText(aValue: String);
begin
  if Assigned(Edit) then
    Edit.Text := aValue;
end;

function TCCRSearchEdit.Validate(var aMessage: String): TCCRValidateCode;
begin
  aMessage := '';
  Result := vcOk;
  if Length(Text) < MinLength then
    Result := vcTooShort
  else if Assigned(OnValidate) then
    begin
      OnValidate(Self, aMessage);
      if aMessage <> '' then
        Result := vcInvalid;
    end;
end;

////////////////////////////// TCCRVistASearchEdit \\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRVistASearchEdit.Create(anOwner: TComponent);
begin
  inherited;
  fRawData := TStringList.Create;
  fSearchFromIndex  := -1;
  fSearchStrPerItem := 1;
  fSuspendGridUpdates := True;
end;

destructor TCCRVistASearchEdit.Destroy;
begin
  FreeAndNil(fRawData);
  inherited;
end;

procedure TCCRVistASearchEdit.DoSearchStart(var aCommand: TCCRSearchCommand);
begin
  SearchGrid.Clear;
  SearchCount := 0;
  inherited;
  if (SearchFromIndex >= 0) and (SearchFromIndex < Length(SearchParams)) then
    SearchParams[SearchFromIndex] := '';
end;

function TCCRVistASearchEdit.getSearchFields: String;
var
  i: Integer;
begin
  if Length(SearchFieldsArray) > 0 then
    begin
      Result := IntToStr(SearchFieldsArray[0]);
      for i:=1 to High(SearchFieldsArray) do
        Result := Result + ',' + IntToStr(SearchFieldsArray[i]);
    end
  else
    Result := '';
end;

procedure TCCRVistASearchEdit.Notification(aComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (aComponent = SearchGrid) then
    SearchGrid := nil;
end;

function TCCRVistASearchEdit.Search: Boolean;
begin
  if not Assigned(SearchGrid) and Assigned(SearchSelector) then
    SearchGrid := SearchSelector.SourceList;
  if Assigned(SearchGrid) then
    begin
      RawData.Clear;
      if SuspendGridUpdates then
        SearchGrid.Items.BeginUpdate;
      Result := inherited Search;
      if SuspendGridUpdates then
        SearchGrid.Items.EndUpdate;
      RawData.Clear;
    end
  else
    Result := False;
end;

procedure TCCRVistASearchEdit.SetParams(Params: array of String);
var
  i, l: Integer;
begin
  l := Length(Params);
  SetLength(SearchParams, l);
  for i:=l-1 downto 0 do
    SearchParams[i] := Params[i];
end;

procedure TCCRVistASearchEdit.setSearchFields(const aValue: String);
var
  i, n: Integer;
  fld: String;
begin
  i := 0;
  n := 0;
  while True do
    begin
      Inc(i);
      fld := Piece(aValue,',',i);
      if fld = '' then
        Break;
      if i >= n then
        begin
          Inc(n, 10);
          SetLength(SearchFieldsArray, n);
        end;
      SearchFieldsArray[i-1] := StrToIntDef(fld, 0);
    end;
  SetLength(SearchFieldsArray, i-1);
end;

end.
