unit mGMV_EditTemplate;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/05/09 10:31a $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Frame used to edit/save vitals templates
*
*       Notes:        Used on the Vitals User and Manager application
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON/mGMV_EditTemplate.pas $
*
* $History: mGMV_EditTemplate.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSCOMMON
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/VitalsCommon
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:18p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:06p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/Common
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 10/29/03   Time: 4:14p
 * Created in $/Vitals503/Common
 * Version 5.0.3
 * 
 * *****************  Version 11  *****************
 * User: Zzzzzzandria Date: 5/02/03    Time: 9:33a
 * Updated in $/Vitals GUI Version 5.0/Common
 * Sentillion CCOW Immersion updates
 * 
 * *****************  Version 10  *****************
 * User: Zzzzzzandria Date: 11/04/02   Time: 9:15a
 * Updated in $/Vitals GUI Version 5.0/Common
 * Version 5.0.0.0
 *
 * *****************  Version 9  *****************
 * User: Zzzzzzandria Date: 10/04/02   Time: 4:50p
 * Updated in $/Vitals GUI Version 5.0/Common
 * Version T32 
 * 
 * *****************  Version 8  *****************
 * User: Zzzzzzandria Date: 9/06/02    Time: 3:58p
 * Updated in $/Vitals GUI Version 5.0/Common
 * Version T31
 *
 * *****************  Version 7  *****************
 * User: Zzzzzzandria Date: 7/12/02    Time: 5:01p
 * Updated in $/Vitals GUI Version 5.0/Common
 * GUI Version T28
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 6/13/02    Time: 5:14p
 * Updated in $/Vitals GUI Version 5.0/Common
 * 
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 6/11/02    Time: 4:47p
 * Updated in $/Vitals GUI Version 5.0/Common
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:08a
 * Updated in $/Vitals GUI Version 5.0/Common
 * Roll-up to 5.0.0.27
 *
 * *****************  Version 3  *****************
 * User: Zzzzzzpetitd Date: 4/26/02    Time: 11:31a
 * Updated in $/Vitals GUI Version 5.0/Common
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 4/15/02    Time: 12:16p
 * Updated in $/Vitals GUI Version 5.0/Common
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 4:01p
 * Created in $/Vitals GUI Version 5.0/Common
 *
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
  Buttons,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  CheckLst,
  uGMV_Common,
  fGMV_AddVCQ
  , uGMV_QualifyBox
  , uGMV_Template
  , ActnList, ImgList, System.Actions, System.ImageList;

type
  TfraGMV_EditTemplate = class(TFrame)
    pnlQualifiers: TPanel;
    pnlVitals: TPanel;
    rgMetric: TRadioGroup;
    Splitter1: TSplitter;
    pnlHeader: TPanel;
    pnlNameDescription: TPanel;
    edtTemplateDescription: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    edtTemplateName: TEdit;
    pnlListView: TPanel;
    ActionList1: TActionList;
    acUp: TAction;
    acDown: TAction;
    acAdd: TAction;
    acDelete: TAction;
    Panel1: TPanel;
    Panel3: TPanel;
    lblVitals: TLabel;
    Panel5: TPanel;
    ImageList1: TImageList;
    Panel7: TPanel;
    pnlDefaults: TPanel;
    Panel8: TPanel;
    lblQualifiers: TLabel;
    pnlDefaultQualifiers: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    gb: TGroupBox;
    Panel4: TPanel;
    lvVitals: TListView;
    procedure QBCheck(Sender: TObject);
    procedure lvVitalsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pnlQualifiersResize(Sender: TObject);
    procedure rgMetricClick(Sender: TObject);
    procedure pnlListViewResize(Sender: TObject);
    procedure ChangeMade(Sender: TObject);
    procedure edtTemplateNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acUpExecute(Sender: TObject);
    procedure acDownExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure edtTemplateNameEnter(Sender: TObject);
    procedure edtTemplateNameExit(Sender: TObject);
    procedure edtTemplateDescriptionEnter(Sender: TObject);
    procedure edtTemplateDescriptionExit(Sender: TObject);
    procedure lvVitalsExit(Sender: TObject);
    procedure lvVitalsEnter(Sender: TObject);
    procedure rgMetricEnter(Sender: TObject);
    procedure rgMetricExit(Sender: TObject);
    procedure gbDefaultEnter(Sender: TObject);
    procedure gbDefaultExit(Sender: TObject);
  private
    fQualBoxes: TList;
    fEditTemplate: TGMV_Template;
    fIgnore:Boolean;
    fChangingOrder: Boolean;
    fChangesMade: Boolean;
    fQCanvas: TWinControl;
    procedure AddVital(Vital: TGMV_TemplateVital);
    procedure ClearAllQualBoxes(Keep:Boolean=False);
    procedure LoadQualifiers(VitalIEN: string);
    function GetEditTemplate: TGMV_Template;
    procedure SetEditTemplate(const Value: TGMV_Template);
    procedure getTemplate(Selected:Boolean;aCaption:String;aTemplate:TGMV_TemplateVital);
    procedure btnMoveUp;
    procedure btnMoveDown;
    procedure btnAddVital;
    procedure btnDeleteVital;
  public
    procedure SaveTemplate;
    procedure SaveTemplateIfChanged;
  published
    property EditTemplate: TGMV_Template
      read GetEditTemplate write SetEditTemplate;
    property ChangesMade: Boolean
      read FChangesMade;
  end;

