inherited frmODProc: TfrmODProc
  Tag = 112
  Left = 430
  Top = 203
  Width = 606
  Height = 442
  HorzScrollBar.Range = 523
  VertScrollBar.Range = 295
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Order a Procedure'
  Constraints.MinHeight = 442
  Constraints.MinWidth = 606
  Position = poDesigned
  OnShow = FormShow
  ExplicitWidth = 606
  ExplicitHeight = 442
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
    Left = 0
    Top = 365
    Width = 380
    Height = 41
    Anchors = [akLeft, akRight, akBottom]
    Lines.Strings = (
      'The order text...'
      
        '----------------------------------------------------------------' +
        '--------------'
      'An order message may be displayed here.')
    ParentFont = False
    TabOrder = 3
    ExplicitLeft = 0
    ExplicitTop = 365
    ExplicitWidth = 380
    ExplicitHeight = 41
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 0
    Width = 598
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      598
      354)
    object lblProc: TLabel
      Left = 4
      Top = 4
      Width = 49
      Height = 13
      Caption = 'Procedure'
    end
    object lblService: TOROffsetLabel
      Left = 4
      Top = 114
      Width = 158
      Height = 15
      Caption = 'Service to perform this procedure'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblReason: TLabel
      Left = 8
      Top = 165
      Width = 95
      Height = 13
      Margins.Left = 0
      Caption = 'Reason for Request'
    end
    object lblUrgency: TStaticText
      Left = 312
      Top = 4
      Width = 44
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Urgency'
      TabOrder = 13
    end
    object lblPlace: TStaticText
      Left = 460
      Top = 92
      Width = 104
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Place of Consultation'
      TabOrder = 14
    end
    object lblAttn: TStaticText
      Left = 460
      Top = 4
      Width = 46
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Attention'
      TabOrder = 15
    end
    object lblProvDiag: TStaticText
      Left = 312
      Top = 135
      Width = 104
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Provisional Diagnosis'
      TabOrder = 16
    end
    object pnlReason: TPanel
      Left = 0
      Top = 184
      Width = 591
      Height = 166
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 11
      object memReason: TCaptionRichEdit
        Left = 0
        Top = 0
        Width = 591
        Height = 166
        Align = alClient
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 40
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
        Caption = 'Reason for Request'
      end
    end
    object cboUrgency: TORComboBox
      Left = 312
      Top = 17
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
      TabOrder = 3
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object cboPlace: TORComboBox
      Left = 460
      Top = 105
      Width = 133
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
      TabOrder = 8
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object txtAttn: TORComboBox
      Left = 460
      Top = 17
      Width = 131
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
      TabOrder = 4
      OnChange = ControlChange
      OnNeedData = txtAttnNeedData
      CharsNeedMatch = 1
    end
    object cboProc: TORComboBox
      Left = 4
      Top = 17
      Width = 290
      Height = 91
      Anchors = [akLeft, akTop, akRight]
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Procedure'
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
      OnChange = cboProcSelect
      OnNeedData = cboProcNeedData
      CharsNeedMatch = 1
    end
    object cboCategory: TORComboBox
      Left = 516
      Top = 10
      Width = 3
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
      TabOrder = 12
      Visible = False
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object cboService: TORComboBox
      Left = 4
      Top = 130
      Width = 290
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service to perform this procedure'
      Color = clWindow
      DropDownCount = 8
      Enabled = False
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
      TabOrder = 1
      OnChange = cboServiceChange
      CharsNeedMatch = 1
    end
    object cmdLexSearch: TButton
      Left = 549
      Top = 149
      Width = 49
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Lexicon'
      TabOrder = 10
      OnClick = cmdLexSearchClick
    end
    object gbInptOpt: TGroupBox
      Left = 312
      Top = 85
      Width = 140
      Height = 45
      Anchors = [akTop, akRight]
      Caption = 'Patient will be seen as an:'
      TabOrder = 7
      object radInpatient: TRadioButton
        Left = 3
        Top = 20
        Width = 61
        Height = 17
        Caption = '&Inpatient'
        TabOrder = 1
        OnClick = radInpatientClick
      end
      object radOutpatient: TRadioButton
        Left = 67
        Top = 20
        Width = 71
        Height = 17
        Caption = '&Outpatient'
        TabOrder = 0
        OnClick = radOutpatientClick
      end
    end
    object txtProvDiag: TCaptionEdit
      Left = 312
      Top = 149
      Width = 234
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 180
      ParentShowHint = False
      PopupMenu = mnuPopProvDx
      ShowHint = True
      TabOrder = 9
      OnChange = txtProvDiagChange
      Caption = 'Provisional Diagnosis'
    end
    object lblEarliest: TStaticText
      Left = 312
      Top = 44
      Width = 121
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Earliest appropriate date:'
      TabOrder = 18
    end
    object calEarliest: TORDateBox
      Left = 312
      Top = 58
      Width = 133
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 5
      OnChange = ControlChange
      DateOnly = True
      RequireTime = False
    end
    object lblLatest: TStaticText
      Left = 460
      Top = 44
      Width = 116
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Latest appropriate date:'
      TabOrder = 19
      Visible = False
    end
    object calLatest: TORDateBox
      Left = 460
      Top = 58
      Width = 131
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 6
      Visible = False
      OnChange = ControlChange
      DateOnly = True
      RequireTime = False
    end
    object servicelbl508: TVA508StaticText
      Name = 'servicelbl508'
      Left = 183
      Top = 114
      Width = 106
      Height = 15
      Alignment = taLeftJustify
      Caption = 'service (for screen R.)'
      Enabled = False
      TabOrder = 2
      Visible = False
      ShowAccelChar = True
    end
  end
  inherited cmdAccept: TButton
    Left = 427
    Top = 382
    Anchors = [akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 427
    ExplicitTop = 382
  end
  inherited cmdQuit: TButton
    Left = 526
    Top = 382
    Width = 64
    Anchors = [akRight, akBottom]
    TabOrder = 5
    ExplicitLeft = 526
    ExplicitTop = 382
    ExplicitWidth = 64
  end
  inherited pnlMessage: TPanel
    Left = 13
    Top = 361
    Width = 316
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 13
    ExplicitTop = 361
    ExplicitWidth = 316
    inherited memMessage: TRichEdit
      Width = 254
      ExplicitWidth = 254
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
        'Component = frmODProc'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = pnlCombatVet'
        'Status = stsDefault')
      (
        'Component = lblUrgency'
        'Status = stsDefault')
      (
        'Component = lblPlace'
        'Status = stsDefault')
      (
        'Component = lblAttn'
        'Status = stsDefault')
      (
        'Component = lblProvDiag'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = cboPlace'
        'Status = stsDefault')
      (
        'Component = txtAttn'
        'Status = stsDefault')
      (
        'Component = cboProc'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
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
        'Component = txtProvDiag'
        'Status = stsDefault')
      (
        'Component = lblEarliest'
        'Status = stsDefault')
      (
        'Component = calEarliest'
        'Status = stsDefault')
      (
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = calLatest'
        'Status = stsDefault')
      (
        'Component = txtCombatVet'
        'Status = stsDefault')
      (
        'Component = servicelbl508'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 353
    Top = 133
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 483
    Top = 337
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
