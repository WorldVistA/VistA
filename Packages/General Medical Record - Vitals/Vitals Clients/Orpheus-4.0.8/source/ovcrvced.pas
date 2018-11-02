
{$I OVC.INC}

{$I+} {Input/Output-Checking}
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

{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{$X+} {Extended Syntax}

{*********************************************************}
{*                  OvcRvCEd.PAS 4.06                    *}
{*********************************************************}

unit ovcrvced;
{component and property editors for the report view component}
interface

{$DEFINE DesignTime}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DesignIntf, DesignEditors, StdCtrls, Buttons, OvcBase, OvcEF, OvcSF,
  OvcRVIdx, OvcRptVw, OvcData, OvcCmbx, ExtCtrls, OvcLB;

type
  PTmpColumnProp = ^TTmpColumnProp;
  TTmpColumnProp = packed record
    Width         : Integer;
    PrintWidth    : Integer;
    ColTag        : Integer;
    ColumnDef     : TOvcAbstractRvField;
    GroupBy       : Boolean;
    ComputeTotals : Boolean;
    OwnerDraw     : Boolean;
    ShowHint      : Boolean;
    AllowResize   : Boolean;
    Name          : string;
    Ref           : TOvcRvViewField;
    Visible       : Boolean;
    SortDir       : Integer;
    AggExp        : string;
  end;
  TEditMode = (emBrowsing,emCreating,emCloning,emEditing);
  TRVCmpEd = class(TForm)
    edtViewTitle: TOvcSimpleField;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SListBox: TOvcListBox;
    NSListBox: TOvcListBox;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    GListBox: TOvcListBox;
    NGListBox: TOvcListBox;
    Label3: TLabel;
    Label4: TLabel;
    btnAddG: TBitBtn;
    btnAdd: TBitBtn;
    btnRemove: TBitBtn;
    btnUp: TBitBtn;
    btnDown: TBitBtn;
    btnProp: TBitBtn;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cbxName: TComboBox;
    OvcComboBox1Label1: TOvcAttachedLabel;
    btnNew: TButton;
    btnClone: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    Bevel1: TBevel;
    procedure SListBoxClick(Sender: TObject);
    procedure NSListBoxClick(Sender: TObject);
    procedure btnAddGClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure GListBoxClick(Sender: TObject);
    procedure NGListBoxClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnPropClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbxNameClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnCloneClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure GListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NGListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure GListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure NGListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnDeleteClick(Sender: TObject);
  private
  public
    OwnerView : TOvcCustomReportView;
    FilterIndex : Integer;
    FilterExp: string;
    ViewTag : Integer;
    ViewSortColumn : Integer;
    ViewSortDescending,
    ShowHeader, ShowFooter, ShowGroupTotals, ShowGroupCounts,
    Hidden,
    EditEnabled, Cloning : Boolean;
    EditMode : TEditMode;
    procedure EnableEdit(Enable : Boolean);
    procedure LoadNewView(Name : string);
    procedure ClearOldView;
  end;

type
  {property editor for the report view}
  TOvcReportViewEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : String;
      override;
    function GetVerbCount : Integer;
      override;
  end;

type
  TOvcRvActiveViewProperty = class(TPropertyEditor)
  public
    function GetAttributes : TPropertyAttributes;
      override;
    procedure GetValues(Proc : TGetStrProc);
      override;
    function GetValue : String;
      override;
    procedure SetValue(const AValue : String);
      override;
  end;

  TOvcRvFieldNameProperty = class(TPropertyEditor)
  public
    function GetAttributes : TPropertyAttributes;
      override;
    procedure GetValues(Proc : TGetStrProc);
      override;
    function GetValue : String;
      override;
    procedure SetValue(const AValue : String);
      override;
  end;

  procedure EditViews(Dsg : IDesigner; ReportView : TOvcCustomReportView);

type
  TOvcRvImgIdxProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;

    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas; var AWidth: Integer);
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas; var AHeight: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
  end;

implementation

uses
  OvcRvPEd, OVCStr;

{$R *.DFM}

procedure Select(ListBox : TOvcListBox; Sel : Boolean);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox.Items.Count) do
    ListBox.Selected[i] := Sel;
end;

function SelItem(ListBox : TOvcListBox) : Integer;
var
  i : Integer;
begin
  for i := 0 to pred(ListBox.Items.Count) do
    if ListBox.Selected[i] then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure TRVCmpEd.SListBoxClick(Sender: TObject);
begin
  if SelItem(SListBox) <> -1 then begin
    Select(NSListBox,False);
    Select(GListBox,False);
    Select(NGListBox,False);
    btnAddG.Enabled := EditEnabled;
    btnAdd.Enabled := EditEnabled;
    btnRemove.Enabled := False;
    btnUp.Enabled := False;
    btnDown.Enabled := False;
  end;
