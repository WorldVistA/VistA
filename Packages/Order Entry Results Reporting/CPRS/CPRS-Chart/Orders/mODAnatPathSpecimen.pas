unit mODAnatPathSpecimen;

// Developer: Theodore Fontana
// 02/24/17

interface

uses
  Winapi.Windows, Winapi.Messages, System.StrUtils, System.SysUtils,
  System.Variants, System.Classes, System.Types, System.Generics.Collections,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Graphics, Vcl.Menus, Vcl.CheckLst, Vcl.Buttons, ORCtrls, fODBase,
  VA508AccessibilityManager, rODAnatPath, oODAnatPath, fBase508Form;

const
  WM_TRACK_DESC = WM_USER + 472;
  SPEC_DESC_PARTS = 20;

type
  TCollSamp = class(TObject)
  private
    CollSampIEN: Integer;                 // IEN of Collection Sample
    CollSampName: string;
    SpecimenIEN: Integer;                 // IEN of Specimen
    SpecimenName: string;
    TubeColor: string;                    // TubeColor (text)
    MinInterval: Integer;                 // Minimum days between orders
    MaxPerDay: Integer;                   // Maximum orders per day
    SampReqComment: string;               // Name of required comment
    FWardComment: TStringList;            // CollSamp specific comment
  public
    constructor Create;
    destructor Destroy; override;
    property WardComment: TStringList read FWardComment;
  end;

  TfraAnatPathSpecimen = class;

  TLabSpecimen = class(TObject)
  private
    FOwner: TfraAnatPathSpecimen;
    FSpecI: string;
    FSpecE: string;
    FSpecDesc: string;
    FCollSampI: string;
    FCollSampE: string;
  public
    constructor Create(AOwner: TfraAnatPathSpecimen); overload;
    destructor Destroy; override;
    property Owner: TfraAnatPathSpecimen read FOwner write FOwner;
    property SpecimenInternal: string read FSpecI write FSpecI;
    property SpecimenExternal: string read FSpecE write FSpecE;
    property SpecimenDescription: string read FSpecDesc write FSpecDesc;
    property CollectionSampleInternal: string read FCollSampI write FCollSampI;
    property CollectionSampleExternal: string read FCollSampE write FCollSampE;
  end;

  TfraAnatPathSpecimen = class(TfrmBase508Form)
    lblCharLimit: TLabel;
    gplBody: TGridPanel;
    cbxCollSamp: TORComboBox;
    lblCollSamp: TLabel;
    lblDescription: TLabel;
    btnDelete: TBitBtn;
    edtSpecimenDesc: TEdit;
    VA508SpecimenDescription: TVA508ComponentAccessibility;
    VA508Specimen: TVA508ComponentAccessibility;
    VA508CollectionSample: TVA508ComponentAccessibility;
    grdHeader: TGridPanel;
    lblSpecimen: TLabel;
    lblEmptySpace: TLabel;
    edtSpecimen: TEdit;
    sbxMain: TScrollBox;
    procedure VA508CaptionQuery(Sender: TObject; var Text: string);
    procedure SpecimenDescChange(Sender: TObject;
      var bValid: Boolean; sNewVal,sOldVal: string);
    procedure ledtSpecimenDescChange(Sender: TObject);
    procedure ledtSpecimenDescKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ledtSpecimenDescKeyPress(Sender: TObject; var Key: Char);
    procedure btnDeleteClick(Sender: TObject);
    procedure cbxCollSampChange(Sender: TObject);
    procedure cboCollSampAction(Sender: TObject);
    procedure edtSpecimenDescExit(Sender: TObject);
  private
    bSuppressCollectDialog: Boolean;
    FLabSpecimen: TLabSpecimen;
    FCollSampList: TList;             // The list of possible Collection Samples
    FCollectionSample: TCollSamp;     // The Collection Sample for this Specimen
    FElements: TStringList;           // TBuilderElement sorted by Position + Specimen (optional)
    FHideSpec: Boolean;
    FSpecPosition: Integer;
    FCSHide: Boolean;
    FCSDefaultIEN: Integer;
    FClear: Boolean;
    FDelete: Boolean;
    FSpecDescWas: string;
    aOldString: array of string;
    aOldLength: array of Integer;
    procedure WMTrackDesc(var Message: TMessage); message WM_TRACK_DESC;
    procedure SetLabSpecimen(const lsValue: TLabSpecimen);
    procedure SetCollSamp(const csValue: TCollSamp);
    procedure LoadCollSamp;
    procedure LoadAllSamples;
    procedure FillCollSampList(slLoadData: TStringList);
    procedure GetAllCollSamples;
    function CollSampbyIEN(iIEN: Integer): TCollSamp;
    function PageReference: string;
    function PageNumber: Integer;
    function BuildSpecDescription: string;
  protected
    procedure UpdateLength;
    procedure DeleteAction(sSpecDescIs: string);
    procedure UpdateForm(sValue: string);
    procedure AddControlItem(sIEN,sTitle,sHide,sReq,sDefault,sPosition,sVals: string);
    procedure CreateBuildReturn(sValue: string;
      var BuildList: TObjectList<TBuildReturn>);
    procedure FinishBuildingThisFrame;
    function NextCell(var iCol: Integer; var iRow: Integer): Boolean;
    function GetIndex(iPos: Integer): Integer;
    function GetOddIndex(iIndex: Integer): Integer;
    function GetStringPos(iIndex,iPos: Integer): Integer;
    function GetBuilderElement(iIndex: Integer): TBuilderElement;
    property CollectionSample: TCollSamp read FCollectionSample write SetCollSamp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ResizeGrids;
    procedure Build(sSpecimen: string; iSpecimen: Integer; bSuppressDialogs: Boolean);
    property Elements: TStringList read FElements;
    property LabSpecimen: TLabSpecimen read FLabSpecimen write SetLabSpecimen;
  end;

