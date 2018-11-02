unit fGMV_RPCLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, fROR_PCall;

type
  TfrmGMV_RPCLog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    mm: TMemo;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    pnlTitle: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    lbRoutines: TListBox;
    Panel4: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    lbLog: TListBox;
    PageControl1: TPageControl;
    tsRPC: TTabSheet;
    tsEvents: TTabSheet;
    StatusBar1: TStatusBar;
    SymbolTbl: TTabSheet;
    SymbolTable: TListBox;
    procedure lbLogClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure lbRoutinesClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
      procedure ListSymbolTable(Dest: TStrings);
    procedure SymbolTableClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGMV_RPCLog: TfrmGMV_RPCLog;

procedure ShowRPCLog;

implementation

uses uGMV_Engine, uGMV_Log
  ;

{$R *.dfm}

procedure ShowRPCLog;
begin
  if not Assigned(frmGMV_RPCLog) then
      Application.CreateForm(TfrmGMV_RPCLog,frmGMV_RPCLog);
  frmGMV_RPCLog.lbLog.Items.Assign(RPCLog);
  frmGMV_RPCLog.ListSymbolTable(frmGMV_RPCLog.SymbolTable.Items);
  frmGMV_RPCLog.Show{Modal};
end;

procedure TfrmGMV_RPCLog.lbLogClick(Sender: TObject);
var
  anItem: TRPCEventItem;
begin
  if lbLog.ItemIndex >= 0 then
    begin
      anItem := TRPCEventItem(lbLog.Items.Objects[lbLog.ItemIndex]);
      if anItem <> nil then
        begin
          mm.Text :=
            Format('%-25.25s',[anItem.RPC]) +
              #13#10#13#10+
            FormatDateTime('hh:mm:ss.zzz',anItem.Start) + ' -- ' +
            FormatDateTime('hh:mm:ss.zzz',anItem.Stop) + '    ' +
            FormatDateTime('  (hh:mm:ss.zzz)',anItem.Stop-anItem.Start) + '    ' +
              #13#10#13#10+
            anItem.Params.Text + #13#10 +
            anItem.Results.Text;
          pnlTitle.Caption := anItem.RPC;
        end
      else
        begin
          mm.Text := '';
          pnlTitle.Caption := '';
        end;
    end
  else
        begin
          mm.Text := '';
          pnltitle.Caption := '';
        end;
end;

procedure TfrmGMV_RPCLog.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmGMV_RPCLog.FormCreate(Sender: TObject);
begin
  ComboBox1.ItemIndex := 0;
  ComboBox2.ItemIndex := 0;
end;

procedure TfrmGMV_RPCLog.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TfrmGMV_RPCLog.lbRoutinesClick(Sender: TObject);
var
  anItem: TActionEventItem;
begin
  if lbRoutines.ItemIndex >= 0 then
    begin
      anItem := TActionEventItem(lbRoutines.Items.Objects[lbRoutines.ItemIndex]);
      if anItem <> nil then
        begin
          mm.Text :=
            Format('%-35.35s %-35.35s',[anItem.Action, anItem.Actor]) +
              #13#10#13#10+
            FormatDateTime('hh:mm:ss.zzz',anItem.Start) + ' -- ' +
            FormatDateTime('hh:mm:ss.zzz',anItem.Stop) + '    ' +
            FormatDateTime('  (hh:mm:ss.zzz)',anItem.Stop-anItem.Start) + '    ' +
              #13#10#13#10+
            anItem.Comments.Text;
          pnlTitle.Caption := anItem.Action;
        end
      else
        begin
          mm.Text := '';
          pnltitle.Caption := '';
        end;
    end
  else
        begin
          mm.Text := '';
          pnltitle.Caption := '';
        end;
end;

procedure TfrmGMV_RPCLog.TrackBar1Change(Sender: TObject);
begin
//  frmGMV_UserMain.AlphaBlendValue := 255 - TrackBar1.Position;
end;

procedure TfrmGMV_RPCLog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then Close;
end;

procedure TfrmGMV_RPCLog.ListSymbolTable(Dest: TStrings);
var
  i: Integer;
  x: string;
begin
  Dest.Clear;
  CallRemoteProc(RPCBroker,'ORWUX SYMTAB', [], nil, [], RPCBroker.Results);
  //CallV('ORWUX SYMTAB', [nil]);
  i := 0;
  with RPCBroker.Results do while i < Count do
  begin
    x := Strings[i] + '=';
    Inc(i);
    if i < Count then x := x + Strings[i];
    Dest.Add(x);
    Inc(i);
  end;
end;

procedure TfrmGMV_RPCLog.SymbolTableClick(Sender: TObject);
begin
 if SymbolTable.ItemIndex >= 0 then
    begin
     pnltitle.Caption := 'Symbols';
     mm.Text := SymbolTable.Items[SymbolTable.ItemIndex];
    end
  else
   begin
    mm.Text := '';
    pnltitle.Caption := '';
   end;
end;

end.
