inherited frmConsultsByDate: TfrmConsultsByDate
  Left = 372
  Top = 217
  BorderIcons = []
  Caption = 'List Consults by Date Range'
  ClientHeight = 232
  ClientWidth = 224
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 240
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 224
    Height = 199
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 191
    object lblBeginDate: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 216
      Height = 16
      Align = alTop
      Caption = 'Beginning Date'
      ExplicitWidth = 92
    end
    object lblEndDate: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 56
      Width = 216
      Height = 16
      Align = alTop
      Caption = 'Ending Date'
      ExplicitWidth = 74
    end
    object calBeginDate: TORDateBox
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 216
      Height = 24
      Align = alTop
      TabOrder = 0
      DateOnly = False
      RequireTime = False
      Caption = 'Beginning Date'
    end
    object calEndDate: TORDateBox
      AlignWithMargins = True
      Left = 4
      Top = 78
      Width = 216
      Height = 24
      Align = alTop
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'Ending Date'
    end
    object radSort: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 108
      Width = 216
      Height = 87
      Align = alClient
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (oldest first)'
        '&Descending (newest first)')
      TabOrder = 2
      ExplicitHeight = 79
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 199
    Width = 224
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 71
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
      ExplicitTop = 8
      ExplicitHeight = 25
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 149
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitTop = 8
      ExplicitHeight = 25
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 192
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = calBeginDate'
        'Text = Beginning Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calEndDate'
        'Text = Ending Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmConsultsByDate'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
