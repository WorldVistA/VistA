inherited frmRenewOutMed: TfrmRenewOutMed
  Left = 334
  Top = 436
  Caption = 'Change Refills for Outpatient Medication'
  ClientHeight = 200
  ClientWidth = 356
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 364
  ExplicitHeight = 227
  PixelsPerInch = 96
  TextHeight = 13
  object memOrder: TCaptionMemo [0]
    Left = 0
    Top = 0
    Width = 356
    Height = 95
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
    Top = 159
    Width = 356
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 165
    DesignSize = (
      356
      41)
    object cmdOK: TButton
      Left = 170
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
      Left = 248
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
    Top = 95
    Width = 356
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblPickup: TLabel
      Left = 100
      Top = 7
      Width = 38
      Height = 13
      Caption = 'Pick Up'
    end
    object lblRefills: TLabel
      Left = 8
      Top = 7
      Width = 28
      Height = 13
      Caption = 'Refills'
    end
    object cboPickup: TORComboBox
      Left = 100
      Top = 31
      Width = 125
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Pick Up'
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
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      CharsNeedMatch = 1
    end
    object txtRefills: TCaptionEdit
      Left = 8
      Top = 31
      Width = 49
      Height = 21
      TabOrder = 1
      Caption = 'Refills'
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
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508ComponentAccessibility1StateQuery
    Left = 296
    Top = 8
  end
end
