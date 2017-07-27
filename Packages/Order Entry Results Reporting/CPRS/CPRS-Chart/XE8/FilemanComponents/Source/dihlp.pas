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
unit dihlp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmDisplayHelp = class(TForm)
    Panel1: TPanel;
    memHelp: TMemo;
    bbtnClose: TBitBtn;
    bbtnPrint: TBitBtn;
  end;

var
  FrmDisplayHelp: TFrmDisplayHelp;

implementation

{$R *.DFM}

end.
