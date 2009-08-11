inherited frmNotePrint: TfrmNotePrint
  Left = 516
  Top = 189
  Caption = 'frmNotePrint'
  ClientHeight = 306
  Position = poScreenCenter
  ExplicitHeight = 340
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrintTo: TLabel [0]
    Left = 8
    Top = 269
    Width = 3
    Height = 13
  end
  object lblNoteTitle: TMemo [1]
    Left = 8
    Top = 8
    Width = 301
    Height = 53
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Note Title, Date/Time of Note, Location')
    ReadOnly = True
    TabOrder = 4
  end
  object grpChooseCopy: TGroupBox [2]
    Left = 321
    Top = 4
    Width = 98
    Height = 61
    Caption = 'Print'
    TabOrder = 5
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
      TabStop = True
      OnClick = radWorkCopyClick
    end
  end
  object grpDevice: TGroupBox [3]
    Left = 8
    Top = 69
    Width = 411
    Height = 192
    Caption = 'Device'
    TabOrder = 0
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
      ListItemsOnly = False
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
    Left = 266
    Top = 276
    Width = 72
    Height = 22
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [5]
    Left = 346
    Top = 276
    Width = 72
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  object chkDefault: TCheckBox [6]
    Left = 8
    Top = 287
    Width = 130
    Height = 17
    Caption = 'Save as default printer'
    TabOrder = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblNoteTitle'
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
        'Component = frmNotePrint'
        'Status = stsDefault'))
  end
  object dlgWinPrinter: TPrintDialog
    Left = 287
    Top = 49
  end
end
