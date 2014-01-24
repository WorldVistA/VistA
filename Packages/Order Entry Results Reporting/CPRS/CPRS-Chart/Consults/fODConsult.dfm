inherited frmODCslt: TfrmODCslt
  Tag = 110
  Left = 430
  Top = 203
  Width = 606
  Height = 455
  HorzScrollBar.Range = 590
  VertScrollBar.Range = 340
  Caption = 'Order a Consult'
  Constraints.MinHeight = 442
  Constraints.MinWidth = 590
  Font.Charset = ANSI_CHARSET
  ExplicitWidth = 606
  ExplicitHeight = 455
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCombatVet: TPanel [0]
    Left = 0
    Top = 0
    Width = 590
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object txtCombatVet: TVA508StaticText
      Name = 'txtCombatVet'
      Left = 1
      Top = 1
      Width = 588
      Height = 23
      Align = alClient
      Alignment = taCenter
      BevelOuter = bvNone
      Enabled = False
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  inherited memOrder: TCaptionMemo
    Left = 3
    Top = 384
    Width = 417
    Height = 41
    Anchors = [akLeft, akBottom]
    Lines.Strings = (
      'The order text...'
      '----------------------------------------------'
      '--------------------------------'
      'An order message may be displayed here.')
    TabOrder = 2
    ExplicitLeft = 3
    ExplicitTop = 384
    ExplicitWidth = 417
    ExplicitHeight = 41
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 0
    Width = 598
    Height = 380
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      598
      380)
    object lblService: TLabel
      Left = 1
      Top = 2
      Width = 134
      Height = 13
      Caption = 'Consult to Service/Specialty'
    end
    object lblProvDiag: TLabel
      Left = 312
      Top = 138
      Width = 100
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Provisional Diagnosis'
    end
    object lblUrgency: TLabel
      Left = 309
      Top = 2
      Width = 40
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Urgency'
    end
    object lblPlace: TLabel
      Left = 457
      Top = 100
      Width = 100
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Place of Consultation'
    end
    object lblAttn: TLabel
      Left = 454
      Top = 2
      Width = 42
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Attention'
    end
    object lblLatest: TStaticText
      Left = 454
      Top = 43
      Width = 116
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Latest appropriate date:'
      TabOrder = 17
      Visible = False
    end
    object lblEarliest: TStaticText
      Left = 309
      Top = 43
      Width = 121
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Earliest appropriate date:'
      TabOrder = 14
    end
    object pnlReason: TPanel
      Left = 3
      Top = 176
      Width = 587
      Height = 179
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Constraints.MinHeight = 53
      TabOrder = 13
      object lblReason: TLabel
        Left = 0
        Top = 0
        Width = 587
        Height = 13
        Align = alTop
        Caption = 'Reason for Request'
        Constraints.MinHeight = 13
        ExplicitWidth = 95
      end
      object memReason: TRichEdit
        Left = 0
        Top = 13
        Width = 587
        Height = 166
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 40
        MaxLength = 2147483645
        ParentFont = False
        PopupMenu = popReason
        ScrollBars = ssBoth
        TabOrder = 0
        WantTabs = True
        OnChange = ControlChange
        OnExit = memReasonExit
        OnKeyDown = memReasonKeyDown
        OnKeyPress = memReasonKeyPress
        OnKeyUp = memReasonKeyUp
      end
    end
    object cboService: TORComboBox
      Left = 0
      Top = 16
      Width = 274
      Height = 154
      Anchors = [akLeft, akTop, akRight]
      Style = orcsSimple
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
      OnChange = ControlChange
      OnClick = cboServiceSelect
      OnExit = cboServiceExit
      OnKeyDown = cboServiceKeyDown
      OnKeyUp = cboServiceKeyUp
      CharsNeedMatch = 1
    end
    object cboUrgency: TORComboBox
      Left = 309
      Top = 16
      Width = 133
      Height = 21
      Anchors = [akTop, akRight]
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
      TabOrder = 4
      TabStop = True
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object cboPlace: TORComboBox
      Left = 457
      Top = 113
      Width = 136
      Height = 21
      Anchors = [akTop, akRight]
      Style = orcsDropDown
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
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object txtProvDiag: TCaptionEdit
      Left = 312
      Top = 151
      Width = 223
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 180
      ParentShowHint = False
      PopupMenu = mnuPopProvDx
      ShowHint = True
      TabOrder = 11
      OnChange = txtProvDiagChange
      Caption = 'Provisional Diagnosis'
    end
    object txtAttn: TORComboBox
      Left = 454
      Top = 16
      Width = 136
      Height = 21
      Anchors = [akTop, akRight]
      Style = orcsDropDown
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
      TabOrder = 5
      OnChange = ControlChange
      OnNeedData = txtAttnNeedData
      CharsNeedMatch = 1
    end
    object treService: TORTreeView
      Left = 0
      Top = 38
      Width = 298
      Height = 220
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideSelection = False
      Indent = 19
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
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
    object cboCategory: TORComboBox
      Left = 225
      Top = -5
      Width = 5
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
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 18
      Visible = False
      CharsNeedMatch = 1
    end
    object pnlServiceTreeButton: TKeyClickPanel
      Left = 274
      Top = 14
      Width = 26
      Height = 26
      Hint = 'View services/specialties hierarchically'
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      BevelWidth = 2
      Caption = 'View services/specialties hierarchically'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnFace
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = True
      OnClick = btnServiceTreeClick
      OnEnter = pnlServiceTreeButtonEnter
      OnExit = pnlServiceTreeButtonExit
      object btnServiceTree: TSpeedButton
        Left = 2
        Top = 2
        Width = 22
        Height = 22
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
      end
    end
    object gbInptOpt: TGroupBox
      Left = 309
      Top = 92
      Width = 140
      Height = 45
      Anchors = [akTop, akRight]
      Caption = 'Patient will be seen as an:'
      TabOrder = 8
      object radInpatient: TRadioButton
        Left = 3
        Top = 20
        Width = 61
        Height = 13
        Caption = '&Inpatient'
        TabOrder = 1
        OnClick = radInpatientClick
      end
      object radOutpatient: TRadioButton
        Left = 67
        Top = 20
        Width = 70
        Height = 13
        Caption = '&Outpatient'
        TabOrder = 0
        OnClick = radOutpatientClick
      end
    end
    object btnDiagnosis: TButton
      Left = 541
      Top = 151
      Width = 49
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Diagnosis'
      TabOrder = 10
      OnClick = btnDiagnosisClick
    end
    object cmdLexSearch: TButton
      Left = 541
      Top = 151
      Width = 49
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Lexicon'
      TabOrder = 12
      OnClick = cmdLexSearchClick
    end
    object calEarliest: TORDateBox
      Left = 309
      Top = 57
      Width = 133
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 6
      OnChange = ControlChange
      DateOnly = True
      RequireTime = False
    end
    object calLatest: TORDateBox
      Left = 454
      Top = 57
      Width = 136
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 7
      Visible = False
      OnChange = ControlChange
      DateOnly = True
      RequireTime = False
    end
    object servicelbl508: TVA508StaticText
      Name = 'servicelbl508'
      Left = 151
      Top = 1
      Width = 106
      Height = 15
      Alignment = taLeftJustify
      Caption = 'service (for screen R.)'
      Enabled = False
      TabOrder = 1
      Visible = False
      ShowAccelChar = True
    end
  end
  inherited cmdAccept: TButton
    Left = 427
    Top = 394
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    ExplicitLeft = 427
    ExplicitTop = 394
  end
  inherited cmdQuit: TButton
    Left = 531
    Top = 394
    Width = 61
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    ExplicitLeft = 531
    ExplicitTop = 394
    ExplicitWidth = 61
  end
  inherited pnlMessage: TPanel
    Left = 13
    Top = 374
    Width = 377
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
    ExplicitLeft = 13
    ExplicitTop = 374
    ExplicitWidth = 377
    inherited memMessage: TRichEdit
      Width = 292
      ExplicitWidth = 292
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
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
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = lblEarliest'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = cboPlace'
        'Status = stsDefault')
      (
        'Component = txtProvDiag'
        'Status = stsDefault')
      (
        'Component = txtAttn'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = pnlServiceTreeButton'
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
        'Component = btnDiagnosis'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
        'Status = stsDefault')
      (
        'Component = calEarliest'
        'Status = stsDefault')
      (
        'Component = calLatest'
        'Status = stsDefault')
      (
        'Component = pnlCombatVet'
        'Status = stsDefault')
      (
        'Component = txtCombatVet'
        'Status = stsDefault')
      (
        'Component = servicelbl508'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 489
    Top = 150
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 547
    Top = 316
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
