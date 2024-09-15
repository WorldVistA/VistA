inherited frmConsultsByStatus: TfrmConsultsByStatus
  Left = 286
  Top = 202
  BorderIcons = []
  Caption = 'List Consults by Status'
  ClientHeight = 311
  ClientWidth = 304
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 304
    Height = 278
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 270
    object lblStatus: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 296
      Height = 16
      Align = alTop
      Caption = 'Status'
      ExplicitWidth = 37
    end
    object radSort: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 200
      Width = 296
      Height = 74
      Align = alBottom
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (A-Z)'
        '&Descending (Z-A)')
      TabOrder = 1
      ExplicitTop = 192
    end
    object lstStatus: TORListBox
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 296
      Height = 168
      Align = alClient
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Status'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      ExplicitHeight = 160
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 278
    Width = 304
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 151
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
      ExplicitHeight = 30
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 229
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitHeight = 30
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 264
    Top = 48
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = lstStatus'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmConsultsByStatus'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
