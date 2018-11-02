{*********************************************************}
{*                  OvcViewEd.pas 4.00                   *}
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


unit ovcviewed;

interface

uses
  Types, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, OvcDrag, OvcRptVw, OvcBase, OvcRVIdx, Menus, OvcCmbx;

const
  WM_Rebuild = WM_User + 123;
  DefGroupColWidth = 20;
type
  TfrmViewEd = class(TForm)
    StaticText1: TStaticText;
    Panel1: TScrollBox;
    Panel2: TScrollBox;
    Panel3: TScrollBox;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Button1: TButton;
    Button2: TButton;
    Panel4: TPanel;
    Label1: TLabel;
    ViewFieldPopup: TPopupMenu;
    ShowTotals1: TMenuItem;
    AllowResize1: TMenuItem;
    ShowHint1: TMenuItem;
    Panel5: TPanel;
    StaticText4: TStaticText;
    Panel6: TPanel;
    Label2: TLabel;
    tEdit: TEdit;
    fEdit: TEdit;
    cbxField: TOvcComboBox;
    cbxOp: TOvcComboBox;
    Panel7: TPanel;
    Panel8: TPanel;
    tbHeader: TCheckBox;
    tbFooter: TCheckBox;
    tbGroupCounts: TCheckBox;
    tbGroupTotals: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbxFunc: TOvcComboBox;
    Label8: TLabel;
    Label9: TLabel;
    btnAdditional: TButton;
    procedure tbHeaderClick(Sender: TObject);
    procedure tbFooterClick(Sender: TObject);
    procedure tbGroupCountsClick(Sender: TObject);
    procedure tbGroupTotalsClick(Sender: TObject);
    procedure ViewFieldPopupPopup(Sender: TObject);
    procedure AllowResize1Click(Sender: TObject);
    procedure ShowTotals1Click(Sender: TObject);
    procedure ShowHint1Click(Sender: TObject);
    procedure tEditChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbxFieldClick(Sender: TObject);
    procedure cbxOpClick(Sender: TObject);
    procedure cbxFuncClick(Sender: TObject);
    procedure btnAdditionalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    PopupColumn : TOvcRvViewField;
    procedure WMRebuild(var Message: TMessage); message WM_Rebuild;
    procedure ClearLists;
    //procedure CheckLists;
    procedure OvcReportView1SortingChanged(Sender: TObject);
  public
    { Public declarations }
    OwnerViewx : TOvcCustomReportView;
    FieldList, PaintList : TList;
    GroupList, GPaintList : TList;
    ColumnList, CPaintList : TList;
    DragShow : TOvcDragShow;
    FieldRect : TRect;
    GroupRect, ColumnRect : TRect;
    MouseOver : (moNothing, moFields, moGroups, moColumns);
    {Dragging : (dNothing, dField, dGroup, dColumn);}
    DragField : TOvcRvField;
    DragColumn : TOvcRvViewField;
    SaveView : string;
    EV : TOvcRvView;
    EditReportView : TOvcCustomReportView;
    procedure PaintBox1Paint(Sender: TObject);
    procedure GPaintBoxPaint(Sender: TObject);
    procedure CPaintBoxPaint(Sender: TObject);
    procedure FPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BuildFieldList;
    procedure BuildGroupColumnList;
    procedure BuildColumnList;
    procedure CalcDragRects;
  end;

function EditView(ReportView : TOvcCustomReportView): Boolean;

implementation
uses
  ovcvcped;

{$R *.DFM}

function EditView(ReportView : TOvcCustomReportView): Boolean;
var
  F : TfrmViewEd;
  Cl : TOvcReportViewClass;
