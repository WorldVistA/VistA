inherited frmODDiet: TfrmODDiet
  Left = 541
  Top = 398
  Width = 650
  Height = 375
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Diet Order'
  Constraints.MinHeight = 305
  Constraints.MinWidth = 528
  ExplicitWidth = 650
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  object nbkDiet: TPageControl [0]
    Left = 0
    Top = 0
    Width = 634
    Height = 194
    ActivePage = pgeTubefeeding
    Align = alTop
    TabOrder = 4
    TabStop = False
    OnChange = nbkDietChange
    OnChanging = nbkDietChanging
    object pgeDiet: TTabSheet
      Caption = 'Diet'
      object lblDietAvail: TLabel
        Left = 4
        Top = 0
        Width = 127
        Height = 13
        Caption = 'Available Diet Components'
      end
      object lblDietSelect: TLabel
        Left = 200
        Top = 0
        Width = 126
        Height = 13
        Caption = 'Selected Diet Components'
      end
      object lblComment: TLabel
        Left = 200
        Top = 119
        Width = 92
        Height = 13
        Caption = 'Special Instructions'
      end
      object lblStart: TLabel
        Left = 393
        Top = 0
        Width = 96
        Height = 13
        Caption = 'Effective Date/Time'
      end
      object lblStop: TLabel
        Left = 393
        Top = 39
        Width = 100
        Height = 13
        Caption = 'Expiration Date/Time'
      end
      object lblDelivery: TLabel
        Left = 393
        Top = 77
        Width = 38
        Height = 13
        Caption = 'Delivery'
      end
      object cboDietAvail: TORComboBox
        Left = 3
        Top = 19
        Width = 188
        Height = 140
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Available Diet Components'
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
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnExit = cboDietAvailExit
        OnMouseClick = cboDietAvailMouseClick
        OnNeedData = cboDietAvailNeedData
        CharsNeedMatch = 1
      end
      object lstDietSelect: TORListBox
        Left = 200
        Top = 14
        Width = 185
        Height = 71
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Caption = 'Selected Diet Components'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object cmdRemove: TButton
        Left = 313
        Top = 85
        Width = 72
        Height = 17
        Caption = 'Remove'
        TabOrder = 2
        OnClick = cmdRemoveClick
      end
      object txtDietComment: TCaptionEdit
        Left = 200
        Top = 133
        Width = 308
        Height = 21
        MaxLength = 80
        TabOrder = 3
        OnChange = DietChange
        Caption = 'Special Instructions'
      end
      object calDietStart: TORDateBox
        Left = 393
        Top = 14
        Width = 115
        Height = 21
        TabOrder = 4
        Text = 'Now'
        OnChange = DietChange
        DateOnly = False
        RequireTime = False
        Caption = 'Effective Date/Time'
      end
      object calDietStop: TORDateBox
        Left = 393
        Top = 52
        Width = 115
        Height = 21
        TabOrder = 5
        OnChange = DietChange
        DateOnly = False
        RequireTime = False
        Caption = 'Expiration Date/Time'
      end
      object cboDelivery: TORComboBox
        Left = 393
        Top = 90
        Width = 115
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Delivery'
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
        TabOrder = 6
        Text = ''
        OnChange = DietChange
        CharsNeedMatch = 1
      end
      object chkCancelTubefeeding: TCheckBox
        Left = 393
        Top = 114
        Width = 115
        Height = 17
        Caption = 'Cancel Tubefeeding'
        State = cbGrayed
        TabOrder = 7
        Visible = False
        OnClick = DietChange
      end
    end
    object pgeOutPt: TTabSheet
      Caption = 'Outpatient Meals'
      object lblOPStart: TLabel
        Left = 292
        Top = 1
        Width = 48
        Height = 13
        Caption = 'Start Date'
      end
      object lblOPStop: TLabel
        Left = 292
        Top = 37
        Width = 45
        Height = 13
        Caption = 'End Date'
      end
      object lblOPDietAvail: TLabel
        Left = 0
        Top = 1
        Width = 70
        Height = 13
        Caption = 'Available Diets'
      end
      object lblOPComment: TLabel
        Left = 4
        Top = 128
        Width = 92
        Height = 13
        Caption = 'Special Instructions'
      end
      object lblOPDelivery: TLabel
        Left = 292
        Top = 74
        Width = 38
        Height = 13
        Caption = 'Delivery'
      end
      object lblOPSelect: TLabel
        Left = 0
        Top = 39
        Width = 64
        Height = 13
        Caption = 'Selected Diet'
      end
      object grpOPMeal: TKeyClickRadioGroup
        Left = 168
        Top = 11
        Width = 110
        Height = 107
        Caption = ' Meal '
        ItemIndex = 3
        Items.Strings = (
          'Breakfast'
          'Lunch'
          'Evening'
          '<none selected>')
        TabOrder = 3
        TabStop = True
        OnClick = grpOPMealClick
      end
      object grpOPDoW: TGroupBox
        Left = 415
        Top = 5
        Width = 93
        Height = 155
        Caption = 'Days of Week'
        TabOrder = 8
        object chkOPMonday: TCheckBox
          Left = 8
          Top = 15
          Width = 80
          Height = 17
          Caption = 'Monday'
          TabOrder = 0
          OnClick = OPChange
        end
        object chkOPTuesday: TCheckBox
          Left = 8
          Top = 35
          Width = 80
          Height = 17
          Caption = 'Tuesday'
          TabOrder = 1
          OnClick = OPChange
        end
        object chkOPWednesday: TCheckBox
          Left = 8
          Top = 54
          Width = 80
          Height = 17
          Caption = 'Wednesday'
          TabOrder = 2
          OnClick = OPChange
        end
        object chkOPThursday: TCheckBox
          Left = 8
          Top = 73
          Width = 80
          Height = 17
          Caption = 'Thursday'
          TabOrder = 3
          OnClick = OPChange
        end
        object chkOPFriday: TCheckBox
          Left = 8
          Top = 92
          Width = 80
          Height = 17
          Caption = 'Friday'
          TabOrder = 4
          OnClick = OPChange
        end
        object chkOPSaturday: TCheckBox
          Left = 8
          Top = 111
          Width = 80
          Height = 17
          Caption = 'Saturday'
          TabOrder = 5
          OnClick = OPChange
        end
        object chkOPSunday: TCheckBox
          Left = 8
          Top = 130
          Width = 80
          Height = 17
          Caption = 'Sunday'
          TabOrder = 6
          OnClick = OPChange
        end
      end
      object calOPStart: TORDateBox
        Left = 292
        Top = 14
        Width = 120
        Height = 21
        TabOrder = 4
        OnChange = calOPStartChange
        OnEnter = calOPStartEnter
        OnExit = calOPStartExit
        DateOnly = True
        RequireTime = False
        Caption = 'Start Date'
      end
      object calOPStop: TORDateBox
        Left = 292
        Top = 50
        Width = 120
        Height = 21
        TabOrder = 5
        OnChange = calOPStopChange
        DateOnly = True
        RequireTime = False
        Caption = 'End Date'
      end
      object cboOPDietAvail: TORComboBox
        Left = 0
        Top = 16
        Width = 157
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Available Diet Components'
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
        TabOrder = 0
        Text = ''
        OnExit = cboDietAvailExit
        OnKeyDown = cboOPDietAvailKeyDown
        OnMouseClick = cboOPDietAvailMouseClick
        CharsNeedMatch = 1
      end
      object txtOPDietComment: TCaptionEdit
        Left = 3
        Top = 143
        Width = 404
        Height = 21
        MaxLength = 80
        TabOrder = 11
        OnChange = OPChange
        Caption = 'Special Instructions'
      end
      object cboOPDelivery: TORComboBox
        Left = 292
        Top = 86
        Width = 120
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Delivery'
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
        TabOrder = 6
        Text = ''
        OnChange = OPChange
        CharsNeedMatch = 1
      end
      object lstOPDietSelect: TORListBox
        Left = 0
        Top = 53
        Width = 156
        Height = 56
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Caption = 'Selected Diet Components'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = OPChange
      end
      object cmdOPRemove: TButton
        Left = 85
        Top = 110
        Width = 72
        Height = 17
        Caption = 'Remove'
        TabOrder = 2
        OnClick = cmdOPRemoveClick
      end
      object chkOPCancelTubefeeding: TCheckBox
        Left = 292
        Top = 112
        Width = 115
        Height = 17
        Caption = 'Cancel Tubefeeding'
        State = cbGrayed
        TabOrder = 7
        Visible = False
        OnClick = OPChange
      end
    end
    object pgeTubefeeding: TTabSheet
      Caption = 'Tubefeeding'
      object lblTFProductList: TLabel
        Left = 4
        Top = 0
        Width = 105
        Height = 13
        Caption = 'Tubefeeding Products'
      end
      object lblTFComment: TLabel
        Left = 4
        Top = 119
        Width = 92
        Height = 13
        Caption = 'Special Instructions'
      end
      object lblTFStrength: TLabel
        Left = 288
        Top = 0
        Width = 40
        Height = 13
        Caption = 'Strength'
      end
      object lblTFQuantity: TLabel
        Left = 352
        Top = 0
        Width = 39
        Height = 13
        Caption = 'Quantity'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = lblTFQuantityClick
      end
      object lblTFProduct: TLabel
        Left = 152
        Top = 0
        Width = 37
        Height = 13
        Caption = 'Product'
      end
      object lblTFAmount: TLabel
        Left = 428
        Top = 0
        Width = 36
        Height = 13
        Caption = 'Amount'
      end
      object lblOPTFStart: TLabel
        Left = 341
        Top = 90
        Width = 51
        Height = 13
        Caption = 'Start Date:'
      end
      object cboProduct: TORComboBox
        Left = 4
        Top = 14
        Width = 140
        Height = 97
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Tubefeeding Products'
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
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnExit = cboProductExit
        OnMouseClick = cboProductMouseClick
        CharsNeedMatch = 1
      end
      object txtTFComment: TCaptionEdit
        Left = 6
        Top = 133
        Width = 504
        Height = 21
        MaxLength = 240
        TabOrder = 8
        OnChange = TFChange
        Caption = 'Special Instructions'
      end
      object grdSelected: TCaptionStringGrid
        Left = 152
        Top = 14
        Width = 356
        Height = 63
        ColCount = 4
        DefaultColWidth = 88
        DefaultRowHeight = 19
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 1
        OnDrawCell = grdSelectedDrawCell
        OnMouseMove = grdSelectedMouseMove
        OnSelectCell = grdSelectedSelectCell
        Caption = 'Selected Products'
      end
      object cmdTFRemove: TButton
        Left = 436
        Top = 77
        Width = 72
        Height = 17
        Caption = 'Remove'
        TabOrder = 4
        OnClick = cmdTFRemoveClick
      end
      object chkCancelTrays: TCheckBox
        Left = 152
        Top = 96
        Width = 153
        Height = 17
        Caption = 'Cancel Future TRAY Orders'
        TabOrder = 5
        OnClick = TFChange
      end
      object txtQuantity: TCaptionEdit
        Tag = -1
        Left = 151
        Top = 124
        Width = 93
        Height = 19
        Hint = 
          'Enter quantity as 2000 K, 100 ML/HOUR, 8 OZ/TID, etc; total quan' +
          'tity may not exceed 5000ml.'
        Ctl3D = False
        ParentCtl3D = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Visible = False
        OnChange = txtQuantityChange
        OnEnter = txtQuantityEnter
        OnExit = txtQuantityExit
        OnKeyDown = txtQuantityKeyDown
        Caption = 'Quantity'
      end
      object cboStrength: TCaptionComboBox
        Tag = -1
        Left = 252
        Top = 124
        Width = 53
        Height = 21
        Style = csDropDownList
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        Visible = False
        OnChange = cboStrengthChange
        OnEnter = cboStrengthEnter
        OnExit = cboStrengthExit
        OnKeyDown = cboStrengthKeyDown
        Items.Strings = (
          '1/4'
          '1/2'
          '3/4'
          'FULL')
        Caption = 'Strength'
      end
      object calOPTFStart: TORDateBox
        Left = 341
        Top = 104
        Width = 169
        Height = 21
        TabStop = False
        TabOrder = 7
        Visible = False
        OnChange = TFChange
        DateOnly = False
        RequireTime = False
        Caption = 'Start Date:'
      end
      object cboOPTFRecurringMeals: TORComboBox
        Left = 342
        Top = 105
        Width = 160
        Height = 21
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
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '12'
        TabOrder = 6
        TabStop = True
        Text = ''
        OnChange = TFChange
        CharsNeedMatch = 1
      end
    end
    object pgeEarlyLate: TTabSheet
      Caption = 'Early / Late Tray'
      object lblELStart: TLabel
        Left = 287
        Top = 2
        Width = 48
        Height = 13
        Caption = 'Start Date'
      end
      object lblELStop: TLabel
        Left = 287
        Top = 46
        Width = 45
        Height = 13
        Caption = 'End Date'
      end
      object grpMeal: TKeyClickRadioGroup
        Left = 4
        Top = 2
        Width = 106
        Height = 93
        Caption = ' Meal '
        ItemIndex = 3
        Items.Strings = (
          'Breakfast'
          'Lunch'
          'Evening'
          '<none selected>')
        TabOrder = 0
        TabStop = True
        OnClick = grpMealClick
      end
      object grpMealTime: TGroupBox
        Left = 114
        Top = 4
        Width = 161
        Height = 93
        Caption = ' Meal Times '
        TabOrder = 1
        object lblNoTimes: TLabel
          Left = 29
          Top = 44
          Width = 96
          Height = 13
          Caption = 'No meal times listed.'
          Visible = False
        end
        object radET1: TRadioButton
          Left = 8
          Top = 18
          Width = 56
          Height = 17
          TabOrder = 0
          Visible = False
          OnClick = ELChange
        end
        object radET2: TRadioButton
          Left = 8
          Top = 43
          Width = 56
          Height = 17
          TabOrder = 1
          Visible = False
          OnClick = ELChange
        end
        object radET3: TRadioButton
          Left = 8
          Top = 68
          Width = 56
          Height = 17
          TabOrder = 2
          Visible = False
          OnClick = ELChange
        end
        object radLT1: TRadioButton
          Left = 92
          Top = 18
          Width = 56
          Height = 17
          TabOrder = 3
          Visible = False
          OnClick = ELChange
        end
        object radLT2: TRadioButton
          Left = 92
          Top = 43
          Width = 56
          Height = 17
          TabOrder = 4
          Visible = False
          OnClick = ELChange
        end
        object radLT3: TRadioButton
          Left = 92
          Top = 68
          Width = 56
          Height = 17
          TabOrder = 5
          Visible = False
          OnClick = ELChange
        end
      end
      object calELStart: TORDateBox
        Left = 287
        Top = 15
        Width = 120
        Height = 21
        TabOrder = 2
        OnChange = calELStartChange
        OnEnter = calELStartEnter
        OnExit = calELStartExit
        DateOnly = True
        RequireTime = False
        Caption = 'Start Date'
      end
      object calELStop: TORDateBox
        Left = 287
        Top = 60
        Width = 120
        Height = 21
        TabOrder = 4
        OnChange = calELStopChange
        DateOnly = True
        RequireTime = False
        Caption = 'End Date'
      end
      object grpDoW: TGroupBox
        Left = 415
        Top = 2
        Width = 93
        Height = 152
        Caption = 'Days of Week'
        TabOrder = 5
        object chkMonday: TCheckBox
          Left = 8
          Top = 16
          Width = 80
          Height = 17
          Caption = 'Monday'
          TabOrder = 0
          OnClick = ELChange
        end
        object chkTuesday: TCheckBox
          Left = 8
          Top = 35
          Width = 80
          Height = 17
          Caption = 'Tuesday'
          TabOrder = 1
          OnClick = ELChange
        end
        object chkWednesday: TCheckBox
          Left = 8
          Top = 54
          Width = 80
          Height = 17
          Caption = 'Wednesday'
          TabOrder = 2
          OnClick = ELChange
        end
        object chkThursday: TCheckBox
          Left = 8
          Top = 73
          Width = 80
          Height = 17
          Caption = 'Thursday'
          TabOrder = 3
          OnClick = ELChange
        end
        object chkFriday: TCheckBox
          Left = 8
          Top = 92
          Width = 80
          Height = 17
          Caption = 'Friday'
          TabOrder = 4
          OnClick = ELChange
        end
        object chkSaturday: TCheckBox
          Left = 8
          Top = 111
          Width = 80
          Height = 17
          Caption = 'Saturday'
          TabOrder = 5
          OnClick = ELChange
        end
        object chkSunday: TCheckBox
          Left = 9
          Top = 130
          Width = 80
          Height = 17
          Caption = 'Sunday'
          TabOrder = 6
          OnClick = ELChange
        end
      end
      object chkBagged: TCheckBox
        Left = 4
        Top = 120
        Width = 85
        Height = 17
        Caption = 'Bagged Meal'
        TabOrder = 6
        OnClick = ELChange
      end
      object cboOPELRecurringMeals: TORComboBox
        Left = 287
        Top = 15
        Width = 121
        Height = 21
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
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '12'
        TabOrder = 3
        TabStop = True
        Text = ''
        OnChange = ELChange
        CharsNeedMatch = 1
      end
    end
    object pgeIsolations: TTabSheet
      Caption = 'Isolations / Precautions'
      object lblIsolation: TLabel
        Left = 4
        Top = 0
        Width = 123
        Height = 13
        Caption = 'Select Type of Precaution'
      end
      object lblIPComment: TLabel
        Left = 4
        Top = 119
        Width = 54
        Height = 13
        Caption = 'Instructions'
      end
      object lblIPCurrent: TLabel
        Left = 224
        Top = 0
        Width = 76
        Height = 13
        Caption = 'Current Isolation'
      end
      object lstIsolation: TORListBox
        Left = 4
        Top = 14
        Width = 212
        Height = 97
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Caption = 'Select Type of Precaution'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = IPChange
      end
      object txtIPComment: TCaptionEdit
        Left = 4
        Top = 133
        Width = 504
        Height = 21
        MaxLength = 240
        TabOrder = 2
        OnChange = IPChange
        Caption = 'Instructions'
      end
      object txtIPCurrent: TCaptionEdit
        Left = 224
        Top = 14
        Width = 212
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = '<none>'
        Caption = 'Current Isolation'
      end
    end
    object pgeAdditional: TTabSheet
      Caption = 'Additional Order'
      object lblAddlOrder: TLabel
        Left = 4
        Top = 24
        Width = 125
        Height = 13
        Caption = 'Enter Additional Diet Order'
      end
      object lblOPAOStart: TLabel
        Left = 6
        Top = 72
        Width = 51
        Height = 13
        Caption = 'Start Date:'
      end
      object txtAOComment: TCaptionEdit
        Left = 4
        Top = 38
        Width = 504
        Height = 21
        MaxLength = 80
        TabOrder = 1
        OnChange = AOChange
        Caption = 'Enter Additional Diet Order'
      end
      object calOPAOStart: TORDateBox
        Left = 54
        Top = 88
        Width = 169
        Height = 21
        TabStop = False
        TabOrder = 4
        Visible = False
        OnChange = AOChange
        DateOnly = False
        RequireTime = False
        Caption = 'Start Date:'
      end
      object cboOPAORecurringMeals: TORComboBox
        Left = 6
        Top = 88
        Width = 168
        Height = 21
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
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '12'
        TabOrder = 2
        TabStop = True
        Text = ''
        OnChange = AOChange
        CharsNeedMatch = 1
      end
    end
  end
  inherited memOrder: TCaptionMemo
    Top = 213
    Width = 412
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akRight, akBottom]
    ExplicitTop = 213
    ExplicitWidth = 412
  end
  inherited cmdAccept: TButton
    Left = 427
    Top = 213
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 427
    ExplicitTop = 213
  end
  inherited cmdQuit: TButton
    Left = 426
    Top = 242
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 3
    ExplicitLeft = 426
    ExplicitTop = 242
  end
  inherited pnlMessage: TPanel
    Top = 202
    Height = 57
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    ExplicitTop = 202
    ExplicitHeight = 57
    inherited imgMessage: TImage
      Top = 10
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitTop = 10
    end
    inherited memMessage: TRichEdit
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitHeight = 45
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 16
    Data = (
      (
        'Component = nbkDiet'
        'Status = stsDefault')
      (
        'Component = pgeDiet'
        'Status = stsDefault')
      (
        'Component = cboDietAvail'
        'Status = stsDefault')
      (
        'Component = lstDietSelect'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = txtDietComment'
        'Status = stsDefault')
      (
        'Component = calDietStart'
        'Text = Effective Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calDietStop'
        'Text = Expiration Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboDelivery'
        'Status = stsDefault')
      (
        'Component = chkCancelTubefeeding'
        'Status = stsDefault')
      (
        'Component = pgeOutPt'
        'Status = stsDefault')
      (
        'Component = grpOPMeal'
        'Status = stsDefault')
      (
        'Component = grpOPDoW'
        'Status = stsDefault')
      (
        'Component = chkOPMonday'
        'Status = stsDefault')
      (
        'Component = chkOPTuesday'
        'Status = stsDefault')
      (
        'Component = chkOPWednesday'
        'Status = stsDefault')
      (
        'Component = chkOPThursday'
        'Status = stsDefault')
      (
        'Component = chkOPFriday'
        'Status = stsDefault')
      (
        'Component = chkOPSaturday'
        'Status = stsDefault')
      (
        'Component = chkOPSunday'
        'Status = stsDefault')
      (
        'Component = calOPStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calOPStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboOPDietAvail'
        'Status = stsDefault')
      (
        'Component = txtOPDietComment'
        'Status = stsDefault')
      (
        'Component = cboOPDelivery'
        'Status = stsDefault')
      (
        'Component = lstOPDietSelect'
        'Status = stsDefault')
      (
        'Component = cmdOPRemove'
        'Status = stsDefault')
      (
        'Component = chkOPCancelTubefeeding'
        'Status = stsDefault')
      (
        'Component = pgeTubefeeding'
        'Status = stsDefault')
      (
        'Component = cboProduct'
        'Status = stsDefault')
      (
        'Component = txtTFComment'
        'Status = stsDefault')
      (
        'Component = grdSelected'
        'Status = stsDefault')
      (
        'Component = cmdTFRemove'
        'Status = stsDefault')
      (
        'Component = chkCancelTrays'
        'Status = stsDefault')
      (
        'Component = txtQuantity'
        'Status = stsDefault')
      (
        'Component = cboStrength'
        'Status = stsDefault')
      (
        'Component = calOPTFStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboOPTFRecurringMeals'
        'Status = stsDefault')
      (
        'Component = pgeEarlyLate'
        'Status = stsDefault')
      (
        'Component = grpMeal'
        'Status = stsDefault')
      (
        'Component = grpMealTime'
        'Status = stsDefault')
      (
        'Component = radET1'
        'Status = stsDefault')
      (
        'Component = radET2'
        'Status = stsDefault')
      (
        'Component = radET3'
        'Status = stsDefault')
      (
        'Component = radLT1'
        'Status = stsDefault')
      (
        'Component = radLT2'
        'Status = stsDefault')
      (
        'Component = radLT3'
        'Status = stsDefault')
      (
        'Component = calELStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calELStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = grpDoW'
        'Status = stsDefault')
      (
        'Component = chkMonday'
        'Status = stsDefault')
      (
        'Component = chkTuesday'
        'Status = stsDefault')
      (
        'Component = chkWednesday'
        'Status = stsDefault')
      (
        'Component = chkThursday'
        'Status = stsDefault')
      (
        'Component = chkFriday'
        'Status = stsDefault')
      (
        'Component = chkSaturday'
        'Status = stsDefault')
      (
        'Component = chkSunday'
        'Status = stsDefault')
      (
        'Component = chkBagged'
        'Status = stsDefault')
      (
        'Component = cboOPELRecurringMeals'
        'Status = stsDefault')
      (
        'Component = pgeIsolations'
        'Status = stsDefault')
      (
        'Component = lstIsolation'
        'Status = stsDefault')
      (
        'Component = txtIPComment'
        'Status = stsDefault')
      (
        'Component = txtIPCurrent'
        'Status = stsDefault')
      (
        'Component = pgeAdditional'
        'Status = stsDefault')
      (
        'Component = txtAOComment'
        'Status = stsDefault')
      (
        'Component = calOPAOStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboOPAORecurringMeals'
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
        'Component = frmODDiet'
        'Status = stsDefault'))
  end
end
