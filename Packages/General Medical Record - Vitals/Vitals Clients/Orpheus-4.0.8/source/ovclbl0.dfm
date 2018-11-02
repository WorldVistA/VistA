object frmOvcLabel: TfrmOvcLabel
  Left = 328
  Top = 198
  BorderStyle = bsDialog
  Caption = 'Style Manager'
  ClientHeight = 456
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 577
    Height = 97
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object OvcLabel: TOvcLabel
      Left = 1
      Top = 1
      Width = 575
      Height = 95
      Align = alClient
      Alignment = taCenter
      Appearance = apCustom
      Caption = 'Orpheus Labels'
      ColorScheme = csCustom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = []
    end
  end
  object Button1: TButton
    Left = 418
    Top = 427
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Button2: TButton
    Left = 500
    Top = 427
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Panel2: TPanel
    Left = 0
    Top = 364
    Width = 393
    Height = 91
    TabOrder = 3
    object TLabel
      Left = 4
      Top = 4
      Width = 58
      Height = 13
      Caption = 'Style Name:'
    end
    object TLabel
      Left = 256
      Top = 5
      Width = 62
      Height = 13
      Caption = 'Appearance:'
    end
    object TLabel
      Left = 256
      Top = 48
      Width = 69
      Height = 13
      Caption = 'Color Scheme:'
    end
    object SchemeCb: TComboBox
      Left = 4
      Top = 20
      Width = 233
      Height = 21
      Style = csDropDownList
      MaxLength = 255
      Sorted = True
      TabOrder = 0
      OnChange = SchemeCbChange
      Items.Strings = (
        'one'
        'two')
    end
    object SaveAsBtn: TButton
      Left = 4
      Top = 55
      Width = 75
      Height = 25
      Caption = 'Save &As...'
      TabOrder = 1
      OnClick = SaveAsBtnClick
    end
    object DeleteBtn: TButton
      Left = 161
      Top = 55
      Width = 75
      Height = 25
      Caption = '&Delete'
      TabOrder = 2
      OnClick = DeleteBtnClick
    end
    object AppearanceCb: TComboBox
      Left = 256
      Top = 20
      Width = 126
      Height = 21
      TabOrder = 3
      OnChange = AppearanceCbChange
    end
    object ColorSchemeCb: TComboBox
      Left = 256
      Top = 62
      Width = 126
      Height = 21
      TabOrder = 4
      OnChange = ColorSchemeCbChange
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 97
    Width = 577
    Height = 189
    TabOrder = 1
    object TLabel
      Left = 152
      Top = 83
      Width = 73
      Height = 13
      Caption = 'Gradient Color:'
    end
    object TLabel
      Left = 294
      Top = 83
      Width = 73
      Height = 13
      Caption = 'Highlight Color:'
    end
    object TLabel
      Left = 437
      Top = 83
      Width = 70
      Height = 13
      Caption = 'Shadow Color:'
    end
    object HighlightDirectionLbl: TLabel
      Left = 304
      Top = 128
      Width = 50
      Height = 32
      AutoSize = False
      Caption = 'Highlight Direction:'
      WordWrap = True
    end
    object ShadowDirectionLbl: TLabel
      Left = 447
      Top = 128
      Width = 50
      Height = 32
      AutoSize = False
      Caption = 'Shadow Direction:'
      WordWrap = True
    end
    object TLabel
      Left = 8
      Top = 65
      Width = 54
      Height = 13
      Caption = 'Text Color/'
    end
    object TLabel
      Left = 8
      Top = 78
      Width = 88
      Height = 13
      Caption = 'Gradient To Color:'
    end
    object GraduateRg: TRadioGroup
      Left = 150
      Top = 3
      Width = 137
      Height = 73
      Caption = 'Text &Gradient Style'
      ItemIndex = 0
      Items.Strings = (
        'None'
        'Horizontal'
        'Vertical')
      TabOrder = 1
      OnClick = GraduateRgClick
    end
    object ShadowRg: TRadioGroup
      Left = 436
      Top = 3
      Width = 137
      Height = 73
      Caption = '&Shadow Style'
      ItemIndex = 0
      Items.Strings = (
        'Plain'
        'Extrude'
        'Graduate')
      TabOrder = 3
      OnClick = ShadowRgClick
    end
    object HighlightRg: TRadioGroup
      Left = 293
      Top = 3
      Width = 137
      Height = 73
      Caption = '&Highlight Style'
      ItemIndex = 0
      Items.Strings = (
        'Plain'
        'Extrude'
        'Graduate')
      TabOrder = 2
      OnClick = HighlightRgClick
    end
    object FromColorCcb: TOvcColorComboBox
      Left = 151
      Top = 99
      Width = 137
      Height = 18
      ItemHeight = 12
      TabOrder = 4
      Text = 'Black'
      OnChange = FromColorCcbChange
    end
    object HighlightColorCcb: TOvcColorComboBox
      Left = 293
      Top = 99
      Width = 137
      Height = 18
      ItemHeight = 12
      TabOrder = 5
      Text = 'Black'
      OnChange = HighlightColorCcbChange
    end
    object ShadowColorCcb: TOvcColorComboBox
      Left = 436
      Top = 99
      Width = 137
      Height = 18
      ItemHeight = 12
      TabOrder = 6
      Text = 'Black'
      OnChange = ShadowColorCcbChange
    end
    object FontColorCcb: TOvcColorComboBox
      Left = 7
      Top = 99
      Width = 137
      Height = 18
      ItemHeight = 12
      TabOrder = 0
      Text = 'Black'
      OnChange = FontColorCcbChange
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 286
    Width = 577
    Height = 78
    TabOrder = 2
    object TLabel
      Left = 20
      Top = 8
      Width = 105
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Font Size: '
    end
    object FontSizeLbl: TLabel
      Left = 500
      Top = 8
      Width = 6
      Height = 13
      Caption = '0'
    end
    object HighlightDepthLbl: TLabel
      Left = 500
      Top = 32
      Width = 6
      Height = 13
      Caption = '0'
    end
    object ShadowDepthLbl: TLabel
      Left = 500
      Top = 56
      Width = 6
      Height = 13
      Caption = '0'
    end
    object TLabel
      Left = 20
      Top = 32
      Width = 105
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Highlight Depth: '
    end
    object TLabel
      Left = 20
      Top = 56
      Width = 105
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Shadow Depth: '
    end
    object FontSizeSb: TScrollBar
      Left = 132
      Top = 8
      Width = 357
      Height = 14
      PageSize = 0
      TabOrder = 0
      OnChange = FontSizeSbChange
    end
    object ShadowDepthSb: TScrollBar
      Left = 132
      Top = 56
      Width = 357
      Height = 14
      Max = 50
      PageSize = 0
      TabOrder = 2
      OnChange = ShadowDepthSbChange
    end
    object HighlightDepthSb: TScrollBar
      Left = 132
      Top = 32
      Width = 357
      Height = 14
      Max = 50
      PageSize = 0
      TabOrder = 1
      OnChange = HighlightDepthSbChange
    end
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 1900
  end
end
