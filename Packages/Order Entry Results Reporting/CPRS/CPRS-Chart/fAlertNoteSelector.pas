unit fAlertNoteSelector;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ORCtrls,
  ORDtTm,
  ORNet,
  ORFn,
  ComCtrls,
  UITypes,
  fBase508Form,
  VA508AccessibilityManager;

type
  TfrmAlertNoteSelector = class(TfrmBase508Form)
    rbtnNewNote: TRadioButton;
    rbtnSelectAddendum: TRadioButton;
    rbtnSelectOwn: TRadioButton;
    btnOK: TButton;
    lbATRNotes_ORIG: TORListBox;
    lbATRs: TORListBox;
    lbATRNotes: TListBox;
    buCancel: TButton;
    StaticText1: TStaticText;
    procedure rbtnNewNoteClick(Sender: TObject);
    procedure rbtnSelectAddendumClick(Sender: TObject);
    procedure rbtnSelectOwnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbATRNotesClick(Sender: TObject);
    procedure buCancelClick(Sender: TObject);
  private
    FXQAID: string;
    FTIUNoteIEN: string;
  public
    property XQAID: string read FXQAID write FXQAID;
    property TIUNoteIEN: string read FTIUNoteIEN write FTIUNoteIEN;
    function GetTIUNotesByDate(thisPatientDFN: string;
      thisStartDate: TFMDateTime; { Start Date }
      thisDocType: integer = 3;
      thisContext: integer = 5;
      thisMaxResults: string = '0';
      thisSortDirection: integer = 1;
      thisIncludeAddenda: boolean = false;
      thisIncludeUntranscribed: boolean = false): TStringList;
    procedure DisplayTARAlertValues();
  end;

var
  frmAlertNoteSelector: TfrmAlertNoteSelector;

implementation

{ - Needs to be upgraded / DRP
uses
  fTARProcess,
  fTARNotification,
  UTARConst;
}
{$R *.dfm}

procedure TfrmAlertNoteSelector.rbtnNewNoteClick(Sender: TObject);
begin
  try
    if rbtnNewNote.Checked then
      begin
        rbtnSelectAddendum.Checked := false;
        rbtnSelectOwn.Checked := false;
      end;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in procedure TfrmATRNoteSelect.rbtnNewNoteClick()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfrmAlertNoteSelector.rbtnSelectAddendumClick(Sender: TObject);
begin
  try
    if rbtnSelectAddendum.Checked then
      begin
        rbtnNewNote.Checked := false;
        rbtnSelectOwn.Checked := false;
      end;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in procedure TfrmATRNoteSelect.rbtnSelectAddendumClick()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfrmAlertNoteSelector.rbtnSelectOwnClick(Sender: TObject);
begin
  try
    if rbtnSelectOwn.Checked then
      begin
        rbtnSelectAddendum.Checked := false;
        rbtnNewNote.Checked := false;
      end;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in procedure TfrmATRNoteSelect.rbtnSelectOwnClick()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfrmAlertNoteSelector.buCancelClick(Sender: TObject);
{
  User wants to cancel out of this process.
  So, we have to "roll back" the processing level of the selected TAR.
}
var
  thisTARien: string;
