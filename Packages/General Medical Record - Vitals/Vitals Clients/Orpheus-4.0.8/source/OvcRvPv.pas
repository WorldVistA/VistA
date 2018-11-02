{******************************************************************}
{******************************************************************}
{*       OvcRvPv.PAS - Report View Print Preview                  *}
{******************************************************************}
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


{ Global defines potentially affecting this unit }
{$I OVC.INC}

unit ovcrvpv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OvcRptVw, Buttons, ComCtrls;

type
  TOvcRVPrintPreview = class(TForm)
    Label3: TLabel;
    ZoomCombo: TComboBox;
    PaperPanel: TPanel;
    PaintBox1: TPaintBox;
    Label4: TLabel;
    lblSection: TLabel;
    btnPrevSection: TBitBtn;
    btnNextSection: TBitBtn;
    StatusBar1: TStatusBar;
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure edtPageChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ZoomComboChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnPrevSectionClick(Sender: TObject);
    procedure btnNextSectionClick(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnFirstClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  published
    Panel1: TPanel;
    btnPrint: TButton;
    btnFirst: TBitBtn;
    btnPrev: TBitBtn;
    btnNext: TBitBtn;
    btnLast: TBitBtn;
    btnClose: TButton;
    edtPage: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblMaxPage: TLabel;
    ScrollBox1: TScrollBox;
    procedure FormShow(Sender: TObject);
    procedure SetCurPage(const Value: Integer);
    procedure SetCurSection(const Value: Integer);
  protected
    FScale: double;
    FZoom: Integer;
    FPageNo: Integer;
    FSectionNo: Integer;
    procedure SetZoom(const Value: Integer);
    procedure ResizeCanvas;
    procedure AlignPaper;
  public
    FCurPage: Integer;
    FCurSection: Integer;
    FPageCount: Integer;
    FSectionCount: Integer;
    FPrintMode : TRVPrintMode;
    FSelectedOnly : Boolean;
    FLineHeight: Integer;
    FLinesPerPage: Integer;
    OwnerReport: TOvcCustomReportView;
    property CurPage: Integer read FCurPage write SetCurPage;
    property CurSection: Integer read FSectionNo write SetCurSection;
    procedure RenderPage(PageNo, SectionNo: Integer);
    property Zoom: Integer read FZoom write SetZoom;
    property Scale: double read FScale;
  end;

implementation
uses
  Math,
  Printers;

{$R *.DFM}

procedure TOvcRVPrintPreview.FormShow(Sender: TObject);
begin
  CurPage := 1;
  CurSection := 1;
  Zoom := 100;
  ResizeCanvas;
  RenderPage(CurPage, CurSection);
end;

procedure TOvcRVPrintPreview.RenderPage(PageNo, SectionNo: Integer);
begin
  FPageNo := PageNo;
  FSectionNo := SectionNo;
  PaintBox1.Invalidate;
end;

procedure TOvcRVPrintPreview.btnFirstClick(Sender: TObject);
begin
  CurPage := 1;
end;

procedure TOvcRVPrintPreview.btnPrevClick(Sender: TObject);
begin
  CurPage := CurPage - 1;
end;

procedure TOvcRVPrintPreview.SetCurPage(const Value: Integer);
begin
  if (Value <> FCurPage)
  and (Value >= 1)
  and (Value <= FPageCount) then begin
    FCurPage := Value;
    RenderPage(Value, FCurSection);
    edtPage.Text := IntToStr(CurPage);
  end;
end;

procedure TOvcRVPrintPreview.SetCurSection(const Value: Integer);
begin
  if (Value <> FCurSection)
  and (Value >= 1)
  and (Value <= FSectionCount) then begin
    FCurSection := Value;
    RenderPage(FCurPage, Value);
    lblSection.Caption := IntToStr(Value) + ' of ' + IntToStr(FSectionCount);
  end;
end;

procedure TOvcRVPrintPreview.btnNextClick(Sender: TObject);
begin
  CurPage := CurPage + 1;
end;

procedure TOvcRVPrintPreview.btnLastClick(Sender: TObject);
begin
  CurPage := FPageCount;
end;

procedure TOvcRVPrintPreview.edtPageChange(Sender: TObject);
begin
  CurPage := StrToInt(edtPage.Text);
end;

procedure TOvcRVPrintPreview.btnPrintClick(Sender: TObject);
begin
  OwnerReport.Print(FPrintMode, FSelectedOnly);
  Caption := 'Print preview - Document printed';
end;

procedure TOvcRVPrintPreview.PaintBox1Paint(Sender: TObject);
var
  MF: TMetaFile;
  MFC: TMetaFileCanvas;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
  MF := TMetaFile.Create;
  try
    MFC := TMetaFileCanvas.Create(MF, Printer.Handle);
    try
      MFC.Font.Assign(Printer.Canvas.Font);
      OwnerReport.RenderPageSection(MFC, FSelectedOnly, FLineHeight, FLinesPerPage, CurSection - 1, CurPage, True);
    finally
      MFC.Free;
    end;
    PaintBox1.Canvas.StretchDraw(PaintBox1.ClientRect, MF);
  finally
    MF.Free;
  end;
end;

procedure TOvcRVPrintPreview.ZoomComboChange(Sender: TObject);
var
  S: string;
begin
  with ZoomCombo do
    S := Items[ItemIndex];
  Zoom := StrToInt(copy(S, 1, length(S) - 1));
end;

procedure TOvcRVPrintPreview.FormCreate(Sender: TObject);
begin
  ZoomCombo.ItemIndex := 5;
end;

procedure TOvcRVPrintPreview.SetZoom(const Value: Integer);
begin
  FZoom := Value;
  FScale := Min(ScrollBox1.ClientHeight / Printer.PageHeight,
                ScrollBox1.ClientWidth / Printer.PageWidth) * FZoom / 100;
  ResizeCanvas;
  AlignPaper;
end;

procedure TOvcRVPrintPreview.ResizeCanvas;
begin
  ScrollBox1.HorzScrollBar.Position := 0;
  ScrollBox1.VertScrollBar.Position := 0;
  PaperPanel.Width := round(Printer.PageWidth * Scale);
  PaperPanel.Height := round(Printer.PageHeight * Scale);
  AlignPaper;
end;

procedure TOvcRVPrintPreview.AlignPaper;
begin
  if PaperPanel.Width < ScrollBox1.ClientWidth then
    PaperPanel.Left := ScrollBox1.ClientWidth div 2 - (PaperPanel.Width div 2)
  else
    PaperPanel.Left := 0;
  if PaperPanel.Height < ScrollBox1.ClientHeight then
    PaperPanel.Top := ScrollBox1.ClientHeight div 2 - (PaperPanel.Height div 2)
  else
    PaperPanel.Top := 0;
end;

procedure TOvcRVPrintPreview.FormResize(Sender: TObject);
begin
  SetZoom(Zoom); {force recalc of preview sizes}
end;

procedure TOvcRVPrintPreview.btnPrevSectionClick(Sender: TObject);
begin
  CurSection := CurSection - 1;
end;

procedure TOvcRVPrintPreview.btnNextSectionClick(Sender: TObject);
begin
  CurSection := CurSection + 1;
end;

procedure TOvcRVPrintPreview.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  S: string;
begin
  if Button = mbLeft then begin
    with ZoomCombo do
      if ItemIndex < Items.Count - 1 then begin
        ItemIndex := ItemIndex + 1;
        S := Items[ItemIndex];
        Zoom := StrToInt(copy(S, 1, length(S) - 1));
      end;
  end else
  if Button = mbRight then begin
    with ZoomCombo do
      if ItemIndex > 0 then begin
        ItemIndex := ItemIndex - 1;
        S := Items[ItemIndex];
        Zoom := StrToInt(copy(S, 1, length(S) - 1));
      end;
  end;
end;

procedure TOvcRVPrintPreview.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
