inherited frmConsultsView: TfrmConsultsView
  Left = 320
  Top = 172
  BorderIcons = []
  Caption = 'List Selected Consults'
  ClientHeight = 373
  ClientWidth = 406
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 406
    Height = 373
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblBeginDate: TLabel
      Left = 239
      Top = 128
      Width = 73
      Height = 13
      Caption = 'Beginning Date'
    end
    object lblEndDate: TLabel
      Left = 239
      Top = 173
      Width = 59
      Height = 13
      Caption = 'Ending Date'
    end
    object lblService: TLabel
      Left = 8
      Top = 9
      Width = 36
      Height = 13
      Caption = 'Service'
    end
    object lblStatus: TLabel
      Left = 239
      Top = 10
      Width = 30
      Height = 13
      Caption = 'Status'
    end
    object Label1: TLabel
      Left = 239
      Top = 217
      Width = 44
      Height = 13
      Caption = 'Group By'
    end
    object calBeginDate: TORDateBox
      Left = 239
      Top = 142
      Width = 155
      Height = 21
      TabOrder = 3
      DateOnly = False
      RequireTime = False
      Caption = 'Beginning Date'
    end
    object calEndDate: TORDateBox
      Left = 239
      Top = 187
      Width = 155
      Height = 21
      TabOrder = 4
      DateOnly = False
      RequireTime = False
      Caption = 'Ending Date'
    end
    object lstStatus: TORListBox
      Left = 239
      Top = 24
      Width = 156
      Height = 96
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      PopupMenu = popStatus
      ShowHint = True
      TabOrder = 2
      Caption = 'Status'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object radSort: TRadioGroup
      Left = 239
      Top = 266
      Width = 155
      Height = 64
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (oldest first)'
        '&Descending (newest first)')
      TabOrder = 6
    end
    object cmdOK: TButton
      Left = 239
      Top = 340
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 7
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 324
      Top = 340
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 8
      OnClick = cmdCancelClick
    end
    object treService: TORTreeView
      Left = 8
      Top = 57
      Width = 214
      Height = 304
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 1
      OnChange = treServiceChange
      Caption = 'Service'
      NodePiece = 0
    end
    object cboService: TORComboBox
      Left = 8
      Top = 27
      Width = 214
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service'
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
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 0
      OnKeyPause = cboServiceSelect
      OnMouseClick = cboServiceSelect
      CharsNeedMatch = 1
    end
    object cboGroupBy: TORComboBox
      Left = 239
      Top = 230
      Width = 155
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Group By'
      Color = clWindow
      DropDownCount = 8
      Items.Strings = (
        '^(none)'
        'T^Consults/Procedures'
        'V^Service'
        'S^Status')
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
      TabOrder = 5
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = calBeginDate'
        'Status = stsDefault')
      (
        'Component = calEndDate'
        'Status = stsDefault')
      (
        'Component = lstStatus'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cboGroupBy'
        'Status = stsDefault')
      (
        'Component = frmConsultsView'
        'Status = stsDefault'))
  end
  object popStatus: TPopupMenu
    Left = 284
    Top = 51
    object popStatusSelectNone: TMenuItem
      Caption = 'Select None'
      OnClick = popStatusSelectNoneClick
    end
  end
end
