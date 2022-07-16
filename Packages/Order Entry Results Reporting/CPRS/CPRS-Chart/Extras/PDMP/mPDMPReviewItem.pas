unit mPDMPReviewItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, VA508AccessibilityManager, Vcl.Menus;

type
  TfrPDMPReviewItem = class(TFrame)
    mm: TMemo;
    pnlItem: TPanel;
    pnlRequired: TPanel;
    lblRequired: TLabel;
    pnlCanvas: TPanel;
    lblInfo: TLabel;
    popBlank: TPopupMenu;
    procedure rbItemClick(Sender: TObject);
  private
    { Private declarations }
    fMandatoryComment: Boolean;
    fRequiresComment: Boolean;
    fItemAlignment: String;
    fItemType: String;
    fItemInfo: String;
    fItemWarning: String;
    fItemComment: String;
    fItemPrefix: String;
    fItemSuffix: String;
    fCommentLimit: Integer;
    fCommentLines: Integer;
    fDelim: String;
    procedure setItemAlignment(anAlign: String);
    procedure setItemComment(aComment: String);
    procedure setItemType(aItemType: String);
    procedure setItemInfo(aItemInfo: String);

    procedure setItemWarning(aItemWarning: String);
    procedure setRequiesComment(aComment: Boolean);
    procedure setCommentLimit(aLimit: Integer);
    procedure setMandatoryComment(aValue: Boolean);
  public
    { Public declarations }
    Item: TControl;
    property ItemAlignment: String read fItemAlignment write setItemAlignment;
    property CommentLines: Integer read fCommentLines write fCommentLines;
    property Delim: String read fDelim write fDelim;
    property ItemPrefix: String read fItemPrefix write fItemPrefix;
    property ItemSuffix: String read fItemSuffix write fItemSuffix;
    property ItemInfo: String read fItemInfo write setItemInfo;
    property ItemWarning: String read fItemWarning write setItemWarning;
    property ItemType: String read fItemType write setItemType;
    property ItemComment: String read fItemComment write setItemComment;
    property MandatoryComment: Boolean read fMandatoryComment
      write setMandatoryComment;
    property RequiresComment: Boolean read fRequiresComment
      write setRequiesComment;
    property CommentLimit: Integer read fCommentLimit write setCommentLimit;

    function isValidInput(var sMsg: String): Boolean;
    function getItemValue: String;
    function getHeight(aWidth: Integer = 0): Integer;
    procedure setMemo(anActive: Boolean);
    procedure setDefaultStatus(aValue: Boolean);
    procedure setFontSize(aSize: Integer);

    procedure mmKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

function getTextHeight(aText: String; aWidth: Integer): Integer;
function getCommentHint(aRequired: Boolean): String;
function isValidType(aType: String): Boolean;

const
  ftRB = 'RB';
  ftCB = 'CB';
  ftLBL = 'LBL';
  ReservedWidth = 48;

implementation

{$R *.dfm}

uses System.UITypes, mPDMPReviewOptions, Clipbrd, uPDMP, ORFn;

const
  fmtRequiredCommentLimit = 'Comments text can''t be blank or exceed %d chars';
  fmtCommentLimit = 'Comments text can''t exceed %d chars';

function isValidType(aType: String): Boolean;
begin
  Result := (aType = ftRB) or (aType = ftCB) or (aType = ftLBL);
end;

function getTextHeight(aText: String; aWidth: Integer): Integer;
var
  r: TRect;
