{*********************************************************}
{*                  O32LOBED.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

(*ChangeLog)

  8/15/01 - Disable the folder only component editor. - PB
*)

unit O32LobEd;
  {-property editor for the LookOut bar}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DesignIntf, DesignEditors, StdCtrls, OvcSpeed, OvcBase, OvcState, ExtCtrls,
  O32LkOut, O32ColEd;

type
  TO32LookoutBarEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index : Integer); override;
    function GetVerb(Index : Integer) : string; override;
    function GetVerbCount : Integer; override;
  end;

  TO32frmLkOutEd = class(TForm)
    pnlItems: TPanel;
    pnlFolders: TPanel;
    lbItems: TListBox;
    lbFolders: TListBox;
    Panel1: TPanel;
    btnItemAdd: TOvcSpeedButton;
    btnItemDelete: TOvcSpeedButton;
    btnItemUp: TOvcSpeedButton;
    btnItemDown: TOvcSpeedButton;
    Panel4: TPanel;
    Label2: TLabel;
    Panel5: TPanel;
    btnFolderAdd: TOvcSpeedButton;
    btnFolderDelete: TOvcSpeedButton;
    btnFolderUp: TOvcSpeedButton;
    btnFolderDown: TOvcSpeedButton;
    Panel6: TPanel;
    Label1: TLabel;
    pnlImages: TPanel;
    Panel8: TPanel;
    Label3: TLabel;
    lbImages: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbFoldersClick(Sender: TObject);
    procedure lbItemsMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure lbItemsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbImagesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbItemsClick(Sender: TObject);
    procedure lbImagesClick(Sender: TObject);
    procedure btnItemUpClick(Sender: TObject);
    procedure btnItemDownClick(Sender: TObject);
    procedure btnFolderUpClick(Sender: TObject);
    procedure btnFolderDownClick(Sender: TObject);
    procedure btnItemDeleteClick(Sender: TObject);
    procedure btnFolderDeleteClick(Sender: TObject);
    procedure btnFolderAddClick(Sender: TObject);
    procedure btnItemAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Bar : TO32LookOutBar;
    Designer   : IDesigner;
    procedure PopulateFolderList;
    procedure PopulateItemList;
  end;

procedure EditLookOut(Designer : IDesigner; Bar : TO32LookOutBar);

implementation

{$R *.DFM}


{*** TO32LookoutBarEditor ***}

{8/15/01 - Disable the folder only component editor. - PB}

procedure TO32LookoutBarEditor.ExecuteVerb(Index : Integer);
begin
  if Index = 0 then
    EditLookOut(Designer, (Component as TO32LookOutBar));
end;

function TO32LookoutBarEditor.GetVerb(Index : Integer) : string;
begin
  if Index = 0 then
    Result := 'Layout Tool...';
end;

function TO32LookoutBarEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


{*** TO32FrmLkOutEd ***}

procedure TO32frmLkOutEd.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;
end;

procedure TO32frmLkOutEd.FormResize(Sender: TObject);
begin
  pnlFolders.Width := (pnlItems.Width + pnlFolders.Width) div 2;
  if Bar.Images <> nil then begin
    pnlImages.Height := 25 + (5 * (Bar.Images.Height div 3));
    lbImages.Columns := lbImages.Width div Bar.Images.Width;
    {Allow for scrollbar if excessive number of images}
    if (lbImages.Width >= Bar.Images.Width) then
      pnlImages.Height := pnlImages.Height + 20;
  end;
end;

procedure TO32frmLkOutEd.PopulateItemList;
var
  I : Integer;
  S : string;
begin
  lbItems.Clear;
  if lbFolders.ItemIndex = -1 then exit;
  with Bar.Folders[lbFolders.ItemIndex] do
    for I := 0 to pred(ItemCount) do begin
      S := Items[I].Caption;
      if S = '' then
        S := Items[I].Name;
      lbItems.Items.AddObject(S,Items[i]);
    end;
end;

procedure TO32frmLkOutEd.lbFoldersClick(Sender: TObject);
begin
  PopulateItemList;
  Bar.ActiveFolder := lbFolders.ItemIndex;
end;

procedure TO32frmLkOutEd.lbItemsMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if (Bar.Images <> nil) then
    Height := Bar.Images.Height + 4;
end;

procedure TO32frmLkOutEd.lbItemsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with TListBox(Control).Canvas do
    FillRect(Rect);
  if (Bar.Images <> nil)
    and (TO32LookOutBtnItem(lbItems.Items.Objects[Index]).IconIndex > -1)
    and (TO32LookOutBtnItem(lbItems.Items.Objects[Index]).IconIndex <
      Bar.Images.Count)
  then begin
    Bar.Images.Draw(TListBox(Control).Canvas, Rect.Right - Bar.Images.Width,
      Rect.Top, TO32LookOutBtnItem(lbItems.Items.Objects[Index]).IconIndex);
    with TListBox(Control).Canvas do
      TextOut(Rect.Left + 2, Rect.Top + (Rect.Bottom - Rect.Top) div 3,
        TListBox(Control).Items[Index]);
  end else
    with TListBox(Control).Canvas do
      TextOut(Rect.Left + 2, Rect.Top, TListBox(Control).Items[Index]);
end;

procedure TO32frmLkOutEd.lbImagesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with TListBox(Control).Canvas do
    FillRect(Rect);
  if (Bar.Images <> nil) then
    Bar.Images.Draw(TListBox(Control).Canvas, Rect.Left + 1, Rect.Top + 1,
      Index);
end;

