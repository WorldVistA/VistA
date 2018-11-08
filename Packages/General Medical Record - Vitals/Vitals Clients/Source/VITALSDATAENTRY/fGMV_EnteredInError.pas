unit fGMV_EnteredInError;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 8/11/09 3:56p $
*       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Utility for marking vitals in error.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY/fGMV_EnteredInError.pas $
*
* $History: fGMV_EnteredInError.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/VitalsDataEntry
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:08p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsUser
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 5/22/03    Time: 10:16a
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Preparation to CCOW
 * MessageDLG changed to MessageDLGS
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 5/21/03    Time: 1:46p
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Version 5.0.1.5
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 12/20/02   Time: 3:02p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzandria Date: 10/11/02   Time: 6:21p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Version vT32_1
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzpetitd Date: 6/20/02    Time: 9:33a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * t27 Build
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:14a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Roll-up to 5.0.0.27
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 11:58a
 * Created in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Buttons,
  CheckLst,
  MFunStr,
  uGMV_Common,
  ComCtrls;

type
  TfrmGMV_EnteredInError = class(TForm)
    GroupBox1: TGroupBox;
    rgReason: TRadioGroup;
    dtpDate: TDateTimePicker;
    pnlButtons: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    lvVitals: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure DateChange(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkToProceed(Sender: TObject);
    procedure ClearList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvVitalsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvVitalsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FPatientIEN: string;
    { Private declarations }
  public
    { Public declarations }
  end;

function EnterVitalsInError(DFN: string): Integer;
function EnteredInErrorByDate(DFN: string;aDate:TDateTime): Integer;

implementation

uses uGMV_FileEntry, uGMV_User, uGMV_Engine, fGMV_PtInfo, system.UITypes
;

const
  kwVitals = 'Vitals';
  kwCliO = 'CliO';
  
{$R *.DFM}

function EnterVitalsInError(DFN: string): Integer;
var
  TimeToStart: TDateTime;
begin
  TimeToStart := getServerWDateTime;
  TimeToStart := Trunc(TimeToStart)+1 - 1/(3600*24);
  Result := EnteredInErrorByDate(DFN,TimeToStart);
end;

function EnteredInErrorByDate(DFN: string;aDate:TDateTime): Integer;
begin
  with TfrmGMV_EnteredInError.Create(Application) do
    try
      FPatientIEN := DFN;
      dtpDate.Date := aDate;
      if dtpDate.Date = 0 then
          dtpDate.Date := Now;
      DateChange(nil);
      Result := ShowModal;
    finally
      free;
    end;
end;

procedure TfrmGMV_EnteredInError.FormCreate(Sender: TObject);
begin
  ClearList;
  dtpDate.Date := getServerWDateTime;
  if dtpDate.Date = 0 then
    begin
      dtpDate.Date := Now;
    end;
end;

procedure TfrmGMV_EnteredInError.DateChange(Sender: TObject);
var
  sSource,
  s: String;
  dt: Double;
  i: integer;
  RetList : TStrings;

  function DataSource(aValue:String):String;
  begin
    Result := kwVitals;
    if pos('{',trim(aValue)) = 1 then
      Result := kwClio;
  end;

begin
  ClearList;
  dt := WindowsDateToFMDate(dtpDate.Date);

  RetList := getGMVRecord(FPatientIEN + '^' + FloatToStr(dt) + '^^' + FloatToStr(dt));

  if (RetList.Count > 0) and (Piece(RetList[0], '^', 1) <> '0') then
    for i := 0 to RetList.Count - 1 do
      if Copy(RetList[i], 1, 1) <> ' ' then
        with lvVitals.Items.Add do
          begin
            s := RetList[i];
            Caption := Piece(Piece(RetList[i], '^', 2), ' ', 1);
            sSource := DataSource(s);

            s := trim(Copy(RetList[i], Pos(' ', RetList[i]), 255));
            SubItems.Add(piece(s,'_',1));
            SubItems.Add(piece(s,'_',2));
            SubItems.Add(sSource);
            Data := TGMV_FileEntry.CreateFromRPC('120.51;' + RetList[i]);
          end;
  RetList.Free;
  lvVitals.Invalidate;
end;

procedure TfrmGMV_EnteredInError.ClearList;
begin
  lvVitals.Items.BeginUpdate;
  while lvVitals.Items.Count > 0 do
    begin
      if lvVitals.Items[0].Data <> nil then
        TGMV_FileEntry(lvVitals.Items[0].Data).Free;
      lvVitals.Items.Delete(0);
    end;
  lvVitals.Items.EndUpdate;
  btnOK.Enabled := False;
  rgReason.Enabled := False;
  rgReason.ItemIndex := -1;
end;

procedure TfrmGMV_EnteredInError.OkButtonClick(Sender: TObject);
var
  i: integer;
  sReason,
  sVitals,sClio,
  sDUZ,
  s: String;
  RetList:TStrings;
  iVitals,iExternal:Integer;

  function WarningString(aClio:Integer):String;
  begin
    Result := 'Are you sure you want to mark ' +
      IntToStr(iVitals)+' vitals sign records as ' + sReason+'?';
    if aClio <> 0 then
      Result := Result +#13#13+
      'NOTE: some of the selected records are stored outside of the Vitals package'+#13+
      'and could not be marked as "Entered in Error" by the Vitals application';
  end;

begin
  if rgReason.ItemIndex < 0 then
    MessageDlg('No reason has been selected.', mtError, [mbok], 0)
  else
    begin
      s := '';
      sVitals := '';
      sCliO := '';
      iVitals := 0;
      iExternal := 0;
      sReason := rgReason.Items[rgReason.ItemIndex];
      for i := 0 to lvVitals.Items.Count - 1 do
        if lvVitals.Items[i].Selected then
          begin
            s := s + lvVitals.Items[i].Caption +'  ' + lvVitals.Items[i].SubItems[0] + #13;
            if lvVitals.Items[i].SubItems[2] = kwVitals then
              begin
                sVitals := sVitals + lvVitals.Items[i].Caption +'  ' + lvVitals.Items[i].SubItems[0] + #13;
                inc(iVitals);
              end
            else
              begin
                sCliO := sCliO + lvVitals.Items[i].Caption +'  ' + lvVitals.Items[i].SubItems[0] + #13;
                inc(iExternal);
              end;
          end;

//      if MessageDlg('Are you sure you want to mark '+IntToStr(j)+' vitals sign records as '
//        + sReason+'?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
//           Exit;
      if iVitals = 0 then
        begin
          MessageDlg('Selected records are not stored in the Vitals package.'+#13+
            'Please use the Flowsheets application to update them.', mtInformation, [mbOk], 0);
          exit;
        end;

      if MessageDlg(WarningString(iExternal), mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit;

      sDUZ := getUserDUZString;
      for i := 0 to lvVitals.Items.Count - 1 do
        if lvVitals.Items[i].Selected and (lvVitals.Items[i].SubItems[2] = kwVitals)
        then
          with TGMV_FileEntry(lvVitals.Items[i].Data) do
            begin
              RetList := setGMVErrorRecord(IEN + '^' + sDUZ + '^' + IntToStr(rgReason.ItemIndex + 1));
              RetList.Free;
            end;
//      MessageDlg('Vitals:'+#13#10#13#10+s+#13#10#13#10+'marked as ' + rgReason.Items[rgReason.ItemIndex],mtInformation,[mbOk],0);
//      ShowInfo('Entered In Error Result','Vitals:'+#13#10#13#10+s+#13#10#13#10+'marked as ' + rgReason.Items[rgReason.ItemIndex]);
      ModalResult := mrOK;
    end;
end;

procedure TfrmGMV_EnteredInError.OkToProceed(Sender: TObject);
begin
  btnOK.Enabled := (rgReason.ItemIndex > -1)
    and (lvVitals.SelCount > 0) and  (rgReason.ItemIndex >= 0);
end;

procedure TfrmGMV_EnteredInError.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearList;
end;

procedure TfrmGMV_EnteredInError.lvVitalsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  rgReason.Enabled := (lvVitals.ItemFocused <> nil) or (lvVitals.SelCount > 0);
end;

procedure TfrmGMV_EnteredInError.FormResize(Sender: TObject);
var
  i,iLen:Integer;
begin
//  lvVitals.Columns[1].Width := lvVitals.Width - lvVitals.Columns[0].Width - lvVitals.Columns[2].Width- 4;
  iLen := lvVitals.Width - 20;
  for i := 0 to lvVitals.Columns.Count - 1 do
    if i <> 1 then
      iLen := iLen - lvVitals.Columns[i].Width;
  lvVitals.Columns[1].Width := iLen;
end;

procedure TfrmGMV_EnteredInError.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmGMV_EnteredInError.lvVitalsCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.SubItems.Count >= 2 then begin
  if Item.SubItems[2] = kwClio then
    lvVitals.Canvas.Font.Color := clGray
  else
    lvVitals.Canvas.Font.Color := clWindowText;
  end;
end;

end.

