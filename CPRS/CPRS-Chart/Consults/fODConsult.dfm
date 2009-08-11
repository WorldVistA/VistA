inherited frmODCslt: TfrmODCslt
  Tag = 110
  Left = 430
  Top = 203
  Width = 606
  Height = 376
  HorzScrollBar.Range = 590
  VertScrollBar.Range = 340
  Caption = 'Order a Consult'
  Constraints.MinHeight = 376
  Constraints.MinWidth = 606
  Font.Charset = ANSI_CHARSET
  ExplicitWidth = 606
  ExplicitHeight = 376
  PixelsPerInch = 96
  TextHeight = 13
  object lblService: TLabel [0]
    Left = 1
    Top = 2
    Width = 134
    Height = 13
    Caption = 'Consult to Service/Specialty'
  end
  object lblProvDiag: TLabel [1]
    Left = 309
    Top = 81
    Width = 100
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Provisional Diagnosis'
  end
  object lblUrgency: TLabel [2]
    Left = 309
    Top = 2
    Width = 40
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Urgency'
  end
  object lblPlace: TLabel [3]
    Left = 454
    Top = 43
    Width = 100
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Place of Consultation'
  end
  object lblAttn: TLabel [4]
    Left = 454
    Top = 2
    Width = 42
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Attention'
  end
  object pnlReason: TPanel [5]
    Left = 3
    Top = 128
    Width = 585
    Height = 161
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 10
    object lblReason: TLabel
      Left = 0
      Top = 0
      Width = 585
      Height = 13
      Align = alTop
      Caption = 'Reason for Request'
      ExplicitWidth = 95
    end
    object memReason: TRichEdit
      Left = 0
      Top = 13
      Width = 585
      Height = 148
      Align = alClient
      Font.Charset = ANSI_CHARSET
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
    end
  end
  inherited memOrder: TCaptionMemo
    Left = 3
    Top = 305
    Width = 417
    Height = 41
    TabStop = True
    Anchors = [akLeft, akBottom]
    Lines.Strings = (
      'The order text...'
      '----------------------------------------------'
      '--------------------------------'
      'An order message may be displayed here.')
    TabOrder = 11
    ExplicitLeft = 3
    ExplicitTop = 305
    ExplicitWidth = 417
    ExplicitHeight = 41
  end
  object cboService: TORComboBox [7]
    Left = 0
    Top = 16
    Width = 274
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Consult to Service/Specialty'
    Color = clWindow
    DropDownCount = 12
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
    TabStop = True
    OnChange = ControlChange
    OnClick = cboServiceSelect
    OnExit = cboServiceExit
    OnKeyDown = cboServiceKeyDown
    OnKeyUp = cboServiceKeyUp
    CharsNeedMatch = 1
  end
  object cboUrgency: TORComboBox [8]
    Left = 309
    Top = 16
    Width = 133
    Height = 21
    Anchors = [akTop, akRight]
    Style = orcsDropDown
    AutoSelect = True
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
    TabStop = True
    OnChange = ControlChange
    CharsNeedMatch = 1
  end
  object cboPlace: TORComboBox [9]
    Left = 454
    Top = 56
    Width = 136
    Height = 21
    Anchors = [akTop, akRight]
    Style = orcsDropDown
    AutoSelect = True
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
  object txtProvDiag: TCaptionEdit [10]
    Left = 309
    Top = 94
    Width = 231
    Height = 21
    Anchors = [akTop, akRight]
    MaxLength = 180
    ParentShowHint = False
    PopupMenu = mnuPopProvDx
    ShowHint = True
    TabOrder = 8
    OnChange = txtProvDiagChange
  end
  object txtAttn: TORComboBox [11]
    Left = 454
    Top = 16
    Width = 136
    Height = 21
    Anchors = [akTop, akRight]
    Style = orcsDropDown
    AutoSelect = True
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
  object treService: TORTreeView [12]
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
    TabOrder = 2
    Visible = False
    OnChange = treServiceChange
    OnCollapsing = treServiceCollapsing
    OnEnter = treServiceEnter
    OnExit = treServiceExit
    OnKeyDown = treServiceKeyDown
    OnKeyUp = treServiceKeyUp
    OnMouseDown = treServiceMouseDown
    NodePiece = 0
  end
  object cboCategory: TORComboBox [13]
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
    TabOrder = 15
    Visible = False
    CharsNeedMatch = 1
  end
  object pnlServiceTreeButton: TKeyClickPanel [14]
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
    TabOrder = 1
    TabStop = True
    OnClick = btnServiceTreeClick
    OnEnter = pnlServiceTreeButtonEnter
    OnExit = pnlServiceTreeButtonExit
    object btnServiceTree: TSpeedButton
      Left = 2
      Top = 2
      Width = 22
      Height = 22
      Hint = 'View services/specialties hierarchically'
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
      ParentShowHint = False
      ShowHint = True
      OnClick = btnServiceTreeClick
    end
  end
  object cmdLexSearch: TButton [15]
    Left = 543
    Top = 94
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Lexicon'
    TabOrder = 9
    OnClick = cmdLexSearchClick
  end
  object gbInptOpt: TGroupBox [16]
    Left = 309
    Top = 35
    Width = 140
    Height = 45
    Anchors = [akTop, akRight]
    Caption = 'Patient will be seen as an:'
    TabOrder = 5
    object radInpatient: TRadioButton
      Left = 3
      Top = 20
      Width = 61
      Height = 13
      Caption = '&Inpatient'
      TabOrder = 0
      OnClick = radInpatientClick
    end
    object radOutpatient: TRadioButton
      Left = 67
      Top = 20
      Width = 70
      Height = 13
      Caption = '&Outpatient'
      TabOrder = 1
      OnClick = radOutpatientClick
    end
  end
  object btnDiagnosis: TButton [17]
    Left = 543
    Top = 95
    Width = 49
    Height = 20
    Anchors = [akTop, akRight]
    Caption = 'Diagnosis'
    TabOrder = 7
    OnClick = btnDiagnosisClick
  end
  inherited cmdAccept: TButton
    Left = 439
    Top = 315
    Anchors = [akLeft, akBottom]
    TabOrder = 12
    ExplicitLeft = 439
    ExplicitTop = 315
  end
  inherited cmdQuit: TButton
    Left = 531
    Top = 315
    Width = 61
    Anchors = [akLeft, akBottom]
    TabOrder = 13
    ExplicitLeft = 531
    ExplicitTop = 315
    ExplicitWidth = 61
  end
  inherited pnlMessage: TPanel
    Left = 13
    Top = 295
    Width = 377
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 14
    ExplicitLeft = 13
    ExplicitTop = 295
    ExplicitWidth = 377
    inherited memMessage: TRichEdit
      Width = 292
      ExplicitWidth = 292
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Label = lblReason'
        'Status = stsOK')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Label = lblUrgency'
        'Status = stsOK')
      (
        'Component = cboPlace'
        'Label = lblPlace'
        'Status = stsOK')
      (
        'Component = txtProvDiag'
        'Label = lblProvDiag'
        'Status = stsOK')
      (
        'Component = txtAttn'
        'Label = lblAttn'
        'Status = stsOK')
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
        'Component = btnDiagnosis'
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
        'Component = frmODCslt'
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
    Top = 188
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