implementation

{$R *.dfm}

uses
  ORNet, ORfn, VAUtils, rODLab, fODLabOthCollSamp, fODAnatPath;

{$REGION 'TCollSamp'}

// Public ----------------------------------------------------------------------

constructor TCollSamp.Create;
begin
  FWardComment := TStringList.Create;
end;

destructor TCollSamp.Destroy;
begin
  FWardComment.Free;
  inherited;
end;

{$ENDREGION}

{$REGION 'TLabSpecimen'}

// Public ----------------------------------------------------------------------

constructor TLabSpecimen.Create(AOwner: TfraAnatPathSpecimen);
begin
  inherited Create;

  FOwner := AOwner;

  if ALabTest <> nil then
    ALabTest.LabSpecimenList.Add(Self);
end;

destructor TLabSpecimen.Destroy;
begin
  if ALabTest <> nil then
  begin
    ALabTest.LabSpecimenList.Extract(Self);
    frmODAnatPath.UpdateSpecimenResponses(True);
  end;

  inherited;
end;

{$ENDREGION}

{$REGION 'TfAnatPathSpecimen'}

procedure TfraAnatPathSpecimen.VA508CaptionQuery(Sender: TObject; var Text: string);
begin
  case TComponent(Sender).Tag of
   1: Text := 'Required field specimen description anatomic site 75 character limit.';
   2: Text := 'Required field specimen.';
   3: Text := 'Required field collection sample.';
  end;
end;

procedure TfraAnatPathSpecimen.SpecimenDescChange(Sender: TObject;
  var bValid: Boolean; sNewVal,sOldVal: string);
var
  sVal: string;
begin
  if FClear then
    Exit;

  sVal := BuildSpecDescription;
  if Length(sVal) > 75 then
  begin
    bValid := False;
    ShowMsg('Specimen Description exceeds max length.');
    Exit;
  end;

  edtSpecimenDesc.Text :=  sVal;
end;

procedure TfraAnatPathSpecimen.ledtSpecimenDescChange(Sender: TObject);
var
  iPg: Integer;
begin
  iPg := PageNumber;
  if iPg > 0 then
  begin
    iPg := iPg - 1;
    if iPg < frmODAnatPath.lvwSpecimen.Items.Count then
      frmODAnatPath.lvwSpecimen.Items[iPg].SubItems[0] := edtSpecimenDesc.Text;
  end;

  if FLabSpecimen <> nil then
  begin
    FLabSpecimen.SpecimenDescription := edtSpecimenDesc.Text;
    frmODAnatPath.UpdateSpecimenResponsesQuick(True);
  end;
