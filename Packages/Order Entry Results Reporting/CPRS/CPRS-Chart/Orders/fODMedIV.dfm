inherited frmODMedIV: TfrmODMedIV
  Left = 246
  Top = 256
  Width = 1024
  Height = 876
  Caption = 'Infusion Order'
  Color = clWindow
  Constraints.MinHeight = 768
  Constraints.MinWidth = 1024
  DoubleBuffered = True
  Font.Height = -19
  ExplicitWidth = 1024
  ExplicitHeight = 876
  PixelsPerInch = 96
  TextHeight = 24
  inherited pnlMessage: TPanel [0]
    Left = 25
    Top = 754
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 0
    ExplicitLeft = 25
    ExplicitTop = 754
    inherited imgMessage: TImage
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
    inherited memMessage: TRichEdit
      Left = 55
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 55
    end
  end
  inherited memOrder: TCaptionMemo [1]
    AlignWithMargins = True
    Left = 25
    Top = 683
    Width = 653
    Height = 61
    Margins.Left = 6
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 1
    ExplicitLeft = 25
    ExplicitTop = 683
    ExplicitWidth = 653
    ExplicitHeight = 61
  end
  object pnlTop: TGridPanel [2]
    AlignWithMargins = True
    Left = 9
    Top = 9
    Width = 776
    Height = 664
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        Value = 23.053987741197300000
      end
      item
        SizeStyle = ssAbsolute
        Value = 70.000000000000000000
      end
      item
        Value = 15.450600961743430000
      end
      item
        Value = 15.420089038335150000
      end
      item
        Value = 15.389378461447130000
      end
      item
        Value = 15.358472369495790000
      end
      item
        Value = 15.327471427781210000
      end
      item
        SizeStyle = ssAbsolute
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 4
        Control = pgctrlSolutionsAndAdditives
        Row = 0
        RowSpan = 4
      end
      item
        Column = 4
        ColumnSpan = 5
        Control = pnlTopRightTop
        Row = 0
        RowSpan = 2
      end
      item
        Column = 8
        Control = cmdRemove
        Row = 2
      end
      item
        Column = 4
        ColumnSpan = 5
        Control = pnlComments
        Row = 3
      end
      item
        Column = 0
        Control = lblRoute
        Row = 4
      end
      item
        Column = 1
        Control = txtAllIVRoutes
        Row = 4
      end
      item
        Column = 2
        Control = lblType
        Row = 4
      end
      item
        Column = 3
        Control = lblTypeHelp
        Row = 4
      end
      item
        Column = 4
        Control = lblSchedule
        Row = 4
      end
      item
        Column = 5
        ColumnSpan = 2
        Control = txtNSS
        Row = 4
      end
      item
        Column = 7
        ColumnSpan = 2
        Control = lblInfusionRate
        Row = 4
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = cboRoute
        Row = 5
      end
      item
        Column = 2
        ColumnSpan = 2
        Control = cboType
        Row = 5
      end
      item
        Column = 4
        ColumnSpan = 2
        Control = cboSchedule
        Row = 5
      end
      item
        Column = 6
        Control = chkPRN
        Row = 5
      end
      item
        Column = 7
        Control = txtRate
        Row = 5
      end
      item
        Column = 8
        Control = cboInfusionTime
        Row = 5
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = lblPriority
        Row = 6
      end
      item
        Column = 2
        ColumnSpan = 3
        Control = lblLimit
        Row = 6
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = cboPriority
        Row = 7
      end
      item
        Column = 2
        Control = txtXDuration
        Row = 7
      end
      item
        Column = 3
        Control = cboDuration
        Row = 7
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = lblFirstDose
        Row = 9
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = lblAdminTime
        Row = 10
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = chkDoseNow
        Row = 8
      end
      item
        Column = 0
        ColumnSpan = 6
        Control = lbl508Required
        Row = 12
      end
      item
        Column = 0
        Control = Label1
        Row = 13
      end
      item
        Column = 5
        ColumnSpan = 3
        Control = cboIndication
        Row = 7
      end
      item
        Column = 5
        Control = lblIndications
        Row = 6
      end>
    RowCollection = <
      item
        Value = 30.925771479574340000
      end
      item
        Value = 37.907565007769590000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        Value = 31.166663512656080000
      end
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end>
    TabOrder = 2
    object pgctrlSolutionsAndAdditives: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 343
      Height = 292
      ActivePage = tbshtAdditives
      Align = alClient
      TabOrder = 0
      object tbshtSolutions: TTabSheet
        AlignWithMargins = True
        Caption = 'Solutions'
        ExplicitTop = 27
        ExplicitHeight = 258
        object cboSolution: TORComboBox
          Left = 0
          Top = 0
          Width = 329
          Height = 247
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Solutions'
          Color = clWindow
          DropDownCount = 11
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabPositions = '20'
          TabOrder = 0
          Text = ''
          OnExit = cboSolutionExit
          OnMouseClick = cboSolutionMouseClick
          OnNeedData = cboSolutionNeedData
          CharsNeedMatch = 1
          ExplicitHeight = 258
        end
      end
      object tbshtAdditives: TTabSheet
        AlignWithMargins = True
        Caption = 'Additives'
        ImageIndex = 1
        ExplicitTop = 27
        ExplicitHeight = 258
        object cboAdditive: TORComboBox
          Left = 0
          Top = 0
          Width = 329
          Height = 247
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Additives'
          Color = clWindow
          DropDownCount = 11
          ItemHeight = 24
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabPositions = '20'
          TabOrder = 0
          Text = ''
          OnExit = cboAdditiveExit
          OnMouseClick = cboAdditiveMouseClick
          OnNeedData = cboAdditiveNeedData
          CharsNeedMatch = 1
          ExplicitHeight = 258
        end
      end
    end
    object pnlTopRightTop: TPanel
      AlignWithMargins = True
      Left = 352
      Top = 3
      Width = 418
      Height = 175
      Align = alClient
      Anchors = []
      BevelOuter = bvNone
      TabOrder = 1
      object pnlTopRightLbls: TPanel
        Left = 0
        Top = 0
        Width = 418
        Height = 30
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblAmount: TLabel
          Left = 134
          Top = 6
          Width = 148
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Volume/Strength*'
          WordWrap = True
        end
        object lblComponent: TLabel
          Left = 5
          Top = 6
          Width = 147
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Solution/Additive*'
        end
        object lblAddFreq: TLabel
          Left = 256
          Top = 6
          Width = 171
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Additive Frequency*'
        end
        object lblPrevAddFreq: TLabel
          Left = 383
          Top = 6
          Width = 138
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Prev. Add. Freq.'
        end
      end
      object grdSelected: TCaptionStringGrid
        Left = 0
        Top = 30
        Width = 418
        Height = 145
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clMoneyGreen
        DefaultColWidth = 100
        DefaultRowHeight = 19
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
        ScrollBars = ssVertical
        TabOrder = 1
        OnDrawCell = grdSelectedDrawCell
        OnKeyPress = grdSelectedKeyPress
        OnMouseDown = grdSelectedMouseDown
        Caption = ''
      end
      object txtSelected: TCaptionEdit
        Tag = -1
        Left = 28
        Top = 81
        Width = 56
        Height = 30
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        Text = 'meq.'
        Visible = False
        OnChange = txtSelectedChange
        OnExit = txtSelectedExit
        OnKeyDown = txtSelectedKeyDown
        Caption = 'Volume'
      end
      object cboSelected: TCaptionComboBox
        Tag = -1
        Left = 91
        Top = 81
        Width = 67
        Height = 32
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        Visible = False
        OnCloseUp = cboSelectedCloseUp
        OnKeyDown = cboSelectedKeyDown
        Caption = 'Volume/Strength'
      end
      object cboAddFreq: TCaptionComboBox
        Left = 165
        Top = 81
        Width = 181
        Height = 32
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 6
        Visible = False
        OnCloseUp = cboAddFreqCloseUp
        OnKeyDown = cboAddFreqKeyDown
        Caption = ''
      end
    end
    object cmdRemove: TButton
      AlignWithMargins = True
      Left = 676
      Top = 184
      Width = 94
      Height = 29
      Align = alClient
      Caption = 'Remove'
      TabOrder = 2
      OnClick = cmdRemoveClick
    end
    object pnlComments: TPanel
      AlignWithMargins = True
      Left = 352
      Top = 219
      Width = 418
      Height = 76
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      object lblComments: TLabel
        Left = 0
        Top = 0
        Width = 418
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Comments'
        ExplicitWidth = 91
      end
      object memComments: TCaptionMemo
        Left = 0
        Top = 24
        Width = 418
        Height = 52
        Align = alClient
        Lines.Strings = (
          'm'
          'e'
          'm'
          'C'
          'o'
          'm'
          'm'
          'e'
          'n'
          't'
          's')
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = ControlChange
        Caption = 'Comments'
        ExplicitTop = 13
        ExplicitHeight = 63
      end
    end
    object lblRoute: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 298
      Width = 69
      Height = 30
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Caption = 'Route*'
      Layout = tlBottom
      ExplicitWidth = 57
      ExplicitHeight = 24
    end
    object txtAllIVRoutes: TLabel
      AlignWithMargins = True
      Left = 78
      Top = 301
      Width = 116
      Height = 24
      Align = alClient
      Alignment = taRightJustify
      AutoSize = False
      Caption = '(Expanded Med Route List)'
      EllipsisPosition = epEndEllipsis
      Layout = tlBottom
      Visible = False
      WordWrap = True
      OnClick = txtAllIVRoutesClick
      ExplicitLeft = 115
      ExplicitTop = 161
      ExplicitWidth = 69
      ExplicitHeight = 48
    end
    object lblType: TLabel
      AlignWithMargins = True
      Left = 200
      Top = 301
      Width = 64
      Height = 24
      Align = alClient
      Caption = 'Type*'
      ParentShowHint = False
      ShowHint = True
      Layout = tlBottom
      ExplicitWidth = 50
    end
    object lblTypeHelp: TLabel
      AlignWithMargins = True
      Left = 270
      Top = 301
      Width = 76
      Height = 24
      Align = alClient
      Alignment = taRightJustify
      AutoSize = False
      Caption = '(IV Type Help)'
      EllipsisPosition = epEndEllipsis
      ParentShowHint = False
      ShowHint = False
      Layout = tlBottom
      OnClick = lblTypeHelpClick
      ExplicitLeft = 260
      ExplicitTop = 161
      ExplicitWidth = 87
      ExplicitHeight = 16
    end
    object lblSchedule: TLabel
      AlignWithMargins = True
      Left = 352
      Top = 301
      Width = 75
      Height = 24
      Align = alClient
      Caption = 'Schedule *'
      Layout = tlBottom
      ExplicitWidth = 93
    end
    object txtNSS: TLabel
      AlignWithMargins = True
      Left = 433
      Top = 301
      Width = 156
      Height = 24
      Align = alClient
      Caption = '(Day-of-Week)'
      Layout = tlBottom
      OnClick = txtNSSClick
      ExplicitWidth = 120
    end
    object lblInfusionRate: TLabel
      AlignWithMargins = True
      Left = 595
      Top = 301
      Width = 175
      Height = 24
      Align = alClient
      Caption = 'Infusion Rate (ml/hr)*'
      Layout = tlBottom
      ExplicitWidth = 174
    end
    object cboRoute: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 332
      Width = 189
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 24
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 4
      Text = ''
      OnChange = cboRouteChange
      OnClick = cboRouteClick
      OnExit = cboRouteExit
      OnKeyDown = cboRouteKeyDown
      OnKeyUp = cboRouteKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cboType: TComboBox
      AlignWithMargins = True
      Left = 200
      Top = 331
      Width = 146
      Height = 32
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnChange = cboTypeChange
      OnKeyDown = cboTypeKeyDown
    end
    object cboSchedule: TORComboBox
      AlignWithMargins = True
      Left = 352
      Top = 331
      Width = 156
      Height = 32
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 24
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 1
      MaxLength = 0
      Pieces = '1'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 6
      Text = ''
      OnChange = cboScheduleChange
      OnClick = cboScheduleClick
      OnExit = cboScheduleExit
      OnKeyDown = cboScheduleKeyDown
      OnKeyUp = cboScheduleKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object chkPRN: TCheckBox
      AlignWithMargins = True
      Left = 514
      Top = 331
      Width = 75
      Height = 29
      Align = alClient
      Caption = 'PRN'
      TabOrder = 7
      OnClick = chkPRNClick
    end
    object txtRate: TCaptionEdit
      AlignWithMargins = True
      Left = 595
      Top = 331
      Width = 75
      Height = 26
      Align = alClient
      AutoSelect = False
      Constraints.MaxHeight = 26
      TabOrder = 8
      OnChange = txtRateChange
      Caption = 'Infusion Rate'
    end
    object cboInfusionTime: TComboBox
      AlignWithMargins = True
      Left = 679
      Top = 332
      Width = 90
      Height = 32
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 13
      OnChange = cboInfusionTimeChange
      OnEnter = cboInfusionTimeEnter
    end
    object lblPriority: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 367
      Width = 187
      Height = 22
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Caption = 'Priority*'
      Layout = tlBottom
      ExplicitWidth = 63
      ExplicitHeight = 24
    end
    object lblLimit: TLabel
      AlignWithMargins = True
      Left = 200
      Top = 366
      Width = 227
      Height = 24
      Align = alClient
      Caption = 'Duration or Total Volume (Optional)'
      Layout = tlBottom
      ExplicitWidth = 296
    end
    object cboPriority: TORComboBox
      AlignWithMargins = True
      Left = 3
      Top = 396
      Width = 191
      Height = 32
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Priority'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 24
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 10
      Text = ''
      OnChange = cboPriorityChange
      OnExit = cboPriorityExit
      OnKeyUp = cboPriorityKeyUp
      CharsNeedMatch = 1
    end
    object txtXDuration: TCaptionEdit
      AlignWithMargins = True
      Left = 200
      Top = 396
      Width = 64
      Height = 26
      Align = alTop
      Constraints.MaxHeight = 26
      TabOrder = 11
      OnChange = txtXDurationChange
      OnExit = txtXDurationExit
      Caption = #54084#20483#8279
    end
    object cboDuration: TComboBox
      AlignWithMargins = True
      Left = 270
      Top = 396
      Width = 76
      Height = 32
      Align = alClient
      AutoComplete = False
      TabOrder = 12
      OnChange = cboDurationChange
      OnEnter = cboDurationEnter
    end
    object lblFirstDose: TVA508StaticText
      Name = 'lblFirstDose'
      AlignWithMargins = True
      Left = 3
      Top = 450
      Width = 343
      Height = 26
      Align = alBottom
      Alignment = taLeftJustify
      Caption = 'First Dose'
      TabOrder = 15
      TabStop = True
      Visible = False
      ShowAccelChar = True
      ExplicitWidth = 86
    end
    object lblAdminTime: TVA508StaticText
      Name = 'lblAdminTime'
      AlignWithMargins = True
      Left = 3
      Top = 471
      Width = 343
      Height = 26
      Align = alBottom
      Alignment = taLeftJustify
      Caption = 'Admin Time'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      TabStop = True
      Visible = False
      ShowAccelChar = True
      ExplicitWidth = 105
    end
    object chkDoseNow: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 431
      Width = 343
      Height = 24
      Align = alBottom
      Caption = 'Give Additional Dose Now'
      TabOrder = 17
      OnClick = chkDoseNowClick
    end
    object lbl508Required: TVA508StaticText
      Name = 'lbl508Required'
      AlignWithMargins = True
      Left = 6
      Top = 493
      Width = 501
      Height = 26
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = ' * Indicates a Required Field'
      TabOrder = 18
      ShowAccelChar = True
      ExplicitWidth = 238
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 531
      Width = 69
      Height = 24
      Align = alBottom
      Caption = 'Order Sig.'
      Layout = tlCenter
      ExplicitTop = 542
      ExplicitWidth = 86
    end
    object cboIndication: TIndicationsComboBox
      AlignWithMargins = True
      Left = 434
      Top = 397
      Width = 235
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 24
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 40
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 14
      Text = ''
      OnChange = cboIndicationChange
      OnExit = cboIndicationExit
      OnKeyUp = cboIndicationKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object lblIndications: TLabel
      AlignWithMargins = True
      Left = 433
      Top = 366
      Width = 75
      Height = 24
      Align = alClient
      Caption = 'Indication*'
      Layout = tlBottom
      ExplicitWidth = 87
    end
  end
  inherited cmdAccept: TButton [3]
    AlignWithMargins = True
    Left = 686
    Top = 680
    Width = 104
    Height = 29
    TabOrder = 4
    ExplicitLeft = 686
    ExplicitTop = 680
    ExplicitWidth = 104
    ExplicitHeight = 29
  end
  inherited cmdQuit: TButton [4]
    AlignWithMargins = True
    Left = 687
    Top = 717
    Width = 104
    Height = 29
    TabOrder = 3
    ExplicitLeft = 687
    ExplicitTop = 717
    ExplicitWidth = 104
    ExplicitHeight = 29
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 686
    Top = 763
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODMedIV'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRightTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRightLbls'
        'Status = stsDefault')
      (
        'Component = grdSelected'
        'Status = stsDefault')
      (
        'Component = txtSelected'
        'Status = stsDefault')
      (
        'Component = cboSelected'
        'Status = stsDefault')
      (
        'Component = cboAddFreq'
        'Status = stsDefault')
      (
        'Component = pgctrlSolutionsAndAdditives'
        'Status = stsDefault')
      (
        'Component = tbshtSolutions'
        'Status = stsDefault')
      (
        'Component = tbshtAdditives'
        'Status = stsDefault')
      (
        'Component = cboAdditive'
        'Status = stsDefault')
      (
        'Component = cboSolution'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboType'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = txtRate'
        'Status = stsDefault')
      (
        'Component = cboInfusionTime'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = cboDuration'
        'Status = stsDefault')
      (
        'Component = lblFirstDose'
        'Status = stsDefault')
      (
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = lbl508Required'
        'Status = stsDefault')
      (
        'Component = cboIndication'
        
          'Text = Indications for use. Indication must be entered and shoul' +
          'd be between 3 to 40 characters.'
        'Status = stsOK'))
  end
  object VA508CompOrderSig: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompOrderSigStateQuery
    Left = 609
    Top = 763
  end
  object VA508CompRoute: TVA508ComponentAccessibility
    Component = cboRoute
    OnInstructionsQuery = VA508CompRouteInstructionsQuery
    Left = 763
    Top = 763
  end
  object VA508CompType: TVA508ComponentAccessibility
    Component = cboType
    OnInstructionsQuery = VA508CompTypeInstructionsQuery
    Left = 724
    Top = 763
  end
  object VA508CompSchedule: TVA508ComponentAccessibility
    Component = cboSchedule
    OnInstructionsQuery = VA508CompScheduleInstructionsQuery
    Left = 647
    Top = 763
  end
  object VA508CompGrdSelected: TVA508ComponentAccessibility
    Component = grdSelected
    OnCaptionQuery = VA508CompGrdSelectedCaptionQuery
    Left = 571
    Top = 763
  end
end
