inherited frmConsultsByService: TfrmConsultsByService
  Left = 339
  Top = 175
  BorderIcons = []
  Caption = 'List Consults by Service'
  ClientHeight = 385
  ClientWidth = 320
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 320
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblService: TLabel
      Left = 8
      Top = 8
      Width = 36
      Height = 13
      Caption = 'Service'
    end
    object radSort: TRadioGroup
      Left = 52
      Top = 289
      Width = 212
      Height = 49
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (A-Z)'
        '&Descending (Z-A)')
      TabOrder = 2
    end
    object cmdOK: TButton
      Left = 70
      Top = 350
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 3
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 157
      Top = 350
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = cmdCancelClick
    end
    object treService: TORTreeView
      Left = 7
      Top = 57
      Width = 305
      Height = 225
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 1
      OnChange = treServiceChange
      Caption = 'Service'
      NodePiece = 0
    end
    object cboService: TORComboBox
      Left = 8
      Top = 28
      Width = 305
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 0
      OnKeyPause = cboServiceSelect
      OnMouseClick = cboServiceSelect
      CharsNeedMatch = 1
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
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = frmConsultsByService'
        'Status = stsDefault'))
  end
end
