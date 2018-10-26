unit uDocTree;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls, uTIU;


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
procedure BuildDocumentTree(DocList: TStrings; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          TIUContext: TTIUContext; TabIndex: integer);
procedure BuildDocumentTree2(DocList: TStrings; Tree:
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

implementation

uses
  rConsults, uDCSumm, uConsults;

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
===============================================================}

procedure CreateListItemsForDocumentTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: Boolean; TabIndex: integer);
const
  NO_MATCHES = '^No Matching Documents Found^^^^^^^^^^^%^0';
var
  i: Integer;
  x, x1, x2, x3, MyParent, MyTitle, MyLocation, MySubject: string;
  AList, SrcList: TStringList;
begin
  AList := TStringList.Create;
  SrcList := TStringList.Create;
  try
    FastAssign(Source, SrcList);
    with SrcList do
      begin
        if (Count = 0) then
          begin
            Dest.Insert(0, IntToStr(Context) + NO_MATCHES);
            Exit;
          end;
        for i := 0 to Count - 1 do
          begin
            x := Strings[i];
            MyParent   := Piece(x, U, 14);
            MyTitle    := Piece(x, U, 2);
            if Length(Trim(MyTitle)) = 0 then
              begin
                MyTitle := '** No Title **';
                SetPiece(x, U, 2, MyTitle);
              end;
            MyLocation := Piece(x, U, 6);
            if Length(Trim(MyLocation)) = 0 then
              begin
                MyLocation := '** No Location **';
                SetPiece(x, U, 6, MyLocation);
              end;
            MySubject  := Piece(x, U, 12);
