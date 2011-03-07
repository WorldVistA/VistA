unit fProbLex;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ORFn, uProbs, StdCtrls, Buttons, ExtCtrls, ORctrls, uConst,
  fAutoSz, uInit, fBase508Form, VA508AccessibilityManager;

type
  TfrmPLLex = class(TfrmBase508Form)
    Label1: TLabel;
    bbCan: TBitBtn;
    bbOK: TBitBtn;
    pnlStatus: TPanel;
    Bevel1: TBevel;
    lblstatus: TVA508StaticText;
    ebLex: TCaptionEdit;
    lbLex: TORListBox;
    bbSearch: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbOKClick(Sender: TObject);
    procedure bbCanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ebLexKeyPress(Sender: TObject; var Key: Char);
    procedure bbSearchClick(Sender: TObject);
    procedure lbLexClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
 fprobs, rProbs, fProbEdt;

{$R *.DFM}

var
 ProblemList:TstringList;

const
  TX_CONTINUE_799 = 'A suitable term was not found based on user input and current defaults.'#13#10 + 
                    'If you proceed with this nonspecific term, an ICD code of "799.9 - OTHER'#13#10 +
                    'UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR MORTALITY" will be filed.'#13#10#13#10 +
                    'Use ';

procedure TfrmPLLex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ProblemList.free;
 {frmProblems.lblProbList.Caption := frmProblems.pnlRight.Caption ;}
 Release;
end;

procedure TfrmPLLex.bbOKClick(Sender: TObject);
const
  TX799 = '799.9';
var
  x, y: string;
  i: integer;
begin
  if (ebLex.Text = '') and ((lbLex.itemindex < 0) or (lbLex.Items.Count = 0)) then
    exit {bail out - nothing selected}
  else if ((lbLex.itemindex < 0) or (lbLex.Items.Count = 0)) then
    begin
      if InfoBox(TX_CONTINUE_799 + UpperCase(ebLex.Text) + '?', 'Unresolved Entry',
        MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES then Exit;
      PLProblem:=u + ebLex.Text + u + TX799 + u;
    end
  else if (Piece(ProblemList[lbLex.ItemIndex], U, 3) = '') then
    begin
      if InfoBox(TX_CONTINUE_799 + UpperCase(lbLex.DisplayText[lbLex.ItemIndex]) + '?', 'Unresolved Entry',
        MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES then Exit;
      PLProblem:=u + lbLex.DisplayText[lbLex.ItemIndex] + u + TX799 + u;
    end
  else
    begin
       x := ProblemList[lbLex.ItemIndex];
       y := Piece(x, U, 2);
       i := Pos(' *', y);
       if i > 0 then y := Copy(y, 1, i - 1);
       SetPiece(x, U, 2, y);
       PLProblem := x;
    end;
  if (not Application.Terminated) and (not uInit.TimedOut) then   {prevents GPF if system close box is clicked
                                                                   while frmDlgProbs is visible}
     if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0)  ;
 Close;
end;

procedure TfrmPLLex.bbCanClick(Sender: TObject);
begin
 PLProblem:='';
 close;
end;

procedure TfrmPLLex.FormCreate(Sender: TObject);
begin
  PLProblem := '';
  ProblemList:=TStringList.create;
  ResizeAnchoredFormToFont(self);
  //Resize bevel to center horizontally
  Bevel1.Width := pnlStatus.ClientWidth - Bevel1.Left- Bevel1.Left;
end;

procedure TfrmPLLex.ebLexKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  begin
   bbSearchClick(Sender);
   Key:=#0;
  end
 else
  begin
   lblStatus.caption:='';
   lbLex.Items.clear;
  end;
 end;

procedure TfrmPLLex.bbSearchClick(Sender: TObject);
VAR
 ALIST:Tstringlist;
 v,Max, Found:string;
 onlist: integer;
procedure SetLexList(v:string);
var   {too bad ORCombo only allows 1 piece to be shown}
 i, j: integer;
 txt, term, code, sys, lin, x: String;
begin
 lbLex.Clear;
 onlist:=-1;
 for i:=0 to pred(ProblemList.count) do
  begin
   txt:=ProblemList[i];
   Term:=Piece(txt,u,2);
   code:=Piece(txt,u,3);
   sys:=Piece(txt,u,5);
   lin:=Piece(txt,u,1) + u + term + '   ' + sys ;
   if code<>'' then lin:=lin + ':(' + code + ')';  
   //lin:=Piece(txt,u,1) + u + term {+ '   ' + sys} ;
   //{if code<>'' then lin:=lin + ':(' + code + ')';  }
   j := Pos(' *', Term);
   if j > 0 then
     x := UpperCase(Copy(Term, 1, j-1))
   else
     x := UpperCase(Term);
   if (x=V) or (code=V) then onlist:=i;
   lbLex.Items.add(lin);
  end;
 if onlist < 0 then
   begin  {Search term not in return list, so add it}
    lbLex.Items.insert(0,(u + V) );
    ProblemList.insert(0,(u + V + u + u));
    lbLex.itemIndex:=0;
   end
 else
   begin  {search term is on return list, so highlight it}
     lbLex.itemIndex:=onlist;
     ActiveControl := bbOK;
   end;
 lbLex.SetFocus;
end;

begin  {body}
if ebLex.text='' then
 begin
   InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
   exit; {don't bother to drop if no text entered}
 end ;
Alist:=TStringList.create;
try
 if lblStatus.caption = '' then
  begin
   lblStatus.caption := 'Searching Lexicon...';
   lblStatus.refresh;
  end;
 v:=uppercase(ebLex.text);
 if (v<>'') and (lbLex.itemindex<1) then
  begin
   ProblemList.clear;
   {FastAssign(ProblemLexiconSearch(v), Alist) ;}
   FastAssign(OldProblemLexiconSearch(v, 100), Alist) ;
  end;
 if Alist.count > 0 then
    begin
     FastAssign(Alist, lbLex.Items);
     FastAssign(Alist, ProblemList);
     Max:=ProblemList[pred(ProblemList.count)]; {get max number found}
     ProblemList.delete(pred(ProblemList.count)); {shed max# found}
     SetLexList(V);
     if onlist < 0 then
       Found := inttostr(ProblemList.Count -1)
     else
       Found := inttostr(ProblemList.Count);
     lblStatus.caption:='Search returned ' + Found + ' items.' +
                        ' out of a possible ' + Max;
     lbLex.Itemindex := 0 ;
    end
 else
    begin
     lblStatus.caption:='No Entries Found for "' + ebLex.text + '"';
    end ;
 finally
  Alist.free;
 end;
end;

procedure TfrmPLLex.lbLexClick(Sender: TObject);
begin
 bbOKClick(sender);
end;

procedure TfrmPLLex.FormShow(Sender: TObject);
begin
 ebLex.setfocus;
end;

end.
