inherited frmODChangeUnreleasedRenew: TfrmODChangeUnreleasedRenew
  Left = 240
  Top = 163
  Caption = 'Change Unreleased Renewed Order'
  ClientHeight = 214
  ClientWidth = 517
  OldCreateOrder = False
  ExplicitWidth = 535
  ExplicitHeight = 259
  PixelsPerInch = 96
  TextHeight = 16
  object Panel3: TPanel [0]
    Left = 0
    Top = 105
    Width = 517
    Height = 77
    Align = alClient
    TabOrder = 3
    object Label1: TLabel
      Left = 61
      Top = 16
      Width = 67
      Height = 16
      Caption = 'Begin Date'
    end
    object Label2: TLabel
      Left = 274
      Top = 16
      Width = 56
      Height = 16
      Caption = 'End Date'
    end
    object txtStart: TORDateBox
      Left = 61
      Top = 39
      Width = 121
      Height = 24
      TabOrder = 0
      DateOnly = False
      RequireTime = False
      Caption = 'Begin Date'
    end
    object txtStop: TORDateBox
      Left = 274
      Top = 39
      Width = 121
      Height = 24
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'End Date'
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 105
    Width = 517
    Height = 77
    Align = alClient
    TabOrder = 0
    object lblDays: TLabel
      Left = 58
      Top = 10
      Width = 77
      Height = 16
      Caption = 'Days Supply'
    end
    object lblQuantity: TLabel
      Left = 158
      Top = 10
      Width = 48
      Height = 16
      Caption = 'Quantity'
      ParentShowHint = False
      ShowHint = True
    end
    object lblRefills: TLabel
      Left = 236
      Top = 10
      Width = 37
      Height = 16
      Caption = 'Refills'
    end
    object Label3: TLabel
      Left = 324
      Top = 10
      Width = 47
      Height = 16
      Caption = 'Pick Up'
    end
    object txtSupply: TCaptionEdit
      Left = 58
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
    object spnSupply: TUpDown
      Left = 118
      Top = 32
      Width = 20
      Height = 24
      Associate = txtSupply
      Max = 32766
      TabOrder = 2
    end
    object txtQuantity: TCaptionEdit
      Left = 158
      Top = 32
      Width = 40
      Height = 24
      AutoSize = False
      TabOrder = 3
      Text = '0'
      OnChange = txtQuantityChange
      OnClick = txtQuantityClick
      Caption = 'Quantity'
    end
    object spnQuantity: TUpDown
      Left = 198
      Top = 32
      Width = 20
      Height = 24
      Associate = txtQuantity
      Max = 32766
      TabOrder = 5
    end
    object txtRefills: TCaptionEdit
      Left = 230
      Top = 32
      Width = 49
      Height = 24
      TabOrder = 6
      Text = '0'
      OnChange = txtRefillsChange
      OnClick = txtRefillsClick
      Caption = 'Refills'
    end
    object spnRefills: TUpDown
      Left = 279
      Top = 32
      Width = 20
      Height = 24
      Associate = txtRefills
      Max = 11
      TabOrder = 8
    end
    object cboPickup: TORComboBox
      Left = 324
      Top = 32
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
  end
  object memOrder: TCaptionMemo [2]
    Left = 0
    Top = 0
    Width = 517
    Height = 105
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvRaised
    Color = clBtnFace
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
    Caption = ''
  end
  object Panel1: TPanel [3]
    Left = 0
    Top = 182
    Width = 517
    Height = 32
    Align = alBottom
    TabOrder = 1
    object btnOK: TButton
      Left = 348
      Top = 7
      Width = 75
      Height = 20
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 433
      Top = 7
      Width = 75
      Height = 20
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = txtStart'
        'Text = start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = txtStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmODChangeUnreleasedRenew'
        'Status = stsDefault')
      (
        'Component = txtSupply'
        'Status = stsDefault')
      (
        'Component = spnSupply'
        'Status = stsDefault')
      (
        'Component = txtQuantity'
        'Status = stsDefault')
      (
        'Component = spnQuantity'
        'Status = stsDefault')
      (
        'Component = txtRefills'
        'Status = stsDefault')
      (
        'Component = spnRefills'
        'Status = stsDefault')
      (
        'Component = cboPickup'
        'Status = stsDefault'))
  end
end
