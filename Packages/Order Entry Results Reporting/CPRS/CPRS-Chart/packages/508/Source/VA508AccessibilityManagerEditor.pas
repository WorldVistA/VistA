unit VA508AccessibilityManagerEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.CheckLst, Vcl.ImgList, Vcl.ComCtrls,
  Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.ExtCtrls, VA508AccessibilityManager, ColnEdit,
  Vcl.Menus;

type

   tStringsHelper = class helper for tStrings
    function IndexOfPiece(const S: string; const PieceDelim: Char; const PieceNum: integer): Integer;
    function IndexOfPieceEx(const S: string; const PieceDelim: Char; const PieceNum: integer; const StartFrom: Integer): Integer;
  end;

  Tva508CollectionEditor = class(TForm)
    pnlLeft: TPanel;
    pnlRight: TPanel;
    splMain: TSplitter;
    chkDefault: TCheckBox;
    cmbAccessLbl: TComboBox;
    cmbAccessProp: TComboBox;
    memAccessTxt: TMemo;
    lbCtrllList: TLabel;
    lblAccLbl: TLabel;
    lblAccProp: TLabel;
    lnlAccTxt: TLabel;
    pnlLstView: TPanel;
    lstAccessCol: TCheckListBox;
    lblAccColumns: TLabel;
    lstCtrls: TListView;
    StatusBar1: TStatusBar;
    lblHeader: TLabel;
    MainMenu1: TMainMenu;
    Main1: TMenuItem;
    RefreshAll1: TMenuItem;
    procedure lstCtrlsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure memAccessTxtChange(Sender: TObject);
    procedure cmbAccessLblChange(Sender: TObject);
    procedure cmbAccessPropChange(Sender: TObject);
    procedure chkDefaultClick(Sender: TObject);
    procedure lstAccessColClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RefreshAll1Click(Sender: TObject);
  private
    { Private declarations }
    fInternal: Boolean;
    fCollection: TVA508AccessibilityCollection;
    fOwnerCtrl: TVA508AccessibilityManager;
    fOldHint: TNotifyEvent;
    procedure MyHint(Sender: TObject);
    procedure ClearAll;
    Function GetAccessItem: TVA508AccessibilityItem;
    procedure SetAccessData(Sender: TObject; AccessItem: TVA508AccessibilityItem);
    procedure ClearControl(aObj: TObject; aEvent: String; AccessItem: TVA508AccessibilityItem);
  public
    { Public declarations }
    procedure FillOutList(aCollection: TVA508AccessibilityCollection;
      aOwnerCtrl: TVA508AccessibilityManager);
 //   constructor Create(AOwner: TComponent); override;
 //   destructor Destroy; override;
   // property Collection: TVA508AccessibilityCollection read fCollection write fCollection;
    // property OwnerForm: TComponent read fOwnerForm write fOwnerForm;
  end;

var
  va508CollectionEditor: Tva508CollectionEditor;

implementation

uses
    system.TypInfo, VAUtils;

const
  HeaderTxt = 'Settings for %s';

{$R *.dfm}


function tStringsHelper.IndexOfPiece(const S: string; const PieceDelim: Char; const PieceNum: integer): Integer;
begin
 Result := IndexOfPieceEx(S, PieceDelim, PieceNum, 0);
end;

function tStringsHelper.IndexOfPieceEx(const S: string; const PieceDelim: Char;
  const PieceNum: integer; const StartFrom: integer): integer;
var
  Count: integer;
  SLen: integer;
  aStr: String;
begin
  Count := GetCount;

  if StartFrom > Count then
  begin
    Result := -1;
    exit;
  end;

  SLen := Length(S);
  for Result := StartFrom to Count - 1 do
  begin
    aStr := Piece(self.Strings[Result], PieceDelim, PieceNum);
    if (Length(aStr) = SLen) and (CompareStrings(aStr, S) = 0) then
      exit;
  end;
  Result := -1;
end;

procedure Tva508CollectionEditor.MyHint(Sender: TObject);
begin
  StatusBar1.SimpleText := Application.Hint;
end;

procedure Tva508CollectionEditor.RefreshAll1Click(Sender: TObject);
begin
 fOwnerCtrl.RefreshComponents;
 FillOutList(fCollection, fOwnerCtrl);
end;