end;

procedure TRVCmpEd.NSListBoxClick(Sender: TObject);
begin
  if SelItem(NSListBox) <> -1 then begin
    Select(SListBox,False);
    Select(GListBox,False);
    Select(NGListBox,False);
    btnAddG.Enabled := False;
    btnAdd.Enabled := EditEnabled;
    btnRemove.Enabled := False;
    btnUp.Enabled := False;
    btnDown.Enabled := False;
  end;
end;

procedure TRVCmpEd.btnAddGClick(Sender: TObject);
var
  I : Integer;
  NewCol : PTmpColumnProp;
begin
  if ((OwnerView <> nil) and
      (OwnerView.CurrentView <> nil)) then begin
    if csAncestor
      in OwnerView.CurrentView.ComponentState then begin
      ShowMessage(
        'Report view is inherited component - can''t add ');
      exit;
    end;
  end;
  for i := 0 to SListBox.Items.Count - 1 do
    if SListBox.Selected[i] then begin
      New(NewCol);
      NewCol^.Width := rvDefColWidth;
      NewCol^.PrintWidth := rvDefColPrintWidth;
      NewCol^.ComputeTotals := rvDefColComputeTotals;
      NewCol^.OwnerDraw := rvDefColOwnerDraw;
      NewCol^.ShowHint := rvDefShowHint;
      NewCol^.AllowResize := True;
      NewCol^.ColTag := 0;
      NewCol^.GroupBy := True;
      NewCol^.Name := '';
      NewCol^.Ref := nil;
      NewCol^.Visible := True;
      NewCol^.SortDir := 0;
      NewCol^.AggExp := '';

      with SListBox do begin
        NewCol^.ColumnDef := TOvcAbstractRvField(Items.Objects[I]);
        GListBox.Items.AddObject(
          Items[I],
          TObject(NewCol));
      end;
    end;
end;

procedure TRVCmpEd.btnAddClick(Sender: TObject);
var
  I : Integer;
  NewCol : PTmpColumnProp;
begin
  if ((OwnerView <> nil) and
      (OwnerView.CurrentView <> nil)) then begin
    if csAncestor
      in OwnerView.ComponentState then begin
      ShowMessage(
        'Report view is inherited component - can''t add ');
      exit;
    end;
  end;
  for i := 0 to SListBox.Items.Count - 1 do
    if SListBox.Selected[i] then begin
      New(NewCol);
      NewCol^.Width := rvDefColWidth;
      NewCol^.PrintWidth := rvDefColPrintWidth;
      NewCol^.ComputeTotals := rvDefColComputeTotals;
      NewCol^.OwnerDraw := rvDefColOwnerDraw;
      NewCol^.ShowHint := rvDefShowHint;
      NewCol^.AllowResize := True;
      NewCol^.ColTag := 0;
      NewCol^.GroupBy := False;
      NewCol^.Name := '';
      NewCol^.Ref := nil;
      NewCol^.Visible := True;
      NewCol^.SortDir := 0;
      NewCol^.AggExp := '';
      with SListBox do begin
        NewCol^.ColumnDef := TOvcAbstractRvField(Items.Objects[I]);
        NGListBox.Items.AddObject(
          Items[I],
          TObject(NewCol)
          )
      end;
    end;
  for i := 0 to NSListBox.Items.Count - 1 do
    if NSListBox.Selected[i] then begin
      New(NewCol);
      NewCol^.Width := rvDefColWidth;
      NewCol^.PrintWidth := rvDefColPrintWidth;
      NewCol^.ComputeTotals := rvDefColComputeTotals;
      NewCol^.OwnerDraw := rvDefColOwnerDraw;
      NewCol^.ShowHint := rvDefShowHint;
      NewCol^.AllowResize := True;
      NewCol^.ColTag := 0;
      NewCol^.GroupBy := False;
      NewCol^.Name := '';
      NewCol^.Ref := nil;
      NewCol^.Visible := True;
      NewCol^.SortDir := 0;
      NewCol^.AggExp := '';
      with NSListBox do begin
        NewCol^.ColumnDef := TOvcAbstractRvField(Items.Objects[I]);
        NGListBox.Items.AddObject(
          Items[I],
          TObject(NewCol)
          )
      end;
    end;
end;

procedure TRVCmpEd.EnableEdit(Enable : Boolean);
begin
  if Enable then begin
    btnOk.Enabled := True;
    edtViewTitle.Enabled := True;
  end else begin
    btnAddG.Enabled := False;
    btnAdd.Enabled := False;
    btnRemove.Enabled := False;
    btnUp.Enabled := False;
    btnDown.Enabled := False;
    btnOk.Enabled := False;
    edtViewTitle.Enabled := False;
  end;
  EditEnabled := Enable;
