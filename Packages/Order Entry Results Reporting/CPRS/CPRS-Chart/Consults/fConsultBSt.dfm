inherited frmConsultsByStatus: TfrmConsultsByStatus
  Left = 286
  Top = 202
  BorderIcons = []
  Caption = 'List Consults by Status'
  ClientHeight = 205
  ClientWidth = 308
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 308
    Height = 205
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblStatus: TLabel
      Left = 8
      Top = 8
      Width = 30
      Height = 13
      Caption = 'Status'
    end
    object radSort: TRadioGroup
      Left = 8
      Top = 148
      Width = 212
      Height = 49
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (A-Z)'
        '&Descending (Z-A)')
      TabOrder = 1
    end
    object lstStatus: TORListBox
      Left = 8
      Top = 22
      Width = 212
      Height = 118
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Status'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object cmdOK: TButton
      Left = 228
      Top = 149
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 228
      Top = 176
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
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
        'Status = stsDefault'))
  end
end
