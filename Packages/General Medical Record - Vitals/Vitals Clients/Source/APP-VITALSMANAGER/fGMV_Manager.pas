unit fGMV_Manager;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/16/09 10:06a $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Main form for Vitals Manager applications
*
*       Notes:
*
================================================================================
*       $ Archive: /Vitals GUI 2007/Vitals-5-0-18/APP-VITALSMANAGER/fGMV_Manager.pas $
*
*       $ History: fGMV_Manager.pas $
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
  ComCtrls,
  uGMV_Common,
  ImgList,
  Menus,
  ActnList,
  ToolWin,
  ShellAPI,
  mGMV_EditTemplate,
  ExtCtrls,
  CheckLst,
  Buttons,
  mGMV_VitalHiLo,
  mGMV_SystemParameters
  , uGMV_Template, uROR_Contextor, AppEvnts, System.Actions,WinHelpViewer,
  System.ImageList
  ;

type
  TfrmGMV_Manager = class(TForm)
    tv: TTreeView;
    tbar: TToolBar;
    tbtnNew: TToolButton;
    tbtnDelete: TToolButton;
    actions: TActionList;
    sb: TStatusBar;
    MainMenu1: TMainMenu;
    mnFile: TMenuItem;
    actFileNewTemplate: TAction;
    actFileDeleteTemplate: TAction;
    mnTemplateNew: TMenuItem;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    mnFileExit: TMenuItem;
    actFileExit: TAction;
    tbtnMakeDefault: TToolButton;
    ToolButton4: TToolButton;
    actFileMakeDefault: TAction;
    tbtnSave: TToolButton;
    actFileSaveTemplate: TAction;
    mnTemplateSave: TMenuItem;
    mnTemplateDelete: TMenuItem;
    mnTemplateSetAsDefault: TMenuItem;
    pgctrl: TPageControl;
    tbshtBlank: TTabSheet;
    tbshtTemplate: TTabSheet;
    tbshtVitals: TTabSheet;
    tbshtVitalsHiLo: TTabSheet;
    fraLowValue: TfraVitalHiLo;
    fraHighValue: TfraVitalHiLo;
    mnTemplates: TMenuItem;
    mnHelp: TMenuItem;
    N2: TMenuItem;
    mnHelpAbout: TMenuItem;
    mnHelpIndex: TMenuItem;
    pnlCategories: TPanel;
    Panel3: TPanel;
    pnlQualifiers: TPanel;
    Panel6: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    clbxQualifiers: TCheckListBox;
    Panel8: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    tbtnNewQualifier: TToolButton;
    tbtnEditQualifier: TToolButton;
    actQualifierNew: TAction;
    actQualifierEdit: TAction;
    mnQual: TMenuItem;
    mnQualNew: TMenuItem;
    mnQualEdit: TMenuItem;
    ToolButton1: TToolButton;
    tbtnHelp: TToolButton;
    actHelpIndex: TAction;
    actHelpContents: TAction;
    mnHelpContents: TMenuItem;
    tbtnPrint: TToolButton;
    actPrint: TAction;
    N1: TMenuItem;
    mnFilePrint: TMenuItem;
    Label3: TLabel;
    ToolButton3: TToolButton;
    Label4: TLabel;
    ToolButton5: TToolButton;
    tbtnSaveAbnormal: TToolButton;
    actAbnormalSave: TAction;
    mnAbnormal: TMenuItem;
    mnAbnormalSave: TMenuItem;
    fraGMV_EditTemplate1: TfraGMV_EditTemplate;
    tbshtSystemParameters: TTabSheet;
    Label5: TLabel;
    ToolButton2: TToolButton;
    tbtnSaveParameters: TToolButton;
    actSaveParameters: TAction;
    msSystemParameters: TMenuItem;
    mnSystemParametersSave: TMenuItem;
    actWebLink: TAction;
    VitalsWebsite1: TMenuItem;
    fraSystemParameters: TfraSystemParameters;
    lvCategories: TListView;
    CCRContextor: TCCRContextor;
    acQuailfiers: TAction;
    Qualifiers1: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    Panel1: TPanel;
    acLog: TAction;
    ShowLog1: TMenuItem;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tvCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tvEdited(Sender: TObject; Node: TTreeNode; var s: string);
    procedure actFileNewTemplateExecute(Sender: TObject);
    procedure actFileDeleteTemplateExecute(Sender: TObject);
    procedure actFileExitExecute(Sender: TObject);
    procedure actFileMakeDefaultExecute(Sender: TObject);
    procedure actFileSaveTemplateExecute(Sender: TObject);
    procedure tbshtVitalsHiLoResize(Sender: TObject);
    procedure mnHelpAboutClick(Sender: TObject);
    procedure clbxQualifiersClickCheck(Sender: TObject);
    procedure sbResize(Sender: TObject);
    procedure actQualifierNewExecute(Sender: TObject);
    procedure actQualifierEditExecute(Sender: TObject);
    procedure clbxQualifiersExit(Sender: TObject);
    procedure clbxQualifiersClick(Sender: TObject);
    procedure actHelpIndexExecute(Sender: TObject);
    procedure actHelpContentsExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actAbnormalSaveExecute(Sender: TObject);
    procedure actSaveParametersExecute(Sender: TObject);
    procedure actWebLinkExecute(Sender: TObject);
    procedure lvCategoriesClick(Sender: TObject);
    procedure lvCategoriesResize(Sender: TObject);
    procedure lvCategoriesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CCRContextorCommitted(Sender: TObject);
    procedure acQuailfiersExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acLogExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function ApplicationEventsHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
    FAbnormalRoot: TTreeNode;
    FParamRoot: TTreeNode;
    FVitalsRoot: TTreeNode;
    FTmpltRoot: TTreeNode;
    FTmpltDomainRoot: TTreeNode;
    FTmpltInstitutionRoot: TTreeNode;
    FTmpltHopsitalLocationRoot: TTreeNode;
    FTmpltNewPersonRoot: TTreeNode;

    { The fEditCount variable (see also the EditCount property) stores number of
      open modal forms that prevent the patient context from changing.  A counter
      instead of a boolean variable is required to handle nested modal forms.
      See the StartPatientEdit and EndPatientEdit procedures for more details. }
    fEditCount:  Integer;

    procedure LoadTreeView;
    procedure InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
    function QualDisplayList:String;//AAN 07/18/2002

    procedure CloseOtherForms(Force: Boolean);
  public

    { Public declarations }
    function RestoreConnection: Boolean;
    procedure RestoreSettings;
    procedure Disconnect;
    property EditCount: Integer read fEditCount;
  end;