end;

procedure TRVCmpEd.GListBoxClick(Sender: TObject);
begin
  if SelItem(GListBox) <> -1 then begin
    Select(SListBox,False);
    Select(NSListBox,False);
    Select(NGListBox,False);
    btnAddG.Enabled := False;
    btnAdd.Enabled := False;
    btnRemove.Enabled := EditEnabled;
    btnUp.Enabled := EditEnabled;
    btnDown.Enabled := EditEnabled;
  end;
end;

procedure TRVCmpEd.NGListBoxClick(Sender: TObject);
begin
  if SelItem(NGListBox) <> -1 then begin
    Select(SListBox,False);
    Select(NSListBox,False);
    Select(GListBox,False);
    btnAddG.Enabled := False;
    btnAdd.Enabled := False;
    btnRemove.Enabled := EditEnabled;
    btnUp.Enabled := EditEnabled;
    btnDown.Enabled := EditEnabled;
  end;
end;

procedure TRVCmpEd.btnRemoveClick(Sender: TObject);
var
  i : Integer;
begin
  if ((OwnerView <> nil) and
      (OwnerView.CurrentView <> nil)) then begin
    if csAncestor
      in OwnerView.CurrentView.ComponentState then begin
      ShowMessage(
        'Report view is inherited component - can''t delete');
      exit;
    end;
  end;
  if csInline
    in OwnerView.ComponentState then begin
    ShowMessage('Ancestor open - can''t delete');
    exit;
  end;
  for i := pred(GListBox.Items.Count) downto 0 do
    if GListBox.Selected[i] then
      with GListBox do begin
        Dispose(PTmpColumnProp(Items.Objects[I]));
        Items.Delete(I);
      end;
  for i := pred(NGListBox.Items.Count) downto 0 do
    if NGListBox.Selected[i] then
      with NGListBox do begin
        Dispose(PTmpColumnProp(Items.Objects[I]));
        Items.Delete(I);
      end;
  btnRemove.Enabled := False;
  btnUp.Enabled := False;
  btnDown.Enabled := False;
end;

procedure TRVCmpEd.btnUpClick(Sender: TObject);
var
  I : Integer;
begin
  if GListBox.SelCount = 1 then begin
    with GListBox do
      if SelItem(GListBox) > 0 then begin
        I := SelItem(GListBox);
        Items.Move(I,I - 1);
        Selected[I - 1] := True;
      end;
  end else
  if NGListBox.SelCount = 1 then
    with NGListBox do
      if SelItem(NGListBox) > 0 then begin
        I := SelItem(NGListBox);
        Items.Move(I,I - 1);
        Selected[I - 1] := True;
      end;
end;

procedure TRVCmpEd.btnDownClick(Sender: TObject);
var
  I : Integer;
begin
  if GListBox.SelCount = 1 then begin
    with GListBox do
      if SelItem(GListBox) < Items.Count - 1 then begin
        I := SelItem(GListBox);
        Items.Move(I,I + 1);
        Selected[I + 1] := True;
      end;
  end else
  if NGListBox.SelCount = 1 then
    with NGListBox do
      if SelItem(NGListBox) < Items.Count - 1 then begin
        I := SelItem(NGListBox);
        Items.Move(I,I + 1);
        Selected[I + 1] := True;
      end;
end;

procedure TRVCmpEd.btnPropClick(Sender: TObject);
var
  i : Integer;
