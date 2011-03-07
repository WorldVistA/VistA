inherited frmIVRoutes: TfrmIVRoutes
  Left = 0
  Top = 0
  Caption = 'Expanded Med Route List'
  ClientHeight = 339
  ClientWidth = 222
  Constraints.MinHeight = 360
  Constraints.MinWidth = 220
  Font.Name = 'Tahoma'
  OldCreateOrder = False
  OnCreate = FormCreate
  ExplicitWidth = 230
  ExplicitHeight = 366
  DesignSize = (
    222
    339)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 220
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object cboAllIVRoutes: TORComboBox
      Left = 24
      Top = 16
      Width = 161
      Height = 217
      Style = orcsSimple
      AutoSelect = True
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
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
  end
  object pnlBottom: TORAutoPanel [1]
    Left = 0
    Top = 255
    Width = 218
    Height = 82
    BevelOuter = bvNone
    TabOrder = 1
    object BtnOK: TButton
      Left = 110
      Top = 24
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object btnCancel: TButton
      Left = 29
      Top = 24
      Width = 75
      Height = 25
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = cboAllIVRoutes'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = BtnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmIVRoutes'
        'Status = stsDefault'))
  end
end
