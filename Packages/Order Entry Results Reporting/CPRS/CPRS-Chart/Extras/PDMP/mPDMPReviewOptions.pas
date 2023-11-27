unit mPDMPReviewOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfrPDMPReviewOptions = class(TFrame)
    sbPDMP: TScrollBox;
    gbPDMP: TGroupBox;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ReviewHandler: HWND;
    procedure alignPDMPControls;
    procedure activateItem(anItem: TObject);
    procedure setView(aStrings: TSTrings);
    function getValue: String;
    function getOptionsHeight: Integer;
    function IsValid(var sError:String): Boolean;
    function IsCheckedRB: Boolean;
    procedure setFontSize(aSize:Integer);
  end;

implementation

uses
  ORFn, mPDMPReviewItem, uPDMP, UResponsiveGUI;

{$R *.dfm}

function TfrPDMPReviewOptions.getOptionsHeight: Integer;
var
  i: Integer;
begin
  Result := 24;//40;
  for i := 0 to gbPDMP.ControlCount - 1 do
    if gbPDMP.Controls[i] is TfrPDMPReviewItem then
      Result := Result + TfrPDMPReviewItem(gbPDMP.Controls[i])
        .getHeight(gbPDMP.Width - ReservedWidth);
end;

procedure TfrPDMPReviewOptions.setView(aStrings: TSTrings);
var
  i: Integer;

  procedure addRI(i: Integer; aData: String; aParent: TWinControl);
  var
    // aSuffix,
    aType, aCaption, aComment, aPrefix, aWarning, anAlignment: String;
    ri: TfrPDMPReviewItem;
    bDefault: Boolean;
  begin
    aType := piece(aData, U, 1);

    bDefault := pos('*', aType) = 1; // item should be selected by default
    if bDefault then
      aType := copy(aType, 2, Length(aType));

    if not isValidType(aType) then
      exit;

    aCaption := piece(aData, U, 2);
    aComment := piece(aData, U, 3);
    aWarning := piece(aData, U, 4);
    anAlignment := piece(aData, U, 5);
    aPrefix := piece(aData, U, 6);

    begin
      ri := TfrPDMPReviewItem.Create(gbPDMP);
      ri.Name := aType + '_' + IntToStr(i);
      ri.Align := alBottom;
      ri.Visible := True;
      ri.ItemType := aType;
      ri.ItemInfo := aCaption;
      ri.ItemComment := aComment;
      ri.CommentLines := 3;
      ri.RequiresComment := aComment <> '';
      ri.MandatoryComment := aComment = '1';
      ri.ItemWarning := aWarning;
      ri.ItemAlignment := anAlignment;
      ri.Hint := getCommentHint(ri.MandatoryComment);
      {
        if aPrefix <> '' then
        begin
        aSuffix := '</' + aPrefix + '>';
        aPrefix := '<' + aPrefix + '>';
        end
        else
        aSuffix := '';
        ri.ItemPrefix := aPrefix;
        ri.ItemSuffix := aSuffix;
      }
      ri.ItemPrefix := '';
      ri.ItemSuffix := '';

      ri.AlignWithMargins := True;
      ri.setDefaultStatus(bDefault);
      ri.Parent := aParent;
      ri.Align := alTop;

      TResponsiveGUI.ProcessMessages;
    end;
  end;

begin
  while gbPDMP.ControlCount > 0 do
    gbPDMP.Controls[0].Free;

  for i := 0 to aStrings.Count - 1 do
    addRI(i, aStrings[i], gbPDMP);

  setFontSize(Application.MainForm.Font.Size);
  getOptionsHeight;
end;

procedure TfrPDMPReviewOptions.alignPDMPControls;
var
  h: Integer;
begin
  h := getOptionsHeight;
  if h < sbPDMP.Height then
    gbPDMP.Height := sbPDMP.Height -2
  else
    gbPDMP.Height := h;
end;

procedure TfrPDMPReviewOptions.FrameResize(Sender: TObject);
begin
  gbPDMP.Width := self.Width - 24; // scrollbar adjustment
  alignPDMPControls;
  gbPDMP.Left := (self.Width - gbPDMP.Width) div 2 -1;
  TResponsiveGUI.ProcessMessages;
end;

procedure TfrPDMPReviewOptions.activateItem(anItem: TObject);
var
  i: Integer;
  rb: TRadioButton;
begin
  for i := 0 to gbPDMP.ControlCount - 1 do
  begin
    if gbPDMP.Controls[i] is TfrPDMPReviewItem then
    begin
      if TfrPDMPReviewItem(gbPDMP.Controls[i]).ItemType = 'RB' then
      begin
        rb := TRadioButton(TfrPDMPReviewItem(gbPDMP.Controls[i]).Item);
        rb.Checked := (rb = anItem) and TRadioButton(anItem).Checked;
        TfrPDMPReviewItem(gbPDMP.Controls[i]).mm.Enabled := rb.Checked;
        TfrPDMPReviewItem(gbPDMP.Controls[i]).setMemo(rb.Checked);
      end;
    end;
  end;
  alignPDMPControls;
  PostMessage(ReviewHandler, UM_PDMP_REFRESH, 0, 0);
  TResponsiveGUI.ProcessMessages;
end;

function TfrPDMPReviewOptions.getValue: String;
var
  i: Integer;
begin
  for i := 0 to gbPDMP.ControlCount - 1 do
  begin
    if gbPDMP.Controls[i] is TfrPDMPReviewItem then
      Result := Result + TfrPDMPReviewItem(gbPDMP.Controls[i]).getItemValue;
  end;
end;

function TfrPDMPReviewOptions.IsValid(var sError: String): Boolean;
var
  b: Boolean;
  i: Integer;
  sMsg: String;
begin
  Result := True;
  sError := '';
  for i := 0 to gbPDMP.ControlCount - 1 do
  begin
    if gbPDMP.Controls[i] is TfrPDMPReviewItem then
    begin
      sMsg := '';
      b := TfrPDMPReviewItem(gbPDMP.Controls[i]).isValidInput(sMsg);
      Result := Result and b;
      if not b then
        sError := sError + sMsg + CRLF;
    end;
  end;

  b := IsCheckedRB;
  Result := Result and b;
  if not b then
    sError := sError + 'At least one option should be selected';
end;

function TfrPDMPReviewOptions.IsCheckedRB: Boolean;
var
  bRbFound: Boolean;
  i: Integer;
  rb: TRadioButton;
begin
  Result := false;

  bRbFound := false;
  for i := 0 to gbPDMP.ControlCount - 1 do
  begin
    if gbPDMP.Controls[i] is TfrPDMPReviewItem then
    begin
      bRbFound := bRbFound or (TfrPDMPReviewItem(gbPDMP.Controls[i]).ItemType = 'RB');
      if TfrPDMPReviewItem(gbPDMP.Controls[i]).ItemType = 'RB' then
      begin
        rb := TRadioButton(TfrPDMPReviewItem(gbPDMP.Controls[i]).Item);
        Result := Result or rb.Checked;
      end;
    end;
  end;

  if not bRbFound then
    Result := True;
end;

procedure TfrPDMPReviewOptions.setFontSize(aSize: Integer);
var
  i: Integer;
begin
  Font.Size := aSize;
  for i := 0 to gbPDMP.ControlCount - 1 do
  begin
    if gbPDMP.Controls[i] is TfrPDMPReviewItem then
      TfrPDMPReviewItem(gbPDMP.Controls[i]).setFontSize(aSize);
  end;
  FrameResize(nil);
end;

end.
