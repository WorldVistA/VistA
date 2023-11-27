inherited frmODRad: TfrmODRad
  Tag = 160
  Left = 282
  Top = 225
  Width = 586
  Height = 404
  Caption = 'Order an Imaging Procedure'
  Constraints.MinHeight = 497
  Constraints.MinWidth = 721
  ExplicitWidth = 586
  ExplicitHeight = 404
  PixelsPerInch = 120
  TextHeight = 16
  inherited memOrder: TCaptionMemo
    Left = 0
    Top = 401
    Width = 603
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 0
    ExplicitTop = 401
    ExplicitWidth = 603
  end
  object FRadCommonCombo: TORListBox [1]
    Left = 516
    Top = 446
    Width = 149
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = False
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
  end
  object pnlLeft: TPanel [2]
    Left = 0
    Top = 0
    Width = 265
    Height = 395
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object lblDrug: TLabel
      Left = 0
      Top = 42
      Width = 114
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Imaging Procedure'
    end
    object lblAvailMod: TLabel
      Left = 0
      Top = 209
      Width = 115
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Available Modifiers'
    end
    object lblImType: TLabel
      Left = 2
      Top = 0
      Width = 83
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Imaging Type'
      OnClick = lblImTypeClick
    end
    object lblSelectMod: TLabel
      Left = 134
      Top = 209
      Width = 112
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Selected Modifiers'
    end
    object cboImType: TORComboBox
      Left = 0
      Top = 16
      Width = 261
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Imaging Type'
      Color = clWindow
      DropDownCount = 8
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
      TabOrder = 0
      Text = ''
      OnChange = cboImTypeChange
      OnDropDownClose = cboImTypeDropDownClose
      OnExit = cboImTypeExit
      CharsNeedMatch = 1
    end
    object lstSelectMod: TORListBox
      Left = 134
      Top = 226
      Width = 126
      Height = 84
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExtendedSelect = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Caption = 'Selected Modifiers'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object cboProcedure: TORComboBox
      Left = 0
      Top = 58
      Width = 261
      Height = 150
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Imaging Procedure'
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
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnClick = cboProcedureSelect
      OnExit = cboProcedureExit
      OnNeedData = cboProcedureNeedData
      CharsNeedMatch = 1
    end
    object cboAvailMod: TORComboBox
      Left = 0
      Top = 226
      Width = 126
      Height = 116
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Available Modifiers'
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
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      OnKeyDown = cboAvailModKeyDown
      OnMouseClick = cboAvailModMouseClick
      CharsNeedMatch = 1
    end
    object cmdRemove: TButton
      Left = 135
      Top = 314
      Width = 126
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Remove'
      TabOrder = 5
      OnClick = cmdRemoveClick
    end
  end
  object pnlRightBase: TPanel [3]
    Left = 265
    Top = 0
    Width = 445
    Height = 396
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object pnlRight: TPanel
      Left = 0
      Top = 156
      Width = 445
      Height = 240
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 446
      object lblRequestDate: TLabel
        Left = 5
        Top = 6
        Width = 80
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Date Desired'
      end
      object lblUrgency: TLabel
        Left = 128
        Top = 6
        Width = 51
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Urgency'
      end
      object lblTransport: TLabel
        Left = 251
        Top = 6
        Width = 58
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Transport'
      end
      object lblCategory: TLabel
        Left = 5
        Top = 52
        Width = 55
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Category'
      end
      object lblSubmit: TLabel
        Left = 190
        Top = 55
        Width = 61
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Submit To'
      end
      object lblLastExam: TLabel
        Left = 5
        Top = 101
        Width = 167
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Exams Over the Last 7 Days'
      end
      object lblAskSubmit: TLabel
        Left = 549
        Top = 127
        Width = 3
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Visible = False
      end
      object lblPreOp: TLabel
        Left = 244
        Top = 192
        Width = 107
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'PreOp Scheduled'
      end
      object calPreOp: TORDateBox
        Left = 244
        Top = 209
        Width = 118
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 9
        OnChange = calPreOpChange
        OnExit = calPreOpExit
        DateOnly = False
        RequireTime = False
        Caption = 'PreOp Scheduled'
      end
      object chkIsolation: TCheckBox
        Left = 244
        Top = 116
        Width = 119
        Height = 21
        Hint = 'Is patient on isolation procedures?'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Isolation'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = ControlChange
        OnExit = chkIsolationExit
      end
      object calRequestDate: TORDateBox
        Left = 5
        Top = 22
        Width = 113
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 0
        OnChange = ControlChange
        DateOnly = False
        RequireTime = False
        Caption = 'Date Desired'
      end
      object cboUrgency: TORComboBox
        Left = 128
        Top = 22
        Width = 113
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Urgency'
        Color = clWindow
        DropDownCount = 8
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
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object cboTransport: TORComboBox
        Left = 251
        Top = 22
        Width = 113
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Transport'
        Color = clWindow
        DropDownCount = 8
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
        TabOrder = 2
        Text = ''
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object cboCategory: TORComboBox
        Left = 5
        Top = 70
        Width = 172
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Category'
        Color = clWindow
        DropDownCount = 8
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
        TabOrder = 3
        Text = ''
        OnChange = cboCategoryChange
        CharsNeedMatch = 1
      end
      object chkPreOp: TCheckBox
        Left = 180
        Top = 287
        Width = 75
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Pre-Op'
        TabOrder = 13
        Visible = False
        OnClick = ControlChange
      end
      object cboSubmit: TORComboBox
        Left = 190
        Top = 70
        Width = 174
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Submit To'
        Color = clWindow
        DropDownCount = 8
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
        TabOrder = 4
        Text = ''
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object lstLastExam: TORListBox
        Left = 5
        Top = 117
        Width = 230
        Height = 121
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = clBtnFace
        ExtendedSelect = False
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Caption = 'Exams Over the Last 7 Days'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object grpPregnant: TGroupBox
        Left = 241
        Top = 138
        Width = 195
        Height = 50
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Pregnant'
        TabOrder = 8
        object radPregnant: TRadioButton
          Left = 2
          Top = 21
          Width = 48
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Yes'
          TabOrder = 0
          OnClick = ControlChange
        end
        object radPregnantNo: TRadioButton
          Left = 58
          Top = 21
          Width = 43
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'No'
          TabOrder = 1
          OnClick = ControlChange
        end
        object radPregnantUnknown: TRadioButton
          Left = 107
          Top = 20
          Width = 81
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Unknown'
          TabOrder = 2
          OnClick = ControlChange
        end
      end
      object Submitlbl508: TVA508StaticText
        Name = 'Submitlbl508'
        Left = 190
        Top = 53
        Width = 183
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taLeftJustify
        Caption = 'Submit To (for screen R.)'
        Enabled = False
        TabOrder = 5
        Visible = False
        ShowAccelChar = True
      end
    end
    object pnlHandR: TPanel
      Left = 0
      Top = 0
      Width = 445
      Height = 156
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 446
      object lblHistory: TLabel
        Left = 0
        Top = 42
        Width = 149
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Clinical History (Optional)'
      end
      object lblReason: TLabel
        Left = 0
        Top = 0
        Width = 335
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Reason for Study (REQUIRED - 64 characters maximum)'
      end
      object memHistory: TCaptionMemo
        Left = 0
        Top = 58
        Width = 446
        Height = 98
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 3
        OnChange = ControlChange
        OnExit = memHistoryExit
        Caption = 'Clinical History (Optional)'
      end
      object txtReason: TCaptionEdit
        Left = 0
        Top = 16
        Width = 446
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        MaxLength = 64
        TabOrder = 0
        OnChange = ControlChange
        OnKeyPress = txtReasonKeyPress
        Caption = 'Reason for Study (REQUIRED)'
      end
    end
  end
  inherited cmdAccept: TButton
    Left = 612
    Top = 401
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 5
    ExplicitLeft = 612
    ExplicitTop = 401
  end
  inherited cmdQuit: TButton
    Left = 613
    Top = 434
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 6
    ExplicitLeft = 613
    ExplicitTop = 434
  end
  inherited pnlMessage: TPanel
    Left = 6
    Top = 391
    Width = 502
    Height = 68
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 2
    OnMouseUp = pnlMessageMouseUp
    ExplicitLeft = 6
    ExplicitTop = 391
    ExplicitWidth = 502
    ExplicitHeight = 68
    inherited imgMessage: TImage
      Left = 12
      Top = 11
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 12
      ExplicitTop = 11
    end
    inherited memMessage: TRichEdit
      Left = 68
      Width = 423
      Height = 53
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 68
      ExplicitWidth = 423
      ExplicitHeight = 53
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = FRadCommonCombo'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = cboImType'
        'Status = stsDefault')
      (
        'Component = lstSelectMod'
        'Status = stsDefault')
      (
        'Component = cboProcedure'
        'Status = stsDefault')
      (
        'Component = cboAvailMod'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = pnlRightBase'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = calPreOp'
        'Text = PreOp Schedule Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = chkIsolation'
        'Status = stsDefault')
      (
        'Component = calRequestDate'
        'Text = Desired Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = cboTransport'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = chkPreOp'
        'Status = stsDefault')
      (
        'Component = cboSubmit'
        'Status = stsDefault')
      (
        'Component = lstLastExam'
        'Status = stsDefault')
      (
        'Component = grpPregnant'
        'Text = Pregnant group box.  Disabled.  Patient is male.'
        'Status = stsOK')
      (
        'Component = radPregnant'
        'Status = stsDefault')
      (
        'Component = radPregnantNo'
        'Status = stsDefault')
      (
        'Component = radPregnantUnknown'
        'Status = stsDefault')
      (
        'Component = pnlHandR'
        'Status = stsDefault')
      (
        'Component = memHistory'
        'Status = stsDefault')
      (
        'Component = txtReason'
        
          'Text = Reason for Study REQUIRED text 64 characters maximum leng' +
          'th'
        'Status = stsOK')
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
        'Component = frmODRad'
        'Status = stsDefault')
      (
        'Component = Submitlbl508'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = memHistory
    OnStateQuery = VA508ComponentAccessibility1StateQuery
    Left = 336
    Top = 64
  end
  object VA508ComponentAccessibility2: TVA508ComponentAccessibility
    Component = grpPregnant
    Left = 536
    Top = 224
  end
end
