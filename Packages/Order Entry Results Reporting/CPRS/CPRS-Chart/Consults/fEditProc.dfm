inherited frmEditProc: TfrmEditProc
  Tag = 112
  Left = 408
  Top = 210
  Width = 580
  Height = 458
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 308
  Caption = 'Edit and resubmit a cancelled procedure'
  Constraints.MinHeight = 458
  Constraints.MinWidth = 580
  Position = poScreenCenter
  ExplicitWidth = 580
  ExplicitHeight = 458
  DesignSize = (
    564
    420)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCombatVet: TPanel [0]
    Left = 0
    Top = 0
    Width = 564
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
      Width = 562
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
  object cmdAccept: TButton [1]
    Left = 410
    Top = 400
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Resubmit'
    TabOrder = 2
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [2]
    Left = 495
    Top = 400
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdQuitClick
  end
  object pnlMessage: TPanel [3]
    Left = 12
    Top = 379
    Width = 392
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
      Left = 40
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
  object pnlMain: TPanel [4]
    Left = 0
    Top = 0
    Width = 572
    Height = 393
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      572
      393)
    object lblProc: TLabel
      Left = 3
      Top = 7
      Width = 49
      Height = 13
      Caption = 'Procedure'
    end
    object lblReason: TLabel
      Left = 8
      Top = 225
      Width = 95
      Height = 13
      Caption = 'Reason for Request'
    end
    object lblService: TOROffsetLabel
      Left = 3
      Top = 49
      Width = 158
      Height = 15
      Caption = 'Service to perform this procedure'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblComment: TLabel
      Left = 8
      Top = 166
      Width = 74
      Height = 13
      Caption = 'New Comments'
    end
    object lblComments: TLabel
      Left = 3
      Top = 92
      Width = 89
      Height = 13
      Caption = 'Display Comments:'
    end
    object lblUrgency: TStaticText
      Left = 190
      Top = 7
      Width = 44
      Height = 17
      Caption = 'Urgency'
      TabOrder = 17
    end
    object lblPlace: TStaticText
      Left = 360
      Top = 92
      Width = 104
      Height = 17
      Caption = 'Place of Consultation'
      TabOrder = 18
    end
    object lblAttn: TStaticText
      Left = 362
      Top = 7
      Width = 46
      Height = 17
      Caption = 'Attention'
      TabOrder = 19
    end
    object lblProvDiag: TStaticText
      Left = 188
      Top = 136
      Width = 104
      Height = 17
      Caption = 'Provisional Diagnosis'
      TabOrder = 20
    end
    object lblInpOutp: TStaticText
      Left = 190
      Top = 92
      Width = 127
      Height = 17
      Caption = 'Patient will be seen as an:'
      TabOrder = 16
    end
    object memReason: TRichEdit
      Left = 8
      Top = 241
      Width = 560
      Height = 151
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      ScrollBars = ssVertical
      TabOrder = 14
      WantTabs = True
      OnChange = ControlChange
      OnExit = memReasonExit
      OnKeyDown = memReasonKeyDown
      OnKeyPress = memReasonKeyPress
      OnKeyUp = memCommentKeyUp
    end
    object cboUrgency: TORComboBox
      Left = 190
      Top = 22
      Width = 165
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
      TabOrder = 2
      Text = ''
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object radInpatient: TRadioButton
      Left = 188
      Top = 105
      Width = 61
      Height = 17
      Caption = '&Inpatient'
      TabOrder = 8
      OnClick = radInpatientClick
    end
    object radOutpatient: TRadioButton
      Left = 255
      Top = 105
      Width = 73
      Height = 17
      Caption = '&Outpatient'
      TabOrder = 9
      OnClick = radOutpatientClick
    end
    object cboPlace: TORComboBox
      Left = 360
      Top = 107
      Width = 206
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
      TabOrder = 10
      Text = ''
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object txtProvDiag: TCaptionEdit
      Left = 188
      Top = 149
      Width = 324
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 180
      ParentShowHint = False
      PopupMenu = mnuPopProvDx
      ShowHint = True
      TabOrder = 12
      OnChange = ControlChange
      Caption = 'Provisional Diagnosis'
    end
    object txtAttn: TORComboBox
      Left = 362
      Top = 22
      Width = 206
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
      TabOrder = 3
      Text = ''
      OnChange = ControlChange
      OnNeedData = txtAttnNeedData
      CharsNeedMatch = 1
    end
    object cboProc: TORComboBox
      Left = 3
      Top = 22
      Width = 173
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Procedure'
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
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentFont = False
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnChange = cboProcSelect
      OnNeedData = cboProcNeedData
      CharsNeedMatch = 1
    end
    object cboCategory: TORComboBox
      Left = 505
      Top = -11
      Width = 2
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
      TabOrder = 15
      Text = ''
      Visible = False
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object cboService: TORComboBox
      Left = 3
      Top = 65
      Width = 173
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service to perform this procedure'
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
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      ParentFont = False
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
    object memComment: TRichEdit
      Left = 8
      Top = 180
      Width = 560
      Height = 38
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      TabOrder = 13
      WantTabs = True
      OnChange = ControlChange
      OnExit = memCommentExit
      OnKeyUp = memCommentKeyUp
    end
    object btnCmtCancel: TButton
      Left = 3
      Top = 111
      Width = 75
      Height = 21
      Caption = 'Cancellation'
      TabOrder = 6
      OnClick = btnCmtCancelClick
    end
    object btnCmtOther: TButton
      Left = 84
      Top = 111
      Width = 75
      Height = 21
      Caption = 'Other'
      TabOrder = 7
      OnClick = btnCmtOtherClick
    end
    object cmdLexSearch: TButton
      Left = 516
      Top = 149
      Width = 49
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Lexicon'
      TabOrder = 11
      OnClick = cmdLexSearchClick
    end
    object lblClinicallyIndicated: TStaticText
      Left = 190
      Top = 49
      Width = 117
      Height = 17
      Caption = 'Clinically indicated date:'
      TabOrder = 21
    end
    object lblLatest: TStaticText
      Left = 361
      Top = 49
      Width = 116
      Height = 17
      Caption = 'Latest appropriate date:'
      TabOrder = 22
      Visible = False
    end
    object calClinicallyIndicated: TORDateBox
      Left = 190
      Top = 65
      Width = 164
      Height = 21
      TabOrder = 4
      OnExit = calClinicallyIndicatedExit
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object calLatest: TORDateBox
      Left = 362
      Top = 65
      Width = 204
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
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
        'Component = frmEditProc'
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
        'Component = cboProc'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = cboService'
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
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = calClinicallyIndicated'
        
          'Text = Earliest appropriate Date/Time. Press the enter key to ac' +
          'cess.'
        'Status = stsOK')
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
    Left = 351
    Top = 132
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 539
    Top = 361
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
