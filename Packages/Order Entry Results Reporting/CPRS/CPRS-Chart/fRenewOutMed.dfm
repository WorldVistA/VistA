inherited frmRenewOutMed: TfrmRenewOutMed
  Left = 334
  Top = 436
  Caption = 'Change Refills for Outpatient Medication'
  ClientHeight = 205
  ClientWidth = 463
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 481
  ExplicitHeight = 250
  PixelsPerInch = 96
  TextHeight = 16
  object memOrder: TCaptionMemo [0]
    Left = 0
    Top = 0
    Width = 463
    Height = 100
    TabStop = False
    Align = alClient
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    Caption = 'Order'
  end
  object pnlButtons: TPanel [1]
    Left = 0
    Top = 164
    Width = 463
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      463
      41)
    object cmdOK: TButton
      Left = 277
      Top = 7
      Width = 72
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 355
      Top = 7
      Width = 103
      Height = 27
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  object pnlMiddle: TPanel [2]
    Left = 0
    Top = 100
    Width = 463
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblPickup: TLabel
      Left = 272
      Top = 12
      Width = 47
      Height = 16
      Caption = 'Pick Up'
    end
    object lblRefills: TLabel
      Left = 184
      Top = 10
      Width = 37
      Height = 16
      Caption = 'Refills'
    end
    object lblDays: TLabel
      Left = 16
      Top = 10
      Width = 77
      Height = 16
      Caption = 'Days Supply'
    end
    object lblQuantity: TLabel
      Left = 112
      Top = 10
      Width = 48
      Height = 16
      Caption = 'Quantity'
      ParentShowHint = False
      ShowHint = True
    end
    object cboPickup: TORComboBox
      Left = 272
      Top = 34
      Width = 125
      Height = 24
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Pick Up'
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
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 9
      Text = ''
      CharsNeedMatch = 1
    end
    object txtRefills: TCaptionEdit
      Left = 184
      Top = 32
      Width = 49
      Height = 24
      TabOrder = 4
      Text = '0'
      OnChange = txtRefillsChange
      OnClick = txtRefillsClick
      Caption = 'Refills'
    end
    object txtSupply: TCaptionEdit
      Left = 16
      Top = 32
      Width = 60
      Height = 24
      AutoSize = False
      TabOrder = 0
      Text = '0'
      OnChange = txtSupplyChange
      OnClick = txtSupplyClick
      Caption = 'Days Supply'
    end
    object spnQuantity: TUpDown
      Left = 152
      Top = 32
      Width = 16
      Height = 24
      Associate = txtQuantity
      Max = 32766
      TabOrder = 3
    end
    object spnSupply: TUpDown
      Left = 76
      Top = 32
      Width = 20
      Height = 24
      Associate = txtSupply
      Max = 32766
      TabOrder = 1
    end
    object txtQuantity: TCaptionEdit
      Left = 112
      Top = 32
      Width = 40
      Height = 24
      AutoSize = False
      TabOrder = 2
      Text = '0'
      OnChange = txtQuantityChange
      OnClick = txtQuantityClick
      Caption = 'Quantity'
    end
    object spnRefills: TUpDown
      Left = 233
      Top = 32
      Width = 20
      Height = 24
      Associate = txtRefills
      Max = 11
      TabOrder = 5
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = cboPickup'
        'Status = stsDefault')
      (
        'Component = txtRefills'
        'Status = stsDefault')
      (
        'Component = frmRenewOutMed'
        'Status = stsDefault')
      (
        'Component = txtSupply'
        'Status = stsDefault')
      (
        'Component = spnQuantity'
        'Status = stsDefault')
      (
        'Component = spnSupply'
        'Status = stsDefault')
      (
        'Component = txtQuantity'
        'Status = stsDefault')
      (
        'Component = spnRefills'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508ComponentAccessibility1StateQuery
    Left = 40
  end
end
