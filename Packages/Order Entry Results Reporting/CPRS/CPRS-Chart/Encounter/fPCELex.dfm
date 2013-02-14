inherited frmPCELex: TfrmPCELex
  Left = 639
  Top = 480
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Lookup Other Diagnosis'
  ClientHeight = 275
  ClientWidth = 429
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  ExplicitHeight = 307
  PixelsPerInch = 96
  TextHeight = 13
  object lblSearch: TLabel [0]
    Left = 6
    Top = 16
    Width = 98
    Height = 13
    Caption = 'Search for Diagnosis'
  end
  object lblSelect: TLabel [1]
    Left = 6
    Top = 67
    Width = 175
    Height = 13
    Caption = 'Select from one of the following items'
    Visible = False
  end
  object txtSearch: TCaptionEdit [2]
    Left = 6
    Top = 30
    Width = 331
    Height = 21
    TabOrder = 0
    OnChange = txtSearchChange
    Caption = 'Search for Diagnosis'
  end
  object cmdSearch: TButton [3]
    Left = 346
    Top = 30
    Width = 75
    Height = 21
    Caption = 'Search'
    Default = True
    TabOrder = 1
    OnClick = cmdSearchClick
  end
  object cmdOK: TButton [4]
    Left = 263
    Top = 245
    Width = 75
    Height = 22
    Caption = 'OK'
    TabOrder = 3
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [5]
    Left = 346
    Top = 245
    Width = 75
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = cmdCancelClick
  end
  object lstSelect: TORListBox [6]
    Left = 6
    Top = 81
    Width = 415
    Height = 156
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = lstSelectClick
    OnDblClick = lstSelectDblClick
    Caption = 'Select from one of the following items'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtSearch'
        'Status = stsDefault')
      (
        'Component = cmdSearch'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lstSelect'
        'Status = stsDefault')
      (
        'Component = frmPCELex'
        'Status = stsDefault'))
  end
end
