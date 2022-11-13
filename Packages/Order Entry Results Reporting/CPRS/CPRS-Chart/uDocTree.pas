unit uDocTree;
{------------------------------------------------------------------------------
Update History
    2016-06-28: NSR#20070817 (CPRS Progress Notes Display Misleading)
-------------------------------------------------------------------------------}
interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls, uTIU, Dialogs;

type
  PDocTreeObject = ^TDocTreeObject;
  TDocTreeObject = record
    DocID          : string ;                 //Document IEN
    DocDate        : string;                  //Formatted date of document
    DocTitle       : string;                  //Document Title Text
    NodeText       : string;                  //Title, Location, Author  (depends on tab)
    ImageCount     : integer;                 //Number of images
    VisitDate      : string;                  //ADM/VIS: date;FMDate
    DocFMDate      : string;                  //FM date of document
    DocHasChildren : string;                  //Has children  (+,>,<)
    DocParent      : string;                  //Parent document, or context
    Author         : string;                  //DUZ;Author name
    PkgRef         : string;                  //IEN;Package    (consults only, for now)
    Location       : string;                  //Location name
    Status         : string;                  //Status
    Subject        : string;                  //Subject
    OrderID        : string;                  //Order file IEN (consults only, for now)
    OrderByTitle   : boolean;                 //Within ID Parents, order children by title, not date
    Orphaned       : boolean;                 //True if the parent no longer exist in the system
  end;

// Procedures for document treeviews/listviews
procedure CreateListItemsForDocumentTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: boolean; TabIndex: integer);
procedure BuildDocumentTree(DocList: TStrings; Tree:
          TORTreeView; TIUContext: TTIUContext; TabIndex: integer) ;
procedure SetTreeNodeImagesAndFormatting(Node: TORTreeNode; CurrentContext: TTIUContext; TabIndex: integer);
procedure ResetDocTreeObjectStrings(AnObject: PDocTreeObject);
procedure KillDocTreeObjects(TreeView: TORTreeView);
procedure KillDocTreeNode(ANode: TTreeNode);
function  ContextMatch(ANode: TORTreeNode; AParentID: string; AContext: TTIUContext): Boolean;
function  TextFound(ANode: TORTreeNode; CurrentContext: TTIUContext): Boolean;
procedure RemoveParentsWithNoChildren(Tree: TTreeView; Context: TTIUContext);
procedure TraverseTree(ATree: TTreeView; AListView: TListView; ANode: TTreeNode; MyNodeID: string;
          AContext: TTIUContext);
procedure AddListViewItem(ANode: TTreeNode; AListView: TListView);
function  MakeNoteTreeObject(x: string): PDocTreeObject;
function  MakeDCSummTreeObject(x: string): PDocTreeObject;
function  MakeConsultsNoteTreeObject(x: string): PDocTreeObject;


function getChildCount(aNode:TTreeNode): Integer;
function getNodeByName(aName:String;aLevel: Integer; tv: TTreeView):TTreeNode;
function getExpandStatus(aTree:TTreeView):TStringList;
procedure setExpandStatus(aNodes:TTreeNodes;aStatus:TStringList);
procedure RemoveDuplicates(const aList: TStringList);
procedure adjustOrder(aList: TStringList; Context: TTIUContext);
function FindTreeNodeByName(aTree:TORTreeView;aName:String):TORTreeNode;
procedure remapNode(aTree:TORTreeView;aName,aParentName:String);
procedure AutoSizeColumns(lv: TListView; cols: array of integer);
function ShowMoreNode(s: String): boolean;

implementation

uses
  rConsults, uDCSumm, uConsults, uMisc;

{==============================================================
RPC [TIU DOCUMENTS BY CONTEXT] returns
the following string '^' pieces:
===============================================================
      1 -  Document IEN
      2 -  Document Title
      3 -  FM date of document
      4 -  Patient Name
      5 -  DUZ;Author name
      6 -  Location
      7 -  Status
      8 -  ADM/VIS: date;FMDate
      9 -  Discharge Date;FMDate
      10 - Package variable pointer
      11 - Number of images
      12 - Subject
      13 - Has children
      14 - Parent document
      15 - Order children of ID Note by title rather than date
      16 - Orphaned
===============================================================}

procedure CreateListItemsForDocumentTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: Boolean; TabIndex: integer);
const
  NO_MATCHES = '^No Matching Documents Found^^^^^^^^^^^%^0';
var
  i: Integer;
  x, x1, x2, x3, MyParent, MyTitle, MyLocation{, MySubject}: string;
  AList, SrcList: TStringList;
  NotShowMore: boolean;

