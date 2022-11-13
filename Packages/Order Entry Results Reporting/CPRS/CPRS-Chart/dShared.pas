unit dShared;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList, uTemplates, ORFn, ORNet, ExtCtrls, ORCtrls, Richedit,
  VA508ImageListLabeler, System.ImageList;

type
  TdmodShared = class(TDataModule)
    imgTemplates: TImageList;
    imgReminders: TImageList;
    imgNotes: TImageList;
    imgImages: TImageList;
    imgReminders2: TImageList;
    imgConsults: TImageList;
    imgSurgery: TImageList;
    imgLblReminders: TVA508ImageListLabeler;
    imgLblHealthFactorLabels: TVA508ImageListLabeler;
    imgLblNotes: TVA508ImageListLabeler;
    imgLblImages: TVA508ImageListLabeler;
    imgLblConsults: TVA508ImageListLabeler;
    imgLblSurgery: TVA508ImageListLabeler;
    imgLblReminders2: TVA508ImageListLabeler;
    procedure dmodSharedCreate(Sender: TObject);
    procedure dmodSharedDestroy(Sender: TObject);
  private
    FTIUObjects: TStringList;
    FInEditor: boolean;
    FOnTemplateLock: TNotifyEvent;
    FTagIndex: longint;
    FDrawerTrees: array of TWinControl;
    FRefreshObject: boolean;
  protected
    procedure EncounterLocationChanged(Sender: TObject);
    function IndexOfDrawer(ADrawer: TWinControl): integer;
  public
    function ImgIdx(Node: TTreeNode): integer;
    procedure AddTemplateNode(Tree: TTreeView; var EmptyCount: integer;
                              const tmpl: TTemplate; AllowInactive: boolean = FALSE;
                              const Owner: TTreeNode = nil);
    function ExpandNode(Tree: TTreeView; Node: TTreeNode;
              var EmptyCount: integer; AllowInactive: boolean = FALSE): boolean;
    procedure Resync(SyncNode: TTreeNode; AllowInactive: boolean;
                                var EmptyCount: integer);
    procedure AddDrawerTree(ADrawer: TWinControl);

    procedure RemoveDrawerTree(ADrawer: TWinControl);
    procedure Reload;
    procedure LoadTIUObjects;
    function BoilerplateOK(const Txt, CRDelim: string; ObjList: TStringList;
                                                       var Err: TStringList): boolean;
    function TemplateOK(tmpl: TTemplate; Msg: string = ''): boolean;
    function NeedsCollapsing(Tree: TTreeView): boolean;
    procedure SelectNode(Tree: TORTreeView; GotoNodeID: string; var EmptyCount: integer);
    procedure ExpandTree(Tree: TORTreeView; ExpandString: string; var EmptyCount: integer;
                         AllowInactive: boolean = FALSE);
    function InDialog(Node: TTreeNode): boolean;
    property InEditor: boolean read FInEditor write FInEditor;
    property OnTemplateLock: TNotifyEvent read FOnTemplateLock write FOnTemplateLock;
    property TIUObjects: TStringList read FTIUObjects;
    property RefreshObject: boolean read FRefreshObject write FRefreshObject;
    procedure FindRichEditText(AFindDialog: TFindDialog; ARichEdit: TRichEdit);
    procedure FindRichEditTextAll(Rich: TRichEdit; AFindDialog: TFindDialog; Color: TColor; Style:
     TFontStyles);
    procedure ReplaceRichEditText(AReplaceDialog: TReplaceDialog; ARichEdit: TRichEdit);
  end;

var
  dmodShared: TdmodShared;

const
  ObjMarker = '^@@^';
  ObjMarkerLen = length(ObjMarker);
  DlgPropMarker = '^@=';
  DlgPropMarkerLen = length(DlgPropMarker);
  NoTextMarker = '<@>';

implementation

uses
  mDrawers, fDrawers, rTemplates, uCore, uTemplateFields, uEventHooks, VA508AccessibilityRouter,
  System.UITypes, VAUtils;

{$R *.DFM}

