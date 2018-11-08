unit uConsults;

interface

uses
    SysUtils, Windows, Messages, Controls, Classes, StdCtrls, ORfn, uTIU, ORCtrls,
    Contnrs, DateUtils;

type

  TConsultRequest = record              {file 123}  {Order Dialog}
    IEN: integer ;                          {.001}
    EntryDate: TFMDateTime ;                { .01}
    ORFileNumber: integer ;                 { .03}
    PatientLocation: integer ;              { .04}
    OrderingFacility: integer ;             { .05}
    ForeignConsultFileNum: integer ;        { .06}
    ToService: integer ;                    {   1}       { * }
    From: integer ;                         {   2}
    RequestDate: TFMDateTime ;              {   3}
    ConsultProcedure: string ;              {   4}
    Urgency: integer ;                      {   5}       { * }
    PlaceOfConsult: integer ;               {   6}       { * }
    Attention: int64   ;                    {   7}       { * }
    ORStatus: integer ;                     {   8}
    LastAction: integer ;                   {   9}
    SendingProvider: int64 ;              {  10}
    SendingProviderName: string ;
    Result: string ;                        {  11}
    ModeOfEntry: string ;                   {  12}
    RequestType: integer ;                  {  13}
    InOut: string ;                         {  14}       { * }
    Findings: string ;                      {  15}
    TIUResultNarrative: integer ;           {  16}
    TIUDocuments: TStrings ;                {from '50' node of file 123}
    MedResults:  TStrings;                  {from '50' node of file 123}
    RequestReason: TStringList ;            {  20}       { * }
    ProvDiagnosis: string ;                 {  30}       { * }
    ProvDxCode: string;                     {  30.1}
    RequestProcessingActivity: TStringList; {  40}
    ClinicallyIndicatedDate: TFMDateTime;
    //LatestDate: TFMDateTime; //dropped requirement WAT
  end ;

  TEditResubmitRec = record
    Changed: boolean;
    IEN: integer;
    OrderableItem: integer;
    RequestType: string;
    ToService: integer;
    ToServiceName: string;
    ConsultProc: string;
    ConsultProcName: string;
    Urgency: integer;
    UrgencyName: string;
    ClinicallyIndicatedDate: TFMDateTime;
    //LatestDate: TFMDateTime; //dropped requirement WAT
    Place: string;
    PlaceName: string;
    Attention: int64;
    AttnName: string;
    InpOutp: string;
    RequestReason: TStringList;
    ProvDiagnosis: string;
    ProvDxCode: string;
    ProvDxCodeInactive:  boolean;
    DenyComments: TStringList;
    OtherComments: TStringList;
    NewComments: TStringList;
  end;

  TSelectContext = record
    Changed: Boolean;
    BeginDate: string;
    EndDate: string;
    Ascending: Boolean;
    Service: string;
    ServiceName: string;
    ConsultUser: Boolean ;
    Status: string;
    StatusName: string;
    GroupBy: string;
  end ;

  TMenuAccessRec = record
    UserLevel: integer;
    AllowMedResulting: Boolean;
    AllowMedDissociate: Boolean;
    AllowResubmit: Boolean;
    ClinProcFlag: integer;
    IsClinicalProcedure: Boolean;
  end;

  TProvisionalDiagnosis = record
    Code: string;
    Text: string;
    CodeInactive: boolean;
    Reqd: string;
    PromptMode: string;
    PreviousPromptMode: string;
  end;

  TConsultTitles = class
    DfltTitle: Integer;
    DfltTitleName: string;
    ShortList: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TClinProcTitles = class
    DfltTitle: Integer;
    DfltTitleName: string;
    ShortList: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