implementation

uses uGMV_GlobalVars, uGMV_Const, uGMV_FileEntry
  , uGMV_Engine, mGMV_DefaultSelector, System.UITypes;


{$R *.DFM}

//AAN 06/11/02------------------------------------------------------------Begin
function MetricCaption(sVitalName:String;bVitalMetric:Boolean):String;
begin
  if pos(UpperCase(sVitalName),upperCase(MetricList)) <> 0 then
    result :=BOOLEANUM[bVitalMetric]
  else
    result := 'N/A';
end;
//AAN 06/11/02--------------------------------------------------------------End

procedure TfraGMV_EditTemplate.AddVital(Vital: TGMV_TemplateVital);
begin
  try
    with lvVitals.Items.Add do
      begin
        Caption := Vital.VitalName;
        SubItems.Add(MetricCaption(Caption,Vital.Metric));//AAN 06/11/02
        try
          SubItems.Add(Vital.DisplayQualifiers);
          Data := Vital;
        except
          Data := nil;
        end;
      end;
  except
  end;
end;

procedure TfraGMV_EditTemplate.ClearAllQualBoxes(Keep:Boolean=False);
var
  pnlQB: TPanel;
begin
  if fQualBoxes <> nil then
    while fQualBoxes.Count > 0 do
      begin
        pnlQB := TPanel(fQualBoxes[0]);
        fQualBoxes.Delete(0);
        FreeAndNil(pnlQB);
      end
  else
    fQualBoxes := TList.Create;

  rgMetric.ItemIndex := -1;
end;

procedure TfraGMV_EditTemplate.QBCheck(Sender: TObject);
var
  i, j: integer;
  s, defQuals: string;
  defQualsText: string;
begin
  for i := 0 to FQualBoxes.Count - 1 do
    with TGMV_TemplateQualifierBox(FQualBoxes[i]) do
      begin
        s := DefaultQualifierIEN;
        if StrToIntDef(s, -1) > 0 then
          begin
            j := GMVQuals.IndexOfIEN(DefaultQualifierIEN);
            if j > -1 then
              begin
                if defQuals <> '' then
                  defQuals := defQuals + '~';
                if defQualsText <> '' then
                  defQualsText := defQualsText + ',';
                defQuals := defQuals + CategoryIEN + ',' + DefaultQualifierIEN;
                defQualsText := defQualsText +
                  GMVQuals.Entries[GMVQuals.IndexOfIEN(DefaultQualifierIEN)];
              end;
          end
      end;
  TGMV_TemplateVital(lvVitals.Selected.Data).Qualifiers := defQuals;
  lvVitals.Selected.SubItems[1] := TGMV_TemplateVital(lvVitals.Selected.Data).DisplayQualifiers;
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0)    //AAN 06/11/02
end;

function TfraGMV_EditTemplate.GetEditTemplate: TGMV_Template;
begin
  Result := FEditTemplate;
end;

procedure TfraGMV_EditTemplate.SaveTemplate;
var
  x: string;
  i: integer;
begin
  {Is it renamed?}
  if edtTemplateName.Text <> FEditTemplate.TemplateName then
    if not FEditTemplate.Rename(edtTemplateName.Text) then
      begin
        MessageDlg('Sorry, ' + edtTemplateName.Text + ' is not a valid template name.', mtError, [mbok], 0);
        edtTemplateName.Text := FEditTemplate.TemplateName;
        Exit;
      end;

  x := edtTemplateDescription.Text + '|';
  for i := 0 to lvVitals.Items.Count - 1 do
    with TGMV_TemplateVital(lvVitals.Items[i].Data) do
      begin
        if i > 0 then
          x := x + ';';
        x := x + IEN + ':' + IntToStr(BOOLEAN01[Metric]);
        if Qualifiers <> '' then
          x := x + ':' + Qualifiers;
      end;
  FEditTemplate.XPARValue := x;
  FChangesMade := False;
  GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0)    //AAN 06/11/02
