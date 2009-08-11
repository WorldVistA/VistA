inherited frmNotesByAuthor: TfrmNotesByAuthor
  Left = 473
  Top = 272
  BorderIcons = []
  Caption = 'List Signed Notes by Author'
  ClientHeight = 205
  ClientWidth = 308
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 316
  ExplicitHeight = 232
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 308
    Height = 205
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblAuthor: TLabel
      Left = 8
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Author'
    end
    object radSort: TRadioGroup
      Left = 8
      Top = 148
      Width = 212
      Height = 49
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (oldest first)'
        '&Descending (newest first)')
      TabOrder = 1
    end
    object cboAuthor: TORComboBox
      Left = 8
      Top = 22
      Width = 212
      Height = 118
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Author'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
    end
    object cmdOK: TButton
      Left = 228
      Top = 22
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 228
      Top = 49
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmNotesByAuthor'
        'Status = stsDefault'))
  end
end