function  MakeConsultListItem(InputString: string):string;
function  MakeConsultListDisplayText(InputString: string): string;
function  MakeConsultNoteDisplayText(RawText: string): string;
procedure BuildServiceTree(Tree: TORTreeView; SvcList: TStrings; const Parent: string; Node: TORTreeNode);
procedure CreateListItemsForConsultTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: Boolean);
procedure BuildConsultsTree(Tree: TORTreeView; tmpList: TStrings; const Parent: string; Node: TORTreeNode;
           CurrentContext: TSelectContext);
procedure SetNodeImage(Node: TORTreeNode; CurrentContext: TSelectContext);

const
   CN_SVC_LIST_DISP     = 0 ;
   CN_SVC_LIST_FWD      = 1 ;
   CN_SVC_LIST_ORD      = 1 ;
   CSLT_PTR             = ';99CON';
   PROC_PTR             = ';99PRC';

   {MenuAccessRec.UserLevel}
   UL_NONE              = 0;
   UL_REVIEW            = 1;
   UL_UPDATE            = 2;
   UL_ADMIN             = 3;
   UL_UPDATE_AND_ADMIN  = 4;
   UL_UNRESTRICTED      = 5;

   {Clinical Procedure statuses}
   CP_NOT_CLINPROC      = 0;
   CP_NO_INSTRUMENT     = 1;
   CP_INSTR_NO_STUB     = 2;
   CP_INSTR_INCOMPLETE  = 3;
   CP_INSTR_COMPLETE    = 4;

   CN_NEW_CSLT_NOTE     = '-30';
   CN_NEW_CP_NOTE       = '-20';

var
   ConsultRec: TConsultRequest ;

implementation

uses
  uConst;

constructor TConsultTitles.Create;
{ creates an object to store Consult titles so only obtained from server once }
begin
  inherited Create;
  ShortList := TStringList.Create;
end;

destructor TConsultTitles.Destroy;
{ frees the lists that were used to store the Consult titles }
begin
  ShortList.Free;
  inherited Destroy;
end;

constructor TClinProcTitles.Create;
{ creates an object to store ClinProc titles so only obtained from server once }
begin
  inherited Create;
  ShortList := TStringList.Create;
end;

destructor TClinProcTitles.Destroy;
{ frees the lists that were used to store the ClinProc titles }
begin
  ShortList.Free;
  inherited Destroy;
end;

{============================================================================================
1016^Jun 04,98  ^(dc)^ COLONOSCOPY GASTROENTEROLOGY Proc^Consult #: 1016^15814^^P
1033^Jun 10,98  ^(c)^ GASTROENTEROLOGY Cons^Consult #: 1033^15881^^C
=============================================================================================
function call [GetConsultsList] returns the following string '^' pieces:
===============================================================
      1 -  Consult IEN
      2 -  Consult Date
      3 -  (Status)
      4 -  Consult/Procedure Display Text
      5 -  Consult #: ###
      6 -  Order IFN
      7 -  ''  (used for HasChildren in tree)
      8 -  Parent in tree
      9 -  'Consult', 'Procedure', or 'Clinical Procedure'
     10 -  Service Name
     11 -  FMDate of piece 2
     12 -  'C' or 'P' or 'M' or 'I' or 'R'
===============================================================}

function MakeConsultListItem(InputString: string): string;
var
  x: string;
begin
  x := InputString;
  if Piece(x, U, 6) = '' then SetPiece(x, U, 6, ' ');
  if Piece(x, U, 9) <> '' then
    case Piece(x, U, 9)[1] of
      'C':  SetPiece(x, U, 10, 'Consult');
      'P':  SetPiece(x, U, 10, 'Procedure');
      'M':  SetPiece(x, U, 10, 'Procedure');  //'Clinical Procedure');
      'I':  SetPiece(x, U, 10, 'Consult - Interfacility');
      'R':  SetPiece(x, U, 10, 'Procedure - Interfacility');
    end
  else
    begin
      if Piece(x, U, 5) = 'Consult' then SetPiece(x, U, 10, 'Consult')
      else SetPiece(x, U, 10, 'Procedure');
    end;
  x := Piece(x, U, 1) + U + FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 2))) + '  ' + U + '(' + Piece(x, U, 3) + ')' + U + Piece(x, U, 6) + Piece(x, U, 7) + U +
       'Consult #: ' + Piece(x, U, 1) + U + Piece(x, U, 8) + U + U + U + Piece(x, U, 10) + U + Piece(x, U, 4)+ U +
       Piece(x, U, 2) + U + Piece(x, U, 9);
  Result := x;
