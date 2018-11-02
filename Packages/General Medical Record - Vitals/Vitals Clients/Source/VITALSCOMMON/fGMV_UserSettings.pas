unit fGMV_UserSettings;

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
  ComCtrls,
  ExtCtrls,
  ToolWin,
  StdCtrls,
  ImgList,
  Grids,
  uGMV_Common, ActnList, Buttons, System.Actions;

type
  TfrmGMV_UserSettings = class(TForm)
    pnlControls: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    acRestoreDefaults: TAction;
    ColorDialog1: TColorDialog;
    gbxNormal: TGroupBox;
    ckbNormalBold: TCheckBox;
    ckbNormalQuals: TCheckBox;
    gbxAbnormal: TGroupBox;
    ckbAbnormalBold: TCheckBox;
    ckbAbnormalQuals: TCheckBox;
    gbxSamples: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtNormal: TEdit;
    edtAbnormal: TEdit;
    grdSample: TStringGrid;
    gbDelay: TGroupBox;
    cbxSearchDelay: TComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    bbNormalText: TBitBtn;
    bbNormalBG: TBitBtn;
    bbNormalToday: TBitBtn;
    ilColors: TImageList;
    bbAbnText: TBitBtn;
    bbAbnBG: TBitBtn;
    bbAbnToday: TBitBtn;
    procedure tbtnAbnormalTextClick(Sender: TObject);
    procedure UpdateSample;
    procedure tbtnAbnormalBackgroundClick(Sender: TObject);
    procedure tbtnNormalBackgroundClick(Sender: TObject);
    procedure tbtnNormalTextClick(Sender: TObject);
    procedure ckbNormalBoldClick(Sender: TObject);
    procedure ckbAbnormalBoldClick(Sender: TObject);
    procedure grdSampleDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure ckbNormalQualsClick(Sender: TObject);
    procedure ckbAbnormalQualsClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure acRestoreDefaultsExecute(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxSearchDelayChange(Sender: TObject);
    procedure tbtnNormalTodayBackgroundClick(Sender: TObject);
    procedure tbtnAbNormalTodayBackgroundClick(Sender: TObject);
    procedure gbxNormalEnter(Sender: TObject);
    procedure gbxAbnormalExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    ChangesMade: Boolean;
    procedure SetApplyActive(bState: Boolean);
    procedure setBM(anIndex: Integer;aButton: TBitBtn; aBM: TBitmap);
  public
    { Public declarations }
  end;

procedure UpdateUserSettings;

implementation

uses fGMV_SelectColor, uGMV_Const, uGMV_GlobalVars, uGMV_User;

{$R *.DFM}
var
  oldGMVAbnormalText: integer = 9;
  oldGMVAbnormalBkgd: integer = 15;
  oldGMVAbnormalTodayBkgd: integer = 15;
  oldGMVAbnormalBold: Boolean = False;
  oldGMVAbnormalQuals: Boolean = False;
  oldGMVNormalText: integer = 0;
  oldGMVNormalBkgd: integer = 15;
  oldGMVNormalTodayBkgd: integer = 15;
  oldGMVNormalBold: Boolean = False;
  oldGMVNormalQuals: Boolean = True;

  oldGMVInquiryBkgd : Integer = $00EACF80;
  newGMVInquiryBkgd : Integer = $00EACF80;
  oldGMVInquiryTextBkgd : Integer = clInfoBk;
  newGMVInquiryTextBkgd : Integer = clInfoBk;

  oldGMVSearchDelay: String = '1.0';

  newGMVAbnormalText: integer = 9;
  newGMVAbnormalBkgd: integer = 15;
  newGMVAbnormalTodayBkgd: integer = 15;
  newGMVAbnormalBold: Boolean = False;
  newGMVAbnormalQuals: Boolean = False;
  newGMVNormalText: integer = 0;
  newGMVNormalBkgd: integer = 15;
  newGMVNormalTodayBkgd: integer = 15;
  newGMVNormalBold: Boolean = False;
  newGMVNormalQuals: Boolean = True;

  newGMVSearchDelay: String = '1.0';

  oldGMVInquiryName: String = 'ORWPT PTINQ';
  newGMVInquiryName: String = 'ORWPT PTINQ';


procedure SetDefaultSettings;
begin
  newGMVAbnormalText := dfltGMVAbnormalText;
  newGMVAbnormalBkgd := dfltGMVAbnormalBkgd;
  newGMVAbnormalTodayBkgd := dfltGMVAbnormalTodayBkgd;
  newGMVAbnormalBold := dfltGMVAbnormalBold;
  newGMVAbnormalQuals := dfltGMVAbnormalQuals;
  newGMVNormalText := dfltGMVNormalText;
  newGMVNormalBkgd := dfltGMVNormalBkgd;
  newGMVNormalTodayBkgd := dfltGMVNormalTodayBkgd;
  newGMVNormalBold := dfltGMVNormalBold;
  newGMVNormalQuals := dfltGMVNormalQuals;

//  newGMVInquiryBkgd := dfltGMVInquiryBkgd;
end;

procedure SaveSettings;
begin
  GMVAbnormalText := newGMVAbnormalText;
  GMVAbnormalBkgd := newGMVAbnormalBkgd;
  GMVAbnormalTodayBkgd := newGMVAbnormalTodayBkgd;
  GMVAbnormalBold := newGMVAbnormalBold;
  GMVAbnormalQuals := newGMVAbnormalQuals;
  GMVNormalText := newGMVNormalText;
  GMVNormalBkgd := newGMVNormalBkgd;
  GMVNormalTodayBkgd := newGMVNormalTodayBkgd;
  GMVNormalBold := newGMVNormalBold;
  GMVNormalQuals := newGMVNormalQuals;

  GMVSearchDelay := newGMVSearchDelay;

  GMVInquiryBkgd := newGMVInquiryBkgd;
  GMVInquiryTextBkgd := newGMVInquiryTextBkgd;
  GMVInquiryName := newGMVInquiryName;
end;

procedure RestoreSettings;
begin
  GMVAbnormalText := oldGMVAbnormalText;
  GMVAbnormalBkgd := oldGMVAbnormalBkgd;
  GMVAbnormalTodayBkgd := oldGMVAbnormalTodayBkgd;
  GMVAbnormalBold := oldGMVAbnormalBold;
  GMVAbnormalQuals := oldGMVAbnormalQuals;
  GMVNormalText := oldGMVNormalText;
  GMVNormalBkgd := oldGMVNormalBkgd;
  GMVNormalTodayBkgd := oldGMVNormalTodayBkgd;
  GMVNormalBold := oldGMVNormalBold;
  GMVNormalQuals := oldGMVNormalQuals;

  GMVSearchDelay := oldGMVSearchDelay;
  GMVInquiryBkgd := oldGMVInquiryBkgd;
  GMVInquiryTextBkgd := oldGMVInquiryTextBkgd;
  GMVInquiryName := oldGMVInquiryName;
end;

procedure CopySettings;
begin
  oldGMVAbnormalText := GMVAbnormalText;
  oldGMVAbnormalBkgd := GMVAbnormalBkgd;
  oldGMVAbnormalTodayBkgd := GMVAbnormalTodayBkgd;
  oldGMVAbnormalBold := GMVAbnormalBold;
  oldGMVAbnormalQuals := GMVAbnormalQuals;
  oldGMVNormalText := GMVNormalText;
  oldGMVNormalBkgd := GMVNormalBkgd;
  oldGMVNormalTodayBkgd := GMVNormalTodayBkgd;
  oldGMVNormalBold := GMVNormalBold;
  oldGMVNormalQuals := GMVNormalQuals;

  oldGMVInquiryBkgd := GMVInquiryBkgd;
  oldGMVInquiryTextBkgd := GMVInquiryTextBkgd;

  oldGMVSearchDelay := GMVSearchDelay;
  oldGMVInquiryName := GMVInquiryName;

  newGMVAbnormalText := GMVAbnormalText;
  newGMVAbnormalBkgd := GMVAbnormalBkgd;
  newGMVAbnormalTodayBkgd := GMVAbnormalTodayBkgd;
  newGMVAbnormalBold := GMVAbnormalBold;
  newGMVAbnormalQuals := GMVAbnormalQuals;
  newGMVNormalText := GMVNormalText;
  newGMVNormalBkgd := GMVNormalBkgd;
  newGMVNormalTodayBkgd := GMVNormalTodayBkgd;
  newGMVNormalBold := GMVNormalBold;
  newGMVNormalQuals := GMVNormalQuals;

  newGMVSearchDelay := GMVSearchDelay;

  newGMVInquiryBkgd := GMVInquiryBkgd;
  newGMVInquiryTextBkgd := GMVInquiryTextBkgd;
  newGMVInquiryName := GMVInquiryName;
end;

procedure UpdateUserSettings;
var
  BM: TBitmap;
begin
  if not assigned(frmGMV_SelectColor)
    then Application.CreateForm(TfrmGMV_SelectColor,frmGMV_SelectColor);

  with TfrmGMV_UserSettings.Create(Application) do
    try
{$IFDEF DLL}
      Caption := 'User preferences';
{$ELSE}
      Caption := 'User preferences [' + GMVUser.Name + ']';
{$ENDIF}
      cbxSearchDelay.Text := GMVSearchDelay;

      CopySettings; //AAN 06/13/02

      BM := TBitmap.Create;
      setBM(GMVNormalText,bbNormalText,BM);
      setBM(GMVNormalBkgd,bbNormalBG,BM);

      ckbNormalBold.Checked := GMVNormalBold;
      ckbNormalQuals.Checked := GMVNormalQuals;

      setBM(GMVAbNormalText,bbAbnText,BM);
      setBM(GMVAbNormalBkgd,bbAbnBG,BM);

      ckbAbnormalBold.Checked := GMVAbnormalBold;
      ckbAbnormalQuals.Checked := GMVAbnormalQuals;

      grdSample.Cells[0, 0] := '';
      grdSample.Cells[1, 0] := FormatDateTime('nn-dd-yy',Now-7);;
      grdSample.Cells[2, 0] := FormatDateTime('nn-dd-yy',Now-1);
//      grdSample.Cells[3, 0] := FormatDateTime('nn-dd-yy',Now);

      grdSample.Cells[0, 1] := 'xxxxxx';
      grdSample.Cells[1, 1] := '123 Normal';

      grdSample.Cells[0, 2] := 'xxxxxx';
      grdSample.Cells[2, 2] := '999* Abnormal';

      grdSample.Cells[0, 3] := 'xxxxxx';//'Today';
      grdSample.Cells[1, 3] := '123 Normal';
      grdSample.Cells[2, 3] := '999* Abnormal';

      UpdateSample;
      ChangesMade := False;
      SetApplyActive(False);//AAN 06/10/02
      if (ShowModal <> mrOK) and ChangesMade then //AAN 06/13/02
        begin
          RestoreSettings;
          CopySettings;
          SaveSettings;
        end
      else
        if ChangesMade then
          SaveSettings;
    finally
      Free;
    end;
end;

procedure TfrmGMV_UserSettings.tbtnNormalTextClick(Sender: TObject);
begin
  SelectColor(TControl(Sender), newGMVNormalText); //AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.tbtnAbnormalTextClick(Sender: TObject);
begin
  SelectColor(bbAbnText, newGMVAbnormalText); //AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.tbtnNormalBackgroundClick(Sender: TObject);
begin
  SelectColor(TControl(Sender), newGMVNormalBkgd);//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.tbtnAbnormalBackgroundClick(Sender: TObject);
begin
  SelectColor(bbAbnBg, newGMVAbnormalBkgd);//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.tbtnAbNormalTodayBackgroundClick(
  Sender: TObject);
