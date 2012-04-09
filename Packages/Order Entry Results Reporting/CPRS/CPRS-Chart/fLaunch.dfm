object frmLaunch: TfrmLaunch
  Left = 557
  Top = 271
  Width = 231
  Height = 189
  Caption = 'Lauch Stuff'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 120
    Width = 33
    Height = 13
    Caption = 'Patient'
  end
  object grpFontSize: TRadioGroup
    Left = 8
    Top = 8
    Width = 65
    Height = 105
    Caption = 'Font Size'
    ItemIndex = 0
    Items.Strings = (
      '8 pt'
      '10 pt'
      '12 pt'
      '14 pt'
      '18 pt')
    TabOrder = 0
  end
  object cmdShow: TButton
    Left = 88
    Top = 12
    Width = 129
    Height = 25
    Caption = 'Show w/o Notifications'
    Default = True
    TabOrder = 1
    OnClick = cmdShowClick
  end
  object Edit1: TEdit
    Left = 8
    Top = 136
    Width = 209
    Height = 21
    TabOrder = 2
  end
  object cmdClose: TButton
    Left = 88
    Top = 88
    Width = 129
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 3
    OnClick = cmdCloseClick
  end
  object cmdNotif: TButton
    Tag = 1
    Left = 88
    Top = 44
    Width = 129
    Height = 25
    Cancel = True
    Caption = 'Show with Notifications'
    TabOrder = 4
    OnClick = cmdShowClick
  end
end
