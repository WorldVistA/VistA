inherited frmEditProc: TfrmEditProc
  Tag = 112
  Left = 296
  Top = 245
  Width = 571
  Height = 359
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 308
  Caption = 'Edit and resubmit a cancelled procedure'
  Constraints.MinHeight = 359
  Constraints.MinWidth = 571
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitLeft = 296
  ExplicitTop = 245
  ExplicitWidth = 571
  ExplicitHeight = 359
  DesignSize = (
    563
    325)
  PixelsPerInch = 96
  TextHeight = 13
  object lblProc: TLabel [0]
    Left = 3
    Top = 7
    Width = 49
    Height = 13
    Caption = 'Procedure'
  end
  object lblReason: TLabel [1]
    Left = 3
    Top = 167
    Width = 90
    Height = 13
    Caption = 'Reason for Consult'
  end
  object lblService: TOROffsetLabel [2]
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
  object lblComment: TLabel [3]
    Left = 106
    Top = 109
    Width = 74
    Height = 13
    Caption = 'New Comments'
  end
  object lblComments: TLabel [4]
    Left = 3
    Top = 99
    Width = 89
    Height = 13
    Caption = 'Display Comments:'
  end
  object lblUrgency: TStaticText [5]
    Left = 190
    Top = 7
    Width = 44
    Height = 17
    Caption = 'Urgency'
    TabOrder = 18
  end
  object lblPlace: TStaticText [6]
    Left = 362
    Top = 50
    Width = 104
    Height = 17
    Caption = 'Place of Consultation'
    TabOrder = 19
  end
  object lblAttn: TStaticText [7]
    Left = 362
    Top = 7
    Width = 46
    Height = 17
    Caption = 'Attention'
    TabOrder = 20
  end
  object lblProvDiag: TStaticText [8]
    Left = 190
    Top = 81
    Width = 104
    Height = 17
    Caption = 'Provisional Diagnosis'
    TabOrder = 21
  end
  object lblInpOutp: TStaticText [9]
    Left = 192
    Top = 48
    Width = 127
    Height = 17
    Caption = 'Patient will be seen as an:'
    TabOrder = 17
  end
  object memReason: TRichEdit [10]
    Left = 2
    Top = 181
    Width = 557
    Height = 119
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = popReason
    ScrollBars = ssBoth
    TabOrder = 12
    WantTabs = True
    OnChange = ControlChange
    OnExit = memReasonExit
    OnKeyDown = memReasonKeyDown
    OnKeyPress = memReasonKeyPress
    OnKeyUp = memCommentKeyUp
  end
  object cmdAccept: TButton [11]
    Left = 401
    Top = 303
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Resubmit'
    TabOrder = 13
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [12]
    Left = 486
    Top = 303
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 14
    OnClick = cmdQuitClick
  end
  object cboUrgency: TORComboBox [13]
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
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object radInpatient: TRadioButton [14]
    Left = 190
    Top = 61
    Width = 61
    Height = 17
    Caption = '&Inpatient'
    TabOrder = 4
    OnClick = radInpatientClick
  end
  object radOutpatient: TRadioButton [15]
    Left = 264
    Top = 61
    Width = 73
    Height = 17
    Caption = '&Outpatient'
    TabOrder = 5
    OnClick = radOutpatientClick
  end
  object cboPlace: TORComboBox [16]
    Left = 362
    Top = 63
    Width = 197
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
    TabOrder = 6
    OnChange = ControlChange
    CharsNeedMatch = 1
    ExplicitWidth = 195
  end
  object txtProvDiag: TCaptionEdit [17]
    Left = 190
    Top = 94
    Width = 315
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 180
    ParentShowHint = False
    PopupMenu = mnuPopProvDx
    ShowHint = True
    TabOrder = 7
    OnChange = ControlChange
    Caption = 'Provisional Diagnosis'
  end
  object txtAttn: TORComboBox [18]
    Left = 362
    Top = 22
    Width = 197
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
    OnChange = ControlChange
    OnNeedData = txtAttnNeedData
    CharsNeedMatch = 1
    ExplicitWidth = 195
  end
  object cboProc: TORComboBox [19]
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
    OnChange = cboProcSelect
    OnNeedData = cboProcNeedData
    CharsNeedMatch = 1
  end
  object cboCategory: TORComboBox [20]
    Left = 505
    Top = -11
    Width = 2
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
    TabOrder = 15
    Visible = False
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object cboService: TORComboBox [21]
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
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object memComment: TRichEdit [22]
    Left = 106
    Top = 123
    Width = 451
    Height = 38
    Anchors = [akLeft, akTop, akRight]
    PopupMenu = popReason
    TabOrder = 11
    WantTabs = True
    OnChange = ControlChange
    OnKeyUp = memCommentKeyUp
  end
  object pnlMessage: TPanel [23]
    Left = 19
    Top = 276
    Width = 383
    Height = 44
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Caption = 'pnlMessage'
    TabOrder = 16
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
      Font.Charset = DEFAULT_CHARSET
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
  object btnCmtCancel: TButton [24]
    Left = 11
    Top = 116
    Width = 75
    Height = 21
    Caption = 'Cancellation'
    TabOrder = 9
    OnClick = btnCmtCancelClick
  end
  object btnCmtOther: TButton [25]
    Left = 11
    Top = 139
    Width = 75
    Height = 21
    Caption = 'Other'
    TabOrder = 10
    OnClick = btnCmtOtherClick
  end
  object cmdLexSearch: TButton [26]
    Left = 509
    Top = 94
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Lexicon'
    TabOrder = 8
    OnClick = cmdLexSearchClick
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
        'Component = lblInpOutp'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
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
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
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
        'Component = frmEditProc'
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
