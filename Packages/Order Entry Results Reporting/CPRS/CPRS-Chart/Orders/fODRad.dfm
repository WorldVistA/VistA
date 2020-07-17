inherited frmODRad: TfrmODRad
  Tag = 160
  Left = 282
  Top = 225
  Width = 916
  Height = 631
  Caption = 'Order an Imaging Procedure'
  Constraints.MinHeight = 631
  Constraints.MinWidth = 916
  ExplicitWidth = 916
  ExplicitHeight = 631
  PixelsPerInch = 120
  TextHeight = 16
  inherited memOrder: TCaptionMemo
    Left = 9
    Top = 486
    Width = 882
    Height = 65
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 4
    ExplicitLeft = 9
    ExplicitTop = 486
    ExplicitWidth = 882
    ExplicitHeight = 65
  end
  object FRadCommonCombo: TORListBox [1]
    Left = 655
    Top = 566
    Width = 189
    Height = 45
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = False
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
  end
  object pnlLeft: TPanel [2]
    Left = 11
    Top = 0
    Width = 372
    Height = 473
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    BevelOuter = bvNone
    TabOrder = 0
    object lblDrug: TLabel
      Left = 13
      Top = 64
      Width = 114
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Imaging Procedure'
    end
    object lblAvailMod: TLabel
      Left = 13
      Top = 280
      Width = 115
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Available Modifiers'
    end
    object lblImType: TLabel
      Left = 13
      Top = 6
      Width = 83
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Imaging Type'
    end
    object lblSelectMod: TLabel
      Left = 181
      Top = 280
      Width = 112
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Selected Modifiers'
    end
    object cboImType: TORComboBox
      Left = 13
      Top = 31
      Width = 331
      Height = 24
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
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
      Left = 181
      Top = 309
      Width = 160
      Height = 106
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
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
      Left = 13
      Top = 89
      Width = 331
      Height = 190
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
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
      Left = 13
      Top = 308
      Width = 160
      Height = 142
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Available Modifiers'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
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
      Left = 181
      Top = 423
      Width = 159
      Height = 27
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Remove'
      TabOrder = 5
      OnClick = cmdRemoveClick
    end
  end
  object pnlRightBase: TPanel [3]
    Left = 390
    Top = -3
    Width = 619
    Height = 476
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    BevelOuter = bvNone
    TabOrder = 1
    object pnlRight: TPanel
      Left = 3
      Top = 175
      Width = 600
      Height = 294
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      BevelOuter = bvNone
      TabOrder = 1
      object lblRequestDate: TLabel
        Left = 0
        Top = 6
        Width = 80
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Date Desired'
      end
      object lblUrgency: TLabel
        Left = 163
        Top = 8
        Width = 51
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Urgency'
      end
      object lblTransport: TLabel
        Left = 319
        Top = 8
        Width = 58
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Transport'
      end
      object lblCategory: TLabel
        Left = 0
        Top = 65
        Width = 55
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Category'
      end
      object lblSubmit: TLabel
        Left = 241
        Top = 70
        Width = 61
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Submit To'
      end
      object lblLastExam: TLabel
        Left = 0
        Top = 129
        Width = 167
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Exams Over the Last 7 Days'
      end
      object lblAskSubmit: TLabel
        Left = 698
        Top = 161
        Width = 3
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Visible = False
      end
      object lblPreOp: TLabel
        Left = 310
        Top = 235
        Width = 107
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'PreOp Scheduled'
      end
      object calPreOp: TORDateBox
        Left = 310
        Top = 258
        Width = 150
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 9
        OnChange = calPreOpChange
        OnExit = calPreOpExit
        DateOnly = False
        RequireTime = False
        Caption = 'PreOp Scheduled'
      end
      object chkIsolation: TCheckBox
        Left = 310
        Top = 129
        Width = 151
        Height = 26
        Hint = 'Is patient on isolation procedures?'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Isolation'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = ControlChange
        OnExit = chkIsolationExit
      end
      object calRequestDate: TORDateBox
        Left = 0
        Top = 29
        Width = 144
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 0
        OnChange = ControlChange
        DateOnly = False
        RequireTime = False
        Caption = 'Date Desired'
      end
      object cboUrgency: TORComboBox
        Left = 163
        Top = 29
        Width = 143
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 319
        Top = 29
        Width = 144
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 0
        Top = 89
        Width = 219
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 229
        Top = 364
        Width = 95
        Height = 27
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Pre-Op'
        TabOrder = 13
        Visible = False
        OnClick = ControlChange
      end
      object cboSubmit: TORComboBox
        Left = 241
        Top = 89
        Width = 222
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 0
        Top = 155
        Width = 293
        Height = 125
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Left = 309
        Top = 163
        Width = 285
        Height = 63
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Pregnant'
        TabOrder = 8
        object radPregnant: TRadioButton
          Left = 10
          Top = 25
          Width = 60
          Height = 31
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Yes'
          TabOrder = 0
          OnClick = ControlChange
        end
        object radPregnantNo: TRadioButton
          Left = 95
          Top = 25
          Width = 55
          Height = 31
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'No'
          TabOrder = 1
          OnClick = ControlChange
        end
        object radPregnantUnknown: TRadioButton
          Left = 174
          Top = 25
          Width = 109
          Height = 31
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Unknown'
          TabOrder = 2
          OnClick = ControlChange
        end
      end
      object Submitlbl508: TVA508StaticText
        Name = 'Submitlbl508'
        Left = 241
        Top = 68
        Width = 149
        Height = 18
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
      Width = 611
      Height = 183
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      BevelOuter = bvNone
      TabOrder = 0
      object lblHistory: TLabel
        Left = 0
        Top = 64
        Width = 149
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Clinical History (Optional)'
      end
      object lblReason: TLabel
        Left = 0
        Top = 6
        Width = 335
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Reason for Study (REQUIRED - 64 characters maximum)'
      end
      object memHistory: TCaptionMemo
        Left = 0
        Top = 89
        Width = 601
        Height = 82
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        ScrollBars = ssVertical
        TabOrder = 3
        OnChange = ControlChange
        OnExit = memHistoryExit
        Caption = 'Clinical History (Optional)'
      end
      object txtReason: TCaptionEdit
        Left = 0
        Top = 31
        Width = 601
        Height = 24
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        MaxLength = 64
        TabOrder = 0
        OnChange = ControlChange
        OnKeyPress = txtReasonKeyPress
        Caption = 'Reason for Study (REQUIRED)'
      end
    end
  end
  inherited cmdAccept: TButton
    Left = 915
    Top = 486
    Width = 94
    Height = 32
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 5
    ExplicitLeft = 915
    ExplicitTop = 486
    ExplicitWidth = 94
    ExplicitHeight = 32
  end
  inherited cmdQuit: TButton
    Left = 915
    Top = 520
    Width = 94
    Height = 31
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 6
    ExplicitLeft = 915
    ExplicitTop = 520
    ExplicitWidth = 94
    ExplicitHeight = 31
  end
  inherited pnlMessage: TPanel
    Left = 38
    Top = 471
    Width = 637
    Height = 85
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 2
    OnMouseUp = pnlMessageMouseUp
    ExplicitLeft = 38
    ExplicitTop = 471
    ExplicitWidth = 637
    ExplicitHeight = 85
    inherited imgMessage: TImage
      Left = 16
      Top = 14
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      ExplicitLeft = 16
      ExplicitTop = 14
    end
    inherited memMessage: TRichEdit
      Left = 86
      Width = 538
      Height = 68
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      ExplicitLeft = 86
      ExplicitWidth = 538
      ExplicitHeight = 68
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 240
    Top = 389
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
    Left = 392
    Top = 389
  end
  object VA508ComponentAccessibility2: TVA508ComponentAccessibility
    Component = grpPregnant
    Left = 316
    Top = 389
  end
end