end;

procedure TfraAnatPathSpecimen.ledtSpecimenDescKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_DELETE) or (Key = VK_BACK) then
  begin
    FDelete := True;
    FSpecDescWas := edtSpecimenDesc.Text;
    PostMessage(Handle, WM_TRACK_DESC, 0, 0);
  end
  else
  begin
    if Length(edtSpecimenDesc.Text) = 75 then
      ShowMsg('Sepcimen Description at max length')
    else
    begin
      FSpecDescWas := edtSpecimenDesc.Text;
      PostMessage(Handle, WM_TRACK_DESC, 0, 0);
    end;
  end;
end;

procedure TfraAnatPathSpecimen.ledtSpecimenDescKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '^' then
    Key := #0;
end;

procedure TfraAnatPathSpecimen.btnDeleteClick(Sender: TObject);
begin
  if ShowMsg('Are you sure you want to delete this entry - doing so means you will have to re-enter data.',
             smiWarning, smbYesNo) = smrYes then
    if ((Owner <> nil) and (Owner is TTabSheet)) then
      frmODAnatPath.DeleteSpecimenPage(TTabSheet(Owner));
end;

procedure TfraAnatPathSpecimen.cbxCollSampChange(Sender: TObject);
var
  ACollSamp: TCollSamp;
begin
  if ((cbxCollSamp.Text = 'Other...') and (cbxCollSamp.ItemIndex >= 0) and
     (cbxCollSamp.ItemIEN = 0)) then
  begin
    GetAllCollSamples;
    Exit;
  end;

  if cbxCollSamp.ItemIEN < 1 then
    Exit;

  ACollSamp := CollSampbyIEN(cbxCollSamp.ItemIEN);
  if ACollSamp = nil then
    Exit;
  CollectionSample := ACollSamp;

  if not frmODAnatPath.Changing then
    if ACollSamp.WardComment.Count > 0 then
      frmODAnatPath.OrderMessage(ACollSamp.WardComment.Text);
end;

procedure TfraAnatPathSpecimen.cboCollSampAction(Sender: TObject);
begin
  inherited;

  if ((cbxCollSamp.Text = 'Other...') and (cbxCollSamp.ItemIndex >= 0) and
     (cbxCollSamp.ItemIEN = 0)) then
    GetAllCollSamples;
end;

procedure TfraAnatPathSpecimen.GetAllCollSamples;
var
  OtherSamp: string;
begin
  cbxCollSamp.DroppedDown := False;

  if ((FCollSampList.Count + 1) <= cbxCollSamp.Items.Count) then
    LoadAllSamples;

  if bSuppressCollectDialog then
    Exit;
  OtherSamp := SelectOtherCollSample(MainFontSize, 0, FCollSampList);
  if OtherSamp = '-1' then
    Exit;

  if cbxCollSamp.SelectByID(Piece(OtherSamp,U,1)) = -1 then
    cbxCollSamp.Items.Insert(0, OtherSamp);

  cbxCollSamp.SelectByID(Piece(OtherSamp, U, 1));
  cbxCollSamp.OnChange(nil);
end;

procedure TfraAnatPathSpecimen.LoadAllSamples;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    LoadSamples(sl);
    FillCollSampList(sl);
  finally
    sl.Free;
  end;
end;

procedure TfraAnatPathSpecimen.FillCollSampList(slLoadData: TStringList);
var
  ACollSamp: TCollSamp;
  I,J: Integer;
