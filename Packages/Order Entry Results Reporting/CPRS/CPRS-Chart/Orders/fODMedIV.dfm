inherited frmODMedIV: TfrmODMedIV
  Left = 246
  Top = 256
  Width = 849
  Height = 876
  Caption = 'Infusion Order'
  Color = clWindow
  Constraints.MinHeight = 500
  Constraints.MinWidth = 500
  DoubleBuffered = True
  ExplicitWidth = 849
  ExplicitHeight = 876
  PixelsPerInch = 120
  TextHeight = 16
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
        ColumnSpan = 7
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
        ColumnSpan = 5
        Control = lblFirstDose
        Row = 9
      end
      item
        Column = 0
        ColumnSpan = 5
        Control = lblAdminTime
        Row = 10
      end
      item
        Column = 0
        ColumnSpan = 5
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
      Height = 282
      ActivePage = tbshtSolutions
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 116
      object tbshtSolutions: TTabSheet
        AlignWithMargins = True
        Caption = 'Solutions'
        ExplicitHeight = 79
        object cboSolution: TORComboBox
          Left = 0
          Top = 0
          Width = 329
          Height = 245
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Solutions'
          Color = clWindow
          DropDownCount = 11
          ItemHeight = 16
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
          ExplicitHeight = 79
        end
      end
      object tbshtAdditives: TTabSheet
        AlignWithMargins = True
        Caption = 'Additives'
        ImageIndex = 1
        ExplicitHeight = 79
        object cboAdditive: TORComboBox
          Left = 0
          Top = 0
          Width = 329
          Height = 245
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Additives'
          Color = clWindow
          DropDownCount = 11
          ItemHeight = 16
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
          ExplicitHeight = 79
        end
      end
    end
    object pnlTopRightTop: TPanel
      AlignWithMargins = True
      Left = 352
      Top = 3
      Width = 418
      Height = 168
      Align = alClient
      Anchors = []
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 54
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
          Width = 104
          Height = 16
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
          Width = 106
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Solution/Additive*'
        end
        object lblAddFreq: TLabel
          Left = 256
          Top = 6
          Width = 121
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Additive Frequency*'
        end
        object lblPrevAddFreq: TLabel
          Left = 383
          Top = 6
          Width = 96
          Height = 16
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
        Height = 138
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
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
        ExplicitHeight = 24
      end
      object txtSelected: TCaptionEdit
        Tag = -1
        Left = 28
        Top = 81
        Width = 56
        Height = 22
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
        Height = 24
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
        Height = 24
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
      Top = 177
      Width = 94
      Height = 29
      Align = alBottom
      Caption = 'Remove'
      TabOrder = 2
      OnClick = cmdRemoveClick
      ExplicitTop = 63
    end
    object pnlComments: TPanel
      AlignWithMargins = True
      Left = 352
      Top = 212
      Width = 418
      Height = 73
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      ExplicitTop = 98
      ExplicitHeight = 21
      object lblComments: TLabel
        Left = 0
        Top = 0
        Width = 418
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Comments'
        ExplicitWidth = 64
      end
      object memComments: TCaptionMemo
        Left = 0
        Top = 16
        Width = 418
        Height = 57
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
        ExplicitHeight = 5
      end
    end
    object lblRoute: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 288
      Width = 69
      Height = 30
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Caption = 'Route*'
      Layout = tlBottom
      ExplicitTop = 122
      ExplicitWidth = 41
      ExplicitHeight = 16
    end
    object txtAllIVRoutes: TLabel
      AlignWithMargins = True
      Left = 78
      Top = 291
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
      Top = 291
      Width = 64
      Height = 24
      Align = alClient
      Caption = 'Type*'
      ParentShowHint = False
      ShowHint = True
      Layout = tlBottom
      ExplicitTop = 125
      ExplicitWidth = 37
      ExplicitHeight = 16
    end
    object lblTypeHelp: TLabel
      AlignWithMargins = True
      Left = 270
      Top = 291
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
      Top = 291
      Width = 75
      Height = 24
      Align = alClient
      Caption = 'Schedule *'
      Layout = tlBottom
      ExplicitTop = 125
      ExplicitWidth = 65
      ExplicitHeight = 16
    end
    object txtNSS: TLabel
      AlignWithMargins = True
      Left = 433
      Top = 291
      Width = 156
      Height = 24
      Align = alClient
      Caption = '(Day-of-Week)'
      Layout = tlBottom
      OnClick = txtNSSClick
      ExplicitTop = 125
      ExplicitWidth = 88
      ExplicitHeight = 16
    end
    object lblInfusionRate: TLabel
      AlignWithMargins = True
      Left = 595
      Top = 291
      Width = 175
      Height = 24
      Align = alClient
      Caption = 'Infusion Rate (ml/hr)*'
      Layout = tlBottom
      ExplicitTop = 125
      ExplicitWidth = 122
      ExplicitHeight = 16
    end
    object cboRoute: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 322
      Width = 189
      Height = 24
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
      TabOrder = 4
      Text = ''
      OnChange = cboRouteChange
      OnClick = cboRouteClick
      OnExit = cboRouteExit
      OnKeyDown = cboRouteKeyDown
      OnKeyUp = cboRouteKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
      ExplicitTop = 156
    end
    object cboType: TComboBox
      AlignWithMargins = True
      Left = 200
      Top = 321
      Width = 146
      Height = 24
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnChange = cboTypeChange
      OnKeyDown = cboTypeKeyDown
      ExplicitTop = 155
    end
    object cboSchedule: TORComboBox
      AlignWithMargins = True
      Left = 352
      Top = 321
      Width = 156
      Height = 24
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
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
      ExplicitTop = 155
    end
    object chkPRN: TCheckBox
      AlignWithMargins = True
      Left = 514
      Top = 321
      Width = 75
      Height = 29
      Align = alClient
      Caption = 'PRN'
      TabOrder = 7
      OnClick = chkPRNClick
      ExplicitTop = 155
      ExplicitHeight = 24
    end
    object txtRate: TCaptionEdit
      AlignWithMargins = True
      Left = 595
      Top = 321
      Width = 75
      Height = 26
      Align = alClient
      AutoSelect = False
      Constraints.MaxHeight = 26
      TabOrder = 8
      OnChange = txtRateChange
      Caption = 'Infusion Rate'
      ExplicitLeft = 598
      ExplicitTop = 156
      ExplicitWidth = 71
      ExplicitHeight = 24
    end
    object cboInfusionTime: TComboBox
      AlignWithMargins = True
      Left = 679
      Top = 322
      Width = 90
      Height = 24
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 13
      OnChange = cboInfusionTimeChange
      OnEnter = cboInfusionTimeEnter
      ExplicitTop = 156
    end
    object lblPriority: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 357
      Width = 187
      Height = 22
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Caption = 'Priority*'
      Layout = tlBottom
      ExplicitTop = 186
      ExplicitWidth = 46
      ExplicitHeight = 16
    end
    object lblLimit: TLabel
      AlignWithMargins = True
      Left = 200
      Top = 356
      Width = 570
      Height = 24
      Align = alClient
      Caption = 'Duration or Total Volume (Optional)'
      Layout = tlBottom
      WordWrap = True
      ExplicitTop = 185
      ExplicitWidth = 209
      ExplicitHeight = 16
    end
    object cboPriority: TORComboBox
      AlignWithMargins = True
      Left = 3
      Top = 386
      Width = 191
      Height = 24
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Priority'
      Color = clWindow
      DropDownCount = 8
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
      TabOrder = 10
      Text = ''
      OnChange = cboPriorityChange
      OnExit = cboPriorityExit
      OnKeyUp = cboPriorityKeyUp
      CharsNeedMatch = 1
      ExplicitTop = 215
    end
    object txtXDuration: TCaptionEdit
      AlignWithMargins = True
      Left = 200
      Top = 386
      Width = 64
      Height = 24
      Align = alTop
      Constraints.MaxHeight = 26
      TabOrder = 11
      OnChange = txtXDurationChange
      OnExit = txtXDurationExit
      Caption = #54084#20483#8279
      ExplicitTop = 215
    end
    object cboDuration: TComboBox
      AlignWithMargins = True
      Left = 270
      Top = 386
      Width = 76
      Height = 24
      Align = alClient
      AutoComplete = False
      TabOrder = 12
      OnChange = cboDurationChange
      OnEnter = cboDurationEnter
      ExplicitTop = 215
    end
    object lblFirstDose: TVA508StaticText
      Name = 'lblFirstDose'
      AlignWithMargins = True
      Left = 3
      Top = 451
      Width = 424
      Height = 18
      Align = alBottom
      Alignment = taLeftJustify
      Caption = 'First Dose'
      TabOrder = 15
      TabStop = True
      Visible = False
      ShowAccelChar = True
      ExplicitTop = 245
      ExplicitWidth = 191
    end
    object lblAdminTime: TVA508StaticText
      Name = 'lblAdminTime'
      AlignWithMargins = True
      Left = 3
      Top = 475
      Width = 424
      Height = 18
      Align = alBottom
      Alignment = taLeftJustify
      Caption = 'Admin Time'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      TabStop = True
      Visible = False
      ShowAccelChar = True
      ExplicitTop = 269
      ExplicitWidth = 191
    end
    object chkDoseNow: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 421
      Width = 424
      Height = 24
      Align = alBottom
      Caption = 'Give Additional Dose Now'
      TabOrder = 17
      OnClick = chkDoseNowClick
      ExplicitTop = 293
      ExplicitWidth = 505
    end
    object lbl508Required: TVA508StaticText
      Name = 'lbl508Required'
      AlignWithMargins = True
      Left = 6
      Top = 500
      Width = 501
      Height = 18
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
      ExplicitTop = 324
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 538
      Width = 69
      Height = 16
      Align = alBottom
      Caption = 'Order Sig.'
      Layout = tlCenter
      ExplicitTop = 349
      ExplicitWidth = 60
    end
  end
  inherited cmdAccept: TButton [3]
    AlignWithMargins = True
    Left = 686
    Top = 680
    Width = 104
    Height = 29
    Margins.Left = 3
    Margins.Top = 3
    Margins.Right = 3
    Margins.Bottom = 3
    TabOrder = 4
    ExplicitLeft = 686
    ExplicitTop = 680
    ExplicitWidth = 104
    ExplicitHeight = 29
  end
  inherited cmdQuit: TButton [4]
    AlignWithMargins = True
    Left = 686
    Top = 715
    Width = 104
    Height = 29
    Margins.Left = 3
    Margins.Top = 3
    Margins.Right = 3
    Margins.Bottom = 3
    TabOrder = 3
    ExplicitLeft = 686
    ExplicitTop = 715
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
        'Status = stsDefault'))
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