end;

procedure TfraGMV_EditTemplate.pnlQualifiersResize(Sender: TObject);
var
  i: integer;
begin
Exit;
  if FQualBoxes <> nil then
    for i := 0 to FQualBoxes.Count - 1 do
      TGMV_TemplateQualifierBox(FQualBoxes[i]).Width := (pnlQualifiers.Width div FQualBoxes.Count);
end;

procedure TfraGMV_EditTemplate.btnMoveUp;
var
  tmpItem: TGMV_TemplateVital;
  i: integer;
begin
  lvVitals.Items.BeginUpdate;
  FChangingOrder := True;
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
  if lvVitals.Selected.Index > 0 then
    begin
      i := lvVitals.Items.IndexOf(lvVitals.Selected);
      tmpItem := lvVitals.Items[i].Data;
      lvVitals.Items[i].Data := lvVitals.Items[i - 1].Data;
      lvVitals.Items[i - 1].Data := tmpItem;

      with TGMV_TemplateVital(lvVitals.Items[i].Data) do
        begin
          lvVitals.Items[i].Caption := VitalName;
          lvVitals.Items[i].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      with TGMV_TemplateVital(lvVitals.Items[i - 1].Data) do
        begin
          lvVitals.Items[i - 1].Caption := VitalName;
          lvVitals.Items[i - 1].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i - 1].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      lvVitals.Items[i].Selected := False;
      lvVitals.Items[i - 1].Selected := True;
      lvVitals.UpdateItems(i - 1, i);
      lvVitals.ItemFocused := lvVitals.Items[i - 1];
    end;
  FChangingOrder := False;
  lvVitals.Items.EndUpdate;
end;

procedure TfraGMV_EditTemplate.btnMoveDown;
var
  tmpItem: TGMV_TemplateVital;
  i: integer;
begin
  lvVitals.Items.BeginUpdate;
  FChangingOrder := True;
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
  if lvVitals.Selected.Index < lvVitals.Items.Count - 1 then
    begin
      i := lvVitals.Items.IndexOf(lvVitals.Selected);
      tmpItem := lvVitals.Items[i].Data;
      lvVitals.Items[i].Data := lvVitals.Items[i + 1].Data;
      lvVitals.Items[i + 1].Data := tmpItem;

      with TGMV_TemplateVital(lvVitals.Items[i].Data) do
        begin
          lvVitals.Items[i].Caption := VitalName;
          lvVitals.Items[i].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      with TGMV_TemplateVital(lvVitals.Items[i + 1].Data) do
        begin
          lvVitals.Items[i + 1].Caption := VitalName;
          lvVitals.Items[i + 1].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i + 1].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      lvVitals.Items[i].Selected := False;
      lvVitals.Items[i + 1].Selected := True;
      lvVitals.UpdateItems(i, i + 1);
      lvVitals.ItemFocused := lvVitals.Items[i + 1];
    end;
  FChangingOrder := False;
  lvVitals.Items.EndUpdate;
end;

procedure TfraGMV_EditTemplate.btnAddVital;
var
  i: integer;
begin
  with TfrmGMV_AddVCQ.Create(Self) do
    try
      LoadVitals;
      ShowModal;
      if ModalResult = mrOk then
        for i := 0 to lbxVitals.Items.Count - 1 do
          if lbxVitals.Selected[i] then
            AddVital(TGMV_TemplateVital.CreateFromXPAR(
              TGMV_FileEntry(lbxVitals.Items.Objects[i]).IEN +
              ':' + lbxVitals.Items[i] + '::')
              );
      FChangesMade := True;
      GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0)    //AAN 06/11/02
    finally
      free;
    end;
end;

procedure TfraGMV_EditTemplate.btnDeleteVital;
var
  i: integer;
begin
  i := lvVitals.Items.IndexOf(lvVitals.Selected); {Where are we now}

  if lvVitals.Selected <> nil then
    begin
      FChangesMade := True;
      GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
      if lvVitals.Selected.Data <> nil then
        TGMV_TemplateVital(lvVitals.Selected.Data).Free;
      lvVitals.Selected.Delete;
      if i > lvVitals.Items.Count - 1 then
        i := lvVitals.Items.Count - 1; {Deleted last one, get new last item}
      if i > -1 then
        lvVitals.Items[i].Selected := True;
    end;
