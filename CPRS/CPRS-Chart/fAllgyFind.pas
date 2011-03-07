unit fAllgyFind;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ComCtrls, ImgList, VA508AccessibilityManager,
  VA508ImageListLabeler, ExtCtrls;

type
  TfrmAllgyFind = class(TfrmAutoSz)
    txtSearch: TCaptionEdit;
    cmdSearch: TButton;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblSearch: TLabel;
    lblSelect: TLabel;
    stsFound: TStatusBar;
    ckNoKnownAllergies: TCheckBox;
    tvAgent: TORTreeView;
    imTree: TImageList;
    lblDetail: TLabel;
    lblSearchCaption: TLabel;
    imgLblAllgyFindTree: TVA508ImageListLabeler;
    NoAllergylbl508: TVA508StaticText;
    procedure cmdSearchClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
    procedure BuildAgentTree(AgentList: TStrings; const Parent: string; Node: TORTreeNode);
    procedure ckNoKnownAllergiesClick(Sender: TObject);
    procedure tvAgentDblClick(Sender: TObject);
  private
    FAllergy: string   ;
    FExpanded : boolean;
  end;

procedure AllergyLookup(var Allergy: string; NKAEnabled: boolean);

implementation

{$R *.DFM}

uses rODAllergy, fARTFreeTextMsg, VA508AccessibilityRouter;

const
  IMG_MATCHES_FOUND = 1;
  IMG_NO_MATCHES    = 2;

  TX_3_CHAR     = 'Enter at least 3 characters for a search.';
  ST_SEARCHING  = 'Searching for allergies...';
  ST_FOUND      = 'Select from the matching entries on the list, or search again.';
  ST_NONE_FOUND = 'No matching items were found.';
  TC_FREE_TEXT  = 'Causative Agent Not On File - No Matches for ';
(*  TX_FREE_TEXT  = 'Would you like to request that this term be added to' + #13#10 +
                  'the list of available allergies?' + #13#10 + #13#10 +
                  '"YES" will send a bulletin to request addition of your' + #13#10 +
                  'entry to the ALLERGY file for future use, since '   + #13#10 +
                  'free-text entries for a patient are not allowed.' + #13#10 + #13#10 +
                  '"NO" will allow you to enter another search term.  Please' + #13#10 +
                  'check your spelling, try alternate spellings or a trade name,' + #13#10 +
                  'or contact your allergy coordinator for assistance.' + #13#10 + #13#10 +
                  '"CANCEL" will abort this entry process completely.';*)
  // NEW TEXT SUBSTITUTED IN V26.50 - RV
  TX_FREE_TEXT  = 'The agent you typed was not found in the database.'  + CRLF +
                  'Consider the common causes of search failure:'       + CRLF +
                  '      Misspellings'                                  + CRLF +
	          '      Typing more than one agent in a single entry ' + CRLF +
	          '      Typing "No known allergies"'                   + CRLF +
                   CRLF +
                   'Select "NO" to attempt the search again.  Carefully check your spelling,'+ CRLF +
                   'try an alternate spelling, a trade name, a generic name or just entering' + CRLF +
                   'the first few characters (minimum of 3).  Enter only one allergy at a time.' + CRLF +
                   'Use the "No Known Allergies" check box to mark a patient as NKA.' + CRLF +
                   CRLF +
                   'Select "YES" to send a bulletin to the allergy coordinator to request assistance.'  + CRLF +
                   'Only do this if you''ve tried alternate methods of finding the causative agent'  + CRLF +
                   'and have been unsuccessful.'  + CRLF +
                   CRLF +
                  'Select "CANCEL" to abort this entry process.';

  TX_BULLETIN   = 'Bulletin has been sent.' + CRLF +
                  'NOTE: This reactant was NOT added for this patient.';
  TC_BULLETIN_ERROR = 'Unable to Send Bulletin';
  TX_BULLETIN_ERROR = 'Free text entries are no longer allowed.' + #13#10 +
                      'Please contact your allergy coordinator if you need assistance.';
var
  uFileCount: integer;
  ScreenReader: boolean;