begin
  // 1  2        3         4       5         6          7         8          9                     10
  // n^IEN^CollSampName^SpecIEN^TubeTop^MinInterval^MaxPerDay^LabCollect^SampReqCommentIEN;name^SpecName
  ACollSamp := nil;
  for I := 0 to slLoadData.Count - 1 do
    if slLoadData[I] = '~CollSamp' then
      for J := I to slLoadData.Count - 1 do
        if slLoadData[J] <> '' then
        begin
          if slLoadData[J][1] = '~' then
            if slLoadData[J] <> '~CollSamp' then
              Exit;
          if slLoadData[J][1] = 'i' then
          begin
            ACollSamp := TCollSamp.Create;
            ACollSamp.CollSampIEN := StrToInt(Piece(slLoadData[J],U,2));
            ACollSamp.CollSampName := Piece(slLoadData[J],U,3);
            ACollSamp.SpecimenIEN := StrToIntDef(Piece(slLoadData[J],U,4), 0);
            ACollSamp.SpecimenName := Piece(slLoadData[J],U,10);
            ACollSamp.TubeColor := Piece(slLoadData[J],U,5);
            ACollSamp.MinInterval := StrToIntDef(Piece(slLoadData[J],U,6), 0);
            ACollSamp.MaxPerDay := StrToIntDef(Piece(slLoadData[J],U,7), 0);
            ACollSamp.SampReqComment := Piece(slLoadData[J],U,9);

            FCollSampList.Add(ACollSamp);
          end
          else if slLoadData[J][1] = 't' then
            if ACollSamp <> nil then
              ACollSamp.FWardComment.Add(Copy(slLoadData[J],2,255));
        end;
end;

// Private ---------------------------------------------------------------------

procedure TfraAnatPathSpecimen.WMTrackDesc(var Message: TMessage);
var
  sSpecDescIs: string;
  I,iIndex: Integer;
  BuilderElement: TBuilderElement;
begin
  sSpecDescIs := edtSpecimenDesc.Text;

  if FDelete then
    DeleteAction(sSpecDescIs);

  if Length(sSpecDescIs) >= Length(FSpecDescWas) then
  begin
    if Length(FSpecDescWas) = 0 then
      aOldString[0] := sSpecDescIs
    else 
    begin
      for I := 1 to Length(sSpecDescIs) do
        if (I > Length(FSpecDescWas)) or (sSpecDescIs[I] <> FSpecDescWas[I]) then
        begin
          iIndex := GetIndex(I);
          if Odd(iIndex) then
          begin
            FClear := True;
            BuilderElement := GetBuilderElement(iIndex);
            if BuilderElement <> nil then
            begin
              BuilderElement.Initalize;
              BuilderElement.Edited := True;
            end
            else
              iIndex := iIndex - 1;
            FClear := False;
          end;
          Insert(sSpecDescIs[I], aOldString[iIndex], GetStringPos(iIndex, I));
          UpdateLength;
          Break;
        end;
    end;
  end;
end;

procedure TfraAnatPathSpecimen.SetLabSpecimen(const lsValue: TLabSpecimen);
var
  iSamp: Integer;
begin
  FLabSpecimen := lsValue;
  FLabSpecimen.Owner := Self;

  // *** Collection Sample
  iSamp := StrToIntDef(FLabSpecimen.CollectionSampleInternal, 0);
  if iSamp > 0 then
  begin
    if cbxCollSamp.SelectByIEN(iSamp) = -1 then
      cbxCollSamp.Items.Add(IntToStr(iSamp) + U + FLabSpecimen.CollectionSampleExternal);
    cbxCollSamp.ItemIndex := ItemInList(cbxCollSamp, FLabSpecimen.CollectionSampleExternal);
    cbxCollSampChange(nil);
  end;

  // *** Specimen Description
  edtSpecimenDesc.Text := FLabSpecimen.SpecimenDescription;
end;

procedure TfraAnatPathSpecimen.SetCollSamp(const csValue: TCollSamp);
begin
  FCollectionSample := csValue;

  if FLabSpecimen <> nil then
  begin
    if csValue <> nil then
    begin
      FLabSpecimen.CollectionSampleInternal := IntToStr(csValue.CollSampIEN);
      FLabSpecimen.CollectionSampleExternal := csValue.CollSampName;
    end
    else
    begin
      FLabSpecimen.CollectionSampleInternal := '';
      FLabSpecimen.CollectionSampleExternal := '';
    end;
  end;
end;

procedure TfraAnatPathSpecimen.LoadCollSamp;
var
  I: Integer;
  ACollSamp: TCollSamp;
  sItem: string;
