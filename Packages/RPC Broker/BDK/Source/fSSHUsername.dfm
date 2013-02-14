object SSHUsername: TSSHUsername
  Left = 234
  Top = 119
  Width = 300
  Height = 151
  Caption = 'Enter SSH username'
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
    Left = 41
    Top = 8
    Width = 209
    Height = 13
    Caption = 'Enter the username for the SSH connection:'
  end
  object Label2: TLabel
    Left = 13
    Top = 24
    Width = 267
    Height = 13
    Caption = 'Or Enter it on the  command line as  SSHUser=username'
  end
  object Edit1: TEdit
    Left = 49
    Top = 48
    Width = 193
    Height = 21
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