begin
  Result := False;
  F := TfrmViewEd.Create(Application);
  with F do
    try
      Caption := 'Editing view layout "' + ReportView.CurrentView.Title + '"';
      Cl := TOvcReportViewClass(ReportView.ClassType);
      EditReportView := Cl.Create(F);
      EditReportView.Parent := Panel7;
      EditReportView.Align := alClient;
      EditReportView.AssignStructure(ReportView);
      EditReportView.ActiveView := ReportView.ActiveView;
      EditReportView.ScrollBars := ssHorizontal;
      EditReportView.HeaderImages := ReportView.HeaderImages;
      EditReportView.Options.Assign(ReportView.Options);
      EditReportView.OnSortingChanged := OvcReportView1SortingChanged;
      EditReportView.Designing := True;
      tEdit.Text := EditReportView.CurrentView.Title;
      fEdit.Text := EditReportView.CurrentView.Filter;
      tbHeader.Checked := EditReportView.CurrentView.ShowHeader;
      tbFooter.Checked := EditReportView.CurrentView.ShowFooter;
      tbGroupCounts.Checked := EditReportView.CurrentView.ShowGroupCounts;
      tbGroupTotals.Checked := EditReportView.CurrentView.ShowGroupTotals;
      OwnerViewx := EditReportView; //ReportView;
      EV := OwnerViewx.CurrentView;
      BuildGroupColumnList;
      BuildColumnList;
      BuildFieldList;
      if Showmodal = mrOK then begin
        SaveView := ReportView.ActiveView;
        ReportView.ActiveView := '';
        ReportView.ReplaceView(SaveView, EditReportView.CurrentView);
        ReportView.RebuildIndexes;
        ReportView.ActiveView := SaveView;
        Result := True;
      end;
    finally
      EV := nil;
      EditReportView := nil;
      Free;
    end;
end;

{ TfrmViewEd }

procedure TfrmViewEd.FormCreate(Sender: TObject);
  {- fix for issue 1056218: The lists used by TfrmViewEd were not freed when the form
     was destroyed. }
begin
  FieldList := nil;
  PaintList := nil;
  GroupList := nil;
  GPaintList:= nil;
  ColumnList:= nil;
  CPaintList:= nil;
end;

procedure TfrmViewEd.FormDestroy(Sender: TObject);
begin
  ClearLists;
  if Assigned(FieldList)  then FieldList.Free;
  if Assigned(PaintList)  then PaintList.Free;
  if Assigned(GroupList)  then GroupList.Free;
  if Assigned(GPaintList) then GPaintList.Free;
  if Assigned(ColumnList) then ColumnList.Free;
  if Assigned(CPaintList) then CPaintList.Free;
end;


procedure TfrmViewEd.ClearLists;
var
  i : Integer;
begin
  if FieldList <> nil then begin
    for i := 0 to pred(PaintList.Count) do
      TPaintBox(PaintList[i]).Free;
    PaintList.Clear;
    FieldList.Clear;
  end;
  if GroupList <> nil then begin
    for i := 0 to pred(GPaintList.Count) do
      TPaintBox(GPaintList[i]).Free;
    GPaintList.Clear;
    GroupList.Clear;
  end;
  if ColumnList <> nil then begin
    for i := pred(CPaintList.Count) downto 0 do begin
      TPaintBox(CPaintList[i]).Parent := nil;
    end;
    for i := pred(CPaintList.Count) downto 0 do begin
      TPaintBox(CPaintList[i]).Free;
    end;
    CPaintList.Clear;
    ColumnList.Clear;
  end;
end;

procedure TfrmViewEd.BuildFieldList;
var
  F : TOvcRvField;
  P : TPaintBox;
  X, Y, i, j : Integer;
  Found : Boolean;
