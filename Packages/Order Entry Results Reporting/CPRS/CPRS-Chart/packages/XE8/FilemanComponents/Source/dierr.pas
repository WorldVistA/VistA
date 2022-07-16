{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{                                                       }
{       Revision Date: 11/25/97                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}

unit Dierr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFrmDisplayError = class(TForm)
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnHelp: TBitBtn;
    memError: TMemo;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    lblFile: TLabel;
    lblField: TLabel;
    lblIENS: TLabel;
    procedure btnHelpClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
  protected
    FHlpList : TList;   // changed from private to protected
  public
    property HlpList: TList read FHlpList write FHlpList;

  end;

var
  FrmDisplayError: TFrmDisplayError;

implementation

{$R *.DFM}

uses Dityplib;

procedure TFrmDisplayError.btnHelpClick(Sender: TObject);
var
  i : integer;
  Hlp : TFMHelpObj;
begin
  for i := 0 to HlpList.Count -1 do
  begin           // begin - end wrapper added 05-25-99 jli
    Hlp := HlpList.Items[i];
    Hlp.DisplayHelp;
  end;
end;

procedure TFrmDisplayError.btnOKClick(Sender: TObject);
begin
  exit;
end;

end.
