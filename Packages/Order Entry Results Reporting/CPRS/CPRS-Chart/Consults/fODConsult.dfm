inherited frmODCslt: TfrmODCslt
  Tag = 110
  Left = 430
  Top = 203
  Width = 675
  Height = 488
  HorzScrollBar.Range = 590
  VertScrollBar.Range = 340
  Caption = 'Order a Consult'
  Constraints.MinHeight = 488
  Constraints.MinWidth = 675
  Font.Charset = ANSI_CHARSET
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 675
  ExplicitHeight = 488
  TextHeight = 13
  inherited pnlMessage: TPanel [0]
    AlignWithMargins = True
    Left = 4
    Top = 0
    Width = 651
    Height = 80
    Margins.Right = 0
    TabOrder = 2
    StyleElements = [seFont, seClient, seBorder]
    ExplicitLeft = 4
    ExplicitTop = 0
    ExplicitWidth = 651
    ExplicitHeight = 80
    inherited imgMessage: TImage
      Left = 2
      Top = 2
      Height = 72
      Align = alLeft
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitHeight = 42
    end
    inherited memMessage: TRichEdit
      Left = 34
      Top = 2
      Width = 611
      Height = 72
      Align = alClient
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 34
      ExplicitTop = 2
      ExplicitWidth = 611
      ExplicitHeight = 72
    end
  end
  object pnlCombatVet: TPanel [1]
    Left = 0
    Top = 0
    Width = 659
    Height = 25
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object txtCombatVet: TVA508StaticText
      Left = 0
      Top = 0
      Width = 659
      Height = 25
      Align = alClient
      Alignment = taCenter
      BevelOuter = bvNone
      Caption = ''
      Enabled = False
      TabOrder = 0
      ShowAccelChar = True
      WordWrap = False
      LabelAlignment = taCenter
      LabelLayout = tlTop
    end
  end
  inherited memOrder: TCaptionMemo [2]
    AlignWithMargins = True
    Left = 4
    Top = 287
    Width = 647
    Height = 50
    Lines.Strings = (
      'The order text...'
      '----------------------------------------------'
      '--------------------------------'
      'An order message may be displayed here.')
    TabOrder = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitLeft = 4
    ExplicitTop = 287
    ExplicitWidth = 647
    ExplicitHeight = 50
  end
  inherited cmdAccept: TButton [3]
    AlignWithMargins = True
    Left = 4
    Top = 53
    Width = 651
    Height = 24
    Margins.Top = 0
    Align = alTop
    TabOrder = 3
    ExplicitLeft = 4
    ExplicitTop = 53
    ExplicitWidth = 651
    ExplicitHeight = 24
  end
  inherited cmdQuit: TButton [4]
    AlignWithMargins = True
    Left = 4
    Top = 25
    Width = 651
    Height = 24
    Margins.Top = 0
    Align = alTop
    TabOrder = 5
    ExplicitLeft = 4
    ExplicitTop = 25
    ExplicitWidth = 651
    ExplicitHeight = 24
  end
  object grdDstControls: TGridPanel [5]
    AlignWithMargins = True
    Left = 3
    Top = 365
    Width = 653
    Height = 81
    Align = alBottom
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 120.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlDSTStatus
        Row = 0
      end
      item
        Column = 0
        Control = pnlBaseMessage
        Row = 1
        RowSpan = 2
      end
      item
        Column = 1
        Control = pnlBaseAccept
        Row = 1
      end
      item
        Column = 1
        Control = pnlBaseCancel
        Row = 2
      end
      item
        Column = 1
        Control = pnlDST
        Row = 0
      end>
    ParentBackground = False
    ParentColor = True
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 33.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 33.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    ShowCaption = False
    TabOrder = 7
    object pnlDSTStatus: TPanel
      Left = 0
      Top = 0
      Width = 533
      Height = 33
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'pnlDSTStatus'
      TabOrder = 0
    end
    object pnlBaseMessage: TPanel
      Left = 0
      Top = 33
      Width = 533
      Height = 48
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlBaseMessage'
      ParentBackground = False
      ParentColor = True
      ShowCaption = False
      TabOrder = 1
    end
    object pnlBaseAccept: TPanel
      Left = 533
      Top = 33
      Width = 120
      Height = 15
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 3
    end
    object pnlBaseCancel: TPanel
      Left = 533
      Top = 48
      Width = 120
      Height = 33
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 4
    end
    object pnlDST: TPanel
      Left = 533
      Top = 0
      Width = 120
      Height = 33
      Align = alClient
      BevelOuter = bvNone
      ParentShowHint = False
      ShowCaption = False
      ShowHint = False
      TabOrder = 2
      object stOpenConsultToolboxDisabled: TStaticText
        Left = -64
        Top = 16
        Width = 184
        Height = 17
        Caption = 'Open Consult Toolbox button disabled'
        TabOrder = 0
        TabStop = True
        Visible = False
      end
      object btnLaunchToolbox: TButton
        AlignWithMargins = True
        Left = 4
        Top = 0
        Width = 108
        Height = 25
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Open Consult Toolbox'
        TabOrder = 1
        OnClick = btnLaunchToolboxClick
      end
    end
  end
  object pnlReason: TPanel [6]
    Left = 0
    Top = 386
    Width = 659
    Height = 103
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 53
    TabOrder = 0
    object lblReason: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 653
      Height = 13
      Align = alTop
      Caption = 'Reason for Request'
      Constraints.MinHeight = 13
      ExplicitWidth = 95
    end
    object memReason: TRichEdit
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 648
      Height = 78
      Margins.Right = 8
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Constraints.MinHeight = 32
      MaxLength = 2147483645
      ParentFont = False
      PopupMenu = popReason
      ScrollBars = ssVertical
      TabOrder = 0
      WantTabs = True
      OnChange = ControlChange
      OnKeyDown = memReasonKeyDown
      OnKeyPress = memReasonKeyPress
      OnKeyUp = memReasonKeyUp
    end
  end
  object gpDetails: TGridPanel [7]
    Left = 0
    Top = 81
    Width = 659
    Height = 305
    Align = alTop
    BevelOuter = bvNone
    Caption = 'gpDetails'
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 48.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 132.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 132.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlLeft
        Row = 0
        RowSpan = 12
      end
      item
        Column = 1
        Control = pnlServiceTreeButton
        Row = 1
      end
      item
        Column = 2
        Control = lblUrgency
        Row = 0
      end
      item
        Column = 3
        Control = lblAttn
        Row = 0
      end
      item
        Column = 2
        Control = cboUrgency
        Row = 1
      end
      item
        Column = 3
        Control = cboAttn
        Row = 1
        RowSpan = 2
      end
      item
        Column = 2
        Control = lblClinicallyIndicated
        Row = 3
      end
      item
        Column = 3
        Control = lblLatest
        Row = 12
      end
      item
        Column = 2
        Control = calClinicallyIndicated
        Row = 4
      end
      item
        Column = 2
        Control = calLatest
        Row = 12
      end
      item
        Column = 2
        ColumnSpan = 2
        Control = gbInptOpt
        Row = 6
        RowSpan = 2
      end
      item
        Column = 3
        Control = lblPlace
        Row = 3
      end
      item
        Column = 3
        Control = cboPlace
        Row = 4
      end
      item
        Column = 2
        ColumnSpan = 2
        Control = lblProvDiag
        Row = 8
      end
      item
        Column = 2
        ColumnSpan = 2
        Control = txtProvDiag
        Row = 9
      end
      item
        Column = 3
        Control = cmdLexSearch
        Row = 11
      end
      item
        Column = 2
        Control = btnDiagnosis
        Row = 11
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 32.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 12.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 32.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 12.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 8
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 347
      Height = 280
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlLeft'
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
      object treService: TORTreeView
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 341
        Height = 252
        Margins.Top = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HideSelection = False
        Indent = 19
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Visible = False
        OnChange = treServiceChange
        OnCollapsing = treServiceCollapsing
        OnEnter = treServiceEnter
        OnExit = treServiceExit
        OnKeyDown = treServiceKeyDown
        OnKeyUp = treServiceKeyUp
        OnMouseDown = treServiceMouseDown
        Caption = 'object lblService: TLabel'
        NodePiece = 0
      end
      object cboService: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 341
        Height = 252
        Margins.Top = 0
        Style = orcsSimple
        Align = alClient
        AutoSelect = True
        Caption = 'Consult to Service/Specialty'
        Color = clWindow
        DropDownCount = 16
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
        FlatCheckBoxes = False
        OnChange = ControlChange
        OnClick = cboServiceSelect
        OnExit = cboServiceExit
        OnKeyDown = cboServiceKeyDown
        OnKeyUp = cboServiceKeyUp
        CharsNeedMatch = 1
      end
      object pnlHeader: TPanel
        Left = 0
        Top = 0
        Width = 347
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        Caption = 'pnlHeader'
        ShowCaption = False
        TabOrder = 3
        object lblService: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 134
          Height = 19
          Align = alLeft
          Caption = 'Consult to Service/Specialty'
          ExplicitHeight = 13
        end
        object servicelbl508: TVA508StaticText
          AlignWithMargins = True
          Left = 143
          Top = 3
          Width = 106
          Height = 19
          Align = alLeft
          Alignment = taLeftJustify
          Caption = 'service (for screen R.)'
          Enabled = False
          TabOrder = 0
          Visible = False
          ShowAccelChar = True
          WordWrap = False
          LabelAlignment = taLeftJustify
          LabelLayout = tlTop
        end
        object cboCategory: TORComboBox
          AlignWithMargins = True
          Left = 280
          Top = 3
          Width = 64
          Height = 21
          Style = orcsDropDown
          Align = alRight
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
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          Visible = False
          FlatCheckBoxes = False
          CharsNeedMatch = 1
        end
      end
    end
    object pnlServiceTreeButton: TKeyClickPanel
      Left = 347
      Top = 24
      Width = 48
      Height = 24
      Hint = 'View services/specialties hierarchically'
      Align = alClient
      BevelOuter = bvNone
      BevelWidth = 2
      Caption = 'View services/specialties hierarchically'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnFace
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = True
      OnClick = btnServiceTreeClick
      OnEnter = pnlServiceTreeButtonEnter
      OnExit = pnlServiceTreeButtonExit
      object btnServiceTree: TSpeedButton
        Left = 0
        Top = 0
        Width = 48
        Height = 24
        Align = alClient
        Glyph.Data = {
          26050000424D26050000000000003604000028000000100000000F0000000100
          080000000000F000000000000000000000000001000000010000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFF0700
          07FFFFFFFFFFFFFFFFFFFFA4A407000400FF040404040404FFFFFFA4FFFF0700
          07FFFFFFFFFFFFFFFFFFFFA4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4FFFFFFFF
          FFFF070007FFFFFFFFFFFFA4FFFFFFA4A407000400FF04040404FFA4FFFFFFA4
          FFFF070007FFFFFFFFFFFFA4FFFFFF07FFFFFFFFFFFFFFFFFFFFFFA4FFFF0700
          07FFFFFFFFFFFFFFFFFFFFA4A407000400FF0404040404FFFFFFFFA4FFFF0700
          07FFFFFFFFFFFFFFFFFFFF07FFFFFFFFFFFFFFFFFFFFFFFFFFFF070007FFFFFF
          FFFFFFFFFFFFFFFFFFFF00FB00FF0404040404FFFFFFFFFFFFFF070007FFFFFF
          FFFFFFFFFFFFFFFFFFFF}
        Margin = 0
        OnClick = btnServiceTreeClick
        ExplicitLeft = 3
        ExplicitTop = 4
        ExplicitWidth = 22
        ExplicitHeight = 22
      end
    end
    object lblUrgency: TLabel
      AlignWithMargins = True
      Left = 398
      Top = 3
      Width = 126
      Height = 18
      Align = alClient
      Caption = 'Urgency'
      ExplicitWidth = 40
      ExplicitHeight = 13
    end
    object lblAttn: TLabel
      AlignWithMargins = True
      Left = 530
      Top = 3
      Width = 126
      Height = 18
      Align = alClient
      Caption = 'Attention'
      ExplicitWidth = 42
      ExplicitHeight = 13
    end
    object cboUrgency: TORComboBox
      AlignWithMargins = True
      Left = 398
      Top = 24
      Width = 126
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
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
      TabOrder = 2
      TabStop = True
      Text = ''
      FlatCheckBoxes = False
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object cboAttn: TORCheckComboBox
      AlignWithMargins = True
      Left = 530
      Top = 24
      Width = 121
      Height = 56
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Attention'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 3
      Text = ''
      FlatCheckBoxes = False
      OnChange = ControlChange
      OnNeedData = cboAttnNeedData
      CharsNeedMatch = 1
      MainCheckBoxCaption = 'Include Non-VA Providers'
      MainCheckBoxVisible = True
      MainCheckBoxAlignment = calBottom
      OnMainCheckboxClick = cboAttnMainCheckboxClick
      DropdownStyle = ddsControl
      ExplicitHeight = 40
    end
    object lblClinicallyIndicated: TStaticText
      AlignWithMargins = True
      Left = 398
      Top = 83
      Width = 126
      Height = 18
      Align = alClient
      Caption = 'Clinically indicated date:'
      TabOrder = 4
    end
    object lblLatest: TStaticText
      AlignWithMargins = True
      Left = 530
      Top = 283
      Width = 126
      Height = 18
      Align = alClient
      Caption = 'Latest appropriate date:'
      TabOrder = 5
      Visible = False
    end
    object calClinicallyIndicated: TORDateBox
      AlignWithMargins = True
      Left = 398
      Top = 104
      Width = 126
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 6
      OnChange = ControlChange
      DateOnly = True
      RequireTime = False
      Caption = ''
      ExplicitHeight = 21
    end
    object calLatest: TORDateBox
      AlignWithMargins = True
      Left = 398
      Top = 280
      Width = 121
      Height = 24
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alClient
      Enabled = False
      TabOrder = 7
      Visible = False
      OnChange = ControlChange
      DateOnly = True
      RequireTime = False
      Caption = ''
      ExplicitHeight = 21
    end
    object gbInptOpt: TGroupBox
      AlignWithMargins = True
      Left = 398
      Top = 143
      Width = 253
      Height = 50
      Margins.Right = 8
      Align = alClient
      Caption = 'Patient will be seen as an:'
      TabOrder = 8
      object radInpatient: TRadioButton
        AlignWithMargins = True
        Left = 18
        Top = 18
        Width = 62
        Height = 27
        Margins.Left = 16
        Margins.Right = 16
        Align = alLeft
        Caption = '&Inpatient'
        TabOrder = 1
        OnClick = radInpatientClick
      end
      object radOutpatient: TRadioButton
        AlignWithMargins = True
        Left = 99
        Top = 18
        Width = 69
        Height = 27
        Align = alLeft
        Caption = '&Outpatient'
        TabOrder = 0
        OnClick = radOutpatientClick
      end
    end
    object lblPlace: TLabel
      AlignWithMargins = True
      Left = 530
      Top = 83
      Width = 126
      Height = 18
      Align = alClient
      Caption = 'Place of Consultation'
      ExplicitWidth = 100
      ExplicitHeight = 13
    end
    object cboPlace: TORComboBox
      AlignWithMargins = True
      Left = 530
      Top = 104
      Width = 121
      Height = 21
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Place of Consultation'
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
      TabOrder = 9
      Text = ''
      FlatCheckBoxes = False
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object lblProvDiag: TLabel
      AlignWithMargins = True
      Left = 398
      Top = 199
      Width = 258
      Height = 18
      Align = alClient
      Caption = 'Provisional Diagnosis'
      ExplicitWidth = 100
      ExplicitHeight = 13
    end
    object txtProvDiag: TCaptionEdit
      AlignWithMargins = True
      Left = 398
      Top = 220
      Width = 253
      Height = 24
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alClient
      MaxLength = 180
      ParentShowHint = False
      PopupMenu = mnuPopProvDx
      ShowHint = True
      TabOrder = 10
      OnChange = txtProvDiagChange
      Caption = 'Provisional Diagnosis'
      ExplicitHeight = 21
    end
    object cmdLexSearch: TButton
      AlignWithMargins = True
      Left = 522
      Top = 256
      Width = 129
      Height = 24
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Lexicon'
      TabOrder = 11
      OnClick = cmdLexSearchClick
    end
    object btnDiagnosis: TButton
      Left = 395
      Top = 256
      Width = 136
      Height = 24
      Align = alLeft
      Caption = 'Diagnosis'
      TabOrder = 12
      OnClick = btnDiagnosisClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 28
    Top = 28
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
        'Component = frmODCslt'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = pnlCombatVet'
        'Status = stsDefault')
      (
        'Component = txtCombatVet'
        'Status = stsDefault')
      (
        'Component = pnlBaseMessage'
        'Status = stsDefault')
      (
        'Component = pnlDSTStatus'
        'Status = stsDefault')
      (
        'Component = pnlDST'
        'Status = stsDefault')
      (
        'Component = stOpenConsultToolboxDisabled'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
        'Status = stsDefault')
      (
        'Component = btnDiagnosis'
        'Status = stsDefault')
      (
        'Component = txtProvDiag'
        'Status = stsDefault')
      (
        'Component = cboPlace'
        'Status = stsDefault')
      (
        'Component = gbInptOpt'
        'Status = stsDefault')
      (
        'Component = radInpatient'
        'Status = stsDefault')
      (
        'Component = radOutpatient'
        'Status = stsDefault')
      (
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = cboAttn'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = calClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = calLatest'
        'Status = stsDefault')
      (
        'Component = btnLaunchToolbox'
        'Status = stsDefault')
      (
        'Component = gpDetails'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = pnlServiceTreeButton'
        'Status = stsDefault')
      (
        'Component = servicelbl508'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = pnlHeader'
        'Status = stsDefault'))
  end
  inherited tmrBringToFront: TTimer
    Left = 52
    Top = 65532
  end
  object mnuPopProvDx: TPopupMenu
    Left = 177
    Top = 30
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 123
    Top = 28
    object popReasonCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = popReasonCutClick
    end
    object popReasonCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = popReasonCopyClick
    end
    object popReasonPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = popReasonPasteClick
    end
    object popReasonPaste2: TMenuItem
      Caption = 'Paste2'
      ShortCut = 8237
      Visible = False
      OnClick = popReasonPasteClick
    end
    object popReasonReformat: TMenuItem
      Caption = 'Reformat Paragraph'
      ShortCut = 16466
      OnClick = popReasonReformatClick
    end
  end
end
