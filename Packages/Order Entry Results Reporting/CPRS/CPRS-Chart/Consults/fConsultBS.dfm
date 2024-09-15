inherited frmConsultsByService: TfrmConsultsByService
  Left = 339
  Top = 175
  BorderIcons = []
  Caption = 'List Consults by Service'
  ClientHeight = 339
  ClientWidth = 224
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 240
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 224
    Height = 306
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 304
    ExplicitHeight = 409
    object lblService: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 216
      Height = 16
      Align = alTop
      Caption = 'Service'
      ExplicitWidth = 46
    end
    object radSort: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 235
      Width = 216
      Height = 67
      Align = alBottom
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (A-Z)'
        '&Descending (Z-A)')
      TabOrder = 2
      ExplicitTop = 338
      ExplicitWidth = 296
    end
    object treService: TORTreeView
      AlignWithMargins = True
      Left = 4
      Top = 56
      Width = 216
      Height = 173
      Align = alClient
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 1
      OnChange = treServiceChange
      Caption = 'Service'
      NodePiece = 0
      ExplicitWidth = 296
      ExplicitHeight = 276
    end
    object cboService: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 216
      Height = 24
      Style = orcsDropDown
      Align = alTop
      AutoSelect = True
      Caption = 'Service'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
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
      Text = ''
      OnKeyPause = cboServiceSelect
      OnMouseClick = cboServiceSelect
      CharsNeedMatch = 1
      ExplicitWidth = 296
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 306
    Width = 224
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 409
    ExplicitWidth = 304
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
      ExplicitLeft = 151
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
      ExplicitLeft = 229
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 120
    Top = 88
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
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