Function Tva508CollectionEditor.GetAccessItem: TVA508AccessibilityItem;
begin
  Result := nil;
  if lstCtrls.ItemIndex > -1 then
    Result := TVA508AccessibilityItem(lstCtrls.Items[lstCtrls.ItemIndex].Data);
end;

procedure Tva508CollectionEditor.ClearAll;
begin
  lblHeader.Caption := '';

  ClearControl(chkDefault, 'OnClick', nil);
  ClearControl(cmbAccessLbl, 'OnChange', nil);
  ClearControl(cmbAccessProp, 'OnChange', nil);
  ClearControl(memAccessTxt, 'OnChange', nil);

  pnlLstView.Visible := false;
  lstAccessCol.Clear;
end;

procedure Tva508CollectionEditor.lstCtrlsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);

var
  EdtItem: TVA508AccessibilityItem;
  I, tmpIdx: integer;
  tmpObj: TColumnList;
begin
  if (not Assigned(Item.Data)) or (not Selected) then
    exit;

  ClearAll;
  EdtItem := Item.Data;

  fOwnerCtrl.GetProperties(EdtItem.Component, cmbAccessProp.Items);

  // Fill out the fields
  chkDefault.Checked := EdtItem.UseDefault;

  lblHeader.Caption := Format(HeaderTxt, [EdtItem.DisplayName]);

  if Assigned(EdtItem.AccessLabel) then
    cmbAccessLbl.ItemIndex := cmbAccessLbl.Items.IndexOfPiece
      (EdtItem.AccessLabel.Name, '=', 1);

  cmbAccessProp.ItemIndex := cmbAccessProp.Items.IndexOf
    (EdtItem.AccessProperty);

  memAccessTxt.Text := EdtItem.AccessText;

  if EdtItem.Component is TListView then
  begin
    pnlLstView.Visible := true;
    //Build the list


     tmpObj := EdtItem.AccessColumns;
     if Assigned(tmpObj) then
     begin

       for I := 0 to TListView(EdtItem.Component).Columns.Count - 1 do
       begin
        tmpIdx := lstAccessCol.Items.Add(TListView(EdtItem.Component).Column[i].Caption);
        lstAccessCol.Checked[tmpIdx] := tmpObj.ColumnValues[I];
       end;
     end;

  end;

end;

 procedure Tva508CollectionEditor.ClearControl(aObj: TObject; aEvent: String; AccessItem: TVA508AccessibilityItem);
 const
   NILEvnt: TMethod = (Code: NIL; Data: NIL);
 var
  fMethodHwnd: TMethod;
 begin
  fMethodHwnd := GetMethodProp(aObj, aEvent);
  SetMethodProp(aObj, aEvent, NILEvnt);
  try
   if aObj = chkDefault then
   begin
    chkDefault.Checked := false;
    if Assigned(AccessItem) then
      AccessItem.UseDefault := false;
   end;
   if aObj = cmbAccessLbl then
   begin
    cmbAccessLbl.ItemIndex := -1;
    if Assigned(AccessItem) then
      AccessItem.AccessLabel := nil;
   end;
   if aObj = cmbAccessProp then
   begin
    cmbAccessProp.ItemIndex := -1;
    if Assigned(AccessItem) then
      AccessItem.AccessProperty := '';
   end;
   if aObj = memAccessTxt then
   begin
    memAccessTxt.text := '';
    if Assigned(AccessItem) then
      AccessItem.AccessText := '';
   end;

  finally
   SetMethodProp(aObj, aEvent, fMethodHwnd);
  end;
 end;


procedure Tva508CollectionEditor.SetAccessData(Sender: TObject; AccessItem: TVA508AccessibilityItem);
var
  SelTxt: String;
  SelLabel: TComponent;
