unit fConsMedRslt;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ORCtrls, ORfn, ExtCtrls, fAutoSz, ORDtTm, fConsultAlertTo, fRptBox,
  VA508AccessibilityManager, Vcl.ComCtrls, Vcl.ImgList, System.ImageList;

type
  TMedResultRec = record
    Action: string;
    ResultPtr: string;
    DateTimeofAction: TFMDateTime;
    ResponsiblePerson: Int64;
    AlertsTo: TRecipientList;
  end;

  TfrmConsMedRslt = class(TfrmAutoSz)
    pnlBase: TORAutoPanel;
    pnlAction: TPanel;
    pnlbottom: TPanel;
    pnlMiddle: TPanel;
    pnlButtons: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    ckAlert: TCheckBox;
    cmdDetails: TButton;
    calDateofAction: TORDateBox;
    lblDateofAction: TOROffsetLabel;
    lblActionBy: TOROffsetLabel;
    cboPerson: TORComboBox;
    SrcLabel: TLabel;
    lstMedResults: TCaptionListView;
    ImageList1: TImageList;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdDetailsClick(Sender: TObject);
    procedure ckAlertClick(Sender: TObject);
    procedure NewPersonNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormDestroy(Sender: TObject);
 //   procedure lstMedResultsDrawItem(Control: TWinControl; Index: Integer;
 //     Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
  protected
    procedure ShowDetailsDestroyed(Sender: TObject);
  private
    FShowDetails: TfrmReportBox;
    FOldShowDetailsOnDestroy: TNotifyEvent;
    FMedResult: TMedResultRec ;
    FChanged: Boolean;
  end;

function SelectMedicineResult(ConsultIEN: integer; FormTitle: string; var MedResult: TMedResultRec): boolean ;

implementation

{$R *.DFM}

uses rConsults, rCore, uCore, uConst, uORLists, uSimilarNames;

const
  TX_MEDRSLT_TEXT = 'Select medicine result or press Cancel.';
  TX_MEDRSLT_CAP  = 'No Result Selected';

var
  RecipientList: TRecipientList ;

function SelectMedicineResult(ConsultIEN: integer; FormTitle: string; var MedResult: TMedResultRec): boolean ;
{ displays Medicine Result selection form and returns a record of the selection }
var
  frmConsMedRslt: TfrmConsMedRslt;
  TempList: TCaptionListStringList;

  procedure DisplayImage(LstView: TCaptionListView);
  var
   x: String;
   I: Integer;
  begin
    for I := 0 to LstView.Items.Count - 1 do
    begin
     x := LstView.Strings[i];

    if StrToIntDef(Piece(x, U, 5), 0) > 0 then
     LstView.Items[i].ImageIndex := 0
    else
     LstView.Items[i].ImageIndex := -1;
    end;
  end;

begin
  frmConsMedRslt := TfrmConsMedRslt.Create(Application);
  try
    with frmConsMedRslt do
    begin
      FChanged := False;
      FillChar(RecipientList, SizeOf(RecipientList), 0);
      FillChar(FMedResult, SizeOf(FMedResult), 0);
      Caption := FormTitle;
      cboPerson.InitLongList(User.Name);
      cboPerson.SelectByIEN(User.DUZ);
      ResizeFormToFont(TForm(frmConsMedRslt));

      TempList := TCaptionListStringList.Create;
      try
        if MedResult.Action = 'ATTACH' then
        begin
          // Must use TempList, NOT lstMedResults.ItemsStrings
          setAssignableMedResults(TempList, ConsultIEN);
          lstMedResults.ItemsStrings := TempList; // rebuilds list view items
          ckAlert.Visible := True;
          DisplayImage(lstMedResults);
        end
        else if MedResult.Action = 'REMOVE' then
        begin
          // Must use TempList, NOT lstMedResults.ItemsStrings
          setRemovableMedResults(TempList, ConsultIEN);
          lstMedResults.ItemsStrings := TempList; // rebuilds list view items
          ckAlert.Visible := False;
          DisplayImage(lstMedResults);
        end;
      finally
        TempList.Free;
      end;
      if lstMedResults.Items.Count > 0 then
        ShowModal
      else
        FChanged := True;
      Result := FChanged;
      MedResult := FMedResult;
    end; {with frmODConsMedRslt}
  finally
    frmConsMedRslt.Release;
  end;
end;

procedure TfrmConsMedRslt.cmdCancelClick(Sender: TObject);
begin
  FillChar(FMedResult, SizeOf(FMedResult), 0);
  FChanged := False;
  Close;
end;

procedure TfrmConsMedRslt.cmdOKClick(Sender: TObject);
var
 ErrMsg: String;
