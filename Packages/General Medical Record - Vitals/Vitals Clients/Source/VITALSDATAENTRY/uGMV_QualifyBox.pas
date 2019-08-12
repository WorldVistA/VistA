unit uGMV_QualifyBox;

interface
uses
  CheckLst
  ,StdCtrls
  ,ExtCtrls
  , Controls
  , Classes
  , Forms
  , mGMV_DefaultSelector
  ;

Type
  TGMV_TemplateQualifierBox = class(TPanel)
//  TGMV_TemplateQualifierBox = class(TGroupBox)
  private
    fDefaultQualifierName: string;
    fVitalIEN: string;
    fDefaultQualifierIEN: string;
    fCategoryIEN: string;
    fViewMode: String;
    fQualifierItems: TStringList;
    fRG: TRadioGroup;
    fCB: TComboBox;

    procedure SetCategoryIEN(const Value: string);
    procedure SetDefaultQualifierIEN(const Value: string);
    procedure SetDefaultQualifierName(const Value: string);
    procedure SetVitalIEN(const Value: string);
    function getIENByName(anIEN:String):String;
  public
    lblName: TLabel;
    constructor CreateParented(anOwner,aParent: TWinControl;
      VitalIEN, CategoryIEN, DefaultIEN: string;ViewMode:String='');
    destructor Destroy; override;
    procedure OnQualEnter(Sender: TObject);
    procedure OnQualExit(Sender: TObject);
  published
    procedure setPopupLayout;
    procedure setDDWidth;
    procedure OnQualClick(Sender: TObject);

    property VitalIEN: string read FVitalIEN write SetVitalIEN;
    property CategoryIEN: string read FCategoryIEN write SetCategoryIEN;
    property DefaultQualifierIEN: string
      read FDefaultQualifierIEN write SetDefaultQualifierIEN;
    property DefaultQualifierName: string
      read FDefaultQualifierName write SetDefaultQualifierName;
  end;

implementation

uses
  uGMV_Utils
  , Graphics
  , SysUtils
  , uGMV_FileEntry
  , uGMV_Const, uGMV_Common, uGMV_Engine
  ;

{ TGMV_TemplateQualifierBox }

constructor TGMV_TemplateQualifierBox.CreateParented(anOwner,aParent: TWinControl;
  VitalIEN, CategoryIEN, DefaultIEN: string;ViewMode:String='');
var
  SL: TStringList;

  procedure setRadioGroup;
  var
    iDefault,
    i: integer;
    SB: TScrollBox;

  begin
    SB := TScrollBox.Create(self);
    SB.Parent := self;
    SB.Align := alClient;

    fRG := TRadioGroup.Create(self);
    with fRG do
      begin
        Caption := TitleCase(GMVCats.Entries[GMVCats.IndexOfIEN(CategoryIEN)]);
        Parent := SB;
        Color := clWindow;
        Align := alClient;
        iDefault := 0;
        for i := 0 to fQualifierItems.Count - 1 do
          begin
            Items.Add(TitleCase(Piece(fQualifierItems[i], '^', 2)));
            if Piece(fQualifierItems[i], '^', 1)=DefaultIEN then
              iDefault := i;
          end;
        ItemIndex := iDefault;
        OnClick := OnQualClick;
        OnEnter := OnQualEnter;
        OnExit := OnQualExit;
      end;
  end;

  procedure setDropDownList;
  var
    iDefault,
    i: integer;
  begin
    Height := 22;
    ParentFont := False;
    lblName := TLabel.Create(AnOwner);
    lblName.Caption := TitleCase(GMVCats.Entries[GMVCats.IndexOfIEN(CategoryIEN)]);
    lblName.Top := 4;
    lblName.Left := 8;
    lblName.Parent := self;

    fcb := TComboBox.Create(Self);
    fcb.Left := 80;
    fcb.Top := 2;
    fcb.Parent := Self;
    iDefault := -1;
    for i := 0 to fQualifierItems.Count - 1 do
      begin
        fcb.Items.Add(TitleCase(Piece(fQualifierItems[i], '^', 2)));
        if Piece(fQualifierItems[i], '^', 1)=DefaultIEN then
          iDefault := i;
      end;
    fcb.ItemIndex := iDefault;
    fcb.OnChange := OnQualClick;
    fCB.OnEnter := OnQualEnter;
    fCB.OnExit:= OnQualExit;
    lblName.FocusControl := fCB;
  end;

