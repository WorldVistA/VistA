inherited frmODLabOthSpec: TfrmODLabOthSpec
  Left = 240
  Top = 136
  BorderIcons = []
  Caption = 'Select Specimen'
  ClientHeight = 332
  ClientWidth = 309
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 309
    Height = 332
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object cboOtherSpec: TORComboBox
      Left = 9
      Top = 22
      Width = 291
      Height = 270
      Style = orcsSimple
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnDblClick = cboOtherSpecDblClick
      OnNeedData = cboOtherSpecNeedData
      CharsNeedMatch = 1
    end
    object cmdOK: TButton
      Left = 76
      Top = 302
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 160
      Top = 302
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cboOtherSpec'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmODLabOthSpec'
        'Status = stsDefault'))
  end
end
