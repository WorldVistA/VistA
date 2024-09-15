unit fReportsAdhocComponent1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, ORCtrls, ORfn, Buttons, fAutoSz,
  VA508AccessibilityManager;

type
  TfrmReportsAdhocComponent1 = class(TfrmAutoSz)
    ORComboBox1: TORComboBox;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    btnCancelMain: TButton;
    btnOKMain: TButton;
    Panel1: TPanel;
    ORListBox2: TORListBox;
    Panel6: TPanel;
    btnRemoveComponent: TButton;
    btnRemoveAllComponents: TButton;
    Splitter4: TSplitter;
    Panel7: TPanel;
    lblHeaderName: TLabel;
    edtHeaderName: TCaptionEdit;
    lblOccuranceLimit: TLabel;
    edtOccuranceLimit: TCaptionEdit;
    lblTimeLimit: TLabel;
    cboTimeLimit: TCaptionComboBox;
    gpbDisplay: TGroupBox;
    ckbHospitalLocation: TCheckBox;
    ckbProviderNarrative: TCheckBox;
    cboICD: TCaptionComboBox;
    lblICD: TLabel;
    btnAddComponent: TButton;
    pnl5Button: TKeyClickPanel;
    SpeedButton5: TSpeedButton;
    pnl6Button: TKeyClickPanel;
    SpeedButton6: TSpeedButton;
    Timer1: TTimer;
    ORListBox1: TORListBox;
    lblItems: TLabel;
    btnEditSubitems: TButton;
    GroupBox1: TGroupBox;
    rbtnHeader: TRadioButton;
    rbtnAbbrev: TRadioButton;
    rbtnName: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelMainClick(Sender: TObject);
    procedure btnOKMainClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HideEdits;
    procedure ORListBox2Click(Sender: TObject);
    procedure btnRemoveComponentClick(Sender: TObject);
    procedure btnRemoveAllComponentsClick(Sender: TObject);
    procedure Splitter4CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure btnAddComponentClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ORListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ORListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ORListBox2EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure btnEditSubitemsClick(Sender: TObject);
    procedure edtHeaderNameExit(Sender: TObject);
    procedure edtOccuranceLimitExit(Sender: TObject);
    procedure cboTimeLimitExit(Sender: TObject);
    procedure ckbHospitalLocationExit(Sender: TObject);
    procedure ckbProviderNarrativeExit(Sender: TObject);
    procedure cboICDExit(Sender: TObject);
    procedure LoadComponents(Dest: TStrings);
    procedure FormShow(Sender: TObject);
    procedure rbtnAbbrevClick(Sender: TObject);
    procedure rbtnNameClick(Sender: TObject);
    procedure rbtnHeaderClick(Sender: TObject);
    procedure pnl5ButtonEnter(Sender: TObject);
    procedure pnl5ButtonExit(Sender: TObject);
    procedure ORComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    GoingUp: Boolean;
    OKPressed: Boolean;
  public
    { Public declarations }
  end;