var
  frmGMV_Manager: TfrmGMV_Manager;

implementation

uses
  fGMV_NewTemplate,
  fGMV_AboutDlg,
  fGMV_AddVCQ,
  fGMV_AddEditQualifier,
  fGMV_DeviceSelector,
  uGMV_GlobalVars, fGMV_Qualifiers, uGMV_User,
  uGMV_Const, uGMV_VitalTypes, uGMV_FileEntry
  , fROR_PCall
  , uGMV_Engine, uROR_RPCBroker, uGMV_RPC_Names, fGMV_RPCLog, system.UITypes, U_HelpMgr;

{$R *.DFM}
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_Manager.CCRContextorCommitted(Sender: TObject);
begin
  if Assigned(RPCBroker) then
    { Perform the checks required by the single sign-on/sign-off. }
    if RPCBroker.WasUserDefined and RPCBroker.IsUserCleared then
      begin
        { Force closure of all modal dialogs and message boxes }
        CloseOtherForms(True);
        { Terminate the application }
        Application.Terminate;
      end;
end;

procedure TfrmGMV_Manager.CloseOtherForms(Force: Boolean);
var
  i: Integer;
begin
  { Close the forms only if there are modal dialogs and/or message boxes that
    block the patient context change or if the "forced" action is requested. }
  if (EditCount > 0) or Force then
    begin
      for i:=1 to Screen.CustomFormCount do
        begin
          { Close all modal dialogs and message boxes that are displayed
            over the this window (main application window). }
          if Screen.CustomForms[i-1] = Self then
            Break;
          if fsModal in Screen.CustomForms[i-1].FormState then
            Screen.CustomForms[i-1].Close;
        end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_Manager.Disconnect;
begin
  if Assigned(RPCBroker) then
    begin
      Hide;
      { Disconnect and destroy the RPC Broker }
      RPCBroker.Connected := False;
      FreeAndNil(RPCBroker);
    end;
end;

