unit fGMV_NewTemplate;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 12/20/07 12:43p $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Create form for a new vitals input template.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER/fGMV_NewTemplate.pas $
*
* $History: fGMV_NewTemplate.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 3:13p
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:40p
 * Created in $/Vitals/VITALS-5-0-18/APP-VitalsManager
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:30p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/APP-VitalsManager
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 4:56p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsManager-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:21p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSMANAGER-503
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/26/04    Time: 1:09p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsManager
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 8/02/02    Time: 4:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Weekly backup
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:11a
 * Updated in $/Vitals GUI Version 5.0/Vitals Manager
 * Roll-up to 5.0.0.27
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 3:42p
 * Created in $/Vitals GUI Version 5.0/Vitals Manager
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
  StdCtrls,
  ExtCtrls,
//  TRPCB,
  uGMV_Common,
  mGMV_Lookup,
  uGMV_Template
  ;

type
  TfrmGMV_NewTemplate = class(TForm)
    rgTemplateType: TRadioGroup;
    edtTemplateName: TEdit;
    lblType: TLabel;
    lblName: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    edtTemplateDescription: TEdit;
    Label1: TLabel;
    fraEntityLookup: TfraGMV_Lookup;
    procedure rgTemplateTypeClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
//    FBroker: TRPCBroker;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGMV_NewTemplate: TfrmGMV_NewTemplate;

//function CreateNewTemplate(Broker: TRPCBroker): TGMV_Template;
function CreateNewTemplate: TGMV_Template;

implementation

uses uGMV_Const
//, fROR_PCall
, uGMV_Engine, system.UITypes;

{$R *.DFM}

//function CreateNewTemplate(Broker: TRPCBroker): TGMV_Template;
function CreateNewTemplate: TGMV_Template;
var
  s,ss:String;
  Entity: string;
begin
  with TfrmGMV_NewTemplate.Create(application) do
  try
    ShowModal;
//    FBroker := Broker;
    if ModalResult <> mrOK then
      Result := nil
    else
      begin
        case rgTemplateType.ItemIndex of
          0: Entity := 'SYS';
          1: Entity := fraEntityLookup.IEN + ';DIC(4,';
          2: Entity := fraEntityLookup.IEN + ';SC(';
          3: Entity := fraEntityLookup.IEN + ';VA(200,';
        end;
        s := edtTemplateDescription.Text;
        ss := edtTemplateName.Text;

//        CallREMOTEProc(Broker, RPC_MANAGER,['NEWTEMP', Entity + '^' + edtTemplateName.Text + '^' + edtTemplateDescription.Text],          nil);
//        if piece(Broker.Results[0], '^') = '-1' then
        s := NewTemplate(Entity,edtTemplateName.Text,edtTemplateDescription.Text);
        if piece(s, '^') = '-1' then
          begin
            MessageDlg('Unable to Create New Template'
//             + #13 +'Reason:'+#13+'<'+ piece(s, '^',2)+'>'
              ,
              mtError, [mbOK], 0);
            Result := nil;
          end
        else
//          Result := TGMV_Template.CreateFromXPAR(Broker.Results[0]);
          Result := TGMV_Template.CreateFromXPAR(s);
      end;
  finally
    free;
  end;
end;

procedure TfrmGMV_NewTemplate.rgTemplateTypeClick(Sender: TObject);
begin
  fraEntityLookup.Enabled := (rgTemplateType.ItemIndex > 0);
  lblType.Caption := rgTemplateType.Items[rgTemplateType.ItemIndex] + ' Name:';
  if rgTemplateType.ItemIndex > 0 then
    begin
//      fraEntityLookup.InitFrame(RPCBroker, piece('4^44^200', '^', rgTemplateType.ItemIndex));
      fraEntityLookup.InitFrame(piece('4^44^200', '^', rgTemplateType.ItemIndex));
      fraEntityLookup.Enabled := True;
    end
  else
    begin
      fraEntityLookup.edtValue.Text := 'SYSTEM';
      fraEntityLookup.Enabled := False;
    end;
end;

procedure TfrmGMV_NewTemplate.btnOKClick(Sender: TObject);
begin
  if rgTemplateType.ItemIndex < 0 then
    MessageDlg('Please select a Template Type', mtInformation, [mbok], 0)
  else if (fraEntityLookup.IEN = '') and (rgTemplateType.ItemIndex > 0) then
    MessageDlg('Please select a ' + rgTemplateType.Items[rgTemplateType.ItemIndex], mtInformation, [mbok], 0)
  else if edtTemplateName.Text = '' then
    MessageDlg('Please enter a name for this template.', mtInformation, [mbok], 0)
  else
    ModalResult := mrOK;
end;

procedure TfrmGMV_NewTemplate.FormCreate(Sender: TObject);
begin
  rgTemplateType.ItemIndex := 0;
  edtTemplateName.Text := '';
  edtTemplateDescription.Text := '';
end;

end.