var
  uComponents: TStringList;    {This is what is built as SubItems are
                                selected.  It is identified by segment
                                and is ordered in the order that the items
                                have been selected or moved by the user.
                                Segment^file #^ifn of file^zero node of file}
  uCurrentComponent: Integer;  //Pointer to current Component ID
  HSCompCtr: integer;          //Component ID
  uFile: String;               //Mumps file Number of Subitems
  uLimit: Integer;             //HS Component Subitem Selection limit
  uLimitCount: Integer;        //Count of current Subitem Selections

  function ExecuteAdhoc1: Boolean;

implementation

uses fReportsAdhocSubItem1, fReports, uCore, rReports, System.Types, VAUtils;

{$R *.DFM}
type
PHSCompRec = ^THSCompRec;
THSCompRec = object
  public
    ID: integer;
    Segment: string;
    Name: string;
    OccuranceLimit: string;
    TimeLimit: string;
    Header: string;
    HospitalLocation: string;
    ICDText: string;
    ProviderNarrative: string;
  end;

function ExecuteAdhoc1: Boolean;
var
  frmReportsAdhocComponent1: TfrmReportsAdhocComponent1;
begin
  Result := False;
  frmReportsAdhocComponent1 := TfrmReportsAdhocComponent1.Create(Application);
  try
    ResizeFormToFont(TForm(frmReportsAdhocComponent1));
    frmReportsAdhocComponent1.ShowModal;
    if frmReportsAdhocComponent1.OKPressed then
      Result := True;
  finally
    frmReportsAdhocComponent1.Release;
  end;
end;

procedure TfrmReportsAdhocComponent1.FormCreate(Sender: TObject);

begin
  HideEdits;
  HSCompCtr := 0;
  uFile := '';
  uLimit := 0;
  uLimitCount := 1;
  uComponents := TStringList.Create;
  Splitter1.Left := ORComboBox1.Left + ORComboBox1.Width + 1;
  Splitter1.Align := ORComboBox1.Align;
  Panel6.Left := Splitter1.Left + Splitter1.Width;
  Panel6.Align := Splitter1.Align;
  ORListBox2.Left := Panel6.Left + Panel6.Width;
  ORListBox2.Align := Panel6.Align;
  Splitter4.Left := ORListBox2.Left + ORListBox2.Width + 1;
  Splitter4.Align := ORListBox2.Align;
end;

procedure TfrmReportsAdhocComponent1.FormShow(Sender: TObject);
begin
  inherited;
  if uListState = 1 then rbtnAbbrev.Checked := true;
  if uListState = 0 then rbtnName.Checked := true;
  if uListState = 2 then rbtnHeader.Checked := true;
  LoadComponents(ORComboBox1.Items);
end;

procedure TfrmReportsAdhocComponent1.btnCancelMainClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReportsAdhocComponent1.btnOKMainClick(Sender: TObject);
var
  i,j: integer;
begin
  OKPressed := True;
  with ORListBox2 do
    begin
      if Items.Count > 0 then
        begin
          for i := 0 to Items.Count - 1 do
           begin
            uHSComponents.Add(PHSCompRec(Items.Objects[i])^.Segment + '^' +
             PHSCompRec(Items.Objects[i])^.OccuranceLimit + '^' +
             PHSCompRec(Items.Objects[i])^.TimeLimit + '^' +
             PHSCompRec(Items.Objects[i])^.Header + '^' +
             PHSCompRec(Items.Objects[i])^.HospitalLocation + '^' +
             PHSCompRec(Items.Objects[i])^.ICDText + '^' +
             PHSCompRec(Items.Objects[i])^.ProviderNarrative);
            for j := 0 to uComponents.Count-1 do
             if StrToInt(piece(uComponents[j],'^',1)) =
              PHSCompRec(Items.Objects[i])^.ID then
               uHSComponents.Add(PHSCompRec(Items.Objects[i])^.Segment + '^' +
               PHSCompRec(Items.Objects[i])^.OccuranceLimit + '^' +
               PHSCompRec(Items.Objects[i])^.TimeLimit + '^' +
               PHSCompRec(Items.Objects[i])^.Header + '^' +
               PHSCompRec(Items.Objects[i])^.HospitalLocation + '^' +
               PHSCompRec(Items.Objects[i])^.ICDText + '^' +
               PHSCompRec(Items.Objects[i])^.ProviderNarrative + '^' +
               uComponents[j]);
           end;
        end;
    end;
  if uHSComponents.Count > 0 then
    begin
      HSReportText(uLocalReportData, uHSComponents);
      Close;
    end
  else
    Application.MessageBox(
      'Sorry, no Components have been selected',
      'Selection Error',MB_OK + MB_DEFBUTTON1);
end;

procedure TfrmReportsAdhocComponent1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  aParam: integer;
begin
  aParam := 1;
  if rbtnName.Checked = true then
    aParam := 0
  else if rbtnAbbrev.Checked = true then
    aParam := 1
  else if rbtnHeader.Checked = true then
    aParam := 2;
  SetAdhocLookup(aParam);
  uComponents.Free;
end;

procedure TfrmReportsAdhocComponent1.HideEdits;
begin
  lblTimeLimit.Enabled := False;
  lblOccuranceLimit.Enabled := False;
  cboTimeLimit.Enabled := False;
  edtOccuranceLimit.Enabled := False;
  gpbDisplay.Enabled := False;
  ckbHospitalLocation.Enabled := False;
  ckbProviderNarrative.Enabled := False;
  lblICD.Enabled := False;
  cboICD.Enabled := False;
  lblItems.Enabled := False;
  ORListBox1.Enabled := False;
  btnEditSubitems.Enabled := False;
  cboTimeLimit.Text := '';
  edtOccuranceLimit.Text := '';
  ckbHospitalLocation.Checked := False;
  ckbProviderNarrative.Checked := False;
  cboICD.Text := '';
end;

procedure TfrmReportsAdhocComponent1.ORListBox2Click(Sender: TObject);
var
  i: integer;
  a: string;
  uHSCompFiles: TStringList;
begin
  HideEdits;
  with ORListBox2 do
    a := PHSCompRec(Items.Objects[ItemIndex])^.Segment;
  uHSCompFiles := TStringList.Create;
  HSComponentFiles(uHSCompFiles,Piece(a,';',2));
  If uHSCompFiles.Count > 0 then
    begin
      uFile := Piece(uHSCompFiles.Strings[0],'^',3);
      If Length(uFile) > 0 then
        begin
          lblItems.Enabled := True;
          ORListBox1.Enabled := True;
          btnEditSubItems.Enabled := True;
        end;
    end;
  uHSCompFiles.Free;
  with ORListBox2 do
    begin
      if length(Piece(Items[ItemIndex],'^',5))>0 then
        begin
          edtHeaderName.Text := PHSCompRec(Items.Objects[ItemIndex])^.Header;
          edtHeaderName.Enabled := True;
          lblHeaderName.Enabled := True;
        end;
      if length(Piece(Items[ItemIndex],'^',3))>0 then
        begin
          edtOccuranceLimit.Text :=
            PHSCompRec(Items.Objects[ItemIndex])^.OccuranceLimit;
          edtOccuranceLimit.Enabled := True;
          lblOccuranceLimit.Enabled := True;
        end;
      if length(Piece(Items[ItemIndex],'^',4))>0 then
        begin
          cboTimeLimit.Text :=
            PHSCompRec(Items.Objects[ItemIndex])^.TimeLimit;
          cboTimeLimit.Enabled := True;
          lblTimeLimit.Enabled := True;
        end;
      if length(Piece(Items[ItemIndex],'^',6))>0 then
        begin
          gpbDisplay.Enabled := True;
          ckbHospitalLocation.Enabled := True;
          if PHSCompRec(Items.Objects[ItemIndex])^.HospitalLocation = 'Y'
            then ckbHospitalLocation.Checked := True
          else
            ckbHospitalLocation.Checked := False;
        end;
      if length(Piece(Items[ItemIndex],'^',7))>0 then
        begin
          gpbDisplay.Enabled := True;
          lblICD.Enabled := True;
          cboICD.Enabled := True;
          if Piece(Items[ItemIndex],'^',7) = 'L' then       //cq 21962
            cboICD.Text := 'Long text';
          if Piece(Items[ItemIndex],'^',7) = 'S' then
            cboICD.Text := 'Short text';
          if Piece(Items[ItemIndex],'^',7) = 'C' then
            cboICD.Text := 'Code only';
          if Piece(Items[ItemIndex],'^',7) = 'T' then
            cboICD.Text := 'Text only';
          if Piece(Items[ItemIndex],'^',7) = 'N' then
            cboICD.Text := 'None';
        end;
      if length(Piece(Items[ItemIndex],'^',8))>0 then
        begin
          gpbDisplay.Enabled := True;
          ckbProviderNarrative.Enabled := True;
          if PHSCompRec(Items.Objects[ItemIndex])^.ProviderNarrative = 'Y'
            then ckbProviderNarrative.Checked := True
          else
            ckbProviderNarrative.Checked := False;
        end;
      uCurrentComponent := PHSCompRec(Items.Objects[ItemIndex])^.ID;
    end;
  ORListBox1.Clear;
  for i := 0 to uComponents.Count-1 do
    if piece(uComponents[i],'^',1) = IntToStr(uCurrentComponent) then
      ORListBox1.Items.Add(Pieces(uComponents[i],'^',3,10));
  if ORListBox1.Items.Count > 0  then
    begin
      lblItems.Enabled := True;
      ORListBox1.Enabled := True;
      btnEditSubItems.Enabled := True;
    end;
end;

procedure TfrmReportsAdhocComponent1.btnRemoveComponentClick(Sender: TObject);
var
  i: integer;
  chk: integer;
begin
  HideEdits;
  edtHeaderName.Text := '';
  edtHeaderName.Enabled := False;
  lblHeaderName.Enabled := False;
  chk := 0;
  ORListBox1.Clear;
  If ORListBox2.Items.Count < 1 then
    begin
      InfoBox('There are no items to remove.', 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end
  else
    for i := 0 to ORListBox2.Items.Count - 1 do
      if ORListBox2.Selected[i] then
          chk := 1;
    if chk = 0 then
      begin
        InfoBox('Please select the item you wish to remove', 'Information', MB_OK or MB_ICONINFORMATION);
        Exit;
      end;
    With ORListBox2 do
      begin
        for i := uComponents.Count-1 downto 0 do
          if piece(uComponents[i],'^',1) = IntToStr(uCurrentComponent) then
            uComponents.Delete(i);
        Items.Delete(ItemIndex);
        if Items.Count < 1 then
          begin
            SpeedButton5.Enabled := false;
            SpeedButton6.Enabled := false;
          end;
      end;
end;

procedure TfrmReportsAdhocComponent1.btnRemoveAllComponentsClick(Sender: TObject);

var
  i: integer;
begin
  HideEdits;
  edtHeaderName.Text := '';
  edtHeaderName.Enabled := False;
  lblHeaderName.Enabled := False;
  ORListBox1.Clear;
  If ORListBox2.Items.Count < 1 then
    begin
      InfoBox('There are no items to remove.', 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end;
  if InfoBox('This button will remove all selected components. OK?',
    'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      With ORListBox2 do
        begin
          for i := uComponents.Count-1 downto 0 do
            uComponents.Delete(i);
          for i := Items.Count-1 downto 0 do
            Items.Delete(i);
        end;
      SpeedButton5.Enabled := false;
      SpeedButton6.Enabled := false;
    end;
end;

procedure TfrmReportsAdhocComponent1.Splitter4CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  if NewSize < 50 then
    NewSize := 50;
end;

procedure TfrmReportsAdhocComponent1.Splitter1CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  if NewSize < 50 then
    NewSize := 50;
end;

procedure TfrmReportsAdhocComponent1.btnAddComponentClick(Sender: TObject);
var
  HSCompPtr: PHSCompRec;
  i: Integer;
  uHSCompFiles: TStringList;
  uCompSubs: TStringList;
begin
  If ORComboBox1.ItemIndex < 0 then
    begin
      InfoBox('Please select a component to Add.', 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end;
  ORListBox1.Clear;
  HideEdits;
  New(HSCompPtr);
  HSCompCtr := HSCompCtr + 1;
  HSCompPtr^.ID := HSCompCtr;
  uLimit := 0;
  with ORComboBox1 do
    begin
      HSCompPtr^.Segment := Piece(Items[ItemIndex],'^',1);
      HSCompPtr^.Name := Piece(Items[ItemIndex],'^',2);
      HSCompPtr^.OccuranceLimit := Piece(Items[ItemIndex],'^',3);
      HSCompPtr^.TimeLimit := UpperCase(Piece(Items[ItemIndex],'^',4));
      HSCompPtr^.Header := Piece(Items[ItemIndex],'^',5);
      HSCompPtr^.HospitalLocation := Piece(Items[ItemIndex],'^',6);
      HSCompPtr^.ICDText := Piece(Items[ItemIndex],'^',7);
      HSCompPtr^.ProviderNarrative := Piece(Items[ItemIndex],'^',8);
      uCurrentComponent := HSCompCtr;
    end;
  with ORListBox2 do
    begin
      Items.AddObject(
        ORComboBox1.Items[ORComboBox1.ItemIndex],TObject(HSCompPtr));
      ItemIndex := Items.Count-1;
      SpeedButton5.Enabled := true;
      SpeedButton6.Enabled := true;
    end;
  uHSCompFiles := TStringList.Create;
  uCompSubs := TStringList.Create;
  HSComponentFiles(uHSCompFiles, Piece(HSCompPtr^.Segment,';',2));
  If uHSCompFiles.Count > 0 then
    begin
      uFile := Piece(uHSCompFiles.Strings[0],'^',3);
      If Length(Piece(uHSCompFiles.Strings[0],'^',4)) > 0 then
        uLimit := StrToInt(Piece(uHSCompFiles.Strings[0],'^',4));
      If Length(uFile) > 0 then
        begin
          lblItems.Enabled := True;
          ORListBox1.Enabled := True;
          btnEditSubItems.Enabled := True;
          HSComponentSubs(uCompSubs, Piece(HSCompPtr^.Segment,';',1));
          If uCompSubs.Count > 0 then
            begin
              ORListBox1.Clear;
              FastAssign(uCompSubs, ORListBox1.Items);
              for i := 0 to uCompSubs.Count-1 do
                uComponents.Add(IntToStr(uCurrentComponent) + '^' + uFile +
                  '^' + uCompSubs[i]);
            end
          else
            begin
              var aCaption := Piece(ORComboBox1.Items[ORComboBox1.ItemIndex],'^',2);
              If ExecuteForm2(aCaption) then
                begin
                  ORListBox1.Clear;
                  for i := 0 to uComponents.Count-1 do
                    if piece(uComponents[i],'^',1) = IntToStr(uCurrentComponent) then
                      ORListBox1.Items.Add(Pieces(uComponents[i],'^',3,10));
                  if ORListBox1.Items.Count < 1 then
                    InfoBox('No sub-items were selected', 'Information', MB_OK or MB_ICONINFORMATION);
                end
              else
                InfoBox('No sub-items were selected', 'Information', MB_OK or MB_ICONINFORMATION);
            end;
        end;
    end;
  with ORComboBox1 do
    begin
      if length(Piece(Items[ItemIndex],'^',5))>0 then
        begin
          edtHeaderName.Text := Piece(Items[ItemIndex],'^',5);
          edtHeaderName.Enabled := True;
          lblHeaderName.Enabled := True;
        end;
      if length(Piece(Items[ItemIndex],'^',3))>0 then
        begin
          edtOccuranceLimit.Text := Piece(Items[ItemIndex],'^',3);
          edtOccuranceLimit.Enabled := True;
          lblOccuranceLimit.Enabled := True;
        end;
      if length(Piece(Items[ItemIndex],'^',4))>0 then
        begin
          cboTimeLimit.Text := Piece(Items[ItemIndex],'^',4);
          cboTimeLimit.Enabled := True;
          lblTimeLimit.Enabled := True;
        end;
      if length(Piece(Items[ItemIndex],'^',6))>0 then
        begin
          gpbDisplay.Enabled := True;
          ckbHospitalLocation.Enabled := True;
          if Piece(Items[ItemIndex],'^',6) = 'Y' then
            ckbHospitalLocation.Checked := True;
        end;
      if length(Piece(Items[ItemIndex],'^',7))>0 then
        begin
          gpbDisplay.Enabled := True;
          lblICD.Enabled := True;
          cboICD.Enabled := True;
          if Piece(Items[ItemIndex],'^',7) = 'L' then
            cboICD.Text := 'Long text';
          if Piece(Items[ItemIndex],'^',7) = 'S' then
            cboICD.Text := 'Short text';
          if Piece(Items[ItemIndex],'^',7) = 'C' then
            cboICD.Text := 'Code only';
          if Piece(Items[ItemIndex],'^',7) = 'T' then
            cboICD.Text := 'Text only';
          if Piece(Items[ItemIndex],'^',7) = 'N' then
            cboICD.Text := 'None';
        end;
      if length(Piece(Items[ItemIndex],'^',8))>0 then
        begin
          gpbDisplay.Enabled := True;
          ckbProviderNarrative.Enabled := True;
          if Piece(Items[ItemIndex],'^',8) = 'Y' then
            ckbProviderNarrative.Checked := True;
        end;
    end;
  uHSCompFiles.Free;
  uCompSubs.Free;
end;

procedure TfrmReportsAdhocComponent1.SpeedButton5Click(Sender: TObject);
var
  i:integer;
begin
  if SpeedButton5.Enabled then
    with ORListBox2 do
      if ItemIndex > 0 then
        begin
          i := ItemIndex;
          Items.Move(i, i-1);
          ItemIndex := i-1;
        end;
end;

procedure TfrmReportsAdhocComponent1.SpeedButton6Click(Sender: TObject);
var
  i : Integer;
begin
  if SpeedButton6.Enabled then
    with ORListbox2 do
      if (ItemIndex < Items.Count-1) and
         (ItemIndex <> -1) then
        begin
          i := ItemIndex;
          Items.Move(i, i+1);
          ItemIndex := i+1;
        end;
end;

procedure TfrmReportsAdhocComponent1.ORListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = Source) and
    (TORListBox(Sender).ItemAtPos(Point(x,y), False) >= 0);
  if Accept then
    with Sender as TORListbox do
      if Y > Height - ItemHeight then
        begin
          GoingUp := False;
          Timer1.Enabled := True;
        end
      else if Y < ItemHeight then
        begin
          GoingUp := True;
          Timer1.Enabled := True;
        end
      else Timer1.Enabled := False;
end;

procedure TfrmReportsAdhocComponent1.ORListBox2DragDrop(Sender, Source: TObject; X,
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

procedure TfrmReportsAdhocComponent1.ORListBox2EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if (Sender = ORListBox2) and (Target = ORComboBox1) then
    btnRemoveComponentClick(nil);
  Timer1.Enabled := False;
end;

procedure TfrmReportsAdhocComponent1.Timer1Timer(Sender: TObject);
begin
  with ORListBox2 do
    if GoingUp then
      if TopIndex > 0 then TopIndex := TopIndex - 1
      else Timer1.Enabled := False
    else
      if TopIndex < Items.Count - 1 then TopIndex := TopIndex + 1
      else Timer1.Enabled := False;
end;

procedure TfrmReportsAdhocComponent1.btnEditSubitemsClick(Sender: TObject);
var
  i: integer;
begin
  var aCaption := Piece(ORComboBox1.Items[ORComboBox1.ItemIndex],'^',2);
  If ExecuteForm2(aCaption) then
      begin
        lblItems.Enabled := False;
        ORListBox1.Enabled := False;
        ORListBox1.Clear;
        for i := 0 to uComponents.Count-1 do
          if piece(uComponents[i],'^',1) = IntToStr(uCurrentComponent) then
            ORListBox1.Items.Add(Pieces(uComponents[i],'^',3,10));
        if ORListBox1.Items.Count > 0 then
          begin
            lblItems.Enabled := True;
            ORListBox1.Enabled := True;
            btnEditSubItems.Enabled := True;
          end;
      end;
end;

procedure TfrmReportsAdhocComponent1.edtHeaderNameExit(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ORListBox2.Items.Count - 1 do
    if PHSCompRec(ORListBox2.Items.Objects[i])^.ID = uCurrentComponent then
      PHSCompRec(ORListBox2.Items.Objects[i])^.Header :=
        edtHeaderName.Text;
end;

procedure TfrmReportsAdhocComponent1.edtOccuranceLimitExit(
  Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ORListBox2.Items.Count - 1 do
    if PHSCompRec(ORListBox2.Items.Objects[i])^.ID = uCurrentComponent then
      PHSCompRec(ORListBox2.Items.Objects[i])^.OccuranceLimit :=
        edtOccuranceLimit.Text;
end;

procedure TfrmReportsAdhocComponent1.cboTimeLimitExit(Sender: TObject);
var
  i: integer;
begin
  if cboTimeLimit.Text = 'No Limit' then
    cboTimeLimit.Text := '99Y';
  for i := 0 to ORListBox2.Items.Count - 1 do
    if PHSCompRec(ORListBox2.Items.Objects[i])^.ID = uCurrentComponent then
      PHSCompRec(ORListBox2.Items.Objects[i])^.TimeLimit :=
        cboTimeLimit.Text;
end;

procedure TfrmReportsAdhocComponent1.ckbHospitalLocationExit(
  Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ORListBox2.Items.Count - 1 do
    if PHSCompRec(ORListBox2.Items.Objects[i])^.ID = uCurrentComponent then
      if ckbHospitalLocation.Checked = True then
        PHSCompRec(ORListBox2.Items.Objects[i])^.HospitalLocation := 'Y'
      else
        PHSCompRec(ORListBox2.Items.Objects[i])^.HospitalLocation := 'N';
end;

procedure TfrmReportsAdhocComponent1.ckbProviderNarrativeExit(
  Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ORListBox2.Items.Count - 1 do
    if PHSCompRec(ORListBox2.Items.Objects[i])^.ID = uCurrentComponent then
      if ckbProviderNarrative.Checked = True then
        PHSCompRec(ORListBox2.Items.Objects[i])^.ProviderNarrative := 'Y'
      else
        PHSCompRec(ORListBox2.Items.Objects[i])^.ProviderNarrative := 'N';
end;

procedure TfrmReportsAdhocComponent1.cboICDExit(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ORListBox2.Items.Count - 1 do
    if PHSCompRec(ORListBox2.Items.Objects[i])^.ID = uCurrentComponent then
      PHSCompRec(ORListBox2.Items.Objects[i])^.ICDText := cboICD.Text;
end;

procedure TfrmReportsAdhocComponent1.ORComboBox1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  //This used to be a KeyUp.  I changed it because it can call up the component
  //selection screen, which can be left with a return.  Leaving the component
  //screen happens on key down, so this screen gets focused and receives the key
  //up message, so it pops up tyhe component screen again.
  If Key = 13 then
    with ORComboBox1 do
      if (Text <> '') and (Items.IndexOf (Text) >= 0) then
        begin
          ItemIndex := Items.IndexOf(Text);
          btnAddComponentClick(nil);
        end;
end;

procedure TfrmReportsAdhocComponent1.LoadComponents(Dest: TStrings);
var
  sComponents: TStringList;
  i: integer;
  s: string;
begin
  sComponents := TStringList.Create;
  if uListState = 0 then
    begin
      HSComponents(sComponents);
      for i := 0 to sComponents.Count - 1 do
        begin
          s := sComponents.Strings[i];
          s := MixedCase(piece(s,'[',1)) + '[' + piece(s,'[',2);
          sComponents.Strings[i] := s;
        end;
    end
  else  if uListState = 1 then
    begin
      HSABVComponents(sComponents);
      for i := 0 to sComponents.Count - 1 do
        begin
          s := sComponents.Strings[i];
          s := piece(s,'-',1) + '-' + MixedCase(piece(s,'-',2));
          sComponents.Strings[i] := s;
        end;
    end
  else  if uListState = 2 then
    begin
      HSDispComponents(sComponents);
      for i := 0 to sComponents.Count - 1 do
        begin
          s := sComponents.Strings[i];
          s := MixedCase(piece(s,'[',1)) + '[' + piece(s,'[',2);
          sComponents.Strings[i] := s;
        end;
    end;
  FastAssign(sComponents, Dest);
  sComponents.Free;
end;

procedure TfrmReportsAdhocComponent1.rbtnAbbrevClick(Sender: TObject);
begin
  inherited;
  uListState := 1;
  ORComboBox1.Clear;
  LoadComponents(ORComboBox1.Items);
  ORComboBox1.SetFocus;
end;

procedure TfrmReportsAdhocComponent1.rbtnNameClick(Sender: TObject);
begin
  inherited;
  uListState := 0;
  ORComboBox1.Clear;
  LoadComponents(ORComboBox1.Items);
  ORComboBox1.SetFocus;
end;

procedure TfrmReportsAdhocComponent1.rbtnHeaderClick(Sender: TObject);
begin
  inherited;
  uListState := 2;
  ORComboBox1.Clear;
  LoadComponents(ORComboBox1.Items);
  ORComboBox1.SetFocus;
end;

procedure TfrmReportsAdhocComponent1.pnl5ButtonEnter(Sender: TObject);
begin
  inherited;
  (Sender as TPanel).BevelOuter := bvRaised;
end;

procedure TfrmReportsAdhocComponent1.pnl5ButtonExit(Sender: TObject);
begin
  inherited;
  (Sender as TPanel).BevelOuter := bvNone;
end;

end.