begin
  if FieldList = nil then begin
    FieldList := TList.Create;
    PaintList := TList.Create;
  end else begin
    FieldList.Clear;
    for i := 0 to pred(PaintList.Count) do begin
      TPaintBox(PaintList[i]).Free;
    end;
    PaintList.Clear;
  end;
  X := 2;
  Y := 1;
  cbxField.Items.Clear;
  for i := 0 to pred(OwnerViewx.Fields.Count) do begin
    F := TOvcRvField(OwnerViewx.Fields[i]);
    if not F.NoDesign then begin
      cbxField.Items.Add(' ' + F.Name + ' ');
      Found := False;
      if GroupList <> nil then
        for j := 0 to pred(GroupList.Count) do
          if TOvcRvViewField(GroupList[j]).Field = F then begin
            Found := True;
            break;
          end;
      if not Found and (ColumnList <> nil) then begin
        for j := 0 to pred(ColumnList.Count) do
          if TOvcRvViewField(ColumnList[j]).Field = F then begin
            Found := True;
            break;
          end;
      end;
      if not Found then begin
        FieldList.Add(F);
        P := TPaintBox.Create(Panel1);
        P.Name := 'PB'+IntToStr(Random(10000));
        P.Height := 18;
        P.Width := Canvas.TextWidth(F.Name) + 4;
        if F.CanSort then
          P.Width := P.Width + 6;
        if X + P.Width >= Panel1.Width - 2 then begin
          inc(Y, 18);
          X := 2;
        end;
        P.Left := X;
        P.Top := Y;
        P.Parent := Panel1;
        P.Hint := F.Hint;
        P.ShowHint := True;
        P.OnPaint := PaintBox1Paint;
        P.OnMouseDown := FPaintBoxMouseDown;
        P.OnMouseUp := FPaintBoxMouseUp;
        P.OnMouseMove := FPaintBoxMouseMove;
        P.Tag := Integer(F);
        inc(X, P.Width);
        PaintList.Add(P);
      end;
    end;
  end;
end;

procedure TfrmViewEd.BuildGroupColumnList;
var
  V : TOvcRvViewField;
  F : TOvcRvField;
  P : TPaintBox;
  X, Y, i : Integer;
begin
  if GroupList = nil then begin
    GroupList := TList.Create;
    GPaintList := TList.Create;
  end else begin
    GroupList.Clear;
    for i := 0 to pred(GPaintList.Count) do
      TPaintBox(GPaintList[i]).Free;
    GPaintList.Clear;
  end;
  X := 2;
  Y := 1;
  for i := 0 to pred(EV.ViewFields.Count) do begin
    V := EV.ViewField[i];
    if V.GroupBy then begin
      F := V.Field;
      GroupList.Add(V);
      P := TPaintBox.Create(Panel2);
      P.Name := 'PB'+IntToStr(Random(10000));
      P.Height := {!3} 24{18};
      P.Width := Canvas.TextWidth(F.Name) + 20;
      P.Hint := F.Hint;
      P.ShowHint := True;
      P.Left := X;
      P.Top := Y;
      P.Parent := Panel2;
      P.OnPaint := GPaintBoxPaint;
      P.OnMouseDown := GPaintBoxMouseDown;
      P.OnMouseUp := GPaintBoxMouseUp;
      P.OnMouseMove := GPaintBoxMouseMove;
      P.PopupMenu := ViewFieldPopup;
      P.Tag := Integer(V);
      inc(X, P.Width{ - 20});
      GPaintList.Add(P);
      inc(Y, 8);
    end;
  end;
end;

procedure TfrmViewEd.BuildColumnList;
var
  V : TOvcRvViewField;
  F : TOvcRvField;
  P : TPaintBox;
  X, Y, i : Integer;
  S : string;
begin
  if ColumnList = nil then begin
    ColumnList := TList.Create;
    CPaintList := TList.Create;
  end else begin
    ColumnList.Clear;
    for i := 0 to pred(CPaintList.Count) do
      TPaintBox(CPaintList[i]).Free;
    CPaintList.Clear;
  end;
  X := 2;
  Y := 1;
  for i := 0 to pred(EV.ViewFields.Count) do begin
    V := EV.ViewField[i];
    if not V.GroupBy then begin
      F := V.Field;
      ColumnList.Add(V);
      P := TPaintBox.Create(Panel3);
      P.Name := 'PB'+IntToStr(Random(10000));
      P.Height := 18;
      P.Hint := F.Hint;
      P.ShowHint := True;
      S := F.Name;
      if V.ComputeTotals then
        S := S + '(t)';
      P.Width := Canvas.TextWidth(S) + 4;
      if (i = EV.DefaultSortColumn) then
        P.Width := P.Width + 6;
      if X + P.Width >= Panel1.Width - 2 then begin
        inc(Y, 18);
        X := 2;
      end;
      P.Left := X;
      P.Top := Y;
      P.Parent := Panel3;
      P.OnPaint := CPaintBoxPaint;
      P.OnMouseDown := CPaintBoxMouseDown;
      P.OnMouseUp := CPaintBoxMouseUp;
      P.OnMouseMove := CPaintBoxMouseMove;
      P.PopupMenu := ViewFieldPopup;
      P.Tag := Integer(V);
      inc(X, P.Width);
      CPaintList.Add(P);
    end;
  end;