procedure AllergyLookup(var Allergy: string; NKAEnabled: boolean);
var
  frmAllgyFind: TfrmAllgyFind;
begin
  frmAllgyFind := TfrmAllgyFind.Create(Application);
  try
    ResizeFormToFont(TForm(frmAllgyFind));
    //TDP - CQ#19731 Need adjust 508StaticText label slightly when font 12 or larger
    case frmAllgyFind.Font.Size of
      18: frmAllgyFind.NoAllergylbl508.Left := frmAllgyFind.NoAllergylbl508.Left - 10;
      14: frmAllgyFind.NoAllergylbl508.Left := frmAllgyFind.NoAllergylbl508.Left - 6;
      12: frmAllgyFind.NoAllergylbl508.Left := frmAllgyFind.NoAllergylbl508.Left - 3;
    end;
    frmAllgyFind.ckNoKnownAllergies.Enabled := NKAEnabled;
    //TDP - CQ#19731 make sure NoAllergylbl508 is enabled and visible if
    //      ckNoKnownAllergies is disabled
    if (ScreenReaderSystemActive) and (frmAllgyFind.ckNoKnownAllergies.Enabled = False) then
    begin
      frmAllgyFind.NoAllergylbl508.Enabled := True;
      frmAllgyFind.NoAllergylbl508.Visible := True;
    end;
    //TDP - CQ#19731 make sure NoAllergylbl508 is not enabled or visible if
    //      ckNoKnownAllergies is enabled
    if frmAllgyFind.ckNoKnownAllergies.Enabled = True then
    begin
      frmAllgyFind.NoAllergylbl508.Enabled := False;
      frmAllgyFind.NoAllergylbl508.Visible := False;
    end;
    frmAllgyFind.ShowModal;
    Allergy := frmAllgyFind.FAllergy;
  finally
    frmAllgyFind.Release;
  end;
end;

procedure TfrmAllgyFind.FormCreate(Sender: TObject);
begin
  inherited;
  FAllergy := '';
  cmdOK.Enabled := False;
  //TDP - CQ#19731 Allow tab to empty search results (tvAgent) when JAWS running
  //      and provide 508 hint
  if ScreenReaderSystemActive then
  begin
    tvAgent.TabStop := True;
    amgrMain.AccessText[tvAgent] := 'No Search Items to Display';
    ScreenReader := True;
  end;
end;

procedure TfrmAllgyFind.txtSearchChange(Sender: TObject);
begin
  inherited;
  cmdSearch.Default := True;
  cmdOK.Default := False;
  cmdOK.Enabled := False;
end;

procedure TfrmAllgyFind.cmdSearchClick(Sender: TObject);
var
  AList: TStringlist;
  tmpNode1: TORTreeNode;
  i: integer;
