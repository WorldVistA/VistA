inherited frmLabTests: TfrmLabTests
  Left = 288
  Top = 115
  Caption = 'Select Lab Tests'
  ClientHeight = 281
  ClientWidth = 452
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLabTests: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 452
    Height = 281
    Align = alClient
    TabOrder = 0
    object lblTests: TLabel
      Left = 12
      Top = 12
      Width = 79
      Height = 13
      Caption = 'Laboratory Tests'
    end
    object lblList: TLabel
      Left = 276
      Top = 28
      Width = 100
      Height = 13
      Caption = 'Tests to be displayed'
    end
    object cmdOK: TButton
      Left = 270
      Top = 247
      Width = 72
      Height = 21
      Caption = 'OK'
      TabOrder = 5
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 362
      Top = 246
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 6
    end
    object lstList: TORListBox
      Left = 274
      Top = 52
      Width = 160
      Height = 179
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = lstListClick
      Caption = 'Tests to be displayed'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object cboTests: TORComboBox
      Left = 10
      Top = 34
      Width = 160
      Height = 200
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Laboratory Tests'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnChange = cboTestsChange
      OnDblClick = cmdAddClick
      OnEnter = cboTestsEnter
      OnExit = cboTestsExit
      OnNeedData = cboTestsNeedData
      CharsNeedMatch = 1
    end
    object cmdRemove: TButton
      Left = 186
      Top = 144
      Width = 72
      Height = 21
      Caption = 'Remove One'
      Enabled = False
      TabOrder = 3
      OnClick = cmdRemoveClick
    end
    object cmdClear: TButton
      Left = 186
      Top = 116
      Width = 72
      Height = 21
      Caption = 'Remove All'
      Enabled = False
      TabOrder = 2
      OnClick = cmdClearClick
    end
    object cmdAdd: TButton
      Left = 186
      Top = 32
      Width = 72
      Height = 21
      Caption = 'Add'
      Enabled = False
      TabOrder = 1
      OnClick = cmdAddClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlLabTests'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lstList'
        'Status = stsDefault')
      (
        'Component = cboTests'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = cmdClear'
        'Status = stsDefault')
      (
        'Component = cmdAdd'
        'Status = stsDefault')
      (
        'Component = frmLabTests'
        'Status = stsDefault'))
  end
end