begin
  cbxCollSamp.Clear;

  if ALabTest = nil then
    Exit;

  FillCollSampList(ALabTest.LoadedTestData);

  if FCollSampList.Count > 0 then
  begin
    for I := 0 to FCollSampList.Count - 1 do
    begin
      ACollSamp := TCollSamp(FCollSampList.Items[I]);

      sItem := IntToStr(ACollSamp.CollSampIEN) + U + ACollSamp.CollSampName;
      if ACollSamp.TubeColor <> '' then
        sItem := sItem + ' (' + ACollSamp.TubeColor + ')';
      cbxCollSamp.Items.Add(sItem);

      if ACollSamp.CollSampIEN = FCSDefaultIEN then
        cbxCollSamp.ItemIndex := I;
    end;
  end
  else
  begin
    cbxCollSamp.Items.Add('0^Other...');
    cbxCollSamp.ItemIndex := 0;
  end;

  cbxCollSampChange(nil);
end;

function TfraAnatPathSpecimen.CollSampbyIEN(iIEN: Integer): TCollSamp;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to FCollSampList.Count - 1 do
    if TCollSamp(FCollSampList.Items[I]).CollSampIEN = iIEN then
    begin
      Result := TCollSamp(FCollSampList.Items[I]);
      Break;
    end;
end;

function TfraAnatPathSpecimen.PageReference: string;
begin
  if FLabSpecimen <> nil then
    Result := 'SP;' + FLabSpecimen.SpecimenInternal
  else
    Result := 'SP;0';
end;

procedure TfraAnatPathSpecimen.ResizeGrids;
const
  GAP = 6;

var
  i, ht, dy, gy: integer;
  ctrls: array of integer;

begin
  Font.Size := MainFont.Size;
  lblDescription.Font.Size := MainFont.Size + 2;
  grdHeader.ColumnCollection.BeginUpdate;
  try
    grdHeader.ColumnCollection[0].Value := Canvas.TextWidth(lblSpecimen.Caption) + GAP;
    grdHeader.ColumnCollection[1].Value := TextWidthByFont(lblDescription.Font.Handle,
      lblDescription.Caption) + GAP*2  - grdHeader.ColumnCollection[0].Value;
    grdHeader.ColumnCollection[3].Value := Canvas.TextWidth(lblCollSamp.Caption) + GAP;
    grdHeader.ColumnCollection[5].Value := Canvas.TextWidth(btnDelete.Caption) + 20;
  finally
    grdHeader.ColumnCollection.EndUpdate;
  end;
  ht := Canvas.TextHeight(lblSpecimen.Caption);
  grdHeader.Height := ht * 5;

  SetLength(ctrls, gplBody.RowCollection.Count);
  for i := 0 to gplBody.ControlCollection.Count - 1 do
    // not sure how, but getting Row = -1 on some entries
    if gplBody.ControlCollection[i].Row >= 0 then
      ctrls[gplBody.ControlCollection[i].Row] := 1;
  dy := ht * 4;
  gy := 0;
  gplBody.RowCollection.BeginUpdate;
  try
    for i := 0 to gplBody.RowCollection.Count - 1 do
      if ctrls[i] > 0 then
      begin
        gplBody.RowCollection[i].Value := dy;
        inc(gy, dy);
      end
      else
        gplBody.RowCollection[i].Value := 0.0;
  finally
    gplBody.RowCollection.EndUpdate;
  end;
  gplBody.Height := gy;
end;

function TfraAnatPathSpecimen.PageNumber: Integer;
begin
  Result := 0;

  if ((Owner = nil) or not (Owner is TTabSheet)) then
    Exit;

  Result := TTabSheet(Owner).PageIndex + 1;
end;

function TfraAnatPathSpecimen.BuildSpecDescription: string;
var
  aString: array of string;
  I,iPos: Integer;
  BuildElement: TBuilderElement;
begin
  Result := '';
  SetLength(aString, 20);
  try
    // Specimen
    if not FHideSpec then
      aString[GetOddIndex(FSpecPosition)] := edtSpecimen.Text;
    // Build Components
    FElements.Sort;
    for I := 0 to FElements.Count - 1 do
    begin
      BuildElement := TBuilderElement(FElements.Objects[I]);
      iPos := I + 1;
      if not FHideSpec and (FSpecPosition = iPos) then
        Inc(iPos);

      if BuildElement.Edited then
        aString[GetOddIndex(iPos)] := aOldString[GetOddIndex(iPos)]
      else
        aString[GetOddIndex(iPos)] := Trim(BuildElement.Value + ' ' + BuildElement.ValueEx);
    end;
    for I := 0 to SPEC_DESC_PARTS - 1 do
    begin
      if Odd(I) then
      begin
        if aString[I] <> '' then
        begin
          aOldString[I] := aString[I];
          Result := Result + aOldString[I]
        end;
      end
      else
      begin
        if Trim(aOldString[I]) = '' then
        begin
          aOldString[I] := ' ';
          if ((Length(Result) > 0) and (Result[Length(Result)] <> ' ')) then
            Result := Result + aOldString[I]
        end
        else
          Result := Result + aOldString[I];
      end;
      aOldLength[I] := Length(Result);
    end;
  finally
    SetLength(aString, 0);
  end;