begin
  with TRVCmpEd2.Create(Application) do
    try
      chkShowHeader.Checked := ShowHeader;
      chkShowFooter.Checked := ShowFooter;
      chkShowGroupTotals.Checked := ShowGroupTotals;
      chkShowGroupCounts.Checked := ShowGroupCounts;
      chkHidden.Checked := Hidden;
      edtFilterIndex.AsInteger := FilterIndex;
      edtFilterExp.Text := FilterExp;
      edtTag.AsInteger := ViewTag;
      {edtSortColumn.AsInteger := ViewSortColumn;}
      chkDescending.Checked := ViewSortDescending;
      with GListBox do
        for i := 0 to pred(Items.Count) do
          ListBox1.Items.AddObject(Items[i],Items.Objects[i]);
      with NGListBox do
        for i := 0 to pred(Items.Count) do
          ListBox1.Items.AddObject(Items[i],Items.Objects[i]);
      for i := 0 to ListBox1.Items.Count - 1 do
        if PTmpColumnProp(ListBox1.Items.Objects[i]).ColumnDef.CanSort then
          cbxDefaultSort.Items.Add(ListBox1.Items[i]);
      for i := 0 to ListBox1.Items.Count - 1 do
      with cbxDefaultSort do
        ItemIndex := Items.IndexOf(ListBox1.Items[ViewSortColumn]);
      btnOk.Enabled := EditEnabled;

      chkShowHeader.Enabled := EditEnabled;
      chkShowFooter.Enabled := EditEnabled;
      chkShowGroupTotals.Enabled := EditEnabled;
      chkTotals.Enabled := EditEnabled;
      ChkOwnerDraw.Enabled := EditEnabled;
      edtWidth.Enabled := EditEnabled;
      edtPrintWidth.Enabled := EditEnabled;
      edtFilterIndex.Enabled := EditEnabled;
      chkGroupBy.Enabled := EditEnabled;
      edtTag.Enabled := EditEnabled;
      edtColTag.Enabled := EditEnabled;
      chkShowGroupCounts.Enabled := EditEnabled;
      chkShowHint.Enabled := EditEnabled;
      chkDescending.Enabled := EditEnabled;
      chkAllowResize.Enabled := EditEnabled;
      chkHidden.Enabled := EditEnabled;
      chkVisible.Enabled := EditEnabled;
      cbxSortDir.Enabled := EditEnabled;
      edtFilterExp.Enabled := EditEnabled;
      edtAgg.Enabled := EditEnabled;
      cbxDefaultSort.Enabled := EditEnabled;

      if ShowModal = mrOK then begin
        ShowHeader := chkShowHeader.Checked;
        ShowFooter := chkShowFooter.Checked;
        ShowGroupTotals := chkShowGroupTotals.Checked;
        ShowGroupCounts := chkShowGroupCounts.Checked;
        Hidden := chkHidden.Checked;
        FilterIndex := edtFilterIndex.AsInteger;
        FilterExp := edtFilterExp.Text;
        ViewTag := edtTag.AsInteger;
        {ViewSortColumn := edtSortColumn.AsInteger;}
        ViewSortColumn := ListBox1.Items.IndexOf(cbxDefaultSort.Text);
        ViewSortDescending := chkDescending.Checked;
      end;
    finally
      free;
    end;
end;

procedure TRVCmpEd.btnOkClick(Sender: TObject);
var
  i : Integer;
begin
  if edtViewTitle.AsString = '' then
    raise Exception.Create('The view must have a title');
  if EditMode <> emEditing then
    for i := 0 to pred(OwnerView.Views.Count) do
      if OwnerView.View[i].Title = edtViewTitle.AsString then
        raise Exception.CreateFmt('A view with the title "%s" already exists',[edtViewTitle.AsString]);
  if GListBox.Items.Count + NGListBox.Items.Count = 0 then
    raise Exception.Create('View contains no columns');
  ModalResult := mrOK;
end;

function UniqueNameFromColumn(ColumnName : string; View : TOvcRVView) : string;
var
  i : Integer;
begin
  if CharInSet(ColumnName[1], ['A'..'Z','a'..'z']) then
    Result := View.Name + '_' + ColumnName[1]
  else
    Result := View.Name + '_';
  for i := 2 to length(ColumnName) do
    if CharInSet(ColumnName[i], ['A'..'Z','a'..'z','0'..'9']) then
      Result := Result + ColumnName[i]
    else
      Result := Result + '_';
  repeat
    for i := 0 to pred(View.ViewFields.Count) do
      if View.ViewField[i].Name = Result then begin
        Result := Result + '_1';
        continue;
      end;
  until True;
end;

procedure CopyColumns(ListBox : TOvcListBox; View :TOvcRVView);
var
  i : Integer;
  NewColumn : TOvcRvViewField;
begin
  for i := 0 to pred(ListBox.Items.Count) do begin
    NewColumn := TOvcRvViewField(View.ViewFields.Add);
    with PTmpColumnProp(ListBox.Items.Objects[i])^ do begin
      NewColumn.FieldName := ListBox.Items[i];
      NewColumn.Name := UniqueNameFromColumn(NewColumn.FieldName,View);
      NewColumn.ComputeTotals := ComputeTotals;
      NewColumn.GroupBy := GroupBy;
      NewColumn.OwnerDraw := OwnerDraw;
      NewColumn.ShowHint := ShowHint;
      NewColumn.AllowResize := AllowResize;
      NewColumn.PrintWidth := PrintWidth;
      NewColumn.Width := Width;
      NewColumn.Tag := ColTag;
      NewColumn.Visible := Visible;
      NewColumn.SortDirection := TOvcRvFieldSort(SortDir);
      NewColumn.Aggregate := AggExp;
    end;
  end;
end;

procedure UpdateColumns(ListBox : TOvcListBox; View :TOvcRVView;
  BaseIndex: Integer);
var
  i, j : Integer;
  ColumnToEdit : TOvcRvViewField;
