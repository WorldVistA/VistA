unit fFindingTemplates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DateUtils, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmFindingTemplates = class(TfrmBase508Form)
    animSearch: TAnimate;
    lblFind: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FCanceled: boolean;
    FSearchString: string;
    FStarted: boolean;
    FTree: TTreeView;
    FStartNode: TTreeNode;
    FCurrentNode :TTreeNode;
    FIgnoreCase: boolean;
    FWholeWords: boolean;
    FFoundNode: TTreeNode;
    FIsNext: boolean;
    procedure Find;
  end;

function FindTemplate(SearchString: string; Tree: TTreeView; OwningForm: TForm;
                      StartNode: TTreeNode; IsNext, IgnoreCase, WholeWords: boolean): TTreeNode;

implementation

uses
  uTemplates,
  VAUtils,
  ORNet,
  UResponsiveGUI;

{$R *.dfm}

const
 // search for 1 second before showing dialog - note some loading may have already
 // taken place before this call.
  DELAY_TIME = 1000;
  MESSAGE_TIME = 0;

function FindTemplate(SearchString: string; Tree: TTreeView; OwningForm: TForm;
                      StartNode: TTreeNode; IsNext, IgnoreCase, WholeWords: boolean): TTreeNode;
var
  frmFindingTemplates: TfrmFindingTemplates;
  msg: string;
begin
  Result := nil;
  if (SearchString = '') or (not assigned(Tree)) then exit;
  frmFindingTemplates := TfrmFindingTemplates.Create(OwningForm);
  try
    with frmFindingTemplates do
    begin
      FSearchString := SearchString;
      FTree := Tree;
      FStartNode := StartNode;
      FIgnoreCase := IgnoreCase;
      FWholeWords := WholeWords;
      FIsNext := IsNext;
      if IsNext then
        lblFind.Caption := 'Finding Next Template';
      Find;
      if assigned(FFoundNode) then
      begin
        Result := FFoundNode;
      end
      else
      begin
        if FCanceled then
          msg := 'Find Canceled.'
        else
          msg := 'Text not Found.';
        ShowMsg('Search Completed.  ' + msg,'Find Template Failed', smiError);
      end;
    end;
  finally
    frmFindingTemplates.Free;
  end;
end;

procedure TfrmFindingTemplates.btnCancelClick(Sender: TObject);
begin
  FCanceled := True;
  btnCancel.Enabled := False;
end;

procedure TfrmFindingTemplates.Find;
var
  Found : boolean;
  Text: String;
  WindowList: Pointer;
  NeedToShow: boolean;
  StartTime: TDateTime;
begin
  WindowList := nil;
  NeedToShow := True;
  StartTime := Now;
  try
    if(FIgnoreCase) then
      FSearchString := UpperCase(FSearchString);
    FCurrentNode := FStartNode;
    Found := False;
    if FIsNext and assigned(FCurrentNode) then
    begin
      FCurrentNode.Expand(False);
      FCurrentNode := FCurrentNode.GetNext;
    end;
    while (not FCanceled) and (assigned(FCurrentNode) and (not Found)) do
    begin
      TResponsiveGUI.ProcessMessages(True);
      if not FCanceled then
      begin
        Text := FCurrentNode.Text;
        if(FIgnoreCase) then
          Text := UpperCase(Text);
        Found := SearchMatch(FSearchString, Text, FWholeWords);
        if(not Found) then
        begin
          FCurrentNode.Expand(False);
          FCurrentNode := FCurrentNode.GetNext;
        end;
        if (not Found) and assigned(FCurrentNode) and NeedToShow then
        begin
          if MilliSecondsBetween(Now, StartTime) > DELAY_TIME then
          begin
            WindowList := DisableTaskWindows(0);
            AppStartedCursorForm := Self;
            Show;
            NeedToShow := False;
          end;
        end;
      end;
    end;
    if Found then
      FFoundNode := FCurrentNode;
  finally
    if not NeedToShow then
    begin
      AppStartedCursorForm := nil;
      EnableTaskWindows(WindowList);
      Hide;
    end;
  end;
end;

procedure TfrmFindingTemplates.FormShow(Sender: TObject);
begin
  if not FStarted then
  begin
    FStarted := True;
    animSearch.Active := True;
  end;
end;

end.