begin
  SelectColor(bbAbnToday, newGMVAbNormalTodayBkgd);//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.tbtnNormalTodayBackgroundClick(Sender: TObject);
begin
  SelectColor(bbNormalToday, newGMVNormalTodayBkgd);//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.setBM(anIndex: Integer;aButton: TBitBtn; aBM: TBitmap);
begin
  ilColors.GetBitmap(anIndex,aBM);
  aButton.Glyph.Assign(aBM);
end;

procedure TfrmGMV_UserSettings.UpdateSample;
var
  BM: TBitmap;
begin
  BM := TBitmap.Create;
  setBM(newGMVNormalText,bbNormalText,BM);
  setBM(newGMVNormalBkgd,bbNormalBG,BM);
  setBM(newGMVNormalTodayBkgd,bbNormalToday,BM);

  setBM(newGMVAbNormalText,bbAbnText,BM);
  setBM(newGMVAbNormalBkgd,bbAbnBG,BM);
  setBM(newGMVAbNormalTodayBkgd,bbAbnToday,BM);

  edtAbnormal.Color := DISPLAYCOLORS[newGMVAbnormalBkgd];//AAN 06/13/02
  edtAbnormal.Font.Color := DISPLAYCOLORS[newGMVAbnormalText];//AAN 06/13/02
  ckbAbnormalBold.Checked := newGMVAbnormalBold;//AAN 06/14/02
  ckbAbnormalQuals.Checked := newGMVAbnormalQuals;//AAN 06/14/02
  if newGMVAbnormalBold then//AAN/06/14
    edtAbnormal.Font.Style := [fsBold]
  else
    edtAbnormal.Font.Style := [];
  edtNormal.Color := DISPLAYCOLORS[newGMVNormalBkgd];//AAN 06/13/02
  edtNormal.Font.Color := DISPLAYCOLORS[newGMVNormalText];//AAN 06/13/02
  ckbNormalQuals.Checked := newGMVNormalQuals;//AAN 06/14/02
  ckbNormalBold.Checked := newGMVNormalBold;//AAN 06/14/02
  if newGMVNormalBold then //AAN 06/13/02
    edtNormal.Font.Style := [fsBold]
  else
    edtNormal.Font.Style := [];
  grdSample.Refresh;

  ChangesMade := True;//AAN 06/13/02
  SetApplyActive(True);//AAN 06/10/02
