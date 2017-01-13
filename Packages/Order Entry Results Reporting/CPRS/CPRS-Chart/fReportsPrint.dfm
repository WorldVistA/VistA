inherited frmReportPrt: TfrmReportPrt
  Left = 507
  Top = 114
  Caption = 'Report Print Device Selection'
  ClientHeight = 314
  ClientWidth = 424
  Position = poScreenCenter
  ExplicitWidth = 432
  ExplicitHeight = 348
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrintTo: TLabel [0]
    Left = 8
    Top = 271
    Width = 3
    Height = 13
  end
  object lblReportsTitle: TMemo [1]
    Left = 8
    Top = 8
    Width = 301
    Height = 53
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Report Title, Date/Time, Location')
    ReadOnly = True
    TabOrder = 4
  end
  object grpDevice: TGroupBox [2]
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
      AutoSize = False
      Caption = 'Right Margin'
    end
    object lblLength: TLabel
      Left = 120
      Top = 166
      Width = 61
      Height = 13
      AutoSize = False
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
      Text = ''
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
      Text = ''
    end
    object cboDevice: TORComboBox
      Left = 8
      Top = 16
      Width = 395
      Height = 140
      Style = orcsSimple
      AutoSelect = True
      Caption = ''
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
      Text = ''
      OnChange = cboDeviceChange
      OnNeedData = cboDeviceNeedData
      CharsNeedMatch = 1
    end
  end
  object cmdOK: TButton [3]
    Left = 267
    Top = 272
    Width = 72
    Height = 22
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 347
    Top = 272
    Width = 72
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  object chkDefault: TCheckBox [5]
    Left = 8
    Top = 294
    Width = 171
    Height = 17
    Caption = 'Save as user'#39's default printer'
    TabOrder = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblReportsTitle'
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
        'Component = frmReportPrt'
        'Status = stsDefault'))
  end
  object dlgWinPrinter: TPrintDialog
    Left = 334
    Top = 18
  end
end
