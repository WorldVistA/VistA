unit fOMVerify;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, VA508AccessibilityManager;

type
  TfrmOMVerify = class(TfrmAutoSz)
    cmdAccept: TButton;
    cmdEdit: TButton;
    cmdCancel: TButton;
    memText: TRichEdit;
    procedure cmdAcceptClick(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure memTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FLevel: Integer;
  end;

procedure ShowVerifyText(var QuickLevel: Integer; var VerifyText: string; InptDispGrp: boolean = False);

implementation

{$R *.DFM}

uses ORFn, uConst, fFrame, rMisc, uODBase;

procedure ShowVerifyText(var QuickLevel: Integer; var VerifyText: string; InptDispGrp: boolean);
var
  frmOMVerify: TfrmOMVerify;
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
  try
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

    with frmOMVerify do
    begin
      SetBounds(frmFrame.Left, frmFrame.Top + frmFrame.Height - Height, Width, Height);
      SetFormPosition(frmOMVerify);
      ExpandOrderObjects(VerifyText, HasObjects);
      memText.Lines.SetText(PChar(VerifyText));
      ShowModal;
      QuickLevel := FLevel;
    end;
  finally
    frmOMVerify.Release;
  end;
end;


procedure TfrmOMVerify.FormCreate(Sender: TObject);
begin
  inherited;
  FLevel := QL_CANCEL;
end;

procedure TfrmOMVerify.cmdAcceptClick(Sender: TObject);
begin
  inherited;
  FLevel := QL_AUTO;
  Close;
end;

procedure TfrmOMVerify.cmdEditClick(Sender: TObject);
begin
  inherited;
  FLevel := QL_DIALOG;
  Close;
end;

procedure TfrmOMVerify.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FLevel := QL_CANCEL;
  Close;
end;

procedure TfrmOMVerify.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
end;

procedure TfrmOMVerify.memTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then
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
  end;
end;

end.