begin
  r := Rect(0, 0, aWidth, 15);
  DrawText(Application.MainForm.Canvas.Handle, PChar(aText), Length(aText), r,
    DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
  Result := r.Bottom - r.Top;
end;

function AlignByName(aName: String): TAlignment;
begin
  Result := taLeftJustify;
  if uppercase(aName) = 'LEFT' then
    Result := taLeftJustify
  else if uppercase(aName) = 'RIGHT' then
    Result := taRightJustify
  else if uppercase(aName) = 'CENTER' then
    Result := taCenter;
end;

function getCommentHint(aRequired: Boolean): String;
begin
  if aRequired then
    Result := Format(fmtRequiredCommentLimit, [PDMP_COMMENT_LIMIT])
  else
    Result := Format(fmtCommentLimit, [PDMP_COMMENT_LIMIT]);
end;

procedure TfrPDMPReviewItem.mmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // disabling paste
  if (not PDMP_PASTE_ENABLED) and (((Key = ord('V')) and (ssCTRL in Shift)) or
    ((Key = VK_INSERT) and (ssShift in Shift))) then
  begin
    Key := 0;
    beep;
    beep;
    if Clipboard.HasFormat(CF_TEXT) then
      Clipboard.Clear;
  end;
  inherited;
end;

procedure TfrPDMPReviewItem.rbItemClick(Sender: TObject);
var
  ctrl: TControl;

  function getParentControl(aClass: String; aControl: TControl): TControl;
  begin
    if (aControl.Parent = nil) or (aControl.Parent.ClassName = aClass) then
      Result := aControl.Parent
    else
      Result := getParentControl(aClass, aControl.Parent);
  end;

begin
  if ItemType = ftCB then
    mm.Enabled := TCheckBox(Sender).Checked
  else if ItemType = ftRB then
  begin
    ctrl := getParentControl('TfrPDMPReviewOptions', Item);
    if Assigned(ctrl) then
      TfrPDMPReviewOptions(ctrl).ActivateItem(Sender);
  end;
  setMemo(mm.Enabled);
end;

procedure TfrPDMPReviewItem.setMemo(anActive: Boolean);
begin
  mm.Enabled := anActive;
  mm.Visible := anActive;
  mm.ShowHint := true;

  if (not PDMP_PASTE_ENABLED) then
    mm.PopupMenu := popBlank;
  mm.OnKeyDown := self.mmKeyDown;

  height := getHeight;

  if mm.Enabled then
    mm.Color := clWindow
  else
    mm.Color := clBtnFace;
end;

procedure TfrPDMPReviewItem.setItemAlignment(anAlign: String);
var
  _Align: TAlignment;

begin
  _Align := AlignByName(trim(anAlign));

  if Assigned(Item) then
  begin
    if ItemType = ftLBL then
      TLabel(Item).Alignment := _Align
    else if (ItemType = ftRB) or (ItemType = ftCB) then
    begin
      lblInfo.Alignment := _Align;
    end;
  end;
end;

procedure TfrPDMPReviewItem.setDefaultStatus(aValue: Boolean);
begin
  if Assigned(Item) then
  begin
    if ItemType = ftCB then
      TCheckBox(Item).Checked := aValue
    else if (ItemType = ftRB) and aValue then
      TRadioButton(Item).Checked := aValue;
  end;
  mm.OnKeyDown := mmKeyDown;
  mm.MaxLength := PDMP_COMMENT_LIMIT;
end;

procedure TfrPDMPReviewItem.setItemType(aItemType: string);
begin
  fItemType := uppercase(aItemType);
  if fItemType = ftCB then
  begin
    Item := TCheckBox.Create(self);
    TCheckBox(Item).WordWrap := true;
    TCheckBox(Item).OnClick := rbItemClick;
  end
  else if fItemType = ftRB then
  begin
    Item := TRadioButton.Create(self);
    TRadioButton(Item).WordWrap := true;
    TRadioButton(Item).OnClick := rbItemClick;
    Delim := CRLF;
  end
  else if fItemType = ftLBL then
  begin
    Item := TLabel.Create(self);
    TLabel(Item).WordWrap := true;
    TLabel(Item).ParentFont := true;
    TLabel(Item).Alignment := taCenter;
    RequiresComment := False;
  end;

  if Assigned(Item) then
  begin
    Item.Parent := pnlItem;
    Item.Visible := true;
    Item.Align := alTop;
    Item.AlignWithMargins := true;
    Item.Margins.Top := 0;
    setMemo(False);
  end;

  // else
  // begin
  // mm.BorderStyle := bsNone;
  // mm.Color := clCream;
  // setMemo(True);
  // RequiresComment := True;
  // end;
end;

procedure TfrPDMPReviewItem.setMandatoryComment(aValue: Boolean);
begin
  fMandatoryComment := aValue;
  lblRequired.Visible := aValue;
  lblRequired.Hint := getCommentHint(aValue);
  mm.Hint := getCommentHint(aValue);
end;

procedure TfrPDMPReviewItem.setItemInfo(aItemInfo: string);
begin
  fItemInfo := aItemInfo;
  if fItemType = ftCB then
    TCheckBox(Item).Caption := aItemInfo
  else if fItemType = ftRB then
    TRadioButton(Item).Caption := aItemInfo
  else if fItemType = ftLBL then
    TLabel(Item).Caption := aItemInfo
  else
    mm.Text := aItemInfo;
end;

procedure TfrPDMPReviewItem.setItemWarning(aItemWarning: string);
begin
  fItemWarning := aItemWarning;

  if fItemType = ftCB then
    lblInfo.Visible := False
  else if fItemType = ftRB then
  begin
    lblInfo.Visible := aItemWarning <> '';
    lblInfo.Caption := aItemWarning;
  end
  else if fItemType = ftLBL then
    lblInfo.Visible := False
  else
    lblInfo.Visible := False;
end;

procedure TfrPDMPReviewItem.setItemComment(aComment: String);
var
  s1, s2: String;
begin
  fItemComment := aComment;
  if fItemType = ftLBL then
  begin
    s1 := piece(aComment, ';', 1);
    s2 := piece(aComment, ';', 2);
    if s2 = '' then
      TLabel(Item).Font.Style := TLabel(Item).Font.Style - [fsBold]
    else
      TLabel(Item).Font.Style := TLabel(Item).Font.Style + [fsBold];

    if uppercase(s1) = 'RED' then
      TLabel(Item).Font.Color := clRed
    else
      TLabel(Item).Font.Color := clWindowText;

    TLabel(Item).Font.Size := Application.MainForm.Font.Size;
  end;
end;

procedure TfrPDMPReviewItem.setRequiesComment(aComment: Boolean);
begin
  fRequiresComment := aComment;
  if RequiresComment then
    self.Tag := 1;

  mm.Visible := fRequiresComment;
end;

function TfrPDMPReviewItem.isValidInput(var sMsg: String): Boolean;
var
  s: String;
begin
  if (ItemType = ftRB) and TRadioButton(Item).Checked then
  begin
    sMsg := '';
    s := trim(mm.Text);
    if MandatoryComment then
    begin
      if s = '' then
        sMsg := 'No comments provided '
      else if Length(s) < PDMP_COMMENT_MIN then
        sMsg := 'Comment text is less than ' + IntToStr(PDMP_COMMENT_MIN)
          + ' chars'
      else if (PDMP_COMMENT_LIMIT < Length(mm.Text)) then
        sMsg := 'Comment text has exceeded ' + IntToStr(PDMP_COMMENT_LIMIT)
          + ' chars';
    end
    else
    begin
      if (PDMP_COMMENT_LIMIT < Length(mm.Text)) then
        sMsg := 'Comment text has exceeded ' + IntToStr(PDMP_COMMENT_LIMIT)
          + ' chars';
    end;
  end;
  Result := sMsg = '';
end;

function TfrPDMPReviewItem.getHeight(aWidth: Integer = 0): Integer;
var
  i, yy, iLine: Integer;
begin
  if aWidth = 0 then
    i := pnlItem.Width
  else
    i := aWidth;

  yy := getTextHeight(ItemInfo, i);
  if Assigned(Item) and Item.AlignWithMargins then
    yy := yy + Item.Margins.Top + Item.Margins.Bottom;

  if Assigned(Item) then
    Item.height := yy;

  if RequiresComment and (Item is TRadioButton) and TRadioButton(Item).Checked
  then
  begin
    iLine := Application.MainForm.Canvas.TextHeight('|');
    yy := yy + CommentLines * (3 + iLine);
    if ItemWarning <> '' then
    begin
      iLine := getTextHeight(lblInfo.Caption, pnlCanvas.Width);
      lblInfo.height := iLine;
      yy := yy + iLine + 4;
    end;
  end;

  self.height := yy;
  Result := yy;
end;

procedure TfrPDMPReviewItem.setCommentLimit(aLimit: Integer);
begin
  fCommentLimit := aLimit;
  if Length(mm.Text) > aLimit then
  begin
    beep;
    mm.Text := copy(mm.Text, 1, aLimit);
  end;
end;

function TfrPDMPReviewItem.getItemValue: String;
var
  b: Boolean;
begin
  Result := '';
  b := False;
  if fItemType = ftCB then
    b := TCheckBox(Item).Checked;
  if fItemType = ftRB then
    b := TRadioButton(Item).Checked;
  if b then
  begin
    Result := ItemPrefix;

    if fItemType = ftCB then
      Result := Result + TCheckBox(Item).Caption
    else if fItemType = ftRB then
      Result := Result + TRadioButton(Item).Caption;

    if RequiresComment then
      if trim(mm.Text) <> '' then
        Result := Result + Delim +
          CRLF + // blank line to separate user text from the option text
          mm.Text;

    Result := Result + ItemSuffix;
  end;
end;

procedure TfrPDMPReviewItem.setFontSize(aSize: Integer);
begin
  Font.Size := aSize;
  if Assigned(Item) then
  begin
    if ItemType = ftLBL then
      TLabel(Item).Font.Size := aSize
    else if ItemType = ftRB then
      TRadioButton(Item).Font.Size := aSize
    else if ItemType = ftCB then
      TCheckBox(Item).Font.Size := aSize;
  end;
  lblInfo.Font.Size := aSize;
end;

end.
