unit Vawrgrid;



interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids;

type
  TVAWrapGrid = class(TStringGrid)
  private
    { Private declarations }
    fHiddenCols: string;
    fHiddenColMap: string[255];
    procedure SetHiddenCols(Value:string);
  protected
    { Protected declarations }
    { This DrawCell procedure wraps text in the grid cell }
    procedure DrawCell(Col, Row : Longint; Rect : TRect; State : TGridDrawState); override ;
  public
    constructor Create(AOwner : TComponent); override ;
  published
    { Published declarations }
    property HiddenCols: string read fHiddenCols write SetHiddenCols;
  end;

procedure Register;

implementation

constructor TVAWrapGrid.Create(AOwner : TComponent);
begin
 { Create a TStringGrid }
 inherited Create(AOwner);
 HiddenCols:='';
  {change to bit map someday}
 fHiddenColMap:='';
end;


procedure TVAWrapGrid.SetHiddenCols(value:string);
var
 v,old:string;
 j:integer;
 procedure SetCol(val:string);
 var
  i:integer;
 begin
  i:=strtoint(val) + 1; {offset for 1 based string index}
  if (i in [1..255]) then fHiddenColMap[i]:='1';
 end;
begin
 old := String(fHiddenColMap); {save oldmap image}
 fHiddenCols:=Value;
 fHiddenColMap:='';  {reset the map}
 for j:=1 to 255 do
 fHiddenColMap:=fHiddenColMap + '0';
 while pos(',',value)>0 do
  begin
   v:=copy(value,1,pos(',',value)-1);
   SetCol(v);
   Delete(value,1,pos(',',value));
  end;
 if value <> '' then
  begin
   SetCol(value); {get the last piece}
   if not (csDesigning in componentstate) then
    invalidate;
  end;
 if old='' then exit;
 if (old <> String(fHiddenColMap)) and (not (csDesigning in componentState)) then
  begin
   j:=pos('1',old);
   while j > 0 do
    begin
     if fHiddenColMap[j]='0' then
      if pred(j) < colcount then colwidths[pred(j)]:=defaultcolwidth;
     old[j]:='0'; {get rid of hit}
     j:=pos('1',old);
    end;
  end;
end;


{ This DrawCell procedure wraps text in the grid cell }
procedure TVAWrapGrid.DrawCell(Col,Row: Longint; Rect: TRect; State: TGridDrawState);
var
  i, MaxRowHeight, CurrRowHeight, hgt, CellLen :integer;
  CellValue :PChar;
begin
  {don't display hidden cols}
  if RowHeights[Row] = 0 then exit;
  if (fHiddenColMap[succ(col)] = '1') and (not (csDesigning in componentstate)) then
    {disappear the column}
    begin
      if colwidths[col] > 0 then colwidths[col] := 0;
      exit;
    end;
  with Canvas do {not a hidden col}
    begin
      if colwidths[col]=0 then ColWidths[col] := defaultcolwidth;
      { Initialize the font to be the control's font }
      Canvas.Font       := Font;
      Canvas.Font.Color := Font.Color;
      {If this is a fixed cell, then use the fixed color }
      if gdFixed in State then
        begin
          Pen.Color   := FixedColor;
          Brush.Color := FixedColor;
          font.color  := self.font.color;
        end
      {if highlighted cell}
      else if (gdSelected in State) and
              (not (gdFocused in State) or
              ([goDrawFocusSelected, goRowSelect] * Options <> [])) then
        begin
          Brush.Color := clHighlight;
          Font.Color  := clHighlightText;
        end
      {else, use the normal color }
      else
        begin
          Pen.Color   := Color;
          Brush.Color := Color;
          font.color  := self.font.color;
        end;
      {Prepaint cell in cell color }
      FillRect(rect);
    end;

  CellValue := PChar(cells[col,row]);
  CellLen   := strlen(CellValue);

  {get cell size}
  Drawtext(canvas.handle,CellValue,CellLen,rect,DT_LEFT or DT_WORdbreak or DT_CALCRECT or DT_NOPREFIX);

  {Draw text in cell}
  Drawtext(canvas.handle,CellValue,CellLen,rect,DT_LEFT or DT_WORdbreak or DT_NOPREFIX);

  {adjust row heights up OR DOWN}
  MaxRowHeight  := DefaultRowHeight;
  CurrRowHeight := RowHeights[row];
  for i := pred(colcount) downto 0 do
    begin
      if (not (gdFixed in state)) then
        begin
          rect := cellrect(i,row);
          hgt  := Drawtext(canvas.handle,PChar(cells[i,row]),length(cells[i,row]),rect,DT_LEFT or
                        DT_WORdbreak or DT_CALCRECT or DT_NOPREFIX);
          if hgt > MaxRowHeight then MaxRowHeight := hgt;
        end;
    end;

  if MaxRowHeight <> CurrRowHeight then rowheights[row] := MaxRowHeight;

end;

procedure Register;
begin
   { You can change Samples to whichever part of the Component Palette you want
     to install this component to }
   RegisterComponents('CPRS', [TVAWrapGrid]);
end;

end.
