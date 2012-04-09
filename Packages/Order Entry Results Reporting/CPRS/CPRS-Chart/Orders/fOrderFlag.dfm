inherited frmFlagOrder: TfrmFlagOrder
  Left = 334
  Top = 234
  Caption = 'Flag Order'
  ClientHeight = 264
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitLeft = 334
  ExplicitTop = 234
  ExplicitWidth = 320
  ExplicitHeight = 291
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 80
    Width = 199
    Height = 13
    Caption = 'Reason for Flag    (Enter or select from list)'
  end
  object lblAlertRecipient: TLabel [1]
    Left = 8
    Top = 211
    Width = 69
    Height = 13
    Caption = 'Alert Recipient'
  end
  object cmdOK: TButton [2]
    Left = 267
    Top = 227
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 347
    Top = 227
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  object memOrder: TMemo [4]
    Left = 8
    Top = 8
    Width = 411
    Height = 56
    Color = clBtnFace
    Lines.Strings = (
      'memOrder')
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
  end
  object cboAlertRecipient: TORComboBox [5]
    Left = 7
    Top = 227
    Width = 226
    Height = 21
    HelpContext = 9102
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Alert Recipient'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    Pieces = '2,3'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    OnExit = cboOnExit
    OnNeedData = cboAlertRecipientNeedData
    CharsNeedMatch = 1
  end
  object cboFlagReason: TORComboBox [6]
    Left = 8
    Top = 99
    Width = 411
    Height = 106
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 80
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cboAlertRecipient'
        'Status = stsDefault')
      (
        'Component = cboFlagReason'
        'Status = stsDefault')
      (
        'Component = frmFlagOrder'
        'Status = stsDefault'))
  end
end