begin
  for i := 0 to pred(ListBox.Items.Count) do begin
    if PTmpColumnProp(ListBox.Items.Objects[i])^.Name <> '' then
      ColumnToEdit := TOvcRvViewField(View.ViewFields.ItemByname(PTmpColumnProp(ListBox.Items.Objects[i])^.Name))
    else
      ColumnToEdit := nil;
    if ColumnToEdit = nil then begin
      if not PTmpColumnProp(ListBox.Items.Objects[i])^.GroupBy then
        ColumnToEdit := TOvcRvViewField(View.ViewFields.Add)
      else begin
        j := 0;
        while (j < View.ViewFields.Count) and (View.ViewField[j].GroupBy) do
          inc(j);
        if j >= View.ViewFields.Count then
          ColumnToEdit := TOvcRvViewField(View.ViewFields.Add)
        else
          ColumnToEdit := TOvcRvViewField(View.ViewFields.Insert(j));
      end;
      PTmpColumnProp(ListBox.Items.Objects[i])^.Ref := ColumnToEdit;
    end;
    with PTmpColumnProp(ListBox.Items.Objects[i])^ do begin
      ColumnToEdit.FieldName := ListBox.Items[i];
      if Name = '' then
        ColumnToEdit.Name := UniqueNameFromColumn(ColumnToEdit.FieldName,View)
      else
        ColumnToEdit.Name := Name;
      ColumnToEdit.ComputeTotals := ComputeTotals;
      ColumnToEdit.GroupBy := GroupBy;
      ColumnToEdit.OwnerDraw := OwnerDraw;
      ColumnToEdit.ShowHint := ShowHint;
      ColumnToEdit.AllowResize := AllowResize;
      ColumnToEdit.PrintWidth := PrintWidth;
      ColumnToEdit.Width := Width;
      ColumnToEdit.Tag := ColTag;
      ColumnToEdit.Index := BaseIndex + i;
      ColumnToEdit.Visible := Visible;
      ColumnToEdit.SortDirection := TOvcRvFieldSort(SortDir);
      ColumnToEdit.Aggregate := AggExp;
    end;
  end;
end;

function UniqueNameFromTitle(ReportView : TOvcCustomReportView; Title : string) : string;
var
  i : Integer;
begin
  if CharInSet(Title[1], ['A'..'Z','a'..'z']) then
    Result := Title[1]
  else
    Result := '_';
  for i := 2 to length(Title) do
    if CharInSet(Title[i], ['A'..'Z','a'..'z','0'..'9']) then
      Result := Result + Title[i]
    else
      Result := Result + '_';
  repeat
    for i := 0 to pred(ReportView.Views.Count) do
      if ReportView.View[i].Name = Result then begin
        Result := Result + '_1';
        continue;
      end;
  until True;
end;

procedure EditViews(Dsg : IDesigner; ReportView : TOvcCustomReportView);
var
  i, j : Integer;
  Found : Boolean;
  ViewToEdit, NewView : TOvcRVView;
  ViewName : string;
