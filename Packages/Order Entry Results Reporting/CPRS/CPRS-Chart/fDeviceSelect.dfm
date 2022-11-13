inherited frmDeviceSelect: TfrmDeviceSelect
  Left = 378
  Top = 340
  Caption = 'Orders Print Device Selection'
  ClientHeight = 235
  ClientWidth = 415
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 423
  ExplicitHeight = 262
  PixelsPerInch = 96
  TextHeight = 16
  object grpDevice: TGroupBox [0]
    Left = 0
    Top = 0
    Width = 415
    Height = 203
    Align = alClient
    Caption = 'Device'
    TabOrder = 0
    ExplicitHeight = 194
    object cboDevice: TORComboBox
      AlignWithMargins = True
      Left = 5
      Top = 21
      Width = 405
      Height = 143
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Device'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
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
      ExplicitLeft = 2
      ExplicitTop = 18
      ExplicitWidth = 411
      ExplicitHeight = 142
    end
    object pnlGBBottom: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 170
      Width = 405
      Height = 28
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 2
      ExplicitTop = 173
      ExplicitWidth = 411
      object lblMargin: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 22
        Align = alLeft
        Caption = 'Right Margin'
        ExplicitLeft = 8
        ExplicitTop = 12
        ExplicitHeight = 16
      end
      object lblLength: TLabel
        AlignWithMargins = True
        Left = 123
        Top = 3
        Width = 76
        Height = 22
        Align = alLeft
        Caption = 'Page Length'
        ExplicitLeft = 120
        ExplicitTop = 12
        ExplicitHeight = 16
      end
      object txtRightMargin: TMaskEdit
        AlignWithMargins = True
        Left = 84
        Top = 3
        Width = 33
        Height = 22
        Align = alLeft
        AutoSize = False
        EditMask = '99999;0; '
        MaxLength = 5
        TabOrder = 0
        Text = ''
        ExplicitLeft = 72
        ExplicitTop = 6
        ExplicitHeight = 19
      end
      object txtPageLength: TMaskEdit
        AlignWithMargins = True
        Left = 205
        Top = 3
        Width = 34
        Height = 22
        Align = alLeft
        AutoSize = False
        EditMask = '99999;0; '
        MaxLength = 5
        TabOrder = 1
        Text = ''
        ExplicitLeft = 184
        ExplicitTop = 6
        ExplicitHeight = 19
      end
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 203
    Width = 415
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 194
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 262
      Top = 3
      Width = 72
      Height = 26
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
      ExplicitLeft = 257
      ExplicitTop = 11
      ExplicitHeight = 22
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 340
      Top = 3
      Width = 72
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitLeft = 337
      ExplicitTop = 11
      ExplicitHeight = 22
    end
    object chkDefault: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 217
      Height = 26
      Align = alLeft
      Caption = 'Save as user'#39's default printer'
      TabOrder = 2
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 56
    Data = (
      (
        'Component = grpDevice'
        'Status = stsDefault')
      (
        'Component = cboDevice'
        'Status = stsDefault')
      (
        'Component = pnlGBBottom'
        'Status = stsDefault')
      (
        'Component = txtRightMargin'
        'Status = stsDefault')
      (
        'Component = txtPageLength'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
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
        'Component = frmDeviceSelect'
        'Status = stsDefault'))
  end
end
