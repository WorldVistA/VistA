unit fGMV_EditUserTemplates;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 2/25/09 6:22p $
*       Developer:    ddomain.user@domain.ext/doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Interface to the template editor for general users.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSCOMMON/fGMV_EditUserTemplates.pas $
*
* $History: fGMV_EditUserTemplates.pas $
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
 * User: Zzzzzzandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
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
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 6  *****************
 * User: Zzzzzzandria Date: 10/04/02   Time: 4:50p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Version T32 
 *
 * *****************  Version 5  *****************
 * User: Zzzzzzandria Date: 6/11/02    Time: 4:48p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzpetitd Date: 6/06/02    Time: 11:14a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Roll-up to 5.0.0.27
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzpetitd Date: 4/26/02    Time: 11:33a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 4/12/02    Time: 3:39p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Done for the week
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 4/04/02    Time: 11:56a
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
  uGMV_Common,
  uGMV_Const,
  mGMV_EditTemplate, Menus;

type
  TfrmGMV_EditUserTemplates = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    fraGMV_EditTemplate1: TfraGMV_EditTemplate;
    lbxTemplates: TListBox;
    Panel2: TPanel;
    Panel3: TPanel;
    btnSaveTemplate: TButton;
    btnClose: TButton;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    btnDelete: TButton;
    btnNewTemplate: TButton;
    Panel4: TPanel;
    Panel9: TPanel;
    MainMenu1: TMainMenu;
    Vitals1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    Down1: TMenuItem;
    Up1: TMenuItem;
    File1: TMenuItem;
    A1: TMenuItem;
    Delete2: TMenuItem;
    N1: TMenuItem;
    Save1: TMenuItem;
    Close1: TMenuItem;
    procedure lbxTemplatesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveTemplateClick(Sender: TObject);
    procedure btnNewTemplateClick(Sender: TObject);
    procedure GetTemplates;
    procedure btnDeleteClick(Sender: TObject);
    procedure lbxTemplatesEnter(Sender: TObject);
    procedure lbxTemplatesExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fraGMV_EditTemplate1edtTemplateNameEnter(Sender: TObject);
    procedure fraGMV_EditTemplate1edtTemplateNameExit(Sender: TObject);
    procedure fraGMV_EditTemplate1edtTemplateDescriptionExit(
      Sender: TObject);
    procedure fraGMV_EditTemplate1edtTemplateDescriptionEnter(
      Sender: TObject);
    procedure fraGMV_EditTemplate1lvVitalsEnter(Sender: TObject);
    procedure fraGMV_EditTemplate1lvVitalsExit(Sender: TObject);
    procedure fraGMV_EditTemplate1sbtnMoveUpClick(Sender: TObject);
    procedure fraGMV_EditTemplate1sbtnAddVitalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CleanUp;
    procedure CMTemplateUpdated(var Message:TMessage); message CM_TemplateUpdated;  //AAN 06/11/02
    procedure CMTemplateRefreshed(var Message:TMessage); message CM_TemplateRefreshed;  //AAN 06/11/02
  end;

var
  frmEditUserTemplate: TfrmGMV_EditUserTemplates;

procedure EditUserTemplates;

implementation

uses uGMV_Template
, uGMV_Engine, system.UITypes;

{$R *.DFM}

procedure EditUserTemplates;
begin
  if not Assigned(frmEditUserTemplate) then
    Application.CreateForm(TfrmGMV_EditUserTemplates,frmEditUserTemplate);

  frmEditUserTemplate.GetTemplates;
  frmEditUserTemplate.ShowModal;
end;

procedure TfrmGMV_EditUserTemplates.lbxTemplatesClick(Sender: TObject);
begin
  if lbxTemplates.ItemIndex > -1 then
    if lbxTemplates.Items.Objects[lbxTemplates.ItemIndex] <> nil then
      begin
        fraGMV_EditTemplate1.Enabled := True;
        btnDelete.Enabled := True;
        fraGMV_EditTemplate1.EditTemplate :=
          TGMV_Template(lbxTemplates.Items.Objects[lbxTemplates.ItemIndex]);
        try
          if Self.Visible then
            lbxTemplates.SetFocus;
        except
        end;
      end
    else
      begin
        fraGMV_EditTemplate1.Enabled := False;
        btnDelete.Enabled := False;
        fraGMV_EditTemplate1.EditTemplate := nil;
      end;
end;

procedure TfrmGMV_EditUserTemplates.CleanUp;
var
  aTemplate:TGMV_Template;
