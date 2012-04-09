inherited frmPCEOther: TfrmPCEOther
  Left = 451
  Top = 201
  ActiveControl = cboOther
  Caption = 'OtherItems'
  ClientHeight = 313
  ClientWidth = 271
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 279
  ExplicitHeight = 340
  PixelsPerInch = 96
  TextHeight = 13
  object cmdCancel: TButton [0]
    Left = 190
    Top = 287
    Width = 75
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object cmdOK: TButton [1]
    Left = 110
    Top = 287
    Width = 75
    Height = 22
    Caption = 'OK'
    Enabled = False
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cboOther: TORComboBox [2]
    Left = 8
    Top = 8
    Width = 257
    Height = 273
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Other Items'
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
    OnChange = cboOtherChange
    OnDblClick = cboOtherDblClick
    CharsNeedMatch = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cboOther'
        'Status = stsDefault')
      (
        'Component = frmPCEOther'
        'Status = stsDefault'))
  end
end