end;

procedure Arrow(Canvas: TCanvas; XBase: Integer; Up, Down: Boolean);
begin
  with Canvas do begin
    Canvas.Pen.Color := clBlack;
    MoveTo(XBase, 3);
    LineTo(XBase, 13);
    if Up then begin
      MoveTo(XBase - 2, 5);
      LineTo(XBase, 3);
      LineTo(XBase + 3, 6);
    end;
    if Down then begin
      MoveTo(XBase - 2, 11);
      LineTo(XBase, 13);
      LineTo(XBase + 3, 10);
    end;
  end;
end;

procedure TfrmViewEd.PaintBox1Paint(Sender: TObject);
var
  R : Integer;
begin
  with TPaintBox(Sender) do begin
    Canvas.MoveTo(0, Height - 1);
    Canvas.Pen.Color := clBtnHighlight;
    Canvas.LineTo(0, 0);
    Canvas.LineTo(Width - 1, 0);
    Canvas.Pen.Color := clBtnShadow;
    Canvas.LineTo(Width - 1, Height - 1);
    Canvas.LineTo(0, Height - 1);
    Canvas.TextOut(2, 2, TOvcRVField(Tag).Name);
    if TOvcRVField(Tag).CanSort then begin
      R := Width - 5;
      Arrow(Canvas, R, True, True);
    end;
  end;
end;

procedure TfrmViewEd.GPaintBoxPaint(Sender: TObject);
var
  R : Integer;
begin
  with TPaintBox(Sender) do begin
    Canvas.MoveTo(0, {Height}18 - 1);
    Canvas.Pen.Color := clBtnHighlight;
    Canvas.LineTo(0, 0);
    Canvas.LineTo(Width - 1, 0);
    Canvas.Pen.Color := clBtnShadow;
    Canvas.LineTo(Width - 1, {Height}18 - 1);
    Canvas.LineTo(0, {Height}18 - 1);
    Canvas.TextOut(2, 2, TOvcRVViewField(Tag).Field.Name);
    Canvas.Pen.Color := clBlack;
    if TOvcRVViewField(Tag).Index < EV.GroupCount - 1 then begin
      Canvas.MoveTo(Width div 2, 18);
      Canvas.LineTo(Width div 2, 22);
      Canvas.LineTo(Width, 22);
    end;
    if (TOvcRVViewField(Tag).Index = EV.DefaultSortColumn) then begin
      R := Width - 5;
      Arrow(Canvas, R, not EV.DefaultSortDescending, EV.DefaultSortDescending);
    end;
  end;
end;

procedure TfrmViewEd.CPaintBoxPaint(Sender: TObject);
var
  R : Integer;
  S : string;
begin
  with TPaintBox(Sender) do begin
    Canvas.MoveTo(0, Height - 1);
    Canvas.Pen.Color := clBtnHighlight;
    Canvas.LineTo(0, 0);
    Canvas.LineTo(Width - 1, 0);
    Canvas.Pen.Color := clBtnShadow;
    Canvas.LineTo(Width - 1, Height - 1);
    Canvas.LineTo(0, Height - 1);
    S := TOvcRVViewField(Tag).Field.Name;
    if TOvcRVViewField(Tag).ComputeTotals then
      S := S + '(t)';
    Canvas.TextOut(2, 2, S);
    if (TOvcRVViewField(Tag).Index {+ EV.GroupCount} = EV.DefaultSortColumn) then begin
      R := Width - 5;
      Arrow(Canvas, R, not EV.DefaultSortDescending, EV.DefaultSortDescending);
    end;
  end;
end;

