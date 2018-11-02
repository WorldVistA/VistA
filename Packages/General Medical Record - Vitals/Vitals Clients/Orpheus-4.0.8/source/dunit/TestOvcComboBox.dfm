object TfrmTestOvcComboBox: TTfrmTestOvcComboBox
  Left = 0
  Top = 0
  Caption = 'TfrmTestOvcComboBox'
  ClientHeight = 123
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object OvcComboBox1: TOvcComboBox
    Left = 20
    Top = 20
    Width = 145
    Height = 22
    ItemHeight = 16
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9')
    TabOrder = 0
    Text = 'OvcComboBox1'
  end
  object OvcDirectoryComboBox1: TOvcDirectoryComboBox
    Left = 20
    Top = 56
    Width = 145
    Height = 22
    Directory = 'C:\Windows\system32'
    Mask = '*.*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 1
    Text = 'C:\Windows\system32'
  end
end