begin
    if Sender = chkDefault then
    begin
       AccessItem.UseDefault := chkDefault.Checked;
       ClearControl(cmbAccessLbl, 'OnChange', AccessItem);
       ClearControl(memAccessTxt, 'OnChange', AccessItem);
       ClearControl(cmbAccessProp, 'OnChange', AccessItem);
    end else if Sender = cmbAccessLbl then
    begin
       if cmbAccessLbl.ItemIndex > -1 then
       begin
         SelTxt := Piece(cmbAccessLbl.Items.Strings[cmbAccessLbl.ItemIndex], '=', 1);
         SelLabel := fOwnerCtrl.Owner.FindComponent(SelTxt);
         AccessItem.AccessLabel := TLabel(SelLabel);
         ClearControl(chkDefault, 'OnClick', AccessItem);
         ClearControl(memAccessTxt, 'OnChange', AccessItem);
         ClearControl(cmbAccessProp, 'OnChange', AccessItem);
       end else
         AccessItem.AccessLabel := nil;
    end else if Sender = cmbAccessProp then
    begin
       AccessItem.AccessProperty := cmbAccessProp.Items.Strings[cmbAccessProp.ItemIndex];
       ClearControl(cmbAccessLbl, 'OnChange', AccessItem);
       ClearControl(memAccessTxt, 'OnChange', AccessItem);
       ClearControl(chkDefault, 'OnClick', AccessItem);
    end else if Sender = memAccessTxt then
    begin
       AccessItem.AccessText := memAccessTxt.Text;
       ClearControl(cmbAccessLbl, 'OnChange', AccessItem);
       ClearControl(chkDefault, 'OnClick', AccessItem);
       ClearControl(cmbAccessProp, 'OnChange', AccessItem);
    end;
end;

procedure Tva508CollectionEditor.lstAccessColClickCheck(Sender: TObject);
var
  AccessItem: TVA508AccessibilityItem;
  tmpObj: TColumnList;
  ColNum: Integer;
begin
  AccessItem := GetAccessItem;
  if Assigned(AccessItem) then
  begin
   tmpObj := AccessItem.AccessColumns;
   ColNum := lstAccessCol.ItemIndex;
   tmpObj.ColumnValues[ColNum] :=  lstAccessCol.Checked[lstAccessCol.ItemIndex];
 //  AccessItem.AccessColumns := tmpObj;
  end;
end;


procedure Tva508CollectionEditor.chkDefaultClick(Sender: TObject);
var
  AccessItem: TVA508AccessibilityItem;
begin
  AccessItem := GetAccessItem;
  if Assigned(AccessItem) then
    SetAccessData(chkDefault, AccessItem);

end;

procedure Tva508CollectionEditor.memAccessTxtChange(Sender: TObject);
var
  AccessItem: TVA508AccessibilityItem;
begin
  AccessItem := GetAccessItem;
  if Assigned(AccessItem) then
    SetAccessData(memAccessTxt, AccessItem);

end;

procedure Tva508CollectionEditor.cmbAccessLblChange(Sender: TObject);
var
  AccessItem: TVA508AccessibilityItem;
begin
  AccessItem := GetAccessItem;
  if Assigned(AccessItem) then
    SetAccessData(cmbAccessLbl, AccessItem);
end;

procedure Tva508CollectionEditor.cmbAccessPropChange(Sender: TObject);
var
  AccessItem: TVA508AccessibilityItem;
begin
  AccessItem := GetAccessItem;
  if Assigned(AccessItem) then
    SetAccessData(cmbAccessProp, AccessItem);
end;

procedure Tva508CollectionEditor.FillOutList(aCollection
  : TVA508AccessibilityCollection; aOwnerCtrl: TVA508AccessibilityManager);
var
  aItem: TListItem;
  I: integer;
  tmpStrLst: TStringList;
begin
  lstCtrls.Clear;
  fCollection := aCollection;
  fOwnerCtrl := aOwnerCtrl;

  for I := 0 to fCollection.Count - 1 do
  begin
    aItem := lstCtrls.Items.Add;
    aItem.Caption := fCollection.Items[I].DisplayName;
    aItem.Data := fCollection.Items[I];
  end;

  // Prefill the available label list
  tmpStrLst := TStringList.Create;
  try
    fOwnerCtrl.GetLabelStrings(tmpStrLst);
    cmbAccessLbl.Items.Assign(tmpStrLst);
  finally
    tmpStrLst.Free;
  end;
 fInternal := false;
end;

procedure Tva508CollectionEditor.FormCreate(Sender: TObject);
begin
 fOldHint := Application.OnHint;
 Application.OnHint := MyHint;
end;

procedure Tva508CollectionEditor.FormDestroy(Sender: TObject);
begin
 Application.OnHint := fOldHint;
end;
{
constructor Tva508CollectionEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor Tva508CollectionEditor.Destroy;
begin
  inherited Destroy;
end;   }

end.
