unit fODAuto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, StdCtrls, ComCtrls, ExtCtrls, ORFn, ORCtrls,
  VA508AccessibilityManager;

type
  TfrmODAuto = class(TfrmODBase)
    Label1: TLabel;
  public
    procedure InitDialog; override;
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    procedure Validate(var AnErrMsg: string); override;
  end;

var
  frmODAuto: TfrmODAuto;

implementation

{$R *.DFM}

uses rODBase, rOrders, fTemplateDialog, uTemplateFields, rTemplates, uConst, uTemplates,
     rConsults, uCore, uODBase, rODMeds, fFrame;

procedure TfrmODAuto.InitDialog;
begin
  inherited;
  // nothing for now
end;

procedure TfrmODAuto.Validate(var AnErrMsg: string);
var
  cptn, tmp, DocInfo: string;
  TempSL: TStringList;
  LType: TTemplateLinkType;
  IEN: integer;
  HasObjects: boolean;

begin
  inherited;
  DocInfo := '';
  LType := DisplayGroupToLinkType(Responses.DisplayGroup);
  tmp := Responses.EValueFor('COMMENT', 1);
  ExpandOrderObjects(tmp, HasObjects);
  Responses.OrderContainsObjects := Responses.OrderContainsObjects or HasObjects;
  if (LType <> ltNone) or HasTemplateField(tmp) then
  begin
    cptn := 'Reason for Request: ' + Responses.EValueFor('ORDERABLE', 1);
    case LType of
      ltConsult:   IEN := StrToIntDef(GetServiceIEN(Responses.IValueFor('ORDERABLE', 1)),0);
      ltProcedure: IEN := StrToIntDef(GetProcedureIEN(Responses.IValueFor('ORDERABLE', 1)),0);
      else         IEN := 0;
    end;
    if IEN <> 0 then
      ExecuteTemplateOrBoilerPlate(tmp, IEN, LType, nil, cptn, DocInfo)
    else
      CheckBoilerplate4Fields(tmp, cptn);


      if WasTemplateDialogCanceled then AnErrMsg := 'The Auto-Accept Quick Order cannot be saved since the template was cancelled.';

    if tmp <> '' then
      Responses.Update('COMMENT', 1, TX_WPTYPE, tmp)
    else
    begin
      TempSL := TStringList.Create;
      try
        TempSL.Text := Responses.EValueFor('COMMENT', 1);
        Convert2LMText(TempSL);
        Responses.Update('COMMENT', 1, TX_WPTYPE, TempSL.Text);
      finally
        TempSL.Free;
      end;
    end;
  end;
end;

procedure TfrmODAuto.SetupDialog(OrderAction: Integer; const ID: string);
var
  DialogNames: TDialogNames;
  DlgOI, AnInstance, IVDsGrp: integer;
  DEAFailStr, TX_INFO: string;
  InptDlg:  Boolean;
begin
  inherited;  // Responses is already loaded here
  DEAFailStr := '';
  InptDlg := False;
  IVDsGrp := DisplayGroupByName('IV RX');
  if DisplayGroup = DisplayGroupByName('UD RX') then InptDlg := TRUE;
  if DisplayGroup = DisplayGroupByName('O RX') then InptDlg := FALSE;
  if DisplayGroup = DisplayGroupByName('NV RX') then InptDlg := FALSE;
  if DisplayGroup = DisplayGroupByName('RX') then InptDlg := OrderForInpatient;
  if (not Patient.Inpatient) and (DisplayGroup = IVDsGrp) then      //if auto-accept of IV med order on Outpatient (ex: from Copy to New order action)
  begin
    AnInstance := Responses.NextInstance('ORDERABLE', 0);
    while AnInstance > 0 do     //perform DEA/schedule check on all solutions before auto-accepting
      begin
        DlgOI := StrtoIntDef(Responses.IValueFor('ORDERABLE',AnInstance),0);
        DEAFailStr := DEACheckFailedForIVOnOutPatient(DlgOI,'S');
        while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
          begin
            case StrToIntDef(Piece(DEAFailStr,U,1),0) of
              1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
              2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
              3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
              4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
              5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
              6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
            end;
            if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
              begin
                InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                AbortOrder := True;
                Exit;
              end;
            if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
              begin
                DEAContext := True;
                fFrame.frmFrame.mnuFileEncounterClick(self);
                DEAFailStr := '';
                DEAFailStr := DEACheckFailedForIVOnOutPatient(DlgOI,'S');
              end
            else
              begin
                AbortOrder := True;
                Exit;
              end;
          end;
        AnInstance := Responses.NextInstance('ORDERABLE', AnInstance);
      end;
    AnInstance := Responses.NextInstance('ADDITIVE', 0);
    while AnInstance > 0 do     //perform DEA/schedule check on all additives before auto-accepting
      begin
        DlgOI := StrtoIntDef(Responses.IValueFor('ADDITIVE',AnInstance),0);
        DEAFailStr := DEACheckFailedForIVOnOutPatient(DlgOI,'A');
        while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
          begin
            case StrToIntDef(Piece(DEAFailStr,U,1),0) of
              1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
              2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
              3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
              4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
              5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
              6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
            end;
            if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
              begin
                InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                AbortOrder := True;
                Exit;
              end;
            if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
              begin
                DEAContext := True;
                fFrame.frmFrame.mnuFileEncounterClick(self);
                DEAFailStr := '';
                DEAFailStr := DEACheckFailedForIVOnOutPatient(DlgOI,'A');
              end
            else
              begin
                AbortOrder := True;
                Exit;
              end;
          end;
        AnInstance := Responses.NextInstance('ADDITIVE', AnInstance);
      end;
  end
  else if DisplayGroup <> IVDsGrp then
  begin          //if auto-accept of unit dose, NON-VA, or Outpatient meds
    DlgOI := StrtoIntDef(Responses.IValueFor('ORDERABLE',1),0);
    DEAFailStr := DEACheckFailed(DlgOI,InptDlg);
    while StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..6] do
      begin
        case StrToIntDef(Piece(DEAFailStr,U,1),0) of
          1:  TX_INFO := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
          2:  TX_INFO := TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
          3:  TX_INFO := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
          4:  TX_INFO := TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
          5:  TX_INFO := TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
          6:  TX_INFO := TX_SCH_ONE;  //schedule 1's are prohibited from electronic prescription
        end;
        if StrToIntDef(Piece(DEAFailStr,U,1),0)=6 then
          begin
            InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
            AbortOrder := True;
            Exit;
          end;
        if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
          begin
            DEAContext := True;
            fFrame.frmFrame.mnuFileEncounterClick(self);
            DEAFailStr := '';
            DEAFailStr := DEACheckFailed(DlgOI,InptDlg);
          end
        else
          begin
            AbortOrder := True;
            Exit;
          end;
      end;  //end while
  end;  //end else
  AutoAccept := True;
  StatusText('Loading Dialog Definition');
  FillerID := FillerIDForDialog(DialogIEN);
  IdentifyDialog(DialogNames, DialogIEN);
  Responses.Dialog := DialogNames.BaseName;                      // loads formatting info
  Responses.DialogDisplayName := DialogNames.Display;
  StatusText('');
end;

end.
