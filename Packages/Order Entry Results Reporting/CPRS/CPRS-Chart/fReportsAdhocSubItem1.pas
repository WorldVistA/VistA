unit fReportsAdhocSubItem1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, Buttons, ORfn, fAutoSz, VA508AccessibilityManager;

type
  TfrmReportsAdhocSubItem1 = class(TfrmAutoSz)
    GroupBox1: TGroupBox;
    Splitter3: TSplitter;
    pnl7Button: TKeyClickPanel;
    SpeedButton7: TSpeedButton;
    pnl8Button: TKeyClickPanel;
    SpeedButton8: TSpeedButton;
    ORComboBox2: TORComboBox;
    ORListBox1: TORListBox;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Panel5: TPanel;
    btnCancel: TButton;
    Panel8: TPanel;
    btnAddSel: TButton;
    btnRemoveSel: TButton;
    btnRemoveAllSel: TButton;
    btnOK: TButton;
    Timer2: TTimer;
    Label6: TStaticText;
    lblLimit: TStaticText;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ORListBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ORListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ORListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure btnRemoveAllSelClick(Sender: TObject);
    procedure btnRemoveSelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAddSelClick(Sender: TObject);
    procedure ORComboBox2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ORComboBox2NeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure pnl7ButtonEnter(Sender: TObject);
    procedure pnl7ButtonExit(Sender: TObject);
  private
    { Private declarations }
    GoingUp: Boolean;
    OKPressed: Boolean;
  public
    { Public declarations }
  end;

function ExecuteForm2(aCaption: string): Boolean;

implementation

uses fReportsAdhocComponent1, rReports, VAUtils, System.Types;

{$R *.DFM}

function ExecuteForm2(aCaption: string): Boolean;
var
  frmReportsAdhocSubItem1: TfrmReportsAdhocSubItem1;
begin
  Result := False;
  frmReportsAdhocSubItem1 := TfrmReportsAdhocSubItem1.Create(Application);
  try
    ResizeFormToFont(TForm(frmReportsAdhocSubItem1));
    frmReportsAdhocSubItem1.Caption := aCaption;
    frmReportsAdhocSubItem1.ShowModal;
    if frmReportsAdhocSubItem1.OKPressed then
      Result := True;
  finally
    frmReportsAdhocSubItem1.Release;
  end;
end;

procedure TfrmReportsAdhocSubItem1.btnCancelClick(Sender: TObject);
begin
  ORComboBox2.Clear;
  ORListBox1.Clear;
  close;
end;

procedure TfrmReportsAdhocSubItem1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  uLimitCount := 1;
  OKPressed := False;
  Panel8.Left := Splitter3.Left + Splitter3.Width;
  Panel8.Align := Splitter3.Align;
  ORListBox1.Left := Panel8.Left + Panel8.Width;
  ORListBox1.Align := Panel8.Align;
  ORComboBox2.LockDrawing;
  try
    ORComboBox2.InitLongList('');
  finally
    ORComboBox2.UnlockDrawing;
  end;
  If uLimit>0 then
        lblLimit.Caption := IntToStr(uLimit)
      else
        lblLimit.Caption := 'No Limit';
  ORListBox1.Caption := 'File Entries Selected ( Selections Allowed: ' +
    lblLimit.Caption + ')';
  for i := 0 to uComponents.Count-1 do
    if piece(uComponents[i],'^',1) = IntToStr(uCurrentComponent) then
      ORListBox1.Items.Add(Pieces(uComponents[i],'^',3,10));
end;

procedure TfrmReportsAdhocSubItem1.ORListBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if (Sender = ORListBox1) and (Target = ORComboBox2) then
    btnRemoveSelClick(nil);
  Timer2.Enabled := False;
end;

procedure TfrmReportsAdhocSubItem1.ORListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  NuPos: Integer;
begin
  with Sender as TORListbox do
    begin
      NuPos := ItemAtPos(Point(X,Y),False);
      If NuPos >= Items.Count then Dec(NuPos);
      Items.Move(ItemIndex, NuPos);
      ItemIndex := NuPos;
    end;
end;

procedure TfrmReportsAdhocSubItem1.ORListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = Source) and (TORListBox(Sender).ItemAtPos(Point(x,y), False) >= 0);
  if Accept then
    with Sender as TORListbox do
      if Y > Height - ItemHeight then
        begin
          GoingUp := False;
          Timer2.Enabled := True;
        end
      else if Y < ItemHeight then
        begin
          GoingUp := True;
          Timer2.Enabled := True;
        end
      else Timer2.Enabled := False;
end;

procedure TfrmReportsAdhocSubItem1.Timer2Timer(Sender: TObject);
begin
 with ORListBox1 do
    if GoingUp then
      if TopIndex > 0 then TopIndex := TopIndex - 1
      else Timer2.Enabled := False
    else
      if TopIndex < Items.Count - 1 then TopIndex := TopIndex + 1
      else Timer2.Enabled := False;
end;

procedure TfrmReportsAdhocSubItem1.SpeedButton8Click(Sender: TObject);
var
  i : Integer;
begin
  with ORListbox1 do
    if (ItemIndex < Items.Count-1) and
       (ItemIndex <> -1) then
      begin
        i := ItemIndex;
        Items.Move(i, i+1);
        ItemIndex := i+1;
      end;
end;

procedure TfrmReportsAdhocSubItem1.SpeedButton7Click(Sender: TObject);
var
  i:integer;