begin
  while lbxTemplates.Items.Count > 0 do
    begin
      aTemplate := TGMV_Template(lbxTemplates.Items.Objects[0]);
      FreeAndNil(aTemplate);
      lbxTemplates.Items.Delete(0);
    end;
end;

procedure TfrmGMV_EditUserTemplates.GetTemplates;
var
  i: Integer;
  Templates: TStringList;
begin
  try
    Templates := GetTemplateListByID('USR');
    CleanUp;
    for i := 1 to Templates.Count - 1 do
      LbxTemplates.Items.AddObject(Piece(Templates[i], '^', 4),
        TGMV_Template.CreateFromXPAR(Templates[i]));
  finally
    FreeAndNil(Templates);
  end;
  if lbxTemplates.Items.Count > 0 then
    begin
      lbxTemplates.Selected[0] := True;
      lbxTemplatesClick(nil);
    end;
end;

procedure TfrmGMV_EditUserTemplates.btnCloseClick(Sender: TObject);
begin
  fraGMV_EditTemplate1.SaveTemplateIfChanged;//AAN 06/11/02
  CleanUp;
  Close;
end;

procedure TfrmGMV_EditUserTemplates.btnSaveTemplateClick(Sender: TObject);
var
  i: Integer;
begin
  i := lbxTemplates.ItemIndex;
  fraGMV_EditTemplate1.SaveTemplate;
  GetTemplates;
  lbxTemplates.ItemIndex := i;
  lbxTemplatesClick(nil);
end;

procedure TfrmGMV_EditUserTemplates.btnNewTemplateClick(Sender: TObject);
begin
  CreateNewUserTemplate;
  GetTemplates;
end;

procedure TfrmGMV_EditUserTemplates.btnDeleteClick(Sender: TObject);
var
  s: String;
begin
  if MessageDlg('Delete Template ' + lbxTemplates.Items[lbxTemplates.ItemIndex] + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      s := deleteUserTemplate(lbxTemplates.Items[lbxTemplates.ItemIndex]);
      if Piece(s, '^', 1) <> '-1' then
        begin
          fraGMV_EditTemplate1.EditTemplate := nil;
          TGMV_Template(lbxTemplates.Items.Objects[lbxTemplates.ItemIndex]).Free;
          lbxTemplates.Items.Delete(lbxTemplates.ItemIndex);
        end
      else
        MessageDlg('Unable to delete template ' + Piece(s, '^', 2, 3), mtError, [mbOk], 0);
    end;
end;

//AAN 06/11/02 ---------------------------------------------------------- Begin
procedure TfrmGMV_EditUserTemplates.CMTemplateUpdated(var Message: TMessage);
begin
  btnSaveTemplate.Enabled := True;
end;

procedure TfrmGMV_EditUserTemplates.CMTemplateRefreshed(var Message: TMessage);
begin
  btnSaveTemplate.Enabled := False;
end;
//AAN 06/11/02 ------------------------------------------------------------ End
procedure TfrmGMV_EditUserTemplates.lbxTemplatesEnter(Sender: TObject);
begin
  GroupBox1.Font.Style := [fsBold];
  lbxTemplates.Color := clInfoBk;
end;

procedure TfrmGMV_EditUserTemplates.lbxTemplatesExit(Sender: TObject);
begin
  GroupBox1.Font.Style := [];
  lbxTemplates.Color := clwindow;
end;

procedure TfrmGMV_EditUserTemplates.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1edtTemplateNameEnter(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.edtTemplateNameEnter(Sender);
  fraGMV_EditTemplate1.edtTemplateName.Color := clInfoBk;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1edtTemplateNameExit(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.edtTemplateNameExit(Sender);
  fraGMV_EditTemplate1.edtTemplateName.Color := clWindow;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1edtTemplateDescriptionExit(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.edtTemplateDescriptionExit(Sender);
  fraGMV_EditTemplate1.edtTemplateDescription.Color := clWindow;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1edtTemplateDescriptionEnter(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.edtTemplateDescriptionEnter(Sender);
  fraGMV_EditTemplate1.edtTemplateDescription.Color := clInfoBk;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1lvVitalsEnter(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.lvVitalsEnter(Sender);
  fraGMV_EditTemplate1.lvVitals.Color := clInfoBk;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1lvVitalsExit(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.lvVitalsExit(Sender);
  fraGMV_EditTemplate1.lvVitals.Color := clWindow;
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1sbtnMoveUpClick(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.acUpExecute(Sender);
end;

procedure TfrmGMV_EditUserTemplates.fraGMV_EditTemplate1sbtnAddVitalClick(
  Sender: TObject);
begin
  fraGMV_EditTemplate1.acAddExecute(Sender);
end;

end.

