unit fOMAction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, rOrders, VA508AccessibilityManager;


type
  TCallOnExit = procedure;

  TfrmOMAction = class(TfrmAutoSz)
    procedure FormDestroy(Sender: TObject);
  private
    FCallOnExit:   TCallOnExit;
    FOrderDialog:  Integer;
    FRefNum:       Integer;
    FAbortAction:  boolean;
  protected
    procedure InitDialog; virtual;
  public
    property CallOnExit:  TCallOnExit read FCallOnExit   write FCallOnExit;
    property OrderDialog: Integer     read FOrderDialog  write FOrderDialog;
    property RefNum:      Integer     read FRefNum       write FRefNum;
    property AbortAction: boolean     read FAbortAction  write FAbortAction;
  end;


var
  frmOMAction: TfrmOMAction;

implementation

{$R *.DFM}

uses
  uConst;

procedure TfrmOMAction.FormDestroy(Sender: TObject);
begin
  if Assigned(FCallOnExit) then FCallOnExit;
  if (Owner <> nil) and (Owner is TWinControl)
    then SendMessage(TWinControl(Owner).Handle, UM_DESTROY, FRefNum, 0);
  inherited;
end;

procedure TfrmOMAction.InitDialog;
begin
  FAbortAction := False;
end;

end.