begin
  if not assigned(Dest) then
    ShowMessage('No destination list provided to CreateListItemsForDocumentTree!');

  if not assigned(Source) or (Source.Count<1) then
    Dest.Insert(0, IntToStr(Context) + '^' + NC_TV_TEXT[TabIndex, Context] + ' - No Matching Documents Found^^^^^^^^^^^%^0')
  else
 begin
  AList := TStringList.Create;
  SrcList := TStringList.Create;

  try
    FastAssign(Source, SrcList);
    with SrcList do
      begin
        for i := 0 to Count - 1 do
          begin
            x := Strings[i];
            if trim(x) = '' then
              continue;

            MyParent   := Piece(x, U, 14);
            MyTitle    := Piece(x, U, 2);
            NotShowMore := not ShowMoreNode(MyTitle);

            if Length(Trim(MyTitle)) = 0 then
              begin
                MyTitle := '** No Title **';
                SetPiece(x, U, 2, MyTitle);
              end;

            MyLocation := Piece(x, U, 6);
            if (Length(Trim(MyLocation)) = 0) and NotShowMore then
              begin
                MyLocation := '** No Location **';
                SetPiece(x, U, 6, MyLocation);
              end;

            if GroupBy <> '' then
              case GroupBy[1] of
                'D':  begin
                        x1 := Piece(Piece(x, U, 8), ';', 1);                    // Visit date
                        x2 := Piece(Piece(Piece(x, U, 8), ';', 2), '.', 1);     // Visit date (FM)   no time - v15.4
                        if (x2 = '') and NotShowMore then
                          begin
                            x2 := 'No Visit';
                            x1 := Piece(x1, ':', 1) + ':  No Visit';
                          end;
                        (*else
                          x1 := Piece(x1, ':', 1) + ':  ' + FormatFMDateTimeStr('mmm dd,yy@hh:nn',x2)*) //removed v15.4
                        if MyParent = IntToStr(Context) then
                          SetPiece(x, U, 14, MyParent + x2 + Copy(x1, 1, 3));    // '2980324Adm'
                        x3 := x2 + Copy(x1, 1, 3) + U + MixedCase(x1) + U + IntToStr(Context) + MixedCase(Copy(x1, 1, 3));
                      end;
                'L':  begin
                        if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                          SetPiece(x, U, 14, MyParent + MyLocation);          // split ID Notes by location
                        x3 := MyLocation + U + MixedCase(MyLocation) + U + IntToStr(Context);
                      end;
                'T':  begin
                        if (MyParent = IntToStr(Context)) and NotShowMore then                  // keep ID notes together, or
                          SetPiece(x, U, 14, MyParent + MyTitle);             // split ID Notes by title?
                        x3 := MyTitle + U + MixedCase(MyTitle) + U + IntToStr(Context);
                      end;
                'A':  begin
                        x1 := Piece(Piece(x, U, 5), ';', 3);
                        if (x1 = '') and NotShowMore then
                          x1 := '** No Author **';
                        if MyParent = IntToStr(Context) then
                          SetPiece(x, U, 14, MyParent + x1);
                        x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                      end;
                  end;

            if (GroupBy <> '') and (pos(copy(GroupBy,1,1),'DLTA')>0 )
              and (Copy(MyTitle, 1, 8) <> 'Addendum')
              and (AList.IndexOf(x3) = -1) // <-- check if the list may include duplicates?
            then
              AList.Add(x3);

            Dest.Add(x);
          end; {for}

        SortByPiece(Dest, U, 3);
        if not Ascending then
          InvertStringList(TStringList(Dest));

        if GroupBy <> '' then
          if GroupBy[1] ='D' then
          begin
            AList.Add('Adm^Inpatient Notes' + U + IntToStr(Context));
            AList.Add('Vis^Outpatient Notes' + U + IntToStr(Context));
          end;

        Dest.Insert(0, IntToStr(Context) + '^' + NC_TV_TEXT[TabIndex, Context] + '^^^^^^^^^^^%^0');

        Alist.Sort; // additional sort is performed by tree component

        if GroupBy <> '' then
          if (GroupBy[1] ='D') and (not Ascending) then
            InvertStringList(AList);

        for i := AList.Count-1 downto 0 do
          Dest.Insert(0, IntToStr(Context) + Piece(AList[i], U, 1) + '^' + Piece(AList[i], U, 2) + '^^^^^^^^^^^%^' + Piece(AList[i], U, 3));
      end;
  finally
    AList.Free;
    SrcList.Free;
  end;
 end;
end;

