unit uCaseTree;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls, uSurgery, rSurgery;


type
  PCaseTreeObject = ^TCaseTreeObject;
  TCaseTreeObject = record
    // used for both types of node
    CaseID         : string;
    NodeText       : string;                  //Title, Location, Author (depends on node type)
    ImageCount     : integer;                 //Number of images
    DocHasChildren : string;                  //Has children  (+)
    DocParent      : string;                  //Parent document, or context
    // used for Case nodes only
    OperativeProc  : string;
    IsNonORProc    : boolean;
    SurgeryDate    : string;
    Surgeon        : string;
    // used for document nodes only
    DocID          : string ;                 //Document IEN
    DocDate        : string;                  //Formatted date of document
    DocTitle       : string;                  //Document Title Text
    VisitDate      : string;                  //ADM/VIS: date;FMDate
    DocFMDate      : string;                  //FM date of document
    Author         : string;                  //DUZ;Author name
    PkgRef         : string;                  //IEN;Package
    Location       : string;                  //Location name
    Status         : string;                  //Status
    Subject        : string;                  //Subject
    // not currently used
    OrderID        : string;                  //Order file IEN (consults only, for now)
    OrderByTitle   : boolean;                 //Within cases, order docs by title, not date
  end;

// Procedures for document treeviews/listviews
procedure CreateListItemsForCaseTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: boolean);
procedure BuildCaseTree(CaseList: TStrings; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          CaseContext: TSurgCaseContext);
procedure SetCaseTreeNodeImagesAndFormatting(Node: TORTreeNode; CurrentContext: TSurgCaseContext);
procedure SetImageFlag(ANode: TORTreeNode);
procedure ResetCaseTreeObjectStrings(AnObject: PCaseTreeObject);
procedure KillCaseTreeObjects(TreeView: TORTreeView);
procedure KillCaseTreeNode(ANode: TTreeNode);
procedure RemoveParentsWithNoChildren(Tree: TTreeView; Context: TSurgCaseContext);
function  MakeCaseTreeObject(x: string): PCaseTreeObject;

implementation

(*uses
  fRptBox;*)

{==============================================================
RPC [SURGERY CASES BY CONTEXT] returns
the following string '^' pieces:
===============================================================
CASE #^Operative Procedure^Date/Time of Operation^Surgeon^^^^^^^^^+^Context         ***NEEDS TO BE FIXED***
IEN NIR^TITLE^REF DATE/TIME^PT ID^AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^+ (if has addenda)^IEN of Parent Document
IEN AR^TITLE^REF DATE/TIME^PT ID^AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^+ (if has addenda)^IEN of Parent Document
IEN OS^TITLE^REF DATE/TIME^PT ID^AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^+ (if has addenda)^IEN of Parent Document
IEN Addendum^TITLE^REF DATE/TIME^PT ID^AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^^IEN of Parent Document*)

===============================================================}

procedure CreateListItemsForCaseTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: Boolean);
const
  NO_MATCHES = '^No Surgery Cases Found^^^^^^^^^^^%^0';
var
  i: Integer;
  x, x1, x2, x3, MyParent, MyType: string;
  AList, SrcList: TStringList;
