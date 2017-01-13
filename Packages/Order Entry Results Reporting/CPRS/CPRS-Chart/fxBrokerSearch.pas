unit fxBrokerSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ORNet, Winapi.RichEdit, fBase508Form, orfn;

type

  TRpcRecord = record
    RpcName: String;
    UCallListIndex: Integer;
    ResultListIndex: Integer;
    RPCText: TStringList;
  end;

  TfrmBokerSearch = class(TfrmBase508Form)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Label2: TLabel;
    Panel4: TPanel;
    SearchTerm: TEdit;
    btnSearch: TButton;
    ResultList: TListView;
    procedure ResultListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SearchTermChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    RPCArray: Array of TRpcRecord;
    RPCSrchSelIndex: Integer;
    FOriginal: Integer;
    fReturnRichEdit: TRichedit;
    fReturnLabel: TStaticText;
    procedure CloneRPCList();
  public
    { Public declarations }
  end;

Procedure ShowBrokerSearch(ReturnIndex: Integer; ReturnRichEdit: TRichedit;
  ReturnLabel: TStaticText);

var
  frmBokerSearch: TfrmBokerSearch;

implementation

{$R *.dfm}


{-------------------------------------------------------------------------------
  Procedure:   ShowBrokerSearch
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   ReturnIndex: Integer; ReturnRichEdit: TRichedit;
               ReturnLabel: TStaticText
  Result:      None
  Description: Show search with interaction
-------------------------------------------------------------------------------}
Procedure ShowBrokerSearch(ReturnIndex: Integer; ReturnRichEdit: TRichedit;
  ReturnLabel: TStaticText);
begin
  if not Assigned(frmBokerSearch) then
    frmBokerSearch := TfrmBokerSearch.Create(Application);
  try
    ResizeAnchoredFormToFont(frmBokerSearch);
    frmBokerSearch.Show;
    frmBokerSearch.FOriginal := ReturnIndex;
    frmBokerSearch.fReturnRichEdit := ReturnRichEdit;
    frmBokerSearch.fReturnLabel := ReturnLabel;
  except
    frmBokerSearch.Free;
  end;
end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.btnOkClick
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject
  Result:      None
  Description: Close the dialog and save the index
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.btnOkClick(Sender: TObject);
Var
  I: Integer;
begin
  for I := Low(RPCArray) to High(RPCArray) do
    if ResultList.Selected.Index = RPCArray[I].ResultListIndex then
      RPCSrchSelIndex := RPCArray[I].UCallListIndex;
end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.btnSearchClick
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject
  Result:      None
  Description: Perform the search
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.btnSearchClick(Sender: TObject);
var
  I, ReturnCursor: Integer;
  Found: Boolean;
  ListItem: TListItem;

begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    // Clear all
    ResultList.Clear;
    Found := false;
    for I := Low(RPCArray) to High(RPCArray) do
    begin
      RPCArray[I].ResultListIndex := -1;
      if Pos(UpperCase(SearchTerm.Text), UpperCase(RPCArray[I].RPCText.Text)) > 0
      then
      begin
        ListItem := ResultList.Items.Add;
        ListItem.Caption :=
          IntToStr((RPCArray[I].UCallListIndex - RetainedRPCCount) + 1);

        ListItem.SubItems.Add(RPCArray[I].RpcName);
        RPCArray[I].ResultListIndex := ListItem.Index;
        if not Found then
        begin
          ResultList.Column[1].Width := -1;
          Found := True;
        end;
      end;
    end;
    if not Found then
      ShowMessage('no matches found');

  finally
    Screen.Cursor := ReturnCursor;
  end;
end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.CloneRPCList
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:
  Result:      None
  Description: Clone the RPC list
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.CloneRPCList();
Var
  I: Integer;
begin
  for I := 0 to RetainedRPCCount - 1 do
  begin
    SetLength(RPCArray, Length(RPCArray) + 1);
    RPCArray[High(RPCArray)].RPCText := TStringList.Create;
    try
      LoadRPCData(RPCArray[High(RPCArray)].RPCText, I);
      RPCArray[High(RPCArray)].RpcName := RPCArray[High(RPCArray)].RPCText[0];
      RPCArray[High(RPCArray)].UCallListIndex := I;
    except
      RPCArray[High(RPCArray)].RPCText.Free;
    end;
  end;

end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.FormCreate
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject
  Result:      None
  Description: Initalize
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.FormCreate(Sender: TObject);
begin
  SetLength(RPCArray, 0);
  CloneRPCList;
  ResultList.Column[0].Width := -2;
  ResultList.Column[1].Width := -2;
end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.FormDestroy
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject
  Result:      None
  Description: Clean up
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.FormDestroy(Sender: TObject);
Var
  I: Integer;
begin
  for I := Low(RPCArray) to High(RPCArray) do
    RPCArray[I].RPCText.Free;
  SetLength(RPCArray, 0);
end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.FormResize
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject
  Result:      None
  Description: Refresh the screen
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.FormResize(Sender: TObject);
begin
  Refresh;
end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.ResultListSelectItem
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject; Item: TListItem; Selected: Boolean
  Result:      None
  Description: Select RPC and load it up in the list
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.ResultListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
Var
  I: Integer;
  SearchString: string;
  CharPos, CharPos2: Integer;
  Format: CHARFORMAT2;
begin
  btnOk.Enabled := Selected; // original code

  if Selected then
  begin
    for I := Low(RPCArray) to High(RPCArray) do
      if ResultList.Selected.Index = RPCArray[I].ResultListIndex then
      begin
        LoadRPCData(fReturnRichEdit.Lines, RPCArray[I].UCallListIndex);
        fReturnRichEdit.SelStart := 0;
        fReturnLabel.Caption := 'Last Call Minus: ' +
          IntToStr((RetainedRPCCount - RPCArray[I].UCallListIndex) - 1);
        FOriginal := RPCArray[I].UCallListIndex;
        break;
      end;

    SearchString := StringReplace(Trim(frmBokerSearch.SearchTerm.Text), #10, '',
      [rfReplaceAll]);

    CharPos := 0;
    repeat
      // find the text and save the position
      CharPos2 := fReturnRichEdit.FindText(SearchString, CharPos,
        Length(fReturnRichEdit.Text), []);
      CharPos := CharPos2 + 1;
      if CharPos = 0 then
        break;

      // Select the word
      fReturnRichEdit.SelStart := CharPos2;
      fReturnRichEdit.SelLength := Length(SearchString);

      // Set the background color
      Format.cbSize := SizeOf(Format);
      Format.dwMask := CFM_BACKCOLOR;
      Format.crBackColor := clYellow;
      fReturnRichEdit.Perform(EM_SETCHARFORMAT, SCF_SELECTION,
        Longint(@Format));
      Application.ProcessMessages;
    until CharPos = 0;

  end;

end;

{-------------------------------------------------------------------------------
  Procedure:   TfrmBokerSearch.SearchTermChange
  Author:      ZZZZZZBELLC
  DateTime:    2013.08.12
  Arguments:   Sender: TObject
  Result:      None
  Description: Toggle the search button
-------------------------------------------------------------------------------}
procedure TfrmBokerSearch.SearchTermChange(Sender: TObject);
begin
  btnSearch.Enabled := (Trim(SearchTerm.Text) > '');

end;

end.