const
  TemplateImageIdx: array[TTemplateType, Boolean, Boolean] of integer =
                          //    Personal       Shared
                          //  Closed  Open   Closed  Open
                          (((    0,    0), (    0,    0)),  //  ttNone,
                           ((    0,    1), (    0,    1)),  //  ttMyRoot
                           ((    0,    1), (    0,    1)),  //  ttRoot
                           ((    0,    1), (    0,    1)),  //  ttTitles
                           ((    0,    1), (    0,    1)),  //  ttConsults
                           ((    0,    1), (    0,    1)),  //  ttProcedures
                           ((    2,    3), (   16,   17)),  //  ttClass
                           ((    4,    4), (   10,   10)),  //  ttDoc
                           ((    5,    6), (   11,   12)),  //  ttGroup
                           ((    7,    7), (   13,   13)),  //  ttDocEx
                           ((    8,    9), (   14,   15))); //  ttGroupEx

  DialogConvMax = 7;
  DialogImageXRef: array[0..DialogConvMax, Boolean] of integer =
                           ((5,18), (6,19),
                            (8,20), (9,21),
                            (11,22),(12,23),
                            (14,24),(15,25));
                            
  RemDlgIdx: array[boolean] of integer = (26, 27);
  COMObjIdx: array[boolean] of integer = (29, 28);

function TdmodShared.ImgIdx(Node: TTreeNode): integer;
var
  Typ: TTemplateType;
  i: integer;

begin
  Result := -1;
  if(assigned(Node.Data)) then
  begin
    with TTemplate(Node.Data) do
    begin
      if (RealType = ttDoc) and (IsReminderDialog) then
        Result := RemDlgIdx[(PersonalOwner <= 0)]
      else
      if (RealType = ttDoc) and (IsCOMObject) then
        Result := COMObjIdx[COMObjectOK(COMObject)]
      else
      begin
        Typ := TemplateType;
        if(Exclude and (Typ in [ttDocEx, ttGroupEx])) then
        begin
          if(not assigned(Node.Parent)) or (TTemplate(Node.Parent.Data).RealType <> ttGroup) then
          begin
            case Typ of
              ttDocEx: Typ := ttDoc;
              ttGroupEx: Typ := ttGroup;
            end;
          end;
        end;
        Result := TemplateImageIdx[Typ, (PersonalOwner <= 0),
                  (Node.Expanded and Node.HasChildren)];
        if(Dialog and (Typ in [ttGroup, ttGroupEx])) then
        begin
          for i := 0 to DialogConvMax do
          begin
            if(Result = DialogImageXRef[i, FALSE]) then
            begin
              Result := DialogImageXRef[i, TRUE];
              break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TdmodShared.AddTemplateNode(Tree: TTreeView; var EmptyCount: integer;
                              const tmpl: TTemplate; AllowInactive: boolean = FALSE;
                              const Owner: TTreeNode = nil);
var
  Cur, Next: TTreeNode;
  Done: boolean;
  NewNode: TTreeNode;

  procedure AddChildObject(Owner: TTreeNode);
  begin
    NewNode := Tree.Items.AddChildObject(Owner, tmpl.PrintName, tmpl);
    TORTreeNode(NewNode).StringData := tmpl.ID + U + tmpl.PrintName;
    NewNode.Cut := not tmpl.Active;
    tmpl.AddNode(NewNode);
    Done := TRUE;
  end;

begin
  if((assigned(tmpl)) and ((tmpl.Active) or AllowInactive)) then
  begin
    Done := FALSE;
    NewNode := nil;
    if(assigned(Owner)) then
    begin
      Cur := Owner.GetFirstChild;
      if(not assigned(Cur)) then
        AddChildObject(Owner);
    end
    else
    begin
      Cur := Tree.Items.GetFirstNode;
      if(not assigned(Cur)) then
        AddChildObject(nil);
    end;
    if(not Done) then
    begin
      repeat
        if(Cur.Data = tmpl) then
          Done := TRUE
        else
        begin
          Next := Cur.GetNextSibling;
          if(assigned(Next)) then
            Cur := Next
          else
            AddChildObject(Owner);
        end;
      until Done;
    end;
    if(assigned(NewNode) and (InEditor or (not tmpl.HideItems)) and 
                             ((tmpl.Children in [tcActive, tcBoth]) or
                             ((tmpl.Children <> tcNone) and AllowInactive))) then
    begin
      Tree.Items.AddChild(NewNode, EmptyNodeText);
      inc(EmptyCount);
    end;
  end;
