inherited frmFlagOrder: TfrmFlagOrder
  Left = 334
  Top = 234
  Caption = 'Flag Order'
  ClientHeight = 431
  ClientWidth = 429
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 445
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 8
    Top = 80
    Width = 249
    Height = 16
    Caption = 'Reason for Flag    (Enter or select from list)'
  end
  object lblAlertRecipient: TLabel [1]
    Left = 8
    Top = 211
    Width = 94
    Height = 16
    Caption = 'Alert Recipients'
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 403
    Width = 128
    Height = 16
    Caption = 'No Un-Flagging Alert:'
  end
  object cmdOK: TButton [3]
    Left = 269
    Top = 404
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 347
    Top = 404
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object memOrder: TMemo [5]
    Left = 8
    Top = 8
    Width = 411
    Height = 56
    Color = clBtnFace
    Lines.Strings = (
      'memOrder')
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
  end
  object cboFlagReason: TORComboBox [6]
    Left = 8
    Top = 99
    Width = 411
    Height = 106
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
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
    Text = ''
    CharsNeedMatch = 1
  end
  object cboAlertRecipient: TORComboBox [7]
    Left = 8
    Top = 230
    Width = 169
    Height = 163
    Style = orcsSimple
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2'
    ShowHint = True
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 4
    Text = ''
    OnChange = cboAlertRecipientChange
    OnExit = cboOnExit
    OnNeedData = cboAlertRecipientNeedData
    CharsNeedMatch = 1
  end
  object orSelectedRecipients: TORListBox [8]
    Left = 269
    Top = 230
    Width = 150
    Height = 163
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object dtFlagExpire: TORDateBox [9]
    Left = 114
    Top = 399
    Width = 128
    Height = 24
    TabOrder = 6
    DateOnly = False
    RequireTime = False
    Caption = ''
  end
  object btnRemoveRecipients: TButton [10]
    Left = 183
    Top = 271
    Width = 80
    Height = 25
    Caption = 'Remove'
    Enabled = False
    TabOrder = 9
    OnClick = btnRemoveRecipientsClick
  end
  object btnRemoveAllRecipients: TButton [11]
    Left = 183
    Top = 302
    Width = 80
    Height = 25
    Caption = 'Remove All'
    Enabled = False
    TabOrder = 10
    OnClick = btnRemoveAllRecipientsClick
  end
  object btnAddRecipient: TButton [12]
    Left = 183
    Top = 240
    Width = 80
    Height = 25
    Caption = 'Add'
    Enabled = False
    TabOrder = 11
    OnClick = btnAddRecipientClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdOK'
        'Text = Close Form'
        'Status = stsOK')
      (
        'Component = cmdCancel'
        'Text = Cancel Form'
        'Status = stsOK')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cboFlagReason'
        'Text = Select a Flagging Reason or Manually Enter a Reason'
        'Status = stsOK')
      (
        'Component = frmFlagOrder'
        'Status = stsDefault')
      (
        'Component = cboAlertRecipient'
        'Status = stsDefault')
      (
        'Component = orSelectedRecipients'
        'Status = stsDefault')
      (
        'Component = dtFlagExpire'
        'Text = Select a date for the Flag Notification to Expire'
        'Status = stsOK')
      (
        'Component = btnRemoveRecipients'
        'Text = Remove a Recipient from Flag Notification List'
        'Status = stsOK')
      (
        'Component = btnRemoveAllRecipients'
        'Text = Remove all Recipients from Flag Notification List'
        'Status = stsOK')
      (
        'Component = btnAddRecipient'
        'Text = Add to Recipient to Flag Notification List'
        'Status = stsOK'))
  end
end
