inherited frmAlertOrders: TfrmAlertOrders
  Left = 374
  Top = 193
  Caption = 'Alert when Results Available'
  ClientHeight = 251
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  ExplicitHeight = 290
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 8
    Width = 297
    Height = 13
    Caption = 
      'The following orders will send alerts when results are available' +
      ' -'
  end
  object lblAlertRecipient: TLabel [1]
    Left = 8
    Top = 208
    Width = 72
    Height = 13
    Caption = 'Alert Recipient:'
  end
  object lstOrders: TCaptionListBox [2]
    Left = 8
    Top = 22
    Width = 411
    Height = 176
    ItemHeight = 13
    TabOrder = 0
    Caption = 
      'The following orders will send alerts when results are available' +
      ' -'
  end
  object cmdOK: TButton [3]
    Left = 267
    Top = 222
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object cmdCancel: TButton [4]
    Left = 347
    Top = 222
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object cboAlertRecipient: TORComboBox [5]
    Left = 7
    Top = 222
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
    Text = ''
    OnNeedData = cboAlertRecipientNeedData
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboAlertRecipient'
        'Status = stsDefault')
      (
        'Component = frmAlertOrders'
        'Status = stsDefault'))
  end
end
