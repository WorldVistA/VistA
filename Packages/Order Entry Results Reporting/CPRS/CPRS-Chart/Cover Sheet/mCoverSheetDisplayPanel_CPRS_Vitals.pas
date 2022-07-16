unit mCoverSheetDisplayPanel_CPRS_Vitals;
{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    doma.user@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-21
  *
  *       Description:  Vitals display panel for CPRS Coversheet.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  mCoverSheetDisplayPanel_CPRS,
  iCoverSheetIntf,
  oDelimitedString;

type
  TfraCoverSheetDisplayPanel_CPRS_Vitals = class(TfraCoverSheetDisplayPanel_CPRS)
  private
    fSeparator: TMenuItem;
    fUpdateVitals: TMenuItem;
  protected
    { Inherited events - TfraGridPanel }
    procedure OnPopupMenu(Sender: TObject); override;
    procedure OnPopupMenuInit(Sender: TObject); override;
    procedure OnPopupMenuFree(Sender: TObject); override;

    { Inherited events - TfraCoverSheetDisplayPanel_CPRS }
    procedure OnAddItems(aList: TStrings); override;
    procedure OnGetDetail(aRec: TDelimitedString; aDetail: TStrings); override;
    procedure OnShowDetail(aText: TStrings; aTitle: string = ''; aPrintable: boolean = false); override;

    { Introduced Events }
    procedure OnUpdateVitals(Sender: TObject); virtual;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  fraCoverSheetDisplayPanel_CPRS_Vitals: TfraCoverSheetDisplayPanel_CPRS_Vitals;

implementation

{$R *.dfm}


uses
  ORFn,
  ORNet,
  rMisc,
  uCore,
  uVitals;

{ TfraCoverSheetDisplayPanel_CPRS_Vitals }

constructor TfraCoverSheetDisplayPanel_CPRS_Vitals.Create(aOwner: TComponent);
begin
  inherited;
  AddColumn(0, 'Vital');
  AddColumn(1, 'Value');
  AddColumn(2, 'Date Taken');
  AddColumn(3, 'Conv. Value');
  AddColumn(4, 'Quals');
  CollapseColumns;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnPopupMenu(Sender: TObject);
begin
  inherited;

  fUpdateVitals.Enabled := True;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnPopupMenuFree(Sender: TObject);
begin
  FreeAndNil(fSeparator);
  FreeAndNil(fUpdateVitals);

  inherited;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnPopupMenuInit(Sender: TObject);
begin
  inherited;

  fSeparator := NewLine;
  fUpdateVitals := NewItem('Update Vitals ...', 0, False, True, OnUpdateVitals, 0, 'pmnVitals_UpdateVitals');

  pmn.Items.Add(fSeparator);
  pmn.Items.Add(fUpdateVitals);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnShowDetail(aText: TStrings;  aTitle: string; aPrintable: boolean);
begin
  // Tricking the UI to go to Vitals Lite when single clicked
  OnUpdateVitals(lvData);
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnUpdateVitals(Sender: TObject);
var
  aFunctionAddr: TGMV_VitalsViewForm;
  aFunctionName: AnsiString;
  aRtnRec: TDllRtnRec;
  aStartDate: string;
  aVitalsAbbv: string;
begin
  { Availble Forms:
    GMV_FName :='GMV_VitalsEnterDLG';
    GMV_FName :='GMV_VitalsEnterForm';
    GMV_FName :='GMV_VitalsViewForm';
    GMV_FName :='GMV_VitalsViewDLG';
  }
  lvData.Enabled := false;
  try
    try
      aFunctionName := 'GMV_VitalsViewDLG';
      aRtnRec := LoadVitalsDLL;

      case aRtnRec.Return_Type of
        DLL_Success:
          try
            @aFunctionAddr := GetProcAddress(VitalsDLLHandle, PAnsiChar(aFunctionName));
            if Assigned(aFunctionAddr) then
              begin
                if Patient.Inpatient then
                  aStartDate := FormatDateTime('mm/dd/yy', Now - 7)
                else
                  aStartDate := FormatDateTime('mm/dd/yy', IncMonth(Now, -6));

                if lvData.Selected <> nil then
                  aVitalsAbbv := lvData.Selected.Caption
                else
                  aVitalsAbbv := '';

                aFunctionAddr(RPCBrokerV, Patient.DFN, IntToStr(Encounter.Location), aStartDate, FormatDateTime('mm/dd/yy', Now), GMV_APP_SIGNATURE, GMV_CONTEXT, GMV_CONTEXT, Patient.Name, Format('%s    %d', [Patient.SSN, Patient.Age]),
                  Encounter.LocationName + U + aVitalsAbbv);
              end
            else
              MessageDLG('Can''t find function "GMV_VitalsViewDLG".', mtError, [mbok], 0);
          except
            on E: Exception do
              MessageDLG('Error running Vitals Lite: ' + E.Message, mtError, [mbok], 0);
          end;
        DLL_Missing:
          begin
            TaskMessageDlg('File Missing or Invalid', aRtnRec.Return_Message, mtError, [mbok], 0);
          end;
        DLL_VersionErr:
          begin
            TaskMessageDlg('Incorrect Version Found', aRtnRec.Return_Message, mtError, [mbok], 0);
          end;
      end;
    finally
      @aFunctionAddr := nil;
      UnloadVitalsDLL;
    end;

    CoverSheet.OnRefreshPanel(Self, CV_CPRS_VITL);
    CoverSheet.OnRefreshPanel(Self, CV_CPRS_RMND);
  finally
    lvData.Enabled := True;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnAddItems(aList: TStrings);
var
  aRec: TDelimitedString;
  aData, aQual, aStr: string;
begin
  if aList.Count = 0 then
    aList.Add('^No Vitals Found.');

  try
    lvData.Items.BeginUpdate;
    for aStr in aList do
      begin
        aRec := TDelimitedString.Create(aStr);

        if lvData.Items.Count = 0 then
          if aRec.GetPieceIsNull(1) and (aList.Count = 1) then
            begin
              CollapseColumns;
              exit;
            end;

        with lvData.Items.Add do
          begin
            Caption := aRec.GetPiece(2);
            SubItems.Add(aRec.GetPiece(5));
            SubItems.Add(FormatDateTime(DT_FORMAT, aRec.GetPieceAsTDateTime(4)));
            SubItems.Add(aRec.GetPiece(6));

//            SubItems.Add(aRec.GetPiece(7));
            aData := aRec.GetPiece(7);
            aQual := aRec.GetPiece(8); // e.g. for POX details are in piece 8
            if Trim(aQual) <> '' then
              aData := aData + ' ' + aQual;
            SubItems.Add(aData);

            Data := aRec;
          end;
      end;
    ExpandColumns;

  finally
    lvData.Items.EndUpdate;
  end;
end;

procedure TfraCoverSheetDisplayPanel_CPRS_Vitals.OnGetDetail(aRec: TDelimitedString; aDetail: TStrings);
var
  aDateTime: TDateTime;
begin
  aDateTime := FMDateTimeToDateTime(aRec.GetPieceAsDouble(4));
  aDetail.Clear;
  aDetail.Add(Format('%s %s', ['Vital ..........', aRec.GetPieceAsString(2)]));
  aDetail.Add(Format('%s %s', ['Date/Time ......', FormatDateTime('MMM DD, YYYY@hh:mm', aDateTime)]));
  aDetail.Add(Format('%s %s', ['Value ..........', aRec.GetPieceAsString(5)]));
  aDetail.Add(Format('%s %s', ['Conv. Value ....', aRec.GetPieceAsString(6)]));
  aDetail.Add(Format('%s %s', ['Qualifiers .....', aRec.GetPieceAsString(7)]));
end;

end.