begin
  AList := TStringList.Create;
  SrcList := TStringList.Create;
  try
    //ReportBox(Source, '', True);
    FastAssign(Source, SrcList);
    with SrcList do
      begin
        if (Count = 1) and (Piece(SrcList[0], U, 1) = '-1') then
          begin
            Dest.Insert(0, IntToStr(Context) + NO_MATCHES);
            Exit;
          end;
        for i := 0 to Count - 1 do
          begin
            x := Strings[i];
            if Piece(x, U, 10) <> '' then      // if item is a note, and is missing information
              begin
                if Piece(x, U, 2) = '' then
                  SetPiece(x, U, 2, '** No title **');
                if Piece(x, U, 6) = '' then
                  SetPiece(x, U, 6, '** No location **');
                if Piece(Piece(x, U, 5), ';', 3) = '' then
                  SetPiece(x, U, 5, '0;** No Author **;** No Author **');
              end;
            MyParent   := Piece(x, U, 14);
            if GroupBy <> '' then case GroupBy[1] of
              'D':  begin
                      x2 := Piece(x, U, 3);                          // Proc date (FM)
                      if x2 = '' then
                        begin
                          x2 := '** No Date **';
                          x1 := '** No Date **';
                        end
                      else
                        x1 := FormatFMDateTime('dddddd', StrToFloat(x2));  // Proc date
                      if MyParent = IntToStr(Context) then
                        SetPiece(x, U, 14, MyParent + x2);
                      x3 := x2 + U + MixedCase(x1) + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;
              'P':  begin
                      x1 := Piece(x, U, 2);
                      if x1 = '' then x1 := '** No Procedure **';
                      if MyParent = IntToStr(Context) then
                        SetPiece(x, U, 14, MyParent + x1);
                      x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;
              'S':  begin
                      x1 := Piece(Piece(x, U, 4), ';', 2);
                      if x1 = '' then x1 := '** No Surgeon **';
                      if MyParent = IntToStr(Context) then
                        SetPiece(x, U, 14, MyParent + x1);
                      x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;
              'T':  begin
                      if MyParent = IntToStr(Context) then
                      begin
                        if Piece(x, U, 6) = '1' then
                          MyType := 'Non-OR Procedures'
                        else
                          MyType := 'Operations';
                        SetPiece(x, U, 14, MyParent + MyType);
                        x3 := MyType + U + MyType + U + IntToStr(Context);
                        if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                      end;
                    end;
            end;
            Dest.Add(x);
          end; {for}
        SortByPiece(TStringList(Dest), U, 3);
        if not Ascending then InvertStringList(TStringList(Dest));
        Dest.Insert(0, IntToStr(Context) + '^' + SG_TV_TEXT + '^^^^^^^^^^^%^0');
        Alist.Sort;
        if Ascending or (CharAt(GroupBy, 1) = 'T') then InvertStringList(AList);   // operations before non-OR procs
        for i := 0 to AList.Count-1 do
          Dest.Insert(0, IntToStr(Context) + Piece(AList[i], U, 1) + '^' + Piece(AList[i], U, 2) + '^^^^^^^^^^^%^' + Piece(AList[i], U, 3));
      end;
      //ReportBox(Dest, '', True);
  finally
    AList.Free;
    SrcList.Free;
  end;
end;

procedure BuildCaseTree(CaseList: TStrings; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          CaseContext: TSurgCaseContext);
var
  MyID, MyParent, Name: string;
  i: Integer;
  ChildNode, tmpNode: TORTreeNode;
  CaseHasChildren: Boolean;
  AnObject: PCaseTreeObject;
begin
  with CaseList do for i := 0 to Count - 1 do
    begin
      tmpNode := nil;
      MyParent := Piece(Strings[i], U, 14);
      if (MyParent = Parent) then
        begin
          MyID := Piece(Strings[i], U, 1);
          if Piece(Strings[i], U, 13) = '%' then
             Name := Piece(Strings[i], U, 2)
          else if Piece(Strings[i], U, 10) = '' then
             Name := MakeSurgeryCaseDisplayText(Strings[i])
          else
             Name := MakeSurgeryReportDisplayText(Strings[i]);
          CaseHasChildren := (Piece(Strings[i], U, 13) <> '');
          if Node <> nil then if Node.HasChildren then
            tmpNode := Tree.FindPieceNode(MyID, 1, U, Node);
          if (tmpNode <> nil) and tmpNode.HasAsParent(Node) then
            Continue
          else
            begin
              AnObject := MakeCaseTreeObject(Strings[i]);
              ChildNode := TORTreeNode(Tree.Items.AddChildObject(TORTreeNode(Node), Name, AnObject));
              ChildNode.StringData := Strings[i];
              SetCaseTreeNodeImagesAndFormatting(ChildNode, CaseContext);
              if CaseHasChildren then BuildCaseTree(CaseList, MyID, Tree, ChildNode, CaseContext);
            end;
        end;
    end;
end;

procedure SetCaseTreeNodeImagesAndFormatting(Node: TORTreeNode; CurrentContext: TSurgCaseContext);
var
  CaseNode: TORTreeNode;
  i: integer;