end;

function MakeConsultListDisplayText(InputString: string): string;
var
  x: string;
begin
  x := InputString;
  x := Piece(x, U, 2) + ' ' + Piece(x, U, 3) + ' ' + Piece(x, U, 4) + ' ' + Piece(x, U, 5);
  Result := x;
end;

function MakeConsultNoteDisplayText(RawText: string): string;
var
  x: string;
begin
  x := RawText;
  if CharInSet(Piece(x, U, 1)[1], ['A', 'N', 'E']) then
    x := Piece(x, U, 2)
  else
    begin
      x := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) + '  ' + Piece(x, U, 2) +
           ' (#' + Piece(Piece(x, U, 1), ';', 1) + ')';
      if not (Copy(Piece(Piece(RawText, U, 1), ';', 2), 1, 4) = 'MCAR') then
        x := x + ', ' + Piece(RawText, U, 6) + ', ' + Piece(Piece(RawText, U, 5), ';', 2);
    end;
  Result := x;
end;

procedure BuildServiceTree(Tree: TORTreeView; SvcList: TStrings; const Parent: string; Node: TORTreeNode);
var
  MyID, MyParent, Name, item: string;
  i, Idx: Integer;
  ParentNode, ChildNode: TORTreeNode;
//  tmpNode: TORTreeNode;
  HasChildren: Boolean;
//  AllNodes: TStringList;
  ParentNodes: TStringList;
//  List: TList;
//  Lists: TObjectList;
//  bad: boolean;

// Former code was only filtering out half the duplicates, depending on
// how they appeared in the tree.  Commented out code filters out all the duplicates,
// and still keeps the fast tree build.  However, CPRS Clinical Workgroup determined
// that no duplicates should be filtered out.  Code kept here in order to keep fast filter
// logic, in case duplicates are ever filtered out in the future.

{
  procedure FilterOutDuplicates;
  var
    j: integer;
  begin
    bad := false;
    if AllNodes.Find(MyID, Idx) then
    begin
      if AllNodes.Objects[Idx] is TORTreeNode then
      begin
        tmpNode := TORTreeNode(AllNodes.Objects[Idx]);
        bad := tmpNode.HasAsParent(ParentNode);
        if (not bad) and assigned(tmpNode.Parent) then
          bad := ParentNode.HasAsParent(tmpNode.Parent);
      end
      else
      begin
        bad := False;
        List := TList(AllNodes.Objects[Idx]);
        for j := 0 to List.Count - 1 do
        begin
          tmpNode := TORTreeNode(List[j]);
          bad := TORTreeNode(List[j]).HasAsParent(ParentNode);
          if (not bad) and assigned(tmpNode.Parent) then
            bad := ParentNode.HasAsParent(tmpNode.Parent);
          if bad then break;
        end;
      end;
    end;
  end;

  procedure AddNode;
  begin
    if AllNodes.Find(MyID, Idx) then
    begin
      if AllNodes.Objects[Idx] is TORTreeNode then
      begin
        List := TList.Create;
        Lists.Add(List);
        List.Add(AllNodes.Objects[Idx]);
        AllNodes.Objects[Idx] := List;
      end
      else
        List := TList(AllNodes.Objects[Idx]);
      List.Add(ChildNode);
    end
    else
      AllNodes.AddObject(MyId, ChildNode);
  end;
}

begin
  Tree.Items.BeginUpdate;
  ParentNodes := TStringList.Create;
//  AllNodes := TStringList.Create;
//  Lists := TObjectList.Create;
  try
    ParentNodes.Sorted := True;
