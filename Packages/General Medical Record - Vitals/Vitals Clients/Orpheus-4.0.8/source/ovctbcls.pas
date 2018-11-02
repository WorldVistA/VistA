{*********************************************************}
{*                  OVCTBCLS.PAS 4.06                    *}
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
{* Roman Kassebaum                                                            *}
{* Patrick Lajko/CDE Software                                                 *}
{* Sebastian Zierer                                                           *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctbcls;
  {-Table column, column array classes}

interface

uses
  Windows, SysUtils, Graphics, Classes, Controls, Forms,
  OvcConst, OvcTCmmn, OvcTCell;

type
  TOvcTableColumnClass = class of TOvcTableColumn;
  TOvcTableColumn = class(TPersistent)
    protected {private}
      {property fields-even size}
      FDefCell  : TOvcBaseTableCell;
      FNumber   : TColNum;
      FOnColumnChanged : TColChangeNotifyEvent;
      FTable    : TOvcTableAncestor;
      FWidth    : Integer;
      {property fields-odd size}
      FHidden   : boolean;
      FShowRightLine{Filler}    : Boolean {byte};

    protected
      {property access}
      procedure SetDefCell(BTC : TOvcBaseTableCell);
      procedure SetHidden(H : boolean);
      procedure SetShowRightLine(H : boolean); //CDE
      procedure SetWidth(W : Integer);

      {miscellaneous}
      procedure tcDoColumnChanged;
      procedure tcNotifyCellDeletion(Cell : TOvcBaseTableCell);

    public {protected}
      {internal only usage}
      property Number : TColNum
         read FNumber write FNumber;
      property OnColumnChanged : TColChangeNotifyEvent
         write FOnColumnChanged;

    public
      procedure Assign(Source : TPersistent); override;
      constructor Create(ATable : TOvcTableAncestor); virtual;
      destructor Destroy; override;

      {properties}
      property Table : TOvcTableAncestor
         read FTable;

    published
      {properties for streaming}
      property DefaultCell: TOvcBaseTableCell
         read FDefCell write SetDefCell;

      property Hidden : boolean
        read FHidden write SetHidden;
      property ShowRightLine : boolean
        read FShowRightLine write SetShowRightLine default true; //CDE

      property Width  : Integer
         read FWidth write SetWidth;
  end;

  TOvcTableColumns = class(TPersistent)
    protected {private}
      {property fields}
      FList   : TList;
      FOnColumnChanged: TColChangeNotifyEvent;
      FFixups : TStringList;
      FTable  : TOvcTableAncestor;

      {other fields}
      tcColumnClass : TOvcTableColumnClass;

    protected
      {property access}
      function GetCol(ColNum : TColNum) : TOvcTableColumn;
      function GetCount : Integer;
      function GetDefaultCell(ColNum : TColNum) : TOvcBaseTableCell;
      function GetHidden(ColNum : TColNum) : boolean;
      function GetShowRightLine(ColNum : TColNum) : boolean; //CDE
      function GetWidth(ColNum : TColNum) : Integer;

      procedure SetCol(ColNum : TColNum; C : TOvcTableColumn);
      procedure SetCount(C : Integer);
      procedure SetDefaultCell(ColNum : TColNum; C : TOvcBaseTableCell);
      procedure SetHidden(ColNum : TColNum; H : boolean);
      procedure SetShowRightLine(ColNum : TColNum; H : boolean); //CDE
      procedure SetWidth(ColNum : TColNum; W : Integer);

      {event access}
      procedure SetOnColumnChanged(OC : TColChangeNotifyEvent);

      {other}
      procedure tcDoColumnChanged(ColNum1, ColNum2 : TColNum;
                                  Action : TOvcTblActions);

    public
      {internal only usage}
      procedure tcNotifyCellDeletion(Cell : TOvcBaseTableCell);
      function tcStartLoading : TStringList;
      procedure tcStopLoading;

      property OnColumnChanged : TColChangeNotifyEvent
         write SetOnColumnChanged;

    public
      constructor Create(ATable : TOvcTableAncestor; ANumber : Integer;
                         AColumnClass : TOvcTableColumnClass);
      destructor Destroy; override;

      procedure Append(C : TOvcTableColumn);
      procedure Clear;
      procedure Delete(ColNum : TColNum);
      procedure Exchange(ColNum1, ColNum2 : TColNum);
      procedure Insert(const ColNum : TColNum; C : TOvcTableColumn);

      property Count : Integer
         read GetCount write SetCount;

      property DefaultCell [ColNum : TColNum] : TOvcBaseTableCell
         read GetDefaultCell write SetDefaultCell;

      property Hidden [ColNum : TColNum] : boolean
         read GetHidden write SetHidden;

      property ShowRightLinex [ColNum : TColNum] : boolean
        read GetShowRightLine write SetShowRightLine;  //CDE
      property List [ColNum : TColNum] : TOvcTableColumn
         read GetCol write SetCol;
         default;

      property Table : TOvcTableAncestor
         read FTable write FTable;

      property Width [ColNum : TColNum] : Integer
         read GetWidth write SetWidth;
  end;

implementation


{===TOvcTableColumn=====================================================}
constructor TOvcTableColumn.Create(ATable : TOvcTableAncestor);
  begin
    inherited Create;
    FWidth := tbDefColWidth;
    FShowRightLine := True; //CDE
    FDefCell := nil;
    FTable := ATable;
  end;
{--------}
destructor TOvcTableColumn.Destroy;
  begin
    DefaultCell := nil;
    inherited Destroy;
  end;
{--------}
procedure TOvcTableColumn.Assign(Source : TPersistent);
  var
    Src : TOvcTableColumn absolute Source;
  begin
    if not (Source is TOvcTableColumn) then
      Exit;
    FWidth := Src.Width;
    FHidden := Src.Hidden;
    FShowRightLine := Src.ShowRightLine; //CDE
    DefaultCell := Src.DefaultCell;
  end;
{--------}
procedure TOvcTableColumn.tcDoColumnChanged;
  begin
    if Assigned(FOnColumnChanged) then
      FOnColumnChanged(Self, FNumber, 0, taSingle);
  end;
{--------}
procedure TOvcTableColumn.tcNotifyCellDeletion(Cell : TOvcBaseTableCell);
  begin
    if (Cell = FDefCell) then
      DefaultCell := nil;
  end;
{--------}
procedure TOvcTableColumn.SetDefCell(BTC : TOvcBaseTableCell);
  var
    DoIt : boolean;
  begin
    DoIt := false;
    if (BTC <> FDefCell) then
      if Assigned(BTC) then
        begin
          if (BTC.References = 0) or
             ((BTC.References > 0) and (BTC.Table = FTable)) then
            DoIt := true;
        end
      else
        DoIt := true;

    if DoIt then
      begin
        if Assigned(FDefCell) then
          FDefCell.DecRefs;
        FDefCell := BTC;
        if Assigned(FDefCell) then
          begin
            if (FDefCell.References = 0) then
              FDefCell.Table := FTable;
            FDefCell.IncRefs;
          end;
        tcDoColumnChanged;
      end;
  end;
{--------}
procedure TOvcTableColumn.SetHidden(H : boolean);
  begin
    if (H <> FHidden) then
      begin
        FHidden := H;
        tcDoColumnChanged;
      end;
  end;
{--------}
//CDE
procedure TOvcTableColumn.SetShowRightLine(H : boolean);
	begin
	  if (H <> FShowRightLine) then
		 begin
			FShowRightLine := H;
			tcDoColumnChanged;
		 end;
	end;
{--------}
procedure TOvcTableColumn.SetWidth(W : Integer);
  begin
    if (W <> FWidth) then
      begin
        FWidth := W;
        tcDoColumnChanged;
      end;
  end;
{====================================================================}



{===TOvcTableColumns=======================================================}
constructor TOvcTableColumns.Create(ATable : TOvcTableAncestor;
                                    ANumber : Integer;
                                    AColumnClass : TOvcTableColumnClass);
  var
    i : Integer;
    Col : TOvcTableColumn;
  begin
    inherited Create;
    FTable := ATable;
    FList := TList.Create;
    tcColumnClass := AColumnClass;
    for i := 0 to pred(ANumber) do
      begin
        Col := AColumnClass.Create(FTable);
        Col.Number := i;
        Append(Col);
      end;
  end;
{--------}
destructor TOvcTableColumns.Destroy;
  begin
    if Assigned(FList) then
      begin
        OnColumnChanged := nil;
        Clear;
        FList.Free;
      end;
    FFixups.Free;
  end;
{--------}
procedure TOvcTableColumns.Append(C : TOvcTableColumn);
  begin
    if (C.Table <> FTable) or (not (C is tcColumnClass)) then
      Exit;
    C.Number := FList.Count;
    FList.Add(C);
    C.OnColumnChanged := FOnColumnChanged;
    tcDoColumnChanged(C.Number, 0, taInsert);
  end;
{--------}
procedure TOvcTableColumns.Clear;
  var
    i : Integer;
  begin
    for i := 0 to pred(FList.Count) do
      TOvcTableColumn(FList[i]).Free;
    FList.Clear;
    tcDoColumnChanged(0, 0, taAll);
  end;
{--------}
procedure TOvcTableColumns.Delete(ColNum : TColNum);
  var
    i : integer;
  begin
    if (0 <= ColNum) and (ColNum < FList.Count) then
      begin
        TOvcTableColumn(FList[ColNum]).Free;
        FList.Delete(ColNum);
        for i := 0 to pred(FList.Count) do
          TOvcTableColumn(FList[i]).Number := i;
        tcDoColumnChanged(ColNum, 0, taDelete);
        if Assigned(FFixups) then
          if (ColNum < FFixups.Count) then
            FFixups.Delete(ColNum);
      end;
  end;
{--------}
procedure TOvcTableColumns.Exchange(ColNum1, ColNum2 : TColNum);
  var
    Temp1, Temp2 : pointer;
  begin
    if (ColNum1 <> ColNum2) and
       (0 <= ColNum1) and (ColNum1 < FList.Count) and
       (0 <= ColNum2) and (ColNum2 < FList.Count) then
      begin
        Temp1 := FList[ColNum1];
        Temp2 := FList[ColNum2];
        TOvcTableColumn(Temp1).Number := ColNum2;
        TOvcTableColumn(Temp2).Number := ColNum1;
        FList[ColNum1] := Temp2;
        FList[ColNum2] := Temp1;
        tcDoColumnChanged(ColNum1, ColNum2, taExchange);
      end;
  end;
{--------}
function TOvcTableColumns.GetCol(ColNum : TColNum) : TOvcTableColumn;
  begin
    if (0 <= ColNum) and (ColNum < FList.Count) then
      Result := TOvcTableColumn(FList[ColNum])
    else
      Result := nil;
  end;
{--------}
function TOvcTableColumns.GetCount : Integer;
  begin
    Result := FList.Count;
  end;
{--------}
function TOvcTableColumns.GetDefaultCell(ColNum : TColNum) : TOvcBaseTableCell;
  begin
    Result := nil;
    if (0 <= ColNum) and (ColNum < FList.Count) then
      Result := TOvcTableColumn(FList[ColNum]).DefaultCell;
  end;
{--------}
function TOvcTableColumns.GetHidden(ColNum : TColNum) : boolean;
  begin
    Result := True;
    if (0 <= ColNum) and (ColNum < FList.Count) then
      Result := TOvcTableColumn(FList[ColNum]).Hidden;
  end;
{--------}
//CDE
function TOvcTableColumns.GetShowRightLine(ColNum : TColNum) : boolean;
	begin
	  Result := True;
	  if (0 <= ColNum) and (ColNum < FList.Count) then
		 Result := TOvcTableColumn(FList[ColNum]).ShowRightLine;
	end;
{--------}
function TOvcTableColumns.GetWidth(ColNum : TColNum) : Integer;
  begin
    Result := 0;
    if (0 <= ColNum) and (ColNum < FList.Count) then
      Result := TOvcTableColumn(FList[ColNum]).Width;
  end;
{--------}
procedure TOvcTableColumns.Insert(const ColNum : TColNum;
                                  C : TOvcTableColumn);
  var
    i : integer;
  begin
    if (C.Table <> FTable) or (not (C is tcColumnClass)) then
      Exit;
    if (0 <= ColNum) and (ColNum < FList.Count) then
      begin
        FList.Insert(ColNum, C);
        for i := 0 to pred(FList.Count) do
          TOvcTableColumn(FList[i]).Number := i;
        C.OnColumnChanged := FOnColumnChanged;
        tcDoColumnChanged(ColNum, 0, taInsert);
        if Assigned(FFixups) then begin
          FFixups.Insert(ColNum, 'unknown');
          FFixups.Objects[ColNum] := C;
        end;
      end;
  end;
{--------}
procedure TOvcTableColumns.tcDoColumnChanged(ColNum1, ColNum2 : TColNum;
                                             Action : TOvcTblActions);
  begin
    if Assigned(FOnColumnChanged) then
      FOnColumnChanged(Self, ColNum1, ColNum2, Action);
  end;
{--------}
procedure TOvcTableColumns.tcNotifyCellDeletion(Cell : TOvcBaseTableCell);
  var
    ColNum : TColNum;
  begin
    for ColNum := 0 to pred(FList.Count) do
      TOvcTableColumn(FList[ColNum]).tcNotifyCellDeletion(Cell);
  end;
{--------}
procedure TOvcTableColumns.SetCol(ColNum : TColNum; C : TOvcTableColumn);
  var
    PC : TOvcTableColumn;
  begin
    if (C.Table <> FTable) or (not (C is tcColumnClass)) then
      Exit;
    if (0 <= ColNum) and (ColNum < FList.Count) then
      begin
        PC := GetCol(ColNum);
        PC.Assign(C);
      end;
  end;
{--------}
procedure TOvcTableColumns.SetCount(C : Integer);
  var
    ColNum : TColNum;
    Col : TOvcTableColumn;
  begin
    if (C > 0) and (C <> Count) then
      if (C < Count) then
        begin
          {must destroy the end set of columns}
          for ColNum := pred(Count) downto C do
            Delete(ColNum);
        end
      else {C > Count}
        begin
          {must add some new columns on the end}
          for ColNum := Count to pred(C) do
            begin
              Col := tcColumnClass.Create(FTable);
              Col.Number := ColNum;
              Append(Col);
            end;
        end;
  end;
{--------}
procedure TOvcTableColumns.SetDefaultCell(ColNum : TColNum; C : TOvcBaseTableCell);
  begin
    if (0 <= ColNum) and (ColNum < FList.Count) then
      TOvcTableColumn(FList[ColNum]).DefaultCell := C;
  end;
{--------}
procedure TOvcTableColumns.SetHidden(ColNum : TColNum; H : boolean);
  begin
    if (0 <= ColNum) and (ColNum < FList.Count) then
      TOvcTableColumn(FList[ColNum]).Hidden := H;
  end;
{--------}
//CDE
procedure TOvcTableColumns.SetShowRightLine(ColNum : TColNum; H : boolean);
	begin
	  if (0 <= ColNum) and (ColNum < FList.Count) then
		 TOvcTableColumn(FList[ColNum]).ShowRightLine := H;
	end;
{--------}
procedure TOvcTableColumns.SetOnColumnChanged(OC : TColChangeNotifyEvent);
  var
    i : Integer;
  begin
    FOnColumnChanged := OC;
    for i := 0 to pred(FList.Count) do
      TOvcTableColumn(FList[i]).OnColumnChanged := OC;
  end;
{--------}
procedure TOvcTableColumns.SetWidth(ColNum : TColNum; W : Integer);
  begin
    if (0 <= ColNum) and (ColNum < FList.Count) then
      TOvcTableColumn(FList[ColNum]).Width := W;
  end;
{--------}
function TOvcTableColumns.tcStartLoading : TStringList;
  begin
    if Assigned(FFixups) then
      FFixups.Clear
    else
      FFixups := TStringList.Create;
    Result := FFixups;
  end;
{--------}
procedure TOvcTableColumns.tcStopLoading;
  {------}
  function GetImmediateParentForm(Control : TControl) : TWinControl;
    var
      ParentCtrl : TControl;
    begin
      ParentCtrl := Control.Parent;
      while (Assigned(ParentCtrl)) and
            (not (ParentCtrl is TCustomForm))
            and (not (ParentCtrl is TCustomFrame))
            do
        ParentCtrl := ParentCtrl.Parent;
      Result := TForm(ParentCtrl);
    end;
  {------}
  function GetFormName(const S, FormName : string) : string;
    var
      PosDot : integer;
    begin
      PosDot := Pos('.', S);
      if (PosDot <> 0) then
        Result := Copy(S, 1, pred(PosDot))
      else
        Result := FormName;
    end;
  {------}
  function FormNamesEqual(const CmptFormName, FormName : string) : boolean;
    var
      PosUL : integer;
    begin
      Result := true;
      if (FormName = '') or (CmptFormName = FormName) then
        Exit;
      PosUL := length(FormName);
      while (PosUL > 0) and (FormName[PosUL] <> '_') do
        dec(PosUL);
      if (PosUL > 0) then
        if (CmptFormName = Copy(FormName, 1, pred(PosUL))) then
          Exit;
      Result := false;
    end;
  {------}
  function GetComponentName(const S : string) : string;
    var
      PosDot : integer;
    begin
      PosDot := Pos('.', S);
      if (PosDot <> 0) then
        Result := Copy(S, succ(PosDot), length(S))
      else
        Result := S;
    end;
  {------}
  var
    i      : integer;
    Form   : TWinControl;
    Compnt : TComponent;
    DM     : integer;
    DataMod: TDataModule;
    DMCount: integer;
  begin
    {if there's nothing to fix up, exit now}
    if not Assigned(FFixups) then
      Exit;
    {fixup references to cell components on the table's form}
    try
      Form := GetImmediateParentForm(FTable);
      for i := pred(FFixups.Count) downto 0 do
        if FormNamesEqual(GetFormName(FFixups[i], Form.Name),
                          Form.Name) then
          begin
            Compnt := Form.FindComponent(GetComponentName(FFixups[i]));
            if Assigned(Compnt) and (Compnt is TOvcBaseTableCell) then
              begin
                TOvcTableColumn(FFixups.Objects[i]).DefaultCell := TOvcBaseTableCell(Compnt);
                FFixups.Delete(i);
              end;
          end;
    {fixup references to cell components on any data modules}
    if (FFixups.Count <> 0) then begin
      DM := 0;
      DMCount := Screen.DataModuleCount;
      while (FFixups.Count > 0) and (DM < DMCount) do begin
        DataMod := Screen.DataModules[DM];
        for i := pred(FFixups.Count) downto 0 do
          if (GetFormName(FFixups[i], Form.Name) = DataMod.Name) then begin
            Compnt := DataMod.FindComponent(GetComponentName(FFixups[i]));
            if Assigned(Compnt) and (Compnt is TOvcBaseTableCell) then begin
              TOvcTableColumn(FFixups.Objects[i]).DefaultCell
                := TOvcBaseTableCell(Compnt);
              FFixups.Delete(i);
            end;
          end;
        inc(DM);
      end;
    end;
    finally
      FFixups.Free;
      FFixups := nil;
    end;
  end;
{====================================================================}

end.
