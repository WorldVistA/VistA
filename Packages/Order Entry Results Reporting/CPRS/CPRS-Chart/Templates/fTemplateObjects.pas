unit fTemplateObjects;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, ExtCtrls, ComCtrls, ORFn, dShared, uTemplates, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmTemplateObjects = class(TfrmBase508Form)
    cboObjects: TORComboBox;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnInsert: TButton;
    btnRefresh: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure cboObjectsDblClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Fre: ORExtensions.TRichEdit;
    FAutoLongLines: TNotifyEvent;
    procedure InsertObject;
    procedure Setre(const Value: ORExtensions.TRichEdit);
  public
    procedure UpdateStatus;
    property re: ORExtensions.TRichEdit read Fre write Setre;
    property AutoLongLines: TNotifyEvent read FAutoLongLines write FAutoLongLines;
  end;

implementation

{$R *.DFM}

uses
  VAUtils;

procedure TfrmTemplateObjects.FormShow(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  //ResizeAnchoredFormToFont doesn't work right on the button positions for some reason.
  btnCancel.Left := pnlBottom.ClientWidth - btnCancel.Width;
  btnInsert.Left := btnCancel.Left - btnInsert.Width - 5;
  btnRefresh.Left := btnInsert.Left - btnRefresh.Width - 5;
  cboObjects.SelectAll;
  cboObjects.SetFocus;
end;

procedure TfrmTemplateObjects.btnInsertClick(Sender: TObject);
begin
  InsertObject;
end;

procedure TfrmTemplateObjects.InsertObject;
var
  cnt: integer;

begin
  if(not Fre.ReadOnly) and (cboObjects.ItemIndex >= 0) then
  begin
    cnt := Fre.Lines.Count;
    Fre.SelText := '|'+Piece(cboObjects.Items[cboObjects.ItemIndex],U,3)+'|';
    if(assigned(FAutoLongLines) and (cnt <> FRe.Lines.Count)) then
      FAutoLongLines(Self);
  end;
end;

procedure TfrmTemplateObjects.cboObjectsDblClick(Sender: TObject);
begin
  InsertObject;
end;

procedure TfrmTemplateObjects.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTemplateObjects.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmTemplateObjects.Setre(const Value: ORExtensions.TRichEdit);
begin
  Fre := Value;
  UpdateStatus;
end;

procedure TfrmTemplateObjects.UpdateStatus;
begin
  btnInsert.Enabled := (not re.ReadOnly);
end;

procedure TfrmTemplateObjects.btnRefreshClick(Sender: TObject);
var
  i: integer;
  DoIt: boolean;
begin
  cboObjects.Clear;
  dmodShared.RefreshObject := true;
  dmodShared.LoadTIUObjects;
  //---------- CQ #8665 - RV ----------------
  DoIt := TRUE;
  UpdatePersonalObjects;
  if uPersonalObjects.Count > 0 then
  begin
    DoIt := FALSE;
    for i := 0 to dmodShared.TIUObjects.Count-1 do
      if uPersonalObjects.IndexOf(Piece(dmodShared.TIUObjects[i],U,2)) >= 0 then
        cboObjects.Items.Add(dmodShared.TIUObjects[i]);
  end;
  if DoIt then
  //---------- end CQ #8665 ------------------
    cboObjects.Items.Assign(dmodShared.TIUObjects);
end;

end.

