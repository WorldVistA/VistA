unit fxLists;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmDbgList = class(TfrmBase508Form)
    memData: TMemo;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure DebugListItems(AListBox: TListBox);

implementation

{$R *.DFM}

uses
  ORFn, ORCtrls;

procedure DebugListItems(AListBox: TListBox);
var
  frmDbgList: TfrmDbgList;
begin
  frmDbgList := TfrmDbgList.Create(Application);
  try
    ResizeAnchoredFormToFont(frmDbgList);
    with frmDbgList do
    begin
      if AListBox is TORListBox then
        FastAssign(TORListBox(AListBox).Items, memData.Lines)
      else
        memData.Lines.Assign(AListBox.Items);
      ShowModal;
    end;
  finally
    frmDbgList.Release;
  end;
end;

procedure TfrmDbgList.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
