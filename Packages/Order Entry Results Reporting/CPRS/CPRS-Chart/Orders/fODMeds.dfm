inherited frmODMeds: TfrmODMeds
  Left = 321
  Top = 183
  Width = 619
  Height = 777
  AutoScroll = True
  Caption = 'Medication Order'
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  DoubleBuffered = True
  OnCanResize = FormCanResize
  ExplicitWidth = 619
  ExplicitHeight = 777
  DesignSize = (
    603
    738)
  PixelsPerInch = 96
  TextHeight = 13
  inherited memOrder: TCaptionMemo
    Tag = 13
    Top = 671
    Width = 491
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    ExplicitTop = 671
    ExplicitWidth = 491
  end
  object txtMed: TEdit [1]
    Left = 8
    Top = 8
    Width = 509
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '(Type a medication name or select from the orders below)'
    OnChange = txtMedChange
    OnExit = txtMedExit
    OnKeyDown = txtMedKeyDown
    OnKeyUp = txtMedKeyUp
  end
  object btnSelect: TButton [2]
    Left = 523
    Top = 8
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 5
    OnClick = btnSelectClick
  end
  inherited cmdQuit: TButton [3]
    Left = 543
    Top = 699
    Width = 51
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 543
    ExplicitTop = 699
    ExplicitWidth = 51
  end
  object PageControl: TPageControl [4]
    Left = 4
    Top = 29
    Width = 594
    Height = 639
    ActivePage = PageFields
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsFlatButtons
    TabOrder = 2
    TabStop = False
    object PageMeds: TTabSheet
      Caption = 'Meds'
      ImageIndex = 1
      TabVisible = False
      object pnlMeds: TPanel
        Left = 0
        Top = 0
        Width = 586
        Height = 629
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object sptSelect: TSplitter
          Left = 0
          Top = 133
          Width = 586
          Height = 4
          Cursor = crVSplit
          Align = alTop
          ExplicitWidth = 690
        end
        object lstQuick: TCaptionListView
          Left = 0
          Top = 0
          Width = 586
          Height = 133
          Align = alTop
          BevelInner = bvLowered
          BevelOuter = bvSpace
          Columns = <
            item
              Width = 420
            end>
          ColumnClick = False
          HideSelection = False
          HotTrack = True
          HoverTime = 2147483647
          OwnerData = True
          ParentShowHint = False
          ShowColumnHeaders = False
          ShowHint = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lstChange
          OnClick = ListViewClick
          OnData = lstQuickData
          OnDataHint = lstQuickDataHint
          OnEditing = ListViewEditing
          OnEnter = ListViewEnter
          OnKeyUp = ListViewKeyUp
          OnResize = ListViewResize
          AutoSize = False
          Caption = 'Quick Orders'
          HideTinyColumns = False
        end
        object lstAll: TCaptionListView
          Left = 0
          Top = 137
          Width = 586
          Height = 492
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          Columns = <
            item
              Width = 420
            end>
          ColumnClick = False
          HideSelection = False
          HotTrack = True
          HoverTime = 2147483647
          OwnerData = True
          ParentShowHint = False
          ShowColumnHeaders = False
          ShowHint = True
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lstChange
          OnClick = ListViewClick
          OnData = lstAllData
          OnDataHint = lstAllDataHint
          OnEditing = ListViewEditing
          OnEnter = ListViewEnter
          OnKeyUp = ListViewKeyUp
          OnResize = ListViewResize
          AutoSize = False
          Caption = 'All Medication orders'
          HideTinyColumns = False
        end
      end
    end
    object PageFields: TTabSheet
      Caption = 'Fields'
      TabVisible = False
      object pnlFields: TPanel
        Left = 0
        Top = 0
        Width = 586
        Height = 629
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        OnResize = pnlFieldsResize
        object pnlTop: TPanel
          Left = 0
          Top = 0
          Width = 586
          Height = 356
          Align = alClient
          ParentBackground = False
          TabOrder = 0
          DesignSize = (
            586
            356)
          object lblRoute: TLabel
            Left = 285
            Top = 23
            Width = 29
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Route'
            Visible = False
            ExplicitLeft = 354
          end
          object lblSchedule: TLabel
            Left = 400
            Top = 22
            Width = 45
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Schedule'
            Visible = False
            WordWrap = True
            ExplicitLeft = 469
          end
          object txtNSS: TLabel
            Left = 448
            Top = 22
            Width = 71
            Height = 13
            Anchors = [akTop, akRight]
            Caption = '(Day-Of-Week)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Visible = False
            WordWrap = True
            OnClick = txtNSSClick
            ExplicitLeft = 517
          end
          object grdDoses: TCaptionStringGrid
            Left = 0
            Top = 36
            Width = 585
            Height = 305
            Anchors = [akLeft, akTop, akRight, akBottom]
            ColCount = 7
            DefaultColWidth = 76
            DefaultRowHeight = 21
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
            ScrollBars = ssVertical
            TabOrder = 4
            OnEnter = grdDosesEnter
            OnExit = grdDosesExit
            OnKeyDown = grdDosesKeyDown
            OnKeyPress = grdDosesKeyPress
            OnMouseDown = grdDosesMouseDown
            OnMouseUp = grdDosesMouseUp
            Caption = 'Complex Dosage'
            JustToTab = True
            ColWidths = (
              76
              76
              76
              76
              76
              76
              76)
          end
          object lblGuideline: TStaticText
            Left = 1
            Top = 5
            Width = 181
            Height = 17
            Caption = 'Display Restrictions/Guidelines'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold, fsUnderline]
            ParentColor = False
            ParentFont = False
            ShowAccelChar = False
            TabOrder = 0
            TabStop = True
            Transparent = False
            Visible = False
            OnClick = lblGuidelineClick
          end
          object tabDose: TTabControl
            Left = 1
            Top = 19
            Width = 175
            Height = 17
            TabOrder = 3
            Tabs.Strings = (
              'Dosage'
              'Complex')
            TabIndex = 0
            TabStop = False
            TabWidth = 86
            OnChange = tabDoseChange
          end
          object cboDosage: TORComboBox
            Left = 1
            Top = 36
            Width = 284
            Height = 316
            Anchors = [akLeft, akTop, akRight, akBottom]
            Style = orcsSimple
            AutoSelect = True
            Caption = 'Dosage'
            Color = clWindow
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            Pieces = '5,3,6'
            Sorted = False
            SynonymChars = '<>'
            TabPositions = '27,32'
            TabOrder = 5
            Text = ''
            OnChange = cboDosageChange
            OnClick = cboDosageClick
            OnExit = cboDosageExit
            OnKeyUp = cboDosageKeyUp
            CharsNeedMatch = 1
            UniqueAutoComplete = True
          end
          object cboRoute: TORComboBox
            Left = 285
            Top = 36
            Width = 113
            Height = 316
            Anchors = [akTop, akRight, akBottom]
            Style = orcsSimple
            AutoSelect = True
            Caption = 'Route'
            Color = clWindow
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            ParentShowHint = False
            Pieces = '2'
            ShowHint = True
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 6
            Text = ''
            OnChange = cboRouteChange
            OnClick = ControlChange
            OnExit = cboRouteExit
            OnKeyUp = cboRouteKeyUp
            CharsNeedMatch = 1
            UniqueAutoComplete = True
          end
          object cboSchedule: TORComboBox
            Left = 400
            Top = 36
            Width = 182
            Height = 316
            Anchors = [akTop, akRight, akBottom]
            Style = orcsSimple
            AutoSelect = False
            Caption = 'Schedule'
            Color = clWindow
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            Pieces = '1'
            Sorted = True
            SynonymChars = '<>'
            TabOrder = 7
            Text = ''
            OnChange = cboScheduleChange
            OnClick = cboScheduleClick
            OnEnter = cboScheduleEnter
            OnExit = cboScheduleExit
            OnKeyUp = cboScheduleKeyUp
            CharsNeedMatch = 1
            UniqueAutoComplete = True
          end
          object chkPRN: TCheckBox
            Left = 535
            Top = 37
            Width = 43
            Height = 18
            Anchors = [akTop, akRight]
            Caption = 'PRN'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 8
            OnClick = chkPRNClick
          end
          object btnXInsert: TButton
            Left = 405
            Top = 3
            Width = 78
            Height = 17
            Anchors = [akTop, akRight]
            Caption = 'Insert Row'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnXInsertClick
          end
          object btnXRemove: TButton
            Left = 490
            Top = 3
            Width = 79
            Height = 17
            Anchors = [akTop, akRight]
            Caption = 'Remove Row'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = btnXRemoveClick
          end
          object pnlXAdminTime: TPanel
            Left = 432
            Top = 149
            Width = 65
            Height = 17
            Caption = 'pnlXAdminTime'
            TabOrder = 9
            Visible = False
            OnClick = pnlXAdminTimeClick
          end
        end
        object cboXDosage: TORComboBox
          Left = 49
          Top = 122
          Width = 72
          Height = 21
          Style = orcsDropDown
          AutoSelect = False
          Caption = 'Dosage'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Pieces = '5'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          Visible = False
          OnChange = cboXDosageChange
          OnClick = cboXDosageClick
          OnEnter = cboXDosageEnter
          OnExit = cboXDosageExit
          OnKeyDown = memMessageKeyDown
          OnKeyUp = cboXDosageKeyUp
          CharsNeedMatch = 1
          UniqueAutoComplete = True
        end
        object cboXRoute: TORComboBox
          Left = 122
          Top = 122
          Width = 72
          Height = 21
          Style = orcsDropDown
          AutoSelect = False
          Caption = 'Route'
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
          TabOrder = 2
          Text = ''
          Visible = False
          OnChange = cboXRouteChange
          OnClick = cboXRouteClick
          OnEnter = cboXRouteEnter
          OnExit = cboXRouteExit
          OnKeyDown = memMessageKeyDown
          CharsNeedMatch = 1
          UniqueAutoComplete = True
        end
        object pnlXDuration: TPanel
          Left = 300
          Top = 122
          Width = 72
          Height = 21
          BevelOuter = bvNone
          TabOrder = 4
          Visible = False
          OnEnter = pnlXDurationEnter
          OnExit = pnlXDurationExit
          DesignSize = (
            72
            21)
          object pnlXDurationButton: TKeyClickPanel
            Left = 39
            Top = 0
            Width = 33
            Height = 21
            Align = alRight
            Caption = 'Duration'
            TabOrder = 2
            TabStop = True
            OnClick = btnXDurationClick
            OnEnter = pnlXDurationButtonEnter
            object btnXDuration: TSpeedButton
              Left = 1
              Top = 1
              Width = 31
              Height = 19
              Align = alClient
              Caption = 'days'
              Flat = True
              Glyph.Data = {
                AE000000424DAE0000000000000076000000280000000E000000070000000100
                0400000000003800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                330033333333333333003330333333733300330003333F87330030000033FFFF
                F30033333333333333003333333333333300}
              Layout = blGlyphRight
              NumGlyphs = 2
              Spacing = 0
              Transparent = False
              OnClick = btnXDurationClick
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 33
            end
          end
          object txtXDuration: TCaptionEdit
            Left = 0
            Top = 0
            Width = 39
            Height = 21
            Align = alClient
            AutoSize = False
            TabOrder = 0
            Text = '0'
            OnChange = txtXDurationChange
            OnKeyDown = memMessageKeyDown
            Caption = 'Duration'
            ExplicitWidth = 23
          end
          object spnXDuration: TUpDown
            Left = 23
            Top = 0
            Width = 17
            Height = 21
            Anchors = [akLeft, akTop, akBottom]
            Associate = txtXDuration
            Max = 999
            TabOrder = 1
          end
        end
        object pnlXSchedule: TPanel
          Left = 195
          Top = 122
          Width = 106
          Height = 21
          BevelOuter = bvNone
          TabOrder = 3
          Visible = False
          OnEnter = pnlXScheduleEnter
          OnExit = pnlXScheduleExit
          DesignSize = (
            106
            21)
          object cboXSchedule: TORComboBox
            Left = 0
            Top = 0
            Width = 63
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Style = orcsDropDown
            AutoSelect = False
            Caption = 'Schedule'
            Color = clWindow
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            Pieces = '1'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 0
            TabStop = True
            Text = ''
            OnChange = cboXScheduleChange
            OnClick = cboXScheduleClick
            OnEnter = cboXScheduleEnter
            OnExit = cboXScheduleExit
            OnKeyDown = memMessageKeyDown
            OnKeyUp = cboXScheduleKeyUp
            CharsNeedMatch = 1
            UniqueAutoComplete = True
          end
          object chkXPRN: TCheckBox
            Left = 63
            Top = 4
            Width = 42
            Height = 11
            Anchors = [akTop, akRight]
            Caption = 'PRN'
            TabOrder = 1
            OnClick = chkXPRNClick
            OnKeyDown = memMessageKeyDown
          end
        end
        object pnlBottom: TPanel
          Left = 0
          Top = 356
          Width = 586
          Height = 273
          Align = alBottom
          ParentBackground = False
          TabOrder = 6
          DesignSize = (
            586
            273)
          object lblComment: TLabel
            Left = 216
            Top = 7
            Width = 54
            Height = 16
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Comments:'
          end
          object lblDays: TLabel
            Left = 4
            Top = 81
            Width = 59
            Height = 13
            Caption = 'Days Supply'
          end
          object lblQuantity: TLabel
            Left = 83
            Top = 81
            Width = 39
            Height = 13
            Caption = 'Quantity'
            ParentShowHint = False
            ShowHint = True
          end
          object lblRefills: TLabel
            Left = 142
            Top = 81
            Width = 28
            Height = 13
            Caption = 'Refills'
          end
          object lblPriority: TLabel
            Left = 503
            Top = 97
            Width = 31
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Priority'
          end
          object Image1: TImage
            Left = 5
            Top = 221
            Width = 31
            Height = 31
            Anchors = [akLeft, akBottom]
            Visible = False
          end
          object lblIndications: TLabel
            Left = 4
            Top = 3
            Width = 54
            Height = 16
            AutoSize = False
            Caption = 'Indication:'
          end
          object chkDoseNow: TCheckBox
            Left = 3
            Top = 120
            Width = 247
            Height = 21
            Caption = 'Give additional dose now'
            TabOrder = 16
            OnClick = chkDoseNowClick
          end
          object memComment: TCaptionMemo
            Left = 216
            Top = 20
            Width = 359
            Height = 39
            Anchors = [akLeft, akTop, akRight]
            ScrollBars = ssVertical
            TabOrder = 1
            OnChange = ControlChange
            OnClick = memCommentClick
            Caption = 'Comments'
          end
          object lblQtyMsg: TStaticText
            Left = 4
            Top = 60
            Width = 206
            Height = 17
            Caption = '>> Quantity Dispensed: Multiples of 100 <<'
            TabOrder = 3
          end
          object txtSupply: TCaptionEdit
            Left = 2
            Top = 94
            Width = 60
            Height = 21
            AutoSize = False
            TabOrder = 4
            Text = '0'
            OnChange = txtSupplyChange
            OnClick = txtSupplyClick
            Caption = 'Days Supply'
          end
          object spnSupply: TUpDown
            Left = 62
            Top = 94
            Width = 16
            Height = 21
            Associate = txtSupply
            Max = 32766
            TabOrder = 5
          end
          object txtQuantity: TCaptionEdit
            Left = 83
            Top = 94
            Width = 39
            Height = 21
            AutoSize = False
            TabOrder = 6
            Text = '0'
            OnChange = txtQuantityChange
            OnClick = txtQuantityClick
            Caption = 'Quantity'
          end
          object spnQuantity: TUpDown
            Left = 122
            Top = 94
            Width = 16
            Height = 21
            Associate = txtQuantity
            Max = 32766
            TabOrder = 7
          end
          object txtRefills: TCaptionEdit
            Left = 142
            Top = 94
            Width = 31
            Height = 21
            AutoSize = False
            TabOrder = 8
            Text = '0'
            OnChange = txtRefillsChange
            OnClick = txtRefillsClick
            Caption = 'Refills'
          end
          object spnRefills: TUpDown
            Left = 173
            Top = 94
            Width = 16
            Height = 21
            Associate = txtRefills
            Max = 11
            TabOrder = 9
          end
          object grpPickup: TGroupBox
            Left = 193
            Top = 81
            Width = 252
            Height = 42
            Caption = 'Pick Up'
            TabOrder = 10
            object radPickWindow: TRadioButton
              AlignWithMargins = True
              Left = 178
              Top = 18
              Width = 72
              Height = 19
              Align = alLeft
              Caption = '&Window'
              TabOrder = 2
              OnClick = ControlChange
            end
            object radPickMail: TRadioButton
              AlignWithMargins = True
              Left = 123
              Top = 18
              Width = 49
              Height = 19
              Align = alLeft
              Caption = '&Mail'
              TabOrder = 1
              OnClick = ControlChange
            end
            object radPickPark: TRadioButton
              AlignWithMargins = True
              Left = 5
              Top = 18
              Width = 53
              Height = 19
              Align = alLeft
              Caption = '&Park'
              TabOrder = 0
              OnClick = ControlChange
            end
          end
          object cboPriority: TORComboBox
            Left = 503
            Top = 112
            Width = 72
            Height = 21
            Anchors = [akTop, akRight]
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Priority'
            Color = clWindow
            DropDownCount = 8
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
            TabOrder = 11
            Text = ''
            OnChange = ControlChange
            OnKeyUp = cboPriorityKeyUp
            CharsNeedMatch = 1
          end
          object stcPI: TStaticText
            Left = 2
            Top = 139
            Width = 89
            Height = 17
            Caption = 'Patient Instruction'
            TabOrder = 19
            Visible = False
          end
          object chkPtInstruct: TCheckBox
            Left = 4
            Top = 153
            Width = 14
            Height = 21
            Hint = 
              'A check in this box WILL INCLUDE the patientins tructions in thi' +
              's order.'
            BiDiMode = bdLeftToRight
            Color = clBtnFace
            ParentBiDiMode = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 20
            Visible = False
            OnClick = chkPtInstructClick
          end
          object memPI: TMemo
            Left = 23
            Top = 155
            Width = 552
            Height = 35
            Hint = 
              'A check in this box below WILL INCLUDE the patients instructions' +
              ' in this order.'
            TabStop = False
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ReadOnly = True
            ScrollBars = ssVertical
            ShowHint = True
            TabOrder = 21
            Visible = False
            OnClick = memPIClick
            OnKeyDown = memPIKeyDown
          end
          object memDrugMsg: TMemo
            Left = 37
            Top = 220
            Width = 538
            Height = 51
            Anchors = [akLeft, akRight, akBottom]
            Color = clCream
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 22
            Visible = False
          end
          object lblAdminSch: TMemo
            Left = 344
            Top = 136
            Width = 76
            Height = 15
            Anchors = [akLeft, akTop, akRight]
            Color = clCream
            ParentShowHint = False
            ReadOnly = True
            ScrollBars = ssVertical
            ShowHint = True
            TabOrder = 18
            Visible = False
          end
          object lblAdminTime: TVA508StaticText
            Name = 'lblAdminTime'
            Left = 164
            Top = 132
            Width = 64
            Height = 15
            Alignment = taLeftJustify
            Caption = 'lblAdminTime'
            TabOrder = 17
            TabStop = True
            ShowAccelChar = True
          end
          object chkTitration: TCheckBox
            Left = 503
            Top = 74
            Width = 80
            Height = 17
            Anchors = [akTop, akRight]
            Caption = 'Titration'
            TabOrder = 2
            OnClick = chkTitrationClick
          end
          object cboIndication: TIndicationsComboBox
            Left = 5
            Top = 20
            Width = 205
            Height = 21
            Hint = 
              'Indication must be entered. Indication should be between 3 and 4' +
              '0 characters.'
            Style = orcsDropDown
            AutoSelect = True
            Caption = ''
            Color = clWindow
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 40
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 0
            Text = ''
            OnChange = cboIndicationChange
            OnExit = cboIndicationExit
            OnKeyUp = cboIndicationKeyUp
            CharsNeedMatch = 1
          end
        end
        object cboXSequence: TORComboBox
          Left = 438
          Top = 122
          Width = 64
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
          Caption = 'Sequence'
          Color = clWindow
          DropDownCount = 8
          Items.Strings = (
            'and'
            'then')
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 5
          Text = ''
          Visible = False
          OnChange = cboXSequenceChange
          OnEnter = cboXSequenceEnter
          OnExit = cboXSequenceExit
          OnKeyDown = memMessageKeyDown
          OnKeyUp = cboXSequenceKeyUp
          CharsNeedMatch = 1
        end
      end
    end
  end
  inherited pnlMessage: TPanel [5]
    Left = 31
    Top = 200
    ParentBackground = False
    TabOrder = 1
    OnEnter = pnlMessageEnter
    ExplicitLeft = 31
    ExplicitTop = 200
    inherited imgMessage: TImage
      Left = 2
      ExplicitLeft = 2
    end
  end
  inherited cmdAccept: TButton [6]
    Left = 508
    Top = 671
    Anchors = [akRight, akBottom]
    TabOrder = 4
    TabStop = False
    Visible = False
    ExplicitLeft = 508
    ExplicitTop = 671
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 40
    Top = 56
    Data = (
      (
        'Component = txtMed'
        'Text = Medication'
        'Status = stsOK')
      (
        'Component = btnSelect'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Text = Order Sig'
        'Status = stsOK')
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
        'Component = frmODMeds'
        'Status = stsDefault')
      (
        'Component = PageControl'
        'Status = stsDefault')
      (
        'Component = PageFields'
        'Status = stsDefault')
      (
        'Component = PageMeds'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = grdDoses'
        'Status = stsDefault')
      (
        'Component = lblGuideline'
        'Status = stsDefault')
      (
        'Component = tabDose'
        'Status = stsDefault')
      (
        'Component = cboDosage'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = btnXInsert'
        'Status = stsDefault')
      (
        'Component = btnXRemove'
        'Status = stsDefault')
      (
        'Component = pnlXAdminTime'
        'Status = stsDefault')
      (
        'Component = cboXDosage'
        'Status = stsDefault')
      (
        'Component = cboXRoute'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = pnlXDurationButton'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = spnXDuration'
        'Status = stsDefault')
      (
        'Component = pnlXSchedule'
        'Status = stsDefault')
      (
        'Component = cboXSchedule'
        'Status = stsDefault')
      (
        'Component = chkXPRN'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = lblQtyMsg'
        'Status = stsDefault')
      (
        'Component = txtSupply'
        'Status = stsDefault')
      (
        'Component = spnSupply'
        'Status = stsDefault')
      (
        'Component = txtQuantity'
        'Status = stsDefault')
      (
        'Component = spnQuantity'
        'Status = stsDefault')
      (
        'Component = txtRefills'
        'Status = stsDefault')
      (
        'Component = spnRefills'
        'Status = stsDefault')
      (
        'Component = grpPickup'
        'Status = stsDefault')
      (
        'Component = radPickWindow'
        'Status = stsDefault')
      (
        'Component = radPickMail'
        'Status = stsDefault')
      (
        'Component = radPickPark'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = stcPI'
        'Status = stsDefault')
      (
        'Component = chkPtInstruct'
        'Status = stsDefault')
      (
        'Component = memPI'
        'Status = stsDefault')
      (
        'Component = memDrugMsg'
        'Status = stsDefault')
      (
        'Component = lblAdminSch'
        'Status = stsDefault')
      (
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = chkTitration'
        'Status = stsDefault')
      (
        'Component = cboXSequence'
        'Status = stsDefault')
      (
        'Component = pnlMeds'
        'Status = stsDefault')
      (
        'Component = lstQuick'
        'Status = stsDefault')
      (
        'Component = lstAll'
        'Status = stsDefault')
      (
        'Component = cboIndication'
        
          'Text = Indication for use. Indication must be entered and should' +
          ' be between 3 and 40 characters.'
        'Status = stsOK'))
  end
  inherited tmrBringToFront: TTimer
    Left = 88
    Top = 56
  end
  object dlgStart: TORDateTimeDlg
    FMDateTime = 3001101.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 84
    Top = 96
  end
  object timCheckChanges: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timCheckChangesTimer
    Left = 133
    Top = 56
  end
  object popDuration: TPopupMenu
    AutoHotkeys = maManual
    Left = 36
    Top = 97
    object popBlank: TMenuItem
      Caption = '(no selection)'
      OnClick = popDurationClick
    end
    object months1: TMenuItem
      Tag = 5
      Caption = 'months'
      OnClick = popDurationClick
    end
    object weeks1: TMenuItem
      Tag = 4
      Caption = 'weeks'
      OnClick = popDurationClick
    end
    object popDays: TMenuItem
      Tag = 3
      Caption = 'days'
      OnClick = popDurationClick
    end
    object hours1: TMenuItem
      Tag = 2
      Caption = 'hours'
      OnClick = popDurationClick
    end
    object minutes1: TMenuItem
      Tag = 1
      Caption = 'minutes'
      OnClick = popDurationClick
    end
  end
end
