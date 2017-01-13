inherited frmEditCslt: TfrmEditCslt
  Tag = 110
  Left = 461
  Top = 191
  Width = 576
  Height = 479
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 340
  Caption = 'Edit/Resubmit a Cancelled Consult'
  Constraints.MinHeight = 467
  Constraints.MinWidth = 576
  Position = poScreenCenter
  ExplicitWidth = 576
  ExplicitHeight = 479
  DesignSize = (
    560
    441)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCombatVet: TPanel [0]
    Left = 0
    Top = 0
    Width = 561
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
      Width = 559
      Height = 23
      Align = alClient
      Alignment = taCenter
      BevelOuter = bvNone
      Caption = ''
      Enabled = False
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object pnlMessage: TPanel [1]
    Left = 21
    Top = 404
    Width = 388
    Height = 44
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Caption = 'pnlMessage'
    TabOrder = 4
    Visible = False
    object imgMessage: TImage
      Left = 4
      Top = 4
      Width = 32
      Height = 32
    end
    object memMessage: TRichEdit
      Left = 37
      Top = 4
      Width = 332
      Height = 32
      Color = clInfoBk
      Font.Charset = ANSI_CHARSET
      Font.Color = clInfoText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
    end
  end
  object cmdAccept: TButton [2]
    Left = 414
    Top = 425
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Resubmit'
    TabOrder = 2
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [3]
    Left = 491
    Top = 425
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdQuitClick
  end
  object pnlMain: TPanel [4]
    Left = 0
    Top = 0
    Width = 569
    Height = 402
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      569
      402)
    object lblService: TLabel
      Left = 4
      Top = 4
      Width = 134
      Height = 13
      Caption = 'Consult to Service/Specialty'
    end
    object lblReason: TLabel
      Left = 4
      Top = 227
      Width = 95
      Height = 13
      Caption = 'Reason for Request'
    end
    object lblComment: TLabel
      Left = 4
      Top = 169
      Width = 77
      Height = 13
      Caption = 'New Comments:'
    end
    object lblComments: TLabel
      Left = 8
      Top = 108
      Width = 89
      Height = 13
      Caption = 'Display Comments:'
    end
    object lblUrgency: TStaticText
      Left = 196
      Top = 4
      Width = 44
      Height = 17
      Caption = 'Urgency'
      TabOrder = 14
    end
    object lblPlace: TStaticText
      Left = 376
      Top = 93
      Width = 104
      Height = 17
      Caption = 'Place of Consultation'
      TabOrder = 15
    end
    object lblAttn: TStaticText
      Left = 376
      Top = 4
      Width = 46
      Height = 17
      Caption = 'Attention'
      TabOrder = 16
    end
    object lblProvDiag: TStaticText
      Left = 195
      Top = 134
      Width = 104
      Height = 17
      Caption = 'Provisional Diagnosis'
      TabOrder = 17
    end
    object lblInpOutp: TStaticText
      Left = 197
      Top = 99
      Width = 127
      Height = 17
      Caption = 'Patient will be seen as an:'
      TabOrder = 18
    end
    object memReason: TRichEdit
      Left = 4
      Top = 240
      Width = 559
      Height = 161
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      ScrollBars = ssVertical
      TabOrder = 12
      WantTabs = True
      OnChange = ControlChange
      OnExit = memReasonExit
      OnKeyDown = memCommentKeyDown
      OnKeyPress = memCommentKeyPress
      OnKeyUp = memCommentKeyUp
    end
    object cboService: TORComboBox
      Left = 4
      Top = 19
      Width = 180
      Height = 83
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Consult to Service/Specialty'
      Color = clWindow
      DropDownCount = 8
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      ParentFont = False
      Pieces = '2'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      CharsNeedMatch = 1
    end
    object cboUrgency: TORComboBox
      Left = 196
      Top = 19
      Width = 170
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
    object radInpatient: TRadioButton
      Left = 197
      Top = 113
      Width = 61
      Height = 17
      Caption = '&Inpatient'
      TabOrder = 6
      OnClick = radInpatientClick
    end
    object radOutpatient: TRadioButton
      Left = 269
      Top = 113
      Width = 73
      Height = 17
      Caption = '&Outpatient'
      TabOrder = 7
      OnClick = radOutpatientClick
    end
    object cboPlace: TORComboBox
      Left = 376
      Top = 106
      Width = 188
      Height = 21
      Anchors = [akLeft, akTop, akRight]
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
      Text = ''
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object txtProvDiag: TCaptionEdit
      Left = 195
      Top = 147
      Width = 316
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 180
      ParentShowHint = False
      PopupMenu = mnuPopProvDx
      ShowHint = True
      TabOrder = 10
      OnChange = ControlChange
      Caption = 'Provisional Diagnosis'
    end
    object txtAttn: TORComboBox
      Left = 376
      Top = 19
      Width = 188
      Height = 21
      Anchors = [akLeft, akTop, akRight]
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
      TabOrder = 2
      Text = ''
      OnChange = ControlChange
      OnNeedData = txtAttnNeedData
      CharsNeedMatch = 1
    end
    object cboCategory: TORComboBox
      Left = 559
      Top = 103
      Width = 10
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
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 13
      Text = ''
      Visible = False
      CharsNeedMatch = 1
    end
    object memComment: TRichEdit
      Left = 4
      Top = 185
      Width = 557
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      TabOrder = 11
      WantTabs = True
      OnChange = ControlChange
      OnExit = memCommentExit
      OnKeyDown = memCommentKeyDown
      OnKeyPress = memCommentKeyPress
      OnKeyUp = memCommentKeyUp
    end
    object btnCmtCancel: TButton
      Left = 8
      Top = 127
      Width = 75
      Height = 21
      Caption = 'Cancellation'
      TabOrder = 4
      OnClick = btnCmtCancelClick
    end
    object btnCmtOther: TButton
      Left = 110
      Top = 127
      Width = 75
      Height = 21
      Caption = 'Other'
      TabOrder = 5
      OnClick = btnCmtOtherClick
    end
    object cmdLexSearch: TButton
      Left = 515
      Top = 147
      Width = 46
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Lexicon'
      TabOrder = 9
      OnClick = cmdLexSearchClick
    end
    object lblClinicallyIndicated: TStaticText
      Left = 197
      Top = 46
      Width = 117
      Height = 17
      Caption = 'Clinically indicated date:'
      TabOrder = 19
    end
    object calClinicallyIndicated: TORDateBox
      Left = 197
      Top = 62
      Width = 164
      Height = 21
      TabOrder = 3
      OnExit = calClinicallyIndicatedExit
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object lblLatest: TStaticText
      Left = 376
      Top = 46
      Width = 116
      Height = 17
      Caption = 'Latest appropriate date:'
      TabOrder = 21
      Visible = False
    end
    object calLatest: TORDateBox
      Left = 378
      Top = 62
      Width = 188
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 22
      Visible = False
      OnExit = calLatestExit
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = frmEditCslt'
        'Status = stsDefault')
      (
        'Component = pnlMain'
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
        'Component = lblInpOutp'
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
        'Component = radInpatient'
        'Status = stsDefault')
      (
        'Component = radOutpatient'
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
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = btnCmtCancel'
        'Status = stsDefault')
      (
        'Component = btnCmtOther'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = calClinicallyIndicated'
        
          'Text = Earliest appropriate Date/Time. Press the enter key to ac' +
          'cess.'
        'Status = stsOK')
      (
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = calLatest'
        
          'Text = Latest appropriate Date/Time. Press the enter key to acce' +
          'ss.'
        'Status = stsOK')
      (
        'Component = pnlCombatVet'
        'Status = stsDefault')
      (
        'Component = txtCombatVet'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 353
    Top = 129
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 523
    Top = 369
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
