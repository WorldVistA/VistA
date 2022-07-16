unit uSizing;

interface
uses
  VCL.StdCtrls, vcl.ComCtrls, vcl.ExtCtrls, vcl.Controls, Forms;

const
  GAP = 8;

procedure adjustBtn(aBtn: TButton;IncludeParent:Boolean = false);
procedure adjustToolPanel(aPanel: TPanel);

function getMainFormTextHeight: Integer;
function getMainFormTextWidth(aText: String): Integer;

function getLabelTextWidth(aLabel: TLabel): Integer;
function getLabelHeight(aLabel: TLabel): Integer;
function getLabelWidth(aLabel: TLabel): Integer;

function getStaticTextHeight(aLabel: TStaticText): Integer;
function getStaticTextWidth(aLabel: TStaticText): Integer;

implementation

procedure adjustToolPanel(aPanel:TPanel);
var
  i: Integer;
  cntrl: TControl;
begin
  for i := 0 to aPanel.ControlCount - 1 do
    begin
      cntrl := aPanel.Controls[i];
      if cntrl is TButton then
        AdjustBtn(TButton(cntrl),true);
    end;
end;

procedure adjustBtn(aBtn: TButton; IncludeParent: Boolean = false);
var
  i: Integer;
begin
  aBtn.Width := getMainFormTextWidth(aBtn.Caption) + GAP * 2;
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

end.