(*  IMG_SURG_BLANK             = 0;
    IMG_SURG_TOP_LEVEL         = 1;
    IMG_SURG_GROUP_SHUT        = 2;
    IMG_SURG_GROUP_OPEN        = 3;
    IMG_SURG_CASE_EMPTY        = 4;
    IMG_SURG_CASE_SHUT         = 5;
    IMG_SURG_CASE_OPEN         = 6;
    IMG_SURG_RPT_SINGLE        = 7;
    IMG_SURG_RPT_ADDM          = 8;
    IMG_SURG_ADDENDUM          = 9;
    IMG_SURG_NON_OR_CASE_EMPTY = 10;
    IMG_SURG_NON_OR_CASE_SHUT  = 11;
    IMG_SURG_NON_OR_CASE_OPEN  = 12;
*)
begin
  with Node, PCaseTreeObject(Node.Data)^ do
    begin
      i := Pos('*', DocTitle);
      if i > 0 then i := i + 1 else i := 0;
      if (Copy(DocTitle, i + 1, 8) = 'Addendum') then
        ImageIndex := IMG_SURG_ADDENDUM
      else if (DocHasChildren = '') then
        begin
          if PkgRef = '' then
            begin
              if IsNonORProc then
                ImageIndex := IMG_SURG_NON_OR_CASE_EMPTY
              else
                ImageIndex := IMG_SURG_CASE_EMPTY;
            end
          else
            ImageIndex := IMG_SURG_RPT_SINGLE;
        end
      else if DocParent = '0' then
        begin
          ImageIndex    := IMG_SURG_TOP_LEVEL;
          SelectedIndex := IMG_SURG_TOP_LEVEL;
          StateIndex := -1;
          with CurrentContext, Node do
            if GroupBy <> '' then
              case GroupBy[1] of
                'P': Text := SG_TV_TEXT + ' by Procedure';        
                'D': Text := SG_TV_TEXT + ' by Surgery Date';
                'S': Text := SG_TV_TEXT + ' by Surgeon';
                'T': Text := SG_TV_TEXT + ' by Type';
              end
            else Text := SG_TV_TEXT;
        end
      else
        case DocHasChildren[1] of
          '+': if PkgRef <> '' then
                 ImageIndex := IMG_SURG_RPT_ADDM
               else
                 begin
                   if IsNonORProc then
                     ImageIndex := IMG_SURG_NON_OR_CASE_SHUT
                   else
                     ImageIndex := IMG_SURG_CASE_SHUT;
                 end;
          '%': begin
                 StateIndex := -1;
                 ImageIndex    := IMG_SURG_GROUP_SHUT;
                 SelectedIndex := IMG_SURG_GROUP_OPEN;
               end;
        end;
      SelectedIndex := ImageIndex;
      SetImageFlag(Node);
      CaseNode := TORTreeView(Node.TreeView).FindPieceNode(CaseID, 1, U, nil);
      if CaseNode <> nil then
        begin
          PCaseTreeObject(CaseNode.Data)^.ImageCount := PCaseTreeObject(CaseNode.Data)^.ImageCount + ImageCount;
          SetImageFlag(CaseNode);
        end;
    end;
end;

procedure SetImageFlag(ANode: TORTreeNode);
begin
  with ANode, PCaseTreeObject(ANode.Data)^ do
    begin
      if (ImageIndex in [IMG_SURG_TOP_LEVEL, IMG_SURG_GROUP_OPEN, IMG_SURG_GROUP_SHUT]) then
        StateIndex := IMG_NO_IMAGES
      else
        begin
          if ImageCount > 0 then
            StateIndex := IMG_1_IMAGE
          else if ImageCount = 0 then
            StateIndex := IMG_NO_IMAGES
          else if ImageCount = -1 then
            StateIndex := IMG_IMAGES_HIDDEN;
        end;
(*      else
        case ImageCount of
          0: StateIndex := IMG_NO_IMAGES;
          1: StateIndex := IMG_1_IMAGE;
          2: StateIndex := IMG_2_IMAGES;
        else
          StateIndex := IMG_MANY_IMAGES;
        end;*)
      if (Parent <> nil) and
         (Parent.ImageIndex in [IMG_SURG_CASE_SHUT, IMG_SURG_CASE_OPEN, IMG_SURG_RPT_ADDM,
                                IMG_SURG_NON_OR_CASE_SHUT, IMG_SURG_NON_OR_CASE_OPEN ]) and
         (StateIndex in [IMG_1_IMAGE, IMG_IMAGES_HIDDEN]) then
         begin
           Parent.StateIndex := IMG_CHILD_HAS_IMAGES;
         end;
    end;
end;