begin
  with ORListBox1 do
    if ItemIndex > 0 then
      begin
        i := ItemIndex;
        Items.Move(i, i-1);
        ItemIndex := i-1;
      end;
end;

procedure TfrmReportsAdhocSubItem1.btnRemoveAllSelClick(Sender: TObject);
var
  i: integer;
begin
  If ORListBox1.Items.Count < 1 then
    begin
      InfoBox('There are no items to remove.', 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end;
  if InfoBox('This button will remove all selected items. OK?',
    'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      With ORListBox1 do
        begin
          for i := uComponents.Count-1 downto 0 do
            uComponents.Delete(i);
          for i := Items.Count-1 downto 0 do
            Items.Delete(i);
        end;
      uLimitCount := 1;
      SpeedButton7.Enabled := false;
      SpeedButton8.Enabled := false;
    end;
end;

procedure TfrmReportsAdhocSubItem1.btnRemoveSelClick(Sender: TObject);
var
  i: integer;
  chk: integer;
begin
  chk := 0;
  If ORListBox1.Items.Count < 1 then
    begin
      InfoBox('There are no items to remove.', 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end
  else
    for i := 0 to ORListBox1.Items.Count - 1 do
      if ORListBox1.Selected[i] then
          chk := 1;
    if chk = 0 then
      begin
        InfoBox('Please select the item you wish to remove', 'Information', MB_OK or MB_ICONINFORMATION);
        Exit;
      end;
    With ORListBox1 do
      begin
        for i := uComponents.Count-1 downto 0 do
          if piece(uComponents[i],'^',2) = Piece(Items[ItemIndex],'^',1) then
            uComponents.Delete(i);
        Items.Delete(ItemIndex);
        uLimitCount := uLimitCount - 1;
        if Items.Count < 1 then
          begin
            SpeedButton7.Enabled := false;
            SpeedButton8.Enabled := false;
          end;
      end;
end;

procedure TfrmReportsAdhocSubItem1.btnOKClick(Sender: TObject);
var
  i: integer;
  uTestList: TStringList;
begin
  uTestList := TStringList.Create;
  uTestList.Clear;
  for i := 0 to ORListBox1.Items.Count-1 do
    uTestList.Add(ORListBox1.Items[i]);
  for i := uComponents.Count-1 downto 0 do
    if piece(uComponents[i],'^',1)=IntToStr(uCurrentComponent) then
      uComponents.Delete(i);
  for i := 0 to uTestList.Count-1 do
    if (uLimit = 0) or (i < uLimit) then
      uComponents.Add(IntToStr(uCurrentComponent)
        + '^' + uFile + '^' + uTestList[i]);
  OKPressed := True;
  ORListBox1.Clear;
  uTestList.Free;
  Close;
end;

procedure TfrmReportsAdhocSubItem1.btnAddSelClick(Sender: TObject);
var
  i: integer;
  uHSSubItems: TStringList;
begin
  If (uLimit <> 0) and (uLimitCount > uLimit) then
    begin
      Application.MessageBox(
      'Sorry, you have reached the selection limit for this component',
      'Selection Error',MB_OK + MB_DEFBUTTON1);
      Exit;
    end;
  If ORComboBox2.ItemIndex < 0 then
    begin
      InfoBox('Please select an item to Add.', 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end;
  If uFile = '60' then
    begin
      uHSSubItems := TStringList.Create;
      HSSubItems(uHSSubItems,
        Piece(ORComboBox2.Items[ORComboBox2.ItemIndex],'^',1));
      If uHSSubItems.Count > 0 then
        for i := 0 to uHSSubItems.Count-1 do
          begin
            ORListBox1.Items.Add(uHSSubItems[i]);
            uLimitCount := uLimitCount + 1;
          end
      Else
        begin
          ORListBox1.Items.Add(ORComboBox2.Items[ORComboBox2.ItemIndex]);
          uLimitCount := uLimitCount + 1;
        end;
      uHSSubItems.Free;
    end
  Else
    begin
      ORListBox1.Items.Add(ORComboBox2.Items[ORComboBox2.ItemIndex]);
      uLimitCount := uLimitCount + 1;
    end;
  If (uLimit <> 0) and (uLimitCount > (uLimit+1)) then
    ShowMsg(
      'MAXIMUM SELECTION LIMIT EXCEEDED! Only the first '
      + IntToStr(uLimit) + ' items in the list will be used');
  If ORListBox1.Items.Count > 0 then
    begin
      SpeedButton7.Enabled := true;
      SpeedButton8.Enabled := true;
    end;
  btnOK.SetFocus;
end;

procedure TfrmReportsAdhocSubItem1.ORComboBox2KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  If Key = 13 then
    with ORComboBox2 do
      if (Text <> '') and (Items.IndexOf (Text) >= 0) then
        begin
          ItemIndex := Items.IndexOf(Text);
          btnAddSelClick(nil);
          Key := 0;
        end;
end;

procedure TfrmReportsAdhocSubItem1.ORComboBox2NeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
  HSFileLookup(sl,uFile,StartFrom,Direction);
  ORComboBox2.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmReportsAdhocSubItem1.pnl7ButtonEnter(Sender: TObject);
begin
  inherited;
  (sender as TPanel).BevelOuter := bvRaised;
end;

procedure TfrmReportsAdhocSubItem1.pnl7ButtonExit(Sender: TObject);
begin
  inherited;
  (sender as TPanel).BevelOuter := bvNone;
end;

end.