procedure BuildDocumentTree(DocList: TStrings; Tree:
  TORTreeView; TIUContext: TTIUContext; TabIndex: integer);

  type
    TBuildDocTree = record
      Name: string;
      ParentNode: TORTreeNode;
      MyNode: TORTreeNode;
      AnObject: PDocTreeObject;
    end;

 var
   OurDocTree: array of TBuildDocTree;
   ListOfParents: TStringList;
   LastRecCnt: Integer;
   newItems: TSTringList;

  function getParentByID(aName:String):TORTreeNode;
  var
    z: Integer;
  begin
    Result := nil;
      for z := Low(OurDocTree) to High(OurDocTree) do
      begin
        if (aName = UpperCase(Piece(OurDocTree[z].MyNode.StringData, U, 1))) and
          (not ShowMoreNode(OurDocTree[z].MyNode.StringData)) then
        begin
          Result := OurDocTree[z].MyNode;
          break;
        end;
      end;
  end;

  procedure MapTheParent(var ItemsToAdd, ParentList: TStringList);
  var
    i, j: Integer;
    ParentNode: TORTreeNode;
    NextParentList: TStringList;
    DocInfo,DocName,
    CurrentParentID,
    DocParentID, newParent:String;
  begin
    NextParentList := TStringList.Create;
    try
    //If we have no parents (first time) then add 0
    if ListOfParents.count < 1 then
      ListOfParents.add('0');

    //Loop though the parent list and find any nodes that need to be added
    for j := 0 to ListOfParents.Count - 1 do
    begin
      CurrentParentID := UpperCase(Piece(ListOfParents.Strings[j], U, 1));
      ParentNode := getParentByID(CurrentParentID);

      //Find any items from our remaining items list that is a child of this parent
      for i := 0 to DocList.count - 1 do
      begin
        DocInfo := DocList.Strings[i];
        DocParentID := UpperCase(Piece(DocInfo, U, 14));
        DocName := UpperCase(Piece(DocInfo, U, 2));
        if DocParentID = CurrentParentID then
        begin
          //Add to the virtual tree.
          //(ItemsToAdd contains documents with parents from the ParentList only.)
          ItemsToAdd.AddObject(DocInfo, ParentNode);

          //If this item is also a parent then we need to add it to our parent list for the next run through
          newParent := Piece(DocInfo, U, 13);
          if (newParent <> '') and (NextParentList.IndexOf(newParent)<0) then
            NextParentList.Add(DocInfo);
        end;
      end;
    end;

    ParentList.Assign(NextParentList);
    finally
      NextParentList.Free;
    end;
  end;

  procedure AddItemsToTree(ItemsToAdd:TStringList); //(ListOfParents: TStringList; Orphaned: Boolean);
  Var
   I, J: Integer;

  begin
   try
   //Now loop through all items that need to be added this go-around
   for i := 0 to ItemsToAdd.count - 1 do begin
    SetLength(OurDocTree, Length(OurDocTree) + 1);

      //Set up the name vaiable
      if Piece(ItemsToAdd.Strings[i], U, 13) <> '%' then
        case TabIndex of
          CT_NOTES: OurDocTree[High(OurDocTree)].Name := MakeNoteDisplayText(ItemsToAdd.Strings[i]);
          CT_CONSULTS: OurDocTree[High(OurDocTree)].Name := MakeConsultNoteDisplayText(ItemsToAdd.Strings
              [i]);
          CT_DCSUMM: OurDocTree[High(OurDocTree)].Name := MakeDCSummDisplayText(ItemsToAdd.Strings[i]);
        end
      else
        OurDocTree[High(OurDocTree)].Name := Piece(ItemsToAdd.Strings[i], U, 2);

      //Set up the actual node
      case TabIndex of
        CT_NOTES:  OurDocTree[High(OurDocTree)].AnObject := MakeNoteTreeObject(ItemsToAdd.Strings[i]);
        CT_CONSULTS: OurDocTree[High(OurDocTree)].AnObject := MakeConsultsNoteTreeObject(ItemsToAdd.Strings
            [i]);
        CT_DCSUMM: OurDocTree[High(OurDocTree)].AnObject := MakeDCSummTreeObject(ItemsToAdd.Strings[i]);
      else
        OurDocTree[High(OurDocTree)].AnObject := nil;
      end;

      //Now create this node using the ParentObject
      OurDocTree[High(OurDocTree)].MyNode := TORTreeNode(Tree.Items.AddChildObject(TORTreeNode
        (ItemsToAdd.Objects[i]), OurDocTree[High(OurDocTree)].Name, OurDocTree[High(OurDocTree)].AnObject));

      OurDocTree[High(OurDocTree)].MyNode.StringData := ItemsToAdd.Strings[i];

      SetTreeNodeImagesAndFormatting(OurDocTree[High(OurDocTree)].MyNode, TIUContext, TabIndex);

      //Find the node from the remaing list to remove.
      for j := 0 to DocList.count - 1 do begin
       if DocList[j] = ItemsToAdd[i] then begin
          DocList.delete(j);
          break;
        end;
      end;
    end;
   finally
   end;
  end;

begin
  ListOfParents := TStringList.Create();
  newItems := TStringList.Create();
  try
   //Clear the array
  SetLength(OurDocTree, 0);
   //Build the virtual tree array
  LastRecCnt := -1;
  while (DocList.Count > 0) and (LastRecCnt <> DocList.Count) do
  begin
    LastRecCnt := DocList.Count;
    //Map out the parent objects and return the future parents
    MapTheParent(newItems,ListOfParents);
    AddItemsToTree(newItems);
    newItems.Clear;
   end;

   //Handle any orphaned records (backup)
   if DocList.Count > 0 then
   begin
    newItems.Assign(DocList);
    AddItemsToTree(newItems);
   end;

   //Clear the list
   SetLength(OurDocTree, 0);

  finally
   ListOfParents.Free;
   newItems.Free;
  end;
end;