end;

procedure TfrmGMV_UserSettings.ckbNormalBoldClick(Sender: TObject);
begin
  newGMVNormalBold := ckbNormalBold.Checked;//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.ckbAbnormalBoldClick(Sender: TObject);
begin
  newGMVAbnormalBold := ckbAbnormalBold.Checked;//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.ckbNormalQualsClick(Sender: TObject);
begin
  newGMVNormalQuals := ckbNormalQuals.Checked;//AAN 06/13/02
  if newGMVNormalQuals then
    grdSample.Cells[1,1] := '123 Normal'
  else
    grdSample.Cells[1,1] := '123';
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.ckbAbnormalQualsClick(Sender: TObject);
begin
  newGMVAbnormalQuals := ckbAbnormalQuals.Checked;//AAN 06/13/02
  if newGMVAbNormalQuals then
    grdSample.Cells[2,2] := '999* Abnormal'
  else
    grdSample.Cells[2,2] := '999*';
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.grdSampleDrawCell(
  Sender: TObject;
  ACol, ARow: integer;
  Rect: TRect;
  State: TGridDrawState);
begin
  with grdSample do
    begin
      // Fill in background as btnFace, Abnormal, Normal
      if (ACol = 0) or (ARow = 0) then
        Canvas.Brush.Color := clBtnFace
      else if Pos('*', Cells[ACol, ARow]) > 0 then
        begin
