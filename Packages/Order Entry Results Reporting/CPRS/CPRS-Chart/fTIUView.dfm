inherited frmTIUView: TfrmTIUView
  Left = 357
  Top = 111
  BorderIcons = []
  Caption = 'List Selected Documents'
  ClientHeight = 436
  ClientWidth = 358
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 374
  ExplicitHeight = 474
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 358
    Height = 436
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblBeginDate: TLabel
      Left = 191
      Top = 100
      Width = 73
      Height = 13
      Caption = 'Beginning Date'
    end
    object lblEndDate: TLabel
      Left = 191
      Top = 153
      Width = 59
      Height = 13
      Caption = 'Ending Date'
    end
    object lblAuthor: TLabel
      Left = 10
      Top = 97
      Width = 31
      Height = 13
      Caption = 'Author'
    end
    object lblStatus: TLabel
      Left = 11
      Top = 5
      Width = 30
      Height = 13
      Caption = 'Status'
    end
    object lblMaxDocs: TLabel
      Left = 192
      Top = 5
      Width = 107
      Height = 13
      Caption = 'Max Number to Return'
    end
    object lblContains: TLabel
      Left = 195
      Top = 354
      Width = 44
      Height = 13
      Caption = 'Contains:'
    end
    object Bevel1: TBevel
      Left = 8
      Top = 349
      Width = 343
      Height = 48
    end
    object Bevel2: TBevel
      Left = 9
      Top = 205
      Width = 343
      Height = 4
    end
    object calBeginDate: TORDateBox
      Left = 191
      Top = 114
      Width = 156
      Height = 21
      TabOrder = 3
      DateOnly = False
      RequireTime = False
      Caption = 'Beginning Date'
    end
    object calEndDate: TORDateBox
      Left = 191
      Top = 168
      Width = 156
      Height = 21
      TabOrder = 4
      DateOnly = False
      RequireTime = False
      Caption = 'Ending Date'
    end
    object lstStatus: TORListBox
      Left = 10
      Top = 18
      Width = 168
      Height = 74
      ExtendedSelect = False
      ItemHeight = 13
      Items.Strings = (
        '1^Signed documents (all)'
        '2^Unsigned documents  '
        '3^Uncosigned documents'
        '4^Signed documents/author'
        '5^Signed documents/date range')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Status'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = lstStatusSelect
    end
    object cmdOK: TButton
      Left = 196
      Top = 407
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 10
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 278
      Top = 407
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 11
      OnClick = cmdCancelClick
    end
    object cboAuthor: TORComboBox
      Left = 10
      Top = 112
      Width = 169
      Height = 88
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Author'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
    end
    object edMaxDocs: TCaptionEdit
      Left = 192
      Top = 18
      Width = 156
      Height = 21
      MaxLength = 6
      TabOrder = 1
      Caption = 'Max Number to Return'
    end
    object txtKeyword: TCaptionEdit
      Left = 195
      Top = 369
      Width = 145
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Caption = 'Contains'
    end
    object grpListView: TGroupBox
      Left = 194
      Top = 214
      Width = 158
      Height = 130
      Caption = 'Sort Note List'
      TabOrder = 6
      object lblSortBy: TLabel
        Left = 11
        Top = 71
        Width = 37
        Height = 13
        Caption = 'Sort By:'
      end
      object radListSort: TRadioGroup
        Left = 8
        Top = 20
        Width = 142
        Height = 49
        Caption = 'Note List Sort Order'
        Items.Strings = (
          '&Ascending'
          '&Descending')
        TabOrder = 0
      end
      object cboSortBy: TORComboBox
        Left = 11
        Top = 85
        Width = 137
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Sort By'
        Color = clWindow
        DropDownCount = 8
        Items.Strings = (
          'R^Date of Note'
          'D^Title'
          'S^Subject'
          'A^Author'
          'L^Location')
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
        TabOrder = 1
        Text = ''
        CharsNeedMatch = 1
      end
      object ckShowSubject: TCheckBox
        Left = 11
        Top = 110
        Width = 131
        Height = 17
        Caption = 'Show subject in list'
        TabOrder = 2
      end
    end
    object grpTreeView: TGroupBox
      Left = 8
      Top = 214
      Width = 175
      Height = 130
      Caption = 'Note Tree View'
      TabOrder = 5
      object lblGroupBy: TOROffsetLabel
        Left = 9
        Top = 79
        Width = 49
        Height = 15
        Caption = 'Group By:'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object cboGroupBy: TORComboBox
        Left = 9
        Top = 93
        Width = 153
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Group By'
        Color = clWindow
        DropDownCount = 8
        Items.Strings = (
          'D^Visit Date'
          'L^Location'
          'T^Title'
          'A^Author')
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
        TabOrder = 1
        Text = ''
        CharsNeedMatch = 1
      end
      object radTreeSort: TRadioGroup
        Left = 9
        Top = 20
        Width = 155
        Height = 49
        Caption = 'Note Tree View Sort Order'
        Items.Strings = (
          '&Chronological'
          '&Reverse chronological')
        TabOrder = 0
      end
    end
    object cmdClear: TButton
      Left = 8
      Top = 407
      Width = 146
      Height = 21
      Caption = 'Clear Sort/Group/Search'
      TabOrder = 9
      OnClick = cmdClearClick
    end
    object grpWhereEitherOf: TGroupBox
      Left = 16
      Top = 352
      Width = 169
      Height = 41
      Caption = 'Where either of:'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      object ckTitle: TCheckBox
        Left = 49
        Top = 16
        Width = 50
        Height = 17
        Caption = 'Title'
        TabOrder = 0
      end
      object ckSubject: TCheckBox
        Left = 102
        Top = 16
        Width = 65
        Height = 17
        Caption = 'Subject'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = calBeginDate'
        'Text = Beginning Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calEndDate'
        'Text = Ending Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = lstStatus'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = edMaxDocs'
        'Status = stsDefault')
      (
        'Component = txtKeyword'
        'Status = stsDefault')
      (
        'Component = grpListView'
        'Status = stsDefault')
      (
        'Component = radListSort'
        'Status = stsDefault')
      (
        'Component = cboSortBy'
        'Status = stsDefault')
      (
        'Component = ckShowSubject'
        'Status = stsDefault')
      (
        'Component = grpTreeView'
        'Status = stsDefault')
      (
        'Component = cboGroupBy'
        'Status = stsDefault')
      (
        'Component = radTreeSort'
        'Status = stsDefault')
      (
        'Component = cmdClear'
        'Status = stsDefault')
      (
        'Component = grpWhereEitherOf'
        'Status = stsDefault')
      (
        'Component = ckTitle'
        'Status = stsDefault')
      (
        'Component = ckSubject'
        'Status = stsDefault')
      (
        'Component = frmTIUView'
        'Status = stsDefault'))
  end
end
