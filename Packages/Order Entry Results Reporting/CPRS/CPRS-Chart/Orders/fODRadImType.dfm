inherited frmODRadImType: TfrmODRadImType
  Left = 308
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Select Imaging Type'
  ClientHeight = 189
  ClientWidth = 259
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 259
    Height = 189
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SrcLabel: TLabel
      Left = 12
      Top = 14
      Width = 145
      Height = 16
      AutoSize = False
      Caption = 'Select or enter imaging type'
    end
    object cmdOK: TButton
      Left = 57
      Top = 151
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 138
      Top = 151
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cboImType: TORComboBox
      Left = 14
      Top = 31
      Width = 234
      Height = 103
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Select or enter imaging type'
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
      OnDblClick = cboImTypeDblClick
      CharsNeedMatch = 1
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
        'Component = cboImType'
        'Status = stsDefault')
      (
        'Component = frmODRadImType'
        'Status = stsDefault'))
  end
end