//          if ARow = 3 then
//            Canvas.Brush.Color := DISPLAYCOLORS[newGMVAbnormalTodayBkgd]
//          else
            Canvas.Brush.Color := DISPLAYCOLORS[newGMVAbnormalBkgd];//AAN 06/13/02
        end
      else
//          if ARow = 3 then
//            Canvas.Brush.Color := DISPLAYCOLORS[newGMVNormalTodayBkgd]
//          else
            Canvas.Brush.Color := DISPLAYCOLORS[newGMVNormalBkgd];//AAN 06/13/02
      Canvas.FillRect(Rect);

      // Set up font color as btnText, Abnormal, Normal
      if (ACol = 0) or (ARow = 0) then
        begin
          Canvas.Font.Color := clBtnText;
          Canvas.Font.Style := [];//AAN 06/14/02
        end
      else if Pos('*', Cells[ACol, ARow]) > 0 then
        begin
          Canvas.Font.Color := DISPLAYCOLORS[newGMVAbnormalText];//AAN 06/13/02
          if newGMVAbnormalBold then//AAN 06/13/02
            Canvas.Font.Style := [fsBold]
          else
            Canvas.Font.Style := [];
        end
      else
        begin
          Canvas.Font.Color := DISPLAYCOLORS[newGMVNormalText];//AAN 06/13/02
          if newGMVNormalBold then//AAN 06/13/02
            Canvas.Font.Style := [fsBold]
          else
            Canvas.Font.Style := [];
        end;
      Canvas.TextRect(Rect, Rect.Left, Rect.Top, Cells[ACol, ARow]);
    end;
