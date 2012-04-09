inherited frmLkUpLocation: TfrmLkUpLocation
  Left = 377
  Top = 314
  Caption = 'Select Location'
  ClientHeight = 212
  ClientWidth = 356
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 364
  ExplicitHeight = 239
  PixelsPerInch = 96
  TextHeight = 13
  object lblLocation: TLabel [0]
    Left = 8
    Top = 8
    Width = 41
    Height = 13
    Caption = 'Location'
  end
  object lblInfo: TLabel [1]
    Left = 8
    Top = 176
    Width = 341
    Height = 28
    AutoSize = False
    WordWrap = True
  end
  object cboLocation: TORComboBox [2]
    Left = 8
    Top = 22
    Width = 193
    Height = 143
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Location'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    OnNeedData = cboLocationNeedData
    CharsNeedMatch = 1
  end
  object cmdOK: TButton [3]
    Left = 276
    Top = 22
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 276
    Top = 51
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboLocation'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmLkUpLocation'
        'Status = stsDefault'))
  end
end