begin
  with TRVCmpEd.Create(Application) do
    try
      OwnerView := ReportView;
      with ReportView do begin
        for i := 0 to pred(Fields.Count) do
          if Field[i].CanSort then
            SListBox.Items.AddObject(Field[i].Name,Field[i])
          else
            NSListBox.Items.AddObject(Field[i].Name,Field[i]);
        for i := 0 to pred(Views.Count) do
          cbxName.Items.Add(View[i].Name);
      end;
      EnableEdit(False);
      if Showmodal = mrOK then begin
        case EditMode of
        emCreating :
          begin
            NewView := TOvcRVView(ReportView.Views.Add);
            NewView.Title := edtViewTitle.AsString;
            NewView.Name := UniqueNameFromTitle(OwnerView,NewView.Title);
            NewView.ShowHeader := ShowHeader;
            NewView.ShowFooter := ShowFooter;
            NewView.ShowGroupTotals := ShowGroupTotals;
            NewView.ShowGroupCounts := ShowGroupCounts;
            NewView.Hidden := Hidden;
            NewView.FilterIndex := FilterIndex;
            NewView.Filter := FilterExp;
            NewView.Tag := ViewTag;
            NewView.DefaultSortColumn := ViewSortColumn;
            NewView.DefaultSortDescending := ViewSortDescending;
            CopyColumns(GListBox,NewView);
            CopyColumns(NGListBox,NewView);
            ReportView.ActiveViewByTitle := NewView.Title;
          end;
        emCloning :
          begin
            ViewName := ReportView.CurrentView.Name;
            NewView := TOvcRVView(ReportView.Views.Add);
            NewView.Title := edtViewTitle.AsString;
            NewView.Name := UniqueNameFromTitle(OwnerView,NewView.Title);
            NewView.ShowHeader := ShowHeader;
            NewView.ShowFooter := ShowFooter;
            NewView.ShowGroupTotals := ShowGroupTotals;
            NewView.ShowGroupCounts := ShowGroupCounts;
            NewView.Hidden := Hidden;
            NewView.FilterIndex := FilterIndex;
            NewView.Filter := FilterExp;
            NewView.Tag := ViewTag;
            NewView.DefaultSortColumn := ViewSortColumn;
            NewView.DefaultSortDescending := ViewSortDescending;
            CopyColumns(GListBox,NewView);
            CopyColumns(NGListBox,NewView);
            ReportView.ActiveViewByTitle := NewView.Title;
          end;
        emEditing :
          begin
            Dsg.Modified;
            Application.ProcessMessages;
            ViewName := ReportView.CurrentView.Name;
            ViewToEdit := ReportView.CurrentView;
            ViewToEdit.Title := edtViewTitle.AsString;
            ViewToEdit.ShowHeader := ShowHeader;
            ViewToEdit.ShowFooter := ShowFooter;
            ViewToEdit.ShowGroupTotals := ShowGroupTotals;
            ViewToEdit.ShowGroupCounts := ShowGroupCounts;
            ViewToEdit.Hidden := Hidden;
            ViewToEdit.FilterIndex := FilterIndex;
            ViewToEdit.Filter := FilterExp;
            ViewToEdit.Tag := ViewTag;
            ViewToEdit.DefaultSortColumn := ViewSortColumn;
            ViewToEdit.DefaultSortDescending := ViewSortDescending;
            UpdateColumns(GListBox,ViewToEdit, 0);
            UpdateColumns(NGListBox,ViewToEdit, GListBox.Items.Count);
            {remove deleted fields}
            for i := pred(ViewToEdit.ViewFields.Count) downto 0 do begin
              Found := False;
              for j := 0 to pred(GListBox.Items.Count) do
                if PTmpColumnProp(GListBox.Items.Objects[j])^.Ref <> nil then
                  if ViewToEdit.ViewField[i] = PTmpColumnProp(GListBox.Items.Objects[j])^.Ref then begin
                    Found := True;
                    break;
                  end;
              if not Found then begin
                for j := 0 to pred(NGListBox.Items.Count) do
                  if PTmpColumnProp(NGListBox.Items.Objects[j])^.Ref <> nil then
                    if ViewToEdit.ViewField[i] = PTmpColumnProp(NGListBox.Items.Objects[j])^.Ref then begin
                      Found := True;
                      break;
                    end;
              end;
              if not Found then
                ViewToEdit.ViewField[i].Free;
            end;
            ReportView.RebuildIndexes;
          end;
        end;
      end;
    finally
      Free;
    end;
end;

procedure TRVCmpEd.LoadNewView(Name : string);
var
  CurrentView : TOvcRvView;
  NewCol : PTmpColumnProp;
  i : Integer;
begin
  CurrentView := TOvcRvView(OwnerView.Views.ItemByName(Name));
  OwnerView.ActiveView := Name;
  ShowHeader := CurrentView.ShowHeader;
  ShowFooter := CurrentView.ShowFooter;
  ShowGroupTotals := CurrentView.ShowGroupTotals;
  ShowGroupCounts := CurrentView.ShowGroupCounts;
  Hidden := CurrentView.Hidden;
  FilterIndex := CurrentView.FilterIndex;
  FilterExp := CurrentView.Filter;
  ViewTag := CurrentView.Tag;
  ViewSortColumn := CurrentView.DefaultSortColumn;
  ViewSortDescending := CurrentView.DefaultSortDescending;
  edtViewTitle.AsString := CurrentView.Title;
  for i := 0 to pred(CurrentView.ViewFields.Count) do begin
    New(NewCol);
    NewCol^.Name := CurrentView.ViewField[i].Name;
    NewCol^.Width := CurrentView.ViewField[i].Width;
    NewCol^.PrintWidth := CurrentView.ViewField[i].PrintWidth;
    NewCol^.ComputeTotals := CurrentView.ViewField[i].ComputeTotals;
    NewCol^.OwnerDraw := CurrentView.ViewField[i].OwnerDraw;
    NewCol^.ShowHint := CurrentView.ViewField[i].ShowHint;
    NewCol^.AllowResize := CurrentView.ViewField[i].AllowResize;
    NewCol^.GroupBy := CurrentView.ViewField[i].GroupBy;
    NewCol^.ColumnDef := CurrentView.ViewField[i].Field;
    NewCol^.ColTag := CurrentView.ViewField[i].Tag;
    NewCol^.Ref := CurrentView.ViewField[i];
    NewCol^.Visible := CurrentView.ViewField[i].Visible;
    NewCol^.SortDir := ord(CurrentView.ViewField[i].SortDirection);
    NewCol^.AggExp := CurrentView.ViewField[i].Aggregate;
    if NewCol^.GroupBy then
      GListBox.Items.AddObject(
        NewCol^.ColumnDef.Name,
        TObject(NewCol)
        )
    else
      NGListBox.Items.AddObject(
        NewCol^.ColumnDef.Name,
        TObject(NewCol)
        );
  end;
