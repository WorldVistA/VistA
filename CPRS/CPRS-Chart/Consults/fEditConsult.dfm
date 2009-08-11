inherited frmEditCslt: TfrmEditCslt
  Tag = 110
  Left = 409
  Top = 225
  Width = 599
  Height = 375
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 340
  Caption = 'Edit/Resubmit a Cancelled Consult'
  Constraints.MinHeight = 371
  Constraints.MinWidth = 573
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitLeft = 409
  ExplicitTop = 225
  ExplicitWidth = 599
  ExplicitHeight = 375
  DesignSize = (
    591
    341)
  PixelsPerInch = 96
  TextHeight = 13
  object lblService: TLabel [0]
    Left = 4
    Top = 4
    Width = 134
    Height = 13
    Caption = 'Consult to Service/Specialty'
  end
  object lblReason: TLabel [1]
    Left = 4
    Top = 166
    Width = 90
    Height = 13
    Caption = 'Reason for Consult'
  end
  object lblComment: TLabel [2]
    Left = 4
    Top = 105
    Width = 77
    Height = 13
    Caption = 'New Comments:'
  end
  object lblComments: TLabel [3]
    Left = 4
    Top = 51
    Width = 89
    Height = 13
    Caption = 'Display Comments:'
  end
  object lblUrgency: TStaticText [4]
    Left = 196
    Top = 4
    Width = 44
    Height = 17
    Caption = 'Urgency'
    TabOrder = 16
  end
  object lblPlace: TStaticText [5]
    Left = 376
    Top = 41
    Width = 104
    Height = 17
    Caption = 'Place of Consultation'
    TabOrder = 17
  end
  object lblAttn: TStaticText [6]
    Left = 376
    Top = 4
    Width = 46
    Height = 17
    Caption = 'Attention'
    TabOrder = 18
  end
  object lblProvDiag: TStaticText [7]
    Left = 195
    Top = 82
    Width = 104
    Height = 17
    Caption = 'Provisional Diagnosis'
    TabOrder = 19
  end
  object lblInpOutp: TStaticText [8]
    Left = 197
    Top = 47
    Width = 127
    Height = 17
    Caption = 'Patient will be seen as an:'
    TabOrder = 20
  end
  object memReason: TRichEdit [9]
    Left = 4
    Top = 179
    Width = 589
    Height = 137
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = popReason
    ScrollBars = ssBoth
    TabOrder = 11
    WantTabs = True
    OnChange = ControlChange
    OnExit = memReasonExit
    OnKeyDown = memCommentKeyDown
    OnKeyPress = memCommentKeyPress
    OnKeyUp = memCommentKeyUp
    ExplicitHeight = 136
  end
  object pnlMessage: TPanel [10]
    Left = 16
    Top = 294
    Width = 418
    Height = 44
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Caption = 'pnlMessage'
    TabOrder = 15
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
  object cboService: TORComboBox [11]
    Left = 4
    Top = 19
    Width = 180
    Height = 21
    Style = orcsDropDown
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
    CharsNeedMatch = 1
  end
  object cboUrgency: TORComboBox [12]
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
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object radInpatient: TRadioButton [13]
    Left = 197
    Top = 61
    Width = 61
    Height = 17
    Caption = '&Inpatient'
    TabOrder = 5
    OnClick = radInpatientClick
  end
  object radOutpatient: TRadioButton [14]
    Left = 269
    Top = 61
    Width = 73
    Height = 17
    Caption = '&Outpatient'
    TabOrder = 6
    OnClick = radOutpatientClick
  end
  object cboPlace: TORComboBox [15]
    Left = 376
    Top = 54
    Width = 216
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
    TabOrder = 7
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object txtProvDiag: TCaptionEdit [16]
    Left = 195
    Top = 95
    Width = 346
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 180
    ParentShowHint = False
    PopupMenu = mnuPopProvDx
    ShowHint = True
    TabOrder = 8
    OnChange = ControlChange
    Caption = 'Provisional Diagnosis'
  end
  object txtAttn: TORComboBox [17]
    Left = 376
    Top = 19
    Width = 218
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
    OnChange = ControlChange
    OnNeedData = txtAttnNeedData
    CharsNeedMatch = 1
  end
  object cboCategory: TORComboBox [18]
    Left = 561
    Top = 103
    Width = 10
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
    TabOrder = 14
    Visible = False
    CharsNeedMatch = 1
  end
  object cmdAccept: TButton [19]
    Left = 437
    Top = 319
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Resubmit'
    TabOrder = 12
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [20]
    Left = 514
    Top = 319
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 13
    OnClick = cmdQuitClick
  end
  object memComment: TRichEdit [21]
    Left = 4
    Top = 121
    Width = 587
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    PopupMenu = popReason
    TabOrder = 10
    WantTabs = True
    OnChange = ControlChange
    OnKeyDown = memCommentKeyDown
    OnKeyPress = memCommentKeyPress
    OnKeyUp = memCommentKeyUp
  end
  object btnCmtCancel: TButton [22]
    Left = 110
    Top = 49
    Width = 75
    Height = 21
    Caption = 'Cancellation'
    TabOrder = 3
    OnClick = btnCmtCancelClick
  end
  object btnCmtOther: TButton [23]
    Left = 110
    Top = 75
    Width = 75
    Height = 21
    Caption = 'Other'
    TabOrder = 4
    OnClick = btnCmtOtherClick
  end
  object cmdLexSearch: TButton [24]
    Left = 545
    Top = 95
    Width = 46
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Lexicon'
    TabOrder = 9
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
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
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
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
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
        'Component = frmEditCslt'
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
