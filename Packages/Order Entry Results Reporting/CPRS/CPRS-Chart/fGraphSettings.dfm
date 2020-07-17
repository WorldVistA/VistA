inherited frmGraphSettings: TfrmGraphSettings
  Left = 109
  Top = 60
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Graph Settings'
  ClientHeight = 404
  ClientWidth = 539
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 545
  ExplicitHeight = 434
  DesignSize = (
    539
    404)
  PixelsPerInch = 120
  TextHeight = 16
  object lblMinGraphHeight: TLabel [0]
    Left = 383
    Top = 63
    Width = 138
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Minimum Graph Height:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblMaxGraphs: TLabel [1]
    Left = 383
    Top = 9
    Width = 137
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Max Graphs in Display:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblOptions: TLabel [2]
    Left = 220
    Top = 5
    Width = 49
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Options:'
    ParentShowHint = False
    ShowHint = False
  end
  object bvlBase: TBevel [3]
    Left = 16
    Top = 353
    Width = 507
    Height = 3
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object lblSources: TLabel [4]
    Left = 20
    Top = 5
    Width = 118
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Sources Displayed:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblConversions: TLabel [5]
    Left = 265
    Top = 350
    Width = 57
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Functions'
    ParentShowHint = False
    ShowHint = False
    Visible = False
  end
  object lblMaxSelect: TLabel [6]
    Left = 383
    Top = 114
    Width = 118
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Max Items to Select:'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lblShow: TLabel [7]
    Left = 242
    Top = 287
    Width = 88
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taRightJustify
    Caption = 'Show Defaults:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblSave: TLabel [8]
    Left = 232
    Top = 326
    Width = 98
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taRightJustify
    Caption = 'Save as Default:'
    ParentShowHint = False
    ShowHint = False
  end
  object bvlDefaults: TBevel [9]
    Left = 217
    Top = 272
    Width = 305
    Height = 2
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object lblOptionsInfo: TLabel [10]
    Left = 16
    Top = 366
    Width = 302
    Height = 32
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Settings saved as your defaults are applied to new graphs.'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lblMaxGraphsRef: TLabel [11]
    Left = 460
    Top = 28
    Width = 70
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    ParentShowHint = False
    ShowHint = False
  end
  object lblMinGraphHeightRef: TLabel [12]
    Left = 460
    Top = 85
    Width = 70
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    ParentShowHint = False
    ShowHint = False
  end
  object lblMaxSelectRef: TLabel [13]
    Left = 460
    Top = 140
    Width = 70
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    ParentShowHint = False
    ShowHint = False
  end
  object bvlMid: TBevel [14]
    Left = 217
    Top = 314
    Width = 305
    Height = 2
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object lblOutpatient: TLabel [15]
    Left = 383
    Top = 166
    Width = 140
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Outpatient Date Default:'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lblInpatient: TLabel [16]
    Left = 383
    Top = 219
    Width = 130
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Inpatient Date Default:'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lstATypes: TListBox [17]
    Left = 311
    Top = 4
    Width = 56
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 21
    Visible = False
  end
  object lstSourcesCopy: TListBox [18]
    Left = 151
    Top = 5
    Width = 56
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Sorted = True
    TabOrder = 20
    Visible = False
  end
  object chklstOptions: TCheckListBox [19]
    Left = 214
    Top = 28
    Width = 148
    Height = 237
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    OnClickCheck = chklstOptionsClickCheck
    ParentShowHint = False
    ShowHint = False
    Sorted = True
    TabOrder = 3
  end
  object txtMinGraphHeight: TEdit [20]
    Left = 383
    Top = 82
    Width = 50
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ParentShowHint = False
    ShowHint = False
    TabOrder = 5
    Text = '90'
    OnChange = txtMinGraphHeightChange
    OnExit = txtMinGraphHeightExit
    OnKeyPress = txtMinGraphHeightKeyPress
  end
  object txtMaxGraphs: TEdit [21]
    Left = 383
    Top = 28
    Width = 50
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    Text = '5'
    OnChange = txtMaxGraphsChange
    OnExit = txtMaxGraphsExit
    OnKeyPress = txtMaxGraphsKeyPress
  end
  object spnMinGraphHeight: TUpDown [22]
    Left = 433
    Top = 82
    Width = 19
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtMinGraphHeight
    Min = 10
    Max = 1000
    ParentShowHint = False
    Position = 90
    ShowHint = False
    TabOrder = 17
    OnClick = spnMinGraphHeightClick
  end
  object spnMaxGraphs: TUpDown [23]
    Left = 433
    Top = 28
    Width = 19
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtMaxGraphs
    Min = 1
    Max = 20
    ParentShowHint = False
    Position = 5
    ShowHint = False
    TabOrder = 16
    OnClick = spnMaxGraphsClick
  end
  object btnClose: TButton [24]
    Left = 431
    Top = 363
    Width = 92
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Close'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 15
    OnClick = btnCloseClick
  end
  object lstSources: TCheckListBox [25]
    Left = 21
    Top = 28
    Width = 188
    Height = 282
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ParentShowHint = False
    ShowHint = False
    Sorted = True
    TabOrder = 0
  end
  object btnAll: TButton [26]
    Left = 22
    Top = 321
    Width = 80
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'All'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    OnClick = btnAllClick
  end
  object brnClear: TButton [27]
    Left = 127
    Top = 321
    Width = 80
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Clear'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    OnClick = btnAllClick
  end
  object btnPersonal: TButton [28]
    Left = 341
    Top = 282
    Width = 80
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Personal'
    TabOrder = 10
    OnClick = btnPublicClick
  end
  object cboConversions: TORComboBox [29]
    Left = 281
    Top = 363
    Width = 142
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    Items.Strings = (
      '<none>'
      'Standard Deviations'
      'Inverse Values')
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    ParentShowHint = False
    ShowHint = False
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 19
    Text = ''
    Visible = False
    CharsNeedMatch = 1
  end
  object txtMaxSelect: TEdit [30]
    Left = 383
    Top = 133
    Width = 50
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ParentShowHint = False
    ShowHint = False
    TabOrder = 6
    Text = '100'
    OnChange = txtMaxSelectChange
    OnExit = txtMaxSelectExit
    OnKeyPress = txtMaxSelectKeyPress
  end
  object spnMaxSelect: TUpDown [31]
    Left = 433
    Top = 133
    Width = 19
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtMaxSelect
    Min = 1
    Max = 1000
    ParentShowHint = False
    Position = 100
    ShowHint = False
    TabOrder = 18
    OnClick = spnMaxSelectClick
  end
  object btnPublic: TButton [32]
    Left = 443
    Top = 282
    Width = 80
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Public'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 11
    OnClick = btnPublicClick
  end
  object btnPersonalSave: TButton [33]
    Left = 341
    Top = 321
    Width = 80
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Personal'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 13
    OnClick = SaveClick
  end
  object btnPublicSave: TButton [34]
    Left = 443
    Top = 321
    Width = 80
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Public'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 14
    OnClick = SaveClick
  end
  object lstOptions: TListBox [35]
    Left = 353
    Top = 363
    Width = 70
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Items.Strings = (
      '3D^A'
      'Clear Background^B'
      'Dates^C'
      'Fixed Date Range^M'
      'Gradient^D'
      'Hints^E'
      'Legend^F'
      'Lines^G'
      'Sort by Type^H'
      'Stay on Top^I'
      'Values^J'
      'Zoom, Horizontal^K'
      'Zoom, Vertical^L')
    Sorted = True
    TabOrder = 22
    Visible = False
  end
  object cboDateRangeOutpatient: TORComboBox [36]
    Left = 383
    Top = 183
    Width = 141
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 9
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 7
    TabStop = True
    Text = ''
    CharsNeedMatch = 1
  end
  object cboDateRangeInpatient: TORComboBox [37]
    Left = 383
    Top = 239
    Width = 141
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 9
    Items.Strings = (
      'S^Date Range...'
      '1^Today'
      '2^One Week'
      '3^Two Weeks'
      '4^One Month'
      '5^Six Months'
      '6^One Year'
      '7^Two Years'
      '8^All Results')
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 8
    TabStop = True
    Text = ''
    CharsNeedMatch = 1
  end
  object lbl508Show: TVA508StaticText [38]
    Name = 'lbl508Show'
    Left = 241
    Top = 287
    Width = 90
    Height = 18
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'Show Defaults:'
    Enabled = False
    TabOrder = 9
    Visible = False
    ShowAccelChar = True
  end
  object lbl508Save: TVA508StaticText [39]
    Name = 'lbl508Save'
    Left = 233
    Top = 326
    Width = 100
    Height = 18
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'Save as Default:'
    Enabled = False
    TabOrder = 12
    Visible = False
    ShowAccelChar = True
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstATypes'
        'Status = stsDefault')
      (
        'Component = lstSourcesCopy'
        'Status = stsDefault')
      (
        'Component = chklstOptions'
        'Status = stsDefault')
      (
        'Component = txtMinGraphHeight'
        'Label = lblMinGraphHeight'
        'Status = stsOK')
      (
        'Component = txtMaxGraphs'
        'Label = lblMaxGraphs'
        'Status = stsOK')
      (
        'Component = spnMinGraphHeight'
        'Status = stsDefault')
      (
        'Component = spnMaxGraphs'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = lstSources'
        'Status = stsDefault')
      (
        'Component = btnAll'
        'Status = stsDefault')
      (
        'Component = brnClear'
        'Status = stsDefault')
      (
        'Component = btnPersonal'
        'Status = stsDefault')
      (
        'Component = cboConversions'
        'Status = stsDefault')
      (
        'Component = txtMaxSelect'
        'Label = lblMaxSelect'
        'Status = stsOK')
      (
        'Component = spnMaxSelect'
        'Status = stsDefault')
      (
        'Component = btnPublic'
        'Status = stsDefault')
      (
        'Component = btnPersonalSave'
        'Status = stsDefault')
      (
        'Component = btnPublicSave'
        'Status = stsDefault')
      (
        'Component = lstOptions'
        'Status = stsDefault')
      (
        'Component = frmGraphSettings'
        'Status = stsDefault')
      (
        'Component = cboDateRangeOutpatient'
        'Label = lblOutpatient'
        'Status = stsOK')
      (
        'Component = cboDateRangeInpatient'
        'Label = lblInpatient'
        'Status = stsOK')
      (
        'Component = lbl508Show'
        'Status = stsDefault')
      (
        'Component = lbl508Save'
        'Status = stsDefault'))
  end
end