end;

function TdmodShared.ExpandNode(Tree: TTreeView; Node: TTreeNode;
              var EmptyCount: integer; AllowInactive: boolean = FALSE): boolean;

var
  TmpNode: TTreeNode;
  tmpl: TTemplate;
  i :integer;

begin
  TmpNode := Node.GetFirstChild;
  Result := TRUE;
  if((assigned(TmpNode)) and (TmpNode.Text = EmptyNodeText)) then
  begin
    TmpNode.Delete;
    dec(EmptyCount);
    tmpl := TTemplate(Node.Data);
    ExpandTemplate(tmpl);
    for i := 0 to tmpl.Items.Count-1 do
      AddTemplateNode(Tree, EmptyCount, TTemplate(tmpl.Items[i]),
                      AllowInactive, Node);
    if((tmpl.Children = tcNone) or ((not AllowInactive) and (tmpl.Children = tcInactive))) then
      Result := FALSE;
  end;
end;

procedure TdmodShared.Resync(SyncNode: TTreeNode; AllowInactive: boolean; var EmptyCount: integer);
var
  FromGet: boolean;
  IDCount, SyncLevel, i: integer;
  SyncExpanded: boolean;
  Node: TTreeNode;
  Template: TTemplate;
  IDSort, CurExp: TStringList;
  SelID, TopID: string;
  DoSel, DoTop: boolean;
  Tree: TTreeView;
  First: boolean;
  TagCount: longint;

  function InSyncNode(Node: TTreeNode): boolean;
  var
    TmpNode: TTreeNode;

  begin
    Result := FALSE;
    TmpNode := Node;
    while((not Result) and assigned(TmpNode)) do
    begin
      if(TmpNode = SyncNode) then
        Result := TRUE
      else
        TmpNode := TmpNode.Parent;
    end;
  end;

  function GetID(Node: TTreeNode): string;
  var
    tmpl: TTemplate;
    IDX: string;
    
  begin
    inc(IDCount);
    Result := '';
    if(assigned(Node) and assigned(Node.Data)) then
    begin
      tmpl := TTemplate(Node.Data);
      if((tmpl.ID = '') or (tmpl.ID = '0')) then
      begin
        if(tmpl.LastTagIndex <> FTagIndex) then
        begin
          tmpl.LastTagIndex := FTagIndex;
          inc(TagCount);
          tmpl.tag := TagCount;
        end;
        IDX := '<'+IntToStr(tmpl.Tag)+'>';
      end
      else
        IDX := tmpl.ID;
      if(Node <> SyncNode) and (assigned(Node.Parent)) then
        Result := U + GetID(Node.Parent);
      Result := IDX + Result;
    end;
    dec(IDCount);
    if((not FromGet) and (IDCount = 0) and (Result <> '')) then
      Result := IntToStr(Node.AbsoluteIndex) + U + Result;
  end;

  function GetNode(ID: string): TTreeNode;
  var
    idx, i :integer;
    TrueID, TmpStr: string;
    TmpNode: TTreeNode;

  begin
    Result := nil;
    if(ID <> '') then
    begin
      idx := StrToIntDef(Piece(ID,U,1),0);
      i := pos(U,ID);
      if(i > 0) then
      begin
        delete(ID,1,i);
        FromGet := TRUE;
        try
          TmpNode := SyncNode.GetFirstChild;
          while ((not assigned(Result)) and (assigned(TmpNode)) and
                 (TmpNode.Level > SyncLevel)) do
          begin
            if(GetID(TmpNode) = ID) then
              Result := TmpNode
            else
              TmpNode := TmpNode.GetNext;
          end;
          if(not assigned(Result)) then
          begin
            TrueID := piece(ID,U,1);
            TmpNode := SyncNode.GetFirstChild;
            while ((not assigned(Result)) and (assigned(TmpNode)) and
                   (TmpNode.Level > SyncLevel)) do
            begin
              if(assigned(TmpNode.Data) and (TTemplate(TmpNode.Data).ID = TrueID)) then
              begin
                TmpStr := IntToStr(abs(idx-TmpNode.AbsoluteIndex));
                TmpStr := copy('000000',1,7-length(TmpStr))+TmpStr;
                IDSort.AddObject(TmpStr,TmpNode);
              end;
              TmpNode := TmpNode.GetNext;
            end;
            if(IDSort.Count > 0) then
            begin
              IDSort.Sort;
              Result := TTreeNode(IDSort.Objects[0]);
              IDSort.Clear;
            end;
          end;
        finally
          FromGet := FALSE;
        end;
      end;
    end;
  end;

  procedure BuildNodes(tmpl: TTemplate; Owner: TTreeNode);
  var
    i: integer;
    TmpNode: TTreeNode;

  begin
    if(tmpl.Active or AllowInactive) then
    begin
      if(First) then
      begin
        First := FALSE;
        TmpNode := Owner;
      end
      else
      begin
        TmpNode := Tree.Items.AddChildObject(Owner, tmpl.PrintName, tmpl);
        TORTreeNode(TmpNode).StringData := tmpl.ID + U + tmpl.PrintName;
        TmpNode.Cut := not tmpl.Active;
        tmpl.AddNode(TmpNode);
      end;
      if(tmpl.Expanded) then
      begin
        for i := 0 to tmpl.Items.Count-1 do
          BuildNodes(TTemplate(tmpl.Items[i]), TmpNode);
      end
      else
      if(InEditor or (not tmpl.HideItems)) and
         ((tmpl.Children in [tcActive, tcBoth]) or
         (AllowInactive and (tmpl.Children = tcInactive))) then
      begin
        Tree.Items.AddChild(TmpNode, EmptyNodeText);
        inc(EmptyCount);
      end;
    end;
  end;