procedure SetTreeNodeImagesAndFormatting(Node: TORTreeNode; CurrentContext: TTIUContext; TabIndex: integer);
var
  tmpAuthor: int64;
  i: integer;

  procedure MakeBold(ANode: TORTreeNode);
  var
    LookingForAddenda: boolean;
  begin
    if not assigned(Node) then exit;
    LookingForAddenda := (Pos('ADDENDUM', UpperCase(CurrentContext.Keyword)) > 0);
    with ANode do
      begin
        Bold := True;
        if assigned(Parent) then
          begin
            if (ImageIndex <> IMG_ADDENDUM) or ((ImageIndex = IMG_ADDENDUM) and LookingForAddenda) then
              Parent.Expand(False);
            if assigned(Parent.Parent) then
              begin
                if (Parent.ImageIndex <> IMG_ADDENDUM) or ((Parent.ImageIndex = IMG_ADDENDUM) and LookingForAddenda) then
                  Parent.Parent.Expand(False);
                if assigned(Parent.Parent.Parent) then
                  if (Parent.Parent.ImageIndex <> IMG_ADDENDUM) or ((Parent.Parent.ImageIndex = IMG_ADDENDUM) and LookingForAddenda) then
                    Parent.Parent.Parent.Expand(False);
              end;
          end;
      end;
  end;