end;

// Protected -------------------------------------------------------------------

procedure TfraAnatPathSpecimen.UpdateLength;
var
  iLength,I: Integer;
begin
  iLength := 0;
  for I := 0 to Length(aOldString) - 1 do
  begin
    iLength := iLength + Length(aOldString[I]);
    aOldLength[I] := iLength
  end;
end;

procedure TfraAnatPathSpecimen.UpdateForm(sValue: string);
var
  I: Integer;
begin
  // Hide Specimen from the Specimen Description
  if Piece(sValue,U,3) = '1' then
    FHideSpec := True
  else
    FHideSpec := False;

  // If Specimen is part of the Specimen Description this will be its position
  FSpecPosition := StrToIntDef(Piece(sValue,U,4), 0);

  // Hide the Collection Sample
  if Piece(sValue,U,5) = '1' then
    FCSHide := True
  else
    FCSHide := False;

  // Default the Collection Sample based on IEN
  if TryStrToInt(Piece(sValue,U,6), I) then
    FCSDefaultIEN := I
  else
    FCSDefaultIEN := 0;
end;

procedure TfraAnatPathSpecimen.AddControlItem(sIEN,sTitle,sHide,sReq,sDefault,
  sPosition,sVals: string);
var
  iCol,iRow: Integer;
  ControlItem: TControlItem;
  BuilderElement: TBuilderElement;
begin
  if not NextCell(iCol,iRow) then
    Exit;

  ControlItem := gplBody.ControlCollection.Add;

  BuilderElement := TBuilderElement.Create(Self);
  BuilderElement.Parent := gplBody;
  BuilderElement.IEN := sIEN;

  FElements.AddObject(sPosition, BuilderElement);

  BuilderElement.Align := alClient;
  BuilderElement.Caption := sTitle;
  BuilderElement.Required := (sReq = '1');

  // Need to have the BuilderElement added to FElements and onValidate set first
  // before running Add due to vDefault
  BuilderElement.Build(sVals, sDefault, sHide);

  BuilderElement.OnValidate := SpecimenDescChange;

  ControlItem.Control := BuilderElement;
  ControlItem.SetLocation(iCol, iRow);
end;

procedure TfraAnatPathSpecimen.CreateBuildReturn(sValue: string;
  var BuildList: TObjectList<TBuildReturn>);
var
  BuildReturn: TBuildReturn;
begin
  // SPB applies to a Builder Element
  // SPV applies to the values of a Builder Element

  BuildReturn := BuildReturnbyIEN(BuildList, Piece(sValue,U,3));
  if BuildReturn = nil then
  begin
    BuildReturn := TBuildReturn.Create;
    BuildReturn.IEN := Piece(sValue,U,3);
    BuildList.Add(BuildReturn);
  end;
  if Piece(sValue,U,1) = 'SPB' then
    BuildReturn.B := sValue
  else if Piece(sValue,U,1) = 'SPV' then
    BuildReturn.V := sValue;
end;

procedure TfraAnatPathSpecimen.FinishBuildingThisFrame;
var
  bDesc: Boolean;
begin
  if FCSDefaultIEN < 1 then
  begin
    if StrToIntDef(uDfltCollSamp, 0) > 0 then
      FCSDefaultIEN := StrToInt(uDfltCollSamp)
    else
      FCSDefaultIEN := StrToIntDef(LRFSAMP, 0);
  end;

  // *** Collection Sample
  LoadCollSamp;

  if FCSHide and (cbxCollSamp.ItemIndex <> -1) then
  begin
    lblCollSamp.Visible := False;
    cbxCollSamp.Visible := False;
  end;

  SetLength(aOldString, SPEC_DESC_PARTS);
  SetLength(aOldLength, SPEC_DESC_PARTS);

  SpecimenDescChange(nil, bDesc, '', '');
