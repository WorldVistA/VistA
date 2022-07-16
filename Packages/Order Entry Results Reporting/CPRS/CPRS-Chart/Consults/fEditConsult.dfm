inherited frmEditCslt: TfrmEditCslt
  Tag = 110
  Left = 461
  Top = 191
  Width = 576
  Height = 467
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 340
  Anchors = [akLeft, akTop, akBottom]
  Caption = 'Edit/Resubmit a Cancelled Consult'
  Constraints.MinHeight = 467
  Constraints.MinWidth = 576
  Position = poScreenCenter
  ExplicitWidth = 576
  ExplicitHeight = 467
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
    Left = 0
    Top = 314
    Width = 561
    Height = 79
    Align = alBottom
    Caption = 'pnlMessage'
    ShowCaption = False
    TabOrder = 2
    Visible = False
    object imgMessage: TImage
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 32
      Height = 71
      Align = alLeft
      ExplicitHeight = 32
    end
    object memMessage: TRichEdit
      Left = 39
      Top = 1
      Width = 521
      Height = 77
      Align = alClient
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
      Zoom = 100
    end
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 25
    Width = 561
    Height = 175
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    DesignSize = (
      561
      175)
    object lblService: TLabel
      Left = 4
      Top = 4
      Width = 134
      Height = 13
      Caption = 'Consult to Service/Specialty'
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
      TabOrder = 12
    end
    object lblAttn: TStaticText
      Left = 376
      Top = 4
      Width = 46
      Height = 17
      Caption = 'Attention'
      TabOrder = 13
    end
    object lblProvDiag: TStaticText
      Left = 195
      Top = 134
      Width = 104
      Height = 17
      Caption = 'Provisional Diagnosis'
      TabOrder = 14
    end
    object lblInpOutp: TStaticText
      Left = 197
      Top = 99
      Width = 127
      Height = 17
      Caption = 'Patient will be seen as an:'
      TabOrder = 15
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
      Width = 323
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
      Width = 451
      Height = 19
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
      Width = 323
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
      Left = 543
      Top = 106
      Width = 157
      Height = 21
      Anchors = [akLeft, akTop, akRight]
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
      TabOrder = 11
      Text = ''
      Visible = False
      CharsNeedMatch = 1
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
      Left = 650
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
      TabOrder = 16
    end
    object calClinicallyIndicated: TORDateBox
      Left = 197
      Top = 62
      Width = 164
      Height = 19
      TabOrder = 3
      OnChange = ControlChange
      OnExit = calClinicallyIndicatedExit
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object lblLatest: TStaticText
      Left = 376
      Top = 46
      Width = 92
      Height = 17
      Caption = 'No later than date:'
      Enabled = False
      TabOrder = 18
      Visible = False
    end
    object calLatest: TORDateBox
      Left = 378
      Top = 62
      Width = 323
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 19
      Visible = False
      OnChange = ControlChange
      OnExit = calLatestExit
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object lblPlace: TStaticText
      Left = 376
      Top = 89
      Width = 104
      Height = 17
      Caption = 'Place of Consultation'
      TabOrder = 22
    end
  end
  object pnlButtons: TPanel [3]
    Left = 0
    Top = 393
    Width = 561
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnlButtons'
    ShowCaption = False
    TabOrder = 3
    object cmdQuit: TButton
      AlignWithMargins = True
      Left = 486
      Top = 3
      Width = 72
      Height = 29
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdQuitClick
    end
    object cmdAccept: TButton
      AlignWithMargins = True
      Left = 408
      Top = 3
      Width = 72
      Height = 29
      Align = alRight
      Caption = 'Resubmit'
      TabOrder = 1
      OnClick = cmdAcceptClick
    end
    object btnLaunchToolbox: TButton
      Left = 4
      Top = 6
      Width = 125
      Height = 25
      Caption = 'Open Consult Toolbox'
      TabOrder = 0
      OnClick = btnLaunchToolboxClick
    end
  end
  object pnlDetails: TPanel [4]
    Left = 0
    Top = 200
    Width = 561
    Height = 114
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlDetails'
    ShowCaption = False
    TabOrder = 4
    object splDetails: TSplitter
      Left = 0
      Top = 81
      Width = 561
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      ExplicitLeft = -1
      ExplicitTop = 71
      ExplicitWidth = 728
    end
    object pnlComments: TPanel
      Left = 0
      Top = 0
      Width = 561
      Height = 81
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlComments'
      ShowCaption = False
      TabOrder = 0
      object lblComment: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 555
        Height = 13
        Align = alTop
        Caption = 'New Comments:'
        ExplicitWidth = 77
      end
      object memComment: TRichEdit
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 555
        Height = 56
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PopupMenu = popReason
        ScrollBars = ssVertical
        TabOrder = 0
        WantTabs = True
        Zoom = 100
        OnChange = ControlChange
        OnExit = memCommentExit
        OnKeyDown = memCommentKeyDown
        OnKeyUp = memCommentKeyUp
      end
    end
    object pnlReason: TPanel
      Left = 0
      Top = 84
      Width = 561
      Height = 30
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlComments'
      ShowCaption = False
      TabOrder = 1
      object lblReason: TLabel
        Left = 0
        Top = 0
        Width = 561
        Height = 13
        Align = alTop
        Caption = 'Reason for Request'
        ExplicitWidth = 95
      end
      object memReason: TRichEdit
        AlignWithMargins = True
        Left = 3
        Top = 16
        Width = 555
        Height = 11
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = popReason
        ScrollBars = ssVertical
        TabOrder = 0
        WantTabs = True
        Zoom = 100
        OnChange = ControlChange
        OnExit = memReasonExit
        OnKeyDown = memCommentKeyDown
        OnKeyUp = memCommentKeyUp
      end
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
        'Status = stsDefault')
      (
        'Component = lblPlace'
        'Status = stsDefault')
      (
        'Component = pnlDetails'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = btnLaunchToolbox'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 449
    Top = 137
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 491
    Top = 265
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