begin
  if not AssignedAndHasData(Node) then
    Exit;
  with Node, PDocTreeObject(Node.Data)^ do
    begin
      i := Pos('*', DocTitle);
      if i > 0 then i := i + 1 else i := 0;
      if Orphaned then
        ImageIndex := IMG_ORPHANED
      else if pos(TX_MORE, DocTitle) > 0 then
        ImageIndex := IMG_SHOWMORE
      else if pos(TX_OLDER_NOTES_WITH_ADDENDA, DocTitle) > 0 then
        ImageIndex := IMG_NONE
      else if (Copy(DocTitle, i + 1, 8) = 'Addendum') then
        ImageIndex := IMG_ADDENDUM
      else if (DocHasChildren = '') then
        ImageIndex := IMG_SINGLE
      else if Pos('+>', DocHasChildren) > 0 then
         ImageIndex := IMG_ID_CHILD_ADD
      else if (DocHasChildren = '>') then
        ImageIndex := IMG_ID_CHILD
      else if Pos('+<', DocHasChildren) > 0 then
        ImageIndex := IMG_IDPAR_ADDENDA_SHUT
      else if DocParent = '0' then
        begin
          ImageIndex    := IMG_TOP_LEVEL;
          StateIndex := -1;
          with CurrentContext, Node do
            begin
              if  Node.HasChildren and (GroupBy <> '') then case GroupBy[1] of
                'T': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by title';
                'D': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by visit date';
                'L': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by location';
                'A': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by author';
              end;
              if TabIndex <> CT_CONSULTS then
                begin
                  if (DocID = '2') or (DocID ='3') then
                    begin
                      if StrToIntDef(Status, 0) in [NC_UNSIGNED, NC_UNCOSIGNED] then
                        begin
                          if Author = 0 then tmpAuthor := User.DUZ else tmpAuthor := Author;
                          Text := Text + ' for ' + ExternalName(tmpAuthor, 200);
                        end
                      else
                        Text := Text + ' for ' + User.Name;
                    end;
                  if DocID = '4' then
                    Text := Text + ' for ' + ExternalName(Author, 200);
                end;
            end;
        end
      else
        case DocHasChildren[1] of
          '<': ImageIndex := IMG_IDNOTE_SHUT;
          '+': ImageIndex := IMG_PARENT;
          '%': begin
                 StateIndex := -1;
                 ImageIndex    := IMG_GROUP_SHUT;
               end;
        end;

      SelectedIndex := ImageIndex;
      if (ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
        StateIndex := IMG_NONE
      else
        begin
          if ImageCount > 0 then
            StateIndex := IMG_1_IMAGE
          else if ImageCount = 0 then
            StateIndex := IMG_NO_IMAGES
          else if ImageCount = -1 then
            StateIndex := IMG_IMAGES_HIDDEN;
        end;
      if (Parent <> nil) and
         (Parent.ImageIndex in [IMG_PARENT, IMG_IDNOTE_SHUT, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_SHUT, IMG_IDPAR_ADDENDA_OPEN]) and
         (StateIndex in [IMG_1_IMAGE, IMG_IMAGES_HIDDEN]) then
         begin
           Parent.StateIndex := IMG_CHILD_HAS_IMAGES;
         end;
(*        case ImageCount of
          0: StateIndex := IMG_NO_IMAGES;
          1: StateIndex := IMG_1_IMAGE;
          2: StateIndex := IMG_2_IMAGES;
        else
          StateIndex := IMG_MANY_IMAGES;
        end;*)
      if Node.Parent <> nil then
        if not CurrentContext.Filtered then
          //don't bother to BOLD every entry
        else
          begin
            if (*ContextMatch(Node) then
              if (CurrentContext.KeyWord = '') or *)TextFound(Node, CurrentContext) then MakeBold(Node);
          end;
    end;
end;

procedure TraverseTree(ATree: TTreeView; AListView: TListView; ANode: TTreeNode; MyNodeID: string; AContext: TTIUContext);
var
  IncludeIt: Boolean;
  x: string;

begin
 while ANode <> nil do
  begin
    IncludeIt := False;
    if Assigned(ANode.Data) and
      (ContextMatch(TORTreeNode(ANode), MyNodeID, AContext) and
      TextFound(TORTreeNode(ANode), AContext))  then
    begin
      with PDocTreeObject(ANode.Data)^ do
      begin
        if pos(TX_MORE, DocTitle) > 0 then
          IncludeIt := True
        else if (AContext.GroupBy <> '') and AssignedAndHasData(ATree.Selected) and
          (ATree.Selected.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
        begin
          case AContext.GroupBy[1] of
            'T':
              if (UpperCase(DocTitle)
                = UpperCase(PDocTreeObject(ATree.Selected.Data)^.DocTitle)) or
                (UpperCase(DocTitle) = UpperCase('Addendum to ' +
                PDocTreeObject(ATree.Selected.Data)^.DocTitle)) or
                (AContext.Filtered and TextFound(TORTreeNode(ANode), AContext))
              then
                IncludeIt := True;
            'D':
              begin
                x := PDocTreeObject(ATree.Selected.Data)^.DocID;
                if (Copy(x, 2, 3) = 'Vis') or (Copy(x, 2, 3) = 'Adm') then
                begin
                  if Copy(VisitDate, 1, 3) = Copy(x, 2, 3) then
                    IncludeIt := True;
                end
                else if Piece(Piece(VisitDate, ';', 2), '.', 1)
                  = Copy(x, 2, Length(x) - 4) then
                  IncludeIt := True;
              end;
            'L':
              if MyNodeID + Location = PDocTreeObject(ATree.Selected.Data)^.DocID
              then
                IncludeIt := True;
            'A':
              if MyNodeID + Piece(Author, ';', 2)
                = PDocTreeObject(ATree.Selected.Data)^.DocID then
                IncludeIt := True;
          end;
        end
        else
          IncludeIt := True;
      end;
    end;
    if IncludeIt then
        AddListViewItem(ANode, AListView);
    if ANode.HasChildren then
       TraverseTree(ATree, AListView, ANode.GetFirstChild, MyNodeID, AContext);
    ANode := ANode.GetNextSibling;
  end;
end;

function ContextMatch(ANode: TORTreeNode; AParentID: string; AContext: TTIUContext): Boolean;
var
  Status: string;
  Author: int64;
begin
  Result := True;
  if not AssignedAndHasData(ANode) then
    Exit;
  Status := PDocTreeObject(ANode.Data)^.Status;

  if (AParentID = '') or (AContext.Status <> AParentID[1]) or
    (AContext.Author = 0) then
    Author := User.DUZ
  else
    Author := AContext.Author;

  if Length(AParentID)  = 0 then exit;
  if Length(Trim(Status)) = 0 then exit;
  (*if PDocTreeObject(ANode.Data)^.DocHasChildren = '%' then Result := False else Result := True;
  Result := False;*)
  case AParentID[1] of
    '1':  Result := (Status = 'completed') or
                    (Status = 'deleted')   or
                    (Status = 'amended')   or
                    (Status = 'uncosigned') or
                    (Status = 'retracted');
    '2':  Result := ((Status = 'unsigned')   or
                    (Status = 'unreleased') or
                    (Status = 'deleted')   or
                    (Status = 'retracted') or
                    (Status = 'unverified')) and
                    (Piece(PDocTreeObject(ANode.Data)^.Author, ';', 1) = IntToStr(Author));
    '3':  Result := ((Status = 'uncosigned') or
                    (Status = 'unsigned')   or
                    (Status = 'unreleased') or
                    (Status = 'deleted')   or
                    (Status = 'retracted') or
                    (Status = 'unverified')) ;//and
 { TODO -oRich V. -cSort/Search : Uncosigned notes - need to check cosigner, not author, but don't have it }
                    //(Piece(PDocTreeObject(ANode.Data)^.Author, ';', 1) = IntToStr(Author));
    '4':  Result := (Piece(PDocTreeObject(ANode.Data)^.Author, ';', 1) = IntToStr(Author));
    '5':  if PDocTreeObject(ANode.Data)^.DocHasChildren = '%' then Result := False
          else Result := (StrToFloat(PDocTreeObject(ANode.Data)^.DocFMDate) >= AContext.FMBeginDate) and
                         (Trunc(StrToFloat(PDocTreeObject(ANode.Data)^.DocFMDate)) <= AContext.FMEndDate);
    'N':  Result := True;     // NEW NOTE
    'E':  Result := True;     // EDITING NOTE
    'A':  Result := True;     // NEW ADDENDUM or processing alert
  end;
end;

function TextFound(ANode: TORTreeNode; CurrentContext: TTIUContext): Boolean;
var
  MySearch: string;
begin
  Result := False;
  if not AssignedAndHasData(ANode) then
    Exit;
  if CurrentContext.SearchField <> '' then
    case CurrentContext.SearchField[1] of
      'T': MySearch := PDocTreeObject(ANode.Data)^.DocTitle;
      'S': MySearch := PDocTreeObject(ANode.Data)^.Subject;
      'B': MySearch := PDocTreeObject(ANode.Data)^.DocTitle + ' ' + PDocTreeObject(ANode.Data)^.Subject;
    end;
  Result := (not CurrentContext.Filtered) or
            ((CurrentContext.Filtered) and (Pos(UpperCase(CurrentContext.KeyWord), UpperCase(MySearch)) > 0));
end;

procedure ResetDocTreeObjectStrings(AnObject: PDocTreeObject);
begin
  with AnObject^ do
    begin
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

procedure KillDocTreeObjects(TreeView: TORTreeView);
var
  i: integer;
  ce: TTVCompareEvent;

begin
  with TreeView do
  begin
    // disable sorting of entire tree with each Data := nil
    if assigned(OnCompare) and (SortType in [stData, stBoth]) then
    begin
      // changing OnCompare better than changing SortType - restoring SortType resorts tree
      ce := OnCompare;
      OnCompare := nil;
    end
    else
      ce := nil;
    try
      for i := 0 to Items.Count-1 do
      begin
        if(Assigned(Items[i].Data)) then
        begin
          ResetDocTreeObjectStrings(PDocTreeObject(Items[i].Data));
          Dispose(PDocTreeObject(Items[i].Data));
          Items[i].Data := nil;
        end;
      end;
    finally
      if assigned(ce) then
        OnCompare := ce;
    end;
  end;
end;

procedure KillDocTreeNode(ANode: TTreeNode);
var
  ce: TTVCompareEvent;
  tree: TTreeView;

begin
  if assigned(ANode) and assigned(ANode.Data) and assigned(ANode.TreeView) and
    assigned(TTreeView(ANode.TreeView).OnCompare) and
    (TTreeView(ANode.TreeView).SortType in [stData, stBoth]) then
  begin
    // disable sorting of entire tree when setting Data := nil
    tree := TTreeView(ANode.TreeView);
    // changing OnCompare better than changing SortType - restoring SortType resorts tree
    ce := tree.OnCompare;
    tree.OnCompare := nil;
  end
  else
  begin
    tree := nil;
    ce := nil;
  end;
  try
    if(Assigned(ANode.Data)) then
    begin
      ResetDocTreeObjectStrings(PDocTreeObject(ANode.Data));
      Dispose(PDocTreeObject(ANode.Data));
      ANode.Data := nil;
    end;
    ANode.Owner.Delete(ANode);
  finally
    if assigned(tree) then
      tree.OnCompare := ce;
  end;
end;

procedure RemoveParentsWithNoChildren(Tree: TTreeView; Context: TTIUContext);
var
  n: integer;
begin
  with Tree do
    for n := Items.Count - 1 downto 0 do
      if ((Items[n].ImageIndex = IMG_GROUP_SHUT)) then
        begin
          if (not Items[n].HasChildren) then
             KillDocTreeNode(Items[n])
          else if Context.Filtered then   // if any hits, would be IMG_GROUP_OPEN
             KillDocTreeNode(Items[n]);
        end;
end;

procedure AddListViewItem(ANode: TTreeNode; AListView: TListView);
var
  ListItem: TListItem;

begin
  if not AssignedAndHasData(ANode) then
    Exit;
  with Anode, PDocTreeObject(ANode.Data)^, AListView do
    begin
      if ANode.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT] then
        Exit;
      if pos(TX_OLDER_NOTES_WITH_ADDENDA, ANode.Text) > 0 then
        exit;
      ListItem := Items.Add;
      if pos(TX_MORE, DocTitle) > 0 then
        ListItem.Caption := ''
      else
        ListItem.Caption := DocDate;                   // date
      ListItem.StateIndex := ANode.StateIndex;
      ListItem.ImageIndex := ANode.ImageIndex;
      with ListItem.SubItems do
        begin
          Add(DocTitle);                               //  title
          Add(Subject);                                //  subject
          Add(MixedCase(Piece(Author, ';', 2)));       //  author
          Add(Location);                               //  location
          Add(DocFMDate);                              //  reference date (FM)
          Add(DocID);                                  //  TIUDA
        end;
    end;
end;

function MakeNoteTreeObject(x: string): PDocTreeObject;
var
  AnObject: PDocTreeObject;
begin
  New(AnObject);
  with AnObject^ do
    begin
      DocID           := Piece(x, U, 1);
      DocDate         := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(x, U, 3)));
      DocTitle        := Piece(x, U, 2);
      Location        := Piece(x, U, 6);
      NodeText        := MakeNoteDisplayText(x);
      ImageCount      := StrToIntDef(Piece(x, U, 11), 0);
      VisitDate       := Piece(x, U, 8);
      DocFMDate       := Piece(x, U, 3);
      DocHasChildren  := Piece(x, U, 13);
      if Copy(DocHasChildren, 1, 1) = '*' then
        DocHasChildren := Copy(DocHasChildren, 2, 5);
      DocParent       := Piece(x, U, 14);
      Author          := Piece(Piece(x, U, 5), ';', 1) + ';' + Piece(Piece(x, U, 5), ';', 3);
      PkgRef          := Piece(x, U, 10);
      Status          := Piece(x, U, 7);
      Subject         := Piece(x, U, 12);
      OrderByTitle    := Piece(x, U, 15) = '1';
      Orphaned        := Piece(x, U, 16) = '1';
    end;
  Result := AnObject;
