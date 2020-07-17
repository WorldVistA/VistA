unit fTemplateAutoGen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, ORFn, fBase508Form, VA508AccessibilityManager;

type
  TfrmTemplateAutoGen = class(TfrmBase508Form)
    rgSource: TKeyClickRadioGroup;
    cbxObjects: TORComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    lblTop: TMemo;
    cbxTitles: TORComboBox;
    lblSelect: TStaticText;
    procedure rgSourceClick(Sender: TObject);
    procedure cbxTitlesNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cbxTitlesDblClick(Sender: TObject);
    procedure cbxObjectsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTitlesDone: boolean;
    FObjectsDone: boolean;
  public
    { Public declarations }
  end;

procedure GetAutoGenText(var AName, AText: string; InList: TStringList);

implementation

uses dShared, rTemplates, uTemplates, VAUtils;

{$R *.DFM}

var
  PersObjects: TStringList;

const
  idxTitle = 0;
  idxObject = 1;

procedure GetAutoGenText(var AName, AText: string; InList: TStringList);
var
  frmTemplateAutoGen: TfrmTemplateAutoGen;

begin
  AName := '';
  AText := '';
  PersObjects := InList;
  frmTemplateAutoGen := TfrmTemplateAutoGen.Create(Application);
  try
    ResizeAnchoredFormToFont(frmTemplateAutoGen);
    with frmTemplateAutoGen do
    begin
      ShowModal;
      if(ModalResult = mrOK) then
      begin
        if(rgSource.ItemIndex = idxTitle) then
        begin
          if(cbxTitles.ItemID <> '') then
          begin
            AName := MixedCase(cbxTitles.DisplayText[cbxTitles.ItemIndex]);
            AText := GetTitleBoilerplate(cbxTitles.ItemID);
          end;
        end
        else
        if(rgSource.ItemIndex = idxObject) then
        begin
          if(cbxObjects.Text <> '') then
          begin
            AName := cbxObjects.Text;
            AText := '|'+Piece(cbxObjects.Items[cbxObjects.ItemIndex],U,3)+'|'
          end;
        end;
      end;
    end;
  finally
    frmTemplateAutoGen.Free;
  end;
end;

procedure TfrmTemplateAutoGen.rgSourceClick(Sender: TObject);
var
  idx,i: integer;
  DoIt: boolean;

begin
  idx := rgSource.ItemIndex;
  rgSource.TabStop := (idx < 0);
  if(idx < 0) then exit;
  if(idx = idxTitle) then
  begin
    cbxTitles.Visible := TRUE;
    cbxObjects.Visible := FALSE;
    if(not FTitlesDone) then
    begin
      cbxTitles.InitLongList('');
      FTitlesDone := TRUE
    end;
    cbxTitles.SetFocus;
  end
  else
  if(idx = idxObject) then
  begin
    cbxObjects.Visible := TRUE;
    cbxTitles.Visible := FALSE;
    if(not FObjectsDone) then
    begin
      DoIt := TRUE;                                        //10/31/01 S Monson-- Added
      if (UserTemplateAccessLevel <> taEditor) then        //UserTemplateAccessLevel check and
        if PersObjects.Count > 0 then                      //PersObjects modification of the list
          begin                                            //in response to NOIS HUN-0701-22052
          DoIt := FALSE;
          for i := 0 to dmodShared.TIUObjects.Count-1 do
            if PersObjects.IndexOf(Piece(dmodShared.TIUObjects[i],U,2)) >= 0 then
              cbxObjects.Items.Add(dmodShared.TIUObjects[i]);
          end;
      if DoIt then
        FastAssign(dmodShared.TIUObjects, cbxObjects.Items);
      FObjectsDone := TRUE;
    end;
    cbxObjects.SetFocus;
  end;
end;

procedure TfrmTemplateAutoGen.cbxTitlesNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    SubSetOfBoilerplatedTitles(StartFrom, Direction, aLst);
    cbxTitles.ForDataUse(aLst);
  finally
    FreeAndNil(aLst);
  end;
end;

procedure TfrmTemplateAutoGen.cbxTitlesDblClick(Sender: TObject);
begin
  if(cbxTitles.ItemIndex >= 0) then
    ModalResult := mrOK;
end;

procedure TfrmTemplateAutoGen.cbxObjectsDblClick(Sender: TObject);
begin
  if(cbxObjects.ItemIndex >= 0) then
    ModalResult := mrOK;
end;

procedure TfrmTemplateAutoGen.FormShow(Sender: TObject);
begin
  //pre-select the first radio item
  rgSource.ItemIndex := 0;
end;

end.
