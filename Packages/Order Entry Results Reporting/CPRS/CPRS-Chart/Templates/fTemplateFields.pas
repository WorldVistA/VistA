unit fTemplateFields;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, ComCtrls, StdCtrls, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmTemplateFields = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnCancel: TButton;
    cboObjects: TORComboBox;
    btnInsert: TButton;
    btnPreview: TButton;
    lblReq: TVA508StaticText;
    pnlBottomSR: TPanel;
    lblSRCont2: TVA508StaticText;
    lblSRCont1: TVA508StaticText;
    lblSRStop: TVA508StaticText;
    pnlSRIntro: TPanel;
    lblSRIntro1: TVA508StaticText;
    lblSRIntro2: TVA508StaticText;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboObjectsNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboObjectsDblClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInsertClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure cboObjectsChange(Sender: TObject);
  private
{    Fre: TRichEdit;}
    Fre: TCustomEdit;
    FInsertAllowed: boolean;
    FInitialized: boolean;
    FAutoLongLines: TNotifyEvent;
    procedure InsertField;
{    procedure Setre(const Value: TRichEdit);}
    procedure Setre(const Value: TCustomEdit);
    function ValidPreview: boolean;
    function ValidInsert: boolean;
  public
    procedure UpdateStatus;
{    property re: TRichEdit read Fre write Setre;}
    property re: TCustomEdit read Fre write Setre;
    property AutoLongLines: TNotifyEvent read FAutoLongLines write FAutoLongLines;
  end;

implementation

uses
  ORFn, rTemplates, uTemplateFields, fTemplateDialog, ORClasses, VAUtils;

{$R *.DFM}

procedure TfrmTemplateFields.FormShow(Sender: TObject);
var
  i: integer;
begin
  if not FInitialized then
  begin
    with cboObjects do
    begin
      for i := low(ScreenReaderCodeLines) to high(ScreenReaderCodeLines) do
        Items.Add(ScreenReaderCodeLines[i]);
      InsertSeparator;
      InitLongList('');
    end;
    FInitialized := TRUE;
  end;
  cboObjects.SelectAll;
  cboObjects.SetFocus;
end;

procedure TfrmTemplateFields.FormCreate(Sender: TObject);
begin
  ResizeFormToFont(self);
  cboObjects.ItemHeight := lblReq.Height - 1;
  FInsertAllowed := TRUE;
  lblReq.Top := (pnlBottom.Height - lblReq.Height);
  pnlSRIntro.Height := lblSRStop.Height;
  pnlBottomSR.Height := lblSRCont1.Height * 4 + 5;
end;

procedure TfrmTemplateFields.cboObjectsNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
var
  tmp: TStringList;
begin
  tmp := TStringList.Create;
  try
    SubSetOfTemplateFields(StartFrom, Direction, tmp);
    ConvertCodes2Text(tmp, FALSE);
    cboObjects.ForDataUse(tmp);
  finally
    FreeAndNil(tmp);
  end;
end;

procedure TfrmTemplateFields.InsertField;
var
  cnt: integer;
  p1, p2: string;
  check: boolean;
  i: integer;

begin
  p1 := Piece(cboObjects.Items[cboObjects.ItemIndex],U,1);
  if p1 = '' then exit;
  if assigned(Fre) and (not TORExposedCustomEdit(Fre).ReadOnly) and (cboObjects.ItemIndex >= 0) then
  begin
    if Fre is TRichEdit then
      cnt := TRichEdit(FRe).Lines.Count
    else
      cnt := 0;
    if StrToIntDef(p1, 0) < 0 then
    begin
      check := true;
      for i := low(ScreenReaderCodeIDs) to high(ScreenReaderCodeIDs) do
      begin
        if p1 = ScreenReaderCodeIDs[i] then
        begin
          p2 := ScreenReaderCodes[i];
          check := FALSE;
          break;
        end;
      end;
    end
    else
      check := TRUE;
    if check then
      p2 := TemplateFieldBeginSignature + Piece(cboObjects.Items[cboObjects.ItemIndex],U,2) +
            TemplateFieldEndSignature;
    Fre.SelText := p2;
    if Fre is TRichEdit then
      if(assigned(FAutoLongLines) and (cnt <> TRichEdit(FRe).Lines.Count)) then
        FAutoLongLines(Self);
  end;
end;

procedure TfrmTemplateFields.cboObjectsDblClick(Sender: TObject);
begin
  if ValidInsert then
    InsertField;
end;

procedure TfrmTemplateFields.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTemplateFields.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmTemplateFields.Setre(const Value: TCustomEdit);
begin
  Fre := Value;
  UpdateStatus;
end;

procedure TfrmTemplateFields.UpdateStatus;
begin
  FInsertAllowed := (not TORExposedCustomEdit(re).ReadOnly);
  btnInsert.Enabled := ValidInsert and FInsertAllowed;
end;

function TfrmTemplateFields.ValidInsert: boolean;
begin
  Result := (cboObjects.ItemIndex >= 0);
  if Result then
    Result := (Piece(cboObjects.Items[cboObjects.ItemIndex],U,1) <> '');
end;

function TfrmTemplateFields.ValidPreview: boolean;
var
  i: integer;
  code: string;
begin
  Result := ValidInsert;
  if Result then
  begin
    code := Piece(cboObjects.Items[cboObjects.ItemIndex],U,1);
    for I := low(ScreenReaderCodeIDs) to high(ScreenReaderCodeIDs) do
    begin
      if code = ScreenReaderCodeIDs[i] then
      begin
        Result := FALSE;
        break;
      end;
    end;
  end;
end;

procedure TfrmTemplateFields.btnInsertClick(Sender: TObject);
begin
  if ValidInsert then
    InsertField;
end;

procedure TfrmTemplateFields.btnPreviewClick(Sender: TObject);
var
  tmp, txt: string;


begin
  if(cboObjects.ItemIndex >= 0) then
  begin
    FormStyle := fsNormal;
    try
      txt := Piece(cboObjects.Items[cboObjects.ItemIndex],U,2);
      tmp := TemplateFieldBeginSignature + txt + TemplateFieldEndSignature;
      CheckBoilerplate4Fields(tmp, 'Preview Template Field: ' + txt, TRUE);
    finally
      FormStyle := fsStayOnTop;
    end;
  end;
end;

procedure TfrmTemplateFields.cboObjectsChange(Sender: TObject);
begin
  btnPreview.Enabled := ValidPreview;
  btnInsert.Enabled := ValidInsert and FInsertAllowed;
end;

end.