end;

function MakeDCSummTreeObject(x: string): PDocTreeObject;
var
  AnObject: PDocTreeObject;
begin
  New(AnObject);
  if Copy(Piece(x, U, 9), 1, 4) = '    ' then SetPiece(x, U, 9, 'Dis: ');
  with AnObject^ do
    begin
      DocID            := Piece(x, U, 1);
      DocDate          := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(x, U, 3)));
      DocTitle         := Piece(x, U, 2);
      Location         := Piece(x, U, 6);
      NodeText         := MakeDCSummDisplayText(x);
      DocFMDate        := Piece(x, U, 3);
      ImageCount       := StrToIntDef(Piece(x, U, 11), 0);
      DocHasChildren   := Piece(x, U, 13);
      if Copy(DocHasChildren, 1, 1) = '*' then
        DocHasChildren := Copy(DocHasChildren, 2, 5);
      DocParent        := Piece(x, U, 14);
      Author           := Piece(Piece(x, U, 5), ';', 1) + ';' + Piece(Piece(x, U, 5), ';', 3);
      PkgRef           := Piece(x, U, 10);
      Status           := Piece(x, U, 7);
      Subject          := Piece(x, U, 12);
      VisitDate        := Piece(x, U, 8);
      OrderByTitle    := Piece(x, U, 15) = '1';
      Orphaned        := Piece(x, U, 16) = '1';
    end;
  Result := AnObject;