end;

procedure TRvCmpEd.ClearOldView;
var
  i : Integer;
begin
  for i := 0 to pred(GListBox.Items.Count) do
    Dispose(PTmpColumnProp(GListBox.Items.Objects[i]));
  GListBox.Clear;
  for i := 0 to pred(NGListBox.Items.Count) do
    Dispose(PTmpColumnProp(NGListBox.Items.Objects[i]));
  NGListBox.Clear;
end;

procedure TRVCmpEd.cbxNameClick(Sender: TObject);
begin
  if OwnerView.Fields.Count = 0 then begin
    ShowMessage('No field definition');
    exit;
  end;
  ClearOldView;
  with cbxName do
    if ItemIndex <> -1 then
      LoadNewView(Items[ItemIndex]);
end;

procedure TRVCmpEd.btnNewClick(Sender: TObject);
begin
  if OwnerView.Fields.Count = 0 then begin
    ShowMessage('No field definition');
    exit;
  end;
  if ((OwnerView <> nil) and
      (OwnerView.CurrentView <> nil)) then begin
    if csAncestor
      in OwnerView.CurrentView.ComponentState then begin
      ShowMessage(
        'Report view is inherited component - can''t add ');
      exit;
    end;
  end;
  ClearOldView;
  edtViewTitle.Text := '';
  ShowHeader := rvDefShowHeader;
  ShowFooter := rvDefShowFooter;
  ShowGroupTotals := rvDefShowGroupTotals;
  ShowGroupCounts := rvDefShowGroupCounts;
  Hidden := False;
  FilterIndex := -1;
  FilterExp := '';
  EditMode := emCreating;
  cbxName.Enabled := False;
  btnNew.Enabled := False;
  btnClone.Enabled := False;
  btnEdit.Enabled := False;
  btnDelete.Enabled := False;
  Caption := 'Creating new view definition';
  EnableEdit(True);
  edtViewTitle.SetFocus;
end;

procedure TRVCmpEd.btnCloneClick(Sender: TObject);
begin
  if OwnerView.Fields.Count = 0 then begin
    ShowMessage('No field definition');
    exit;
  end;
  if cbxName.ItemIndex = -1 then begin
    ShowMessage('First select the view to clone');
    exit;
  end;
  edtViewTitle.Text := '';
  EditMode := emCloning;
  Cloning := True;
  cbxName.Enabled := False;
  btnNew.Enabled := False;
  btnClone.Enabled := False;
  btnEdit.Enabled := False;
  btnDelete.Enabled := False;
  with cbxName do
    Caption := 'Cloning new view from ' + Items[ItemIndex];
  cbxName.Text := '(New)';
  EnableEdit(True);
end;

procedure TRVCmpEd.btnEditClick(Sender: TObject);
begin
  if OwnerView.Fields.Count = 0 then begin
    ShowMessage('No field definition');
    exit;
  end;
  if cbxName.ItemIndex = -1 then begin
    ShowMessage('First select the view to edit');
    exit;
  end;
  EditMode := emEditing;
  cbxName.Enabled := False;
  btnNew.Enabled := False;
  btnClone.Enabled := False;
  btnEdit.Enabled := False;
  btnDelete.Enabled := False;
  with cbxName do
    Caption := 'Editing view ' + Items[ItemIndex];
  EnableEdit(True);
end;

procedure TRVCmpEd.GListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := EditEnabled and (Source = SListBox);
end;

procedure TRVCmpEd.GListBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  btnAddGClick(nil);
end;

procedure TRVCmpEd.NGListBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := EditEnabled and ((Source = SListBox) or (Source = NSListBox));
end;

procedure TRVCmpEd.NGListBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  btnAddClick(nil);
end;

{*** TOvcCustomReportView ***}

procedure TOvcReportViewEditor.ExecuteVerb(Index : Integer);
begin
  EditViews(Designer, Component as TOvcCustomReportView);
end;

function TOvcReportViewEditor.GetVerb(Index : Integer) : String;
begin
  case Index of
    0 : Result := 'Edit View Definitions';
  else
    Result := '?';
  end;
end;

function TOvcReportViewEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;

{*** TOvcRvActiveViewProperty ***}

function TOvcRvActiveViewProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TOvcRvActiveViewProperty.GetValues(Proc : TGetStrProc);
var
  I     : Integer;
  Ctl   : TOvcCustomReportView;
begin
  Ctl := GetComponent(0) as TOvcCustomReportView;
  with Ctl do
    for I := 0 to pred(Views.Count) do
      Proc(View[I].Name);
end;

function TOvcRvActiveViewProperty.GetValue : String;
begin
  Result := GetStrValue;
end;

procedure TOvcRvActiveViewProperty.SetValue(const AValue : String);
begin
  SetStrValue(AValue);
end;

{*** TOvcRvFieldNameProperty ***}

function TOvcRvFieldNameProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TOvcRvFieldNameProperty.GetValues(Proc : TGetStrProc);
var
  I     : Integer;
  Ctl   : TOvcAbstractRvViewField;
begin
  Ctl := GetComponent(0) as TOvcAbstractRvViewField;
  with Ctl do
    for I := 0 to pred(Ctl.OwnerReport.Fields.Count) do
      Proc(Ctl.OwnerReport.Field[i].Name);
end;

function TOvcRvFieldNameProperty.GetValue : String;
begin
  Result := GetStrValue;
end;

procedure TOvcRvFieldNameProperty.SetValue(const AValue : String);
begin
  SetStrValue(AValue);
end;

procedure TRVCmpEd.btnDeleteClick(Sender: TObject);
var
  ViewToDelete : TOvcRVView;
begin
  if cbxName.ItemIndex = -1 then begin
    ShowMessage('No current view');
    exit;
  end;
  if ((OwnerView <> nil) and
      (OwnerView.CurrentView <> nil)) then begin
    if csAncestor
      in OwnerView.CurrentView.ComponentState then begin
      ShowMessage(
        'Report view is inherited component - can''t delete');
      exit;
    end;
  end;
  if MessageDlg('Warning! This operation cannot be undone. Delete current view?',
    mtConfirmation,mbOkCancel,0) <> mrOK then exit;
  ClearOldView;
  ViewToDelete := OwnerView.CurrentView;
  OwnerView.ActiveView := '';
  ViewToDelete.Free;
  with cbxName do begin
    Items.Delete(ItemIndex);
    ItemIndex := -1;
  end;
end;

{ TOvcRvImgIdxProperty }

function TOvcRvImgIdxProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paRevertable];
end;

function TOvcRvImgIdxProperty.GetValue: string;
begin
  Result := IntToStr(GetOrdValue);
end;

procedure TOvcRvImgIdxProperty.GetValues(Proc: TGetStrProc);
var
  C: TOvcRvField;
  i: Integer;
begin
  C := TOvcRvField(GetComponent(0));
  Proc('-1');
  if TObject(C) is TOvcRvField then
    if TOvcCustomReportView(C.OwnerReport).HeaderImages <> nil then
      for i := 0 to TOvcCustomReportView(C.OwnerReport).HeaderImages.Count - 1 do
        Proc(IntToStr(i));
end;

{
procedure TOvcRvImgIdxProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  if GetVisualValue <> '' then
    ListDrawValue(GetVisualValue, ACanvas, ARect, True)
  else
    inherited PropDrawValue(ACanvas, ARect, ASelected);
end;
}

procedure TOvcRvImgIdxProperty.ListDrawValue(const Value: string; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);

  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red,
      Green,
      Blue,
      Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or
       (TColorQuad(AColor).Green > 192) or
       (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else if ASelected then
      Result := clWhite
    else
      Result := AColor;
  end;

var
  ImgIdx: Integer;
begin
  with ACanvas do
  try

    ImgIdx := StrToInt(Value);
    if ImgIdx <> -1 then begin
      TOvcCustomReportView(TOvcRvField(GetComponent(0)).OwnerReport).HeaderImages.Draw(
        ACanvas,
        ARect.Left + 1,
        ARect.Top + 1,
        ImgIdx);
    end;
  finally
  end;
end;

procedure TOvcRvImgIdxProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  if TOvcCustomReportView(TOvcRvField(GetComponent(0)).OwnerReport).HeaderImages
    <> nil
  then
    AWidth := TOvcCustomReportView(
      TOvcRvField(GetComponent(0)).OwnerReport).HeaderImages.Width + 4
      + ACanvas.TextWidth('00');
end;

procedure TOvcRvImgIdxProperty.ListMeasureHeight(const Value: string; ACanvas: TCanvas;
  var AHeight: Integer);
begin
  if TOvcCustomReportView(TOvcRvField(GetComponent(0)).OwnerReport).HeaderImages <> nil then
    AHeight := TOvcCustomReportView(TOvcRvField(GetComponent(0)).OwnerReport).HeaderImages.Height + 4;
end;

end.