procedure TO32frmLkOutEd.lbItemsClick(Sender: TObject);
begin
  if (Bar.Images <> nil) and (lbItems.ItemIndex <> -1) then
    lbImages.ItemIndex :=
      TO32LookOutBtnItem(lbItems.Items.Objects[lbItems.ItemIndex]).IconIndex;
end;

procedure TO32frmLkOutEd.lbImagesClick(Sender: TObject);
begin
  if (lbImages.ItemIndex <> -1) and (lbItems.ItemIndex <> -1) then begin
    TO32LookOutBtnItem(lbItems.Items.Objects[lbItems.ItemIndex]).IconIndex :=
      lbImages.ItemIndex;
    lbItems.Invalidate;
    if assigned(Designer) then
      Designer.Modified;
  end;
end;

procedure TO32frmLkOutEd.btnItemUpClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (lbItems.ItemIndex > 0) then begin
    SaveItemIndex := lbItems.ItemIndex;
    with TO32LookOutBtnItem(lbItems.Items.Objects[lbItems.ItemIndex]) do begin
      Index := Index - 1;
      if Assigned(Designer) then
        Designer.Modified;
    end;
    PopulateItemList;
    lbItems.ItemIndex := SaveItemIndex - 1;
    Bar.Invalidate;
  end;
end;

procedure TO32frmLkOutEd.btnItemDownClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (lbItems.ItemIndex < lbItems.Items.Count - 1) then begin
    SaveItemIndex := lbItems.ItemIndex;
    with TO32LookOutBtnItem(lbItems.Items.Objects[lbItems.ItemIndex]) do begin
      Index := Index + 1;
      if assigned(Designer) then
        Designer.Modified;
    end;
    PopulateItemList;
    lbItems.ItemIndex := SaveItemIndex + 1;
    Bar.Invalidate;
  end;
end;

procedure TO32frmLkOutEd.PopulateFolderList;
var
  I : Integer;
  S : string;
begin
  lbFolders.Clear;
  for I := 0 to Pred(Bar.FolderCount) do begin
    S := Bar.Folders[I].Caption;
    if S = '' then
      S := Bar.Folders[I].Name;
    lbFolders.Items.AddObject(S, Bar.Folders[I]);
  end;
end;

procedure TO32frmLkOutEd.btnFolderUpClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (lbFolders.ItemIndex > 0) then begin
    SaveItemIndex := lbFolders.ItemIndex;
    with TO32LookOutBtnItem(lbFolders.Items.Objects[lbFolders.ItemIndex]) do begin
      Index := Index - 1;
      if assigned(Designer) then
        Designer.Modified;
    end;
    PopulateFolderList;
    lbFolders.ItemIndex := SaveItemIndex - 1;
    Bar.Invalidate;
  end;
end;

procedure TO32frmLkOutEd.btnFolderDownClick(Sender: TObject);
var
  SaveItemIndex : Integer;
begin
  if (lbFolders.ItemIndex < lbFolders.Items.Count - 1) then begin
    SaveItemIndex := lbFolders.ItemIndex;
    with TO32LookOutBtnItem(lbFolders.Items.Objects[lbFolders.ItemIndex]) do
    begin
      Index := Index + 1;
      if assigned(Designer) then
        Designer.Modified;
    end;
    PopulateFolderList;
    lbFolders.ItemIndex := SaveItemIndex + 1;
    Bar.Invalidate;
  end;
end;

procedure TO32frmLkOutEd.btnItemDeleteClick(Sender: TObject);
begin
  if (lbItems.ItemIndex <> -1) then begin
    TO32LookOutBtnItem(lbItems.Items.Objects[lbItems.ItemIndex]).Free;
    lbItems.ItemIndex := -1;
    PopulateItemList;
    if assigned(Designer) then
      Designer.Modified;
  end;
end;

procedure TO32frmLkOutEd.btnFolderDeleteClick(Sender: TObject);
begin
  if (lbFolders.ItemIndex <> -1) then begin
    TO32LookOutFolder(lbFolders.Items.Objects[lbFolders.ItemIndex]).Free;
    lbFolders.ItemIndex := -1;
    PopulateFolderList;
    if assigned(Designer) then
      Designer.Modified;
  end;
end;

procedure TO32frmLkOutEd.btnFolderAddClick(Sender: TObject);
begin
  Bar.FolderCollection.Add;
  PopulateFolderList;
  lbFolders.ItemIndex := lbFolders.Items.Count - 1;
  if assigned(Designer) then
    Designer.Modified;
end;

procedure TO32frmLkOutEd.btnItemAddClick(Sender: TObject);
begin
  if (lbFolders.ItemIndex <> -1) then begin
    TO32LookOutFolder(
      lbFolders.Items.Objects[lbFolders.ItemIndex]).ItemCollection.Add;
    lbItems.ItemIndex := -1;
    PopulateItemList;
    if assigned(Designer) then
      Designer.Modified;
  end;
end;

procedure EditLookOut(Designer : IDesigner; Bar : TO32LookOutBar);
var
  O32frmLkOutEd: TO32frmLkOutEd;
  i : Integer;
begin
  O32frmLkOutEd := TO32frmLkOutEd.Create(Application);
  try
    O32frmLkOutEd.Bar := Bar;
    O32frmLkOutEd.PopulateFolderList;
    O32frmLkOutEd.Designer := Designer;
    if Bar.Images <> nil then begin
      O32frmLkOutEd.lbImages.ItemHeight := Bar.Images.Height + 4;
      for i := 0 to pred(Bar.Images.Count) do
        O32frmLkOutEd.lbImages.Items.Add(IntToStr(i));
    end;
    O32frmLkOutEd.ShowModal;
  finally
    O32frmLkOutEd.Free;
  end;
end;

end.
