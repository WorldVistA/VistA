object fPlinkPassword: TfPlinkPassword
  Left = 234
  Top = 119
  Width = 300
  Height = 151
  Caption = 'Enter Plink Password'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 8
    Width = 212
    Height = 13
    Caption = 'Enter your Plink Password - or enter it on the '
  end
  object Label2: TLabel
    Left = 57
    Top = 24
    Width = 177
    Height = 13
    Caption = 'Command Line as  SSHpw=password'
  end
  object Edit1: TEdit
    Left = 49
    Top = 48
    Width = 193
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 108
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
end
