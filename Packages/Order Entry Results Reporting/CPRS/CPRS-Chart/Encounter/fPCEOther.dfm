inherited frmPCEOther: TfrmPCEOther
  Left = 451
  Top = 201
  ActiveControl = cboOther
  Caption = 'OtherItems'
  ClientHeight = 441
  ClientWidth = 304
  Constraints.MinHeight = 480
  Constraints.MinWidth = 320
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 320
  ExplicitHeight = 480
  TextHeight = 13
  object cboOther: TORComboBox [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 298
    Height = 411
    Margins.Bottom = 0
    Style = orcsSimple
    Align = alClient
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
    Text = ''
    FlatCheckBoxes = False
    OnChange = cboOtherChange
    OnDblClick = cboOtherDblClick
    CharsNeedMatch = 1
    ExplicitWidth = 265
    ExplicitHeight = 325
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 414
    Width = 304
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 328
    ExplicitWidth = 271
    object btnOK: TBitBtn
      AlignWithMargins = True
      Left = 145
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
      OnClick = cmdOKClick
      ExplicitLeft = 112
    end
    object btnCancel: TBitBtn
      AlignWithMargins = True
      Left = 226
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitLeft = 193
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboOther'
        'Status = stsDefault')
      (
        'Component = frmPCEOther'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault'))
  end
end
