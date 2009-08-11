inherited frmTemplateAutoGen: TfrmTemplateAutoGen
  Left = 361
  Top = 230
  ActiveControl = rgSource
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Generate Template'
  ClientHeight = 213
  ClientWidth = 415
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblTop: TMemo [0]
    Left = 256
    Top = 8
    Width = 147
    Height = 65
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Template generation creates a '
      'new template, automatically '
      'copying the template'#39's '
      'boilerplate from an existing '
      'source.')
    TabOrder = 5
  end
  object lblSelect: TStaticText [1]
    Left = 0
    Top = 0
    Width = 241
    Height = 213
    Align = alLeft
    Alignment = taCenter
    AutoSize = False
    Caption = 'Select Source of Template Generation ...'
    TabOrder = 6
  end
  object rgSource: TKeyClickRadioGroup [2]
    Left = 256
    Top = 88
    Width = 153
    Height = 81
    Caption = ' Template Generate Source '
    Items.Strings = (
      '&Boilerplated Note Title'
      '&Patient Data (Object)')
    TabOrder = 2
    TabStop = True
    OnClick = rgSourceClick
  end
  object cbxObjects: TORComboBox [3]
    Left = 0
    Top = 0
    Width = 249
    Height = 213
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Patient Data'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '1'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    Visible = False
    OnDblClick = cbxObjectsDblClick
    CharsNeedMatch = 1
  end
  object btnOK: TButton [4]
    Left = 257
    Top = 190
    Width = 75
    Height = 21
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton [5]
    Left = 337
    Top = 190
    Width = 75
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object cbxTitles: TORComboBox [6]
    Left = 0
    Top = 0
    Width = 249
    Height = 213
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Choose Existing Template'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    Visible = False
    OnDblClick = cbxTitlesDblClick
    OnNeedData = cbxTitlesNeedData
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblTop'
        'Status = stsDefault')
      (
        'Component = lblSelect'
        'Status = stsDefault')
      (
        'Component = rgSource'
        'Status = stsDefault')
      (
        'Component = cbxObjects'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = cbxTitles'
        'Status = stsDefault')
      (
        'Component = frmTemplateAutoGen'
        'Status = stsDefault'))
  end
end