end;

function MakeConsultsNoteTreeObject(x: string): PDocTreeObject;
var
  AnObject: PDocTreeObject;
begin
  New(AnObject);
  with AnObject^ do
    begin
      DocID           := Piece(x, U, 1);
      DocDate         := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(x, U, 3)));
      DocTitle        := Piece(x, U, 2);
      Location        := Piece(x, U, 6);
      NodeText        := MakeConsultNoteDisplayText(x);
      DocFMDate       := Piece(x, U, 3);
      Status          := Piece(x, U, 7);
      Author          := Piece(Piece(x, U, 5), ';', 1) + ';' + Piece(Piece(x, U, 5), ';', 3);
      PkgRef          := Piece(x, U, 10);
      if Piece(PkgRef, ';', 2) = PKG_CONSULTS then
        OrderID       := GetConsultOrderIEN(StrToIntDef(Piece(PkgRef, ';', 1), 0));
      ImageCount      := StrToIntDef(Piece(x, U, 11), 0);
      VisitDate       := Piece(x, U, 8);
      DocHasChildren  := Piece(x, U, 13);
      if Copy(DocHasChildren, 1, 1) = '*' then
        DocHasChildren := Copy(DocHasChildren, 2, 5);
      DocParent       := Piece(x, U, 14);
      OrderByTitle    := Piece(x, U, 15) = '1';
      Orphaned        := Piece(x, U, 16) = '1';
    end;
  Result := AnObject;
end;

////////////////////////////////////////////////////////////////////////////////

function getChildCount(aNode:TTreeNode): Integer;
var
  Node: TTreeNode;
begin
  Result := 0;
  if aNode = nil then
    exit;
  Node := aNode.GetFirstChild;
  while Node <> nil do
  begin
    Inc(Result);
    Result := Result + getChildCount(Node);
    Node := Node.GetNextChild(Node);
  end;
end;

function getNodeByName(aName:String;aLevel: Integer; tv: TTreeView):TTreeNode;
var
  tn: TTreeNode;
begin
  tn := tv.Items.GetFirstNode;
  while tn <> nil do
    begin
      if tn.Level = aLevel then
        begin
          if pos(aName,tn.Text)=1 then
            break;
          tn := tn.getNextSibling;
        end
      else if tn = nil then
          break
      else if tn.Level < aLevel then
          tn := tn.getFirstChild
      else
          tn := tn.parent;
    end;
    Result := tn;
end;

function getExpandStatus(aTree:TTreeView):TStringList;
var
  i: integer;
  SL: TSTringList;
  n: TTreeNode;
begin
  SL := TStringList.Create;
  if assigned(aTree) then
    for i := 0 to aTree.Items.Count - 1 do
      begin
        n := aTree.Items[i];
        if n.Expanded then   // register only expanded nodes
          begin
            if n.Data = nil then
              SL.Add(n.Text+'=1')
            else
              SL.Add(PDocTreeObject(n.Data)^.DocID+'=1')
          end;
      end;
  Result := SL;
end;

procedure setExpandStatus(aNodes:TTreeNodes;aStatus:TStringList);
var
  sName:String;
  i,iPos: integer;
begin
  if not assigned(aStatus) then
    exit;
  for i := 0 to aNodes.Count-1 do
    begin
      if assigned(aNodes[i].Data) then
        sName := PDocTreeObject(aNodes[i].Data)^.DocID
      else
        sName := aNodes[i].Text;

      iPos := aStatus.IndexOfName(sName);
      if iPos > -1 then
        aNodes[i].Expanded := aStatus.Values[sName] = '1'
      else if aNodes[i].HasChildren then
        aNodes[i].Expanded := false;
    end;
end;

procedure RemoveDuplicates(const aList: TStringList);
var
  tmpList:TStringList;
  i, LastCount: integer;
