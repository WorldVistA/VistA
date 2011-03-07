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
     rConsults, uCore, uODBase;

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
begin
  inherited;  // Responses is already loaded here
  AutoAccept := True;
  StatusText('Loading Dialog Definition');
  FillerID := FillerIDForDialog(DialogIEN);
  IdentifyDialog(DialogNames, DialogIEN);
  Responses.Dialog := DialogNames.BaseName;                      // loads formatting info
  Responses.DialogDisplayName := DialogNames.Display;
  StatusText('');
end;

end.