//    AllNodes.Sorted := True;
    for i := 0 to SvcList.Count - 1 do
    begin
      item := SvcList[i];
      if Piece(item, U, 5) = 'S' then Continue; 
      MyParent := Piece(item, U, 3);
      MyID := Piece(item, U, 1);
      if not ParentNodes.Find(MyParent, Idx) then
        ParentNode := nil
      else
      begin
        ParentNode := TORTreeNode(ParentNodes.Objects[Idx]);
//        FilterOutDuplicates;
//        if bad then Continue;
      end;
      Name := Piece(item, U, 2);
      HasChildren := Piece(item, U, 4) = '+';
      ChildNode := TORTreeNode(Tree.Items.AddChild(ParentNode, Name));
      ChildNode.StringData := item;
//      AddNode;
      if HasChildren then
        ParentNodes.AddObject(MyID, ChildNode);
    end;
  finally
    ParentNodes.Free;
//    AllNodes.Free;
//    Lists.Free;
  end;
  Tree.Items.EndUpdate;
end;

procedure CreateListItemsForConsultTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: Boolean);
var
  i: Integer;
  x, x3, MyParent, MyService, MyStatus, MyType, StatusText: string;
  AList, SrcList: TStringList;
begin
  AList := TStringList.Create;
  SrcList := TStringList.Create;
  try
    FastAssign(Source, SrcList);
    with SrcList do
      begin
        if (Count = 1) and (Piece(Strings[0], U, 1) = '-1') then
          begin
            Dest.Insert(0, IntToStr(Context) + '^^^' + 'No Matching Consults Found' + '^^^^0^^^^');
            Exit;
          end;
        for i := 0 to Count - 1 do
          begin
            x := Strings[i];
            MyType   := Piece(x, U, 9);
            if Context = 0 then Context := CC_ALL;
            SetPiece(x, U, 8, IntToStr(Context));
            MyParent := Piece(x, U, 8);
            MyService  := Piece(x, U, 10);
            MyStatus   := Piece(x, U, 3);
            if Length(Trim(MyService)) = 0 then
              begin
                MyService := '** No Service **';
                SetPiece(x, U, 10, MyService);
              end;
            if Length(Trim(MyStatus)) = 0 then
              begin
                MyStatus := '** No Status **';
                SetPiece(x, U, 3, MyStatus);
              end;
            if GroupBy <> '' then case GroupBy[1] of
              'S':  begin
                      SetPiece(x, U, 8, MyParent + MyStatus);
                      if MyStatus = '(a)' then StatusText := 'Active'
                      else if MyStatus = '(p)' then StatusText := 'Pending'
                      else if MyStatus = '(pr)' then StatusText := 'Partial Results'
                      else if MyStatus = '(s)' then StatusText := 'Scheduled'
                      else if MyStatus = '(x)' then StatusText := 'Cancelled'
                      else if MyStatus = '(dc)' then StatusText := 'Discontinued'
                      else if MyStatus = '(c)' then StatusText := 'Completed'
                      else StatusText := 'Other';
                      x3 := MyStatus + U + StatusText + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;
              'V':  begin
                      SetPiece(x, U, 8, MyParent + MyService);
                      x3 := MyService + U + MixedCase(MyService) + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;
              'T':  begin
                      SetPiece(x, U, 8, MyParent + MyType);
                      x3 := MyType + U + MixedCase(MyType) + U + IntToStr(Context);
                      if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                    end;
            end;
            Dest.Add(x);
          end; {for}
        SortByPiece(TStringList(Dest), U, 11);
        if not Ascending then InvertStringList(TStringList(Dest));
        Dest.Insert(0, IntToStr(Context) + '^^^' + CC_TV_TEXT[Context] + '^^^+^0^^^^');
        Alist.Sort;
        InvertStringList(AList);
        for i := 0 to AList.Count-1 do
          Dest.Insert(0, IntToStr(Context) + Piece(AList[i], U, 1) + '^^^' + Piece(AList[i], U, 2) + '^^^+^' + Piece(AList[i], U, 3) + '^^^^');
      end;
  finally
    AList.Free;
    SrcList.Free;
  end;
