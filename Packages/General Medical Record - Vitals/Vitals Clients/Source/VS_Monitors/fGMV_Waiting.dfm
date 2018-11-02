object frmWaiting: TfrmWaiting
  Left = 544
  Top = 270
  BorderStyle = bsNone
  Caption = 'frmWaiting'
  ClientHeight = 66
  ClientWidth = 303
  Color = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 303
    Height = 66
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 165
      Height = 13
      Caption = 'Lookin for CASMED on port: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPort: TLabel
      Left = 224
      Top = 24
      Width = 35
      Height = 13
      Caption = 'COM1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