begin
  try
    thisTARien := Piece(self.XQAID, ';', 7);

    // If user has gotten this far in the TAR processing, they they have
    // already taken 'some' action. So, be proactive and "reset" it to
    // '1 = Some Action Taken' even though it already is 1.

    { TODO -oDan P -cSMART : Upgrade to redesinged SMART Notes
    CallV('ORATR SET ATR PROCESSING LEVEL', [thisTARien, TAR_SOME_ACTION_TAKEN]);
    }

    // We don't want to do this here, because user may have already processed
    // a Reminder for this TAR. We just want to Cancel.
    // CallV('ORATR SET TIU NOTE', [thisTARien, '@']);
  except
    on E: Exception do
      MessageDlg('An exception has occurred in procedure TfrmATRNoteSelect.buCancelClick()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfrmAlertNoteSelector.DisplayTARAlertValues();
var
//  i: integer;
  slParamArray: TStringList;
  thisIEN: string;
begin
  try
    lbATRs.Clear;
    rbtnSelectAddendum.Checked := true;

    slParamArray := TStringList.Create;

    thisIEN := Piece(self.XQAID, ';', 7);
    slParamArray.Add('ATR^' + thisIEN);

    { TODO -oDan P -cSMART : Upgrade to redesinged SMART Notes
    CallV('ORATR GET TEST RESULTS', [slParamArray]);
    for i := 0 to frmTARNotification.RPCBroker.Results.Count - 1 do
      lbATRs.Items.Add(frmTARNotification.RPCBroker.Results[i]);
    }

    if slParamArray <> nil then
      FreeAndNil(slParamArray);
  except
    on E: Exception do
      MessageDlg('An exception has occurred in procedure frmATRNoteSelect.DisplayTARAlertValues()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfrmAlertNoteSelector.FormShow(Sender: TObject);
var
  j: integer;
  thisOrderDate: double;
  thisTIUDate: double;
  slTIUNotes: TStringList;
  thisATRTIUNoteIEN: string;
begin
  try
    lbATRs.Clear;
    DisplayTARAlertValues();

    // Add ONLY the TIU Notes from the date that the ORIGINAL ORDER (ie, the order that generated the ATR Alert) was signed.
    { TODO -oDan P -cSMART : Upgrade to redesinged SMART Notes
    frmATRNoteSelect.rbtnNewNote.Checked := true; // default
    slTIUNotes := TStringList.Create;
    thisOrderDate := strToInt64(Piece(Piece(self.XQAID, ';', 6), '.', 1));
    slTIUNotes := GetTIUNotesByDate(frmTARNotification.PatientDFN, thisOrderDate);
    //FastAssign(frmTARNotification.RPCBroker.Results, slTIUNotes);  // DRP - Unfavorable Results In XE
    slTIUNotes.Text := frmTARNotification.RPCBroker.Results.Text;
    }

    thisATRTIUNoteIEN := Piece(self.XQAID, ';', 7);
    if thisATRTIUNoteIEN <> '' then
      begin
        rbtnNewNote.Enabled := true;
        rbtnNewNote.Checked := true;
      end
    else
      begin
        rbtnNewNote.Enabled := false;
        rbtnNewNote.Checked := false;
      end;

    if slTIUNotes.Count = 0 then
      rbtnSelectAddendum.Enabled := false
    else
      rbtnSelectAddendum.Enabled := true;

    for j := 0 to slTIUNotes.Count - 1 do
      begin
        thisTIUDate := strToInt64(Piece(Piece(slTIUNotes[j], '^', 3), '.', 1));
        if thisOrderDate = thisTIUDate then
          lbATRNotes.Items.Add(Piece(slTIUNotes[j], '^', 2) + ' - ' + Piece(slTIUNotes[j], '^', 6) + '  ' + Piece(Piece(slTIUNotes[j], '^', 8), ';', 1));
      end;

    if slTIUNotes <> nil then
      FreeAndNil(slTIUNotes);
  except
    on E: Exception do
      MessageDlg('An exception has occurred in procedure frmATRNoteSelect.FormShow()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

function TfrmAlertNoteSelector.GetTIUNotesByDate(thisPatientDFN: string;
  thisStartDate: TFMDateTime; // Start Date
  thisDocType: integer = 3; // Progress Notes
  thisContext: integer = 5; // 5 = signed documents/date range
  thisMaxResults: string = '0';
  thisSortDirection: integer = 1;
  thisIncludeAddenda: boolean = false;
  thisIncludeUntranscribed: boolean = false): TStringList;
//var
//  i: integer;
//  slTIUDocumentsByContext: TStringList;
begin
  try
    { TODO -oDan P -cSMART : Upgrade to redesinged SMART Notes
    CallV('TIU DOCUMENTS BY CONTEXT', [thisDocType, // Document type, 3 = Progress Notes
      thisContext, // Document Context: signed documents by date range
      thisPatientDFN, // patient
      thisStartDate, // Start Date
      thisStartDate, // End Date same as Start Date
      frmTARNotification.UserDUZ, // User ID
      0, // Max results
      1, // 0=Ascending, 1=Descending
      0, // param SHOWADD
      1]); // param INCUND


    slTIUDocumentsByContext := TStringList.Create;
    for i := 0 to frmTARNotification.RPCBroker.Results.Count - 1 do
      begin
        if i = 0 then
          begin
            self.Caption := Piece(ORNet.RPCBrokerV.Results[i], '^', 4); // form caption = patient name + (last init,last4)
            slTIUDocumentsByContext.Add(frmTARNotification.RPCBroker.Results[i]);
          end
        else
          slTIUDocumentsByContext.Add(frmTARNotification.RPCBroker.Results[i]);
      end;

    if frmTARNotification.RPCBroker.Results.Count > 0 then
      self.TIUNoteIEN := Piece(frmTARNotification.RPCBroker.Results[0], '^', 1);

    result := slTIUDocumentsByContext;
    }
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfrmATRNoteSelect.GetTIUNotesByDate()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfrmAlertNoteSelector.lbATRNotesClick(Sender: TObject);
begin
  try
    rbtnSelectAddendum.Checked := true;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfrmATRNoteSelect.lbATRNotesClick()' + CRLF + E.Message, mtError, [mbOk], 0);
  end;
end;

end.
