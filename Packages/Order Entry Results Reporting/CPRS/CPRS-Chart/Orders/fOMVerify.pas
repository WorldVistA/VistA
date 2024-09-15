unit fOMVerify;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, VA508AccessibilityManager, VA508AccessibilityRouter,
  Vcl.ExtCtrls;

type
  TfrmOMVerify = class(TfrmAutoSz)
    cmdAccept: TButton;
    cmdEdit: TButton;
    cmdCancel: TButton;
    memText: ORExtensions.TRichEdit;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    pnlButtons: TPanel;
    Panel1: TPanel;
    procedure cmdAcceptClick(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure memTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure VA508ComponentAccessibility1StateQuery(Sender: TObject;
      var Text: string);
    procedure FormShow(Sender: TObject);
    procedure memTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FLevel: Integer;
  end;

procedure ShowVerifyText(var QuickLevel: Integer; var VerifyText: string; InptDispGrp: boolean = False);

var
 frmOMVerify: TfrmOMVerify;
implementation

{$R *.DFM}

uses ORFn, uConst, fFrame, rMisc, uODBase, VAUtils;

procedure ShowVerifyText(var QuickLevel: Integer; var VerifyText: string; InptDispGrp: boolean);
var
  //frmOMVerify: TfrmOMVerify;
  tempStrs,prompts: TStringList;
  flag: boolean;
  HasObjects: boolean;

  function CutoffOutptPrompts(const promptIDs: TStringList; var promptList: TStringList): boolean;
  var
    i,j: integer;
  begin
    result := False;
    for i := 0 to promptList.Count - 1 do
    begin
      if result = True then
        break;
      for j := 0 to promptIDs.Count - 1 do
      begin
        if Pos(promptIDs[j],LowerCase(promptList[i]))>0 then
        begin
          promptList.Delete(i);
          result := True;
          break;
        end;
      end;
    end;
  end;

begin
  prompts := TStringList.Create;
  prompts.Add('supply');
  prompts.Add('quantity');
  prompts.Add('refill');
  prompts.Add('pick up');
  prompts.Add('priority');
  frmOMVerify := TfrmOMVerify.Create(Application);
    ResizeFormToFont(TForm(frmOMVerify));
    if InptDispGrp then
    begin
      tempStrs := TStringList.Create;
      TStrings(tempStrs).SetText(PChar(VerifyText));
      repeat
        flag := CutoffOutptPrompts(prompts, tempStrs);
      until not flag;
      SetString(VerifyText, tempStrs.GetText, StrLen(tempStrs.GetText))
    end;
      SetFormPosition(frmOMVerify);
      ExpandOrderObjects(VerifyText, HasObjects);
      frmOMVerify.memText.Lines.SetText(PChar(VerifyText));
      frmOMVerify.ShowModal;
      if frmOMVerify.ModalResult = mrOK then
        begin
          QuickLevel := frmOMVerify.FLevel;
        end;
      //agp on CPRS timeout ModalResult equal mrCancel this prevent starting a new order
      //when the chart is timing out.
      if frmOMVerify.ModalResult = mrCancel then QuickLevel := QL_CANCEL;      
     frmOMVerify.Free;
end;


procedure TfrmOMVerify.FormCreate(Sender: TObject);
begin
  inherited;
  frmOMVerify := nil;
  FLevel := QL_CANCEL;
  ModalResult := mrNone;
end;


procedure TfrmOMVerify.FormDestroy(Sender: TObject);
begin
  inherited;
  frmOMVerify := nil;
end;

procedure TfrmOMVerify.FormShow(Sender: TObject);
begin
  inherited;
  if ScreenReaderSystemActive then
  begin
    memText.TabStop := true;
    memText.SetFocus;
  end;
end;

procedure TfrmOMVerify.cmdAcceptClick(Sender: TObject);
begin
  inherited;
  FLevel := QL_AUTO;
  ModalResult := mrOK;
end;

procedure TfrmOMVerify.cmdEditClick(Sender: TObject);
begin
  inherited;
  FLevel := QL_DIALOG;
  ModalResult := mrOK;
end;

procedure TfrmOMVerify.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FLevel := QL_CANCEL;
  ModalResult := mrOK;
end;

procedure TfrmOMVerify.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
end;

procedure TfrmOMVerify.memTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if ShiftTabIsPressed() then
  begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    Key := 0;
  end;
  if TabIsPressed() then
  begin
    FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    Key := 0;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmOMVerify.memTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  {if (Key = VK_TAB) then
  begin
    if ssShift in Shift then
    begin
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
      Key := 0;
    end
    else if ssCtrl	in Shift then
    begin
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
      Key := 0;
    end;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end; }
end;

procedure TfrmOMVerify.VA508ComponentAccessibility1StateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  Text := memText.Text;
end;

end.