end;

procedure TfrmGMV_UserSettings.btnApplyClick(Sender: TObject);
begin
  SaveSettings;//AAN 06/13/02
  GMVUser.Setting[usCanvasNormal] :=
    IntToStr(GMVNormalBkgd) + ';' +
    IntToStr(GMVNormalText) + ';' +
    IntToStr(BOOLEAN01[ckbNormalBold.Checked]) + ';' +
    IntToStr(BOOLEAN01[ckbNormalQuals.Checked])+ ';' +
    IntToStr(GMVNormalTodayBkgd)
    +';'+ IntToStr(GMVInquiryBkgd)
    +';'+ IntToStr(GMVInquiryTextBkgd)
    +';'+ GMVInquiryName
    ;
  GMVUser.Setting[usCanvasAbnormal] :=
    IntToStr(GMVAbnormalBkgd) + ';' +
    IntToStr(GMVAbnormalText) + ';' +
    IntToStr(BOOLEAN01[ckbAbnormalBold.Checked]) + ';' +
    IntToStr(BOOLEAN01[ckbAbnormalQuals.Checked]) + ';'+
    IntToStr(GMVAbnormalTodayBkgd);

  try
    GMVSearchDelay := cbxSearchDelay.Text;
    GMVUser.Setting[usSearchDelay] := cbxSearchDelay.Text;
  except
  end;
  SetApplyActive(False);//AAN 06/10/02
end;

//AAN 06/10/02-------------------------------------------------Begin
procedure TfrmGMV_UserSettings.SetApplyActive(bState: boolean);
begin
  btnApply.Enabled := bState;
end;
//AAN 06/10/02---------------------------------------------------End

procedure TfrmGMV_UserSettings.acRestoreDefaultsExecute(Sender: TObject);
begin
  SetDefaultSettings;
  ChangesMade := True;
  UpdateSample;
  refresh;

  GMVSearchDelay := '1.0';
  cbxSearchDelay.Text := '1.0';
  SetApplyActive(true);
end;

procedure TfrmGMV_UserSettings.btnOKClick(Sender: TObject);
begin
  btnApplyClick(Sender);
end;

procedure TfrmGMV_UserSettings.cbxSearchDelayChange(Sender: TObject);
begin
  SetApplyActive(True);
end;

procedure TfrmGMV_UserSettings.gbxNormalEnter(Sender: TObject);
begin
  TGroupBox(Sender).Font.Style := [fsBold];
end;

procedure TfrmGMV_UserSettings.gbxAbnormalExit(Sender: TObject);
begin
  TGroupBox(Sender).Font.Style := [];
end;

procedure TfrmGMV_UserSettings.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Escape then
    ModalResult := mrCancel;
end;

end.