procedure ResetCaseTreeObjectStrings(AnObject: PCaseTreeObject);
begin
  with AnObject^ do
    begin
      CaseID         := '';
      OperativeProc  := '';
      SurgeryDate    := '';
      Surgeon        := '';
      DocID          := '';
      DocDate        := '';
      DocTitle       := '';
      NodeText       := '';
      VisitDate      := '';
      DocFMDate      := '';
      DocHasChildren := '';
      DocParent      := '';
      Author         := '';
      PkgRef         := '';
      Location       := '';
      Status         := '';
      Subject        := '';
      OrderID        := '';
    end;
end;

procedure KillCaseTreeObjects(TreeView: TORTreeView);
var
  i: integer;
begin
  with TreeView do
    for i := 0 to Items.Count-1 do
    begin
      if(Assigned(Items[i].Data)) then
        begin
          ResetCaseTreeObjectStrings(PCaseTreeObject(Items[i].Data));
          Dispose(PCaseTreeObject(Items[i].Data));
          Items[i].Data := nil;
        end;
    end;
end;

procedure KillCaseTreeNode(ANode: TTreeNode);
begin
  if(Assigned(ANode.Data)) then
    begin
      ResetCaseTreeObjectStrings(PCaseTreeObject(ANode.Data));
      Dispose(PCaseTreeObject(ANode.Data));
      ANode.Data := nil;
    end;
  ANode.Owner.Delete(ANode);
end;

procedure RemoveParentsWithNoChildren(Tree: TTreeView; Context: TSurgCaseContext);
var
  n: integer;
begin
  with Tree do
    for n := Items.Count - 1 downto 0 do
      if (Items[n].ImageIndex in  [IMG_SURG_GROUP_SHUT, IMG_SURG_GROUP_OPEN]) then
        begin
          if (not Items[n].HasChildren) then
             KillCaseTreeNode(Items[n]);
        end;
end;


function MakeCaseTreeObject(x: string): PCaseTreeObject;
var
  AnObject: PCaseTreeObject;
begin
  New(AnObject);
  with AnObject^ do
    begin
      if Piece(x, U, 10) = '' then
        //CASE #^Operative Procedure^Date/Time of Operation^Surgeon^^^^^^^^^+^Context   
        begin
          CaseID          := Piece(x, U, 1);
          OperativeProc   := Piece(x, U, 2);
          SurgeryDate     := Piece(x, U, 3);
          Surgeon         := Piece(x, U, 4);
          IsNonORProc     := Piece(x, U, 6) = '1';
          DocHasChildren  := Piece(x, U, 13);
          DocParent       := Piece(x, U, 14);
          ImageCount      := StrToIntDef(Piece(x, U, 11), 0);
          NodeText        := MakeSurgeryCaseDisplayText(x);
        end
      else
        //IEN NIR^TITLE^REF DATE/TIME^PT ID^AUTHORDUZ;AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^+ (if has addenda)^IEN of Parent Document
        //IEN AR^TITLE^REF DATE/TIME^PT ID^AUTHORDUZ;AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^+ (if has addenda)^IEN of Parent Document
        //IEN OS^TITLE^REF DATE/TIME^PT ID^AUTHORDUZ;AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^+ (if has addenda)^IEN of Parent Document
        //IEN Addendum^TITLE^REF DATE/TIME^PT ID^AUTHORDUZ;AUTHOR^HOSP LOC^STATUS^Vis DT^Disch DT^CASE;SRF(^# Assoc Images^Subject^^IEN of Parent Document
        begin
          DocID           := Piece(x, U, 1);
          DocTitle        := Piece(x, U, 2);
          DocFMDate       := Piece(x, U, 3);
          DocDate         := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3)));
          Author          := Piece(x, U, 5);
          Location        := Piece(x, U, 6);
          Status          := Piece(x, U, 7);
          VisitDate       := Piece(x, U, 8);
          PkgRef          := Piece(x, U, 10);
          CaseID          := Piece(Piece(x, U, 10), ';', 1);
          ImageCount      := StrToIntDef(Piece(x, U, 11), 0);
          Subject         := Piece(x, U, 12);
          DocHasChildren  := Piece(x, U, 13);
          DocParent       := Piece(x, U, 14);
          NodeText        := MakeSurgeryReportDisplayText(x);
        end;
    end;
  Result := AnObject;
end;


end.
