inherited frmHFSearch: TfrmHFSearch
  Left = 286
  Top = 248
  Caption = 'Other Health Factors'
  ClientHeight = 441
  ClientWidth = 304
  Constraints.MinHeight = 480
  Constraints.MinWidth = 320
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 320
  ExplicitHeight = 480
  TextHeight = 13
  object splMain: TSplitter [0]
    Left = 0
    Top = 131
    Width = 304
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 355
  end
  object lblCat: TLabel [1]
    Left = 0
    Top = 0
    Width = 304
    Height = 13
    Align = alTop
    Caption = 'Category:'
    ExplicitWidth = 45
  end
  object cbxSearch: TORComboBox [2]
    Left = 0
    Top = 13
    Width = 304
    Height = 118
    Style = orcsSimple
    Align = alTop
    AutoSelect = True
    Caption = 'Category'
    Color = clWindow
    DropDownCount = 7
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    TabStop = True
    Text = ''
    FlatCheckBoxes = False
    OnChange = cbxSearchChange
    OnDblClick = tvSearchDblClick
    CharsNeedMatch = 1
    ExplicitWidth = 355
  end
  object tvSearch: TORTreeView [3]
    Left = 0
    Top = 134
    Width = 304
    Height = 280
    Align = alClient
    HideSelection = False
    Images = dmodShared.imgTemplates
    Indent = 23
    ReadOnly = True
    TabOrder = 1
    OnChange = tvSearchChange
    OnCollapsed = tvSearchGetImageIndex
    OnDblClick = tvSearchDblClick
    OnExpanded = tvSearchGetImageIndex
    OnGetImageIndex = tvSearchGetImageIndex
    OnGetSelectedIndex = tvSearchGetImageIndex
    Caption = 'Health Factors Category'
    NodePiece = 2
    ExplicitWidth = 355
    ExplicitHeight = 229
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 414
    Width = 304
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 363
    ExplicitWidth = 355
    DesignSize = (
      304
      27)
    object btnOK: TButton
      Left = 145
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&OK'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 196
    end
    object btnCancel: TButton
      Left = 225
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 276
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 176
    Data = (
      (
        'Component = cbxSearch'
        'Status = stsDefault')
      (
        'Component = tvSearch'
        'Status = stsDefault')
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
        'Component = frmHFSearch'
        'Status = stsDefault'))
  end
  object imgListHFtvSearch: TVA508ImageListLabeler
    Components = <
      item
        Component = tvSearch
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblHealthFactorLabels
    Left = 224
  end
end