//  s: String;
begin
  tmpList := TStringList.Create;
  tmpList.BeginUpdate;
  try
    tmpList.Sorted := True;
    tmpList.Duplicates := dupIgnore;

//   this code messes up existing sort order of aList
//    for s in aList do
//      tmpList.Add(s);
//    aList.Assign(tmpList);

    for i := aList.Count-1 downto 0 do
    begin
      LastCount := tmpList.Count;
      tmpList.Add(aList[i]);
      if tmpList.Count = LastCount then
        aList.Delete(i);
    end;
  finally
     tmpList.EndUpdate;
     tmpList.Free;
  end;
end;

procedure adjustOrder(aList: TStringList; Context: TTIUContext);
var
  iPos,
  i,j: integer;
  s,ss: string;
begin
  if (not assigned(aList)) or Context.TreeAscending then
    exit;
  iPos := -1;
  for i := 0 to aList.Count - 1 do
    begin
      s := aList[i];
      if pos(TX_MORE,s)>0 then
        begin
          ss := piece(s,U,1);
          j := strToIntDef(ss,-1);
          if j>0 then
            begin
              iPos := i;
              break;
            end;
        end;
    end;
  if iPos >0 then
    begin
      aList.Delete(iPos);
      aList.Add(s);
      if Context.GroupBy = '' then
      begin
        SetPiece(s, U, 2, TX_OLDER_NOTES_WITH_ADDENDA);
        aList.Add(s);
      end;
    end
    else if (Context.Status = '5') and (Context.FMBeginDate > 0) then
    begin
      s := U + TX_OLDER_NOTES_WITH_ADDENDA + U +
        FloatToStr(Context.FMBeginDate) + '^^^^^^^^^^^' + Context.Status;
      aList.Add(s);
    end;
end;

function FindTreeNodeByName(aTree:TORTreeView;aName:String):TORTreeNode;
var
  i: integer;
  sName:String;
begin
  Result := nil;
  if not assigned(aTree) then
    exit;
  if aTree.Items.Count <1 then
    exit;
  i := 0;
  while (i < aTree.Items.Count) do
    begin
      Result := TORTreeNode(aTree.Items[i]);
      sName := UpperCase(piece(Result.StringData,U,2));
      if pos(aName,sName)=1 then
        break
      else
        begin
          Result := nil;
          inc(i);
        end;
    end;
end;

/// re-assigning node parent
procedure remapNode(aTree:TORTreeView;aName,aParentName:String);
var
  nn,nd,ndParent:TORTreeNode;
begin
  nd := findTreeNodeByName(aTree,aName);
  if nd = nil then
    exit;
  ndParent := findTreeNodeByName(aTree,aParentName);
  if ndParent = nil then
    exit;
  if nd.Parent = ndParent then
    exit;
  nn := TORTreeNode(aTree.Items.AddChildObject(ndParent,nd.Text,nd.Data));
  nn.Data := nd.Data;
  nn.StringData := nd.StringData;
  nn.StateIndex := nd.StateIndex;
  aTree.Items.Delete(nd);
  nn.ImageIndex := IMG_SHOWMORE;
  nn.SelectedIndex := IMG_SHOWMORE;
  nn.StateIndex := IMG_NONE;
end;

procedure AutoSizeColumns(lv: TListView; cols: array of integer);
var
  c, i, w, icon, iconW, state, stateW, max: integer;
  x: string;
  Looking: boolean;

begin
  if lv.Items.Count = 0 then
    exit;
  Looking := assigned(lv.SmallImages);
  if Looking then
    iconW := lv.SmallImages.Width + 2
  else
    iconW := 0;
  if not Looking then
    Looking := assigned(lv.StateImages);
  if Looking and assigned(lv.StateImages) then
    stateW := lv.StateImages.Width + 6
  else
    stateW := 0;
  for c := Low(cols) to High(cols) do
  begin
    if cols[c] < lv.Columns.Count then
    begin
      if lv.Columns[cols[c]].ImageIndex > 0 then
        state := stateW
      else
        state := 0;
      max := TextWidthByFont(MainFont.Handle, lv.Columns[cols[c]].Caption) + state + 4;
      for i := 0 to lv.Items.Count - 1 do
      begin
        if cols[c] = 0 then
        begin
          x := lv.Items[i].Caption;
          if Looking and (lv.Items[i].ImageIndex >= 0) then
            icon := iconW
          else
            icon := 0;
        end
        else
        begin
          x := lv.Items[i].SubItems[cols[c] - 1];
          if Looking and (lv.Items[i].SubItemImages[cols[c]-1] >= 0) then
            icon := iconW
          else
            icon := 0;
        end;
        if lv.Items[i].StateIndex >= 0 then
          state := stateW
        else
          state := 0;
        w := TextWidthByFont(MainFont.Handle, x) + icon + state + 8;
        if max < w then
          max := w;
      end;
      lv.Columns[cols[c]].Width := max + 8;
    end;
  end;
end;

function ShowMoreNode(s: String): boolean;
begin
  Result := (pos(TX_MORE, s) > 0) or (Pos(TX_OLDER_NOTES_WITH_ADDENDA, s) > 0);
end;

end.
