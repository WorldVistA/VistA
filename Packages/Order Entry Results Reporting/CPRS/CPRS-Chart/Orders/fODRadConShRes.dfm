inherited frmODRadConShRes: TfrmODRadConShRes
  Left = 308
  Top = 206
  ActiveControl = txtResearch
  BorderStyle = bsDialog
  Caption = 'Contract/Sharing/Research Source'
  ClientHeight = 149
  ClientWidth = 354
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 294
  ExplicitHeight = 146
  PixelsPerInch = 120
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 354
    Height = 149
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SrcLabel: TLabel
      Left = 15
      Top = 17
      Width = 133
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Select or enter source:'
    end
    object cmdOK: TButton
      Left = 71
      Top = 91
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 171
      Top = 91
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object cboSource: TORComboBox
      Left = 17
      Top = 38
      Width = 323
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Select or enter source:'
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
      Text = ''
      CharsNeedMatch = 1
    end
    object txtResearch: TCaptionEdit
      Left = 15
      Top = 38
      Width = 321
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      MaxLength = 40
      TabOrder = 1
      Caption = 'Select or enter source:'
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
        'Component = cboSource'
        'Status = stsDefault')
      (
        'Component = txtResearch'
        'Status = stsDefault')
      (
        'Component = frmODRadConShRes'
        'Status = stsDefault'))
  end
end
