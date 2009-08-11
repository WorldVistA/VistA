inherited frm513Print: Tfrm513Print
  Left = 116
  Top = 375
  Caption = 'Print SF 513'
  ClientHeight = 306
  Position = poScreenCenter
  ExplicitHeight = 340
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrintTo: TLabel [0]
    Left = 7
    Top = 265
    Width = 3
    Height = 13
  end
  object lblConsultTitle: TMemo [1]
    Left = 10
    Top = 8
    Width = 301
    Height = 53
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Consult Title, Date/Time of Consult, Location')
    ReadOnly = True
    TabOrder = 0
  end
  object grpChooseCopy: TGroupBox [2]
    Left = 321
    Top = 4
    Width = 98
    Height = 61
    Caption = 'Print'
    TabOrder = 1
    object radChartCopy: TRadioButton
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      Caption = '&Chart Copy'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = radChartCopyClick
    end
    object radWorkCopy: TRadioButton
      Left = 8
      Top = 36
      Width = 81
      Height = 17
      Caption = '&Work Copy'
      TabOrder = 1
      OnClick = radWorkCopyClick
    end
  end
  object grpDevice: TGroupBox [3]
    Left = 8
    Top = 69
    Width = 411
    Height = 192
    Caption = 'Device'
    TabOrder = 2
    object lblMargin: TLabel
      Left = 8
      Top = 166
      Width = 60
      Height = 13
      Caption = 'Right Margin'
    end
    object lblLength: TLabel
      Left = 120
      Top = 166
      Width = 61
      Height = 13
      Caption = 'Page Length'
    end
    object txtRightMargin: TMaskEdit
      Left = 72
      Top = 164
      Width = 34
      Height = 19
      AutoSize = False
      EditMask = '99999;0; '
      MaxLength = 5
      TabOrder = 1
    end
    object txtPageLength: TMaskEdit
      Left = 184
      Top = 164
      Width = 34
      Height = 19
      AutoSize = False
      EditMask = '99999;0; '
      MaxLength = 5
      TabOrder = 2
    end
    object cboDevice: TORComboBox
      Left = 8
      Top = 16
      Width = 395
      Height = 140
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Device'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,4'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '30'
      TabOrder = 0
      OnChange = cboDeviceChange
      OnNeedData = cboDeviceNeedData
      CharsNeedMatch = 1
    end
  end
  object cmdOK: TButton [4]
    Left = 267
    Top = 272
    Width = 72
    Height = 22
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [5]
    Left = 347
    Top = 272
    Width = 72
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = cmdCancelClick
  end
  object chkDefault: TCheckBox [6]
    Left = 7
    Top = 288
    Width = 166
    Height = 17
    Caption = 'Save as user'#39's default printer'
    TabOrder = 3
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblConsultTitle'
        'Status = stsDefault')
      (
        'Component = grpChooseCopy'
        'Status = stsDefault')
      (
        'Component = radChartCopy'
        'Status = stsDefault')
      (
        'Component = radWorkCopy'
        'Status = stsDefault')
      (
        'Component = grpDevice'
        'Status = stsDefault')
      (
        'Component = txtRightMargin'
        'Status = stsDefault')
      (
        'Component = txtPageLength'
        'Status = stsDefault')
      (
        'Component = cboDevice'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = chkDefault'
        'Status = stsDefault')
      (
        'Component = frm513Print'
        'Status = stsDefault'))
  end
  object dlgWinPrinter: TPrintDialog
    Left = 268
    Top = 26
  end
end
