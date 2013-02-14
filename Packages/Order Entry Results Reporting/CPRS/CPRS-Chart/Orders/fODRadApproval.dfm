inherited frmODRadApproval: TfrmODRadApproval
  Left = 295
  Top = 167
  BorderStyle = bsDialog
  Caption = 'Select Approving Radiologist'
  ClientHeight = 262
  ClientWidth = 259
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 259
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SrcLabel: TLabel
      Left = 12
      Top = 14
      Width = 98
      Height = 13
      Caption = 'Select or enter name'
    end
    object cmdOK: TButton
      Left = 52
      Top = 227
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 132
      Top = 226
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cboRadiologist: TORComboBox
      Left = 13
      Top = 31
      Width = 234
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
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 0
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
        'Component = cboRadiologist'
        'Status = stsDefault')
      (
        'Component = frmODRadApproval'
        'Status = stsDefault'))
  end
end