begin
  FillChar(FMedResult, SizeOf(FMedResult), 0);
  if lstMedResults.ItemIndex = -1 then
  begin
    InfoBox(TX_MEDRSLT_TEXT, TX_MEDRSLT_CAP, MB_OK or MB_ICONWARNING);
    FChanged := False ;
    Exit;
  end;
  if not CheckForSimilarName(cboPerson, ErrMsg, sPr) then
  begin
    ShowMsgOn(ErrMsg <> '', ErrMsg, 'Provider Selection');
    exit;
  end;
  FChanged := True;
  with FMedResult do
    begin
      ResultPtr := lstMedResults.ItemID ;
      DateTimeofAction := calDateOfAction.FMDateTime;
      ResponsiblePerson := cboPerson.ItemIEN;
      AlertsTo := RecipientList;
    end;
  Close;
end;

procedure TfrmConsMedRslt.cmdDetailsClick(Sender: TObject);
const
  TX_RESULTS_CAP = 'Detailed Results Display';
var
  x: string;
  // MsgString, HasImages: string;
  sl: TStrings;
begin
  inherited;
  if lstMedResults.ItemIndex = -1 then
    Exit;
  x := Piece(Piece(Piece(lstMedResults.ItemID, ';', 2), '(', 2), ',', 1) + ';' +
    Piece(lstMedResults.ItemID, ';', 1);
  // ---------------------------------------------------------------
  // Don't do this until MED API is changed for new/unassigned results, or false '0' will be broadcast
  (* MsgString := 'MED^' + x;
    HasImages := BOOLCHAR[StrToIntDef(Piece(x, U, 5), 0) > 0];
    SetPiece(HasImages, U, 10, HasImages);
    NotifyOtherApps(NAE_REPORT, MsgString); *)
  // ---------------------------------------------------------------
  NotifyOtherApps(NAE_REPORT, 'MED^' + x);
  if (not assigned(FShowDetails)) then
  begin
    // FShowDetails := ModelessReportBox(GetDetailedMedicineResults(lstMedResults.ItemID), TX_RESULTS_CAP, True);
    sl := TSTringList.Create;
    try
      setDetailedMedicineResults(sl, lstMedResults.ItemID);
      FShowDetails := ModelessReportBox(sl, TX_RESULTS_CAP, True);
    finally
      sl.Free;
    end;
    FOldShowDetailsOnDestroy := FShowDetails.OnDestroy;
    FShowDetails.OnDestroy := ShowDetailsDestroyed;
    cmdDetails.Enabled := (not assigned(FShowDetails));
    lstMedResults.Enabled := (not assigned(FShowDetails));
  end;
end;

procedure TfrmConsMedRslt.ShowDetailsDestroyed(Sender: TObject);
begin
  if(assigned(FOldShowDetailsOnDestroy)) then
    FOldShowDetailsOnDestroy(Sender);
  FShowDetails := nil;
  cmdDetails.Enabled := (not assigned(FShowDetails));
  lstMedResults.Enabled := (not assigned(FShowDetails));
end;


procedure TfrmConsMedRslt.ckAlertClick(Sender: TObject);
begin
  FillChar(RecipientList, SizeOf(RecipientList), 0);
  if ckAlert.Checked then SelectRecipients(Font.Size, 0, RecipientList) ;
end;

procedure TfrmConsMedRslt.NewPersonNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList((Sender as TORComboBox), StartFrom, Direction);
end;

procedure TfrmConsMedRslt.FormCreate(Sender: TObject);
var
 AnImage: TBitMap;
begin
  inherited;
  AnImage := TBitMap.Create;
  try
   AnImage.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_1');
   ImageList1.Add(AnImage,nil);
  finally
    AnImage.Free;
  end;
end;

procedure TfrmConsMedRslt.FormDestroy(Sender: TObject);
begin
  inherited;
  KillObj(@FShowDetails);
end;

{procedure TfrmConsMedRslt.lstMedResultsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  AnImage: TBitMap;
const
  STD_PROC_TEXT = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  STD_DATE = 'MMM DD,YY@HH:NNXX';
begin
  inherited;
  AnImage := TBitMap.Create;
  try
    with (Control as TORListBox).Canvas do  { draw on control canvas, not on the form }
  {    begin
        x := (Control as TORListBox).Items[Index];
        FillRect(Rect);       { clear the rectangle }
  {      AnImage.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_1');
        (Control as TORListBox).ItemHeight := HigherOf(TextHeight(x), AnImage.Height);
        if StrToIntDef(Piece(x, U, 5), 0) > 0 then
          begin
            BrushCopy(Bounds(Rect.Left, Rect.Top, AnImage.Width, AnImage.Height),
              AnImage, Bounds(0, 0, AnImage.Width, AnImage.Height), clRed); {render ImageFlag}
 {         end;
        TextOut(Rect.Left + AnImage.Width, Rect.Top, Piece(x, U, 2));
        TextOut(Rect.Left + AnImage.Width + TextWidth(STD_PROC_TEXT), Rect.Top, Piece(x, U, 3));
        TextOut(Rect.Left + AnImage.Width + TextWidth(STD_PROC_TEXT) + TextWidth(STD_DATE), Rect.Top, Piece(x, U, 4));
      end;
  finally
    AnImage.Free;
  end;
end; }

end.