procedure TfrmViewEd.FPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  R : TRect;
begin
  if Button <> mbLeft then exit;
  CalcDragRects;
  Pt := TPaintBox(Sender).Parent.ClientToScreen(Point(TPaintBox(Sender).Left, TPaintBox(Sender).Top));
  R := Rect(Pt.x, Pt.y, Pt.x + TPaintBox(Sender).Width - 1, Pt.y + TPaintBox(Sender).Height - 1);
  Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
  DragShow := TOvcDragShow.Create(pt.x, pt.y, R, clYellow{clBtnFace});
  {Dragging := dField;}
  DragField := TOvcRvField(TPaintBox(Sender).Tag);
end;

procedure TfrmViewEd.FPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  Pt : TPoint;
  VF : TOvcRvViewField;
  Found : Integer;
begin
  if Button <> mbLeft then exit;
  DragShow.Free;
  DragShow := nil;
  case MouseOver of
  moNothing : ;
  moFields : ;
  moGroups :
    if DragField.CanSort then begin
      Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
      Pt := Panel2.ScreenToClient(Pt); {!!}
      Found := EV.GroupCount;
      for i := 0 to pred(GPaintList.Count) do begin
        if PtInRect(TPaintBox(GPaintList[i]).BoundsRect, Pt) then begin
          Found := i;
          break;
        end;
      end;
      ClearLists;
      VF := TOvcRvViewField(EV.ViewFields.Insert(Found));
      VF.FieldName := DragField.Name;
      VF.GroupBy := True;
      VF.Width := DefGroupColWidth;
      VF.OwnerDraw := False;
      PostMessage(Handle, WM_Rebuild, 0, 0);
    end;
  moColumns :
    begin
      Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
      Pt := Panel3.ScreenToClient(Pt); {!!}
      Found := CPaintList.Count;
      for i := 0 to pred(CPaintList.Count) do begin
        if PtInRect(TPaintBox(CPaintList[i]).BoundsRect, Pt) then begin
          Found := i;
          break;
        end;
      end;
      ClearLists;
      VF := TOvcRvViewField(EV.ViewFields.Insert(EV.GroupCount + Found));
      VF.FieldName := DragField.Name;
      VF.GroupBy := False;
      VF.OwnerDraw := DragField.DefaultOwnerDraw;
      VF.SortDirection := DragField.DefaultSortDirection;
      PostMessage(Handle, WM_Rebuild, 0, 0);
    end;
  end;
  {Dragging := dNothing;}
  DragField := nil;
  DragColumn := nil;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewEd.FPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pt : TPoint;
begin
  if DragShow <> nil then begin
    Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
    DragShow.DragMove(pt.X, pt.Y);
    if PtInRect(FieldRect, Pt) then
      MouseOver := moFields
    else
    if PtInRect(GroupRect, Pt) then
      MouseOver := moGroups
    else
    if PtInRect(ColumnRect, Pt) then
      MouseOver := moColumns
    else
      MouseOver := moNothing;
    case MouseOver of
    moNothing :
      Screen.Cursor := crNoDrop;
    moFields :
      Screen.Cursor := crDefault;
    moGroups :
      if DragField.CanSort then
        Screen.Cursor := crDefault
      else
        Screen.Cursor := crNoDrop;
    moColumns :
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmViewEd.GPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  R : TRect;
begin
  if Button <> mbLeft then exit;
  CalcDragRects;
  Pt := TPaintBox(Sender).Parent.ClientToScreen(Point(TPaintBox(Sender).Left, TPaintBox(Sender).Top));
  R := Rect(Pt.x, Pt.y, Pt.x + TPaintBox(Sender).Width - 1, Pt.y + TPaintBox(Sender).Height - 1);
  Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
  DragShow := TOvcDragShow.Create(pt.x, pt.y, R, clYellow{clBtnFace});
  {Dragging := dGroup;}
  DragColumn := TOvcRvViewField(TPaintBox(Sender).Tag);
  DragField := DragColumn.Field;
end;

procedure TfrmViewEd.GPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  Pt : TPoint;
  VF : TOvcRvViewField;
  Found : Integer;