begin
  if(assigned(SyncNode)) then
  begin
    TagCount := 0;
    inc(FTagIndex);
    Tree := TTreeView(SyncNode.TreeView);
    Tree.Items.BeginUpdate;
    try
      SyncExpanded := SyncNode.Expanded;
      Template := TTemplate(SyncNode.Data);
      SyncLevel := SyncNode.Level;
      FromGet := FALSE;
      IDCount := 0;
      IDSort := TStringList.Create;
      try
      {-- Get the Current State of the tree --}
        CurExp := TStringList.Create;
        try
          Node := Tree.TopItem;
          DoTop := InSyncNode(Node);
          if(DoTop) then
            TopID := GetID(Node);

          Node := Tree.Selected;
          DoSel := InSyncNode(Node);
          if(DoSel) then
            SelID := GetID(Node);

          Node := SyncNode.GetFirstChild;
          while ((assigned(Node)) and (Node.Level > SyncLevel)) do
          begin
            if(Node.Text = EmptyNodeText) then
              dec(EmptyCount)
            else
            if(Node.Expanded) then
              CurExp.Add(GetID(Node));
            if(assigned(Node.Data)) then
              TTemplate(Node.Data).RemoveNode(Node);
            Node := Node.GetNext;
          end;

        {-- Recursively Rebuild the Tree --}
          SyncNode.DeleteChildren;
          First := TRUE;
          BuildNodes(Template, SyncNode);

        {-- Attempt to restore Tree to it's former State --}
          SyncNode.Expanded := SyncExpanded;
          for i := 0 to CurExp.Count-1 do
          begin
            Node := GetNode(CurExp[i]);
            if(assigned(Node)) then
              Node.Expand(FALSE);
          end;

          if(DoTop) and (TopID <> '') then
          begin
            Node := GetNode(TopID);
            if(assigned(Node)) then
              Tree.TopItem := Node;
          end;

          if(DoSel) and (SelID <> '') then
          begin
            Node := GetNode(SelID);
            if(assigned(Node)) then
            begin
              Tree.Selected := Node;
              Node.MakeVisible;
            end;
          end;

        finally
          CurExp.Free;
        end;

      finally
        IDSort.Free;
      end;

    finally
      Tree.Items.EndUpdate;
    end;
  end;
end;


procedure TdmodShared.dmodSharedCreate(Sender: TObject);
begin
  imgReminders.Overlay(6,0);
  imgReminders.Overlay(7,1);
  imgReminders2.Overlay(4,0);
end;

procedure TdmodShared.dmodSharedDestroy(Sender: TObject);
begin
 // KillObj(@FDrawerTrees);
  SetLength(FDrawerTrees, 0);
  KillObj(@FTIUObjects);

end;

procedure TdmodShared.AddDrawerTree(ADrawer: TWinControl);
begin
  if (IndexOfDrawer(ADrawer) < 0) then begin
    SetLength(FDrawerTrees, Length(FDrawerTrees) + 1);
    FDrawerTrees[Length(FDrawerTrees) - 1] := ADrawer;
  end;
  Encounter.Notifier.NotifyWhenChanged(EncounterLocationChanged);
end;

procedure TdmodShared.RemoveDrawerTree(ADrawer: TWinControl);
var
  i, idx: integer;
begin
 // if(assigned(FDrawerTrees)) then
  if Length(FDrawerTrees) > 0 then
  begin
    idx := IndexOfDrawer(ADrawer);
    if(idx >= 0) then begin
      for i := idx to Length(fDrawerTrees) - 2 do begin
        fDrawerTrees[i] := fDrawerTrees[i+1];
      end;
      SetLength(fDrawerTrees, Length(fDrawerTrees) - 1);
    end;
  end;
end;

procedure TdmodShared.Reload;
var
  i: integer;

begin
  //if(assigned(FDrawerTrees)) then begin
  if Length(FDrawerTrees) > 0 then begin
    ReleaseTemplates;
    for i := 0 to Length(FDrawerTrees) - 1 do begin
      if (fDrawerTrees[i] is TfrmDrawers) then begin
        TfrmDrawers(FDrawerTrees[i]).ExternalReloadTemplates;
      end else if (fDrawerTrees[i] is TfraDrawers) then begin
        TfraDrawers(FDrawerTrees[i]).ExternalReloadTemplates;
      end;
    end;
  end;
end;

procedure TdmodShared.LoadTIUObjects;
var
  i: integer;
  aLst: TStringList;
begin
  if (not assigned(FTIUObjects)) or (FRefreshObject = TRUE) then
  begin
    if(not assigned(FTIUObjects)) then
      FTIUObjects := TStringList.Create;
    FTIUObjects.Clear;
      aLst := TStringList.Create;
      try
        GetObjectList(aLst);
        for i := 0 to aLst.Count - 1 do
          FTIUObjects.Add(MixedCase(Piece(aLst[i], U, 2)) + U + aLst[i]);
      finally
        FreeAndNil(aLst);
      end;
    FTIUObjects.Sort;
      FRefreshObject := FALSE;
   end;
end;

function TdmodShared.NeedsCollapsing(Tree: TTreeView): boolean;
var
  Node: TTreeNode;

begin
  Result := FALSE;
  if(assigned(Tree)) then
  begin
    Node := Tree.Items.GetFirstNode;
    while((not Result) and assigned(Node)) do
    begin
      Result := Node.Expanded;
      Node := Node.GetNextSibling;
    end;
  end;
end;

function TdmodShared.BoilerplateOK(const Txt, CRDelim: string; ObjList: TStringList;
                                                               var Err: TStringList): boolean;
var
  cnt, i, j, p: integer;
  tmp,obj: string;
  BadObj, ok: boolean;

  procedure AddErr(Amsg: string);
  begin
    if(not assigned(Err)) then
      Err := TStringList.Create;
    Err.Add(Amsg)
  end;

  function ErrCount: integer;
  begin
    if(Assigned(Err)) then
      Result := Err.Count
    else
      Result := 0;
  end;

begin
  if(assigned(ObjList)) then
    ObjList.Clear;
  cnt := ErrCount;
  tmp := Txt;
  BadObj := FALSE;
  repeat
    i := pos('|',tmp);
    if(i > 0) then
    begin
      delete(tmp,1,i);
      j := pos('|',tmp);
      if(j = 0) then
      begin
        AddErr('Unpaired "|" in Boilerplate');
        continue;
      end;
      obj := copy(tmp,1,j-1);
      delete(tmp,1,j);
      if(obj = '') then
      begin
        AddErr('Brackets "||" are there, but there''s no name inside it.');
        continue;
      end;
      j := pos(CRDelim, obj);
      if(j > 0) then
      begin
        AddErr('Object "'+copy(obj,1,j-1)+'" split between lines');
        continue;
      end;
      LoadTIUObjects;
      ok := FALSE;
      for j := 0 to FTIUObjects.Count-1 do
      begin
        for p := 3 to 5 do
        begin
          if(obj = piece(FTIUObjects[j],U,p)) then
          begin
            ok := TRUE;
            if(assigned(ObjList)) and (ObjList.IndexOf(ObjMarker + obj) < 0) then
            begin
              ObjList.Add(ObjMarker + obj);
              ObjList.Add('|' + obj + '|');
            end;
            break;
          end;
        end;
        if(ok) then break;
      end;
      if(not ok) then
      begin
        AddErr('Object "'+obj+'" not found.');
        BadObj := TRUE;
      end;
    end;
  until(i=0);
  Result := (cnt = ErrCount);
  if(not Result) then
  begin
    Err.Insert(0,'Boilerplate Contains Errors:'); 
    Err.Insert(1,'');
    if(BadObj) then
    begin
      Err.Add('');
      Err.Add('Use UPPERCASE and object''s exact NAME, PRINT NAME, or ABBREVIATION');
      Err.Add('Any of these may have changed since an object was embedded.');
    end;
  end;
  if(assigned(ObjList) and (ObjList.Count > 0)) then
    ObjList.Add(ObjMarker);
end;

function TdmodShared.TemplateOK(tmpl: TTemplate; Msg: string = ''): boolean;
var
  Err: TStringList;
  btns: TMsgDlgButtons;

begin
  Err := nil;
  try
    Result := BoilerplateOK(tmpl.FullBoilerplate, #13, nil, Err);
    if(not Result) then
    begin
      if(Msg = 'OK') then
        btns := [mbOK]
      else
      begin
        btns := [mbAbort, mbIgnore];
        Err.Add('');
        if(Msg = '') then
          Msg := 'template insertion';
        Err.Add('Do you want to Abort '+Msg+', or Ignore the error and continue?');
      end;
      Result := (MessageDlg(Err.Text, mtError, btns, 0) = mrIgnore);
    end;
  finally
    if(assigned(Err)) then
      Err.Free;
  end;
  if Result then
    Result := BoilerplateTemplateFieldsOK(tmpl.FullBoilerplate, Msg);
end;

procedure TdmodShared.EncounterLocationChanged(Sender: TObject);
var
  i: integer;

begin
  //if(assigned(FDrawerTrees)) then
  if Length(FDrawerTrees) > 0 then
  begin
    for i:= 0 to Length(FDrawerTrees) - 1 do begin
      if (fDrawerTrees[i] is TfrmDrawers) then begin
        TfrmDrawers(FDrawerTrees[i]).UpdatePersonalTemplates;
      end else if (fDrawerTrees[i] is TfraDrawers) then begin
        TfraDrawers(FDrawerTrees[i]).UpdatePersonalTemplates;
      end;

    end;
  end;
end;

procedure TdmodShared.SelectNode(Tree: TORTreeView; GotoNodeID: string; var EmptyCount: integer);
var
  i, j: integer;
  IEN, PIEN: string;
  Node: TORTreeNode;

  function FindNode(StartNode: TORTreeNode): TORTreeNode;
  begin
    Result := nil;
    while assigned(StartNode) do
    begin
      if(Piece(StartNode.StringData, U ,1) = IEN) then
      begin
        Result := StartNode;
        exit;
      end;
      StartNode := TORTreeNode(StartNode.GetNextSibling);
    end;
  end;

begin
  if(GotoNodeID <> '') then
  begin
    i := 1;
    for j := 1 to length(GotoNodeID) do
      if(GotoNodeID[j] = ';') then inc(i);
    PIEN := '';
    Node := TORTreeNode(Tree.Items.GetFirstNode);
    repeat
      IEN := piece(GotoNodeID, ';', i);
      if(IEN <> '') then
      begin
        Node := FindNode(Node);
        if(assigned(Node)) then
        begin
          if(PIEN <> '') then
            PIEN := ';' + PIEN;
          PIEN := IEN + PIEN;
          if(PIEN = GotoNodeID) then
          begin
            Node.EnsureVisible;
            Tree.Selected := Node;
            IEN := '';
          end
          else
          begin
            dmodShared.ExpandNode(Tree, Node, EmptyCount);
            Node := TORTreeNode(Node.GetFirstChild);
            if(assigned(Node)) then
              dec(i)
            else
              IEN := '';
          end;
        end
        else
          IEN := '';
      end;
    until (i < 1) or (IEN = '');
    if Assigned(Tree.selected) then
      Tree.selected.MakeVisible;
  end;
end;

function TdmodShared.IndexOfDrawer(ADrawer: TWinControl): integer;
begin
  Result := 0;
  while (Result < Length(FDrawerTrees)) and (FDrawerTrees[Result] <> ADrawer) do inc(Result);
  if (Result = Length(FDrawerTrees)) then
    Result := -1;
end;

function TdmodShared.InDialog(Node: TTreeNode): boolean;
begin
  Result := FALSE;
  while assigned(Node) and (not Result) do
  begin
    if TTemplate(Node.Data).IsDialog then
      Result := TRUE
    else
      Node := Node.Parent;
  end;
end;

procedure TdmodShared.ExpandTree(Tree: TORTreeView; ExpandString: string;
  var EmptyCount: integer; AllowInactive: boolean = FALSE);

var
  NStr: string;
  i: integer;
  Node: TTreeNode;

begin
  Tree.Items.BeginUpdate;
  try
    i := 1;
    repeat
      NStr := piece(ExpandString,U,i);
      if(NStr <> '') then
      begin
        inc(i);
        Node := Tree.FindPieceNode(NStr, 1, ';');
        if assigned(Node) then
        begin
          ExpandNode(Tree, Node, EmptyCount, AllowInactive);
          Node.Expand(False);
        end;
      end;
    until(NStr = '');
  finally
    Tree.Items.EndUpdate;
  end;
end;

procedure TdmodShared.FindRichEditText(AFindDialog: TFindDialog; ARichEdit: TRichEdit);
const
  TX_NOMATCH = 'The text was not found';
  TC_NOMATCH = 'No more matches';
var
  FoundAt, FoundLine, TopLine, BottomLine: LongInt;
  StartPos, ToEnd, CharPos: Integer;
  SearchOpts: TSearchTypes;
begin
  SearchOpts := [];
  with ARichEdit do
  begin
    SetFocus;
    { begin the search after the current selection if there is one }
    { otherwise, begin at the start of the text }
    if SelStart <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;
    { ToEnd is the length from StartPos to the end of the text in the rich edit control }
    ToEnd := Length(Text) - StartPos;
    if frMatchCase in AFindDialog.Options then Include(SearchOpts, stMatchCase);
    if frWholeWord in AFindDialog.Options then Include(SearchOpts, stWholeWord);
    FoundAt := FindText(AFindDialog.FindText, StartPos, ToEnd, SearchOpts);
    if FoundAt <> -1 then
    begin
      SetFocus;
      TopLine := SendMessage(Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
      BottomLine := TopLine + (Height div FontHeightPixel(Font.Handle));
      FoundLine := SendMessage(Handle, EM_EXLINEFROMCHAR, 0, FoundAt);
      if (FoundLine + 10) > BottomLine then
        SendMessage(Handle, EM_LINESCROLL, 0, FoundLine - BottomLine + 10);
      CharPos := Pos(AFindDialog.FindText, Lines[FoundLine]);
      SendMessage(ARichEdit.Handle, EM_LINESCROLL, CharPos, 0);
      SelStart := FoundAt;
      SelLength := Length(AFindDialog.FindText);
    end
    else
    begin
      if not (frReplaceAll in AFindDialog.Options) then InfoBox(TX_NOMATCH, TC_NOMATCH, MB_OK);
      SelStart := 0;
      SelLength := 0;
      Windows.SetFocus(AFindDialog.Handle);
    end;
  end;
end;

procedure TdmodShared.FindRichEditTextAll(Rich: TRichEdit; AFindDialog: TFindDialog; Color:
TColor; Style: TFontStyles);
var
 CharPos, CharPos2, endChars: Integer;
 SearchOpts: TSearchTypes;
 Format: CHARFORMAT2;
begin
 //Clear out the variables
 CharPos := 0;
 endChars := 0;
 SearchOpts := [];
 if Length(Rich.Text) > 0 then
  endChars := Length(Rich.Text);
 repeat
  //Get the search options
  if frMatchCase in AFindDialog.Options then Include(SearchOpts, stMatchCase);
  if frWholeWord in AFindDialog.Options then Include(SearchOpts, stWholeWord);
  //find the text and save the position
  CharPos2 := Rich.FindText(AFindDialog.FindText, CharPos, endChars, SearchOpts);
  CharPos := CharPos2 + 1;
  //Select the word
  Rich.SelStart := CharPos2;
  Rich.SelLength := Length(AFindDialog.FindText);
  //Set the background color
  FillChar(Format, SizeOf(Format), 0);
  Format.cbSize := SizeOf(Format);
  Format.dwMask := CFM_BACKCOLOR ;
  Format.crBackColor := ColorToRGB(Color);
  Rich.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
  //Set the style of the found word
  Rich.SelAttributes.Style := Style;
 until charpos = 0;
 AFindDialog.CloseDialog;
end;

procedure TdmodShared.ReplaceRichEditText(AReplaceDialog: TReplaceDialog; ARichEdit: TRichEdit);
const
  TC_COMPLETE  = 'Replacement Complete';
  TX_COMPLETE1 = 'CPRS has finished searching the document.  ' + CRLF;
  TX_COMPLETE2 = ' replacements were made.';
var
  Replacements: integer;
  NewStart: integer;
begin
  Replacements := 0;
  if (frReplace in AReplaceDialog.Options) then
    begin
      if ARichEdit.SelLength > 0 then
        begin
          NewStart := ARichEdit.SelStart + Length(AReplaceDialog.ReplaceText);
          ARichEdit.SelText := AReplaceDialog.ReplaceText;
          ARichEdit.SelStart := NewStart;
        end;
      FindRichEditText(AReplaceDialog, ARichEdit);
    end
  else if (frReplaceAll in AReplaceDialog.Options) then
    begin
      repeat
        if ARichEdit.SelLength > 0 then
          begin
            NewStart := ARichEdit.SelStart + Length(AReplaceDialog.ReplaceText);
            ARichEdit.SelText := AReplaceDialog.ReplaceText;
            ARichEdit.SelStart := NewStart;
            Replacements := Replacements + 1;
          end;
        FindRichEditText(AReplaceDialog, ARichEdit);
      until ARichEdit.SelLength = 0;
      InfoBox(TX_COMPLETE1 + IntToStr(Replacements) + TX_COMPLETE2, TC_COMPLETE, MB_OK);
    end
  else
    FindRichEditText(AReplaceDialog, ARichEdit);
end;

initialization
  SpecifyFormIsNotADialog(TdmodShared);

end.
