unit uSizing;

interface
uses
  VCL.StdCtrls, vcl.ComCtrls, vcl.ExtCtrls, vcl.Controls, Forms;

const
  GAP = 8;

procedure adjustBtn(aBtn: TButton;IncludeParent:Boolean = false);
procedure adjustToolPanel(aPanel: TPanel); overload;
procedure adjustToolPanel(aPanel: TPanel; out aWidth:Integer); overload;

function getMainFormTextHeight: Integer;
function getMainFormTextWidth(aText: String): Integer;

function getLabelTextWidth(aLabel: TLabel): Integer;
function getLabelHeight(aLabel: TLabel): Integer;
function getLabelWidth(aLabel: TLabel): Integer;

function getStaticTextHeight(aLabel: TStaticText): Integer;
function getStaticTextWidth(aLabel: TStaticText): Integer;

function getRectHeight(aRectWidth: Integer; aText: String): Integer;

implementation

uses
  WinAPI.Windows, System.Classes, Math;

procedure adjustToolPanel(aPanel:TPanel);
var
  i: Integer;
  cntrl: TControl;
begin
  for i := 0 to aPanel.ControlCount - 1 do
    begin
      cntrl := aPanel.Controls[i];
      if cntrl is TButton then
        AdjustBtn(TButton(cntrl), true);
    end;
end;

procedure adjustChkBox(aCkb: TCheckBox);
begin
  aCkb.Width := getMainFormTextWidth(aCkb.Caption) + GAP * 2 + 42;
  if aCkb.AlignWithMargins then
    aCkb.Width := aCkb.Width + aCkb.Margins.Left + aCkb.Margins.Right;
end;

procedure adjustLbl(aLbl: TLabel);
begin
  aLbl.Width := getMainFormTextWidth(aLbl.Caption) + GAP * 2;
  if aLbl.AlignWithMargins then
    aLbl.Width := aLbl.Width + aLbl.Margins.Left + aLbl.Margins.Right;
end;

procedure adjustStTxt(aTxt: TStaticText);
begin
  aTxt.Width := getMainFormTextWidth(aTxt.Caption) + GAP * 2;
  if aTxt.AlignWithMargins then
    aTxt.Width := aTxt.Width + aTxt.Margins.Left + aTxt.Margins.Right;
end;


procedure adjustToolPanel(aPanel: TPanel; out aWidth:Integer);
var
  cntrl: TControl;
begin
  aWidth := 0;
  for var i := 0 to aPanel.ControlCount - 1 do
    begin
      cntrl := aPanel.Controls[i];
      if cntrl is TButton then
        AdjustBtn(TButton(cntrl), true)
      else if cntrl is TCheckBox then
        AdjustChkBox(TCheckBox(cntrl))
      else if Cntrl is TLabel then
        AdjustLbl(TLabel(cntrl))
      else if cntrl is TStaticText then
        AdjustStTxt(TStaticText(cntrl))
      else
        continue;
      inc(aWidth, cntrl.Width);
    end;
end;

procedure adjustBtn(aBtn: TButton; IncludeParent: Boolean = false);
var
  i,j: Integer;
begin
  i := getMainFormTextWidth('Cancel');
  j := getMainFormTextWidth(aBtn.Caption);

  aBtn.Width := max(i,j) + GAP * 2;
  if aBtn.AlignWithMargins then
    aBtn.Width := aBtn.Width + aBtn.Margins.Left + aBtn.Margins.Right;

  aBtn.height := getMainFormTextHeight + GAP;

  if aBtn.AlignWithMargins then
    aBtn.height := aBtn.height + aBtn.Margins.Top + aBtn.Margins.Bottom;
  if IncludeParent and (aBtn.Parent is TPanel) then
  begin
    i := getMainFormTextHeight + GAP * 3;
    TPanel(aBtn.Parent).height := i;
    if TPanel(aBtn.Parent).AlignWithMargins then
      TPanel(aBtn.Parent).height := TPanel(aBtn.Parent).height +
        TPanel(aBtn.Parent).Margins.Top + TPanel(aBtn.Parent).Margins.Bottom;
  end;
end;


function getLabelHeight(aLabel: TLabel): Integer;
begin
  Result := 0;
  if aLabel.Visible then
  begin
    Result := getMainFormTextHeight + GAP div 2;
    if aLabel.AlignWithMargins then
      Result := Result + aLabel.Margins.Top + aLabel.Margins.Bottom;
  end;
end;

function getLabelTextWidth(aLabel: TLabel): Integer;
begin
  Result := 0;
  if Assigned(aLabel) then
    Result := aLabel.Canvas.TextWidth(aLabel.Caption);
end;

function getLabelWidth(aLabel: TLabel): Integer;
begin
  Result := 0;
  if aLabel.Visible then
  begin
    Result := getMainFormTextWidth(aLabel.Caption) + GAP;
    if aLabel.AlignWithMargins then
      Result := Result + aLabel.Margins.Left + aLabel.Margins.Right;
  end;
end;


function getMainFormTextHeight: Integer;
begin
  Result := 12;
  if Assigned(Application.MainForm) then
    Result := Application.MainForm.Canvas.TextHeight('qwerty1234567890');
end;

function getMainFormTextWidth(aText: String): Integer;
begin
  Result := 0;
  if Assigned(Application.MainForm) then
    Result := Application.MainForm.Canvas.TextWidth(aText);
end;


function getStaticTextHeight(aLabel: TStaticText): Integer;
begin
  Result := 0;
  if aLabel.Visible then
  begin
    Result := getMainFormTextHeight + GAP div 2;
    if aLabel.AlignWithMargins then
      Result := Result + aLabel.Margins.Top + aLabel.Margins.Bottom;
  end;
end;

function getStaticTextWidth(aLabel: TStaticText): Integer;
begin
  Result := 0;
  if aLabel.Visible then
  begin
    Result := getMainFormTextWidth(aLabel.Caption) + GAP;
    if aLabel.AlignWithMargins then
      Result := Result + aLabel.Margins.Left + aLabel.Margins.Right;
  end;
end;

function getRectHeight(aRectWidth: Integer; aText: String): Integer;
var
  r: TRect;
begin
  r := Rect(0, 0, aRectWidth, aRectWidth);
  DrawText(Application.MainForm.Canvas.Handle, PChar(aText), Length(aText), r,
    DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
  Result := r.Bottom - r.Top + 6; // Default margings
end;

end.