begin
  if Button <> mbLeft then exit;
  DragShow.Free;
  DragShow := nil;
  case MouseOver of
  moNothing : ;
  moFields :
    begin
      DragColumn.Free;
      ClearLists;
      PostMessage(Handle, WM_Rebuild, 0, 0);
    end;
  moGroups : ;
  moColumns :
    begin
      Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
      Pt := Panel3.ScreenToClient(Pt); {!!}
      Found := CPaintList.Count;
      for i := 0 to pred(CPaintList.Count) do begin
        if PtInRect(TPaintBox(CPaintList[i]).BoundsRect, Pt) then begin
          Found := i;
          break;
        end;
      end;
      ClearLists;
      VF := DragColumn;
      VF.GroupBy := False;
      VF.Index := EV.GroupCount + Found;
      VF.Width := VF.Field.DefaultWidth;
      VF.OwnerDraw := VF.Field.DefaultOwnerDraw;
      VF.SortDirection := VF.Field.DefaultSortDirection;
      PostMessage(Handle, WM_Rebuild, 0, 0);
    end;
  end;
  {Dragging := dNothing;}
  DragField := nil;
  DragColumn := nil;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewEd.GPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pt : TPoint;
begin
  if DragShow <> nil then begin
    Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
    DragShow.DragMove(pt.X, pt.Y);
    if PtInRect(FieldRect, Pt) then
      MouseOver := moFields
    else
    if PtInRect(GroupRect, Pt) then
      MouseOver := moGroups
    else
    if PtInRect(ColumnRect, Pt) then
      MouseOver := moColumns
    else
      MouseOver := moNothing;
    case MouseOver of
    moNothing :
      Screen.Cursor := crNoDrop;
    moFields :
      Screen.Cursor := crDefault;
    moGroups :
      Screen.Cursor := crDefault;
    moColumns :
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmViewEd.CPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  R : TRect;
begin
  if Button <> mbLeft then exit;
  CalcDragRects;
  Pt := TPaintBox(Sender).Parent.ClientToScreen(Point(TPaintBox(Sender).Left, TPaintBox(Sender).Top));
  R := Rect(Pt.x, Pt.y, Pt.x + TPaintBox(Sender).Width - 1, Pt.y + TPaintBox(Sender).Height - 1);
  Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
  DragShow := TOvcDragShow.Create(pt.x, pt.y, R, clYellow{clBtnFace});
  {Dragging := dColumn;}
  DragColumn := TOvcRvViewField(TPaintBox(Sender).Tag);
  DragField := DragColumn.Field;
end;

procedure TfrmViewEd.CPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  Pt : TPoint;
  VF : TOvcRvViewField;
  Found : Integer;
begin
  if Button <> mbLeft then exit;
  DragShow.Free;
  DragShow := nil;
  case MouseOver of
  moNothing : ;
  moFields :
    begin
      DragColumn.Free;
      ClearLists;
      PostMessage(Handle, WM_Rebuild, 0, 0);
    end;
  moGroups :
    if DragField.CanSort then begin
      Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
      Pt := Panel2.ScreenToClient(Pt); {!!}
      Found := EV.GroupCount;
      for i := 0 to pred(GPaintList.Count) do begin
        if PtInRect(TPaintBox(GPaintList[i]).BoundsRect, Pt) then begin
          Found := i;
          break;
        end;
      end;
      ClearLists;
      VF := DragColumn;
      VF.GroupBy := True;
      VF.Index := Found;
      VF.Width := DefGroupColWidth;
      PostMessage(Handle, WM_Rebuild, 0, 0);
    end;
  moColumns :
    begin
      Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
      Pt := Panel3.ScreenToClient(Pt); {!!}
      Found := CPaintList.Count - 1;
      for i := 0 to pred(CPaintList.Count) do begin
        if PtInRect(TPaintBox(CPaintList[i]).BoundsRect, Pt) then begin
          Found := i;
          break;
        end;
      end;
      if EV.GroupCount + Found <> DragColumn.Index then begin
        ClearLists;
        DragColumn.Index := EV.GroupCount + Found;
        PostMessage(Handle, WM_Rebuild, 0, 0);
      end;
    end;
  end;
  {Dragging := dNothing;}
  DragField := nil;
  DragColumn := nil;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewEd.CPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pt : TPoint;
