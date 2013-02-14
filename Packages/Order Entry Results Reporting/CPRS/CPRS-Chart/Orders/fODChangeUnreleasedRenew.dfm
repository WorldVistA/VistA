inherited frmODChangeUnreleasedRenew: TfrmODChangeUnreleasedRenew
  Left = 240
  Top = 163
  Caption = 'Change Unreleased Renewed Order'
  ClientHeight = 171
  ClientWidth = 529
  OldCreateOrder = False
  OnCreate = FormCreate
  ExplicitWidth = 537
  ExplicitHeight = 198
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel [0]
    Left = 0
    Top = 57
    Width = 529
    Height = 82
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 81
    object lblRefill: TLabel
      Left = 9
      Top = 15
      Width = 28
      Height = 13
      Caption = 'Refills'
    end
    object lblPickUp: TLabel
      Left = 216
      Top = 15
      Width = 36
      Height = 13
      Caption = 'Pick up'
    end
    object edtRefill: TCaptionEdit
      Left = 8
      Top = 34
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object cboPickup: TORComboBox
      Left = 216
      Top = 32
      Width = 145
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      CharsNeedMatch = 1
    end
  end
  object Panel3: TPanel [1]
    Left = 0
    Top = 57
    Width = 529
    Height = 82
    Align = alClient
    TabOrder = 3
    ExplicitHeight = 81
    object Label1: TLabel
      Left = 61
      Top = 16
      Width = 53
      Height = 13
      Caption = 'Begin Date'
    end
    object Label2: TLabel
      Left = 274
      Top = 17
      Width = 45
      Height = 13
      Caption = 'End Date'
    end
    object txtStart: TORDateBox
      Left = 61
      Top = 39
      Width = 121
      Height = 21
      TabOrder = 0
      DateOnly = False
      RequireTime = False
      Caption = 'Begin Date'
    end
    object txtStop: TORDateBox
      Left = 274
      Top = 39
      Width = 121
      Height = 21
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'End Date'
    end
  end
  object memOrder: TCaptionMemo [2]
    Left = 0
    Top = 0
    Width = 529
    Height = 57
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvRaised
    Color = clBtnFace
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Panel1: TPanel [3]
    Left = 0
    Top = 139
    Width = 529
    Height = 32
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 138
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
        'Component = edtRefill'
        'Status = stsDefault')
      (
        'Component = cboPickup'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = txtStart'
        'Status = stsDefault')
      (
        'Component = txtStop'
        'Status = stsDefault')
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
        'Status = stsDefault'))
  end
end