end;

procedure TfraGMV_EditTemplate.rgMetricClick(Sender: TObject);
begin
  if lvVitals.Selected <> nil then
    begin
      FChangesMade := True;
      GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
//AAN 06/11/02      lvVitals.Selected.SubItems[0] := rgMetric.Items[rgMetric.ItemIndex];
      TGMV_TemplateVital(lvVitals.Selected.Data).Metric := (rgMetric.ItemIndex = 1);
      lvVitals.Selected.SubItems[0] := MetricCaption(           //AAN 06/11/02
          TGMV_TemplateVital(lvVitals.Selected.Data).VitalName, //AAN 06/11/02
          TGMV_TemplateVital(lvVitals.Selected.Data).Metric);   //AAN 06/11/02
    end;
end;

procedure TfraGMV_EditTemplate.pnlListViewResize(Sender: TObject);
begin
  lvVitals.Width := pnlListView.Width - (lvVitals.Left * 2);
  lvVitals.Height := pnlListView.Height - (lvVitals.Top * 2);
end;

procedure TfraGMV_EditTemplate.ChangeMade(Sender: TObject);
begin
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0)    //AAN 06/11/02
end;

//AAN 06/11/02 ---------------------------------------------------------- Begin
procedure TfraGMV_EditTemplate.edtTemplateNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_Escape then
    ChangeMade(Sender);
end;

procedure TfraGMV_EditTemplate.SaveTemplateIfChanged;
begin
  if FChangesMade then
    if MessageDlg('The template <' + FEditTemplate.TemplateName + '> has been changed.'+
      #13#10+ 'Save changes?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      SaveTemplate;
end;
//AAN 06/11/02 ------------------------------------------------------------ End

procedure TfraGMV_EditTemplate.acUpExecute(Sender: TObject);
begin
  btnMoveUp;
end;

procedure TfraGMV_EditTemplate.acDownExecute(Sender: TObject);
begin
  btnMoveDown;
end;

procedure TfraGMV_EditTemplate.acAddExecute(Sender: TObject);
begin
  btnAddVital;
end;

procedure TfraGMV_EditTemplate.acDeleteExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete'+#13+
     '<'+lvVitals.Selected.Caption+'>?' ,
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  btnDeleteVital;
end;

procedure TfraGMV_EditTemplate.edtTemplateNameEnter(Sender: TObject);
begin
   label1.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.edtTemplateNameExit(Sender: TObject);
begin
   label1.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.edtTemplateDescriptionEnter(
  Sender: TObject);
begin
   label2.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.edtTemplateDescriptionExit(Sender: TObject);
begin
   label2.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.lvVitalsExit(Sender: TObject);
begin
  lblVitals.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.lvVitalsEnter(Sender: TObject);
begin
  lblVitals.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.gbDefaultEnter(Sender: TObject);
begin
  gb.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.gbDefaultExit(Sender: TObject);
begin
  gb.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.rgMetricExit(Sender: TObject);
begin
  rgMetric.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.rgMetricEnter(Sender: TObject);
var
  i: Integer;
begin
  rgMetric.font.Style := [fsBold];
  for i := 0 to rgMetric.ControlCount - 1 do
    if rgMetric.Controls[i] is TRadioButton then
      TRadioButton(rgMetric.Controls[i]).Font.Style := [];
end;

procedure TfraGMV_EditTemplate.LoadQualifiers(VitalIEN: string);
var
  iOrder,
  i: integer;
  retList: TStrings;

  function AddQualifierBox(QBVitalIEN: string;
    QBCatIEN: string; DefaultQualIEN: string = ''): TGMV_TemplateQualifierBox;
  begin
    if FQualBoxes = nil then
      FQualBoxes := TList.Create;
    Result := TGMV_TemplateQualifierBox.CreateParented(Self,fQCanvas,
      QBVitalIEN, QBCatIEN, DefaultQualIEN); // zzzzzzandria 20090219
    Result.OnClick := QBCheck;
    Result.Visible := True;
    Result.setDDWidth;
    FQualBoxes.Add(Result);
  end;

begin
  fQCanvas := gb;

  lblQualifiers.Caption := 'Default Qualifiers: (Loading...)';
  Application.ProcessMessages;
  ClearAllQualBoxes;
  Application.ProcessMessages;

  RetList := getCategoryQualifiers(VitalIEN);
  for i := RetList.Count - 1 downto 1  do
    AddQualifierBox(VitalIEN, Piece(RetList[i], '^', 1));
  RetList.Free;

  for i := 0 to fQCanvas.ControlCount - 1 do
    if fQCanvas.Controls[i] is tGMV_TemplateQualifierBox then
      begin
        iOrder := fQCanvas.ControlCount - 1 - i;
        TGMV_TemplateQualifierBox(fQCanvas.Controls[i]).TabOrder := iOrder;
      end;
  lblQualifiers.Caption := 'Default Qualifiers:';

  if not FChangesMade then  //AAN 06/12/02
    GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0)    //AAN 06/11/02
