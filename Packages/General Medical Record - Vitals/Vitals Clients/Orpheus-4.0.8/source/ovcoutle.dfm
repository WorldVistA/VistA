object OvcfrmOLItemsEditor: TOvcfrmOLItemsEditor
  Left = 314
  Top = 213
  BorderStyle = bsDialog
  ClientHeight = 232
  ClientWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 177
    Caption = ' Items '
    TabOrder = 0
    object OvcOutline1: TOvcOutline
      Left = 8
      Top = 16
      Width = 129
      Height = 148
      Controller = OvcController1
      HideSelection = False
      ParentColor = False
      ParentShowHint = False
      SelectColor.BackColor = clHighlight
      SelectColor.TextColor = clHighlightText
      TabOrder = 0
      TabStop = True
      OnActiveChange = OvcOutline1ActiveChange
    end
    object btnNewItem: TButton
      Left = 144
      Top = 16
      Width = 80
      Height = 25
      Caption = 'New Node'
      Default = True
      TabOrder = 1
      OnClick = btnNewItemClick
    end
    object btnNewSubItem: TButton
      Left = 144
      Top = 48
      Width = 80
      Height = 25
      Caption = 'New SubNode'
      Enabled = False
      TabOrder = 2
      OnClick = btnNewSubItemClick
    end
    object btnDelete: TButton
      Left = 144
      Top = 80
      Width = 80
      Height = 25
      Caption = 'Delete'
      Enabled = False
      TabOrder = 3
      OnClick = btnDeleteClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 248
    Top = 8
    Width = 249
    Height = 177
    Caption = ' Node Properties '
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 21
      Width = 24
      Height = 13
      Caption = 'Text:'
    end
    object Label2: TLabel
      Left = 13
      Top = 45
      Width = 61
      Height = 13
      Caption = 'Image Index:'
    end
    object edtText: TEdit
      Left = 112
      Top = 18
      Width = 85
      Height = 21
      Enabled = False
      TabOrder = 0
      OnExit = edtTextExit
    end
    object rgStyle: TRadioGroup
      Left = 16
      Top = 72
      Width = 105
      Height = 73
      Caption = ' Style '
      Enabled = False
      Items.Strings = (
        'Plain'
        'Radio Box'
        'Check Box')
      TabOrder = 2
      OnClick = rgStyleClick
    end
    object OvcSliderEdit1: TOvcSliderEdit
      Left = 112
      Top = 40
      Width = 85
      Height = 21
      AllowIncDec = False
      ButtonGlyph.Data = {
        C2010000424DC20100000000000036000000280000000B0000000B0000000100
        1800000000008C01000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800080800080800000000080
        8000808000808000808000808000808000808000808000808000808000808000
        0000008080008080008080000000000000008080008080008080008080008080
        0080800000000080800080800080800000000000000000000080800080800080
        8000808000808000000000808000808000808000000000000000000000000000
        8080008080008080008080000000008080008080008080000000000000000000
        0000000000000080800080800080800000000080800080800080800000000000
        0000000000000000808000808000808000808000000000808000808000808000
        0000000000000000008080008080008080008080008080000000008080008080
        0080800000000000000080800080800080800080800080800080800000000080
        8000808000808000808000808000808000808000808000808000808000808000
        0000008080008080008080008080008080008080008080008080008080008080
        008080000000}
      Enabled = False
      PopupAnchor = paLeft
      PopupDrawMarks = True
      PopupHeight = 20
      PopupMax = 10.000000000000000000
      PopupStep = 1.000000000000000000
      PopupWidth = 121
      ReadOnly = False
      ShowButton = True
      TabOrder = 1
      Validate = False
      OnChange = OvcSliderEdit1Change
    end
    object chkChecked: TCheckBox
      Left = 25
      Top = 152
      Width = 97
      Height = 17
      Caption = 'Checked'
      Enabled = False
      TabOrder = 4
      OnClick = chkCheckedClick
    end
    object rgMode: TRadioGroup
      Left = 128
      Top = 72
      Width = 105
      Height = 73
      Caption = ' Mode '
      Enabled = False
      Items.Strings = (
        'Preload'
        'Dynamic Load'
        'Dynamic')
      TabOrder = 3
      OnClick = rgStyleClick
    end
  end
  object btnOk: TButton
    Left = 344
    Top = 200
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 424
    Top = 200
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnApply: TButton
    Left = 248
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 2
    OnClick = btnApplyClick
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