procedure TfrmGMV_Manager.FormCreate(Sender: TObject);
begin
  tbshtBlank.TabVisible := False;
  { Try to start the underlaying contextor and connect to the vault. If the
    Sentillion contextor is not installed on the users workstation or the vault
    is not available then the TCCRContextor will switch to idle mode and all
    requests will be ignored. }
  ccrContextor.Run;
{$IFDEF SHOWLOG}
  Timer.Enabled := True;
  ShowLog1.Visible := True;
{$ELSE}
  ShowLog1.Visible := False;
  Timer1.Enabled := False;
{$ENDIF}
end;

function TfrmGMV_Manager.RestoreConnection:Boolean;
begin
  if Assigned(RPCBroker) then Disconnect;
{$IFNDEF V5021} // v. 5.0.2.1: GMV*5*7 has no CCOW support, has CASMed
  if not CmdLineSwitch(['/noccow','/NOCCOW']) then
    RPCBroker := SelectBroker(RPC_CREATECONTEXT, ccrContextor.Contextor)
  else
{$ENDIF}
    // v.5.0.2.1 does not support CCOW
    RPCBroker := SelectBroker(RPC_CREATECONTEXT, nil);

  Result := RPCBroker <> nil;
  if Result then // zzzzzzandia 2007-07-18
    GMVUser := TGMV_User.Create;
end;

procedure TfrmGMV_Manager.RestoreSettings;
var
  i: integer;
begin
  Font := Screen.MenuFont;

  for i := 0 to pgctrl.PageCount - 1 do
    TTabSheet(pgctrl.Pages[i]).TabVisible := False;

  pgctrl.ActivePage := tbshtBlank;
  tv.Enabled := False;
  tv.Items.Clear;
  tv.ShowRoot := False;
  with tv.Items.Add(nil, 'Loading, please wait...') do
    begin
      ImageIndex := -1;
      selectedIndex := -1;
      Selected := False;
    end;
  Show;
  Application.ProcessMessages;
  LoadTreeView;
  tv.Enabled := True;
  for i := 0 to GMVQuals.Entries.Count - 1 do
    //AAN 07/18/2002: We should show Qualifier names as they are kept in DB
    clbxQualifiers.Items.AddObject({TitleCase}(GMVQuals.Entries[i]), GMVQuals.Entries.Objects[i]);
  clbxQualifiers.Enabled := False;
  Caption := 'Vitals Management. User: '+ GMVUser.Name + '  (' + GMVUser.Title +') Division: '+ GMVUser.Division;
  lvCategoriesResize(nil);
  sb.SimplePanel := true;

//{$IFDEF GMRV*5*8}  //HDR
  actQualifierNew.Enabled := False;
  actQualifierEdit.Enabled := False;
//{$ENDIF}
end;

procedure TfrmGMV_Manager.LoadTreeView;
var
  tmpList: TStringList;
  i: integer;
