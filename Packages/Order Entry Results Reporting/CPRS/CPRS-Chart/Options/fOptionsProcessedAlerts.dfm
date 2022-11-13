inherited frmOptionsProcessedAlerts: TfrmOptionsProcessedAlerts
  Left = 232
  Top = 107
  HelpContext = 9100
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Processed Alerts Preferences'
  ClientHeight = 118
  ClientWidth = 314
  HelpFile = 'CPRSWT.HLP'
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 320
  ExplicitHeight = 147
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 86
    Width = 314
    Height = 32
    HelpContext = 9100
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 314
      Height = 2
      Align = alTop
      ExplicitWidth = 313
    end
    object btnDefaults: TButton
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alLeft
      Caption = 'Defaults'
      TabOrder = 0
      OnClick = btnDefaultsClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 236
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 86
      ExplicitTop = 3
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 155
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
      ExplicitLeft = 100
      ExplicitTop = 8
    end
  end
  object edDays: TEdit [1]
    Left = 200
    Top = 17
    Width = 106
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '33'
    OnKeyPress = edDaysKeyPress
  end
  object edMaxRecords: TEdit [2]
    Left = 200
    Top = 47
    Width = 105
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    NumbersOnly = True
    TabOrder = 3
    Text = '111'
  end
  object sTxtMaxRecords: TVA508StaticText [3]
    Name = 'sTxtMaxRecords'
    Left = 8
    Top = 49
    Width = 125
    Height = 15
    Alignment = taLeftJustify
    Caption = 'Max # of records to show:'
    TabOrder = 2
    ShowAccelChar = True
  end
  object sTxtLogDays: TVA508StaticText [4]
    Name = 'sTxtLogDays'
    Left = 8
    Top = 17
    Width = 122
    Height = 15
    Alignment = taLeftJustify
    Caption = 'Show Log Data for (days)'
    TabOrder = 0
    ShowAccelChar = True
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 152
    Top = 16
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = frmOptionsProcessedAlerts'
        'Status = stsDefault')
      (
        'Component = btnDefaults'
        'Status = stsDefault')
      (
        'Component = edDays'
        'Status = stsDefault')
      (
        'Component = edMaxRecords'
        'Status = stsDefault')
      (
        'Component = sTxtMaxRecords'
        'Status = stsDefault')
      (
        'Component = sTxtLogDays'
        'Status = stsDefault'))
  end
end
