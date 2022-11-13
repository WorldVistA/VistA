unit fConsultAlertTo;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ORCtrls, ORfn, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmConsultAlertsTo = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboSrcList: TORComboBox;
    DstList: TORListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    pnlBase: TORAutoPanel;
    btnAdd: TButton;
    btnRemove: TButton;
    pnlButtons: TPanel;
    procedure cboSrcListNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    //procedure cboSrcListdblClick(Sender: TObject);
    procedure cboSrcListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DstListClick(Sender: TObject);
    procedure cboSrcListMouseClick(Sender: TObject);
  private
    FActionType: integer;
    FRecipients: string ;
    FChanged: Boolean;
  end;

TRecipientList = record
    Changed: Boolean;
    Recipients: string ;
  end;

procedure SelectRecipients(FontSize: Integer; ActionType: integer; var RecipientList: TRecipientList) ;

implementation

{$R *.DFM}

uses rConsults, rCore, uCore, uConsults, fConsults, uORLists, uSimilarNames;

const
  TX_RCPT_TEXT = 'Select recipients or press Cancel.';
  TX_RCPT_CAP = 'No Recipients Selected';
  TX_REQ_TEXT = 'The requesting provider is always included in this type of alert';
  TX_REQ_CAP = 'Cannot Remove Recipient';

procedure SelectRecipients(FontSize: Integer; ActionType: integer; var RecipientList: TRecipientList) ;
{ displays recipients select form for consults and returns a record of the selection }
var
  frmConsultAlertsTo: TfrmConsultAlertsTo;
begin
  frmConsultAlertsTo := TfrmConsultAlertsTo.Create(Application);
  try
    ResizeAnchoredFormToFont(frmConsultAlertsTo);
    with frmConsultAlertsTo do
    begin
      FActionType := ActionType;
      FChanged := False;
      cboSrcList.InitLongList('');
(*      cboSrcList.InitLongList(ConsultRec.SendingProviderName);
      cboSrcList.SelectByIEN(ConsultRec.SendingProvider);
      cboSrcListMouseClick(cboSrcList) ;*)
      ShowModal;
      with RecipientList do
        begin
          Recipients := Recipients + FRecipients ;
          Changed := FChanged ;
        end ;
    end; {with frmConsultAlertsTo}
  finally
    frmConsultAlertsTo.Release;
  end;
end;

procedure TfrmConsultAlertsTo.cboSrcListNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  setPersonList(cboSrcList, StartFrom, Direction);
end;

procedure TfrmConsultAlertsTo.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultAlertsTo.cmdOKClick(Sender: TObject);
var
  i: integer ;
begin
  if DstList.Items.Count = 0 then
  begin
    InfoBox(TX_RCPT_TEXT, TX_RCPT_CAP, MB_OK or MB_ICONWARNING);
    FChanged := False ;
    Exit;
  end;
  FChanged := True;
  for i := 0 to DstList.Items.Count-1 do
      FRecipients := Piece(DstList.Items[i],u,1) + ';' + FRecipients;
  Close;
end;

(*procedure TfrmConsultAlertsTo.cboSrcListdblClick(Sender: TObject);
begin
     if cboSrcList.ItemIndex = -1 then exit ;
     if DstList.SelectByID(cboSrcList.ItemID) = -1 then
       DstList.Items.Add(cboSrcList.Items[cboSrcList.Itemindex]) ;
end;*)

procedure TfrmConsultAlertsTo.DstListClick(Sender: TObject);
begin
     if DstList.ItemIndex = -1 then exit ;
(*     if (DstList.ItemIEN = ConsultRec.SendingProvider) and
        ((FActionType = CN_ACT_SIGFIND) or (FActionType = CN_ACT_ADMIN_COMPLETE)) then
       begin
         InfoBox(TX_REQ_TEXT, TX_REQ_CAP, MB_OK or MB_ICONWARNING);
         exit ;
       end ;*)
     DstList.Items.Delete(DstList.ItemIndex) ;
end;

procedure TfrmConsultAlertsTo.cboSrcListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then cboSrcListMouseClick(Self);
end;

procedure TfrmConsultAlertsTo.cboSrcListMouseClick(Sender: TObject);
var
 ErrMsg: String;
begin
  if not CheckForSimilarName(cboSrcList, ErrMsg, sPr, DstList.Items) then
  begin
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'Provider Selection');
    exit;
  end;
  if cboSrcList.ItemIndex = -1 then exit ;
  if DstList.SelectByID(cboSrcList.ItemID) = -1 then
    DstList.Items.Add(cboSrcList.Items[cboSrcList.Itemindex]) ;
end;

end.
