unit fODSaveQuick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, Buttons, ExtCtrls, StdCtrls, ORCtrls, VA508AccessibilityManager;

type
  TfrmODQuick = class(TfrmAutoSz)
    Label1: TLabel;
    Edit1: TCaptionEdit;
    ORListBox1: TORListBox;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmODQuick: TfrmODQuick;

implementation

{$R *.DFM}

end.