begin
  inherited;
  if Length(txtSearch.Text) < 3 then
    begin
      InfoBox(TX_3_CHAR, 'Information', MB_OK or MB_ICONINFORMATION);
      Exit;
    end;
  StatusText(ST_SEARCHING);
  FExpanded := False;
  AList := TStringList.Create;
  try
    if tvAgent.Items <> nil then tvAgent.Items.Clear;
    FastAssign(SearchForAllergies(UpperCase(txtSearch.Text)), AList);
    uFileCount := 0;
    for i := 0 to AList.Count - 1 do
      if Piece(AList[i], U, 5) = 'TOP' then uFileCount := uFileCount + 1;
    if AList.Count = uFileCount  then
    begin
      lblSelect.Visible := False;
      txtSearch.SetFocus;
      txtSearch.SelectAll;
      cmdOK.Default := False;
      cmdSearch.Default := True;
      stsFound.SimpleText := ST_NONE_FOUND;

      //TDP - CQ#19731 Provide 508 hint for empty search results (tvAgent) when JAWS active.
      if ScreenReader then amgrMain.AccessText[tvAgent] := 'No Search Items to Display'
      //TDP - CQ#19731 Stop tab to empty search results (tvAgent) when JAWS not active.
      else tvAgent.TabStop := False;

      cmdOKClick(Self);
    end else
    begin
      //if tvAgent.Items <> nil then tvAgent.Items.Clear;
      AList.Insert(0, 'TOP^' + IntToStr(Alist.Count - uFileCount) + ' matches found.^^^0^+');
      AList.Add('FREETEXT^Add new free-text allergy^^^TOP^+');
      AList.Add('^' + UpperCase(txtSearch.Text) + '^^^FREETEXT^');
      BuildAgentTree(AList, '0', nil);
      tmpNode1 := TORTreeNode(tvAgent.Items.getFirstNode);
      tmpNode1.Expand(False);
      tmpNode1 := TORTreeNode(tmpNode1.GetFirstChild);
      if tmpNode1.HasChildren then
        begin
          tmpNode1.Text := tmpNode1.Text + '  (' + IntToStr(tmpNode1.Count) + ')';
          tmpNode1.Bold := True;
          tmpNode1.StateIndex := IMG_MATCHES_FOUND;
          tmpNode1.Expand(True);
          FExpanded := True;
        end
      else
        begin
          tmpNode1.Text := tmpNode1.Text + '  (no matches)';
          tmpNode1.StateIndex := IMG_NO_MATCHES;
        end;
      while tmpNode1 <> nil do
        begin
           tmpNode1 := TORTreeNode(tmpNode1.GetNextSibling);
           if tmpNode1 <> nil then
             if tmpNode1.HasChildren then
               begin
                 tmpNode1.Text := tmpNode1.Text + '  (' + IntToStr(tmpNode1.Count) + ')';
                 tmpNode1.StateIndex := IMG_MATCHES_FOUND;
                 if not FExpanded then
                   begin
                     tmpNode1.Bold := True;
                     tmpNode1.Expand(True);
                     FExpanded := True;
                   end;
               end
            else
              begin
                tmpNode1.StateIndex := IMG_NO_MATCHES;
                tmpNode1.Text := tmpNode1.Text + '  (no matches)';
              end;
        end;
      lblSelect.Visible := True;

      //TDP - CQ#19731 Clear 508 hint when JAWS active.
      if ScreenReader then amgrMain.AccessText[tvAgent] := ''
      //TDP - CQ#19731 Allow tab to search results (tvAgent) when JAWS not active.
      else tvAgent.TabStop := True;

      tvAgent.SetFocus;
      cmdSearch.Default := False;
      cmdOK.Enabled := True;
      stsFound.SimpleText := ST_FOUND;
    end;
  finally
    AList.Free;
    StatusText('');
    if stsFound.SimpleText = ''  then stsFound.TabStop := False
    else if ScreenReaderSystemActive then stsFound.TabStop := True;
  end;
end;

procedure TfrmAllgyFind.cmdOKClick(Sender: TObject);
var
  x, AGlobal: string;
  tmpList: TStringList;
  OKtoContinue: boolean ;