begin
  if DragShow <> nil then begin
    Pt := TPaintBox(Sender).ClientToScreen(Point(X, Y));
    DragShow.DragMove(pt.X, pt.Y);
    if PtInRect(FieldRect, Pt) then
      MouseOver := moFields
    else
    if PtInRect(GroupRect, Pt) then
      MouseOver := moGroups
    else
    if PtInRect(ColumnRect, Pt) then
      MouseOver := moColumns
    else
      MouseOver := moNothing;
    case MouseOver of
    moNothing :
      Screen.Cursor := crNoDrop;
    moFields :
      Screen.Cursor := crDefault;
    moGroups :
      if DragField.CanSort then
        Screen.Cursor := crDefault
      else
        Screen.Cursor := crNoDrop;
    moColumns :
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmViewEd.CalcDragRects;
begin
  FieldRect := Panel1.BoundsRect;
  FieldRect.TopLeft := ClientToScreen(FieldRect.TopLeft);
  FieldRect.BottomRight := ClientToScreen(FieldRect.BottomRight);
  GroupRect := Panel2.BoundsRect;
  GroupRect.TopLeft := ClientToScreen(GroupRect.TopLeft);
  GroupRect.BottomRight := ClientToScreen(GroupRect.BottomRight);
  ColumnRect := Panel3.BoundsRect;
  ColumnRect.TopLeft := ClientToScreen(ColumnRect.TopLeft);
  ColumnRect.BottomRight := ClientToScreen(ColumnRect.BottomRight);
end;

procedure TfrmViewEd.WMRebuild(var Message: TMessage);
begin
  BuildGroupColumnList;
  BuildColumnList;
  BuildFieldList;
  EditReportView.RebuildIndexes;
end;

procedure TfrmViewEd.OvcReportView1SortingChanged(Sender: TObject);
begin
  if (EditReportView.CurrentView.DefaultSortColumn <>
    EditReportView.SortColumn)
  or (EditReportView.CurrentView.DefaultSortDescending <>
    EditReportView.SortDescending) then begin
    EditReportView.CurrentView.DefaultSortColumn :=
      EditReportView.SortColumn;
    EditReportView.CurrentView.DefaultSortDescending :=
      EditReportView.SortDescending;
    PostMessage(Handle, WM_Rebuild, 0, 0);
  end;
end;

procedure TfrmViewEd.tbHeaderClick(Sender: TObject);
begin
  EditReportView.CurrentView.ShowHeader := tbHeader.Checked;
end;

procedure TfrmViewEd.tbFooterClick(Sender: TObject);
begin
  EditReportView.CurrentView.ShowFooter := tbFooter.Checked;
end;

procedure TfrmViewEd.tbGroupCountsClick(Sender: TObject);
begin
  EditReportView.CurrentView.ShowGroupCounts := tbGroupCounts.Checked;
end;

procedure TfrmViewEd.tbGroupTotalsClick(Sender: TObject);
begin
  EditReportView.CurrentView.ShowGroupTotals := tbGroupTotals.Checked;
end;

procedure TfrmViewEd.ViewFieldPopupPopup(Sender: TObject);
begin
  if ViewFieldPopup.PopupComponent is TPaintBox then begin
    PopupColumn := TOvcRvViewField(TPaintBox(ViewFieldPopup.PopupComponent).Tag);
    if PopupColumn is TOvcRvViewField then begin
      ShowTotals1.Checked := PopupColumn.ComputeTotals;
      AllowResize1.Checked := PopupColumn.AllowResize;
      ShowHint1.Checked := PopupColumn.ShowHint;
    end;
  end;
end;

procedure TfrmViewEd.AllowResize1Click(Sender: TObject);
begin
  if PopupColumn <> nil then
    PopupColumn.AllowResize := not PopupColumn.AllowResize;
end;