end;

procedure BuildConsultsTree(Tree: TORTreeView; tmpList: TStrings; const Parent: string; Node: TORTreeNode;
           CurrentContext: TSelectContext);
var
  MyID, MyParent, Name, temp: string;
  i: Integer;
  ChildNode, tmpNode: TORTreeNode;
  HasChildren: Boolean;
begin
  Tree.Items.BeginUpdate;
  with tmpList do for i := 0 to Count - 1 do
    begin
      MyParent := Piece(Strings[i], U, 8);
      if (MyParent = Parent) then
        begin
          MyID := Piece(Strings[i], U, 1);
          Name := MakeConsultListDisplayText(Strings[i]);
          temp  := Strings[i];
          tmpNode := nil;
          HasChildren := Piece(Strings[i], U, 7) = '+';
          if Node <> nil then if Node.HasChildren then
            tmpNode := Tree.FindPieceNode(MyID, 1, U, Node);
          if (tmpNode <> nil) and tmpNode.HasAsParent(Node) then
            Continue
          else
            begin
              ChildNode := TORTreeNode(Tree.Items.AddChild(Node, Name));
              ChildNode.StringData := temp;
              SetNodeImage(ChildNode, CurrentContext);
              if HasChildren then
                  BuildConsultsTree(Tree, tmpList, MyID, ChildNode, CurrentContext);
            end;
        end;
    end;
  Tree.Items.EndUpdate;
end;

procedure SetNodeImage(Node: TORTreeNode; CurrentContext: TSelectContext);
begin
  with Node do
    begin
      if Piece(Stringdata, U, 8) = '0' then
        begin
          ImageIndex    := IMG_GMRC_TOP_LEVEL;
          SelectedIndex := IMG_GMRC_TOP_LEVEL;
          if (Piece(StringData, U, 4) = 'No Matching Consults Found') then exit;
          if Piece(Stringdata, U, 1) <> '-1' then
            with CurrentContext, Node do
              if GroupBy <> '' then case GroupBy[1] of
                'V': Text := CC_TV_TEXT[StrToInt(Piece(Stringdata, U, 1))] + ' by Service';
                'S': Text := CC_TV_TEXT[StrToInt(Piece(Stringdata, U, 1))] + ' by Status';
                'T': Text := CC_TV_TEXT[StrToInt(Piece(Stringdata, U, 1))] + ' by Type';
              end;
        end
      else
        begin
          if Piece(Stringdata, U, 7) <> '' then
            case Piece(Stringdata, U, 7)[1] of
              '+': begin
                     ImageIndex    := IMG_GMRC_GROUP_SHUT;
                     SelectedIndex := IMG_GMRC_GROUP_OPEN;
                   end;
            end
          else
            begin
              if Piece(StringData, U, 12) <> '' then
                case Piece(StringData, U, 12)[1] of
                  'C': ImageIndex := IMG_GMRC_CONSULT;
                  'P': ImageIndex := IMG_GMRC_ALL_PROC;  //IMG_GMRC_PROC;
                  'M': ImageIndex := IMG_GMRC_ALL_PROC;  //IMG_GMRC_CLINPROC;
                  'I': ImageIndex := IMG_GMRC_IFC_CONSULT;
                  'R': ImageIndex := IMG_GMRC_IFC_PROC;
                end
              else
                begin
                  if Piece(StringData, U, 9) = 'Procedure' then
                    ImageIndex := IMG_GMRC_ALL_PROC
                  else
                    ImageIndex := IMG_GMRC_CONSULT;
                end;
              SelectedIndex := ImageIndex;
            end;
        end;
      StateIndex := IMG_NONE;
    end;
end;

end.
