unit mVimmICE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, mVImmBase, System.ImageList,
  Vcl.ImgList, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls, rvimm, orFn,
  Vcl.ComCtrls, Vcl.Menus, mVimmSelect, ORextensions;

type
  TfraIce = class(TfraParent)
    lstICE: ORextensions.TListView;
    mnuActions: TPopupMenu;
    Splitter1: TSplitter;
    AddImmunization1: TMenuItem;
    ViewHistory1: TMenuItem;
    lstHistory: ORextensions.TListView;
    procedure addImmunization(Sender: TObject);
    procedure viewHistory(Sender: TObject);
    procedure mnuActionsPopup(Sender: TObject);
  private
    { Private declarations }
//    histList: TStrings;
    iceList: TStringList;
    procedure loadICEResults;
    procedure populateGrid(iceResults: TStrings);
    procedure addtoList(idx: integer);
    function getRecordType: integer;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure collapse;
  end;

  TIceHistory = class(TObject)
    immunizationIEN: string;
    immunizationName: string;
    cvxCode: string;
    adminDate: TFMDateTime;
    doseNumber: integer;
    componentCvxCode: string;
    validityCode: string;
    CvxCodeDisplayName: string;
    reasonDisplayName: string;
    historyReason: string;
    historyDisplay: string;
    constructor Create(input: string); overload;
    destructor Destroy; override;
  end;

  TIceResult = class(TObject)
     groupName: string;
     recommendData: string;
     recommendType: string;
     recommendItem: string;
     displayName: string;
     recommendDate: TFMDateTime;
     overDueDate: TFMDateTime;
     earliestDate: TFMDateTime;
     recommendCode: string;
     recommendDisplayName: string;
     dosesRemaining: string;
     reasonCode: string;
     reasonDisplayName : string;
     historyList: TStringlist;
     constructor Create(input: string); overload;
     destructor Destroy; override;
  end;

var
  fraIce: TfraIce;

implementation

{$R *.dfm}

{ TfraIceImmunization }

procedure TfraIce.addImmunization(Sender: TObject);
var
recordType: integer;
grid: TGridPanel;
aControl: TControl;
iceData: TIceResult;
begin
  recordType := getRecordType;
  if recordType < 0 then exit;
  iceData := TIceResult(iceList.Objects[recordType]);
  grid := TGridPanel(self.Parent);
  aControl := grid.ControlCollection.Controls[0, 2];
  if (aControl is TfraVimmSelect) then
    TfraVimmSelect(aControl).startFromIce(iceData.recommendData);

end;

procedure TfraIce.addtoList(idx: integer);
var
 lstItem: TListItem;
 iceData: TIceResult;
 strs: TStrings;
 item: TStringList;
begin
  item := TStringList.create;
  try
  iceData := TIceResult(iceList.Objects[idx]);
  lstice.Items.BeginUpdate;
  strs := TStringList.Create;
  strs.Add(iceData.recommendType);
  strs.Add(iceData.displayName);
  strs.Add(iceData.recommendDisplayName);
  strs.Add(FormatFMDateTime('mm/dd/yyyy', iceData.recommendDate));
  strs.Add(FormatFMDateTime('mm/dd/yyyy', iceData.overDueDate));
  lstItem := lstICE.Items.Add;
  lstItem.Caption := IntToStr(idx);
  lstItem.SubItems := strs;
  lstIce.Items.EndUpdate;
  finally
    FreeAndNil(item);
  end;
end;

procedure TfraIce.collapse;
begin
  if not fCollapsed then spbtnExpandCollapseClick(self);
end;

constructor TfraIce.Create(aOwner: TComponent);
begin
  inherited;
//  HistList := TStringList.Create;
  iceList := TStringList.Create;
  loadICEResults;
end;

destructor TfraIce.Destroy;
var
i: integer;
iceData: TIceResult;
begin
  for i := 0 to self.iceList.Count - 1 do
    begin
      iceData := TIceResult(self.iceList.Objects[i]);
      FreeAndNil(iceData);
    end;
    FreeAndNil(iceList);
//  FreeAndNil(histList);
  inherited;
end;

function TfraIce.getRecordType: integer;
var
lstItem: TListItem;
idx: integer;
begin
  result := -1;
  idx := lstICE.ItemIndex;
  if idx = -1 then
    begin
      ShowMessage('No row selected');
      exit;
    end;
  lstItem := lstICE.Items.Item[idx];
  result := StrToIntDef(lstItem.Caption, -1);
  //name := lstItem.SubItems[0];
  //documType := lstItem.SubItems[1];
  //result := vid + U + name + U + documType;
end;

procedure TfraIce.loadICEResults;
var
iceResults: TStrings;
begin
  iceResults := TStringList.Create;
  try
//    histList.Clear;
    getICEResults(iceResults);
    populateGrid(iceResults);
  finally
    FreeAndNil(iceResults);
  end;
end;

procedure TfraIce.mnuActionsPopup(Sender: TObject);
begin
  inherited;
      mnuActions.Items[1].Enabled := true;
      mnuActions.Items[1].Enabled := true;
end;

procedure TfraIce.populateGrid(iceResults: TStrings);
var
  dueNowList, conditionalList, notDueList: TStrings;
  temp,temp1,hist: string;
  i,idx, tempCNT: integer;
  iceData: TIceResult;
  iceHistory: TIceHistory;