(*            case TIUContext.SearchField[1] of
              'T': if ((TextFound(MyTitle)) then continue;
              'S': if (not TextFound(MySubject)) then continue;
              'B': if not ((TextFound(MyTitle)) or (TextFound(MySubject))) then continue;
            end;*)
            if GroupBy <> '' then case GroupBy[1] of
              'D':  begin
                      x1 := Piece(Piece(x, U, 8), ';', 1);                    // Visit date
                      x2 := Piece(Piece(Piece(x, U, 8), ';', 2), '.', 1);     // Visit date (FM)   no time - v15.4
                      if x2 = '' then
                        begin
                          x2 := 'No Visit';
                          x1 := Piece(x1, ':', 1) + ':  No Visit';
                        end;
                      (*else
                        x1 := Piece(x1, ':', 1) + ':  ' + FormatFMDateTimeStr('mmm dd,yy@hh:nn',x2)*) //removed v15.4
                      if MyParent = IntToStr(Context) then
                        SetPiece(x, U, 14, MyParent + x2 + Copy(x1, 1, 3));    // '2980324Adm'
                      x3 := x2 + Copy(x1, 1, 3) + U + MixedCase(x1) + U + IntToStr(Context) + MixedCase(Copy(x1, 1, 3));
                      if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                        AList.Add(x3);   // '2980324Adm^Mar 24,98'
                    end;
              'L':  begin
                      if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                        SetPiece(x, U, 14, MyParent + MyLocation);
(*                        if (Copy(MyTitle, 1, 8) <> 'Addendum') then       // split ID Notes by location?
                        SetPiece(x, U, 14, IntToStr(Context) + MyLocation);*)
                      x3 := MyLocation + U + MixedCase(MyLocation) + U + IntToStr(Context);
                      if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                        AList.Add(x3);
                    end;
              'T':  begin
                      if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                        SetPiece(x, U, 14, MyParent + MyTitle);
(*                        if (Copy(MyTitle, 1, 8) <> 'Addendum') then       // split ID Notes by title?
                        SetPiece(x, U, 14, IntToStr(Context) + MyTitle);*)
                      x3 := MyTitle + U + MixedCase(MyTitle) + U + IntToStr(Context);
                      if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                        AList.Add(x3);
                    end;
              'A':  begin
                      x1 := Piece(Piece(x, U, 5), ';', 3);
                      if x1 = '' then x1 := '** No Author **';
                      if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                        SetPiece(x, U, 14, MyParent + x1);
                      //if (Copy(MyTitle, 1, 8) <> 'Addendum') then         // split ID Notes by author?
                      //  SetPiece(x, U, 14, IntToStr(Context) + x1);
                      x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                      if (Copy(MyTitle, 1, 8) <> 'Addendum') and(AList.IndexOf(x3) = -1) then
                        AList.Add(x3);
                    end;
(*              'A':  begin                                                 // Makes note appear both places in tree,
                      x1 := Piece(Piece(x, U, 5), ';', 3);                  // but also appears TWICE in lstNotes.
                      if x1 = '' then x1 := '** No Author **';              // IS THIS REALLY A PROBLEM??
                      if MyParent = IntToStr(Context) then                  // Impact on EditingIndex?
                        SetPiece(x, U, 14, MyParent + x1);                  // Careful when deleting note being edited!!!
                      Dest.Add(x);                                          // Need to find and delete ALL occurrences!
                      SetPiece(x, U, 14, IntToStr(Context) + x1);
                      x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;*)
            end;
            Dest.Add(x);
          end; {for}
        SortByPiece(TStringList(Dest), U, 3);
        if not Ascending then InvertStringList(TStringList(Dest));
        if GroupBy <> '' then if GroupBy[1] ='D' then
          begin
            AList.Add('Adm^Inpatient Notes' + U + IntToStr(Context));
            AList.Add('Vis^Outpatient Notes' + U + IntToStr(Context));
          end;
        Dest.Insert(0, IntToStr(Context) + '^' + NC_TV_TEXT[TabIndex, Context] + '^^^^^^^^^^^%^0');
        Alist.Sort;
        InvertStringList(AList);
        if GroupBy <> '' then if GroupBy[1] ='D' then
          if (not Ascending) then InvertStringList(AList);
        for i := 0 to AList.Count-1 do
          Dest.Insert(0, IntToStr(Context) + Piece(AList[i], U, 1) + '^' + Piece(AList[i], U, 2) + '^^^^^^^^^^^%^' + Piece(AList[i], U, 3));
      end;
  finally
    AList.Free;
    SrcList.Free;
  end;
end;

procedure BuildDocumentTree(DocList: TStrings; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          TIUContext: TTIUContext; TabIndex: integer);
var
  MyID, MyParent, Name: string;
  i: Integer;
  ChildNode, tmpNode: TORTreeNode;
  DocHasChildren: Boolean;
  AnObject: PDocTreeObject;
begin
  with DocList do for i := 0 to Count - 1 do
    begin
      tmpNode := nil;
      MyParent := Piece(Strings[i], U, 14);
      if (MyParent = Parent) then
        begin
          MyID := Piece(Strings[i], U, 1);
          if Piece(Strings[i], U, 13) <> '%' then
            case TabIndex of
                CT_NOTES:    Name := MakeNoteDisplayText(Strings[i]);
                CT_CONSULTS: Name := MakeConsultNoteDisplayText(Strings[i]);
                CT_DCSUMM:   Name := MakeDCSummDisplayText(Strings[i]);
            end
          else
            Name := Piece(Strings[i], U, 2);
          DocHasChildren := (Piece(Strings[i], U, 13) <> '');
          if Node <> nil then if Node.HasChildren then
            tmpNode := Tree.FindPieceNode(MyID, 1, U, Node);
          if (tmpNode <> nil) and tmpNode.HasAsParent(Node) then
            Continue
          else
            begin
              case TabIndex of
                CT_NOTES:    AnObject := MakeNoteTreeObject(Strings[i]);
                CT_CONSULTS: AnObject := MakeConsultsNoteTreeObject(Strings[i]);
                CT_DCSUMM:   AnObject := MakeDCSummTreeObject(Strings[i]);
              else
                AnObject := nil;
              end;
              ChildNode := TORTreeNode(Tree.Items.AddChildObject(TORTreeNode(Node), Name, AnObject));
              ChildNode.StringData := Strings[i];
              SetTreeNodeImagesAndFormatting(ChildNode, TIUContext, TabIndex);
              if DocHasChildren then BuildDocumentTree(DocList, MyID, Tree, ChildNode, TIUContext, TabIndex);
            end;
        end;
    end;
end;

procedure BuildDocumentTree2(DocList: TStrings; Tree:
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
  FirstParent: TObject;

  procedure MapTheParent(var ItemsToAdd, ParentList: TStringList);
  var
   i, j, Z: Integer;
   ParentNode: TORTreeNode;
   NextParentList: TStringList;
  begin
    NextParentList := TStringList.Create;
    try
    //If we have no parents (first time) then add 0
    if ListOfParents.count < 1 then ListOfParents.add('0');

    //Loop though the parent list and find any nodes that need to be added
    for j := 0 to ListOfParents.Count - 1 do begin
       //Find this parent node (if exist). to be used when adding these individual nodes.
       ParentNode := nil;
       for z := Low(OurDocTree) to High(OurDocTree) do
       begin
        if UpperCase(Piece(ListOfParents.Strings[j], U, 1)) = UpperCase(Piece(OurDocTree[z].MyNode.StringData, U, 1) ) then
        begin
         ParentNode := OurDocTree[z].MyNode;
         break;
        end;
       end;
      //Find any items from our remaining items list that is a child of this parent
      for i := 0 to DocList.count - 1 do begin
        if UpperCase(Piece(DocList.Strings[i], U, 14)) = UpperCase(Piece(ListOfParents.Strings[j], U, 1))
          then begin
            //Add to the virtual tree
            ItemsToAdd.AddObject(DocList.Strings[i], ParentNode);
            if not Assigned(FirstParent) then
             FirstParent := ParentNode;

            //If this item is also a parent then we need to add it to our parent list for the next run through
            if (Piece(DocList.Strings[i], U, 13) <> '') then
             NextParentList.Add(DocList.Strings[i]);
        end;
      end;
    end;

    ParentList.Assign(NextParentList);
    finally
      NextParentList.Free;
    end;

  end;

  procedure AddItemsToTree(ListOfParents: TStringList; Orphaned: Boolean);
  Var
   I, J: Integer;
   ItemsToAdd: TStringList;
  begin
   ItemsToAdd := TStringList.Create;
   try
   //Map out the parent objects and return the future parents
   If not Orphaned then
    MapTheParent(ItemsToAdd, ListOfParents)
   else
    ItemsToAdd.Assign(ListOfParents);


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
        CT_NOTES: OurDocTree[High(OurDocTree)].AnObject := MakeNoteTreeObject(ItemsToAdd.Strings[i]);
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
     ItemsToAdd.free;
   end;

  end;

begin
  ListOfParents := TStringList.Create();
  try
   //Clear the array
   SetLength(OurDocTree, 0);

   //Build the virtual tree array
   LastRecCnt := -1;
   FirstParent := nil;

   while (DocList.Count > 0) and (LastRecCnt <> DocList.Count) do
   begin
    LastRecCnt := DocList.Count;
    AddItemsToTree(ListOfParents, false);
   end;

   //Handle any orphaned records (backp)
   if DocList.Count > 0 then
   begin
    AddItemsToTree(TStringList(DocList), True);
   end;


   //Clear the list
   SetLength(OurDocTree, 0);

  finally
   ListOfParents.Free;
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
  with Node, PDocTreeObject(Node.Data)^ do
    begin
      i := Pos('*', DocTitle);
      if i > 0 then i := i + 1 else i := 0;
      if Orphaned then
        ImageIndex := IMG_ORPHANED
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
          SelectedIndex := IMG_TOP_LEVEL;
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
                 SelectedIndex := IMG_GROUP_OPEN;
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
    if (ContextMatch(TORTreeNode(ANode), MyNodeID, AContext) and
      TextFound(TORTreeNode(ANode), AContext)) then
    begin
      with PDocTreeObject(ANode.Data)^ do
      begin
        if (AContext.GroupBy <> '') and
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
  if not Assigned(ANode.Data) then Exit;
  Status := PDocTreeObject(ANode.Data)^.Status;

  if (AContext.Status <> AParentID[1]) or (AContext.Author = 0) then
    Author := User.DUZ
  else
    Author := AContext.Author;

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
  if not Assigned(ANode.Data) then Exit;
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
begin
  with TreeView do
    for i := 0 to Items.Count-1 do
    begin
      if(Assigned(Items[i].Data)) then
        begin
          ResetDocTreeObjectStrings(PDocTreeObject(Items[i].Data));
          Dispose(PDocTreeObject(Items[i].Data));
          Items[i].Data := nil;
        end;
    end;
end;

procedure KillDocTreeNode(ANode: TTreeNode);
begin
  if(Assigned(ANode.Data)) then
    begin
      ResetDocTreeObjectStrings(PDocTreeObject(ANode.Data));
      Dispose(PDocTreeObject(ANode.Data));
      ANode.Data := nil;
    end;
  ANode.Owner.Delete(ANode);
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
  if not Assigned(ANode.Data) then Exit;
  with Anode, PDocTreeObject(ANode.Data)^, AListView do
    begin
(*      if (FCurrentContext.Status = '1') and
           (Copy(DocTitle, 1 , 8) = 'Addendum') then Exit;*)
      if ANode.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT] then Exit;
      ListItem := Items.Add;
      ListItem.Caption := DocDate;                     // date
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
      DocDate         := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3)));
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
      DocDate          := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3)));
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
      DocDate         := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3)));
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


end.
