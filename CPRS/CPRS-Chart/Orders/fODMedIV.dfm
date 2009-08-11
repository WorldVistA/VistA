inherited frmODMedIV: TfrmODMedIV
  Left = 246
  Top = 256
  Width = 668
  Height = 465
  Caption = 'Infusion Order'
  Constraints.MinHeight = 350
  Constraints.MinWidth = 500
  ExplicitWidth = 668
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfusionRate: TLabel [0]
    Left = 486
    Top = 197
    Width = 100
    Height = 13
    Caption = 'Infusion Rate (ml/hr)*'
  end
  object lblPriority: TLabel [1]
    Left = 8
    Top = 238
    Width = 35
    Height = 13
    Caption = 'Priority*'
  end
  object lblComponent: TLabel [2]
    Left = 214
    Top = 7
    Width = 85
    Height = 13
    Caption = 'Solution/Additive*'
  end
  object lblAmount: TLabel [3]
    Left = 328
    Top = 7
    Width = 84
    Height = 13
    Caption = 'Volume/Strength*'
    WordWrap = True
  end
  object lblComments: TLabel [4]
    Left = 214
    Top = 107
    Width = 49
    Height = 13
    Caption = 'Comments'
  end
  object lblLimit: TLabel [5]
    Left = 185
    Top = 238
    Width = 165
    Height = 13
    Caption = 'Duration or Total Volume (Optional)'
  end
  object Label1: TLabel [6]
    Left = 8
    Top = 344
    Width = 133
    Height = 13
    Caption = ' * Indicates a Required Field'
  end
  object lblRoute: TLabel [7]
    Left = 8
    Top = 197
    Width = 33
    Height = 13
    Caption = 'Route*'
  end
  object lblSchedule: TLabel [8]
    Left = 304
    Top = 197
    Width = 52
    Height = 13
    Caption = 'Schedule *'
  end
  object lblType: TLabel [9]
    Left = 184
    Top = 197
    Width = 28
    Height = 13
    Caption = 'Type*'
    ParentShowHint = False
    ShowHint = True
  end
  object txtNSS: TLabel [10]
    Left = 361
    Top = 197
    Width = 69
    Height = 13
    Caption = '(Day-of-Week)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = txtNSSClick
  end
  object txtAllIVRoutes: TLabel [11]
    Left = 47
    Top = 197
    Width = 129
    Height = 13
    Caption = '(Expanded Med Route List)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
    OnClick = txtAllIVRoutesClick
  end
  object lblTypeHelp: TLabel [12]
    Left = 219
    Top = 197
    Width = 68
    Height = 13
    Caption = '(IV Type Help)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnClick = lblTypeHelpClick
  end
  object txtRate: TCaptionEdit [13]
    Left = 486
    Top = 211
    Width = 91
    Height = 21
    AutoSelect = False
    TabOrder = 8
    OnChange = txtRateChange
    Caption = 'Infusion Rate'
  end
  object cboPriority: TORComboBox [14]
    Left = 8
    Top = 252
    Width = 72
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Priority'
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
    TabOrder = 10
    OnChange = cboPriorityChange
    OnExit = cboPriorityExit
    CharsNeedMatch = 1
  end
  object grdSelected: TCaptionStringGrid [15]
    Left = 214
    Top = 21
    Width = 437
    Height = 76
    ColCount = 3
    DefaultColWidth = 100
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ScrollBars = ssVertical
    TabOrder = 1
    OnDrawCell = grdSelectedDrawCell
    OnKeyPress = grdSelectedKeyPress
    OnMouseDown = grdSelectedMouseDown
    Caption = 'Selected Solution and Additives'
  end
  object cmdRemove: TButton [16]
    Left = 443
    Top = 100
    Width = 72
    Height = 18
    Caption = 'Remove'
    TabOrder = 2
    OnClick = cmdRemoveClick
  end
  object memComments: TCaptionMemo [17]
    Left = 214
    Top = 121
    Width = 437
    Height = 66
    Lines.Strings = (
      'memComments')
    ScrollBars = ssVertical
    TabOrder = 13
    OnChange = ControlChange
    Caption = 'Comments'
  end
  object txtSelected: TCaptionEdit [18]
    Tag = -1
    Left = 416
    Top = 45
    Width = 45
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Text = 'meq.'
    Visible = False
    OnChange = txtSelectedChange
    OnExit = txtSelectedExit
    Caption = 'Volume'
  end
  object cboSelected: TCaptionComboBox [19]
    Tag = -1
    Left = 460
    Top = 45
    Width = 53
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 4
    Visible = False
    OnChange = cboSelectedChange
    OnExit = cboSelectedExit
    Caption = 'Volume/Strength'
  end
  inherited memOrder: TCaptionMemo
    Top = 359
    Width = 475
    TabStop = True
    TabOrder = 16
    ExplicitTop = 359
    ExplicitWidth = 475
  end
  object pnlXDuration: TPanel [21]
    Left = 184
    Top = 252
    Width = 150
    Height = 21
    BevelOuter = bvNone
    TabOrder = 11
    OnEnter = pnlXDurationEnter
    object txtXDuration: TCaptionEdit
      Left = 0
      Top = 0
      Width = 68
      Height = 21
      TabOrder = 0
      OnChange = txtXDurationChange
      OnExit = txtXDurationExit
      Caption = 'Duration'
    end
    object cboDuration: TComboBox
      Left = 70
      Top = 0
      Width = 75
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      OnChange = cboDurationChange
      OnEnter = cboDurationEnter
    end
  end
  object pnlCombo: TPanel [22]
    Left = 8
    Top = 2
    Width = 200
    Height = 185
    BevelOuter = bvNone
    TabOrder = 25
    object cboAdditive: TORComboBox
      Left = 0
      Top = 20
      Width = 200
      Height = 165
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Additives'
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
      OnExit = cboAdditiveExit
      OnMouseClick = cboAdditiveMouseClick
      OnNeedData = cboAdditiveNeedData
      CharsNeedMatch = 1
    end
    object tabFluid: TTabControl
      Left = 0
      Top = 0
      Width = 200
      Height = 20
      Align = alTop
      TabHeight = 15
      TabOrder = 2
      Tabs.Strings = (
        '   Solutions   '
        '   Additives   ')
      TabIndex = 0
      TabStop = False
      OnChange = tabFluidChange
    end
    object cboSolution: TORComboBox
      Left = 0
      Top = 20
      Width = 200
      Height = 165
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
      TabOrder = 1
      OnExit = cboSolutionExit
      OnMouseClick = cboSolutionMouseClick
      OnNeedData = cboSolutionNeedData
      CharsNeedMatch = 1
    end
  end
  object cboRoute: TORComboBox [23]
    Left = 8
    Top = 211
    Width = 168
    Height = 21
    Style = orcsDropDown
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
    TabOrder = 3
    OnChange = cboRouteChange
    OnClick = cboRouteClick
    OnExit = cboRouteExit
    CharsNeedMatch = 1
    UniqueAutoComplete = True
  end
  object cboSchedule: TORComboBox [24]
    Left = 304
    Top = 211
    Width = 129
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
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
    OnChange = cboScheduleChange
    OnClick = cboScheduleClick
    OnExit = cboScheduleExit
    CharsNeedMatch = 1
    UniqueAutoComplete = True
  end
  object cboType: TComboBox [25]
    Left = 184
    Top = 211
    Width = 114
    Height = 21
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnChange = cboTypeChange
  end
  object chkPRN: TCheckBox [26]
    Left = 436
    Top = 213
    Width = 45
    Height = 21
    Caption = 'PRN'
    TabOrder = 7
    OnClick = chkPRNClick
  end
  object chkDoseNow: TCheckBox [27]
    Left = 8
    Top = 279
    Width = 147
    Height = 17
    Anchors = [akLeft]
    Caption = 'Give Additional Dose Now'
    Constraints.MinWidth = 147
    TabOrder = 12
    OnClick = chkDoseNowClick
  end
  object cboInfusionTime: TComboBox [28]
    Left = 576
    Top = 211
    Width = 74
    Height = 21
    ItemHeight = 13
    TabOrder = 9
    OnChange = cboInfusionTimeChange
    OnEnter = cboInfusionTimeEnter
  end
  object lblAdminTime: TVA508StaticText [29]
    Name = 'lblAdminTime'
    Left = 8
    Top = 308
    Width = 4
    Height = 4
    Alignment = taLeftJustify
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    TabStop = True
    Visible = False
    ShowAccelChar = True
  end
  object lblFirstDose: TVA508StaticText [30]
    Name = 'lblFirstDose'
    Left = 8
    Top = 323
    Width = 4
    Height = 4
    Alignment = taLeftJustify
    TabOrder = 15
    TabStop = True
    Visible = False
    ShowAccelChar = True
  end
  inherited cmdAccept: TButton
    Left = 495
    Top = 359
    TabOrder = 17
    ExplicitLeft = 495
    ExplicitTop = 359
  end
  inherited cmdQuit: TButton
    Left = 495
    Top = 386
    TabOrder = 18
    ExplicitLeft = 495
    ExplicitTop = 386
  end
  inherited pnlMessage: TPanel
    Left = 56
    Top = 349
    TabOrder = 19
    ExplicitLeft = 56
    ExplicitTop = 349
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtRate'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = grdSelected'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = txtSelected'
        'Status = stsDefault')
      (
        'Component = cboSelected'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = pnlCombo'
        'Status = stsDefault')
      (
        'Component = cboAdditive'
        'Status = stsDefault')
      (
        'Component = tabFluid'
        'Status = stsDefault')
      (
        'Component = cboSolution'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = cboType'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
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
        'Component = cboInfusionTime'
        'Status = stsDefault')
      (
        'Component = cboDuration'
        'Status = stsDefault')
      (
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = lblFirstDose'
        'Status = stsDefault'))
  end
end