end;

procedure TfraGMV_EditTemplate.getTemplate(Selected:Boolean;aCaption:String;aTemplate:TGMV_TemplateVital);
var
  CatIEN: string;
  QualIEN: string;
  i, j: integer;
  bTmp: Boolean; //AAN 06/12/02
begin
  lvVitals.Enabled := False;
  if not fChangingOrder then
    if Selected then
      begin
        lblQualifiers.Caption := aCaption + ' Default Qualifiers';
        with aTemplate do
          begin
            LoadQualifiers(IEN);
            i := 1;
            while Piece(Qualifiers, '~', i) <> '' do
              begin
                CatIEN := Piece(Piece(Qualifiers, '~', i), ',', 1);
                QualIEN := Piece(Piece(Qualifiers, '~', i), ',', 2);
                for j := 0 to fQualBoxes.Count - 1 do
                  with TGMV_TemplateQualifierBox(fQualBoxes[j]) do
                    begin
                      if CategoryIEN = CatIEN then
                        DefaultQualifierIEN := QualIEN;
                      OnQualExit(nil);
                    end;
                inc(i);
              end;
            bTmp := FChangesMade;       //AAN 06/12/02
            rgMetric.ItemIndex := BOOLEAN01[Metric];
            rgMetric.Enabled := True;
            fChangesMade := bTmp;       //AAN 06/12/02
          end;
      end
    else
      ClearAllQualBoxes;

  acUp.Enabled := Selected;
  acDown.Enabled := Selected;
  acDelete.Enabled := Selected;
  rgMetric.Enabled := Selected;

//AAN 06/11/02 -----------------------------------------------------------Begin
  try
    rgMetric.Enabled := (pos(aTemplate.VitalName,MetricList) <> 0);
  except
  end;

  if not fChangesMade then
    GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0);    //AAN 06/11/02
//AAN 06/11/02 -------------------------------------------------------------End
  try
    lvVitals.Enabled := True;
    lvVitals.SetFocus;
  except
  end;
end;

procedure TfraGMV_EditTemplate.SetEditTemplate(const Value: TGMV_Template);
var
  XPAR: string;
  i: integer;
begin
  if FChangesMade then
    if MessageDlg('Save template ' + FEditTemplate.TemplateName + '?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      SaveTemplate;

  ClearAllQualBoxes;
  fIgnore := True;
  lvVitals.Items.Clear;
  fIgnore := False;

  rgMetric.ItemIndex := -1;
  rgMetric.Enabled := False;

  acUp.Enabled := False;
  acDown.Enabled := False;
  acDelete.Enabled := False;

  if Value <> nil then
    begin
      fEditTemplate := Value;
      fChangingOrder := False;
      XPAR := FEditTemplate.XPARValue;
      edtTemplateName.Text := FEditTemplate.TemplateName;
      edtTemplateDescription.Text := Piece(XPAR, '|', 1);
      XPAR := Piece(XPAR, '|', 2);
      i := 1;
      while Piece(XPAR, ';', i) <> '' do
        begin
          AddVital(TGMV_TemplateVital.CreateFromXPAR(Piece(XPAR, ';', i)));
          inc(i);
        end;
      if lvVitals.Items.Count > 0 then
        lvVitals.Items[0].Selected := True; // results in call to reload
    end
  else
    begin
      edtTemplateName.Text := '';
      edtTemplateDescription.Text := '';
    end;
  Enabled := (Value <> nil);
  fChangesMade := False;
  GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0);    //AAN 06/11/02
end;

procedure TfraGMV_EditTemplate.lvVitalsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if fIgnore then
    exit
  else
    fIgnore := True;
  getTemplate(Selected,Item.Caption,TGMV_TemplateVital(Item.Data));
  fIgnore := False;
end;

end.

