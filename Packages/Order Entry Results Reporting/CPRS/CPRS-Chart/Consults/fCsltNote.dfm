inherited frmCsltNote: TfrmCsltNote
  Left = 147
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Select Progress Note'
  ClientHeight = 189
  ClientWidth = 398
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 398
    Height = 189
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblAction: TLabel
      Left = 12
      Top = 14
      Width = 372
      Height = 16
      AutoSize = False
      Caption = 'Select a note for this action:'
    end
    object cmdOK: TButton
      Left = 122
      Top = 152
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 203
      Top = 152
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cboCsltNote: TORComboBox
      Left = 15
      Top = 32
      Width = 370
      Height = 103
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Select a note for this action'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2,3'
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
        'Component = cboCsltNote'
        'Status = stsDefault')
      (
        'Component = frmCsltNote'
        'Status = stsDefault'))
  end
end