begin
  inherited Create(anOwner);
  fQualifierItems := TStringList.Create;

  Visible := False;
  Parent := aParent;
  Align := alTop;

  BevelInner := bvNone;
  BevelOuter := bvNone;
  Caption := '  '+TitleCase(GMVCats.Entries[GMVCats.IndexOfIEN(CategoryIEN)]);

  FVitalIEN := VitalIEN;
  FCategoryIEN := CategoryIEN;
  FDefaultQualifierName := DefaultIEN;

  SL := getQualifiers(VitalIEN,CategoryIEN);
  fQualifierItems.Text := SL.Text;
  if fQualifierItems.Count > 0 then
    fQualifierItems[0] := '-None-';
  SL.Free;

  fViewMode := ViewMode;
  if fViewMode = '' then
    setDropDownList
  else
    setRadioGroup;
end;

destructor TGMV_TemplateQualifierBox.Destroy;
begin
  FreeAndNil(fQualifierItems);
  inherited;
end;

procedure TGMV_TemplateQualifierBox.OnQualEnter(Sender: TObject);
begin
  Font.Style := [fsBold];
  fCB.Font.Style := [];
  fCB.Color := clInfoBk;
end;

procedure TGMV_TemplateQualifierBox.OnQualExit(Sender: TObject);
begin
  Font.Style := [];
  fCB.Color := clWindow;
end;

function TGMV_TemplateQualifierBox.getIENByName(anIEN:String):String;
var
  s:String;
  i: Integer;
begin
  Result := '';
  for i := 1 to  fQualifierItems.Count - 1 do
    begin
      s := fQualifierItems[i];
      if piece(s,'^',2) = uppercase(fDefaultQualifierName) then
        begin
          Result := piece(s,'^',1);
          break;
        end;
    end;
end;

procedure TGMV_TemplateQualifierBox.OnQualClick(Sender: TObject);
begin
  if fViewMode <> '' then
    begin
      FDefaultQualifierName := fRG.Items[fRG.ItemIndex];
      FDefaultQualifierIEN := Piece(fQualifierItems[fRG.ItemIndex], '^', 1);
    end
  else
    begin
      FDefaultQualifierName := fCB.Text;
      fDefaultQualifierIEN := getIENByName(FDefaultQualifierName);
    end;
  Self.OnClick(Self);
end;

procedure TGMV_TemplateQualifierBox.SetCategoryIEN(const Value: string);
begin
  FCategoryIEN := Value;
end;

procedure TGMV_TemplateQualifierBox.SetDefaultQualifierIEN(const Value: string);
var
  i: integer;
begin
  FDefaultQualifierIEN := '-1';
  i := GMVQuals.IndexOfIEN(Value);
  if i > -1 then
    for i := 0 to fQualifierItems.Count - 1 do
      begin
        if pos(Value,fQualifierItems[i]) = 1 then
          begin
            if fViewMode <> '' then
              begin
                fRG.ItemIndex := i;
                FDefaultQualifierName := fRG.Items[i];
              end
            else
              begin
                fCB.ItemIndex := i;
                FDefaultQualifierName := fCB.Text;
              end;
            FDefaultQualifierIEN := Value;
          end;
      end;
end;

procedure TGMV_TemplateQualifierBox.SetDefaultQualifierName(const Value: string);
begin
  FDefaultQualifierName := Value;
end;

procedure TGMV_TemplateQualifierBox.SetVitalIEN(const Value: string);
begin
  FVitalIEN := Value;
end;

procedure TGMV_TemplateQualifierBox.setPopupLayout;
begin
  setDDWidth;
end;

procedure TGMV_TemplateQualifierBox.setDDWidth;
begin
  fCB.Width := self.Width - fCB.Left - 4;
end;


end.
