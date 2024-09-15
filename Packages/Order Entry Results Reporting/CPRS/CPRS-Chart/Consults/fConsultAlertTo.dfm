inherited frmConsultAlertsTo: TfrmConsultAlertsTo
  Left = 297
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Send Alert'
  ClientHeight = 305
  ClientWidth = 444
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 450
  ExplicitHeight = 334
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 444
    Height = 272
    Align = alClient
    TabOrder = 0
    DesignSize = (
      444
      272)
    object SrcLabel: TLabel
      Left = 12
      Top = 8
      Width = 98
      Height = 13
      Caption = 'Select or enter name'
    end
    object DstLabel: TLabel
      Left = 263
      Top = 8
      Width = 132
      Height = 13
      Caption = 'Currently selected recipients'
    end
    object cboSrcList: TORComboBox
      Left = 0
      Top = 30
      Width = 178
      Height = 236
      Anchors = [akLeft, akTop, akBottom]
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Select or enter name'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnKeyDown = cboSrcListKeyDown
      OnMouseClick = cboSrcListMouseClick
      OnNeedData = cboSrcListNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object DstList: TORListBox
      Left = 263
      Top = 35
      Width = 178
      Height = 231
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = DstListClick
      Caption = 'Currently selected recipients'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object btnAdd: TButton
      Left = 184
      Top = 32
      Width = 73
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = cboSrcListMouseClick
    end
    object btnRemove: TButton
      Left = 184
      Top = 63
      Width = 73
      Height = 25
      Caption = 'Remove'
      TabOrder = 2
      OnClick = DstListClick
    end
  end
  object pnlButtons: TPanel [1]
    Left = 0
    Top = 272
    Width = 444
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 285
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 366
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 88
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
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault'))
  end
end
