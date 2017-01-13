inherited frmODRad: TfrmODRad
  Tag = 160
  Left = 282
  Top = 225
  Width = 586
  Height = 404
  Caption = 'Order an Imaging Procedure'
  Constraints.MinHeight = 404
  Constraints.MinWidth = 586
  ExplicitWidth = 586
  ExplicitHeight = 404
  PixelsPerInch = 96
  TextHeight = 13
  inherited memOrder: TCaptionMemo
    Left = 0
    Top = 326
    Width = 490
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 0
    ExplicitTop = 326
    ExplicitWidth = 490
  end
  object FRadCommonCombo: TORListBox [1]
    Left = 419
    Top = 362
    Width = 121
    Height = 11
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = False
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
  end
  object pnlLeft: TORAutoPanel [2]
    Left = 0
    Top = 0
    Width = 215
    Height = 321
    Anchors = [akLeft, akTop, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object lblDrug: TLabel
      Left = 0
      Top = 34
      Width = 89
      Height = 13
      Caption = 'Imaging Procedure'
    end
    object lblAvailMod: TLabel
      Left = 0
      Top = 170
      Width = 88
      Height = 13
      Caption = 'Available Modifiers'
    end
    object lblImType: TLabel
      Left = 0
      Top = 0
      Width = 64
      Height = 13
      Caption = 'Imaging Type'
    end
    object lblSelectMod: TLabel
      Left = 109
      Top = 170
      Width = 87
      Height = 13
      Caption = 'Selected Modifiers'
    end
    object cboImType: TORComboBox
      Left = 0
      Top = 13
      Width = 212
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Imaging Type'
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
      OnChange = cboImTypeChange
      OnDropDownClose = cboImTypeDropDownClose
      OnExit = cboImTypeExit
      CharsNeedMatch = 1
    end
    object lstSelectMod: TORListBox
      Left = 109
      Top = 184
      Width = 102
      Height = 68
      ExtendedSelect = False
      ItemHeight = 13
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
      Top = 47
      Width = 212
      Height = 122
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Imaging Procedure'
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
      TabOrder = 1
      Text = ''
      OnClick = cboProcedureSelect
      OnExit = cboProcedureExit
      OnNeedData = cboProcedureNeedData
      CharsNeedMatch = 1
    end
    object cboAvailMod: TORComboBox
      Left = 0
      Top = 184
      Width = 102
      Height = 94
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
      Left = 110
      Top = 255
      Width = 102
      Height = 18
      Caption = 'Remove'
      TabOrder = 5
      OnClick = cmdRemoveClick
    end
  end
  object pnlRightBase: TORAutoPanel [3]
    Left = 215
    Top = 0
    Width = 362
    Height = 322
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object pnlRight: TORAutoPanel
      Left = 0
      Top = 127
      Width = 362
      Height = 195
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      object lblRequestDate: TLabel
        Left = 4
        Top = 5
        Width = 62
        Height = 13
        Caption = 'Date Desired'
      end
      object lblUrgency: TLabel
        Left = 104
        Top = 5
        Width = 40
        Height = 13
        Caption = 'Urgency'
      end
      object lblTransport: TLabel
        Left = 204
        Top = 5
        Width = 45
        Height = 13
        Caption = 'Transport'
      end
      object lblCategory: TLabel
        Left = 4
        Top = 42
        Width = 42
        Height = 13
        Caption = 'Category'
      end
      object lblSubmit: TLabel
        Left = 154
        Top = 45
        Width = 48
        Height = 13
        Caption = 'Submit To'
      end
      object lblLastExam: TLabel
        Left = 4
        Top = 82
        Width = 134
        Height = 13
        Caption = 'Exams Over the Last 7 Days'
      end
      object lblAskSubmit: TLabel
        Left = 446
        Top = 103
        Width = 3
        Height = 13
        Visible = False
      end
      object lblPreOp: TLabel
        Left = 198
        Top = 156
        Width = 84
        Height = 13
        Caption = 'PreOp Scheduled'
      end
      object calPreOp: TORDateBox
        Left = 198
        Top = 170
        Width = 96
        Height = 21
        TabOrder = 9
        OnChange = calPreOpChange
        OnExit = calPreOpExit
        DateOnly = False
        RequireTime = False
        Caption = 'PreOp Scheduled'
      end
      object chkIsolation: TCheckBox
        Left = 198
        Top = 94
        Width = 97
        Height = 17
        Hint = 'Is patient on isolation procedures?'
        Caption = 'Isolation'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = ControlChange
        OnExit = chkIsolationExit
      end
      object calRequestDate: TORDateBox
        Left = 4
        Top = 18
        Width = 92
        Height = 21
        TabOrder = 0
        OnChange = ControlChange
        DateOnly = False
        RequireTime = False
        Caption = 'Date Desired'
      end
      object cboUrgency: TORComboBox
        Left = 104
        Top = 18
        Width = 92
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Urgency'
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
        TabOrder = 1
        Text = ''
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object cboTransport: TORComboBox
        Left = 204
        Top = 18
        Width = 92
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Transport'
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
        TabOrder = 2
        Text = ''
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object cboCategory: TORComboBox
        Left = 4
        Top = 57
        Width = 140
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Category'
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
        TabOrder = 3
        Text = ''
        OnChange = cboCategoryChange
        CharsNeedMatch = 1
      end
      object chkPreOp: TCheckBox
        Left = 146
        Top = 233
        Width = 61
        Height = 17
        Caption = 'Pre-Op'
        TabOrder = 13
        Visible = False
        OnClick = ControlChange
      end
      object cboSubmit: TORComboBox
        Left = 154
        Top = 57
        Width = 142
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Submit To'
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
        TabOrder = 4
        Text = ''
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object lstLastExam: TORListBox
        Left = 4
        Top = 95
        Width = 187
        Height = 98
        Color = clBtnFace
        ExtendedSelect = False
        ItemHeight = 13
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
        Left = 196
        Top = 112
        Width = 158
        Height = 41
        Caption = 'Pregnant'
        TabOrder = 8
        object radPregnant: TRadioButton
          Left = 2
          Top = 17
          Width = 39
          Height = 17
          Caption = 'Yes'
          TabOrder = 0
          OnClick = ControlChange
        end
        object radPregnantNo: TRadioButton
          Left = 47
          Top = 17
          Width = 35
          Height = 17
          Caption = 'No'
          TabOrder = 1
          OnClick = ControlChange
        end
        object radPregnantUnknown: TRadioButton
          Left = 87
          Top = 16
          Width = 66
          Height = 17
          Caption = 'Unknown'
          TabOrder = 2
          OnClick = ControlChange
        end
      end
      object Submitlbl508: TVA508StaticText
        Name = 'Submitlbl508'
        Left = 154
        Top = 43
        Width = 120
        Height = 15
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
      Width = 362
      Height = 127
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblHistory: TLabel
        Left = 0
        Top = 34
        Width = 362
        Height = 13
        Align = alTop
        Caption = 'Clinical History (Optional)'
        ExplicitWidth = 116
      end
      object lblReason: TLabel
        Left = 0
        Top = 0
        Width = 362
        Height = 13
        Align = alTop
        Caption = 'Reason for Study (REQUIRED - 64 characters maximum)'
        ExplicitWidth = 268
      end
      object memHistory: TCaptionMemo
        Left = 0
        Top = 47
        Width = 362
        Height = 80
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 3
        OnChange = ControlChange
        OnExit = memHistoryExit
        Caption = 'Clinical History (Optional)'
      end
      object txtReason: TCaptionEdit
        Left = 0
        Top = 13
        Width = 362
        Height = 21
        Align = alTop
        MaxLength = 64
        TabOrder = 0
        OnChange = ControlChange
        Caption = 'Reason for Study (REQUIRED)'
      end
    end
  end
  inherited cmdAccept: TButton
    Left = 497
    Top = 326
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 5
    ExplicitLeft = 497
    ExplicitTop = 326
  end
  inherited cmdQuit: TButton
    Left = 498
    Top = 353
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 6
    ExplicitLeft = 498
    ExplicitTop = 353
  end
  inherited pnlMessage: TPanel
    Left = 5
    Top = 318
    Width = 408
    Height = 55
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
    OnMouseUp = pnlMessageMouseUp
    ExplicitLeft = 5
    ExplicitTop = 318
    ExplicitWidth = 408
    ExplicitHeight = 55
    inherited imgMessage: TImage
      Left = 10
      Top = 9
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitLeft = 10
      ExplicitTop = 9
    end
    inherited memMessage: TRichEdit
      Left = 55
      Width = 344
      Height = 43
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitLeft = 55
      ExplicitWidth = 344
      ExplicitHeight = 43
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
