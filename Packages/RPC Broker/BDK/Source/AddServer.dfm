object frmAddServer: TfrmAddServer
  Left = 287
  Top = 259
  Caption = 'Add Server'
  ClientHeight = 109
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblAddress: TLabel
    Left = 16
    Top = 16
    Width = 50
    Height = 13
    Caption = 'Address:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPortNumber: TLabel
    Left = 16
    Top = 48
    Width = 75
    Height = 13
    Caption = 'Port Number:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtAddress: TEdit
    Left = 104
    Top = 8
    Width = 177
    Height = 21
    Hint = 'Enter Server Address, either as Server Name or IP Address'
    TabOrder = 0
  end
  object edtPortNumber: TEdit
    Left = 104
    Top = 40
    Width = 113
    Height = 21
    Hint = 'Enter the Port Number to use for this server'
    TabOrder = 1
  end
  object bbtnOK: TBitBtn
    Left = 70
    Top = 80
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
  end
  object bbtnCancel: TBitBtn
    Left = 190
    Top = 80
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
end