begin
    dueNowList := TStringList.Create;
    conditionalList := TStringLIst.Create;
    notDueList := TStringList.Create;
    tempCNT := iceResults.count - 2;
    iceData := nil;
    try
      for I := 0 to iceResults.Count-1 do
        begin
          temp := iceResults.Strings[i];
          if i = 0 then
            begin
              if Piece(temp, U, 1) = '-1' then
                begin
                  ShowMessage(Piece(temp, u, 2));
                  exit;
                end
            end;
          if Piece(temp, U, 1) = 'GRP' then
            begin
              iceData := TIceResult.Create(temp);
              idx := iceList.AddObject(temp, iceData);
              if iceData.recommendCode = 'RECOMMENDED' then
                 dueNowList.Add(IntToStr(idx))
              else if (iceData.recommendCode = 'FUTURE_RECOMMENDED') or
                      (iceData.recommendCode = 'CONDITIONALLY_RECOMMENDED') then
                   conditionalList.Add(IntToStr(idx))
              else notDueList.Add(IntToStr(idx));
              continue;
            end
          else if (Piece(temp, u, 1) = 'RSN') and (temp1 <> '') then
              begin
                if assigned(iceData) then
                begin
                  iceData.reasonCode := Piece(temp, U, 2);
                  iceData.reasonDisplayName := Piece(temp, U, 3);
                end;
                continue;
              end
          else if Piece(temp, u, 1) = 'HIST' then
            begin
              iceHistory := TIceHistory.Create(temp);
              if (i + 1) <= tempCNT then
                begin
                  hist := iceResults.Strings[i+1];
                  if Piece(hist, U, 1) = 'HISTRSN' then
                    begin
                      iceHistory.historyReason := Piece(hist, u, 2);
                      iceHistory.historyDisplay := Piece(hist, u, 3);
                    end;
                end;
              iceData.historyList.AddObject(FloatToStr(iceHistory.adminDate), iceHistory);
            end;
        end;
      if dueNowList.Count > -1 then
        begin
          for i := 0 to dueNowList.Count - 1 do
            addtoList(StrToInt(dueNowList.Strings[i]));
        end;

      if conditionalList.Count > -1 then
        begin
          for i := 0 to conditionalList.Count - 1 do
            addtoList(StrToInt(conditionalList.Strings[i]));
        end;

      if notDueList.Count > -1 then
        begin
          for i := 0 to notDueList.Count - 1 do
            addtoList(StrToInt(notDueList.Strings[i]));
        end;

    finally
      freeAndNil(dueNowList);
      freeAndNil(conditionalList);
      FreeAndNil(notDueList);
    end;
end;

procedure TfraIce.viewHistory(Sender: TObject);
var
recordType: integer;
i: integer;
lstItem: TListItem;
strs: TStrings;
item: TStringList;
iceData: TIceResult;
iceHist: TIceHistory;
begin
  recordType := getRecordType;
  if recordType = -1 then exit;
  iceData := TIceResult(iceList.Objects[recordType]);
  item := TStringList.create;
  strs := TStringList.Create;
  try
    lstHistory.Clear;
    lstHistory.Items.BeginUpdate;
    for i := 0 to iceData.historyList.Count - 1 do
      begin
        iceHist := TIceHistory(iceData.historyList.Objects[i]);
        strs.Clear;
//        strs.Add(iceHist.immunizationName);
        strs.Add(FormatFMDateTime('mm/dd/yyyy', iceHist.adminDate));
        strs.Add(iceHist.historyDisplay);
        lstItem := lstHistory.Items.Add;
        lstItem.Caption := iceHist.ImmunizationName;
        lstItem.SubItems := strs;
      end;
    lstHistory.Items.EndUpdate;
  finally
    FreeAndNil(item);
    FreeAndNil(strs);
  end;
end;

{ TIceResult }

constructor TIceResult.Create(input: string);
var
tmp: string;
begin
  groupName := Piece(input,u,2);
  tmp := Piece(input,u, 3);
  recommendData := tmp;
  if Piece(tmp, ':', 1) = 'C' then recommendType := 'CVX'
  else recommendType := 'GROUP';
  recommendItem := Piece(tmp, ':', 2);
  displayName := Piece(input,u,4);
  recommendDate := StrToFloatDef(Piece(input,u,5),0);
  overDueDate := StrToFloatDef(Piece(input,u,6),0);
  earliestDate := StrToFloatDef(Piece(input,u,7),0);
  recommendCode := Piece(input,u,8);
  recommendDisplayName := Piece(input,u,9);
  dosesRemaining := Piece(input,u,10);
  historyList := TStringList.Create;
end;

destructor TIceResult.Destroy;
var
i: integer;
history: TIceHistory;
begin
  for i := 0 to self.historyList.Count - 1 do
    begin
      history := TIceHistory(self.historyList.Objects[i]);
      FreeAndNil(history);
    end;
  inherited;
end;

{ TIceHistory }

constructor TIceHistory.Create(input: string);
begin
//    immunizationIEN: string;
//    immunizationName: string;
//    cvxCode: string;
//    adminDate: TFMDateTime;
//    doseNumber: integer;
//    componentCvxCode: string;
//    validityCode: string;
//    validityDisplayName: string;
//    reasonCode: string;
//    reasonDisplayName: string;
//    constructor Create(input: string); overload;

  immunizationIEN := Piece(input, U, 2);
  immunizationName := Piece(input, u, 3);
  cvxcode := Piece(input, u, 4);
  adminDate := StrToFloatDef(Piece(input, u, 5), 0);
  doseNumber := StrToIntDef(Piece(input, u, 6), 0);
  componentCvxCode := Piece(input, u, 7);
  CvxCodeDisplayName := Piece(input, u, 8);
  validityCode := Piece(input, u, 9);
  reasonDisplayName := Piece(input, u, 10);
end;

destructor TIceHistory.Destroy;
begin

  inherited;
end;

end.