begin
  tv.Enabled := False;
  tv.Items.BeginUpdate;
  tv.ShowRoot := True;
  with tv.items do
    begin
      Clear;
      FParamRoot := Add(nil, 'System Parameters');
      FParamRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FParamRoot.SelectedIndex := GMVIMAGES[iiFolderOpen];

      FAbnormalRoot := Add(nil, 'Abnormal Values');
      FAbnormalRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FAbnormalRoot.SelectedIndex := GMVIMAGES[iiFolderClosed];

      FVitalsRoot := Add(nil, 'Vitals');
      FVitalsRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FVitalsRoot.SelectedIndex := GMVIMAGES[iiFolderClosed];

      FTmpltRoot := Add(nil, 'Templates');
      FTmpltRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FTmpltRoot.SelectedIndex := GMVIMAGES[iiFolderClosed];

      FTmpltDomainRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teDomain]);
      FTmpltDomainRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FTmpltDomainRoot.SelectedIndex := GMVIMAGES[iiFolderClosed];

      FTmpltInstitutionRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teInstitution]);
      FTmpltInstitutionRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FTmpltInstitutionRoot.SelectedIndex := GMVIMAGES[iiFolderOpen];

      FTmpltHopsitalLocationRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teHospitalLocation]);
      FTmpltHopsitalLocationRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FTmpltHopsitalLocationRoot.SelectedIndex := GMVIMAGES[iiFolderOpen];

      FTmpltNewPersonRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teNewPerson]);
      FTmpltNewPersonRoot.ImageIndex := GMVIMAGES[iiFolderClosed];
      FTmpltNewPersonRoot.SelectedIndex := GMVIMAGES[iiFolderOpen];
    end;

  with tv.Items.AddChildObject(FAbnormalRoot, 'Blood Pressure - Systolic', TGMV_VitalHiLoDefinition.Create(hltSystolic, 0, 300, 10)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

  with tv.Items.AddChildObject(FAbnormalRoot, 'Blood Pressure - Diastolic', TGMV_VitalHiLoDefinition.Create(hltDiastolic, 0, 300, 10)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

  with tv.Items.AddChildObject(FAbnormalRoot, 'Temperature', TGMV_VitalHiLoDefinition.Create(hltTemperature, 45, 120, 5)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

  with tv.Items.AddChildObject(FAbnormalRoot, 'Respiration', TGMV_VitalHiLoDefinition.Create(hltRespiration, 0, 100, 5)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

  with tv.Items.AddChildObject(FAbnormalRoot, 'Pulse', TGMV_VitalHiLoDefinition.Create(hltPulse, 0, 300, 10)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

  with tv.Items.AddChildObject(FAbnormalRoot, 'CVP', TGMV_VitalHiLoDefinition.Create(hltCVP, -13, 136, 10)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

// AAN 2003/06/03 -- label is changed
//  with tv.Items.AddChildObject(FAbnormalRoot, 'O2 Sat', TGMV_VitalHiLoDefinition.Create(hltO2Sat, 0, 100, 10)) do
  with tv.Items.AddChildObject(FAbnormalRoot, 'Pulse Oximetry', TGMV_VitalHiLoDefinition.Create(hltO2Sat, 0, 100, 10)) do
    begin
      ImageIndex := GMVIMAGES[iiAbnormal];
      SelectedIndex := GMVIMAGES[iiAbnormal];
    end;

  for i := 0 to GMVTypes.Entries.Count - 1 do
    with tv.Items.AddChild(FVitalsRoot, {TitleCase}(GMVTypes.Entries[i])) do
      begin
        ImageIndex := GMVIMAGES[iiVital];
        SelectedIndex := GMVIMAGES[iiVital];
        Data := GMVTypes.Entries.Objects[i];
      end;

  try
    tmpList := getTemplateList; // zzzzzzandria 05-01-13
    for i := 1 to tmpList.Count - 1 do
      InsertTemplate(TGMV_Template.CreateFromXPAR(tmpList[i]));
  finally
    FreeAndNil(tmpList);
  end;

  tv.AlphaSort;
  tv.Enabled := True;
  tv.Items.EndUpdate;
  Refresh;
end;

procedure TfrmGMV_Manager.InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
var
  TypeRoot: TTreeNode;
  oRoot: TTreeNode;
  NewNode: TTreeNode;

  function OwnerRoot: TTreeNode;
  begin
    Result := nil;
    oRoot := TypeRoot.getFirstChild;
    while oRoot <> nil do
      begin
        if TGMV_TemplateOwner(oRoot.Data).Entity = Template.Entity then
          begin
            Result := oRoot;
            exit;
          end
        else
          oRoot := TypeRoot.GetNextChild(oRoot);
      end;

    if oRoot = nil then
      begin
        if Template.EntityType = teNewPerson then
          Result := tv.Items.AddChildObject(TypeRoot, {TitleCase}(Template.Owner.OwnerName), Template.Owner)
        else
          Result := tv.Items.AddChildObject(TypeRoot, Template.Owner.OwnerName, Template.Owner);
        Result.ImageIndex := GMVIMAGES[iiFolderClosed];
        Result.SelectedIndex := GMVImages[iiFolderClosed];
      end;
  end;

begin
  case Template.EntityType of
    teUnknown: Exit; // TypeRoot := nil; //AAN 08/02/2002
    teDomain: TypeRoot := FTmpltDomainRoot;
    teInstitution: TypeRoot := FTmpltInstitutionRoot;
    teHospitalLocation: TypeRoot := FTmpltHopsitalLocationRoot;
    teNewPerson: TypeRoot := FTmpltNewPersonRoot;
  end;

  try   //AAN 08/02/2002
    NewNode := tv.Items.AddChildObject(OwnerRoot, Template.TemplateName, Template);
    if GMVDefaultTemplates.IsDefault(Template.Entity, Template.TemplateName) then
      begin
        NewNode.ImageIndex := GMVIMAGES[iiDefaultTemplate];
        NewNode.SelectedIndex := GMVIMAGES[iiDefaultTemplate];
      end
    else
      begin
        NewNode.ImageIndex := GMVIMAGES[iiTemplate];
        NewNode.SelectedIndex := GMVIMAGES[iiTemplate];
      end;
    if GoToTemplate then
      begin
        NewNode.Selected := True;
//        tv.SetFocus; zzzzzzandria 20090304
      end;
  except
    on E: Exception do
      MessageDlg(E.Message,mtWarning,[mbOK],0);
  end;

end;

procedure TfrmGMV_Manager.tvCollapsed(Sender: TObject; Node: TTreeNode);
begin
  Node.ImageIndex := GMVIMAGES[iiFolderClosed];
  Node.SelectedIndex := GMVIMAGES[iiFolderClosed];
end;

procedure TfrmGMV_Manager.tvExpanded(Sender: TObject; Node: TTreeNode);
begin
  Node.ImageIndex := GMVIMAGES[iiFolderOpen];
  Node.SelectedIndex := GMVIMAGES[iiFolderOpen];
end;

procedure TfrmGMV_Manager.tvChange(Sender: TObject; Node: TTreeNode);
var
  SL: TStringList;
  li:TListItem;
  i, j: integer;
begin
  pgctrl.ActivePage := tbshtBlank;
  actFileSaveTemplate.Enabled := False;
  actFileDeleteTemplate.Enabled := False;
  actFileMakeDefault.Enabled := False;
  actAbnormalSave.Enabled := False;
  actSaveParameters.Enabled := False;

  fraGMV_EditTemplate1.acUp.Enabled := False;
  fraGMV_EditTemplate1.acDown.Enabled := False;

  if Node.Data <> nil then
    begin
      if (TObject(Node.Data) is TGMV_Template) then
        begin
          fraGMV_EditTemplate1.acUp.Enabled := True;
          fraGMV_EditTemplate1.acDown.Enabled := True;
          pgctrl.ActivePage := tbshtTemplate;
          fraGMV_EditTemplate1.EditTemplate := TGMV_Template(Node.Data);
        end
      else if (TObject(Node.Data) is TGMV_FileEntry) then
        begin
          for i := 0 to clbxQualifiers.Items.Count - 1 do
            clbxQualifiers.Checked[i] := False;
          clbxQualifiers.ItemIndex := -1;
          clbxQualifiers.Enabled := False;

          lvCategories.Items.Clear;//AAN 07/15/2002

          SL := getCategoryQualifiers(TGMV_FileEntry(Node.Data).IEN);
          for i := 1 to SL.Count - 1 do
            begin
              j := GMVCats.IndexOfIEN(Piece(SL[i], '^', 1));
              if j > - 1 then
                begin
                  li := lvCategories.Items.Add;
                  li.Caption := {TitleCase}(GMVCats.Entries[j]);
                  li.SubItems.Add(TGMV_FileEntry(GMVCats.Entries.Objects[j]).IEN);
                  li.SubItems.Add('[' + {TitleCase}(Piece(SL[i], '^', 3)) + ']');
                end;
            end;
          SL.Free;

          pgctrl.ActivePage := tbshtVitals;
        end
      else if (TObject(Node.Data) is TGMV_VitalHiLoDefinition) then
        with TGMV_VitalHiLoDefinition(Node.Data) do
          begin
            case VitalType of
              hltO2Sat:
                fraLowValue.SetUpFrame(VitalType, hlLow, Minimum, Maximum, Increment)
            else
              begin
                fraLowValue.SetUpFrame(VitalType, hlLow, Minimum, Maximum, Increment);
                fraHighValue.SetUpFrame(VitalType, hlHigh, Minimum, Maximum, Increment);
              end;
            end;
            fraHighValue.Visible := (VitalType <> hltO2Sat);
            pgctrl.ActivePage := tbshtVitalsHiLo;
          end
      else
        pgctrl.ActivePage := tbshtBlank;

      actFileSaveTemplate.Enabled := (TObject(Node.Data) is TGMV_Template);
      actFileDeleteTemplate.Enabled := (TObject(Node.Data) is TGMV_Template);
      actFileMakeDefault.Enabled := (TObject(Node.Data) is TGMV_Template);
      actAbnormalSave.Enabled := (TObject(Node.Data) is TGMV_VitalHiLoDefinition);
    end
  else if Node = FParamRoot then
    begin
      fraSystemParameters.LoadParameters;
      actSaveParameters.Enabled := True;
      pgctrl.ActivePage := tbshtSystemParameters;
    end;
end;

procedure TfrmGMV_Manager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmGMV_Manager.tvEdited(Sender: TObject; Node: TTreeNode; var s: string);
var
  SS:String;
begin
  if TObject(Node.Data) is TGMV_Template then
    with TGMV_Template(Node.Data) do
      begin
        SS := renameTemplate(Entity,Node.Text,s);
        if Piece(ss, '^', 1) = '-1' then
          begin
            s := Node.Text;
            MessageDlg('Error Renaming Parameter: ' + Piece(ss, '^', 2, 3), mtError, [mbok], 0);
          end;
      end
  else
    MessageDlg('Sorry, You may not rename this item', mtInformation, [mbok], 0);
end;

procedure TfrmGMV_Manager.actFileNewTemplateExecute(Sender: TObject);
var
  NewTemplate: TGMV_Template;
begin
  NewTemplate := CreateNewTemplate;
  if NewTemplate <> nil then
    begin
      InsertTemplate(NewTemplate, True);
      tv.AlphaSort;
    end;
end;

procedure TfrmGMV_Manager.actFileDeleteTemplateExecute(Sender: TObject);
var
  s:String;
begin
  if tv.Selected <> nil then
    if tv.Selected.Data <> nil then
      if TObject(tv.Selected.Data) is TGMV_Template then
        if MessageDlg('Are you sure you want to delete template ''' + tv.Selected.Text + '''?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
          with TGMV_Template(tv.Selected.Data) do
            begin
              s := deleteTemplate(Entity,TemplateName);
              if Piece(s, '^', 1) <> '-1' then
                begin
                  TGMV_Template(tv.Selected.Data).Free;
                  tv.Items.Delete(tv.Selected);
                end
              else
                MessageDlg('Unable to delete template ' + Piece(s, '^', 2, 3), mtError, [mbOk], 0);
            end;
end;

procedure TfrmGMV_Manager.actFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmGMV_Manager.actFileMakeDefaultExecute(Sender: TObject);
var
  ParentNode: TTreeNode;
  SiblingNode: TTreeNode;
begin
  ParentNode := tv.Selected.Parent;
  with TGMV_Template(tv.Selected.Data) do
    if SetAsDefault then
      begin
        SiblingNode := ParentNode.getFirstChild;
        while SiblingNode <> nil do
          begin
            SiblingNode.ImageIndex := GMVIMAGES[iiTemplate];
            SiblingNode.SelectedIndex := GMVIMAGES[iiTemplate];
            SiblingNode := ParentNode.GetNextChild(SiblingNode);
          end;
        tv.Selected.ImageIndex := GMVIMAGES[iiDefaultTemplate];
        tv.Selected.SelectedIndex := GMVIMAGES[iiDefaultTemplate];
      end
    else
      MessageDlg('Error setting default Template', mtError, [mbok], 0);
end;

procedure TfrmGMV_Manager.actFileSaveTemplateExecute(Sender: TObject);
begin
  fraGMV_EditTemplate1.SaveTemplate;
  tv.Selected.Text := TGMV_Template(tv.Selected.Data).TemplateName;
end;

procedure TfrmGMV_Manager.actPrintExecute(Sender: TObject);
var
  x: string;
  y: Double;
begin
  if GetKernelDevice(x, y) then
    begin
      x := printQualifierTable(X,FloatToStr(y));
      if Piece(x, '^', 1) = '-1' then
        MessageDlg(Piece(x, '^', 2), mtError, [mbOk], 0)
      else
        MessageDlg(Piece(x, '^', 2), mtInformation, [mbOk], 0);
    end
  else
    MessageDlg('Report cancelled by user.', mtInformation, [mbOk], 0);
end;

procedure TfrmGMV_Manager.clbxQualifiersExit(Sender: TObject);
begin
  actQualifierEdit.Enabled := False;
end;

procedure TfrmGMV_Manager.actQualifierNewExecute(Sender: TObject);
var
  NewQual: TGMV_FileEntry;
begin
  // zzzzzzandria 050722
  acQuailfiersExecute(nil);
  Exit;

  NewQual := NewQualifier;
  if NewQual <> nil then
    clbxQualifiers.Items.AddObject({TitleCase}(NewQual.Caption), NewQual);
end;

procedure TfrmGMV_Manager.actQualifierEditExecute(Sender: TObject);
begin
  // zzzzzzandria 050722
  acQuailfiersExecute(nil);
  Exit;

  if MessageDlg(
    'This option is only to be used to correct miss-spellings' + #13 +
    'and/or editing of abbreviations.  Changing the name' + #13 +
    'of a qualifier will change that qualifier on every Vitals' + #13 +
    'Record on the system, thus changing the permanent' + #13 +
    'record with no audits to revert the data back to it''s' + #13 +
    'original form.' + #13 + #13 +
    'Do you want to proceed changes?',
    mtWarning, [mbYes,  mbCancel], 0) = mrYes then
    begin
      EditQualifier(
        TGMV_FileEntry(clbxQualifiers.Items.Objects[clbxQualifiers.ItemIndex]));
      clbxQualifiers.Items[clbxQualifiers.ItemIndex] :=
        TGMV_FileEntry(clbxQualifiers.Items.Objects[clbxQualifiers.ItemIndex]).Caption;//AAN 07/18/2002
      lvCategories.ItemFocused.SubItems[1] := '[' + QualDisplayList + ']';//AAN 07/18/2002
    end;
end;

procedure TfrmGMV_Manager.actHelpIndexExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_INDEX, 0);
end;

procedure TfrmGMV_Manager.actHelpContentsExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 1);
end;

procedure TfrmGMV_Manager.tbshtVitalsHiLoResize(Sender: TObject);
begin
  fraLowValue.Width := (tbshtVitalsHiLo.Width - (tbshtVitalsHiLo.BorderWidth * 4)) div 2;
  fraHighValue.Width := (tbshtVitalsHiLo.Width - (tbshtVitalsHiLo.BorderWidth * 4)) div 2;
end;

procedure TfrmGMV_Manager.mnHelpAboutClick(Sender: TObject);
begin
  GMVAboutDlg.Execute;
end;

//AAN 07/18/2002 --------------------------------------------------------- Begin
function TfrmGMV_Manager.QualDisplayList:String;
var
  i: Integer;
  s: String;
begin
  result := '';
  s := '';
  for i := 0 to clbxQualifiers.Items.Count - 1 do
    if clbxQualifiers.Checked[i] then
      begin
        if s <> '' then
          s := s + ', ';
        s := s + clbxQualifiers.Items[i];
      end;
  result := s;
end;
//AAN 07/18/2002 ----------------------------------------------------------- End

procedure TfrmGMV_Manager.clbxQualifiersClickCheck(Sender: TObject);
var
  i: integer;
  VitalIEN: string;
  CategoryIEN: string;
  QualifierIEN: string;
begin
{$IFDEF DISABLEQUALIFIERS}
   Exit;
{$ENDIF}


{$IFDEF GMV*5*8}
  actQualifierEdit.Enabled := False;
{$ELSE}
  actQualifierEdit.Enabled := True;
{$ENDIF}

  VitalIEN := TGMV_FileEntry(tv.Selected.Data).IEN;

  CategoryIEN := lvCategories.ItemFocused.SubItems[0];
  QualifierIEN := TGMV_FileEntry(clbxQualifiers.Items.Objects[clbxQualifiers.ItemIndex]).IEN;

  i := clbxQualifiers.ItemIndex;
  if clbxQualifiers.Checked[i] then
     addQualifier(VitalIEN,CategoryIEN,QualifierIEN)
  else
     delQualifier(VitalIEN,CategoryIEN,QualifierIEN);
  lvCategories.ItemFocused.SubItems[1] := '[' + QualDisplayList + ']';
end;

procedure TfrmGMV_Manager.sbResize(Sender: TObject);
begin
  sb.Panels[0].Width := Trunc(sb.Width * 0.5);
  sb.Panels[1].Width := sb.Width - sb.Panels[0].Width;
end;

procedure TfrmGMV_Manager.clbxQualifiersClick(Sender: TObject);
begin
  //zzzzzzandria 070222
  // Disabling the qualifier update
{$IFDEF DISABLEQUALIFIERS}
  if Sender = clbxQualifiers then
    begin
      MessageDLG(sMsgDisabledQualifiers,mtWarning,[mbOK],0);
      Exit;
    end;
{$ENDIF}
  actQualifierEdit.Enabled := (clbxQualifiers.ItemIndex <> -1);
end;

procedure TfrmGMV_Manager.actAbnormalSaveExecute(Sender: TObject);
begin
  if fraHighValue.Visible and not fraHighValue.CheckLimits then Exit;
  if fraLowValue.Visible and not fraLowValue.CheckLimits then Exit;

  if fraHighValue.Visible then
    if fraLowValue.HiLoValue < fraHighValue.HiLoValue then
      begin
        MessageDlg(
          'Your Low Value is higher than the High Value',
          mtError, [mbok], 0);
        Exit;
      end;

  fraLowValue.SaveValue;
  if fraHighValue.Visible then
    fraHighValue.SaveValue;
end;

procedure TfrmGMV_Manager.actSaveParametersExecute(Sender: TObject);
begin
  fraSystemParameters.SaveParameters;
  LoadTreeView;
end;

procedure TfrmGMV_Manager.actWebLinkExecute(Sender: TObject);
var
  S: String;
begin
  s := getWebLinkAddress;
  if s <> '' then
    ShellExecute(0, nil, PChar(S), nil, nil, SW_NORMAL)
end;

function TfrmGMV_Manager.ApplicationEventsHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
var
  s: String;
  iHelp, CrRtn: Integer;
begin
  try
    ApplicationEvents.CancelDispatch;

    CrRtn := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      if Assigned(GMVUser) then
        s := GMVUser.HelpFileDirectory
      else
        s := ExtractFileDir(Application.ExeName) + '\Help\';

      s := s + ChangeFileExt(ExtractFileName(Application.ExeName), '.hlp');
      LoadHelpFile(s);
    finally
      Screen.Cursor := CrRtn;
    end;

    if Assigned(ActiveControl) then
      iHelp := ActiveControl.HelpContext
    else
      iHelp := 1;

    if iHelp = 0 then
      iHelp := 1;

    Application.HelpSystem.ShowContextHelp(iHelp, Application.HelpFile);
    CallHelp := False;
    Result := True;
  except
    CallHelp := True;
    Result := False;
  end;
end;

procedure TfrmGMV_Manager.lvCategoriesClick(Sender: TObject);
var
  SL: TStringList;
  i: integer;
  j: integer;
  VitalIEN: string;
  CategoryIEN: string;
begin
  if lvCategories.ItemFocused <> nil then
    begin
      for i := 0 to clbxQualifiers.Items.Count - 1 do
        clbxQualifiers.Checked[i] := False;

      VitalIEN := TGMV_FileEntry(tv.Selected.Data).IEN;
      CategoryIEN := lvCategories.ItemFocused.SubItems[0];

      SL := getQualifiers(VitalIEN,CategoryIEN);
      for i := 1 to SL.Count - 1 do
        begin
          j := GMVQuals.IndexOfIEN(Piece(SL[i], '^', 1));
          if j > -1 then
            j := clbxQualifiers.Items.IndexOfObject(GMVQuals.Entries.Objects[j]);
          if j > -1 then
            begin
              clbxQualifiers.Checked[j] := True;
            end;
        end;
      SL.Free;
      clbxQualifiers.Enabled := True;
    end
  else
    clbxQualifiers.Enabled := False;
end;

procedure TfrmGMV_Manager.lvCategoriesResize(Sender: TObject);
begin
 // lvCategories.Columns[2].Width := lvCategories.Width - lvCategories.Columns[0].Width-4;
end;

procedure TfrmGMV_Manager.lvCategoriesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  lvCategoriesClick(Sender);
end;

procedure TfrmGMV_Manager.acQuailfiersExecute(Sender: TObject);
begin
  ShowMessage(sMsgDisabledQualifiers);
end;


procedure TfrmGMV_Manager.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = word(VK_F1) then
    Application.HelpCommand(HELP_CONTEXT, 0);
end;

procedure TfrmGMV_Manager.acLogExecute(Sender: TObject);
begin
{$IFDEF SHOWLOG}
  ShowRPCLog;
{$ENDIF}
end;

procedure TfrmGMV_Manager.Timer1Timer(Sender: TObject);
begin
{$IFDEF SHOWLOG}
  try
    if Assigned(ActiveControl) then
      sb.SimpleText := 'Active control: '+ActiveControl.Name
    else
      sb.SimpleText := 'Active control: Unknown';
  except
  end;
{$ENDIF}
end;

end.
