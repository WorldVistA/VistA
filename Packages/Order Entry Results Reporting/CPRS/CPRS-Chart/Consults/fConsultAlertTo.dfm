inherited frmConsultAlertsTo: TfrmConsultAlertsTo
  Left = 297
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Send Alert'
  ClientHeight = 262
  ClientWidth = 371
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 371
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 358
    object SrcLabel: TLabel
      Left = 12
      Top = 14
      Width = 98
      Height = 13
      Caption = 'Select or enter name'
    end
    object DstLabel: TLabel
      Left = 217
      Top = 14
      Width = 132
      Height = 13
      Caption = 'Currently selected recipients'
    end
    object cmdOK: TButton
      Left = 105
      Top = 226
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 4
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 185
      Top = 226
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
      OnClick = cmdCancelClick
    end
    object cboSrcList: TORComboBox
      Left = 12
      Top = 30
      Width = 144
      Height = 185
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Select or enter name'
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
      TabOrder = 0
      OnKeyDown = cboSrcListKeyDown
      OnMouseClick = cboSrcListMouseClick
      OnNeedData = cboSrcListNeedData
      CharsNeedMatch = 1
    end
    object DstList: TORListBox
      Left = 217
      Top = 30
      Width = 144
      Height = 185
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = DstListClick
      Caption = 'Currently selected recipients'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object btnAdd: TButton
      Left = 160
      Top = 109
      Width = 51
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = cboSrcListMouseClick
    end
    object btnRemove: TButton
      Left = 160
      Top = 140
      Width = 51
      Height = 25
      Caption = 'Remove'
      TabOrder = 3
      OnClick = DstListClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboSrcList'
        'Status = stsDefault')
      (
        'Component = DstList'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = frmConsultAlertsTo'
        'Status = stsDefault'))
  end
end
