inherited frmGraphSettings: TfrmGraphSettings
  Left = 109
  Top = 60
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Graph Settings'
  ClientHeight = 318
  ClientWidth = 438
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 444
  ExplicitHeight = 343
  DesignSize = (
    438
    318)
  PixelsPerInch = 96
  TextHeight = 13
  object lblMinGraphHeight: TLabel [0]
    Left = 311
    Top = 51
    Width = 110
    Height = 13
    Caption = 'Minimum Graph Height:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblMaxGraphs: TLabel [1]
    Left = 311
    Top = 7
    Width = 108
    Height = 13
    Caption = 'Max Graphs in Display:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblOptions: TLabel [2]
    Left = 179
    Top = 4
    Width = 39
    Height = 13
    Caption = 'Options:'
    ParentShowHint = False
    ShowHint = False
  end
  object bvlBase: TBevel [3]
    Left = 13
    Top = 287
    Width = 412
    Height = 2
  end
  object lblSources: TLabel [4]
    Left = 16
    Top = 4
    Width = 91
    Height = 13
    Caption = 'Sources Displayed:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblConversions: TLabel [5]
    Left = 215
    Top = 284
    Width = 46
    Height = 13
    Caption = 'Functions'
    ParentShowHint = False
    ShowHint = False
    Visible = False
  end
  object lblMaxSelect: TLabel [6]
    Left = 311
    Top = 93
    Width = 96
    Height = 13
    Caption = 'Max Items to Select:'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lblShow: TLabel [7]
    Left = 196
    Top = 233
    Width = 72
    Height = 13
    Alignment = taRightJustify
    Caption = 'Show Defaults:'
    ParentShowHint = False
    ShowHint = False
  end
  object lblSave: TLabel [8]
    Left = 189
    Top = 265
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Save as Default:'
    ParentShowHint = False
    ShowHint = False
  end
  object bvlDefaults: TBevel [9]
    Left = 176
    Top = 221
    Width = 248
    Height = 2
  end
  object lblOptionsInfo: TLabel [10]
    Left = 13
    Top = 297
    Width = 275
    Height = 13
    Caption = 'Settings saved as your defaults are applied to new graphs.'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lblMaxGraphsRef: TLabel [11]
    Left = 374
    Top = 23
    Width = 57
    Height = 17
    AutoSize = False
    ParentShowHint = False
    ShowHint = False
  end
  object lblMinGraphHeightRef: TLabel [12]
    Left = 374
    Top = 69
    Width = 57
    Height = 17
    AutoSize = False
    ParentShowHint = False
    ShowHint = False
  end
  object lblMaxSelectRef: TLabel [13]
    Left = 374
    Top = 114
    Width = 57
    Height = 17
    AutoSize = False
    ParentShowHint = False
    ShowHint = False
  end
  object bvlMid: TBevel [14]
    Left = 176
    Top = 255
    Width = 248
    Height = 2
  end
  object lblOutpatient: TLabel [15]
    Left = 311
    Top = 135
    Width = 115
    Height = 13
    Caption = 'Outpatient Date Default:'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lblInpatient: TLabel [16]
    Left = 311
    Top = 178
    Width = 107
    Height = 13
    Caption = 'Inpatient Date Default:'
    ParentShowHint = False
    ShowHint = False
    WordWrap = True
  end
  object lstATypes: TListBox [17]
    Left = 253
    Top = 3
    Width = 45
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 17
    Visible = False
  end
  object lstSourcesCopy: TListBox [18]
    Left = 123
    Top = 4
    Width = 45
    Height = 16
    ItemHeight = 13
    Sorted = True
    TabOrder = 16
    Visible = False
  end
  object chklstOptions: TCheckListBox [19]
    Left = 174
    Top = 23
    Width = 120
    Height = 192
    OnClickCheck = chklstOptionsClickCheck
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = False
    Sorted = True
    TabOrder = 1
  end
  object txtMinGraphHeight: TEdit [20]
    Left = 311
    Top = 67
    Width = 41
    Height = 21
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    Text = '90'
    OnChange = txtMinGraphHeightChange
    OnExit = txtMinGraphHeightExit
    OnKeyPress = txtMinGraphHeightKeyPress
  end
  object txtMaxGraphs: TEdit [21]
    Left = 311
    Top = 23
    Width = 41
    Height = 21
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    Text = '5'
    OnChange = txtMaxGraphsChange
    OnExit = txtMaxGraphsExit
    OnKeyPress = txtMaxGraphsKeyPress
  end
  object spnMinGraphHeight: TUpDown [22]
    Left = 352
    Top = 67
    Width = 15
    Height = 21
    Associate = txtMinGraphHeight
    Min = 10
    Max = 1000
    ParentShowHint = False
    Position = 90
    ShowHint = False
    TabOrder = 5
    OnClick = spnMinGraphHeightClick
  end
  object spnMaxGraphs: TUpDown [23]
    Left = 352
    Top = 23
    Width = 15
    Height = 21
    Associate = txtMaxGraphs
    Min = 1
    Max = 20
    ParentShowHint = False
    Position = 5
    ShowHint = False
    TabOrder = 3
    OnClick = spnMaxGraphsClick
  end
  object btnClose: TButton [24]
    Left = 350
    Top = 295
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Close'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 15
    OnClick = btnCloseClick
  end
  object lstSources: TCheckListBox [25]
    Left = 17
    Top = 23
    Width = 153
    Height = 229
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = False
    Sorted = True
    TabOrder = 0
  end
  object btnAll: TButton [26]
    Left = 18
    Top = 261
    Width = 65
    Height = 21
    Caption = 'All'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 9
    OnClick = btnAllClick
  end
  object brnClear: TButton [27]
    Left = 103
    Top = 261
    Width = 65
    Height = 21
    Cancel = True
    Caption = 'Clear'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 10
    OnClick = btnAllClick
  end
  object btnPersonal: TButton [28]
    Left = 277
    Top = 229
    Width = 65
    Height = 21
    Cancel = True
    Caption = 'Personal'
    TabOrder = 11
    OnClick = btnPublicClick
  end
  object cboConversions: TORComboBox [29]
    Left = 228
    Top = 295
    Width = 116
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    Items.Strings = (
      '<none>'
      'Standard Deviations'
      'Inverse Values')
    ItemHeight = 13
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
    TabOrder = 8
    Visible = False
    CharsNeedMatch = 1
  end
  object txtMaxSelect: TEdit [30]
    Left = 311
    Top = 108
    Width = 41
    Height = 21
    ParentShowHint = False
    ShowHint = False
    TabOrder = 6
    Text = '100'
    OnChange = txtMaxSelectChange
    OnExit = txtMaxSelectExit
    OnKeyPress = txtMaxSelectKeyPress
  end
  object spnMaxSelect: TUpDown [31]
    Left = 352
    Top = 108
    Width = 15
    Height = 21
    Associate = txtMaxSelect
    Min = 1
    Max = 1000
    ParentShowHint = False
    Position = 100
    ShowHint = False
    TabOrder = 7
    OnClick = spnMaxSelectClick
  end
  object btnPublic: TButton [32]
    Left = 360
    Top = 229
    Width = 65
    Height = 21
    Cancel = True
    Caption = 'Public'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 12
    OnClick = btnPublicClick
  end
  object btnPersonalSave: TButton [33]
    Left = 277
    Top = 261
    Width = 65
    Height = 21
    Cancel = True
    Caption = 'Personal'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 13
    OnClick = SaveClick
  end
  object btnPublicSave: TButton [34]
    Left = 360
    Top = 261
    Width = 65
    Height = 21
    Cancel = True
    Caption = 'Public'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 14
    OnClick = SaveClick
  end
  object lstOptions: TListBox [35]
    Left = 287
    Top = 295
    Width = 57
    Height = 17
    ItemHeight = 13
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
    TabOrder = 18
    Visible = False
  end
  object cboDateRangeOutpatient: TORComboBox [36]
    Left = 311
    Top = 149
    Width = 115
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Color = clWindow
    DropDownCount = 9
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
    TabOrder = 19
    TabStop = True
    CharsNeedMatch = 1
  end
  object cboDateRangeInpatient: TORComboBox [37]
    Left = 311
    Top = 194
    Width = 115
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
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
    TabOrder = 20
    TabStop = True
    CharsNeedMatch = 1
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
        'Status = stsDefault')
      (
        'Component = txtMaxGraphs'
        'Status = stsDefault')
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
        'Status = stsDefault')
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
        'Status = stsDefault')
      (
        'Component = cboDateRangeInpatient'
        'Status = stsDefault'))
  end
end
