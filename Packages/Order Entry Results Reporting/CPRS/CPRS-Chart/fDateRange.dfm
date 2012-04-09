inherited frmDateRange: TfrmDateRange
  Left = 460
  Top = 262
  Caption = 'Date Range'
  ClientHeight = 132
  ClientWidth = 274
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 282
  ExplicitHeight = 159
  PixelsPerInch = 96
  TextHeight = 13
  object lblStart: TLabel [0]
    Left = 8
    Top = 44
    Width = 53
    Height = 13
    Caption = 'Begin Date'
  end
  object lblStop: TLabel [1]
    Left = 145
    Top = 44
    Width = 45
    Height = 13
    Caption = 'End Date'
  end
  object lblInstruct: TOROffsetLabel [2]
    Left = 0
    Top = 0
    Width = 274
    Height = 37
    Align = alTop
    Caption = 'Select a date range -'
    HorzOffset = 8
    Transparent = False
    VertOffset = 8
    WordWrap = True
  end
  object txtStart: TORDateBox [3]
    Left = 8
    Top = 58
    Width = 121
    Height = 21
    TabOrder = 0
    DateOnly = False
    RequireTime = False
    Caption = 'Begin Date'
  end
  object txtStop: TORDateBox [4]
    Left = 145
    Top = 58
    Width = 121
    Height = 21
    TabOrder = 1
    DateOnly = False
    RequireTime = False
    Caption = 'End Date'
  end
  object cmdOK: TButton [5]
    Left = 114
    Top = 103
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [6]
    Left = 194
    Top = 103
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
        'Status = stsDefault')
      (
        'Component = txtStop'
        'Status = stsDefault')
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