procedure TfrmViewEd.ShowTotals1Click(Sender: TObject);
begin
  if PopupColumn <> nil then begin
    PopupColumn.ComputeTotals := not PopupColumn.ComputeTotals;
    PostMessage(Handle, WM_Rebuild, 0, 0);
  end;
end;

procedure TfrmViewEd.ShowHint1Click(Sender: TObject);
begin
  if PopupColumn <> nil then
    PopupColumn.ShowHint := not PopupColumn.ShowHint;
end;

procedure TfrmViewEd.tEditChange(Sender: TObject);
begin
  EditReportView.CurrentView.Title := tEdit.Text;
  Caption := 'Editing view layout "' + EditReportView.CurrentView.Title + '"';
end;

procedure TfrmViewEd.Button1Click(Sender: TObject);
begin
  if EditReportView.CurrentView.ViewFields.Count = 0 then
    raise Exception.Create('A view layout must have at least one column');
  EditReportView.CurrentView.Filter := fEdit.Text;
  ModalResult := mrOK;
end;

procedure TfrmViewEd.cbxFieldClick(Sender: TObject);
begin
  if cbxField.ItemIndex <> -1 then begin
    fEdit.SelText := cbxField.Items[cbxField.ItemIndex];
    fEdit.SetFocus;
    fEdit.SelStart := length(fEdit.Text);
    fEdit.SelLength := 0;
    cbxField.ItemIndex := -1;
  end;
end;

procedure TfrmViewEd.cbxOpClick(Sender: TObject);
begin
  if cbxOp.ItemIndex <> -1 then begin
    fEdit.SelText := cbxOp.Items[cbxOp.ItemIndex];
    fEdit.SetFocus;
    fEdit.SelStart := length(fEdit.Text);
    fEdit.SelLength := 0;
    cbxOp.ItemIndex := -1;
  end;
end;

procedure TfrmViewEd.cbxFuncClick(Sender: TObject);
begin
  if cbxFunc.ItemIndex <> -1 then begin
    fEdit.SelText := cbxFunc.Items[cbxFunc.ItemIndex];
    fEdit.SetFocus;
    fEdit.SelStart := length(fEdit.Text);
    fEdit.SelLength := 0;
    cbxFunc.ItemIndex := -1;
  end;
end;

procedure TfrmViewEd.btnAdditionalClick(Sender: TObject);
var
  ViewCopy: TOvcRvView;
  OldView : TOvcRvView;
  SaveView : string;
  i: Integer;
  Pt: TPoint;
  F: TOvcRvField;
begin
  with TfrmViewCEd.Create(Application) do
    try
      Pt := btnAdditional.Parent.ClientToScreen(Point(btnAdditional.Left, btnAdditional.Top));
      Left := Pt.x + btnAdditional.Width + 2;
      Top := Pt.y - Height + btnAdditional.Height;
      OldView := EditReportView.CurrentView;
      SaveView := EditReportView.ActiveView;
      EditReportView.CurrentItem := nil;
      EditReportView.ActiveView := '';
      ViewCopy := EditReportView.Views.Add;
      ViewCopy.Assign(OldView);
      ViewCopy.Name := EditReportView.UniqueViewNameFromTitle(ViewCopy.Title);
      EditReportView.ActiveViewByTitle := ViewCopy.Title;
      for i := 0 to ViewCopy.ViewFields.Count - 1 do
        Listbox1.Items.AddObject(ViewCopy.ViewField[i].Field.Name, ViewCopy.ViewField[i]);
      cbxField.Items.Clear;
      for i := 0 to pred(EditReportView.Fields.Count) do begin
        F := TOvcRvField(EditReportView.Fields[i]);
        if not F.NoDesign then
          cbxField.Items.Add(' ' + F.Name + ' ');
      end;
      if ShowModal = mrOK then begin
        for i := 0 to ViewCopy.ViewFields.Count - 1 do
          OldView.ViewField[i].Assign(ViewCopy.ViewField[i]);
        PostMessage(Self.Handle, WM_Rebuild, 0, 0);
      end;
      EditReportView.ActiveView := SaveView;
      ViewCopy.Free;
    finally
      Free;
    end;
end;

end.


