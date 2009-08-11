inherited frmOptionsPrimaryList: TfrmOptionsPrimaryList
  Left = 714
  Top = 143
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Primary List'
  ClientHeight = 225
  ClientWidth = 175
  HelpFile = 'CPRSWT.HLP'
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrimaryList: TLabel [0]
    Left = 10
    Top = 8
    Width = 145
    Height = 49
    AutoSize = False
    Caption = 'Select the list you wish to be your primary personal list.'
    WordWrap = True
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 191
    Width = 175
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnOK: TButton
      Left = 11
      Top = 7
      Width = 75
      Height = 22
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 91
      Top = 7
      Width = 75
      Height = 22
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object cboPrimary: TORComboBox [2]
    Left = 10
    Top = 64
    Width = 153
    Height = 113
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Select the list you wish to be your primary personal list.'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 0
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = cboPrimary'
        'Status = stsDefault')
      (
        'Component = frmOptionsPrimaryList'
        'Status = stsDefault'))
  end
end
