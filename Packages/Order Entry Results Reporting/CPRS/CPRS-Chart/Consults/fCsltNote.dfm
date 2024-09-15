inherited frmCsltNote: TfrmCsltNote
  Left = 147
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Select Progress Note'
  ClientHeight = 203
  ClientWidth = 314
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 320
  ExplicitHeight = 236
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 314
    Height = 170
    Align = alClient
    TabOrder = 0
    object lblAction: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 306
      Height = 16
      Align = alTop
      Caption = 'Select a note for this action:'
      ExplicitWidth = 161
    end
    object cboCsltNote: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 306
      Height = 140
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Select a note for this action'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
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
      Text = ''
      CharsNeedMatch = 1
    end
  end
  object pnlButtons: TPanel [1]
    Left = 0
    Top = 170
    Width = 314
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 155
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 236
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
    Left = 16
    Top = 64
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
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault'))
  end
end
