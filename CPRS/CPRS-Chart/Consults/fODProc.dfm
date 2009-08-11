inherited frmODProc: TfrmODProc
  Tag = 112
  Left = 208
  Top = 188
  Width = 543
  Height = 393
  HorzScrollBar.Range = 523
  VertScrollBar.Range = 295
  Caption = 'Order a Procedure'
  Constraints.MinHeight = 393
  Constraints.MinWidth = 543
  ExplicitLeft = 208
  ExplicitTop = 188
  ExplicitWidth = 543
  ExplicitHeight = 393
  PixelsPerInch = 96
  TextHeight = 13
  object lblProc: TLabel [0]
    Left = 4
    Top = 4
    Width = 49
    Height = 13
    Caption = 'Procedure'
  end
  object lblService: TOROffsetLabel [1]
    Left = 4
    Top = 42
    Width = 158
    Height = 15
    Caption = 'Service to perform this procedure'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblReason: TLabel [2]
    Left = 4
    Top = 103
    Width = 95
    Height = 13
    Caption = 'Reason for Request'
  end
  object lblUrgency: TStaticText [3]
    Left = 249
    Top = 4
    Width = 44
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Urgency'
    TabOrder = 15
  end
  object lblPlace: TStaticText [4]
    Left = 396
    Top = 43
    Width = 104
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Place of Consultation'
    TabOrder = 16
  end
  object lblAttn: TStaticText [5]
    Left = 396
    Top = 4
    Width = 46
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Attention'
    TabOrder = 17
  end
  object lblProvDiag: TStaticText [6]
    Left = 249
    Top = 81
    Width = 104
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Provisional Diagnosis'
    TabOrder = 18
  end
  object pnlReason: TPanel [7]
    Left = 0
    Top = 120
    Width = 528
    Height = 192
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 9
    object memReason: TCaptionRichEdit
      Left = 0
      Top = 0
      Width = 528
      Height = 192
      Align = alClient
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
  inherited memOrder: TCaptionMemo
    Left = 0
    Top = 321
    Width = 380
    Height = 41
    Anchors = [akLeft, akRight]
    Lines.Strings = (
      'The order text...'
      
        '----------------------------------------------------------------' +
        '--------------'
      'An order message may be displayed here.')
    TabOrder = 1
    ExplicitLeft = 0
    ExplicitTop = 321
    ExplicitWidth = 380
    ExplicitHeight = 41
  end
  object cboUrgency: TORComboBox [9]
    Left = 249
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
    TabOrder = 2
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object cboPlace: TORComboBox [10]
    Left = 396
    Top = 56
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
    TabOrder = 6
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object txtAttn: TORComboBox [11]
    Left = 396
    Top = 17
    Width = 133
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
    TabOrder = 3
    OnChange = ControlChange
    OnNeedData = txtAttnNeedData
    CharsNeedMatch = 1
  end
  object cboProc: TORComboBox [12]
    Left = 4
    Top = 17
    Width = 227
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Style = orcsDropDown
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
  object cboCategory: TORComboBox [13]
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
    TabOrder = 13
    Visible = False
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object cboService: TORComboBox [14]
    Left = 4
    Top = 58
    Width = 227
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
    TabOrder = 4
    OnChange = cboServiceChange
    CharsNeedMatch = 1
  end
  object cmdLexSearch: TButton [15]
    Left = 486
    Top = 93
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Lexicon'
    TabOrder = 8
    OnClick = cmdLexSearchClick
  end
  object gbInptOpt: TGroupBox [16]
    Left = 249
    Top = 36
    Width = 140
    Height = 45
    Anchors = [akTop, akRight]
    Caption = 'Patient will be seen as an:'
    TabOrder = 5
    object radInpatient: TRadioButton
      Left = 3
      Top = 20
      Width = 61
      Height = 17
      Caption = '&Inpatient'
      TabOrder = 0
      OnClick = radInpatientClick
    end
    object radOutpatient: TRadioButton
      Left = 67
      Top = 20
      Width = 71
      Height = 17
      Caption = '&Outpatient'
      TabOrder = 1
      OnClick = radOutpatientClick
    end
  end
  object txtProvDiag: TCaptionEdit [17]
    Left = 249
    Top = 93
    Width = 234
    Height = 21
    Anchors = [akTop, akRight]
    MaxLength = 180
    ParentShowHint = False
    PopupMenu = mnuPopProvDx
    ShowHint = True
    TabOrder = 7
    OnChange = txtProvDiagChange
    Caption = 'Provisional Diagnosis'
  end
  inherited cmdAccept: TButton
    Left = 387
    Top = 339
    Anchors = [akRight, akBottom]
    TabOrder = 10
    ExplicitLeft = 387
    ExplicitTop = 339
  end
  inherited cmdQuit: TButton
    Left = 469
    Top = 339
    Width = 64
    Anchors = [akRight, akBottom]
    TabOrder = 11
    ExplicitLeft = 469
    ExplicitTop = 339
    ExplicitWidth = 64
  end
  inherited pnlMessage: TPanel
    Left = 50
    Top = 320
    Width = 316
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 12
    ExplicitLeft = 50
    ExplicitTop = 320
    ExplicitWidth = 316
    inherited memMessage: TRichEdit
      Width = 254
      ExplicitWidth = 254
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
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
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 353
    Top = 77
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 411
    Top = 169
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