begin
  inherited;
  if ckNoKnownAllergies.Checked then
    begin
      FAllergy := '-1^No Known Allergy^';
      Close;
    end
  else if (txtSearch.Text = '') and ((tvAgent.Selected = nil) or (tvAgent.Items.Count = uFileCount)) then
    {bail out - no search term present, and (no items currently in tree or none selected)}
    begin
      FAllergy := '';
      Exit ;
    end
  else if ((tvAgent.Selected = nil) or
           (tvAgent.Items.Count = uFileCount) or
           (Piece(TORTreeNode(tvAgent.Selected).StringData, U, 5) = 'FREETEXT')) then
    {entry of free text agent - retry, send bulletin, or abort entry}
    begin
      FAllergy := '';
      case InfoBox(TX_FREE_TEXT, TC_FREE_TEXT + UpperCase(txtSearch.Text), MB_YESNOCANCEL or MB_DEFBUTTON2 or MB_ICONQUESTION)of
        ID_YES   :  // send bulletin and abort free-text entry
                    begin
                      tmpList := TStringList.Create;
                      try
                        OKtoContinue := False;
                        GetFreeTextARTComment(tmpList, OKtoContinue);
                        if not OKtoContinue then
                        begin
                          stsFound.SimpleText := '';
                          txtSearch.SetFocus;
                          Exit;
                        end;
                        x := SendARTBulletin(UpperCase(txtSearch.Text), tmpList);
                        if Piece(x, U, 1) = '-1' then
                          InfoBox(TX_BULLETIN_ERROR, TC_BULLETIN_ERROR, MB_OK or MB_ICONWARNING)
                        else if Piece(x, U, 1) = '1' then
                          InfoBox(TX_BULLETIN, 'Information', MB_OK or MB_ICONINFORMATION)
                        else
                          InfoBox(Piece(x, U, 2), TC_BULLETIN_ERROR, MB_OK or MB_ICONWARNING);
                      finally
                        tmpList.Free;
                      end;
                      Close;
                    end;
        ID_NO    :  // clear status message, and allow repeat search
                    begin
                      stsFound.SimpleText := '';
                      txtSearch.SetFocus;
                      Exit;
                    end;
        ID_CANCEL:  // abort entry and return to order menu or whatever
                    Close;
      end;
    end
  else if Piece(TORTreeNode(tvAgent.Selected).StringData, U, 6) = '+' then
    {bail out - tree grouper selected}
    begin
      FAllergy := '';
      Exit;
    end
  else
    {matching item selected}
    begin
      FAllergy := TORTreeNode(tvAgent.Selected).StringData;
      x := Piece(FAllergy, U, 2);
      AGlobal := Piece(FAllergy, U, 3);
      if ((Pos('GMRD', AGlobal) > 0) or (Pos('PSDRUG', AGlobal) > 0)) and (Pos('<', x) > 0) then
        //x := Trim(Piece(x, '<', 1));
        x := Copy(x, 1, Length(Piece(x, '<', 1)) - 1);
      SetPiece(FAllergy, U, 2, x);
      Close;
    end;
end;

procedure TfrmAllgyFind.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FAllergy := '';
  Close;
end;

procedure TfrmAllgyFind.ckNoKnownAllergiesClick(Sender: TObject);
begin
  inherited;
  with ckNoKnownAllergies do
    begin
      txtSearch.Enabled := not Checked;
      cmdSearch.Enabled := not Checked;
      lblSearch.Enabled := not Checked;
      lblSelect.Enabled := not Checked;
      tvAgent.Enabled   := not Checked;

      // CQ #15770 - Allow OK button again if unchecked and items exist - JCS
      //cmdOK.Enabled := Checked;
      if Checked then
        cmdOK.Enabled := True
      else
        cmdOK.Enabled := (tvAgent.Items.Count > 0);
    end;
end;

procedure TfrmAllgyFind.BuildAgentTree(AgentList: TStrings; const Parent: string; Node: TORTreeNode);
var
  MyID, MyParent, Name: string;
  i: Integer;
  ChildNode, tmpNode: TORTreeNode;
  HasChildren, Found: Boolean;
begin
  tvAgent.Items.BeginUpdate;
  with AgentList do for i := 0 to Count - 1 do
    begin
      Found := False;
      MyParent := Piece(Strings[i], U, 5);
      if (MyParent = Parent) then
        begin
          MyID := Piece(Strings[i], U, 1);
          Name := Piece(Strings[i], U, 2);
          HasChildren := Piece(Strings[i], U, 6) = '+';
          if Node <> nil then
            begin
              if Node.HasChildren then
                begin
                  tmpNode := TORTreeNode(Node.GetFirstChild);
                  while tmpNode <> nil do
                    begin
                      if tmpNode.Text = Piece(Strings[i], U, 2) then Found := True;
                      tmpNode := TORTreeNode(Node.GetNextChild(tmpNode));
                    end;
                end
              else
                Node.StateIndex := 0;
            end;
          if Found then
            Continue
          else
            begin
              ChildNode := TORTreeNode(tvAgent.Items.AddChild(Node, Name));
              ChildNode.StringData := AgentList[i];
              if HasChildren then BuildAgentTree(AgentList, MyID, ChildNode);
            end;
        end;
    end;
  tvAgent.Items.EndUpdate;
end;
 
procedure TfrmAllgyFind.tvAgentDblClick(Sender: TObject);
begin
  inherited;
  cmdOKClick(Self);
end;

end.
