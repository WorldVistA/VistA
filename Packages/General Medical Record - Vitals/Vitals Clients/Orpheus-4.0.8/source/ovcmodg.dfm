object OvcfrmMemoDlg: TOvcfrmMemoDlg
  Left = 340
  Top = 206
  Width = 400
  Height = 250
  Caption = 'Memo Dialog'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object TPanel
    Left = 0
    Top = 185
    Width = 392
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnHelp: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 0
    end
    object TPanel
      Left = 227
      Top = 0
      Width = 165
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object lblReadOnly: TLabel
        Left = 21
        Top = 10
        Width = 48
        Height = 13
        Caption = 'Read only'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInactiveCaption
        Font.Height = -11
        Font.Name = 'Default'
        Font.Style = []
        ParentFont = False
      end
      object btnOK: TButton
        Left = 6
        Top = 4
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 88
        Top = 4
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 185
    Align = alClient
    TabOrder = 0
    object Memo: TMemo
      Left = 1
      Top = 1
      Width = 390
      Height = 183
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      WantTabs = True
    end
  end
end