end;

function TfraAnatPathSpecimen.NextCell(var iCol: Integer; var iRow: Integer): Boolean;
var
  Ir,Ic: Integer;
begin
  Result := False;

  // If there is no ControlItem or that ControlItem has no control or that
  // control is not visible then we can use that cell.
  for Ir := 0 to gplBody.RowCollection.Count - 1 do
    for Ic := 0 to gplBody.ColumnCollection.Count - 1 do
      if (gplBody.ControlCollection.ControlItems[Ic,Ir] = nil) or
         ((gplBody.ControlCollection.ControlItems[Ic,Ir].Control <> nil) and
          (not gplBody.ControlCollection.ControlItems[Ic,Ir].Control.Visible)) then
      begin
        Result := True;
        iCol := Ic;
        iRow := Ir;
        Exit;
      end;
end;

function TfraAnatPathSpecimen.GetIndex(iPos: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;

  // If I (15) and sOldLength[1] = 23 and Length(sOldString[1]) = 10 then
  // sOldString[1] is 10 to 23 which I (15) is part of meaning that this
  // builder element has been changed therefore this value now becomes part
  // of the free text piece before and the builder element is reset

  for I := 0 to SPEC_DESC_PARTS - 1 do
  begin
    // 1. In between a block
    if ((iPos <= aOldLength[I]) and (iPos >= (aOldLength[I] - Length(aOldString[I])))) then
    begin
      Result := I;
      Break;
    end;
    // 2. The end of a block (one more than) but less than the next
    if ((iPos = (aOldLength[I] + 1)) and (I < (SPEC_DESC_PARTS - 1)) and
        (iPos < aOldLength[I+1])) then
    begin
      Result := I;
      Break;
    end;
    // 3. The end of a block (one more than) while the next block is the same as
    if ((iPos = (aOldLength[I] + 1)) and (I < (SPEC_DESC_PARTS - 1)) and
        (aOldLength[I] = aOldLength[I+1])) then
    begin
      Result := I + 1;
      Break;
    end;
    // 4. The end of a block (one more than) last block
    if (iPos = (aOldLength[I] + 1)) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TfraAnatPathSpecimen.GetOddIndex(iIndex: Integer): Integer;
begin
  Result := 0;

  case iIndex of
    0: Result := 1;
    1: Result := 3;
    2: Result := 5;
    3: Result := 7;
    4: Result := 9;
    5: Result := 11;
  end;
end;

function TfraAnatPathSpecimen.GetStringPos(iIndex,iPos: Integer): Integer;
var
  I,iLength: Integer;
begin
  iLength := 0;
  for I := 0 to iIndex - 1 do
    iLength := aOldLength[I];
  Result := iPos - iLength;
  if Result < 1 then
    Result := 1;
end;

function TfraAnatPathSpecimen.GetBuilderElement(iIndex: Integer): TBuilderElement;
begin
  Result := nil;

  case iIndex of
     1: if 0 <= FElements.Count - 1 then Result := TBuilderElement(FElements.Objects[0]);
     3: if 1 <= FElements.Count - 1 then Result := TBuilderElement(FElements.Objects[1]);
     5: if 2 <= FElements.Count - 1 then Result := TBuilderElement(FElements.Objects[2]);
     7: if 3 <= FElements.Count - 1 then Result := TBuilderElement(FElements.Objects[3]);
     9: if 4 <= FElements.Count - 1 then Result := TBuilderElement(FElements.Objects[4]);
    11: if 5 <= FElements.Count - 1 then Result := TBuilderElement(FElements.Objects[5]);
  end;
end;

procedure TfraAnatPathSpecimen.DeleteAction(sSpecDescIs: string);
var
  I,iIndex: Integer;
  BuilderElement: TBuilderElement;
begin
  if Length(sSpecDescIs) <> Length(FSpecDescWas) then
  begin
    if Length(sSpecDescIs) = 0 then
    begin
      FClear := True;
      for I := 0 to SPEC_DESC_PARTS - 1 do
      begin
        aOldString[I] := '';
        aOldLength[I] := 0;
      end;
      for I := 0 to FElements.Count - 1 do
        TBuilderElement(FElements.Objects[I]).Initalize;
      FClear := False;
    end
    else
    begin
      for I := 1 to Length(FSpecDescWas) do
        if (I > Length(sSpecDescIs)) or (sSpecDescIs[I] <> FSpecDescWas[I]) then
        begin
          iIndex := GetIndex(I);
          Delete(aOldString[iIndex], GetStringPos(iIndex, I), 1);
          if Odd(iIndex) then
          begin
            FClear := True;
            BuilderElement := GetBuilderElement(iIndex);
            if BuilderElement <> nil then
            begin
              BuilderElement.Initalize;
              BuilderElement.Edited := True;
            end;
            FClear := False;
          end;
          UpdateLength;
          Break;
        end;
    end;
  end;
  FDelete := False;
  Exit;
end;

// Public ----------------------------------------------------------------------

constructor TfraAnatPathSpecimen.Create(AOwner: TComponent);
begin
  inherited;
  FLabSpecimen := TLabSpecimen.Create(Self);
  FCollSampList := TList.Create;
  FElements := TStringList.Create(True);
end;

destructor TfraAnatPathSpecimen.Destroy;
var
  I: Integer;
begin
  if Assigned(FLabSpecimen) then
    FLabSpecimen.Free;

  for I := FCollSampList.Count - 1 downto 0 do
    TCollSamp(FCollSampList.Items[I]).Free;
  FCollSampList.Free;

  FElements.Free;
  SetLength(aOldString, 0);
  SetLength(aOldLength, 0);

  inherited;
end;

procedure TfraAnatPathSpecimen.edtSpecimenDescExit(Sender: TObject);
begin
  if ShiftTabIsPressed then
  begin
    if ScreenReaderActive and frmODAnatPath.pnlTotal.TabStop then
      frmODAnatPath.pnlTotal.SetFocus
    else
      frmODAnatPath.lvwSpecimen.SetFocus;
  end;
end;

procedure TfraAnatPathSpecimen.Build(sSpecimen: string; iSpecimen: Integer; bSuppressDialogs: Boolean);
var
  BuildList: TObjectList<TBuildReturn>;
  sl: TStringList;
  I: Integer;
begin
  bSuppressCollectDialog := bSuppressDialogs;
  FCSDefaultIEN := 0;
  FCSHide := False;
  FLabSpecimen.SpecimenInternal := IntToStr(iSpecimen);
  FLabSpecimen.SpecimenExternal := sSpecimen;
  edtSpecimen.Text := sSpecimen;

  gplBody.ControlCollection.BeginUpdate;
  try
    BuildList := TObjectList<TBuildReturn>.Create(True);
    try
      sl := TStringList.Create;
      try
        ConfigureFrame(PageReference, ALabTest.OrderableItemInternal, sl);
        if (sl.Count > 0) and (sl[0] <> '0') then
        begin
          // SPH^SP^HIDE_FROM_DESCRIPTION^POSITION^COLLECTION_SAMPLE_HIDE(1,0)^COLLECTION_SAMPLE_DEFAULT
          // SPB^SP^IEN^TITLE^HIDE^REQUIRED^DEFAULT_VALUE^POSITION
          // SPV^SP^IEN^VAL|VAL
          for I := 0 to sl.Count - 1 do
          begin
            if Piece(sl[I],U,1) = 'SPH' then
              UpdateForm(sl[I])
            else
              CreateBuildReturn(sl[I], BuildList);
          end;

          for I := 0 to BuildList.Count - 1 do
            AddControlItem(Piece(BuildList[I].B,U,3), Piece(BuildList[I].B,U,4), Piece(BuildList[I].B,U,5),
                           Piece(BuildList[I].B,U,6), Piece(BuildList[I].B,U,7), Piece(BuildList[I].B,U,8),
                           Piece(BuildList[I].V,U,4));

          FElements.Sort;
        end;

        FinishBuildingThisFrame;
      finally
        sl.Free;
      end;
    finally
      BuildList.Free;
    end;
  finally
    gplBody.ControlCollection.EndUpdate;
  end;
  ResizeGrids;
end;

{$ENDREGION}

end.
