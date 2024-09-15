inherited frmTIUView: TfrmTIUView
  Left = 357
  Top = 111
  BorderIcons = []
  Caption = 'List Selected Documents'
  ClientHeight = 526
  ClientWidth = 393
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 409
  ExplicitHeight = 564
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 393
    Height = 487
    Align = alClient
    TabOrder = 0
    ExplicitTop = -3
    ExplicitHeight = 647
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 4
      Top = 241
      Width = 385
      Height = 4
      Align = alTop
      ExplicitLeft = 9
      ExplicitTop = 205
      ExplicitWidth = 343
    end
    object pnlStatus: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 385
      Height = 99
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlStatus'
      ShowCaption = False
      TabOrder = 5
      ExplicitTop = 544
      ExplicitWidth = 417
      object Panel2: TPanel
        Left = 201
        Top = 0
        Width = 184
        Height = 99
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 0
        ExplicitLeft = 136
        ExplicitTop = 56
        ExplicitWidth = 185
        ExplicitHeight = 41
        object lblMaxDocs: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 178
          Height = 16
          Align = alTop
          Caption = 'Max Number to Return'
          ExplicitLeft = 119
          ExplicitTop = 5
          ExplicitWidth = 132
        end
        object edMaxDocs: TCaptionEdit
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 178
          Height = 24
          Align = alTop
          MaxLength = 6
          TabOrder = 0
          Caption = 'Max Number to Return'
          ExplicitLeft = 95
          ExplicitTop = 18
          ExplicitWidth = 156
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 201
        Height = 99
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 1
        ExplicitLeft = -6
        ExplicitTop = -2
        ExplicitHeight = 150
        object lblStatus: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 195
          Height = 16
          Align = alTop
          Caption = 'Status'
          ExplicitLeft = 10
          ExplicitTop = 5
          ExplicitWidth = 37
        end
        object lstStatus: TORListBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 195
          Height = 71
          Align = alClient
          ExtendedSelect = False
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
          ExplicitLeft = 10
          ExplicitTop = 18
          ExplicitWidth = 168
          ExplicitHeight = 74
        end
      end
    end
    object pnlAuthor: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 109
      Width = 385
      Height = 126
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 6
      ExplicitTop = 517
      ExplicitWidth = 417
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 201
        Height = 126
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 0
        object lblAuthor: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 195
          Height = 16
          Align = alTop
          Caption = 'Author'
          ExplicitLeft = 10
          ExplicitTop = 97
          ExplicitWidth = 38
        end
        object cboAuthor: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 195
          Height = 98
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Author'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = True
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          OnNeedData = cboAuthorNeedData
          CharsNeedMatch = 1
          ExplicitLeft = 16
          ExplicitTop = 38
          ExplicitWidth = 169
          ExplicitHeight = 88
        end
      end
      object Panel4: TPanel
        Left = 201
        Top = 0
        Width = 184
        Height = 126
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 1
        ExplicitLeft = 8
        ExplicitWidth = 185
        object lblBeginDate: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 178
          Height = 16
          Align = alTop
          Caption = 'Beginning Date'
          ExplicitLeft = 140
          ExplicitTop = 100
          ExplicitWidth = 92
        end
        object lblEndDate: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 55
          Width = 178
          Height = 16
          Align = alTop
          Caption = 'Ending Date'
          ExplicitLeft = 158
          ExplicitTop = 110
          ExplicitWidth = 74
        end
        object calBeginDate: TORDateBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 178
          Height = 24
          Align = alTop
          TabOrder = 0
          DateOnly = False
          RequireTime = False
          Caption = 'Beginning Date'
          ExplicitLeft = 76
          ExplicitTop = 102
          ExplicitWidth = 156
        end
        object calEndDate: TORDateBox
          Left = 0
          Top = 74
          Width = 184
          Height = 24
          Align = alTop
          TabOrder = 1
          DateOnly = False
          RequireTime = False
          Caption = 'Ending Date'
          ExplicitLeft = 76
          ExplicitTop = 102
          ExplicitWidth = 156
        end
      end
    end
    object pnlOptions: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 251
      Width = 385
      Height = 171
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlOptions'
      ShowCaption = False
      TabOrder = 7
      ExplicitTop = 472
      object grpTreeView: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 195
        Height = 165
        Align = alLeft
        Caption = 'Note Tree View'
        TabOrder = 0
        ExplicitHeight = 112
        object lblGroupBy: TOROffsetLabel
          AlignWithMargins = True
          Left = 5
          Top = 87
          Width = 185
          Height = 16
          Align = alTop
          Caption = 'Group By:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitTop = 105
        end
        object cboGroupBy: TORComboBox
          AlignWithMargins = True
          Left = 5
          Top = 109
          Width = 185
          Height = 24
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = 'Group By'
          Color = clWindow
          DropDownCount = 8
          Items.Strings = (
            'D^Visit Date'
            'L^Location'
            'T^Title'
            'A^Author')
          ItemHeight = 16
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
          ExplicitLeft = 7
          ExplicitTop = 130
        end
        object radTreeSort: TRadioGroup
          AlignWithMargins = True
          Left = 5
          Top = 21
          Width = 185
          Height = 60
          Align = alTop
          Caption = 'Note Tree View Sort Order'
          Items.Strings = (
            '&Chronological'
            '&Reverse chronological')
          TabOrder = 0
        end
      end
      object grpListView: TGroupBox
        AlignWithMargins = True
        Left = 204
        Top = 3
        Width = 178
        Height = 165
        Align = alClient
        Caption = 'Sort Note List'
        TabOrder = 1
        ExplicitLeft = 194
        ExplicitTop = 17
        ExplicitWidth = 158
        ExplicitHeight = 130
        object lblSortBy: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 87
          Width = 168
          Height = 16
          Align = alTop
          Caption = 'Sort By:'
          ExplicitLeft = 3
          ExplicitTop = 75
          ExplicitWidth = 46
        end
        object radListSort: TRadioGroup
          AlignWithMargins = True
          Left = 5
          Top = 21
          Width = 168
          Height = 60
          Align = alTop
          Caption = 'Note List Sort Order'
          Items.Strings = (
            '&Ascending'
            '&Descending')
          TabOrder = 0
        end
        object cboSortBy: TORComboBox
          AlignWithMargins = True
          Left = 5
          Top = 109
          Width = 168
          Height = 24
          Style = orcsDropDown
          Align = alTop
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
          ItemHeight = 16
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
          ExplicitLeft = 11
          ExplicitTop = 85
          ExplicitWidth = 137
        end
        object ckShowSubject: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 143
          Width = 168
          Height = 17
          Align = alBottom
          Caption = 'Show subject in list'
          TabOrder = 2
          ExplicitLeft = 11
          ExplicitTop = 110
          ExplicitWidth = 131
        end
      end
    end
    object pnlOp: TPanel
      Left = 1
      Top = 425
      Width = 391
      Height = 62
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlOptions2'
      ShowCaption = False
      TabOrder = 8
      ExplicitTop = 592
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 204
        Height = 56
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel5'
        ShowCaption = False
        TabOrder = 0
        ExplicitLeft = 0
        ExplicitTop = -2
        ExplicitHeight = 110
        object grpWhereEitherOf: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 198
          Height = 49
          Align = alTop
          Caption = 'Where either of:'
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 0
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 204
          object ckTitle: TCheckBox
            AlignWithMargins = True
            Left = 5
            Top = 21
            Width = 50
            Height = 23
            Align = alLeft
            Caption = 'Title'
            TabOrder = 0
            ExplicitLeft = 49
            ExplicitTop = 16
            ExplicitHeight = 17
          end
          object ckSubject: TCheckBox
            AlignWithMargins = True
            Left = 61
            Top = 21
            Width = 65
            Height = 23
            Align = alLeft
            Caption = 'Subject'
            TabOrder = 1
            ExplicitLeft = 102
            ExplicitTop = 16
            ExplicitHeight = 17
          end
        end
      end
      object Panel6: TPanel
        Left = 210
        Top = 0
        Width = 181
        Height = 62
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel6'
        ShowCaption = False
        TabOrder = 1
        ExplicitTop = -2
        ExplicitHeight = 110
        object lblContains: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 175
          Height = 16
          Align = alTop
          Caption = 'Contains:'
          ExplicitLeft = 126
          ExplicitTop = 94
          ExplicitWidth = 55
        end
        object txtKeyword: TCaptionEdit
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 175
          Height = 24
          Align = alTop
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Caption = 'Contains'
          ExplicitLeft = 36
          ExplicitTop = 86
          ExplicitWidth = 145
        end
      end
    end
  end
  object pnlButtons: TPanel [1]
    Left = 0
    Top = 487
    Width = 393
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 470
    ExplicitWidth = 454
    object cmdClear: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 182
      Height = 33
      Align = alLeft
      Caption = 'Clear Sort/Group/Search'
      TabOrder = 0
      OnClick = cmdClearClick
      ExplicitTop = 6
      ExplicitHeight = 35
    end
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 240
      Top = 3
      Width = 72
      Height = 33
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
      ExplicitLeft = 196
      ExplicitTop = 20
      ExplicitHeight = 21
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 318
      Top = 3
      Width = 72
      Height = 33
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
      ExplicitLeft = 278
      ExplicitTop = 20
      ExplicitHeight = 21
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 328
    Top = 40
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
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlStatus'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = pnlAuthor'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = pnlOptions'
        'Status = stsDefault')
      (
        'Component = pnlOp'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault'))
  end
end
