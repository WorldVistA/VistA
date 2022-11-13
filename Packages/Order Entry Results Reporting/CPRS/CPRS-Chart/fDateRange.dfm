inherited frmDateRange: TfrmDateRange
  Left = 460
  Top = 262
  Caption = 'Date Range'
  ClientHeight = 138
  ClientWidth = 318
  Position = poScreenCenter
  ExplicitWidth = 336
  ExplicitHeight = 183
  PixelsPerInch = 96
  TextHeight = 16
  object lblStart: TLabel [0]
    Left = 32
    Top = 59
    Width = 67
    Height = 16
    Caption = 'Begin Date'
  end
  object lblStop: TLabel [1]
    Left = 169
    Top = 59
    Width = 56
    Height = 16
    Caption = 'End Date'
  end
  object lblInstruct: TOROffsetLabel [2]
    Left = 0
    Top = 0
    Width = 318
    Height = 53
    Align = alTop
    Caption = 'Select a date range -'
    HorzOffset = 8
    Transparent = False
    VertOffset = 8
    WordWrap = True
  end
  object txtStart: TORDateBox [3]
    Left = 32
    Top = 73
    Width = 121
    Height = 24
    TabOrder = 0
    DateOnly = False
    RequireTime = False
    Caption = 'Begin Date'
  end
  object txtStop: TORDateBox [4]
    Left = 169
    Top = 73
    Width = 121
    Height = 24
    TabOrder = 1
    DateOnly = False
    RequireTime = False
    Caption = 'End Date'
  end
  object cmdOK: TButton [5]
    Left = 154
    Top = 109
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [6]
    Left = 234
    Top = 109
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtStart'
        'Text = Begin Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = txtStop'
        'Text = End Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmDateRange'
        'Status = stsDefault'))
  end
end
